#!/usr/bin/env bash
# Riftwrought — Roguelite Foundation G2 smoke checks: deterministic per-level
# offer-seed derivation (decision D-265).
#
# THIS IS NOT A GATE, AND IT DELIBERATELY RUNS NO LOCKED CHAIN.
#
# The foundation is TWO pure-logic scripts under `scripts/level_seeds/` plus this
# suite. It adds no scene, no resource, no asset, no InputMap action and no
# entrypoint change; it writes nothing to disk; it changes no gameplay value; and
# NOTHING THAT RUNS CALLS IT — the accepted single level-up coordinator still
# receives its offer's root seed explicitly from its caller, and the verification
# proves that by scanning every project file under `scripts/`, `scenes/`,
# `data/` and `addons/`, plus `project.godot`, and requiring that not one of them
# names either new class. Rerunning Gates A-F, 1A-1E, the Zone Composer, the
# three roguelite reviews or any accepted foundation — including D1, which G2
# will one day feed — to check an unwired derivation would be verification
# theatre over work that cannot have reached them.
#
# NO ACCEPTED SUITE WAS EDITED. The derivation names no accepted class, so no
# accepted verifier's allowlist had to move, and none of them is rerun from here.
#
# What this script proves:
#
#   1. every new script parses;
#   2. the pinned verification passes, proved in BOTH directions against a
#      replay of its own log, with every owed check reaching its last line;
#   3. the two scripts name nothing concrete, read no storage, no random source
#      and no ambient engine state, contain no loop, no floating-point literal and
#      no trace of the offer composer's mixer or lane domains, declare the three
#      frozen constants exactly as the brief spells them, and multiply exactly
#      twice between them — and nothing else in the project names either class,
#      checked in the shell as well as in the engine;
#   4. `scripts/level_seeds/` holds exactly the two scripts it should;
#   5. `project.godot` gained nothing;
#   6. the files this work could conceivably have disturbed are BYTE-IDENTICAL
#      ACROSS THE RUN — including both accepted D1 scripts, both E2 scripts and
#      both G1 scripts.
#
# IT READS NO OTHER SUITE. The verification names no file under `tests/` but its
# own, which step 3 asserts, so a rename or a formatting-only edit inside any
# other suite cannot change a result here.
#
# Usage, from the repository root:
#   game/tests/rift_level_offer_seed_smoke.sh

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
		printf '\nRIFT LEVEL OFFER SEED SMOKE CHECKS: ABORTED before the end of the script\n'
		printf '  the run stopped early (exit %s) — nothing after that point was proved\n' "$status"
		exit 1
	fi
	exit "$status"
}
trap on_exit EXIT

GODOT="${GODOT:-/Applications/Godot.app/Contents/MacOS/Godot}"
EXPECTED_VERSION="4.7.2.stable"
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

VERIFICATION="res://tests/rift_level_offer_seed_verification.gd"

# Pinned, and proved in both directions below.
EXPECTED_CHECKS=5466

# The number of check FUNCTIONS the suite owes, separate from the number of
# assertions. Pinned as a variable rather than written into the grep, because
# hard-coding it into the pattern goes stale the moment a check is added —
# reporting a failure whose text is the correct answer.
EXPECTED_OWED_CHECKS=21

NEW_SCRIPTS=(
	"scripts/level_seeds/rift_level_offer_seed_derivation.gd"
	"scripts/level_seeds/rift_level_offer_seed_reading.gd"
	"tests/rift_level_offer_seed_verification.gd"
)

G2_SCRIPTS=(
	"scripts/level_seeds/rift_level_offer_seed_derivation.gd"
	"scripts/level_seeds/rift_level_offer_seed_reading.gd"
)

DERIVATION="scripts/level_seeds/rift_level_offer_seed_derivation.gd"
READING="scripts/level_seeds/rift_level_offer_seed_reading.gd"

