#!/usr/bin/env bash
# Riftwrought — P1C-H: Huntress character and combat proof — focused runner.
#
# P1C-H IS ACCEPTED and CLOSED under D-365, as the verified 2D MECHANICS PROTOTYPE.
# A green run is still NOT acceptance -- acceptance is the owner's ruling.
#
# 2D PRESENTATION AND OWNER-ART PRODUCTION ARE FROZEN under D-365. The intended final
# visual target is now a modern stylized 3D dark-fantasy ARPG. NO 3D PIVOT AND NO 3D SPIKE
# IS AUTHORIZED by that ruling; each needs its own bounded authorization. `game2d/` is
# preserved as the accepted mechanics prototype.
#
# **P1C-H IS THE HUNTRESS-FIRST SUBSTAGE OF P1C.** Original criterion C9 (the Mage spell)
# and the "both characters" scope are TRANSFERRED to the future Mage art phase. Completing
# P1C-H does NOT complete the original P1C or P1, and does NOT authorize P2.

set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "$HERE/.." && pwd)"
REPO_DIR="$(cd "$PROJECT_DIR/.." && pwd)"
GODOT="${GODOT:-/Applications/Godot.app/Contents/MacOS/Godot}"

WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT
FAILURES=0
step() { printf '\n=== %s ===\n' "$1"; }
pass() { printf '  PASS  %s\n' "$1"; }
fail() { printf '  FAIL  %s\n' "$1"; FAILURES=$((FAILURES + 1)); }
note() { printf '  ----  %s\n' "$1"; }

PIN_CHECKS="15"
PIN_OWED="15"
PIN_TRANSFERRED="2"
PIN_GAME_FILE_COUNT="1482"
PIN_GAME_DIGEST="dbf6258d75f4a7c2a3a1cb42fd99414a393525fe7d02c836a4c37175d7200f51"
RUN_TOKEN="p1c-$$-$(date -u +%Y%m%dT%H%M%SZ)"

step "1. Every P1C-H script parses"
for rel in scripts/p1c_facing.gd scripts/p1c_movement.gd scripts/p1c_targeting.gd \
		scripts/p1c_combat.gd scripts/p1c_room.gd tests/p1c_verification.gd; do
	out="$("$GODOT" --headless --path "$PROJECT_DIR" --log-file "$WORK/p.log" \
		--check-only --script "res://$rel" 2>&1 | grep -v '^Godot Engine' | grep -v '^$')"
	if [ -z "$out" ]; then pass "$rel parses"; else fail "$rel: $out"; fi
done

step "2. Boundaries"
pxo="$(find "$PROJECT_DIR" -type f -iname '*.pxo' | wc -l | tr -d ' ')"
[ "$pxo" = "0" ] && pass "no Pixelorama source under game2d/" || fail "$pxo .pxo under game2d/"
# The legacy Mage must not be used as production art by P1C-H.
mage=0
while IFS= read -r -d '' f; do
	n="$(grep -cE '(load|preload)[^#]*mage' "$f" 2>/dev/null)" || n=0
	mage=$((mage + n))
done < <(find "$PROJECT_DIR/scripts" "$PROJECT_DIR/tests" -type f -name 'p1c_*.gd' -print0)
if [ "$mage" = "0" ]; then
	pass "no P1C-H module loads the legacy Mage art"
else
	fail "$mage P1C-H line(s) load the legacy Mage art"
fi
# The unaccepted simplified candidate must not be LOADED. Prose mentions are fine and
# expected -- check 11 exists precisely to assert its absence, so it names it. What must
# not exist is a path that resolves, so the guard matches the candidate's actual FILE
# NAME rather than the bare word. (The same guard bug bit the P1B runner once, and then
# bit this one: a grep for the word flagged the very check that tests for the word.)
simp=0
while IFS= read -r -d '' f; do
	n="$(grep -cE '(load|preload|FileAccess|ResourceLoader)[^#]*wroughtstone_ground_slate_simplified' "$f" 2>/dev/null)" || n=0
	simp=$((simp + n))
done < <(find "$PROJECT_DIR/scripts" "$PROJECT_DIR/tests" -type f -name 'p1c_*.gd' -print0)
if [ "$simp" = "0" ]; then
	pass "no P1C-H module LOADS the unaccepted simplified candidate (prose mentions are expected)"
