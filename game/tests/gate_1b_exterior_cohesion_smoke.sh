#!/usr/bin/env bash
# Riftwrought — First-MVP Gate 1B smoke checks: the Exterior Cohesion Comparison.
#
# The first Gate 1B spike (D-198/D-199) proved that the registered KayKit families
# are technically compatible, and its deliberate catalogue layout could not answer
# whether they make a believable zone. D-202 authorizes this separate comparison,
# which asks one narrower question:
#
#   Can a deliberately composed, traversable exterior route slice use one
#   restrained supplemental terrain language and one restrained ruin language
#   while still reading as the same game as the KayKit Knight, Dungeon, Forest,
#   and Halloween families?
#
# THE LOCKED CHAIN RUNS FIRST AND STOPS EVERYTHING ON ANY REGRESSION
# (specification §9.1). `gate_1b_exterior_asset_spike_smoke.sh` runs
# `gate_1a_scale_hall_smoke.sh`, which runs `gate_f_smoke.sh`, which reruns Gate E,
# D, C, B, and A. This comparison extracted new third-party assets and touched
# nothing else; that ordering is what proves it.
#
# IT NEVER TOUCHES THE PROJECT OWNER'S OWN SAVED STATE. The comparison writes no
# save or settings file at all — it has no store, no configuration file, and no
# engine user-data path, asserted from inside the engine and again from the shell.
# This script also fingerprints the two real files before and after the whole run,
# and uses the established D-192 non-writing path-resolution guard to prove that
# guard still refuses the production directory.
#
# AUTOMATED CHECKS CANNOT CLASSIFY AN ASSET FAMILY, AND THAT IS THE WHOLE POINT.
# Gate 1B stays OPEN after this script passes: only the project owner can decide
# which exterior topology, architecture, and dressing families belong. See
#   docs/testing/FIRST_MVP_GATE_1B_EXTERIOR_COHESION_COMPARISON_REPORT.md
#
# Usage, from the repository root:
#   game/tests/gate_1b_exterior_cohesion_smoke.sh [--shots <dir>]
#
# --shots additionally renders the §8 evidence at 1920 x 1080 and a reduced set at
# the 1280 x 720 minimum tested window.

set -uo pipefail

GODOT="${GODOT:-/Applications/Godot.app/Contents/MacOS/Godot}"
EXPECTED_VERSION="4.7.2.stable"
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPO_DIR="$(cd "$PROJECT_DIR/.." && pwd)"
COHESION_SCENE="res://scenes/first_mvp/visual/exterior_cohesion_comparison.tscn"
SPIKE_SCENE="res://scenes/first_mvp/visual/exterior_asset_compatibility_spike.tscn"
HALL_SCENE="res://scenes/first_mvp/calibration/scale_calibration_hall.tscn"
APP_SCENE="res://scenes/app/prototype_app.tscn"
ROOM_SCENE="res://scenes/prototype_zero/prototype_zero.tscn"

# The inherited locked ladder D-202 names, which this work must leave exactly
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
# And this suite's own count, pinned here from the first passing run — the same
# discipline D-202 authorizes for the first Gate 1B spike's 654, applied to this
# suite from the beginning rather than left for a later authorization to add.
# D-204 moved it 597 -> 613 by exact arithmetic: 8 assertions REPLACED one for one
# where the atlas absence made them false, and 16 ADDED as dependency proofs —
# +2 the recursive allowlist scan now owes for the two atlases themselves,
# +8 their existence, exact byte count, in-engine byte identity, and game-side
#    destination in the source note (4 each),
# +1 the inventory's own `atlases` term,
# +4 that all nine models resolve THEIR OWN kit's atlas (none unresolved, none
#    on the wrong kit's atlas, 6 Fantasy Town, 3 Graveyard),
# +1 that the imported materials keep CULL_DISABLED under the treatment.
# 597 + 16 = 613.
EXPECTED_COHESION=613

# The third-party inventory, specification §4.5 as D-204 §12 restates it:
#     62  files the first Gate 1B spike left behind
#   + 21  D-202 selected models
#   +  4  D-202 verbatim archive licences
#   +  2  D-204 colour atlases
#   = 89  payload files
#   +  2  D-202 project-authored source maps
#   = 91
# The `.md` filter is the one every earlier suite uses, so the three PRE-EXISTING
# notes stay outside the payload count exactly as before and are checked by
# content and byte identity instead. Both numbers are printed.
# MOVED UNDER D-215:  89 payload files at D-204
#                    + 47 approved models + 47 `.bin` sidecars
#                    = 183 payload files.
# MOVED UNDER D-216:  183 payload files
#                    + 2 LeLu Noise Pack textures (accepted Riftfall Landing
#                      Greybox V2 + Visual Review dressing pass — see
#                      game/assets/third_party/lelu/SOURCE_AND_LICENSE.md)
#                    = 185 payload files, plus the 2 D-202 source maps = 187.
EXPECTED_THIRD_PARTY_PAYLOADS=185
EXPECTED_THIRD_PARTY=187

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

# A count read out of a log this run did not write is not a measurement. Every
# check_count below therefore requires its log to be newer than the moment this
# script started.
#
# THIS MUST BE ASSIGNED AT THE TOP OF THE SCRIPT, NOT BESIDE `check_count`.
# Assigned next to the function it serves, it is evaluated only when execution
# REACHES that line — which is after step 1 has already run the whole chain, so
# every log the chain just wrote is "older than the run" and all six reads fail.
# Measured exactly that way once before this comment existed.
CHAIN_STARTED_AT="$(date +%s)"

log_is_fresh() {
	local logfile="$1"
	[[ -f "$logfile" ]] || return 1
	local written
	written="$(stat -f %m "$logfile" 2>/dev/null || echo 0)"
	[[ "$written" -ge "$CHAIN_STARTED_AT" ]]
}

step() { printf '\n=== %s\n' "$1"; }
pass() { printf '  PASS  %s\n' "$1"; }
fail() { printf '  FAIL  %s\n' "$1"; failures=$((failures + 1)); }

