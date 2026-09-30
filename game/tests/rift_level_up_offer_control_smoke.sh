#!/usr/bin/env bash
# Riftwrought — Roguelite Foundation I1 smoke checks: run-owned level-up offer
# control on the accepted H8 Experience-Mote runtime (decision D-291).
#
# THIS IS NOT A GATE, AND IT DELIBERATELY RUNS NO LOCKED CHAIN.
#
# Foundation I1 adds six one-line delegations to `scripts/experience/rift_mote_runtime.gd`
# — open the current level's offer, read its root seed, lanes, per-lane identity and
# frozen requirement, and take one lane — each handing its question to the run's own
# accepted G4 operation and returning the run's answer unchanged. No new production
# file, no fourth field, no scene, no resource, no asset, no InputMap action, no
# entrypoint change, nothing written to disk, and NOTHING THAT RUNS CALLS THEM.
#
# The accepted suites it moved are run once by their own runners — H8 (its method
# pins, one for one), G4 (its reader row for the runtime gained the run-level record),
# and the three whole-project class scans whose reader tables gained the runtime by
# file and class (Skill profile, support definition, card record) — plus H9, because it
# must stay visibly and mechanically unchanged. None of them is rerun from here.
#
# What this script proves:
#
#   1. the extended runtime and this verification parse;
#   2. the pinned verification passes, proved in BOTH directions against a replay of
#      its own log, with every owed check reaching its last line and the measurements
#      it exists to make read out of that log — and a run that hangs is killed and
#      FAILS rather than waiting forever;
#   3. from outside the engine: the runtime still declares exactly its three bare
#      fields; each of the six new operations is one line handing its question to the
#      run; none of the six is named by any other file under `scripts/`, `scenes/`,
#      `data/` or `addons/`, or by `project.godot`; the runtime names no catalogue and
#      no concrete Skill, support or card id; and the verification names no file under
#      `tests/` but its own;
#   4. the files this work could conceivably have disturbed — the accepted G4, E2, G1,
#      G2, D1, D2, D3 and H1–H7 mechanisms, both catalogues, the Graveblade, the H9
#      review and its HUD, scene and six accepted evidence frames, the core loop,
#      `project.godot`, the project owner's composed zone and loading teaser, and
#      `CLAUDE.md` — are BYTE-IDENTICAL ACROSS THE RUN.
#
# Usage, from the repository root:
#   game/tests/rift_level_up_offer_control_smoke.sh

set -uo pipefail

# Assigned at the TOP of the script: a shell evaluates an assignment only when
# execution REACHES it (Gate 1E's lesson).
RUN_STARTED_AT="$(date +%s)"

reached_end=0
scratch_replay=""
on_exit() {
	local code=$?
	[[ -n "$scratch_replay" ]] && rm -f "$scratch_replay"
	if [[ "$reached_end" != "1" ]]; then
		printf '\nRIFT LEVEL-UP OFFER CONTROL SMOKE CHECKS: ABORTED before the end of the script\n'
		printf '  the run stopped early (exit %s) — nothing after that point was proved\n' "$code"
		exit 1
	fi
	exit "$code"
}
trap on_exit EXIT

GODOT="${GODOT:-/Applications/Godot.app/Contents/MacOS/Godot}"
EXPECTED_VERSION="4.7.2.stable"
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

VERIFICATION="res://tests/rift_level_up_offer_control_verification.gd"

# Pinned, and proved in both directions below.
EXPECTED_CHECKS=302

EXPECTED_OWED_CHECKS=15

VERIFICATION_TIMEOUT=300

RUNTIME="scripts/experience/rift_mote_runtime.gd"
THIS_VERIFICATION="tests/rift_level_up_offer_control_verification.gd"

PARSED_SCRIPTS=(
	"$RUNTIME"
	"$THIS_VERIFICATION"
)

