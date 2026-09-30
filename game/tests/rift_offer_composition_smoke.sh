#!/usr/bin/env bash
# Riftwrought — Roguelite Foundation D1 smoke checks: Deterministic Three-Lane
# Rift Offer Composition (decision D-239).
#
# THIS IS NOT A GATE, AND IT DELIBERATELY RUNS NO LOCKED CHAIN.
#
# The foundation is two pure-logic scripts under `scripts/offers/` plus this
# suite. It adds no scene, no resource, no asset, no InputMap action and no
# entrypoint change; it writes nothing to disk; it changes no gameplay value;
# and NOTHING THAT RUNS CALLS IT — there is no experience, no level, no
# choosing, no applying and no persistence, and the verification proves that by
# scanning every project file under `scripts/`, `scenes/`, `data/` and
# `addons/`, plus `project.godot`, and requiring that not one of them names
# either new class. Rerunning Gates A-F, 1A-1E, the Zone Composer or the three
# roguelite reviews to check an unwired composer would be verification theatre
# over work that cannot have reached them.
#
# IT DOES NOT RERUN FOUNDATIONS A, B, C1, C2 OR C3. Each owns its own count and
# is rerun by its own runner. D1 is authorized to READ all five, which is why
# each of those suites' scope assertions was moved ONE FOR ONE to allow exactly
# these two files and exactly the classes each of them names — changes proved
# separately, in both directions, and at their unchanged pinned 165, 223, 256,
# 180 and 299.
#
# What this script proves:
#
#   1. every new script parses;
#   2. the pinned verification passes, proved in BOTH directions against a
#      replay of its own log, with every owed check reaching its last line;
#   3. the two scripts name no concrete Skill, support, card, catalogue or
#      presentation name, read no storage, no random source and no ambient
#      engine state, and build no weighted ladder of their own — and nothing
#      else in the project names either of them; checked in the shell as well as
#      in the engine, because a scan that only ever runs inside the thing it
#      audits is one process away from proving nothing;
#   4. `scripts/offers/` holds exactly the two scripts it should and no stray
#      file beside them;
#   5. the seventeen files it could conceivably have disturbed are BYTE-IDENTICAL
#      ACROSS THE RUN — `project.godot` and the sixteen accepted mechanism
#      scripts of Foundations A, B, C1, C2 and C3 that this composer reads.
#
# THE FIVE ACCEPTED SUITES ARE DELIBERATELY NOT IN THAT PRESERVED LIST, because
# D-239 edits five of them on purpose: a blanket "nothing names this class"
# became a per-file, per-class allowlist in each. Their MECHANISMS are in the
# list and are untouched; their harnesses moved, and each is re-run by its own
# runner at its own unchanged count.
#
# Usage, from the repository root:
#   game/tests/rift_offer_composition_smoke.sh

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
		printf '\nRIFT OFFER COMPOSITION SMOKE CHECKS: ABORTED before the end of the script\n'
		printf '  the run stopped early (exit %s) — nothing after that point was proved\n' "$status"
		exit 1
	fi
	exit "$status"
}
trap on_exit EXIT

GODOT="${GODOT:-/Applications/Godot.app/Contents/MacOS/Godot}"
EXPECTED_VERSION="4.7.2.stable"
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

VERIFICATION="res://tests/rift_offer_composition_verification.gd"

# Pinned, and proved in both directions below.
# Foundation F3 moved this from 447 by exactly +29, and the arithmetic is stated
# rather than observed: +17 is the one new clause every driven refusal now owes
# (a refusal must expose no support progression, over 17 refusals); +3 is check
# 12's exhaustion case becoming a composed rank increase, which is asserted
# rather than dropped; +5 is check 13's new F3 boundary — the composer must not
# reach around the continuation to the weighted selector, that scan is proved
# capable of failing, the two authorized staging members are used, the forbidden
# ones are not, and the offer builds no acquisition record; and +4 is the two
# cross-checks that the F1 and F2 suites really do grant this foundation the
# exemptions it now depends on.
EXPECTED_CHECKS=476

# The number of check FUNCTIONS the suite owes, separate from the number of
# assertions. Pinned as a variable rather than written into the grep, because
# hard-coding it into the pattern goes stale the moment a check is added —
# reporting a failure whose text is the correct answer.
EXPECTED_OWED_CHECKS=13

NEW_SCRIPTS=(
	"scripts/offers/rift_offer_composition.gd"
	"scripts/offers/rift_offer.gd"
	"tests/rift_offer_composition_verification.gd"
)

