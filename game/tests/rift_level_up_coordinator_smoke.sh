#!/usr/bin/env bash
# Riftwrought — Roguelite Foundation E2 smoke checks: the single Rift level-up
# coordinator (decision D-248).
#
# THIS IS NOT A GATE, AND IT DELIBERATELY RUNS NO LOCKED CHAIN.
#
# The foundation is TWO pure-logic scripts under `scripts/levels/` plus this
# suite. It adds no scene, no resource, no asset, no InputMap action and no
# entrypoint change; it writes nothing to disk; it changes no gameplay value; and
# NOTHING THAT RUNS CALLS IT — there is no experience source, no level curve, no
# offer presentation, no UI and no persistence, and the verification proves that
# by scanning every project file under `scripts/`, `scenes/`, `data/` and
# `addons/`, plus `project.godot`, and requiring that not one of them names
# either new class. Rerunning Gates A-F, 1A-1E, the Zone Composer or the three
# roguelite reviews to check an unwired coordinator would be verification theatre
# over work that cannot have reached them.
#
# IT DOES NOT RERUN THE FIVE FOUNDATIONS IT COMPOSES, NOR THE FOUR BESIDE THEM.
# Each owns its own count and is rerun by its own runner. What E2 does do is move
# SEVEN accepted suites' scope assertions one for one — each gains a per-file,
# per-class allowlist row for the E2 coordinator, and two of them gain the
# allowlist itself where they previously refused every file outright — so those
# seven are each rerun by their own runners at their own unchanged pinned counts.
# The four accepted suites E2 does not touch at all are not rerun.
#
# What this script proves:
#
#   1. every new script parses;
#   2. the pinned verification passes, proved in BOTH directions against a
#      replay of its own log, with every owed check reaching its last line;
#   3. the two scripts name no concrete Skill, support, card, character class,
#      room or presentation label, read no storage, no random source and no
#      ambient engine state, and PERFORM NO ARITHMETIC AT ALL — no
#      multiplication, no division, no addition and no floating-point literal but
#      zero, which is the shape a level curve, an experience value or a cap would
#      arrive in; and nothing else in the project names either class, checked in
#      the shell as well as in the engine, because a scan that only ever runs
#      inside the thing it audits is one process away from proving nothing;
#   4. `scripts/levels/` holds exactly the two scripts and no stray file beside
#      them;
#   5. the twenty-seven files it could conceivably have disturbed are
#      BYTE-IDENTICAL ACROSS THE RUN — `project.godot`, the twenty-four accepted
#      mechanism scripts of Foundations A, B, C1, C2, C3, D1, D2, D3 and E1, and
#      the two first-MVP character scripts that own the project's OTHER,
#      persisted, curve-driven experience concept, which this foundation is
#      deliberately not a second implementation of.
#
# THE SEVEN EDITED SUITES ARE DELIBERATELY NOT IN THAT PRESERVED LIST, because
# D-248 edits them on purpose. Every one of their MECHANISM files is in the list
# and is untouched; only their harnesses moved, and each is rerun by its own
# runner at its own unchanged count.
#
# Usage, from the repository root:
#   game/tests/rift_level_up_coordinator_smoke.sh

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
		printf '\nRIFT LEVEL-UP COORDINATOR SMOKE CHECKS: ABORTED before the end of the script\n'
		printf '  the run stopped early (exit %s) — nothing after that point was proved\n' "$status"
		exit 1
	fi
	exit "$status"
}
trap on_exit EXIT

GODOT="${GODOT:-/Applications/Godot.app/Contents/MacOS/Godot}"
EXPECTED_VERSION="4.7.2.stable"
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

VERIFICATION="res://tests/rift_level_up_coordinator_verification.gd"

# Pinned, and proved in both directions below.
# 488 at D-248 delivery, plus the 6 D-249 adds: each of the three lanes now
# proves that the granted identity survives the release of the offer, which is
# the one thing the result type exists for.
EXPECTED_CHECKS=494

# The number of check FUNCTIONS the suite owes, separate from the number of
# assertions. Pinned as a variable rather than written into the grep, because
# hard-coding it into the pattern goes stale the moment a check is added —
# reporting a failure whose text is the correct answer.
EXPECTED_OWED_CHECKS=18

NEW_SCRIPTS=(
	"scripts/levels/rift_level_up_coordinator.gd"
	"scripts/levels/rift_level_up_result.gd"
	"tests/rift_level_up_coordinator_verification.gd"
)

# The two files the foundation owns. Neither may name a Skill, a support, a
# card, a catalogue, a character class, a room or a presentation label; neither
# may store, randomise or read ambient state; and neither may perform any
# arithmetic, because every number in this lifecycle belongs to a foundation
# below it.
LEVEL_SCRIPTS=(
	"scripts/levels/rift_level_up_coordinator.gd"
	"scripts/levels/rift_level_up_result.gd"
)

