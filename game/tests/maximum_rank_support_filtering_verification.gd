extends SceneTree
## Riftwrought — Roguelite Foundation I5: Maximum-Rank Support Filtering and Honest
## Exhaustion — automated verification (decision D-300).
##
## ONE FOCUSED HEADLESS TEST. I5 gives the generic support definition a maximum rank,
## derives the two shipped maxima from `SkillSupportCatalogue`'s exact applied-rank
## records, teaches the accepted weighted selector a RANK-INCREASE draw that excludes
## pairs at their maximum, and lets the accepted continuation report EXHAUSTION as an
## explicit classification. It adds no scene, panel, HUD, evidence frame or playable
## review, and this suite builds none: it runs as a `SceneTree` script, exactly as the
## foundation suites do.
##
## CORRECTED UNDER D-301, AND FOUR CHECKS WERE ADDED FOR IT. A usable maximum is now
## part of every definition's validity, a pair held above its maximum is invalid state
## that both draws refuse, the selector classifies a VALID EMPTY candidate set, and
## the continuation advances from its new-pair phase only on that classification.
## Checks 4 and 5 moved to the stricter validity rule; checks 23–26 prove the
## maximum-rank-one lifecycle, the above-maximum refusal, the classification itself,
## and the reported overflow edge case.
##
## CORRECTED AGAIN UNDER D-302, WITH FOUR MORE CHECKS. Foundation B's selector now
## builds and validates the ladder of EVERY candidate Skill before stage one draws,
## so an over-ceiling pool refuses the whole selection on every seed instead of only
## on the seeds that happened to draw it. Check 26 moved to "every seed refuses";
## checks 27-30 prove the pre-draw validation in the new-pair draw, its rank-mode
## equivalent, the exact ceiling and its non-candidate boundary, and the shipped
## 100 / 100 ladder.
##
## EVERY DISTRIBUTION CLAIM IS WALKED, NEVER SAMPLED. Ticket ownership is proved by
## walking every ticket of a ladder through the accepted `_with_tickets` entry points,
## and a seed sweep is used only for claims that are statements about every seed —
## "no seed composes rank three" — never as evidence of a weight.
##
## WHAT IS STAGED, STATED WHERE IT HAPPENS. Every acquisition state is composed by this
## harness through the accepted ranked-ownership record's own `acquire()` and
## `increase_rank()`, or through the accepted run build's operations; no playable route
## reaches rank two, because one playable level-up exists and repeated ones are not
## authorized. The fabricated Skills and supports below are `zz_` test data, registered
## in no catalogue, shipped in no scene or `.tres`, and not canon.
##
## EVERY EXPECTED VALUE IS A TYPED LITERAL — from the brief, from D-299's accepted
## table, or from an accepted suite's own published corpus — and EVERY PRINTED LINE
## CARRIES WHAT WAS MEASURED, because the runner reads those lines back as evidence. IT
## PORTS D-211's OWED-SET DISCIPLINE: every check records reaching its LAST line, and
## the suite compares that set to what it owes in both directions.
##
## Run: godot --headless --path game --script res://tests/maximum_rank_support_filtering_verification.gd

const DEFINITION_FILE: String = "res://scripts/skills/support_definition.gd"
const SELECTION_FILE: String = "res://scripts/skills/support_selection.gd"
const SELECTION_RESULT_FILE: String = "res://scripts/skills/support_selection_result.gd"
const CONTINUATION_FILE: String = "res://scripts/continuation/support_continuation.gd"
const RESULT_FILE: String = "res://scripts/continuation/support_continuation_result.gd"
const CATALOGUE_FILE: String = "res://scripts/skills/skill_support_catalogue.gd"
const COMPOSER_FILE: String = "res://scripts/offers/rift_offer_composition.gd"
const SEAM_FILE: String = "res://scripts/roguelite/live_effects/rift_build_application.gd"
const SEAM_RESULT_FILE: String = "res://scripts/roguelite/live_effects/rift_build_application_result.gd"
const PROJECT_SETTINGS_FILE: String = "res://project.godot"
const CANONICAL_QUICK_STRIKE: String = "res://data/prototype_zero/quick_strike.tres"
const CANONICAL_DATA_ROOT: String = "res://data"
const ENTRYPOINT: String = "res://scenes/app/prototype_app.tscn"
const EXPECTED_ACTIONS: int = 31
const SCANNED_ROOTS: Array[String] = ["res://scripts", "res://scenes", "res://data", "res://addons"]

## The shipped ids, typed independently of the catalogue.
const QUICK_STRIKE: StringName = &"quick_strike"
const REACHING: StringName = &"reaching_edge"
const SWEEPING: StringName = &"sweeping_edge"

## D-299's accepted table: two exact ranks per support, so a maximum of two.
const SHIPPED_MAXIMUM_RANK: int = 2
const SHIPPED_RANKS: Array[int] = [1, 2]
const SHIPPED_WEIGHT: int = 100
const REACH_BY_RANK: Dictionary = {1: 2.65, 2: 3.65}
const ARC_BY_RANK: Dictionary = {1: 180.0, 2: 260.0}
const CONE_BY_RANK: Dictionary = {1: 110.0, 2: 155.0}

## The diagnostics this suite pins, typed from the delivered mechanism.
const EXHAUSTION_REASON: String = "the support lane is exhausted: every compatible support pair is already held at its maximum supported rank, so nothing new can be selected and nothing held can be raised"
const RANK_POOL_EMPTY_REASON: String = "no equipped Skill has an eligible support held below its maximum rank (0 pair(s) not held, 2 at their maximum rank, 0 refused by eligibility)"
const NEW_PAIR_POOL_EMPTY_REASON: String = "no equipped Skill has an available eligible support (2 pair(s) already acquired, 0 refused by eligibility)"
const SUPPORT_LANE_PREFIX: String = "the Support lane refused: "

## Foundation B's frozen shipped corpus (D-228, pinned across D-236), retyped: seed,
## Skill, support, reduced ticket, ladder total. The ordinary draw must still answer it.
const B_SHIPPED_CORPUS: Array = [
	[0, "quick_strike", "reaching_edge", 42, 200],
	[1, "quick_strike", "reaching_edge", 55, 200],
	[3, "quick_strike", "reaching_edge", 96, 200],
	[7, "quick_strike", "sweeping_edge", 187, 200],
	[42, "quick_strike", "reaching_edge", 26, 200],
	[257, "quick_strike", "reaching_edge", 62, 200],
	[999, "quick_strike", "sweeping_edge", 104, 200],
	[12345, "quick_strike", "sweeping_edge", 194, 200],
	[99991, "quick_strike", "sweeping_edge", 170, 200],
	[2147483647, "quick_strike", "reaching_edge", 81, 200],
	[-1, "quick_strike", "reaching_edge", 3, 200],
	[-12345, "quick_strike", "reaching_edge", 53, 200],
	[1000000007, "quick_strike", "sweeping_edge", 106, 200],
	[9223372036854775807, "quick_strike", "reaching_edge", 3, 200],
]

## Foundation F3's documented rank worked example (D-255), retyped: root seed 18 with
## both shipped pairs at rank 1.
const F3_ROOT_SEED: int = 18
const F3_SUPPORT_LANE_SEED: int = 51507111
const F3_COMBAT_CARD: StringName = &"card_power"
const F3_UTILITY_CARD: StringName = &"card_insight"

## The frozen values the brief forbids moving, typed from their accepted decisions.
const SKILL_STREAM_SALT: int = 0x9E3779B9
const SUPPORT_STREAM_SALT: int = 0x85EBCA6B
const MAXIMUM_TOTAL_WEIGHT: int = 0xFFFFFFFF
const SUPPORT_LANE_DOMAIN: int = 0x6A09E667
const COMBAT_DEFENCE_LANE_DOMAIN: int = 0xBB67AE85
const UTILITY_LANE_DOMAIN: int = 0x3C6EF372

## The I3 seam and its result, byte-identical since D-298 published them.
## Roguelite I13 (D-318) made Global Damage live through the seam and its result, so both
## prefixes moved one for one from D-298's `1aa00c5f` and `b6b6d1ee` to the D-318 files. The
## rank table the seam reads, and its rank-three refusal, did not move. Same count.
## Roguelite I14 (D-320) made Maximum Life live through the same two files, so both prefixes
## moved one for one again, from the D-318 `63c7fe71` and `b46ed70c` to the D-320 files.
const SEAM_SHA256_PREFIX: String = "c7b9df38"
## Roguelite I14's correction (D-321) moved the result's prefix once more, from `73d445f7`, for its
## describe() diagnostic.
const SEAM_RESULT_SHA256_PREFIX: String = "2fd01f80"

## Test-only identities.
const SKILL_ONE: StringName = &"zz_skill_one"
const SKILL_TWO: StringName = &"zz_skill_two"
const SKILL_THREE: StringName = &"zz_skill_three"
const SUPPORT_ALPHA: StringName = &"zz_t1_alpha"
const SUPPORT_BETA: StringName = &"zz_t2_beta"
const SUPPORT_GAMMA: StringName = &"zz_t3_gamma"
const WEIGHT_ALPHA: int = 4
const WEIGHT_BETA: int = 6
const WEIGHT_GAMMA: int = 5
const FIXTURE_MAXIMUM_RANK: int = 3

const SEED_SAMPLES: int = 256
const SWEEP_TICKETS: int = 600
const SWEEP_ROOT_SEEDS: int = 1024
const CHAINS: int = 32
const SEED_SEARCH_LIMIT: int = 4096

## Every running file allowed to name each new member, and nothing else may.
##
## Roguelite Foundation I6 (D-304) grants `is_exhausted(` to its exhausted-support
## passive fallback, which may activate only on that classification. The same
## single assertion is made; the owned uses it requires move 16 -> 17, and the
## pinned count does not move.
const NEW_MEMBER_OWNERS: Array = [
	["select_rank_increase", ["support_selection.gd", "support_continuation.gd"]],
	["is_rank_exhausted", ["support_selection.gd", "support_continuation.gd"]],
	## Roguelite Foundation I7 (D-306) widens the same row to both offer files: the composer activates
	## the fallback only on that classification, and the offer re-asks it of a fallback lane's
	## continuation. Owned uses 17 -> 19; the same single assertion.
	["is_exhausted(", ["support_continuation_result.gd", "support_exhaustion_passive_fallback.gd", "rift_offer_composition.gd", "rift_offer.gd"]],
	["exhaustion(", ["support_continuation.gd", "support_continuation_result.gd"]],
	["maximum_rank_from(", ["skill_support_catalogue.gd"]],
	["support_maximum_rank", ["skill_support_catalogue.gd"]],
	["maximum_rank", ["skill_support_catalogue.gd", "support_definition.gd", "support_selection.gd"]],
	["has_no_candidates(", ["support_continuation.gd", "support_selection_result.gd"]],
	["no_candidates_found(", ["support_selection.gd", "support_selection_result.gd"]],
]

## What none of the generic mechanism's five files may name, raw, comments included.
const CONCRETE_TOKENS: Array[String] = [
	"quick_strike", "Quick Strike", "QuickStrike", "reaching_edge", "Reaching Edge",
	"sweeping_edge", "Sweeping Edge", "SkillSupportCatalogue", "RiftBuildApplication",
	"live-application", "release_arc", "soft_target", "maximum_targets", "FirstMvpSkill",
]

const OWED_CHECKS: Array[String] = [
	"shipped_maximum_ranks_are_derived_from_the_applied_rank_records",
	"the_shipped_rank_sets_are_contiguous_one_and_two",
	"the_derivation_fails_closed_on_unsuitable_records",
	"a_malformed_maximum_rank_refuses_whole",
	"ordinary_new_pair_selection_and_its_frozen_corpus_are_unchanged",
	"rank_one_to_two_transitions_are_unchanged",
	"reversed_profile_or_definition_order_changes_nothing",
	"duplicated_tags_change_nothing",
	"reaching_at_its_maximum_leaves_only_sweeping",
	"sweeping_at_its_maximum_leaves_only_reaching",
	"a_pair_at_its_maximum_owns_zero_tickets",
	"a_skill_with_only_maximum_rank_pairs_is_absent_from_stage_one",
	"a_maximum_rank_pair_on_one_skill_does_not_block_another",
	"skill_first_balance_holds_over_rankable_candidates",
	"both_shipped_pairs_at_rank_two_report_exhaustion",
	"the_exhausted_result_carries_no_decision",
	"invalid_input_and_exhaustion_are_distinguishable_without_text",
	"exhausted_composition_carries_the_passive_fallback_whole",
	"no_composed_offer_requests_rank_three",
	"the_i4_rank_three_refusal_is_unchanged",
	"nothing_running_calls_the_new_mechanism_except_through_accepted_composition",
	"the_generic_mechanism_names_nothing_concrete_and_nothing_accepted_moved",
	"a_maximum_rank_one_support_is_acquired_once_and_then_finished",
	"above_maximum_ownership_is_invalid_state",
	"only_a_valid_empty_candidate_set_is_classified_no_candidates",
	"a_refused_new_pair_ladder_never_advances_to_the_rank_phase",
	"every_candidate_pool_is_validated_before_either_stage_draws",
	"an_overweight_rankable_pool_cannot_be_avoided_by_the_rank_draw",
	"the_ceiling_is_exact_and_only_real_candidates_are_weighed",
	"the_shipped_ladders_are_unchanged",
]

## The continuation's refusal when no new pair exists and the rank query itself refuses.
const RANK_QUERY_REFUSES_PREFIX: String = "the support lane cannot continue: no new pair is available, and the rank query refuses: "

var _failures: PackedStringArray = PackedStringArray()
var _checks: int = 0
var _reached: Dictionary = {}
var _refusals: int = 0
var _hashes_before: Dictionary = {}


func _initialize() -> void:
	print("")
	print("=== Roguelite Foundation I5 — Maximum-Rank Support Filtering and Honest Exhaustion (D-300, corrected under D-301 and D-302) ===")
	_hashes_before = _canonical_hashes()

	_check_shipped_maximum_ranks_are_derived_from_the_applied_rank_records()
	_check_the_shipped_rank_sets_are_contiguous_one_and_two()
	_check_the_derivation_fails_closed_on_unsuitable_records()
	_check_a_malformed_maximum_rank_refuses_whole()
	_check_ordinary_new_pair_selection_and_its_frozen_corpus_are_unchanged()
	_check_rank_one_to_two_transitions_are_unchanged()
	_check_reversed_profile_or_definition_order_changes_nothing()
	_check_duplicated_tags_change_nothing()
	_check_reaching_at_its_maximum_leaves_only_sweeping()
	_check_sweeping_at_its_maximum_leaves_only_reaching()
	_check_a_pair_at_its_maximum_owns_zero_tickets()
	_check_a_skill_with_only_maximum_rank_pairs_is_absent_from_stage_one()
	_check_a_maximum_rank_pair_on_one_skill_does_not_block_another()
	_check_skill_first_balance_holds_over_rankable_candidates()
	_check_both_shipped_pairs_at_rank_two_report_exhaustion()
	_check_the_exhausted_result_carries_no_decision()
	_check_invalid_input_and_exhaustion_are_distinguishable_without_text()
	_check_exhausted_composition_carries_the_passive_fallback_whole()
	_check_no_composed_offer_requests_rank_three()
	_check_the_i4_rank_three_refusal_is_unchanged()
	_check_nothing_running_calls_the_new_mechanism_except_through_accepted_composition()
	_check_the_generic_mechanism_names_nothing_concrete_and_nothing_accepted_moved()
	_check_a_maximum_rank_one_support_is_acquired_once_and_then_finished()
	_check_above_maximum_ownership_is_invalid_state()
	_check_only_a_valid_empty_candidate_set_is_classified_no_candidates()
	_check_a_refused_new_pair_ladder_never_advances_to_the_rank_phase()
	_check_every_candidate_pool_is_validated_before_either_stage_draws()
	_check_an_overweight_rankable_pool_cannot_be_avoided_by_the_rank_draw()
	_check_the_ceiling_is_exact_and_only_real_candidates_are_weighed()
	_check_the_shipped_ladders_are_unchanged()

	_check_every_check_ran()

	print("")
	print("  %d refusals were driven across this suite" % _refusals)
	if _failures.is_empty():
		print("MAXIMUM RANK SUPPORT FILTERING VERIFICATION: PASS (%d checks)" % _checks)
		quit(0)
	else:
		for failure: String in _failures:
			printerr("  FAIL: %s" % failure)
		printerr("MAXIMUM RANK SUPPORT FILTERING VERIFICATION: %d FAILURE(S) of %d checks" % [
			_failures.size(), _checks,
		])
		quit(1)


# --- 1. The shipped maxima are derived, not typed -------------------------------------------------------------------

func _check_shipped_maximum_ranks_are_derived_from_the_applied_rank_records() -> void:
	print("")
	print("--- 1. Both shipped definitions publish maximum rank 2, derived from their exact rank records")
	var definitions: Array[SupportDefinition] = SkillSupportCatalogue.support_definitions()
	_expect(definitions.size() == 2, "the catalogue holds %d definitions, not 2" % definitions.size())
	var lines: PackedStringArray = PackedStringArray()
	var wrong: PackedStringArray = PackedStringArray()
	for definition: SupportDefinition in definitions:
		var id: StringName = definition.support_id()
		var ranks: Array[int] = SkillSupportCatalogue.reviewed_support_ranks(QUICK_STRIKE, id)
		## The rule, applied here to the table as its PUBLIC accessors answer it — a second
		## route to the same records, so the catalogue's own derivation is checked against
		## the records rather than against itself.
		var table: Dictionary = {}
		for rank: int in ranks:
			table[rank] = SkillSupportCatalogue.support_rank_values(QUICK_STRIKE, id, rank)
		var ruled: Dictionary = SkillSupportCatalogue.maximum_rank_from({"%s on %s" % [id, QUICK_STRIKE]: table})
		if definition.maximum_rank != SHIPPED_MAXIMUM_RANK \
				or not definition.maximum_rank_problem().is_empty() \
				or ranks.is_empty() or definition.maximum_rank != int(ranks.back()) \
				or definition.maximum_rank != SkillSupportCatalogue.support_maximum_rank(id) \
				or not SkillSupportCatalogue.support_maximum_rank_problem(id).is_empty() \
				or int(ruled["maximum"]) != definition.maximum_rank or not String(ruled["problem"]).is_empty():
			wrong.append("%s: maximum %d, problem '%s', ranks %s, ruled %s" % [
				id, definition.maximum_rank, definition.maximum_rank_problem(), str(ranks), str(ruled)])
		lines.append("%s maximum rank %d = the highest of its applied ranks %s = the rule over its records (%d)" % [
			id, definition.maximum_rank, str(ranks), int(ruled["maximum"])])
	_expect(wrong.is_empty(), "a shipped maximum is not the one its records support: %s" % ", ".join(wrong))

	## NO DUPLICATE CAP. The definitions are built from a CALL, never from a typed number:
	## both bodies call the derivation and hold no numeric literal; the catalogue declares
	## no maximum-rank constant; and the derivation reads the table itself.
	var catalogue: String = _code_only(FileAccess.get_file_as_string(CATALOGUE_FILE))
	var literal_count: int = 0
	var calls: int = 0
	for name: String in ["reaching_edge_definition", "sweeping_edge_definition"]:
		var body: String = _function_body(catalogue, name)
		literal_count += _numeric_literals(body).size()
		calls += body.count("support_maximum_rank(")
	var cap_constants: PackedStringArray = PackedStringArray()
	for key: Variant in (load(CATALOGUE_FILE) as GDScript).get_script_constant_map():
		if String(key).contains("MAXIMUM") or String(key).contains("MAX_RANK"):
			cap_constants.append(String(key))
	var derivation: String = _function_body(catalogue, "_maximum_rank_derivation")
	_expect(literal_count == 0 and calls == 2 and cap_constants.is_empty()
			and derivation.contains("_rank_records(") and derivation.contains("maximum_rank_from("),
		"the definitions hold %d numeric literal(s) and %d derivation call(s); cap constants %s"
			% [literal_count, calls, ", ".join(cap_constants)])

	## AND THE GENERIC RECORD HOLDS A NUMBER, NOT A TABLE: its fields and constants, pinned.
	var fields: PackedStringArray = _script_fields(SupportDefinition.new())
	var constants: PackedStringArray = PackedStringArray()
	for key: Variant in (load(DEFINITION_FILE) as GDScript).get_script_constant_map():
		constants.append(String(key))
	constants.sort()
	_expect(", ".join(fields) == "eligibility, base_weight, tag_bonuses, maximum_rank"
			and ", ".join(constants) == "MAXIMUM_WEIGHT, MINIMUM_BASE_WEIGHT, MINIMUM_MAXIMUM_RANK, UNDECLARED_MAXIMUM_RANK"
			and SupportDefinition.UNDECLARED_MAXIMUM_RANK == 0 and SupportDefinition.MINIMUM_MAXIMUM_RANK == AcquiredSupports.FIRST_RANK,
		"the generic definition carries fields [%s] and constants [%s]" % [", ".join(fields), ", ".join(constants)])

	for line: String in lines:
		print("  %s" % line)
	print("  the two definition bodies hold %d numeric literal(s) and make %d derivation call(s); the catalogue declares %d maximum-rank constant(s)"
		% [literal_count, calls, cap_constants.size()])
	print("  the generic definition carries [%s] and declares [%s]" % [", ".join(fields), ", ".join(constants)])
	_done("shipped_maximum_ranks_are_derived_from_the_applied_rank_records")


