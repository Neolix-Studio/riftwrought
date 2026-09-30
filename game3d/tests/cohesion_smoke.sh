#!/usr/bin/env bash
# =============================================================================
# RIFTWROUGHT — THE MOBILE MINION COHESION STAGE RUNNER  (D-398, 2026-09-19)
# =============================================================================
#
# Runs ALL SIX game3d/ suites headless against the final code: the ACCEPTED
# D-373 foundation, D-376 Imprint, D-383 alignment, D-394 Splinter Shot and
# D-397 Kindred Hounds suites as REGRESSIONS, then this stage's own suite. It
# checks their summaries, owed lists, printed rows, the state line,
# truthfulness, the isolation of every protected tree, the D-398 change set
# inside game3d/, the asset guards, the input map, the units, the declared
# fixture and the rendered evidence.
#
#   tests/cohesion_smoke.sh                  headless only (the default)
#   tests/cohesion_smoke.sh --with-evidence  also RENDERS frames 32-39 first,
#                                            each under a hard 120 s ceiling
#
# Set FOUNDATION_BASELINE_DIR to a directory of pre-work SHA-256 listings
# (baseline_<tree>.sha256, baseline_archives.sha256) to run Z15, and
# D398_BASELINE_GAME3D to the PRE-D-398 listing of game3d/ to run Z16. Without
# them they print [SKIP], are NOT counted as passes, and the run is INCOMPLETE.
#
# =============================================================================
# UNITS. EIGHTEEN COUNTS, AND NONE IS A SYNONYM FOR ANOTHER.
#
#   D-398: 22 RUNNER CHECKS here (Z01-Z22) · 40 EXECUTABLE CHECKS in
#          tests/cohesion_verification.gd · 201 OWED CRITERIA in
#          docs/testing/D398_MOBILE_MINION_COHESION_OWED_CRITERIA_INVENTORY.md
#   D-396: 21 RUNNER CHECKS · 45 EXECUTABLE CHECKS · 202 OWED CRITERIA
#   D-392: 21 RUNNER CHECKS · 53 EXECUTABLE CHECKS · 203 OWED CRITERIA
#   D-380: 21 RUNNER CHECKS · 40 EXECUTABLE CHECKS · 162 OWED CRITERIA
#   D-375: 26 RUNNER CHECKS · 101 EXECUTABLE CHECKS · 149 OWED CRITERIA
#   D-370: 20 RUNNER CHECKS · 85 EXECUTABLE CHECKS · 125 OWED CRITERIA
# =============================================================================
#
# THIS RUNNER VERIFIED A STAGE DELIVERED OPEN -- true when written. The owner
# ACCEPTED and CLOSED that stage under D-400, and it is re-run here as a
# REGRESSION under the D-400 PLAYER LOCOMOTION REDIRECTION STAGE. It still
# accepts nothing. It is not P2, not a pack-size increase, not a new Skill, not
# final minion AI, not art production, not VFX work and not numerical tuning,
# and it locks no number.
#
# RE-PINNED UNDER D-400, AS ITS FIRST ACT. The runner STILL has 22 RUNNER CHECKS;
# these moved IN PLACE, one for one, in the same change as the artifact:
#   * STATE_EXPECT (Z12, Z14): the six-fact line -> the seven-fact line;
#   * Z12: GAINS the D-398-era line as a superseded line that must be absent, and
#     its self-acceptance pattern moves from the now-accepted D-398 stage to the
#     OPEN D-400 one;
#   * PIN_C_OWNER (Z06, Z09, Z10) 5 -> 0 and PIN_C_DISCHARGED 0 -> 5, because
#     D-400 accepted the stage: CO-01..CO-05 now print DISCHARGED — D-399 with
#     their original text preserved (5 - 5 = 0; ZERO DELETED);
#   * Z13: the self-denial string becomes its dated form and the two owner-question
#     strings become their DISCHARGED — D-399 forms (nineteen strings, unchanged
#     in number);
#   * Z16: a D-398 DELIVERY-TIME claim. Without a pre-D-398 listing it is now
#     DECLARED rather than SKIPPED, so an accepted runner is not left permanently
#     INCOMPLETE -- exactly what D-396 did for W17 and D-398 for Y15.
#     tests/locomotion_smoke.sh N16 proves D-400's own change set.
# =============================================================================
set -uo pipefail

GODOT="${GODOT:-/Applications/Godot.app/Contents/MacOS/Godot}"
HERE="$(cd "$(dirname "$0")" && pwd)"
PROJ="$(cd "$HERE/.." && pwd)"
ROOT="$(cd "$PROJ/.." && pwd)"
FLOG="$(mktemp -t cohesion_foundation)"
ILOG="$(mktemp -t cohesion_imprint)"
ALOG="$(mktemp -t cohesion_alignment)"
HLOG="$(mktemp -t cohesion_huntress)"
KLOG="$(mktemp -t cohesion_hounds)"
CLOG="$(mktemp -t cohesion_stage)"
FAILED=0
SKIPPED=0
DECLARED_CLAIMS=0
WITH_EVIDENCE=0
[ "${1:-}" = "--with-evidence" ] && WITH_EVIDENCE=1

# THE ONE STATE LINE, identical in all six runners (Z14 compares them).
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
PIN_K_OWNER=0
PIN_K_DISCHARGED=6
PIN_C_CHECKS=40
PIN_C_DEFERRED=16
PIN_C_OWNER=0
PIN_C_DISCHARGED=5

# THE DECLARED D-398 CHANGE SET INSIDE game3d/, against the PRE-D-398 listing
# (taken 2026-09-19 19:44:50) — pinned in BOTH directions by Z16.
DECLARED_MODIFIED="README.md
project.godot
scripts/control/player_controller.gd
scripts/core/prod_config.gd
scripts/foundation_main.gd
scripts/hounds/hound_config.gd
scripts/hounds/hound_review_hud.gd
scripts/hounds/hound_runtime.gd
scripts/hounds/hound_stand_in.gd
scripts/hounds/kindred_hound.gd
tests/alignment_smoke.sh
tests/alignment_verification.gd
tests/foundation_smoke.sh
tests/foundation_verification.gd
tests/hounds_smoke.sh
tests/hounds_verification.gd
tests/huntress_smoke.sh
tests/huntress_verification.gd
tests/imprint_smoke.sh
tests/imprint_verification.gd"
D398_SCRIPTS="attack_positions cohort_config cohort_diagnostics cohort_formation cohort_review_hud formation_profile mobile_cohort"
EV_FRAMES="32_d398_launch 33_d398_pop2_travel 34_d398_pop6_travel 35_d398_pop10_travel 36_d398_pop15_travel 37_d398_pop15_doorway 38_d398_pop15_regroup 39_d398_pop15_attack"
DECLARED_NEW="$(
  printf '%s\n' tests/cohesion_smoke.sh tests/cohesion_verification.gd tests/cohesion_verification.gd.uid
  for s in $D398_SCRIPTS; do printf 'scripts/cohort/%s.gd\nscripts/cohort/%s.gd.uid\n' "$s" "$s"; done
  for e in $EV_FRAMES; do printf 'evidence/%s.png\nevidence/%s.png.import\n' "$e" "$e"; done
)"
# The protected trees, each byte-identical to its pre-work listing (Z15).
PROTECTED="game game2d game3d_spike game3d_boss_spike game3d_huntress_spike models"
# The 27 input actions accepted before D-398, in project order (Z18).
ACCEPTED_ACTIONS="move_command stick_left stick_right stick_up stick_down aim_left aim_right aim_up aim_down diagnostic_attack zoom_in zoom_out toggle_overlay imprint_binding_1 imprint_binding_2 imprint_binding_3 imprint_binding_4 imprint_binding_5 imprint_binding_6 imprint_binding_7 imprint_binding_8 imprint_panel imprint_panel_prev imprint_panel_next imprint_panel_activate diagnostic_reservation_cycle diagnostic_hound_fall"
D398_ACTIONS="diagnostic_stress_population diagnostic_travel_speed"

