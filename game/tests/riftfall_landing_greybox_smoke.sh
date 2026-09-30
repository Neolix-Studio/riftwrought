#!/usr/bin/env bash
# Riftwrought — Riftfall Landing greybox review smoke checks.
#
# THIS IS NOT A GATE AND IT DELIBERATELY DOES NOT RUN THE LOCKED CHAIN.
#
# The greybox review is one ISOLATED, non-canonical level-design blockout. It
# ships no gameplay, touches no accepted value, adds no InputMap action, and
# shares no file with any closed gate or with the Zone Composer, so rerunning
# Gates A-F, 1A, 1B and 1C to check a primitive-geometry blockout would be
# verification theatre over work this scene cannot possibly have broken. What
# this script proves is exactly what the greybox review CAN break:
#
#   1. both new scripts parse;
#   2. the scene boots headless with zero SCRIPT ERROR;
#   3. the headless verification passes at its pinned count, proved in BOTH
#      directions against a replay of its own log;
#   4. the canonical Gate 1C scene, the Zone Composer, and the project owner's
#      own composed zone are BYTE-IDENTICAL before and after this run;
#   5. project.godot is untouched — same 31 actions, same entrypoint, no new
#      section;
#   6. optionally, rendered evidence screenshots (--shots <dir>).
#
# Usage, from the repository root:
#   game/tests/riftfall_landing_greybox_smoke.sh
#   game/tests/riftfall_landing_greybox_smoke.sh --shots docs/testing/riftfall_landing_greybox_evidence

set -uo pipefail

GODOT="${GODOT:-/Applications/Godot.app/Contents/MacOS/Godot}"
EXPECTED_VERSION="4.7.2.stable"
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

SCENE="res://scenes/first_mvp/greybox/riftfall_landing_greybox_review.tscn"
VERIFICATION="res://tests/riftfall_landing_greybox_verification.gd"
LAYOUT_SCRIPT="$PROJECT_DIR/scripts/first_mvp/greybox/riftfall_landing_greybox_layout.gd"
REVIEW_SCRIPT="$PROJECT_DIR/scripts/first_mvp/greybox/riftfall_landing_greybox_review.gd"

# Pinned, and proved in both directions below.
EXPECTED_CHECKS=150

EXPECTED_INPUT_ACTIONS=31
EXPECTED_MAIN_SCENE="res://scenes/app/prototype_app.tscn"

# Files this review must never touch, fingerprinted before and after.
CANONICAL_SCENE="$PROJECT_DIR/scenes/first_mvp/severed_threshold/riftfall_landing.tscn"
CANONICAL_REVIEW="$PROJECT_DIR/scenes/first_mvp/severed_threshold/riftfall_landing_review.tscn"
CANONICAL_LAYOUT_GD="$PROJECT_DIR/scripts/first_mvp/severed_threshold/riftfall_landing_layout.gd"
PRACTICE_ZONE="$PROJECT_DIR/scenes/first_mvp/zone_composer_practice.tscn"
PROJECT_GODOT="$PROJECT_DIR/project.godot"

SHOT_DIR=""
if [[ "${1:-}" == "--shots" && -n "${2:-}" ]]; then
	mkdir -p "$2"
	# Resolved to an absolute path regardless of the caller's own working
	# directory, so it means the same thing whether Godot's own process cwd
	# matches the invoking shell's or not.
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
step "0. Godot, and fingerprints of every file this review must not touch"

version="$("$GODOT" --version 2>/dev/null | head -1 | tr -d '\r')"
if [[ "$version" == "$EXPECTED_VERSION"* ]]; then
	pass "Godot $version"
else
	fail "Godot is $version, not $EXPECTED_VERSION"
	printf '\nRIFTFALL LANDING GREYBOX SMOKE CHECKS: FAIL (wrong engine)\n'
	exit 1
fi

canonical_before="$(fingerprint "$CANONICAL_SCENE")"
canonical_review_before="$(fingerprint "$CANONICAL_REVIEW")"
canonical_layout_before="$(fingerprint "$CANONICAL_LAYOUT_GD")"
practice_before="$(fingerprint "$PRACTICE_ZONE")"
project_godot_before="$(fingerprint "$PROJECT_GODOT")"
pass "canonical Riftfall Landing fingerprinted (${canonical_before:0:16})"
pass "the owner's composed Zone Composer practice zone fingerprinted (${practice_before:0:16})"
pass "project.godot fingerprinted (${project_godot_before:0:16})"

# --------------------------------------------------------------------------
step "1. Both new scripts parse"

for script in "$LAYOUT_SCRIPT" "$REVIEW_SCRIPT" "$PROJECT_DIR/tests/riftfall_landing_greybox_verification.gd"; do
	name="$(basename "$script")"
	relative="${script#"$PROJECT_DIR"/}"
	log="/tmp/riftwrought_greybox_parse_$name.log"
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
step "2. No environment asset, shader, particle system, or registered presentation component"

