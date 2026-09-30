#!/usr/bin/env bash
# Riftwrought — Roguelite I12: Repeated Live-Effect Level-Up Loop Review V1 smoke checks
# (decision D-316).
#
# THIS IS NOT A GATE, AND IT RUNS NO LOCKED CHAIN.
#
# I12 OWNS NO SCENE. It lets the accepted live-effect review (I3) inherit the accepted repeated and
# chained level-up loop (I11), and its one production edit hides I3's live receipt while any
# offer stands. Its verification is a SceneTree script that loads the accepted I3 scene exactly as
# it ships and drives seed 99's five choices through it. What this script proves:
#
#   1. the new verification and the one changed production script parse;
#   2. both accepted review scenes, the accepted suites that stand beside this work and every
#      accepted I2, I3, I10, I11 and H9 evidence frame are byte-identical to their accepted
#      hashes; nothing that runs names the harness; the verification names no file under tests/
#      but its own and no storage path or writer; and the review is the only file under scripts/,
#      scenes/, data/ or addons/ that hands a build to the application seam, exactly twice;
#   3. the pinned verification passes, proved in BOTH directions against a replay of its own
#      log, with every owed check reaching its last line, the measured lines read out of that
#      log, zero SCRIPT ERROR and zero engine ERROR, and no engine WARNING but the accepted core
#      loop's own two navigation-bake precision warnings — and a run that hangs is killed and
#      FAILS;
#   4. `project.godot` is untouched: 31 actions, the Prototype App entrypoint, the same nine
#      sections, no `[autoload]`;
#   5. the third-party inventory has not moved (185 + 2 = 187);
#   6. optionally (`--shots <dir>`), rendered evidence at 1920x1080 and at the 1280x720 minimum
#      tested window, each run passing at the SAME pinned count, because the evidence frames add
#      no assertion;
#   7. the whole of game/ outside .godot/, .godot/ itself, every protected file outside game/ and
#      the project owner's own user:// files are byte-identical across the run.
#
# Usage, from the repository root:
#   game/tests/roguelite_repeated_live_effect_loop_smoke.sh
#   game/tests/roguelite_repeated_live_effect_loop_smoke.sh --shots docs/testing/roguelite_repeated_live_effect_loop_evidence

set -uo pipefail

# Assigned at the TOP of the script, never beside the function it serves: a shell evaluates an
# assignment only when execution REACHES it.
RUN_STARTED_AT="$(date +%s)"

# A SCRIPT THAT DIES HALFWAY MUST NOT REPORT SUCCESS.
reached_end=0
scratch_replay=""
on_exit() {
	local code=$?
	[[ -n "$scratch_replay" ]] && rm -f "$scratch_replay"
	if [[ "$reached_end" != "1" ]]; then
		printf '\nROGUELITE REPEATED LIVE EFFECT LOOP SMOKE CHECKS: ABORTED before the end of the script\n'
		printf '  the run stopped early (exit %s) — nothing after that point was proved\n' "$code"
		exit 1
	fi
	exit "$code"
}
trap on_exit EXIT

GODOT="${GODOT:-/Applications/Godot.app/Contents/MacOS/Godot}"
EXPECTED_VERSION="4.7.2.stable"
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ROUTE_SEED=99

# Pinned, and proved in both directions below. ONE number: the rendered evidence frames add no
# assertion, so the headless and both rendered runs must agree.
EXPECTED_CHECKS=40
EXPECTED_OWED_CHECKS=20

# Seconds a verification may take before it is killed and counted as a failure.
VERIFICATION_TIMEOUT=600

EXPECTED_INPUT_ACTIONS=31
EXPECTED_MAIN_SCENE="res://scenes/app/prototype_app.tscn"
EXPECTED_SECTIONS="application audio debug display editor_plugins input layer_names navigation rendering"

# The review extracts nothing. D-216's authorized numbers, unmoved.
EXPECTED_THIRD_PARTY_PAYLOADS=185
EXPECTED_THIRD_PARTY=187

# The only engine warnings the verification may print: the accepted core loop's own navigation
# bake rounding its agent values to the voxel grid (accepted under D-290).
KNOWN_WARNINGS=(
	"WARNING: Property agent_max_climb is floored to cell_height voxel units and loses precision."
	"WARNING: Property agent_radius is ceiled to cell_size voxel units and loses precision."
)

THIS_VERIFICATION="tests/roguelite_repeated_live_effect_loop_verification.gd"
REVIEW="scripts/roguelite/live_effects/roguelite_live_effect_review.gd"

# The new verification, and the one production script Roguelite I12 changed.
PARSED_SCRIPTS=(
	"$THIS_VERIFICATION"
	"$REVIEW"
)

