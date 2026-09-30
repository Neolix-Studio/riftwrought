#!/usr/bin/env bash
# =============================================================================
# RIFTWROUGHT — 3D PRODUCTION FOUNDATION RUNNER  (D-370, 2026-09-17)
#
# Runs the foundation's verification suite HEADLESS by default, then applies the
# project's standing runner rules:
#   * run the IMPORT PASS first, so a fresh checkout verifies instead of failing
#     on unimported assets;
#   * fail on ANY engine error, regardless of the suite's own PASS line;
#   * the error guard is PROVED able to refuse a planted ERROR line every run;
#   * every pinned count is pinned IN BOTH DIRECTIONS -- the run's own log is
#     replayed with the count altered and the pin must refuse it;
#   * isolation is ASSERTED, not assumed: game/, game2d/, game3d_spike/,
#     game3d_boss_spike/ and the source archives must be byte-identical.
#
# Rendered evidence is OPT-IN (--with-evidence). A plain invocation is
# headless-only, per the project's standing rule.
#
# ============================================================================
# UNITS. This runner makes 20 RUNNER CHECKS. The suite runs 85 EXECUTABLE
# CHECKS. The D-370 owed-criteria inventory lists 125 OWED CRITERIA. THREE
# DIFFERENT UNITS; none is a synonym for another.
# (70/110 at first delivery; +8 at the D-370 owner live review, which required an
#  action-movement commitment policy; +7 at the live RE-review, which required
#  recovery cancellation.)
#
# THE D-375 IMPRINT STAGE HAS ITS OWN THREE COUNTS, in its own inventory, its own
# suite and its own runner. They are SEPARATE UNITS and they do not add to these.
#
# RE-PINNED UNDER D-375, AND ONLY THESE TWO THINGS: the STATE line and the
# deferred-row count (12 -> 11, because D-373 DISCHARGED M-04). The 20 runner
# checks and the 85 executable checks did NOT move. This is the repair D-373
# section 6.1 recommended and the D-375 ruling authorized.
#
# RE-PINNED AGAIN UNDER D-380, AS ITS FIRST ACT, AND ONLY R08: its STATE line
# (the D-375-era line -> the three-stage line), its truthfulness strings (the
# D-375 clause -> the D-376 clause, plus the D-380 clause), and one ADDED refusal
# (the D-375-era line must be absent). This is the repair D-376 section 7
# recommended and the D-380 ruling authorized. The 20 runner checks, the 85
# executable checks and the 11 deferred rows did NOT move, and
# tests/foundation_verification.gd is NOT EDITED AT ALL.
#
# RE-PINNED A THIRD TIME UNDER D-392, AS ITS FIRST ACT, AND ONLY R08: its STATE
# line (the three-stage D-380 line -> the four-fact line), its truthfulness
# strings (the D-380 clause -> the D-383 clause, plus the D-392 clause:
# 14 - 1 + 2 = 15), and one ADDED refusal (the D-380-era line must be absent).
# This is the repair D-383 section 6 recommended and the D-392 ruling
# authorized. The 20 runner checks, the 85 executable checks and the 11 deferred
# rows did NOT move. (tests/foundation_verification.gd WAS edited under D-392,
# ONLY inside F04 -- see that check; true of D-380, "NOT EDITED AT ALL", when
# written.)
#
# RE-PINNED A FOURTH TIME UNDER D-396, AS ITS FIRST ACT, AND ONLY R08 (the
# five-fact line; 15 - 1 + 2 = 16; the D-392-era line must be absent).
#
# RE-PINNED A FIFTH TIME UNDER D-398, AS ITS FIRST ACT, AND ONLY R08: its STATE
# line (the five-fact D-396 line -> the six-fact line), its truthfulness strings
# (the D-396 clause -> the D-397 clause, plus the D-398 clause: 16 - 1 + 2 = 17),
# and one ADDED refusal (the D-396-era line must be absent). This is the repair
# D-397 section 6 recommended and the D-398 ruling authorized. The 20 runner
# checks, the 85 executable checks and the 11 deferred rows did NOT move.
# ============================================================================
#
# THIS RUNNER VERIFIES THE ACCEPTED D-373 FOUNDATION BASELINE. It completes no
# phase, does not complete P1 or the original P1C, authorizes no phase, and locks
# no value.
# =============================================================================
set -uo pipefail

