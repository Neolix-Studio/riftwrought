#!/usr/bin/env bash
# Riftwrought — Roguelite Foundation I5: Maximum-Rank Support Filtering and Honest
# Exhaustion smoke checks (decision D-300, corrected under D-301).
#
# THIS IS NOT A GATE, AND IT RUNS NO LOCKED CHAIN.
#
# D-301 CORRECTED TWO DEFECTS BEFORE ACCEPTANCE: a definition with no usable maximum
# still passed ordinary validation and could be acquired, and the continuation entered
# its rank phase after a new-pair refusal that was not an empty candidate set. A usable
# maximum is now part of `SupportDefinition.problem()`, a pair held above its maximum
# is refused as invalid acquisition state, the selector's result classifies a valid
# empty candidate set, and the continuation advances only on that classification. The
# selector's result file joined the edited set, and two further accepted suites moved
# one for one because their fixtures now declare a maximum.
#
# D-302 CORRECTED FOUNDATION B'S SELECTOR ONCE MORE: every candidate Skill's weight
# ladder is built and validated before stage one draws, so a malformed pool refuses
# the whole selection on every seed rather than only on the seeds that drew it. The
# selector is the only production file it edits; F2's suite moved one for one.
#
# I5 is a headless MECHANISM. The generic support definition gains a maximum rank; the
# two shipped maxima are DERIVED from `SkillSupportCatalogue`'s exact applied-rank
# records; the accepted weighted selector gains a rank-increase draw that excludes a
# pair at its maximum; and the accepted continuation reports EXHAUSTION as an explicit,
# stored classification, which the accepted rank-aware composer turns into a whole-offer
# refusal with no special case of its own. It adds no scene, panel, HUD, evidence frame,
# asset, `.tres`, InputMap action or storage, and it is not the entrypoint. What this
# script proves:
#
#   0. the engine is the locked 4.7.2 and every protected file is fingerprinted;
#   1. the seven edited production scripts, the new suite and the seven accepted suites
#      I5 moved one for one all parse;
#   2. the edited files name no asset or storage, each names exactly the project classes
#      recorded below, the catalogue computes with no rank, every new member is named only
#      by the files that own it, the three touched directories hold exactly their
#      scripts, and the new suite reads no other suite — in the shell as well as in the
#      engine, because a scan that only runs inside the thing it audits is one process
#      away from proving nothing;
#   3. the pinned verification passes — its check count AND its owed-check count each
#      proved in BOTH directions against a replay of its own log — with zero SCRIPT
#      ERROR, zero engine ERROR and zero engine WARNING, the measured lines read out of
#      that log, and a run that hangs killed and failed;
#   4. `project.godot` is untouched: 31 actions, the Prototype App entrypoint, the same
#      nine sections, no `[autoload]`, nothing naming I5;
#   5. the third-party inventory has not moved (185 + 2 = 187);
#   6. the run wrote nothing: no file under `game/` outside `.godot/` is newer than the
#      run's start, `.godot/` is byte-identical, and no `.uid` sidecar sits beside the
#      new suite;
#   7. every protected file — the canonical `.tres` records, the loading teaser with its
#      import record and imported cache, the eighteen accepted H9/I2/I3 evidence frames,
#      the combat and movement kernels, the I3 seam and its result, the run build and
#      its records, the offer record and the choice transaction, the level-up files, the
#      accepted suites I5 did not move, the project owner's composed zone,
#      `project.godot`, `CLAUDE.md` and `README.md` — is BYTE-IDENTICAL across the run,
#      and the project owner's own user:// files are untouched.
#
# THE SEVEN EDITED PRODUCTION FILES AND THE SEVEN MOVED SUITES ARE DELIBERATELY NOT IN
# THE PROTECTED LIST, because I5 edits them on purpose; the accepted suites that own or
# guard them are run by their own runners (D-300 and D-301 name which, and why).
#
# Usage, from the repository root:
#   game/tests/maximum_rank_support_filtering_smoke.sh

set -uo pipefail

# Assigned at the TOP of the script, never beside the function it serves: a shell
# evaluates an assignment only when execution REACHES it.
RUN_STARTED_AT="$(date +%s)"

# A SCRIPT THAT DIES HALFWAY MUST NOT REPORT SUCCESS.
reached_end=0
scratch_replay=""
run_marker=""
on_exit() {
	local code=$?
	[[ -n "$scratch_replay" ]] && rm -f "$scratch_replay"
	[[ -n "$run_marker" ]] && rm -f "$run_marker"
	if [[ "$reached_end" != "1" ]]; then
		printf '\nMAXIMUM RANK SUPPORT FILTERING SMOKE CHECKS: ABORTED before the end of the script\n'
		printf '  the run stopped early (exit %s) — nothing after that point was proved\n' "$code"
		exit 1
	fi
	exit "$code"
}
trap on_exit EXIT

GODOT="${GODOT:-/Applications/Godot.app/Contents/MacOS/Godot}"
EXPECTED_VERSION="4.7.2.stable"
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

VERIFICATION="res://tests/maximum_rank_support_filtering_verification.gd"
THIS_VERIFICATION="tests/maximum_rank_support_filtering_verification.gd"
PASS_LINE="MAXIMUM RANK SUPPORT FILTERING VERIFICATION"

# Pinned, and proved in both directions below: the count of the corrected suite's first
# green run. D-300 delivered 55 checks over 22 owed functions; D-301 took check 4 from 4
# assertions to 3 and added checks 23-26 at 5 + 2 + 4 + 4, so 55 - 1 + 15 = 69 over 26.
# D-302 kept check 26 at its 4 assertions and added checks 27-30 at 4 + 4 + 5 + 2, so
# 69 + 15 = 84 over 30.
EXPECTED_CHECKS=84
EXPECTED_OWED_CHECKS=30

# Seconds a verification may take before it is killed and counted as a failure.
VERIFICATION_TIMEOUT=600

