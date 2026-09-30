#!/usr/bin/env bash
# Riftwrought — Roguelite Foundation F3 smoke checks: Rank-Aware Three-Lane Rift
# Offer Composition (decision D-255).
#
# THIS IS NOT A GATE, AND IT DELIBERATELY RUNS NO LOCKED CHAIN.
#
# F3 adds NO production file of its own. It EXTENDS the two accepted Foundation
# D1 scripts under `scripts/offers/` so that the support lane is decided by the
# accepted continuation mechanism and the rank transition that decision implies
# is frozen into the offer. It adds no scene, no resource, no asset, no InputMap
# action and no entrypoint change; it writes nothing to disk; and nothing that
# runs calls any of it — D1's own suite proves that, and this foundation did not
# widen it. Rerunning Gates A-F, 1A-1E, the Zone Composer or the three roguelite
# reviews to check an unwired composer would be verification theatre over work
# that cannot have reached them.
#
# IT ALSO DOES NOT RERUN THE ACCEPTED FOUNDATIONS. Those suites own their own
# counts and were run separately against this tree; chaining them here would make
# every future edit to a comment rerun foundations it cannot reach. What this
# script does instead is FINGERPRINT every accepted mechanism script across its
# own run, so this run cannot disturb them.
#
# What this script proves:
#
#   1. both extended scripts and the new verification parse;
#   2. the pinned verification passes, proved in BOTH directions against a replay
#      of its own log, with every owed check reaching its last line;
#   3. the composer composes its support lane THROUGH the accepted continuation
#      and never around it, and stages the frozen transition through exactly the
#      two ranked-ownership members it was granted — checked in the shell as well
#      as in the engine, because a scan that only ever runs inside the thing it
#      audits is one process away from proving nothing;
#   4. `scripts/offers/` still holds exactly its two scripts, so this foundation
#      really did extend rather than fork;
#   5. `project.godot` gained no autoload, no new class and no action;
#   6. the files it could conceivably have disturbed are BYTE-IDENTICAL ACROSS
#      THE RUN, including the canonical Quick Strike record, every accepted
#      foundation mechanism script and the project owner's own composed zone.
#
# Usage, from the repository root:
#   game/tests/rank_aware_offer_composition_smoke.sh

set -uo pipefail

# Assigned at the TOP of the script, never beside the function it serves: a shell
# evaluates an assignment only when execution REACHES it, and Gate 1E's first
# staleness guard failed every read for exactly that reason.
RUN_STARTED_AT="$(date +%s)"

# A SCRIPT THAT DIES HALFWAY MUST NOT REPORT SUCCESS. `reached_end` is set by
# exactly one line, immediately before the final verdict.
reached_end=0
scratch_replay=""
on_exit() {
	local status=$?
	[[ -n "$scratch_replay" ]] && rm -f "$scratch_replay"
	if [[ "$reached_end" != "1" ]]; then
		printf '\nRANK AWARE OFFER COMPOSITION SMOKE CHECKS: ABORTED before the end of the script\n'
		printf '  the run stopped early (exit %s) — nothing after that point was proved\n' "$status"
		exit 1
	fi
	exit "$status"
}
trap on_exit EXIT

GODOT="${GODOT:-/Applications/Godot.app/Contents/MacOS/Godot}"
EXPECTED_VERSION="4.7.2.stable"
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

VERIFICATION="res://tests/rank_aware_offer_composition_verification.gd"

# Pinned, and proved in both directions below.
#
# 197 AT D-255 DELIVERY; 203 SINCE D-257, AND THE +6 IS ONE CHECK CHANGING ITS
# SUBJECT BY AUTHORIZATION RATHER THAN THIS FOUNDATION GAINING SCOPE. Check 15
# pinned the fact that the accepted choice transaction REFUSED a rank offer as
# stale, which was correct while nothing downstream could consume a frozen
# progression. Foundation F4 authorizes exactly that consumption, so the check now
# pins the seam it always existed for — that a rank offer this composer produced is
# actionable exactly as it was frozen, moving one rank and not one pair — and it
# takes 23 assertions where the refusal took 17. Nothing else in this suite moved:
# no composition answer, no corpus row, no lane seed and no frozen transition.
#
# UNCHANGED BY FOUNDATION I5 (D-300). Check 15's run moved one for one — one pair
# raised to its maximum instead of both raised to rank 2, which is now an exhausted
# state — and the fabricated definitions declare a maximum far above every rank the
# suite holds; one measured line below was retyped to the 1 -> 2 it now prints.
EXPECTED_CHECKS=203