# --- 2. Contiguous [1, 2] ---------------------------------------------------------------------------------------------

func _check_the_shipped_rank_sets_are_contiguous_one_and_two() -> void:
	print("")
	print("--- 2. The exact rank sets are contiguous [1, 2], and nothing answers at rank 0 or 3")
	var answered: PackedStringArray = PackedStringArray()
	var sets: PackedStringArray = PackedStringArray()
	for id: StringName in [REACHING, SWEEPING]:
		var ranks: Array[int] = SkillSupportCatalogue.reviewed_support_ranks(QUICK_STRIKE, id)
		sets.append("%s %s" % [id, str(ranks)])
		_expect(ranks == SHIPPED_RANKS, "%s holds the ranks %s, not [1, 2]" % [id, str(ranks)])
		for rank: int in [1, 2]:
			if SkillSupportCatalogue.support_rank_values(QUICK_STRIKE, id, rank).is_empty():
				answered.append("%s has no record at rank %d" % [id, rank])
		for rank: int in [0, 3]:
			if not SkillSupportCatalogue.support_rank_values(QUICK_STRIKE, id, rank).is_empty():
				answered.append("%s answers at rank %d" % [id, rank])
	_expect(answered.is_empty(), "the rank table is not exactly [1, 2]: %s" % ", ".join(answered))
	print("  reviewed ranks: %s; records at ranks 0 and 3: %d" % [", ".join(sets), answered.size()])
	_done("the_shipped_rank_sets_are_contiguous_one_and_two")


# --- 3. The derivation fails closed ------------------------------------------------------------------------------------

func _check_the_derivation_fails_closed_on_unsuitable_records() -> void:
	print("")
	print("--- 3. The derivation refuses every unsuitable record set, and never takes the largest rank seen")
	var record: Dictionary = {&"reach": 1.0}
	var unsuitable: Array = [
		["no applicable pair", {}, "no applicable Skill"],
		["a pair with no record", {"p": {}}, "no applied-rank record at all"],
		["rank one absent", {"p": {2: record}}, "do not begin at rank one"],
		["a rank at zero", {"p": {0: record, 1: record}}, "do not begin at rank one"],
		["a negative rank", {"p": {-1: record, 1: record, 2: record}}, "do not begin at rank one"],
		["a gap", {"p": {1: record, 3: record}}, "skip a rank"],
		["an empty record", {"p": {1: record, 2: {}}}, "an empty applied-rank record"],
		["a rank that is not an integer", {"p": {"one": record}}, "which is not a rank"],
		["two pairs that disagree", {"a": {1: record, 2: record}, "b": {1: record, 2: record, 3: record}}, "no one maximum is honest"],
		["a missing pair-specific rank beside a complete pair", {"a": {1: record, 2: record}, "b": {1: record}}, "no one maximum is honest"],
	]
	var accepted: PackedStringArray = PackedStringArray()
	for row: Array in unsuitable:
		var answer: Dictionary = SkillSupportCatalogue.maximum_rank_from(row[1] as Dictionary)
		if int(answer["maximum"]) != SupportDefinition.UNDECLARED_MAXIMUM_RANK \
				or not String(answer["problem"]).contains(String(row[2])):
			accepted.append("%s answered %s" % [row[0], str(answer)])
		else:
			_refusals += 1
	_expect(accepted.is_empty(), "unsuitable records published a maximum: %s" % "; ".join(accepted))

	var suitable: Array = [
		[{"p": {1: record}}, 1],
		[{"a": {1: record, 2: record}, "b": {2: record, 1: record}}, 2],
		[{"p": {1: record, 2: record, 3: record}}, 3],
	]
	var published: PackedStringArray = PackedStringArray()
	var wrong: int = 0
	for row: Array in suitable:
		var answer: Dictionary = SkillSupportCatalogue.maximum_rank_from(row[0] as Dictionary)
		published.append(str(int(answer["maximum"])))
		if int(answer["maximum"]) != int(row[1]) or not String(answer["problem"]).is_empty():
			wrong += 1
	_expect(wrong == 0, "%d suitable record set(s) did not publish their maximum: %s" % [wrong, ", ".join(published)])

	## An id the catalogue does not hold is refused too, and a definition carrying a refused
	## maximum is one the rank query will refuse.
	var unknown: String = SkillSupportCatalogue.support_maximum_rank_problem(&"zz_not_a_support")
	var undeclared: SupportDefinition = SupportDefinition.of(
		SkillSupportCatalogue.reaching_edge(), SHIPPED_WEIGHT, {},
		SkillSupportCatalogue.support_maximum_rank(&"zz_not_a_support"))
	_expect(not unknown.is_empty() and SkillSupportCatalogue.support_maximum_rank(&"zz_not_a_support")
			== SupportDefinition.UNDECLARED_MAXIMUM_RANK and not undeclared.maximum_rank_problem().is_empty(),
		"an unknown support answered '%s' / %d" % [unknown, undeclared.maximum_rank])
	_refusals += 1
	print("  %d of %d unsuitable record sets refused (no pair, no record, rank one absent, a rank at zero, a negative rank, a gap, an empty record, a non-integer rank, two disagreeing pairs, a missing pair-specific rank); %d suitable sets published [%s]; an unknown support: '%s'"
		% [unsuitable.size() - accepted.size(), unsuitable.size(), suitable.size(), ", ".join(published), unknown])
	_done("the_derivation_fails_closed_on_unsuitable_records")


# --- 4. A malformed maximum refuses whole ------------------------------------------------------------------------------

func _check_a_malformed_maximum_rank_refuses_whole() -> void:
	print("")
	print("--- 4. An undeclared, zero or negative maximum makes a definition invalid: no selection, no acquisition, no offer")
	var profiles: Array[SkillTagProfile] = _one_melee_skill()
	var cards: Array[PassiveCardDefinition] = PassiveCardCatalogue.records()
	var malformed: Array = [
		["undeclared", SupportDefinition.of(
			SupportEligibility.of(SUPPORT_BETA, "Test Support", [SkillTags.MELEE] as Array[StringName],
				[] as Array[StringName], [] as Array[StringName]), WEIGHT_BETA, {})],
		["zero", _definition(SUPPORT_BETA, [SkillTags.MELEE] as Array[StringName], WEIGHT_BETA, 0)],
		["minus one", _definition(SUPPORT_BETA, [SkillTags.MELEE] as Array[StringName], WEIGHT_BETA, -1)],
		["minus five", _definition(SUPPORT_BETA, [SkillTags.MELEE] as Array[StringName], WEIGHT_BETA, -5)],
	]
	## D-301: A USABLE MAXIMUM IS PART OF VALIDITY. Each malformed record must now be
	## refused by the ORDINARY draw too — alone, beside a valid support, and where it is
	## not even a candidate — and so it can be neither acquired through the continuation
	## nor composed into an offer. The first delivery let the ordinary draw select over
	## it, which is the defect this check now pins the other way round.
	var accepted: PackedStringArray = PackedStringArray()
	var partial: PackedStringArray = PackedStringArray()
	for row: Array in malformed:
		var broken: SupportDefinition = row[1]
		var own: String = broken.maximum_rank_problem()
		var definitions: Array[SupportDefinition] = []
		definitions.append(_definition(SUPPORT_ALPHA, [SkillTags.MELEE] as Array[StringName], WEIGHT_ALPHA, FIXTURE_MAXIMUM_RANK))
		definitions.append(broken)
		var alone: Array[SupportDefinition] = []
		alone.append(broken)
		var elsewhere: Array[SupportDefinition] = []
		elsewhere.append(definitions[0])
		elsewhere.append(_definition(SUPPORT_BETA, [SkillTags.FIRE] as Array[StringName], WEIGHT_BETA, broken.maximum_rank))
		var ordinary: SupportSelectionResult = SupportSelection.select(profiles, definitions, AcquiredSupports.new(), 7)
		var ordinary_alone: SupportSelectionResult = SupportSelection.select(profiles, alone, AcquiredSupports.new(), 7)
		var not_a_candidate: SupportSelectionResult = SupportSelection.select(profiles, elsewhere, AcquiredSupports.new(), 7)
		var ranked: SupportSelectionResult = SupportSelection.select_rank_increase(profiles, definitions,
			_fabricated([[SKILL_ONE, SUPPORT_ALPHA, 1], [SKILL_ONE, SUPPORT_BETA, 1]]), 7)
		var continued: SupportContinuationResult = SupportContinuation.select(profiles, definitions, AcquiredSupports.new(), 7)
		var offer: RiftOffer = RiftOfferComposition.compose(profiles, definitions, AcquiredSupports.new(), cards, 7)
		if own.is_empty() or not broken.problem().contains(own) \
				or ordinary.ok or ordinary.has_no_candidates() or not ordinary.failure_reason.contains(own) \
				or ordinary_alone.ok or not_a_candidate.ok or ranked.ok or ranked.has_no_candidates() \
				or continued.ok or continued.is_exhausted() or not continued.failure_reason.contains(own) \
				or offer.ok or offer.refusing_lane != RiftOffer.Lane.SUPPORT or not offer.failure_reason.contains(own):
			accepted.append("%s: '%s' / %s / %s / %s" % [row[0], own, ordinary.describe(), continued.describe(), offer.failure_reason])
		if not ordinary.problem().is_empty() or not String(ordinary.skill_id).is_empty() \
				or ordinary.total_eligible_weight != 0 or not continued.problem().is_empty() \
				or continued.kind != SupportContinuationResult.UNRESOLVED_KIND \
				or continued.selection != null or not continued.pair().is_empty() \
				or not offer.problem().is_empty() or not offer.identity_for(RiftOffer.Lane.SUPPORT).is_empty():
			partial.append(String(row[0]))
		_refusals += 6
	_expect(accepted.is_empty(), "a malformed maximum was selected, acquired, composed or misclassified: %s" % "; ".join(accepted))
	_expect(partial.is_empty(), "a refusal carried a partial selection: %s" % ", ".join(partial))
	## THE DEFAULT OBJECT IS CONSTRUCTIBLE AND INVALID, and so is a shipped record rebuilt
	## without a maximum.
	var default_definition: SupportDefinition = SupportDefinition.new()
	var shipped_undeclared: SupportDefinition = SupportDefinition.of(
		SkillSupportCatalogue.sweeping_edge(), SHIPPED_WEIGHT, {})
	_expect(not default_definition.problem().is_empty()
			and default_definition.maximum_rank == SupportDefinition.UNDECLARED_MAXIMUM_RANK
			and shipped_undeclared.maximum_rank == SupportDefinition.UNDECLARED_MAXIMUM_RANK
			and shipped_undeclared.problem() == "sweeping_edge declares no maximum rank, so a held pair of it cannot be raised",
		"the default object answers '%s'; an undeclared shipped definition '%s'" % [
			default_definition.problem(), shipped_undeclared.problem()])
	print("  %d of %d malformed maxima (undeclared, 0, -1, -5) make problem() non-empty and are refused by the ordinary draw (alone, beside a valid support, and where not even a candidate), the rank draw, the continuation and composition: %d accepted, %d partial"
		% [malformed.size() - accepted.size(), malformed.size(), accepted.size(), partial.size()])
	print("  the default object answers '%s'; an undeclared shipped definition answers '%s'"
		% [default_definition.problem(), shipped_undeclared.problem()])
	_done("a_malformed_maximum_rank_refuses_whole")


# --- 5. The ordinary draw is unchanged ---------------------------------------------------------------------------------

func _check_ordinary_new_pair_selection_and_its_frozen_corpus_are_unchanged() -> void:
	print("")
	print("--- 5. The ordinary new-pair draw and Foundation B's frozen corpus are unchanged")
	var profiles: Array[SkillTagProfile] = SkillSupportCatalogue.skill_profiles()
	var definitions: Array[SupportDefinition] = SkillSupportCatalogue.support_definitions()
	var corpus_wrong: PackedStringArray = PackedStringArray()
	for row: Array in B_SHIPPED_CORPUS:
		var result: SupportSelectionResult = SupportSelection.select(profiles, definitions, AcquiredSupports.new(), int(row[0]))
		if not result.ok or String(result.skill_id) != String(row[1]) or String(result.support_id) != String(row[2]) \
				or result.rolled_ticket != int(row[3]) or result.total_eligible_weight != int(row[4]):
			corpus_wrong.append("seed %d: %s" % [int(row[0]), result.describe()])
	_expect(corpus_wrong.is_empty(), "the frozen corpus moved: %s" % "; ".join(corpus_wrong))

	## A VALID MAXIMUM IS NEVER WEIGHED BY THE ORDINARY DRAW: the same records declaring
	## 1000 or 5 — both above every rank held here — answer identically in a new-pair
	## state, while the same records declaring none are refused every time (D-301).
	var fabricated_profiles: Array[SkillTagProfile] = _two_melee_skills()
	var drift: int = 0
	var compared: int = 0
	var undeclared_refused: int = 0
	for state: AcquiredSupports in [AcquiredSupports.new(), _fabricated([[SKILL_ONE, SUPPORT_ALPHA, 1], [SKILL_TWO, SUPPORT_GAMMA, 2]])]:
		for seed_value: int in SEED_SAMPLES:
			var baseline: String = _signature(SupportSelection.select(fabricated_profiles, _three_melee_supports(1000), state, seed_value))
			compared += 1
			if _signature(SupportSelection.select(fabricated_profiles, _three_melee_supports(5), state, seed_value)) != baseline:
				drift += 1
			var undeclared: SupportSelectionResult = SupportSelection.select(fabricated_profiles,
				_three_melee_supports(SupportDefinition.UNDECLARED_MAXIMUM_RANK), state, seed_value)
			if not undeclared.ok and not undeclared.has_no_candidates():
				undeclared_refused += 1
	_expect(drift == 0 and compared == SEED_SAMPLES * 2 and undeclared_refused == compared,
		"a valid maximum moved %d of %d ordinary selections; an undeclared one was refused %d times" % [drift, compared, undeclared_refused])
	var refused: SupportSelectionResult = SupportSelection.select(profiles, definitions, _shipped(1, 1), 7)
	_expect(not refused.ok and refused.failure_reason == NEW_PAIR_POOL_EMPTY_REASON and refused.has_no_candidates(),
		"the ordinary draw's all-held refusal reads '%s' (empty candidate set: %s)" % [refused.failure_reason, refused.has_no_candidates()])
	_refusals += 1
	## Structurally: the ordinary draw reads a rank only through its acquisition-state
	## validation (D-301); its candidate walk reads none and weighs no maximum.
	var code: String = _code_only(FileAccess.get_file_as_string(SELECTION_FILE))
	var core: String = _function_body(code, "select_with_tickets")
	_expect(core.length() > 300 and core.contains("_acquisition_problem(") and core.contains("no_candidates_found(")
			and not core.contains("maximum_rank") and not core.contains("rank_for(") and not core.contains("_rank_standing(")
			and _function_body(code, "_acquisition_problem").contains("rank_for("),
		"the ordinary core reads a rank outside its acquisition validation, or does not validate")
	print("  %d of %d frozen corpus rows reproduce exactly; over %d fabricated ordinary selections a valid maximum of 1000 or 5 moved %d, and an undeclared one was refused %d times"
		% [B_SHIPPED_CORPUS.size() - corpus_wrong.size(), B_SHIPPED_CORPUS.size(), compared, drift, undeclared_refused])
	print("  its all-held refusal still reads '%s' and is classified an empty candidate set: %s"
		% [refused.failure_reason, refused.has_no_candidates()])
	_done("ordinary_new_pair_selection_and_its_frozen_corpus_are_unchanged")


# --- 6. Rank 1 -> 2 is unchanged ---------------------------------------------------------------------------------------

func _check_rank_one_to_two_transitions_are_unchanged() -> void:
	print("")
	print("--- 6. Every rank 1 -> 2 decision is exactly the one made before a maximum existed")
	var profiles: Array[SkillTagProfile] = SkillSupportCatalogue.skill_profiles()
	var definitions: Array[SupportDefinition] = SkillSupportCatalogue.support_definitions()
	var cards: Array[PassiveCardDefinition] = PassiveCardCatalogue.records()
	var both_one: AcquiredSupports = _shipped(1, 1)
	## Before I5 the rank phase WAS the ordinary draw against an empty record. Below every
	## maximum the rank-increase draw sees the same pool with the same tickets, so every
	## rank decision must equal that old answer, derivation and all.
	var shipped_drift: int = 0
	for seed_value: int in SEED_SAMPLES:
		var result: SupportContinuationResult = SupportContinuation.select(profiles, definitions, both_one, seed_value)
		var before_i5: SupportSelectionResult = SupportSelection.select(profiles, definitions, AcquiredSupports.new(), seed_value)
		if not result.is_rank_increase() or _signature(result.selection) != _signature(before_i5):
			shipped_drift += 1
	var fabricated_profiles: Array[SkillTagProfile] = _two_melee_skills()
	var fabricated: Array[SupportDefinition] = _three_melee_supports(FIXTURE_MAXIMUM_RANK)
	var all_one: AcquiredSupports = _every_eligible(fabricated_profiles, fabricated, 1)
	var fabricated_drift: int = 0
	for seed_value: int in SEED_SAMPLES:
		var result: SupportContinuationResult = SupportContinuation.select(fabricated_profiles, fabricated, all_one, seed_value)
		var before_i5: SupportSelectionResult = SupportSelection.select(fabricated_profiles, fabricated, AcquiredSupports.new(), seed_value)
		if not result.is_rank_increase() or _signature(result.selection) != _signature(before_i5):
			fabricated_drift += 1
	_expect(shipped_drift == 0 and fabricated_drift == 0,
		"%d shipped and %d fabricated rank decisions differ from the pre-I5 answer" % [shipped_drift, fabricated_drift])
	var composed: int = 0
	for root_seed: int in SEED_SAMPLES:
		var offer: RiftOffer = RiftOfferComposition.compose(profiles, definitions, both_one, cards, root_seed)
		if offer.ok and offer.problem().is_empty() \
				and offer.support_progression_kind == SupportContinuationResult.Kind.RANK_INCREASE \
				and offer.support_rank_before == 1 and offer.support_rank_after == 2:
			composed += 1
	_expect(composed == SEED_SAMPLES, "%d of %d offers over both pairs at rank 1 froze 1 -> 2" % [composed, SEED_SAMPLES])
	var example: RiftOffer = RiftOfferComposition.compose(profiles, definitions, both_one, cards, F3_ROOT_SEED)
	_expect(example.ok and example.seed_for(RiftOffer.Lane.SUPPORT) == F3_SUPPORT_LANE_SEED
			and example.skill_id == QUICK_STRIKE and example.support_id == SWEEPING
			and example.combat_card_id == F3_COMBAT_CARD and example.utility_card_id == F3_UTILITY_CARD
			and example.support_rank_before == 1 and example.support_rank_after == 2,
		"F3's worked example reads %s" % example.describe())
	print("  %d shipped and %d fabricated rank decisions equal the pre-I5 empty-record draw exactly; %d of %d composed offers over both pairs at rank 1 froze 1 -> 2"
		% [SEED_SAMPLES - shipped_drift, SEED_SAMPLES - fabricated_drift, composed, SEED_SAMPLES])
	print("  root seed %d: support lane seed %d, %s [%s]" % [
		F3_ROOT_SEED, example.seed_for(RiftOffer.Lane.SUPPORT), example.offer_line(), example.support_progression_line()])
	_done("rank_one_to_two_transitions_are_unchanged")


