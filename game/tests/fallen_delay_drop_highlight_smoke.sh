#!/usr/bin/env bash
# Riftwrought — First-MVP UI J5: Fallen-Delay Ground-Drop Highlight Clearing V1 smoke checks (decision D-330).
#
# THIS IS NOT A GATE, AND IT RUNS NO LOCKED CHAIN.
#
# J5 changes exactly one line of one production file: the not-alive branch of Gate 1D's
# `BrokenWatchSlice._update_drop_nameplate()` now calls the ground drop's existing
# `set_soft_targeted(false)` before it returns, so a fallen character's drop loses its controller
# highlight from the slice's first process update after the lethal Hit. What this script proves:
#
#   1. the new verification, the slice and the four accepted verifications J5 moved parse;
#   2. the slice and the six accepted suite files J5 moved are at their D-330 hashes, and no other
#      production file has changed since D-329 — one digest over every file under scripts/, scenes/,
#      data/, addons/ and assets/ and project.godot, the slice excepted;
#   3. the pinned verification passes headless, proved in BOTH directions against a replay of its
#      own log — its check count, its owed count and the exact owed SET — with the measured lines
#      read out of the log, zero SCRIPT ERROR and zero engine ERROR, and no engine WARNING but the
#      accepted ones counted exactly;
#   4. the same verification passes rendered at 1920x1080 and at the 1280x720 minimum window, at the
#      SAME pinned count and owed set, each reporting the window it was given and saving its two
#      evidence frames — into this run's temporary directory, or with `--shots <dir>` into <dir> and
#      <dir>/1280x720;
#   5. `project.godot` is untouched: 31 actions, the Prototype App entrypoint, the same nine
#      sections, no `[autoload]`;
#   6. every file this work stands beside and the whole `.godot/` directory are BYTE-IDENTICAL
#      across the run, and the project owner's own user:// files are untouched.
#
# Everything this script writes goes into one `mktemp -d` directory, removed on every exit — Godot's
# own file log included — except the evidence frames when `--shots` names a directory.
#
# Usage, from the repository root:
#   game/tests/fallen_delay_drop_highlight_smoke.sh
#   game/tests/fallen_delay_drop_highlight_smoke.sh --shots docs/testing/fallen_delay_drop_highlight_evidence

set -uo pipefail

# Assigned at the TOP of the script, never beside the function it serves.
RUN_STARTED_AT="$(date +%s)"

reached_end=0
scratch=()
on_exit() {
	local code=$?
	for path in "${scratch[@]+"${scratch[@]}"}"; do
		rm -rf "$path"
	done
	if [[ "$reached_end" != "1" ]]; then
		printf '\nFALLEN DELAY DROP HIGHLIGHT SMOKE CHECKS: ABORTED before the end of the script\n'
		printf '  the run stopped early (exit %s) — nothing after that point was proved\n' "$code"
		exit 1
	fi
	exit "$code"
}
trap on_exit EXIT

GODOT="${GODOT:-/Applications/Godot.app/Contents/MacOS/Godot}"
EXPECTED_VERSION="4.7.2.stable"
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Pinned, and proved in both directions below. ONE number: the evidence frames add no assertion, so
# the headless and both rendered runs must agree.
EXPECTED_CHECKS=19
EXPECTED_OWED_CHECKS=17
OWED_SET="the_production_diff_is_exactly_the_one_authorized_line, the_accepted_suites_moved_only_their_slice_pins, the_line_sits_in_the_not_alive_branch_before_its_return, the_reach_is_gate_1d_and_its_descendants_by_inheritance, no_scene_input_map_or_project_setting_changed, a_production_graveblade_death_creates_the_guaranteed_drop, a_living_controller_player_in_range_soft_selects_the_drop, production_graveblade_attacks_kill_the_player_and_arm_the_delay, the_lethal_frame_is_read_before_any_process_or_drawn_frame, the_first_process_update_clears_the_highlight, the_highlight_stays_cleared_through_the_delay_as_the_countdown_falls, the_j4_controller_direct_and_mouse_refusals_still_hold, behind_the_fallen_overlay_the_highlight_stays_cleared, after_a_normal_restart_range_and_family_still_drive_the_highlight, a_living_comparison_and_equip_still_work_exactly_once, f5_in_a_later_delay_still_cancels_before_the_revival, the_guaranteed_drop_latch_still_permits_one_drop"
VERIFICATION_TIMEOUT=600

EXPECTED_INPUT_ACTIONS=31
EXPECTED_MAIN_SCENE="res://scenes/app/prototype_app.tscn"
EXPECTED_SECTIONS="application audio debug display editor_plugins input layer_names navigation rendering"

# Every production file but the slice, as it stood at the end of D-329: 870 files under scripts/,
# scenes/, data/, addons/ and assets/ and project.godot, each line `sha256  path`, sorted, digested.
# First-MVP UI J6 (D-332) moved it one for one, from 77573cd0, when the combat HUD moved.
# First-MVP UI J7 (D-334) moved it again, from b87a3669, when the combat HUD moved.
# First-MVP UI J8 (D-336) moved it again, from e6b55fec, when the combat HUD moved.
# First-MVP Gameplay J10 (D-340) moved it again, from 658bcd6a, when Broken Watch's layout moved.
EXPECTED_PRODUCTION_FILES=870
EXPECTED_PRODUCTION_DIGEST="d875eae9fd51cfa5593dcb80692ba4cff9ec3dc3f29f595808b074bd63aa0843"

