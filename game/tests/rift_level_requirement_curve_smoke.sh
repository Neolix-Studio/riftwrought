#!/usr/bin/env bash
# Riftwrought — Roguelite Foundation G1 smoke checks: the deterministic greybox
# level-requirement curve (decision D-262).
#
# THIS IS NOT A GATE, AND IT DELIBERATELY RUNS NO LOCKED CHAIN.
#
# The foundation is TWO pure-logic scripts under `scripts/level_requirements/`
# plus this suite. It adds no scene, no resource, no asset, no InputMap action and
# no entrypoint change; it writes nothing to disk; it changes no gameplay value;
# and NOTHING THAT RUNS CALLS IT — the accepted experience track and the accepted
# level-up coordinator still receive their requirement from their caller, and the
# verification proves that by scanning every project file under `scripts/`,
# `scenes/`, `data/` and `addons/`, plus `project.godot`, and requiring that not
# one of them names either new class. Rerunning Gates A-F, 1A-1E, the Zone
# Composer, the three roguelite reviews or any accepted foundation to check an
# unwired formula would be verification theatre over work that cannot have
# reached them.
#
# NO ACCEPTED SUITE WAS EDITED. The curve names no accepted class, so no accepted
# verifier's allowlist had to move, and none of them is rerun from here.
#
# What this script proves:
#
#   1. every new script parses;
#   2. the pinned verification passes, proved in BOTH directions against a
#      replay of its own log, with every owed check reaching its last line;
#   3. the two scripts name nothing concrete, read no storage, no random source
#      and no ambient engine state, contain no loop and no floating-point literal,
#      and hold the formula's multiplication exactly once — and nothing else in
#      the project names either class, checked in the shell as well as in the
#      engine, because a scan that only ever runs inside the thing it audits is
#      one process away from proving nothing;
#   4. `scripts/level_requirements/` holds exactly the two scripts it should;
#   5. `project.godot` gained nothing;
#   6. the files this work could conceivably have disturbed are BYTE-IDENTICAL
#      ACROSS THE RUN — including both accepted Foundation E1 scripts and both
#      accepted Foundation E2 scripts.
#
# IT READS NO OTHER SUITE (decision D-263). The verification names no file under
# `tests/` but its own, which step 3 asserts, so a rename or a formatting-only
# edit inside any other suite cannot change a result here.
#
# Usage, from the repository root:
#   game/tests/rift_level_requirement_curve_smoke.sh

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
		printf '\nRIFT LEVEL REQUIREMENT CURVE SMOKE CHECKS: ABORTED before the end of the script\n'
		printf '  the run stopped early (exit %s) — nothing after that point was proved\n' "$status"
		exit 1
	fi
	exit "$status"
}
trap on_exit EXIT

GODOT="${GODOT:-/Applications/Godot.app/Contents/MacOS/Godot}"
EXPECTED_VERSION="4.7.2.stable"
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

VERIFICATION="res://tests/rift_level_requirement_curve_verification.gd"

# Pinned, and proved in both directions below.
EXPECTED_CHECKS=516

# The number of check FUNCTIONS the suite owes, separate from the number of
# assertions. Pinned as a variable rather than written into the grep, because
# hard-coding it into the pattern goes stale the moment a check is added —
# reporting a failure whose text is the correct answer.
EXPECTED_OWED_CHECKS=17

NEW_SCRIPTS=(
	"scripts/level_requirements/rift_level_requirement_curve.gd"
	"scripts/level_requirements/rift_level_requirement_reading.gd"
	"tests/rift_level_requirement_curve_verification.gd"
)

G1_SCRIPTS=(
	"scripts/level_requirements/rift_level_requirement_curve.gd"
	"scripts/level_requirements/rift_level_requirement_reading.gd"
)

CURVE="scripts/level_requirements/rift_level_requirement_curve.gd"

# The two global class names this foundation introduces. Nothing that runs may
# name either of them.
G1_CLASSES=(
	"RiftLevelRequirementCurve"
	"RiftLevelRequirementReading"
)

