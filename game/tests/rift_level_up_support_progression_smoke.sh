#!/usr/bin/env bash
# Riftwrought — Roguelite Foundation F5 smoke checks: Support progression
# propagated into the level-up receipt (decision D-260).
#
# THIS IS NOT A GATE, AND IT DELIBERATELY RUNS NO LOCKED CHAIN.
#
# F5 adds NO production file at all. It extends the two accepted Foundation E2
# scripts so the `RiftLevelUpResult` a completed level-up returns keeps the
# Support progression the accepted choice transaction consumed — NEW_PAIR 0 -> 1
# or RANK_INCREASE N -> N+1 — copied out of the successful choice result by the
# receipt's own one-argument constructor rather than re-derived from the build
# afterwards. Passive level-ups and every refusal carry none. It adds no scene, no
# resource, no asset, no InputMap action and no entrypoint change; it writes
# nothing to disk; it changes no gameplay mechanic; and NOTHING THAT RUNS CALLS
# IT — there is still no offer display, no input, no application to any actor and
# no persistence. Rerunning Gates A-F, 1A-1E, the Zone Composer or the three
# roguelite reviews to check an unwired receipt would be verification theatre over
# work that cannot have reached them.
#
# IT DOES NOT RERUN THE FOUNDATIONS IT STANDS ON FROM HERE. Each owns its own
# count and is rerun by its own runner; which of them F5 reached, and why, is
# recorded in decision D-260 rather than restated in a comment that could go
# stale.
#
# What this script proves:
#
#   1. every touched script parses;
#   2. the pinned verification passes, proved in BOTH directions against a replay
#      of its own log, with every owed check reaching its last line;
#   3. the progression is COPIED: the coordinator hands the whole successful
#      result to the receipt's constructor and names no rank and no progression;
#      the receipt reads its stable facts out of that one argument, asks the one
#      shared transition rule, and reads nothing mutable;
#   4. the two E2 scripts still name nothing concrete, read nothing ambient and
#      compute nothing;
#   5. F5 added no production file: `scripts/levels/` still holds its two;
#   6. `project.godot` gained nothing;
#   7. every protected file this work could have disturbed is byte-identical.

set -uo pipefail

# `/tmp` is never cleared between runs. Recorded before anything runs, so a log
# written by an earlier — possibly interrupted — invocation can never answer for
# this one.
RUN_STARTED_AT="$(date +%s)"

# A SCRIPT THAT DIES HALFWAY MUST NOT REPORT SUCCESS. `reached_end` is set by
# exactly one line, immediately before the final verdict.
reached_end=0
scratch_replay=""
on_exit() {
	local status=$?
	[[ -n "$scratch_replay" ]] && rm -f "$scratch_replay"
	if [[ "$reached_end" != "1" ]]; then
		printf '\nRIFT LEVEL-UP SUPPORT PROGRESSION SMOKE CHECKS: ABORTED before the end of the script\n'
		printf '  the run stopped early (exit %s) — nothing after that point was proved\n' "$status"
		exit 1
	fi
	exit "$status"
}
trap on_exit EXIT

GODOT="${GODOT:-/Applications/Godot.app/Contents/MacOS/Godot}"
EXPECTED_VERSION="4.7.2.stable"
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

VERIFICATION="res://tests/rift_level_up_support_progression_verification.gd"

# Pinned, and proved in both directions below.
#
# 720 OF THE 1125 ARE THE CORPUS'S OWN FIXTURE ASSERTIONS — 240 lifecycles
# (5 pre-choice states x 16 seeds x 3 lanes), three assertions each for the two
# awards, the reached requirement and the opened offer — so moving SEED_SAMPLES
# by one moves this pin by 45. The other 405 are the fifteen checks' own
# assertions and the owed-set pair; the suite prints its success and refusal
# totals because the two per-outcome helpers emit a fixed number each.
#
# 1128 UNTIL FOUNDATION I5 (D-300); THE -3 IS FIXTURE ARITHMETIC. Three fixtures held
# every pair at rank 2 — now an exhausted state that composes nothing — and built it
# in four asserted run-build operations; each moved one for one to a state holding
# one pair at its maximum beside the other at rank 1, built in three (checks 3, 4
# and 13, -1 each). The corpus is still 720; no other assertion moved.
EXPECTED_CHECKS=1125

