extends SceneTree
## Riftwrought — Roguelite Foundation I6 verification: Deterministic
## Exhausted-Support Passive Fallback Selection (decision D-304).
##
## ONE FOCUSED HEADLESS TEST, run as a `SceneTree` script exactly as every earlier
## foundation's suite is. The foundation is two pure-logic scripts under
## `scripts/fallback/` and a narrow extension of the accepted passive selector, so
## it needs no scene, no camera, no rendering and no evidence frame.
##
## IT PORTS D-211's OWED-SET DISCIPLINE: every check records reaching its LAST
## line, and the set is compared with what the suite owes in both directions.
##
## EVERY EXACT-OWNERSHIP CLAIM WALKS A COMPLETE TICKET LADDER. Nothing here proves
## a distribution by sampling one; seeds appear only as reproduction pins.
##
## THE EXPECTED ANSWERS ARE TYPED HERE, NOT READ FROM WHAT IS CHECKED — the pools,
## their order, the stage domains and the seed corpus. The corpus was computed by
## an independent re-implementation of the mixer OUTSIDE the engine before it was
## pinned, so it is not the code agreeing with itself.
##
## THE TEST DATA IS NOT CONTENT. Every fabricated card, Skill profile and forged
## result below lives in this file only and is not canon.

const FALLBACK_FILE: String = "res://scripts/fallback/support_exhaustion_passive_fallback.gd"
const RESULT_FILE: String = "res://scripts/fallback/support_exhaustion_passive_fallback_result.gd"
const SELECTOR_FILE: String = "res://scripts/stats/passive_card_selection.gd"
const NEW_FILES: Array[String] = [FALLBACK_FILE, RESULT_FILE]
const NEW_CLASSES: Array[String] = [
	"SupportExhaustionPassiveFallback", "SupportExhaustionPassiveFallbackResult",
]

const COMBAT: int = PlayerStatDefinition.Category.COMBAT_DEFENCE
const UTILITY: int = PlayerStatDefinition.Category.UTILITY

const CELERITY: StringName = &"card_celerity"
const POWER: StringName = &"card_power"
const VITALITY: StringName = &"card_vitality"
const FLEETNESS: StringName = &"card_fleetness"
const INSIGHT: StringName = &"card_insight"
const MAGNETISM: StringName = &"card_magnetism"

const QUICK_STRIKE: StringName = &"quick_strike"
const REACHING: StringName = &"reaching_edge"
const SWEEPING: StringName = &"sweeping_edge"

## The accepted exhaustion reason (D-300), pinned so an unchanged continuation is
## a measurement rather than an assumption.
const EXHAUSTION_REASON: String = "the support lane is exhausted: every compatible support pair is already held at its maximum supported rank, so nothing new can be selected and nothing held can be raised"

## The two stage domains, typed independently of the mechanism.
const EXPECTED_CATEGORY_STAGE_DOMAIN: int = 0xA54FF53A
const EXPECTED_CARD_STAGE_DOMAIN: int = 0x510E527F
## The three accepted offer lane domains (D-240) and the accepted stream salts —
## the passive category salt and Foundation B's two — none of which a stage
## domain, or a stage domain combined with the stream it is read through, may be.
const LANE_DOMAINS: Array[int] = [0x6A09E667, 0xBB67AE85, 0x3C6EF372]
const STREAM_SALTS: Array[int] = [0x9E3779B9, 0x85EBCA6B]

## seed, category, card, raw category ticket, raw card ticket — for the shipped
## Celerity / Fleetness example. COMPUTED OUTSIDE THE ENGINE by an independent
## re-implementation of the mixer, the passive stream and the two domains, then
## frozen. A regression pin, not a proof of correctness: correctness lives in the
## complete ladder walks.
const FALLBACK_CORPUS: Array = [
	[0, 0, "card_vitality", 2866402716, 3547293528],
	[1, 0, "card_vitality", 1946084486, 3514825132],
	[7, 0, "card_vitality", 2219703732, 3828343556],
	[18, 0, "card_vitality", 3906530272, 3156865968],
	[42, 0, "card_power", 3107081432, 2710349279],
	[12345, 0, "card_vitality", 621949274, 2264060774],
	[99991, 1, "card_magnetism", 3350234659, 1201812941],
	[2147483647, 1, "card_magnetism", 1721338091, 3198775505],
	[-1, 1, "card_insight", 1422448907, 3389027081],
	[-12345, 1, "card_magnetism", 2758721149, 2793457760],
	[1000000007, 0, "card_vitality", 2559881116, 2738652574],
	[9223372036854775807, 1, "card_insight", 1422448907, 3389027081],
	[51507111, 0, "card_power", 3141935186, 1617272035],
	[257, 0, "card_vitality", 3835553122, 46157700],
	[263, 1, "card_insight", 173116513, 3760429290],
	[4294967295, 1, "card_insight", 1422448907, 3389027081],
	[4294967296, 0, "card_vitality", 2866402716, 3547293528],
]

## Foundation C3's frozen corpus, copied verbatim (D-234): seed, combat card,
## combat ticket, utility card, utility ticket.
const C3_CORPUS: Array = [
	[0, "card_vitality", 294, "card_insight", 110],
	[1, "card_vitality", 296, "card_fleetness", 14],
	[3, "card_celerity", 92, "card_fleetness", 72],
	[4, "card_celerity", 25, "card_magnetism", 292],
	[5, "card_power", 182, "card_magnetism", 254],
	[7, "card_vitality", 274, "card_fleetness", 95],
	[42, "card_vitality", 212, "card_insight", 160],
	[12345, "card_power", 173, "card_insight", 105],
	[99991, "card_vitality", 280, "card_insight", 129],
	[2147483647, "card_vitality", 291, "card_magnetism", 207],
	[-1, "card_celerity", 21, "card_insight", 165],
	[-12345, "card_power", 143, "card_fleetness", 10],
	[1000000007, "card_vitality", 242, "card_fleetness", 64],
	[9223372036854775807, "card_celerity", 21, "card_insight", 165],
	[257, "card_celerity", 48, "card_magnetism", 266],
	[259, "card_celerity", 36, "card_insight", 161],
	[261, "card_vitality", 214, "card_insight", 188],
	[263, "card_celerity", 51, "card_insight", 145],
	[265, "card_celerity", 62, "card_fleetness", 86],
]

## The six shipped records, typed: id, stat, magnitude. Every one weighs 100 and
## is repeatable.
const SHIPPED_CARDS: Array = [
	["card_power", "global_damage", 0.10], ["card_celerity", "skill_speed", 0.10],
	["card_vitality", "maximum_life", 0.15], ["card_fleetness", "movement_speed", 0.10],
	["card_insight", "experience_gain", 0.10], ["card_magnetism", "pickup_radius", 0.25],
]

## Accepted production files this work must not have touched, by the SHA-256
## prefix each held at the start of D-304 (and, for the I5 files, at D-303).
const ACCEPTED_HASHES: Array = [
	["res://scripts/skills/support_definition.gd", "53fe8521"],
	["res://scripts/skills/support_selection.gd", "7c4d8e3b"],
	["res://scripts/skills/support_selection_result.gd", "ad7bcec3"],
	["res://scripts/skills/skill_support_catalogue.gd", "a94f61cc"],
	["res://scripts/skills/acquired_supports.gd", "aad88e92"],
	["res://scripts/skills/skill_tag_profile.gd", "e8db91d3"],
	["res://scripts/skills/skill_tags.gd", "82b3a27d"],
	["res://scripts/skills/support_eligibility.gd", "f8336a9e"],
	["res://scripts/continuation/support_continuation.gd", "c815ad5d"],
	["res://scripts/continuation/support_continuation_result.gd", "68c8811d"],
	## Roguelite Foundation I7 (D-306) composes this fallback into the offer, so these two rows
	## moved one for one from D-304's `ce297469` and `d88fa954` to the D-306 files. Same count.
	["res://scripts/offers/rift_offer.gd", "9bc94208"],
	["res://scripts/offers/rift_offer_composition.gd", "15ef203a"],
	## Roguelite Foundation I8 (D-308): the two choice files moved one for one from
	## `4946603e` and `94285b22` to the D-308 files. Same count.
	["res://scripts/choices/rift_offer_choice.gd", "533ee30f"],
	["res://scripts/choices/rift_offer_choice_result.gd", "f051a955"],
	["res://scripts/choices/rift_consumption_ledger.gd", "f990eab7"],
	## Roguelite I10 (D-312) gives the one-level coordinator two readings of the standing
	## offer, so this row moved one for one from `bbba1a71` to the D-312 file. Same count.
	["res://scripts/levels/rift_level_up_coordinator.gd", "f178c358"],
	## Roguelite Foundation I9 (D-310) extends the level-up receipt to record a consumed
	## fallback, so this row moved one for one from `0f2e4a86` to the D-310 file. Same count.
	["res://scripts/levels/rift_level_up_result.gd", "2d67cee9"],
	["res://scripts/runs/rift_run_build.gd", "1920ae25"],
	["res://scripts/stats/passive_card_definition.gd", "c64dcaf4"],
	["res://scripts/stats/passive_card_catalogue.gd", "278b30dc"],
	["res://scripts/stats/passive_card_selection_result.gd", "05a74cb3"],
	## Roguelite I13 (D-318) made Global Damage live through the seam and its result, so these
	## two rows moved one for one from `1aa00c5f` and `b6b6d1ee` to the D-318 files, and Roguelite I14 (D-320), making Maximum Life live, to the D-320 files. Same count.
	["res://scripts/roguelite/live_effects/rift_build_application.gd", "c7b9df38"],
	## Roguelite I14's correction (D-321) moved the result once more, from `73d445f7`, for its
	## describe() diagnostic. Same count.
	["res://scripts/roguelite/live_effects/rift_build_application_result.gd", "2fd01f80"],
	["res://project.godot", "55351038"],
]

const EXPECTED_FALLBACK_METHODS: Array[String] = [
	"select", "select_with_tickets", "category_ticket_for", "card_ticket_for",
	"_activation_problem", "_lane_problem",
]
const EXPECTED_RESULT_METHODS: Array[String] = [
	"failed", "fallback_unavailable", "chosen", "is_unavailable",
	"candidate_categories", "excluded_card_ids", "selection", "category_for_ticket",
	"problem", "describe",
]
const EXPECTED_RESULT_FIELDS: Array[String] = [
	"ok", "failure_reason", "unavailable", "selected_category", "selected_card_id",
	"category_ticket", "card_ticket", "normalized_category_ticket",
	"_candidate_categories", "_excluded_card_ids", "_selection",
]
const EXPECTED_SELECTOR_METHODS: Array[String] = [
	"select", "select_with_ticket", "select_with_ticket_excluding", "records_problem",
	"ticket_for", "_mix", "_sorted_records",
]

## Every project class each new file names, EXACTLY, derived from the engine's
## own global class list. Substrings are honest: a file naming a result is also
## reported as naming the class whose name that result's name contains.
const EXPECTED_NAMED_CLASSES: Array = [
	[FALLBACK_FILE, [
		"PassiveCardDefinition", "PassiveCardSelection", "PassiveCardSelectionResult",
		"PlayerStatDefinition", "SupportContinuation", "SupportContinuationResult",
		"SupportExhaustionPassiveFallback", "SupportExhaustionPassiveFallbackResult",
	]],
	[RESULT_FILE, [
		"PassiveCardSelection", "PassiveCardSelectionResult",
		"SupportExhaustionPassiveFallback", "SupportExhaustionPassiveFallbackResult",
	]],
]

## Concrete names neither new file may hold, RAW, comments included (D-215).
const CONCRETE_TOKENS: Array[String] = [
	"card_power", "card_celerity", "card_vitality", "card_fleetness", "card_insight",
	"card_magnetism", "Celerity", "Vitality", "Fleetness", "Insight", "Magnetism",
	"quick_strike", "QuickStrike", "Quick Strike", "reaching_edge", "Reaching Edge",
	"sweeping_edge", "Sweeping Edge", "PassiveCardCatalogue", "SkillSupportCatalogue",
	"Graveblade", "Riftmarked",
]

## What a pure mechanism may not read, RAW.
const AMBIENT_TOKENS: Array[String] = [
	"randi", "randf", "randomize", "RandomNumberGenerator", "rand_from_seed",
	"Time.", "OS.", "Engine.", "ProjectSettings", "InputMap", "FileAccess",
	"DirAccess", "ConfigFile", "ResourceSaver", "ResourceLoader", "user://", "get_tree(",
]

## Card fields and ladder machinery neither new file may touch IN CODE: the
## weights, the ceiling, the mixer and the card's own facts belong to the accepted
## selector and the card record.
const CODE_FORBIDDEN_TOKENS: Array[String] = [
	"base_weight", "magnitude", "stat_id", "display_name", "repeatable", "effect_line",
	"MAXIMUM_TOTAL_WEIGHT", "_mix(", "0x7FEB", "0x846C",
]

## Ladder internals the MECHANISM may not read: it delegates the draw whole.
const MECHANISM_FORBIDDEN_TOKENS: Array[String] = [
	"candidate_weights", "total_weight", "normalized_ticket", "card_for_ticket",
]

## The accepted suites whose allowlists I6 moved, and the path each must now grant.
const GRANTING_SUITES: Array = [
	["res://tests/player_stat_vocabulary_verification.gd", "C1", [FALLBACK_FILE]],
	["res://tests/passive_card_records_verification.gd", "C2", [FALLBACK_FILE]],
	["res://tests/passive_card_selection_verification.gd", "C3", [FALLBACK_FILE, RESULT_FILE]],
	["res://tests/support_continuation_verification.gd", "F2", [FALLBACK_FILE]],
]
const I5_SUITE: String = "res://tests/maximum_rank_support_filtering_verification.gd"

## THE TWO RUNNING FILES GRANTED THIS FALLBACK'S CLASSES SINCE ROGUELITE FOUNDATION I7
## (D-306): the offer composer calls the fallback for an exhausted Support lane, and the
## offer holds its result. "Nothing runs it" became "only the offer composition runs it",
## one for one, in the same single assertion.
const COMPOSING_READERS: Array[String] = [
	"res://scripts/offers/rift_offer.gd", "res://scripts/offers/rift_offer_composition.gd",
]

const SCANNED_ROOTS: Array[String] = [
	"res://scripts", "res://scenes", "res://data", "res://addons",
]
const PROJECT_SETTINGS_FILE: String = "res://project.godot"
const ENTRYPOINT: String = "res://scenes/app/prototype_app.tscn"
const EXPECTED_ACTIONS: int = 31

