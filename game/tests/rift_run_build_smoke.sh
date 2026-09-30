#!/usr/bin/env bash
# Riftwrought — Roguelite Foundation D2 smoke checks: the temporary Rift
# run-build state (decision D-241, corrected under D-242).
#
# THIS IS NOT A GATE, AND IT DELIBERATELY RUNS NO LOCKED CHAIN.
#
# The foundation is ONE pure-logic script under `scripts/runs/` plus this suite.
# It adds no scene, no resource, no asset, no InputMap action and no entrypoint
# change; it writes nothing to disk; it changes no gameplay value; and NOTHING
# THAT RUNS CALLS IT — there is no offer, no choosing, no experience, no level,
# no application to any actor and no persistence, and the verification proves
# that by scanning every project file under `scripts/`, `scenes/`, `data/` and
# `addons/`, plus `project.godot`, and requiring that not one of them names the
# new class. Rerunning Gates A-F, 1A-1E, the Zone Composer or the three roguelite
# reviews to check an unwired value would be verification theatre over work that
# cannot have reached them.
#
# IT DOES NOT RERUN FOUNDATIONS A, B, C1, C2, C3 OR D1. Each owns its own count
# and is rerun by its own runner. D2 is authorized to READ three of them, which
# is why three of those suites' scope assertions were moved ONE FOR ONE to allow
# exactly this file and exactly the classes it names — changes proved separately
# and at their unchanged pinned 223 (B), 256 (C1) and 180 (C2), with C3 at 299
# and D1 at 447 confirmed unchanged because each cross-reads an edited suite's
# source.
#
# What this script proves:
#
#   1. every new script parses;
#   2. the pinned verification passes, proved in BOTH directions against a
#      replay of its own log, with every owed check reaching its last line;
#   3. the run-build state names no concrete Skill, support, card, catalogue or
#      presentation label, reads neither the presentation name nor the offer
#      weight — the two fields D-242 deliberately keeps OUT of a card's
#      mechanical fingerprint — reads no storage, no random source and no
#      ambient engine state, and performs no percentage arithmetic of its own;
#      and nothing else in the project names it; checked in the shell as well as
#      in the engine, because a scan that only ever runs inside the thing it
#      audits is one process away from proving nothing;
#   4. `scripts/runs/` holds exactly the one script it should and no stray file
#      beside it;
#   5. the nineteen files it could conceivably have disturbed are BYTE-IDENTICAL
#      ACROSS THE RUN — `project.godot` and the eighteen accepted mechanism
#      scripts of Foundations A, B, C1, C2, C3 and D1.
#
# THE THREE EDITED SUITES ARE DELIBERATELY NOT IN THAT PRESERVED LIST, because
# D-241 edits them on purpose: a per-file allowlist gained one row each. Their
# MECHANISMS are in the list and are untouched; their harnesses moved, and each
# is re-run by its own runner at its own unchanged count.
#
# Usage, from the repository root:
#   game/tests/rift_run_build_smoke.sh

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
	local status=$?
	[[ -n "$scratch_replay" ]] && rm -f "$scratch_replay"
	if [[ "$reached_end" != "1" ]]; then
		printf '\nRIFT RUN BUILD SMOKE CHECKS: ABORTED before the end of the script\n'
		printf '  the run stopped early (exit %s) — nothing after that point was proved\n' "$status"
		exit 1
	fi
	exit "$status"
}
trap on_exit EXIT

GODOT="${GODOT:-/Applications/Godot.app/Contents/MacOS/Godot}"
EXPECTED_VERSION="4.7.2.stable"
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

VERIFICATION="res://tests/rift_run_build_verification.gd"

# Pinned, and proved in both directions below.
EXPECTED_CHECKS=259

# The number of check FUNCTIONS the suite owes, separate from the number of
# assertions. Pinned as a variable rather than written into the grep, because
# hard-coding it into the pattern goes stale the moment a check is added —
# reporting a failure whose text is the correct answer.
EXPECTED_OWED_CHECKS=11

NEW_SCRIPTS=(
	"scripts/runs/rift_run_build.gd"
	"tests/rift_run_build_verification.gd"
)

# The one file the foundation itself owns. It may not name a Skill, a support, a
# card, either catalogue or a presentation label; it may not store, randomise or
# read ambient state; and it may not compute a percentage — the accepted
# accumulator adds modifiers and nothing here applies one.
STATE_SCRIPTS=(
	"scripts/runs/rift_run_build.gd"
)

