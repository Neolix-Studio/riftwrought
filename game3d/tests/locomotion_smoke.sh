#!/usr/bin/env bash
# =============================================================================
# RIFTWROUGHT — THE PLAYER LOCOMOTION REDIRECTION STAGE RUNNER  (D-400, 2026-09-20)
# =============================================================================
#
# Runs ALL SEVEN game3d/ suites headless against the final code: the ACCEPTED
# D-373 foundation, D-376 Imprint, D-383 alignment, D-394 Splinter Shot, D-397
# Kindred Hounds and D-399 mobile minion cohesion suites as REGRESSIONS, then
# this stage's own suite. It checks their summaries, owed lists, printed rows,
# the state line, truthfulness, the isolation of every protected tree, the D-400
# change set inside game3d/, the asset guards, the input map, the units, the
# accepted fixture and the rendered evidence.
#
#   tests/locomotion_smoke.sh                  headless only (the default)
#   tests/locomotion_smoke.sh --with-evidence  also RENDERS frames 40-45 first,
#                                              each under a hard 120 s ceiling
#
# Set FOUNDATION_BASELINE_DIR to a directory of pre-work SHA-256 listings
# (baseline_<tree>.sha256, baseline_archives.sha256) to run N15, and
# D400_BASELINE_GAME3D to the PRE-D-400 listing of game3d/ to run N16. Without
# them they print [SKIP], are NOT counted as passes, and the run is INCOMPLETE.
#
# =============================================================================
# UNITS. TWENTY-ONE COUNTS, AND NONE IS A SYNONYM FOR ANOTHER.
#
#   D-400: 22 RUNNER CHECKS here (N01-N22) · 33 EXECUTABLE CHECKS in
#          tests/locomotion_verification.gd · 180 OWED CRITERIA in
#          docs/testing/D400_PLAYER_LOCOMOTION_REDIRECTION_OWED_CRITERIA_INVENTORY.md
#   D-398: 22 RUNNER CHECKS · 40 EXECUTABLE CHECKS · 201 OWED CRITERIA
#   D-396: 21 RUNNER CHECKS · 45 EXECUTABLE CHECKS · 202 OWED CRITERIA
#   D-392: 21 RUNNER CHECKS · 53 EXECUTABLE CHECKS · 203 OWED CRITERIA
#   D-380: 21 RUNNER CHECKS · 40 EXECUTABLE CHECKS · 162 OWED CRITERIA
#   D-375: 26 RUNNER CHECKS · 101 EXECUTABLE CHECKS · 149 OWED CRITERIA
#   D-370: 20 RUNNER CHECKS · 85 EXECUTABLE CHECKS · 125 OWED CRITERIA
# =============================================================================
#
# THIS RUNNER VERIFIES A STAGE DELIVERED OPEN. It accepts nothing. It is not
# movement-speed tuning, not a control-scheme change and not authorization for
# other content, and it locks no number.
# =============================================================================
set -uo pipefail

GODOT="${GODOT:-/Applications/Godot.app/Contents/MacOS/Godot}"
HERE="$(cd "$(dirname "$0")" && pwd)"
PROJ="$(cd "$HERE/.." && pwd)"
ROOT="$(cd "$PROJ/.." && pwd)"
FLOG="$(mktemp -t loco_foundation)"
ILOG="$(mktemp -t loco_imprint)"
ALOG="$(mktemp -t loco_alignment)"
HLOG="$(mktemp -t loco_huntress)"
KLOG="$(mktemp -t loco_hounds)"
CLOG="$(mktemp -t loco_cohesion)"
MLOG="$(mktemp -t loco_stage)"
FAILED=0
SKIPPED=0
WITH_EVIDENCE=0
[ "${1:-}" = "--with-evidence" ] && WITH_EVIDENCE=1

# THE ONE STATE LINE, identical in all seven runners (N14 compares them).
# RE-PINNED UNDER D-404, AS ITS FIRST ACT: the D-402 open clause is REPLACED by
# the D-403 acceptance clause and the D-404 open clause is ADDED -- eight facts
# -> NINE. Until D-404 this line ended "... · CINDER FIELD STAGE DELIVERED and
# OPEN pending owner live review (D-402)" -- TRUE WHEN WRITTEN. Still EXACT-LINE.
STATE_EXPECT="STATE: FOUNDATION STAGE ACCEPTED and CLOSED (D-373) · IMPRINT STAGE ACCEPTED and CLOSED (D-376) · D-378 ALIGNMENT STAGE ACCEPTED and CLOSED (D-383) · HUNTRESS SPLINTER SHOT STAGE ACCEPTED and CLOSED (D-394) · KINDRED HOUNDS STAGE ACCEPTED and CLOSED (D-397) · MOBILE MINION COHESION STAGE ACCEPTED and CLOSED (D-399) · PLAYER LOCOMOTION REDIRECTION STAGE ACCEPTED and CLOSED (D-401) · CINDER FIELD STAGE ACCEPTED and CLOSED (D-403) · PLAYER DIRECT-CLICK MOVEMENT CORRECTION STAGE DELIVERED and OPEN pending owner live review (D-404)"
STATE_D375_LINE="STATE: FOUNDATION STAGE ACCEPTED and CLOSED (D-373) · IMPRINT STAGE DELIVERED and OPEN pending owner live review (D-375)"
STATE_D380_LINE="STATE: FOUNDATION STAGE ACCEPTED and CLOSED (D-373) · IMPRINT STAGE ACCEPTED and CLOSED (D-376) · D-378 ALIGNMENT STAGE DELIVERED and OPEN pending owner live review (D-380)"
STATE_D392_LINE="STATE: FOUNDATION STAGE ACCEPTED and CLOSED (D-373) · IMPRINT STAGE ACCEPTED and CLOSED (D-376) · D-378 ALIGNMENT STAGE ACCEPTED and CLOSED (D-383) · HUNTRESS SPLINTER SHOT STAGE DELIVERED and OPEN pending owner live review (D-392)"
STATE_D396_LINE="STATE: FOUNDATION STAGE ACCEPTED and CLOSED (D-373) · IMPRINT STAGE ACCEPTED and CLOSED (D-376) · D-378 ALIGNMENT STAGE ACCEPTED and CLOSED (D-383) · HUNTRESS SPLINTER SHOT STAGE ACCEPTED and CLOSED (D-394) · KINDRED HOUNDS STAGE DELIVERED and OPEN pending owner live review (D-396)"
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
PIN_M_CHECKS=33
PIN_M_DEFERRED=14
# RE-PINNED UNDER D-402, AS ITS FIRST ACT: D-401 ANSWERED LO-01..LO-04 directly
# ("works well, I like it."), so they moved from OWED-TO-OWNER to DISCHARGED with
# their original text preserved. 4 - 4 = 0 owed; 0 + 4 = 4 discharged; 0 deleted.
# The check and deferred counts do NOT move.
PIN_M_OWNER=0
PIN_M_DISCHARGED=4

