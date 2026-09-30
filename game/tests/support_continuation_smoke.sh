#!/usr/bin/env bash
# Riftwrought — Roguelite Foundation F2 smoke checks: Deterministic
# Support-Lane Continuation Selection (decision D-253).
#
# THIS IS NOT A GATE, AND IT DELIBERATELY RUNS NO LOCKED CHAIN.
#
# The foundation is two pure-logic scripts under `scripts/continuation/` plus
# this suite. It adds no scene, no resource, no asset, no InputMap action and no
# entrypoint change; it writes nothing to disk; and NOTHING THAT RUNS CALLS IT —
# the verification proves that by scanning every project file, and this script
# proves it again in the shell, outside the engine. Rerunning Gates A-F, 1A-1E,
# the Zone Composer or the three roguelite reviews to check an unwired selector
# would be verification theatre over work that cannot have reached them.
#
# IT ALSO DOES NOT RERUN THE ACCEPTED FOUNDATIONS. Those suites own their own
# counts and were run separately against this tree; chaining them here would
# make every future edit to a comment rerun foundations it cannot reach. What
# this script does instead is FINGERPRINT the accepted mechanism scripts across
# its own run, so this run cannot disturb them.
#
# What this script proves:
#
#   1. every new script parses;
#   2. the pinned verification passes, proved in BOTH directions against a
#      replay of its own log, with every owed check reaching its last line;
#   3. the two continuation scripts name nothing concrete, read nothing ambient
#      and call no rank member — checked in the shell as well as in the engine,
#      because a scan that only ever runs inside the thing it audits is one
#      process away from proving nothing;
#   4. `scripts/continuation/` holds exactly the two scripts it should;
#   5. no project file outside the foundation names either new class;
#   6. the files it could conceivably have disturbed are BYTE-IDENTICAL ACROSS
#      THE RUN, including `project.godot`, the canonical Quick Strike record,
#      every accepted foundation mechanism script and the project owner's own
#      composed zone.
#
# Usage, from the repository root:
#   game/tests/support_continuation_smoke.sh

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
		printf '\nSUPPORT CONTINUATION SMOKE CHECKS: ABORTED before the end of the script\n'
		printf '  the run stopped early (exit %s) — nothing after that point was proved\n' "$status"
		exit 1
	fi
	exit "$status"
}
trap on_exit EXIT

GODOT="${GODOT:-/Applications/Godot.app/Contents/MacOS/Godot}"
EXPECTED_VERSION="4.7.2.stable"
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

VERIFICATION="res://tests/support_continuation_verification.gd"

# Pinned, and proved in both directions below. UNCHANGED BY FOUNDATION I5 (D-300):
# checks 4, 9 and 12 moved one for one from the empty-record draw to the accepted
# rank-increase draw, the result record's method and field pins gained I5's two
# methods and one field inside the same two assertions, and two measured lines
# below were retyped to what those checks now print.
EXPECTED_CHECKS=245

# The number of check FUNCTIONS the suite owes, separate from the number of
# assertions. Pinned as a variable rather than written into the grep, because
# hard-coding it into the pattern goes stale the moment a check is added —
# reporting a failure whose text is the correct answer.
EXPECTED_OWED_CHECKS=20

NEW_SCRIPTS=(
	"scripts/continuation/support_continuation_result.gd"
	"scripts/continuation/support_continuation.gd"
	"tests/support_continuation_verification.gd"
)

# The two files the foundation itself owns.
FOUNDATION_SCRIPTS=(
	"scripts/continuation/support_continuation_result.gd"
	"scripts/continuation/support_continuation.gd"
)

# The two global class names F2 introduces. No file outside the foundation may
# name either.
F2_CLASSES=("SupportContinuationResult" "SupportContinuation")

# DELIBERATELY SHORT, AND NOT A WHOLE-PROJECT CATALOGUE. These are the files
# this work could conceivably have disturbed: the project settings, the
# canonical combat record, every accepted foundation mechanism script — two of
# whose SUITES this work edited, so the scripts themselves must be proved not to
# have moved with them — the Build Variety upgrade record, and the project
# owner's own composed zone.
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
	"scripts/stats/passive_card_selection.gd"
	"scripts/stats/passive_card_selection_result.gd"
	"scripts/stats/passive_card_catalogue.gd"
	"scripts/stats/passive_card_definition.gd"
	"scripts/stats/player_stats.gd"
	"scripts/roguelite/build_variety/roguelite_upgrade.gd"
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

printf 'Riftwrought — Roguelite Foundation F2: Deterministic Support-Lane Continuation Selection (D-253)\n'
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
verify_log="/tmp/riftwrought_support_continuation_verify.log"
"$GODOT" --headless --path "$PROJECT_DIR" --script "$VERIFICATION" > "$verify_log" 2>&1
verify_status=$?
assert_log_is_fresh "$verify_log"
assert_no_script_error "the headless continuation verification" "$verify_log"

