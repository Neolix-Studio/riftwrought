#!/usr/bin/env bash
# Riftwrought — Roguelite Foundation I9 smoke checks: Immutable Passive-Fallback Level-Up
# Receipt Propagation (decision D-310).
#
# THIS IS NOT A GATE, AND IT RUNS NO LOCKED CHAIN.
#
# I9 extends the accepted one-level level-up receipt so the passive-fallback Support choice
# I8 made consumable stays coherent and fully identified after the one-level coordinator
# commits it and the run-level record keeps it: the receipt now copies the Support content
# kind and the fallback category out of the whole successful choice result, validates the
# four success shapes and every refusal, and copies both scalars in its own duplicate. It
# edits the receipt and no other production file; neither coordinator moved. Nothing that
# runs reaches the fallback receipt. What this script proves:
#
#   0. the engine is the locked 4.7.2 and every protected file is fingerprinted;
#   1. the edited receipt, the new suite and the seven accepted suites whose pins moved one
#      for one all parse, and the four accepted runners edited beside them are valid shell;
#   2. the pinned verification passes — its check count AND its owed-check count each
#      proved in BOTH directions against a replay of its own log — with zero SCRIPT
#      ERROR, zero engine ERROR and zero engine WARNING, and the measured lines read out
#      of its own log;
#   3. the receipt names exactly the project classes recorded below, nothing concrete or
#      ambient, and does no arithmetic; outside the receipt, only the choice result, the
#      transaction and the offer name any of the receipt's four new members, each only its
#      own; exactly four running files besides the receipt name its class, and none of them
#      names a new member; scripts/levels/ holds exactly its files — in the shell as well as
#      in the engine;
#   4. project.godot is untouched: 31 actions, the Prototype App entrypoint, no
#      [autoload];
#   5. the run wrote nothing, .godot/ is byte-identical across it, every protected file
#      is byte-identical, and the project owner's own user:// files are untouched.
#
# Usage, from the repository root:
#   game/tests/passive_fallback_level_up_receipt_smoke.sh

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
		printf '\nPASSIVE FALLBACK LEVEL-UP RECEIPT SMOKE CHECKS: ABORTED before the end of the script\n'
		printf '  the run stopped early (exit %s) — nothing after that point was proved\n' "$status"
		exit 1
	fi
	exit "$status"
}
trap on_exit EXIT

GODOT="${GODOT:-/Applications/Godot.app/Contents/MacOS/Godot}"
EXPECTED_VERSION="4.7.2.stable"
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

THIS_VERIFICATION="tests/passive_fallback_level_up_receipt_verification.gd"
VERIFICATION="res://$THIS_VERIFICATION"
VERIFY_BANNER="PASSIVE FALLBACK LEVEL-UP RECEIPT VERIFICATION"

# Pinned, and proved in both directions below.
EXPECTED_CHECKS=115
EXPECTED_OWED_CHECKS=17
EXPECTED_INPUT_ACTIONS=31
EXPECTED_MAIN_SCENE="res://scenes/app/prototype_app.tscn"

RECEIPT="scripts/levels/rift_level_up_result.gd"
EDITED_PRODUCTION=("$RECEIPT")
# The seven accepted verifications whose pins I9 moved one for one.
MOVED_SUITES=(
	"tests/rift_level_up_coordinator_verification.gd"
	"tests/rift_level_up_support_progression_verification.gd"
	"tests/rift_level_up_continuation_verification.gd"
	"tests/rift_run_level_coordinator_verification.gd"
	"tests/support_exhaustion_passive_fallback_verification.gd"
	"tests/passive_fallback_offer_composition_verification.gd"
	"tests/passive_fallback_choice_transaction_verification.gd"
)
# The four accepted runners edited beside them: a granted row or a measured line.
MOVED_RUNNERS=(
	"tests/rift_level_up_support_progression_smoke.sh"
	"tests/rift_run_level_coordinator_smoke.sh"
	"tests/passive_fallback_offer_composition_smoke.sh"
	"tests/passive_fallback_choice_transaction_smoke.sh"
)

