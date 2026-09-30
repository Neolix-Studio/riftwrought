#!/usr/bin/env bash
# Riftwrought — Roguelite Foundation G3 smoke checks: the completed level-up
# continuation seam (decision D-267).
#
# THIS IS NOT A GATE, AND IT DELIBERATELY RUNS NO LOCKED CHAIN.
#
# Foundation G3 adds ONE method to the accepted single level-up coordinator —
# `next_level_coordinator()` — and nothing else: no field, no scene, no resource,
# no asset, no InputMap action, no entrypoint change, nothing written to disk, and
# NOTHING THAT RUNS CALLS IT. It is a state-transfer seam: a completed one-level
# lifecycle can hand its resulting level, retained experience, run build and
# ledger to a new, independent one-level lifecycle, built through the existing
# `with_state()` seam. It asks no level curve for a requirement, derives no seed,
# and opens no offer on anyone's behalf.
#
# IT DOES NOT RERUN THE FOUNDATIONS THE COORDINATOR COMPOSES. Two accepted suites
# pin the coordinator's exact method list — Foundation E2's and Foundation F5's —
# and each moved by exactly one row; each is rerun by its own runner at its own
# unchanged count. No other accepted suite's file or allowlist changed.
#
# What this script proves:
#
#   1. the changed and new scripts parse;
#   2. the pinned verification passes, proved in BOTH directions against a
#      replay of its own log, with every owed check reaching its last line and
#      the measurements it exists to make read out of that log;
#   3. from outside the engine: the new method is one line of delegation behind
#      one guard; the coordinator, its receipt and this suite's verification name
#      no class of the two accepted, unwired foundations G1 and G2 — whose names
#      are DERIVED here from their own `class_name` lines rather than typed; and
#      nothing under `scripts/`, `scenes/`, `data/` or `addons/`, and nothing in
#      `project.godot`, names the continuation;
#   4. `scripts/levels/` still holds exactly its two scripts;
#   5. the files this work could conceivably have disturbed are BYTE-IDENTICAL
#      ACROSS THE RUN.
#
# Usage, from the repository root:
#   game/tests/rift_level_up_continuation_smoke.sh

set -uo pipefail

# Assigned at the TOP of the script, never beside the function it serves: a
# shell evaluates an assignment only when execution REACHES it, and Gate 1E's
# first staleness guard failed every read for exactly that reason.
RUN_STARTED_AT="$(date +%s)"

# A SCRIPT THAT DIES HALFWAY MUST NOT REPORT SUCCESS. `reached_end` is set by
# exactly one line, immediately before the final verdict.
reached_end=0
scratch_replay=""
on_exit() {
	local code=$?
	[[ -n "$scratch_replay" ]] && rm -f "$scratch_replay"
	if [[ "$reached_end" != "1" ]]; then
		printf '\nRIFT LEVEL-UP CONTINUATION SMOKE CHECKS: ABORTED before the end of the script\n'
		printf '  the run stopped early (exit %s) — nothing after that point was proved\n' "$code"
		exit 1
	fi
	exit "$code"
}
trap on_exit EXIT

GODOT="${GODOT:-/Applications/Godot.app/Contents/MacOS/Godot}"
EXPECTED_VERSION="4.7.2.stable"
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

VERIFICATION="res://tests/rift_level_up_continuation_verification.gd"

# Pinned, and proved in both directions below.
EXPECTED_CHECKS=286

# The number of check FUNCTIONS the suite owes, separate from the number of
# assertions. Pinned as a variable rather than written into the grep, because
# hard-coding it into the pattern goes stale the moment a check is added.
EXPECTED_OWED_CHECKS=9

# The production file G3 changed, the two accepted suites whose pins moved one
# row each, and this suite's verification.
PARSED_SCRIPTS=(
	"scripts/levels/rift_level_up_coordinator.gd"
	"tests/rift_level_up_coordinator_verification.gd"
	"tests/rift_level_up_support_progression_verification.gd"
	"tests/rift_level_up_continuation_verification.gd"
)

COORDINATOR="scripts/levels/rift_level_up_coordinator.gd"
RESULT="scripts/levels/rift_level_up_result.gd"
THIS_VERIFICATION="tests/rift_level_up_continuation_verification.gd"

# The two accepted, deliberately unwired foundations whose classes G3 must not
# name. Their class names are read out of these directories below.
UNWIRED_DIRECTORIES=(
	"scripts/level_requirements"
	"scripts/level_seeds"
)
EXPECTED_UNWIRED_CLASSES=4

