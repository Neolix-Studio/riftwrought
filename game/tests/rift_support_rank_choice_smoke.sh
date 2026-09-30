#!/usr/bin/env bash
# Riftwrought — Roguelite Foundation F4 smoke checks: atomic Support rank-choice
# consumption (decision D-257).
#
# THIS IS NOT A GATE, AND IT DELIBERATELY RUNS NO LOCKED CHAIN.
#
# F4 adds NO production file at all. It extends the two accepted Foundation D3
# scripts so the choice transaction consumes the support lane's FROZEN NEW_PAIR or
# RANK_INCREASE operation, and it extracts the frozen transition's legality rule
# out of `RiftOffer.problem()` into one shared static both sides ask. It adds no
# scene, no resource, no asset, no InputMap action and no entrypoint change; it
# writes nothing to disk; it changes no gameplay value; and NOTHING THAT RUNS
# CALLS IT — there is still no offer display, no input, no application to any
# actor and no persistence. Rerunning Gates A-F, 1A-1E, the Zone Composer or the
# three roguelite reviews to check an unwired transaction would be verification
# theatre over work that cannot have reached them.
#
# IT DOES NOT RERUN THE FOUNDATIONS IT STANDS ON. Each owns its own count and is
# rerun by its own runner. F4 directly affected FIVE of them and each was rerun
# once, at the counts recorded below:
#
#   D1  rift_offer_composition_smoke.sh          476 — unchanged; one method pin moved
#   D3  rift_offer_choice_smoke.sh               572 — 571 + 1, the narrowing below
#   F1  ranked_support_ownership_smoke.sh        395 — unchanged; caller allowlist widened
#   F2  support_continuation_smoke.sh            245 — unchanged; reader allowlist widened
#   F3  rank_aware_offer_composition_smoke.sh    203 — 197 + 6, check 15 inverted
#
# and E2 (494) was rerun and is unchanged and untouched, because F4 reaches it
# only through the call it already makes.
#
# What this script proves:
#
#   1. every touched script parses;
#   2. the pinned verification passes, proved in BOTH directions against a replay
#      of its own log, with every owed check reaching its last line;
#   3. the transaction routes to both accepted operations, takes no continuation
#      decision of its own, and neither extended file restates the transition rule;
#   4. the two extended scripts still name nothing concrete, read nothing ambient
#      and compute nothing, and neither carries a per-rank value, a ceiling or a
#      refund;
#   5. F4 added no production file: `scripts/choices/` still holds its three and
#      `scripts/offers/` still holds its two;
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
		printf '\nRIFT SUPPORT RANK CHOICE SMOKE CHECKS: ABORTED before the end of the script\n'
		printf '  the run stopped early (exit %s) — nothing after that point was proved\n' "$status"
		exit 1
	fi
	exit "$status"
}
trap on_exit EXIT

GODOT="${GODOT:-/Applications/Godot.app/Contents/MacOS/Godot}"
EXPECTED_VERSION="4.7.2.stable"
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

VERIFICATION="res://tests/rift_support_rank_choice_verification.gd"

# Pinned, and proved in both directions below.
#
# 797 AT D-257 DELIVERY; 855 SINCE D-258, AND THE +58 IS EXACT ARITHMETIC RATHER
# THAN A NUMBER READ OFF A RUN. The correction moved the carried build's rank
# comparison out of the result's permanent `problem()` contract and into the
# separately named point-in-time audit, so this suite now asks BOTH queries
# everywhere it used to ask one:
#
#   +20  one audit assertion per SUCCESS, in `_expect_success`
#   +23  one audit assertion per REFUSAL, in `_expect_refused`
#   +4   the four passive choices in check 3
#   +5   check 9's corrected block: problem() stays empty, the audit speaks, and
#        the frozen progression, identity, seed and lane are proved unmoved
#        (six assertions replacing the one that asserted the old behaviour)
#   +4   check 10: the shifted-transition row, a purported success with no build,
#        and the three-way audit control
#   +2   check 16's structural proof of WHERE each query lives
#
# The success and refusal totals are printed by the suite for exactly this
# reason, so the two per-outcome terms above are reproducible rather than
# remembered.
#
# 851 SINCE FOUNDATION I5 (D-300), AND THE -4 IS FIXTURE ARITHMETIC, NOT A LOST
# ASSERTION. Check 4's two stale runs are built through the accepted run-build
# operations with one assertion per operation, exactly as before, but a shipped
# maximum of rank 2 changed which runs they can be: the BEHIND run now acquires one
# pair instead of two (-1), and the AHEAD run acquires two and raises one instead of
# acquiring two and raising four (-3). No assertion about the transaction was added
# or removed, and checks 2, 8 and 9 moved one for one at unchanged counts.
EXPECTED_CHECKS=851

