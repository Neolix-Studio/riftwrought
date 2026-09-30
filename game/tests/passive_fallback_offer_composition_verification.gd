extends SceneTree
## Riftwrought — Roguelite Foundation I7 verification: Exhausted-Support
## Passive-Fallback Offer Composition (decision D-306).
##
## ONE FOCUSED HEADLESS TEST, run as a `SceneTree` script exactly as every earlier
## foundation's suite is. I7 edits two pure-logic files — the accepted offer record
## and its composer — so it needs no scene, no camera and no evidence frame.
##
## IT PORTS D-211's OWED-SET DISCIPLINE: every check records reaching its LAST
## line, and the set is compared with what the suite owes in both directions.
##
## "UNCHANGED" IS A BEFORE/AFTER MEASUREMENT, NOT A RE-READING. Before the first
## I7 edit, the accepted composer composed a corpus of every non-exhausted shipped
## state over 522 root seeds, plus a corpus of non-exhausted refusals, and the
## SHA-256 of each was recorded. This suite recomposes both with the same row
## formatter and requires the same digests.
##
## THE EXHAUSTED EXAMPLES WERE COMPUTED OUTSIDE THE ENGINE FIRST, by an independent
## re-implementation of the lane domains, the passive stream and the two I6 stage
## domains, and only then pinned here.
##
## THE TEST DATA IS NOT CONTENT. Every fabricated card and forged result below
## lives in this file only and is not canon.
##
## ROGUELITE FOUNDATION I8 (D-308) MOVED THIS SUITE ONE FOR ONE AND ADDED NO
## ASSERTION. I8 made the choice transaction consume a fallback Support lane, so
## check 12 now proves that consumption where it proved a refusal (same three
## assertions, renamed); check 13 grants the two choice files the five
## Support-content members they now name; check 16 pins those two files at their
## D-308 hashes; and three printed lines say "the choice transaction" where they
## said "the unchanged choice transaction". The count did not move.

const OFFER_FILE: String = "res://scripts/offers/rift_offer.gd"
const COMPOSER_FILE: String = "res://scripts/offers/rift_offer_composition.gd"
const FALLBACK_FILE: String = "res://scripts/fallback/support_exhaustion_passive_fallback.gd"
const FALLBACK_RESULT_FILE: String = "res://scripts/fallback/support_exhaustion_passive_fallback_result.gd"
const D1_FILES: Array[String] = [OFFER_FILE, COMPOSER_FILE]

const COMBAT: int = PlayerStatDefinition.Category.COMBAT_DEFENCE
const UTILITY: int = PlayerStatDefinition.Category.UTILITY
const SUPPORT_LANE: int = RiftOffer.Lane.SUPPORT
const COMBAT_LANE: int = RiftOffer.Lane.COMBAT_DEFENCE
const UTILITY_LANE: int = RiftOffer.Lane.UTILITY
const FALLBACK_KIND: int = RiftOffer.SupportContentKind.PASSIVE_FALLBACK
const PROGRESSION_KIND: int = RiftOffer.SupportContentKind.SUPPORT_PROGRESSION

const CELERITY: StringName = &"card_celerity"
const POWER: StringName = &"card_power"
const VITALITY: StringName = &"card_vitality"
const FLEETNESS: StringName = &"card_fleetness"
const INSIGHT: StringName = &"card_insight"
const MAGNETISM: StringName = &"card_magnetism"
const QUICK_STRIKE: StringName = &"quick_strike"
const REACHING: StringName = &"reaching_edge"
const SWEEPING: StringName = &"sweeping_edge"

## The accepted reasons, pinned so an unchanged mechanism is a measurement.
const EXHAUSTION_REASON: String = "the support lane is exhausted: every compatible support pair is already held at its maximum supported rank, so nothing new can be selected and nothing held can be raised"
const UNAVAILABLE_REASON: String = "no passive card remains in either category once the two cards this offer already carries are excluded"
## Replaced one for one under Roguelite Foundation I8 (D-308): the I7 constant here was the
## unchanged transaction's refusal of a fallback Support lane, which I8 retired. This is
## what the unchanged one-level receipt reports once that lane is consumed — RECORDED in
## check 12, not decided by it.
##
## Replaced one for one again under Roguelite Foundation I9 (D-310). I8's constant here was
## the then-unchanged receipt's own verdict on a consumed fallback — 'the Support lane
## granted 1 identifiers, not 2' — and I9 extended the receipt to record the Support content
## kind and the fallback category. This is that receipt's fallback line for the worked
## example, typed here; check 12 still records it rather than deciding it.
const E2_FALLBACK_RECEIPT_LINE: String = "passive fallback: card_celerity, drawn from Combat and Defence"
const NOT_ATTEMPTED_NOTE: String = "; the exhausted Support lane's passive fallback was not attempted"

## THE PRE-I7 DIGESTS, measured with the accepted composer before the first edit.
const PRE_I7_ROWS: int = 4698
const PRE_I7_DIGEST: String = "5976e0b070b7c4338836d3e132aad625c89463e9e3a6f5aa12eb17bdd47904d3"
const PRE_I7_REFUSAL_ROWS: int = 960
const PRE_I7_REFUSAL_DIGEST: String = "dae784d6e43a2588887f8ef402e16b9a103198495a3f9b20886b80a6b1eb57ad"
const SPECIAL_SEEDS: Array[int] = [
	-1, -12345, 2147483647, 4294967295, 4294967296, 9223372036854775807,
	-9223372036854775807 - 1, 51507111, 1000000007, 99991,
]

## Root seed 18 with both shipped supports at rank 2, every value typed.
const EXAMPLE_DESCRIBE: String = "root seed 18 [Support 51507111, Combat and Defence 1168206400, Utility 3720129402] — Support: card_celerity; Combat and Defence: card_power; Utility: card_insight"
const EXAMPLE_FALLBACK_LINE: String = "passive fallback: Combat and Defence: card_celerity from category position 0 of 2 [Combat and Defence, Utility], excluding [card_power, card_insight]; Combat and Defence: card_celerity from ticket 35 of 200 over [card_celerity x100, card_vitality x100]"

## root seed, Support / Combat and Defence / Utility lane seeds, the two ordinary
## cards, raw category ticket, raw card ticket, fallback category, fallback card —
## with both shipped supports at their maximum. COMPUTED OUTSIDE THE ENGINE FIRST.
const EXHAUSTED_CORPUS: Array = [
	[0, 2074702303, 856502828, 83415710, "card_vitality", "card_magnetism", 3025064388, 3245500459, 0, "card_celerity"],
	[1, 1992569692, 1644117255, 1136996714, "card_celerity", "card_fleetness", 1324834158, 2158650044, 0, "card_power"],
	[3, 721961813, 1354442878, 538578972, "card_power", "card_fleetness", 2121915000, 3499162600, 0, "card_celerity"],
	[7, 4138976552, 605881410, 197629295, "card_power", "card_fleetness", 2855316324, 4131862758, 0, "card_vitality"],
	[18, 51507111, 1168206400, 3720129402, "card_power", "card_insight", 3141935186, 1617272035, 0, "card_celerity"],
	[42, 707968515, 3998878852, 3512831560, "card_vitality", "card_fleetness", 349586754, 927642626, 0, "card_celerity"],
	[257, 3492135287, 573141247, 791363066, "card_celerity", "card_magnetism", 2462375119, 3073730544, 1, "card_insight"],
	[999, 4103667829, 2113307790, 2221117341, "card_celerity", "card_fleetness", 2763427806, 2761486096, 0, "card_power"],
	[12345, 1009438761, 612468971, 1162198605, "card_vitality", "card_insight", 3529226384, 3300522950, 0, "card_power"],
	[99991, 1939204551, 4169958103, 197201829, "card_power", "card_fleetness", 1446851370, 1370592164, 0, "card_vitality"],
	[2147483647, 1166519778, 748253319, 3235043907, "card_power", "card_insight", 2785819467, 842211073, 1, "card_fleetness"],
	[-1, 326752841, 771551199, 3101234265, "card_power", "card_magnetism", 4099794208, 1489440417, 0, "card_celerity"],
	[-12345, 4230437894, 921368375, 776091310, "card_power", "card_fleetness", 4169529293, 1452818790, 1, "card_magnetism"],
	[1000000007, 2357638753, 995110969, 483406264, "card_celerity", "card_magnetism", 1888953122, 3482953039, 0, "card_power"],
	[9223372036854775807, 326752841, 771551199, 3101234265, "card_power", "card_magnetism", 4099794208, 1489440417, 0, "card_celerity"],
	[4294967296, 2074702303, 856502828, 83415710, "card_vitality", "card_magnetism", 3025064388, 3245500459, 0, "card_celerity"],
	[-9223372036854775807 - 1, 2074702303, 856502828, 83415710, "card_vitality", "card_magnetism", 3025064388, 3245500459, 0, "card_celerity"],
]

## Foundation D1's pinned corpus, copied verbatim (D-239) and compared below with the
## D1 and F3 suites' own constants: root seed, three lane seeds, Skill, support,
## Combat and Defence card, Utility card.
const D1_SEED_CORPUS: Array = [
	[0, 2074702303, 856502828, 83415710,
		"quick_strike", "reaching_edge", "card_vitality", "card_magnetism"],
	[1, 1992569692, 1644117255, 1136996714,
		"quick_strike", "sweeping_edge", "card_celerity", "card_fleetness"],
	[3, 721961813, 1354442878, 538578972,
		"quick_strike", "reaching_edge", "card_power", "card_fleetness"],
	[7, 4138976552, 605881410, 197629295,
		"quick_strike", "reaching_edge", "card_power", "card_fleetness"],
	[42, 707968515, 3998878852, 3512831560,
		"quick_strike", "reaching_edge", "card_vitality", "card_fleetness"],
	[257, 3492135287, 573141247, 791363066,
		"quick_strike", "reaching_edge", "card_celerity", "card_magnetism"],
	[999, 4103667829, 2113307790, 2221117341,
		"quick_strike", "reaching_edge", "card_celerity", "card_fleetness"],
	[12345, 1009438761, 612468971, 1162198605,
		"quick_strike", "sweeping_edge", "card_vitality", "card_insight"],
	[99991, 1939204551, 4169958103, 197201829,
		"quick_strike", "reaching_edge", "card_power", "card_fleetness"],
	[2147483647, 1166519778, 748253319, 3235043907,
		"quick_strike", "sweeping_edge", "card_power", "card_insight"],
	[-1, 326752841, 771551199, 3101234265,
		"quick_strike", "reaching_edge", "card_power", "card_magnetism"],
	[-12345, 4230437894, 921368375, 776091310,
		"quick_strike", "reaching_edge", "card_power", "card_fleetness"],
	[1000000007, 2357638753, 995110969, 483406264,
		"quick_strike", "sweeping_edge", "card_celerity", "card_magnetism"],
	[9223372036854775807, 326752841, 771551199, 3101234265,
		"quick_strike", "reaching_edge", "card_power", "card_magnetism"],
]
const D1_SUITE: String = "res://tests/rift_offer_composition_verification.gd"
const F3_SUITE: String = "res://tests/rank_aware_offer_composition_verification.gd"
const I5_SUITE: String = "res://tests/maximum_rank_support_filtering_verification.gd"
const I6_SUITE: String = "res://tests/support_exhaustion_passive_fallback_verification.gd"
const D1_RUNNER: String = "res://tests/rift_offer_composition_smoke.sh"
const I5_RUNNER: String = "res://tests/maximum_rank_support_filtering_smoke.sh"
const I6_RUNNER: String = "res://tests/support_exhaustion_passive_fallback_smoke.sh"

## The two edited files, by the SHA-256 prefix each holds after D-306.
const EDITED_HASHES: Array = [
	[OFFER_FILE, "9bc94208"],
	[COMPOSER_FILE, "15ef203a"],
]

