#!/usr/bin/env bash
# =============================================================================
# RIFTWROUGHT — THE PLAYER DIRECT-CLICK MOVEMENT CORRECTION STAGE RUNNER  (D-404, 2026-09-28)
# =============================================================================
#
# Runs ALL NINE game3d/ suites headless against the final code: the ACCEPTED
# D-373 foundation, D-376 Imprint, D-383 alignment, D-394 Splinter Shot, D-397
# Kindred Hounds, D-399 mobile minion cohesion, D-401 player locomotion
# redirection and D-403 Cinder Field suites as REGRESSIONS, then this stage's
# own suite. It checks their summaries, owed lists, printed rows, the state line,
# truthfulness -- including EVERY accepted runner's own forbidden-claim and
# self-acceptance patterns, applied to all nine logs -- the isolation of every
# protected tree, the D-404 change set inside game3d/, the asset guards, the
# input map, the units and the rendered evidence.
#
#   tests/direct_click_smoke.sh                  headless only (the default)
#   tests/direct_click_smoke.sh --with-evidence  also RENDERS frames 55-60 first,
#                                                each under a hard 120 s ceiling
#
# Set FOUNDATION_BASELINE_DIR to a directory of pre-work SHA-256 listings
# (baseline_<tree>.sha256, baseline_archives.sha256) to run U15, and
# D404_BASELINE_GAME3D to the PRE-D-404 listing of game3d/ to run U16 and U17.
# Without them they print [SKIP], are NOT counted as passes, and the run is
# INCOMPLETE.
#
# =============================================================================
# UNITS. THIRTY COUNTS, AND NONE IS A SYNONYM FOR ANOTHER.
#
#   D-404: 24 RUNNER CHECKS here (U01-U24) · 32 EXECUTABLE CHECKS in
#          tests/direct_click_verification.gd · 124 OWED CRITERIA in
#          docs/testing/D404_DIRECT_CLICK_MOVEMENT_OWED_CRITERIA_INVENTORY.md
#   D-402: 24 RUNNER CHECKS · 48 EXECUTABLE CHECKS · 185 OWED CRITERIA
#   D-400: 22 RUNNER CHECKS · 33 EXECUTABLE CHECKS · 180 OWED CRITERIA
#   D-398: 22 RUNNER CHECKS · 40 EXECUTABLE CHECKS · 201 OWED CRITERIA
#   D-396: 21 RUNNER CHECKS · 45 EXECUTABLE CHECKS · 202 OWED CRITERIA
#   D-392: 21 RUNNER CHECKS · 53 EXECUTABLE CHECKS · 203 OWED CRITERIA
#   D-380: 21 RUNNER CHECKS · 40 EXECUTABLE CHECKS · 162 OWED CRITERIA
#   D-375: 26 RUNNER CHECKS · 101 EXECUTABLE CHECKS · 149 OWED CRITERIA
#   D-370: 20 RUNNER CHECKS · 85 EXECUTABLE CHECKS · 125 OWED CRITERIA
# =============================================================================
#
# THIS RUNNER VERIFIES A STAGE DELIVERED OPEN. It accepts nothing. It is not P2,
# not movement-speed tuning, not a control-scheme change and not a UI
# foundation, and it locks no number.
# =============================================================================
set -uo pipefail

GODOT="${GODOT:-/Applications/Godot.app/Contents/MacOS/Godot}"
HERE="$(cd "$(dirname "$0")" && pwd)"
PROJ="$(cd "$HERE/.." && pwd)"
ROOT="$(cd "$PROJ/.." && pwd)"
FLOG="$(mktemp -t click_foundation)"
ILOG="$(mktemp -t click_imprint)"
ALOG="$(mktemp -t click_alignment)"
HLOG="$(mktemp -t click_huntress)"
KLOG="$(mktemp -t click_hounds)"
CLOG="$(mktemp -t click_cohesion)"
MLOG="$(mktemp -t click_locomotion)"
ELOG="$(mktemp -t click_cinder)"
DLOG="$(mktemp -t click_stage)"
FAILED=0
SKIPPED=0
WITH_EVIDENCE=0
[ "${1:-}" = "--with-evidence" ] && WITH_EVIDENCE=1

# THE ONE STATE LINE, identical in all nine runners (U14 compares them).
STATE_EXPECT="STATE: FOUNDATION STAGE ACCEPTED and CLOSED (D-373) · IMPRINT STAGE ACCEPTED and CLOSED (D-376) · D-378 ALIGNMENT STAGE ACCEPTED and CLOSED (D-383) · HUNTRESS SPLINTER SHOT STAGE ACCEPTED and CLOSED (D-394) · KINDRED HOUNDS STAGE ACCEPTED and CLOSED (D-397) · MOBILE MINION COHESION STAGE ACCEPTED and CLOSED (D-399) · PLAYER LOCOMOTION REDIRECTION STAGE ACCEPTED and CLOSED (D-401) · CINDER FIELD STAGE ACCEPTED and CLOSED (D-403) · PLAYER DIRECT-CLICK MOVEMENT CORRECTION STAGE DELIVERED and OPEN pending owner live review (D-404)"
STATE_D375_LINE="STATE: FOUNDATION STAGE ACCEPTED and CLOSED (D-373) · IMPRINT STAGE DELIVERED and OPEN pending owner live review (D-375)"
STATE_D380_LINE="STATE: FOUNDATION STAGE ACCEPTED and CLOSED (D-373) · IMPRINT STAGE ACCEPTED and CLOSED (D-376) · D-378 ALIGNMENT STAGE DELIVERED and OPEN pending owner live review (D-380)"
STATE_D392_LINE="STATE: FOUNDATION STAGE ACCEPTED and CLOSED (D-373) · IMPRINT STAGE ACCEPTED and CLOSED (D-376) · D-378 ALIGNMENT STAGE ACCEPTED and CLOSED (D-383) · HUNTRESS SPLINTER SHOT STAGE DELIVERED and OPEN pending owner live review (D-392)"
STATE_D396_LINE="STATE: FOUNDATION STAGE ACCEPTED and CLOSED (D-373) · IMPRINT STAGE ACCEPTED and CLOSED (D-376) · D-378 ALIGNMENT STAGE ACCEPTED and CLOSED (D-383) · HUNTRESS SPLINTER SHOT STAGE ACCEPTED and CLOSED (D-394) · KINDRED HOUNDS STAGE DELIVERED and OPEN pending owner live review (D-396)"
STATE_D398_LINE="STATE: FOUNDATION STAGE ACCEPTED and CLOSED (D-373) · IMPRINT STAGE ACCEPTED and CLOSED (D-376) · D-378 ALIGNMENT STAGE ACCEPTED and CLOSED (D-383) · HUNTRESS SPLINTER SHOT STAGE ACCEPTED and CLOSED (D-394) · KINDRED HOUNDS STAGE ACCEPTED and CLOSED (D-397) · MOBILE MINION COHESION STAGE DELIVERED and OPEN pending owner live review (D-398)"
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
PIN_M_OWNER=0
PIN_M_DISCHARGED=4
# THE NEWLY ACCEPTED CINDER FIELD COUNTS, re-pinned by this stage's first act:
# D-403 answered FO-01..FO-07 with one overall acceptance. 7 - 7 = 0 owed;
# 0 + 7 = 7 discharged; 0 deleted. The check and deferred counts do not move.
PIN_E_CHECKS=48
PIN_E_DEFERRED=19
PIN_E_OWNER=0
PIN_E_DISCHARGED=7
# THIS STAGE'S OWN.
PIN_D_CHECKS=32
# 21 DD- rows were written before the work; DD-22 (the canon disagreement) was
# added during it: 21 + 1 = 22.
PIN_D_DEFERRED=22
PIN_D_OWNER=6