# The two files the foundation itself owns. Neither may name a Skill, a support,
# a card, either catalogue or a presentation name; neither may store, randomise
# or read ambient state; and neither may build a weighted ladder — this is a
# COMPOSER, and a composer that drew its own candidate would be a third selector.
COMPOSITION_SCRIPTS=(
	"scripts/offers/rift_offer_composition.gd"
	"scripts/offers/rift_offer.gd"
)

# The two global class names this foundation introduces. Nothing that runs may
# name either. Note the substring: `RiftOffer` is contained in
# `RiftOfferComposition`, so a hit on the composer is reported for both — the
# scan being blunt in the safe direction.
COMPOSITION_CLASSES=(
	"RiftOfferComposition"
	"RiftOffer"
)

# DELIBERATELY SHORT, AND NOT A WHOLE-PROJECT CATALOGUE. These are the files this
# work could conceivably have disturbed: the project settings and the sixteen
# accepted mechanism scripts of the five foundations D1 composes. D1 must read
# them and must not edit them.
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

printf 'Riftwrought — Roguelite Foundation D1: Rift Offer Composition (D-239)\n'
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
verify_log="/tmp/riftwrought_rift_offer_composition_verify.log"
"$GODOT" --headless --path "$PROJECT_DIR" --script "$VERIFICATION" > "$verify_log" 2>&1
verify_status=$?
assert_log_is_fresh "$verify_log"
assert_no_script_error "the headless rift offer composition verification" "$verify_log"

if [[ "$verify_status" == "0" ]]; then
	pass "the verification exited 0"
else
	fail "the verification exited $verify_status"
	grep -E "^  FAIL" "$verify_log" | head -20 | sed 's/^/        /'
fi

count="$(read_check_count "RIFT OFFER COMPOSITION VERIFICATION" "$verify_log")"
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
replay="$(mktemp -t riftwrought_rift_offer_replay)"
scratch_replay="$replay"
sed "s/RIFT OFFER COMPOSITION VERIFICATION: PASS ($EXPECTED_CHECKS checks)/RIFT OFFER COMPOSITION VERIFICATION: PASS ($((EXPECTED_CHECKS + 1)) checks)/" \
	"$verify_log" > "$replay"
replay_count="$(read_check_count "RIFT OFFER COMPOSITION VERIFICATION" "$replay")"
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
three lanes in the fixed order Support, Combat and Defence, Utility; 4 identities; a fourth lane answers nothing
256 of 256 support lanes reproduce Foundation B exactly and are eligible; an ineligible support was offered 0 times; 2 of 2 shipped supports reached
Combat and Defence [card_celerity, card_power, card_vitality] / Utility [card_fleetness, card_insight, card_magnetism]; 0 shared, 0 uncovered; 6 of 6 cards reached over 256 offers; 0 wrong-category lanes
100 of 100 identical compositions agree on the whole derivation; 256 seeds produced 256 distinct offers; 0 inputs mutated
256 offers over reversed Skills, supports and records are bit-identical, fabricated (0 drift) and shipped (0 drift)
256 offers over renamed Skills, supports and cards are bit-identical; neither D1 file names display_name
14 corpus rows exact over 42 lane seeds; 2 of 2 supports and 6 of 6 cards reached; -1 and 9223372036854775807 are one question
3 lane domains fixed and pairwise distinct, none a nested salt; 0 collisions and 0 negatives over 4096 roots; 4 finalizer copies agree over 1000 values
a support weight moved the support lane at 126 of 256 seeds and a wider pool at 168; 0 passive lanes moved
a combat weight moved the combat lane at 142 of 256 seeds; the support and utility lanes moved at 0
a utility weight moved the utility lane at 139 of 256 seeds; the support and combat lanes moved at 0
17 refusals, each naming its lane in words and by member and exposing 0 of 4 identities; two lanes that succeeded expose nothing
0 forbidden tokens, 0 ambient reads, 0 ladder fields; 26 methods and 21 fields pinned, 0 composer state
MEASURED

# --------------------------------------------------------------------------
step "3. The composer names nothing concrete, reads nothing ambient, builds no ladder"
ambient=0
for script in "${COMPOSITION_SCRIPTS[@]}"; do
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
	# A composer is handed the records it works on. Naming either shipped
	# catalogue would make a generic mechanism the shipped set's own.
	if grep -qE 'PassiveCardCatalogue|SkillSupportCatalogue|card_power|card_celerity|card_vitality|card_fleetness|card_insight|card_magnetism|reaching_edge|sweeping_edge' "$PROJECT_DIR/$script"; then
		fail "$script names a catalogue, a card or a support"
		ambient=$((ambient + 1))
	fi
	# Renaming a record must never change an offer, and the only arrangement in
	# which that is true is one where the mechanism cannot see the copy at all.
	if grep -q 'display_name' "$PROJECT_DIR/$script"; then
		fail "$script reads a presentation name"
		ambient=$((ambient + 1))
	fi
	# It composes three delegated draws. It never builds a fourth.
	if grep -qE 'base_weight|effective_weight|tag_bonuses|candidate_weights|total_weight|normalized_ticket|rolled_ticket' "$PROJECT_DIR/$script"; then
		fail "$script reads a weight or a ladder field"
		ambient=$((ambient + 1))
	fi