# DELIBERATELY SHORT, AND NOT A WHOLE-PROJECT CATALOGUE. The project settings, the
# coordinator G3 extends (which must not move again while this suite reads it),
# every accepted mechanism file a continuation carries or stands beside — the
# track, the receipt, the build, the ledger, the offer, the composer, the choice
# transaction, the ranked-support record, the continuation decision — the two
# unwired foundations G1 and G2, the two first-MVP character scripts that own the
# project's OTHER experience concept, and the project owner's composed zone.
PRESERVED_FILES=(
	"project.godot"
	"scripts/levels/rift_level_up_coordinator.gd"
	"scripts/levels/rift_level_up_result.gd"
	"scripts/experience/rift_experience_track.gd"
	"scripts/experience/rift_experience_reading.gd"
	"scripts/runs/rift_run_build.gd"
	"scripts/choices/rift_consumption_ledger.gd"
	"scripts/choices/rift_offer_choice.gd"
	"scripts/choices/rift_offer_choice_result.gd"
	"scripts/offers/rift_offer.gd"
	"scripts/offers/rift_offer_composition.gd"
	"scripts/skills/acquired_supports.gd"
	"scripts/continuation/support_continuation.gd"
	"scripts/continuation/support_continuation_result.gd"
	"scripts/level_requirements/rift_level_requirement_curve.gd"
	"scripts/level_requirements/rift_level_requirement_reading.gd"
	"scripts/level_seeds/rift_level_offer_seed_derivation.gd"
	"scripts/level_seeds/rift_level_offer_seed_reading.gd"
	"scripts/character/experience_table.gd"
	"scripts/character/character_state.gd"
	"scenes/first_mvp/zone_composer_practice.tscn"
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

# D-201's lesson, kept alive in every runner since: a run that reports PASS
# while a script error scrolled past is not a pass.
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

# `/tmp` is never cleared between runs, so a file from an earlier — possibly
# interrupted — invocation must never answer for this one.
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

printf 'Riftwrought — Roguelite Foundation G3: the completed level-up continuation seam (D-267)\n'
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

# The before-fingerprints, taken before anything runs.
declare -a before_prints=()
for file in "${PRESERVED_FILES[@]}"; do
	before_prints+=("$(fingerprint "$PROJECT_DIR/$file")")
done

# --------------------------------------------------------------------------
step "1. Every changed or new script parses"
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
verify_log="/tmp/riftwrought_rift_level_up_continuation_verify.log"
"$GODOT" --headless --path "$PROJECT_DIR" --script "$VERIFICATION" > "$verify_log" 2>&1
verify_status=$?
assert_log_is_fresh "$verify_log"
assert_no_script_error "the headless level-up continuation verification" "$verify_log"

if [[ "$verify_status" == "0" ]]; then
	pass "the verification exited 0"
else
	fail "the verification exited $verify_status"
	grep -E "^  FAIL" "$verify_log" | head -20 | sed 's/^/        /'
fi

count="$(read_check_count "RIFT LEVEL-UP CONTINUATION VERIFICATION" "$verify_log")"
if [[ "$count" == "$EXPECTED_CHECKS" ]]; then
	pass "verification passes at the pinned $EXPECTED_CHECKS checks"
else
	fail "verification reports ${count:-no} checks, not $EXPECTED_CHECKS"
fi

# A guard that accepts everything protects nothing: the pin must refuse a log
# whose count moved by one, and the negative direction must READ the moved
# number, because a bare `!=` is satisfied by the empty string on exactly the
# runs where a broken suite needs catching.
replay="$(mktemp -t riftwrought_rift_level_up_continuation_replay)"
scratch_replay="$replay"
sed "s/RIFT LEVEL-UP CONTINUATION VERIFICATION: PASS ($EXPECTED_CHECKS checks)/RIFT LEVEL-UP CONTINUATION VERIFICATION: PASS ($((EXPECTED_CHECKS + 1)) checks)/" \
	"$verify_log" > "$replay"
replay_count="$(read_check_count "RIFT LEVEL-UP CONTINUATION VERIFICATION" "$replay")"
if [[ -z "$count" ]]; then
	fail "the verification printed no count line, so the count pin proves nothing this run"
elif [[ "$replay_count" == "$((EXPECTED_CHECKS + 1))" ]]; then
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

# The measurements this foundation exists to make, read out of the run's own log
# rather than restated here. `--` before the pattern is D-244's lesson kept: a
# measured line that begins with a dash is read by grep as an option bundle.
# The number of project files scanned is deliberately NOT pinned: it moves
# whenever any unrelated file is added.
while IFS= read -r line; do
	if grep -qF -- "$line" "$verify_log"; then
		pass "measured: ${line}"
	else
		fail "the verification log does not report: ${line}"
	fi
done <<'MEASURED'
6 continuation requests answered null, 0 moved anything; the completed control continued
15 refusals across both states, each followed by a null continuation and an unmoved lifecycle
Level 2 with 50.09999999999999432 retained, card_vitality x1 {maximum_life 0.14999999999999999 repeatable}, seeds [0] — carried exactly
finished=false offer=false seed=0 (the stand-in, and a seed the ledger holds) requirement=0.0 lanes=0
new pair reaching_edge@1, held reaching_edge@2 beside card_vitality x1, and reaching_edge@1 + sweeping_edge@2 after a consumed 1 -> 2 — all carried
seed 12345 still spent in the continuation; 3 lanes refused with the transaction's own sentence, nothing moved
the stale offer cannot be withdrawn: that continuation refused an award and a second open and cannot complete
a second continuation completed on seed 314159: Level 3, seeds [12345, 314159]
award 30.0; Level 1 against 10.0 -> Level 2 with 20.0 retained; continue; Level 2 against 20.0 -> Level 3 with 0.0 retained
seed 12345 took quick_strike -> sweeping_edge; seed 314159 offered quick_strike -> reaching_edge (an empty build offers sweeping_edge) and took card_celerity; seeds [12345, 314159]
3 continuations of one source, 0 shared private values; progressing one moved neither the source nor another
6 operations refused on the completed source, unmoved; 4 handed-out copies mutated, 0 coordinators moved
21 coordinator methods (the accepted 20 plus next_level_coordinator) and 6 fields; the method is 4 code lines with 0 assignments
4 G1/G2 classes found by directory: named by 0 E2 files, by this suite, or by any running file outside the 3 per-file grants (G4's two files; H9's review, G1 only);
project files scanned, 0 call the continuation outside the G4 run coordinator
28 refusals and 27 null continuations were driven across this suite
MEASURED

# --------------------------------------------------------------------------
step "3. One delegating method, no G1 or G2 name, and nothing that runs calls it"
seam=0

# THE METHOD, FROM OUTSIDE THE ENGINE. Comment lines are stripped: the file says
# in plain English what the continuation does not do, and a scan that cannot
# tell the promise from the breach is worthless — Gate 1C's lesson, kept.
coordinator_code="$(grep -vE '^[[:space:]]*#' "$PROJECT_DIR/$COORDINATOR")"
if [[ "$(grep -cxF 'func next_level_coordinator() -> RiftLevelUpCoordinator:' <<< "$coordinator_code")" != "1" ]]; then
	fail "the coordinator does not declare the continuation exactly once"
	seam=$((seam + 1))
fi
if [[ "$(grep -cxF '	return RiftLevelUpCoordinator.with_state(_track, _build, _ledger)' <<< "$coordinator_code")" != "1" ]]; then
	fail "the continuation does not delegate through with_state() exactly once"
	seam=$((seam + 1))
fi
if [[ "$(grep -oF 'with_state(' <<< "$coordinator_code" | wc -l | tr -d ' ')" != "2" ]]; then
	fail "the coordinator's code names with_state( other than once to declare it and once to call it"
	seam=$((seam + 1))
fi
if [[ "$seam" == "0" ]]; then
	pass "the continuation is declared once and delegates once through with_state()"
fi

# THE TWO UNWIRED FOUNDATIONS' CLASS NAMES, READ FROM THEIR OWN FILES — never
# typed here, so this runner cannot pass by naming the wrong ones, and cannot
# name them at all.
declare -a unwired_classes=()
for directory in "${UNWIRED_DIRECTORIES[@]}"; do
	while IFS= read -r name; do
		[[ -n "$name" ]] && unwired_classes+=("$name")
	done < <(grep -hoE '^class_name [A-Za-z0-9_]+' "$PROJECT_DIR/$directory"/*.gd 2>/dev/null \
		| awk '{print $2}')
done
if [[ "${#unwired_classes[@]}" == "$EXPECTED_UNWIRED_CLASSES" ]]; then
	pass "${#unwired_classes[@]} G1/G2 class names were read from their own directories"
else
	fail "${#unwired_classes[@]} G1/G2 class names were read, not $EXPECTED_UNWIRED_CLASSES — the absence scan below may be inert"
fi
named=0
for file in "$COORDINATOR" "$RESULT" "$THIS_VERIFICATION"; do
	for name in "${unwired_classes[@]}"; do
		if grep -qF "$name" "$PROJECT_DIR/$file"; then
			fail "$file names $name"
			named=$((named + 1))
		fi
	done
done
if [[ "$named" == "0" ]]; then
	pass "the coordinator, its receipt and this suite's verification name no G1 or G2 class"
fi

# NOTHING THAT RUNS CALLS THE CONTINUATION. A floor on what was searched is the
# whole difference between this and a scan of a directory that does not exist.
searched="$(find "$PROJECT_DIR/scripts" "$PROJECT_DIR/scenes" "$PROJECT_DIR/data" \
	"$PROJECT_DIR/addons" -type f \( -name '*.gd' -o -name '*.tscn' -o -name '*.tres' \) \
	2>/dev/null | wc -l | tr -d ' ')"
if [[ "${searched:-0}" -gt 100 ]]; then
	pass "the shell-side scan read $searched project files"
else
	fail "the shell-side scan found only ${searched:-0} project files, so it proves nothing"
fi
callers=0
while IFS= read -r hit; do
	case "$hit" in
		*/scripts/levels/rift_level_up_coordinator.gd)
			continue ;;
	esac
	# D-269: the Foundation G4 run-level coordinator is the one caller D-268
	# ruling 2 assigns single succession to. Nothing that runs calls it.
	case "$hit" in
		*/scripts/levels/rift_run_level_coordinator.gd)
			continue ;;
	esac
	fail "$(basename "$hit") names next_level_coordinator"
	callers=$((callers + 1))
