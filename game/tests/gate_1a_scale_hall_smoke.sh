#!/usr/bin/env bash
# Riftwrought — First-MVP Gate 1A smoke checks: the Scale Calibration Hall.
#
# Gate 1A is the first authorized first-MVP implementation step (D-195). It
# builds one temporary developer-only Scale Calibration Hall so the project owner
# can judge whether the accepted Prototype Zero player, camera, movement, KayKit
# architecture, combat lanes, ranged sightlines, telegraph clearances, and
# occluders read at the scale of a broad ARPG rather than an enlarged one-room
# prototype.
#
# THE LOCKED PROTOTYPE ZERO CHAIN RUNS FIRST AND STOPS EVERYTHING ON ANY
# REGRESSION (specification §9). `gate_f_smoke.sh` reruns Gate E, which reruns
# Gate D, which reruns Gate C, which reruns Gate B, which reruns Gate A — so an
# asset, rig, locomotion, combat-kernel, encounter, progression, feedback, or
# storage regression is caught before a single Gate 1A result is trusted. Gate 1A
# extracted the shared locomotion, cursor-to-navigation, and click-and-hold
# components out of that accepted code, and this ordering is what proves the
# extraction preserved Prototype Zero bit for bit.
#
# IT NEVER TOUCHES THE PROJECT OWNER'S OWN SAVED STATE. The hall writes no save
# or settings file at all — it has no store, no ConfigFile, and no user:// path,
# asserted from inside the engine. This script additionally fingerprints the two
# real files before and after the whole run, and uses the established D-192
# non-writing path-resolution guard to prove the guard still refuses the
# production directory. Gate F's own suite runs its destructive half inside a
# `mktemp -d` directory, exactly as before.
#
# Automated checks cannot certify scale. Gate 1A remains OPEN after this script
# passes: only the project owner's mouse-and-controller playtest can accept the
# candidate scale, choose measured replacements, or ask for another pass. See
#   docs/testing/FIRST_MVP_GATE_1A_SCALE_CALIBRATION_HALL_REPORT.md
#
# Usage, from the repository root:
#   game/tests/gate_1a_scale_hall_smoke.sh [--shots <dir>]
#
# --shots additionally renders the Gate 1A evidence at 1920 x 1080 and a reduced
# set at the 1280 x 720 minimum tested window.

set -uo pipefail

GODOT="${GODOT:-/Applications/Godot.app/Contents/MacOS/Godot}"
EXPECTED_VERSION="4.7.2.stable"
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
HALL_SCENE="res://scenes/first_mvp/calibration/scale_calibration_hall.tscn"
APP_SCENE="res://scenes/app/prototype_app.tscn"
ROOM_SCENE="res://scenes/prototype_zero/prototype_zero.tscn"

# Where the project owner's real files live, derived from the project name Godot
# itself uses for the user data directory — the same derivation gate_f_smoke.sh
# makes, and cross-checked against the path the engine prints in step 1.
project_name="$(sed -n 's/^config\/name="\(.*\)"[[:space:]]*$/\1/p' "$PROJECT_DIR/project.godot" | head -1)"
production_dir="$HOME/Library/Application Support/Godot/app_userdata/$project_name"
production_settings="$production_dir/prototype_settings.cfg"
production_lab="$production_dir/prototype_zero.cfg"

state_fingerprint() {
	# "absent" is a legitimate answer: the claim is that the run changes nothing,
	# not that a file has to exist.
	if [[ -f "$1" ]]; then
		printf '%s bytes, sha256 %s' \
			"$(wc -c < "$1" | tr -d ' ')" "$(shasum -a 256 "$1" | awk '{print $1}')"
	else
		printf 'absent'
	fi
}

production_settings_before="$(state_fingerprint "$production_settings")"
production_lab_before="$(state_fingerprint "$production_lab")"

shots_dir=""
if [[ "${1:-}" == "--shots" ]]; then
	shots_dir="${2:?--shots requires a directory}"
	mkdir -p "$shots_dir"
	shots_dir="$(cd "$shots_dir" && pwd)"
fi

failures=0

step() {
	printf '\n=== %s\n' "$1"
}

