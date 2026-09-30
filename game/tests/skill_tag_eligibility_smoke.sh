#!/usr/bin/env bash
# Riftwrought — Roguelite Foundation A smoke checks: Skill Tags and Support
# Eligibility (decision D-224).
#
# THIS IS NOT A GATE, AND IT DELIBERATELY RUNS NO LOCKED CHAIN.
#
# The foundation is four pure-logic scripts under `scripts/skills/` plus this
# suite. It adds no scene, no resource, no asset, no InputMap action and no
# entrypoint change; it writes nothing to disk; and NO SCRIPT THAT RUNS
# REFERENCES IT — the verification proves that by scanning every project file,
# which is the strongest available statement that Build Variety V1 and every
# accepted review behave exactly as before. Rerunning Gates A-F, 1A-1E, the Zone
# Composer or the three roguelite reviews to check an inert query would be
# verification theatre over work that cannot have reached them.
#
# What this script proves:
#
#   1. every new script parses;
#   2. the pinned verification passes, proved in BOTH directions against a
#      replay of its own log, with every owed check reaching its last line;
#   3. the foundation names no storage path and no writer;
#   4. the nine files it could conceivably have disturbed are BYTE-IDENTICAL
#      ACROSS THE RUN, including `project.godot`, the canonical Quick Strike
#      record, the Gate 1E Skill records and the Build Variety upgrade record.
#      `first_mvp_skill_data.gd` gained one constant under D-225 — the canonical
#      tag owner accepting `Strike` — which is referenced by nothing in Gate 1E
#      and moves no displayed tag line; it is still fingerprinted here so THIS
#      run cannot disturb it.
#
# Usage, from the repository root:
#   game/tests/skill_tag_eligibility_smoke.sh

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
		printf '\nSKILL TAG ELIGIBILITY SMOKE CHECKS: ABORTED before the end of the script\n'
		printf '  the run stopped early (exit %s) — nothing after that point was proved\n' "$status"
		exit 1
	fi
	exit "$status"
}
trap on_exit EXIT

GODOT="${GODOT:-/Applications/Godot.app/Contents/MacOS/Godot}"
EXPECTED_VERSION="4.7.2.stable"
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

VERIFICATION="res://tests/skill_tag_eligibility_verification.gd"

# Pinned, and proved in both directions below.
EXPECTED_CHECKS=165

# The number of check FUNCTIONS the suite owes, separate from the number of
# assertions. Pinned as a variable rather than written into the grep, because
# hard-coding it into the pattern goes stale the moment a check is added —
# reporting a failure whose text is the correct answer.
EXPECTED_OWED_CHECKS=12

NEW_SCRIPTS=(
	"scripts/skills/skill_tags.gd"
	"scripts/skills/skill_tag_profile.gd"
	"scripts/skills/support_eligibility.gd"
	"scripts/skills/skill_support_catalogue.gd"
	"tests/skill_tag_eligibility_verification.gd"
)

# The four files the foundation itself owns. None may name a storage path.
FOUNDATION_SCRIPTS=(
	"scripts/skills/skill_tags.gd"
	"scripts/skills/skill_tag_profile.gd"
	"scripts/skills/support_eligibility.gd"
	"scripts/skills/skill_support_catalogue.gd"
)