# NOTE on the pattern below, carried from gate_f_smoke.sh. Godot's output is
# written to a log FIRST and the log is then grepped, rather than piping Godot
# through `tee ... | grep -q`. With `set -o pipefail`, `grep -q` exits the moment
# it matches and `tee` can then die on EPIPE, failing the pipeline even though the
# verification passed. That race reported a regression that had not happened.

# A GDScript runtime error inside a check function ABORTS that function and every
# later assertion in it, while the suite still reports PASS — measured in Gate 1A
# under D-200 and D-201. So this suite refuses to trust ANY of its own passing
# runs that also printed a script error, not only its headless one.
assert_no_script_error() {
	local label="$1" logfile="$2"
	if grep -qE "SCRIPT ERROR" "$logfile"; then
		fail "$label printed a script error; assertions were skipped"
		grep -E "SCRIPT ERROR" "$logfile" | head -5 | sed 's/^/        /'
	else
		pass "$label ran end to end with no script error, so no check was skipped"
	fi
}

step "0. Engine baseline"
version="$("$GODOT" --version 2>/dev/null | tr -d '\r')"
printf '  installed: %s\n' "$version"
if [[ "$version" == "$EXPECTED_VERSION"* ]]; then
	pass "matches the locked $EXPECTED_VERSION baseline"
else
	fail "expected $EXPECTED_VERSION, found $version"
fi
printf '  production settings before: %s\n' "$production_settings_before"
printf '  production lab state before: %s\n' "$production_lab_before"

step "1. The complete locked chain (Gate 1B -> 1A -> F -> E -> D -> C -> B -> A)"
# Specification §9.1: run the existing Gate 1B suite first and require the whole
# inherited ladder to remain unchanged. This work added third-party assets and a
# separate scene; if any accepted value, asset, rig, locomotion, combat, or
# storage behaviour moved, it fails here and nothing below is trusted.
if "$PROJECT_DIR/tests/gate_1b_exterior_asset_spike_smoke.sh" \
	> /tmp/riftwrought_gate_1b_from_cohesion.log 2>&1; then
	pass "gate_1b_exterior_asset_spike_smoke.sh still passes with the D-202 extraction present"
else
	fail "gate_1b_exterior_asset_spike_smoke.sh failed; cohesion results are not trusted"
	tail -40 /tmp/riftwrought_gate_1b_from_cohesion.log | sed 's/^/        /'
fi



check_count() {
	local label="$1" expected="$2" pattern="$3" logfile="$4"
	local found
	if ! log_is_fresh "$logfile"; then
		fail "$label: $logfile is missing or older than this run; a stale log cannot answer for it"
		return
	fi
	found="$(grep -ohE "$pattern" "$logfile" 2>/dev/null | grep -ohE '[0-9]+ checks' | grep -ohE '[0-9]+' | sort -u | head -1)"
	if [[ -z "$found" ]]; then
		fail "$label: no count found in the chain output"
	elif [[ "$found" == "$expected" ]]; then
		printf '  PASS  %-8s %s checks, unchanged\n' "$label" "$found"
	else
		fail "$label: $found checks, expected $expected"
	fi
}
# D-219 REPAIR: THESE FOUR READS WERE POINTED AT A LOG THAT NEVER CONTAINED THEM,
# AND ONLY STALE /tmp FILES EVER MADE THEM PASS.
#
# `gate_1a_scale_hall_smoke.sh` runs `gate_f_smoke.sh` into
# /tmp/riftwrought_gate_f_from_1a.log and then greps that file for
# "GATE [A-F] VERIFICATION" to echo a chain summary. But Gate B, C, D and E each
# write their own raw "GATE X VERIFICATION: PASS (N checks)" line into their OWN
# /tmp/riftwrought_gate_<x>_verify.log and never onto their smoke script's
# stdout — which is precisely why Gate F's own count is already special-cased
# below, with a comment in `gate_1a_scale_hall_smoke.sh` saying "otherwise the
# chain summary here would silently stop at Gate E".
#
# So /tmp/riftwrought_gate_1a_from_1b.log holds exactly two of these lines,
# GATE 1A and GATE F, and has never held B, C, D or E. Every previous green run
# was reading LEFTOVER CONTENT from an earlier invocation; deleting the /tmp logs
# before a run makes all four fail at once. Measured, on a clean /tmp: 0 of 4
# found.
#
# Each read is repointed at the log that actually contains its line, exactly as
# Gate F's already is. `pass`/`fail` are shell counters rather than verification
# checks, so no pinned count moves. Found by Gate 1E; the same class as the
# closed-gate defect Gate 1B found in Gate 1A and D-200/D-201 repaired.
#
# THE STALENESS THAT MASKED IT IS NOW ITSELF GUARDED: `check_count` refuses a log
# older than this run, so a leftover file can no longer answer for a run that did
# not produce one.
check_count "Gate B"  "$EXPECTED_GATE_B"  "GATE B VERIFICATION: PASS \([0-9]+ checks\)"  /tmp/riftwrought_gate_b_verify.log
check_count "Gate C"  "$EXPECTED_GATE_C"  "GATE C VERIFICATION: PASS \([0-9]+ checks\)"  /tmp/riftwrought_gate_c_verify.log
check_count "Gate D"  "$EXPECTED_GATE_D"  "GATE D VERIFICATION: PASS \([0-9]+ checks\)"  /tmp/riftwrought_gate_d_verify.log
check_count "Gate E"  "$EXPECTED_GATE_E"  "GATE E VERIFICATION: PASS \([0-9]+ checks\)"  /tmp/riftwrought_gate_e_verify.log
check_count "Gate F"  "$EXPECTED_GATE_F"  "GATE F VERIFICATION: PASS \([0-9]+ checks\)"  /tmp/riftwrought_gate_f_verify.log
check_count "Gate 1A" "$EXPECTED_GATE_1A" "GATE 1A VERIFICATION: PASS \([0-9]+ checks\)" /tmp/riftwrought_gate_1a_from_1b.log
check_count "Gate 1B" "$EXPECTED_GATE_1B" "GATE 1B VERIFICATION: PASS \([0-9]+ checks\)" /tmp/riftwrought_gate_1b_verify.log
# Gate A has no check COUNT to pin — it is an asset and rig spike — so it is
# proved by the three specific strings it prints, each read from the log the
# chain actually writes it to rather than from whatever happens to be nearby.
gate_a_passes=0
for pair in "GATE A SMOKE CHECKS: PASS|/tmp/riftwrought_gate_a_from_b.log" \
            "GATE A ASSET REPORT: PASS|/tmp/riftwrought_gate_a_assets.log" \
            "GATE A RIG VERIFICATION: PASS|/tmp/riftwrought_gate_a_rig.log"; do
	IFS='|' read -r needle logfile <<< "$pair"
	if [[ -f "$logfile" ]] && grep -q "$needle" "$logfile"; then
		gate_a_passes=$((gate_a_passes + 1))
	else
		fail "Gate A: '$needle' not found in $logfile"
	fi
