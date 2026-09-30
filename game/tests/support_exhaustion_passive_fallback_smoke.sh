#!/usr/bin/env bash
# Riftwrought — Roguelite Foundation I6 smoke checks: Deterministic Exhausted-Support
# Passive Fallback Selection (decision D-304).
#
# THIS IS NOT A GATE, AND IT RUNS NO LOCKED CHAIN.
#
# I6 is a headless MECHANISM. When the accepted support continuation reports honest
# exhaustion, it chooses — deterministically — the passive card the support lane would
# carry instead: from the supplied records, excluding the Combat and Defence card and
# the Utility card the same offer already carries, uniformly between the two
# categories when both keep a card, and by the accepted integer weights within the
# chosen one. It adds two scripts under `scripts/fallback/` and extends the accepted
# passive selector with an exclusion-aware draw and a public record check. NOTHING
# THAT RUNS CALLS IT: no offer, choice, panel or runtime is wired to it. It adds no
# scene, panel, HUD, evidence frame, asset, `.tres`, InputMap action or storage, and it
# is not the entrypoint. What this script proves:
#
#   0. the engine is the locked 4.7.2 and every protected file is fingerprinted;
#   1. the two new scripts, the edited selector, the new suite and the five accepted
#      suites whose allowlists moved one for one all parse, and the three accepted
#      runners edited beside them are valid shell;
#   2. the pinned verification passes — its check count AND its owed-check count each
#      proved in BOTH directions against a replay of its own log — with zero SCRIPT
#      ERROR, zero engine ERROR and zero engine WARNING, and the measured lines read out
#      of its own log;
#   3. the two new files name exactly the project classes recorded below and no
#      concrete card, Skill or support, read no ambient state, and nothing under
#      scripts/, scenes/, data/ or addons/ — nor project.godot — names either new
#      class; the selector's class set is unchanged; scripts/fallback/ holds exactly its
#      two scripts — in the shell as well as in the engine;
#   4. project.godot is untouched: 31 actions, the Prototype App entrypoint, no
#      [autoload];
#   5. the run wrote nothing, .godot/ is byte-identical across it, every protected file
#      is byte-identical, and the project owner's own user:// files are untouched.
#
# Usage, from the repository root:
#   game/tests/support_exhaustion_passive_fallback_smoke.sh

set -uo pipefail

# Assigned at the TOP of the script, never beside the function it serves (Gate 1E).
RUN_STARTED_AT="$(date +%s)"

reached_end=0
scratch_replay=""
run_marker=""
on_exit() {
	local status=$?
	[[ -n "$scratch_replay" ]] && rm -f "$scratch_replay"
	[[ -n "$run_marker" ]] && rm -f "$run_marker"
	if [[ "$reached_end" != "1" ]]; then
		printf '\nSUPPORT EXHAUSTION PASSIVE FALLBACK SMOKE CHECKS: ABORTED before the end of the script\n'
		printf '  the run stopped early (exit %s) — nothing after that point was proved\n' "$status"
		exit 1
	fi
	exit "$status"
}
trap on_exit EXIT

GODOT="${GODOT:-/Applications/Godot.app/Contents/MacOS/Godot}"
EXPECTED_VERSION="4.7.2.stable"
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

THIS_VERIFICATION="tests/support_exhaustion_passive_fallback_verification.gd"
VERIFICATION="res://$THIS_VERIFICATION"
VERIFY_BANNER="SUPPORT EXHAUSTION PASSIVE FALLBACK VERIFICATION"

# Pinned, and proved in both directions below.
EXPECTED_CHECKS=103
EXPECTED_OWED_CHECKS=22
EXPECTED_INPUT_ACTIONS=31
EXPECTED_MAIN_SCENE="res://scenes/app/prototype_app.tscn"

NEW_PRODUCTION=(
	"scripts/fallback/support_exhaustion_passive_fallback.gd"
	"scripts/fallback/support_exhaustion_passive_fallback_result.gd"
)
EDITED_PRODUCTION=(
	"scripts/stats/passive_card_selection.gd"
)
# The five accepted verifications whose allowlists I6 moved one for one.
MOVED_SUITES=(
	"tests/passive_card_selection_verification.gd"
	"tests/passive_card_records_verification.gd"
	"tests/player_stat_vocabulary_verification.gd"
	"tests/support_continuation_verification.gd"
	"tests/maximum_rank_support_filtering_verification.gd"
)
# The three accepted runners edited beside them: an allowlist row or a measured line.
MOVED_RUNNERS=(
	"tests/passive_card_selection_smoke.sh"
	"tests/support_continuation_smoke.sh"
	"tests/maximum_rank_support_filtering_smoke.sh"
)
NEW_CLASSES=("SupportExhaustionPassiveFallback" "SupportExhaustionPassiveFallbackResult")

