#!/usr/bin/env bash
# =============================================================================
# RIFTWROUGHT — THE HUNTRESS SPLINTER SHOT STAGE RUNNER  (D-392, 2026-09-19)
# =============================================================================
#
# Runs ALL FOUR game3d/ suites headless against the final code: the ACCEPTED
# D-373 foundation suite, the ACCEPTED D-376 Imprint suite and the ACCEPTED
# D-383 alignment suite as REGRESSIONS, then this stage's own suite. It checks
# their summaries, owed lists, printed rows, the state line, truthfulness, the
# isolation of every protected tree, the game3d/ change set, the placeholder
# intake against its archives, the input map and the rendered evidence.
#
#   tests/huntress_smoke.sh                  headless only (the default)
#   tests/huntress_smoke.sh --with-evidence  also RENDERS frames 16-20 and 23 first,
#                                            each under a hard 120 s ceiling
#
# Set FOUNDATION_BASELINE_DIR to a directory of pre-work SHA-256 listings
# (baseline_<tree>.sha256, baseline_archives.sha256) to run W16 and W17; without
# it they print [SKIP] and are NOT counted as passes.
#
# =============================================================================
# UNITS. TWELVE COUNTS, AND NONE IS A SYNONYM FOR ANOTHER.
#
#   D-392: 21 RUNNER CHECKS here (W01-W21) · 53 EXECUTABLE CHECKS in
#          tests/huntress_verification.gd · 203 OWED CRITERIA in
#          docs/testing/D392_SPLINTER_SHOT_OWED_CRITERIA_INVENTORY.md
#          (57 and 207 until the owner removed Prey under D-393: 57 - 5 + 1 = 53,
#          207 - 26 + 22 = 203; rows 18 -> 15 SD and 5 -> 4 SO. True when written.)
#   D-380: 21 RUNNER CHECKS · 40 EXECUTABLE CHECKS · 162 OWED CRITERIA
#   D-375: 26 RUNNER CHECKS · 101 EXECUTABLE CHECKS · 149 OWED CRITERIA
#   D-370: 20 RUNNER CHECKS · 85 EXECUTABLE CHECKS · 125 OWED CRITERIA
# =============================================================================
#
# THIS RUNNER VERIFIES A STAGE DELIVERED OPEN. It accepts nothing. It is not
# P2, not campaign production, not final animation, not final VFX and not the
# full Huntress, and it locks no number.
# (True when written. D-394 ACCEPTED and CLOSED the stage; it is re-run here as a
# REGRESSION under the D-396 Kindred Hounds stage, whose own runner is
# tests/hounds_smoke.sh.)
#
# RE-PINNED UNDER D-396, AS ITS FIRST ACT, EXACTLY AS D-394 SECTION 7 RECOMMENDED.
# The runner STILL has 21 RUNNER CHECKS; these moved IN PLACE, one for one, in
# the same change as the artifact they guard:
#   * STATE_EXPECT (W13, W15): the four-fact line -> the five-fact line, and every
#     runner now also holds the D-392-era line as a SUPERSEDED needle;
#   * W05, W10, W11: the D-392 suite's four SO- rows were ANSWERED under D-394 and
#     print DISCHARGED — D-394 with their text preserved: owed 4 -> 0,
#     discharged 0 -> 4 (4 - 4 = 0; 0 + 4 = 4; ZERO DELETED). The summary line
#     gained its discharged count, and W10's third alteration now moves THAT;
#   * W13: the self-acceptance needles follow the state -- the open D-396 stage
#     called accepted, or the D-392 stage accepting ITSELF, not the accepted fact;
#   * W14: the self-denial string and the "ONLY Splinter Shot" denial follow their
#     dated rewording; the first and last owner questions are sought as
#     DISCHARGED rows; "Kindred Hounds are implemented" leaves the forbidden list
#     (D-396 makes it true) and "Coursing Hounds are implemented" takes its place;
#   * W17: a D-392 DELIVERY-TIME claim no baseline can satisfy after D-396 -- it
#     prints [DECLARED] without a pre-D-392 listing (the D-380 runner's T17 is in
#     the same state since D-392); D-396's change set is tests/hounds_smoke.sh Y15;
#   * W19: ONE diagnostic input action added under D-396 (26 + 1 = 27), named.
#
# RE-PINNED UNDER D-398, AS ITS FIRST ACT, EXACTLY AS D-397 SECTION 6 RECOMMENDED.
# The runner STILL has 21 RUNNER CHECKS; these moved IN PLACE, one for one:
#   * STATE_EXPECT (W13, W15): the five-fact line -> the six-fact line, and every
#     runner now also holds the D-396-era line as a SUPERSEDED needle;
#   * W13: the self-acceptance needles follow the state -- the open D-398 stage
#     called accepted, or the D-392 or D-396 stage accepting ITSELF, not the
#     accepted facts;
#   * W19: TWO diagnostic input actions added under D-398 (27 + 2 = 29), named.
# (Re-run here as a REGRESSION under the D-398 mobile minion cohesion stage, whose
# own runner is tests/cohesion_smoke.sh.)
# =============================================================================
set -uo pipefail

GODOT="${GODOT:-/Applications/Godot.app/Contents/MacOS/Godot}"
HERE="$(cd "$(dirname "$0")" && pwd)"
PROJ="$(cd "$HERE/.." && pwd)"
ROOT="$(cd "$PROJ/.." && pwd)"
FLOG="$(mktemp -t hunt_foundation)"
ILOG="$(mktemp -t hunt_imprint)"
ALOG="$(mktemp -t hunt_alignment)"
HLOG="$(mktemp -t hunt_stage)"
FAILED=0
SKIPPED=0
DECLARED_CLAIMS=0
WITH_EVIDENCE=0
[ "${1:-}" = "--with-evidence" ] && WITH_EVIDENCE=1

# THE ONE STATE LINE, identical in all four runners (W15 compares them).
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
PIN_A_DEFERRED=10
PIN_H_CHECKS=53
PIN_H_DEFERRED=15
# 4 -> 0 UNDER D-396 (first act): SO-01, SO-02, SO-03, SO-05 were ANSWERED under
# D-394 and print DISCHARGED — D-394. 4 - 4 = 0 owed; 0 + 4 = 4 discharged.
PIN_H_OWNER=0
PIN_H_DISCHARGED=4

