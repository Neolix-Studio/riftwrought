#!/usr/bin/env bash
# Riftwrought — First-MVP Gameplay J11: Gate 1D Landing-to-Broken-Watch Route Continuity V1 smoke checks
# (decision D-344).
#
# THIS IS NOT A GATE, AND IT RUNS NO LOCKED CHAIN. IT IS HEADLESS ONLY: IT HAS NO RENDERED MODE, SAVES NO
# SCREENSHOT AND OPENS NO WINDOW.
#
# J11 changes one production file. In Gate 1D's composed scene, Riftfall Landing's Watch Breach far cap stands
# inside Broken Watch's Watch Threshold — the two layouts are siblings in one shared local frame — and it
# blocked the route's own centreline: a player-sized capsule met it from local z = -30.0 to z = -34.0 and the
# navigation mesh was 2.55 m away at z = -32. The slice now removes that one cap's three built nodes from ITS
# OWN instance, before the navigation bake, exactly as `CanonicalOpeningRuntime` removes Broken Watch's own far
# cap toward the Nexus Threshold. `riftfall_landing_greybox_layout.gd` is untouched and the standalone Landing
# review still builds the cap. What this script proves:
#
#   1. the new verification, the slice and the eleven accepted verifications J11 moved parse, and this runner
#      and the nine accepted runners it moved pass `bash -n` and are executable;
#   2. the slice, the new verification, the engine, both store files and the twenty accepted suite files are at
#      their D-344 hashes, each pin refusing a file with one byte appended; the slice with J11's opening put
#      back is, byte for byte, the D-343 file; and no other production file has changed — one digest over every
#      file under scripts/, scenes/, data/, addons/ and assets/ and project.godot, the slice excepted and every
#      `.DS_Store` pruned;
#   3. the pinned verification passes headless, proved in BOTH directions against a replay of its own log — its
#      check count, its owed count, the exact owed SET and this run's own token — with every measured line read
#      out of the log; zero SCRIPT ERROR and zero engine ERROR; the two accepted bake warnings exactly twice
#      each (two scenes); neither startup probe; and no other engine WARNING;
#   4. `tests/provenance/` holds exactly the engine and the two store files, D-342's is byte-identical, and the
#      D-344 file is new — a store file is written once and never rewritten;
#   5. `project.godot` is untouched: 31 actions, the Prototype App entrypoint, the same nine sections, no
#      `[autoload]`;
#   6. every file this work stands beside and the whole `.godot/` directory are BYTE-IDENTICAL across the run,
#      the project owner's own user:// files are untouched, and Godot's own user://logs/ did not move;
#   7. this run's temporary directory is gone and no other J11 temporary directory is left behind.
#
# Everything this script writes goes into one `mktemp -d` directory, removed on every exit — Godot's own file
# log for every invocation included. Every walk this script makes prunes `.DS_Store`, and none reaches the
# repository's `assets/` directory.
#
# Usage, from the repository root:
#   game/tests/landing_broken_watch_route_continuity_smoke.sh

set -uo pipefail

# Assigned at the TOP of the script, never beside the function it serves.
RUN_STARTED_AT="$(date +%s)"
RUN_TOKEN="j11-${RUN_STARTED_AT}-$$-${RANDOM}"