# Accepted files this work stands beside and must not regenerate or edit, each by the SHA-256
# prefix its acceptance recorded: both review scenes (D-295, D-293); I3's own suite and runner
# (D-297), I4's and I10's suites (D-299, D-313) and G4's suite with its nine-field test helper
# (D-269); and every accepted I2, I3, I10, I11 and H9 evidence frame (D-294, D-297, D-313, D-315,
# D-290).
ACCEPTED_PREFIXES=(
	"scenes/roguelite/roguelite_live_effect_review.tscn|0c3c6c98"
	"scenes/roguelite/roguelite_level_up_choice_review.tscn|7038bce6"
	# Roguelite I13 (D-318) moved I3's suite and runner and I4's suite one for one — `6fdcaafd`,
	# `74db357f` and `2aae92a4` — to their D-318 files. Same count.
	# Roguelite I14 (D-320) moved all three one for one again — `7c694b94`, `ab1470bc` and `145732c9` —
	# to their D-320 files: I3 proves Maximum Life live, and I4 allows the result its receipt numbers.
	# Roguelite I14's correction (D-321) moved I3's runner and I4's suite once more, for describe().
	# First-MVP UI J1 (D-322) moved I3's and I10's suites one for one — `80af7135` → `8ab346a6` and
	# `a12a485a` → `0ad96507` — reading the card a click reached instead of the panel's removed count.
	"tests/roguelite_live_effect_review_verification.gd|8ab346a6"
	"tests/roguelite_live_effect_review_smoke.sh|c6c94bd1"
	"tests/rift_rank_two_spatial_support_verification.gd|177868dc"
	"tests/passive_fallback_presentation_review_verification.gd|0ad96507"
	"tests/rift_run_level_coordinator_verification.gd|eaf80a6a"
	"../docs/testing/roguelite_level_up_choice_review_evidence/01_three_card_offer.png|5567fa79"
	"../docs/testing/roguelite_level_up_choice_review_evidence/02_support_receipt.png|d4ad49f6"
	"../docs/testing/roguelite_level_up_choice_review_evidence/03_passive_receipt.png|6168883e"
	"../docs/testing/roguelite_level_up_choice_review_evidence/1280x720/01_three_card_offer.png|32bce080"
	"../docs/testing/roguelite_level_up_choice_review_evidence/1280x720/02_support_receipt.png|912bbc23"
	"../docs/testing/roguelite_level_up_choice_review_evidence/1280x720/03_passive_receipt.png|5bcedc2b"
	"../docs/testing/roguelite_live_effect_review_evidence/01_sweeping_edge_live.png|73ccb8ec"
	"../docs/testing/roguelite_live_effect_review_evidence/02_celerity_live.png|c23cf8ed"
	"../docs/testing/roguelite_live_effect_review_evidence/03_fleetness_live.png|f844767c"
	"../docs/testing/roguelite_live_effect_review_evidence/1280x720/01_sweeping_edge_live.png|5b112d8c"
	"../docs/testing/roguelite_live_effect_review_evidence/1280x720/02_celerity_live.png|82d4bbe8"
	"../docs/testing/roguelite_live_effect_review_evidence/1280x720/03_fleetness_live.png|5207c56c"
	"../docs/testing/roguelite_passive_fallback_presentation_review_evidence/01_passive_fallback_offer.png|6695a969"
	"../docs/testing/roguelite_passive_fallback_presentation_review_evidence/02_passive_fallback_receipt.png|f72204e5"
	"../docs/testing/roguelite_passive_fallback_presentation_review_evidence/1280x720/01_passive_fallback_offer.png|f93a1d48"
	"../docs/testing/roguelite_passive_fallback_presentation_review_evidence/1280x720/02_passive_fallback_receipt.png|8b96f21e"
	"../docs/testing/roguelite_repeated_level_up_offer_loop_evidence/01_later_offer.png|51415ef1"
	"../docs/testing/roguelite_repeated_level_up_offer_loop_evidence/02_chained_offer.png|c1869df8"
	"../docs/testing/roguelite_repeated_level_up_offer_loop_evidence/03_fallback_offer.png|4439377e"
	"../docs/testing/roguelite_repeated_level_up_offer_loop_evidence/04_fallback_receipt.png|86d6b859"
	"../docs/testing/roguelite_repeated_level_up_offer_loop_evidence/1280x720/01_later_offer.png|60eb4cf8"
	"../docs/testing/roguelite_repeated_level_up_offer_loop_evidence/1280x720/02_chained_offer.png|4e002a84"
	"../docs/testing/roguelite_repeated_level_up_offer_loop_evidence/1280x720/03_fallback_offer.png|0d46693b"
	"../docs/testing/roguelite_repeated_level_up_offer_loop_evidence/1280x720/04_fallback_receipt.png|64077250"
	"../docs/testing/roguelite_experience_collection_review_evidence/01_uncollected_mote_pickup_off.png|39b83295"
	"../docs/testing/roguelite_experience_collection_review_evidence/02_level_up_ready.png|6281a25a"
	"../docs/testing/roguelite_experience_collection_review_evidence/03_fresh_second_run.png|cc6c6f7f"
	"../docs/testing/roguelite_experience_collection_review_evidence/1280x720/01_uncollected_mote_pickup_off.png|63909c92"
	"../docs/testing/roguelite_experience_collection_review_evidence/1280x720/02_level_up_ready.png|77ff0426"
	"../docs/testing/roguelite_experience_collection_review_evidence/1280x720/03_fresh_second_run.png|7134269a"
)

# Protected outside game/, where the whole-tree fingerprint below does not reach.
PRESERVED_FILES=(
	"../CLAUDE.md"
	"../README.md"
)
for row in "${ACCEPTED_PREFIXES[@]}"; do
	PRESERVED_FILES+=("${row%%|*}")
done

SHOT_DIR=""
if [[ "${1:-}" == "--shots" && -n "${2:-}" ]]; then
	mkdir -p "$2"
	SHOT_DIR="$(cd "$2" && pwd)"
fi

failures=0
step() { printf '\n=== %s\n' "$1"; }
pass() { printf '  PASS  %s\n' "$1"; }
fail() { printf '  FAIL  %s\n' "$1"; failures=$((failures + 1)); }

fingerprint() {
	if [[ -f "$1" ]]; then
		shasum -a 256 "$1" | awk '{print $1}'
	else
		echo "MISSING"
	fi
}

