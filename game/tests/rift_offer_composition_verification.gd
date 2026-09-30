extends SceneTree
## Riftwrought — Roguelite Foundation D1 verification: Deterministic Three-Lane
## Rift Offer Composition (decision D-239).
##
## ONE FOCUSED HEADLESS TEST. The foundation is two pure-logic scripts under
## `scripts/offers/` — a composer and its result — so it needs no scene, no
## camera, no navigation, no rendering and no evidence frame, and it deliberately
## gets none. It runs as a `SceneTree` script exactly as all five earlier
## foundations' suites do.
##
## IT PORTS D-211's OWED-SET DISCIPLINE. Every check function records reaching
## its LAST line, and the suite compares that set against what it owes in BOTH
## directions, so a check that dies half way cannot leave a green run behind it.
##
## THE LOAD-BEARING PROOFS ARE EXACT, NOT STATISTICAL. Lane independence is
## proved by composing the SAME root seeds against a changed pool and requiring
## the untouched lanes to be bit-identical on their WHOLE derivation — every
## seed, no tolerance — and by requiring the touched lane to actually move, so a
## mutation that changed nothing cannot pass as a proof that nothing bled. No
## claim in this suite rests on a distribution.
##
## THE EXPECTED POOLS AND THE CORPUS ARE WRITTEN OUT HERE, NOT READ FROM THE
## THINGS THEY CHECK. A check that takes its expected answer from the mechanism
## it is checking proves only that a file agrees with itself. The two category
## pools, their order, the shipped weights, the three lane domains and every
## corpus row are typed independently below — and the corpus was additionally
## re-derived from an independent re-implementation of the whole derivation
## OUTSIDE the engine before it was pinned.
##
## THE TEST DATA IS NOT CONTENT. Every fabricated Skill profile, support
## definition and passive card built below lives inside this file only, is
## registered in no catalogue, ships in no scene, no `.tres` and no library, and
## is not canon. Quick Strike, the two shipped supports and the six shipped cards
## appear here as the FIXTURE the project can actually equip today; no production
## file names any of them, which is the property check 13 proves.

## The two scripts this foundation owns. NEITHER may name a Skill, a support, a
## card, a catalogue, a class outside its allowlist or a presentation name.
## Scanned RAW, comments included — D-215's lesson: an illustrative name in a
## comment breaches the rule just as surely as a real one.
const COMPOSER_FILE: String = "res://scripts/offers/rift_offer_composition.gd"
const OFFER_FILE: String = "res://scripts/offers/rift_offer.gd"

const D1_FILES: Array[String] = [
	"res://scripts/offers/rift_offer_composition.gd",
	"res://scripts/offers/rift_offer.gd",
]

## Concrete Skill, support, card, catalogue and instrument names. The same list
## the five earlier foundations are held to, plus both catalogues: a composer
## takes the records it is given, so naming either shipped set would make a
## generic mechanism the shipped set's own.
const FORBIDDEN_TOKENS: Array[String] = [
	"QuickStrike", "quick_strike", "Quick Strike",
	"PrototypePlayer", "PrototypeWeaponData", "PrototypeGraveblade",
	"PassiveEffects", "PassiveGraph", "PassiveNodeData",
	"RogueliteUpgrade", "RogueliteRunBoon", "RogueliteBuildState", "RogueliteRunPlan",
	"SkillSupportCatalogue", "SkillTags", "SupportEligibility",
	"FirstMvpSkill", "CharacterState", "ExperienceTable", "PlayerLoadout",
	"Faultbreaker", "Splinter Shot", "Emberbolt", "Marrowshot",
	"Reaching Edge", "reaching_edge", "Sweeping Edge", "sweeping_edge",
	"Expedition Blade", "Quickened Edge", "Quickened Form",
	"First Fracture", "first_fracture", "Graveblade", "Riftmarked",
	"PassiveCardCatalogue", "card_power", "card_celerity", "card_vitality",
	"card_fleetness", "card_insight", "card_magnetism",
]

## A pure composer may read no ambient state whatsoever.
const AMBIENT_TOKENS: Array[String] = [
	"randi", "randf", "randomize", "RandomNumberGenerator", "rand_from_seed",
	"Time.", "OS.", "Engine.", "ProjectSettings", "InputMap",
	"FileAccess", "ConfigFile", "ResourceSaver", "ResourceLoader", "user://",
]

## The presentation field the mechanism must be unable to see. Scanned for by
## name AND driven behaviourally, because either alone is weaker: a scan cannot
## see a name read through a helper, and a behavioural test cannot see a name
## read for a purpose that happens not to matter today.
const NAME_FIELD_TOKEN: String = "display_name"

## THE FIELDS A LADDER IS BUILT OUT OF. D1 delegates both weighted draws and must
## reimplement neither, and the method pin below is the strong form of that — but
## a composer could read a weight without declaring a method, so the field names
## a ladder needs are scanned for as well. None of them may appear in either D1
## file, in code or in a comment.
const LADDER_FIELD_TOKENS: Array[String] = [
	"base_weight", "effective_weight", "tag_bonuses", "matching_bonuses",
	"candidate_weights", "total_weight", "total_eligible_weight",
	"rolled_ticket", "normalized_ticket", "candidate_ids",
	"MINIMUM_BASE_WEIGHT", "MAXIMUM_TOTAL_WEIGHT", "MAXIMUM_WEIGHT",
]

## The two global class names this foundation introduces. Nothing that runs may
## reference either except an authorized reader below: D1 composes, and composing
## is still all it does — no experience, no level, no applying, no scene.
##
## NOTE THE SUBSTRING: `RiftOffer` is contained in `RiftOfferComposition`, so a
## file naming the composer is reported for both. That is the scan being blunt in
## the safe direction — everything is refused either way.
const D1_CLASSES: Array[String] = ["RiftOfferComposition", "RiftOffer"]

## THE FILES AUTHORIZED TO NAME A FOUNDATION D1 CLASS, AND THE EXACT CLASSES EACH
## MAY NAME (D-244). The Foundation D3 choice transaction is HANDED one composed
## offer and reads its lanes, its lane identities and its root seed; its result
## type carries the lane that was taken and asks the offer contract for that
## lane's own name and category. Both therefore name the OFFER — and neither may
## name the COMPOSER, because a mechanism that could compose its own offer could
## consume one nobody made, which is the entire property this foundation and D3
## exist to keep apart.
##
## THIS REPLACES D-239's BLANKET "no file that runs may name either class" ONE
## FOR ONE: the same single assertion is made either way, it still fails for any
## other file AND for any class a listed file is not granted, and the pinned count
## does not move.
##
## ONE SUBSTRING IS RECORDED RATHER THAN LEFT TO BE FOUND: `RiftOffer` is a
## prefix of `RiftOfferChoice` and `RiftOfferChoiceResult`, so those two files
## would be reported as naming the offer even if they only ever named themselves.
## They genuinely name it, and the D3 suite asserts that in its own right — which
## is what keeps this grant from being a claim about nothing.
const AUTHORIZED_READERS: Array = [
	["res://scripts/choices/rift_offer_choice.gd", ["RiftOffer"]],
	["res://scripts/choices/rift_offer_choice_result.gd", ["RiftOffer"]],
	## D-248: THE FOUNDATION E2 LEVEL-UP COORDINATOR IS THE FIRST FILE GRANTED
	## THE COMPOSER, AND THAT IS A DELIBERATE WIDENING RATHER THAN AN OVERSIGHT.
	## The paragraph above withholds it from the two D3 files because a mechanism
	## that could compose its own offer could consume one nobody made — and
	## composing exactly one offer, once, at a threshold it was told about, is
	## precisely what E2 exists to do. What keeps the property that grant
	## protects is that E2 opens ONE offer and then permanently refuses to open
	## another, which its own suite proves; the boundary moved from "nothing may
	## compose" to "one named coordinator may compose once", and it moved in the
	## open. It is granted the OFFER as well, which it stores, inspects and hands
	## to the transaction. Added one for one, and the pinned count does not move.
	["res://scripts/levels/rift_level_up_coordinator.gd",
		["RiftOffer", "RiftOfferComposition"]],
	## AND ITS RESULT TYPE IS GRANTED THE OFFER ALONE. It carries the lane that
	## was taken and asks the offer contract whether that lane is declared, what
	## its name is, and how the absence of one is spelled. It is refused the
	## COMPOSER exactly as the two D3 files are, which is what makes the grant
	## above per class rather than a blanket exemption for the foundation.
	["res://scripts/levels/rift_level_up_result.gd", ["RiftOffer"]],
	## Roguelite I2 (decision D-293): the Playable Three-Lane Level-Up Choice Review — an
	## isolated scene launched by name — shows the standing offer's lanes and asks the
	## offer contract what each lane is called and which one is Support. It is granted
	## the OFFER and refused the COMPOSER, exactly as the result type above. Added one
	## for one, and the pinned count does not move.
	["res://scripts/roguelite/level_up/roguelite_level_up_choice_review.gd", ["RiftOffer"]],
]

## `res://addons` IS SCANNED TOO. An editor plugin is code that runs; a reference
## from one would load these classes while a scripts/scenes/data scan reported
## nothing. `project.godot` is checked separately, because an `[autoload]` entry
## names a class from a file no extension filter would reach.
const SCANNED_ROOTS: Array[String] = [
	"res://scripts", "res://scenes", "res://data", "res://addons",
]

const PROJECT_SETTINGS_FILE: String = "res://project.godot"

## The only project classes the two D1 files may name. An ALLOWLIST derived from
## the engine's own global class list, not a denylist of remembered names.
##
## FOUNDATION F3 (D-255) ADDS TWO, ONE FOR ONE: the composer asks the accepted
## CONTINUATION selector for the whole support-lane decision, and the offer holds
## that decision and reads its mechanical kind. Nothing else was granted, and the
## exact per-file sets below are what keeps this list from being an OR-shaped
## permission for the foundation as a whole.
##
## ROGUELITE FOUNDATION I7 (D-306) ADDS TWO MORE, ONE FOR ONE: the accepted I6
## exhausted-support fallback and its result, which the composer calls and the
## offer holds. The allowlist assertion is unchanged in number.
const AUTHORIZED_CLASSES: Array[String] = [
	"RiftOffer", "RiftOfferComposition",
	"SkillTagProfile", "SupportDefinition", "AcquiredSupports",
	"SupportSelection", "SupportSelectionResult",
	"SupportContinuation", "SupportContinuationResult",
	"SupportExhaustionPassiveFallback", "SupportExhaustionPassiveFallbackResult",
	"PassiveCardDefinition", "PassiveCardSelection", "PassiveCardSelectionResult",
	"PlayerStatDefinition",
]

## Every method each script declares, in order, and no other. Pinned as NAMES
## rather than as a count, because the thing this guards against — a second
## weighted ladder, an acquisition step, an experience rule, a reroll — arrives
## as an extra method with a plausible name rather than as a missing one.
const EXPECTED_COMPOSER_METHODS: Array[String] = [
	"compose", "_stage_support_progression", "lane_domain_for", "lane_seed_for", "_mix",
]

## `support_transition_problem` ARRIVED WITH FOUNDATION F4 (D-257) AND IS AN
## EXTRACTION RATHER THAN A NEW RULE. The three branches deciding whether a frozen
## `0 -> 1` or `N -> N + 1` is legal were written inline inside `problem()`; they
## are now one static that `problem()` calls and returns verbatim, so the accepted
## choice transaction's result can re-check a progression it consumed against the
## SAME definition instead of carrying a second copy of it. No offer answer moved.
##
## ROGUELITE FOUNDATION I7 (D-306) ADDED SIX, MOVED ONE FOR ONE IN THIS SAME PIN: the
## fallback-unavailable refusal constructor, the passive-fallback success
## constructor, the classification's predicate, the fallback's presentation line,
## and the two named re-derivations `problem()` now calls — the progression block,
## moved out of `problem()` verbatim, and the fallback's own. Same single assertion.
const EXPECTED_OFFER_METHODS: Array[String] = [
	"refused", "refused_as_fallback_unavailable", "composed", "composed_with_passive_fallback",
	"category_for_lane", "is_declared_lane", "support_transition_problem",
	"lane_order", "is_support_fallback_unavailable", "seed_for", "identity_for", "lane_is_coherent",
	"problem", "_support_progression_problem", "_passive_fallback_problem",
	"lane_label", "support_progression_line", "support_fallback_line", "offer_line", "seed_line",
	"describe",
]

## ROGUELITE FOUNDATION I7 (D-306) APPENDED FOUR MORE AFTER THE SEVENTEEN BELOW, MOVED
## ONE FOR ONE: the Support lane's stored content kind, its passive-fallback card,
## the accepted fallback result it was composed from, and the refusal's
## fallback-unavailable classification. Every accepted field keeps its place.
##
## The seventeen fields an offer carries, in order, and no eighteenth. Foundation
## F3 added exactly four: the support lane's mechanical progression kind, the two
## frozen ranks, and the accepted continuation decision the first three are read
## from. The four scalars are safe as public fields for the reason D-249
## measured — a bool, an int or a String read out of an object cannot reach the
## object — and the two collections an offer carries are still `lanes` and
## `lane_seeds`, both of which are handed out only through copying accessors.
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

## Which project classes each D1 file names, EXACTLY, in this order. An
## at-least-one test is OR-shaped and is satisfied while a grant covering a
## second class quietly protects nothing.
##
## THE SUBSTRING RELATIONSHIPS ARE HONEST HERE RATHER THAN HIDDEN:
## `SupportSelection` is contained in `SupportSelectionResult` and
## `PassiveCardSelection` in `PassiveCardSelectionResult`, so a file naming
## either result is reported as naming its selector too. The stronger property —
## that the RESULT type never CALLS either selector — is asserted separately by
## its own token below.
const CLASS_UNIVERSE: Array[String] = [
	"SkillTagProfile", "SkillTags", "SupportEligibility", "SkillSupportCatalogue",
	"SupportDefinition", "AcquiredSupports", "SupportSelectionResult", "SupportSelection",
	"SupportContinuationResult", "SupportContinuation",
	"SupportExhaustionPassiveFallbackResult", "SupportExhaustionPassiveFallback",
	"PassiveCardDefinition", "PassiveCardCatalogue",
	"PassiveCardSelectionResult", "PassiveCardSelection",
	"PlayerStatDefinition", "PlayerStats", "PlayerStatValue", "PlayerStatTotals",
	"RiftOfferComposition", "RiftOffer",
]

