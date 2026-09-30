#!/usr/bin/env bash
# Riftwrought — First-MVP UI J2: Fallen-State Preservation Across Modal Neutralization V1 smoke
# checks (decision D-324).
#
# THIS IS NOT A GATE, AND IT RUNS NO LOCKED CHAIN.
#
# J2 changes exactly one production file: `PrototypePlayer.clear_movement_intent()` still clears
# every control, but assigns IDLE only when the character is not FALLEN, so a modal's
# neutralization — the Fallen overlay's own opening above all — no longer makes `is_alive()` answer
# true at zero Life. What this script proves:
#
#   1. the new verification and the player parse;
#   2. the player is at its D-324 hash;
#   3. the pinned verification passes headless, proved in BOTH directions against a replay of its
#      own log — its check count, its owed count and the exact owed SET — with the measured lines
#      read out of the log, zero SCRIPT ERROR and zero engine ERROR, and no engine WARNING but the
#      accepted ones counted exactly;
#   4. `project.godot` is untouched: 31 actions, the Prototype App entrypoint, the same nine
#      sections, no `[autoload]`;
#   5. every file this work stands beside is BYTE-IDENTICAL across the run, and the project owner's
#      own user:// files are untouched.
#
# Usage, from the repository root:
#   game/tests/fallen_modal_life_state_smoke.sh

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
		printf '\nFALLEN MODAL LIFE STATE SMOKE CHECKS: ABORTED before the end of the script\n'
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

# Pinned, and proved in both directions below.
EXPECTED_CHECKS=34
EXPECTED_OWED_CHECKS=31
OWED_SET="the_production_scope_is_exactly_the_player, the_player_declares_nothing_new, is_alive_is_unchanged, clear_movement_intent_is_the_accepted_body_with_one_fallen_rule, the_player_stays_the_only_state_authority, no_modal_or_runtime_carries_a_death_special_case, no_scene_input_map_or_presentation_changed, a_living_idle_neutralization_is_unchanged, a_living_navigate_neutralization_is_unchanged, a_living_stick_neutralization_is_unchanged, a_fallen_neutralization_clears_controls_and_keeps_fallen, gate_1d_living_modals_still_neutralize_to_idle, gate_1d_the_delay_keeps_the_player_fallen_with_no_modal, gate_1d_opening_fallen_changes_no_death_fact, gate_1d_the_paused_fallen_player_can_do_nothing, gate_1d_restart_by_focused_confirm, gate_1d_restart_by_a_real_left_click_without_click_through, gate_1d_restart_by_f5_while_the_overlay_stands, roguelite_vitality_is_held_at_575_and_living_offers_neutralize_to_idle, roguelite_the_delay_and_the_open_overlay_keep_the_player_fallen_at_0_of_575, roguelite_no_sweep_pickup_experience_or_offer_while_fallen, roguelite_the_paused_fallen_player_can_do_nothing, roguelite_a_real_left_click_returns_to_the_nexus_and_restores_the_baseline, roguelite_focused_confirm_returns_once, roguelite_f5_while_the_overlay_stands_returns_once, roguelite_f5_inside_the_delay_cancels_the_overlay, the_next_expedition_begins_clean, no_life_damage_or_fall_signal_repeats, no_new_damage_is_accepted_while_fallen, the_killing_event_and_instrumentation_are_unchanged, the_overlays_read_exactly_as_accepted"
VERIFICATION_TIMEOUT=600

EXPECTED_INPUT_ACTIONS=31
EXPECTED_MAIN_SCENE="res://scenes/app/prototype_app.tscn"
EXPECTED_SECTIONS="application audio debug display editor_plugins input layer_names navigation rendering"