done
if [[ "$gate_a_passes" == "3" ]]; then
	printf '  PASS  %-8s asset report, rig verification, and smoke all still pass\n' "Gate A"
fi

step "2. Every earlier runnable scene still starts, and the entrypoint is unchanged"
main_scene="$(sed -n 's/^run\/main_scene="\(.*\)"[[:space:]]*$/\1/p' "$PROJECT_DIR/project.godot" | head -1)"
printf '  project main scene: %s\n' "$main_scene"
if [[ "$main_scene" == "$APP_SCENE" ]]; then
	pass "the Prototype App is still the project entrypoint"
else
	fail "the main scene is $main_scene, not $APP_SCENE"
fi
for pair in "the Prototype App|$APP_SCENE|60" \
            "the Prototype Zero laboratory|$ROOM_SCENE|90" \
            "the Gate 1A calibration hall|$HALL_SCENE|120" \
            "the first Gate 1B spike|$SPIKE_SCENE|200"; do
	IFS='|' read -r label scene quit <<< "$pair"
	if "$GODOT" --headless --path "$PROJECT_DIR" "$scene" --quit-after "$quit" \
		> /tmp/riftwrought_cohesion_boot_other.log 2>&1; then
		pass "$label still starts standalone"
	else
		fail "$label no longer starts standalone"
		tail -20 /tmp/riftwrought_cohesion_boot_other.log | sed 's/^/        /'
	fi
done

step "3. The comparison imports, parses, and starts headlessly"
if "$GODOT" --headless --path "$PROJECT_DIR" --import \
	> /tmp/riftwrought_cohesion_import.log 2>&1; then
	pass "the project imports with the D-202 assets, scene, and scripts present"
else
	fail "import failed"
	tail -20 /tmp/riftwrought_cohesion_import.log | sed 's/^/        /'
fi

# A clean import, with NO exception carved out for the atlas any more. Before
# D-204 this block counted the expected missing-`colormap.png` errors, printed
# them, and filtered them out of the "other errors" scan — and it never asserted
# the count at all, so it was a guard that accepted anything. D-204 removes both
# the exception and the filter: a `colormap.png` error is now an ordinary import
# error, and there must be none.
#
# The count alone is weak evidence, because `--import` on a warm cache re-emits
# nothing. So the shell proves the two FILES are present and byte-identical (step
# 4 below), and the engine verification proves the nine models actually RESOLVE
# them at the point of use. This assertion is the third leg, not the only one.
atlas_errors="$(grep -cE "Can't open file from path 'res://assets/third_party/kenney/(fantasy_town|graveyard)/Textures/colormap.png'" \
	/tmp/riftwrought_cohesion_import.log | tr -d ' ')"
other_errors="$(grep -icE "ERROR.*(kenney|quaternius)" /tmp/riftwrought_cohesion_import.log \
	| tr -d ' ')"
printf '  import reports: %s missing-atlas errors, %s D-202/D-204 import errors in total\n' \
	"$atlas_errors" "$other_errors"
if [[ "$atlas_errors" == "0" && "$other_errors" == "0" ]]; then
	pass "no missing-atlas error and no other D-202 or D-204 candidate import error"
else
	fail "a D-202 or D-204 candidate reported an import error; D-204 requires zero"
	grep -iE "ERROR.*(kenney|quaternius)" /tmp/riftwrought_cohesion_import.log \
		| head -10 | sed 's/^/        /'
fi

if "$GODOT" --headless --path "$PROJECT_DIR" "$COHESION_SCENE" --quit-after 260 \
	> /tmp/riftwrought_cohesion_boot.log 2>&1; then
	pass "the cohesion comparison builds, bakes, and exits cleanly"
	grep -E "\[gate-1b-cohesion\] (instances placed|catalogued models|route footprint|threshold gap|dungeon doorway|navigation baked)" \
		/tmp/riftwrought_cohesion_boot.log | sed 's/^/        /' || true
else
	fail "the cohesion comparison does not start"
	tail -30 /tmp/riftwrought_cohesion_boot.log | sed 's/^/        /'
fi

# Every D-202 script must parse cleanly on its own, so a syntax error in a file
# the comparison happens not to reach at runtime cannot hide here. `--check-only`
# reports a parse failure in its OUTPUT and still exits zero, so the exit status
# is not the test — the log is.
for script in "$PROJECT_DIR"/scripts/first_mvp/visual/exterior_cohesion_*.gd \
	"$PROJECT_DIR"/tests/gate_1b_exterior_cohesion_verification.gd; do
	rel="${script#"$PROJECT_DIR"/}"
	"$GODOT" --headless --path "$PROJECT_DIR" --check-only --script "res://$rel" \
		> /tmp/riftwrought_cohesion_parse.log 2>&1
	if grep -qE "Parse Error|Compile Error|Failed to load script" /tmp/riftwrought_cohesion_parse.log; then
		fail "$rel does not parse"
		tail -10 /tmp/riftwrought_cohesion_parse.log | sed 's/^/        /'
	else
		pass "$rel"
	fi