# Exactly the project classes each file names, sorted.
EXPECTED_FALLBACK_NAMES="PassiveCardDefinition PassiveCardSelection PassiveCardSelectionResult PlayerStatDefinition SupportContinuation SupportContinuationResult SupportExhaustionPassiveFallback SupportExhaustionPassiveFallbackResult"
EXPECTED_RESULT_NAMES="PassiveCardSelection PassiveCardSelectionResult SupportExhaustionPassiveFallback SupportExhaustionPassiveFallbackResult"
EXPECTED_SELECTOR_NAMES="PassiveCardDefinition PassiveCardSelection PassiveCardSelectionResult PlayerStatDefinition"
EXPECTED_FALLBACK_DIR="support_exhaustion_passive_fallback.gd support_exhaustion_passive_fallback.gd.uid support_exhaustion_passive_fallback_result.gd support_exhaustion_passive_fallback_result.gd.uid"

# DELIBERATELY SHORT, AND NOT A WHOLE-PROJECT CATALOGUE: the files I6 reads, stands
# beside or could conceivably disturb, and the project owner's work. Every `.tres` under
# data/ is added below, enumerated rather than typed.
PRESERVED_FILES=(
	"project.godot"
	"../CLAUDE.md"
	"../README.md"
	"scenes/first_mvp/zone_composer_practice.tscn"
	"assets/prototype/ui/loading/riftwrought-loading-teaser-v1.png"
	"assets/prototype/ui/loading/riftwrought-loading-teaser-v1.png.import"
	"scripts/stats/passive_card_definition.gd"
	"scripts/stats/passive_card_catalogue.gd"
	"scripts/stats/passive_card_selection_result.gd"
	"scripts/stats/player_stat_definition.gd"
	"scripts/stats/player_stats.gd"
	"scripts/stats/player_stat_value.gd"
	"scripts/stats/player_stat_totals.gd"
	"scripts/skills/support_definition.gd"
	"scripts/skills/support_selection.gd"
	"scripts/skills/support_selection_result.gd"
	"scripts/skills/skill_support_catalogue.gd"
	"scripts/skills/acquired_supports.gd"
	"scripts/skills/skill_tag_profile.gd"
	"scripts/skills/skill_tags.gd"
	"scripts/skills/support_eligibility.gd"
	"scripts/continuation/support_continuation.gd"
	"scripts/continuation/support_continuation_result.gd"
	"scripts/offers/rift_offer.gd"
	"scripts/offers/rift_offer_composition.gd"
	"scripts/choices/rift_offer_choice.gd"
	"scripts/choices/rift_offer_choice_result.gd"
	"scripts/choices/rift_consumption_ledger.gd"
	"scripts/levels/rift_level_up_coordinator.gd"
	"scripts/levels/rift_level_up_result.gd"
	"scripts/levels/rift_run_level_coordinator.gd"
	"scripts/runs/rift_run_build.gd"
	"scripts/experience/rift_mote_runtime.gd"
	"scripts/roguelite/live_effects/rift_build_application.gd"
	"scripts/roguelite/live_effects/rift_build_application_result.gd"
	"scripts/roguelite/level_up/roguelite_level_up_choice_review.gd"
	"scripts/roguelite/level_up/rift_level_up_offer_panel.gd"
	"scripts/ui/first_mvp_modal.gd"
	"scripts/combat/quick_strike_action.gd"
	"scripts/combat/quick_strike_data.gd"
	"scripts/actors/prototype_player.gd"
	"tests/rift_offer_composition_verification.gd"
	"tests/rank_aware_offer_composition_verification.gd"
	"tests/rift_support_rank_choice_verification.gd"
	"tests/rift_level_up_support_progression_verification.gd"
	"tests/support_selection_verification.gd"
	"tests/ranked_support_ownership_verification.gd"
)
while IFS= read -r tres; do
	PRESERVED_FILES+=("${tres#"$PROJECT_DIR/"}")