if grep -qiE "res://assets/|\.gltf|\.glb|\.png|\.import|ExteriorReview|kaykit|kenney|k0rveen|GPUParticles|CPUParticles|ShaderMaterial|\.gdshader" \
		"$LAYOUT_SCRIPT" "$REVIEW_SCRIPT"; then
	fail "a shipping script names a forbidden fragment"
	grep -inE "res://assets/|\.gltf|\.glb|\.png|\.import|ExteriorReview|kaykit|kenney|k0rveen|GPUParticles|CPUParticles|ShaderMaterial|\.gdshader" \
		"$LAYOUT_SCRIPT" "$REVIEW_SCRIPT" | sed 's/^/        /'
else
	pass "raw source scan (comments included): no registered asset, shader, or particle system named"
fi

# --------------------------------------------------------------------------
step "3. The scene boots headless with zero SCRIPT ERROR, and the pinned verification passes"

verify_log="/tmp/riftwrought_greybox_verify.log"
"$GODOT" --headless --path "$PROJECT_DIR" "$SCENE" -- --verify-greybox > "$verify_log" 2>&1

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

count="$(read_check_count "RIFTFALL LANDING GREYBOX REVIEW" "$verify_log")"
if [[ "$count" == "$EXPECTED_CHECKS" ]]; then
	pass "verification passes at the pinned $EXPECTED_CHECKS checks"
else
	fail "verification reports ${count:-no} checks, not $EXPECTED_CHECKS"
	grep -E "^  FAIL|GREYBOX REVIEW:" "$verify_log" | sed 's/^/        /'
fi

# The pin is proved in BOTH directions: a replayed log whose count moved by
# one must be refused.
replay="$(mktemp -t riftwrought_greybox_replay)"
sed "s/RIFTFALL LANDING GREYBOX REVIEW: PASS ($EXPECTED_CHECKS checks)/RIFTFALL LANDING GREYBOX REVIEW: PASS ($((EXPECTED_CHECKS + 1)) checks)/" \
	"$verify_log" > "$replay"
if [[ "$(read_check_count "RIFTFALL LANDING GREYBOX REVIEW" "$replay")" != "$EXPECTED_CHECKS" ]]; then
	pass "and that pin refuses a log whose count moved by one"
else
	fail "the count pin accepts a wrong count and therefore proves nothing"
fi
rm -f "$replay"

# --------------------------------------------------------------------------
step "4. project.godot is untouched"

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

if grep -q "greybox" "$PROJECT_GODOT"; then
	fail "project.godot names the greybox review — it must own no project setting"
else
	pass "project.godot names nothing about the greybox review"
fi

# --------------------------------------------------------------------------
step "5. Every file this review must not touch is byte-identical"

canonical_after="$(fingerprint "$CANONICAL_SCENE")"
canonical_review_after="$(fingerprint "$CANONICAL_REVIEW")"
canonical_layout_after="$(fingerprint "$CANONICAL_LAYOUT_GD")"
practice_after="$(fingerprint "$PRACTICE_ZONE")"

if [[ "$canonical_after" == "$canonical_before" && "$canonical_after" != "MISSING" ]]; then
	pass "canonical riftfall_landing.tscn is byte-identical"
else
	fail "canonical riftfall_landing.tscn changed or is missing"
fi
if [[ "$canonical_review_after" == "$canonical_review_before" && "$canonical_review_after" != "MISSING" ]]; then
	pass "canonical riftfall_landing_review.tscn is byte-identical"
else
	fail "canonical riftfall_landing_review.tscn changed or is missing"
fi
if [[ "$canonical_layout_after" == "$canonical_layout_before" && "$canonical_layout_after" != "MISSING" ]]; then
	pass "canonical riftfall_landing_layout.gd is byte-identical"
else
	fail "canonical riftfall_landing_layout.gd changed or is missing"
fi
if [[ "$practice_after" == "$practice_before" && "$practice_after" != "MISSING" ]]; then
	pass "the owner's composed Zone Composer practice zone is byte-identical"
else
	fail "the owner's composed Zone Composer practice zone changed or is missing"
fi

# --------------------------------------------------------------------------
if [[ -n "$SHOT_DIR" ]]; then
	step "6. Rendered evidence"
	mkdir -p "$SHOT_DIR"
	shots_log="/tmp/riftwrought_greybox_shots.log"
	"$GODOT" --path "$PROJECT_DIR" --resolution 1920x1080 "$SCENE" \
		-- --verify-greybox --shots "$SHOT_DIR" > "$shots_log" 2>&1
	shot_count=0
	for shot in 01_overhead 02_arrival 03_middle 04_exit; do
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
	printf 'RIFTFALL LANDING GREYBOX SMOKE CHECKS: PASS\n'
	exit 0
else
	printf 'RIFTFALL LANDING GREYBOX SMOKE CHECKS: FAIL (%d failure(s))\n' "$failures"
	exit 1
fi