# THE DECLARED D-404 CHANGE SET INSIDE game3d/, against the PRE-D-404 listing
# (taken 2026-09-28 11:13) — pinned in BOTH directions by U16.
#
# `project.godot` is NOT in it: D-404 adds NO input action. The asset trees are
# NOT in it: D-404 adds no asset. `README.md` IS in it: D-403's closure and
# D-404's delivery both write status there.
DECLARED_MODIFIED="README.md
scripts/cinder/cinder_config.gd
scripts/control/player_controller.gd
scripts/core/prod_config.gd
scripts/foundation_main.gd
tests/alignment_smoke.sh
tests/alignment_verification.gd
tests/cinder_smoke.sh
tests/cinder_verification.gd
tests/cohesion_smoke.sh
tests/cohesion_verification.gd
tests/foundation_smoke.sh
tests/foundation_verification.gd
tests/hounds_smoke.sh
tests/hounds_verification.gd
tests/huntress_smoke.sh
tests/huntress_verification.gd
tests/imprint_smoke.sh
tests/imprint_verification.gd
tests/locomotion_smoke.sh
tests/locomotion_verification.gd"
D404_SCRIPTS="direct_click_config direct_click_gizmo direct_click_order direct_click_review_hud"
EV_FRAMES="55_d404_unobstructed 56_d404_behind_wall 57_d404_stopped_at_wall 58_d404_glancing 59_d404_manual_around 60_d404_extreme"
DECLARED_NEW="$(
  printf '%s\n' tests/direct_click_smoke.sh tests/direct_click_verification.gd tests/direct_click_verification.gd.uid
  for s in $D404_SCRIPTS; do printf 'scripts/click/%s.gd\nscripts/click/%s.gd.uid\n' "$s" "$s"; done
  for e in $EV_FRAMES; do printf 'evidence/%s.png\nevidence/%s.png.import\n' "$e" "$e"; done
)"
# The protected trees, each byte-identical to its pre-work listing (U15).
PROTECTED="game game2d game3d_spike game3d_boss_spike game3d_huntress_spike models"
# The 29 accepted input actions, in project order. D-404 ADDS NONE.
ACCEPTED_ACTIONS="move_command stick_left stick_right stick_up stick_down aim_left aim_right aim_up aim_down diagnostic_attack zoom_in zoom_out toggle_overlay imprint_binding_1 imprint_binding_2 imprint_binding_3 imprint_binding_4 imprint_binding_5 imprint_binding_6 imprint_binding_7 imprint_binding_8 imprint_panel imprint_panel_prev imprint_panel_next imprint_panel_activate diagnostic_reservation_cycle diagnostic_hound_fall diagnostic_stress_population diagnostic_travel_speed"
ALL_LOGS=("$FLOG" "$ILOG" "$ALOG" "$HLOG" "$KLOG" "$CLOG" "$MLOG" "$ELOG" "$DLOG")
ACCEPTED_LOGS=("$FLOG" "$ILOG" "$ALOG" "$HLOG" "$KLOG" "$CLOG" "$MLOG" "$ELOG")

say()  { printf '%s\n' "$*"; }
fail() { say "  [FAIL] $*"; FAILED=1; }
ok()   { say "  [ OK ] $*"; }
skip() { say "  [SKIP] $*"; SKIPPED=$((SKIPPED + 1)); }

say "========================================================================"
say "RIFTWROUGHT PLAYER DIRECT-CLICK MOVEMENT CORRECTION STAGE RUNNER (D-404)"
say "Headless by default. Rendered evidence is opt-in via --with-evidence."
say "It runs the ACCEPTED D-373, D-376, D-383, D-394, D-397, D-399, D-401 and D-403 suites as REGRESSIONS, then this stage."
say "DELIVERED and OPEN pending owner live review. It accepts nothing."
say "========================================================================"

# The evidence as it stands BEFORE this run -- U20 proves a plain run leaves it alone.
EV_BEFORE="$(cd "$PROJ" && for e in $EV_FRAMES; do [ -f "evidence/$e.png" ] && shasum -a 256 "evidence/$e.png"; done)"

# --------------------------------------------- 0. opt-in evidence, rendered FIRST
EV_RESULT=""
CEILING=120
if [ "$WITH_EVIDENCE" -eq 1 ]; then
  say ""
  say "[0/9] Rendering this stage's six captures (55-60) FIRST (opt-in) — never 01-54"
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

# ------------------------------------------------------------ U01. import ----
say ""
say "[1/9] Import pass (U01)"
"$GODOT" --headless --path "$PROJ" --import >/dev/null 2>&1
IMPORTED="$(ls "$PROJ/.godot/imported" 2>/dev/null | wc -l | tr -d ' ')"
UIDS=0
for s in $D404_SCRIPTS; do [ -f "$PROJ/scripts/click/$s.gd.uid" ] && UIDS=$((UIDS + 1)); done
[ -f "$PROJ/tests/direct_click_verification.gd.uid" ] && UIDS=$((UIDS + 1))
if [ "$IMPORTED" -gt 0 ] && [ "$UIDS" = "5" ]; then
  ok "U01 assets imported ($IMPORTED entries); all four D-404 scripts and the D-404 suite carry their .uid — a fresh checkout verifies"
else
  fail "U01 the import pass produced $IMPORTED entries; D-404 uids $UIDS of 5"
fi