# The number of check FUNCTIONS the suite owes, separate from the number of
# assertions. Pinned as a variable rather than written into the grep, because
# hard-coding it into the pattern goes stale the moment a check is added —
# reporting a failure whose text is the correct answer.
EXPECTED_OWED_CHECKS=15

PARSED_SCRIPTS=(
	"scripts/levels/rift_level_up_coordinator.gd"
	"scripts/levels/rift_level_up_result.gd"
	"tests/rift_level_up_support_progression_verification.gd"
)

# The two files F5 extends. Neither may name a Skill, a support, a card or a
# presentation label; neither may store, randomise or read ambient state; and
# neither may compute anything.
LEVEL_SCRIPTS=(
	"scripts/levels/rift_level_up_coordinator.gd"
	"scripts/levels/rift_level_up_result.gd"
)

COORDINATOR="scripts/levels/rift_level_up_coordinator.gd"
RESULT="scripts/levels/rift_level_up_result.gd"

# DELIBERATELY SHORT, AND NOT A WHOLE-PROJECT CATALOGUE. These are the files this
# work could conceivably have disturbed: the project settings, the canonical
# combat record, every accepted foundation mechanism script — including the two
# this foundation extends, which must not move again while this suite is reading
# them — and the project owner's own composed zone.
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
# file fails to PARSE exits 0.
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

printf 'Riftwrought — Roguelite Foundation F5: Support progression in the level-up receipt (D-260)\n'
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
step "1. Every touched script parses"
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
verify_log="/tmp/riftwrought_rift_level_up_support_progression_verify.log"
"$GODOT" --headless --path "$PROJECT_DIR" --script "$VERIFICATION" > "$verify_log" 2>&1
verify_status=$?
assert_log_is_fresh "$verify_log"
assert_no_script_error "the headless support-progression receipt verification" "$verify_log"

if [[ "$verify_status" == "0" ]]; then
	pass "the verification exited 0"
else
	fail "the verification exited $verify_status"
	grep -E "^  FAIL" "$verify_log" | head -20 | sed 's/^/        /'
fi

count="$(read_check_count "RIFT LEVEL-UP SUPPORT PROGRESSION VERIFICATION" "$verify_log")"
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
replay="$(mktemp -t riftwrought_rift_level_up_support_progression_replay)"
scratch_replay="$replay"
sed "s/RIFT LEVEL-UP SUPPORT PROGRESSION VERIFICATION: PASS ($EXPECTED_CHECKS checks)/RIFT LEVEL-UP SUPPORT PROGRESSION VERIFICATION: PASS ($((EXPECTED_CHECKS + 1)) checks)/" \
	"$verify_log" > "$replay"