# --- 7 and 8. Order and duplicated tags --------------------------------------------------------------------------------

func _check_reversed_profile_or_definition_order_changes_nothing() -> void:
	print("")
	print("--- 7. Reversing the Skill and support arrays moves no rank decision, no exhaustion and no refusal")
	var profiles: Array[SkillTagProfile] = _mixed_skills()
	var definitions: Array[SupportDefinition] = _mixed_supports()
	var reversed_profiles: Array[SkillTagProfile] = []
	for index: int in range(profiles.size() - 1, -1, -1):
		reversed_profiles.append(profiles[index])
	var reversed_definitions: Array[SupportDefinition] = []
	for index: int in range(definitions.size() - 1, -1, -1):
		reversed_definitions.append(definitions[index])
	_expect(reversed_profiles[0].skill_id != profiles[0].skill_id
			and reversed_definitions[0].support_id() != definitions[0].support_id(),
		"the reversed arrays are not actually different")
	var moved: int = 0
	var compared: int = 0
	var kinds: Dictionary = {}
	for state: AcquiredSupports in _order_states(profiles, definitions):
		for seed_value: int in SEED_SAMPLES:
			var baseline: String = _full(SupportContinuation.select(profiles, definitions, state, seed_value)) \
				+ _signature(SupportSelection.select_rank_increase(profiles, definitions, state, seed_value)) \
				+ str(SupportSelection.is_rank_exhausted(profiles, definitions, state))
			var other: String = _full(SupportContinuation.select(reversed_profiles, reversed_definitions, state, seed_value)) \
				+ _signature(SupportSelection.select_rank_increase(reversed_profiles, reversed_definitions, state, seed_value)) \
				+ str(SupportSelection.is_rank_exhausted(reversed_profiles, reversed_definitions, state))
			compared += 1
			kinds[_kind_of(SupportContinuation.select(profiles, definitions, state, seed_value))] = true
			if other != baseline:
				moved += 1
	_expect(moved == 0 and kinds.size() == 3, "reversal moved %d of %d answers; kinds seen %s" % [moved, compared, str(kinds.keys())])
	print("  %d answers over 3 states (new pair, mixed ranks, all at maximum): reversed arrays moved %d; kinds seen %s"
		% [compared, moved, ", ".join(_sorted_keys(kinds))])
	_done("reversed_profile_or_definition_order_changes_nothing")


func _check_duplicated_tags_change_nothing() -> void:
	print("")
	print("--- 8. Reversing and duplicating every tag moves nothing")
	var profiles: Array[SkillTagProfile] = _mixed_skills()
	var definitions: Array[SupportDefinition] = _mixed_supports()
	var retagged: Array[SkillTagProfile] = []
	for profile: SkillTagProfile in profiles:
		var scrambled: Array[StringName] = []
		for index: int in range(profile.tags.size() - 1, -1, -1):
			scrambled.append(profile.tags[index])
			scrambled.append(profile.tags[index])
		retagged.append(SkillTagProfile.of(profile.skill_id, profile.display_name, scrambled))
	_expect(retagged[0].tags.size() == profiles[0].tags.size() * 2, "the retagged profile is not doubled")
	var moved: int = 0
	var compared: int = 0
	for state: AcquiredSupports in _order_states(profiles, definitions):
		for seed_value: int in SEED_SAMPLES:
			compared += 1
			if _full(SupportContinuation.select(retagged, definitions, state, seed_value)) \
					!= _full(SupportContinuation.select(profiles, definitions, state, seed_value)) \
					or SupportSelection.is_rank_exhausted(retagged, definitions, state) \
					!= SupportSelection.is_rank_exhausted(profiles, definitions, state):
				moved += 1
	_expect(moved == 0, "duplicated tags moved %d of %d answers" % [moved, compared])
	print("  %d answers over 3 states: reversed, doubled tags moved %d" % [compared, moved])
	_done("duplicated_tags_change_nothing")


# --- 9 and 10. One shipped pair at its maximum -------------------------------------------------------------------------

func _check_reaching_at_its_maximum_leaves_only_sweeping() -> void:
	_one_shipped_pair_at_its_maximum(2, 1, SWEEPING, "reaching_at_its_maximum_leaves_only_sweeping")


func _check_sweeping_at_its_maximum_leaves_only_reaching() -> void:
	_one_shipped_pair_at_its_maximum(1, 2, REACHING, "sweeping_at_its_maximum_leaves_only_reaching")


func _one_shipped_pair_at_its_maximum(reaching: int, sweeping: int, remaining: StringName, check_name: String) -> void:
	var at_maximum: StringName = REACHING if reaching == SHIPPED_MAXIMUM_RANK else SWEEPING
	print("")
	print("--- %d. %s at rank 2: every rank decision selects %s" % [
		9 if remaining == SWEEPING else 10, at_maximum, remaining])
	var profiles: Array[SkillTagProfile] = SkillSupportCatalogue.skill_profiles()
	var definitions: Array[SupportDefinition] = SkillSupportCatalogue.support_definitions()
	var cards: Array[PassiveCardDefinition] = PassiveCardCatalogue.records()
	var held: AcquiredSupports = _shipped(reaching, sweeping)
	var selected: int = 0
	var decided: int = 0
	var composed: int = 0
	for seed_value: int in SEED_SAMPLES:
		var direct: SupportSelectionResult = SupportSelection.select_rank_increase(profiles, definitions, held, seed_value)
		if direct.ok and direct.support_id == remaining and direct.total_eligible_weight == SHIPPED_WEIGHT \
				and direct.eligible_skill_count == 1:
			selected += 1
		var result: SupportContinuationResult = SupportContinuation.select(profiles, definitions, held, seed_value)
		if result.is_rank_increase() and result.support_id == remaining and result.problem().is_empty():
			decided += 1
		var offer: RiftOffer = RiftOfferComposition.compose(profiles, definitions, held, cards, seed_value)
		if offer.ok and offer.support_id == remaining and offer.support_rank_before == 1 and offer.support_rank_after == 2:
			composed += 1
	var owners: Dictionary = {}
	for ticket: int in SHIPPED_WEIGHT * 2:
		var walked: SupportSelectionResult = SupportSelection.select_rank_increase_with_tickets(profiles, definitions, held, 0, ticket)
		owners[walked.support_id] = int(owners.get(walked.support_id, 0)) + 1
	_expect(selected == SEED_SAMPLES and decided == SEED_SAMPLES and composed == SEED_SAMPLES,
		"%s raised %d / %d / %d of %d times" % [remaining, selected, decided, composed, SEED_SAMPLES])
	_expect(owners.size() == 1 and int(owners.get(remaining, 0)) == SHIPPED_WEIGHT * 2
			and not SupportSelection.is_rank_exhausted(profiles, definitions, held),
		"the rank ladder is owned %s" % str(owners))
	print("  %s at rank %d: %d of %d rank draws, %d of %d decisions and %d of %d composed offers raise %s 1 -> 2; %d of %d walked tickets are %s's"
		% [at_maximum, SHIPPED_MAXIMUM_RANK, selected, SEED_SAMPLES, decided, SEED_SAMPLES, composed, SEED_SAMPLES,
			remaining, int(owners.get(remaining, 0)), SHIPPED_WEIGHT * 2, remaining])
	_done(check_name)


# --- 11. Zero tickets ------------------------------------------------------------------------------------------------

func _check_a_pair_at_its_maximum_owns_zero_tickets() -> void:
	print("")
	print("--- 11. A pair at its maximum owns no ticket; the ladder is walked ticket by ticket")
	var profiles: Array[SkillTagProfile] = _one_melee_skill()
	var definitions: Array[SupportDefinition] = _three_melee_supports(FIXTURE_MAXIMUM_RANK)
	var below: AcquiredSupports = _fabricated([[SKILL_ONE, SUPPORT_ALPHA, 1], [SKILL_ONE, SUPPORT_BETA, 2], [SKILL_ONE, SUPPORT_GAMMA, 2]])
	var at: AcquiredSupports = _fabricated([[SKILL_ONE, SUPPORT_ALPHA, 1], [SKILL_ONE, SUPPORT_BETA, FIXTURE_MAXIMUM_RANK], [SKILL_ONE, SUPPORT_GAMMA, 2]])
	var below_owner: Array[StringName] = _walk(profiles, definitions, below, WEIGHT_ALPHA + WEIGHT_BETA + WEIGHT_GAMMA)
	var at_owner: Array[StringName] = _walk(profiles, definitions, at, WEIGHT_ALPHA + WEIGHT_GAMMA)
	var below_counts: Dictionary = _count(below_owner)
	var at_counts: Dictionary = _count(at_owner)
	_expect(int(below_counts.get(SUPPORT_ALPHA, 0)) == WEIGHT_ALPHA and int(below_counts.get(SUPPORT_BETA, 0)) == WEIGHT_BETA
			and int(below_counts.get(SUPPORT_GAMMA, 0)) == WEIGHT_GAMMA,
		"below every maximum the ladder is owned %s" % str(below_counts))
	_expect(not at_counts.has(SUPPORT_BETA) and int(at_counts.get(SUPPORT_ALPHA, 0)) == WEIGHT_ALPHA
			and int(at_counts.get(SUPPORT_GAMMA, 0)) == WEIGHT_GAMMA
			and at_owner[0] == SUPPORT_ALPHA and at_owner[3] == SUPPORT_ALPHA
			and at_owner[4] == SUPPORT_GAMMA and at_owner[8] == SUPPORT_GAMMA,
		"with the middle support at its maximum the ladder is owned %s" % str(at_counts))
	var total: SupportSelectionResult = SupportSelection.select_rank_increase_with_tickets(profiles, definitions, at, 0, 0)
	_expect(total.ok and total.total_eligible_weight == WEIGHT_ALPHA + WEIGHT_GAMMA,
		"the ladder total is %d" % total.total_eligible_weight)
	print("  below every maximum: %s over %d tickets; %s at its maximum: %s over %d tickets (tickets 0-3 %s, 4-8 %s); its tickets: %d"
		% [_count_line(below_counts), below_owner.size(), SUPPORT_BETA, _count_line(at_counts), at_owner.size(),
			at_owner[0], at_owner[8], int(at_counts.get(SUPPORT_BETA, 0))])
	_done("a_pair_at_its_maximum_owns_zero_tickets")


# --- 12. Absent from stage one ---------------------------------------------------------------------------------------

func _check_a_skill_with_only_maximum_rank_pairs_is_absent_from_stage_one() -> void:
	print("")
	print("--- 12. A Skill whose every held pair is at its maximum is absent from the first stage")
	var profiles: Array[SkillTagProfile] = _three_mixed_skills()
	var definitions: Array[SupportDefinition] = _melee_and_fire_supports(2)
	var held: AcquiredSupports = _fabricated([
		[SKILL_ONE, SUPPORT_ALPHA, 2], [SKILL_ONE, SUPPORT_BETA, 2],
		[SKILL_TWO, SUPPORT_ALPHA, 1], [SKILL_TWO, SUPPORT_BETA, 2],
		[SKILL_THREE, SUPPORT_GAMMA, 1],
	])
	var counts: Dictionary = {}
	var wrong_count: int = 0
	for ticket: int in SWEEP_TICKETS:
		var result: SupportSelectionResult = SupportSelection.select_rank_increase_with_tickets(profiles, definitions, held, ticket, 0)
		counts[result.skill_id] = int(counts.get(result.skill_id, 0)) + 1
		if result.eligible_skill_count != 2:
			wrong_count += 1
	_expect(not counts.has(SKILL_ONE) and int(counts.get(SKILL_TWO, 0)) == SWEEP_TICKETS / 2
			and int(counts.get(SKILL_THREE, 0)) == SWEEP_TICKETS / 2 and wrong_count == 0,
		"the first stage over %d tickets: %s (%d with a count other than 2)" % [SWEEP_TICKETS, str(counts), wrong_count])
	print("  %d first-stage tickets: %s; %s received %d, and every draw saw 2 eligible Skills"
		% [SWEEP_TICKETS, _count_line(counts), SKILL_ONE, int(counts.get(SKILL_ONE, 0))])
	_done("a_skill_with_only_maximum_rank_pairs_is_absent_from_stage_one")


# --- 13. One Skill's maximum does not block another's pair ------------------------------------------------------------

func _check_a_maximum_rank_pair_on_one_skill_does_not_block_another() -> void:
	print("")
	print("--- 13. The same support at its maximum on one Skill does not block it on another")
	var profiles: Array[SkillTagProfile] = _two_melee_skills()
	var definitions: Array[SupportDefinition] = []
	definitions.append(_definition(SUPPORT_ALPHA, [SkillTags.MELEE] as Array[StringName], WEIGHT_ALPHA, 2))
	var held: AcquiredSupports = _fabricated([[SKILL_ONE, SUPPORT_ALPHA, 2], [SKILL_TWO, SUPPORT_ALPHA, 1]])
	var raised_two: int = 0
	for seed_value: int in SEED_SAMPLES:
		var result: SupportContinuationResult = SupportContinuation.select(profiles, definitions, held, seed_value)
		if result.is_rank_increase() and result.skill_id == SKILL_TWO and result.support_id == SUPPORT_ALPHA:
			raised_two += 1
	_expect(raised_two == SEED_SAMPLES and not SupportSelection.is_rank_exhausted(profiles, definitions, held),
		"%s -> %s was raised %d of %d times" % [SKILL_TWO, SUPPORT_ALPHA, raised_two, SEED_SAMPLES])
	## And once the second Skill's pair reaches its maximum too, the lane is exhausted.
	var both: AcquiredSupports = _fabricated([[SKILL_ONE, SUPPORT_ALPHA, 2], [SKILL_TWO, SUPPORT_ALPHA, 2]])
	var exhausted: SupportContinuationResult = SupportContinuation.select(profiles, definitions, both, 7)
	_expect(exhausted.is_exhausted() and SupportSelection.is_rank_exhausted(profiles, definitions, both),
		"both at their maximum answered %s" % exhausted.describe())
	_refusals += 1
	print("  %s at rank 2 beside %s at rank 1: %d of %d decisions raise %s -> %s; with both at rank 2 the lane is exhausted: %s"
		% [SKILL_ONE, SKILL_TWO, raised_two, SEED_SAMPLES, SKILL_TWO, SUPPORT_ALPHA, exhausted.is_exhausted()])
	_done("a_maximum_rank_pair_on_one_skill_does_not_block_another")


# --- 14. Skill-first balance --------------------------------------------------------------------------------------------

func _check_skill_first_balance_holds_over_rankable_candidates() -> void:
	print("")
	print("--- 14. The first stage stays uniform over Skills with something to raise; catalogue depth is not balance")
	var profiles: Array[SkillTagProfile] = []
	profiles.append(_profile(SKILL_ONE, [SkillTags.ATTACK, SkillTags.HIT, SkillTags.MELEE] as Array[StringName]))
	profiles.append(_profile(SKILL_TWO, [SkillTags.SPELL, SkillTags.HIT, SkillTags.FIRE] as Array[StringName]))
	var definitions: Array[SupportDefinition] = []
	for id: StringName in [&"zz_t1_deep_a", &"zz_t2_deep_b", &"zz_t3_deep_c"]:
		definitions.append(_definition(id, [SkillTags.MELEE] as Array[StringName], 1000, 5))
	definitions.append(_definition(&"zz_t4_shallow", [SkillTags.FIRE] as Array[StringName], 1, 5))
	var all_rankable: AcquiredSupports = _every_eligible(profiles, definitions, 1)
	var one_finished: AcquiredSupports = _every_eligible(profiles, definitions, 1)
	for _step: int in 4:
		one_finished.increase_rank(SKILL_ONE, &"zz_t1_deep_a")
	var results: PackedStringArray = PackedStringArray()
	var uneven: int = 0
	for state: AcquiredSupports in [all_rankable, one_finished]:
		var counts: Dictionary = {}
		for ticket: int in SWEEP_TICKETS:
			var result: SupportSelectionResult = SupportSelection.select_rank_increase_with_tickets(profiles, definitions, state, ticket, 0)
			counts[result.skill_id] = int(counts.get(result.skill_id, 0)) + 1
		results.append(_count_line(counts))
		if int(counts.get(SKILL_ONE, 0)) != SWEEP_TICKETS / 2 or int(counts.get(SKILL_TWO, 0)) != SWEEP_TICKETS / 2:
			uneven += 1
	_expect(uneven == 0, "the first stage is not 50 / 50: %s" % "; ".join(results))
	print("  3 heavy rankable supports against 1 light: %s; with one of the 3 at its maximum: %s" % [results[0], results[1]])
	_done("skill_first_balance_holds_over_rankable_candidates")


# --- 15. Both shipped pairs at rank 2 -----------------------------------------------------------------------------------

func _check_both_shipped_pairs_at_rank_two_report_exhaustion() -> void:
	print("")
	print("--- 15. With both shipped pairs at rank 2, the continuation reports explicit exhaustion on every seed")
	var profiles: Array[SkillTagProfile] = SkillSupportCatalogue.skill_profiles()
	var definitions: Array[SupportDefinition] = SkillSupportCatalogue.support_definitions()
	var held: AcquiredSupports = _shipped(2, 2)
	var exhausted: int = 0
	var identical: Dictionary = {}
	for seed_value: int in SEED_SAMPLES:
		var result: SupportContinuationResult = SupportContinuation.select(profiles, definitions, held, seed_value)
		if result.is_exhausted() and not result.ok and not result.is_new_pair() and not result.is_rank_increase() \
				and result.problem().is_empty() and result.failure_reason == EXHAUSTION_REASON:
			exhausted += 1
		identical[_full(result)] = true
		_refusals += 1
	var direct: SupportSelectionResult = SupportSelection.select_rank_increase(profiles, definitions, held, 7)
	_expect(exhausted == SEED_SAMPLES and identical.size() == 1,
		"%d of %d seeds reported exhaustion, in %d distinct forms" % [exhausted, SEED_SAMPLES, identical.size()])
	_expect(SupportSelection.is_rank_exhausted(profiles, definitions, held) and not direct.ok
			and direct.failure_reason == RANK_POOL_EMPTY_REASON and direct.problem().is_empty(),
		"the rank draw answered '%s'" % direct.failure_reason)
	print("  %d of %d seeds exhausted, in %d form: '%s'" % [exhausted, SEED_SAMPLES, identical.size(), EXHAUSTION_REASON])
	print("  the rank draw itself refuses: '%s'" % direct.failure_reason)
	_done("both_shipped_pairs_at_rank_two_report_exhaustion")