const SEED_SAMPLES: int = 64
const REPEAT_CALLS: int = 100

const OWED_CHECKS: Array[String] = [
	"the_shipped_celerity_and_fleetness_example",
	"a_coherent_support_exhaustion_activates_the_fallback",
	"a_support_decision_or_ordinary_refusal_never_activates",
	"invalid_or_forged_support_state_cannot_masquerade_as_exhaustion",
	"missing_incoherent_or_refused_passive_sources_refuse_whole",
	"a_swapped_pair_of_sources_is_refused_not_repaired",
	"offered_cards_must_be_supplied_filed_correctly_and_distinct",
	"every_supplied_record_is_validated_before_exclusion",
	"the_offered_cards_own_zero_tickets_and_are_never_returned",
	"category_ownership_is_equal_whatever_the_catalogue_depth",
	"card_ownership_follows_the_accepted_integer_weights",
	"order_tags_and_presentation_names_change_nothing",
	"duplicated_records_refuse_rather_than_bias",
	"the_weight_ceiling_is_inherited_from_the_accepted_selector",
	"one_available_category_owns_every_category_ticket",
	"no_remaining_card_is_an_explicit_fallback_unavailable",
	"unavailable_malformed_and_support_exhaustion_are_mechanically_distinct",
	"seeded_answers_reproduce_through_the_pure_core_and_a_frozen_corpus",
	"public_collections_are_copies",
	"the_selector_extension_changes_no_ordinary_selection",
	"support_continuation_and_exhaustion_are_unchanged",
	"the_fallback_is_generic_stateless_and_unwired",
]

var _failures: PackedStringArray = PackedStringArray()
var _checks: int = 0
var _reached: Dictionary = {}
var _refusals: int = 0


func _initialize() -> void:
	print("")
	print("=== Roguelite Foundation I6 — Deterministic Exhausted-Support Passive Fallback (D-304) ===")

	_check_the_shipped_celerity_and_fleetness_example()
	_check_a_coherent_support_exhaustion_activates_the_fallback()
	_check_a_support_decision_or_ordinary_refusal_never_activates()
	_check_invalid_or_forged_support_state_cannot_masquerade_as_exhaustion()
	_check_missing_incoherent_or_refused_passive_sources_refuse_whole()
	_check_a_swapped_pair_of_sources_is_refused_not_repaired()
	_check_offered_cards_must_be_supplied_filed_correctly_and_distinct()
	_check_every_supplied_record_is_validated_before_exclusion()
	_check_the_offered_cards_own_zero_tickets_and_are_never_returned()
	_check_category_ownership_is_equal_whatever_the_catalogue_depth()
	_check_card_ownership_follows_the_accepted_integer_weights()
	_check_order_tags_and_presentation_names_change_nothing()
	_check_duplicated_records_refuse_rather_than_bias()
	_check_the_weight_ceiling_is_inherited_from_the_accepted_selector()
	_check_one_available_category_owns_every_category_ticket()
	_check_no_remaining_card_is_an_explicit_fallback_unavailable()
	_check_unavailable_malformed_and_support_exhaustion_are_mechanically_distinct()
	_check_seeded_answers_reproduce_through_the_pure_core_and_a_frozen_corpus()
	_check_public_collections_are_copies()
	_check_the_selector_extension_changes_no_ordinary_selection()
	_check_support_continuation_and_exhaustion_are_unchanged()
	_check_the_fallback_is_generic_stateless_and_unwired()

	_check_every_check_ran()

	print("")
	print("  %d refusals were driven across this suite" % _refusals)
	if _failures.is_empty():
		print("SUPPORT EXHAUSTION PASSIVE FALLBACK VERIFICATION: PASS (%d checks)" % _checks)
		quit(0)
	else:
		for failure: String in _failures:
			printerr("  FAIL: %s" % failure)
		printerr("SUPPORT EXHAUSTION PASSIVE FALLBACK VERIFICATION: %d FAILURE(S) of %d checks" % [
			_failures.size(), _checks,
		])
		quit(1)


# --- 0. The shipped example --------------------------------------------------------------------------------------

func _check_the_shipped_celerity_and_fleetness_example() -> void:
	print("")
	print("--- 0. The shipped example: the offer already carries Celerity and Fleetness")
	var cards: Array[PassiveCardDefinition] = _cards()
	var combat: PassiveCardSelectionResult = _source(cards, COMBAT, 0)
	var utility: PassiveCardSelectionResult = _source(cards, UTILITY, 0)
	var exhausted: SupportContinuationResult = _exhausted()
	_expect(combat.ok and combat.selected_card_id == CELERITY and combat.total_weight == 300
			and utility.ok and utility.selected_card_id == FLEETNESS and utility.total_weight == 300,
		"the sources read %s and %s" % [combat.describe(), utility.describe()])
	_expect(exhausted.is_exhausted() and exhausted.problem().is_empty(),
		"the shipped R2 S2 continuation reads %s" % exhausted.describe())

	var owners: Dictionary = {}
	var by_category: Dictionary = {}
	var ladders: Dictionary = {}
	var ladder_orders: Dictionary = {}
	var refused: int = 0
	var incoherent: int = 0
	for category_ticket: int in 2:
		for card_ticket: int in 200:
			var result: SupportExhaustionPassiveFallbackResult = SupportExhaustionPassiveFallback.select_with_tickets(
				exhausted, combat, utility, cards, category_ticket, card_ticket)
			if not result.ok:
				refused += 1
				continue
			if not result.problem().is_empty():
				incoherent += 1
			_count(owners, String(result.selected_card_id))
			_count(by_category, result.selected_category)
			ladders[result.selected_category] = result.selection().ladder_line()
			ladder_orders[str(result.candidate_categories())] = true
	_expect(refused == 0 and incoherent == 0, "%d refused and %d incoherent of 400" % [refused, incoherent])
	_expect(int(owners.get("card_power", 0)) == 100 and int(owners.get("card_vitality", 0)) == 100
			and int(owners.get("card_insight", 0)) == 100 and int(owners.get("card_magnetism", 0)) == 100
			and owners.size() == 4,
		"the grid's owners are %s" % owners)
	_expect(int(owners.get("card_celerity", 0)) == 0 and int(owners.get("card_fleetness", 0)) == 0,
		"an offered card owned tickets: %s" % owners)
	_expect(String(ladders.get(COMBAT, "")) == "card_power x100, card_vitality x100"
			and String(ladders.get(UTILITY, "")) == "card_insight x100, card_magnetism x100",
		"the fallback ladders are %s" % ladders)
	_expect(ladder_orders.size() == 1 and ladder_orders.has(str([COMBAT, UTILITY]))
			and int(by_category.get(COMBAT, 0)) == 200 and int(by_category.get(UTILITY, 0)) == 200,
		"the category ladder read %s with ownership %s" % [ladder_orders.keys(), by_category])

	var boundaries: Array = [
		[0, 0, POWER], [0, 99, POWER], [0, 100, VITALITY], [0, 199, VITALITY],
		[1, 0, INSIGHT], [1, 99, INSIGHT], [1, 100, MAGNETISM], [1, 199, MAGNETISM],
		[2, 200, POWER], [3, 299, INSIGHT], [5, 399, MAGNETISM],
	]
	var wrong: PackedStringArray = PackedStringArray()
	for row: Array in boundaries:
		var result: SupportExhaustionPassiveFallbackResult = SupportExhaustionPassiveFallback.select_with_tickets(
			exhausted, combat, utility, cards, int(row[0]), int(row[1]))
		if not result.ok or result.selected_card_id != (row[2] as StringName):
			wrong.append("(%d, %d) -> %s" % [int(row[0]), int(row[1]), result.selected_card_id])
	_expect(wrong.is_empty(), "boundaries moved: %s" % ", ".join(wrong))

	print("  sources: Combat and Defence card_celerity (tickets 0-99 of 300), Utility card_fleetness (tickets 0-99 of 300); the support lane exhausted: %s"
		% exhausted.is_exhausted())
	print("  fallback candidates: Combat and Defence [%s] | Utility [%s]; category ladder %s: position 0 Combat and Defence, position 1 Utility"
		% [ladders.get(COMBAT, ""), ladders.get(UTILITY, ""), str([COMBAT, UTILITY])])
	print("  400 fallbacks over the complete grid (2 category x 200 card tickets): %s; card_celerity %d, card_fleetness %d; Combat and Defence %d, Utility %d"
		% [_owner_line(owners), int(owners.get("card_celerity", 0)), int(owners.get("card_fleetness", 0)),
			int(by_category.get(COMBAT, 0)), int(by_category.get(UTILITY, 0))])
	print("  category ticket 0 -> Combat and Defence, 1 -> Utility; card tickets 0-99 -> card_power / card_insight, 100-199 -> card_vitality / card_magnetism; %d of %d typed boundaries hold"
		% [boundaries.size() - wrong.size(), boundaries.size()])
	_done("the_shipped_celerity_and_fleetness_example")


# --- 1. Activation ---------------------------------------------------------------------------------------------------

func _check_a_coherent_support_exhaustion_activates_the_fallback() -> void:
	print("")
	print("--- 1. A coherent Support-exhausted continuation activates the fallback")
	var cards: Array[PassiveCardDefinition] = _cards()
	var combat: PassiveCardSelectionResult = _source(cards, COMBAT, 0)
	var utility: PassiveCardSelectionResult = _source(cards, UTILITY, 0)
	var profiles: Array[SkillTagProfile] = SkillSupportCatalogue.skill_profiles()
	var definitions: Array[SupportDefinition] = SkillSupportCatalogue.support_definitions()
	var held: AcquiredSupports = _shipped(2, 2)
	var activated: int = 0
	var exhausted_seen: int = 0
	for seed_value: int in SEED_SAMPLES:
		var continuation: SupportContinuationResult = SupportContinuation.select(profiles, definitions, held, seed_value)
		if continuation.is_exhausted():
			exhausted_seen += 1
		var result: SupportExhaustionPassiveFallbackResult = SupportExhaustionPassiveFallback.select(
			continuation, combat, utility, cards, seed_value)
		if result.ok and result.problem().is_empty():
			activated += 1
	_expect(exhausted_seen == SEED_SAMPLES and activated == SEED_SAMPLES,
		"%d of %d continuations exhausted, %d fallbacks activated" % [exhausted_seen, SEED_SAMPLES, activated])
	## The activation reads the classification itself: a record built by the accepted
	## exhaustion constructor activates exactly as the one the continuation returned.
	var constructed: SupportContinuationResult = SupportContinuationResult.exhaustion("")
	var from_constructor: SupportExhaustionPassiveFallbackResult = SupportExhaustionPassiveFallback.select_with_tickets(
		constructed, combat, utility, cards, 0, 0)
	var from_continuation: SupportExhaustionPassiveFallbackResult = SupportExhaustionPassiveFallback.select_with_tickets(
		_exhausted(), combat, utility, cards, 0, 0)
	_expect(from_constructor.ok and _derivation(from_constructor) == _derivation(from_continuation),
		"the constructed exhaustion answered %s" % from_constructor.describe())
	print("  %d of %d shipped R2 S2 continuations exhausted and %d of %d fallbacks activated; a record from the accepted exhaustion constructor activates identically"
		% [exhausted_seen, SEED_SAMPLES, activated, SEED_SAMPLES])
	_done("a_coherent_support_exhaustion_activates_the_fallback")


# --- 2. Decisions and ordinary refusals --------------------------------------------------------------------------------

func _check_a_support_decision_or_ordinary_refusal_never_activates() -> void:
	print("")
	print("--- 2. A new pair, a rank increase or an ordinary Support refusal never activates the fallback")
	var cards: Array[PassiveCardDefinition] = _cards()
	var combat: PassiveCardSelectionResult = _source(cards, COMBAT, 0)
	var utility: PassiveCardSelectionResult = _source(cards, UTILITY, 0)
	var profiles: Array[SkillTagProfile] = SkillSupportCatalogue.skill_profiles()
	var definitions: Array[SupportDefinition] = SkillSupportCatalogue.support_definitions()

	var new_pairs: int = 0
	var ranks: int = 0
	var refused_decisions: int = 0
	for state: Array in [[0, 0], [1, 0], [0, 2], [1, 1], [2, 1], [1, 2]]:
		var held: AcquiredSupports = _shipped(int(state[0]), int(state[1]))
		for seed_value: int in SEED_SAMPLES:
			var continuation: SupportContinuationResult = SupportContinuation.select(profiles, definitions, held, seed_value)
			if continuation.is_new_pair():
				new_pairs += 1
			elif continuation.is_rank_increase():
				ranks += 1
			var result: SupportExhaustionPassiveFallbackResult = SupportExhaustionPassiveFallback.select(
				continuation, combat, utility, cards, seed_value)
			_refusals += 1
			if _refuses(result, "the support lane is not exhausted: it decided"):
				refused_decisions += 1
	_expect(new_pairs == 3 * SEED_SAMPLES and ranks == 3 * SEED_SAMPLES,
		"%d new pairs and %d rank increases over 6 states" % [new_pairs, ranks])
	_expect(refused_decisions == 6 * SEED_SAMPLES,
		"%d of %d decisions were refused whole" % [refused_decisions, 6 * SEED_SAMPLES])

	var no_definitions: Array[SupportDefinition] = []
	var broken: Array[SupportDefinition] = [SupportDefinition.new()]
	var caster: Array[SkillTagProfile] = [
		SkillTagProfile.of(&"zz_caster", "Caster", [SkillTags.SPELL, SkillTags.HIT] as Array[StringName]),
	]
	var ordinary: Array = [
		["no support definitions", SupportContinuation.select(profiles, no_definitions, null, 7)],
		["an invalid support definition", SupportContinuation.select(profiles, broken, null, 7)],
		["no compatible support for any Skill", SupportContinuation.select(caster, definitions, null, 7)],
	]
	var refused_ordinary: int = 0
	for row: Array in ordinary:
		var continuation: SupportContinuationResult = row[1]
		var result: SupportExhaustionPassiveFallbackResult = SupportExhaustionPassiveFallback.select_with_tickets(
			continuation, combat, utility, cards, 0, 0)
		_refusals += 1
		var ordinary_refusal: bool = not continuation.ok and not continuation.is_exhausted() \
			and continuation.problem().is_empty()
		if ordinary_refusal and _refuses(result, "the support lane refused without being exhausted") \
				and result.failure_reason.contains(continuation.failure_reason):
			refused_ordinary += 1
		else:
			_expect(false, "%s: the continuation read %s and the fallback %s" % [
				String(row[0]), continuation.describe(), result.describe()])
	_expect(refused_ordinary == ordinary.size(),
		"%d of %d ordinary Support refusals were refused whole" % [refused_ordinary, ordinary.size()])
	print("  %d new-pair and %d rank-increase decisions over 6 shipped states x %d seeds: %d refused whole, 0 partial"
		% [new_pairs, ranks, SEED_SAMPLES, refused_decisions])
	print("  %d of %d ordinary Support refusals (no definitions, an invalid definition, no compatible support) refused whole, quoting the continuation"
		% [refused_ordinary, ordinary.size()])
	_done("a_support_decision_or_ordinary_refusal_never_activates")


