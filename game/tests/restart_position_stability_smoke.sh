#!/usr/bin/env bash
# Riftwrought — First-MVP Gameplay J10: Gate 1D Restart Position Stability V1 smoke checks (decision D-340).
#
# THIS IS NOT A GATE, AND IT RUNS NO LOCKED CHAIN. IT IS HEADLESS ONLY: IT HAS NO RENDERED MODE, SAVES NO
# SCREENSHOT AND OPENS NO WINDOW.
#
# J10 changes two production files, one line each with its comment. Broken Watch's layout moves its entry socket
# out of Riftfall Landing's Watch Breach far cap, which it had sat 1.0 m inside, so the first physics step after a
# restart no longer pushes the character 1.40 m out; Gate 1D's slice ends the movement command a restart used to
# carry, through `clear_movement_intent(reason, false)`, directly after the entry. What this script proves:
#
#   1. the new verification, the slice, the layout and the nine accepted verifications J10 moved parse, and this
#      runner and the seven accepted runners J10 moved pass `bash -n`;
#   2. the slice, the layout, the new verification and the sixteen accepted suite files J10 moved are at their
#      D-340 hashes, each pin refusing a file with one byte appended; the slice and the layout with J10's lines put
#      back are, byte for byte, the D-339 files; no other production file has changed — one digest over every file
#      under scripts/, scenes/, data/, addons/ and assets/ and project.godot, the slice and the layout excepted and
#      every `.DS_Store` pruned; and this runner and the seven moved runners are executable;
#   3. the pinned verification passes headless, proved in BOTH directions against a replay of its own log — its
#      check count, its owed count, the exact owed SET and this run's own token — with the measured lines read out
#      of the log, including the sixteen moved files rebuilt to their D-339 hashes; zero SCRIPT ERROR and zero
#      engine ERROR; the two accepted bake warnings exactly twice each (two scenes); neither startup probe; and no
#      other engine WARNING;
#   4. `project.godot` is untouched: 31 actions, the Prototype App entrypoint, the same nine sections, no
#      `[autoload]`;
#   5. every file this work stands beside and the whole `.godot/` directory are BYTE-IDENTICAL across the run, the
#      project owner's own user:// files are untouched, and Godot's own user://logs/ did not move;
#   6. this run's temporary directory is gone and no other J10 temporary directory is left behind.
#
# Everything this script writes goes into one `mktemp -d` directory, removed on every exit — Godot's own file log
# for every invocation included. Every walk this script makes prunes `.DS_Store`, and none reaches the repository's
# `assets/` directory.
#
# Usage, from the repository root:
#   game/tests/restart_position_stability_smoke.sh

set -uo pipefail

# Assigned at the TOP of the script, never beside the function it serves.
RUN_STARTED_AT="$(date +%s)"
RUN_TOKEN="j10-${RUN_STARTED_AT}-$$-${RANDOM}"

reached_end=0
scratch=()
on_exit() {
	local code=$?
	for path in "${scratch[@]+"${scratch[@]}"}"; do
		rm -rf "$path"
	done
	if [[ "$reached_end" != "1" ]]; then
		printf '\nRESTART POSITION STABILITY SMOKE CHECKS: ABORTED before the end of the script\n'
		printf '  the run stopped early (exit %s) — nothing after that point was proved\n' "$code"
		exit 1
	fi
	exit "$code"
}
trap on_exit EXIT

GODOT="${GODOT:-/Applications/Godot.app/Contents/MacOS/Godot}"
EXPECTED_VERSION="4.7.2.stable"
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEMP_ROOT="${TMPDIR:-/tmp}"
TEMP_ROOT="${TEMP_ROOT%/}"
TEMP_STEM="riftwrought_j10"

# Pinned, and proved in both directions below.
EXPECTED_CHECKS=27
EXPECTED_OWED_CHECKS=18
OWED_SET="the_production_diff_is_exactly_the_clearing_line_and_the_moved_socket, the_accepted_suites_moved_only_their_pins_reconstructions_and_j3s_ruled_line_list, restart_current_slice_ends_the_movement_intent_after_the_entry_and_nothing_else_moved, the_entry_socket_left_the_landing_cap_and_nothing_else_in_the_layout_moved, the_reach_is_gate_1d_gate_1e_by_structure_and_not_the_roguelite, the_d339_entry_sat_inside_the_cap_and_the_new_entry_is_clear_on_the_mesh_and_reachable, a_real_first_graveblade_kill_keeps_j9s_binding_and_one_drop, route_1_f5_with_an_active_click_destination, route_2_f5_with_the_stick_held, route_2_f5_with_the_left_button_held, route_2_f5_during_a_quick_strike_that_suspended_a_held_stick, route_3_f5_inside_the_fallen_delay, route_4_fallen_restart_by_keyboard_confirm, route_5_fallen_restart_by_a_real_left_click, a_restart_with_both_graveblades_present_resets_both_and_the_player_stays, every_restart_kept_the_drop_latch_and_j9s_rewarded_set, the_roguelite_core_loop_keeps_its_own_reset, gate_1e_inherits_by_structure_only_and_is_not_run"
VERIFICATION_TIMEOUT=600

EXPECTED_INPUT_ACTIONS=31
EXPECTED_MAIN_SCENE="res://scenes/app/prototype_app.tscn"
EXPECTED_SECTIONS="application audio debug display editor_plugins input layer_names navigation rendering"

# Every production file but the slice and the layout, as J10 leaves them: files under scripts/, scenes/, data/,
# addons/ and assets/ and project.godot, every `.DS_Store` pruned, each line `sha256  path`, sorted, digested.
EXPECTED_PRODUCTION_FILES=862
EXPECTED_PRODUCTION_DIGEST="e7123116cbc632facb08c9284a8c95bb99d6bf9418c140bd055f55fa1dcf4802"

