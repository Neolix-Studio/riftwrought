#!/usr/bin/env bash
# Riftwrought — P1B: Wroughtstone 2D Proof Kit — focused runner.
#
# P1B IS ACCEPTED AND CLOSED under D-362. This runner is now the regression guard over what
# that acceptance covers: the three proof tiles, the measured mask, the no-transform
# guarantee, the whole-pixel lattice, and the two ACCEPTED DEBTS with their ceilings.
# A green run is still NOT P1B acceptance -- acceptance is the owner's ruling.
#
# A PLAIN INVOCATION IS HEADLESS ONLY. It opens no window and writes no image.
#
#   bash game2d/tests/p1b_smoke.sh                # headless checks only
#   bash game2d/tests/p1b_smoke.sh --inventory <dir>   # ... and write the mask sheet
#
# WHAT IT PROVES
#   1. every P1B script parses;
#   2. the P1A locks are untouched and `game/` is byte-identical;
#   3. the P1B verification passes, and its log is pinned in BOTH directions;
#   4. no `.pxo` is reachable from `game2d/`, and no owner art was written to.
#
# WHAT IT CANNOT PROVE YET, and says so: terrain placement, repeated-tile seams and
# pixel-stable rendering OF REAL ART. Those are BLOCKED on the owner's exports and are
# never recorded as passes.

set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "$HERE/.." && pwd)"
REPO_DIR="$(cd "$PROJECT_DIR/.." && pwd)"
GODOT="${GODOT:-/Applications/Godot.app/Contents/MacOS/Godot}"

INVENTORY=""
while [ $# -gt 0 ]; do
	case "$1" in
		--inventory) INVENTORY="${2:-}"; shift 2 ;;
		*) echo "unknown argument: $1" >&2; exit 2 ;;
	esac
