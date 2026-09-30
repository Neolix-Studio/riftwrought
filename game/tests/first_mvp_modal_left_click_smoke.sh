#!/usr/bin/env bash
# Riftwrought — First-MVP UI J1: Shared Modal Left-Click Activation V1 smoke checks
# (decision D-322).
#
# THIS IS NOT A GATE, AND IT RUNS NO LOCKED CHAIN.
#
# J1 changes exactly two production files: `FirstMvpModal._input()` lets an open modal's
# left PRESS continue to Godot's GUI, and `RiftLevelUpOfferPanel` loses the I2-local
# override and counter that did the same for one panel. What this script proves:
#
#   1. the new verification and both changed files parse;
#   2. both changed files are at their D-322 hashes;
#   3. the pinned verification passes headless, proved in BOTH directions against a
#      replay of its own log, with every owed check reaching its last line (also proved
#      both ways), the measured lines read out of the log, zero SCRIPT ERROR and zero
#      engine ERROR, and no engine WARNING but the accepted ones counted exactly;
#   4. the same verification passes at 1920x1080 and at the 1280x720 minimum window, at
#      the SAME pinned count, each run reporting the window it was given;
#   5. `project.godot` is untouched: 31 actions, the Prototype App entrypoint, the same
#      nine sections, no `[autoload]`;
#   6. every file this work stands beside is BYTE-IDENTICAL across the run, the canonical
#      opening only ever wrote into this run's own `mktemp -d` directories, and the project
#      owner's own user:// files are untouched.
#
# Usage, from the repository root:
#   game/tests/first_mvp_modal_left_click_smoke.sh

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
		printf '\nFIRST-MVP MODAL LEFT CLICK SMOKE CHECKS: ABORTED before the end of the script\n'
		printf '  the run stopped early (exit %s) — nothing after that point was proved\n' "$code"
		exit 1
	fi
	exit "$code"
}
trap on_exit EXIT

GODOT="${GODOT:-/Applications/Godot.app/Contents/MacOS/Godot}"
EXPECTED_VERSION="4.7.2.stable"
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ROUTE_SEED=99

# Pinned, and proved in both directions below. ONE number for all three runs.
EXPECTED_CHECKS=55
EXPECTED_OWED_CHECKS=30
VERIFICATION_TIMEOUT=600

EXPECTED_INPUT_ACTIONS=31
EXPECTED_MAIN_SCENE="res://scenes/app/prototype_app.tscn"
EXPECTED_SECTIONS="application audio debug display editor_plugins input layer_names navigation rendering"

# Engine warnings the verification may print, each with the exact number of times it
# must appear: the accepted navigation bake's two precision lines once per scene loaded
# (five scenes), and the canonical opening's own startup probe, which may report once
# that its map was not yet queryable within its own 40 physics frames. It is the
# opening's accepted runtime code, printed before any J1 check runs in that scene; the
# suite waits for the map itself before it acts.
BAKE_CLIMB="WARNING: Property agent_max_climb is floored to cell_height voxel units and loses precision."
BAKE_RADIUS="WARNING: Property agent_radius is ceiled to cell_size voxel units and loses precision."
OPENING_PROBE="WARNING: BrokenWatchSlice: the navigation map did not become queryable"
EXPECTED_BAKE_LINES=5
MOST_OPENING_PROBES=1

THIS_VERIFICATION="tests/first_mvp_modal_left_click_verification.gd"
MODAL="scripts/ui/first_mvp_modal.gd"
PANEL="scripts/roguelite/level_up/rift_level_up_offer_panel.gd"

D322_ROWS=(
	"$MODAL|1cfe9c73"
	"$PANEL|694eb0b2"
)