# The two global class names this foundation introduces. Nothing that runs may
# name either of them.
G2_CLASSES=(
	"RiftLevelOfferSeedDerivation"
	"RiftLevelOfferSeedReading"
)

# The three constants the owner's brief freezes, exactly as it spells them.
FROZEN_DECLARATIONS=(
	"const MASK_32: int = 0xFFFF_FFFF"
	"const RUN_HIGH_FOLD_STEP: int = 65_537"
	"const LEVEL_STEP: int = 1_000_003"
)

# DELIBERATELY SHORT, AND NOT A WHOLE-PROJECT CATALOGUE. These are the files this
# work could conceivably have disturbed: the project settings, the canonical
# combat record, every accepted foundation mechanism script — including the two
# D1 scripts whose root-seed behaviour G2 relies on, the two E2 scripts it is
# deliberately NOT wired into, and the two G1 scripts it stands beside — the
# temporary review's run plan that carries one of the four recorded finalizer
# copies, and the project owner's own composed zone. No other suite's file is in
# this list, because the verification reads none.
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
	"scripts/level_requirements/rift_level_requirement_curve.gd"
	"scripts/level_requirements/rift_level_requirement_reading.gd"
	"scripts/stats/passive_card_catalogue.gd"
	"scripts/stats/passive_card_definition.gd"
	"scripts/stats/passive_card_selection.gd"
	"scripts/stats/passive_card_selection_result.gd"
	"scripts/stats/player_stat_definition.gd"
	"scripts/stats/player_stat_totals.gd"
	"scripts/stats/player_stat_value.gd"
	"scripts/stats/player_stats.gd"
	"scripts/roguelite/roguelite_run_plan.gd"
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
# file fails to PARSE exits 0. `String formatting error` is E1's addition: a `%`
# that binds tighter than a `+` prints one and still exits zero.
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

# Every line of a script that is not a whole-line comment.
code_only() {
	grep -vE '^[[:space:]]*#' "$1"
}

printf 'Riftwrought — Roguelite Foundation G2: deterministic per-level offer-seed derivation (D-265)\n'
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
verify_log="/tmp/riftwrought_rift_level_offer_seed_verify.log"
"$GODOT" --headless --path "$PROJECT_DIR" --script "$VERIFICATION" > "$verify_log" 2>&1
verify_status=$?
assert_log_is_fresh "$verify_log"
assert_no_script_error "the headless level offer-seed verification" "$verify_log"

if [[ "$verify_status" == "0" ]]; then
	pass "the verification exited 0"
else
	fail "the verification exited $verify_status"
	grep -E "^  FAIL" "$verify_log" | head -20 | sed 's/^/        /'
fi

count="$(read_check_count "RIFT LEVEL OFFER SEED VERIFICATION" "$verify_log")"
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
replay="$(mktemp -t riftwrought_rift_level_offer_seed_replay)"
scratch_replay="$replay"
sed "s/RIFT LEVEL OFFER SEED VERIFICATION: PASS ($EXPECTED_CHECKS checks)/RIFT LEVEL OFFER SEED VERIFICATION: PASS ($((EXPECTED_CHECKS + 1)) checks)/" \
	"$verify_log" > "$replay"