if [[ "$verify_status" == "0" ]]; then
	pass "the verification exited 0"
else
	fail "the verification exited $verify_status"
	grep -E "^  FAIL" "$verify_log" | head -20 | sed 's/^/        /'
fi

count="$(read_check_count "SUPPORT CONTINUATION VERIFICATION" "$verify_log")"
if [[ "$count" == "$EXPECTED_CHECKS" ]]; then
	pass "verification passes at the pinned $EXPECTED_CHECKS checks"
else
	fail "verification reports ${count:-no} checks, not $EXPECTED_CHECKS"
fi

# A guard that accepts everything protects nothing: the pin must refuse a log
# whose count moved by one.
replay="$(mktemp -t riftwrought_support_continuation_replay)"
scratch_replay="$replay"
sed "s/SUPPORT CONTINUATION VERIFICATION: PASS ($EXPECTED_CHECKS checks)/SUPPORT CONTINUATION VERIFICATION: PASS ($((EXPECTED_CHECKS + 1)) checks)/" \
	"$verify_log" > "$replay"
if [[ "$(read_check_count "SUPPORT CONTINUATION VERIFICATION" "$replay")" != "$EXPECTED_CHECKS" ]]; then
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
256 seeds: F2 == the accepted selector exactly, all NEW_PAIR, 0 claimed held
the held pair is offered 0 times over 256 seeds; the remaining 3 pairs are reachable
an exhausted Skill ranked 0 times over 256 seeds; a partial pool ranked 0 times
first stage 300 / 300 over 600 tickets in both phases; both Skills reachable when ranking
0 rank decisions at 1-5 of 6 pairs held; 256 of 256 seeds rank at 6 of 6
256 rank decisions, all held for their own Skill; 6 distinct pairs reached
256 seeds identical at ranks 1, 2, 977 and mixed — below the declared maximum of 1000, rank 1 and rank 977 are selection-equivalent
256 rank decisions reproduce the accepted rank-increase selection exactly, same seed
ladder 4 / 6 / 5 of 15 walked ticket by ticket
13 refusals driven, every one whole: no kind, no ids, no derivation
0 concrete names, 0 ambient reads, 0 rank readings, 0 deferred concepts
A, B and F1 answer exactly as before; the shipped ladder is 100 / 100; 31 actions
MEASURED

# --------------------------------------------------------------------------
step "3. The continuation scripts store nothing, randomise nothing and read no rank"
ambient=0
for script in "${FOUNDATION_SCRIPTS[@]}"; do
	if grep -qE 'user://|ConfigFile|ResourceSaver|FileAccess' "$PROJECT_DIR/$script"; then
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
	# Concrete names, RAW — comments included, which is the D-215 rule.
	if grep -qE 'quick_strike|Quick Strike|reaching_edge|sweeping_edge|Graveblade|Riftfall' \
			"$PROJECT_DIR/$script"; then
		fail "$script names something concrete"
		ambient=$((ambient + 1))
	fi
	# Rank members, CODE ONLY: documenting a deliberate absence is not a fault,
	# calling one is.
	if grep -vE '^[[:space:]]*#' "$PROJECT_DIR/$script" \
			| grep -qE 'rank_for\(|increase_rank\(|total_ranks\(|rank_support\(|support_rank_for\(|total_support_ranks\('; then
		fail "$script calls a ranked-ownership member, so a rank could move a selection"
		ambient=$((ambient + 1))
	fi
done
if [[ "$ambient" == "0" ]]; then
	pass "neither generic script stores, randomises, names anything concrete or reads a rank"
fi

# --------------------------------------------------------------------------
step "4. scripts/continuation/ holds exactly its two scripts"
EXPECTED_CONTINUATION_SCRIPTS=2
unexpected=0
while IFS= read -r path; do
	base="$(basename "$path")"
	case "$base" in
		support_continuation.gd|support_continuation_result.gd) ;;
		support_continuation.gd.uid|support_continuation_result.gd.uid) ;;
		*)
			fail "scripts/continuation/ holds the unexpected file $base"
			unexpected=$((unexpected + 1))
			;;
	esac
done < <(find "$PROJECT_DIR/scripts/continuation" -type f 2>/dev/null)
found="$(find "$PROJECT_DIR/scripts/continuation" -type f -name '*.gd' 2>/dev/null | wc -l | tr -d ' ')"
if [[ "$found" != "$EXPECTED_CONTINUATION_SCRIPTS" ]]; then
	fail "scripts/continuation/ holds $found scripts, not $EXPECTED_CONTINUATION_SCRIPTS"
