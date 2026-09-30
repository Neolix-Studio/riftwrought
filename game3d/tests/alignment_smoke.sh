#!/usr/bin/env bash
# =============================================================================
# RIFTWROUGHT — D-378 ALIGNMENT STAGE RUNNER  (D-380, 2026-09-18)
#
# Runs ALL THREE suites headless: the ACCEPTED D-373 foundation baseline and the
# ACCEPTED D-376 Imprint stage as REGRESSIONS, then this stage's own suite. Then
# it applies the project's standing runner rules:
#   * the IMPORT PASS first, so a fresh checkout verifies;
#   * fail on ANY engine error, regardless of a suite's own PASS line;
#   * the error guard is PROVED able to refuse a planted ERROR line;
#   * every pinned count is pinned IN BOTH DIRECTIONS -- the run's own log is
#     replayed with the count altered and the pin must refuse it;
#   * isolation is ASSERTED, not assumed -- and inside game3d/ ITSELF, every
#     authored file outside the DECLARED change set must be byte-identical.
#
# Rendered evidence is OPT-IN (--with-evidence). A plain invocation is
# headless-only, per the project's standing rule. With --with-evidence it renders
# ONLY the D-381 correction's three NEW captures (13, 14, 15) -- never the
# accepted 01-10 and never D-380's 11-12, which the correction does not affect --
# and it renders them FIRST, so the import pass and the change-set check see them.
# (At D-380's delivery it rendered 11 and 12 -- true when written.)
#
# =============================================================================
# RE-SCOPED UNDER D-381 — the REVIEWABILITY CORRECTION inside this stage. The
# runner stays 21 RUNNER CHECKS; these moved IN PLACE, one for one:
#   * PIN_A_CHECKS 28 -> 35 (A29-A35) and PIN_A_DEFERRED 14 -> 16 (AD-11, AM-05);
#   * T09: rows owed to the owner 4 -> 5;
#   * T13: eleven truthfulness strings -> fifteen (+4 from the correction);
#   * T17: the declared change set grows by project.godot, the foundation suite,
#     the review HUD script and its uid, and evidence 13-15 -- 15 + 2 = 17
#     modified, 7 + 8 = 15 new;
#   * T19: 25 input actions -> 26, and the one extra must be the diagnostic cycle;
#   * T21: renders 13-15 and checks 11-15.
#
# RE-SCOPED UNDER D-382 — the owner's clarification of D-381 and ruling on AD-11.
# The runner STILL has 21 RUNNER CHECKS; these moved IN PLACE, one for one:
#   * PIN_A_CHECKS 35 -> 40 (A36-A40) and PIN_A_DEFERRED 16 -> 15 (AD-11 moved,
#     text preserved, to a printed DISCHARGED block — 16 - 1 = 15);
#   * T09: AD-11 must now print as DISCHARGED — D-382, exactly once;
#   * T13: fifteen truthfulness strings -> seventeen (+2 from D-382);
#   * T17: scripts/combat/damageable.gd joins the declared modified set (17 -> 18);
#   * T21: renders ONLY 14 and 15 — the two captures the Health rule changes —
#     and still checks 11-15. (13 shows MANA RESERVATION, which D-382 leaves alone.)
# =============================================================================
#
# RE-PINNED UNDER D-392, AS ITS FIRST ACT, EXACTLY AS D-383 SECTION 6 RECOMMENDED.
# The runner STILL has 21 RUNNER CHECKS; these moved IN PLACE, one for one, in
# the same change as the artifact they guard:
#   * STATE_EXPECT (T11, T20): the three-stage D-380 line -> the four-fact line;
#   * T12: GAINS the D-380-era line as a superseded line that must be absent;
#   * T13: the D-380 clause -> the D-383 clause (17 strings, unchanged in number);
#   * PIN_A_DEFERRED (T06, T08, T09) 15 -> 10 and T09's owner rows 5 -> 0, because
#     D-383 answered or closed AM-01..AM-05, which now print DISCHARGED — D-383
#     with their original text preserved (15 - 5 = 10; ZERO DELETED);
#   * T18: its COUNT LOGIC is unchanged; its message names its scope, because
#     D-392 declares a SEPARATE placeholder intake verified by W18.
# T17's declared change set is D-380's and is NOT extended: run against a
# pre-D-380 game3d/ baseline it reports the D-392 files, which is a DELIVERY-TIME
# claim of D-380, not a repository pin. D-392's own change set is W17's.
#
# RE-PINNED UNDER D-396, AS ITS FIRST ACT, EXACTLY AS D-394 SECTION 7 RECOMMENDED.
# The runner STILL has 21 RUNNER CHECKS; these moved IN PLACE, one for one:
#   * STATE_EXPECT (T11, T20): the four-fact line -> the five-fact line;
#   * T12: GAINS the D-392-era line as a superseded line that must be absent;
#   * T19: ONE diagnostic input action added under D-396 (26 + 1 = 27), named.
# T13 carries no D-392 clause and does not move. T17 stays a D-380 delivery-time
# claim; D-396's own change set is Y15's.
#
# RE-PINNED UNDER D-398, AS ITS FIRST ACT, EXACTLY AS D-397 SECTION 6 RECOMMENDED.
# The runner STILL has 21 RUNNER CHECKS; these moved IN PLACE, one for one:
#   * STATE_EXPECT (T11, T20): the five-fact line -> the six-fact line;
#   * T12: GAINS the D-396-era line as a superseded line that must be absent;
#   * T19: TWO diagnostic input actions added under D-398 (27 + 2 = 29), named.
# T13 carries no D-396 clause and does not move. D-398's own change set is Z16's.
#
# RE-PINNED UNDER D-400, AS ITS FIRST ACT, EXACTLY AS THE RULING DIRECTS.
# The runner STILL has 21 RUNNER CHECKS; these moved IN PLACE, one for one:
#   * STATE_EXPECT (T11, T20): the six-fact line -> the seven-fact line, whose
#     sixth fact is D-400's ACCEPTANCE of the cohesion stage and whose seventh is
#     the D-400 player locomotion redirection stage, OPEN;
#   * T12: GAINS the D-398-era line as a superseded line that must be absent
#     (five needles -> six).
# T13 carries no D-398 clause and does not move. T19's input-action count does
# NOT move: D-400 adds NO input action (29 stays 29). D-400's own change set is
# tests/locomotion_smoke.sh N16's.
# =============================================================================
#
# =============================================================================
# UNITS. NINE COUNTS, AND NONE IS A SYNONYM FOR ANOTHER.
#
#   D-380: 21 RUNNER CHECKS here (T01-T21) · 40 EXECUTABLE CHECKS in
#          tests/alignment_verification.gd · 162 OWED CRITERIA in
#          docs/testing/D380_ALIGNMENT_OWED_CRITERIA_INVENTORY.md
#          (28 and 121 at delivery; + 7 and + 25 under the D-381 correction;
#          + 5 and + 16 under D-382 — now 40 and 162)
#   D-375: 26 RUNNER CHECKS · 101 EXECUTABLE CHECKS · 149 OWED CRITERIA
#   D-370: 20 RUNNER CHECKS · 85 EXECUTABLE CHECKS · 125 OWED CRITERIA
# =============================================================================
#
# THIS RUNNER VERIFIES A STAGE DELIVERED OPEN: a SEMANTIC ALIGNMENT of the
# Imprint runtime with the owner's D-378 rulings. It is NOT Huntress
# implementation and NOT progression tuning. It completes no phase, authorizes
# no phase, LOCKS NO NUMBER and ADOPTS NO D-378 TEST CANDIDATE.
# =============================================================================
set -uo pipefail