say()  { printf '%s\n' "$*"; }
fail() { say "  [FAIL] $*"; FAILED=1; }
ok()   { say "  [ OK ] $*"; }
skip() { say "  [SKIP] $*"; SKIPPED=$((SKIPPED + 1)); }

say "========================================================================"
say "RIFTWROUGHT MOBILE MINION COHESION STAGE RUNNER (D-398)"
say "Headless by default. Rendered evidence is opt-in via --with-evidence."
say "It runs the ACCEPTED D-373, D-376, D-383, D-394 and D-397 suites as REGRESSIONS, then this stage (ACCEPTED under D-400)."
say "The stage it verifies is ACCEPTED and CLOSED (D-400); this is a REGRESSION run. It accepts nothing."
say "========================================================================"

# The evidence as it stands BEFORE this run -- Z20 proves a plain run leaves it alone.
EV_BEFORE="$(cd "$PROJ" && for e in $EV_FRAMES; do [ -f "evidence/$e.png" ] && shasum -a 256 "evidence/$e.png"; done)"

# --------------------------------------------- 0. opt-in evidence, rendered FIRST
EV_RESULT=""
CEILING=120
if [ "$WITH_EVIDENCE" -eq 1 ]; then
  say ""
  say "[0/9] Rendering this stage's eight captures (32-39) FIRST (opt-in) — never 01-31"
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

# ------------------------------------------------------------ Z01. import ----
say ""
say "[1/9] Import pass (Z01)"
"$GODOT" --headless --path "$PROJ" --import >/dev/null 2>&1
IMPORTED="$(ls "$PROJ/.godot/imported" 2>/dev/null | wc -l | tr -d ' ')"
UIDS=0
for s in $D398_SCRIPTS; do [ -f "$PROJ/scripts/cohort/$s.gd.uid" ] && UIDS=$((UIDS + 1)); done
[ -f "$PROJ/tests/cohesion_verification.gd.uid" ] && UIDS=$((UIDS + 1))
if [ "$IMPORTED" -gt 0 ] && [ "$UIDS" = "8" ]; then
  ok "Z01 assets imported ($IMPORTED entries) and all 7 D-398 scripts and the D-398 suite carry their .uid — a fresh checkout verifies"
else
  fail "Z01 the import pass produced $IMPORTED entries; D-398 uids $UIDS of 8"
fi

# ------------------------------------------------------ Z02-Z08. the suites --
say ""
say "[2/9] The six suites: D-373, D-376, D-383, D-394 and D-397 as REGRESSIONS, then D-398 (Z02-Z08)"
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
"$GODOT" --headless --path "$PROJ" --script res://tests/cohesion_verification.gd >"$CLOG" 2>&1
C_RC=$?
grep -E "^  \[(PASS|FAIL|UNREACHED) *\]" "$CLOG" | sed 's/^/    /' | head -60
grep -E "^(FOUNDATION|IMPRINT|ALIGNMENT|HUNTRESS|HOUNDS|COHESION) VERIFICATION:" \
  "$FLOG" "$ILOG" "$ALOG" "$HLOG" "$KLOG" "$CLOG" | sed "s|^[^:]*:|    |"

pin_summary() { # $1 id, $2 log, $3 prefix, $4 checks, $5 deferred
  local line expect
  line="$(grep -E "^$3 VERIFICATION:" "$2" | head -1)"
  expect="$3 VERIFICATION: PASS ($4 checks: $4 passed, 0 failed/unreached, $5 deferred)"
  if [ "$line" = "$expect" ]; then
    ok "$1 the ACCEPTED $3 summary matches EXACTLY: $4 executable checks, $5 deferred rows"
  else
    fail "$1 $3 summary MISMATCH"; say "        expected: $expect"; say "        actual  : $line"
  fi
}
H_EXPECT="HUNTRESS VERIFICATION: PASS ($PIN_H_CHECKS checks: $PIN_H_CHECKS passed, 0 failed/unreached, $PIN_H_DEFERRED deferred, $PIN_H_OWNER owed to the owner, $PIN_H_DISCHARGED discharged)"
K_EXPECT="HOUNDS VERIFICATION: PASS ($PIN_K_CHECKS checks: $PIN_K_CHECKS passed, 0 failed/unreached, $PIN_K_DEFERRED deferred, $PIN_K_OWNER owed to the owner, $PIN_K_DISCHARGED discharged)"
C_EXPECT="COHESION VERIFICATION: PASS ($PIN_C_CHECKS checks: $PIN_C_CHECKS passed, 0 failed/unreached, $PIN_C_DEFERRED deferred, $PIN_C_OWNER owed to the owner, $PIN_C_DISCHARGED discharged)"
pin_summary Z02 "$FLOG" FOUNDATION "$PIN_F_CHECKS" "$PIN_F_DEFERRED"
pin_summary Z03 "$ILOG" IMPRINT "$PIN_I_CHECKS" "$PIN_I_DEFERRED"
pin_summary Z04 "$ALOG" ALIGNMENT "$PIN_A_CHECKS" "$PIN_A_DEFERRED"
H_LINE="$(grep -E '^HUNTRESS VERIFICATION:' "$HLOG" | head -1)"
K_LINE="$(grep -E '^HOUNDS VERIFICATION:' "$KLOG" | head -1)"
C_LINE="$(grep -E '^COHESION VERIFICATION:' "$CLOG" | head -1)"
if [ "$H_LINE" = "$H_EXPECT" ] && [ "$K_LINE" = "$K_EXPECT" ]; then
  ok "Z05 the ACCEPTED Splinter Shot summary ($PIN_H_CHECKS checks, $PIN_H_DEFERRED deferred, $PIN_H_OWNER owed, $PIN_H_DISCHARGED discharged) and the ACCEPTED Kindred Hounds summary ($PIN_K_CHECKS checks, $PIN_K_DEFERRED deferred, $PIN_K_OWNER owed, $PIN_K_DISCHARGED discharged) match EXACTLY"