# The slice and the layout as D-339 left them, whole, and J10's lines in each.
PRE_J10_SLICE_SHA256="942aee836be7402f5da5698887263039aae279721aa9ace54771f488a256b0b5"
PRE_J10_LAYOUT_SHA256="79c2b3a57b04309bbbb1c5a1aacb2aaf18b04e49de0ed6eaf61d73fc764d9219"
J10_COMMENT_1=$'\t# First-MVP Gameplay J10 (decision D-340): the revival keeps the old destination,'
J10_COMMENT_2=$'\t# locomotion and attack, so the one neutralization authority ends them at the entry.'
J10_CLEARING=$'\tplayer.clear_movement_intent(reason, false)'
J10_SOCKET_1='## First-MVP Gameplay J10 (decision D-340): the entry was (3, -33), 1.0 m inside the'
J10_SOCKET_2="## Landing's Watch Breach far cap (a solid at x 1-9, z -34 to -30 in this same frame),"
J10_SOCKET_3="## so a body placed there was pushed 1.40 m out. It now stands 0.75 m past that cap's"
J10_SOCKET_4='## face, clear of it and on the navigation mesh, still inside the Watch Threshold.'
J10_ENTRY='const ENTRY_POINT: Vector2 = Vector2(3.0, -34.75)'
PRE_J10_ENTRY='const ENTRY_POINT: Vector2 = Vector2(3.0, -33.0)'

# Engine warnings the verification may print, each with the exact number of times it must appear: the accepted
# navigation bake's two precision lines, once per scene for the two scenes it loads — Gate 1D's slice and the
# Roguelite Core Loop. Neither scene's startup probe may appear at all.
BAKE_CLIMB="WARNING: Property agent_max_climb is floored to cell_height voxel units and loses precision."
BAKE_RADIUS="WARNING: Property agent_radius is ceiled to cell_size voxel units and loses precision."
SLICE_PROBE="WARNING: BrokenWatchSlice: the navigation map did not become queryable"
LOOP_PROBE="WARNING: RogueliteCoreLoopRuntime: the navigation map did not become queryable"
EXPECTED_BAKE_LINES=2

THIS_VERIFICATION="tests/restart_position_stability_verification.gd"
THIS_SMOKE="tests/restart_position_stability_smoke.sh"
SLICE="scripts/first_mvp/severed_threshold/broken_watch_slice.gd"
LAYOUT="scripts/first_mvp/severed_threshold/broken_watch_layout.gd"
J1_VERIFICATION="tests/first_mvp_modal_left_click_verification.gd"
J2_VERIFICATION="tests/fallen_modal_life_state_verification.gd"
J3_VERIFICATION="tests/pending_fallen_restart_verification.gd"
J3_SMOKE="tests/pending_fallen_restart_smoke.sh"
J4_VERIFICATION="tests/fallen_delay_item_interaction_verification.gd"
J4_SMOKE="tests/fallen_delay_item_interaction_smoke.sh"
J5_VERIFICATION="tests/fallen_delay_drop_highlight_verification.gd"
J5_SMOKE="tests/fallen_delay_drop_highlight_smoke.sh"
J6_VERIFICATION="tests/combat_hud_fractional_fill_verification.gd"
J6_SMOKE="tests/combat_hud_fractional_fill_smoke.sh"
J7_VERIFICATION="tests/enemy_hover_life_fractional_fill_verification.gd"
J7_SMOKE="tests/enemy_hover_life_fractional_fill_smoke.sh"
J8_VERIFICATION="tests/combat_hud_safe_bottom_placement_verification.gd"
J8_SMOKE="tests/combat_hud_safe_bottom_placement_smoke.sh"
J9_VERIFICATION="tests/guaranteed_drop_defeated_enemy_binding_verification.gd"
J9_SMOKE="tests/guaranteed_drop_defeated_enemy_binding_smoke.sh"

# The slice, the layout, this runner's own verification and the sixteen accepted suite files J10 moved, at their
# D-340 hashes.
# Verification Maintenance V1 (D-342) moved this runner's verification and eleven of the others again, one for one, from 51108a47, 5c8e9b07, dceea6f9, b1b456bd, f7144aac, 6cf22e7d, 0b816f06, 0dbde2d8, b709813c, 900c8d9e, ae964685 and 1f2a43b1, when their put-back pairs moved into the flat provenance store.
# First-MVP Gameplay J11 (D-344) moved this runner's rows again, one for one, when Gate 1D's slice came to open Riftfall Landing's Watch Breach far cap in its own composition.
D340_ROWS=(
	"$SLICE|d4e839fb"
	"$LAYOUT|cac924df"
	"$THIS_VERIFICATION|1588cff8"
	"$J1_VERIFICATION|d12ad271"
	"$J2_VERIFICATION|72e39a8a"
	"$J3_VERIFICATION|7d0e3f08"
	"$J3_SMOKE|54a4464a"
	"$J4_VERIFICATION|8aad4262"
	"$J4_SMOKE|939d9b48"
	"$J5_VERIFICATION|beb94aa0"
	"$J5_SMOKE|6f792a38"
	"$J6_VERIFICATION|8c653002"
	"$J6_SMOKE|51d64a23"
	"$J7_VERIFICATION|bf92c1ec"
	"$J7_SMOKE|64a84a9d"
	"$J8_VERIFICATION|2ca75553"
	"$J8_SMOKE|f562e165"
	"$J9_VERIFICATION|aaa9e1d3"
	"$J9_SMOKE|94b5e6c9"
)
MOVED_VERIFICATIONS=("$J1_VERIFICATION" "$J2_VERIFICATION" "$J3_VERIFICATION" "$J4_VERIFICATION" "$J5_VERIFICATION" "$J6_VERIFICATION" "$J7_VERIFICATION" "$J8_VERIFICATION" "$J9_VERIFICATION")
MOVED_RUNNERS=("$J3_SMOKE" "$J4_SMOKE" "$J5_SMOKE" "$J6_SMOKE" "$J7_SMOKE" "$J8_SMOKE" "$J9_SMOKE")