# --- 3. Invalid and forged Support state -------------------------------------------------------------------------------

func _check_invalid_or_forged_support_state_cannot_masquerade_as_exhaustion() -> void:
	print("")
	print("--- 3. An invalid, above-maximum or forged Support state cannot masquerade as exhaustion")
	var cards: Array[PassiveCardDefinition] = _cards()
	var combat: PassiveCardSelectionResult = _source(cards, COMBAT, 0)
	var utility: PassiveCardSelectionResult = _source(cards, UTILITY, 0)
	var profiles: Array[SkillTagProfile] = SkillSupportCatalogue.skill_profiles()
	var definitions: Array[SupportDefinition] = SkillSupportCatalogue.support_definitions()

	var above_refused: int = 0
	var above_exhausted: int = 0
	for state: Array in [[3, 0], [3, 1], [3, 2], [1, 3]]:
		var held: AcquiredSupports = _shipped(int(state[0]), int(state[1]))
		for seed_value: int in SEED_SAMPLES:
			var continuation: SupportContinuationResult = SupportContinuation.select(profiles, definitions, held, seed_value)
			if continuation.is_exhausted():
				above_exhausted += 1
			var result: SupportExhaustionPassiveFallbackResult = SupportExhaustionPassiveFallback.select(
				continuation, combat, utility, cards, seed_value)
			_refusals += 1
			if _refuses(result, "invalid acquisition state"):
				above_refused += 1
	_expect(above_exhausted == 0 and above_refused == 4 * SEED_SAMPLES,
		"above-maximum: %d exhausted, %d of %d refused quoting the invalid state" % [
			above_exhausted, above_refused, 4 * SEED_SAMPLES])

	var success_marked: SupportContinuationResult = SupportContinuation.select(profiles, definitions, _shipped(0, 0), 7)
	success_marked.exhausted = true
	var ok_marked: SupportContinuationResult = SupportContinuationResult.exhaustion("forged")
	ok_marked.ok = true
	var kind_marked: SupportContinuationResult = SupportContinuationResult.exhaustion("forged")
	kind_marked.kind = SupportContinuationResult.Kind.NEW_PAIR
	var selection_marked: SupportContinuationResult = SupportContinuationResult.exhaustion("forged")
	selection_marked.selection = SupportSelection.select(profiles, definitions, null, 7)
	var pair_marked: SupportContinuationResult = SupportContinuationResult.exhaustion("forged")
	pair_marked.skill_id = QUICK_STRIKE
	var forged: Array = [
		["a new-pair decision marked exhausted", success_marked],
		["an exhaustion marked successful", ok_marked],
		["an exhaustion carrying a decision kind", kind_marked],
		["an exhaustion carrying a selection", selection_marked],
		["an exhaustion naming a Skill", pair_marked],
		["a default-constructed continuation", SupportContinuationResult.new()],
	]
	var forged_refused: int = 0
	for row: Array in forged:
		var continuation: SupportContinuationResult = row[1]
		var result: SupportExhaustionPassiveFallbackResult = SupportExhaustionPassiveFallback.select_with_tickets(
			continuation, combat, utility, cards, 0, 0)
		_refusals += 1
		if not continuation.problem().is_empty() and _refuses(result, "the support continuation is incoherent"):
			forged_refused += 1
		else:
			_expect(false, "%s was not refused as incoherent: %s" % [String(row[0]), result.describe()])
	_expect(forged_refused == forged.size(), "%d of %d forged records refused" % [forged_refused, forged.size()])
	var absent: SupportExhaustionPassiveFallbackResult = SupportExhaustionPassiveFallback.select_with_tickets(
		null, combat, utility, cards, 0, 0)
	_refusals += 1
	_expect(_refuses(absent, "no support continuation was supplied"), "a null continuation read %s" % absent.describe())
	print("  4 above-maximum states x %d seeds: %d continuations exhausted, %d of %d fallbacks refused, quoting the invalid state"
		% [SEED_SAMPLES, above_exhausted, above_refused, 4 * SEED_SAMPLES])
	print("  %d of %d forged or incoherent records refused as incoherent before their classification is read; a null continuation is refused"
		% [forged_refused, forged.size()])
	print("  STATED LIMITATION: a COHERENT record built by the accepted exhaustion constructor activates (check 1); the fallback trusts that classification and is not handed the support inputs to re-prove it.")
	_done("invalid_or_forged_support_state_cannot_masquerade_as_exhaustion")


# --- 4. Missing, incoherent or refused sources -------------------------------------------------------------------------

func _check_missing_incoherent_or_refused_passive_sources_refuse_whole() -> void:
	print("")
	print("--- 4. A missing, incoherent or refused passive-lane source refuses the whole fallback")
	var cards: Array[PassiveCardDefinition] = _cards()
	var combat: PassiveCardSelectionResult = _source(cards, COMBAT, 0)
	var utility: PassiveCardSelectionResult = _source(cards, UTILITY, 0)
	var exhausted: SupportContinuationResult = _exhausted()
	var forged: PassiveCardSelectionResult = _source(cards, COMBAT, 0)
	forged.selected_card_id = POWER
	var forged_ladder: PassiveCardSelectionResult = _source(cards, UTILITY, 0)
	forged_ladder.candidate_weights[0] = 7
	var refused_combat: PassiveCardSelectionResult = PassiveCardSelection.select_with_ticket(cards, COMBAT, -1)
	var refused_utility: PassiveCardSelectionResult = PassiveCardSelection.select_with_ticket(_only(cards, COMBAT), UTILITY, 0)
	var rows: Array = [
		["a missing Combat and Defence selection", null, utility, "no Combat and Defence selection"],
		["a missing Utility selection", combat, null, "no Utility selection"],
		["a default-constructed Combat and Defence result", PassiveCardSelectionResult.new(), utility, "selection is incoherent"],
		["a default-constructed Utility result", combat, PassiveCardSelectionResult.new(), "selection is incoherent"],
		["a Combat and Defence success naming a card its ticket does not reach", forged, utility, "selection is incoherent"],
		["a Utility success whose ladder no longer sums", combat, forged_ladder, "selection is incoherent"],
		["a refused Combat and Defence selection", refused_combat, utility, "refused, so it offers no card to exclude"],
		["a refused Utility selection", combat, refused_utility, "refused, so it offers no card to exclude"],
	]
	var refused: int = 0
	for row: Array in rows:
		var result: SupportExhaustionPassiveFallbackResult = SupportExhaustionPassiveFallback.select_with_tickets(
			exhausted, row[1] as PassiveCardSelectionResult, row[2] as PassiveCardSelectionResult, cards, 0, 0)
		_refusals += 1
		if _refuses(result, String(row[3])):
			refused += 1
		else:
			_expect(false, "%s was not refused as expected: %s" % [String(row[0]), result.describe()])
	_expect(refused == rows.size(), "%d of %d source faults refused" % [refused, rows.size()])
	print("  %d of %d source faults (2 missing, 4 incoherent, 2 refused) refused whole, with no category, card, ticket or derivation"
		% [refused, rows.size()])
	_done("missing_incoherent_or_refused_passive_sources_refuse_whole")


# --- 5. Swapped sources -----------------------------------------------------------------------------------------------

func _check_a_swapped_pair_of_sources_is_refused_not_repaired() -> void:
	print("")
	print("--- 5. Swapped Combat and Defence and Utility sources are refused, never repaired")
	var cards: Array[PassiveCardDefinition] = _cards()
	var combat: PassiveCardSelectionResult = _source(cards, COMBAT, 0)
	var utility: PassiveCardSelectionResult = _source(cards, UTILITY, 0)
	var exhausted: SupportContinuationResult = _exhausted()
	var shapes: Array = [
		["swapped", utility, combat, "the Combat and Defence selection was drawn from the Utility category"],
		["both Combat and Defence", combat, combat, "the Utility selection was drawn from the Combat and Defence category"],
		["both Utility", utility, utility, "the Combat and Defence selection was drawn from the Utility category"],
	]
	var refused: int = 0
	var cases: int = 0
	for row: Array in shapes:
		for category_ticket: int in 2:
			for card_ticket: int in [0, 99, 100, 199]:
				cases += 1
				var result: SupportExhaustionPassiveFallbackResult = SupportExhaustionPassiveFallback.select_with_tickets(
					exhausted, row[1] as PassiveCardSelectionResult, row[2] as PassiveCardSelectionResult,
					cards, category_ticket, card_ticket)
				_refusals += 1
				if _refuses(result, String(row[3])) and result.failure_reason.contains("refused rather than repaired"):
					refused += 1
	_expect(refused == cases, "%d of %d swapped cases refused" % [refused, cases])
	print("  %d of %d cases (swapped, both Combat and Defence, both Utility x 8 ticket pairs) refused whole, naming the category each was drawn from"
		% [refused, cases])
	_done("a_swapped_pair_of_sources_is_refused_not_repaired")


# --- 6. Membership, filing and distinctness ---------------------------------------------------------------------------

func _check_offered_cards_must_be_supplied_filed_correctly_and_distinct() -> void:
	print("")
	print("--- 6. The offered cards must be among the supplied records, filed where their lane drew them, and distinct")
	var cards: Array[PassiveCardDefinition] = _cards()
	var utility: PassiveCardSelectionResult = _source(cards, UTILITY, 0)
	var exhausted: SupportContinuationResult = _exhausted()

	var with_extra: Array[PassiveCardDefinition] = _with(cards, _card("zz_extra", "Extra", PlayerStats.GLOBAL_DAMAGE, 100))
	var extra_source: PassiveCardSelectionResult = _source(with_extra, COMBAT, 300)
	var dual_combat_set: Array[PassiveCardDefinition] = _with(cards, _card("zz_dual", "Dual", PlayerStats.GLOBAL_DAMAGE, 100))
	var dual_utility_set: Array[PassiveCardDefinition] = _with(cards, _card("zz_dual", "Dual", PlayerStats.MOVEMENT_SPEED, 100))
	var dual_combat: PassiveCardSelectionResult = _source(dual_combat_set, COMBAT, 300)
	var dual_utility: PassiveCardSelectionResult = _source(dual_utility_set, UTILITY, 300)
	_expect(extra_source.ok and extra_source.selected_card_id == &"zz_extra" and extra_source.problem().is_empty()
			and dual_combat.ok and dual_combat.selected_card_id == &"zz_dual"
			and dual_utility.ok and dual_utility.selected_card_id == &"zz_dual",
		"the fabricated sources are %s / %s / %s" % [extra_source.describe(), dual_combat.describe(), dual_utility.describe()])

	var rows: Array = [
		["an offered card absent from the supplied records", extra_source, utility, cards,
			"zz_extra, offered by the Combat and Defence lane, is not among the supplied passive card records"],
		["an offered card the supplied records file under the other category", dual_combat, utility, dual_utility_set,
			"zz_dual, offered by the Combat and Defence lane, is filed under Utility by the supplied records"],
		["both lanes offering one card", dual_combat, dual_utility, dual_combat_set,
			"both passive lanes already offer zz_dual"],
	]
	var refused: int = 0
	for row: Array in rows:
		var records: Array[PassiveCardDefinition] = row[3]
		var result: SupportExhaustionPassiveFallbackResult = SupportExhaustionPassiveFallback.select_with_tickets(
			exhausted, row[1] as PassiveCardSelectionResult, row[2] as PassiveCardSelectionResult, records, 0, 0)
		_refusals += 1
		if _refuses(result, String(row[4])):
			refused += 1
		else:
			_expect(false, "%s: %s" % [String(row[0]), result.describe()])
	_expect(refused == rows.size(), "%d of %d membership faults refused" % [refused, rows.size()])
	print("  %d of %d refused whole: an offered card absent from the records, one filed under the other category, and one card offered by both lanes"
		% [refused, rows.size()])
	_done("offered_cards_must_be_supplied_filed_correctly_and_distinct")


# --- 7. Whole-set validation ------------------------------------------------------------------------------------------

