#!/usr/bin/env bash
# Riftwrought — First-MVP UI J3: Gate 1D Pending-Fallen Cancellation on Restart V1 smoke checks
# (decision D-326).
#
# THIS IS NOT A GATE, AND IT RUNS NO LOCKED CHAIN.
#
# J3 changes exactly one production file: `BrokenWatchSlice.restart_current_slice()` now clears
# `_fallen_countdown` and `_pending_fallen_event` before it revives the player, so F5 inside the
# 0.90 s Fallen delay no longer leaves a death presentation armed to open over the living character.
# What this script proves:
#
#   1. the new verification, the slice and the two accepted verifications J3 moved parse;
#   2. the slice and the two moved verifications are at the hashes J5 moved them to (D-330);
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
#   game/tests/pending_fallen_restart_smoke.sh

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
		printf '\nPENDING FALLEN RESTART SMOKE CHECKS: ABORTED before the end of the script\n'
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
EXPECTED_CHECKS=23
EXPECTED_OWED_CHECKS=20
OWED_SET="the_production_scope_is_exactly_the_slice, restart_current_slice_is_the_accepted_body_with_two_cancellations_before_the_revival, the_slice_declares_nothing_new_and_the_delay_is_unchanged, the_reach_is_gate_1d_and_the_one_subclass_that_calls_it, no_scene_input_map_or_presentation_changed, a_real_graveblade_kill_arms_the_normal_delay, the_delay_keeps_the_player_fallen_with_no_overlay, f5_immediately_after_the_lethal_frame_cancels, f5_early_in_the_delay_cancels, f5_at_the_middle_of_the_delay_cancels, f5_late_in_the_delay_cancels, cancellation_comes_before_the_revival, no_stale_event_second_restart_or_second_revival, a_later_genuine_death_opens_fallen_once_with_its_new_event, restart_by_focused_confirm_with_the_overlay_standing, restart_by_a_real_left_click_with_the_overlay_standing, restart_by_f5_with_the_overlay_standing, restarting_a_living_character_arms_nothing, the_j2_state_contract_holds_while_fallen, the_guaranteed_drop_latch_is_unchanged"
VERIFICATION_TIMEOUT=600

EXPECTED_INPUT_ACTIONS=31
EXPECTED_MAIN_SCENE="res://scenes/app/prototype_app.tscn"
EXPECTED_SECTIONS="application audio debug display editor_plugins input layer_names navigation rendering"

# Engine warnings the verification may print, each with the exact number of times it must appear:
# the accepted navigation bake's two precision lines once each for the one scene it loads, and Gate
# 1D's own startup probe, which may report once that its map was not yet queryable within its own 40
# physics frames — the unchanged `BrokenWatchSlice._await_navigation_synchronized()` inside the
# slice's own `_ready()`, before any J3 check runs; the suite waits for the map itself before it acts.
BAKE_CLIMB="WARNING: Property agent_max_climb is floored to cell_height voxel units and loses precision."
BAKE_RADIUS="WARNING: Property agent_radius is ceiled to cell_size voxel units and loses precision."
SLICE_PROBE="WARNING: BrokenWatchSlice: the navigation map did not become queryable"
EXPECTED_BAKE_LINES=1
MOST_SLICE_PROBES=1

THIS_VERIFICATION="tests/pending_fallen_restart_verification.gd"
SLICE="scripts/first_mvp/severed_threshold/broken_watch_slice.gd"
J1_VERIFICATION="tests/first_mvp_modal_left_click_verification.gd"
J2_VERIFICATION="tests/fallen_modal_life_state_verification.gd"

# First-MVP UI J4 (D-328) moved all three again, one for one, from b35e04a6, 2f5a32ca and b04b0a1e.
# First-MVP UI J5 (D-330) moved all three again, one for one, from c204a087, c6fe40f1 and a3f97de5.
# First-MVP UI J6 (D-332) moved J2's verification again, one for one, from ca594f7d, when the combat HUD moved.
# First-MVP UI J7 (D-334) moved J2's verification again, one for one, from f065a48d, when the combat HUD moved.
# First-MVP UI J8 (D-336) moved J2's verification again, one for one, from eb7f4153, when the combat HUD moved.
# First-MVP Gameplay J9 (D-338) moved all three again, one for one, from f83e9436, 8c0e290c and d5407c7c, when Gate 1D's slice moved.
# First-MVP Gameplay J10 (D-340) moved all three again, one for one, from 942aee83, acbd3892 and 6acc1e0c, when Gate 1D's slice moved.
# First-MVP Gameplay J11 (D-344) moved this runner's rows again, one for one, when Gate 1D's slice came to open Riftfall Landing's Watch Breach far cap in its own composition.
D326_ROWS=(
	"$SLICE|d4e839fb"
	"$J1_VERIFICATION|d12ad271"
	"$J2_VERIFICATION|72e39a8a"
)