# Fingerprinted before and after the run: the two changed files, everything the
# verification pins as unchanged, the project owner's composed zone, and the two
# handoff documents.
PRESERVED_FILES=(
	"$MODAL"
	"$PANEL"
	"$THIS_VERIFICATION"
	"project.godot"
	"scenes/first_mvp/zone_composer_practice.tscn"
	"../CLAUDE.md"
	"../README.md"
	"scripts/ui/first_mvp_fallen_overlay.gd"
	"scripts/ui/first_mvp_item_comparison.gd"
	"scripts/ui/foundation_cache_panel.gd"
	"scripts/ui/nexus_dialogue_panel.gd"
	"scripts/ui/origin_ring_panel.gd"
	"scripts/roguelite/replayability/roguelite_boon_choice_panel.gd"
	"scripts/roguelite/roguelite_run_summary_panel.gd"
	"scripts/roguelite/build_variety/roguelite_upgrade_choice_panel.gd"
	"scripts/roguelite/roguelite_fallen_overlay.gd"
	"scripts/roguelite/replayability/roguelite_replayability_summary_panel.gd"
	"scripts/roguelite/build_variety/roguelite_build_variety_summary_panel.gd"
	"scripts/ui/gate_e_modal.gd"
	"scripts/first_mvp/severed_threshold/broken_watch_slice.gd"
	"scripts/roguelite/roguelite_core_loop_runtime.gd"
	"scripts/first_mvp/canonical_opening/canonical_opening_runtime.gd"
	"scripts/roguelite/replayability/roguelite_replayability_runtime.gd"
	"scripts/roguelite/build_variety/roguelite_build_variety_runtime.gd"
	"scripts/roguelite/level_up/roguelite_level_up_choice_review.gd"
	"scripts/roguelite/experience/roguelite_experience_collection_review.gd"
	"scripts/roguelite/live_effects/roguelite_live_effect_review.gd"
	"scripts/input/input_family_tracker.gd"
	"scripts/movement/prototype_mouse_hold.gd"
	"scripts/actors/prototype_player.gd"
	"scenes/roguelite/roguelite_core_loop.tscn"
	"scenes/first_mvp/canonical_opening/canonical_opening.tscn"
	"scenes/roguelite/roguelite_replayability_review.tscn"
	"scenes/roguelite/roguelite_build_variety_review.tscn"
	"scenes/roguelite/roguelite_level_up_choice_review.tscn"
	"scenes/roguelite/roguelite_live_effect_review.tscn"
	"scenes/roguelite/roguelite_experience_collection_review.tscn"
	"scenes/first_mvp/severed_threshold/broken_watch_slice.tscn"
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

# Engine ERROR lines are refused outright; every WARNING must be one of the three
# accepted lines, the two bake lines exactly EXPECTED_BAKE_LINES times each and the
# opening's probe at most MOST_OPENING_PROBES times.
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
	probe="$(grep -cxF "$OPENING_PROBE" "$logfile" | tr -d ' ')"
	others="$(grep -E "^WARNING:" "$logfile" | grep -vxF "$BAKE_CLIMB" | grep -vxF "$BAKE_RADIUS" \
		| grep -vxF "$OPENING_PROBE" | wc -l | tr -d ' ')"
	if [[ "$climb" == "$EXPECTED_BAKE_LINES" && "$radius" == "$EXPECTED_BAKE_LINES" \
			&& "$probe" -le "$MOST_OPENING_PROBES" && "$others" == "0" ]]; then
		pass "$what printed each bake warning $EXPECTED_BAKE_LINES times (once per scene), the opening's startup probe $probe time(s), and no other WARNING"
	else
		fail "$what printed bake lines $climb / $radius, the opening's probe $probe time(s), and $others other warning(s)"
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

BANNER="FIRST-MVP MODAL LEFT CLICK VERIFICATION"

printf 'Riftwrought — First-MVP UI J1: Shared Modal Left-Click Activation V1 smoke checks (D-322)\n'
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

project_name="$(sed -n 's/^config\/name="\(.*\)"[[:space:]]*$/\1/p' "$PROJECT_DIR/project.godot" | head -1)"
production_dir="$HOME/Library/Application Support/Godot/app_userdata/$project_name"
settings_before="$(state_fingerprint "$production_dir/prototype_settings.cfg")"
lab_before="$(state_fingerprint "$production_dir/prototype_zero.cfg")"
character_before="$(state_fingerprint "$production_dir/riftwrought_character.cfg")"
pass "the project owner's own three user:// files fingerprinted"

# --------------------------------------------------------------------------
step "1. The new verification and both changed files parse"

for relative in "$THIS_VERIFICATION" "$MODAL" "$PANEL"; do
	out="$("$GODOT" --headless --path "$PROJECT_DIR" --check-only --script "res://$relative" 2>&1 \
		| grep -v '^Godot Engine')"
	if [[ -z "$out" ]]; then
		pass "$relative parses"
	else
		fail "$relative does not parse"
		printf '%s\n' "$out" | head -10 | sed 's/^/        /'
	fi