# --- 16. The exhausted result -------------------------------------------------------------------------------------------

func _check_the_exhausted_result_carries_no_decision() -> void:
	print("")
	print("--- 16. An exhausted result carries no Skill, no support, no derivation, no rank and no choice")
	var result: SupportContinuationResult = SupportContinuation.select(
		SkillSupportCatalogue.skill_profiles(), SkillSupportCatalogue.support_definitions(), _shipped(2, 2), F3_ROOT_SEED)
	_expect(result.is_exhausted() and result.kind == SupportContinuationResult.UNRESOLVED_KIND
			and String(result.skill_id).is_empty() and String(result.support_id).is_empty()
			and result.selection == null and not result.held_when_classified and result.pair().is_empty()
			and result.problem().is_empty() and result.describe().begins_with("support lane exhausted — "),
		"the exhausted result reads %s" % result.describe())
	var rank_fields: PackedStringArray = PackedStringArray()
	var fields: PackedStringArray = _script_fields(result)
	for field: String in fields:
		if field.contains("rank"):
			rank_fields.append(field)
	_expect(rank_fields.is_empty() and fields.has("exhausted"),
		"the result record carries [%s]" % ", ".join(fields))
	## And the record refuses every incoherent use of the classification.
	var blank: SupportContinuationResult = SupportContinuationResult.exhaustion("  ")
	var plain: SupportContinuationResult = SupportContinuationResult.failed("a stated reason")
	var good: SupportSelectionResult = SupportSelection.select(_one_melee_skill(), _three_melee_supports(FIXTURE_MAXIMUM_RANK), AcquiredSupports.new(), 5)
	var lying: SupportContinuationResult = SupportContinuationResult.new_pair(good, false)
	lying.exhausted = true
	var forced: SupportContinuationResult = SupportContinuationResult.exhaustion("a stated reason")
	forced.ok = true
	_expect(blank.is_exhausted() and not blank.failure_reason.strip_edges().is_empty() and blank.problem().is_empty()
			and not plain.is_exhausted() and not lying.problem().is_empty() and not lying.is_exhausted()
			and not forced.is_exhausted() and not forced.problem().is_empty(),
		"the classification's coherence rules: blank %s, plain %s, lying '%s', forced '%s'"
			% [blank.describe(), plain.describe(), lying.problem(), forced.problem()])
	print("  kind %d, ids ['%s', '%s'], derivation %s, held %s, fields [%s] — %d carry a rank"
		% [result.kind, result.skill_id, result.support_id, result.selection, result.held_when_classified,
			", ".join(fields), rank_fields.size()])
	print("  a success marked exhausted reports: '%s'" % lying.problem())
	_done("the_exhausted_result_carries_no_decision")


# --- 17. Invalid input and exhaustion are told apart without text ------------------------------------------------------

func _check_invalid_input_and_exhaustion_are_distinguishable_without_text() -> void:
	print("")
	print("--- 17. Six refusals; exactly one is exhaustion, told apart by the stored classification alone")
	var profiles: Array[SkillTagProfile] = SkillSupportCatalogue.skill_profiles()
	var definitions: Array[SupportDefinition] = SkillSupportCatalogue.support_definitions()
	var incompatible: Array[SupportDefinition] = []
	incompatible.append(_definition(SUPPORT_ALPHA, [SkillTags.VOID] as Array[StringName], WEIGHT_ALPHA, 2))
	var undeclared: Array[SupportDefinition] = []
	for definition: SupportDefinition in definitions:
		undeclared.append(SupportDefinition.of(definition.eligibility, definition.base_weight, definition.tag_bonuses))
	var no_definitions: Array[SupportDefinition] = []
	var cases: Array = [
		["no compatible support", SupportContinuation.select(profiles, incompatible, _shipped(1, 1), 7), false],
		["no support definitions", SupportContinuation.select(profiles, no_definitions, null, 7), false],
		["undeclared maximum ranks", SupportContinuation.select(profiles, undeclared, _shipped(1, 1), 7), false],
		["a pair held above its maximum", SupportContinuation.select(profiles, definitions, _shipped(3, 1), 7), false],
		["a new-pair ladder over the ceiling", _overflow_case(), false],
		["exhaustion", SupportContinuation.select(profiles, definitions, _shipped(2, 2), 7), true],
	]
	var wrong: PackedStringArray = PackedStringArray()
	var exhausted_names: PackedStringArray = PackedStringArray()
	for row: Array in cases:
		var result: SupportContinuationResult = row[1]
		_refusals += 1
		if result == null or result.ok or result.is_exhausted() != bool(row[2]) or not result.problem().is_empty() \
				or result.kind != SupportContinuationResult.UNRESOLVED_KIND or result.selection != null:
			wrong.append("%s: %s" % [row[0], result.describe() if result != null else "<null>"])
		if result != null and result.is_exhausted():
			exhausted_names.append(String(row[0]))
	_expect(wrong.is_empty() and exhausted_names == PackedStringArray(["exhaustion"]),
		"the refusals classified wrongly: %s; exhausted: %s" % ["; ".join(wrong), ", ".join(exhausted_names)])
	## Structurally: the classification is set in one place and never inferred from prose.
	var result_code: String = _code_only(FileAccess.get_file_as_string(RESULT_FILE))
	var continuation_code: String = _code_only(FileAccess.get_file_as_string(CONTINUATION_FILE))
	var parsing: PackedStringArray = PackedStringArray()
	for token: String in [".contains(", ".find(", "begins_with(", "ends_with(", ".match(", "RegEx", "split("]:
		if continuation_code.contains(token):
			parsing.append(token)
	var conditions_on_text: int = 0
	for line: String in continuation_code.split("\n"):
		var stripped: String = line.strip_edges()
		if (stripped.begins_with("if ") or stripped.begins_with("elif ") or stripped.begins_with("match ")) \
				and stripped.contains("failure_reason"):
			conditions_on_text += 1
	var exhaustion_at: int = continuation_code.find("SupportContinuationResult.exhaustion(")
	var proof_at: int = continuation_code.find("if SupportSelection.is_rank_exhausted(")
	_expect(result_code.count("exhausted = true") == 1 and _function_body(result_code, "is_exhausted").contains("exhausted")
			and not _function_body(result_code, "is_exhausted").contains("failure_reason")
			and continuation_code.count("SupportContinuationResult.exhaustion(") == 1
			and proof_at > 0 and exhaustion_at > proof_at and parsing.is_empty() and conditions_on_text == 0,
		"the classification is set %d time(s); the continuation parses [%s] and branches on text %d time(s)"
			% [result_code.count("exhausted = true"), ", ".join(parsing), conditions_on_text])
	print("  %d refusals: %d classified exhausted (%s); the classification is set in 1 place, guarded by the selector's exhaustion proof; the continuation inspects refusal text 0 times"
		% [cases.size(), exhausted_names.size(), ", ".join(exhausted_names)])
	_done("invalid_input_and_exhaustion_are_distinguishable_without_text")


# --- 18. The composed offer carries the passive fallback whole ----------------------------------------------------------

## MOVED ONE FOR ONE UNDER ROGUELITE FOUNDATION I7 (D-306). Under I5 this check proved the whole
## offer refused on exhaustion; I7 composes the exhausted Support lane's passive fallback instead, so
## the same two assertions now prove that offer is composed whole — and every seed still drives one
## refusal: the unchanged choice transaction refusing to take that Support lane.
##
## MOVED AGAIN UNDER ROGUELITE FOUNDATION I8 (D-308): the choice transaction now takes that Support
## lane as one passive card, so the same assertion proves it is taken — its seed spent and its card
## held once — and no refusal is driven here any more.
func _check_exhausted_composition_carries_the_passive_fallback_whole() -> void:
	print("")
	print("--- 18. Rank-aware composition on exhaustion carries the I7 passive fallback whole: no partial lane, no support progression, no fourth lane")
	var profiles: Array[SkillTagProfile] = SkillSupportCatalogue.skill_profiles()
	var definitions: Array[SupportDefinition] = SkillSupportCatalogue.support_definitions()
	var cards: Array[PassiveCardDefinition] = PassiveCardCatalogue.records()
	var held: AcquiredSupports = _shipped(2, 2)
	var whole: int = 0
	var passive_ready: int = 0
	var repeatable: int = 0
	for root_seed: int in SEED_SAMPLES:
		var offer: RiftOffer = RiftOfferComposition.compose(profiles, definitions, held, cards, root_seed)
		var taken: RiftOfferChoiceResult = RiftOfferChoice.choose(offer, RiftOffer.Lane.SUPPORT,
			RiftRunBuild.new(), RiftConsumptionLedger.new())
		if offer.ok and offer.problem().is_empty() and offer.root_seed == root_seed \
				and offer.lane_order() == RiftOffer.LANE_ORDER \
				and offer.support_content_kind == RiftOffer.SupportContentKind.PASSIVE_FALLBACK \
				and offer.identity_for(RiftOffer.Lane.SUPPORT).size() == 1 and offer.support_fallback != null \
				and offer.support_fallback_card_id != offer.combat_card_id \
				and offer.support_fallback_card_id != offer.utility_card_id \
				and String(offer.skill_id).is_empty() and String(offer.support_id).is_empty() \
				and offer.support_derivation == null \
				and offer.support_progression_kind == RiftOffer.UNRESOLVED_PROGRESSION_KIND \
				and offer.support_rank_before == RiftOffer.UNRESOLVED_RANK and offer.support_rank_after == RiftOffer.UNRESOLVED_RANK \
				and offer.support_continuation != null and offer.support_continuation.is_exhausted() \
				and offer.support_continuation.failure_reason == EXHAUSTION_REASON \
				and taken.ok and taken.carries_support_fallback() and taken.problem().is_empty() \
				and taken.root_seed == root_seed and taken.new_ledger.has_consumed(root_seed) \
				and taken.new_build.acquisitions_for(offer.support_fallback_card_id) == 1:
			whole += 1
		## BOTH PASSIVE LANES ARE THE INDEPENDENT DRAWS, untouched by the fallback beside them.
		var combat: PassiveCardSelectionResult = PassiveCardSelection.select(cards,
			RiftOffer.category_for_lane(RiftOffer.Lane.COMBAT_DEFENCE),
			RiftOfferComposition.lane_seed_for(root_seed, RiftOffer.Lane.COMBAT_DEFENCE))
		var utility: PassiveCardSelectionResult = PassiveCardSelection.select(cards,
			RiftOffer.category_for_lane(RiftOffer.Lane.UTILITY),
			RiftOfferComposition.lane_seed_for(root_seed, RiftOffer.Lane.UTILITY))
		if combat.ok and utility.ok and offer.combat_card_id == combat.selected_card_id \
				and offer.utility_card_id == utility.selected_card_id:
			passive_ready += 1
		## No redraw: the same root seed composes the same offer.
		if RiftOfferComposition.compose(profiles, definitions, held, cards, root_seed).describe() == offer.describe():
			repeatable += 1
	_expect(whole == SEED_SAMPLES, "%d of %d exhausted compositions carried the passive fallback whole" % [whole, SEED_SAMPLES])
	_expect(passive_ready == SEED_SAMPLES and repeatable == SEED_SAMPLES and RiftOffer.LANE_ORDER.size() == 3,
		"passive lanes independent at %d, repeatable at %d, %d lanes" % [passive_ready, repeatable, RiftOffer.LANE_ORDER.size()])
	print("  %d of %d root seeds compose a PASSIVE_FALLBACK Support lane beside the two ordinary passive lanes; the I8 choice transaction takes that Support lane as one passive card on every one"
		% [whole, SEED_SAMPLES])
	print("  no Skill, support, weighted derivation, progression kind or rank on the Support lane; both passive lanes are the independent draws on %d of %d; the same seed composes the same offer %d of %d; %d lanes in the fixed order"
		% [passive_ready, SEED_SAMPLES, repeatable, SEED_SAMPLES, RiftOffer.LANE_ORDER.size()])
	_done("exhausted_composition_carries_the_passive_fallback_whole")


# --- 19. Never rank three -------------------------------------------------------------------------------------------------

func _check_no_composed_offer_requests_rank_three() -> void:
	print("")
	print("--- 19. Across every shipped rank state and %d root seeds, no composed offer requests rank 3" % SWEEP_ROOT_SEEDS)
	var profiles: Array[SkillTagProfile] = SkillSupportCatalogue.skill_profiles()
	var definitions: Array[SupportDefinition] = SkillSupportCatalogue.support_definitions()
	var cards: Array[PassiveCardDefinition] = PassiveCardCatalogue.records()
	var composed: int = 0
	var above: int = 0
	var from_maximum: int = 0
	var refusals_by_state: Dictionary = {}
	var fallbacks_by_state: Dictionary = {}
	var non_exhaustion_refusals: int = 0
	for reaching: int in [0, 1, 2]:
		for sweeping: int in [0, 1, 2]:
			var held: AcquiredSupports = _shipped(reaching, sweeping)
			var state: String = "R%d S%d" % [reaching, sweeping]
			for root_seed: int in SWEEP_ROOT_SEEDS:
				var offer: RiftOffer = RiftOfferComposition.compose(profiles, definitions, held, cards, root_seed)
				composed += 1
				if not offer.ok:
					refusals_by_state[state] = int(refusals_by_state.get(state, 0)) + 1
					if offer.failure_reason != SUPPORT_LANE_PREFIX + EXHAUSTION_REASON:
						non_exhaustion_refusals += 1
					continue
				## Roguelite Foundation I7 (D-306): exhaustion now composes a passive fallback.
				if offer.support_content_kind == RiftOffer.SupportContentKind.PASSIVE_FALLBACK:
					fallbacks_by_state[state] = int(fallbacks_by_state.get(state, 0)) + 1
					continue
				if offer.support_rank_after > SHIPPED_MAXIMUM_RANK:
					above += 1
				if offer.support_progression_kind == SupportContinuationResult.Kind.RANK_INCREASE \
						and offer.support_rank_before >= SHIPPED_MAXIMUM_RANK:
					from_maximum += 1
	_expect(above == 0 and from_maximum == 0, "%d offers requested a rank above 2 and %d raised a pair already at 2" % [above, from_maximum])
	## MOVED ONE FOR ONE UNDER I7 (D-306): R2 S2 composes a passive fallback rather than refusing.
	_expect(refusals_by_state.is_empty() and fallbacks_by_state.size() == 1
			and int(fallbacks_by_state.get("R2 S2", 0)) == SWEEP_ROOT_SEEDS and non_exhaustion_refusals == 0,
		"refusals by state %s; passive fallbacks by state %s; %d refusals were not exhaustion" % [
			str(refusals_by_state), str(fallbacks_by_state), non_exhaustion_refusals])

	## AND THE PROGRESSION D-299 NAMES, END TO END THROUGH THE ACCEPTED CHOICE TRANSACTION —
	## composed and taken by this harness, one Support choice after another, never by a
	## playable level-up: acquire each pair at rank 1, raise each to rank 2, then stop.
	var shapes: Dictionary = {}
	var bad_chains: PackedStringArray = PackedStringArray()
	for chain: int in CHAINS:
		var build: RiftRunBuild = RiftRunBuild.new()
		var ledger: RiftConsumptionLedger = RiftConsumptionLedger.new()
		var steps: PackedStringArray = PackedStringArray()
		var final_reason: String = ""
		var final_kind: int = RiftOffer.UNRESOLVED_SUPPORT_CONTENT_KIND
		for step: int in 6:
			var root_seed: int = chain * 100 + step
			var offer: RiftOffer = RiftOfferComposition.compose(profiles, definitions, build.acquired_supports(), cards, root_seed)
			final_kind = offer.support_content_kind
			if not offer.ok:
				final_reason = offer.failure_reason
				break
			var taken: RiftOfferChoiceResult = RiftOfferChoice.choose(offer, RiftOffer.Lane.SUPPORT, build, ledger)
			if not taken.ok:
				final_reason = "the choice refused: %s" % taken.failure_reason
				break
			## Roguelite Foundation I8 (D-308): a passive-fallback Support lane is taken as one passive card.
			if taken.carries_support_fallback():
				steps.append("fallback")
			else:
				steps.append("%s %d->%d" % ["new" if taken.support_progression_kind == SupportContinuationResult.Kind.NEW_PAIR else "rank",
					taken.support_rank_before, taken.support_rank_after])
			build = taken.new_build
			ledger = taken.new_ledger
		var shape: String = ", ".join(steps)
		shapes[shape] = int(shapes.get(shape, 0)) + 1
		## MOVED ONE FOR ONE UNDER I8 (D-308): the two compositions after the named four carry a passive
		## fallback, and the choice transaction takes each as one passive card — no rank moves, no refusal.
		if shape != "new 0->1, new 0->1, rank 1->2, rank 1->2, fallback, fallback" \
				or final_kind != RiftOffer.SupportContentKind.PASSIVE_FALLBACK or not final_reason.is_empty() \
				or build.passive_acquisitions() != 2 \
				or build.support_rank_for(QUICK_STRIKE, REACHING) != 2 or build.support_rank_for(QUICK_STRIKE, SWEEPING) != 2:
			bad_chains.append("chain %d: [%s] then '%s'" % [chain, shape, final_reason])
	_expect(bad_chains.is_empty(), "a chain left the named progression: %s" % "; ".join(bad_chains))
	print("  %d compositions over 9 shipped states x %d root seeds: %d requested a rank above 2, %d raised a pair already at rank 2; refusals %s, passive fallbacks %s, %d refusals not exhaustion"
		% [composed, SWEEP_ROOT_SEEDS, above, from_maximum, str(refusals_by_state), str(fallbacks_by_state), non_exhaustion_refusals])
	print("  %d chains through the accepted choice transaction: %s — the fifth and sixth compositions carried a passive fallback, which the I8 choice transaction takes as one passive card while both ranks stay at 2"
		% [CHAINS, ", ".join(_shape_lines(shapes))])
	_done("no_composed_offer_requests_rank_three")


# --- 20. I4's safety net -----------------------------------------------------------------------------------------------

func _check_the_i4_rank_three_refusal_is_unchanged() -> void:
	print("")
	print("--- 20. The accepted I4 whole-build rank-three refusal is unchanged")
	var seam_hash: String = FileAccess.get_sha256(SEAM_FILE)
	var result_hash: String = FileAccess.get_sha256(SEAM_RESULT_FILE)
	var answered: int = 0
	for id: StringName in [REACHING, SWEEPING]:
		for rank: int in [3, 4]:
			if not SkillSupportCatalogue.support_rank_values(QUICK_STRIKE, id, rank).is_empty():
				answered += 1
	_expect(seam_hash.begins_with(SEAM_SHA256_PREFIX) and result_hash.begins_with(SEAM_RESULT_SHA256_PREFIX) and answered == 0,
		"the seam hashes %s, its result %s; %d rank-three answers" % [seam_hash.left(8), result_hash.left(8), answered])
	print("  the seam %s… and its result %s… are at their D-320 and D-321 hashes — D-298's published files with I13's Global Damage and I14's Maximum Life added; the catalogue answers %d of 4 questions at ranks 3 and 4"
		% [seam_hash.left(8), result_hash.left(8), answered])
	print("  STATED LIMITATION: the behavioural rank-three refusal is the accepted I4 suite's own proof, re-run unchanged beside this one;")
	print("  this suite proves only that the seam which makes it did not change and that the table still answers nothing past rank 2.")
	_done("the_i4_rank_three_refusal_is_unchanged")