done < <(find "$PROJECT_DIR/data" -type f -name '*.tres' | sort)

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

state_fingerprint() {
	if [[ -f "$1" ]]; then
		shasum -a 256 "$1" | awk '{print $1}'
	else
		echo "ABSENT"
	fi
}

godot_tree_fingerprint() {
	(cd "$PROJECT_DIR/.godot" && find . -type f -print0 | sort -z | xargs -0 shasum -a 256) \
		| shasum -a 256 | awk '{print $1}'
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

# The project classes a file names, sorted, read from the engine's own class cache.
named_classes() {
	local file="$1" class found=""
	while IFS= read -r class; do
		[[ -n "$class" ]] && grep -qF -- "$class" "$file" && found="$found $class"
	done <<< "$PROJECT_CLASSES"
	echo "$found" | tr ' ' '\n' | grep -v '^$' | sort | tr '\n' ' ' | sed 's/ $//'
}

printf 'Riftwrought — Roguelite Foundation I6: Exhausted-Support Passive Fallback (D-304)\n'
printf 'project: %s\n' "$PROJECT_DIR"

# --------------------------------------------------------------------------
step "0. Godot version, and the before-fingerprints"
version="$("$GODOT" --version 2>/dev/null | tail -1)"
printf '  installed: %s\n' "$version"
if [[ "$version" == "$EXPECTED_VERSION"* ]]; then
	pass "matches the locked $EXPECTED_VERSION baseline"
else
	fail "expected $EXPECTED_VERSION (locked by D-167)"
fi

declare -a BEFORE_HASHES=()
missing_preserved=0
for file in "${PRESERVED_FILES[@]}"; do
	hash="$(fingerprint "$PROJECT_DIR/$file")"
	BEFORE_HASHES+=("$hash")
	if [[ "$hash" == "MISSING" ]]; then
		fail "$file is missing"
		missing_preserved=$((missing_preserved + 1))
	fi
done
if [[ "$missing_preserved" == "0" ]]; then
	pass "${#PRESERVED_FILES[@]} protected file(s) fingerprinted"
fi

godot_before="$(godot_tree_fingerprint)"
run_marker="$(mktemp -t riftwrought_exhaustion_fallback_marker)"
pass ".godot/ fingerprinted as one tree, and a start-of-run marker laid"

project_name="$(sed -n 's/^config\/name="\(.*\)"[[:space:]]*$/\1/p' "$PROJECT_DIR/project.godot" | head -1)"
production_dir="$HOME/Library/Application Support/Godot/app_userdata/$project_name"
settings_before="$(state_fingerprint "$production_dir/prototype_settings.cfg")"
lab_before="$(state_fingerprint "$production_dir/prototype_zero.cfg")"
character_before="$(state_fingerprint "$production_dir/riftwrought_character.cfg")"
pass "the project owner's own three user:// files fingerprinted"

# --------------------------------------------------------------------------
step "1. Every new and edited script and every moved suite parses; every edited runner is valid shell"
for script in "${NEW_PRODUCTION[@]}" "${EDITED_PRODUCTION[@]}" "$THIS_VERIFICATION" "${MOVED_SUITES[@]}"; do
	if [[ ! -f "$PROJECT_DIR/$script" ]]; then
		fail "$script is missing"
		continue
	fi
	out="$("$GODOT" --headless --path "$PROJECT_DIR" --check-only --script "res://$script" 2>&1 \
		| grep -v '^Godot Engine')"
	if [[ -z "$out" ]]; then
		pass "$script parses"
	else
		fail "$script does not parse"
		printf '%s\n' "$out" | head -10 | sed 's/^/        /'
	fi
done
for runner in "${MOVED_RUNNERS[@]}" "tests/support_exhaustion_passive_fallback_smoke.sh"; do
	if bash -n "$PROJECT_DIR/$runner" 2>/dev/null; then
		pass "$runner is valid shell"
	else
		fail "$runner is not valid shell"
	fi
done