done

step "4. The exact §4 + D-204 extraction, byte for byte against the four archives"
# The engine verification proves all 27 archive-derived files with ZIPReader. This
# step proves the same thing INDEPENDENTLY in the shell with `unzip`, because a
# byte-identity claim that only one tool can make is weaker than one two agree on.
nature_zip="$REPO_DIR/assets/kenney_nature-kit.zip"
ruins_zip="$REPO_DIR/assets/Ultimate Modular Ruins Pack - Aug 2021-20260901T195405Z-1-001.zip"
town_zip="$REPO_DIR/assets/kenney_fantasy-town-kit_2.0.zip"
graveyard_zip="$REPO_DIR/assets/kenney_graveyard-kit_5.0.zip"
for archive in "$nature_zip" "$ruins_zip" "$town_zip" "$graveyard_zip"; do
	if [[ -f "$archive" ]]; then
		pass "source archive present and unmodified in place: $(basename "$archive")"
	else
		fail "source archive missing: $archive"
	fi
done

# The archive SHA-256 values recorded in assets/ASSET_REGISTER.md. If an archive
# itself changed, every byte-identity result below would be about a different
# thing.
check_archive_sha() {
	local archive="$1" expected="$2" found
	found="$(shasum -a 256 "$archive" 2>/dev/null | awk '{print $1}')"
	if [[ "$found" == "$expected" ]]; then
		pass "registered SHA-256 unchanged: $(basename "$archive")"
	else
		fail "$(basename "$archive") is $found, not the registered $expected"
	fi
}
check_archive_sha "$nature_zip"    "fa7974a0d342bfe63c38664ba9f8ec1a4aab8ea25f099bdc56870e33588c4d9d"
check_archive_sha "$ruins_zip"     "91299d428c9af7a402e3fc20f9e7781190aa2ff7ffbc7bd3e44cbb60b372acf6"
check_archive_sha "$town_zip"      "1a7530c09f4d2fa2cdee259876f089334f8b1f27fa86a0c4f54ef86cdd8676ef"
check_archive_sha "$graveyard_zip" "1a93613f2e5675f3310acf49ec9ef13ae7adeb756ac3b205bfb6cc9311a81062"

compare_zip() {
	local zip="$1" inside="$2" game_side="$3" a b
	a="$(unzip -p "$zip" "$inside" 2>/dev/null | shasum -a 256 | awk '{print $1}')"
	b="$(shasum -a 256 "$game_side" 2>/dev/null | awk '{print $1}')"
	[[ -n "$b" && "$a" == "$b" ]]
}

verbatim=0
mismatch=0
compare_one() {
	if compare_zip "$1" "$2" "$3"; then
		verbatim=$((verbatim + 1))
	else
		mismatch=$((mismatch + 1))
		printf '        MISMATCH %s\n' "${3#"$PROJECT_DIR"/assets/third_party/}"
	fi
}
for f in cliff_stone cliff_corner_stone cliff_top_stone ground_pathStraight ground_pathBend rock_largeC; do
	compare_one "$nature_zip" "Models/GLTF format/$f.glb" \
		"$PROJECT_DIR/assets/third_party/kenney/nature/$f.glb"
done
for f in Wall_Broken Wall_ArchRound_Broken Arch_Gothic Column_Round_Short Stairs Bricks; do
	compare_one "$ruins_zip" "Ultimate Modular Ruins Pack - Aug 2021/FBX/$f.fbx" \
		"$PROJECT_DIR/assets/third_party/quaternius/modular_ruins/$f.fbx"
done
for f in wall-broken wall-arch wall-half wall-corner pillar-stone stairs-stone; do
	compare_one "$town_zip" "Models/GLB format/$f.glb" \
		"$PROJECT_DIR/assets/third_party/kenney/fantasy_town/$f.glb"
done
for f in stone-wall-damaged stone-wall-column debris; do
	compare_one "$graveyard_zip" "Models/GLB format/$f.glb" \
		"$PROJECT_DIR/assets/third_party/kenney/graveyard/$f.glb"
done
printf '  extracted models compared against their archives: %s verbatim, %s mismatched\n' \
	"$verbatim" "$mismatch"
if [[ "$verbatim" == "21" && "$mismatch" == "0" ]]; then
	pass "all 21 selected models are byte-identical to their in-archive originals"
else
	fail "expected 21 verbatim models and 0 mismatches"
fi

# The two D-204 colour atlases, counted SEPARATELY from the 21 models so that
# restoring a dependency cannot quietly move the model pin. Size is asserted as
# well as hash: two files can only be byte-identical at the same length, but a
# stated byte count that is never checked is documentation, not evidence.
atlas_ok=0
compare_atlas() {
	local zip="$1" game_side="$2" want_bytes="$3" label="$4" bytes
	bytes="$(wc -c < "$game_side" 2>/dev/null | tr -d ' ')"
	if [[ "$bytes" == "$want_bytes" ]] \
		&& compare_zip "$zip" "Models/GLB format/Textures/colormap.png" "$game_side"; then
		atlas_ok=$((atlas_ok + 1))
		printf '        %s colormap.png  %s bytes, byte-identical to its archive\n' \
			"$label" "$bytes"
	else
		printf '        MISMATCH %s colormap.png (%s bytes, expected %s)\n' \
			"$label" "${bytes:-absent}" "$want_bytes"
	fi
}
compare_atlas "$town_zip" \
	"$PROJECT_DIR/assets/third_party/kenney/fantasy_town/Textures/colormap.png" \
	11143 "Fantasy Town"
compare_atlas "$graveyard_zip" \
	"$PROJECT_DIR/assets/third_party/kenney/graveyard/Textures/colormap.png" \
	10965 "Graveyard"
if [[ "$atlas_ok" == "2" ]]; then
	pass "both D-204 colour atlases are present, exactly sized, and byte-identical"
else
	fail "expected 2 verbatim D-204 colour atlases, found $atlas_ok"
