#!/usr/bin/env bash
# =============================================================================
# RIFTWROUGHT — BOSS ANIMATION FEASIBILITY GATE RUNNER  (D-368, 2026-09-17)
#
# Runs the gate's verification suite HEADLESS by default, then applies the
# project's standing runner rules:
#   * fail on ANY engine error, regardless of the suite's own PASS line;
#   * the error guard is PROVED able to refuse a planted ERROR line every run;
#   * every pinned count is pinned IN BOTH DIRECTIONS -- the run's own log is
#     replayed with the count altered and the pin must refuse it;
#   * isolation is asserted, not assumed: game/, game2d/, game3d_spike/ and the
#     source archives must be byte-identical.
#
# Rendered evidence is OPT-IN (--with-evidence). A plain invocation is
# headless-only, per the project's standing rule.
#
# THIS RUNNER VERIFIES A FEASIBILITY GATE. It accepts no visual direction,
# completes no phase, authorizes no production pivot, and does NOT prove that
# all bosses are feasible.
# =============================================================================
set -uo pipefail

GODOT="${GODOT:-/Applications/Godot.app/Contents/MacOS/Godot}"
HERE="$(cd "$(dirname "$0")" && pwd)"
PROJ="$(cd "$HERE/.." && pwd)"
ROOT="$(cd "$PROJ/.." && pwd)"
LOG="$(mktemp -t bossgate_run)"
FAILED=0
WITH_EVIDENCE=0
[ "${1:-}" = "--with-evidence" ] && WITH_EVIDENCE=1

say() { printf '%s\n' "$*"; }
fail() { say "  [FAIL] $*"; FAILED=1; }
ok()   { say "  [ OK ] $*"; }

say "========================================================================"
say "RIFTWROUGHT BOSS ANIMATION FEASIBILITY GATE RUNNER (D-368)"
say "Headless by default. Rendered evidence is opt-in via --with-evidence."
say "========================================================================"

# ---------------------------------------------------------------- 1. run ----
say ""
say "[1/7] Running the verification suite (headless)"
"$GODOT" --headless --path "$PROJ" --script res://tests/boss_gate_verification.gd \
  >"$LOG" 2>&1
SUITE_RC=$?
grep -E "^  \[(PASS|FAIL|UNREACHED|DEFERRED)" "$LOG" | sed 's/^/    /'
grep -E "^(OWED vs REACHED|  owed=|BOSS GATE VERIFICATION:|STATE:)" "$LOG" | sed 's/^/    /'

# ------------------------------------------------------- 2. scene runs ------
say ""
say "[2/7] The encounter itself runs error-free (headless smoke)"
SMOKE="$(mktemp -t bossgate_smoke)"
"$GODOT" --headless --path "$PROJ" -- --selftest=3000 >"$SMOKE" 2>&1
SMOKE_RC=$?
if [ "$SMOKE_RC" -ne 0 ]; then
  fail "the encounter smoke run exited non-zero ($SMOKE_RC)"
fi
# The smoke run must actually reach the whole encounter, not merely start it.
for s in "windup_begin" "commit" "phase_break_complete" "stagger" \
         "death_begin" "death_complete" "dead"; do
  if grep -qF "$s" "$SMOKE"; then ok "the encounter reached: $s"
  else fail "the encounter never reached: $s"; fi
done
if grep -qE "^(SCRIPT )?ERROR:|^USER ERROR:|Parse Error" "$SMOKE"; then
  fail "engine errors in the encounter smoke run:"
  grep -E "^(SCRIPT )?ERROR:|^USER ERROR:|Parse Error" "$SMOKE" | head -8 | sed 's/^/        /'
else
  ok "no engine errors in the encounter smoke run"
fi
rm -f "$SMOKE"

# --------------------------------------------------------- 3. error guard ----
say ""
say "[3/7] Engine-error guard"
# Anchored to line start so the suite's own prose about errors cannot trip it.
ERRPAT='^(SCRIPT )?ERROR:|^USER ERROR:|^SCRIPT ERROR|Parse Error|Failed to load script'
# Check G22 DELIBERATELY plants one bad clip name to prove the runtime's
# animation guard cannot fail silently. That guard's push_error is therefore an
# EXPECTED, SELF-INFLICTED line. It is pinned in BOTH directions: it must be
# present (or G22 proved nothing) and it is the ONLY line excluded from the
# engine-error scan (so the exclusion cannot hide a real error).
SELF='Boss_Signature_Roar_THIS_DOES_NOT_EXIST'
# Counted among ERROR LINES ONLY. G22's own note also prints the planted name
# when it reports that the guard refused it, so a plain whole-log count finds
# two and the pin would misreport a perfectly healthy run.
SELF_N="$(grep -E "$ERRPAT" "$LOG" | grep -cF "$SELF")"
if [ "$SELF_N" -eq 1 ]; then
  ok "the one expected self-inflicted guard-proving error is present (exactly 1)"