## THE COMPOSER NO LONGER NAMES THE WEIGHTED SUPPORT SELECTOR AT ALL, AND THAT IS
## THE POINT OF FOUNDATION F3 RATHER THAN AN ACCIDENT OF EDITING: the support
## lane is decided by the accepted CONTINUATION selector, which owns the
## new-pair-before-rank policy and delegates the draw itself. The OFFER still
## names the weighted RESULT, because it holds the derivation that decision was
## made from.
##
## THE OFFER NOW NAMES THE ACQUISITION RECORD, and it names it for exactly one
## reason: it reads that record's own two named ranks — the rank an absent pair
## reports and the rank a first acquisition begins at — so the frozen transition
## is checked against F1's vocabulary instead of against two integers retyped
## here. It holds no acquisition state and constructs none, which check 13 asserts
## separately.
##
## ROGUELITE FOUNDATION I7 (D-306) ADDS THE ACCEPTED I6 FALLBACK'S TWO CLASSES TO BOTH
## ROWS, ONE FOR ONE: the composer asks the fallback for the exhausted Support lane's
## card, and the offer holds the fallback's result and re-derives its two stage
## tickets from the Support lane seed. Same two assertions, same count.
const EXPECTED_NAMED_CLASSES: Array = [
	["res://scripts/offers/rift_offer_composition.gd", [
		"SkillTagProfile", "SupportDefinition", "AcquiredSupports",
		"SupportContinuationResult", "SupportContinuation",
		"SupportExhaustionPassiveFallbackResult", "SupportExhaustionPassiveFallback",
		"PassiveCardDefinition", "PassiveCardSelectionResult", "PassiveCardSelection",
		"RiftOfferComposition", "RiftOffer",
	]],
	["res://scripts/offers/rift_offer.gd", [
		"AcquiredSupports", "SupportSelectionResult", "SupportSelection",
		"SupportContinuationResult", "SupportContinuation",
		"SupportExhaustionPassiveFallbackResult", "SupportExhaustionPassiveFallback",
		"PassiveCardSelectionResult", "PassiveCardSelection",
		"PlayerStatDefinition", "RiftOffer",
	]],
]

## The result type describes a composition; it must never make one. Neither call
## may appear in it. The support entry moved one for one when Foundation F3
## routed the support lane through the accepted continuation selector.
const SELECTOR_CALL_TOKENS: Array[String] = [
	"SupportContinuation.select", "PassiveCardSelection.select",
]

## THE CALL THE COMPOSER MUST NOT MAKE. Reaching around the accepted continuation
## decision to the weighted selector underneath it would put the
## new-pair-before-rank policy back inside a composer as a second, subtly
## different copy — the exact outcome F3 exists to avoid — and it would pass every
## other scan in this file, because the class is one this foundation is
## legitimately allowed to name.
const FORBIDDEN_COMPOSER_CALL: String = "SupportSelection.select"

## The two ranked-ownership members the composer is authorized to call, and the
## only two. It stages the decided operation on a discarded duplicate to MEASURE
## the transition it freezes; anything beyond reading a rank and applying the
## decided operation would be the composer deciding something.
const STAGING_MEMBERS: Array[String] = ["rank_for(", "increase_rank(", "acquire("]

## The ranked-ownership members the composer must NOT call: it records no
## progression of its own, and it must never raise a rank on anything a caller
## can still see.
const FORBIDDEN_STAGING_MEMBERS: Array[String] = [
	"total_ranks(", "rank_support(", "support_rank_for(", "total_support_ranks(",
	"release(",
]

## The five accepted foundations' suites, each of which must authorize the D1
## files it newly permits to name its classes. Two independently typed copies of
## one list is how they drift, so each grant is checked from this side as well.
const AUTHORIZING_SUITES: Array = [
	["res://tests/skill_tag_eligibility_verification.gd", "A",
		["res://scripts/offers/rift_offer_composition.gd"]],
	["res://tests/support_selection_verification.gd", "B",
		["res://scripts/offers/rift_offer_composition.gd",
			"res://scripts/offers/rift_offer.gd"]],
	["res://tests/player_stat_vocabulary_verification.gd", "C1",
		["res://scripts/offers/rift_offer.gd"]],
	["res://tests/passive_card_records_verification.gd", "C2",
		["res://scripts/offers/rift_offer_composition.gd"]],
	["res://tests/passive_card_selection_verification.gd", "C3",
		["res://scripts/offers/rift_offer_composition.gd",
			"res://scripts/offers/rift_offer.gd"]],
	## FOUNDATION F3 ADDS TWO MORE. The ranked-ownership suite proves that nothing
	## that runs calls any of its six members, and the composer is now the one
	## file that calls two of them; the continuation suite proves that nothing
	## names either of its classes, and both D1 files now name them. Each of those
	## suites had to grant this foundation an exemption, and an exemption nobody
	## checks from the other side is how two independently typed lists drift.
	["res://tests/ranked_support_ownership_verification.gd", "F1",
		["res://scripts/offers/rift_offer_composition.gd"]],
	["res://tests/support_continuation_verification.gd", "F2",
		["res://scripts/offers/rift_offer_composition.gd",
			"res://scripts/offers/rift_offer.gd"]],
]

# --- The three lane domains, typed independently of the composer -----------------

const EXPECTED_SUPPORT_DOMAIN: int = 0x6A09E667
const EXPECTED_COMBAT_DOMAIN: int = 0xBB67AE85
const EXPECTED_UTILITY_DOMAIN: int = 0x3C6EF372

## The two stream salts the accepted selectors already use. A lane domain must
## equal neither, so a lane's stream and a nested stream can never coincide.
const NESTED_STREAM_SALTS: Array[int] = [0x9E3779B9, 0x85EBCA6B]

## The other three copies of the 32-bit avalanche finalizer this project carries.
## Loaded by PATH and called dynamically rather than named as classes, so this
## check is a measurement of files on disk rather than a compile-time dependency
## on three private members — and so it fails loudly with a readable message if
## one of them is ever moved.
const MIXER_TWINS: Array[String] = [
	"res://scripts/skills/support_selection.gd",
	"res://scripts/stats/passive_card_selection.gd",
	"res://scripts/roguelite/roguelite_run_plan.gd",
]

# --- The two expected passive pools, typed independently of the catalogue --------
#
# In LADDER ORDER, which is ascending stable id.

const COMBAT_POOL: Array[String] = ["card_celerity", "card_power", "card_vitality"]
const UTILITY_POOL: Array[String] = ["card_fleetness", "card_insight", "card_magnetism"]

## The two shipped supports, in ascending stable id order.
const SHIPPED_SUPPORTS: Array[String] = ["reaching_edge", "sweeping_edge"]

## The one Skill the project can equip today.
const SHIPPED_SKILL: String = "quick_strike"

## How many identical calls a determinism claim is made over.
const REPEAT_CALLS: int = 100

## How many seeds every independence and order claim is made over. Each seed is
## an EXACT comparison of a whole derivation, not a sample of a distribution.
const SEED_SAMPLES: int = 256

## How many roots the lane-seed collision claim is made over.
const ROOT_SAMPLES: int = 4096

## How many values the four mixer copies are compared over.
const MIXER_SAMPLES: int = 1000