# Engine warnings the verification may print, each with the exact number of times it must appear:
# the accepted navigation bake's two precision lines once each for the one scene it loads, and Gate
# 1D's own startup probe, which may report once that its map was not yet queryable within its own 40
# physics frames — the unchanged `BrokenWatchSlice._await_navigation_synchronized()` inside the
# slice's own `_ready()`, before any J5 check runs; the suite waits for the map itself before it acts.
BAKE_CLIMB="WARNING: Property agent_max_climb is floored to cell_height voxel units and loses precision."
BAKE_RADIUS="WARNING: Property agent_radius is ceiled to cell_size voxel units and loses precision."
SLICE_PROBE="WARNING: BrokenWatchSlice: the navigation map did not become queryable"
EXPECTED_BAKE_LINES=1
MOST_SLICE_PROBES=1

THIS_VERIFICATION="tests/fallen_delay_drop_highlight_verification.gd"
SLICE="scripts/first_mvp/severed_threshold/broken_watch_slice.gd"
J1_VERIFICATION="tests/first_mvp_modal_left_click_verification.gd"
J2_VERIFICATION="tests/fallen_modal_life_state_verification.gd"
J3_VERIFICATION="tests/pending_fallen_restart_verification.gd"
J3_SMOKE="tests/pending_fallen_restart_smoke.sh"
J4_VERIFICATION="tests/fallen_delay_item_interaction_verification.gd"
J4_SMOKE="tests/fallen_delay_item_interaction_smoke.sh"

# First-MVP UI J6 (D-332) moved five of them again, one for one, from ca594f7d, b2cfc253, 6e4120a3, 7ad7dd67 and ffbb4b7b, when the combat HUD moved.
# First-MVP UI J7 (D-334) moved the same five again, one for one, from f065a48d, 68a1227e, f7b48202, 308fe51a and b7ff3d66, when the combat HUD moved.
# First-MVP UI J8 (D-336) moved the same five again, one for one, from eb7f4153, 520d9543, 67cf7ba9, 611891a3 and d7cf4498, when the combat HUD moved.
# First-MVP Gameplay J9 (D-338) moved all seven again, one for one, from f83e9436, 8c0e290c, d5407c7c, 1062c1db, 689284cc, 3deeb26a and cb520369, when Gate 1D's slice moved.
# First-MVP Gameplay J10 (D-340) moved all seven again, one for one, from 942aee83, acbd3892, 6acc1e0c, dc9be60f, ec5bc37f, eff592af and e14e996b, when Gate 1D's slice moved.
# Verification Maintenance V1 (D-342) moved one of them again, from 5c8e9b07, when their put-back pairs moved into the flat provenance store.
# First-MVP Gameplay J11 (D-344) moved this runner's rows again, one for one, when Gate 1D's slice came to open Riftfall Landing's Watch Breach far cap in its own composition.
D330_ROWS=(
	"$SLICE|d4e839fb"
	"$J1_VERIFICATION|d12ad271"
	"$J2_VERIFICATION|72e39a8a"
	"$J3_VERIFICATION|7d0e3f08"
	"$J3_SMOKE|54a4464a"
	"$J4_VERIFICATION|8aad4262"
	"$J4_SMOKE|939d9b48"
)

