#!/usr/bin/env bash
# Riftwrought — First-MVP UI J7: Enemy Hover-Life Fractional Fill Truthfulness V1 smoke checks (decision D-334).
#
# THIS IS NOT A GATE, AND IT RUNS NO LOCKED CHAIN.
#
# J7 changes one production file by two layout lines and their comments: `FirstMvpCombatHud._build()` now
# gives the enemy hover fill `SIZE_SHRINK_BEGIN`, so the `PanelContainer` it sits in no longer stretches
# it across the whole track when the panel appears, and `show_hover()` now writes the fill's minimum size
# at the fractional width, so the fixed 190 x 10 minimum no longer holds it at 190 px. What this script
# proves:
#
#   1. the new verification, the HUD and the five accepted verifications J7 moved parse, and this runner
#      and the six accepted runners J7 moved pass `bash -n`;
#   2. the HUD and the eleven accepted suite files J7 moved are at their D-334 hashes, each pin refusing a
#      file with one byte appended; the HUD with J7's eight lines removed is, byte for byte, the D-333
#      file; and no other production file has changed — one digest over every file under scripts/,
#      scenes/, data/, addons/ and assets/ and project.godot, the HUD excepted;
#   3. the pinned verification passes headless, by the pointer's own route, proved in BOTH directions
#      against a replay of its own log — its check count, its owed count and the exact owed SET — with
#      the measured lines read out of the log, zero SCRIPT ERROR and zero engine ERROR, and no engine
#      WARNING but the accepted ones counted exactly;
#   4. ONLY WITH `--shots <dir>`: the same verification rendered at 1920x1080 and at the 1280x720 minimum
#      window, at the SAME pinned count and owed set, each saving its three evidence frames into <dir> and
#      <dir>/1280x720. A plain invocation opens no window;
#   5. `project.godot` is untouched: 31 actions, the Prototype App entrypoint, the same nine sections, no
#      `[autoload]`;
#   6. every file this work stands beside and the whole `.godot/` directory are BYTE-IDENTICAL across the
#      run, the project owner's own user:// files are untouched, and Godot's own user://logs/ did not move;
#   7. this run's temporary directory is gone and no other J7 temporary directory is left behind.
#
# Everything this script writes goes into one `mktemp -d` directory, removed on every exit — Godot's own
# file log for every invocation included — except the evidence frames when `--shots` names a directory.
#
# Usage, from the repository root:
#   game/tests/enemy_hover_life_fractional_fill_smoke.sh
#   game/tests/enemy_hover_life_fractional_fill_smoke.sh --shots docs/testing/enemy_hover_life_fractional_fill_evidence

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
		printf '\nENEMY HOVER LIFE FRACTIONAL FILL SMOKE CHECKS: ABORTED before the end of the script\n'
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
TEMP_STEM="riftwrought_j7"

# Pinned, and proved in both directions below. ONE number: the evidence frames add no assertion, so the
# headless and both rendered runs must agree.
EXPECTED_CHECKS=19
EXPECTED_OWED_CHECKS=17
OWED_SET="the_production_diff_is_exactly_the_authorized_hover_fill_correction, the_accepted_suites_moved_only_their_hud_pins, only_build_and_show_hover_gained_one_line_each, the_hud_reaches_gate_1d_and_its_runtimes_by_instancing_only, no_player_combat_scene_input_map_or_project_behaviour_changed, the_pointer_route_shows_full_life_as_the_whole_190_px_fill, real_quick_strikes_take_the_graveblade_to_two_thirds_one_third_and_death, at_two_thirds_the_first_laid_out_update_is_already_truthful, later_updates_and_forced_layout_passes_keep_the_truthful_width, hiding_and_reopening_while_partial_never_restores_a_full_fill, at_one_third_the_fill_is_truthful_from_the_first_update_on, both_measured_causes_are_gone, the_fill_stays_clamped_inside_its_track, a_dead_or_null_enemy_still_hides_the_panel, hover_never_changes_targeting_or_acquisition, the_player_life_and_mana_bars_stay_as_j6_left_them, labels_colours_geometry_borders_and_placement_are_unchanged_but_the_hover_fill_width"
VERIFICATION_TIMEOUT=600