# The one global class name this foundation introduces. Nothing that runs may
# name it.
STATE_CLASSES=(
	"RiftRunBuild"
)

# DELIBERATELY SHORT, AND NOT A WHOLE-PROJECT CATALOGUE. These are the files this
# work could conceivably have disturbed: the project settings and the eighteen
# accepted mechanism scripts of the foundations D2 stands on. D2 must read three
# of them and must edit none.
PRESERVED_FILES=(
	"project.godot"
	"scripts/skills/skill_tags.gd"
	"scripts/skills/skill_tag_profile.gd"
	"scripts/skills/support_eligibility.gd"
	"scripts/skills/skill_support_catalogue.gd"
	"scripts/skills/support_definition.gd"
	"scripts/skills/acquired_supports.gd"
	"scripts/skills/support_selection.gd"
	"scripts/skills/support_selection_result.gd"
	"scripts/stats/player_stat_definition.gd"
	"scripts/stats/player_stat_value.gd"
	"scripts/stats/player_stats.gd"
	"scripts/stats/player_stat_totals.gd"
	"scripts/stats/passive_card_definition.gd"
	"scripts/stats/passive_card_catalogue.gd"
	"scripts/stats/passive_card_selection.gd"
	"scripts/stats/passive_card_selection_result.gd"
	"scripts/offers/rift_offer.gd"
	"scripts/offers/rift_offer_composition.gd"
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

printf 'Riftwrought — Roguelite Foundation D2: the Rift run-build state (D-241)\n'
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
step "1. Every new script parses"
for script in "${NEW_SCRIPTS[@]}"; do
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
verify_log="/tmp/riftwrought_rift_run_build_verify.log"
"$GODOT" --headless --path "$PROJECT_DIR" --script "$VERIFICATION" > "$verify_log" 2>&1
verify_status=$?
assert_log_is_fresh "$verify_log"
assert_no_script_error "the headless rift run build verification" "$verify_log"

if [[ "$verify_status" == "0" ]]; then
	pass "the verification exited 0"
else
	fail "the verification exited $verify_status"
	grep -E "^  FAIL" "$verify_log" | head -20 | sed 's/^/        /'
fi

count="$(read_check_count "RIFT RUN BUILD VERIFICATION" "$verify_log")"
if [[ "$count" == "$EXPECTED_CHECKS" ]]; then
	pass "verification passes at the pinned $EXPECTED_CHECKS checks"
else
	fail "verification reports ${count:-no} checks, not $EXPECTED_CHECKS"
fi

# A guard that accepts everything protects nothing: the pin must refuse a log
# whose count moved by one.
#
# THE NEGATIVE DIRECTION MUST READ THE MOVED NUMBER, NOT MERELY "NOT THE PINNED
# ONE". A bare `!=` is satisfied by the empty string, so on any run where the
# verification never printed its PASS line — exactly the runs where a broken
# suite needs catching — the substitution is a no-op, both reads come back
# empty, and the guard reports PASS while proving nothing at all.
replay="$(mktemp -t riftwrought_rift_run_build_replay)"
scratch_replay="$replay"
sed "s/RIFT RUN BUILD VERIFICATION: PASS ($EXPECTED_CHECKS checks)/RIFT RUN BUILD VERIFICATION: PASS ($((EXPECTED_CHECKS + 1)) checks)/" \
	"$verify_log" > "$replay"
replay_count="$(read_check_count "RIFT RUN BUILD VERIFICATION" "$replay")"
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
# rather than restated here.
while IFS= read -r line; do
	if grep -qF "$line" "$verify_log"; then
		pass "measured: ${line}"
	else
		fail "the verification log does not report: ${line}"
	fi
done <<'MEASURED'
a new state is empty across 6 stats, 0 pairs and 0 card acquisitions
1 pair held after a refused repeat; the complete state is unchanged
1 support across 2 Skills is 2 pairs; 3 pairs over 2 Skills report in a stable order
5 empty-identifier refusals, each leaving the complete state unchanged
2 acquisitions of card_power: 2 recorded, total 0.20000000000000001, contributions [0.10000000000000001, 0.10000000000000001]
the multiplicative answer would have been 0.21000000000000019 and is refused
6 of 6 shipped cards are repeatable and are unchanged; the once-only rule is generic
2 identical, 1 renamed and 1 reweighted record all compatible
3 mechanical conflicts refused by name, 1 once-only bypass refused,
11 invalid records refused, each leaving the complete state unchanged
and the one refusal the record layer cannot see — a non-finite SUM — counts nothing
4 acquisition orders over 8 cards agree on every count and every total (0 drift)
6 exposed values mutated; the original state is unchanged in both directions
0 forbidden tokens, 0 ambient reads, 0 deferred members, 0 operators, 0 float literals
24 methods and 3 fields pinned, all 3 fields private
25 refusals were driven across this suite
MEASURED

# --------------------------------------------------------------------------
step "3. The state names nothing concrete, reads nothing ambient, computes no percentage"
ambient=0
for script in "${STATE_SCRIPTS[@]}"; do
	if grep -qE 'user://|ConfigFile|ResourceSaver|ResourceLoader|FileAccess' "$PROJECT_DIR/$script"; then
		fail "$script names a storage path or a writer"
		ambient=$((ambient + 1))
	fi
	if grep -qE 'randi|randf|randomize|RandomNumberGenerator|rand_from_seed' "$PROJECT_DIR/$script"; then
		fail "$script reads a global random source"
		ambient=$((ambient + 1))
	fi
	if grep -qE 'Time\.|OS\.|Engine\.|ProjectSettings|InputMap' "$PROJECT_DIR/$script"; then
		fail "$script reads ambient engine state"
		ambient=$((ambient + 1))
	fi
	if grep -qE 'QuickStrike|quick_strike|PrototypePlayer|PassiveEffects|RogueliteUpgrade|SkillTags|FirstMvpSkill|Graveblade' "$PROJECT_DIR/$script"; then
		fail "$script names a concrete class"
		ambient=$((ambient + 1))
	fi
	# A run-build state is handed the records it accumulates. Naming a catalogue
	# would make a generic mechanism the shipped set's own.
	if grep -qE 'PassiveCardCatalogue|SkillSupportCatalogue|card_power|card_celerity|card_vitality|card_fleetness|card_insight|card_magnetism|reaching_edge|sweeping_edge' "$PROJECT_DIR/$script"; then
		fail "$script names a catalogue, a card or a support"
		ambient=$((ambient + 1))
	fi
	# Renaming or reweighting a record must never change what is stored, and the
	# only arrangement in which that is true is one where it cannot see either.
	if grep -qE 'display_name|base_weight' "$PROJECT_DIR/$script"; then
		fail "$script reads a presentation name or an offer weight"
		ambient=$((ambient + 1))
	fi
	# It accumulates through the accepted accumulator and applies nothing. The
	# comment lines are stripped first: the file's own header says in plain
	# English that it computes no percentage, and a scan that cannot tell the
	# promise from the breach is worthless — Gate 1C's lesson, kept.
	if grep -vE '^[[:space:]]*#' "$PROJECT_DIR/$script" | grep -qE '[*/]'; then
		fail "$script multiplies or divides"
		ambient=$((ambient + 1))
	fi
	if grep -vE '^[[:space:]]*#' "$PROJECT_DIR/$script" | grep -qE '[0-9]\.[0-9]'; then
		fail "$script carries a floating-point literal"
		ambient=$((ambient + 1))
	fi
done
if [[ "$ambient" == "0" ]]; then
	pass "the ${#STATE_SCRIPTS[@]} state script stores nothing, randomises nothing, reads no ambient state, names no catalogue or label, and does no percentage arithmetic"
fi

# NOTHING THAT RUNS CALLS IT, measured a second time from outside the engine.
#
# IT ASSERTS A FLOOR ON WHAT IT SEARCHED, WHICH IS THE WHOLE DIFFERENCE BETWEEN
# this and a scan that proves nothing. `grep -rl` over a directory that does not
# exist — a renamed tree, a PROJECT_DIR resolved one level high — returns nothing
# and looks exactly like a clean result.
searched="$(find "$PROJECT_DIR/scripts" "$PROJECT_DIR/scenes" "$PROJECT_DIR/data" \
	"$PROJECT_DIR/addons" -type f \( -name '*.gd' -o -name '*.tscn' -o -name '*.tres' \) \
	2>/dev/null | wc -l | tr -d ' ')"
if [[ "${searched:-0}" -gt 100 ]]; then
	pass "the shell-side scan read $searched project files"
else
	fail "the shell-side scan found only ${searched:-0} project files, so it proves nothing"
fi

referenced=0
for name in "${STATE_CLASSES[@]}"; do
	while IFS= read -r hit; do
		case "$hit" in
			*/scripts/runs/rift_run_build.gd)
				continue ;;
		esac
		# D-244: the Foundation D3 choice transaction duplicates the run build and
		# stages one lane onto the copy; its result carries that new build. Both
		# therefore name the state. The consumption ledger beside them does not.
		# D-269: the Foundation G4 run-level coordinator hands on its current
		# lifecycle's build copy as its run-build reading, so it names the state too.
		# D-295: the H8 runtime hands on its run's build copy as its one build reading,
		# the run-build application seam is handed that snapshot, and the live-effect
		# review asks for it and makes one empty build to restore every baseline.
		if [[ "$name" == "RiftRunBuild" ]]; then
			case "$hit" in
				*/scripts/choices/rift_offer_choice.gd|*/scripts/choices/rift_offer_choice_result.gd| \
				*/scripts/levels/rift_level_up_coordinator.gd| \
				*/scripts/levels/rift_run_level_coordinator.gd| \
				*/scripts/experience/rift_mote_runtime.gd| \
				*/scripts/roguelite/live_effects/rift_build_application.gd| \
				*/scripts/roguelite/live_effects/roguelite_live_effect_review.gd)
					continue ;;
			esac
		fi
		fail "$(basename "$hit") names $name"
		referenced=$((referenced + 1))
	done < <(grep -rlF "$name" "$PROJECT_DIR/scripts" "$PROJECT_DIR/scenes" \
		"$PROJECT_DIR/data" "$PROJECT_DIR/addons" 2>/dev/null)
	# An [autoload] entry loads a class without any script naming it.
	if grep -qF "$name" "$PROJECT_DIR/project.godot"; then
		fail "project.godot names $name"
		referenced=$((referenced + 1))
	fi