# THE DECLARED CHANGE SET INSIDE game3d/ SINCE THE PRE-D-392 BASELINE — pinned in
# BOTH directions by W17. Everything else is byte-identical.
DECLARED_MODIFIED="README.md
project.godot
scripts/assets/asset_manifest.gd
scripts/control/player_controller.gd
scripts/core/prod_config.gd
scripts/debug/debug_overlay.gd
scripts/foundation_main.gd
scripts/imprint/imprint.gd
scripts/imprint/imprint_config.gd
scripts/imprint/review_hud.gd
scripts/imprint/skill_configuration.gd
scripts/imprint/skill_runtime.gd
tests/alignment_smoke.sh
tests/alignment_verification.gd
tests/foundation_smoke.sh
tests/foundation_verification.gd
tests/imprint_smoke.sh
tests/imprint_verification.gd"
# D-393: huntress_prey, prey_marker and prey_eligibility REMOVED; hit_eligibility
# (the same predicate as a general rule) ADDED -- 17 - 3 + 1 = 15. Frames 21 and 22
# (the Prey frames) REMOVED -- 8 - 2 = 6; the rest keep their numbers.
D392_SCRIPTS="arrow_collision bone_pose bow_presentation bow_retargeter combat_entity_registry hit_eligibility huntress_bow_animator huntress_config huntress_content huntress_pose_modifier huntress_review_hud huntress_runtime impact_flash kaykit_clip_source splinter_arrow"
EV_FRAMES="16_d392_launch 17_d392_draw_gameplay 18_d392_draw_closeup 19_d392_release_gameplay 20_d392_release_closeup 23_d392_overlap"
DECLARED_NEW="$(
  printf '%s\n' \
    assets/third_party/huntress_placeholder/SOURCE_AND_LICENSE.md \
    assets/third_party/huntress_placeholder/kaykit_character_animations/Rig_Medium_CombatRanged.glb \
    assets/third_party/huntress_placeholder/kaykit_character_animations/Rig_Medium_CombatRanged.glb.import \
    assets/third_party/huntress_placeholder/kaykit_character_animations/Rig_Medium_MovementAdvanced.glb \
    assets/third_party/huntress_placeholder/kaykit_character_animations/Rig_Medium_MovementAdvanced.glb.import \
    assets/third_party/huntress_placeholder/licenses/LICENSE_kaykit_character_animations_CC0.txt \
    assets/third_party/huntress_placeholder/licenses/LICENSE_quaternius_medieval_weapons_CC0.txt \
    assets/third_party/huntress_placeholder/quaternius_medieval_weapons/Arrow.mtl \
    assets/third_party/huntress_placeholder/quaternius_medieval_weapons/Arrow.obj \
    assets/third_party/huntress_placeholder/quaternius_medieval_weapons/Arrow.obj.import \
    assets/third_party/huntress_placeholder/quaternius_medieval_weapons/Bow_Wooden.mtl \
    assets/third_party/huntress_placeholder/quaternius_medieval_weapons/Bow_Wooden.obj \
    assets/third_party/huntress_placeholder/quaternius_medieval_weapons/Bow_Wooden.obj.import \
    tests/huntress_smoke.sh tests/huntress_verification.gd tests/huntress_verification.gd.uid
  for s in $D392_SCRIPTS; do printf 'scripts/huntress/%s.gd\nscripts/huntress/%s.gd.uid\n' "$s" "$s"; done
  for e in $EV_FRAMES; do printf 'evidence/%s.png\nevidence/%s.png.import\n' "$e" "$e"; done
)"
# The protected trees, each byte-identical to its pre-work listing (W16).
PROTECTED="game game2d game3d_spike game3d_boss_spike game3d_huntress_spike models"
# The D-392 intake: [in-tree path relative to the placeholder root] <- [archive] :: [entry].
PLACEHOLDER="$PROJ/assets/third_party/huntress_placeholder"
KAYKIT_ZIP="$ROOT/assets/KayKit_Character_Animations_1.1.zip"
WEAPONS_ZIP="$ROOT/assets/Quaternius Assets/Medieval Weapons Pack by @Quaternius-20260917T104936Z-1-001.zip"

say()  { printf '%s\n' "$*"; }
fail() { say "  [FAIL] $*"; FAILED=1; }
ok()   { say "  [ OK ] $*"; }
skip() { say "  [SKIP] $*"; SKIPPED=$((SKIPPED + 1)); }

say "========================================================================"
say "RIFTWROUGHT HUNTRESS SPLINTER SHOT STAGE RUNNER (D-392)"
say "Headless by default. Rendered evidence is opt-in via --with-evidence."
say "It runs the ACCEPTED D-373, D-376 and D-383 suites as REGRESSIONS, then this stage —"
say "ACCEPTED and CLOSED under D-394, re-run as a regression under the D-400 player locomotion redirection stage."
say "========================================================================"

# The evidence as it stands BEFORE this run -- W20 proves a plain run leaves it alone.
EV_BEFORE="$(cd "$PROJ" && for e in $EV_FRAMES; do [ -f "evidence/$e.png" ] && shasum -a 256 "evidence/$e.png"; done)"

# --------------------------------------------- 0. opt-in evidence, rendered FIRST
EV_RESULT=""
CEILING=120
if [ "$WITH_EVIDENCE" -eq 1 ]; then
  say ""
  say "[0/9] Rendering this stage's six captures (16-20, 23) FIRST (opt-in) — never 01-15"
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

# ------------------------------------------------------------ W01. import ----
say ""
say "[1/9] Import pass (W01)"
"$GODOT" --headless --path "$PROJ" --import >/dev/null 2>&1
IMPORTED="$(ls "$PROJ/.godot/imported" 2>/dev/null | wc -l | tr -d ' ')"
PLACEHOLDER_IMPORTED="$(ls "$PROJ/.godot/imported" 2>/dev/null | grep -cE '^(Rig_Medium_CombatRanged|Rig_Medium_MovementAdvanced)\.glb-|^(Bow_Wooden|Arrow)\.obj-' || true)"
if [ "$IMPORTED" -gt 0 ] && [ "$PLACEHOLDER_IMPORTED" -ge 4 ]; then
  ok "W01 assets imported ($IMPORTED entries, the four placeholder models among them) — a fresh checkout verifies"
else
  fail "W01 the import pass produced $IMPORTED entries ($PLACEHOLDER_IMPORTED placeholder)"
fi

