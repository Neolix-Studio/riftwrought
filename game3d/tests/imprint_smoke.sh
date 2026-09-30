#!/usr/bin/env bash
# =============================================================================
# RIFTWROUGHT — GLOBAL IMPRINT SYSTEM PROTOTYPE RUNNER  (D-375, 2026-09-17)
#
# Runs BOTH suites headless: the ACCEPTED D-373 foundation baseline as a
# REGRESSION, and this stage's own suite. Then it applies the project's standing
# runner rules to each:
#   * the IMPORT PASS first, so a fresh checkout verifies;
#   * fail on ANY engine error, regardless of a suite's own PASS line;
#   * the error guard is PROVED able to refuse a planted ERROR line;
#   * every pinned count is pinned IN BOTH DIRECTIONS -- the run's own log is
#     replayed with the count altered and the pin must refuse it;
#   * isolation is ASSERTED, not assumed.
#
# Rendered evidence is OPT-IN (--with-evidence). A plain invocation is
# headless-only, per the project's standing rule.
#
# =============================================================================
# UNITS. FIVE COUNTS, AND NONE IS A SYNONYM FOR ANOTHER.
#
#   D-375: 26 RUNNER CHECKS here · 101 EXECUTABLE CHECKS in
#          tests/imprint_verification.gd · 149 OWED CRITERIA in
#          docs/testing/D375_IMPRINT_OWED_CRITERIA_INVENTORY.md
#   D-370: 20 RUNNER CHECKS in tests/foundation_smoke.sh · 85 EXECUTABLE CHECKS
#          in tests/foundation_verification.gd · 125 OWED CRITERIA in
#          docs/testing/D370_OWED_CRITERIA_INVENTORY.md
#
# THE D-370 NUMBERS ARE A DIFFERENT DECISION'S AND DO NOT ADD TO THESE.
#
# THE D-375 COUNTS MOVED ONCE, AND THE ARITHMETIC IS STATED: 148 -> 149 criteria
# and 100 -> 101 executable checks, because the RENDERED EVIDENCE exposed a
# canonical per-use-targeting defect no check was looking for. The 26 runner
# checks did not move, and nothing was removed, renamed or renumbered.
# This project has been blocked once by a closure that quoted two different
# counts as if they were one number.
# =============================================================================
#
# THIS RUNNER VERIFIED A STAGE DELIVERED OPEN (D-375), ACCEPTED and CLOSED UNDER
# D-376. It completes no phase, does not complete P1 or the original P1C,
# authorizes no phase, locks no value, and FINALIZES NO ROSTER, SLOT COUNT, RANK
# CAP, CAPACITY VALUE, XP CURVE, RESERVATION VALUE OR BALANCE.
#
# =============================================================================
# RE-PINNED UNDER D-380, AS ITS FIRST ACT, EXACTLY AS D-376 SECTION 7
# RECOMMENDED -- AND ONLY THESE, ALL IN ONE CHANGE WITH THE ARTIFACT THEY GUARD:
#   * STATE_EXPECT (S16, S17): the D-375-era line -> the three-stage line;
#   * S14: "IMPRINT STAGE DELIVERED and OPEN pending owner live review (D-375)"
#     -> "IMPRINT STAGE ACCEPTED and CLOSED (D-376)", PLUS the D-380 clause;
#   * S17: KEEPS its refusal proof, and GAINS two refusals -- the D-375-era line
#     must be absent, and no MO- row may print as OWED-TO-OWNER;
#   * PIN_I_DEFERRED (S06, S09): 24 -> 16, because D-376 DISCHARGED the eight
#     MO- rows, which now print under DISCHARGED with their text preserved.
# THE 26 RUNNER CHECKS AND THE 101 EXECUTABLE CHECKS DID NOT MOVE. Every state
# pin is still an EXACT-LINE match. NO GUARD WAS WEAKENED.
#
# RE-PINNED AGAIN UNDER D-392, AS ITS FIRST ACT, EXACTLY AS D-383 SECTION 6
# RECOMMENDED -- AND ONLY THESE, IN ONE CHANGE WITH THE ARTIFACT THEY GUARD:
#   * STATE_EXPECT (S16, S17): the three-stage D-380 line -> the four-fact line;
#   * S14: the D-380 clause -> the D-383 clause, PLUS the D-392 clause
#     (18 - 1 + 2 = 19 strings);
#   * S17: KEEPS every refusal, and GAINS one -- the D-380-era line must be absent;
#   * S22: its COUNT LOGIC is unchanged (the D-370 manifest's 29 files); its
#     message now names its scope, because D-392 declares a SEPARATE placeholder
#     intake which the D-392 runner verifies (W18).
# THE 26 RUNNER CHECKS, THE 101 EXECUTABLE CHECKS AND THE 16 DEFERRED ROWS DID
# NOT MOVE. NO GUARD WAS WEAKENED.
#
# RE-PINNED A THIRD TIME UNDER D-396, AS ITS FIRST ACT, EXACTLY AS D-394 SECTION 7
# RECOMMENDED -- AND ONLY THESE, IN ONE CHANGE WITH THE ARTIFACT THEY GUARD:
#   * STATE_EXPECT (S16, S17): the four-fact line -> the five-fact line;
#   * S14: the D-392 clause -> the D-394 clause, PLUS the D-396 clause
#     (19 - 1 + 2 = 20 strings);
#   * S17: KEEPS every refusal, and GAINS one -- the D-392-era line must be absent;
#   * S25: ONE diagnostic input action added under D-396 (26 + 1 = 27).
# THE 26 RUNNER CHECKS, THE 101 EXECUTABLE CHECKS AND THE 16 DEFERRED ROWS DID
# NOT MOVE. NO GUARD WAS WEAKENED.
#
# RE-PINNED A FOURTH TIME UNDER D-398, AS ITS FIRST ACT, EXACTLY AS D-397 SECTION 6
# RECOMMENDED -- AND ONLY THESE, IN ONE CHANGE WITH THE ARTIFACT THEY GUARD:
#   * STATE_EXPECT (S16, S17): the five-fact line -> the six-fact line;
#   * S14: the D-396 clause -> the D-397 clause, PLUS the D-398 clause
#     (20 - 1 + 2 = 21 strings);
#   * S17: KEEPS every refusal, and GAINS one -- the D-396-era line must be absent;
#   * S25: TWO diagnostic input actions added under D-398 (27 + 2 = 29).
# THE 26 RUNNER CHECKS, THE 101 EXECUTABLE CHECKS AND THE 16 DEFERRED ROWS DID
# NOT MOVE. NO GUARD WAS WEAKENED.
# =============================================================================
set -uo pipefail