# ------------------------------------------------------ U02-U08. the suites --
say ""
say "[2/9] The nine suites: the eight ACCEPTED ones as REGRESSIONS, then D-404's own (U02-U08)"
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
"$GODOT" --headless --path "$PROJ" --script res://tests/cinder_verification.gd >"$ELOG" 2>&1
E_RC=$?
"$GODOT" --headless --path "$PROJ" --script res://tests/direct_click_verification.gd >"$DLOG" 2>&1
D_RC=$?
grep -E "^  \[(PASS|FAIL|UNREACHED) *\]" "$DLOG" | sed 's/^/    /' | head -40
grep -E "^(FOUNDATION|IMPRINT|ALIGNMENT|HUNTRESS|HOUNDS|COHESION|LOCOMOTION|CINDER|DIRECT CLICK) VERIFICATION:" \
  "${ALL_LOGS[@]}" | sed "s|^[^:]*:|    |"

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
four_summary() { # $1 prefix $2 checks $3 deferred $4 owed $5 discharged
  printf '%s VERIFICATION: PASS (%s checks: %s passed, 0 failed/unreached, %s deferred, %s owed to the owner, %s discharged)' "$1" "$2" "$2" "$3" "$4" "$5"
}
H_EXPECT="$(four_summary HUNTRESS $PIN_H_CHECKS $PIN_H_DEFERRED $PIN_H_OWNER $PIN_H_DISCHARGED)"
K_EXPECT="$(four_summary HOUNDS $PIN_K_CHECKS $PIN_K_DEFERRED $PIN_K_OWNER $PIN_K_DISCHARGED)"
C_EXPECT="$(four_summary COHESION $PIN_C_CHECKS $PIN_C_DEFERRED $PIN_C_OWNER $PIN_C_DISCHARGED)"
M_EXPECT="$(four_summary LOCOMOTION $PIN_M_CHECKS $PIN_M_DEFERRED $PIN_M_OWNER $PIN_M_DISCHARGED)"
E_EXPECT="$(four_summary CINDER $PIN_E_CHECKS $PIN_E_DEFERRED $PIN_E_OWNER $PIN_E_DISCHARGED)"
D_EXPECT="DIRECT CLICK VERIFICATION: PASS ($PIN_D_CHECKS checks: $PIN_D_CHECKS passed, 0 failed/unreached, $PIN_D_DEFERRED deferred, $PIN_D_OWNER owed to the owner)"
pin_summary U02 "$FLOG" FOUNDATION "$PIN_F_CHECKS" "$PIN_F_DEFERRED"
pin_summary U03 "$ILOG" IMPRINT "$PIN_I_CHECKS" "$PIN_I_DEFERRED"
pin_summary U04 "$ALOG" ALIGNMENT "$PIN_A_CHECKS" "$PIN_A_DEFERRED"
H_LINE="$(grep -E '^HUNTRESS VERIFICATION:' "$HLOG" | head -1)"
K_LINE="$(grep -E '^HOUNDS VERIFICATION:' "$KLOG" | head -1)"
C_LINE="$(grep -E '^COHESION VERIFICATION:' "$CLOG" | head -1)"
M_LINE="$(grep -E '^LOCOMOTION VERIFICATION:' "$MLOG" | head -1)"
E_LINE="$(grep -E '^CINDER VERIFICATION:' "$ELOG" | head -1)"
D_LINE="$(grep -E '^DIRECT CLICK VERIFICATION:' "$DLOG" | head -1)"
if [ "$H_LINE" = "$H_EXPECT" ] && [ "$K_LINE" = "$K_EXPECT" ] && [ "$C_LINE" = "$C_EXPECT" ] && [ "$M_LINE" = "$M_EXPECT" ]; then
  ok "U05 the four ACCEPTED summaries carrying owed/discharged counts match EXACTLY: Splinter Shot ($PIN_H_CHECKS/$PIN_H_DEFERRED/$PIN_H_OWNER/$PIN_H_DISCHARGED), Kindred Hounds ($PIN_K_CHECKS/$PIN_K_DEFERRED/$PIN_K_OWNER/$PIN_K_DISCHARGED), cohesion ($PIN_C_CHECKS/$PIN_C_DEFERRED/$PIN_C_OWNER/$PIN_C_DISCHARGED) and locomotion ($PIN_M_CHECKS/$PIN_M_DEFERRED/$PIN_M_OWNER/$PIN_M_DISCHARGED)"
else
  fail "U05 a summary MISMATCH"
  for pair in "$H_EXPECT|$H_LINE" "$K_EXPECT|$K_LINE" "$C_EXPECT|$C_LINE" "$M_EXPECT|$M_LINE"; do
    say "        expected: ${pair%%|*}"; say "        actual  : ${pair#*|}"
  done
fi
if [ "$E_LINE" = "$E_EXPECT" ] && [ "$D_LINE" = "$D_EXPECT" ]; then
  ok "U06 the ACCEPTED Cinder Field summary matches EXACTLY ($PIN_E_CHECKS checks, $PIN_E_DEFERRED deferred, $PIN_E_OWNER owed, $PIN_E_DISCHARGED discharged — re-pinned under D-404's first act), and THIS stage's matches EXACTLY: $PIN_D_CHECKS executable checks, $PIN_D_DEFERRED deferred rows, $PIN_D_OWNER owed to the owner"
else
  fail "U06 a summary MISMATCH"; say "        expected: $E_EXPECT"; say "        actual  : $E_LINE"
  say "        expected: $D_EXPECT"; say "        actual  : $D_LINE"
fi
OWED_OK=1
for spec in "$FLOG:$PIN_F_CHECKS:F" "$ILOG:$PIN_I_CHECKS:I" "$ALOG:$PIN_A_CHECKS:A" "$HLOG:$PIN_H_CHECKS:H" \
            "$KLOG:$PIN_K_CHECKS:B" "$CLOG:$PIN_C_CHECKS:C" "$MLOG:$PIN_M_CHECKS:L" "$ELOG:$PIN_E_CHECKS:E" \
            "$DLOG:$PIN_D_CHECKS:D"; do
  L="${spec%%:*}"; rest="${spec#*:}"; C="${rest%%:*}"; P="${rest#*:}"
  LINE="$(grep -E '^  owed=' "$L" | head -1 | sed 's/^ *//')"
  EXPECT="owed=$C  reached=$C  owed-but-not-reached=0 []  reached-but-not-owed=0 []"
  NAMES="$(grep -cE "^  \[PASS     \] $P[0-9]+_" "$L")"
  if [ "$LINE" != "$EXPECT" ] || [ "$NAMES" != "$C" ]; then
    OWED_OK=0; say "        $(basename "$L"): '$LINE' ($NAMES $P-names)"
  fi
done
if [ "$OWED_OK" -eq 1 ]; then
  ok "U07 owed vs reached matches in BOTH directions in all nine logs, and every F-, I-, A-, H-, B-, C-, L-, E- and D-numbered check passed"
else
  fail "U07 owed/reached or name counts MISMATCH"
fi
RC_OK=1
for rc in "$F_RC" "$I_RC" "$A_RC" "$H_RC" "$K_RC" "$C_RC" "$M_RC" "$E_RC" "$D_RC"; do [ "$rc" -ne 0 ] && RC_OK=0; done
if [ "$RC_OK" -eq 1 ]; then
  ok "U08 all nine suites exited 0 (and U11 separately refuses a parse error, which EXITS 0)"
else
  fail "U08 a suite exited non-zero (F $F_RC, I $I_RC, A $A_RC, H $H_RC, B $K_RC, C $C_RC, L $M_RC, E $E_RC, D $D_RC)"
fi

# ----------------------------------------------- U09. pins able to refuse ----
say ""
say "[3/9] Every summary pin PROVED able to refuse an altered value (U09)"
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
refuse_three "$M_LINE" "$M_EXPECT" "$PIN_M_CHECKS" deferred "$PIN_M_DEFERRED" discharged "$PIN_M_DISCHARGED" && REFUSED=$((REFUSED + 1))
refuse_three "$E_LINE" "$E_EXPECT" "$PIN_E_CHECKS" deferred "$PIN_E_DEFERRED" discharged "$PIN_E_DISCHARGED" && REFUSED=$((REFUSED + 1))
refuse_three "$D_LINE" "$D_EXPECT" "$PIN_D_CHECKS" deferred "$PIN_D_DEFERRED" owed "$PIN_D_OWNER" && REFUSED=$((REFUSED + 1))
if [ "$REFUSED" = "9" ]; then
  ok "U09 all nine summary pins REFUSE an altered check count AND an altered row count (the five carrying a discharged count also an altered discharged count; this stage's an altered OWED count) — replayed"
else
  fail "U09 only $REFUSED of 9 summary pins were proved able to refuse an altered value"
fi