# Engine warnings the verification may print, each with the exact number of times it must appear:
# the accepted navigation bake's two precision lines once per scene loaded (two scenes), and Gate
# 1D's own startup probe, which may report once that its map was not yet queryable within its own
# 40 physics frames — the unchanged, hash-pinned `BrokenWatchSlice._await_navigation_synchronized()`
# inside the slice's own `_ready()`, before any J2 check runs there; the suite waits for the map
# itself before it acts.
BAKE_CLIMB="WARNING: Property agent_max_climb is floored to cell_height voxel units and loses precision."
BAKE_RADIUS="WARNING: Property agent_radius is ceiled to cell_size voxel units and loses precision."
SLICE_PROBE="WARNING: BrokenWatchSlice: the navigation map did not become queryable"
EXPECTED_BAKE_LINES=2
MOST_SLICE_PROBES=1

THIS_VERIFICATION="tests/fallen_modal_life_state_verification.gd"
PLAYER="scripts/actors/prototype_player.gd"

D324_ROWS=(
	"$PLAYER|80e38838"
)

# Fingerprinted before and after the run: the changed file, the four accepted verifications and
# three runners whose player row J2 moved, everything the verification pins as unchanged, the project
# owner's composed zone, and the two handoff documents.
PRESERVED_FILES=(
	"$PLAYER"
	"$THIS_VERIFICATION"
	"tests/roguelite_repeated_live_effect_loop_verification.gd"
	"tests/roguelite_repeated_live_effect_loop_smoke.sh"
	"tests/global_damage_live_application_verification.gd"
	"tests/global_damage_live_application_smoke.sh"
	"tests/maximum_life_live_application_verification.gd"
	"tests/maximum_life_live_application_smoke.sh"
	"tests/first_mvp_modal_left_click_verification.gd"
	"tests/first_mvp_modal_left_click_smoke.sh"
	"project.godot"
	"scenes/first_mvp/zone_composer_practice.tscn"
	"../CLAUDE.md"
	"../README.md"
	"scripts/ui/first_mvp_modal.gd"
	"scripts/ui/first_mvp_fallen_overlay.gd"
	"scripts/roguelite/roguelite_fallen_overlay.gd"
	"scripts/ui/first_mvp_item_comparison.gd"
	"scripts/roguelite/level_up/rift_level_up_offer_panel.gd"
	"scripts/ui/gate_e_modal.gd"
	"scripts/ui/prototype_fallen_overlay.gd"
	"scripts/prototype_zero/prototype_zero.gd"
	"scripts/first_mvp/severed_threshold/broken_watch_slice.gd"
	"scripts/first_mvp/canonical_opening/canonical_opening_runtime.gd"
	"scripts/roguelite/roguelite_core_loop_runtime.gd"
	"scripts/roguelite/experience/roguelite_experience_collection_review.gd"
	"scripts/roguelite/level_up/roguelite_level_up_choice_review.gd"
	"scripts/roguelite/live_effects/roguelite_live_effect_review.gd"
	"scripts/combat/quick_strike_action.gd"
	"scripts/combat/attack_coordinator.gd"
	"scripts/combat/damage_event.gd"
	"scripts/actors/prototype_graveblade.gd"
	"scripts/movement/prototype_locomotion.gd"
	"scripts/roguelite/live_effects/rift_build_application.gd"
	"scripts/roguelite/live_effects/rift_build_application_result.gd"
	"scripts/experience/rift_mote_runtime.gd"
	"scripts/stats/player_stats.gd"
	"scripts/ui/first_mvp_combat_hud.gd"
	"scripts/roguelite/roguelite_run_hud.gd"
	"scripts/roguelite/experience/roguelite_experience_review_hud.gd"
	"scenes/actors/prototype_player.tscn"
	"scenes/actors/prototype_graveblade.tscn"
	"scenes/first_mvp/severed_threshold/broken_watch_slice.tscn"
	"scenes/first_mvp/canonical_opening/canonical_opening.tscn"
	"scenes/roguelite/roguelite_core_loop.tscn"
	"scenes/roguelite/roguelite_experience_collection_review.tscn"
	"scenes/roguelite/roguelite_level_up_choice_review.tscn"
	"scenes/roguelite/roguelite_live_effect_review.tscn"
	"data/prototype_zero/graveblade.tres"
	"data/roguelite/graveblade_elite.tres"
	"data/roguelite/worn_blade.tres"
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
		pass "$what printed each bake warning $EXPECTED_BAKE_LINES times (once per scene), Gate 1D's startup probe $probe time(s), and no other WARNING"
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

BANNER="FALLEN MODAL LIFE STATE VERIFICATION"

printf 'Riftwrought — First-MVP UI J2: Fallen-State Preservation Across Modal Neutralization V1 smoke checks (D-324)\n'
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
step "1. The new verification and the player parse"

for relative in "$THIS_VERIFICATION" "$PLAYER"; do
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
step "2. The player is at its D-324 hash"

for row in "${D324_ROWS[@]}"; do
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

verify_log="/tmp/riftwrought_fallen_modal_life_state_verify.log"
run_verification "$verify_log" --headless --path "$PROJECT_DIR" --script "res://$THIS_VERIFICATION" \
	-- --seed "$ROUTE_SEED"
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

# A guard that accepts everything protects nothing: each pin must refuse a replay of this run's own
# log with its value moved, and must READ the moved value.
replay="$(mktemp -t riftwrought_j2_replay)"
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

# The measurements this work exists to make, read out of the run's own log.
while IFS= read -r line; do
	if grep -qF -- "$line" "$verify_log"; then
		pass "measured: ${line}"
	else
		fail "the verification log does not report: ${line}"
	fi
done <<'MEASURED'
the player is at its J2 hash 80e38838; with J2's 8 comment lines removed and its 2-line guard put back as the accepted 1 line it is, byte for byte, the pre-J2 file a6d93721
38 files J2 stands beside hold the hashes they held before the first J2 edit
30 fields, 18 exports, 53 functions, 4 constants, 2 enums and 10 signals — the counts before J2
func is_alive() -> bool: / return action_state != ActionState.FALLEN — no Life test, no modal test, nothing else
14 code lines: the attack cleared, the suspension, the destination, the agent's target, the locomotion and the velocity, then `if action_state != ActionState.FALLEN:` over the accepted `action_state = ActionState.IDLE`
receive_damage() is its 13 accepted lines (Life, then the Hit, then the fall) and _fall() its 18
none writes an action state; inside the player, [command_move_to, clear_movement_intent, _fall, revive_for_testing, _physics_process, _arrive] do
0 of 7 death tokens in first_mvp_modal.gd, first_mvp_fallen_overlay.gd and roguelite_fallen_overlay.gd
31 actions; the entrypoint is prototype_app.tscn; project.godot declares no [autoload] and names nothing of J2
IDLE -> IDLE; changed exactly [agent_target, awaiting_neutral, neutral_reason]
NAVIGATE (mouse path) -> IDLE; changed exactly [action_state, agent_target, awaiting_neutral, has_destination, movement_mode, neutral_reason]
a stick of 0.90 commanding -> not commanding, IDLE; changed exactly [agent_target, awaiting_neutral, neutral_reason, stick_magnitude, stick_raw]
FALLEN -> FALLEN at 0 / 500; changed exactly [neutral_reason, stick_magnitude, stick_raw, velocity]
then command_move_to() answered 'rejected: fallen', a live stick did not command, and a 50-damage event was refused; revive_for_testing() alone brought it back
QUICK STRIKE (ATTACK_WINDUP, none, attack ATTACK_WINDUP) -> IDLE, mode none, no destination, no velocity, stick at rest, attack READY with no target or buffer, latched as 'comparison opened', paused, Close focused
STICK (NAVIGATE, controller direct, attack READY) -> IDLE, mode none, no destination, no velocity, stick at rest
the wind-up was cancelled before its release (1 cancelled use); the Graveblade it aimed at still holds 300 Life
4 of the Graveblade's own attacks: Life 500 -> 375 -> 250 -> 125 -> 0; on the lethal frame FALLEN, not alive, no modal, not paused, no attack permission held, 0 Graveblades acting
inside open()'s neutralization and after it: FALLEN, not alive, Life 0 / 500, the same fallen_at_msec, 4 DamageEvents, the same killing event, Mana 100, the same weapon, position and facing; movement_intent_cleared said [fallen, fallen opened]; the latch reads 'fallen opened'
30 physics and 10 idle frames: paused and FALLEN at 0 / 500 throughout; the left press landed on the overlay's own Dim and the right press over "Restart Broken Watch" pressed nothing
Gate 1D's slice carries 0 Foundation Skill actions, so none can begin
the overlay closed once, one restart_current_slice(), one revival (life_changed [500 / 500 IDLE], IDLE, latched 'encounter reset')
one left press and release through Input.parse_input_event(): one pressed, on that button; the overlay closed once, one restart_current_slice()
Rift level 6 holding one Vitality: Life 575 / 575 — C1's answer for +15% on the unmodified 500 — alive and not paused
3 offers opened through the contract on a living character (Levels 1, 2 and 3; 4 and 5 replaced them in place): each left it IDLE, latched as 'level-up offer opened', and the world paused
5 of the escort's own attacks: Life 575 -> 450 -> 325 -> 200 -> 75 -> 0
inside the overlay's own neutralization and after it: FALLEN, not alive, Life 0 / 575, Maximum Life +15% over a baseline of 500; movement_intent_cleared said [fallen, fallen opened]
the mote was dropped at the corpse's feet (uncollected 0 -> 1)
30 physics and 10 idle frames: paused and FALLEN at 0 / 575 throughout; the left press landed on the overlay's own Dim and the right press over "Return to the Nexus" pressed nothing
the restoration ran on the FALLEN character at 0 / 575 and kept its zero: 0 / 500 (life_changed [0 / 500 FALLEN], still FALLEN); then the core loop's two revivals: [500 / 500 IDLE, 500 / 500 IDLE]
3 physics frames after the lethal hit: FALLEN, no overlay; F5 then: the overlay closed once, exactly one run ended (the plan advanced once)
Rift level 1, 0 experience, an empty build; Life 500 / 500, +0% Maximum Life over 500, the Worn Blade, no receipt, no offer, no overlay; the Teaching Hall's Graveblade at full Life
roguelite — 0 / 575, real left click: 5 Hits, 5 took_damage, 5 life_changed, 1 fell
6 of 6 refused it
7 of 7: raw 125 and final 125 from the Graveblade that struck
Gate 1D, three times: Fallen / Killed by / Graveblade — Melee Hit — 125 Physical Damage / Life ran 125 → 0 of 500. No Armour, Evasion, Block, Resistance, or Mana Guard exists yet to reduce it. / Restart Broken Watch / F5 also restarts.
"Life ran 125 → 0 of 575. No Armour, Evasion, Block, Resistance, or Mana Guard exists yet to reduce it." at 575
every one focused on its button, that button's glyph the live input family's, and faded in to 1.00
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
step "5. Every protected file is byte-identical, and the owner's files are untouched"

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
	printf 'FALLEN MODAL LIFE STATE SMOKE CHECKS: PASS\n'
	printf '  %s checks; %s of %s owed; headless; %s protected files byte-identical\n' \
		"$EXPECTED_CHECKS" "$EXPECTED_OWED_CHECKS" "$EXPECTED_OWED_CHECKS" "${#PRESERVED_FILES[@]}"
	printf '  First-MVP UI J2 — Fallen-State Preservation Across Modal Neutralization V1 is DELIVERED\n'
	printf '  under D-324 and ACCEPTED and CLOSED at the shared player Fallen-state preservation during\n'
	printf '  modal and input-intent clearing mechanism level under D-325. D-223 remains OPEN.\n'
	reached_end=1
	exit 0
else
	printf 'FALLEN MODAL LIFE STATE SMOKE CHECKS: %d FAILURE(S)\n' "$failures"
	reached_end=1
	exit 1
fi