## Accepted files I7 must not touch, by the SHA-256 prefix each held before the
## first I7 edit: the I6 mechanism, the selectors, the choice transaction, the
## level-up coordinators and receipts, the run build, the live-effect seam, the
## running review and its panel, and project.godot.
const UNCHANGED_HASHES: Array = [
	["res://scripts/fallback/support_exhaustion_passive_fallback.gd", "c1cad5e4"],
	["res://scripts/fallback/support_exhaustion_passive_fallback_result.gd", "a195665f"],
	["res://scripts/stats/passive_card_selection.gd", "833cd25b"],
	["res://scripts/stats/passive_card_selection_result.gd", "05a74cb3"],
	["res://scripts/stats/passive_card_definition.gd", "c64dcaf4"],
	["res://scripts/stats/passive_card_catalogue.gd", "278b30dc"],
	["res://scripts/skills/support_definition.gd", "53fe8521"],
	["res://scripts/skills/support_selection.gd", "7c4d8e3b"],
	["res://scripts/skills/support_selection_result.gd", "ad7bcec3"],
	["res://scripts/skills/skill_support_catalogue.gd", "a94f61cc"],
	["res://scripts/skills/acquired_supports.gd", "aad88e92"],
	["res://scripts/continuation/support_continuation.gd", "c815ad5d"],
	["res://scripts/continuation/support_continuation_result.gd", "68c8811d"],
	## Roguelite Foundation I8 (D-308): the two choice files moved one for one from the
	## `4946603e` / `94285b22` I7 left untouched to the D-308 files. Same count.
	["res://scripts/choices/rift_offer_choice.gd", "533ee30f"],
	["res://scripts/choices/rift_offer_choice_result.gd", "f051a955"],
	["res://scripts/choices/rift_consumption_ledger.gd", "f990eab7"],
	## Roguelite I10 (D-312): both level-up coordinators, the mote runtime and the running
	## review moved one for one — from `bbba1a71`, `01090425`, `083d4c28` and `005af300` — to
	## the D-312 files. Same count.
	["res://scripts/levels/rift_level_up_coordinator.gd", "f178c358"],
	## Roguelite Foundation I9 (D-310): the level-up receipt moved one for one from the
	## `0f2e4a86` I7 left untouched to the D-310 file. Same count.
	["res://scripts/levels/rift_level_up_result.gd", "2d67cee9"],
	["res://scripts/levels/rift_run_level_coordinator.gd", "b654e0a2"],
	["res://scripts/runs/rift_run_build.gd", "1920ae25"],
	["res://scripts/experience/rift_mote_runtime.gd", "23c41eb2"],
	## Roguelite I10's correction (D-313) moved the running review again, `1af0ffe8` → `9dcbfcc6`.
	## Roguelite I11 (D-314) moved the running review and its panel one for one — `9dcbfcc6` →
	## `128103b4` and `434740f2` → `61173e43` — to the D-314 files. Same count.
	["res://scripts/roguelite/level_up/roguelite_level_up_choice_review.gd", "128103b4"],
	## First-MVP UI J1 (D-322) moved the panel one for one — `61173e43` → `694eb0b2` — removing its
	## own left-press override now that the shared modal contract routes the pointer. Same count.
	["res://scripts/roguelite/level_up/rift_level_up_offer_panel.gd", "694eb0b2"],
	## Roguelite I13 (D-318) made Global Damage live, so the seam, its result and the live-effect
	## review moved one for one — `1aa00c5f`, `b6b6d1ee` and `ec2ec19e` — to the D-318 files, and Roguelite I14 (D-320), making Maximum Life live, to the D-320 files. Same count.
	["res://scripts/roguelite/live_effects/rift_build_application.gd", "c7b9df38"],
	## Roguelite I14's correction (D-321) moved the result once more, from `73d445f7`, for its
	## describe() diagnostic. Same count.
	["res://scripts/roguelite/live_effects/rift_build_application_result.gd", "2fd01f80"],
	## Roguelite I12 (D-316) moved the live-effect review one for one — `6a260f4c` →
	## `ec2ec19e` — to the D-316 file. Same count.
	["res://scripts/roguelite/live_effects/roguelite_live_effect_review.gd", "75cb02b9"],
	["res://project.godot", "55351038"],
]

const EXPECTED_OFFER_METHODS: Array[String] = [
	"refused", "refused_as_fallback_unavailable", "composed", "composed_with_passive_fallback",
	"category_for_lane", "is_declared_lane", "support_transition_problem",
	"lane_order", "is_support_fallback_unavailable", "seed_for", "identity_for", "lane_is_coherent",
	"problem", "_support_progression_problem", "_passive_fallback_problem",
	"lane_label", "support_progression_line", "support_fallback_line", "offer_line", "seed_line",
	"describe",
]
const EXPECTED_OFFER_FIELDS: Array[String] = [
	"ok", "failure_reason", "refusing_lane", "root_seed", "lanes", "lane_seeds",
	"skill_id", "support_id",
	"support_progression_kind", "support_rank_before", "support_rank_after",
	"combat_card_id", "utility_card_id",
	"support_continuation", "support_derivation",
	"combat_derivation", "utility_derivation",
	"support_content_kind", "support_fallback_card_id", "support_fallback",
	"support_fallback_unavailable",
]
const EXPECTED_COMPOSER_METHODS: Array[String] = [
	"compose", "_stage_support_progression", "lane_domain_for", "lane_seed_for", "_mix",
]

## Every project class each D1 file names after I7, exactly, sorted — from the
## engine's own class list, so substrings are honest.
const EXPECTED_NAMED_CLASSES: Array = [
	[OFFER_FILE, [
		"AcquiredSupports", "PassiveCardSelection", "PassiveCardSelectionResult",
		"PlayerStatDefinition", "RiftOffer", "SupportContinuation", "SupportContinuationResult",
		"SupportExhaustionPassiveFallback", "SupportExhaustionPassiveFallbackResult",
		"SupportSelection", "SupportSelectionResult",
	]],
	[COMPOSER_FILE, [
		"AcquiredSupports", "PassiveCardDefinition", "PassiveCardSelection",
		"PassiveCardSelectionResult", "RiftOffer", "RiftOfferComposition", "SkillTagProfile",
		"SupportContinuation", "SupportContinuationResult", "SupportDefinition",
		"SupportExhaustionPassiveFallback", "SupportExhaustionPassiveFallbackResult",
	]],
]

## Tokens only I7 introduces. Nothing that runs may name any of them outside the two
## D1 files.
const I7_TOKENS: Array[String] = [
	"SupportContentKind", "PASSIVE_FALLBACK", "SUPPORT_PROGRESSION", "support_content_kind",
	"support_fallback", "composed_with_passive_fallback", "refused_as_fallback_unavailable",
	"is_support_fallback_unavailable",
]

## THE TWO CHOICE FILES AND THE I7 MEMBERS EACH MAY NAME SINCE ROGUELITE FOUNDATION I8
## (D-308): the transaction routes on the offer's stored Support content kind and reads
## its fallback, and the result records which kind a Support choice consumed. Each is
## granted exactly those five members and none of the three I7 constructors or readings.
const CONSUMING_READERS: Array = [
	["res://scripts/choices/rift_offer_choice.gd", [
		"SupportContentKind", "PASSIVE_FALLBACK", "SUPPORT_PROGRESSION", "support_content_kind",
		"support_fallback",
	]],
	["res://scripts/choices/rift_offer_choice_result.gd", [
		"SupportContentKind", "PASSIVE_FALLBACK", "SUPPORT_PROGRESSION", "support_content_kind",
		"support_fallback",
	]],
	## Roguelite Foundation I9 (D-310): the one-level level-up receipt records which kind of
	## Support content a choice consumed and, for a consumed fallback, its category — so it
	## names the same five members the choice result does, and none of the three I7
	## constructors or readings. Added one for one: the same single assertion.
	["res://scripts/levels/rift_level_up_result.gd", [
		"SupportContentKind", "PASSIVE_FALLBACK", "SUPPORT_PROGRESSION", "support_content_kind",
		"support_fallback",
	]],
	## Roguelite I10 (D-312): the one-level coordinator reads the standing offer's stored
	## Support content kind and, for a passive fallback, its fallback's category; the
	## run-level coordinator and the mote runtime hand both readings on by name; and the
	## running review branches its Support card and its receipt on the stored kind. Each is
	## granted exactly the members it names, and none of the three I7 constructors or
	## readings. Added one for one: the same single assertion.
	["res://scripts/levels/rift_level_up_coordinator.gd", [
		"SupportContentKind", "PASSIVE_FALLBACK", "support_content_kind", "support_fallback",
	]],
	["res://scripts/levels/rift_run_level_coordinator.gd", ["support_content_kind", "support_fallback"]],
	["res://scripts/experience/rift_mote_runtime.gd", ["support_content_kind", "support_fallback"]],
	["res://scripts/roguelite/level_up/roguelite_level_up_choice_review.gd", [
		"SupportContentKind", "PASSIVE_FALLBACK", "SUPPORT_PROGRESSION", "support_content_kind",
		"support_fallback",
	]],
]

## Concrete names and ambient reads neither D1 file may hold, RAW (D-215).
const CONCRETE_TOKENS: Array[String] = [
	"card_power", "card_celerity", "card_vitality", "card_fleetness", "card_insight",
	"card_magnetism", "quick_strike", "QuickStrike", "Quick Strike", "reaching_edge",
	"Reaching Edge", "sweeping_edge", "Sweeping Edge", "PassiveCardCatalogue",
	"SkillSupportCatalogue", "Graveblade", "Riftmarked", "display_name",
]
const AMBIENT_TOKENS: Array[String] = [
	"randi", "randf", "randomize", "RandomNumberGenerator", "rand_from_seed",
	"Time.", "OS.", "Engine.", "ProjectSettings", "InputMap", "FileAccess",
	"DirAccess", "ConfigFile", "ResourceSaver", "ResourceLoader", "user://",
]

const SCANNED_ROOTS: Array[String] = [
	"res://scripts", "res://scenes", "res://data", "res://addons",
]
const PROJECT_SETTINGS_FILE: String = "res://project.godot"
const ENTRYPOINT: String = "res://scenes/app/prototype_app.tscn"
const EXPECTED_ACTIONS: int = 31

const SEED_SAMPLES: int = 256
const ROOT_SAMPLES: int = 4096
const SEED_SEARCH_LIMIT: int = 65536
const REPEAT_CALLS: int = 100

const OWED_CHECKS: Array[String] = [
	"the_shipped_exhausted_offer_carries_a_passive_fallback",
	"every_accepted_non_exhausted_offer_reproduces_exactly",
	"independently_derived_exhausted_examples_are_pinned",
	"the_fallback_never_returns_a_card_the_offer_carries",
	"one_supplied_catalogue_feeds_all_three_lanes",
	"reversed_inputs_and_repeats_change_nothing",
	"ticket_boundaries_hold_through_the_composed_offer",
	"one_remaining_category_is_used",
	"fallback_unavailable_refuses_the_whole_offer_as_support",
	"faulty_catalogues_refuse_before_a_seed_can_matter",
	"a_passive_lane_refusal_is_attributed_to_that_lane",
	"every_refusal_carries_the_root_seed_and_nothing_else",
	"the_i8_choice_transaction_consumes_the_fallback_lane",
	"nothing_running_uses_the_fallback_offer",
	"the_offer_contract_proves_each_kind_in_both_directions",
	"the_offer_and_composer_shapes_and_boundaries",
	"accepted_files_outside_the_offer_are_unchanged",
	"accepted_suites_moved_one_for_one",
]

var _failures: PackedStringArray = PackedStringArray()
var _checks: int = 0
var _reached: Dictionary = {}
var _refusals: int = 0

## Every refused offer this suite composes, with the root seed it was asked for, so
## check 11 can hold all of them to the refusal contract at once.
var _collected_refusals: Array = []


func _initialize() -> void:
	print("")
	print("=== Roguelite Foundation I7 — Exhausted-Support Passive-Fallback Offer Composition (D-306) ===")

	_check_the_shipped_exhausted_offer_carries_a_passive_fallback()
	_check_every_accepted_non_exhausted_offer_reproduces_exactly()
	_check_independently_derived_exhausted_examples_are_pinned()
	_check_the_fallback_never_returns_a_card_the_offer_carries()
	_check_one_supplied_catalogue_feeds_all_three_lanes()
	_check_reversed_inputs_and_repeats_change_nothing()
	_check_ticket_boundaries_hold_through_the_composed_offer()
	_check_one_remaining_category_is_used()
	_check_fallback_unavailable_refuses_the_whole_offer_as_support()
	_check_faulty_catalogues_refuse_before_a_seed_can_matter()
	_check_a_passive_lane_refusal_is_attributed_to_that_lane()
	_check_every_refusal_carries_the_root_seed_and_nothing_else()
	_check_the_choice_transaction_consumes_the_fallback_lane()
	_check_nothing_running_uses_the_fallback_offer()
	_check_the_offer_contract_proves_each_kind_in_both_directions()
	_check_the_offer_and_composer_shapes_and_boundaries()
	_check_accepted_files_outside_the_offer_are_unchanged()
	_check_accepted_suites_moved_one_for_one()

	_check_every_check_ran()

	print("")
	print("  %d refusals were driven across this suite" % _refusals)
	if _failures.is_empty():
		print("PASSIVE FALLBACK OFFER COMPOSITION VERIFICATION: PASS (%d checks)" % _checks)
		quit(0)
	else:
		for failure: String in _failures:
			printerr("  FAIL: %s" % failure)
		printerr("PASSIVE FALLBACK OFFER COMPOSITION VERIFICATION: %d FAILURE(S) of %d checks" % [
			_failures.size(), _checks,
		])
		quit(1)


# --- 0. The shipped exhausted offer ------------------------------------------------------------------------------

