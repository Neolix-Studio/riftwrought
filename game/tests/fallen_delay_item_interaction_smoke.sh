#!/usr/bin/env bash
# Riftwrought — First-MVP UI J4: Fallen-Delay Item-Interaction Gating V1 smoke checks (decision D-328).
#
# THIS IS NOT A GATE, AND IT RUNS NO LOCKED CHAIN.
#
# J4 changes exactly one production file: Gate 1D's `BrokenWatchSlice` now refuses item interaction
# while the character is not alive. `open_item_comparison()` and `_try_interact_with_drop()` each return
# when `player.is_alive()` is false, and `_update_drop_nameplate()` hides the nameplate and clears the
# prompt. What this script proves:
#
#   1. the new verification, the slice and the three accepted verifications J4 moved parse;
#   2. the slice and the four accepted suite files J4 moved are at the hashes J5 moved them to (D-330);
#   3. the pinned verification passes headless, proved in BOTH directions against a replay of its
#      own log — its check count, its owed count and the exact owed SET — with the measured lines
#      read out of the log, zero SCRIPT ERROR and zero engine ERROR, and no engine WARNING but the
#      accepted ones counted exactly;
#   4. `project.godot` is untouched: 31 actions, the Prototype App entrypoint, the same nine
#      sections, no `[autoload]`;
#   5. every file this work stands beside and the whole `.godot/` directory are BYTE-IDENTICAL
#      across the run, and the project owner's own user:// files are untouched.
#
# Everything this script writes goes into one `mktemp -d` directory, removed on every exit.
#
# Usage, from the repository root:
#   game/tests/fallen_delay_item_interaction_smoke.sh

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
		printf '\nFALLEN DELAY ITEM INTERACTION SMOKE CHECKS: ABORTED before the end of the script\n'
		printf '  the run stopped early (exit %s) — nothing after that point was proved\n' "$code"
		exit 1
	fi
	exit "$code"
}
trap on_exit EXIT

GODOT="${GODOT:-/Applications/Godot.app/Contents/MacOS/Godot}"
EXPECTED_VERSION="4.7.2.stable"
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Pinned, and proved in both directions below.
EXPECTED_CHECKS=22
EXPECTED_OWED_CHECKS=20
OWED_SET="the_production_scope_is_exactly_the_slice, the_accepted_suites_moved_only_their_slice_pins, only_the_three_functions_changed_each_by_one_life_guard, the_slice_declares_nothing_new, the_reach_is_gate_1d_and_its_descendants_by_inheritance, no_scene_input_map_or_presentation_changed, a_production_graveblade_death_creates_the_guaranteed_drop, production_graveblade_attacks_kill_the_player_and_arm_the_delay, a_lethal_frame_nameplate_press_opens_nothing, the_first_process_update_hides_the_nameplate_and_prompt, repeated_nameplate_presses_in_the_delay_change_nothing, controller_interact_in_the_delay_opens_nothing_and_says_nothing, the_direct_opener_refuses_a_fallen_player, the_delay_runs_on_and_opens_fallen_once_on_the_original_hit, behind_the_fallen_overlay_item_interaction_is_still_refused, a_living_player_sees_the_nameplate_and_opens_and_closes_it_by_left_click, a_living_out_of_range_controller_interact_still_says_walk_closer, a_living_player_opens_it_by_controller_and_equips_once, f5_in_a_later_delay_still_cancels_before_the_revival, the_guaranteed_drop_latch_still_permits_one_drop"
VERIFICATION_TIMEOUT=600

EXPECTED_INPUT_ACTIONS=31
EXPECTED_MAIN_SCENE="res://scenes/app/prototype_app.tscn"
EXPECTED_SECTIONS="application audio debug display editor_plugins input layer_names navigation rendering"