GODOT="${GODOT:-/Applications/Godot.app/Contents/MacOS/Godot}"
HERE="$(cd "$(dirname "$0")" && pwd)"
PROJ="$(cd "$HERE/.." && pwd)"
ROOT="$(cd "$PROJ/.." && pwd)"
FLOG="$(mktemp -t align_foundation)"
ILOG="$(mktemp -t align_imprint)"
ALOG="$(mktemp -t align_stage)"
FAILED=0
WITH_EVIDENCE=0
[ "${1:-}" = "--with-evidence" ] && WITH_EVIDENCE=1

# THE ONE STATE LINE, identical in all three runners (T20 compares them).
# RE-PINNED UNDER D-392 (first act): it read "... · D-378 ALIGNMENT STAGE
# DELIVERED and OPEN pending owner live review (D-380)" until D-392 -- true when
# written; D-383 accepted the stage.
# RE-PINNED UNDER D-396 (first act): it read "... · HUNTRESS SPLINTER SHOT STAGE
# DELIVERED and OPEN pending owner live review (D-392)" until D-396 -- true when
# written; D-394 accepted that stage.
# RE-PINNED UNDER D-398 (first act): it read "... · KINDRED HOUNDS STAGE
# DELIVERED and OPEN pending owner live review (D-396)" until D-398 -- true when
# written; D-397 accepted that stage.
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
PIN_I_DEFERRED=16
PIN_A_CHECKS=40
# 15 -> 10 UNDER D-392 (first act): AM-01..AM-05 print DISCHARGED — D-383.
PIN_A_DEFERRED=10
PIN_MAP_PARTS=27
DECLARED_THIRD_PARTY_FILES=29
INVENTORY="$ROOT/docs/testing/D380_ALIGNMENT_OWED_CRITERIA_INVENTORY.md"

# THE DECLARED CHANGE SET INSIDE game3d/ — pinned in BOTH directions by T17.
DECLARED_MODIFIED="README.md
project.godot
scripts/combat/damageable.gd
scripts/core/prod_config.gd
scripts/foundation_main.gd
scripts/imprint/diag_imprint_content.gd
scripts/imprint/imprint.gd
scripts/imprint/imprint_config.gd
scripts/imprint/imprint_library.gd
scripts/imprint/imprint_loadout.gd
scripts/imprint/loadout_panel.gd
scripts/imprint/resource_pool.gd
scripts/imprint/skill_configuration.gd
scripts/imprint/skill_runtime.gd
tests/foundation_smoke.sh
tests/foundation_verification.gd
tests/imprint_smoke.sh
tests/imprint_verification.gd"
DECLARED_NEW="evidence/11_d378_alignment_panel.png
evidence/11_d378_alignment_panel.png.import
evidence/12_d378_overview_panel.png
evidence/12_d378_overview_panel.png.import
evidence/13_d381_review_hud_mana.png
evidence/13_d381_review_hud_mana.png.import
evidence/14_d381_review_hud_life.png
evidence/14_d381_review_hud_life.png.import
evidence/15_d381_review_hud_off.png
evidence/15_d381_review_hud_off.png.import
scripts/imprint/review_hud.gd
scripts/imprint/review_hud.gd.uid
tests/alignment_smoke.sh
tests/alignment_verification.gd
tests/alignment_verification.gd.uid"
# D-382: RENDER only the two captures the Health rule changes; CHECK all five.
# (D-381 rendered 13-15 -- true when written.)
EV_LIST="14_d381_review_hud_life:d381_hud_life:120 15_d381_review_hud_off:d381_hud_off:120"
EV_CHECK="11_d378_alignment_panel 12_d378_overview_panel 13_d381_review_hud_mana $EV_LIST"