# Every file under game/ outside .godot/, and .godot/ on its own, each as one digest.
tree_fingerprint() {
	(cd "$PROJECT_DIR" && find . -path ./.godot -prune -o -type f -print0 | LC_ALL=C sort -z \
		| xargs -0 shasum -a 256) | shasum -a 256 | cut -d' ' -f1
}
cache_fingerprint() {
	(cd "$PROJECT_DIR" && find .godot -type f -print0 | LC_ALL=C sort -z | xargs -0 shasum -a 256) \
		| shasum -a 256 | cut -d' ' -f1
}

state_fingerprint() {
	if [[ -f "$1" ]]; then
		printf '%s bytes, sha256 %s, mtime %s' \
			"$(wc -c < "$1" | tr -d ' ')" \
			"$(shasum -a 256 "$1" | cut -d' ' -f1)" \
			"$(stat -f %m "$1")"
	else
		printf 'absent'
	fi
}

# D-201's lesson: a run that reports PASS while a script error scrolled past is not a pass.
assert_no_script_error() {
	local what="$1" logfile="$2" found
	found="$(grep -cE "SCRIPT ERROR|String formatting error|Parse Error" "$logfile" 2>/dev/null | tr -d ' ')"
	if [[ "$found" == "0" ]]; then
		pass "$what produced no SCRIPT ERROR"
	else
		fail "$what produced $found script error line(s)"
		grep -A3 -E "SCRIPT ERROR|String formatting error|Parse Error" "$logfile" | head -20 | sed 's/^/        /'
	fi
}

# Engine ERROR lines are refused outright, and every WARNING line must be one of the accepted
# bake's two known lines.
assert_engine_output() {
	local what="$1" logfile="$2" errors warnings unknown=0 line known
	errors="$(grep -cE "^ERROR:" "$logfile" 2>/dev/null | tr -d ' ')"
	if [[ "$errors" == "0" ]]; then
		pass "$what produced no engine ERROR line"
	else
		fail "$what produced $errors engine ERROR line(s)"
		grep -A2 -E "^ERROR:" "$logfile" | head -20 | sed 's/^/        /'
	fi
	warnings="$(grep -cE "^WARNING:" "$logfile" 2>/dev/null | tr -d ' ')"
	while IFS= read -r line; do
		known=0
		for expected in "${KNOWN_WARNINGS[@]}"; do
			[[ "$line" == "$expected" ]] && known=1
		done
		if [[ "$known" == "0" ]]; then
			fail "$what printed an unexpected warning: $line"
			unknown=$((unknown + 1))
		fi
	done < <(grep -E "^WARNING:" "$logfile" 2>/dev/null)
	if [[ "$unknown" == "0" ]]; then
		pass "$what printed $warnings engine WARNING line(s), each one of the accepted core loop's two navigation-bake precision warnings"
	fi
}

# `/tmp` is never cleared between runs, so a file from an earlier invocation must never answer
# for this one.
assert_log_is_fresh() {
	local logfile="$1" written
	if [[ ! -f "$logfile" ]]; then
		fail "$logfile was never written"
		return
	fi
	written="$(stat -f %m "$logfile" 2>/dev/null || echo 0)"
	if [[ "$written" -ge "$RUN_STARTED_AT" ]]; then
		pass "$(basename "$logfile") was written by THIS run"
	else
		fail "$(basename "$logfile") is older than this run — a stale log answered for it"
	fi
}

# The three-step read the project settled on.
read_check_count() {
	grep -ohE "$1: PASS \([0-9]+ checks\)" "$2" \
		| grep -ohE '[0-9]+ checks' | grep -ohE '[0-9]+' | head -1
}

run_verification() {
	local logfile="$1"
	shift
	perl -e 'alarm shift; exec @ARGV' "$VERIFICATION_TIMEOUT" "$GODOT" "$@" > "$logfile" 2>&1
}

printf 'Riftwrought — Roguelite I12: Repeated Live-Effect Level-Up Loop Review V1 smoke checks (D-316)\n'
printf 'project: %s\n' "$PROJECT_DIR"

# --------------------------------------------------------------------------
step "0. Engine, and a fingerprint of everything this review must not disturb"

installed="$("$GODOT" --version 2>/dev/null | tail -1)"
printf '  installed: %s\n' "$installed"
if [[ "$installed" == "$EXPECTED_VERSION"* ]]; then
	pass "matches the locked $EXPECTED_VERSION baseline"
else
	fail "expected $EXPECTED_VERSION, found $installed"
fi

tree_before="$(tree_fingerprint)"
cache_before="$(cache_fingerprint)"
tree_files="$(cd "$PROJECT_DIR" && find . -path ./.godot -prune -o -type f -print | wc -l | tr -d ' ')"
cache_files="$(cd "$PROJECT_DIR" && find .godot -type f | wc -l | tr -d ' ')"
pass "game/ fingerprinted whole: $tree_files file(s) outside .godot/, and $cache_files under .godot/"

declare -a BEFORE_HASHES
missing_preserved=0
for i in "${!PRESERVED_FILES[@]}"; do
	BEFORE_HASHES[$i]="$(fingerprint "$PROJECT_DIR/${PRESERVED_FILES[$i]}")"
	if [[ "${BEFORE_HASHES[$i]}" == "MISSING" ]]; then
		fail "protected file ${PRESERVED_FILES[$i]} does not exist"
		missing_preserved=$((missing_preserved + 1))
	fi
done
if [[ "$missing_preserved" == "0" ]]; then
	pass "${#PRESERVED_FILES[@]} protected file(s) outside game/ fingerprinted"
fi

