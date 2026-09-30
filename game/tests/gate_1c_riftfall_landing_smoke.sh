#!/usr/bin/env bash
# Riftwrought — First-MVP Gate 1C smoke checks: canonical Riftfall Landing.
#
# Gate 1C (D-208) implements ONE canonical environment slice — the safe exterior
# opening of The Severed Threshold — plus a separate developer review wrapper. It
# does not build the first fight: Broken Watch begins later and owns the first
# Graveblade.
#
# THE LOCKED CHAIN RUNS FIRST AND STOPS EVERYTHING ON ANY REGRESSION (§11).
# `gate_1b_exterior_cohesion_smoke.sh` runs `gate_1b_exterior_asset_spike_smoke.sh`,
# which runs `gate_1a_scale_hall_smoke.sh`, which runs `gate_f_smoke.sh`, which
# reruns Gate E, D, C, B and A. Gate 1C extracted nothing and changed no accepted
# value; that ordering is what proves it.
#
# IT NEVER TOUCHES THE PROJECT OWNER'S OWN SAVED STATE. Gate 1C writes no save and
# no settings file at all — it has no store, no configuration file and no engine
# user-data path, asserted from inside the engine and again from the shell. This
# script also fingerprints the two real files before and after the whole run, and
# uses the established D-192 non-writing path-resolution guard to prove that guard
# still refuses the production directory.
#
# AUTOMATED CHECKS CANNOT ANSWER THE GOVERNING QUESTION, AND THAT IS THE POINT.
# §1 asks whether entering Riftwrought through Riftfall Landing feels like
# arriving in a spacious, readable, ominous world rather than spawning in another
# test room. GATE 1C STAYS OPEN after this script passes: only the project owner
# can answer that, with mouse and controller. See
#   docs/testing/FIRST_MVP_GATE_1C_RIFTFALL_LANDING_REPORT.md
#
# Usage, from the repository root:
#   game/tests/gate_1c_riftfall_landing_smoke.sh [--shots <dir>]
#
# --shots additionally renders the §12 evidence at 1920 x 1080 and the two
# required frames at the 1280 x 720 minimum tested window.

set -uo pipefail

GODOT="${GODOT:-/Applications/Godot.app/Contents/MacOS/Godot}"
EXPECTED_VERSION="4.7.2.stable"
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPO_DIR="$(cd "$PROJECT_DIR/.." && pwd)"
REVIEW_SCENE="res://scenes/first_mvp/severed_threshold/riftfall_landing_review.tscn"
CANONICAL_SCENE="res://scenes/first_mvp/severed_threshold/riftfall_landing.tscn"
COHESION_SCENE="res://scenes/first_mvp/visual/exterior_cohesion_comparison.tscn"
SPIKE_SCENE="res://scenes/first_mvp/visual/exterior_asset_compatibility_spike.tscn"
HALL_SCENE="res://scenes/first_mvp/calibration/scale_calibration_hall.tscn"
APP_SCENE="res://scenes/app/prototype_app.tscn"
ROOM_SCENE="res://scenes/prototype_zero/prototype_zero.tscn"

# The inherited locked ladder D-208 §4 names, which this work must leave exactly
# where it found it. Every one of them is read back out of the chain's own output
# and compared, so "unchanged" is a number rather than an impression.
EXPECTED_GATE_B=106
EXPECTED_GATE_C=209
EXPECTED_GATE_D=230
EXPECTED_GATE_E=713
EXPECTED_GATE_F=1008
EXPECTED_GATE_1A=284
# MOVED UNDER D-215, and by exact arithmetic rather than by observation: the
# spike verifier emits ONE assertion per file in kaykit/forest and kaykit/halloween,
# and D-215 authorized 4 Forest + 8 Halloween models = 12 models = 24 files there.
# 654 + 24 = 678. The 35 approved Dungeon models add nothing here, because
# kaykit/dungeon is not one of the directories that loop walks.
EXPECTED_GATE_1B=678
EXPECTED_COHESION=613
# This suite's own count, pinned from the first passing frozen-tree run and proved
# in BOTH directions below, exactly as the two Gate 1B runners pin theirs.
#
# TWO NUMBERS, AND THE ARITHMETIC BETWEEN THEM IS STATED RATHER THAN HIDDEN. The
# headless run makes 200 assertions. The rendered run makes three more, and only
# three, because §12 requires two frames of the repeating stone posed at exact
# states and one overview frame taken with the camera calibration range widened:
# each of those three poses is itself asserted rather than assumed, so
#   200 + 2 stone poses + 1 camera-calibration restore = 203.
EXPECTED_GATE_1C=200
EXPECTED_GATE_1C_RENDERED=203

# §4: the third-party inventory Gate 1C must not move. It extracted nothing,
# downloaded nothing and deleted nothing.
# MOVED UNDER D-215:  89 payload files at D-204
#                    + 47 approved models + 47 `.bin` sidecars
#                    = 183 payload files.
# MOVED UNDER D-216:  183 payload files
#                    + 2 LeLu Noise Pack textures (the accepted Riftfall
#                      Landing Greybox V2 + Visual Review dressing pass)
#                    = 185 payload files, plus the 2 D-202 source maps = 187.
EXPECTED_THIRD_PARTY_PAYLOADS=185
EXPECTED_THIRD_PARTY=187
# §2: no InputMap action is added, so the accepted set stays at exactly this many.
EXPECTED_INPUT_ACTIONS=31