say()  { printf '%s\n' "$*"; }
fail() { say "  [FAIL] $*"; FAILED=1; }
ok()   { say "  [ OK ] $*"; }

say "========================================================================"
say "RIFTWROUGHT D-378 ALIGNMENT STAGE RUNNER (D-380)"
say "Headless by default. Rendered evidence is opt-in via --with-evidence."
say "It runs the ACCEPTED D-373 and D-376 suites as REGRESSIONS, then this stage."
say "========================================================================"

# --------------------------------------------- 0. opt-in evidence, rendered FIRST
EV_RESULT=""
if [ "$WITH_EVIDENCE" -eq 1 ]; then
  say ""
  say "[0/9] Rendering the two captures D-382 changes (14, 15) FIRST (opt-in) — never 01-13"
  # A fresh import is needed before a windowed run can load the scripts.
  "$GODOT" --headless --path "$PROJ" --import >/dev/null 2>&1
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
      EV_RESULT="$EV_RESULT|$out:TIMEOUT"
    fi
    wait "$CAP_PID" 2>/dev/null
    say "    rendered $out ($mode)"
  done
fi

# ------------------------------------------------------------ T01. import ----
say ""
say "[1/9] Import pass (T01)"
"$GODOT" --headless --path "$PROJ" --import >/dev/null 2>&1
IMPORTED="$(ls "$PROJ/.godot/imported" 2>/dev/null | wc -l | tr -d ' ')"
if [ "$IMPORTED" -gt 0 ]; then
  ok "T01 assets imported ($IMPORTED entries) — a fresh checkout verifies"
else
  fail "T01 the import pass produced nothing; no suite can load an asset"
fi

# ------------------------------------------------------ T02-T07. the suites --
say ""
say "[2/9] The three suites: D-373 and D-376 as REGRESSIONS, then D-380 (T02-T07)"
"$GODOT" --headless --path "$PROJ" --script res://tests/foundation_verification.gd >"$FLOG" 2>&1
F_RC=$?
"$GODOT" --headless --path "$PROJ" --script res://tests/imprint_verification.gd >"$ILOG" 2>&1
I_RC=$?
"$GODOT" --headless --path "$PROJ" --script res://tests/alignment_verification.gd >"$ALOG" 2>&1
A_RC=$?
grep -E "^  \[(PASS|FAIL|UNREACHED|DEFERRED|OWED-TO-OWNER)" "$ALOG" | sed 's/^/    /' | head -60
grep -E "^(FOUNDATION VERIFICATION:|IMPRINT VERIFICATION:|ALIGNMENT VERIFICATION:)" \
  "$FLOG" "$ILOG" "$ALOG" | sed "s|^[^:]*:|    |"

pin_summary() { # $1 id, $2 log, $3 prefix, $4 checks, $5 deferred
  local line expect
  line="$(grep -E "^$3 VERIFICATION:" "$2" | head -1)"
  expect="$3 VERIFICATION: PASS ($4 checks: $4 passed, 0 failed/unreached, $5 deferred)"
  if [ "$line" = "$expect" ]; then
    ok "$1 $3 summary matches EXACTLY: $4 executable checks, $5 deferred rows"
  else
    fail "$1 $3 summary MISMATCH"; say "        expected: $expect"; say "        actual  : $line"
  fi
}
pin_owed() { # $1 id, $2 log, $3 checks, $4 name prefix
  local line expect names
  line="$(grep -E '^  owed=' "$2" | head -1 | sed 's/^ *//')"
  expect="owed=$3  reached=$3  owed-but-not-reached=0 []  reached-but-not-owed=0 []"
  names="$(grep -cE "^  \[PASS     \] $4[0-9]+_" "$2")"
  if [ "$line" = "$expect" ] && [ "$names" = "$3" ]; then
    ok "$1 owed vs reached matches in BOTH directions, and all $3 $4-numbered checks passed"
  else
    fail "$1 owed/reached or name count MISMATCH ($names $4-names)"; say "        expected: $expect"; say "        actual  : $line"
  fi
}
pin_summary T02 "$FLOG" FOUNDATION "$PIN_F_CHECKS" "$PIN_F_DEFERRED"
pin_owed     T03 "$FLOG" "$PIN_F_CHECKS" F
pin_summary T04 "$ILOG" IMPRINT "$PIN_I_CHECKS" "$PIN_I_DEFERRED"
pin_owed     T05 "$ILOG" "$PIN_I_CHECKS" I
pin_summary T06 "$ALOG" ALIGNMENT "$PIN_A_CHECKS" "$PIN_A_DEFERRED"
pin_owed     T07 "$ALOG" "$PIN_A_CHECKS" A