# Fingerprinted before and after the run: the two changed files, this verification, every accepted suite file J10
# moved, everything the verification pins as unchanged, the suites beside them, the project owner's composed zone,
# and the two handoff documents.
PRESERVED_FILES=(
	"$SLICE"
	"$LAYOUT"
	"$THIS_VERIFICATION"
	"$J1_VERIFICATION"
	"$J2_VERIFICATION"
	"$J3_VERIFICATION"
	"$J3_SMOKE"
	"$J4_VERIFICATION"
	"$J4_SMOKE"
	"$J5_VERIFICATION"
	"$J5_SMOKE"
	"$J6_VERIFICATION"
	"$J6_SMOKE"
	"$J7_VERIFICATION"
	"$J7_SMOKE"
	"$J8_VERIFICATION"
	"$J8_SMOKE"
	"$J9_VERIFICATION"
	"$J9_SMOKE"
	"scripts/actors/prototype_player.gd"
	"scripts/movement/prototype_locomotion.gd"
	"scripts/movement/prototype_mouse_hold.gd"
	"scripts/movement/prototype_ground_pointer.gd"
	"scripts/first_mvp/greybox/riftfall_landing_greybox_layout.gd"
	"scenes/first_mvp/severed_threshold/broken_watch_slice.tscn"
	"scripts/actors/prototype_graveblade.gd"
	"scripts/actors/graveblade_target_area.gd"
	"scenes/actors/prototype_graveblade.tscn"
	"scenes/actors/prototype_player.tscn"
	"scripts/combat/damage_event.gd"
	"scripts/combat/quick_strike_action.gd"
	"scripts/combat/attack_coordinator.gd"
	"scripts/combat/target_acquisition.gd"
	"scripts/combat/prototype_targetable.gd"
	"scripts/input/input_family_tracker.gd"
	"scripts/camera/prototype_camera_rig.gd"
	"scripts/prototype_zero/destination_marker.gd"
	"scripts/items/first_mvp_item_drop.gd"
	"scripts/items/player_loadout.gd"
	"scripts/ui/first_mvp_modal.gd"
	"scripts/ui/first_mvp_item_comparison.gd"
	"scripts/ui/first_mvp_fallen_overlay.gd"
	"scripts/ui/first_mvp_combat_hud.gd"
	"scripts/first_mvp/canonical_opening/canonical_opening_runtime.gd"
	"scripts/roguelite/roguelite_core_loop_runtime.gd"
	"scripts/roguelite/replayability/roguelite_replayability_runtime.gd"
	"scripts/roguelite/build_variety/roguelite_build_variety_runtime.gd"
	"scripts/roguelite/experience/roguelite_experience_collection_review.gd"
	"scripts/roguelite/level_up/roguelite_level_up_choice_review.gd"
	"scripts/roguelite/live_effects/roguelite_live_effect_review.gd"
	"scripts/prototype_zero/prototype_zero.gd"
	"scenes/first_mvp/canonical_opening/canonical_opening.tscn"
	"scenes/roguelite/roguelite_core_loop.tscn"
	"data/prototype_zero/graveblade.tres"
	"data/roguelite/graveblade_elite.tres"
	"data/first_mvp/severed_threshold/broken_watch/starting_sword.tres"
	"data/first_mvp/severed_threshold/broken_watch/watchsteel_sword.tres"
	"project.godot"
	"tests/gate_1d_broken_watch_verification.gd"
	"tests/gate_1d_broken_watch_smoke.sh"
	"tests/gate_1e_canonical_opening_verification.gd"
	"tests/roguelite_core_loop_verification.gd"
	"tests/roguelite_core_loop_smoke.sh"
	"tests/first_mvp_modal_left_click_smoke.sh"
	"tests/fallen_modal_life_state_smoke.sh"
	"tests/global_damage_live_application_smoke.sh"
	"tests/maximum_life_live_application_smoke.sh"
	"scenes/first_mvp/zone_composer_practice.tscn"
	"../CLAUDE.md"
	"../README.md"
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

# Every file in a directory by name, size and modification time, or "absent"; `.DS_Store` pruned.
directory_listing() {
	if [[ -d "$1" ]]; then
		(cd "$1" && find . -type f ! -name .DS_Store -print0 | sort -z | xargs -0 stat -f '%N %z %m')
	else
		printf 'absent'
	fi
}

godot_fingerprint() {
	(cd "$PROJECT_DIR" && find .godot -type f ! -name .DS_Store -print0 | sort -z | xargs -0 shasum -a 256 | shasum -a 256 | cut -d' ' -f1)
}
godot_file_count() {
	find "$PROJECT_DIR/.godot" -type f ! -name .DS_Store | wc -l | tr -d ' '
}

# Every production file but the slice and the layout, by path and content, every `.DS_Store` pruned.
production_listing() {
	(cd "$PROJECT_DIR" && find scripts scenes data addons assets project.godot -type f ! -name .DS_Store ! -path "$SLICE" ! -path "$LAYOUT" -print0 \
		| sort -z | xargs -0 shasum -a 256)
}
J11_FIRST=$'\t# First-MVP Gameplay J11 (decision D-344): RIFTFALL LANDING CLOSED ITS OWN FAR END,'
J11_LAST=$'\tlog_event("landing cap opened", "%d Riftfall Landing boundary mass overlaps Broken Watch; its %d built nodes are removed in THIS composition, before the bake" % [landing_caps.size(), cap_nodes_removed])'

# The slice with J10's three lines dropped: its two comment lines and the clearing.
put_back_slice() {
	awk -v c1="$J10_COMMENT_1" -v c2="$J10_COMMENT_2" -v clearing="$J10_CLEARING" '
		$0 == c1 || $0 == c2 || $0 == clearing { next }
		{ print }' "$1"
}

# The layout with J10's four comment lines dropped and the moved socket put back to the one it replaced.
put_back_layout() {
	awk -v s1="$J10_SOCKET_1" -v s2="$J10_SOCKET_2" -v s3="$J10_SOCKET_3" -v s4="$J10_SOCKET_4" \
		-v entry="$J10_ENTRY" -v old="$PRE_J10_ENTRY" '
		$0 == s1 || $0 == s2 || $0 == s3 || $0 == s4 { next }
		$0 == entry { print old; next }
		{ print }' "$1"
}

# The slice with First-MVP Gameplay J11’s composition-local cap opening dropped (D-344), so that the
# put-backs below read the slice their own decisions left. The block runs from its first comment line to its
# log line, and the blank line that follows it goes with it.
put_back_j11() {
	awk -v first="$J11_FIRST" -v last="$J11_LAST" '
		state == 0 && $0 == first { state = 1; next }
		state == 1 { if ($0 == last) { state = 2 }; next }
		state == 2 { state = 3; if ($0 == "") next }
		{ print }' "$1"
}

leftover_count() {
	find "$TEMP_ROOT" -maxdepth 1 -name "$TEMP_STEM.*" 2>/dev/null | wc -l | tr -d ' '
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

# Engine ERROR lines are refused outright; every WARNING must be one of the two accepted bake lines, each exactly
# EXPECTED_BAKE_LINES times, and neither scene's startup probe may appear.
assert_engine_output() {
	local what="$1" logfile="$2" errors climb radius probes others
	errors="$(grep -cE "^ERROR:" "$logfile" 2>/dev/null | tr -d ' ')"
	if [[ "$errors" == "0" ]]; then
		pass "$what produced no engine ERROR line"
	else
		fail "$what produced $errors engine ERROR line(s)"
		grep -A2 -E "^ERROR:" "$logfile" | head -20 | sed 's/^/        /'
	fi
	climb="$(grep -cxF "$BAKE_CLIMB" "$logfile" | tr -d ' ')"
	radius="$(grep -cxF "$BAKE_RADIUS" "$logfile" | tr -d ' ')"
	probes="$(grep -cF -e "$SLICE_PROBE" -e "$LOOP_PROBE" "$logfile" | tr -d ' ')"
	others="$(grep -E "^WARNING:" "$logfile" | grep -vxF "$BAKE_CLIMB" | grep -vxF "$BAKE_RADIUS" | wc -l | tr -d ' ')"
	if [[ "$climb" == "$EXPECTED_BAKE_LINES" && "$radius" == "$EXPECTED_BAKE_LINES" && "$probes" == "0" && "$others" == "0" ]]; then
		pass "$what printed each bake warning exactly $EXPECTED_BAKE_LINES times (two scenes), neither startup probe, and no other WARNING"
	else
		fail "$what printed bake lines $climb / $radius, startup probes $probes time(s), and $others other warning(s)"
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

# The verification prints the token this run handed it; a log from any other run carries another one.
assert_run_token() {
	local logfile="$1" replay="$2"
	if grep -qxF "  run token: $RUN_TOKEN" "$logfile"; then
		pass "$(basename "$logfile") carries this run's own token $RUN_TOKEN"
	else
		fail "$(basename "$logfile") does not carry this run's token — it was not written for this run"
	fi
	sed "s/  run token: $RUN_TOKEN/  run token: ${RUN_TOKEN}0/" "$logfile" > "$replay"
	if ! grep -qxF "  run token: $RUN_TOKEN" "$replay" && grep -qE "^  run token: " "$replay"; then
		pass "and that pin refuses a replay of the same log carrying another run's token"
	else
		fail "the token pin accepts another run's log and therefore proves nothing"
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

BANNER="RESTART POSITION STABILITY VERIFICATION"

# Counted BEFORE this run makes its own.
stale_before="$(leftover_count)"

work="$(mktemp -d -t "$TEMP_STEM")"
scratch+=("$work")

printf 'Riftwrought — First-MVP Gameplay J10: Gate 1D Restart Position Stability V1 smoke checks (D-340)\n'
printf 'project: %s\n' "$PROJECT_DIR"
printf 'run token: %s\n' "$RUN_TOKEN"
printf 'headless only — this runner has no rendered mode and opens no window\n'

# --------------------------------------------------------------------------
step "0. Engine, leftovers, and a fingerprint of everything this work must not disturb"

installed="$("$GODOT" --version 2>/dev/null | tail -1)"
printf '  installed: %s\n' "$installed"
if [[ "$installed" == "$EXPECTED_VERSION"* ]]; then
	pass "matches the locked $EXPECTED_VERSION baseline"
else
	fail "expected $EXPECTED_VERSION, found $installed"
fi

if [[ "$stale_before" == "0" ]]; then
	pass "no J10 temporary directory was left behind by an earlier run"
else
	fail "$stale_before J10 temporary director(y/ies) from an earlier run remain in $TEMP_ROOT — remove them"
	find "$TEMP_ROOT" -maxdepth 1 -name "$TEMP_STEM.*" | sed 's/^/        /'
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
logs_before="$(directory_listing "$production_dir/logs")"
pass "the project owner's own three user:// files and Godot's user://logs/ listing fingerprinted"

# --------------------------------------------------------------------------
step "1. The new verification, the slice, the layout and the moved verifications parse; this runner and the moved runners pass bash -n"

for relative in "$THIS_VERIFICATION" "$SLICE" "$LAYOUT" "${MOVED_VERIFICATIONS[@]}"; do
	out="$("$GODOT" --headless --path "$PROJECT_DIR" --log-file "$work/parse.log" --check-only --script "res://$relative" 2>&1 \
		| grep -v '^Godot Engine')"
	if [[ -z "$out" ]]; then
		pass "$relative parses"
	else
		fail "$relative does not parse"
		printf '%s\n' "$out" | head -10 | sed 's/^/        /'
	fi
done
for relative in "$THIS_SMOKE" "${MOVED_RUNNERS[@]}"; do
	if bash -n "$PROJECT_DIR/$relative" 2>"$work/bash_n.txt"; then
		pass "$relative passes bash -n"
	else
		fail "$relative fails bash -n"
		head -5 "$work/bash_n.txt" | sed 's/^/        /'
	fi
done

# --------------------------------------------------------------------------
step "2. The slice, the layout, the verification and the sixteen moved suite files are at their D-340 hashes; the slice and the layout rebuild to D-339; no other production file moved"

for row in "${D340_ROWS[@]}"; do
	relative="${row%%|*}"
	prefix="${row##*|}"
	actual="$(fingerprint "$PROJECT_DIR/$relative")"
	moved="$({ cat "$PROJECT_DIR/$relative"; printf 'x'; } | shasum -a 256 | cut -d' ' -f1)"
	if [[ "$actual" == "$prefix"* && "$moved" != "$prefix"* ]]; then
		pass "$relative is at $prefix, and the pin refuses the file with one byte appended (${moved:0:8})"
	else
		fail "$relative is at ${actual:0:8}, not $prefix (or its pin accepts a moved file: ${moved:0:8})"
	fi
done

# J10's lines, put back: what is left must be the D-339 slice and the D-339 layout, byte for byte.
present=0
for line in "$J10_COMMENT_1" "$J10_COMMENT_2" "$J10_CLEARING"; do
	present=$((present + $(grep -cxF -- "$line" "$PROJECT_DIR/$SLICE" | tr -d ' ')))
done
rebuilt="$(put_back_j11 "$PROJECT_DIR/$SLICE" | put_back_slice - | shasum -a 256 | cut -d' ' -f1)"
if [[ "$present" == "3" && "$rebuilt" == "$PRE_J10_SLICE_SHA256" ]]; then
	pass "the slice holds J10's 3 lines once each; dropped, it is, byte for byte, the D-339 file ${PRE_J10_SLICE_SHA256:0:8}"
else
	fail "the slice holds $present of J10's 3 lines, and put back hashes ${rebuilt:0:8}, not ${PRE_J10_SLICE_SHA256:0:8}"
fi
rebuilt_moved="$({ put_back_j11 "$PROJECT_DIR/$SLICE" | put_back_slice -; printf 'x'; } | shasum -a 256 | cut -d' ' -f1)"
if [[ "$rebuilt_moved" != "$PRE_J10_SLICE_SHA256" ]]; then
	pass "and that reconstruction pin refuses a rebuild with one byte appended (${rebuilt_moved:0:8})"
else
	fail "the slice's reconstruction pin accepts a moved rebuild and therefore proves nothing"
fi

present=0
for line in "$J10_SOCKET_1" "$J10_SOCKET_2" "$J10_SOCKET_3" "$J10_SOCKET_4" "$J10_ENTRY"; do
	present=$((present + $(grep -cxF -- "$line" "$PROJECT_DIR/$LAYOUT" | tr -d ' ')))
done
absent="$(grep -cxF -- "$PRE_J10_ENTRY" "$PROJECT_DIR/$LAYOUT" | tr -d ' ')"
rebuilt="$(put_back_layout "$PROJECT_DIR/$LAYOUT" | shasum -a 256 | cut -d' ' -f1)"
if [[ "$present" == "5" && "$absent" == "0" && "$rebuilt" == "$PRE_J10_LAYOUT_SHA256" ]]; then
	pass "the layout holds J10's 4 comment lines and moved socket once each and not the socket it replaced; put back, it is, byte for byte, the D-339 file ${PRE_J10_LAYOUT_SHA256:0:8}"
else
	fail "the layout holds $present of J10's 5 lines and $absent D-339 socket(s), and put back hashes ${rebuilt:0:8}, not ${PRE_J10_LAYOUT_SHA256:0:8}"
fi
rebuilt_moved="$({ put_back_layout "$PROJECT_DIR/$LAYOUT"; printf 'x'; } | shasum -a 256 | cut -d' ' -f1)"
if [[ "$rebuilt_moved" != "$PRE_J10_LAYOUT_SHA256" ]]; then
	pass "and that reconstruction pin refuses a rebuild with one byte appended (${rebuilt_moved:0:8})"
else
	fail "the layout's reconstruction pin accepts a moved rebuild and therefore proves nothing"
fi

listing="$work/production.txt"
production_listing > "$listing"
production_files="$(wc -l < "$listing" | tr -d ' ')"
production_digest="$(shasum -a 256 < "$listing" | cut -d' ' -f1)"
if [[ "$production_files" == "$EXPECTED_PRODUCTION_FILES" && "$production_digest" == "$EXPECTED_PRODUCTION_DIGEST" ]]; then
	pass "every other production file is as D-339 left it: $production_files files, digest ${production_digest:0:8}"
else
	fail "the production tree outside the slice and the layout moved: $production_files files, digest ${production_digest:0:8}, not $EXPECTED_PRODUCTION_FILES / ${EXPECTED_PRODUCTION_DIGEST:0:8}"
fi
moved_digest="$(sed '1s/$/x/' "$listing" | shasum -a 256 | cut -d' ' -f1)"
if [[ "$moved_digest" != "$EXPECTED_PRODUCTION_DIGEST" && "$moved_digest" != "$production_digest" ]]; then
	pass "and that pin refuses a listing with one line moved (${moved_digest:0:8})"
else
	fail "the production pin accepts a moved listing and therefore proves nothing"
fi

for runner in "$THIS_SMOKE" "${MOVED_RUNNERS[@]}"; do
	if [[ -x "$PROJECT_DIR/$runner" ]]; then
		pass "$runner is executable"
	else
		fail "$runner is not executable"
	fi
done

# --------------------------------------------------------------------------
step "3. The pinned verification passes headless, proved in BOTH directions"

verify_log="$work/verify.log"
run_verification "$verify_log" --headless --path "$PROJECT_DIR" --log-file "$work/godot_file.log" \
	--script "res://$THIS_VERIFICATION" -- --run-token "$RUN_TOKEN"
verify_status=$?
printf '  verification exit status: %s\n' "$verify_status"
assert_log_is_fresh "$verify_log"
assert_run_token "$verify_log" "$work/token_replay.log"
assert_no_script_error "the headless verification" "$verify_log"
assert_engine_output "the headless verification" "$verify_log"

if [[ "$verify_status" == "0" ]]; then
	pass "the verification exited 0"
elif [[ "$verify_status" == "142" ]]; then
	fail "the verification did not finish within $VERIFICATION_TIMEOUT s and was killed"
else
	fail "the verification exited $verify_status"
	grep -E "FAIL:" "$verify_log" | head -25 | cut -c1-400 | sed 's/^/        /'
fi

count="$(read_check_count "$BANNER" "$verify_log")"
if [[ "$count" == "$EXPECTED_CHECKS" ]]; then
	pass "verification passes at the pinned $EXPECTED_CHECKS checks"
else
	fail "verification reports ${count:-no} checks, not $EXPECTED_CHECKS"
fi

# A guard that accepts everything protects nothing: each pin must refuse a replay of this run's own log with its
# value moved, and must READ the moved value.
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

# The measurements this work exists to make, read out of the run's own log. The number of process frames a
# released control takes to lift the neutral latch, and what the latch reads after a click's own flush, can differ
# by a frame from run to run, so the lines that carry them are cut before them.
while IFS= read -r line; do
	if grep -qF -- "$line" "$verify_log"; then
		pass "measured: ${line}"
	else
		fail "the verification log does not report: ${line}"
	fi
done <<'MEASURED'
the slice is at its J10 hash 883ef25e, 814 lines; with J10's 2 comment lines and 1 clearing line put back it is, byte for byte, the D-339 file 942aee83, 811 lines
the layout is at its J10 hash cac924df, 513 lines; with J10's 4 comment lines removed and ENTRY_POINT put back to Vector2(3.0, -33.0) it is, byte for byte, the D-339 file 79c2b3a5, 509 lines
44 files J10 stands beside hold the hashes they held before the first J10 edit
put back, the 16 are byte for byte acbd3892, 6acc1e0c, dc9be60f, ec5bc37f, eff592af, e14e996b, b735e6c7, fea9988e, d38624c8, a444af4b, 2187ccb1, 22a95042, c980d240, 8c13aa43, 368f584e, 56258899 (88 replaced blocks)
13 code lines: J3's accepted body with clear_movement_intent(reason, false) directly after player.global_position = broken_watch.entry() and before the facing; D-339 had 12
35 fields, 8 exports, 53 functions in D-339's order, 12 constants, no signal and no enum; only restart_current_slice() differs from D-339; clear_movement_intent( appears 2 times in the slice's code, where D-339 had 1 — neutralize_for_modal()'s
the unchanged authority, read in the player: it clears the attack, the suspension, the destination, the agent's target, the locomotion reading and the velocity, keeps FALLEN, and re-arms the neutral latch only when asked — J10 passes false, so the latch the revival set stands
ENTRY_POINT is (3.0, -34.75); every function body and every other constant is D-339's; ENTRY_POINT is still named 4 times — its declaration, its socket marker and entry()'s two reads
the D-339 entry (3.0, -33.0) lies inside exactly one of Riftfall Landing Greybox V2's boundary masses — the tall Watch Breach far cap [P: (1.0, -34.0), S: (8.0, 4.0)], in the same local frame
the new entry is 0.75 m from the nearest boundary mass and 6.00 m from the nearest Broken Watch wall — both beyond the capsule's 0.40 m radius — and still inside the Watch Threshold
7 descend from BrokenWatchSlice: canonical_opening_runtime.gd, roguelite_build_variety_runtime.gd, roguelite_core_loop_runtime.gd, roguelite_experience_collection_review.gd, roguelite_level_up_choice_review.gd, roguelite_live_effect_review.gd, roguelite_replayability_runtime.gd
restart_current_slice() is declared by broken_watch_slice.gd, canonical_opening_runtime.gd, roguelite_core_loop_runtime.gd, roguelite_experience_collection_review.gd: Gate 1E's calls super first, so it inherits the clearing and the new socket; the core loop's overrides it without super and names no broken_watch; the experience review's calls super into the core loop's
broken_watch.entry() is read twice in running code: the slice's restart and Gate 1E's _spawn_for_milestone(), which continues a character at the BROKEN_WATCH milestone there; no other script reads BrokenWatchLayout.ENTRY_POINT
31 actions; the entrypoint is prototype_app.tscn; project.godot declares no [autoload]
the D-339 entry (3.00, -33.00) lies inside Riftfall Landing's ONE authored boundary mass over Broken Watch — the Watch Breach far cap [P: (1.0, -34.0), S: (8.0, 4.0)] — which First-MVP Gameplay J11 (D-344) now opens in this composition, so a capsule there meets nothing tall and the navigation mesh lies 0.0000 m from it
entry() now answers local (3.00, -34.75): the same capsule there meets only ground plates, the navigation mesh lies 0.0000 m from it, and a path from Riftfall Landing's player start reaches it in 39 points and 60.50 m, ending 0.0000 m from it
3 real Quick Strikes at 100 damage took the first Graveblade 300 -> 200 -> 100 -> 0; its died reached the slice's _on_first_graveblade_died() through the one connection, with 1 bound argument — the first Graveblade itself
the event named the player as source and the first Graveblade as target; the rewarded set holds the first Graveblade's id and not the player's; the latch is set and 1 drop was created
route 1: staged walking to a click destination 4.0 m ahead: the destination held and the character moving
route 1: in F5's own call: 0.0000 m from the entry, alive and IDLE at 500 / 500 Life and 100 / 100 Mana, facing the route; no destination, the agent's target 0.0000 m from the entry, no movement mode, planar speed 0.0000 m/s; no attack in progress, buffered or held, and no suspension; the marker hidden; the neutral latch set as 'encounter reset'; no Fallen armed; both Graveblades back at their spawns, alive and active
route 1: isolated, the first Graveblade 59.6 m from the entry: over 150 physics frames at most 0.0000 m from the entry and 0.0000 m/s, 0.0000 m at the end; no destination, restart, Fallen or attack; the marker hidden and the character facing the route at full Life at the end
route 1: after neutral, a new click 3.0 m on was accepted and moved the character more than 0.50 m in 30 physics frames
route 2, stick: staged with the stick held forward and the character moving
route 2, stick: in F5's own call: 0.0000 m from the entry, alive and IDLE at 500 / 500 Life and 100 / 100 Mana, facing the route; no destination, the agent's target 0.0000 m from the entry, no movement mode, planar speed 0.0000 m/s; no attack in progress, buffered or held, and no suspension; the marker hidden; the neutral latch set as 'encounter reset'; no Fallen armed; both Graveblades back at their spawns, alive and active
route 2, stick: isolated, the first Graveblade 59.6 m from the entry, the stick still held: over 150 physics frames at most 0.0000 m from the entry and 0.0000 m/s, 0.0000 m at the end; no destination, restart, Fallen or attack; the marker hidden and the character facing the route at full Life at the end; the latch held on all 150 frames
route 2, stick: released: the latch lifted
the character still 0.0000 m from the entry; a new deflection then moved it more than 0.50 m in 30 physics frames, in controller direct mode
route 2, left button: staged with the left button held on the ground 4.0 m ahead: the hold re-issuing, the destination held and the character moving
route 2, left button: in F5's own call: 0.0000 m from the entry, alive and IDLE at 500 / 500 Life and 100 / 100 Mana, facing the route; no destination, the agent's target 0.0000 m from the entry, no movement mode, planar speed 0.0000 m/s; no attack in progress, buffered or held, and no suspension; the marker hidden; the neutral latch set as 'encounter reset'; no Fallen armed; both Graveblades back at their spawns, alive and active
route 2, left button: isolated, the first Graveblade 59.6 m from the entry, the button still held: over 150 physics frames at most 0.0000 m from the entry and 0.0000 m/s, 0.0000 m at the end; no destination, restart, Fallen or attack; the marker hidden and the character facing the route at full Life at the end; the latch held on all 150 frames and every held re-issue was refused as 'rejected: awaiting neutral input'
route 2, left button: released: the hold ended and the latch lifted
the character still 0.0000 m from the entry; a new click then moved it more than 0.50 m in 30 physics frames
route 2, attack: staged with the stick held, then one real right press: a Quick Strike in its wind-up, the held stick suspended
route 2, attack: in F5's own call: 0.0000 m from the entry, alive and IDLE at 500 / 500 Life and 100 / 100 Mana, facing the route; no destination, the agent's target 0.0000 m from the entry, no movement mode, planar speed 0.0000 m/s; no attack in progress, buffered or held, and no suspension; the marker hidden; the neutral latch set as 'encounter reset'; no Fallen armed; both Graveblades back at their spawns, alive and active
route 2, attack: isolated, the first Graveblade 59.6 m from the entry, the stick and the right button still held: over 150 physics frames at most 0.0000 m from the entry and 0.0000 m/s, 0.0000 m at the end; no destination, restart, Fallen or attack; the marker hidden and the character facing the route at full Life at the end; the interrupted Quick Strike never released
route 2, attack: released: the latch lifted
the character still 0.0000 m from the entry, and no Quick Strike released
route 3: 4 real Graveblade Hits took Life 500 -> 375 -> 250 -> 125 -> 0 — "Graveblade — Melee Hit — 125 Physical Damage" — and the delay was armed and waiting
route 3: in F5's own call: 0.0000 m from the entry, alive and IDLE at 500 / 500 Life and 100 / 100 Mana, facing the route; no destination, the agent's target 0.0000 m from the entry, no movement mode, planar speed 0.0000 m/s; no attack in progress, buffered or held, and no suspension; the marker hidden; the neutral latch set as 'encounter reset'; no Fallen armed; both Graveblades back at their spawns, alive and active
route 3: isolated, the first Graveblade 59.6 m from the entry: over 150 physics frames at most 0.0000 m from the entry and 0.0000 m/s, 0.0000 m at the end; no destination, restart, Fallen or attack; the marker hidden and the character facing the route at full Life at the end — longer than the delay and the fade together, and Fallen never opened
route 4: 4 real Graveblade Hits took Life 500 -> 375 -> 250 -> 125 -> 0; the overlay opened by itself, paused, with "Restart Broken Watch" focused
route 4: Enter: the overlay closed once and in the restart's own call: 0.0000 m from the entry, alive and IDLE at 500 / 500 Life and 100 / 100 Mana, facing the route; no destination, the agent's target 0.0000 m from the entry, no movement mode, planar speed 0.0000 m/s; no attack in progress, buffered or held, and no suspension; the marker hidden; the neutral latch set as 'encounter reset'; no Fallen armed; both Graveblades back at their spawns, alive and active
route 4: isolated, the first Graveblade 59.6 m from the entry: over 150 physics frames at most 0.0000 m from the entry and 0.0000 m/s, 0.0000 m at the end; no destination, restart, Fallen or attack; the marker hidden and the character facing the route at full Life at the end
route 5: 4 real Graveblade Hits took Life 500 -> 375 -> 250 -> 125 -> 0; the overlay opened by itself, paused
route 5: one left press and release through Input.parse_input_event(): one pressed, on "Restart Broken Watch", and on no other button; the overlay closed once
route 5: two process frames after the restart: 0.0000 m from the entry, alive and IDLE at 500 / 500 Life and 100 / 100 Mana, facing the route; no destination, the agent's target 0.0000 m from the entry, no movement mode, planar speed 0.0000 m/s; no attack in progress, buffered or held, and no suspension; the marker hidden; the neutral latch set as 'encounter reset'; no Fallen armed; both Graveblades back at their spawns, alive and active — the latch read at the revival, inside the restart
route 5: isolated, the first Graveblade 59.6 m from the entry: over 150 physics frames at most 0.0000 m from the entry and 0.0000 m/s, 0.0000 m at the end; no destination, restart, Fallen or attack; the marker hidden and the character facing the route at full Life at the end; no movement command was issued, refused or accepted from the click to the end, the mouse hold never started and move_point was never held
both Graveblades present: in F5's own call: 0.0000 m from the entry, alive and IDLE at 500 / 500 Life and 100 / 100 Mana, facing the route; no destination, the agent's target 0.0000 m from the entry, no movement mode, planar speed 0.0000 m/s; no attack in progress, buffered or held, and no suspension; the marker hidden; the neutral latch set as 'encounter reset'; no Fallen armed; both Graveblades back at their spawns, alive and active
both Graveblades present: nothing moved or quieted after it: over 150 physics frames at most 0.0000 m from the entry and 0.0000 m/s, 0.0000 m at the end; no destination, restart, Fallen or attack; the marker hidden and the character facing the route at full Life at the end
both Graveblades present: at the end both Graveblades still stood at their spawns — 12.25 m and 42.25 m from the entry — alive, at full Life, active and unaware, and no attack permission was held
8 restarts, 1 drop created and 1 placement line; the same drop still lies there, the latch is set, the rewarded set is still [the first Graveblade's id], and no reward was refused
F5 with the character 3.00 m into the Nexus: 'run ended' and 'run reset' once each, the plan advanced once, the loop in HUB; in the call the character stood 0.0000 m from the Nexus entry, alive at full Life, with no destination
over 150 physics frames at most 0.0000 m from the Nexus entry and 0.0000 m/s — the core loop's own _place_player_at() teleport, as before
broken_watch and landing_layout are null and no node of either layout class exists in its tree: Broken Watch's socket cannot reach this scene
canonical_opening_runtime.gd extends BrokenWatchSlice and its restart_current_slice() calls super first, so it runs the clearing and returns to the moved socket; _spawn_for_milestone() continues a BROKEN_WATCH character at broken_watch.entry()
structural only: Gate 1E's scene never entered the tree in this run, and nothing of Gate 1E is measured here
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
step "5. Every protected file and .godot/ are byte-identical, and the owner's files and logs are untouched"

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
	pass "every other production file is still as D-339 left it after the runs"
else
	fail "a production file outside the slice and the layout changed during this run"
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
	pass "the project owner's own prototype_settings.cfg, prototype_zero.cfg and riftwrought_character.cfg are unchanged (the last $character_after)"
else
	fail "a file in the project owner's own user:// directory changed during this run"
fi
logs_after="$(directory_listing "$production_dir/logs")"
if [[ "$logs_after" == "$logs_before" ]]; then
	pass "Godot's own user://logs/ is unchanged — every invocation logged into this run's temporary directory"
else
	fail "Godot's own user://logs/ changed during this run"
fi

# --------------------------------------------------------------------------
step "6. This run's temporary directory is removed and nothing of J10 is left behind"

rm -rf "$work"
if [[ ! -e "$work" && "$(leftover_count)" == "0" ]]; then
	pass "the temporary directory is gone and no $TEMP_STEM.* directory remains in $TEMP_ROOT"
else
	fail "a J10 temporary directory remains in $TEMP_ROOT"
fi

# --------------------------------------------------------------------------
printf '\n'
if [[ "$failures" == "0" ]]; then
	printf 'RESTART POSITION STABILITY SMOKE CHECKS: PASS\n'
	printf '  %s checks; %s of %s owed; headless; %s protected files and .godot/ byte-identical\n' \
		"$EXPECTED_CHECKS" "$EXPECTED_OWED_CHECKS" "$EXPECTED_OWED_CHECKS" "${#PRESERVED_FILES[@]}"
	printf 'First-MVP Gameplay J10 — Gate 1D Restart Position Stability V1 — ACCEPTED\n'
	printf 'VERDICT: PASS — J10 is accepted.\n'
	printf 'D-223 remains OPEN.\n'
	reached_end=1
	exit 0
else
	printf 'RESTART POSITION STABILITY SMOKE CHECKS: %d FAILURE(S)\n' "$failures"
	reached_end=1
	exit 1
fi