shots_dir=""
if [[ "${1:-}" == "--shots" && -n "${2:-}" ]]; then
	shots_dir="$2"
	mkdir -p "$shots_dir"
fi

failures=0

pass() { printf '  PASS  %s\n' "$1"; }
fail() { printf '  FAIL  %s\n' "$1"; failures=$((failures + 1)); }
step() { printf '\n=== %s\n' "$1"; }

# A run that reports PASS while a script error scrolled past is not a pass. D-201
# measured exactly that: a throw inside a check function aborts the whole function
# and the suite still prints its green line.
assert_no_script_error() {
	local what="$1" logfile="$2" found
	found="$(grep -c "SCRIPT ERROR" "$logfile" 2>/dev/null | tr -d ' ')"
	if [[ "$found" == "0" ]]; then
		pass "$what produced no SCRIPT ERROR"
	else
		fail "$what produced $found SCRIPT ERROR line(s)"
		grep -A3 "SCRIPT ERROR" "$logfile" | head -20 | sed 's/^/        /'
	fi
}

# Three steps, not one. The first number in "GATE 1C VERIFICATION: ..." is the 1
# of "1C", so extracting bare digits from the whole line reads 1 and the pin would
# refuse every run including a correct one.
count_from() {
	local logfile="$1" label="$2"
	grep -ohE "$label: PASS \([0-9]+ checks\)" "$logfile" 2>/dev/null \
		| grep -ohE '[0-9]+ checks' | grep -ohE '[0-9]+' | head -1
}

check_count() {
	local logfile="$1" label="$2" expected="$3" found
	found="$(count_from "$logfile" "$label")"
	if [[ -n "$found" && "$found" == "$expected" ]]; then
		pass "$label  $expected checks, unchanged"
	else
		fail "$label reported '${found:-nothing}', not the locked $expected"
	fi
}

# Gates B to 1A are run by the cohesion runner's own step 1, which captures their
# raw output into ITS temporary logs and prints only its own summary line for each.
# So the number to read back here is that summary line, not a verification line
# that never reaches this log — a distinction the first version of this runner got
# wrong and reported as six missing counts.
check_chain_row() {
	local logfile="$1" label="$2" expected="$3"
	if grep -qE "PASS +${label}[[:space:]]+${expected} checks, unchanged" "$logfile"; then
		pass "$label  $expected checks, unchanged (via the cohesion chain)"
	else
		fail "the chain did not report $label at the locked $expected"
		grep -E "PASS +${label}" "$logfile" | head -2 | sed 's/^/        /' || true
	fi
}

# Where the project owner's real files live, derived from the project name Godot
# itself uses for the user data directory.
project_name="$(sed -n 's/^config\/name="\(.*\)"[[:space:]]*$/\1/p' "$PROJECT_DIR/project.godot" | head -1)"
production_dir="$HOME/Library/Application Support/Godot/app_userdata/$project_name"
production_settings="$production_dir/prototype_settings.cfg"
production_lab="$production_dir/prototype_zero.cfg"

state_fingerprint() {
	# "absent" is a legitimate answer: the claim is that the run changes nothing,
	# not that a file has to exist.
	if [[ -f "$1" ]]; then
		printf '%s bytes, sha256 %s, mtime %s' \
			"$(wc -c < "$1" | tr -d ' ')" \
			"$(shasum -a 256 "$1" | cut -d' ' -f1)" \
			"$(stat -f %m "$1")"
	else
		printf 'absent'
	fi
}

printf 'Riftwrought — First-MVP Gate 1C smoke checks (canonical Riftfall Landing)\n'
printf 'project: %s\n' "$PROJECT_DIR"

step "0. Engine baseline and the project owner's own files"
installed="$("$GODOT" --version 2>/dev/null | tail -1)"
printf '  installed: %s\n' "$installed"
if [[ "$installed" == "$EXPECTED_VERSION"* ]]; then
	pass "matches the locked $EXPECTED_VERSION baseline"
else
	fail "expected $EXPECTED_VERSION, found $installed"
fi
production_settings_before="$(state_fingerprint "$production_settings")"
production_lab_before="$(state_fingerprint "$production_lab")"
printf '  production settings before: %s\n' "$production_settings_before"
printf '  production lab state before: %s\n' "$production_lab_before"

step "1. The complete locked chain (Gate 1B -> 1A -> F -> E -> D -> C -> B -> A)"
if bash "$PROJECT_DIR/tests/gate_1b_exterior_cohesion_smoke.sh" \
	> /tmp/riftwrought_gate_1c_chain.log 2>&1; then
	pass "gate_1b_exterior_cohesion_smoke.sh still passes with Gate 1C present"
else
	fail "the inherited chain regressed"
	grep -E "FAIL" /tmp/riftwrought_gate_1c_chain.log | head -20 | sed 's/^/        /'