# --------------------------------------------------------------------------
step "2. The pinned verification passes, proved in BOTH directions"
verify_log="/tmp/riftwrought_support_exhaustion_passive_fallback_verify.log"
"$GODOT" --headless --path "$PROJECT_DIR" --script "$VERIFICATION" > "$verify_log" 2>&1
verify_status=$?
assert_log_is_fresh "$verify_log"

if [[ "$verify_status" == "0" ]]; then
	pass "the verification exited 0"
else
	fail "the verification exited $verify_status"
	grep -E "^  FAIL" "$verify_log" | head -20 | sed 's/^/        /'
fi

script_errors="$(grep -cE "SCRIPT ERROR|String formatting error" "$verify_log" | tr -d ' ')"
if [[ "$script_errors" == "0" ]]; then
	pass "the verification produced no SCRIPT ERROR"
else
	fail "the verification produced $script_errors SCRIPT ERROR line(s)"
	grep -A3 -E "SCRIPT ERROR|String formatting error" "$verify_log" | head -20 | sed 's/^/        /'
fi
engine_lines="$(grep -cE "^(ERROR|WARNING):" "$verify_log" | tr -d ' ')"
if [[ "$engine_lines" == "0" ]]; then
	pass "the verification produced no engine ERROR and no engine WARNING line"
else
	fail "the verification produced $engine_lines engine ERROR or WARNING line(s)"
	grep -A2 -E "^(ERROR|WARNING):" "$verify_log" | head -20 | sed 's/^/        /'
fi

count="$(read_check_count "$VERIFY_BANNER" "$verify_log")"
if [[ "$count" == "$EXPECTED_CHECKS" ]]; then
	pass "verification passes at the pinned $EXPECTED_CHECKS checks"
else
	fail "verification reports ${count:-no} checks, not $EXPECTED_CHECKS"
fi

# The negative direction must READ the moved number, not merely "not the pinned one":
# a bare `!=` is satisfied by an empty read on exactly the runs that need catching.
replay="$(mktemp -t riftwrought_exhaustion_fallback_replay)"
scratch_replay="$replay"
sed "s/$VERIFY_BANNER: PASS ($EXPECTED_CHECKS checks)/$VERIFY_BANNER: PASS ($((EXPECTED_CHECKS + 1)) checks)/" \
	"$verify_log" > "$replay"
replay_count="$(read_check_count "$VERIFY_BANNER" "$replay")"
if [[ -z "$count" ]]; then
	fail "the verification printed no count line, so the count pin proves nothing this run"
elif [[ "$replay_count" == "$((EXPECTED_CHECKS + 1))" ]]; then
	pass "and that pin reads a log whose count moved by one as $replay_count, refusing it"
else
	fail "the count pin read '${replay_count:-nothing}' from a moved log and therefore proves nothing"
fi

owed_pattern="^  $EXPECTED_OWED_CHECKS of $EXPECTED_OWED_CHECKS owed checks completed"
if grep -qE "$owed_pattern" "$verify_log"; then
	pass "all $EXPECTED_OWED_CHECKS owed checks reached their last line"
else
	fail "the owed-set report is missing or short"
	grep -E "owed checks" "$verify_log" | sed 's/^/        /'
fi
sed -E "s/^  $EXPECTED_OWED_CHECKS of $EXPECTED_OWED_CHECKS owed/  $((EXPECTED_OWED_CHECKS - 1)) of $EXPECTED_OWED_CHECKS owed/" \
	"$verify_log" > "$replay"
short_refused=0
grep -qE "$owed_pattern" "$replay" || short_refused=1
sed -E "s/^  $EXPECTED_OWED_CHECKS of $EXPECTED_OWED_CHECKS owed/  $EXPECTED_OWED_CHECKS of $((EXPECTED_OWED_CHECKS + 1)) owed/" \
	"$verify_log" > "$replay"
long_refused=0
grep -qE "$owed_pattern" "$replay" || long_refused=1
if [[ "$short_refused" == "1" && "$long_refused" == "1" ]]; then
	pass "the owed pin refuses '$((EXPECTED_OWED_CHECKS - 1)) of $EXPECTED_OWED_CHECKS' and '$EXPECTED_OWED_CHECKS of $((EXPECTED_OWED_CHECKS + 1))'"
else
	fail "the owed pin accepted a moved owed-set report"
fi