PRESERVED_FILES=(
	"project.godot"
	"scenes/first_mvp/zone_composer_practice.tscn"
	"assets/prototype/ui/loading/riftwrought-loading-teaser-v1.png"
	"assets/prototype/ui/loading/riftwrought-loading-teaser-v1.png.import"
	"scripts/levels/rift_run_level_coordinator.gd"
	"scripts/levels/rift_run_level_up_result.gd"
	"scripts/levels/rift_level_up_coordinator.gd"
	"scripts/levels/rift_level_up_result.gd"
	"scripts/level_requirements/rift_level_requirement_curve.gd"
	"scripts/level_seeds/rift_level_offer_seed_derivation.gd"
	"scripts/offers/rift_offer.gd"
	"scripts/offers/rift_offer_composition.gd"
	"scripts/runs/rift_run_build.gd"
	"scripts/choices/rift_offer_choice.gd"
	"scripts/choices/rift_consumption_ledger.gd"
	"scripts/skills/skill_support_catalogue.gd"
	"scripts/stats/passive_card_catalogue.gd"
	"scripts/experience/rift_graveblade_mote_binding.gd"
	"scripts/experience/rift_enemy_mote_emission.gd"
	"scripts/experience/rift_experience_mote.gd"
	"scripts/experience/rift_experience_track.gd"
	"scripts/pickups/rift_mote_field.gd"
	"scripts/pickups/rift_mote_sweep_result.gd"
	"scripts/pickups/rift_mote_drop.gd"
	"scripts/pickups/rift_mote_collection_attempt.gd"
	"scripts/actors/prototype_graveblade.gd"
	"scenes/actors/prototype_graveblade.tscn"
	"data/prototype_zero/graveblade.tres"
	"scripts/roguelite/experience/roguelite_experience_collection_review.gd"
	"scripts/roguelite/experience/roguelite_experience_review_hud.gd"
	"scenes/roguelite/roguelite_experience_collection_review.tscn"
	"scripts/roguelite/roguelite_core_loop_runtime.gd"
	"scenes/roguelite/roguelite_core_loop.tscn"
	"../docs/testing/roguelite_experience_collection_review_evidence/01_uncollected_mote_pickup_off.png"
	"../docs/testing/roguelite_experience_collection_review_evidence/02_level_up_ready.png"
	"../docs/testing/roguelite_experience_collection_review_evidence/03_fresh_second_run.png"
	"../docs/testing/roguelite_experience_collection_review_evidence/1280x720/01_uncollected_mote_pickup_off.png"
	"../docs/testing/roguelite_experience_collection_review_evidence/1280x720/02_level_up_ready.png"
	"../docs/testing/roguelite_experience_collection_review_evidence/1280x720/03_fresh_second_run.png"
	"../CLAUDE.md"
)

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

assert_no_script_error() {
	local what="$1" logfile="$2" found
	found="$(grep -cE "SCRIPT ERROR|String formatting error" "$logfile" 2>/dev/null | tr -d ' ')"
	if [[ "$found" == "0" ]]; then
		pass "$what produced no SCRIPT ERROR"
	else
		fail "$what produced $found engine error line(s)"
		grep -A3 -E "SCRIPT ERROR|String formatting error" "$logfile" | head -20 | sed 's/^/        /'
	fi
}

assert_no_engine_error() {
	local what="$1" logfile="$2" found
	found="$(grep -cE "^ERROR:|^WARNING:" "$logfile" 2>/dev/null | tr -d ' ')"
	if [[ "$found" == "0" ]]; then
		pass "$what produced no engine ERROR or WARNING line"
	else
		fail "$what produced $found engine ERROR or WARNING line(s)"
		grep -A2 -E "^ERROR:|^WARNING:" "$logfile" | head -20 | sed 's/^/        /'
	fi
}

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

read_check_count() {
	grep -ohE "$1: PASS \([0-9]+ checks\)" "$2" \
		| grep -ohE '[0-9]+ checks' | grep -ohE '[0-9]+' | head -1
}