done

# --------------------------------------------------------------------------
step "2. Both changed files are at their D-322 hashes"

for row in "${D322_ROWS[@]}"; do
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

verify_log="/tmp/riftwrought_first_mvp_modal_left_click_verify.log"
# Made HERE, never inside `$(…)`: a subshell's `scratch+=` would never reach the cleanup.
state_dir="$(mktemp -d -t riftwrought_j1_state)"
scratch+=("$state_dir")
run_verification "$verify_log" --headless --path "$PROJECT_DIR" --script "res://$THIS_VERIFICATION" \
	-- --seed "$ROUTE_SEED" --state-dir "$state_dir"
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
	grep -E "FAIL:" "$verify_log" | head -20 | sed 's/^/        /'
fi

count="$(read_check_count "$BANNER" "$verify_log")"
if [[ "$count" == "$EXPECTED_CHECKS" ]]; then
	pass "verification passes at the pinned $EXPECTED_CHECKS checks"
else
	fail "verification reports ${count:-no} checks, not $EXPECTED_CHECKS"
fi

# A guard that accepts everything protects nothing: each pin must refuse a replay of this
# run's own log with its number moved by one, and must READ the moved number.
replay="$(mktemp -t riftwrought_j1_replay)"
scratch+=("$replay")
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
	fail "the owed-set report is missing or short"
	grep -E "owed checks" "$verify_log" | sed 's/^/        /'
fi
sed "s/$owed_line/  $((EXPECTED_OWED_CHECKS - 1)) of $EXPECTED_OWED_CHECKS owed checks completed/" "$verify_log" > "$replay"
if ! grep -qxF "$owed_line" "$replay" && grep -qxF "  $((EXPECTED_OWED_CHECKS - 1)) of $EXPECTED_OWED_CHECKS owed checks completed" "$replay"; then
	pass "and that pin refuses a replay reporting $((EXPECTED_OWED_CHECKS - 1)) of $EXPECTED_OWED_CHECKS"
else
	fail "the owed-set pin accepts a short replay and therefore proves nothing"
fi

# The measurements this work exists to make, read out of the run's own log.
while IFS= read -r line; do
	if grep -qF -- "$line" "$verify_log"; then
		pass "measured: ${line}"
	else
		fail "the verification log does not report: ${line}"
	fi