# Fingerprinted before and after the run: the changed file, this verification, the six accepted suite
# files J5 moved and every other suite that reads the slice beside them, everything the verification
# pins as unchanged, the project owner's composed zone, and the two handoff documents.
PRESERVED_FILES=(
	"$SLICE"
	"$THIS_VERIFICATION"
	"$J1_VERIFICATION"
	"tests/first_mvp_modal_left_click_smoke.sh"
	"$J2_VERIFICATION"
	"tests/fallen_modal_life_state_smoke.sh"
	"$J3_VERIFICATION"
	"$J3_SMOKE"
	"$J4_VERIFICATION"
	"$J4_SMOKE"
	"tests/gate_1d_broken_watch_verification.gd"
	"tests/gate_1d_broken_watch_smoke.sh"
	"tests/gate_1e_canonical_opening_verification.gd"
	"tests/roguelite_core_loop_verification.gd"
	"tests/roguelite_experience_collection_review_verification.gd"
	"tests/roguelite_level_up_choice_review_verification.gd"
	"tests/roguelite_live_effect_review_verification.gd"
	"tests/roguelite_repeated_live_effect_loop_verification.gd"
	"project.godot"
	"scenes/first_mvp/zone_composer_practice.tscn"
	"../CLAUDE.md"
	"../README.md"
	"scripts/actors/prototype_player.gd"
	"scripts/ui/first_mvp_modal.gd"
	"scripts/ui/first_mvp_fallen_overlay.gd"
	"scripts/roguelite/roguelite_fallen_overlay.gd"
	"scripts/ui/first_mvp_item_comparison.gd"
	"scripts/ui/first_mvp_combat_hud.gd"
	"scripts/first_mvp/canonical_opening/canonical_opening_runtime.gd"
	"scripts/roguelite/roguelite_core_loop_runtime.gd"
	"scripts/roguelite/experience/roguelite_experience_collection_review.gd"
	"scripts/roguelite/level_up/roguelite_level_up_choice_review.gd"
	"scripts/roguelite/live_effects/roguelite_live_effect_review.gd"
	"scripts/roguelite/replayability/roguelite_replayability_runtime.gd"
	"scripts/roguelite/build_variety/roguelite_build_variety_runtime.gd"
	"scripts/prototype_zero/prototype_zero.gd"
	"scripts/actors/prototype_graveblade.gd"
	"scripts/combat/quick_strike_action.gd"
	"scripts/combat/attack_coordinator.gd"
	"scripts/combat/damage_event.gd"
	"scripts/combat/target_acquisition.gd"
	"scripts/combat/prototype_targetable.gd"
	"scripts/movement/prototype_locomotion.gd"
	"scripts/movement/prototype_ground_pointer.gd"
	"scripts/movement/prototype_mouse_hold.gd"
	"scripts/items/first_mvp_item_drop.gd"
	"scripts/items/player_loadout.gd"
	"scripts/first_mvp/severed_threshold/broken_watch_layout.gd"
	"scripts/prototype_zero/destination_marker.gd"
	"scripts/camera/prototype_camera_rig.gd"
	"scripts/input/input_family_tracker.gd"
	"scenes/first_mvp/severed_threshold/broken_watch_slice.tscn"
	"scenes/actors/prototype_player.tscn"
	"scenes/actors/prototype_graveblade.tscn"
	"scenes/first_mvp/canonical_opening/canonical_opening.tscn"
	"scenes/roguelite/roguelite_core_loop.tscn"
	"data/prototype_zero/graveblade.tres"
	"data/first_mvp/severed_threshold/broken_watch/starting_sword.tres"
	"data/first_mvp/severed_threshold/broken_watch/watchsteel_sword.tres"
)

failures=0
step() { printf '\n=== %s\n' "$1"; }
pass() { printf '  PASS  %s\n' "$1"; }
fail() { printf '  FAIL  %s\n' "$1"; failures=$((failures + 1)); }

fingerprint() {
	if [[ -f "$1" ]]; then
		shasum -a 256 "$1" | awk '{print $1}'
	else
		echo "MISSING"
	fi
}

state_fingerprint() {
	if [[ -f "$1" ]]; then
		printf '%s bytes, sha256 %s, mtime %s' \
			"$(wc -c < "$1" | tr -d ' ')" \
			"$(shasum -a 256 "$1" | cut -d' ' -f1)" \
			"$(stat -f %m "$1")"
	else
		printf 'absent'
	fi
}

# Every file under `.godot/`, by path and content, folded into one digest, and the file count.
godot_fingerprint() {
	(cd "$PROJECT_DIR" && find .godot -type f -print0 | sort -z | xargs -0 shasum -a 256 | shasum -a 256 | cut -d' ' -f1)
}
godot_file_count() {
	find "$PROJECT_DIR/.godot" -type f | wc -l | tr -d ' '
}

# Every production file but the slice, by path and content: the listing, then its digest and count.
production_listing() {
	(cd "$PROJECT_DIR" && find scripts scenes data addons assets project.godot -type f ! -path "$SLICE" -print0 \
		| sort -z | xargs -0 shasum -a 256)
}

assert_no_script_error() {
	local what="$1" logfile="$2" found
	found="$(grep -cE "SCRIPT ERROR|String formatting error|Parse Error" "$logfile" 2>/dev/null | tr -d ' ')"
	if [[ "$found" == "0" ]]; then
		pass "$what produced no SCRIPT ERROR"
	else
		fail "$what produced $found script error line(s)"
		grep -A3 -E "SCRIPT ERROR|String formatting error|Parse Error" "$logfile" | head -20 | sed 's/^/        /'
	fi
}

# Engine ERROR lines are refused outright; every WARNING must be one of the three accepted lines,
# the two bake lines exactly EXPECTED_BAKE_LINES times each and the slice's probe at most
# MOST_SLICE_PROBES times.
assert_engine_output() {
	local what="$1" logfile="$2" errors climb radius probe others
	errors="$(grep -cE "^ERROR:" "$logfile" 2>/dev/null | tr -d ' ')"
	if [[ "$errors" == "0" ]]; then
		pass "$what produced no engine ERROR line"
	else
		fail "$what produced $errors engine ERROR line(s)"
		grep -A2 -E "^ERROR:" "$logfile" | head -20 | sed 's/^/        /'
	fi
	climb="$(grep -cxF "$BAKE_CLIMB" "$logfile" | tr -d ' ')"
	radius="$(grep -cxF "$BAKE_RADIUS" "$logfile" | tr -d ' ')"
	probe="$(grep -cxF "$SLICE_PROBE" "$logfile" | tr -d ' ')"
	others="$(grep -E "^WARNING:" "$logfile" | grep -vxF "$BAKE_CLIMB" | grep -vxF "$BAKE_RADIUS" \
		| grep -vxF "$SLICE_PROBE" | wc -l | tr -d ' ')"
	if [[ "$climb" == "$EXPECTED_BAKE_LINES" && "$radius" == "$EXPECTED_BAKE_LINES" \
			&& "$probe" -le "$MOST_SLICE_PROBES" && "$others" == "0" ]]; then
		pass "$what printed each bake warning $EXPECTED_BAKE_LINES time (one scene), Gate 1D's startup probe $probe time(s), and no other WARNING"
	else
		fail "$what printed bake lines $climb / $radius, the slice's probe $probe time(s), and $others other warning(s)"
		grep -E "^WARNING:" "$logfile" | grep -vxF "$BAKE_CLIMB" | grep -vxF "$BAKE_RADIUS" | head -5 | sed 's/^/        /'
	fi
}

