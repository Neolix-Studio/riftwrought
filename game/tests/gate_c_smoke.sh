#!/usr/bin/env bash
# Riftwrought — Prototype Zero Gate C smoke checks.
#
# Gate C is the Quick Strike kernel: target acquisition and approach, directional
# swings, attack-in-place, controller soft targeting, the six action states, held
# input arbitration, buffering, repeating, cancellation, the stable Skill Use ID,
# exactly one animation-aligned release query per use, and Mana.
#
# Controller soft targeting obeys D-178: a 65-degree TOTAL cone (+/-32.5 degrees)
# and a priority group for candidates already inside the 1.65 m release reach.
#
# This script runs every automated check Gate C is allowed to have (specification
# §25 forbids installing a test framework), and it runs the whole Gate B suite
# first — which itself runs the whole Gate A suite first — so an asset, rig, or
# locomotion regression is caught before any combat result is trusted.
#
# Automated checks cannot certify feel. See:
#   game/tests/manual/PROTOTYPE_ZERO_TEST_MATRIX.md
#   docs/testing/PROTOTYPE_ZERO_GATE_C_REPORT.md
#
# The project owner's controller-feel review is still outstanding (D-175) and
# nothing in here can stand in for it.
#
# Usage, from the repository root:
#   game/tests/gate_c_smoke.sh [--shots <dir>]
#
# --shots additionally boots the room with a real renderer and writes the Gate C
# evidence screenshots.

set -uo pipefail

GODOT="${GODOT:-/Applications/Godot.app/Contents/MacOS/Godot}"
EXPECTED_VERSION="4.7.2.stable"
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ROOM_SCENE="res://scenes/prototype_zero/prototype_zero.tscn"

shots_dir=""
if [[ "${1:-}" == "--shots" ]]; then
	shots_dir="${2:?--shots requires a directory}"
	mkdir -p "$shots_dir"
	shots_dir="$(cd "$shots_dir" && pwd)"
fi

# Gate F made scenes/app/prototype_app.tscn the project main scene, so the
# startup check names the ROOM scene explicitly. Every earlier suite still
# measures the room on its own, exactly as it always did.
failures=0

# NOTE on the pattern below. Godot's output is written to a log FIRST and the log
# is then grepped, rather than piping Godot through `tee ... | grep -q`. With
# `set -o pipefail`, `grep -q` exits the moment it matches and `tee` can then die
# on EPIPE, failing the whole pipeline even though the verification passed. That
# race is timing-dependent, which is the worst kind of flaky: it reported a
# regression that had not happened.

step() {
	printf '\n=== %s\n' "$1"
}

check() {
	local label="$1"
	shift
	if "$@" > /tmp/riftwrought_gate_c_step.log 2>&1; then
		printf '  PASS  %s\n' "$label"
	else
		printf '  FAIL  %s\n' "$label"
		sed 's/^/        /' /tmp/riftwrought_gate_c_step.log | tail -20
		failures=$((failures + 1))
	fi
}

step "0. Engine baseline"
version="$("$GODOT" --version 2>/dev/null | tail -1)"
printf '  installed: %s\n' "$version"
if [[ "$version" != "$EXPECTED_VERSION"* ]]; then
	printf '  FAIL  expected %s (locked by D-167); report the mismatch before upgrading the project.\n' "$EXPECTED_VERSION"
	failures=$((failures + 1))
else
	printf '  PASS  matches the locked %s baseline\n' "$EXPECTED_VERSION"
fi

step "1. Gate B regression (which reruns the whole Gate A suite first)"
if "$PROJECT_DIR/tests/gate_b_smoke.sh" > /tmp/riftwrought_gate_b_from_c.log 2>&1; then
	printf '  PASS  gate_b_smoke.sh still passes after the Gate C work\n'
	grep -E "^  (movement  |camera  |CF, |clear floor in CF|navigation mesh )" /tmp/riftwrought_gate_b_from_c.log | head -6
else
	printf '  FAIL  gate_b_smoke.sh regressed\n'
	sed 's/^/        /' /tmp/riftwrought_gate_b_from_c.log | tail -40
	failures=$((failures + 1))
fi

step "2. Quick Strike animation copy is current"
if "$GODOT" --headless --path "$PROJECT_DIR" --script res://scripts/tools/build_quick_strike_animation.gd > /tmp/riftwrought_gate_c_anim.log 2>&1; grep -q "QUICK STRIKE ANIMATION BUILD: PASS" /tmp/riftwrought_gate_c_anim.log; then
	grep -E "^  (length |tip crosses forward|reach at contact|release marker |measured contact|anticipation |follow-through|playback speed|worst pose error)" \
		/tmp/riftwrought_gate_c_anim.log
	printf '  PASS  the retimed local clip rebuilds and preserves every pose\n'
else
	printf '  FAIL  Quick Strike animation build\n'
	grep -E "FAIL|BUILD" /tmp/riftwrought_gate_c_anim.log | sed 's/^/        /' | tail -20
	failures=$((failures + 1))
fi

step "3. Gate C kernel verification (headless)"
if "$GODOT" --headless --path "$PROJECT_DIR" "$ROOM_SCENE" -- --verify-c > /tmp/riftwrought_gate_c_verify.log 2>&1; grep -q "GATE C VERIFICATION: PASS" /tmp/riftwrought_gate_c_verify.log; then
	grep -E "^    release [0-9]: clip at|^  held repeat at|^  totals: |^  the visible blade" \
		/tmp/riftwrought_gate_c_verify.log
	printf '  PASS  timing, release marker, targeting, approach, arc, obstruction,\n'
	printf '        arbitration, buffer, repeat, cancellation, Skill Use IDs, Mana, scope\n'
else
	printf '  FAIL  Gate C verification\n'
	grep -E "FAIL|VERIFICATION" /tmp/riftwrought_gate_c_verify.log | sed 's/^/        /' | tail -20
	failures=$((failures + 1))
fi

step "4. Headless startup of the main scene"
check "boots the room with the Quick Strike kernel and exits cleanly" \
	"$GODOT" --headless --path "$PROJECT_DIR" "$ROOM_SCENE" --quit-after 180

if [[ -n "$shots_dir" ]]; then
	step "5. Rendered evidence screenshots"
	if "$GODOT" --path "$PROJECT_DIR" "$ROOM_SCENE" --resolution 1280x720 -- --verify-c --shots "$shots_dir" \
		> /tmp/riftwrought_gate_c_shots.log 2>&1; then
		printf '  PASS  wrote screenshots to %s\n' "$shots_dir"
	else
		printf '  FAIL  rendered run\n'
		sed 's/^/        /' /tmp/riftwrought_gate_c_shots.log | tail -30
		failures=$((failures + 1))
	fi
fi

printf '\n'
if [[ $failures -eq 0 ]]; then
	printf 'GATE C SMOKE CHECKS: PASS\n'
	printf 'Automated checks cannot certify feel. The project owner still owes the\n'
	printf 'carried controller-feel review from D-175 before Gate C can be closed.\n'
	exit 0
fi
printf 'GATE C SMOKE CHECKS: %d FAILURE(S)\n' "$failures"
exit 1