done
case "$INVENTORY" in "" | /*) ;; *) INVENTORY="$(pwd)/$INVENTORY" ;; esac

WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

FAILURES=0
step() { printf '\n=== %s ===\n' "$1"; }
pass() { printf '  PASS  %s\n' "$1"; }
fail() { printf '  FAIL  %s\n' "$1"; FAILURES=$((FAILURES + 1)); }
note() { printf '  ----  %s\n' "$1"; }

PIN_CHECKS="15"
PIN_OWED="15"
# D-361: the remaining terrain-edge transparency is ACCEPTED, non-blocking art debt, so the
# verification no longer fails for it. It is CEILINGED inside the suite instead, and the
# debt is counted here so it cannot quietly disappear.
PIN_DEBT="2"
PIN_GAME_FILE_COUNT="1482"
PIN_GAME_DIGEST="dbf6258d75f4a7c2a3a1cb42fd99414a393525fe7d02c836a4c37175d7200f51"

RUN_TOKEN="p1b-$$-$(date -u +%Y%m%dT%H%M%SZ)"

step "1. Every P1B script parses"
for rel in scripts/p1b_terrain.gd scripts/p1b_tileset.gd tests/p1b_verification.gd tools/p1b_mask_inventory.gd; do
	out="$("$GODOT" --headless --path "$PROJECT_DIR" --log-file "$WORK/parse.log" \
		--check-only --script "res://$rel" 2>&1 | grep -v '^Godot Engine' | grep -v '^$')"
	if [ -z "$out" ]; then pass "$rel parses"; else fail "$rel: $out"; fi
done

step "2. The owner-art boundary"
pxo_in_project="$(find "$PROJECT_DIR" -type f -iname '*.pxo' | wc -l | tr -d ' ')"
if [ "$pxo_in_project" = "0" ]; then
	pass "no Pixelorama source exists anywhere under game2d/"
else
	fail "$pxo_in_project .pxo file(s) under game2d/"
fi
# The property that matters is not whether the string ".pxo" appears -- this suite and its
# modules say the word in prose precisely because the prohibition has to be visible. What
# matters is that NO .pxo string ever reaches a file or resource API, i.e. that no .pxo
# path RESOLVES. P1B source is scoped by name so P1A's legitimate reads of owner PNGs
# (which prove byte-identity, and are accepted) are not swept up.
#
# Scope: the P1B GDScript MODULES. This runner is the guard, not the guarded -- its own
# planted test fixture below deliberately contains a resolving .pxo path.
#
# NOTE ON QUOTING: these paths contain spaces. An unquoted `for f in $list` splits them and
# the guard silently scans NOTHING and passes vacuously. It did exactly that once. Hence
# -print0 / read -d, and hence the reachability proof at the end of this step.
RESOLVER='(load|preload|FileAccess|DirAccess|ResourceLoader|get_file)'

scan() {  # scan <regex> ; prints the number of matching lines across P1B source
	local pattern="$1" total=0 n
	while IFS= read -r -d '' f; do
		n="$(grep -cE "$pattern" "$f" 2>/dev/null)" || n=0
		total=$((total + n))
	done < <(find "$PROJECT_DIR/scripts" "$PROJECT_DIR/tests" "$PROJECT_DIR/tools" \
		-type f -name 'p1b_*.gd' -print0 2>/dev/null)
	printf '%s' "$total"
}

p1b_file_count="$(scan '.')"
if [ "$p1b_file_count" -gt 0 ]; then
	pass "the boundary guard actually reached P1B source ($p1b_file_count lines scanned)"
else
	fail "the boundary guard scanned NOTHING - it would pass vacuously"
fi

resolving_pxo="$(scan "${RESOLVER}[^#]*\.pxo")"
if [ "$resolving_pxo" = "0" ]; then
	pass "no .pxo string in P1B source ever reaches a file or resource API: no .pxo path resolves"
else
	fail "$resolving_pxo line(s) pass a .pxo path to a file or resource API"
fi

resolving_owner="$(scan "${RESOLVER}[^#]*assets/Pixel Art")"
prose_owner="$(scan 'assets/Pixel Art')"
if [ "$resolving_owner" = "0" ]; then
	pass "no P1B source resolves a path inside the owner's assets/Pixel Art/ tree ($prose_owner prose mention(s))"
else
	fail "$resolving_owner P1B line(s) resolve a path inside assets/Pixel Art/"
fi

# BOTH DIRECTIONS: the guard must be able to fail. Plant a violating line in a scratch copy
# of the real pattern and require the same regex to catch it.
probe="$WORK/guard_probe.gd"
printf '%s\n' 'var img = load("res://assets/Pixel Art/Environment/Wroughtstone/thing.pxo")' > "$probe"
if grep -qE "${RESOLVER}[^#]*\.pxo" "$probe"; then
	pass "the boundary guard refuses a planted resolving .pxo path"
else
	fail "the boundary guard cannot detect a resolving .pxo path"
fi

step "3. \`game/\` is untouched"
if [ -d "$REPO_DIR/game" ]; then
	game_list="$WORK/game_files.txt"
	( cd "$REPO_DIR/game" && find . -type f ! -name '.DS_Store' -print0 | sort -z | xargs -0 shasum -a 256 ) > "$game_list"
	game_count="$(wc -l < "$game_list" | tr -d ' ')"
	game_digest="$(shasum -a 256 < "$game_list" | cut -d' ' -f1)"
	if [ "$game_count" = "$PIN_GAME_FILE_COUNT" ] && [ "$game_digest" = "$PIN_GAME_DIGEST" ]; then
		pass "game/ is byte-identical: $game_count files, digest ${game_digest:0:16}…"
	else
		fail "game/ moved: $game_count files, digest ${game_digest:0:16}…"
	fi
	altered="$(printf '%s\nx\n' "$(cat "$game_list")" | shasum -a 256 | cut -d' ' -f1)"
	if [ "$altered" != "$PIN_GAME_DIGEST" ]; then
		pass "the game/ digest pin refuses a list with one line added"
	else
		fail "the game/ digest pin accepts an altered list"
	fi
else
	fail "game/ is missing"
fi

step "4. The P1B verification, and its log pinned in both directions"
verify_log="$WORK/verify.log"
"$GODOT" --headless --path "$PROJECT_DIR" --log-file "$WORK/godot.log" \
	--script "res://tests/p1b_verification.gd" -- --run-token "$RUN_TOKEN" > "$verify_log" 2>&1
verify_status=$?
if [ "$verify_status" = "0" ]; then
	pass "the verification exited 0"
else
	fail "the verification exited $verify_status"
fi
if grep -qE "SCRIPT ERROR|Parse Error|Failed to load script" "$verify_log"; then
	fail "the verification log carries an engine error, whatever its PASS line says"
	grep -E "SCRIPT ERROR|Parse Error|Failed to load script" "$verify_log" | head -5
else
	pass "the verification log carries no engine error"
fi

pin_line() {
	local label="$1" want="$2" tampered="$3"
	if grep -qxF "$want" "$verify_log"; then
		pass "$label: '$want'"
	else
		fail "$label: '$want' is not in the log"
		return
	fi
	sed "s|^$(printf '%s' "$want" | sed 's/[.[\*^$/]/\\&/g')\$|$tampered|" "$verify_log" > "$WORK/tampered.log"
	if grep -qxF "$want" "$WORK/tampered.log"; then
		fail "$label: the pin accepts a log with that line altered"
	else
		pass "$label: the pin refuses a log with that line altered"
	fi
}
pin_line "run token"   "P1B RUN TOKEN: $RUN_TOKEN"                "P1B RUN TOKEN: not-this-run"
pin_line "check count" "P1B VERIFICATION: PASS ($PIN_CHECKS checks)" "P1B VERIFICATION: PASS ($((PIN_CHECKS + 1)) checks)"
pin_line "accepted debt" "P1B ACCEPTED DEBT: $PIN_DEBT"              "P1B ACCEPTED DEBT: $((PIN_DEBT - 1))"
pin_line "owed count"  "P1B OWED CHECKS: $PIN_OWED"               "P1B OWED CHECKS: $((PIN_OWED + 1))"
if grep -q "owed $PIN_OWED; reached $PIN_OWED" "$verify_log"; then
	pass "the owed set was compared in both directions and nothing was missing or unexpected"
else
	fail "the owed-set comparison line is not in the log"
fi
if grep -q "A GREEN RUN IS NOT P1B ACCEPTANCE" "$verify_log" \
	&& grep -q "Acceptance is the owner" "$verify_log" \
	&& grep -q "P1C-H IS BEGUN under D-364" "$verify_log" \
	&& grep -q "ORIGINAL P1C is NOT" "$verify_log"; then
	pass "the verification says out loud that passing is not acceptance"
else
	fail "the verification does not disclaim acceptance"
fi
if grep -q "WARNING / ACCEPTED DEBT" "$verify_log"; then
	note "the seam measurement is reported as accepted DEBT, ceilinged, and never as a pass"
else
	fail "the verification no longer reports the seam measurement at all"
fi

step "5. The mask inventory"
if [ -n "$INVENTORY" ]; then
	mkdir -p "$INVENTORY"
	if "$GODOT" --headless --path "$PROJECT_DIR" --log-file "$WORK/inv.log" \
			--script "res://tools/p1b_mask_inventory.gd" -- --out "$INVENTORY/p1b_mask_inventory.png" \
			> "$WORK/inv.out" 2>&1; then
		pass "wrote $INVENTORY/p1b_mask_inventory.png"
	else
		fail "the mask inventory tool failed"
	fi
else
	note "NOT REQUESTED: pass --inventory <dir> to write the visual mask sheet."
fi

step "Summary"
printf '  P1B is ACCEPTED AND CLOSED under D-362 \u2014 by the owner, after a visual review this\n'
printf '  runner cannot perform. A green runner is still not acceptance.\n'
printf '  P1C-H IS BEGUN (D-364), DELIVERED and OPEN. The ORIGINAL P1C is NOT complete and\n'
printf '  its Mage-dependent portion is DEFERRED to the future Mage art phase.\n'
printf '\n'
printf '  MEASURED, not inferred: an isometric tile in MATCH_SIDES exposes exactly FOUR\n'
printf '  peering bits, so there are 16 masks (15 non-empty). Godot does NOT require a\n'
printf '  complete set: with 2 of 16 tiles an L-run filled 5 of 5 cells and errored not\n'
printf '  at all. Missing masks are a VISUAL defect, never an engine failure.\n'
printf '\n'
printf '  BLOCKED on owner exports, and never recorded as passes:\n'
printf '    - terrain placement of real art;\n'
printf '    - repeated-tile seam inspection;\n'
printf '    - pixel-stable rendering of real tiles under the locked mode 7.\n'
printf '\n'
if [ "$FAILURES" = "0" ]; then
	printf 'P1B SMOKE: PASS\n'
else
	printf 'P1B SMOKE: %d FAILURE(S)\n' "$FAILURES"
fi

printf '\n--- the verification record, in full ---\n'
cat "$verify_log"

[ "$FAILURES" = "0" ] || exit 1