EXPECTED_INPUT_ACTIONS=31
EXPECTED_MAIN_SCENE="res://scenes/app/prototype_app.tscn"
EXPECTED_SECTIONS="application audio debug display editor_plugins input layer_names navigation rendering"

# I5 extracts nothing. D-216's authorized numbers, unmoved.
EXPECTED_THIRD_PARTY_PAYLOADS=185
EXPECTED_THIRD_PARTY=187

# Every canonical `.tres` record under data/ is protected; how many there are is pinned.
EXPECTED_CANONICAL_RECORDS=17

DEFINITION="scripts/skills/support_definition.gd"
SELECTION="scripts/skills/support_selection.gd"
SELECTION_RESULT="scripts/skills/support_selection_result.gd"
CONTINUATION="scripts/continuation/support_continuation.gd"
RESULT="scripts/continuation/support_continuation_result.gd"
CATALOGUE="scripts/skills/skill_support_catalogue.gd"
COMPOSER="scripts/offers/rift_offer_composition.gd"

EDITED_PRODUCTION=(
	"$DEFINITION"
	"$SELECTION"
	"$SELECTION_RESULT"
	"$CONTINUATION"
	"$RESULT"
	"$CATALOGUE"
	"$COMPOSER"
)

# The project classes each edited file names after I5, read from the engine's own class
# cache. Every set is the one measured before the first I5 edit EXCEPT the definition's,
# which gained `AcquiredSupports` for exactly one reason: its lowest usable maximum is
# that record's own first rank, read rather than retyped. The selector's result file
# joined the edited set under D-301 and names no class it did not already name.
EXPECTED_DEFINITION_NAMES="AcquiredSupports SkillTagProfile SkillTags SupportDefinition SupportEligibility"
EXPECTED_SELECTION_NAMES="AcquiredSupports SkillTagProfile SupportDefinition SupportSelection SupportSelectionResult"
EXPECTED_SELECTION_RESULT_NAMES="SupportSelection SupportSelectionResult"
EXPECTED_CONTINUATION_NAMES="AcquiredSupports SkillTagProfile SupportContinuation SupportContinuationResult SupportDefinition SupportSelection SupportSelectionResult"
EXPECTED_RESULT_NAMES="SupportContinuation SupportContinuationResult SupportSelection SupportSelectionResult"
EXPECTED_CATALOGUE_NAMES="FirstMvpSkillData FirstMvpSkillLibrary QuickStrikeData RogueliteUpgrade SkillSupportCatalogue SkillTagProfile SkillTags SupportDefinition SupportEligibility"
# Roguelite Foundation I7 (D-306) makes the composer ask the accepted I6 fallback for an
# exhausted Support lane's card: the composer's set gains exactly those two classes.
EXPECTED_COMPOSER_NAMES="AcquiredSupports PassiveCardDefinition PassiveCardSelection PassiveCardSelectionResult RiftOffer RiftOfferComposition SkillTagProfile SupportContinuation SupportContinuationResult SupportDefinition SupportExhaustionPassiveFallback SupportExhaustionPassiveFallbackResult"

# The seven edited production scripts, this suite, and the seven accepted suites I5
# moved — the last two by D-301, whose fixtures now declare a maximum.
PARSED_SCRIPTS=(
	"${EDITED_PRODUCTION[@]}"
	"$THIS_VERIFICATION"
	"tests/support_continuation_verification.gd"
	"tests/support_selection_verification.gd"
	"tests/rift_offer_composition_verification.gd"
	"tests/rank_aware_offer_composition_verification.gd"
	"tests/rift_support_rank_choice_verification.gd"
	"tests/rift_level_up_support_progression_verification.gd"
	"tests/ranked_support_ownership_verification.gd"
)

# Every running file allowed to name each new member, `token|file,file`. A member named
# anywhere else fails, and every file listed must really name it — a grant that cannot
# fail is not a boundary.
# Roguelite Foundation I6 (D-304) grants `is_exhausted(` to its exhausted-support passive
# fallback, which activates only on that classification: one row widened, owned uses 16 -> 17.
# Roguelite Foundation I7 (D-306) grants it to both offer files: the composer activates
# the fallback only on that classification and the offer re-asks it of a fallback lane's
# continuation. The same row widened again, owned uses 17 -> 19.
NEW_MEMBER_ROWS=(
	"select_rank_increase|support_selection.gd,support_continuation.gd"
	"is_rank_exhausted|support_selection.gd,support_continuation.gd"
	"is_exhausted(|support_continuation_result.gd,support_exhaustion_passive_fallback.gd,rift_offer_composition.gd,rift_offer.gd"
	"exhaustion(|support_continuation.gd,support_continuation_result.gd"
	"maximum_rank_from(|skill_support_catalogue.gd"
	"support_maximum_rank|skill_support_catalogue.gd"
	"maximum_rank|skill_support_catalogue.gd,support_definition.gd,support_selection.gd"
	"has_no_candidates(|support_continuation.gd,support_selection_result.gd"
	"no_candidates_found(|support_selection.gd,support_selection_result.gd"
)

# The three directories I5 edited a file in, and exactly what each holds.
EXPECTED_SKILLS_SCRIPTS="acquired_supports.gd first_mvp_active_bindings.gd first_mvp_skill_action.gd first_mvp_skill_data.gd first_mvp_skill_library.gd first_mvp_skill_projectile.gd skill_support_catalogue.gd skill_tag_profile.gd skill_tags.gd support_definition.gd support_eligibility.gd support_selection.gd support_selection_result.gd"
EXPECTED_CONTINUATION_SCRIPTS="support_continuation.gd support_continuation_result.gd"
EXPECTED_OFFERS_SCRIPTS="rift_offer.gd rift_offer_composition.gd"

