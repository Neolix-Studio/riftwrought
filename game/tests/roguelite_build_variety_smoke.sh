#!/usr/bin/env bash
# Riftwrought — Roguelite Build Variety V1 smoke checks (decision D-223).
#
# THIS IS NOT A GATE, AND IT DELIBERATELY DOES NOT RUN THE LOCKED CHAIN.
#
# The review is one ISOLATED, non-canonical playtest instrument built ON TOP of
# the accepted Roguelite Core Loop Review (D-220/D-221) and the Roguelite
# Replayability V1 review (D-222). Every file it adds lives under
# `scripts/roguelite/build_variety/`, `scenes/roguelite/` and `tests/`; it edits
# no existing file, adds no room, adds no enemy, adds no asset, adds no `.tres`
# record, adds no InputMap action, writes nothing to disk, and is not the
# project entrypoint. Rerunning Gates A-F, 1A, 1B, 1C, 1D, 1E and the Zone
# Composer to check a greybox upgrade-combination review would be verification
# theatre over work this scene cannot possibly have broken — the same reasoning
# `roguelite_core_loop_smoke.sh` and `roguelite_replayability_smoke.sh` each
# state for themselves.
#
# What it DOES run, because they are the two things this review genuinely could
# break, are BOTH ACCEPTED REVIEWS' OWN VERIFICATIONS. "Preserve the existing
# reviews as working baselines" is the first thing the brief asked for, and a
# promise nothing measures is a hope.
#
# What this script proves:
#
#   1. every new script parses, and the scene boots with zero SCRIPT ERROR;
#   2. the pinned verification passes, proved in BOTH directions against a
#      replay of its own log, with every owed check reaching its last line;
#   3. the ACCEPTED core loop still passes at its pinned 626 checks AND the
#      ACCEPTED replayability review at its pinned 973, and every one of their
#      files is byte-identical;
#   4. `project.godot` is byte-identical — the same 31 actions, the same
#      entrypoint, the same nine sections, no `[autoload]`, and no mention of
#      this review;
#   5. the third-party inventory has not moved (185 payloads + 2 = 187): the
#      review extracts nothing;
#   6. 78 protected files are BYTE-IDENTICAL before and after — both accepted
#      roguelite reviews, Broken Watch, Riftfall Landing and its greybox and
#      visual review, the canonical opening, the combat kernel, the accepted
#      `.tres` records, and the project owner's own composed zone;
#   7. the project owner's own `user://` files are untouched;
#   8. optionally, rendered evidence (`--shots <dir>`) — FOUR frames, at
#      1920x1080 and at the 1280x720 minimum tested window.
#
# Usage, from the repository root:
#   game/tests/roguelite_build_variety_smoke.sh
#   game/tests/roguelite_build_variety_smoke.sh --shots docs/testing/roguelite_build_variety_evidence

set -uo pipefail

# Assigned at the TOP of the script, never beside the function it serves: a
# shell evaluates an assignment only when execution REACHES it, and Gate 1E's
# first staleness guard failed every read for exactly that reason.
RUN_STARTED_AT="$(date +%s)"

# A SCRIPT THAT DIES HALFWAY MUST NOT REPORT SUCCESS, AND THIS GUARD EXISTS
# BECAUSE A REVIEW OF THIS RUNNER FOUND EXACTLY THAT HOLE. Under `set -u` an
# unbound variable — a pin left as a placeholder, say — terminates the shell at
# that line; every step after it, including the two accepted reviews' own
# verifications and the after-run fingerprint comparison, silently never runs,
# and a caller reading `$?` can see a pass. `reached_end` is set to 1 by exactly
# one line, immediately before the final verdict, so the only way out that
# reports success is the one that ran the whole script.
reached_end=0
scratch_replay=""
on_exit() {
	local status=$?
	[[ -n "$scratch_replay" ]] && rm -f "$scratch_replay"
	if [[ "$reached_end" != "1" ]]; then
		printf '\nROGUELITE BUILD VARIETY SMOKE CHECKS: ABORTED before the end of the script\n'
		printf '  the run stopped early (exit %s) — nothing after that point was proved\n' "$status"
		exit 1
	fi
	exit "$status"
}
trap on_exit EXIT