# The two global class names this foundation introduces. Nothing that runs may
# name either of them.
LEVEL_CLASSES=(
	"RiftLevelUpCoordinator"
	"RiftLevelUpResult"
)

# DELIBERATELY SHORT, AND NOT A WHOLE-PROJECT CATALOGUE. These are the files this
# work could conceivably have disturbed: the project settings, the twenty-four
# accepted mechanism scripts of the nine foundations E2 stands on, and the two
# first-MVP character scripts that own the project's other experience concept.
# E2 must read nine of them and must edit none.
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
	"scripts/runs/rift_run_build.gd"
	"scripts/choices/rift_offer_choice.gd"
	"scripts/choices/rift_offer_choice_result.gd"
	"scripts/choices/rift_consumption_ledger.gd"
	"scripts/experience/rift_experience_track.gd"
	"scripts/experience/rift_experience_reading.gd"
	"scripts/character/experience_table.gd"
	"scripts/character/character_state.gd"
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
# while a script error scrolled past is not a pass. `String formatting error`
# earns its place here because E1's first form printed two of them from a `%`
# that bound tighter than a `+`, and the verification still exited zero.
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

printf 'Riftwrought — Roguelite Foundation E2: the single Rift level-up coordinator (D-248)\n'
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
verify_log="/tmp/riftwrought_rift_level_up_coordinator_verify.log"
"$GODOT" --headless --path "$PROJECT_DIR" --script "$VERIFICATION" > "$verify_log" 2>&1
verify_status=$?
assert_log_is_fresh "$verify_log"
assert_no_script_error "the headless rift level-up coordinator verification" "$verify_log"

if [[ "$verify_status" == "0" ]]; then
	pass "the verification exited 0"
else
	fail "the verification exited $verify_status"
	grep -E "^  FAIL" "$verify_log" | head -20 | sed 's/^/        /'
fi

count="$(read_check_count "RIFT LEVEL-UP COORDINATOR VERIFICATION" "$verify_log")"
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
replay="$(mktemp -t riftwrought_rift_level_up_coordinator_replay)"
scratch_replay="$replay"
sed "s/RIFT LEVEL-UP COORDINATOR VERIFICATION: PASS ($EXPECTED_CHECKS checks)/RIFT LEVEL-UP COORDINATOR VERIFICATION: PASS ($((EXPECTED_CHECKS + 1)) checks)/" \
	"$verify_log" > "$replay"
replay_count="$(read_check_count "RIFT LEVEL-UP COORDINATOR VERIFICATION" "$replay")"
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
# measured line that begins with a dash is read by grep as an option bundle and
# refused outright, producing a check that could never pass whatever the log said.
while IFS= read -r line; do
	if grep -qF -- "$line" "$verify_log"; then
		pass "measured: ${line}"
	else
		fail "the verification log does not report: ${line}"
	fi
done <<'MEASURED'
a default coordinator: level=1 experience=0.0 finished=false offer=false seed=0 requirement=0.0 lanes=[]
50 -> 50.0, 50 -> 100.0; ready for 100 with 0.0 remaining; the level never moved
root seed 0 [Support 2074702303, Combat and Defence 856502828, Utility 83415710] -> quick_strike -> reaching_edge | card_vitality | card_magnetism
4 operations refused while the offer stood; the whole lifecycle is unmoved at level=1 experience=100.0 finished=false offer=true seed=0 requirement=100.0
Support: quick_strike -> reaching_edge; quick_strike -> reaching_edge; no passive cards acquired; no modifiers
Combat and Defence: card_vitality -> maximum_life 0.14999999999999999
Utility: card_magnetism -> pickup_radius 0.25
one pre-choice state, three outcomes, three distinct lifecycles:
50 unmodified -> 50.0; 50 at the shipped Gain -> 55.00000000000000711; two boosted awards -> 110.00000000000001421
150 against 100 -> Level 2 with 50.0 retained; a second offer is still refused
1 short open and 6 unusable requirements refused; the lifecycle stayed at level=1 experience=50.0
2 composition refusals, both quoted from the composer; no offer stood after either
4 undeclared lanes refused; the same offer then paid out card_vitality
nothing advanced, nothing consumed, the offer stood
the advance's own two refusals are unreachable while an offer stands
64 offers over 64 seeds with one pair held: 0 stale, and only ["quick_strike -> sweeping_edge"] offered
7 operations refused after the level-up; the lifecycle is unmoved at level=2 experience=0.0 finished=true offer=false
3 supplied values and 5 returned copies proved independent in both directions
2 scripts scanned raw: 0 forbidden tokens, 0 ambient reads, 0 deferred members, 0 arithmetic operators, 0 stray float literals
8 grants in 7 accepted suites authorize these two files by path and by class
26 refusals were driven across this suite
MEASURED