fi

lic=0
compare_zip "$nature_zip" "License.txt" \
	"$PROJECT_DIR/assets/third_party/kenney/licenses/Kenney_Nature_Kit_2.1_License.txt" \
	&& lic=$((lic + 1)) || printf '        MISMATCH Kenney Nature License.txt\n'
compare_zip "$town_zip" "License.txt" \
	"$PROJECT_DIR/assets/third_party/kenney/licenses/Kenney_Fantasy_Town_Kit_2.0_License.txt" \
	&& lic=$((lic + 1)) || printf '        MISMATCH Kenney Fantasy Town License.txt\n'
compare_zip "$graveyard_zip" "License.txt" \
	"$PROJECT_DIR/assets/third_party/kenney/licenses/Kenney_Graveyard_Kit_5.0_License.txt" \
	&& lic=$((lic + 1)) || printf '        MISMATCH Kenney Graveyard License.txt\n'
compare_zip "$ruins_zip" "Ultimate Modular Ruins Pack - Aug 2021/License.txt" \
	"$PROJECT_DIR/assets/third_party/quaternius/licenses/Quaternius_Ultimate_Modular_Ruins_Pack_Aug_2021_License.txt" \
	&& lic=$((lic + 1)) || printf '        MISMATCH Quaternius License.txt\n'
if [[ "$lic" == "4" ]]; then
	pass "all four archive licences are verbatim copies with collision-free names"
else
	fail "only $lic of 4 licence copies are identical to their in-archive originals"
fi

# All four archives are CC0, so none obliges attribution the way the k0rveen
# CC BY 4.0 pack does. The project credits the creators anyway, and the source
# maps must say so.
for pair in "$PROJECT_DIR/assets/third_party/kenney/SOURCE_AND_LICENSE.md|www.kenney.nl" \
            "$PROJECT_DIR/assets/third_party/quaternius/SOURCE_AND_LICENSE.md|Quaternius"; do
	IFS='|' read -r note creator <<< "$pair"
	if [[ -f "$note" ]] && grep -qF "$creator" "$note" && grep -qF "CC0" "$note"; then
		pass "$(basename "$(dirname "$note")")/SOURCE_AND_LICENSE.md names its creator and CC0"
	else
		fail "$note is missing, or does not name $creator and CC0"
	fi
done

step "5. Nothing else was extracted, and nothing else was added"
third_party_payloads="$(find "$PROJECT_DIR/assets/third_party" -type f \
	! -name '*.import' ! -name '.DS_Store' ! -name '*.md' | wc -l | tr -d ' ')"
d202_source_maps=0
for note in "$PROJECT_DIR/assets/third_party/kenney/SOURCE_AND_LICENSE.md" \
	"$PROJECT_DIR/assets/third_party/quaternius/SOURCE_AND_LICENSE.md"; do
	[[ -f "$note" ]] && d202_source_maps=$((d202_source_maps + 1))
done
third_party_count=$((third_party_payloads + d202_source_maps))
printf '     62  third-party files the first Gate 1B spike left behind\n'
printf '   + 21  D-202 selected models\n'
printf '   +  4  D-202 verbatim archive licences\n'
printf '   +  2  D-204 colour atlases\n'
printf '   + 94  D-215 approved models and their .bin sidecars (47 + 47)\n'
printf '   +  2  D-216 LeLu Noise Pack textures (Greybox V2 + Visual Review)\n'
printf '   = %s  payload files (measured: %s)\n' "$EXPECTED_THIRD_PARTY_PAYLOADS" "$third_party_payloads"
printf '   +  %s  D-202 project-authored source maps\n' "$d202_source_maps"
printf '   = %s  (measured: %s)\n' "$EXPECTED_THIRD_PARTY" "$third_party_count"
if [[ "$third_party_payloads" == "$EXPECTED_THIRD_PARTY_PAYLOADS" \
	&& "$third_party_count" == "$EXPECTED_THIRD_PARTY" ]]; then
	pass "the third-party inventory is exactly 62 + 29 + 94 + 2 = $EXPECTED_THIRD_PARTY"
else
	fail "$third_party_payloads payloads and $d202_source_maps source maps exist; the authorized inventory is $EXPECTED_THIRD_PARTY_PAYLOADS + 2 = $EXPECTED_THIRD_PARTY"
fi

# §4 names its exclusions by hand. A file whose name matches one of them is a
# manifest breach, not a style question.
excluded="$(find "$PROJECT_DIR/assets/third_party/kenney/nature" \
	"$PROJECT_DIR/assets/third_party/kenney/fantasy_town" \
	"$PROJECT_DIR/assets/third_party/kenney/graveyard" \
	"$PROJECT_DIR/assets/third_party/quaternius/modular_ruins" -type f \
	\( -iname '*tree*' -o -iname '*grave*' -o -iname '*crypt*' -o -iname '*coffin*' \
	   -o -iname '*skull*' -o -iname '*bush*' -o -iname '*flower*' -o -iname '*roof*' \
	   -o -iname '*fountain*' -o -iname '*cart*' -o -iname '*windmill*' -o -iname '*banner*' \
	   -o -iname '*character*' -o -iname '*chest*' -o -iname '*trap*' -o -iname '*statue*' \
	   -o -iname '*candle*' -o -iname '*altar*' -o -iname '*urn*' -o -iname '*cross*' \
	   -o -iname '*bridge*' -o -iname '*water*' -o -iname '*tent*' -o -iname '*floor*' \) \
	2>/dev/null | wc -l | tr -d ' ')"
if [[ "$excluded" == "0" ]]; then
	pass "none of the §4 exclusions was extracted from any of the four archives"
else
	fail "$excluded excluded files were extracted"
fi

# The three registered archives D-202 deliberately keeps OUTSIDE the game project.
outside=0
for absent in "$PROJECT_DIR/assets/third_party/assetquest" \
	"$PROJECT_DIR/assets/third_party/kenney/cave" \
	"$PROJECT_DIR/assets/third_party/kenney/modular_cave" \
	"$PROJECT_DIR/assets/third_party/quaternius/medieval_village"; do
	[[ -e "$absent" ]] && outside=$((outside + 1))