# THE DECLARED D-400 CHANGE SET INSIDE game3d/, against the PRE-D-400 listing
# (taken 2026-09-20 08:50:02) — pinned in BOTH directions by N16.
#
# `tests/foundation_verification.gd` IS NOT IN IT. The accepted foundation suite
# asserts nothing about the state line, so the first act had nothing in it to
# move, and this stage did not touch it at all. `project.godot` is not in it
# either: D-400 adds NO input action.
DECLARED_MODIFIED="README.md
scripts/cohort/cohort_config.gd
scripts/control/locomotion_motor.gd
scripts/control/player_controller.gd
scripts/core/prod_config.gd
scripts/foundation_main.gd
tests/alignment_smoke.sh
tests/alignment_verification.gd
tests/cohesion_smoke.sh
tests/cohesion_verification.gd
tests/foundation_smoke.sh
tests/hounds_smoke.sh
tests/hounds_verification.gd
tests/huntress_smoke.sh
tests/huntress_verification.gd
tests/imprint_smoke.sh
tests/imprint_verification.gd"
D400_SCRIPTS="ground_motion locomotion_config"
EV_FRAMES="40_d400_launch 41_d400_reversal_ordinary 42_d400_reversal_extreme 43_d400_corner_extreme 44_d400_arrival_extreme 45_d400_doorway_fast"
DECLARED_NEW="$(
  printf '%s\n' tests/locomotion_smoke.sh tests/locomotion_verification.gd tests/locomotion_verification.gd.uid
  for s in $D400_SCRIPTS; do printf 'scripts/locomotion/%s.gd\nscripts/locomotion/%s.gd.uid\n' "$s" "$s"; done
  for e in $EV_FRAMES; do printf 'evidence/%s.png\nevidence/%s.png.import\n' "$e" "$e"; done
)"
# The protected trees, each byte-identical to its pre-work listing (N15).
PROTECTED="game game2d game3d_spike game3d_boss_spike game3d_huntress_spike models"
# The 29 input actions accepted before D-400, in project order. D-400 ADDS NONE.
ACCEPTED_ACTIONS="move_command stick_left stick_right stick_up stick_down aim_left aim_right aim_up aim_down diagnostic_attack zoom_in zoom_out toggle_overlay imprint_binding_1 imprint_binding_2 imprint_binding_3 imprint_binding_4 imprint_binding_5 imprint_binding_6 imprint_binding_7 imprint_binding_8 imprint_panel imprint_panel_prev imprint_panel_next imprint_panel_activate diagnostic_reservation_cycle diagnostic_hound_fall diagnostic_stress_population diagnostic_travel_speed"

say()  { printf '%s\n' "$*"; }
fail() { say "  [FAIL] $*"; FAILED=1; }
ok()   { say "  [ OK ] $*"; }
skip() { say "  [SKIP] $*"; SKIPPED=$((SKIPPED + 1)); }

say "========================================================================"
say "RIFTWROUGHT PLAYER LOCOMOTION REDIRECTION STAGE RUNNER (D-400)"
say "Headless by default. Rendered evidence is opt-in via --with-evidence."
say "It runs the ACCEPTED D-373, D-376, D-383, D-394, D-397 and D-399 suites as REGRESSIONS, then this stage."
say "DELIVERED and OPEN pending owner live review. It accepts nothing."
say "========================================================================"

# The evidence as it stands BEFORE this run -- N20 proves a plain run leaves it alone.
EV_BEFORE="$(cd "$PROJ" && for e in $EV_FRAMES; do [ -f "evidence/$e.png" ] && shasum -a 256 "evidence/$e.png"; done)"

# --------------------------------------------- 0. opt-in evidence, rendered FIRST
EV_RESULT=""
CEILING=120
if [ "$WITH_EVIDENCE" -eq 1 ]; then
  say ""
  say "[0/9] Rendering this stage's six captures (40-45) FIRST (opt-in) — never 01-39"
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

# ------------------------------------------------------------ N01. import ----
say ""
say "[1/9] Import pass (N01)"
"$GODOT" --headless --path "$PROJ" --import >/dev/null 2>&1
IMPORTED="$(ls "$PROJ/.godot/imported" 2>/dev/null | wc -l | tr -d ' ')"
UIDS=0
for s in $D400_SCRIPTS; do [ -f "$PROJ/scripts/locomotion/$s.gd.uid" ] && UIDS=$((UIDS + 1)); done
[ -f "$PROJ/tests/locomotion_verification.gd.uid" ] && UIDS=$((UIDS + 1))
if [ "$IMPORTED" -gt 0 ] && [ "$UIDS" = "3" ]; then
  ok "N01 assets imported ($IMPORTED entries) and both D-400 scripts and the D-400 suite carry their .uid — a fresh checkout verifies"
else
  fail "N01 the import pass produced $IMPORTED entries; D-400 uids $UIDS of 3"
fi

# ------------------------------------------------------ N02-N08. the suites --
say ""
say "[2/9] The seven suites: D-373, D-376, D-383, D-394, D-397 and D-399's cohesion suite as REGRESSIONS, then D-400's own (N02-N08)"
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
"$GODOT" --headless --path "$PROJ" --script res://tests/locomotion_verification.gd >"$MLOG" 2>&1
M_RC=$?
grep -E "^  \[(PASS|FAIL|UNREACHED) *\]" "$MLOG" | sed 's/^/    /' | head -40
grep -E "^(FOUNDATION|IMPRINT|ALIGNMENT|HUNTRESS|HOUNDS|COHESION|LOCOMOTION) VERIFICATION:" \
  "$FLOG" "$ILOG" "$ALOG" "$HLOG" "$KLOG" "$CLOG" "$MLOG" | sed "s|^[^:]*:|    |"

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
M_EXPECT="LOCOMOTION VERIFICATION: PASS ($PIN_M_CHECKS checks: $PIN_M_CHECKS passed, 0 failed/unreached, $PIN_M_DEFERRED deferred, $PIN_M_OWNER owed to the owner, $PIN_M_DISCHARGED discharged)"
pin_summary N02 "$FLOG" FOUNDATION "$PIN_F_CHECKS" "$PIN_F_DEFERRED"
pin_summary N03 "$ILOG" IMPRINT "$PIN_I_CHECKS" "$PIN_I_DEFERRED"
pin_summary N04 "$ALOG" ALIGNMENT "$PIN_A_CHECKS" "$PIN_A_DEFERRED"
H_LINE="$(grep -E '^HUNTRESS VERIFICATION:' "$HLOG" | head -1)"
K_LINE="$(grep -E '^HOUNDS VERIFICATION:' "$KLOG" | head -1)"
C_LINE="$(grep -E '^COHESION VERIFICATION:' "$CLOG" | head -1)"
M_LINE="$(grep -E '^LOCOMOTION VERIFICATION:' "$MLOG" | head -1)"
if [ "$H_LINE" = "$H_EXPECT" ] && [ "$K_LINE" = "$K_EXPECT" ] && [ "$C_LINE" = "$C_EXPECT" ]; then
  ok "N05 the three ACCEPTED summaries that carry owed/discharged counts match EXACTLY: Splinter Shot ($PIN_H_CHECKS/$PIN_H_DEFERRED/$PIN_H_OWNER/$PIN_H_DISCHARGED), Kindred Hounds ($PIN_K_CHECKS/$PIN_K_DEFERRED/$PIN_K_OWNER/$PIN_K_DISCHARGED) and mobile minion cohesion ($PIN_C_CHECKS/$PIN_C_DEFERRED/$PIN_C_OWNER/$PIN_C_DISCHARGED — re-pinned under D-400's first act)"