EXPECTED_INPUT_ACTIONS=31
EXPECTED_MAIN_SCENE="res://scenes/app/prototype_app.tscn"
EXPECTED_SECTIONS="application audio debug display editor_plugins input layer_names navigation rendering"

# Every production file but the HUD, as it stood at the end of D-333: 870 files under scripts/, scenes/,
# data/, addons/ and assets/ and project.godot, each line `sha256  path`, sorted, digested.
# First-MVP Gameplay J9 (D-338) moved it one for one, from c85dd245, when Gate 1D's slice moved.
# First-MVP Gameplay J10 (D-340) moved it again, from 368cb1b4, when Gate 1D's slice and Broken Watch's layout moved.
EXPECTED_PRODUCTION_FILES=870
EXPECTED_PRODUCTION_DIGEST="a0ebf533f12f953fab4fa29a594708a1577ec55cff50ab56a6f31bdfbb011d48"

# The HUD as D-333 left it, whole.
PRE_J7_HUD_SHA256="aff939f37124666bcbf63e887ab8685f9e867d935741377a01ba397379a326f5"

# Engine warnings the verification may print, each with the exact number of times it must appear: the
# accepted navigation bake's two precision lines once each for the one scene it loads, and Gate 1D's own
# startup probe at most once — the unchanged `BrokenWatchSlice._await_navigation_synchronized()` inside
# the slice's own `_ready()`, before any J7 check runs.
BAKE_CLIMB="WARNING: Property agent_max_climb is floored to cell_height voxel units and loses precision."
BAKE_RADIUS="WARNING: Property agent_radius is ceiled to cell_size voxel units and loses precision."
SLICE_PROBE="WARNING: BrokenWatchSlice: the navigation map did not become queryable"
EXPECTED_BAKE_LINES=1
MOST_SLICE_PROBES=1

THIS_VERIFICATION="tests/enemy_hover_life_fractional_fill_verification.gd"
THIS_SMOKE="tests/enemy_hover_life_fractional_fill_smoke.sh"
HUD="scripts/ui/first_mvp_combat_hud.gd"
J2_VERIFICATION="tests/fallen_modal_life_state_verification.gd"
J3_VERIFICATION="tests/pending_fallen_restart_verification.gd"
J3_SMOKE="tests/pending_fallen_restart_smoke.sh"
J4_VERIFICATION="tests/fallen_delay_item_interaction_verification.gd"
J4_SMOKE="tests/fallen_delay_item_interaction_smoke.sh"
J5_VERIFICATION="tests/fallen_delay_drop_highlight_verification.gd"
J5_SMOKE="tests/fallen_delay_drop_highlight_smoke.sh"
J6_VERIFICATION="tests/combat_hud_fractional_fill_verification.gd"
J6_SMOKE="tests/combat_hud_fractional_fill_smoke.sh"
I13_SMOKE="tests/global_damage_live_application_smoke.sh"
I14_SMOKE="tests/maximum_life_live_application_smoke.sh"