func _check_the_shipped_exhausted_offer_carries_a_passive_fallback() -> void:
	print("")
	print("--- 0. Both shipped supports at their maximum rank: the Support lane carries a passive fallback")
	var held: AcquiredSupports = _shipped(2, 2)
	var offer: RiftOffer = _compose(held, _cards(), 18)
	var fallback: SupportExhaustionPassiveFallbackResult = offer.support_fallback
	_expect(offer.ok and offer.problem().is_empty() and offer.root_seed == 18,
		"root seed 18 at R2 S2 reads %s / '%s'" % [offer.describe(), offer.problem()])
	_expect(offer.lane_order() == RiftOffer.LANE_ORDER
			and str(offer.lane_seeds) == str([51507111, 1168206400, 3720129402]),
		"the lanes read %s with seeds %s" % [str(offer.lane_order()), str(offer.lane_seeds)])
	_expect(offer.support_content_kind == FALLBACK_KIND
			and _ids(offer, SUPPORT_LANE) == "card_celerity" and _ids(offer, COMBAT_LANE) == "card_power"
			and _ids(offer, UTILITY_LANE) == "card_insight" and offer.support_fallback_card_id == CELERITY,
		"kind %d with identities [%s] [%s] [%s]" % [offer.support_content_kind,
			_ids(offer, SUPPORT_LANE), _ids(offer, COMBAT_LANE), _ids(offer, UTILITY_LANE)])
	_expect(String(offer.skill_id).is_empty() and String(offer.support_id).is_empty()
			and offer.support_progression_kind == RiftOffer.UNRESOLVED_PROGRESSION_KIND
			and offer.support_rank_before == RiftOffer.UNRESOLVED_RANK
			and offer.support_rank_after == RiftOffer.UNRESOLVED_RANK
			and offer.support_derivation == null and not offer.support_fallback_unavailable
			and offer.support_progression_line() == "no support progression",
		"the fallback lane carries support progression: %s -> %s, kind %d, %d -> %d" % [
			offer.skill_id, offer.support_id, offer.support_progression_kind,
			offer.support_rank_before, offer.support_rank_after])
	_expect(offer.support_continuation != null and offer.support_continuation.is_exhausted()
			and offer.support_continuation.problem().is_empty()
			and offer.support_continuation.failure_reason == EXHAUSTION_REASON,
		"the carried continuation is not the accepted exhaustion")
	var nested: PassiveCardSelectionResult = fallback.selection() if fallback != null else null
	_expect(fallback != null and fallback.ok and fallback.problem().is_empty()
			and fallback.selected_category == COMBAT and fallback.selected_card_id == CELERITY
			and fallback.category_ticket == 3141935186 and fallback.card_ticket == 1617272035
			and fallback.normalized_category_ticket == 0
			and fallback.candidate_categories() == ([COMBAT, UTILITY] as Array[int])
			and fallback.excluded_card_ids() == ([POWER, INSIGHT] as Array[StringName])
			and nested != null and nested.ladder_line() == "card_celerity x100, card_vitality x100"
			and nested.normalized_ticket == 35 and nested.total_weight == 200,
		"the fallback reads %s" % (fallback.describe() if fallback != null else "<none>"))
	_expect(offer.describe() == EXAMPLE_DESCRIBE and offer.support_fallback_line() == EXAMPLE_FALLBACK_LINE,
		"the lines read '%s' / '%s'" % [offer.describe(), offer.support_fallback_line()])

	var whole: int = 0
	var bad: PackedStringArray = PackedStringArray()
	for root_seed: int in SEED_SAMPLES:
		var candidate: RiftOffer = _compose(held, _cards(), root_seed)
		if _is_whole_fallback(candidate):
			whole += 1
		else:
			bad.append("%d: %s" % [root_seed, candidate.describe()])
	_expect(whole == SEED_SAMPLES, "%d of %d exhausted offers carried the fallback whole: %s" % [
		whole, SEED_SAMPLES, "; ".join(bad.slice(0, 3))])
	print("  root seed 18, both pairs at rank 2: lanes [Support, Combat and Defence, Utility], seeds 51507111 / 1168206400 / 3720129402; Support PASSIVE_FALLBACK [card_celerity], Combat and Defence [card_power], Utility [card_insight]")
	print("  the fallback: category ticket 3141935186 -> position 0 of 2 -> Combat and Defence; card ticket 1617272035 -> 35 of 200 over [card_celerity x100, card_vitality x100] -> card_celerity; excluded [card_power, card_insight]")
	print("  no Skill, no support, no progression kind, no rank, no weighted support derivation; the carried continuation is the accepted exhaustion")
	print("  %d of %d root seeds at R2 S2 compose a whole PASSIVE_FALLBACK offer: fixed lane order, one-card Support identity, a coherent I6 derivation, no support progression" % [whole, SEED_SAMPLES])
	_done("the_shipped_exhausted_offer_carries_a_passive_fallback")


# --- 1. Non-exhausted offers ---------------------------------------------------------------------------------------

func _check_every_accepted_non_exhausted_offer_reproduces_exactly() -> void:
	print("")
	print("--- 1. Every accepted non-exhausted offer and refusal reproduces exactly")
	var seeds: Array[int] = _corpus_seeds()
	var rows: PackedStringArray = PackedStringArray()
	var progression: int = 0
	var wrong_kind: PackedStringArray = PackedStringArray()
	for reaching: int in 3:
		for sweeping: int in 3:
			if reaching == 2 and sweeping == 2:
				continue
			var held: AcquiredSupports = _shipped(reaching, sweeping)
			for s: int in seeds:
				var o: RiftOffer = _compose(held, _cards(), s)
				rows.append("R%d S%d %d: %s" % [reaching, sweeping, s, _row(o)])
				if _is_progression_offer(o):
					progression += 1
				else:
					wrong_kind.append("R%d S%d %d" % [reaching, sweeping, s])
	for s: int in seeds:
		var o: RiftOffer = RiftOfferComposition.compose(_profiles(), _definitions(), null, _cards(), s)
		rows.append("null %d: %s" % [s, _row(o)])
		if _is_progression_offer(o):
			progression += 1
		else:
			wrong_kind.append("null %d" % s)
	var digest: String = "\n".join(rows).sha256_text()
	_expect(rows.size() == PRE_I7_ROWS and digest == PRE_I7_DIGEST,
		"%d rows hash %s, not the pre-I7 %d / %s" % [rows.size(), digest, PRE_I7_ROWS, PRE_I7_DIGEST])
	_expect(progression == rows.size() and wrong_kind.is_empty(),
		"%d of %d non-exhausted offers are SUPPORT_PROGRESSION with no fallback: %s" % [
			progression, rows.size(), ", ".join(wrong_kind.slice(0, 5))])

	var refusal_rows: PackedStringArray = _refusal_corpus()
	var refusal_digest: String = "\n".join(refusal_rows).sha256_text()
	_expect(refusal_rows.size() == PRE_I7_REFUSAL_ROWS and refusal_digest == PRE_I7_REFUSAL_DIGEST,
		"%d refusal rows hash %s, not the pre-I7 %d / %s" % [
			refusal_rows.size(), refusal_digest, PRE_I7_REFUSAL_ROWS, PRE_I7_REFUSAL_DIGEST])

	## D1's and F3's own pinned corpora, verbatim, and the same rows those suites hold.
	var d1_rows: Variant = _constants(D1_SUITE).get("SEED_CORPUS")
	var f3_rows: Variant = _constants(F3_SUITE).get("SEED_CORPUS")
	_expect(str(d1_rows) == str(D1_SEED_CORPUS) and str(f3_rows) == str(D1_SEED_CORPUS),
		"the typed corpus differs from the accepted D1 or F3 suite's own")
	var exact: int = 0
	for row: Array in D1_SEED_CORPUS:
		var o: RiftOffer = RiftOfferComposition.compose(_profiles(), _definitions(), null, _cards(), int(row[0]))
		if o.ok and o.problem().is_empty() and o.seed_for(SUPPORT_LANE) == int(row[1]) \
				and o.seed_for(COMBAT_LANE) == int(row[2]) and o.seed_for(UTILITY_LANE) == int(row[3]) \
				and _ids(o, SUPPORT_LANE) == "%s, %s" % [row[4], row[5]] \
				and String(o.combat_card_id) == String(row[6]) and String(o.utility_card_id) == String(row[7]) \
				and o.support_content_kind == PROGRESSION_KIND \
				and o.support_progression_kind == SupportContinuationResult.Kind.NEW_PAIR \
				and o.support_rank_before == 0 and o.support_rank_after == 1 and o.support_fallback == null:
			exact += 1
	_expect(exact == D1_SEED_CORPUS.size(), "%d of %d D1 / F3 corpus rows exact" % [exact, D1_SEED_CORPUS.size()])

	## F3's worked rank example and E2's worked new pair.
	var rank_offer: RiftOffer = _compose(_shipped(1, 1), _cards(), 18)
	var e2_offer: RiftOffer = _compose(AcquiredSupports.new(), _cards(), 0)
	_expect(rank_offer.ok and rank_offer.support_content_kind == PROGRESSION_KIND
			and rank_offer.support_id == SWEEPING and rank_offer.support_rank_before == 1
			and rank_offer.support_rank_after == 2 and rank_offer.combat_card_id == POWER
			and rank_offer.utility_card_id == INSIGHT and _ids(rank_offer, SUPPORT_LANE) == "quick_strike, sweeping_edge"
			and rank_offer.support_progression_line() == "another rank of a held pair, rank 1 -> 2"
			and e2_offer.ok and e2_offer.support_id == REACHING and e2_offer.support_fallback == null,
		"F3's example reads %s (%s); E2's reads %s" % [rank_offer.describe(),
			rank_offer.support_progression_line(), e2_offer.describe()])
	print("  %d non-exhausted offers (8 shipped states + a null record x %d root seeds) hash %s — identical to the pre-I7 composer's" % [rows.size(), seeds.size(), digest.left(16)])
	print("  %d of %d are SUPPORT_PROGRESSION with a two-id Support identity, their original kind and ranks, and no fallback" % [progression, rows.size()])
	print("  %d non-exhausted refusals (no definitions, no profiles, no cards, one category only x 3 states x 64 seeds) hash %s — identical" % [refusal_rows.size(), refusal_digest.left(16)])
	print("  %d of %d D1 / F3 corpus rows exact, the typed corpus equal to both accepted suites' own; F3's root seed 18 rank example sweeping_edge 1 -> 2, card_power, card_insight" % [exact, D1_SEED_CORPUS.size()])
	_done("every_accepted_non_exhausted_offer_reproduces_exactly")

# --- 2. Independently derived examples ---------------------------------------------------------------------------

func _check_independently_derived_exhausted_examples_are_pinned() -> void:
	print("")
	print("--- 2. The exhausted examples computed outside the engine are reproduced exactly")
	var held: AcquiredSupports = _shipped(2, 2)
	var cards: Array[PassiveCardDefinition] = _cards()
	var exact: int = 0
	var core: int = 0
	var formula: int = 0
	var reached_cards: Dictionary = {}
	var reached_categories: Dictionary = {}
	var wrong: PackedStringArray = PackedStringArray()
	for row: Array in EXHAUSTED_CORPUS:
		var root_seed: int = int(row[0])
		var o: RiftOffer = _compose(held, cards, root_seed)
		var f: SupportExhaustionPassiveFallbackResult = o.support_fallback
		if o.ok and o.problem().is_empty() and f != null and o.root_seed == root_seed \
				and o.seed_for(SUPPORT_LANE) == int(row[1]) and o.seed_for(COMBAT_LANE) == int(row[2]) \
				and o.seed_for(UTILITY_LANE) == int(row[3]) \
				and String(o.combat_card_id) == String(row[4]) and String(o.utility_card_id) == String(row[5]) \
				and f.category_ticket == int(row[6]) and f.card_ticket == int(row[7]) \
				and f.selected_category == int(row[8]) and String(f.selected_card_id) == String(row[9]) \
				and String(o.support_fallback_card_id) == String(row[9]):
			exact += 1
		else:
			wrong.append("%d: %s" % [root_seed, o.describe()])
		if f != null:
			var again: SupportExhaustionPassiveFallbackResult = SupportExhaustionPassiveFallback.select_with_tickets(
				o.support_continuation, o.combat_derivation, o.utility_derivation, cards, int(row[6]), int(row[7]))
			if _fallback_derivation(again) == _fallback_derivation(f):
				core += 1
		if _test_lane_seed(root_seed, 0x6A09E667) == int(row[1]) and _test_lane_seed(root_seed, 0xBB67AE85) == int(row[2]) \
				and _test_lane_seed(root_seed, 0x3C6EF372) == int(row[3]) \
				and _test_ticket(int(row[1]), 0xA54FF53A) == int(row[6]) and _test_ticket(int(row[1]), 0x510E527F) == int(row[7]):
			formula += 1
		_count(reached_cards, String(row[9]))
		_count(reached_categories, int(row[8]))
	_expect(exact == EXHAUSTED_CORPUS.size(), "%d of %d rows exact: %s" % [exact, EXHAUSTED_CORPUS.size(), "; ".join(wrong.slice(0, 3))])
	_expect(core == EXHAUSTED_CORPUS.size() and formula == EXHAUSTED_CORPUS.size(),
		"%d reproduce through the pure core and %d match the in-suite formula" % [core, formula])
	_expect(reached_cards.size() == 6 and reached_categories.size() == 2,
		"the corpus reaches %s and categories %s" % [str(reached_cards), str(reached_categories)])
	print("  %d of %d frozen rows exact (root seed, 3 lane seeds, both ordinary cards, both raw fallback tickets, fallback category and card); %d reproduce through select_with_tickets(); %d match an in-suite derivation from the documented formulas" % [exact, EXHAUSTED_CORPUS.size(), core, formula])
	print("  the corpus reaches all 6 shipped cards as a fallback and both categories; example: root seed 257 -> Combat and Defence card_celerity, Utility card_magnetism, fallback Utility card_insight")
	_done("independently_derived_exhausted_examples_are_pinned")


# --- 3. Never a card the offer carries ----------------------------------------------------------------------------

func _check_the_fallback_never_returns_a_card_the_offer_carries() -> void:
	print("")
	print("--- 3. The fallback never returns either card the two passive lanes already offer")
	var held: AcquiredSupports = _shipped(2, 2)
	var cards: Array[PassiveCardDefinition] = _cards()
	var composed: int = 0
	var duplicated: int = 0
	var misexcluded: int = 0
	var on_ladder: int = 0
	var pairs: Dictionary = {}
	var owners: Dictionary = {}
	var categories: Dictionary = {}
	for root_seed: int in ROOT_SAMPLES:
		var o: RiftOffer = _compose(held, cards, root_seed)
		if not o.ok or o.support_fallback == null:
			continue
		composed += 1
		var carried: Array[StringName] = [o.combat_card_id, o.utility_card_id]
		pairs["%s / %s" % carried] = true
		if carried.has(o.support_fallback_card_id):
			duplicated += 1
		if o.support_fallback.excluded_card_ids() != carried:
			misexcluded += 1
		var ladder: PassiveCardSelectionResult = o.support_fallback.selection()
		if ladder.candidate_ids.has(o.combat_card_id) or ladder.candidate_ids.has(o.utility_card_id):
			on_ladder += 1
		_count(owners, String(o.support_fallback_card_id))
		_count(categories, PassiveCardSelectionResult.category_label(o.support_fallback.selected_category))
	_expect(composed == ROOT_SAMPLES and duplicated == 0 and misexcluded == 0 and on_ladder == 0,
		"%d composed; %d returned a carried card, %d excluded the wrong pair, %d carried a card on the ladder" % [
			composed, duplicated, misexcluded, on_ladder])
	_expect(pairs.size() == 9, "only %d of 9 source pairs were reached" % pairs.size())
	print("  %d exhausted offers over root seeds 0-%d: a carried card returned 0 times, on a nested ladder 0 times; excluded == [Combat and Defence card, Utility card] in lane order %d of %d; 9 of 9 source pairs reached" % [composed, ROOT_SAMPLES - 1, composed - misexcluded, composed])
	print("  tally over those seeds (a record, not a distribution claim — I6 proves the distribution by complete ladder walks): %s; %s" % [_owner_line(owners), _owner_line(categories)])
	_done("the_fallback_never_returns_a_card_the_offer_carries")


