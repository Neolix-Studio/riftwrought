#!/usr/bin/env bash
# Riftwrought — Roguelite Foundation D3 smoke checks: the atomic Rift-offer
# choice and its single-consumption protection (decision D-244).
#
# THIS IS NOT A GATE, AND IT DELIBERATELY RUNS NO LOCKED CHAIN.
#
# The foundation is THREE pure-logic scripts under `scripts/choices/` plus this
# suite. It adds no scene, no resource, no asset, no InputMap action and no
# entrypoint change; it writes nothing to disk; it changes no gameplay value; and
# NOTHING THAT RUNS CALLS IT — there is no offer display, no input, no
# experience, no level, no application to any actor and no persistence, and the
# verification proves that by scanning every project file under `scripts/`,
# `scenes/`, `data/` and `addons/`, plus `project.godot`, and requiring that not
# one of them names any of the three new classes. Rerunning Gates A-F, 1A-1E, the
# Zone Composer or the three roguelite reviews to check an unwired transaction
# would be verification theatre over work that cannot have reached them.
#
# IT DOES NOT RERUN FOUNDATIONS A, B, C1, C2, C3, D1 OR D2. Each owns its own
# count and is rerun by its own runner. D3 is authorized to READ three of them,
# which is why THREE of those suites' scope assertions were moved ONE FOR ONE to
# allow exactly these files and exactly the classes each names — changes proved
# separately and at their unchanged pinned 447 (D1), 259 (D2) and 180 (C2), with
# C3 at 299 confirmed unchanged because it cross-reads the edited C2 source.
#
# What this script proves:
#
#   1. every new script parses;
#   2. the pinned verification passes, proved in BOTH directions against a
#      replay of its own log, with every owed check reaching its last line;
#   3. the three scripts name no concrete Skill, support, card or presentation
#      label, read no storage, no random source and no ambient engine state, and
#      perform no arithmetic of their own — and exactly ONE of them names the
#      canonical card catalogue, asserted in both directions, because resolving a
#      stable id canonically IS the transaction's authorized mechanism and a
#      ledger that knew about content would have stopped being a value; and
#      nothing else in the project names any of the three classes; checked in the
#      shell as well as in the engine, because a scan that only ever runs inside
#      the thing it audits is one process away from proving nothing;
#   4. `scripts/choices/` holds exactly the three scripts it should and no stray
#      file beside them;
#   5. the twenty files it could conceivably have disturbed are BYTE-IDENTICAL
#      ACROSS THE RUN — `project.godot` and the nineteen accepted mechanism
#      scripts of Foundations A, B, C1, C2, C3, D1 and D2.
#
# THE THREE EDITED SUITES ARE DELIBERATELY NOT IN THAT PRESERVED LIST, because
# D-244 edits them on purpose: a per-file, per-class allowlist gained one or two
# rows each. Their MECHANISMS are in the list and are untouched; their harnesses
# moved, and each is re-run by its own runner at its own unchanged count.
#
# Usage, from the repository root:
#   game/tests/rift_offer_choice_smoke.sh

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
		printf '\nRIFT OFFER CHOICE SMOKE CHECKS: ABORTED before the end of the script\n'
		printf '  the run stopped early (exit %s) — nothing after that point was proved\n' "$status"
		exit 1
	fi
	exit "$status"
}
trap on_exit EXIT

GODOT="${GODOT:-/Applications/Godot.app/Contents/MacOS/Godot}"
EXPECTED_VERSION="4.7.2.stable"
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

VERIFICATION="res://tests/rift_offer_choice_verification.gd"