# The number of check FUNCTIONS the suite owes, separate from the number of
# assertions. Pinned as a variable rather than written into the grep, because
# hard-coding it into the pattern goes stale the moment a check is added —
# reporting a failure whose text is the correct answer.
EXPECTED_OWED_CHECKS=16

PARSED_SCRIPTS=(
	"scripts/choices/rift_offer_choice.gd"
	"scripts/choices/rift_offer_choice_result.gd"
	"scripts/offers/rift_offer.gd"
	"tests/rift_support_rank_choice_verification.gd"
)

# The two files F4 extends. Neither may name a Skill, a support, a card or a
# presentation label; neither may store, randomise or read ambient state; and
# neither may compute anything — a rank RECORDS PROGRESSION and applies nothing.
EXTENDED_SCRIPTS=(
	"scripts/choices/rift_offer_choice.gd"
	"scripts/choices/rift_offer_choice_result.gd"
)

CHOICE="scripts/choices/rift_offer_choice.gd"
RESULT="scripts/choices/rift_offer_choice_result.gd"
OFFER="scripts/offers/rift_offer.gd"

# DELIBERATELY SHORT, AND NOT A WHOLE-PROJECT CATALOGUE. These are the files this
# work could conceivably have disturbed: the project settings, the canonical
# combat record, every accepted foundation mechanism script — including the three
# this foundation extends, which must not move again while their own suites are
# reading them — and the project owner's own composed zone.
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
# while a script error scrolled past is not a pass. It earned its keep again
# here: a `--script` run whose file fails to PARSE exits 0.
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

printf 'Riftwrought — Roguelite Foundation F4: atomic Support rank-choice consumption (D-257)\n'
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
verify_log="/tmp/riftwrought_rift_support_rank_choice_verify.log"
"$GODOT" --headless --path "$PROJECT_DIR" --script "$VERIFICATION" > "$verify_log" 2>&1
verify_status=$?
assert_log_is_fresh "$verify_log"
assert_no_script_error "the headless rank-choice verification" "$verify_log"

if [[ "$verify_status" == "0" ]]; then
	pass "the verification exited 0"
else
	fail "the verification exited $verify_status"
	grep -E "^  FAIL" "$verify_log" | head -20 | sed 's/^/        /'
fi

count="$(read_check_count "RIFT SUPPORT RANK CHOICE VERIFICATION" "$verify_log")"
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
replay="$(mktemp -t riftwrought_rift_support_rank_choice_replay)"
scratch_replay="$replay"
sed "s/RIFT SUPPORT RANK CHOICE VERIFICATION: PASS ($EXPECTED_CHECKS checks)/RIFT SUPPORT RANK CHOICE VERIFICATION: PASS ($((EXPECTED_CHECKS + 1)) checks)/" \
	"$verify_log" > "$replay"
replay_count="$(read_check_count "RIFT SUPPORT RANK CHOICE VERIFICATION" "$replay")"
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
	if grep -qF -- "$line" "$verify_log"; then
		pass "measured: ${line}"
	else
		fail "the verification log does not report: ${line}"
	fi
