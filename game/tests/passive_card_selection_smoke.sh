#!/usr/bin/env bash
# Riftwrought — Roguelite Foundation C3 smoke checks: Deterministic Passive Card
# Selection (decision D-234).
#
# THIS IS NOT A GATE, AND IT DELIBERATELY RUNS NO LOCKED CHAIN.
#
# The foundation is two pure-logic scripts under `scripts/stats/` plus this
# suite. It adds no scene, no resource, no asset, no InputMap action and no
# entrypoint change; it writes nothing to disk; it changes no gameplay value;
# and NOTHING THAT RUNS CALLS IT — there is no offer, no acquisition and no
# runtime application, and the verification proves that by scanning every
# project file under `scripts/`, `scenes/` and `data/` and requiring that not
# one of them names either new class. Rerunning Gates A-F, 1A-1E, the Zone
# Composer, the three roguelite reviews or Foundations A, B, C1 or C2 to check
# an unwired selector would be verification theatre over work that cannot have
# reached them.
#
# IT DOES NOT RERUN FOUNDATION C1 OR C2. Each owns its own count and is rerun by
# its own runner. C3 is authorized to READ C1's vocabulary and C2's records,
# which is why each of those suites' scope assertions was moved one for one to
# allow exactly these two files — changes proved separately, and at their
# unchanged pinned 256 and 180.
#
# What this script proves:
#
#   1. every new script parses;
#   2. the pinned verification passes, proved in BOTH directions against a
#      replay of its own log, with every owed check reaching its last line;
#   3. the two scripts name no concrete class, no catalogue and no presentation
#      name, read no storage, no random source and no ambient engine state, and
#      reach no part of the vocabulary's calculation — and nothing else in the
#      project names either of them; checked in the shell as well as in the
#      engine, because a scan that only ever runs inside the thing it audits is
#      one process away from proving nothing;
#   4. the seven files it could conceivably have disturbed are BYTE-IDENTICAL
#      ACROSS THE RUN — `project.godot`, the four scripts of the accepted
#      Foundation C1 vocabulary and the two accepted Foundation C2 records this
#      selector reads.
#
# Usage, from the repository root:
#   game/tests/passive_card_selection_smoke.sh

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
		printf '\nPASSIVE CARD SELECTION SMOKE CHECKS: ABORTED before the end of the script\n'
		printf '  the run stopped early (exit %s) — nothing after that point was proved\n' "$status"
		exit 1
	fi
	exit "$status"
}
trap on_exit EXIT

GODOT="${GODOT:-/Applications/Godot.app/Contents/MacOS/Godot}"
EXPECTED_VERSION="4.7.2.stable"
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

VERIFICATION="res://tests/passive_card_selection_verification.gd"

# Pinned, and proved in both directions below.
EXPECTED_CHECKS=299

# The number of check FUNCTIONS the suite owes, separate from the number of
# assertions. Pinned as a variable rather than written into the grep, because
# hard-coding it into the pattern goes stale the moment a check is added —
# reporting a failure whose text is the correct answer.
EXPECTED_OWED_CHECKS=9

NEW_SCRIPTS=(
	"scripts/stats/passive_card_selection.gd"
	"scripts/stats/passive_card_selection_result.gd"
	"tests/passive_card_selection_verification.gd"
)

# The two files the foundation itself owns. Neither may name a concrete class,
# a card, the catalogue or a presentation name; neither may store, randomise or
# read ambient state; and neither may reach the vocabulary's calculation — this
# is a SELECTOR, and a selector that applied what it drew would be a runtime.
SELECTION_SCRIPTS=(
	"scripts/stats/passive_card_selection.gd"
	"scripts/stats/passive_card_selection_result.gd"
)

# The two global class names this foundation introduces. Nothing that runs may
# name either.
SELECTION_CLASSES=(
	"PassiveCardSelection"
	"PassiveCardSelectionResult"
)