# -------------------------------------------------- U10. printed rows ----
say ""
say "[4/9] Deferred, owed and discharged rows (U10)"
DD_ROWS="$(grep -cE '^  \[[^]]+\] DD-(0[1-9]|1[0-9]|2[0-2]) ' "$DLOG")"
DD22="$(grep -cE '^  \[DECLARED — NOT REPAIRED *\] DD-22 CANON DISAGREES' "$DLOG")"
DO_ROWS="$(grep -cE '^  \[OWED-TO-OWNER\] DO-0[1-6] ' "$DLOG")"
D_PASSROW="$(grep -cE '^  \[(PASS|OK) *\] D[DO]-' "$DLOG")"
DD03="$(grep -cE '^  \[CARRIED — NOT REPAIRED *\] DD-03 ' "$DLOG")"
DD04="$(grep -cE '^  \[CARRIED — NOT REPAIRED *\] DD-04 ' "$DLOG")"
DD08="$(grep -cE '^  \[CARRIED — PROVISIONAL FINDING *\] DD-08 ' "$DLOG")"
# THE ACCEPTED CINDER FIELD ROWS, reconciled by this stage's first act.
FO_OWED="$(grep -cE '^  \[OWED-TO-OWNER\] FO-0[1-7] ' "$ELOG")"
FO_DIS="$(grep -cE '^  \[DISCHARGED — D-403\] FO-0[1-7] ' "$ELOG")"
FO_KEPT="$(grep -cF "ORIGINAL ROW TEXT, PRESERVED VERBATIM (OWED-TO-OWNER): '" "$ELOG")"
FD15="$(grep -cE '^  \[DECLARED — NOT REPAIRED *\] FD-15 ' "$ELOG")"
LO_DIS="$(grep -cE '^  \[DISCHARGED — D-401\] LO-0[1-4] ' "$MLOG")"
# NO D-404 ROW LEAKS INTO AN ACCEPTED LOG.
LEAK="$(grep -cE '^  \[OWED-TO-OWNER\] DO-|^  \[[^]]+\] DD-[0-9]+ |^DIRECT CLICK VERIFICATION' "${ACCEPTED_LOGS[@]}" | awk -F: '{s+=$2} END{print s+0}')"
if [ "$DD_ROWS" = "$PIN_D_DEFERRED" ] && [ "$DO_ROWS" = "$PIN_D_OWNER" ] && [ "$D_PASSROW" = "0" ] \
   && [ "$DD03" = "1" ] && [ "$DD04" = "1" ] && [ "$DD08" = "1" ] && [ "$DD22" = "1" ] \
   && [ "$FO_OWED" = "0" ] && [ "$FO_DIS" = "$PIN_E_DISCHARGED" ] && [ "$FO_KEPT" -ge "$PIN_E_DISCHARGED" ] \
   && [ "$FD15" = "1" ] && [ "$LO_DIS" = "$PIN_M_DISCHARGED" ] && [ "$LEAK" = "0" ]; then
  ok "U10 the D-404 run prints DD-01..DD-22 ($DD_ROWS), DD-22 declaring the canon disagreement, and DO-01..DO-06 OWED-TO-OWNER ($DO_ROWS), none as a pass; the two D-403 findings print as DD-03 and DD-04 CARRIED — NOT REPAIRED, and LD-02 as DD-08 CARRIED — PROVISIONAL FINDING | the D-402 run prints FO-01..FO-07 DISCHARGED — D-403 ($FO_DIS), original text kept ($FO_KEPT), NONE owed, and FD-15 still DECLARED — NOT REPAIRED | the D-400 run still prints LO-01..LO-04 DISCHARGED — D-401 | no D-404 row leaks into an accepted log"
else
  fail "U10 rows: DD $DD_ROWS, DD-22 $DD22, DO $DO_ROWS, as pass $D_PASSROW, DD-03 $DD03, DD-04 $DD04, DD-08 $DD08, FO owed $FO_OWED, FO discharged $FO_DIS, FO kept $FO_KEPT, FD-15 $FD15, LO discharged $LO_DIS, leaked $LEAK"
fi

# ---------------------------------------------------- U11. engine errors ----
say ""
say "[5/9] Engine-error guard (U11)"
ERRPAT='^(SCRIPT )?ERROR:|^USER ERROR:|^SCRIPT ERROR|Parse Error|Failed to load script'
SELF='Foundation_Signature_Move_THIS_DOES_NOT_EXIST'
SELF_N="$(grep -cF "$SELF" "$FLOG")"
F_REAL="$(grep -E "$ERRPAT" "$FLOG" | grep -vF "$SELF" || true)"
OTHER_REAL="$(grep -E "$ERRPAT" "$ILOG" "$ALOG" "$HLOG" "$KLOG" "$CLOG" "$MLOG" "$ELOG" "$DLOG" || true)"
PLANT="$(mktemp -t click_plant)"; cat "$DLOG" > "$PLANT"
printf 'SCRIPT ERROR: Parse Error: planted, for guard proving only\n' >> "$PLANT"
if [ "$SELF_N" -lt 1 ]; then
  fail "U11 the accepted suite's guard-proving error line is missing — F12's proof is not intact"
elif [ -n "$F_REAL" ] || [ -n "$OTHER_REAL" ]; then
  fail "U11 engine errors present:"
  printf '%s\n' "$F_REAL" "$OTHER_REAL" | grep -v '^$' | head -12 | sed 's/^/        /'
elif ! grep -qE "$ERRPAT" "$PLANT"; then
  fail "U11 the error guard could NOT detect a planted error line"
else
  ok "U11 no engine error in any of the nine logs beyond the one expected guard proof, and the guard refuses a planted parse error (a parse error EXITS 0 — this D-404 work met exactly that on its first regression run — so this guard, not the exit code, is what catches it)"
fi
rm -f "$PLANT"

# ------------------------------------ U12-U14. state line and truthfulness --
say ""
say "[6/9] The state line and truthfulness (U12-U14)"
BAD_STATE=0
for L in "${ALL_LOGS[@]}"; do
  N_STATE="$(grep -cE '^STATE: ' "$L")"
  N_EXACT="$(grep -cxF "$STATE_EXPECT" "$L")"
  if [ "$N_STATE" -lt 1 ] || [ "$N_STATE" != "$N_EXACT" ]; then
    BAD_STATE=1; say "        in $(basename "$L"): $N_EXACT of $N_STATE state lines exact"
  fi
done
SUPERSEDED=0
for S in "$STATE_D375_LINE" "$STATE_D380_LINE" "$STATE_D392_LINE" "$STATE_D396_LINE" "$STATE_D398_LINE" "$STATE_D400_LINE" "$STATE_D402_LINE" "STATE: DELIVERED and OPEN pending owner live review"; do
  grep -qxF "$S" "${ALL_LOGS[@]}" && SUPERSEDED=1
done
# THE STAGE NEVER ACCEPTS ITSELF, and no earlier stage is made to accept itself:
# "CINDER FIELD STAGE ACCEPTED and CLOSED (D-403)" is the OWNER's fact and sits
# in the state line; the Cinder Field stage accepting ITSELF (D-402) is false.
SELF_ACCEPT='PLAYER DIRECT-CLICK MOVEMENT CORRECTION STAGE ACCEPTED|D-404 (is|stage is) ACCEPTED|ACCEPTED and CLOSED \(D-404\)|ACCEPTED and CLOSED \(D-402\)|ACCEPTED and CLOSED \(D-400\)|ACCEPTED and CLOSED \(D-398\)|ACCEPTED and CLOSED \(D-396\)|ACCEPTED and CLOSED \(D-392\)'
ACCEPTS="$(grep -hE "$SELF_ACCEPT" "${ALL_LOGS[@]}" | grep -v 'SELF_ACCEPT' | head -3 || true)"
PLANT3="$(mktemp -t click_plant3)"; printf 'PLAYER DIRECT-CLICK MOVEMENT CORRECTION STAGE ACCEPTED and CLOSED (D-404)\n' > "$PLANT3"
ALT_STATE="$(printf '%s' "$STATE_EXPECT" | sed 's/DELIVERED and OPEN pending owner live review (D-404)/ACCEPTED and CLOSED (D-404)/')"
if [ "$BAD_STATE" -eq 0 ] && [ "$SUPERSEDED" -eq 0 ] && [ -z "$ACCEPTS" ] && grep -qE "$SELF_ACCEPT" "$PLANT3" \
   && [ "$ALT_STATE" != "$STATE_EXPECT" ] && [ "$STATE_D402_LINE" != "$STATE_EXPECT" ]; then
  ok "U12 every STATE line in all nine logs is the SAME exact nine-fact line; no superseded line (D-375, D-380, D-392, D-396, D-398, D-400, D-402, bare D-370) is printed; nothing claims the open D-404 stage accepted or an earlier stage accepting itself — and each scan refuses a planted line"