func _check_every_supplied_record_is_validated_before_exclusion() -> void:
	print("")
	print("--- 7. Every supplied record is validated before anything is excluded or counted")
	var cards: Array[PassiveCardDefinition] = _cards()
	var combat: PassiveCardSelectionResult = _source(cards, COMBAT, 0)
	var utility: PassiveCardSelectionResult = _source(cards, UTILITY, 0)
	var exhausted: SupportContinuationResult = _exhausted()
	var with_null: Array[PassiveCardDefinition] = cards.duplicate()
	with_null.append(null)
	var rows: Array = [
		["the EXCLUDED Combat and Defence card at weight 0",
			_replaced(cards, CELERITY, _faulted(_record(cards, CELERITY), "weight")), "below the minimum"],
		["the EXCLUDED Utility card with a negative magnitude",
			_replaced(cards, FLEETNESS, _faulted(_record(cards, FLEETNESS), "magnitude")), "is not positive"],
		["a Utility card at weight 0, which no Combat and Defence ticket reaches",
			_replaced(cards, MAGNETISM, _faulted(_record(cards, MAGNETISM), "weight")), "below the minimum"],
		["a Combat and Defence card with an illegal id, which no Utility ticket reaches",
			_replaced(cards, VITALITY, _faulted(_record(cards, VITALITY), "id")), "lower_snake_case"],
		["an extra record naming an unknown stat",
			_with(cards, _card("zz_stray", "Stray", &"not_a_stat", 100)), "not a recognised player stat"],
		["a null record", with_null, "a passive card record is null"],
	]
	var refused: int = 0
	var cases: int = 0
	for row: Array in rows:
		var records: Array[PassiveCardDefinition] = row[1]
		for category_ticket: int in 2:
			for card_ticket: int in [0, 99, 100, 199]:
				cases += 1
				var result: SupportExhaustionPassiveFallbackResult = SupportExhaustionPassiveFallback.select_with_tickets(
					exhausted, combat, utility, records, category_ticket, card_ticket)
				_refusals += 1
				if _refuses(result, "the supplied passive card records cannot be drawn from") \
						and result.failure_reason.contains(String(row[2])):
					refused += 1
	_expect(refused == cases, "%d of %d polluted cases refused" % [refused, cases])
	## "No seed decides validity": the unchosen-category fault, over seeds as well.
	var unreached: Array[PassiveCardDefinition] = rows[2][1]
	var seeded_refused: int = 0
	for seed_value: int in SEED_SAMPLES:
		var result: SupportExhaustionPassiveFallbackResult = SupportExhaustionPassiveFallback.select(
			exhausted, combat, utility, unreached, seed_value)
		_refusals += 1
		if _refuses(result, "below the minimum"):
			seeded_refused += 1
	_expect(seeded_refused == SEED_SAMPLES, "%d of %d seeds refused the unreached fault" % [seeded_refused, SEED_SAMPLES])
	## Positive control: the clean set accepts every one of the same ticket pairs.
	var clean: int = 0
	for category_ticket: int in 2:
		for card_ticket: int in [0, 99, 100, 199]:
			if SupportExhaustionPassiveFallback.select_with_tickets(
					exhausted, combat, utility, cards, category_ticket, card_ticket).ok:
				clean += 1
	_expect(clean == 8, "the clean control accepted %d of 8" % clean)
	print("  %d of %d cases over 6 faults (both excluded cards, a card in each unreached category, an unknown stat, a null) x 8 ticket pairs refused whole; %d of %d seeds refuse the unreached Utility fault; the clean control accepts %d of 8"
		% [refused, cases, seeded_refused, SEED_SAMPLES, clean])
	_done("every_supplied_record_is_validated_before_exclusion")


# --- 8. Zero tickets for the offered cards ----------------------------------------------------------------------------

func _check_the_offered_cards_own_zero_tickets_and_are_never_returned() -> void:
	print("")
	print("--- 8. Over every source pair, the two offered cards own zero tickets and are never returned")
	var cards: Array[PassiveCardDefinition] = _cards()
	var exhausted: SupportContinuationResult = _exhausted()
	var fallbacks: int = 0
	var returned_offered: int = 0
	var on_ladder: int = 0
	var uneven_pairs: int = 0
	var refused: int = 0
	for combat_index: int in 3:
		for utility_index: int in 3:
			var combat: PassiveCardSelectionResult = _source(cards, COMBAT, 100 * combat_index)
			var utility: PassiveCardSelectionResult = _source(cards, UTILITY, 100 * utility_index)
			var owners: Dictionary = {}
			for category_ticket: int in 2:
				for card_ticket: int in 200:
					var result: SupportExhaustionPassiveFallbackResult = SupportExhaustionPassiveFallback.select_with_tickets(
						exhausted, combat, utility, cards, category_ticket, card_ticket)
					fallbacks += 1
					if not result.ok:
						refused += 1
						continue
					_count(owners, String(result.selected_card_id))
					if result.selected_card_id == combat.selected_card_id or result.selected_card_id == utility.selected_card_id:
						returned_offered += 1
					var nested: PassiveCardSelectionResult = result.selection()
					if nested.candidate_ids.has(combat.selected_card_id) or nested.candidate_ids.has(utility.selected_card_id):
						on_ladder += 1
			var even: bool = owners.size() == 4
			for owned: Variant in owners.values():
				if int(owned) != 100:
					even = false
			if not even:
				uneven_pairs += 1
	_expect(fallbacks == 3600 and refused == 0, "%d fallbacks, %d refused" % [fallbacks, refused])
	_expect(returned_offered == 0 and on_ladder == 0,
		"an offered card was returned %d times and sat on a ladder %d times" % [returned_offered, on_ladder])
	_expect(uneven_pairs == 0, "%d of 9 source pairs did not give each remaining card exactly 100" % uneven_pairs)
	print("  %d fallbacks over all 9 source pairs x the complete 2 x 200 grid: an offered card returned %d times and on a nested ladder %d times; each pair's 4 remaining cards own exactly 100 of 400 (%d uneven)"
		% [fallbacks, returned_offered, on_ladder, uneven_pairs])
	_done("the_offered_cards_own_zero_tickets_and_are_never_returned")


# --- 9. Category ownership --------------------------------------------------------------------------------------------

func _check_category_ownership_is_equal_whatever_the_catalogue_depth() -> void:
	print("")
	print("--- 9. The category stage owns exactly one ticket per available category, whatever the catalogue depth")
	var exhausted: SupportContinuationResult = _exhausted()
	var shipped: Array[PassiveCardDefinition] = _cards()
	var deep_combat: Array[PassiveCardDefinition] = shipped.duplicate()
	deep_combat.append(_card("zz_c1", "One", PlayerStats.GLOBAL_DAMAGE, 1))
	deep_combat.append(_card("zz_c2", "Two", PlayerStats.MAXIMUM_LIFE, 50))
	deep_combat.append(_card("zz_c3", "Three", PlayerStats.SKILL_SPEED, 300))
	deep_combat.append(_card("zz_c4", "Four", PlayerStats.GLOBAL_DAMAGE, 1000))
	var deep_utility: Array[PassiveCardDefinition] = shipped.duplicate()
	deep_utility.append(_card("zz_u1", "One", PlayerStats.MOVEMENT_SPEED, 1))
	deep_utility.append(_card("zz_u2", "Two", PlayerStats.EXPERIENCE_GAIN, 50))
	deep_utility.append(_card("zz_u3", "Three", PlayerStats.PICKUP_RADIUS, 300))
	deep_utility.append(_card("zz_u4", "Four", PlayerStats.MOVEMENT_SPEED, 1000))
	var lines: PackedStringArray = PackedStringArray()
	for row: Array in [["shipped", shipped, 200, 200], ["deep Combat and Defence", deep_combat, 1551, 200],
			["deep Utility", deep_utility, 200, 1551]]:
		var records: Array[PassiveCardDefinition] = row[1]
		var combat: PassiveCardSelectionResult = _source(records, COMBAT, 0)
		var utility: PassiveCardSelectionResult = _source(records, UTILITY, 0)
		_expect(combat.selected_card_id == CELERITY and utility.selected_card_id == FLEETNESS,
			"the %s sources are %s / %s" % [String(row[0]), combat.selected_card_id, utility.selected_card_id])
		## The complete category ladder, twice over: every position once, then 1000
		## consecutive tickets.
		var by_ticket: Dictionary = {}
		for category_ticket: int in 1000:
			var result: SupportExhaustionPassiveFallbackResult = SupportExhaustionPassiveFallback.select_with_tickets(
				exhausted, combat, utility, records, category_ticket, 0)
			_count(by_ticket, result.selected_category)
		## And the complete grid: every category ticket position against every card
		## ticket of the deeper ladder — the category decision never looks at depth.
		var totals: Dictionary = {}
		var nested_totals: Dictionary = {}
		var span: int = maxi(int(row[2]), int(row[3]))
		for category_ticket: int in 2:
			for card_ticket: int in span:
				var result: SupportExhaustionPassiveFallbackResult = SupportExhaustionPassiveFallback.select_with_tickets(
					exhausted, combat, utility, records, category_ticket, card_ticket)
				_count(totals, result.selected_category)
				nested_totals[result.selected_category] = result.selection().total_weight
		_expect(int(by_ticket.get(COMBAT, 0)) == 500 and int(by_ticket.get(UTILITY, 0)) == 500,
			"%s: 1000 category tickets split %s" % [String(row[0]), by_ticket])
		_expect(int(totals.get(COMBAT, 0)) == span and int(totals.get(UTILITY, 0)) == span
				and int(nested_totals.get(COMBAT, 0)) == int(row[2]) and int(nested_totals.get(UTILITY, 0)) == int(row[3]),
			"%s: the grid split %s over ladders %s" % [String(row[0]), totals, nested_totals])
		lines.append("%s (card ladders %d / %d): 1000 category tickets %d / %d, the %d x 2 grid %d / %d" % [
			String(row[0]), int(nested_totals.get(COMBAT, 0)), int(nested_totals.get(UTILITY, 0)),
			int(by_ticket.get(COMBAT, 0)), int(by_ticket.get(UTILITY, 0)), span,
			int(totals.get(COMBAT, 0)), int(totals.get(UTILITY, 0))])
	for line: String in lines:
		print("  %s" % line)
	_done("category_ownership_is_equal_whatever_the_catalogue_depth")


# --- 10. Card ownership -----------------------------------------------------------------------------------------------

func _check_card_ownership_follows_the_accepted_integer_weights() -> void:
	print("")
	print("--- 10. Within the chosen category, card ownership follows the accepted integer weights exactly")
	var exhausted: SupportContinuationResult = _exhausted()
	var shipped: Array[PassiveCardDefinition] = _cards()
	var uneven: Array[PassiveCardDefinition] = []
	uneven.append(_card("zz_third", "Gamma", PlayerStats.MAXIMUM_LIFE, 5))
	uneven.append(_record(shipped, FLEETNESS))
	uneven.append(_card("zz_first", "Alpha", PlayerStats.GLOBAL_DAMAGE, 4))
	uneven.append(_record(shipped, CELERITY))
	uneven.append(_card("zz_second", "Beta", PlayerStats.SKILL_SPEED, 6))
	uneven.append(_record(shipped, INSIGHT))
	var combat: PassiveCardSelectionResult = _source(uneven, COMBAT, 0)
	var utility: PassiveCardSelectionResult = _source(uneven, UTILITY, 0)
	_expect(combat.selected_card_id == CELERITY and utility.selected_card_id == FLEETNESS,
		"the uneven sources are %s / %s" % [combat.selected_card_id, utility.selected_card_id])
	var excluded: Array[StringName] = [CELERITY, FLEETNESS]
	var owners: Dictionary = {}
	var disagreed: int = 0
	var ladder: String = ""
	for card_ticket: int in 15:
		var result: SupportExhaustionPassiveFallbackResult = SupportExhaustionPassiveFallback.select_with_tickets(
			exhausted, combat, utility, uneven, 0, card_ticket)
		_count(owners, String(result.selected_card_id))
		ladder = result.selection().ladder_line()
		var direct: PassiveCardSelectionResult = PassiveCardSelection.select_with_ticket_excluding(
			uneven, COMBAT, card_ticket, excluded)
		if _passive_derivation(direct) != _passive_derivation(result.selection()):
			disagreed += 1
	_expect(ladder == "zz_first x4, zz_second x6, zz_third x5", "the uneven ladder is [%s]" % ladder)
	_expect(int(owners.get("zz_first", 0)) == 4 and int(owners.get("zz_second", 0)) == 6
			and int(owners.get("zz_third", 0)) == 5 and owners.size() == 3,
		"the uneven ownership is %s" % owners)
	_expect(disagreed == 0, "%d of 15 nested draws disagreed with the accepted selector called directly" % disagreed)
	var boundaries: Array = [[0, "zz_first"], [3, "zz_first"], [4, "zz_second"], [9, "zz_second"],
		[10, "zz_third"], [14, "zz_third"], [15, "zz_first"]]
	var wrong: int = 0
	for row: Array in boundaries:
		var result: SupportExhaustionPassiveFallbackResult = SupportExhaustionPassiveFallback.select_with_tickets(
			exhausted, combat, utility, uneven, 0, int(row[0]))
		if String(result.selected_card_id) != String(row[1]):
			wrong += 1
	_expect(wrong == 0, "%d of %d uneven boundaries moved" % [wrong, boundaries.size()])
	var utility_side: Dictionary = {}
	for card_ticket: int in 100:
		_count(utility_side, String(SupportExhaustionPassiveFallback.select_with_tickets(
			exhausted, combat, utility, uneven, 1, card_ticket).selected_card_id))
	_expect(int(utility_side.get("card_insight", 0)) == 100 and utility_side.size() == 1,
		"the lone Utility candidate owned %s" % utility_side)
	print("  Combat and Defence after excluding card_celerity: [%s] over 15 tickets — ownership zz_first 4, zz_second 6, zz_third 5; 0/3 -> first, 4/9 -> second, 10/14 -> third, 15 wraps to first; %d of 15 nested draws differ from the accepted selector called directly"
		% [ladder, disagreed])
	_done("card_ownership_follows_the_accepted_integer_weights")


# --- 11. Order, tags and presentation ---------------------------------------------------------------------------------