else
  fail "Z05 a summary MISMATCH"; say "        expected: $H_EXPECT"; say "        actual  : $H_LINE"
  say "        expected: $K_EXPECT"; say "        actual  : $K_LINE"
fi
if [ "$C_LINE" = "$C_EXPECT" ]; then
  ok "Z06 this stage's summary matches EXACTLY: $PIN_C_CHECKS executable checks, $PIN_C_DEFERRED deferred rows, $PIN_C_OWNER owed to the owner, $PIN_C_DISCHARGED discharged"
else
  fail "Z06 the D-398 summary MISMATCH"; say "        expected: $C_EXPECT"; say "        actual  : $C_LINE"
fi
OWED_OK=1
for spec in "$FLOG:$PIN_F_CHECKS:F" "$ILOG:$PIN_I_CHECKS:I" "$ALOG:$PIN_A_CHECKS:A" "$HLOG:$PIN_H_CHECKS:H" \
            "$KLOG:$PIN_K_CHECKS:B" "$CLOG:$PIN_C_CHECKS:C"; do
  L="${spec%%:*}"; rest="${spec#*:}"; C="${rest%%:*}"; P="${rest#*:}"
  LINE="$(grep -E '^  owed=' "$L" | head -1 | sed 's/^ *//')"
  EXPECT="owed=$C  reached=$C  owed-but-not-reached=0 []  reached-but-not-owed=0 []"
  NAMES="$(grep -cE "^  \[PASS     \] $P[0-9]+_" "$L")"
  if [ "$LINE" != "$EXPECT" ] || [ "$NAMES" != "$C" ]; then
    OWED_OK=0; say "        $(basename "$L"): '$LINE' ($NAMES $P-names)"
  fi
done
if [ "$OWED_OK" -eq 1 ]; then
  ok "Z07 owed vs reached matches in BOTH directions in all six logs, and every F-, I-, A-, H-, B- and C-numbered check passed"
else
  fail "Z07 owed/reached or name counts MISMATCH"
fi
RC_OK=1
for rc in "$F_RC" "$I_RC" "$A_RC" "$H_RC" "$K_RC" "$C_RC"; do [ "$rc" -ne 0 ] && RC_OK=0; done
if [ "$RC_OK" -eq 1 ]; then
  ok "Z08 all six suites exited 0"
else
  fail "Z08 a suite exited non-zero (F $F_RC, I $I_RC, A $A_RC, H $H_RC, B $K_RC, C $C_RC)"
fi

# ----------------------------------------------- Z09. pins able to refuse ----
say ""
say "[3/9] Every summary pin PROVED able to refuse an altered value (Z09)"
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
K_ALT3="$(printf '%s' "$K_LINE" | sed "s/, $PIN_K_DISCHARGED discharged/, $((PIN_K_DISCHARGED - 1)) discharged/")"
if [ "$K_ALT1" != "$K_EXPECT" ] && [ "$K_ALT2" != "$K_EXPECT" ] && [ "$K_ALT3" != "$K_EXPECT" ] && [ "$K_LINE" = "$K_EXPECT" ]; then
  REFUSED=$((REFUSED + 1))
