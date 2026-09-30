#!/usr/bin/env bash
# Riftwrought — Prototype Zero Gate D smoke checks.
#
# Gate D is one real Graveblade: detection and pursuit, an attack-permission
# request, a readable committed attack that can genuinely miss, deterministic
# Physical damage in both directions, Life, mechanical death, complete Hit and
# kill ordering, and the exact three-Hit starter relationship.
#
# This script runs every automated check Gate D is allowed to have (specification
# §25 forbids installing a test framework), and it runs the whole Gate C suite
# first — which itself runs the whole Gate B suite, which itself runs the whole
# Gate A suite — so a combat-kernel, locomotion, asset, or rig regression is
# caught before any encounter result is trusted.
#
# The Gate B and Gate C suites deliberately run WITHOUT the Graveblade: a live
# enemy chasing the character would change what they measure. The room removes it
# for those two runs and says so in its log; Gate D's own run asserts it is there.
#
# Automated checks cannot certify feel. See:
#   game/tests/manual/PROTOTYPE_ZERO_TEST_MATRIX.md
#   docs/testing/PROTOTYPE_ZERO_GATE_D_REPORT.md
#
# Gate D is NOT closed by this script passing. D-181 closes only when the project
# owner has judged the one-Graveblade fight with mouse and controller.
#
# Usage, from the repository root:
#   game/tests/gate_d_smoke.sh [--shots <dir>]
#
# --shots additionally boots the room with a real renderer and writes the Gate D
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
	if "$@" > /tmp/riftwrought_gate_d_step.log 2>&1; then
		printf '  PASS  %s\n' "$label"
	else
		printf '  FAIL  %s\n' "$label"
		sed 's/^/        /' /tmp/riftwrought_gate_d_step.log | tail -20
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

step "1. Gate C regression (which reruns Gate B, which reruns Gate A)"
if "$PROJECT_DIR/tests/gate_c_smoke.sh" > /tmp/riftwrought_gate_c_from_d.log 2>&1; then
	printf '  PASS  gate_c_smoke.sh still passes after the Gate D work\n'
	grep -E "GATE C VERIFICATION|navigation mesh |release marker |held repeat at 0%" /tmp/riftwrought_gate_c_from_d.log | head -5
else
	printf '  FAIL  gate_c_smoke.sh regressed\n'
	sed 's/^/        /' /tmp/riftwrought_gate_c_from_d.log | tail -40
	failures=$((failures + 1))
fi

step "2. Graveblade attack animation copy is current"
if "$GODOT" --headless --path "$PROJECT_DIR" --script res://scripts/tools/build_graveblade_animation.gd > /tmp/riftwrought_gate_d_anim.log 2>&1; grep -q "GRAVEBLADE ANIMATION BUILD: PASS" /tmp/riftwrought_gate_d_anim.log; then
	grep -E "^  (tip, blade centreline|CONTACT at|maximum contact distance|closest lateral miss|reach vs a|VERDICT|release marker |anticipation |follow-through|worst pose error|at the marker)" \
		/tmp/riftwrought_gate_d_anim.log
	grep -E "^  VERDICT: |^  FALLING BACK" /tmp/riftwrought_gate_d_anim.log
	printf '  PASS  both D-181 candidates measured; the chosen clip rebuilds and preserves every pose\n'
else
	printf '  FAIL  Graveblade animation build\n'
	grep -E "FAIL|VERDICT|BUILD" /tmp/riftwrought_gate_d_anim.log | sed 's/^/        /' | tail -20
	failures=$((failures + 1))
fi

step "3. Gate D encounter verification (headless)"
if "$GODOT" --headless --path "$PROJECT_DIR" "$ROOM_SCENE" -- --verify-d > /tmp/riftwrought_gate_d_verify.log 2>&1; grep -q "GATE D VERIFICATION: PASS" /tmp/riftwrought_gate_d_verify.log; then
	grep -E "^  observed: |^  committed |^  recorded: |^  decoration |^  the Graveblade actually walked" \
		/tmp/riftwrought_gate_d_verify.log
	printf '  PASS  locked values, states, permission, commitment, hit/miss boundaries,\n'
	printf '        genuine misses, Life in both directions, death, ordering, and scope\n'
else
	printf '  FAIL  Gate D verification\n'
	grep -E "FAIL|VERIFICATION" /tmp/riftwrought_gate_d_verify.log | sed 's/^/        /' | tail -20
	failures=$((failures + 1))
fi

step "4. Headless startup of the main scene"
check "boots the room with the Graveblade and exits cleanly" \
	"$GODOT" --headless --path "$PROJECT_DIR" "$ROOM_SCENE" --quit-after 180

if [[ -n "$shots_dir" ]]; then
	step "5. Rendered evidence screenshots"
	if "$GODOT" --path "$PROJECT_DIR" "$ROOM_SCENE" --resolution 1280x720 -- --verify-d --shots "$shots_dir" \
		> /tmp/riftwrought_gate_d_shots.log 2>&1; then
		printf '  PASS  wrote screenshots to %s\n' "$shots_dir"
	else
		printf '  FAIL  rendered run\n'
		sed 's/^/        /' /tmp/riftwrought_gate_d_shots.log | tail -30
		failures=$((failures + 1))
	fi
fi

printf '\n'
if [[ $failures -eq 0 ]]; then
	printf 'GATE D SMOKE CHECKS: PASS\n'
	printf 'Automated checks cannot certify feel. Gate D is NOT closed until the project\n'
	printf 'owner has judged the one-Graveblade fight with mouse and controller (D-181).\n'
	exit 0
fi
printf 'GATE D SMOKE CHECKS: %d FAILURE(S)\n' "$failures"
exit 1