# ------------------------------------------------------ W02-W09. the suites --
say ""
say "[2/9] The four suites: D-373, D-376 and D-383 as REGRESSIONS, then D-392 (W02-W09)"
"$GODOT" --headless --path "$PROJ" --script res://tests/foundation_verification.gd >"$FLOG" 2>&1
F_RC=$?
"$GODOT" --headless --path "$PROJ" --script res://tests/imprint_verification.gd >"$ILOG" 2>&1
I_RC=$?
"$GODOT" --headless --path "$PROJ" --script res://tests/alignment_verification.gd >"$ALOG" 2>&1
A_RC=$?
"$GODOT" --headless --path "$PROJ" --script res://tests/huntress_verification.gd >"$HLOG" 2>&1
H_RC=$?
grep -E "^  \[(PASS|FAIL|UNREACHED) *\]" "$HLOG" | sed 's/^/    /' | head -70
grep -E "^(FOUNDATION VERIFICATION:|IMPRINT VERIFICATION:|ALIGNMENT VERIFICATION:|HUNTRESS VERIFICATION:)" \
  "$FLOG" "$ILOG" "$ALOG" "$HLOG" | sed "s|^[^:]*:|    |"

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
H_EXPECT="HUNTRESS VERIFICATION: PASS ($PIN_H_CHECKS checks: $PIN_H_CHECKS passed, 0 failed/unreached, $PIN_H_DEFERRED deferred, $PIN_H_OWNER owed to the owner, $PIN_H_DISCHARGED discharged)"
pin_summary W02 "$FLOG" FOUNDATION "$PIN_F_CHECKS" "$PIN_F_DEFERRED"
pin_summary W03 "$ILOG" IMPRINT "$PIN_I_CHECKS" "$PIN_I_DEFERRED"
pin_summary W04 "$ALOG" ALIGNMENT "$PIN_A_CHECKS" "$PIN_A_DEFERRED"
H_LINE="$(grep -E '^HUNTRESS VERIFICATION:' "$HLOG" | head -1)"
if [ "$H_LINE" = "$H_EXPECT" ]; then
  ok "W05 HUNTRESS summary matches EXACTLY: $PIN_H_CHECKS executable checks, $PIN_H_DEFERRED deferred rows, $PIN_H_OWNER owed to the owner, $PIN_H_DISCHARGED discharged (D-394)"
else
  fail "W05 HUNTRESS summary MISMATCH"; say "        expected: $H_EXPECT"; say "        actual  : $H_LINE"
fi
pin_owed W06 "$FLOG" "$PIN_F_CHECKS" F
pin_owed W07 "$ILOG" "$PIN_I_CHECKS" I
pin_owed W08 "$ALOG" "$PIN_A_CHECKS" A
pin_owed W09 "$HLOG" "$PIN_H_CHECKS" H

# ----------------------------------------------- W10. pins able to refuse ----
say ""
say "[3/9] Every summary pin PROVED able to refuse an altered value (W10)"
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
# D-396: the third alteration moves the DISCHARGED count (the owed count is 0).
H_ALT3="$(printf '%s' "$H_LINE" | sed "s/, $PIN_H_DISCHARGED discharged/, $((PIN_H_DISCHARGED - 1)) discharged/")"
if [ "$H_ALT1" != "$H_EXPECT" ] && [ "$H_ALT2" != "$H_EXPECT" ] && [ "$H_ALT3" != "$H_EXPECT" ] && [ "$H_LINE" = "$H_EXPECT" ]; then
  REFUSED=$((REFUSED + 1))
fi
if [ "$REFUSED" = "4" ]; then
  ok "W10 all four summary pins REFUSE an altered check count AND an altered deferred count (the D-392 pin also an altered discharged count) — replayed"
else
  fail "W10 only $REFUSED of 4 summary pins were proved able to refuse an altered value"
fi

# -------------------------------------------------- W11. printed rows ----
say ""
say "[4/9] Deferred, owed and discharged rows (W11)"
SD_ROWS="$(grep -cE '^  \[[^]]+\] SD-(0[4-9]|1[0-8]) ' "$HLOG")"
SO_ROWS="$(grep -cE '^  \[OWED-TO-OWNER\] SO-0[1235] ' "$HLOG")"
SD_PASS="$(grep -cE '^  \[(PASS|OK) *\] S[DO]-' "$HLOG")"
# D-393: SD-01..SD-03 and SO-04 (Prey) are WITHDRAWN -- none may print, and no
# printed row may name Prey. (Until D-393 SD01 had to print STILL OWED once.)
SD01="$(grep -cE '^  \[[^]]+\] (SD-0[123]|SO-04) ' "$HLOG")"
ROW_PREY="$(grep -E '^  \[[^]]+\] S[DO]-[0-9]+ ' "$HLOG" | grep -ci 'prey' || true)"
SD07="$(grep -cE '^  \[CARRIED — NOT FIXED *\] SD-07 ' "$HLOG")"
AM_DIS="$(grep -cE '^  \[DISCHARGED — D-383\] AM-0[1-5] ' "$ALOG")"
AM_KEPT="$(grep -cF "ORIGINAL ROW TEXT, PRESERVED VERBATIM (OWED-TO-OWNER): 'MEASURED" "$ALOG")"
A_OWNER="$(grep -cE '^  \[OWED-TO-OWNER *\] AM-[0-9]+ ' "$ALOG")"
# D-396 (first act): SO-01, SO-02, SO-03, SO-05 print DISCHARGED — D-394, each with
# its original text preserved; none prints OWED-TO-OWNER any more ($PIN_H_OWNER).
SO_DIS="$(grep -cE '^  \[DISCHARGED — D-394\] SO-0[1235] ' "$HLOG")"
SO_KEPT="$(grep -cF "ORIGINAL ROW TEXT, PRESERVED VERBATIM (OWED-TO-OWNER): '" "$HLOG")"
if [ "$SD_ROWS" = "$PIN_H_DEFERRED" ] && [ "$SO_ROWS" = "$PIN_H_OWNER" ] && [ "$SD_PASS" = "0" ] \
   && [ "$SO_DIS" = "$PIN_H_DISCHARGED" ] && [ "$SO_KEPT" = "$PIN_H_DISCHARGED" ] \
   && [ "$SD01" = "0" ] && [ "$ROW_PREY" = "0" ] && [ "$SD07" = "1" ] && [ "$AM_DIS" = "5" ] && [ "$AM_KEPT" = "5" ] && [ "$A_OWNER" = "0" ]; then
  ok "W11 the D-392 run prints $SD_ROWS SD- rows (SD-04..SD-18), none as a pass and none naming Prey; SO-01..03 and SO-05 print DISCHARGED — D-394 ($SO_DIS, text kept $SO_KEPT) and $SO_ROWS owed — the withdrawn Prey rows SD-01..03 and SO-04 print nowhere; SD-07 (the five polish debts) CARRIED — NOT FIXED; the D-380 suite prints AM-01..AM-05 DISCHARGED — D-383 with their original text ($AM_KEPT of 5), none owed"