# DELIBERATELY SHORT, AND NOT A WHOLE-PROJECT CATALOGUE. These are the files this
# work could conceivably have disturbed: the project settings, the canonical
# combat record, every accepted foundation mechanism script — including the two
# E1 and two E2 scripts this curve is deliberately NOT wired into — the two
# first-MVP character scripts that own the project's other, unrelated experience
# curve, and the project owner's own composed zone. No other suite's file is in
# this list, because since D-263 the verification reads none.
PRESERVED_FILES=(
	"project.godot"
	"data/prototype_zero/quick_strike.tres"
	"scripts/skills/skill_tags.gd"
	"scripts/skills/skill_tag_profile.gd"
	"scripts/skills/support_eligibility.gd"
	"scripts/skills/skill_support_catalogue.gd"
	"scripts/skills/support_definition.gd"
	"scripts/skills/acquired_supports.gd"
	"scripts/skills/support_selection_result.gd"
	"scripts/skills/support_selection.gd"
	"scripts/continuation/support_continuation.gd"
	"scripts/continuation/support_continuation_result.gd"
	"scripts/runs/rift_run_build.gd"
	"scripts/offers/rift_offer.gd"
	"scripts/offers/rift_offer_composition.gd"
	"scripts/choices/rift_offer_choice.gd"
	"scripts/choices/rift_offer_choice_result.gd"
	"scripts/choices/rift_consumption_ledger.gd"
	"scripts/experience/rift_experience_track.gd"
	"scripts/experience/rift_experience_reading.gd"
	"scripts/levels/rift_level_up_coordinator.gd"
	"scripts/levels/rift_level_up_result.gd"
	"scripts/stats/passive_card_catalogue.gd"
	"scripts/stats/passive_card_definition.gd"
	"scripts/stats/passive_card_selection.gd"
	"scripts/stats/passive_card_selection_result.gd"
	"scripts/stats/player_stat_definition.gd"
	"scripts/stats/player_stat_totals.gd"
	"scripts/stats/player_stat_value.gd"
	"scripts/stats/player_stats.gd"
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
# while a script error scrolled past is not a pass — and a `--script` run whose
# file fails to PARSE exits 0. `String formatting error` is E1's addition: a `%`
# that binds tighter than a `+` prints one and still exits zero.
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

printf 'Riftwrought — Roguelite Foundation G1: the deterministic greybox level-requirement curve (D-262)\n'
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
verify_log="/tmp/riftwrought_rift_level_requirement_curve_verify.log"
"$GODOT" --headless --path "$PROJECT_DIR" --script "$VERIFICATION" > "$verify_log" 2>&1
verify_status=$?
assert_log_is_fresh "$verify_log"
assert_no_script_error "the headless level-requirement curve verification" "$verify_log"

if [[ "$verify_status" == "0" ]]; then
	pass "the verification exited 0"
else
	fail "the verification exited $verify_status"
	grep -E "^  FAIL" "$verify_log" | head -20 | sed 's/^/        /'
fi

count="$(read_check_count "RIFT LEVEL REQUIREMENT CURVE VERIFICATION" "$verify_log")"
if [[ "$count" == "$EXPECTED_CHECKS" ]]; then
	pass "verification passes at the pinned $EXPECTED_CHECKS checks"
else
	fail "verification reports ${count:-no} checks, not $EXPECTED_CHECKS"
fi

# A guard that accepts everything protects nothing: the pin must refuse a log
# whose count moved by one — and the negative direction must read the MOVED
# number rather than merely "not the pinned one", because a bare `!=` is
# satisfied by the empty string on exactly the runs where a broken suite needs
# catching.
replay="$(mktemp -t riftwrought_rift_level_requirement_curve_replay)"
scratch_replay="$replay"
sed "s/RIFT LEVEL REQUIREMENT CURVE VERIFICATION: PASS ($EXPECTED_CHECKS checks)/RIFT LEVEL REQUIREMENT CURVE VERIFICATION: PASS ($((EXPECTED_CHECKS + 1)) checks)/" \
	"$verify_log" > "$replay"
replay_count="$(read_check_count "RIFT LEVEL REQUIREMENT CURVE VERIFICATION" "$replay")"
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
while IFS= read -r line; do
	if grep -qF -- "$line" "$verify_log"; then
		pass "measured: ${line}"
	else
		fail "the verification log does not report: ${line}"
	fi
done <<'MEASURED'
6 levels below 1 refused, down to -9223372036854775808; each stored requirement 0 and converted to positive infinity; level 1 answers
level 1 -> 100, 2 -> 125, 3 -> 150, 5 -> 200, 10 -> 325, 25 -> 700, 100 -> 2575
level 1 -> 100, converted 100.0; the accepted track: 100 ready with 0.0 left, 75 not ready with 25.0 still needed, 130 advances once to Level 2 keeping 30.0
10000 consecutive levels from Level 1: 100 -> 250075, every one positive, finite and larger than the last
10000 consecutive levels ending at the boundary: 9007199254491000 -> 9007199254740975, every one positive, finite and larger than the last
from level 1: 9999 adjacent steps, every one exactly 25 and exactly 25.0
from level 360287970179637: 9999 adjacent steps, every one exactly 25 and exactly 25.0
23 sampled levels asked three times each: every answer bit-identical and a fresh value; a tampered reading reached nothing
23 levels asked forwards, backwards, from both ends between refusals, and through two instances: 0 answers moved
curve: 0 instance fields, 0 declared variables, 2 of 2 methods static; reading: 4 fields — ok, failure_reason, level, requirement
13 contradictory shapes caught by problem(); each restored reading is coherent again; the bound itself is coherent
largest supported level 360287970189636 -> 9007199254740975, below the bound 9007199254740991; converts exactly to 9007199254740975.0
level 360287970189637 refused, storing requirement 0 and converting to positive infinity; it would need 9007199254741000, exactly representable yet past the bound
the 9-level refusal band across both guards, from 360287970189637 to 9223372036854775807, all refused with no requirement; the boundary answer unmoved
20012 results examined: 0 above 9007199254740991, 0 changed by conversion; the largest is 9007199254740975
the engine wraps: 737869762948382065 x 25 = 9; 3 wrap-around levels that a result check would accept were refused by guards that run first
floor guard, subtraction, product guard, product, sum guard, sum at body lines [0, 5, 6, 8, 9, 11]; 1 multiplication and 1 addition in production
no scanned file outside the G4 grant and the experience collection review's grant, and not project.godot, names a G1 class; E1 keeps its 5 requirement-taking members and E2 its 2; 4 accepted files name nothing G1 introduced
2 scripts scanned: 0 forbidden tokens, 0 ambient reads, 0 deferred members, 0 loops, 0 float literals
whole numbers: curve 1, 100, 25, reading 0, 1, 53; 7 signatures, 8 constants and 4 fields pinned
no designed maximum: 1000000 -> 25000075, 1000000000 -> 25000000075, 1000000000000 -> 25000000000075, 100000000000000 -> 2500000000000075, 300000000000000 -> 7500000000000075
14 successes and 16 refusals were driven across this suite
17 refusals from the floor, both guards and the constructor: every one stored 0 and converted to positive infinity; 0 to zero, 0 to negative infinity, 0 to NaN, 0 finite
221 careless comparisons against 13 finite progress values up to the largest finite double: 0 satisfied; a zero conversion would have satisfied 11 of the 13
12 refused conversions handed to 4 accepted tracks: every reading, readiness, remaining and advance refused; 0 tracks moved
20012 successful conversions: every one finite, positive and byte-identical to its exact whole number; 7 named examples and the boundary match independent expectations byte for byte
MEASURED

# --------------------------------------------------------------------------
step "3. The two scripts name nothing concrete, read nothing ambient, and are unwired"
ambient=0
for script in "${G1_SCRIPTS[@]}"; do
	if grep -qE 'user://|ConfigFile|ResourceSaver|ResourceLoader|FileAccess' "$PROJECT_DIR/$script"; then
		fail "$script names a storage path or a writer"
		ambient=$((ambient + 1))
	fi
	if grep -qE 'randi|randf|randomize|RandomNumberGenerator|rand_from_seed' "$PROJECT_DIR/$script"; then
		fail "$script reads a global random source"
		ambient=$((ambient + 1))
	fi
	if grep -qE 'Time\.|OS\.|Engine\.|ProjectSettings|InputMap|get_tree|get_node' "$PROJECT_DIR/$script"; then
		fail "$script reads ambient engine state"
		ambient=$((ambient + 1))
	fi
	# A level-requirement rule is handed a level. Naming a card, a Skill, the
	# accepted experience track, the accepted coordinator or the project's OTHER
	# experience curve would make it a caller of something, or a second copy of it.
	if grep -qE 'QuickStrike|quick_strike|Graveblade|PassiveCard|SkillSupport|RiftExperience|RiftLevelUp|RiftOffer|RiftRunBuild|ExperienceTable|CharacterState|TOTAL_FOR_LEVEL' "$PROJECT_DIR/$script"; then
		fail "$script names a card, a Skill, an accepted foundation or the first-MVP curve"
		ambient=$((ambient + 1))
	fi
	# Comment lines are stripped for the next three: both files say in plain
	# English that they hold no loop, no table and no cap, and a scan that cannot
	# tell the promise from the breach is worthless — Gate 1C's lesson, kept.
	if grep -vE '^[[:space:]]*#' "$PROJECT_DIR/$script" | grep -qE '^[[:space:]]*(for|while)[[:space:]]'; then
		fail "$script loops"
		ambient=$((ambient + 1))
	fi
	strays="$(grep -vE '^[[:space:]]*#' "$PROJECT_DIR/$script" \
		| grep -oE '[0-9]+\.[0-9]+' | sort -u | tr '\n' ' ')"
	if [[ -n "${strays// /}" ]]; then
		fail "$script carries the floating-point literal(s) ${strays}"
		ambient=$((ambient + 1))
	fi
done
# ONE FORMULA: the curve's code multiplies exactly once, and the result type not
# at all.
products="$(grep -vE '^[[:space:]]*#' "$PROJECT_DIR/$CURVE" | grep -c '\*' | tr -d ' ')"
if [[ "$products" != "1" ]]; then
	fail "the curve's code multiplies on $products lines, not 1"
	ambient=$((ambient + 1))
fi
if grep -vE '^[[:space:]]*#' "$PROJECT_DIR/scripts/level_requirements/rift_level_requirement_reading.gd" \
		| grep -qE '\*| \+ '; then
	fail "the result type multiplies or adds"
	ambient=$((ambient + 1))
fi
# A REFUSED CONVERSION FAILS SAFE (D-263): the result type answers positive
# infinity for a refusal in exactly one place, and never a zero conversion.
reading_code="$(grep -vE '^[[:space:]]*#' "$PROJECT_DIR/scripts/level_requirements/rift_level_requirement_reading.gd")"
if [[ "$(grep -cE '^[[:space:]]*return INF$' <<< "$reading_code")" != "1" ]]; then
	fail "the result type does not convert a refusal to positive infinity in exactly one place"
	ambient=$((ambient + 1))
fi
if grep -qE 'return float\(NO_REQUIREMENT\)|return -INF|return NAN' <<< "$reading_code"; then
	fail "the result type converts a refusal to zero, negative infinity or NaN"
	ambient=$((ambient + 1))
fi
if [[ "$ambient" == "0" ]]; then
	pass "the ${#G1_SCRIPTS[@]} scripts store nothing, randomise nothing, read no ambient state, name nothing concrete, loop nowhere, hold no float literal, and multiply once between them"
fi

# IT READS NO OTHER SUITE (D-263). The verification may name no file under
# `tests/` but its own, so nothing another suite names, formats or moves can
# change a result here — measured from outside the engine, with a floor on what
# was read so that an empty file cannot pass for a clean one.
verification_source="$PROJECT_DIR/tests/rift_level_requirement_curve_verification.gd"
named_tests="$(grep -oE 'res://tests/[A-Za-z0-9_]+\.gd' "$verification_source" | sort -u | tr '\n' ' ')"
if [[ "$(wc -l < "$verification_source" | tr -d ' ')" -lt 1000 ]]; then
	fail "the verification read as too short for this scan to prove anything"
elif [[ "$named_tests" == "res://tests/rift_level_requirement_curve_verification.gd " ]]; then
	pass "the verification names no file under tests/ but its own, so it reads no other suite"
else
	fail "the verification names other test files: ${named_tests}"
fi

# NOTHING THAT RUNS CALLS IT, measured a second time from outside the engine.
#
# IT ASSERTS A FLOOR ON WHAT IT SEARCHED: `grep -rl` over a directory that does
# not exist returns nothing and looks exactly like a clean result.
searched="$(find "$PROJECT_DIR/scripts" "$PROJECT_DIR/scenes" "$PROJECT_DIR/data" \
	"$PROJECT_DIR/addons" -type f \( -name '*.gd' -o -name '*.tscn' -o -name '*.tres' \) \
	2>/dev/null | wc -l | tr -d ' ')"
if [[ "${searched:-0}" -gt 100 ]]; then
	pass "the shell-side scan read $searched project files"
else
	fail "the shell-side scan found only ${searched:-0} project files, so it proves nothing"
fi

referenced=0
for name in "${G1_CLASSES[@]}"; do
	while IFS= read -r hit; do
		case "$hit" in
			*/scripts/level_requirements/rift_level_requirement_curve.gd|*/scripts/level_requirements/rift_level_requirement_reading.gd)
				continue ;;
		esac
		# D-269: the Foundation G4 run-level coordinator asks this curve for the
		# current level's requirement, so it names both classes. Granted in the
		# verification's own per-file allowlist; nothing that runs calls it.
		case "$hit" in
			*/scripts/levels/rift_run_level_coordinator.gd)
				continue ;;
		esac
		# D-288: the Roguelite Experience Collection Greybox Review asks this curve
		# for the current level's requirement to display it, so it names both
		# classes. Granted in the verification's own per-file allowlist.
		case "$hit" in
			*/scripts/roguelite/experience/roguelite_experience_collection_review.gd)
				continue ;;
		esac
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
	pass "nothing under scripts/, scenes/, data/ or addons/ but the G4 run coordinator and the experience collection review, and nothing in project.godot, names a Foundation G1 class"
