#!/usr/bin/env bash
# Riftwrought — Roguelite Foundation I7 smoke checks: Exhausted-Support Passive-Fallback
# Offer Composition (decision D-306).
#
# THIS IS NOT A GATE, AND IT RUNS NO LOCKED CHAIN.
#
# I7 composes the accepted I6 passive fallback into the accepted three-lane offer. When
# the Support continuation is honestly exhausted and both passive lanes are sound, the
# Support lane carries a PASSIVE_FALLBACK — one card, never either passive lane's — drawn
# from the same supplied records with the Support lane's own seed; otherwise every offer
# composes exactly as before. It edits the two offer files and no other production file,
# and it is NOT consumable yet: the unchanged choice transaction refuses a fallback
# Support lane. It adds no scene, panel, HUD, evidence frame, asset, `.tres`, InputMap
# action or storage, and nothing that runs reaches it. What this script proves:
#
#   0. the engine is the locked 4.7.2 and every protected file is fingerprinted;
#   1. both edited offer files, the new suite and the three accepted suites whose pins
#      moved one for one all parse, and the three accepted runners edited beside them
#      are valid shell;
#   2. the pinned verification passes — its check count AND its owed-check count each
#      proved in BOTH directions against a replay of its own log — with zero SCRIPT
#      ERROR, zero engine ERROR and zero engine WARNING, and the measured lines read out
#      of its own log;
#   3. both offer files name exactly the project classes recorded below and nothing
#      concrete or ambient, and nothing else under scripts/, scenes/, data/ or addons/ —
#      nor project.godot — names any I7 member; scripts/offers/ and scripts/fallback/
#      hold exactly their files — in the shell as well as in the engine;
#   4. project.godot is untouched: 31 actions, the Prototype App entrypoint, no
#      [autoload];
#   5. the run wrote nothing, .godot/ is byte-identical across it, every protected file
#      is byte-identical, and the project owner's own user:// files are untouched.
#
# Roguelite Foundation I8 (D-308) has since made a fallback Support lane consumable
# through the choice transaction. The verification's check 12 and six measured lines
# below moved one for one, the two choice files' hash rows moved, and step 3 grants
# those two files the five Support-content members they now name. The count did not
# move.
#
# Roguelite Foundation I9 (D-310) has since extended the one-level level-up receipt so a
# consumed fallback reaches it coherently. Check 12's receipt assertion and its measured
# line moved one for one, the receipt's hash row moved, and the receipt is granted the same
# five Support-content members in both scans; two further measured lines name that grant
# and that hash. The count did not move.
#
# Usage, from the repository root:
#   game/tests/passive_fallback_offer_composition_smoke.sh

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
		printf '\nPASSIVE FALLBACK OFFER COMPOSITION SMOKE CHECKS: ABORTED before the end of the script\n'
		printf '  the run stopped early (exit %s) — nothing after that point was proved\n' "$status"
		exit 1
	fi
	exit "$status"
}
trap on_exit EXIT

GODOT="${GODOT:-/Applications/Godot.app/Contents/MacOS/Godot}"
EXPECTED_VERSION="4.7.2.stable"
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

THIS_VERIFICATION="tests/passive_fallback_offer_composition_verification.gd"
VERIFICATION="res://$THIS_VERIFICATION"
VERIFY_BANNER="PASSIVE FALLBACK OFFER COMPOSITION VERIFICATION"

# Pinned, and proved in both directions below.
EXPECTED_CHECKS=1104
EXPECTED_OWED_CHECKS=18
EXPECTED_INPUT_ACTIONS=31
EXPECTED_MAIN_SCENE="res://scenes/app/prototype_app.tscn"

EDITED_PRODUCTION=(
	"scripts/offers/rift_offer.gd"
	"scripts/offers/rift_offer_composition.gd"
)
# The three accepted verifications whose pins I7 moved one for one.
MOVED_SUITES=(
	"tests/rift_offer_composition_verification.gd"
	"tests/maximum_rank_support_filtering_verification.gd"
	"tests/support_exhaustion_passive_fallback_verification.gd"
)
# The three accepted runners edited beside them: a pinned row or a measured line.
MOVED_RUNNERS=(
	"tests/rift_offer_composition_smoke.sh"
	"tests/maximum_rank_support_filtering_smoke.sh"
	"tests/support_exhaustion_passive_fallback_smoke.sh"
)