else
  fail "W11 rows: SD $SD_ROWS, SO owed $SO_ROWS, SO discharged $SO_DIS (text kept $SO_KEPT), printed as pass $SD_PASS, withdrawn Prey rows printed $SD01, rows naming Prey $ROW_PREY, SD-07 $SD07, AM discharged $AM_DIS, text kept $AM_KEPT, AM owed $A_OWNER"
fi

# ---------------------------------------------------- W12. engine errors ----
say ""
say "[5/9] Engine-error guard (W12)"
ERRPAT='^(SCRIPT )?ERROR:|^USER ERROR:|^SCRIPT ERROR|Parse Error|Failed to load script'
SELF='Foundation_Signature_Move_THIS_DOES_NOT_EXIST'
SELF_N="$(grep -cF "$SELF" "$FLOG")"
F_REAL="$(grep -E "$ERRPAT" "$FLOG" | grep -vF "$SELF" || true)"
I_REAL="$(grep -E "$ERRPAT" "$ILOG" || true)"
A_REAL="$(grep -E "$ERRPAT" "$ALOG" || true)"
H_REAL="$(grep -E "$ERRPAT" "$HLOG" || true)"
PLANT="$(mktemp -t hunt_plant)"; cat "$HLOG" > "$PLANT"
printf 'SCRIPT ERROR: planted engine error, for guard proving only\n' >> "$PLANT"
if [ "$SELF_N" -lt 1 ]; then
  fail "W12 the accepted suite's guard-proving error line is missing — F12's proof is not intact"
elif [ -n "$F_REAL" ] || [ -n "$I_REAL" ] || [ -n "$A_REAL" ] || [ -n "$H_REAL" ]; then
  fail "W12 engine errors present:"
  printf '%s\n' "$F_REAL" "$I_REAL" "$A_REAL" "$H_REAL" | grep -v '^$' | head -12 | sed 's/^/        /'
elif ! grep -qE "$ERRPAT" "$PLANT"; then
  fail "W12 the error guard could NOT detect a planted error line"
else
  ok "W12 no engine error in any of the four logs beyond the one expected guard proof, and the guard refuses a planted error"
fi
rm -f "$PLANT"

# -------------------------------------- W13-W15. state line and truthfulness --
say ""
say "[6/9] The state line and truthfulness (W13-W15)"
BAD_STATE=0
for L in "$FLOG" "$ILOG" "$ALOG" "$HLOG"; do
  LINE="$(grep -E '^STATE: ' "$L" | head -1)"
  [ "$LINE" != "$STATE_EXPECT" ] && { BAD_STATE=1; say "        in $(basename "$L"): $LINE"; }
done
SUPERSEDED=0
grep -qxF "$STATE_D375_LINE" "$FLOG" "$ILOG" "$ALOG" "$HLOG" && SUPERSEDED=1
grep -qxF "$STATE_D380_LINE" "$FLOG" "$ILOG" "$ALOG" "$HLOG" && SUPERSEDED=1
grep -qxF "$STATE_D392_LINE" "$FLOG" "$ILOG" "$ALOG" "$HLOG" && SUPERSEDED=1
grep -qxF "$STATE_D396_LINE" "$FLOG" "$ILOG" "$ALOG" "$HLOG" && SUPERSEDED=1
grep -qxF "$STATE_D398_LINE" "$FLOG" "$ILOG" "$ALOG" "$HLOG" && SUPERSEDED=1
# D-402 (first act): the D-400-era line JOINS the superseded needles. 5 -> 6.
grep -qxF "$STATE_D400_LINE" "$FLOG" "$ILOG" "$ALOG" "$HLOG" && SUPERSEDED=1
# D-404 (first act): the D-402-era line JOINS the superseded needles. 6 -> 7.
grep -qxF "$STATE_D402_LINE" "$FLOG" "$ILOG" "$ALOG" "$HLOG" && SUPERSEDED=1
grep -qxF "STATE: DELIVERED and OPEN pending owner live review" "$FLOG" "$ILOG" "$ALOG" "$HLOG" && SUPERSEDED=1
# RE-SCOPED UNDER D-396 (first act), one for one: until D-396 this refused
# "SPLINTER SHOT STAGE ACCEPTED" and "D-392 (is|stage is) ACCEPTED" -- true when
# written; D-394 made the acceptance the OWNER's, and the state line now carries it.
# What is still false, and refused: the D-392 stage accepting ITSELF, and the OPEN
# D-396 stage called accepted.
# RE-SCOPED AGAIN UNDER D-398 (first act), one for one: D-397 made "KINDRED HOUNDS
# STAGE ACCEPTED" the OWNER's fact. What is still false, and refused: the D-392 or
# D-396 stage accepting ITSELF, and the OPEN D-398 stage called accepted.
# RE-SCOPED A THIRD TIME UNDER D-400 (first act), one for one: D-400 made "MOBILE
# MINION COHESION STAGE ACCEPTED" the OWNER's fact, so it leaves the pattern and
# the OPEN D-400 stage takes its place. What is still false, and refused: the
# D-392, D-396 or D-398 stage accepting ITSELF (D-398 delivered; D-400 accepted),
# and the OPEN D-400 stage called accepted.
# RE-SCOPED A FOURTH TIME UNDER D-402 (first act), one for one: D-401 made
# "PLAYER LOCOMOTION REDIRECTION STAGE ACCEPTED" the OWNER's fact, so it leaves
# the pattern and the OPEN D-402 Cinder Field stage takes its place. What is
# still false, and refused: the D-392, D-396, D-398 or D-400 stage accepting
# ITSELF (D-400 delivered; D-401 accepted), and the OPEN D-402 stage called
# accepted.
# RE-SCOPED UNDER D-404 (first act), one for one: D-403 made "CINDER FIELD
# STAGE ACCEPTED" the OWNER's fact -- it is in the state line itself -- so it
# leaves the pattern and the OPEN D-404 direct-click stage takes its place.
# "ACCEPTED and CLOSED (D-402)" joins what is still false: D-402 DELIVERED the
# Cinder Field stage and D-403 accepted it.
SELF_ACCEPT='PLAYER DIRECT-CLICK MOVEMENT CORRECTION STAGE ACCEPTED|D-404 (is|stage is) ACCEPTED|ACCEPTED and CLOSED \(D-402\)|ACCEPTED and CLOSED \(D-392\)|ACCEPTED and CLOSED \(D-396\)|D-396 (is|stage is) ACCEPTED|ACCEPTED and CLOSED \(D-398\)|ACCEPTED and CLOSED \(D-400\)'
ACCEPTS="$(grep -hE "$SELF_ACCEPT" "$FLOG" "$ILOG" "$ALOG" "$HLOG" | grep -v 'SELF_ACCEPT' | head -3 || true)"
PLANT3="$(mktemp -t hunt_plant3)"; printf 'PLAYER DIRECT-CLICK MOVEMENT CORRECTION STAGE ACCEPTED and CLOSED (D-404)\n' > "$PLANT3"
ALT_STATE="$(printf '%s' "$STATE_EXPECT" | sed 's/DELIVERED and OPEN pending owner live review (D-404)/ACCEPTED and CLOSED (D-404)/')"
if [ "$BAD_STATE" -eq 0 ] && [ "$SUPERSEDED" -eq 0 ] && [ -z "$ACCEPTS" ] && grep -qE "$SELF_ACCEPT" "$PLANT3" \
   && [ "$ALT_STATE" != "$STATE_EXPECT" ] && [ "$STATE_D380_LINE" != "$STATE_EXPECT" ] \
   && [ "$STATE_D392_LINE" != "$STATE_EXPECT" ] && [ "$STATE_D396_LINE" != "$STATE_EXPECT" ] \
   && [ "$STATE_D398_LINE" != "$STATE_EXPECT" ] && [ "$STATE_D400_LINE" != "$STATE_EXPECT" ] \
   && [ "$STATE_D402_LINE" != "$STATE_EXPECT" ]; then
  ok "W13 all four suites print the SAME exact nine-fact state line (D-404 first act); no superseded line (D-375, D-380, D-392, D-396, D-398, D-400, D-402, bare D-370) is printed; nothing claims a self-acceptance — and each of those scans refuses a planted line"
