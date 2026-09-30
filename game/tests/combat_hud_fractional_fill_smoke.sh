#!/usr/bin/env bash
# Riftwrought — First-MVP UI J6: Player Resource-Bar Fractional Fill Truthfulness V1 smoke checks (decision D-332).
#
# THIS IS NOT A GATE, AND IT RUNS NO LOCKED CHAIN.
#
# J6 changes one production file by one layout line and its comment: `FirstMvpCombatHud._bar_row()` now
# gives each resource fill `SIZE_SHRINK_BEGIN`, so the `PanelContainer` it sits in lays it out at the
# fractional width `_on_life_changed()` and `_on_mana_changed()` already write instead of stretching it
# across the whole bar. What this script proves:
#
#   1. the new verification, the HUD and the four accepted verifications J6 moved parse, and the five
#      accepted runners J6 moved pass `bash -n`;
#   2. the HUD and the nine accepted suite files J6 moved are at their D-332 hashes, each pin refusing a
#      file with one byte appended; the HUD with J6's five lines removed is, byte for byte, the D-331 file;
#      and no other production file has changed since D-331 — one digest over every file under scripts/,
#      scenes/, data/, addons/ and assets/ and project.godot, the HUD excepted;
#   3. the pinned verification passes headless, proved in BOTH directions against a replay of its own
#      log — its check count, its owed count and the exact owed SET — with the measured lines read out of
#      the log, zero SCRIPT ERROR and zero engine ERROR, and no engine WARNING but the accepted ones counted
#      exactly;
#   4. ONLY WITH `--shots <dir>`: the same verification rendered at 1920x1080 and at the 1280x720 minimum
#      window, at the SAME pinned count and owed set, each saving its three evidence frames into <dir> and
#      <dir>/1280x720. A plain invocation opens no window;
#   5. `project.godot` is untouched: 31 actions, the Prototype App entrypoint, the same nine sections, no
#      `[autoload]`;
#   6. every file this work stands beside and the whole `.godot/` directory are BYTE-IDENTICAL across the
#      run, the project owner's own user:// files are untouched, and Godot's own user://logs/ did not move;
#   7. this run's temporary directory is gone and no other J6 temporary directory is left behind.
#
# Everything this script writes goes into one `mktemp -d` directory, removed on every exit — Godot's own
# file log for every invocation included — except the evidence frames when `--shots` names a directory.
#
# Usage, from the repository root:
#   game/tests/combat_hud_fractional_fill_smoke.sh
#   game/tests/combat_hud_fractional_fill_smoke.sh --shots docs/testing/combat_hud_fractional_fill_evidence

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
		printf '\nCOMBAT HUD FRACTIONAL FILL SMOKE CHECKS: ABORTED before the end of the script\n'
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
TEMP_STEM="riftwrought_j6"

# Pinned, and proved in both directions below. ONE number: the evidence frames add no assertion, so the
# headless and both rendered runs must agree.
EXPECTED_CHECKS=22
EXPECTED_OWED_CHECKS=20
OWED_SET="the_production_diff_is_exactly_the_authorized_hud_layout_correction, the_accepted_suites_moved_only_their_hud_pins, only_bar_row_gained_one_layout_line_and_the_width_writers_are_the_accepted_ones, the_hud_reaches_gate_1d_and_its_runtimes_by_instancing_only, no_player_combat_scene_input_map_or_project_behaviour_changed, the_hud_begins_full_at_500_of_500_and_100_of_100, a_real_quick_strike_spends_its_configured_mana_and_the_fill_follows, natural_mana_regeneration_moves_the_fill_truthfully_back_to_full, four_real_graveblade_hits_step_the_life_fill_to_75_50_25_and_zero, the_written_width_now_survives_the_container_sort, the_lethal_hit_still_arms_fallen_and_its_delay, through_the_fallen_delay_the_label_reads_zero_and_no_red_fill_spans_the_bar, the_zero_width_fill_survives_forced_layout_passes_and_drawn_frames, behind_the_fallen_overlay_the_life_fill_stays_empty, a_normal_restart_restores_500_of_500_and_a_full_fill, both_fills_stay_clamped_between_empty_and_full, labels_colours_dimensions_placement_and_borders_are_unchanged, the_j5_highlight_clearing_and_j4_refusals_still_hold, the_living_prompts_messages_comparison_and_equip_still_work, the_hover_life_bar_is_measured_and_left_unchanged"
VERIFICATION_TIMEOUT=600