done <<'MEASURED'
root seed 0 consumed; Support: quick_strike -> reaching_edge [a new compatible pair, rank 0 -> 1]; 1 pair at rank 1, 0 passives, the supplied values untouched
quick_strike -> sweeping_edge raised 1 -> 2, then quick_strike -> reaching_edge 1 -> 2 on a fresh seed (the pair at its maximum offered 0 times over 127 unspent seeds): 2 pairs unchanged, 4 ranks in all, 0 passives and 1 other pair unmoved by the first choice
4 Combat/Defence and Utility choices over new-pair AND rank offers: 0 carried a progression, 0 moved a pair or a rank
2 stale rank offers refused in both directions, each naming the pair and both ranks; both seeds stayed spendable and both replacements succeeded
a stale new-pair offer (a new compatible pair, rank 0 -> 1) refuses, names rank 0 against the held rank 1, spends nothing, and root seed 0 then buys a fresh offer
2 mutations that succeeded without landing where the offer froze refused before the seed; the same offers succeed against the accepted run build
7 tampered progressions refused by offer coherence before any mutation, each quoting the offer's own reason; 0 seeds spent
9 attempts on a spent root seed refused across 3 offer identities and 3 lanes; an offer that is both spent and stale still reports spent first
the supplied build and ledger never moved on success or failure; the returned values are independent in both directions; and a later legitimate rank leaves problem() empty while the audit reports 'quick_strike -> sweeping_edge was consumed at rank 2 and the build now holds rank 3'
12 stable-fact contradictions reported by problem(); a legal transition the carried build disagrees with is reported by the point-in-time audit instead
256 support identities over new-pair AND rank choices are exactly 2 ordered ids; the accepted identity and presentation are unchanged
7 documented Foundation D3 seeds still take their new pair at rank 0 -> 1, and 3 documented seed pairs are still independently spendable
256 compositions over 128 seeds and 2 acquisition states reproduce themselves exactly, progression included; the accepted presentation is unchanged
root seed 0 still opens quick_strike -> reaching_edge as a new pair and still ends at Level 2 with 1 pair at rank 1 and 0 passives
an exhausted coordinator completes its one level-up through quick_strike -> sweeping_edge rank 1 -> 2: Level 2, 2 pairs, 3 ranks, permanently finished
3 legal and 6 illegal transitions driven through one shared validator
20 successes and 23 refusals were driven across this suite
MEASURED

# --------------------------------------------------------------------------
step "3. The transaction consumes a frozen progression and decides nothing"
seam=0

# The two accepted operations it MUST route between. A transaction that named
# only one of them would have inferred the other, which is exactly what reading
# the explicit kind exists to prevent.
for member in 'build.acquire_support(' 'build.rank_support('; do
	if ! grep -qF "$member" "$PROJECT_DIR/$CHOICE"; then
		fail "the transaction does not route to $member"
		seam=$((seam + 1))
	fi
done
for kind in 'SupportContinuationResult.Kind.NEW_PAIR' 'SupportContinuationResult.Kind.RANK_INCREASE'; do
	if ! grep -qF "$kind" "$PROJECT_DIR/$CHOICE"; then
		fail "the transaction does not route on $kind"
		seam=$((seam + 1))
	fi
done

# The precondition and the outcome gate, both by the member each reads through.
if ! grep -qF 'build.support_rank_for(' "$PROJECT_DIR/$CHOICE"; then
	fail "the transaction does not read the run's current rank"
	seam=$((seam + 1))
fi

# The one call NEITHER may make. Reading which operation an offer FROZE is
# consuming a decision; calling the selector would be taking one — and it would
# pass every purity scan, because that class is one they are now allowed to name.
for script in "$CHOICE" "$RESULT"; do
	if grep -qF 'SupportContinuation.select' "$PROJECT_DIR/$script"; then
		fail "$script calls the accepted continuation selector"
		seam=$((seam + 1))
	fi
done

# ONE OWNER FOR THE TRANSITION RULE. The shared static lives in the offer
# contract; the result asks it; the transaction requires the offer's own
# coherence instead; and NEITHER restates the accepted record's two named ranks.
if ! grep -qF 'static func support_transition_problem(' "$PROJECT_DIR/$OFFER"; then
	fail "the shared validator is not declared where the offer contract owns it"
	seam=$((seam + 1))
fi
if ! grep -qF 'RiftOffer.support_transition_problem' "$PROJECT_DIR/$RESULT"; then
	fail "the choice result does not ask the shared validator"
	seam=$((seam + 1))
fi
if grep -qF 'RiftOffer.support_transition_problem' "$PROJECT_DIR/$CHOICE"; then
	fail "the transaction asks the validator directly instead of requiring the offer's own coherence"
	seam=$((seam + 1))
fi

# PERMANENT COHERENCE AND THE POINT-IN-TIME AUDIT ARE TWO QUERIES (D-258). The
# result must declare both, and the STAGED post-mutation check inside the
# transaction must be untouched by the move — the audit is a diagnostic a caller
# asks later, never the thing that stops a bad success being built.
if ! grep -qF 'func support_progression_build_problem() -> String:' "$PROJECT_DIR/$RESULT"; then
	fail "the result declares no point-in-time build audit"
	seam=$((seam + 1))
fi
if ! grep -qF 'if reached != offer.support_rank_after:' "$PROJECT_DIR/$CHOICE"; then
	fail "the transaction no longer verifies the staged rank before spending the seed"
	seam=$((seam + 1))