# --- 4. One catalogue ---------------------------------------------------------------------------------------------

func _check_one_supplied_catalogue_feeds_all_three_lanes() -> void:
	print("")
	print("--- 4. All three lane selections draw from the one supplied card catalogue")
	var held: AcquiredSupports = _shipped(2, 2)
	var custom: Array[PassiveCardDefinition] = _weighted_catalogue()
	var combat_ids: Array[StringName] = [&"zz_c_alpha", &"zz_c_beta", &"zz_c_gamma"]
	var utility_ids: Array[StringName] = [&"zz_u_alpha", &"zz_u_beta", &"zz_u_gamma"]
	var same: int = 0
	var shipped_named: int = 0
	var provenance_refused: int = 0
	var wrong: PackedStringArray = PackedStringArray()
	for root_seed: int in SEED_SAMPLES:
		var o: RiftOffer = _compose(held, custom, root_seed)
		var f: SupportExhaustionPassiveFallbackResult = o.support_fallback
		if not o.ok or f == null:
			wrong.append("%d refused: %s" % [root_seed, o.failure_reason])
			continue
		var remaining: Array[StringName] = []
		for id: StringName in (combat_ids if f.selected_category == COMBAT else utility_ids):
			if id != o.combat_card_id and id != o.utility_card_id:
				remaining.append(id)
		var direct: SupportExhaustionPassiveFallbackResult = SupportExhaustionPassiveFallback.select(
			o.support_continuation, o.combat_derivation, o.utility_derivation, custom, o.seed_for(SUPPORT_LANE))
		var nested_direct: PassiveCardSelectionResult = PassiveCardSelection.select_with_ticket_excluding(
			custom, f.selected_category, f.card_ticket, f.excluded_card_ids())
		if o.combat_derivation.candidate_ids == combat_ids and o.utility_derivation.candidate_ids == utility_ids \
				and f.selection().candidate_ids == remaining \
				and _fallback_derivation(direct) == _fallback_derivation(f) \
				and _passive_derivation(nested_direct) == _passive_derivation(f.selection()):
			same += 1
		else:
			wrong.append("%d: %s" % [root_seed, f.describe()])
		for lane: int in RiftOffer.LANE_ORDER:
			for id: String in o.identity_for(lane):
				if id.begins_with("card_"):
					shipped_named += 1
		## PROVENANCE MATTERS: the same derivations handed a DIFFERENT catalogue refuse.
		var elsewhere: SupportExhaustionPassiveFallbackResult = SupportExhaustionPassiveFallback.select(
			o.support_continuation, o.combat_derivation, o.utility_derivation, _cards(), o.seed_for(SUPPORT_LANE))
		if not elsewhere.ok and not elsewhere.is_unavailable() \
				and elsewhere.failure_reason.contains("is not among the supplied passive card records"):
			provenance_refused += 1
			_refusals += 1
	_expect(same == SEED_SAMPLES and wrong.is_empty(), "%d of %d offers drew all three lanes from the supplied catalogue: %s" % [
		same, SEED_SAMPLES, "; ".join(wrong.slice(0, 3))])
	_expect(shipped_named == 0 and provenance_refused == SEED_SAMPLES,
		"%d shipped ids appeared; %d of %d re-asked against the shipped catalogue refused" % [
			shipped_named, provenance_refused, SEED_SAMPLES])
	print("  a fabricated catalogue [zz_c_alpha x3, zz_c_beta x5, zz_c_gamma x7 | zz_u_alpha x2, zz_u_beta x4, zz_u_gamma x6], both pairs at rank 2, %d root seeds:" % SEED_SAMPLES)
	print("  %d of %d: both passive ladders are exactly its categories, the fallback ladder is its chosen category minus the two carried cards, and the fallback equals I6 asked directly with that catalogue and the Support lane seed; 0 shipped ids anywhere" % [same, SEED_SAMPLES])
	print("  the same three derivations re-asked against the shipped catalogue refuse %d of %d times — a fallback drawn from another catalogue cannot be composed" % [provenance_refused, SEED_SAMPLES])
	_done("one_supplied_catalogue_feeds_all_three_lanes")


# --- 5. Order and repetition ---------------------------------------------------------------------------------------

func _check_reversed_inputs_and_repeats_change_nothing() -> void:
	print("")
	print("--- 5. Reversed Skill, support and card arrays and repeated calls change no answer")
	var profiles: Array[SkillTagProfile] = _profiles()
	var definitions: Array[SupportDefinition] = _definitions()
	var cards: Array[PassiveCardDefinition] = _cards()
	var reversed_profiles: Array[SkillTagProfile] = []
	for index: int in range(profiles.size() - 1, -1, -1):
		reversed_profiles.append(profiles[index])
	var reversed_definitions: Array[SupportDefinition] = []
	for index: int in range(definitions.size() - 1, -1, -1):
		reversed_definitions.append(definitions[index])
	var reversed_cards: Array[PassiveCardDefinition] = _reversed(cards)
	var custom: Array[PassiveCardDefinition] = _weighted_catalogue()
	var compared: int = 0
	var moved: int = 0
	var fallbacks: int = 0
	for reaching: int in 3:
		for sweeping: int in 3:
			var held: AcquiredSupports = _shipped(reaching, sweeping)
			for root_seed: int in 64:
				var forward: String = _full(RiftOfferComposition.compose(profiles, definitions, held, cards, root_seed))
				for variant: String in [
					_full(RiftOfferComposition.compose(reversed_profiles, definitions, held, cards, root_seed)),
					_full(RiftOfferComposition.compose(profiles, reversed_definitions, held, cards, root_seed)),
					_full(RiftOfferComposition.compose(profiles, definitions, held, reversed_cards, root_seed)),
					_full(RiftOfferComposition.compose(reversed_profiles, reversed_definitions, held, reversed_cards, root_seed)),
				]:
					compared += 1
					if variant != forward:
						moved += 1
				if forward.contains("content=%d " % FALLBACK_KIND):
					fallbacks += 1
	var exhausted: AcquiredSupports = _shipped(2, 2)
	for root_seed: int in 64:
		compared += 1
		if _full(RiftOfferComposition.compose(profiles, definitions, exhausted, custom, root_seed)) \
				!= _full(RiftOfferComposition.compose(reversed_profiles, reversed_definitions, exhausted, _reversed(custom), root_seed)):
			moved += 1
	var first: String = _full(_compose(exhausted, cards, 18))
	var drift: int = 0
	for _call: int in REPEAT_CALLS:
		if _full(_compose(exhausted, cards, 18)) != first:
			drift += 1
	_expect(compared == 9 * 64 * 4 + 64 and moved == 0, "%d of %d answers moved when an input array was reversed" % [moved, compared])
	_expect(fallbacks == 64 and drift == 0, "%d exhausted forward answers; %d of %d repeats drifted" % [fallbacks, drift, REPEAT_CALLS])
	print("  %d answers over 9 shipped states x 64 root seeds x 4 reversals (Skills, supports, cards, all three), plus 64 on a fabricated catalogue: 0 moved, the 64 R2 S2 answers all passive fallbacks" % compared)
	print("  %d repeated compositions of root seed 18 at R2 S2: %d drifted" % [REPEAT_CALLS, drift])
	_done("reversed_inputs_and_repeats_change_nothing")


# --- 6. Ticket boundaries -----------------------------------------------------------------------------------------

func _check_ticket_boundaries_hold_through_the_composed_offer() -> void:
	print("")
	print("--- 6. Category and card ticket boundaries hold through the composed offer")
	var held: AcquiredSupports = _shipped(2, 2)
	var cards: Array[PassiveCardDefinition] = _cards()
	## (a) The composer hands the fallback exactly the Support lane seed's two tickets.
	var handed: int = 0
	for root_seed: int in ROOT_SAMPLES:
		var o: RiftOffer = _compose(held, cards, root_seed)
		var f: SupportExhaustionPassiveFallbackResult = o.support_fallback
		var support_seed: int = RiftOfferComposition.lane_seed_for(root_seed, SUPPORT_LANE)
		if f != null and f.category_ticket == SupportExhaustionPassiveFallback.category_ticket_for(support_seed) \
				and f.card_ticket == SupportExhaustionPassiveFallback.card_ticket_for(support_seed) \
				and _fallback_derivation(f) == _fallback_derivation(SupportExhaustionPassiveFallback.select_with_tickets(
					o.support_continuation, o.combat_derivation, o.utility_derivation, cards, f.category_ticket, f.card_ticket)):
			handed += 1
	_expect(handed == ROOT_SAMPLES, "%d of %d offers carry the Support lane seed's own tickets" % [handed, ROOT_SAMPLES])

	## (b) Search root seeds for composed offers at every boundary position.
	var targets: Array[String] = []
	for category_position: int in 2:
		for card_position: int in [0, 99, 100, 199]:
			targets.append("%d/%d" % [category_position, card_position])
	var found: Dictionary = {}
	var wrong: PackedStringArray = PackedStringArray()
	var walked: int = 0
	var searched: int = 0
	for root_seed: int in SEED_SEARCH_LIMIT:
		if found.size() == targets.size():
			break
		searched += 1
		var o: RiftOffer = _compose(held, cards, root_seed)
		var f: SupportExhaustionPassiveFallbackResult = o.support_fallback
		if f == null:
			continue
		var nested: PassiveCardSelectionResult = f.selection()
		var key: String = "%d/%d" % [f.normalized_category_ticket, nested.normalized_ticket]
		if not targets.has(key) or found.has(key):
			continue
		found[key] = root_seed
		var owner_category: int = [COMBAT, UTILITY][f.normalized_category_ticket]
		var owner_card: StringName = nested.candidate_ids[0 if nested.normalized_ticket < 100 else 1]
		if f.selected_category != owner_category or f.category_for_ticket(f.normalized_category_ticket) != owner_category \
				or f.selected_card_id != owner_card or o.support_fallback_card_id != owner_card:
			wrong.append("%s at root seed %d chose %s" % [key, root_seed, f.selected_card_id])
		## (c) and the composed offer's whole nested ladder and category ladder, walked.
		var owned: Dictionary = {}
		for position: int in nested.total_weight:
			_count(owned, String(nested.card_for_ticket(position)))
			walked += 1
		if owned.size() != 2 or int(owned.get(String(nested.candidate_ids[0]), 0)) != 100 \
				or int(owned.get(String(nested.candidate_ids[1]), 0)) != 100 \
				or f.category_for_ticket(0) != COMBAT or f.category_for_ticket(1) != UTILITY \
				or f.category_for_ticket(2) != SupportExhaustionPassiveFallbackResult.UNRESOLVED_CATEGORY:
			wrong.append("%s walked %s" % [key, str(owned)])
	_expect(found.size() == targets.size() and wrong.is_empty(),
		"%d of %d boundary positions found within %d seeds: %s" % [found.size(), targets.size(), searched, "; ".join(wrong)])

	## (d) Weighted card selection through the composed offer: every nested ladder walked.
	var custom: Array[PassiveCardDefinition] = _weighted_catalogue()
	var weighted_offers: int = 0
	var weighted_positions: int = 0
	var weighted_wrong: PackedStringArray = PackedStringArray()
	for root_seed: int in SEED_SAMPLES:
		var o: RiftOffer = _compose(held, custom, root_seed)
		var f: SupportExhaustionPassiveFallbackResult = o.support_fallback
		if f == null:
			weighted_wrong.append("%d refused" % root_seed)
			continue
		var nested: PassiveCardSelectionResult = f.selection()
		var expected_total: int = 0
		var owned: Dictionary = {}
		for id: StringName in nested.candidate_ids:
			expected_total += _record(custom, id).base_weight
		for position: int in nested.total_weight:
			_count(owned, String(nested.card_for_ticket(position)))
			weighted_positions += 1
		var right: bool = nested.total_weight == expected_total \
			and nested.normalized_ticket == f.card_ticket % expected_total \
			and nested.card_for_ticket(nested.normalized_ticket) == f.selected_card_id \
			and f.candidate_categories() == ([COMBAT, UTILITY] as Array[int])
		for id: StringName in nested.candidate_ids:
			if int(owned.get(String(id), 0)) != _record(custom, id).base_weight:
				right = false
		if right:
			weighted_offers += 1
		else:
			weighted_wrong.append("%d: %s" % [root_seed, f.describe()])
	_expect(weighted_offers == SEED_SAMPLES, "%d of %d weighted ladders owned exactly their weights: %s" % [
		weighted_offers, SEED_SAMPLES, "; ".join(weighted_wrong.slice(0, 3))])
	print("  %d of %d exhausted offers carry exactly the tickets the Support lane seed derives, and I6's pure core reproduces each" % [handed, ROOT_SAMPLES])
	print("  all 8 boundaries (category positions 0 and 1 x card positions 0, 99, 100 and 199) found within %d root seeds: position 0 -> Combat and Defence, 1 -> Utility; 0-99 -> the first remaining card, 100-199 -> the second; %d wrong" % [searched, wrong.size()])
	print("  those 8 offers' nested ladders walked whole (%d positions): each remaining card owns 100 of 200; each category owns exactly 1 of 2 category positions" % walked)
	print("  weighted: %d of %d fabricated-catalogue offers walked whole (%d positions) — every remaining card owns exactly its integer weight, and the chosen card owns the walked ticket" % [weighted_offers, SEED_SAMPLES, weighted_positions])
	_done("ticket_boundaries_hold_through_the_composed_offer")