# Exactly the project classes the receipt names, sorted.
EXPECTED_RECEIPT_NAMES="RiftLevelUpResult RiftOffer RiftOfferChoice RiftOfferChoiceResult SupportContinuation SupportContinuationResult"
EXPECTED_LEVELS_DIR="rift_level_up_coordinator.gd rift_level_up_coordinator.gd.uid rift_level_up_result.gd rift_level_up_result.gd.uid rift_run_level_coordinator.gd rift_run_level_coordinator.gd.uid rift_run_level_up_result.gd rift_run_level_up_result.gd.uid"
# The four members I9 gives the receipt.
NEW_MEMBERS=("support_content_kind" "support_fallback_category" "carries_support_fallback" "support_fallback_line")
# Every running file besides the receipt that names the receipt's class, sorted.
EXPECTED_READERS="scripts/levels/rift_level_up_coordinator.gd scripts/levels/rift_run_level_coordinator.gd scripts/levels/rift_run_level_up_result.gd scripts/roguelite/level_up/roguelite_level_up_choice_review.gd"

# DELIBERATELY SHORT, AND NOT A WHOLE-PROJECT CATALOGUE: the files I9 reads, stands beside
# or could conceivably disturb, and the project owner's work. Every `.tres` under data/ is
# added below, enumerated rather than typed.
PRESERVED_FILES=(
	"project.godot"
	"../CLAUDE.md"
	"../README.md"
	"scenes/first_mvp/zone_composer_practice.tscn"
	"assets/prototype/ui/loading/riftwrought-loading-teaser-v1.png"
	"assets/prototype/ui/loading/riftwrought-loading-teaser-v1.png.import"
	"scripts/levels/rift_level_up_result.gd"
	"scripts/levels/rift_level_up_coordinator.gd"
	"scripts/levels/rift_run_level_coordinator.gd"
	"scripts/levels/rift_run_level_up_result.gd"
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
	"scripts/skills/acquired_supports.gd"
	"scripts/continuation/support_continuation.gd"
	"scripts/continuation/support_continuation_result.gd"
	"scripts/experience/rift_experience_track.gd"
	"scripts/level_requirements/rift_level_requirement_curve.gd"
	"scripts/level_seeds/rift_level_offer_seed_derivation.gd"
	"scripts/experience/rift_mote_runtime.gd"
	"scripts/roguelite/level_up/roguelite_level_up_choice_review.gd"
	"scripts/roguelite/level_up/rift_level_up_offer_panel.gd"
	"scripts/roguelite/live_effects/rift_build_application.gd"
	"scripts/roguelite/live_effects/rift_build_application_result.gd"
	"scripts/roguelite/live_effects/roguelite_live_effect_review.gd"
	"tests/rift_level_up_coordinator_verification.gd"
	"tests/rift_level_up_coordinator_smoke.sh"
	"tests/rift_level_up_support_progression_verification.gd"
	"tests/rift_level_up_support_progression_smoke.sh"
	"tests/rift_level_up_continuation_verification.gd"
	"tests/rift_level_up_continuation_smoke.sh"
	"tests/rift_run_level_coordinator_verification.gd"
	"tests/rift_run_level_coordinator_smoke.sh"
	"tests/support_exhaustion_passive_fallback_verification.gd"
	"tests/support_exhaustion_passive_fallback_smoke.sh"
	"tests/passive_fallback_offer_composition_verification.gd"
	"tests/passive_fallback_offer_composition_smoke.sh"
	"tests/passive_fallback_choice_transaction_verification.gd"
	"tests/passive_fallback_choice_transaction_smoke.sh"
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

printf 'Riftwrought — Roguelite Foundation I9: Immutable Passive-Fallback Level-Up Receipt Propagation (D-310)\n'
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
run_marker="$(mktemp -t riftwrought_passive_fallback_receipt_marker)"
pass ".godot/ fingerprinted as one tree, and a start-of-run marker laid"

project_name="$(sed -n 's/^config\/name="\(.*\)"[[:space:]]*$/\1/p' "$PROJECT_DIR/project.godot" | head -1)"
production_dir="$HOME/Library/Application Support/Godot/app_userdata/$project_name"
settings_before="$(state_fingerprint "$production_dir/prototype_settings.cfg")"
lab_before="$(state_fingerprint "$production_dir/prototype_zero.cfg")"
character_before="$(state_fingerprint "$production_dir/riftwrought_character.cfg")"
pass "the project owner's own three user:// files fingerprinted"

# --------------------------------------------------------------------------
step "1. The edited receipt, the new suite and every moved suite parse; every edited runner is valid shell"
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
for runner in "${MOVED_RUNNERS[@]}" "tests/passive_fallback_level_up_receipt_smoke.sh"; do
	if bash -n "$PROJECT_DIR/$runner" 2>/dev/null; then
		pass "$runner is valid shell"
	else
		fail "$runner is not valid shell"
	fi
done

# --------------------------------------------------------------------------
step "2. The pinned verification passes, proved in BOTH directions"
verify_log="/tmp/riftwrought_passive_fallback_level_up_receipt_verify.log"
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
replay="$(mktemp -t riftwrought_passive_fallback_receipt_replay)"
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
3198 accepted receipt and run-level record rows (E2 lifecycles over 9 rank states x 72 root seeds x 3 lanes, E2 refusals, the constructors, and G4 runs over 7 run seeds x 4 lane sequences) hash 9f090c6441b2e74f — identical to the pre-I9 receipt's
every formatted receipt carries its Support content: 620 Support progressions SUPPORT_PROGRESSION with no fallback category, 1389 passive receipts and 1185 refusals with neither, and the 4 constructor rows that are incoherent by design carry what their lane's choice declared
the one class whose answer moved: 72 E2 fallback receipts the pre-I9 receipt called incoherent ('the Support lane granted 1 identifiers, not 2') and 7 G4 records wrapping one ('the one-level result it records is incoherent: the Support lane granted 1 identifiers, not 2') are each coherent now — one card, PASSIVE_FALLBACK, a passive category, no progression
root seed 18 at R2 S2: the I8 choice consumed Support [card_celerity] from category 0; the receipt reads root seed 18, lane Support, [card_celerity], content PASSIVE_FALLBACK, category 0, progression kind -1 at ranks 0 -> 0 — equal to the choice in all ten facts
presented: 'root seed 18 spent; Support: card_celerity'; 'no support progression'; 'passive fallback: card_celerity, drawn from Combat and Defence'; problem() empty
4096 of 4096 fallback choices over root seeds 0-4095 become coherent receipts equal to their choice: by card [card_celerity 682, card_fleetness 708, card_insight 621, card_magnetism 665, card_power 700, card_vitality 720]; by category [Combat and Defence 2102, Utility 1994]
256 of 256 through the unchanged one-level coordinator, each equal field for field to an independent choice's receipt: by card [card_celerity 53, card_fleetness 50, card_insight 40, card_magnetism 37, card_power 33, card_vitality 43]; by category [Combat and Defence 129, Utility 127]
6 choice shapes — two fallbacks, a new pair, a rank increase and both passive lanes — each copied whole: seed, known, lane, identity, three progression facts, content kind and category
a hand-made Utility fallback over an empty build: the receipt carries [card_insight] and category 1 as the choice declares; the build is never asked
STRUCTURAL, read from the code: taken() takes one RiftOfferChoiceResult and reads each stable fact once; nothing else in the receipt names it; the one-level coordinator builds its receipt only through taken(outcome) and names none of the four new members in choose(), and none at all outside I10's (D-312) two standing-offer readings
14 refusals — taken() of null and of two refused choices, both refusal constructors, a lane before any offer, 3 undeclared lanes of a fallback offer, the fallback lane on a spent seed ('root seed 18 has already been consumed by this run'), 3 lanes after completion and a G4 choice before any offer — each ok=false with no identity, no Support content kind, no fallback category and no progression, coherent, and copied the same
root seed 0: 'root seed 0 spent; Support: quick_strike -> reaching_edge', a new compatible pair, rank 0 -> 1, content SUPPORT_PROGRESSION, no fallback category, 'no passive fallback'
root seed 18 with both pairs at rank 1: 'root seed 18 spent; Support: quick_strike -> sweeping_edge', another rank of a held pair, rank 1 -> 2, content SUPPORT_PROGRESSION, no fallback category
root seed 0 spent; Combat and Defence: card_vitality; root seed 0 spent; Utility: card_magnetism; root seed 18 spent; Combat and Defence: card_power; root seed 18 spent; Utility: card_insight — every one with no Support content kind, no fallback category and no progression, including both passive lanes of the root-seed-18 fallback offer
27 of 27 mixed shapes refused by exact message — 23 tamperings (the content kind tampered 10 times and the category 7, each alone, across all four shapes; plus identities, a progression, ranks and a lane), each coherent again once restored, and 4 mixed choice results copied by taken() and still refused
both one-versus-two mistakes refused: 'the Support lane granted 2 identifiers, not 1' and 'the Support lane granted 1 identifiers, not 2'
the source choice mutated 10 ways — its identity, both content scalars, its progression, its lane, seed and success, its build and its ledger — and the receipt did not move; it holds no object field
11 of 11 fields copied, both content scalars included; a copy mutated in its content kind, category and identity reached neither the original nor a sibling, and a mutated original reached neither copy; an incoherent receipt's copy carries the same verdict
root seed 18: 150.0 against 100.0 -> Level 2 with 50.0 retained, 1 seed consumed [18], finished, no offer standing; the receipt: passive fallback: card_celerity, drawn from Combat and Defence, category 0
the committed build: card_celerity held 0 -> 1, skill_speed = 0.10000000000000001 over 1 contribution, card_power and card_insight 0 -> 0, pairs [quick_strike -> reaching_edge, quick_strike -> sweeping_edge] at ranks 2 / 2 unmoved
root seed 2: passive fallback: card_magnetism, drawn from Utility, category 1 — Level 2, card_magnetism held once, seed 2 consumed
run seed 99, Support at every level: L1 a new compatible pair, rank 0 -> 1, L2 a new compatible pair, rank 0 -> 1, L3 another rank of a held pair, rank 1 -> 2, L4 another rank of a held pair, rank 1 -> 2, L5 fallback at roots [99, 1000102, 2000105, 3000108, 4000111]
the Level 5 record: 'run seed 99 at level 5: root seed 4000111 spent; Support: card_power', problem() empty; its receipt: root seed 4000111, Support, [card_power], PASSIVE_FALLBACK, category 0 — 'passive fallback: card_power, drawn from Combat and Defence'
level_up() hands out independent copies carrying both content scalars; the record keeps its three fields and no fallback field of its own; G2 still refuses the record at a moved level
the continuation begins at Level 2 with 50.0 retained, card_celerity held once, ranks 2 / 2 and seed 18 spent; the completed lifecycle is untouched
root seed 18 opens again and its fallback is refused — 'root seed 18 has already been consumed by this run' — with nothing moved; root seed 0 then takes passive fallback: card_celerity, drawn from Combat and Defence: two passive acquisitions, seeds [0, 18], Level 3
after the E2 fallback: 5 of 5 later operations refused and the lifecycle unmoved at Level 2
after the G4 fallback: Level 6 with 250.0 retained against a requirement of 225.0 — no offer stands until one is explicitly opened, and opening it moves no level
287 running files scanned: outside the receipt, only the choice result, the transaction, the offer and — since I10 (D-312) — both coordinators, the mote runtime and the running review name any of the receipt's four new members, each only its own; project.godot names none
the receipt's class is named by exactly 4 running files — the one-level coordinator, the run-level coordinator and record, and the running review — and none of them names a new member beyond its I10 (D-312) grant
the running review asks each level's offer once (I11, D-314), beginning at Level 1, and a fresh build composes 0 fallbacks over 256 root seeds; project.godot: 31 actions, the Prototype App entrypoint, no [autoload]
the receipt: 11 fields (the accepted 9 plus 2 appended) and 13 methods (the accepted 11 plus 2); it names exactly 6 project classes and holds no forbidden member
STRUCTURAL, read from the code: problem() asks identity_size_for_content() once and the shared transition rule once, and reads the passive categories through the offer's own lane vocabulary; duplicated() assigns both new scalars; identity_line(), describe() and the progression line name no fallback
neither coordinator nor the run-level record names a new member outside I10's (D-312) two standing-offer readings; scripts/levels/ still holds its 4 scripts and 4 uid files
28 of 28 accepted production files byte-identical by SHA-256 prefix to the tree before the first I9 edit, except both coordinators and the mote runtime, pinned at their D-312 hashes, and the running review and its panel, at their D-314 hashes, and the seam, its result and the live-effect review, at their D-320 hashes, the result at its D-321 hash, the panel at its D-322 hash —both choice files, the offer and composer, the I6 fallback, the ledger, the run build, the card records and selector, the acquisition record, the continuation, both coordinators and the run-level record, the track, G1, G2, the mote runtime, the running review and its panel, the live-effect seam and review, and project.godot
the receipt 2d67cee9… (was 0f2e4a86…)
E2: two signature rows, two field rows and the fallback permit; F5: the same pins and its permit text; G3 and G4: the same receipt pins; hash rows: support_exhaustion_passive_fallback_verification.gd 2d67cee9 (24), passive_fallback_offer_composition_verification.gd 2d67cee9 (27), passive_fallback_choice_transaction_verification.gd 2d67cee9 (25); I7: the receipt as its third consuming reader; I8: check 15 renamed and moved, the receipt's four-member grant
MEASURED
if [[ "$measured" == "$measured_total" ]]; then
	pass "$measured of $measured_total measured lines found in the run's own log"
fi

# --------------------------------------------------------------------------
step "3. The receipt names exactly its classes and nothing concrete, and nothing running consumes its new members"
PROJECT_CLASSES="$(grep -oE '"class": &"[A-Za-z0-9_]+"' "$PROJECT_DIR/.godot/global_script_class_cache.cfg" \
	| sed -E 's/.*&"([^"]+)"/\1/' | sort -u)"
class_total="$(printf '%s\n' "$PROJECT_CLASSES" | grep -c .)"
if [[ "$class_total" -gt 150 ]] && printf '%s\n' "$PROJECT_CLASSES" | grep -qx "RiftLevelUpResult"; then
	pass "the engine's class cache lists $class_total project classes"
else
	fail "the class cache lists $class_total classes"
fi
actual="$(named_classes "$PROJECT_DIR/$RECEIPT")"
if [[ "$actual" == "$EXPECTED_RECEIPT_NAMES" ]]; then
	pass "$RECEIPT names exactly [$actual]"
else
	fail "$RECEIPT names [$actual], not [$EXPECTED_RECEIPT_NAMES]"
fi

leaked=0
if grep -qE 'card_(power|celerity|vitality|fleetness|insight|magnetism)|quick_strike|QuickStrike|Quick Strike|reaching_edge|Reaching Edge|sweeping_edge|Sweeping Edge|SkillSupportCatalogue|PassiveCardCatalogue|PassiveCardSelectionResult|PlayerStatDefinition|SupportExhaustionPassiveFallback|chosen_support_fallback|_stage_support_fallback|display_name|base_weight' "$PROJECT_DIR/$RECEIPT"; then
	fail "the receipt names a concrete card, Skill, support, catalogue, stat vocabulary, the I6 class or an I8 constructor"
	leaked=$((leaked + 1))
fi
if grep -qE 'randi|randf|randomize|RandomNumberGenerator|rand_from_seed|Time\.|OS\.|Engine\.|ProjectSettings|InputMap|FileAccess|DirAccess|ConfigFile|ResourceSaver|ResourceLoader|user://' "$PROJECT_DIR/$RECEIPT"; then
	fail "the receipt reads ambient state or storage"
	leaked=$((leaked + 1))
fi
receipt_code="$(grep -vE '^[[:space:]]*#' "$PROJECT_DIR/$RECEIPT")"
if grep -qE '[*/+]|[0-9]\.[0-9]' <<< "$receipt_code"; then
	fail "the receipt multiplies, divides, adds or carries a floating-point literal in code"
	leaked=$((leaked + 1))
fi
if grep -qE 'new_build|new_ledger' <<< "$receipt_code"; then
	fail "the receipt's code reads the choice result's build or ledger"
	leaked=$((leaked + 1))
fi
for member in 'from_choice.support_content_kind' 'from_choice.support_fallback_category'; do
	if [[ "$(grep -cF "$member" <<< "$receipt_code")" != "1" ]]; then
		fail "the receipt does not copy $member exactly once"
		leaked=$((leaked + 1))
	fi
done
if [[ "$leaked" == "0" ]]; then
	pass "the receipt names nothing concrete, reads nothing ambient, does no arithmetic, reads no build or ledger, and copies both new facts once each"
fi

# NOTHING THAT RUNS CONSUMES THE NEW MEMBERS, measured from outside the engine, with a floor
# on what was searched — a scan over a directory that does not exist looks exactly clean.
searched="$(find "$PROJECT_DIR/scripts" "$PROJECT_DIR/scenes" "$PROJECT_DIR/data" "$PROJECT_DIR/addons" \
	-type f \( -name '*.gd' -o -name '*.tscn' -o -name '*.tres' \) 2>/dev/null | wc -l | tr -d ' ')"
referenced=0
for member in "${NEW_MEMBERS[@]}"; do
	while IFS= read -r hit; do
		case "$hit" in
			*/scripts/levels/rift_level_up_result.gd)
				continue ;;
			*/scripts/choices/rift_offer_choice_result.gd)
				case "$member" in
					support_content_kind|support_fallback_category|carries_support_fallback) continue ;;
				esac ;;
			*/scripts/choices/rift_offer_choice.gd)
				case "$member" in
					support_content_kind) continue ;;
				esac ;;
			*/scripts/offers/rift_offer.gd)
				case "$member" in
					support_content_kind|support_fallback_line) continue ;;
				esac ;;
			# Roguelite I10 (D-312): the standing-offer readings of both coordinators and the
			# mote runtime, and the running review's rendering of a consumed fallback — granted
			# exactly as in the engine-side scan.
			*/scripts/levels/rift_level_up_coordinator.gd|*/scripts/levels/rift_run_level_coordinator.gd|*/scripts/experience/rift_mote_runtime.gd)
				case "$member" in
					support_content_kind|support_fallback_category) continue ;;
				esac ;;
			*/scripts/roguelite/level_up/roguelite_level_up_choice_review.gd)
				case "$member" in
					support_content_kind|support_fallback_category|carries_support_fallback) continue ;;
				esac ;;
		esac
		fail "$(basename "$hit") names $member"
		referenced=$((referenced + 1))
	done < <(grep -rlF -- "$member" "$PROJECT_DIR/scripts" "$PROJECT_DIR/scenes" \
		"$PROJECT_DIR/data" "$PROJECT_DIR/addons" 2>/dev/null)
	if grep -qF -- "$member" "$PROJECT_DIR/project.godot"; then
		fail "project.godot names $member"
		referenced=$((referenced + 1))
	fi