# --------------------------------------------------------------------------
step "3. The two scripts name nothing concrete, read nothing ambient, do no arithmetic"
ambient=0
for script in "${LEVEL_SCRIPTS[@]}"; do
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
	# A coordinator is handed the records it forwards. Naming a catalogue, a
	# concrete card or the project's OTHER experience concept would make a
	# generic mechanism the shipped set's own — or a second implementation of
	# something that already exists.
	if grep -qE 'PassiveCardCatalogue|SkillSupportCatalogue|ExperienceTable|CharacterState|card_power|card_celerity|card_vitality|card_fleetness|card_insight|card_magnetism' "$PROJECT_DIR/$script"; then
		fail "$script names a catalogue, a concrete card or the first-MVP character curve"
		ambient=$((ambient + 1))
	fi
	# Renaming a record or changing how often it is offered must never change a
	# level-up, and the only arrangement in which that is true is one where it
	# cannot see either.
	if grep -qE 'display_name|base_weight' "$PROJECT_DIR/$script"; then
		fail "$script reads a presentation name or an offer weight"
		ambient=$((ambient + 1))
	fi
	# IT PERFORMS NO ARITHMETIC AT ALL. The comment lines are stripped first:
	# the files' own headers say in plain English that they compute nothing and
	# hold no curve, and a scan that cannot tell the promise from the breach is
	# worthless — Gate 1C's lesson, kept. Unlike E1, ADDITION is forbidden here
	# too: every sum in this lifecycle belongs to a foundation below it.
	if grep -vE '^[[:space:]]*#' "$PROJECT_DIR/$script" | grep -qE '[*/+]'; then
		fail "$script multiplies, divides or adds"
		ambient=$((ambient + 1))
	fi
	# THE ONLY FLOATING-POINT LITERAL IS ZERO. A level curve, an experience drop
	# value or a cap would arrive as exactly one of these, and would name nothing
	# forbidden while doing it.
	strays="$(grep -vE '^[[:space:]]*#' "$PROJECT_DIR/$script" \
		| grep -oE '[0-9]+\.[0-9]+' | grep -vx '0.0' | sort -u | tr '\n' ' ')"
	if [[ -n "${strays// /}" ]]; then
		fail "$script carries the floating-point literal(s) ${strays}"
		ambient=$((ambient + 1))
	fi
done
if [[ "$ambient" == "0" ]]; then
	pass "the ${#LEVEL_SCRIPTS[@]} level-up scripts store nothing, randomise nothing, read no ambient state, name no catalogue, card or label, and perform no arithmetic"
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
for name in "${LEVEL_CLASSES[@]}"; do
	while IFS= read -r hit; do
		case "$hit" in
			*/scripts/levels/rift_level_up_coordinator.gd|*/scripts/levels/rift_level_up_result.gd)
				continue ;;
		esac
		# D-269: the Foundation G4 run-level coordinator owns one current one-level
		# lifecycle and reads the receipt each choice returns, so it names both
		# classes; the run-level record carries a copy of that receipt and names
		# the receipt ONLY. Granted per class in the verification's own allowlist.
		case "$hit" in
			*/scripts/levels/rift_run_level_coordinator.gd)
				continue ;;
		esac
		if [[ "$name" == "RiftLevelUpResult" ]]; then
			case "$hit" in
				*/scripts/levels/rift_run_level_up_result.gd)
					continue ;;
			esac
		fi
		# D-293: the Roguelite I2 level-up choice review reads the receipt a choice's
		# run-level record carries, to present it — the receipt ONLY, never the
		# coordinator. Granted per class in the verification's own allowlist.
		if [[ "$name" == "RiftLevelUpResult" ]]; then
			case "$hit" in
				*/scripts/roguelite/level_up/roguelite_level_up_choice_review.gd)
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
	pass "nothing under scripts/, scenes/, data/ or addons/ outside the Foundation G4 grants and the D-293 review's one receipt grant, and nothing in project.godot, names a Foundation E2 class"
fi

# --------------------------------------------------------------------------
step "4. The new directory holds exactly what it should"
# A scratch probe left behind is a project file nobody meant to ship, and it
# would be invisible to every scan above that filters on a known path. Since
# Foundation G4 (D-269) the directory also holds that foundation's two scripts
# and their two uid files, and nothing else.
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
	pass "scripts/levels/ holds exactly E2's two scripts, G4's two, and their four uid files"
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
	printf 'RIFT LEVEL-UP COORDINATOR SMOKE CHECKS: PASS\n'
	printf '  %s checks; %s of %s owed; %s protected files byte-identical\n' \
		"$EXPECTED_CHECKS" "$EXPECTED_OWED_CHECKS" "$EXPECTED_OWED_CHECKS" "${#PRESERVED_FILES[@]}"
	printf '  Roguelite Foundation E2 is DELIVERED under D-248, CORRECTED under D-249,\n'
	printf '  and ACCEPTED and CLOSED at the single-level-up coordination mechanism\n'
	printf '  level under D-250.\n'
	reached_end=1
	exit 0
else
	printf 'RIFT LEVEL-UP COORDINATOR SMOKE CHECKS: %d FAILURE(S)\n' "$failures"
	reached_end=1
	exit 1
fi