fi

# --------------------------------------------------------------------------
step "4. The new directory holds exactly what it should"
# A scratch probe left behind is a project file nobody meant to ship, and it
# would be invisible to every scan above that filters on a known path.
unexpected=0
while IFS= read -r entry; do
	case "$(basename "$entry")" in
		rift_level_requirement_curve.gd|rift_level_requirement_curve.gd.uid| \
		rift_level_requirement_reading.gd|rift_level_requirement_reading.gd.uid)
			continue ;;
	esac
	fail "scripts/level_requirements/ holds the unexpected file $(basename "$entry")"
	unexpected=$((unexpected + 1))
done < <(find "$PROJECT_DIR/scripts/level_requirements" -type f 2>/dev/null)
gd_count="$(find "$PROJECT_DIR/scripts/level_requirements" -type f -name '*.gd' 2>/dev/null | wc -l | tr -d ' ')"
if [[ "$gd_count" != "2" ]]; then
	fail "scripts/level_requirements/ holds $gd_count scripts, not 2"
elif [[ "$unexpected" == "0" ]]; then
	pass "scripts/level_requirements/ holds exactly the two scripts and their two uid files"
fi

# --------------------------------------------------------------------------
step "5. project.godot gained nothing"
settings=0
if grep -q '\[autoload\]' "$PROJECT_DIR/project.godot"; then
	fail "project.godot declares an [autoload] section"
	settings=$((settings + 1))