replay_count="$(read_check_count "RIFT LEVEL-UP SUPPORT PROGRESSION VERIFICATION" "$replay")"
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
root seed 0: Support quick_strike -> reaching_edge, a new compatible pair, rank 0 -> 1; the run holds it at rank 1
exhausted, root seed 18: Support quick_strike -> sweeping_edge, another rank of a held pair, rank 1 -> 2; the run holds it at rank 2
reaching_edge at its maximum, root seed 18: Support quick_strike -> sweeping_edge, another rank of a held pair, rank 1 -> 2; the run holds it at rank 2
mixed ranks, sweeping_edge at its maximum: root seed 18 raises quick_strike -> reaching_edge 1 -> 2 and root seed 0 raises quick_strike -> reaching_edge 1 -> 2
240 lifecycles over 16 seeds, 5 pre-choice states and 3 lanes: every receipt equals its D3 choice — 32 new pairs, 48 rank increases, 160 passive
the receipt outlived its released offer: 0 lanes readable from the coordinator, 4 later operations refused, the receipt unmoved at another rank of a held pair, rank 1 -> 2
Combat and Defence: card_vitality, no support progression; Utility: card_magnetism, no support progression
4 passive level-ups over new-pair AND rank offers: 0 carried a progression
9 refusals carried no identity and no progression
17 tampered stable facts refused by problem(); each restored receipt is coherent again
4 legal and 8 illegal transitions: every receipt answer is the shared validator's own
the returned identity and the source choice result were mutated 9 ways; the receipt did not move
11 fields and 13 methods pinned; 17 forbidden members absent; the comparator refuses an extra and a missing member
150.0 against 100.0 through a rank choice: Level 2, 50.0 retained, 1 seed consumed, finished; 6 later operations refused
D3 still answers: quick_strike -> reaching_edge, a new compatible pair, rank 0 -> 1; quick_strike -> sweeping_edge, another rank of a held pair, rank 1 -> 2; quick_strike -> reaching_edge, another rank of a held pair, rank 1 -> 2; every audit silent and every supplied build untouched
the coordinator names 0 of 7 rank or progression tokens and hands 1 whole result to taken(); the receipt reads 0 of 13 mutable members
20 successes and 15 refusals were driven across this suite
MEASURED

# --------------------------------------------------------------------------
step "3. The progression is copied out of one object and never re-derived"
seam=0

# THE COORDINATOR HANDS THE WHOLE SUCCESSFUL RESULT OVER, AND READS NONE OF IT.
# Comment lines are stripped: both files say in plain English what they do not
# do, and a scan that cannot tell the promise from the breach is worthless.
coordinator_code="$(grep -vE '^[[:space:]]*#' "$PROJECT_DIR/$COORDINATOR")"
if [[ "$(grep -cF 'RiftLevelUpResult.taken(outcome)' <<< "$coordinator_code")" != "1" ]]; then
	fail "the coordinator does not build its receipt from the whole outcome exactly once"
	seam=$((seam + 1))
fi
if grep -qE 'rank|progression|chosen_identity' <<< "$coordinator_code"; then
	fail "the coordinator's code names a rank, a progression or the identity it no longer reads"
	seam=$((seam + 1))
fi

# THE RECEIPT READS ITS STABLE FACTS OUT OF THAT ONE ARGUMENT, ASKS THE ONE SHARED
# RULE, AND READS NOTHING MUTABLE.
result_code="$(grep -vE '^[[:space:]]*#' "$PROJECT_DIR/$RESULT")"
if ! grep -qF 'static func taken(from_choice: RiftOfferChoiceResult) -> RiftLevelUpResult:' <<< "$result_code"; then
	fail "the receipt's success constructor no longer takes the whole choice result"
	seam=$((seam + 1))
fi
for member in 'from_choice.support_progression_kind' 'from_choice.support_rank_before' \
		'from_choice.support_rank_after' 'from_choice.chosen_identity()'; do
	if ! grep -qF "$member" <<< "$result_code"; then
		fail "the receipt does not copy $member"
		seam=$((seam + 1))
	fi
done
if [[ "$(grep -cF 'RiftOffer.support_transition_problem(' <<< "$result_code")" != "1" ]]; then
	fail "the receipt does not ask the shared transition rule exactly once"
	seam=$((seam + 1))
fi
if grep -qE 'new_build|new_ledger|support_rank_for|has_support|acquired_supports|SupportContinuation\.select|ABSENT_RANK|FIRST_RANK' <<< "$result_code"; then
	fail "the receipt reads a mutable value, asks a build about a rank, or restates the rule"
	seam=$((seam + 1))
fi
if [[ "$seam" == "0" ]]; then
	pass "the coordinator hands one whole result to taken(); the receipt copies it, asks the shared rule once, and reads nothing mutable"
fi