project_name="$(sed -n 's/^config\/name="\(.*\)"[[:space:]]*$/\1/p' "$PROJECT_DIR/project.godot" | head -1)"
production_dir="$HOME/Library/Application Support/Godot/app_userdata/$project_name"
settings_before="$(state_fingerprint "$production_dir/prototype_settings.cfg")"
lab_before="$(state_fingerprint "$production_dir/prototype_zero.cfg")"
character_before="$(state_fingerprint "$production_dir/riftwrought_character.cfg")"
pass "the project owner's own three user:// files fingerprinted"

# --------------------------------------------------------------------------
step "1. The new verification and the one changed production script parse"

for relative in "${PARSED_SCRIPTS[@]}"; do
	if [[ ! -f "$PROJECT_DIR/$relative" ]]; then
		fail "$relative is missing"
		continue
	fi
	out="$("$GODOT" --headless --path "$PROJECT_DIR" --check-only --script "res://$relative" 2>&1 \
		| grep -v '^Godot Engine')"
	if [[ -z "$out" ]]; then
		pass "$relative parses"
	else
		fail "$relative does not parse"
		printf '%s\n' "$out" | head -10 | sed 's/^/        /'
	fi
done

# --------------------------------------------------------------------------
step "2. The accepted scenes, suites and frames are the accepted ones; nothing that runs names the harness; one caller hands the seam a build"

mismatched=0
for row in "${ACCEPTED_PREFIXES[@]}"; do
	relative="${row%%|*}"
	prefix="${row##*|}"
	digest="$(fingerprint "$PROJECT_DIR/$relative")"
	if [[ "$digest" != "$prefix"* ]]; then
		fail "$relative hashes ${digest:0:8}, not its accepted $prefix"
		mismatched=$((mismatched + 1))
	fi
done
if [[ "$mismatched" == "0" ]]; then
	pass "both review scenes, 5 accepted suites and all 30 accepted I2, I3, I10, I11 and H9 evidence frames match their accepted SHA-256 prefixes"
fi

if grep -rlE 'repeated_live_effect_loop' "$PROJECT_DIR/scripts" "$PROJECT_DIR/scenes" \
		"$PROJECT_DIR/data" "$PROJECT_DIR/addons" "$PROJECT_DIR/project.godot" 2>/dev/null | grep -q .; then
	fail "a running file or project.godot names the I12 harness"
else
	pass "no file under scripts/, scenes/, data/ or addons/, and nothing in project.godot, names the I12 harness"
fi

others="$(grep -oE 'res://tests/[A-Za-z0-9_./-]+' "$PROJECT_DIR/$THIS_VERIFICATION" | sort -u \
	| grep -vxF "res://$THIS_VERIFICATION" | tr '\n' ' ')"
if [[ -z "${others// /}" ]] && grep -q '^extends SceneTree$' "$PROJECT_DIR/$THIS_VERIFICATION"; then
	pass "the verification is a SceneTree script and names no file under tests/ but its own"
else
	fail "the verification names another test file: ${others:-none}, or is not a SceneTree script"
fi

if grep -qE 'user://|ConfigFile|ResourceSaver|DirAccess|store_string' "$PROJECT_DIR/$THIS_VERIFICATION"; then
	fail "the verification names a storage path or writer"
else
	pass "the verification names no storage path or writer (its only file write is an evidence frame under --shots)"
fi

# THE ONE APPLICATION SEAM HAS ONE CALLER, measured from outside the engine over every running
# directory: the review, which hands it a build exactly twice — after a successful choice, and an
# empty build to restore every baseline.
callers="$(grep -rlF 'RiftBuildApplication.apply(' "$PROJECT_DIR/scripts" "$PROJECT_DIR/scenes" \
	"$PROJECT_DIR/data" "$PROJECT_DIR/addons" 2>/dev/null | sed "s|^$PROJECT_DIR/||" | tr '\n' ' ' | sed 's/ $//')"
calls="$(grep -oF 'RiftBuildApplication.apply(' "$PROJECT_DIR/$REVIEW" | wc -l | tr -d ' ')"
if [[ "$callers" == "$REVIEW" && "$calls" == "2" ]]; then
	pass "the only running caller of RiftBuildApplication.apply( is $REVIEW, exactly twice"
else
	fail "RiftBuildApplication.apply( is called by '${callers:-nothing}' ($calls time(s) in the review)"
fi

# --------------------------------------------------------------------------
step "3. The pinned verification passes, proved in BOTH directions"

verify_log="/tmp/riftwrought_repeated_live_effect_loop_verify.log"
run_verification "$verify_log" --headless --path "$PROJECT_DIR" --script "res://$THIS_VERIFICATION" -- --seed "$ROUTE_SEED"
verify_status=$?
printf '  verification exit status: %s\n' "$verify_status"
assert_log_is_fresh "$verify_log"
assert_no_script_error "the headless verification" "$verify_log"
assert_engine_output "the headless verification" "$verify_log"

if [[ "$verify_status" == "0" ]]; then
	pass "the verification exited 0"
elif [[ "$verify_status" == "142" ]]; then
	fail "the verification did not finish within $VERIFICATION_TIMEOUT s and was killed"
else
	fail "the verification exited $verify_status"
	grep -E "^  FAIL" "$verify_log" | head -20 | sed 's/^/        /'
fi

count="$(read_check_count "ROGUELITE REPEATED LIVE EFFECT LOOP VERIFICATION" "$verify_log")"
if [[ "$count" == "$EXPECTED_CHECKS" ]]; then
	pass "verification passes at the pinned $EXPECTED_CHECKS checks"
else
	fail "verification reports ${count:-no} checks, not $EXPECTED_CHECKS"
fi

