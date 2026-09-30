#!/usr/bin/env bash
# Riftwrought — Roguelite Foundation I8 smoke checks: the Atomic Passive-Fallback Choice
# Transaction (decision D-308).
#
# THIS IS NOT A GATE, AND IT RUNS NO LOCKED CHAIN.
#
# I8 extends the accepted D3 choice transaction so an I7 PASSIVE_FALLBACK Support lane is
# consumed atomically as ONE passive-card acquisition through the accepted run-build
# operation, and extends the choice result so a Support success says which kind of content
# it consumed and, for a fallback, which passive category it drew from. It edits the two
# choice files and no other production file. It stops at the choice result: nothing
# carries the new result further, and nothing that runs reaches it. What this script
# proves:
#
#   0. the engine is the locked 4.7.2 and every protected file is fingerprinted;
#   1. both edited choice files, the new suite and the five accepted suites whose pins
#      moved one for one all parse, and the three accepted runners edited beside them are
#      valid shell;
#   2. the pinned verification passes — its check count AND its owed-check count each
#      proved in BOTH directions against a replay of its own log — with zero SCRIPT
#      ERROR, zero engine ERROR and zero engine WARNING, and the measured lines read out
#      of its own log;
#   3. both choice files name exactly the project classes recorded below and nothing
#      concrete or ambient, nothing else under scripts/, scenes/, data/ or addons/ — nor
#      project.godot — names an I8 member, and scripts/choices/ holds exactly its files —
#      in the shell as well as in the engine;
#   4. project.godot is untouched: 31 actions, the Prototype App entrypoint, no
#      [autoload];
#   5. the run wrote nothing, .godot/ is byte-identical across it, every protected file
#      is byte-identical, and the project owner's own user:// files are untouched.
#
# Roguelite Foundation I9 (D-310) has since extended the one-level level-up receipt so a
# consumed fallback reaches it coherently. The verification's check 15 moved one for one
# and was renamed, the receipt's hash row moved, check 16 grants the receipt the four I8
# members it names, and check 17 reads I7's third consuming reader; six measured lines
# below moved and step 3 grants the receipt the same four members. The count did not move.
#
# Usage, from the repository root:
#   game/tests/passive_fallback_choice_transaction_smoke.sh

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
		printf '\nPASSIVE FALLBACK CHOICE TRANSACTION SMOKE CHECKS: ABORTED before the end of the script\n'
		printf '  the run stopped early (exit %s) — nothing after that point was proved\n' "$status"
		exit 1
	fi
	exit "$status"
}
trap on_exit EXIT

GODOT="${GODOT:-/Applications/Godot.app/Contents/MacOS/Godot}"
EXPECTED_VERSION="4.7.2.stable"
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

THIS_VERIFICATION="tests/passive_fallback_choice_transaction_verification.gd"
VERIFICATION="res://$THIS_VERIFICATION"
VERIFY_BANNER="PASSIVE FALLBACK CHOICE TRANSACTION VERIFICATION"

# Pinned, and proved in both directions below.
EXPECTED_CHECKS=81
EXPECTED_OWED_CHECKS=17
EXPECTED_INPUT_ACTIONS=31
EXPECTED_MAIN_SCENE="res://scenes/app/prototype_app.tscn"

EDITED_PRODUCTION=(
	"scripts/choices/rift_offer_choice.gd"
	"scripts/choices/rift_offer_choice_result.gd"
)
# The five accepted verifications whose pins I8 moved one for one.
MOVED_SUITES=(
	"tests/rift_offer_choice_verification.gd"
	"tests/ranked_support_ownership_verification.gd"
	"tests/maximum_rank_support_filtering_verification.gd"
	"tests/support_exhaustion_passive_fallback_verification.gd"
	"tests/passive_fallback_offer_composition_verification.gd"
)
# The three accepted runners edited beside them: a granted row or a measured line.
MOVED_RUNNERS=(
	"tests/ranked_support_ownership_smoke.sh"
	"tests/maximum_rank_support_filtering_smoke.sh"
	"tests/passive_fallback_offer_composition_smoke.sh"
)