# Exactly the project classes each edited file names, sorted.
EXPECTED_OFFER_NAMES="AcquiredSupports PassiveCardSelection PassiveCardSelectionResult PlayerStatDefinition RiftOffer SupportContinuation SupportContinuationResult SupportExhaustionPassiveFallback SupportExhaustionPassiveFallbackResult SupportSelection SupportSelectionResult"
EXPECTED_COMPOSER_NAMES="AcquiredSupports PassiveCardDefinition PassiveCardSelection PassiveCardSelectionResult RiftOffer RiftOfferComposition SkillTagProfile SupportContinuation SupportContinuationResult SupportDefinition SupportExhaustionPassiveFallback SupportExhaustionPassiveFallbackResult"
EXPECTED_OFFERS_DIR="rift_offer.gd rift_offer.gd.uid rift_offer_composition.gd rift_offer_composition.gd.uid"
EXPECTED_FALLBACK_DIR="support_exhaustion_passive_fallback.gd support_exhaustion_passive_fallback.gd.uid support_exhaustion_passive_fallback_result.gd support_exhaustion_passive_fallback_result.gd.uid"
# Members only I7 introduces; nothing outside the two offer files may name one.
I7_TOKENS=(
	"SupportContentKind" "PASSIVE_FALLBACK" "SUPPORT_PROGRESSION" "support_content_kind"
	"support_fallback" "composed_with_passive_fallback" "refused_as_fallback_unavailable"
	"is_support_fallback_unavailable"
)