bare_code() {
	grep -vE '^[[:space:]]*#' "$1" | sed -E 's/"([^"\\]|\\.)*"/""/g'
}

printf 'Riftwrought — Roguelite Foundation I1: run-owned level-up offer control (D-291)\n'
printf 'project: %s\n' "$PROJECT_DIR"

# --------------------------------------------------------------------------
step "0. Godot version"
version="$("$GODOT" --version 2>/dev/null | tail -1)"
printf '  installed: %s\n' "$version"
if [[ "$version" == "$EXPECTED_VERSION"* ]]; then
	pass "matches the locked $EXPECTED_VERSION baseline"
else
	fail "expected $EXPECTED_VERSION (locked by D-167)"
fi

declare -a before_prints=()
for file in "${PRESERVED_FILES[@]}"; do
	before_prints+=("$(fingerprint "$PROJECT_DIR/$file")")
done

# --------------------------------------------------------------------------
step "1. The extended runtime and this verification parse"
for script in "${PARSED_SCRIPTS[@]}"; do
	if [[ ! -f "$PROJECT_DIR/$script" ]]; then
		fail "$script is missing"
		continue
	fi
	out="$("$GODOT" --headless --path "$PROJECT_DIR" --check-only --script "res://$script" 2>&1 \
		| grep -v '^Godot Engine')"
	if [[ -z "$out" ]]; then
		pass "$script"
	else
		fail "$script does not parse"
		printf '%s\n' "$out" | head -10 | sed 's/^/        /'
	fi
done

# --------------------------------------------------------------------------
step "2. The pinned verification passes, proved in BOTH directions"
verify_log="/tmp/riftwrought_rift_level_up_offer_control_verify.log"
perl -e 'alarm shift; exec @ARGV' "$VERIFICATION_TIMEOUT" \
	"$GODOT" --headless --path "$PROJECT_DIR" --script "$VERIFICATION" > "$verify_log" 2>&1
verify_status=$?
assert_log_is_fresh "$verify_log"
assert_no_script_error "the headless offer-control verification" "$verify_log"
assert_no_engine_error "the headless offer-control verification" "$verify_log"

if [[ "$verify_status" == "0" ]]; then
	pass "the verification exited 0"
elif [[ "$verify_status" == "142" ]]; then
	fail "the verification did not finish within $VERIFICATION_TIMEOUT s and was killed"
else
	fail "the verification exited $verify_status"
	grep -E "^  FAIL" "$verify_log" | head -20 | sed 's/^/        /'
fi

count="$(read_check_count "RIFT LEVEL-UP OFFER CONTROL VERIFICATION" "$verify_log")"
if [[ "$count" == "$EXPECTED_CHECKS" ]]; then
	pass "verification passes at the pinned $EXPECTED_CHECKS checks"
else
	fail "verification reports ${count:-no} checks, not $EXPECTED_CHECKS"
fi

# A guard that accepts everything protects nothing: the pin must refuse a log whose
# count moved by one, and must READ the moved number.
replay="$(mktemp -t riftwrought_rift_level_up_offer_control_replay)"
scratch_replay="$replay"
sed "s/RIFT LEVEL-UP OFFER CONTROL VERIFICATION: PASS ($EXPECTED_CHECKS checks)/RIFT LEVEL-UP OFFER CONTROL VERIFICATION: PASS ($((EXPECTED_CHECKS + 1)) checks)/" \
	"$verify_log" > "$replay"
replay_count="$(read_check_count "RIFT LEVEL-UP OFFER CONTROL VERIFICATION" "$replay")"
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

# The measurements this foundation exists to make, read out of the run's own log.
# Two lines are pinned only up to a number that varies: the count of project files
# grows with the project, and the frames that pass during check 15's waits depend on
# the machine.
while IFS= read -r line; do
	if grep -qF -- "$line" "$verify_log"; then
		pass "measured: ${line}"
	else
		fail "the verification log does not report: ${line}"
	fi