# First-MVP UI J8 (D-336) moved all twelve again, one for one, from 38c485cb, eb7f4153, 520d9543, 67cf7ba9, 611891a3, d7cf4498, 44ed4bdf, aeba508d, 423858a2, 1c2f1d12, 803b8a7f and 657c0b17, when the combat HUD moved.
# First-MVP Gameplay J9 (D-338) moved nine of them again, one for one, from d5407c7c, 1062c1db, 689284cc, 3deeb26a, cb520369, c9648eea, d2772373, 333c1674 and a5744db6, when Gate 1D's slice moved.
# First-MVP Gameplay J10 (D-340) moved the same nine again, one for one, from 6acc1e0c, dc9be60f, ec5bc37f, eff592af, e14e996b, b735e6c7, fea9988e, d38624c8 and a444af4b, when Gate 1D's slice moved.
# Verification Maintenance V1 (D-342) moved five of them again, one for one, from 5c8e9b07, dceea6f9, b1b456bd, f7144aac and 6cf22e7d, when their put-back pairs moved into the flat provenance store.
# First-MVP Gameplay J11 (D-344) moved this runner's rows again, one for one, when Gate 1D's slice came to open Riftfall Landing's Watch Breach far cap in its own composition.
D334_ROWS=(
	"$HUD|ee485029"
	"$J2_VERIFICATION|72e39a8a"
	"$J3_VERIFICATION|7d0e3f08"
	"$J3_SMOKE|54a4464a"
	"$J4_VERIFICATION|8aad4262"
	"$J4_SMOKE|939d9b48"
	"$J5_VERIFICATION|beb94aa0"
	"$J5_SMOKE|6f792a38"
	"$J6_VERIFICATION|8c653002"
	"$J6_SMOKE|51d64a23"
	"$I13_SMOKE|ccef4a26"
	"$I14_SMOKE|e3887f96"
)

# Fingerprinted before and after the run: the changed file, this verification, every accepted suite file
# J7 moved and the suites beside them, everything the verification pins as unchanged, the project owner's
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
	"$J6_VERIFICATION"
	"$J6_SMOKE"
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
	"scripts/actors/graveblade_target_area.gd"
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

BANNER="ENEMY HOVER LIFE FRACTIONAL FILL VERIFICATION"

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

printf 'Riftwrought — First-MVP UI J7: Enemy Hover-Life Fractional Fill Truthfulness V1 smoke checks (D-334)\n'
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
	pass "no J7 temporary directory was left behind by an earlier run"
else
	fail "$stale_before J7 temporary director(y/ies) from an earlier run remain in $TEMP_ROOT — remove them"
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
step "1. The new verification, the HUD and the moved verifications parse; this runner and the moved runners pass bash -n"

for relative in "$THIS_VERIFICATION" "$HUD" "$J2_VERIFICATION" "$J3_VERIFICATION" "$J4_VERIFICATION" "$J5_VERIFICATION" "$J6_VERIFICATION"; do
	out="$("$GODOT" --headless --path "$PROJECT_DIR" --log-file "$work/parse.log" --check-only --script "res://$relative" 2>&1 \
		| grep -v '^Godot Engine')"
	if [[ -z "$out" ]]; then
		pass "$relative parses"
	else
		fail "$relative does not parse"
		printf '%s\n' "$out" | head -10 | sed 's/^/        /'
	fi
done
for relative in "$THIS_SMOKE" "$J3_SMOKE" "$J4_SMOKE" "$J5_SMOKE" "$J6_SMOKE" "$I13_SMOKE" "$I14_SMOKE"; do
	if bash -n "$PROJECT_DIR/$relative" 2>"$work/bash_n.txt"; then
		pass "$relative passes bash -n"
	else
		fail "$relative fails bash -n"
		head -5 "$work/bash_n.txt" | sed 's/^/        /'
	fi
done

# --------------------------------------------------------------------------
step "2. The HUD and the eleven moved suite files are at their D-334 hashes; the HUD rebuilds to D-333; no other production file moved"

for row in "${D334_ROWS[@]}"; do
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
# J7's eight inserted lines, removed from the file on disk: what is left must be the D-333 HUD, byte for byte.
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
inserted="$(grep -cxF -f "$work/j7_lines.txt" "$work/hud_j7.txt" | tr -d ' ')"
rebuilt="$(grep -vxF -f "$work/j7_lines.txt" "$work/hud_j7.txt" | shasum -a 256 | cut -d' ' -f1)"
if [[ "$inserted" == "8" && "$rebuilt" == "$PRE_J7_HUD_SHA256" ]]; then
	pass "with J8's replaced line put back (D-336), the HUD holds J7's 8 lines once each; with them removed it is, byte for byte, the D-333 file ${PRE_J7_HUD_SHA256:0:8}"