# A guard that accepts everything protects nothing: the pin must refuse a log whose count moved
# by one, and the negative direction must READ the moved number.
replay="$(mktemp -t riftwrought_repeated_live_effect_loop_replay)"
scratch_replay="$replay"
sed "s/ROGUELITE REPEATED LIVE EFFECT LOOP VERIFICATION: PASS ($EXPECTED_CHECKS checks)/ROGUELITE REPEATED LIVE EFFECT LOOP VERIFICATION: PASS ($((EXPECTED_CHECKS + 1)) checks)/" \
	"$verify_log" > "$replay"
replay_count="$(read_check_count "ROGUELITE REPEATED LIVE EFFECT LOOP VERIFICATION" "$replay")"
if [[ -z "$count" ]]; then
	fail "the verification printed no count line, so the count pin proves nothing this run"
elif [[ "$replay_count" == "$((EXPECTED_CHECKS + 1))" && "$replay_count" != "$EXPECTED_CHECKS" ]]; then
	pass "and that pin reads a log whose count moved by one as $replay_count, refusing it"
else
	fail "the count pin read '${replay_count:-nothing}' from a moved log and therefore proves nothing"
fi

if grep -qE "^  $EXPECTED_OWED_CHECKS of $EXPECTED_OWED_CHECKS owed checks completed" "$verify_log"; then
	pass "all $EXPECTED_OWED_CHECKS owed checks reached their last line"
else
	fail "the owed-set report is missing or short"
	grep -E "owed checks" "$verify_log" | sed 's/^/        /'
fi
for moved in "$((EXPECTED_OWED_CHECKS - 1)) of $EXPECTED_OWED_CHECKS" "$EXPECTED_OWED_CHECKS of $((EXPECTED_OWED_CHECKS + 1))"; do
	if grep -qE "^  $moved owed checks completed" "$verify_log"; then
		fail "the owed-set line reads '$moved'"
	fi
done

# The measurements this review exists to make, read out of the run's own log rather than restated
# here. `--` before the pattern is D-244's lesson kept. No line carrying a frame number, a
# distance walked or a count of drawn lines — each of which varies with the window and the clock —
# is listed.
while IFS= read -r line; do
	if grep -qF -- "$line" "$verify_log"; then
		pass "measured: ${line}"
	else
		fail "the verification log does not report: ${line}"
	fi