GODOT="${GODOT:-/Applications/Godot.app/Contents/MacOS/Godot}"
HERE="$(cd "$(dirname "$0")" && pwd)"
PROJ="$(cd "$HERE/.." && pwd)"
ROOT="$(cd "$PROJ/.." && pwd)"
LOG="$(mktemp -t foundation_run)"
FAILED=0
WITH_EVIDENCE=0
[ "${1:-}" = "--with-evidence" ] && WITH_EVIDENCE=1

say()  { printf '%s\n' "$*"; }
fail() { say "  [FAIL] $*"; FAILED=1; }
ok()   { say "  [ OK ] $*"; }

say "========================================================================"
say "RIFTWROUGHT 3D PRODUCTION FOUNDATION RUNNER (D-370)"
say "Headless by default. Rendered evidence is opt-in via --with-evidence."
say "========================================================================"

# ------------------------------------------------------------ R01. import ----
say ""
say "[1/7] Import pass (R01)"
# A FRESH CHECKOUT HAS NO .godot/. Running the suite first in that state fails
# with 'No loader found for resource' on every asset -- which reads exactly like
# a broken project. Importing first makes the runner work from a clean tree.
"$GODOT" --headless --path "$PROJ" --import >/dev/null 2>&1
IMPORTED="$(ls "$PROJ/.godot/imported" 2>/dev/null | wc -l | tr -d ' ')"
if [ "$IMPORTED" -gt 0 ]; then
  ok "assets imported ($IMPORTED entries) — a fresh checkout verifies"
else
  fail "the import pass produced nothing; the suite cannot load any asset"
fi

# --------------------------------------------------------------- R02. run ----
say ""
say "[2/7] Running the verification suite, headless (R02)"
"$GODOT" --headless --path "$PROJ" --script res://tests/foundation_verification.gd \
  >"$LOG" 2>&1
SUITE_RC=$?
grep -E "^  \[(PASS|FAIL|UNREACHED|DEFERRED|TRANSFERRED|STILL OWED|OWED-TO-OWNER)" "$LOG" \
  | sed 's/^/    /'
grep -E "^(OWED vs REACHED|  owed=|FOUNDATION VERIFICATION:|STATE:)" "$LOG" | sed 's/^/    /'

# ------------------------------------------------------- R03/R04. errors ----
say ""
say "[3/7] Engine-error guard (R03, R04)"
# Anchored to line start so the suite's own prose about errors cannot trip it.
ERRPAT='^(SCRIPT )?ERROR:|^USER ERROR:|^SCRIPT ERROR|Parse Error|Failed to load script'
# Check F12 DELIBERATELY plants one bad clip name to prove the runtime's
# animation guard cannot fail silently. That guard's push_error is therefore an
# EXPECTED, SELF-INFLICTED line. It is pinned in BOTH directions: it must be
# present (or F12 proved nothing) and it is the ONLY line excluded from the
# engine-error scan (so the exclusion cannot hide a real error).
SELF='Foundation_Signature_Move_THIS_DOES_NOT_EXIST'
SELF_N="$(grep -cF "$SELF" "$LOG")"
if [ "$SELF_N" -ge 1 ]; then
  ok "the expected self-inflicted guard-proving error is present ($SELF_N line(s))"
else
  fail "no guard-proving error line found — F12's guard proof is not intact"
fi
REAL="$(grep -E "$ERRPAT" "$LOG" | grep -vF "$SELF" || true)"
if [ -n "$REAL" ]; then
  fail "engine errors present in the run log (excluding the one expected line):"
  printf '%s\n' "$REAL" | head -10 | sed 's/^/        /'
else
  ok "no engine errors in the run log beyond the expected guard proof"