func _check_order_tags_and_presentation_names_change_nothing() -> void:
	print("")
	print("--- 11. Card-array order, Support-input order, Skill tag order and presentation names change no answer")
	var cards: Array[PassiveCardDefinition] = _cards()
	var reference: PackedStringArray = _grid(_exhausted(), cards, cards)

	var variants: Array = []
	variants.append(["reversed cards", _reversed(cards)])
	variants.append(["rotated cards", _rotated(cards, 2)])
	variants.append(["interleaved cards", _interleaved(cards)])
	var renamed: Array[PassiveCardDefinition] = []
	var index: int = 0
	for card: PassiveCardDefinition in cards:
		renamed.append(PassiveCardDefinition.of(card.card_id, "Renamed %d" % index, card.stat_id,
			card.magnitude, card.base_weight, card.repeatable))
		index += 1
	variants.append(["renamed cards", renamed])
	var swapped: Array[PassiveCardDefinition] = []
	for card: PassiveCardDefinition in cards:
		var name_for: String = card.display_name
		if card.card_id == POWER:
			name_for = _record(cards, INSIGHT).display_name
		elif card.card_id == INSIGHT:
			name_for = _record(cards, POWER).display_name
		swapped.append(PassiveCardDefinition.of(card.card_id, name_for, card.stat_id,
			card.magnitude, card.base_weight, card.repeatable))
	variants.append(["name-swapped cards", swapped])

	var compared: int = 0
	var moved: int = 0
	for row: Array in variants:
		var records: Array[PassiveCardDefinition] = row[1]
		var answers: PackedStringArray = _grid(_exhausted(), records, records)
		compared += answers.size()
		moved += _differences(reference, answers)

	## The Support side: the continuation that activates the fallback, rebuilt from
	## reversed definitions, reversed Skill tags and a renamed Skill profile.
	var profile: SkillTagProfile = SkillSupportCatalogue.quick_strike_profile()
	var reversed_tags: Array[StringName] = []
	for position: int in range(profile.tags.size() - 1, -1, -1):
		reversed_tags.append(profile.tags[position])
	var definitions: Array[SupportDefinition] = SkillSupportCatalogue.support_definitions()
	var reversed_definitions: Array[SupportDefinition] = []
	for position: int in range(definitions.size() - 1, -1, -1):
		reversed_definitions.append(definitions[position])
	var support_variants: Array = [
		["reversed support definitions", SkillSupportCatalogue.skill_profiles(), reversed_definitions],
		["reversed Skill tags", [SkillTagProfile.of(profile.skill_id, profile.display_name, reversed_tags)] as Array[SkillTagProfile], definitions],
		["a renamed Skill profile", [SkillTagProfile.of(profile.skill_id, "Renamed Skill", profile.tags)] as Array[SkillTagProfile], definitions],
	]
	var support_exhausted: int = 0
	for row: Array in support_variants:
		var profiles: Array[SkillTagProfile] = row[1]
		var variant_definitions: Array[SupportDefinition] = row[2]
		var continuation: SupportContinuationResult = SupportContinuation.select(
			profiles, variant_definitions, _shipped(2, 2), 7)
		if continuation.is_exhausted():
			support_exhausted += 1
		var answers: PackedStringArray = _grid(continuation, cards, cards)
		compared += answers.size()
		moved += _differences(reference, answers)
	_expect(_ids_of(variants[0][1]) != _ids_of(cards) and _ids_of(variants[1][1]) != _ids_of(cards)
			and _ids_of(variants[2][1]) != _ids_of(cards) and reversed_tags != profile.tags,
		"a permutation did not actually move anything")
	_expect(support_exhausted == support_variants.size(), "%d of %d Support variants exhausted" % [
		support_exhausted, support_variants.size()])
	_expect(moved == 0 and compared == 8 * 400, "%d of %d answers moved" % [moved, compared])
	print("  %d answers over 8 variants (reversed, rotated and interleaved cards; renamed and name-swapped cards; reversed support definitions, reversed Skill tags, a renamed Skill) x the complete 2 x 200 grid: %d moved"
		% [compared, moved])
	_done("order_tags_and_presentation_names_change_nothing")


# --- 12. Duplicates ---------------------------------------------------------------------------------------------------

func _check_duplicated_records_refuse_rather_than_bias() -> void:
	print("")
	print("--- 12. Duplicated supplied records refuse rather than biasing a ladder")
	var cards: Array[PassiveCardDefinition] = _cards()
	var combat: PassiveCardSelectionResult = _source(cards, COMBAT, 0)
	var utility: PassiveCardSelectionResult = _source(cards, UTILITY, 0)
	var exhausted: SupportContinuationResult = _exhausted()
	var rows: Array = [
		["a remaining card supplied twice", _with(cards, _record(cards, POWER))],
		["an offered card supplied twice", _with(cards, _record(cards, CELERITY))],
		["a second record sharing an offered card's id", _with(cards, _card("card_fleetness", "Impostor", PlayerStats.GLOBAL_DAMAGE, 100))],
		["a second record sharing a remaining card's id", _with(cards, _card("card_insight", "Impostor", PlayerStats.MOVEMENT_SPEED, 100))],
	]
	var refused: int = 0
	var cases: int = 0
	for row: Array in rows:
		var records: Array[PassiveCardDefinition] = row[1]
		for category_ticket: int in 2:
			for card_ticket: int in [0, 100, 199, 250]:
				cases += 1
				var result: SupportExhaustionPassiveFallbackResult = SupportExhaustionPassiveFallback.select_with_tickets(
					exhausted, combat, utility, records, category_ticket, card_ticket)
				_refusals += 1
				if _refuses(result, "duplicate card id"):
					refused += 1
	_expect(refused == cases, "%d of %d duplicate cases refused" % [refused, cases])
	print("  %d of %d cases over 4 duplicate shapes (a remaining or an offered card twice, an id shared with an offered or a remaining card) x 8 ticket pairs refused whole — none weighed twice"
		% [refused, cases])
	_done("duplicated_records_refuse_rather_than_bias")


# --- 13. The weight ceiling -------------------------------------------------------------------------------------------

func _check_the_weight_ceiling_is_inherited_from_the_accepted_selector() -> void:
	print("")
	print("--- 13. The weight ceiling is the accepted selector's: exactly at it is accepted, one past it refuses on every ticket")
	var exhausted: SupportContinuationResult = _exhausted()
	var ceiling: int = PassiveCardSelection.MAXIMUM_TOTAL_WEIGHT
	var source_card: PassiveCardDefinition = _card("zz_c_src", "Offered", PlayerStats.GLOBAL_DAMAGE, 1)
	var utility_card: PassiveCardDefinition = _card("zz_u_src", "Offered", PlayerStats.MOVEMENT_SPEED, 1)
	var other_card: PassiveCardDefinition = _card("zz_u_other", "Other", PlayerStats.EXPERIENCE_GAIN, 1)
	var companion: Array[PassiveCardDefinition] = [source_card, utility_card, other_card]
	var combat: PassiveCardSelectionResult = _source(companion, COMBAT, 0)
	var utility: PassiveCardSelectionResult = _source(companion, UTILITY, 1)
	_expect(combat.selected_card_id == &"zz_c_src" and utility.selected_card_id == &"zz_u_src",
		"the ceiling sources are %s / %s" % [combat.selected_card_id, utility.selected_card_id])

	var exact: Array[PassiveCardDefinition] = [source_card,
		_card("zz_heavy_one", "Heavy One", PlayerStats.MAXIMUM_LIFE, 4_000_000_000),
		_card("zz_heavy_two", "Heavy Two", PlayerStats.SKILL_SPEED, ceiling - 4_000_000_000),
		utility_card, other_card]
	## The Combat and Defence LANE itself could not draw over this set: its full
	## ladder is the ceiling plus the offered card's weight.
	var lane_draw: PassiveCardSelectionResult = PassiveCardSelection.select_with_ticket(exact, COMBAT, 0)
	_expect(not lane_draw.ok and lane_draw.failure_reason.contains("would exceed the ceiling"),
		"the full Combat and Defence ladder read %s" % lane_draw.describe())
	var boundaries: Array = [[0, "zz_heavy_one"], [3_999_999_999, "zz_heavy_one"], [4_000_000_000, "zz_heavy_two"],
		[ceiling - 1, "zz_heavy_two"], [ceiling, "zz_heavy_one"]]
	var held: int = 0
	var totals_right: int = 0
	for row: Array in boundaries:
		var result: SupportExhaustionPassiveFallbackResult = SupportExhaustionPassiveFallback.select_with_tickets(
			exhausted, combat, utility, exact, 0, int(row[0]))
		if result.ok and String(result.selected_card_id) == String(row[1]) and result.problem().is_empty():
			held += 1
		if result.ok and result.selection().total_weight == ceiling:
			totals_right += 1
	var utility_answer: SupportExhaustionPassiveFallbackResult = SupportExhaustionPassiveFallback.select_with_tickets(
		exhausted, combat, utility, exact, 1, 0)
	_expect(held == boundaries.size() and totals_right == boundaries.size(),
		"%d of %d exact-ceiling boundaries held, %d totals equal the ceiling" % [held, boundaries.size(), totals_right])
	_expect(utility_answer.ok and utility_answer.selected_card_id == &"zz_u_other",
		"the Utility side answered %s" % utility_answer.describe())

	var over: Array[PassiveCardDefinition] = [source_card,
		_card("zz_heavy_one", "Heavy One", PlayerStats.MAXIMUM_LIFE, 4_000_000_000),
		_card("zz_heavy_two", "Heavy Two", PlayerStats.SKILL_SPEED, ceiling - 3_999_999_999),
		utility_card, other_card]
	var over_refused: int = 0
	var over_cases: int = 0
	for category_ticket: int in 2:
		for card_ticket: int in [0, 1, 4_000_000_000]:
			over_cases += 1
			var result: SupportExhaustionPassiveFallbackResult = SupportExhaustionPassiveFallback.select_with_tickets(
				exhausted, combat, utility, over, category_ticket, card_ticket)
			_refusals += 1
			if _refuses(result, "would exceed the ceiling") and result.failure_reason.contains("no category may be chosen"):
				over_refused += 1
	var seeded_over: int = 0
	for seed_value: int in SEED_SAMPLES:
		_refusals += 1
		if _refuses(SupportExhaustionPassiveFallback.select(exhausted, combat, utility, over, seed_value), "would exceed the ceiling"):
			seeded_over += 1
	_expect(over_refused == over_cases and seeded_over == SEED_SAMPLES,
		"one past the ceiling: %d of %d ticket pairs and %d of %d seeds refused" % [
			over_refused, over_cases, seeded_over, SEED_SAMPLES])
	var excluded: Array[StringName] = [&"zz_c_src", &"zz_u_src"]
	var direct: PassiveCardSelectionResult = PassiveCardSelection.select_with_ticket_excluding(exact, COMBAT, 0, excluded)
	_expect(direct.ok and direct.total_weight == ceiling,
		"the accepted selector with the offered card excluded read %s" % direct.describe())
	print("  a remaining Combat and Defence pool totalling exactly %d (the full lane ladder %d refuses): %d of %d boundaries hold at 0, 3999999999, 4000000000, %d and the wrap; the Utility side answers zz_u_other"
		% [ceiling, ceiling + 1, held, boundaries.size(), ceiling - 1])
	print("  one past the ceiling: %d of %d ticket pairs — including category ticket 1, which would choose Utility — and %d of %d seeds refuse whole before any category is chosen"
		% [over_refused, over_cases, seeded_over, SEED_SAMPLES])
	_done("the_weight_ceiling_is_inherited_from_the_accepted_selector")


# --- 14. One available category ---------------------------------------------------------------------------------------

func _check_one_available_category_owns_every_category_ticket() -> void:
	print("")
	print("--- 14. When only one category has a remaining card, it owns every category ticket")
	var exhausted: SupportContinuationResult = _exhausted()
	var cards: Array[PassiveCardDefinition] = _cards()
	var utility_bare: Array[PassiveCardDefinition] = _only(cards, COMBAT)
	utility_bare.append(_record(cards, FLEETNESS))
	var combat_bare: Array[PassiveCardDefinition] = _only(cards, UTILITY)
	combat_bare.append(_record(cards, CELERITY))
	var lines: PackedStringArray = PackedStringArray()
	for row: Array in [["Utility holds only the offered card", utility_bare, COMBAT],
			["Combat and Defence holds only the offered card", combat_bare, UTILITY]]:
		var records: Array[PassiveCardDefinition] = row[1]
		var combat: PassiveCardSelectionResult = _source(records, COMBAT, 0)
		var utility: PassiveCardSelectionResult = _source(records, UTILITY, 0)
		var owned: int = 0
		var ladders_right: int = 0
		for category_ticket: int in 10:
			for card_ticket: int in [0, 150]:
				var result: SupportExhaustionPassiveFallbackResult = SupportExhaustionPassiveFallback.select_with_tickets(
					exhausted, combat, utility, records, category_ticket, card_ticket)
				if result.ok and result.selected_category == int(row[2]) and result.normalized_category_ticket == 0:
					owned += 1
				if str(result.candidate_categories()) == str([int(row[2])]):
					ladders_right += 1
		_expect(owned == 20 and ladders_right == 20, "%s: %d of 20 owned, %d ladders right" % [String(row[0]), owned, ladders_right])
		lines.append("%s: %s owns %d of 20 (10 category tickets x 2 card tickets), the category ladder [%d]" % [
			String(row[0]), PassiveCardSelectionResult.category_label(int(row[2])), owned, int(row[2])])
	for line: String in lines:
		print("  %s" % line)
	_done("one_available_category_owns_every_category_ticket")


# --- 15. Fallback unavailable -----------------------------------------------------------------------------------------

func _check_no_remaining_card_is_an_explicit_fallback_unavailable() -> void:
	print("")
	print("--- 15. With no remaining card in either category the result is an explicit, bare fallback-unavailable")
	var exhausted: SupportContinuationResult = _exhausted()
	var cards: Array[PassiveCardDefinition] = _cards()
	var pair: Array[PassiveCardDefinition] = [_record(cards, CELERITY), _record(cards, FLEETNESS)]
	var combat: PassiveCardSelectionResult = _source(pair, COMBAT, 0)
	var utility: PassiveCardSelectionResult = _source(pair, UTILITY, 0)
	var unavailable: int = 0
	var cases: int = 0
	var bare: int = 0
	var reason: String = ""
	for category_ticket: int in 4:
		for card_ticket: int in 4:
			cases += 1
			var result: SupportExhaustionPassiveFallbackResult = SupportExhaustionPassiveFallback.select_with_tickets(
				exhausted, combat, utility, pair, category_ticket, card_ticket)
			_refusals += 1
			reason = result.failure_reason
			if result.is_unavailable() and not result.ok:
				unavailable += 1
			if _is_bare_refusal(result) and result.describe().begins_with("fallback unavailable — "):
				bare += 1
	var seeded: int = 0
	for seed_value: int in SEED_SAMPLES:
		_refusals += 1
		if SupportExhaustionPassiveFallback.select(exhausted, combat, utility, pair, seed_value).is_unavailable():
			seeded += 1
	_expect(unavailable == cases and bare == cases and seeded == SEED_SAMPLES,
		"%d of %d unavailable, %d bare, %d of %d seeds" % [unavailable, cases, bare, seeded, SEED_SAMPLES])
	print("  the two-card catalogue [card_celerity, card_fleetness]: %d of %d ticket pairs and %d of %d seeds are fallback-unavailable, each with no category, card, ticket, candidate or nested draw (%d bare): '%s'"
		% [unavailable, cases, seeded, SEED_SAMPLES, bare, reason])
	_done("no_remaining_card_is_an_explicit_fallback_unavailable")


# --- 16. Mechanically distinct outcomes -------------------------------------------------------------------------------