done <<'MEASURED'
the accepted scene roguelite_live_effect_review.tscn runs roguelite_live_effect_review.gd over roguelite_level_up_choice_review.gd; no accepted suite started; 31 actions; the entrypoint is prototype_app.tscn; project.godot declares no [autoload]; 0 of 18 injection patterns in this harness's code
the review declares 9 fields, 6 constants and 10 functions — the accepted ones, no field for a chained offer, a queue, a build, a lane, an identity or a seed, and no new public method
5 overrides (_build_run_surfaces, _discard_mote_runtime, _maybe_start_verification, _refresh_receipt, choose_offered_lane); _refresh_receipt hides the live line while the level-up panel is open; the build is applied through RiftBuildApplication twice — after a choice from mote_runtime.run_build(), and to restore from an empty build
of the 6 files the running review is made of, none writes reach, arc, cone or Skill Speed, and only the core loop's spawn sets the accepted movement baseline; the seam writes them; 0 of 25 concrete tokens and no decimal value in the review or its scene
36 accepted files match the SHA-256 prefixes they held before the first I12 edit, but for the four I13 moved (D-318), three of them moved again by I14 (D-320), the panel and the modal contract J1 moved (D-322), and the player J2 moved once more (D-324); the one edited file, roguelite_live_effect_review.gd, is at its D-320 hash 75cb02b9
reaching_edge: rank 1 { &"reach": 2.65 }, rank 2 { &"reach": 3.65 }; sweeping_edge: rank 1 { &"release_arc_degrees": 180.0, &"soft_target_cone_degrees": 110.0 }, rank 2 { &"release_arc_degrees": 260.0, &"soft_target_cone_degrees": 155.0 }; nothing at rank 3; maximum rank 2 for both
the seam makes [global_damage, skill_speed, maximum_life, movement_speed] live, leaves [experience_gain, pickup_radius] to the run's own mote path and holds [] without applying them
the route's real motes: experience 25 -> 50 -> 75 through the review's own sweep, 0 openings asked; one fixture mote of 25 by one explicit H8 sweep
100 = G1's Level 1 requirement; the review asked 1 opening on its own tick, the panel opened and the probe was paused once; root seed 99 = G2's; root 99 lanes [0, 1, 2] [quick_strike, sweeping_edge] [card_celerity] [card_fleetness] kind 0 category -1
the panel states I3's note: Covered effects are applied immediately for this expedition. Final values and presentation are not locked.
lane 7: 'lane 7 is not one of the offer's lanes (Support 2752175283, Combat and Defence 416632034, Utility 444303818)' — shown word for word; the same Level 4 offer, still open and paused; 0 applications, 0 application refusals, every live value unchanged; receipt and live line hidden
movement 5.0 m/s, action time 0.80 s, reach 3.65 m, arc 260°, cone 155°, 1 target; reaching_edge 2 / 2 and sweeping_edge 2 / 2; 4 applications, 0 refusals; paused
the fallback offer standing: 15 of 15 visible text controls on screen, smallest 12 px; 3 cards, 0 overlapping; the panel centred within 1 px; behind it no receipt and no live line
the escort — alive, AI on, pursuing — and the player, the sweep, the motes, the attack and the probe: identical across both chained offers, the refused lane and 80 held frames (5 readings)
the fallback choice sent the probe exactly 1 unpause notice; 8 frames later the escort had moved, the sweep had run and the probe had ticked; after Levels 1 and 2 the same
Support — Power, passive fallback from category 0, root 4000111: carried by exactly 1 of the 5 records; taking the lane again answered 'no offer is open; one must be opened before a lane may be taken'
card_power 0 -> 1; reaching_edge 2 -> 2, sweeping_edge 2 -> 2, total ranks 4 -> 4; Global Damage +10% held in the build and live through the seam; weapon damage 100 raw
5 successful applications; the panel closed and play resumed; Rift level 6 with 0 XP against G1's 225
| Support — Power (+10% Global Damage)
| Passive fallback from Combat and Defence
| Rift level 5 → 6 · 0 XP carried over
| Live now — reach 1.65 m → 3.65 m · arc 100° → 260° · cone 65° → 155° · one target / damage 100 → 110
| Applied to the character now; every value returns to its baseline when this expedition ends.
"Live now —" appears once and heads the seam's two applied lines; Power's damage reads 'damage 100 → 110' — no card named, no held heading
the final receipt: 6 lines on screen inside the review panel, 0 overlapping, clear of the centre, smallest 12 px; not paused
3.20 m ahead: the live record's release query hit; the canonical record's miss — '3.20 m is beyond the 1.65 m reach'
the real press began in its wind-up toward it without stepping and hit once — Life 600 -> 490
the kernel times a 0.800 s action at +0% Skill Speed; at 60 Hz the release fired on tick 16, the first at or after 0.80 s x 0.325, with the pose at 0.3250, and READY returned on tick 49 (0.8167 s), inside the one-tick window after 0.80 s that I3's accepted suite reads
110° at 1.20 m: the live record's release query hit; the canonical record's miss — '110 deg is outside the 100 deg release arc'
the real press swung along the facing — 'no eligible target in the 155 deg cone' — and its one release selected it and hit: Life 490 -> 380
the canonical record's query refused both; the live record's real release found 2 legal targets, made 1 damage event on the nearer — 380 -> 270 — and left the other at 300; maximum targets 1
a real stick held fully right for 45 ticks: top speed and every 12-tick plateau within 0.01 m/s of 5.0 m/s, straight along the camera's right
the three real hits each took C1's answer for the weapon's raw 100 at +10% — 110, 110 and 110 — live through the seam
movement 5.0 m/s, action time 0.80 s, reach 3.65 m, arc 260°, cone 155°, 1 target(s) -> movement 5.0 m/s, action time 0.80 s, reach 1.65 m, arc 100°, cone 65°, 1 target(s)
restored by the seam from an empty build (quick_strike; skill speed +0% -> 0.800000000 s; movement +0% -> 5.000 m/s; global damage +0% -> 100.000 from 100.000; maximum life +0% -> 500.000 from 500.000; life 500.000/500.000 -> 500.000/500.000; reach 1.65 m, arc 100 deg, cone 65 deg, 1 target(s); supports []; run path []; deferred []; committed); no application, live line or receipt left
B began at Rift level 1, XP 0 / 100, run seed 99: an empty build (0 pairs, card_power 0, Global Damage 0), no offer, no receipt, no live line, no application result; movement 5.0 m/s, action time 0.80 s, reach 1.65 m, arc 100°, cone 65°, 1 target(s)
Level 1, opened on its own: 'Rift level 1' / 'XP 100 / 100' behind the three cards Sweeping Edge / Celerity / Fleetness; the receipt shows only 'Level-up offer open — choose one of the three cards.'; no live line, no stale receipt text; the level-up panel the only open modal
Level 2, opened on its own: 'Rift level 2' / 'XP 125 / 125' behind the three cards Reaching Edge / Power / Magnetism; the receipt shows only 'Level-up offer open — choose one of the three cards.'; no live line, no stale receipt text; the level-up panel the only open modal
Level 3, opened on its own with 525 banked: 'Rift level 3' / 'XP 525 / 150' behind the three cards Reaching Edge / Vitality / Fleetness; the receipt shows only 'Level-up offer open — choose one of the three cards.'; no live line, no stale receipt text; the level-up panel the only open modal
Level 4, in place of Level 3's in the same call: 'Rift level 4' / 'XP 375 / 175' behind the three cards Sweeping Edge / Power / Magnetism; the receipt shows only 'Level-up offer open — choose one of the three cards.'; no live line, no stale receipt text; the level-up panel the only open modal
Level 4, after a refused lane: 'Rift level 4' / 'XP 375 / 175' behind the three cards Sweeping Edge / Power / Magnetism; the receipt shows only 'Level-up offer open — choose one of the three cards.'; no live line, no stale receipt text; the level-up panel the only open modal
Level 4, after 30 physics and 10 idle frames held: 'Rift level 4' / 'XP 375 / 175' behind the three cards Sweeping Edge / Power / Magnetism; the receipt shows only 'Level-up offer open — choose one of the three cards.'; no live line, no stale receipt text; the level-up panel the only open modal
Level 5, in place of Level 4's in the same call: 'Rift level 5' / 'XP 200 / 200' behind the three cards Power / Vitality / Fleetness; the receipt shows only 'Level-up offer open — choose one of the three cards.'; no live line, no stale receipt text; the level-up panel the only open modal
Level 5 fallback, after 30 physics and 10 idle frames held: 'Rift level 5' / 'XP 200 / 200' behind the three cards Power / Vitality / Fleetness; the receipt shows only 'Level-up offer open — choose one of the three cards.'; no live line, no stale receipt text; the level-up panel the only open modal
7 of 8 standing moments held both a completed receipt and a live line — hidden, not cleared
each application equals the seam's own derivation of a fresh copy of the run's whole build, and none was refused
Support — Quick Strike → Sweeping Edge: reach 1.65 m, arc 180°, cone 110°, 1 target, 5.0 m/s, 0.80 s; a new compatible pair, rank 0 -> 1; 'Live now — arc 100° → 180° · cone 65° → 110° · one target'
Support — Quick Strike → Reaching Edge: reach 2.65 m, arc 180°, cone 110°, 1 target, 5.0 m/s, 0.80 s; a new compatible pair, rank 0 -> 1; 'Live now — reach 1.65 m → 2.65 m · arc 100° → 180° · cone 65° → 110° · one target'
Support — Quick Strike → Reaching Edge: reach 3.65 m, arc 180°, cone 110°, 1 target, 5.0 m/s, 0.80 s; another rank of a held pair, rank 1 -> 2; 'Live now — reach 1.65 m → 3.65 m · arc 100° → 180° · cone 65° → 110° · one target'
Support — Quick Strike → Sweeping Edge: reach 3.65 m, arc 260°, cone 155°, 1 target, 5.0 m/s, 0.80 s; another rank of a held pair, rank 1 -> 2; 'Live now — reach 1.65 m → 3.65 m · arc 100° → 260° · cone 65° → 155° · one target'
Support — Power (+10% Global Damage): reach 3.65 m, arc 260°, cone 155°, 1 target, 5.0 m/s, 0.80 s; Passive fallback from Combat and Defence; 'Live now — reach 1.65 m → 3.65 m · arc 100° → 260° · cone 65° → 155° · one target / damage 100 → 110'
Level 3 -> 4: the panel stayed open (opens 3, closes 2, replacements 0 -> 1); 0 probe ticks and 0 unpause notices; Level 4's offer from root 3000108, card 1 focused; reach 3.65 m, arc 180°, cone 110° already live; receipt and live line hidden
Level 4 -> 5: the panel stayed open (opens 3, closes 2, replacements 1 -> 2); 0 probe ticks and 0 unpause notices; Level 5's offer from root 4000111, card 1 focused; reach 3.65 m, arc 260°, cone 155° already live; receipt and live line hidden
the fallback offer reads, word for word as I10 accepted it: Support: Power — Supports maxed — +10% Global Damage; Combat and Defence: Vitality — +15% Maximum Life; Utility: Fleetness — +10% Movement Speed
2 expeditions (1 given seed 99 again by staging), 5 fixture Graveblades registered and killed, 3 real Quick Strike presses, 5 offer openings asked by the review, 5 level-ups taken, 2 offers shown in place of a chosen one, 5 applications and 4 restorations made by the review
MEASURED