reached_end=0
scratch=()
on_exit() {
	local code=$?
	for path in "${scratch[@]+"${scratch[@]}"}"; do
		rm -rf "$path"
	done
	if [[ "$reached_end" != "1" ]]; then
		printf '\nROUTE CONTINUITY SMOKE CHECKS: ABORTED before the end of the script\n'
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
TEMP_STEM="riftwrought_j11"
VERIFICATION_TIMEOUT=900

EXPECTED_INPUT_ACTIONS=31
EXPECTED_MAIN_SCENE="res://scenes/app/prototype_app.tscn"
EXPECTED_SECTIONS="application audio debug display editor_plugins input layer_names navigation rendering"
PROVENANCE_DIR="tests/provenance"

# The files this runner names, and every one of them pinned at its D-344 hash.
SLICE="scripts/first_mvp/severed_threshold/broken_watch_slice.gd"
THIS_VERIFICATION="tests/landing_broken_watch_route_continuity_verification.gd"
ENGINE="tests/provenance/accepted_suite_provenance.gd"
STORE_D342="tests/provenance/d342_accepted_suite_history.provenance"
STORE_D344="tests/provenance/d344_gate_1d_route_continuity.provenance"
J1_VERIFICATION="tests/first_mvp_modal_left_click_verification.gd"
J1_SMOKE="tests/first_mvp_modal_left_click_smoke.sh"
J2_VERIFICATION="tests/fallen_modal_life_state_verification.gd"
J2_SMOKE="tests/fallen_modal_life_state_smoke.sh"
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
J10_VERIFICATION="tests/restart_position_stability_verification.gd"
J10_SMOKE="tests/restart_position_stability_smoke.sh"
VM1_VERIFICATION="tests/non_nesting_accepted_suite_reconstruction_verification.gd"
VM1_SMOKE="tests/non_nesting_accepted_suite_reconstruction_smoke.sh"
THIS_SMOKE="tests/landing_broken_watch_route_continuity_smoke.sh"

D344_ROWS=(
	"$SLICE|d4e839fb"
	"$THIS_VERIFICATION|64c4f067"
	"$ENGINE|fadbdfeb"
	"$STORE_D342|3b38ca4d"
	"$STORE_D344|0ab807ed"
	"$J1_VERIFICATION|d12ad271"
	"$J1_SMOKE|977c05bd"
	"$J2_VERIFICATION|72e39a8a"
	"$J2_SMOKE|9e0977fb"
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
	"$J10_VERIFICATION|1588cff8"
	"$J10_SMOKE|34db74ce"
	"$VM1_VERIFICATION|03c174ad"
	"$VM1_SMOKE|64daa9bf"
)
MOVED_VERIFICATIONS=("$J1_VERIFICATION" "$J2_VERIFICATION" "$J3_VERIFICATION" "$J4_VERIFICATION" "$J5_VERIFICATION" "$J6_VERIFICATION" "$J7_VERIFICATION" "$J8_VERIFICATION" "$J9_VERIFICATION" "$J10_VERIFICATION" "$VM1_VERIFICATION")
MOVED_RUNNERS=("$THIS_SMOKE" "$J3_SMOKE" "$J4_SMOKE" "$J5_SMOKE" "$J6_SMOKE" "$J7_SMOKE" "$J8_SMOKE" "$J9_SMOKE" "$J10_SMOKE" "$VM1_SMOKE")

# Pinned, and proved in both directions below.
EXPECTED_CHECKS=38
EXPECTED_OWED_CHECKS=14
OWED_SET="the_production_diff_is_exactly_the_composition_local_cap_opening, the_slice_declares_nothing_new_and_only_ready_differs_from_d343, the_accepted_suites_moved_only_their_pins_and_read_back_layers, the_d342_store_is_untouched_and_the_d344_store_is_flat_and_content_addressed, the_provenance_records_refuse_mutation_omission_duplication_reordering_and_wrong_targets, the_reach_is_gate_1d_and_gate_1e_by_structure_and_not_the_roguelite, exactly_one_landing_boundary_mass_qualifies_and_only_its_three_nodes_are_removed, the_opening_precedes_the_bake_and_one_continuous_map_is_baked, the_seam_is_navigable_through_the_former_cap_footprint_on_both_faces, the_path_continues_to_the_entry_and_to_the_first_encounter_area, a_real_player_body_walks_the_seam_under_ordinary_movement, j10s_entry_socket_and_restart_stability_are_unchanged, j9s_binding_the_drop_latch_and_the_encounter_reset_are_unchanged, the_standalone_landing_keeps_its_far_cap_its_boundary_list_and_its_sockets"

# Every production file but the slice, as J11 leaves them, each line `sha256  path`, sorted, digested.
EXPECTED_PRODUCTION_FILES=863
EXPECTED_PRODUCTION_DIGEST="15042662b1aae29f029c306033d9a476a965d1805555fef34ab25c9e22054758"

# The slice as D-343 left it, and the two lines that bound J11's opening.
PRE_J11_SLICE_SHA256="883ef25e0cf401607e38094b0d303820da6dc8114ad849f1616869941d328a55"
J11_FIRST=$'\t# First-MVP Gameplay J11 (decision D-344): RIFTFALL LANDING CLOSED ITS OWN FAR END,'
J11_LAST=$'\tlog_event("landing cap opened", "%d Riftfall Landing boundary mass overlaps Broken Watch; its %d built nodes are removed in THIS composition, before the bake" % [landing_caps.size(), cap_nodes_removed])'
EXPECTED_D342_BYTES=412215
EXPECTED_D344_BYTES=83610

# Fingerprinted before and after the run.
PRESERVED_FILES=(
	"scripts/first_mvp/severed_threshold/broken_watch_slice.gd"
	"tests/landing_broken_watch_route_continuity_verification.gd"
	"tests/provenance/accepted_suite_provenance.gd"
	"tests/provenance/d342_accepted_suite_history.provenance"
	"tests/provenance/d344_gate_1d_route_continuity.provenance"
	"tests/first_mvp_modal_left_click_verification.gd"
	"tests/first_mvp_modal_left_click_smoke.sh"
	"tests/fallen_modal_life_state_verification.gd"
	"tests/fallen_modal_life_state_smoke.sh"
	"tests/pending_fallen_restart_verification.gd"
	"tests/pending_fallen_restart_smoke.sh"
	"tests/fallen_delay_item_interaction_verification.gd"
	"tests/fallen_delay_item_interaction_smoke.sh"
	"tests/fallen_delay_drop_highlight_verification.gd"
	"tests/fallen_delay_drop_highlight_smoke.sh"
	"tests/combat_hud_fractional_fill_verification.gd"
	"tests/combat_hud_fractional_fill_smoke.sh"
	"tests/enemy_hover_life_fractional_fill_verification.gd"
	"tests/enemy_hover_life_fractional_fill_smoke.sh"
	"tests/combat_hud_safe_bottom_placement_verification.gd"
	"tests/combat_hud_safe_bottom_placement_smoke.sh"
	"tests/guaranteed_drop_defeated_enemy_binding_verification.gd"
	"tests/guaranteed_drop_defeated_enemy_binding_smoke.sh"
	"tests/restart_position_stability_verification.gd"
	"tests/restart_position_stability_smoke.sh"
	"tests/non_nesting_accepted_suite_reconstruction_verification.gd"
	"tests/non_nesting_accepted_suite_reconstruction_smoke.sh"
	"scripts/first_mvp/greybox/riftfall_landing_greybox_layout.gd"
	"scripts/first_mvp/severed_threshold/broken_watch_layout.gd"
	"scripts/actors/prototype_player.gd"
	"scripts/actors/prototype_graveblade.gd"
	"scripts/combat/quick_strike_action.gd"
	"scripts/combat/attack_coordinator.gd"
	"scripts/combat/target_acquisition.gd"
	"scripts/combat/damage_event.gd"
	"scripts/movement/prototype_locomotion.gd"
	"scripts/movement/prototype_ground_pointer.gd"
	"scripts/movement/prototype_mouse_hold.gd"
	"scripts/items/first_mvp_item_drop.gd"
	"scripts/items/player_loadout.gd"
	"scripts/ui/first_mvp_combat_hud.gd"
	"scripts/ui/first_mvp_modal.gd"
	"scripts/ui/first_mvp_fallen_overlay.gd"
	"scripts/ui/first_mvp_item_comparison.gd"
	"scripts/camera/prototype_camera_rig.gd"
	"scripts/input/input_family_tracker.gd"
	"scripts/prototype_zero/destination_marker.gd"
	"scripts/first_mvp/canonical_opening/canonical_opening_runtime.gd"
	"scripts/roguelite/roguelite_core_loop_runtime.gd"
	"scenes/first_mvp/severed_threshold/broken_watch_slice.tscn"
	"scenes/first_mvp/greybox/riftfall_landing_greybox_review.tscn"
	"scenes/first_mvp/canonical_opening/canonical_opening.tscn"
	"scenes/roguelite/roguelite_core_loop.tscn"
	"scenes/actors/prototype_player.tscn"
	"scenes/actors/prototype_graveblade.tscn"
	"data/prototype_zero/graveblade.tres"
	"data/first_mvp/severed_threshold/broken_watch/starting_sword.tres"
	"data/first_mvp/severed_threshold/broken_watch/watchsteel_sword.tres"
	"project.godot"
	"tests/gate_1d_broken_watch_verification.gd"
	"tests/gate_1d_broken_watch_smoke.sh"
	"tests/gate_1e_canonical_opening_verification.gd"
	"tests/roguelite_core_loop_verification.gd"
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
		printf '%s bytes, sha256 %s, mtime %s' "$(wc -c < "$1" | tr -d ' ')" \
			"$(shasum -a 256 "$1" | cut -d' ' -f1)" "$(stat -f %m "$1")"
	else
		printf 'absent'
	fi
}

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

# Every production file but the slice, by path and content, every `.DS_Store` pruned.
production_listing() {
	(cd "$PROJECT_DIR" && find scripts scenes data addons assets project.godot -type f ! -name .DS_Store ! -path "$SLICE" -print0 \
		| sort -z | xargs -0 shasum -a 256)
}

# The slice with J11's composition-local cap opening dropped: the block runs from its first comment line to its
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

BAKE_CLIMB="WARNING: Property agent_max_climb is floored to cell_height voxel units and loses precision."
BAKE_RADIUS="WARNING: Property agent_radius is ceiled to cell_size voxel units and loses precision."
SLICE_PROBE="WARNING: BrokenWatchSlice: the navigation map did not become queryable"
REVIEW_PROBE="WARNING: RiftfallLandingGreyboxReview"
EXPECTED_BAKE_LINES=2

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
	probes="$(grep -cF -e "$SLICE_PROBE" -e "$REVIEW_PROBE" "$logfile" | tr -d ' ')"
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
	grep -ohE "$1: PASS \([0-9]+ checks\)" "$2" | grep -ohE '[0-9]+ checks' | grep -ohE '[0-9]+' | head -1
}

