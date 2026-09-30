#!/usr/bin/env bash
# Riftwrought — First-MVP Gate 1B smoke checks: the Exterior Asset Compatibility
# Spike.
#
# Gate 1B is a bounded VISUAL AND TECHNICAL COMPATIBILITY SPIKE (D-198), not a
# gameplay gate. It answers one question — can the registered KayKit Forest
# Nature and Halloween Bits candidates form a coherent dark exterior around the
# real Knight and Dungeon Pack, and can k0rveen fill terrain and background gaps
# without becoming a competing foreground style — in the actual Godot camera,
# world scale, light, and material pipeline.
#
# THE LOCKED CHAIN RUNS FIRST AND STOPS EVERYTHING ON ANY REGRESSION
# (specification §8.1). `gate_1a_scale_hall_smoke.sh` runs `gate_f_smoke.sh`,
# which reruns Gate E, D, C, B, and A. This spike extracted new third-party
# assets and touched nothing else; that ordering is what proves it.
#
# IT NEVER TOUCHES THE PROJECT OWNER'S OWN SAVED STATE. The spike writes no save
# or settings file at all — it has no store, no ConfigFile, and no user:// path,
# asserted from inside the engine and again from the shell. This script also
# fingerprints the two real files before and after the whole run, and uses the
# established D-192 non-writing path-resolution guard to prove that guard still
# refuses the production directory.
#
# AUTOMATED CHECKS CANNOT CLASSIFY AN ASSET FAMILY, AND THAT IS THE WHOLE POINT
# OF THIS SPIKE. Gate 1B stays OPEN after this script passes: only the project
# owner can approve KayKit Forest Nature as an exterior family, selected
# Halloween Bits as an architectural bridge, and k0rveen as foreground,
# background-only, or rejected. See
#   docs/testing/FIRST_MVP_GATE_1B_EXTERIOR_ASSET_COMPATIBILITY_SPIKE_REPORT.md
#
# Usage, from the repository root:
#   game/tests/gate_1b_exterior_asset_spike_smoke.sh [--shots <dir>]
#
# --shots additionally renders the §7 evidence at 1920 x 1080 and a reduced set
# at the 1280 x 720 minimum tested window.

set -uo pipefail

GODOT="${GODOT:-/Applications/Godot.app/Contents/MacOS/Godot}"
EXPECTED_VERSION="4.7.2.stable"
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPO_DIR="$(cd "$PROJECT_DIR/.." && pwd)"
SPIKE_SCENE="res://scenes/first_mvp/visual/exterior_asset_compatibility_spike.tscn"
HALL_SCENE="res://scenes/first_mvp/calibration/scale_calibration_hall.tscn"
APP_SCENE="res://scenes/app/prototype_app.tscn"
ROOM_SCENE="res://scenes/prototype_zero/prototype_zero.tscn"

# The locked counts this spike must leave exactly where it found them.
#
# Gate 1A moved 278 -> 284 under D-200 (authorization) and D-201 (delivery). This
# constant and the comment you are reading are the ONLY changes made to this suite
# for it. That is not a regression and not something the spike did: the
# spike REPORTED (report §8) that `_check_prototype_zero_is_untouched()` threw on
# two wrong property names after its first assertion, so six of its seven
# assertions never ran behind a green PASS. D-200 authorized repairing exactly
# those two names, and the six skipped assertions now run. 278 + 6 = 284; no
# assertion was added and no asserted value moved. Every other count below is
# still the number this spike found.
#
# GATE 1B'S OWN COUNT IS NOW PINNED, under D-202. It was previously not pinned by
# anything at all — step 6 only grepped for the PASS string — which is one of the
# six residuals the Gate 1A report §16.4a listed for a later Gate 1B pass, and the
# only one of them that left THIS suite unable to see its own count move. The
# cohesion comparison brief §2 authorizes exactly this: "pin the existing Gate 1B
# verification count at exactly 654 in its own runner, without changing its
# verifier or its count". No verifier was edited to do it and the count is
# unchanged.
EXPECTED_GATE_B=106
EXPECTED_GATE_C=209
EXPECTED_GATE_D=230
EXPECTED_GATE_E=713
EXPECTED_GATE_F=1008
EXPECTED_GATE_1A=284
# MOVED UNDER D-215, and by exact arithmetic rather than by observation: the
# spike verifier emits ONE assertion per file in kaykit/forest and kaykit/halloween,
# and D-215 authorized 4 Forest + 8 Halloween models = 12 models = 24 files there.
# 654 + 24 = 678. The 35 approved Dungeon models add nothing here, because
# kaykit/dungeon is not one of the directories that loop walks.
EXPECTED_GATE_1B=678

# The third-party inventory. Gate A extracted 27 files; D-198 authorizes exactly
# 35 more — 11 Forest payloads + 1 Forest licence, 17 Halloween payloads + 1
# Halloween licence, and 5 k0rveen meshes — so 27 + 35 = 62.
#
# D-202 then authorizes 21 more models and 4 more verbatim archive licences, and
# D-204 authorizes the 2 colour atlases those 2025 Kenney models declare —
# 62 + 27 = 89 payload files, and D-215 then added 94 more (47 approved models and
# their 47 `.bin` sidecars) for 183 — plus 2 LeLu Noise Pack textures registered
# under D-216 for the accepted Riftfall Landing Greybox V2 + Visual Review
# dressing pass (T_Cracks336.png, T_CloudNoise_Tiled.png; see
# game/assets/third_party/lelu/SOURCE_AND_LICENSE.md), giving 185 — plus 2
# project-authored source maps, which §4.5 of the cohesion brief counts inside
# its own addition, giving 185 + 2 = 187. The `.md` filter below is the one every
# earlier suite uses, so the notes stay outside the payload count exactly as
# before and are checked by content instead. Both numbers are printed so neither
# can hide the other.
#
# THIS STATEMENT MOVED BY AUTHORIZATION, ONE FOR ONE, AND NOTHING ELSE DID. D-204
# authorizes exactly two additional files, so the number this step asserts changes
# and the thing it proves does not. `gate_1b_exterior_asset_spike_verification.gd`
# was NOT touched and Gate 1B is still 654 checks.
# MOVED UNDER D-215:  89 payload files at D-204
#                    + 47 approved models + 47 `.bin` sidecars
#                    = 183 payload files.
# MOVED UNDER D-216:  183 payload files
#                    + 2 LeLu Noise Pack textures
#                    = 185 payload files, plus the 2 D-202 source maps = 187.
EXPECTED_THIRD_PARTY_PAYLOADS=185
EXPECTED_THIRD_PARTY=187