else
  fail "W13 state line differs ($BAD_STATE), a superseded line is printed ($SUPERSEDED), or a self-acceptance appears: $ACCEPTS"
fi
rm -f "$PLANT3"
W14_MISS=""
for s in "The D-392 stage IS NOT P2 and AUTHORIZES NO P2." \
         "IS NOT campaign production" \
         "it implemented ONLY Splinter Shot" \
         "IMPLEMENTS NO RIFT SHARDS" \
         "TEMPORARY PLACEHOLDER" \
         "NO VFX package is read or used" \
         "does NOT use the paid Quaternius Source edition" \
         "fixes NONE of the five accepted D-389 polish debts" \
         "LOCKS NO NUMBER" \
         "implements NO Prey: the owner removed it from the Huntress design under D-393" \
         "Huntress's Mark is a recorded FUTURE concept (D-393) and is NOT implemented" \
         "enables NO Pierce, Chain, Fork, additional projectile, explosion" \
         "IS NOT a UI foundation" \
         "modifies NO accepted spike" \
         "was delivered OPEN and never accepted itself: the owner ACCEPTED and CLOSED it under D-394" \
         "[DISCHARGED — D-394] SO-01 Splinter Shot's responsiveness at the provisional release timing." \
         "[DISCHARGED — D-394] SO-05 Whether projectile collision behaves predictably when targets overlap."; do
  grep -qF "$s" "$HLOG" || W14_MISS="$W14_MISS | $s"
done
# D-396 (first act): "Kindred Hounds (are|is) implemented" left this list -- D-396
# implements them -- and "Coursing Hounds (are|is) implemented" took its place.
FORBID='P2 is authorized|P1 is complete|final animation is (approved|accepted)|the release timing is locked|0\.5 s is locked|Coursing Hounds (are|is) implemented|the multi-target (Prey )?rule is (resolved|decided)|Mark is implemented|Prey is designated|production ready|pivot complete'
PLANT2="$(mktemp -t hunt_plant2)"; printf 'the release timing is locked\n' > "$PLANT2"
if [ -n "$W14_MISS" ]; then
  fail "W14 the D-392 run does NOT state:$W14_MISS"
elif grep -qiE "$FORBID" "$FLOG" "$ILOG" "$ALOG" "$HLOG"; then
  fail "W14 a run log makes a forbidden lock or completion claim"
elif ! grep -qiE "$FORBID" "$PLANT2"; then
  fail "W14 the forbidden-claim scan cannot see a planted claim"
else
  ok "W14 the D-392 run states its seventeen truthfulness strings (fifteen denials — the Prey removal and Huntress's Mark among them — and the first and last owner questions, now DISCHARGED — D-394), no log makes a forbidden claim, and the scan refuses a planted one"
fi
rm -f "$PLANT2"
L_F="$(grep -E '^STATE_EXPECT=' "$PROJ/tests/foundation_smoke.sh" | head -1)"
L_I="$(grep -E '^STATE_EXPECT=' "$PROJ/tests/imprint_smoke.sh" | head -1)"
L_A="$(grep -E '^STATE_EXPECT=' "$PROJ/tests/alignment_smoke.sh" | head -1)"
L_H="$(grep -E '^STATE_EXPECT=' "$0" | head -1)"
CNT_OK=1
grep -qx 'PIN_CHECKS=85' "$PROJ/tests/foundation_smoke.sh" || CNT_OK=0
grep -qx 'PIN_DEFERRED=11' "$PROJ/tests/foundation_smoke.sh" || CNT_OK=0
for r in imprint_smoke.sh alignment_smoke.sh huntress_smoke.sh; do
  for p in 'PIN_F_CHECKS=85' 'PIN_F_DEFERRED=11' 'PIN_I_CHECKS=101' 'PIN_I_DEFERRED=16'; do
    grep -qx "$p" "$PROJ/tests/$r" || CNT_OK=0
  done
done
for p in 'PIN_A_CHECKS=40' 'PIN_A_DEFERRED=10'; do
  grep -qx "$p" "$PROJ/tests/alignment_smoke.sh" || CNT_OK=0
  grep -qx "$p" "$PROJ/tests/huntress_smoke.sh" || CNT_OK=0
done
REFUSE_380=0
REFUSE_392=0
REFUSE_396=0
REFUSE_398=0
for r in foundation_smoke.sh imprint_smoke.sh alignment_smoke.sh huntress_smoke.sh; do
  grep -qxF "STATE_D380_LINE=\"$STATE_D380_LINE\"" "$PROJ/tests/$r" && REFUSE_380=$((REFUSE_380 + 1))
  grep -qxF "STATE_D392_LINE=\"$STATE_D392_LINE\"" "$PROJ/tests/$r" && REFUSE_392=$((REFUSE_392 + 1))
  grep -qxF "STATE_D396_LINE=\"$STATE_D396_LINE\"" "$PROJ/tests/$r" && REFUSE_396=$((REFUSE_396 + 1))
  grep -qxF "STATE_D398_LINE=\"$STATE_D398_LINE\"" "$PROJ/tests/$r" && REFUSE_398=$((REFUSE_398 + 1))