else
  fail "U12 a state line differs ($BAD_STATE), a superseded line is printed ($SUPERSEDED), or a self-acceptance appears: $ACCEPTS"
fi
rm -f "$PLANT3"
U13_MISS=""
for s in "The D-404 stage IS NOT P2 and AUTHORIZES NO P2." \
         "changes ONLY how a MOUSE click order moves the player" \
         "does NOT change controller-stick movement" \
         "does NOT change enemy, Kindred Hound or mobile-minion navigation" \
         "does NOT change the navigation mesh, collision shapes, layers, masks" \
         "does NOT change Cinder Field's placement rules" \
         "is NOT movement-speed tuning" \
         "does NOT scale, replace or clear the ACTION brake" \
         "does NOT change the accepted independent movement-and-aim behaviour" \
         "adds NO input action: the project's 29 accepted actions stay 29" \
         "adds NO automatic routing, NO shift-click routing and NO path-to-click option" \
         "LOCKS NO NUMBER" \
         "The D-404 stage delivers OPEN pending owner live review; it does NOT accept itself." \
         "[OWED-TO-OWNER] DO-01 Does clicking behind an obstacle now stop the player where expected?" \
         "[OWED-TO-OWNER] DO-06 Does it remain stable at FAST and EXTREME speeds?"; do
  grep -qF "$s" "$DLOG" || U13_MISS="$U13_MISS | $s"
done
for s in "The D-402 stage was delivered OPEN and never accepted itself: the owner ACCEPTED and CLOSED it under D-403" \
         "[DISCHARGED — D-403] FO-01 Does placement feel responsive and accurate while using click-to-move?" \
         "THE OWNER'S D-403 LIVE REVIEW: ANSWERED AS ONE OVERALL ACCEPTANCE — \"Looks and feels good.\""; do
  grep -qF "$s" "$ELOG" || U13_MISS="$U13_MISS | (D-402 log) $s"
done
FORBID='P2 is authorized|P1 is complete|the top speed is (locked|changed)|3\.889 is locked|routing is (restored|reintroduced)|the stick (is|was) changed|WASD is (added|bound)|a new input action is added|the contact hold is locked|production ready|pivot complete|the HUD is a UI foundation'
PLANT2="$(mktemp -t click_plant2)"; printf 'routing is restored\n' > "$PLANT2"
# AND EVERY ACCEPTED RUNNER'S OWN PATTERNS, over ALL NINE logs: this stage's
# banner lands in every accepted suite's log, so a phrase any accepted runner
# forbids would turn THAT runner red. Read from the runners themselves.
# EACH IS APPLIED EXACTLY AS ITS OWN RUNNER APPLIES IT: a FORBID pattern
# case-INsensitively (`grep -qiE`), a SELF_ACCEPT pattern case-sensitively
# (`grep -hE`), and each over all nine logs rather than only its own.
FOREIGN=""
for r in foundation_smoke.sh imprint_smoke.sh alignment_smoke.sh huntress_smoke.sh hounds_smoke.sh cohesion_smoke.sh locomotion_smoke.sh cinder_smoke.sh; do
  while IFS= read -r line; do
    kind="${line%%=*}"
    pat="${line#*=}"; pat="${pat#\'}"; pat="${pat%\'}"
    [ -z "$pat" ] && continue
    if [ "$kind" = "FORBID" ]; then
      grep -qiE "$pat" "${ALL_LOGS[@]}" && FOREIGN="$FOREIGN | $r FORBID"
    else
      grep -hE "$pat" "${ALL_LOGS[@]}" | grep -qv 'SELF_ACCEPT' && FOREIGN="$FOREIGN | $r SELF_ACCEPT"
    fi
  done < <(grep -hE "^(FORBID|SELF_ACCEPT)='" "$PROJ/tests/$r")
done
N_FOREIGN="$(grep -hcE "^(FORBID|SELF_ACCEPT)='" "$PROJ"/tests/foundation_smoke.sh "$PROJ"/tests/imprint_smoke.sh "$PROJ"/tests/alignment_smoke.sh "$PROJ"/tests/huntress_smoke.sh "$PROJ"/tests/hounds_smoke.sh "$PROJ"/tests/cohesion_smoke.sh "$PROJ"/tests/locomotion_smoke.sh "$PROJ"/tests/cinder_smoke.sh | awk '{s+=$1} END{print s+0}')"
if [ -n "$U13_MISS" ]; then
  fail "U13 the run does NOT state:$U13_MISS"
elif grep -qiE "$FORBID" "${ALL_LOGS[@]}"; then
  fail "U13 a run log makes a forbidden lock or completion claim:"
  grep -hiE "$FORBID" "${ALL_LOGS[@]}" | head -3 | sed 's/^/        /'
elif ! grep -qiE "$FORBID" "$PLANT2"; then
  fail "U13 the forbidden-claim scan cannot see a planted claim"
elif [ -n "$FOREIGN" ]; then
  fail "U13 an ACCEPTED runner's own pattern matches a log line:$FOREIGN"
elif [ "$N_FOREIGN" -lt 10 ]; then
  fail "U13 only $N_FOREIGN accepted-runner patterns were found to apply — the cross-check did not run"
else
  ok "U13 the D-404 run states its fifteen truthfulness strings (thirteen denials and the first and last owner questions), the D-402 run its three reconciled strings (the dated self-denial, FO-01 DISCHARGED — D-403, and the owner's verbatim answer), no log makes a forbidden claim, the scan refuses a planted one, and NONE of the $N_FOREIGN FORBID / SELF_ACCEPT patterns the eight accepted runners carry matches any of the nine logs"
fi
rm -f "$PLANT2"
NEEDLES_402=0
LINES_SAME=1
for r in foundation_smoke.sh imprint_smoke.sh alignment_smoke.sh huntress_smoke.sh hounds_smoke.sh cohesion_smoke.sh locomotion_smoke.sh cinder_smoke.sh direct_click_smoke.sh; do
  L_R="$(grep -E '^STATE_EXPECT=' "$PROJ/tests/$r" | head -1)"
  [ "$L_R" = "STATE_EXPECT=\"$STATE_EXPECT\"" ] || { LINES_SAME=0; say "        $r pins a different state line"; }
  grep -qxF "STATE_D402_LINE=\"$STATE_D402_LINE\"" "$PROJ/tests/$r" && [ "$(grep -c 'STATE_D402_LINE' "$PROJ/tests/$r")" -ge 2 ] \
    && NEEDLES_402=$((NEEDLES_402 + 1))