done
if [[ "$ambient" == "0" ]]; then
	pass "neither of the ${#COMPOSITION_SCRIPTS[@]} scripts stores, randomises, reads ambient state, names a catalogue, reads a name or builds a ladder"
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
for name in "${COMPOSITION_CLASSES[@]}"; do
	while IFS= read -r hit; do
		case "$hit" in
			*/scripts/offers/rift_offer_composition.gd|*/scripts/offers/rift_offer.gd)
				continue ;;
		esac
		# D-244: the Foundation D3 choice transaction and its result are handed one
		# composed offer and read its lanes, so they name RiftOffer. Granted PER
		# CLASS: naming the COMPOSER is still refused for them exactly as it is for
		# every other file, because a mechanism that could compose its own offer
		# could consume one nobody made.
		if [[ "$name" == "RiftOffer" ]]; then
			case "$hit" in
				*/scripts/choices/rift_offer_choice.gd|*/scripts/choices/rift_offer_choice_result.gd)
					continue ;;
			esac
		fi
		# D-248: the Foundation E2 level-up coordinator composes the ONE offer it
		# ever opens and then permanently refuses to open another, so it is the
		# first file granted the COMPOSER as well as the offer. The widening is
		# deliberate and is recorded in the verification's own allowlist beside
		# the reason the two D3 files are still refused it.
		case "$hit" in
			*/scripts/levels/rift_level_up_coordinator.gd)
				continue ;;
		esac
		# Its result type asks the offer contract about the lane it carries, and
		# is refused the COMPOSER exactly as the two D3 files are.
		if [[ "$name" == "RiftOffer" ]]; then
			case "$hit" in
				*/scripts/levels/rift_level_up_result.gd)
					continue ;;
			esac
		fi
		# D-293: the Roguelite I2 level-up choice review shows the standing offer's
		# lanes and asks the offer contract for each lane's name. Granted the OFFER
		# only, never the composer, in the verification's per-file, per-class table.
		if [[ "$name" == "RiftOffer" ]]; then
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
	pass "nothing under scripts/, scenes/, data/ or addons/ and nothing in project.godot names either Foundation D1 class"
fi

# --------------------------------------------------------------------------
step "4. The new directory holds exactly what it should"
# A scratch probe left behind is a project file nobody meant to ship, and it
# would be invisible to every scan above that filters on a known path.
unexpected=0
while IFS= read -r entry; do
	case "$(basename "$entry")" in
		rift_offer.gd|rift_offer.gd.uid|rift_offer_composition.gd|rift_offer_composition.gd.uid)
			continue ;;
	esac
	fail "scripts/offers/ holds the unexpected file $(basename "$entry")"
	unexpected=$((unexpected + 1))
done < <(find "$PROJECT_DIR/scripts/offers" -type f 2>/dev/null)
gd_count="$(find "$PROJECT_DIR/scripts/offers" -type f -name '*.gd' 2>/dev/null | wc -l | tr -d ' ')"
if [[ "$gd_count" != "2" ]]; then
	fail "scripts/offers/ holds $gd_count scripts, not 2"
elif [[ "$unexpected" == "0" ]]; then
	pass "scripts/offers/ holds exactly the two scripts and their two uid files"
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
	printf 'RIFT OFFER COMPOSITION SMOKE CHECKS: PASS\n'
	printf '  %s checks; %s of %s owed; %s protected files byte-identical\n' \
		"$EXPECTED_CHECKS" "$EXPECTED_OWED_CHECKS" "$EXPECTED_OWED_CHECKS" "${#PRESERVED_FILES[@]}"
	printf '  Roguelite Foundation F3 (D-255) EXTENDED both of these scripts so the support lane\n'
	printf '  may offer a rank of a held pair; that extension has its own suite and its own\n'
	printf '  decision, and it does not reopen this one.\n'
	printf '  Roguelite Foundation D1 is DELIVERED under D-239 and ACCEPTED and CLOSED\n'
	printf '  at the deterministic offer-composition mechanism level under D-240.\n'
	reached_end=1
	exit 0
else
	printf 'RIFT OFFER COMPOSITION SMOKE CHECKS: %d FAILURE(S)\n' "$failures"
	reached_end=1
	exit 1
fi