else
  fail "expected exactly 1 guard-proving error line, found $SELF_N -- G22's guard proof is not intact"
fi
REAL="$(grep -E "$ERRPAT" "$LOG" | grep -vF "$SELF" || true)"
if [ -n "$REAL" ]; then
  fail "engine errors present in the run log (excluding the one expected line):"
  printf '%s\n' "$REAL" | head -10 | sed 's/^/        /'
else
  ok "no engine errors in the run log beyond the expected guard proof"
fi
# A GUARD NOTHING CAN REACH IS NOT A GUARD: prove it refuses a planted line.
PLANT="$(mktemp -t bossgate_plant)"; cat "$LOG" > "$PLANT"
printf 'ERROR: planted engine error, for guard proving only\n' >> "$PLANT"
if grep -qE "$ERRPAT" "$PLANT"; then
  ok "error guard PROVED able to refuse a planted 'ERROR:' line"
else
  fail "error guard could NOT detect a planted error line -- it protects nothing"
fi
rm -f "$PLANT"

# ------------------------------------------------- 4. both-direction pins ----
say ""
say "[4/7] Count pins, in BOTH directions"
PIN_CHECKS=67
PIN_DEFERRED=7
LINE="$(grep -E '^BOSS GATE VERIFICATION:' "$LOG" | head -1)"
EXPECT="BOSS GATE VERIFICATION: PASS ($PIN_CHECKS checks: $PIN_CHECKS passed, 0 failed/unreached, $PIN_DEFERRED deferred)"
if [ "$LINE" = "$EXPECT" ]; then
  ok "pinned summary matches exactly: $PIN_CHECKS checks, $PIN_DEFERRED deferred"
else
  fail "pinned summary MISMATCH"
  say "        expected: $EXPECT"
  say "        actual  : $LINE"