done
CNT_OK=1
for r in cinder_smoke.sh direct_click_smoke.sh; do
  for p in 'PIN_E_CHECKS=48' 'PIN_E_DEFERRED=19' 'PIN_E_OWNER=0' 'PIN_E_DISCHARGED=7' 'PIN_M_CHECKS=33' 'PIN_C_CHECKS=40' 'PIN_K_CHECKS=45' 'PIN_H_CHECKS=53' 'PIN_A_CHECKS=40' 'PIN_I_CHECKS=101' 'PIN_F_CHECKS=85'; do
    grep -qx "$p" "$PROJ/tests/$r" || CNT_OK=0
  done
done
if [ "$LINES_SAME" -eq 1 ] && [ "$NEEDLES_402" = "9" ] && [ "$CNT_OK" -eq 1 ]; then
  ok "U14 the NINE runners pin the IDENTICAL nine-fact state line, each holds the D-402-era line as a USED superseded needle, and the Cinder Field runner and this one carry the same accepted counts (85, 101, 40, 53, 45, 40, 33, 48 with 0 owed and 7 discharged)"
else
  fail "U14 the runners disagree on the state line ($LINES_SAME), the D-402-era needle ($NEEDLES_402 of 9), or a carried count ($CNT_OK)"
fi

# ------------------------------------------------ U15-U19. isolation ----
say ""
say "[7/9] Isolation, the change set, the asset guards, the input map and the units (U15-U19)"
BASE="${FOUNDATION_BASELINE_DIR:-}"
U15_OK=1; U15_RAN=0; N_ARCH=0
for d in $PROTECTED; do
  f="$BASE/baseline_$d.sha256"
  if [ -n "$BASE" ] && [ -f "$f" ]; then
    U15_RAN=$((U15_RAN + 1))
    NOW="$(mktemp -t click_now)"
    ( cd "$ROOT" && find "$d" -type f -print0 | sort -z | xargs -0 shasum -a 256 ) > "$NOW"
    if ! diff -q "$f" "$NOW" >/dev/null; then
      U15_OK=0; say "        $d/ CHANGED"
      diff "$f" "$NOW" | grep -E '^[<>]' | head -6 | sed 's/^/          /'
    fi
    rm -f "$NOW"
  fi
done
if [ -n "$BASE" ] && [ -f "$BASE/baseline_archives.sha256" ]; then
  U15_RAN=$((U15_RAN + 1))
  NOW="$(mktemp -t click_now)"
  ( cd "$ROOT" && sed -E 's/^[0-9a-f]+  //' "$BASE/baseline_archives.sha256" | while IFS= read -r p; do
      shasum -a 256 "$p"; done ) | sort -k2 > "$NOW"
  N_ARCH="$(wc -l < "$NOW" | tr -d ' ')"
  diff -q "$BASE/baseline_archives.sha256" "$NOW" >/dev/null || { U15_OK=0; say "        an archive under assets/ CHANGED"; }
  rm -f "$NOW"
fi
if [ "$U15_RAN" -eq 7 ] && [ "$U15_OK" -eq 1 ]; then
  ok "U15 game/, game2d/, game3d_spike/, game3d_boss_spike/, game3d_huntress_spike/, models/ and all $N_ARCH archives under assets/ are byte-identical to the pre-work baseline"
elif [ "$U15_RAN" -eq 0 ]; then
  skip "U15 baselines not supplied (set FOUNDATION_BASELINE_DIR) — NOT a pass"
else
  fail "U15 a protected tree or archive changed, or a baseline is missing ($U15_RAN of 7 measured)"
fi
G3="${D404_BASELINE_GAME3D:-}"
if [ -n "$G3" ] && [ -f "$G3" ]; then
  NOW="$(mktemp -t click_now)"
  ( cd "$ROOT" && find game3d -type f -not -path 'game3d/.godot/*' -not -name '.DS_Store' -print0 | sort -z \
    | xargs -0 shasum -a 256 ) > "$NOW"
  BASE_G3="$(mktemp -t click_base)"
  grep -v '/\.DS_Store$' "$G3" > "$BASE_G3"
  B_PATHS="$(sed -E 's/^[0-9a-f]+  //' "$BASE_G3" | sort)"
  N_PATHS="$(sed -E 's/^[0-9a-f]+  //' "$NOW" | sort)"
  CHANGED="$(diff <(sort -k2 "$BASE_G3") <(sort -k2 "$NOW") | grep -E '^[<>]' \
             | sed -E 's/^[<>] [0-9a-f]+  //' | sort -u)"
  ADDED="$(comm -13 <(printf '%s\n' "$B_PATHS") <(printf '%s\n' "$N_PATHS"))"
  REMOVED="$(comm -23 <(printf '%s\n' "$B_PATHS") <(printf '%s\n' "$N_PATHS"))"
  MODIFIED="$(comm -12 <(printf '%s\n' "$CHANGED") <(printf '%s\n' "$B_PATHS") | comm -12 - <(printf '%s\n' "$N_PATHS"))"
  EXP_MOD="$(printf '%s\n' "$DECLARED_MODIFIED" | sed 's|^|game3d/|' | sort)"
  EXP_NEW="$(printf '%s\n' "$DECLARED_NEW" | sed 's|^|game3d/|' | sort)"
  PLANTED_SET="$(printf '%s\ngame3d/project.godot\n' "$MODIFIED" | sort -u)"
  if [ -z "$REMOVED" ] && [ "$MODIFIED" = "$EXP_MOD" ] && [ "$ADDED" = "$EXP_NEW" ] && [ "$PLANTED_SET" != "$EXP_MOD" ]; then
    ok "U16 inside game3d/: exactly the $(printf '%s\n' "$EXP_MOD" | wc -l | tr -d ' ') declared files changed and the $(printf '%s\n' "$EXP_NEW" | wc -l | tr -d ' ') declared files are new — EVERY other authored file is byte-identical (project.godot, the enemy, hound, cohort, navigation, locomotion, Huntress, Imprint and Cinder Field runtime code, scenes, the asset trees, evidence 01-54); a planted undeclared change is refused. (Finder's .DS_Store is not authored content and is excluded from both sides.)"
  else
    fail "U16 the game3d/ change set differs from the declared set"
    say "        undeclared/missing modifications:"; diff <(printf '%s\n' "$MODIFIED") <(printf '%s\n' "$EXP_MOD") | grep -E '^[<>]' | head -8 | sed 's/^/          /'
    say "        undeclared/missing additions:";    diff <(printf '%s\n' "$ADDED") <(printf '%s\n' "$EXP_NEW") | grep -E '^[<>]' | head -8 | sed 's/^/          /'
    [ -n "$REMOVED" ] && { say "        removed:"; printf '%s\n' "$REMOVED" | head -5 | sed 's/^/          /'; }
  fi
  rm -f "$NOW" "$BASE_G3"
else
  skip "U16 the pre-D-404 game3d/ listing not supplied (set D404_BASELINE_GAME3D) — NOT a pass"
