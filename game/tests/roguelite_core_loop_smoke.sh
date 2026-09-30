#!/usr/bin/env bash
# Riftwrought — Roguelite Core Loop Review smoke checks (decision D-220).
#
# THIS IS NOT A GATE, AND IT DELIBERATELY DOES NOT RUN THE LOCKED CHAIN.
#
# The review is one ISOLATED, non-canonical playtest instrument. Every file it
# adds lives under `scripts/roguelite/`, `scenes/roguelite/`, `data/roguelite/`
# and `tests/`; it edits no existing file, adds no asset, adds no InputMap
# action, writes nothing to disk, and is not the project entrypoint. Rerunning
# Gates A-F, 1A, 1B, 1C, 1D, 1E and the Zone Composer to check a greybox loop
# would be verification theatre over work this scene cannot possibly have
# broken — the same reasoning `riftfall_landing_greybox_smoke.sh` states for
# itself. What this script proves is exactly what the review CAN break:
#
#   1. every new script parses, and the scene boots with zero SCRIPT ERROR;
#   2. the pinned verification passes, proved in BOTH directions against a
#      replay of its own log;
#   3. `project.godot` is byte-identical — the same 31 actions, the same
#      entrypoint, the same nine sections, no `[autoload]`, and no mention of
#      this review;
#   4. the third-party inventory has not moved (185 payloads + 2 = 187): the
#      review extracts nothing;
#   5. every file the pivot says must not be disturbed is BYTE-IDENTICAL
#      before and after — Broken Watch, Riftfall Landing and its greybox and
#      visual review, the canonical opening, the combat kernel, the accepted
#      `.tres` records, Gate 1D's own suite, and the project owner's own
#      composed zone;
#   6. the project owner's own `user://` files are untouched;
#   7. optionally, rendered evidence (`--shots <dir>`), at 1920x1080 and at
#      the 1280x720 minimum tested window.
#
# Usage, from the repository root:
#   game/tests/roguelite_core_loop_smoke.sh
#   game/tests/roguelite_core_loop_smoke.sh --shots docs/testing/roguelite_core_loop_evidence

set -uo pipefail

# Assigned at the TOP of the script, never beside the function it serves: a
# shell evaluates an assignment only when execution REACHES it, and Gate 1E's
# first staleness guard failed every read for exactly that reason.
RUN_STARTED_AT="$(date +%s)"

GODOT="${GODOT:-/Applications/Godot.app/Contents/MacOS/Godot}"
EXPECTED_VERSION="4.7.2.stable"
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

SCENE="res://scenes/roguelite/roguelite_core_loop.tscn"

# Pinned, and proved in both directions below. TWO numbers, because the
# rendered evidence pass kills five more enemies through `_kill()`, which
# asserts that each actually died — 612 + 5 = 617. Gate 1C carries 200 and 203
# for the same reason.
EXPECTED_CHECKS=626
EXPECTED_CHECKS_RENDERED=631

# The number of check FUNCTIONS the suite owes, separate from the number of
# assertions. Pinned as a variable rather than written into the grep, because
# the first version hard-coded "19 of 19" into the pattern and went stale the
# moment a check was added — reporting a failure whose text was the correct
# answer.
EXPECTED_OWED_CHECKS=20

EXPECTED_INPUT_ACTIONS=31
EXPECTED_MAIN_SCENE="res://scenes/app/prototype_app.tscn"
EXPECTED_SECTIONS="application audio debug display editor_plugins input layer_names navigation rendering"

# The review extracts nothing. These are D-216's authorized numbers, unmoved.
EXPECTED_THIRD_PARTY_PAYLOADS=185
EXPECTED_THIRD_PARTY=187

# Every new file the review owns. Each must parse; none may name a storage path.
NEW_SCRIPTS=(
	"scripts/roguelite/roguelite_room_module.gd"
	"scripts/roguelite/roguelite_run_plan.gd"
	"scripts/roguelite/roguelite_run_state.gd"
	"scripts/roguelite/roguelite_core_loop_runtime.gd"
	"scripts/roguelite/roguelite_run_hud.gd"
	"scripts/roguelite/roguelite_fallen_overlay.gd"
	"scripts/roguelite/roguelite_run_summary_panel.gd"
	"tests/roguelite_core_loop_verification.gd"
)