# DELIBERATELY SHORT, AND NOT A WHOLE-PROJECT CATALOGUE: the files I5 reads, stands
# beside or could conceivably disturb, and the project owner's work. Every `.tres` under
# data/ is added below, enumerated rather than typed.
PRESERVED_FILES=(
	"project.godot"
	"../CLAUDE.md"
	"../README.md"
	"scenes/first_mvp/zone_composer_practice.tscn"
	"assets/prototype/ui/loading/riftwrought-loading-teaser-v1.png"
	"assets/prototype/ui/loading/riftwrought-loading-teaser-v1.png.import"
	".godot/imported/riftwrought-loading-teaser-v1.png-b052aa6f935e93824cd8ff133a3ff6f4.ctex"
	".godot/imported/riftwrought-loading-teaser-v1.png-b052aa6f935e93824cd8ff133a3ff6f4.md5"
	"../docs/testing/roguelite_experience_collection_review_evidence/01_uncollected_mote_pickup_off.png"
	"../docs/testing/roguelite_experience_collection_review_evidence/02_level_up_ready.png"
	"../docs/testing/roguelite_experience_collection_review_evidence/03_fresh_second_run.png"
	"../docs/testing/roguelite_experience_collection_review_evidence/1280x720/01_uncollected_mote_pickup_off.png"
	"../docs/testing/roguelite_experience_collection_review_evidence/1280x720/02_level_up_ready.png"
	"../docs/testing/roguelite_experience_collection_review_evidence/1280x720/03_fresh_second_run.png"
	"../docs/testing/roguelite_level_up_choice_review_evidence/01_three_card_offer.png"
	"../docs/testing/roguelite_level_up_choice_review_evidence/02_support_receipt.png"
	"../docs/testing/roguelite_level_up_choice_review_evidence/03_passive_receipt.png"
	"../docs/testing/roguelite_level_up_choice_review_evidence/1280x720/01_three_card_offer.png"
	"../docs/testing/roguelite_level_up_choice_review_evidence/1280x720/02_support_receipt.png"
	"../docs/testing/roguelite_level_up_choice_review_evidence/1280x720/03_passive_receipt.png"
	"../docs/testing/roguelite_live_effect_review_evidence/01_sweeping_edge_live.png"
	"../docs/testing/roguelite_live_effect_review_evidence/02_celerity_live.png"
	"../docs/testing/roguelite_live_effect_review_evidence/03_fleetness_live.png"
	"../docs/testing/roguelite_live_effect_review_evidence/1280x720/01_sweeping_edge_live.png"
	"../docs/testing/roguelite_live_effect_review_evidence/1280x720/02_celerity_live.png"
	"../docs/testing/roguelite_live_effect_review_evidence/1280x720/03_fleetness_live.png"
	"scripts/combat/quick_strike_action.gd"
	"scripts/combat/quick_strike_data.gd"
	"scripts/combat/target_acquisition.gd"
	"scripts/actors/prototype_player.gd"
	"scripts/actors/prototype_graveblade.gd"
	"scenes/actors/prototype_player.tscn"
	"scripts/movement/prototype_locomotion.gd"
	"scripts/roguelite/live_effects/rift_build_application.gd"
	"scripts/roguelite/live_effects/rift_build_application_result.gd"
	"scripts/roguelite/live_effects/roguelite_live_effect_review.gd"
	"scripts/runs/rift_run_build.gd"
	"scripts/skills/acquired_supports.gd"
	"scripts/skills/skill_tag_profile.gd"
	"scripts/skills/skill_tags.gd"
	"scripts/skills/support_eligibility.gd"
	"scripts/skills/first_mvp_skill_library.gd"
	"scripts/skills/first_mvp_skill_data.gd"
	"scripts/stats/passive_card_catalogue.gd"
	"scripts/stats/passive_card_definition.gd"
	"scripts/stats/passive_card_selection.gd"
	"scripts/stats/passive_card_selection_result.gd"
	"scripts/offers/rift_offer.gd"
	"scripts/choices/rift_offer_choice.gd"
	"scripts/choices/rift_offer_choice_result.gd"
	"scripts/choices/rift_consumption_ledger.gd"
	"scripts/levels/rift_level_up_coordinator.gd"
	"scripts/levels/rift_level_up_result.gd"
	"scripts/levels/rift_run_level_coordinator.gd"
	"scripts/experience/rift_mote_runtime.gd"
	"scripts/roguelite/level_up/roguelite_level_up_choice_review.gd"
	"scripts/roguelite/roguelite_core_loop_runtime.gd"
	"scripts/roguelite/build_variety/roguelite_upgrade.gd"
	"tests/support_selection_smoke.sh"
	"tests/skill_tag_eligibility_verification.gd"
	"tests/skill_tag_eligibility_smoke.sh"
	"tests/rift_offer_composition_smoke.sh"
	"tests/rift_rank_two_spatial_support_verification.gd"
	"tests/rift_rank_two_spatial_support_smoke.sh"
	"tests/roguelite_live_effect_review_verification.gd"
	"tests/roguelite_live_effect_review_smoke.sh"
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

state_fingerprint() {
	if [[ -f "$1" ]]; then
		printf '%s bytes, sha256 %s, mtime %s' \
			"$(wc -c < "$1" | tr -d ' ')" \
			"$(shasum -a 256 "$1" | cut -d' ' -f1)" \
			"$(stat -f %m "$1")"
	else
		printf 'absent'
	fi
}

godot_tree_fingerprint() {
	(cd "$PROJECT_DIR/.godot" && find . -type f -print0 | sort -z | xargs -0 shasum -a 256 | shasum -a 256 | awk '{print $1}')
}

# `/tmp` is never cleared between runs, so a file from an earlier invocation must
# never answer for this one.
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

# The three-step read the project settled on.
read_check_count() {
	grep -ohE "$1: PASS \([0-9]+ checks\)" "$2" \
		| grep -ohE '[0-9]+ checks' | grep -ohE '[0-9]+' | head -1
}

# The owed line, read in two parts, so a replay can move either one.
read_owed() {
	grep -ohE "^  [0-9]+ of [0-9]+ owed checks completed" "$1" | grep -ohE '[0-9]+ of [0-9]+' | head -1
}

# Comment lines removed.
code_of() {
	sed -e 's/^[[:space:]]*#.*$//' "$1"
}

printf 'Riftwrought — Roguelite Foundation I5: Maximum-Rank Support Filtering and Honest Exhaustion smoke checks (D-300, corrected under D-301 and D-302)\n'
printf 'project: %s\n' "$PROJECT_DIR"

# --------------------------------------------------------------------------
step "0. Engine, and a fingerprint of everything I5 must not disturb"

installed="$("$GODOT" --version 2>/dev/null | tail -1)"
printf '  installed: %s\n' "$installed"
if [[ "$installed" == "$EXPECTED_VERSION"* ]]; then
	pass "matches the locked $EXPECTED_VERSION baseline"
else
	fail "expected $EXPECTED_VERSION, found $installed"
fi

canonical_records=()
while IFS= read -r record; do
	canonical_records+=("${record#"$PROJECT_DIR"/}")
done < <(find "$PROJECT_DIR/data" -type f -name '*.tres' | sort)
if [[ "${#canonical_records[@]}" == "$EXPECTED_CANONICAL_RECORDS" ]]; then
	pass "${#canonical_records[@]} canonical .tres records found under data/, all protected"
else
	fail "found ${#canonical_records[@]} canonical .tres records under data/, not $EXPECTED_CANONICAL_RECORDS"
fi
PRESERVED_FILES+=("${canonical_records[@]}")

declare -a BEFORE_HASHES
missing_preserved=0
for i in "${!PRESERVED_FILES[@]}"; do
	BEFORE_HASHES[$i]="$(fingerprint "$PROJECT_DIR/${PRESERVED_FILES[$i]}")"
	if [[ "${BEFORE_HASHES[$i]}" == "MISSING" ]]; then
		fail "protected file ${PRESERVED_FILES[$i]} does not exist"
		missing_preserved=$((missing_preserved + 1))
	fi
done
if [[ "$missing_preserved" == "0" ]]; then
	pass "${#PRESERVED_FILES[@]} protected file(s) fingerprinted"
fi

godot_before="$(godot_tree_fingerprint)"
run_marker="$(mktemp -t riftwrought_maximum_rank_marker)"
pass ".godot/ fingerprinted as one tree, and a start-of-run marker laid"

project_name="$(sed -n 's/^config\/name="\(.*\)"[[:space:]]*$/\1/p' "$PROJECT_DIR/project.godot" | head -1)"
production_dir="$HOME/Library/Application Support/Godot/app_userdata/$project_name"
settings_before="$(state_fingerprint "$production_dir/prototype_settings.cfg")"
lab_before="$(state_fingerprint "$production_dir/prototype_zero.cfg")"
character_before="$(state_fingerprint "$production_dir/riftwrought_character.cfg")"
pass "the project owner's own three user:// files fingerprinted"

# --------------------------------------------------------------------------
step "1. Every edited script, the new suite and the seven moved suites parse"

for relative in "${PARSED_SCRIPTS[@]}"; do
	if [[ ! -f "$PROJECT_DIR/$relative" ]]; then
		fail "$relative is missing"
		continue
	fi
	out="$("$GODOT" --headless --path "$PROJECT_DIR" --check-only --script "res://$relative" 2>&1 \
		| grep -v '^Godot Engine')"
	if [[ -z "$out" ]]; then
		pass "$relative parses"
	else
		fail "$relative does not parse"
		printf '%s\n' "$out" | head -10 | sed 's/^/        /'
	fi