# --- 7. One remaining category ------------------------------------------------------------------------------------

func _check_one_remaining_category_is_used() -> void:
	print("")
	print("--- 7. A catalogue leaving candidates in only one category uses that category")
	var held: AcquiredSupports = _shipped(2, 2)
	var rows: Array = [
		["Utility holds one card", _catalogue([["zz_c_alpha", &"global_damage", 3], ["zz_c_beta", &"skill_speed", 5],
			["zz_u_only", &"movement_speed", 2]]), COMBAT],
		["Combat and Defence holds one card", _catalogue([["zz_c_only", &"global_damage", 3],
			["zz_u_alpha", &"movement_speed", 2], ["zz_u_beta", &"experience_gain", 4]]), UTILITY],
	]
	var lines: PackedStringArray = PackedStringArray()
	for row: Array in rows:
		var catalogue: Array[PassiveCardDefinition] = row[1]
		var used: int = 0
		for root_seed: int in SEED_SAMPLES:
			var o: RiftOffer = _compose(held, catalogue, root_seed)
			var f: SupportExhaustionPassiveFallbackResult = o.support_fallback
			if o.ok and o.problem().is_empty() and f != null and f.selected_category == int(row[2]) \
					and f.candidate_categories() == ([int(row[2])] as Array[int]) and f.normalized_category_ticket == 0 \
					and o.support_fallback_card_id != o.combat_card_id and o.support_fallback_card_id != o.utility_card_id:
				used += 1
		_expect(used == SEED_SAMPLES, "%s: %d of %d offers used the one remaining category" % [String(row[0]), used, SEED_SAMPLES])
		lines.append("%s: %d of %d offers draw the fallback from %s, the category ladder [%d]" % [
			String(row[0]), used, SEED_SAMPLES, PassiveCardSelectionResult.category_label(int(row[2])), int(row[2])])
	for line: String in lines:
		print("  " + line)
	_done("one_remaining_category_is_used")

# --- 8. Fallback unavailable --------------------------------------------------------------------------------------

func _check_fallback_unavailable_refuses_the_whole_offer_as_support() -> void:
	print("")
	print("--- 8. Fallback-unavailable refuses the whole offer as the Support lane, with no partial offer")
	var held: AcquiredSupports = _shipped(2, 2)
	var expected_reason: String = "the Support lane refused: %s; and its passive fallback is unavailable: %s" % [
		EXHAUSTION_REASON, UNAVAILABLE_REASON]
	var catalogues: Array = [
		["a fabricated one-card-per-category catalogue", _catalogue([["zz_c_only", &"global_damage", 3],
			["zz_u_only", &"movement_speed", 2]])],
		["the shipped two-card catalogue [card_celerity, card_fleetness]",
			[_record(_cards(), CELERITY), _record(_cards(), FLEETNESS)] as Array[PassiveCardDefinition]],
	]
	var lines: PackedStringArray = PackedStringArray()
	for row: Array in catalogues:
		var catalogue: Array[PassiveCardDefinition] = row[1]
		var whole: int = 0
		var control: int = 0
		for root_seed: int in SEED_SAMPLES:
			var o: RiftOffer = _compose(held, catalogue, root_seed)
			_refusals += 1
			_collected_refusals.append([o, root_seed])
			if _is_bare_refusal(o, root_seed) and o.refusing_lane == SUPPORT_LANE \
					and o.is_support_fallback_unavailable() and o.support_fallback_unavailable \
					and o.failure_reason == expected_reason \
					and o.support_fallback_line() == "passive fallback unavailable":
				whole += 1
			## The same catalogue is perfectly usable while support progression is not exhausted.
			var usable: RiftOffer = _compose(AcquiredSupports.new(), catalogue, root_seed)
			if usable.ok and usable.support_content_kind == PROGRESSION_KIND:
				control += 1
		_expect(whole == SEED_SAMPLES and control == SEED_SAMPLES,
			"%s: %d of %d refused whole as fallback-unavailable, %d of %d composed while not exhausted" % [
				String(row[0]), whole, SEED_SAMPLES, control, SEED_SAMPLES])
		lines.append("%s: %d of %d root seeds refuse whole at the Support lane, is_support_fallback_unavailable() true, no lane, seed, identity, derivation, kind, card or rank; %d of %d compose while support is not exhausted" % [
			String(row[0]), whole, SEED_SAMPLES, control, SEED_SAMPLES])

	## D-305 RULING 5, THROUGH THE UNCHANGED ONE-LEVEL COORDINATOR: the level-up stays
	## ready and unconsumed.
	var two_cards: Array[PassiveCardDefinition] = catalogues[1][1]
	var lifecycle: RiftLevelUpCoordinator = RiftLevelUpCoordinator.with_state(null, _build(2, 2), null)
	var awarded: String = lifecycle.award_experience(100.0)
	var refusal: String = lifecycle.open_offer(100.0, _profiles(), _definitions(), two_cards, 18)
	_refusals += 1
	_expect(awarded.is_empty() and refusal.contains(expected_reason) and not lifecycle.is_offer_active()
			and lifecycle.level() == 1 and not lifecycle.is_completed()
			and lifecycle.reading_for(100.0).ready and lifecycle.consumption_ledger().count() == 0
			and lifecycle.frozen_requirement() == RiftLevelUpCoordinator.NO_REQUIREMENT,
		"the coordinator answered '%s' and reads %s" % [refusal, lifecycle.describe()])
	for line: String in lines:
		print("  " + line)
	print("  the reason: '%s'" % expected_reason)
	print("  through the unchanged one-level coordinator: the offer does not open, Level 1, the level-up still ready, 0 seeds consumed, nothing frozen")
	_done("fallback_unavailable_refuses_the_whole_offer_as_support")


# --- 9. Faulty catalogues -----------------------------------------------------------------------------------------

func _check_faulty_catalogues_refuse_before_a_seed_can_matter() -> void:
	print("")
	print("--- 9. Malformed or over-ceiling catalogues refuse whole, identically on every seed, before the fallback")
	var held: AcquiredSupports = _shipped(2, 2)
	var shipped: Array[PassiveCardDefinition] = _cards()
	var faults: Array = [
		["an unknown stat", _with(shipped, _card("zz_unknown", &"zz_no_such_stat", 100))],
		["a zero weight", _with(shipped, _card("zz_u_zero", &"movement_speed", 0))],
		["a duplicated id", _with(shipped, _record(shipped, INSIGHT))],
		["a null record", _with(shipped, null)],
		["a Utility pool one past the ceiling", _catalogue([["zz_c_alpha", &"global_damage", 3],
			["zz_c_beta", &"skill_speed", 5], ["zz_u_heavy", &"movement_speed", 4294967295],
			["zz_u_light", &"experience_gain", 1]])],
		["a Combat and Defence pool one past the ceiling", _catalogue([["zz_c_heavy", &"global_damage", 4294967295],
			["zz_c_light", &"skill_speed", 1], ["zz_u_alpha", &"movement_speed", 2],
			["zz_u_beta", &"experience_gain", 4]])],
	]
	var lines: PackedStringArray = PackedStringArray()
	for row: Array in faults:
		var catalogue: Array[PassiveCardDefinition] = row[1]
		var reasons: Dictionary = {}
		var lanes: Dictionary = {}
		var whole: int = 0
		for root_seed: int in SEED_SAMPLES:
			var o: RiftOffer = _compose(held, catalogue, root_seed)
			_refusals += 1
			_collected_refusals.append([o, root_seed])
			reasons[o.failure_reason] = true
			lanes[o.refusing_lane] = true
			if _is_bare_refusal(o, root_seed) and o.refusing_lane != SUPPORT_LANE \
					and not o.is_support_fallback_unavailable() and o.failure_reason.ends_with(NOT_ATTEMPTED_NOTE):
				whole += 1
		var control: RiftOffer = _compose(AcquiredSupports.new(), catalogue, 0)
		var one_reason: String = String(reasons.keys()[0]) if reasons.size() == 1 else ""
		_expect(whole == SEED_SAMPLES and reasons.size() == 1 and lanes.size() == 1
				and not control.ok and one_reason == control.failure_reason + NOT_ATTEMPTED_NOTE
				and control.refusing_lane == int(lanes.keys()[0]),
			"%s: %d of %d refused whole at a passive lane; %d reasons, %d lanes; control '%s'" % [
				String(row[0]), whole, SEED_SAMPLES, reasons.size(), lanes.size(), control.failure_reason])
		lines.append("%s: %d of %d root seeds refuse whole at the %s lane with one identical reason, the fallback not attempted: '%s'" % [
			String(row[0]), whole, SEED_SAMPLES, RiftOffer.lane_label(int(lanes.keys()[0])), one_reason])
	for line: String in lines:
		print("  " + line)
	print("  STRUCTURAL: with one catalogue feeding all three lanes, the passive lanes validate the same whole record set first, so I6's own malformed-record and over-ceiling refusals are unreachable through composition")
	_done("faulty_catalogues_refuse_before_a_seed_can_matter")


# --- 10. Attribution ----------------------------------------------------------------------------------------------

func _check_a_passive_lane_refusal_is_attributed_to_that_lane() -> void:
	print("")
	print("--- 10. A passive-lane refusal is attributed to that lane, not to the Support lane, and I6 is never called")
	var exhausted: AcquiredSupports = _shipped(2, 2)
	var only_utility: Array[PassiveCardDefinition] = _only(_cards(), UTILITY)
	var only_combat: Array[PassiveCardDefinition] = _only(_cards(), COMBAT)
	var none: Array[PassiveCardDefinition] = []
	var no_definitions: Array[SupportDefinition] = []
	var rows: Array = [
		["exhausted, no Combat and Defence card", exhausted, _definitions(), only_utility, COMBAT_LANE,
			"the Combat and Defence lane refused: no supplied passive card belongs to the Combat and Defence category" + NOT_ATTEMPTED_NOTE],
		["exhausted, no Utility card", exhausted, _definitions(), only_combat, UTILITY_LANE,
			"the Utility lane refused: no supplied passive card belongs to the Utility category" + NOT_ATTEMPTED_NOTE],
		["exhausted, no card at all", exhausted, _definitions(), none, COMBAT_LANE,
			"the Combat and Defence lane refused: no passive card records were given (2 of 3 lanes refused)" + NOT_ATTEMPTED_NOTE],
		["not exhausted, no Combat and Defence card (accepted)", AcquiredSupports.new(), _definitions(), only_utility, COMBAT_LANE,
			"the Combat and Defence lane refused: no supplied passive card belongs to the Combat and Defence category"],
	]
	var lines: PackedStringArray = PackedStringArray()
	for row: Array in rows:
		var right: int = 0
		for root_seed: int in 64:
			var o: RiftOffer = RiftOfferComposition.compose(_profiles(), row[2], row[1], row[3], root_seed)
			_refusals += 1
			_collected_refusals.append([o, root_seed])
			if _is_bare_refusal(o, root_seed) and o.refusing_lane == int(row[4]) and o.failure_reason == String(row[5]) \
					and not o.is_support_fallback_unavailable() and not o.failure_reason.contains("passive fallback is"):
				right += 1
		_expect(right == 64, "%s: %d of 64 attributed correctly" % [String(row[0]), right])
		lines.append("%s: %d of 64 refuse at the %s lane — '%s'" % [String(row[0]), right,
			RiftOffer.lane_label(int(row[4])), String(row[5])])
	## An ORDINARY Support refusal is still the Support lane's, beside a refusing passive lane.
	var ordinary: int = 0
	for root_seed: int in 64:
		var o: RiftOffer = RiftOfferComposition.compose(_profiles(), no_definitions, exhausted, only_utility, root_seed)
		_refusals += 1
		_collected_refusals.append([o, root_seed])
		if _is_bare_refusal(o, root_seed) and o.refusing_lane == SUPPORT_LANE \
				and o.failure_reason.begins_with("the Support lane refused: the support lane cannot continue") \
				and o.failure_reason.ends_with("(2 of 3 lanes refused)") and not o.is_support_fallback_unavailable():
			ordinary += 1
	_expect(ordinary == 64, "%d of 64 ordinary Support refusals were still named Support" % ordinary)
	## I6 is called in exactly one place, and only behind both conditions.
	var body: String = _function_body(_code(COMPOSER_FILE), "compose")
	var gate_at: int = body.find("if exhausted and passive_lanes_sound:")
	var call_at: int = body.find("SupportExhaustionPassiveFallback.select(")
	_expect(body.count("SupportExhaustionPassiveFallback.select(") == 1 and gate_at > 0 and call_at > gate_at
			and body.count("continuation.is_exhausted()") == 1
			and body.contains("combat.ok and combat.problem().is_empty()")
			and body.contains("utility.ok and utility.problem().is_empty()"),
		"the composer does not call the fallback once, behind exhaustion and both passive lanes")
	for line: String in lines:
		print("  " + line)
	print("  an ordinary Support refusal (no definitions) beside a refusing passive lane: %d of 64 still named Support with '(2 of 3 lanes refused)'" % ordinary)
	print("  refusing_lane names the first lane, in fixed order, whose own resolution refused; an exhausted Support lane is resolved only after both passive lanes succeed — otherwise it is neither named nor counted")
	print("  the composer calls SupportExhaustionPassiveFallback.select( exactly once, behind 'if exhausted and passive_lanes_sound:', reading is_exhausted() once")
	_done("a_passive_lane_refusal_is_attributed_to_that_lane")