# The number of check FUNCTIONS the suite owes, separate from the number of
# assertions. Pinned as a variable rather than written into the grep, because
# hard-coding it into the pattern goes stale the moment a check is added —
# reporting a failure whose text is the correct answer.
EXPECTED_OWED_CHECKS=17

PARSED_SCRIPTS=(
	"scripts/offers/rift_offer.gd"
	"scripts/offers/rift_offer_composition.gd"
	"tests/rank_aware_offer_composition_verification.gd"
)

COMPOSER="scripts/offers/rift_offer_composition.gd"
OFFER="scripts/offers/rift_offer.gd"

# DELIBERATELY SHORT, AND NOT A WHOLE-PROJECT CATALOGUE. These are the files this
# work could conceivably have disturbed: the project settings, the canonical
# combat record, every accepted foundation mechanism script — including the two
# this foundation extends, which must not move again while their own suite is
# reading them — the Build Variety upgrade record, and the project owner's own
# composed zone.
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

# D-201's lesson, kept alive in every runner since: a run that reports PASS while
# a script error scrolled past is not a pass.
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

printf 'Riftwrought — Roguelite Foundation F3: Rank-Aware Three-Lane Rift Offer Composition (D-255)\n'
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
step "1. Both extended scripts and the new verification parse"
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
verify_log="/tmp/riftwrought_rank_aware_offer_verify.log"
"$GODOT" --headless --path "$PROJECT_DIR" --script "$VERIFICATION" > "$verify_log" 2>&1
verify_status=$?
assert_log_is_fresh "$verify_log"
assert_no_script_error "the headless rank-aware composition verification" "$verify_log"

if [[ "$verify_status" == "0" ]]; then
	pass "the verification exited 0"
else
	fail "the verification exited $verify_status"
	grep -E "^  FAIL" "$verify_log" | head -20 | sed 's/^/        /'
fi

count="$(read_check_count "RANK AWARE OFFER COMPOSITION VERIFICATION" "$verify_log")"
if [[ "$count" == "$EXPECTED_CHECKS" ]]; then
	pass "verification passes at the pinned $EXPECTED_CHECKS checks"
else
	fail "verification reports ${count:-no} checks, not $EXPECTED_CHECKS"
fi

# A guard that accepts everything protects nothing: the pin must refuse a log
# whose count moved by one.
replay="$(mktemp -t riftwrought_rank_aware_offer_replay)"
scratch_replay="$replay"
sed "s/RANK AWARE OFFER COMPOSITION VERIFICATION: PASS ($EXPECTED_CHECKS checks)/RANK AWARE OFFER COMPOSITION VERIFICATION: PASS ($((EXPECTED_CHECKS + 1)) checks)/" \
	"$verify_log" > "$replay"
if [[ "$(read_check_count "RANK AWARE OFFER COMPOSITION VERIFICATION" "$replay")" != "$EXPECTED_CHECKS" ]]; then
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
	if grep -qF -- "$line" "$verify_log"; then
		pass "measured: ${line}"
	else
		fail "the verification log does not report: ${line}"
	fi
done <<'MEASURED'
14 of 14 documented rows exact and all NEW_PAIR at rank 0 -> 1
14 documented rows exact over 42 lane seeds (39 distinct); 256 of 256 seeds keep both passive lanes across a new-pair AND a rank offer
1280 offers across 1-5 of 6 pairs held: all NEW_PAIR at 0 -> 1, 0 already held
the held pair is offered 0 times
256 of 256 shipped and 256 of 256 fabricated exhausted seeds compose a RANK_INCREASE; 6 of 6 held pairs reachable
768 offers at ranks 1, 2, 977: 0 pair drift, 768 exact transitions; a mixed record froze 6 distinct before-ranks over 256 seeds
512 of 512 offers carry a coherent, reproducible decision over the very derivation it was made from
768 complete offers over 3 acquisition states: reversed arrays, reversed and doubled tags and reversed records change nothing, progression included
512 successful compositions over 2 states and 256 refusals left every pair, rank, count and listing exactly where it was
2 complete support-lane refusals: no identity, no derivation, no progression, no lane; both passive lanes suppressed
6 passive-record faults over an empty AND an exhausted acquisition state, all reported at the Combat and Defence lane with no partial offer
9 field mutations and 4 nested-decision mutations each reported by problem()
512 support identities over new-pair AND rank offers are exactly 2 ordered ids; the accepted presentation is unchanged
the documented new-pair offer is taken exactly as before: 1 pair at rank 1, 0 passives, root seed 0 consumed
a rank offer (another rank of a held pair, rank 1 -> 2) is consumed through the accepted rank operation: 4 ranks over 2 pairs
root seed 0 still opens quick_strike -> reaching_edge as a new pair and still ends at Level 2 with 1 pair at rank 1 and 0 passives
768 transitions (512 new, 256 rank) reproduce an independent staging exactly
STATED LIMITATION: neither staging refusal is driven behaviourally, because the
8 refusals were driven across this suite
MEASURED