assert_log_is_fresh() {
	local logfile="$1" written
	if [[ ! -f "$logfile" ]]; then
		fail "$logfile was never written"
		return
	fi
	written="$(stat -f %m "$logfile" 2>/dev/null || echo 0)"
	if [[ "$written" -ge "$RUN_STARTED_AT" ]]; then
		pass "$(basename "$logfile") was written by THIS run"
	else
		fail "$(basename "$logfile") is older than this run — a stale log answered for it"
	fi
}

read_check_count() {
	grep -ohE "$1: PASS \([0-9]+ checks\)" "$2" \
		| grep -ohE '[0-9]+ checks' | grep -ohE '[0-9]+' | head -1
}

run_verification() {
	local logfile="$1"
	shift
	perl -e 'alarm shift; exec @ARGV' "$VERIFICATION_TIMEOUT" "$GODOT" "$@" > "$logfile" 2>&1
}

BANNER="FALLEN DELAY DROP HIGHLIGHT VERIFICATION"

work="$(mktemp -d -t riftwrought_j5)"
scratch+=("$work")

SHOT_DIR="$work/shots"
if [[ "${1:-}" == "--shots" && -n "${2:-}" ]]; then
	mkdir -p "$2" && SHOT_DIR="$(cd "$2" && pwd)"
fi
mkdir -p "$SHOT_DIR/1280x720"

printf 'Riftwrought — First-MVP UI J5: Fallen-Delay Ground-Drop Highlight Clearing V1 smoke checks (D-330)\n'
printf 'project: %s\n' "$PROJECT_DIR"
printf 'evidence frames: %s\n' "$SHOT_DIR"

# --------------------------------------------------------------------------
step "0. Engine, and a fingerprint of everything this work must not disturb"

installed="$("$GODOT" --version 2>/dev/null | tail -1)"
printf '  installed: %s\n' "$installed"
if [[ "$installed" == "$EXPECTED_VERSION"* ]]; then
	pass "matches the locked $EXPECTED_VERSION baseline"
else
	fail "expected $EXPECTED_VERSION, found $installed"
fi

declare -a BEFORE_HASHES
missing_preserved=0
for i in "${!PRESERVED_FILES[@]}"; do
	BEFORE_HASHES[$i]="$(fingerprint "$PROJECT_DIR/${PRESERVED_FILES[$i]}")"
	if [[ "${BEFORE_HASHES[$i]}" == "MISSING" ]]; then
		fail "protected file ${PRESERVED_FILES[$i]} does not exist"
		missing_preserved=$((missing_preserved + 1))
	fi
done
if [[ "$missing_preserved" == "0" ]]; then
	pass "${#PRESERVED_FILES[@]} protected file(s) fingerprinted"
fi

godot_before="$(godot_fingerprint)"
godot_count_before="$(godot_file_count)"
pass ".godot/ fingerprinted: $godot_count_before files"

project_name="$(sed -n 's/^config\/name="\(.*\)"[[:space:]]*$/\1/p' "$PROJECT_DIR/project.godot" | head -1)"
production_dir="$HOME/Library/Application Support/Godot/app_userdata/$project_name"
settings_before="$(state_fingerprint "$production_dir/prototype_settings.cfg")"
lab_before="$(state_fingerprint "$production_dir/prototype_zero.cfg")"
character_before="$(state_fingerprint "$production_dir/riftwrought_character.cfg")"
pass "the project owner's own three user:// files fingerprinted"

# --------------------------------------------------------------------------
step "1. The new verification, the slice and the four moved verifications parse"

for relative in "$THIS_VERIFICATION" "$SLICE" "$J1_VERIFICATION" "$J2_VERIFICATION" "$J3_VERIFICATION" "$J4_VERIFICATION"; do
	out="$("$GODOT" --headless --path "$PROJECT_DIR" --log-file "$work/parse.log" --check-only --script "res://$relative" 2>&1 \
		| grep -v '^Godot Engine')"
	if [[ -z "$out" ]]; then
		pass "$relative parses"
	else
		fail "$relative does not parse"
		printf '%s\n' "$out" | head -10 | sed 's/^/        /'
	fi
done

# --------------------------------------------------------------------------
step "2. The slice and the six moved suite files are at their D-330 hashes; no other production file moved"

for row in "${D330_ROWS[@]}"; do
	relative="${row%%|*}"
	prefix="${row##*|}"
	actual="$(fingerprint "$PROJECT_DIR/$relative")"
	if [[ "$actual" == "$prefix"* ]]; then
		pass "$relative is at $prefix"
	else
		fail "$relative is at ${actual:0:8}, not $prefix"
	fi
