#!/usr/bin/env bash
# =============================================================================
# RIFTWROUGHT — THE KINDRED HOUNDS STAGE RUNNER  (D-396, 2026-09-19)
# =============================================================================
#
# Runs ALL FIVE game3d/ suites headless against the final code: the ACCEPTED
# D-373 foundation suite, the ACCEPTED D-376 Imprint suite, the ACCEPTED D-383
# alignment suite and the ACCEPTED D-394 Splinter Shot suite as REGRESSIONS,
# then this stage's own suite. It checks their summaries, owed lists, printed
# rows, the state line, truthfulness, the isolation of every protected tree, the
# D-396 change set inside game3d/, the asset guards, the input map, the declared
# fixture and the rendered evidence.
#
#   tests/hounds_smoke.sh                  headless only (the default)
#   tests/hounds_smoke.sh --with-evidence  also RENDERS frames 24-31 first,
#                                          each under a hard 120 s ceiling
#
# Set FOUNDATION_BASELINE_DIR to a directory of pre-work SHA-256 listings
# (baseline_<tree>.sha256, baseline_archives.sha256) to run Y14, and
# D396_BASELINE_GAME3D to the PRE-D-396 listing of game3d/ to run Y15. Without
# them they print [SKIP], are NOT counted as passes, and the run is INCOMPLETE.
# (A separate variable, because the accepted D-380 and D-392 runners read a
# game3d/ listing from FOUNDATION_BASELINE_DIR for THEIR OWN delivery-time
# claims, which a pre-D-396 listing cannot satisfy.)
#
# =============================================================================
# UNITS. FIFTEEN COUNTS, AND NONE IS A SYNONYM FOR ANOTHER.
#
#   D-396: 21 RUNNER CHECKS here (Y01-Y21) · 45 EXECUTABLE CHECKS in
#          tests/hounds_verification.gd · 202 OWED CRITERIA in
#          docs/testing/D396_KINDRED_HOUNDS_OWED_CRITERIA_INVENTORY.md
#   D-392: 21 RUNNER CHECKS · 53 EXECUTABLE CHECKS · 203 OWED CRITERIA
#   D-380: 21 RUNNER CHECKS · 40 EXECUTABLE CHECKS · 162 OWED CRITERIA
#   D-375: 26 RUNNER CHECKS · 101 EXECUTABLE CHECKS · 149 OWED CRITERIA
#   D-370: 20 RUNNER CHECKS · 85 EXECUTABLE CHECKS · 125 OWED CRITERIA
# =============================================================================
#
# THIS RUNNER VERIFIES A STAGE DELIVERED OPEN. It accepts nothing. It is not
# P2, not full Beastmaster implementation, not final art, not VFX production
# and not tuning, and it locks no number.
# (True when written. D-397 ACCEPTED and CLOSED the stage; it is re-run here as a
# REGRESSION under the D-398 mobile minion cohesion stage, whose own runner is
# tests/cohesion_smoke.sh.)
#
# RE-PINNED UNDER D-398, AS ITS FIRST ACT, EXACTLY AS D-397 SECTION 6 RECOMMENDED.
# The runner STILL has 21 RUNNER CHECKS; these moved IN PLACE, one for one, in
# the same change as the artifact they guard:
#   * STATE_EXPECT (Y11, Y13): the five-fact line -> the six-fact line, and every
#     runner now also holds the D-396-era line as a SUPERSEDED needle;
#   * Y05, Y08, Y09: the D-396 suite's six KO- rows were ANSWERED under D-397 and
#     print DISCHARGED — D-397 with their text preserved: owed 6 -> 0,
#     discharged 0 -> 6 (6 - 6 = 0; 0 + 6 = 6; ZERO DELETED). The summary line
#     gained its discharged count, and Y08's third alteration now moves THAT;
#   * Y11: the self-acceptance needles follow the state -- the open D-398 stage
#     called accepted, or the D-392 or D-396 stage accepting ITSELF;
#   * Y12: the self-denial string follows its dated rewording, and the first and
#     last owner questions are sought as DISCHARGED rows;
#   * Y15: a D-396 DELIVERY-TIME claim no baseline can satisfy after D-398 -- it
#     prints [DECLARED] without a pre-D-396 listing (the D-392 runner's W17 is in
#     the same state since D-396); D-398's change set is tests/cohesion_smoke.sh Z16;
#   * Y17: TWO diagnostic input actions added under D-398 (27 + 2 = 29), named.
# =============================================================================
set -uo pipefail

GODOT="${GODOT:-/Applications/Godot.app/Contents/MacOS/Godot}"
HERE="$(cd "$(dirname "$0")" && pwd)"
PROJ="$(cd "$HERE/.." && pwd)"
ROOT="$(cd "$PROJ/.." && pwd)"
FLOG="$(mktemp -t hounds_foundation)"
ILOG="$(mktemp -t hounds_imprint)"
ALOG="$(mktemp -t hounds_alignment)"
HLOG="$(mktemp -t hounds_huntress)"
KLOG="$(mktemp -t hounds_stage)"
FAILED=0
SKIPPED=0
DECLARED_CLAIMS=0
WITH_EVIDENCE=0
[ "${1:-}" = "--with-evidence" ] && WITH_EVIDENCE=1

# THE ONE STATE LINE, identical in all five runners (Y13 compares them).
# RE-PINNED UNDER D-398 (first act): it read "... · KINDRED HOUNDS STAGE
# DELIVERED and OPEN pending owner live review (D-396)" until D-398 -- true when
# written; D-397 accepted this stage.
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
PIN_A_DEFERRED=10
PIN_H_CHECKS=53
PIN_H_DEFERRED=15
PIN_H_OWNER=0
PIN_H_DISCHARGED=4
PIN_K_CHECKS=45
PIN_K_DEFERRED=16
# 6 -> 0 UNDER D-398 (first act): KO-01..KO-06 were ANSWERED under D-397 and print
# DISCHARGED — D-397, text preserved. 6 - 6 = 0 owed; 0 + 6 = 6 discharged.
PIN_K_OWNER=0
PIN_K_DISCHARGED=6