# Pinned, and proved in both directions below.
# 532 at D-244 delivery, plus the 39 the D-249 aliasing correction adds in one
# new check. Nothing was removed: the six moved call sites and the two moved
# pins are the same assertions asked through an accessor instead of a field.
#
# 571 -> 572 UNDER D-257 (Foundation F4), AND THE ARITHMETIC IS EXACTLY ONE
# ASSERTION. F4 teaches this transaction to consume the support lane's frozen
# NEW_PAIR or RANK_INCREASE operation, so the two choice files now name the
# accepted continuation VOCABULARY — and because the selector's class name is a
# substring of the record's, the per-file allowlist had to grant the selector as
# well. The one added assertion is the narrowing that pays for that: neither file
# may CALL `SupportContinuation.select`. Everything else moved without moving a
# count: the method and field pins are single joined comparisons, and the
# deferred-member list swapped its `rank` token for the four things F4 still
# defers rather than gaining or losing a row.
EXPECTED_CHECKS=572

# The number of check FUNCTIONS the suite owes, separate from the number of
# assertions. Pinned as a variable rather than written into the grep, because
# hard-coding it into the pattern goes stale the moment a check is added —
# reporting a failure whose text is the correct answer.
EXPECTED_OWED_CHECKS=16

NEW_SCRIPTS=(
	"scripts/choices/rift_offer_choice.gd"
	"scripts/choices/rift_offer_choice_result.gd"
	"scripts/choices/rift_consumption_ledger.gd"
	"tests/rift_offer_choice_verification.gd"
)

# The three files the foundation owns. None may name a Skill, a support, a card
# or a presentation label; none may store, randomise or read ambient state; and
# none may compute anything — the accepted accumulator adds modifiers and the
# accepted run-build state counts acquisitions.
CHOICE_SCRIPTS=(
	"scripts/choices/rift_offer_choice.gd"
	"scripts/choices/rift_offer_choice_result.gd"
	"scripts/choices/rift_consumption_ledger.gd"
)

# The one file that MUST name the canonical card catalogue, and therefore the
# only one that may. Asserted in both directions below.
CATALOGUE_READER="scripts/choices/rift_offer_choice.gd"

# The three global class names this foundation introduces. Nothing that runs may
# name any of them.
CHOICE_CLASSES=(
	"RiftOfferChoiceResult"
	"RiftOfferChoice"
	"RiftConsumptionLedger"
)

# DELIBERATELY SHORT, AND NOT A WHOLE-PROJECT CATALOGUE. These are the files this
# work could conceivably have disturbed: the project settings and the nineteen
# accepted mechanism scripts of the foundations D3 stands on. D3 must read three
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
	"scripts/runs/rift_run_build.gd"
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

printf 'Riftwrought — Roguelite Foundation D3: the atomic Rift-offer choice (D-244)\n'
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
verify_log="/tmp/riftwrought_rift_offer_choice_verify.log"
"$GODOT" --headless --path "$PROJECT_DIR" --script "$VERIFICATION" > "$verify_log" 2>&1
verify_status=$?
assert_log_is_fresh "$verify_log"
assert_no_script_error "the headless rift offer choice verification" "$verify_log"

if [[ "$verify_status" == "0" ]]; then
	pass "the verification exited 0"
else
	fail "the verification exited $verify_status"
	grep -E "^  FAIL" "$verify_log" | head -20 | sed 's/^/        /'
fi

count="$(read_check_count "RIFT OFFER CHOICE VERIFICATION" "$verify_log")"
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
replay="$(mktemp -t riftwrought_rift_offer_choice_replay)"
scratch_replay="$replay"
sed "s/RIFT OFFER CHOICE VERIFICATION: PASS ($EXPECTED_CHECKS checks)/RIFT OFFER CHOICE VERIFICATION: PASS ($((EXPECTED_CHECKS + 1)) checks)/" \
	"$verify_log" > "$replay"
replay_count="$(read_check_count "RIFT OFFER CHOICE VERIFICATION" "$replay")"
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
# `--` before the pattern, and it is load-bearing rather than tidy: one of the
# measured lines below begins with `-1`, which `grep` reads as an option bundle
# and refuses outright — a check that could never pass whatever the log said.
while IFS= read -r line; do
	if grep -qF -- "$line" "$verify_log"; then
		pass "measured: ${line}"
	else
		fail "the verification log does not report: ${line}"
	fi
