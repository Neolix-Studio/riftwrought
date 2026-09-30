#!/usr/bin/env bash
# Riftwrought — Riftfall Landing visual review smoke checks.
#
# THIS IS NOT A GATE AND IT DELIBERATELY DOES NOT RUN THE LOCKED CHAIN.
#
# The visual review is one ISOLATED, non-canonical candidate art pass over the
# project owner's accepted Greybox V2 layout. It touches no accepted value,
# adds no InputMap action, and shares no file with any closed gate, the Zone
# Composer, or the canonical Gate 1C scene, so rerunning Gates A-F, 1A, 1B and
# 1C would be verification theatre over work this scene cannot possibly have
# broken. What this script proves is exactly what this pass CAN break:
#
#   1. all three new scripts parse;
#   2. the scene boots headless with zero SCRIPT ERROR;
#   3. the headless verification passes at its pinned count, proved in BOTH
#      directions against a replay of its own log;
#   4. Greybox V2's own layout script, its review scaffolding, the canonical
#      Gate 1C scene, the Zone Composer, the shared presentation components
#      this pass reuses, and the project owner's own composed zone are all
#      BYTE-IDENTICAL before and after this run;
#   5. project.godot is untouched — same 31 actions, same entrypoint, no new
#      section;
#   6. exactly the two declared LeLu's Noise Pack files exist, byte-identical
#      to the archive, and no more;
#   7. optionally, rendered evidence screenshots (--shots <dir>).
#
# Usage, from the repository root:
#   game/tests/riftfall_landing_visual_review_smoke.sh
#   game/tests/riftfall_landing_visual_review_smoke.sh --shots docs/testing/riftfall_landing_visual_review_evidence

set -uo pipefail

GODOT="${GODOT:-/Applications/Godot.app/Contents/MacOS/Godot}"
EXPECTED_VERSION="4.7.2.stable"
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPO_DIR="$(cd "$PROJECT_DIR/.." && pwd)"

SCENE="res://scenes/first_mvp/visual_review/riftfall_landing_visual_review.tscn"

REVIEW_SCRIPT="$PROJECT_DIR/scripts/first_mvp/visual_review/riftfall_landing_visual_review.gd"
DRESSING_SCRIPT="$PROJECT_DIR/scripts/first_mvp/visual_review/riftfall_landing_visual_review_dressing.gd"
STONE_SCRIPT="$PROJECT_DIR/scripts/first_mvp/visual_review/riftfall_landing_visual_review_stone.gd"
VERIFICATION_SCRIPT="$PROJECT_DIR/tests/riftfall_landing_visual_review_verification.gd"

# Pinned, and proved in both directions below.
EXPECTED_CHECKS=139

EXPECTED_INPUT_ACTIONS=31
EXPECTED_MAIN_SCENE="res://scenes/app/prototype_app.tscn"

# Files this review must never touch, fingerprinted before and after: Greybox
# V2's own foundation (the accepted layout this pass is built on), the
# canonical Gate 1C scene, the Zone Composer and the owner's own composed
# zone, project.godot, and every shared presentation/measurement component
# this pass reuses UNCHANGED.
GREYBOX_LAYOUT_GD="$PROJECT_DIR/scripts/first_mvp/greybox/riftfall_landing_greybox_layout.gd"
GREYBOX_REVIEW_GD="$PROJECT_DIR/scripts/first_mvp/greybox/riftfall_landing_greybox_review.gd"
GREYBOX_SCENE="$PROJECT_DIR/scenes/first_mvp/greybox/riftfall_landing_greybox_review.tscn"
GREYBOX_VERIFICATION_GD="$PROJECT_DIR/tests/riftfall_landing_greybox_verification.gd"
CANONICAL_SCENE="$PROJECT_DIR/scenes/first_mvp/severed_threshold/riftfall_landing.tscn"
CANONICAL_REVIEW="$PROJECT_DIR/scenes/first_mvp/severed_threshold/riftfall_landing_review.tscn"
CANONICAL_LAYOUT_GD="$PROJECT_DIR/scripts/first_mvp/severed_threshold/riftfall_landing_layout.gd"
CANONICAL_LANDING_GD="$PROJECT_DIR/scripts/first_mvp/severed_threshold/riftfall_landing.gd"
LOOP_EVENT_GD="$PROJECT_DIR/scripts/first_mvp/severed_threshold/riftfall_loop_event.gd"
TREATMENT_GD="$PROJECT_DIR/scripts/first_mvp/visual/exterior_review_treatment.gd"
LIGHTING_GD="$PROJECT_DIR/scripts/first_mvp/visual/exterior_review_lighting.gd"
PROBE_GD="$PROJECT_DIR/scripts/first_mvp/visual/exterior_asset_probe.gd"
PALETTE_GD="$PROJECT_DIR/scripts/environment/approved_environment_palette.gd"
PRACTICE_ZONE="$PROJECT_DIR/scenes/first_mvp/zone_composer_practice.tscn"
PROJECT_GODOT="$PROJECT_DIR/project.godot"