replay_count="$(read_check_count "RIFT LEVEL OFFER SEED VERIFICATION" "$replay")"
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
25 refusals across 5 levels below 1, down to -9223372036854775808, and 5 run seeds: each echoed both inputs, named its level and carried -1
11 of 11 required examples exact: (0, 1) -> 0, (0, 2) -> 1000003, (0, 3) -> 2000006, (99, 1) -> 99, (99, 2) -> 1000102, (404, 1) -> 404, (404, 10) -> 9000431, (-1, 1) -> 4294901758, (-1, 2) -> 934465, (9223372036854775807, 1) -> 2147418110, (-9223372036854775808, 1) -> 2147483648
84 of 84 extended corpus rows exact; 95 distinct independently calculated questions
4111 of 4111 non-negative 32-bit run seeds, up to 4294967295, are their own Level-1 root; outside that range: 4294967296 -> 65537, -1 -> 4294901758, 9223372036854775807 -> 2147418110
384 single-bit flips over 6 run seeds (192 low, 192 high): 0 left the run key unchanged; 4096 high halves beside one low half gave 4096 run keys
collisions exist and are not hidden: 65537 and 4294967296 share run key 65537; -1 and 4294901758 share run key 4294901758; -9223372036854775808 and 2147483648 share run key 2147483648 — at all 7 levels asked
-1 and 9223372036854775807 are one question under the composer's mask (4294967295) and two under G2 (4294901758, 2147418110)
the engine's right shift keeps the sign (-1 >> 32 = -1); masked, the high half of -1 is 4294967295 and of -9223372036854775808 is 2147483648
29 negative corpus rows reproduced exactly, twice each; 25 of 25 constructed negative run seeds answered a non-negative root
928 run seeds x 22 levels = 20416 results: 0 refused, 0 incoherent, 0 outside 0 … 4294967295; lowest 0, highest 4294967295
sweep sum 44516600168232, xor 3145776, weighted sum 446334862375735476 and 5604 distinct roots — all four match the outside calculation
33 sampled questions asked three times each: every answer bit-identical and a fresh value; a tampered reading reached nothing
33 questions asked forwards, backwards, from both ends between extremes, and through two instances: 0 answers moved
16 of 16 rebuilt spellings agreed with typed answers; 33 of 33 readings reproduced from their own run seed and level
39996 of 39996 adjacent steps exactly 1000003 modulo 2^32; 9 edge steps across the period and at the top of the level range also exact
(4294967295, 1) -> 4294967295, (4294967295, 2) -> 1000002, (4294967294, 2) -> 1000001, (4294000000, 2) -> 32707, (0, 4295) -> 4294012882, (0, 4296) -> 45589; the first level-step wrap for run key 0 is at level 4296
level 1 and level 4294967297 share root 0 for run seed 0; 36 of 36 level triples 2^32 and 2 x 2^32 apart repeated; level 9223372036854775807 shares level 4294967295's root
THE SCHEDULE REPEATS EVERY 4294967296 LEVELS — a stated representation fact of the 32-bit seed domain, not a level cap
65536 consecutive levels from Level 1 for each of 4 run seeds, and 65536 straddling level 4294967296: 327680 levels walked, 0 duplicates; the detector finds the 1 planted
1000003 and 65537 are odd and coprime to 2^32; 1000003 x 2021759595 = 1 and 65537 x 4294901761 = 1 modulo 2^32
so level index -> root seed is a permutation of the 2^32 residues for every run key; 60 of 60 indices recovered by the inverse; an even step would collapse index 2^31 onto index 0
high x 65537 <= 281479271612415, + low <= 281483566579710; level_index x 1000003 <= 4294980179901885, + run_key <= 4294984474869180
INT64_MAX is 9223372036854775807: 2147 times the largest level sum and 32767 times the largest fold sum; each bound proved by division before any product is formed
floor guard, low mask, high mask, fold product, level-index mask, level product, answer at body lines [0, 3, 4, 5, 6, 7, 8]; 2 products, both of masked values; 5 masks
an unmasked, wrapping version would answer the same 4292967290 at level 9223372036854775807 (its product wraps to 9223372036852775802), so masking order is not observable in any answer and is pinned structurally
15 contradictory shapes caught by problem(); each restored reading is coherent again; 4 edge successes coherent
no scanned file outside the two G4 grants and not project.godot names a G2 class; E2 opens and D1 composes from an explicit root seed; 6 accepted D1, E2 and G1 files name nothing G2 introduced
3 frozen lane domains unchanged; D-239's documented rows 12345 and 0 reproduce all 6 lane seeds; 6 of 6 mask-equivalent roots are still one question
95 corpus roots survive the composer's mask unchanged; 6 of 6 end-to-end rows run seed -> root -> 3 lane seeds match; 16384 consecutive levels give 16384 distinct seeds in every lane
finding: a refusal's -1, handed onward without asking ok, composes exactly the offer of root 4294967295 — a root G2 itself derives for run seed 4294967295 at Level 1
G2 names no G1 class, constant or requirement; G1 names nothing G2 introduced; both begin at Level 1
separate boundaries: G1's exact-experience limit is level 360287970189636, G2's seed period is 4294967296 levels, and G2 answers at and beyond G1's limit
derivation: 0 instance fields, 0 declared variables, 1 of 1 methods static; reading: 5 scalar fields — ok, failure_reason, run_seed, level, offer_root_seed
2 scripts scanned: 0 forbidden tokens, 0 ambient reads, 0 deferred members, 0 loops, 0 float literals; 1 shift, by 32; 0 xors; 0 mixer or lane-domain constants in any spelling
numbers: derivation 1, 1000003, 32, 4294967295, 65537, reading 0, 1, 32; 5 signatures, 8 constants and 5 fields pinned
111 successes and 25 refusals were driven through the counting helpers
MEASURED