# --- 21. Nothing new is wired ------------------------------------------------------------------------------------------

func _check_nothing_running_calls_the_new_mechanism_except_through_accepted_composition() -> void:
	print("")
	print("--- 21. Nothing that runs reaches the new mechanism except through the accepted composition path")
	var stray: PackedStringArray = PackedStringArray()
	var reached: Dictionary = {}
	var scanned: int = 0
	var continuation_callers: PackedStringArray = PackedStringArray()
	for scan_root: String in SCANNED_ROOTS:
		for path: String in _files_under(scan_root, [".gd", ".tscn", ".tres"]):
			scanned += 1
			var source: String = FileAccess.get_file_as_string(path)
			for row: Array in NEW_MEMBER_OWNERS:
				if not source.contains(String(row[0])):
					continue
				if (row[1] as Array).has(path.get_file()):
					reached["%s:%s" % [row[0], path.get_file()]] = true
				else:
					stray.append("%s names %s" % [path.get_file(), row[0]])
			if source.contains("SupportContinuation.select(") and path != CONTINUATION_FILE:
				continuation_callers.append(path.get_file())
	var owed: int = 0
	for row: Array in NEW_MEMBER_OWNERS:
		owed += (row[1] as Array).size()
	var project: String = FileAccess.get_file_as_string(PROJECT_SETTINGS_FILE)
	var project_names: int = 0
	for row: Array in NEW_MEMBER_OWNERS:
		if project.contains(String(row[0])):
			project_names += 1
	_expect(scanned > 100 and stray.is_empty() and reached.size() == owed,
		"%d files scanned; stray %s; %d of %d owned uses present" % [scanned, ", ".join(stray), reached.size(), owed])
	_expect(continuation_callers == PackedStringArray(["rift_offer_composition.gd"]) and project_names == 0
			and not project.contains("[autoload]") and _action_count() == EXPECTED_ACTIONS
			and String(ProjectSettings.get_setting("application/run/main_scene", "")) == ENTRYPOINT,
		"the continuation is called by [%s]; project.godot names %d new member(s)" % [", ".join(continuation_callers), project_names])
	print("  %d running files scanned: the %d new members appear only where they are owned — %d of %d owned uses present, %d stray; the continuation is called only by [%s]"
		% [scanned, NEW_MEMBER_OWNERS.size(), reached.size(), owed, stray.size(), ", ".join(continuation_callers)])
	print("  project.godot: %d actions, the Prototype App entrypoint, [autoload] present: %s, %d new member(s) named"
		% [_action_count(), project.contains("[autoload]"), project_names])
	_done("nothing_running_calls_the_new_mechanism_except_through_accepted_composition")


# --- 22. Generic, and nothing accepted moved ---------------------------------------------------------------------------

func _check_the_generic_mechanism_names_nothing_concrete_and_nothing_accepted_moved() -> void:
	print("")
	print("--- 22. The generic mechanism names nothing concrete, and no accepted value moved")
	var named: PackedStringArray = PackedStringArray()
	for path: String in [DEFINITION_FILE, SELECTION_FILE, SELECTION_RESULT_FILE, CONTINUATION_FILE, RESULT_FILE]:
		var raw: String = FileAccess.get_file_as_string(path)
		for token: String in CONCRETE_TOKENS:
			if raw.contains(token):
				named.append("%s: %s" % [path.get_file(), token])
	var catalogue_raw: String = FileAccess.get_file_as_string(CATALOGUE_FILE)
	var found_in_catalogue: int = 0
	for token: String in CONCRETE_TOKENS:
		if catalogue_raw.contains(token):
			found_in_catalogue += 1
	_expect(named.is_empty() and found_in_catalogue >= 4,
		"the generic files name %s (the scan found %d tokens where they belong)" % [", ".join(named), found_in_catalogue])

	## The values the brief forbids moving.
	var value_wrong: PackedStringArray = PackedStringArray()
	for rank: int in [1, 2]:
		if SkillSupportCatalogue.support_rank_values(QUICK_STRIKE, REACHING, rank) != {&"reach": REACH_BY_RANK[rank]} \
				or SkillSupportCatalogue.support_rank_values(QUICK_STRIKE, SWEEPING, rank) != {
					&"release_arc_degrees": ARC_BY_RANK[rank], &"soft_target_cone_degrees": CONE_BY_RANK[rank]}:
			value_wrong.append("the rank-%d records" % rank)
	for definition: SupportDefinition in SkillSupportCatalogue.support_definitions():
		if definition.base_weight != SHIPPED_WEIGHT or not definition.tag_bonuses.is_empty():
			value_wrong.append("%s's weight" % definition.support_id())
	var profile: SkillTagProfile = SkillSupportCatalogue.quick_strike_profile()
	var tags: PackedStringArray = PackedStringArray()
	for tag: StringName in profile.tags:
		tags.append(String(tag))
	tags.sort()
	if ", ".join(tags) != "Attack, Hit, Melee, Physical, Strike":
		value_wrong.append("Quick Strike's tags [%s]" % ", ".join(tags))
	if PassiveCardCatalogue.records().size() != 6:
		value_wrong.append("the card records")
	if SupportSelection.SKILL_STREAM_SALT != SKILL_STREAM_SALT or SupportSelection.SUPPORT_STREAM_SALT != SUPPORT_STREAM_SALT \
			or SupportSelection.MAXIMUM_TOTAL_WEIGHT != MAXIMUM_TOTAL_WEIGHT \
			or RiftOfferComposition.SUPPORT_LANE_DOMAIN != SUPPORT_LANE_DOMAIN \
			or RiftOfferComposition.COMBAT_DEFENCE_LANE_DOMAIN != COMBAT_DEFENCE_LANE_DOMAIN \
			or RiftOfferComposition.UTILITY_LANE_DOMAIN != UTILITY_LANE_DOMAIN \
			or RiftOffer.LANE_ORDER != [RiftOffer.Lane.SUPPORT, RiftOffer.Lane.COMBAT_DEFENCE, RiftOffer.Lane.UTILITY]:
		value_wrong.append("a salt, ceiling, lane domain or the lane order")
	var canonical: QuickStrikeData = load(CANONICAL_QUICK_STRIKE) as QuickStrikeData
	if canonical == null or not is_equal_approx(canonical.reach, 1.65) or not is_equal_approx(canonical.release_arc_degrees, 100.0) \
			or not is_equal_approx(canonical.soft_target_cone_degrees, 65.0) or canonical.maximum_targets != 1 \
			or not is_equal_approx(canonical.action_time, 0.80):
		value_wrong.append("the canonical Quick Strike record")
	if not SkillSupportCatalogue.problems().is_empty():
		value_wrong.append("catalogue problems %s" % str(SkillSupportCatalogue.problems()))
	var hashes_after: Dictionary = _canonical_hashes()
	if hashes_after != _hashes_before or hashes_after.size() < 10:
		value_wrong.append("the .tres records under res://data")
	_expect(value_wrong.is_empty(), "accepted values moved: %s" % ", ".join(value_wrong))
	print("  the five generic files name %d concrete token(s); the scan found %d where they belong"
		% [named.size(), found_in_catalogue])
	print("  rank records 2.65 / 3.65 m, 180 / 260 and 110 / 155 degrees; weights 100 / 100; tags [%s]; %d cards; salts, ceiling, lane domains and lane order as accepted; quick_strike.tres 0.80 s / 1.65 m / 100 / 65 / 1 target; %d of %d .tres records hash identically before and after"
		% [", ".join(tags), PassiveCardCatalogue.records().size(), hashes_after.size() if hashes_after == _hashes_before else 0, _hashes_before.size()])
	_done("the_generic_mechanism_names_nothing_concrete_and_nothing_accepted_moved")


# --- Fixtures ----------------------------------------------------------------------------------------------------------

# --- 23. Maximum rank one (D-301) ------------------------------------------------------------------------------------------

func _check_a_maximum_rank_one_support_is_acquired_once_and_then_finished() -> void:
	print("")
	print("--- 23. A support with maximum rank 1 is acquired once at rank 1, is then finished, and a lane of them exhausts")
	var profiles: Array[SkillTagProfile] = _one_melee_skill()
	var cards: Array[PassiveCardDefinition] = PassiveCardCatalogue.records()
	var definitions: Array[SupportDefinition] = []
	definitions.append(_definition(SUPPORT_ALPHA, [SkillTags.MELEE] as Array[StringName], WEIGHT_ALPHA, 1))
	definitions.append(_definition(SUPPORT_BETA, [SkillTags.MELEE] as Array[StringName], WEIGHT_BETA, 1))
	_expect(definitions[0].problem().is_empty() and definitions[1].problem().is_empty(),
		"a maximum of 1 is not a valid definition: %s / %s" % [definitions[0].problem(), definitions[1].problem()])
	## Acquired through the accepted composer and choice transaction, one Support choice
	## at a time — composed by this harness, never by a playable level-up.
	var build: RiftRunBuild = RiftRunBuild.new()
	var ledger: RiftConsumptionLedger = RiftConsumptionLedger.new()
	var steps: PackedStringArray = PackedStringArray()
	var first_pair: StringName = &""
	var finished_draw: SupportSelectionResult = null
	var finished_tickets: int = -1
	var final_offer: RiftOffer = null
	for step: int in 3:
		var offer: RiftOffer = RiftOfferComposition.compose(profiles, definitions, build.acquired_supports(), cards, 700 + step)
		## Roguelite Foundation I7 (D-306): the exhausted lane now composes a passive fallback.
		if not offer.ok or offer.support_content_kind == RiftOffer.SupportContentKind.PASSIVE_FALLBACK:
			final_offer = offer
			break
		var taken: RiftOfferChoiceResult = RiftOfferChoice.choose(offer, RiftOffer.Lane.SUPPORT, build, ledger)
		if not taken.ok:
			steps.append("refused: %s" % taken.failure_reason)
			break
		steps.append("%s %s %d->%d" % [offer.support_id,
			"new" if offer.support_progression_kind == SupportContinuationResult.Kind.NEW_PAIR else "rank",
			taken.support_rank_before, taken.support_rank_after])
		build = taken.new_build
		ledger = taken.new_ledger
		if step == 0:
			## IMMEDIATELY AFTER ACQUISITION IT IS FINISHED: the rank draw finds nothing to
			## raise, and no ticket of its ladder reaches the pair.
			first_pair = offer.support_id
			finished_draw = SupportSelection.select_rank_increase(profiles, definitions, build.acquired_supports(), 7)
			finished_tickets = 0
			for ticket: int in WEIGHT_ALPHA + WEIGHT_BETA:
				if SupportSelection.select_rank_increase_with_tickets(profiles, definitions,
						build.acquired_supports(), 0, ticket).support_id == first_pair:
					finished_tickets += 1
	var held_after: AcquiredSupports = build.acquired_supports()
	var continued: SupportContinuationResult = SupportContinuation.select(profiles, definitions, held_after, 7)
	_expect(steps.size() == 2 and steps[0].ends_with("new 0->1") and steps[1].ends_with("new 0->1")
			and build.support_rank_for(SKILL_ONE, SUPPORT_ALPHA) == 1 and build.support_rank_for(SKILL_ONE, SUPPORT_BETA) == 1,
		"the maximum-one lifecycle took [%s]" % ", ".join(steps))
	_expect(finished_draw != null and not finished_draw.ok and finished_draw.has_no_candidates() and finished_tickets == 0,
		"after its first acquisition %s was still rankable: %s" % [
			first_pair, finished_draw.describe() if finished_draw != null else "<none>"])
	## MOVED ONE FOR ONE UNDER I7 (D-306): the third composition carries a passive fallback, and the
	## unchanged choice transaction refuses its Support lane — still two refusals driven.
	## MOVED AGAIN UNDER I8 (D-308): the choice transaction now takes that Support lane as one passive
	## card without moving either rank, so one refusal is driven here rather than two.
	var fallback_choice: RiftOfferChoiceResult = RiftOfferChoice.choose(final_offer, RiftOffer.Lane.SUPPORT,
		build, ledger) if final_offer != null else null
	_expect(continued.is_exhausted() and SupportSelection.is_rank_exhausted(profiles, definitions, held_after)
			and final_offer != null and final_offer.ok and final_offer.problem().is_empty()
			and final_offer.support_content_kind == RiftOffer.SupportContentKind.PASSIVE_FALLBACK
			and final_offer.support_continuation.is_exhausted()
			and fallback_choice != null and fallback_choice.ok and fallback_choice.carries_support_fallback()
			and fallback_choice.new_build.total_support_ranks() == build.total_support_ranks(),
		"both pairs at their maximum of 1 answered %s / %s" % [
			continued.describe(), final_offer.describe() if final_offer != null else "<no offer>"])
	_refusals += 1
	## AND BESIDE A MAXIMUM-TWO SUPPORT, every rank decision raises the one that can rise.
	var mixed: Array[SupportDefinition] = []
	mixed.append(_definition(SUPPORT_ALPHA, [SkillTags.MELEE] as Array[StringName], WEIGHT_ALPHA, 1))
	mixed.append(_definition(SUPPORT_BETA, [SkillTags.MELEE] as Array[StringName], WEIGHT_BETA, 2))
	var mixed_held: AcquiredSupports = _fabricated([[SKILL_ONE, SUPPORT_ALPHA, 1], [SKILL_ONE, SUPPORT_BETA, 1]])
	var raised_beta: int = 0
	var raised_alpha: int = 0
	for seed_value: int in SEED_SAMPLES:
		var result: SupportContinuationResult = SupportContinuation.select(profiles, mixed, mixed_held, seed_value)
		if result.is_rank_increase() and result.support_id == SUPPORT_BETA:
			raised_beta += 1
		if result.ok and result.support_id == SUPPORT_ALPHA:
			raised_alpha += 1
	_expect(raised_beta == SEED_SAMPLES and raised_alpha == 0,
		"beside a maximum-two support, %d decisions raised it and %d raised the finished one" % [raised_beta, raised_alpha])
	print("  through the accepted choice transaction: [%s], then the third composition carried a passive fallback (%s), whose Support lane the I8 choice transaction takes as one passive card"
		% [", ".join(steps), final_offer.support_fallback_card_id if final_offer != null else "none"])
	print("  immediately after acquiring %s at rank 1 of 1 it is finished: the rank draw reports an empty candidate set (%s) and %d of %d walked tickets reach it"
		% [first_pair, finished_draw.has_no_candidates() if finished_draw != null else false, finished_tickets, WEIGHT_ALPHA + WEIGHT_BETA])
	print("  beside a maximum-two support held at rank 1: %d of %d rank decisions raise %s and %d reach the finished %s"
		% [raised_beta, SEED_SAMPLES, SUPPORT_BETA, raised_alpha, SUPPORT_ALPHA])
	_done("a_maximum_rank_one_support_is_acquired_once_and_then_finished")


# --- 24. Above-maximum ownership is invalid state (D-301) -------------------------------------------------------------------

func _check_above_maximum_ownership_is_invalid_state() -> void:
	print("")
	print("--- 24. A pair held above its maximum is invalid state: refused whole in both phases, never exhaustion, never clamped")
	var profiles: Array[SkillTagProfile] = SkillSupportCatalogue.skill_profiles()
	var definitions: Array[SupportDefinition] = SkillSupportCatalogue.support_definitions()
	var reversed_definitions: Array[SupportDefinition] = []
	for index: int in range(definitions.size() - 1, -1, -1):
		reversed_definitions.append(definitions[index])
	var cards: Array[PassiveCardDefinition] = PassiveCardCatalogue.records()
	## One of the four states, R3 S0, still has a NEW compatible pair available — the
	## first delivery would have offered it over the corrupted record.
	var states: Array = [[3, 0], [3, 1], [3, 2], [1, 3]]
	var violations: PackedStringArray = PackedStringArray()
	var driven: int = 0
	for state: Array in states:
		var held: AcquiredSupports = _shipped(int(state[0]), int(state[1]))
		for seed_value: int in SEED_SAMPLES:
			driven += 1
			var ordinary: SupportSelectionResult = SupportSelection.select(profiles, definitions, held, seed_value)
			var ranked: SupportSelectionResult = SupportSelection.select_rank_increase(profiles, definitions, held, seed_value)
			var continued: SupportContinuationResult = SupportContinuation.select(profiles, definitions, held, seed_value)
			var reversed: SupportContinuationResult = SupportContinuation.select(profiles, reversed_definitions, held, seed_value)
			var offer: RiftOffer = RiftOfferComposition.compose(profiles, definitions, held, cards, seed_value)
			_refusals += 5
			if ordinary.ok or ordinary.has_no_candidates() or not ordinary.failure_reason.begins_with("invalid acquisition state: ") \
					or ranked.ok or ranked.has_no_candidates() \
					or continued.ok or continued.is_exhausted() or not continued.problem().is_empty() \
					or continued.selection != null or not continued.pair().is_empty() or _full(reversed) != _full(continued) \
					or offer.ok or not offer.problem().is_empty() or offer.refusing_lane != RiftOffer.Lane.SUPPORT \
					or not offer.identity_for(RiftOffer.Lane.SUPPORT).is_empty() \
					or SupportSelection.is_rank_exhausted(profiles, definitions, held):
				violations.append("R%d S%d seed %d: %s / %s" % [int(state[0]), int(state[1]), seed_value,
					ordinary.describe(), continued.describe()])
	var reason: String = SupportSelection.select(profiles, definitions, _shipped(3, 1), 0).failure_reason
	_expect(violations.is_empty(), "%d of %d above-maximum answers were not invalid-state refusals: %s" % [
		violations.size(), driven, "; ".join(violations.slice(0, 3))])
	_expect(reason == "invalid acquisition state: quick_strike -> reaching_edge is held at rank 3, above the maximum rank of 2 its definition declares",
		"the above-maximum refusal reads '%s'" % reason)
	print("  4 states holding a pair above its maximum (R3 S0, R3 S1, R3 S2, R1 S3) x %d seeds: %d new-pair draws, rank draws, continuations and compositions each refused as invalid state; %d violations (a selection, an empty-candidate reading, exhaustion, a partial offer, or reversal changing the answer)"
		% [SEED_SAMPLES, driven, violations.size()])
	print("  the refusal names the corruption rather than clamping it: '%s'" % reason)
	_done("above_maximum_ownership_is_invalid_state")


# --- 25. The empty-candidate classification (D-301) ------------------------------------------------------------------------