done <<'MEASURED'
a new ledger is empty; 1 seed recorded, 1 duplicate refused, 5 recorded in all
root seed 0 consumed; Support: quick_strike -> reaching_edge
maximum_life +0.14999999999999999 from card_vitality alone; 5 other stats untouched
pickup_radius +0.25 from card_magnetism alone; 5 other stats untouched
3 lanes, 3 distinct builds from one starting state; the supplied values never moved
the returned build and ledger are independent in both directions
4 attempts on a spent root seed refused; the build and ledger never moved
root seeds 3 and 6 both offer
-1 and 9223372036854775807 compose one question
a stale support offer refuses, spends nothing, and its other lanes remain takeable
8 absent or incoherent arguments refused; the supplied build and ledger never moved
2 unknown ids and 2 canonical ids offered from the wrong lane all refused
the once-only rule refuses directly and through the transaction; 6 of 6 shipped
card_power x2 from root seeds 7 and 9: global_damage = 0.20000000000000001 over 2 contributions
6 records renamed, 0 ids moved; all 3 lanes produce byte-identical outcomes
3 scripts scanned raw: 0 forbidden tokens, 0 ambient reads, 0 deferred members
21 refusals were driven across this suite
the identity is answered by copy: 2 supplied, 2 read and 2 accessor mutations reached nothing
quick_strike -> reaching_edge / card_vitality / card_magnetism are unchanged byte for byte and order for order
MEASURED

# --------------------------------------------------------------------------
step "3. The three scripts name nothing concrete, read nothing ambient, compute nothing"
ambient=0
for script in "${CHOICE_SCRIPTS[@]}"; do
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
	# A choice transaction is handed an offer and a run build. Naming the SUPPORT
	# catalogue or a concrete card would make a generic mechanism the shipped
	# set's own; the CARD catalogue is the one deliberate exception and is
	# handled, in both directions, immediately below.
	if grep -qE 'SkillSupportCatalogue|card_power|card_celerity|card_vitality|card_fleetness|card_insight|card_magnetism|reaching_edge|sweeping_edge' "$PROJECT_DIR/$script"; then
		fail "$script names the support catalogue, a card or a support"
		ambient=$((ambient + 1))
	fi
	# Renaming a record or changing how often it is offered must never change a
	# transaction, and the only arrangement in which that is true is one where it
	# cannot see either.
	if grep -qE 'display_name|base_weight' "$PROJECT_DIR/$script"; then
		fail "$script reads a presentation name or an offer weight"
		ambient=$((ambient + 1))
	fi
	# It records a choice and computes nothing. The comment lines are stripped
	# first: the files' own headers say in plain English that they apply no value
	# and add no total, and a scan that cannot tell the promise from the breach is
	# worthless — Gate 1C's lesson, kept.
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
	pass "the ${#CHOICE_SCRIPTS[@]} choice scripts store nothing, randomise nothing, read no ambient state, name no support catalogue, card or label, and do no arithmetic"
fi

# THE CARD CATALOGUE, IN BOTH DIRECTIONS. Exactly one file must name it —
# resolving a stable id canonically IS the transaction's mechanism, and a check
# that only forbade it would go green the day the transaction stopped doing that.
catalogue_named=0
for script in "${CHOICE_SCRIPTS[@]}"; do
	if grep -qF 'PassiveCardCatalogue' "$PROJECT_DIR/$script"; then
		catalogue_named=$((catalogue_named + 1))
		if [[ "$script" != "$CATALOGUE_READER" ]]; then
			fail "$script names the canonical card catalogue"
		fi
	fi
done
if [[ "$catalogue_named" == "1" ]] && grep -qF 'PassiveCardCatalogue' "$PROJECT_DIR/$CATALOGUE_READER"; then
	pass "exactly one script names the canonical card catalogue, and it is the transaction"