GODOT="${GODOT:-/Applications/Godot.app/Contents/MacOS/Godot}"
EXPECTED_VERSION="4.7.2.stable"
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

SCENE="res://scenes/roguelite/roguelite_build_variety_review.tscn"
ACCEPTED_LOOP_SCENE="res://scenes/roguelite/roguelite_core_loop.tscn"
ACCEPTED_REPLAY_SCENE="res://scenes/roguelite/roguelite_replayability_review.tscn"

# Pinned, and proved in both directions below.
#
# ONE number, not two, and the difference from the accepted reviews is
# deliberate rather than an oversight. Those carry 626 / 631 and 973 / 978
# because their evidence passes drive extra kills through a `_kill()` that
# COUNTS its assertions. This suite's evidence pass drives its extra swings
# through helpers that report with `_expect_quiet()` — a real failure is still
# reported, but the pinned total cannot drift with the number of frames the
# evidence pass happens to take. So the rendered run must reach exactly the same
# count as the headless one, which is a slightly stronger statement.
EXPECTED_CHECKS=481
EXPECTED_CHECKS_RENDERED=481

# The number of check FUNCTIONS the suite owes, separate from the number of
# assertions. Pinned as a variable rather than written into the grep, because
# hard-coding it into the pattern goes stale the moment a check is added —
# reporting a failure whose text is the correct answer.
EXPECTED_OWED_CHECKS=24

# The two accepted baselines this review extends. Each has its own runner that
# pins these too; they are repeated here because "the existing reviews remain
# behaviourally intact" is the first thing the brief asked for.
EXPECTED_ACCEPTED_LOOP_CHECKS=626
EXPECTED_ACCEPTED_REPLAY_CHECKS=973

EXPECTED_INPUT_ACTIONS=31
EXPECTED_MAIN_SCENE="res://scenes/app/prototype_app.tscn"
EXPECTED_SECTIONS="application audio debug display editor_plugins input layer_names navigation rendering"

# The review extracts nothing. These are D-216's authorized numbers, unmoved.
EXPECTED_THIRD_PARTY_PAYLOADS=185
EXPECTED_THIRD_PARTY=187

# Every new file the review owns. Each must parse; none may name a storage path.
NEW_SCRIPTS=(
	"scripts/roguelite/build_variety/roguelite_upgrade.gd"
	"scripts/roguelite/build_variety/roguelite_build_state.gd"
	"scripts/roguelite/build_variety/roguelite_build_variety_run_plan.gd"
	"scripts/roguelite/build_variety/roguelite_strike_envelope.gd"
	"scripts/roguelite/build_variety/roguelite_upgrade_choice_panel.gd"
	"scripts/roguelite/build_variety/roguelite_build_variety_hud.gd"
	"scripts/roguelite/build_variety/roguelite_build_variety_summary_panel.gd"
	"scripts/roguelite/build_variety/roguelite_build_variety_runtime.gd"
	"tests/roguelite_build_variety_verification.gd"
)

# Every file this review must not disturb, fingerprinted before and after. The
# list is the accepted D-222 review's own 67 PLUS the eleven files of the
# accepted D-222 review itself, because "preserve the existing reviews as
# working baselines" is the first thing this review was asked for.
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
	"tests/roguelite_core_loop_smoke.sh"
	"tests/roguelite_core_loop_verification.gd"
	"scripts/roguelite/replayability/roguelite_room_library.gd"
	"scripts/roguelite/replayability/roguelite_variant_room_module.gd"
	"scripts/roguelite/replayability/roguelite_seeded_run_plan.gd"
	"scripts/roguelite/replayability/roguelite_run_boon.gd"
	"scripts/roguelite/replayability/roguelite_boon_choice_panel.gd"
	"scripts/roguelite/replayability/roguelite_replayability_hud.gd"
	"scripts/roguelite/replayability/roguelite_replayability_summary_panel.gd"
	"scripts/roguelite/replayability/roguelite_replayability_runtime.gd"
	"scenes/roguelite/roguelite_replayability_review.tscn"
	"tests/roguelite_replayability_smoke.sh"
	"tests/roguelite_replayability_verification.gd"
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