# DELIBERATELY SHORT, AND NOT A WHOLE-PROJECT CATALOGUE. These are the files
# this work could conceivably have disturbed: the project settings, the
# canonical combat record and its class, the Gate 1E Skill contract and library
# the foundation READS, the three shipped Skill records it scans, and the Build
# Variety upgrade record whose two support names it pins.
PRESERVED_FILES=(
	"project.godot"
	"data/prototype_zero/quick_strike.tres"
	"scripts/combat/quick_strike_data.gd"
	"scripts/skills/first_mvp_skill_data.gd"
	"scripts/skills/first_mvp_skill_library.gd"
	"scripts/roguelite/build_variety/roguelite_upgrade.gd"
	"data/first_mvp/skills/faultbreaker.tres"
	"data/first_mvp/skills/splinter_shot.tres"
	"data/first_mvp/skills/emberbolt.tres"
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
	found="$(grep -c "SCRIPT ERROR" "$logfile" 2>/dev/null | tr -d ' ')"
	if [[ "$found" == "0" ]]; then
		pass "$what produced no SCRIPT ERROR"
	else
		fail "$what produced $found SCRIPT ERROR line(s)"
		grep -A3 "SCRIPT ERROR" "$logfile" | head -20 | sed 's/^/        /'
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

printf 'Riftwrought — Roguelite Foundation A: Skill Tags and Support Eligibility (D-224)\n'
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
verify_log="/tmp/riftwrought_skill_tag_eligibility_verify.log"
"$GODOT" --headless --path "$PROJECT_DIR" --script "$VERIFICATION" > "$verify_log" 2>&1
verify_status=$?
assert_log_is_fresh "$verify_log"
assert_no_script_error "the headless foundation verification" "$verify_log"

if [[ "$verify_status" == "0" ]]; then
	pass "the verification exited 0"
else
	fail "the verification exited $verify_status"
	grep -E "^  FAIL" "$verify_log" | head -20 | sed 's/^/        /'
fi

count="$(read_check_count "SKILL TAG ELIGIBILITY VERIFICATION" "$verify_log")"
if [[ "$count" == "$EXPECTED_CHECKS" ]]; then
	pass "verification passes at the pinned $EXPECTED_CHECKS checks"
else
	fail "verification reports ${count:-no} checks, not $EXPECTED_CHECKS"
fi

# A guard that accepts everything protects nothing: the pin must refuse a log
# whose count moved by one.
replay="$(mktemp -t riftwrought_skill_tag_replay)"
scratch_replay="$replay"
sed "s/SKILL TAG ELIGIBILITY VERIFICATION: PASS ($EXPECTED_CHECKS checks)/SKILL TAG ELIGIBILITY VERIFICATION: PASS ($((EXPECTED_CHECKS + 1)) checks)/" \
	"$verify_log" > "$replay"
if [[ "$(read_check_count "SKILL TAG ELIGIBILITY VERIFICATION" "$replay")" != "$EXPECTED_CHECKS" ]]; then
	pass "and that pin refuses a log whose count moved by one"
else
	fail "the count pin accepts a wrong count and therefore proves nothing"
fi

if grep -qE "^  $EXPECTED_OWED_CHECKS of $EXPECTED_OWED_CHECKS owed checks completed" "$verify_log"; then
	pass "all $EXPECTED_OWED_CHECKS owed checks reached their last line"
else
	fail "the owed-set report is missing or short"
	grep -E "owed checks" "$verify_log" | sed 's/^/        /'
fi

# The four answers this foundation exists to give, read out of the run's own log
# rather than restated here.
for line in \
	"tags recognised, all canonical" \
	"quick_strike -> ELIGIBLE; recorded-tags-only" \
	"quick_strike -> ELIGIBLE (Melee + Strike); faultbreaker -> requires Strike" \
	"generic required-any rule: Strike branch -> ELIGIBLE; Area branch -> ELIGIBLE" \
	"refused by both; the same set without Projectile -> accepted by both" \
	"unrecognised required -> denies; unrecognised on the Skill -> inert"
do
	if grep -qF "$line" "$verify_log"; then
		pass "measured: ${line}"
	else
		fail "the verification log does not report: ${line}"
	fi
done

# --------------------------------------------------------------------------
step "3. The foundation stores nothing"
stored=0
for script in "${FOUNDATION_SCRIPTS[@]}"; do
	if grep -qE 'user://|ConfigFile|ResourceSaver|FileAccess' "$PROJECT_DIR/$script"; then
		fail "$script names a storage path or a writer"
		stored=$((stored + 1))
	fi
done
if [[ "$stored" == "0" ]]; then
	pass "none of the ${#FOUNDATION_SCRIPTS[@]} foundation scripts names a storage path or a writer"
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
	printf 'SKILL TAG ELIGIBILITY SMOKE CHECKS: PASS\n'
	printf '  %s checks; %s of %s owed; %s protected files byte-identical\n' \
		"$EXPECTED_CHECKS" "$EXPECTED_OWED_CHECKS" "$EXPECTED_OWED_CHECKS" "${#PRESERVED_FILES[@]}"
	printf '  Roguelite Foundation A is DELIVERED under D-224, CORRECTED under D-225, and\n'
	printf '  ACCEPTED and CLOSED at the technical-foundation level under D-226.\n'
	reached_end=1
	exit 0
else
	printf 'SKILL TAG ELIGIBILITY SMOKE CHECKS: %d FAILURE(S)\n' "$failures"
	reached_end=1
	exit 1
fi