# DELIBERATELY SHORT, AND NOT A WHOLE-PROJECT CATALOGUE. These are the files
# this work could conceivably have disturbed: the project settings, the four
# scripts of the accepted Foundation C1 vocabulary, and the two accepted
# Foundation C2 records. C3 must read them and must not edit them.
PRESERVED_FILES=(
	"project.godot"
	"scripts/stats/player_stat_definition.gd"
	"scripts/stats/player_stat_value.gd"
	"scripts/stats/player_stats.gd"
	"scripts/stats/player_stat_totals.gd"
	"scripts/stats/passive_card_definition.gd"
	"scripts/stats/passive_card_catalogue.gd"
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

printf 'Riftwrought — Roguelite Foundation C3: Passive Card Selection (D-234)\n'
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
verify_log="/tmp/riftwrought_passive_card_selection_verify.log"
"$GODOT" --headless --path "$PROJECT_DIR" --script "$VERIFICATION" > "$verify_log" 2>&1
verify_status=$?
assert_log_is_fresh "$verify_log"
assert_no_script_error "the headless passive card selection verification" "$verify_log"

if [[ "$verify_status" == "0" ]]; then
	pass "the verification exited 0"
else
	fail "the verification exited $verify_status"
	grep -E "^  FAIL" "$verify_log" | head -20 | sed 's/^/        /'
fi

count="$(read_check_count "PASSIVE CARD SELECTION VERIFICATION" "$verify_log")"
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
replay="$(mktemp -t riftwrought_passive_card_selection_replay)"
scratch_replay="$replay"
sed "s/PASSIVE CARD SELECTION VERIFICATION: PASS ($EXPECTED_CHECKS checks)/PASSIVE CARD SELECTION VERIFICATION: PASS ($((EXPECTED_CHECKS + 1)) checks)/" \
	"$verify_log" > "$replay"
replay_count="$(read_check_count "PASSIVE CARD SELECTION VERIFICATION" "$replay")"
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
Combat and Defence [card_celerity, card_power, card_vitality] / Utility [card_fleetness, card_insight, card_magnetism]; 0 shared, 0 uncovered
Combat and Defence: card_celerity=100, card_power=100, card_vitality=100 | Utility: card_fleetness=100, card_insight=100, card_magnetism=100
0/99 -> first, 100/199 -> second, 200/299 -> third in both pools; 300 -> 0, 599 -> 299, 2147483647 -> 247; 5 negatives refused, 0 seeded negatives
ownership 4 / 6 / 5; a 1000-weight card in the other lane contributes 0
1800 draws over 3 permutations and 38 seeded draws are bit-identical to the canonical order
1200 draws over a fully renamed set and a name-swapped set are bit-identical; neither script names display_name
24 refusals, each naming its fault and carrying no partial result; a fault in the OTHER lane still refuses the whole selection
19 corpus rows exact over 2 categories; 6 of 6 cards reached; 100 of 100 repeats agree; one shared ticket matches ordinals 512 of 512, the salted streams 168 of 512
0 forbidden tokens, 0 ambient reads; 14 methods and 8 fields pinned, 0 selector state
0 of 100 identical draws disagree
MEASURED

# --------------------------------------------------------------------------
step "3. The selector names nothing concrete, reads nothing ambient, applies nothing"
ambient=0
for script in "${SELECTION_SCRIPTS[@]}"; do
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
	if grep -qE 'QuickStrike|PrototypePlayer|PassiveEffects|RogueliteUpgrade|SkillTags|FirstMvpSkill|Graveblade' "$PROJECT_DIR/$script"; then
		fail "$script names a concrete class"
		ambient=$((ambient + 1))
	fi
	# A selector is handed the records it works on. Naming the shipped catalogue
	# would make a generic mechanism the shipped six's own.
	if grep -qE 'PassiveCardCatalogue|card_power|card_celerity|card_vitality|card_fleetness|card_insight|card_magnetism' "$PROJECT_DIR/$script"; then
		fail "$script names the catalogue or one of its cards"
		ambient=$((ambient + 1))
	fi
	# Renaming a card must never be a balance change, and the only arrangement in
	# which that is true is one where the mechanism cannot see the copy at all.
	if grep -q 'display_name' "$PROJECT_DIR/$script"; then
		fail "$script reads a presentation name"
		ambient=$((ambient + 1))
	fi
	# It selects a card. It never accumulates a modifier and never applies one —
	# that is the vocabulary's calculation and a later decision's runtime.
	if grep -qE 'PlayerStatValue|PlayerStatTotals|PlayerStats\.apply' "$PROJECT_DIR/$script"; then
		fail "$script reaches the vocabulary's calculation"
		ambient=$((ambient + 1))
	fi
done
if [[ "$ambient" == "0" ]]; then
	pass "neither of the ${#SELECTION_SCRIPTS[@]} scripts stores, randomises, reads ambient state, names a class or card, reads a name or applies a modifier"
fi

# NOTHING THAT RUNS CALLS IT, measured a second time from outside the engine.
#
# IT ASSERTS A FLOOR ON WHAT IT SEARCHED, WHICH IS THE WHOLE DIFFERENCE BETWEEN
# this and a scan that proves nothing. `grep -rl` over a directory that does not
# exist — a renamed tree, a PROJECT_DIR resolved one level high — returns nothing
# and looks exactly like a clean result. The engine-side twin already requires
# that it saw more than a hundred files; without the same floor here, the shell
# half could report PASS having read no project file at all.
searched="$(find "$PROJECT_DIR/scripts" "$PROJECT_DIR/scenes" "$PROJECT_DIR/data" \
	"$PROJECT_DIR/addons" -type f \( -name '*.gd' -o -name '*.tscn' -o -name '*.tres' \) \
	2>/dev/null | wc -l | tr -d ' ')"
if [[ "${searched:-0}" -gt 100 ]]; then
	pass "the shell-side scan read $searched project files"
else
	fail "the shell-side scan found only ${searched:-0} project files, so it proves nothing"
fi

referenced=0
for name in "${SELECTION_CLASSES[@]}"; do
	while IFS= read -r hit; do
		case "$hit" in
			*/scripts/stats/passive_card_selection.gd|*/scripts/stats/passive_card_selection_result.gd)
				continue ;;
			# D-239: the Foundation D1 composer delegates both passive lanes to
			# this selector and its offer holds the results, so both are
			# authorized readers here exactly as they are in the engine-side scan
			# above. Added one for one; no assertion moved.
			*/scripts/offers/rift_offer_composition.gd|*/scripts/offers/rift_offer.gd)
				continue ;;
			# D-304: the Roguelite Foundation I6 exhausted-support fallback and its
			# result, granted exactly as in the engine-side scan. Added one for
			# one; no assertion moved.
			*/scripts/fallback/support_exhaustion_passive_fallback.gd|*/scripts/fallback/support_exhaustion_passive_fallback_result.gd)
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
	pass "nothing under scripts/, scenes/, data/ or addons/ and nothing in project.godot names either Foundation C3 class"
fi

# --------------------------------------------------------------------------
step "4. Nothing that already existed changed"
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
	printf 'PASSIVE CARD SELECTION SMOKE CHECKS: PASS\n'
	printf '  %s checks; %s of %s owed; %s protected files byte-identical\n' \
		"$EXPECTED_CHECKS" "$EXPECTED_OWED_CHECKS" "$EXPECTED_OWED_CHECKS" "${#PRESERVED_FILES[@]}"
	printf '  Roguelite Foundation C3 is DELIVERED under D-234 and ACCEPTED at the\n'
	printf '  deterministic passive-selection mechanism level under D-235.\n'
	reached_end=1
	exit 0
else
	printf 'PASSIVE CARD SELECTION SMOKE CHECKS: %d FAILURE(S)\n' "$failures"
	reached_end=1
	exit 1
fi