fi
if ! grep -q 'run/main_scene="res://scenes/app/prototype_app.tscn"' "$PROJECT_DIR/project.godot"; then
	fail "the project entrypoint is not the Prototype App"
	settings=$((settings + 1))
fi
if [[ "$settings" == "0" ]]; then
	pass "no autoload, and the entrypoint is still the Prototype App"
fi

# --------------------------------------------------------------------------
step "6. Nothing that already existed changed"
index=0
moved=0
for file in "${PRESERVED_FILES[@]}"; do
	after="$(fingerprint "$PROJECT_DIR/$file")"
	if [[ "$after" == "MISSING" ]]; then
		fail "$file is missing, so its fingerprint proves nothing"
		moved=$((moved + 1))
	elif [[ "$after" != "${before_prints[$index]}" ]]; then
		fail "$file changed during this run"
		moved=$((moved + 1))
	fi
	index=$((index + 1))
done
if [[ "$moved" == "0" ]]; then
	pass "${#PRESERVED_FILES[@]} protected files are present and byte-identical before and after"
fi

# --------------------------------------------------------------------------
printf '\n'
if [[ "$failures" == "0" ]]; then
	printf 'RIFT LEVEL REQUIREMENT CURVE SMOKE CHECKS: PASS\n'
	printf '  %s checks; %s of %s owed; %s protected files byte-identical\n' \
		"$EXPECTED_CHECKS" "$EXPECTED_OWED_CHECKS" "$EXPECTED_OWED_CHECKS" "${#PRESERVED_FILES[@]}"
	printf '  Roguelite Foundation G1 — Deterministic Greybox Level-Requirement Curve —\n'
	printf '  is DELIVERED under D-262, CORRECTED under D-263, and ACCEPTED and CLOSED\n'
	printf '  at the deterministic greybox level-requirement mechanism level under D-264.\n'
	reached_end=1
	exit 0
else
	printf 'RIFT LEVEL REQUIREMENT CURVE SMOKE CHECKS: %d FAILURE(S)\n' "$failures"
	reached_end=1
	exit 1
fi