func _check_unavailable_malformed_and_support_exhaustion_are_mechanically_distinct() -> void:
	print("")
	print("--- 16. Fallback-unavailable, malformed input and Support exhaustion are told apart without text")
	var exhausted: SupportContinuationResult = _exhausted()
	var cards: Array[PassiveCardDefinition] = _cards()
	var pair: Array[PassiveCardDefinition] = [_record(cards, CELERITY), _record(cards, FLEETNESS)]
	var combat: PassiveCardSelectionResult = _source(pair, COMBAT, 0)
	var utility: PassiveCardSelectionResult = _source(pair, UTILITY, 0)
	var unavailable: SupportExhaustionPassiveFallbackResult = SupportExhaustionPassiveFallback.select_with_tickets(
		exhausted, combat, utility, pair, 0, 0)
	## The same exhausted catalogue with one malformed extra: the valid part has
	## nothing left, and it is STILL malformed input rather than unavailable.
	var malformed_pair: Array[PassiveCardDefinition] = _with(pair, _card("zz_bad", "Bad", PlayerStats.GLOBAL_DAMAGE, 0))
	var malformed: SupportExhaustionPassiveFallbackResult = SupportExhaustionPassiveFallback.select_with_tickets(
		exhausted, combat, utility, malformed_pair, 0, 0)
	var not_exhausted: SupportExhaustionPassiveFallbackResult = SupportExhaustionPassiveFallback.select_with_tickets(
		SupportContinuation.select(SkillSupportCatalogue.skill_profiles(), SkillSupportCatalogue.support_definitions(),
			_shipped(1, 1), 7), _source(cards, COMBAT, 0), _source(cards, UTILITY, 0), cards, 0, 0)
	var success: SupportExhaustionPassiveFallbackResult = SupportExhaustionPassiveFallback.select_with_tickets(
		exhausted, _source(cards, COMBAT, 0), _source(cards, UTILITY, 0), cards, 0, 0)
	_refusals += 3
	_expect(exhausted.is_exhausted() and not exhausted.ok, "the Support side is not exhausted")
	_expect(unavailable.is_unavailable() and not unavailable.ok, "the unavailable result reads %s" % unavailable.describe())
	_expect(not malformed.ok and not malformed.is_unavailable() and malformed.problem().is_empty(),
		"the malformed result reads %s" % malformed.describe())
	_expect(not not_exhausted.ok and not not_exhausted.is_unavailable(), "the non-exhausted refusal reads %s" % not_exhausted.describe())
	_expect(success.ok and not success.is_unavailable() and not success.unavailable, "the success reads %s" % success.describe())

	## Structurally: the classification is written once, read once, and never from text.
	var result_code: String = _code(RESULT_FILE)
	var mechanism_code: String = _code(FALLBACK_FILE)
	var parse: RegEx = RegEx.new()
	parse.compile("failure_reason\\s*(==|!=)|failure_reason\\.(contains|find|begins_with|ends_with|split|match|matchn|similarity|count)")
	_expect(result_code.count("unavailable = true") == 1
			and _function_body(result_code, "fallback_unavailable").contains("unavailable = true")
			and not _function_body(result_code, "is_unavailable").contains("failure_reason"),
		"the classification is written %d times" % result_code.count("unavailable = true"))
	_expect(parse.search_all(mechanism_code).size() == 0 and parse.search_all(result_code).size() == 0,
		"a new file inspects a refusal's text")
	_expect(mechanism_code.count("is_exhausted()") == 1 and mechanism_code.count(".exhausted") == 0,
		"the mechanism reads the Support classification %d times through its predicate" % mechanism_code.count("is_exhausted()"))
	print("  Support exhaustion: SupportContinuationResult.is_exhausted() %s | fallback unavailable: is_unavailable() %s, ok %s | malformed: ok %s, is_unavailable() %s | a non-exhausted Support refusal: is_unavailable() %s | a success: ok %s"
		% [exhausted.is_exhausted(), unavailable.is_unavailable(), unavailable.ok, malformed.ok,
			malformed.is_unavailable(), not_exhausted.is_unavailable(), success.ok])
	print("  the classification is written in 1 place and read by its predicate; neither new file inspects refusal text (0 matches); the mechanism reads the Support classification once, through is_exhausted()")
	_done("unavailable_malformed_and_support_exhaustion_are_mechanically_distinct")


# --- 17. Seeded reproduction ------------------------------------------------------------------------------------------

func _check_seeded_answers_reproduce_through_the_pure_core_and_a_frozen_corpus() -> void:
	print("")
	print("--- 17. Seeded answers reproduce exactly through the pure core, and a frozen corpus survives every reversal")
	var cards: Array[PassiveCardDefinition] = _cards()
	var combat: PassiveCardSelectionResult = _source(cards, COMBAT, 0)
	var utility: PassiveCardSelectionResult = _source(cards, UTILITY, 0)
	var exhausted: SupportContinuationResult = _exhausted()
	var reversed_cards: Array[PassiveCardDefinition] = _reversed(cards)
	var definitions: Array[SupportDefinition] = SkillSupportCatalogue.support_definitions()
	var reversed_definitions: Array[SupportDefinition] = []
	for position: int in range(definitions.size() - 1, -1, -1):
		reversed_definitions.append(definitions[position])
	var reversed_exhausted: SupportContinuationResult = SupportContinuation.select(
		SkillSupportCatalogue.skill_profiles(), reversed_definitions, _shipped(2, 2), 7)
	var reversed_combat: PassiveCardSelectionResult = _source(reversed_cards, COMBAT, 0)
	var reversed_utility: PassiveCardSelectionResult = _source(reversed_cards, UTILITY, 0)

	var exact: int = 0
	var delegated: int = 0
	var independent: int = 0
	var invariant: int = 0
	var reached: Dictionary = {}
	for row: Array in FALLBACK_CORPUS:
		var seed_value: int = int(row[0])
		var category_ticket: int = SupportExhaustionPassiveFallback.category_ticket_for(seed_value)
		var card_ticket: int = SupportExhaustionPassiveFallback.card_ticket_for(seed_value)
		var seeded: SupportExhaustionPassiveFallbackResult = SupportExhaustionPassiveFallback.select(
			exhausted, combat, utility, cards, seed_value)
		if seeded.ok and seeded.selected_category == int(row[1]) and String(seeded.selected_card_id) == String(row[2]) \
				and category_ticket == int(row[3]) and card_ticket == int(row[4]) \
				and seeded.category_ticket == category_ticket and seeded.card_ticket == card_ticket:
			exact += 1
		else:
			_expect(false, "seed %d gave %s at %d / %d" % [seed_value, seeded.describe(), category_ticket, card_ticket])
		if _derivation(seeded) == _derivation(SupportExhaustionPassiveFallback.select_with_tickets(
				exhausted, combat, utility, cards, category_ticket, card_ticket)):
			delegated += 1
		if category_ticket == _test_ticket(seed_value, EXPECTED_CATEGORY_STAGE_DOMAIN) \
				and card_ticket == _test_ticket(seed_value, EXPECTED_CARD_STAGE_DOMAIN):
			independent += 1
		if _derivation(seeded) == _derivation(SupportExhaustionPassiveFallback.select(
				reversed_exhausted, reversed_combat, reversed_utility, reversed_cards, seed_value)):
			invariant += 1
		reached[String(seeded.selected_card_id)] = true
	var rows: int = FALLBACK_CORPUS.size()
	_expect(exact == rows and delegated == rows and independent == rows and invariant == rows,
		"corpus: %d exact, %d delegated, %d independent, %d invariant of %d" % [exact, delegated, independent, invariant, rows])
	_expect(reached.size() == 4, "the corpus reaches %d of the 4 remaining cards" % reached.size())

	## The domains are the typed ones, distinct from every accepted domain and salt,
	## and so is each combined with the stream it is read through.
	var stream: int = 0x9E3779B9
	var domains_distinct: bool = SupportExhaustionPassiveFallback.CATEGORY_STAGE_DOMAIN == EXPECTED_CATEGORY_STAGE_DOMAIN \
		and SupportExhaustionPassiveFallback.CARD_STAGE_DOMAIN == EXPECTED_CARD_STAGE_DOMAIN \
		and SupportExhaustionPassiveFallback.STAGE_STREAM_CATEGORY == COMBAT
	for domain: int in [EXPECTED_CATEGORY_STAGE_DOMAIN, EXPECTED_CARD_STAGE_DOMAIN]:
		for accepted: int in LANE_DOMAINS + STREAM_SALTS:
			if domain == accepted or (domain ^ stream) == accepted:
				domains_distinct = false
		if (domain ^ stream) == 0:
			domains_distinct = false
	_expect(domains_distinct and EXPECTED_CATEGORY_STAGE_DOMAIN != EXPECTED_CARD_STAGE_DOMAIN,
		"a stage domain coincides with an accepted domain or salt")
	var first: String = _derivation(SupportExhaustionPassiveFallback.select(exhausted, combat, utility, cards, 12345))
	var drifted: int = 0
	for _call: int in REPEAT_CALLS:
		if _derivation(SupportExhaustionPassiveFallback.select(exhausted, combat, utility, cards, 12345)) != first:
			drifted += 1
	_expect(drifted == 0, "%d of %d repeats drifted" % [drifted, REPEAT_CALLS])
	var negative: int = 0
	for seed_value: int in [-1, -9223372036854775807, -4294967296, 0]:
		if SupportExhaustionPassiveFallback.category_ticket_for(seed_value) < 0 \
				or SupportExhaustionPassiveFallback.card_ticket_for(seed_value) < 0:
			negative += 1
	_expect(negative == 0, "%d seeded tickets were negative" % negative)
	print("  %d of %d frozen corpus rows exact (category, card and both raw tickets); %d reproduce through select_with_tickets(); %d match an independent in-suite derivation; %d are unchanged with card, source and Support arrays reversed; %d of 4 remaining cards reached"
		% [exact, rows, delegated, independent, invariant, reached.size()])
	print("  stage domains 0x%X (category) and 0x%X (card), read through the Combat and Defence stream: distinct from the 3 lane domains and 2 stream salts; %d of %d repeats drift; 0 negative tickets"
		% [EXPECTED_CATEGORY_STAGE_DOMAIN, EXPECTED_CARD_STAGE_DOMAIN, drifted, REPEAT_CALLS])
	print("  seed 51507111 (F3's worked support lane seed for root seed 18) -> category ticket 3141935186 -> Combat and Defence, card ticket 1617272035 -> card_power")
	_done("seeded_answers_reproduce_through_the_pure_core_and_a_frozen_corpus")


# --- 18. Copies -------------------------------------------------------------------------------------------------------

func _check_public_collections_are_copies() -> void:
	print("")
	print("--- 18. Every collection a reader is handed is a copy")
	var cards: Array[PassiveCardDefinition] = _cards()
	var result: SupportExhaustionPassiveFallbackResult = SupportExhaustionPassiveFallback.select_with_tickets(
		_exhausted(), _source(cards, COMBAT, 0), _source(cards, UTILITY, 0), cards, 0, 0)
	var before: String = _derivation(result)
	var before_text: String = result.describe()
	var categories: Array[int] = result.candidate_categories()
	categories.append(99)
	categories[0] = 42
	var excluded: Array[StringName] = result.excluded_card_ids()
	excluded.append(&"zz_intruder")
	excluded.clear()
	var nested: PassiveCardSelectionResult = result.selection()
	nested.candidate_ids.append(&"zz_intruder")
	nested.candidate_weights[0] = 1
	nested.selected_card_id = &"zz_intruder"
	nested.total_weight = 7
	var another: PassiveCardSelectionResult = result.selection()
	_expect(_derivation(result) == before and result.describe() == before_text and result.problem().is_empty(),
		"mutating returned collections changed the result: %s" % result.describe())
	_expect(another != nested and another.ladder_line() == "card_power x100, card_vitality x100",
		"a second selection() read %s" % another.ladder_line())
	var refusal: SupportExhaustionPassiveFallbackResult = SupportExhaustionPassiveFallbackResult.failed("x")
	refusal.candidate_categories().append(1)
	refusal.excluded_card_ids().append(&"x")
	_expect(refusal.candidate_categories().is_empty() and refusal.excluded_card_ids().is_empty()
			and refusal.selection() == null and refusal.problem().is_empty(),
		"a refusal's accessors leaked")
	print("  appending to, overwriting and clearing candidate_categories(), excluded_card_ids() and selection() changed 0 stored facts; each selection() is a new object; a refusal hands out empty copies and no draw")
	_done("public_collections_are_copies")


# --- 19. The selector extension ---------------------------------------------------------------------------------------