measured=0
measured_total=0
while IFS= read -r line; do
	measured_total=$((measured_total + 1))
	if grep -qF -- "$line" "$verify_log"; then
		measured=$((measured + 1))
		pass "measured: ${line}"
	else
		fail "the verification log does not report: ${line}"
	fi
done <<'MEASURED'
sources: Combat and Defence card_celerity (tickets 0-99 of 300), Utility card_fleetness (tickets 0-99 of 300); the support lane exhausted: true
fallback candidates: Combat and Defence [card_power x100, card_vitality x100] | Utility [card_insight x100, card_magnetism x100]; category ladder [0, 1]: position 0 Combat and Defence, position 1 Utility
400 fallbacks over the complete grid (2 category x 200 card tickets): card_insight 100, card_magnetism 100, card_power 100, card_vitality 100; card_celerity 0, card_fleetness 0; Combat and Defence 200, Utility 200
category ticket 0 -> Combat and Defence, 1 -> Utility; card tickets 0-99 -> card_power / card_insight, 100-199 -> card_vitality / card_magnetism; 11 of 11 typed boundaries hold
64 of 64 shipped R2 S2 continuations exhausted and 64 of 64 fallbacks activated; a record from the accepted exhaustion constructor activates identically
192 new-pair and 192 rank-increase decisions over 6 shipped states x 64 seeds: 384 refused whole, 0 partial
3 of 3 ordinary Support refusals (no definitions, an invalid definition, no compatible support) refused whole, quoting the continuation
4 above-maximum states x 64 seeds: 0 continuations exhausted, 256 of 256 fallbacks refused, quoting the invalid state
6 of 6 forged or incoherent records refused as incoherent before their classification is read; a null continuation is refused
STATED LIMITATION: a COHERENT record built by the accepted exhaustion constructor activates (check 1); the fallback trusts that classification and is not handed the support inputs to re-prove it.
8 of 8 source faults (2 missing, 4 incoherent, 2 refused) refused whole, with no category, card, ticket or derivation
24 of 24 cases (swapped, both Combat and Defence, both Utility x 8 ticket pairs) refused whole, naming the category each was drawn from
3 of 3 refused whole: an offered card absent from the records, one filed under the other category, and one card offered by both lanes
48 of 48 cases over 6 faults (both excluded cards, a card in each unreached category, an unknown stat, a null) x 8 ticket pairs refused whole; 64 of 64 seeds refuse the unreached Utility fault; the clean control accepts 8 of 8
3600 fallbacks over all 9 source pairs x the complete 2 x 200 grid: an offered card returned 0 times and on a nested ladder 0 times; each pair's 4 remaining cards own exactly 100 of 400 (0 uneven)
shipped (card ladders 200 / 200): 1000 category tickets 500 / 500, the 200 x 2 grid 200 / 200
deep Combat and Defence (card ladders 1551 / 200): 1000 category tickets 500 / 500, the 1551 x 2 grid 1551 / 1551
deep Utility (card ladders 200 / 1551): 1000 category tickets 500 / 500, the 1551 x 2 grid 1551 / 1551
Combat and Defence after excluding card_celerity: [zz_first x4, zz_second x6, zz_third x5] over 15 tickets — ownership zz_first 4, zz_second 6, zz_third 5; 0/3 -> first, 4/9 -> second, 10/14 -> third, 15 wraps to first; 0 of 15 nested draws differ from the accepted selector called directly
3200 answers over 8 variants (reversed, rotated and interleaved cards; renamed and name-swapped cards; reversed support definitions, reversed Skill tags, a renamed Skill) x the complete 2 x 200 grid: 0 moved
32 of 32 cases over 4 duplicate shapes (a remaining or an offered card twice, an id shared with an offered or a remaining card) x 8 ticket pairs refused whole — none weighed twice
a remaining Combat and Defence pool totalling exactly 4294967295 (the full lane ladder 4294967296 refuses): 5 of 5 boundaries hold at 0, 3999999999, 4000000000, 4294967294 and the wrap; the Utility side answers zz_u_other
one past the ceiling: 6 of 6 ticket pairs — including category ticket 1, which would choose Utility — and 64 of 64 seeds refuse whole before any category is chosen
Utility holds only the offered card: Combat and Defence owns 20 of 20 (10 category tickets x 2 card tickets), the category ladder [0]
Combat and Defence holds only the offered card: Utility owns 20 of 20 (10 category tickets x 2 card tickets), the category ladder [1]
the two-card catalogue [card_celerity, card_fleetness]: 16 of 16 ticket pairs and 64 of 64 seeds are fallback-unavailable, each with no category, card, ticket, candidate or nested draw (16 bare): 'no passive card remains in either category once the two cards this offer already carries are excluded'
Support exhaustion: SupportContinuationResult.is_exhausted() true | fallback unavailable: is_unavailable() true, ok false | malformed: ok false, is_unavailable() false | a non-exhausted Support refusal: is_unavailable() false | a success: ok true
the classification is written in 1 place and read by its predicate; neither new file inspects refusal text (0 matches); the mechanism reads the Support classification once, through is_exhausted()
17 of 17 frozen corpus rows exact (category, card and both raw tickets); 17 reproduce through select_with_tickets(); 17 match an independent in-suite derivation; 17 are unchanged with card, source and Support arrays reversed; 4 of 4 remaining cards reached
stage domains 0xA54FF53A (category) and 0x510E527F (card), read through the Combat and Defence stream: distinct from the 3 lane domains and 2 stream salts; 0 of 100 repeats drift; 0 negative tickets
seed 51507111 (F3's worked support lane seed for root seed 18) -> category ticket 3141935186 -> Combat and Defence, card ticket 1617272035 -> card_power
appending to, overwriting and clearing candidate_categories(), excluded_card_ids() and selection() changed 0 stored facts; each selection() is a new object; a refusal hands out empty copies and no draw
19 of 19 C3 corpus rows exact; 1200 draws over both orders and both categories identical through select_with_ticket() and the empty exclusion; 9 of 9 accepted refusals unchanged, the record check returning each record fault's own words
7 of 7 extension refusals (unknown or blank id, an id twice, every card excluded, no card in the category, and record and category faults taking precedence); excluding a Utility card moves 0 Combat and Defence draws; excluding card_celerity leaves card_power 100, card_vitality 100
root seed 18: Support quick_strike -> sweeping_edge 1 -> 2, card_power, card_insight; both pairs at rank 2: the offer composes the I7 passive fallback card_celerity (D-306)
24 of 24 accepted production files byte-identical by SHA-256 prefix
9 shipped states x 64 seeds: 320 new pairs, 192 rank increases, 64 exhausted with the accepted reason, 0 unexpected; maximum ranks [reaching_edge 2, sweeping_edge 2]
2 files scanned raw: 0 concrete names, 0 ambient reads; 0 ladder or card-field tokens in code
methods pinned: mechanism 6, result 10, selector 7; the result carries 11 fields; mechanism and selector state: 0 fields
running files scanned: none beyond the 2 granted offer files names either new class; project.godot: 31 actions, the Prototype App entrypoint, no [autoload]; scripts/fallback/ holds its 2 scripts and 2 uid files; 4 of 4 granting suites and I5 list the new files; 6 of 6 shipped records unchanged
1007 refusals were driven across this suite
MEASURED
if [[ "$measured" == "$measured_total" ]]; then
	pass "$measured of $measured_total measured lines found in the run's own log"
fi

# --------------------------------------------------------------------------
step "3. The new files name exactly their classes and nothing concrete, and nothing that runs names them"
PROJECT_CLASSES="$(grep -oE '"class": &"[A-Za-z0-9_]+"' "$PROJECT_DIR/.godot/global_script_class_cache.cfg" \
	| sed -E 's/.*&"([^"]+)"/\1/' | sort -u)"
class_total="$(printf '%s\n' "$PROJECT_CLASSES" | grep -c .)"
if [[ "$class_total" -gt 150 ]] && printf '%s\n' "$PROJECT_CLASSES" | grep -qx "${NEW_CLASSES[0]}" \
		&& printf '%s\n' "$PROJECT_CLASSES" | grep -qx "${NEW_CLASSES[1]}"; then
	pass "the engine's class cache lists $class_total project classes, both new ones among them"
else
	fail "the class cache lists $class_total classes and not both new ones"
fi
for row in "scripts/fallback/support_exhaustion_passive_fallback.gd|$EXPECTED_FALLBACK_NAMES" \
		"scripts/fallback/support_exhaustion_passive_fallback_result.gd|$EXPECTED_RESULT_NAMES" \
		"scripts/stats/passive_card_selection.gd|$EXPECTED_SELECTOR_NAMES"; do
	file="${row%%|*}"
	expected="${row#*|}"
	actual="$(named_classes "$PROJECT_DIR/$file")"
	if [[ "$actual" == "$expected" ]]; then
		pass "$file names exactly [$actual]"
	else
		fail "$file names [$actual], not [$expected]"
	fi
done

leaked=0
for file in "${NEW_PRODUCTION[@]}"; do
	if grep -qE 'card_(power|celerity|vitality|fleetness|insight|magnetism)|Celerity|Vitality|Fleetness|Insight|Magnetism|quick_strike|QuickStrike|Quick Strike|reaching_edge|Reaching Edge|sweeping_edge|Sweeping Edge|PassiveCardCatalogue|SkillSupportCatalogue' "$PROJECT_DIR/$file"; then
		fail "$file names a concrete card, Skill, support or catalogue"
		leaked=$((leaked + 1))
	fi
	if grep -qE 'randi|randf|randomize|RandomNumberGenerator|rand_from_seed|Time\.|OS\.|Engine\.|ProjectSettings|InputMap|FileAccess|DirAccess|ConfigFile|ResourceSaver|ResourceLoader|user://' "$PROJECT_DIR/$file"; then
		fail "$file reads ambient state or storage"
		leaked=$((leaked + 1))
	fi
	if grep -vE '^[[:space:]]*#' "$PROJECT_DIR/$file" | grep -qE 'base_weight|magnitude|stat_id|display_name|MAXIMUM_TOTAL_WEIGHT|_mix\(|0x7FEB|0x846C'; then
		fail "$file touches a card field, the ceiling or a mixer in code"
		leaked=$((leaked + 1))
	fi
done
if [[ "$leaked" == "0" ]]; then
	pass "neither new file names a concrete card, Skill, support or catalogue, reads ambient state, or touches a card field, the ceiling or a mixer"
fi

# NOTHING THAT RUNS CALLS IT, measured from outside the engine, with a floor on what
# was searched — a scan over a directory that does not exist looks exactly clean.
searched="$(find "$PROJECT_DIR/scripts" "$PROJECT_DIR/scenes" "$PROJECT_DIR/data" "$PROJECT_DIR/addons" \
	-type f \( -name '*.gd' -o -name '*.tscn' -o -name '*.tres' \) 2>/dev/null | wc -l | tr -d ' ')"
referenced=0
for name in "${NEW_CLASSES[@]}"; do
	while IFS= read -r hit; do
		case "$hit" in
			*/scripts/fallback/support_exhaustion_passive_fallback.gd|*/scripts/fallback/support_exhaustion_passive_fallback_result.gd)
				continue ;;
			# D-306: Roguelite Foundation I7 composes the fallback into the offer, so both
			# offer files name it — granted exactly as in the engine-side scan.
			*/scripts/offers/rift_offer.gd|*/scripts/offers/rift_offer_composition.gd)
				continue ;;
		esac
		fail "$(basename "$hit") names $name"
		referenced=$((referenced + 1))
	done < <(grep -rlF "$name" "$PROJECT_DIR/scripts" "$PROJECT_DIR/scenes" \
		"$PROJECT_DIR/data" "$PROJECT_DIR/addons" 2>/dev/null)
	if grep -qF "$name" "$PROJECT_DIR/project.godot"; then
		fail "project.godot names $name"
		referenced=$((referenced + 1))
	fi
done
if [[ "$searched" -le 100 ]]; then
	fail "the shell-side scan found only $searched project files, so it proves nothing"
elif [[ "$referenced" == "0" ]]; then
	pass "$searched project files scanned in the shell: nothing but the two new files, and nothing in project.godot, names either new class"
fi

dir_listing="$(find "$PROJECT_DIR/scripts/fallback" -mindepth 1 -maxdepth 1 -exec basename {} \; | sort | tr '\n' ' ' | sed 's/ $//')"
if [[ "$dir_listing" == "$EXPECTED_FALLBACK_DIR" ]]; then
	pass "scripts/fallback/ holds exactly its two scripts and their two uid files"
else
	fail "scripts/fallback/ holds '$dir_listing'"
fi

# --------------------------------------------------------------------------
step "4. project.godot is untouched"
project_godot="$PROJECT_DIR/project.godot"
actions="$(sed -n '/^\[input\]/,/^\[layer_names\]/p' "$project_godot" | grep -cE '^[a-zA-Z_0-9]+=')"
if [[ "$actions" == "$EXPECTED_INPUT_ACTIONS" ]]; then
	pass "the InputMap still declares exactly $EXPECTED_INPUT_ACTIONS actions"
else
	fail "the InputMap declares $actions actions, not $EXPECTED_INPUT_ACTIONS"
fi
main_scene="$(grep -oE 'run/main_scene="[^"]+"' "$project_godot" | head -1 | sed -E 's/run\/main_scene="([^"]+)"/\1/')"
if [[ "$main_scene" == "$EXPECTED_MAIN_SCENE" ]]; then
	pass "the entrypoint is still $EXPECTED_MAIN_SCENE"