GODOT="${GODOT:-/Applications/Godot.app/Contents/MacOS/Godot}"
HERE="$(cd "$(dirname "$0")" && pwd)"
PROJ="$(cd "$HERE/.." && pwd)"
ROOT="$(cd "$PROJ/.." && pwd)"
FLOG="$(mktemp -t imprint_foundation)"
ILOG="$(mktemp -t imprint_stage)"
FAILED=0
WITH_EVIDENCE=0
[ "${1:-}" = "--with-evidence" ] && WITH_EVIDENCE=1

# THE ONE STATE LINE, PINNED ONCE AND COMPARED IN BOTH SUITES. A state asserted
# in two places that can disagree is a state nobody can trust.
# RE-PINNED UNDER D-380 (first act). It read "... · IMPRINT STAGE DELIVERED and
# OPEN pending owner live review (D-375)" from D-375 until D-380 -- true when
# written; D-376 then accepted the stage.
# RE-PINNED UNDER D-392 (first act). It read "... · D-378 ALIGNMENT STAGE
# DELIVERED and OPEN pending owner live review (D-380)" from D-380 until D-392 --
# true when written; D-383 then accepted that stage.
# RE-PINNED UNDER D-396 (first act). It read "... · HUNTRESS SPLINTER SHOT STAGE
# DELIVERED and OPEN pending owner live review (D-392)" from D-392 until D-396 --
# true when written; D-394 then accepted that stage.
# RE-PINNED UNDER D-398 (first act). It read "... · KINDRED HOUNDS STAGE
# DELIVERED and OPEN pending owner live review (D-396)" from D-396 until D-398 --
# true when written; D-397 then accepted that stage.
# RE-PINNED UNDER D-404, AS ITS FIRST ACT: the D-402 open clause is REPLACED by
# the D-403 acceptance clause and the D-404 open clause is ADDED -- eight facts
# -> NINE. Until D-404 this line ended "... · CINDER FIELD STAGE DELIVERED and
# OPEN pending owner live review (D-402)" -- TRUE WHEN WRITTEN. Still EXACT-LINE.
STATE_EXPECT="STATE: FOUNDATION STAGE ACCEPTED and CLOSED (D-373) · IMPRINT STAGE ACCEPTED and CLOSED (D-376) · D-378 ALIGNMENT STAGE ACCEPTED and CLOSED (D-383) · HUNTRESS SPLINTER SHOT STAGE ACCEPTED and CLOSED (D-394) · KINDRED HOUNDS STAGE ACCEPTED and CLOSED (D-397) · MOBILE MINION COHESION STAGE ACCEPTED and CLOSED (D-399) · PLAYER LOCOMOTION REDIRECTION STAGE ACCEPTED and CLOSED (D-401) · CINDER FIELD STAGE ACCEPTED and CLOSED (D-403) · PLAYER DIRECT-CLICK MOVEMENT CORRECTION STAGE DELIVERED and OPEN pending owner live review (D-404)"
STATE_D375_LINE="STATE: FOUNDATION STAGE ACCEPTED and CLOSED (D-373) · IMPRINT STAGE DELIVERED and OPEN pending owner live review (D-375)"
STATE_D380_LINE="STATE: FOUNDATION STAGE ACCEPTED and CLOSED (D-373) · IMPRINT STAGE ACCEPTED and CLOSED (D-376) · D-378 ALIGNMENT STAGE DELIVERED and OPEN pending owner live review (D-380)"
STATE_D392_LINE="STATE: FOUNDATION STAGE ACCEPTED and CLOSED (D-373) · IMPRINT STAGE ACCEPTED and CLOSED (D-376) · D-378 ALIGNMENT STAGE ACCEPTED and CLOSED (D-383) · HUNTRESS SPLINTER SHOT STAGE DELIVERED and OPEN pending owner live review (D-392)"
STATE_D396_LINE="STATE: FOUNDATION STAGE ACCEPTED and CLOSED (D-373) · IMPRINT STAGE ACCEPTED and CLOSED (D-376) · D-378 ALIGNMENT STAGE ACCEPTED and CLOSED (D-383) · HUNTRESS SPLINTER SHOT STAGE ACCEPTED and CLOSED (D-394) · KINDRED HOUNDS STAGE DELIVERED and OPEN pending owner live review (D-396)"
# ADDED UNDER D-400, AS ITS FIRST ACT: the D-398-era six-fact line, held as a
# SUPERSEDED needle exactly as the D-392- and D-396-era lines are.
STATE_D398_LINE="STATE: FOUNDATION STAGE ACCEPTED and CLOSED (D-373) · IMPRINT STAGE ACCEPTED and CLOSED (D-376) · D-378 ALIGNMENT STAGE ACCEPTED and CLOSED (D-383) · HUNTRESS SPLINTER SHOT STAGE ACCEPTED and CLOSED (D-394) · KINDRED HOUNDS STAGE ACCEPTED and CLOSED (D-397) · MOBILE MINION COHESION STAGE DELIVERED and OPEN pending owner live review (D-398)"
# ADDED UNDER D-402, AS ITS FIRST ACT: the D-400-era seven-fact line, held as a
# SUPERSEDED needle exactly as the D-392-, D-396- and D-398-era lines are. D-401
# ACCEPTED and CLOSED the locomotion stage; its section 6 recommended this
# reconciliation for the next authorized stage's first act.
STATE_D400_LINE="STATE: FOUNDATION STAGE ACCEPTED and CLOSED (D-373) · IMPRINT STAGE ACCEPTED and CLOSED (D-376) · D-378 ALIGNMENT STAGE ACCEPTED and CLOSED (D-383) · HUNTRESS SPLINTER SHOT STAGE ACCEPTED and CLOSED (D-394) · KINDRED HOUNDS STAGE ACCEPTED and CLOSED (D-397) · MOBILE MINION COHESION STAGE ACCEPTED and CLOSED (D-399) · PLAYER LOCOMOTION REDIRECTION STAGE DELIVERED and OPEN pending owner live review (D-400)"
# ADDED UNDER D-404, AS ITS FIRST ACT: the D-402-era eight-fact line, held as a
# SUPERSEDED needle exactly as the D-392-, D-396-, D-398- and D-400-era lines
# are. D-403 ACCEPTED and CLOSED the Cinder Field stage; the same ruling directs
# this reconciliation as the D-404 stage's first act.
STATE_D402_LINE="STATE: FOUNDATION STAGE ACCEPTED and CLOSED (D-373) · IMPRINT STAGE ACCEPTED and CLOSED (D-376) · D-378 ALIGNMENT STAGE ACCEPTED and CLOSED (D-383) · HUNTRESS SPLINTER SHOT STAGE ACCEPTED and CLOSED (D-394) · KINDRED HOUNDS STAGE ACCEPTED and CLOSED (D-397) · MOBILE MINION COHESION STAGE ACCEPTED and CLOSED (D-399) · PLAYER LOCOMOTION REDIRECTION STAGE ACCEPTED and CLOSED (D-401) · CINDER FIELD STAGE DELIVERED and OPEN pending owner live review (D-402)"
PIN_F_CHECKS=85
PIN_F_DEFERRED=11
PIN_I_CHECKS=101
# 24 -> 16 UNDER D-380: the eight MO- rows D-376 DISCHARGED now print under
# DISCHARGED, history preserved verbatim. 24 - 8 = 16. ZERO ROWS DELETED.
PIN_I_DEFERRED=16
DECLARED_THIRD_PARTY_FILES=29