fi
check_chain_row /tmp/riftwrought_gate_1c_chain.log "Gate B" "$EXPECTED_GATE_B"
check_chain_row /tmp/riftwrought_gate_1c_chain.log "Gate C" "$EXPECTED_GATE_C"
check_chain_row /tmp/riftwrought_gate_1c_chain.log "Gate D" "$EXPECTED_GATE_D"
check_chain_row /tmp/riftwrought_gate_1c_chain.log "Gate E" "$EXPECTED_GATE_E"
check_chain_row /tmp/riftwrought_gate_1c_chain.log "Gate F" "$EXPECTED_GATE_F"
check_chain_row /tmp/riftwrought_gate_1c_chain.log "Gate 1A" "$EXPECTED_GATE_1A"
# The Gate 1B SPIKE is one of the gates the cohesion runner executes inside its own
# step 1, so like Gates B to 1A its number arrives as that runner's summary line.
# The COHESION count is different: the cohesion runner runs its own verification in
# its own step 6 and prints the raw line, which does reach this log.
check_chain_row /tmp/riftwrought_gate_1c_chain.log "Gate 1B" "$EXPECTED_GATE_1B"
check_count /tmp/riftwrought_gate_1c_chain.log "GATE 1B COHESION VERIFICATION" "$EXPECTED_COHESION"

step "2. Every earlier runnable scene still starts, and the entrypoint is unchanged"
main_scene="$(sed -n 's/^run\/main_scene="\(.*\)"[[:space:]]*$/\1/p' "$PROJECT_DIR/project.godot" | head -1)"
printf '  project main scene: %s\n' "$main_scene"
if [[ "$main_scene" == "$APP_SCENE" ]]; then
	pass "the Prototype App is still the project entrypoint; Gate 1C did not replace it"
else
	fail "the main scene is '$main_scene', not $APP_SCENE"
fi
for scene in "$APP_SCENE" "$ROOM_SCENE" "$HALL_SCENE" "$SPIKE_SCENE" "$COHESION_SCENE"; do
	if "$GODOT" --headless --path "$PROJECT_DIR" "$scene" --quit-after 90 \
		> /tmp/riftwrought_gate_1c_boot.log 2>&1; then
		pass "$(basename "$scene") still starts standalone"
	else
		fail "$(basename "$scene") no longer starts"
		tail -15 /tmp/riftwrought_gate_1c_boot.log | sed 's/^/        /'
	fi
done

step "3. Gate 1C imports, parses, and starts headlessly"
if "$GODOT" --headless --path "$PROJECT_DIR" --import > /tmp/riftwrought_gate_1c_import.log 2>&1; then
	pass "the project imports with the Gate 1C scenes and scripts present"
else
	fail "the headless import failed"
	tail -20 /tmp/riftwrought_gate_1c_import.log | sed 's/^/        /'
fi
# §11.3: fail on any import error touching Gate 1C or an accepted asset family.
import_errors="$(grep -cE "ERROR:.*(severed_threshold|riftfall|kaykit/(dungeon|forest|halloween)|kenney/graveyard)" \
	/tmp/riftwrought_gate_1c_import.log | tr -d ' ')"
printf '  import errors naming Gate 1C or an accepted family: %s\n' "$import_errors"
if [[ "$import_errors" == "0" ]]; then
	pass "no Gate 1C or accepted-family import error"
else
	fail "$import_errors import error(s) touch Gate 1C or an accepted asset family"
	grep -E "ERROR:.*(severed_threshold|riftfall|kaykit|kenney)" \
		/tmp/riftwrought_gate_1c_import.log | head -10 | sed 's/^/        /'
fi

