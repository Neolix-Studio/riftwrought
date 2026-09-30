#!/usr/bin/env bash
# =============================================================================
# RIFTWROUGHT — 3D FEASIBILITY SPIKE RUNNER  (D-366, 2026-09-17)
#
# Runs the spike's verification suite HEADLESS by default, then applies the
# project's standing runner rules:
#   * fail on ANY engine error, regardless of the suite's own PASS line;
#   * the error guard is PROVED able to refuse a planted ERROR line every run;
#   * every pinned count is pinned IN BOTH DIRECTIONS -- the run's own log is
#     replayed with the count altered and the pin must refuse it;
#   * isolation is asserted, not assumed: game/, game2d/ and the source
#     archives must be byte-identical.
#
# Rendered evidence is OPT-IN (--with-evidence). A plain invocation is
# headless-only, per the project's standing rule.
#
# THIS RUNNER VERIFIES A FEASIBILITY SPIKE. It accepts no visual direction,
# completes no phase, and authorizes nothing.
# =============================================================================
set -uo pipefail

GODOT="${GODOT:-/Applications/Godot.app/Contents/MacOS/Godot}"
HERE="$(cd "$(dirname "$0")" && pwd)"
PROJ="$(cd "$HERE/.." && pwd)"
ROOT="$(cd "$PROJ/.." && pwd)"
LOG="$(mktemp -t spike_run)"
FAILED=0
WITH_EVIDENCE=0
[ "${1:-}" = "--with-evidence" ] && WITH_EVIDENCE=1

say() { printf '%s\n' "$*"; }
fail() { say "  [FAIL] $*"; FAILED=1; }
ok()   { say "  [ OK ] $*"; }

say "========================================================================"
say "RIFTWROUGHT 3D FEASIBILITY SPIKE RUNNER (D-366)"
say "Headless by default. Rendered evidence is opt-in via --with-evidence."
say "========================================================================"

# ---------------------------------------------------------------- 1. run ----
say ""
say "[1/6] Running the verification suite (headless)"
"$GODOT" --headless --path "$PROJ" --script res://tests/spike_verification.gd >"$LOG" 2>&1
SUITE_RC=$?
grep -E "^  \[(PASS|FAIL|UNREACHED|DEFERRED)" "$LOG" | sed 's/^/    /'
grep -E "^(OWED vs REACHED|  owed=|SPIKE VERIFICATION:|STATE:)" "$LOG" | sed 's/^/    /'

# --------------------------------------------------------- 2. error guard ----
say ""
say "[2/6] Engine-error guard"
# Anchored to line start so the suite's own prose about errors cannot trip it.
ERRPAT='^(SCRIPT )?ERROR:|^USER ERROR:|^SCRIPT ERROR|Parse Error|Failed to load script'
# Check C05 DELIBERATELY plants one bad clip name to prove the runtime's
# animation guard cannot fail silently. That guard's push_error is therefore an
# EXPECTED, SELF-INFLICTED line. It is pinned in BOTH directions: it must be
# present (or C05 proved nothing) and it is the ONLY line excluded from the
# engine-error scan (so the exclusion cannot hide a real error).
SELF='Bow_Draw_Release_THIS_DOES_NOT_EXIST'
SELF_N="$(grep -cF "$SELF" "$LOG")"
if [ "$SELF_N" -eq 1 ]; then
  ok "the one expected self-inflicted guard-proving error is present (exactly 1)"
else
  fail "expected exactly 1 guard-proving error line, found $SELF_N -- C05's guard proof is not intact"
fi
REAL="$(grep -E "$ERRPAT" "$LOG" | grep -vF "$SELF" || true)"
if [ -n "$REAL" ]; then
  fail "engine errors present in the run log (excluding the one expected line):"
  printf '%s\n' "$REAL" | head -10 | sed 's/^/        /'
else
  ok "no engine errors in the run log beyond the expected guard proof"
fi
# A GUARD NOTHING CAN REACH IS NOT A GUARD: prove it refuses a planted line.
PLANT="$(mktemp -t spike_plant)"; cat "$LOG" > "$PLANT"
printf 'ERROR: planted engine error, for guard proving only\n' >> "$PLANT"
if grep -qE "$ERRPAT" "$PLANT"; then
  ok "error guard PROVED able to refuse a planted 'ERROR:' line"
else
  fail "error guard could NOT detect a planted error line -- it protects nothing"
fi
rm -f "$PLANT"