run_verification() {
	local logfile="$1"
	shift
	perl -e 'alarm shift; exec @ARGV' "$VERIFICATION_TIMEOUT" "$GODOT" "$@" > "$logfile" 2>&1
}

BANNER="LANDING TO BROKEN WATCH ROUTE CONTINUITY VERIFICATION"

stale_before="$(leftover_count)"
work="$(mktemp -d -t "$TEMP_STEM")"
scratch+=("$work")

printf 'Riftwrought — First-MVP Gameplay J11: Gate 1D Landing-to-Broken-Watch Route Continuity V1 smoke checks (D-344)\n'
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
	pass "no J11 temporary directory was left behind by an earlier run"
else
	fail "$stale_before J11 temporary director(y/ies) from an earlier run remain in $TEMP_ROOT — remove them"
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
step "1. The new verification, the slice and the moved verifications parse; this runner and the moved runners pass bash -n and are executable"

for relative in "$THIS_VERIFICATION" "$SLICE" "${MOVED_VERIFICATIONS[@]}"; do
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
	if [[ -x "$PROJECT_DIR/$relative" ]]; then
		pass "$relative is executable"
	else
		fail "$relative is not executable"
	fi
done

# --------------------------------------------------------------------------
step "2. Every pinned file is at its D-344 hash, the slice rebuilds to D-343, and no other production file moved"