PRESERVED_FILES=(
	"$GREYBOX_LAYOUT_GD" "$GREYBOX_REVIEW_GD" "$GREYBOX_SCENE" "$GREYBOX_VERIFICATION_GD"
	"$CANONICAL_SCENE" "$CANONICAL_REVIEW" "$CANONICAL_LAYOUT_GD" "$CANONICAL_LANDING_GD"
	"$LOOP_EVENT_GD" "$TREATMENT_GD" "$LIGHTING_GD" "$PROBE_GD" "$PALETTE_GD"
	"$PRACTICE_ZONE"
)

# Exactly the two files this pass extracted from LeLu's Noise Pack (FREE).
LELU_CRACKS="$PROJECT_DIR/assets/third_party/lelu/noise_pack/T_Cracks336.png"
LELU_CLOUDS="$PROJECT_DIR/assets/third_party/lelu/noise_pack/T_CloudNoise_Tiled.png"
LELU_DIR="$PROJECT_DIR/assets/third_party/lelu"

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

# --------------------------------------------------------------------------
step "0. Godot, and fingerprints of every file this pass must not touch"

version="$("$GODOT" --version 2>/dev/null | head -1 | tr -d '\r')"
if [[ "$version" == "$EXPECTED_VERSION"* ]]; then
	pass "Godot $version"
else
	fail "Godot is $version, not $EXPECTED_VERSION"
	printf '\nRIFTFALL LANDING VISUAL REVIEW SMOKE CHECKS: FAIL (wrong engine)\n'
	exit 1
fi

declare -a before_hashes
for f in "${PRESERVED_FILES[@]}"; do
	before_hashes+=("$(fingerprint "$f")")
done
project_godot_before="$(fingerprint "$PROJECT_GODOT")"
pass "${#PRESERVED_FILES[@]} preserved files fingerprinted (Greybox V2 foundation, canonical Gate 1C, Zone Composer, shared components, owner's practice zone)"
pass "project.godot fingerprinted (${project_godot_before:0:16})"

# --------------------------------------------------------------------------
step "1. All three new scripts parse"

for script in "$REVIEW_SCRIPT" "$DRESSING_SCRIPT" "$STONE_SCRIPT" "$VERIFICATION_SCRIPT"; do
	name="$(basename "$script")"
	relative="${script#"$PROJECT_DIR"/}"
	log="/tmp/riftwrought_visual_review_parse_$name.log"
	"$GODOT" --headless --path "$PROJECT_DIR" --check-only --script "res://$relative" \
		> "$log" 2>&1
	if grep -qE "Parse Error|Compile Error|Failed to load script" "$log"; then
		fail "$name does not parse"
		grep -E "Parse Error|Compile Error" "$log" | head -3 | sed 's/^/        /'
	else
		pass "$name parses"
	fi
done

# --------------------------------------------------------------------------
step "2. The scene boots headless with zero SCRIPT ERROR, and the pinned verification passes"

verify_log="/tmp/riftwrought_visual_review_verify.log"
"$GODOT" --headless --path "$PROJECT_DIR" "$SCENE" -- --verify-visual-review > "$verify_log" 2>&1

script_errors="$(grep -c "SCRIPT ERROR" "$verify_log" | tr -d ' ')"
if [[ "$script_errors" == "0" ]]; then
	pass "no SCRIPT ERROR"
else
	fail "$script_errors script errors"
	grep -A3 "SCRIPT ERROR" "$verify_log" | head -20 | sed 's/^/        /'
fi

read_check_count() {
	grep -ohE "$1: PASS \([0-9]+ checks\)" "$2" \
		| grep -ohE '[0-9]+ checks' | grep -ohE '[0-9]+' | head -1
}

count="$(read_check_count "RIFTFALL LANDING VISUAL REVIEW" "$verify_log")"
if [[ "$count" == "$EXPECTED_CHECKS" ]]; then
	pass "verification passes at the pinned $EXPECTED_CHECKS checks"
else
	fail "verification reports ${count:-no} checks, not $EXPECTED_CHECKS"
	grep -E "^  FAIL|VISUAL REVIEW:" "$verify_log" | sed 's/^/        /'
fi

replay="$(mktemp -t riftwrought_visual_review_replay)"
sed "s/RIFTFALL LANDING VISUAL REVIEW: PASS ($EXPECTED_CHECKS checks)/RIFTFALL LANDING VISUAL REVIEW: PASS ($((EXPECTED_CHECKS + 1)) checks)/" \
	"$verify_log" > "$replay"