EXPECTED_INPUT_ACTIONS=31
EXPECTED_MAIN_SCENE="res://scenes/app/prototype_app.tscn"
EXPECTED_SECTIONS="application audio debug display editor_plugins input layer_names navigation rendering"

# Every production file but the HUD, as it stood at the end of D-331: 870 files under scripts/, scenes/,
# data/, addons/ and assets/ and project.godot, each line `sha256  path`, sorted, digested.
# First-MVP Gameplay J9 (D-338) moved it one for one, from c85dd245, when Gate 1D's slice moved.
# First-MVP Gameplay J10 (D-340) moved it again, from 368cb1b4, when Gate 1D's slice and Broken Watch's layout moved.
EXPECTED_PRODUCTION_FILES=870
EXPECTED_PRODUCTION_DIGEST="a0ebf533f12f953fab4fa29a594708a1577ec55cff50ab56a6f31bdfbb011d48"

# The HUD as D-331 left it, whole.
PRE_J6_HUD_SHA256="0bb284a18b1e979529771f098ff0845d9634dabe6c593467f38453108595737f"

# Engine warnings the verification may print, each with the exact number of times it must appear: the
# accepted navigation bake's two precision lines once each for the one scene it loads, and Gate 1D's own
# startup probe at most once — the unchanged `BrokenWatchSlice._await_navigation_synchronized()` inside
# the slice's own `_ready()`, before any J6 check runs.
BAKE_CLIMB="WARNING: Property agent_max_climb is floored to cell_height voxel units and loses precision."
BAKE_RADIUS="WARNING: Property agent_radius is ceiled to cell_size voxel units and loses precision."
SLICE_PROBE="WARNING: BrokenWatchSlice: the navigation map did not become queryable"
EXPECTED_BAKE_LINES=1
MOST_SLICE_PROBES=1

THIS_VERIFICATION="tests/combat_hud_fractional_fill_verification.gd"
THIS_SMOKE="tests/combat_hud_fractional_fill_smoke.sh"
HUD="scripts/ui/first_mvp_combat_hud.gd"
J2_VERIFICATION="tests/fallen_modal_life_state_verification.gd"
J3_VERIFICATION="tests/pending_fallen_restart_verification.gd"
J3_SMOKE="tests/pending_fallen_restart_smoke.sh"
J4_VERIFICATION="tests/fallen_delay_item_interaction_verification.gd"
J4_SMOKE="tests/fallen_delay_item_interaction_smoke.sh"
J5_VERIFICATION="tests/fallen_delay_drop_highlight_verification.gd"
J5_SMOKE="tests/fallen_delay_drop_highlight_smoke.sh"
I13_SMOKE="tests/global_damage_live_application_smoke.sh"
I14_SMOKE="tests/maximum_life_live_application_smoke.sh"

# First-MVP UI J7 (D-334) moved all ten again, one for one, from aff939f3, f065a48d, 68a1227e, f7b48202, 308fe51a, b7ff3d66, 733d4af8, f5451331, 4f8cad92 and e5d90d8e, when the combat HUD moved.
# First-MVP UI J8 (D-336) moved all ten again, one for one, from 38c485cb, eb7f4153, 520d9543, 67cf7ba9, 611891a3, d7cf4498, 44ed4bdf, aeba508d, 803b8a7f and 657c0b17, when the combat HUD moved.
# First-MVP Gameplay J9 (D-338) moved seven of them again, one for one, from d5407c7c, 1062c1db, 689284cc, 3deeb26a, cb520369, c9648eea and d2772373, when Gate 1D's slice moved.
# First-MVP Gameplay J10 (D-340) moved the same seven again, one for one, from 6acc1e0c, dc9be60f, ec5bc37f, eff592af, e14e996b, b735e6c7 and fea9988e, when Gate 1D's slice moved.
# Verification Maintenance V1 (D-342) moved three of them again, one for one, from 5c8e9b07, dceea6f9 and b1b456bd, when their put-back pairs moved into the flat provenance store.
# First-MVP Gameplay J11 (D-344) moved this runner's rows again, one for one, when Gate 1D's slice came to open Riftfall Landing's Watch Breach far cap in its own composition.
D332_ROWS=(
	"$HUD|ee485029"
	"$J2_VERIFICATION|72e39a8a"
	"$J3_VERIFICATION|7d0e3f08"
	"$J3_SMOKE|54a4464a"
	"$J4_VERIFICATION|8aad4262"
	"$J4_SMOKE|939d9b48"
	"$J5_VERIFICATION|beb94aa0"
	"$J5_SMOKE|6f792a38"
	"$I13_SMOKE|ccef4a26"
	"$I14_SMOKE|e3887f96"
)