for row in "${D344_ROWS[@]}"; do
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

present=0
for line in "$J11_FIRST" "$J11_LAST"; do
	present=$((present + $(grep -cxF -- "$line" "$PROJECT_DIR/$SLICE" | tr -d ' ')))
done
rebuilt="$(put_back_j11 "$PROJECT_DIR/$SLICE" | shasum -a 256 | cut -d' ' -f1)"
if [[ "$present" == "2" && "$rebuilt" == "$PRE_J11_SLICE_SHA256" ]]; then
	pass "the slice holds J11's opening once; dropped, it is, byte for byte, the D-343 file ${PRE_J11_SLICE_SHA256:0:8}"
else
	fail "the slice holds $present of J11's 2 anchor lines, and put back hashes ${rebuilt:0:8}, not ${PRE_J11_SLICE_SHA256:0:8}"
fi
rebuilt_moved="$({ put_back_j11 "$PROJECT_DIR/$SLICE"; printf 'x'; } | shasum -a 256 | cut -d' ' -f1)"
if [[ "$rebuilt_moved" != "$PRE_J11_SLICE_SHA256" ]]; then
	pass "and that reconstruction pin refuses a rebuild with one byte appended (${rebuilt_moved:0:8})"
else
	fail "the slice's reconstruction pin accepts a moved rebuild and therefore proves nothing"