# --------------------------------------------------------------------------
step "3. The two scripts name nothing concrete, read nothing ambient, mix nothing, and are unwired"
ambient=0
for script in "${G2_SCRIPTS[@]}"; do
	if grep -qE 'user://|ConfigFile|ResourceSaver|ResourceLoader|FileAccess' "$PROJECT_DIR/$script"; then
		fail "$script names a storage path or a writer"
		ambient=$((ambient + 1))
	fi
	if grep -qE 'randi|randf|randomize|RandomNumberGenerator|rand_from_seed' "$PROJECT_DIR/$script"; then
		fail "$script reads a global random source"
		ambient=$((ambient + 1))
	fi
	if grep -qE 'Time\.|OS\.|Engine\.|ProjectSettings|InputMap|get_tree|get_node' "$PROJECT_DIR/$script"; then
		fail "$script reads ambient engine state"
		ambient=$((ambient + 1))
	fi
	# A seed derivation is handed a run seed and a level. Naming a card, a Skill
	# or any accepted foundation would make it a caller of something — and several
	# accepted suites grep the whole tree for exactly these names, so a stray one
	# even in a comment would turn an accepted suite red.
	if grep -qE 'QuickStrike|quick_strike|Graveblade|PassiveCard|SkillSupport|SupportSelection|SupportContinuation|RiftExperience|RiftLevelUp|RiftLevelRequirement|RiftOffer|RiftRunBuild|RiftConsumptionLedger|ExperienceTable|CharacterState' "$PROJECT_DIR/$script"; then
		fail "$script names a card, a Skill or an accepted foundation"
		ambient=$((ambient + 1))
	fi
	# NO MIXER AND NO LANE DOMAIN: the offer composer's finalizer multipliers and
	# frozen lane domains, in any spelling, comments included.
	if grep -qiE '7feb_?352d|846c_?a68b|6a09|bb67|3c6e|2146121005|2221713035|1779033703|3144134277|1013904242' "$PROJECT_DIR/$script"; then
		fail "$script restates the offer composer's mixer or lane domains"
		ambient=$((ambient + 1))
	fi
	# Comment lines are stripped for the next two: both files say in plain English
	# that they hold no loop and no queue, and a scan that cannot tell the promise
	# from the breach is worthless — Gate 1C's lesson, kept.
	if code_only "$PROJECT_DIR/$script" | grep -qE '^[[:space:]]*(for|while)[[:space:]]'; then
		fail "$script loops"
		ambient=$((ambient + 1))
	fi
	strays="$(code_only "$PROJECT_DIR/$script" | grep -oE '[0-9]+\.[0-9]+' | sort -u | tr '\n' ' ')"
	if [[ -n "${strays// /}" ]]; then
		fail "$script carries the floating-point literal(s) ${strays}"
		ambient=$((ambient + 1))
	fi