done
if [[ "$outside" == "0" ]]; then
	pass "AssetQuest Forest, Kenney Modular Cave, and Quaternius Medieval Village stayed out"
else
	fail "$outside unauthorized candidate families entered the game project"
fi

audio="$(find "$PROJECT_DIR/assets/third_party/kenney" \
	"$PROJECT_DIR/assets/third_party/quaternius" \
	"$PROJECT_DIR/scenes/first_mvp/visual" "$PROJECT_DIR/scripts/first_mvp/visual" \
	\( -name '*.wav' -o -name '*.ogg' -o -name '*.mp3' \) 2>/dev/null | wc -l | tr -d ' ')"
if [[ "$audio" == "0" ]]; then
	pass "D-202 added no audio file; the comparison is silent by design"
else
	fail "$audio audio files exist under the D-202 trees"
fi

# The asset paths the comparison names must all be either an authorized D-202
# candidate or one of the already-registered §5.1 permanent anchors.
kit_used="$(grep -rohE 'res://assets/[a-zA-Z0-9_/]+\.[a-z]+' \
	"$PROJECT_DIR"/scripts/first_mvp/visual/exterior_cohesion_*.gd \
	"$PROJECT_DIR"/scenes/first_mvp/visual/exterior_cohesion_*.tscn \
	2>/dev/null | sort -u)"
printf '  asset paths any D-202 file names directly:\n'
printf '%s\n' "$kit_used" | sed 's/^/        /'
unregistered="$(printf '%s\n' "$kit_used" \
	| grep -vE 'assets/third_party/kenney/(nature|fantasy_town|graveyard|licenses)/' \
	| grep -vE 'assets/third_party/quaternius/(modular_ruins|licenses)/' \
	| grep -vE 'assets/third_party/kaykit/dungeon/(floor_tile_large|wall|wall_pillar)\.gltf' \
	| grep -vE 'assets/third_party/kaykit/(forest|halloween)/' \
	| grep -vE 'assets/third_party/(kenney|quaternius)/SOURCE_AND_LICENSE\.md' \
	| grep -c . | tr -d ' ')"
if [[ "$unregistered" == "0" ]]; then
	pass "only the §4 manifest and the already-registered §5.1 permanent anchors"
else
	fail "a D-202 file names an asset outside the authorized manifest"
fi

step "6. Gate 1B cohesion verification (headless)"
if "$GODOT" --headless --path "$PROJECT_DIR" "$COHESION_SCENE" -- --verify-1b-cohesion \
	> /tmp/riftwrought_cohesion_verify.log 2>&1; then
	:
fi
assert_no_script_error "the headless cohesion verification" /tmp/riftwrought_cohesion_verify.log

# THE PIN, applied to this suite's own count from the beginning. A suite that can
# only see the word PASS cannot see its own count move.
assert_cohesion_count() {
	local logfile="$1" found
	# The intermediate "N checks" step matters: the first number in
	# "GATE 1B COHESION VERIFICATION: ..." is the 1 of "1B", so extracting bare
	# digits from the whole line reads 1 and the pin would refuse every run
	# including a correct one. Same three-step shape as `check_count` above.
	found="$(grep -ohE "GATE 1B COHESION VERIFICATION: PASS \([0-9]+ checks\)" "$logfile" 2>/dev/null \
		| grep -ohE '[0-9]+ checks' | grep -ohE '[0-9]+' | head -1)"
	[[ -n "$found" && "$found" == "$EXPECTED_COHESION" ]]
}
# Proved in BOTH directions against a replay of this run's own log: a guard that
# accepts everything protects nothing.
cohesion_replay="$(mktemp -t riftwrought_cohesion_pin_replay)"
trap 'rm -f "$cohesion_replay"' EXIT
sed "s/GATE 1B COHESION VERIFICATION: PASS ($EXPECTED_COHESION checks)/GATE 1B COHESION VERIFICATION: PASS ($((EXPECTED_COHESION + 1)) checks)/" \
	/tmp/riftwrought_cohesion_verify.log > "$cohesion_replay"
if assert_cohesion_count "$cohesion_replay"; then
	fail "the $EXPECTED_COHESION pin accepted a replayed log reporting $((EXPECTED_COHESION + 1)) checks"
else
	pass "the pin rejects an altered replayed count ($((EXPECTED_COHESION + 1)) is refused)"
fi
if assert_cohesion_count /tmp/riftwrought_cohesion_verify.log; then
	grep -E "^  (centreline|threshold gap|baked surface|[0-9]+ combinations|walked|the stick)" \
		/tmp/riftwrought_cohesion_verify.log | sed 's/^/      /' || true
	grep -E "GATE 1B COHESION VERIFICATION: PASS" /tmp/riftwrought_cohesion_verify.log | sed 's/^/  /'
	pass "manifest, byte identity, licences, both D-204 colour atlases, source maps,
        the 62 + 29 = 91 inventory,
        measurements, import state, ONE composed route with three beats, all twelve mode
        combinations at identical navigation and clearance, complete traversal, click
        resolution, collision, the accepted locomotion and camera contract, controller
        arbitration, refused combat inputs, both review states, three non-destructive
        material cycles, every toggle, the reset, scope, storage, the untouched closed
        gates, and the visible surfaces"
else
	fail "the cohesion verification did not pass at $EXPECTED_COHESION checks"
	grep -E "FAIL:|VERIFICATION" /tmp/riftwrought_cohesion_verify.log | sed 's/^/        /' || true
	tail -20 /tmp/riftwrought_cohesion_verify.log | sed 's/^/        /'
fi

step "7. The comparison writes nothing, and the storage guard still refuses production"
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
	> /tmp/riftwrought_cohesion_guard.log 2>&1; then
	fail "the storage guard accepted the production directory"