done
if [[ "$searched" -le 100 ]]; then
	fail "the shell-side scan found only $searched project files, so it proves nothing"
elif [[ "$referenced" == "0" ]]; then
	pass "$searched project files scanned in the shell: outside the receipt, only the choice result, the transaction, the offer and — since I10 — both coordinators, the mote runtime and the running review name any of the four new members, each only its own, and nothing in project.godot does"
fi

readers="$(grep -rlF RiftLevelUpResult "$PROJECT_DIR/scripts" "$PROJECT_DIR/scenes" "$PROJECT_DIR/data" \
	"$PROJECT_DIR/addons" 2>/dev/null | sed "s|$PROJECT_DIR/||" | grep -vx "$RECEIPT" | sort | tr '\n' ' ' | sed 's/ $//')"
reading=0
for reader in $readers; do
	for member in "${NEW_MEMBERS[@]}"; do
		# Roguelite I10 (D-312): each reader may name exactly its grant — the same grants as
		# the engine-side scan's MEMBER_OWNERS.
		case "$reader" in
			scripts/levels/rift_level_up_coordinator.gd|scripts/levels/rift_run_level_coordinator.gd)
				case "$member" in
					support_content_kind|support_fallback_category) continue ;;
				esac ;;
			scripts/roguelite/level_up/roguelite_level_up_choice_review.gd)
				case "$member" in
					support_content_kind|support_fallback_category|carries_support_fallback) continue ;;
				esac ;;
		esac
		if grep -qF -- "$member" "$PROJECT_DIR/$reader"; then
			fail "$reader reads the receipt's $member"
			reading=$((reading + 1))
		fi
	done