# Exactly the project classes each edited file names, sorted.
EXPECTED_CHOICE_NAMES="PassiveCardCatalogue PassiveCardDefinition RiftConsumptionLedger RiftOffer RiftOfferChoice RiftOfferChoiceResult RiftRunBuild SupportContinuation SupportContinuationResult"
EXPECTED_RESULT_NAMES="RiftConsumptionLedger RiftOffer RiftOfferChoice RiftOfferChoiceResult RiftRunBuild SupportContinuation SupportContinuationResult"
EXPECTED_CHOICES_DIR="rift_consumption_ledger.gd rift_consumption_ledger.gd.uid rift_offer_choice.gd rift_offer_choice.gd.uid rift_offer_choice_result.gd rift_offer_choice_result.gd.uid"
# Members only I8 introduces; nothing outside the two choice files may name one.
I8_TOKENS=(
	"chosen_support_fallback" "carries_support_fallback" "identity_size_for_content"
	"support_fallback_category" "NO_FALLBACK_CATEGORY" "_stage_support_fallback"
)

# DELIBERATELY SHORT, AND NOT A WHOLE-PROJECT CATALOGUE: the files I8 reads, stands
# beside or could conceivably disturb, and the project owner's work. Every `.tres` under
# data/ is added below, enumerated rather than typed.
PRESERVED_FILES=(
	"project.godot"
	"../CLAUDE.md"
	"../README.md"
	"scenes/first_mvp/zone_composer_practice.tscn"
	"assets/prototype/ui/loading/riftwrought-loading-teaser-v1.png"
	"assets/prototype/ui/loading/riftwrought-loading-teaser-v1.png.import"
	"scripts/choices/rift_offer_choice.gd"
	"scripts/choices/rift_offer_choice_result.gd"
	"scripts/choices/rift_consumption_ledger.gd"
	"scripts/offers/rift_offer.gd"
	"scripts/offers/rift_offer_composition.gd"
	"scripts/fallback/support_exhaustion_passive_fallback.gd"
	"scripts/fallback/support_exhaustion_passive_fallback_result.gd"
	"scripts/runs/rift_run_build.gd"
	"scripts/stats/passive_card_definition.gd"
	"scripts/stats/passive_card_catalogue.gd"
	"scripts/stats/passive_card_selection.gd"
	"scripts/stats/passive_card_selection_result.gd"
	"scripts/stats/player_stat_totals.gd"
	"scripts/skills/acquired_supports.gd"
	"scripts/continuation/support_continuation.gd"
	"scripts/continuation/support_continuation_result.gd"
	"scripts/levels/rift_level_up_coordinator.gd"
	"scripts/levels/rift_level_up_result.gd"
	"scripts/levels/rift_run_level_coordinator.gd"
	"scripts/levels/rift_run_level_up_result.gd"
	"scripts/experience/rift_mote_runtime.gd"
	"scripts/roguelite/live_effects/rift_build_application.gd"
	"scripts/roguelite/live_effects/rift_build_application_result.gd"
	"scripts/roguelite/live_effects/roguelite_live_effect_review.gd"
	"scripts/roguelite/level_up/roguelite_level_up_choice_review.gd"
	"scripts/roguelite/level_up/rift_level_up_offer_panel.gd"
	"scripts/ui/first_mvp_modal.gd"
	"tests/rift_offer_choice_verification.gd"
	"tests/rift_offer_choice_smoke.sh"
	"tests/ranked_support_ownership_verification.gd"
	"tests/ranked_support_ownership_smoke.sh"
	"tests/maximum_rank_support_filtering_verification.gd"
	"tests/maximum_rank_support_filtering_smoke.sh"
	"tests/support_exhaustion_passive_fallback_verification.gd"
	"tests/passive_fallback_offer_composition_verification.gd"
	"tests/passive_fallback_offer_composition_smoke.sh"
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

printf 'Riftwrought — Roguelite Foundation I8: Atomic Passive-Fallback Choice Transaction (D-308)\n'
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
run_marker="$(mktemp -t riftwrought_passive_fallback_choice_marker)"
pass ".godot/ fingerprinted as one tree, and a start-of-run marker laid"

project_name="$(sed -n 's/^config\/name="\(.*\)"[[:space:]]*$/\1/p' "$PROJECT_DIR/project.godot" | head -1)"
production_dir="$HOME/Library/Application Support/Godot/app_userdata/$project_name"
settings_before="$(state_fingerprint "$production_dir/prototype_settings.cfg")"
lab_before="$(state_fingerprint "$production_dir/prototype_zero.cfg")"
character_before="$(state_fingerprint "$production_dir/riftwrought_character.cfg")"
pass "the project owner's own three user:// files fingerprinted"

# --------------------------------------------------------------------------
step "1. Both edited scripts, the new suite and every moved suite parse; every edited runner is valid shell"
for script in "${EDITED_PRODUCTION[@]}" "$THIS_VERIFICATION" "${MOVED_SUITES[@]}"; do
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
for runner in "${MOVED_RUNNERS[@]}" "tests/passive_fallback_choice_transaction_smoke.sh"; do
	if bash -n "$PROJECT_DIR/$runner" 2>/dev/null; then
		pass "$runner is valid shell"
	else
		fail "$runner is not valid shell"
	fi
done

# --------------------------------------------------------------------------
step "2. The pinned verification passes, proved in BOTH directions"
verify_log="/tmp/riftwrought_passive_fallback_choice_transaction_verify.log"
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
replay="$(mktemp -t riftwrought_passive_fallback_choice_replay)"
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
4992 accepted D3 outcomes (3536 over 8 non-fallback states x 136 seeds and the two passive lanes of 136 fallback offers, 1024 stale offers, 432 spent seeds) hash 9381d4bb493d3697 — identical to the pre-I8 transaction's
every one carries its content kind: 1344 Support progressions SUPPORT_PROGRESSION with two ids, 2448 passive lanes and 1200 refusals with none, and no fallback category anywhere
the one class whose answer moved: the 136 fallback Support choices the pre-I8 transaction refused as 'the support lane named 1 identifiers, not 2' are each consumed whole as one passive card
root seed 18 at R2 S2: Support [card_celerity] drawn from Combat and Defence is consumed — card_celerity held 0 -> 1, skill_speed=0.10000000000000001(1), maximum_life=0.14999999999999999(1), card_power and card_insight held 0 -> 0, pairs [quick_strike -> reaching_edge, quick_strike -> sweeping_edge] at ranks 2 / 2, ledger [-424242] -> [-424242, 18]
the result: 'root seed 18 consumed; Support: card_celerity'; content PASSIVE_FALLBACK, category 0, no progression; the supplied build, ledger and offer byte-identical
4096 of 4096 fallback offers over root seeds 0-4095 consumed as one passive card: by card [card_celerity 682, card_fleetness 708, card_insight 621, card_magnetism 665, card_power 700, card_vitality 720]; by category [Combat and Defence 2102, Utility 1994]
every one equal to the run build's own acquisition of its canonical record, in the fallback's own category, with 0 ordinary cards acquired, 0 pairs or ranks moved, the seed spent once, and 4096 of 4096 supplied build, ledger and offer triples byte-identical
6 of 6 shipped cards, each found as a fallback and taken onto a build already holding it once, are held twice through the run build's own repeat rule: card_power (root seed 1), card_celerity (root seed 0), card_vitality (root seed 7), card_fleetness (root seed 24), card_insight (root seed 4), card_magnetism (root seed 2)
card_celerity from root seed 18 onto a build holding it: skill_speed = 0.20000000000000001 over 2 contributions, its mechanical identity unchanged; root seeds 0 then 18 in sequence hold it 0 -> 1 -> 2 with two seeds spent
3840 answers over 256 root seeds x 3 lanes x 5 reversals (Skills, supports, cards, the held pairs' order, and all four together) against the unreversed composition: 0 moved; all 256 Support answers are consumed fallbacks
16 of 16 single-field tamperings (content kind x3, fallback id x4, the fallback derivation x2, the exhausted continuation, a borrowed Skill, and inside the fallback its category, card, both tickets and its success) refused with no seed spent — every one at the offer's own coherence gate, quoted verbatim
16 of 16 left the supplied build, ledger and tampered offer byte-identical, and 16 of 16 refusals expose no identity, content kind, category, build or ledger
STRUCTURAL: the transaction's own one-card, fallback-coherence and three-way-agreement gates are unreachable through a supplied offer — a coherent offer already guarantees all three, and every tampering above is refused by that coherence first
a canonical Combat and Defence id fabricated as a Utility card: 64 coherent fallback offers drawing it from Utility, 64 refused — 'card_power derives category 0 and the Support lane's passive fallback drew from category 1' — with nothing spent and the supplied values byte-identical
a catalogue of ids the canonical one does not hold: 64 of 64 coherent fallback offers refused — e.g. 'zz_c_three is not a card the canonical catalogue holds' — atomically
STRUCTURAL: a canonical record that is itself invalid is unreachable — the shipped catalogue is coherent, which its own accepted suite proves
run-build refusal, verbatim, nothing spent: a magnitude conflict: 'card_celerity: was first acquired with magnitude 0.2 and now carries 0.1 — one card id is one mechanical passive for the life of a run'
run-build refusal, verbatim, nothing spent: a stat conflict: 'card_celerity: was first acquired with stat_id global_damage and now carries skill_speed — one card id is one mechanical passive for the life of a run'
run-build refusal, verbatim, nothing spent: a repeat-flag conflict: 'card_celerity: was first acquired with repeatable false and now carries true — one card id is one mechanical passive for the life of a run'
STRUCTURAL: the run build's 'not repeatable' branch needs a non-repeatable canonical record, and 6 of 6 shipped records are repeatable, so a future non-repeatable conflict reaches the transaction today only as the repeat-flag fingerprint conflict above
STRUCTURAL: the run build's unusable-total branch needs a sum that is not finite, and a shipped magnitude cannot make one — holding the largest finite skill_speed total, the fallback still succeeds
after the fallback is consumed, all 3 lanes of the same offer are refused against the new values — 'root seed 18 has already been consumed by this run' — atomically; the untouched originals still answer an equal, independent result
512 of 512 ordinary passive-lane choices of a fallback offer: the lane's own card taken through the run build's acquisition, no Support content, no fallback category, the fallback card not acquired
the shipped two-card catalogue [card_celerity, card_fleetness] at R2 S2: 64 of 64 offers refuse as fallback-unavailable, and 192 of 192 lane choices of them are refused as 'the offer did not compose' with nothing spent
342 of 342 refusals collected by checks 6-11 carry a reason and nothing else: no identity, Support content kind, fallback category, progression, build or ledger, and each is coherent by its own rule (11 distinct reason heads)
2 identity reads, 2 returned-value mutations, 2 supplied-value mutations, the fallback constructor's own array and two sibling results: 0 reached anything they should not; the offer byte-identical
coherent — Support progression: 2 ids, progression present, fallback category unresolved, coherent true
coherent — Support passive fallback: 1 ids, progression absent, fallback category Combat and Defence, coherent true
coherent — ordinary passive lane: 1 ids, progression absent, fallback category unresolved, coherent true
coherent — refusal: 0 ids, progression absent, fallback category unresolved, coherent true
identity_size_for_content: Support progression 2, Support fallback 1, Support without content 0, an undeclared kind 0, each passive lane 1, a passive lane with Support content 0, an undeclared lane 0; the preserved identity_size_for still answers Support 2, passive 1, undeclared 0
both one-versus-two mistakes refused: 'the Support lane granted 1 identifiers, not 2' and 'the Support lane granted 2 identifiers, not 1'
16 of 16 mixed shapes refused by exact message and each coherent again once restored; carries_support_fallback() reads only the stored kind
a later acquisition of the same card leaves the historical fallback choice coherent (card_celerity held twice, problem() and the audit both empty); the progression audit still reports a later rank
RiftLevelUpResult.taken() on the consumed fallback: ok, Support, root seed 18, [card_celerity], no progression — coherent since I9 (D-310), carrying content PASSIVE_FALLBACK and category 0: 'passive fallback: card_celerity, drawn from Combat and Defence'
through the unchanged one-level coordinator at root seed 18: the fallback Support choice COMMITS — Level 2, completed, 1 seed consumed, card_celerity held once, a next coordinator available — and returns that coherent receipt
the unchanged run-level record wrapping it at run seed 18, level 1 is coherent and hands out a copy carrying the fallback; a progression through the same path is coherent
THE BINDING PREREQUISITE D-308 RECORDED IS MET BY I9 (D-310): the one-level receipt, the one-level coordinator's commit and the run-level record carry the Support content kind and the fallback category
methods pinned: transaction 5, result 15; the result carries 13 fields (the accepted 11 plus 2 appended); transaction state: 0 fields
the transaction names exactly 9 project classes and the result 7 — neither names the I6 fallback classes, and the fallback is read only through the offer's own field
both files scanned raw: 0 concrete names, 0 ambient reads; in code, no level, experience, receipt, panel, actor, application, save, input or signal
STRUCTURAL, read from the code: choose() stages the lane — a fallback through _stage() on the stored content kind — before it consumes the seed, and builds the fallback success only after; the fallback staging names no ledger operation
running files scanned: none but the two edited files names an I8 member, except the four the level-up receipt is granted since I9 (D-310) and those I10 (D-312) grants both level-up coordinators, the mote runtime and the running review; project.godot names none; the running review asks each level's offer once (I11, D-314), beginning at Level 1, and a fresh build composes 0 fallbacks over 256 root seeds
project.godot: 31 actions, the Prototype App entrypoint, no [autoload]; scripts/choices/ holds its 3 scripts and 3 uid files
25 of 25 accepted files byte-identical by SHA-256 prefix to the tree before the first I8 edit, except the level-up receipt, pinned at its D-310 hash, and both level-up coordinators and the mote runtime, pinned at their D-312 hashes, and the running review and its panel, at their D-314 hashes, and the seam, its result and the live-effect review, at their D-320 hashes, the result at its D-321 hash, the panel at its D-322 hash —the offer and composer, the I6 fallback, the ledger, the run build, the card records and selector, the continuation, every level-up coordinator and receipt, the mote runtime, the running review and its panel, the live-effect seam and review, and project.godot
the transaction 533ee30f… and its result f051a955… at their D-308 hashes
D3: three pins moved; F1: total_support_ranks( granted to the transaction alone; I5: checks 18, 19 and 23 moved, 8064 refusals; I6: two hash rows (24); I7: check 12 renamed and moved, two hash rows (27), five members granted to each choice file, 2644 refusals
342 refusals were driven across this suite
MEASURED
if [[ "$measured" == "$measured_total" ]]; then
	pass "$measured of $measured_total measured lines found in the run's own log"
fi

# --------------------------------------------------------------------------
step "3. The choice files name exactly their classes and nothing concrete, and nothing else names an I8 member"
PROJECT_CLASSES="$(grep -oE '"class": &"[A-Za-z0-9_]+"' "$PROJECT_DIR/.godot/global_script_class_cache.cfg" \
	| sed -E 's/.*&"([^"]+)"/\1/' | sort -u)"
class_total="$(printf '%s\n' "$PROJECT_CLASSES" | grep -c .)"
if [[ "$class_total" -gt 150 ]] && printf '%s\n' "$PROJECT_CLASSES" | grep -qx "RiftOfferChoiceResult"; then
	pass "the engine's class cache lists $class_total project classes"
else
	fail "the class cache lists $class_total classes"
fi
for row in "scripts/choices/rift_offer_choice.gd|$EXPECTED_CHOICE_NAMES" \
		"scripts/choices/rift_offer_choice_result.gd|$EXPECTED_RESULT_NAMES"; do
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
for file in "${EDITED_PRODUCTION[@]}"; do
	if grep -qE 'card_(power|celerity|vitality|fleetness|insight|magnetism)|quick_strike|QuickStrike|Quick Strike|reaching_edge|Reaching Edge|sweeping_edge|Sweeping Edge|SkillSupportCatalogue|SupportExhaustionPassiveFallback|display_name|base_weight' "$PROJECT_DIR/$file"; then
		fail "$file names a concrete card, Skill, support, the I6 class or a presentation field"
		leaked=$((leaked + 1))
	fi
	if grep -qE 'randi|randf|randomize|RandomNumberGenerator|rand_from_seed|Time\.|OS\.|Engine\.|ProjectSettings|InputMap|FileAccess|DirAccess|ConfigFile|ResourceSaver|ResourceLoader|user://' "$PROJECT_DIR/$file"; then
		fail "$file reads ambient state or storage"
		leaked=$((leaked + 1))
	fi
	if grep -vE '^[[:space:]]*#' "$PROJECT_DIR/$file" | grep -qE '[*/]|[0-9]\.[0-9]'; then
		fail "$file multiplies, divides or carries a floating-point literal in code"
		leaked=$((leaked + 1))
	fi
done
if grep -qF 'PassiveCardCatalogue' "$PROJECT_DIR/scripts/choices/rift_offer_choice_result.gd"; then
	fail "the result names the canonical card catalogue"
	leaked=$((leaked + 1))
fi
if [[ "$leaked" == "0" ]]; then
	pass "neither choice file names anything concrete, reads ambient state or does arithmetic beyond one count, and the result names no catalogue"
fi

# NOTHING THAT RUNS REACHES IT, measured from outside the engine, with a floor on what
# was searched — a scan over a directory that does not exist looks exactly clean.
searched="$(find "$PROJECT_DIR/scripts" "$PROJECT_DIR/scenes" "$PROJECT_DIR/data" "$PROJECT_DIR/addons" \
	-type f \( -name '*.gd' -o -name '*.tscn' -o -name '*.tres' \) 2>/dev/null | wc -l | tr -d ' ')"
referenced=0
for token in "${I8_TOKENS[@]}"; do
	while IFS= read -r hit; do
		case "$hit" in
			*/scripts/choices/rift_offer_choice.gd|*/scripts/choices/rift_offer_choice_result.gd)
				continue ;;
		esac
		# Roguelite Foundation I9 (D-310): the level-up receipt names exactly four I8
		# members — granted exactly as in the engine-side scan.
		case "$hit" in
			*/scripts/levels/rift_level_up_result.gd)
				case "$token" in
					carries_support_fallback|identity_size_for_content|support_fallback_category|NO_FALLBACK_CATEGORY)
						continue ;;
				esac ;;
		esac
		# Roguelite I10 (D-312): both level-up coordinators, the mote runtime and the running
		# review name exactly the I8 members each is granted — granted exactly as in the
		# engine-side scan.
		case "$hit" in
			*/scripts/levels/rift_level_up_coordinator.gd)
				case "$token" in
					support_fallback_category|NO_FALLBACK_CATEGORY) continue ;;
				esac ;;
			*/scripts/levels/rift_run_level_coordinator.gd|*/scripts/experience/rift_mote_runtime.gd)
				case "$token" in
					support_fallback_category) continue ;;
				esac ;;
			*/scripts/roguelite/level_up/roguelite_level_up_choice_review.gd)
				case "$token" in
					carries_support_fallback|support_fallback_category) continue ;;
				esac ;;
		esac
		fail "$(basename "$hit") names $token"
		referenced=$((referenced + 1))
	done < <(grep -rlF -- "$token" "$PROJECT_DIR/scripts" "$PROJECT_DIR/scenes" \
		"$PROJECT_DIR/data" "$PROJECT_DIR/addons" 2>/dev/null)
	if grep -qF -- "$token" "$PROJECT_DIR/project.godot"; then
		fail "project.godot names $token"
		referenced=$((referenced + 1))
	fi