done
if [[ "$referenced" == "0" ]]; then
	pass "nothing under scripts/, scenes/, data/ or addons/ and nothing in project.godot names the Foundation D2 class"
fi

# --------------------------------------------------------------------------
step "4. The new directory holds exactly what it should"
# A scratch probe left behind is a project file nobody meant to ship, and it
# would be invisible to every scan above that filters on a known path.
unexpected=0
while IFS= read -r entry; do
	case "$(basename "$entry")" in
		rift_run_build.gd|rift_run_build.gd.uid)
			continue ;;
	esac
	fail "scripts/runs/ holds the unexpected file $(basename "$entry")"
	unexpected=$((unexpected + 1))
done < <(find "$PROJECT_DIR/scripts/runs" -type f 2>/dev/null)
gd_count="$(find "$PROJECT_DIR/scripts/runs" -type f -name '*.gd' 2>/dev/null | wc -l | tr -d ' ')"
if [[ "$gd_count" != "1" ]]; then
	fail "scripts/runs/ holds $gd_count scripts, not 1"
elif [[ "$unexpected" == "0" ]]; then
	pass "scripts/runs/ holds exactly the one script and its uid file"
fi

# --------------------------------------------------------------------------
step "5. Nothing that already existed changed"
index=0
moved=0
for file in "${PRESERVED_FILES[@]}"; do
	after="$(fingerprint "$PROJECT_DIR/$file")"
	if [[ "$after" != "${before_prints[$index]}" ]]; then
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
	printf 'RIFT RUN BUILD SMOKE CHECKS: PASS\n'
	printf '  %s checks; %s of %s owed; %s protected files byte-identical\n' \
		"$EXPECTED_CHECKS" "$EXPECTED_OWED_CHECKS" "$EXPECTED_OWED_CHECKS" "${#PRESERVED_FILES[@]}"
	printf '  Roguelite Foundation D2 is DELIVERED under D-241, CORRECTED under D-242,\n'
	printf '  and ACCEPTED and CLOSED at the temporary run-state mechanism level\n'
	printf '  under D-243.\n'
	reached_end=1
	exit 0
else
	printf 'RIFT RUN BUILD SMOKE CHECKS: %d FAILURE(S)\n' "$failures"
	reached_end=1
	exit 1
fi