done
if [ -n "$L_F" ] && [ "$L_F" = "$L_I" ] && [ "$L_I" = "$L_A" ] && [ "$L_A" = "$L_H" ] \
   && [ "$L_H" = "STATE_EXPECT=\"$STATE_EXPECT\"" ] && [ "$CNT_OK" -eq 1 ] && [ "$REFUSE_380" = "4" ] \
   && [ "$REFUSE_392" = "4" ] && [ "$REFUSE_396" = "4" ] && [ "$REFUSE_398" = "4" ]; then
  ok "W15 the four runners pin the IDENTICAL state line, carry the same 85/11, 101/16 and 40/10 counts, and each holds the D-380 line, (D-396) the D-392-era line, (D-398) the D-396-era line AND (D-400) the D-398-era line as SUPERSEDED needles (R08, S14/S16/S17, T11/T12/T20, W13/W15 moved together)"
else
  fail "W15 the runners disagree on the state line or a carried count (counts ok=$CNT_OK, D-380 needles=$REFUSE_380 of 4, D-392 needles=$REFUSE_392 of 4, D-396 needles=$REFUSE_396 of 4, D-398 needles=$REFUSE_398 of 4)"
fi

# ------------------------------------------------ W16-W19. isolation ----
say ""
say "[7/9] Isolation, the change set, the intake and the input map (W16-W19)"
BASE="${FOUNDATION_BASELINE_DIR:-}"
W16_OK=1; W16_RAN=0
for d in $PROTECTED; do
  f="$BASE/baseline_$d.sha256"
  if [ -n "$BASE" ] && [ -f "$f" ]; then
    W16_RAN=$((W16_RAN + 1))
    NOW="$(mktemp -t hunt_now)"
    ( cd "$ROOT" && find "$d" -type f -print0 | sort -z | xargs -0 shasum -a 256 ) > "$NOW"
    if ! diff -q "$f" "$NOW" >/dev/null; then
      W16_OK=0; say "        $d/ CHANGED"
      diff "$f" "$NOW" | grep -E '^[<>]' | head -6 | sed 's/^/          /'
    fi
    rm -f "$NOW"
  fi
done
if [ -n "$BASE" ] && [ -f "$BASE/baseline_archives.sha256" ]; then
  W16_RAN=$((W16_RAN + 1))
  NOW="$(mktemp -t hunt_now)"
  ( cd "$ROOT" && sed -E 's/^[0-9a-f]+  //' "$BASE/baseline_archives.sha256" | while IFS= read -r p; do
      shasum -a 256 "$p"; done ) | sort -k2 > "$NOW"
  N_ARCH="$(wc -l < "$NOW" | tr -d ' ')"
  diff -q "$BASE/baseline_archives.sha256" "$NOW" >/dev/null || { W16_OK=0; say "        an archive under assets/ CHANGED"; }
  rm -f "$NOW"
fi
if [ "$W16_RAN" -eq 7 ] && [ "$W16_OK" -eq 1 ]; then
  ok "W16 game/, game2d/, game3d_spike/, game3d_boss_spike/, game3d_huntress_spike/ (README included), models/ and all $N_ARCH archives under assets/ are byte-identical to the pre-work baseline"
elif [ "$W16_RAN" -eq 0 ]; then
  skip "W16 baselines not supplied (set FOUNDATION_BASELINE_DIR) — NOT a pass"
else
  fail "W16 a protected tree or archive changed, or a baseline is missing ($W16_RAN of 7 measured)"
fi
if [ -n "$BASE" ] && [ -f "$BASE/baseline_game3d.sha256" ]; then
  NOW="$(mktemp -t hunt_now)"
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
    ok "W17 inside game3d/: exactly the $(printf '%s\n' "$EXP_MOD" | wc -l | tr -d ' ') declared files changed and the $(printf '%s\n' "$EXP_NEW" | wc -l | tr -d ' ') declared files are new — EVERY other authored file is byte-identical (combat, world, view, the rig corpus, scenes, the D-370 asset tree, evidence 01-15)"
  else
    fail "W17 the game3d/ change set differs from the declared set"
    say "        undeclared/missing modifications:"; diff <(printf '%s\n' "$MODIFIED") <(printf '%s\n' "$EXP_MOD") | grep -E '^[<>]' | head -8 | sed 's/^/          /'
    say "        undeclared/missing additions:";    diff <(printf '%s\n' "$ADDED") <(printf '%s\n' "$EXP_NEW") | grep -E '^[<>]' | head -8 | sed 's/^/          /'
    [ -n "$REMOVED" ] && { say "        removed:"; printf '%s\n' "$REMOVED" | head -5 | sed 's/^/          /'; }
  fi
  rm -f "$NOW"
else
  # RE-SCOPED UNDER D-396, one for one: W17 is a D-392 DELIVERY-TIME claim -- its
  # declared set is D-392's own, measured against a PRE-D-392 listing. After
  # D-396 changes further files NO listing exists against which it can pass (the
  # D-380 runner's T17 has been in the same state since D-392, and that runner
  # does not count its skip). So without a listing W17 is DECLARED, not skipped,
  # and the change-set guard moves forward: tests/hounds_smoke.sh Y15 proves
  # D-396's own set in both directions. Until D-396 this printed [SKIP] and made
  # the run INCOMPLETE -- true when written.
  say "  [DECLARED] W17 a D-392 delivery-time claim (its change set against a pre-D-392 listing); superseded by the D-396 stage, whose change set tests/hounds_smoke.sh Y15 proves — NOT a pass and NOT a skip"
  DECLARED_CLAIMS=$((DECLARED_CLAIMS + 1))