done
if [[ "$searched" -le 100 ]]; then
	fail "the shell-side scan found only $searched project files, so it proves nothing"
elif [[ "$referenced" == "0" ]]; then
	pass "$searched project files scanned in the shell: nothing but the two choice files — and the level-up receipt's four granted I8 members, and those I10 grants both level-up coordinators, the mote runtime and the running review — and nothing in project.godot, names an I8 member"
fi

choices_listing="$(find "$PROJECT_DIR/scripts/choices" -mindepth 1 -maxdepth 1 -exec basename {} \; | sort | tr '\n' ' ' | sed 's/ $//')"
if [[ "$choices_listing" == "$EXPECTED_CHOICES_DIR" ]]; then
	pass "scripts/choices/ holds exactly its three scripts and three uid files"
else
	fail "scripts/choices/ holds '$choices_listing'"
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
	printf 'PASSIVE FALLBACK CHOICE TRANSACTION SMOKE CHECKS: PASS\n'
	printf '  %s checks; %s of %s owed; %s protected files byte-identical\n' \
		"$EXPECTED_CHECKS" "$EXPECTED_OWED_CHECKS" "$EXPECTED_OWED_CHECKS" "${#PRESERVED_FILES[@]}"
	printf '  Roguelite Foundation I8 — Atomic Passive-Fallback Choice Transaction —\n'
	printf '  is DELIVERED under D-308 and ACCEPTED and CLOSED at the atomic\n'
	printf '  passive-fallback choice-transaction mechanism level under D-309.\n'
	reached_end=1
	exit 0
else
	printf 'PASSIVE FALLBACK CHOICE TRANSACTION SMOKE CHECKS: %d FAILURE(S)\n' "$failures"
	reached_end=1
	exit 1
fi