# ----------------------------------------------- T08. pins able to refuse ----
say ""
say "[3/9] Every pin PROVED able to refuse an altered value (T08)"
REFUSED=0
for spec in "FOUNDATION:$FLOG:$PIN_F_CHECKS:$PIN_F_DEFERRED" "IMPRINT:$ILOG:$PIN_I_CHECKS:$PIN_I_DEFERRED" \
            "ALIGNMENT:$ALOG:$PIN_A_CHECKS:$PIN_A_DEFERRED"; do
  P="${spec%%:*}"; rest="${spec#*:}"; L="${rest%%:*}"; rest="${rest#*:}"; C="${rest%%:*}"; D="${rest#*:}"
  LINE="$(grep -E "^$P VERIFICATION:" "$L" | head -1)"
  EXPECT="$P VERIFICATION: PASS ($C checks: $C passed, 0 failed/unreached, $D deferred)"
  ALT1="$(printf '%s' "$LINE" | sed "s/($C checks/($((C - 1)) checks/")"
  ALT2="$(printf '%s' "$LINE" | sed "s/, $D deferred/, $((D + 1)) deferred/")"
  if [ "$ALT1" != "$EXPECT" ] && [ "$ALT2" != "$EXPECT" ] && [ "$LINE" = "$EXPECT" ]; then
    REFUSED=$((REFUSED + 1))
  fi
done
if [ "$REFUSED" = "3" ]; then
  ok "T08 all three summary pins REFUSE an altered check count AND an altered deferred count (replayed)"
else
  fail "T08 only $REFUSED of 3 summary pins were proved able to refuse an altered value"
fi

# -------------------------------------------------- T09. printed rows ----
say ""
say "[4/9] Deferred, owed and discharged rows (T09)"
A_ROWS="$(grep -cE '^  \[(DEFERRED|OWED-TO-OWNER) *\] A[DM]-[0-9]+ ' "$ALOG")"
A_OWNER="$(grep -cE '^  \[OWED-TO-OWNER *\] AM-[0-9]+ ' "$ALOG")"
# D-392 (first act): the five AM- rows print DISCHARGED — D-383, history kept.
AM_DIS="$(grep -cE '^  \[DISCHARGED — D-383\] AM-0[1-5] ' "$ALOG")"
AM_KEPT="$(grep -cF "ORIGINAL ROW TEXT, PRESERVED VERBATIM (OWED-TO-OWNER): 'MEASURED" "$ALOG")"
I_ROWS="$(grep -cE '^  \[(DEFERRED|STILL OWED) *\] DF-[0-9]+ ' "$ILOG")"
MO_OWED="$(grep -cE '^  \[OWED-TO-OWNER *\] MO-0' "$ILOG")"
MO_DIS="$(grep -cE '^  \[DISCHARGED — D-376 *\] MO-0[1-8] ' "$ILOG")"
AS_PASS="$(grep -cE '^  \[PASS *\] A[DM]-' "$ALOG")"
AD11_DIS="$(grep -cE '^  \[DISCHARGED — D-382\] AD-11 ' "$ALOG")"
AD11_OPEN="$(grep -cE '^  \[(DEFERRED|OWED-TO-OWNER) *\] AD-11 ' "$ALOG")"
# RE-PINNED UNDER D-392 (first act): owner rows 5 -> 0, and all five AM- rows must
# print DISCHARGED — D-383 with their original text. Until D-392 this required
# "$A_OWNER" = "5" -- true when written.
if [ "$A_ROWS" = "$PIN_A_DEFERRED" ] && [ "$A_OWNER" = "0" ] && [ "$AM_DIS" = "5" ] && [ "$AM_KEPT" = "5" ] \
   && [ "$I_ROWS" = "$PIN_I_DEFERRED" ] \
   && [ "$MO_OWED" = "0" ] && [ "$MO_DIS" = "8" ] && [ "$AS_PASS" = "0" ] \
   && [ "$AD11_DIS" = "1" ] && [ "$AD11_OPEN" = "0" ]; then
  ok "T09 $A_ROWS D-380 rows print (none owed to the owner any more) and $I_ROWS D-375 rows print, none as a pass; AM-01..AM-05 print DISCHARGED — D-383 with their original text ($AM_KEPT of 5); AD-11 prints DISCHARGED — D-382; the eight MO- rows print DISCHARGED — D-376, none as owed"
else
  fail "T09 rows: D-380 $A_ROWS (owner $A_OWNER, AM discharged $AM_DIS, text kept $AM_KEPT), D-375 $I_ROWS, MO owed $MO_OWED, MO discharged $MO_DIS, rows printed as pass $AS_PASS, AD-11 discharged $AD11_DIS / still open $AD11_OPEN"
fi

# ---------------------------------------------------- T10. engine errors ----
say ""
say "[5/9] Engine-error guard (T10)"
ERRPAT='^(SCRIPT )?ERROR:|^USER ERROR:|^SCRIPT ERROR|Parse Error|Failed to load script'
# The ACCEPTED foundation suite plants ONE bad clip name to prove its animation
# guard cannot fail silently. It is the ONLY expected error line in any log.
SELF='Foundation_Signature_Move_THIS_DOES_NOT_EXIST'
SELF_N="$(grep -cF "$SELF" "$FLOG")"
F_REAL="$(grep -E "$ERRPAT" "$FLOG" | grep -vF "$SELF" || true)"
I_REAL="$(grep -E "$ERRPAT" "$ILOG" || true)"
A_REAL="$(grep -E "$ERRPAT" "$ALOG" || true)"
PLANT="$(mktemp -t align_plant)"; cat "$ALOG" > "$PLANT"
printf 'ERROR: planted engine error, for guard proving only\n' >> "$PLANT"
if [ "$SELF_N" -lt 1 ]; then
  fail "T10 the accepted suite's guard-proving error line is missing — F12's proof is not intact"
elif [ -n "$F_REAL" ] || [ -n "$I_REAL" ] || [ -n "$A_REAL" ]; then
  fail "T10 engine errors present:"
  printf '%s\n' "$F_REAL" "$I_REAL" "$A_REAL" | grep -v '^$' | head -12 | sed 's/^/        /'
elif ! grep -qE "$ERRPAT" "$PLANT"; then
  fail "T10 the error guard could NOT detect a planted error line"
else
  ok "T10 no engine error in any of the three logs beyond the one expected guard proof, and the guard refuses a planted error"
fi
rm -f "$PLANT"

# ------------------------------------------ T11-T15. truthfulness and the map --
say ""
say "[6/9] The state line, truthfulness, and the D-378 map (T11-T15)"
BAD_STATE=0
for L in "$FLOG" "$ILOG" "$ALOG"; do
  LINE="$(grep -E '^STATE: ' "$L" | head -1)"
  [ "$LINE" != "$STATE_EXPECT" ] && { BAD_STATE=1; say "        in $(basename "$L"): $LINE"; }
done
ALT_STATE="$(printf '%s' "$STATE_EXPECT" | sed 's/ACCEPTED and CLOSED (D-376)/DELIVERED and OPEN (D-376)/')"
if [ "$BAD_STATE" -eq 0 ] && [ "$ALT_STATE" != "$STATE_EXPECT" ]; then
  ok "T11 all three suites print the SAME exact state line, and the pin is PROVED able to refuse an altered one"
else
  fail "T11 the state line differs from the pin, the suites disagree, or the pin cannot refuse"
  say "        expected: $STATE_EXPECT"
fi
# D-392 (first act): the D-380-era line joins the superseded lines that must be absent.
# D-396 (first act): and the D-392-era line joins them. Three -> four needles.
# D-398 (first act): and the D-396-era line joins them. Four -> five needles.
# D-400 (first act): and the D-398-era line joins them. Five -> six needles.
# D-402 (first act): and the D-400-era line joins them. Six -> seven needles.
# D-404 (first act): and the D-402-era line joins them. Seven -> eight needles.
if grep -qxF "$STATE_D375_LINE" "$FLOG" "$ILOG" "$ALOG" \
   || grep -qxF "$STATE_D380_LINE" "$FLOG" "$ILOG" "$ALOG" \
   || grep -qxF "$STATE_D392_LINE" "$FLOG" "$ILOG" "$ALOG" \
   || grep -qxF "$STATE_D396_LINE" "$FLOG" "$ILOG" "$ALOG" \
   || grep -qxF "$STATE_D398_LINE" "$FLOG" "$ILOG" "$ALOG" \
   || grep -qxF "$STATE_D400_LINE" "$FLOG" "$ILOG" "$ALOG" \
   || grep -qxF "$STATE_D402_LINE" "$FLOG" "$ILOG" "$ALOG" \
   || grep -qxF "STATE: DELIVERED and OPEN pending owner live review" "$FLOG" "$ILOG" "$ALOG"; then
  fail "T12 a superseded state line (the D-375, D-380, D-392, D-396, D-398, D-400 or D-402 one, or the bare D-370 one) is still printed"
elif [ "$STATE_D375_LINE" = "$STATE_EXPECT" ] || [ "$STATE_D380_LINE" = "$STATE_EXPECT" ] \
     || [ "$STATE_D392_LINE" = "$STATE_EXPECT" ] || [ "$STATE_D396_LINE" = "$STATE_EXPECT" ] \
     || [ "$STATE_D398_LINE" = "$STATE_EXPECT" ] || [ "$STATE_D400_LINE" = "$STATE_EXPECT" ] \
     || [ "$STATE_D402_LINE" = "$STATE_EXPECT" ]; then
  fail "T12 a superseded needle equals the pin — the absence check could never fire"
else
  ok "T12 none of the eight superseded state lines is printed by any of the three suites"
fi
T13_MISS=""
# RE-PINNED UNDER D-392 (first act): the D-380 clause -> the D-383 clause.
# Until D-392 the second string read "D-378 ALIGNMENT STAGE DELIVERED and OPEN
# pending owner live review (D-380)" -- true when written. 17 strings, unchanged.
for s in "IMPRINT STAGE ACCEPTED and CLOSED (D-376)" \
         "D-378 ALIGNMENT STAGE ACCEPTED and CLOSED (D-383)" \
         "IS NOT Huntress implementation" "IS NOT progression tuning" \
         "DOES NOT AUTHORIZE P2" "BUILDS NO Machinations model" \
         "ADOPTS NO D-378 TEST CANDIDATE" "LOCKS NO NUMBER" \
         "NO canonical Huntress class specification" \
         "MODIFIES NO accepted D-373 value" \
         "CURRENT WORKING BASELINE (D-378 OD-09, amending D-376's six) — NOT a lock" \
         "NOT HUMAN-REVIEWABLE DURING PLAY" "IS NOT a production UI foundation" \
         "OWNS NO NUMBER" "EXACTLY ONE diagnostic input action" \
         "RESOLVED UNDER D-382" "D-382 changes NO tuning value"; do
  grep -qF "$s" "$ALOG" || T13_MISS="$T13_MISS | $s"
done
if [ -z "$T13_MISS" ]; then
  ok "T13 the D-380 run states every one of its seventeen truthfulness strings (eleven + four from D-381 + two from D-382)"
else
  fail "T13 the D-380 run does NOT state:$T13_MISS"
fi
FORBID='P2 is authorized|P1 is complete|production ready|pivot complete|final balance is locked|the rank cap is locked|the Huntress roster is final|this is the final Huntress|~2x is adopted|unequipped progression is implemented'
PLANT2="$(mktemp -t align_plant2)"; printf 'the rank cap is locked\n' > "$PLANT2"
if grep -qiE "$FORBID" "$FLOG" "$ILOG" "$ALOG"; then
  fail "T14 a run log makes a forbidden lock or completion claim"
elif ! grep -qiE "$FORBID" "$PLANT2"; then
  fail "T14 the forbidden-claim scan cannot see a planted claim"
else
  ok "T14 no forbidden lock or completion claim in any log, and the scan refuses a planted one"
fi
rm -f "$PLANT2"
# T15 — THE RUNTIME MAP AND THE INVENTORY'S MAP, ROW FOR ROW.
RUN_MAP="$(grep -E '^  \[D378-MAP\] OD-' "$ALOG" | sed -E 's/^  \[D378-MAP\] (OD-[0-9.]+) = (.*) :: .*$/\1|\2/' | sort -u)"
DOC_MAP="$(grep -E '^\| `OD-[0-9.]+` \| (IMPLEMENTED|ALREADY SATISFIED|DEFERRED — CANDIDATE ONLY|OUT OF SCOPE) \|' "$INVENTORY" \
  | sed -E 's/^\| `(OD-[0-9.]+)` \| ([^|]+) \|.*$/\1|\2/' | sed -E 's/ +$//' | sort -u)"
RUN_N="$(printf '%s\n' "$RUN_MAP" | grep -c '^OD-')"
DOC_N="$(printf '%s\n' "$DOC_MAP" | grep -c '^OD-')"
ALT_MAP="$(printf '%s\n' "$RUN_MAP" | sed '1s/|.*$/|OUT OF SCOPE-ALTERED/')"
if [ "$RUN_MAP" = "$DOC_MAP" ] && [ "$RUN_N" = "$PIN_MAP_PARTS" ] && [ "$ALT_MAP" != "$DOC_MAP" ]; then
  ok "T15 the runtime's D-378 map equals the inventory's map ROW FOR ROW ($RUN_N parts), and the comparison refuses an altered row"
else
  fail "T15 the runtime map ($RUN_N parts) and the inventory map ($DOC_N parts) differ, or the comparison cannot refuse"
  diff <(printf '%s\n' "$RUN_MAP") <(printf '%s\n' "$DOC_MAP") | head -8 | sed 's/^/        /'
fi

# ------------------------------------------------ T16-T19. isolation ----
say ""
say "[7/9] Isolation and preservation (T16-T19)"
BASE="${FOUNDATION_BASELINE_DIR:-}"
T16_OK=1; T16_RAN=0
for d in game game2d game3d_spike game3d_boss_spike; do
  f="$BASE/baseline_$d.sha256"
  if [ -n "$BASE" ] && [ -f "$f" ]; then
    T16_RAN=$((T16_RAN + 1))
    NOW="$(mktemp -t align_now)"
    ( cd "$ROOT" && find "$d" -type f -print0 | sort -z | xargs -0 shasum -a 256 ) > "$NOW"
    if ! diff -q "$f" "$NOW" >/dev/null; then
      T16_OK=0; say "        $d/ CHANGED"
      diff "$f" "$NOW" | grep -E '^[<>]' | head -6 | sed 's/^/          /'
    fi
    rm -f "$NOW"
  fi
done
if [ -n "$BASE" ] && [ -f "$BASE/baseline_quaternius.sha256" ]; then
  T16_RAN=$((T16_RAN + 1))
  NOW="$(mktemp -t align_now)"
  ( cd "$ROOT" && find "assets/Quaternius Assets" -type f -print0 | sort -z | xargs -0 shasum -a 256 ) > "$NOW"
  diff -q "$BASE/baseline_quaternius.sha256" "$NOW" >/dev/null || { T16_OK=0; say "        the source archives CHANGED"; }
  rm -f "$NOW"
fi
if [ "$T16_RAN" -eq 5 ] && [ "$T16_OK" -eq 1 ]; then
  ok "T16 game/, game2d/, game3d_spike/, game3d_boss_spike/ and the eleven archives are byte-identical to the pre-work baseline"
elif [ "$T16_RAN" -eq 0 ]; then
  say "  [SKIP] T16 baselines not supplied (set FOUNDATION_BASELINE_DIR)"
else
  fail "T16 a protected project or archive changed, or a baseline is missing ($T16_RAN of 5 measured)"
fi
# T17 — INSIDE game3d/: every authored file OUTSIDE the declared set is
# byte-identical; every declared file DID change or IS new. Both directions.
if [ -n "$BASE" ] && [ -f "$BASE/baseline_game3d.sha256" ]; then
  NOW="$(mktemp -t align_now)"
  ( cd "$ROOT" && find game3d -type f -not -path 'game3d/.godot/*' -print0 | sort -z \
    | xargs -0 shasum -a 256 ) > "$NOW"
  B_PATHS="$(sed -E 's/^[0-9a-f]+  //' "$BASE/baseline_game3d.sha256" | sort)"
  N_PATHS="$(sed -E 's/^[0-9a-f]+  //' "$NOW" | sort)"
  CHANGED="$(diff <(sort -k2 "$BASE/baseline_game3d.sha256") <(sort -k2 "$NOW") | grep -E '^[<>]' \
             | sed -E 's/^[<>] [0-9a-f]+  //' | sort -u)"
  ADDED="$(comm -13 <(printf '%s\n' "$B_PATHS") <(printf '%s\n' "$N_PATHS"))"
  REMOVED="$(comm -23 <(printf '%s\n' "$B_PATHS") <(printf '%s\n' "$N_PATHS"))"
  MODIFIED="$(comm -12 <(printf '%s\n' "$CHANGED") <(printf '%s\n' "$B_PATHS") | comm -12 - <(printf '%s\n' "$N_PATHS"))"
  EXP_MOD="$(printf '%s\n' "$DECLARED_MODIFIED" | sed 's|^|game3d/|' | sort)"
  EXP_NEW="$(printf '%s\n' "$DECLARED_NEW" | sed 's|^|game3d/|' | sort)"
  if [ -z "$REMOVED" ] && [ "$MODIFIED" = "$EXP_MOD" ] && [ "$ADDED" = "$EXP_NEW" ]; then
    ok "T17 inside game3d/: exactly the $(printf '%s\n' "$EXP_MOD" | wc -l | tr -d ' ') declared files changed and the $(printf '%s\n' "$EXP_NEW" | wc -l | tr -d ' ') declared files are new — EVERY other authored file is byte-identical (control, combat except damageable.gd, world, view, assets, scenes, evidence 01-10; project.godot and the foundation suite are DECLARED by D-381, damageable.gd by D-382)"
  else
    fail "T17 the game3d/ change set differs from the declared set"
    say "        undeclared/missing modifications:"; diff <(printf '%s\n' "$MODIFIED") <(printf '%s\n' "$EXP_MOD") | grep -E '^[<>]' | head -8 | sed 's/^/          /'
    say "        undeclared/missing additions:";    diff <(printf '%s\n' "$ADDED") <(printf '%s\n' "$EXP_NEW") | grep -E '^[<>]' | head -8 | sed 's/^/          /'
    [ -n "$REMOVED" ] && { say "        removed:"; printf '%s\n' "$REMOVED" | head -5 | sed 's/^/          /'; }
  fi
  rm -f "$NOW"
else
  say "  [SKIP] T17 game3d/ baseline not supplied (set FOUNDATION_BASELINE_DIR)"
fi
# T18 — owner art, the asset trees, zero new assets, no audio, no excluded pack.
PXO="$(find "$PROJ" -name '*.pxo' 2>/dev/null | head -1)"
TREES="$(find "$ROOT" -type d -name 'quaternius' 2>/dev/null | sed "s|^$ROOT/||" | sort | tr '\n' ' ')"
EXPECT_TREES="game/assets/third_party/quaternius game3d/assets/third_party/quaternius game3d_boss_spike/assets/third_party/quaternius game3d_spike/assets/third_party/quaternius "
DECLARED="$(grep -oE '"(bestiary_dungeon_monsters|universal_animation_library|universal_animation_library_2|modular_character_outfits_fantasy|ultimate_modular_ruins)/[^"]+"' "$PROJ/scripts/assets/asset_manifest.gd" | grep -vF '%s' | sort -u | wc -l | tr -d ' ')"
AUDIO="$(find "$PROJ" \( -name '*.wav' -o -name '*.ogg' -o -name '*.mp3' -o -name '*.flac' \) 2>/dev/null | head -1)"
BAD="$(find "$PROJ" \( -iname '*Puglin*' -o -iname '*UltimateMonsters*' -o -iname '*Dragon*' -o -iname '*PinkBlob*' \) 2>/dev/null | head -1)"
if [ -z "$PXO" ] && [ "$TREES" = "$EXPECT_TREES" ] && [ "$DECLARED" = "$DECLARED_THIRD_PARTY_FILES" ] \
   && [ -z "$AUDIO" ] && [ -z "$BAD" ]; then
  ok "T18 no .pxo in game3d/, exactly the four quaternius trees, $DECLARED declared third-party files in the D-370 manifest block (the D-380 stage added ZERO; D-392's separate placeholder intake is verified by W18), no audio, no excluded pack"
else
  fail "T18 isolation: pxo='$PXO' trees='$TREES' declared=$DECLARED audio='$AUDIO' excluded='$BAD'"
fi
# T19 — EXACTLY ONE input action added (D-381), and no W/A/S/D.
ACTIONS="$(grep -cE '^[a-z_][a-z_0-9]*=\{$' "$PROJ/project.godot")"
IMPRINT_ACTIONS="$(grep -cE '^imprint_[a-z_0-9]+=\{$' "$PROJ/project.godot")"
WASD=0
for code in 87 65 83 68; do
  N="$(grep -cF "\"physical_keycode\":$code" "$PROJ/project.godot" || true)"
  [ "$N" != "0" ] && WASD=1
done
CYCLE_ACTION="$(grep -cxF 'diagnostic_reservation_cycle={' "$PROJ/project.godot")"
# RE-PINNED UNDER D-396: 26 + 1 = 27 -- the Kindred Hounds stage adds EXACTLY
# `diagnostic_hound_fall`, named, so any other addition still fails.
# RE-PINNED UNDER D-398: 27 + 2 = 29 -- the mobile minion cohesion stage adds
# EXACTLY the two diagnostic modes, both named.
FALL_ACTION="$(grep -cxF 'diagnostic_hound_fall={' "$PROJ/project.godot")"
D398_ACTIONS="$(grep -cxE 'diagnostic_stress_population=\{|diagnostic_travel_speed=\{' "$PROJ/project.godot")"
if [ "$ACTIONS" = "29" ] && [ "$IMPRINT_ACTIONS" = "12" ] && [ "$CYCLE_ACTION" = "1" ] && [ "$FALL_ACTION" = "1" ] && [ "$D398_ACTIONS" = "2" ] && [ "$WASD" -eq 0 ]; then
  ok "T19 project.godot declares exactly 29 input actions (12 of them the Imprint stage's; D-380 added none, D-381 added EXACTLY diagnostic_reservation_cycle: 25 + 1 = 26; D-396 EXACTLY diagnostic_hound_fall: 26 + 1 = 27; D-398 EXACTLY its two diagnostic modes: 27 + 2 = 29) and NO W/A/S/D keycode"
else
  fail "T19 input actions $ACTIONS ($IMPRINT_ACTIONS imprint, diagnostic cycle $CYCLE_ACTION, D-396 fall $FALL_ACTION, D-398 modes $D398_ACTIONS), W/A/S/D present=$WASD"
fi

# -------------------------------------------- T20. the runners agree ----
say ""
say "[8/9] The three runners pin the same line and the same carried counts (T20)"
L_F="$(grep -E '^STATE_EXPECT=' "$PROJ/tests/foundation_smoke.sh" | head -1)"
L_I="$(grep -E '^STATE_EXPECT=' "$PROJ/tests/imprint_smoke.sh" | head -1)"
L_A="$(grep -E '^STATE_EXPECT=' "$PROJ/tests/alignment_smoke.sh" | head -1)"
CNT_OK=1
grep -qx 'PIN_CHECKS=85' "$PROJ/tests/foundation_smoke.sh" || CNT_OK=0
grep -qx 'PIN_DEFERRED=11' "$PROJ/tests/foundation_smoke.sh" || CNT_OK=0
for r in imprint_smoke.sh alignment_smoke.sh; do
  for p in 'PIN_F_CHECKS=85' 'PIN_F_DEFERRED=11' 'PIN_I_CHECKS=101' 'PIN_I_DEFERRED=16'; do
    grep -qx "$p" "$PROJ/tests/$r" || CNT_OK=0
  done
done
if [ -n "$L_F" ] && [ "$L_F" = "$L_I" ] && [ "$L_I" = "$L_A" ] && [ "$CNT_OK" -eq 1 ]; then
  ok "T20 the foundation, Imprint and D-380 runners pin the IDENTICAL state line and the same 85/11 and 101/16 counts"
else
  fail "T20 the runners disagree on the state line or a carried count"
fi

# ------------------------------------------------------- T21. evidence ----
say ""
say "[9/9] Rendered evidence — this stage's five captures, 11-15 (T21)"
T21_OK=1
for spec in $EV_CHECK; do
  out="${spec%%:*}.png"
  if [ -f "$PROJ/evidence/$out" ]; then
    DIM="$(sips -g pixelWidth -g pixelHeight "$PROJ/evidence/$out" 2>/dev/null \
           | awk '/pixel/{printf "%s", $2"x"} END{print ""}' | sed 's/x$//')"
    [ "$DIM" = "1920x1080" ] || { T21_OK=0; say "        evidence/$out is $DIM"; }
  else
    T21_OK=0; say "        evidence/$out missing (run with --with-evidence)"
  fi
done
case "$EV_RESULT" in *TIMEOUT*) T21_OK=0; say "        a capture exceeded its 120 s ceiling: $EV_RESULT";; esac
if [ "$T21_OK" -eq 1 ]; then
  if [ "$WITH_EVIDENCE" -eq 1 ]; then
    ok "T21 the two captures D-382 changes (14, 15) RENDERED natively at 1920x1080 in this run, and 11-13 are 1920x1080 (01-13 were NOT re-rendered)"
  else
    ok "T21 all five of this stage's captures (11-15) are 1920x1080 (rendering is opt-in; accepted evidence 01-10 untouched)"
  fi
else
  fail "T21 the D-380 evidence is missing, mis-sized, or timed out"
fi

# ------------------------------------------------------------------ verdict --
say ""
say "========================================================================"
[ "$F_RC" -ne 0 ] && fail "the ACCEPTED foundation suite exited non-zero ($F_RC)"
[ "$I_RC" -ne 0 ] && fail "the ACCEPTED Imprint suite exited non-zero ($I_RC)"
[ "$A_RC" -ne 0 ] && fail "the D-380 suite exited non-zero ($A_RC)"
if [ "$FAILED" -eq 0 ]; then
  say "ALIGNMENT RUNNER: PASS"
else
  say "ALIGNMENT RUNNER: FAIL"
fi
say ""
say "UNITS — NINE COUNTS, AND NONE IS A SYNONYM FOR ANOTHER:"
say "  D-380: 21 RUNNER CHECKS here · $PIN_A_CHECKS EXECUTABLE CHECKS in the D-380 suite ·"
say "         162 OWED CRITERIA in docs/testing/D380_ALIGNMENT_OWED_CRITERIA_INVENTORY.md"
say "         (28 checks and 121 criteria at delivery; + 7 and + 25 under D-381; + 5 and + 16 under D-382)"
say "  D-375: 26 RUNNER CHECKS · $PIN_I_CHECKS EXECUTABLE CHECKS · 149 OWED CRITERIA"
say "  D-370: 20 RUNNER CHECKS · $PIN_F_CHECKS EXECUTABLE CHECKS · 125 OWED CRITERIA"
say ""
say "This is the D-378 ALIGNMENT STAGE, the THIRD authorized stage of the canonical"
say "production project, ACCEPTED and CLOSED under D-383 and re-run here as a REGRESSION"
say "(the D-392 Huntress Splinter Shot stage was accepted under D-394; the D-396 Kindred"
say "Hounds stage is OPEN — run ./tests/hounds_smoke.sh)."
say "It is a SEMANTIC ALIGNMENT: NOT Huntress implementation, NOT"
say "progression tuning, NOT P2, and NOT a Machinations model. It COMPLETES NO PHASE,"
say "LOCKS NO NUMBER and ADOPTS NO D-378 TEST CANDIDATE."
say ""
say "$STATE_EXPECT"
say "========================================================================"
# OPT-IN: keep the three suites' full logs (every measured note) for the report.
if [ -n "${ALIGNMENT_KEEP_LOGS:-}" ] && [ -d "${ALIGNMENT_KEEP_LOGS}" ]; then
  cp "$FLOG" "$ALIGNMENT_KEEP_LOGS/foundation_suite.log"
  cp "$ILOG" "$ALIGNMENT_KEEP_LOGS/imprint_suite.log"
  cp "$ALOG" "$ALIGNMENT_KEEP_LOGS/alignment_suite.log"
fi
rm -f "$FLOG" "$ILOG" "$ALOG"
exit "$FAILED"