done <<'MEASURED'
the contract is at its D-322 hash 1cfe9c73 and the I2 panel at 694eb0b2; 32 files
the pass-through is written once, in first_mvp_modal.gd; the only other running files naming MOUSE_BUTTON_LEFT in code are two in-engine verification tools and the Zone Composer plugin, none of them a modal; the header states the rule and names D-322
24 code lines: the open guard first, the release re-arming, cancel and confirm unchanged, then `var click …`, `if click.button_index == MOUSE_BUTTON_LEFT and click.pressed:`, `return`, then the accepted quick_strike / move_point block; 23 functions, 10 fields, 8 constants and 2 signals, none added
0 of 6 hit-test tokens in the contract and the 12 descendants; `emit_signal("pressed")` appears once, in activate_focused(), called only from the ui_confirm / interact branch above the pointer lines
no _input, no counter, no mouse token; 20 functions and 11 fields where there were 21 and 12; no running file names left_presses_passed
direct: FirstMvpFallenOverlay, FirstMvpItemComparison, FoundationCachePanel, NexusDialoguePanel, OriginRingPanel, RiftLevelUpOfferPanel, RogueliteBoonChoicePanel, RogueliteRunSummaryPanel, RogueliteUpgradeChoicePanel; beneath them: RogueliteFallenOverlay, RogueliteReplayabilitySummaryPanel, RogueliteBuildVarietySummaryPanel
0 of 5 pointer tokens in the 12 descendant scripts; one _input() among them, first_mvp_fallen_overlay.gd's, which answers quick_restart and hands every other event to the contract
31 actions; move_point is the left mouse button alone; the entrypoint is prototype_app.tscn; project.godot declares no [autoload] and names nothing of J1
Close by one click: one pressed, the panel closed once, the Expedition Blade still on the ground and not owned; Escape closed it again; Equip by one click: one pressed, picked up and equipped (owned 1 -> 2), the run's reward marked equipped, the ground item gone
one left press and release over "Back to the Nexus": one pressed, the summary closed once and the run stayed complete in the Nexus — where D-293 measured closes = 0; reopened, the same click in the same call closed it once more
one left press and release over "Return to the Nexus": one pressed, the overlay closed once, exactly one run ended (run index 1 -> 2) and the character stands alive in the Nexus
the character file lies inside the run's own state directory; one left press and release over "Restart Broken Watch": one pressed, the overlay closed once, one restart through restart_current_slice(), the character alive
the left button held over the world as F1 opened the Ring: its release over Close acted on nothing and re-armed the panel; a fresh click closed it once; no destination followed
(A) held as it opened the Ring beside the Anchor: pressed again while held, refused once by the contract's held-input rule; released, re-armed; a fresh (A) confirmed the focused Close once
the pointer over Orbiting Guard previewed it and left first_fracture selected; a click selected it; Allocate spent the one point on it; Refund returned it; Close closed the Ring once — one pressed each
a click on Continue advanced exactly one line and Enter one more; a click on Skip went to the last line, hid Skip and left the focus on Close; a click on Close read it through, recorded the conversation and closed once
the pointer over the third card previewed it and left card 1 selected; a click selected the third card; Escape and then Not yet closed without choosing; a click on the second card and on Choose granted exactly its package — Splinter Shot and the Marrow Bow — once
one left press and release over "Quickened Edge": one pressed on that button and none on the other; exactly one boon taken — Quickened Edge — the reward beat cleared, and the run still in that room
one left press and release over the second slot's button: one pressed; exactly one upgrade taken — Reaching Edge, the kind that slot held — and the panel closed once
one left press and release over card 3: one pressed; lane 2 (Utility) taken through H8, I1 and G4 — granted [card_fleetness], the identity the standing offer held for that lane — one attempt, one choice, the panel closed at Rift level 2
10 of 10 panels: the pointer passed over every visible button — 31 in all — and nothing was pressed
10 of 10 panels: each press landed on the modal's own Dim, then on its own Panel body; each stopped there
10 of 10 panels: the pointer over a committing button, a right press and release — nothing pressed
Enter closed the run summary through its focused "Back to the Nexus" and advanced the first conversation one line through its focused Continue
(A) closed the run summary, advanced the first conversation one line, and — once its held press was released — closed the Origin Ring through its focused Close
Escape closed the comparison, the run summary, the conversation, the Origin Ring and the Foundation Cache once each; Escape and (B) left both Fallen overlays, the boon, the upgrade and the level-up choice open over the same state
4 closing clicks sent through Input.parse_input_event() — the comparison's Close, the run summary's "Back to the Nexus", the conversation's Close and the boon's second choice: over the 20 physics frames after each, no destination, no attack, no movement, no modal, and the left button no longer held
10 of 10 panels: over 10 physics frames the tree stayed paused, the character did not move and no attack began
10 of 10 panels opened with their accepted safe control focused
21 activating clicks on 10 panels, every one over the real button: exactly one pressed on that button and none on any other button in its panel
display headless, window 64x64, visible 1920x1920
MEASURED