# Engine warnings the verification may print, each with the exact number of times it must appear:
# the accepted navigation bake's two precision lines once each for the one scene it loads, and Gate
# 1D's own startup probe, which may report once that its map was not yet queryable within its own 40
# physics frames — the unchanged `BrokenWatchSlice._await_navigation_synchronized()` inside the
# slice's own `_ready()`, before any J4 check runs; the suite waits for the map itself before it acts.
BAKE_CLIMB="WARNING: Property agent_max_climb is floored to cell_height voxel units and loses precision."
BAKE_RADIUS="WARNING: Property agent_radius is ceiled to cell_size voxel units and loses precision."
SLICE_PROBE="WARNING: BrokenWatchSlice: the navigation map did not become queryable"
EXPECTED_BAKE_LINES=1
MOST_SLICE_PROBES=1

THIS_VERIFICATION="tests/fallen_delay_item_interaction_verification.gd"
SLICE="scripts/first_mvp/severed_threshold/broken_watch_slice.gd"
J1_VERIFICATION="tests/first_mvp_modal_left_click_verification.gd"
J2_VERIFICATION="tests/fallen_modal_life_state_verification.gd"
J3_VERIFICATION="tests/pending_fallen_restart_verification.gd"
J3_SMOKE="tests/pending_fallen_restart_smoke.sh"

# First-MVP UI J5 (D-330) moved all five again, one for one, from c204a087, c6fe40f1, a3f97de5, 565a0a4f and 5c45961b.
# First-MVP UI J6 (D-332) moved three of them again, one for one, from ca594f7d, b2cfc253 and 6e4120a3, when the combat HUD moved.
# First-MVP UI J7 (D-334) moved the same three again, one for one, from f065a48d, 68a1227e and f7b48202, when the combat HUD moved.
# First-MVP UI J8 (D-336) moved the same three again, one for one, from eb7f4153, 520d9543 and 67cf7ba9, when the combat HUD moved.
# First-MVP Gameplay J9 (D-338) moved all five again, one for one, from f83e9436, 8c0e290c, d5407c7c, 1062c1db and 689284cc, when Gate 1D's slice moved.
# First-MVP Gameplay J10 (D-340) moved all five again, one for one, from 942aee83, acbd3892, 6acc1e0c, dc9be60f and ec5bc37f, when Gate 1D's slice moved.
# First-MVP Gameplay J11 (D-344) moved this runner's rows again, one for one, when Gate 1D's slice came to open Riftfall Landing's Watch Breach far cap in its own composition.
D328_ROWS=(
	"$SLICE|d4e839fb"
	"$J1_VERIFICATION|d12ad271"
	"$J2_VERIFICATION|72e39a8a"
	"$J3_VERIFICATION|7d0e3f08"
	"$J3_SMOKE|54a4464a"
)

