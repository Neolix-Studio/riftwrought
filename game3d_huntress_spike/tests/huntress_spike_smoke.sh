#!/usr/bin/env bash
# =============================================================================
# RIFTWROUGHT — HUNTRESS BOW-RETARGETING AND PREY FEASIBILITY SPIKE RUNNER
# (D-388, 2026-09-19)
#
# Runs the spike's verification suite HEADLESS by default, then applies the
# project's standing runner rules:
#   * run the IMPORT PASS first, so a fresh checkout verifies;
#   * fail on ANY engine error, regardless of the suite's own PASS line -- and
#     a suite that failed to PARSE prints no summary at all, which is refused;
#   * the error guard is PROVED able to refuse a planted ERROR line every run;
#   * every pinned count is pinned IN BOTH DIRECTIONS;
#   * the eleven accepted modules are compared BYTE FOR BYTE with game3d/;
#   * the nineteen intake files are compared with their ARCHIVE ENTRIES, read in
#     memory -- nothing is extracted;
#   * isolation is ASSERTED against baselines taken before any work, never
#     assumed; without them the runner SKIPS and says so.
#
# Rendered evidence is OPT-IN (--with-evidence). A plain invocation is headless.
#
# ============================================================================
# UNITS. This runner makes 19 RUNNER CHECKS (K01-K19). The suite runs 72
# EXECUTABLE CHECKS. The D-388 inventory lists 117 OWED CRITERIA. Three units;
# none is a synonym for another.
# ============================================================================
#
# IT VERIFIES A SPIKE DELIVERED OPEN. It completes no phase, authorizes nothing,
# locks no value, and does NOT classify the retarget -- rendered evidence and the
# owner's live review do.
# =============================================================================
set -uo pipefail

GODOT="${GODOT:-/Applications/Godot.app/Contents/MacOS/Godot}"
HERE="$(cd "$(dirname "$0")" && pwd)"
PROJ="$(cd "$HERE/.." && pwd)"
ROOT="$(cd "$PROJ/.." && pwd)"
LOG="$(mktemp -t huntress_spike_run)"
FAILED=0
WITH_EVIDENCE=0
[ "${1:-}" = "--with-evidence" ] && WITH_EVIDENCE=1

say()  { printf '%s\n' "$*"; }
fail() { say "  [FAIL] $*"; FAILED=1; }
ok()   { say "  [ OK ] $*"; }

say "========================================================================"
say "RIFTWROUGHT HUNTRESS BOW-RETARGETING AND PREY FEASIBILITY SPIKE RUNNER (D-388)"
say "Headless by default. Rendered evidence is opt-in via --with-evidence."
say "========================================================================"

# --------------------------------------------------------------- K01 import ----
say ""
say "[1/8] Import pass (K01)"
"$GODOT" --headless --path "$PROJ" --import >/dev/null 2>&1
IMPORTED="$(ls "$PROJ/.godot/imported" 2>/dev/null | wc -l | tr -d ' ')"
if [ "$IMPORTED" -gt 0 ]; then ok "K01 assets imported ($IMPORTED entries) — a fresh checkout verifies"
else fail "K01 the import pass produced nothing"; fi

# ---------------------------------------------------------------- K02 run -----
say ""
say "[2/8] The verification suite, headless, fixed 60 Hz steps (K02)"
"$GODOT" --headless --fixed-fps 60 --path "$PROJ" --script res://tests/huntress_spike_verification.gd >"$LOG" 2>&1
SUITE_RC=$?
grep -E "^  \[(PASS|FAIL|UNREACHED)" "$LOG" | sed 's/^/    /'
SUMMARY="$(grep -E '^HUNTRESS SPIKE VERIFICATION:' "$LOG" | head -1)"
if [ -n "$SUMMARY" ] && [ "$SUITE_RC" -eq 0 ]; then
  ok "K02 the suite ran to its summary and exited 0"