else
	if grep -qE "refusing to start|own user data directory" /tmp/riftwrought_cohesion_guard.log; then
		pass "the D-192 guard still refuses the production directory, without writing"
	else
		fail "the storage guard did not report a refusal"
		tail -10 /tmp/riftwrought_cohesion_guard.log | sed 's/^/        /'
	fi
fi

# No SHIPPING first-MVP file may name a user:// path or a config store at all. The
# two verifications are excluded by construction rather than by name: they live
# under tests/, not under scripts/first_mvp/.
leaks="$(grep -rlE 'user://|ConfigFile|ResourceSaver' \
	"$PROJECT_DIR/scripts/first_mvp" "$PROJECT_DIR/scenes/first_mvp" \
	"$PROJECT_DIR/data/first_mvp" 2>/dev/null \
	| grep -v 'gate_1a_verification.gd' | wc -l | tr -d ' ')"
printf '  shipping first-MVP files naming a user:// path, ConfigFile, or ResourceSaver: %s\n' "$leaks"
if [[ "$leaks" == "0" ]]; then
	pass "no first-MVP scene or script has storage of any kind"
else
	fail "a first-MVP file reaches persistent storage"
	grep -rlE 'user://|ConfigFile|ResourceSaver' \
		"$PROJECT_DIR/scripts/first_mvp" "$PROJECT_DIR/scenes/first_mvp" \
		"$PROJECT_DIR/data/first_mvp" 2>/dev/null \
		| grep -v 'gate_1a_verification.gd' | sed 's/^/        /'
fi

# The pattern matches CALLS, not the forbidden-string list the verification
# carries in order to forbid them.
verify_calls="$(grep -cE 'ConfigFile\.new|ResourceSaver\.save|FileAccess\.open\(|\.store_string\(|\.store_line\(' \
	"$PROJECT_DIR/tests/gate_1b_exterior_cohesion_verification.gd" | tr -d ' ')"
printf '  writing storage calls in the cohesion verification itself: %s\n' "$verify_calls"
if [[ "$verify_calls" == "0" ]]; then
	pass "the verification only READS — source, licences, and archives — and writes PNGs into --shots"
else
	fail "the cohesion verification opens persistent storage for writing"
fi

step "8. Only the D-208 Gate 1C, D-216 accepted-foundation, and D-217 Gate 1D paths exist"
# D-208 §11.2 REPLACES THIS ASSERTION ONE FOR ONE. Until Gate 1C this step asked
# whether ANY Riftfall or Severed file existed and required the answer to be none,
# which was the right question for D-202. Gate 1C authorizes exactly the files its
# §3 lists, so that claim became false BY AUTHORIZATION rather than by drift, and
# it became the next honest boundary instead. D-216 (the project owner's
# acceptance of Riftfall Landing Greybox V2 + Visual Review as the development-
# ready placeholder foundation) and D-217 (Gate 1D, Broken Watch) each move that
# boundary again, the same way: every path below may exist, every other route
# file still may not, and neither closed Gate 1B scene may name any part of it.
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
# `.uid` sidecars are Godot's own, generated beside every script; they are folded
# onto the file they belong to rather than counted as unauthorized route files.
route_files="$(cd "$PROJECT_DIR" && find scenes/first_mvp scripts/first_mvp data/first_mvp \
	\( -iname '*severed*' -o -iname '*riftfall*' -o -iname '*broken_watch*' \
	   -o -iname '*nexus*' -o -iname '*run_graph*' -o -iname '*module_library*' \
	   -o -iname '*canonical_opening*' -o -iname '*rift_anchor*' -o -iname '*mara*' \
	   -o -iname '*dialogue*' -o -iname '*first_footing*' \) \
	2>/dev/null | sed 's/\.uid$//' | sort -u)"
unauthorized="$(printf '%s\n' "$route_files" | grep -v '^$' \
	| grep -vxF "$authorized_route_paths" | wc -l | tr -d ' ')"
missing_1c=0
while IFS= read -r wanted; do
	[[ -e "$PROJECT_DIR/$wanted" ]] || missing_1c=$((missing_1c + 1))
done <<< "$authorized_route_paths"
# And the closed Gate 1B scenes stay ISOLATED from it: neither may instance, load
# or even name a Gate 1C scene, script or class.
# THE TOKENS ARE IDENTIFIERS AND PATHS, NEVER PROSE, and that distinction is the
# whole guard. Both closed Gate 1B scripts say "not riftfall landing" — one in a
# documentation heading, one in a `log_event` line the cohesion verification itself
# asserts reaches the screen — because stating the boundary is precisely what they
# are supposed to do. A scan for the words "riftfall landing" therefore fails on the
# sentence that makes the claim, which the first version of this guard did, twice.
# What must not appear is a REFERENCE: a Gate 1C class name, script stem or path.
# None of those can occur in English prose.
gate_1c_leaks="$(grep -rlE 'RiftfallLanding|RiftfallLoopEvent|riftfall_landing|riftfall_loop_event|severed_threshold' \
	"$PROJECT_DIR"/scenes/first_mvp/visual "$PROJECT_DIR"/scripts/first_mvp/visual \
	2>/dev/null | wc -l | tr -d ' ')"
if [[ "$gate_1c_leaks" != "0" ]]; then
	grep -rlE 'RiftfallLanding|RiftfallLoopEvent|riftfall_landing|riftfall_loop_event|severed_threshold' \
		"$PROJECT_DIR"/scenes/first_mvp/visual "$PROJECT_DIR"/scripts/first_mvp/visual \
		2>/dev/null | sed "s|^$PROJECT_DIR/|        Gate 1B file references Gate 1C: |"
fi
printf '  route files found: %s; unauthorized: %s; Gate 1C paths missing: %s; Gate 1B references to Gate 1C: %s\n' \
	"$(printf '%s\n' "$route_files" | grep -vc '^$' || true)" \
	"$unauthorized" "$missing_1c" "$gate_1c_leaks"