# ------------------------------------------------- 3. both-direction pins ----
say ""
say "[3/6] Count pins, in BOTH directions"
PIN_CHECKS=25
PIN_DEFERRED=5
LINE="$(grep -E '^SPIKE VERIFICATION:' "$LOG" | head -1)"
EXPECT="SPIKE VERIFICATION: PASS ($PIN_CHECKS checks: $PIN_CHECKS passed, 0 failed/unreached, $PIN_DEFERRED deferred)"
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
# And the owed-vs-reached line, in both directions.
OWED_LINE="$(grep -E '^  owed=' "$LOG" | head -1 | sed 's/^ *//')"
OWED_EXPECT="owed=$PIN_CHECKS  reached=$PIN_CHECKS  owed-but-not-reached=0 []  reached-but-not-owed=0 []"
if [ "$OWED_LINE" = "$OWED_EXPECT" ]; then
  ok "owed vs reached matches in both directions"
else
  fail "owed/reached MISMATCH"; say "        expected: $OWED_EXPECT"; say "        actual  : $OWED_LINE"
fi

# --------------------------------------------------------- 4. truthfulness ----
say ""
say "[4/6] Truthfulness pins"
for s in "REMAINS PROVISIONAL" "NOT A PRODUCT LOCK" \
         "accepts no visual direction" "completes no phase" \
         "DELIVERED and OPEN pending owner live review" \
         "NO bow / archery" "NO death clip"; do
  if grep -qiF "$s" "$LOG"; then ok "runtime states: \"$s\""
  else fail "runtime does NOT state: \"$s\""; fi
done
if grep -qiE "final Huntress is|production ready|pivot complete|P2 complete" "$LOG"; then
  fail "the run log makes a forbidden completion claim"
else
  ok "no forbidden completion claim in the run log"
fi

# ------------------------------------------------------------ 5. isolation ----
say ""
say "[5/6] Isolation and preservation"
BASE="${SPIKE_BASELINE_DIR:-}"
# ONE exception is declared IN ADVANCE, in
# docs/testing/D366_STAGE_B_OWED_CHECK_INVENTORY.md check B2: game2d/README.md
# receives a status-only edit recording that game2d/ is preserved and unchanged.
# The exception is PINNED to exactly that one path -- if any OTHER file under
# game2d/ differs, or if that file stops differing (meaning the declared edit was
# never made), this FAILS. An exception that can absorb an unknown change is not
# an exception, it is a hole.
ALLOWED_G2D="game2d/README.md"
for pair in "game:$BASE/baseline_game.sha256" "game2d:$BASE/baseline_game2d.sha256"; do
  d="${pair%%:*}"; f="${pair#*:}"
  if [ -n "$BASE" ] && [ -f "$f" ]; then
    NOW="$(mktemp -t spike_now)"
    ( cd "$ROOT" && find "$d" -type f -print0 | sort -z | xargs -0 shasum -a 256 ) > "$NOW"
    DIFFS="$(diff "$f" "$NOW" | grep -E '^[<>]' | sed 's/^[<>] *//' | awk '{ $1=""; sub(/^ /,""); print }' | sort -u)"
    if [ -z "$DIFFS" ]; then
      ok "$d/ is byte-identical to the pre-spike baseline"
    elif [ "$d" = "game2d" ] && [ "$DIFFS" = "$ALLOWED_G2D" ]; then
      ok "game2d/ differs in EXACTLY the one declared path ($ALLOWED_G2D) and nothing else"
    else
      fail "$d/ CHANGED beyond what was declared:"
      printf '%s\n' "$DIFFS" | head -10 | sed 's/^/        /'
    fi
    rm -f "$NOW"
  else
    say "  [SKIP] $d/ baseline not supplied (set SPIKE_BASELINE_DIR)"
  fi
done
if [ -n "$BASE" ] && [ -f "$BASE/baseline_quaternius.sha256" ]; then
  NOW="$(mktemp -t spike_now)"
  ( cd "$ROOT" && find "assets/Quaternius Assets" -type f -print0 | sort -z | xargs -0 shasum -a 256 ) > "$NOW"
  if diff -q "$BASE/baseline_quaternius.sha256" "$NOW" >/dev/null; then ok "source archives byte-identical"
  else fail "source archives CHANGED"; fi
  rm -f "$NOW"