func _check_only_a_valid_empty_candidate_set_is_classified_no_candidates() -> void:
	print("")
	print("--- 25. Only a VALID empty candidate set is classified 'no candidates'; invalid inputs and unusable ladders never are")
	var profiles: Array[SkillTagProfile] = SkillSupportCatalogue.skill_profiles()
	var definitions: Array[SupportDefinition] = SkillSupportCatalogue.support_definitions()
	var caster: Array[SkillTagProfile] = []
	caster.append(_profile(&"zz_caster", [SkillTags.SPELL, SkillTags.HIT] as Array[StringName]))
	var no_profiles: Array[SkillTagProfile] = []
	var untagged: Array[SkillTagProfile] = []
	untagged.append(SkillTagProfile.of(&"zz_untagged", "Test Untagged", [] as Array[StringName]))
	var no_definitions: Array[SupportDefinition] = []
	var null_definition: Array[SupportDefinition] = []
	null_definition.append(null)
	var duplicate: Array[SupportDefinition] = definitions.duplicate()
	duplicate.append(definitions[0])
	var reaching: SupportEligibility = definitions[0].eligibility
	var variants: Dictionary = {}
	for row: Array in [
		["a zero base weight", 0, {}, definitions[0].maximum_rank],
		["a negative tag bonus", 10, {SkillTags.MELEE: -5}, definitions[0].maximum_rank],
		["an undeclared maximum", 10, {}, SupportDefinition.UNDECLARED_MAXIMUM_RANK],
		["a zero maximum", 10, {}, 0],
		["a negative maximum", 10, {}, -3],
	]:
		var variant_set: Array[SupportDefinition] = []
		variant_set.append(SupportDefinition.of(reaching, int(row[1]), row[2] as Dictionary, int(row[3])))
		variant_set.append(definitions[1])
		variants[String(row[0])] = variant_set
	var heavy_profiles: Array[SkillTagProfile] = []
	heavy_profiles.append(_profile(&"zz_skill_heavy", [SkillTags.ATTACK, SkillTags.MELEE] as Array[StringName]))
	var heavy: Array[SupportDefinition] = []
	for index: int in 5:
		heavy.append(_definition(StringName("zz_t_heavy_%d" % index), [SkillTags.MELEE] as Array[StringName],
			SupportDefinition.MAXIMUM_WEIGHT, FIXTURE_MAXIMUM_RANK))
	var heavy_held: AcquiredSupports = _every_eligible(heavy_profiles, heavy, 1)
	var valid_empty: Array = [
		["the new-pair draw with every compatible pair held", SupportSelection.select(profiles, definitions, _shipped(1, 1), 7)],
		["the new-pair draw with no compatible support", SupportSelection.select(caster, definitions, null, 7)],
		["the rank draw with every pair at its maximum", SupportSelection.select_rank_increase(profiles, definitions, _shipped(2, 2), 7)],
		["the rank draw with nothing held", SupportSelection.select_rank_increase(profiles, definitions, null, 7)],
	]
	var invalid: Array = [
		["a negative ticket", SupportSelection.select_with_tickets(profiles, definitions, null, -1, 0)],
		["no equipped Skill", SupportSelection.select(no_profiles, definitions, null, 7)],
		["an untagged Skill", SupportSelection.select(untagged, definitions, null, 7)],
		["no support definitions", SupportSelection.select(profiles, no_definitions, null, 7)],
		["a null definition", SupportSelection.select(profiles, null_definition, null, 7)],
		["a duplicate support", SupportSelection.select(profiles, duplicate, null, 7)],
		["a pair above its maximum, new-pair draw", SupportSelection.select(profiles, definitions, _shipped(3, 0), 7)],
		["a pair above its maximum, rank draw", SupportSelection.select_rank_increase(profiles, definitions, _shipped(3, 1), 7)],
		["a new-pair ladder over the ceiling", SupportSelection.select_with_tickets(heavy_profiles, heavy, null, 0, 0)],
		["a rank ladder over the ceiling", SupportSelection.select_rank_increase_with_tickets(heavy_profiles, heavy, heavy_held, 0, 0)],
	]
	for key: String in _sorted_keys(variants):
		var variant_set: Array[SupportDefinition] = variants[key]
		invalid.append([key, SupportSelection.select(profiles, variant_set, null, 7)])
		invalid.append(["%s, rank draw" % key, SupportSelection.select_rank_increase(profiles, variant_set, _shipped(1, 1), 7)])
	var valid_wrong: PackedStringArray = PackedStringArray()
	for row: Array in valid_empty:
		var result: SupportSelectionResult = row[1]
		_refusals += 1
		if result.ok or not result.has_no_candidates() or not result.problem().is_empty() \
				or not String(result.skill_id).is_empty() or result.total_eligible_weight != 0:
			valid_wrong.append("%s: %s" % [row[0], result.describe()])
	var invalid_wrong: PackedStringArray = PackedStringArray()
	for row: Array in invalid:
		var result: SupportSelectionResult = row[1]
		_refusals += 1
		if result.ok or result.has_no_candidates() or result.no_candidates or not result.problem().is_empty():
			invalid_wrong.append("%s: %s" % [row[0], result.describe()])
	var successes: Array[SupportSelectionResult] = [
		SupportSelection.select(profiles, definitions, null, 7),
		SupportSelection.select_rank_increase(profiles, definitions, _shipped(1, 1), 7),
	]
	var success_wrong: int = 0
	for result: SupportSelectionResult in successes:
		if not result.ok or result.has_no_candidates() or not result.problem().is_empty():
			success_wrong += 1
	var forged: SupportSelectionResult = SupportSelectionResult.chosen(SKILL_ONE, SUPPORT_ALPHA, 4, {}, 4, 0, 4, 1, 0)
	forged.no_candidates = true
	var blank: SupportSelectionResult = SupportSelectionResult.no_candidates_found("  ")
	var plain: SupportSelectionResult = SupportSelectionResult.failed("a stated reason")
	_expect(valid_wrong.is_empty(), "a valid empty candidate set was not classified: %s" % "; ".join(valid_wrong))
	_expect(invalid_wrong.is_empty(), "an invalid input or unusable ladder was classified 'no candidates': %s" % "; ".join(invalid_wrong))
	_expect(success_wrong == 0 and not forged.problem().is_empty() and blank.has_no_candidates()
			and not blank.failure_reason.strip_edges().is_empty() and blank.problem().is_empty()
			and not plain.has_no_candidates(),
		"successes misclassified %d; forged '%s'; blank %s; plain %s" % [success_wrong, forged.problem(), blank.describe(), plain.describe()])
	## Structurally: set in one place, only after a completed walk, never by the ladder.
	var selection_code: String = _code_only(FileAccess.get_file_as_string(SELECTION_FILE))
	var result_code: String = _code_only(FileAccess.get_file_as_string(SELECTION_RESULT_FILE))
	_expect(selection_code.count("SupportSelectionResult.no_candidates_found(") == 2
			and not _function_body(selection_code, "_draw").contains("no_candidates_found(")
			and result_code.count("no_candidates = true") == 1
			and _function_body(result_code, "has_no_candidates").contains("no_candidates")
			and not _function_body(result_code, "has_no_candidates").contains("failure_reason"),
		"the classification is built %d time(s) in the selector and set %d time(s) in the result" % [
			selection_code.count("SupportSelectionResult.no_candidates_found("), result_code.count("no_candidates = true")])
	print("  %d of %d valid empty candidate sets classified 'no candidates' (every pair held; no compatible support; every pair at its maximum; nothing held to raise)"
		% [valid_empty.size() - valid_wrong.size(), valid_empty.size()])
	print("  %d of %d invalid inputs and unusable ladders classified — a negative ticket, no Skill, an untagged Skill, no definitions, a null or duplicate definition, a pair above its maximum in either draw, either ladder over the ceiling, and a zero weight, negative bonus, undeclared, zero or negative maximum in either draw"
		% [invalid_wrong.size(), invalid.size()])
	print("  %d of %d successes classified; a success forced to claim an empty set reports: '%s'; the classification is built in 2 places, each after a completed walk, and never by the ladder"
		% [success_wrong, successes.size(), forged.problem()])
	_done("only_a_valid_empty_candidate_set_is_classified_no_candidates")


# --- 26. The reported overflow edge case (D-301) ----------------------------------------------------------------------------

func _check_a_refused_new_pair_ladder_never_advances_to_the_rank_phase() -> void:
	print("")
	print("--- 26. One Skill's ladder over the ceiling beside another Skill's new pair: the lane refuses on every seed, and never ranks")
	## MOVED BY D-302, THE SAME FOUR ASSERTIONS. Under D-301 this fixture refused only on
	## the seeds whose stage-one ticket pointed at the over-ceiling Skill and drew the
	## valid Skill's new pair on the rest, so this check counted both and required some
	## of each. Every candidate ladder is now validated before stage one, so the same
	## inputs refuse on EVERY seed: the first assertion now requires all of them, and
	## still requires the sweep to contain seeds pointing at each Skill, so the seeds
	## D-301 answered with a new pair are among those that now refuse.
	var fixture: Array = _overflow_fixture()
	var profiles: Array[SkillTagProfile] = fixture[0]
	var definitions: Array[SupportDefinition] = fixture[1]
	var held: AcquiredSupports = fixture[2]
	var reversed_profiles: Array[SkillTagProfile] = _reversed_skills(profiles)
	var reversed_definitions: Array[SupportDefinition] = _reversed_supports(definitions)
	var cards: Array[PassiveCardDefinition] = PassiveCardCatalogue.records()
	var expected: String = _overweight_reason(&"zz_skill_heavy")
	var refused_all: int = 0
	var drew: int = 0
	var points_at_overweight: int = 0
	var points_at_valid: int = 0
	var violations: PackedStringArray = PackedStringArray()
	for seed_value: int in SEED_SAMPLES:
		## Where stage one WOULD point: the ordinary draw has two Skills with something new,
		## sorted heavy before light. Before D-302 this ticket decided whether the malformed
		## pool was looked at at all.
		if SupportSelection.skill_ticket_for(seed_value) % 2 == 0:
			points_at_overweight += 1
		else:
			points_at_valid += 1
		var first: SupportSelectionResult = SupportSelection.select(profiles, definitions, held, seed_value)
		var continued: SupportContinuationResult = SupportContinuation.select(profiles, definitions, held, seed_value)
		var reversed: SupportContinuationResult = SupportContinuation.select(reversed_profiles, reversed_definitions, held, seed_value)
		_refusals += 1
		if first.ok:
			drew += 1
		elif not first.has_no_candidates() and first.failure_reason == expected:
			refused_all += 1
		if _full(reversed) != _full(continued):
			violations.append("seed %d: reversal answered %s" % [seed_value, reversed.describe()])
		if continued.ok or continued.is_new_pair() or continued.is_rank_increase() \
				or continued.is_exhausted() or not continued.problem().is_empty() or continued.selection != null \
				or not continued.pair().is_empty() or not continued.failure_reason.contains(expected):
			violations.append("seed %d: %s" % [seed_value, continued.describe()])
	var offers_refused: int = 0
	var offers_new: int = 0
	var offers_rank: int = 0
	var offers_bad: int = 0
	for root_seed: int in SEED_SAMPLES:
		var offer: RiftOffer = RiftOfferComposition.compose(profiles, definitions, held, cards, root_seed)
		if not offer.ok:
			offers_refused += 1
			if offer.refusing_lane != RiftOffer.Lane.SUPPORT or not offer.problem().is_empty() \
					or not offer.identity_for(RiftOffer.Lane.SUPPORT).is_empty():
				offers_bad += 1
		elif offer.support_progression_kind == SupportContinuationResult.Kind.RANK_INCREASE:
			offers_rank += 1
		else:
			offers_new += 1
	## THE PHASE ADVANCES ONLY ON THE CLASSIFICATION, and no refusal text chooses a phase.
	var code: String = _code_only(FileAccess.get_file_as_string(CONTINUATION_FILE))
	var guard_at: int = code.find("if not new_pair_selection.has_no_candidates():")
	var rank_at: int = code.find("SupportSelection.select_rank_increase(")
	var rank_guard_at: int = code.find("if not rank_selection.has_no_candidates():")
	var exhausted_at: int = code.find("if SupportSelection.is_rank_exhausted(")
	_expect(refused_all == SEED_SAMPLES and drew == 0 and points_at_overweight > 0 and points_at_valid > 0,
		"the new-pair draw refused %d of %d seeds as the over-ceiling pool and drew %d (stage one pointed at it %d times, at the valid Skill %d)" % [
			refused_all, SEED_SAMPLES, drew, points_at_overweight, points_at_valid])
	_expect(violations.is_empty(), "the edge case advanced, misclassified or changed under reversal: %s" % "; ".join(violations.slice(0, 3)))
	_expect(offers_refused == SEED_SAMPLES and offers_new == 0 and offers_rank == 0 and offers_bad == 0,
		"compositions: %d refused, %d new, %d rank, %d malformed" % [offers_refused, offers_new, offers_rank, offers_bad])
	_expect(guard_at > 0 and rank_at > guard_at and rank_guard_at > rank_at and exhausted_at > rank_guard_at,
		"the phase guards are missing or out of order (%d, %d, %d, %d)" % [guard_at, rank_at, rank_guard_at, exhausted_at])
	print("  over %d seeds the new-pair draw refused the over-ceiling pool %d times and drew %d pairs; stage one would have pointed at that Skill on %d seeds and at the valid Skill on %d — the seeds D-301 still answered with a new pair"
		% [SEED_SAMPLES, refused_all, drew, points_at_overweight, points_at_valid])
	print("  all %d continuations refuse — 0 new pairs, 0 rank increases, 0 exhausted, 0 partial — and reversing the arrays changed %d answers"
		% [SEED_SAMPLES, violations.size()])
	print("  %d compositions over the same state: %d refused whole at the Support lane, %d offered a new pair, %d offered a rank"
		% [SEED_SAMPLES, offers_refused, offers_new, offers_rank])
	print("  the phase advances only on the selector's empty-candidate classification: its guard precedes the rank query, and the rank guard precedes the exhaustion proof")
	_done("a_refused_new_pair_ladder_never_advances_to_the_rank_phase")


# --- 27. Every candidate ladder is validated before stage one (D-302) ---------------------------------------------------------

func _check_every_candidate_pool_is_validated_before_either_stage_draws() -> void:
	print("")
	print("--- 27. Every candidate pool's ladder is validated before stage one: no seed and no ticket reaches past a malformed pool")
	var fixture: Array = _overflow_fixture()
	var profiles: Array[SkillTagProfile] = fixture[0]
	var definitions: Array[SupportDefinition] = fixture[1]
	var held: AcquiredSupports = fixture[2]
	var expected: String = _overweight_reason(&"zz_skill_heavy")
	## EVERY STAGE-ONE TICKET THAT MATTERS, against tickets on both candidate ladders.
	## The ordinary draw has two candidate Skills, so Skill tickets 0-3 reach each twice.
	var ticket_wrong: PackedStringArray = PackedStringArray()
	var ticket_answers: int = 0
	for skill_ticket: int in 4:
		for support_ticket: int in [0, 1, 9, 10, 19, 20, SupportSelection.MAXIMUM_TOTAL_WEIGHT]:
			var result: SupportSelectionResult = SupportSelection.select_with_tickets(
				profiles, definitions, held, skill_ticket, support_ticket)
			ticket_answers += 1
			_refusals += 1
			if result.ok or result.has_no_candidates() or result.failure_reason != expected or not _no_partial_selection(result):
				ticket_wrong.append("%d/%d: %s" % [skill_ticket, support_ticket, result.describe()])
	## REVERSED ARRAYS ON EVERY SEED: neither the verdict nor the Skill it names moves.
	var reversed_profiles: Array[SkillTagProfile] = _reversed_skills(profiles)
	var reversed_definitions: Array[SupportDefinition] = _reversed_supports(definitions)
	var seed_wrong: PackedStringArray = PackedStringArray()
	for seed_value: int in SEED_SAMPLES:
		var answers: Array[SupportSelectionResult] = [
			SupportSelection.select(profiles, definitions, held, seed_value),
			SupportSelection.select(reversed_profiles, reversed_definitions, held, seed_value),
		]
		for answer: SupportSelectionResult in answers:
			_refusals += 1
			if answer.ok or answer.has_no_candidates() or answer.failure_reason != expected or not _no_partial_selection(answer):
				seed_wrong.append("seed %d: %s" % [seed_value, answer.describe()])
	## TWO MALFORMED POOLS: the refusal names the first in stable Skill-ID order, however
	## the caller ordered them. `zz_skill_brute` sorts before `zz_skill_heavy` and is
	## supplied LAST in one order and first in the other.
	var two_profiles: Array[SkillTagProfile] = profiles.duplicate()
	two_profiles.append(_profile(&"zz_skill_brute", [SkillTags.ATTACK, SkillTags.MELEE] as Array[StringName]))
	var two_reversed: Array[SkillTagProfile] = _reversed_skills(two_profiles)
	var named: Dictionary = {}
	for seed_value: int in SEED_SAMPLES:
		var answers: Array[SupportSelectionResult] = [
			SupportSelection.select(two_profiles, definitions, held, seed_value),
			SupportSelection.select(two_reversed, reversed_definitions, held, seed_value),
		]
		for answer: SupportSelectionResult in answers:
			_refusals += 1
			var key: String = answer.failure_reason if not answer.ok else "selected %s" % answer.pair()
			named[key] = int(named.get(key, 0)) + 1
	var brute_reason: String = _overweight_reason(&"zz_skill_brute")
	## STRUCTURE: each ladder is built once, by one function that reads no ticket, and
	## both draws validate every ladder before stage two's `_draw()` — which computes no
	## weight and checks no ceiling, so it cannot build a different ladder afterwards.
	var code: String = _code_only(FileAccess.get_file_as_string(SELECTION_FILE))
	var ladder: String = _function_body(code, "_ladder_problem")
	var draw: String = _function_body(code, "_draw")
	var structured: bool = ladder.length() > 200 and draw.length() > 200 \
		and code.count("effective_weight_for(") == 1 and ladder.contains("effective_weight_for(") \
		and ladder.contains("MAXIMUM_TOTAL_WEIGHT") and not ladder.contains("ticket") \
		and not draw.contains("effective_weight_for(") and not draw.contains("MAXIMUM_TOTAL_WEIGHT")
	for name: String in ["select_with_tickets", "select_rank_increase_with_tickets"]:
		var body: String = _function_body(code, name)
		structured = structured and body.count("_ladder_problem(") == 1 and body.count("_draw(") == 1 \
			and body.find("_ladder_problem(") < body.find("no_candidates_found(") \
			and body.find("no_candidates_found(") < body.find("_draw(")
	_expect(ticket_wrong.is_empty() and ticket_answers == 28,
		"%d of %d ticket pairs did not refuse the malformed pool before stage one: %s" % [
			ticket_wrong.size(), ticket_answers, "; ".join(ticket_wrong.slice(0, 3))])
	_expect(seed_wrong.is_empty(), "the verdict or the Skill it names moved with seed or order: %s" % "; ".join(seed_wrong.slice(0, 3)))
	_expect(named.size() == 1 and int(named.get(brute_reason, 0)) == SEED_SAMPLES * 2,
		"with two malformed pools the refusals named %s" % str(named))
	_expect(structured, "a ladder is built outside `_ladder_problem()`, reads a ticket, or is validated after `_draw()`")
	print("  %d Skill/support ticket pairs (Skill tickets 0-3 over both candidate Skills) and %d seeds in both array orders: every answer refuses as '%s', with no partial selection"
		% [ticket_answers, SEED_SAMPLES, expected])
	print("  with a second malformed pool supplied last and then first, %d of %d refusals name zz_skill_brute, the first in stable Skill-ID order"
		% [int(named.get(brute_reason, 0)), SEED_SAMPLES * 2])
	print("  each ladder is built once, by `_ladder_problem()`, which reads no ticket; both draws validate every ladder before `_draw()`, which computes no weight")
	_done("every_candidate_pool_is_validated_before_either_stage_draws")


# --- 28. An overweight rankable pool cannot be avoided (D-302) ----------------------------------------------------------------