# Every file the pivot instruction says must not be disturbed, fingerprinted
# before and after. The list is deliberately long: "no changes to Riftfall
# Landing, its visual review, canonical gate scenes, or project entrypoint" is
# a promise, and a promise nothing measures is a hope.
PRESERVED_FILES=(
	"project.godot"
	"scripts/first_mvp/severed_threshold/broken_watch_slice.gd"
	"scripts/first_mvp/severed_threshold/broken_watch_layout.gd"
	"scenes/first_mvp/severed_threshold/broken_watch_slice.tscn"
	"scripts/first_mvp/severed_threshold/riftfall_landing.gd"
	"scripts/first_mvp/severed_threshold/riftfall_landing_layout.gd"
	"scenes/first_mvp/severed_threshold/riftfall_landing.tscn"
	"scenes/first_mvp/severed_threshold/riftfall_landing_review.tscn"
	"scripts/first_mvp/greybox/riftfall_landing_greybox_layout.gd"
	"scenes/first_mvp/greybox/riftfall_landing_greybox_review.tscn"
	"scripts/first_mvp/visual_review/riftfall_landing_visual_review.gd"
	"scripts/first_mvp/visual_review/riftfall_landing_visual_review_dressing.gd"
	"scenes/first_mvp/visual_review/riftfall_landing_visual_review.tscn"
	"scripts/first_mvp/canonical_opening/canonical_opening_runtime.gd"
	"scenes/first_mvp/canonical_opening/canonical_opening.tscn"
	"scripts/actors/prototype_player.gd"
	"scripts/actors/prototype_graveblade.gd"
	"scenes/actors/prototype_player.tscn"
	"scenes/actors/prototype_graveblade.tscn"
	"scripts/combat/quick_strike_action.gd"
	"scripts/combat/attack_coordinator.gd"
	"scripts/combat/target_acquisition.gd"
	"scripts/combat/damage_event.gd"
	"scripts/camera/prototype_camera_rig.gd"
	"scripts/movement/prototype_locomotion.gd"
	"scripts/movement/prototype_ground_pointer.gd"
	"scripts/movement/prototype_mouse_hold.gd"
	"scripts/prototype_zero/destination_marker.gd"
	"scripts/input/input_family_tracker.gd"
	"scripts/combat/prototype_targetable.gd"
	"scripts/combat/prototype_weapon_data.gd"
	"scripts/combat/graveblade_data.gd"
	"scripts/combat/quick_strike_data.gd"
	"scripts/actors/graveblade_target_area.gd"
	"scripts/items/player_loadout.gd"
	"scripts/items/first_mvp_item_drop.gd"
	"scripts/ui/first_mvp_modal.gd"
	"scripts/ui/first_mvp_combat_hud.gd"
	"scripts/ui/first_mvp_item_comparison.gd"
	"scripts/ui/first_mvp_fallen_overlay.gd"
	"data/prototype_zero/quick_strike.tres"
	"data/prototype_zero/graveblade.tres"
	"data/prototype_zero/starter_sword.tres"
	"data/prototype_zero/honed_sword.tres"
	"data/prototype_zero/progression.tres"
	"data/first_mvp/severed_threshold/broken_watch/starting_sword.tres"
	"data/first_mvp/severed_threshold/broken_watch/watchsteel_sword.tres"
	"scenes/first_mvp/zone_composer_practice.tscn"
	"tests/gate_1d_broken_watch_smoke.sh"
	"tests/gate_1d_broken_watch_verification.gd"
	"tests/gate_1e_canonical_opening_smoke.sh"
	"tests/riftfall_landing_greybox_smoke.sh"
	"tests/riftfall_landing_visual_review_smoke.sh"
	"tests/zone_composer_smoke.sh"
)