# --------------------------------------------------------------------------
step "4. The same verification at 1920x1080 and at the 1280x720 minimum window"

for resolution in 1920x1080 1280x720; do
	window_log="/tmp/riftwrought_first_mvp_modal_left_click_$resolution.log"
	state_dir="$(mktemp -d -t riftwrought_j1_state)"
	scratch+=("$state_dir")
	run_verification "$window_log" --path "$PROJECT_DIR" --resolution "$resolution" \
		--script "res://$THIS_VERIFICATION" -- --seed "$ROUTE_SEED" --state-dir "$state_dir" --expect-window "$resolution"
	window_status=$?
	printf '  %s verification exit status: %s\n' "$resolution" "$window_status"
	assert_log_is_fresh "$window_log"
	assert_no_script_error "the $resolution run" "$window_log"
	assert_engine_output "the $resolution run" "$window_log"
	window_count="$(read_check_count "$BANNER" "$window_log")"
	if [[ "$window_status" == "0" && "$window_count" == "$EXPECTED_CHECKS" ]] \
			&& grep -qxF "$owed_line" "$window_log"; then
		pass "the $resolution run exits 0 at the same pinned $EXPECTED_CHECKS checks, $EXPECTED_OWED_CHECKS of $EXPECTED_OWED_CHECKS owed"
	else
		fail "the $resolution run exits $window_status at ${window_count:-no} checks"
		grep -E "FAIL:" "$window_log" | head -10 | sed 's/^/        /'
	fi
	if grep -qE "^  display [A-Za-z]+, window $resolution, visible 1920x1080, stretch x" "$window_log"; then
		pass "the run reports a $resolution window showing the 1920x1080 canvas"
	else
		fail "the $resolution run does not report its window"
	fi
	if grep -qF "10 of 10 panels: each press landed on the modal's own Dim, then on its own Panel body" "$window_log" \
			&& grep -qF "21 activating clicks on 10 panels, every one over the real button" "$window_log"; then
		pass "at $resolution every click landed on the real button and every backdrop press on the backdrop"
	else
		fail "at $resolution a click or a backdrop press was not measured as expected"
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
step "6. Every protected file is byte-identical, and the owner's files are untouched"

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

written=0
for dir in "${scratch[@]}"; do
	[[ -d "$dir" && -f "$dir/riftwrought_character.cfg" ]] && written=$((written + 1))
done
if [[ "$written" == "3" ]]; then
	pass "each of the 3 runs' canonical openings wrote its character only into its own mktemp -d directory"
else
	fail "$written of 3 isolated state directories hold the opening's character file"
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
	printf 'FIRST-MVP MODAL LEFT CLICK SMOKE CHECKS: PASS\n'
	printf '  %s checks; %s of %s owed; headless, 1920x1080 and 1280x720; %s protected files byte-identical\n' \
		"$EXPECTED_CHECKS" "$EXPECTED_OWED_CHECKS" "$EXPECTED_OWED_CHECKS" "${#PRESERVED_FILES[@]}"
	printf '  First-MVP UI J1 — Shared Modal Left-Click Activation V1 is DELIVERED under D-322\n'
	printf '  and ACCEPTED and CLOSED at the shared First-MVP modal left-click GUI-routing\n'
	printf '  mechanism level under D-323. D-223 remains OPEN.\n'
	reached_end=1
	exit 0
else
	printf 'FIRST-MVP MODAL LEFT CLICK SMOKE CHECKS: %d FAILURE(S)\n' "$failures"
	reached_end=1
	exit 1
fi