done < <(grep -rlF "next_level_coordinator" "$PROJECT_DIR/scripts" "$PROJECT_DIR/scenes" \
	"$PROJECT_DIR/data" "$PROJECT_DIR/addons" 2>/dev/null)
if grep -qF "next_level_coordinator" "$PROJECT_DIR/project.godot"; then
	fail "project.godot names next_level_coordinator"
	callers=$((callers + 1))
fi
if grep -q '\[autoload\]' "$PROJECT_DIR/project.godot"; then
	fail "project.godot declares an [autoload] section"
	callers=$((callers + 1))
fi
if [[ "$callers" == "0" ]]; then
	pass "nothing under scripts/, scenes/, data/ or addons/ but the G4 run coordinator, and nothing in project.godot, calls the continuation"
fi

# --------------------------------------------------------------------------
step "4. scripts/levels/ holds exactly E2's two scripts and G4's two"
# G3 extended rather than added; Foundation G4 (D-269) later added its own two
# scripts, which with their uid files are the only other files allowed here.
unexpected=0
while IFS= read -r entry; do
	case "$(basename "$entry")" in
		rift_level_up_coordinator.gd|rift_level_up_coordinator.gd.uid| \
		rift_level_up_result.gd|rift_level_up_result.gd.uid| \
		rift_run_level_coordinator.gd|rift_run_level_coordinator.gd.uid| \
		rift_run_level_up_result.gd|rift_run_level_up_result.gd.uid)
			continue ;;
	esac
	fail "scripts/levels/ holds the unexpected file $(basename "$entry")"
	unexpected=$((unexpected + 1))