# DELIBERATELY SHORT, AND NOT A WHOLE-PROJECT CATALOGUE: the files I7 reads, stands
# beside or could conceivably disturb, and the project owner's work. Every `.tres` under
# data/ is added below, enumerated rather than typed.
PRESERVED_FILES=(
	"project.godot"
	"../CLAUDE.md"
	"../README.md"
	"scenes/first_mvp/zone_composer_practice.tscn"
	"assets/prototype/ui/loading/riftwrought-loading-teaser-v1.png"
	"assets/prototype/ui/loading/riftwrought-loading-teaser-v1.png.import"
	"scripts/offers/rift_offer.gd"
	"scripts/offers/rift_offer_composition.gd"
	"scripts/fallback/support_exhaustion_passive_fallback.gd"
	"scripts/fallback/support_exhaustion_passive_fallback_result.gd"
	"scripts/stats/passive_card_definition.gd"
	"scripts/stats/passive_card_catalogue.gd"
	"scripts/stats/passive_card_selection.gd"
	"scripts/stats/passive_card_selection_result.gd"
	"scripts/skills/support_definition.gd"
	"scripts/skills/support_selection.gd"
	"scripts/skills/support_selection_result.gd"
	"scripts/skills/skill_support_catalogue.gd"
	"scripts/skills/acquired_supports.gd"
	"scripts/continuation/support_continuation.gd"
	"scripts/continuation/support_continuation_result.gd"
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
	"scripts/roguelite/live_effects/roguelite_live_effect_review.gd"
	"scripts/roguelite/level_up/roguelite_level_up_choice_review.gd"
	"scripts/roguelite/level_up/rift_level_up_offer_panel.gd"
	"scripts/ui/first_mvp_modal.gd"
	"tests/rift_offer_composition_verification.gd"
	"tests/rift_offer_composition_smoke.sh"
	"tests/maximum_rank_support_filtering_verification.gd"
	"tests/maximum_rank_support_filtering_smoke.sh"
	"tests/support_exhaustion_passive_fallback_verification.gd"
	"tests/support_exhaustion_passive_fallback_smoke.sh"
	"tests/rank_aware_offer_composition_verification.gd"
	"tests/rift_support_rank_choice_verification.gd"
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

printf 'Riftwrought — Roguelite Foundation I7: Exhausted-Support Passive-Fallback Offer Composition (D-306)\n'
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
run_marker="$(mktemp -t riftwrought_passive_fallback_offer_marker)"
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
for runner in "${MOVED_RUNNERS[@]}" "tests/passive_fallback_offer_composition_smoke.sh"; do
	if bash -n "$PROJECT_DIR/$runner" 2>/dev/null; then
		pass "$runner is valid shell"
	else
		fail "$runner is not valid shell"
	fi
done

# --------------------------------------------------------------------------
step "2. The pinned verification passes, proved in BOTH directions"
verify_log="/tmp/riftwrought_passive_fallback_offer_composition_verify.log"
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
replay="$(mktemp -t riftwrought_passive_fallback_offer_replay)"
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
root seed 18, both pairs at rank 2: lanes [Support, Combat and Defence, Utility], seeds 51507111 / 1168206400 / 3720129402; Support PASSIVE_FALLBACK [card_celerity], Combat and Defence [card_power], Utility [card_insight]
the fallback: category ticket 3141935186 -> position 0 of 2 -> Combat and Defence; card ticket 1617272035 -> 35 of 200 over [card_celerity x100, card_vitality x100] -> card_celerity; excluded [card_power, card_insight]
256 of 256 root seeds at R2 S2 compose a whole PASSIVE_FALLBACK offer: fixed lane order, one-card Support identity, a coherent I6 derivation, no support progression
4698 non-exhausted offers (8 shipped states + a null record x 522 root seeds) hash 5976e0b070b7c433 — identical to the pre-I7 composer's
4698 of 4698 are SUPPORT_PROGRESSION with a two-id Support identity, their original kind and ranks, and no fallback
960 non-exhausted refusals (no definitions, no profiles, no cards, one category only x 3 states x 64 seeds) hash dae784d6e43a2588 — identical
14 of 14 D1 / F3 corpus rows exact, the typed corpus equal to both accepted suites' own; F3's root seed 18 rank example sweeping_edge 1 -> 2, card_power, card_insight
17 of 17 frozen rows exact (root seed, 3 lane seeds, both ordinary cards, both raw fallback tickets, fallback category and card); 17 reproduce through select_with_tickets(); 17 match an in-suite derivation from the documented formulas
4096 exhausted offers over root seeds 0-4095: a carried card returned 0 times, on a nested ladder 0 times; excluded == [Combat and Defence card, Utility card] in lane order 4096 of 4096; 9 of 9 source pairs reached
256 of 256: both passive ladders are exactly its categories, the fallback ladder is its chosen category minus the two carried cards, and the fallback equals I6 asked directly with that catalogue and the Support lane seed; 0 shipped ids anywhere
the same three derivations re-asked against the shipped catalogue refuse 256 of 256 times — a fallback drawn from another catalogue cannot be composed
2368 answers over 9 shipped states x 64 root seeds x 4 reversals (Skills, supports, cards, all three), plus 64 on a fabricated catalogue: 0 moved, the 64 R2 S2 answers all passive fallbacks
100 repeated compositions of root seed 18 at R2 S2: 0 drifted
4096 of 4096 exhausted offers carry exactly the tickets the Support lane seed derives, and I6's pure core reproduces each
all 8 boundaries (category positions 0 and 1 x card positions 0, 99, 100 and 199) found within 754 root seeds: position 0 -> Combat and Defence, 1 -> Utility; 0-99 -> the first remaining card, 100-199 -> the second; 0 wrong
those 8 offers' nested ladders walked whole (1600 positions): each remaining card owns 100 of 200; each category owns exactly 1 of 2 category positions
weighted: 256 of 256 fabricated-catalogue offers walked whole (2180 positions) — every remaining card owns exactly its integer weight, and the chosen card owns the walked ticket
Utility holds one card: 256 of 256 offers draw the fallback from Combat and Defence, the category ladder [0]
Combat and Defence holds one card: 256 of 256 offers draw the fallback from Utility, the category ladder [1]
a fabricated one-card-per-category catalogue: 256 of 256 root seeds refuse whole at the Support lane, is_support_fallback_unavailable() true, no lane, seed, identity, derivation, kind, card or rank; 256 of 256 compose while support is not exhausted
the shipped two-card catalogue [card_celerity, card_fleetness]: 256 of 256 root seeds refuse whole at the Support lane, is_support_fallback_unavailable() true, no lane, seed, identity, derivation, kind, card or rank; 256 of 256 compose while support is not exhausted
the reason: 'the Support lane refused: the support lane is exhausted: every compatible support pair is already held at its maximum supported rank, so nothing new can be selected and nothing held can be raised; and its passive fallback is unavailable: no passive card remains in either category once the two cards this offer already carries are excluded'
through the unchanged one-level coordinator: the offer does not open, Level 1, the level-up still ready, 0 seeds consumed, nothing frozen
an unknown stat: 256 of 256 root seeds refuse whole at the Combat and Defence lane with one identical reason, the fallback not attempted
a zero weight: 256 of 256 root seeds refuse whole at the Combat and Defence lane with one identical reason, the fallback not attempted
a duplicated id: 256 of 256 root seeds refuse whole at the Combat and Defence lane with one identical reason, the fallback not attempted
a null record: 256 of 256 root seeds refuse whole at the Combat and Defence lane with one identical reason, the fallback not attempted
a Utility pool one past the ceiling: 256 of 256 root seeds refuse whole at the Utility lane with one identical reason, the fallback not attempted
a Combat and Defence pool one past the ceiling: 256 of 256 root seeds refuse whole at the Combat and Defence lane with one identical reason, the fallback not attempted
STRUCTURAL: with one catalogue feeding all three lanes, the passive lanes validate the same whole record set first, so I6's own malformed-record and over-ceiling refusals are unreachable through composition
exhausted, no Combat and Defence card: 64 of 64 refuse at the Combat and Defence lane — 'the Combat and Defence lane refused: no supplied passive card belongs to the Combat and Defence category; the exhausted Support lane's passive fallback was not attempted'
exhausted, no Utility card: 64 of 64 refuse at the Utility lane — 'the Utility lane refused: no supplied passive card belongs to the Utility category; the exhausted Support lane's passive fallback was not attempted'
exhausted, no card at all: 64 of 64 refuse at the Combat and Defence lane — 'the Combat and Defence lane refused: no passive card records were given (2 of 3 lanes refused); the exhausted Support lane's passive fallback was not attempted'
not exhausted, no Combat and Defence card (accepted): 64 of 64 refuse at the Combat and Defence lane — 'the Combat and Defence lane refused: no supplied passive card belongs to the Combat and Defence category'
an ordinary Support refusal (no definitions) beside a refusing passive lane: 64 of 64 still named Support with '(2 of 3 lanes refused)'
the composer calls SupportExhaustionPassiveFallback.select( exactly once, behind 'if exhausted and passive_lanes_sound:', reading is_exhausted() once
2368 of 2368 refused offers collected by checks 8-10 carry their own root seed and nothing else (12 distinct reasons; by lane Combat and Defence 1472, Support 576, Utility 320)
256 of 256 fallback offers: the Support lane is consumed as one passive card — its identity the fallback card, its category the fallback's, the card held once more, the seed spent once, no pair or rank moved, and the supplied values byte-identical
RECORDED, NOT DECIDED HERE: through the unchanged one-level coordinator at root seed 18 the fallback offer opens with Support [card_celerity] and choosing it completes the level-up — Level 2, 1 seed consumed, card_celerity held once — and since I9 (D-310) its receipt is coherent and records it: 'passive fallback: card_celerity, drawn from Combat and Defence'
RECORDED, NOT DECIDED HERE: the choice transaction takes the two ORDINARY passive lanes of a fallback offer exactly as before — 512 of 512 such choices spent their seed and granted their card
running files scanned: none but the two offer files names an I7 member, except the five Support-content members the two D3 choice files are granted since I8 (D-308) and the level-up receipt since I9 (D-310), and the members I10 (D-312) grants both level-up coordinators, the mote runtime and the running review; none but the offer files and I6's own two names the fallback class; project.godot names none
the only running caller of the level-up offer is [roguelite_level_up_choice_review.gd], which since I11 (D-314) asks each level's offer once, beginning at Level 1; a fresh build composes 4096 of 4096 SUPPORT_PROGRESSION new pairs and 0 fallbacks
project.godot: 31 actions, the Prototype App entrypoint, no [autoload]
23 of 23 single-field tamperings reported by name — 16 on a fallback offer, 3 on a progression offer, 4 on a refusal; the choice transaction refuses 19 of 19 tampered offers as incoherent
methods pinned: offer 21, composer 5; the offer carries 21 fields (the accepted 17 plus 4 appended); composer state: 0 fields
SupportContentKind {SUPPORT_PROGRESSION: 0, PASSIVE_FALLBACK: 1}, unresolved -1; the offer names exactly 11 project classes and the composer 12
both files scanned raw: 0 concrete names, 0 ambient reads; the composer calls the fallback once with the supplied cards and the Support lane seed and reads no sentence; the offer selects nothing
27 of 27 accepted files at their pinned SHA-256 prefix — byte-identical to the tree before the first I7 edit except the choice transaction and its result, pinned at their D-308 hashes, and the level-up receipt, pinned at its D-310 hash
the offer 9bc94208… and the composer 15ef203a… at their D-306 hashes
D1: offer methods and fields and the two new classes pinned; I5: is_exhausted( granted to both offer files (4 owners); I6: the offer and composer hash prefixes moved to 9bc94208 / 15ef203a (24 rows) and both offer files granted the fallback classes
2644 refusals were driven across this suite
MEASURED
if [[ "$measured" == "$measured_total" ]]; then
	pass "$measured of $measured_total measured lines found in the run's own log"
fi

# --------------------------------------------------------------------------
step "3. The offer files name exactly their classes and nothing concrete, and nothing else names an I7 member"
PROJECT_CLASSES="$(grep -oE '"class": &"[A-Za-z0-9_]+"' "$PROJECT_DIR/.godot/global_script_class_cache.cfg" \
	| sed -E 's/.*&"([^"]+)"/\1/' | sort -u)"
class_total="$(printf '%s\n' "$PROJECT_CLASSES" | grep -c .)"
if [[ "$class_total" -gt 150 ]] && printf '%s\n' "$PROJECT_CLASSES" | grep -qx "SupportExhaustionPassiveFallback"; then
	pass "the engine's class cache lists $class_total project classes"
else
	fail "the class cache lists $class_total classes"
fi
for row in "scripts/offers/rift_offer.gd|$EXPECTED_OFFER_NAMES" \
		"scripts/offers/rift_offer_composition.gd|$EXPECTED_COMPOSER_NAMES"; do
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
	if grep -qE 'card_(power|celerity|vitality|fleetness|insight|magnetism)|quick_strike|QuickStrike|Quick Strike|reaching_edge|Reaching Edge|sweeping_edge|Sweeping Edge|PassiveCardCatalogue|SkillSupportCatalogue|display_name' "$PROJECT_DIR/$file"; then
		fail "$file names a concrete card, Skill, support, catalogue or presentation name"
		leaked=$((leaked + 1))
	fi
	if grep -qE 'randi|randf|randomize|RandomNumberGenerator|rand_from_seed|Time\.|OS\.|Engine\.|ProjectSettings|InputMap|FileAccess|DirAccess|ConfigFile|ResourceSaver|ResourceLoader|user://' "$PROJECT_DIR/$file"; then
		fail "$file reads ambient state or storage"
		leaked=$((leaked + 1))
	fi
done
if [[ "$leaked" == "0" ]]; then
	pass "neither offer file names anything concrete or reads ambient state"
fi

# NOTHING THAT RUNS REACHES IT, measured from outside the engine, with a floor on what
# was searched — a scan over a directory that does not exist looks exactly clean.
searched="$(find "$PROJECT_DIR/scripts" "$PROJECT_DIR/scenes" "$PROJECT_DIR/data" "$PROJECT_DIR/addons" \
	-type f \( -name '*.gd' -o -name '*.tscn' -o -name '*.tres' \) 2>/dev/null | wc -l | tr -d ' ')"
referenced=0
for token in "${I7_TOKENS[@]}"; do
	while IFS= read -r hit; do
		case "$hit" in
			*/scripts/offers/rift_offer.gd|*/scripts/offers/rift_offer_composition.gd)
				continue ;;
		esac
		# Roguelite Foundation I8 (D-308): the two choice files route on and record the
		# Support content kind, so each is granted exactly the five Support-content members
		# — granted exactly as in the engine-side scan. Roguelite Foundation I9 (D-310): the
		# level-up receipt records the same content kind and is granted the same five.
		case "$hit" in
			*/scripts/choices/rift_offer_choice.gd|*/scripts/choices/rift_offer_choice_result.gd|*/scripts/levels/rift_level_up_result.gd)
				case "$token" in
					SupportContentKind|PASSIVE_FALLBACK|SUPPORT_PROGRESSION|support_content_kind|support_fallback)
						continue ;;
				esac ;;
		esac
		# Roguelite I10 (D-312): both level-up coordinators, the mote runtime and the running
		# review are granted exactly the Support-content members each names — granted exactly
		# as in the engine-side scan.
		case "$hit" in
			*/scripts/levels/rift_level_up_coordinator.gd)
				case "$token" in
					SupportContentKind|PASSIVE_FALLBACK|support_content_kind|support_fallback)
						continue ;;
				esac ;;
			*/scripts/levels/rift_run_level_coordinator.gd|*/scripts/experience/rift_mote_runtime.gd)
				case "$token" in
					support_content_kind|support_fallback)
						continue ;;
				esac ;;
			*/scripts/roguelite/level_up/roguelite_level_up_choice_review.gd)
				case "$token" in
					SupportContentKind|PASSIVE_FALLBACK|SUPPORT_PROGRESSION|support_content_kind|support_fallback)
						continue ;;
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
	pass "$searched project files scanned in the shell: nothing but the two offer files — and the two choice files' and the level-up receipt's five granted Support-content members, and the members I10 grants both level-up coordinators, the mote runtime and the running review — names an I7 member, and nothing in project.godot does"