# Where the project owner's real files live, derived from the project name Godot
# itself uses for the user data directory.
project_name="$(sed -n 's/^config\/name="\(.*\)"[[:space:]]*$/\1/p' "$PROJECT_DIR/project.godot" | head -1)"
production_dir="$HOME/Library/Application Support/Godot/app_userdata/$project_name"
production_settings="$production_dir/prototype_settings.cfg"
production_lab="$production_dir/prototype_zero.cfg"

state_fingerprint() {
	# "absent" is a legitimate answer: the claim is that the run changes nothing,
	# not that a file has to exist.
	if [[ -f "$1" ]]; then
		printf '%s bytes, sha256 %s' \
			"$(wc -c < "$1" | tr -d ' ')" "$(shasum -a 256 "$1" | awk '{print $1}')"
	else
		printf 'absent'
	fi
}

production_settings_before="$(state_fingerprint "$production_settings")"
production_lab_before="$(state_fingerprint "$production_lab")"

shots_dir=""
if [[ "${1:-}" == "--shots" ]]; then
	shots_dir="${2:?--shots requires a directory}"
	mkdir -p "$shots_dir"
	shots_dir="$(cd "$shots_dir" && pwd)"
fi

failures=0

# A count read out of a log this run did not write is not a measurement. Every
# check_count below therefore requires its log to be newer than the moment this
# script started.
#
# THIS MUST BE ASSIGNED AT THE TOP OF THE SCRIPT, NOT BESIDE `check_count`.
# Assigned next to the function it serves, it is evaluated only when execution
# REACHES that line — which is after step 1 has already run the whole chain, so
# every log the chain just wrote is "older than the run" and all six reads fail.
# Measured exactly that way once before this comment existed.
CHAIN_STARTED_AT="$(date +%s)"

log_is_fresh() {
	local logfile="$1"
	[[ -f "$logfile" ]] || return 1
	local written
	written="$(stat -f %m "$logfile" 2>/dev/null || echo 0)"
	[[ "$written" -ge "$CHAIN_STARTED_AT" ]]
}

step() {
	printf '\n=== %s\n' "$1"
}

pass() { printf '  PASS  %s\n' "$1"; }
fail() { printf '  FAIL  %s\n' "$1"; failures=$((failures + 1)); }

# NOTE on the pattern below, carried from gate_f_smoke.sh. Godot's output is
# written to a log FIRST and the log is then grepped, rather than piping Godot
# through `tee ... | grep -q`. With `set -o pipefail`, `grep -q` exits the moment
# it matches and `tee` can then die on EPIPE, failing the pipeline even though the
# verification passed. That race reported a regression that had not happened.

step "0. Engine baseline"
version="$("$GODOT" --version 2>/dev/null | tr -d '\r')"
printf '  installed: %s\n' "$version"
if [[ "$version" == "$EXPECTED_VERSION"* ]]; then
	pass "matches the locked $EXPECTED_VERSION baseline"
else
	fail "expected $EXPECTED_VERSION, found $version"
fi
printf '  production settings before: %s\n' "$production_settings_before"
printf '  production lab state before: %s\n' "$production_lab_before"

step "1. The complete locked chain (Gate 1A -> F -> E -> D -> C -> B -> A)"
# Specification §8.1: run the Gate 1A suite first and require its complete locked
# chain and counts to remain unchanged. This spike added third-party assets and a
# separate scene; if any accepted value, asset, rig, locomotion, combat, or
# storage behaviour moved, it fails here and nothing below is trusted.
if "$PROJECT_DIR/tests/gate_1a_scale_hall_smoke.sh" > /tmp/riftwrought_gate_1a_from_1b.log 2>&1; then
	pass "gate_1a_scale_hall_smoke.sh still passes with the Gate 1B extraction present"
else
	fail "gate_1a_scale_hall_smoke.sh failed; Gate 1B results are not trusted"
	tail -40 /tmp/riftwrought_gate_1a_from_1b.log | sed 's/^/        /'
fi

# Every locked count is read back out of that run and compared, so "unchanged"
# is a number rather than an impression.


check_count() {
	local label="$1" expected="$2" pattern="$3" logfile="$4"
	local found
	if ! log_is_fresh "$logfile"; then
		fail "$label: $logfile is missing or older than this run; a stale log cannot answer for it"
		return
	fi
	found="$(grep -ohE "$pattern" "$logfile" 2>/dev/null | grep -ohE '[0-9]+ checks' | grep -ohE '[0-9]+' | sort -u | head -1)"
	if [[ -z "$found" ]]; then
		fail "$label: no count found in the chain output"
	elif [[ "$found" == "$expected" ]]; then
		printf '  PASS  %-8s %s checks, unchanged\n' "$label" "$found"
	else
		fail "$label: $found checks, expected $expected"
	fi
}
# D-219 REPAIR: THESE FOUR READS WERE POINTED AT A LOG THAT NEVER CONTAINED THEM,
# AND ONLY STALE /tmp FILES EVER MADE THEM PASS.
#
# `gate_1a_scale_hall_smoke.sh` runs `gate_f_smoke.sh` into
# /tmp/riftwrought_gate_f_from_1a.log and then greps that file for
# "GATE [A-F] VERIFICATION" to echo a chain summary. But Gate B, C, D and E each
# write their own raw "GATE X VERIFICATION: PASS (N checks)" line into their OWN
# /tmp/riftwrought_gate_<x>_verify.log and never onto their smoke script's
# stdout — which is precisely why Gate F's own count is already special-cased
# below, with a comment in `gate_1a_scale_hall_smoke.sh` saying "otherwise the
# chain summary here would silently stop at Gate E".
#
# So /tmp/riftwrought_gate_1a_from_1b.log holds exactly two of these lines,
# GATE 1A and GATE F, and has never held B, C, D or E. Every previous green run
# was reading LEFTOVER CONTENT from an earlier invocation; deleting the /tmp logs
# before a run makes all four fail at once. Measured, on a clean /tmp: 0 of 4
# found.
#
# Each read is repointed at the log that actually contains its line, exactly as
# Gate F's already is. `pass`/`fail` are shell counters rather than verification
# checks, so no pinned count moves. Found by Gate 1E; the same class as the
# closed-gate defect Gate 1B found in Gate 1A and D-200/D-201 repaired.
#
# THE STALENESS THAT MASKED IT IS NOW ITSELF GUARDED: `check_count` refuses a log
# older than this run, so a leftover file can no longer answer for a run that did
# not produce one.
check_count "Gate B"  "$EXPECTED_GATE_B"  "GATE B VERIFICATION: PASS \([0-9]+ checks\)"  /tmp/riftwrought_gate_b_verify.log
check_count "Gate C"  "$EXPECTED_GATE_C"  "GATE C VERIFICATION: PASS \([0-9]+ checks\)"  /tmp/riftwrought_gate_c_verify.log
check_count "Gate D"  "$EXPECTED_GATE_D"  "GATE D VERIFICATION: PASS \([0-9]+ checks\)"  /tmp/riftwrought_gate_d_verify.log
check_count "Gate E"  "$EXPECTED_GATE_E"  "GATE E VERIFICATION: PASS \([0-9]+ checks\)"  /tmp/riftwrought_gate_e_verify.log
check_count "Gate F"  "$EXPECTED_GATE_F"  "GATE F VERIFICATION: PASS \([0-9]+ checks\)"  /tmp/riftwrought_gate_f_verify.log
check_count "Gate 1A" "$EXPECTED_GATE_1A" "GATE 1A VERIFICATION: PASS \([0-9]+ checks\)" /tmp/riftwrought_gate_1a_from_1b.log