SHOT_DIR=""
if [[ "${1:-}" == "--shots" && -n "${2:-}" ]]; then
	mkdir -p "$2"
	SHOT_DIR="$(cd "$2" && pwd)"
fi

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

# D-201's lesson, kept alive in every runner since: a run that reports PASS
# while a script error scrolled past is not a pass.
assert_no_script_error() {
	local what="$1" logfile="$2" found
	found="$(grep -c "SCRIPT ERROR" "$logfile" 2>/dev/null | tr -d ' ')"
	if [[ "$found" == "0" ]]; then
		pass "$what produced no SCRIPT ERROR"
	else
		fail "$what produced $found SCRIPT ERROR line(s)"
		grep -A3 "SCRIPT ERROR" "$logfile" | head -20 | sed 's/^/        /'
	fi
}

# `/tmp` is never cleared between runs, so a log written by an earlier —
# possibly interrupted — invocation can answer for this one. Gate 1E found
# exactly that defect in two closed runners.
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

# The three-step read the project settled on. A single `grep -ohE '[0-9]+'`
# would read the "1" out of a label like "1D" and refuse every run.
read_check_count() {
	grep -ohE "$1: PASS \([0-9]+ checks\)" "$2" \
		| grep -ohE '[0-9]+ checks' | grep -ohE '[0-9]+' | head -1
}

printf 'Riftwrought — Roguelite Core Loop Review smoke checks (D-220)\n'
printf 'project: %s\n' "$PROJECT_DIR"

# --------------------------------------------------------------------------
step "0. Engine, and a fingerprint of everything this review must not disturb"

installed="$("$GODOT" --version 2>/dev/null | tail -1)"
printf '  installed: %s\n' "$installed"
if [[ "$installed" == "$EXPECTED_VERSION"* ]]; then
	pass "matches the locked $EXPECTED_VERSION baseline"
else
	fail "expected $EXPECTED_VERSION, found $installed"
	printf '\nROGUELITE CORE LOOP SMOKE CHECKS: FAIL (wrong engine)\n'
	exit 1
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
step "1. Every new script parses"

for relative in "${NEW_SCRIPTS[@]}"; do
	name="$(basename "$relative")"
	log="/tmp/riftwrought_roguelite_parse_$name.log"
	"$GODOT" --headless --path "$PROJECT_DIR" --check-only --script "res://$relative" > "$log" 2>&1
	if grep -qE "Parse Error|Compile Error|Failed to load script" "$log"; then
		fail "$name does not parse"
		grep -E "Parse Error|Compile Error" "$log" | head -3 | sed 's/^/        /'
	else
		pass "$name parses"
	fi
done

# --------------------------------------------------------------------------
step "2. The review names no asset, shader, particle or sound; and writes nothing"

# TWO SCANS, WITH DIFFERENT RULES, AND THE DIFFERENCE IS DELIBERATE.
#
# The ASSET scan is RAW, comments included — D-215's sharpest lesson is that an
# illustrative asset path in a comment breaches the rule exactly as surely as a
# real one, because the rule exists so a reader can trust the file holds no
# asset list. The shipping files therefore avoid these words entirely rather
# than relying on a comment-stripped scan, which is the same discipline
# `riftfall_landing_greybox_verification.gd` states for itself.
#
# The STORAGE scan is COMMENT-STRIPPED, because "this review writes nothing" is
# a claim a file should be allowed to make in prose. A raw scan here would fail
# on the sentence that makes the claim — precisely the Gate 1C defect where a
# scope guard fired on the words "THIS IS NOT RIFTFALL LANDING" in the very
# files whose scope it protected.
#
# The verification script is excluded from BOTH by construction: the line that
# forbids a fragment has to name it, which is the same reason Gate 1E had to
# narrow its own UID scan after it matched the runner looking for the UID.
SHIPPING_FILES=(
	"scripts/roguelite/roguelite_room_module.gd"
	"scripts/roguelite/roguelite_run_plan.gd"
	"scripts/roguelite/roguelite_run_state.gd"
	"scripts/roguelite/roguelite_core_loop_runtime.gd"
	"scripts/roguelite/roguelite_run_hud.gd"
	"scripts/roguelite/roguelite_fallen_overlay.gd"
	"scripts/roguelite/roguelite_run_summary_panel.gd"
	"scenes/roguelite/roguelite_core_loop.tscn"
	"data/roguelite/worn_blade.tres"
	"data/roguelite/expedition_blade.tres"
	"data/roguelite/graveblade_elite.tres"
)

