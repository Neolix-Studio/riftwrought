#!/usr/bin/env bash
# Riftwrought — Prototype Zero Gate B smoke checks.
#
# Gate B is calibration room, camera, collision, navigation mesh, click-to-move,
# controller direct movement, deadzone, and input-family tracking. This script
# runs every automated check Gate B is allowed to have (specification §25
# forbids installing a test framework), and it runs the preserved Gate A
# regression suite first so an asset or rig regression is caught before any
# locomotion result is trusted.
#
# Automated checks cannot certify feel. See:
#   game/tests/manual/PROTOTYPE_ZERO_TEST_MATRIX.md
#   docs/testing/PROTOTYPE_ZERO_GATE_B_REPORT.md
#
# Usage, from the repository root:
#   game/tests/gate_b_smoke.sh [--shots <dir>]
#
# --shots additionally boots the room with a real renderer and writes the
# Gate B evidence screenshots.

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
	if "$@" > /tmp/riftwrought_gate_b_step.log 2>&1; then
		printf '  PASS  %s\n' "$label"
	else
		printf '  FAIL  %s\n' "$label"
		sed 's/^/        /' /tmp/riftwrought_gate_b_step.log | tail -20
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

step "1. Gate A regression (preserved asset and rig spike)"
if "$PROJECT_DIR/tests/gate_a_smoke.sh" > /tmp/riftwrought_gate_a_from_b.log 2>&1; then
	printf '  PASS  gate_a_smoke.sh still passes after the Gate B work\n'
else
	printf '  FAIL  gate_a_smoke.sh regressed\n'
	sed 's/^/        /' /tmp/riftwrought_gate_a_from_b.log | tail -30
	failures=$((failures + 1))
fi

step "2. GDScript parse validation"
while IFS= read -r script; do
	check "$script" "$GODOT" --headless --path "$PROJECT_DIR" --check-only --script "res://$script"
done < <(cd "$PROJECT_DIR" && find scripts -name '*.gd' | sort)

step "3. Gate B room verification (headless)"
if "$GODOT" --headless --path "$PROJECT_DIR" "$ROOM_SCENE" -- --verify > /tmp/riftwrought_gate_b_verify.log 2>&1; grep -q "GATE B VERIFICATION: PASS" /tmp/riftwrought_gate_b_verify.log; then
	grep -E "^  (world unit|clear playable|P, player|movement  |long-axis|camera  |CF, |  {26}|clear floor in CF|ground seen|navigation mesh )" \
		/tmp/riftwrought_gate_b_verify.log
	printf '  PASS  navigation, click-to-move, walls, barrier, controller, deadzone, input family, no WASD\n'
else
	printf '  FAIL  Gate B verification\n'
	grep -E "FAIL|VERIFICATION" /tmp/riftwrought_gate_b_verify.log | sed 's/^/        /' | tail -20
	failures=$((failures + 1))
fi

step "4. Headless startup of the main scene"
check "boots the calibration room and exits cleanly" \
	"$GODOT" --headless --path "$PROJECT_DIR" "$ROOM_SCENE" --quit-after 180

if [[ -n "$shots_dir" ]]; then
	step "5. Rendered evidence screenshots"
	if "$GODOT" --path "$PROJECT_DIR" "$ROOM_SCENE" --resolution 1280x720 -- --verify --shots "$shots_dir" \
		> /tmp/riftwrought_gate_b_shots.log 2>&1; then
		printf '  PASS  wrote screenshots to %s\n' "$shots_dir"
	else
		printf '  FAIL  rendered run\n'
		sed 's/^/        /' /tmp/riftwrought_gate_b_shots.log | tail -30
		failures=$((failures + 1))
	fi
fi

printf '\n'
if [[ $failures -eq 0 ]]; then
	printf 'GATE B SMOKE CHECKS: PASS\n'
	exit 0
fi
printf 'GATE B SMOKE CHECKS: %d FAILURE(S)\n' "$failures"
exit 1