func _check_an_overweight_rankable_pool_cannot_be_avoided_by_the_rank_draw() -> void:
	print("")
	print("--- 28. One Skill's rankable pool over the ceiling beside another rankable Skill: the rank draw refuses on every seed")
	var fixture: Array = _rank_overflow_fixture(1)
	var profiles: Array[SkillTagProfile] = fixture[0]
	var definitions: Array[SupportDefinition] = fixture[1]
	var held: AcquiredSupports = fixture[2]
	var reversed_profiles: Array[SkillTagProfile] = _reversed_skills(profiles)
	var reversed_definitions: Array[SupportDefinition] = _reversed_supports(definitions)
	var cards: Array[PassiveCardDefinition] = PassiveCardCatalogue.records()
	var expected: String = _overweight_reason(&"zz_skill_heavy")
	var draw_wrong: PackedStringArray = PackedStringArray()
	var points_at_valid: int = 0
	for seed_value: int in SEED_SAMPLES:
		## Stage one would point at the valid rankable Skill on odd tickets (heavy sorts first).
		if SupportSelection.skill_ticket_for(seed_value) % 2 == 1:
			points_at_valid += 1
		var answers: Array[SupportSelectionResult] = [
			SupportSelection.select_rank_increase(profiles, definitions, held, seed_value),
			SupportSelection.select_rank_increase(reversed_profiles, reversed_definitions, held, seed_value),
		]
		for answer: SupportSelectionResult in answers:
			_refusals += 1
			if answer.ok or answer.has_no_candidates() or answer.failure_reason != expected or not _no_partial_selection(answer):
				draw_wrong.append("seed %d: %s" % [seed_value, answer.describe()])
		## Every pair is held, so the NEW-PAIR set is validly empty — which is exactly what
		## lets the lane reach the rank query at all.
		var new_pair: SupportSelectionResult = SupportSelection.select(profiles, definitions, held, seed_value)
		if new_pair.ok or not new_pair.has_no_candidates():
			draw_wrong.append("seed %d new pair: %s" % [seed_value, new_pair.describe()])
	for skill_ticket: int in 4:
		for support_ticket: int in [0, 9, 10, 19, SupportSelection.MAXIMUM_TOTAL_WEIGHT]:
			var result: SupportSelectionResult = SupportSelection.select_rank_increase_with_tickets(
				profiles, definitions, held, skill_ticket, support_ticket)
			_refusals += 1
			if result.ok or result.has_no_candidates() or result.failure_reason != expected or not _no_partial_selection(result):
				draw_wrong.append("%d/%d: %s" % [skill_ticket, support_ticket, result.describe()])
	var continuation_wrong: PackedStringArray = PackedStringArray()
	var offers_refused: int = 0
	var offers_rank: int = 0
	var offers_other: int = 0
	for seed_value: int in SEED_SAMPLES:
		var continued: SupportContinuationResult = SupportContinuation.select(profiles, definitions, held, seed_value)
		var reversed: SupportContinuationResult = SupportContinuation.select(reversed_profiles, reversed_definitions, held, seed_value)
		_refusals += 1
		if continued.ok or continued.is_rank_increase() or continued.is_new_pair() or continued.is_exhausted() \
				or not continued.problem().is_empty() or continued.selection != null or not continued.pair().is_empty() \
				or not continued.failure_reason.begins_with(RANK_QUERY_REFUSES_PREFIX + expected) \
				or _full(reversed) != _full(continued):
			continuation_wrong.append("seed %d: %s" % [seed_value, continued.describe()])
		var offer: RiftOffer = RiftOfferComposition.compose(profiles, definitions, held, cards, seed_value)
		if not offer.ok and offer.refusing_lane == RiftOffer.Lane.SUPPORT and offer.problem().is_empty() \
				and offer.identity_for(RiftOffer.Lane.SUPPORT).is_empty():
			offers_refused += 1
		elif offer.ok and offer.support_progression_kind == SupportContinuationResult.Kind.RANK_INCREASE:
			offers_rank += 1
		else:
			offers_other += 1
	## EXHAUSTION IS NOT THIS. The same fixture with every pair at its maximum weighs no
	## pool at all — nothing is a candidate — and is exhausted on every seed.
	var finished: Array = _rank_overflow_fixture(FIXTURE_MAXIMUM_RANK)
	var finished_profiles: Array[SkillTagProfile] = finished[0]
	var finished_definitions: Array[SupportDefinition] = finished[1]
	var finished_held: AcquiredSupports = finished[2]
	var exhausted: int = 0
	for seed_value: int in SEED_SAMPLES:
		var result: SupportContinuationResult = SupportContinuation.select(finished_profiles, finished_definitions, finished_held, seed_value)
		if result.is_exhausted() and result.failure_reason == EXHAUSTION_REASON \
				and SupportSelection.select_rank_increase(finished_profiles, finished_definitions, finished_held, seed_value).has_no_candidates():
			exhausted += 1
	_expect(draw_wrong.is_empty() and points_at_valid > 0,
		"the rank draw reached past the malformed pool: %s" % "; ".join(draw_wrong.slice(0, 3)))
	_expect(continuation_wrong.is_empty(), "the continuation advanced, ranked or misclassified: %s" % "; ".join(continuation_wrong.slice(0, 3)))
	_expect(offers_refused == SEED_SAMPLES and offers_rank == 0 and offers_other == 0,
		"compositions: %d refused whole, %d rank, %d other" % [offers_refused, offers_rank, offers_other])
	_expect(exhausted == SEED_SAMPLES and SupportSelection.is_rank_exhausted(finished_profiles, finished_definitions, finished_held)
			and not SupportSelection.is_rank_exhausted(profiles, definitions, held),
		"exhaustion and the overweight refusal are not distinct: %d exhausted" % exhausted)
	print("  every pair held at rank 1 of 3: the new-pair set is validly empty on %d of %d seeds, and the rank draw refuses all %d in both array orders as '%s' — including the %d whose stage-one ticket points at the valid rankable Skill"
		% [SEED_SAMPLES, SEED_SAMPLES, SEED_SAMPLES, expected, points_at_valid])
	print("  %d continuations refuse — 0 rank increases, 0 new pairs, 0 exhausted, 0 partial; %d compositions refuse whole at the Support lane, %d offer a rank"
		% [SEED_SAMPLES, offers_refused, offers_rank])
	print("  the same fixture with every pair at its maximum: %d of %d seeds exhausted, no pool weighed — exhaustion and the overweight refusal stay distinct"
		% [exhausted, SEED_SAMPLES])
	_done("an_overweight_rankable_pool_cannot_be_avoided_by_the_rank_draw")


# --- 29. The ceiling is exact, and only real candidates are weighed (D-302) ---------------------------------------------------

func _check_the_ceiling_is_exact_and_only_real_candidates_are_weighed() -> void:
	print("")
	print("--- 29. A pool of exactly the ceiling is accepted and one unit more is refused before stage one; only a mode's real candidates are weighed")
	var exact: Array = _ceiling_fixture(SupportSelection.MAXIMUM_TOTAL_WEIGHT)
	var over: Array = _ceiling_fixture(SupportSelection.MAXIMUM_TOTAL_WEIGHT + 1)
	var exact_profiles: Array[SkillTagProfile] = exact[0]
	var exact_definitions: Array[SupportDefinition] = exact[1]
	var over_profiles: Array[SkillTagProfile] = over[0]
	var over_definitions: Array[SupportDefinition] = over[1]
	var exact_held: AcquiredSupports = _every_eligible(exact_profiles, exact_definitions, 1)
	var over_held: AcquiredSupports = _every_eligible(over_profiles, over_definitions, 1)

	## EXACTLY THE CEILING IS ACCEPTED, in both draws, on every seed, whichever Skill
	## stage one picks.
	var exact_wrong: PackedStringArray = PackedStringArray()
	var bulk_draws: int = 0
	for seed_value: int in SEED_SAMPLES:
		var answers: Array[SupportSelectionResult] = [
			SupportSelection.select(exact_profiles, exact_definitions, null, seed_value),
			SupportSelection.select_rank_increase(exact_profiles, exact_definitions, exact_held, seed_value),
		]
		for answer: SupportSelectionResult in answers:
			if not answer.ok:
				exact_wrong.append("seed %d: %s" % [seed_value, answer.failure_reason])
			elif answer.skill_id == &"zz_skill_bulk":
				bulk_draws += 1
				if answer.total_eligible_weight != SupportSelection.MAXIMUM_TOTAL_WEIGHT:
					exact_wrong.append("seed %d: total %d" % [seed_value, answer.total_eligible_weight])
	## The bulk ladder's segment boundaries, each owned by exactly its support. A ladder
	## of 4,294,967,295 tickets cannot be walked, so each segment's first and last
	## tickets are — a bounded claim, stated as one. The light ladder IS walked whole.
	var boundaries: int = 0
	var segment_start: int = 0
	for definition: SupportDefinition in exact_definitions:
		if not String(definition.support_id()).begins_with("zz_t_bulk_"):
			continue
		var segment_end: int = segment_start + definition.base_weight - 1
		for ticket: int in [segment_start, segment_end]:
			var answer: SupportSelectionResult = SupportSelection.select_with_tickets(exact_profiles, exact_definitions, null, 0, ticket)
			boundaries += 1
			if not answer.ok or answer.support_id != definition.support_id() or answer.rolled_ticket != ticket \
					or answer.total_eligible_weight != SupportSelection.MAXIMUM_TOTAL_WEIGHT:
				exact_wrong.append("ticket %d: %s" % [ticket, answer.describe()])
		segment_start = segment_end + 1
	var light_owned: Dictionary = {}
	for ticket: int in 20:
		var answer: SupportSelectionResult = SupportSelection.select_with_tickets(exact_profiles, exact_definitions, null, 1, ticket)
		light_owned[String(answer.support_id)] = int(light_owned.get(String(answer.support_id), 0)) + 1

	## ONE UNIT MORE IS REFUSED BEFORE STAGE ONE, in both draws, on every seed and every
	## Skill ticket — including every one that would have picked the valid Skill.
	var over_expected: String = _overweight_reason(&"zz_skill_bulk")
	var over_wrong: PackedStringArray = PackedStringArray()
	for seed_value: int in SEED_SAMPLES:
		var answers: Array[SupportSelectionResult] = [
			SupportSelection.select(over_profiles, over_definitions, null, seed_value),
			SupportSelection.select_rank_increase(over_profiles, over_definitions, over_held, seed_value),
		]
		for answer: SupportSelectionResult in answers:
			_refusals += 1
			if answer.ok or answer.has_no_candidates() or answer.failure_reason != over_expected or not _no_partial_selection(answer):
				over_wrong.append("seed %d: %s" % [seed_value, answer.describe()])
	for skill_ticket: int in 4:
		for support_ticket: int in [0, 10, SupportSelection.MAXIMUM_TOTAL_WEIGHT]:
			var answer: SupportSelectionResult = SupportSelection.select_with_tickets(over_profiles, over_definitions, null, skill_ticket, support_ticket)
			_refusals += 1
			if answer.ok or answer.failure_reason != over_expected or not _no_partial_selection(answer):
				over_wrong.append("%d/%d: %s" % [skill_ticket, support_ticket, answer.describe()])
	var exact_total: int = 0
	for definition: SupportDefinition in exact_definitions:
		if String(definition.support_id()).begins_with("zz_t_bulk_"):
			exact_total += definition.base_weight
	var over_total: int = 0
	for definition: SupportDefinition in over_definitions:
		if String(definition.support_id()).begins_with("zz_t_bulk_"):
			over_total += definition.base_weight

	## ONLY A MODE'S REAL CANDIDATES ARE WEIGHED: five supports at the per-definition
	## maximum sit beside a valid Skill in every case below, and are never a candidate.
	var heavy: SkillTagProfile = _profile(&"zz_skill_heavy", [SkillTags.ATTACK, SkillTags.MELEE] as Array[StringName])
	var light: SkillTagProfile = _profile(&"zz_skill_light", [SkillTags.SPELL, SkillTags.FIRE] as Array[StringName])
	var holder: SkillTagProfile = _profile(&"zz_skill_held", [SkillTags.ATTACK, SkillTags.PROJECTILE] as Array[StringName])
	var heavy_supports: Array[SupportDefinition] = _heavy_supports([SkillTags.MELEE] as Array[StringName])
	var stranded: Array[SupportDefinition] = _heavy_supports([SkillTags.SPELL, SkillTags.MELEE] as Array[StringName])
	var light_pairs: Array[SupportDefinition] = _ten_weight_pairs("zz_t_light_", SkillTags.FIRE)
	var held_pairs: Array[SupportDefinition] = _ten_weight_pairs("zz_t_held_", SkillTags.PROJECTILE)
	var heavy_and_light: Array[SkillTagProfile] = [heavy, light]
	var heavy_and_holder: Array[SkillTagProfile] = [heavy, holder]
	var cases: Array = [
		["new pair: every overweight pair already held", false, heavy_and_light, heavy_supports + light_pairs,
			_fabricated(_rows_for(&"zz_skill_heavy", heavy_supports, 1)), &"zz_skill_light"],
		["rank: every overweight pair not held", true, heavy_and_holder, heavy_supports + held_pairs,
			_fabricated(_rows_for(&"zz_skill_held", held_pairs, 1)), &"zz_skill_held"],
		["rank: every overweight pair at its maximum", true, heavy_and_holder, heavy_supports + held_pairs,
			_fabricated(_rows_for(&"zz_skill_heavy", heavy_supports, FIXTURE_MAXIMUM_RANK) + _rows_for(&"zz_skill_held", held_pairs, 1)), &"zz_skill_held"],
		["new pair: overweight supports eligible for no Skill", false, heavy_and_light, stranded + light_pairs,
			null, &"zz_skill_light"],
		["rank: overweight supports eligible for no Skill", true, heavy_and_light, stranded + light_pairs,
			_fabricated(_rows_for(&"zz_skill_light", light_pairs, 1)), &"zz_skill_light"],
	]
	var candidate_wrong: PackedStringArray = PackedStringArray()
	for row: Array in cases:
		var case_profiles: Array[SkillTagProfile] = row[2]
		var case_definitions: Array[SupportDefinition] = []
		case_definitions.assign(row[3])
		var case_held: AcquiredSupports = row[4]
		for seed_value: int in SEED_SAMPLES:
			var answer: SupportSelectionResult = SupportSelection.select_rank_increase(case_profiles, case_definitions, case_held, seed_value) \
				if bool(row[1]) else SupportSelection.select(case_profiles, case_definitions, case_held, seed_value)
			if not answer.ok or answer.skill_id != row[5] or answer.eligible_skill_count != 1:
				candidate_wrong.append("%s, seed %d: %s" % [row[0], seed_value, answer.describe()])
				break
	## A GENUINELY EMPTY VALID SET IS STILL CLASSIFIED, with the overweight supports present.
	var only_heavy: Array[SkillTagProfile] = [heavy]
	var empties: Array = [
		["rank: overweight pairs eligible, none held",
			SupportSelection.select_rank_increase(only_heavy, heavy_supports, null, 7)],
		["new pair: every overweight pair held",
			SupportSelection.select(only_heavy, heavy_supports, _fabricated(_rows_for(&"zz_skill_heavy", heavy_supports, 1)), 7)],
	]
	var empty_wrong: PackedStringArray = PackedStringArray()
	for row: Array in empties:
		var result: SupportSelectionResult = row[1]
		if result.ok or not result.has_no_candidates() or not result.problem().is_empty():
			empty_wrong.append("%s: %s" % [row[0], result.describe()])
	_expect(exact_wrong.is_empty() and bulk_draws > 0 and boundaries == 10
			and light_owned == {"zz_t_light_0": 10, "zz_t_light_1": 10},
		"exactly the ceiling: %s; %d bulk draws, %d boundaries, light %s" % [
			"; ".join(exact_wrong.slice(0, 3)), bulk_draws, boundaries, str(light_owned)])
	_expect(over_wrong.is_empty(), "one unit past the ceiling: %s" % "; ".join(over_wrong.slice(0, 3)))
	_expect(over_total == exact_total + 1 and exact_total == SupportSelection.MAXIMUM_TOTAL_WEIGHT,
		"the two boundary pools total %d and %d" % [exact_total, over_total])
	_expect(candidate_wrong.is_empty(), "a non-candidate collection changed a selection: %s" % "; ".join(candidate_wrong))
	_expect(empty_wrong.is_empty(), "a valid empty set was not classified: %s" % "; ".join(empty_wrong))
	print("  a pool totalling exactly %d beside a valid Skill: %d of %d draws in both modes accepted (%d landed on it, each with that total); its 5 segments own their first and last tickets (%d boundaries); the light ladder, walked whole, owns %s"
		% [exact_total, SEED_SAMPLES * 2 - exact_wrong.size(), SEED_SAMPLES * 2, bulk_draws, boundaries, str(light_owned)])
	print("  the same pool at %d (%d more): %d seeds in both modes and 12 Skill/support ticket pairs, every one refused as '%s' with no partial selection"
		% [over_total, over_total - exact_total, SEED_SAMPLES, over_expected])
	print("  %d non-candidate cases (overweight pairs held for a new pair, unheld or at their maximum for a rank, eligible for no Skill in either mode): %d disturbed a selection over %d seeds each"
		% [cases.size(), candidate_wrong.size(), SEED_SAMPLES])
	print("  %d of %d genuinely empty valid sets beside the overweight supports are still classified 'no candidates'"
		% [empties.size() - empty_wrong.size(), empties.size()])
	_done("the_ceiling_is_exact_and_only_real_candidates_are_weighed")


# --- 30. The shipped ladders are unchanged (D-302) ------------------------------------------------------------------------------

func _check_the_shipped_ladders_are_unchanged() -> void:
	print("")
	print("--- 30. The shipped 100 / 100 ladder owns exactly the tickets it always owned, in both draws")
	var profiles: Array[SkillTagProfile] = SkillSupportCatalogue.skill_profiles()
	var definitions: Array[SupportDefinition] = SkillSupportCatalogue.support_definitions()
	var modes: Array = [
		["new pair, nothing held", false, AcquiredSupports.new()],
		["rank increase, both pairs at rank 1", true, _shipped(1, 1)],
	]
	var lines: PackedStringArray = PackedStringArray()
	for mode: Array in modes:
		var held: AcquiredSupports = mode[2]
		var owned: Dictionary = {}
		var first_ticket: Dictionary = {}
		var last_ticket: Dictionary = {}
		var odd: int = 0
		## EVERY TICKET OF THE LADDER, WALKED, at every stage-one ticket that matters.
		for skill_ticket: int in 2:
			for ticket: int in SHIPPED_WEIGHT * 2:
				var result: SupportSelectionResult = SupportSelection.select_rank_increase_with_tickets(profiles, definitions, held, skill_ticket, ticket) \
					if bool(mode[1]) else SupportSelection.select_with_tickets(profiles, definitions, held, skill_ticket, ticket)
				if not result.ok or result.skill_id != QUICK_STRIKE or result.eligible_skill_count != 1 \
						or result.total_eligible_weight != SHIPPED_WEIGHT * 2 or result.rolled_ticket != ticket:
					odd += 1
					continue
				var id: String = String(result.support_id)
				owned[id] = int(owned.get(id, 0)) + 1
				if not first_ticket.has(id):
					first_ticket[id] = ticket
				last_ticket[id] = ticket
		var ok: bool = odd == 0 and owned == {String(REACHING): SHIPPED_WEIGHT * 2, String(SWEEPING): SHIPPED_WEIGHT * 2} \
			and first_ticket == {String(REACHING): 0, String(SWEEPING): SHIPPED_WEIGHT} \
			and last_ticket == {String(REACHING): SHIPPED_WEIGHT - 1, String(SWEEPING): SHIPPED_WEIGHT * 2 - 1}
		_expect(ok, "%s: owned %s, first %s, last %s, %d odd answers" % [mode[0], str(owned), str(first_ticket), str(last_ticket), odd])
		lines.append("%s: reaching_edge tickets %d-%d, sweeping_edge %d-%d of %d" % [
			mode[0], int(first_ticket.get(String(REACHING), -1)), int(last_ticket.get(String(REACHING), -1)),
			int(first_ticket.get(String(SWEEPING), -1)), int(last_ticket.get(String(SWEEPING), -1)), SHIPPED_WEIGHT * 2])
	for line: String in lines:
		print("  %s, over Skill tickets 0 and 1 — quick_strike the one candidate Skill" % line)
	_done("the_shipped_ladders_are_unchanged")