fi

listing="$work/production.txt"
production_listing > "$listing"
production_files="$(wc -l < "$listing" | tr -d ' ')"
production_digest="$(shasum -a 256 < "$listing" | cut -d' ' -f1)"
if [[ "$production_files" == "$EXPECTED_PRODUCTION_FILES" && "$production_digest" == "$EXPECTED_PRODUCTION_DIGEST" ]]; then
	pass "every other production file is as D-343 left it: $production_files files, digest ${production_digest:0:8}"
else
	fail "the production tree outside the slice moved: $production_files files, digest ${production_digest:0:8}, not $EXPECTED_PRODUCTION_FILES / ${EXPECTED_PRODUCTION_DIGEST:0:8}"
fi
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

replay="$work/replay.log"
sed "s/$BANNER: PASS ($EXPECTED_CHECKS checks)/$BANNER: PASS ($((EXPECTED_CHECKS + 1)) checks)/" "$verify_log" > "$replay"
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

# The measurements this work exists to make, read out of the run's own log. Two lines carry a frame count that
# can differ by a frame from run to run, so they are cut before it.
while IFS= read -r line; do
	if grep -qF -- "$line" "$verify_log"; then
		pass "measured: ${line}"
	else
		fail "the verification log does not report: ${line}"
	fi
done <<'MEASURED'
the slice is at its J11 hash d4e839fb, 857 lines; with J11's 43-line opening put back it is, byte for byte, the D-343 file 883ef25e, 814 lines
`riftfall_landing_greybox_layout.gd` is untouched at 21afae31 and `broken_watch_layout.gd` at cac924df — the cap is NOT deleted from the Landing, and J10's socket did not move
16 file(s) J11 stands beside hold the hashes they held before the first J11 edit
35 fields, 8 exports, 53 functions in D-343's order, 12 constants, no signal and no enum — the counts every accepted suite pins; only _ready() differs from D-343
the Landing is resolved, then the cap is opened, then the navigation is configured and baked: code lines 3, 15, 36, 37 of _ready()
the cap is found from both layouts' own authored constants, never from the node name Boundary_10_-340, and a wrong count fails through push_error() as well as assert(), which release builds strip
put back through the store, the 18 are byte for byte 75f26486, 935a37e9, 53c37976, 9a860bca, 15352d8a, 0fd60eb7, 6204a260, 08aa2d0b, d23c5fdc, be9f6f47, 09e25736, 85a49a22, bfab962c, 95506b40, e526397b, 22544403, bf25715a, 02f03162 (162 replaced blocks)
the two Verification Maintenance V1 files rebuild to a9844935, 7b979661 through 94 inline blocks — they are inline because each names the D-344 store's own SHA-256, which a record inside that store could not
d342_accepted_suite_history.provenance is byte-identical at 3b38ca4d, 412215 bytes — D-344 rewrote nothing
d344_gate_1d_route_continuity.provenance is 0ab807ed, 83610 bytes: 155 texts each one literal `=` segment and each hashing to its name, 18 pair lists, 19 edges, and ZERO `%` or `&` reference lines
the union is 737 texts, 104 pair lists and 165 edges, and all 19 D-344 edges put their file back to the bytes D-343 left
no accepted suite's body, raw or escaped, and no D-342 pair-list name is inside the new file: the graph is flat and non-nesting
10 mutation case(s) refused and none accepted; a wrong target state and a wrong target file are both refused; a pin one character off resolves to nothing
229 script(s) scanned; exactly 2 extend BrokenWatchSlice directly: canonical_opening_runtime.gd, roguelite_core_loop_runtime.gd — and no script but the slice itself names RiftfallLandingGreyboxLayout.BOUNDARY_MASSES or the cap node
Gate 1D runs the opening in its own _ready(); Gate 1E's CanonicalOpeningRuntime inherits it through `await super._ready()` and creates NO second Landing-cap opening — it still removes Broken Watch's opposite far cap toward the Nexus Threshold, by CAP_HEIGHT, in its own _open_broken_watch_far_cap()
the Roguelite Core Loop extends the slice for the TYPE and deliberately does not call super._ready(), and names neither layout, so it never composes the Landing with Broken Watch and is untouched
structural only: Gate 1E's scene never entered the tree in this run, and nothing of Gate 1E is measured here
1 of 11 Riftfall Landing boundary masses overlaps a Broken Watch walkable rectangle: the Watch Breach far cap [P: (1.0, -34.0), S: (8.0, 4.0)], 32.00 m^2 of the Watch Threshold
its three built nodes are gone — Visuals/Boundary_10_-340, WorldCollision/Boundary_10_-340 and NavigationObstacles/Boundary_10_-340Carve — and every other Landing solid remains: 34 visuals, 30 colliders, 15 carves, one of each fewer than the Landing builds alone
Broken Watch is untouched: 25 visuals, 24 colliders and 19 carves, every one of them still there
the cap is opened at log line 0 and the navigation baked at 1 — before, not after — in 1 bake over 1 region: 166 polygons, 1887.89 m^2 walkable
15 stations along the route's own centreline, local x = 3.0 from z = -28.0 to z = -35.0 in 0.5 m steps: every one ON the navigation mesh (at most 0.0000 m) and none meeting any tall solid
a path from local (3.0, -28.0) to the entry runs 3 points and 6.75 m, straight through the former cap: it crosses the near face z = -30.0 AND the far face z = -34.0, holds a waypoint inside the old footprint, and never leaves x = 3.0 by more than 0.00 m
before the edit the same query answered 9 points and 10.93 m, swinging west to local x = 0.45 around the cap, and the mesh was 2.55 m away at z = -32.00
Riftfall Landing's player start -> Broken Watch's entry: 39 points, 60.50 m, ending 0.0000 m from it, with a waypoint inside the former cap footprint — before the edit it was 38 points and 62.78 m around the cap
on to the first encounter area: 44 points, 72.73 m, ending 0.0000 m from FirstEncounterSpawn; and to Broken Watch's exit socket: 63 points, 115.71 m
click-to-move through the production chain — PrototypeGroundPointer.resolve_to_navigation() then PrototypePlayer.command_move_to(), the two lines _issue_move_command() itself runs — from local (3.0, -22.0) to the entry: the body reached it in 154 physics frames
nothing was teleported: the largest single physics step was 0.0833 m against the 0.1500 m an accepted 5.0 m/s body can take, the body never left the navigation mesh by more than 0.0000 m, never stalled, never rose more than 0.000 m, and no position was written during the window
and with the navigation agent given nothing at all — the InputMap's own move_vector_forward held through Input.action_press(), direct physics against real collision — the body still passed both former faces, reaching local z = -34.46
the first Graveblade stood 47.1 m away and quiet for both windows, so neither its collision nor its AI could touch the result
BrokenWatchLayout.ENTRY_POINT is still (3.0, -34.75) and restart_current_slice() still calls clear_movement_intent(reason, false) directly after the entry
F5 with a stale click destination 4.0 m ahead: in the restart's own call 0.0000 m from the entry, and over 150 physics frames at most 0.0000 m and 0.0000 m/s, ending 0.0000 m away, with no destination and the latch still 'encounter reset'
a real Fallen Restart, four Graveblade Hits then Enter on the focused "Restart Broken Watch": the overlay closed once and the character stood 0.0000 m from the entry, at most 0.0000 m over 150 frames
three real Quick Strikes at 100 damage took the first Graveblade 300 -> 200 -> 100 -> 0; its died reached the slice's _on_first_graveblade_died through the one connection, whose 1 bound argument is that Graveblade itself
the event named the player as source and the first Graveblade as target; the rewarded set holds the first Graveblade's id and not the player's; the latch is set and exactly 1 drop was created
after 2 restarts the same drop still lies there, the latch is still set, the rewarded set still holds 1 id, and both Graveblades are back at their spawns, alive and active
instanced by itself, the accepted review still holds Visuals/Boundary_10_-340, WorldCollision/Boundary_10_-340 and NavigationObstacles/Boundary_10_-340Carve — the cap is NOT deleted, only opened inside Gate 1D's own composition
its authored boundary list is unchanged at 11 masses, and it builds 35 visuals, 31 colliders and 16 carves — one of each MORE than Gate 1D's composed instance
its measurements are the accepted ones: 1201.00 m^2 walkable, an 8.000 m Watch Breach clearance and an 8.000 m narrowest clearance, with PlayerStart (-7.0, 24.0) and WayOut (3.0, -27.0) exactly where they were
MEASURED

