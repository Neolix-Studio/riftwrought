#!/usr/bin/env bash
# Riftwrought — Prototype Zero Gate E smoke checks.
#
# Gate E is the contained improvement loop: the first eligible kill grants
# exactly 10 XP and one guaranteed Prototype Honed Sword; mouse and controller
# can inspect, close, and equip it through a factual comparison; equipping
# changes Quick Strike from exactly 100 to exactly 150 Physical damage and an
# equivalent 300-Life Graveblade from a three-Hit kill to a two-Hit one; the
# second kill reaches exactly 20 / 20 and opens the one-option Quickened Form
# card; confirming it changes the action time from 0.80 to 0.64 seconds through
# the accepted attack-speed mechanism; and the repeat loop then runs
# deterministic waves of one, two, and three about 1.25 seconds after each
# previous threat is gone.
#
# This script runs every automated check Gate E is allowed to have
# (specification §25 forbids installing a test framework), and it runs the whole
# Gate D suite first — which itself runs the whole Gate C suite, which runs the
# whole Gate B suite, which runs the whole Gate A suite — so an encounter,
# combat-kernel, locomotion, asset, or rig regression is caught before any
# progression result is trusted.
#
# The Gate B and Gate C suites deliberately run WITHOUT any Graveblade, and the
# Gate B, Gate C, and Gate D suites all run with the Gate E progression director
# SUSPENDED: a live director spawning waves would change what they measure. A
# suspended director produces exactly the arrangement Gate D was accepted in —
# one Graveblade at the authored spawn marker, no rewards, no waves. Gate E's own
# run asserts the director is live.
#
# Automated checks cannot certify feel. See:
#   game/tests/manual/PROTOTYPE_ZERO_TEST_MATRIX.md
#   docs/testing/PROTOTYPE_ZERO_GATE_E_REPORT.md
#
# Gate E is NOT closed by this script passing. D-184 closes only when the project
# owner has judged the improvement loop with mouse and controller.
#
# Usage, from the repository root:
#   game/tests/gate_e_smoke.sh [--shots <dir>]
#
# --shots additionally boots the room with a real renderer and writes the Gate E
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
	if "$@" > /tmp/riftwrought_gate_e_step.log 2>&1; then
		printf '  PASS  %s\n' "$label"
	else
		printf '  FAIL  %s\n' "$label"
		sed 's/^/        /' /tmp/riftwrought_gate_e_step.log | tail -20
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

step "1. Gate D regression (which reruns Gate C, which reruns Gate B, which reruns Gate A)"
if "$PROJECT_DIR/tests/gate_d_smoke.sh" > /tmp/riftwrought_gate_d_from_e.log 2>&1; then
	printf '  PASS  gate_d_smoke.sh still passes after the Gate E work\n'
	grep -E "GATE D VERIFICATION|GATE C VERIFICATION|navigation mesh |release marker |observed: 300" \
		/tmp/riftwrought_gate_d_from_e.log | head -6
else
	printf '  FAIL  gate_d_smoke.sh regressed\n'
	sed 's/^/        /' /tmp/riftwrought_gate_d_from_e.log | tail -40
	failures=$((failures + 1))
fi

step "2. Gate E improvement-loop verification (headless)"
if "$GODOT" --headless --path "$PROJECT_DIR" "$ROOM_SCENE" -- --verify-e > /tmp/riftwrought_gate_e_verify.log 2>&1; grep -q "GATE E VERIFICATION: PASS" /tmp/riftwrought_gate_e_verify.log; then
	grep -E "^  (the controlled|    ceil|Graveblade Life with|XP trace|observed wave sizes|mean gap|gaps between DIFFERENT|recorded:|wind-up |action  )" \
		/tmp/riftwrought_gate_e_verify.log
	printf '  PASS  weapon records, XP sequence, reward uniqueness, stage order, 0.80 -> 0.64 s,\n'
	printf '        deterministic waves, safe spawns, coordination, the modal contract, and scope\n'
else
	printf '  FAIL  Gate E verification\n'
	grep -E "FAIL|VERIFICATION" /tmp/riftwrought_gate_e_verify.log | sed 's/^/        /' | tail -20
	failures=$((failures + 1))
fi

step "3. Headless startup of the main scene"
check "boots the room with the live progression director and exits cleanly" \
	"$GODOT" --headless --path "$PROJECT_DIR" "$ROOM_SCENE" --quit-after 240

if [[ -n "$shots_dir" ]]; then
	step "4. Rendered evidence screenshots"
	if "$GODOT" --path "$PROJECT_DIR" "$ROOM_SCENE" --resolution 1280x720 -- --verify-e --shots "$shots_dir" \
		> /tmp/riftwrought_gate_e_shots.log 2>&1; then
		printf '  PASS  wrote screenshots to %s\n' "$shots_dir"
		grep -E "GATE E VERIFICATION" /tmp/riftwrought_gate_e_shots.log
	else
		printf '  FAIL  rendered run\n'
		sed 's/^/        /' /tmp/riftwrought_gate_e_shots.log | tail -30
		failures=$((failures + 1))
	fi
fi

printf '\n'
if [[ $failures -eq 0 ]]; then
	printf 'GATE E SMOKE CHECKS: PASS\n'
	printf 'Automated checks cannot certify feel. Gate E is NOT closed until the project\n'
	printf 'owner has judged the improvement loop with mouse and controller (D-184).\n'
	exit 0
fi
printf 'GATE E SMOKE CHECKS: %d FAILURE(S)\n' "$failures"
exit 1