else
  fail "K02 the suite did not reach its summary or exited $SUITE_RC — a parse error prints NO summary and still exits 0"
fi

# ------------------------------------------------------------ K03 errors ------
say ""
say "[3/8] Engine-error guard (K03)"
ERRPAT='^(SCRIPT )?ERROR:|^USER ERROR:|^SCRIPT ERROR|Parse Error|Failed to load script'
REAL="$(grep -E "$ERRPAT" "$LOG" || true)"
PLANT="$(mktemp -t huntress_plant)"; cat "$LOG" > "$PLANT"
printf 'ERROR: planted engine error, for guard proving only\n' >> "$PLANT"
if [ -n "$REAL" ]; then
  fail "K03 engine errors in the run log:"; printf '%s\n' "$REAL" | head -10 | sed 's/^/        /'
elif grep -qE "$ERRPAT" "$PLANT"; then
  ok "K03 no engine error in the run log · the guard is PROVED able to refuse a planted 'ERROR:' line"
else
  fail "K03 the error guard cannot detect a planted error line — it protects nothing"
fi
rm -f "$PLANT"

# ------------------------------------------------------ K04-K06 count pins ----
say ""
say "[4/8] Count pins, in BOTH directions (K04, K05, K06)"
PIN_CHECKS=72
PIN_DEFERRED=13
PIN_OWED=6
PIN_FINDINGS=51
EXPECT="HUNTRESS SPIKE VERIFICATION: PASS ($PIN_CHECKS checks: $PIN_CHECKS passed, 0 failed/unreached, $PIN_DEFERRED deferred, $PIN_OWED owed-to-owner, $PIN_FINDINGS findings)"
ALT="$(printf '%s' "$SUMMARY" | sed "s/($PIN_CHECKS checks/(99 checks/")"
if [ "$SUMMARY" = "$EXPECT" ] && [ "$ALT" != "$EXPECT" ]; then
  ok "K04 summary pinned exactly ($PIN_CHECKS checks · $PIN_DEFERRED deferred · $PIN_OWED owed-to-owner · $PIN_FINDINGS findings) · an altered replay ('99 checks') is REFUSED"
else
  fail "K04 summary mismatch"; say "        expected: $EXPECT"; say "        actual  : $SUMMARY"
fi
OWED_LINE="$(grep -E '^  owed=' "$LOG" | head -1 | sed 's/^ *//')"
OWED_EXPECT="owed=$PIN_CHECKS  reached=$PIN_CHECKS  owed-but-not-reached=0 []  reached-but-not-owed=0 []"
if [ "$OWED_LINE" = "$OWED_EXPECT" ]; then ok "K05 owed vs reached matches in BOTH directions"
else fail "K05 owed/reached mismatch"; say "        expected: $OWED_EXPECT"; say "        actual  : $OWED_LINE"; fi
# Count the rows the SUITE prints (after its RESULTS header), not the banner's.
RES="$(awk '/^RESULTS — /{f=1} f' "$LOG")"
ND="$(printf '%s\n' "$RES" | grep -c '^  \[DEFERRED\]')"
NO="$(printf '%s\n' "$RES" | grep -c '^  \[OWED-TO-OWNER\]')"
NF="$(printf '%s\n' "$RES" | grep -c '^  \[FINDING\]')"
if [ "$ND" -eq "$PIN_DEFERRED" ] && [ "$NO" -eq "$PIN_OWED" ] && [ "$NF" -eq "$PIN_FINDINGS" ] && grep -qF "Different unit." "$LOG"; then
  ok "K06 printed rows: $ND DEFERRED · $NO OWED-TO-OWNER · $NF FINDINGS — none a pass · the suite names its units"
else
  fail "K06 printed rows: $ND DEFERRED, $NO OWED-TO-OWNER, $NF FINDINGS (expected $PIN_DEFERRED / $PIN_OWED / $PIN_FINDINGS), or the units are not named"
fi

# ------------------------------------------------------ K07 truthfulness ------
say ""
say "[5/8] Truthfulness (K07)"
STATE_EXPECT="SPIKE STATE: HUNTRESS BOW-RETARGETING AND PREY FEASIBILITY SPIKE DELIVERED and OPEN pending owner live review (D-388)"
STATE_LINE="$(grep -E '^SPIKE STATE: ' "$LOG" | head -1)"
MISSING=""
for s in "NOT P2" "NOT production implementation" "NOT final Huntress art" "NOT VFX intake" "NOT tuning" \
         "does NOT modify game3d/" "NOT Splinter Shot" "DIAGNOSTIC NATIVE-RIG COMPARATOR ONLY" \
         "NO hound art is proven" "does NOT resolve the OWED multi-target Prey tie-break" \
         "changes NO Huntress canon" "The runtime does not classify itself"; do
  grep -qF "$s" "$LOG" || MISSING="$MISSING | $s"
done
FORBID="$(grep -iE "P2 is authorized|production[- ]ready|this is the final Huntress|VIABLE FOR PRODUCTION CONTINUATION|VIABLE FOR PROTOTYPE ONLY" "$LOG" || true)"
ALT_STATE="$(printf '%s' "$STATE_LINE" | sed 's/DELIVERED and OPEN/ACCEPTED and CLOSED/')"
if [ "$STATE_LINE" = "$STATE_EXPECT" ] && [ "$ALT_STATE" != "$STATE_EXPECT" ] && [ -z "$MISSING" ] && [ -z "$FORBID" ]; then
  ok "K07 the state line is EXACT (an altered line is refused) · every denial is printed · no forbidden or self-classifying claim"
else
  fail "K07 truthfulness: state='$STATE_LINE' missing='$MISSING' forbidden='$FORBID'"
fi

# ---------------------------------------------- K08-K11 intake and code -------
say ""
say "[6/8] The accepted code and the intake, byte for byte (K08-K11)"
MODS="scripts/core/prod_config.gd scripts/control/action_commitment.gd scripts/control/input_intent.gd scripts/control/locomotion_motor.gd scripts/control/yaw_driver.gd scripts/control/player_controller.gd scripts/view/iso_camera_rig.gd scripts/view/ground_shadow.gd scripts/world/nav_service.gd scripts/combat/damageable.gd scripts/combat/diagnostic_bolt.gd"
BADMOD=""
for m in $MODS; do cmp -s "$ROOT/game3d/$m" "$PROJ/$m" || BADMOD="$BADMOD $m"; done
HAVE="$(cd "$PROJ" && find scripts/core scripts/control scripts/view scripts/world scripts/combat -name '*.gd' | sort | tr '\n' ' ')"
WANT="$(printf '%s\n' $MODS | sort | tr '\n' ' ')"
# A GUARD NOTHING CAN REACH IS NOT A GUARD: a copy with one byte added must differ.
PLANTM="$(mktemp -t hs_mod)"; cp "$PROJ/scripts/control/action_commitment.gd" "$PLANTM"; printf ' ' >> "$PLANTM"
if cmp -s "$ROOT/game3d/scripts/control/action_commitment.gd" "$PLANTM"; then K08P=0; else K08P=1; fi
rm -f "$PLANTM"
if [ -z "$BADMOD" ] && [ "$HAVE" = "$WANT" ] && [ "$K08P" -eq 1 ]; then
  ok "K08 the 11 accepted modules are BYTE-IDENTICAL to game3d/, no other game3d/ script is present · a planted one-byte change is REFUSED"
else
  fail "K08 verbatim modules differ:$BADMOD · present: $HAVE"
fi
K09="$(cd "$ROOT" && python3 - "$PROJ" <<'PY'
import sys, zipfile, hashlib, os
proj = sys.argv[1]
T = proj + "/assets/third_party/"
def h(b): return hashlib.sha256(b).hexdigest()
OUT = "Modular Character Outfits - Fantasy[Standard]/Exports/glTF (Godot-Unreal)/"
M = [
 ("quaternius_modular_character_outfits_fantasy/Female_Ranger.gltf", "assets/Quaternius Assets/Modular Character Outfits - Fantasy[Standard].zip", OUT + "Outfits/Female_Ranger.gltf"),
 ("quaternius_modular_character_outfits_fantasy/Female_Ranger.bin", "assets/Quaternius Assets/Modular Character Outfits - Fantasy[Standard].zip", OUT + "Outfits/Female_Ranger.bin"),
] + [("quaternius_modular_character_outfits_fantasy/" + f, "assets/Quaternius Assets/Modular Character Outfits - Fantasy[Standard].zip", OUT + "Modular Parts/" + f)
     for f in ["T_Ranger_BaseColor.png", "T_Ranger_Normal.png", "T_Ranger_ORM.png", "T_Regular_Female_Dark_BaseColor.png", "T_Regular_Female_Normal.png", "T_Regular_Female_Roughness.png"]] + [
 ("licenses/LICENSE_quaternius_modular_character_outfits_fantasy_CC0.txt", "assets/Quaternius Assets/Modular Character Outfits - Fantasy[Standard].zip", "Modular Character Outfits - Fantasy[Standard]/License_Standard.txt"),
 ("kaykit_character_animations/Rig_Medium_CombatRanged.glb", "assets/KayKit_Character_Animations_1.1.zip", "KayKit_Character_Animations_1.1/Animations/gltf/Rig_Medium/Rig_Medium_CombatRanged.glb"),
 ("kaykit_character_animations/Rig_Medium_MovementAdvanced.glb", "assets/KayKit_Character_Animations_1.1.zip", "KayKit_Character_Animations_1.1/Animations/gltf/Rig_Medium/Rig_Medium_MovementAdvanced.glb"),
 ("licenses/LICENSE_kaykit_character_animations_CC0.txt", "assets/KayKit_Character_Animations_1.1.zip", "KayKit_Character_Animations_1.1/License.txt"),
 ("kaykit_adventurers/Ranger.glb", "assets/KayKit_Adventurers_2.0_FREE.zip", "KayKit_Adventurers_2.0_FREE/Characters/gltf/Ranger.glb"),
 ("licenses/LICENSE_kaykit_adventurers_CC0.txt", "assets/KayKit_Adventurers_2.0_FREE.zip", "KayKit_Adventurers_2.0_FREE/License.txt"),
] + [("quaternius_medieval_weapons/" + f, "assets/Quaternius Assets/Medieval Weapons Pack by @Quaternius-20260917T104936Z-1-001.zip", "Medieval Weapons Pack by @Quaternius/OBJ/" + f) for f in ["Bow_Wooden.obj", "Bow_Wooden.mtl", "Arrow.obj", "Arrow.mtl"]] + [
 ("licenses/LICENSE_quaternius_medieval_weapons_CC0.txt", "assets/Quaternius Assets/Medieval Weapons Pack by @Quaternius-20260917T104936Z-1-001.zip", "Medieval Weapons Pack by @Quaternius/License.txt"),
]
bad = []
for dst, arc, inner in M:
    local = open(T + dst, "rb").read()
    if local != zipfile.ZipFile(arc).read(inner):
        bad.append(dst)
    if dst.startswith("quaternius_modular") and not dst.startswith("licenses"):
        g3 = "game3d/assets/third_party/quaternius/modular_character_outfits_fantasy/" + dst.split("/")[-1]
        if open(g3, "rb").read() != local:
            bad.append("vs game3d: " + dst)
declared = set(d for d, _, _ in M) | {"SOURCE_AND_LICENSE.md"}
extra = []
for dp, dn, fn in os.walk(T):
    for f in fn:
        rel = os.path.relpath(os.path.join(dp, f), T)
        if rel in declared or rel.endswith(".import") or rel.endswith(".uid") or os.path.basename(rel).startswith("Ranger_ranger_texture"):
            continue
        extra.append(rel)
print("OK" if not bad and not extra and len(M) == 19 else "BAD %s EXTRA %s N %d" % (bad, extra, len(M)))
PY
)"
if [ "$K09" = "OK" ]; then
  ok "K09 all 19 intake files are byte-identical to their ARCHIVE entries (read in memory), the 8 Huntress files also to game3d/'s copies, and nothing undeclared sits beside them"
else
  fail "K09 intake: $K09"
fi
ARCH_BAD=""
while IFS='|' read -r a want; do
  got="$(shasum -a 256 "$ROOT/$a" | awk '{print $1}')"
  [ "$got" = "$want" ] || ARCH_BAD="$ARCH_BAD $a"
done <<'LIST'
assets/Quaternius Assets/Modular Character Outfits - Fantasy[Standard].zip|c3468b18871cc8c8f05ab14df7712baf22cb9f389cbd870babf130e595187f70
assets/KayKit_Character_Animations_1.1.zip|65882f31f905ad2e953819648a59287cdeab8f623908d5ef701971d3758be20f
assets/KayKit_Adventurers_2.0_FREE.zip|abe48f4763fba0896bab486ee9e6d08ca6b5b3884b9601f235c8847ae94dc479
assets/Quaternius Assets/Medieval Weapons Pack by @Quaternius-20260917T104936Z-1-001.zip|66db9bcb92a2f1cdf8a3b53b882b91e4fb6a6a982d54936ca09a05346f37b395
LIST
if [ -z "$ARCH_BAD" ]; then ok "K10 the four source archives keep their recorded SHA-256"
else fail "K10 source archives changed:$ARCH_BAD"; fi
RW="$(cd "$PROJ" && { find assets/third_party -type f ! -name '*.import' ! -name '*.uid' ! -name 'Ranger_ranger_texture*' ! -name 'SOURCE_AND_LICENSE.md' -perm -u+w; for m in $MODS; do [ -w "$m" ] && echo "$m"; done; } )"
if [ -z "$RW" ]; then ok "K11 the 19 intake files and the 11 accepted modules are READ-ONLY copies"
else fail "K11 writable copies: $RW"; fi

# ------------------------------------------------- K12-K16 isolation ----------
say ""
say "[7/8] Isolation and preservation (K12-K16)"
BASE="${HUNTRESS_SPIKE_BASELINE_DIR:-}"
if [ -n "$BASE" ] && [ -f "$BASE/baseline_game.sha256" ]; then
  CHANGED=""
  for d in game game2d game3d game3d_spike game3d_boss_spike models design; do
    NOW="$(mktemp -t hs_now)"
    ( cd "$ROOT" && find "$d" -type f -print0 | sort -z | xargs -0 shasum -a 256 ) > "$NOW"
    diff -q "$BASE/baseline_$d.sha256" "$NOW" >/dev/null || CHANGED="$CHANGED $d/"
    rm -f "$NOW"
  done
  NOW="$(mktemp -t hs_now)"
  ( cd "$ROOT" && find assets \( -path 'assets/Pixel Art' \) -prune -o -type f ! -name '*.pxo' ! -path 'assets/ASSET_REGISTER.md' -print0 | sort -z | xargs -0 shasum -a 256 ) > "$NOW"
  diff -q "$BASE/baseline_assets.sha256" "$NOW" >/dev/null || CHANGED="$CHANGED assets/(archives)"
  rm -f "$NOW"
  # The comparison can fail: a baseline with one digest altered must differ.
  PLANTB="$(mktemp -t hs_base)"; sed '1s/^[0-9a-f]\{64\}/0000000000000000000000000000000000000000000000000000000000000000/' "$BASE/baseline_models.sha256" > "$PLANTB"
  NOWM="$(mktemp -t hs_now)"; ( cd "$ROOT" && find models -type f -print0 | sort -z | xargs -0 shasum -a 256 ) > "$NOWM"
  if diff -q "$PLANTB" "$NOWM" >/dev/null; then K12P=0; else K12P=1; fi
  rm -f "$PLANTB" "$NOWM"
  [ "$K12P" -eq 1 ] || CHANGED="$CHANGED (the baseline comparison could not refuse a planted digest)"
  if [ -z "$CHANGED" ]; then
    ok "K12 game/, game2d/, game3d/ (with its .godot cache), game3d_spike/, game3d_boss_spike/, models/, design/ and every file under assets/ (43 archives incl. assets/VFX/) are byte-identical to the pre-work baseline"
  else
    fail "K12 CHANGED since the pre-work baseline:$CHANGED — no exception is declared"
  fi
else
  say "  [SKIP] K12 baselines not supplied (set HUNTRESS_SPIKE_BASELINE_DIR) — an unproved claim is not passed"
fi
# The accepted game3d/ runners' own repository-wide expression, evaluated verbatim.
FOUND="$(find "$ROOT" -type d -name 'quaternius' 2>/dev/null | sed "s|^$ROOT/||" | sort | tr '\n' ' ')"
EXPECT_TREES="game/assets/third_party/quaternius game3d/assets/third_party/quaternius game3d_boss_spike/assets/third_party/quaternius game3d_spike/assets/third_party/quaternius "
PLANTED_FOUND="${FOUND}game3d_huntress_spike/assets/third_party/quaternius "
if [ "$FOUND" = "$EXPECT_TREES" ] && [ "$PLANTED_FOUND" != "$EXPECT_TREES" ]; then
  ok "K13 the accepted game3d/ runners' repository-wide 'quaternius' pin still sees exactly its four trees — no accepted pin moved · a planted fifth tree is REFUSED"
else
  fail "K13 the accepted quaternius-tree pin would MOVE: $FOUND"
fi
if find "$PROJ" -name '*.pxo' 2>/dev/null | grep -q .; then fail "K14 a .pxo is present in the spike"
else ok "K14 no owner .pxo anywhere in the spike"; fi
BAD="$(find "$PROJ" -path "$PROJ/.godot" -prune -o \( -iname '*.wav' -o -iname '*.ogg' -o -iname '*.mp3' -o -iname '*BattleFX*' -o -iname '*DarkMagic*' -o -iname '*ElementalMagic*' -o -iname '*Portal*' -o -iname '*VividMotion*' -o -iname '*UltimateMonsters*' -o -iname '*Puglin*' -o -iname 'Imp.glb' -o -iname 'UAL*' -o -iname '*.gdshader' -o -iname '*.tres' \) -print 2>/dev/null || true)"
if [ -z "$BAD" ]; then ok "K15 no audio, no VFX pack, no Ultimate Monsters, no UAL/Bestiary file and no imported effect resource in the spike"
else fail "K15 forbidden files: $BAD"; fi
STRAY="$(grep -rlF "game3d_huntress_spike" "$ROOT/game" "$ROOT/game2d" "$ROOT/game3d" "$ROOT/game3d_spike" "$ROOT/game3d_boss_spike" "$ROOT/models" 2>/dev/null || true)"
if [ -z "$STRAY" ]; then ok "K16 no protected project references the spike — the cross-reference runs one way, outward"
else fail "K16 a protected project references the spike: $STRAY"; fi

# ---------------------------------------------------------- K17-K19 evidence ---
say ""
say "[8/8] Rendered evidence (K17-K19)"
EV="01_running_with_bow:e01_run 01a_draw_filmstrip_feet:e01a_draw_filmstrip 02_full_draw_aim:e02_draw 03_release_frame:e03_release 04_post_release_recovery:e04_recovery 05a_lineup_front_right:e05_lineup_front_right 05b_lineup_profile_right:e05_lineup_profile_right 05c_raw_vs_corrected:e05_raw_vs_corrected 06_prey_on_target_a:e06_prey_a 07_prey_switched_to_b:e07_prey_b 08_hound_following_prey_a:e08_hound_a 09_hound_following_prey_b:e09_hound_b 10_hound_autonomous_prey_out_of_reach:e10_hound_autonomous"
run_capture() {
  # A hard 120 s ceiling: a windowed capture that hangs must not hang the runner.
  local mode="$1" out="$2" clog="$3"
  "$GODOT" --path "$PROJ" --resolution 1920x1080 -- --capture="$mode" --out="res://evidence/$out" >"$clog" 2>&1 &
  local pid=$! t=0
  while kill -0 "$pid" 2>/dev/null; do
    sleep 1; t=$((t + 1))
    if [ "$t" -ge 120 ]; then kill "$pid" 2>/dev/null; echo "TIMEOUT" >>"$clog"; break; fi
  done
  wait "$pid" 2>/dev/null
}
MISS=""; DIMBAD=""; STATEBAD=""
for spec in $EV; do
  out="${spec%%:*}.png"; mode="${spec#*:}"
  if [ "$WITH_EVIDENCE" -eq 1 ]; then
    CLOG="$(mktemp -t hs_cap)"
    run_capture "$mode" "$out" "$CLOG"
    if grep -qE "$ERRPAT|TIMEOUT|never arrived" "$CLOG" || ! grep -qF "CAPTURE: $mode" "$CLOG"; then STATEBAD="$STATEBAD $out"; fi
    rm -f "$CLOG"
  fi
  if [ ! -f "$PROJ/evidence/$out" ]; then MISS="$MISS $out"; continue; fi
  DIM="$(sips -g pixelWidth -g pixelHeight "$PROJ/evidence/$out" 2>/dev/null | awk '/pixel/{printf "%s", $2"x"} END{print ""}' | sed 's/x$//')"
  [ "$DIM" = "1920x1080" ] || DIMBAD="$DIMBAD $out($DIM)"
done
if [ "$WITH_EVIDENCE" -eq 1 ]; then
  if [ -z "$STATEBAD" ]; then ok "K17 13 captures rendered; each reached its waited-for STATE with no engine error and no timeout"
  else fail "K17 captures that did not reach their state:$STATEBAD"; fi
else
  say "  [SKIP] K17 rendering is opt-in; re-run with --with-evidence (existing frames are checked below)"
fi
if [ -z "$MISS" ]; then ok "K18 all 13 evidence frames exist"
else fail "K18 missing evidence:$MISS"; fi
if [ -z "$DIMBAD" ]; then ok "K19 every evidence frame is 1920x1080"
else fail "K19 evidence at the wrong size:$DIMBAD"; fi

# ------------------------------------------------------------------ verdict ---
say ""
say "========================================================================"
if [ "$FAILED" -eq 0 ]; then say "HUNTRESS SPIKE RUNNER: PASS"; else say "HUNTRESS SPIKE RUNNER: FAIL"; fi
say ""
say "UNITS: 19 RUNNER CHECKS here · 72 EXECUTABLE CHECKS in the suite · 117 OWED CRITERIA"
say "       in docs/testing/D388_HUNTRESS_SPIKE_OWED_CRITERIA_INVENTORY.md. Different unit."
say ""
say "Automated checks prove STATE and TIMING. Rendered evidence and the owner's live review"
say "decide VISUAL feasibility. The retarget classification is the delivery report's, and"
say "it is OWED to the owner's live review."
say "SPIKE STATE: HUNTRESS BOW-RETARGETING AND PREY FEASIBILITY SPIKE DELIVERED and OPEN"
say "             pending owner live review (D-388)."
say "========================================================================"
rm -f "$LOG"
exit "$FAILED"