else
	fail "$simp P1C-H line(s) load the simplified candidate"
fi
# And prove that guard can fail.
probe="$WORK/simp_probe.gd"
printf '%s\n' 'var t = load("res://wroughtstone_ground_slate_simplified_proof_120x60_v1.png")' > "$probe"
grep -qE '(load|preload|FileAccess|ResourceLoader)[^#]*wroughtstone_ground_slate_simplified' "$probe" \
	&& pass "the simplified-candidate guard refuses a planted resolving reference" \
	|| fail "the simplified-candidate guard cannot detect a resolving reference"

step "3. \`game/\` is untouched"
if [ -d "$REPO_DIR/game" ]; then
	gl="$WORK/game.txt"
	( cd "$REPO_DIR/game" && find . -type f ! -name '.DS_Store' -print0 | sort -z | xargs -0 shasum -a 256 ) > "$gl"
	gc="$(wc -l < "$gl" | tr -d ' ')"; gd="$(shasum -a 256 < "$gl" | cut -d' ' -f1)"
	if [ "$gc" = "$PIN_GAME_FILE_COUNT" ] && [ "$gd" = "$PIN_GAME_DIGEST" ]; then
		pass "game/ is byte-identical: $gc files, digest ${gd:0:16}…"
	else
		fail "game/ moved: $gc files, ${gd:0:16}…"
	fi
	alt="$(printf '%s\nx\n' "$(cat "$gl")" | shasum -a 256 | cut -d' ' -f1)"
	[ "$alt" != "$PIN_GAME_DIGEST" ] && pass "the game/ digest pin refuses an altered list" \
		|| fail "the game/ digest pin accepts an altered list"
else
	fail "game/ is missing"
fi

step "4. The P1C-H verification, pinned in both directions"
vl="$WORK/verify.log"
"$GODOT" --headless --path "$PROJECT_DIR" --log-file "$WORK/g.log" \
	--script "res://tests/p1c_verification.gd" -- --run-token "$RUN_TOKEN" > "$vl" 2>&1
vs=$?
[ "$vs" = "0" ] && pass "the verification exited 0" || fail "the verification exited $vs"
# The pattern deliberately includes a bare leading ERROR:/USER ERROR: line. Godot prints
# server-side failures — a navigation query made before the map synchronised, for one — in
# that form and NOT as a SCRIPT ERROR, so a guard that looked only for script errors reported
# a clean log while an engine error sat in it. Matching is anchored to the line start so the
# suite's own prose can discuss errors without tripping it.
engine_error_re='^(ERROR|USER ERROR):|SCRIPT ERROR|Parse Error|Failed to load script'
if grep -qE "$engine_error_re" "$vl"; then
	fail "the verification log carries an engine error, whatever its PASS line says"
	grep -E "$engine_error_re" "$vl" | head -3
else
	pass "the verification log carries no engine error"
	planted_err="$WORK/verify_planted_error.log"
	{ cat "$vl"; printf 'ERROR: planted engine error\n'; } > "$planted_err"
	if grep -qE "$engine_error_re" "$planted_err"; then
		pass "the engine-error guard REFUSES a planted bare ERROR: line"
	else
		fail "the engine-error guard cannot see a planted bare ERROR: line"
	fi
fi
pin_line() {
	local label="$1" want="$2" tampered="$3"
	if grep -qxF "$want" "$vl"; then pass "$label: '$want'"; else fail "$label: '$want' is not in the log"; return; fi
	sed "s|^$(printf '%s' "$want" | sed 's/[.[\*^$/]/\\&/g')\$|$tampered|" "$vl" > "$WORK/t.log"
	if grep -qxF "$want" "$WORK/t.log"; then fail "$label: the pin accepts an altered line"; else pass "$label: the pin refuses an altered line"; fi
}
pin_line "run token"        "P1C-H RUN TOKEN: $RUN_TOKEN"                  "P1C-H RUN TOKEN: not-this-run"
pin_line "check count"      "P1C-H VERIFICATION: PASS ($PIN_CHECKS checks)" "P1C-H VERIFICATION: PASS ($((PIN_CHECKS + 1)) checks)"
pin_line "owed count"       "P1C-H OWED CHECKS: $PIN_OWED"                 "P1C-H OWED CHECKS: $((PIN_OWED + 1))"
pin_line "transferred count" "P1C-H TRANSFERRED: $PIN_TRANSFERRED"         "P1C-H TRANSFERRED: $((PIN_TRANSFERRED - 1))"
grep -q "owed $PIN_OWED; reached $PIN_OWED" "$vl" \
	&& pass "the owed set was compared in both directions" \
	|| fail "the owed-set comparison line is not in the log"