done

# --------------------------------------------------------------------------
step "2. The edited files name nothing new, the catalogue computes no rank, and every new member stays where it is owned"

# The ASSET scan is RAW, comments included (D-215). The STORAGE scan is
# COMMENT-STRIPPED, so a file may say in prose that it writes nothing.
asset_fragments='res://assets/|\.gltf|\.glb|\.png|\.import|kaykit|kenney|k0rveen|quaternius|lelu|GPUParticles|CPUParticles|ShaderMaterial|\.gdshader|AudioStream|Texture2D'
storage_fragments='user://|ConfigFile|ResourceSaver|FileAccess|DirAccess|store_string|save_png|PrototypeSettings|PrototypeLabState|CharacterSave'
hits=0
for relative in "${EDITED_PRODUCTION[@]}"; do
	if grep -qE "$asset_fragments" "$PROJECT_DIR/$relative"; then
		fail "$relative names an asset, shader, particle or sound fragment"
		hits=$((hits + 1))
	fi
	if code_of "$PROJECT_DIR/$relative" | grep -qE "$storage_fragments"; then
		fail "$relative names a storage path, store or writer in CODE"
		hits=$((hits + 1))
	fi
done
if [[ "$hits" == "0" ]]; then
	pass "the ${#EDITED_PRODUCTION[@]} edited production files name no asset (raw) and no storage (code)"
fi

# The project classes each edited file names, read from the engine's own class cache.
project_classes="$(grep -oE '"class": &"[A-Za-z0-9_]+"' "$PROJECT_DIR/.godot/global_script_class_cache.cfg" \
	| grep -oE '&"[A-Za-z0-9_]+"' | tr -d '&"' | sort -u)"