# A PASSING VERIFICATION RUN THAT ALSO PRINTED A SCRIPT ERROR IS NOT A PASS
# (D-200). A GDScript runtime error inside a check function aborts that function
# and every later assertion in it, while the verifier's own counter — which only
# counts assertions that were reached — still prints a green PASS. That shape was
# live here until D-200/D-201: `_check_prototype_zero_is_untouched()` read two property
# names that do not exist, `float(null)` threw, and six of its seven assertions
# never ran behind `GATE 1A VERIFICATION: PASS (278 checks)`. The suite could not
# see it, because it only ever grepped for the word PASS.
#
# So every verification run this script makes is now checked for `SCRIPT ERROR`
# as well, and a hit fails the suite regardless of what else the log says. This is
# the rule `gate_1b_exterior_asset_spike_smoke.sh` introduced for itself under
# D-199, and stricter in one respect: that script checks only its headless run,
# while this one covers the headless run and both rendered `--shots` runs.
#
# Two honest limits. It asserts the ABSENCE of a string, not that the run produced
# output, so an empty log passes it — the `GATE 1A VERIFICATION: PASS` grep right
# after each call is what catches that. And it covers this script's OWN
# verification runs; a script error inside the chained Gate F/E/D/C/B verifications
# is still invisible here.
assert_no_script_error() {
	local label="$1" logfile="$2"
	if grep -qE "SCRIPT ERROR" "$logfile"; then
		printf '  FAIL  the %s printed a script error, so assertions were skipped behind a PASS\n' "$label"
		grep -E "SCRIPT ERROR" "$logfile" | head -5 | sed 's/^/        /'
		failures=$((failures + 1))
	else
		printf '  PASS  the %s ran end to end with no script error, so no check was skipped\n' "$label"
	fi
}

# NOTE on the pattern below, carried from gate_f_smoke.sh. Godot's output is
# written to a log FIRST and the log is then grepped, rather than piping Godot
# through `tee ... | grep -q`. With `set -o pipefail`, `grep -q` exits the moment
# it matches and `tee` can then die on EPIPE, failing the pipeline even though the
# verification passed. That race reported a regression that had not happened.

step "0. Engine baseline"
version="$("$GODOT" --version 2>/dev/null | tr -d '\r')"
printf '  installed: %s\n' "$version"
if [[ "$version" == "$EXPECTED_VERSION"* ]]; then
	printf '  PASS  matches the locked %s baseline\n' "$EXPECTED_VERSION"
else
	printf '  FAIL  expected %s, found %s\n' "$EXPECTED_VERSION" "$version"
	failures=$((failures + 1))
fi

printf '  production settings before: %s\n' "$production_settings_before"
printf '  production lab state before: %s\n' "$production_lab_before"

step "1. The complete locked Prototype Zero chain (Gate F -> E -> D -> C -> B -> A)"
# This is the regression authority. Gate 1A extracted shared movement components
# out of Prototype Zero's accepted code; if any of it moved, this fails here and
# nothing below is trusted.
if "$PROJECT_DIR/tests/gate_f_smoke.sh" > /tmp/riftwrought_gate_f_from_1a.log 2>&1; then
	printf '  PASS  gate_f_smoke.sh still passes after the Gate 1A extraction\n'
	grep -ohE "GATE [A-F] VERIFICATION: PASS \([0-9]+ checks\)" \
		/tmp/riftwrought_gate_f_from_1a.log | sort -u | sed 's/^/        /' || true
	# Gate F's own count lands in the verification log rather than on the smoke
	# script's stdout, so it is read from there — otherwise the chain summary here
	# would silently stop at Gate E.
	grep -ohE "GATE F VERIFICATION: PASS \([0-9]+ checks\)" /tmp/riftwrought_gate_f_verify.log \
		2>/dev/null | sort -u | sed 's/^/        /' || true
	grep -E "^GATE F SMOKE CHECKS" /tmp/riftwrought_gate_f_from_1a.log \
		| sed 's/^/        /' || true
else
	printf '  FAIL  gate_f_smoke.sh failed; Gate 1A results are not trusted\n'
	tail -40 /tmp/riftwrought_gate_f_from_1a.log | sed 's/^/        /'
	failures=$((failures + 1))
fi