func _check_the_selector_extension_changes_no_ordinary_selection() -> void:
	print("")
	print("--- 19. The selector extension changes no ordinary selection, refusal or corpus row")
	var cards: Array[PassiveCardDefinition] = _cards()
	var none: Array[StringName] = []

	var corpus_exact: int = 0
	for row: Array in C3_CORPUS:
		var a: PassiveCardSelectionResult = PassiveCardSelection.select(cards, COMBAT, int(row[0]))
		var b: PassiveCardSelectionResult = PassiveCardSelection.select(cards, UTILITY, int(row[0]))
		if String(a.selected_card_id) == String(row[1]) and a.normalized_ticket == int(row[2]) \
				and String(b.selected_card_id) == String(row[3]) and b.normalized_ticket == int(row[4]):
			corpus_exact += 1
	_expect(corpus_exact == C3_CORPUS.size(), "%d of %d C3 corpus rows reproduce" % [corpus_exact, C3_CORPUS.size()])

	var compared: int = 0
	var moved: int = 0
	for records: Array[PassiveCardDefinition] in [cards, _reversed(cards)]:
		for category: int in [COMBAT, UTILITY]:
			for ticket: int in 300:
				compared += 1
				if _passive_derivation(PassiveCardSelection.select_with_ticket(records, category, ticket)) \
						!= _passive_derivation(PassiveCardSelection.select_with_ticket_excluding(records, category, ticket, none)):
					moved += 1
	_expect(moved == 0 and compared == 1200, "%d of %d empty-exclusion draws moved" % [moved, compared])

	## C3's refusals, reached through both entry points, and the moved record check.
	var with_null: Array[PassiveCardDefinition] = cards.duplicate()
	with_null.append(null)
	var empty: Array[PassiveCardDefinition] = []
	var ceiling: int = PassiveCardSelection.MAXIMUM_TOTAL_WEIGHT
	var over_ceiling: Array[PassiveCardDefinition] = [
		_card("zz_heavy_one", "Heavy One", PlayerStats.GLOBAL_DAMAGE, 4_000_000_000),
		_card("zz_heavy_two", "Heavy Two", PlayerStats.MAXIMUM_LIFE, ceiling - 3_999_999_999)]
	var refusal_rows: Array = [
		[empty, COMBAT, 0, "no passive card records were given", true],
		[with_null, COMBAT, 0, "a passive card record is null", true],
		[_with(cards, _card("", "Nameless", PlayerStats.GLOBAL_DAMAGE, 100)), COMBAT, 0, "must carry a stable id", true],
		[_with(cards, _card("zz_stray", "Stray", &"not_a_stat", 100)), COMBAT, 0, "not a recognised player stat", true],
		[_with(cards, _record(cards, POWER)), COMBAT, 0, "duplicate card id card_power among the supplied records", true],
		[cards, 99, 0, "99 is not a recognised passive card category", false],
		[_only(cards, UTILITY), COMBAT, 0, "no supplied passive card belongs to the Combat and Defence category", false],
		[cards, COMBAT, -5, "a ticket must not be negative (-5)", false],
		[over_ceiling, COMBAT, 0, "would exceed the ceiling", false],
	]
	var same: int = 0
	for row: Array in refusal_rows:
		var records: Array[PassiveCardDefinition] = row[0]
		var plain: PassiveCardSelectionResult = PassiveCardSelection.select_with_ticket(records, int(row[1]), int(row[2]))
		var extended: PassiveCardSelectionResult = PassiveCardSelection.select_with_ticket_excluding(records, int(row[1]), int(row[2]), none)
		_refusals += 2
		var records_fault: String = PassiveCardSelection.records_problem(records)
		## A record fault is reported by the moved check in exactly the draw's words;
		## every other refusal comes from a set the check calls coherent.
		var expected_fault: String = plain.failure_reason if bool(row[4]) else ""
		if not plain.ok and plain.failure_reason.contains(String(row[3])) \
				and _passive_derivation(plain) == _passive_derivation(extended) and plain.problem().is_empty() \
				and records_fault == expected_fault:
			same += 1
		else:
			_expect(false, "the refusal '%s' read '%s' / '%s' / records '%s'" % [
				String(row[3]), plain.failure_reason, extended.failure_reason, records_fault])
	_expect(same == refusal_rows.size(), "%d of %d accepted refusals unchanged" % [same, refusal_rows.size()])
	_expect(PassiveCardSelection.records_problem(cards).is_empty(), "the shipped set reports a record problem")

	## The extension's own refusals — and their precedence.
	var unknown: Array[StringName] = [&"zz_unknown"]
	var blank: Array[StringName] = [&""]
	var twice: Array[StringName] = [CELERITY, CELERITY]
	var every_combat: Array[StringName] = [CELERITY, POWER, VITALITY]
	var utility_only_excluding: Array[StringName] = [FLEETNESS]
	var extension_rows: Array = [
		[cards, COMBAT, unknown, "the excluded card id 'zz_unknown' is not among the supplied records"],
		[cards, COMBAT, blank, "the excluded card id '' is not among the supplied records"],
		[cards, COMBAT, twice, "the card id card_celerity is excluded more than once"],
		[cards, COMBAT, every_combat, "every supplied passive card in the Combat and Defence category is excluded"],
		[_only(cards, UTILITY), COMBAT, utility_only_excluding, "no supplied passive card belongs to the Combat and Defence category"],
		[_with(cards, _card("zz_stray", "Stray", &"not_a_stat", 100)), COMBAT, unknown, "not a recognised player stat"],
		[cards, 99, unknown, "99 is not a recognised passive card category"],
	]
	var extension_refused: int = 0
	for row: Array in extension_rows:
		var records: Array[PassiveCardDefinition] = row[0]
		var excluded: Array[StringName] = row[2]
		var result: PassiveCardSelectionResult = PassiveCardSelection.select_with_ticket_excluding(records, int(row[1]), 0, excluded)
		_refusals += 1
		if not result.ok and result.failure_reason.contains(String(row[3])) \
				and String(result.selected_card_id).is_empty() and result.candidate_ids.is_empty() \
				and result.problem().is_empty():
			extension_refused += 1
		else:
			_expect(false, "the extension refusal '%s' read '%s'" % [String(row[3]), result.failure_reason])
	_expect(extension_refused == extension_rows.size(), "%d of %d extension refusals" % [extension_refused, extension_rows.size()])

	## An excluded card in the other category changes nothing; one in this category owns nothing.
	var other_moved: int = 0
	var owners: Dictionary = {}
	var fleetness_only: Array[StringName] = [FLEETNESS]
	var celerity_only: Array[StringName] = [CELERITY]
	for ticket: int in 300:
		if _passive_derivation(PassiveCardSelection.select_with_ticket_excluding(cards, COMBAT, ticket, fleetness_only)) \
				!= _passive_derivation(PassiveCardSelection.select_with_ticket(cards, COMBAT, ticket)):
			other_moved += 1
	for ticket: int in 200:
		_count(owners, String(PassiveCardSelection.select_with_ticket_excluding(cards, COMBAT, ticket, celerity_only).selected_card_id))
	_expect(other_moved == 0, "excluding a Utility card moved %d Combat and Defence draws" % other_moved)
	_expect(int(owners.get("card_power", 0)) == 100 and int(owners.get("card_vitality", 0)) == 100 and owners.size() == 2,
		"excluding card_celerity left %s" % owners)

	## The accepted offer composition is unchanged, including its honest refusal.
	var profiles: Array[SkillTagProfile] = SkillSupportCatalogue.skill_profiles()
	var definitions: Array[SupportDefinition] = SkillSupportCatalogue.support_definitions()
	var offer: RiftOffer = RiftOfferComposition.compose(profiles, definitions, _shipped(1, 1), cards, 18)
	_expect(offer.ok and offer.seed_for(RiftOffer.Lane.SUPPORT) == 51507111 and offer.support_id == SWEEPING
			and offer.support_rank_before == 1 and offer.support_rank_after == 2
			and offer.combat_card_id == POWER and offer.utility_card_id == INSIGHT,
		"F3's worked example reads %s" % offer.describe())
	## MOVED ONE FOR ONE UNDER ROGUELITE FOUNDATION I7 (D-306): the exhausted composition no longer
	## refuses — its Support lane carries this fallback's own card for the same seed.
	var fallback_offer: RiftOffer = RiftOfferComposition.compose(profiles, definitions, _shipped(2, 2), cards, 18)
	_expect(fallback_offer.ok and fallback_offer.problem().is_empty()
			and fallback_offer.support_content_kind == RiftOffer.SupportContentKind.PASSIVE_FALLBACK
			and fallback_offer.support_fallback_card_id == CELERITY,
		"the exhausted composition reads %s" % fallback_offer.describe())
	print("  %d of %d C3 corpus rows exact; %d draws over both orders and both categories identical through select_with_ticket() and the empty exclusion; %d of %d accepted refusals unchanged, the record check returning each record fault's own words"
		% [corpus_exact, C3_CORPUS.size(), compared, same, refusal_rows.size()])
	print("  %d of %d extension refusals (unknown or blank id, an id twice, every card excluded, no card in the category, and record and category faults taking precedence); excluding a Utility card moves %d Combat and Defence draws; excluding card_celerity leaves card_power 100, card_vitality 100"
		% [extension_refused, extension_rows.size(), other_moved])
	print("  root seed 18: Support quick_strike -> sweeping_edge 1 -> 2, card_power, card_insight; both pairs at rank 2: the offer composes the I7 passive fallback card_celerity (D-306)")
	_done("the_selector_extension_changes_no_ordinary_selection")


# --- 20. Support unchanged --------------------------------------------------------------------------------------------

func _check_support_continuation_and_exhaustion_are_unchanged() -> void:
	print("")
	print("--- 20. Support continuation and I5 exhaustion are unchanged")
	var unchanged: int = 0
	for row: Array in ACCEPTED_HASHES:
		var digest: String = FileAccess.get_sha256(String(row[0]))
		if digest.begins_with(String(row[1])):
			unchanged += 1
		else:
			_expect(false, "%s hashes %s, not %s…" % [String(row[0]), digest.left(8), String(row[1])])
	_expect(unchanged == ACCEPTED_HASHES.size(), "%d of %d accepted files unchanged" % [unchanged, ACCEPTED_HASHES.size()])

	var profiles: Array[SkillTagProfile] = SkillSupportCatalogue.skill_profiles()
	var definitions: Array[SupportDefinition] = SkillSupportCatalogue.support_definitions()
	var kinds: Dictionary = {}
	var wrong: int = 0
	for reaching: int in 3:
		for sweeping: int in 3:
			var held: AcquiredSupports = _shipped(reaching, sweeping)
			var expected: String = "new pair"
			if reaching >= 1 and sweeping >= 1:
				expected = "rank increase"
			if reaching == 2 and sweeping == 2:
				expected = "exhausted"
			for seed_value: int in SEED_SAMPLES:
				var result: SupportContinuationResult = SupportContinuation.select(profiles, definitions, held, seed_value)
				var kind: String = "refused"
				if result.is_new_pair():
					kind = "new pair"
				elif result.is_rank_increase():
					kind = "rank increase"
				elif result.is_exhausted() and result.failure_reason == EXHAUSTION_REASON:
					kind = "exhausted"
				_count(kinds, kind)
				if kind != expected:
					wrong += 1
	_expect(wrong == 0 and int(kinds.get("new pair", 0)) == 5 * SEED_SAMPLES
			and int(kinds.get("rank increase", 0)) == 3 * SEED_SAMPLES and int(kinds.get("exhausted", 0)) == SEED_SAMPLES,
		"the 9 shipped states classified %s, %d unexpected" % [kinds, wrong])
	var maxima: PackedStringArray = PackedStringArray()
	for definition: SupportDefinition in definitions:
		maxima.append("%s %d" % [definition.support_id(), definition.maximum_rank])
	_expect(", ".join(maxima) == "reaching_edge 2, sweeping_edge 2", "the maxima read %s" % ", ".join(maxima))
	print("  %d of %d accepted production files byte-identical by SHA-256 prefix — the definition, selector, its result, catalogue, continuation, its result, offer, composer, choice, ledger, level-up, run build, card records, the I4 seam and project.godot"
		% [unchanged, ACCEPTED_HASHES.size()])
	print("  9 shipped states x %d seeds: %d new pairs, %d rank increases, %d exhausted with the accepted reason, %d unexpected; maximum ranks [%s]"
		% [SEED_SAMPLES, int(kinds.get("new pair", 0)), int(kinds.get("rank increase", 0)), int(kinds.get("exhausted", 0)),
			wrong, ", ".join(maxima)])
	_done("support_continuation_and_exhaustion_are_unchanged")


# --- 21. Generic, stateless, unwired ----------------------------------------------------------------------------------