fi
# Byte-identity above already proves nothing was imported into game/ or
# game2d/. (An earlier version of this check looked for .glb/.gltf under game/
# and "failed" -- game/ IS the accepted 3D project and legitimately contains
# them. A guard that flags correct state is worse than no guard.) What is
# asserted here is the complementary claim: the spike's third-party tree is
# wholly contained inside game3d_spike/, and neither protected project
# references it.
# game2d/README.md is DECLARED to reference the spike -- that reference IS the
# preservation record. It is pinned by name; any other referencing file fails.
STRAY="$(grep -rlF "game3d_spike" "$ROOT/game" "$ROOT/game2d" 2>/dev/null \
         | sed "s|^$ROOT/||" | grep -v "^game2d/README.md$" || true)"
if [ -n "$STRAY" ]; then
  fail "game/ or game2d/ references the spike outside the one declared file:"
  printf '%s\n' "$STRAY" | sed 's/^/        /'
else
  ok "only the declared game2d/README.md references the spike"
fi
if grep -qF "game3d_spike" "$ROOT/game2d/README.md" 2>/dev/null; then
  ok "game2d/README.md carries its declared preservation note"
else
  fail "game2d/README.md is MISSING its declared preservation note"
fi
# The set of quaternius asset trees in the repository is PINNED. Exactly two
# are expected and both are accounted for:
#   1. game3d_spike/assets/third_party/quaternius  -- created by this spike;
#   2. game/assets/third_party/quaternius          -- PRE-EXISTING, 14 files of
#      the same Ultimate Modular Ruins pack, present in the pre-spike baseline
#      and covered by the byte-identity check above. This spike did NOT create
#      it and did NOT touch it.
# An earlier version of this check flagged (2) as leakage. It is not: game/ is
# the accepted 3D project and legitimately carries those files. Pinning the set
# is the honest guard -- a THIRD tree appearing would still be caught.
FOUND="$(find "$ROOT" -type d -name 'quaternius' 2>/dev/null | sed "s|^$ROOT/||" | sort | tr '\n' ' ')"
EXPECT_TREES="game/assets/third_party/quaternius game3d_spike/assets/third_party/quaternius "
if [ "$FOUND" = "$EXPECT_TREES" ]; then
  ok "quaternius asset trees are exactly the two expected (spike + pre-existing game/)"
else
  fail "unexpected quaternius asset tree set"
  say "        expected: $EXPECT_TREES"
  say "        actual  : $FOUND"
fi
PREEXIST_N="$(find "$ROOT/game/assets/third_party/quaternius" -type f 2>/dev/null | wc -l | tr -d ' ')"
if [ "$PREEXIST_N" = "14" ]; then
  ok "pre-existing game/ quaternius tree is unchanged at 14 files"
else
  fail "pre-existing game/ quaternius tree is $PREEXIST_N files, pinned at 14"
fi
if find "$PROJ" -name '*.pxo' 2>/dev/null | grep -q .; then
  fail "a .pxo is present inside the spike -- owner art must never be touched"
else
  ok "no owner .pxo anywhere in the spike"
fi

# ------------------------------------------------------------- 6. evidence ----
say ""
say "[6/6] Rendered evidence"
if [ "$WITH_EVIDENCE" -eq 1 ]; then
  for m in full close combat density lighting; do
    case "$m" in
      full)     out=01_courtyard_full.png;     w=140 ;;
      close)    out=02_huntress_enemy_close.png; w=150 ;;
      combat)   out=03_six_enemy_combat.png;   w=88  ;;
      density)  out=04_density_24_enemies.png; w=120 ;;
      lighting) out=05_lighting_and_vfx.png;   w=95  ;;
    esac
    "$GODOT" --path "$PROJ" --resolution 1920x1080 -- \
      --capture="$m" --out="res://evidence/$out" --wait="$w" >/dev/null 2>&1
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
  for out in 01_courtyard_full.png 02_huntress_enemy_close.png \
             03_six_enemy_combat.png 04_density_24_enemies.png \
             05_lighting_and_vfx.png; do
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
  say "SPIKE RUNNER: PASS"
else
  say "SPIKE RUNNER: FAIL"
fi
say "This is a BOUNDED FEASIBILITY SPIKE result."
say "It is NOT the final Huntress, NOT final art, NOT the 3D production project,"
say "NOT P2, NOT a completed pivot, NOT proof the complete game is feasible, and"
say "NOT acceptance of the Quaternius visual style."
say "STATE: 3D feasibility spike DELIVERED and OPEN pending owner live review."
say "========================================================================"
rm -f "$LOG"
exit "$FAILED"