asset_fragments='res://assets/|\.gltf|\.glb|\.png|\.import|kaykit|kenney|k0rveen|quaternius|lelu|GPUParticles|CPUParticles|ShaderMaterial|\.gdshader|AudioStream'
hits=0
for relative in "${SHIPPING_FILES[@]}"; do
	if grep -qE "$asset_fragments" "$PROJECT_DIR/$relative"; then
		fail "$relative names an asset, shader, particle or sound fragment"
		grep -inE "$asset_fragments" "$PROJECT_DIR/$relative" | head -3 | sed 's/^/        /'
		hits=$((hits + 1))
	fi
done
if [[ "$hits" == "0" ]]; then
	pass "raw scan of ${#SHIPPING_FILES[@]} shipping file(s), comments included: no asset, shader, particle or sound"
fi

storage_fragments='user://|ConfigFile|ResourceSaver|FileAccess\.open|store_string|PrototypeSettings|PrototypeLabState|CharacterSave'
storage_hits=0
for relative in "${SHIPPING_FILES[@]}"; do
	# Comment lines removed first, so the file may say in prose that it writes
	# nothing without failing the check that proves it.
	if sed -e 's/[[:space:]]*#.*$//' -e 's/^[[:space:]]*;.*$//' "$PROJECT_DIR/$relative" \
			| grep -qE "$storage_fragments"; then
		fail "$relative names a storage path or store in CODE"
		sed -e 's/[[:space:]]*#.*$//' "$PROJECT_DIR/$relative" | grep -nE "$storage_fragments" | head -3 | sed 's/^/        /'
		storage_hits=$((storage_hits + 1))
	fi
done
if [[ "$storage_hits" == "0" ]]; then
	pass "comment-stripped scan: no shipping file names a storage path, store or writer"
fi

# The Zone Composer's own guards, which reach any new file under scripts/,
# scenes/ or data/. Neither may ever match this review.
if grep -rqE 'ZoneComposer|addons/riftwrought_zone_composer' \
		"$PROJECT_DIR/scripts/roguelite" "$PROJECT_DIR/scenes/roguelite" "$PROJECT_DIR/data/roguelite" 2>/dev/null; then
	fail "a review file names the Zone Composer, which turns its closed suite red"
else
	pass "no review file names the Zone Composer"
fi
zc_named="$(find "$PROJECT_DIR/scripts/roguelite" "$PROJECT_DIR/scenes/roguelite" "$PROJECT_DIR/data/roguelite" \
	\( -name '*.gd' -o -name '*.cfg' \) -iname '*zone_composer*' 2>/dev/null | wc -l | tr -d ' ')"
if [[ "$zc_named" == "0" ]]; then
	pass "no review filename matches the Zone Composer stray-file scan"
else
	fail "$zc_named review file(s) would match the Zone Composer stray-file scan"
fi

# --------------------------------------------------------------------------
step "3. The scene boots headless with zero SCRIPT ERROR"

boot_log="/tmp/riftwrought_roguelite_boot.log"
"$GODOT" --headless --path "$PROJECT_DIR" "$SCENE" --quit-after 240 > "$boot_log" 2>&1
assert_log_is_fresh "$boot_log"
assert_no_script_error "an ordinary headless boot of the review" "$boot_log"
if grep -q "roguelite core loop" "$boot_log"; then
	pass "the review assembled and said so"
else
	fail "the review did not report assembling"
fi