elif [[ "$unexpected" == "0" ]]; then
	pass "scripts/continuation/ holds exactly its $EXPECTED_CONTINUATION_SCRIPTS scripts and their uid files"
fi

# --------------------------------------------------------------------------
# THE FILES AUTHORIZED TO NAME A FOUNDATION F2 CLASS, in the order they were
# granted. The first two arrived with Foundation F3 (D-255): the
# accepted three-lane offer composer delegates its whole support lane to this
# decision, and the accepted offer retains the record that decision comes back
# in. Nothing else may name either, and the exemption must actually be used — a
# grant that cannot fail is not a boundary.
# Foundation F4 (D-257) added the two accepted choice scripts: the transaction
# routes on the progression kind an offer froze, and the result names the record
# for its own kind label. Neither may CALL the selector, which the Foundation D3
# suite asserts by name.
# Foundation F5 (D-260) added the level-up receipt, which carries the Support
# progression its choice consumed and names the record for the same kind label.
# It may CALL nothing of F2 either, which the Foundation F5 suite asserts by name.
# Roguelite Foundation I6 (D-304) added the exhausted-support passive fallback,
# which activates only on the record's own exhaustion classification. It CALLS no
# selector of F2 either. Added one for one; no assertion moved.
AUTHORIZED_READERS=(
	"scripts/offers/rift_offer_composition.gd"
	"scripts/offers/rift_offer.gd"
	"scripts/choices/rift_offer_choice.gd"
	"scripts/choices/rift_offer_choice_result.gd"
	"scripts/levels/rift_level_up_result.gd"
	"scripts/fallback/support_exhaustion_passive_fallback.gd"
)

# The step title reads its count from the list above rather than typing it
# (D-261): it said "two" through two later reader additions. The list is defined
# first and prints nothing, so only the number in the title moves.
step "5. Only the ${#AUTHORIZED_READERS[@]} authorized readers name either new class — measured OUTSIDE the engine"

scanned=0
named=0
authorized_hits=0
while IFS= read -r path; do
	case "$path" in
		*/scripts/continuation/*) continue ;;
	esac
	scanned=$((scanned + 1))
	granted=0
	for reader in "${AUTHORIZED_READERS[@]}"; do
		case "$path" in
			*/"$reader") granted=1 ;;
		esac
	done
	for name in "${F2_CLASSES[@]}"; do
		if grep -q "$name" "$path"; then
			if [[ "$granted" == "1" ]]; then
				authorized_hits=$((authorized_hits + 1))
				continue
			fi
			fail "$(basename "$path") names $name"
			named=$((named + 1))
		fi
	done
done < <(find "$PROJECT_DIR/scripts" "$PROJECT_DIR/scenes" "$PROJECT_DIR/data" "$PROJECT_DIR/addons" \
	-type f \( -name '*.gd' -o -name '*.tscn' -o -name '*.tres' \) 2>/dev/null)
if grep -qE 'SupportContinuation' "$PROJECT_DIR/project.godot"; then
	fail "project.godot names a Foundation F2 class"
	named=$((named + 1))
fi
# Every reader names the record, and the record's name contains the selector's,
# so each authorized file is reported for both class names: readers x 2 names.
EXPECTED_AUTHORIZED_HITS=$(( ${#AUTHORIZED_READERS[@]} * ${#F2_CLASSES[@]} ))
if [[ "$authorized_hits" != "$EXPECTED_AUTHORIZED_HITS" ]]; then
	fail "the authorized readers account for $authorized_hits of the $EXPECTED_AUTHORIZED_HITS name readings they must"
	named=$((named + 1))
fi
if [[ "$scanned" -lt 100 ]]; then
	fail "only $scanned project files were scanned in the shell, so the scan proves nothing"
elif [[ "$named" == "0" ]]; then
	pass "$scanned project files scanned in the shell; only the ${#AUTHORIZED_READERS[@]} authorized readers name a Foundation F2 class"
fi

# --------------------------------------------------------------------------
step "6. Nothing that already existed changed"
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
	printf 'SUPPORT CONTINUATION SMOKE CHECKS: PASS\n'
	printf '  %s checks; %s of %s owed; %s protected files byte-identical\n' \
		"$EXPECTED_CHECKS" "$EXPECTED_OWED_CHECKS" "$EXPECTED_OWED_CHECKS" "${#PRESERVED_FILES[@]}"
	printf '  Roguelite Foundation F2 is DELIVERED under D-253 and ACCEPTED and CLOSED at the\n'
	printf '  deterministic support-continuation selection mechanism level under D-254.\n'
	reached_end=1
	exit 0
else
	printf 'SUPPORT CONTINUATION SMOKE CHECKS: %d FAILURE(S)\n' "$failures"
	reached_end=1
	exit 1
fi