grep -q "A GREEN RUN IS NOT P1C-H ACCEPTANCE" "$vl" \
	&& grep -q "Acceptance is the owner" "$vl" \
	&& pass "the verification attributes acceptance to the owner's ruling, not to its own exit code" \
	|| fail "the verification does not attribute acceptance to the owner"
grep -q "2D PRESENTATION AND OWNER-ART PRODUCTION ARE FROZEN" "$vl" \
	&& grep -q "NO 3D PIVOT AND NO 3D SPIKE IS" "$vl" \
	&& pass "the verification states the 2D freeze and that no 3D pivot or spike is authorized" \
	|| fail "the verification does not state the freeze and the 3D boundary"
grep -q "5.0 m/s REMAINS PROVISIONAL" "$vl" \
	&& pass "the verification states that 5.0 m/s is provisional, not a permanent lock" \
	|| fail "the verification does not state that 5.0 m/s is provisional"
grep -q "DOES NOT COMPLETE THE ORIGINAL P1C OR P1, AND DOES NOT AUTHORIZE P2" "$vl" \
	&& pass "the verification says out loud that P1C-H completes neither P1C nor P1, and authorizes no P2" \
	|| fail "the verification does not disclaim P1C/P1 completion or P2"
grep -q "TRANSFERRED: ORIGINAL P1C CRITERION C9" "$vl" \
	&& pass "C9 is printed as TRANSFERRED, never as a pass" \
	|| fail "C9 is not printed as transferred"

step "5. The accepted P1A and P1B suites still pass"
for s in p1a p1b; do
	if bash "$HERE/${s}_smoke.sh" > "$WORK/$s.log" 2>&1; then
		pass "$(echo "$s" | tr 'a-z' 'A-Z') suite: $(grep -oE "P1[AB] SMOKE: .*" "$WORK/$s.log" | head -1)"
	else
		fail "$(echo "$s" | tr 'a-z' 'A-Z') suite failed"
		grep -E "^  FAIL" "$WORK/$s.log" | head -5
	fi
done

step "Summary"
printf '  P1C-H is ACCEPTED and CLOSED under D-365, as the verified 2D MECHANICS PROTOTYPE\n'
printf '  \u2014 by the owner, after a review this runner cannot perform. A green runner is still\n'
printf '  not acceptance.\n'
printf '\n'
printf '  2D PRESENTATION AND OWNER-ART PRODUCTION ARE FROZEN (D-365). The intended final\n'
printf '  visual target is now a modern stylized 3D dark-fantasy ARPG with a fixed\n'
printf '  orthographic isometric camera. NO 3D PIVOT AND NO 3D SPIKE IS AUTHORIZED.\n'
printf '  `game2d/` is preserved as the accepted mechanics prototype; the existing 2D art\n'
printf '  remains valid prototype/reference material and is NOT rejected or deleted.\n'
printf '\n'
printf '  5.0 m/s REMAINS PROVISIONAL, not a permanent cross-presentation lock.\n'
printf '\n'
printf '  P1C-H IS THE HUNTRESS-FIRST SUBSTAGE. Carried OUT and never counted as passes:\n'
printf '    - original C9, the Mage spell;\n'
printf '    - the original "both characters at 128x128 and eight directions" scope.\n'
printf '  Both are owed by the already-recorded future Mage art phase.\n'
printf '\n'
printf '  COMPLETING P1C-H DOES NOT COMPLETE THE ORIGINAL P1C OR P1, AND DOES NOT\n'
printf '  AUTHORIZE P2. P2 additionally requires a canonical Huntress class specification,\n'
printf '  which remains a P2 prerequisite and which P1C-H does not write.\n'
printf '\n'
if [ "$FAILURES" = "0" ]; then printf 'P1C-H SMOKE: PASS\n'; else printf 'P1C-H SMOKE: %d FAILURE(S)\n' "$FAILURES"; fi
printf '\n--- the verification record, in full ---\n'
cat "$vl"
[ "$FAILURES" = "0" ] || exit 1