# --------------------------------------------------------------------------
step "4. The pinned verification passes, proved in BOTH directions"

verify_log="/tmp/riftwrought_roguelite_verify.log"
"$GODOT" --headless --path "$PROJECT_DIR" "$SCENE" -- --verify-loop > "$verify_log" 2>&1
verify_status=$?
assert_log_is_fresh "$verify_log"
assert_no_script_error "the headless roguelite verification" "$verify_log"

if [[ "$verify_status" == "0" ]]; then
	pass "the verification exited 0"
else
	fail "the verification exited $verify_status"
	grep -E "^  FAIL" "$verify_log" | head -20 | sed 's/^/        /'
fi

count="$(read_check_count "ROGUELITE CORE LOOP VERIFICATION" "$verify_log")"
if [[ "$count" == "$EXPECTED_CHECKS" ]]; then
	pass "verification passes at the pinned $EXPECTED_CHECKS checks"
else
	fail "verification reports ${count:-no} checks, not $EXPECTED_CHECKS"
fi

# A guard that accepts everything protects nothing: the pin must refuse a log
# whose count moved by one.
replay="$(mktemp -t riftwrought_roguelite_replay)"
trap 'rm -f "$replay"' EXIT
sed "s/ROGUELITE CORE LOOP VERIFICATION: PASS ($EXPECTED_CHECKS checks)/ROGUELITE CORE LOOP VERIFICATION: PASS ($((EXPECTED_CHECKS + 1)) checks)/" \
	"$verify_log" > "$replay"
if [[ "$(read_check_count "ROGUELITE CORE LOOP VERIFICATION" "$replay")" != "$EXPECTED_CHECKS" ]]; then
	pass "and that pin refuses a log whose count moved by one"
else
	fail "the count pin accepts a wrong count and therefore proves nothing"
fi

# The owed-set line is the one that catches an un-awaited coroutine check.
if grep -qE "^  $EXPECTED_OWED_CHECKS of $EXPECTED_OWED_CHECKS owed checks completed" "$verify_log"; then
	pass "all $EXPECTED_OWED_CHECKS owed checks reached their last line"
else
	fail "the owed-set report is missing or short"
	grep -E "owed checks" "$verify_log" | sed 's/^/        /'
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

if grep -qi "roguelite" "$project_godot"; then
	fail "project.godot names the roguelite review — it must own no project setting"
else
	pass "project.godot names nothing about this review"
fi

# --------------------------------------------------------------------------
step "6. The third-party inventory has not moved — the review extracts nothing"

# The arithmetic is the one five closed runners already use, reproduced
# exactly: payload files, plus the TWO D-202 source maps counted BY NAME. A
# generic `-name SOURCE_AND_LICENSE.md` finds five (kaykit, kenney, quaternius,
# k0rveen, lelu) and would report 190 against an authorized 187 — a check that
# computes its own different number is not the same check.
payloads="$(find "$PROJECT_DIR/assets/third_party" -type f \
	! -name '*.import' ! -name '.DS_Store' ! -name '*.md' 2>/dev/null | wc -l | tr -d ' ')"
maps=0
for note in "$PROJECT_DIR/assets/third_party/kenney/SOURCE_AND_LICENSE.md" \
		"$PROJECT_DIR/assets/third_party/quaternius/SOURCE_AND_LICENSE.md"; do
	[[ -f "$note" ]] && maps=$((maps + 1))
done
total=$((payloads + maps))
printf '  arithmetic: %d payload(s) + %d source map(s) = %d\n' "$payloads" "$maps" "$total"
if [[ "$payloads" == "$EXPECTED_THIRD_PARTY_PAYLOADS" && "$total" == "$EXPECTED_THIRD_PARTY" ]]; then
	pass "still $EXPECTED_THIRD_PARTY_PAYLOADS + $maps = $EXPECTED_THIRD_PARTY, unchanged"
else
	fail "the third-party inventory is $payloads + $maps = $total, not $EXPECTED_THIRD_PARTY_PAYLOADS + 2 = $EXPECTED_THIRD_PARTY"