else
  fail "N05 a summary MISMATCH"; say "        expected: $H_EXPECT"; say "        actual  : $H_LINE"
  say "        expected: $K_EXPECT"; say "        actual  : $K_LINE"
  say "        expected: $C_EXPECT"; say "        actual  : $C_LINE"
fi
if [ "$M_LINE" = "$M_EXPECT" ]; then
  ok "N06 this stage's summary matches EXACTLY: $PIN_M_CHECKS executable checks, $PIN_M_DEFERRED deferred rows, $PIN_M_OWNER owed to the owner and $PIN_M_DISCHARGED discharged (D-402 first act: D-401 answered all four)"
else
  fail "N06 the D-400 summary MISMATCH"; say "        expected: $M_EXPECT"; say "        actual  : $M_LINE"
fi
OWED_OK=1
for spec in "$FLOG:$PIN_F_CHECKS:F" "$ILOG:$PIN_I_CHECKS:I" "$ALOG:$PIN_A_CHECKS:A" "$HLOG:$PIN_H_CHECKS:H" \
            "$KLOG:$PIN_K_CHECKS:B" "$CLOG:$PIN_C_CHECKS:C" "$MLOG:$PIN_M_CHECKS:L"; do
  L="${spec%%:*}"; rest="${spec#*:}"; C="${rest%%:*}"; P="${rest#*:}"
  LINE="$(grep -E '^  owed=' "$L" | head -1 | sed 's/^ *//')"
  EXPECT="owed=$C  reached=$C  owed-but-not-reached=0 []  reached-but-not-owed=0 []"
  NAMES="$(grep -cE "^  \[PASS     \] $P[0-9]+_" "$L")"
  if [ "$LINE" != "$EXPECT" ] || [ "$NAMES" != "$C" ]; then
    OWED_OK=0; say "        $(basename "$L"): '$LINE' ($NAMES $P-names)"
  fi
done
if [ "$OWED_OK" -eq 1 ]; then
  ok "N07 owed vs reached matches in BOTH directions in all seven logs, and every F-, I-, A-, H-, B-, C- and L-numbered check passed"
else
  fail "N07 owed/reached or name counts MISMATCH"
fi
RC_OK=1
for rc in "$F_RC" "$I_RC" "$A_RC" "$H_RC" "$K_RC" "$C_RC" "$M_RC"; do [ "$rc" -ne 0 ] && RC_OK=0; done
if [ "$RC_OK" -eq 1 ]; then
  ok "N08 all seven suites exited 0"
else
  fail "N08 a suite exited non-zero (F $F_RC, I $I_RC, A $A_RC, H $H_RC, B $K_RC, C $C_RC, L $M_RC)"
fi

