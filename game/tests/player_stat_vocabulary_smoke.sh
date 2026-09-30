#!/usr/bin/env bash
# Riftwrought — Roguelite Foundation C1 smoke checks: Core Passive Stat
# Vocabulary (decision D-229).
#
# THIS IS NOT A GATE, AND IT DELIBERATELY RUNS NO LOCKED CHAIN.
#
# The foundation is four pure-logic scripts under `scripts/stats/` plus this
# suite. It adds no scene, no resource, no asset, no InputMap action and no
# entrypoint change; it writes nothing to disk; it changes no gameplay value;
# and NOTHING THAT RUNS CALLS IT — the verification proves that by scanning
# every project file under `scripts/`, `scenes/` and `data/` and requiring that
# none of them names any of the four new classes — except for the readers named
# in the verification's own per-file, per-class allowlist, each of which is
# granted exactly the classes written beside its own path and no others, so a
# file listed for one class is still refused for another. THAT ALLOWLIST IS THE
# AUTHORITY on which files may reference this vocabulary and on what each of
# them may name, and it is deliberately not summarised here: a reader count
# repeated in a comment goes stale the moment a foundation is granted a row, and
# this one had already been wrong for three of them before it was corrected.
# Rerunning Gates A-F, 1A-1E,
# the Zone Composer, the three roguelite reviews or either earlier foundation to
# check an unwired vocabulary would be verification theatre over work that
# cannot have reached them.
#
# IT ALSO DOES NOT RERUN FOUNDATION A OR FOUNDATION B. Those suites own their
# own counts and are untouched by this work — C1 shares no file with either and
# names neither. What this script does instead is FINGERPRINT the nine existing
# files whose stat concepts C1 names, so this run cannot disturb them.
#
# What this script proves:
#
#   1. every new script parses;
#   2. the pinned verification passes, proved in BOTH directions against a
#      replay of its own log, with every owed check reaching its last line;
#   3. the four new scripts name no concrete class, Skill, support or card, and
#      read no storage, no random source and no ambient engine state — checked
#      in the shell as well as in the engine, because a scan that only ever runs
#      inside the thing it audits is one process away from proving nothing;
#   4. the nine files it could conceivably have disturbed are BYTE-IDENTICAL
#      ACROSS THE RUN — `project.godot`, the canonical Quick Strike record, and
#      the seven scripts that own the five existing base values and the one
#      existing increase this vocabulary reconciles with.
#
# Usage, from the repository root:
#   game/tests/player_stat_vocabulary_smoke.sh

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
		printf '\nPLAYER STAT VOCABULARY SMOKE CHECKS: ABORTED before the end of the script\n'
		printf '  the run stopped early (exit %s) — nothing after that point was proved\n' "$status"
		exit 1
	fi
	exit "$status"
}
trap on_exit EXIT

GODOT="${GODOT:-/Applications/Godot.app/Contents/MacOS/Godot}"
EXPECTED_VERSION="4.7.2.stable"
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

VERIFICATION="res://tests/player_stat_vocabulary_verification.gd"

# Pinned, and proved in both directions below.
EXPECTED_CHECKS=256

# The number of check FUNCTIONS the suite owes, separate from the number of
# assertions. Pinned as a variable rather than written into the grep, because
# hard-coding it into the pattern goes stale the moment a check is added —
# reporting a failure whose text is the correct answer.
EXPECTED_OWED_CHECKS=9

NEW_SCRIPTS=(
	"scripts/stats/player_stat_definition.gd"
	"scripts/stats/player_stat_value.gd"
	"scripts/stats/player_stats.gd"
	"scripts/stats/player_stat_totals.gd"
	"tests/player_stat_vocabulary_verification.gd"
)

# The four files the foundation itself owns. None may name a concrete class,
# Skill, support or card, and none may store, randomise or read ambient state.
FOUNDATION_SCRIPTS=(
	"scripts/stats/player_stat_definition.gd"
	"scripts/stats/player_stat_value.gd"
	"scripts/stats/player_stats.gd"
	"scripts/stats/player_stat_totals.gd"
)