# THE DECLARED D-396 CHANGE SET INSIDE game3d/, against the PRE-D-396 listing
# (taken 2026-09-19 16:54:16) — pinned in BOTH directions by Y15.
DECLARED_MODIFIED="README.md
project.godot
scripts/core/prod_config.gd
scripts/foundation_main.gd
scripts/huntress/huntress_config.gd
scripts/imprint/imprint.gd
scripts/imprint/imprint_config.gd
scripts/imprint/skill_configuration.gd
scripts/imprint/skill_runtime.gd
tests/alignment_smoke.sh
tests/alignment_verification.gd
tests/foundation_smoke.sh
tests/foundation_verification.gd
tests/huntress_smoke.sh
tests/huntress_verification.gd
tests/imprint_smoke.sh
tests/imprint_verification.gd"
D396_SCRIPTS="hound_config hound_content hound_review_hud hound_runtime hound_stand_in hound_targeting kindred_hound"
EV_FRAMES="24_d396_launch 25_d396_following 26_d396_acquisition 27_d396_retention 28_d396_leash_return 29_d396_bite 30_d396_fallen 31_d396_recovered"
DECLARED_NEW="$(
  printf '%s\n' tests/hounds_smoke.sh tests/hounds_verification.gd tests/hounds_verification.gd.uid
  for s in $D396_SCRIPTS; do printf 'scripts/hounds/%s.gd\nscripts/hounds/%s.gd.uid\n' "$s" "$s"; done
  for e in $EV_FRAMES; do printf 'evidence/%s.png\nevidence/%s.png.import\n' "$e" "$e"; done
)"
# The protected trees, each byte-identical to its pre-work listing (Y14).
PROTECTED="game game2d game3d_spike game3d_boss_spike game3d_huntress_spike models"
# The 26 input actions accepted before D-396, in project order (Y17).
ACCEPTED_ACTIONS="move_command stick_left stick_right stick_up stick_down aim_left aim_right aim_up aim_down diagnostic_attack zoom_in zoom_out toggle_overlay imprint_binding_1 imprint_binding_2 imprint_binding_3 imprint_binding_4 imprint_binding_5 imprint_binding_6 imprint_binding_7 imprint_binding_8 imprint_panel imprint_panel_prev imprint_panel_next imprint_panel_activate diagnostic_reservation_cycle"
FALL_ACTION="diagnostic_hound_fall"

say()  { printf '%s\n' "$*"; }
fail() { say "  [FAIL] $*"; FAILED=1; }
ok()   { say "  [ OK ] $*"; }
skip() { say "  [SKIP] $*"; SKIPPED=$((SKIPPED + 1)); }

say "========================================================================"
say "RIFTWROUGHT KINDRED HOUNDS STAGE RUNNER (D-396)"
say "Headless by default. Rendered evidence is opt-in via --with-evidence."
say "It runs the ACCEPTED D-373, D-376, D-383 and D-394 suites as REGRESSIONS, then this stage —"
say "ACCEPTED and CLOSED under D-397, re-run as a regression under the D-400 player locomotion redirection stage."
say "========================================================================"

# The evidence as it stands BEFORE this run -- Y19 proves a plain run leaves it alone.
EV_BEFORE="$(cd "$PROJ" && for e in $EV_FRAMES; do [ -f "evidence/$e.png" ] && shasum -a 256 "evidence/$e.png"; done)"

# --------------------------------------------- 0. opt-in evidence, rendered FIRST
EV_RESULT=""
CEILING=120
if [ "$WITH_EVIDENCE" -eq 1 ]; then
  say ""
  say "[0/9] Rendering this stage's eight captures (24-31) FIRST (opt-in) — never 01-23"
  "$GODOT" --headless --path "$PROJ" --import >/dev/null 2>&1
  for e in $EV_FRAMES; do
    mode="${e#*_}"
    "$GODOT" --path "$PROJ" --resolution 1920x1080 -- \
      --capture="$mode" --out="res://evidence/$e.png" --wait=90 >/dev/null 2>&1 &
    CAP_PID=$!
    CAP_WAITED=0
    while kill -0 "$CAP_PID" 2>/dev/null && [ "$CAP_WAITED" -lt "$CEILING" ]; do
      sleep 2
      CAP_WAITED=$((CAP_WAITED + 2))
    done
    if kill -0 "$CAP_PID" 2>/dev/null; then
      kill -9 "$CAP_PID" 2>/dev/null
      EV_RESULT="$EV_RESULT|$e:TIMEOUT"
    fi
    wait "$CAP_PID"
    RC=$?
    [ "$RC" -ne 0 ] && EV_RESULT="$EV_RESULT|$e:EXIT$RC"
    say "    rendered $e.png ($mode, ${CAP_WAITED}s, exit $RC)"
  done
fi

# ------------------------------------------------------------ Y01. import ----
say ""
say "[1/9] Import pass (Y01)"
"$GODOT" --headless --path "$PROJ" --import >/dev/null 2>&1
IMPORTED="$(ls "$PROJ/.godot/imported" 2>/dev/null | wc -l | tr -d ' ')"
UIDS=0
for s in $D396_SCRIPTS; do [ -f "$PROJ/scripts/hounds/$s.gd.uid" ] && UIDS=$((UIDS + 1)); done
if [ "$IMPORTED" -gt 0 ] && [ "$UIDS" = "7" ]; then
  ok "Y01 assets imported ($IMPORTED entries) and all 7 D-396 scripts carry their .uid — a fresh checkout verifies"
else
  fail "Y01 the import pass produced $IMPORTED entries; D-396 script uids $UIDS of 7"
fi

# ------------------------------------------------------ Y02-Y07. the suites --
say ""
say "[2/9] The five suites: D-373, D-376, D-383 and D-394 as REGRESSIONS, then D-396 (Y02-Y07)"
"$GODOT" --headless --path "$PROJ" --script res://tests/foundation_verification.gd >"$FLOG" 2>&1
F_RC=$?
"$GODOT" --headless --path "$PROJ" --script res://tests/imprint_verification.gd >"$ILOG" 2>&1
I_RC=$?
"$GODOT" --headless --path "$PROJ" --script res://tests/alignment_verification.gd >"$ALOG" 2>&1
A_RC=$?
"$GODOT" --headless --path "$PROJ" --script res://tests/huntress_verification.gd >"$HLOG" 2>&1
H_RC=$?
"$GODOT" --headless --path "$PROJ" --script res://tests/hounds_verification.gd >"$KLOG" 2>&1
K_RC=$?
grep -E "^  \[(PASS|FAIL|UNREACHED) *\]" "$KLOG" | sed 's/^/    /' | head -60
grep -E "^(FOUNDATION|IMPRINT|ALIGNMENT|HUNTRESS|HOUNDS) VERIFICATION:" \
  "$FLOG" "$ILOG" "$ALOG" "$HLOG" "$KLOG" | sed "s|^[^:]*:|    |"

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
H_EXPECT="HUNTRESS VERIFICATION: PASS ($PIN_H_CHECKS checks: $PIN_H_CHECKS passed, 0 failed/unreached, $PIN_H_DEFERRED deferred, $PIN_H_OWNER owed to the owner, $PIN_H_DISCHARGED discharged)"
K_EXPECT="HOUNDS VERIFICATION: PASS ($PIN_K_CHECKS checks: $PIN_K_CHECKS passed, 0 failed/unreached, $PIN_K_DEFERRED deferred, $PIN_K_OWNER owed to the owner, $PIN_K_DISCHARGED discharged)"
pin_summary Y02 "$FLOG" FOUNDATION "$PIN_F_CHECKS" "$PIN_F_DEFERRED"
pin_summary Y03 "$ILOG" IMPRINT "$PIN_I_CHECKS" "$PIN_I_DEFERRED"
pin_summary Y04 "$ALOG" ALIGNMENT "$PIN_A_CHECKS" "$PIN_A_DEFERRED"
H_LINE="$(grep -E '^HUNTRESS VERIFICATION:' "$HLOG" | head -1)"
K_LINE="$(grep -E '^HOUNDS VERIFICATION:' "$KLOG" | head -1)"
if [ "$H_LINE" = "$H_EXPECT" ] && [ "$K_LINE" = "$K_EXPECT" ]; then
  ok "Y05 the ACCEPTED Splinter Shot summary matches EXACTLY ($PIN_H_CHECKS checks, $PIN_H_DEFERRED deferred, $PIN_H_OWNER owed, $PIN_H_DISCHARGED discharged) and this stage's too ($PIN_K_CHECKS checks, $PIN_K_DEFERRED deferred, $PIN_K_OWNER owed to the owner, $PIN_K_DISCHARGED discharged — re-pinned under D-398)"