# Fingerprinted before and after the run: the changed file, this verification, the four accepted
# suite files J4 moved and every other suite that reads the slice beside them, everything the
# verification pins as unchanged, the project owner's composed zone, and the two handoff documents.
PRESERVED_FILES=(
	"$SLICE"
	"$THIS_VERIFICATION"
	"$J1_VERIFICATION"
	"tests/first_mvp_modal_left_click_smoke.sh"
	"$J2_VERIFICATION"
	"tests/fallen_modal_life_state_smoke.sh"
	"$J3_VERIFICATION"
	"$J3_SMOKE"
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

BANNER="FALLEN DELAY ITEM INTERACTION VERIFICATION"

work="$(mktemp -d -t riftwrought_j4)"
scratch+=("$work")

printf 'Riftwrought — First-MVP UI J4: Fallen-Delay Item-Interaction Gating V1 smoke checks (D-328)\n'
printf 'project: %s\n' "$PROJECT_DIR"

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
step "1. The new verification, the slice and the three moved verifications parse"

for relative in "$THIS_VERIFICATION" "$SLICE" "$J1_VERIFICATION" "$J2_VERIFICATION" "$J3_VERIFICATION"; do
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
step "2. The slice and the four moved accepted suite files are at the hashes J5 moved them to (D-330)"

for row in "${D328_ROWS[@]}"; do
	relative="${row%%|*}"
	prefix="${row##*|}"
	actual="$(fingerprint "$PROJECT_DIR/$relative")"
	if [[ "$actual" == "$prefix"* ]]; then
		pass "$relative is at $prefix"
	else
		fail "$relative is at ${actual:0:8}, not $prefix"
	fi
done
if [[ -x "$PROJECT_DIR/$J3_SMOKE" ]]; then
	pass "$J3_SMOKE is still executable"
else
	fail "$J3_SMOKE lost its executable bit"
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
if [[ "$timings" == "3" ]]; then
	pass "the verification reported its 3 timing lines"
	grep -E "^  timing: " "$verify_log" | sed 's/^  /        /'
else
	fail "the verification reported $timings timing line(s), not 3"
fi

# The measurements this work exists to make, read out of the run's own log.
while IFS= read -r line; do
	if grep -qF -- "$line" "$verify_log"; then
		pass "measured: ${line}"
	else
		fail "the verification log does not report: ${line}"
	fi
done <<'MEASURED'
the slice is at its J5 hash f83e9436; with J5's one line removed, at its J4 hash c204a087; with J4's 3 comments (10 lines) and its 3 guards (8 lines) removed it is, byte for byte, J3's file b35e04a6
48 files J4 stands beside hold the hashes they held before the first J4 edit
put back, the four are byte for byte 2f5a32ca, b04b0a1e, 51c8560c and 1789de06 (18 replaced blocks)
open_item_comparison(): the third refusal, after the missing drop and the open modal, before the log line and open_for() — 8 code lines
_try_interact_with_drop(): the third refusal, after the same two, before the range check and "Walk closer" — 10 code lines
_update_drop_nameplate(): the second branch, after the missing drop or nameplate, before the camera read, placement, prompt and soft-selection writes — it hides the nameplate and clears the prompt
player.is_alive() occurs 3 times in the slice's code, once in each of the three; none reads Life, the countdown, the pending event, the action state or the neutral latch; the three signatures are unchanged
35 fields, 8 exports, 53 functions in J3's order, 12 constants, no signal and no enum — the counts J3 left
7 descend from BrokenWatchSlice: canonical_opening_runtime.gd, roguelite_build_variety_runtime.gd, roguelite_experience_collection_review.gd, roguelite_level_up_choice_review.gd, roguelite_live_effect_review.gd, roguelite_replayability_runtime.gd, roguelite_core_loop_runtime.gd
none overrides _try_interact_with_drop() or _update_drop_nameplate(); every _process and _unhandled_input override among them calls super
Gate 1E alone overrides open_item_comparison(): its own modal test, then _hide_world_nameplates(), then super — so the guard still decides
31 actions; the entrypoint is prototype_app.tscn; project.godot declares no [autoload] and names nothing of J4
3 Quick Strikes at 100: Life 300 -> 200 -> 100 -> 0; the Graveblade's own died, from the player, gave one guaranteed drop — the Watchsteel Sword
one 'guaranteed drop' line, the latch set, the Worn Sword still equipped
3 deaths: Life 500 -> 375 -> 250 -> 125 -> 0 each; on each lethal frame FALLEN, not alive, no overlay, not paused, the countdown armed at exactly 0.90 s and the pending event the killing Hit itself; one took_damage per Hit and one fell
death A stood 1.00 m from the drop (in range) and death B 4.00 m (out of range), each with the nameplate showing before the first Hit; death C came after the drop was equipped
FALLEN and not alive, no process update since the lethal Hit, the nameplate still visible: one left press and release at its centre
through push_input() — one button_down and one pressed, on the nameplate
the comparison did not open, no 'item comparison opened' line was added, the tree stayed unpaused, the countdown still read 0.90 s with the killing Hit pending, and the drop, loadout and equipped weapon were unchanged
in all 3 deaths, read after the slice's own first process update past the lethal frame: nameplate hidden, prompt text empty, prompt panel hidden
3 left presses and releases through Input.parse_input_event() at the nameplate's last centre: none reached the nameplate, which stayed hidden; no comparison, no pause, the countdown still falling, the killing Hit still pending, the character FALLEN with no destination, and the drop, loadout and equipped weapon unchanged
the slice logged, in all: movement command rejected rejected: fallen; movement command rejected rejected: fallen; movement command rejected rejected: fallen
one joypad (A) press and release in death A, in range, and one in death B, out of range: read in the same call, no comparison, no pause, the countdown not moved, the HUD message untouched; nothing logged
afterwards the drop, ownership, loadout and equipped weapon were unchanged and the countdown kept falling
s of the delay left: no comparison, no log line, no pause, the countdown and the killing Hit untouched, the drop and loadout unchanged
on every sampled frame of both delays: not paused, FALLEN at 0, the killing Hit pending, no comparison, and the countdown strictly falling; the harness's cleanup path ran 0 times
each delay then opened Fallen exactly once, the room's pending event at that moment the original killing Hit, "Graveblade — Melee Hit — 125 Physical Damage" on the overlay, its restart button focused; over the whole run it opened twice
and read after each of the slice's own process updates in both delays, the countdown strictly fell every time and the tree was never paused
10 paused physics and 5 idle frames: the overlay standing, the tree paused, the nameplate hidden, the prompt empty, no comparison
one left click through J1's route where the nameplate stood landed on the overlay's own panel, not its Restart button: no button pressed, no comparison, no restart, the drop and loadout unchanged
alive, 1.50 m from the drop: the nameplate showing "Watchsteel Sword" and the prompt "Watchsteel Sword — Left click"
one left press and release on the nameplate through Input.parse_input_event(): one pressed; the comparison opened once ('nameplate clicked'), paused, Close focused
one left click on Close: closed once, "closed — the item is still on the ground"; the drop still on the ground, nothing owned or equipped changed
4.00 m from the drop, one joypad (A) press: "Walk closer to inspect it" shown for 3.0 s, no comparison, no pause; the prompt then read "Watchsteel Sword — walk closer"
1.50 m from the drop the prompt read "Watchsteel Sword — (A) Inspect"; one joypad (A) press opened the comparison once ('controller interact'), paused, Close focused
joypad right moved focus to Equip and (A) pressed it: one weapon_changed, one 'weapon equipped' line, the comparison closed as 'equipped', the drop gone, one more item owned, the Watchsteel Sword equipped and swung; one more (A) opened nothing
one restart_current_slice() (quick restart), one revival to 500 / 500 IDLE — at which the countdown already read -1.0 and the pending event was already null — and no Fallen overlay, pause, second restart or fall in the
one drop was ever created, through 3 deaths, 3 restarts and one equip; one more kill of the first Graveblade was refused ('reward refused') with no second drop and no second 'guaranteed drop' line
MEASURED

# --------------------------------------------------------------------------
step "4. project.godot is untouched"

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
step "5. Every protected file and .godot/ are byte-identical, and the owner's files are untouched"

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
	printf 'FALLEN DELAY ITEM INTERACTION SMOKE CHECKS: PASS\n'
	printf '  %s checks; %s of %s owed; headless; %s protected files and .godot/ byte-identical\n' \
		"$EXPECTED_CHECKS" "$EXPECTED_OWED_CHECKS" "$EXPECTED_OWED_CHECKS" "${#PRESERVED_FILES[@]}"
	printf '  First-MVP UI J4 — Fallen-Delay Item-Interaction Gating V1 is DELIVERED under D-328 and ACCEPTED and\n'
	printf '  CLOSED at the shared player-life-gated ground-item presentation and item-comparison-opening mechanism\n'
	printf '  level under D-329. D-223 remains OPEN.\n'
	reached_end=1
	exit 0
else
	printf 'FALLEN DELAY ITEM INTERACTION SMOKE CHECKS: %d FAILURE(S)\n' "$failures"
	reached_end=1
	exit 1
fi