# --------------------------------------------------------------------------
step "4. project.godot is untouched"

project_godot="$PROJECT_DIR/project.godot"
actions="$(sed -n '/^\[input\]/,/^\[layer_names\]/p' "$project_godot" | grep -cE '^[a-zA-Z_0-9]+=')"
if [[ "$actions" == "$EXPECTED_INPUT_ACTIONS" ]]; then
	pass "the InputMap still declares exactly $EXPECTED_INPUT_ACTIONS actions"
else
	fail "the InputMap declares $actions actions, not $EXPECTED_INPUT_ACTIONS"
fi
main_scene="$(grep -oE 'run/main_scene="[^"]+"' "$project_godot" | head -1 | sed -E 's/run\/main_scene="([^"]+)"/\1/')"
if [[ "$main_scene" == "$EXPECTED_MAIN_SCENE" ]]; then
	pass "the entrypoint is still $EXPECTED_MAIN_SCENE"
else
	fail "the entrypoint is '$main_scene', not $EXPECTED_MAIN_SCENE"
fi
sections="$(grep -oE '^\[[a-z_]+\]$' "$project_godot" | tr -d '[]' | sort | tr '\n' ' ' | sed 's/ $//')"
if [[ "$sections" == "$EXPECTED_SECTIONS" ]]; then
	pass "the same nine sections, no new one"
else
	fail "project.godot's sections are '$sections'"
fi
if grep -q '^\[autoload\]' "$project_godot"; then
	fail "an [autoload] section was added"
else
	pass "there is still no [autoload]"
fi

# --------------------------------------------------------------------------
step "5. The third-party inventory has not moved — the review extracts nothing"

payloads="$(find "$PROJECT_DIR/assets/third_party" -type f \
	! -name '*.import' ! -name '.DS_Store' ! -name '*.md' 2>/dev/null | wc -l | tr -d ' ')"
maps=0
for note in "$PROJECT_DIR/assets/third_party/kenney/SOURCE_AND_LICENSE.md" \
		"$PROJECT_DIR/assets/third_party/quaternius/SOURCE_AND_LICENSE.md"; do
	[[ -f "$note" ]] && maps=$((maps + 1))
done
total=$((payloads + maps))
printf '  arithmetic: %d payload(s) + %d source map(s) = %d\n' "$payloads" "$maps" "$total"
if [[ "$payloads" == "$EXPECTED_THIRD_PARTY_PAYLOADS" && "$total" == "$EXPECTED_THIRD_PARTY" ]]; then
	pass "still $EXPECTED_THIRD_PARTY_PAYLOADS + $maps = $EXPECTED_THIRD_PARTY, unchanged"
else
	fail "the third-party inventory is $payloads + $maps = $total, not $EXPECTED_THIRD_PARTY_PAYLOADS + 2 = $EXPECTED_THIRD_PARTY"
fi

# --------------------------------------------------------------------------
step "6. Rendered evidence"

