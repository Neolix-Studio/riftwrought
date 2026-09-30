#!/usr/bin/env bash
# =============================================================================
# RIFTWROUGHT — THE CINDER FIELD STAGE RUNNER  (D-402, 2026-09-20)
# =============================================================================
#
# Runs ALL EIGHT game3d/ suites headless against the final code: the ACCEPTED
# D-373 foundation, D-376 Imprint, D-383 alignment, D-394 Splinter Shot, D-397
# Kindred Hounds, D-399 mobile minion cohesion and D-401 player locomotion
# redirection suites as REGRESSIONS, then this stage's own suite. It checks their
# summaries, owed lists, printed rows, the state line, truthfulness, the
# isolation of every protected tree, the D-402 change set inside game3d/, the
# asset guards, the input map, the units and the rendered evidence.
#
#   tests/cinder_smoke.sh                  headless only (the default)
#   tests/cinder_smoke.sh --with-evidence  also RENDERS frames 46-54 first,
#                                          each under a hard 120 s ceiling
#
# Set FOUNDATION_BASELINE_DIR to a directory of pre-work SHA-256 listings
# (baseline_<tree>.sha256, baseline_archives.sha256) to run Q17, and
# D402_BASELINE_GAME3D to the PRE-D-402 listing of game3d/ to run Q18. Without
# them they print [SKIP], are NOT counted as passes, and the run is INCOMPLETE.
#
# =============================================================================
# UNITS. TWENTY-FOUR COUNTS, AND NONE IS A SYNONYM FOR ANOTHER.
#
#   D-402: 24 RUNNER CHECKS here (Q01-Q24) · 48 EXECUTABLE CHECKS in
#          tests/cinder_verification.gd · 185 OWED CRITERIA in
#          docs/testing/D402_CINDER_FIELD_OWED_CRITERIA_INVENTORY.md
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
# not Sinew Ballista, not another Huntress Skill, not Huntress's Mark, not Rift
# Shards, not Augments, not production VFX and not a broader trap framework,
# and it locks no number.
# =============================================================================
set -uo pipefail

GODOT="${GODOT:-/Applications/Godot.app/Contents/MacOS/Godot}"
HERE="$(cd "$(dirname "$0")" && pwd)"
PROJ="$(cd "$HERE/.." && pwd)"
ROOT="$(cd "$PROJ/.." && pwd)"
FLOG="$(mktemp -t cinder_foundation)"
ILOG="$(mktemp -t cinder_imprint)"
ALOG="$(mktemp -t cinder_alignment)"
HLOG="$(mktemp -t cinder_huntress)"
KLOG="$(mktemp -t cinder_hounds)"
CLOG="$(mktemp -t cinder_cohesion)"
MLOG="$(mktemp -t cinder_locomotion)"
ELOG="$(mktemp -t cinder_stage)"
FAILED=0
SKIPPED=0
WITH_EVIDENCE=0
[ "${1:-}" = "--with-evidence" ] && WITH_EVIDENCE=1

# THE ONE STATE LINE, identical in all seven runners (Q14 compares them).
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
# THIS STAGE'S OWN.
PIN_E_CHECKS=48
PIN_E_DEFERRED=19
# RE-PINNED UNDER D-404, AS ITS FIRST ACT: D-403 ANSWERED FO-01..FO-07 with one
# overall acceptance ("Looks and feels good."), so they moved from OWED-TO-OWNER
# to DISCHARGED with their original text preserved. 7 - 7 = 0 owed; 0 + 7 = 7
# discharged; 0 deleted. The check and deferred counts do NOT move. Until D-404
# this read PIN_E_OWNER=7 -- true when written.
PIN_E_OWNER=0
PIN_E_DISCHARGED=7

# THE DECLARED D-402 CHANGE SET INSIDE game3d/, against the PRE-D-402 listing
# (taken 2026-09-20 15:23:25) — pinned in BOTH directions by Q18.
#
# `tests/foundation_verification.gd` IS NOT IN IT. The accepted foundation suite
# asserts nothing about the state line, so the first act had nothing in it to
# move, and this stage did not touch it at all. `project.godot` is not in it
# either: D-402 adds NO input action.
#
# `assets/third_party/quaternius/SOURCE_AND_LICENSE.md` IS in it, because the
# intake of two models must be recorded where the accepted F01 reads it.
DECLARED_MODIFIED="README.md
assets/third_party/quaternius/SOURCE_AND_LICENSE.md
scripts/assets/asset_manifest.gd
scripts/core/prod_config.gd
scripts/foundation_main.gd
scripts/imprint/skill_configuration.gd
scripts/imprint/skill_runtime.gd
scripts/locomotion/locomotion_config.gd
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
tests/imprint_verification.gd
tests/locomotion_smoke.sh
tests/locomotion_verification.gd"
D402_SCRIPTS="cinder_config cinder_content cinder_ground cinder_review_hud cinder_runtime cinder_trap"
D402_ASSETS="BearTrap_Open BearTrap_Closed"
EV_FRAMES="46_d402_launch 47_d402_placement 48_d402_armed 49_d402_eruption 50_d402_burning_ground 51_d402_multi_hit 52_d402_overlap 53_d402_replacement 54_d402_expiry"
DECLARED_NEW="$(
  printf '%s\n' tests/cinder_smoke.sh tests/cinder_verification.gd tests/cinder_verification.gd.uid
  for s in $D402_SCRIPTS; do printf 'scripts/cinder/%s.gd\nscripts/cinder/%s.gd.uid\n' "$s" "$s"; done
  for a in $D402_ASSETS; do printf 'assets/third_party/quaternius/ultimate_modular_ruins/%s.obj\nassets/third_party/quaternius/ultimate_modular_ruins/%s.obj.import\nassets/third_party/quaternius/ultimate_modular_ruins/%s.mtl\n' "$a" "$a" "$a"; done
  for e in $EV_FRAMES; do printf 'evidence/%s.png\nevidence/%s.png.import\n' "$e" "$e"; done
)"
# The protected trees, each byte-identical to its pre-work listing (Q15).
PROTECTED="game game2d game3d_spike game3d_boss_spike game3d_huntress_spike models"
# The 29 input actions accepted before D-400, in project order. D-400 ADDS NONE.
ACCEPTED_ACTIONS="move_command stick_left stick_right stick_up stick_down aim_left aim_right aim_up aim_down diagnostic_attack zoom_in zoom_out toggle_overlay imprint_binding_1 imprint_binding_2 imprint_binding_3 imprint_binding_4 imprint_binding_5 imprint_binding_6 imprint_binding_7 imprint_binding_8 imprint_panel imprint_panel_prev imprint_panel_next imprint_panel_activate diagnostic_reservation_cycle diagnostic_hound_fall diagnostic_stress_population diagnostic_travel_speed"

say()  { printf '%s\n' "$*"; }
fail() { say "  [FAIL] $*"; FAILED=1; }
ok()   { say "  [ OK ] $*"; }
skip() { say "  [SKIP] $*"; SKIPPED=$((SKIPPED + 1)); }

say "========================================================================"
say "RIFTWROUGHT CINDER FIELD STAGE RUNNER (D-402)"
say "Headless by default. Rendered evidence is opt-in via --with-evidence."
say "It runs the ACCEPTED D-373, D-376, D-383, D-394, D-397, D-399 and D-401 suites as REGRESSIONS, then this stage."
say "DELIVERED and OPEN pending owner live review. It accepts nothing."
say "========================================================================"