done
# TWO PRODUCTS, ONE SHIFT, NO XOR in the derivation's code, and no product or
# addition in the result type's.
products="$(code_only "$PROJECT_DIR/$DERIVATION" | grep -c '\*' | tr -d ' ')"
if [[ "$products" != "2" ]]; then
	fail "the derivation's code multiplies on $products lines, not 2"
	ambient=$((ambient + 1))
fi
shifts="$(code_only "$PROJECT_DIR/$DERIVATION" | grep -o '>>' | wc -l | tr -d ' ')"
if [[ "$shifts" != "1" ]] || code_only "$PROJECT_DIR/$DERIVATION" | grep -q '\^'; then
	fail "the derivation's code shifts $shifts times or xors — the shape of a mixer"
	ambient=$((ambient + 1))
fi
if code_only "$PROJECT_DIR/$READING" | grep -qE '\*| \+ '; then
	fail "the result type multiplies or adds"
	ambient=$((ambient + 1))
fi
# THE FROZEN CONSTANTS, spelled exactly as the brief spells them, each once.
for declaration in "${FROZEN_DECLARATIONS[@]}"; do
	if [[ "$(grep -cxF "$declaration" "$PROJECT_DIR/$DERIVATION" | tr -d ' ')" != "1" ]]; then
		fail "the derivation does not declare '$declaration' exactly once"
		ambient=$((ambient + 1))
	fi
done
if [[ "$ambient" == "0" ]]; then
	pass "the ${#G2_SCRIPTS[@]} scripts store nothing, randomise nothing, read no ambient state, name nothing concrete, restate no mixer or domain, loop nowhere, hold no float literal, multiply twice, shift once and declare the ${#FROZEN_DECLARATIONS[@]} frozen constants exactly"
fi

# IT READS NO OTHER SUITE. The verification may name no file under `tests/` but
# its own, so nothing another suite names, formats or moves can change a result
# here — measured from outside the engine, with a floor on what was read so that
# an empty file cannot pass for a clean one.
verification_source="$PROJECT_DIR/tests/rift_level_offer_seed_verification.gd"
named_tests="$(grep -oE 'res://tests/[A-Za-z0-9_]+\.gd' "$verification_source" | sort -u | tr '\n' ' ')"
if [[ "$(wc -l < "$verification_source" | tr -d ' ')" -lt 1000 ]]; then
	fail "the verification read as too short for this scan to prove anything"
elif [[ "$named_tests" == "res://tests/rift_level_offer_seed_verification.gd " ]]; then
	pass "the verification names no file under tests/ but its own, so it reads no other suite"
else
	fail "the verification names other test files: ${named_tests}"
fi

# NOTHING THAT RUNS CALLS IT, measured a second time from outside the engine.
#
# IT ASSERTS A FLOOR ON WHAT IT SEARCHED: `grep -rl` over a directory that does
# not exist returns nothing and looks exactly like a clean result.
searched="$(find "$PROJECT_DIR/scripts" "$PROJECT_DIR/scenes" "$PROJECT_DIR/data" \
	"$PROJECT_DIR/addons" -type f \( -name '*.gd' -o -name '*.tscn' -o -name '*.tres' \) \
	2>/dev/null | wc -l | tr -d ' ')"
if [[ "${searched:-0}" -gt 100 ]]; then
	pass "the shell-side scan read $searched project files"
else
	fail "the shell-side scan found only ${searched:-0} project files, so it proves nothing"
fi