# Fingerprinted before and after the run: the changed file, this verification, every accepted suite file
# J6 moved and the suites beside them, everything the verification pins as unchanged, the project owner's
# composed zone, and the two handoff documents.
PRESERVED_FILES=(
	"$HUD"
	"$THIS_VERIFICATION"
	"$J2_VERIFICATION"
	"$J3_VERIFICATION"
	"$J3_SMOKE"
	"$J4_VERIFICATION"
	"$J4_SMOKE"
	"$J5_VERIFICATION"
	"$J5_SMOKE"
	"$I13_SMOKE"
	"$I14_SMOKE"
	"tests/first_mvp_modal_left_click_verification.gd"
	"tests/first_mvp_modal_left_click_smoke.sh"
	"tests/fallen_modal_life_state_smoke.sh"
	"tests/gate_1d_broken_watch_verification.gd"
	"tests/gate_1d_broken_watch_smoke.sh"
	"tests/gate_1e_canonical_opening_verification.gd"
	"tests/roguelite_core_loop_verification.gd"
	"tests/global_damage_live_application_verification.gd"
	"tests/maximum_life_live_application_verification.gd"
	"project.godot"
	"scenes/first_mvp/zone_composer_practice.tscn"
	"../CLAUDE.md"
	"../README.md"
	"scripts/actors/prototype_player.gd"
	"scripts/first_mvp/severed_threshold/broken_watch_slice.gd"
	"scripts/ui/first_mvp_modal.gd"
	"scripts/ui/first_mvp_fallen_overlay.gd"
	"scripts/roguelite/roguelite_fallen_overlay.gd"
	"scripts/ui/first_mvp_item_comparison.gd"
	"scripts/ui/canonical_opening_hud.gd"
	"scripts/roguelite/roguelite_run_hud.gd"
	"scripts/items/first_mvp_item_drop.gd"
	"scripts/items/player_loadout.gd"
	"scripts/first_mvp/canonical_opening/canonical_opening_runtime.gd"
	"scripts/roguelite/roguelite_core_loop_runtime.gd"
	"scripts/roguelite/replayability/roguelite_replayability_runtime.gd"
	"scripts/roguelite/build_variety/roguelite_build_variety_runtime.gd"
	"scripts/actors/prototype_graveblade.gd"
	"scripts/combat/quick_strike_action.gd"
	"scripts/combat/quick_strike_data.gd"
	"scripts/combat/attack_coordinator.gd"
	"scripts/combat/damage_event.gd"
	"scripts/combat/target_acquisition.gd"
	"scripts/input/input_family_tracker.gd"
	"scenes/first_mvp/severed_threshold/broken_watch_slice.tscn"
	"scenes/first_mvp/canonical_opening/canonical_opening.tscn"
	"scenes/roguelite/roguelite_core_loop.tscn"
	"scenes/roguelite/roguelite_replayability_review.tscn"
	"scenes/roguelite/roguelite_build_variety_review.tscn"
	"scenes/actors/prototype_player.tscn"
	"scenes/actors/prototype_graveblade.tscn"
	"data/prototype_zero/graveblade.tres"
	"data/prototype_zero/quick_strike.tres"
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

# Every file in a directory by name, size and modification time, or "absent".
directory_listing() {
	if [[ -d "$1" ]]; then
		(cd "$1" && find . -type f -print0 | sort -z | xargs -0 stat -f '%N %z %m')
	else
		printf 'absent'
	fi
}

godot_fingerprint() {
	(cd "$PROJECT_DIR" && find .godot -type f -print0 | sort -z | xargs -0 shasum -a 256 | shasum -a 256 | cut -d' ' -f1)
}
godot_file_count() {
	find "$PROJECT_DIR/.godot" -type f | wc -l | tr -d ' '
}

# Every production file but the HUD, by path and content.
production_listing() {
	(cd "$PROJECT_DIR" && find scripts scenes data addons assets project.godot -type f ! -path "$HUD" -print0 \
		| sort -z | xargs -0 shasum -a 256)
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

# Engine ERROR lines are refused outright; every WARNING must be one of the three accepted lines, the two
# bake lines exactly EXPECTED_BAKE_LINES times each and the slice's probe at most MOST_SLICE_PROBES times.
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

BANNER="COMBAT HUD FRACTIONAL FILL VERIFICATION"

# Counted BEFORE this run makes its own.
stale_before="$(leftover_count)"

work="$(mktemp -d -t "$TEMP_STEM")"
scratch+=("$work")

SHOTS=0
SHOT_DIR=""
if [[ "${1:-}" == "--shots" && -n "${2:-}" ]]; then
	mkdir -p "$2" && SHOT_DIR="$(cd "$2" && pwd)"
	mkdir -p "$SHOT_DIR/1280x720"
	SHOTS=1
fi

printf 'Riftwrought — First-MVP UI J6: Player Resource-Bar Fractional Fill Truthfulness V1 smoke checks (D-332)\n'
printf 'project: %s\n' "$PROJECT_DIR"
if [[ "$SHOTS" == "1" ]]; then
	printf 'evidence frames: %s — rendered runs at 1920x1080 and 1280x720 will open a window\n' "$SHOT_DIR"
else
	printf 'headless only — no window opens; pass --shots <dir> for the rendered evidence runs\n'
fi

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
	pass "no J6 temporary directory was left behind by an earlier run"
else
	fail "$stale_before J6 temporary director(y/ies) from an earlier run remain in $TEMP_ROOT — remove them"
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
step "1. The new verification, the HUD and the moved verifications parse; the moved runners pass bash -n"

for relative in "$THIS_VERIFICATION" "$HUD" "$J2_VERIFICATION" "$J3_VERIFICATION" "$J4_VERIFICATION" "$J5_VERIFICATION"; do
	out="$("$GODOT" --headless --path "$PROJECT_DIR" --log-file "$work/parse.log" --check-only --script "res://$relative" 2>&1 \
		| grep -v '^Godot Engine')"
	if [[ -z "$out" ]]; then
		pass "$relative parses"
	else
		fail "$relative does not parse"
		printf '%s\n' "$out" | head -10 | sed 's/^/        /'
	fi
done
for relative in "$THIS_SMOKE" "$J3_SMOKE" "$J4_SMOKE" "$J5_SMOKE" "$I13_SMOKE" "$I14_SMOKE"; do
	if bash -n "$PROJECT_DIR/$relative" 2>"$work/bash_n.txt"; then
		pass "$relative passes bash -n"
	else
		fail "$relative fails bash -n"
		head -5 "$work/bash_n.txt" | sed 's/^/        /'
	fi
done

# --------------------------------------------------------------------------
step "2. The HUD and the nine moved suite files are at their D-332 hashes; the HUD rebuilds to D-331; no other production file moved"

for row in "${D332_ROWS[@]}"; do
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

# First-MVP UI J8 (D-336) replaced one line of its own with eight; they are put back first, leaving the HUD J7 left.
cat > "$work/j8_lines.txt" <<'LINES'
	# First-MVP UI J8 (decision D-336): the column is anchored by its bottom edge,
	# 24 px above the viewport's, and grows upward to its own height. A top edge
	# 80 px above the bottom left the 94 px column's last 14 px below the window.
	resources.offset_left = 24.0
	resources.offset_top = -24.0
	resources.offset_right = 24.0
	resources.offset_bottom = -24.0
	resources.grow_vertical = Control.GROW_DIRECTION_BEGIN
LINES
awk -v old=$'\tresources.position = Vector2(24, -80)' 'NR == FNR { j8[$0] = 1; next } ($0 in j8) { if (!done) print old; done = 1; next } { print }' \
	"$work/j8_lines.txt" "$PROJECT_DIR/$HUD" > "$work/hud_j7.txt"
# First-MVP UI J7 (D-334) inserted eight lines of its own; they are removed first, leaving the HUD J6 left.
cat > "$work/j7_lines.txt" <<'LINES'
	# First-MVP UI J7 (decision D-334): the hover fill keeps the width its own
	# minimum size gives it, as the resource fills have since J6. The PanelContainer
	# stretched a filling child across the whole bar whenever it sorted, so the
	# panel appeared with a full-width fill.
	_hover_fill.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	# First-MVP UI J7 (decision D-334): the minimum size follows the fraction. A
	# fixed 190 x 10 minimum held the fill at 190 px against the write below.
	_hover_fill.custom_minimum_size = Vector2(190.0 * fraction, 10.0)
LINES
grep -vxF -f "$work/j7_lines.txt" "$work/hud_j7.txt" > "$work/hud_j6.txt"
# J6's five inserted lines, removed from the file on disk: what is left must be the D-331 HUD, byte for byte.
cat > "$work/j6_lines.txt" <<'LINES'
	# First-MVP UI J6 (decision D-332): the fill keeps the width its own minimum
	# size gives it. A PanelContainer lays a filling child across its whole
	# content rect on every sort, which overrode the fractional width
	# `_on_life_changed()` and `_on_mana_changed()` write and drew every bar full.
	fill.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
LINES
inserted="$(grep -cxF -f "$work/j6_lines.txt" "$work/hud_j6.txt" | tr -d ' ')"
rebuilt="$(grep -vxF -f "$work/j6_lines.txt" "$work/hud_j6.txt" | shasum -a 256 | cut -d' ' -f1)"
if [[ "$inserted" == "5" && "$rebuilt" == "$PRE_J6_HUD_SHA256" ]]; then
	pass "with J8's replaced line put back (D-336) and J7's 8 lines removed (D-334), the HUD holds J6's 5 lines once each; with them removed it is, byte for byte, the D-331 file ${PRE_J6_HUD_SHA256:0:8}"
else
	fail "the HUD holds $inserted of J6's 5 lines, and without them hashes ${rebuilt:0:8}, not ${PRE_J6_HUD_SHA256:0:8}"
fi
rebuilt_moved="$({ grep -vxF -f "$work/j6_lines.txt" "$work/hud_j6.txt"; printf 'x'; } | shasum -a 256 | cut -d' ' -f1)"
if [[ "$rebuilt_moved" != "$PRE_J6_HUD_SHA256" ]]; then
	pass "and that reconstruction pin refuses a rebuild with one byte appended (${rebuilt_moved:0:8})"
else
	fail "the reconstruction pin accepts a moved rebuild and therefore proves nothing"
fi

listing="$work/production.txt"
production_listing > "$listing"
production_files="$(wc -l < "$listing" | tr -d ' ')"
production_digest="$(shasum -a 256 < "$listing" | cut -d' ' -f1)"
if [[ "$production_files" == "$EXPECTED_PRODUCTION_FILES" && "$production_digest" == "$EXPECTED_PRODUCTION_DIGEST" ]]; then
	pass "every other production file is as D-331 left it, but for Gate 1D's slice, which J9 and J10 moved (D-338, D-340), and Broken Watch's layout, which J10 moved (D-340): $production_files files, digest ${production_digest:0:8}"
else
	fail "the production tree outside the HUD moved: $production_files files, digest ${production_digest:0:8}, not $EXPECTED_PRODUCTION_FILES / ${EXPECTED_PRODUCTION_DIGEST:0:8}"
fi
moved_digest="$(sed '1s/$/x/' "$listing" | shasum -a 256 | cut -d' ' -f1)"
if [[ "$moved_digest" != "$EXPECTED_PRODUCTION_DIGEST" && "$moved_digest" != "$production_digest" ]]; then
	pass "and that pin refuses a listing with one line moved (${moved_digest:0:8})"
else
	fail "the production pin accepts a moved listing and therefore proves nothing"
fi

for runner in "$THIS_SMOKE" "$J3_SMOKE" "$J4_SMOKE" "$J5_SMOKE" "$I13_SMOKE" "$I14_SMOKE"; do
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
	grep -E "FAIL:" "$verify_log" | head -25 | cut -c1-400 | sed 's/^/        /'
fi

count="$(read_check_count "$BANNER" "$verify_log")"
if [[ "$count" == "$EXPECTED_CHECKS" ]]; then
	pass "verification passes at the pinned $EXPECTED_CHECKS checks"
else
	fail "verification reports ${count:-no} checks, not $EXPECTED_CHECKS"
fi

# A guard that accepts everything protects nothing: each pin must refuse a replay of this run's own log
# with its value moved, and must READ the moved value.
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

# The timing line varies from run to run and is read, not pinned.
timings="$(grep -cE "^  timing: " "$verify_log" | tr -d ' ')"
if [[ "$timings" == "1" ]]; then
	pass "the verification reported its 1 timing line"
	grep -E "^  timing: " "$verify_log" | sed 's/^  /        /'
else
	fail "the verification reported $timings timing line(s), not 1"
fi
mechanisms="$(grep -cE "^  mechanism: " "$verify_log" | tr -d ' ')"
if [[ "$mechanisms" == "8" ]]; then
	pass "the verification reported its 8 mechanism lines"
	grep -E "^  mechanism: " "$verify_log" | sed 's/^  /        /'
else
	fail "the verification reported $mechanisms mechanism line(s), not 8"
fi

# The measurements this work exists to make, read out of the run's own log.
while IFS= read -r line; do
	if grep -qF -- "$line" "$verify_log"; then
		pass "measured: ${line}"
	else
		fail "the verification log does not report: ${line}"
	fi
done <<'MEASURED'
geometry: "Life — 500 / 500" fill 260 x 22 at x 25 in a 262 x 24 bar (content 260 wide): 100.0%
geometry: "Mana — 100 / 100" fill 260 x 22 at x 25 in a 262 x 24 bar (content 260 wide): 100.0%
geometry: "Mana — 95 / 100" fill 247 x 22 at x 25 in a 262 x 24 bar (content 260 wide): 95.0%
geometry: "Mana — 90 / 100" fill 234 x 22 at x 25 in a 262 x 24 bar (content 260 wide): 90.0%
geometry: "Mana — 85 / 100" fill 221 x 22 at x 25 in a 262 x 24 bar (content 260 wide): 85.0%
geometry: "Life — 375 / 500" fill 195 x 22 at x 25 in a 262 x 24 bar (content 260 wide): 75.0%
geometry: "Life — 250 / 500" fill 130 x 22 at x 25 in a 262 x 24 bar (content 260 wide): 50.0%
geometry: "Life — 125 / 500" fill 65 x 22 at x 25 in a 262 x 24 bar (content 260 wide): 25.0%
geometry: "Life — 0 / 500" fill 0 x 22 at x 25 in a 262 x 24 bar (content 260 wide): 0.0% — the first update after the lethal Hit
both below full: "Life — 250 / 500" fill 130 x 22 at x 25 in a 260 x 24 bar (content 258 wide): 50.4%; "Mana — 95 / 100" fill 247 x 22 at x 25 in a 260 x 24 bar (content 258 wide): 95.7%
mechanism: Life 0 / 500: written 0 px by both; after the sort the pre-J6 fill 260 px, the live fill 0 px
the HUD is at its J6 hash
53 files J6 stands beside hold the hashes they held before the first J6 edit
_bar_row(): the accepted 18 code lines plus exactly one, before the fill joins its background: fill.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
5 scenes instance the HUD: canonical_opening.tscn, broken_watch_slice.tscn, roguelite_build_variety_review.tscn, roguelite_core_loop.tscn, roguelite_replayability_review.tscn
Quick Strike's configured cost is 5 Mana — the player's runtime record and quick_strike.tres agree; regeneration 10 per second, held at 0 for the readings
3 real Quick Strikes killed the first Graveblade, Life 300 -> 200 -> 100 -> 0, and left Mana at 95, 90, 85
the countdown fell on every one of the slice's
2 forced layout passes, one inside the delay and one behind the overlay:
10 paused physics frames, one forced layout pass and 5 idle frames with the overlay standing
staged, the HUD's own handlers given values play cannot produce: Life 600 / 500 -> 260 px, Life -50 / 500 -> 0 px, Mana 130 / 100 -> 260 px, Mana -20 / 100 -> 0 px
the one difference is the fill's horizontal size flag (live 0 / pre-J6 1): SIZE_SHRINK_BEGIN against SIZE_FILL
finding, repaired by J8 (D-336): the resources column is 94 px tall, its bottom edge 24 px above the window's and its top edge 118 px above it
from the slice's first update after the lethal Hit until Fallen opened: the drop unselected, its ring ordinary copper
(A) opened the comparison once ('controller interact'), paused, Close focused; joypad right and (A) equipped once, the message "Equipped Watchsteel Sword"
finding, not repaired: a truthful fill is 126.67 px
MEASURED

# --------------------------------------------------------------------------
if [[ "$SHOTS" == "1" ]]; then
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
		full="$(grep -E "^  screenshot: .*/01_full_life_500_of_500\.png \($resolution\) — IDLE, " "$window_log" \
			| grep -cF '"Life — 500 / 500" fill 260 x 22 at x 25 in a 262 x 24 bar (content 260 wide): 100.0%' | tr -d ' ')"
		half="$(grep -E "^  screenshot: .*/02_partial_life_250_of_500\.png \($resolution\) — IDLE, " "$window_log" \
			| grep -cF '"Life — 250 / 500" fill 130 x 22 at x 25 in a 262 x 24 bar (content 260 wide): 50.0%' | tr -d ' ')"
		zero="$(grep -E "^  screenshot: .*/03_fallen_life_0_of_500\.png \($resolution\) — FALLEN, " "$window_log" \
			| grep -F '"Life — 0 / 500" fill 0 x 22 at x 25 in a 262 x 24 bar (content 260 wide): 0.0%' | grep -cF 'overlay not open' | tr -d ' ')"
		if [[ "$shots" == "3" && "$full" == "1" && "$half" == "1" && "$zero" == "1" \
				&& -s "$target/01_full_life_500_of_500.png" && -s "$target/02_partial_life_250_of_500.png" && -s "$target/03_fallen_life_0_of_500.png" ]]; then
			pass "at $resolution three frames were saved: Life full at 500 / 500, half at 250 / 500, and zero-width while Fallen at 0 / 500"
			grep -E "^  screenshot: " "$window_log" | sed 's/^  /        /'
		else
			fail "at $resolution the evidence frames were not saved as expected ($shots screenshot line(s))"
			grep -E "^  screenshot: " "$window_log" | sed 's/^/        /'
		fi
	done
else
	step "4. Rendered evidence runs: not requested (pass --shots <dir>); no window was opened"
	pass "headless only, as a plain invocation must be"
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
	pass "every other production file is still as D-331 left it after the runs, but for Gate 1D's slice, which J9 and J10 moved (D-338, D-340), and Broken Watch's layout, which J10 moved (D-340)"
else
	fail "a production file outside the HUD changed during this run"
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
logs_after="$(directory_listing "$production_dir/logs")"
if [[ "$logs_after" == "$logs_before" ]]; then
	pass "Godot's own user://logs/ is unchanged — every invocation logged into this run's temporary directory"
else
	fail "Godot's own user://logs/ changed during this run"
fi

# --------------------------------------------------------------------------
step "7. This run's temporary directory is removed and nothing of J6 is left behind"

rm -rf "$work"
if [[ ! -e "$work" && "$(leftover_count)" == "0" ]]; then
	pass "the temporary directory is gone and no $TEMP_STEM.* directory remains in $TEMP_ROOT"
else
	fail "a J6 temporary directory remains in $TEMP_ROOT"
fi

# --------------------------------------------------------------------------
printf '\n'
modes="headless"
[[ "$SHOTS" == "1" ]] && modes="headless, 1920x1080 and 1280x720"
if [[ "$failures" == "0" ]]; then
	printf 'COMBAT HUD FRACTIONAL FILL SMOKE CHECKS: PASS\n'
	printf '  %s checks; %s of %s owed; %s; %s protected files and .godot/ byte-identical\n' \
		"$EXPECTED_CHECKS" "$EXPECTED_OWED_CHECKS" "$EXPECTED_OWED_CHECKS" "$modes" "${#PRESERVED_FILES[@]}"
	printf '  J6 — Player Resource-Bar Fractional Fill Truthfulness V1 — ACCEPTED\n'
	printf '  VERDICT: PASS — J6 is accepted. The player Life and Mana fills remain proportional through real damage, real Mana spending, regeneration, Fallen and restart, while the existing HUD geometry and presentation remain preserved.\n'
	printf '  D-223 remains OPEN.\n'
	reached_end=1
	exit 0
else
	printf 'COMBAT HUD FRACTIONAL FILL SMOKE CHECKS: %d FAILURE(S)\n' "$failures"
	reached_end=1
	exit 1
fi