else
	fail "the HUD holds $inserted of J7's 8 lines, and without them hashes ${rebuilt:0:8}, not ${PRE_J7_HUD_SHA256:0:8}"
fi
rebuilt_moved="$({ grep -vxF -f "$work/j7_lines.txt" "$work/hud_j7.txt"; printf 'x'; } | shasum -a 256 | cut -d' ' -f1)"
if [[ "$rebuilt_moved" != "$PRE_J7_HUD_SHA256" ]]; then
	pass "and that reconstruction pin refuses a rebuild with one byte appended (${rebuilt_moved:0:8})"
else
	fail "the reconstruction pin accepts a moved rebuild and therefore proves nothing"
fi

listing="$work/production.txt"
production_listing > "$listing"
production_files="$(wc -l < "$listing" | tr -d ' ')"
production_digest="$(shasum -a 256 < "$listing" | cut -d' ' -f1)"
if [[ "$production_files" == "$EXPECTED_PRODUCTION_FILES" && "$production_digest" == "$EXPECTED_PRODUCTION_DIGEST" ]]; then
	pass "every other production file is as D-333 left it, but for Gate 1D's slice, which J9 and J10 moved (D-338, D-340), and Broken Watch's layout, which J10 moved (D-340): $production_files files, digest ${production_digest:0:8}"
else
	fail "the production tree outside the HUD moved: $production_files files, digest ${production_digest:0:8}, not $EXPECTED_PRODUCTION_FILES / ${EXPECTED_PRODUCTION_DIGEST:0:8}"
fi
moved_digest="$(sed '1s/$/x/' "$listing" | shasum -a 256 | cut -d' ' -f1)"
if [[ "$moved_digest" != "$EXPECTED_PRODUCTION_DIGEST" && "$moved_digest" != "$production_digest" ]]; then
	pass "and that pin refuses a listing with one line moved (${moved_digest:0:8})"
else
	fail "the production pin accepts a moved listing and therefore proves nothing"
fi

for runner in "$THIS_SMOKE" "$J3_SMOKE" "$J4_SMOKE" "$J5_SMOKE" "$J6_SMOKE" "$I13_SMOKE" "$I14_SMOKE"; do
	if [[ -x "$PROJECT_DIR/$runner" ]]; then
		pass "$runner is executable"
	else
		fail "$runner is not executable"
	fi
done

# --------------------------------------------------------------------------
step "3. The pinned verification passes headless, by the pointer's own route, proved in BOTH directions"

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

# The headless run is the primary proof, and it must have opened the hover by the pointer's own route.
if grep -qE "^  hover route: the pointer's own route" "$verify_log"; then
	pass "the headless run opened every hover by the pointer's own route"
	grep -E "^  hover route: " "$verify_log" | cut -c1-300 | sed 's/^  /        /'
else
	fail "the headless run did not report the pointer's own route"
	grep -E "^  hover route: " "$verify_log" | sed 's/^/        /'
fi
mechanisms="$(grep -cE "^  mechanism: " "$verify_log" | tr -d ' ')"
if [[ "$mechanisms" == "6" ]]; then
	pass "the verification reported its 6 mechanism lines"
	grep -E "^  mechanism: " "$verify_log" | sed 's/^  /        /'
else
	fail "the verification reported $mechanisms mechanism line(s), not 6"
fi

# The measurements this work exists to make, read out of the run's own log.
while IFS= read -r line; do
	if grep -qF -- "$line" "$verify_log"; then
		pass "measured: ${line}"
	else
		fail "the verification log does not report: ${line}"
	fi