fi
# Replay the run's OWN log with the count altered; the pin MUST refuse it.
ALT="$(printf '%s' "$LINE" | sed "s/($PIN_CHECKS checks/(99 checks/")"
if [ "$ALT" = "$EXPECT" ]; then
  fail "the pin ACCEPTS an altered count -- a guard that accepts everything protects nothing"
else
  ok "pin PROVED able to refuse an altered count (replayed as '99 checks')"
fi
# And the deferred count, in both directions.
ALT2="$(printf '%s' "$LINE" | sed "s/$PIN_DEFERRED deferred/0 deferred/")"
if [ "$ALT2" = "$EXPECT" ]; then
  fail "the pin ACCEPTS a zeroed deferred count -- deferrals could vanish unnoticed"
else
  ok "pin PROVED able to refuse a zeroed deferred count"
fi
# The owed-vs-reached line, in both directions.
OWED_LINE="$(grep -E '^  owed=' "$LOG" | head -1 | sed 's/^ *//')"
OWED_EXPECT="owed=$PIN_CHECKS  reached=$PIN_CHECKS  owed-but-not-reached=0 []  reached-but-not-owed=0 []"
if [ "$OWED_LINE" = "$OWED_EXPECT" ]; then
  ok "owed vs reached matches in both directions"
else
  fail "owed/reached MISMATCH"; say "        expected: $OWED_EXPECT"; say "        actual  : $OWED_LINE"
fi
# Every DEFERRED row must be printed, and none may be reported as a pass.
DEF_N="$(grep -cE '^  \[DEFERRED ' "$LOG")"
if [ "$DEF_N" -eq "$PIN_DEFERRED" ]; then
  ok "all $PIN_DEFERRED deferred/transferred rows are printed"
else
  fail "expected $PIN_DEFERRED deferred rows printed, found $DEF_N"
fi

# --------------------------------------------------------- 5. truthfulness ----
say ""
say "[5/7] Truthfulness pins"
for s in "REMAINS PROVISIONAL" "NOT A PRODUCT LOCK" \
         "accepts no visual direction" "completes no phase" \
         "DELIVERED and OPEN pending owner live review" \
         "does NOT prove that all bosses are feasible" \
         "NEXT PROVISIONAL STARTING CANDIDATE" \
         "STRICT SUBSET" "COMMISSIONED SIGNATURE ANIMATION" \
         "DOES NOT TRANSFER"; do
  if grep -qiF "$s" "$LOG"; then ok "the run states: \"$s\""
  else fail "the run does NOT state: \"$s\""; fi
done
# Claims the gate must NOT make.
if grep -qiE "production ready|pivot complete|all bosses are feasible,|bosses are proved|P2 complete|final animation is done|bespoke boss animation is proved" "$LOG"; then
  fail "the run log makes a forbidden completion claim:"
  grep -inE "production ready|pivot complete|bosses are proved|P2 complete" "$LOG" | head -5 | sed 's/^/        /'
else
  ok "no forbidden completion claim in the run log"
fi
# And prove THAT guard can fail, in both directions.
PLANT2="$(mktemp -t bossgate_plant2)"; cat "$LOG" > "$PLANT2"
printf 'the pivot complete and all bosses are proved\n' >> "$PLANT2"
if grep -qiE "pivot complete|bosses are proved" "$PLANT2"; then
  ok "forbidden-claim guard PROVED able to catch a planted claim"
else
  fail "forbidden-claim guard could NOT catch a planted claim -- it protects nothing"
fi
rm -f "$PLANT2"

# ------------------------------------------------------------ 6. isolation ----
say ""
say "[6/7] Isolation and preservation"
BASE="${BOSS_GATE_BASELINE_DIR:-}"
# NO EXCEPTIONS ARE DECLARED FOR ANY OF THE THREE PROTECTED PROJECTS.
# game3d_spike/ is an ACCEPTED, CLOSED artifact (D-367 5.1) and gets no
# courtesy cross-reference note: the easiest mistake in this whole gate would
# be a friendly one-line edit to its README.
for d in game game2d game3d_spike; do
  f="$BASE/baseline_${d}.sha256"
  if [ -n "$BASE" ] && [ -f "$f" ]; then
    NOW="$(mktemp -t bossgate_now)"
    ( cd "$ROOT" && find "$d" -type f -print0 | sort -z | xargs -0 shasum -a 256 ) > "$NOW"
    DIFFS="$(diff "$f" "$NOW" | grep -E '^[<>]' | sed 's/^[<>] *//' | awk '{ $1=""; sub(/^ /,""); print }' | sort -u)"
    if [ -z "$DIFFS" ]; then
      ok "$d/ is byte-identical to the pre-gate baseline"
    else
      fail "$d/ CHANGED -- no exception is declared for it:"
      printf '%s\n' "$DIFFS" | head -10 | sed 's/^/        /'
    fi
    rm -f "$NOW"
  else
    say "  [SKIP] $d/ baseline not supplied (set BOSS_GATE_BASELINE_DIR)"
  fi
done
if [ -n "$BASE" ] && [ -f "$BASE/baseline_quaternius.sha256" ]; then
  NOW="$(mktemp -t bossgate_now)"
  ( cd "$ROOT" && find "assets/Quaternius Assets" -type f -print0 | sort -z | xargs -0 shasum -a 256 ) > "$NOW"
  if diff -q "$BASE/baseline_quaternius.sha256" "$NOW" >/dev/null; then
    ok "the source archives are byte-identical"
  else
    fail "the source archives CHANGED -- reading from an archive is fine, writing is not"
  fi
  rm -f "$NOW"
fi
# Neither protected project may reference this gate, in either direction.
STRAY="$(grep -rlF "game3d_boss_spike" "$ROOT/game" "$ROOT/game2d" "$ROOT/game3d_spike" \
         2>/dev/null | sed "s|^$ROOT/||" || true)"
if [ -n "$STRAY" ]; then
  fail "a protected project references this gate (it must not, in either direction):"
  printf '%s\n' "$STRAY" | sed 's/^/        /'
else
  ok "no protected project references this gate"
fi
# The set of quaternius asset trees is PINNED. Exactly three are expected:
#   1. game/assets/third_party/quaternius        -- PRE-EXISTING, 14 files
#   2. game3d_spike/assets/third_party/quaternius -- the accepted, closed spike
#   3. game3d_boss_spike/assets/third_party/quaternius -- created by THIS gate
FOUND="$(find "$ROOT" -type d -name 'quaternius' 2>/dev/null | sed "s|^$ROOT/||" | sort | tr '\n' ' ')"
EXPECT_TREES="game/assets/third_party/quaternius game3d_boss_spike/assets/third_party/quaternius game3d_spike/assets/third_party/quaternius "
if [ "$FOUND" = "$EXPECT_TREES" ]; then
  ok "quaternius asset trees are exactly the three expected"
else
  fail "unexpected quaternius asset tree set"
  say "        expected: $EXPECT_TREES"
  say "        actual  : $FOUND"
fi
PREEXIST_N="$(find "$ROOT/game/assets/third_party/quaternius" -type f 2>/dev/null | wc -l | tr -d ' ')"
if [ "$PREEXIST_N" = "14" ]; then
  ok "the pre-existing game/ quaternius tree is unchanged at 14 files"
else
  fail "the pre-existing game/ quaternius tree is $PREEXIST_N files, pinned at 14"
fi
# Ultimate Monsters is EXCLUDED from visual acceptance and is not imported.
UM="$(find "$PROJ" -iname '*dragon*' -o -iname '*blob*' -o -iname '*mushnub*' \
      -o -iname '*alpaking*' -o -iname '*squidle*' 2>/dev/null || true)"
if [ -z "$UM" ]; then
  ok "no Ultimate Monsters asset is imported into the gate"
else
  fail "an Ultimate Monsters asset is present -- it is excluded from visual acceptance:"
  printf '%s\n' "$UM" | sed 's/^/        /'
fi
# NO NEW AUDIO. CLAUDE.md 12 forbids it; the gate ships hooks, not sounds.
AUD="$(find "$PROJ" \( -name '*.wav' -o -name '*.ogg' -o -name '*.mp3' \
       -o -name '*.flac' \) 2>/dev/null || true)"
if [ -z "$AUD" ]; then
  ok "zero audio assets in the gate -- sound HOOKS only"
else
  fail "audio assets present, which CLAUDE.md 12 forbids:"
  printf '%s\n' "$AUD" | sed 's/^/        /'
fi
if find "$PROJ" -name '*.pxo' 2>/dev/null | grep -q .; then
  fail "a .pxo is present inside the gate -- owner art must never be touched"
else
  ok "no owner .pxo anywhere in the gate"
fi
# Every licence the gate relies on must be present, verbatim.
for l in LICENSE_bestiary_dungeon_monsters_QAL_v1.0.txt \
         LICENSE_universal_animation_library_1_CC0.txt \
         LICENSE_universal_animation_library_2_CC0.txt \
         LICENSE_modular_character_outfits_fantasy.txt \
         LICENSE_medieval_weapons_CC0.txt \
         LICENSE_ultimate_modular_ruins_CC0.txt; do
  if [ -s "$PROJ/assets/third_party/quaternius/licenses/$l" ]; then
    ok "licence present and non-empty: $l"
  else
    fail "licence MISSING or empty: $l"
  fi
done
if grep -qF "QAL" "$PROJ/assets/third_party/quaternius/SOURCE_AND_LICENSE.md" 2>/dev/null \
   && grep -qiF "forbids" "$PROJ/assets/third_party/quaternius/SOURCE_AND_LICENSE.md" 2>/dev/null; then
  ok "the provenance record states the QAL redistribution restriction"
else
  fail "the provenance record does NOT state the QAL redistribution restriction"
fi

# ------------------------------------------------------------- 7. evidence ----
say ""
say "[7/7] Rendered evidence"
EV_LIST="01_boss_beside_ordinary_control.png 02_attack_a1_sweep_cone.png \
03_attack_a2_slam_annulus.png 04_attack_a3_lance_line.png \
05_phase_transition_shield_break.png 06_death_sequence_death01.png"
if [ "$WITH_EVIDENCE" -eq 1 ]; then
  for m in compare sweep slam lance phase death; do
    case "$m" in
      compare) out=01_boss_beside_ordinary_control.png ;;
      sweep)   out=02_attack_a1_sweep_cone.png ;;
      slam)    out=03_attack_a2_slam_annulus.png ;;
      lance)   out=04_attack_a3_lance_line.png ;;
      phase)   out=05_phase_transition_shield_break.png ;;
      death)   out=06_death_sequence_death01.png ;;
    esac
    "$GODOT" --path "$PROJ" --resolution 1920x1080 -- \
      --capture="$m" --out="res://evidence/$out" >/dev/null 2>&1
    if [ -f "$PROJ/evidence/$out" ]; then
      DIM="$(sips -g pixelWidth -g pixelHeight "$PROJ/evidence/$out" 2>/dev/null | awk '/pixel/{printf "%s", $2"x"} END{print ""}' | sed 's/x$//')"
      if [ "$DIM" = "1920x1080" ]; then ok "evidence/$out rendered natively at 1920x1080"
      else fail "evidence/$out is ${DIM}, not 1920x1080"; fi
    else
      fail "evidence/$out was not produced"
    fi
  done
else
  say "  [SKIP] rendered evidence is opt-in; re-run with --with-evidence"
  for out in $EV_LIST; do
    if [ -f "$PROJ/evidence/$out" ]; then
      DIM="$(sips -g pixelWidth -g pixelHeight "$PROJ/evidence/$out" 2>/dev/null | awk '/pixel/{printf "%s", $2"x"} END{print ""}' | sed 's/x$//')"
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
  say "BOSS GATE RUNNER: PASS"
else
  say "BOSS GATE RUNNER: FAIL"
fi
say "This is a BOUNDED FEASIBILITY GATE result."
say "It is NOT the production pivot, NOT proof that all bosses are feasible,"
say "NOT a bespoke boss animation pipeline, NOT final art, NOT final animation,"
say "NOT the Crownless Warden, NOT an Act I encounter, and NOT P2."
say "It proves a bounded HUMANOID case and explicitly NOT the non-humanoid one."
say "STATE: Boss Animation Feasibility Gate DELIVERED and OPEN pending owner live review."
say "========================================================================"
rm -f "$LOG"
exit "$FAILED"