fi
# W18 — THE PLACEHOLDER INTAKE, byte-identical to its archive entries (read in
# memory; nothing is extracted), plus the repository-wide guards.
W18_OK=1
check_entry() { # $1 in-tree path (relative to PLACEHOLDER), $2 archive, $3 entry
  local a b
  a="$(shasum -a 256 "$PLACEHOLDER/$1" 2>/dev/null | cut -d' ' -f1)"
  b="$(unzip -p "$2" "$3" 2>/dev/null | shasum -a 256 | cut -d' ' -f1)"
  if [ -z "$a" ] || [ "$a" != "$b" ]; then W18_OK=0; say "        $1 differs from $3"; fi
}
check_entry kaykit_character_animations/Rig_Medium_CombatRanged.glb "$KAYKIT_ZIP" "KayKit_Character_Animations_1.1/Animations/gltf/Rig_Medium/Rig_Medium_CombatRanged.glb"
check_entry kaykit_character_animations/Rig_Medium_MovementAdvanced.glb "$KAYKIT_ZIP" "KayKit_Character_Animations_1.1/Animations/gltf/Rig_Medium/Rig_Medium_MovementAdvanced.glb"
check_entry licenses/LICENSE_kaykit_character_animations_CC0.txt "$KAYKIT_ZIP" "KayKit_Character_Animations_1.1/License.txt"
check_entry quaternius_medieval_weapons/Bow_Wooden.obj "$WEAPONS_ZIP" "Medieval Weapons Pack by @Quaternius/OBJ/Bow_Wooden.obj"
check_entry quaternius_medieval_weapons/Bow_Wooden.mtl "$WEAPONS_ZIP" "Medieval Weapons Pack by @Quaternius/OBJ/Bow_Wooden.mtl"
check_entry quaternius_medieval_weapons/Arrow.obj "$WEAPONS_ZIP" "Medieval Weapons Pack by @Quaternius/OBJ/Arrow.obj"
check_entry quaternius_medieval_weapons/Arrow.mtl "$WEAPONS_ZIP" "Medieval Weapons Pack by @Quaternius/OBJ/Arrow.mtl"
check_entry licenses/LICENSE_quaternius_medieval_weapons_CC0.txt "$WEAPONS_ZIP" "Medieval Weapons Pack by @Quaternius/License.txt"
# THE COMPARISON CAN REFUSE: a different entry does not match.
PLANT_SHA="$(unzip -p "$WEAPONS_ZIP" "Medieval Weapons Pack by @Quaternius/OBJ/Arrow.mtl" 2>/dev/null | shasum -a 256 | cut -d' ' -f1)"
OBJ_SHA="$(shasum -a 256 "$PLACEHOLDER/quaternius_medieval_weapons/Arrow.obj" | cut -d' ' -f1)"
[ "$PLANT_SHA" = "$OBJ_SHA" ] && { W18_OK=0; say "        the entry comparison cannot refuse"; }
REG_ROWS=0
for f in Rig_Medium_CombatRanged.glb Rig_Medium_MovementAdvanced.glb Bow_Wooden.obj Bow_Wooden.mtl Arrow.obj Arrow.mtl \
         LICENSE_kaykit_character_animations_CC0.txt LICENSE_quaternius_medieval_weapons_CC0.txt; do
  sed -n '/^# D-392 First Huntress Implementation Stage/,$p' "$ROOT/assets/ASSET_REGISTER.md" | grep -qF "$f" && REG_ROWS=$((REG_ROWS + 1))
done
PXO="$(find "$PROJ" -name '*.pxo' 2>/dev/null | head -1)"
TREES="$(find "$ROOT" -type d -name 'quaternius' 2>/dev/null | sed "s|^$ROOT/||" | sort | tr '\n' ' ')"
EXPECT_TREES="game/assets/third_party/quaternius game3d/assets/third_party/quaternius game3d_boss_spike/assets/third_party/quaternius game3d_spike/assets/third_party/quaternius "
AUDIO="$(find "$PROJ" \( -name '*.wav' -o -name '*.ogg' -o -name '*.mp3' -o -name '*.flac' \) 2>/dev/null | head -1)"
BAD="$(find "$PROJ" \( -iname '*Puglin*' -o -iname '*UltimateMonsters*' -o -iname '*Dragon*' -o -iname '*PinkBlob*' \
        -o -iname '*VFX*' -o -iname '*BattleFX*' -o -iname '*MagicFX*' -o -iname '*VividMotion*' -o -iname '*Ranger*.glb' \
        -o -iname '*prey*' \) \
        -not -path '*/.godot/*' 2>/dev/null | head -1)"
DECLARED="$(grep -oE '"(bestiary_dungeon_monsters|universal_animation_library|universal_animation_library_2|modular_character_outfits_fantasy|ultimate_modular_ruins)/[^"]+"' "$PROJ/scripts/assets/asset_manifest.gd" | grep -vF '%s' | sort -u | wc -l | tr -d ' ')"
INTAKE_N="$(find "$PLACEHOLDER" -type f -not -name '*.import' -not -name '*.uid' -not -name 'SOURCE_AND_LICENSE.md' | wc -l | tr -d ' ')"
if [ "$W18_OK" -eq 1 ] && [ "$REG_ROWS" = "8" ] && [ "$INTAKE_N" = "8" ] && [ -z "$PXO" ] \
   && [ "$TREES" = "$EXPECT_TREES" ] && [ -z "$AUDIO" ] && [ -z "$BAD" ] && [ "$DECLARED" = "29" ]; then
  ok "W18 the 8 D-392 intake files are byte-identical to their archive entries (read in memory) and all 8 are registered in assets/ASSET_REGISTER.md; the D-370 block still declares 29; no .pxo, no audio, no VFX, Ranger or excluded pack, and no file named for Prey (D-393); exactly the four quaternius trees"
else
  fail "W18 intake ok=$W18_OK registered=$REG_ROWS files=$INTAKE_N pxo='$PXO' trees='$TREES' audio='$AUDIO' excluded='$BAD' declared=$DECLARED"
fi
# W19 — NO input action added, renamed or removed; the ordinary attack's events
# moved to binding 6 and the diagnostic action keeps its name with none.
# RE-PINNED UNDER D-396: 26 + 1 = 27 -- the Kindred Hounds stage adds EXACTLY
# `diagnostic_hound_fall`, named, so any other addition still fails.
# RE-PINNED UNDER D-398: 27 + 2 = 29 -- the mobile minion cohesion stage adds
# EXACTLY its two diagnostic modes, both named.
ACTIONS="$(grep -cE '^[a-z_][a-z_0-9]*=\{$' "$PROJ/project.godot")"
IMPRINT_ACTIONS="$(grep -cE '^imprint_[a-z_0-9]+=\{$' "$PROJ/project.godot")"
FALL_ACTION="$(grep -cxF 'diagnostic_hound_fall={' "$PROJ/project.godot")"
D398_ACTIONS="$(grep -cxE 'diagnostic_stress_population=\{|diagnostic_travel_speed=\{' "$PROJ/project.godot")"
DIAG_EMPTY="$(awk '/^diagnostic_attack=\{/{f=1} f&&/"events": \[\]/{print "yes"; exit} f&&/^}/{exit}' "$PROJ/project.godot")"
B6="$(awk '/^imprint_binding_6=\{/{f=1} f{print} f&&/^}/{exit}' "$PROJ/project.godot")"
B6_OK=0
printf '%s' "$B6" | grep -qF '"physical_keycode":54' && printf '%s' "$B6" | grep -qF '"button_index":2' \
  && printf '%s' "$B6" | grep -q 'InputEventJoypadButton' && B6_OK=1
WASD=0
for code in 87 65 83 68; do
  N="$(grep -cF "\"physical_keycode\":$code" "$PROJ/project.godot" || true)"
  [ "$N" != "0" ] && WASD=1