## The ordinary refusal an over-ceiling candidate pool produces, for `skill_id`.
func _overweight_reason(skill_id: StringName) -> String:
	return "the total eligible weight for %s would exceed the ceiling of %d" % [skill_id, SupportSelection.MAXIMUM_TOTAL_WEIGHT]


## True when a refused selection carries nothing that looks like a selection.
func _no_partial_selection(result: SupportSelectionResult) -> bool:
	return result.problem().is_empty() and String(result.skill_id).is_empty() and String(result.support_id).is_empty() \
		and result.total_eligible_weight == 0 and result.effective_weight == 0


func _reversed_skills(profiles: Array[SkillTagProfile]) -> Array[SkillTagProfile]:
	var out: Array[SkillTagProfile] = []
	for index: int in range(profiles.size() - 1, -1, -1):
		out.append(profiles[index])
	return out


func _reversed_supports(definitions: Array[SupportDefinition]) -> Array[SupportDefinition]:
	var out: Array[SupportDefinition] = []
	for index: int in range(definitions.size() - 1, -1, -1):
		out.append(definitions[index])
	return out


## Five supports at the per-definition maximum weight, requiring every tag given.
func _heavy_supports(required_all: Array[StringName]) -> Array[SupportDefinition]:
	var out: Array[SupportDefinition] = []
	for index: int in 5:
		out.append(_definition(StringName("zz_t_heavy_%d" % index), required_all, SupportDefinition.MAXIMUM_WEIGHT, FIXTURE_MAXIMUM_RANK))
	return out


## Two supports of weight 10 requiring `tag`, named `<prefix>0` and `<prefix>1`.
func _ten_weight_pairs(prefix: String, tag: StringName) -> Array[SupportDefinition]:
	var out: Array[SupportDefinition] = []
	for index: int in 2:
		out.append(_definition(StringName("%s%d" % [prefix, index]), [tag] as Array[StringName], 10, FIXTURE_MAXIMUM_RANK))
	return out


## `[skill, support, rank]` rows holding every one of `definitions` on `skill_id` at `rank`.
func _rows_for(skill_id: StringName, definitions: Array[SupportDefinition], rank: int) -> Array:
	var rows: Array = []
	for definition: SupportDefinition in definitions:
		rows.append([skill_id, definition.support_id(), rank])
	return rows


## THE RANK-MODE OVERFLOW FIXTURE (D-302), as `[profiles, definitions, held]`: one
## Skill whose five supports carry the per-definition maximum weight, and one Skill
## with two supports of weight 10 — every pair held at `rank`, so at rank 1 both Skills
## are rankable, nothing is new, and the first Skill's rank ladder is over the ceiling.
func _rank_overflow_fixture(rank: int) -> Array:
	var profiles: Array[SkillTagProfile] = []
	profiles.append(_profile(&"zz_skill_heavy", [SkillTags.ATTACK, SkillTags.MELEE] as Array[StringName]))
	profiles.append(_profile(&"zz_skill_held", [SkillTags.ATTACK, SkillTags.PROJECTILE] as Array[StringName]))
	var definitions: Array[SupportDefinition] = _heavy_supports([SkillTags.MELEE] as Array[StringName])
	definitions.append_array(_ten_weight_pairs("zz_t_held_", SkillTags.PROJECTILE))
	return [profiles, definitions, _every_eligible(profiles, definitions, rank)]


## Two Skills, as `[profiles, definitions]`: `zz_skill_bulk`, whose melee pool sums to
## exactly `total` in chunks of the per-definition maximum plus one remainder, and
## `zz_skill_light`, with two fire supports of weight 10.
func _ceiling_fixture(total: int) -> Array:
	var profiles: Array[SkillTagProfile] = []
	profiles.append(_profile(&"zz_skill_bulk", [SkillTags.ATTACK, SkillTags.MELEE] as Array[StringName]))
	profiles.append(_profile(&"zz_skill_light", [SkillTags.SPELL, SkillTags.FIRE] as Array[StringName]))
	var definitions: Array[SupportDefinition] = []
	var remaining: int = total
	var index: int = 0
	while remaining > 0:
		var weight: int = mini(remaining, SupportDefinition.MAXIMUM_WEIGHT)
		definitions.append(_definition(StringName("zz_t_bulk_%d" % index), [SkillTags.MELEE] as Array[StringName], weight, FIXTURE_MAXIMUM_RANK))
		remaining -= weight
		index += 1
	definitions.append_array(_ten_weight_pairs("zz_t_light_", SkillTags.FIRE))
	return [profiles, definitions]


func _profile(id: StringName, tags: Array[StringName]) -> SkillTagProfile:
	return SkillTagProfile.of(id, "Test Skill %s" % id, tags)


func _definition(id: StringName, required_all: Array[StringName], weight: int, maximum: int) -> SupportDefinition:
	return SupportDefinition.of(
		SupportEligibility.of(id, "Test Support %s" % id, required_all, [] as Array[StringName], [] as Array[StringName]),
		weight, {}, maximum)


func _one_melee_skill() -> Array[SkillTagProfile]:
	var out: Array[SkillTagProfile] = []
	out.append(_profile(SKILL_ONE, [SkillTags.ATTACK, SkillTags.HIT, SkillTags.MELEE, SkillTags.STRIKE, SkillTags.PHYSICAL] as Array[StringName]))
	return out


func _two_melee_skills() -> Array[SkillTagProfile]:
	var out: Array[SkillTagProfile] = _one_melee_skill()
	out.append(_profile(SKILL_TWO, [SkillTags.ATTACK, SkillTags.HIT, SkillTags.MELEE, SkillTags.PHYSICAL] as Array[StringName]))
	return out


func _three_mixed_skills() -> Array[SkillTagProfile]:
	var out: Array[SkillTagProfile] = _two_melee_skills()
	out.append(_profile(SKILL_THREE, [SkillTags.SPELL, SkillTags.HIT, SkillTags.FIRE] as Array[StringName]))
	return out


func _three_melee_supports(maximum: int) -> Array[SupportDefinition]:
	var out: Array[SupportDefinition] = []
	if maximum == SupportDefinition.UNDECLARED_MAXIMUM_RANK:
		for row: Array in [[SUPPORT_ALPHA, WEIGHT_ALPHA], [SUPPORT_BETA, WEIGHT_BETA], [SUPPORT_GAMMA, WEIGHT_GAMMA]]:
			out.append(SupportDefinition.of(SupportEligibility.of(row[0], "Test Support %s" % row[0],
				[SkillTags.MELEE] as Array[StringName], [] as Array[StringName], [] as Array[StringName]), int(row[1]), {}))
		return out
	out.append(_definition(SUPPORT_ALPHA, [SkillTags.MELEE] as Array[StringName], WEIGHT_ALPHA, maximum))
	out.append(_definition(SUPPORT_BETA, [SkillTags.MELEE] as Array[StringName], WEIGHT_BETA, maximum))
	out.append(_definition(SUPPORT_GAMMA, [SkillTags.MELEE] as Array[StringName], WEIGHT_GAMMA, maximum))
	return out


## Two melee supports and one fire support, each declaring `maximum`.
func _melee_and_fire_supports(maximum: int) -> Array[SupportDefinition]:
	var out: Array[SupportDefinition] = []
	out.append(_definition(SUPPORT_ALPHA, [SkillTags.MELEE] as Array[StringName], WEIGHT_ALPHA, maximum))
	out.append(_definition(SUPPORT_BETA, [SkillTags.MELEE] as Array[StringName], WEIGHT_BETA, maximum))
	out.append(_definition(SUPPORT_GAMMA, [SkillTags.FIRE] as Array[StringName], WEIGHT_GAMMA, maximum))
	return out


## The order fixture: three Skills and three supports with different maxima.
func _mixed_skills() -> Array[SkillTagProfile]:
	return _three_mixed_skills()


func _mixed_supports() -> Array[SupportDefinition]:
	var out: Array[SupportDefinition] = []
	out.append(_definition(SUPPORT_ALPHA, [SkillTags.MELEE] as Array[StringName], WEIGHT_ALPHA, 2))
	out.append(_definition(SUPPORT_BETA, [SkillTags.HIT] as Array[StringName], WEIGHT_BETA, 3))
	out.append(_definition(SUPPORT_GAMMA, [SkillTags.FIRE] as Array[StringName], WEIGHT_GAMMA, 4))
	return out


## Three states over the order fixture: one with something new, one with every pair held
## at mixed ranks (some at their maximum), and one with every pair at its maximum.
func _order_states(profiles: Array[SkillTagProfile], definitions: Array[SupportDefinition]) -> Array[AcquiredSupports]:
	var partial: AcquiredSupports = _fabricated([[SKILL_ONE, SUPPORT_ALPHA, 2], [SKILL_TWO, SUPPORT_BETA, 1]])
	var mixed: AcquiredSupports = _every_eligible(profiles, definitions, 1)
	mixed.increase_rank(SKILL_ONE, SUPPORT_ALPHA)
	mixed.increase_rank(SKILL_TWO, SUPPORT_BETA)
	mixed.increase_rank(SKILL_TWO, SUPPORT_BETA)
	var finished: AcquiredSupports = AcquiredSupports.new()
	for profile: SkillTagProfile in profiles:
		for definition: SupportDefinition in definitions:
			if definition.allows(profile):
				finished.acquire(profile.skill_id, definition.support_id())
				while finished.rank_for(profile.skill_id, definition.support_id()) < definition.maximum_rank:
					finished.increase_rank(profile.skill_id, definition.support_id())
	var out: Array[AcquiredSupports] = [partial, mixed, finished]
	return out


## The shipped pairs on the one shipped Skill at the two given ranks; 0 leaves one unheld.
func _shipped(reaching: int, sweeping: int) -> AcquiredSupports:
	return _fabricated([[QUICK_STRIKE, REACHING, reaching], [QUICK_STRIKE, SWEEPING, sweeping]])


## A record holding each `[skill, support, rank]` row; a rank of 0 or less holds nothing.
func _fabricated(rows: Array) -> AcquiredSupports:
	var record: AcquiredSupports = AcquiredSupports.new()
	for row: Array in rows:
		var rank: int = int(row[2])
		if rank <= AcquiredSupports.ABSENT_RANK:
			continue
		record.acquire(row[0] as StringName, row[1] as StringName)
		for _step: int in range(rank - AcquiredSupports.FIRST_RANK):
			record.increase_rank(row[0] as StringName, row[1] as StringName)
	return record


## Every eligible pair held at `rank`.
func _every_eligible(profiles: Array[SkillTagProfile], definitions: Array[SupportDefinition], rank: int) -> AcquiredSupports:
	var rows: Array = []
	for profile: SkillTagProfile in profiles:
		for definition: SupportDefinition in definitions:
			if definition.allows(profile):
				rows.append([profile.skill_id, definition.support_id(), rank])
	return _fabricated(rows)


## THE REPORTED EDGE CASE (D-301), as `[profiles, definitions, held]`: one Skill whose
## five supports carry the per-definition maximum weight, so its new-pair ladder is over
## the stream-width ceiling; one Skill whose two pairs are held below their maximum, so a
## rank is available; and one Skill with two new compatible pairs.
func _overflow_fixture() -> Array:
	var profiles: Array[SkillTagProfile] = []
	profiles.append(_profile(&"zz_skill_heavy", [SkillTags.ATTACK, SkillTags.MELEE] as Array[StringName]))
	profiles.append(_profile(&"zz_skill_held", [SkillTags.ATTACK, SkillTags.PROJECTILE] as Array[StringName]))
	profiles.append(_profile(&"zz_skill_light", [SkillTags.SPELL, SkillTags.FIRE] as Array[StringName]))
	var definitions: Array[SupportDefinition] = []
	for index: int in 5:
		definitions.append(_definition(StringName("zz_t_heavy_%d" % index), [SkillTags.MELEE] as Array[StringName],
			SupportDefinition.MAXIMUM_WEIGHT, FIXTURE_MAXIMUM_RANK))
	for index: int in 2:
		definitions.append(_definition(StringName("zz_t_held_%d" % index), [SkillTags.PROJECTILE] as Array[StringName], 10, FIXTURE_MAXIMUM_RANK))
		definitions.append(_definition(StringName("zz_t_light_%d" % index), [SkillTags.FIRE] as Array[StringName], 10, FIXTURE_MAXIMUM_RANK))
	var held: AcquiredSupports = _fabricated([[&"zz_skill_held", &"zz_t_held_0", 1], [&"zz_skill_held", &"zz_t_held_1", 1]])
	return [profiles, definitions, held]


## The continuation at the first seed whose stage-one ticket points at the
## over-ceiling Skill — the first stage sorts it first of the two Skills with
## something new. Since D-302 every seed refuses the fixture before stage one; this
## seed is kept so check 17's case is unchanged.
func _overflow_case() -> SupportContinuationResult:
	var fixture: Array = _overflow_fixture()
	var profiles: Array[SkillTagProfile] = fixture[0]
	var definitions: Array[SupportDefinition] = fixture[1]
	var held: AcquiredSupports = fixture[2]
	for seed_value: int in SEED_SEARCH_LIMIT:
		if SupportSelection.skill_ticket_for(seed_value) % 2 == 0:
			return SupportContinuation.select(profiles, definitions, held, seed_value)
	return null


# --- Plumbing ------------------------------------------------------------------------------------------------------------

func _walk(profiles: Array[SkillTagProfile], definitions: Array[SupportDefinition], held: AcquiredSupports, total: int) -> Array[StringName]:
	var out: Array[StringName] = []
	for ticket: int in total:
		out.append(SupportSelection.select_rank_increase_with_tickets(profiles, definitions, held, 0, ticket).support_id)
	return out


func _count(owners: Array[StringName]) -> Dictionary:
	var counts: Dictionary = {}
	for owner: StringName in owners:
		counts[owner] = int(counts.get(owner, 0)) + 1
	return counts


func _count_line(counts: Dictionary) -> String:
	var parts: PackedStringArray = PackedStringArray()
	for key: String in _sorted_keys(counts):
		parts.append("%s %d" % [key, int(counts[StringName(key)] if counts.has(StringName(key)) else counts[key])])
	return ", ".join(parts)


func _sorted_keys(values: Dictionary) -> PackedStringArray:
	var out: PackedStringArray = PackedStringArray()
	for key: Variant in values:
		out.append(String(key))
	out.sort()
	return out


func _shape_lines(shapes: Dictionary) -> PackedStringArray:
	var out: PackedStringArray = PackedStringArray()
	for shape: String in _sorted_keys(shapes):
		out.append("%d x [%s]" % [int(shapes[shape]), shape])
	return out


func _kind_of(result: SupportContinuationResult) -> String:
	if result.is_new_pair():
		return "new pair"
	if result.is_rank_increase():
		return "rank increase"
	if result.is_exhausted():
		return "exhausted"
	return "refused"


func _signature(selection: SupportSelectionResult) -> String:
	if selection == null:
		return "<no selection>"
	return "ok=%s no_candidates=%s skill=%s support=%s skill_ticket=%d of %d ticket=%d of %d base=%d effective=%d bonuses=%s reason=%s" % [
		selection.ok, selection.no_candidates, selection.skill_id, selection.support_id, selection.skill_ticket,
		selection.eligible_skill_count, selection.rolled_ticket, selection.total_eligible_weight, selection.base_weight,
		selection.effective_weight, selection.matched_bonuses, selection.failure_reason,
	]


func _full(result: SupportContinuationResult) -> String:
	if result == null:
		return "<null>"
	return "ok=%s kind=%d skill=%s support=%s held=%s exhausted=%s reason=%s | %s" % [
		result.ok, result.kind, result.skill_id, result.support_id, result.held_when_classified,
		result.exhausted, result.failure_reason, _signature(result.selection),
	]


func _script_fields(object: Object) -> PackedStringArray:
	var out: PackedStringArray = PackedStringArray()
	for entry: Dictionary in object.get_property_list():
		if int(entry.get("usage", 0)) & PROPERTY_USAGE_SCRIPT_VARIABLE != 0:
			out.append(String(entry.get("name", "")))
	return out


func _action_count() -> int:
	var actions: int = 0
	for action: StringName in InputMap.get_actions():
		if String(action).begins_with("ui_") and not String(action) in ["ui_confirm", "ui_cancel"]:
			continue
		actions += 1
	return actions


func _canonical_hashes() -> Dictionary:
	var out: Dictionary = {}
	for path: String in _files_under(CANONICAL_DATA_ROOT, [".tres"]):
		out[path] = FileAccess.get_sha256(path)
	return out


## Every line that is not a whole-line comment, string literals emptied and trailing
## comments removed — the same reading the I4 suite uses.
func _code_only(source: String) -> String:
	var kept: PackedStringArray = PackedStringArray()
	for line: String in source.split("\n"):
		if line.strip_edges().begins_with("#"):
			continue
		kept.append(line)
	var strings: RegEx = RegEx.create_from_string("\"([^\"\\\\]|\\\\.)*\"")
	var emptied: String = strings.sub("\n".join(kept), "\"\"", true)
	var trailing: RegEx = RegEx.create_from_string("(?m)\\s#.*$")
	return trailing.sub(emptied, "", true)


## The indented body of top-level function `name`, up to the next unindented line.
func _function_body(source: String, name: String) -> String:
	var body: PackedStringArray = PackedStringArray()
	var inside: bool = false
	for line: String in source.split("\n"):
		if line.begins_with("func %s(" % name) or line.begins_with("static func %s(" % name):
			inside = true
			continue
		if inside:
			if not line.is_empty() and not line.begins_with("\t") and not line.begins_with(" ") \
					and not line.begins_with(")"):
				break
			body.append(line)
	return "\n".join(body)


func _numeric_literals(code: String) -> PackedStringArray:
	var pattern: RegEx = RegEx.create_from_string("(?<![A-Za-z_0-9.])[0-9]+(?:\\.[0-9]+)?(?![A-Za-z_0-9.])")
	var found: PackedStringArray = PackedStringArray()
	for match: RegExMatch in pattern.search_all(code):
		if not found.has(match.get_string()):
			found.append(match.get_string())
	return found


func _files_under(start: String, extensions: Array[String]) -> PackedStringArray:
	var out: PackedStringArray = PackedStringArray()
	var dir: DirAccess = DirAccess.open(start)
	if dir == null:
		return out
	dir.list_dir_begin()
	var entry: String = dir.get_next()
	while not entry.is_empty():
		if entry != "." and entry != "..":
			var full: String = start.path_join(entry)
			if dir.current_is_dir():
				out.append_array(_files_under(full, extensions))
			else:
				for extension: String in extensions:
					if entry.ends_with(extension):
						out.append(full)
						break
		entry = dir.get_next()
	dir.list_dir_end()
	return out


func _check_every_check_ran() -> void:
	print("")
	print("--- Every check this suite owes actually reached its last line")
	var missing: PackedStringArray = PackedStringArray()
	for owed: String in OWED_CHECKS:
		if not _reached.has(owed):
			missing.append(owed)
	var extra: PackedStringArray = PackedStringArray()
	for ran: Variant in _reached:
		if not OWED_CHECKS.has(String(ran)):
			extra.append(String(ran))
	_expect(missing.is_empty(), "check(s) never completed: %s" % ", ".join(missing))
	_expect(extra.is_empty(), "check(s) ran that the suite does not owe: %s" % ", ".join(extra))
	print("  %d of %d owed checks completed" % [_reached.size(), OWED_CHECKS.size()])


func _expect(condition: bool, failure_message: String) -> void:
	_checks += 1
	if not condition:
		_failures.append(failure_message)


func _done(check_name: String) -> void:
	_reached[check_name] = true