# --- 11. Every refusal --------------------------------------------------------------------------------------------

func _check_every_refusal_carries_the_root_seed_and_nothing_else() -> void:
	print("")
	print("--- 11. Every refusal carries its root seed and no lane, identity, derivation, kind, card or rank")
	var bare: int = 0
	var reasons: Dictionary = {}
	var by_lane: Dictionary = {}
	for pair: Array in _collected_refusals:
		var o: RiftOffer = pair[0]
		if _is_bare_refusal(o, int(pair[1])):
			bare += 1
		reasons[o.failure_reason] = true
		_count(by_lane, RiftOffer.lane_label(o.refusing_lane))
	_expect(_collected_refusals.size() >= 1000 and bare == _collected_refusals.size(),
		"%d of %d collected refusals are bare" % [bare, _collected_refusals.size()])
	print("  %d of %d refused offers collected by checks 8-10 carry their own root seed and nothing else (%d distinct reasons; by lane %s)" % [
		bare, _collected_refusals.size(), reasons.size(), _owner_line(by_lane)])
	_done("every_refusal_carries_the_root_seed_and_nothing_else")


# --- 12. The choice transaction, extended by I8 (D-308) -------------------------------------------------------------------------

## MOVED ONE FOR ONE UNDER ROGUELITE FOUNDATION I8 (D-308). Under I7 these three assertions
## proved the unchanged D3 transaction refused a fallback Support lane atomically. I8
## authorizes the transaction to consume it, so the same three now prove it is consumed as
## one passive card, that the ordinary passive lanes are untouched, and — RECORDED, NOT
## DECIDED HERE — what the unchanged one-level coordinator does with the result. Neither
## choice is a refusal any more, so neither is counted as one.
func _check_the_choice_transaction_consumes_the_fallback_lane() -> void:
	print("")
	print("--- 12. The I8 choice transaction consumes a fallback Support lane as one passive card")
	var held: AcquiredSupports = _shipped(2, 2)
	var consumed: int = 0
	var passive_taken: int = 0
	for root_seed: int in SEED_SAMPLES:
		var offer: RiftOffer = _compose(held, _cards(), root_seed)
		var build: RiftRunBuild = _build(2, 2)
		build.acquire_passive_card(_record(_cards(), VITALITY))
		var ledger: RiftConsumptionLedger = RiftConsumptionLedger.new()
		ledger.consume(-424242)
		var before: String = "%s | %s" % [build.describe(), ledger.describe()]
		var card: StringName = offer.support_fallback_card_id
		var taken: RiftOfferChoiceResult = RiftOfferChoice.choose(offer, SUPPORT_LANE, build, ledger)
		if taken.ok and taken.carries_support_fallback() and taken.problem().is_empty() \
				and taken.root_seed == root_seed and taken.lane == SUPPORT_LANE \
				and ", ".join(taken.chosen_identity()) == String(card) \
				and taken.support_fallback_category == offer.support_fallback.selected_category \
				and taken.new_ledger.has_consumed(root_seed) and taken.new_ledger.count() == 2 \
				and taken.new_build.acquisitions_for(card) == build.acquisitions_for(card) + 1 \
				and taken.new_build.support_pairs() == build.support_pairs() \
				and taken.new_build.total_support_ranks() == build.total_support_ranks() \
				and "%s | %s" % [build.describe(), ledger.describe()] == before \
				and not ledger.has_consumed(root_seed) and ledger.count() == 1:
			consumed += 1
		## The two ordinary passive lanes are ordinary lanes, exactly as under I7.
		for lane: int in [COMBAT_LANE, UTILITY_LANE]:
			var passive: RiftOfferChoiceResult = RiftOfferChoice.choose(offer, lane, build, ledger)
			if passive.ok and passive.new_ledger.has_consumed(root_seed) \
					and passive.new_build.acquisitions_for(StringName(offer.identity_for(lane)[0])) \
						== build.acquisitions_for(StringName(offer.identity_for(lane)[0])) + 1:
				passive_taken += 1
	_expect(consumed == SEED_SAMPLES, "%d of %d fallback Support choices were consumed as one passive card" % [consumed, SEED_SAMPLES])
	_expect(passive_taken == 2 * SEED_SAMPLES, "%d of %d passive-lane choices of a fallback offer were taken" % [
		passive_taken, 2 * SEED_SAMPLES])

	## Through the unchanged one-level coordinator. RECORDED, NOT DECIDED HERE. Under I8 its
	## then-unchanged receipt could not describe a consumed fallback; since Roguelite Foundation
	## I9 (D-310) the receipt records the Support content kind and the fallback category, so the
	## same single assertion now requires it coherent and carrying the fallback.
	var lifecycle: RiftLevelUpCoordinator = RiftLevelUpCoordinator.with_state(null, _build(2, 2), null)
	var awarded: String = lifecycle.award_experience(100.0)
	var opened: String = lifecycle.open_offer(100.0, _profiles(), _definitions(), _cards(), 18)
	var identity: PackedStringArray = lifecycle.offer_identity_for(SUPPORT_LANE)
	var receipt: RiftLevelUpResult = lifecycle.choose(SUPPORT_LANE)
	_expect(awarded.is_empty() and opened.is_empty() and ", ".join(identity) == "card_celerity"
			and receipt.ok and receipt.root_seed == 18 and ", ".join(receipt.granted_identity()) == "card_celerity"
			and receipt.problem().is_empty() and receipt.carries_support_fallback()
			and receipt.support_fallback_category == COMBAT
			and receipt.support_fallback_line() == E2_FALLBACK_RECEIPT_LINE
			and not lifecycle.is_offer_active() and lifecycle.level() == 2 and lifecycle.is_completed()
			and lifecycle.consumption_ledger().count() == 1 and lifecycle.run_build().acquisitions_for(CELERITY) == 1,
		"the coordinator opened '%s' with [%s] and answered %s / '%s'" % [
			opened, ", ".join(identity), receipt.describe(), receipt.problem()])
	print("  %d of %d fallback offers: the Support lane is consumed as one passive card — its identity the fallback card, its category the fallback's, the card held once more, the seed spent once, no pair or rank moved, and the supplied values byte-identical" % [consumed, SEED_SAMPLES])
	print("  RECORDED, NOT DECIDED HERE: through the unchanged one-level coordinator at root seed 18 the fallback offer opens with Support [card_celerity] and choosing it completes the level-up — Level %d, %d seed consumed, card_celerity held once — and since I9 (D-310) its receipt is coherent and records it: '%s'" % [
		lifecycle.level(), lifecycle.consumption_ledger().count(), receipt.support_fallback_line()])
	print("  RECORDED, NOT DECIDED HERE: the choice transaction takes the two ORDINARY passive lanes of a fallback offer exactly as before — %d of %d such choices spent their seed and granted their card" % [passive_taken, 2 * SEED_SAMPLES])
	_done("the_i8_choice_transaction_consumes_the_fallback_lane")


# --- 13. Nothing running --------------------------------------------------------------------------------------------

func _check_nothing_running_uses_the_fallback_offer() -> void:
	print("")
	print("--- 13. Nothing that runs or renders uses the fallback offer")
	var scanned: int = 0
	var stray: PackedStringArray = PackedStringArray()
	var callers: PackedStringArray = PackedStringArray()
	for root: String in SCANNED_ROOTS:
		for path: String in _files_under(root, [".gd", ".tscn", ".tres"]):
			scanned += 1
			var text: String = FileAccess.get_file_as_string(path)
			if not D1_FILES.has(path):
				for token: String in I7_TOKENS:
					if text.contains(token) and not _consumer_may_name(path, token):
						stray.append("%s names %s" % [path.get_file(), token])
			if not D1_FILES.has(path) and path != FALLBACK_FILE and path != FALLBACK_RESULT_FILE \
					and text.contains("SupportExhaustionPassiveFallback"):
				stray.append("%s names the I6 fallback" % path.get_file())
			if text.contains("open_level_up_offer(") and not path.ends_with("rift_mote_runtime.gd"):
				callers.append(path.get_file())
	var settings: String = FileAccess.get_file_as_string(PROJECT_SETTINGS_FILE)
	for token: String in I7_TOKENS:
		if settings.contains(token):
			stray.append("project.godot names %s" % token)
	## Roguelite I11 (D-314) moved the second assertion one for one: the running review no longer
	## declares a single OFFERED_LEVEL; it asks each level's offer once, behind one integer guard
	## whose empty value is NO_LEVEL_ASKED, beginning at Level 1 from a fresh build.
	var review_constants: Dictionary = _constants("res://scripts/roguelite/level_up/roguelite_level_up_choice_review.gd")
	_expect(scanned > 100 and stray.is_empty(), "%d files scanned; %s" % [scanned, ", ".join(stray)])
	_expect(callers == PackedStringArray(["roguelite_level_up_choice_review.gd"]) and not review_constants.has("OFFERED_LEVEL")
			and review_constants.get("NO_LEVEL_ASKED") == 0,
		"the running offer is opened by [%s], the review declaring %s" % [", ".join(callers), str(review_constants.keys())])
	## The running path composes against a FRESH run build at Level 1.
	var fresh_fallbacks: int = 0
	var fresh_new_pairs: int = 0
	for root_seed: int in ROOT_SAMPLES:
		var o: RiftOffer = _compose(AcquiredSupports.new(), _cards(), root_seed)
		if o.support_content_kind == FALLBACK_KIND:
			fresh_fallbacks += 1
		if o.ok and o.support_content_kind == PROGRESSION_KIND and o.support_progression_kind == SupportContinuationResult.Kind.NEW_PAIR:
			fresh_new_pairs += 1
	_expect(fresh_fallbacks == 0 and fresh_new_pairs == ROOT_SAMPLES,
		"a fresh build composed %d fallbacks and %d new pairs" % [fresh_fallbacks, fresh_new_pairs])
	_expect(_action_count() == EXPECTED_ACTIONS and not settings.contains("[autoload]")
			and String(ProjectSettings.get_setting("application/run/main_scene", "")) == ENTRYPOINT,
		"project.godot holds %d actions" % _action_count())
	print("  %d running files scanned: none but the two offer files names an I7 member, except the five Support-content members the two D3 choice files are granted since I8 (D-308) and the level-up receipt since I9 (D-310), and the members I10 (D-312) grants both level-up coordinators, the mote runtime and the running review; none but the offer files and I6's own two names the fallback class; project.godot names none" % scanned)
	print("  the only running caller of the level-up offer is [roguelite_level_up_choice_review.gd], which since I11 (D-314) asks each level's offer once, beginning at Level 1; a fresh build composes %d of %d SUPPORT_PROGRESSION new pairs and 0 fallbacks" % [fresh_new_pairs, ROOT_SAMPLES])
	print("  project.godot: %d actions, the Prototype App entrypoint, no [autoload]" % _action_count())
	_done("nothing_running_uses_the_fallback_offer")

# --- 14. The offer contract, both kinds, both directions ---------------------------------------------------------