fi
for script in "$CHOICE" "$RESULT"; do
	if grep -vE '^[[:space:]]*#' "$PROJECT_DIR/$script" \
			| grep -qE 'AcquiredSupports\.(ABSENT|FIRST)_RANK'; then
		fail "$script restates the accepted record's named ranks"
		seam=$((seam + 1))
	fi
done

if [[ "$seam" == "0" ]]; then
	pass "the transaction routes on the frozen kind to both accepted operations, takes no continuation decision, and the transition rule is written once"
fi

# --------------------------------------------------------------------------
step "4. The two extended scripts name nothing concrete, read nothing, compute nothing"
ambient=0
for script in "${EXTENDED_SCRIPTS[@]}"; do
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
	if grep -qE 'QuickStrike|quick_strike|PrototypePlayer|SkillSupportCatalogue|reaching_edge|sweeping_edge|card_power|card_vitality|Graveblade' "$PROJECT_DIR/$script"; then
		fail "$script names something concrete"
		ambient=$((ambient + 1))
	fi
	if grep -qE 'display_name|base_weight' "$PROJECT_DIR/$script"; then
		fail "$script reads a presentation name or an offer weight"
		ambient=$((ambient + 1))
	fi
	# A rank RECORDS PROGRESSION AND APPLIES NOTHING: no per-rank value, no
	# gameplay ceiling, no refund, and no arithmetic of its own. Comment lines are
	# stripped first — both files say in plain English that they apply no value,
	# and a scan that cannot tell the promise from the breach is worthless.
	if grep -vE '^[[:space:]]*#' "$PROJECT_DIR/$script" \
			| grep -qE 'rank_cap|max_rank|maximum_rank|diminish|multiplier|magnitude|refund'; then
		fail "$script carries a per-rank value, a ceiling or a refund"
		ambient=$((ambient + 1))
	fi
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
	pass "the ${#EXTENDED_SCRIPTS[@]} extended scripts store nothing, randomise nothing, read no ambient state, name nothing concrete, and do no arithmetic"
fi

# --------------------------------------------------------------------------
step "5. F4 added no production file"
unexpected=0
gd_count="$(find "$PROJECT_DIR/scripts/choices" -type f -name '*.gd' 2>/dev/null | wc -l | tr -d ' ')"
if [[ "$gd_count" != "3" ]]; then
	fail "scripts/choices/ holds $gd_count scripts, not the 3 Foundation D3 delivered"
	unexpected=$((unexpected + 1))
fi
offer_count="$(find "$PROJECT_DIR/scripts/offers" -type f -name '*.gd' 2>/dev/null | wc -l | tr -d ' ')"
if [[ "$offer_count" != "2" ]]; then
	fail "scripts/offers/ holds $offer_count scripts, not the 2 Foundation D1 delivered"
	unexpected=$((unexpected + 1))
fi
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
if [[ "$unexpected" == "0" ]]; then
	pass "scripts/choices/ holds exactly its 3 scripts and scripts/offers/ exactly its 2 — this foundation extended rather than added"
fi

# --------------------------------------------------------------------------
step "6. project.godot gained nothing"
settings=0
if grep -q '\[autoload\]' "$PROJECT_DIR/project.godot"; then
	fail "project.godot declares an [autoload] section"
	settings=$((settings + 1))
fi
if grep -qE 'RiftOffer|RiftRunBuild|SupportContinuation|AcquiredSupports' "$PROJECT_DIR/project.godot"; then
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
	printf 'RIFT SUPPORT RANK CHOICE SMOKE CHECKS: PASS\n'
	printf '  %s checks; %s of %s owed; %s protected files byte-identical\n' \
		"$EXPECTED_CHECKS" "$EXPECTED_OWED_CHECKS" "$EXPECTED_OWED_CHECKS" "${#PRESERVED_FILES[@]}"
	printf '  Roguelite Foundation F4 — Atomic Support Rank-Choice Consumption — is\n'
	printf '  DELIVERED under D-257, CORRECTED under D-258, and ACCEPTED and CLOSED at\n'
	printf '  the atomic support-progression choice-transaction mechanism level under\n'
	printf '  D-259.\n'
	reached_end=1
	exit 0
else
	printf 'RIFT SUPPORT RANK CHOICE SMOKE CHECKS: %d FAILURE(S)\n' "$failures"
	reached_end=1
	exit 1
fi