names_in() {
	local file="$1" named=""
	for class_id in $project_classes; do
		grep -q "$class_id" "$file" && named="$named $class_id"
	done
	echo "${named# }"
}
wrong_names=0
for row in "$DEFINITION|$EXPECTED_DEFINITION_NAMES" "$SELECTION|$EXPECTED_SELECTION_NAMES" \
		"$SELECTION_RESULT|$EXPECTED_SELECTION_RESULT_NAMES" "$CONTINUATION|$EXPECTED_CONTINUATION_NAMES" "$RESULT|$EXPECTED_RESULT_NAMES" \
		"$CATALOGUE|$EXPECTED_CATALOGUE_NAMES" "$COMPOSER|$EXPECTED_COMPOSER_NAMES"; do
	file="${row%%|*}"
	expected="${row#*|}"
	named="$(names_in "$PROJECT_DIR/$file")"
	if [[ "$named" != "$expected" ]]; then
		fail "$file names '$named', not '$expected'"
		wrong_names=$((wrong_names + 1))
	fi
done
if [[ "$wrong_names" == "0" ]]; then
	pass "of $(echo "$project_classes" | wc -l | tr -d ' ') project classes each of the seven edited files names exactly its recorded set — no new class anywhere, and one new name in the definition, stated above"
fi

# The catalogue derives a maximum from its table; it must still compute with no rank.
if code_of "$PROJECT_DIR/$CATALOGUE" | grep -qE 'rank \*|\* rank|rank \+|\+ rank|rank -|rank /'; then
	fail "the catalogue computes with a rank"
else
	pass "the catalogue computes with no rank"
fi

# The continuation still reads no rank and names no maximum in CODE: that rule is the
# selector's, and asked of it.
if code_of "$PROJECT_DIR/$CONTINUATION" \
		| grep -qE 'rank_for\(|increase_rank\(|total_ranks\(|rank_support\(|support_rank_for\(|maximum_rank|max_rank|rank_cap'; then
	fail "the continuation reads a rank or names a maximum in code"
else
	pass "the continuation reads no rank and names no maximum in code — it asks the selector"
fi