# --------------------------------------------------------------------------
step "3. The support lane is composed THROUGH the accepted continuation"
seam=0

# The one call it MUST make, and the one it must NOT. Reaching around the
# continuation to the weighted selector would put the global
# new-pair-before-rank policy back inside a composer as a second, subtly
# different copy — and it would pass every purity scan, because that class is one
# this foundation is legitimately allowed to name.
if ! grep -qF 'SupportContinuation.select' "$PROJECT_DIR/$COMPOSER"; then
	fail "the composer does not delegate its support lane to the accepted continuation"
	seam=$((seam + 1))
fi
if grep -qF 'SupportSelection.select' "$PROJECT_DIR/$COMPOSER"; then
	fail "the composer calls the weighted selector directly, around the continuation"
	seam=$((seam + 1))
fi
if ! grep -qF 'SupportSelection.select' "$PROJECT_DIR/scripts/continuation/support_continuation.gd"; then
	fail "the accepted continuation no longer calls the weighted selector, so the scan proves nothing"
	seam=$((seam + 1))
fi
if grep -qE 'SupportContinuation\.select|SupportSelection\.select|PassiveCardSelection\.select' \
		"$PROJECT_DIR/$OFFER"; then
	fail "the offer record makes a selection of its own"
	seam=$((seam + 1))
fi

# The frozen transition is MEASURED through the accepted ranked-ownership record,
# using exactly the two members Foundation F1's suite grants the composer.
for member in 'rank_for(' 'increase_rank('; do
	if ! grep -qF "$member" "$PROJECT_DIR/$COMPOSER"; then
		fail "the composer does not stage through $member"
		seam=$((seam + 1))
	fi
done
for member in 'total_ranks(' 'rank_support(' 'support_rank_for(' 'total_support_ranks(' 'release('; do
	if grep -qF "$member" "$PROJECT_DIR/$COMPOSER"; then
		fail "the composer calls the forbidden ranked-ownership member $member"
		seam=$((seam + 1))
	fi
done
if grep -qE 'rank_for\(|increase_rank\(|acquire\(' "$PROJECT_DIR/$OFFER"; then
	fail "the offer record stages a rank operation of its own"
	seam=$((seam + 1))
fi

# It stages on a DUPLICATE and mutates nothing it was handed.
if ! grep -qF 'acquired.duplicated()' "$PROJECT_DIR/$COMPOSER"; then
	fail "the composer does not stage on a duplicate of the supplied record"
	seam=$((seam + 1))
fi

# Neither extended script reads ambient state, randomises or names anything
# concrete. RAW — comments included, which is the D-215 rule.
for script in "$COMPOSER" "$OFFER"; do
	if grep -qE 'user://|ConfigFile|ResourceSaver|FileAccess' "$PROJECT_DIR/$script"; then
		fail "$script names a storage path or a writer"
		seam=$((seam + 1))
	fi
	if grep -qE 'randi|randf|randomize|RandomNumberGenerator|rand_from_seed' "$PROJECT_DIR/$script"; then
		fail "$script reads a global random source"
		seam=$((seam + 1))
	fi
	if grep -qE 'Time\.|OS\.|Engine\.|ProjectSettings|InputMap' "$PROJECT_DIR/$script"; then
		fail "$script reads ambient engine state"
		seam=$((seam + 1))
	fi
	if grep -qE 'quick_strike|Quick Strike|reaching_edge|sweeping_edge|card_power|card_insight|Graveblade|Riftfall' \
			"$PROJECT_DIR/$script"; then
		fail "$script names something concrete"
		seam=$((seam + 1))
	fi
	# The rank RECORDS PROGRESSION AND APPLIES NOTHING: no per-rank value, no
	# multiplier, no gameplay ceiling and no diminishing return.
	if grep -vE '^[[:space:]]*#' "$PROJECT_DIR/$script" \
			| grep -qE 'rank_cap|max_rank|maximum_rank|diminish|multiplier|rarity'; then
		fail "$script carries a rank cap, a diminishing return or a per-rank value"
		seam=$((seam + 1))
	fi