func _check_the_offer_contract_proves_each_kind_in_both_directions() -> void:
	print("")
	print("--- 14. RiftOffer.problem() proves each Support content kind in both directions")
	var fallback_offer: RiftOffer = _compose(_shipped(2, 2), _cards(), 18)
	var progression_offer: RiftOffer = _compose(AcquiredSupports.new(), _cards(), 18)
	var forged_continuation: SupportContinuationResult = SupportContinuationResult.exhaustion("a forged exhaustion")
	forged_continuation.kind = SupportContinuationResult.Kind.NEW_PAIR
	var cards: Array[PassiveCardDefinition] = _cards()
	var carried_power: SupportExhaustionPassiveFallbackResult = SupportExhaustionPassiveFallbackResult.chosen(
		COMBAT, [COMBAT, UTILITY] as Array[int], [&"zz_x", &"zz_y"] as Array[StringName], 0, 100, 0,
		PassiveCardSelection.select_with_ticket(cards, COMBAT, 100))
	var swapped_exclusion: SupportExhaustionPassiveFallbackResult = SupportExhaustionPassiveFallbackResult.chosen(
		COMBAT, [COMBAT, UTILITY] as Array[int], [INSIGHT, POWER] as Array[StringName], 0, 35, 0,
		PassiveCardSelection.select_with_ticket_excluding(cards, COMBAT, 35, [INSIGHT, POWER] as Array[StringName]))
	var other_tickets: SupportExhaustionPassiveFallbackResult = SupportExhaustionPassiveFallback.select_with_tickets(
		fallback_offer.support_continuation, fallback_offer.combat_derivation, fallback_offer.utility_derivation,
		cards, 0, 35)
	var controls: bool = fallback_offer.problem().is_empty() and progression_offer.problem().is_empty() \
		and carried_power.problem().is_empty() and swapped_exclusion.problem().is_empty() \
		and other_tickets.ok and other_tickets.selected_card_id == CELERITY
	_expect(controls, "a control is not coherent: '%s' / '%s' / '%s' / '%s'" % [fallback_offer.problem(),
		progression_offer.problem(), carried_power.problem(), swapped_exclusion.problem()])

	## [base, label, [field, value, ...], the words the refusal must contain]
	var rows: Array = [
		["fallback", "a Skill id", ["skill_id", &"zz_skill"], "must name no Skill or support"],
		["fallback", "a support id", ["support_id", &"zz_support"], "must name no Skill or support"],
		["fallback", "a weighted support derivation", ["support_derivation", progression_offer.support_derivation], "must carry no weighted support derivation"],
		["fallback", "a progression kind", ["support_progression_kind", SupportContinuationResult.Kind.NEW_PAIR], "must declare no support progression kind"],
		["fallback", "a frozen rank", ["support_rank_before", 0], "must freeze no support rank transition"],
		["fallback", "no continuation", ["support_continuation", null], "must carry the exhausted continuation"],
		["fallback", "a new-pair continuation", ["support_continuation", progression_offer.support_continuation], "may answer only an exhausted Support lane"],
		["fallback", "an incoherent continuation", ["support_continuation", forged_continuation], "exhausted continuation is incoherent"],
		["fallback", "another card id", ["support_fallback_card_id", VITALITY], "offers the passive fallback card_vitality but its fallback selected card_celerity"],
		["fallback", "no fallback result", ["support_fallback", null], "the Support lane carries no coherent derivation"],
		["fallback", "a card the Combat and Defence lane carries", ["support_fallback", carried_power, "support_fallback_card_id", POWER], "is already offered by a passive lane"],
		["fallback", "the exclusions in the wrong order", ["support_fallback", swapped_exclusion], "not the two passive lanes'"],
		["fallback", "tickets from another seed", ["support_fallback", other_tickets], "was not drawn from the Support lane seed 51507111"],
		["fallback", "an unknown kind", ["support_content_kind", 7], "unknown Support content kind 7"],
		["fallback", "the progression kind", ["support_content_kind", PROGRESSION_KIND], "the Support lane carries no coherent derivation"],
		["fallback", "the unavailable classification", ["support_fallback_unavailable", true], "must not declare its passive fallback unavailable"],
		["progression", "a fallback result", ["support_fallback", fallback_offer.support_fallback], "a support-progression lane must carry no passive fallback"],
		["progression", "a fallback card", ["support_fallback_card_id", CELERITY], "a support-progression lane must carry no passive fallback"],
		["progression", "the fallback kind", ["support_content_kind", FALLBACK_KIND], "the Support lane carries no coherent derivation"],
		["refusal", "a content kind", ["support_content_kind", FALLBACK_KIND], "must declare no Support content kind"],
		["refusal", "a fallback result", ["support_fallback", fallback_offer.support_fallback], "must expose no passive fallback"],
		["refusal", "a fallback card", ["support_fallback_card_id", CELERITY], "must expose no passive fallback"],
		["refusal", "the unavailable classification on another lane", ["support_fallback_unavailable", true], "only the Support lane refuses because its passive fallback is unavailable"],
	]
	var reported: int = 0
	var d3_refused: int = 0
	for row: Array in rows:
		var base: RiftOffer = null
		match String(row[0]):
			"fallback":
				base = _compose(_shipped(2, 2), _cards(), 18)
			"progression":
				base = _compose(AcquiredSupports.new(), _cards(), 18)
			_:
				base = RiftOffer.refused("a fabricated refusal", COMBAT_LANE, 5)
		var edits: Array = row[2]
		for index: int in range(0, edits.size(), 2):
			base.set(String(edits[index]), edits[index + 1])
		var problem: String = base.problem()
		if not problem.is_empty() and problem.contains(String(row[3])):
			reported += 1
		else:
			_expect(false, "%s with %s reported '%s'" % [String(row[0]), String(row[1]), problem])
		if String(row[0]) != "refusal":
			var build: RiftRunBuild = RiftRunBuild.new()
			var ledger: RiftConsumptionLedger = RiftConsumptionLedger.new()
			var taken: RiftOfferChoiceResult = RiftOfferChoice.choose(base, SUPPORT_LANE, build, ledger)
			_refusals += 1
			if not taken.ok and taken.failure_reason.contains("not internally coherent") and ledger.count() == 0:
				d3_refused += 1
	var tampered_offers: int = 0
	for row: Array in rows:
		if String(row[0]) != "refusal":
			tampered_offers += 1
	_expect(reported == rows.size() and d3_refused == tampered_offers,
		"%d of %d tamperings reported; %d of %d refused by the choice transaction" % [
			reported, rows.size(), d3_refused, tampered_offers])
	var default_unavailable: RiftOffer = RiftOffer.refused_as_fallback_unavailable("", 3)
	_expect(default_unavailable.problem().is_empty() and default_unavailable.is_support_fallback_unavailable()
			and default_unavailable.refusing_lane == SUPPORT_LANE and default_unavailable.root_seed == 3
			and default_unavailable.failure_reason == "the offer failed for an unstated reason"
			and not RiftOffer.refused("x", SUPPORT_LANE, 3).is_support_fallback_unavailable(),
		"the unavailable constructor reads '%s' / %s" % [default_unavailable.problem(), default_unavailable.describe()])
	print("  controls: the composed fallback offer, the composed progression offer and 2 forged-but-coherent I6 results are each coherent")
	print("  %d of %d single-field tamperings reported by name — 16 on a fallback offer, 3 on a progression offer, 4 on a refusal; the choice transaction refuses %d of %d tampered offers as incoherent" % [
		reported, rows.size(), d3_refused, tampered_offers])
	print("  a fallback offer may not carry a Skill, a support, a weighted derivation, a progression kind or a rank, may not drop or swap its exhausted continuation, and must carry its own card, drawn from its own Support lane seed, excluding exactly the two passive cards in lane order")
	_done("the_offer_contract_proves_each_kind_in_both_directions")


# --- 15. Shape ----------------------------------------------------------------------------------------------------

func _check_the_offer_and_composer_shapes_and_boundaries() -> void:
	print("")
	print("--- 15. The offer and composer shapes, named classes and boundaries")
	var offer_methods: PackedStringArray = _methods_of(OFFER_FILE)
	var composer_methods: PackedStringArray = _methods_of(COMPOSER_FILE)
	var offer_fields: PackedStringArray = _script_fields(RiftOffer.new())
	var composer_fields: PackedStringArray = _script_fields(RiftOfferComposition.new())
	_expect(", ".join(offer_methods) == ", ".join(EXPECTED_OFFER_METHODS), "the offer declares %s" % ", ".join(offer_methods))
	_expect(", ".join(offer_fields) == ", ".join(EXPECTED_OFFER_FIELDS), "the offer carries %s" % ", ".join(offer_fields))
	_expect(", ".join(composer_methods) == ", ".join(EXPECTED_COMPOSER_METHODS) and composer_fields.is_empty(),
		"the composer declares %s with state [%s]" % [", ".join(composer_methods), ", ".join(composer_fields)])
	_expect(RiftOffer.SupportContentKind.size() == 2 and RiftOffer.SupportContentKind.SUPPORT_PROGRESSION == 0
			and RiftOffer.SupportContentKind.PASSIVE_FALLBACK == 1 and RiftOffer.UNRESOLVED_SUPPORT_CONTENT_KIND == -1
			and RiftOffer.new().support_content_kind == RiftOffer.UNRESOLVED_SUPPORT_CONTENT_KIND,
		"the content kind vocabulary moved")

	var project_classes: PackedStringArray = PackedStringArray()
	for entry: Dictionary in ProjectSettings.get_global_class_list():
		project_classes.append(String(entry.get("class", "")))
	project_classes.sort()
	for row: Array in EXPECTED_NAMED_CLASSES:
		var source: String = FileAccess.get_file_as_string(String(row[0]))
		var actually: PackedStringArray = PackedStringArray()
		for class_id: String in project_classes:
			if not class_id.is_empty() and source.contains(class_id):
				actually.append(class_id)
		var wanted: PackedStringArray = PackedStringArray()
		for class_id: String in row[1]:
			wanted.append(class_id)
		_expect(", ".join(actually) == ", ".join(wanted), "%s names [%s]" % [String(row[0]).get_file(), ", ".join(actually)])

	var leaked: PackedStringArray = PackedStringArray()
	for path: String in D1_FILES:
		var raw: String = FileAccess.get_file_as_string(path)
		for token: String in CONCRETE_TOKENS + AMBIENT_TOKENS:
			if raw.contains(token):
				leaked.append("%s names %s" % [path.get_file(), token])
	var own: String = FileAccess.get_file_as_string("res://tests/passive_fallback_offer_composition_verification.gd")
	var found_here: int = 0
	for token: String in CONCRETE_TOKENS + AMBIENT_TOKENS:
		if own.contains(token):
			found_here += 1
	_expect(leaked.is_empty() and found_here >= 20, "leaks %s; the scan found %d tokens here" % [", ".join(leaked), found_here])

	var composer_code: String = _code(COMPOSER_FILE)
	var offer_code: String = _code(OFFER_FILE)
	_expect(composer_code.count("SupportExhaustionPassiveFallback.select(") == 1
			and composer_code.contains("continuation, combat, utility, cards, support_seed")
			and not composer_code.contains("select_with_tickets(")
			and composer_code.count(".is_exhausted()") == 1 and composer_code.count(".is_unavailable()") == 1
			and not composer_code.contains("failure_reason.contains(") and not composer_code.contains("failure_reason.begins_with(")
			and not composer_code.contains("failure_reason.find("),
		"the composer does not delegate to the fallback as documented, or reads a sentence")
	_expect(not offer_code.contains(".select(") and not offer_code.contains("select_with_tickets(")
			and offer_code.count("SupportExhaustionPassiveFallback.category_ticket_for(") == 1
			and offer_code.count("SupportExhaustionPassiveFallback.card_ticket_for(") == 1
			and offer_code.contains("func _support_progression_problem()")
			and offer_code.contains("support_transition_problem(\n\t\tsupport_progression_kind"),
		"the offer makes a selection or lost its moved block")

	var offers_dir: PackedStringArray = _listing("res://scripts/offers")
	var fallback_dir: PackedStringArray = _listing("res://scripts/fallback")
	_expect(", ".join(offers_dir) == "rift_offer.gd, rift_offer.gd.uid, rift_offer_composition.gd, rift_offer_composition.gd.uid"
			and ", ".join(fallback_dir) == "support_exhaustion_passive_fallback.gd, support_exhaustion_passive_fallback.gd.uid, support_exhaustion_passive_fallback_result.gd, support_exhaustion_passive_fallback_result.gd.uid"
			and not FileAccess.file_exists("res://tests/passive_fallback_offer_composition_verification.gd.uid"),
		"scripts/offers/ holds %s; scripts/fallback/ holds %s" % [", ".join(offers_dir), ", ".join(fallback_dir)])
	print("  methods pinned: offer %d, composer %d; the offer carries %d fields (the accepted 17 plus 4 appended); composer state: 0 fields" % [
		offer_methods.size(), composer_methods.size(), offer_fields.size()])
	print("  SupportContentKind {SUPPORT_PROGRESSION: 0, PASSIVE_FALLBACK: 1}, unresolved -1; the offer names exactly %d project classes and the composer %d" % [
		EXPECTED_NAMED_CLASSES[0][1].size(), EXPECTED_NAMED_CLASSES[1][1].size()])
	print("  both files scanned raw: 0 concrete names, 0 ambient reads; the composer calls the fallback once with the supplied cards and the Support lane seed and reads no sentence; the offer selects nothing")
	print("  scripts/offers/ and scripts/fallback/ each still hold exactly their 2 scripts and 2 uid files")
	_done("the_offer_and_composer_shapes_and_boundaries")


# --- 16. Unchanged accepted files ---------------------------------------------------------------------------------

func _check_accepted_files_outside_the_offer_are_unchanged() -> void:
	print("")
	print("--- 16. Every accepted file outside the two offer files is byte-identical")
	var unchanged: int = 0
	for row: Array in UNCHANGED_HASHES:
		var digest: String = FileAccess.get_sha256(String(row[0]))
		if digest.begins_with(String(row[1])):
			unchanged += 1
		else:
			_expect(false, "%s hashes %s, not %s…" % [String(row[0]), digest.left(8), String(row[1])])
	var edited: int = 0
	for row: Array in EDITED_HASHES:
		if FileAccess.get_sha256(String(row[0])).begins_with(String(row[1])):
			edited += 1
	_expect(unchanged == UNCHANGED_HASHES.size(), "%d of %d accepted files unchanged" % [unchanged, UNCHANGED_HASHES.size()])
	_expect(edited == EDITED_HASHES.size(), "%d of %d edited files at their D-306 hash" % [edited, EDITED_HASHES.size()])
	print("  %d of %d accepted files at their pinned SHA-256 prefix — byte-identical to the tree before the first I7 edit except the choice transaction and its result, pinned at their D-308 hashes, and the level-up receipt, pinned at its D-310 hash — the I6 mechanism, the selectors, the continuation, the choice transaction, both level-up coordinators and the receipt, the run build, the live-effect seam, the running review and its panel, and project.godot" % [unchanged, UNCHANGED_HASHES.size()])
	print("  the offer 9bc94208… and the composer 15ef203a… at their D-306 hashes")
	_done("accepted_files_outside_the_offer_are_unchanged")


# --- 17. The accepted suites' one-for-one moves ------------------------------------------------------------------