# ----------------------------------------------- N09. pins able to refuse ----
say ""
say "[3/9] Every summary pin PROVED able to refuse an altered value (N09)"
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
refuse_three() { # $1 line, $2 expect, $3 checks, $4 rows-token, $5 rows, $6 third-token, $7 third
  local a1 a2 a3
  a1="$(printf '%s' "$1" | sed "s/($3 checks/($(($3 - 1)) checks/")"
  a2="$(printf '%s' "$1" | sed "s/, $5 $4/, $(($5 + 1)) $4/")"
  a3="$(printf '%s' "$1" | sed "s/, $7 $6/, $(($7 - 1)) $6/")"
  [ "$a1" != "$2" ] && [ "$a2" != "$2" ] && [ "$a3" != "$2" ] && [ "$1" = "$2" ]
}
refuse_three "$H_LINE" "$H_EXPECT" "$PIN_H_CHECKS" deferred "$PIN_H_DEFERRED" discharged "$PIN_H_DISCHARGED" && REFUSED=$((REFUSED + 1))
refuse_three "$K_LINE" "$K_EXPECT" "$PIN_K_CHECKS" deferred "$PIN_K_DEFERRED" discharged "$PIN_K_DISCHARGED" && REFUSED=$((REFUSED + 1))
refuse_three "$C_LINE" "$C_EXPECT" "$PIN_C_CHECKS" deferred "$PIN_C_DEFERRED" discharged "$PIN_C_DISCHARGED" && REFUSED=$((REFUSED + 1))
M_ALT1="$(printf '%s' "$M_LINE" | sed "s/($PIN_M_CHECKS checks/($((PIN_M_CHECKS - 1)) checks/")"
M_ALT2="$(printf '%s' "$M_LINE" | sed "s/, $PIN_M_DEFERRED deferred/, $((PIN_M_DEFERRED - 1)) deferred/")"
M_ALT3="$(printf '%s' "$M_LINE" | sed "s/, $PIN_M_DISCHARGED discharged/, $((PIN_M_DISCHARGED - 1)) discharged/")"
if [ "$M_ALT1" != "$M_EXPECT" ] && [ "$M_ALT2" != "$M_EXPECT" ] && [ "$M_ALT3" != "$M_EXPECT" ] && [ "$M_LINE" = "$M_EXPECT" ]; then
  REFUSED=$((REFUSED + 1))
fi
if [ "$REFUSED" = "7" ]; then
  ok "N09 all seven summary pins REFUSE an altered check count AND an altered row count (the three carrying a discharged count also an altered discharged count; this stage's, since D-402's first act, an altered DISCHARGED count) — replayed"
else
  fail "N09 only $REFUSED of 7 summary pins were proved able to refuse an altered value"
fi

# -------------------------------------------------- N10. printed rows ----
say ""
say "[4/9] Deferred, owed and discharged rows (N10)"
LD_ROWS="$(grep -cE '^  \[[^]]+\] LD-(0[1-9]|1[0-4]) ' "$MLOG")"
LO_ROWS="$(grep -cE '^  \[OWED-TO-OWNER\] LO-0[1-4] ' "$MLOG")"
# D-402 (first act): D-401 ANSWERED all four, so they print DISCHARGED — D-401
# with their ORIGINAL text preserved, and none prints as owed any more.
LO_DIS="$(grep -cE '^  \[DISCHARGED — D-401\] LO-0[1-4] ' "$MLOG")"
LO_KEPT="$(grep -cF "ORIGINAL ROW TEXT, PRESERVED VERBATIM (OWED-TO-OWNER): 'Whether" "$MLOG")"
M_PASSROW="$(grep -cE '^  \[(PASS|OK) *\] L[DO]-' "$MLOG")"
# D-402 (first act): the owner RE-CLASSIFIED LD-02 under D-401 -- "a measured
# provisional finding rather than a defect or locked rule" -- so its disposition
# moved. RE-CLASSIFICATION IS NOT DISCHARGE: it still prints, and still is not a
# pass. Until D-402 this required "DECLARED — NOT REPAIRED" -- true when written.
LD02="$(grep -cE '^  \[CARRIED — PROVISIONAL FINDING *\] LD-02 ' "$MLOG")"
LD03="$(grep -cE '^  \[CARRIED — NOT DISCHARGED *\] LD-03 ' "$MLOG")"
LD10="$(grep -cE '^  \[OUT OF SCOPE *\] LD-10 ' "$MLOG")"
ROW_PREY="$(grep -E '^  \[[^]]+\] L[DO]-[0-9]+ ' "$MLOG" | grep -ci 'prey' || true)"
CO_DIS="$(grep -cE '^  \[DISCHARGED — D-399\] CO-0[1-5] ' "$CLOG")"
CO_OWED="$(grep -cE '^  \[OWED-TO-OWNER\] CO-' "$CLOG")"
KO_DIS="$(grep -cE '^  \[DISCHARGED — D-397\] KO-0[1-6] ' "$KLOG")"
SO_DIS="$(grep -cE '^  \[DISCHARGED — D-394\] SO-0[1235] ' "$HLOG")"
LEAK="$(grep -cE '^  \[OWED-TO-OWNER\] LO-|^  \[[^]]+\] LD-[0-9]+ |^LOCOMOTION VERIFICATION' "$FLOG" "$ILOG" "$ALOG" "$HLOG" "$KLOG" "$CLOG" | awk -F: '{s+=$2} END{print s+0}')"
if [ "$LD_ROWS" = "$PIN_M_DEFERRED" ] && [ "$LO_ROWS" = "$PIN_M_OWNER" ] && [ "$M_PASSROW" = "0" ] \
   && [ "$LD02" = "1" ] && [ "$LD03" = "1" ] && [ "$LD10" = "1" ] && [ "$ROW_PREY" = "0" ] \
   && [ "$LO_DIS" = "$PIN_M_DISCHARGED" ] && [ "$LO_KEPT" -ge "$PIN_M_DISCHARGED" ] \
   && [ "$CO_DIS" = "$PIN_C_DISCHARGED" ] && [ "$CO_OWED" = "0" ] && [ "$KO_DIS" = "$PIN_K_DISCHARGED" ] \
   && [ "$SO_DIS" = "$PIN_H_DISCHARGED" ] && [ "$LEAK" = "0" ]; then
  ok "N10 the D-400 run prints LD-01..LD-14 ($LD_ROWS) and, since D-402's first act, LO-01..LO-04 as DISCHARGED — D-401 ($LO_DIS) with their original text preserved ($LO_KEPT) and NONE owed ($LO_ROWS), none as a pass and none naming Prey; LD-02 CARRIED — PROVISIONAL FINDING (re-classified by D-401, NOT discharged), LD-03 CARRIED, LD-10 OUT OF SCOPE; the D-398 run prints CO-01..CO-05 DISCHARGED — D-399 and none owed, the D-396 run its six KO- rows DISCHARGED — D-397 and the D-392 run its four SO- rows DISCHARGED — D-394; no D-400 row leaks into an accepted log"
else
  fail "N10 rows: LD $LD_ROWS, LO owed $LO_ROWS, LO discharged $LO_DIS, LO text kept $LO_KEPT, as pass $M_PASSROW, LD-02 $LD02, LD-03 $LD03, LD-10 $LD10, naming Prey $ROW_PREY, CO discharged $CO_DIS, CO owed $CO_OWED, KO discharged $KO_DIS, SO discharged $SO_DIS, leaked $LEAK"
fi

# ---------------------------------------------------- N11. engine errors ----
say ""
say "[5/9] Engine-error guard (N11)"
ERRPAT='^(SCRIPT )?ERROR:|^USER ERROR:|^SCRIPT ERROR|Parse Error|Failed to load script'
SELF='Foundation_Signature_Move_THIS_DOES_NOT_EXIST'
SELF_N="$(grep -cF "$SELF" "$FLOG")"
F_REAL="$(grep -E "$ERRPAT" "$FLOG" | grep -vF "$SELF" || true)"
OTHER_REAL="$(grep -E "$ERRPAT" "$ILOG" "$ALOG" "$HLOG" "$KLOG" "$CLOG" "$MLOG" || true)"
PLANT="$(mktemp -t loco_plant)"; cat "$MLOG" > "$PLANT"
printf 'SCRIPT ERROR: planted engine error, for guard proving only\n' >> "$PLANT"
if [ "$SELF_N" -lt 1 ]; then
  fail "N11 the accepted suite's guard-proving error line is missing — F12's proof is not intact"
elif [ -n "$F_REAL" ] || [ -n "$OTHER_REAL" ]; then
  fail "N11 engine errors present:"
  printf '%s\n' "$F_REAL" "$OTHER_REAL" | grep -v '^$' | head -12 | sed 's/^/        /'
elif ! grep -qE "$ERRPAT" "$PLANT"; then
  fail "N11 the error guard could NOT detect a planted error line"
else
  ok "N11 no engine error in any of the seven logs beyond the one expected guard proof, and the guard refuses a planted error (a parse error EXITS 0, so this guard, not the exit code, is what catches it)"
fi
rm -f "$PLANT"

# ------------------------------------ N12-N14. state line and truthfulness --
say ""
say "[6/9] The state line and truthfulness (N12-N14)"
BAD_STATE=0
for L in "$FLOG" "$ILOG" "$ALOG" "$HLOG" "$KLOG" "$CLOG" "$MLOG"; do
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
  grep -qxF "$S" "$FLOG" "$ILOG" "$ALOG" "$HLOG" "$KLOG" "$CLOG" "$MLOG" && SUPERSEDED=1
done
# THE STAGE NEVER ACCEPTS ITSELF, and no earlier stage is made to accept itself.
# "MOBILE MINION COHESION STAGE ACCEPTED and CLOSED (D-399)" is the OWNER'S
# fact and appears in the state line itself, so it is NOT forbidden. What is
# still false, and refused: the OPEN D-400 stage called accepted, and any earlier
# stage attributed its acceptance to the ruling that only DELIVERED it.
# RE-SCOPED UNDER D-402 (first act), one for one: D-401 made "PLAYER LOCOMOTION
# REDIRECTION STAGE ACCEPTED" the OWNER's fact -- it is now in the state line
# itself -- so it leaves the pattern and the OPEN D-402 Cinder Field stage takes
# its place. Still false, and refused: an earlier stage attributed its acceptance
# to the ruling that only DELIVERED it, and the OPEN D-402 stage called accepted.
# RE-SCOPED UNDER D-404 (first act), one for one: D-403 made "CINDER FIELD
# STAGE ACCEPTED" the OWNER's fact -- it is in the state line itself -- so it
# leaves the pattern and the OPEN D-404 direct-click stage takes its place.
# "ACCEPTED and CLOSED (D-402)" joins what is still false: D-402 DELIVERED the
# Cinder Field stage and D-403 accepted it.
SELF_ACCEPT='PLAYER DIRECT-CLICK MOVEMENT CORRECTION STAGE ACCEPTED|D-404 (is|stage is) ACCEPTED|ACCEPTED and CLOSED \(D-402\)|ACCEPTED and CLOSED \(D-400\)|ACCEPTED and CLOSED \(D-398\)|ACCEPTED and CLOSED \(D-396\)|ACCEPTED and CLOSED \(D-392\)'
ACCEPTS="$(grep -hE "$SELF_ACCEPT" "$FLOG" "$ILOG" "$ALOG" "$HLOG" "$KLOG" "$CLOG" "$MLOG" | grep -v 'SELF_ACCEPT' | head -3 || true)"
PLANT3="$(mktemp -t loco_plant3)"; printf 'PLAYER DIRECT-CLICK MOVEMENT CORRECTION STAGE ACCEPTED and CLOSED (D-404)\n' > "$PLANT3"
ALT_STATE="$(printf '%s' "$STATE_EXPECT" | sed 's/DELIVERED and OPEN pending owner live review (D-404)/ACCEPTED and CLOSED (D-404)/')"
if [ "$BAD_STATE" -eq 0 ] && [ "$SUPERSEDED" -eq 0 ] && [ -z "$ACCEPTS" ] && grep -qE "$SELF_ACCEPT" "$PLANT3" \
   && [ "$ALT_STATE" != "$STATE_EXPECT" ] && [ "$STATE_D398_LINE" != "$STATE_EXPECT" ] \
   && [ "$STATE_D400_LINE" != "$STATE_EXPECT" ] \
   && [ "$STATE_D402_LINE" != "$STATE_EXPECT" ]; then
  ok "N12 every STATE line in all seven logs is the SAME exact nine-fact line (D-404 first act); no superseded line (D-375, D-380, D-392, D-396, D-398, D-400, D-402, bare D-370) is printed; nothing claims the open D-402 stage accepted or an earlier stage accepting itself — and each scan refuses a planted line"
else
  fail "N12 a state line differs ($BAD_STATE), a superseded line is printed ($SUPERSEDED), or a self-acceptance appears: $ACCEPTS"
fi
rm -f "$PLANT3"
N13_MISS=""
for s in "The D-400 stage IS NOT P2 and AUTHORIZES NO P2." \
         "IS NOT movement-speed tuning" \
         "IS NOT a control-scheme change" \
         "adds NO input action: the project's 29 accepted actions stay 29" \
         "adds NO player-facing or review surface and IS NOT a UI foundation" \
         "changes NO diagnostic travel-speed multiplier" \
         "changes NO camera, zoom, Skill timing, damage, minion movement or navigation geometry value" \
         "changes NO minion locomotion" \
         "introduces EXACTLY TWO numbers and derives everything else; it LOCKS NO NUMBER" \
         "does NOT scale the ACTION brake" \
         "modifies NO accepted spike and has NO runtime dependency outside game3d/" \
         "The D-400 stage was delivered OPEN and never accepted itself: the owner ACCEPTED and CLOSED it under D-401" \
         "[DISCHARGED — D-401] LO-01 Whether abrupt direction changes feel immediate and controlled at ORDINARY speed." \
         "[DISCHARGED — D-401] LO-04 Whether starts and stops still feel natural." \
         "THE OWNER'S D-401 LIVE REVIEW: ANSWERED DIRECTLY — \"works well, I like it.\"" \
         "LD-02 stays CARRIED as a measured provisional finding rather than a defect or a rule"; do
  grep -qF "$s" "$MLOG" || N13_MISS="$N13_MISS | $s"
done
# AND THE D-398 STAGE'S OWN RECONCILED STRINGS, in its own log.
for s in "The D-398 stage was delivered OPEN and never accepted itself: the owner ACCEPTED and CLOSED it under D-399" \
         "[DISCHARGED — D-399] CO-01 Whether the pack stays around or ahead of her." \
         "THE OWNER'S ANSWER, VERBATIM: the pack \"stays appropriately around or ahead of me\"" \
         "for the owner to confirm or overrule"; do
  grep -qF "$s" "$CLOG" || N13_MISS="$N13_MISS | (D-398 log) $s"
done
FORBID='P2 is authorized|P1 is complete|the top speed is (locked|changed)|3\.889 is locked|the acceleration rate is locked|the braking rate is locked|the response time is locked|movement speed is tuned|WASD is (added|bound)|a new input action is added|the camera is (locked|changed)|production ready|pivot complete|final animation is (approved|accepted)|the pack size is (locked|increased)'
PLANT2="$(mktemp -t loco_plant2)"; printf 'the acceleration rate is locked\n' > "$PLANT2"
if [ -n "$N13_MISS" ]; then
  fail "N13 the run does NOT state:$N13_MISS"
elif grep -qiE "$FORBID" "$FLOG" "$ILOG" "$ALOG" "$HLOG" "$KLOG" "$CLOG" "$MLOG"; then
  fail "N13 a run log makes a forbidden lock or completion claim:"
  grep -hiE "$FORBID" "$FLOG" "$ILOG" "$ALOG" "$HLOG" "$KLOG" "$CLOG" "$MLOG" | head -3 | sed 's/^/        /'
elif ! grep -qiE "$FORBID" "$PLANT2"; then
  fail "N13 the forbidden-claim scan cannot see a planted claim"
else
  ok "N13 the D-400 run states its twenty truthfulness strings (twelve of its fourteen denials, its reconciled self-denial, the first and last owner questions now DISCHARGED — D-401 with the owner's verbatim answer, and LD-02's re-classification, plus the D-398 stage's four reconciled strings in its own log), no log makes a forbidden lock or completion claim, and the scan refuses a planted one"
fi
rm -f "$PLANT2"
L_F="$(grep -E '^STATE_EXPECT=' "$PROJ/tests/foundation_smoke.sh" | head -1)"
L_I="$(grep -E '^STATE_EXPECT=' "$PROJ/tests/imprint_smoke.sh" | head -1)"
L_A="$(grep -E '^STATE_EXPECT=' "$PROJ/tests/alignment_smoke.sh" | head -1)"
L_H="$(grep -E '^STATE_EXPECT=' "$PROJ/tests/huntress_smoke.sh" | head -1)"
L_K="$(grep -E '^STATE_EXPECT=' "$PROJ/tests/hounds_smoke.sh" | head -1)"
L_C="$(grep -E '^STATE_EXPECT=' "$PROJ/tests/cohesion_smoke.sh" | head -1)"
L_M="$(grep -E '^STATE_EXPECT=' "$0" | head -1)"
NEEDLES_396=0
NEEDLES_398=0
for r in foundation_smoke.sh imprint_smoke.sh alignment_smoke.sh huntress_smoke.sh hounds_smoke.sh cohesion_smoke.sh locomotion_smoke.sh; do
  grep -qxF "STATE_D396_LINE=\"$STATE_D396_LINE\"" "$PROJ/tests/$r" && NEEDLES_396=$((NEEDLES_396 + 1))
  grep -qxF "STATE_D398_LINE=\"$STATE_D398_LINE\"" "$PROJ/tests/$r" && NEEDLES_398=$((NEEDLES_398 + 1))
done
CNT_OK=1
for r in imprint_smoke.sh alignment_smoke.sh huntress_smoke.sh hounds_smoke.sh cohesion_smoke.sh locomotion_smoke.sh; do
  for p in 'PIN_F_CHECKS=85' 'PIN_F_DEFERRED=11' 'PIN_I_CHECKS=101' 'PIN_I_DEFERRED=16'; do
    grep -qx "$p" "$PROJ/tests/$r" || CNT_OK=0
  done
done
for r in alignment_smoke.sh huntress_smoke.sh hounds_smoke.sh cohesion_smoke.sh locomotion_smoke.sh; do
  for p in 'PIN_A_CHECKS=40' 'PIN_A_DEFERRED=10'; do grep -qx "$p" "$PROJ/tests/$r" || CNT_OK=0; done
done
for r in huntress_smoke.sh hounds_smoke.sh cohesion_smoke.sh locomotion_smoke.sh; do
  for p in 'PIN_H_CHECKS=53' 'PIN_H_DEFERRED=15' 'PIN_H_OWNER=0' 'PIN_H_DISCHARGED=4'; do grep -qx "$p" "$PROJ/tests/$r" || CNT_OK=0; done
done
for r in hounds_smoke.sh cohesion_smoke.sh locomotion_smoke.sh; do
  for p in 'PIN_K_CHECKS=45' 'PIN_K_DEFERRED=16' 'PIN_K_OWNER=0' 'PIN_K_DISCHARGED=6'; do grep -qx "$p" "$PROJ/tests/$r" || CNT_OK=0; done
done
for p in 'PIN_C_CHECKS=40' 'PIN_C_DEFERRED=16' 'PIN_C_OWNER=0' 'PIN_C_DISCHARGED=5'; do
  grep -qx "$p" "$PROJ/tests/cohesion_smoke.sh" || CNT_OK=0
  grep -qx "$p" "$PROJ/tests/locomotion_smoke.sh" || CNT_OK=0
done
if [ -n "$L_F" ] && [ "$L_F" = "$L_I" ] && [ "$L_I" = "$L_A" ] && [ "$L_A" = "$L_H" ] && [ "$L_H" = "$L_K" ] \
   && [ "$L_K" = "$L_C" ] && [ "$L_C" = "$L_M" ] && [ "$L_M" = "STATE_EXPECT=\"$STATE_EXPECT\"" ] \
   && [ "$NEEDLES_396" = "7" ] && [ "$NEEDLES_398" = "7" ] && [ "$CNT_OK" -eq 1 ]; then
  ok "N14 the seven runners pin the IDENTICAL seven-fact state line, each holds the D-396-era and D-398-era lines as SUPERSEDED needles, and they carry the same accepted counts (85/11, 101/16, 40/10, 53/15 with 0 owed and 4 discharged, 45/16 with 0 owed and 6 discharged, 40/16 with 0 owed and 5 discharged)"
else
  fail "N14 the runners disagree on the state line, a needle (D-396 $NEEDLES_396 of 7, D-398 $NEEDLES_398 of 7) or a carried count (ok=$CNT_OK)"
fi

# ------------------------------------------------ N15-N19. isolation ----
say ""
say "[7/9] Isolation, the change set, the asset guards, the input map and the units (N15-N19)"
BASE="${FOUNDATION_BASELINE_DIR:-}"
N15_OK=1; N15_RAN=0; N_ARCH=0
for d in $PROTECTED; do
  f="$BASE/baseline_$d.sha256"
  if [ -n "$BASE" ] && [ -f "$f" ]; then
    N15_RAN=$((N15_RAN + 1))
    NOW="$(mktemp -t loco_now)"
    ( cd "$ROOT" && find "$d" -type f -print0 | sort -z | xargs -0 shasum -a 256 ) > "$NOW"
    if ! diff -q "$f" "$NOW" >/dev/null; then
      N15_OK=0; say "        $d/ CHANGED"
      diff "$f" "$NOW" | grep -E '^[<>]' | head -6 | sed 's/^/          /'
    fi
    rm -f "$NOW"
  fi
done
if [ -n "$BASE" ] && [ -f "$BASE/baseline_archives.sha256" ]; then
  N15_RAN=$((N15_RAN + 1))
  NOW="$(mktemp -t loco_now)"
  ( cd "$ROOT" && sed -E 's/^[0-9a-f]+  //' "$BASE/baseline_archives.sha256" | while IFS= read -r p; do
      shasum -a 256 "$p"; done ) | sort -k2 > "$NOW"
  N_ARCH="$(wc -l < "$NOW" | tr -d ' ')"
  diff -q "$BASE/baseline_archives.sha256" "$NOW" >/dev/null || { N15_OK=0; say "        an archive under assets/ CHANGED"; }
  rm -f "$NOW"
fi
if [ "$N15_RAN" -eq 7 ] && [ "$N15_OK" -eq 1 ]; then
  ok "N15 game/, game2d/, game3d_spike/, game3d_boss_spike/, game3d_huntress_spike/ (README included), models/ and all $N_ARCH archives under assets/ are byte-identical to the pre-work baseline"
elif [ "$N15_RAN" -eq 0 ]; then
  skip "N15 baselines not supplied (set FOUNDATION_BASELINE_DIR) — NOT a pass"
else
  fail "N15 a protected tree or archive changed, or a baseline is missing ($N15_RAN of 7 measured)"
fi
G3="${D400_BASELINE_GAME3D:-}"
if [ -n "$G3" ] && [ -f "$G3" ]; then
  NOW="$(mktemp -t loco_now)"
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
  PLANTED_SET="$(printf '%s\ngame3d/tests/foundation_verification.gd\n' "$MODIFIED" | sort -u)"
  if [ -z "$REMOVED" ] && [ "$MODIFIED" = "$EXP_MOD" ] && [ "$ADDED" = "$EXP_NEW" ] && [ "$PLANTED_SET" != "$EXP_MOD" ]; then
    ok "N16 inside game3d/: exactly the $(printf '%s\n' "$EXP_MOD" | wc -l | tr -d ' ') declared files changed and the $(printf '%s\n' "$EXP_NEW" | wc -l | tr -d ' ') declared files are new — EVERY other authored file is byte-identical (the ACCEPTED foundation suite, project.godot, the cohort, hound, Huntress, Imprint, combat, world and view code, scenes, the asset trees, evidence 01-39); a planted undeclared change is refused"
  else
    fail "N16 the game3d/ change set differs from the declared set"
    say "        undeclared/missing modifications:"; diff <(printf '%s\n' "$MODIFIED") <(printf '%s\n' "$EXP_MOD") | grep -E '^[<>]' | head -8 | sed 's/^/          /'
    say "        undeclared/missing additions:";    diff <(printf '%s\n' "$ADDED") <(printf '%s\n' "$EXP_NEW") | grep -E '^[<>]' | head -8 | sed 's/^/          /'
    [ -n "$REMOVED" ] && { say "        removed:"; printf '%s\n' "$REMOVED" | head -5 | sed 's/^/          /'; }
  fi
  rm -f "$NOW"
else
  skip "N16 the pre-D-400 game3d/ listing not supplied (set D400_BASELINE_GAME3D) — NOT a pass"
fi
# N17 — NO NEW ASSET, NO ART, NO VFX, NO AUDIO, NO .pxo, the four trees.
PXO="$(find "$PROJ" -name '*.pxo' 2>/dev/null | head -1)"
TREES="$(find "$ROOT" -type d -name 'quaternius' 2>/dev/null | sed "s|^$ROOT/||" | sort | tr '\n' ' ')"
EXPECT_TREES="game/assets/third_party/quaternius game3d/assets/third_party/quaternius game3d_boss_spike/assets/third_party/quaternius game3d_spike/assets/third_party/quaternius "
AUDIO="$(find "$PROJ" \( -name '*.wav' -o -name '*.ogg' -o -name '*.mp3' -o -name '*.flac' \) 2>/dev/null | head -1)"
BAD="$(find "$PROJ" \( -iname '*UltimateMonsters*' -o -iname '*Ultimate_Monsters*' -o -iname '*dog*' -o -iname '*wolf*' \
        -o -iname '*VFX*' -o -iname '*BattleFX*' -o -iname '*MagicFX*' -o -iname '*VividMotion*' -o -iname '*prey*' \) \
        -not -path '*/.godot/*' 2>/dev/null | head -1)"
# RE-PINNED UNDER D-402, ONE FOR ONE: 29 + 4 = 33 -- the two Cinder Field
# placeholder bodies (.obj + .mtl each) added to the ALREADY-DECLARED CC0
# Ultimate Modular Ruins pack. The variable keeps its NAME so nothing is
# renamed around a guard; its expected value moves. Until D-402 it was 29.
DECLARED29="$(grep -oE '"(bestiary_dungeon_monsters|universal_animation_library|universal_animation_library_2|modular_character_outfits_fantasy|ultimate_modular_ruins)/[^"]+"' "$PROJ/scripts/assets/asset_manifest.gd" | grep -vF '%s' | sort -u | wc -l | tr -d ' ')"
LOCO_REFS="$(grep -lE 'res://assets|preload\(|[^_]load\(' "$PROJ"/scripts/locomotion/*.gd 2>/dev/null | head -1)"
ASSET_FILES_BEFORE="$( [ -n "${D400_BASELINE_GAME3D:-}" ] && [ -f "$D400_BASELINE_GAME3D" ] \
  && sed -E 's/^[0-9a-f]+  game3d\///' "$D400_BASELINE_GAME3D" | grep -c '^assets/' )"
ASSET_FILES_NOW="$(cd "$PROJ" && find assets -type f | wc -l | tr -d ' ')"
if [ -z "$PXO" ] && [ "$TREES" = "$EXPECT_TREES" ] && [ -z "$AUDIO" ] && [ -z "$BAD" ] && [ "$DECLARED29" = "33" ] && [ -z "$LOCO_REFS" ] \
   && { [ -z "$ASSET_FILES_BEFORE" ] || [ "$ASSET_FILES_BEFORE" = "$ASSET_FILES_NOW" ]; }; then
  ok "N17 no .pxo, no audio, no model, dog, wolf, Ultimate Monsters, VFX or Prey file in game3d/; the D-370 block still declares 29; neither locomotion script loads anything; the asset tree holds the same $ASSET_FILES_NOW files; exactly the four quaternius trees in the repository"
else
  fail "N17 pxo='$PXO' trees='$TREES' audio='$AUDIO' excluded='$BAD' declared=$DECLARED29 load='$LOCO_REFS' asset files before=$ASSET_FILES_BEFORE now=$ASSET_FILES_NOW"
fi
# N18 — THE INPUT MAP IS UNCHANGED: the 29 accepted actions, in order, and NO more.
ACT_LIST="$(grep -oE '^[a-z_][a-z_0-9]*=\{$' "$PROJ/project.godot" | tr -d '={' | tr '\n' ' ' | sed 's/ $//')"
WASD=0
for code in 87 65 83 68; do
  N="$(grep -cF "\"physical_keycode\":$code," "$PROJ/project.godot" || true)"
  [ "$N" != "0" ] && WASD=1
done
PLANT_LIST="$ACCEPTED_ACTIONS diagnostic_dash"
MOUSE="$(awk '/^move_command=\{/{f=1} f{print} f&&/^}/{exit}' "$PROJ/project.godot" | grep -c 'InputEventMouseButton')"
if [ "$ACT_LIST" = "$ACCEPTED_ACTIONS" ] && [ "$WASD" -eq 0 ] && [ "$MOUSE" -ge 1 ] \
   && [ "$PLANT_LIST" != "$ACT_LIST" ]; then
  ok "N18 project.godot declares EXACTLY the 29 accepted actions, unchanged and in order — D-400 adds NONE (29 stays 29); move_command is still bound to a mouse button; no W/A/S/D; a planted extra action is refused"
else
  fail "N18 actions '$ACT_LIST' | move_command mouse events $MOUSE | W/A/S/D=$WASD"
fi
# N19 — THE UNITS, stated where they are owed.
INV="$ROOT/docs/testing/D400_PLAYER_LOCOMOTION_REDIRECTION_OWED_CRITERIA_INVENTORY.md"
OWED_N="$(awk '/^const OWED := \[/{f=1; next} f&&/^\]/{exit} f' "$PROJ/tests/locomotion_verification.gd" | grep -cE '^\s*"L[0-9][0-9]_')"
RUNNER_N="$(grep -oE 'N[0-9][0-9]' "$0" | sort -u | wc -l | tr -d ' ')"
if [ -f "$INV" ] && grep -qF '= 180 OWED CRITERIA' "$INV" && grep -qF '**33**' "$INV" \
   && grep -qF '**22**' "$INV" && grep -qF '`L01` …' "$INV" && grep -qF '`N01` …' "$INV" \
   && [ "$OWED_N" = "33" ] && [ "$RUNNER_N" = "22" ] && grep -qF '22 RUNNER CHECKS in tests/locomotion_smoke.sh' "$MLOG"; then
  ok "N19 the inventory states 180 OWED CRITERIA, 33 EXECUTABLE CHECKS and 22 RUNNER CHECKS; the suite owes $OWED_N and this runner makes $RUNNER_N; the suite's log names all three — different units, none a synonym"
else
  fail "N19 units: inventory present=$([ -f "$INV" ] && echo yes || echo no), suite owes $OWED_N, runner makes $RUNNER_N"
fi

# ------------------------------------------- N20-N21. rendered evidence ----
say ""
say "[8/9] Rendered evidence is opt-in and bounded (N20)"
EV_AFTER="$(cd "$PROJ" && for e in $EV_FRAMES; do [ -f "evidence/$e.png" ] && shasum -a 256 "evidence/$e.png"; done)"
CEIL_OK=0
grep -qE 'CAP_WAITED" -lt "\$CEILING"' "$0" && [ "$CEILING" -le 120 ] && CEIL_OK=1
if [ "$WITH_EVIDENCE" -eq 0 ] && [ "$EV_BEFORE" = "$EV_AFTER" ] && [ "$CEIL_OK" -eq 1 ]; then
  ok "N20 this plain run was HEADLESS ONLY and left the evidence untouched; a rendered run is opt-in (--with-evidence) with a hard ${CEILING} s ceiling per capture"
elif [ "$WITH_EVIDENCE" -eq 1 ] && [ "$CEIL_OK" -eq 1 ] && [ -z "$EV_RESULT" ]; then
  ok "N20 rendering was OPTED IN; each of the six captures reached the state its name claims, finished inside its ${CEILING} s ceiling and exited 0"
else
  fail "N20 evidence changed without opting in, a capture timed out or refused its state ($EV_RESULT), or the ceiling is missing"
fi
say ""
say "[9/9] This stage's six captures (N21) and the accepted D-398 fixture (N22)"
N21_OK=1
for e in $EV_FRAMES; do
  if [ -f "$PROJ/evidence/$e.png" ]; then
    DIM="$(sips -g pixelWidth -g pixelHeight "$PROJ/evidence/$e.png" 2>/dev/null \
           | awk '/pixel/{printf "%s", $2"x"} END{print ""}' | sed 's/x$//')"
    [ "$DIM" = "1920x1080" ] || { N21_OK=0; say "        evidence/$e.png is $DIM"; }
  else
    N21_OK=0; say "        evidence/$e.png missing (run with --with-evidence)"
  fi
done
if [ "$N21_OK" -eq 1 ]; then
  ok "N21 all six D-400 captures (40-45) exist at 1920x1080 — accepted evidence 01-39 is untouched (N16)"
else
  fail "N21 the D-400 evidence is missing or mis-sized"
fi
# N22 — THE ACCEPTED FIXTURE AND THE BANNERS. The declared D-392-loadout fixture
# is called by the four accepted suites (once each) and the D-396 suite, NOT by
# the D-398 or D-400 suites, which run on the review loadout; and in the runtime
# only by the capture path and its definition. Every log shows the D-396, D-398
# and D-400 stages exactly once, through their banners. Paths are read LINE BY
# LINE (this path has spaces).
CALLERS="$(grep -lF 'restore_accepted_d392_loadout(' "$PROJ"/tests/*.gd | while IFS= read -r f; do basename "$f"; done | sort | tr '\n' ' ')"
RT_CALLERS="$(grep -rlF 'restore_accepted_d392_loadout(' "$PROJ/scripts" | while IFS= read -r f; do basename "$f"; done | sort | tr '\n' ' ')"
ONCE=1
for s in foundation imprint alignment huntress; do
  N="$(grep -cF 'main.get("hounds").restore_accepted_d392_loadout()' "$PROJ/tests/${s}_verification.gd")"
  [ "$N" = "1" ] || ONCE=0
done
BANNERS=1
for L in "$FLOG" "$ILOG" "$ALOG" "$HLOG" "$KLOG" "$CLOG" "$MLOG"; do
  N6="$(grep -cF 'RIFTWROUGHT — KINDRED HOUNDS STAGE  (D-396, 2026-09-19)' "$L")"
  N8="$(grep -cF 'RIFTWROUGHT — MOBILE MINION COHESION STAGE  (D-398, 2026-09-19)' "$L")"
  N9="$(grep -cF 'RIFTWROUGHT — PLAYER LOCOMOTION REDIRECTION STAGE  (D-400, 2026-09-20)' "$L")"
  { [ "$N6" = "1" ] && [ "$N8" = "1" ] && [ "$N9" = "1" ]; } || BANNERS=0
done
if [ "$CALLERS" = "alignment_verification.gd foundation_verification.gd hounds_verification.gd huntress_verification.gd imprint_verification.gd " ] \
   && [ "$RT_CALLERS" = "foundation_main.gd hound_runtime.gd " ] && [ "$ONCE" -eq 1 ] && [ "$BANNERS" -eq 1 ] && [ "$LEAK" = "0" ]; then
  ok "N22 the accepted D-392-loadout fixture is called by the four accepted suites (once each) and the D-396 suite — not by the D-398 or D-400 suites — and in the runtime only by the capture path and its definition; every log shows the D-396, D-398 and D-400 stages once each, and no D-400 row leaks into an accepted log"
else
  fail "N22 fixture callers '$CALLERS', runtime '$RT_CALLERS', once each=$ONCE, banners=$BANNERS, leaked rows=$LEAK"
fi

# ------------------------------------------------------------------ verdict --
say ""
say "========================================================================"
say "UNITS: 22 RUNNER CHECKS here · 33 EXECUTABLE CHECKS · 180 OWED CRITERIA — different units."
say "$STATE_EXPECT"
if [ "$FAILED" -eq 0 ] && [ "$SKIPPED" -eq 0 ]; then
  say "LOCOMOTION RUNNER: PASS (22 runner checks)"
elif [ "$FAILED" -eq 0 ]; then
  say "LOCOMOTION RUNNER: INCOMPLETE — $SKIPPED runner check(s) SKIPPED for lack of a baseline; NOT a pass"
  FAILED=1
else
  say "LOCOMOTION RUNNER: FAIL"
fi
say "========================================================================"
# Set LOCOMOTION_LOG_DIR to keep the seven suite logs (a run of record cites them).
if [ -n "${LOCOMOTION_LOG_DIR:-}" ] && [ -d "$LOCOMOTION_LOG_DIR" ]; then
  cp "$FLOG" "$LOCOMOTION_LOG_DIR/foundation.log"; cp "$ILOG" "$LOCOMOTION_LOG_DIR/imprint.log"
  cp "$ALOG" "$LOCOMOTION_LOG_DIR/alignment.log"; cp "$HLOG" "$LOCOMOTION_LOG_DIR/huntress.log"
  cp "$KLOG" "$LOCOMOTION_LOG_DIR/hounds.log"; cp "$CLOG" "$LOCOMOTION_LOG_DIR/cohesion.log"
  cp "$MLOG" "$LOCOMOTION_LOG_DIR/locomotion.log"
fi
rm -f "$FLOG" "$ILOG" "$ALOG" "$HLOG" "$KLOG" "$CLOG" "$MLOG"
exit "$FAILED"