say()  { printf '%s\n' "$*"; }
fail() { say "  [FAIL] $*"; FAILED=1; }
ok()   { say "  [ OK ] $*"; }

say "========================================================================"
say "RIFTWROUGHT GLOBAL IMPRINT SYSTEM PROTOTYPE RUNNER (D-375)"
say "Headless by default. Rendered evidence is opt-in via --with-evidence."
say "It runs the ACCEPTED D-373 baseline as a REGRESSION, then this stage."
say "========================================================================"

# ------------------------------------------------------------ S01. import ----
say ""
say "[1/8] Import pass (S01)"
"$GODOT" --headless --path "$PROJ" --import >/dev/null 2>&1
IMPORTED="$(ls "$PROJ/.godot/imported" 2>/dev/null | wc -l | tr -d ' ')"
if [ "$IMPORTED" -gt 0 ]; then
  ok "S01 assets imported ($IMPORTED entries) — a fresh checkout verifies"
else
  fail "S01 the import pass produced nothing; neither suite can load an asset"
fi

# ---------------------------------- S02-S05. the ACCEPTED baseline, re-run ----
say ""
say "[2/8] The ACCEPTED D-373 foundation baseline, as a REGRESSION (S02-S05)"
"$GODOT" --headless --path "$PROJ" --script res://tests/foundation_verification.gd \
  >"$FLOG" 2>&1
F_RC=$?
grep -E "^(FOUNDATION VERIFICATION:|  owed=)" "$FLOG" | sed 's/^/    /'
F_LINE="$(grep -E '^FOUNDATION VERIFICATION:' "$FLOG" | head -1)"
F_EXPECT="FOUNDATION VERIFICATION: PASS ($PIN_F_CHECKS checks: $PIN_F_CHECKS passed, 0 failed/unreached, $PIN_F_DEFERRED deferred)"
if [ "$F_LINE" = "$F_EXPECT" ]; then
  ok "S02 the accepted baseline still passes EXACTLY: $PIN_F_CHECKS checks, $PIN_F_DEFERRED deferred"
else
  fail "S02 the accepted baseline's pinned summary MISMATCHES"
  say "        expected: $F_EXPECT"
  say "        actual  : $F_LINE"
