#!/usr/bin/env bash
# Riftwrought — Prototype Zero Gate A smoke checks.
#
# Runs every automated check Gate A is allowed to have: headless import,
# GDScript parse validation, the asset probe, the rig verification, and a
# headless startup. No test framework is installed (see specification §25).
#
# Usage, from the repository root:
#   game/tests/gate_a_smoke.sh [--shots <dir>]
#
# --shots additionally boots the spike with a real renderer and writes the
# Gate A evidence screenshots.
#
# The spike is a PRESERVED REGRESSION FIXTURE. From Gate B onward it is no
# longer the project's main scene, so every step below names the spike scene
# explicitly instead of relying on run/main_scene.

set -uo pipefail

GODOT="${GODOT:-/Applications/Godot.app/Contents/MacOS/Godot}"
EXPECTED_VERSION="4.7.2.stable"
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SPIKE_SCENE="res://scenes/prototype_zero/gate_a_asset_spike.tscn"

shots_dir=""
if [[ "${1:-}" == "--shots" ]]; then
	shots_dir="${2:?--shots requires a directory}"
	mkdir -p "$shots_dir"
fi

failures=0

# NOTE on the pattern below. Godot's output is written to a log FIRST and the log
# is then grepped, rather than piping Godot through `tee ... | grep -q`. With
# `set -o pipefail`, `grep -q` exits the moment it matches and `tee` can then die
# on EPIPE, failing the whole pipeline even though the verification passed.

step() {
	printf '\n=== %s\n' "$1"
}

check() {
	local label="$1"
	shift
	if "$@" > /tmp/riftwrought_gate_a_step.log 2>&1; then
		printf '  PASS  %s\n' "$label"
	else
		printf '  FAIL  %s\n' "$label"
		sed 's/^/        /' /tmp/riftwrought_gate_a_step.log | tail -20
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

step "1. Headless asset import"
check "godot --headless --import" "$GODOT" --headless --path "$PROJECT_DIR" --import

step "2. GDScript parse validation"
while IFS= read -r script; do
	check "$script" "$GODOT" --headless --path "$PROJECT_DIR" --check-only --script "res://$script"
done < <(cd "$PROJECT_DIR" && find scripts -name '*.gd' | sort)

step "3. Registered asset probe"
if "$GODOT" --headless --path "$PROJECT_DIR" --script res://scripts/tools/gate_a_asset_report.gd > /tmp/riftwrought_gate_a_assets.log 2>&1; grep -q "GATE A ASSET REPORT: PASS" /tmp/riftwrought_gate_a_assets.log; then
	printf '  PASS  rig, socket, scale, and clip inventory\n'
else
	printf '  FAIL  asset probe\n'
	sed 's/^/        /' /tmp/riftwrought_gate_a_assets.log | tail -30
	failures=$((failures + 1))
fi

step "4. Rig verification (headless)"
if "$GODOT" --headless --path "$PROJECT_DIR" "$SPIKE_SCENE" -- --verify > /tmp/riftwrought_gate_a_rig.log 2>&1; grep -q "GATE A RIG VERIFICATION: PASS" /tmp/riftwrought_gate_a_rig.log; then
	printf '  PASS  clips, handslot.r attachment, in-place locomotion\n'
else
	printf '  FAIL  rig verification\n'
	sed 's/^/        /' /tmp/riftwrought_gate_a_rig.log | tail -30
	failures=$((failures + 1))
fi

step "5. Headless startup"
check "boots the Gate A spike scene and exits cleanly" "$GODOT" --headless --path "$PROJECT_DIR" "$SPIKE_SCENE" --quit-after 120

if [[ -n "$shots_dir" ]]; then
	step "6. Rendered evidence screenshots"
	if "$GODOT" --path "$PROJECT_DIR" "$SPIKE_SCENE" --resolution 1280x720 -- --verify --shots "$shots_dir" > /tmp/riftwrought_gate_a_shots.log 2>&1; then
		printf '  PASS  wrote screenshots to %s\n' "$shots_dir"
	else
		printf '  FAIL  rendered run\n'
		sed 's/^/        /' /tmp/riftwrought_gate_a_shots.log | tail -30
		failures=$((failures + 1))
	fi
fi

printf '\n'
if [[ $failures -eq 0 ]]; then
	printf 'GATE A SMOKE CHECKS: PASS\n'
	exit 0
fi
printf 'GATE A SMOKE CHECKS: %d FAILURE(S)\n' "$failures"
exit 1