# Fingerprinted before and after the run: the changed file, this verification, the two accepted
# verifications J3 moved and every other suite that reads the slice beside them, everything the
# verification pins as unchanged, the project owner's composed zone, and the two handoff documents.
PRESERVED_FILES=(
	"$SLICE"
	"$THIS_VERIFICATION"
	"$J1_VERIFICATION"
	"tests/first_mvp_modal_left_click_smoke.sh"
	"$J2_VERIFICATION"
	"tests/fallen_modal_life_state_smoke.sh"
	"tests/gate_1d_broken_watch_verification.gd"
	"tests/gate_1d_broken_watch_smoke.sh"
	"tests/gate_1e_canonical_opening_verification.gd"
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

BANNER="PENDING FALLEN RESTART VERIFICATION"

work="$(mktemp -d -t riftwrought_j3)"
scratch+=("$work")

printf 'Riftwrought — First-MVP UI J3: Gate 1D Pending-Fallen Cancellation on Restart V1 smoke checks (D-326)\n'
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
step "1. The new verification, the slice and the two moved verifications parse"

for relative in "$THIS_VERIFICATION" "$SLICE" "$J1_VERIFICATION" "$J2_VERIFICATION"; do
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
step "2. The slice and the two moved verifications are at the hashes J5 moved them to (D-330)"

for row in "${D326_ROWS[@]}"; do
	relative="${row%%|*}"
	prefix="${row##*|}"
	actual="$(fingerprint "$PROJECT_DIR/$relative")"
	if [[ "$actual" == "$prefix"* ]]; then
		pass "$relative is at $prefix"
	else
		fail "$relative is at ${actual:0:8}, not $prefix"
	fi
done

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

# One timing line per F5 point: the measured seconds left vary from run to run and are read, not
# pinned; the verification itself asserts their order and bounds.
timings="$(grep -cE "^  timing: F5 with [0-9.]+ s of 0\.90 left" "$verify_log" | tr -d ' ')"
if [[ "$timings" == "4" ]]; then
	pass "the verification reported the time left at each of its 4 F5 points"
	grep -E "^  timing: F5 with" "$verify_log" | cut -d';' -f1 | sed 's/^  /        /'
else
	fail "the verification reported $timings F5 timing line(s), not 4"
fi

# The measurements this work exists to make, read out of the run's own log.
while IFS= read -r line; do
	if grep -qF -- "$line" "$verify_log"; then
		pass "measured: ${line}"
	else
		fail "the verification log does not report: ${line}"
	fi
done <<'MEASURED'
the slice is at its J5 hash f83e9436; with J5's one line removed, at its J4 hash c204a087; with J4's 3 comments and 3 guards removed, at its J3 hash b35e04a6; with J3's 8 comment lines and its 2 cancellation lines removed it is, byte for byte, the pre-J3 file e6bbb174
37 files J3 stands beside hold the hashes they held before the first J3 edit
J1's and J2's verifications moved only their slice row, with its comment and one clause in their print, under J3, again under J4 and again under J5: put back, they are byte for byte 2606fd80 and d78c5ae1
13 code lines: the log line, then `_fallen_countdown = -1.0` and `_pending_fallen_event = null`, then the accepted revival, entry, J10's movement-intent clearing (D-340), facing, Graveblade reset, permission reset, soft target and marker — no return, no condition, the signature (reason: String) unchanged
_on_player_fell() is its 5 accepted lines and _tick_fallen_delay() its 6; J3's comment sits directly above the method it describes
35 fields, 8 exports, 53 functions, 12 constants, no signal and no enum — the counts before J3; FALLEN_DELAY is still 0.90 and the countdown's inactive sentinel still -1.0
the countdown is written in [_on_player_fell, _tick_fallen_delay, restart_current_slice] and the pending event in [_on_player_fell, restart_current_slice]
2 extend BrokenWatchSlice: canonical_opening_runtime.gd, whose restart_current_slice() calls super first, so Gate 1E inherits the cancellation; and roguelite_core_loop_runtime.gd, which overrides it without super and already clears both facts
the two field names appear in no other running script but prototype_zero.gd, which declares its own separate _fallen_countdown and does not extend the slice
31 actions; the entrypoint is prototype_app.tscn; project.godot declares no [autoload] and names nothing of J3
7 deaths, each to 4 of the Graveblade's own attacks: Life 500 -> 375 -> 250 -> 125 -> 0; on each lethal frame FALLEN, not alive, no overlay, not paused, no permission held, 0 Graveblades acting, the countdown armed at no more than 0.90 s and the pending event the killing Hit itself; one took_damage per Hit and one fell
on every sampled frame of all 7 delays: FALLEN at 0 / 500, not paused, no overlay, no restart yet, no permission held, the countdown running and the pending event unchanged
F5 immediately after the lethal frame: one restart_current_slice() (quick restart), one revival (life_changed [500 / 500 IDLE]); the countdown -1.0 and no pending event; Broken Watch's entry, both Graveblades at full Life at their spawns and active, no permission held, instrumentation reset; no Fallen overlay, no second restart and no second revival in the 1.75 s after
F5 early in the delay: one restart_current_slice() (quick restart), one revival (life_changed [500 / 500 IDLE]); the countdown -1.0 and no pending event; Broken Watch's entry, both Graveblades at full Life at their spawns and active, no permission held, instrumentation reset; no Fallen overlay, no second restart and no second revival in the 1.75 s after
F5 at the middle of the delay: one restart_current_slice() (quick restart), one revival (life_changed [500 / 500 IDLE]); the countdown -1.0 and no pending event; Broken Watch's entry, both Graveblades at full Life at their spawns and active, no permission held, instrumentation reset; no Fallen overlay, no second restart and no second revival in the 1.75 s after
F5 late in the delay: one restart_current_slice() (quick restart), one revival (life_changed [500 / 500 IDLE]); the countdown -1.0 and no pending event; Broken Watch's entry, both Graveblades at full Life at their spawns and active, no permission held, instrumentation reset; no Fallen overlay, no second restart and no second revival in the 1.75 s after
pushed at the first frame boundary with no more than 1.5 of that delay's longest frame left
at the revival of all 8 restarts — the 4 inside the delay, the 3 behind the overlay and the living one — the countdown already read -1.0 and the pending event already null
4 of 4 cancellations: no Fallen overlay opened, the tree never paused, the character stayed alive, the countdown stayed -1.0 with no pending event, and restart_current_slice(), the revival and the fall each happened once; the harness's cleanup path ran 0 times
over the whole run the Fallen overlay opened exactly 3 times — once for each genuine death after the cancellations
after 4 cancellations a genuine death armed the delay again and opened Fallen exactly once, the room's pending event at that moment the new killing Hit — none of the 4 cancelled deaths' events — and "Graveblade — Melee Hit — 125 Physical Damage" on the overlay, its restart button focused
so did the next two genuine deaths; 30 paused physics and 10 idle frames behind each overlay: still opened once, FALLEN at 0 / 500, the countdown -1.0 and the new Hit pending until the restart
the overlay closed once, one restart_current_slice() (Fallen), one revival (life_changed [500 / 500 IDLE]); the countdown -1.0 and no pending event; Broken Watch's entry, both Graveblades at full Life at their spawns and active, no permission held, instrumentation reset; no Fallen overlay in the 1.75 s after
one left press and release through Input.parse_input_event(): one pressed, on that button; the overlay closed once, one restart_current_slice() (Fallen)
over the 20 physics frames after it: no destination, no attack, no movement, no modal, and the left button no longer held
a living character at 375 / 500 after one of the Graveblade's own Hits, the countdown -1.0: F5 ran one restart_current_slice() (quick restart) and one revival to 500 / 500; the countdown stayed -1.0 with no pending event, nothing fell, and no Fallen overlay opened in the 1.75 s after
inside the delay the room's own neutralize_for_modal() left the character FALLEN at 0 / 500 with the countdown still running and the Hit still pending, and a further 125-damage event was refused; the overlay then opened by itself
every movement_intent_cleared before a restart saw FALLEN at 0: [fallen] for each cancelled death, [fallen, j3 neutralization inside the delay, fallen opened] and [fallen, fallen opened] for the others; behind each of the 3 overlays one more event was refused
the guaranteed drop was granted once, before the first death; after 8 restarts the latch is still set, the same Watchsteel Sword still lies on the ground as the only drop, the Starting Sword is still equipped, and one more kill of the first Graveblade was refused ('reward refused') with no second drop
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
	printf 'PENDING FALLEN RESTART SMOKE CHECKS: PASS\n'
	printf '  %s checks; %s of %s owed; headless; %s protected files and .godot/ byte-identical\n' \
		"$EXPECTED_CHECKS" "$EXPECTED_OWED_CHECKS" "$EXPECTED_OWED_CHECKS" "${#PRESERVED_FILES[@]}"
	printf '  First-MVP UI J3 — Gate 1D Pending-Fallen Cancellation on Restart V1 is DELIVERED under D-326\n'
	printf '  and ACCEPTED and CLOSED at the Gate 1D pending-Fallen cancellation-before-revival mechanism\n'
	printf '  level under D-327. D-223 remains OPEN.\n'
	reached_end=1
	exit 0
else
	printf 'PENDING FALLEN RESTART SMOKE CHECKS: %d FAILURE(S)\n' "$failures"
	reached_end=1
	exit 1
fi
