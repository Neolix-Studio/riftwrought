#!/usr/bin/env bash
# Riftwrought — Roguelite Foundation C2 smoke checks: Passive Card Records
# (decision D-231).
#
# THIS IS NOT A GATE, AND IT DELIBERATELY RUNS NO LOCKED CHAIN.
#
# The foundation is two pure-logic scripts under `scripts/stats/` plus this
# suite. It adds no scene, no resource, no asset, no InputMap action and no
# entrypoint change; it writes nothing to disk; it changes no gameplay value;
# and NOTHING THAT RUNS CALLS IT — there is no selector, no offer generator and
# no runtime application, and the verification proves that by scanning every
# project file under `scripts/`, `scenes/` and `data/` and requiring that not
# one of them names either new class. Rerunning Gates A-F, 1A-1E, the Zone
# Composer, the three roguelite reviews or Foundation A or B to check an unwired
# set of records would be verification theatre over work that cannot have
# reached them.
#
# IT ALSO DOES NOT RERUN FOUNDATION C1. That suite owns its own count and is
# rerun by its own runner; C2 is authorized to READ C1's vocabulary, which is
# why C1's own scope assertion was moved one for one to allow exactly these two
# files — a change proved separately, and at C1's unchanged pinned 256.
#
# What this script proves:
#
#   1. every new script parses;
#   2. the pinned verification passes, proved in BOTH directions against a
#      replay of its own log, with every owed check reaching its last line;
#   3. the two records name no concrete class, Skill, support or card, read no
#      storage, no random source and no ambient engine state, and reach no part
#      of the calculation — checked in the shell as well as in the engine,
#      because a scan that only ever runs inside the thing it audits is one
#      process away from proving nothing;
#   4. the five files it could conceivably have disturbed are BYTE-IDENTICAL
#      ACROSS THE RUN — `project.godot` and the four scripts of the accepted
#      Foundation C1 vocabulary these records derive from.
#
# Usage, from the repository root:
#   game/tests/passive_card_records_smoke.sh

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
		printf '\nPASSIVE CARD RECORDS SMOKE CHECKS: ABORTED before the end of the script\n'
		printf '  the run stopped early (exit %s) — nothing after that point was proved\n' "$status"
		exit 1
	fi
	exit "$status"
}
trap on_exit EXIT

GODOT="${GODOT:-/Applications/Godot.app/Contents/MacOS/Godot}"
EXPECTED_VERSION="4.7.2.stable"
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

VERIFICATION="res://tests/passive_card_records_verification.gd"

# Pinned, and proved in both directions below.
EXPECTED_CHECKS=180

# The number of check FUNCTIONS the suite owes, separate from the number of
# assertions. Pinned as a variable rather than written into the grep, because
# hard-coding it into the pattern goes stale the moment a check is added —
# reporting a failure whose text is the correct answer.
EXPECTED_OWED_CHECKS=8

NEW_SCRIPTS=(
	"scripts/stats/passive_card_definition.gd"
	"scripts/stats/passive_card_catalogue.gd"
	"tests/passive_card_records_verification.gd"
)

# The two files the foundation itself owns. Neither may name a concrete class,
# Skill, support or card, neither may store, randomise or read ambient state,
# and neither may reach the vocabulary's calculation: these are RECORDS, and a
# record that applied itself would be a runtime.
RECORD_SCRIPTS=(
	"scripts/stats/passive_card_definition.gd"
	"scripts/stats/passive_card_catalogue.gd"
)

# DELIBERATELY SHORT, AND NOT A WHOLE-PROJECT CATALOGUE. These are the files
# this work could conceivably have disturbed: the project settings, and the four
# scripts of the accepted Foundation C1 vocabulary whose stat ids, categories,
# modes and units these records DERIVE from. C2 must read them and must not
# edit them.
PRESERVED_FILES=(
	"project.godot"
	"scripts/stats/player_stat_definition.gd"
	"scripts/stats/player_stat_value.gd"
	"scripts/stats/player_stats.gd"
	"scripts/stats/player_stat_totals.gd"
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

printf 'Riftwrought — Roguelite Foundation C2: Passive Card Records (D-231)\n'
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
verify_log="/tmp/riftwrought_passive_card_records_verify.log"
"$GODOT" --headless --path "$PROJECT_DIR" --script "$VERIFICATION" > "$verify_log" 2>&1
verify_status=$?
assert_log_is_fresh "$verify_log"
assert_no_script_error "the headless passive card verification" "$verify_log"

if [[ "$verify_status" == "0" ]]; then
	pass "the verification exited 0"
else
	fail "the verification exited $verify_status"
	grep -E "^  FAIL" "$verify_log" | head -20 | sed 's/^/        /'
fi

count="$(read_check_count "PASSIVE CARD RECORDS VERIFICATION" "$verify_log")"
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
replay="$(mktemp -t riftwrought_passive_card_records_replay)"
scratch_replay="$replay"
sed "s/PASSIVE CARD RECORDS VERIFICATION: PASS ($EXPECTED_CHECKS checks)/PASSIVE CARD RECORDS VERIFICATION: PASS ($((EXPECTED_CHECKS + 1)) checks)/" \
	"$verify_log" > "$replay"
replay_count="$(read_check_count "PASSIVE CARD RECORDS VERIFICATION" "$replay")"
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
6 review cards over 6 distinct stats; every id differs from its own name
0 of 10 restated members appear in the 2 records, 10 appear in the vocabulary; the 6 authored fields are exactly the six
+10% Global Damage / +10% Skill Speed / +15% Maximum Life / +10% Movement Speed / +10% Experience Gain / +25% Pickup Radius
6 of 6 weights are 100; 1 distinct weight
6 of 6 review passives are repeatable
invalid records and sets refused, each with a reason that names the fault
6 of 6 shipped ids obey ^[a-z][a-z0-9_]*$; 11 id cases agree with the pattern; a spaced id is refused
0 forbidden tokens, 0 ambient reads, 0 calculation reaches
only authorized readers name a Foundation C2 class; 0 of 100 identical reads disagree
MEASURED

# --------------------------------------------------------------------------
step "3. The records name nothing concrete, read nothing ambient, apply nothing"
ambient=0
for script in "${RECORD_SCRIPTS[@]}"; do
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
	# A record describes a card. It never accumulates a modifier and never
	# applies one — that is the vocabulary's calculation and a later decision's
	# runtime.
	if grep -qE 'PlayerStatValue|PlayerStatTotals|PlayerStats\.apply' "$PROJECT_DIR/$script"; then
		fail "$script reaches the vocabulary's calculation"
		ambient=$((ambient + 1))
	fi
done
if [[ "$ambient" == "0" ]]; then
	pass "neither of the ${#RECORD_SCRIPTS[@]} records stores, randomises, reads ambient state, names a class or applies a modifier"
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
	printf 'PASSIVE CARD RECORDS SMOKE CHECKS: PASS\n'
	printf '  %s checks; %s of %s owed; %s protected files byte-identical\n' \
		"$EXPECTED_CHECKS" "$EXPECTED_OWED_CHECKS" "$EXPECTED_OWED_CHECKS" "${#PRESERVED_FILES[@]}"
	printf '  Roguelite Foundation C2 is DELIVERED under D-231, CORRECTED under D-232,\n'
	printf '  and ACCEPTED at the record-contract level under D-233.\n'
	reached_end=1
	exit 0
else
	printf 'PASSIVE CARD RECORDS SMOKE CHECKS: %d FAILURE(S)\n' "$failures"
	reached_end=1
	exit 1
fi