if [[ "$unauthorized" == "0" && "$missing_1c" == "0" && "$gate_1c_leaks" == "0" ]]; then
	pass "only the D-208 Gate 1C, D-216 accepted-foundation, and D-217 Gate 1D paths
        exist; the Nexus Threshold, the Rift Nexus, the run graph and the module
        library remain unstarted, and neither closed Gate 1B scene names any part
        of Gate 1C"
else
	fail "$unauthorized unauthorized route file(s), $missing_1c missing Gate 1C path(s), $gate_1c_leaks Gate 1B reference(s) to Gate 1C"
	printf '%s\n' "$route_files" | grep -v '^$' | grep -vxF "$authorized_route_paths" | sed 's/^/        /'
fi
if [[ -f "$REPO_DIR/docs/testing/FIRST_MVP_VERTICAL_SLICE_REPORT.md" ]]; then
	fail "a first-MVP vertical-slice report exists; that work is not authorized"
else
	pass "the first-MVP vertical slice has not been started"
fi

if [[ -n "$shots_dir" ]]; then
	step "9. Rendered evidence at 1920 x 1080 and at the 1280 x 720 minimum window"
	if "$GODOT" --path "$PROJECT_DIR" --resolution 1920x1080 "$COHESION_SCENE" \
		-- --verify-1b-cohesion --shots "$shots_dir" \
		> /tmp/riftwrought_cohesion_shots_full.log 2>&1; then
		:
	fi
	assert_no_script_error "the rendered 1920 x 1080 run" /tmp/riftwrought_cohesion_shots_full.log
	if assert_cohesion_count /tmp/riftwrought_cohesion_shots_full.log; then
		grep -E "GATE 1B COHESION VERIFICATION: PASS" /tmp/riftwrought_cohesion_shots_full.log | sed 's/^/  /'
		pass "the rendered run passes at $EXPECTED_COHESION and writes the 1920 x 1080 evidence"
	else
		fail "the rendered 1920 x 1080 run did not pass at $EXPECTED_COHESION"
		grep -E "FAIL:" /tmp/riftwrought_cohesion_shots_full.log | sed 's/^/        /' || true
	fi

	# §8 and §9.7: the same assertions must hold, and the overlay must still be
	# readable, at the minimum tested window.
	if "$GODOT" --path "$PROJECT_DIR" --resolution 1280x720 "$COHESION_SCENE" \
		-- --verify-1b-cohesion --shots "$shots_dir" --shots-brief \
		> /tmp/riftwrought_cohesion_shots_small.log 2>&1; then
		:
	fi
	assert_no_script_error "the rendered 1280 x 720 run" /tmp/riftwrought_cohesion_shots_small.log
	if assert_cohesion_count /tmp/riftwrought_cohesion_shots_small.log; then
		grep -E "overlay root" /tmp/riftwrought_cohesion_shots_small.log | sed 's/^/      /' || true
		grep -E "GATE 1B COHESION VERIFICATION: PASS" /tmp/riftwrought_cohesion_shots_small.log | sed 's/^/  /'
		pass "every surface is still on screen at 1280 x 720"
	else
		fail "the rendered 1280 x 720 run did not pass at $EXPECTED_COHESION"
		grep -E "FAIL:" /tmp/riftwrought_cohesion_shots_small.log | sed 's/^/        /' || true
	fi

	# §8 names eight required views. Each is checked to exist and to be a real
	# frame rather than an empty file.
	missing_shot=0
	for stem in 1_kaykit_baseline_neutral 2_kaykit_baseline_treatment \
		3a_topology_off 3b_topology_on \
		4a_quaternius_neutral 4b_quaternius_treatment \
		5a_kenney_town_neutral 5b_kenney_town_treatment \
		6a_dressing_off 6b_dressing_on \
		7a_knight_grid_kaykit 7b_knight_grid_quaternius 7c_knight_grid_kenney_town \
		8a_route_from_the_arrival 8b_route_at_the_threshold \
		8c_whole_route_slice 8d_whole_route_slice_neutral; do
		shot="$shots_dir/gate_1b_cohesion_${stem}_1920x1080.png"
		if [[ -f "$shot" ]] && [[ "$(wc -c < "$shot" | tr -d ' ')" -gt 20000 ]]; then
			printf '  PASS  §8 view: %s (%s bytes)\n' "$stem" "$(wc -c < "$shot" | tr -d ' ')"
		else
			missing_shot=$((missing_shot + 1))
			fail "§8 required view missing or empty: $stem"
		fi
	done
	if [[ "$missing_shot" == "0" ]]; then
		pass "all seventeen §8 required views rendered at 1920 x 1080"
	fi
	small_shots="$(ls "$shots_dir"/*_1280x720.png 2>/dev/null | wc -l | tr -d ' ')"
	if [[ "$small_shots" -ge 10 ]]; then
		pass "$small_shots frames also rendered at the 1280 x 720 minimum tested window"
	else
		fail "only $small_shots frames rendered at 1280 x 720"
	fi
	printf '  evidence written to %s (%s files)\n' \
		"$shots_dir" "$(ls "$shots_dir" | wc -l | tr -d ' ')"
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
	printf 'GATE 1B COHESION SMOKE CHECKS: PASS\n'
	cat <<'NOTE'
Automated checks cannot decide whether a family belongs in Riftwrought, and that
is what this comparison is FOR. GATE 1B REMAINS OPEN. Only the project owner can
decide whether Kenney Nature provides useful topology, whether Quaternius Modular
Ruins or Kenney Fantasy Town should carry focal Broken Watch architecture, whether
the three-piece Kenney Graveyard layer adds history without turning the route into
a cemetery, and which single terrain family and which single architectural family
should proceed into Riftfall Landing paper design. The mouse and controller
playtest is in
docs/testing/FIRST_MVP_GATE_1B_EXTERIOR_COHESION_COMPARISON_REPORT.md §11.
No result authorizes Riftfall Landing construction. Do not begin the Severed
Threshold route.
NOTE
	exit 0
else
	printf 'GATE 1B COHESION SMOKE CHECKS: %d FAILURE(S)\n' "$failures"
	exit 1
fi