done

if [[ "$seam" == "0" ]]; then
	pass "the support lane goes through the accepted continuation, the transition is staged on a duplicate through exactly 2 granted members, and neither script names or reads anything it must not"
fi

# --------------------------------------------------------------------------
step "4. scripts/offers/ still holds exactly its two scripts"
EXPECTED_OFFER_SCRIPTS=2
unexpected=0
while IFS= read -r path; do
	base="$(basename "$path")"
	case "$base" in
		rift_offer.gd|rift_offer_composition.gd) ;;
		rift_offer.gd.uid|rift_offer_composition.gd.uid) ;;
		*)
			fail "scripts/offers/ holds the unexpected file $base"
			unexpected=$((unexpected + 1))
			;;
	esac
done < <(find "$PROJECT_DIR/scripts/offers" -type f 2>/dev/null)
found="$(find "$PROJECT_DIR/scripts/offers" -type f -name '*.gd' 2>/dev/null | wc -l | tr -d ' ')"
if [[ "$found" != "$EXPECTED_OFFER_SCRIPTS" ]]; then
	fail "scripts/offers/ holds $found scripts, not $EXPECTED_OFFER_SCRIPTS"
elif [[ "$unexpected" == "0" ]]; then
	pass "scripts/offers/ holds exactly its $EXPECTED_OFFER_SCRIPTS scripts and their uid files — this foundation extended rather than forked"
fi

# scripts/continuation/ is untouched by this foundation and must stay that way.
continuation_found="$(find "$PROJECT_DIR/scripts/continuation" -type f -name '*.gd' 2>/dev/null | wc -l | tr -d ' ')"
if [[ "$continuation_found" == "2" ]]; then
	pass "scripts/continuation/ still holds exactly its 2 accepted scripts"
else
	fail "scripts/continuation/ holds $continuation_found scripts, not 2"
fi

# --------------------------------------------------------------------------
step "5. project.godot gained nothing"
settings=0
if grep -q '\[autoload\]' "$PROJECT_DIR/project.godot"; then
	fail "project.godot declares an [autoload] section"
	settings=$((settings + 1))
fi
if grep -qE 'RiftOffer|SupportContinuation|AcquiredSupports' "$PROJECT_DIR/project.godot"; then
	fail "project.godot names a foundation class"
	settings=$((settings + 1))
fi
if ! grep -q 'run/main_scene="res://scenes/app/prototype_app.tscn"' "$PROJECT_DIR/project.godot"; then
	fail "the project entrypoint is not the Prototype App"
	settings=$((settings + 1))
fi
if [[ "$settings" == "0" ]]; then
	pass "no autoload, no foundation class, and the entrypoint is unchanged"
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
	printf 'RANK AWARE OFFER COMPOSITION SMOKE CHECKS: PASS\n'
	printf '  %s checks; %s of %s owed; %s protected files byte-identical\n' \
		"$EXPECTED_CHECKS" "$EXPECTED_OWED_CHECKS" "$EXPECTED_OWED_CHECKS" "${#PRESERVED_FILES[@]}"
	printf '  Roguelite Foundation F3 — Rank-Aware Three-Lane Rift Offer Composition — is\n'
	printf '  DELIVERED under D-255 and ACCEPTED and CLOSED at the rank-aware deterministic\n'
	printf '  offer-composition mechanism level under D-256.\n'
	printf '  Foundation F4 (D-257) moved check 15 one for one — a rank offer is now CONSUMED\n'
	printf '  by the accepted choice transaction rather than refused as stale — and extracted\n'
	printf '  the frozen transition rule into RiftOffer.support_transition_problem(). Neither\n'
	printf '  reopens this foundation, and no composition answer moved.\n'
	reached_end=1
	exit 0
else
	printf 'RANK AWARE OFFER COMPOSITION SMOKE CHECKS: %d FAILURE(S)\n' "$failures"
	reached_end=1
	exit 1
fi