# Every Gate 1C script must parse cleanly on its own, so a syntax error in a file
# the scene happens not to reach at runtime cannot hide here. `--check-only`
# reports a parse failure in its OUTPUT and still exits zero, so the exit status is
# not the test — the log is.
for script in "$PROJECT_DIR"/scripts/first_mvp/severed_threshold/*.gd \
	"$PROJECT_DIR"/tests/gate_1c_riftfall_landing_verification.gd; do
	rel="${script#"$PROJECT_DIR"/}"
	"$GODOT" --headless --path "$PROJECT_DIR" --check-only --script "res://$rel" \
		> /tmp/riftwrought_gate_1c_parse.log 2>&1
	if grep -qE "Parse Error|Compile Error|Failed to load script" /tmp/riftwrought_gate_1c_parse.log; then
		fail "$rel does not parse"
		tail -10 /tmp/riftwrought_gate_1c_parse.log | sed 's/^/        /'
	else
		pass "$rel"
	fi
done

for scene in "$CANONICAL_SCENE" "$REVIEW_SCENE"; do
	if "$GODOT" --headless --path "$PROJECT_DIR" "$scene" --quit-after 150 \
		> /tmp/riftwrought_gate_1c_scene.log 2>&1; then
		assert_no_script_error "$(basename "$scene")" /tmp/riftwrought_gate_1c_scene.log
	else
		fail "$(basename "$scene") does not start"
		tail -20 /tmp/riftwrought_gate_1c_scene.log | sed 's/^/        /'
	fi
done

step "4. Gate 1C added no asset, no audio, and no storage"
third_party_payloads="$(find "$PROJECT_DIR/assets/third_party" -type f \
	! -name '*.import' ! -name '.DS_Store' ! -name '*.md' | wc -l | tr -d ' ')"
d202_source_maps=0
for note in "$PROJECT_DIR/assets/third_party/kenney/SOURCE_AND_LICENSE.md" \
	"$PROJECT_DIR/assets/third_party/quaternius/SOURCE_AND_LICENSE.md"; do
	[[ -f "$note" ]] && d202_source_maps=$((d202_source_maps + 1))
done
third_party_count=$((third_party_payloads + d202_source_maps))
printf '   %s payload files + %s source maps = %s (authorized: %s + 2 = %s)\n' \
	"$third_party_payloads" "$d202_source_maps" "$third_party_count" \
	"$EXPECTED_THIRD_PARTY_PAYLOADS" "$EXPECTED_THIRD_PARTY"
if [[ "$third_party_payloads" == "$EXPECTED_THIRD_PARTY_PAYLOADS" \
	&& "$third_party_count" == "$EXPECTED_THIRD_PARTY" ]]; then
	pass "the third-party inventory is the authorized $EXPECTED_THIRD_PARTY; Gate 1C extracted nothing, and D-215's 94 files plus D-216's 2 LeLu files are accounted for"
else
	fail "the third-party inventory moved to $third_party_count"
fi

# §6.3: only the approved payloads, and none of the rejected or unclassified
# families. Scanned RAW so a path inside a comment cannot slip past either.
kit_used="$(grep -rohE 'res://assets/[a-zA-Z0-9_/]+\.[a-z]+' \
	"$PROJECT_DIR"/scripts/first_mvp/severed_threshold \
	"$PROJECT_DIR"/scenes/first_mvp/severed_threshold 2>/dev/null | sort -u)"
printf '  asset paths any Gate 1C file names directly:\n'
printf '%s\n' "$kit_used" | sed 's/^/        /'
# D-217 widens this from "Gate 1C's own §6.3 manifest only" to "the §6.3
# manifest OR the D-215 availability record", one for one: this same tree
# (scripts/first_mvp/severed_threshold, scenes/first_mvp/severed_threshold)
# now also holds Gate 1D's own files, which are not bound by Gate 1C's closed
# allowlist and legitimately reach for D-215-approved KayKit Dungeon
# architecture beyond the three Gate 1C itself uses. The whole `kaykit/dungeon/`
# directory is allowlisted by prefix — exactly the same shape the `(forest|
# halloween)/` line already uses — because every rejected or unclassified
# family the next check scans for (k0rveen, Kenney Nature, Fantasy Town,
# Quaternius Modular Ruins, AssetQuest, Medieval Village, Modular Cave,
# Demonson, lowpoly_Village) lives under a DIFFERENT top-level path, so
# widening this one directory cannot admit any of them.
unregistered="$(printf '%s\n' "$kit_used" | grep -v '^$' \
	| grep -vE 'assets/third_party/kaykit/dungeon/' \
	| grep -vE 'assets/third_party/kaykit/(forest|halloween)/' \
	| grep -vE 'assets/third_party/kenney/graveyard/' \
	| grep -c . | tr -d ' ')"
if [[ "$unregistered" == "0" ]]; then
	pass "only the §6.3 approved payloads and the D-215 KayKit Dungeon availability record are named"
else
	fail "a Gate 1C or Gate 1D file names an asset outside the §6.3 manifest and the D-215 record"
fi
rejected="$(grep -rlE 'k0rveen|kenney/nature|fantasy_town|modular_ruins|assetquest|medieval_village|modular_cave|Demonson|lowpoly_Village' \
	"$PROJECT_DIR"/scripts/first_mvp/severed_threshold \
	"$PROJECT_DIR"/scenes/first_mvp/severed_threshold 2>/dev/null | wc -l | tr -d ' ')"
if [[ "$rejected" == "0" ]]; then
	pass "no Gate 1C file names a rejected or unclassified asset family"
else
	fail "$rejected Gate 1C file(s) name a rejected or unclassified family"
fi
audio="$(find "$PROJECT_DIR/scenes/first_mvp/severed_threshold" \
	"$PROJECT_DIR/scripts/first_mvp/severed_threshold" \
	\( -name '*.wav' -o -name '*.ogg' -o -name '*.mp3' \) 2>/dev/null | wc -l | tr -d ' ')"
if [[ "$audio" == "0" ]]; then
	pass "Gate 1C added no audio file; the Landing is silent by design"
else
	fail "$audio audio files exist under the Gate 1C trees"
fi
# No SHIPPING first-MVP file may name a user:// path or a config store at all. The
# verification is excluded by construction rather than by name: it lives under
# tests/, not under scripts/first_mvp/.
leaks="$(grep -rlE 'user://|ConfigFile|ResourceSaver' \
	"$PROJECT_DIR/scripts/first_mvp" "$PROJECT_DIR/scenes/first_mvp" \
	"$PROJECT_DIR/data/first_mvp" 2>/dev/null \
	| grep -v 'gate_1a_verification.gd' | wc -l | tr -d ' ')"
if [[ "$leaks" == "0" ]]; then
	pass "no first-MVP scene or script has storage of any kind"
else
	fail "a first-MVP file reaches persistent storage"
fi
# The pattern matches CALLS, not the forbidden-string list the verification
# carries in order to forbid them.
verify_calls="$(grep -cE 'ConfigFile\.new|ResourceSaver\.save|FileAccess\.open\(|\.store_string\(|\.store_line\(' \
	"$PROJECT_DIR/tests/gate_1c_riftfall_landing_verification.gd" | tr -d ' ')"
printf '  writing storage calls in the Gate 1C verification itself: %s\n' "$verify_calls"
if [[ "$verify_calls" == "0" ]]; then
	pass "the verification only READS source, and writes PNGs into --shots"
else
	fail "the Gate 1C verification opens persistent storage for writing"
fi

step "5. No accepted value moved: the InputMap, the .tres records, and project.godot"
declared_actions="$(awk '/^\[input\]/{f=1;next} /^\[/{f=0} f && /^[a-zA-Z_]+=\{/{c++} END{print c+0}' \
	"$PROJECT_DIR/project.godot")"
printf '  InputMap actions declared in project.godot: %s\n' "$declared_actions"
if [[ "$declared_actions" == "$EXPECTED_INPUT_ACTIONS" ]]; then
	pass "the accepted $EXPECTED_INPUT_ACTIONS-action InputMap is unchanged; Gate 1C uses physical keys"
else
	fail "project.godot declares $declared_actions actions, not $EXPECTED_INPUT_ACTIONS"
fi
wasd="$(grep -cE '^(move_up|move_down|move_left|move_right)=' "$PROJECT_DIR/project.godot" | tr -d ' ')"
if [[ "$wasd" == "0" ]]; then
	pass "still no WASD binding"
else
	fail "$wasd WASD-style actions exist"
fi
# Every gameplay record Gate 1C must not touch, by content hash. The chain above
# re-reads their values in the engine; this proves the FILES did not move either.
tres_ok=1
while IFS='|' read -r rel want; do
	got="$(shasum -a 256 "$PROJECT_DIR/$rel" 2>/dev/null | cut -d' ' -f1)"
	if [[ "$got" != "$want" ]]; then
		printf '        %s\n          expected %s\n          measured %s\n' "$rel" "$want" "${got:-missing}"
		tres_ok=0
	fi
done <<'RECORDS'
data/prototype_zero/quick_strike.tres|76060315856333f018c9bf9b815cf4b6bfc18d57dde002c9a6cf4bbe79fafdad
data/prototype_zero/graveblade.tres|56317f5f88e0e3f5b08681171221303a15d72786736c65cf2e12cabd91ad348c
data/prototype_zero/starter_sword.tres|5069d1a32a22be6542e7aa20ee17225377954de0c8bc198c0cfe7e3c4e91f6e6
data/prototype_zero/honed_sword.tres|77cc713d7d541ab02268df58fd5eed5f2b79f506fa539bee9a1e4d877f723ee2
data/prototype_zero/progression.tres|d1f018dc0a3fa8abe74a6312dd9579dda5cf65358c2321ef4938a07fdc53d7aa
data/first_mvp/calibration/scale_calibration.tres|6f24a1740003c608b91166e308d20ba540cfab753162f942ee20f91347f191e9
RECORDS
if [[ "$tres_ok" == "1" ]]; then
	pass "all six accepted .tres records are byte-identical to the pinned baseline"
else
	fail "an accepted .tres record changed"
fi

step "6. Gate 1C verification (headless, isolated, non-writing)"
if "$GODOT" --headless --path "$PROJECT_DIR" "$REVIEW_SCENE" -- --verify-1c \
	> /tmp/riftwrought_gate_1c_verify.log 2>&1; then
	:
fi
assert_no_script_error "the headless Gate 1C verification" /tmp/riftwrought_gate_1c_verify.log

assert_gate_1c_count() {
	local logfile="$1" expected="${2:-$EXPECTED_GATE_1C}" found
	found="$(count_from "$logfile" "GATE 1C VERIFICATION")"
	[[ -n "$found" && "$found" == "$expected" ]]
}
# Proved in BOTH directions against a replay of this run's own log: a guard that
# accepts everything protects nothing.
gate_1c_replay="$(mktemp -t riftwrought_gate_1c_pin_replay)"
trap 'rm -f "$gate_1c_replay"' EXIT
sed "s/GATE 1C VERIFICATION: PASS ($EXPECTED_GATE_1C checks)/GATE 1C VERIFICATION: PASS ($((EXPECTED_GATE_1C + 1)) checks)/" \
	/tmp/riftwrought_gate_1c_verify.log > "$gate_1c_replay"
if assert_gate_1c_count "$gate_1c_replay"; then
	fail "the $EXPECTED_GATE_1C pin accepted a replayed log reporting $((EXPECTED_GATE_1C + 1)) checks"
else
	pass "the pin rejects an altered replayed count ($((EXPECTED_GATE_1C + 1)) is refused)"
fi
if assert_gate_1c_count /tmp/riftwrought_gate_1c_verify.log; then
	grep -E "^  (authored movement|CF at|geometric route|resolved navigation|navigation mesh|narrowest|Watch breach|route widths|clear movement|direct traversal|accepted camera|principal-ground|walked|exterior ambient)" \
		/tmp/riftwrought_gate_1c_verify.log | sed 's/^/      /' || true
	grep -E "GATE 1C VERIFICATION: PASS" /tmp/riftwrought_gate_1c_verify.log | sed 's/^/  /'
	pass "scene separation, accepted values, the InputMap, §6.1's measured outcome, the §6.2
        beats, the §6.3 allowlist and §6.4 contact rules, the accepted presentation, the
        §7 event machine across two full cycles, the §8 sockets, §10's navigation,
        traversal, collision, cursor and controller proofs, the §9 overlay and reset,
        scope, storage and the closed gates"
else
	fail "the Gate 1C verification did not pass at $EXPECTED_GATE_1C checks"
	grep -E "FAIL:|VERIFICATION" /tmp/riftwrought_gate_1c_verify.log | sed 's/^/        /' || true
	tail -20 /tmp/riftwrought_gate_1c_verify.log | sed 's/^/        /'
fi

step "7. Gate 1C writes nothing, and the storage guard still refuses production"
settings_mid="$(state_fingerprint "$production_settings")"
lab_mid="$(state_fingerprint "$production_lab")"
if [[ "$settings_mid" == "$production_settings_before" && "$lab_mid" == "$production_lab_before" ]]; then
	pass "the production files are unchanged after every run above"
else
	fail "a run above changed the project owner's own files"
	printf '        settings before %s\n        settings after  %s\n' \
		"$production_settings_before" "$settings_mid"
	printf '        lab before      %s\n        lab after       %s\n' \
		"$production_lab_before" "$lab_mid"
fi
if "$GODOT" --headless --path "$PROJECT_DIR" -- --check-state-dir --state-dir "$production_dir" \
	> /tmp/riftwrought_gate_1c_guard.log 2>&1; then
	fail "the storage guard accepted the production directory"
else
	if grep -qE "refusing to start|own user data directory" /tmp/riftwrought_gate_1c_guard.log; then
		pass "the D-192 guard still refuses the production directory, without writing"
	else
		fail "the storage guard did not report a refusal"
		tail -10 /tmp/riftwrought_gate_1c_guard.log | sed 's/^/        /'
	fi
fi

step "8. Only the D-208, D-216, D-217 and D-219 authorized paths exist, and later work is unstarted"
# D-217 REPLACES THIS ASSERTION ONE FOR ONE, exactly as D-208 did to its own
# predecessor: Broken Watch is no longer unstarted, so "Broken Watch remains
# unstarted" became false BY AUTHORIZATION, and the boundary moves to name
# Gate 1D's own paths instead of forbidding them. D-216 (the accepted Greybox
# V2 + Visual Review foundation) moves it the same way.
# D-219 EXTENDS THIS ALLOWLIST ONE ENTRY PER FILE, exactly as D-217 did for
# Gate 1D. The Nexus Threshold and the Rift Nexus are no longer unstarted, so
# forbidding them became false BY AUTHORIZATION and the boundary moves to name
# them instead. What remains forbidden is everything past the First Footing
# boundary. The -iname token list below is widened at the same time, so Gate 1E's
# own files are actually VISIBLE to this scan rather than sitting in the same
# blind spot scripts/items/ and scripts/ui/ already sit in.
authorized_route_paths="scenes/first_mvp/severed_threshold
scenes/first_mvp/severed_threshold/riftfall_landing.tscn
scenes/first_mvp/severed_threshold/riftfall_landing_review.tscn
scenes/first_mvp/severed_threshold/broken_watch_slice.tscn
scripts/first_mvp/severed_threshold
scripts/first_mvp/severed_threshold/riftfall_landing.gd
scripts/first_mvp/severed_threshold/riftfall_landing_layout.gd
scripts/first_mvp/severed_threshold/riftfall_loop_event.gd
scripts/first_mvp/severed_threshold/riftfall_landing_review.gd
scripts/first_mvp/severed_threshold/riftfall_landing_overlay.gd
scripts/first_mvp/severed_threshold/broken_watch_layout.gd
scripts/first_mvp/severed_threshold/broken_watch_slice.gd
data/first_mvp/severed_threshold
data/first_mvp/severed_threshold/broken_watch
scenes/first_mvp/greybox/riftfall_landing_greybox_review.tscn
scenes/first_mvp/visual_review/riftfall_landing_visual_review.tscn
scripts/first_mvp/greybox/riftfall_landing_greybox_layout.gd
scripts/first_mvp/greybox/riftfall_landing_greybox_review.gd
scripts/first_mvp/visual_review/riftfall_landing_visual_review.gd
scripts/first_mvp/visual_review/riftfall_landing_visual_review_dressing.gd
scripts/first_mvp/visual_review/riftfall_landing_visual_review_stone.gd
scripts/first_mvp/severed_threshold/nexus_threshold_layout.gd
scripts/first_mvp/nexus
scripts/first_mvp/nexus/rift_nexus_layout.gd
scripts/first_mvp/nexus/rift_anchor.gd
scripts/first_mvp/nexus/mara_veyl.gd
scripts/first_mvp/nexus/first_mvp_dialogue.gd
scripts/first_mvp/canonical_opening
scripts/first_mvp/canonical_opening/canonical_opening_runtime.gd
scripts/first_mvp/canonical_opening/foundation_skill_practice.gd
scenes/first_mvp/canonical_opening
scenes/first_mvp/canonical_opening/canonical_opening.tscn
scenes/first_mvp/canonical_opening/foundation_skill_practice.tscn
data/first_mvp/skills
data/first_mvp/foundation"
route_files="$(cd "$PROJECT_DIR" && find scenes/first_mvp scripts/first_mvp data/first_mvp \
	\( -iname '*severed*' -o -iname '*riftfall*' -o -iname '*broken_watch*' \
	   -o -iname '*nexus*' -o -iname '*run_graph*' -o -iname '*module_library*' \
	   -o -iname '*canonical_opening*' -o -iname '*rift_anchor*' -o -iname '*mara*' \
	   -o -iname '*dialogue*' -o -iname '*first_footing*' \) \
	2>/dev/null | sed 's/\.uid$//' | sort -u)"
unauthorized="$(printf '%s\n' "$route_files" | grep -v '^$' | grep -vxF "$authorized_route_paths" | wc -l | tr -d ' ')"
missing_1c=0
while IFS= read -r wanted; do
	[[ -e "$PROJECT_DIR/$wanted" ]] || missing_1c=$((missing_1c + 1))
done <<< "$authorized_route_paths"
if [[ "$unauthorized" == "0" && "$missing_1c" == "0" ]]; then
	pass "exactly the D-208 §3, D-216, D-217 and D-219 paths exist; First Footing, the
        run graph and the module library remain unstarted"
else
	fail "$unauthorized unauthorized route file(s) and $missing_1c missing authorized path(s)"
	printf '%s\n' "$route_files" | grep -v '^$' | grep -vxF "$authorized_route_paths" | sed 's/^/        /'
fi
if [[ -f "$REPO_DIR/docs/testing/FIRST_MVP_VERTICAL_SLICE_REPORT.md" ]]; then
	fail "FIRST_MVP_VERTICAL_SLICE_REPORT.md exists; that work is not authorized"
else
	pass "FIRST_MVP_VERTICAL_SLICE_REPORT.md does not exist"
fi
# D-217 REPLACES THIS ASSERTION ONE FOR ONE: Gate 1D's own specification and
# delivery report now MUST exist, exactly as Gate 1C's own did once D-208/D-209
# delivered it.
for present in "$REPO_DIR/design/FIRST_MVP_GATE_1D_BROKEN_WATCH_COMBAT_AND_LOOT_SLICE_SPECIFICATION.md" \
	"$REPO_DIR/docs/testing/FIRST_MVP_GATE_1D_BROKEN_WATCH_REPORT.md" \
	"$REPO_DIR/design/FIRST_MVP_GATE_1E_NEXUS_THRESHOLD_AND_THE_NEXUS_ANSWERS_SPECIFICATION.md" \
	"$REPO_DIR/docs/testing/FIRST_MVP_GATE_1E_NEXUS_THRESHOLD_REPORT.md"; do
	if [[ -f "$present" ]]; then
		pass "$(basename "$present") exists"
	else
		fail "$(basename "$present") is missing; D-217/D-219 require it"
	fi
done

if [[ -n "$shots_dir" ]]; then
	step "9. Rendered evidence at 1920 x 1080 and at the 1280 x 720 minimum window"
	if "$GODOT" --path "$PROJECT_DIR" --resolution 1920x1080 "$REVIEW_SCENE" \
		-- --verify-1c --shots "$shots_dir" > /tmp/riftwrought_gate_1c_shots_full.log 2>&1; then
		:
	fi
	assert_no_script_error "the rendered 1920 x 1080 run" /tmp/riftwrought_gate_1c_shots_full.log
	if assert_gate_1c_count /tmp/riftwrought_gate_1c_shots_full.log "$EXPECTED_GATE_1C_RENDERED"; then
		grep -E "GATE 1C VERIFICATION: PASS" /tmp/riftwrought_gate_1c_shots_full.log | sed 's/^/  /'
		pass "the rendered 1920 x 1080 run passes at $EXPECTED_GATE_1C_RENDERED and writes the §12 evidence"
	else
		fail "the rendered 1920 x 1080 run did not pass at $EXPECTED_GATE_1C_RENDERED"
		grep -E "FAIL:" /tmp/riftwrought_gate_1c_shots_full.log | head -10 | sed 's/^/        /' || true
	fi
	if "$GODOT" --path "$PROJECT_DIR" --resolution 1280x720 "$REVIEW_SCENE" \
		-- --verify-1c --shots "$shots_dir" --shots-brief \
		> /tmp/riftwrought_gate_1c_shots_small.log 2>&1; then
		:
	fi
	assert_no_script_error "the rendered 1280 x 720 run" /tmp/riftwrought_gate_1c_shots_small.log
	# The brief run renders only the two §12 frames the minimum window owes, so it
	# takes neither stone pose nor the overview and lands on the headless count.
	if assert_gate_1c_count /tmp/riftwrought_gate_1c_shots_small.log "$EXPECTED_GATE_1C"; then
		grep -E "overlay root" /tmp/riftwrought_gate_1c_shots_small.log | sed 's/^/      /' || true
		pass "every surface is still on screen at the 1280 x 720 minimum tested window"
	else
		fail "the rendered 1280 x 720 run did not pass at $EXPECTED_GATE_1C"
		grep -E "FAIL:" /tmp/riftwrought_gate_1c_shots_small.log | head -10 | sed 's/^/        /' || true
	fi

	# §12: eight exact images. Each must exist, carry the expected dimensions in its
	# own IHDR, and be a real frame rather than an empty file. Dimensions are read
	# from the PNG header rather than trusted from the filename, because the
	# filename is written by the same run that would get them wrong.
	# `od` emits a trailing record after the eight bytes, and awk read it as a
	# second image — the first version reported "1920x10800x0" and failed all eight.
	png_dimensions() {
		od -An -tu1 -j16 -N8 "$1" 2>/dev/null | awk 'NR == 1 {
			printf "%dx%d", ($1*16777216 + $2*65536 + $3*256 + $4), ($5*16777216 + $6*65536 + $7*256 + $8)
		}'
	}
	missing_shot=0
	while IFS='|' read -r stem wanted; do
		shot="$shots_dir/$stem.png"
		if [[ ! -f "$shot" ]]; then
			fail "§12 required image missing: $stem"
			missing_shot=$((missing_shot + 1))
			continue
		fi
		bytes="$(wc -c < "$shot" | tr -d ' ')"
		dims="$(png_dimensions "$shot")"
		if [[ "$dims" == "$wanted" && "$bytes" -gt 20000 ]]; then
			printf '  PASS  §12 image: %s (%s, %s bytes)\n' "$stem" "$dims" "$bytes"
		else
			fail "§12 image $stem is $dims / $bytes bytes; expected $wanted and a real frame"
			missing_shot=$((missing_shot + 1))
		fi
	done <<'IMAGES'
01_arrival_1920x1080_clean|1920x1080
02_first_bearing_1920x1080_clean|1920x1080
03_stone_roll_1920x1080_clean|1920x1080
04_stone_impossible_return_1920x1080_clean|1920x1080
05_watch_breach_1920x1080_clean|1920x1080
06_route_overview_1920x1080_overlay|1920x1080
07_arrival_1280x720_clean|1280x720
08_watch_breach_1280x720_clean|1280x720
IMAGES
	if [[ "$missing_shot" == "0" ]]; then
		pass "all eight §12 images exist at their declared dimensions"
	fi
	extra="$(find "$shots_dir" -name '*.png' | wc -l | tr -d ' ')"
	printf '  evidence written to %s (%s PNG files)\n' "$shots_dir" "$extra"
	if [[ "$extra" == "8" ]]; then
		pass "exactly the eight §12 images were produced, and no others"
	else
		fail "$extra PNG files exist; §12 names exactly eight"
	fi
fi

step "10. The project owner's own files are byte-for-byte untouched"
production_settings_after="$(state_fingerprint "$production_settings")"
production_lab_after="$(state_fingerprint "$production_lab")"
printf '  %s\n    before %s\n    after  %s\n' \
	"$production_settings" "$production_settings_before" "$production_settings_after"
printf '  %s\n    before %s\n    after  %s\n' \
	"$production_lab" "$production_lab_before" "$production_lab_after"
if [[ "$production_settings_before" == "$production_settings_after" \
	&& "$production_lab_before" == "$production_lab_after" ]]; then
	pass "the real settings and lab files are unchanged, or still absent"
else
	fail "this run changed the project owner's own files"
fi

printf '\n'
if [[ "$failures" -eq 0 ]]; then
	printf 'GATE 1C SMOKE CHECKS: PASS\n'
	cat <<'NOTE'
Automated checks can prove scale, route, navigation, collision, asset boundaries,
the repeating event and regression safety. They cannot answer the question Gate 1C
exists to ask: does entering Riftwrought through Riftfall Landing feel like
arriving in a spacious, readable, ominous world rather than spawning in another
test room? GATE 1C REMAINS OPEN. Only the project owner can decide that, and the
mouse and controller playtests are in
docs/testing/FIRST_MVP_GATE_1C_RIFTFALL_LANDING_REPORT.md §11.
Broken Watch is now delivered under D-217 (see
docs/testing/FIRST_MVP_GATE_1D_BROKEN_WATCH_REPORT.md). No result here
authorizes the Nexus Threshold, the Rift Nexus, the wider Severed Threshold
route beyond Broken Watch, Mara, dialogue, the Foundation Cache, the Passive
Web, Rift Shards, Rift Echo, Augments, the Forge, random loot tables,
procedural generation, saves, final UI, final VFX, or final audio.
NOTE
	exit 0
else
	printf 'GATE 1C SMOKE CHECKS: %d FAILURE(S)\n' "$failures"
	exit 1
fi