done
for runner in "$J3_SMOKE" "$J4_SMOKE" "tests/fallen_delay_drop_highlight_smoke.sh"; do
	if [[ -x "$PROJECT_DIR/$runner" ]]; then
		pass "$runner is executable"
	else
		fail "$runner is not executable"
	fi
done

listing="$work/production.txt"
production_listing > "$listing"
production_files="$(wc -l < "$listing" | tr -d ' ')"
production_digest="$(shasum -a 256 < "$listing" | cut -d' ' -f1)"
if [[ "$production_files" == "$EXPECTED_PRODUCTION_FILES" && "$production_digest" == "$EXPECTED_PRODUCTION_DIGEST" ]]; then
	pass "every other production file is as D-329 left it, but for the combat HUD, which J6 moved (D-332), and Broken Watch's layout, which J10 moved (D-340): $production_files files, digest ${production_digest:0:8}"
else
	fail "the production tree outside the slice moved: $production_files files, digest ${production_digest:0:8}, not $EXPECTED_PRODUCTION_FILES / ${EXPECTED_PRODUCTION_DIGEST:0:8}"
fi
# A guard that accepts everything protects nothing: one byte appended to one listed file's line must
# change the digest the pin reads.
moved_digest="$(sed '1s/$/x/' "$listing" | shasum -a 256 | cut -d' ' -f1)"
if [[ "$moved_digest" != "$EXPECTED_PRODUCTION_DIGEST" && "$moved_digest" != "$production_digest" ]]; then
	pass "and that pin refuses a listing with one line moved (${moved_digest:0:8})"
else
	fail "the production pin accepts a moved listing and therefore proves nothing"
fi

# --------------------------------------------------------------------------
step "3. The pinned verification passes headless, proved in BOTH directions"

verify_log="$work/verify.log"
run_verification "$verify_log" --headless --path "$PROJECT_DIR" --log-file "$work/godot_file.log" \
	--script "res://$THIS_VERIFICATION"
verify_status=$?
printf '  verification exit status: %s\n' "$verify_status"
assert_log_is_fresh "$verify_log"
assert_no_script_error "the headless verification" "$verify_log"
assert_engine_output "the headless verification" "$verify_log"

if [[ "$verify_status" == "0" ]]; then
	pass "the verification exited 0"
elif [[ "$verify_status" == "142" ]]; then
	fail "the verification did not finish within $VERIFICATION_TIMEOUT s and was killed"
else
	fail "the verification exited $verify_status"
	grep -E "FAIL:" "$verify_log" | head -20 | cut -c1-300 | sed 's/^/        /'
fi

count="$(read_check_count "$BANNER" "$verify_log")"
if [[ "$count" == "$EXPECTED_CHECKS" ]]; then
	pass "verification passes at the pinned $EXPECTED_CHECKS checks"
else
	fail "verification reports ${count:-no} checks, not $EXPECTED_CHECKS"
fi

# A guard that accepts everything protects nothing: each pin must refuse a replay of this run's own
# log with its value moved, and must READ the moved value.
replay="$work/replay.log"
sed "s/$BANNER: PASS ($EXPECTED_CHECKS checks)/$BANNER: PASS ($((EXPECTED_CHECKS + 1)) checks)/" \
	"$verify_log" > "$replay"
replay_count="$(read_check_count "$BANNER" "$replay")"
if [[ -z "$count" ]]; then
	fail "the verification printed no count line, so the count pin proves nothing this run"
elif [[ "$replay_count" == "$((EXPECTED_CHECKS + 1))" && "$replay_count" != "$EXPECTED_CHECKS" ]]; then
	pass "and that pin reads a log whose count moved by one as $replay_count, refusing it"
else
	fail "the count pin read '${replay_count:-nothing}' from a moved log and therefore proves nothing"
fi

owed_line="  $EXPECTED_OWED_CHECKS of $EXPECTED_OWED_CHECKS owed checks completed"
if grep -qxF "$owed_line" "$verify_log"; then
	pass "all $EXPECTED_OWED_CHECKS owed checks reached their last line"
else
	fail "the owed-count report is missing or short"
	grep -E "owed checks" "$verify_log" | sed 's/^/        /'
fi
sed "s/$owed_line/  $((EXPECTED_OWED_CHECKS - 1)) of $EXPECTED_OWED_CHECKS owed checks completed/" "$verify_log" > "$replay"
if ! grep -qxF "$owed_line" "$replay" && grep -qxF "  $((EXPECTED_OWED_CHECKS - 1)) of $EXPECTED_OWED_CHECKS owed checks completed" "$replay"; then
	pass "and that pin refuses a replay reporting $((EXPECTED_OWED_CHECKS - 1)) of $EXPECTED_OWED_CHECKS"
else
	fail "the owed-count pin accepts a short replay and therefore proves nothing"
fi