fi
# U17 — NO NEW ASSET, NO ART, NO VFX, NO AUDIO, NO .pxo, the four trees.
PXO="$(find "$PROJ" -name '*.pxo' 2>/dev/null | head -1)"
TREES="$(find "$ROOT" -type d -name 'quaternius' 2>/dev/null | sed "s|^$ROOT/||" | sort | tr '\n' ' ')"
EXPECT_TREES="game/assets/third_party/quaternius game3d/assets/third_party/quaternius game3d_boss_spike/assets/third_party/quaternius game3d_spike/assets/third_party/quaternius "
AUDIO="$(find "$PROJ" \( -name '*.wav' -o -name '*.ogg' -o -name '*.mp3' -o -name '*.flac' \) 2>/dev/null | head -1)"
CLICK_ASSET="$(grep -lE 'res://assets|AssetManifest' "$PROJ"/scripts/click/*.gd 2>/dev/null | head -1)"
ASSET_FILES_BEFORE="$( [ -n "${D404_BASELINE_GAME3D:-}" ] && [ -f "$D404_BASELINE_GAME3D" ] \
  && sed -E 's/^[0-9a-f]+  game3d\///' "$D404_BASELINE_GAME3D" | grep -c '^assets/' )"
ASSET_FILES_NOW="$(cd "$PROJ" && find assets -type f | wc -l | tr -d ' ')"
if [ -z "${ASSET_FILES_BEFORE:-}" ]; then
  skip "U17 the pre-D-404 game3d/ listing not supplied (set D404_BASELINE_GAME3D) — the asset count cannot be compared; NOT a pass"
elif [ -z "$PXO" ] && [ "$TREES" = "$EXPECT_TREES" ] && [ -z "$AUDIO" ] && [ -z "$CLICK_ASSET" ] \
   && [ "$ASSET_FILES_NOW" = "$ASSET_FILES_BEFORE" ]; then
  ok "U17 no .pxo and no audio in game3d/; no D-404 script reaches an asset at all; the asset tree is UNCHANGED ($ASSET_FILES_BEFORE = $ASSET_FILES_NOW files) — D-404 adds no asset, art or VFX; exactly the four quaternius trees in the repository"
else
  fail "U17 pxo='$PXO' trees='$TREES' audio='$AUDIO' click-asset='$CLICK_ASSET' assets $ASSET_FILES_BEFORE -> $ASSET_FILES_NOW (want unchanged)"
fi
# U18 — THE INPUT MAP IS UNCHANGED: the 29 accepted actions, in order, and NO more.
ACT_LIST="$(grep -oE '^[a-z_][a-z_0-9]*=\{$' "$PROJ/project.godot" | tr -d '={' | tr '\n' ' ' | sed 's/ $//')"
WASD=0
for code in 87 65 83 68; do
  N="$(grep -cF "\"physical_keycode\":$code," "$PROJ/project.godot" || true)"
  [ "$N" != "0" ] && WASD=1
done
PLANT_LIST="$ACCEPTED_ACTIONS diagnostic_route_to_click"
MOUSE="$(awk '/^move_command=\{/{f=1} f{print} f&&/^}/{exit}' "$PROJ/project.godot" | grep -c 'InputEventMouseButton')"
if [ "$ACT_LIST" = "$ACCEPTED_ACTIONS" ] && [ "$WASD" -eq 0 ] && [ "$MOUSE" -ge 1 ] \
   && [ "$PLANT_LIST" != "$ACT_LIST" ]; then
  ok "U18 project.godot declares EXACTLY the 29 accepted actions, unchanged and in order — D-404 adds NONE; move_command is still bound to a mouse button; no W/A/S/D; a planted extra action is refused"
else
  fail "U18 actions '$ACT_LIST' | move_command mouse events $MOUSE | W/A/S/D=$WASD"
fi
# U19 — THE UNITS, stated where they are owed.
INV="$ROOT/docs/testing/D404_DIRECT_CLICK_MOVEMENT_OWED_CRITERIA_INVENTORY.md"
OWED_N="$(awk '/^const OWED := \[/{f=1; next} f&&/^\]/{exit} f' "$PROJ/tests/direct_click_verification.gd" | grep -cE '^\s*"D[0-9][0-9]_')"
RUNNER_N="$(grep -oE 'U[0-9][0-9]' "$0" | sort -u | wc -l | tr -d ' ')"
if [ -f "$INV" ] && grep -qF '**124**' "$INV" && grep -qF '**32**' "$INV" \
   && grep -qF '**24**' "$INV" && grep -qF '`D01`' "$INV" && grep -qF '`U01`' "$INV" \
   && [ "$OWED_N" = "32" ] && [ "$RUNNER_N" = "24" ] && grep -qF '24 RUNNER CHECKS in tests/direct_click_smoke.sh' "$DLOG"; then
  ok "U19 the inventory states 124 OWED CRITERIA, 32 EXECUTABLE CHECKS and 24 RUNNER CHECKS; the suite owes $OWED_N and this runner makes $RUNNER_N; the suite's log names all three — different units, none a synonym"
else
  fail "U19 units: inventory present=$([ -f "$INV" ] && echo yes || echo no), suite owes $OWED_N, runner makes $RUNNER_N"
fi

# ------------------------------------------- U20-U21. rendered evidence ----
say ""
say "[8/9] Rendered evidence is opt-in and bounded (U20) and exists (U21)"
EV_AFTER="$(cd "$PROJ" && for e in $EV_FRAMES; do [ -f "evidence/$e.png" ] && shasum -a 256 "evidence/$e.png"; done)"
CEIL_OK=0
grep -qE 'CAP_WAITED" -lt "\$CEILING"' "$0" && [ "$CEILING" -le 120 ] && CEIL_OK=1
REFUSE_OK=0
grep -qF 'refusing to save' "$PROJ/scripts/foundation_main.gd" && grep -qF 'func _d404_capture(' "$PROJ/scripts/foundation_main.gd" && REFUSE_OK=1
if [ "$WITH_EVIDENCE" -eq 0 ] && [ "$EV_BEFORE" = "$EV_AFTER" ] && [ "$CEIL_OK" -eq 1 ] && [ "$REFUSE_OK" -eq 1 ]; then
  ok "U20 this plain run was HEADLESS ONLY and left the evidence untouched; a rendered run is opt-in (--with-evidence) with a hard ${CEILING} s ceiling per capture, and every D-404 capture refuses to save if its state is not reached"
elif [ "$WITH_EVIDENCE" -eq 1 ] && [ "$CEIL_OK" -eq 1 ] && [ -z "$EV_RESULT" ] && [ "$REFUSE_OK" -eq 1 ]; then
  ok "U20 rendering was OPTED IN; each of the six captures reached the state its name claims, finished inside its ${CEILING} s ceiling and exited 0"
else
  fail "U20 evidence changed without opting in, a capture timed out or refused its state ($EV_RESULT), or the ceiling / refusal is missing"
fi
U21_OK=1
for e in $EV_FRAMES; do
  if [ -f "$PROJ/evidence/$e.png" ]; then
    DIM="$(sips -g pixelWidth -g pixelHeight "$PROJ/evidence/$e.png" 2>/dev/null \
           | awk '/pixel/{printf "%s", $2"x"} END{print ""}' | sed 's/x$//')"
    [ "$DIM" = "1920x1080" ] || { U21_OK=0; say "        evidence/$e.png is $DIM"; }
  else
    U21_OK=0; say "        evidence/$e.png missing (run with --with-evidence)"
  fi
done
if [ "$U21_OK" -eq 1 ]; then
  ok "U21 all six D-404 captures (55-60) exist at 1920x1080 — accepted evidence 01-54 is untouched (U16)"
else
  fail "U21 the D-404 evidence is missing or mis-sized"
fi