func _check_the_fallback_is_generic_stateless_and_unwired() -> void:
	print("")
	print("--- 21. The fallback names nothing concrete, reads nothing ambient, copies no ladder and runs nowhere")
	var concrete: int = 0
	var ambient: int = 0
	var implementation: int = 0
	for path: String in NEW_FILES:
		var raw: String = FileAccess.get_file_as_string(path)
		var code: String = _code(path)
		var named: PackedStringArray = PackedStringArray()
		for token: String in CONCRETE_TOKENS:
			if raw.contains(token):
				named.append(token)
				concrete += 1
		for token: String in AMBIENT_TOKENS:
			if raw.contains(token):
				named.append(token)
				ambient += 1
		var copied: PackedStringArray = PackedStringArray()
		var forbidden: Array[String] = CODE_FORBIDDEN_TOKENS.duplicate()
		if path == FALLBACK_FILE:
			forbidden.append_array(MECHANISM_FORBIDDEN_TOKENS)
		for token: String in forbidden:
			if code.contains(token):
				copied.append(token)
		implementation += copied.size()
		_expect(named.is_empty(), "%s names %s" % [path.get_file(), ", ".join(named)])
		_expect(copied.is_empty(), "%s touches %s in code" % [path.get_file(), ", ".join(copied)])
	var own: String = FileAccess.get_file_as_string("res://tests/support_exhaustion_passive_fallback_verification.gd")
	var found_here: int = 0
	for token: String in CONCRETE_TOKENS + AMBIENT_TOKENS + CODE_FORBIDDEN_TOKENS:
		if own.contains(token):
			found_here += 1
	_expect(found_here >= 30, "the scans found only %d of their tokens in this suite and may be inert" % found_here)

	## The exact class set each file names, from the engine's own class list.
	var project_classes: PackedStringArray = PackedStringArray()
	for entry: Dictionary in ProjectSettings.get_global_class_list():
		project_classes.append(String(entry.get("class", "")))
	project_classes.sort()
	_expect(project_classes.has(NEW_CLASSES[0]) and project_classes.has(NEW_CLASSES[1]) and project_classes.size() > 150,
		"the engine lists %d classes and not both new ones" % project_classes.size())
	for row: Array in EXPECTED_NAMED_CLASSES:
		var source: String = FileAccess.get_file_as_string(String(row[0]))
		var actually: PackedStringArray = PackedStringArray()
		for class_id: String in project_classes:
			if not class_id.is_empty() and source.contains(class_id):
				actually.append(class_id)
		var wanted: PackedStringArray = PackedStringArray()
		for class_id: String in row[1]:
			wanted.append(class_id)
		wanted.sort()
		_expect(", ".join(actually) == ", ".join(wanted), "%s names [%s]" % [String(row[0]).get_file(), ", ".join(actually)])

	## Shape: methods, fields, and no state.
	_expect(", ".join(_methods_of(FALLBACK_FILE)) == ", ".join(EXPECTED_FALLBACK_METHODS),
		"the mechanism declares %s" % ", ".join(_methods_of(FALLBACK_FILE)))
	_expect(", ".join(_methods_of(RESULT_FILE)) == ", ".join(EXPECTED_RESULT_METHODS),
		"the result declares %s" % ", ".join(_methods_of(RESULT_FILE)))
	_expect(", ".join(_methods_of(SELECTOR_FILE)) == ", ".join(EXPECTED_SELECTOR_METHODS),
		"the selector declares %s" % ", ".join(_methods_of(SELECTOR_FILE)))
	var result_fields: PackedStringArray = _script_fields(SupportExhaustionPassiveFallbackResult.new())
	var mechanism_fields: PackedStringArray = _script_fields(SupportExhaustionPassiveFallback.new())
	var selector_fields: PackedStringArray = _script_fields(PassiveCardSelection.new())
	_expect(", ".join(result_fields) == ", ".join(EXPECTED_RESULT_FIELDS), "the result carries %s" % ", ".join(result_fields))
	_expect(mechanism_fields.is_empty() and selector_fields.is_empty(),
		"state: mechanism [%s], selector [%s]" % [", ".join(mechanism_fields), ", ".join(selector_fields)])

	## It delegates rather than copies.
	var mechanism_code: String = _code(FALLBACK_FILE)
	_expect(mechanism_code.contains("PassiveCardSelection.records_problem(")
			and mechanism_code.contains("PassiveCardSelection.select_with_ticket_excluding(")
			and mechanism_code.count("PassiveCardSelection.ticket_for(") == 2
			and not mechanism_code.contains("PassiveCardSelection.select_with_ticket(")
			and not mechanism_code.contains("PassiveCardSelection.select(")
			and mechanism_code.contains("var draw_problem: String = draw.problem()"),
		"the mechanism does not delegate as documented")

	## Nothing runs it.
	var scanned: int = 0
	var referenced: PackedStringArray = PackedStringArray()
	for root: String in SCANNED_ROOTS:
		for path: String in _files_under(root, [".gd", ".tscn", ".tres"]):
			if NEW_FILES.has(path):
				continue
			scanned += 1
			if COMPOSING_READERS.has(path):
				continue
			var text: String = FileAccess.get_file_as_string(path)
			for name: String in NEW_CLASSES:
				if text.contains(name):
					referenced.append("%s names %s" % [path.get_file(), name])
	var settings: String = FileAccess.get_file_as_string(PROJECT_SETTINGS_FILE)
	for name: String in NEW_CLASSES:
		if settings.contains(name):
			referenced.append("project.godot names %s" % name)
	_expect(scanned > 100 and referenced.is_empty() and not settings.contains("[autoload]"),
		"%d files scanned; referenced by %s" % [scanned, ", ".join(referenced)])
	_expect(_action_count() == EXPECTED_ACTIONS
			and String(ProjectSettings.get_setting("application/run/main_scene", "")) == ENTRYPOINT,
		"project.godot holds %d actions and entrypoint %s" % [_action_count(),
			ProjectSettings.get_setting("application/run/main_scene", "")])
	var directory: PackedStringArray = PackedStringArray()
	var dir: DirAccess = DirAccess.open("res://scripts/fallback")
	if dir != null:
		for entry: String in dir.get_files():
			directory.append(entry)
	directory.sort()
	_expect(", ".join(directory) == "support_exhaustion_passive_fallback.gd, support_exhaustion_passive_fallback.gd.uid, support_exhaustion_passive_fallback_result.gd, support_exhaustion_passive_fallback_result.gd.uid",
		"scripts/fallback/ holds %s" % ", ".join(directory))

	## The allowlist moves I6 made are present and earned.
	var granted: int = 0
	for row: Array in GRANTING_SUITES:
		var suite: String = FileAccess.get_file_as_string(String(row[0]))
		var all_listed: bool = true
		for path: String in row[2]:
			if not suite.contains(path):
				all_listed = false
		if all_listed:
			granted += 1
		else:
			_expect(false, "the Foundation %s suite does not grant %s" % [String(row[1]), row[2]])
	var i5: String = FileAccess.get_file_as_string(I5_SUITE)
	_expect(granted == GRANTING_SUITES.size()
			and i5.contains("[\"is_exhausted(\", [\"support_continuation_result.gd\", \"support_exhaustion_passive_fallback.gd\", \"rift_offer_composition.gd\", \"rift_offer.gd\"]]"),
		"%d of %d granting suites list the new files; I5 grants is_exhausted( as moved: %s" % [
			granted, GRANTING_SUITES.size(), i5.contains("support_exhaustion_passive_fallback.gd")])

	## The six shipped records, unchanged.
	var records_right: int = 0
	var cards: Array[PassiveCardDefinition] = _cards()
	for row: Array in SHIPPED_CARDS:
		var record: PassiveCardDefinition = _record(cards, StringName(String(row[0])))
		if record != null and String(record.stat_id) == String(row[1]) and is_equal_approx(record.magnitude, float(row[2])) \
				and record.base_weight == 100 and record.repeatable and record.problem().is_empty():
			records_right += 1
	_expect(records_right == 6 and cards.size() == 6, "%d of 6 shipped records unchanged" % records_right)
	print("  2 files scanned raw: %d concrete names, %d ambient reads; %d ladder or card-field tokens in code; the mechanism names exactly [%s]"
		% [concrete, ambient, implementation, ", ".join(EXPECTED_NAMED_CLASSES[0][1])])
	print("  methods pinned: mechanism %d, result %d, selector %d; the result carries %d fields; mechanism and selector state: 0 fields"
		% [EXPECTED_FALLBACK_METHODS.size(), EXPECTED_RESULT_METHODS.size(), EXPECTED_SELECTOR_METHODS.size(), result_fields.size()])
	print("  %d running files scanned: none beyond the 2 granted offer files names either new class; project.godot: %d actions, the Prototype App entrypoint, no [autoload]; scripts/fallback/ holds its 2 scripts and 2 uid files; %d of 4 granting suites and I5 list the new files; 6 of 6 shipped records unchanged"
		% [scanned, _action_count(), granted])
	_done("the_fallback_is_generic_stateless_and_unwired")


# --- Helpers -----------------------------------------------------------------------------------------------------------

func _cards() -> Array[PassiveCardDefinition]:
	return PassiveCardCatalogue.records()


func _source(records: Array[PassiveCardDefinition], category: int, ticket: int) -> PassiveCardSelectionResult:
	return PassiveCardSelection.select_with_ticket(records, category, ticket)


func _exhausted() -> SupportContinuationResult:
	return SupportContinuation.select(SkillSupportCatalogue.skill_profiles(),
		SkillSupportCatalogue.support_definitions(), _shipped(2, 2), 7)


## A fabricated card. Test data only; not canon.
func _card(card_id: String, display: String, stat_id: StringName, weight: int) -> PassiveCardDefinition:
	return PassiveCardDefinition.of(StringName(card_id), display, stat_id, 0.10, weight, true)


func _record(records: Array[PassiveCardDefinition], card_id: StringName) -> PassiveCardDefinition:
	for record: PassiveCardDefinition in records:
		if record != null and record.card_id == card_id:
			return record
	return null


func _with(records: Array[PassiveCardDefinition], extra: PassiveCardDefinition) -> Array[PassiveCardDefinition]:
	var out: Array[PassiveCardDefinition] = records.duplicate()
	out.append(extra)
	return out


func _only(records: Array[PassiveCardDefinition], category: int) -> Array[PassiveCardDefinition]:
	var out: Array[PassiveCardDefinition] = []
	for record: PassiveCardDefinition in records:
		if record.category() == category:
			out.append(record)
	return out


func _replaced(records: Array[PassiveCardDefinition], card_id: StringName,
		replacement: PassiveCardDefinition) -> Array[PassiveCardDefinition]:
	var out: Array[PassiveCardDefinition] = []
	for record: PassiveCardDefinition in records:
		out.append(replacement if record.card_id == card_id else record)
	return out


## The same card with exactly one fault introduced.
func _faulted(card: PassiveCardDefinition, kind: String) -> PassiveCardDefinition:
	match kind:
		"weight":
			return PassiveCardDefinition.of(card.card_id, card.display_name, card.stat_id,
				card.magnitude, 0, card.repeatable)
		"id":
			return PassiveCardDefinition.of(StringName(String(card.card_id).replace("_", " ")),
				card.display_name, card.stat_id, card.magnitude, card.base_weight, card.repeatable)
		"magnitude":
			return PassiveCardDefinition.of(card.card_id, card.display_name, card.stat_id,
				-card.magnitude, card.base_weight, card.repeatable)
	return card


func _shipped(reaching: int, sweeping: int) -> AcquiredSupports:
	return _fabricated([[QUICK_STRIKE, REACHING, reaching], [QUICK_STRIKE, SWEEPING, sweeping]])


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


## Every answer over the complete 2 x 200 grid, sources drawn at ticket 0 from
## `source_records` and the fallback run over `records`.
func _grid(continuation: SupportContinuationResult, source_records: Array[PassiveCardDefinition],
		records: Array[PassiveCardDefinition]) -> PackedStringArray:
	var combat: PassiveCardSelectionResult = _source(source_records, COMBAT, 0)
	var utility: PassiveCardSelectionResult = _source(source_records, UTILITY, 0)
	var out: PackedStringArray = PackedStringArray()
	for category_ticket: int in 2:
		for card_ticket: int in 200:
			out.append(_derivation(SupportExhaustionPassiveFallback.select_with_tickets(
				continuation, combat, utility, records, category_ticket, card_ticket)))
	return out


func _differences(a: PackedStringArray, b: PackedStringArray) -> int:
	if a.size() != b.size():
		return maxi(a.size(), b.size())
	var different: int = 0
	for index: int in a.size():
		if a[index] != b[index]:
			different += 1
	return different


## The WHOLE derivation as one string.
func _derivation(result: SupportExhaustionPassiveFallbackResult) -> String:
	var nested: PassiveCardSelectionResult = result.selection()
	return "ok=%s unavailable=%s reason='%s' category=%d card=%s tickets=%d/%d normalized=%d categories=%s excluded=%s nested=%s" % [
		result.ok, result.unavailable, result.failure_reason, result.selected_category,
		result.selected_card_id, result.category_ticket, result.card_ticket,
		result.normalized_category_ticket, str(result.candidate_categories()),
		str(result.excluded_card_ids()), "none" if nested == null else _passive_derivation(nested),
	]


func _passive_derivation(result: PassiveCardSelectionResult) -> String:
	return "ok=%s reason='%s' category=%d ladder=[%s] total=%d ticket=%d selected=%s" % [
		result.ok, result.failure_reason, result.requested_category, result.ladder_line(),
		result.total_weight, result.normalized_ticket, result.selected_card_id,
	]


## A refusal that carries nothing but its reason: no category, card, ticket,
## candidate or nested draw, and a coherent record.
func _is_bare_refusal(result: SupportExhaustionPassiveFallbackResult) -> bool:
	return result != null and not result.ok and not result.failure_reason.strip_edges().is_empty() \
		and result.selected_category == SupportExhaustionPassiveFallbackResult.UNRESOLVED_CATEGORY \
		and String(result.selected_card_id).is_empty() and result.category_ticket == 0 \
		and result.card_ticket == 0 and result.normalized_category_ticket == 0 \
		and result.candidate_categories().is_empty() and result.excluded_card_ids().is_empty() \
		and result.selection() == null and result.problem().is_empty()


## An ORDINARY refusal (never unavailable) naming `fragment`, with no partial fallback.
func _refuses(result: SupportExhaustionPassiveFallbackResult, fragment: String) -> bool:
	return _is_bare_refusal(result) and not result.is_unavailable() and not result.unavailable \
		and result.failure_reason.contains(fragment)


func _count(tally: Dictionary, key: Variant) -> void:
	tally[key] = int(tally.get(key, 0)) + 1


func _owner_line(owners: Dictionary) -> String:
	var keys: PackedStringArray = PackedStringArray()
	for key: Variant in owners:
		keys.append(String(key))
	keys.sort()
	var parts: PackedStringArray = PackedStringArray()
	for key: String in keys:
		parts.append("%s %d" % [key, int(owners[key])])
	return ", ".join(parts)


## An in-suite derivation of a stage ticket, written from the documented formula
## rather than calling the stream: mix((seed ^ domain) ^ the first category salt).
func _test_ticket(seed_value: int, domain: int) -> int:
	return _test_mix(((seed_value ^ domain) & 0xFFFFFFFF) ^ 0x9E3779B9)


func _test_mix(value: int) -> int:
	var x: int = value & 0xFFFFFFFF
	x = (x ^ (x >> 16)) * 0x7FEB_352D & 0xFFFFFFFF
	x = (x ^ (x >> 15)) * 0x846C_A68B & 0xFFFFFFFF
	x = x ^ (x >> 16)
	return x & 0xFFFFFFFF


## A file's source with every comment line removed.
func _code(path: String) -> String:
	var kept: PackedStringArray = PackedStringArray()
	for line: String in FileAccess.get_file_as_string(path).split("\n"):
		if line.strip_edges().begins_with("#"):
			continue
		kept.append(line)
	return "\n".join(kept)


func _function_body(source: String, name: String) -> String:
	var start: int = source.find("func %s(" % name)
	if start < 0:
		return ""
	var rest: String = source.substr(start)
	var end: int = rest.length()
	for marker: String in ["\nfunc ", "\nstatic func "]:
		var at: int = rest.find(marker, 1)
		if at > 0 and at < end:
			end = at
	return rest.substr(0, end)


func _methods_of(path: String) -> PackedStringArray:
	var out: PackedStringArray = PackedStringArray()
	var script: GDScript = load(path) as GDScript
	if script == null:
		return out
	for entry: Dictionary in script.get_script_method_list():
		out.append(String(entry.get("name", "")))
	return out


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


func _ids_of(records: Array) -> String:
	var out: PackedStringArray = PackedStringArray()
	for record: Variant in records:
		out.append(String((record as PassiveCardDefinition).card_id) if record != null else "<null>")
	return ", ".join(out)


func _reversed(records: Array[PassiveCardDefinition]) -> Array[PassiveCardDefinition]:
	var out: Array[PassiveCardDefinition] = []
	for index: int in range(records.size() - 1, -1, -1):
		out.append(records[index])
	return out


func _rotated(records: Array[PassiveCardDefinition], by: int) -> Array[PassiveCardDefinition]:
	var out: Array[PassiveCardDefinition] = []
	for index: int in records.size():
		out.append(records[(index + by) % records.size()])
	return out


func _interleaved(records: Array[PassiveCardDefinition]) -> Array[PassiveCardDefinition]:
	var out: Array[PassiveCardDefinition] = []
	var low: int = 0
	var high: int = records.size() - 1
	while low <= high:
		out.append(records[low])
		if low != high:
			out.append(records[high])
		low += 1
		high -= 1
	return out


func _files_under(root: String, extensions: Array[String]) -> PackedStringArray:
	var out: PackedStringArray = PackedStringArray()
	var dir: DirAccess = DirAccess.open(root)
	if dir == null:
		return out
	dir.list_dir_begin()
	var entry: String = dir.get_next()
	while not entry.is_empty():
		if entry != "." and entry != "..":
			var full: String = root.path_join(entry)
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