# The evidence as it stands BEFORE this run -- Q20 proves a plain run leaves it alone.
EV_BEFORE="$(cd "$PROJ" && for e in $EV_FRAMES; do [ -f "evidence/$e.png" ] && shasum -a 256 "evidence/$e.png"; done)"

# --------------------------------------------- 0. opt-in evidence, rendered FIRST
EV_RESULT=""
CEILING=120
if [ "$WITH_EVIDENCE" -eq 1 ]; then
  say ""
  say "[0/9] Rendering this stage's nine captures (46-54) FIRST (opt-in) — never 01-45"
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

# ------------------------------------------------------------ Q01. import ----
say ""
say "[1/9] Import pass (Q01)"
"$GODOT" --headless --path "$PROJ" --import >/dev/null 2>&1
IMPORTED="$(ls "$PROJ/.godot/imported" 2>/dev/null | wc -l | tr -d ' ')"
UIDS=0
for s in $D402_SCRIPTS; do [ -f "$PROJ/scripts/cinder/$s.gd.uid" ] && UIDS=$((UIDS + 1)); done
[ -f "$PROJ/tests/cinder_verification.gd.uid" ] && UIDS=$((UIDS + 1))
IMPS=0
for a in $D402_ASSETS; do
  [ -f "$PROJ/assets/third_party/quaternius/ultimate_modular_ruins/$a.obj.import" ] && IMPS=$((IMPS + 1))
done
if [ "$IMPORTED" -gt 0 ] && [ "$UIDS" = "7" ] && [ "$IMPS" = "2" ]; then
  ok "Q01 assets imported ($IMPORTED entries); all six D-402 scripts and the D-402 suite carry their .uid, and both placeholder trap models carry their .import — a fresh checkout verifies"
else
  fail "Q01 the import pass produced $IMPORTED entries; D-402 uids $UIDS of 7; trap .import files $IMPS of 2"
fi

# ------------------------------------------------------ Q02-Q08. the suites --
say ""
say "[2/9] The eight suites: D-373, D-376, D-383, D-394, D-397, D-399 and D-401's locomotion suite as REGRESSIONS, then D-402's own (Q02-Q08)"
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
grep -E "^  \[(PASS|FAIL|UNREACHED) *\]" "$ELOG" | sed 's/^/    /' | head -56
grep -E "^(FOUNDATION|IMPRINT|ALIGNMENT|HUNTRESS|HOUNDS|COHESION|LOCOMOTION|CINDER) VERIFICATION:" \
  "$FLOG" "$ILOG" "$ALOG" "$HLOG" "$KLOG" "$CLOG" "$MLOG" "$ELOG" | sed "s|^[^:]*:|    |"

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
E_EXPECT="CINDER VERIFICATION: PASS ($PIN_E_CHECKS checks: $PIN_E_CHECKS passed, 0 failed/unreached, $PIN_E_DEFERRED deferred, $PIN_E_OWNER owed to the owner, $PIN_E_DISCHARGED discharged)"
pin_summary Q02 "$FLOG" FOUNDATION "$PIN_F_CHECKS" "$PIN_F_DEFERRED"
pin_summary Q03 "$ILOG" IMPRINT "$PIN_I_CHECKS" "$PIN_I_DEFERRED"
pin_summary Q04 "$ALOG" ALIGNMENT "$PIN_A_CHECKS" "$PIN_A_DEFERRED"
H_LINE="$(grep -E '^HUNTRESS VERIFICATION:' "$HLOG" | head -1)"
K_LINE="$(grep -E '^HOUNDS VERIFICATION:' "$KLOG" | head -1)"
C_LINE="$(grep -E '^COHESION VERIFICATION:' "$CLOG" | head -1)"
M_LINE="$(grep -E '^LOCOMOTION VERIFICATION:' "$MLOG" | head -1)"
E_LINE="$(grep -E '^CINDER VERIFICATION:' "$ELOG" | head -1)"
if [ "$H_LINE" = "$H_EXPECT" ] && [ "$K_LINE" = "$K_EXPECT" ] && [ "$C_LINE" = "$C_EXPECT" ]; then
  ok "Q05 the three ACCEPTED summaries that carry owed/discharged counts match EXACTLY: Splinter Shot ($PIN_H_CHECKS/$PIN_H_DEFERRED/$PIN_H_OWNER/$PIN_H_DISCHARGED), Kindred Hounds ($PIN_K_CHECKS/$PIN_K_DEFERRED/$PIN_K_OWNER/$PIN_K_DISCHARGED) and mobile minion cohesion ($PIN_C_CHECKS/$PIN_C_DEFERRED/$PIN_C_OWNER/$PIN_C_DISCHARGED — re-pinned under D-400's first act)"
else
  fail "Q05 a summary MISMATCH"; say "        expected: $H_EXPECT"; say "        actual  : $H_LINE"
  say "        expected: $K_EXPECT"; say "        actual  : $K_LINE"
  say "        expected: $C_EXPECT"; say "        actual  : $C_LINE"
fi
if [ "$M_LINE" = "$M_EXPECT" ] && [ "$E_LINE" = "$E_EXPECT" ]; then
  ok "Q06 the ACCEPTED locomotion summary matches EXACTLY ($PIN_M_CHECKS checks, $PIN_M_DEFERRED deferred, $PIN_M_OWNER owed, $PIN_M_DISCHARGED discharged — re-pinned under D-402's first act), and THIS stage's matches EXACTLY: $PIN_E_CHECKS executable checks, $PIN_E_DEFERRED deferred rows, $PIN_E_OWNER owed to the owner"
else
  fail "Q06 a summary MISMATCH"; say "        expected: $M_EXPECT"; say "        actual  : $M_LINE"
  say "        expected: $E_EXPECT"; say "        actual  : $E_LINE"
fi
OWED_OK=1
for spec in "$FLOG:$PIN_F_CHECKS:F" "$ILOG:$PIN_I_CHECKS:I" "$ALOG:$PIN_A_CHECKS:A" "$HLOG:$PIN_H_CHECKS:H" \
            "$KLOG:$PIN_K_CHECKS:B" "$CLOG:$PIN_C_CHECKS:C" "$MLOG:$PIN_M_CHECKS:L" "$ELOG:$PIN_E_CHECKS:E"; do
  L="${spec%%:*}"; rest="${spec#*:}"; C="${rest%%:*}"; P="${rest#*:}"
  LINE="$(grep -E '^  owed=' "$L" | head -1 | sed 's/^ *//')"
  EXPECT="owed=$C  reached=$C  owed-but-not-reached=0 []  reached-but-not-owed=0 []"
  NAMES="$(grep -cE "^  \[PASS     \] $P[0-9]+_" "$L")"
  if [ "$LINE" != "$EXPECT" ] || [ "$NAMES" != "$C" ]; then
    OWED_OK=0; say "        $(basename "$L"): '$LINE' ($NAMES $P-names)"
  fi
done
if [ "$OWED_OK" -eq 1 ]; then
  ok "Q07 owed vs reached matches in BOTH directions in all eight logs, and every F-, I-, A-, H-, B-, C-, L- and E-numbered check passed"
else
  fail "Q07 owed/reached or name counts MISMATCH"