done
if [ "$ACTIONS" = "29" ] && [ "$IMPRINT_ACTIONS" = "12" ] && [ "$FALL_ACTION" = "1" ] && [ "$D398_ACTIONS" = "2" ] && [ "$DIAG_EMPTY" = "yes" ] && [ "$B6_OK" = "1" ] && [ "$WASD" -eq 0 ]; then
  ok "W19 project.godot declares exactly 29 input actions (12 Imprint): D-392 added, renamed or removed none, D-396 added EXACTLY diagnostic_hound_fall (26 + 1 = 27) and D-398 EXACTLY its two diagnostic modes (27 + 2 = 29); diagnostic_attack keeps its name with NO event; binding 6 holds key 6, right mouse and the pad button; no W/A/S/D"
else
  fail "W19 input actions $ACTIONS ($IMPRINT_ACTIONS imprint, D-396 fall $FALL_ACTION, D-398 modes $D398_ACTIONS), diagnostic_attack empty=$DIAG_EMPTY, binding 6 events ok=$B6_OK, W/A/S/D=$WASD"
fi

# ------------------------------------------- W20-W21. rendered evidence ----
say ""
say "[8/9] Rendered evidence is opt-in and bounded (W20)"
EV_AFTER="$(cd "$PROJ" && for e in $EV_FRAMES; do [ -f "evidence/$e.png" ] && shasum -a 256 "evidence/$e.png"; done)"
CEIL_OK=0
grep -qE 'CAP_WAITED" -lt "\$CEILING"' "$0" && [ "$CEILING" -le 120 ] && CEIL_OK=1
if [ "$WITH_EVIDENCE" -eq 0 ] && [ "$EV_BEFORE" = "$EV_AFTER" ] && [ "$CEIL_OK" -eq 1 ]; then
  ok "W20 this plain run was HEADLESS ONLY and left the evidence untouched; a rendered run is opt-in (--with-evidence) with a hard ${CEILING} s ceiling per capture"
elif [ "$WITH_EVIDENCE" -eq 1 ] && [ "$CEIL_OK" -eq 1 ] && [ -z "$EV_RESULT" ]; then
  ok "W20 rendering was OPTED IN; each of the six captures finished inside its ${CEILING} s ceiling and exited 0"
else
  fail "W20 evidence changed without opting in, a capture timed out or failed ($EV_RESULT), or the ceiling is missing"
fi
say ""
say "[9/9] This stage's six captures, 16-20 and 23 (W21)"
W21_OK=1
for e in $EV_FRAMES; do
  if [ -f "$PROJ/evidence/$e.png" ]; then
    DIM="$(sips -g pixelWidth -g pixelHeight "$PROJ/evidence/$e.png" 2>/dev/null \
           | awk '/pixel/{printf "%s", $2"x"} END{print ""}' | sed 's/x$//')"
    [ "$DIM" = "1920x1080" ] || { W21_OK=0; say "        evidence/$e.png is $DIM"; }
  else
    W21_OK=0; say "        evidence/$e.png missing (run with --with-evidence)"
  fi
done
for gone in 21_d392_prey_a 22_d392_prey_b; do
  [ -e "$PROJ/evidence/$gone.png" ] && { W21_OK=0; say "        evidence/$gone.png still exists — removed with Prey under D-393"; }
done
if [ "$W21_OK" -eq 1 ]; then
  ok "W21 all six D-392 captures (16-20, 23) exist at 1920x1080, and the removed Prey frames 21-22 do not (D-393) — accepted evidence 01-15 is untouched (W17)"
else
  fail "W21 the D-392 evidence is missing or mis-sized"
fi

# ------------------------------------------------------------------ verdict --
say ""
say "========================================================================"
[ "$F_RC" -ne 0 ] && fail "the ACCEPTED foundation suite exited non-zero ($F_RC)"
[ "$I_RC" -ne 0 ] && fail "the ACCEPTED Imprint suite exited non-zero ($I_RC)"
[ "$A_RC" -ne 0 ] && fail "the ACCEPTED alignment suite exited non-zero ($A_RC)"
[ "$H_RC" -ne 0 ] && fail "the D-392 suite exited non-zero ($H_RC)"
say "UNITS: 21 RUNNER CHECKS here · 53 EXECUTABLE CHECKS · 203 OWED CRITERIA — different units."
say "$STATE_EXPECT"
if [ "$FAILED" -eq 0 ] && [ "$SKIPPED" -eq 0 ] && [ "$DECLARED_CLAIMS" -gt 0 ]; then
  say "HUNTRESS RUNNER: PASS (21 runner checks: $((21 - DECLARED_CLAIMS)) run and passed, $DECLARED_CLAIMS DECLARED delivery-time claim(s) — D-396)"
elif [ "$FAILED" -eq 0 ] && [ "$SKIPPED" -eq 0 ]; then
  say "HUNTRESS RUNNER: PASS (21 runner checks)"
elif [ "$FAILED" -eq 0 ]; then
  say "HUNTRESS RUNNER: INCOMPLETE — $SKIPPED runner check(s) SKIPPED for lack of a baseline; NOT a pass"
  FAILED=1
else
  say "HUNTRESS RUNNER: FAIL"
fi
say "========================================================================"
# Set HUNTRESS_LOG_DIR to keep the four suite logs (a run of record cites them).
if [ -n "${HUNTRESS_LOG_DIR:-}" ] && [ -d "$HUNTRESS_LOG_DIR" ]; then
  cp "$FLOG" "$HUNTRESS_LOG_DIR/foundation.log"; cp "$ILOG" "$HUNTRESS_LOG_DIR/imprint.log"
  cp "$ALOG" "$HUNTRESS_LOG_DIR/alignment.log"; cp "$HLOG" "$HUNTRESS_LOG_DIR/huntress.log"
fi
rm -f "$FLOG" "$ILOG" "$ALOG" "$HLOG"
exit "$FAILED"