fi

# --------------------------------------------------------------------------
step "7. Rendered evidence"

if [[ -n "$SHOT_DIR" ]]; then
	shots_log="/tmp/riftwrought_roguelite_shots.log"
	"$GODOT" --path "$PROJECT_DIR" --resolution 1920x1080 "$SCENE" \
		-- --verify-loop --shots "$SHOT_DIR" > "$shots_log" 2>&1
	assert_no_script_error "the rendered evidence run" "$shots_log"
	rendered_count="$(read_check_count "ROGUELITE CORE LOOP VERIFICATION" "$shots_log")"
	if [[ "$rendered_count" == "$EXPECTED_CHECKS_RENDERED" ]]; then
		pass "the rendered run passes at the pinned $EXPECTED_CHECKS_RENDERED checks ($EXPECTED_CHECKS + 5 from the evidence pass)"
	else
		fail "the rendered run reports ${rendered_count:-no} checks, not $EXPECTED_CHECKS_RENDERED"
	fi
	shots=0
	for stem in 01_nexus_hub 02_teaching_hall 03_cache_room_reward 04_item_comparison \
			05_elite_hall 06_run_complete 07_all_four_modules; do
		if [[ -f "$SHOT_DIR/$stem.png" ]]; then
			shots=$((shots + 1))
		else
			fail "$stem.png was not captured"
		fi
	done
	if [[ "$shots" == "7" ]]; then
		pass "all 7 evidence frames captured into $SHOT_DIR"
	fi

	# AND AT 1280x720, THE MINIMUM TESTED WINDOW. Gate F found two real layout
	# faults — a clipped HUD column and buttons below the screen — that were
	# invisible at the 1920x1080 reference and only appeared at this size. The
	# header used to promise this pass without running it.
	small_log="/tmp/riftwrought_roguelite_shots_720.log"
	mkdir -p "$SHOT_DIR/1280x720"
	"$GODOT" --path "$PROJECT_DIR" --resolution 1280x720 "$SCENE" \
		-- --verify-loop --shots "$SHOT_DIR/1280x720" > "$small_log" 2>&1
	assert_no_script_error "the 1280x720 evidence run" "$small_log"
	small_count="$(read_check_count "ROGUELITE CORE LOOP VERIFICATION" "$small_log")"
	if [[ "$small_count" == "$EXPECTED_CHECKS_RENDERED" ]]; then
		pass "the 1280x720 run passes at the same $EXPECTED_CHECKS_RENDERED checks — no surface falls off the smaller window"
	else
		fail "the 1280x720 run reports ${small_count:-no} checks, not $EXPECTED_CHECKS_RENDERED"
		grep -E "^  FAIL" "$small_log" | head -10 | sed 's/^/        /'
	fi
else
	printf '  skipped (pass --shots <dir> to render evidence)\n'
fi

# --------------------------------------------------------------------------
step "8. Every protected file is byte-identical, and the owner's files are untouched"

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
	printf '    settings:  %s\n' "$settings_after"
	printf '    lab:       %s\n' "$lab_after"
	printf '    character: %s\n' "$character_after"
else
	fail "a file in the project owner's own user:// directory changed during this run"
fi

# --------------------------------------------------------------------------
printf '\n'
if [[ "$failures" == "0" ]]; then
	printf 'ROGUELITE CORE LOOP SMOKE CHECKS: PASS\n'
	cat <<'NOTE'

  Automated success is NOT acceptance, and it was not what closed this review.
  The project owner played it and answered the only question this script cannot
  — does the run feel like a run? — with "It feels like a run; we'll polish it
  as we go." The review is ACCEPTED and CLOSED under D-221.

  What this script still exists for is the other half: that the accepted loop
  keeps behaving, and that the review stays isolated. Acceptance relaxes none
  of its protections.
NOTE
	exit 0
else
	printf 'ROGUELITE CORE LOOP SMOKE CHECKS: FAIL (%d failure(s))\n' "$failures"
	exit 1
fi