# --------------------------------------------------------------------------
step "4. The two E2 scripts name nothing concrete, read nothing ambient, compute nothing"
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
	if grep -qE 'QuickStrike|quick_strike|PrototypePlayer|SkillSupportCatalogue|PassiveCardCatalogue|reaching_edge|sweeping_edge|card_power|card_vitality|card_magnetism|Graveblade|AcquiredSupports' "$PROJECT_DIR/$script"; then
		fail "$script names something concrete"
		ambient=$((ambient + 1))
	fi
	if grep -qE 'display_name|base_weight' "$PROJECT_DIR/$script"; then
		fail "$script reads a presentation name or an offer weight"
		ambient=$((ambient + 1))
	fi
	# A RECEIPT RECORDS WHAT HAPPENED AND APPLIES NOTHING: no per-rank value, no
	# gameplay ceiling, no refund, and no arithmetic of its own.
	if grep -vE '^[[:space:]]*#' "$PROJECT_DIR/$script" \
			| grep -qE 'rank_cap|max_rank|maximum_rank|diminish|multiplier|magnitude|refund'; then
		fail "$script carries a per-rank value, a ceiling or a refund"
		ambient=$((ambient + 1))
	fi
	if grep -vE '^[[:space:]]*#' "$PROJECT_DIR/$script" | grep -qE '[*/+]'; then
		fail "$script multiplies, divides or adds"
		ambient=$((ambient + 1))
	fi
	strays="$(grep -vE '^[[:space:]]*#' "$PROJECT_DIR/$script" \
		| grep -oE '[0-9]+\.[0-9]+' | grep -vx '0.0' | sort -u | tr '\n' ' ')"
	if [[ -n "${strays// /}" ]]; then
		fail "$script carries the floating-point literal(s) ${strays}"
		ambient=$((ambient + 1))
	fi
done
if [[ "$ambient" == "0" ]]; then
	pass "the ${#LEVEL_SCRIPTS[@]} E2 scripts store nothing, randomise nothing, read no ambient state, name nothing concrete, and do no arithmetic"
fi

# --------------------------------------------------------------------------
step "5. F5 added no production file"
# Foundation G4 (D-269) later added its own two scripts beside E2's; they and
# their uid files are the only other files the directory may hold.
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
	fail "scripts/levels/ holds $gd_count scripts, not the 2 Foundation E2 delivered and the 2 Foundation G4 added"
elif [[ "$unexpected" == "0" ]]; then
	pass "scripts/levels/ holds exactly E2's 2 scripts, G4's 2, and their uid files — this foundation extended rather than added"
fi

# --------------------------------------------------------------------------
step "6. project.godot gained nothing"
settings=0
if grep -q '\[autoload\]' "$PROJECT_DIR/project.godot"; then
	fail "project.godot declares an [autoload] section"
	settings=$((settings + 1))
fi
if grep -qE 'RiftLevelUp|RiftOffer|RiftRunBuild|SupportContinuation|AcquiredSupports' "$PROJECT_DIR/project.godot"; then
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
step "7. Nothing that already existed changed"
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
	printf 'RIFT LEVEL-UP SUPPORT PROGRESSION SMOKE CHECKS: PASS\n'
	printf '  %s checks; %s of %s owed; %s protected files byte-identical\n' \
		"$EXPECTED_CHECKS" "$EXPECTED_OWED_CHECKS" "$EXPECTED_OWED_CHECKS" "${#PRESERVED_FILES[@]}"
	printf '  Roguelite Foundation F5 — Support Progression Propagation into the\n'
	printf '  Level-Up Receipt — is DELIVERED under D-260 and ACCEPTED and CLOSED at\n'
	printf '  the immutable level-up progression-receipt mechanism level under D-261.\n'
	reached_end=1
	exit 0
else
	printf 'RIFT LEVEL-UP SUPPORT PROGRESSION SMOKE CHECKS: %d FAILURE(S)\n' "$failures"
	reached_end=1
	exit 1
fi