# The owed SET, name for name and in order: this script's own list against the one the run printed.
set_line="  completed: $OWED_SET"
set_names="$(printf '%s' "$OWED_SET" | tr ',' '\n' | sed 's/^ //' | grep -c .)"
if [[ "$set_names" == "$EXPECTED_OWED_CHECKS" ]] && grep -qxF "$set_line" "$verify_log"; then
	pass "the run completed exactly the $set_names owed checks this script names, in order"
else
	fail "the completed set differs from the $set_names names this script owes"
	grep -E "^  completed:" "$verify_log" | cut -c1-200 | sed 's/^/        /'
fi
first_name="${OWED_SET%%, *}"
sed "s/  completed: $first_name, /  completed: /" "$verify_log" > "$replay"
if ! grep -qxF "$set_line" "$replay" && grep -qE "^  completed: " "$replay"; then
	pass "and that pin refuses a replay whose set lacks $first_name"
else
	fail "the owed-set pin accepts a replay missing a name and therefore proves nothing"
fi

# The timing lines vary from run to run and are read, not pinned; the verification itself asserts
# their order and bounds.
timings="$(grep -cE "^  timing: " "$verify_log" | tr -d ' ')"
if [[ "$timings" == "4" ]]; then
	pass "the verification reported its 4 timing lines"
	grep -E "^  timing: " "$verify_log" | sed 's/^  /        /'
else
	fail "the verification reported $timings timing line(s), not 4"
fi

# The measurements this work exists to make, read out of the run's own log.
while IFS= read -r line; do
	if grep -qF -- "$line" "$verify_log"; then
		pass "measured: ${line}"
	else
		fail "the verification log does not report: ${line}"
	fi
done <<'MEASURED'
the slice is at its J5 hash f83e9436, 810 lines; with J5's one line removed it is, byte for byte, J4's file c204a087, 809 lines
48 files J5 stands beside hold the hashes they held before the first J5 edit
put back, the six are byte for byte c6fe40f1, a3f97de5, 565a0a4f, 5c45961b, 409b540d, 8b55c045 (32 replaced blocks)
_update_drop_nameplate(): the not-alive branch hides the nameplate, clears the prompt, then calls _active_drop.set_soft_targeted(false), then returns — before the camera read; 30 code lines against J4's 29; its last line is still the living soft-selection write
_active_drop.set_soft_targeted() is called twice in the slice, both in _update_drop_nameplate(); player.is_alive() still occurs 3 times; the function reads no Life, countdown, pending event, action state or neutral latch
_on_player_fell() is its 5 accepted lines and _tick_fallen_delay() its 6 — no immediate lethal-call cleanup
35 fields, 8 exports, 53 functions in J4's order, 12 constants, no signal and no enum — the counts J4 left
7 descend from BrokenWatchSlice: canonical_opening_runtime.gd, roguelite_build_variety_runtime.gd, roguelite_experience_collection_review.gd, roguelite_level_up_choice_review.gd, roguelite_live_effect_review.gd, roguelite_replayability_runtime.gd, roguelite_core_loop_runtime.gd
none overrides _update_drop_nameplate() or writes the drop's soft selection itself; every _process override among them calls super
roguelite_core_loop_runtime.gd alone places its own reward in the inherited _active_drop, so the same line would clear it for a fallen roguelite character — structural only, not measured here
31 actions; the entrypoint is prototype_app.tscn; project.godot declares no [autoload] and names nothing of J5
3 Quick Strikes at 100: Life 300 -> 200 -> 100 -> 0; the Graveblade's own died, from the player, gave one guaranteed drop — the Watchsteel Sword — one 'guaranteed drop' line, the latch set, the Worn Sword still equipped
alive, 1.00 m from the drop with the mouse live: soft_selected false, the ring ordinary copper
the same spot with the controller live: soft_selected true, the ring bright (1.00, 0.82, 0.52), COPPER_BRIGHT, the prompt "Watchsteel Sword — (A) Inspect"; the stick deflection moved the character 0.000 m
one 64-pixel pointer movement from a device other than the harness's own was held back by the harness's filter: the controller stayed live and the drop soft-selected
foreign pointer events held back: 1 — 1 from the harness's own self-check, any other from a real pointer on the window
2 deaths: Life 500 -> 375 -> 250 -> 125 -> 0 each; on each lethal frame FALLEN, not alive, no overlay, not paused, the countdown armed at exactly 0.90 s and the pending event the killing Hit itself; one took_damage per Hit and one fell
before death A's first Hit the character stood 1.00 m from the drop, in range, the controller live and the drop soft-selected; death C came after the drop was equipped
the lethal Hit landed in a physics step; in a deferred call on fell the slice's pre-probe count, the engine's process-frame count and its drawn-frame count were all unchanged — no process update and no drawn frame since the lethal Hit
in that interval the drop was soft_selected true and its ring bright (1.00, 0.82, 0.52), COPPER_BRIGHT — still as the last living update left them; the character FALLEN, not alive, 1.00 m from the drop with the controller live, the nameplate not yet hidden, no comparison, no overlay, not paused, the countdown armed at 0.90 s
read after every node's first process update past the lethal frame: soft_selected false and the ring ordinary copper
— with the controller live and the character in range: true
the nameplate hidden, the prompt empty, the prompt panel hidden, no comparison, the tree unpaused, and the countdown running at
process updates from the first after the lethal frame until Fallen opened: soft_selected false, the ring ordinary, the tree unpaused, and the countdown strictly lower than at the update before
of those updates came with the controller still live and the character still in range — every update before the delay's one mouse click
on every sampled frame after the first update: soft_selected false and the ring ordinary; on every sampled frame: not paused, FALLEN at 0, the killing Hit pending, no comparison, the countdown never rising; the harness's cleanup path ran 0 times
Fallen then opened exactly once, on the original killing Hit, "Graveblade — Melee Hit — 125 Physical Damage" on the overlay, its restart button focused; Enter on it restarted the slice once
one joypad (A) press in range with the controller live: read in the same call, no comparison, no pause, the countdown not moved, the HUD message untouched, no "Walk closer"; nothing logged
open_item_comparison("verification") called directly: no comparison, no pause, the countdown not moved; nothing logged
one left press and release through Input.parse_input_event() where the nameplate stood: it reached no nameplate, which stayed hidden; no comparison, no pause
after each, the drop and loadout unchanged, the character FALLEN with no destination, the countdown still falling, and the drop still unselected with its ring ordinary; the slice logged, in all: movement command rejected rejected: fallen
15 paused physics and idle frames read with the overlay standing and the tree paused, 0 of them faulted: the last soft_selected false, the ring ordinary copper
alive with the controller live: 1.50 m from the drop, soft-selected and the ring bright (1.00, 0.82, 0.52), COPPER_BRIGHT; 4.00 m away, unselected and the ring ordinary copper
the prompt "— walk closer"; back at 1.50 m, soft-selected again
one real pointer movement made the mouse live: still in range, unselected, the ring ordinary copper
1.50 m from the drop one joypad (A) press opened the comparison once ('controller interact'), paused, Close focused
joypad right moved focus to Equip and (A) pressed it: one weapon_changed, one 'weapon equipped' line, the comparison closed as 'equipped', the drop gone, one more item owned, the Watchsteel Sword equipped and swung; one more (A) opened nothing
one restart_current_slice() (quick restart), one revival to 500 / 500 IDLE — at which the countdown already read -1.0 and the pending event was already null — and no Fallen overlay, pause, second restart or fall in the
one drop was ever created, through 2 deaths, 2 restarts and one equip; one more kill of the first Graveblade was refused ('reward refused') with no second drop and no second 'guaranteed drop' line
MEASURED