if [[ "$(read_check_count "RIFTFALL LANDING VISUAL REVIEW" "$replay")" != "$EXPECTED_CHECKS" ]]; then
	pass "and that pin refuses a log whose count moved by one"
else
	fail "the count pin accepts a wrong count and therefore proves nothing"
fi
rm -f "$replay"

# --------------------------------------------------------------------------
step "3. project.godot is untouched"

project_godot_after="$(fingerprint "$PROJECT_GODOT")"
if [[ "$project_godot_after" == "$project_godot_before" ]]; then
	pass "project.godot is byte-identical"
else
	fail "project.godot changed during this run"
fi

actions="$(sed -n '/^\[input\]/,/^\[layer_names\]/p' "$PROJECT_GODOT" | grep -cE '^[a-zA-Z_0-9]+=')"
if [[ "$actions" == "$EXPECTED_INPUT_ACTIONS" ]]; then
	pass "InputMap still declares exactly $EXPECTED_INPUT_ACTIONS actions"
else
	fail "InputMap declares $actions actions, not $EXPECTED_INPUT_ACTIONS"
fi

main_scene="$(grep -oE 'run/main_scene="[^"]+"' "$PROJECT_GODOT" | head -1 | sed -E 's/run\/main_scene="([^"]+)"/\1/')"
if [[ "$main_scene" == "$EXPECTED_MAIN_SCENE" ]]; then
	pass "entrypoint is still $EXPECTED_MAIN_SCENE"
else
	fail "entrypoint is '$main_scene', not $EXPECTED_MAIN_SCENE"
fi

if grep -q "visual_review" "$PROJECT_GODOT"; then
	fail "project.godot names the visual review — it must own no project setting"
else
	pass "project.godot names nothing about the visual review"
fi

# --------------------------------------------------------------------------
step "4. Every file this pass must not touch is byte-identical"

all_preserved=1
for i in "${!PRESERVED_FILES[@]}"; do
	f="${PRESERVED_FILES[$i]}"
	name="$(basename "$f")"
	after="$(fingerprint "$f")"
	before="${before_hashes[$i]}"
	if [[ "$after" == "$before" && "$after" != "MISSING" ]]; then
		pass "$name is byte-identical"
	else
		fail "$name changed or is missing"
		all_preserved=0
	fi
done
if [[ "$all_preserved" == "1" ]]; then
	pass "all ${#PRESERVED_FILES[@]} preserved files confirmed untouched"
fi

# --------------------------------------------------------------------------
step "5. Exactly the minimum useful LeLu's Noise Pack extraction"

lelu_count="$(find "$LELU_DIR" -type f \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' \) 2>/dev/null | wc -l | tr -d ' ')"
if [[ "$lelu_count" == "2" ]]; then
	pass "exactly 2 LeLu texture files present under $LELU_DIR"
else
	fail "$lelu_count LeLu texture files present, not exactly 2"
fi
if [[ -f "$LELU_CRACKS" ]]; then
	pass "T_Cracks336.png present"
else
	fail "T_Cracks336.png missing"
fi
if [[ -f "$LELU_CLOUDS" ]]; then
	pass "T_CloudNoise_Tiled.png present"
else
	fail "T_CloudNoise_Tiled.png missing"
fi
if [[ -f "$PROJECT_DIR/assets/third_party/lelu/SOURCE_AND_LICENSE.md" ]]; then
	pass "LeLu source-and-license note present"
else
	fail "LeLu source-and-license note missing"
fi

# --------------------------------------------------------------------------
if [[ -n "$SHOT_DIR" ]]; then
	step "6. Rendered evidence"
	mkdir -p "$SHOT_DIR"
	shots_log="/tmp/riftwrought_visual_review_shots.log"
	"$GODOT" --path "$PROJECT_DIR" --resolution 1920x1080 "$SCENE" \
		-- --verify-visual-review --shots "$SHOT_DIR" > "$shots_log" 2>&1
	shot_count=0
	for shot in 01_overhead 02_arrival 03_procession 04_breach; do
		if [[ -f "$SHOT_DIR/$shot.png" ]]; then
			pass "$shot.png captured"
			shot_count=$((shot_count + 1))
		else
			fail "$shot.png was not captured"
		fi
	done
	if [[ "$shot_count" == "4" ]]; then
		pass "all 4 evidence frames present"
	fi
fi

# --------------------------------------------------------------------------
printf '\n'
if [[ "$failures" == "0" ]]; then
	printf 'RIFTFALL LANDING VISUAL REVIEW SMOKE CHECKS: PASS\n'
	exit 0
else
	printf 'RIFTFALL LANDING VISUAL REVIEW SMOKE CHECKS: FAIL (%d failure(s))\n' "$failures"
	exit 1
fi