else
  fail "Y05 a summary MISMATCH"; say "        expected: $H_EXPECT"; say "        actual  : $H_LINE"
  say "        expected: $K_EXPECT"; say "        actual  : $K_LINE"
fi
OWED_OK=1
for spec in "$FLOG:$PIN_F_CHECKS:F" "$ILOG:$PIN_I_CHECKS:I" "$ALOG:$PIN_A_CHECKS:A" "$HLOG:$PIN_H_CHECKS:H" "$KLOG:$PIN_K_CHECKS:B"; do
  L="${spec%%:*}"; rest="${spec#*:}"; C="${rest%%:*}"; P="${rest#*:}"
  LINE="$(grep -E '^  owed=' "$L" | head -1 | sed 's/^ *//')"
  EXPECT="owed=$C  reached=$C  owed-but-not-reached=0 []  reached-but-not-owed=0 []"
  NAMES="$(grep -cE "^  \[PASS     \] $P[0-9]+_" "$L")"
  if [ "$LINE" != "$EXPECT" ] || [ "$NAMES" != "$C" ]; then
    OWED_OK=0; say "        $(basename "$L"): '$LINE' ($NAMES $P-names)"
  fi
done
if [ "$OWED_OK" -eq 1 ]; then
  ok "Y06 owed vs reached matches in BOTH directions in all five logs, and every F-, I-, A-, H- and B-numbered check passed"
else
  fail "Y06 owed/reached or name counts MISMATCH"
fi
RC_OK=1
for rc in "$F_RC" "$I_RC" "$A_RC" "$H_RC" "$K_RC"; do [ "$rc" -ne 0 ] && RC_OK=0; done
if [ "$RC_OK" -eq 1 ]; then
  ok "Y07 all five suites exited 0"
else
  fail "Y07 a suite exited non-zero (F $F_RC, I $I_RC, A $A_RC, H $H_RC, B $K_RC)"
fi