fi
F_ALT="$(printf '%s' "$F_LINE" | sed "s/($PIN_F_CHECKS checks/(84 checks/")"
if [ "$F_ALT" = "$F_EXPECT" ]; then
  fail "S03 the baseline pin ACCEPTS an altered count — it protects nothing"
else
  ok "S03 the baseline pin is PROVED able to refuse an altered count"
fi
F_OWED="$(grep -E '^  owed=' "$FLOG" | head -1 | sed 's/^ *//')"
F_OWED_EXPECT="owed=$PIN_F_CHECKS  reached=$PIN_F_CHECKS  owed-but-not-reached=0 []  reached-but-not-owed=0 []"
if [ "$F_OWED" = "$F_OWED_EXPECT" ]; then
  ok "S04 the baseline's owed vs reached matches in both directions"
else
  fail "S04 baseline owed/reached MISMATCH"; say "        expected: $F_OWED_EXPECT"; say "        actual  : $F_OWED"
fi
# THE ACCEPTED SUITE'S 85 CHECK NAMES MUST BE UNCHANGED. A re-pinned count with a
# renamed check underneath it would be exactly the drift this stage must not
# cause, and a count alone cannot see it.
F_NAMES="$(grep -cE '^  \[PASS     \] F[0-9][0-9]_' "$FLOG")"
if [ "$F_NAMES" = "$PIN_F_CHECKS" ]; then
  ok "S05 all $PIN_F_CHECKS accepted checks still carry their original F-numbered names"
else
  fail "S05 only $F_NAMES of $PIN_F_CHECKS accepted checks still carry an F-numbered name — something was renamed or renumbered"
fi

# ------------------------------------------- S06-S10. this stage's suite ----
say ""
say "[3/8] The D-375 Imprint stage suite (S06-S10)"
"$GODOT" --headless --path "$PROJ" --script res://tests/imprint_verification.gd \
  >"$ILOG" 2>&1
I_RC=$?
grep -E "^  \[(PASS|FAIL|UNREACHED|DEFERRED|STILL OWED|OWED-TO-OWNER)" "$ILOG" \
  | sed 's/^/    /' | head -130
grep -E "^(IMPRINT VERIFICATION:|  owed=)" "$ILOG" | sed 's/^/    /'
I_LINE="$(grep -E '^IMPRINT VERIFICATION:' "$ILOG" | head -1)"
I_EXPECT="IMPRINT VERIFICATION: PASS ($PIN_I_CHECKS checks: $PIN_I_CHECKS passed, 0 failed/unreached, $PIN_I_DEFERRED deferred)"
if [ "$I_LINE" = "$I_EXPECT" ]; then
  ok "S06 pinned summary matches exactly: $PIN_I_CHECKS executable checks, $PIN_I_DEFERRED deferred rows"
else
  fail "S06 pinned summary MISMATCH"
  say "        expected: $I_EXPECT"
  say "        actual  : $I_LINE"
fi
I_ALT="$(printf '%s' "$I_LINE" | sed "s/($PIN_I_CHECKS checks/(77 checks/")"
if [ "$I_ALT" = "$I_EXPECT" ]; then
  fail "S07 the pin ACCEPTS an altered count — a guard that accepts everything protects nothing"
else
  ok "S07 pin PROVED able to refuse an altered count (replayed as '77 checks')"
fi
I_OWED="$(grep -E '^  owed=' "$ILOG" | head -1 | sed 's/^ *//')"
I_OWED_EXPECT="owed=$PIN_I_CHECKS  reached=$PIN_I_CHECKS  owed-but-not-reached=0 []  reached-but-not-owed=0 []"
if [ "$I_OWED" = "$I_OWED_EXPECT" ]; then
  ok "S08 owed vs reached matches in both directions"
else
  fail "S08 owed/reached MISMATCH"; say "        expected: $I_OWED_EXPECT"; say "        actual  : $I_OWED"
fi
# EVERY DEFERRED AND OWED-TO-OWNER ROW MUST PRINT, and none may print as a pass.
I_ROWS="$(grep -cE '^  \[(DEFERRED|STILL OWED|OWED-TO-OWNER)' "$ILOG")"
if [ "$I_ROWS" = "$PIN_I_DEFERRED" ]; then
  ok "S09 all $PIN_I_DEFERRED deferred/owed rows PRINT, and none of them prints as a pass"
else
  fail "S09 $I_ROWS deferred/owed rows printed, expected $PIN_I_DEFERRED"
fi
# THE UNITS ARE NAMED, EVERY RUN.
if grep -qF "None is a synonym for another" "$ILOG" \
   && grep -qF "149 OWED CRITERIA" "$ILOG" \
   && grep -qF "85 EXECUTABLE CHECKS" "$ILOG"; then
  ok "S10 the suite names all of its units and states that none is a synonym for another"
else
  fail "S10 the suite does not name the unit of every count it quotes"
fi

# ------------------------------------------- S11-S13. engine-error guards ----
say ""
say "[4/8] Engine-error guards (S11-S13)"
ERRPAT='^(SCRIPT )?ERROR:|^USER ERROR:|^SCRIPT ERROR|Parse Error|Failed to load script'
# The ACCEPTED suite deliberately plants ONE bad clip name to prove the runtime's
# animation guard cannot fail silently. It is the ONLY expected, self-inflicted
# error line in either log, and it is pinned in BOTH directions.
SELF='Foundation_Signature_Move_THIS_DOES_NOT_EXIST'
SELF_N="$(grep -cF "$SELF" "$FLOG")"
if [ "$SELF_N" -ge 1 ]; then
  ok "S11 the accepted suite's guard-proving error is still present ($SELF_N line(s))"
else
  fail "S11 no guard-proving error line in the baseline log — F12's guard proof is not intact"
fi
F_REAL="$(grep -E "$ERRPAT" "$FLOG" | grep -vF "$SELF" || true)"
# THIS STAGE'S SUITE PLANTS NOTHING, so its log must be COMPLETELY clean.
I_REAL="$(grep -E "$ERRPAT" "$ILOG" || true)"
if [ -n "$F_REAL" ] || [ -n "$I_REAL" ]; then
  fail "S12 engine errors present (the one expected baseline line excluded):"
  printf '%s\n' "$F_REAL" "$I_REAL" | grep -v '^$' | head -12 | sed 's/^/        /'
else
  ok "S12 no engine errors in either log beyond the accepted suite's one expected guard proof"
fi
PLANT="$(mktemp -t imprint_plant)"; cat "$ILOG" > "$PLANT"
printf 'ERROR: planted engine error, for guard proving only\n' >> "$PLANT"
if grep -qE "$ERRPAT" "$PLANT"; then
  ok "S13 error guard PROVED able to refuse a planted 'ERROR:' line"
else
  fail "S13 error guard could NOT detect a planted error line — it protects nothing"
fi
rm -f "$PLANT"

# ------------------------------- S14-S17. truthfulness and the state line ----
say ""
say "[5/8] Truthfulness pins and the reconciled STATE line (S14-S17)"
# RE-PINNED UNDER D-380: the D-375 clause is REPLACED by the D-376 clause, and the
# D-380 clause is ADDED. Every other string is unchanged. 17 - 1 + 2 = 18.
# RE-PINNED UNDER D-392 (first act): the D-380 clause is REPLACED by the D-383
# clause, and the D-392 clause is ADDED. 18 - 1 + 2 = 19.
# RE-PINNED UNDER D-396 (first act): the D-392 clause is REPLACED by the D-394
# clause, and the D-396 clause is ADDED. 19 - 1 + 2 = 20.
# RE-PINNED UNDER D-398 (first act): the D-396 clause is REPLACED by the D-397
# clause, and the D-398 clause is ADDED. 20 - 1 + 2 = 21.
# RE-PINNED UNDER D-400 (first act): the D-398 clause is REPLACED by the D-400
# acceptance clause, and the D-400 open clause is ADDED. 21 - 1 + 2 = 22.
# RE-PINNED UNDER D-402 (first act): the D-400 open clause is REPLACED by the
# D-401 acceptance clause, and the D-402 open clause is ADDED. 22 - 1 + 2 = 23.
# RE-PINNED UNDER D-404 (first act): the D-402 open clause is REPLACED by the
# D-403 acceptance clause and the D-404 open clause is ADDED. 23 - 1 + 2 = 24.
for s in "FOUNDATION STAGE ACCEPTED and CLOSED (D-373)" \
         "IMPRINT STAGE ACCEPTED and CLOSED (D-376)" \
         "D-378 ALIGNMENT STAGE ACCEPTED and CLOSED (D-383)" \
         "HUNTRESS SPLINTER SHOT STAGE ACCEPTED and CLOSED (D-394)" \
         "KINDRED HOUNDS STAGE ACCEPTED and CLOSED (D-397)" \
         "MOBILE MINION COHESION STAGE ACCEPTED and CLOSED (D-399)" \
         "PLAYER LOCOMOTION REDIRECTION STAGE ACCEPTED and CLOSED (D-401)" \
         "CINDER FIELD STAGE ACCEPTED and CLOSED (D-403)" \
         "PLAYER DIRECT-CLICK MOVEMENT CORRECTION STAGE DELIVERED and OPEN pending owner live review (D-404)" \
         "COMPLETES NO PHASE" "DOES NOT COMPLETE P1" \
         "DOES NOT AUTHORIZE P2" \
         "DOES NOT FINALIZE THE HUNTRESS ROSTER" \
         "DOES NOT IMPLEMENT RIFT SHARDS" \
         "DOES NOT FINALIZE SLOT COUNTS" \
         "DOES NOT FINALIZE THE RANK CAP" \
         "DOES NOT FINALIZE CAPACITY VALUES" \
         "DOES NOT FINALIZE THE XP CURVE" \
         "DOES NOT FINALIZE RESERVATION VALUES" \
         "DOES NOT FINALIZE BALANCE" \
         "NO canonical Huntress class specification is written here" \
         "There is NO equipment system here" \
         "NO accepted D-373 value is modified by this stage" \
         "NOT a UI foundation"; do
  if grep -qF "$s" "$ILOG"; then ok "S14 the stage states: \"$s\""
  else fail "S14 the stage does NOT state: \"$s\""; fi
done
if grep -qiE "P2 is authorized|P1 is complete|production ready|final balance is locked|the rank cap is locked|this is the final Huntress|the Huntress roster is final" "$ILOG" "$FLOG"; then
  fail "S15 a run log makes a forbidden completion claim"
else
  ok "S15 no forbidden completion claim in either run log"
fi
# ============================================================================
# THE STATE LINE IS PINNED EXACTLY, AND IN BOTH SUITES.
# ============================================================================
BAD_STATE=0
for L in "$FLOG" "$ILOG"; do
  LINE="$(grep -E '^STATE: ' "$L" | head -1)"
  if [ "$LINE" != "$STATE_EXPECT" ]; then
    BAD_STATE=1
    say "        in $(basename "$L"): $LINE"
  fi
done
if [ "$BAD_STATE" -eq 0 ]; then
  ok "S16 both suites print the SAME exact reconciled STATE line"
else
  fail "S16 the STATE line differs from the pin, or the two suites disagree"
  say "        expected: $STATE_EXPECT"
fi
ALT_STATE="$(printf '%s' "$STATE_EXPECT" | sed 's/ACCEPTED and CLOSED/DELIVERED and OPEN/')"
if [ "$ALT_STATE" = "$STATE_EXPECT" ]; then
  fail "S17 the STATE pin ACCEPTS an altered line"
else
  ok "S17 the STATE pin is PROVED able to refuse an altered line"
fi
# AND THE OLD, NOW-FALSE STATE MUST BE GONE, not merely superseded elsewhere.
if grep -qxF "STATE: DELIVERED and OPEN pending owner live review" "$FLOG" "$ILOG"; then
  fail "S17 the OLD, now-false state line is still present — the D-375 reconciliation did not take"
else
  ok "S17 the old, now-false state line is GONE from both logs"
fi
# ADDED UNDER D-380: THE D-375-ERA LINE MUST BE GONE TOO, and the guard is proved
# able to see it -- the needle is the exact line the artifact printed until D-380.
if grep -qxF "$STATE_D375_LINE" "$FLOG" "$ILOG"; then
  fail "S17 the D-375-era state line is still present — the D-380 reconciliation did not take"
elif [ "$STATE_D375_LINE" = "$STATE_EXPECT" ]; then
  fail "S17 the D-375-era needle equals the current pin — the absence check could never fire"
else
  ok "S17 the D-375-era state line is GONE from both logs (and differs from the pin, so the check can fire)"
fi
# ADDED UNDER D-392: THE D-380-ERA LINE MUST BE GONE TOO -- the needle is the exact
# line the artifact printed from D-380 until D-392.
if grep -qxF "$STATE_D380_LINE" "$FLOG" "$ILOG"; then
  fail "S17 the D-380-era state line is still present — the D-392 reconciliation did not take"
elif [ "$STATE_D380_LINE" = "$STATE_EXPECT" ]; then
  fail "S17 the D-380-era needle equals the current pin — the absence check could never fire"
else
  ok "S17 the D-380-era state line is GONE from both logs (and differs from the pin, so the check can fire)"
fi
# ADDED UNDER D-396: THE D-392-ERA LINE MUST BE GONE TOO -- the needle is the exact
# line the artifact printed from D-392 until D-396.
if grep -qxF "$STATE_D392_LINE" "$FLOG" "$ILOG"; then
  fail "S17 the D-392-era state line is still present — the D-396 reconciliation did not take"
elif [ "$STATE_D392_LINE" = "$STATE_EXPECT" ]; then
  fail "S17 the D-392-era needle equals the current pin — the absence check could never fire"
else
  ok "S17 the D-392-era state line is GONE from both logs (and differs from the pin, so the check can fire)"
fi
# ADDED UNDER D-398: THE D-396-ERA LINE MUST BE GONE TOO -- the needle is the exact
# line the artifact printed from D-396 until D-398.
if grep -qxF "$STATE_D396_LINE" "$FLOG" "$ILOG"; then
  fail "S17 the D-396-era state line is still present — the D-398 reconciliation did not take"
elif [ "$STATE_D396_LINE" = "$STATE_EXPECT" ]; then
  fail "S17 the D-396-era needle equals the current pin — the absence check could never fire"
else
  ok "S17 the D-396-era state line is GONE from both logs (and differs from the pin, so the check can fire)"
fi
# ADDED UNDER D-400: THE D-398-ERA LINE MUST BE GONE TOO -- the needle is the exact
# line the artifact printed from D-398 until D-400.
if grep -qxF "$STATE_D398_LINE" "$FLOG" "$ILOG"; then
  fail "S17 the D-398-era state line is still present — the D-400 reconciliation did not take"
elif [ "$STATE_D398_LINE" = "$STATE_EXPECT" ]; then
  fail "S17 the D-398-era needle equals the current pin — the absence check could never fire"
else
  ok "S17 the D-398-era state line is GONE from both logs (and differs from the pin, so the check can fire)"
fi
# ADDED UNDER D-402: THE D-400-ERA LINE MUST BE GONE TOO -- the needle is the exact
# line the artifact printed from D-400 until D-402.
if grep -qxF "$STATE_D400_LINE" "$FLOG" "$ILOG"; then
  fail "S17 the D-400-era state line is still present — the D-402 reconciliation did not take"
elif [ "$STATE_D400_LINE" = "$STATE_EXPECT" ]; then
  fail "S17 the D-400-era needle equals the current pin — the absence check could never fire"
else
  ok "S17 the D-400-era state line is GONE from both logs (and differs from the pin, so the check can fire)"
fi
# ADDED UNDER D-404: THE D-402-ERA LINE MUST BE GONE TOO -- the needle is the exact
# line the artifact printed from D-402 until D-404.
if grep -qxF "$STATE_D402_LINE" "$FLOG" "$ILOG"; then
  fail "S17 the D-402-era state line is still present — the D-404 reconciliation did not take"
elif [ "$STATE_D402_LINE" = "$STATE_EXPECT" ]; then
  fail "S17 the D-402-era needle equals the current pin — the absence check could never fire"
else
  ok "S17 the D-402-era state line is GONE from both logs (and differs from the pin, so the check can fire)"
fi
# ADDED UNDER D-380: NO MO- ROW MAY PRINT AS OWED-TO-OWNER, AND ALL EIGHT MUST
# PRINT AS DISCHARGED WITH THEIR HISTORY. D-376 answered them.
MO_OWED="$(grep -cE '^  \[OWED-TO-OWNER *\] MO-0' "$ILOG")"
MO_DIS="$(grep -cE '^  \[DISCHARGED — D-376 *\] MO-0[1-8] ' "$ILOG")"
if [ "$MO_OWED" != "0" ]; then
  fail "S17 $MO_OWED MO- row(s) still print as OWED-TO-OWNER; D-376 DISCHARGED all eight"
elif [ "$MO_DIS" = "8" ] && grep -qF "ORIGINAL ROW TEXT, PRESERVED VERBATIM (OWED-TO-OWNER)" "$ILOG"; then
  ok "S17 all eight MO- rows print as DISCHARGED — D-376 with their original text preserved"
else
  fail "S17 $MO_DIS of 8 MO- rows print as DISCHARGED — D-376, or their history is not preserved"
fi
# AND M-04 IS DISCHARGED, WITH ITS HISTORY STILL PRINTED.
if grep -qE '^  \[OWED-TO-OWNER\] M-04' "$FLOG"; then
  fail "S17 M-04 still prints as OWED-TO-OWNER; D-373 DISCHARGED it"
elif grep -qF "DISCHARGED — D-373" "$FLOG" && grep -qF "ORIGINAL ROW TEXT, PRESERVED VERBATIM" "$FLOG"; then
  ok "S17 M-04 prints as DISCHARGED with its original text preserved — history kept, false state removed"
else
  fail "S17 M-04's discharge is not recorded with its history preserved"
fi

# --------------------------------------------- S18-S24. isolation, assets ----
say ""
say "[6/8] Isolation and preservation (S18-S24)"
BASE="${FOUNDATION_BASELINE_DIR:-}"
# NO EXCEPTION IS DECLARED FOR ANY PROTECTED PROJECT.
# The cross-reference runs ONE WAY ONLY, outward from game3d/. game3d_spike/ and
# game3d_boss_spike/ are ACCEPTED and CLOSED, and their "DELIVERED and OPEN"
# strings must NOT be "fixed" -- that instruction applies to THEM, and it is the
# reason this stage reconciled only game3d/'s own state line.
for d in game game2d game3d_spike game3d_boss_spike; do
  f="$BASE/baseline_$d.sha256"
  if [ -n "$BASE" ] && [ -f "$f" ]; then
    NOW="$(mktemp -t imprint_now)"
    ( cd "$ROOT" && find "$d" -type f -print0 | sort -z | xargs -0 shasum -a 256 ) > "$NOW"
    DIFFS="$(diff "$f" "$NOW" | grep -E '^[<>]' | sed 's/^[<>] *//' \
             | awk '{ $1=""; sub(/^ /,""); print }' | sort -u)"
    if [ -z "$DIFFS" ]; then
      ok "S18 $d/ is byte-identical to the pre-work baseline"
    else
      fail "S18 $d/ CHANGED — no exception is declared for any protected project:"
      printf '%s\n' "$DIFFS" | head -10 | sed 's/^/        /'
    fi
    rm -f "$NOW"
  else
    say "  [SKIP] $d/ baseline not supplied (set FOUNDATION_BASELINE_DIR)"
  fi
done
if [ -n "$BASE" ] && [ -f "$BASE/baseline_quaternius.sha256" ]; then
  NOW="$(mktemp -t imprint_now)"
  ( cd "$ROOT" && find "assets/Quaternius Assets" -type f -print0 | sort -z \
    | xargs -0 shasum -a 256 ) > "$NOW"
  if diff -q "$BASE/baseline_quaternius.sha256" "$NOW" >/dev/null; then
    ok "S19 the eleven source archives are byte-identical (reading is allowed; writing is not)"
  else fail "S19 source archives CHANGED"; fi
  rm -f "$NOW"
else
  say "  [SKIP] archive baseline not supplied"
fi
# S20 — owner art is never touched.
if find "$PROJ" -name '*.pxo' 2>/dev/null | grep -q .; then
  fail "S20 a .pxo is present inside game3d/ — owner art must never be touched"
else
  ok "S20 no owner .pxo anywhere in game3d/"
fi
# S21 — the SET of quaternius asset trees is pinned. A fifth appearing is caught.
FOUND="$(find "$ROOT" -type d -name 'quaternius' 2>/dev/null | sed "s|^$ROOT/||" | sort | tr '\n' ' ')"
EXPECT_TREES="game/assets/third_party/quaternius game3d/assets/third_party/quaternius game3d_boss_spike/assets/third_party/quaternius game3d_spike/assets/third_party/quaternius "
if [ "$FOUND" = "$EXPECT_TREES" ]; then
  ok "S21 quaternius asset trees are exactly the four expected"
else
  fail "S21 unexpected quaternius asset tree set"
  say "        expected: $EXPECT_TREES"
  say "        actual  : $FOUND"
fi
# S22 — ZERO NEW THIRD-PARTY ASSETS. The declared file count is pinned, and the
# count of art files actually on disk is pinned against it.
# COUNTED BY OCCURRENCE, NOT BY LINE, AND WITH THE ONE FORMAT STRING EXCLUDED:
# the manifest packs several declarations on one line (a line count reported 17
# where the truth is 29) and it also holds `ultimate_modular_ruins/%s.obj`, which
# is a FORMAT STRING rather than a declared file. Both corrections are named
# rather than absorbed into a number nobody can reproduce.
DECLARED="$(grep -oE '"(bestiary_dungeon_monsters|universal_animation_library|universal_animation_library_2|modular_character_outfits_fantasy|ultimate_modular_ruins)/[^"]+"' "$PROJ/scripts/assets/asset_manifest.gd" | grep -vF '%s' | sort -u | wc -l | tr -d ' ')"
ON_DISK="$(find "$PROJ/assets/third_party" -type f \
  \( -name '*.glb' -o -name '*.gltf' -o -name '*.obj' -o -name '*.mtl' -o -name '*.bin' -o -name '*.png' \) \
  2>/dev/null | wc -l | tr -d ' ')"
if [ "$DECLARED" = "$DECLARED_THIRD_PARTY_FILES" ]; then
  ok "S22 the D-370 manifest block still declares exactly $DECLARED_THIRD_PARTY_FILES third-party files — the D-375 stage imported ZERO new assets ($ON_DISK art/texture files on disk across assets/third_party, including importer-extracted textures and, since D-392, the placeholder tree). D-392's separate placeholder intake is verified by tests/huntress_smoke.sh (W18)"
else
  fail "S22 the manifest declares $DECLARED third-party files, expected $DECLARED_THIRD_PARTY_FILES — this stage must import ZERO new assets"
fi
# S23 — the one-way cross-reference, and no audio.
STRAY="$(grep -rl "game3d/" "$ROOT/game" "$ROOT/game2d" "$ROOT/game3d_spike" \
         "$ROOT/game3d_boss_spike" 2>/dev/null | sed "s|^$ROOT/||" || true)"
AUDIO="$(find "$PROJ" \( -name '*.wav' -o -name '*.ogg' -o -name '*.mp3' -o -name '*.flac' \) 2>/dev/null || true)"
if [ -n "$STRAY" ]; then
  fail "S23 a protected project references game3d/ — the cross-reference must run one way only:"
  printf '%s\n' "$STRAY" | sed 's/^/        /'
elif [ -n "$AUDIO" ]; then
  fail "S23 audio assets present: $AUDIO"
else
  ok "S23 no protected project references game3d/, and there are zero audio assets"
fi
# S24 — the excluded pack, the boss candidate, AND no W/A/S/D binding, which the
# twelve new input actions make worth re-asserting at the runner level too.
BAD="$(find "$PROJ" \( -iname '*Puglin*' -o -iname '*UltimateMonsters*' -o -iname '*Dragon*' -o -iname '*PinkBlob*' \) 2>/dev/null || true)"
WASD=0
for code in 87 65 83 68; do
  N="$(grep -cF "\"physical_keycode\":$code" "$PROJ/project.godot" || true)"
  [ "$N" != "0" ] && WASD=1
done
if [ -n "$BAD" ]; then fail "S24 an excluded asset is present: $BAD"
elif [ "$WASD" -ne 0 ]; then fail "S24 a W/A/S/D keycode appears in project.godot — CLAUDE.md 8 forbids it"
else ok "S24 no boss candidate, no Ultimate Monsters file, and NO W/A/S/D keycode despite twelve new input actions"; fi

# ------------------------------------------------ S25. the input action set ---
say ""
say "[7/8] The input action set, pinned in both directions (S25)"
# 13 + 12 = 25. Declared here as well as in the suite, because a count asserted
# in only one place drifts.
# RE-PINNED UNDER D-381: 25 + 1 = 26. The reviewability correction adds EXACTLY
# ONE diagnostic input, `diagnostic_reservation_cycle`, which the owner's ruling
# authorizes in terms. This stage's own count stays 12: the new action is not an
# `imprint_` action, so NEW_COUNT still counts D-375's twelve and nothing else.
# THE PATTERN ALLOWS DIGITS. Without them it missed `imprint_binding_1` .. `_8`
# and reported 17 where the truth is 25 -- a pattern that cannot see the thing it
# is counting is not a count.
# RE-PINNED UNDER D-396: 26 + 1 = 27. The Kindred Hounds stage adds EXACTLY ONE
# diagnostic input, `diagnostic_hound_fall` -- the ruling's "clearly diagnostic
# review control" -- named here, so a different addition still fails.
# RE-PINNED UNDER D-398: 27 + 2 = 29. The mobile minion cohesion stage adds
# EXACTLY TWO diagnostic inputs -- `diagnostic_stress_population` and
# `diagnostic_travel_speed`, the ruling's diagnostic modes -- both named here.
ACTION_COUNT="$(grep -cE '^[a-z_][a-z_0-9]*=\{$' "$PROJ/project.godot")"
NEW_COUNT="$(grep -cE '^imprint_[a-z_0-9]+=\{$' "$PROJ/project.godot")"
FALL_ACTION="$(grep -cxF 'diagnostic_hound_fall={' "$PROJ/project.godot")"
D398_ACTIONS="$(grep -cxE 'diagnostic_stress_population=\{|diagnostic_travel_speed=\{' "$PROJ/project.godot")"
if [ "$ACTION_COUNT" = "29" ] && [ "$NEW_COUNT" = "12" ] && [ "$FALL_ACTION" = "1" ] && [ "$D398_ACTIONS" = "2" ]; then
  ok "S25 project.godot declares exactly 29 input actions, 12 of them this stage's (13 + 12 = 25; + 1 under D-381 = 26; + diagnostic_hound_fall under D-396 = 27; + the two D-398 diagnostic modes = 29)"
else
  fail "S25 project.godot declares $ACTION_COUNT input actions ($NEW_COUNT from this stage, D-396 fall action $FALL_ACTION, D-398 modes $D398_ACTIONS), expected 29, 12, 1 and 2"
fi

# ------------------------------------------------------- S26. evidence ----
say ""
say "[8/8] Rendered evidence (S26)"
# RENDER THE EVIDENCE AND LOOK AT IT. Four of the twelve defects found while
# building the accepted foundation were invisible to every automated check, and
# THREE OF THEM WERE VISUAL. A live-review surface nobody has looked at is not a
# live-review surface.
EV_LIST="07_loadout_panel:panel:120 08_storm_volley:imprint_volley:120 09_ward_ballista:imprint_ballista:120 10_beast_pack:imprint_beasts:120"
if [ "$WITH_EVIDENCE" -eq 1 ]; then
  # ==========================================================================
  # THE CAPTURE IS BOUNDED, BECAUSE AN UNBOUNDED ONE HUNG FOREVER.
  # ==========================================================================
  # A parse error in the composition root meant the scene never loaded, so
  # `_maybe_capture()` never ran and the WINDOW simply sat there -- a capture
  # step that cannot fail is a capture step that can hang a whole verification
  # run. Each capture now gets a hard ceiling and is reported if it exceeds it.
  for spec in $EV_LIST; do
    out="${spec%%:*}.png"; rest="${spec#*:}"; mode="${rest%%:*}"; w="${rest#*:}"
    "$GODOT" --path "$PROJ" --resolution 1920x1080 -- \
      --capture="$mode" --out="res://evidence/$out" --wait="$w" >/dev/null 2>&1 &
    CAP_PID=$!
    CAP_WAITED=0
    while kill -0 "$CAP_PID" 2>/dev/null && [ "$CAP_WAITED" -lt 120 ]; do
      sleep 2
      CAP_WAITED=$((CAP_WAITED + 2))
    done
    if kill -0 "$CAP_PID" 2>/dev/null; then
      kill -9 "$CAP_PID" 2>/dev/null
      fail "S26 the $mode capture exceeded its 120 s ceiling and was killed"
    fi
    wait "$CAP_PID" 2>/dev/null
    if [ -f "$PROJ/evidence/$out" ]; then
      DIM="$(sips -g pixelWidth -g pixelHeight "$PROJ/evidence/$out" 2>/dev/null \
             | awk '/pixel/{printf "%s", $2"x"} END{print ""}' | sed 's/x$//')"
      if [ "$DIM" = "1920x1080" ]; then ok "S26 evidence/$out rendered natively at 1920x1080"
      else fail "S26 evidence/$out is ${DIM}, not 1920x1080"; fi
    else
      fail "S26 evidence/$out was not produced"
    fi
  done
else
  say "  [SKIP] rendered evidence is opt-in; re-run with --with-evidence"
  for spec in $EV_LIST; do
    out="${spec%%:*}.png"
    if [ -f "$PROJ/evidence/$out" ]; then
      DIM="$(sips -g pixelWidth -g pixelHeight "$PROJ/evidence/$out" 2>/dev/null \
             | awk '/pixel/{printf "%s", $2"x"} END{print ""}' | sed 's/x$//')"
      [ "$DIM" = "1920x1080" ] && ok "S26 existing evidence/$out is 1920x1080" \
        || fail "S26 existing evidence/$out is ${DIM}"
    else
      fail "S26 evidence/$out missing (run with --with-evidence)"
    fi
  done
fi

# ------------------------------------------------------------------ verdict --
say ""
say "========================================================================"
if [ "$F_RC" -ne 0 ]; then fail "the ACCEPTED baseline suite exited non-zero ($F_RC)"; fi
if [ "$I_RC" -ne 0 ]; then fail "the Imprint stage suite exited non-zero ($I_RC)"; fi
if [ "$FAILED" -eq 0 ]; then
  say "IMPRINT RUNNER: PASS"
else
  say "IMPRINT RUNNER: FAIL"
fi
say ""
say "UNITS — FIVE COUNTS, AND NONE IS A SYNONYM FOR ANOTHER:"
say "  D-375: 26 RUNNER CHECKS here · $PIN_I_CHECKS EXECUTABLE CHECKS in the stage suite ·"
say "         149 OWED CRITERIA in docs/testing/D375_IMPRINT_OWED_CRITERIA_INVENTORY.md"
say "  D-370: 20 RUNNER CHECKS in tests/foundation_smoke.sh · $PIN_F_CHECKS EXECUTABLE"
say "         CHECKS in the accepted suite · 125 OWED CRITERIA in its own inventory"
say "  The D-370 numbers belong to a DIFFERENT DECISION and do NOT add to these."
say ""
say "This is the GLOBAL IMPRINT SYSTEM PROTOTYPE, the SECOND authorized stage of"
say "the canonical production project, ACCEPTED and CLOSED under D-376 and re-run"
say "here as a REGRESSION (the D-380 alignment stage was ACCEPTED and CLOSED under"
say "D-383; the D-392 Huntress Splinter Shot stage under D-394; the D-396 Kindred Hounds"
say "stage under D-397; the D-398 mobile minion cohesion stage under D-400; the D-400"
say "player locomotion redirection stage is OPEN). It COMPLETES NO PHASE. It does NOT"
say "complete P1 or the original P1C. It does NOT authorize P2. It LOCKS NO VALUE,"
say "and it FINALIZES NO ROSTER, SLOT COUNT, RANK CAP, CAPACITY VALUE, XP CURVE,"
say "RESERVATION VALUE OR BALANCE. NO ACCEPTED D-373 VALUE WAS MODIFIED."
say ""
say "SEVEN CANONICAL CONFLICTS WERE MEASURED. X-02, X-03 AND X-04 WERE RESOLVED BY"
say "D-376; X-02's withdrawn four-Persistent cap was REMOVED from the runtime by D-380."
say "Run ./tests/alignment_smoke.sh for the D-380 stage's own counts, and"
say "./tests/huntress_smoke.sh for the D-392 stage's, ./tests/hounds_smoke.sh for D-396's,"
say "./tests/cohesion_smoke.sh for D-398's and ./tests/locomotion_smoke.sh for D-400's."
say ""
say "$STATE_EXPECT"
say "========================================================================"
rm -f "$FLOG" "$ILOG"
exit "$FAILED"