step "2. The Prototype Zero entrypoint and laboratory still start on their own"
# Specification §9.3: the persistent main scene is unchanged and separately
# starts. Gate 1A is a SEPARATE runnable scene and must not have taken over.
main_scene="$(sed -n 's/^run\/main_scene="\(.*\)"[[:space:]]*$/\1/p' "$PROJECT_DIR/project.godot" | head -1)"
printf '  project main scene: %s\n' "$main_scene"
if [[ "$main_scene" == "$APP_SCENE" ]]; then
	printf '  PASS  the Prototype App is still the project entrypoint\n'
else
	printf '  FAIL  the main scene is %s, not %s\n' "$main_scene" "$APP_SCENE"
	failures=$((failures + 1))
fi

if "$GODOT" --headless --path "$PROJECT_DIR" "$APP_SCENE" --quit-after 60 \
	> /tmp/riftwrought_gate_1a_app.log 2>&1; then
	printf '  PASS  the Prototype App boots to its title screen and exits cleanly\n'
else
	printf '  FAIL  the Prototype App no longer starts\n'
	tail -20 /tmp/riftwrought_gate_1a_app.log | sed 's/^/        /'
	failures=$((failures + 1))
fi

if "$GODOT" --headless --path "$PROJECT_DIR" "$ROOM_SCENE" --quit-after 90 \
	> /tmp/riftwrought_gate_1a_room.log 2>&1; then
	printf '  PASS  the Prototype Zero laboratory still starts standalone\n'
else
	printf '  FAIL  the Prototype Zero laboratory no longer starts standalone\n'
	tail -20 /tmp/riftwrought_gate_1a_room.log | sed 's/^/        /'
	failures=$((failures + 1))
fi

step "3. The hall imports, parses, and starts headlessly"
if "$GODOT" --headless --path "$PROJECT_DIR" --import \
	> /tmp/riftwrought_gate_1a_import.log 2>&1; then
	printf '  PASS  the project imports with the Gate 1A scene, scripts, and data present\n'
else
	printf '  FAIL  import failed\n'
	tail -20 /tmp/riftwrought_gate_1a_import.log | sed 's/^/        /'
	failures=$((failures + 1))
fi

if "$GODOT" --headless --path "$PROJECT_DIR" "$HALL_SCENE" --quit-after 120 \
	> /tmp/riftwrought_gate_1a_boot.log 2>&1; then
	printf '  PASS  the Scale Calibration Hall builds, bakes, and exits cleanly\n'
	grep -E "\[gate-1a\] (clear floor|gate measured|lane measured|navigation baked)" \
		/tmp/riftwrought_gate_1a_boot.log | sed 's/^/        /' || true
else
	printf '  FAIL  the Scale Calibration Hall does not start\n'
	tail -30 /tmp/riftwrought_gate_1a_boot.log | sed 's/^/        /'
	failures=$((failures + 1))
fi