done <<'MEASURED'
the HUD is at its J7 hash 38c485cb, 234 lines; with J7's 8 inserted lines removed it is, byte for byte, the D-333 file aff939f3, 226 lines
54 files J7 stands beside hold the hashes they held before the first J7 edit
put back, the 11 are byte for byte f065a48d, 68a1227e, f7b48202, 308fe51a, b7ff3d66, 733d4af8, f5451331, c5a873fd, d69585af, 4f8cad92, e5d90d8e (45 replaced blocks)
_build(): the accepted 51 code lines plus exactly one, before the fill joins its track: _hover_fill.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
show_hover(): the accepted 7 code lines plus exactly one, before the width write: _hover_fill.custom_minimum_size = Vector2(190.0 * fraction, 10.0); its null-and-dead branch is still its first three lines
5 scenes instance the HUD: canonical_opening.tscn, broken_watch_slice.tscn, roguelite_build_variety_review.tscn, roguelite_core_loop.tscn, roguelite_replayability_review.tscn
show_hover() is called twice, both in broken_watch_slice.gd's _update_hover_info()
canonical_opening.tscn is Gate 1E's scene, and the roguelite runtimes extend the slice: each inherits the correction by instancing the same script — structural only, not measured here
the slice's _update_hover_info() is its 13 accepted code lines: a fresh ray under the pointer, then show_hover() — it writes nothing an attack reads
the first laid-out update: "Graveblade" fill 190 x 10 at x 862 in a 196 x 10 track: 100.0% of 190; the panel shown, 220 x 60 at (850, 18)
the first sort of the track after the panel appeared left the fill 190 px; the updates read 190 px on all
3 real Quick Strikes, aimed through force_next_aim_for_verification(): Life 300 -> 200 -> 100 -> 0, each one damage record of raw 100 from the player; the third killed it
at 200 / 300 the truthful fill is 126.67 px: the first laid-out update after the pointer moved over the Graveblade: "Graveblade" fill 126.67 x 10 at x 862 in a 196 x 10 track: 66.7% of 190
the first sort of the track after the panel appeared left the live fill 126.67 px; the pre-J7 HUD, shown the same enemy in the same update, read 196 px on that update
every fill the truthful width, 190, 126.67, 63.33 px
each leaving the fill at that stage's truthful width; the pre-J7 HUD's forced sorts left its fill 196, 196, 196 px
when it moved back, the first laid-out update read 190, 126.67, 63.33 px at 300, 200 and 100 of 300, and no live sort or update in between reached the full 190 px while the Graveblade was damaged
the pre-J7 HUD, reopened the same way in the same updates, read 196, 196, 196 px on its first update each time
at 100 / 300 the truthful fill is 63.33 px: the first laid-out update: "Graveblade" fill 63.33 x 10 at x 862 in a 196 x 10 track: 33.3% of 190
the first sort left the live fill 63.33 px, and the updates read 63.33 px on all
the layout difference is the fill's horizontal size flag (live 0 / pre-J7 1: SIZE_SHRINK_BEGIN against SIZE_FILL) and its minimum width
every fill between 0 and 190 px, at its own minimum width, starting at its track's left edge; the fill never passed its track's right edge — at its widest it ended 6 px inside it
staged, supplemental: a fixture Graveblade shown through the HUD's own show_hover() at 450 / 300 -> 190 px, 150 / 300 -> 95 px, 0 / 300 -> 0 px, -50 / 300 -> 0 px, 300 / 300 -> 190 px; the pre-J7 HUD read 190, 190, 190, 190, 190 px; then hidden again
the slice's own ray found no target — a dead Graveblade is not a valid target — and the panel hidden on every one
show_hover() called directly with the dead Graveblade while the fixture's panel stood: hidden in the same call; shown again by the next update's staged call; then show_hover(null): hidden in the same call
read exactly what they read before the pointer moved; the mouse stayed the live family
the Life fill 260 px at 500 / 500 throughout, and the Mana fill always 260 x Mana / 100 within 0.01 px — down to 247 px at 95 / 100 after the Quick Strikes
updates compared with both panels shown, live against pre-J7: the panel's rect, minimum, anchors and style, the name's rect, text, size, colour and alignment, the track's rect, minimum and style, the fill's colour, origin and height, both player bars and their labels, and the resources column — identical
nominal: the panel 220 x 60 at (centre - 110, 18) = (850, 18), SLATE with a 1 px IRON border, radius 3, margins 12; the name 15 px, centred; the track 190 x 10 minimum, (0.10, 0.11, 0.13), radius 2; the fill LIFE (0.78, 0.26, 0.24)
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
		grep -E "^  hover route: " "$window_log" | cut -c1-300 | sed "s/^  /        $resolution /"
		shots="$(grep -cE "^  screenshot: " "$window_log" | tr -d ' ')"
		full="$(grep -E "^  screenshot: .*/01_hover_full_300_of_300\.png \($resolution\) — 300 / 300: \"Graveblade\" fill 190 x 10 " "$window_log" \
			| grep -cF 'the panel shown' | tr -d ' ')"
		two="$(grep -E "^  screenshot: .*/02_hover_two_thirds_200_of_300\.png \($resolution\) — 200 / 300: \"Graveblade\" fill 126\.67 x 10 " "$window_log" \
			| grep -cF 'the panel shown' | tr -d ' ')"
		one="$(grep -E "^  screenshot: .*/03_hover_one_third_100_of_300\.png \($resolution\) — 100 / 300: \"Graveblade\" fill 63\.33 x 10 " "$window_log" \
			| grep -cF 'the panel shown' | tr -d ' ')"
		if [[ "$shots" == "3" && "$full" == "1" && "$two" == "1" && "$one" == "1" \
				&& -s "$target/01_hover_full_300_of_300.png" && -s "$target/02_hover_two_thirds_200_of_300.png" && -s "$target/03_hover_one_third_100_of_300.png" ]]; then
			pass "at $resolution three frames were saved: the hover panel at 300 / 300 with a 190 px fill, at 200 / 300 with 126.67 px and at 100 / 300 with 63.33 px"
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
	pass "every other production file is still as D-333 left it after the runs, but for Gate 1D's slice, which J9 and J10 moved (D-338, D-340), and Broken Watch's layout, which J10 moved (D-340)"
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
step "7. This run's temporary directory is removed and nothing of J7 is left behind"