# --------------------------------------------------------------------------
step "4. The same verification rendered at 1920x1080 and at the 1280x720 minimum window, with its evidence frames"

for resolution in 1920x1080 1280x720; do
	target="$SHOT_DIR"
	[[ "$resolution" == "1280x720" ]] && target="$SHOT_DIR/1280x720"
	window_log="$work/verify_$resolution.log"
	run_verification "$window_log" --path "$PROJECT_DIR" --resolution "$resolution" --log-file "$work/godot_file_$resolution.log" \
		--script "res://$THIS_VERIFICATION" -- --shots "$target"
	window_status=$?
	printf '  %s verification exit status: %s\n' "$resolution" "$window_status"
	assert_log_is_fresh "$window_log"
	assert_no_script_error "the $resolution run" "$window_log"
	assert_engine_output "the $resolution run" "$window_log"
	window_count="$(read_check_count "$BANNER" "$window_log")"
	if [[ "$window_status" == "0" && "$window_count" == "$EXPECTED_CHECKS" ]] \
			&& grep -qxF "$owed_line" "$window_log" && grep -qxF "$set_line" "$window_log"; then
		pass "the $resolution run exits 0 at the same pinned $EXPECTED_CHECKS checks, the same $EXPECTED_OWED_CHECKS owed checks completed"
	else
		fail "the $resolution run exits $window_status at ${window_count:-no} checks"
		grep -E "FAIL:" "$window_log" | head -10 | cut -c1-300 | sed 's/^/        /'
	fi
	if grep -qE "^  display [A-Za-z]+, window $resolution, " "$window_log"; then
		pass "the run reports a $resolution window"
	else
		fail "the $resolution run does not report its window"
		grep -E "^  display " "$window_log" | sed 's/^/        /'
	fi
	shots="$(grep -cE "^  screenshot: " "$window_log" | tr -d ' ')"
	selected="$(grep -E "^  screenshot: .*/01_living_controller_in_range_selected\.png \($resolution\) — alive, the controller live, " "$window_log" \
		| grep -cF "soft_selected true, ring bright (1.00, 0.82, 0.52), COPPER_BRIGHT, prompt \"Watchsteel Sword — (A) Inspect\"" | tr -d ' ')"
	cleared="$(grep -E "^  screenshot: .*/02_fallen_delay_ring_ordinary\.png \($resolution\) — FALLEN, 0\.[0-9]+ s of the delay left, the controller live, soft_selected false, ring ordinary copper " "$window_log" \
		| grep -cF "nameplate hidden, prompt \"\", overlay not open" | tr -d ' ')"
	if [[ "$shots" == "2" && "$selected" == "1" && "$cleared" == "1" \
			&& -s "$target/01_living_controller_in_range_selected.png" && -s "$target/02_fallen_delay_ring_ordinary.png" ]]; then
		pass "at $resolution two frames were saved: the living controller character in range with the ring bright, and the fallen one inside the delay with the ring ordinary, no nameplate and no prompt"
		grep -E "^  screenshot: " "$window_log" | sed 's/^  /        /'
	else
		fail "at $resolution the evidence frames were not saved as expected ($shots screenshot line(s))"
		grep -E "^  screenshot: " "$window_log" | sed 's/^/        /'
	fi