fi
# A GUARD NOTHING CAN REACH IS NOT A GUARD: prove it refuses a planted line.
PLANT="$(mktemp -t foundation_plant)"; cat "$LOG" > "$PLANT"
printf 'ERROR: planted engine error, for guard proving only\n' >> "$PLANT"
if grep -qE "$ERRPAT" "$PLANT"; then
  ok "error guard PROVED able to refuse a planted 'ERROR:' line"
else
  fail "error guard could NOT detect a planted error line — it protects nothing"
fi
rm -f "$PLANT"

# ------------------------------------------------- R05/R06/R07. count pins ----
say ""
say "[4/7] Count pins, in BOTH directions (R05, R06, R07)"
PIN_CHECKS=85
# ============================================================================
# 12 -> 11, RE-PINNED UNDER D-375 IN THE SAME CHANGE AS THE STATE STRING.
# ============================================================================
# `M-04` was DISCHARGED by D-373's final live review and now prints under the
# suite's DISCHARGED_ROWS heading instead of as OWED-TO-OWNER. D-373 section 6.1
# declared this discrepancy rather than hiding it and RECOMMENDED -- explicitly
# NOT authorizing -- that the next authorized stage fix the string and re-pin the
# count TOGETHER. The D-375 ruling authorizes exactly that.
#
# 85 EXECUTABLE CHECKS DID NOT MOVE. Nothing was removed, renamed or renumbered.
PIN_DEFERRED=11
LINE="$(grep -E '^FOUNDATION VERIFICATION:' "$LOG" | head -1)"
EXPECT="FOUNDATION VERIFICATION: PASS ($PIN_CHECKS checks: $PIN_CHECKS passed, 0 failed/unreached, $PIN_DEFERRED deferred)"
if [ "$LINE" = "$EXPECT" ]; then
  ok "pinned summary matches exactly: $PIN_CHECKS executable checks, $PIN_DEFERRED deferred rows"
else
  fail "pinned summary MISMATCH"
  say "        expected: $EXPECT"
  say "        actual  : $LINE"