referenced=0
for name in "${G2_CLASSES[@]}"; do
	while IFS= read -r hit; do
		case "$hit" in
			*/scripts/level_seeds/rift_level_offer_seed_derivation.gd|*/scripts/level_seeds/rift_level_offer_seed_reading.gd)
				continue ;;
		esac
		# D-269: the Foundation G4 run-level coordinator asks this derivation for
		# each level's root seed, and the run-level record re-derives its root
		# through it; both name both classes. Granted in the verification's own
		# per-file allowlist; nothing that runs calls either.
		case "$hit" in
			*/scripts/levels/rift_run_level_coordinator.gd|*/scripts/levels/rift_run_level_up_result.gd)
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
	pass "nothing under scripts/, scenes/, data/ or addons/ but the two G4 files, and nothing in project.godot, names a Foundation G2 class"
fi

# --------------------------------------------------------------------------
step "4. The new directory holds exactly what it should"
# A scratch probe left behind is a project file nobody meant to ship, and it
# would be invisible to every scan above that filters on a known path.
unexpected=0
while IFS= read -r entry; do
	case "$(basename "$entry")" in
		rift_level_offer_seed_derivation.gd|rift_level_offer_seed_derivation.gd.uid| \
		rift_level_offer_seed_reading.gd|rift_level_offer_seed_reading.gd.uid)
			continue ;;
	esac
	fail "scripts/level_seeds/ holds the unexpected file $(basename "$entry")"
	unexpected=$((unexpected + 1))
done < <(find "$PROJECT_DIR/scripts/level_seeds" -type f 2>/dev/null)
gd_count="$(find "$PROJECT_DIR/scripts/level_seeds" -type f -name '*.gd' 2>/dev/null | wc -l | tr -d ' ')"
if [[ "$gd_count" != "2" ]]; then
	fail "scripts/level_seeds/ holds $gd_count scripts, not 2"
elif [[ "$unexpected" == "0" ]]; then
	pass "scripts/level_seeds/ holds exactly the two scripts and their two uid files"
fi

# --------------------------------------------------------------------------
step "5. project.godot gained nothing"
settings=0
if grep -q '\[autoload\]' "$PROJECT_DIR/project.godot"; then
	fail "project.godot declares an [autoload] section"
	settings=$((settings + 1))
fi
if ! grep -q 'run/main_scene="res://scenes/app/prototype_app.tscn"' "$PROJECT_DIR/project.godot"; then
	fail "the project entrypoint is not the Prototype App"
	settings=$((settings + 1))
fi
if [[ "$settings" == "0" ]]; then
	pass "no autoload, and the entrypoint is still the Prototype App"
fi

# --------------------------------------------------------------------------
step "6. Nothing that already existed changed"
index=0
moved=0
for file in "${PRESERVED_FILES[@]}"; do
	after="$(fingerprint "$PROJECT_DIR/$file")"
	if [[ "$after" == "MISSING" ]]; then
		fail "$file is missing, so its fingerprint proves nothing"
		moved=$((moved + 1))
	elif [[ "$after" != "${before_prints[$index]}" ]]; then
		fail "$file changed during this run"
		moved=$((moved + 1))
	fi
	index=$((index + 1))
done
if [[ "$moved" == "0" ]]; then
	pass "${#PRESERVED_FILES[@]} protected files are present and byte-identical before and after"
fi

# --------------------------------------------------------------------------
printf '\n'
if [[ "$failures" == "0" ]]; then
	printf 'RIFT LEVEL OFFER SEED SMOKE CHECKS: PASS\n'
	printf '  %s checks; %s of %s owed; %s protected files byte-identical\n' \
		"$EXPECTED_CHECKS" "$EXPECTED_OWED_CHECKS" "$EXPECTED_OWED_CHECKS" "${#PRESERVED_FILES[@]}"
	printf '  Roguelite Foundation G2 — Deterministic Per-Level Offer-Seed Derivation —\n'
	printf '  is DELIVERED under D-265 and ACCEPTED and CLOSED at the deterministic\n'
	printf '  per-level offer-seed derivation mechanism level under D-266.\n'
	reached_end=1
	exit 0
else
	printf 'RIFT LEVEL OFFER SEED SMOKE CHECKS: %d FAILURE(S)\n' "$failures"
	reached_end=1
	exit 1
fi