done <<'MEASURED'
5 of 5 refusals word for word as G4's: 0.0 -> 'no offer opens yet for level 1 — not ready: 0 of the 100 required, 100 still needed'; 25.0 -> 'no offer opens yet for level 1 — not ready: 25 of the 100 required, 75 still needed'; 50.0 -> 'no offer opens yet for level 1 — not ready: 50 of the 100 required, 50 still needed'; 75.0 -> 'no offer opens yet for level 1 — not ready: 75 of the 100 required, 25 still needed'; 99.0 -> 'no offer opens yet for level 1 — not ready: 99 of the 100 required, 1 still needed'
a choice with no offer: 'no offer is open; one must be opened before a lane may be taken', run seed 99 at level 1, no root seed known — and nothing moved
the sweep collected [4]: experience 100.0 = G1's Level 1 requirement 100.0; level 1, offer false, lanes [], paused false, 1 root children before and after
open_level_up_offer(): '' — root seed 99 (G2: 99), frozen requirement 100.0 (G1: 100.0), lanes [0, 1, 2] (D1: [0, 1, 2])
seed 99's Level 1 offer: Support [quick_strike, sweeping_edge]; Combat and Defence [card_celerity]; Utility [card_fleetness] — 3 of 3 identical to the twin's, at D3's own sizes
opening chose nothing and advanced nothing: level 1, experience 100.0, 5 drops all collected
a second opening answered 'level 1 already has an offer open; only a lane of that offer may be taken', as G4 does; the offer and the run are unchanged
3 of 3 undeclared lanes refused exactly as G4 refuses them, each naming run seed 99 at level 1 and root seed 99; the same offer still stands
7: 'lane 7 is not one of the offer's lanes (Support 2996865621, Combat and Defence 1818840148, Utility 1107088162)'
with no profiles, definitions or cards the runtime answered G4's own 'no offer composed: the Support lane refused: the support lane cannot continue: no equipped Skill profiles were given; and with nothing acquired the same inputs still refuse: no equipped Skill profiles were given (3 of 3 lanes refused)' and moved nothing; the same runtime then opened ('')
Support: granted [quick_strike, sweeping_edge] from root seed 99 — a new compatible pair, rank 0 -> 1; the twin's build holds quick_strike -> sweeping_edge at rank 1; then level 2, experience 0.0, no offer; taken again: 'no offer is open; one must be opened before a lane may be taken'; opening: 'no offer opens yet for level 2 — not ready: 0 of the 125 required, 125 still needed'
Combat and Defence: granted [card_celerity] from root seed 99 — no support progression; the twin's build holds card_celerity x1; then level 2, experience 0.0, no offer; taken again: 'no offer is open; one must be opened before a lane may be taken'; opening: 'no offer opens yet for level 2 — not ready: 0 of the 125 required, 125 still needed'
Utility: granted [card_fleetness] from root seed 99 — no support progression; the twin's build holds card_fleetness x1; then level 2, experience 0.0, no offer; taken again: 'no offer is open; one must be opened before a lane may be taken'; opening: 'no offer opens yet for level 2 — not ready: 0 of the 125 required, 125 still needed'
3 of 3 lanes succeeded from 3 independently built runtimes, each record identical to G4's, each advancing exactly one level with the root seed spent once
125.0 -> choice -> level 2 with 25.0 retained, no offer; asked to open: 'no offer opens yet for level 2 — not ready: 25 of the 125 required, 100 still needed', as G4 answers
under the standing offer: attempted 1, collected [], refused 1 with 'an offer is open; it must be resolved before further experience is recorded'; experience 100.0, 1 uncollected, the same offer standing
after Utility was taken (level 2, experience 0.0) the same place collected [5] and paid 25.0; a further sweep skipped 6 and paid nothing
run seed 10: Utility granted [card_insight] (the catalogue's Experience Gain card) and the runtime's own next 25.0 mote paid 27.50000000000000355; Combat and Defence granted [card_vitality] and paid 25.0 — each exactly as its twin
a lane reading rewritten to [2, 1, 2, 7] left the offer reading [0, 1, 2]; an identity reading rewritten to [invented_skill, sweeping_edge, invented_support] left it [quick_strike, sweeping_edge]
the choice granted the offer's own [quick_strike, sweeping_edge]; a copy of its receipt rewritten and the record's own run seed and level rewritten moved nothing; the next record is a new one (run seed 99, level 2); the runtime still holds _run, _field, _bindings
8 of 8 refused records granted nothing, carried no support operation, were coherent, and left their runtime at the level they were asked at
3 fields (_run, _field, _bindings); open_level_up_offer -> G4 open_current_offer; offer_root_seed -> G4 offer_root_seed; offer_lanes -> G4 offer_lanes; offer_identity_for -> G4 offer_identity_for; frozen_offer_requirement -> G4 frozen_requirement; choose_level_up_lane -> G4 choose; each one line; only _init, sweep_at, choose_level_up_lane and Roguelite I3's run_build answer an object
0 of 27 owner-bypassing tokens in its code; 0 of 9 catalogue ids anywhere in the file; no catalogue named
project files scanned; the runtime's only running reader is roguelite_experience_collection_review.gd, which names none of the six and still reads is_offer_active() and shows LEVEL-UP READY; the one file granted its operations, roguelite_level_up_choice_review.gd, calls exactly open_level_up_offer, offer_lanes, offer_identity_for, choose_level_up_lane; project.godot names none
seed=99 level=1 experience=100.0 bindings=4 drops=4 collected=4 uncollected=0 problem='' held while frames passed — no offer, not paused, no node added; then the explicit ask opened it ('') and it still did not pause (
20 refusals were asserted, 11 lane or opening successes driven, 45 Graveblade deaths driven and 47 sweeps made across this suite
MEASURED

# --------------------------------------------------------------------------
step "3. Three fields, six one-line delegations, no catalogue, and nothing that runs calls them"
shape=0
code="$(bare_code "$PROJECT_DIR/$RUNTIME")"
fields="$(grep -E '^var ' <<< "$code" | tr '\n' '|')"
if [[ "$fields" != 'var _run: RiftRunLevelCoordinator|var _field: RiftMoteField|var _bindings: Dictionary[PrototypeGraveblade, RiftGravebladeMoteBinding] = {}|' ]]; then
	fail "the runtime declares the fields: ${fields:-none} — not exactly three"
	shape=$((shape + 1))
fi
for delegation in \
		'return _run.open_current_offer(profiles, definitions, cards)' \
		'return _run.offer_root_seed()' \
		'return _run.offer_lanes()' \
		'return _run.offer_identity_for(lane)' \
		'return _run.frozen_requirement()' \
		'return _run.choose(lane)'; do
	if [[ "$(sed -E 's/^[[:space:]]+//' <<< "$code" | grep -cxF -- "$delegation" | tr -d ' ')" != "1" ]]; then
		fail "the runtime does not hold exactly one line '$delegation'"
		shape=$((shape + 1))
	fi
done
if grep -qE 'Catalogue|quick_strike|reaching_edge|sweeping_edge|card_[a-z]' "$PROJECT_DIR/$RUNTIME"; then
	fail "the runtime names a catalogue or a concrete Skill, support or card id"
	shape=$((shape + 1))
fi
if [[ "$shape" == "0" ]]; then
	pass "three bare fields; the six delegations each exactly one line; no catalogue and no concrete id"
fi

unwired=0
for token in "open_level_up_offer" "offer_root_seed" "offer_lanes" "offer_identity_for" "frozen_offer_requirement" "choose_level_up_lane"; do
	while IFS= read -r hit; do
		case "$hit" in
			*/"$RUNTIME") continue ;;
		esac
		# The three names G4 and E2 share are theirs; a file reaches the runtime's
		# only through a runtime, so only files naming the runtime are refused them.
		if [[ "$token" == "offer_root_seed" || "$token" == "offer_lanes" || "$token" == "offer_identity_for" ]] \
				&& ! grep -qF "RiftMoteRuntime" "$hit"; then
			continue
		fi
		# D-293: the Roguelite I2 level-up choice review, an isolated scene launched by
		# name, is the one file granted four of the six — it opens the one offer, reads
		# its lanes and each lane's identity, and takes one lane. The verification's
		# check 14 proves it calls exactly those four.
		if [[ "$token" == "open_level_up_offer" || "$token" == "offer_lanes" \
				|| "$token" == "offer_identity_for" || "$token" == "choose_level_up_lane" ]]; then
			case "$hit" in
				*/scripts/roguelite/level_up/roguelite_level_up_choice_review.gd) continue ;;
			esac
		fi
		fail "$(basename "$hit") names $token"
		unwired=$((unwired + 1))
	done < <(grep -rlF "$token" "$PROJECT_DIR/scripts" "$PROJECT_DIR/scenes" \
		"$PROJECT_DIR/data" "$PROJECT_DIR/addons" 2>/dev/null)
	if grep -qF "$token" "$PROJECT_DIR/project.godot"; then
		fail "project.godot names $token"
		unwired=$((unwired + 1))
	fi