# --------------------------------------------------------------------------
step "4. The provenance directory holds exactly the engine and the two store files, and D-342's is byte-identical"

stored="$(cd "$PROJECT_DIR/$PROVENANCE_DIR" && find . -mindepth 1 ! -name .DS_Store | sort | tr '\n' ' ' | sed 's/ $//')"
if [[ "$stored" == "./$(basename "$ENGINE") ./$(basename "$STORE_D342") ./$(basename "$STORE_D344")" ]]; then
	pass "$PROVENANCE_DIR/ holds exactly the engine and the two store files (.DS_Store pruned), and no directory"
else
	fail "$PROVENANCE_DIR/ holds: $stored"
fi
d342_bytes="$(wc -c < "$PROJECT_DIR/$STORE_D342" | tr -d ' ')"
d344_bytes="$(wc -c < "$PROJECT_DIR/$STORE_D344" | tr -d ' ')"
if [[ "$d342_bytes" == "$EXPECTED_D342_BYTES" && "$d344_bytes" == "$EXPECTED_D344_BYTES" ]]; then
	pass "D-342's store is still $d342_bytes bytes and D-344's is $d344_bytes — the older file was not rewritten"
else
	fail "the store files are $d342_bytes and $d344_bytes bytes, not $EXPECTED_D342_BYTES and $EXPECTED_D344_BYTES"