rm -rf "$work"
if [[ ! -e "$work" && "$(leftover_count)" == "0" ]]; then
	pass "the temporary directory is gone and no $TEMP_STEM.* directory remains in $TEMP_ROOT"
else
	fail "a J7 temporary directory remains in $TEMP_ROOT"
fi

# --------------------------------------------------------------------------
printf '\n'
modes="headless"
[[ "$SHOTS" == "1" ]] && modes="headless, 1920x1080 and 1280x720"
if [[ "$failures" == "0" ]]; then
	printf 'ENEMY HOVER LIFE FRACTIONAL FILL SMOKE CHECKS: PASS\n'
	printf '  %s checks; %s of %s owed; %s; %s protected files and .godot/ byte-identical\n' \
		"$EXPECTED_CHECKS" "$EXPECTED_OWED_CHECKS" "$EXPECTED_OWED_CHECKS" "$modes" "${#PRESERVED_FILES[@]}"
	printf 'J7 — Enemy Hover-Life Fractional Fill Truthfulness V1 — ACCEPTED\n'
	printf 'VERDICT: PASS — J7 is accepted. The enemy hover-Life fill remains truthful on its first layout, later updates, reopening and forced layout passes, while hover remains informational only.\n'
	printf 'D-223 remains OPEN.\n'
	reached_end=1
	exit 0
else
	printf 'ENEMY HOVER LIFE FRACTIONAL FILL SMOKE CHECKS: %d FAILURE(S)\n' "$failures"
	reached_end=1
	exit 1
fi