# ----------------------------------------------- Y08. pins able to refuse ----
say ""
say "[3/9] Every summary pin PROVED able to refuse an altered value (Y08)"
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
H_ALT1="$(printf '%s' "$H_LINE" | sed "s/($PIN_H_CHECKS checks/($((PIN_H_CHECKS - 1)) checks/")"
H_ALT2="$(printf '%s' "$H_LINE" | sed "s/, $PIN_H_DEFERRED deferred/, $((PIN_H_DEFERRED + 1)) deferred/")"
H_ALT3="$(printf '%s' "$H_LINE" | sed "s/, $PIN_H_DISCHARGED discharged/, $((PIN_H_DISCHARGED - 1)) discharged/")"
if [ "$H_ALT1" != "$H_EXPECT" ] && [ "$H_ALT2" != "$H_EXPECT" ] && [ "$H_ALT3" != "$H_EXPECT" ] && [ "$H_LINE" = "$H_EXPECT" ]; then
  REFUSED=$((REFUSED + 1))
fi
K_ALT1="$(printf '%s' "$K_LINE" | sed "s/($PIN_K_CHECKS checks/($((PIN_K_CHECKS - 1)) checks/")"
K_ALT2="$(printf '%s' "$K_LINE" | sed "s/, $PIN_K_DEFERRED deferred/, $((PIN_K_DEFERRED - 1)) deferred/")"
# D-398: the third alteration moves the DISCHARGED count (the owed count is 0).
K_ALT3="$(printf '%s' "$K_LINE" | sed "s/, $PIN_K_DISCHARGED discharged/, $((PIN_K_DISCHARGED - 1)) discharged/")"
if [ "$K_ALT1" != "$K_EXPECT" ] && [ "$K_ALT2" != "$K_EXPECT" ] && [ "$K_ALT3" != "$K_EXPECT" ] && [ "$K_LINE" = "$K_EXPECT" ]; then
  REFUSED=$((REFUSED + 1))
fi
if [ "$REFUSED" = "5" ]; then
  ok "Y08 all five summary pins REFUSE an altered check count AND an altered row count (the D-392 and D-396 pins also an altered discharged count) — replayed"
else
  fail "Y08 only $REFUSED of 5 summary pins were proved able to refuse an altered value"
fi

# -------------------------------------------------- Y09. printed rows ----
say ""
say "[4/9] Deferred, owed and discharged rows (Y09)"
KD_ROWS="$(grep -cE '^  \[[^]]+\] KD-(0[1-9]|1[0-6]) ' "$KLOG")"
# D-398 (first act): KO-01..KO-06 print DISCHARGED — D-397, none owed.
KO_ROWS="$(grep -cE '^  \[DISCHARGED — D-397\] KO-0[1-6] ' "$KLOG")"
KO_OWED="$(grep -cE '^  \[OWED-TO-OWNER\] KO-' "$KLOG")"
K_PASSROW="$(grep -cE '^  \[(PASS|OK) *\] K[DO]-' "$KLOG")"
KD14="$(grep -cE '^  \[DECLARED — NOT REPAIRED *\] KD-14 ' "$KLOG")"
KD11="$(grep -cE '^  \[CARRIED — NOT DISCHARGED *\] KD-11 ' "$KLOG")"
ROW_PREY="$(grep -E '^  \[[^]]+\] K[DO]-[0-9]+ ' "$KLOG" | grep -ci 'prey' || true)"
SO_DIS="$(grep -cE '^  \[DISCHARGED — D-394\] SO-0[1235] ' "$HLOG")"
SO_OWED="$(grep -cE '^  \[OWED-TO-OWNER\] SO-' "$HLOG")"
LEAK="$(grep -cE '^  \[(OWED-TO-OWNER|DISCHARGED — D-397)\] KO-|^  \[[^]]+\] KD-[0-9]+ |^HOUNDS VERIFICATION' "$FLOG" "$ILOG" "$ALOG" "$HLOG" | awk -F: '{s+=$2} END{print s+0}')"
if [ "$KD_ROWS" = "$PIN_K_DEFERRED" ] && [ "$KO_ROWS" = "$PIN_K_DISCHARGED" ] && [ "$KO_OWED" = "$PIN_K_OWNER" ] && [ "$K_PASSROW" = "0" ] && [ "$KD14" = "1" ] \
   && [ "$KD11" = "1" ] && [ "$ROW_PREY" = "0" ] && [ "$SO_DIS" = "$PIN_H_DISCHARGED" ] && [ "$SO_OWED" = "0" ] && [ "$LEAK" = "0" ]; then
  ok "Y09 the D-396 run prints KD-01..KD-16 ($KD_ROWS) and KO-01..KO-06 DISCHARGED — D-397 ($KO_ROWS, none owed), none as a pass and none naming Prey; KD-14 DECLARED — NOT REPAIRED and KD-11 CARRIED — NOT DISCHARGED; the D-392 run prints its four SO- rows DISCHARGED — D-394 and none owed; no D-396 row leaks into an accepted log"
else
  fail "Y09 rows: KD $KD_ROWS, KO discharged $KO_ROWS, KO owed $KO_OWED, as pass $K_PASSROW, KD-14 $KD14, KD-11 $KD11, naming Prey $ROW_PREY, SO discharged $SO_DIS, SO owed $SO_OWED, leaked $LEAK"
fi

# ---------------------------------------------------- Y10. engine errors ----
say ""
say "[5/9] Engine-error guard (Y10)"
ERRPAT='^(SCRIPT )?ERROR:|^USER ERROR:|^SCRIPT ERROR|Parse Error|Failed to load script'
SELF='Foundation_Signature_Move_THIS_DOES_NOT_EXIST'
SELF_N="$(grep -cF "$SELF" "$FLOG")"
F_REAL="$(grep -E "$ERRPAT" "$FLOG" | grep -vF "$SELF" || true)"
OTHER_REAL="$(grep -E "$ERRPAT" "$ILOG" "$ALOG" "$HLOG" "$KLOG" || true)"
PLANT="$(mktemp -t hounds_plant)"; cat "$KLOG" > "$PLANT"
printf 'SCRIPT ERROR: planted engine error, for guard proving only\n' >> "$PLANT"
if [ "$SELF_N" -lt 1 ]; then
  fail "Y10 the accepted suite's guard-proving error line is missing — F12's proof is not intact"
elif [ -n "$F_REAL" ] || [ -n "$OTHER_REAL" ]; then
  fail "Y10 engine errors present:"
  printf '%s\n' "$F_REAL" "$OTHER_REAL" | grep -v '^$' | head -12 | sed 's/^/        /'
elif ! grep -qE "$ERRPAT" "$PLANT"; then
  fail "Y10 the error guard could NOT detect a planted error line"
else
  ok "Y10 no engine error in any of the five logs beyond the one expected guard proof, and the guard refuses a planted error (a parse error EXITS 0 — measured under D-396 — so this guard, not the exit code, is what catches it)"
fi
rm -f "$PLANT"

# ------------------------------------ Y11-Y13. state line and truthfulness --
say ""
say "[6/9] The state line and truthfulness (Y11-Y13)"
BAD_STATE=0
for L in "$FLOG" "$ILOG" "$ALOG" "$HLOG" "$KLOG"; do
  N_STATE="$(grep -cE '^STATE: ' "$L")"
  N_EXACT="$(grep -cxF "$STATE_EXPECT" "$L")"
  if [ "$N_STATE" -lt 1 ] || [ "$N_STATE" != "$N_EXACT" ]; then
    BAD_STATE=1; say "        in $(basename "$L"): $N_EXACT of $N_STATE state lines exact"
  fi
done
SUPERSEDED=0
# D-402 (first act): the D-400-era line JOINS the superseded needles. 5 -> 6.
# D-404 (first act): the D-402-era line JOINS the superseded needles. 6 -> 7.
for S in "$STATE_D375_LINE" "$STATE_D380_LINE" "$STATE_D392_LINE" "$STATE_D396_LINE" "$STATE_D398_LINE" "$STATE_D400_LINE" "$STATE_D402_LINE" "STATE: DELIVERED and OPEN pending owner live review"; do
  grep -qxF "$S" "$FLOG" "$ILOG" "$ALOG" "$HLOG" "$KLOG" && SUPERSEDED=1
done
# RE-SCOPED UNDER D-398 (first act), one for one: until D-398 this refused "KINDRED
# HOUNDS STAGE ACCEPTED" -- true when written; D-397 made the acceptance the
# OWNER's, and the state line now carries it. What is still false, and refused:
# the D-392 or D-396 stage accepting ITSELF, and the OPEN D-398 stage called accepted.
# RE-SCOPED AGAIN UNDER D-400 (first act), one for one: D-400 made "MOBILE MINION
# COHESION STAGE ACCEPTED" the OWNER's fact, so it leaves the pattern and the OPEN
# D-400 stage takes its place. Still false, and refused: the D-392, D-396 or D-398
# stage accepting ITSELF, and the OPEN D-400 stage called accepted.
# RE-SCOPED AGAIN UNDER D-402 (first act), one for one: D-401 made "PLAYER
# LOCOMOTION REDIRECTION STAGE ACCEPTED" the OWNER's fact, so it leaves the
# pattern and the OPEN D-402 Cinder Field stage takes its place.
# RE-SCOPED UNDER D-404 (first act), one for one: D-403 made "CINDER FIELD
# STAGE ACCEPTED" the OWNER's fact -- it is in the state line itself -- so it
# leaves the pattern and the OPEN D-404 direct-click stage takes its place.
# "ACCEPTED and CLOSED (D-402)" joins what is still false: D-402 DELIVERED the
# Cinder Field stage and D-403 accepted it.
SELF_ACCEPT='PLAYER DIRECT-CLICK MOVEMENT CORRECTION STAGE ACCEPTED|D-404 (is|stage is) ACCEPTED|ACCEPTED and CLOSED \(D-402\)|ACCEPTED and CLOSED \(D-396\)|D-396 (is|stage is) ACCEPTED|ACCEPTED and CLOSED \(D-392\)|ACCEPTED and CLOSED \(D-398\)|ACCEPTED and CLOSED \(D-400\)'
ACCEPTS="$(grep -hE "$SELF_ACCEPT" "$FLOG" "$ILOG" "$ALOG" "$HLOG" "$KLOG" | head -3 || true)"
PLANT3="$(mktemp -t hounds_plant3)"; printf 'PLAYER DIRECT-CLICK MOVEMENT CORRECTION STAGE ACCEPTED and CLOSED (D-404)\n' > "$PLANT3"
ALT_STATE="$(printf '%s' "$STATE_EXPECT" | sed 's/DELIVERED and OPEN pending owner live review (D-404)/ACCEPTED and CLOSED (D-404)/')"
if [ "$BAD_STATE" -eq 0 ] && [ "$SUPERSEDED" -eq 0 ] && [ -z "$ACCEPTS" ] && grep -qE "$SELF_ACCEPT" "$PLANT3" \
   && [ "$ALT_STATE" != "$STATE_EXPECT" ] && [ "$STATE_D392_LINE" != "$STATE_EXPECT" ] && [ "$STATE_D396_LINE" != "$STATE_EXPECT" ] \
   && [ "$STATE_D398_LINE" != "$STATE_EXPECT" ] && [ "$STATE_D400_LINE" != "$STATE_EXPECT" ] \
   && [ "$STATE_D402_LINE" != "$STATE_EXPECT" ]; then
  ok "Y11 every STATE line in all five logs is the SAME exact nine-fact line (D-404 first act); no superseded line (D-375, D-380, D-392, D-396, D-398, D-400, D-402, bare D-370) is printed; nothing claims a self-acceptance — and each scan refuses a planted line"
else
  fail "Y11 a state line differs ($BAD_STATE), a superseded line is printed ($SUPERSEDED), or a self-acceptance appears: $ACCEPTS"
fi
rm -f "$PLANT3"
Y12_MISS=""
for s in "The D-396 stage IS NOT P2 and AUTHORIZES NO P2." \
         "IS NOT full Beastmaster implementation" \
         "implements NO other roster Skill" \
         "IMPLEMENTS NO RIFT SHARDS" \
         "PROCEDURAL STAND-INS — NOT final art, animation or VFX" \
         "LOCKS NO NUMBER" \
         "Huntress's Mark remains a FUTURE concept and is NOT implemented" \
         "adds NO rarity-based targeting" \
         "Ordinary enemies DO NOT select hounds" \
         "is a REVIEW CONTROL and NOT a command" \
         "Capacity is NOT increased (30 + 5 = 35)" \
         "review tooling and IS NOT a UI foundation" \
         "has NO runtime dependency on the closed D-388 spike" \
         "The D-396 stage was delivered OPEN and never accepted itself: the owner ACCEPTED and CLOSED it under D-397" \
         "[DISCHARGED — D-397] KO-01 Whether the hounds feel autonomous rather than managed." \
         "[DISCHARGED — D-397] KO-06 Whether fallen-hound recovery feels sufficiently low-friction." \
         "PRE-EXISTING (accepted D-392 loadout, NOT repaired)"; do
  grep -qF "$s" "$KLOG" || Y12_MISS="$Y12_MISS | $s"
done
FORBID='P2 is authorized|P1 is complete|final animation is (approved|accepted)|the release timing is locked|0\.5 s is locked|Coursing Hounds (are|is) implemented|the multi-target (Prey )?rule is (resolved|decided)|Mark is implemented|Prey is designated|production ready|pivot complete|Beastmaster is complete|Additional Minion is implemented|the pack size is locked|the (reservation|leash|recovery delay|acquisition range) is locked|final hound art is (approved|accepted)'
PLANT2="$(mktemp -t hounds_plant2)"; printf 'the pack size is locked\n' > "$PLANT2"
if [ -n "$Y12_MISS" ]; then
  fail "Y12 the D-396 run does NOT state:$Y12_MISS"
elif grep -qiE "$FORBID" "$FLOG" "$ILOG" "$ALOG" "$HLOG" "$KLOG"; then
  fail "Y12 a run log makes a forbidden lock or completion claim:"
  grep -hiE "$FORBID" "$FLOG" "$ILOG" "$ALOG" "$HLOG" "$KLOG" | head -3 | sed 's/^/        /'
elif ! grep -qiE "$FORBID" "$PLANT2"; then
  fail "Y12 the forbidden-claim scan cannot see a planted claim"
else
  ok "Y12 the D-396 run states its seventeen truthfulness strings (fourteen denials among them — the self-denial now dated history naming D-397 — the first and last owner questions, now DISCHARGED — D-397, and the pre-existing overflow finding), no log makes a forbidden lock or completion claim, and the scan refuses a planted one"
fi
rm -f "$PLANT2"
L_F="$(grep -E '^STATE_EXPECT=' "$PROJ/tests/foundation_smoke.sh" | head -1)"
L_I="$(grep -E '^STATE_EXPECT=' "$PROJ/tests/imprint_smoke.sh" | head -1)"
L_A="$(grep -E '^STATE_EXPECT=' "$PROJ/tests/alignment_smoke.sh" | head -1)"
L_H="$(grep -E '^STATE_EXPECT=' "$PROJ/tests/huntress_smoke.sh" | head -1)"
L_K="$(grep -E '^STATE_EXPECT=' "$0" | head -1)"
NEEDLES=0
NEEDLES_396=0
NEEDLES_398=0
for r in foundation_smoke.sh imprint_smoke.sh alignment_smoke.sh huntress_smoke.sh hounds_smoke.sh; do
  grep -qxF "STATE_D392_LINE=\"$STATE_D392_LINE\"" "$PROJ/tests/$r" && NEEDLES=$((NEEDLES + 1))
  grep -qxF "STATE_D396_LINE=\"$STATE_D396_LINE\"" "$PROJ/tests/$r" && NEEDLES_396=$((NEEDLES_396 + 1))
  grep -qxF "STATE_D398_LINE=\"$STATE_D398_LINE\"" "$PROJ/tests/$r" && NEEDLES_398=$((NEEDLES_398 + 1))
done
CNT_OK=1
for r in imprint_smoke.sh alignment_smoke.sh huntress_smoke.sh hounds_smoke.sh; do
  for p in 'PIN_F_CHECKS=85' 'PIN_F_DEFERRED=11' 'PIN_I_CHECKS=101' 'PIN_I_DEFERRED=16'; do
    grep -qx "$p" "$PROJ/tests/$r" || CNT_OK=0
  done
done
for r in alignment_smoke.sh huntress_smoke.sh hounds_smoke.sh; do
  for p in 'PIN_A_CHECKS=40' 'PIN_A_DEFERRED=10'; do grep -qx "$p" "$PROJ/tests/$r" || CNT_OK=0; done
done
for r in huntress_smoke.sh hounds_smoke.sh; do
  for p in 'PIN_H_CHECKS=53' 'PIN_H_DEFERRED=15' 'PIN_H_OWNER=0' 'PIN_H_DISCHARGED=4'; do grep -qx "$p" "$PROJ/tests/$r" || CNT_OK=0; done
done
if [ -n "$L_F" ] && [ "$L_F" = "$L_I" ] && [ "$L_I" = "$L_A" ] && [ "$L_A" = "$L_H" ] && [ "$L_H" = "$L_K" ] \
   && [ "$L_K" = "STATE_EXPECT=\"$STATE_EXPECT\"" ] && [ "$NEEDLES" = "5" ] && [ "$NEEDLES_396" = "5" ] \
   && [ "$NEEDLES_398" = "5" ] && [ "$CNT_OK" -eq 1 ]; then
  ok "Y13 the five runners pin the IDENTICAL seven-fact state line, each holds the D-392-era, (D-398) the D-396-era AND (D-400) the D-398-era line as SUPERSEDED needles, and they carry the same accepted counts (85/11, 101/16, 40/10, 53/15 with 0 owed and 4 discharged)"
else
  fail "Y13 the runners disagree on the state line, a needle (D-392 $NEEDLES of 5, D-396 $NEEDLES_396 of 5, D-398 $NEEDLES_398 of 5) or a carried count (ok=$CNT_OK)"
fi

# ------------------------------------------------ Y14-Y18. isolation ----
say ""
say "[7/9] Isolation, the change set, the asset guards, the input map and the units (Y14-Y18)"
BASE="${FOUNDATION_BASELINE_DIR:-}"
Y14_OK=1; Y14_RAN=0; N_ARCH=0
for d in $PROTECTED; do
  f="$BASE/baseline_$d.sha256"
  if [ -n "$BASE" ] && [ -f "$f" ]; then
    Y14_RAN=$((Y14_RAN + 1))
    NOW="$(mktemp -t hounds_now)"
    ( cd "$ROOT" && find "$d" -type f -print0 | sort -z | xargs -0 shasum -a 256 ) > "$NOW"
    if ! diff -q "$f" "$NOW" >/dev/null; then
      Y14_OK=0; say "        $d/ CHANGED"
      diff "$f" "$NOW" | grep -E '^[<>]' | head -6 | sed 's/^/          /'
    fi
    rm -f "$NOW"
  fi
done
if [ -n "$BASE" ] && [ -f "$BASE/baseline_archives.sha256" ]; then
  Y14_RAN=$((Y14_RAN + 1))
  NOW="$(mktemp -t hounds_now)"
  ( cd "$ROOT" && sed -E 's/^[0-9a-f]+  //' "$BASE/baseline_archives.sha256" | while IFS= read -r p; do
      shasum -a 256 "$p"; done ) | sort -k2 > "$NOW"
  N_ARCH="$(wc -l < "$NOW" | tr -d ' ')"
  diff -q "$BASE/baseline_archives.sha256" "$NOW" >/dev/null || { Y14_OK=0; say "        an archive under assets/ CHANGED"; }
  rm -f "$NOW"
fi
if [ "$Y14_RAN" -eq 7 ] && [ "$Y14_OK" -eq 1 ]; then
  ok "Y14 game/, game2d/, game3d_spike/, game3d_boss_spike/, game3d_huntress_spike/ (README included), models/ and all $N_ARCH archives under assets/ are byte-identical to the pre-work baseline"
elif [ "$Y14_RAN" -eq 0 ]; then
  skip "Y14 baselines not supplied (set FOUNDATION_BASELINE_DIR) — NOT a pass"
else
  fail "Y14 a protected tree or archive changed, or a baseline is missing ($Y14_RAN of 7 measured)"
fi
G3="${D396_BASELINE_GAME3D:-}"
if [ -n "$G3" ] && [ -f "$G3" ]; then
  NOW="$(mktemp -t hounds_now)"
  ( cd "$ROOT" && find game3d -type f -not -path 'game3d/.godot/*' -print0 | sort -z \
    | xargs -0 shasum -a 256 ) > "$NOW"
  B_PATHS="$(sed -E 's/^[0-9a-f]+  //' "$G3" | sort)"
  N_PATHS="$(sed -E 's/^[0-9a-f]+  //' "$NOW" | sort)"
  CHANGED="$(diff <(sort -k2 "$G3") <(sort -k2 "$NOW") | grep -E '^[<>]' \
             | sed -E 's/^[<>] [0-9a-f]+  //' | sort -u)"
  ADDED="$(comm -13 <(printf '%s\n' "$B_PATHS") <(printf '%s\n' "$N_PATHS"))"
  REMOVED="$(comm -23 <(printf '%s\n' "$B_PATHS") <(printf '%s\n' "$N_PATHS"))"
  MODIFIED="$(comm -12 <(printf '%s\n' "$CHANGED") <(printf '%s\n' "$B_PATHS") | comm -12 - <(printf '%s\n' "$N_PATHS"))"
  EXP_MOD="$(printf '%s\n' "$DECLARED_MODIFIED" | sed 's|^|game3d/|' | sort)"
  EXP_NEW="$(printf '%s\n' "$DECLARED_NEW" | sed 's|^|game3d/|' | sort)"
  # THE COMPARISON CAN REFUSE: one undeclared file, planted into the measured set.
  PLANTED_SET="$(printf '%s\ngame3d/scripts/combat/ordinary_enemy.gd\n' "$MODIFIED" | sort -u)"
  if [ -z "$REMOVED" ] && [ "$MODIFIED" = "$EXP_MOD" ] && [ "$ADDED" = "$EXP_NEW" ] && [ "$PLANTED_SET" != "$EXP_MOD" ]; then
    ok "Y15 inside game3d/: exactly the $(printf '%s\n' "$EXP_MOD" | wc -l | tr -d ' ') declared files changed and the $(printf '%s\n' "$EXP_NEW" | wc -l | tr -d ' ') declared files are new — EVERY other authored file is byte-identical (combat, world, view, huntress runtime, scenes, the asset trees, evidence 01-23); a planted undeclared change is refused"
  else
    fail "Y15 the game3d/ change set differs from the declared set"
    say "        undeclared/missing modifications:"; diff <(printf '%s\n' "$MODIFIED") <(printf '%s\n' "$EXP_MOD") | grep -E '^[<>]' | head -8 | sed 's/^/          /'
    say "        undeclared/missing additions:";    diff <(printf '%s\n' "$ADDED") <(printf '%s\n' "$EXP_NEW") | grep -E '^[<>]' | head -8 | sed 's/^/          /'
    [ -n "$REMOVED" ] && { say "        removed:"; printf '%s\n' "$REMOVED" | head -5 | sed 's/^/          /'; }
  fi
  rm -f "$NOW"
else
  # RE-SCOPED UNDER D-398, one for one: Y15 is a D-396 DELIVERY-TIME claim -- its
  # change set against a pre-D-396 listing of game3d/. That listing is gone, and
  # after D-398 changes further files NO listing exists against which it can pass.
  # So without one it is DECLARED, not skipped -- exactly as W17 has been since
  # D-396. tests/cohesion_smoke.sh Z16 proves D-398's own change set in both
  # directions. Until D-398 this printed [SKIP] and made the run INCOMPLETE.
  say "  [DECLARED] Y15 a D-396 delivery-time claim (its change set against a pre-D-396 listing); superseded by the D-398 and D-400 stages, whose change sets tests/cohesion_smoke.sh Z16 and tests/locomotion_smoke.sh N16 prove — NOT a pass and NOT a skip"
  DECLARED_CLAIMS=$((DECLARED_CLAIMS + 1))
fi
# Y16 — NO NEW ASSET, NO HOUND ART, NO VFX, NO AUDIO, NO .pxo, the four trees.
PXO="$(find "$PROJ" -name '*.pxo' 2>/dev/null | head -1)"
TREES="$(find "$ROOT" -type d -name 'quaternius' 2>/dev/null | sed "s|^$ROOT/||" | sort | tr '\n' ' ')"
EXPECT_TREES="game/assets/third_party/quaternius game3d/assets/third_party/quaternius game3d_boss_spike/assets/third_party/quaternius game3d_spike/assets/third_party/quaternius "
AUDIO="$(find "$PROJ" \( -name '*.wav' -o -name '*.ogg' -o -name '*.mp3' -o -name '*.flac' \) 2>/dev/null | head -1)"
BAD="$(find "$PROJ" \( -iname '*UltimateMonsters*' -o -iname '*Ultimate_Monsters*' -o -iname '*dog*' -o -iname '*hound*.glb' \
        -o -iname '*hound*.gltf' -o -iname '*hound*.obj' -o -iname '*hound*.fbx' -o -iname '*wolf*' -o -iname '*VFX*' \
        -o -iname '*BattleFX*' -o -iname '*MagicFX*' -o -iname '*VividMotion*' -o -iname '*prey*' \) \
        -not -path '*/.godot/*' 2>/dev/null | head -1)"
# RE-PINNED UNDER D-402, ONE FOR ONE: 29 + 4 = 33 -- the two Cinder Field
# placeholder bodies (.obj + .mtl each) added to the ALREADY-DECLARED CC0
# Ultimate Modular Ruins pack. The variable keeps its NAME so nothing is
# renamed around a guard; its expected value moves. Until D-402 it was 29.
DECLARED29="$(grep -oE '"(bestiary_dungeon_monsters|universal_animation_library|universal_animation_library_2|modular_character_outfits_fantasy|ultimate_modular_ruins)/[^"]+"' "$PROJ/scripts/assets/asset_manifest.gd" | grep -vF '%s' | sort -u | wc -l | tr -d ' ')"
HOUND_ASSET_REFS="$(grep -lE 'res://assets|preload\(|[^_]load\(' "$PROJ"/scripts/hounds/*.gd 2>/dev/null | head -1)"
if [ -z "$PXO" ] && [ "$TREES" = "$EXPECT_TREES" ] && [ -z "$AUDIO" ] && [ -z "$BAD" ] && [ "$DECLARED29" = "33" ] && [ -z "$HOUND_ASSET_REFS" ]; then
  ok "Y16 no .pxo, no audio, no hound model, dog, wolf, Ultimate Monsters, VFX or Prey file in game3d/; the D-370 block still declares 29; no hound script loads anything; exactly the four quaternius trees in the repository"
else
  fail "Y16 pxo='$PXO' trees='$TREES' audio='$AUDIO' excluded='$BAD' declared=$DECLARED29 hound load='$HOUND_ASSET_REFS'"
fi
# Y17 — EXACTLY ONE input action added: the accepted 26 in order, then the fall
# control, on key H and the pad's D-pad left, clashing with nothing.
ACT_LIST="$(grep -oE '^[a-z_][a-z_0-9]*=\{$' "$PROJ/project.godot" | tr -d '={' | tr '\n' ' ' | sed 's/ $//')"
FALL_BLOCK="$(awk '/^diagnostic_hound_fall=\{/{f=1} f{print} f&&/^}/{exit}' "$PROJ/project.godot")"
FALL_KEYS="$(printf '%s' "$FALL_BLOCK" | grep -oE '"physical_keycode":[0-9]+' | tr '\n' ' ')"
FALL_PADS="$(printf '%s' "$FALL_BLOCK" | grep -oE '"button_index":[0-9]+' | tr '\n' ' ')"
H_USERS="$(grep -cF '"physical_keycode":72,' "$PROJ/project.godot")"
DPAD_USERS="$(awk '/InputEventJoypadButton/ && /"button_index":13,/' "$PROJ/project.godot" | wc -l | tr -d ' ')"
WASD=0
for code in 87 65 83 68; do
  N="$(grep -cF "\"physical_keycode\":$code," "$PROJ/project.godot" || true)"
  [ "$N" != "0" ] && WASD=1
done
# RE-PINNED UNDER D-398, one for one: 27 + 2 = 29 -- after the fall control come
# EXACTLY the D-398 ruling's two diagnostic modes, in order, named.
D398_ACTIONS="diagnostic_stress_population diagnostic_travel_speed"
PLANT_LIST="$ACCEPTED_ACTIONS diagnostic_pet_command $FALL_ACTION $D398_ACTIONS"
if [ "$ACT_LIST" = "$ACCEPTED_ACTIONS $FALL_ACTION $D398_ACTIONS" ] && [ "$FALL_KEYS" = '"physical_keycode":72 ' ] \
   && [ "$FALL_PADS" = '"button_index":13 ' ] && [ "$H_USERS" = "1" ] && [ "$DPAD_USERS" = "1" ] && [ "$WASD" -eq 0 ] \
   && [ "$PLANT_LIST" != "$ACT_LIST" ]; then
  ok "Y17 project.godot declares the 26 accepted actions unchanged and in order, then EXACTLY diagnostic_hound_fall (26 + 1 = 27) on key H and pad D-pad left, used by nothing else, then (D-398) EXACTLY the two diagnostic modes (27 + 2 = 29); no W/A/S/D; a planted extra action is refused"
else
  fail "Y17 actions '$ACT_LIST' | fall keys '$FALL_KEYS' pads '$FALL_PADS' | H users $H_USERS, D-pad-left users $DPAD_USERS, W/A/S/D=$WASD"
fi
# Y18 — THE UNITS, stated where they are owed.
INV="$ROOT/docs/testing/D396_KINDRED_HOUNDS_OWED_CRITERIA_INVENTORY.md"
OWED_N="$(awk '/^const OWED := \[/{f=1; next} f&&/^\]/{exit} f' "$PROJ/tests/hounds_verification.gd" | grep -cE '^\s*"B[0-9][0-9]_')"
RUNNER_N="$(grep -oE 'Y[0-9][0-9]' "$0" | sort -u | wc -l | tr -d ' ')"
if [ -f "$INV" ] && grep -qF '= **202**' "$INV" && grep -qF '`B01`…`B45` = **45**' "$INV" && grep -qF '`Y01`…`Y21` = **21**' "$INV" \
   && [ "$OWED_N" = "45" ] && [ "$RUNNER_N" = "21" ]; then
  ok "Y18 the inventory states 202 OWED CRITERIA, 45 EXECUTABLE CHECKS and 21 RUNNER CHECKS; the suite owes $OWED_N and this runner makes $RUNNER_N — different units, none a synonym"
else
  fail "Y18 units: inventory present=$([ -f "$INV" ] && echo yes || echo no), suite owes $OWED_N, runner makes $RUNNER_N"
fi

# ------------------------------------------- Y19-Y20. rendered evidence ----
say ""
say "[8/9] Rendered evidence is opt-in and bounded (Y19)"
EV_AFTER="$(cd "$PROJ" && for e in $EV_FRAMES; do [ -f "evidence/$e.png" ] && shasum -a 256 "evidence/$e.png"; done)"
CEIL_OK=0
grep -qE 'CAP_WAITED" -lt "\$CEILING"' "$0" && [ "$CEILING" -le 120 ] && CEIL_OK=1
if [ "$WITH_EVIDENCE" -eq 0 ] && [ "$EV_BEFORE" = "$EV_AFTER" ] && [ "$CEIL_OK" -eq 1 ]; then
  ok "Y19 this plain run was HEADLESS ONLY and left the evidence untouched; a rendered run is opt-in (--with-evidence) with a hard ${CEILING} s ceiling per capture"
elif [ "$WITH_EVIDENCE" -eq 1 ] && [ "$CEIL_OK" -eq 1 ] && [ -z "$EV_RESULT" ]; then
  ok "Y19 rendering was OPTED IN; each of the eight captures reached its state, finished inside its ${CEILING} s ceiling and exited 0"
else
  fail "Y19 evidence changed without opting in, a capture timed out or refused its state ($EV_RESULT), or the ceiling is missing"
fi
say ""
say "[9/9] This stage's eight captures (Y20) and the declared fixture (Y21)"
Y20_OK=1
for e in $EV_FRAMES; do
  if [ -f "$PROJ/evidence/$e.png" ]; then
    DIM="$(sips -g pixelWidth -g pixelHeight "$PROJ/evidence/$e.png" 2>/dev/null \
           | awk '/pixel/{printf "%s", $2"x"} END{print ""}' | sed 's/x$//')"
    [ "$DIM" = "1920x1080" ] || { Y20_OK=0; say "        evidence/$e.png is $DIM"; }
  else
    Y20_OK=0; say "        evidence/$e.png missing (run with --with-evidence)"
  fi
done
if [ "$Y20_OK" -eq 1 ]; then
  ok "Y20 all eight D-396 captures (24-31) exist at 1920x1080 — accepted evidence 01-23 is untouched (Y15)"
else
  fail "Y20 the D-396 evidence is missing or mis-sized"
fi
# Y21 — THE DECLARED FIXTURE: called by the four accepted suites (once each) and
# this suite, and in the runtime only by the capture path; the composed stage
# shows in every accepted log exactly once, through its banner, and no D-396 row
# or summary does.
# Paths are read LINE BY LINE: this repository's path contains spaces, which
# `xargs basename` splits (measured on the first D-396 run).
CALLERS="$(grep -lF 'restore_accepted_d392_loadout(' "$PROJ"/tests/*.gd | while IFS= read -r f; do basename "$f"; done | sort | tr '\n' ' ')"
RT_CALLERS="$(grep -rlF 'restore_accepted_d392_loadout(' "$PROJ/scripts" | while IFS= read -r f; do basename "$f"; done | sort | tr '\n' ' ')"
ONCE=1
for s in foundation imprint alignment huntress; do
  N="$(grep -cF 'main.get("hounds").restore_accepted_d392_loadout()' "$PROJ/tests/${s}_verification.gd")"
  [ "$N" = "1" ] || ONCE=0
done
BANNERS=1
for L in "$FLOG" "$ILOG" "$ALOG" "$HLOG" "$KLOG"; do
  N="$(grep -cF 'RIFTWROUGHT — KINDRED HOUNDS STAGE  (D-396, 2026-09-19)' "$L")"
  [ "$N" = "1" ] || BANNERS=0
done
if [ "$CALLERS" = "alignment_verification.gd foundation_verification.gd hounds_verification.gd huntress_verification.gd imprint_verification.gd " ] \
   && [ "$RT_CALLERS" = "foundation_main.gd hound_runtime.gd " ] && [ "$ONCE" -eq 1 ] && [ "$BANNERS" -eq 1 ] && [ "$LEAK" = "0" ]; then
  ok "Y21 the declared fixture is called by the four accepted suites (once each) and the D-396 suite, and in the runtime only by the capture path and its definition; every log shows the composed stage once, and no D-396 row leaks into an accepted log"
else
  fail "Y21 fixture callers '$CALLERS', runtime '$RT_CALLERS', once each=$ONCE, banners=$BANNERS, leaked rows=$LEAK"
fi

# ------------------------------------------------------------------ verdict --
say ""
say "========================================================================"
say "UNITS: 21 RUNNER CHECKS here · 45 EXECUTABLE CHECKS · 202 OWED CRITERIA — different units."
say "$STATE_EXPECT"
if [ "$FAILED" -eq 0 ] && [ "$SKIPPED" -eq 0 ] && [ "$DECLARED_CLAIMS" -gt 0 ]; then
  say "HOUNDS RUNNER: PASS (21 runner checks: $((21 - DECLARED_CLAIMS)) run and passed, $DECLARED_CLAIMS DECLARED delivery-time claim(s) — D-398)"
elif [ "$FAILED" -eq 0 ] && [ "$SKIPPED" -eq 0 ]; then
  say "HOUNDS RUNNER: PASS (21 runner checks)"
elif [ "$FAILED" -eq 0 ]; then
  say "HOUNDS RUNNER: INCOMPLETE — $SKIPPED runner check(s) SKIPPED for lack of a baseline; NOT a pass"
  FAILED=1
else
  say "HOUNDS RUNNER: FAIL"
fi
say "========================================================================"
# Set HOUNDS_LOG_DIR to keep the five suite logs (a run of record cites them).
if [ -n "${HOUNDS_LOG_DIR:-}" ] && [ -d "$HOUNDS_LOG_DIR" ]; then
  cp "$FLOG" "$HOUNDS_LOG_DIR/foundation.log"; cp "$ILOG" "$HOUNDS_LOG_DIR/imprint.log"
  cp "$ALOG" "$HOUNDS_LOG_DIR/alignment.log"; cp "$HLOG" "$HOUNDS_LOG_DIR/huntress.log"
  cp "$KLOG" "$HOUNDS_LOG_DIR/hounds.log"
fi
rm -f "$FLOG" "$ILOG" "$ALOG" "$HLOG" "$KLOG"
exit "$FAILED"