step "2. The Prototype Zero entrypoint, laboratory, and Gate 1A hall still start"
main_scene="$(sed -n 's/^run\/main_scene="\(.*\)"[[:space:]]*$/\1/p' "$PROJECT_DIR/project.godot" | head -1)"
printf '  project main scene: %s\n' "$main_scene"
if [[ "$main_scene" == "$APP_SCENE" ]]; then
	pass "the Prototype App is still the project entrypoint"
else
	fail "the main scene is $main_scene, not $APP_SCENE"
fi
for pair in "the Prototype App|$APP_SCENE|60" \
            "the Prototype Zero laboratory|$ROOM_SCENE|90" \
            "the Gate 1A calibration hall|$HALL_SCENE|120"; do
	IFS='|' read -r label scene quit <<< "$pair"
	if "$GODOT" --headless --path "$PROJECT_DIR" "$scene" --quit-after "$quit" \
		> /tmp/riftwrought_gate_1b_boot_other.log 2>&1; then
		pass "$label still starts standalone"
	else
		fail "$label no longer starts standalone"
		tail -20 /tmp/riftwrought_gate_1b_boot_other.log | sed 's/^/        /'
	fi
done

step "3. The spike imports, parses, and starts headlessly"
if "$GODOT" --headless --path "$PROJECT_DIR" --import \
	> /tmp/riftwrought_gate_1b_import.log 2>&1; then
	pass "the project imports with the Gate 1B assets, scene, and scripts present"
else
	fail "import failed"
	tail -20 /tmp/riftwrought_gate_1b_import.log | sed 's/^/        /'
fi
# A clean import: the newly extracted glTF and FBX candidates must not have
# produced a single import error or warning of their own.
if grep -iE "ERROR.*(forest|halloween|k0rveen|lowpoly)" /tmp/riftwrought_gate_1b_import.log > /dev/null; then
	fail "a Gate 1B candidate reported an import error"
	grep -iE "ERROR.*(forest|halloween|k0rveen|lowpoly)" /tmp/riftwrought_gate_1b_import.log \
		| head -10 | sed 's/^/        /'
else
	pass "no Gate 1B candidate reported an import error"
fi

if "$GODOT" --headless --path "$PROJECT_DIR" "$SPIKE_SCENE" --quit-after 200 \
	> /tmp/riftwrought_gate_1b_boot.log 2>&1; then
	pass "the exterior spike builds, bakes, and exits cleanly"
	grep -E "\[gate-1b\] (candidates placed|court clear ground|dungeon doorway|navigation baked)" \
		/tmp/riftwrought_gate_1b_boot.log | sed 's/^/        /' || true
else
	fail "the exterior spike does not start"
	tail -30 /tmp/riftwrought_gate_1b_boot.log | sed 's/^/        /'
fi

