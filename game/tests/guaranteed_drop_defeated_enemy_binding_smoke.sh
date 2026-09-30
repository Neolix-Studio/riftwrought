#!/usr/bin/env bash
# Riftwrought — First-MVP Gameplay J9: Gate 1D Guaranteed-Drop Defeated-Enemy Binding V1 smoke checks (decision D-338).
#
# THIS IS NOT A GATE, AND IT RUNS NO LOCKED CHAIN. IT IS HEADLESS ONLY: IT HAS NO RENDERED MODE, SAVES NO
# SCREENSHOT AND OPENS NO WINDOW.
#
# J9 changes one production file, Gate 1D's slice, in two places: its one `died` connection now binds the
# first Graveblade, and `_on_first_graveblade_died()` receives that Graveblade and keys the rewarded set on
# it, where it used to read `DamageEvent.source` — the attacker. What this script proves:
#
#   1. the new verification, the slice and the eight accepted verifications J9 moved parse, and this runner
#      and the six accepted runners J9 moved pass `bash -n`;
#   2. the slice, the new verification and the fourteen accepted suite files J9 moved are at their D-338
#      hashes, each pin refusing a file with one byte appended; the slice with J9's changes put back is, byte
#      for byte, the D-337 file; no other production file has changed — one digest over every file under
#      scripts/, scenes/, data/, addons/ and assets/ and project.godot, the slice excepted and every
#      `.DS_Store` pruned; and the six moved runners are still executable;
#   3. the pinned verification passes headless, proved in BOTH directions against a replay of its own log —
#      its check count, its owed count, the exact owed SET and this run's own token — with the measured lines
#      read out of the log, including the fourteen moved files rebuilt to their D-337 hashes; zero SCRIPT ERROR
#      and zero engine ERROR; the two accepted bake warnings exactly twice each (two scenes); neither startup
#      probe; and no other engine WARNING;
#   4. `project.godot` is untouched: 31 actions, the Prototype App entrypoint, the same nine sections, no
#      `[autoload]`;
#   5. every file this work stands beside and the whole `.godot/` directory are BYTE-IDENTICAL across the run,
#      the project owner's own user:// files are untouched, and Godot's own user://logs/ did not move;
#   6. this run's temporary directory is gone and no other J9 temporary directory is left behind.
#
# Everything this script writes goes into one `mktemp -d` directory, removed on every exit — Godot's own file
# log for every invocation included. Every walk this script makes prunes `.DS_Store`, and none reaches the
# repository's `assets/` directory.
#
# Usage, from the repository root:
#   game/tests/guaranteed_drop_defeated_enemy_binding_smoke.sh

set -uo pipefail

# Assigned at the TOP of the script, never beside the function it serves.
RUN_STARTED_AT="$(date +%s)"
RUN_TOKEN="j9-${RUN_STARTED_AT}-$$-${RANDOM}"