fi

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
step "6. Every protected file and .godot/ are byte-identical, and the owner's files and logs are untouched"

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
	pass "every other production file is still as D-343 left it after the runs"
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
step "7. This run's temporary directory is removed and nothing of J11 is left behind"

rm -rf "$work"
if [[ ! -e "$work" && "$(leftover_count)" == "0" ]]; then
	pass "the temporary directory is gone and no $TEMP_STEM.* directory remains in $TEMP_ROOT"
else
	fail "a J11 temporary directory remains in $TEMP_ROOT"
fi

# --------------------------------------------------------------------------
printf '\n'
if [[ "$failures" == "0" ]]; then
	printf 'ROUTE CONTINUITY SMOKE CHECKS: PASS\n'
	printf '  %s checks; %s of %s owed; headless; %s protected files and .godot/ byte-identical\n' \
		"$EXPECTED_CHECKS" "$EXPECTED_OWED_CHECKS" "$EXPECTED_OWED_CHECKS" "${#PRESERVED_FILES[@]}"
	printf 'First-MVP Gameplay J11 — Gate 1D Landing-to-Broken-Watch Route Continuity V1 — ACCEPTED\n'
	printf 'VERDICT: PASS — J11 is accepted.\n'
	printf 'D-223 remains OPEN.\n'
	reached_end=1
	exit 0
else
	printf 'ROUTE CONTINUITY SMOKE CHECKS: %d FAILURE(S)\n' "$failures"
	reached_end=1
	exit 1
fi