else
	fail "the entrypoint is '$main_scene', not $EXPECTED_MAIN_SCENE"
fi
if grep -q '^\[autoload\]' "$project_godot"; then
	fail "an [autoload] section was added"
else
	pass "there is still no [autoload]"
fi

# --------------------------------------------------------------------------
step "5. The run wrote nothing, and every protected file is byte-identical"
written="$(find "$PROJECT_DIR" -path "$PROJECT_DIR/.godot" -prune -o -type f -newer "$run_marker" -print 2>/dev/null)"
if [[ -z "$written" ]]; then
	pass "no file under game/ outside .godot/ was written during this run"
else
	fail "files were written during this run: $(echo "$written" | sed "s|$PROJECT_DIR/||" | tr '\n' ' ')"
fi
if [[ "$(godot_tree_fingerprint)" == "$godot_before" ]]; then
	pass ".godot/ is byte-identical across the run — no import pass, no cache rewrite"
else
	fail ".godot/ changed during this run"
fi
if [[ -e "$PROJECT_DIR/$THIS_VERIFICATION.uid" ]]; then
	fail "a .uid sidecar sits beside the new suite"
else
	pass "no .uid sidecar sits beside the new suite"
fi

changed=0
for i in "${!PRESERVED_FILES[@]}"; do
	after="$(fingerprint "$PROJECT_DIR/${PRESERVED_FILES[$i]}")"
	if [[ "$after" != "${BEFORE_HASHES[$i]}" ]]; then
		fail "${PRESERVED_FILES[$i]} CHANGED during this run"
		changed=$((changed + 1))
	fi