# Every Gate 1A script must parse cleanly on its own, so a syntax error in a file
# the hall happens not to reach at runtime cannot hide here.
# `--check-only` reports a parse failure in its OUTPUT and still exits zero, so
# the exit status is not the test — the log is.
for script in "$PROJECT_DIR"/scripts/first_mvp/calibration/*.gd \
	"$PROJECT_DIR"/scripts/movement/*.gd; do
	rel="${script#"$PROJECT_DIR"/}"
	"$GODOT" --headless --path "$PROJECT_DIR" --check-only --script "res://$rel" \
		> /tmp/riftwrought_gate_1a_parse.log 2>&1
	if grep -qE "Parse Error|Compile Error|Failed to load script" /tmp/riftwrought_gate_1a_parse.log; then
		printf '  FAIL  %s does not parse\n' "$rel"
		tail -10 /tmp/riftwrought_gate_1a_parse.log | sed 's/^/        /'
		failures=$((failures + 1))
	else
		printf '  PASS  %s\n' "$rel"
	fi
done

step "4. Gate 1A hall verification (headless)"
if "$GODOT" --headless --path "$PROJECT_DIR" "$HALL_SCENE" -- --verify-1a \
	> /tmp/riftwrought_gate_1a_verify.log 2>&1; then
	:
fi
assert_no_script_error "headless Gate 1A verification" /tmp/riftwrought_gate_1a_verify.log
if grep -q "GATE 1A VERIFICATION: PASS" /tmp/riftwrought_gate_1a_verify.log; then
	grep -E "^  (world unit|clear usable floor|§4.1 target|full floor|player collision|camera |CF at|hall in CF|movement |navigation )" \
		/tmp/riftwrought_gate_1a_verify.log | sed 's/^/      /' || true
	grep -E "^  (stress gate|ordinary connector|broad connector|major gate|close ordinary lane|broad formation lane) " \
		/tmp/riftwrought_gate_1a_verify.log | sed 's/^/      /' || true
	grep -E "GATE 1A VERIFICATION: PASS" /tmp/riftwrought_gate_1a_verify.log | sed 's/^/  /'
	printf '  PASS  measured footprint, gates, lanes, ranged marks, telegraph and hazard\n'
	printf '        clearances, navigation coverage, click resolution, gate and lane\n'
	printf '        traversal, wall collision, the accepted locomotion contract, fixture\n'
	printf '        inertness, runtime-calibration reset, scope, and on-screen surfaces\n'
else
	printf '  FAIL  the Gate 1A verification did not pass\n'
	grep -E "FAIL:|VERIFICATION" /tmp/riftwrought_gate_1a_verify.log | sed 's/^/        /' || true
	tail -20 /tmp/riftwrought_gate_1a_verify.log | sed 's/^/        /'
	failures=$((failures + 1))
fi

step "5. The hall writes no state, and the storage guard still refuses production"
# The hall has no store at all, so the strongest available proof is that the two
# production files are untouched by a full hall run and that the D-192 guard —
# which is what protects them everywhere else — still answers correctly on its
# NON-WRITING startup path.
settings_mid="$(state_fingerprint "$production_settings")"
lab_mid="$(state_fingerprint "$production_lab")"
if [[ "$settings_mid" == "$production_settings_before" && "$lab_mid" == "$production_lab_before" ]]; then
	printf '  PASS  the production files are unchanged after every Gate 1A run above\n'
else
	printf '  FAIL  a Gate 1A run changed the project owner'"'"'s own files\n'
	printf '        settings before %s\n        settings after  %s\n' \
		"$production_settings_before" "$settings_mid"
	printf '        lab before      %s\n        lab after       %s\n' \
		"$production_lab_before" "$lab_mid"
	failures=$((failures + 1))
fi

if "$GODOT" --headless --path "$PROJECT_DIR" -- --check-state-dir --state-dir "$production_dir" \
	> /tmp/riftwrought_gate_1a_guard.log 2>&1; then
	printf '  FAIL  the storage guard accepted the production directory\n'
	failures=$((failures + 1))
else
	if grep -qE "refusing to start|own user data directory" /tmp/riftwrought_gate_1a_guard.log; then
		printf '  PASS  the D-192 guard still refuses the production directory, without writing\n'
	else
		printf '  FAIL  the storage guard did not report a refusal\n'
		tail -10 /tmp/riftwrought_gate_1a_guard.log | sed 's/^/        /'
		failures=$((failures + 1))
	fi
fi

# No SHIPPING Gate 1A file may name a user:// path or a config store at all.
# `gate_1a_verification.gd` is excluded BY NAME and for a stated reason: it holds
# the literal strings `user://`, `ConfigFile`, `FileAccess.open`, and
# `ResourceSaver` precisely because it is the code that FORBIDS them, and a scan
# that cannot tell the promise from the breach is worthless. It is checked
# separately, immediately below, for whether it actually calls any of them.
leaks="$(grep -rlE 'user://|ConfigFile|ResourceSaver' \
	"$PROJECT_DIR/scripts/first_mvp" "$PROJECT_DIR/scenes/first_mvp" \
	"$PROJECT_DIR/data/first_mvp" 2>/dev/null \
	| grep -v 'gate_1a_verification.gd' | wc -l | tr -d ' ')"
printf '  shipping Gate 1A files naming a user:// path, ConfigFile, or ResourceSaver: %s\n' "$leaks"
if [[ "$leaks" == "0" ]]; then
	printf '  PASS  the hall has no storage of any kind\n'
else
	printf '  FAIL  a Gate 1A file reaches persistent storage\n'
	grep -rlE 'user://|ConfigFile|ResourceSaver' \
		"$PROJECT_DIR/scripts/first_mvp" "$PROJECT_DIR/scenes/first_mvp" \
		"$PROJECT_DIR/data/first_mvp" 2>/dev/null \
		| grep -v 'gate_1a_verification.gd' | sed 's/^/        /'
	failures=$((failures + 1))
fi

# And the verification itself never CALLS any of them. It reads source with
# FileAccess.get_file_as_string and writes PNGs only into the --shots directory.
verify_calls="$(grep -cE 'ConfigFile\.new|ResourceSaver\.save|FileAccess\.open\(' \
	"$PROJECT_DIR/scripts/first_mvp/calibration/gate_1a_verification.gd" | tr -d ' ')"
printf '  storage calls in the Gate 1A verification itself: %s\n' "$verify_calls"
if [[ "$verify_calls" == "0" ]]; then
	printf '  PASS  the verification names those strings only in order to forbid them\n'
else
	printf '  FAIL  the Gate 1A verification opens persistent storage\n'
	failures=$((failures + 1))
fi

step "6. No asset was downloaded or added FOR GATE 1A"
# D-195 and specification §2: registered KayKit geometry only, no new third-party
# asset and no external download. The three dungeon pieces Gate A imported are the
# only third-party files the hall loads, and nothing new appeared beside them.
#
# TWO ASSERTIONS IN THIS STEP MOVED FORWARD BY AUTHORIZATION, one for one, and
# the arithmetic is stated because the Gate 1A specification §9 requires it.
# D-198 authorizes the first-MVP Gate 1B Exterior Asset Compatibility Spike to
# extract an exact 35-file candidate manifest, so "the inventory is 27" and "the
# only asset path any first-MVP file names is one of three dungeon pieces" are
# now false BY AUTHORIZATION rather than by regression. Both are replaced with
# the same statement about the new boundary, and NO Gate 1A verification
# assertion moved for that reason: at D-199 `gate_1a_verification.gd` was
# untouched and still 278 checks.
#
# THE SAME TWO MOVED AGAIN, ONE FOR ONE, UNDER D-202. The Exterior Cohesion
# Comparison is authorized to extract exactly 21 more models and four more
# verbatim archive licences and to add two project-authored source maps, so the
# inventory statement moves 62 -> 89 and the allowlist is extended to that
# manifest. THE INVENTORY STATEMENT MOVED ONCE MORE UNDER D-204, 89 -> 91, for the
# two Kenney colour atlases the 2025 kits declare — two files, no new licence, no
# new source map, and no allowlist change, because the allowlist already matches
# `kenney/fantasy_town/` and `kenney/graveyard/` by prefix. Specification §2 of the comparison brief permits exactly this and no
# more: "update exact third-party inventory assertions and path allowlists only
# as required by this manifest, with scene-specific checks proving the old Gate 1A
# hall and first Gate 1B spike did not begin using the new candidates". The
# hall-only scan further down is that proof for Gate 1A and is UNCHANGED; the
# equivalent proof for the first Gate 1B spike lives in its own runner. Again NO
# Gate 1A verification assertion moved and `gate_1a_verification.gd` was not
# touched: Gate 1A is still 284 checks.
#
# The verification is 284 checks now, and it moved for a DIFFERENT and separately
# authorized reason. D-200 authorized and D-201 delivered the repair of two wrong
# property names in `_check_prototype_zero_is_untouched()`, which had been throwing
# and aborting the function after its first assertion; the six rows that were being
# skipped now run.
# 278 + 6 = 284. No assertion was added, no asserted value moved, and this step's
# asset arithmetic above is unaffected.
#
#   27 registered Gate A files
# + 11 Forest payloads + 1 verbatim Forest licence
# + 17 Halloween payloads + 1 verbatim Halloween licence
# +  5 k0rveen meshes
# = 62                                                          (D-198 / D-199)
# + 21 D-202 selected models
# +  4 D-202 verbatim archive licences
# = 87 payload files
# +  2 D-202 project-authored source maps
# = 89                                                          (D-202)
# +  2 D-204 Kenney colour atlases
# = 91                                                          (D-204)
#
# AND IT MOVED ONCE MORE UNDER D-215, for the third time and for the same kind of
# reason: the project owner approved 47 further KayKit models for Zone Composer
# availability, so 47 `.gltf` and their 47 `.bin` sidecars entered the established
# kaykit/{dungeon,forest,halloween} folders. No new licence and no new source map
# — all three packs already carry theirs — and no allowlist change, because the
# D-215 record lives at `scripts/environment/`, outside the `first_mvp` trees this
# scan walks, and Gate 1A's own hall names none of the new models.
# + 47 D-215 approved models
# + 47 of their `.bin` sidecars
# = 183 payload files
# +  2 LeLu Noise Pack textures (T_Cracks336.png, T_CloudNoise_Tiled.png,
#      registered under D-216 for the accepted Riftfall Landing Greybox V2 +
#      Visual Review dressing pass — see game/assets/third_party/lelu/
#      SOURCE_AND_LICENSE.md; CC0-equivalent, no attribution required)
# = 185 payload files
# +  2 D-202 project-authored source maps
# = 187                                                         (D-216)
#
# The `.md` filter is the one every earlier suite uses, so the 89 above is
# payloads only; §4.5 of the cohesion brief counts its two new source maps inside
# its own addition, so they are added back explicitly rather than by loosening the
# filter — which would also have pulled in the three PRE-EXISTING notes and given
# 94. Both numbers are printed so neither can hide the other.
#
# The two Gate 1B suites prove those manifests file by file, byte for byte against
# the archives; this step only proves that nothing beyond them appeared.
third_party_payloads="$(find "$PROJECT_DIR/assets/third_party" -type f \
	! -name '*.import' ! -name '.DS_Store' ! -name '*.md' | wc -l | tr -d ' ')"
d202_source_maps=0
for note in "$PROJECT_DIR/assets/third_party/kenney/SOURCE_AND_LICENSE.md" \
	"$PROJECT_DIR/assets/third_party/quaternius/SOURCE_AND_LICENSE.md"; do
	[[ -f "$note" ]] && d202_source_maps=$((d202_source_maps + 1))
done
third_party_count=$((third_party_payloads + d202_source_maps))
printf '  third-party payload files under assets/third_party: %s\n' "$third_party_payloads"
printf '  D-202 project-authored source maps: %s\n' "$d202_source_maps"
printf '  authorized inventory: %s + %s = %s\n' \
	"$third_party_payloads" "$d202_source_maps" "$third_party_count"
if [[ "$third_party_payloads" == "185" && "$third_party_count" == "187" ]]; then
	printf '  PASS  27 Gate A + 35 Gate 1B spike + 25 D-202 + 2 D-204 + 94 D-215 + 2 LeLu\n'
	printf '        = 185 payloads, plus the 2 D-202 source maps = 187\n'
	printf '        Gate 1A itself extracted and downloaded none of them\n'
else
	printf '  FAIL  %s payload files and %s source maps exist; the authorized\n' \
		"$third_party_payloads" "$d202_source_maps"
	printf '        inventory is 185 + 2 = 187\n'
	failures=$((failures + 1))
fi

# D-217 widens this from "the three Gate 1A dungeon pieces only" to "the three
# Gate 1A pieces OR the D-215 KayKit Dungeon availability record", the SAME
# one-directory-prefix change already applied to Gate 1C's own asset scan (see
# D-216 in docs/DECISION_LOG.md): the whole `kaykit/dungeon/` directory is
# allowlisted by prefix, exactly like `(forest|halloween)/` already is, because
# no rejected or unclassified family lives under that path. This was needed for
# Gate 1D's own Broken Watch dressing (D-215-approved Dungeon pieces beyond the
# three Gate 1A itself uses), and it also incidentally clears a false positive
# this narrower scan had been reporting independently since D-215 widened Zone
# Composer availability without this scan ever being told: the project owner's
# own `zone_composer_practice.tscn` legitimately places other approved Dungeon
# pieces too. The narrower Gate 1A hall check below is UNCHANGED and still
# proves the closed hall itself uses only its own three pieces.
kit_used="$(grep -rohE 'res://assets/[a-zA-Z0-9_/]+\.[a-z]+' \
	"$PROJECT_DIR"/scripts/first_mvp "$PROJECT_DIR"/scenes/first_mvp \
	"$PROJECT_DIR"/data/first_mvp 2>/dev/null | sort -u)"
printf '  asset paths any first-MVP file names directly:\n'
printf '%s\n' "$kit_used" | sed 's/^/        /'
unregistered="$(printf '%s\n' "$kit_used" \
	| grep -vE 'assets/third_party/kaykit/dungeon/' \
	| grep -vE 'assets/third_party/kaykit/(forest|halloween)/' \
	| grep -vE 'assets/third_party/k0rveen/lowpoly_environment/' \
	| grep -vE 'assets/third_party/kenney/(nature|fantasy_town|graveyard|licenses)/' \
	| grep -vE 'assets/third_party/quaternius/(modular_ruins|licenses)/' \
	| grep -vE 'assets/third_party/(kenney|quaternius)/SOURCE_AND_LICENSE\.md' \
	| grep -vE 'assets/third_party/lelu/' \
	| grep -c . | tr -d ' ')"
if [[ "$unregistered" == "0" ]]; then
	printf '  PASS  only the registered dungeon set (Gate 1A three plus the D-215 record),\n'
	printf '        forest/halloween, and the authorized D-198 and D-202 manifests (the\n'
	printf '        Knight and Graveblade bodies arrive through the existing scenes/actors\n'
	printf '        rig scenes, which are themselves registered)\n'
else
	printf '  FAIL  a first-MVP file names an asset outside the registered dungeon set\n'
	printf '        and the authorized Gate 1B manifests\n'
	failures=$((failures + 1))
fi

# And no first-MVP file may name one of the three archives D-202 deliberately
# leaves outside the game project.
outside="$(grep -rohE 'assets/third_party/(assetquest|kenney/(cave|modular_cave)|quaternius/medieval_village)[a-zA-Z0-9_/]*' \
	"$PROJECT_DIR"/scripts/first_mvp "$PROJECT_DIR"/scenes/first_mvp \
	"$PROJECT_DIR"/data/first_mvp 2>/dev/null | sort -u | grep -c . | tr -d ' ')"
if [[ "$outside" == "0" ]]; then
	printf '  PASS  AssetQuest Forest, Kenney Modular Cave, and Quaternius Medieval Village\n'
	printf '        are named by no first-MVP file and are not in the game project\n'
else
	printf '  FAIL  a first-MVP file names an archive D-202 keeps outside the project\n'
	failures=$((failures + 1))
fi

# And the hall itself still names ONLY the three dungeon pieces. That is the
# original Gate 1A statement, kept intact and scoped to Gate 1A's own trees, so
# the broadened check above cannot quietly weaken it.
hall_used="$(grep -rohE 'res://assets/[a-zA-Z0-9_/]+\.[a-z]+' \
	"$PROJECT_DIR"/scripts/first_mvp/calibration "$PROJECT_DIR"/scenes/first_mvp/calibration \
	"$PROJECT_DIR"/data/first_mvp/calibration 2>/dev/null | sort -u \
	| grep -vE 'assets/third_party/kaykit/dungeon/(floor_tile_large|wall|wall_pillar)\.gltf' \
	| grep -c . | tr -d ' ')"
if [[ "$hall_used" == "0" ]]; then
	printf '  PASS  the calibration hall still loads only those three pieces\n'
else
	printf '  FAIL  a Gate 1A file names an asset outside the registered dungeon set\n'
	failures=$((failures + 1))
fi

audio="$(find "$PROJECT_DIR/scenes/first_mvp" "$PROJECT_DIR/scripts/first_mvp" \
	"$PROJECT_DIR/data/first_mvp" \
	\( -name '*.wav' -o -name '*.ogg' -o -name '*.mp3' \) 2>/dev/null | wc -l | tr -d ' ')"
if [[ "$audio" == "0" ]]; then
	printf '  PASS  Gate 1A added no audio file; the hall is silent by design\n'
else
	printf '  FAIL  %s audio files exist under the Gate 1A trees\n' "$audio"
	failures=$((failures + 1))
fi

if [[ -n "$shots_dir" ]]; then
	step "7. Rendered evidence at 1920 x 1080 and at the 1280 x 720 minimum window"
	if "$GODOT" --path "$PROJECT_DIR" --resolution 1920x1080 "$HALL_SCENE" \
		-- --verify-1a --shots "$shots_dir" \
		> /tmp/riftwrought_gate_1a_shots_full.log 2>&1; then
		:
	fi
	assert_no_script_error "rendered 1920 x 1080 Gate 1A verification" /tmp/riftwrought_gate_1a_shots_full.log
	if grep -q "GATE 1A VERIFICATION: PASS" /tmp/riftwrought_gate_1a_shots_full.log; then
		grep -E "GATE 1A VERIFICATION: PASS" /tmp/riftwrought_gate_1a_shots_full.log | sed 's/^/  /'
		printf '  PASS  the rendered run passes and writes the 1920 x 1080 evidence\n'
	else
		printf '  FAIL  the rendered 1920 x 1080 run did not pass\n'
		grep -E "FAIL:" /tmp/riftwrought_gate_1a_shots_full.log | sed 's/^/        /' || true
		failures=$((failures + 1))
	fi

	# §9.17 and §10: the same assertions must hold, and the overlay must still be
	# readable, at the minimum tested window.
	if "$GODOT" --path "$PROJECT_DIR" --resolution 1280x720 "$HALL_SCENE" \
		-- --verify-1a --shots "$shots_dir" --shots-brief \
		> /tmp/riftwrought_gate_1a_shots_small.log 2>&1; then
		:
	fi
	assert_no_script_error "rendered 1280 x 720 Gate 1A verification" /tmp/riftwrought_gate_1a_shots_small.log
	if grep -q "GATE 1A VERIFICATION: PASS" /tmp/riftwrought_gate_1a_shots_small.log; then
		grep -E "overlay root" /tmp/riftwrought_gate_1a_shots_small.log | sed 's/^/      /' || true
		grep -E "GATE 1A VERIFICATION: PASS" /tmp/riftwrought_gate_1a_shots_small.log | sed 's/^/  /'
		printf '  PASS  every surface is still on screen at 1280 x 720\n'
	else
		printf '  FAIL  the rendered 1280 x 720 run did not pass\n'
		grep -E "FAIL:" /tmp/riftwrought_gate_1a_shots_small.log | sed 's/^/        /' || true
		failures=$((failures + 1))
	fi
	printf '  evidence written to %s (%s files)\n' \
		"$shots_dir" "$(ls "$shots_dir" | wc -l | tr -d ' ')"
fi

step "8. The project owner's own files are byte-for-byte untouched"
production_settings_after="$(state_fingerprint "$production_settings")"
production_lab_after="$(state_fingerprint "$production_lab")"
printf '  %s\n    before %s\n    after  %s\n' \
	"$production_settings" "$production_settings_before" "$production_settings_after"
printf '  %s\n    before %s\n    after  %s\n' \
	"$production_lab" "$production_lab_before" "$production_lab_after"
if [[ "$production_settings_before" == "$production_settings_after" \
	&& "$production_lab_before" == "$production_lab_after" ]]; then
	printf '  PASS  the real settings and lab files are unchanged, or still absent\n'
else
	printf '  FAIL  this run changed the project owner'"'"'s own files\n'
	failures=$((failures + 1))
fi

printf '\n'
if [[ "$failures" -eq 0 ]]; then
	printf 'GATE 1A SMOKE CHECKS: PASS\n'
	cat <<'NOTE'
Automated checks cannot certify scale, and scale is what Gate 1A is FOR.
GATE 1A REMAINS OPEN. Only the project owner's mouse-and-controller playtest can
accept the candidate scale, choose measured first-MVP replacements, or ask for
another calibration pass. The checklists are in
docs/testing/FIRST_MVP_GATE_1A_SCALE_CALIBRATION_HALL_REPORT.md §11.
Gate 1B closed under D-206 and D-208's isolated Gate 1C Riftfall Landing scene
exists; the WIDER Severed Threshold route, Broken Watch, canonical opening combat,
Mara, the Nexus, progression and save integration remain unstarted and each needs
its own authorization. Nothing executable in this script changed for that: Gate 1A
is still 284 checks.
NOTE
	exit 0
else
	printf 'GATE 1A SMOKE CHECKS: %d FAILURE(S)\n' "$failures"
	exit 1
fi