fi
RC_OK=1
for rc in "$F_RC" "$I_RC" "$A_RC" "$H_RC" "$K_RC" "$C_RC" "$M_RC" "$E_RC"; do [ "$rc" -ne 0 ] && RC_OK=0; done
if [ "$RC_OK" -eq 1 ]; then
  ok "Q08 all eight suites exited 0"
else
  fail "Q08 a suite exited non-zero (F $F_RC, I $I_RC, A $A_RC, H $H_RC, B $K_RC, C $C_RC, L $M_RC, E $E_RC)"
fi

# ----------------------------------------------- Q09. pins able to refuse ----
say ""
say "[3/9] Every summary pin PROVED able to refuse an altered value (Q09)"
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
E_ALT1="$(printf '%s' "$E_LINE" | sed "s/($PIN_E_CHECKS checks/($((PIN_E_CHECKS - 1)) checks/")"
E_ALT2="$(printf '%s' "$E_LINE" | sed "s/, $PIN_E_DEFERRED deferred/, $((PIN_E_DEFERRED - 1)) deferred/")"
# RE-SCOPED UNDER D-404 (first act), one for one: the owed count is now 0, so the
# third altered value is the DISCHARGED count, exactly as the other suites carrying
# one are proved. Until D-404 this altered the OWED count -- true when written.
E_ALT3="$(printf '%s' "$E_LINE" | sed "s/, $PIN_E_DISCHARGED discharged/, $((PIN_E_DISCHARGED - 1)) discharged/")"
if [ "$E_ALT1" != "$E_EXPECT" ] && [ "$E_ALT2" != "$E_EXPECT" ] && [ "$E_ALT3" != "$E_EXPECT" ] && [ "$E_LINE" = "$E_EXPECT" ]; then
  REFUSED=$((REFUSED + 1))
fi
if [ "$REFUSED" = "8" ]; then
  ok "Q09 all eight summary pins REFUSE an altered check count AND an altered row count (the four carrying a discharged count also an altered discharged count; this stage's an altered OWED count) — replayed"
else
  fail "Q09 only $REFUSED of 8 summary pins were proved able to refuse an altered value"
fi

# -------------------------------------------------- Q10. printed rows ----
say ""
say "[4/9] Deferred, owed and discharged rows (Q10)"
# THIS STAGE'S OWN ROWS, in its OWN log.
FD_ROWS="$(grep -cE '^  \[[^]]+\] FD-(0[1-9]|1[0-9]) ' "$ELOG")"
FO_ROWS="$(grep -cE '^  \[OWED-TO-OWNER\] FO-0[1-7] ' "$ELOG")"
# ADDED UNDER D-404 (first act): the seven rows now print DISCHARGED — D-403, each
# with its ORIGINAL text preserved verbatim beside the owner's one overall answer.
FO_DIS="$(grep -cE '^  \[DISCHARGED — D-403\] FO-0[1-7] ' "$ELOG")"
FO_KEPT="$(grep -cF "ORIGINAL ROW TEXT, PRESERVED VERBATIM (OWED-TO-OWNER): '" "$ELOG")"
E_PASSROW="$(grep -cE '^  \[(PASS|OK) *\] F[DO]-' "$ELOG")"
FD03="$(grep -cE '^  \[OUT OF SCOPE *\] FD-03 ' "$ELOG")"
FD08="$(grep -cE '^  \[DECLARED — NOT REPAIRED *\] FD-08 ' "$ELOG")"
FD18="$(grep -cE '^  \[CARRIED — NOT DISCHARGED *\] FD-18 ' "$ELOG")"
# NO ROW OF THIS STAGE NAMES PREY OR MARK AS A MECHANIC IT IMPLEMENTS.
# CORRECTED DURING THE D-402 WORK, AND DISCLOSED: this guard first demanded TWO
# such rows, on the assumption that Prey had one of its own. It does not, and
# should not: PREY WAS REMOVED FROM HER DESIGN UNDER D-393, so it is not a
# deferred obligation at all -- it is a DENIAL, and the denial block carries it
# (proved here and again by Q13). Exactly ONE row names Huntress's Mark, FD-07,
# and it is an OUT OF SCOPE row. Demanding a Prey ROW would have been demanding
# the stage treat a removed mechanic as owed.
ROW_PREY="$(grep -E '^  \[[^]]+\] F[DO]-[0-9]+ ' "$ELOG" | grep -ciE 'prey|mark' || true)"
ROW_MARK_SCOPE="$(grep -cE '^  \[OUT OF SCOPE *\] FD-07 ' "$ELOG")"
DENY_PREY="$(grep -cF 'The D-402 stage introduces NO PREY in any form' "$ELOG" || true)"
# THE ACCEPTED LOCOMOTION ROWS, in ITS log, reconciled by this stage's first act.
LD_ROWS="$(grep -cE '^  \[[^]]+\] LD-(0[1-9]|1[0-4]) ' "$MLOG")"
LO_ROWS="$(grep -cE '^  \[OWED-TO-OWNER\] LO-0[1-4] ' "$MLOG")"
LO_DIS="$(grep -cE '^  \[DISCHARGED — D-401\] LO-0[1-4] ' "$MLOG")"
LO_KEPT="$(grep -cF "ORIGINAL ROW TEXT, PRESERVED VERBATIM (OWED-TO-OWNER): 'Whether" "$MLOG")"
LD02="$(grep -cE '^  \[CARRIED — PROVISIONAL FINDING *\] LD-02 ' "$MLOG")"
# AND THE EARLIER STAGES' DISCHARGED ROWS, each in its own log.
CO_DIS="$(grep -cE '^  \[DISCHARGED — D-399\] CO-0[1-5] ' "$CLOG")"
KO_DIS="$(grep -cE '^  \[DISCHARGED — D-397\] KO-0[1-6] ' "$KLOG")"
SO_DIS="$(grep -cE '^  \[DISCHARGED — D-394\] SO-0[1235] ' "$HLOG")"
# NO D-402 ROW LEAKS INTO AN ACCEPTED LOG.
LEAK="$(grep -cE '^  \[OWED-TO-OWNER\] FO-|^  \[[^]]+\] FD-[0-9]+ |^CINDER VERIFICATION' "$FLOG" "$ILOG" "$ALOG" "$HLOG" "$KLOG" "$CLOG" "$MLOG" | awk -F: '{s+=$2} END{print s+0}')"
if [ "$FD_ROWS" = "$PIN_E_DEFERRED" ] && [ "$FO_ROWS" = "$PIN_E_OWNER" ] && [ "$E_PASSROW" = "0" ] \
   && [ "$FO_DIS" = "$PIN_E_DISCHARGED" ] && [ "$FO_KEPT" -ge "$PIN_E_DISCHARGED" ] \
   && [ "$FD03" = "1" ] && [ "$FD08" = "1" ] && [ "$FD18" = "1" ] && [ "$ROW_PREY" = "1" ] \
   && [ "$ROW_MARK_SCOPE" = "1" ] && [ "$DENY_PREY" -ge "1" ] \
   && [ "$LD_ROWS" = "$PIN_M_DEFERRED" ] && [ "$LO_ROWS" = "0" ] && [ "$LO_DIS" = "$PIN_M_DISCHARGED" ] \
   && [ "$LO_KEPT" -ge "$PIN_M_DISCHARGED" ] && [ "$LD02" = "1" ] \
   && [ "$CO_DIS" = "$PIN_C_DISCHARGED" ] && [ "$KO_DIS" = "$PIN_K_DISCHARGED" ] \
   && [ "$SO_DIS" = "$PIN_H_DISCHARGED" ] && [ "$LEAK" = "0" ]; then
  ok "Q10 the D-402 run prints FD-01..FD-19 ($FD_ROWS), none as a pass, and — RE-SCOPED UNDER D-404 — FO-01..FO-07 DISCHARGED — D-403 ($FO_DIS, original text kept $FO_KEPT) with $FO_ROWS owed; FD-03 OUT OF SCOPE, FD-08 DECLARED — NOT REPAIRED, FD-18 CARRIED; exactly ONE row names Huntress's Mark and it is OUT OF SCOPE ($ROW_PREY), while Prey — REMOVED from her design under D-393 — is not a row at all but a DENIAL ($DENY_PREY) | the D-400 run prints LD-01..LD-14 ($LD_ROWS) with LO-01..LO-04 DISCHARGED — D-401 ($LO_DIS), their original text preserved ($LO_KEPT) and NONE owed, and LD-02 CARRIED — PROVISIONAL FINDING (re-classified by D-401, NOT discharged) | the D-398 run prints its five CO- rows DISCHARGED — D-399, the D-396 run its six KO- rows DISCHARGED — D-397 and the D-392 run its four SO- rows DISCHARGED — D-394 | no D-402 row leaks into an accepted log"
else
  fail "Q10 rows: FD $FD_ROWS, FO owed $FO_ROWS, FO discharged $FO_DIS, FO kept $FO_KEPT, as pass $E_PASSROW, FD-03 $FD03, FD-08 $FD08, FD-18 $FD18, naming Mark $ROW_PREY (FD-07 out-of-scope $ROW_MARK_SCOPE), Prey denials $DENY_PREY, LD $LD_ROWS, LO owed $LO_ROWS, LO discharged $LO_DIS, LO kept $LO_KEPT, LD-02 $LD02, CO $CO_DIS, KO $KO_DIS, SO $SO_DIS, leaked $LEAK"
fi

# ---------------------------------------------------- Q11. engine errors ----
say ""
say "[5/9] Engine-error guard (Q11)"
ERRPAT='^(SCRIPT )?ERROR:|^USER ERROR:|^SCRIPT ERROR|Parse Error|Failed to load script'
SELF='Foundation_Signature_Move_THIS_DOES_NOT_EXIST'
SELF_N="$(grep -cF "$SELF" "$FLOG")"
F_REAL="$(grep -E "$ERRPAT" "$FLOG" | grep -vF "$SELF" || true)"
OTHER_REAL="$(grep -E "$ERRPAT" "$ILOG" "$ALOG" "$HLOG" "$KLOG" "$CLOG" "$MLOG" "$ELOG" || true)"
PLANT="$(mktemp -t cinder_plant)"; cat "$ELOG" > "$PLANT"
printf 'SCRIPT ERROR: planted engine error, for guard proving only\n' >> "$PLANT"
if [ "$SELF_N" -lt 1 ]; then
  fail "Q11 the accepted suite's guard-proving error line is missing — F12's proof is not intact"
elif [ -n "$F_REAL" ] || [ -n "$OTHER_REAL" ]; then
  fail "Q11 engine errors present:"
  printf '%s\n' "$F_REAL" "$OTHER_REAL" | grep -v '^$' | head -12 | sed 's/^/        /'
elif ! grep -qE "$ERRPAT" "$PLANT"; then
  fail "Q11 the error guard could NOT detect a planted error line"
else
  ok "Q11 no engine error in any of the eight logs beyond the one expected guard proof, and the guard refuses a planted error (a parse error EXITS 0, so this guard, not the exit code, is what catches it)"
fi
rm -f "$PLANT"

# ------------------------------------ Q12-Q14. state line and truthfulness --
say ""
say "[6/9] The state line and truthfulness (Q12-Q14)"
BAD_STATE=0
for L in "$FLOG" "$ILOG" "$ALOG" "$HLOG" "$KLOG" "$CLOG" "$MLOG" "$ELOG"; do
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
  grep -qxF "$S" "$FLOG" "$ILOG" "$ALOG" "$HLOG" "$KLOG" "$CLOG" "$MLOG" "$ELOG" && SUPERSEDED=1
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
ACCEPTS="$(grep -hE "$SELF_ACCEPT" "$FLOG" "$ILOG" "$ALOG" "$HLOG" "$KLOG" "$CLOG" "$MLOG" "$ELOG" | grep -v 'SELF_ACCEPT' | head -3 || true)"
PLANT3="$(mktemp -t cinder_plant3)"; printf 'PLAYER DIRECT-CLICK MOVEMENT CORRECTION STAGE ACCEPTED and CLOSED (D-404)\n' > "$PLANT3"
ALT_STATE="$(printf '%s' "$STATE_EXPECT" | sed 's/DELIVERED and OPEN pending owner live review (D-404)/ACCEPTED and CLOSED (D-404)/')"
if [ "$BAD_STATE" -eq 0 ] && [ "$SUPERSEDED" -eq 0 ] && [ -z "$ACCEPTS" ] && grep -qE "$SELF_ACCEPT" "$PLANT3" \
   && [ "$ALT_STATE" != "$STATE_EXPECT" ] && [ "$STATE_D398_LINE" != "$STATE_EXPECT" ] \
   && [ "$STATE_D400_LINE" != "$STATE_EXPECT" ] \
   && [ "$STATE_D402_LINE" != "$STATE_EXPECT" ]; then
  ok "Q12 every STATE line in all eight logs is the SAME exact nine-fact line (D-404 first act); no superseded line (D-375, D-380, D-392, D-396, D-398, D-400, D-402, bare D-370) is printed; nothing claims the open D-402 stage accepted or an earlier stage accepting itself — and each scan refuses a planted line"
else
  fail "Q12 a state line differs ($BAD_STATE), a superseded line is printed ($SUPERSEDED), or a self-acceptance appears: $ACCEPTS"
fi
rm -f "$PLANT3"
Q13_MISS=""
# THIS STAGE'S OWN TRUTHFULNESS STRINGS, in its OWN log.
# RE-SCOPED UNDER D-404 (first act), one for one: the self-denial is now its DATED
# form and the first and last owner questions their DISCHARGED — D-403 forms. Until
# D-404 these read "The D-402 stage delivers OPEN pending owner live review; it
# does NOT accept itself." and "[OWED-TO-OWNER] FO-01 ..." -- true when written.
for s in "The D-402 stage IS NOT P2 and AUTHORIZES NO P2." \
         "implements NO Sinew Ballista and NO other Huntress Skill" \
         "implements NO Huntress's Mark" \
         "introduces NO PREY in any form" \
         "IMPLEMENTS NO RIFT SHARDS" \
         "implements NO AUGMENT and NO TRANSFORM" \
         "implements NO IGNITE and NO ailment" \
         "IS NOT a broader trap or deployable framework" \
         "is NOT production VFX work" \
         "NEITHER is final Huntress art" \
         "LOCKS NO NUMBER" \
         "adds NO input action: the project's 29 accepted actions stay 29" \
         "adds NO third action-movement policy" \
         "increases NO Capacity: the budget stays 30 + 5 = 35" \
         "review HUD is review tooling and IS NOT a UI foundation" \
         "modifies NO accepted spike and has NO runtime dependency outside game3d/" \
         "The D-402 stage was delivered OPEN and never accepted itself: the owner ACCEPTED and CLOSED it under D-403" \
         "[DISCHARGED — D-403] FO-01 Does placement feel responsive and accurate while using click-to-move?" \
         "[DISCHARGED — D-403] FO-07 Does this feel like a plausible foundation for a trap-focused Huntress build?"; do
  grep -qF "$s" "$ELOG" || Q13_MISS="$Q13_MISS | $s"
done
# AND THE D-400 STAGE'S OWN RECONCILED STRINGS, in its own log.
for s in "The D-400 stage was delivered OPEN and never accepted itself: the owner ACCEPTED and CLOSED it under D-401" \
         "[DISCHARGED — D-401] LO-01 Whether abrupt direction changes feel immediate and controlled at ORDINARY speed." \
         "THE OWNER'S D-401 LIVE REVIEW: ANSWERED DIRECTLY — \"works well, I like it.\"" \
         "RE-CLASSIFIED BY THE OWNER (D-401)"; do
  grep -qF "$s" "$MLOG" || Q13_MISS="$Q13_MISS | (D-400 log) $s"
done
FORBID='P2 is authorized|P1 is complete|the top speed is (locked|changed)|3\.889 is locked|the arming delay is locked|the trigger radius is locked|the instance cap is locked|the eruption damage is locked|Prey is (restored|reintroduced)|Ignite is implemented|Huntress.s Mark is implemented|Capacity (is|was) increased|production ready|pivot complete|final art is (approved|accepted)|the roster is (complete|finalized)'
PLANT2="$(mktemp -t cinder_plant2)"; printf 'the arming delay is locked\n' > "$PLANT2"
if [ -n "$Q13_MISS" ]; then
  fail "Q13 the run does NOT state:$Q13_MISS"
elif grep -qiE "$FORBID" "$FLOG" "$ILOG" "$ALOG" "$HLOG" "$KLOG" "$CLOG" "$MLOG" "$ELOG"; then
  fail "Q13 a run log makes a forbidden lock or completion claim:"
  grep -hiE "$FORBID" "$FLOG" "$ILOG" "$ALOG" "$HLOG" "$KLOG" "$CLOG" "$MLOG" "$ELOG" | head -3 | sed 's/^/        /'
elif ! grep -qiE "$FORBID" "$PLANT2"; then
  fail "Q13 the forbidden-claim scan cannot see a planted claim"
else
  ok "Q13 the D-402 run states its nineteen truthfulness strings (seventeen denials and the first and last owner questions), the D-400 run states its four reconciled strings (its dated self-denial, LO-01 DISCHARGED — D-401 with the owner's verbatim answer, and LD-02's re-classification), no log makes a forbidden lock or completion claim, and the scan refuses a planted one"
fi
rm -f "$PLANT2"
L_F="$(grep -E '^STATE_EXPECT=' "$PROJ/tests/foundation_smoke.sh" | head -1)"
L_I="$(grep -E '^STATE_EXPECT=' "$PROJ/tests/imprint_smoke.sh" | head -1)"
L_A="$(grep -E '^STATE_EXPECT=' "$PROJ/tests/alignment_smoke.sh" | head -1)"
L_H="$(grep -E '^STATE_EXPECT=' "$PROJ/tests/huntress_smoke.sh" | head -1)"
L_K="$(grep -E '^STATE_EXPECT=' "$PROJ/tests/hounds_smoke.sh" | head -1)"
L_C="$(grep -E '^STATE_EXPECT=' "$PROJ/tests/cohesion_smoke.sh" | head -1)"
L_M="$(grep -E '^STATE_EXPECT=' "$PROJ/tests/locomotion_smoke.sh" | head -1)"
L_E="$(grep -E '^STATE_EXPECT=' "$0" | head -1)"
NEEDLES_396=0
NEEDLES_398=0
NEEDLES_400=0
for r in foundation_smoke.sh imprint_smoke.sh alignment_smoke.sh huntress_smoke.sh hounds_smoke.sh cohesion_smoke.sh locomotion_smoke.sh cinder_smoke.sh; do
  grep -qxF "STATE_D396_LINE=\"$STATE_D396_LINE\"" "$PROJ/tests/$r" && NEEDLES_396=$((NEEDLES_396 + 1))
  grep -qxF "STATE_D398_LINE=\"$STATE_D398_LINE\"" "$PROJ/tests/$r" && NEEDLES_398=$((NEEDLES_398 + 1))
  grep -qxF "STATE_D400_LINE=\"$STATE_D400_LINE\"" "$PROJ/tests/$r" && NEEDLES_400=$((NEEDLES_400 + 1))
done
CNT_OK=1
for r in imprint_smoke.sh alignment_smoke.sh huntress_smoke.sh hounds_smoke.sh cohesion_smoke.sh locomotion_smoke.sh cinder_smoke.sh; do
  for p in 'PIN_F_CHECKS=85' 'PIN_F_DEFERRED=11' 'PIN_I_CHECKS=101' 'PIN_I_DEFERRED=16'; do
    grep -qx "$p" "$PROJ/tests/$r" || CNT_OK=0
  done
done
for r in alignment_smoke.sh huntress_smoke.sh hounds_smoke.sh cohesion_smoke.sh locomotion_smoke.sh cinder_smoke.sh; do
  for p in 'PIN_A_CHECKS=40' 'PIN_A_DEFERRED=10'; do grep -qx "$p" "$PROJ/tests/$r" || CNT_OK=0; done
done
for r in huntress_smoke.sh hounds_smoke.sh cohesion_smoke.sh locomotion_smoke.sh cinder_smoke.sh; do
  for p in 'PIN_H_CHECKS=53' 'PIN_H_DEFERRED=15' 'PIN_H_OWNER=0' 'PIN_H_DISCHARGED=4'; do grep -qx "$p" "$PROJ/tests/$r" || CNT_OK=0; done
done
for r in hounds_smoke.sh cohesion_smoke.sh locomotion_smoke.sh cinder_smoke.sh; do
  for p in 'PIN_K_CHECKS=45' 'PIN_K_DEFERRED=16' 'PIN_K_OWNER=0' 'PIN_K_DISCHARGED=6'; do grep -qx "$p" "$PROJ/tests/$r" || CNT_OK=0; done
done
for r in cohesion_smoke.sh locomotion_smoke.sh cinder_smoke.sh; do
  for p in 'PIN_C_CHECKS=40' 'PIN_C_DEFERRED=16' 'PIN_C_OWNER=0' 'PIN_C_DISCHARGED=5'; do
    grep -qx "$p" "$PROJ/tests/$r" || CNT_OK=0
  done
done
# AND THE NEWLY ACCEPTED LOCOMOTION COUNTS, carried by this stage's runner.
for p in 'PIN_M_CHECKS=33' 'PIN_M_DEFERRED=14' 'PIN_M_OWNER=0' 'PIN_M_DISCHARGED=4'; do
  grep -qx "$p" "$PROJ/tests/locomotion_smoke.sh" || CNT_OK=0
  grep -qx "$p" "$PROJ/tests/cinder_smoke.sh" || CNT_OK=0
done
if [ -n "$L_F" ] && [ "$L_F" = "$L_I" ] && [ "$L_I" = "$L_A" ] && [ "$L_A" = "$L_H" ] && [ "$L_H" = "$L_K" ] \
   && [ "$L_K" = "$L_C" ] && [ "$L_C" = "$L_M" ] && [ "$L_M" = "$L_E" ] \
   && [ "$L_E" = "STATE_EXPECT=\"$STATE_EXPECT\"" ] \
   && [ "$NEEDLES_396" = "8" ] && [ "$NEEDLES_398" = "8" ] && [ "$NEEDLES_400" = "8" ] && [ "$CNT_OK" -eq 1 ]; then
  ok "Q14 the EIGHT runners pin the IDENTICAL nine-fact state line (D-404 first act), each holds the D-396-era, D-398-era and (D-402) D-400-era lines as SUPERSEDED needles, and they carry the same accepted counts (85/11, 101/16, 40/10, 53/15 with 0 owed and 4 discharged, 45/16 with 0 owed and 6 discharged, 40/16 with 0 owed and 5 discharged, 33/14 with 0 owed and 4 discharged)"
else
  fail "Q14 the runners disagree on the state line, a needle (D-396 $NEEDLES_396 of 8, D-398 $NEEDLES_398 of 8, D-400 $NEEDLES_400 of 8) or a carried count (ok=$CNT_OK)"
fi

# ------------------------------------------------ Q15-Q19. isolation ----
say ""
say "[7/9] Isolation, the change set, the asset guards, the input map and the units (Q15-Q19)"
BASE="${FOUNDATION_BASELINE_DIR:-}"
N15_OK=1; N15_RAN=0; N_ARCH=0
for d in $PROTECTED; do
  f="$BASE/baseline_$d.sha256"
  if [ -n "$BASE" ] && [ -f "$f" ]; then
    N15_RAN=$((N15_RAN + 1))
    NOW="$(mktemp -t cinder_now)"
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
  NOW="$(mktemp -t cinder_now)"
  ( cd "$ROOT" && sed -E 's/^[0-9a-f]+  //' "$BASE/baseline_archives.sha256" | while IFS= read -r p; do
      shasum -a 256 "$p"; done ) | sort -k2 > "$NOW"
  N_ARCH="$(wc -l < "$NOW" | tr -d ' ')"
  diff -q "$BASE/baseline_archives.sha256" "$NOW" >/dev/null || { N15_OK=0; say "        an archive under assets/ CHANGED"; }
  rm -f "$NOW"
fi
if [ "$N15_RAN" -eq 7 ] && [ "$N15_OK" -eq 1 ]; then
  ok "Q15 game/, game2d/, game3d_spike/, game3d_boss_spike/, game3d_huntress_spike/ (README included), models/ and all $N_ARCH archives under assets/ are byte-identical to the pre-work baseline"
elif [ "$N15_RAN" -eq 0 ]; then
  skip "Q15 baselines not supplied (set FOUNDATION_BASELINE_DIR) — NOT a pass"
else
  fail "Q15 a protected tree or archive changed, or a baseline is missing ($N15_RAN of 7 measured)"
fi
G3="${D402_BASELINE_GAME3D:-}"
if [ -n "$G3" ] && [ -f "$G3" ]; then
  NOW="$(mktemp -t cinder_now)"
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
    ok "Q16 inside game3d/: exactly the $(printf '%s\n' "$EXP_MOD" | wc -l | tr -d ' ') declared files changed and the $(printf '%s\n' "$EXP_NEW" | wc -l | tr -d ' ') declared files are new — EVERY other authored file is byte-identical (the ACCEPTED foundation suite, project.godot, the cohort, hound, Huntress, Imprint, combat, world and view code, scenes, the asset trees, evidence 01-39); a planted undeclared change is refused"
  else
    fail "Q16 the game3d/ change set differs from the declared set"
    say "        undeclared/missing modifications:"; diff <(printf '%s\n' "$MODIFIED") <(printf '%s\n' "$EXP_MOD") | grep -E '^[<>]' | head -8 | sed 's/^/          /'
    say "        undeclared/missing additions:";    diff <(printf '%s\n' "$ADDED") <(printf '%s\n' "$EXP_NEW") | grep -E '^[<>]' | head -8 | sed 's/^/          /'
    [ -n "$REMOVED" ] && { say "        removed:"; printf '%s\n' "$REMOVED" | head -5 | sed 's/^/          /'; }
  fi
  rm -f "$NOW"
else
  skip "Q16 the pre-D-400 game3d/ listing not supplied (set D402_BASELINE_GAME3D) — NOT a pass"
fi
# Q17 — NO NEW ASSET, NO ART, NO VFX, NO AUDIO, NO .pxo, the four trees.
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
# THE ONLY D-402 FILE ALLOWED TO REACH AN ASSET is the trap, and it must do it
# through the MANIFEST's own constant, never a hard-coded path.
CINDER_HARD="$(grep -lF 'res://assets' "$PROJ"/scripts/cinder/*.gd 2>/dev/null | head -1)"
CINDER_MANIFEST="$(grep -lF 'AssetManifest.ruins(' "$PROJ/scripts/cinder/cinder_trap.gd" 2>/dev/null | head -1)"
# EXACTLY THE FOUR DECLARED FILES ARE NEW under the ruins directory, and nothing
# else from that archive came with them.
TRAPFILES="$(cd "$PROJ" && ls assets/third_party/quaternius/ultimate_modular_ruins/ | grep -ci 'beartrap' || true)"
STRAY="$(cd "$PROJ" && find assets -type f \( -name '*.fbx' -o -name '*.blend' -o -iname '*trapdoor*' \) | head -1)"
# THE ASSET TREE GREW BY EXACTLY THE SIX DECLARED FILES AND NOTHING ELSE.
# CORRECTED DURING THE D-402 WORK, AND DISCLOSED: this guard was first written --
# scaffolded from the D-400 runner, whose stage added NO asset -- demanding the
# count be UNCHANGED, which is false of a stage that deliberately imports two
# placeholder bodies. It now demands the ARITHMETIC instead: 78 + 6 = 84, the
# six being BearTrap_Open/.Closed .obj + .mtl + .import. An undeclared seventh
# file fails it exactly as an unchanged count would have.
ASSET_FILES_BEFORE="$( [ -n "${D402_BASELINE_GAME3D:-}" ] && [ -f "$D402_BASELINE_GAME3D" ] \
  && sed -E 's/^[0-9a-f]+  game3d\///' "$D402_BASELINE_GAME3D" | grep -c '^assets/' )"
ASSET_FILES_NOW="$(cd "$PROJ" && find assets -type f | wc -l | tr -d ' ')"
ASSET_DELTA_OK=1
if [ -n "$ASSET_FILES_BEFORE" ]; then
  [ "$ASSET_FILES_NOW" = "$(( ASSET_FILES_BEFORE + 6 ))" ] || ASSET_DELTA_OK=0
fi
if [ -z "$PXO" ] && [ "$TREES" = "$EXPECT_TREES" ] && [ -z "$AUDIO" ] && [ -z "$BAD" ] && [ "$DECLARED29" = "33" ] \
   && [ -z "$CINDER_HARD" ] && [ -n "$CINDER_MANIFEST" ] && [ "$TRAPFILES" = "6" ] && [ -z "$STRAY" ] \
   && [ "$ASSET_DELTA_OK" -eq 1 ]; then
  ok "Q17 no .pxo, no audio, no dog, wolf, Ultimate Monsters, VFX or Prey file in game3d/; the manifest declares 33 third-party files (29 + the four D-402 ones); no D-402 script hard-codes an asset path and the trap reaches its bodies through the MANIFEST's constant; exactly SIX bear-trap files exist under the ruins directory (two .obj, two .mtl, two .import) and NO .fbx, .blend or Trapdoor came with them; the asset tree grew by EXACTLY those six and nothing else (${ASSET_FILES_BEFORE:-?} + 6 = $ASSET_FILES_NOW); exactly the four quaternius trees in the repository"
else
  fail "Q17 pxo='$PXO' trees='$TREES' audio='$AUDIO' excluded='$BAD' declared=$DECLARED29 hard-coded='$CINDER_HARD' via-manifest='$CINDER_MANIFEST' trap files=$TRAPFILES stray='$STRAY' assets ${ASSET_FILES_BEFORE:-?} -> $ASSET_FILES_NOW (want +6)"
fi
# Q18 — THE INPUT MAP IS UNCHANGED: the 29 accepted actions, in order, and NO more.
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
  ok "Q18 project.godot declares EXACTLY the 29 accepted actions, unchanged and in order — D-400 adds NONE (29 stays 29); move_command is still bound to a mouse button; no W/A/S/D; a planted extra action is refused"
else
  fail "Q18 actions '$ACT_LIST' | move_command mouse events $MOUSE | W/A/S/D=$WASD"
fi
# Q19 — THE UNITS, stated where they are owed.
INV="$ROOT/docs/testing/D402_CINDER_FIELD_OWED_CRITERIA_INVENTORY.md"
OWED_N="$(awk '/^const OWED := \[/{f=1; next} f&&/^\]/{exit} f' "$PROJ/tests/cinder_verification.gd" | grep -cE '^\s*"E[0-9][0-9]_')"
RUNNER_N="$(grep -oE 'Q[0-9][0-9]' "$0" | sort -u | wc -l | tr -d ' ')"
if [ -f "$INV" ] && grep -qF '**185**' "$INV" && grep -qF '**48**' "$INV" \
   && grep -qF '**24**' "$INV" && grep -qF '`E01`' "$INV" && grep -qF '`Q01`' "$INV" \
   && [ "$OWED_N" = "48" ] && [ "$RUNNER_N" = "24" ] && grep -qF '24 RUNNER CHECKS in tests/cinder_smoke.sh' "$ELOG"; then
  ok "Q19 the inventory states 185 OWED CRITERIA, 48 EXECUTABLE CHECKS and 24 RUNNER CHECKS; the suite owes $OWED_N and this runner makes $RUNNER_N; the suite's log names all three — different units, none a synonym"
else
  fail "Q19 units: inventory present=$([ -f "$INV" ] && echo yes || echo no), suite owes $OWED_N, runner makes $RUNNER_N"
fi

# ------------------------------------------- Q20-Q21. rendered evidence ----
say ""
say "[8/9] Rendered evidence is opt-in and bounded (Q20)"
EV_AFTER="$(cd "$PROJ" && for e in $EV_FRAMES; do [ -f "evidence/$e.png" ] && shasum -a 256 "evidence/$e.png"; done)"
CEIL_OK=0
grep -qE 'CAP_WAITED" -lt "\$CEILING"' "$0" && [ "$CEILING" -le 120 ] && CEIL_OK=1
if [ "$WITH_EVIDENCE" -eq 0 ] && [ "$EV_BEFORE" = "$EV_AFTER" ] && [ "$CEIL_OK" -eq 1 ]; then
  ok "Q20 this plain run was HEADLESS ONLY and left the evidence untouched; a rendered run is opt-in (--with-evidence) with a hard ${CEILING} s ceiling per capture"
elif [ "$WITH_EVIDENCE" -eq 1 ] && [ "$CEIL_OK" -eq 1 ] && [ -z "$EV_RESULT" ]; then
  ok "Q20 rendering was OPTED IN; each of the nine captures reached the state its name claims, finished inside its ${CEILING} s ceiling and exited 0"
else
  fail "Q20 evidence changed without opting in, a capture timed out or refused its state ($EV_RESULT), or the ceiling is missing"
fi
say ""
say "[9/9] This stage's nine captures (Q21) and the accepted D-392-loadout fixture (Q22)"
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
  ok "Q21 all nine D-402 captures (46-54) exist at 1920x1080 — accepted evidence 01-45 is untouched (Q18)"
else
  fail "Q21 the D-402 evidence is missing or mis-sized"
fi
# Q22 — THE ACCEPTED FIXTURE AND THE BANNERS. The declared D-392-loadout fixture
# is called by the four accepted suites (once each), the D-396 suite and THIS
# stage's suite -- NOT by the D-398 or D-400 suites, which run on the review
# loadout; and in the runtime only by the capture path and its definition.
#
# CORRECTED DURING THE D-402 WORK, AND DISCLOSED: scaffolded from the D-400
# runner, this guard first asserted the D-402 suite did NOT call it, which the
# suite made false. The D-402 suite calls it TWICE, and both calls measure the
# ACCEPTED loadout rather than its own: `E08` restores it to measure the
# PRE-EXISTING 36 / 35 LIFE CONVERSION overflow (`FD-08`, disclosed and not
# repaired), and `E39` restores it to prove binding 7 is EMPTY there. The count
# is pinned at 2 so a third, casual use would be caught. The accepted D-396
# check `B09` was re-scoped one for one in the same change: 5 + 1 = 6 callers.
#
# Every log shows the D-396, D-398, D-400 and D-402 stages exactly once, through
# their banners. Paths are read LINE BY LINE (this path has spaces).
CALLERS="$(grep -lF 'restore_accepted_d392_loadout(' "$PROJ"/tests/*.gd | while IFS= read -r f; do basename "$f"; done | sort | tr '\n' ' ')"
RT_CALLERS="$(grep -rlF 'restore_accepted_d392_loadout(' "$PROJ/scripts" | while IFS= read -r f; do basename "$f"; done | sort | tr '\n' ' ')"
ONCE=1
for s in foundation imprint alignment huntress; do
  N="$(grep -cF 'main.get("hounds").restore_accepted_d392_loadout()' "$PROJ/tests/${s}_verification.gd")"
  [ "$N" = "1" ] || ONCE=0
done
BANNERS=1
for L in "$FLOG" "$ILOG" "$ALOG" "$HLOG" "$KLOG" "$CLOG" "$MLOG" "$ELOG"; do
  N6="$(grep -cF 'RIFTWROUGHT — KINDRED HOUNDS STAGE  (D-396, 2026-09-19)' "$L")"
  N8="$(grep -cF 'RIFTWROUGHT — MOBILE MINION COHESION STAGE  (D-398, 2026-09-19)' "$L")"
  N9="$(grep -cF 'RIFTWROUGHT — PLAYER LOCOMOTION REDIRECTION STAGE  (D-400, 2026-09-20)' "$L")"
  N10="$(grep -cF 'RIFTWROUGHT — CINDER FIELD STAGE  (D-402, 2026-09-20)' "$L")"
  { [ "$N6" = "1" ] && [ "$N8" = "1" ] && [ "$N9" = "1" ] && [ "$N10" = "1" ]; } || BANNERS=0
done
E_CALLS="$(grep -cF 'restore_accepted_d392_loadout()' "$PROJ/tests/cinder_verification.gd")"
COHESION_FREE=1
for s in cohesion locomotion; do
  grep -qF 'restore_accepted_d392_loadout(' "$PROJ/tests/${s}_verification.gd" && COHESION_FREE=0
done
if [ "$CALLERS" = "alignment_verification.gd cinder_verification.gd foundation_verification.gd hounds_verification.gd huntress_verification.gd imprint_verification.gd " ] \
   && [ "$RT_CALLERS" = "foundation_main.gd hound_runtime.gd " ] && [ "$ONCE" -eq 1 ] && [ "$BANNERS" -eq 1 ] \
   && [ "$E_CALLS" = "2" ] && [ "$COHESION_FREE" -eq 1 ] && [ "$LEAK" = "0" ]; then
  ok "Q22 the accepted D-392-loadout fixture is called by the four accepted suites (once each in start-up), the D-396 suite and THIS suite exactly twice — E08 for the pre-existing 36 / 35 overflow and E39 for the empty binding 7 — and NOT by the D-398 or D-400 suites, which run on the review loadout; in the runtime only by the capture path and its definition; every log shows the D-396, D-398, D-400 and D-402 stages once each, and no D-402 row leaks into an accepted log"
else
  fail "Q22 fixture callers '$CALLERS', runtime '$RT_CALLERS', once each=$ONCE, D-402 calls=$E_CALLS, D-398/D-400 free=$COHESION_FREE, banners=$BANNERS, leaked rows=$LEAK"
fi

# Q23 — THE ASSET INTAKE, VERIFIED AT THE SHELL LEVEL, INDEPENDENTLY OF THE SUITE.
# The four files on disk must hash to the ARCHIVE ENTRIES they were copied from,
# and the SOURCE ARCHIVE must be byte-identical afterwards: "preserve the source
# archive byte-identically" is the ruling's own condition on the intake.
say ""
say "[9/9] The placeholder trap intake, verified against the archive itself (Q23)"
ARCHIVE="$ROOT/assets/Quaternius Assets/Ultimate Modular Ruins Pack - Aug 2021-20260917T104959Z-1-001.zip"
ARCHIVE_SHA="a35c9fc06eaca38b2c0f24e58f838806b7b2c5ec0d1079bd0df1d1b24e28483a"
RUINS="$PROJ/assets/third_party/quaternius/ultimate_modular_ruins"
INTAKE_OK=1
INTAKE_ROWS=""
for spec in "BearTrap_Open.obj:f501c675071b458070baa0e7a1c3fe1f2f5bd4fa3ea3dfdebe58629d25471226" \
            "BearTrap_Open.mtl:3cf25b84cfa42802c41f102fc758d87a447e625b946b0cc9d5a04564bf822157" \
            "BearTrap_Closed.obj:9e5a3870d37f6e9a69b99060602829b2c3e3d50b86957b731d3d74fa6c0d90be" \
            "BearTrap_Closed.mtl:8a8406e94a99976870b218dfdd0d60c65bee3164ea2e4d79d25701dd4766f80f"; do
  NAME="${spec%%:*}"; WANT="${spec#*:}"
  GOT="$(shasum -a 256 "$RUINS/$NAME" 2>/dev/null | cut -d' ' -f1)"
  if [ "$GOT" = "$WANT" ]; then INTAKE_ROWS="$INTAKE_ROWS $NAME=OK"; else INTAKE_OK=0; INTAKE_ROWS="$INTAKE_ROWS $NAME=MISMATCH"; fi
done
ARCH_NOW="$(shasum -a 256 "$ARCHIVE" 2>/dev/null | cut -d' ' -f1)"
MAPS="$(grep -l 'map_' "$RUINS"/BearTrap_*.mtl 2>/dev/null | head -1)"
if [ "$INTAKE_OK" -eq 1 ] && [ "$ARCH_NOW" = "$ARCHIVE_SHA" ] && [ -z "$MAPS" ]; then
  ok "Q23 all four placeholder files hash to the CC0 archive entries they were copied from ($INTAKE_ROWS ); the SOURCE ARCHIVE is byte-identical afterwards ($ARCHIVE_SHA); and neither .mtl references a texture"
else
  fail "Q23 intake$INTAKE_ROWS | archive now '$ARCH_NOW' want '$ARCHIVE_SHA' | .mtl naming a texture: '$MAPS'"
fi

# Q24 — THE OWNER'S DISCLOSURE, VISIBLE IN THE RUN. "Do not increase Capacity
# merely to make the review loadout fit ... disclose exactly what changed." The
# run itself must say what the loadout was, what it became, and that nothing was
# replaced or disabled to make room.
DISCLOSED=""
for s in "the accepted D-396 review loadout" \
         "Cinder Field took binding 7 (index 6) — EMPTY before, held after" \
         "every OTHER binding is byte-identical before and after" \
         "nothing replaced, disabled or deleted" \
         "the budget is UNCHANGED at 30 + 5 = 35" \
         "34 / 35 reserving Mana" \
         "35 / 35 in LIFE CONVERSION" \
         "no D-402 file assigns a Capacity value"; do
  grep -qF "$s" "$ELOG" || DISCLOSED="$DISCLOSED | $s"
done
if [ -z "$DISCLOSED" ]; then
  ok "Q24 the run DISCLOSES exactly what the review loadout change was: the measured D-396 loadout before it, Cinder Field on the previously EMPTY binding 7, every other binding byte-identical, nothing replaced, disabled or deleted, the budget unchanged at 30 + 5 = 35, and the arithmetic in BOTH reservation states (34 / 35 and 35 / 35)"
else
  fail "Q24 the run does NOT disclose:$DISCLOSED"
fi

# ------------------------------------------------------------------ verdict --
say ""
say "========================================================================"
say "UNITS: 24 RUNNER CHECKS here · 48 EXECUTABLE CHECKS · 185 OWED CRITERIA — different units."
say "$STATE_EXPECT"
if [ "$FAILED" -eq 0 ] && [ "$SKIPPED" -eq 0 ]; then
  say "CINDER RUNNER: PASS (24 runner checks)"
elif [ "$FAILED" -eq 0 ]; then
  say "CINDER RUNNER: INCOMPLETE — $SKIPPED runner check(s) SKIPPED for lack of a baseline; NOT a pass"
  FAILED=1
else
  say "CINDER RUNNER: FAIL"
fi
say "========================================================================"
# Set CINDER_LOG_DIR to keep the eight suite logs (a run of record cites them).
if [ -n "${CINDER_LOG_DIR:-}" ] && [ -d "$CINDER_LOG_DIR" ]; then
  cp "$FLOG" "$CINDER_LOG_DIR/foundation.log"; cp "$ILOG" "$CINDER_LOG_DIR/imprint.log"
  cp "$ALOG" "$CINDER_LOG_DIR/alignment.log"; cp "$HLOG" "$CINDER_LOG_DIR/huntress.log"
  cp "$KLOG" "$CINDER_LOG_DIR/hounds.log"; cp "$CLOG" "$CINDER_LOG_DIR/cohesion.log"
  cp "$MLOG" "$CINDER_LOG_DIR/locomotion.log"; cp "$ELOG" "$CINDER_LOG_DIR/cinder.log"
fi
rm -f "$FLOG" "$ILOG" "$ALOG" "$HLOG" "$KLOG" "$CLOG" "$MLOG" "$ELOG"
exit "$FAILED"