fi
# Replay the run's OWN log with the count altered; the pin MUST refuse it.
ALT="$(printf '%s' "$LINE" | sed "s/($PIN_CHECKS checks/(99 checks/")"
if [ "$ALT" = "$EXPECT" ]; then
  fail "the pin ACCEPTS an altered count — a guard that accepts everything protects nothing"
else
  ok "pin PROVED able to refuse an altered count (replayed as '99 checks')"
fi
OWED_LINE="$(grep -E '^  owed=' "$LOG" | head -1 | sed 's/^ *//')"
OWED_EXPECT="owed=$PIN_CHECKS  reached=$PIN_CHECKS  owed-but-not-reached=0 []  reached-but-not-owed=0 []"
if [ "$OWED_LINE" = "$OWED_EXPECT" ]; then
  ok "owed vs reached matches in both directions"
else
  fail "owed/reached MISMATCH"; say "        expected: $OWED_EXPECT"; say "        actual  : $OWED_LINE"
fi
# THE UNITS ARE NAMED, EVERY RUN. This project has been blocked once already by
# a closure that quoted two different counts as if they were one number.
if grep -qF "Different unit." "$LOG"; then
  ok "the suite names the unit of its own count (85 executable checks, not 125 criteria)"
else
  fail "the suite does not name the unit of its count"
fi

# ------------------------------------------------- R08/R09. truthfulness ----
say ""
say "[5/7] Truthfulness pins (R08, R09)"
# RE-PINNED UNDER D-380: the D-375 clause is REPLACED by the D-376 clause and the
# D-380 clause is ADDED. Every other string is unchanged. 13 - 1 + 2 = 14.
# RE-PINNED UNDER D-392 (first act): the D-380 clause is REPLACED by the D-383
# clause and the D-392 clause is ADDED. Every other string is unchanged.
# 14 - 1 + 2 = 15.
# RE-PINNED UNDER D-396 (first act): the D-392 clause is REPLACED by the D-394
# clause and the D-396 clause is ADDED. Every other string is unchanged.
# 15 - 1 + 2 = 16.
# RE-PINNED UNDER D-398 (first act): the D-396 clause is REPLACED by the D-397
# clause and the D-398 clause is ADDED. Every other string is unchanged.
# 16 - 1 + 2 = 17.
# RE-PINNED UNDER D-400 (first act): the D-398 clause is REPLACED by the D-400
# acceptance clause and the D-400 open clause is ADDED. Every other string is
# unchanged. 17 - 1 + 2 = 18.
# RE-PINNED UNDER D-402 (first act): the D-400 open clause is REPLACED by the
# D-401 acceptance clause and the D-402 open clause is ADDED. 18 - 1 + 2 = 19.
# RE-PINNED UNDER D-404 (first act): the D-402 open clause is REPLACED by the
# D-403 acceptance clause and the D-404 open clause is ADDED. 19 - 1 + 2 = 20.
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
         "DOES NOT COMPLETE the original P1C" "DOES NOT AUTHORIZE P2" \
         "NO canonical Huntress class specification is written here" \
         "NO value here is a production lock" \
         "NO 2D lock from game2d/ is promoted here" \
         "PROVISIONAL STARTING CANDIDATE" \
         "NOT a Skill system" \
         "NOT an ability framework" \
         "NO bow / archery"; do
  if grep -qiF "$s" "$LOG"; then ok "runtime/suite states: \"$s\""
  else fail "runtime/suite does NOT state: \"$s\""; fi
done
if grep -qiE "P2 is authorized|P1 is complete|production ready|pivot complete|this is the final Huntress" "$LOG"; then
  fail "the run log makes a forbidden completion claim"
else
  ok "no forbidden completion claim in the run log"
fi
# ============================================================================
# THE STATE LINE IS PINNED EXACTLY, NOT BY SUBSTRING. STRICTER THAN BEFORE.
# ============================================================================
# The old pin was a substring match on "DELIVERED and OPEN pending owner live
# review" -- which the NEW state string still contains, so a substring pin could
# no longer tell the two apart. An exact-line pin can, and it is PROVED able to
# refuse an altered line.
# RE-PINNED UNDER D-380 (first act). From D-375 until D-380 this read
# "... · IMPRINT STAGE DELIVERED and OPEN pending owner live review (D-375)" --
# true when written; D-376 then accepted the Imprint stage.
# RE-PINNED UNDER D-392 (first act). From D-380 until D-392 this read
# "... · D-378 ALIGNMENT STAGE DELIVERED and OPEN pending owner live review
# (D-380)" -- true when written; D-383 then accepted the alignment stage.
# RE-PINNED UNDER D-396 (first act). From D-392 until D-396 this read
# "... · HUNTRESS SPLINTER SHOT STAGE DELIVERED and OPEN pending owner live review
# (D-392)" -- true when written; D-394 then accepted the Splinter Shot stage.
# RE-PINNED UNDER D-398 (first act). From D-396 until D-398 this read
# "... · KINDRED HOUNDS STAGE DELIVERED and OPEN pending owner live review
# (D-396)" -- true when written; D-397 then accepted the Kindred Hounds stage.
# RE-PINNED UNDER D-400 (first act). From D-398 until D-400 this read
# "... · MOBILE MINION COHESION STAGE DELIVERED and OPEN pending owner live
# review (D-398)" -- true when written; D-400 then accepted the cohesion stage
# and authorized the player locomotion redirection stage, which is now the open
# one.
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
STATE_LINE="$(grep -E '^STATE: ' "$LOG" | head -1)"
if [ "$STATE_LINE" = "$STATE_EXPECT" ]; then
  # D-404 (first act): this message read "(seven facts stated: … the D-400 player
  # locomotion redirection stage is open)" -- true at D-400, and STALE from D-402,
  # which moved the pin beside it but not its words. The PIN is what is checked;
  # the message now says what the pin holds.
  ok "the STATE line is pinned EXACTLY (nine facts stated: the foundation, Imprint, D-378 alignment, Huntress Splinter Shot, Kindred Hounds, mobile minion cohesion, player locomotion redirection and Cinder Field stages are closed, the D-404 player direct-click movement correction stage is open)"
else
  fail "STATE line MISMATCH"
  say "        expected: $STATE_EXPECT"
  say "        actual  : $STATE_LINE"
fi
ALT_STATE="$(printf '%s' "$STATE_LINE" | sed 's/ACCEPTED and CLOSED/DELIVERED and OPEN/')"
if [ "$ALT_STATE" = "$STATE_EXPECT" ]; then
  fail "the STATE pin ACCEPTS an altered line — a guard that accepts everything protects nothing"
else
  ok "the STATE pin is PROVED able to refuse an altered line"
fi
# AND THE STALE ASSERTION MUST BE GONE, not merely superseded somewhere else.
if grep -qxF "STATE: DELIVERED and OPEN pending owner live review" "$LOG"; then
  fail "the OLD, now-false state line is STILL PRESENT — the D-375 reconciliation did not take"
else
  ok "the old, now-false state line is GONE (the D-375 reconciliation is real, not additive)"
fi
# ADDED UNDER D-380: the D-375-era line must be gone too, and the needle must
# differ from the pin, or the absence check could never fire.
if grep -qxF "$STATE_D375_LINE" "$LOG"; then
  fail "the D-375-era state line is STILL PRESENT — the D-380 reconciliation did not take"
elif [ "$STATE_D375_LINE" = "$STATE_EXPECT" ]; then
  fail "the D-375-era needle equals the current pin — the absence check could never fire"
else
  ok "the D-375-era state line is GONE (the D-380 reconciliation is real, not additive)"
fi
# ADDED UNDER D-392: the D-380-era line must be gone too, and the needle must
# differ from the pin, or the absence check could never fire.
if grep -qxF "$STATE_D380_LINE" "$LOG"; then
  fail "the D-380-era state line is STILL PRESENT — the D-392 reconciliation did not take"
elif [ "$STATE_D380_LINE" = "$STATE_EXPECT" ]; then
  fail "the D-380-era needle equals the current pin — the absence check could never fire"
else
  ok "the D-380-era state line is GONE (the D-392 reconciliation is real, not additive)"
fi
# ADDED UNDER D-396: the D-392-era line must be gone too, and the needle must
# differ from the pin, or the absence check could never fire.
if grep -qxF "$STATE_D392_LINE" "$LOG"; then
  fail "the D-392-era state line is STILL PRESENT — the D-396 reconciliation did not take"
elif [ "$STATE_D392_LINE" = "$STATE_EXPECT" ]; then
  fail "the D-392-era needle equals the current pin — the absence check could never fire"
else
  ok "the D-392-era state line is GONE (the D-396 reconciliation is real, not additive)"
fi
# ADDED UNDER D-398: the D-396-era line must be gone too, and the needle must
# differ from the pin, or the absence check could never fire.
if grep -qxF "$STATE_D396_LINE" "$LOG"; then
  fail "the D-396-era state line is STILL PRESENT — the D-398 reconciliation did not take"
elif [ "$STATE_D396_LINE" = "$STATE_EXPECT" ]; then
  fail "the D-396-era needle equals the current pin — the absence check could never fire"
else
  ok "the D-396-era state line is GONE (the D-398 reconciliation is real, not additive)"
fi
# ADDED UNDER D-400: the D-398-era line must be gone too, and the needle must
# differ from the pin, or the absence check could never fire.
if grep -qxF "$STATE_D398_LINE" "$LOG"; then
  fail "the D-398-era state line is STILL PRESENT — the D-400 reconciliation did not take"
elif [ "$STATE_D398_LINE" = "$STATE_EXPECT" ]; then
  fail "the D-398-era needle equals the current pin — the absence check could never fire"
else
  ok "the D-398-era state line is GONE (the D-400 reconciliation is real, not additive)"
fi
# ADDED UNDER D-402: the D-400-era line must be gone too, and the needle must
# differ from the pin, or the absence check could never fire.
if grep -qxF "$STATE_D400_LINE" "$LOG"; then
  fail "the D-400-era state line is STILL PRESENT — the D-402 reconciliation did not take"
elif [ "$STATE_D400_LINE" = "$STATE_EXPECT" ]; then
  fail "the D-400-era needle equals the current pin — the absence check could never fire"
else
  ok "the D-400-era state line is GONE (the D-402 reconciliation is real, not additive)"
fi
# ADDED UNDER D-404: the D-402-era line must be gone too, and the needle must
# differ from the pin, or the absence check could never fire.
if grep -qxF "$STATE_D402_LINE" "$LOG"; then
  fail "the D-402-era state line is STILL PRESENT — the D-404 reconciliation did not take"
elif [ "$STATE_D402_LINE" = "$STATE_EXPECT" ]; then
  fail "the D-402-era needle equals the current pin — the absence check could never fire"
else
  ok "the D-402-era state line is GONE (the D-404 reconciliation is real, not additive)"
fi
# AND `M-04` MUST NO LONGER PRINT AS OWED, WHILE ITS HISTORY MUST STILL PRINT.
if grep -qE '^  \[OWED-TO-OWNER\]' "$LOG"; then
  fail "a row still prints as OWED-TO-OWNER; M-04 was DISCHARGED by D-373"
else
  ok "no row prints as OWED-TO-OWNER any more (M-04 was discharged by D-373)"
fi
if grep -qF "DISCHARGED — D-373" "$LOG" && grep -qF "ORIGINAL ROW TEXT, PRESERVED VERBATIM" "$LOG"; then
  ok "M-04's history is PRESERVED and printed as DISCHARGED, which is not a pass"
else
  fail "M-04's history is not preserved in the run log"
fi

# --------------------------------------- R10..R17,R19,R20. isolation ----
say ""
say "[6/7] Isolation and preservation (R10-R17, R19, R20)"
BASE="${FOUNDATION_BASELINE_DIR:-}"
# NO EXCEPTION IS DECLARED FOR ANY PROTECTED PROJECT.
# D-366 declared one (game2d/README.md). D-370 declares NONE: the cross-reference
# runs ONE WAY ONLY, outward from game3d/, exactly as D-368 did for
# game3d_spike/. game3d_spike/ and game3d_boss_spike/ are accepted and CLOSED,
# and their "DELIVERED and OPEN" strings must NOT be "fixed".
for d in game game2d game3d_spike game3d_boss_spike; do
  f="$BASE/baseline_$d.sha256"
  if [ -n "$BASE" ] && [ -f "$f" ]; then
    NOW="$(mktemp -t foundation_now)"
    ( cd "$ROOT" && find "$d" -type f -print0 | sort -z | xargs -0 shasum -a 256 ) > "$NOW"
    DIFFS="$(diff "$f" "$NOW" | grep -E '^[<>]' | sed 's/^[<>] *//' \
             | awk '{ $1=""; sub(/^ /,""); print }' | sort -u)"
    if [ -z "$DIFFS" ]; then
      ok "$d/ is byte-identical to the pre-work baseline"
    else
      fail "$d/ CHANGED — no exception is declared for any protected project:"
      printf '%s\n' "$DIFFS" | head -10 | sed 's/^/        /'
    fi
    rm -f "$NOW"
  else
    say "  [SKIP] $d/ baseline not supplied (set FOUNDATION_BASELINE_DIR)"
  fi
done
if [ -n "$BASE" ] && [ -f "$BASE/baseline_quaternius.sha256" ]; then
  NOW="$(mktemp -t foundation_now)"
  ( cd "$ROOT" && find "assets/Quaternius Assets" -type f -print0 | sort -z \
    | xargs -0 shasum -a 256 ) > "$NOW"
  if diff -q "$BASE/baseline_quaternius.sha256" "$NOW" >/dev/null; then
    ok "the eleven source archives are byte-identical (reading is allowed; writing is not)"
  else fail "source archives CHANGED"; fi
  rm -f "$NOW"
else
  say "  [SKIP] archive baseline not supplied"
fi
# R15 — owner art is never touched.
if find "$PROJ" -name '*.pxo' 2>/dev/null | grep -q .; then
  fail "a .pxo is present inside game3d/ — owner art must never be touched"
else
  ok "no owner .pxo anywhere in game3d/"
fi
# R16 — the SET of quaternius asset trees is pinned. A fifth appearing is caught.
FOUND="$(find "$ROOT" -type d -name 'quaternius' 2>/dev/null | sed "s|^$ROOT/||" | sort | tr '\n' ' ')"
EXPECT_TREES="game/assets/third_party/quaternius game3d/assets/third_party/quaternius game3d_boss_spike/assets/third_party/quaternius game3d_spike/assets/third_party/quaternius "
if [ "$FOUND" = "$EXPECT_TREES" ]; then
  ok "quaternius asset trees are exactly the four expected (game/, game3d/, and the two closed spikes)"
else
  fail "unexpected quaternius asset tree set"
  say "        expected: $EXPECT_TREES"
  say "        actual  : $FOUND"
fi
# R17 — the cross-reference runs ONE WAY ONLY, outward.
STRAY="$(grep -rl "game3d/" "$ROOT/game" "$ROOT/game2d" "$ROOT/game3d_spike" \
         "$ROOT/game3d_boss_spike" 2>/dev/null | sed "s|^$ROOT/||" || true)"
if [ -n "$STRAY" ]; then
  fail "a protected project references game3d/ — the cross-reference must run one way only:"
  printf '%s\n' "$STRAY" | sed 's/^/        /'
else
  ok "no protected project references game3d/ (one-way cross-reference, outward only)"
fi
# R19 — no audio asset anywhere.
AUDIO="$(find "$PROJ" \( -name '*.wav' -o -name '*.ogg' -o -name '*.mp3' -o -name '*.flac' \) 2>/dev/null || true)"
if [ -n "$AUDIO" ]; then fail "audio assets present: $AUDIO"
else ok "zero audio assets (CLAUDE.md 12 forbids new audio; there are no audio hooks either)"; fi
# R20 — the excluded pack and the boss candidate are absent.
BAD="$(find "$PROJ" \( -iname '*Puglin*' -o -iname '*UltimateMonsters*' -o -iname '*Dragon*' -o -iname '*PinkBlob*' \) 2>/dev/null || true)"
if [ -n "$BAD" ]; then fail "an excluded asset is present: $BAD"
else ok "no boss candidate and no Ultimate Monsters file anywhere in game3d/"; fi

# ------------------------------------------------------- R18. evidence ----
say ""
say "[7/7] Rendered evidence (R18)"
EV_LIST="01_arena_wide:arena:150 02_combat_loop:combat:150 03_telegraph:telegraph:120 04_doorway_navigation:doorway:120 05_death_sequence:death:120 06_committed_attack:commit:100"
if [ "$WITH_EVIDENCE" -eq 1 ]; then
  for spec in $EV_LIST; do
    out="${spec%%:*}.png"; rest="${spec#*:}"; mode="${rest%%:*}"; w="${rest#*:}"
    "$GODOT" --path "$PROJ" --resolution 1920x1080 -- \
      --capture="$mode" --out="res://evidence/$out" --wait="$w" >/dev/null 2>&1
    if [ -f "$PROJ/evidence/$out" ]; then
      DIM="$(sips -g pixelWidth -g pixelHeight "$PROJ/evidence/$out" 2>/dev/null \
             | awk '/pixel/{printf "%s", $2"x"} END{print ""}' | sed 's/x$//')"
      if [ "$DIM" = "1920x1080" ]; then ok "evidence/$out rendered natively at 1920x1080, overlay disabled"
      else fail "evidence/$out is ${DIM}, not 1920x1080"; fi
    else
      fail "evidence/$out was not produced"
    fi
  done
else
  say "  [SKIP] rendered evidence is opt-in; re-run with --with-evidence"
  for spec in $EV_LIST; do
    out="${spec%%:*}.png"
    if [ -f "$PROJ/evidence/$out" ]; then
      DIM="$(sips -g pixelWidth -g pixelHeight "$PROJ/evidence/$out" 2>/dev/null \
             | awk '/pixel/{printf "%s", $2"x"} END{print ""}' | sed 's/x$//')"
      [ "$DIM" = "1920x1080" ] && ok "existing evidence/$out is 1920x1080" \
        || fail "existing evidence/$out is ${DIM}"
    else
      fail "evidence/$out missing (run with --with-evidence)"
    fi
  done
fi

# ------------------------------------------------------------------ verdict --
say ""
say "========================================================================"
if [ "$SUITE_RC" -ne 0 ]; then fail "the verification suite exited non-zero ($SUITE_RC)"; fi
if [ "$FAILED" -eq 0 ]; then
  say "FOUNDATION RUNNER: PASS"
else
  say "FOUNDATION RUNNER: FAIL"
fi
say ""
say "UNITS: 20 RUNNER CHECKS here · 85 EXECUTABLE CHECKS in this suite ·"
say "       125 OWED CRITERIA in docs/testing/D370_OWED_CRITERIA_INVENTORY.md."
say "       Three different units. None is a synonym for another."
say "       THE D-375 IMPRINT STAGE HAS ITS OWN THREE COUNTS, in its own"
say "       inventory, suite and runner. They are not these, and they do not add"
say "       to these. Run ./tests/imprint_smoke.sh for that stage."
say ""
say "This is the ACCEPTED D-373 FOUNDATION BASELINE, re-run as a REGRESSION."
say "Its 85 executable checks are UNCHANGED; nothing was removed, renamed or"
say "renumbered. Two things were RE-PINNED under D-375, in the same change as the"
say "artifact they guard: the STATE line and the deferred-row count (12 -> 11,"
say "because D-373 DISCHARGED M-04). NO GUARD WAS WEAKENED — the STATE pin is now"
say "an EXACT-LINE match, which is stricter than the substring it replaced."
say ""
say "RE-PINNED AGAIN UNDER D-380, AS ITS FIRST ACT: R08's STATE line and its"
say "truthfulness strings, with one refusal ADDED. The suite file was NOT edited then."
say "RE-PINNED A THIRD TIME UNDER D-392, AS ITS FIRST ACT: R08's STATE line and its"
say "truthfulness strings (14 - 1 + 2 = 15), with one refusal ADDED."
say "RE-PINNED A FOURTH TIME UNDER D-396, AS ITS FIRST ACT: R08's STATE line and its"
say "truthfulness strings (15 - 1 + 2 = 16), with one refusal ADDED."
say "RE-PINNED A FIFTH TIME UNDER D-398, AS ITS FIRST ACT: R08's STATE line and its"
say "truthfulness strings (16 - 1 + 2 = 17), with one refusal ADDED."
say "RE-PINNED A SIXTH TIME UNDER D-400, AS ITS FIRST ACT: R08's STATE line and its"
say "truthfulness strings (17 - 1 + 2 = 18), with one refusal ADDED."
say ""
say "It COMPLETES NO PHASE. It does NOT complete P1 or the original P1C."
say "It does NOT authorize P2. It LOCKS NO VALUE, and every tuning number in it"
say "remains PROVISIONAL. No placeholder asset is final."
say "STATE: FOUNDATION STAGE ACCEPTED and CLOSED (D-373) · IMPRINT STAGE"
say "       ACCEPTED and CLOSED (D-376) · D-378 ALIGNMENT STAGE ACCEPTED and"
say "       CLOSED (D-383) · HUNTRESS SPLINTER SHOT STAGE ACCEPTED and CLOSED"
say "       (D-394) · KINDRED HOUNDS STAGE ACCEPTED and CLOSED (D-397) · MOBILE"
say "       MINION COHESION STAGE ACCEPTED and CLOSED (D-400) · PLAYER LOCOMOTION"
say "       REDIRECTION STAGE DELIVERED and OPEN pending owner live review"
say "       (D-400)."
say "========================================================================"
rm -f "$LOG"
exit "$FAILED"