if [[ -n "$SHOT_DIR" ]]; then
	for resolution in 1920x1080 1280x720; do
		target="$SHOT_DIR"
		[[ "$resolution" == "1280x720" ]] && target="$SHOT_DIR/1280x720"
		mkdir -p "$target"
		shots_log="/tmp/riftwrought_repeated_live_effect_loop_shots_$resolution.log"
		run_verification "$shots_log" --path "$PROJECT_DIR" --resolution "$resolution" \
			--script "res://$THIS_VERIFICATION" -- --seed "$ROUTE_SEED" --shots "$target"
		shots_status=$?
		printf '  %s verification exit status: %s\n' "$resolution" "$shots_status"
		assert_log_is_fresh "$shots_log"
		assert_no_script_error "the $resolution rendered run" "$shots_log"
		assert_engine_output "the $resolution rendered run" "$shots_log"
		rendered_count="$(read_check_count "ROGUELITE REPEATED LIVE EFFECT LOOP VERIFICATION" "$shots_log")"
		if [[ "$shots_status" == "0" && "$rendered_count" == "$EXPECTED_CHECKS" ]]; then
			pass "the $resolution rendered run exits 0 at the same pinned $EXPECTED_CHECKS checks"
		else
			fail "the $resolution rendered run exits $shots_status at ${rendered_count:-no} checks, not $EXPECTED_CHECKS"
			grep -E "^  FAIL" "$shots_log" | head -10 | sed 's/^/        /'
		fi
		measured_here=0
		for panel_line in "the fallback offer standing: 15 of 15 visible text controls on screen" \
				"the final receipt: 6 lines on screen inside the review panel, 0 overlapping, clear of the centre"; do
			grep -qF -- "$panel_line" "$shots_log" && measured_here=$((measured_here + 1))
		done
		if [[ "$measured_here" == "2" ]]; then
			pass "at $resolution the standing fallback offer and the final receipt are on screen, apart and unobstructed"
		else
			fail "at $resolution only $measured_here of 2 on-screen measurements were reported"
		fi
		drawn="$(grep -oE "the live line's three logical lines are drawn as [0-9]+ lines" "$shots_log" | head -1)"
		printf '  at %s %s\n' "$resolution" "${drawn:-(no drawn-line count reported)}"
		shots=0
		for stem in 01_fallback_offer_after_rank_two 02_level_six_live_and_held_receipt; do
			frame="$target/$stem.png"
			if [[ -f "$frame" && "$(stat -f %m "$frame")" -ge "$RUN_STARTED_AT" && "$(wc -c < "$frame" | tr -d ' ')" -gt 20000 ]]; then
				shots=$((shots + 1))
			else
				fail "$stem.png was not freshly captured at $resolution"
			fi
		done
		if [[ "$shots" == "2" ]]; then
			pass "both evidence frames freshly captured into $target"
		fi
	done
else
	printf '  skipped (pass --shots <dir> to render evidence)\n'
fi

# --------------------------------------------------------------------------
step "7. Nothing under game/ moved, every protected file is byte-identical, and the owner's files are untouched"

tree_after="$(tree_fingerprint)"
cache_after="$(cache_fingerprint)"
if [[ "$tree_after" == "$tree_before" ]]; then
	pass "game/ outside .godot/ is byte-identical across the run: $tree_files file(s), the run wrote nothing there"
else
	fail "a file under game/ outside .godot/ changed during this run"
fi
if [[ "$cache_after" == "$cache_before" ]]; then
	pass ".godot/ is byte-identical across the run: $cache_files file(s)"
else
	fail ".godot/ changed during this run"
fi

changed=0
for i in "${!PRESERVED_FILES[@]}"; do
	after="$(fingerprint "$PROJECT_DIR/${PRESERVED_FILES[$i]}")"
	if [[ "$after" != "${BEFORE_HASHES[$i]}" ]]; then
		fail "${PRESERVED_FILES[$i]} CHANGED during this run"
		changed=$((changed + 1))
	fi
done
if [[ "$changed" == "0" && "$missing_preserved" == "0" ]]; then
	pass "all ${#PRESERVED_FILES[@]} protected files outside game/ are byte-identical"
fi

settings_after="$(state_fingerprint "$production_dir/prototype_settings.cfg")"
lab_after="$(state_fingerprint "$production_dir/prototype_zero.cfg")"
character_after="$(state_fingerprint "$production_dir/riftwrought_character.cfg")"
if [[ "$settings_after" == "$settings_before" && "$lab_after" == "$lab_before" \
		&& "$character_after" == "$character_before" ]]; then
	pass "the project owner's own prototype_settings.cfg, prototype_zero.cfg and riftwrought_character.cfg are unchanged"
else
	fail "a file in the project owner's own user:// directory changed during this run"
fi

# --------------------------------------------------------------------------
printf '\n'
if [[ "$failures" == "0" ]]; then
	printf 'ROGUELITE REPEATED LIVE EFFECT LOOP SMOKE CHECKS: PASS\n'
	printf '  %s checks; %s of %s owed; game/ and %s protected files byte-identical\n' \
		"$EXPECTED_CHECKS" "$EXPECTED_OWED_CHECKS" "$EXPECTED_OWED_CHECKS" "${#PRESERVED_FILES[@]}"
	printf '  Roguelite I12 — Repeated Live-Effect Level-Up Loop Review V1 is DELIVERED under D-316\n'
	printf '  and ACCEPTED and CLOSED at the repeated playable live-effect level-up-loop review level\n'
	printf '  under D-317.\n'
	reached_end=1
	exit 0
else
	printf 'ROGUELITE REPEATED LIVE EFFECT LOOP SMOKE CHECKS: %d FAILURE(S)\n' "$failures"
	reached_end=1
	exit 1
fi