# Every new member is named only by the files that own it, and every owner really names it.
stray=0
earned=0
owed_uses=0
for row in "${NEW_MEMBER_ROWS[@]}"; do
	token="${row%%|*}"
	IFS=',' read -r -a owners <<< "${row#*|}"
	owed_uses=$((owed_uses + ${#owners[@]}))
	while IFS= read -r hit; do
		[[ -z "$hit" ]] && continue
		base="$(basename "$hit")"
		owned=0
		for owner in "${owners[@]}"; do
			[[ "$base" == "$owner" ]] && owned=1
		done
		if [[ "$owned" == "1" ]]; then
			earned=$((earned + 1))
		else
			fail "$base names $token"
			stray=$((stray + 1))
		fi
	done < <(grep -rlF -- "$token" "$PROJECT_DIR/scripts" "$PROJECT_DIR/scenes" "$PROJECT_DIR/data" "$PROJECT_DIR/addons" 2>/dev/null)
done
if [[ "$stray" == "0" && "$earned" == "$owed_uses" ]]; then
	pass "the ${#NEW_MEMBER_ROWS[@]} new members are named only where owned — $earned of $owed_uses owned uses present, 0 stray"
elif [[ "$earned" != "$owed_uses" ]]; then
	fail "the owners use $earned of the $owed_uses grants they hold — a grant that cannot fail is not a boundary"
fi

for dir_row in "scripts/skills|$EXPECTED_SKILLS_SCRIPTS|13" "scripts/continuation|$EXPECTED_CONTINUATION_SCRIPTS|2" \
		"scripts/offers|$EXPECTED_OFFERS_SCRIPTS|2"; do
	dir="${dir_row%%|*}"
	rest="${dir_row#*|}"
	expected_scripts="${rest%%|*}"
	expected_uids="${rest#*|}"
	scripts="$(find "$PROJECT_DIR/$dir" -maxdepth 1 -type f -name '*.gd' -exec basename {} \; | sort | tr '\n' ' ' | sed 's/ $//')"
	uids="$(find "$PROJECT_DIR/$dir" -maxdepth 1 -type f -name '*.gd.uid' | wc -l | tr -d ' ')"
	other="$(find "$PROJECT_DIR/$dir" -mindepth 1 ! -name '*.gd' ! -name '*.gd.uid' | wc -l | tr -d ' ')"
	if [[ "$scripts" == "$expected_scripts" && "$uids" == "$expected_uids" && "$other" == "0" ]]; then
		pass "$dir/ holds exactly its $expected_uids scripts and their $expected_uids uid files — I5 added none"
	else
		fail "$dir/ holds '$scripts' ($uids uid, $other other)"
	fi
done

others="$(grep -oE 'res://tests/[A-Za-z0-9_./-]+' "$PROJECT_DIR/$THIS_VERIFICATION" | sort -u \
	| grep -vxF "res://$THIS_VERIFICATION" | tr '\n' ' ')"
if [[ -z "${others// /}" ]]; then
	pass "the verification names no file under tests/ but its own"
else
	fail "the verification names another test file: $others"
fi

# --------------------------------------------------------------------------
step "3. The pinned verification passes, proved in BOTH directions"

verify_log="/tmp/riftwrought_maximum_rank_support_filtering_verify.log"
perl -e 'alarm shift; exec @ARGV' "$VERIFICATION_TIMEOUT" "$GODOT" --headless --path "$PROJECT_DIR" \
	--script "$VERIFICATION" > "$verify_log" 2>&1
verify_status=$?
printf '  verification exit status: %s\n' "$verify_status"
assert_log_is_fresh "$verify_log"

script_errors="$(grep -cE "SCRIPT ERROR|String formatting error|Parse Error" "$verify_log" | tr -d ' ')"
engine_lines="$(grep -cE "^(ERROR|WARNING):" "$verify_log" | tr -d ' ')"
if [[ "$script_errors" == "0" ]]; then
	pass "the verification produced no SCRIPT ERROR"
else
	fail "the verification produced $script_errors script error line(s)"
	grep -A3 -E "SCRIPT ERROR|String formatting error|Parse Error" "$verify_log" | head -20 | sed 's/^/        /'
fi
if [[ "$engine_lines" == "0" ]]; then
	pass "the verification produced no engine ERROR and no engine WARNING line"
else
	fail "the verification produced $engine_lines engine ERROR or WARNING line(s)"
	grep -A2 -E "^(ERROR|WARNING):" "$verify_log" | head -20 | sed 's/^/        /'
fi

if [[ "$verify_status" == "0" ]]; then
	pass "the verification exited 0"
elif [[ "$verify_status" == "142" ]]; then
	fail "the verification did not finish within $VERIFICATION_TIMEOUT s and was killed"
else
	fail "the verification exited $verify_status"
	grep -E "^  FAIL" "$verify_log" | head -20 | sed 's/^/        /'
fi

count="$(read_check_count "$PASS_LINE" "$verify_log")"
if [[ "$count" == "$EXPECTED_CHECKS" ]]; then
	pass "verification passes at the pinned $EXPECTED_CHECKS checks"
else
	fail "verification reports ${count:-no} checks, not $EXPECTED_CHECKS"
fi

# A guard that accepts everything protects nothing: each pin must refuse a log whose
# number moved, and the negative direction must READ the moved number.
replay="$(mktemp -t riftwrought_maximum_rank_replay)"
scratch_replay="$replay"
sed "s/$PASS_LINE: PASS ($EXPECTED_CHECKS checks)/$PASS_LINE: PASS ($((EXPECTED_CHECKS + 1)) checks)/" \
	"$verify_log" > "$replay"
replay_count="$(read_check_count "$PASS_LINE" "$replay")"
if [[ -z "$count" ]]; then
	fail "the verification printed no count line, so the count pin proves nothing this run"
elif [[ "$replay_count" == "$((EXPECTED_CHECKS + 1))" && "$replay_count" != "$EXPECTED_CHECKS" ]]; then
	pass "and that pin reads a log whose count moved by one as $replay_count, refusing it"
else
	fail "the count pin read '${replay_count:-nothing}' from a moved log and therefore proves nothing"
fi

owed="$(read_owed "$verify_log")"
expected_owed="$EXPECTED_OWED_CHECKS of $EXPECTED_OWED_CHECKS"
if [[ "$owed" == "$expected_owed" ]]; then
	pass "all $EXPECTED_OWED_CHECKS owed checks reached their last line"
else
	fail "the owed-set report reads '${owed:-nothing}', not '$expected_owed'"
fi
refused=0
for moved in "$((EXPECTED_OWED_CHECKS - 1)) of $EXPECTED_OWED_CHECKS" "$EXPECTED_OWED_CHECKS of $((EXPECTED_OWED_CHECKS + 1))"; do
	sed "s/^  $expected_owed owed checks completed/  $moved owed checks completed/" "$verify_log" > "$replay"
	moved_read="$(read_owed "$replay")"
	if [[ "$moved_read" == "$moved" && "$moved_read" != "$expected_owed" ]]; then
		refused=$((refused + 1))
	fi
done
if [[ -z "$owed" ]]; then
	fail "the verification printed no owed line, so the owed pin proves nothing this run"
elif [[ "$refused" == "2" ]]; then
	pass "and that pin reads a log with one check short ('$((EXPECTED_OWED_CHECKS - 1)) of $EXPECTED_OWED_CHECKS') and one owed too many ('$EXPECTED_OWED_CHECKS of $((EXPECTED_OWED_CHECKS + 1))'), refusing both"
else
	fail "the owed pin refused $refused of 2 moved logs"
fi

# The measurements I5 exists to make, read out of the run's own log rather than
# restated here. `--` before the pattern is D-244's lesson kept. A line that follows a
# number which varies with the project's file count is pinned only up to it.
while IFS= read -r line; do
	if grep -qF -- "$line" "$verify_log"; then
		pass "measured: ${line}"
	else
		fail "the verification log does not report: ${line}"
	fi
done <<'MEASURED'
reaching_edge maximum rank 2 = the highest of its applied ranks [1, 2] = the rule over its records (2)
sweeping_edge maximum rank 2 = the highest of its applied ranks [1, 2] = the rule over its records (2)
the two definition bodies hold 0 numeric literal(s) and make 2 derivation call(s); the catalogue declares 0 maximum-rank constant(s)
the generic definition carries [eligibility, base_weight, tag_bonuses, maximum_rank] and declares [MAXIMUM_WEIGHT, MINIMUM_BASE_WEIGHT, MINIMUM_MAXIMUM_RANK, UNDECLARED_MAXIMUM_RANK]
reviewed ranks: reaching_edge [1, 2], sweeping_edge [1, 2]; records at ranks 0 and 3: 0
10 of 10 unsuitable record sets refused (no pair, no record, rank one absent, a rank at zero, a negative rank, a gap, an empty record, a non-integer rank, two disagreeing pairs, a missing pair-specific rank); 3 suitable sets published [1, 2, 3]; an unknown support: 'zz_not_a_support is not a support this catalogue holds'
4 of 4 malformed maxima (undeclared, 0, -1, -5) make problem() non-empty and are refused by the ordinary draw (alone, beside a valid support, and where not even a candidate), the rank draw, the continuation and composition: 0 accepted, 0 partial
the default object answers 'a support definition must carry an eligibility rule'; an undeclared shipped definition answers 'sweeping_edge declares no maximum rank, so a held pair of it cannot be raised'
14 of 14 frozen corpus rows reproduce exactly; over 512 fabricated ordinary selections a valid maximum of 1000 or 5 moved 0, and an undeclared one was refused 512 times
its all-held refusal still reads 'no equipped Skill has an available eligible support (2 pair(s) already acquired, 0 refused by eligibility)' and is classified an empty candidate set: true
256 shipped and 256 fabricated rank decisions equal the pre-I5 empty-record draw exactly; 256 of 256 composed offers over both pairs at rank 1 froze 1 -> 2
root seed 18: support lane seed 51507111, Support: quick_strike -> sweeping_edge; Combat and Defence: card_power; Utility: card_insight [another rank of a held pair, rank 1 -> 2]
768 answers over 3 states (new pair, mixed ranks, all at maximum): reversed arrays moved 0; kinds seen exhausted, new pair, rank increase
768 answers over 3 states: reversed, doubled tags moved 0
reaching_edge at rank 2: 256 of 256 rank draws, 256 of 256 decisions and 256 of 256 composed offers raise sweeping_edge 1 -> 2; 200 of 200 walked tickets are sweeping_edge's
sweeping_edge at rank 2: 256 of 256 rank draws, 256 of 256 decisions and 256 of 256 composed offers raise reaching_edge 1 -> 2; 200 of 200 walked tickets are reaching_edge's
below every maximum: zz_t1_alpha 4, zz_t2_beta 6, zz_t3_gamma 5 over 15 tickets; zz_t2_beta at its maximum: zz_t1_alpha 4, zz_t3_gamma 5 over 9 tickets (tickets 0-3 zz_t1_alpha, 4-8 zz_t3_gamma); its tickets: 0
600 first-stage tickets: zz_skill_three 300, zz_skill_two 300; zz_skill_one received 0, and every draw saw 2 eligible Skills
zz_skill_one at rank 2 beside zz_skill_two at rank 1: 256 of 256 decisions raise zz_skill_two -> zz_t1_alpha; with both at rank 2 the lane is exhausted: true
3 heavy rankable supports against 1 light: zz_skill_one 300, zz_skill_two 300; with one of the 3 at its maximum: zz_skill_one 300, zz_skill_two 300
256 of 256 seeds exhausted, in 1 form: 'the support lane is exhausted: every compatible support pair is already held at its maximum supported rank, so nothing new can be selected and nothing held can be raised'
the rank draw itself refuses: 'no equipped Skill has an eligible support held below its maximum rank (0 pair(s) not held, 2 at their maximum rank, 0 refused by eligibility)'
kind -1, ids ['', ''], derivation <null>, held false, fields [ok, failure_reason, kind, skill_id, support_id, selection, held_when_classified, exhausted] — 0 carry a rank
a success marked exhausted reports: 'a successful result must not declare the support lane exhausted'
6 refusals: 1 classified exhausted (exhaustion); the classification is set in 1 place, guarded by the selector's exhaustion proof; the continuation inspects refusal text 0 times
256 of 256 root seeds compose a PASSIVE_FALLBACK Support lane beside the two ordinary passive lanes; the I8 choice transaction takes that Support lane as one passive card on every one
no Skill, support, weighted derivation, progression kind or rank on the Support lane; both passive lanes are the independent draws on 256 of 256; the same seed composes the same offer 256 of 256; 3 lanes in the fixed order
9216 compositions over 9 shipped states x 1024 root seeds: 0 requested a rank above 2, 0 raised a pair already at rank 2; refusals {  }, passive fallbacks { "R2 S2": 1024 }, 0 refusals not exhaustion
32 chains through the accepted choice transaction: 32 x [new 0->1, new 0->1, rank 1->2, rank 1->2, fallback, fallback] — the fifth and sixth compositions carried a passive fallback, which the I8 choice transaction takes as one passive card while both ranks stay at 2
the seam c7b9df38… and its result 2fd01f80… are at their D-320 and D-321 hashes — D-298's published files with I13's Global Damage and I14's Maximum Life added; the catalogue answers 0 of 4 questions at ranks 3 and 4
STATED LIMITATION: the behavioural rank-three refusal is the accepted I4 suite's own proof, re-run unchanged beside this one;
running files scanned: the 9 new members appear only where they are owned — 19 of 19 owned uses present, 0 stray; the continuation is called only by [rift_offer_composition.gd]
project.godot: 31 actions, the Prototype App entrypoint, [autoload] present: false, 0 new member(s) named
the five generic files name 0 concrete token(s); the scan found 12 where they belong
rank records 2.65 / 3.65 m, 180 / 260 and 110 / 155 degrees; weights 100 / 100; tags [Attack, Hit, Melee, Physical, Strike]; 6 cards; salts, ceiling, lane domains and lane order as accepted; quick_strike.tres 0.80 s / 1.65 m / 100 / 65 / 1 target; 17 of 17 .tres records hash identically before and after
through the accepted choice transaction: [zz_t2_beta new 0->1, zz_t1_alpha new 0->1], then the third composition carried a passive fallback (card_insight), whose Support lane the I8 choice transaction takes as one passive card
immediately after acquiring zz_t2_beta at rank 1 of 1 it is finished: the rank draw reports an empty candidate set (true) and 0 of 10 walked tickets reach it
beside a maximum-two support held at rank 1: 256 of 256 rank decisions raise zz_t2_beta and 0 reach the finished zz_t1_alpha
4 states holding a pair above its maximum (R3 S0, R3 S1, R3 S2, R1 S3) x 256 seeds: 1024 new-pair draws, rank draws, continuations and compositions each refused as invalid state; 0 violations
the refusal names the corruption rather than clamping it: 'invalid acquisition state: quick_strike -> reaching_edge is held at rank 3, above the maximum rank of 2 its definition declares'
4 of 4 valid empty candidate sets classified 'no candidates' (every pair held; no compatible support; every pair at its maximum; nothing held to raise)
0 of 20 invalid inputs and unusable ladders classified
0 of 2 successes classified; a success forced to claim an empty set reports: 'a successful result must not report an empty candidate set'; the classification is built in 2 places, each after a completed walk, and never by the ladder
over 256 seeds the new-pair draw refused the over-ceiling pool 256 times and drew 0 pairs; stage one would have pointed at that Skill on 126 seeds and at the valid Skill on 130 — the seeds D-301 still answered with a new pair
all 256 continuations refuse — 0 new pairs, 0 rank increases, 0 exhausted, 0 partial — and reversing the arrays changed 0 answers
256 compositions over the same state: 256 refused whole at the Support lane, 0 offered a new pair, 0 offered a rank
the phase advances only on the selector's empty-candidate classification: its guard precedes the rank query, and the rank guard precedes the exhaustion proof
28 Skill/support ticket pairs (Skill tickets 0-3 over both candidate Skills) and 256 seeds in both array orders: every answer refuses as 'the total eligible weight for zz_skill_heavy would exceed the ceiling of 4294967295', with no partial selection
with a second malformed pool supplied last and then first, 512 of 512 refusals name zz_skill_brute, the first in stable Skill-ID order
each ladder is built once, by `_ladder_problem()`, which reads no ticket; both draws validate every ladder before `_draw()`, which computes no weight
every pair held at rank 1 of 3: the new-pair set is validly empty on 256 of 256 seeds, and the rank draw refuses all 256 in both array orders as 'the total eligible weight for zz_skill_heavy would exceed the ceiling of 4294967295' — including the 130 whose stage-one ticket points at the valid rankable Skill
256 continuations refuse — 0 rank increases, 0 new pairs, 0 exhausted, 0 partial; 256 compositions refuse whole at the Support lane, 0 offer a rank
the same fixture with every pair at its maximum: 256 of 256 seeds exhausted, no pool weighed — exhaustion and the overweight refusal stay distinct
a pool totalling exactly 4294967295 beside a valid Skill: 512 of 512 draws in both modes accepted (252 landed on it, each with that total); its 5 segments own their first and last tickets (10 boundaries); the light ladder, walked whole, owns { "zz_t_light_0": 10, "zz_t_light_1": 10 }
the same pool at 4294967296 (1 more): 256 seeds in both modes and 12 Skill/support ticket pairs, every one refused as 'the total eligible weight for zz_skill_bulk would exceed the ceiling of 4294967295' with no partial selection
5 non-candidate cases (overweight pairs held for a new pair, unheld or at their maximum for a rank, eligible for no Skill in either mode): 0 disturbed a selection over 256 seeds each
2 of 2 genuinely empty valid sets beside the overweight supports are still classified 'no candidates'
new pair, nothing held: reaching_edge tickets 0-99, sweeping_edge 100-199 of 200, over Skill tickets 0 and 1 — quick_strike the one candidate Skill
rank increase, both pairs at rank 1: reaching_edge tickets 0-99, sweeping_edge 100-199 of 200, over Skill tickets 0 and 1 — quick_strike the one candidate Skill
8064 refusals were driven across this suite
MEASURED

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
sections="$(grep -oE '^\[[a-z_]+\]$' "$project_godot" | tr -d '[]' | sort | tr '\n' ' ' | sed 's/ $//')"
if [[ "$sections" == "$EXPECTED_SECTIONS" ]]; then
	pass "the same nine sections, no new one"
else
	fail "project.godot's sections are '$sections'"
fi
if grep -q '^\[autoload\]' "$project_godot"; then
	fail "an [autoload] section was added"
else
	pass "there is still no [autoload]"
fi
if grep -qiE "maximum_rank|rank_exhaust|select_rank_increase|support_filtering" "$project_godot"; then
	fail "project.godot names I5 — it must own no project setting"
else
	pass "project.godot names nothing about I5"
fi

# --------------------------------------------------------------------------
step "5. The third-party inventory has not moved — I5 extracts nothing"

payloads="$(find "$PROJECT_DIR/assets/third_party" -type f \
	! -name '*.import' ! -name '.DS_Store' ! -name '*.md' 2>/dev/null | wc -l | tr -d ' ')"
maps=0
for note in "$PROJECT_DIR/assets/third_party/kenney/SOURCE_AND_LICENSE.md" \
		"$PROJECT_DIR/assets/third_party/quaternius/SOURCE_AND_LICENSE.md"; do
	[[ -f "$note" ]] && maps=$((maps + 1))
done
total=$((payloads + maps))
printf '  arithmetic: %d payload(s) + %d source map(s) = %d\n' "$payloads" "$maps" "$total"
if [[ "$payloads" == "$EXPECTED_THIRD_PARTY_PAYLOADS" && "$total" == "$EXPECTED_THIRD_PARTY" ]]; then
	pass "still $EXPECTED_THIRD_PARTY_PAYLOADS + $maps = $EXPECTED_THIRD_PARTY, unchanged"
else
	fail "the third-party inventory is $payloads + $maps = $total, not $EXPECTED_THIRD_PARTY_PAYLOADS + 2 = $EXPECTED_THIRD_PARTY"
fi

# --------------------------------------------------------------------------
step "6. The run wrote nothing"

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

# --------------------------------------------------------------------------
step "7. Every protected file is byte-identical, and the owner's files are untouched"

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
	printf 'MAXIMUM RANK SUPPORT FILTERING SMOKE CHECKS: PASS\n'
	printf '  %s checks; %s of %s owed; %s protected files byte-identical\n' \
		"$EXPECTED_CHECKS" "$EXPECTED_OWED_CHECKS" "$EXPECTED_OWED_CHECKS" "${#PRESERVED_FILES[@]}"
	printf '  Roguelite Foundation I5 — Maximum-Rank Support Filtering and Honest\n'
	printf '  Exhaustion — is DELIVERED under D-300, CORRECTED under D-301 and D-302,\n'
	printf '  and ACCEPTED and CLOSED at the maximum-rank support-filtering and\n'
	printf '  honest-exhaustion mechanism level under D-303.\n'
	reached_end=1
	exit 0
else
	printf 'MAXIMUM RANK SUPPORT FILTERING SMOKE CHECKS: %d FAILURE(S)\n' "$failures"
	reached_end=1
	exit 1
fi