done
if [[ "$readers" == "$EXPECTED_READERS" && "$reading" == "0" ]]; then
	pass "exactly 4 running files besides the receipt name its class, and none of them names a new member beyond its I10 (D-312) grant"
else
	fail "the receipt's class is named by [$readers]"
fi

levels_listing="$(find "$PROJECT_DIR/scripts/levels" -mindepth 1 -maxdepth 1 -exec basename {} \; | sort | tr '\n' ' ' | sed 's/ $//')"
if [[ "$levels_listing" == "$EXPECTED_LEVELS_DIR" ]]; then
	pass "scripts/levels/ holds exactly its four scripts and four uid files"
else
	fail "scripts/levels/ holds '$levels_listing'"
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
	printf 'PASSIVE FALLBACK LEVEL-UP RECEIPT SMOKE CHECKS: PASS\n'
	printf '  %s checks; %s of %s owed; %s protected files byte-identical\n' \
		"$EXPECTED_CHECKS" "$EXPECTED_OWED_CHECKS" "$EXPECTED_OWED_CHECKS" "${#PRESERVED_FILES[@]}"
	printf '  Roguelite Foundation I9 — Immutable Passive-Fallback Level-Up Receipt\n'
	printf '  Propagation — is DELIVERED under D-310 and ACCEPTED and CLOSED at the\n'
	printf '  immutable passive-fallback level-up-receipt propagation mechanism level\n'
	printf '  under D-311.\n'
	reached_end=1
	exit 0
else
	printf 'PASSIVE FALLBACK LEVEL-UP RECEIPT SMOKE CHECKS: %d FAILURE(S)\n' "$failures"
	reached_end=1
	exit 1
fi