done
if [[ "$changed" == "0" && "$missing_preserved" == "0" ]]; then
	pass "all ${#PRESERVED_FILES[@]} protected files are byte-identical"
fi

settings_after="$(state_fingerprint "$production_dir/prototype_settings.cfg")"
lab_after="$(state_fingerprint "$production_dir/prototype_zero.cfg")"
character_after="$(state_fingerprint "$production_dir/riftwrought_character.cfg")"
if [[ "$settings_after" == "$settings_before" && "$lab_after" == "$lab_before" \
		&& "$character_after" == "$character_before" ]]; then
	pass "the project owner's own prototype_settings.cfg, prototype_zero.cfg and riftwrought_character.cfg are unchanged"
else
	fail "a file in the project owner's own user:// directory changed during this run"
fi

# --------------------------------------------------------------------------
printf '\n'
if [[ "$failures" == "0" ]]; then
	printf 'SUPPORT EXHAUSTION PASSIVE FALLBACK SMOKE CHECKS: PASS\n'
	printf '  %s checks; %s of %s owed; %s protected files byte-identical\n' \
		"$EXPECTED_CHECKS" "$EXPECTED_OWED_CHECKS" "$EXPECTED_OWED_CHECKS" "${#PRESERVED_FILES[@]}"
	printf '  Roguelite Foundation I6 — Deterministic Exhausted-Support Passive Fallback\n'
	printf '  Selection — is DELIVERED under D-304 and ACCEPTED and CLOSED at the\n'
	printf '  deterministic exhausted-support passive-fallback selection mechanism level\n'
	printf '  under D-305.\n'
	reached_end=1
	exit 0
else
	printf 'SUPPORT EXHAUSTION PASSIVE FALLBACK SMOKE CHECKS: %d FAILURE(S)\n' "$failures"
	reached_end=1
	exit 1
fi