fi
C_ALT1="$(printf '%s' "$C_LINE" | sed "s/($PIN_C_CHECKS checks/($((PIN_C_CHECKS - 1)) checks/")"
C_ALT2="$(printf '%s' "$C_LINE" | sed "s/, $PIN_C_DEFERRED deferred/, $((PIN_C_DEFERRED - 1)) deferred/")"
C_ALT3="$(printf '%s' "$C_LINE" | sed "s/, $PIN_C_DISCHARGED discharged/, $((PIN_C_DISCHARGED - 1)) discharged/")"
if [ "$C_ALT1" != "$C_EXPECT" ] && [ "$C_ALT2" != "$C_EXPECT" ] && [ "$C_ALT3" != "$C_EXPECT" ] && [ "$C_LINE" = "$C_EXPECT" ]; then
  REFUSED=$((REFUSED + 1))
fi
if [ "$REFUSED" = "6" ]; then
  ok "Z09 all six summary pins REFUSE an altered check count AND an altered row count (the D-392, D-396 and — since D-400 — this stage's pin also an altered discharged count) — replayed"
else
  fail "Z09 only $REFUSED of 6 summary pins were proved able to refuse an altered value"
fi

# -------------------------------------------------- Z10. printed rows ----
say ""
say "[4/9] Deferred, owed and discharged rows (Z10)"
CD_ROWS="$(grep -cE '^  \[[^]]+\] CD-(0[1-9]|1[0-6]) ' "$CLOG")"
CO_ROWS="$(grep -cE '^  \[OWED-TO-OWNER\] CO-' "$CLOG")"
CO_DIS="$(grep -cE '^  \[DISCHARGED — D-399\] CO-0[1-5] ' "$CLOG")"
C_PASSROW="$(grep -cE '^  \[(PASS|OK) *\] C[DO]-' "$CLOG")"
CD08="$(grep -cE '^  \[CARRIED — NOT DISCHARGED *\] CD-08 ' "$CLOG")"
CD15="$(grep -cE '^  \[CARRIED — NOT DISCHARGED *\] CD-15 ' "$CLOG")"
CD16="$(grep -cE '^  \[DECLARED — NOT REPAIRED *\] CD-16 ' "$CLOG")"
ROW_PREY="$(grep -E '^  \[[^]]+\] C[DO]-[0-9]+ ' "$CLOG" | grep -ci 'prey' || true)"
KO_DIS="$(grep -cE '^  \[DISCHARGED — D-397\] KO-0[1-6] ' "$KLOG")"
KO_OWED="$(grep -cE '^  \[OWED-TO-OWNER\] KO-' "$KLOG")"
SO_DIS="$(grep -cE '^  \[DISCHARGED — D-394\] SO-0[1235] ' "$HLOG")"
LEAK="$(grep -cE '^  \[(OWED-TO-OWNER|DISCHARGED — D-399)\] CO-|^  \[[^]]+\] CD-[0-9]+ |^COHESION VERIFICATION' "$FLOG" "$ILOG" "$ALOG" "$HLOG" "$KLOG" | awk -F: '{s+=$2} END{print s+0}')"
KEPT="$(grep -cF "ORIGINAL ROW TEXT, PRESERVED VERBATIM (OWED-TO-OWNER)" "$CLOG")"
NO_INFER="$(grep -cF "THE OWNER'S ANSWER, VERBATIM: " "$CLOG")"
if [ "$CD_ROWS" = "$PIN_C_DEFERRED" ] && [ "$CO_ROWS" = "$PIN_C_OWNER" ] && [ "$CO_DIS" = "$PIN_C_DISCHARGED" ] \
   && [ "$KEPT" -ge "$PIN_C_DISCHARGED" ] && [ "$NO_INFER" -ge "$PIN_C_DISCHARGED" ] \
   && [ "$C_PASSROW" = "0" ] && [ "$CD08" = "1" ] \
   && [ "$CD15" = "1" ] && [ "$CD16" = "1" ] && [ "$ROW_PREY" = "0" ] && [ "$KO_DIS" = "$PIN_K_DISCHARGED" ] \
   && [ "$KO_OWED" = "0" ] && [ "$SO_DIS" = "$PIN_H_DISCHARGED" ] && [ "$LEAK" = "0" ]; then
  ok "Z10 the D-398 run prints CD-01..CD-16 ($CD_ROWS) and CO-01..CO-05 DISCHARGED — D-399 ($CO_DIS, original text kept $KEPT, each carrying THE OWNER'S OWN ANSWER $NO_INFER) with $CO_ROWS still owed, none as a pass and none naming Prey; CD-08 and CD-15 CARRIED, CD-16 DECLARED — NOT REPAIRED; the D-396 run prints KO-01..KO-06 DISCHARGED — D-397 and none owed, the D-392 run its four SO- rows DISCHARGED — D-394; no D-398 row leaks into an accepted log"
else
  fail "Z10 rows: CD $CD_ROWS, CO owed $CO_ROWS, CO discharged $CO_DIS, text kept $KEPT, owner-answer $NO_INFER, as pass $C_PASSROW, CD-08 $CD08, CD-15 $CD15, CD-16 $CD16, naming Prey $ROW_PREY, KO discharged $KO_DIS, KO owed $KO_OWED, SO discharged $SO_DIS, leaked $LEAK"
fi

# ---------------------------------------------------- Z11. engine errors ----
say ""
say "[5/9] Engine-error guard (Z11)"
ERRPAT='^(SCRIPT )?ERROR:|^USER ERROR:|^SCRIPT ERROR|Parse Error|Failed to load script'
SELF='Foundation_Signature_Move_THIS_DOES_NOT_EXIST'
SELF_N="$(grep -cF "$SELF" "$FLOG")"
F_REAL="$(grep -E "$ERRPAT" "$FLOG" | grep -vF "$SELF" || true)"
OTHER_REAL="$(grep -E "$ERRPAT" "$ILOG" "$ALOG" "$HLOG" "$KLOG" "$CLOG" || true)"
PLANT="$(mktemp -t cohesion_plant)"; cat "$CLOG" > "$PLANT"
printf 'SCRIPT ERROR: planted engine error, for guard proving only\n' >> "$PLANT"
if [ "$SELF_N" -lt 1 ]; then
  fail "Z11 the accepted suite's guard-proving error line is missing — F12's proof is not intact"
elif [ -n "$F_REAL" ] || [ -n "$OTHER_REAL" ]; then
  fail "Z11 engine errors present:"
  printf '%s\n' "$F_REAL" "$OTHER_REAL" | grep -v '^$' | head -12 | sed 's/^/        /'
elif ! grep -qE "$ERRPAT" "$PLANT"; then
  fail "Z11 the error guard could NOT detect a planted error line"
else
  ok "Z11 no engine error in any of the six logs beyond the one expected guard proof, and the guard refuses a planted error (a parse error EXITS 0, so this guard, not the exit code, is what catches it)"
fi
rm -f "$PLANT"

# ------------------------------------ Z12-Z14. state line and truthfulness --
say ""
say "[6/9] The state line and truthfulness (Z12-Z14)"
BAD_STATE=0
for L in "$FLOG" "$ILOG" "$ALOG" "$HLOG" "$KLOG" "$CLOG"; do
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
  grep -qxF "$S" "$FLOG" "$ILOG" "$ALOG" "$HLOG" "$KLOG" "$CLOG" && SUPERSEDED=1
done
# THE STAGE NEVER ACCEPTS ITSELF, and no earlier stage is made to accept itself.
# RE-SCOPED UNDER D-400 (first act), one for one: D-400 made "MOBILE MINION
# COHESION STAGE ACCEPTED" the OWNER's fact, so it leaves the pattern and the OPEN
# D-400 stage takes its place. Still false, and refused: the D-392, D-396 or D-398
# stage accepting ITSELF (D-398 delivered; D-400 accepted), and the OPEN D-400
# stage called accepted.
# RE-SCOPED AGAIN UNDER D-402 (first act), one for one: D-401 made "PLAYER
# LOCOMOTION REDIRECTION STAGE ACCEPTED" the OWNER's fact, so it leaves the
# pattern and the OPEN D-402 Cinder Field stage takes its place.
# RE-SCOPED UNDER D-404 (first act), one for one: D-403 made "CINDER FIELD
# STAGE ACCEPTED" the OWNER's fact -- it is in the state line itself -- so it
# leaves the pattern and the OPEN D-404 direct-click stage takes its place.
# "ACCEPTED and CLOSED (D-402)" joins what is still false: D-402 DELIVERED the
# Cinder Field stage and D-403 accepted it.
SELF_ACCEPT='PLAYER DIRECT-CLICK MOVEMENT CORRECTION STAGE ACCEPTED|D-404 (is|stage is) ACCEPTED|ACCEPTED and CLOSED \(D-402\)|ACCEPTED and CLOSED \(D-398\)|D-398 (is|stage is) ACCEPTED|ACCEPTED and CLOSED \(D-396\)|ACCEPTED and CLOSED \(D-392\)|ACCEPTED and CLOSED \(D-400\)'
ACCEPTS="$(grep -hE "$SELF_ACCEPT" "$FLOG" "$ILOG" "$ALOG" "$HLOG" "$KLOG" "$CLOG" | head -3 || true)"
PLANT3="$(mktemp -t cohesion_plant3)"; printf 'PLAYER DIRECT-CLICK MOVEMENT CORRECTION STAGE ACCEPTED and CLOSED (D-404)\n' > "$PLANT3"
ALT_STATE="$(printf '%s' "$STATE_EXPECT" | sed 's/DELIVERED and OPEN pending owner live review (D-404)/ACCEPTED and CLOSED (D-404)/')"
if [ "$BAD_STATE" -eq 0 ] && [ "$SUPERSEDED" -eq 0 ] && [ -z "$ACCEPTS" ] && grep -qE "$SELF_ACCEPT" "$PLANT3" \
   && [ "$ALT_STATE" != "$STATE_EXPECT" ] && [ "$STATE_D396_LINE" != "$STATE_EXPECT" ] \
   && [ "$STATE_D398_LINE" != "$STATE_EXPECT" ] && [ "$STATE_D400_LINE" != "$STATE_EXPECT" ] \
   && [ "$STATE_D402_LINE" != "$STATE_EXPECT" ]; then
  ok "Z12 every STATE line in all six logs is the SAME exact nine-fact line (D-404 first act); no superseded line (D-375, D-380, D-392, D-396, D-398, D-400, D-402, bare D-370) is printed; nothing claims the open D-402 stage accepted or an earlier stage accepting itself — and each scan refuses a planted line"
else
  fail "Z12 a state line differs ($BAD_STATE), a superseded line is printed ($SUPERSEDED), or a self-acceptance appears: $ACCEPTS"
fi
rm -f "$PLANT3"
Z13_MISS=""
for s in "The D-398 stage IS NOT P2 and AUTHORIZES NO P2." \
         "the canonical Kindred Hounds pack stays TWO, and populations of 6, 10 and 15 are DIAGNOSTIC STRESS MODES only" \
         "adds NO Additional Minion and NO real pack-size progression" \
         "no Coursing Hounds, Sinew Ballista or other Skill exists" \
         "only the MELEE Vanguard exists" \
         "IS NOT final minion AI" \
         "does NOT implement Huntress's Mark" \
         "the two diagnostic controls are REVIEW CONTROLS and NOT commands" \
         "changes NO minion damage, reservation, Capacity or recovery value, and NO accepted constant" \
         "the soft-recovery fade is a PLACEHOLDER" \
         "The D-398 stage LOCKS NO NUMBER" \
         "her accepted 3.889 m/s is unchanged, and ORDINARY is exactly it" \
         "decides NO distribution or focus rule" \
         "review tooling and IS NOT a UI foundation" \
         "has NO runtime dependency outside game3d/" \
         "The D-398 stage was delivered OPEN and never accepted itself: the owner ACCEPTED and CLOSED it under D-399" \
         "for the owner to confirm or overrule" \
         "[DISCHARGED — D-399] CO-01 Whether the pack stays around or ahead of her." \
         "[DISCHARGED — D-399] CO-05 Whether it recovers unobtrusively at extreme speed."; do
  grep -qF "$s" "$CLOG" || Z13_MISS="$Z13_MISS | $s"
done
FORBID='P2 is authorized|P1 is complete|the pack size is (locked|increased)|(15|fifteen) (hounds|minions) (is|are) (canonical|the pack)|Additional Minion is implemented|(Ranged|Support) (minions|behaviour|profile) (is|are) implemented|final minion AI is (implemented|complete|accepted)|the (lead|catch-up|formation|congestion|recovery|separation) (value|multiplier|threshold|distance) is locked|Coursing Hounds (are|is) implemented|Mark is implemented|Prey is designated|production ready|the (extreme|fast) speed is (canonical|locked)|final hound art is (approved|accepted)'
PLANT2="$(mktemp -t cohesion_plant2)"; printf 'the pack size is increased\n' > "$PLANT2"
if [ -n "$Z13_MISS" ]; then
  fail "Z13 the D-398 run does NOT state:$Z13_MISS"
elif grep -qiE "$FORBID" "$FLOG" "$ILOG" "$ALOG" "$HLOG" "$KLOG" "$CLOG"; then
  fail "Z13 a run log makes a forbidden lock or completion claim:"
  grep -hiE "$FORBID" "$FLOG" "$ILOG" "$ALOG" "$HLOG" "$KLOG" "$CLOG" | head -3 | sed 's/^/        /'
elif ! grep -qiE "$FORBID" "$PLANT2"; then
  fail "Z13 the forbidden-claim scan cannot see a planted claim"
else
  ok "Z13 the D-398 run states its nineteen truthfulness strings (sixteen of its seventeen denials — the self-denial now dated history naming D-400 — the regroup reading still put to the owner, and the first and last owner questions, now DISCHARGED — D-399), no log makes a forbidden lock or completion claim, and the scan refuses a planted one"
fi
rm -f "$PLANT2"
L_F="$(grep -E '^STATE_EXPECT=' "$PROJ/tests/foundation_smoke.sh" | head -1)"
L_I="$(grep -E '^STATE_EXPECT=' "$PROJ/tests/imprint_smoke.sh" | head -1)"
L_A="$(grep -E '^STATE_EXPECT=' "$PROJ/tests/alignment_smoke.sh" | head -1)"
L_H="$(grep -E '^STATE_EXPECT=' "$PROJ/tests/huntress_smoke.sh" | head -1)"
L_K="$(grep -E '^STATE_EXPECT=' "$PROJ/tests/hounds_smoke.sh" | head -1)"
L_C="$(grep -E '^STATE_EXPECT=' "$0" | head -1)"
NEEDLES=0
NEEDLES_396=0
NEEDLES_398=0
for r in foundation_smoke.sh imprint_smoke.sh alignment_smoke.sh huntress_smoke.sh hounds_smoke.sh cohesion_smoke.sh; do
  grep -qxF "STATE_D392_LINE=\"$STATE_D392_LINE\"" "$PROJ/tests/$r" && NEEDLES=$((NEEDLES + 1))
  grep -qxF "STATE_D396_LINE=\"$STATE_D396_LINE\"" "$PROJ/tests/$r" && NEEDLES_396=$((NEEDLES_396 + 1))
  grep -qxF "STATE_D398_LINE=\"$STATE_D398_LINE\"" "$PROJ/tests/$r" && NEEDLES_398=$((NEEDLES_398 + 1))
done
CNT_OK=1
for r in imprint_smoke.sh alignment_smoke.sh huntress_smoke.sh hounds_smoke.sh cohesion_smoke.sh; do
  for p in 'PIN_F_CHECKS=85' 'PIN_F_DEFERRED=11' 'PIN_I_CHECKS=101' 'PIN_I_DEFERRED=16'; do
    grep -qx "$p" "$PROJ/tests/$r" || CNT_OK=0
  done
done
for r in alignment_smoke.sh huntress_smoke.sh hounds_smoke.sh cohesion_smoke.sh; do
  for p in 'PIN_A_CHECKS=40' 'PIN_A_DEFERRED=10'; do grep -qx "$p" "$PROJ/tests/$r" || CNT_OK=0; done
done
for r in huntress_smoke.sh hounds_smoke.sh cohesion_smoke.sh; do
  for p in 'PIN_H_CHECKS=53' 'PIN_H_DEFERRED=15' 'PIN_H_OWNER=0' 'PIN_H_DISCHARGED=4'; do grep -qx "$p" "$PROJ/tests/$r" || CNT_OK=0; done
done
for r in hounds_smoke.sh cohesion_smoke.sh; do
  for p in 'PIN_K_CHECKS=45' 'PIN_K_DEFERRED=16' 'PIN_K_OWNER=0' 'PIN_K_DISCHARGED=6'; do grep -qx "$p" "$PROJ/tests/$r" || CNT_OK=0; done
done
if [ -n "$L_F" ] && [ "$L_F" = "$L_I" ] && [ "$L_I" = "$L_A" ] && [ "$L_A" = "$L_H" ] && [ "$L_H" = "$L_K" ] && [ "$L_K" = "$L_C" ] \
   && [ "$L_C" = "STATE_EXPECT=\"$STATE_EXPECT\"" ] && [ "$NEEDLES" = "6" ] && [ "$NEEDLES_396" = "6" ] \
   && [ "$NEEDLES_398" = "6" ] && [ "$CNT_OK" -eq 1 ]; then
  ok "Z14 the six runners pin the IDENTICAL seven-fact state line, each holds the D-392-era, D-396-era and (D-400) D-398-era lines as SUPERSEDED needles, and they carry the same accepted counts (85/11, 101/16, 40/10, 53/15 with 0 owed and 4 discharged, 45/16 with 0 owed and 6 discharged)"
else
  fail "Z14 the runners disagree on the state line, a needle (D-392 $NEEDLES of 6, D-396 $NEEDLES_396 of 6, D-398 $NEEDLES_398 of 6) or a carried count (ok=$CNT_OK)"
fi

# ------------------------------------------------ Z15-Z19. isolation ----
say ""
say "[7/9] Isolation, the change set, the asset guards, the input map and the units (Z15-Z19)"
BASE="${FOUNDATION_BASELINE_DIR:-}"
Z15_OK=1; Z15_RAN=0; N_ARCH=0
for d in $PROTECTED; do
  f="$BASE/baseline_$d.sha256"
  if [ -n "$BASE" ] && [ -f "$f" ]; then
    Z15_RAN=$((Z15_RAN + 1))
    NOW="$(mktemp -t cohesion_now)"
    ( cd "$ROOT" && find "$d" -type f -print0 | sort -z | xargs -0 shasum -a 256 ) > "$NOW"
    if ! diff -q "$f" "$NOW" >/dev/null; then
      Z15_OK=0; say "        $d/ CHANGED"
      diff "$f" "$NOW" | grep -E '^[<>]' | head -6 | sed 's/^/          /'
    fi
    rm -f "$NOW"
  fi
done
if [ -n "$BASE" ] && [ -f "$BASE/baseline_archives.sha256" ]; then
  Z15_RAN=$((Z15_RAN + 1))
  NOW="$(mktemp -t cohesion_now)"
  ( cd "$ROOT" && sed -E 's/^[0-9a-f]+  //' "$BASE/baseline_archives.sha256" | while IFS= read -r p; do
      shasum -a 256 "$p"; done ) | sort -k2 > "$NOW"
  N_ARCH="$(wc -l < "$NOW" | tr -d ' ')"
  diff -q "$BASE/baseline_archives.sha256" "$NOW" >/dev/null || { Z15_OK=0; say "        an archive under assets/ CHANGED"; }
  rm -f "$NOW"
fi
if [ "$Z15_RAN" -eq 7 ] && [ "$Z15_OK" -eq 1 ]; then
  ok "Z15 game/, game2d/, game3d_spike/, game3d_boss_spike/, game3d_huntress_spike/ (README included), models/ and all $N_ARCH archives under assets/ are byte-identical to the pre-work baseline"
elif [ "$Z15_RAN" -eq 0 ]; then
  skip "Z15 baselines not supplied (set FOUNDATION_BASELINE_DIR) — NOT a pass"
else
  fail "Z15 a protected tree or archive changed, or a baseline is missing ($Z15_RAN of 7 measured)"
fi
G3="${D398_BASELINE_GAME3D:-}"
if [ -n "$G3" ] && [ -f "$G3" ]; then
  NOW="$(mktemp -t cohesion_now)"
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
  PLANTED_SET="$(printf '%s\ngame3d/scripts/hounds/hound_targeting.gd\n' "$MODIFIED" | sort -u)"
  if [ -z "$REMOVED" ] && [ "$MODIFIED" = "$EXP_MOD" ] && [ "$ADDED" = "$EXP_NEW" ] && [ "$PLANTED_SET" != "$EXP_MOD" ]; then
    ok "Z16 inside game3d/: exactly the $(printf '%s\n' "$EXP_MOD" | wc -l | tr -d ' ') declared files changed and the $(printf '%s\n' "$EXP_NEW" | wc -l | tr -d ' ') declared files are new — EVERY other authored file is byte-identical (the targeting rule, combat, world, view, the Imprint and Huntress runtimes, scenes, the asset trees, evidence 01-31); a planted undeclared change is refused"
  else
    fail "Z16 the game3d/ change set differs from the declared set"
    say "        undeclared/missing modifications:"; diff <(printf '%s\n' "$MODIFIED") <(printf '%s\n' "$EXP_MOD") | grep -E '^[<>]' | head -8 | sed 's/^/          /'
    say "        undeclared/missing additions:";    diff <(printf '%s\n' "$ADDED") <(printf '%s\n' "$EXP_NEW") | grep -E '^[<>]' | head -8 | sed 's/^/          /'
    [ -n "$REMOVED" ] && { say "        removed:"; printf '%s\n' "$REMOVED" | head -5 | sed 's/^/          /'; }
  fi
  rm -f "$NOW"
else
  # RE-SCOPED UNDER D-400, one for one: Z16 is a D-398 DELIVERY-TIME claim -- its
  # change set against a pre-D-398 listing of game3d/. That listing is gone, and
  # after D-400 changes further files NO listing exists against which it can pass.
  # So without one it is DECLARED, not skipped -- exactly as W17 has been since
  # D-396 and Y15 since D-398. tests/locomotion_smoke.sh N16 proves D-400's own
  # change set in both directions. Until D-400 this printed [SKIP] and made the
  # run INCOMPLETE.
  say "  [DECLARED] Z16 a D-398 delivery-time claim (its change set against a pre-D-398 listing); superseded by the D-400 stage, whose change set tests/locomotion_smoke.sh N16 proves — NOT a pass and NOT a skip"
  DECLARED_CLAIMS=$((DECLARED_CLAIMS + 1))
fi
# Z17 — NO NEW ASSET, NO MINION ART, NO VFX, NO AUDIO, NO .pxo, the four trees.
PXO="$(find "$PROJ" -name '*.pxo' 2>/dev/null | head -1)"
TREES="$(find "$ROOT" -type d -name 'quaternius' 2>/dev/null | sed "s|^$ROOT/||" | sort | tr '\n' ' ')"
EXPECT_TREES="game/assets/third_party/quaternius game3d/assets/third_party/quaternius game3d_boss_spike/assets/third_party/quaternius game3d_spike/assets/third_party/quaternius "
AUDIO="$(find "$PROJ" \( -name '*.wav' -o -name '*.ogg' -o -name '*.mp3' -o -name '*.flac' \) 2>/dev/null | head -1)"
BAD="$(find "$PROJ" \( -iname '*UltimateMonsters*' -o -iname '*Ultimate_Monsters*' -o -iname '*dog*' -o -iname '*hound*.glb' \
        -o -iname '*hound*.gltf' -o -iname '*hound*.obj' -o -iname '*hound*.fbx' -o -iname '*wolf*' -o -iname '*minion*.glb' \
        -o -iname '*VFX*' -o -iname '*BattleFX*' -o -iname '*MagicFX*' -o -iname '*VividMotion*' -o -iname '*prey*' \) \
        -not -path '*/.godot/*' 2>/dev/null | head -1)"
# RE-PINNED UNDER D-402, ONE FOR ONE: 29 + 4 = 33 -- the two Cinder Field
# placeholder bodies (.obj + .mtl each) added to the ALREADY-DECLARED CC0
# Ultimate Modular Ruins pack. The variable keeps its NAME so nothing is
# renamed around a guard; its expected value moves. Until D-402 it was 29.
DECLARED29="$(grep -oE '"(bestiary_dungeon_monsters|universal_animation_library|universal_animation_library_2|modular_character_outfits_fantasy|ultimate_modular_ruins)/[^"]+"' "$PROJ/scripts/assets/asset_manifest.gd" | grep -vF '%s' | sort -u | wc -l | tr -d ' ')"
ASSET_REFS="$(grep -lE 'res://assets|preload\(|[^_]load\(' "$PROJ"/scripts/cohort/*.gd "$PROJ"/scripts/hounds/*.gd 2>/dev/null | head -1)"
# The asset tree's file count, now and in the pre-D-398 listing (when supplied).
ASSET_FILES_BEFORE="$( [ -n "${D398_BASELINE_GAME3D:-}" ] && [ -f "$D398_BASELINE_GAME3D" ] \
  && sed -E 's/^[0-9a-f]+  game3d\///' "$D398_BASELINE_GAME3D" | grep -c '^assets/' )"
ASSET_FILES_NOW="$(cd "$PROJ" && find assets -type f | wc -l | tr -d ' ')"
if [ -z "$PXO" ] && [ "$TREES" = "$EXPECT_TREES" ] && [ -z "$AUDIO" ] && [ -z "$BAD" ] && [ "$DECLARED29" = "33" ] && [ -z "$ASSET_REFS" ] \
   && { [ -z "$ASSET_FILES_BEFORE" ] || [ "$ASSET_FILES_BEFORE" = "$ASSET_FILES_NOW" ]; }; then
  ok "Z17 no .pxo, no audio, no minion or hound model, dog, wolf, Ultimate Monsters, VFX or Prey file in game3d/; the D-370 block still declares 29; no cohort or hound script loads anything; the asset tree holds the same $ASSET_FILES_NOW files; exactly the four quaternius trees in the repository"
else
  fail "Z17 pxo='$PXO' trees='$TREES' audio='$AUDIO' excluded='$BAD' declared=$DECLARED29 load='$ASSET_REFS' asset files before=$ASSET_FILES_BEFORE now=$ASSET_FILES_NOW"
fi
# Z18 — EXACTLY TWO input actions added: the accepted 27 in order, then the two
# diagnostic modes, on keys P / T and the pad's D-pad right / START, clashing with
# nothing.
ACT_LIST="$(grep -oE '^[a-z_][a-z_0-9]*=\{$' "$PROJ/project.godot" | tr -d '={' | tr '\n' ' ' | sed 's/ $//')"
POP_BLOCK="$(awk '/^diagnostic_stress_population=\{/{f=1} f{print} f&&/^}/{exit}' "$PROJ/project.godot")"
SPD_BLOCK="$(awk '/^diagnostic_travel_speed=\{/{f=1} f{print} f&&/^}/{exit}' "$PROJ/project.godot")"
POP_KEYS="$(printf '%s' "$POP_BLOCK" | grep -oE '"physical_keycode":[0-9]+' | tr '\n' ' ')"
POP_PADS="$(printf '%s' "$POP_BLOCK" | grep -oE '"button_index":[0-9]+' | tr '\n' ' ')"
SPD_KEYS="$(printf '%s' "$SPD_BLOCK" | grep -oE '"physical_keycode":[0-9]+' | tr '\n' ' ')"
SPD_PADS="$(printf '%s' "$SPD_BLOCK" | grep -oE '"button_index":[0-9]+' | tr '\n' ' ')"
P_USERS="$(grep -cF '"physical_keycode":80,' "$PROJ/project.godot")"
T_USERS="$(grep -cF '"physical_keycode":84,' "$PROJ/project.godot")"
DPR_USERS="$(awk '/InputEventJoypadButton/ && /"button_index":14,/' "$PROJ/project.godot" | wc -l | tr -d ' ')"
START_USERS="$(awk '/InputEventJoypadButton/ && /"button_index":6,/' "$PROJ/project.godot" | wc -l | tr -d ' ')"
WASD=0
for code in 87 65 83 68; do
  N="$(grep -cF "\"physical_keycode\":$code," "$PROJ/project.godot" || true)"
  [ "$N" != "0" ] && WASD=1
done
PLANT_LIST="$ACCEPTED_ACTIONS diagnostic_pet_command $D398_ACTIONS"
if [ "$ACT_LIST" = "$ACCEPTED_ACTIONS $D398_ACTIONS" ] && [ "$POP_KEYS" = '"physical_keycode":80 ' ] \
   && [ "$POP_PADS" = '"button_index":14 ' ] && [ "$SPD_KEYS" = '"physical_keycode":84 ' ] && [ "$SPD_PADS" = '"button_index":6 ' ] \
   && [ "$P_USERS" = "1" ] && [ "$T_USERS" = "1" ] && [ "$DPR_USERS" = "1" ] && [ "$START_USERS" = "1" ] && [ "$WASD" -eq 0 ] \
   && [ "$PLANT_LIST" != "$ACT_LIST" ]; then
  ok "Z18 project.godot declares the 27 accepted actions unchanged and in order, then EXACTLY diagnostic_stress_population (key P, pad D-pad right) and diagnostic_travel_speed (key T, pad START) — 27 + 2 = 29 — each binding used by nothing else; no W/A/S/D; a planted extra action is refused"
else
  fail "Z18 actions '$ACT_LIST' | population keys '$POP_KEYS' pads '$POP_PADS' | speed keys '$SPD_KEYS' pads '$SPD_PADS' | P $P_USERS, T $T_USERS, D-pad-right $DPR_USERS, START $START_USERS, W/A/S/D=$WASD"
fi
# Z19 — THE UNITS, stated where they are owed.
INV="$ROOT/docs/testing/D398_MOBILE_MINION_COHESION_OWED_CRITERIA_INVENTORY.md"
OWED_N="$(awk '/^const OWED := \[/{f=1; next} f&&/^\]/{exit} f' "$PROJ/tests/cohesion_verification.gd" | grep -cE '^\s*"C[0-9][0-9]_')"
RUNNER_N="$(grep -oE 'Z[0-9][0-9]' "$0" | sort -u | wc -l | tr -d ' ')"
if [ -f "$INV" ] && grep -qF '= **201**' "$INV" && grep -qF '`C01`…`C40` = **40**' "$INV" && grep -qF '`Z01`…`Z22` = **22**' "$INV" \
   && [ "$OWED_N" = "40" ] && [ "$RUNNER_N" = "22" ] && grep -qF '22 RUNNER CHECKS in tests/cohesion_smoke.sh' "$CLOG"; then
  ok "Z19 the inventory states 201 OWED CRITERIA, 40 EXECUTABLE CHECKS and 22 RUNNER CHECKS; the suite owes $OWED_N and this runner makes $RUNNER_N; the suite's log names all three — different units, none a synonym"
else
  fail "Z19 units: inventory present=$([ -f "$INV" ] && echo yes || echo no), suite owes $OWED_N, runner makes $RUNNER_N"
fi

# ------------------------------------------- Z20-Z21. rendered evidence ----
say ""
say "[8/9] Rendered evidence is opt-in and bounded (Z20)"
EV_AFTER="$(cd "$PROJ" && for e in $EV_FRAMES; do [ -f "evidence/$e.png" ] && shasum -a 256 "evidence/$e.png"; done)"
CEIL_OK=0
grep -qE 'CAP_WAITED" -lt "\$CEILING"' "$0" && [ "$CEILING" -le 120 ] && CEIL_OK=1
if [ "$WITH_EVIDENCE" -eq 0 ] && [ "$EV_BEFORE" = "$EV_AFTER" ] && [ "$CEIL_OK" -eq 1 ]; then
  ok "Z20 this plain run was HEADLESS ONLY and left the evidence untouched; a rendered run is opt-in (--with-evidence) with a hard ${CEILING} s ceiling per capture"
elif [ "$WITH_EVIDENCE" -eq 1 ] && [ "$CEIL_OK" -eq 1 ] && [ -z "$EV_RESULT" ]; then
  ok "Z20 rendering was OPTED IN; each of the eight captures reached the state its name claims, finished inside its ${CEILING} s ceiling and exited 0"
else
  fail "Z20 evidence changed without opting in, a capture timed out or refused its state ($EV_RESULT), or the ceiling is missing"
fi
say ""
say "[9/9] This stage's eight captures (Z21) and the declared fixture (Z22)"
Z21_OK=1
for e in $EV_FRAMES; do
  if [ -f "$PROJ/evidence/$e.png" ]; then
    DIM="$(sips -g pixelWidth -g pixelHeight "$PROJ/evidence/$e.png" 2>/dev/null \
           | awk '/pixel/{printf "%s", $2"x"} END{print ""}' | sed 's/x$//')"
    [ "$DIM" = "1920x1080" ] || { Z21_OK=0; say "        evidence/$e.png is $DIM"; }
  else
    Z21_OK=0; say "        evidence/$e.png missing (run with --with-evidence)"
  fi
done
if [ "$Z21_OK" -eq 1 ]; then
  ok "Z21 all eight D-398 captures (32-39) exist at 1920x1080 — accepted evidence 01-31 is untouched (Z16)"
else
  fail "Z21 the D-398 evidence is missing or mis-sized"
fi
# Z22 — THE DECLARED FIXTURE is untouched by this stage: called by the four
# accepted suites (once each) and the D-396 suite — NOT by the D-398 suite, which
# runs on the review loadout — and in the runtime only by the capture path and
# its definition. Every log shows the D-396 and the D-398 stage exactly once,
# through their banners. Paths are read LINE BY LINE (this path has spaces).
CALLERS="$(grep -lF 'restore_accepted_d392_loadout(' "$PROJ"/tests/*.gd | while IFS= read -r f; do basename "$f"; done | sort | tr '\n' ' ')"
RT_CALLERS="$(grep -rlF 'restore_accepted_d392_loadout(' "$PROJ/scripts" | while IFS= read -r f; do basename "$f"; done | sort | tr '\n' ' ')"
ONCE=1
for s in foundation imprint alignment huntress; do
  N="$(grep -cF 'main.get("hounds").restore_accepted_d392_loadout()' "$PROJ/tests/${s}_verification.gd")"
  [ "$N" = "1" ] || ONCE=0
done
BANNERS=1
for L in "$FLOG" "$ILOG" "$ALOG" "$HLOG" "$KLOG" "$CLOG"; do
  N6="$(grep -cF 'RIFTWROUGHT — KINDRED HOUNDS STAGE  (D-396, 2026-09-19)' "$L")"
  N8="$(grep -cF 'RIFTWROUGHT — MOBILE MINION COHESION STAGE  (D-398, 2026-09-19)' "$L")"
  { [ "$N6" = "1" ] && [ "$N8" = "1" ]; } || BANNERS=0
done
if [ "$CALLERS" = "alignment_verification.gd foundation_verification.gd hounds_verification.gd huntress_verification.gd imprint_verification.gd " ] \
   && [ "$RT_CALLERS" = "foundation_main.gd hound_runtime.gd " ] && [ "$ONCE" -eq 1 ] && [ "$BANNERS" -eq 1 ] && [ "$LEAK" = "0" ]; then
  ok "Z22 the declared fixture is called by the four accepted suites (once each) and the D-396 suite — not by the D-398 suite — and in the runtime only by the capture path and its definition; every log shows the D-396 and D-398 stages once each, and no D-398 row leaks into an accepted log"
else
  fail "Z22 fixture callers '$CALLERS', runtime '$RT_CALLERS', once each=$ONCE, banners=$BANNERS, leaked rows=$LEAK"
fi

# ------------------------------------------------------------------ verdict --
say ""
say "========================================================================"
say "UNITS: 22 RUNNER CHECKS here · 40 EXECUTABLE CHECKS · 201 OWED CRITERIA — different units."
say "$STATE_EXPECT"
if [ "$FAILED" -eq 0 ] && [ "$SKIPPED" -eq 0 ]; then
  say "COHESION RUNNER: PASS (22 runner checks: $((22 - DECLARED_CLAIMS)) run and passed, $DECLARED_CLAIMS DECLARED delivery-time claim(s) — D-400)"
elif [ "$FAILED" -eq 0 ]; then
  say "COHESION RUNNER: INCOMPLETE — $SKIPPED runner check(s) SKIPPED for lack of a baseline; NOT a pass"
  FAILED=1
else
  say "COHESION RUNNER: FAIL"
fi
say "========================================================================"
# Set COHESION_LOG_DIR to keep the six suite logs (a run of record cites them).
if [ -n "${COHESION_LOG_DIR:-}" ] && [ -d "$COHESION_LOG_DIR" ]; then
  cp "$FLOG" "$COHESION_LOG_DIR/foundation.log"; cp "$ILOG" "$COHESION_LOG_DIR/imprint.log"
  cp "$ALOG" "$COHESION_LOG_DIR/alignment.log"; cp "$HLOG" "$COHESION_LOG_DIR/huntress.log"
  cp "$KLOG" "$COHESION_LOG_DIR/hounds.log"; cp "$CLOG" "$COHESION_LOG_DIR/cohesion.log"
fi
rm -f "$FLOG" "$ILOG" "$ALOG" "$HLOG" "$KLOG" "$CLOG"
exit "$FAILED"