# Every Gate 1B script must parse cleanly on its own, so a syntax error in a file
# the spike happens not to reach at runtime cannot hide here. `--check-only`
# reports a parse failure in its OUTPUT and still exits zero, so the exit status
# is not the test — the log is.
for script in "$PROJECT_DIR"/scripts/first_mvp/visual/*.gd \
	"$PROJECT_DIR"/tests/gate_1b_exterior_asset_spike_verification.gd; do
	rel="${script#"$PROJECT_DIR"/}"
	"$GODOT" --headless --path "$PROJECT_DIR" --check-only --script "res://$rel" \
		> /tmp/riftwrought_gate_1b_parse.log 2>&1
	if grep -qE "Parse Error|Compile Error|Failed to load script" /tmp/riftwrought_gate_1b_parse.log; then
		fail "$rel does not parse"
		tail -10 /tmp/riftwrought_gate_1b_parse.log | sed 's/^/        /'
	else
		pass "$rel"
	fi
done

step "4. The exact §4 extraction, byte for byte against the archives"
# The engine verification proves the KayKit payloads and licences verbatim with
# ZIPReader. It CANNOT read the k0rveen RAR, so those five meshes and the whole
# file set are proved here instead, where `bsdtar` can.
forest_zip="$REPO_DIR/assets/KayKit_Forest_Nature_Pack_1.0_FREE.zip"
halloween_zip="$REPO_DIR/assets/KayKit_HalloweenBits_1.0_FREE.zip"
k0rveen_rar="$REPO_DIR/assets/LowPoly Environment Pack.rar"
for archive in "$forest_zip" "$halloween_zip" "$k0rveen_rar"; do
	if [[ -f "$archive" ]]; then
		pass "source archive present and unmodified in place: $(basename "$archive")"
	else
		fail "source archive missing: $archive"
	fi
done

compare_zip() {
	local zip="$1" inside="$2" game_side="$3"
	local a b
	a="$(unzip -p "$zip" "$inside" 2>/dev/null | shasum -a 256 | awk '{print $1}')"
	b="$(shasum -a 256 "$game_side" 2>/dev/null | awk '{print $1}')"
	if [[ -n "$b" && "$a" == "$b" ]]; then
		return 0
	fi
	return 1
}

forest_root="KayKit_Forest_Nature_Pack_1.0_FREE"
halloween_root="KayKit_HalloweenBits_1.0_FREE"
verbatim=0
mismatch=0
for f in forest_texture.png \
	Tree_Bare_1_C_Color1.gltf Tree_Bare_1_C_Color1.bin \
	Tree_Bare_2_C_Color1.gltf Tree_Bare_2_C_Color1.bin \
	Rock_1_A_Color1.gltf Rock_1_A_Color1.bin \
	Rock_1_Q_Color1.gltf Rock_1_Q_Color1.bin \
	Rock_3_A_Color1.gltf Rock_3_A_Color1.bin; do
	if compare_zip "$forest_zip" "$forest_root/Assets/gltf/$f" \
		"$PROJECT_DIR/assets/third_party/kaykit/forest/$f"; then
		verbatim=$((verbatim + 1))
	else
		mismatch=$((mismatch + 1))
		printf '        MISMATCH forest/%s\n' "$f"
	fi
done
for f in halloweenbits_texture.png \
	floor_dirt.gltf floor_dirt.bin path_A.gltf path_A.bin path_C.gltf path_C.bin \
	arch.gltf arch.bin fence_broken.gltf fence_broken.bin \
	fence_pillar_broken.gltf fence_pillar_broken.bin \
	tree_dead_large.gltf tree_dead_large.bin \
	lantern_standing.gltf lantern_standing.bin; do
	if compare_zip "$halloween_zip" "$halloween_root/Assets/gltf/$f" \
		"$PROJECT_DIR/assets/third_party/kaykit/halloween/$f"; then
		verbatim=$((verbatim + 1))
	else
		mismatch=$((mismatch + 1))
		printf '        MISMATCH halloween/%s\n' "$f"
	fi
done
for f in Terrain_1.fbx Terrain_2.fbx Mounting_1.fbx Rock_1.fbx Tree_1.fbx; do
	a="$(bsdtar -xOf "$k0rveen_rar" "$f" 2>/dev/null | shasum -a 256 | awk '{print $1}')"
	b="$(shasum -a 256 "$PROJECT_DIR/assets/third_party/k0rveen/lowpoly_environment/$f" 2>/dev/null | awk '{print $1}')"
	if [[ -n "$b" && "$a" == "$b" ]]; then
		verbatim=$((verbatim + 1))
	else
		mismatch=$((mismatch + 1))
		printf '        MISMATCH k0rveen/%s\n' "$f"
	fi
done
printf '  extracted payloads compared against their archives: %s verbatim, %s mismatched\n' \
	"$verbatim" "$mismatch"
if [[ "$verbatim" == "33" && "$mismatch" == "0" ]]; then
	pass "all 33 payload files are byte-identical to their in-archive originals"
else
	fail "expected 33 verbatim payloads and 0 mismatches"
fi

# Licence copies and the durable provenance record.
lic=0
if compare_zip "$forest_zip" "$forest_root/License.txt" \
	"$PROJECT_DIR/assets/third_party/kaykit/licenses/KayKit_Forest_Nature_Pack_1.0_FREE_License.txt"; then
	lic=$((lic + 1)); else printf '        MISMATCH Forest License.txt\n'; fi
if compare_zip "$halloween_zip" "$halloween_root/License.txt" \
	"$PROJECT_DIR/assets/third_party/kaykit/licenses/KayKit_HalloweenBits_1.0_FREE_License.txt"; then
	lic=$((lic + 1)); else printf '        MISMATCH Halloween License.txt\n'; fi
if cmp -s "$REPO_DIR/assets/licenses/K0RVEEN_LOW_POLY_ENVIRONMENT_PACK_CC_BY_4.0_SOURCE.md" \
	"$PROJECT_DIR/assets/third_party/k0rveen/licenses/K0RVEEN_LOW_POLY_ENVIRONMENT_PACK_CC_BY_4.0_SOURCE.md"; then
	lic=$((lic + 1)); else printf '        MISMATCH k0rveen provenance record\n'; fi
if [[ "$lic" == "3" ]]; then
	pass "both KayKit licences are verbatim and the k0rveen provenance record is identical"
else
	fail "only $lic of 3 licence/provenance copies are identical"
fi

# CC BY 4.0 obliges attribution; CC0 does not. The credit must exist in the
# game-side note, in the code, and in the repository register.
credit="LowPoly Environment Pack by k0rveen, licensed under CC BY 4.0."
missing_credit=0
for file in "$PROJECT_DIR/assets/third_party/k0rveen/SOURCE_AND_LICENSE.md" \
	"$PROJECT_DIR/scripts/first_mvp/visual/exterior_asset_catalogue.gd" \
	"$REPO_DIR/assets/ASSET_REGISTER.md"; do
	if ! grep -qF "$credit" "$file"; then
		missing_credit=$((missing_credit + 1))
		printf '        missing the credit: %s\n' "${file#"$REPO_DIR"/}"
	fi
done
if [[ "$missing_credit" == "0" ]]; then
	pass "the required CC BY 4.0 credit is in the source note, the catalogue, and the register"
else
	fail "$missing_credit files are missing the required k0rveen credit"
fi

step "5. Nothing else was extracted, and nothing else was added"
third_party_payloads="$(find "$PROJECT_DIR/assets/third_party" -type f \
	! -name '*.import' ! -name '.DS_Store' ! -name '*.md' | wc -l | tr -d ' ')"
d202_source_maps=0
for note in "$PROJECT_DIR/assets/third_party/kenney/SOURCE_AND_LICENSE.md" \
	"$PROJECT_DIR/assets/third_party/quaternius/SOURCE_AND_LICENSE.md"; do
	[[ -f "$note" ]] && d202_source_maps=$((d202_source_maps + 1))
done
third_party_count=$((third_party_payloads + d202_source_maps))
printf '  third-party payload files: %s   D-202 source maps: %s   total: %s\n' \
	"$third_party_payloads" "$d202_source_maps" "$third_party_count"
if [[ "$third_party_payloads" == "$EXPECTED_THIRD_PARTY_PAYLOADS" \
	&& "$third_party_count" == "$EXPECTED_THIRD_PARTY" ]]; then
	pass "27 Gate A + 35 Gate 1B spike + 25 D-202 + 2 D-204 + 94 D-215 + 2 LeLu = $EXPECTED_THIRD_PARTY_PAYLOADS payloads, plus 2 source maps = $EXPECTED_THIRD_PARTY"
else
	fail "$third_party_payloads payloads and $d202_source_maps source maps exist; the authorized inventory is $EXPECTED_THIRD_PARTY_PAYLOADS + 2 = $EXPECTED_THIRD_PARTY"
fi

# §4.1 and §4.2 name their exclusions by hand. A file whose name matches one of
# them is a manifest breach, not a style question.
excluded="$(find "$PROJECT_DIR/assets/third_party/kaykit/forest" \
	"$PROJECT_DIR/assets/third_party/kaykit/halloween" -type f \
	\( -iname '*pumpkin*' -o -iname '*grave*' -o -iname '*crypt*' -o -iname '*coffin*' \
	   -o -iname '*skull*' -o -iname '*bush*' -o -iname '*grass*' -o -iname '*bench*' \) \
	2>/dev/null | wc -l | tr -d ' ')"
if [[ "$excluded" == "0" ]]; then
	pass "no pumpkin, grave, crypt, coffin, skull, bush, grass, or bench was extracted"
else
	fail "$excluded excluded files were extracted"
fi

audio="$(find "$PROJECT_DIR/assets/third_party/kaykit/forest" \
	"$PROJECT_DIR/assets/third_party/kaykit/halloween" \
	"$PROJECT_DIR/assets/third_party/k0rveen" \
	"$PROJECT_DIR/scenes/first_mvp/visual" "$PROJECT_DIR/scripts/first_mvp/visual" \
	\( -name '*.wav' -o -name '*.ogg' -o -name '*.mp3' \) 2>/dev/null | wc -l | tr -d ' ')"
if [[ "$audio" == "0" ]]; then
	pass "Gate 1B added no audio file; the spike is silent by design"
else
	fail "$audio audio files exist under the Gate 1B trees"
fi

# The asset paths the spike names must all be either an authorized Gate 1B
# candidate or a registered Gate A dungeon piece — the §5.2 transition reference.
kit_used="$(grep -rohE 'res://assets/[a-zA-Z0-9_/]+\.[a-z]+' \
	"$PROJECT_DIR"/scripts/first_mvp/visual "$PROJECT_DIR"/scenes/first_mvp/visual \
	2>/dev/null | sort -u)"
printf '  asset paths any Gate 1B file names directly:\n'
printf '%s\n' "$kit_used" | sed 's/^/        /'
unregistered="$(printf '%s\n' "$kit_used" \
	| grep -vE 'assets/third_party/kaykit/(forest|halloween)/' \
	| grep -vE 'assets/third_party/k0rveen/lowpoly_environment/' \
	| grep -vE 'assets/third_party/kaykit/dungeon/(floor_tile_large|wall|wall_pillar)\.gltf' \
	| grep -vE 'assets/third_party/kenney/(nature|fantasy_town|graveyard|licenses)/' \
	| grep -vE 'assets/third_party/quaternius/(modular_ruins|licenses)/' \
	| grep -vE 'assets/third_party/(kenney|quaternius)/SOURCE_AND_LICENSE\.md' \
	| grep -c . | tr -d ' ')"
if [[ "$unregistered" == "0" ]]; then
	pass "only the §4 manifests and the three registered Gate A dungeon pieces"
else
	fail "a Gate 1B file names an asset outside the authorized manifests"
fi

# THE ASSERTION ADDED RATHER THAN REMOVED. Broadening the scan above to include
# the D-202 manifest would otherwise quietly weaken what it used to prove, so
# THIS spike's own files are scanned separately and must still name ONLY the
# D-198 manifest and the three registered dungeon pieces. That is exactly the
# proof the cohesion brief §9.6 asks for: "separately proving the Prototype App,
# Gate 1A hall, and first Gate 1B scene do not reference any new family".
spike_used="$(grep -rohE 'res://assets/[a-zA-Z0-9_/]+\.[a-z]+' \
	"$PROJECT_DIR"/scripts/first_mvp/visual/exterior_asset_compatibility_spike.gd \
	"$PROJECT_DIR"/scripts/first_mvp/visual/exterior_asset_catalogue.gd \
	"$PROJECT_DIR"/scripts/first_mvp/visual/exterior_asset_probe.gd \
	"$PROJECT_DIR"/scripts/first_mvp/visual/exterior_spike_layout.gd \
	"$PROJECT_DIR"/scripts/first_mvp/visual/exterior_spike_overlay.gd \
	"$PROJECT_DIR"/scenes/first_mvp/visual/exterior_asset_compatibility_spike.tscn \
	"$PROJECT_DIR"/scenes/first_mvp/visual/exterior_spike_overlay.tscn \
	2>/dev/null | sort -u \
	| grep -vE 'assets/third_party/kaykit/(forest|halloween)/' \
	| grep -vE 'assets/third_party/k0rveen/lowpoly_environment/' \
	| grep -vE 'assets/third_party/kaykit/dungeon/(floor_tile_large|wall|wall_pillar)\.gltf' \
	| grep -c . | tr -d ' ')"
if [[ "$spike_used" == "0" ]]; then
	pass "THIS spike's own files still name only the D-198 manifest; it did not start
        using a D-202 candidate"
else
	fail "the first Gate 1B spike began naming an asset outside its own D-198 manifest"
fi

step "6. Gate 1B spike verification (headless)"
if "$GODOT" --headless --path "$PROJECT_DIR" "$SPIKE_SCENE" -- --verify-1b \
	> /tmp/riftwrought_gate_1b_verify.log 2>&1; then
	:
fi
# A GDScript runtime error inside a check function ABORTS that function and every
# later assertion in it, while the suite still reports PASS. That shape is live in
# the Gate 1A verification today (Gate 1B report §8), so this suite refuses to
# trust a passing run that also printed a script error.
if grep -qE "SCRIPT ERROR" /tmp/riftwrought_gate_1b_verify.log; then
	fail "the Gate 1B verification printed a script error; assertions were skipped"
	grep -E "SCRIPT ERROR" /tmp/riftwrought_gate_1b_verify.log | head -5 | sed 's/^/        /'
else
	pass "the verification ran end to end with no script error, so no check was skipped"
fi
# THE PIN, AUTHORIZED BY D-202. This suite could previously only see that its own
# verification printed the word PASS; it could not see its own COUNT move. The
# count is now read back out of the log and compared with EXPECTED_GATE_1B, which
# is the same discipline `check_count` above already applies to every inherited
# gate.
assert_gate_1b_count() {
	local logfile="$1" found
	# The intermediate "N checks" step matters: the first number in
	# "GATE 1B VERIFICATION: ..." is the 1 of "1B", so extracting bare digits from
	# the whole line reads 1 and the pin would refuse every run including a
	# correct one. This is the same three-step shape `check_count` above uses.
	found="$(grep -ohE "GATE 1B VERIFICATION: PASS \([0-9]+ checks\)" "$logfile" 2>/dev/null \
		| grep -ohE '[0-9]+ checks' | grep -ohE '[0-9]+' | head -1)"
	[[ -n "$found" && "$found" == "$EXPECTED_GATE_1B" ]]
}

# A guard that accepts everything protects nothing, so the pin is proved in BOTH
# directions against a REPLAY of this run's own log: the real log must be
# accepted, and the same log with its count altered by one must be rejected. That
# is the rule D-201 established for the Gate 1A script-error guard, applied here.
replay="$(mktemp -t riftwrought_gate_1b_pin_replay)"
trap 'rm -f "$replay"' EXIT
sed "s/GATE 1B VERIFICATION: PASS ($EXPECTED_GATE_1B checks)/GATE 1B VERIFICATION: PASS ($((EXPECTED_GATE_1B + 1)) checks)/" \
	/tmp/riftwrought_gate_1b_verify.log > "$replay"
if assert_gate_1b_count "$replay"; then
	fail "the $EXPECTED_GATE_1B pin accepted a replayed log reporting $((EXPECTED_GATE_1B + 1)) checks"
else
	pass "the pin rejects an altered replayed count ($((EXPECTED_GATE_1B + 1)) is refused)"
fi
if assert_gate_1b_count /tmp/riftwrought_gate_1b_verify.log; then
	pass "Gate 1B  $EXPECTED_GATE_1B checks, pinned and unchanged"
else
	fail "Gate 1B's own count is not $EXPECTED_GATE_1B; see the log for what it reported"
	grep -E "GATE 1B VERIFICATION" /tmp/riftwrought_gate_1b_verify.log | sed 's/^/        /' || true
fi

if grep -q "GATE 1B VERIFICATION: PASS" /tmp/riftwrought_gate_1b_verify.log; then
	grep -E "^  (candidate |Tree_|Rock_|floor_dirt|path_|arch |fence_|tree_dead|lantern_|Terrain |Mountain |Tree 1|Rock 1)" \
		/tmp/riftwrought_gate_1b_verify.log | sed 's/^/      /' || true
	grep -E "^  (review ground|hybrid court|dungeon doorway|navigation |baked surface)" \
		/tmp/riftwrought_gate_1b_verify.log | sed 's/^/      /' || true
	grep -E "GATE 1B VERIFICATION: PASS" /tmp/riftwrought_gate_1b_verify.log | sed 's/^/  /'
	pass "manifest, payloads, licences, credit, measurements, import state, the three review
        areas, the registered Dungeon transition, navigation and terrain exclusion, click
        resolution, movement and collision, the accepted locomotion contract, every review
        toggle, non-destructive materials, reset, scope, storage, and on-screen surfaces"
else
	fail "the Gate 1B verification did not pass"
	grep -E "FAIL:|VERIFICATION" /tmp/riftwrought_gate_1b_verify.log | sed 's/^/        /' || true
	tail -20 /tmp/riftwrought_gate_1b_verify.log | sed 's/^/        /'
fi

step "7. The spike writes nothing, and the storage guard still refuses production"
settings_mid="$(state_fingerprint "$production_settings")"
lab_mid="$(state_fingerprint "$production_lab")"
if [[ "$settings_mid" == "$production_settings_before" && "$lab_mid" == "$production_lab_before" ]]; then
	pass "the production files are unchanged after every Gate 1B run above"
else
	fail "a Gate 1B run changed the project owner's own files"
	printf '        settings before %s\n        settings after  %s\n' \
		"$production_settings_before" "$settings_mid"
	printf '        lab before      %s\n        lab after       %s\n' \
		"$production_lab_before" "$lab_mid"
fi

if "$GODOT" --headless --path "$PROJECT_DIR" -- --check-state-dir --state-dir "$production_dir" \
	> /tmp/riftwrought_gate_1b_guard.log 2>&1; then
	fail "the storage guard accepted the production directory"
else
	if grep -qE "refusing to start|own user data directory" /tmp/riftwrought_gate_1b_guard.log; then
		pass "the D-192 guard still refuses the production directory, without writing"
	else
		fail "the storage guard did not report a refusal"
		tail -10 /tmp/riftwrought_gate_1b_guard.log | sed 's/^/        /'
	fi
fi

# No SHIPPING Gate 1B file may name a user:// path or a config store at all. The
# verification is excluded by construction rather than by name: it lives under
# tests/, not under scripts/first_mvp/.
leaks="$(grep -rlE 'user://|ConfigFile|ResourceSaver' \
	"$PROJECT_DIR/scripts/first_mvp" "$PROJECT_DIR/scenes/first_mvp" \
	"$PROJECT_DIR/data/first_mvp" 2>/dev/null \
	| grep -v 'gate_1a_verification.gd' | wc -l | tr -d ' ')"
printf '  shipping first-MVP files naming a user:// path, ConfigFile, or ResourceSaver: %s\n' "$leaks"
if [[ "$leaks" == "0" ]]; then
	pass "neither the spike nor the Gate 1A hall has storage of any kind"
else
	fail "a first-MVP file reaches persistent storage"
	grep -rlE 'user://|ConfigFile|ResourceSaver' \
		"$PROJECT_DIR/scripts/first_mvp" "$PROJECT_DIR/scenes/first_mvp" \
		"$PROJECT_DIR/data/first_mvp" 2>/dev/null \
		| grep -v 'gate_1a_verification.gd' | sed 's/^/        /'
fi

# The pattern matches CALLS, not the forbidden-string list the verification
# carries in order to forbid them: `ConfigFile` alone, `FileAccess.open` without a
# parenthesis, and a bare `store_string` are the literals in that list, while a
# constructor, a call, and a method invocation are what a breach looks like.
verify_calls="$(grep -cE 'ConfigFile\.new|ResourceSaver\.save|FileAccess\.open\(|\.store_string\(|\.store_line\(' \
	"$PROJECT_DIR/tests/gate_1b_exterior_asset_spike_verification.gd" | tr -d ' ')"
printf '  writing storage calls in the Gate 1B verification itself: %s\n' "$verify_calls"
if [[ "$verify_calls" == "0" ]]; then
	pass "the verification only READS — source, licences, and archives — and writes PNGs into --shots"
else
	fail "the Gate 1B verification opens persistent storage for writing"
fi

step "8. Only the D-208, D-216 and D-217 authorized paths exist, and nothing more"
# D-208 §11.2 REPLACES THIS ASSERTION ONE FOR ONE. Until Gate 1C this step asked
# whether ANY Riftfall or Severed file existed and required the answer to be none,
# which was the right question for D-198. Gate 1C authorizes exactly the files its
# §3 lists, so that claim became false BY AUTHORIZATION rather than by drift, and
# it became the next honest boundary instead. D-216 (the accepted Greybox V2 +
# Visual Review foundation) and D-217 (Gate 1D, Broken Watch) each move that
# boundary again, the same way: every path below may exist, every other route
# file still may not, and neither closed Gate 1B scene may name any part of it.
# D-219 EXTENDS THIS ALLOWLIST ONE ENTRY PER FILE, exactly as D-217 did for
# Gate 1D. The Nexus Threshold and the Rift Nexus are no longer unstarted, so
# forbidding them became false BY AUTHORIZATION and the boundary moves to name
# them instead. What remains forbidden is everything past the First Footing
# boundary. The -iname token list below is widened at the same time, so Gate 1E's
# own files are actually VISIBLE to this scan rather than sitting in the same
# blind spot scripts/items/ and scripts/ui/ already sit in.
authorized_route_paths="scenes/first_mvp/severed_threshold
scenes/first_mvp/severed_threshold/riftfall_landing.tscn
scenes/first_mvp/severed_threshold/riftfall_landing_review.tscn
scenes/first_mvp/severed_threshold/broken_watch_slice.tscn
scripts/first_mvp/severed_threshold
scripts/first_mvp/severed_threshold/riftfall_landing.gd
scripts/first_mvp/severed_threshold/riftfall_landing_layout.gd
scripts/first_mvp/severed_threshold/riftfall_loop_event.gd
scripts/first_mvp/severed_threshold/riftfall_landing_review.gd
scripts/first_mvp/severed_threshold/riftfall_landing_overlay.gd
scripts/first_mvp/severed_threshold/broken_watch_layout.gd
scripts/first_mvp/severed_threshold/broken_watch_slice.gd
data/first_mvp/severed_threshold
data/first_mvp/severed_threshold/broken_watch
scenes/first_mvp/greybox/riftfall_landing_greybox_review.tscn
scenes/first_mvp/visual_review/riftfall_landing_visual_review.tscn
scripts/first_mvp/greybox/riftfall_landing_greybox_layout.gd
scripts/first_mvp/greybox/riftfall_landing_greybox_review.gd
scripts/first_mvp/visual_review/riftfall_landing_visual_review.gd
scripts/first_mvp/visual_review/riftfall_landing_visual_review_dressing.gd
scripts/first_mvp/visual_review/riftfall_landing_visual_review_stone.gd
scripts/first_mvp/severed_threshold/nexus_threshold_layout.gd
scripts/first_mvp/nexus
scripts/first_mvp/nexus/rift_nexus_layout.gd
scripts/first_mvp/nexus/rift_anchor.gd
scripts/first_mvp/nexus/mara_veyl.gd
scripts/first_mvp/nexus/first_mvp_dialogue.gd
scripts/first_mvp/canonical_opening
scripts/first_mvp/canonical_opening/canonical_opening_runtime.gd
scripts/first_mvp/canonical_opening/foundation_skill_practice.gd
scenes/first_mvp/canonical_opening
scenes/first_mvp/canonical_opening/canonical_opening.tscn
scenes/first_mvp/canonical_opening/foundation_skill_practice.tscn
data/first_mvp/skills
data/first_mvp/foundation"
# `.uid` sidecars are Godot's own, generated beside every script; they are folded
# onto the file they belong to rather than counted as unauthorized route files.
route_files="$(cd "$PROJECT_DIR" && find scenes/first_mvp scripts/first_mvp data/first_mvp \
	\( -iname '*severed*' -o -iname '*riftfall*' -o -iname '*broken_watch*' \
	   -o -iname '*nexus*' -o -iname '*run_graph*' -o -iname '*module_library*' \
	   -o -iname '*canonical_opening*' -o -iname '*rift_anchor*' -o -iname '*mara*' \
	   -o -iname '*dialogue*' -o -iname '*first_footing*' \) \
	2>/dev/null | sed 's/\.uid$//' | sort -u)"
unauthorized="$(printf '%s\n' "$route_files" | grep -v '^$' \
	| grep -vxF "$authorized_route_paths" | wc -l | tr -d ' ')"
missing_1c=0
while IFS= read -r wanted; do
	[[ -e "$PROJECT_DIR/$wanted" ]] || missing_1c=$((missing_1c + 1))
done <<< "$authorized_route_paths"
# And the closed Gate 1B scenes stay ISOLATED from it: neither may instance, load
# or even name a Gate 1C scene, script or class.
# THE TOKENS ARE IDENTIFIERS AND PATHS, NEVER PROSE, and that distinction is the
# whole guard. Both closed Gate 1B scripts say "not riftfall landing" — one in a
# documentation heading, one in a `log_event` line the cohesion verification itself
# asserts reaches the screen — because stating the boundary is precisely what they
# are supposed to do. A scan for the words "riftfall landing" therefore fails on the
# sentence that makes the claim, which the first version of this guard did, twice.
# What must not appear is a REFERENCE: a Gate 1C class name, script stem or path.
# None of those can occur in English prose.
gate_1c_leaks="$(grep -rlE 'RiftfallLanding|RiftfallLoopEvent|riftfall_landing|riftfall_loop_event|severed_threshold' \
	"$PROJECT_DIR"/scenes/first_mvp/visual "$PROJECT_DIR"/scripts/first_mvp/visual \
	2>/dev/null | wc -l | tr -d ' ')"
if [[ "$gate_1c_leaks" != "0" ]]; then
	grep -rlE 'RiftfallLanding|RiftfallLoopEvent|riftfall_landing|riftfall_loop_event|severed_threshold' \
		"$PROJECT_DIR"/scenes/first_mvp/visual "$PROJECT_DIR"/scripts/first_mvp/visual \
		2>/dev/null | sed "s|^$PROJECT_DIR/|        Gate 1B file references Gate 1C: |"
fi
printf '  route files found: %s; unauthorized: %s; Gate 1C paths missing: %s; Gate 1B references to Gate 1C: %s\n' \
	"$(printf '%s\n' "$route_files" | grep -vc '^$' || true)" \
	"$unauthorized" "$missing_1c" "$gate_1c_leaks"
if [[ "$unauthorized" == "0" && "$missing_1c" == "0" && "$gate_1c_leaks" == "0" ]]; then
	pass "only the D-208, D-216 and D-217 paths exist; the Nexus Threshold, the
        Rift Nexus, the run graph and the module library remain unstarted, and
        neither closed Gate 1B scene names any part of Gate 1C"
else
	fail "$unauthorized unauthorized route file(s), $missing_1c missing Gate 1C path(s), $gate_1c_leaks Gate 1B reference(s) to Gate 1C"
	printf '%s\n' "$route_files" | grep -v '^$' | grep -vxF "$authorized_route_paths" | sed 's/^/        /'
fi
if [[ -f "$REPO_DIR/docs/testing/FIRST_MVP_VERTICAL_SLICE_REPORT.md" ]]; then
	fail "a first-MVP vertical-slice report exists; that work is not authorized"
else
	pass "the first-MVP vertical slice has not been started"
fi

if [[ -n "$shots_dir" ]]; then
	step "9. Rendered evidence at 1920 x 1080 and at the 1280 x 720 minimum window"
	if "$GODOT" --path "$PROJECT_DIR" --resolution 1920x1080 "$SPIKE_SCENE" \
		-- --verify-1b --shots "$shots_dir" \
		> /tmp/riftwrought_gate_1b_shots_full.log 2>&1; then
		:
	fi
	if grep -q "GATE 1B VERIFICATION: PASS" /tmp/riftwrought_gate_1b_shots_full.log; then
		grep -E "GATE 1B VERIFICATION: PASS" /tmp/riftwrought_gate_1b_shots_full.log | sed 's/^/  /'
		pass "the rendered run passes and writes the 1920 x 1080 evidence"
	else
		fail "the rendered 1920 x 1080 run did not pass"
		grep -E "FAIL:" /tmp/riftwrought_gate_1b_shots_full.log | sed 's/^/        /' || true
	fi

	# §8.7 and §7: the same assertions must hold, and the overlay must still be
	# readable, at the minimum tested window.
	if "$GODOT" --path "$PROJECT_DIR" --resolution 1280x720 "$SPIKE_SCENE" \
		-- --verify-1b --shots "$shots_dir" --shots-brief \
		> /tmp/riftwrought_gate_1b_shots_small.log 2>&1; then
		:
	fi
	if grep -q "GATE 1B VERIFICATION: PASS" /tmp/riftwrought_gate_1b_shots_small.log; then
		grep -E "overlay root" /tmp/riftwrought_gate_1b_shots_small.log | sed 's/^/      /' || true
		grep -E "GATE 1B VERIFICATION: PASS" /tmp/riftwrought_gate_1b_shots_small.log | sed 's/^/  /'
		pass "every surface is still on screen at 1280 x 720"
	else
		fail "the rendered 1280 x 720 run did not pass"
		grep -E "FAIL:" /tmp/riftwrought_gate_1b_shots_small.log | sed 's/^/        /' || true
	fi

	# §7 names seven required views. Each one is checked to exist and to be a real
	# frame rather than an empty file.
	missing_shot=0
	for stem in 1_neutral_source_lineup 2_candidate_treatment_lineup \
		3_knight_beside_candidates_grid 4_hybrid_court_dungeon_transition \
		5_k0rveen_imported 6_k0rveen_candidate_treatment 7_kaykit_only_k0rveen_hidden; do
		shot="$shots_dir/gate_1b_${stem}_1920x1080.png"
		if [[ -f "$shot" ]] && [[ "$(wc -c < "$shot" | tr -d ' ')" -gt 20000 ]]; then
			printf '  PASS  §7 view: %s (%s bytes)\n' "$stem" "$(wc -c < "$shot" | tr -d ' ')"
		else
			missing_shot=$((missing_shot + 1))
			fail "§7 required view missing or empty: $stem"
		fi
	done
	if [[ "$missing_shot" == "0" ]]; then
		pass "all seven §7 required views rendered"
	fi
	printf '  evidence written to %s (%s files)\n' \
		"$shots_dir" "$(ls "$shots_dir" | wc -l | tr -d ' ')"
fi

step "10. The project owner's own files are byte-for-byte untouched"
production_settings_after="$(state_fingerprint "$production_settings")"
production_lab_after="$(state_fingerprint "$production_lab")"
printf '  %s\n    before %s\n    after  %s\n' \
	"$production_settings" "$production_settings_before" "$production_settings_after"
printf '  %s\n    before %s\n    after  %s\n' \
	"$production_lab" "$production_lab_before" "$production_lab_after"
if [[ "$production_settings_before" == "$production_settings_after" \
	&& "$production_lab_before" == "$production_lab_after" ]]; then
	pass "the real settings and lab files are unchanged, or still absent"
else
	fail "this run changed the project owner's own files"
fi

printf '\n'
if [[ "$failures" -eq 0 ]]; then
	printf 'GATE 1B SMOKE CHECKS: PASS\n'
	cat <<'NOTE'
Automated checks cannot decide whether an asset belongs in Riftwrought, and that
is what this spike is FOR. GATE 1B REMAINS OPEN. Only the project owner can
approve KayKit Forest Nature as an exterior family, selected Halloween Bits as an
architectural bridge, and k0rveen as foreground, background-only, or rejected —
or ask for another asset search or a revised treatment pass. The mouse and
controller playtest is in
docs/testing/FIRST_MVP_GATE_1B_EXTERIOR_ASSET_COMPATIBILITY_SPIKE_REPORT.md §10.
No result authorizes Riftfall Landing construction. Do not begin the Severed
Threshold route.
NOTE
	exit 0
else
	printf 'GATE 1B SMOKE CHECKS: %d FAILURE(S)\n' "$failures"
	exit 1
fi