## THE PINNED CORPUS: root seed, the three lane seeds in lane order, then the
## Skill, the support, the Combat and Defence card and the Utility card.
##
## A REGRESSION PIN, AND MORE THAN ONE. It proves the composition cannot move
## silently; it also proves the derivation itself, because every row was
## RE-DERIVED FROM AN INDEPENDENT RE-IMPLEMENTATION OF THE WHOLE CHAIN OUTSIDE
## THE ENGINE — the finalizer, the three lane domains, both nested stream
## derivations and all three ladders, retyped from the specifications rather than
## read from the project — and all fourteen rows and all forty-two lane seeds
## agreed before they were pinned. Negative and 64-bit seeds are in the corpus on
## purpose.
const SEED_CORPUS: Array = [
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

## The one root seed every independence check is demonstrated at by name, chosen
## because all four mutations move their own lane at it — so the four
## demonstrations are not silently comparing two identical offers.
const INDEPENDENCE_SEED: int = 18

## The measured number of seeds, out of `SEED_SAMPLES`, at which each mutation
## moves its own lane's SELECTED IDENTITY. Pinned exactly, because "the untouched
## lanes did not move" is worthless unless the touched one did.
const EXPECTED_COMBAT_WEIGHT_MOVES: int = 142
const EXPECTED_UTILITY_WEIGHT_MOVES: int = 139
const EXPECTED_SUPPORT_WEIGHT_MOVES: int = 126
const EXPECTED_WIDER_POOL_MOVES: int = 168

## The weight a mutated record is given. Chosen so the ladder's TOTAL moves as
## well as one rung's share of it, which is what makes the mutation reach the
## reduced ticket rather than only the walk.
const MUTATED_WEIGHT: int = 250

const OWED_CHECKS: Array[String] = [
	"one_valid_input_produces_three_lanes_in_the_fixed_order",
	"the_support_lane_is_resolved_by_the_accepted_support_selector",
	"each_passive_lane_belongs_only_to_its_own_category",
	"identical_inputs_and_a_root_seed_reproduce_every_lane",
	"input_order_cannot_change_an_offer",
	"presentation_names_cannot_change_an_offer",
	"the_documented_root_seeds_reproduce_a_fixed_corpus",
	"the_three_lane_domains_are_fixed_distinct_and_never_collide",
	"the_support_pool_and_its_weights_move_only_the_support_lane",
	"a_combat_passive_weight_moves_only_the_combat_lane",
	"a_utility_passive_weight_moves_only_the_utility_lane",
	"every_refusal_names_its_lane_and_exposes_no_partial_offer",
	"the_composer_is_generic_reads_nothing_ambient_and_is_unwired",
]

var _failures: PackedStringArray = PackedStringArray()
var _checks: int = 0
var _reached: Dictionary = {}
var _refusals: int = 0


func _initialize() -> void:
	print("")
	print("=== Roguelite Foundation D1 — Three-Lane Rift Offer Composition (D-239) ===")

	_check_one_valid_input_produces_three_lanes_in_the_fixed_order()
	_check_the_support_lane_is_resolved_by_the_accepted_support_selector()
	_check_each_passive_lane_belongs_only_to_its_own_category()
	_check_identical_inputs_and_a_root_seed_reproduce_every_lane()
	_check_input_order_cannot_change_an_offer()
	_check_presentation_names_cannot_change_an_offer()
	_check_the_documented_root_seeds_reproduce_a_fixed_corpus()
	_check_the_three_lane_domains_are_fixed_distinct_and_never_collide()
	_check_the_support_pool_and_its_weights_move_only_the_support_lane()
	_check_a_combat_passive_weight_moves_only_the_combat_lane()
	_check_a_utility_passive_weight_moves_only_the_utility_lane()
	_check_every_refusal_names_its_lane_and_exposes_no_partial_offer()
	_check_the_composer_is_generic_reads_nothing_ambient_and_is_unwired()

	_check_every_check_ran()

	print("")
	if _failures.is_empty():
		print("RIFT OFFER COMPOSITION VERIFICATION: PASS (%d checks)" % _checks)
		quit(0)
	else:
		for failure: String in _failures:
			printerr("  FAIL: %s" % failure)
		printerr("RIFT OFFER COMPOSITION VERIFICATION: %d FAILURE(S) of %d checks" % [
			_failures.size(), _checks,
		])
		quit(1)


# --- 1. The fixed 1 + 1 + 1 shape, in the fixed order ---------------------------

func _check_one_valid_input_produces_three_lanes_in_the_fixed_order() -> void:
	print("")
	print("--- 1. One valid input produces exactly three lanes in the fixed order")

	var offer: RiftOffer = _shipped_offer(INDEPENDENCE_SEED)
	_expect(offer.ok, "a valid greybox input was refused: %s" % offer.failure_reason)
	_expect(offer.problem().is_empty(), "the offer is incoherent: %s" % offer.problem())
	_expect(offer.root_seed == INDEPENDENCE_SEED,
		"the offer echoes root seed %d, not %d" % [offer.root_seed, INDEPENDENCE_SEED])
	_expect(offer.refusing_lane == RiftOffer.UNRESOLVED_LANE,
		"a successful offer names lane %d as having refused" % offer.refusing_lane)
	_expect(offer.failure_reason.is_empty(),
		"a successful offer states the reason '%s'" % offer.failure_reason)

	## THE ORDER, MEMBER FOR MEMBER. A three-entry array in the wrong order is
	## exactly the failure a length test cannot see, so the expected order is
	## typed here rather than read from the constant it is checking.
	var expected_order: Array[int] = [
		RiftOffer.Lane.SUPPORT, RiftOffer.Lane.COMBAT_DEFENCE, RiftOffer.Lane.UTILITY,
	]
	_expect(offer.lane_order().size() == 3,
		"the offer carries %d lanes, not 3" % offer.lane_order().size())
	for index: int in expected_order.size():
		_expect(offer.lane_order()[index] == expected_order[index],
			"lane %d of the offer is %d, not %d" % [
				index, offer.lane_order()[index], expected_order[index],
			])
	_expect(", ".join(_as_text(RiftOffer.LANE_ORDER)) == ", ".join(_as_text(expected_order)),
		"the declared lane order is [%s]" % ", ".join(_as_text(RiftOffer.LANE_ORDER)))

	## LANE IDENTITY IS MECHANICAL. Each lane is asked for BY MEMBER, and the
	## answer must agree with the offer's own named fields — which is the whole
	## difference between reading a lane and reading an array position.
	var support_identity: PackedStringArray = offer.identity_for(RiftOffer.Lane.SUPPORT)
	var combat_identity: PackedStringArray = offer.identity_for(RiftOffer.Lane.COMBAT_DEFENCE)
	var utility_identity: PackedStringArray = offer.identity_for(RiftOffer.Lane.UTILITY)
	_expect(support_identity.size() == 2,
		"the support lane offers %d identities, not 2" % support_identity.size())
	_expect(combat_identity.size() == 1,
		"the combat lane offers %d identities, not 1" % combat_identity.size())
	_expect(utility_identity.size() == 1,
		"the utility lane offers %d identities, not 1" % utility_identity.size())
	_expect(support_identity.size() > 1
			and support_identity[0] == String(offer.skill_id)
			and support_identity[1] == String(offer.support_id),
		"the support lane identifies [%s] but the offer names %s -> %s" % [
			", ".join(support_identity), offer.skill_id, offer.support_id,
		])
	_expect(combat_identity.size() > 0 and combat_identity[0] == String(offer.combat_card_id),
		"the combat lane identifies [%s] but the offer names %s" % [
			", ".join(combat_identity), offer.combat_card_id,
		])
	_expect(utility_identity.size() > 0 and utility_identity[0] == String(offer.utility_card_id),
		"the utility lane identifies [%s] but the offer names %s" % [
			", ".join(utility_identity), offer.utility_card_id,
		])
	_expect(support_identity.size() + combat_identity.size() + utility_identity.size() == 4,
		"the offer carries %d identities, not the fixed 2 + 1 + 1" % (
			support_identity.size() + combat_identity.size() + utility_identity.size()
		))

	## THE THREE LANE SEEDS ARE THE ONES THE PUBLIC DERIVATION PRODUCES, checked
	## by recomputing each of them rather than by reading the offer twice.
	for lane: int in expected_order:
		_expect(offer.seed_for(lane) == RiftOfferComposition.lane_seed_for(
				INDEPENDENCE_SEED, lane),
			"the %s lane reports seed %d, not the derived %d" % [
				RiftOffer.lane_label(lane), offer.seed_for(lane),
				RiftOfferComposition.lane_seed_for(INDEPENDENCE_SEED, lane),
			])

	## THERE IS NO FOURTH LANE, AND ASKING FOR ONE IS ANSWERED HONESTLY RATHER
	## THAN PLAUSIBLY.
	_expect(offer.identity_for(99).is_empty(),
		"an undeclared lane offers [%s]" % ", ".join(offer.identity_for(99)))
	_expect(offer.seed_for(99) == RiftOffer.UNRESOLVED_SEED,
		"an undeclared lane reports the seed %d" % offer.seed_for(99))
	_expect(not offer.lane_is_coherent(99), "an undeclared lane reports itself coherent")
	_expect(not RiftOffer.is_declared_lane(99), "99 is reported as a declared lane")
	for lane: int in expected_order:
		_expect(RiftOffer.is_declared_lane(lane),
			"the declared lane %d is not reported as one" % lane)

	## THE SUPPORT LANE NAMES BOTH HALVES OF ITS PAIR, which is the one thing a
	## support lane must do that a passive lane must not.
	_expect(not String(offer.skill_id).is_empty(), "the support lane names no Skill")
	_expect(not String(offer.support_id).is_empty(), "the support lane names no support")
	_expect(offer.combat_card_id != offer.utility_card_id,
		"both passive lanes offer %s" % offer.combat_card_id)

	print("  three lanes in the fixed order %s; %d identities; a fourth lane answers nothing" % [
		", ".join(_lane_labels(expected_order)),
		support_identity.size() + combat_identity.size() + utility_identity.size(),
	])
	_done("one_valid_input_produces_three_lanes_in_the_fixed_order")


# --- 2. The support lane is Foundation B's answer, not a second one --------------

func _check_the_support_lane_is_resolved_by_the_accepted_support_selector() -> void:
	print("")
	print("--- 2. The support lane is resolved by Foundation B and is eligible")

	var profiles: Array[SkillTagProfile] = SkillSupportCatalogue.skill_profiles()
	var definitions: Array[SupportDefinition] = SkillSupportCatalogue.support_definitions()
	var cards: Array[PassiveCardDefinition] = PassiveCardCatalogue.records()

	## THE DELEGATION IS PROVED RATHER THAN PROMISED: the accepted selector is
	## called directly on the lane seed the offer reports, and its whole
	## derivation must equal the one the offer carries.
	var delegated: int = 0
	var eligible: int = 0
	var in_pool: int = 0
	for seed_value: int in SEED_SAMPLES:
		var offer: RiftOffer = RiftOfferComposition.compose(
			profiles, definitions, null, cards, seed_value)
		if not offer.ok:
			_expect(false, "seed %d was refused: %s" % [seed_value, offer.failure_reason])
			continue
		var direct: SupportSelectionResult = SupportSelection.select(
			profiles, definitions, null, offer.seed_for(RiftOffer.Lane.SUPPORT))
		if direct.describe() == offer.support_derivation.describe() \
				and direct.pair() == offer.support_derivation.pair():
			delegated += 1
		## ELIGIBILITY IS RE-DERIVED FROM THE SUPPLIED RECORDS, not read back out
		## of the result that selected them. The rule object is found by id and
		## asked whether it accepts the profile that was offered it.
		var profile: SkillTagProfile = _profile_with_id(profiles, offer.skill_id)
		var definition: SupportDefinition = _definition_with_id(definitions, offer.support_id)
		if profile != null and definition != null and definition.allows(profile):
			eligible += 1
		if profile != null and definition != null:
			in_pool += 1
	_expect(delegated == SEED_SAMPLES,
		"%d of %d support lanes reproduce Foundation B's own answer" % [delegated, SEED_SAMPLES])
	_expect(eligible == SEED_SAMPLES,
		"%d of %d offered supports are eligible for the Skill they were offered on" % [
			eligible, SEED_SAMPLES,
		])
	_expect(in_pool == SEED_SAMPLES,
		"%d of %d offered pairs came from the supplied records" % [in_pool, SEED_SAMPLES])

	## AN INELIGIBLE SUPPORT IS NEVER OFFERED, and the pool is proved to actually
	## contain one — a check that no forbidden thing appeared is worthless if no
	## forbidden thing was ever available.
	var mixed: Array[SupportDefinition] = [
		_definition(&"t1_melee_only", [SkillTags.MELEE] as Array[StringName], 100),
		_definition(&"t2_spell_only", [SkillTags.SPELL] as Array[StringName], 100),
	]
	var melee: Array[SkillTagProfile] = [_profile(&"s1_contact", [
		SkillTags.ATTACK, SkillTags.HIT, SkillTags.MELEE, SkillTags.PHYSICAL,
	] as Array[StringName])]
	_expect(not mixed[1].allows(melee[0]),
		"the spell-only support accepts a melee Skill, so its absence proves nothing")
	_expect(mixed[0].allows(melee[0]), "the melee support refuses a melee Skill")
	var ineligible_offered: int = 0
	var eligible_offered: int = 0
	for seed_value: int in SEED_SAMPLES:
		var offer: RiftOffer = RiftOfferComposition.compose(melee, mixed, null, cards, seed_value)
		if not offer.ok:
			_expect(false, "the mixed pool refused seed %d: %s" % [
				seed_value, offer.failure_reason])
			continue
		if offer.support_id == &"t2_spell_only":
			ineligible_offered += 1
		if offer.support_id == &"t1_melee_only":
			eligible_offered += 1
	_expect(ineligible_offered == 0,
		"an ineligible support was offered %d times" % ineligible_offered)
	_expect(eligible_offered == SEED_SAMPLES,
		"the eligible support was offered %d of %d times" % [eligible_offered, SEED_SAMPLES])

	## BOTH SHIPPED SUPPORTS ARE REACHABLE, so a stream stuck on one answer would
	## fail here rather than pass quietly.
	var reached: Dictionary = {}
	for seed_value: int in SEED_SAMPLES:
		var offer: RiftOffer = RiftOfferComposition.compose(
			profiles, definitions, null, cards, seed_value)
		if offer.ok:
			reached[String(offer.support_id)] = true
	for support_id: String in SHIPPED_SUPPORTS:
		_expect(reached.has(support_id),
			"%s was never offered over %d seeds" % [support_id, SEED_SAMPLES])
	_expect(reached.size() == SHIPPED_SUPPORTS.size(),
		"%d distinct supports were offered, not %d" % [
			reached.size(), SHIPPED_SUPPORTS.size(),
		])

	print("  %d of %d support lanes reproduce Foundation B exactly and are eligible; "
		% [delegated, SEED_SAMPLES]
		+ "an ineligible support was offered %d times; %d of %d shipped supports reached"
			% [ineligible_offered, reached.size(), SHIPPED_SUPPORTS.size()])
	_done("the_support_lane_is_resolved_by_the_accepted_support_selector")


# --- 3. Each passive lane draws from its own category and no other ---------------

func _check_each_passive_lane_belongs_only_to_its_own_category() -> void:
	print("")
	print("--- 3. Each passive lane belongs only to its own category")

	var cards: Array[PassiveCardDefinition] = PassiveCardCatalogue.records()

	## THE TWO POOLS PARTITION THE CATALOGUE, derived through each RECORD's own
	## canonical stat definition rather than through the selector that filters on
	## it. Both memberships, in both directions.
	var combat_seen: Array[String] = []
	var utility_seen: Array[String] = []
	for record: PassiveCardDefinition in cards:
		if record.category() == PlayerStatDefinition.Category.COMBAT_DEFENCE:
			combat_seen.append(String(record.card_id))
		elif record.category() == PlayerStatDefinition.Category.UTILITY:
			utility_seen.append(String(record.card_id))
		else:
			_expect(false, "%s derives the category %d" % [record.card_id, record.category()])
	combat_seen.sort()
	utility_seen.sort()
	_expect(", ".join(combat_seen) == ", ".join(COMBAT_POOL),
		"the combat category holds [%s], not [%s]" % [
			", ".join(combat_seen), ", ".join(COMBAT_POOL),
		])
	_expect(", ".join(utility_seen) == ", ".join(UTILITY_POOL),
		"the utility category holds [%s], not [%s]" % [
			", ".join(utility_seen), ", ".join(UTILITY_POOL),
		])
	var shared: int = 0
	for card_id: String in COMBAT_POOL:
		if UTILITY_POOL.has(card_id):
			shared += 1
	_expect(shared == 0, "%d card(s) appear in both expected pools" % shared)
	_expect(combat_seen.size() + utility_seen.size() == cards.size(),
		"%d of %d records were placed in a pool" % [
			combat_seen.size() + utility_seen.size(), cards.size(),
		])

	## AND THE LANES HONOUR THAT PARTITION OVER EVERY SEED, with the delegation
	## proved against the accepted selector called directly on the reported seed.
	var profiles: Array[SkillTagProfile] = SkillSupportCatalogue.skill_profiles()
	var definitions: Array[SupportDefinition] = SkillSupportCatalogue.support_definitions()
	var combat_wrong: int = 0
	var utility_wrong: int = 0
	var combat_delegated: int = 0
	var utility_delegated: int = 0
	var combat_reached: Dictionary = {}
	var utility_reached: Dictionary = {}
	for seed_value: int in SEED_SAMPLES:
		var offer: RiftOffer = RiftOfferComposition.compose(
			profiles, definitions, null, cards, seed_value)
		if not offer.ok:
			_expect(false, "seed %d was refused: %s" % [seed_value, offer.failure_reason])
			continue
		if not COMBAT_POOL.has(String(offer.combat_card_id)) \
				or UTILITY_POOL.has(String(offer.combat_card_id)):
			combat_wrong += 1
		if not UTILITY_POOL.has(String(offer.utility_card_id)) \
				or COMBAT_POOL.has(String(offer.utility_card_id)):
			utility_wrong += 1
		combat_reached[String(offer.combat_card_id)] = true
		utility_reached[String(offer.utility_card_id)] = true
		var direct_combat: PassiveCardSelectionResult = PassiveCardSelection.select(
			cards, PlayerStatDefinition.Category.COMBAT_DEFENCE,
			offer.seed_for(RiftOffer.Lane.COMBAT_DEFENCE))
		if direct_combat.describe() == offer.combat_derivation.describe():
			combat_delegated += 1
		var direct_utility: PassiveCardSelectionResult = PassiveCardSelection.select(
			cards, PlayerStatDefinition.Category.UTILITY,
			offer.seed_for(RiftOffer.Lane.UTILITY))
		if direct_utility.describe() == offer.utility_derivation.describe():
			utility_delegated += 1
	_expect(combat_wrong == 0,
		"%d combat lanes offered a card outside Combat and Defence" % combat_wrong)
	_expect(utility_wrong == 0,
		"%d utility lanes offered a card outside Utility" % utility_wrong)
	_expect(combat_delegated == SEED_SAMPLES,
		"%d of %d combat lanes reproduce Foundation C3's own answer" % [
			combat_delegated, SEED_SAMPLES,
		])
	_expect(utility_delegated == SEED_SAMPLES,
		"%d of %d utility lanes reproduce Foundation C3's own answer" % [
			utility_delegated, SEED_SAMPLES,
		])
	for card_id: String in COMBAT_POOL:
		_expect(combat_reached.has(card_id),
			"%s was never offered in the combat lane over %d seeds" % [card_id, SEED_SAMPLES])
	for card_id: String in UTILITY_POOL:
		_expect(utility_reached.has(card_id),
			"%s was never offered in the utility lane over %d seeds" % [card_id, SEED_SAMPLES])

	## THE LANE-TO-CATEGORY MAPPING IS WRITTEN IN ONE PLACE AND IS THE ONE THE
	## LANES USED.
	_expect(RiftOffer.category_for_lane(RiftOffer.Lane.COMBAT_DEFENCE)
			== PlayerStatDefinition.Category.COMBAT_DEFENCE,
		"the combat lane maps to category %d" % RiftOffer.category_for_lane(
			RiftOffer.Lane.COMBAT_DEFENCE))
	_expect(RiftOffer.category_for_lane(RiftOffer.Lane.UTILITY)
			== PlayerStatDefinition.Category.UTILITY,
		"the utility lane maps to category %d" % RiftOffer.category_for_lane(
			RiftOffer.Lane.UTILITY))
	_expect(RiftOffer.category_for_lane(RiftOffer.Lane.SUPPORT) == RiftOffer.NO_CATEGORY,
		"the support lane maps to the stat category %d" % RiftOffer.category_for_lane(
			RiftOffer.Lane.SUPPORT))
	_expect(RiftOffer.category_for_lane(99) == RiftOffer.NO_CATEGORY,
		"an undeclared lane maps to the stat category %d" % RiftOffer.category_for_lane(99))
	_expect(not PlayerStatDefinition.Category.values().has(RiftOffer.NO_CATEGORY),
		"the no-category sentinel %d is a declared category" % RiftOffer.NO_CATEGORY)

	print("  Combat and Defence [%s] / Utility [%s]; %d shared, %d uncovered; "
		% [", ".join(combat_seen), ", ".join(utility_seen), shared,
			cards.size() - combat_seen.size() - utility_seen.size()]
		+ "%d of %d cards reached over %d offers; %d wrong-category lanes" % [
			combat_reached.size() + utility_reached.size(), cards.size(),
			SEED_SAMPLES, combat_wrong + utility_wrong,
		])
	_done("each_passive_lane_belongs_only_to_its_own_category")


# --- 4. Determinism ---------------------------------------------------------------

func _check_identical_inputs_and_a_root_seed_reproduce_every_lane() -> void:
	print("")
	print("--- 4. Identical inputs and one root seed reproduce all three lanes")

	var first: String = _full(_shipped_offer(INDEPENDENCE_SEED))
	var drifted: int = 0
	for _call: int in REPEAT_CALLS:
		if _full(_shipped_offer(INDEPENDENCE_SEED)) != first:
			drifted += 1
	_expect(drifted == 0,
		"%d of %d identical compositions disagreed" % [drifted, REPEAT_CALLS])

	## AND ACROSS EVERY SEED, on the whole derivation rather than on the answer.
	var seed_drift: int = 0
	for seed_value: int in SEED_SAMPLES:
		if _full(_shipped_offer(seed_value)) != _full(_shipped_offer(seed_value)):
			seed_drift += 1
	_expect(seed_drift == 0,
		"%d of %d seeds produced two different offers" % [seed_drift, SEED_SAMPLES])

	## TWO DIFFERENT ROOT SEEDS MUST BE ABLE TO DISAGREE, otherwise the
	## reproduction above is a proof about a constant.
	var distinct: Dictionary = {}
	for seed_value: int in SEED_SAMPLES:
		distinct[_full(_shipped_offer(seed_value))] = true
	_expect(distinct.size() > 1,
		"%d seeds produced %d distinct offers" % [SEED_SAMPLES, distinct.size()])

	## THE COMPOSER MUTATES NOTHING IT WAS HANDED. An input a composer edits is an
	## input the next call cannot reproduce from.
	var profiles: Array[SkillTagProfile] = SkillSupportCatalogue.skill_profiles()
	var definitions: Array[SupportDefinition] = SkillSupportCatalogue.support_definitions()
	var cards: Array[PassiveCardDefinition] = PassiveCardCatalogue.records()
	var held: AcquiredSupports = AcquiredSupports.new()
	var before: String = "%d/%d/%d/%d" % [
		profiles.size(), definitions.size(), cards.size(), held.size(),
	]
	var before_ids: String = "%s|%s|%s" % [
		_ids_of_profiles(profiles), _ids_of_definitions(definitions), _ids_of_cards(cards),
	]
	RiftOfferComposition.compose(profiles, definitions, held, cards, INDEPENDENCE_SEED)
	_expect(before == "%d/%d/%d/%d" % [
			profiles.size(), definitions.size(), cards.size(), held.size()],
		"composing changed the size of an input it was handed")
	_expect(before_ids == "%s|%s|%s" % [
			_ids_of_profiles(profiles), _ids_of_definitions(definitions), _ids_of_cards(cards)],
		"composing changed the contents of an input it was handed")
	_expect(held.is_empty(), "composing recorded an acquisition: %s" % held.describe())

	print("  %d of %d identical compositions agree on the whole derivation; "
		% [REPEAT_CALLS - drifted, REPEAT_CALLS]
		+ "%d seeds produced %d distinct offers; 0 inputs mutated" % [
			SEED_SAMPLES, distinct.size(),
		])
	_done("identical_inputs_and_a_root_seed_reproduce_every_lane")


# --- 5. Input order ---------------------------------------------------------------

func _check_input_order_cannot_change_an_offer() -> void:
	print("")
	print("--- 5. Reversing every input array changes nothing")

	var profiles: Array[SkillTagProfile] = _two_skills()
	var definitions: Array[SupportDefinition] = _three_supports()
	var cards: Array[PassiveCardDefinition] = PassiveCardCatalogue.records()

	var reversed_profiles: Array[SkillTagProfile] = []
	for index: int in range(profiles.size() - 1, -1, -1):
		reversed_profiles.append(profiles[index])
	var reversed_definitions: Array[SupportDefinition] = []
	for index: int in range(definitions.size() - 1, -1, -1):
		reversed_definitions.append(definitions[index])
	var reversed_cards: Array[PassiveCardDefinition] = []
	for index: int in range(cards.size() - 1, -1, -1):
		reversed_cards.append(cards[index])

	## THE REVERSALS ARE PROVED TO BE REVERSALS AND TO ACTUALLY DIFFER. A
	## permutation test over a set that was already in that order proves nothing.
	_expect(_ids_of_profiles(reversed_profiles) != _ids_of_profiles(profiles),
		"the reversed Skill order is the same order")
	_expect(_ids_of_definitions(reversed_definitions) != _ids_of_definitions(definitions),
		"the reversed support order is the same order")
	_expect(_ids_of_cards(reversed_cards) != _ids_of_cards(cards),
		"the reversed card order is the same order")
	_expect(_sorted_text(_ids_of_profiles(reversed_profiles))
			== _sorted_text(_ids_of_profiles(profiles)),
		"the reversed Skills are not the same set")
	_expect(_sorted_text(_ids_of_definitions(reversed_definitions))
			== _sorted_text(_ids_of_definitions(definitions)),
		"the reversed supports are not the same set")
	_expect(_sorted_text(_ids_of_cards(reversed_cards)) == _sorted_text(_ids_of_cards(cards)),
		"the reversed cards are not the same set")

	var drift: int = 0
	for seed_value: int in SEED_SAMPLES:
		var canonical: String = _full(RiftOfferComposition.compose(
			profiles, definitions, null, cards, seed_value))
		var reversed_offer: String = _full(RiftOfferComposition.compose(
			reversed_profiles, reversed_definitions, null, reversed_cards, seed_value))
		if canonical != reversed_offer:
			drift += 1
	_expect(drift == 0,
		"%d of %d offers changed when every input array was reversed" % [drift, SEED_SAMPLES])

	## AND THE SHIPPED RECORDS TOO, reversed the same way, so the property is not
	## only true of fabricated data.
	var shipped_definitions: Array[SupportDefinition] = \
		SkillSupportCatalogue.support_definitions()
	var reversed_shipped: Array[SupportDefinition] = []
	for index: int in range(shipped_definitions.size() - 1, -1, -1):
		reversed_shipped.append(shipped_definitions[index])
	var shipped_drift: int = 0
	for seed_value: int in SEED_SAMPLES:
		if _full(RiftOfferComposition.compose(SkillSupportCatalogue.skill_profiles(),
				reversed_shipped, null, reversed_cards, seed_value)) != _full(
				_shipped_offer(seed_value)):
			shipped_drift += 1
	_expect(shipped_drift == 0,
		"%d of %d shipped offers changed when the inputs were reversed" % [
			shipped_drift, SEED_SAMPLES,
		])

	print("  %d offers over reversed Skills, supports and records are bit-identical, "
		% SEED_SAMPLES
		+ "fabricated (%d drift) and shipped (%d drift)" % [drift, shipped_drift])
	_done("input_order_cannot_change_an_offer")


# --- 6. Presentation names ---------------------------------------------------------

func _check_presentation_names_cannot_change_an_offer() -> void:
	print("")
	print("--- 6. Renaming every record changes nothing, and neither file can see a name")

	var profiles: Array[SkillTagProfile] = SkillSupportCatalogue.skill_profiles()
	var definitions: Array[SupportDefinition] = SkillSupportCatalogue.support_definitions()
	var cards: Array[PassiveCardDefinition] = PassiveCardCatalogue.records()

	var renamed_profiles: Array[SkillTagProfile] = []
	for profile: SkillTagProfile in profiles:
		renamed_profiles.append(SkillTagProfile.of(
			profile.skill_id, "ZZ renamed %s" % profile.skill_id, profile.tags))
	var renamed_definitions: Array[SupportDefinition] = []
	for definition: SupportDefinition in definitions:
		renamed_definitions.append(SupportDefinition.of(SupportEligibility.of(
			definition.support_id(), "ZZ renamed %s" % definition.support_id(),
			definition.eligibility.required_all, definition.eligibility.required_any,
			definition.eligibility.excluded), definition.base_weight, definition.tag_bonuses,
			definition.maximum_rank))
	var renamed_cards: Array[PassiveCardDefinition] = []
	for record: PassiveCardDefinition in cards:
		renamed_cards.append(PassiveCardDefinition.of(
			record.card_id, "ZZ renamed %s" % record.card_id, record.stat_id,
			record.magnitude, record.base_weight, record.repeatable))

	## THE RENAME IS PROVED TO HAVE HAPPENED AND THE IDS PROVED UNCHANGED, so a
	## no-op cannot pass as a proof that names do not matter.
	var renamed_count: int = 0
	for index: int in profiles.size():
		if renamed_profiles[index].display_name != profiles[index].display_name:
			renamed_count += 1
	for index: int in definitions.size():
		if renamed_definitions[index].display_name() != definitions[index].display_name():
			renamed_count += 1
	for index: int in cards.size():
		if renamed_cards[index].display_name != cards[index].display_name:
			renamed_count += 1
	_expect(renamed_count == profiles.size() + definitions.size() + cards.size(),
		"only %d of %d records were actually renamed" % [
			renamed_count, profiles.size() + definitions.size() + cards.size(),
		])
	_expect(_ids_of_profiles(renamed_profiles) == _ids_of_profiles(profiles)
			and _ids_of_definitions(renamed_definitions) == _ids_of_definitions(definitions)
			and _ids_of_cards(renamed_cards) == _ids_of_cards(cards),
		"the rename changed a stable id, so it proves nothing about names")

	var drift: int = 0
	for seed_value: int in SEED_SAMPLES:
		if _full(RiftOfferComposition.compose(renamed_profiles, renamed_definitions,
				null, renamed_cards, seed_value)) != _full(_shipped_offer(seed_value)):
			drift += 1
	_expect(drift == 0,
		"%d of %d offers changed when every record was renamed" % [drift, SEED_SAMPLES])

	## THE SCAN, BECAUSE THE BEHAVIOURAL HALF CANNOT SEE A NAME READ FOR A PURPOSE
	## THAT HAPPENS NOT TO MATTER TODAY.
	var named: int = 0
	for path: String in D1_FILES:
		if FileAccess.get_file_as_string(path).contains(NAME_FIELD_TOKEN):
			named += 1
			_expect(false, "%s reads a presentation name" % path.get_file())
	_expect(named == 0, "%d of %d D1 files read a presentation name" % [named, D1_FILES.size()])
	## AND THAT SCAN IS PROVED CAPABLE OF FAILING, by finding the token in a file
	## that legitimately declares it.
	_expect(FileAccess.get_file_as_string(
			"res://scripts/stats/passive_card_definition.gd").contains(NAME_FIELD_TOKEN),
		"the presentation-name scan cannot find the field where it is declared")

	print("  %d offers over renamed Skills, supports and cards are bit-identical; "
		% SEED_SAMPLES
		+ "neither D1 file names %s" % NAME_FIELD_TOKEN)
	_done("presentation_names_cannot_change_an_offer")


# --- 7. The pinned corpus -----------------------------------------------------------

func _check_the_documented_root_seeds_reproduce_a_fixed_corpus() -> void:
	print("")
	print("--- 7. The documented root seeds reproduce a fixed corpus exactly")

	var supports_reached: Dictionary = {}
	var cards_reached: Dictionary = {}
	var rows: int = 0
	for row: Array in SEED_CORPUS:
		var root: int = int(row[0])
		var offer: RiftOffer = _shipped_offer(root)
		_expect(offer.ok, "corpus seed %d was refused: %s" % [root, offer.failure_reason])
		if not offer.ok:
			continue
		rows += 1
		_expect(offer.seed_for(RiftOffer.Lane.SUPPORT) == int(row[1]),
			"seed %d: the support lane seed is %d, not %d" % [
				root, offer.seed_for(RiftOffer.Lane.SUPPORT), int(row[1]),
			])
		_expect(offer.seed_for(RiftOffer.Lane.COMBAT_DEFENCE) == int(row[2]),
			"seed %d: the combat lane seed is %d, not %d" % [
				root, offer.seed_for(RiftOffer.Lane.COMBAT_DEFENCE), int(row[2]),
			])
		_expect(offer.seed_for(RiftOffer.Lane.UTILITY) == int(row[3]),
			"seed %d: the utility lane seed is %d, not %d" % [
				root, offer.seed_for(RiftOffer.Lane.UTILITY), int(row[3]),
			])
		_expect(String(offer.skill_id) == String(row[4]),
			"seed %d: the Skill is %s, not %s" % [root, offer.skill_id, String(row[4])])
		_expect(String(offer.support_id) == String(row[5]),
			"seed %d: the support is %s, not %s" % [root, offer.support_id, String(row[5])])
		_expect(String(offer.combat_card_id) == String(row[6]),
			"seed %d: the combat card is %s, not %s" % [
				root, offer.combat_card_id, String(row[6]),
			])
		_expect(String(offer.utility_card_id) == String(row[7]),
			"seed %d: the utility card is %s, not %s" % [
				root, offer.utility_card_id, String(row[7]),
			])
		supports_reached[String(offer.support_id)] = true
		cards_reached[String(offer.combat_card_id)] = true
		cards_reached[String(offer.utility_card_id)] = true
	_expect(rows == SEED_CORPUS.size(),
		"%d of %d corpus rows were compared" % [rows, SEED_CORPUS.size()])
	_expect(supports_reached.size() == SHIPPED_SUPPORTS.size(),
		"the corpus reaches %d of %d supports" % [
			supports_reached.size(), SHIPPED_SUPPORTS.size(),
		])
	_expect(cards_reached.size() == COMBAT_POOL.size() + UTILITY_POOL.size(),
		"the corpus reaches %d of %d cards" % [
			cards_reached.size(), COMBAT_POOL.size() + UTILITY_POOL.size(),
		])

	## THE 32-BIT MASK MAKES TWO SEEDS ONE QUESTION, and the corpus contains both
	## halves of exactly that pair, so the property is measured rather than
	## inferred from the mask being written down.
	_expect(_derived(_shipped_offer(-1)) == _derived(_shipped_offer(9223372036854775807)),
		"-1 and 9223372036854775807 compose differently despite the 32-bit mask")
	## AND THE TWO ARE STILL DISTINGUISHABLE, because each echoes the root seed it
	## was actually asked with. Two seeds being one QUESTION is not the same as an
	## offer forgetting which of them was asked, and the first check above would
	## pass either way — which is why this one is beside it.
	_expect(_full(_shipped_offer(-1)) != _full(_shipped_offer(9223372036854775807)),
		"the two seeds are indistinguishable even in the root seed each offer echoes")
	_expect(_derived(_shipped_offer(0)) != _derived(_shipped_offer(1)),
		"two adjacent seeds compose identically")

	print("  %d corpus rows exact over %d lane seeds; %d of %d supports and %d of %d cards "
		% [rows, rows * 3, supports_reached.size(), SHIPPED_SUPPORTS.size(),
			cards_reached.size(), COMBAT_POOL.size() + UTILITY_POOL.size()]
		+ "reached; -1 and 9223372036854775807 are one question")
	_done("the_documented_root_seeds_reproduce_a_fixed_corpus")


# --- 8. The lane domains ------------------------------------------------------------

func _check_the_three_lane_domains_are_fixed_distinct_and_never_collide() -> void:
	print("")
	print("--- 8. The three lane domains are fixed, distinct and never collide")

	## PINNED, BECAUSE THEY ARE PART OF WHAT A ROOT SEED MEANS. Changing one would
	## silently rewrite every offer ever reproduced from a seed.
	_expect(RiftOfferComposition.SUPPORT_LANE_DOMAIN == EXPECTED_SUPPORT_DOMAIN,
		"the support lane domain is %d, not %d" % [
			RiftOfferComposition.SUPPORT_LANE_DOMAIN, EXPECTED_SUPPORT_DOMAIN,
		])
	_expect(RiftOfferComposition.COMBAT_DEFENCE_LANE_DOMAIN == EXPECTED_COMBAT_DOMAIN,
		"the combat lane domain is %d, not %d" % [
			RiftOfferComposition.COMBAT_DEFENCE_LANE_DOMAIN, EXPECTED_COMBAT_DOMAIN,
		])
	_expect(RiftOfferComposition.UTILITY_LANE_DOMAIN == EXPECTED_UTILITY_DOMAIN,
		"the utility lane domain is %d, not %d" % [
			RiftOfferComposition.UTILITY_LANE_DOMAIN, EXPECTED_UTILITY_DOMAIN,
		])
	var domains: Array[int] = [
		EXPECTED_SUPPORT_DOMAIN, EXPECTED_COMBAT_DOMAIN, EXPECTED_UTILITY_DOMAIN,
	]
	for index: int in domains.size():
		for other: int in range(index + 1, domains.size()):
			_expect(domains[index] != domains[other],
				"two lane domains share the value %d" % domains[index])
		_expect(not NESTED_STREAM_SALTS.has(domains[index]),
			"the lane domain %d is also a nested stream salt" % domains[index])

	## THE MAPPING IS ONE FUNCTION AND IT ANSWERS FOR EVERY LANE, including one it
	## does not recognise — a guard nothing can reach is not a guard.
	_expect(RiftOfferComposition.lane_domain_for(RiftOffer.Lane.SUPPORT)
			== EXPECTED_SUPPORT_DOMAIN, "the support lane resolves the wrong domain")
	_expect(RiftOfferComposition.lane_domain_for(RiftOffer.Lane.COMBAT_DEFENCE)
			== EXPECTED_COMBAT_DOMAIN, "the combat lane resolves the wrong domain")
	_expect(RiftOfferComposition.lane_domain_for(RiftOffer.Lane.UTILITY)
			== EXPECTED_UTILITY_DOMAIN, "the utility lane resolves the wrong domain")
	_expect(RiftOfferComposition.lane_domain_for(99)
			== RiftOfferComposition.UNRECOGNISED_LANE,
		"an undeclared lane resolves the domain %d" % RiftOfferComposition.lane_domain_for(99))
	_expect(RiftOfferComposition.lane_seed_for(0, 99)
			== RiftOfferComposition.UNRECOGNISED_LANE,
		"an undeclared lane derives the seed %d" % RiftOfferComposition.lane_seed_for(0, 99))
	_expect(RiftOfferComposition.UNRECOGNISED_LANE < 0,
		"the unrecognised-lane answer %d could be mistaken for a real seed"
			% RiftOfferComposition.UNRECOGNISED_LANE)

	## NO TWO LANES EVER SHARE A SEED, AND NO LANE SEED IS EVER NEGATIVE. The
	## finalizer is a bijection on the 32-bit range, so this holds for every root;
	## it is measured over a corpus anyway, because a proof in a comment and a
	## measurement are different kinds of evidence.
	var collisions: int = 0
	var negatives: int = 0
	var distinct_support: Dictionary = {}
	for offset: int in ROOT_SAMPLES:
		var root: int = offset - 512
		var support_seed: int = RiftOfferComposition.lane_seed_for(root, RiftOffer.Lane.SUPPORT)
		var combat_seed: int = RiftOfferComposition.lane_seed_for(
			root, RiftOffer.Lane.COMBAT_DEFENCE)
		var utility_seed: int = RiftOfferComposition.lane_seed_for(root, RiftOffer.Lane.UTILITY)
		if support_seed == combat_seed or support_seed == utility_seed \
				or combat_seed == utility_seed:
			collisions += 1
		if support_seed < 0 or combat_seed < 0 or utility_seed < 0:
			negatives += 1
		if support_seed > 0xFFFFFFFF or combat_seed > 0xFFFFFFFF or utility_seed > 0xFFFFFFFF:
			_expect(false, "a lane seed exceeded the 32-bit range at root %d" % root)
		distinct_support[support_seed] = true
	_expect(collisions == 0,
		"%d of %d roots produced two identical lane seeds" % [collisions, ROOT_SAMPLES])
	_expect(negatives == 0,
		"%d of %d roots produced a negative lane seed" % [negatives, ROOT_SAMPLES])
	## The derivation is injective over the roots it was asked about, so two roots
	## cannot be one question by accident.
	_expect(distinct_support.size() == ROOT_SAMPLES,
		"%d roots produced only %d distinct support lane seeds" % [
			ROOT_SAMPLES, distinct_support.size(),
		])

	## THE FOUR COPIES OF THE FINALIZER STILL AGREE. The duplication is recorded
	## debt; this is the measurement that keeps it from becoming a divergence
	## nobody notices.
	var twins_compared: int = 0
	for path: String in MIXER_TWINS:
		var script: GDScript = load(path) as GDScript
		if script == null:
			_expect(false, "%s could not be loaded to compare its finalizer" % path)
			continue
		var disagreements: int = 0
		for value: int in MIXER_SAMPLES:
			if int(script.call("_mix", value)) != RiftOfferComposition._mix(value):
				disagreements += 1
		_expect(disagreements == 0,
			"%s disagrees with the D1 finalizer on %d of %d values" % [
				path.get_file(), disagreements, MIXER_SAMPLES,
			])
		twins_compared += 1
	_expect(twins_compared == MIXER_TWINS.size(),
		"%d of %d finalizer copies were compared" % [twins_compared, MIXER_TWINS.size()])

	print("  3 lane domains fixed and pairwise distinct, none a nested salt; "
		+ "%d collisions and %d negatives over %d roots; " % [
			collisions, negatives, ROOT_SAMPLES]
		+ "%d finalizer copies agree over %d values" % [
			twins_compared + 1, MIXER_SAMPLES,
		])
	_done("the_three_lane_domains_are_fixed_distinct_and_never_collide")


# --- 9. The support lane's inputs move only the support lane -------------------------

func _check_the_support_pool_and_its_weights_move_only_the_support_lane() -> void:
	print("")
	print("--- 9. A support weight and a wider support pool move only the support lane")

	var profiles: Array[SkillTagProfile] = SkillSupportCatalogue.skill_profiles()
	var definitions: Array[SupportDefinition] = SkillSupportCatalogue.support_definitions()
	var cards: Array[PassiveCardDefinition] = PassiveCardCatalogue.records()

	var heavier: Array[SupportDefinition] = []
	for definition: SupportDefinition in definitions:
		heavier.append(SupportDefinition.of(definition.eligibility,
			MUTATED_WEIGHT if definition.support_id() == StringName(SHIPPED_SUPPORTS[0])
				else definition.base_weight,
			definition.tag_bonuses, definition.maximum_rank))
	var wider: Array[SupportDefinition] = definitions.duplicate()
	wider.append(_definition(&"t9_extra", [SkillTags.MELEE] as Array[StringName], 100))

	## THE MUTATIONS ARE PROVED TO BE MUTATIONS.
	_expect(heavier.size() == definitions.size(),
		"the reweighted pool holds %d supports, not %d" % [
			heavier.size(), definitions.size(),
		])
	_expect(wider.size() == definitions.size() + 1,
		"the widened pool holds %d supports, not %d" % [
			wider.size(), definitions.size() + 1,
		])
	var reweighted: int = 0
	for index: int in definitions.size():
		if heavier[index].base_weight != definitions[index].base_weight:
			reweighted += 1
	_expect(reweighted == 1, "%d supports were reweighted, not 1" % reweighted)

	var heavier_moves: int = _lane_movement(
		profiles, heavier, cards, profiles, definitions, cards, RiftOffer.Lane.SUPPORT)
	var wider_moves: int = _lane_movement(
		profiles, wider, cards, profiles, definitions, cards, RiftOffer.Lane.SUPPORT)
	var heavier_bleed: int = _lane_bleed(
		profiles, heavier, cards, profiles, definitions, cards, RiftOffer.Lane.SUPPORT)
	var wider_bleed: int = _lane_bleed(
		profiles, wider, cards, profiles, definitions, cards, RiftOffer.Lane.SUPPORT)

	_expect(heavier_moves == EXPECTED_SUPPORT_WEIGHT_MOVES,
		"a support weight moved the support lane at %d of %d seeds, not %d" % [
			heavier_moves, SEED_SAMPLES, EXPECTED_SUPPORT_WEIGHT_MOVES,
		])
	_expect(wider_moves == EXPECTED_WIDER_POOL_MOVES,
		"a wider pool moved the support lane at %d of %d seeds, not %d" % [
			wider_moves, SEED_SAMPLES, EXPECTED_WIDER_POOL_MOVES,
		])
	_expect(heavier_bleed == 0,
		"a support weight moved a passive lane at %d of %d seeds" % [
			heavier_bleed, SEED_SAMPLES,
		])
	_expect(wider_bleed == 0,
		"a wider support pool moved a passive lane at %d of %d seeds" % [
			wider_bleed, SEED_SAMPLES,
		])

	## AND AT THE NAMED SEED, spelled out so a reader can check one case by hand.
	var base: RiftOffer = _shipped_offer(INDEPENDENCE_SEED)
	var widened: RiftOffer = RiftOfferComposition.compose(
		profiles, wider, null, cards, INDEPENDENCE_SEED)
	_expect(widened.ok and base.ok, "the named independence seed refused")
	_expect(widened.support_id != base.support_id,
		"the widened pool offered the same support %s at the named seed" % base.support_id)
	_expect(widened.combat_card_id == base.combat_card_id
			and widened.utility_card_id == base.utility_card_id,
		"the widened pool moved a passive card at the named seed")
	for lane: int in RiftOffer.LANE_ORDER:
		_expect(widened.seed_for(lane) == base.seed_for(lane),
			"the widened pool moved the %s lane seed" % RiftOffer.lane_label(lane))

	print("  a support weight moved the support lane at %d of %d seeds and a wider pool at %d; "
		% [heavier_moves, SEED_SAMPLES, wider_moves]
		+ "%d passive lanes moved" % (heavier_bleed + wider_bleed))
	_done("the_support_pool_and_its_weights_move_only_the_support_lane")


# --- 10. A combat weight moves only the combat lane ------------------------------------

func _check_a_combat_passive_weight_moves_only_the_combat_lane() -> void:
	print("")
	print("--- 10. A Combat and Defence weight moves only the Combat and Defence lane")

	var profiles: Array[SkillTagProfile] = SkillSupportCatalogue.skill_profiles()
	var definitions: Array[SupportDefinition] = SkillSupportCatalogue.support_definitions()
	var cards: Array[PassiveCardDefinition] = PassiveCardCatalogue.records()
	var mutated: Array[PassiveCardDefinition] = _reweighted_cards(
		cards, StringName(COMBAT_POOL[0]), MUTATED_WEIGHT)

	_expect(_reweighted_count(cards, mutated) == 1,
		"%d cards were reweighted, not 1" % _reweighted_count(cards, mutated))
	_expect(_category_of(mutated, StringName(COMBAT_POOL[0]))
			== PlayerStatDefinition.Category.COMBAT_DEFENCE,
		"the reweighted card is not a Combat and Defence card")

	var moves: int = _lane_movement(profiles, definitions, mutated,
		profiles, definitions, cards, RiftOffer.Lane.COMBAT_DEFENCE)
	var bleed: int = _lane_bleed(profiles, definitions, mutated,
		profiles, definitions, cards, RiftOffer.Lane.COMBAT_DEFENCE)
	_expect(moves == EXPECTED_COMBAT_WEIGHT_MOVES,
		"a combat weight moved the combat lane at %d of %d seeds, not %d" % [
			moves, SEED_SAMPLES, EXPECTED_COMBAT_WEIGHT_MOVES,
		])
	_expect(bleed == 0,
		"a combat weight moved the support or utility lane at %d of %d seeds" % [
			bleed, SEED_SAMPLES,
		])

	var base: RiftOffer = _shipped_offer(INDEPENDENCE_SEED)
	var changed: RiftOffer = RiftOfferComposition.compose(
		profiles, definitions, null, mutated, INDEPENDENCE_SEED)
	_expect(changed.ok and base.ok, "the named independence seed refused")
	_expect(changed.combat_card_id != base.combat_card_id,
		"the combat lane offered the same card %s at the named seed" % base.combat_card_id)
	_expect(changed.support_id == base.support_id and changed.skill_id == base.skill_id,
		"a combat weight moved the support lane at the named seed")
	_expect(changed.utility_card_id == base.utility_card_id,
		"a combat weight moved the utility lane at the named seed")
	_expect(changed.utility_derivation.describe() == base.utility_derivation.describe(),
		"a combat weight moved the utility lane's ticket or its candidates")
	for lane: int in RiftOffer.LANE_ORDER:
		_expect(changed.seed_for(lane) == base.seed_for(lane),
			"a combat weight moved the %s lane seed" % RiftOffer.lane_label(lane))

	print("  a combat weight moved the combat lane at %d of %d seeds; "
		% [moves, SEED_SAMPLES]
		+ "the support and utility lanes moved at %d" % bleed)
	_done("a_combat_passive_weight_moves_only_the_combat_lane")


# --- 11. A utility weight moves only the utility lane -----------------------------------

func _check_a_utility_passive_weight_moves_only_the_utility_lane() -> void:
	print("")
	print("--- 11. A Utility weight moves only the Utility lane")

	var profiles: Array[SkillTagProfile] = SkillSupportCatalogue.skill_profiles()
	var definitions: Array[SupportDefinition] = SkillSupportCatalogue.support_definitions()
	var cards: Array[PassiveCardDefinition] = PassiveCardCatalogue.records()
	var mutated: Array[PassiveCardDefinition] = _reweighted_cards(
		cards, StringName(UTILITY_POOL[0]), MUTATED_WEIGHT)

	_expect(_reweighted_count(cards, mutated) == 1,
		"%d cards were reweighted, not 1" % _reweighted_count(cards, mutated))
	_expect(_category_of(mutated, StringName(UTILITY_POOL[0]))
			== PlayerStatDefinition.Category.UTILITY,
		"the reweighted card is not a Utility card")

	var moves: int = _lane_movement(profiles, definitions, mutated,
		profiles, definitions, cards, RiftOffer.Lane.UTILITY)
	var bleed: int = _lane_bleed(profiles, definitions, mutated,
		profiles, definitions, cards, RiftOffer.Lane.UTILITY)
	_expect(moves == EXPECTED_UTILITY_WEIGHT_MOVES,
		"a utility weight moved the utility lane at %d of %d seeds, not %d" % [
			moves, SEED_SAMPLES, EXPECTED_UTILITY_WEIGHT_MOVES,
		])
	_expect(bleed == 0,
		"a utility weight moved the support or combat lane at %d of %d seeds" % [
			bleed, SEED_SAMPLES,
		])

	var base: RiftOffer = _shipped_offer(INDEPENDENCE_SEED)
	var changed: RiftOffer = RiftOfferComposition.compose(
		profiles, definitions, null, mutated, INDEPENDENCE_SEED)
	_expect(changed.ok and base.ok, "the named independence seed refused")
	_expect(changed.utility_card_id != base.utility_card_id,
		"the utility lane offered the same card %s at the named seed" % base.utility_card_id)
	_expect(changed.support_id == base.support_id and changed.skill_id == base.skill_id,
		"a utility weight moved the support lane at the named seed")
	_expect(changed.combat_card_id == base.combat_card_id,
		"a utility weight moved the combat lane at the named seed")
	_expect(changed.combat_derivation.describe() == base.combat_derivation.describe(),
		"a utility weight moved the combat lane's ticket or its candidates")
	for lane: int in RiftOffer.LANE_ORDER:
		_expect(changed.seed_for(lane) == base.seed_for(lane),
			"a utility weight moved the %s lane seed" % RiftOffer.lane_label(lane))

	print("  a utility weight moved the utility lane at %d of %d seeds; "
		% [moves, SEED_SAMPLES]
		+ "the support and combat lanes moved at %d" % bleed)
	_done("a_utility_passive_weight_moves_only_the_utility_lane")


# --- 12. Fail closed, by lane, always -----------------------------------------------------

func _check_every_refusal_names_its_lane_and_exposes_no_partial_offer() -> void:
	print("")
	print("--- 12. Every refusal names its lane and exposes no partial offer")

	var profiles: Array[SkillTagProfile] = SkillSupportCatalogue.skill_profiles()
	var definitions: Array[SupportDefinition] = SkillSupportCatalogue.support_definitions()
	var cards: Array[PassiveCardDefinition] = PassiveCardCatalogue.records()

	# --- The support lane refuses -------------------------------------------------
	var no_profiles: Array[SkillTagProfile] = []
	_expect_refusal(no_profiles, definitions, null, cards, RiftOffer.Lane.SUPPORT,
		"no equipped Skill profiles", "an empty equipped set")

	var null_profile: Array[SkillTagProfile] = [null]
	_expect_refusal(null_profile, definitions, null, cards, RiftOffer.Lane.SUPPORT,
		"is null", "a null Skill profile")

	var duplicate_skill: Array[SkillTagProfile] = [profiles[0], profiles[0]]
	_expect_refusal(duplicate_skill, definitions, null, cards, RiftOffer.Lane.SUPPORT,
		"duplicate Skill id", "the same Skill supplied twice")

	var untagged: Array[SkillTagProfile] = [SkillTagProfile.of(
		&"s_untagged", "Test Untagged", [] as Array[StringName])]
	_expect_refusal(untagged, definitions, null, cards, RiftOffer.Lane.SUPPORT,
		"at least one tag", "a Skill profile with no tag")

	var no_definitions: Array[SupportDefinition] = []
	_expect_refusal(profiles, no_definitions, null, cards, RiftOffer.Lane.SUPPORT,
		"no support definitions", "an empty support catalogue")

	var null_definition: Array[SupportDefinition] = [null]
	_expect_refusal(profiles, null_definition, null, cards, RiftOffer.Lane.SUPPORT,
		"is null", "a null support definition")

	var duplicate_support: Array[SupportDefinition] = definitions.duplicate()
	duplicate_support.append(definitions[0])
	_expect_refusal(profiles, duplicate_support, null, cards, RiftOffer.Lane.SUPPORT,
		"duplicate support id", "the same support supplied twice")

	var weightless: Array[SupportDefinition] = [
		SupportDefinition.of(definitions[0].eligibility, 0, {}, definitions[0].maximum_rank),
		definitions[1],
	]
	_expect_refusal(profiles, weightless, null, cards, RiftOffer.Lane.SUPPORT,
		"base weight 0", "a support with a zero base weight")

	var stranger: Array[SkillTagProfile] = [_profile(&"s_caster", [
		SkillTags.SPELL, SkillTags.HIT,
	] as Array[StringName])]
	_expect_refusal(stranger, definitions, null, cards, RiftOffer.Lane.SUPPORT,
		"no equipped Skill has an available eligible support",
		"a Skill no shipped support accepts")

	# --- Both passive lanes refuse, and the first in lane order is named ----------
	var no_cards: Array[PassiveCardDefinition] = []
	_expect_refusal(profiles, definitions, null, no_cards, RiftOffer.Lane.COMBAT_DEFENCE,
		"no passive card records", "an empty record set")

	var null_card: Array[PassiveCardDefinition] = [null]
	_expect_refusal(profiles, definitions, null, null_card, RiftOffer.Lane.COMBAT_DEFENCE,
		"is null", "a null passive card record")

	var duplicate_card: Array[PassiveCardDefinition] = cards.duplicate()
	duplicate_card.append(cards[0])
	_expect_refusal(profiles, definitions, null, duplicate_card,
		RiftOffer.Lane.COMBAT_DEFENCE, "duplicate card id",
		"the same passive card supplied twice")

	_expect_refusal(profiles, definitions, null,
		_reweighted_cards(cards, StringName(COMBAT_POOL[1]), 0),
		RiftOffer.Lane.COMBAT_DEFENCE, "base weight 0",
		"a Combat and Defence card with a zero weight")

	## THE ONE THAT MATTERS MOST HERE, AND IT IS A CONSEQUENCE OF FOUNDATION C3
	## RATHER THAN A CHOICE MADE IN D1: a fault in a UTILITY card refuses the
	## COMBAT lane too, because the accepted passive selector validates the WHOLE
	## record set before it filters by category. A record set is coherent or it is
	## not, and reporting the fault at the first lane in lane order is the
	## documented rule rather than an accident of evaluation.
	_expect_refusal(profiles, definitions, null,
		_reweighted_cards(cards, StringName(UTILITY_POOL[0]), 0),
		RiftOffer.Lane.COMBAT_DEFENCE, "base weight 0",
		"a Utility card with a zero weight")

	var illegal_id: Array[PassiveCardDefinition] = []
	for record: PassiveCardDefinition in cards:
		if record.card_id == StringName(UTILITY_POOL[1]):
			illegal_id.append(PassiveCardDefinition.of(
				StringName(String(record.card_id).to_upper()), record.display_name,
				record.stat_id, record.magnitude, record.base_weight, record.repeatable))
		else:
			illegal_id.append(record)
	_expect_refusal(profiles, definitions, null, illegal_id, RiftOffer.Lane.COMBAT_DEFENCE,
		"is not a legal card id", "a Utility card with an illegal id")

	var negative_magnitude: Array[PassiveCardDefinition] = []
	for record: PassiveCardDefinition in cards:
		if record.card_id == StringName(COMBAT_POOL[2]):
			negative_magnitude.append(PassiveCardDefinition.of(
				record.card_id, record.display_name, record.stat_id,
				-record.magnitude, record.base_weight, record.repeatable))
		else:
			negative_magnitude.append(record)
	_expect_refusal(profiles, definitions, null, negative_magnitude,
		RiftOffer.Lane.COMBAT_DEFENCE, "is not positive",
		"a Combat and Defence card with a negative magnitude")

	# --- A support lane with nothing to offer AT ALL, which is a real condition ---
	#     rather than a fabricated one
	#
	# EXHAUSTION IS NO LONGER THIS CASE, AND THE MOVE IS RECORDED HERE RATHER THAN
	# QUIETLY DROPPED (Foundation F3). Taking every eligible pair used to leave the
	# support lane with nothing to offer, and D1 refused. It now composes ONE
	# FURTHER RANK of a pair the run holds, because the accepted continuation
	# decision says so — asserted immediately below, so this suite can never drift
	# back to refusing without saying so.
	#
	# WHAT STILL REFUSES, and what this case moved to one for one, is a support
	# lane with no compatible pair ANYWHERE — held or not — where the accepted
	# continuation refuses in BOTH of its phases. It proves exactly the property
	# the exhaustion case used to: that a refused offer exposes nothing from the
	# two lanes that succeeded.
	var exhausted: AcquiredSupports = AcquiredSupports.new()
	for definition: SupportDefinition in definitions:
		exhausted.acquire(profiles[0].skill_id, definition.support_id())
	_expect(exhausted.size() == definitions.size(),
		"%d pairs were acquired, not %d" % [exhausted.size(), definitions.size()])
	var continued: RiftOffer = RiftOfferComposition.compose(
		profiles, definitions, exhausted, cards, INDEPENDENCE_SEED)
	_expect(continued.ok and continued.problem().is_empty(),
		"an exhausted support pool refused the offer: %s%s" % [
			continued.failure_reason, continued.problem(),
		])
	_expect(continued.support_progression_kind
			== SupportContinuationResult.Kind.RANK_INCREASE,
		"an exhausted support pool composed progression kind %d, not a rank increase"
			% continued.support_progression_kind)

	var accepting: int = 0
	for definition: SupportDefinition in definitions:
		if definition.allows(stranger[0]):
			accepting += 1
	_expect(accepting == 0,
		"%d shipped support(s) accept the barren fixture, so its refusal proves nothing"
			% accepting)
	_expect_refusal(stranger, definitions, null, cards, RiftOffer.Lane.SUPPORT,
		"with nothing acquired the same inputs still refuse",
		"a support lane with no compatible pair anywhere")

	## THE TWO PASSIVE LANES WOULD HAVE SUCCEEDED, PROVED BY RESOLVING THEM
	## DIRECTLY — so their absence from the refusal is a real suppression rather
	## than two lanes that failed anyway.
	var combat_would: PassiveCardSelectionResult = PassiveCardSelection.select(
		cards, PlayerStatDefinition.Category.COMBAT_DEFENCE,
		RiftOfferComposition.lane_seed_for(INDEPENDENCE_SEED, RiftOffer.Lane.COMBAT_DEFENCE))
	var utility_would: PassiveCardSelectionResult = PassiveCardSelection.select(
		cards, PlayerStatDefinition.Category.UTILITY,
		RiftOfferComposition.lane_seed_for(INDEPENDENCE_SEED, RiftOffer.Lane.UTILITY))
	_expect(combat_would.ok and utility_would.ok,
		"the two passive lanes did not succeed on their own, so the suppression is unproved")
	var suppressed: RiftOffer = RiftOfferComposition.compose(
		stranger, definitions, null, cards, INDEPENDENCE_SEED)
	_expect(not suppressed.ok, "the barren support lane did not refuse the offer")
	_expect(String(suppressed.combat_card_id).is_empty()
			and String(suppressed.utility_card_id).is_empty(),
		"a refused offer exposed %s and %s from lanes that succeeded" % [
			suppressed.combat_card_id, suppressed.utility_card_id,
		])
	_expect(not _full(suppressed).contains(String(combat_would.selected_card_id))
			and not _full(suppressed).contains(String(utility_would.selected_card_id)),
		"a refused offer's own description names a card from a lane that succeeded")
	_expect(suppressed.combat_derivation == null and suppressed.utility_derivation == null,
		"a refused offer carries a passive derivation")

	## AND THE SHAPE IS NEVER REPAIRED: a missing support does not become a second
	## passive, and a refusal carries no lane at all.
	_expect(suppressed.lane_order().is_empty(),
		"a refused offer carries %d lanes" % suppressed.lane_order().size())
	_expect(suppressed.identity_for(RiftOffer.Lane.COMBAT_DEFENCE).is_empty()
			and suppressed.identity_for(RiftOffer.Lane.UTILITY).is_empty(),
		"a refused offer answers a lane identity")

	## A REFUSAL NAMES ITS LANE MECHANICALLY AS WELL AS IN WORDS, and the two must
	## agree — a reader that branches on the member and a reader that reads the
	## sentence must be told the same thing.
	_expect(suppressed.refusing_lane == RiftOffer.Lane.SUPPORT,
		"the refusal names lane %d" % suppressed.refusing_lane)
	_expect(suppressed.failure_reason.contains(
			RiftOffer.lane_label(RiftOffer.Lane.SUPPORT)),
		"the refusal '%s' does not name its lane in words" % suppressed.failure_reason)
	_expect(not suppressed.failure_reason.contains("lanes refused"),
		"a single-lane refusal reports a multi-lane count: %s" % suppressed.failure_reason)
	_expect(suppressed.root_seed == INDEPENDENCE_SEED,
		"the refusal echoes root seed %d, not %d" % [
			suppressed.root_seed, INDEPENDENCE_SEED,
		])

	## WHEN TWO LANES REFUSE, THE FIRST IN LANE ORDER IS NAMED AND THE COUNT IS
	## STATED.
	var both_passives: RiftOffer = RiftOfferComposition.compose(
		profiles, definitions, null, no_cards, INDEPENDENCE_SEED)
	_expect(both_passives.refusing_lane == RiftOffer.Lane.COMBAT_DEFENCE,
		"a two-lane refusal names lane %d" % both_passives.refusing_lane)
	_expect(both_passives.failure_reason.contains("2 of 3 lanes refused"),
		"a two-lane refusal does not state its count: %s" % both_passives.failure_reason)

	## AND A DEFAULT-CONSTRUCTED OFFER IS REFUSED BY ITS OWN COHERENCE CHECK,
	## rather than reading as an empty but valid one.
	_expect(not RiftOffer.new().problem().is_empty(),
		"a default-constructed offer reports itself coherent")

	print("  %d refusals, each naming its lane in words and by member and exposing "
		% _refusals
		+ "0 of 4 identities; two lanes that succeeded expose nothing")
	_done("every_refusal_names_its_lane_and_exposes_no_partial_offer")


# --- 13. Generic, inert, unwired ------------------------------------------------------------

func _check_the_composer_is_generic_reads_nothing_ambient_and_is_unwired() -> void:
	print("")
	print("--- 13. The two scripts name nothing concrete, read nothing ambient, run nowhere")

	var scanned: int = 0
	var forbidden_total: int = 0
	var ambient_total: int = 0
	var ladder_total: int = 0
	for path: String in D1_FILES:
		if not FileAccess.file_exists(path):
			_expect(false, "%s is missing" % path)
			continue
		## RAW, comments included.
		var source: String = FileAccess.get_file_as_string(path)
		var named: PackedStringArray = PackedStringArray()
		for token: String in FORBIDDEN_TOKENS:
			if source.contains(token):
				named.append(token)
		forbidden_total += named.size()
		_expect(named.is_empty(), "%s names %s" % [path.get_file(), ", ".join(named)])
		var ambient: PackedStringArray = PackedStringArray()
		for token: String in AMBIENT_TOKENS:
			if source.contains(token):
				ambient.append(token)
		ambient_total += ambient.size()
		_expect(ambient.is_empty(),
			"%s reads ambient state: %s" % [path.get_file(), ", ".join(ambient)])
		var ladder: PackedStringArray = PackedStringArray()
		for token: String in LADDER_FIELD_TOKENS:
			if source.contains(token):
				ladder.append(token)
		ladder_total += ladder.size()
		_expect(ladder.is_empty(),
			"%s reads a weight or a ladder field: %s" % [path.get_file(), ", ".join(ladder)])
		scanned += 1
	_expect(scanned == D1_FILES.size(),
		"%d of %d D1 scripts were scanned" % [scanned, D1_FILES.size()])

	## THE SCANS ARE PROVED CAPABLE OF FAILING, by showing them finding their own
	## tokens in files that legitimately hold them.
	var own: String = FileAccess.get_file_as_string(
		"res://tests/rift_offer_composition_verification.gd")
	var found_here: int = 0
	for token: String in FORBIDDEN_TOKENS:
		if own.contains(token):
			found_here += 1
	_expect(found_here >= 10,
		"the forbidden-token scan found only %d of its own tokens and may be inert" % found_here)
	var ambient_here: int = 0
	for token: String in AMBIENT_TOKENS:
		if own.contains(token):
			ambient_here += 1
	_expect(ambient_here >= 3,
		"the ambient scan found only %d of its own tokens and may be inert" % ambient_here)
	var ladder_here: int = 0
	var support_source: String = FileAccess.get_file_as_string(
		"res://scripts/skills/support_selection.gd")
	var passive_source: String = FileAccess.get_file_as_string(
		"res://scripts/stats/passive_card_selection.gd")
	for token: String in LADDER_FIELD_TOKENS:
		if support_source.contains(token) or passive_source.contains(token):
			ladder_here += 1
	_expect(ladder_here >= 5,
		"the ladder-field scan found only %d of its tokens in the two files that build ladders"
			% ladder_here)

	## THE RESULT TYPE DESCRIBES A COMPOSITION AND MUST NEVER MAKE ONE.
	var offer_source: String = FileAccess.get_file_as_string(OFFER_FILE)
	for token: String in SELECTOR_CALL_TOKENS:
		_expect(not offer_source.contains(token),
			"the result type calls %s" % token)
	var composer_source: String = FileAccess.get_file_as_string(COMPOSER_FILE)
	var calls: int = 0
	for token: String in SELECTOR_CALL_TOKENS:
		if composer_source.contains(token):
			calls += 1
	_expect(calls == SELECTOR_CALL_TOKENS.size(),
		"the composer calls %d of the %d accepted selectors, so the scan above proves nothing"
			% [calls, SELECTOR_CALL_TOKENS.size()])

	## AND IT NEVER REACHES AROUND THE CONTINUATION TO THE WEIGHTED SELECTOR
	## UNDERNEATH IT (Foundation F3). Calling that directly would put the
	## new-pair-before-rank policy back inside a composer as a second copy, and it
	## would pass every other scan here because the class is one this file is
	## legitimately allowed to name.
	_expect(not composer_source.contains(FORBIDDEN_COMPOSER_CALL),
		"the composer calls %s directly instead of the accepted continuation"
			% FORBIDDEN_COMPOSER_CALL)
	_expect(FileAccess.get_file_as_string(
			"res://scripts/continuation/support_continuation.gd")
			.contains(FORBIDDEN_COMPOSER_CALL),
		"the accepted continuation does not call %s, so the scan above proves nothing"
			% FORBIDDEN_COMPOSER_CALL)

	## THE STAGING CALLS THE COMPOSER IS AUTHORIZED TO MAKE, AND THE ONES IT IS
	## NOT. It measures the frozen rank transition by staging the decided
	## operation on a discarded duplicate; reading a rank and applying the decided
	## operation is the whole of that, and anything beyond it — a total, a
	## run-build rank raise, a release — would be a composer recording progression
	## rather than describing it.
	var staging_present: PackedStringArray = PackedStringArray()
	for token: String in STAGING_MEMBERS:
		if composer_source.contains(token):
			staging_present.append(token)
	_expect(staging_present.size() == STAGING_MEMBERS.size(),
		"the composer stages through %d of the %d ranked-ownership members it must" % [
			staging_present.size(), STAGING_MEMBERS.size(),
		])
	var staging_forbidden: PackedStringArray = PackedStringArray()
	for token: String in FORBIDDEN_STAGING_MEMBERS:
		if composer_source.contains(token):
			staging_forbidden.append(token)
	_expect(staging_forbidden.is_empty(),
		"the composer calls the forbidden ranked-ownership member(s) %s"
			% ", ".join(staging_forbidden))
	_expect(not offer_source.contains("AcquiredSupports.new")
			and not offer_source.contains("duplicated()"),
		"the offer constructs or copies an acquisition record instead of only reading its ranks")

	## AN ALLOWLIST, NOT ONLY A DENYLIST. The token lists above can only refuse
	## names somebody remembered to add; this asks the ENGINE which project
	## classes exist and requires that the two scripts name none of them but the
	## eleven they are entitled to.
	var project_classes: PackedStringArray = PackedStringArray()
	for entry: Dictionary in ProjectSettings.get_global_class_list():
		var class_id: String = String(entry.get("class", ""))
		if not class_id.is_empty() and not AUTHORIZED_CLASSES.has(class_id):
			project_classes.append(class_id)
	_expect(project_classes.size() > 20,
		"only %d project classes were enumerated; the allowlist may be inert"
			% project_classes.size())
	for expected_refused: String in ["PassiveCardCatalogue", "SkillSupportCatalogue"]:
		_expect(project_classes.has(expected_refused),
			"%s is not among the classes this allowlist refuses, so its absence is unproved"
				% expected_refused)
	for path: String in D1_FILES:
		var source: String = FileAccess.get_file_as_string(path)
		var outside: PackedStringArray = PackedStringArray()
		for class_id: String in project_classes:
			if source.contains(class_id):
				outside.append(class_id)
		_expect(outside.is_empty(),
			"%s names the unauthorized project class(es) %s" % [
				path.get_file(), ", ".join(outside),
			])

	## AND THE EXACT SET, PER FILE, because an at-least-one test is OR-shaped.
	for row: Array in EXPECTED_NAMED_CLASSES:
		var path: String = String(row[0])
		var source: String = FileAccess.get_file_as_string(path)
		var actually_named: PackedStringArray = PackedStringArray()
		for class_id: String in CLASS_UNIVERSE:
			if source.contains(class_id):
				actually_named.append(class_id)
		var wanted: PackedStringArray = PackedStringArray()
		for class_id: String in row[1]:
			wanted.append(class_id)
		_expect(", ".join(actually_named) == ", ".join(wanted),
			"%s names [%s], not [%s]" % [
				path.get_file(), ", ".join(actually_named), ", ".join(wanted),
			])

	## THE PROOF A TOKEN SCAN CANNOT GIVE. A second weighted ladder, an
	## acquisition step, an experience rule or a reroll need name nothing
	## forbidden at all — each arrives as an extra method with a plausible name.
	## So both scripts' methods are enumerated from the engine and pinned BY NAME.
	var composer_methods: PackedStringArray = _methods_of(COMPOSER_FILE)
	_expect(", ".join(composer_methods) == ", ".join(EXPECTED_COMPOSER_METHODS),
		"the composer declares: %s" % ", ".join(composer_methods))
	var offer_methods: PackedStringArray = _methods_of(OFFER_FILE)
	_expect(", ".join(offer_methods) == ", ".join(EXPECTED_OFFER_METHODS),
		"the offer declares: %s" % ", ".join(offer_methods))

	var offer_fields: PackedStringArray = PackedStringArray()
	for entry: Dictionary in RiftOffer.new().get_property_list():
		if int(entry.get("usage", 0)) & PROPERTY_USAGE_SCRIPT_VARIABLE != 0:
			offer_fields.append(String(entry.get("name", "")))
	_expect(", ".join(offer_fields) == ", ".join(EXPECTED_OFFER_FIELDS),
		"an offer carries the fields: %s" % ", ".join(offer_fields))

	## THE COMPOSER CARRIES NO STATE AT ALL, which is what makes "no memory of the
	## last offer, no pity counter, no cache" a property of the file rather than a
	## promise in its header.
	var composer_fields: PackedStringArray = PackedStringArray()
	for entry: Dictionary in RiftOfferComposition.new().get_property_list():
		if int(entry.get("usage", 0)) & PROPERTY_USAGE_SCRIPT_VARIABLE != 0:
			composer_fields.append(String(entry.get("name", "")))
	_expect(composer_fields.is_empty(),
		"the composer carries the instance field(s) %s" % ", ".join(composer_fields))

	## NOTHING REFERENCES IT. There is no experience, no level, no choosing and no
	## applying, so no file that runs may name either class.
	var project_files: int = 0
	var referenced: PackedStringArray = PackedStringArray()
	for root: String in SCANNED_ROOTS:
		for path: String in _files_under(root, [".gd", ".tscn", ".tres"]):
			if D1_FILES.has(path):
				continue
			project_files += 1
			var source: String = FileAccess.get_file_as_string(path)
			for name: String in D1_CLASSES:
				if not source.contains(name):
					continue
				if _is_authorized_reader(path, name):
					continue
				referenced.append("%s names %s" % [path.get_file(), name])
	var settings: String = FileAccess.get_file_as_string(PROJECT_SETTINGS_FILE)
	for name: String in D1_CLASSES:
		if settings.contains(name):
			referenced.append("project.godot names %s" % name)
	_expect(not settings.contains("[autoload]"),
		"project.godot declares an [autoload] section")
	_expect(referenced.is_empty(),
		"Foundation D1 is referenced by code that runs: %s" % ", ".join(referenced))
	_expect(project_files > 100, "only %d project files were scanned" % project_files)
	_expect(_files_under("res://addons", [".gd"]).size() > 0,
		"the addons root was scanned and held no script, so widening the scan proved nothing")

	## THE EXEMPTIONS THE FIVE ACCEPTED SUITES GRANT THESE FILES ARE EARNED, AND
	## THE LISTS AGREE. Each of those suites proves that nothing names its classes
	## except an authorized reader; if a D1 file stopped naming them, the
	## exemption would quietly become a claim about nothing while still passing.
	for row: Array in AUTHORIZING_SUITES:
		var suite_path: String = String(row[0])
		var label: String = String(row[1])
		var granted: Array = row[2]
		var suite_source: String = FileAccess.get_file_as_string(suite_path)
		_expect(not suite_source.is_empty(),
			"the Foundation %s suite could not be read" % label)
		var listed: int = 0
		for path: String in granted:
			if suite_source.contains(path):
				listed += 1
		_expect(listed == granted.size(),
			"the Foundation %s suite authorizes %d of the %d D1 scripts it must" % [
				label, listed, granted.size(),
			])

	## Determinism at the file level, measured rather than argued.
	var first: String = _full(_shipped_offer(INDEPENDENCE_SEED))
	var drifted: int = 0
	for _call: int in REPEAT_CALLS:
		if _full(_shipped_offer(INDEPENDENCE_SEED)) != first:
			drifted += 1
	_expect(drifted == 0, "%d of %d identical offers disagreed" % [drifted, REPEAT_CALLS])

	print("  %d scripts scanned raw: %d forbidden tokens, %d ambient reads, %d ladder fields; "
		% [scanned, forbidden_total, ambient_total, ladder_total]
		+ "%d methods and %d fields pinned, 0 composer state; " % [
			composer_methods.size() + offer_methods.size(), offer_fields.size(),
		]
		+ "%d project files name no Foundation D1 class; %d of %d identical offers disagree"
			% [project_files, drifted, REPEAT_CALLS])
	_done("the_composer_is_generic_reads_nothing_ambient_and_is_unwired")


# --- Helpers ---------------------------------------------------------------------------
#
# Every fabricated record below is test data only: it is in no catalogue, no
# scene and no `.tres`, and it is not canon.

func _shipped_offer(root_seed: int) -> RiftOffer:
	return RiftOfferComposition.compose(
		SkillSupportCatalogue.skill_profiles(),
		SkillSupportCatalogue.support_definitions(),
		null,
		PassiveCardCatalogue.records(),
		root_seed
	)


func _profile(id: StringName, tags: Array[StringName]) -> SkillTagProfile:
	return SkillTagProfile.of(id, "Test Skill %s" % id, tags)


## THE MAXIMUM RANK EVERY FABRICATED DEFINITION DECLARES (Foundation I5, D-301). A
## usable maximum is part of a definition's validity, so a fixture that declared none
## would be refused by every composition. Rebuilt shipped definitions carry the
## shipped definition's own derived maximum instead. Test data, not balance.
const FIXTURE_MAXIMUM_RANK: int = 1000


func _definition(id: StringName, required_all: Array[StringName],
		weight: int) -> SupportDefinition:
	return SupportDefinition.of(
		SupportEligibility.of(id, "Test Support %s" % id, required_all,
			[] as Array[StringName], [] as Array[StringName]),
		weight, {}, FIXTURE_MAXIMUM_RANK
	)


func _two_skills() -> Array[SkillTagProfile]:
	var out: Array[SkillTagProfile] = []
	out.append(_profile(&"s1_contact", [
		SkillTags.ATTACK, SkillTags.HIT, SkillTags.MELEE, SkillTags.STRIKE, SkillTags.PHYSICAL,
	] as Array[StringName]))
	out.append(_profile(&"s2_contact", [
		SkillTags.ATTACK, SkillTags.HIT, SkillTags.MELEE, SkillTags.PHYSICAL,
	] as Array[StringName]))
	return out


func _three_supports() -> Array[SupportDefinition]:
	var out: Array[SupportDefinition] = []
	out.append(_definition(&"t1_light", [SkillTags.MELEE] as Array[StringName], 5))
	out.append(_definition(&"t2_medium", [SkillTags.MELEE] as Array[StringName], 7))
	out.append(_definition(&"t3_heavy", [SkillTags.MELEE] as Array[StringName], 11))
	return out


func _reweighted_cards(cards: Array[PassiveCardDefinition], target: StringName,
		weight: int) -> Array[PassiveCardDefinition]:
	var out: Array[PassiveCardDefinition] = []
	for record: PassiveCardDefinition in cards:
		out.append(PassiveCardDefinition.of(record.card_id, record.display_name,
			record.stat_id, record.magnitude,
			weight if record.card_id == target else record.base_weight, record.repeatable))
	return out


func _reweighted_count(before: Array[PassiveCardDefinition],
		after: Array[PassiveCardDefinition]) -> int:
	if before.size() != after.size():
		return -1
	var moved: int = 0
	for index: int in before.size():
		if before[index].base_weight != after[index].base_weight:
			moved += 1
	return moved


func _category_of(cards: Array[PassiveCardDefinition], card_id: StringName) -> int:
	for record: PassiveCardDefinition in cards:
		if record.card_id == card_id:
			return record.category()
	return RiftOffer.NO_CATEGORY


func _profile_with_id(profiles: Array[SkillTagProfile], id: StringName) -> SkillTagProfile:
	for profile: SkillTagProfile in profiles:
		if profile != null and profile.skill_id == id:
			return profile
	return null


func _definition_with_id(definitions: Array[SupportDefinition],
		id: StringName) -> SupportDefinition:
	for definition: SupportDefinition in definitions:
		if definition != null and definition.support_id() == id:
			return definition
	return null


## The WHOLE derivation as one string, so a comparison cannot pass by agreeing on
## the answer while disagreeing about how it was reached.
## THE WHOLE COMPOSED OFFER AS ONE COMPARABLE STRING, PROGRESSION INCLUDED. The
## support lane's frozen kind and rank transition are part of what an offer IS
## since Foundation F3, so an independence or order proof that compared
## everything except them would be comparing less than the whole answer. The
## nested continuation's own `describe()` carries the weighted derivation
## underneath it, so nothing was dropped by naming the decision instead of the
## draw.
func _full(offer: RiftOffer) -> String:
	if not offer.ok:
		return "REFUSED lane=%d seed=%d reason='%s'" % [
			offer.refusing_lane, offer.root_seed, offer.failure_reason,
		]
	return "root=%d lanes=[%s] seeds=[%s] %s [%s] | %s | %s | %s" % [
		offer.root_seed, ", ".join(_as_text(offer.lane_order())), offer.seed_line(),
		offer.offer_line(), offer.support_progression_line(),
		offer.support_continuation.describe(),
		offer.combat_derivation.describe(), offer.utility_derivation.describe(),
	]


## THE WHOLE DERIVATION WITHOUT THE ROOT SEED THE OFFER ECHOES. Two root seeds
## that mask to the same 32 bits are ONE QUESTION and must compose identically —
## but each offer still echoes the seed it was actually handed, so the full form
## above legitimately differs for them and cannot express that property.
func _derived(offer: RiftOffer) -> String:
	if not offer.ok:
		return "REFUSED lane=%d reason='%s'" % [offer.refusing_lane, offer.failure_reason]
	return "lanes=[%s] seeds=[%s] %s [%s] | %s | %s | %s" % [
		", ".join(_as_text(offer.lane_order())), offer.seed_line(),
		offer.offer_line(), offer.support_progression_line(),
		offer.support_continuation.describe(),
		offer.combat_derivation.describe(), offer.utility_derivation.describe(),
	]


## ONE LANE's whole derivation, used to prove that a change in another lane's
## inputs did not reach it. It deliberately includes the lane SEED, the selected
## identity and the nested derivation, because a lane can move without changing
## its answer — a different ticket over the same ladder is still a moved lane.
func _lane_part(offer: RiftOffer, lane: int) -> String:
	if not offer.ok:
		return "REFUSED %d %s" % [offer.refusing_lane, offer.failure_reason]
	match lane:
		RiftOffer.Lane.SUPPORT:
			return "%d|%s|%s" % [offer.seed_for(lane), " -> ".join(offer.identity_for(lane)),
				offer.support_derivation.describe()]
		RiftOffer.Lane.COMBAT_DEFENCE:
			return "%d|%s|%s" % [offer.seed_for(lane), " -> ".join(offer.identity_for(lane)),
				offer.combat_derivation.describe()]
		RiftOffer.Lane.UTILITY:
			return "%d|%s|%s" % [offer.seed_for(lane), " -> ".join(offer.identity_for(lane)),
				offer.utility_derivation.describe()]
	return "unrecognised lane %d" % lane


## How many seeds, out of `SEED_SAMPLES`, at which the mutated inputs change the
## SELECTED IDENTITY of `lane`. A mutation that moves nothing cannot prove that
## nothing else moved.
func _lane_movement(
	mutated_profiles: Array[SkillTagProfile],
	mutated_definitions: Array[SupportDefinition],
	mutated_cards: Array[PassiveCardDefinition],
	base_profiles: Array[SkillTagProfile],
	base_definitions: Array[SupportDefinition],
	base_cards: Array[PassiveCardDefinition],
	lane: int
) -> int:
	var moved: int = 0
	for seed_value: int in SEED_SAMPLES:
		var base: RiftOffer = RiftOfferComposition.compose(
			base_profiles, base_definitions, null, base_cards, seed_value)
		var changed: RiftOffer = RiftOfferComposition.compose(
			mutated_profiles, mutated_definitions, null, mutated_cards, seed_value)
		if not base.ok or not changed.ok:
			_expect(false, "seed %d refused during a movement measurement" % seed_value)
			continue
		if " -> ".join(changed.identity_for(lane)) != " -> ".join(base.identity_for(lane)):
			moved += 1
	return moved


## How many seeds, out of `SEED_SAMPLES`, at which the mutated inputs change ANY
## lane other than `lane`, compared on the whole lane derivation rather than on
## the answer alone.
func _lane_bleed(
	mutated_profiles: Array[SkillTagProfile],
	mutated_definitions: Array[SupportDefinition],
	mutated_cards: Array[PassiveCardDefinition],
	base_profiles: Array[SkillTagProfile],
	base_definitions: Array[SupportDefinition],
	base_cards: Array[PassiveCardDefinition],
	lane: int
) -> int:
	var bled: int = 0
	for seed_value: int in SEED_SAMPLES:
		var base: RiftOffer = RiftOfferComposition.compose(
			base_profiles, base_definitions, null, base_cards, seed_value)
		var changed: RiftOffer = RiftOfferComposition.compose(
			mutated_profiles, mutated_definitions, null, mutated_cards, seed_value)
		if not base.ok or not changed.ok:
			_expect(false, "seed %d refused during a bleed measurement" % seed_value)
			continue
		for other: int in RiftOffer.LANE_ORDER:
			if other == lane:
				continue
			if _lane_part(changed, other) != _lane_part(base, other):
				bled += 1
				break
	return bled


## A refusal must name its lane BOTH in words and by member, must name the fault
## rather than merely report that there was one, must expose nothing at all, and
## must itself be a coherent result.
func _expect_refusal(
	profiles: Array[SkillTagProfile],
	definitions: Array[SupportDefinition],
	acquired: AcquiredSupports,
	cards: Array[PassiveCardDefinition],
	expected_lane: int,
	expected_fragment: String,
	described: String
) -> void:
	_refusals += 1
	var offer: RiftOffer = RiftOfferComposition.compose(
		profiles, definitions, acquired, cards, INDEPENDENCE_SEED)
	_expect(not offer.ok, "%s was accepted" % described)
	_expect(offer.refusing_lane == expected_lane,
		"%s was refused at lane %d, not %d" % [described, offer.refusing_lane, expected_lane])
	_expect(offer.failure_reason.contains(RiftOffer.lane_label(expected_lane)),
		"%s was refused as '%s', which does not name the %s lane" % [
			described, offer.failure_reason, RiftOffer.lane_label(expected_lane),
		])
	_expect(offer.failure_reason.contains(expected_fragment),
		"%s was refused as '%s', which does not name '%s'" % [
			described, offer.failure_reason, expected_fragment,
		])
	_expect(String(offer.skill_id).is_empty() and String(offer.support_id).is_empty()
			and String(offer.combat_card_id).is_empty()
			and String(offer.utility_card_id).is_empty(),
		"%s left an identity behind" % described)
	_expect(offer.lane_order().is_empty() and offer.lane_seeds.is_empty(),
		"%s left a lane behind" % described)
	_expect(offer.support_derivation == null and offer.combat_derivation == null
			and offer.utility_derivation == null,
		"%s left a derivation behind" % described)
	## FOUNDATION F3: WHICH OPERATION THE SUPPORT LANE WOULD HAVE OFFERED, AND THE
	## RANKS IT WOULD HAVE MOVED BETWEEN, ARE ANSWERS TOO. Asserted on every driven
	## refusal rather than once, because a partial offer is not a thing one case
	## can rule out for all the others.
	_expect(offer.support_continuation == null
			and offer.support_progression_kind == RiftOffer.UNRESOLVED_PROGRESSION_KIND
			and offer.support_rank_before == RiftOffer.UNRESOLVED_RANK
			and offer.support_rank_after == RiftOffer.UNRESOLVED_RANK,
		"%s left a support progression behind" % described)
	_expect(offer.problem().is_empty(),
		"the refusal of %s is itself incoherent: %s" % [described, offer.problem()])


## Whether `path` is granted `name` by the allowlist above. An exact per-file,
## per-class test: a file not listed is granted nothing, and a listed file is
## granted only the classes written beside it.
func _is_authorized_reader(path: String, name: String) -> bool:
	for row: Array in AUTHORIZED_READERS:
		if String(row[0]) != path:
			continue
		for granted: String in row[1]:
			if granted == name:
				return true
		return false
	return false


func _methods_of(path: String) -> PackedStringArray:
	var out: PackedStringArray = PackedStringArray()
	var script: GDScript = load(path) as GDScript
	if script == null:
		return out
	for entry: Dictionary in script.get_script_method_list():
		out.append(String(entry.get("name", "")))
	return out


func _as_text(values: Array[int]) -> PackedStringArray:
	var out: PackedStringArray = PackedStringArray()
	for value: int in values:
		out.append(str(value))
	return out


func _lane_labels(lanes: Array[int]) -> PackedStringArray:
	var out: PackedStringArray = PackedStringArray()
	for lane: int in lanes:
		out.append(RiftOffer.lane_label(lane))
	return out


func _ids_of_profiles(profiles: Array[SkillTagProfile]) -> String:
	var out: PackedStringArray = PackedStringArray()
	for profile: SkillTagProfile in profiles:
		out.append(String(profile.skill_id) if profile != null else "<null>")
	return ", ".join(out)


func _ids_of_definitions(definitions: Array[SupportDefinition]) -> String:
	var out: PackedStringArray = PackedStringArray()
	for definition: SupportDefinition in definitions:
		out.append(String(definition.support_id()) if definition != null else "<null>")
	return ", ".join(out)


func _ids_of_cards(cards: Array[PassiveCardDefinition]) -> String:
	var out: PackedStringArray = PackedStringArray()
	for record: PassiveCardDefinition in cards:
		out.append(String(record.card_id) if record != null else "<null>")
	return ", ".join(out)


func _sorted_text(line: String) -> String:
	var parts: PackedStringArray = line.split(", ")
	parts.sort()
	return ", ".join(parts)


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