done
if grep -q '\[autoload\]' "$PROJECT_DIR/project.godot"; then
	fail "project.godot declares an [autoload] section"
	unwired=$((unwired + 1))
fi
if [[ "$unwired" == "0" ]]; then
	pass "nothing under scripts/, scenes/, data/ or addons/ and nothing in project.godot calls any of the six but the D-293 review's four granted calls"
fi

others="$(grep -oE 'res://tests/[A-Za-z0-9_./-]+' "$PROJECT_DIR/$THIS_VERIFICATION" | sort -u \
	| grep -vxF "res://$THIS_VERIFICATION" | tr '\n' ' ')"
if [[ -z "${others// /}" ]] && grep -qF "res://$THIS_VERIFICATION" "$PROJECT_DIR/$THIS_VERIFICATION"; then
	pass "the verification names no file under tests/ but its own"
else
	fail "the verification names another test file: ${others:-none, and not even its own}"
fi

# --------------------------------------------------------------------------
step "4. Nothing that already existed changed during the run"
index=0
moved=0
for file in "${PRESERVED_FILES[@]}"; do
	after="$(fingerprint "$PROJECT_DIR/$file")"
	if [[ "$after" == "MISSING" ]]; then
		fail "$file is missing"
		moved=$((moved + 1))
	elif [[ "$after" != "${before_prints[$index]}" ]]; then
		fail "$file changed during this run"
		moved=$((moved + 1))
	fi
	index=$((index + 1))
done
if [[ "$moved" == "0" ]]; then
	pass "${#PRESERVED_FILES[@]} protected files are byte-identical before and after"
fi

# --------------------------------------------------------------------------
printf '\n'
if [[ "$failures" == "0" ]]; then
	printf 'RIFT LEVEL-UP OFFER CONTROL SMOKE CHECKS: PASS\n'
	printf '  %s checks; %s of %s owed; %s protected files byte-identical\n' \
		"$EXPECTED_CHECKS" "$EXPECTED_OWED_CHECKS" "$EXPECTED_OWED_CHECKS" "${#PRESERVED_FILES[@]}"
	printf '  Roguelite Foundation I1 — Run-Owned Level-Up Offer Control — is\n'
	printf '  DELIVERED under D-291 and ACCEPTED and CLOSED at the run-owned level-up\n'
	printf '  offer-delegation mechanism level under D-292.\n'
	reached_end=1
	exit 0
else
	printf 'RIFT LEVEL-UP OFFER CONTROL SMOKE CHECKS: %d FAILURE(S)\n' "$failures"
	reached_end=1
	exit 1
fi