reached_end=0
scratch=()
on_exit() {
	local code=$?
	for path in "${scratch[@]+"${scratch[@]}"}"; do
		rm -rf "$path"
	done
	if [[ "$reached_end" != "1" ]]; then
		printf '\nGUARANTEED DROP DEFEATED ENEMY BINDING SMOKE CHECKS: ABORTED before the end of the script\n'
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
TEMP_STEM="riftwrought_j9"

# Pinned, and proved in both directions below.
EXPECTED_CHECKS=31
EXPECTED_OWED_CHECKS=15
OWED_SET="the_production_diff_is_exactly_the_bound_emitter, the_accepted_suites_moved_only_their_pins_and_reconstructions, only_the_connection_and_the_callbacks_first_lines_changed, the_callback_is_named_and_connected_only_by_the_slice, no_combat_scene_input_map_or_project_behaviour_changed, a_real_first_graveblade_death_names_the_player_as_source_and_the_graveblade_as_target, the_production_connection_carries_the_exact_first_graveblade, the_rewarded_set_holds_the_defeated_graveblade_and_not_the_attacker, exactly_one_watchsteel_drop_lies_where_the_unchanged_route_resolves_it, a_repeated_death_signal_naming_another_attacker_is_refused_as_the_same_graveblade, the_second_graveblade_stays_outside_the_guaranteed_drop_connection, a_restart_revives_both_and_a_second_real_kill_is_refused_without_a_second_drop, the_fallen_delay_item_interaction_and_highlight_behave_as_accepted, the_roguelite_core_loop_binds_its_own_enemies_and_never_connects_the_callback, gate_1e_inherits_the_binding_by_structure_only_and_is_not_run"
VERIFICATION_TIMEOUT=600

EXPECTED_INPUT_ACTIONS=31
EXPECTED_MAIN_SCENE="res://scenes/app/prototype_app.tscn"
EXPECTED_SECTIONS="application audio debug display editor_plugins input layer_names navigation rendering"

# Every production file but the slice, as it stood at the end of D-337: 863 files under scripts/, scenes/,
# data/, addons/ and assets/ and project.godot, every `.DS_Store` pruned, each line `sha256  path`, sorted,
# digested.
# First-MVP Gameplay J10 (D-340) moved it one for one, from 3bb069c7, when Broken Watch's layout moved.
EXPECTED_PRODUCTION_FILES=863
EXPECTED_PRODUCTION_DIGEST="15042662b1aae29f029c306033d9a476a965d1805555fef34ab25c9e22054758"

# The slice as D-337 left it, whole, and J9's lines in it and the lines they replaced.
PRE_J9_SLICE_SHA256="f83e94367fd69a98833017554cc034ac87cb250047cc64eb286627e106dbbbc2"
J9_COMMENT_1=$'\t# First-MVP Gameplay J9 (decision D-338): the Graveblade that emits `died` is'
J9_COMMENT_2=$'\t# bound, because `DamageEvent.source` is the attacker, not the enemy that died.'
J9_CONNECTION=$'\tgraveblades[0].died.connect(_on_first_graveblade_died.bind(graveblades[0]))'
J9_SIGNATURE='func _on_first_graveblade_died(event: DamageEvent, enemy: PrototypeGraveblade) -> void:'
PRE_J9_CONNECTION=$'\tgraveblades[0].died.connect(_on_first_graveblade_died)'
PRE_J9_SIGNATURE='func _on_first_graveblade_died(event: DamageEvent) -> void:'
PRE_J9_ATTACKER_READ=$'\tvar enemy: Node = event.source'
# J10's lines in the slice (D-340), dropped before J9's are put back.
J10_COMMENT_1=$'\t# First-MVP Gameplay J10 (decision D-340): the revival keeps the old destination,'
J10_COMMENT_2=$'\t# locomotion and attack, so the one neutralization authority ends them at the entry.'
J10_CLEARING=$'\tplayer.clear_movement_intent(reason, false)'

# Engine warnings the verification may print, each with the exact number of times it must appear: the accepted
# navigation bake's two precision lines, once per scene for the two scenes it loads — Gate 1D's slice and the
# Roguelite Core Loop. Neither scene's startup probe may appear at all.
BAKE_CLIMB="WARNING: Property agent_max_climb is floored to cell_height voxel units and loses precision."
BAKE_RADIUS="WARNING: Property agent_radius is ceiled to cell_size voxel units and loses precision."
SLICE_PROBE="WARNING: BrokenWatchSlice: the navigation map did not become queryable"
LOOP_PROBE="WARNING: RogueliteCoreLoopRuntime: the navigation map did not become queryable"
EXPECTED_BAKE_LINES=2

THIS_VERIFICATION="tests/guaranteed_drop_defeated_enemy_binding_verification.gd"
THIS_SMOKE="tests/guaranteed_drop_defeated_enemy_binding_smoke.sh"
SLICE="scripts/first_mvp/severed_threshold/broken_watch_slice.gd"
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

# The slice, this runner's own verification and the fourteen accepted suite files J9 moved, at their D-338 hashes.
# First-MVP Gameplay J10 (D-340) moved all sixteen again, one for one, from 942aee83, 368f584e, acbd3892, 6acc1e0c, dc9be60f, ec5bc37f, eff592af, e14e996b, b735e6c7, fea9988e, d38624c8, a444af4b, 2187ccb1, 22a95042, c980d240 and 8c13aa43, when Gate 1D's slice moved.
# Verification Maintenance V1 (D-342) moved this runner's verification and nine of the others again, one for one, from ae964685, 5c8e9b07, dceea6f9, b1b456bd, f7144aac, 6cf22e7d, 0b816f06, 0dbde2d8, b709813c and 900c8d9e, when their put-back pairs moved into the flat provenance store.
# First-MVP Gameplay J11 (D-344) moved this runner's rows again, one for one, when Gate 1D's slice came to open Riftfall Landing's Watch Breach far cap in its own composition.
D338_ROWS=(
	"$SLICE|d4e839fb"
	"$THIS_VERIFICATION|aaa9e1d3"
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
)
MOVED_VERIFICATIONS=("$J1_VERIFICATION" "$J2_VERIFICATION" "$J3_VERIFICATION" "$J4_VERIFICATION" "$J5_VERIFICATION"
	"$J6_VERIFICATION" "$J7_VERIFICATION" "$J8_VERIFICATION")
MOVED_RUNNERS=("$J3_SMOKE" "$J4_SMOKE" "$J5_SMOKE" "$J6_SMOKE" "$J7_SMOKE" "$J8_SMOKE")

# Fingerprinted before and after the run: the changed file, this verification, every accepted suite file J9
# moved, everything the verification pins as unchanged, the project owner's composed zone, and the two
# handoff documents.
PRESERVED_FILES=(
	"$SLICE"
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
	"scripts/actors/prototype_player.gd"
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
	"scripts/movement/prototype_ground_pointer.gd"
	"scripts/movement/prototype_locomotion.gd"
	"scripts/input/input_family_tracker.gd"
	"scripts/items/first_mvp_item_drop.gd"
	"scripts/items/player_loadout.gd"
	"scripts/ui/first_mvp_modal.gd"
	"scripts/ui/first_mvp_item_comparison.gd"
	"scripts/ui/first_mvp_fallen_overlay.gd"
	"scripts/ui/first_mvp_combat_hud.gd"
	"scripts/first_mvp/severed_threshold/broken_watch_layout.gd"
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

# Every production file but the slice, by path and content, every `.DS_Store` pruned.
production_listing() {
	(cd "$PROJECT_DIR" && find scripts scenes data addons assets project.godot -type f ! -name .DS_Store ! -path "$SLICE" -print0 \
		| sort -z | xargs -0 shasum -a 256)
}
J11_FIRST=$'\t# First-MVP Gameplay J11 (decision D-344): RIFTFALL LANDING CLOSED ITS OWN FAR END,'
J11_LAST=$'\tlog_event("landing cap opened", "%d Riftfall Landing boundary mass overlaps Broken Watch; its %d built nodes are removed in THIS composition, before the bake" % [landing_caps.size(), cap_nodes_removed])'

# The slice with J9's lines put back to the ones they replaced: the two comment lines dropped, the bound
# connection back to the bare one, and the new signature back to the old one with the attacker read after it.
put_back_j9() {
	awk -v c1="$J9_COMMENT_1" -v c2="$J9_COMMENT_2" -v bound="$J9_CONNECTION" -v bare="$PRE_J9_CONNECTION" \
		-v sig="$J9_SIGNATURE" -v old_sig="$PRE_J9_SIGNATURE" -v attacker="$PRE_J9_ATTACKER_READ" '
		$0 == c1 || $0 == c2 { next }
		$0 == bound { print bare; next }
		$0 == sig { print old_sig; print attacker; next }
		{ print }' "$1"
}

# J10's three lines dropped from the slice (D-340), so that J9's put-back reads the D-339 slice.
put_back_j10() {
	awk -v c1="$J10_COMMENT_1" -v c2="$J10_COMMENT_2" -v clearing="$J10_CLEARING" '
		$0 == c1 || $0 == c2 || $0 == clearing { next }
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

# Engine ERROR lines are refused outright; every WARNING must be one of the two accepted bake lines, each
# exactly EXPECTED_BAKE_LINES times, and neither scene's startup probe may appear.
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

BANNER="GUARANTEED DROP DEFEATED ENEMY BINDING VERIFICATION"

# Counted BEFORE this run makes its own.
stale_before="$(leftover_count)"

work="$(mktemp -d -t "$TEMP_STEM")"
scratch+=("$work")

printf 'Riftwrought — First-MVP Gameplay J9: Gate 1D Guaranteed-Drop Defeated-Enemy Binding V1 smoke checks (D-338)\n'
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
	pass "no J9 temporary directory was left behind by an earlier run"
else
	fail "$stale_before J9 temporary director(y/ies) from an earlier run remain in $TEMP_ROOT — remove them"
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
step "1. The new verification, the slice and the moved verifications parse; this runner and the moved runners pass bash -n"

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
done

# --------------------------------------------------------------------------
step "2. The slice, the verification and the fourteen moved suite files are at their D-338 hashes; the slice rebuilds to D-337; no other production file moved"

for row in "${D338_ROWS[@]}"; do
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

# J9's lines, put back to the ones they replaced: what is left must be the D-337 slice, byte for byte.
present=0
for line in "$J9_COMMENT_1" "$J9_COMMENT_2" "$J9_CONNECTION" "$J9_SIGNATURE"; do
	present=$((present + $(grep -cxF -- "$line" "$PROJECT_DIR/$SLICE" | tr -d ' ')))
done
absent=0
for line in "$PRE_J9_CONNECTION" "$PRE_J9_SIGNATURE" "$PRE_J9_ATTACKER_READ"; do
	absent=$((absent + $(grep -cxF -- "$line" "$PROJECT_DIR/$SLICE" | tr -d ' ')))
done
rebuilt="$(put_back_j11 "$PROJECT_DIR/$SLICE" | put_back_j10 - | put_back_j9 - | shasum -a 256 | cut -d' ' -f1)"
if [[ "$present" == "4" && "$absent" == "0" && "$rebuilt" == "$PRE_J9_SLICE_SHA256" ]]; then
	pass "the slice holds J9's 4 lines once each and none of the 3 it replaced; put back, it is, byte for byte, the D-337 file ${PRE_J9_SLICE_SHA256:0:8} — with J10's 3 lines (D-340) put back first"
else
	fail "the slice holds $present of J9's 4 lines and $absent replaced line(s), and put back hashes ${rebuilt:0:8}, not ${PRE_J9_SLICE_SHA256:0:8}"
fi
rebuilt_moved="$({ put_back_j11 "$PROJECT_DIR/$SLICE" | put_back_j10 - | put_back_j9 -; printf 'x'; } | shasum -a 256 | cut -d' ' -f1)"
if [[ "$rebuilt_moved" != "$PRE_J9_SLICE_SHA256" ]]; then
	pass "and that reconstruction pin refuses a rebuild with one byte appended (${rebuilt_moved:0:8})"
else
	fail "the reconstruction pin accepts a moved rebuild and therefore proves nothing"
fi

listing="$work/production.txt"
production_listing > "$listing"
production_files="$(wc -l < "$listing" | tr -d ' ')"
production_digest="$(shasum -a 256 < "$listing" | cut -d' ' -f1)"
if [[ "$production_files" == "$EXPECTED_PRODUCTION_FILES" && "$production_digest" == "$EXPECTED_PRODUCTION_DIGEST" ]]; then
	pass "every other production file is as D-337 left it, but for Broken Watch's layout, which J10 moved (D-340): $production_files files, digest ${production_digest:0:8}"
else
	fail "the production tree outside the slice moved: $production_files files, digest ${production_digest:0:8}, not $EXPECTED_PRODUCTION_FILES / ${EXPECTED_PRODUCTION_DIGEST:0:8}"
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

# A guard that accepts everything protects nothing: each pin must refuse a replay of this run's own log with
# its value moved, and must READ the moved value.
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

# The measurements this work exists to make, read out of the run's own log. Instance ids and the time left in
# the Fallen delay vary from run to run, so the lines that carry them are cut before them.
while IFS= read -r line; do
	if grep -qF -- "$line" "$verify_log"; then
		pass "measured: ${line}"
	else
		fail "the verification log does not report: ${line}"
	fi
done <<'MEASURED'
the slice is at its J9 hash 942aee83, 811 lines; with J9's 2 comment lines and bound connection put back to the one connection they replaced, and the callback's signature put back with the attacker read it lost, it is, byte for byte, the D-337 file f83e9436, 810 lines
event.source is read 0 times in the slice's code; the D-337 slice read it 1 time, as the rewarded enemy
45 files J9 stands beside hold the hashes they held before the first J9 edit
put back, the 14 are byte for byte 8c0e290c, d5407c7c, 1062c1db, 689284cc, 3deeb26a, cb520369, c9648eea, d2772373, 333c1674, a5744db6, fde101de, 5aa1ec83, 117ab87b, cc7e665a (65 replaced blocks)
_spawn_graveblades(): 3 code lines; the D-337 third — graveblades[0].died.connect(_on_first_graveblade_died) — now reads graveblades[0].died.connect(_on_first_graveblade_died.bind(graveblades[0]))
_on_first_graveblade_died(): 9 code lines where D-337 had 10; the line(s) it lost: var enemy: Node = event.source; the signature now reads func _on_first_graveblade_died(event: DamageEvent, enemy: PrototypeGraveblade) -> void:
35 fields, 8 exports, 53 functions in D-337's order, 12 constants, no signal and no enum; every body but those two is byte for byte the D-337 one; one .bind(, one died.connect(, _rewarded_enemies named 3 times as before
only broken_watch_slice.gd names _on_first_graveblade_died() — its declaration and its one connection; of the slice and its descendants only it names _spawn_graveblades() — its declaration and the call in its _ready(); elsewhere foundation_skill_practice.gd x2 (extends Node3D), each declaring its own unrelated function of that name
7 descend from BrokenWatchSlice: canonical_opening_runtime.gd, roguelite_build_variety_runtime.gd, roguelite_experience_collection_review.gd, roguelite_level_up_choice_review.gd, roguelite_live_effect_review.gd, roguelite_replayability_runtime.gd, roguelite_core_loop_runtime.gd; none redeclares _on_first_graveblade_died(), _spawn_graveblades() or _place_drop()
31 actions; the entrypoint is prototype_app.tscn; project.godot declares no [autoload] and names nothing of J9
3 real Quick Strikes at 100 damage took the first Graveblade 300 -> 200 -> 100 -> 0; it emitted died once, with an event whose source is the player — the attacker — and whose target is the first Graveblade
the first Graveblade's died -> _on_first_graveblade_died() on the slice, 1 bound [
— the first Graveblade itself, by instance id; the second Graveblade's: none
the rewarded set holds [the first Graveblade's id] as the slice's callback left it, and held [the first Graveblade's id] when the died emission reached the harness; the drop latch is set
1 drop created and 1 placement line; GuaranteedDrop carries the Watchsteel Sword, interaction range 2.20 m; it lies 0.0000 m from the point PrototypeGroundPointer.resolve_to_navigation() gives for the fallen Graveblade's position, on the ground, 0.000 m from where it fell
the harness emitted it; the slice's callback wrote 'duplicate kill signal from an already-rewarded enemy' 1 more time(s) and 'the guaranteed drop was already granted' 0; the rewarded set went from [the first Graveblade's id] to [the first Graveblade's id]
0 drop(s) created and 0 placement line(s) written; the same drop still lies there: true; the latch is set
the second Graveblade's died has no connection to _on_first_graveblade_died(); 3 real Quick Strikes took it 300 -> 200 -> 100 -> 0 and its death — the player as source — changed nothing: the same set, no refusal, no placement, no drop
F5 restarted the slice once ('quick restart'): both Graveblades and the player back at full Life, no Fallen armed; the same drop, the latch and the rewarded set kept
3 real Quick Strikes took the revived first Graveblade 300 -> 200 -> 100 -> 0; its death was refused as a duplicate of the same Graveblade — no second drop, no placement, the same set
before the Fallen, controller live and 1.0 m from the drop: the drop highlighted, its nameplate shown, (A) opened the comparison (the world paused) and Escape closed it
4 real Graveblade Hits took Life 375 -> 250 -> 125 -> 0; inside the delay,
the overlay not open, the highlight and nameplate were cleared, the prompt empty, and (A) opened nothing
the overlay then opened once by itself — "Graveblade — Melee Hit — 125 Physical Damage", paused, its restart focused; Enter restarted the slice once, both Graveblades and the player alive, the same drop, latch and set
after the Restart, controller live and 1.0 m from the drop: highlighted again, the nameplate shown, (A) opened the comparison and Escape closed it
5 enemies across its rooms: each died connected once to _on_encounter_enemy_died() on the runtime, with 2 bound arguments — its room index and the enemy itself — and none to _on_first_graveblade_died()
broken_watch is null, the inherited drop latch unset, the rewarded set empty and no ground item placed: Gate 1D's guaranteed drop is not reachable from this scene
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
	pass "every other production file is still as D-337 left it after the runs, but for Broken Watch's layout, which J10 moved (D-340)"
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
step "6. This run's temporary directory is removed and nothing of J9 is left behind"

rm -rf "$work"
if [[ ! -e "$work" && "$(leftover_count)" == "0" ]]; then
	pass "the temporary directory is gone and no $TEMP_STEM.* directory remains in $TEMP_ROOT"
else
	fail "a J9 temporary directory remains in $TEMP_ROOT"
fi

# --------------------------------------------------------------------------
printf '\n'
if [[ "$failures" == "0" ]]; then
	printf 'GUARANTEED DROP DEFEATED ENEMY BINDING SMOKE CHECKS: PASS\n'
	printf '  %s checks; %s of %s owed; headless; %s protected files and .godot/ byte-identical\n' \
		"$EXPECTED_CHECKS" "$EXPECTED_OWED_CHECKS" "$EXPECTED_OWED_CHECKS" "${#PRESERVED_FILES[@]}"
	printf 'First-MVP Gameplay J9 — Gate 1D Guaranteed-Drop Defeated-Enemy Binding V1 — ACCEPTED\n'
	printf 'VERDICT: PASS — J9 is accepted.\n'
	printf 'D-223 remains OPEN.\n'
	reached_end=1
	exit 0
else
	printf 'GUARANTEED DROP DEFEATED ENEMY BINDING SMOKE CHECKS: %d FAILURE(S)\n' "$failures"
	reached_end=1
	exit 1
fi