# ----------------------------------------- U22-U24. fixtures, code, disclosure
say ""
say "[9/9] The accepted fixture and banners (U22), untouched code (U23) and the disclosure (U24)"
CALLERS="$(grep -lF 'restore_accepted_d392_loadout(' "$PROJ"/tests/*.gd | while IFS= read -r f; do basename "$f"; done | sort | tr '\n' ' ')"
BANNERS=1
for L in "${ALL_LOGS[@]}"; do
  N="$(grep -cF 'RIFTWROUGHT — PLAYER DIRECT-CLICK MOVEMENT CORRECTION STAGE  (D-404, 2026-09-28)' "$L")"
  N10="$(grep -cF 'RIFTWROUGHT — CINDER FIELD STAGE  (D-402, 2026-09-20)' "$L")"
  { [ "$N" = "1" ] && [ "$N10" = "1" ]; } || BANNERS=0
done
if [ "$CALLERS" = "alignment_verification.gd cinder_verification.gd foundation_verification.gd hounds_verification.gd huntress_verification.gd imprint_verification.gd " ] \
   && [ "$BANNERS" -eq 1 ] && [ "$LEAK" = "0" ]; then
  ok "U22 the accepted D-392-loadout fixture keeps exactly its six accepted callers — the D-404 suite runs on the review loadout and does NOT call it; every log shows the D-402 and D-404 banners exactly once; and no D-404 row leaks into an accepted log"
else
  fail "U22 fixture callers '$CALLERS', banners=$BANNERS, leaked rows=$LEAK"
fi
# U23 — THE CODE THIS STAGE MUST NOT TOUCH, by its PRE-D-404 SHA-256.
U23_ROWS=""
U23_OK=1
for spec in "scripts/world/nav_service.gd:6eba15fe4ca331069f4211b85210536b70b130adeec8d989fa15dc6aeef5fa6d" \
            "scripts/combat/ordinary_enemy.gd:bc77f3aaeb79b1948b4f031c099111ef961df8a9b6284464ac6cb18be535619e" \
            "scripts/cohort/mobile_cohort.gd:6069da3c318646bf83fc26c982d353386a18e5ca981f966773c797883289decd" \
            "scripts/hounds/kindred_hound.gd:078efcc3f73913b87304873bcb7696c3c51475f70dffd03c3835ffe2ef75334e" \
            "scripts/hounds/hound_targeting.gd:3cb568a932002dcfe599faf03aae0bb63edb23fca01683fa5232d11ec4fddb61" \
            "scripts/cinder/cinder_runtime.gd:626384d148b533ab244a883bfca677cbe5aa5c744ee63d2e3e2166ebf1b45809" \
            "scripts/cinder/cinder_trap.gd:6b4c669c77421670a6b39a5dcb1d824f3afce5ef60e8aef0276b8f9240e32e03" \
            "scripts/control/locomotion_motor.gd:e5b45fccfdc90d413f15a4ddc14fefbcdb19ce78d467f9a8dca1ae1e4210f22b" \
            "scripts/locomotion/ground_motion.gd:3c5b0c67f38ad397df96c5e567b53ec29d8fa00ce8708dc06de63ef5ee464d08" \
            "scripts/control/action_commitment.gd:5936706e90594d716db5b2d523cb1e610a7eb0b4045f5584243791bc1f538010" \
            "scripts/control/input_intent.gd:a5fd43202926681588336914da8653aff56bfbeb9e064191c0eec19423746616"; do
  F="${spec%%:*}"; WANT="${spec#*:}"
  GOT="$(shasum -a 256 "$PROJ/$F" 2>/dev/null | cut -d' ' -f1)"
  if [ "$GOT" != "$WANT" ]; then U23_OK=0; U23_ROWS="$U23_ROWS $F"; fi
done
if [ "$U23_OK" -eq 1 ]; then
  ok "U23 the navigation service, the enemy, the cohort, the hound and its targeting rule, Cinder Field's runtime and trap, the accepted motor and its arithmetic, the commitment and the input layer are ALL byte-identical to their pre-D-404 SHA-256 — the correction lives in the controller and scripts/click/ alone"
else
  fail "U23 code this stage must not touch CHANGED:$U23_ROWS"
fi
# U24 — THE DISCLOSURE, VISIBLE IN THE RUN: every accepted check this stage
# replaced says so in its own printed note, with its old name.
DISC=""
for pair in "$FLOG:REPLACED ONE FOR ONE UNDER D-404 (was F27_offmesh_click_is_reported_not_dropped" \
            "$FLOG:re-scoped under D-404 — NO navigation path" \
            "$ILOG:REPLACED ONE FOR ONE UNDER D-404 (was I80_click_to_move_still_resolves_the_nearest_navigable_point" \
            "$MLOG:REPLACED ONE FOR ONE UNDER D-404 (was L12_a_sharp_path_corner_redirects_in_the_same_physics_frame" \
            "$MLOG:REPLACED ONE FOR ONE UNDER D-404 (was L18_path_corner_deviation_is_bounded_and_does_not_grow_with_speed" \
            "$MLOG:REPLACED ONE FOR ONE UNDER D-404 (was L21_the_narrow_doorway_is_still_navigated_at_every_speed" \
            "$CLOG:(D-404: she now takes this route BY HAND" \
            "$ALOG:RE-SCOPED UNDER D-404, ONE FOR ONE: the runtime scripts are now 68 + 4 = 72"; do
  L="${pair%%:*}"; S="${pair#*:}"
  grep -qF "$S" "$L" || DISC="$DISC | $(basename "$L"): $S"
done
if [ -z "$DISC" ]; then
  ok "U24 the run DISCLOSES every accepted check this stage re-scoped: F27, I80, L12, L18 and L21 replaced one for one, each naming its old name; F76's path conjunct; C27's drive walked by hand (C15's drive with it); and A26's runtime-script count, 68 + 4 = 72"
else
  fail "U24 the run does NOT disclose:$DISC"
fi

# ------------------------------------------------------------------ verdict --
say ""
say "========================================================================"
say "UNITS: 24 RUNNER CHECKS here · 32 EXECUTABLE CHECKS · 124 OWED CRITERIA — different units."
say "$STATE_EXPECT"
if [ "$FAILED" -eq 0 ] && [ "$SKIPPED" -eq 0 ]; then
  say "DIRECT CLICK RUNNER: PASS (24 runner checks)"
elif [ "$FAILED" -eq 0 ]; then
  say "DIRECT CLICK RUNNER: INCOMPLETE — $SKIPPED runner check(s) SKIPPED for lack of a baseline; NOT a pass"
  FAILED=1
else
  say "DIRECT CLICK RUNNER: FAIL"
fi
say "========================================================================"
# Set CLICK_LOG_DIR to keep the nine suite logs (a run of record cites them).
if [ -n "${CLICK_LOG_DIR:-}" ] && [ -d "$CLICK_LOG_DIR" ]; then
  cp "$FLOG" "$CLICK_LOG_DIR/foundation.log"; cp "$ILOG" "$CLICK_LOG_DIR/imprint.log"
  cp "$ALOG" "$CLICK_LOG_DIR/alignment.log"; cp "$HLOG" "$CLICK_LOG_DIR/huntress.log"
  cp "$KLOG" "$CLICK_LOG_DIR/hounds.log"; cp "$CLOG" "$CLICK_LOG_DIR/cohesion.log"
  cp "$MLOG" "$CLICK_LOG_DIR/locomotion.log"; cp "$ELOG" "$CLICK_LOG_DIR/cinder.log"
  cp "$DLOG" "$CLICK_LOG_DIR/direct_click.log"
fi
rm -f "${ALL_LOGS[@]}"
exit "$FAILED"