# DELIBERATELY SHORT, AND NOT A WHOLE-PROJECT CATALOGUE. These are the files
# this work could conceivably have disturbed: the project settings, the
# canonical combat record the suite reads its accepted action time from, and the
# seven scripts that own the five existing base values (`physical_damage`,
# `action_time`, `max_life` / `max_speed`, `total_experience`,
# `interaction_range`) and the one existing increase
# (`increased_attack_speed`, aggregated as `increased_attack_and_cast_speed`)
# that this vocabulary names. C1 must reconcile with them and must not edit
# them.
PRESERVED_FILES=(
	"project.godot"
	"data/prototype_zero/quick_strike.tres"
	"scripts/combat/quick_strike_data.gd"
	"scripts/combat/prototype_weapon_data.gd"
	"scripts/actors/prototype_player.gd"
	"scripts/passives/passive_effects.gd"
	"scripts/character/character_state.gd"
	"scripts/character/experience_table.gd"
	"scripts/items/first_mvp_item_drop.gd"
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

printf 'Riftwrought — Roguelite Foundation C1: Core Passive Stat Vocabulary (D-229)\n'
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
verify_log="/tmp/riftwrought_player_stat_vocabulary_verify.log"
"$GODOT" --headless --path "$PROJECT_DIR" --script "$VERIFICATION" > "$verify_log" 2>&1
verify_status=$?
assert_log_is_fresh "$verify_log"
assert_no_script_error "the headless vocabulary verification" "$verify_log"

if [[ "$verify_status" == "0" ]]; then
	pass "the verification exited 0"
else
	fail "the verification exited $verify_status"
	grep -E "^  FAIL" "$verify_log" | head -20 | sed 's/^/        /'
fi

count="$(read_check_count "PLAYER STAT VOCABULARY VERIFICATION" "$verify_log")"
if [[ "$count" == "$EXPECTED_CHECKS" ]]; then
	pass "verification passes at the pinned $EXPECTED_CHECKS checks"
else
	fail "verification reports ${count:-no} checks, not $EXPECTED_CHECKS"
fi

# A guard that accepts everything protects nothing: the pin must refuse a log
# whose count moved by one.
replay="$(mktemp -t riftwrought_player_stat_vocabulary_replay)"
scratch_replay="$replay"
sed "s/PLAYER STAT VOCABULARY VERIFICATION: PASS ($EXPECTED_CHECKS checks)/PLAYER STAT VOCABULARY VERIFICATION: PASS ($((EXPECTED_CHECKS + 1)) checks)/" \
	"$verify_log" > "$replay"
if [[ "$(read_check_count "PLAYER STAT VOCABULARY VERIFICATION" "$replay")" != "$EXPECTED_CHECKS" ]]; then
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

# The measurements this foundation exists to make, read out of the run's own log
# rather than restated here.
while IFS= read -r line; do
	if grep -qF "$line" "$verify_log"; then
		pass "measured: ${line}"
	else
		fail "the verification log does not report: ${line}"
	fi
done <<'MEASURED'
6 stats: 3 combat and defence, 3 utility; 1 rate, 5 multiplied; 6 distinct units
+10% and +20% -> total 0.30, scale 1.30, 100 -> 130.00 (compounding would give 132.00)
canonical example: +80% and -20% -> 1.60x -> 160.00
0.80 s at +25% -> 0.6400 s; swept 1200 totals from -0.999 upward, 0 non-positive
2.20 m at +100% -> 4.40 m (an AREA modifier would give 3.111 m); ground x4.00
6 orderings of 0.1/0.2/0.3 are bit-identical while the naive sums differ; 3 duplicates total 0.30
all refused with a reason and no partial value
0 forbidden tokens, 0 ambient reads
only authorized readers name an authorized Foundation C1 class; 31 actions
MEASURED

# --------------------------------------------------------------------------
step "3. The vocabulary names nothing concrete and reads nothing ambient"
ambient=0
for script in "${FOUNDATION_SCRIPTS[@]}"; do
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
done
if [[ "$ambient" == "0" ]]; then
	pass "none of the ${#FOUNDATION_SCRIPTS[@]} scripts stores, randomises, reads ambient state or names a class"
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
	printf 'PLAYER STAT VOCABULARY SMOKE CHECKS: PASS\n'
	printf '  %s checks; %s of %s owed; %s protected files byte-identical\n' \
		"$EXPECTED_CHECKS" "$EXPECTED_OWED_CHECKS" "$EXPECTED_OWED_CHECKS" "${#PRESERVED_FILES[@]}"
	printf '  Roguelite Foundation C1 is DELIVERED under D-229 and ACCEPTED under D-230.\n'
	reached_end=1
	exit 0
else
	printf 'PLAYER STAT VOCABULARY SMOKE CHECKS: %d FAILURE(S)\n' "$failures"
	reached_end=1
	exit 1
fi