done < <(find "$PROJECT_DIR/scripts/levels" -type f 2>/dev/null)
gd_count="$(find "$PROJECT_DIR/scripts/levels" -type f -name '*.gd' 2>/dev/null | wc -l | tr -d ' ')"
if [[ "$gd_count" != "4" ]]; then
	fail "scripts/levels/ holds $gd_count scripts, not E2's 2 and G4's 2"
elif [[ "$unexpected" == "0" ]]; then
	pass "scripts/levels/ holds exactly E2's two scripts, G4's two, and their four uid files — G3 extended rather than added"
fi

# --------------------------------------------------------------------------
step "5. Nothing that already existed changed during the run"
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
	printf 'RIFT LEVEL-UP CONTINUATION SMOKE CHECKS: PASS\n'
	printf '  %s checks; %s of %s owed; %s protected files byte-identical\n' \
		"$EXPECTED_CHECKS" "$EXPECTED_OWED_CHECKS" "$EXPECTED_OWED_CHECKS" "${#PRESERVED_FILES[@]}"
	printf '  Roguelite Foundation G3 — Completed Level-Up Continuation Seam — is\n'
	printf '  DELIVERED under D-267 and ACCEPTED and CLOSED at the completed level-up\n'
	printf '  continuation mechanism level under D-268.\n'
	reached_end=1
	exit 0
else
	printf 'RIFT LEVEL-UP CONTINUATION SMOKE CHECKS: %d FAILURE(S)\n' "$failures"
	reached_end=1
	exit 1
fi