else
	fail "$catalogue_named of ${#CHOICE_SCRIPTS[@]} scripts name the canonical card catalogue"
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
for name in "${CHOICE_CLASSES[@]}"; do
	while IFS= read -r hit; do
		case "$hit" in
			*/scripts/choices/rift_offer_choice.gd|*/scripts/choices/rift_offer_choice_result.gd|*/scripts/choices/rift_consumption_ledger.gd)
				continue ;;
		esac
		# D-248: the Foundation E2 level-up coordinator holds one consumption
		# ledger, delegates the whole choice to this transaction and reads its
		# result; its own result type names that result for the one thing only
		# that file writes down. Granted PER CLASS in the verification's own
		# allowlist — the E2 result is refused the LEDGER exactly as every other
		# file is.
		case "$hit" in
			*/scripts/levels/rift_level_up_coordinator.gd)
				continue ;;
		esac
		if [[ "$name" != "RiftConsumptionLedger" ]]; then
			case "$hit" in
				*/scripts/levels/rift_level_up_result.gd)
					continue ;;
			esac
		fi
		# D-269: the Foundation G4 run-level coordinator asks its current
		# lifecycle's ledger copy whether a derived root seed is already spent, so
		# it names the LEDGER — and is refused the transaction and its result.
		if [[ "$name" == "RiftConsumptionLedger" ]]; then
			case "$hit" in
				*/scripts/levels/rift_run_level_coordinator.gd)
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
	pass "nothing under scripts/, scenes/, data/ or addons/ and nothing in project.godot names a Foundation D3 class"
fi

# --------------------------------------------------------------------------
step "4. The new directory holds exactly what it should"
# A scratch probe left behind is a project file nobody meant to ship, and it
# would be invisible to every scan above that filters on a known path.
unexpected=0
while IFS= read -r entry; do
	case "$(basename "$entry")" in
		rift_offer_choice.gd|rift_offer_choice.gd.uid| \
		rift_offer_choice_result.gd|rift_offer_choice_result.gd.uid| \
		rift_consumption_ledger.gd|rift_consumption_ledger.gd.uid)
			continue ;;
	esac
	fail "scripts/choices/ holds the unexpected file $(basename "$entry")"
	unexpected=$((unexpected + 1))
done < <(find "$PROJECT_DIR/scripts/choices" -type f 2>/dev/null)
gd_count="$(find "$PROJECT_DIR/scripts/choices" -type f -name '*.gd' 2>/dev/null | wc -l | tr -d ' ')"
if [[ "$gd_count" != "3" ]]; then
	fail "scripts/choices/ holds $gd_count scripts, not 3"
elif [[ "$unexpected" == "0" ]]; then
	pass "scripts/choices/ holds exactly the three scripts and their three uid files"
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
	printf 'RIFT OFFER CHOICE SMOKE CHECKS: PASS\n'
	printf '  %s checks; %s of %s owed; %s protected files byte-identical\n' \
		"$EXPECTED_CHECKS" "$EXPECTED_OWED_CHECKS" "$EXPECTED_OWED_CHECKS" "${#PRESERVED_FILES[@]}"
	printf '  Roguelite Foundation D3 is DELIVERED under D-244 and ACCEPTED and CLOSED\n'
	printf '  at the temporary choice-transaction mechanism level under D-245,\n'
	printf '  and CORRECTED under D-249. The correction does not reopen it.\n'
	printf '  Foundation F4 (D-257) EXTENDED this transaction so the support lane consumes\n'
	printf '  the frozen NEW_PAIR or RANK_INCREASE operation an offer carries; that\n'
	printf '  extension has its own suite and its own decision, and it does not reopen\n'
	printf '  this one. Every accepted D3 answer above is measured unchanged.\n'
	reached_end=1
	exit 0
else
	printf 'RIFT OFFER CHOICE SMOKE CHECKS: %d FAILURE(S)\n' "$failures"
	reached_end=1
	exit 1
fi