# A malformed format string is not a SCRIPT ERROR and would scroll past the
# guard above. This review's own first verification run printed two of them.
assert_no_format_error() {
	local what="$1" logfile="$2" found
	found="$(grep -c "String formatting error" "$logfile" 2>/dev/null | tr -d ' ')"
	if [[ "$found" == "0" ]]; then
		pass "$what produced no string-formatting error"
	else
		fail "$what produced $found string-formatting error(s)"
		grep -A2 "String formatting error" "$logfile" | head -12 | sed 's/^/        /'
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
# would read the "1" out of a label like "V1" and refuse every run.
read_check_count() {
	grep -ohE "$1: PASS \([0-9]+ checks\)" "$2" \
		| grep -ohE '[0-9]+ checks' | grep -ohE '[0-9]+' | head -1
}

printf 'Riftwrought — Roguelite Build Variety V1 smoke checks (D-223)\n'
printf 'project: %s\n' "$PROJECT_DIR"

# --------------------------------------------------------------------------
step "0. Engine, and a fingerprint of everything this review must not disturb"

installed="$("$GODOT" --version 2>/dev/null | tail -1)"
printf '  installed: %s\n' "$installed"
if [[ "$installed" == "$EXPECTED_VERSION"* ]]; then
	pass "matches the locked $EXPECTED_VERSION baseline"
else
	fail "expected $EXPECTED_VERSION, found $installed"
	printf '\nROGUELITE REPLAYABILITY SMOKE CHECKS: FAIL (wrong engine)\n'
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
	pass "${#PRESERVED_FILES[@]} protected file(s) fingerprinted, including BOTH accepted roguelite reviews"
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
	log="/tmp/riftwrought_build_variety_parse_$name.log"
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
# asset list.
#
# The STORAGE scan is COMMENT-STRIPPED, because "this review writes nothing" is
# a claim a file should be allowed to make in prose. A raw scan would fail on
# the sentence that makes the claim — the Gate 1C defect where a scope guard
# fired on the words "THIS IS NOT RIFTFALL LANDING" in the very files whose
# scope it protected.
#
# The verification script is excluded from BOTH by construction: the line that
# forbids a fragment has to name it.
SHIPPING_FILES=(
	"scripts/roguelite/build_variety/roguelite_upgrade.gd"
	"scripts/roguelite/build_variety/roguelite_build_state.gd"
	"scripts/roguelite/build_variety/roguelite_build_variety_run_plan.gd"
	"scripts/roguelite/build_variety/roguelite_strike_envelope.gd"
	"scripts/roguelite/build_variety/roguelite_upgrade_choice_panel.gd"
	"scripts/roguelite/build_variety/roguelite_build_variety_hud.gd"
	"scripts/roguelite/build_variety/roguelite_build_variety_summary_panel.gd"
	"scripts/roguelite/build_variety/roguelite_build_variety_runtime.gd"
	"scenes/roguelite/roguelite_build_variety_review.tscn"
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

# THE REVIEW ADDS NO DATA RECORD AT ALL, and that is worth measuring rather
# than saying: all four upgrades reuse accepted records and accepted FIELDS —
# the Expedition Blade the core loop already ships, and the attack-speed, reach
# and release-arc fields the accepted Quick Strike kernel already owns.
tres_count="$(find "$PROJECT_DIR/data/roguelite" -name '*.tres' 2>/dev/null | wc -l | tr -d ' ')"
if [[ "$tres_count" == "3" ]]; then
	pass "data/roguelite still holds exactly the accepted 3 records — this review adds none"
else
	fail "data/roguelite holds $tres_count records, not the accepted 3"
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

boot_log="/tmp/riftwrought_build_variety_boot.log"
"$GODOT" --headless --path "$PROJECT_DIR" "$SCENE" --quit-after 240 > "$boot_log" 2>&1
assert_log_is_fresh "$boot_log"
assert_no_script_error "an ordinary headless boot of the review" "$boot_log"
if grep -q "roguelite build variety v1" "$boot_log"; then
	pass "the review assembled and said so"
else
	fail "the review did not report assembling"
fi
if grep -q "9 authored room(s) across 3 beat(s)" "$boot_log"; then
	pass "the ACCEPTED room library still reports three beats of three authored rooms"
else
	fail "the room library did not report its shape"
fi
if grep -q "4 temporary upgrade(s): Expedition Blade, Quickened Edge, Reaching Edge, Sweeping Edge" "$boot_log"; then
	pass "the pool reports its four upgrades by name"
else
	fail "the upgrade pool did not report its four upgrades"
	grep -E "upgrade pool" "$boot_log" | sed 's/^/        /'
fi
if grep -q "Quick Strike 100 Physical · 0.80 s · 1.65 m · 100° arc · 65° soft cone" "$boot_log"; then
	pass "an ordinary boot starts from the authored baseline in all four values"
else
	fail "the baseline line is missing or has moved"
	grep -E "baseline" "$boot_log" | sed 's/^/        /'
fi

# --------------------------------------------------------------------------
step "4. The pinned verification passes, proved in BOTH directions"

verify_log="/tmp/riftwrought_build_variety_verify.log"
"$GODOT" --headless --path "$PROJECT_DIR" "$SCENE" -- --verify-build > "$verify_log" 2>&1
verify_status=$?
assert_log_is_fresh "$verify_log"
assert_no_script_error "the headless build-variety verification" "$verify_log"
assert_no_format_error "the headless build-variety verification" "$verify_log"

if [[ "$verify_status" == "0" ]]; then
	pass "the verification exited 0"
else
	fail "the verification exited $verify_status"
	grep -E "^  FAIL" "$verify_log" | head -20 | sed 's/^/        /'
fi

count="$(read_check_count "ROGUELITE BUILD VARIETY VERIFICATION" "$verify_log")"
if [[ "$count" == "$EXPECTED_CHECKS" ]]; then
	pass "verification passes at the pinned $EXPECTED_CHECKS checks"
else
	fail "verification reports ${count:-no} checks, not $EXPECTED_CHECKS"
fi

# A guard that accepts everything protects nothing: the pin must refuse a log
# whose count moved by one.
replay="$(mktemp -t riftwrought_build_variety_replay)"
scratch_replay="$replay"
sed "s/ROGUELITE BUILD VARIETY VERIFICATION: PASS ($EXPECTED_CHECKS checks)/ROGUELITE BUILD VARIETY VERIFICATION: PASS ($((EXPECTED_CHECKS + 1)) checks)/" \
	"$verify_log" > "$replay"
if [[ "$(read_check_count "ROGUELITE BUILD VARIETY VERIFICATION" "$replay")" != "$EXPECTED_CHECKS" ]]; then
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

# The two documented seeds, read out of the run's own log rather than restated
# — both the ROUTE and the first OFFER, because this review's claim is about
# both.
if grep -q "99: Pillar Court → Cache Vault → Broad Hall | first offer Quickened Edge | Reaching Edge" "$verify_log" \
		&& grep -q "404: Dogleg → Crossing Cache → Pinch Hall | first offer Quickened Edge | Expedition Blade" "$verify_log"; then
	pass "the two documented seeds produced their documented routes AND their documented first offers"
else
	fail "the documented seed routes/offers are not in the verification log"
	grep -E "^  (99|404): " "$verify_log" | sed 's/^/        /'
fi

# The four upgrades are proved to move real properties, and the log says so in
# numbers rather than in adjectives.
for measured in \
		"2.20 m: MISS at 1.65 m reach, HIT at 2.65 m" \
		"70° off axis: MISS at 100° arc, HIT at 180°" \
		"2.20 m at 70° off axis: missed with neither and with each alone, hit with both" \
		"100 → 150 Physical; 3 Hits → 2 against 300 Life"; do
	if grep -qF "$measured" "$verify_log"; then
		pass "measured: $measured"
	else
		fail "the verification did not report: $measured"
	fi
done

# --------------------------------------------------------------------------
step "5. BOTH accepted reviews still pass at their own pinned counts"

# The two dependencies this review genuinely could have broken, and the first
# thing the brief asked for: "preserve the existing reviews as working
# baselines". These are focused tests on direct dependencies, not a chain rerun.
accepted_log="/tmp/riftwrought_build_variety_accepted_loop.log"
"$GODOT" --headless --path "$PROJECT_DIR" "$ACCEPTED_LOOP_SCENE" -- --verify-loop > "$accepted_log" 2>&1
accepted_status=$?
assert_log_is_fresh "$accepted_log"
assert_no_script_error "the accepted core loop's own verification" "$accepted_log"
accepted_count="$(read_check_count "ROGUELITE CORE LOOP VERIFICATION" "$accepted_log")"
if [[ "$accepted_status" == "0" && "$accepted_count" == "$EXPECTED_ACCEPTED_LOOP_CHECKS" ]]; then
	pass "the accepted core loop still passes at $EXPECTED_ACCEPTED_LOOP_CHECKS checks, unchanged"
else
	fail "the accepted core loop reports ${accepted_count:-no} checks (exit $accepted_status), not $EXPECTED_ACCEPTED_LOOP_CHECKS"
	grep -E "^  FAIL" "$accepted_log" | head -10 | sed 's/^/        /'
fi

replay_log="/tmp/riftwrought_build_variety_accepted_replay.log"
"$GODOT" --headless --path "$PROJECT_DIR" "$ACCEPTED_REPLAY_SCENE" -- --verify-replay > "$replay_log" 2>&1
replay_status=$?
assert_log_is_fresh "$replay_log"
assert_no_script_error "the accepted replayability review's own verification" "$replay_log"
replay_count="$(read_check_count "ROGUELITE REPLAYABILITY VERIFICATION" "$replay_log")"
if [[ "$replay_status" == "0" && "$replay_count" == "$EXPECTED_ACCEPTED_REPLAY_CHECKS" ]]; then
	pass "the accepted replayability review still passes at $EXPECTED_ACCEPTED_REPLAY_CHECKS checks, unchanged"
else
	fail "the accepted replayability review reports ${replay_count:-no} checks (exit $replay_status), not $EXPECTED_ACCEPTED_REPLAY_CHECKS"
	grep -E "^  FAIL" "$replay_log" | head -10 | sed 's/^/        /'
fi

# BEHAVIOURALLY INTACT, NOT MERELY UNEDITED — and asserted with a row that can
# actually FAIL. The first draft of this check passed in both branches, which is
# the project's own recorded lesson that a row that cannot fail is not a
# boundary. What is asserted instead is each accepted suite's OWED-SET line:
# every check function it owes reached its last line, so neither suite passed by
# quietly not running.
if grep -qE "^  29 of 29 owed checks completed" "$replay_log"; then
	pass "the accepted replayability suite completed all 29 of its own owed checks"
else
	fail "the accepted replayability suite did not complete its own owed checks"
	grep -E "owed checks" "$replay_log" | sed 's/^/        /'
fi
if grep -qE "^  20 of 20 owed checks completed" "$accepted_log"; then
	pass "the accepted core loop suite completed all 20 of its own owed checks"
else
	fail "the accepted core loop suite did not complete its own owed checks"
	grep -E "owed checks" "$accepted_log" | sed 's/^/        /'
fi

# --------------------------------------------------------------------------
step "6. project.godot is untouched"

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

if grep -qi "build_variety\|build variety" "$project_godot"; then
	fail "project.godot names the build-variety review — it must own no project setting"
else
	pass "project.godot names nothing about this review"
fi

# --------------------------------------------------------------------------
step "7. The third-party inventory has not moved — the review extracts nothing"

# The arithmetic five closed runners already use, reproduced exactly: payload
# files, plus the TWO D-202 source maps counted BY NAME. A generic
# `-name SOURCE_AND_LICENSE.md` finds five and would report 190 against an
# authorized 187 — a check that computes its own different number is not the
# same check.
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
step "8. Rendered evidence"

if [[ -n "$SHOT_DIR" ]]; then
	shots_log="/tmp/riftwrought_build_variety_shots.log"
	"$GODOT" --path "$PROJECT_DIR" --resolution 1920x1080 "$SCENE" \
		-- --verify-build --shots "$SHOT_DIR" > "$shots_log" 2>&1
	assert_no_script_error "the rendered evidence run" "$shots_log"
	assert_no_format_error "the rendered evidence run" "$shots_log"
	rendered_count="$(read_check_count "ROGUELITE BUILD VARIETY VERIFICATION" "$shots_log")"
	if [[ "$rendered_count" == "$EXPECTED_CHECKS_RENDERED" ]]; then
		pass "the rendered run passes at the pinned $EXPECTED_CHECKS_RENDERED checks ($EXPECTED_CHECKS plus the evidence pass)"
	else
		fail "the rendered run reports ${rendered_count:-no} checks, not $EXPECTED_CHECKS_RENDERED"
		grep -E "^  FAIL" "$shots_log" | head -10 | sed 's/^/        /'
	fi
	shots=0
	for stem in 01_first_choice 02_two_upgrades_and_the_swing_outline \
			03_elite_room_with_the_build 04_run_summary; do
		if [[ -f "$SHOT_DIR/$stem.png" ]]; then
			shots=$((shots + 1))
		else
			fail "$stem.png was not captured"
		fi
	done
	if [[ "$shots" == "4" ]]; then
		pass "all 4 evidence frames captured into $SHOT_DIR"
	fi

	# AND AT 1280x720, THE MINIMUM TESTED WINDOW. Gate F found two real layout
	# faults — a clipped HUD column and buttons below the screen — that were
	# invisible at the 1920x1080 reference and only appeared at this size. The
	# upgrade choice panel is the biggest new surface in this review — five rows
	# per option instead of the accepted review's three — and its own rectangle
	# is measured rather than assumed.
	small_log="/tmp/riftwrought_build_variety_shots_720.log"
	mkdir -p "$SHOT_DIR/1280x720"
	"$GODOT" --path "$PROJECT_DIR" --resolution 1280x720 "$SCENE" \
		-- --verify-build --shots "$SHOT_DIR/1280x720" > "$small_log" 2>&1
	assert_no_script_error "the 1280x720 evidence run" "$small_log"
	small_count="$(read_check_count "ROGUELITE BUILD VARIETY VERIFICATION" "$small_log")"
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
step "9. Every protected file is byte-identical, and the owner's files are untouched"

changed=0
for i in "${!PRESERVED_FILES[@]}"; do
	after="$(fingerprint "$PROJECT_DIR/${PRESERVED_FILES[$i]}")"
	if [[ "$after" != "${BEFORE_HASHES[$i]}" ]]; then
		fail "${PRESERVED_FILES[$i]} CHANGED during this run"
		changed=$((changed + 1))
	fi
done
if [[ "$changed" == "0" && "$missing_preserved" == "0" ]]; then
	pass "all ${#PRESERVED_FILES[@]} protected files are byte-identical, BOTH accepted roguelite reviews included"
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
# THE ONE LINE THAT SETS IT. Everything above has run.
reached_end=1

printf '\n'
if [[ "$failures" == "0" ]]; then
	printf 'ROGUELITE BUILD VARIETY SMOKE CHECKS: PASS\n'
	cat <<'NOTE'

  Automated success is NOT acceptance. This script cannot answer the question
  the review exists to ask — do temporary upgrade COMBINATIONS create
  meaningfully different play styles? — and it is not trying to. Only the
  project owner can answer that, by playing seed 99 and seed 404.

  It is DELIVERED and OPEN under D-223. Stop here for owner playtesting before
  adding more upgrades, more rooms, or any permanent progression.
NOTE
	exit 0
else
	printf 'ROGUELITE BUILD VARIETY SMOKE CHECKS: FAIL (%d failure(s))\n' "$failures"
	exit 1
fi