done

# --------------------------------------------------------------------------
step "5. project.godot is untouched"

project_godot="$PROJECT_DIR/project.godot"
actions="$(sed -n '/^\[input\]/,/^\[layer_names\]/p' "$project_godot" | grep -cE '^[a-zA-Z_0-9]+=')"
if [[ "$actions" == "$EXPECTED_INPUT_ACTIONS" ]]; then
	pass "the InputMap still declares exactly $EXPECTED_INPUT_ACTIONS actions"
else
	fail "the InputMap declares $actions actions, not $EXPECTED_INPUT_ACTIONS"
fi
main_scene="$(grep -oE 'run/main_scene="[^"]+"' "$project_godot" | head -1 | sed -E 's/run\/main_scene="([^"]+)"/\1/')"
if [[ "$main_scene" == "$EXPECTED_MAIN_SCENE" ]]; then
	pass "the entrypoint is still $EXPECTED_MAIN_SCENE"
else
	fail "the entrypoint is '$main_scene', not $EXPECTED_MAIN_SCENE"
fi
sections="$(grep -oE '^\[[a-z_]+\]$' "$project_godot" | tr -d '[]' | sort | tr '\n' ' ' | sed 's/ $//')"
if [[ "$sections" == "$EXPECTED_SECTIONS" ]]; then
	pass "the same nine sections, no new one"
else
	fail "project.godot's sections are '$sections'"
fi
if grep -q '^\[autoload\]' "$project_godot"; then
	fail "an [autoload] section was added"
else
	pass "there is still no [autoload]"
fi

# --------------------------------------------------------------------------
step "6. Every protected file and .godot/ are byte-identical, and the owner's files are untouched"

changed=0
for i in "${!PRESERVED_FILES[@]}"; do
	after="$(fingerprint "$PROJECT_DIR/${PRESERVED_FILES[$i]}")"
	if [[ "$after" != "${BEFORE_HASHES[$i]}" ]]; then
		fail "${PRESERVED_FILES[$i]} CHANGED during this run"
		changed=$((changed + 1))
	fi
done
if [[ "$changed" == "0" && "$missing_preserved" == "0" ]]; then
	pass "all ${#PRESERVED_FILES[@]} protected files are byte-identical"
fi

production_after="$(production_listing | shasum -a 256 | cut -d' ' -f1)"
if [[ "$production_after" == "$EXPECTED_PRODUCTION_DIGEST" ]]; then
	pass "every other production file is still as D-329 left it after the runs, but for the combat HUD, which J6 moved (D-332), and Broken Watch's layout, which J10 moved (D-340)"
else
	fail "a production file outside the slice changed during this run"
fi

godot_after="$(godot_fingerprint)"
godot_count_after="$(godot_file_count)"
if [[ "$godot_after" == "$godot_before" && "$godot_count_after" == "$godot_count_before" ]]; then
	pass ".godot/ is byte-identical: $godot_count_after files, the same content"
else
	fail ".godot/ changed during this run: $godot_count_before -> $godot_count_after files"
fi

settings_after="$(state_fingerprint "$production_dir/prototype_settings.cfg")"
lab_after="$(state_fingerprint "$production_dir/prototype_zero.cfg")"
character_after="$(state_fingerprint "$production_dir/riftwrought_character.cfg")"
if [[ "$settings_after" == "$settings_before" && "$lab_after" == "$lab_before" \
		&& "$character_after" == "$character_before" ]]; then
	pass "the project owner's own prototype_settings.cfg, prototype_zero.cfg and riftwrought_character.cfg are unchanged"
else
	fail "a file in the project owner's own user:// directory changed during this run"
fi

# --------------------------------------------------------------------------
printf '\n'
if [[ "$failures" == "0" ]]; then
	printf 'FALLEN DELAY DROP HIGHLIGHT SMOKE CHECKS: PASS\n'
	printf '  %s checks; %s of %s owed; headless, 1920x1080 and 1280x720; %s protected files and .godot/ byte-identical\n' \
		"$EXPECTED_CHECKS" "$EXPECTED_OWED_CHECKS" "$EXPECTED_OWED_CHECKS" "${#PRESERVED_FILES[@]}"
	printf '  J5 — Fallen-Delay Ground-Drop Highlight Clearing V1 — ACCEPTED\n'
	printf '  VERDICT: PASS — J5 is accepted. The selected ground-drop highlight clears on the first update after death, before the Fallen overlay, while controller ownership remains live and the J4 interaction refusals remain intact. The immediate post-hit/pre-update state is outside J5.\n'
	printf '  D-223 remains OPEN.\n'
	reached_end=1
	exit 0
else
	printf 'FALLEN DELAY DROP HIGHLIGHT SMOKE CHECKS: %d FAILURE(S)\n' "$failures"
	reached_end=1
	exit 1
fi