fi

offers_listing="$(find "$PROJECT_DIR/scripts/offers" -mindepth 1 -maxdepth 1 -exec basename {} \; | sort | tr '\n' ' ' | sed 's/ $//')"
fallback_listing="$(find "$PROJECT_DIR/scripts/fallback" -mindepth 1 -maxdepth 1 -exec basename {} \; | sort | tr '\n' ' ' | sed 's/ $//')"
if [[ "$offers_listing" == "$EXPECTED_OFFERS_DIR" && "$fallback_listing" == "$EXPECTED_FALLBACK_DIR" ]]; then
	pass "scripts/offers/ and scripts/fallback/ each hold exactly their two scripts and two uid files"
else
	fail "scripts/offers/ holds '$offers_listing'; scripts/fallback/ holds '$fallback_listing'"
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
	printf 'PASSIVE FALLBACK OFFER COMPOSITION SMOKE CHECKS: PASS\n'
	printf '  %s checks; %s of %s owed; %s protected files byte-identical\n' \
		"$EXPECTED_CHECKS" "$EXPECTED_OWED_CHECKS" "$EXPECTED_OWED_CHECKS" "${#PRESERVED_FILES[@]}"
	printf '  Roguelite Foundation I7 — Exhausted-Support Passive-Fallback Offer\n'
	printf '  Composition — is DELIVERED under D-306 and ACCEPTED and CLOSED at the\n'
	printf '  deterministic passive-fallback offer-composition mechanism level under\n'
	printf '  D-307.\n'
	reached_end=1
	exit 0
else
	printf 'PASSIVE FALLBACK OFFER COMPOSITION SMOKE CHECKS: %d FAILURE(S)\n' "$failures"
	reached_end=1
	exit 1
fi