func _check_accepted_suites_moved_one_for_one() -> void:
	print("")
	print("--- 17. The accepted suites whose pins I7 moved carry exactly those moves")
	var d1: Dictionary = _constants(D1_SUITE)
	var i5: Dictionary = _constants(I5_SUITE)
	var i6: Dictionary = _constants(I6_SUITE)
	var d1_classes: Array = d1.get("AUTHORIZED_CLASSES", [])
	_expect(str(d1.get("EXPECTED_OFFER_METHODS")) == str(EXPECTED_OFFER_METHODS)
			and str(d1.get("EXPECTED_OFFER_FIELDS")) == str(EXPECTED_OFFER_FIELDS)
			and str(d1.get("EXPECTED_COMPOSER_METHODS")) == str(EXPECTED_COMPOSER_METHODS)
			and d1_classes.has("SupportExhaustionPassiveFallback") and d1_classes.has("SupportExhaustionPassiveFallbackResult"),
		"the D1 suite's pins do not match the delivered shape")
	var owners: Array = []
	for row: Array in i5.get("NEW_MEMBER_OWNERS", []):
		if String(row[0]) == "is_exhausted(":
			owners = row[1]
	_expect(owners.has("rift_offer_composition.gd") and owners.has("rift_offer.gd") and owners.size() == 4,
		"I5 grants is_exhausted( to %s" % str(owners))
	var i6_hashes: Dictionary = {}
	for row: Array in i6.get("ACCEPTED_HASHES", []):
		i6_hashes[String(row[0])] = String(row[1])
	var readers: Array = i6.get("COMPOSING_READERS", [])
	_expect(String(i6_hashes.get(OFFER_FILE, "")) == "9bc94208" and String(i6_hashes.get(COMPOSER_FILE, "")) == "15ef203a"
			and readers.has(OFFER_FILE) and readers.has(COMPOSER_FILE) and i6_hashes.size() == 24,
		"the I6 suite pins %s / %s and grants %s" % [i6_hashes.get(OFFER_FILE, ""), i6_hashes.get(COMPOSER_FILE, ""), str(readers)])
	var d1_runner: String = FileAccess.get_file_as_string(D1_RUNNER)
	var i5_runner: String = FileAccess.get_file_as_string(I5_RUNNER)
	var i6_runner: String = FileAccess.get_file_as_string(I6_RUNNER)
	_expect(d1_runner.contains("26 methods and 21 fields pinned")
			and i5_runner.contains("is_exhausted(|support_continuation_result.gd,support_exhaustion_passive_fallback.gd,rift_offer_composition.gd,rift_offer.gd")
			and i5_runner.contains("SupportExhaustionPassiveFallback SupportExhaustionPassiveFallbackResult")
			and i6_runner.contains("*/scripts/offers/rift_offer.gd|*/scripts/offers/rift_offer_composition.gd)"),
		"a runner does not carry its move")
	print("  D1: offer methods and fields and the two new classes pinned; I5: is_exhausted( granted to both offer files (4 owners); I6: the offer and composer hash prefixes moved to 9bc94208 / 15ef203a (24 rows) and both offer files granted the fallback classes")
	print("  runners: D1 measures '26 methods and 21 fields pinned'; I5 carries the widened row and the composer's two new classes; I6's shell scan grants both offer files")
	_done("accepted_suites_moved_one_for_one")


# --- Helpers -----------------------------------------------------------------------------------------------------

func _profiles() -> Array[SkillTagProfile]:
	return SkillSupportCatalogue.skill_profiles()


func _definitions() -> Array[SupportDefinition]:
	return SkillSupportCatalogue.support_definitions()


func _cards() -> Array[PassiveCardDefinition]:
	return PassiveCardCatalogue.records()


func _compose(held: AcquiredSupports, cards: Array[PassiveCardDefinition], root_seed: int) -> RiftOffer:
	return RiftOfferComposition.compose(_profiles(), _definitions(), held, cards, root_seed)


func _shipped(reaching: int, sweeping: int) -> AcquiredSupports:
	var record: AcquiredSupports = AcquiredSupports.new()
	for row: Array in [[REACHING, reaching], [SWEEPING, sweeping]]:
		var rank: int = int(row[1])
		if rank <= AcquiredSupports.ABSENT_RANK:
			continue
		record.acquire(QUICK_STRIKE, row[0] as StringName)
		for _step: int in range(rank - AcquiredSupports.FIRST_RANK):
			record.increase_rank(QUICK_STRIKE, row[0] as StringName)
	return record


## The same state as a run build, through the accepted run-build operations.
func _build(reaching: int, sweeping: int) -> RiftRunBuild:
	var build: RiftRunBuild = RiftRunBuild.new()
	for row: Array in [[REACHING, reaching], [SWEEPING, sweeping]]:
		if int(row[1]) >= 1:
			_expect(build.acquire_support(QUICK_STRIKE, row[0] as StringName).is_empty(), "the fixture could not acquire %s" % row[0])
		for _step: int in range(int(row[1]) - 1):
			_expect(build.rank_support(QUICK_STRIKE, row[0] as StringName).is_empty(), "the fixture could not rank %s" % row[0])
	return build


func _corpus_seeds() -> Array[int]:
	var seeds: Array[int] = []
	for s: int in 512:
		seeds.append(s)
	seeds.append_array(SPECIAL_SEEDS)
	return seeds


## The pre-I7 refusal corpus, built exactly as the probe built it.
func _refusal_corpus() -> PackedStringArray:
	var profiles: Array[SkillTagProfile] = _profiles()
	var definitions: Array[SupportDefinition] = _definitions()
	var cards: Array[PassiveCardDefinition] = _cards()
	var no_definitions: Array[SupportDefinition] = []
	var no_profiles: Array[SkillTagProfile] = []
	var no_cards: Array[PassiveCardDefinition] = []
	var only_utility: Array[PassiveCardDefinition] = []
	var only_combat: Array[PassiveCardDefinition] = []
	for card: PassiveCardDefinition in cards:
		if card.category() == UTILITY:
			only_utility.append(card)
		else:
			only_combat.append(card)
	var rows: PackedStringArray = PackedStringArray()
	for state: Array in [[0, 0], [1, 1], [2, 1]]:
		var held: AcquiredSupports = _shipped(int(state[0]), int(state[1]))
		for s: int in 64:
			rows.append("R%d S%d %d no-defs: %s" % [state[0], state[1], s, _row(RiftOfferComposition.compose(profiles, no_definitions, held, cards, s))])
			rows.append("R%d S%d %d no-profiles: %s" % [state[0], state[1], s, _row(RiftOfferComposition.compose(no_profiles, definitions, held, cards, s))])
			rows.append("R%d S%d %d no-cards: %s" % [state[0], state[1], s, _row(RiftOfferComposition.compose(profiles, definitions, held, no_cards, s))])
			rows.append("R%d S%d %d only-utility: %s" % [state[0], state[1], s, _row(RiftOfferComposition.compose(profiles, definitions, held, only_utility, s))])
			rows.append("R%d S%d %d only-combat: %s" % [state[0], state[1], s, _row(RiftOfferComposition.compose(profiles, definitions, held, only_combat, s))])
	return rows


## THE PRE-I7 ROW FORMATTER, VERBATIM FROM THE PROBE THAT MEASURED THE DIGESTS. It
## reads only members that existed before I7, so an unchanged digest is an unchanged
## offer.
func _row(o: RiftOffer) -> String:
	return "%s | %s | %s | refusing=%d | kind=%d | ranks=%d->%d | lanes=%s | %s | ok=%s | problem='%s' | ids=[%s][%s][%s] | cont=%s | sup=%s | com=%s | uti=%s" % [
		o.describe(), o.offer_line(), o.support_progression_line(), o.refusing_lane,
		o.support_progression_kind, o.support_rank_before, o.support_rank_after,
		str(o.lane_order()), o.seed_line(), o.ok, o.problem(),
		", ".join(o.identity_for(RiftOffer.Lane.SUPPORT)),
		", ".join(o.identity_for(RiftOffer.Lane.COMBAT_DEFENCE)),
		", ".join(o.identity_for(RiftOffer.Lane.UTILITY)),
		"none" if o.support_continuation == null else o.support_continuation.describe(),
		"none" if o.support_derivation == null else o.support_derivation.describe(),
		"none" if o.combat_derivation == null else o.combat_derivation.describe(),
		"none" if o.utility_derivation == null else o.utility_derivation.describe(),
	]


## The whole offer, I7's fields included.
func _full(o: RiftOffer) -> String:
	return "%s | content=%d card=%s unavailable=%s | %s | %s" % [_row(o), o.support_content_kind,
		o.support_fallback_card_id, o.support_fallback_unavailable, o.support_fallback_line(),
		_fallback_derivation(o.support_fallback)]


func _fallback_derivation(result: SupportExhaustionPassiveFallbackResult) -> String:
	if result == null:
		return "none"
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


func _ids(o: RiftOffer, lane: int) -> String:
	return ", ".join(o.identity_for(lane))


func _is_whole_fallback(o: RiftOffer) -> bool:
	return o.ok and o.problem().is_empty() and o.lane_order() == RiftOffer.LANE_ORDER \
		and o.lane_seeds.size() == 3 and o.support_content_kind == FALLBACK_KIND \
		and o.support_fallback != null and o.support_fallback.ok \
		and o.identity_for(SUPPORT_LANE).size() == 1 \
		and o.identity_for(SUPPORT_LANE)[0] == String(o.support_fallback_card_id) \
		and o.support_fallback_card_id != o.combat_card_id and o.support_fallback_card_id != o.utility_card_id \
		and String(o.skill_id).is_empty() and String(o.support_id).is_empty() and o.support_derivation == null \
		and o.support_progression_kind == RiftOffer.UNRESOLVED_PROGRESSION_KIND \
		and o.support_rank_before == RiftOffer.UNRESOLVED_RANK and o.support_rank_after == RiftOffer.UNRESOLVED_RANK \
		and o.support_continuation != null and o.support_continuation.is_exhausted() \
		and not o.support_fallback_unavailable


func _is_progression_offer(o: RiftOffer) -> bool:
	return o.ok and o.problem().is_empty() and o.support_content_kind == PROGRESSION_KIND \
		and o.support_fallback == null and String(o.support_fallback_card_id).is_empty() \
		and not o.support_fallback_unavailable \
		and _ids(o, SUPPORT_LANE) == "%s, %s" % [o.skill_id, o.support_id] \
		and o.support_fallback_line() == "no passive fallback"


## A refusal carrying its own root seed and nothing else, and a coherent record.
func _is_bare_refusal(o: RiftOffer, root_seed: int) -> bool:
	if o == null or o.ok or o.failure_reason.strip_edges().is_empty() or o.root_seed != root_seed:
		return false
	for lane: int in RiftOffer.LANE_ORDER:
		if not o.identity_for(lane).is_empty() or o.seed_for(lane) != RiftOffer.UNRESOLVED_SEED:
			return false
	return o.problem().is_empty() and o.lanes.is_empty() and o.lane_seeds.is_empty() \
		and String(o.skill_id).is_empty() and String(o.support_id).is_empty() \
		and String(o.combat_card_id).is_empty() and String(o.utility_card_id).is_empty() \
		and String(o.support_fallback_card_id).is_empty() \
		and o.support_continuation == null and o.support_derivation == null \
		and o.combat_derivation == null and o.utility_derivation == null and o.support_fallback == null \
		and o.support_content_kind == RiftOffer.UNRESOLVED_SUPPORT_CONTENT_KIND \
		and o.support_progression_kind == RiftOffer.UNRESOLVED_PROGRESSION_KIND \
		and o.support_rank_before == RiftOffer.UNRESOLVED_RANK and o.support_rank_after == RiftOffer.UNRESOLVED_RANK


## A fabricated card. Test data only; not canon.
func _card(card_id: String, stat_id: StringName, weight: int) -> PassiveCardDefinition:
	return PassiveCardDefinition.of(StringName(card_id), "Test %s" % card_id, stat_id, 0.10, weight, true)


func _catalogue(rows: Array) -> Array[PassiveCardDefinition]:
	var out: Array[PassiveCardDefinition] = []
	for row: Array in rows:
		out.append(_card(String(row[0]), row[1] as StringName, int(row[2])))
	return out


func _weighted_catalogue() -> Array[PassiveCardDefinition]:
	return _catalogue([
		["zz_c_alpha", &"global_damage", 3], ["zz_c_beta", &"skill_speed", 5], ["zz_c_gamma", &"maximum_life", 7],
		["zz_u_alpha", &"movement_speed", 2], ["zz_u_beta", &"experience_gain", 4], ["zz_u_gamma", &"pickup_radius", 6],
	])


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


func _reversed(records: Array[PassiveCardDefinition]) -> Array[PassiveCardDefinition]:
	var out: Array[PassiveCardDefinition] = []
	for index: int in range(records.size() - 1, -1, -1):
		out.append(records[index])
	return out


## Whether `path` is one of the files granted `token` by `CONSUMING_READERS` — the two
## choice files since Roguelite Foundation I8 (D-308), and the level-up receipt since I9
## (D-310). Per file and per member.
func _consumer_may_name(path: String, token: String) -> bool:
	for row: Array in CONSUMING_READERS:
		if String(row[0]) == path:
			return (row[1] as Array).has(token)
	return false


## A script's own constants, read from the engine rather than retyped.
func _constants(path: String) -> Dictionary:
	var script: GDScript = load(path) as GDScript
	return script.get_script_constant_map() if script != null else {}


## In-suite derivations from the documented formulas, never calling the project's.
func _test_lane_seed(root_seed: int, domain: int) -> int:
	return _test_mix((root_seed & 0xFFFFFFFF) ^ domain)


func _test_ticket(seed_value: int, domain: int) -> int:
	return _test_mix(((seed_value ^ domain) & 0xFFFFFFFF) ^ 0x9E3779B9)


func _test_mix(value: int) -> int:
	var x: int = value & 0xFFFFFFFF
	x = (x ^ (x >> 16)) * 0x7FEB_352D & 0xFFFFFFFF
	x = (x ^ (x >> 15)) * 0x846C_A68B & 0xFFFFFFFF
	x = x ^ (x >> 16)
	return x & 0xFFFFFFFF


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


func _listing(directory_path: String) -> PackedStringArray:
	var out: PackedStringArray = PackedStringArray()
	var dir: DirAccess = DirAccess.open(directory_path)
	if dir != null:
		for entry: String in dir.get_files():
			out.append(entry)
	out.sort()
	return out


func _action_count() -> int:
	var actions: int = 0
	for action: StringName in InputMap.get_actions():
		if String(action).begins_with("ui_") and not String(action) in ["ui_confirm", "ui_cancel"]:
			continue
		actions += 1
	return actions


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
