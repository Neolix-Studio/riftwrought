extends SceneTree
## Riftwrought — Roguelite Foundation D3 verification: the atomic Rift-offer
## choice and its single-consumption protection.
##
## ONE FOCUSED HEADLESS TEST. The foundation is three pure-logic scripts under
## `scripts/choices/`, so it needs no scene, no camera, no navigation, no
## rendering and no evidence frame, and it deliberately gets none. It runs as a
## `SceneTree` script exactly as all seven earlier foundations' suites do.
##
## IT PORTS D-211's OWED-SET DISCIPLINE. Every check function records reaching
## its LAST line, and the suite compares that set against what it owes in BOTH
## directions, so a check that dies half way cannot leave a green run behind it.
##
## EVERY ATOMICITY PROOF COMPARES THE WHOLE OF BOTH SUPPLIED VALUES. A complete
## snapshot of the run build — every pair, every card count, every bound
## mechanical identity and every stat total to seventeen significant digits — is
## taken beside a complete snapshot of the ledger immediately before each
## attempt, and both are compared afterwards. Checking only the thing the
## operation was about is how a partial mutation survives a green suite, and this
## transaction touches two objects rather than one.
##
## THE SUPPLIED VALUES ARE SEEDED BEFORE EVERY ATOMICITY PROOF, ON PURPOSE.
## "Nothing changed" is nearly free to satisfy on an empty build and an empty
## ledger; it is a real claim only when there is something there to disturb.
##
## FOUNDATION F4 (D-257) EXTENDED THE TRANSACTION THIS SUITE PINS, AND WHAT
## MOVED HERE IS RECORDED RATHER THAN LEFT TO BE INFERRED. The support lane now
## consumes the FROZEN progression an offer carries — it compares the offer's
## before-rank against the run's current rank, routes on the frozen kind to the
## acquisition or the rank operation, and verifies the rank it reached before
## spending the seed. NO CHECK IN THIS SUITE CHANGED ITS SUBJECT: every offer
## composed here is composed against an empty acquisition record, so every one of
## them is still a new pair at the first rank, and check 9's stale refusal is now
## reached because the frozen before-rank disagrees with the held rank rather than
## because the pair is held — the same refusal, naming the same pair, spending the
## same nothing. What moved is four PINS (the deferred-member list, the per-file
## class allowlist, the result's method list and its field list) and exactly ONE
## added assertion, which pays for a substring the widened class allowlist could
## not avoid granting. See `CONTINUATION_CALL`.
##
## THE POSITIVE CASES USE THE SHIPPED CATALOGUES AND NOTHING ELSE, which is what
## makes them statements about the project rather than about a fixture. The
## refusal cases that cannot be reached with the shipped records use test-only
## coherent record sets built inside this file: every one of them is in no
## catalogue, no scene and no `.tres`, is not canon, and each is asserted VALID
## on its own before its refusal is counted — because a refusal that is right for
## the wrong reason looks identical from the outside.

# --- The three scripts this foundation owns -------------------------------------

const CHOICE_FILE: String = "res://scripts/choices/rift_offer_choice.gd"
const RESULT_FILE: String = "res://scripts/choices/rift_offer_choice_result.gd"
const LEDGER_FILE: String = "res://scripts/choices/rift_consumption_ledger.gd"

const D3_FILES: Array[String] = [
	"res://scripts/choices/rift_offer_choice.gd",
	"res://scripts/choices/rift_offer_choice_result.gd",
	"res://scripts/choices/rift_consumption_ledger.gd",
]

## The three global class names this foundation introduces. NOTHING that runs may
## reference any of them: D3 resolves a choice and is deliberately unwired — no
## experience, no level, no UI, no scene, no persistence.
##
## NOTE THE SUBSTRING: `RiftOfferChoice` is contained in `RiftOfferChoiceResult`,
## so a file naming the result is reported as naming the transaction too. That is
## the scan being blunt in the safe direction — everything is refused either way.
const D3_CLASSES: Array[String] = [
	"RiftOfferChoiceResult", "RiftOfferChoice", "RiftConsumptionLedger",
]

## THE FILES AUTHORIZED TO NAME A FOUNDATION D3 CLASS, AND THE EXACT CLASSES EACH
## MAY NAME (D-248). The Foundation E2 level-up coordinator OWNS one consumption
## ledger for the lifecycle it coordinates, stages a copy of it, hands that copy
## to this transaction and commits the new one the transaction returns — so it
## names all three: the ledger it holds, the transaction it delegates to, and the
## result it reads and deliberately never hands on. Its own result type names the
## transaction's result too, for the one thing only that file writes down: how
## many identifiers a lane grants.
##
## THIS REPLACES D-244's BLANKET "no file that runs may name any of the three"
## ONE FOR ONE: the same single assertion is made either way, it still fails for
## any other file AND for any class a listed file is not granted, and the pinned
## count does not move.
##
## THE SUBSTRING NOTED ABOVE APPLIES HERE TOO: a grant for `RiftOfferChoiceResult`
## must carry `RiftOfferChoice` with it, because the second is contained in the
## first. Both listed files genuinely name both, and the E2 suite asserts which
## of them CALLS the transaction and which only reads its result.
const AUTHORIZED_READERS: Array = [
	["res://scripts/levels/rift_level_up_coordinator.gd", [
		"RiftOfferChoice", "RiftOfferChoiceResult", "RiftConsumptionLedger",
	]],
	["res://scripts/levels/rift_level_up_result.gd", [
		"RiftOfferChoice", "RiftOfferChoiceResult",
	]],
	## Foundation G4 (decision D-269): the repeated run-level coordinator asks the
	## current one-level lifecycle's ledger COPY whether the derived root seed has
	## already been consumed before it opens an offer — the spent-seed preflight
	## D-268 ruling 4 binds it to — and hands that copy out as its ledger reading.
	## It names the LEDGER and nothing else here: it never calls this transaction
	## and never reads its result. Added one for one, and the pinned count does
	## not move.
	["res://scripts/levels/rift_run_level_coordinator.gd", ["RiftConsumptionLedger"]],
]

## Concrete Skill, support, card and instrument names, plus the two presentation
## fields a record carries. Scanned RAW, comments included — D-215's lesson: an
## illustrative name in a comment breaches the rule just as surely as a real one.
##
## `PassiveCardCatalogue` IS DELIBERATELY NOT IN THIS LIST and is handled
## separately below, because exactly one of the three files is required to name
## it and the other two are required not to.
const FORBIDDEN_TOKENS: Array[String] = [
	"QuickStrike", "quick_strike", "Quick Strike",
	"PrototypePlayer", "PrototypeWeaponData", "PrototypeGraveblade",
	"PassiveEffects", "PassiveGraph", "PassiveNodeData",
	"RogueliteUpgrade", "RogueliteRunBoon", "RogueliteBuildState", "RogueliteRunPlan",
	"SkillSupportCatalogue", "SkillTags", "SupportEligibility", "SkillTagProfile",
	"SupportDefinition", "SupportSelection", "SupportSelectionResult",
	"PassiveCardSelection", "PassiveCardSelectionResult",
	"PlayerStats", "PlayerStatDefinition", "PlayerStatValue", "PlayerStatTotals",
	"AcquiredSupports", "RiftOfferComposition",
	"FirstMvpSkill", "CharacterState", "ExperienceTable", "PlayerLoadout",
	"Faultbreaker", "Splinter Shot", "Emberbolt", "Marrowshot",
	"Reaching Edge", "reaching_edge", "Sweeping Edge", "sweeping_edge",
	"Expedition Blade", "Quickened Edge", "Quickened Form",
	"First Fracture", "first_fracture", "Graveblade", "Riftmarked",
	"card_power", "card_celerity", "card_vitality",
	"card_fleetness", "card_insight", "card_magnetism",
	"Celerity", "Vitality", "Fleetness", "Insight", "Magnetism",
	"display_name", "base_weight",
]

## The one project class exactly one D3 file must name and the other two must
## not. Asserted in BOTH directions: a transaction that stopped resolving ids
## through the canonical catalogue would be a different mechanism, and a ledger
## or a result that started naming it would be a value that had learned about
## content.
const CATALOGUE_TOKEN: String = "PassiveCardCatalogue"

## The accepted continuation SELECTOR's call, which neither file granted the
## continuation vocabulary may make (D-257). Reading which operation an offer
## FROZE is consuming a decision; making that call would be taking it.
const CONTINUATION_CALL: String = "SupportContinuation.select"

## A pure value may read no ambient state whatsoever.
const AMBIENT_TOKENS: Array[String] = [
	"randi", "randf", "randomize", "RandomNumberGenerator", "rand_from_seed",
	"Time.", "OS.", "Engine.", "ProjectSettings", "InputMap",
	"FileAccess", "ConfigFile", "ResourceSaver", "ResourceLoader", "user://",
]

## THE SYSTEMS THIS FOUNDATION DEFERS, AS MEMBER-NAME TOKENS.
##
## SCANNED OVER CODE LINES ONLY, AND THE REASON IS A DEFECT GATE 1C ALREADY
## FOUND: a guard whose token is too crude fires on the sentence that makes the
## claim. All three files say in plain English that they grant no experience,
## apply nothing to an actor, and have no reset or persistence — so a raw scan
## for `experience`, `apply` or `reset` would be red on exactly the files that
## promise none of them. The concrete-name scan above stays RAW, where the
## opposite rule applies.
##
## `offer`, `lane`, `consume` and `choice` are absent from this list on purpose:
## they are this foundation's own vocabulary rather than a deferred system's.
## `rank` WAS ON THIS LIST AND IS NOT ANY MORE, AND THAT IS AN AUTHORIZED MOVE
## RATHER THAN A WEAKENING (Foundation F4, decision D-257). It was here because
## D3 consumed a PAIR and knew nothing about ranks, so `support_rank_before`
## arriving in this file would have meant a deferred system had leaked in. F4
## authorizes exactly that arrival: the transaction now compares the offer's
## frozen before-rank against the run's current rank, routes to the acquisition
## or the rank operation on the accepted run build, and verifies the rank it
## reached. The token would now be red on the very members the foundation exists
## to add.
##
## IT IS REPLACED BY WHAT IS STILL DEFERRED, WHICH IS THE POINT — a token
## removed and nothing put back is a guard quietly narrowed. F4 adds no per-rank
## VALUE, no gameplay ceiling on a rank and no way to give one back, and none of
## the four tokens below appears in any of the three files. `rank_cap` and
## `max_rank` are the two shapes a gameplay ceiling arrives as; `refund` is the
## reversal; `magnitude` is the per-rank effect value, which is the single thing
## a consumed rank must keep not having.
const DEFERRED_MEMBER_TOKENS: Array[String] = [
	"experience", "level", "abandon",
	"reroll", "rarity", "pity", "affix",
	"eligib", "exhaust", "refine",
	"save", "persist", "storage", "schema", "migrat",
	"reset", "death", "nexus",
	"apply", "actor", "base_value", "current_life",
	"input", "controller", "viewport", "canvas",
	"rank_cap", "max_rank", "refund", "magnitude",
	"xp", "mote", "skip", "ban", "lock", "luck",
]

## THE SHORT TOKENS ABOVE ARE MATCHED AS IDENTIFIER WORDS RATHER THAN AS BARE
## SUBSTRINGS, AND THE REASON IS A DEFECT THIS SUITE FOUND IN ITSELF. `xp` as a
## substring is contained in `expose`, and the result type says in plain code that
## a refusal must "expose no updated run build" — so the first form of this scan
## was red on exactly the line that makes the promise it exists to protect. That
## is Gate 1C's lesson arriving a third time: a guard whose token is too crude
## fires on the sentence that makes the claim.
##
## THE FIX KEEPS THE GUARD STRONG RATHER THAN SOFTENING IT, AND THE DIFFERENCE
## MATTERS. A letter or a digit on either side is a boundary; an UNDERSCORE is
## not treated as part of the word, so `award_xp`, `experience_mote`,
## `skip_offer` and `lock_offer` are all still caught, while `expose`, `remote`,
## `block` and `abandon` are not — and `abandon` is in the list above in its own
## right, so nothing was lost by removing the `ban` coincidence that used to catch
## it. The matcher itself is proved in both directions in check 15.
##
## THE ORIGINAL WORDING OF THIS PARAGRAPH NAMED `support_rank` AS ONE OF THE
## MEMBERS STILL CAUGHT, and that stopped being true when D-257 retired the `rank`
## token above; the example is removed rather than left standing as a claim about
## a token that is no longer in either list. Nothing about the matcher changed.
const WORD_MATCHED_TOKENS: Array[String] = [
	"xp", "mote", "skip", "ban", "lock", "luck",
]

## The only project classes each D3 file may name. An ALLOWLIST derived from the
## engine's own global class list, PER FILE — not a denylist of remembered names,
## and not one shared list, because a shared list would hand the catalogue to the
## ledger as a side effect of granting it to the transaction.
## `SupportContinuationResult` IS GRANTED TO TWO OF THE THREE SINCE D-257, AND
## THE GRANT IS EXACT — WITH ONE BLUNTNESS THAT IS PAID FOR RATHER THAN ACCEPTED.
## `SupportContinuation`, the accepted SELECTOR, is a substring of
## `SupportContinuationResult`, so this scan reports a file naming the record as
## naming the selector too and the selector has to be granted beside it. That
## grant would otherwise open a real hole: a transaction that CALLED the selector
## would be deciding which operation to offer instead of consuming the one an
## offer froze. So it is narrowed immediately below by `CONTINUATION_CALL`, which
## refuses that call in both files by name.
##
## THE REST OF THE GRANT. That record is where the two progression operations are
## DECLARED, so a transaction that routes on the operation an offer froze must
## name it — inventing offer-level predicates instead would be a second vocabulary
## for one pair of operations — and the result names it for the one thing the
## vocabulary already formats, its own kind label. The LEDGER is still refused it,
## exactly as it is refused the card catalogue: a value that had learned what a
## support operation is would have stopped being one.
const AUTHORIZED_CLASSES: Array = [
	["res://scripts/choices/rift_offer_choice.gd", [
		"RiftOfferChoice", "RiftOfferChoiceResult", "RiftOffer", "RiftRunBuild",
		"RiftConsumptionLedger", "PassiveCardCatalogue", "PassiveCardDefinition",
		"SupportContinuationResult", "SupportContinuation",
	]],
	["res://scripts/choices/rift_offer_choice_result.gd", [
		"RiftOfferChoice", "RiftOfferChoiceResult", "RiftOffer", "RiftRunBuild",
		"RiftConsumptionLedger", "SupportContinuationResult", "SupportContinuation",
	]],
	["res://scripts/choices/rift_consumption_ledger.gd", ["RiftConsumptionLedger"]],
]

## `res://addons` IS SCANNED TOO. An editor plugin is code that runs; a reference
## from one would load these classes while a scripts/scenes/data scan reported
## nothing. `project.godot` is checked separately, because an `[autoload]` entry
## names a class from a file no extension filter would reach.
const SCANNED_ROOTS: Array[String] = [
	"res://scripts", "res://scenes", "res://data", "res://addons",
]

const PROJECT_SETTINGS_FILE: String = "res://project.godot"

## The three accepted suites whose scope assertions D3 moved one for one, the
## D3 scripts each must now authorize by path, and the exact classes that grant
## is for. Read from the suites' own sources: a grant nobody can see is a grant
## that quietly stops meaning anything.
const AUTHORIZING_SUITES: Array = [
	["res://tests/rift_offer_composition_verification.gd", "D1",
		["res://scripts/choices/rift_offer_choice.gd",
			"res://scripts/choices/rift_offer_choice_result.gd"],
		["RiftOffer"]],
	["res://tests/rift_run_build_verification.gd", "D2",
		["res://scripts/choices/rift_offer_choice.gd",
			"res://scripts/choices/rift_offer_choice_result.gd"],
		["RiftRunBuild"]],
	["res://tests/passive_card_records_verification.gd", "C2",
		["res://scripts/choices/rift_offer_choice.gd"],
		["PassiveCardDefinition", "PassiveCardCatalogue"]],
]

## THE PROOF A TOKEN SCAN CANNOT GIVE. A second offer, a level-up step, a reset
## rule or a persistence hook need name nothing forbidden at all — each arrives
## as an extra method with a plausible name. So each script's methods are
## enumerated from the engine and pinned BY NAME, in order.
## ROGUELITE FOUNDATION I8 (D-308) MOVED THREE PINS ONE FOR ONE, AND NO ASSERTION WAS
## ADDED OR REMOVED. The transaction gained `_stage_support_fallback`, the staging
## of a passive-fallback Support lane as one passive-card acquisition; the result
## gained `identity_size_for_content`, `chosen_support_fallback` and
## `carries_support_fallback`, and the two appended fields
## `support_content_kind` and `support_fallback_category`. Each list is still
## compared whole in one assertion, in declaration order.
const EXPECTED_CHOICE_METHODS: Array[String] = [
	"choose", "_stage", "_stage_support", "_stage_support_fallback", "_stage_passive",
]

## `chosen_identity` IS A METHOD SINCE D-249, not the public field it was. That
## is the correction itself and not a cosmetic move: the field aliased, so a
## caller reading it could grow the identity inside an accepted result and make
## `problem()` below report that very result as incoherent.
##
## TWO MORE ARRIVED WITH D-257 AND BOTH ARE INSPECTION ONLY:
## `carries_support_progression()` is the authority on whether the two rank fields
## say anything, and `support_progression_line()` is a diagnostic. Neither grants,
## computes or applies anything, and `describe()` deliberately does NOT quote the
## second — the accepted suites compare that line, and a progression appearing
## inside it would change what those comparisons mean.
##
## A THIRD ARRIVED WITH D-258, AND IT IS A MOVE RATHER THAN AN ADDITION.
## `support_progression_build_problem()` is the comparison between the CARRIED
## BUILD's current rank and the rank this choice reached; it was written inside
## `problem()` and it did not belong there, because a caller that legitimately
## raises that support again made a finished, correct result start reporting itself
## incoherent. `problem()` now owns only the facts that stay true, and this owns
## the one that is allowed to stop being true. Neither guard was weakened: the
## transaction still reads the staged rank back and refuses before spending the
## seed.
const EXPECTED_RESULT_METHODS: Array[String] = [
	"identity_size_for", "identity_size_for_content", "refused_without_a_seed", "refused",
	"chosen", "chosen_support_fallback", "chosen_identity", "carries_support_progression",
	"carries_support_fallback", "problem",
	"support_progression_build_problem", "identity_line",
	"support_progression_line", "describe", "_stated",
]

const EXPECTED_LEDGER_METHODS: Array[String] = [
	"consume", "has_consumed", "count", "is_empty", "consumed_seeds",
	"duplicated", "describe",
]

## FIVE PUBLIC SCALARS, ONE PRIVATE COLLECTION, AND TWO PUBLIC OBJECT FIELDS.
## The collection is private since D-249 for a measured reason; the two object
## fields are the new values the transaction produced and are the whole point of
## the result, and an object read out of an object was never a copy in the first
## place, so nothing about them was ever believed that turned out to be false.
## EIGHT PUBLIC SCALARS SINCE D-257, and the three that arrived are the consumed
## support progression: which operation was taken and the two ranks it moved
## between. They are scalars for exactly the reason the five before them are — an
## int read out of an object cannot reach the object — so the D-249 measurement
## covers them without being re-argued, and the one collection here is still
## private and still copied on the way out.
const EXPECTED_RESULT_FIELDS: Array[String] = [
	"ok", "failure_reason", "root_seed", "root_seed_known", "lane",
	"support_progression_kind", "support_rank_before", "support_rank_after",
	"_chosen_identity", "new_build", "new_ledger",
	"support_content_kind", "support_fallback_category",
]

const EXPECTED_LEDGER_FIELDS: Array[String] = ["_consumed"]

# --- The seeds this suite is built on -------------------------------------------
#
# Every one of them was found by composing the SHIPPED catalogues and reading
# what came out, and each is pinned here so a check names the property it needs
# rather than hunting for a seed at run time.

## Offers `quick_strike -> reaching_edge`, `card_vitality`, `card_magnetism` —
## three lanes whose three effects are distinct in stat AND in magnitude, so a
## lane that granted another lane's effect could not look correct.
const LANE_SEED: int = 0

## Two DIFFERENT root seeds whose offers are identical in all four identities.
const TWIN_SEED_A: int = 3
const TWIN_SEED_B: int = 6

## Two more whose Combat and Defence lanes offer the same repeatable card.
const REPEAT_SEED_A: int = 7
const REPEAT_SEED_B: int = 9

## The two full seeds the composition mechanism masks into ONE question.
const MASKED_LOW: int = -1
const MASKED_HIGH: int = 9223372036854775807

## Offers the same support pair as `LANE_SEED`, which is what makes a stale
## support offer reachable without fabricating anything.
const STALE_SEED: int = 3

## A lane value outside the declared set, and the offer contract's own
## "unresolved" value, which is also outside it.
const UNDECLARED_LANE: int = 7

# --- What the shipped records must produce, typed independently -----------------
#
# Typed here rather than read from the catalogue being exercised: a check that
# takes its expected answer from the thing it is checking proves only that a file
# agrees with itself.

const EXPECTED_SKILL: StringName = &"quick_strike"
const EXPECTED_SUPPORT: StringName = &"reaching_edge"
const EXPECTED_COMBAT_CARD: StringName = &"card_vitality"
const EXPECTED_COMBAT_STAT: StringName = &"maximum_life"
const EXPECTED_COMBAT_MAGNITUDE: float = 0.15
const EXPECTED_UTILITY_CARD: StringName = &"card_magnetism"
const EXPECTED_UTILITY_STAT: StringName = &"pickup_radius"
const EXPECTED_UTILITY_MAGNITUDE: float = 0.25
const EXPECTED_REPEAT_CARD: StringName = &"card_power"
const EXPECTED_REPEAT_STAT: StringName = &"global_damage"
const EXPECTED_REPEAT_MAGNITUDE: float = 0.10

## What two acquisitions of the repeatable card must come to. Additive, and
## compared with `==` rather than with a tolerance.
const EXPECTED_REPEAT_TOTAL: float = 0.20

## A canonical Utility card id carried by a test-only record that declares a
## Combat and Defence stat, and the mirror. They are what make the
## category-disagreement refusal reachable: the OFFER is composed against the
## fabricated record, and the TRANSACTION resolves the canonical one.
const CANONICAL_UTILITY_ID: StringName = &"card_insight"
const CANONICAL_COMBAT_ID: StringName = &"card_power"

const PROBE_WEIGHT: int = 100
const PROBE_MAGNITUDE: float = 0.10

## The presentation label every renamed record carries, and the label no shipped
## record does.
const RENAME_PREFIX: String = "Zz Renamed "

const OWED_CHECKS: Array[String] = [
	"a_new_ledger_records_each_root_seed_once_and_hands_out_no_live_collection",
	"choosing_the_support_lane_adds_one_pair_and_no_passive_contribution",
	"choosing_the_combat_lane_adds_exactly_its_canonical_magnitude",
	"choosing_the_utility_lane_adds_exactly_its_canonical_magnitude",
	"only_the_selected_lane_moves_and_the_returned_values_are_independent_copies",
	"one_root_seed_can_be_consumed_only_once_whatever_it_is_asked_with",
	"two_root_seeds_that_compose_one_offer_are_independently_consumable",
	"the_masked_seeds_stay_distinct_consumption_identities",
	"a_stale_support_offer_refuses_without_consuming_its_seed",
	"every_absent_or_incoherent_argument_refuses_atomically",
	"a_passive_the_catalogue_refuses_or_miscategorises_refuses_atomically",
	"a_non_repeatable_passive_already_held_refuses_without_consuming",
	"a_repeatable_passive_taken_from_two_offers_counts_twice",
	"presentation_labels_cannot_change_the_transaction",
	"the_transaction_is_generic_reads_nothing_ambient_and_is_unwired",
	"the_granted_identity_cannot_be_reached_through_the_result",
]

var _failures: PackedStringArray = PackedStringArray()
var _checks: int = 0
var _reached: Dictionary = {}
var _refusals: int = 0


func _initialize() -> void:
	print("")
	print("=== Roguelite Foundation D3 — Atomic Rift-Offer Choice (D-244) ===")

	_check_a_new_ledger_records_each_root_seed_once()
	_check_choosing_the_support_lane_adds_one_pair()
	_check_choosing_the_combat_lane_adds_its_canonical_magnitude()
	_check_choosing_the_utility_lane_adds_its_canonical_magnitude()
	_check_only_the_selected_lane_moves()
	_check_one_root_seed_can_be_consumed_only_once()
	_check_two_root_seeds_that_compose_one_offer_are_independent()
	_check_the_masked_seeds_stay_distinct()
	_check_a_stale_support_offer_refuses_without_consuming()
	_check_every_absent_or_incoherent_argument_refuses_atomically()
	_check_a_passive_the_catalogue_refuses_or_miscategorises()
	_check_a_non_repeatable_passive_already_held_refuses()
	_check_a_repeatable_passive_taken_from_two_offers_counts_twice()
	_check_presentation_labels_cannot_change_the_transaction()
	_check_the_transaction_is_generic_and_unwired()
	_check_the_granted_identity_cannot_be_reached()

	_check_every_check_ran()

	print("")
	if _failures.is_empty():
		print("RIFT OFFER CHOICE VERIFICATION: PASS (%d checks)" % _checks)
		quit(0)
	else:
		for failure: String in _failures:
			printerr("  FAIL: %s" % failure)
		printerr("RIFT OFFER CHOICE VERIFICATION: %d FAILURE(S) of %d checks" % [
			_failures.size(), _checks,
		])
		quit(1)


# --- 1. The ledger ---------------------------------------------------------------

func _check_a_new_ledger_records_each_root_seed_once() -> void:
	print("")
	print("--- 1. A new ledger is empty, records each root seed once, and leaks nothing")

	var ledger: RiftConsumptionLedger = RiftConsumptionLedger.new()
	_expect(ledger.is_empty(), "a new ledger does not report itself empty")
	_expect(ledger.count() == 0, "a new ledger holds %d seeds" % ledger.count())
	_expect(ledger.consumed_seeds().is_empty(),
		"a new ledger reports the seeds %s" % _seeds_line(ledger))
	_expect(not ledger.has_consumed(0), "a new ledger claims to have consumed 0")
	_expect(ledger.describe() == "no offer consumed",
		"a new ledger describes itself as '%s'" % ledger.describe())

	## RECORDED ONCE, AND THE SECOND ATTEMPT IS REFUSED RATHER THAN IGNORED. The
	## answer must be a value a caller can read: a silent no-op is
	## indistinguishable from success at exactly the moment it matters.
	_expect(ledger.consume(LANE_SEED), "the first consumption of %d was refused" % LANE_SEED)
	_expect(ledger.has_consumed(LANE_SEED), "%d is not recorded as consumed" % LANE_SEED)
	_expect(ledger.count() == 1, "one consumption produced a count of %d" % ledger.count())
	_refusals += 1
	_expect(not ledger.consume(LANE_SEED),
		"the same root seed was consumed twice")
	_expect(ledger.count() == 1,
		"a refused consumption moved the count to %d" % ledger.count())

	## THE FULL SIGNED RANGE, INCLUDING THE TWO THE COMPOSITION MECHANISM MASKS
	## INTO ONE QUESTION. They are two entries here and check 8 proves that end to
	## end; this is the ledger's own half of it.
	_expect(ledger.consume(MASKED_LOW), "%d could not be consumed" % MASKED_LOW)
	_expect(ledger.consume(MASKED_HIGH), "%d could not be consumed" % MASKED_HIGH)
	_expect(ledger.consume(TWIN_SEED_A), "%d could not be consumed" % TWIN_SEED_A)
	_expect(ledger.count() == 4, "four consumptions produced a count of %d" % ledger.count())

	## A STABLE DIAGNOSTIC ORDER, WHICH IS WHY IT IS SORTED RATHER THAN IN
	## INSERTION ORDER: a diagnostic that changes when nothing changed is one a
	## reader stops trusting.
	var expected_order: String = "%d, %d, %d, %d" % [
		MASKED_LOW, LANE_SEED, TWIN_SEED_A, MASKED_HIGH,
	]
	_expect(_seeds_line(ledger) == expected_order,
		"the ledger reports %s, not %s" % [_seeds_line(ledger), expected_order])
	_expect(ledger.describe().begins_with("4 consumed:"),
		"the ledger describes itself as '%s'" % ledger.describe())

	## NOTHING LIVE EVER LEAVES. A `PackedInt64Array` is copied on assignment, so
	## a caller cannot reach the set through the value it was handed to read — and
	## that is asserted by mutating what was handed out rather than by trusting
	## the type.
	var handed_out: PackedInt64Array = ledger.consumed_seeds()
	handed_out.append(424242)
	handed_out.sort()
	_expect(ledger.count() == 4,
		"mutating the returned list moved the count to %d" % ledger.count())
	_expect(not ledger.has_consumed(424242),
		"mutating the returned list consumed a seed")
	_expect(_seeds_line(ledger) == expected_order,
		"mutating the returned list changed the ledger to %s" % _seeds_line(ledger))

	## THE DUPLICATE IS INDEPENDENT IN BOTH DIRECTIONS, because one direction
	## alone would miss a copy that shares its internals.
	var copy: RiftConsumptionLedger = ledger.duplicated()
	_expect(_ledger_snapshot(copy) == _ledger_snapshot(ledger),
		"the duplicate does not match: %s vs %s" % [
			_ledger_snapshot(copy), _ledger_snapshot(ledger),
		])
	_expect(copy.consume(TWIN_SEED_B), "the duplicate refused a fresh seed")
	_expect(not ledger.has_consumed(TWIN_SEED_B),
		"consuming in the duplicate consumed in the original")
	_expect(ledger.count() == 4,
		"consuming in the duplicate moved the original to %d" % ledger.count())
	_expect(ledger.consume(REPEAT_SEED_A), "the original refused a fresh seed")
	_expect(not copy.has_consumed(REPEAT_SEED_A),
		"consuming in the original consumed in the duplicate")
	_expect(copy.count() == 5, "the duplicate now holds %d" % copy.count())
	_expect(ledger.count() == 5, "the original now holds %d" % ledger.count())

	print("  a new ledger is empty; 1 seed recorded, 1 duplicate refused, %d recorded in all"
		% ledger.count())
	print("  the returned list is a copy and the duplicate is independent in both directions")
	_done("a_new_ledger_records_each_root_seed_once_and_hands_out_no_live_collection")


# --- 2. The support lane ------------------------------------------------------------

func _check_choosing_the_support_lane_adds_one_pair() -> void:
	print("")
	print("--- 2. Choosing the support lane adds exactly one pair and no passive")

	var offer: RiftOffer = _shipped_offer(LANE_SEED)
	_expect(offer.ok and offer.problem().is_empty(),
		"the fixture offer did not compose: %s" % offer.failure_reason)
	_expect(offer.skill_id == EXPECTED_SKILL and offer.support_id == EXPECTED_SUPPORT,
		"root seed %d offers %s -> %s" % [LANE_SEED, offer.skill_id, offer.support_id])

	var build: RiftRunBuild = RiftRunBuild.new()
	var ledger: RiftConsumptionLedger = RiftConsumptionLedger.new()
	var before_build: String = _snapshot(build)
	var before_ledger: String = _ledger_snapshot(ledger)

	var result: RiftOfferChoiceResult = RiftOfferChoice.choose(
		offer, RiftOffer.Lane.SUPPORT, build, ledger)
	_expect_success(result, "the support lane of root seed %d" % LANE_SEED)

	_expect(result.lane == RiftOffer.Lane.SUPPORT,
		"the result names lane %d" % result.lane)
	_expect(result.root_seed == LANE_SEED and result.root_seed_known,
		"the result names root seed %d (known %s)" % [result.root_seed, result.root_seed_known])
	_expect(" -> ".join(result.chosen_identity()) == "%s -> %s" % [EXPECTED_SKILL, EXPECTED_SUPPORT],
		"the result granted %s" % result.identity_line())

	## EXACTLY ONE PAIR.
	_expect(result.new_build.support_count() == 1,
		"the new build holds %d pairs" % result.new_build.support_count())
	_expect(result.new_build.has_support(EXPECTED_SKILL, EXPECTED_SUPPORT),
		"the new build does not hold the offered pair")
	_expect(", ".join(result.new_build.support_pairs()) == "%s -> %s" % [
			EXPECTED_SKILL, EXPECTED_SUPPORT,
		], "the new build holds %s" % ", ".join(result.new_build.support_pairs()))

	## AND NO PASSIVE CONTRIBUTION AT ALL — every declared stat, not a sample. A
	## zero that is only true for the one stat somebody thought to check is not a
	## proof that nothing was granted.
	_expect(result.new_build.passive_acquisitions() == 0,
		"the support lane granted %d passive acquisitions"
			% result.new_build.passive_acquisitions())
	_expect(result.new_build.acquired_card_ids().is_empty(),
		"the support lane granted the cards %s"
			% _ids_line(result.new_build.acquired_card_ids()))
	_expect(_nonzero_stats(result.new_build).is_empty(),
		"the support lane moved the stats %s" % _nonzero_stats(result.new_build))

	## AND NOTHING FROM THE TWO LANES THAT WERE NOT CHOSEN, named explicitly: the
	## same offer carried both, and this is the assertion that says they stayed
	## in it.
	_expect(result.new_build.acquisitions_for(offer.combat_card_id) == 0,
		"the combat card of the same offer was granted")
	_expect(result.new_build.acquisitions_for(offer.utility_card_id) == 0,
		"the utility card of the same offer was granted")

	## THE SEED IS SPENT, AND NOTHING ELSE IS.
	_expect(result.new_ledger.count() == 1,
		"the new ledger holds %d seeds" % result.new_ledger.count())
	_expect(result.new_ledger.has_consumed(LANE_SEED),
		"the new ledger did not record root seed %d" % LANE_SEED)

	## THE SUPPLIED VALUES ARE UNTOUCHED, WHOLE.
	_expect(_snapshot(build) == before_build,
		"the supplied build changed:\n    before %s\n    after  %s" % [
			before_build, _snapshot(build),
		])
	_expect(_ledger_snapshot(ledger) == before_ledger,
		"the supplied ledger changed: %s -> %s" % [
			before_ledger, _ledger_snapshot(ledger),
		])

	print("  %s; the supplied build and ledger are untouched" % result.describe())
	_done("choosing_the_support_lane_adds_one_pair_and_no_passive_contribution")


# --- 3 and 4. The two passive lanes ------------------------------------------------

func _check_choosing_the_combat_lane_adds_its_canonical_magnitude() -> void:
	print("")
	print("--- 3. Choosing the Combat and Defence lane adds exactly its canonical magnitude")
	_prove_passive_lane(
		RiftOffer.Lane.COMBAT_DEFENCE, EXPECTED_COMBAT_CARD,
		EXPECTED_COMBAT_STAT, EXPECTED_COMBAT_MAGNITUDE)
	_done("choosing_the_combat_lane_adds_exactly_its_canonical_magnitude")


func _check_choosing_the_utility_lane_adds_its_canonical_magnitude() -> void:
	print("")
	print("--- 4. Choosing the Utility lane adds exactly its canonical magnitude")
	_prove_passive_lane(
		RiftOffer.Lane.UTILITY, EXPECTED_UTILITY_CARD,
		EXPECTED_UTILITY_STAT, EXPECTED_UTILITY_MAGNITUDE)
	_done("choosing_the_utility_lane_adds_exactly_its_canonical_magnitude")


## One passive lane, proved the same way for both: exactly its own canonical
## magnitude on exactly its own stat, no support pair, and nothing whatsoever
## from the other passive lane of the same offer.
func _prove_passive_lane(
	lane: int, expected_card: StringName, expected_stat: StringName, expected_magnitude: float
) -> void:
	var offer: RiftOffer = _shipped_offer(LANE_SEED)
	_expect(offer.ok and offer.problem().is_empty(),
		"the fixture offer did not compose: %s" % offer.failure_reason)
	var offered: PackedStringArray = offer.identity_for(lane)
	_expect(offered.size() == 1 and StringName(offered[0]) == expected_card,
		"the %s lane of root seed %d offers %s" % [
			RiftOffer.lane_label(lane), LANE_SEED, " -> ".join(offered),
		])

	var build: RiftRunBuild = RiftRunBuild.new()
	var ledger: RiftConsumptionLedger = RiftConsumptionLedger.new()
	var before_build: String = _snapshot(build)
	var before_ledger: String = _ledger_snapshot(ledger)

	var result: RiftOfferChoiceResult = RiftOfferChoice.choose(offer, lane, build, ledger)
	_expect_success(result, "the %s lane of root seed %d" % [
		RiftOffer.lane_label(lane), LANE_SEED,
	])
	_expect(result.lane == lane, "the result names lane %d, not %d" % [result.lane, lane])
	_expect(" -> ".join(result.chosen_identity()) == String(expected_card),
		"the result granted %s" % result.identity_line())

	## THE CANONICAL MAGNITUDE, EXACTLY, COMPARED WITH `==`. Not a tolerance: the
	## accepted accumulator adds, and an additive answer that is only nearly right
	## is a rounding rule nobody wrote down.
	_expect(result.new_build.acquisitions_for(expected_card) == 1,
		"%s was acquired %d times" % [
			expected_card, result.new_build.acquisitions_for(expected_card),
		])
	_expect(result.new_build.total_for(expected_stat) == expected_magnitude,
		"%s came to %s, not %s" % [
			expected_stat, _exact(result.new_build.total_for(expected_stat)),
			_exact(expected_magnitude),
		])
	_expect(result.new_build.contribution_count_for(expected_stat) == 1,
		"%s received %d contributions" % [
			expected_stat, result.new_build.contribution_count_for(expected_stat),
		])

	## NO SUPPORT, AND NOTHING FROM THE OTHER PASSIVE LANE OF THE SAME OFFER.
	_expect(result.new_build.support_count() == 0,
		"a passive lane granted %d support pairs" % result.new_build.support_count())
	_expect(result.new_build.support_pairs().is_empty(),
		"a passive lane granted the pairs %s" % ", ".join(result.new_build.support_pairs()))
	var other_lane: int = RiftOffer.Lane.UTILITY if lane == RiftOffer.Lane.COMBAT_DEFENCE \
		else RiftOffer.Lane.COMBAT_DEFENCE
	var other_card: StringName = StringName(offer.identity_for(other_lane)[0])
	_expect(result.new_build.acquisitions_for(other_card) == 0,
		"the %s lane also granted %s" % [RiftOffer.lane_label(lane), other_card])
	_expect(result.new_build.passive_acquisitions() == 1,
		"one passive lane produced %d acquisitions" % result.new_build.passive_acquisitions())

	## AND EVERY OTHER STAT IS UNTOUCHED, enumerated rather than sampled.
	var moved: PackedStringArray = PackedStringArray()
	for stat_id: StringName in PlayerStats.ALL:
		if stat_id == expected_stat:
			continue
		if result.new_build.total_for(stat_id) != 0.0 \
				or result.new_build.contribution_count_for(stat_id) != 0:
			moved.append("%s=%s(%d)" % [
				stat_id, _exact(result.new_build.total_for(stat_id)),
				result.new_build.contribution_count_for(stat_id),
			])
	_expect(moved.is_empty(), "the %s lane also moved %s" % [
		RiftOffer.lane_label(lane), ", ".join(moved),
	])

	_expect(result.new_ledger.count() == 1 and result.new_ledger.has_consumed(LANE_SEED),
		"the new ledger reads %s" % _ledger_snapshot(result.new_ledger))
	_expect(_snapshot(build) == before_build,
		"the supplied build changed:\n    before %s\n    after  %s" % [
			before_build, _snapshot(build),
		])
	_expect(_ledger_snapshot(ledger) == before_ledger,
		"the supplied ledger changed: %s -> %s" % [
			before_ledger, _ledger_snapshot(ledger),
		])

	print("  %s" % result.describe())
	print("  %s +%s from %s alone; %d other stats untouched" % [
		expected_stat, _exact(expected_magnitude), expected_card, PlayerStats.ALL.size() - 1,
	])


# --- 5. One lane moves; the returned values are independent copies -------------------

func _check_only_the_selected_lane_moves() -> void:
	print("")
	print("--- 5. Only the selected lane moves, and the returned values are independent")

	var offer: RiftOffer = _shipped_offer(LANE_SEED)
	_expect(offer.ok and offer.problem().is_empty(),
		"the fixture offer did not compose: %s" % offer.failure_reason)

	## THREE CHOICES FROM ONE OFFER AND ONE STARTING STATE, so the only thing that
	## differs between the three outcomes is the lane that was asked for.
	var build: RiftRunBuild = _seeded_build()
	var ledger: RiftConsumptionLedger = _seeded_ledger()
	var before_build: String = _snapshot(build)
	var before_ledger: String = _ledger_snapshot(ledger)

	var outcomes: Dictionary = {}
	for lane: int in RiftOffer.LANE_ORDER:
		var result: RiftOfferChoiceResult = RiftOfferChoice.choose(offer, lane, build, ledger)
		_expect_success(result, "lane %d from the shared starting state" % lane)
		outcomes[lane] = _snapshot(result.new_build)

	## THE THREE OUTCOMES DIFFER FROM EACH OTHER AND FROM THE START. Compared as
	## COMPLETE snapshots: a lane that granted a second lane's effect as well
	## would still differ from the start, and only a whole-state comparison sees
	## it.
	var distinct: Dictionary = {}
	for lane: int in RiftOffer.LANE_ORDER:
		distinct[String(outcomes[lane])] = true
		_expect(String(outcomes[lane]) != before_build,
			"lane %d changed nothing at all" % lane)
	_expect(distinct.size() == RiftOffer.LANE_ORDER.size(),
		"the three lanes produced %d distinct builds, not %d" % [
			distinct.size(), RiftOffer.LANE_ORDER.size(),
		])

	## AND THE SUPPLIED VALUES SURVIVED ALL THREE, which is the claim the three
	## calls above exist to make: a transaction that mutated what it was given
	## would have left the second and third calls looking at a different state.
	_expect(_snapshot(build) == before_build,
		"the supplied build changed across three choices:\n    before %s\n    after  %s" % [
			before_build, _snapshot(build),
		])
	_expect(_ledger_snapshot(ledger) == before_ledger,
		"the supplied ledger changed across three choices: %s -> %s" % [
			before_ledger, _ledger_snapshot(ledger),
		])

	## INDEPENDENCE, PROVED IN BOTH DIRECTIONS ON BOTH VALUES. One direction alone
	## would miss a copy that shares its internals.
	var result: RiftOfferChoiceResult = RiftOfferChoice.choose(
		offer, RiftOffer.Lane.COMBAT_DEFENCE, build, ledger)
	_expect_success(result, "the choice whose copies are about to be mutated")

	var returned_build: String = _snapshot(result.new_build)
	var returned_ledger: String = _ledger_snapshot(result.new_ledger)

	_expect(result.new_build.acquire_passive_card(_shipped(EXPECTED_REPEAT_CARD)).is_empty(),
		"the returned build refused a card while proving independence")
	_expect(result.new_ledger.consume(TWIN_SEED_A),
		"the returned ledger refused a fresh seed while proving independence")
	_expect(_snapshot(build) == before_build,
		"mutating the returned build changed the supplied one")
	_expect(_ledger_snapshot(ledger) == before_ledger,
		"mutating the returned ledger changed the supplied one")

	var after_mutating_returned_build: String = _snapshot(result.new_build)
	var after_mutating_returned_ledger: String = _ledger_snapshot(result.new_ledger)
	_expect(build.acquire_passive_card(_shipped(EXPECTED_UTILITY_CARD)).is_empty(),
		"the supplied build refused a card while proving independence")
	_expect(ledger.consume(TWIN_SEED_B),
		"the supplied ledger refused a fresh seed while proving independence")
	_expect(_snapshot(result.new_build) == after_mutating_returned_build,
		"mutating the supplied build changed the returned one")
	_expect(_ledger_snapshot(result.new_ledger) == after_mutating_returned_ledger,
		"mutating the supplied ledger changed the returned one")

	print("  3 lanes, 3 distinct builds from one starting state; the supplied values never moved")
	print("  the returned build and ledger are independent in both directions (%s | %s)" % [
		returned_build.substr(0, 48), returned_ledger,
	])
	_done("only_the_selected_lane_moves_and_the_returned_values_are_independent_copies")


# --- 6. One root seed, once ---------------------------------------------------------

func _check_one_root_seed_can_be_consumed_only_once() -> void:
	print("")
	print("--- 6. One root seed can be consumed only once, whatever it is asked with")

	var offer: RiftOffer = _shipped_offer(LANE_SEED)
	var first: RiftOfferChoiceResult = RiftOfferChoice.choose(
		offer, RiftOffer.Lane.COMBAT_DEFENCE, _seeded_build(), _seeded_ledger())
	_expect_success(first, "the first consumption of root seed %d" % LANE_SEED)

	var build: RiftRunBuild = first.new_build
	var ledger: RiftConsumptionLedger = first.new_ledger

	## A build that ALSO already holds the pair that offer's support lane offers,
	## so the offer below carries two faults at once. Built here rather than at
	## the assertion so the assertion reads as the one question it asks.
	var spent_and_held_build: RiftRunBuild = build.duplicated()
	_expect(spent_and_held_build.acquire_support(
			offer.skill_id, offer.support_id).is_empty(),
		"the doubly-faulted build could not acquire the pair the offer offers")

	## THE SAME OFFER OBJECT, A DIFFERENT LANE. A run that could take a second
	## lane of an offer it already spent would be taking two rewards from one
	## offer, which is the whole reason this ledger exists.
	_expect_atomic_refusal(
		RiftOfferChoice.choose(offer, RiftOffer.Lane.UTILITY, build, ledger),
		build, ledger, "the utility lane of an offer already spent")

	## A FRESHLY COMPOSED OFFER FROM THE SAME SEED. The identity is the seed, not
	## the object: an offer recomposed after the fact is the same offer.
	var recomposed: RiftOffer = _shipped_offer(LANE_SEED)
	_expect(recomposed != offer, "the recomposed offer is the same object")
	_expect(recomposed.offer_line() == offer.offer_line(),
		"the recomposed offer differs: %s vs %s" % [
			recomposed.offer_line(), offer.offer_line(),
		])
	_expect_atomic_refusal(
		RiftOfferChoice.choose(recomposed, RiftOffer.Lane.COMBAT_DEFENCE, build, ledger),
		build, ledger, "a freshly composed offer from a spent root seed")

	## AND THE SAME SEED COMPOSED AGAINST DIFFERENT RECORDS. Reusing one root seed
	## with changed pools is still reuse: the ledger is asked about the seed and
	## never about what the seed happened to produce.
	var reweighted: RiftOffer = RiftOfferComposition.compose(
		SkillSupportCatalogue.skill_profiles(),
		SkillSupportCatalogue.support_definitions(),
		null, _renamed_cards(), LANE_SEED)
	_expect(reweighted.ok and reweighted.problem().is_empty(),
		"the offer composed against renamed records did not compose")
	_expect_atomic_refusal(
		RiftOfferChoice.choose(reweighted, RiftOffer.Lane.UTILITY, build, ledger),
		build, ledger, "a spent root seed composed against different records")

	## AND THE REFUSAL SAYS SO, naming the seed a caller must go and look at.
	var refusal: RiftOfferChoiceResult = RiftOfferChoice.choose(
		offer, RiftOffer.Lane.SUPPORT, build, ledger)
	_expect(refusal.failure_reason.contains("already been consumed")
			and refusal.failure_reason.contains(str(LANE_SEED)),
		"the refusal reads '%s'" % refusal.failure_reason)
	_expect(refusal.root_seed == LANE_SEED and refusal.root_seed_known,
		"the refusal echoes root seed %d" % refusal.root_seed)
	_expect(refusal.lane == RiftOffer.Lane.SUPPORT,
		"the refusal echoes lane %d" % refusal.lane)
	_refusals += 1

	## AND THE ORDER OF THE GATES IS OBSERVABLE, WHICH IS WHY THIS ASSERTION
	## EXISTS AT ALL. Deleting the ledger gate above does NOT let a seed be spent
	## twice — the ledger refuses its own duplicate, so the transaction still
	## fails — and a suite that only proved "the second attempt is refused" would
	## therefore be green with the gate removed. What the gate actually decides is
	## WHICH fault a caller is told about when there is more than one, and that is
	## a real, reachable difference: an offer whose seed is spent AND whose
	## support pair is already held must report the spent seed, because the seed
	## is consulted before anything is staged. Told "stale" instead, a caller
	## would re-offer something that can never be taken.
	var doubly_faulted: RiftOfferChoiceResult = RiftOfferChoice.choose(
		offer, RiftOffer.Lane.SUPPORT, spent_and_held_build, ledger)
	_expect_refused(doubly_faulted, "an offer that is both spent and stale")
	_expect(doubly_faulted.failure_reason.contains("already been consumed"),
		"an offer that is both spent and stale reported '%s' rather than the spent seed"
			% doubly_faulted.failure_reason)
	_expect(not doubly_faulted.failure_reason.contains("stale"),
		"the spent-seed gate ran after the lane was staged: '%s'"
			% doubly_faulted.failure_reason)

	## A DIFFERENT SEED IS STILL SPENDABLE AFTERWARDS, so the refusals above
	## refused this offer rather than sealing the ledger.
	var later: RiftOfferChoiceResult = RiftOfferChoice.choose(
		_shipped_offer(TWIN_SEED_A), RiftOffer.Lane.COMBAT_DEFENCE, build, ledger)
	_expect_success(later, "a different root seed after four refusals")
	_expect(later.new_ledger.count() == ledger.count() + 1,
		"the ledger moved from %d to %d" % [ledger.count(), later.new_ledger.count()])

	print("  4 attempts on a spent root seed refused; the build and ledger never moved")
	print("  a different root seed is still spendable afterwards")
	_done("one_root_seed_can_be_consumed_only_once_whatever_it_is_asked_with")


# --- 7. Two seeds, one composition ---------------------------------------------------

func _check_two_root_seeds_that_compose_one_offer_are_independent() -> void:
	print("")
	print("--- 7. Two root seeds that compose the same offer are independently consumable")

	var first: RiftOffer = _shipped_offer(TWIN_SEED_A)
	var second: RiftOffer = _shipped_offer(TWIN_SEED_B)
	_expect(first.ok and second.ok, "one of the twin offers did not compose")
	_expect(TWIN_SEED_A != TWIN_SEED_B, "the twin seeds are the same value")

	## THE PREMISE, ASSERTED RATHER THAN ASSUMED: these two offers really do
	## present the same four identities. Without this the check below would prove
	## only that two unrelated offers can both be taken.
	_expect(first.offer_line() == second.offer_line(),
		"the twin offers differ: %s vs %s" % [first.offer_line(), second.offer_line()])
	_expect(first.root_seed != second.root_seed,
		"the twin offers echo the same root seed")

	var build: RiftRunBuild = RiftRunBuild.new()
	var ledger: RiftConsumptionLedger = RiftConsumptionLedger.new()

	var a: RiftOfferChoiceResult = RiftOfferChoice.choose(
		first, RiftOffer.Lane.COMBAT_DEFENCE, build, ledger)
	_expect_success(a, "the first twin")
	var b: RiftOfferChoiceResult = RiftOfferChoice.choose(
		second, RiftOffer.Lane.COMBAT_DEFENCE, a.new_build, a.new_ledger)
	_expect_success(b, "the second twin, which offers exactly what the first did")

	_expect(b.new_ledger.count() == 2,
		"two twin offers produced a ledger of %d" % b.new_ledger.count())
	_expect(b.new_ledger.has_consumed(TWIN_SEED_A) and b.new_ledger.has_consumed(TWIN_SEED_B),
		"the ledger reads %s" % _ledger_snapshot(b.new_ledger))
	_expect(b.new_build.acquisitions_for(first.combat_card_id) == 2,
		"%s was acquired %d times" % [
			first.combat_card_id, b.new_build.acquisitions_for(first.combat_card_id),
		])

	print("  root seeds %d and %d both offer '%s' and are both consumable" % [
		TWIN_SEED_A, TWIN_SEED_B, first.offer_line(),
	])
	_done("two_root_seeds_that_compose_one_offer_are_independently_consumable")


# --- 8. The masked pair -----------------------------------------------------------------

func _check_the_masked_seeds_stay_distinct() -> void:
	print("")
	print("--- 8. The two seeds the composer masks into one question stay two identities")

	var low: RiftOffer = _shipped_offer(MASKED_LOW)
	var high: RiftOffer = _shipped_offer(MASKED_HIGH)
	_expect(low.ok and high.ok, "one of the masked offers did not compose")
	_expect(MASKED_LOW != MASKED_HIGH, "the two masked seeds are the same value")

	## THE PREMISE: the composition mechanism really does mask these two into ONE
	## question — the same three lane seeds and the same four identities. Without
	## this the check below would prove nothing about masking at all.
	_expect(low.seed_line() == high.seed_line(),
		"the masked offers derive different lane seeds: %s vs %s" % [
			low.seed_line(), high.seed_line(),
		])
	_expect(low.offer_line() == high.offer_line(),
		"the masked offers present different identities: %s vs %s" % [
			low.offer_line(), high.offer_line(),
		])
	_expect(low.root_seed != high.root_seed,
		"the masked offers echo the same root seed")

	## AND THEY ARE STILL TWO OFFERS. Masking here would silently make the second
	## unspendable, and a player who never saw it would never know why.
	var first: RiftOfferChoiceResult = RiftOfferChoice.choose(
		low, RiftOffer.Lane.COMBAT_DEFENCE, RiftRunBuild.new(), RiftConsumptionLedger.new())
	_expect_success(first, "the offer from root seed %d" % MASKED_LOW)
	_expect(not first.new_ledger.has_consumed(MASKED_HIGH),
		"consuming %d recorded %d as well" % [MASKED_LOW, MASKED_HIGH])

	var second: RiftOfferChoiceResult = RiftOfferChoice.choose(
		high, RiftOffer.Lane.COMBAT_DEFENCE, first.new_build, first.new_ledger)
	_expect_success(second, "the offer from root seed %d, which composes identically" % MASKED_HIGH)
	_expect(second.new_ledger.count() == 2,
		"both masked seeds produced a ledger of %d" % second.new_ledger.count())
	_expect(second.new_ledger.has_consumed(MASKED_LOW)
			and second.new_ledger.has_consumed(MASKED_HIGH),
		"the ledger reads %s" % _ledger_snapshot(second.new_ledger))
	_expect(second.new_build.acquisitions_for(low.combat_card_id) == 2,
		"%s was acquired %d times" % [
			low.combat_card_id, second.new_build.acquisitions_for(low.combat_card_id),
		])

	## AND THE OTHER ORDER, because a set keyed on a value that collided would
	## fail in exactly one direction if the two keys were folded asymmetrically.
	var reversed_first: RiftOfferChoiceResult = RiftOfferChoice.choose(
		high, RiftOffer.Lane.UTILITY, RiftRunBuild.new(), RiftConsumptionLedger.new())
	_expect_success(reversed_first, "the high seed taken first")
	var reversed_second: RiftOfferChoiceResult = RiftOfferChoice.choose(
		low, RiftOffer.Lane.UTILITY, reversed_first.new_build, reversed_first.new_ledger)
	_expect_success(reversed_second, "the low seed taken second")
	_expect(reversed_second.new_ledger.count() == 2,
		"the reversed order produced a ledger of %d" % reversed_second.new_ledger.count())

	print("  %d and %d compose one question (%s) and remain two consumption identities" % [
		MASKED_LOW, MASKED_HIGH, low.seed_line(),
	])
	_done("the_masked_seeds_stay_distinct_consumption_identities")


# --- 9. A stale support offer -------------------------------------------------------------

func _check_a_stale_support_offer_refuses_without_consuming() -> void:
	print("")
	print("--- 9. A support offer whose pair is already held refuses and consumes nothing")

	var first: RiftOfferChoiceResult = RiftOfferChoice.choose(
		_shipped_offer(LANE_SEED), RiftOffer.Lane.SUPPORT,
		RiftRunBuild.new(), RiftConsumptionLedger.new())
	_expect_success(first, "the support lane that establishes the held pair")
	_expect(first.new_build.has_support(EXPECTED_SKILL, EXPECTED_SUPPORT),
		"the pair was not established")

	var stale: RiftOffer = _shipped_offer(STALE_SEED)
	_expect(stale.ok and stale.problem().is_empty(),
		"the stale-offer fixture did not compose")
	_expect(stale.skill_id == EXPECTED_SKILL and stale.support_id == EXPECTED_SUPPORT,
		"root seed %d offers %s -> %s, which is not the held pair" % [
			STALE_SEED, stale.skill_id, stale.support_id,
		])
	_expect(not first.new_ledger.has_consumed(STALE_SEED),
		"the stale offer's root seed was already consumed, so this proves nothing")

	var refusal: RiftOfferChoiceResult = _expect_atomic_refusal(
		RiftOfferChoice.choose(
			stale, RiftOffer.Lane.SUPPORT, first.new_build, first.new_ledger),
		first.new_build, first.new_ledger, "a support offer whose pair is already held")
	_expect(refusal.failure_reason.contains("stale")
			and refusal.failure_reason.contains(String(EXPECTED_SKILL))
			and refusal.failure_reason.contains(String(EXPECTED_SUPPORT)),
		"the refusal reads '%s'" % refusal.failure_reason)

	## THE SEED IS EXPLICITLY UNSPENT, which is the half of atomicity a build
	## comparison alone cannot see: an offer that was refused must still be there
	## to be taken a different way.
	_expect(not first.new_ledger.has_consumed(STALE_SEED),
		"a refused stale offer consumed root seed %d" % STALE_SEED)

	## AND IT REALLY IS STILL TAKEABLE — the same offer, a lane that is not stale.
	var recovered: RiftOfferChoiceResult = RiftOfferChoice.choose(
		stale, RiftOffer.Lane.COMBAT_DEFENCE, first.new_build, first.new_ledger)
	_expect_success(recovered, "another lane of the offer whose support lane was stale")
	_expect(recovered.new_ledger.has_consumed(STALE_SEED),
		"the recovered choice did not consume root seed %d" % STALE_SEED)

	print("  a stale support offer refuses, spends nothing, and its other lanes remain takeable")
	_done("a_stale_support_offer_refuses_without_consuming_its_seed")


# --- 10. Absent and incoherent arguments -----------------------------------------------

func _check_every_absent_or_incoherent_argument_refuses_atomically() -> void:
	print("")
	print("--- 10. Every absent or incoherent argument refuses, atomically and by name")

	var offer: RiftOffer = _shipped_offer(LANE_SEED)
	_expect(offer.ok and offer.problem().is_empty(), "the fixture offer did not compose")

	var build: RiftRunBuild = _seeded_build()
	var ledger: RiftConsumptionLedger = _seeded_ledger()

	## A NULL OFFER. The one refusal that cannot echo a root seed, because there
	## is nowhere to read one from — and every integer is a legal seed, so the
	## absence is carried as its own fact rather than as a sentinel.
	var no_offer: RiftOfferChoiceResult = _expect_atomic_refusal(
		RiftOfferChoice.choose(null, RiftOffer.Lane.SUPPORT, build, ledger),
		build, ledger, "a null offer")
	_expect(not no_offer.root_seed_known,
		"a refusal with no offer claims to know root seed %d" % no_offer.root_seed)
	_expect(no_offer.lane == RiftOffer.Lane.SUPPORT,
		"a refusal with no offer echoes lane %d" % no_offer.lane)
	_expect(no_offer.failure_reason.contains("offer"),
		"the refusal reads '%s'" % no_offer.failure_reason)

	## A REFUSED OFFER — a real one, produced by a real condition rather than
	## fabricated: a run offered from a support catalogue with nothing in it.
	##
	## THE CONDITION MOVED AND THE MOVE IS RECORDED RATHER THAN QUIETLY EDITED.
	## Holding every eligible pair used to be what emptied the support lane, and
	## the accepted composition mechanism refused. Since Foundation F3 that
	## composes ONE FURTHER RANK of a held pair instead, so the fixture below
	## still holds both shipped pairs — proving that holding them is no longer the
	## cause — and the refusal now comes from there being no support definition at
	## all, which the accepted mechanism still refuses at the Support lane. This
	## transaction is unchanged in every respect: it is handed an offer that did
	## not compose, exactly as before.
	var exhausted: AcquiredSupports = AcquiredSupports.new()
	_expect(exhausted.acquire(EXPECTED_SKILL, &"reaching_edge"), "the first pair was refused")
	_expect(exhausted.acquire(EXPECTED_SKILL, &"sweeping_edge"), "the second pair was refused")
	var no_supports: Array[SupportDefinition] = []
	var refused_offer: RiftOffer = RiftOfferComposition.compose(
		SkillSupportCatalogue.skill_profiles(), no_supports,
		exhausted, PassiveCardCatalogue.records(), LANE_SEED)
	_expect(not refused_offer.ok, "the composition against an empty support pool succeeded")
	_expect(refused_offer.problem().is_empty(),
		"the refused offer is itself incoherent: %s" % refused_offer.problem())
	var not_composed: RiftOfferChoiceResult = _expect_atomic_refusal(
		RiftOfferChoice.choose(refused_offer, RiftOffer.Lane.COMBAT_DEFENCE, build, ledger),
		build, ledger, "an offer that did not compose")
	_expect(not_composed.failure_reason.contains("did not compose"),
		"the refusal reads '%s'" % not_composed.failure_reason)

	## A DEFAULT-CONSTRUCTED OFFER. It is not `ok` and carries no reason at all,
	## which is exactly the case a refusal that quoted an empty string would
	## report as a blank.
	var blank: RiftOffer = RiftOffer.new()
	_expect(not blank.ok and blank.failure_reason.is_empty(),
		"a default-constructed offer is not the blank this check needs")
	var blank_refusal: RiftOfferChoiceResult = _expect_atomic_refusal(
		RiftOfferChoice.choose(blank, RiftOffer.Lane.UTILITY, build, ledger),
		build, ledger, "a default-constructed offer")
	_expect(blank_refusal.failure_reason.contains("no reason stated"),
		"the refusal reads '%s'" % blank_refusal.failure_reason)

	## AN INTERNALLY INCOHERENT OFFER: one that claims to have succeeded while
	## carrying no lane at all. It passes the `ok` gate and is caught by the
	## coherence gate, which is the only thing between a caller and an offer that
	## says yes and means nothing.
	var incoherent: RiftOffer = RiftOffer.new()
	incoherent.ok = true
	_expect(not incoherent.problem().is_empty(),
		"the fabricated incoherent offer reports itself coherent")
	var incoherent_refusal: RiftOfferChoiceResult = _expect_atomic_refusal(
		RiftOfferChoice.choose(incoherent, RiftOffer.Lane.SUPPORT, build, ledger),
		build, ledger, "an offer that claims success while carrying no lane")
	_expect(incoherent_refusal.failure_reason.contains("not internally coherent")
			and incoherent_refusal.failure_reason.contains(incoherent.problem()),
		"the refusal reads '%s' rather than quoting '%s'" % [
			incoherent_refusal.failure_reason, incoherent.problem(),
		])

	## A LANE THE OFFER DOES NOT CARRY. One test answers both halves of the
	## contract: a coherent offer carries exactly the three declared lanes, so
	## "not carried" and "not declared" are the same question and cannot be
	## answered differently.
	for absent_lane: int in [UNDECLARED_LANE, RiftOffer.UNRESOLVED_LANE]:
		var lane_refusal: RiftOfferChoiceResult = _expect_atomic_refusal(
			RiftOfferChoice.choose(offer, absent_lane, build, ledger),
			build, ledger, "lane %d, which the offer does not carry" % absent_lane)
		_expect(lane_refusal.lane == absent_lane,
			"the refusal echoes lane %d rather than the %d it was asked for" % [
				lane_refusal.lane, absent_lane,
			])
		_expect(lane_refusal.failure_reason.contains(str(absent_lane)),
			"the refusal reads '%s'" % lane_refusal.failure_reason)
		_expect(lane_refusal.root_seed == LANE_SEED and lane_refusal.root_seed_known,
			"the refusal echoes root seed %d" % lane_refusal.root_seed)

	## AND THE THREE DECLARED LANES REALLY ARE ALL CARRIED, which is what makes
	## the single test above equivalent to both halves rather than only to one.
	for declared: int in RiftOffer.LANE_ORDER:
		_expect(offer.lane_order().has(declared),
			"a coherent offer does not carry declared lane %d" % declared)

	## A NULL BUILD AND A NULL LEDGER. Both refuse, and the ledger the caller
	## still holds is untouched — which is the only observable half of "nothing
	## happened" when one of the two values did not exist.
	var no_build: RiftOfferChoiceResult = RiftOfferChoice.choose(
		offer, RiftOffer.Lane.SUPPORT, null, ledger)
	_expect_refused(no_build, "a null run build")
	_expect(no_build.failure_reason.contains("run build"),
		"the refusal reads '%s'" % no_build.failure_reason)
	_expect(_ledger_snapshot(ledger) == _ledger_snapshot(_seeded_ledger()),
		"a refusal for a null build changed the ledger")

	var no_ledger: RiftOfferChoiceResult = RiftOfferChoice.choose(
		offer, RiftOffer.Lane.SUPPORT, build, null)
	_expect_refused(no_ledger, "a null consumption ledger")
	_expect(no_ledger.failure_reason.contains("ledger"),
		"the refusal reads '%s'" % no_ledger.failure_reason)
	_expect(_snapshot(build) == _snapshot(_seeded_build()),
		"a refusal for a null ledger changed the build")

	## AND THE FIXTURE STILL WORKS AFTERWARDS, so the eight refusals above refused
	## their own attempts rather than breaking the transaction.
	_expect_success(
		RiftOfferChoice.choose(offer, RiftOffer.Lane.SUPPORT, build, ledger),
		"a well-formed choice after eight refusals")

	print("  8 absent or incoherent arguments refused; the supplied build and ledger never moved")
	_done("every_absent_or_incoherent_argument_refuses_atomically")


# --- 11. The catalogue is the authority ------------------------------------------------

func _check_a_passive_the_catalogue_refuses_or_miscategorises() -> void:
	print("")
	print("--- 11. A passive the catalogue does not hold, or holds in another category, refuses")

	var build: RiftRunBuild = _seeded_build()
	var ledger: RiftConsumptionLedger = _seeded_ledger()

	## AN OFFER COMPOSED AGAINST RECORDS THE CATALOGUE HAS NEVER HEARD OF. The
	## offer itself is perfectly coherent — asserted — so the refusal below is
	## this transaction's rather than the composer's.
	var unknown: RiftOffer = _offer_from_cards(_unknown_id_cards(), LANE_SEED)
	_expect(unknown.ok and unknown.problem().is_empty(),
		"the unknown-id offer did not compose: %s" % unknown.failure_reason)
	for lane: int in [RiftOffer.Lane.COMBAT_DEFENCE, RiftOffer.Lane.UTILITY]:
		var offered: StringName = StringName(unknown.identity_for(lane)[0])
		_expect(not PassiveCardCatalogue.is_known(offered),
			"%s is in the canonical catalogue, so this proves nothing" % offered)
		var refusal: RiftOfferChoiceResult = _expect_atomic_refusal(
			RiftOfferChoice.choose(unknown, lane, build, ledger),
			build, ledger, "a %s card the catalogue does not hold" % RiftOffer.lane_label(lane))
		_expect(refusal.failure_reason.contains(String(offered))
				and refusal.failure_reason.contains("catalogue"),
			"the refusal reads '%s'" % refusal.failure_reason)

	## A CANONICAL ID OFFERED IN THE WRONG LANE, WHICH IS THE SHARPER CASE. The
	## record the offer was composed from declares a Combat and Defence stat; the
	## record the CATALOGUE holds for that same id is a Utility card. The stable
	## id is the choice authority, so the canonical record wins and the lane
	## refuses it — and, just as importantly, the fabricated record's magnitude
	## never reaches the build.
	var miscategorised: Array = [
		[RiftOffer.Lane.COMBAT_DEFENCE, CANONICAL_UTILITY_ID, _combat_lane_holds_a_utility_id()],
		[RiftOffer.Lane.UTILITY, CANONICAL_COMBAT_ID, _utility_lane_holds_a_combat_id()],
	]
	for row: Array in miscategorised:
		var lane: int = int(row[0])
		var canonical_id: StringName = row[1]
		var cards: Array[PassiveCardDefinition] = row[2]
		var offer: RiftOffer = _offer_from_cards(cards, LANE_SEED)
		_expect(offer.ok and offer.problem().is_empty(),
			"the miscategorised offer did not compose: %s" % offer.failure_reason)
		_expect(StringName(offer.identity_for(lane)[0]) == canonical_id,
			"the %s lane offers %s, not %s" % [
				RiftOffer.lane_label(lane), " -> ".join(offer.identity_for(lane)), canonical_id,
			])
		var canonical: PassiveCardDefinition = PassiveCardCatalogue.record(canonical_id)
		_expect(canonical != null and canonical.problem().is_empty(),
			"the canonical record for %s is missing or invalid" % canonical_id)
		_expect(canonical.category() != RiftOffer.category_for_lane(lane),
			"the canonical %s already belongs to the %s lane, so this proves nothing" % [
				canonical_id, RiftOffer.lane_label(lane),
			])
		var refusal: RiftOfferChoiceResult = _expect_atomic_refusal(
			RiftOfferChoice.choose(offer, lane, build, ledger),
			build, ledger,
			"the canonical %s offered from the %s lane" % [
				canonical_id, RiftOffer.lane_label(lane),
			])
		_expect(refusal.failure_reason.contains(String(canonical_id))
				and refusal.failure_reason.contains("category"),
			"the refusal reads '%s'" % refusal.failure_reason)
		_expect(build.acquisitions_for(canonical_id) == 0,
			"the miscategorised card was acquired anyway")

	print("  2 unknown ids and 2 canonical ids offered from the wrong lane all refused")
	print("  the supplied build and ledger never moved and nothing was acquired")
	_done("a_passive_the_catalogue_refuses_or_miscategorises_refuses_atomically")


# --- 12. A once-only passive already held ---------------------------------------------

func _check_a_non_repeatable_passive_already_held_refuses() -> void:
	print("")
	print("--- 12. A passive this run already holds as once-only refuses and consumes nothing")

	## FIRST, THE RULE ITSELF, PROVED WHERE IT LIVES. The accepted run-build state
	## owns "not repeatable and already acquired", and a test-only record is the
	## only way to reach that sentence at all — which is a fact about the shipped
	## catalogue rather than about this transaction, and is asserted as one below.
	var direct: RiftRunBuild = RiftRunBuild.new()
	var once_only: PassiveCardDefinition = _card(
		&"zz_probe_sealed", "Probe Sealed", PlayerStats.MAXIMUM_LIFE,
		PROBE_MAGNITUDE, PROBE_WEIGHT, false)
	_expect(once_only.problem().is_empty(),
		"the once-only probe is invalid on its own: %s" % once_only.problem())
	_expect(direct.acquire_passive_card(once_only).is_empty(),
		"the once-only probe was refused on its first acquisition")
	_refusals += 1
	_expect(not direct.acquire_passive_card(once_only).is_empty(),
		"a once-only card was acquired twice")
	_expect(direct.acquisitions_for(&"zz_probe_sealed") == 1,
		"the once-only card is held %d times" % direct.acquisitions_for(&"zz_probe_sealed"))

	## AND THE FACT THAT MAKES THE ABOVE NECESSARY, MEASURED RATHER THAN CLAIMED:
	## every shipped card is repeatable, so no canonical record can reach that
	## sentence through this transaction today.
	var repeatable: int = 0
	for record: PassiveCardDefinition in PassiveCardCatalogue.records():
		if record.repeatable:
			repeatable += 1
	_expect(repeatable == PassiveCardCatalogue.records().size(),
		"%d of %d shipped cards are repeatable" % [
			repeatable, PassiveCardCatalogue.records().size(),
		])

	## THE REACHABLE FORM, THROUGH THE TRANSACTION. A run in which the card id is
	## already bound as ONCE-ONLY refuses the canonical record that says
	## otherwise, because one card id is one mechanical passive for the life of a
	## run — and the refusal happens after every gate, which is exactly where a
	## consumption committed too early would already have been spent.
	var build: RiftRunBuild = RiftRunBuild.new()
	var sealed: PassiveCardDefinition = _card(
		EXPECTED_REPEAT_CARD, "Probe Sealed Repeat", EXPECTED_REPEAT_STAT,
		EXPECTED_REPEAT_MAGNITUDE, PROBE_WEIGHT, false)
	_expect(sealed.problem().is_empty(),
		"the sealed probe is invalid on its own: %s" % sealed.problem())
	_expect(build.acquire_passive_card(sealed).is_empty(),
		"the sealed probe could not be acquired")
	_expect(build.mechanical_identity_for(EXPECTED_REPEAT_CARD).contains("once only"),
		"the run bound %s as '%s'" % [
			EXPECTED_REPEAT_CARD, build.mechanical_identity_for(EXPECTED_REPEAT_CARD),
		])

	var ledger: RiftConsumptionLedger = RiftConsumptionLedger.new()
	var offer: RiftOffer = _shipped_offer(REPEAT_SEED_A)
	_expect(offer.combat_card_id == EXPECTED_REPEAT_CARD,
		"root seed %d offers %s in the combat lane" % [REPEAT_SEED_A, offer.combat_card_id])

	var refusal: RiftOfferChoiceResult = _expect_atomic_refusal(
		RiftOfferChoice.choose(offer, RiftOffer.Lane.COMBAT_DEFENCE, build, ledger),
		build, ledger, "a canonical card this run already holds as once-only")
	_expect(refusal.failure_reason.contains(String(EXPECTED_REPEAT_CARD)),
		"the refusal reads '%s'" % refusal.failure_reason)
	_expect(build.acquisitions_for(EXPECTED_REPEAT_CARD) == 1,
		"the refused acquisition moved the count to %d"
			% build.acquisitions_for(EXPECTED_REPEAT_CARD))
	_expect(not ledger.has_consumed(REPEAT_SEED_A),
		"a refused acquisition consumed root seed %d" % REPEAT_SEED_A)
	_expect(ledger.count() == 0, "the ledger holds %d seeds" % ledger.count())

	print("  the once-only rule refuses directly and through the transaction; %d of %d shipped"
		% [repeatable, PassiveCardCatalogue.records().size()])
	print("  cards are repeatable, so the canonical route to that sentence is unreachable today")
	_done("a_non_repeatable_passive_already_held_refuses_without_consuming")


# --- 13. A repeatable passive from two offers ------------------------------------------

func _check_a_repeatable_passive_taken_from_two_offers_counts_twice() -> void:
	print("")
	print("--- 13. A repeatable passive taken from two offers counts and adds twice")

	var canonical: PassiveCardDefinition = _shipped(EXPECTED_REPEAT_CARD)
	_expect(canonical != null and canonical.repeatable,
		"%s is not a repeatable canonical card" % EXPECTED_REPEAT_CARD)
	_expect(canonical.stat_id == EXPECTED_REPEAT_STAT
			and canonical.magnitude == EXPECTED_REPEAT_MAGNITUDE,
		"%s moves %s by %s" % [
			EXPECTED_REPEAT_CARD, canonical.stat_id, _exact(canonical.magnitude),
		])

	var first_offer: RiftOffer = _shipped_offer(REPEAT_SEED_A)
	var second_offer: RiftOffer = _shipped_offer(REPEAT_SEED_B)
	_expect(first_offer.combat_card_id == EXPECTED_REPEAT_CARD
			and second_offer.combat_card_id == EXPECTED_REPEAT_CARD,
		"the two fixtures offer %s and %s" % [
			first_offer.combat_card_id, second_offer.combat_card_id,
		])
	_expect(REPEAT_SEED_A != REPEAT_SEED_B, "the two fixtures share a root seed")

	var first: RiftOfferChoiceResult = RiftOfferChoice.choose(
		first_offer, RiftOffer.Lane.COMBAT_DEFENCE,
		RiftRunBuild.new(), RiftConsumptionLedger.new())
	_expect_success(first, "the first acquisition of %s" % EXPECTED_REPEAT_CARD)
	_expect(first.new_build.total_for(EXPECTED_REPEAT_STAT) == EXPECTED_REPEAT_MAGNITUDE,
		"one acquisition came to %s" % _exact(first.new_build.total_for(EXPECTED_REPEAT_STAT)))

	var second: RiftOfferChoiceResult = RiftOfferChoice.choose(
		second_offer, RiftOffer.Lane.COMBAT_DEFENCE, first.new_build, first.new_ledger)
	_expect_success(second, "the second acquisition of %s" % EXPECTED_REPEAT_CARD)

	## THE COUNT AND THE TOTAL, BOTH, BECAUSE THEY FAIL SEPARATELY. A repeat that
	## replaced a contribution instead of adding one would move the count and not
	## the total; a repeat that added twice from one offer would move the total
	## and not the ledger.
	_expect(second.new_build.acquisitions_for(EXPECTED_REPEAT_CARD) == 2,
		"%s is held %d times" % [
			EXPECTED_REPEAT_CARD, second.new_build.acquisitions_for(EXPECTED_REPEAT_CARD),
		])
	_expect(second.new_build.total_for(EXPECTED_REPEAT_STAT) == EXPECTED_REPEAT_TOTAL,
		"two acquisitions came to %s, not %s" % [
			_exact(second.new_build.total_for(EXPECTED_REPEAT_STAT)),
			_exact(EXPECTED_REPEAT_TOTAL),
		])
	_expect(second.new_build.contribution_count_for(EXPECTED_REPEAT_STAT) == 2,
		"%s received %d contributions" % [
			EXPECTED_REPEAT_STAT,
			second.new_build.contribution_count_for(EXPECTED_REPEAT_STAT),
		])
	_expect(second.new_build.passive_acquisitions() == 2,
		"the run holds %d passive acquisitions" % second.new_build.passive_acquisitions())
	_expect(second.new_ledger.count() == 2,
		"two offers produced a ledger of %d" % second.new_ledger.count())

	## AND THE BOUND MECHANICAL IDENTITY DID NOT MOVE, which is the D-242 property
	## this transaction must not be able to disturb.
	_expect(second.new_build.mechanical_identity_for(EXPECTED_REPEAT_CARD)
			== first.new_build.mechanical_identity_for(EXPECTED_REPEAT_CARD),
		"the bound identity moved from '%s' to '%s'" % [
			first.new_build.mechanical_identity_for(EXPECTED_REPEAT_CARD),
			second.new_build.mechanical_identity_for(EXPECTED_REPEAT_CARD),
		])

	print("  %s x2 from root seeds %d and %d: %s = %s over 2 contributions" % [
		EXPECTED_REPEAT_CARD, REPEAT_SEED_A, REPEAT_SEED_B, EXPECTED_REPEAT_STAT,
		_exact(second.new_build.total_for(EXPECTED_REPEAT_STAT)),
	])
	_done("a_repeatable_passive_taken_from_two_offers_counts_twice")


# --- 14. Presentation labels ---------------------------------------------------------

func _check_presentation_labels_cannot_change_the_transaction() -> void:
	print("")
	print("--- 14. Renaming every presentation label changes nothing about a transaction")

	var canonical_cards: Array[PassiveCardDefinition] = PassiveCardCatalogue.records()
	var renamed_cards: Array[PassiveCardDefinition] = _renamed_cards()

	## THE RENAME ACTUALLY HAPPENED, AND THE IDS DID NOT MOVE. Without both halves
	## the comparison below would be satisfied by having changed nothing at all.
	_expect(renamed_cards.size() == canonical_cards.size(),
		"the renamed set holds %d records, not %d" % [
			renamed_cards.size(), canonical_cards.size(),
		])
	var renamed_count: int = 0
	var id_drift: PackedStringArray = PackedStringArray()
	for index: int in canonical_cards.size():
		if renamed_cards[index].display_name != canonical_cards[index].display_name:
			renamed_count += 1
		if renamed_cards[index].card_id != canonical_cards[index].card_id:
			id_drift.append(String(canonical_cards[index].card_id))
	_expect(renamed_count == canonical_cards.size(),
		"only %d of %d records were renamed" % [renamed_count, canonical_cards.size()])
	_expect(id_drift.is_empty(), "renaming moved the ids %s" % ", ".join(id_drift))

	## AND THE OFFER IS THE SAME OFFER, which is what makes the comparison below a
	## statement about the TRANSACTION rather than about the composer.
	var canonical_offer: RiftOffer = _shipped_offer(LANE_SEED)
	var renamed_offer: RiftOffer = _offer_from_cards(renamed_cards, LANE_SEED)
	_expect(renamed_offer.ok and renamed_offer.problem().is_empty(),
		"the renamed offer did not compose: %s" % renamed_offer.failure_reason)
	_expect(renamed_offer.offer_line() == canonical_offer.offer_line(),
		"the renamed offer presents %s, not %s" % [
			renamed_offer.offer_line(), canonical_offer.offer_line(),
		])

	## EVERY LANE, COMPARED AS A COMPLETE OUTCOME. The granted identity, the whole
	## resulting build and the whole resulting ledger.
	for lane: int in RiftOffer.LANE_ORDER:
		var from_canonical: RiftOfferChoiceResult = RiftOfferChoice.choose(
			canonical_offer, lane, RiftRunBuild.new(), RiftConsumptionLedger.new())
		var from_renamed: RiftOfferChoiceResult = RiftOfferChoice.choose(
			renamed_offer, lane, RiftRunBuild.new(), RiftConsumptionLedger.new())
		_expect_success(from_canonical, "the canonical %s lane" % RiftOffer.lane_label(lane))
		_expect_success(from_renamed, "the renamed %s lane" % RiftOffer.lane_label(lane))
		_expect(from_renamed.identity_line() == from_canonical.identity_line(),
			"the %s lane granted %s under renaming, not %s" % [
				RiftOffer.lane_label(lane), from_renamed.identity_line(),
				from_canonical.identity_line(),
			])
		_expect(_snapshot(from_renamed.new_build) == _snapshot(from_canonical.new_build),
			"the %s lane produced a different build under renaming:\n    %s\n    %s" % [
				RiftOffer.lane_label(lane), _snapshot(from_canonical.new_build),
				_snapshot(from_renamed.new_build),
			])
		_expect(_ledger_snapshot(from_renamed.new_ledger)
				== _ledger_snapshot(from_canonical.new_ledger),
			"the %s lane produced a different ledger under renaming" % RiftOffer.lane_label(lane))

	## AND A RENAMED RECORD IS STILL COMPATIBLE WITH ONE ALREADY HELD, which is
	## the mid-run half of the same property: copy may be rewritten without
	## invalidating what a player already holds.
	var held: RiftOfferChoiceResult = RiftOfferChoice.choose(
		_shipped_offer(REPEAT_SEED_A), RiftOffer.Lane.COMBAT_DEFENCE,
		RiftRunBuild.new(), RiftConsumptionLedger.new())
	_expect_success(held, "the first acquisition before a rename")
	var after_rename: RiftOfferChoiceResult = RiftOfferChoice.choose(
		_offer_from_cards(renamed_cards, REPEAT_SEED_B), RiftOffer.Lane.COMBAT_DEFENCE,
		held.new_build, held.new_ledger)
	_expect_success(after_rename, "a second acquisition from a renamed record set")
	_expect(after_rename.new_build.acquisitions_for(EXPECTED_REPEAT_CARD) == 2,
		"%s is held %d times across a rename" % [
			EXPECTED_REPEAT_CARD,
			after_rename.new_build.acquisitions_for(EXPECTED_REPEAT_CARD),
		])
	_expect(after_rename.new_build.total_for(EXPECTED_REPEAT_STAT) == EXPECTED_REPEAT_TOTAL,
		"the total across a rename came to %s" % _exact(
			after_rename.new_build.total_for(EXPECTED_REPEAT_STAT)))

	print("  %d records renamed, 0 ids moved; all 3 lanes produce byte-identical outcomes"
		% renamed_count)
	print("  and a renamed record is still the same mechanical passive mid-run")
	_done("presentation_labels_cannot_change_the_transaction")


# --- 15. Generic, ambient-free, unwired --------------------------------------------------

func _check_the_transaction_is_generic_and_unwired() -> void:
	print("")
	print("--- 15. The three scripts name nothing concrete, read nothing ambient, run nowhere")

	var scanned: int = 0
	var forbidden_total: int = 0
	var ambient_total: int = 0
	var deferred_total: int = 0
	for path: String in D3_FILES:
		var raw: String = FileAccess.get_file_as_string(path)
		_expect(raw.length() > 1500,
			"%s read as %d characters, so these scans prove nothing" % [
				path.get_file(), raw.length(),
			])
		var code: String = _code_only(raw)
		_expect(code.length() > 400 and code.length() < raw.length(),
			"%s: comment stripping produced %d characters from %d" % [
				path.get_file(), code.length(), raw.length(),
			])
		scanned += 1

		var named: PackedStringArray = PackedStringArray()
		for token: String in FORBIDDEN_TOKENS:
			if raw.contains(token):
				named.append(token)
		forbidden_total += named.size()
		_expect(named.is_empty(), "%s names: %s" % [path.get_file(), ", ".join(named)])

		var ambient: PackedStringArray = PackedStringArray()
		for token: String in AMBIENT_TOKENS:
			if raw.contains(token):
				ambient.append(token)
		ambient_total += ambient.size()
		_expect(ambient.is_empty(),
			"%s reads ambient state: %s" % [path.get_file(), ", ".join(ambient)])

		var deferred: PackedStringArray = PackedStringArray()
		for token: String in DEFERRED_MEMBER_TOKENS:
			if _names_deferred_member(code, token):
				deferred.append(token)
		deferred_total += deferred.size()
		_expect(deferred.is_empty(),
			"%s carries deferred members: %s" % [path.get_file(), ", ".join(deferred)])
	_expect(scanned == D3_FILES.size(),
		"%d of %d D3 scripts were scanned" % [scanned, D3_FILES.size()])

	## THE SCANS ARE PROVED CAPABLE OF FAILING, by finding their own tokens where
	## those tokens legitimately live: in this file. A scan that can only ever
	## report zero is not a guard.
	var self_source: String = FileAccess.get_file_as_string(
		"res://tests/rift_offer_choice_verification.gd")
	var found_here: int = 0
	for token: String in FORBIDDEN_TOKENS:
		if self_source.contains(token):
			found_here += 1
	_expect(found_here > 20,
		"the forbidden-token scan found only %d of its own tokens in this file" % found_here)

	## AND THE REFINED DEFERRED-MEMBER MATCHER IS PROVED IN BOTH DIRECTIONS, on
	## the exact pair that made it necessary: it must still catch a member named
	## for a deferred system, and it must not fire on the word that describes what
	## this foundation refuses to expose.
	_expect(_names_deferred_member("var award_xp: int = 0", "xp"),
		"the deferred-member matcher no longer catches a member named for a deferred system")
	_expect(not _names_deferred_member("a refused choice must expose nothing", "xp"),
		"the deferred-member matcher still fires on the sentence that makes the claim")

	## THE CATALOGUE, IN BOTH DIRECTIONS. Exactly one file must name it, because
	## resolving a stable id through the canonical catalogue IS the transaction's
	## authorized mechanism; the other two must not, because a ledger or a result
	## that knew about content would be a value that had stopped being one.
	_expect(FileAccess.get_file_as_string(CHOICE_FILE).contains(CATALOGUE_TOKEN),
		"the transaction does not name %s, so it no longer resolves ids canonically"
			% CATALOGUE_TOKEN)
	for path: String in [RESULT_FILE, LEDGER_FILE]:
		_expect(not FileAccess.get_file_as_string(path).contains(CATALOGUE_TOKEN),
			"%s names %s" % [path.get_file(), CATALOGUE_TOKEN])

	## AN ALLOWLIST, NOT ONLY A DENYLIST, AND PER FILE. The token list above can
	## only refuse names somebody remembered to add; this asks the ENGINE which
	## project classes exist and requires each file to name none of them but the
	## ones written beside its own path.
	var all_classes: PackedStringArray = PackedStringArray()
	for entry: Dictionary in ProjectSettings.get_global_class_list():
		var class_id: String = String(entry.get("class", ""))
		if not class_id.is_empty():
			all_classes.append(class_id)
	_expect(all_classes.size() > 20,
		"only %d project classes were enumerated; the allowlist may be inert"
			% all_classes.size())
	for row: Array in AUTHORIZED_CLASSES:
		var path: String = String(row[0])
		var granted: Array = row[1]
		var raw: String = FileAccess.get_file_as_string(path)
		var outside: PackedStringArray = PackedStringArray()
		for class_id: String in all_classes:
			if granted.has(class_id):
				continue
			if raw.contains(class_id):
				outside.append(class_id)
		_expect(outside.is_empty(),
			"%s names unauthorized project class(es): %s" % [
				path.get_file(), ", ".join(outside),
			])

	## THE SUBSTRING GRANT ABOVE IS PAID FOR, AND THIS IS THE PAYMENT. The two
	## files were granted the accepted continuation SELECTOR only because its name
	## is contained in the record's; neither may actually call it, because a
	## transaction that selected its own continuation would be composing the
	## decision it exists to consume.
	var selecting: PackedStringArray = PackedStringArray()
	for path: String in [CHOICE_FILE, RESULT_FILE]:
		if FileAccess.get_file_as_string(path).contains(CONTINUATION_CALL):
			selecting.append(path.get_file())
	_expect(selecting.is_empty(),
		"%s calls the accepted continuation selector, which consumes nothing"
			% ", ".join(selecting))

	## THE METHOD AND FIELD PINS. A second offer, a level-up step, a reset rule or
	## a persistence hook arrives as an extra method with a plausible name rather
	## than as a forbidden token.
	_expect(", ".join(_methods_of(CHOICE_FILE)) == ", ".join(EXPECTED_CHOICE_METHODS),
		"the transaction declares: %s" % ", ".join(_methods_of(CHOICE_FILE)))
	_expect(", ".join(_methods_of(RESULT_FILE)) == ", ".join(EXPECTED_RESULT_METHODS),
		"the result declares: %s" % ", ".join(_methods_of(RESULT_FILE)))
	_expect(", ".join(_methods_of(LEDGER_FILE)) == ", ".join(EXPECTED_LEDGER_METHODS),
		"the ledger declares: %s" % ", ".join(_methods_of(LEDGER_FILE)))

	var choice_fields: PackedStringArray = _fields_of(RiftOfferChoice.new())
	_expect(choice_fields.is_empty(),
		"the transaction carries the instance field(s) %s" % ", ".join(choice_fields))
	var result_fields: PackedStringArray = _fields_of(RiftOfferChoiceResult.new())
	_expect(", ".join(result_fields) == ", ".join(EXPECTED_RESULT_FIELDS),
		"the result carries the fields: %s" % ", ".join(result_fields))
	var ledger_fields: PackedStringArray = _fields_of(RiftConsumptionLedger.new())
	_expect(", ".join(ledger_fields) == ", ".join(EXPECTED_LEDGER_FIELDS),
		"the ledger carries the fields: %s" % ", ".join(ledger_fields))
	var exposed: PackedStringArray = PackedStringArray()
	for field: String in ledger_fields:
		if not field.begins_with("_"):
			exposed.append(field)
	_expect(exposed.is_empty(),
		"the ledger exposes the field(s) %s directly" % ", ".join(exposed))

	## NOTHING BUT AN AUTHORIZED READER REFERENCES IT. There is still no offer
	## display, no input, no experience source and no persistence anywhere in
	## this foundation; the only files that may name one of its three classes are
	## the three themselves and the readers named in `AUTHORIZED_READERS`, each
	## granted exactly the classes written beside its own path.
	var project_files: int = 0
	var referenced: PackedStringArray = PackedStringArray()
	for root: String in SCANNED_ROOTS:
		for path: String in _files_under(root, [".gd", ".tscn", ".tres"]):
			if D3_FILES.has(path):
				continue
			project_files += 1
			var source: String = FileAccess.get_file_as_string(path)
			for name: String in D3_CLASSES:
				if source.contains(name) and not _reader_may_name(path, name):
					referenced.append("%s names %s" % [path.get_file(), name])
	var settings: String = FileAccess.get_file_as_string(PROJECT_SETTINGS_FILE)
	for name: String in D3_CLASSES:
		if settings.contains(name):
			referenced.append("project.godot names %s" % name)
	_expect(referenced.is_empty(),
		"Foundation D3 is referenced by code that runs: %s" % ", ".join(referenced))
	_expect(project_files > 100,
		"only %d project files were scanned, so the scan proves nothing" % project_files)
	_expect(_files_under("res://addons", [".gd"]).size() > 0,
		"the addons root was scanned and held no script, so widening the scan proved nothing")
	_expect(not settings.contains("[autoload]"),
		"project.godot declares an [autoload] section")

	## `scripts/choices/` HOLDS EXACTLY WHAT IT SHOULD. A scratch probe left
	## behind is a project file nobody meant to ship, and every scan above that
	## filters on a known path is blind to it.
	var choice_scripts: PackedStringArray = _files_under("res://scripts/choices", [".gd"])
	choice_scripts.sort()
	var expected_scripts: PackedStringArray = PackedStringArray(D3_FILES)
	expected_scripts.sort()
	_expect(", ".join(choice_scripts) == ", ".join(expected_scripts),
		"scripts/choices/ holds: %s" % ", ".join(choice_scripts))

	## THE EXEMPTIONS THE THREE ACCEPTED SUITES GRANT THESE FILES ARE EARNED, AND
	## THE LISTS AGREE. Each of those suites proves that nothing names its classes
	## except an authorized reader; if a D3 file stopped naming the class it was
	## granted, the exemption would quietly become a claim about nothing while
	## still passing.
	for row: Array in AUTHORIZING_SUITES:
		var suite_source: String = FileAccess.get_file_as_string(String(row[0]))
		var label: String = String(row[1])
		var granted_paths: Array = row[2]
		var granted_classes: Array = row[3]
		_expect(not suite_source.is_empty(),
			"the Foundation %s suite could not be read" % label)
		var listed: int = 0
		for path: String in granted_paths:
			if suite_source.contains(path):
				listed += 1
		_expect(listed == granted_paths.size(),
			"the Foundation %s suite authorizes %d of the %d D3 scripts it must" % [
				label, listed, granted_paths.size(),
			])
		var unearned: PackedStringArray = PackedStringArray()
		for path: String in granted_paths:
			var source: String = FileAccess.get_file_as_string(path)
			for class_id: String in granted_classes:
				if not source.contains(class_id):
					unearned.append("%s does not name %s" % [path.get_file(), class_id])
		_expect(unearned.is_empty(),
			"the Foundation %s exemption is unearned: %s" % [label, ", ".join(unearned)])

	## The entrypoint and the InputMap, counted exactly as every existing suite
	## counts them.
	_expect(String(ProjectSettings.get_setting("application/run/main_scene", ""))
			== "res://scenes/app/prototype_app.tscn",
		"the project entrypoint is %s"
			% ProjectSettings.get_setting("application/run/main_scene", ""))
	var actions: int = 0
	for action: StringName in InputMap.get_actions():
		if String(action).begins_with("ui_") and not String(action) in ["ui_confirm", "ui_cancel"]:
			continue
		actions += 1
	_expect(actions == 31, "the InputMap holds %d project actions, not 31" % actions)

	print("  %d scripts scanned raw: %d forbidden tokens, %d ambient reads, %d deferred members"
		% [scanned, forbidden_total, ambient_total, deferred_total])
	print("  %d methods and %d fields pinned, 0 transaction state; %d project files name no D3 class"
		% [
			EXPECTED_CHOICE_METHODS.size() + EXPECTED_RESULT_METHODS.size()
				+ EXPECTED_LEDGER_METHODS.size(),
			result_fields.size() + ledger_fields.size(), project_files,
		])
	print("  %d refusals were driven across this suite" % _refusals)
	_done("the_transaction_is_generic_reads_nothing_ambient_and_is_unwired")


# --- 16. The granted identity cannot be reached through the result (D-249) ---------

## A MINIMAL OBJECT CARRYING A PACKED ARRAY IN A SCRIPT VARIABLE, and nothing
## else. It exists so that the engine behaviour this correction guards against can
## be DRIVEN rather than described — and driven on a purpose-built probe rather
## than on the corrected file, so the proof that the guard is NECESSARY does not
## depend on the defect still being present anywhere.
class AliasProbe extends RefCounted:
	var carried: PackedStringArray = PackedStringArray()


func _check_the_granted_identity_cannot_be_reached() -> void:
	print("")
	print("--- 16. The granted identity is a copy, and the aliasing defect is gone")

	## THE ENGINE BEHAVIOUR FIRST, BECAUSE WITHOUT IT EVERY ASSERTION BELOW IS
	## SATISFIED BY AN ENGINE THAT COPIES ANYWAY. A `PackedStringArray` read out
	## of a script VARIABLE aliases rather than copying, which is the opposite of
	## what it is usually believed to do, and is the whole reason the public field
	## this check replaces was unsafe.
	var probe: AliasProbe = AliasProbe.new()
	probe.carried = PackedStringArray(["zz_one"])
	var aliased: PackedStringArray = probe.carried
	aliased.append("zz_two")
	_expect(probe.carried.size() == 2,
		"a packed array read out of a script variable no longer aliases,"
			+ " so the accessor proofs below prove nothing")

	## 1. MUTATING THE ARRAY HANDED TO THE CONSTRUCTOR CANNOT REACH THE RESULT.
	var supplied: PackedStringArray = PackedStringArray([
		String(EXPECTED_SKILL), String(EXPECTED_SUPPORT),
	])
	## The ledger this result carries must really record the seed it claims to
	## have spent, because `problem()` cross-checks exactly that and a probe built
	## with an empty one would be incoherent for a reason that has nothing to do
	## with the identity.
	var spent: RiftConsumptionLedger = RiftConsumptionLedger.new()
	_expect(spent.consume(LANE_SEED), "the probe ledger could not record its seed")
	## AND THE BUILD IT CARRIES MUST REALLY HOLD THE PAIR AT THE RANK THE
	## PROGRESSION NAMES, for the same reason and since the same foundation
	## (D-257): `problem()` now cross-checks the carried build's rank for the
	## offered pair against the after-rank this result says it consumed, so a probe
	## built on an empty build would be incoherent for a reason that has nothing to
	## do with the identity this check is about. The acquisition is not asserted
	## here on purpose — assertion 4 below requires this very result to be
	## COHERENT, which is false unless it succeeded, so a silent failure cannot
	## survive this check and no assertion was added to the pinned count.
	var carried: RiftRunBuild = RiftRunBuild.new()
	carried.acquire_support(EXPECTED_SKILL, EXPECTED_SUPPORT)
	var result: RiftOfferChoiceResult = RiftOfferChoiceResult.chosen(
		LANE_SEED, RiftOffer.Lane.SUPPORT, supplied,
		SupportContinuationResult.Kind.NEW_PAIR,
		AcquiredSupports.ABSENT_RANK, AcquiredSupports.FIRST_RANK,
		carried, spent
	)
	var expected: String = "%s -> %s" % [EXPECTED_SKILL, EXPECTED_SUPPORT]
	_expect(" -> ".join(result.chosen_identity()) == expected,
		"the constructor recorded %s" % " -> ".join(result.chosen_identity()))
	supplied.append("zz_injected")
	_expect(supplied.size() == 3, "the supplied array was not actually mutated")
	_expect(" -> ".join(result.chosen_identity()) == expected,
		"mutating the supplied array changed the result to %s"
			% " -> ".join(result.chosen_identity()))

	## 2. MUTATING WHAT THE ACCESSOR ANSWERED CANNOT REACH THE RESULT.
	var read_once: PackedStringArray = result.chosen_identity()
	read_once.append("zz_injected")
	_expect(read_once.size() == 3, "the array read from the accessor was not mutated")
	_expect(" -> ".join(result.chosen_identity()) == expected,
		"mutating a read identity changed the result to %s"
			% " -> ".join(result.chosen_identity()))
	_expect(result.chosen_identity() != read_once,
		"the accessor answered the very array that was appended to")

	## 3. TWO ANSWERS CANNOT REACH EACH OTHER, which is the half a single read
	## cannot show: an accessor that duplicated once and then cached would pass
	## every assertion above.
	var first: PackedStringArray = result.chosen_identity()
	var second: PackedStringArray = result.chosen_identity()
	first.append("zz_first")
	_expect(second.size() == 2,
		"appending to one answer changed another: %s" % " -> ".join(second))
	second.append("zz_second")
	_expect(first.size() == 3 and first[2] == "zz_first",
		"the two answers are one array: %s" % " -> ".join(first))

	## 4. AFTER ALL OF THAT, THE RESULT IS STILL EXACTLY WHAT IT WAS — and still
	## COHERENT, which is the property the defect actually broke: a grown identity
	## made this type's own `problem()` report the result as incoherent.
	_expect(" -> ".join(result.chosen_identity()) == expected,
		"the result now reports %s" % " -> ".join(result.chosen_identity()))
	_expect(result.chosen_identity().size()
			== RiftOfferChoiceResult.identity_size_for(RiftOffer.Lane.SUPPORT),
		"the identity no longer matches its lane's owed shape")
	_expect(result.problem().is_empty(),
		"the result stopped being coherent after a caller read it: %s" % result.problem())
	_expect(result.identity_line() == expected,
		"the presentation line now reads %s" % result.identity_line())

	## 5. A REFUSAL STILL ANSWERS AN EMPTY IDENTITY AND NO PARTIAL STATE, and
	## mutating what it answered cannot give it one.
	var refusal: RiftOfferChoiceResult = RiftOfferChoiceResult.refused(
		"zz refused for this check", LANE_SEED, RiftOffer.Lane.SUPPORT)
	_expect(refusal.chosen_identity().is_empty(),
		"a refusal answered %s" % " -> ".join(refusal.chosen_identity()))
	_expect(refusal.new_build == null and refusal.new_ledger == null,
		"a refusal carries a partial build or ledger")
	var from_refusal: PackedStringArray = refusal.chosen_identity()
	from_refusal.append("zz_injected")
	_expect(refusal.chosen_identity().is_empty(),
		"mutating a refusal's answer gave it the identity %s"
			% " -> ".join(refusal.chosen_identity()))
	_expect(refusal.problem().is_empty(),
		"the refusal stopped being coherent: %s" % refusal.problem())
	var seedless: RiftOfferChoiceResult = RiftOfferChoiceResult.refused_without_a_seed(
		"zz refused with no seed", RiftOffer.Lane.SUPPORT)
	_expect(seedless.chosen_identity().is_empty(),
		"a seedless refusal answered %s" % " -> ".join(seedless.chosen_identity()))

	## 6. AND THE IDENTITIES THEMSELVES DID NOT MOVE — byte for byte and order
	## for order, through the REAL transaction rather than through a constructor.
	## This is what makes the correction a change of route rather than of content.
	var support: RiftOfferChoiceResult = RiftOfferChoice.choose(
		_shipped_offer(LANE_SEED), RiftOffer.Lane.SUPPORT,
		RiftRunBuild.new(), RiftConsumptionLedger.new()
	)
	_expect_success(support, "the support lane through the real transaction")
	var support_identity: PackedStringArray = support.chosen_identity()
	_expect(support_identity.size() == 2,
		"the support lane granted %d identifiers" % support_identity.size())
	_expect(support_identity.size() == 2 and support_identity[0] == String(EXPECTED_SKILL),
		"the support lane's FIRST identifier is %s" % support_identity[0])
	_expect(support_identity.size() == 2 and support_identity[1] == String(EXPECTED_SUPPORT),
		"the support lane's SECOND identifier is %s" % support_identity[1])
	for lane_and_card: Array in [
		[RiftOffer.Lane.COMBAT_DEFENCE, EXPECTED_COMBAT_CARD],
		[RiftOffer.Lane.UTILITY, EXPECTED_UTILITY_CARD],
	]:
		var lane: int = int(lane_and_card[0])
		var card_id: StringName = lane_and_card[1]
		var passive: RiftOfferChoiceResult = RiftOfferChoice.choose(
			_shipped_offer(LANE_SEED), lane,
			RiftRunBuild.new(), RiftConsumptionLedger.new()
		)
		_expect_success(passive, "the %s lane through the real transaction"
			% RiftOffer.lane_label(lane))
		var identity: PackedStringArray = passive.chosen_identity()
		_expect(identity.size() == 1 and identity[0] == String(card_id),
			"the %s lane granted %s" % [
				RiftOffer.lane_label(lane), " -> ".join(identity),
			])

	print("  the identity is answered by copy: 2 supplied, 2 read and 2 accessor"
		+ " mutations reached nothing")
	print("  %s / %s / %s are unchanged byte for byte and order for order" % [
		expected, EXPECTED_COMBAT_CARD, EXPECTED_UTILITY_CARD,
	])
	_done("the_granted_identity_cannot_be_reached_through_the_result")


# --- Fixtures and helpers -------------------------------------------------------------
#
# Every fabricated record below is test data only: it is in no catalogue, no
# scene and no `.tres`, and it is not canon. The `zz_` prefix is so that none of
# them can be mistaken for content and so a future catalogue entry cannot collide
# with one.

func _shipped_offer(root_seed: int) -> RiftOffer:
	return _offer_from_cards(PassiveCardCatalogue.records(), root_seed)


func _offer_from_cards(
	cards: Array[PassiveCardDefinition], root_seed: int
) -> RiftOffer:
	return RiftOfferComposition.compose(
		SkillSupportCatalogue.skill_profiles(),
		SkillSupportCatalogue.support_definitions(),
		null, cards, root_seed
	)


func _shipped(card_id: StringName) -> PassiveCardDefinition:
	return PassiveCardCatalogue.record(card_id)


func _card(
	card_id: StringName, presentation: String, stat_id: StringName,
	magnitude: float, weight: int, repeatable: bool
) -> PassiveCardDefinition:
	return PassiveCardDefinition.of(card_id, presentation, stat_id, magnitude, weight, repeatable)


## Two cards per category, none of whose ids the canonical catalogue holds.
func _unknown_id_cards() -> Array[PassiveCardDefinition]:
	var out: Array[PassiveCardDefinition] = []
	out.append(_card(&"zz_probe_combat_one", "Probe Combat One",
		PlayerStats.GLOBAL_DAMAGE, PROBE_MAGNITUDE, PROBE_WEIGHT, true))
	out.append(_card(&"zz_probe_combat_two", "Probe Combat Two",
		PlayerStats.SKILL_SPEED, PROBE_MAGNITUDE, PROBE_WEIGHT, true))
	out.append(_card(&"zz_probe_utility_one", "Probe Utility One",
		PlayerStats.MOVEMENT_SPEED, PROBE_MAGNITUDE, PROBE_WEIGHT, true))
	out.append(_card(&"zz_probe_utility_two", "Probe Utility Two",
		PlayerStats.PICKUP_RADIUS, PROBE_MAGNITUDE, PROBE_WEIGHT, true))
	return out


## A record set whose ONLY Combat and Defence card carries a canonical UTILITY
## id, so the combat lane is forced to offer an id the catalogue holds in the
## other category. The record is valid on its own; the disagreement is with the
## catalogue rather than with the record contract.
func _combat_lane_holds_a_utility_id() -> Array[PassiveCardDefinition]:
	var out: Array[PassiveCardDefinition] = []
	out.append(_card(CANONICAL_UTILITY_ID, "Probe Misplaced Combat",
		PlayerStats.GLOBAL_DAMAGE, PROBE_MAGNITUDE, PROBE_WEIGHT, true))
	out.append(_card(&"zz_probe_utility_one", "Probe Utility One",
		PlayerStats.MOVEMENT_SPEED, PROBE_MAGNITUDE, PROBE_WEIGHT, true))
	return out


## The mirror: the only Utility card carries a canonical COMBAT AND DEFENCE id.
func _utility_lane_holds_a_combat_id() -> Array[PassiveCardDefinition]:
	var out: Array[PassiveCardDefinition] = []
	out.append(_card(&"zz_probe_combat_one", "Probe Combat One",
		PlayerStats.GLOBAL_DAMAGE, PROBE_MAGNITUDE, PROBE_WEIGHT, true))
	out.append(_card(CANONICAL_COMBAT_ID, "Probe Misplaced Utility",
		PlayerStats.MOVEMENT_SPEED, PROBE_MAGNITUDE, PROBE_WEIGHT, true))
	return out


## The shipped six with every presentation label rewritten and nothing else
## touched: same ids, same stats, same magnitudes, same weights, same
## repeatability.
func _renamed_cards() -> Array[PassiveCardDefinition]:
	var out: Array[PassiveCardDefinition] = []
	for record: PassiveCardDefinition in PassiveCardCatalogue.records():
		out.append(_card(record.card_id, RENAME_PREFIX + String(record.card_id),
			record.stat_id, record.magnitude, record.base_weight, record.repeatable))
	return out


## A build holding one pair and one card, so an atomicity claim is made against
## something rather than against nothing.
func _seeded_build() -> RiftRunBuild:
	var build: RiftRunBuild = RiftRunBuild.new()
	_expect(build.acquire_support(&"zz_skill_alpha", &"zz_support_reach").is_empty(),
		"the seeded build could not acquire its pair")
	_expect(build.acquire_passive_card(_shipped(EXPECTED_COMBAT_CARD)).is_empty(),
		"the seeded build could not acquire its card")
	return build


## A ledger holding one seed that no check ever composes an offer for, so it can
## never be mistaken for a consumption a transaction made.
func _seeded_ledger() -> RiftConsumptionLedger:
	var ledger: RiftConsumptionLedger = RiftConsumptionLedger.new()
	_expect(ledger.consume(987654321), "the seeded ledger could not record its seed")
	return ledger


# --- Assertions ------------------------------------------------------------------------

## One successful result, checked as a whole rather than only on `ok`: a success
## must also be internally coherent, carry both new values and state no reason.
func _expect_success(result: RiftOfferChoiceResult, described: String) -> void:
	_expect(result != null and result.ok, "%s was refused: %s" % [
		described, "no result at all" if result == null else result.failure_reason,
	])
	if result == null or not result.ok:
		return
	_expect(result.problem().is_empty(),
		"%s produced an incoherent result: %s" % [described, result.problem()])
	_expect(result.failure_reason.is_empty(),
		"%s succeeded and stated '%s'" % [described, result.failure_reason])
	_expect(result.new_build != null and result.new_ledger != null,
		"%s succeeded without both new values" % described)
	_expect(not result.chosen_identity().is_empty(),
		"%s succeeded and granted nothing" % described)


## One refusal, counted, and checked for the properties EVERY refusal owes: a
## stated reason, a coherent shape, and no updated state or granted identity.
func _expect_refused(result: RiftOfferChoiceResult, described: String) -> void:
	_refusals += 1
	_expect(result != null and not result.ok, "%s was accepted" % described)
	if result == null or result.ok:
		return
	_expect(not result.failure_reason.strip_edges().is_empty(),
		"%s was refused without a reason" % described)
	_expect(result.problem().is_empty(),
		"the refusal of %s is itself incoherent: %s" % [described, result.problem()])
	_expect(result.new_build == null and result.new_ledger == null,
		"the refusal of %s carries an updated build or ledger" % described)
	_expect(result.chosen_identity().is_empty(),
		"the refusal of %s granted %s" % [described, " -> ".join(result.chosen_identity())])


## A refusal that also left BOTH supplied values exactly as they were. The
## snapshots are complete on purpose: a refusal that recorded a card without its
## modifier, or spent a seed without granting anything, is caught by the same
## comparison that catches a refusal which recorded everything.
func _expect_atomic_refusal(
	result: RiftOfferChoiceResult, build: RiftRunBuild,
	ledger: RiftConsumptionLedger, described: String
) -> RiftOfferChoiceResult:
	var before_build: String = _snapshot(build)
	var before_ledger: String = _ledger_snapshot(ledger)
	_expect_refused(result, described)
	_expect(_snapshot(build) == before_build,
		"the refusal of %s changed the build:\n    before %s\n    after  %s" % [
			described, before_build, _snapshot(build),
		])
	_expect(_ledger_snapshot(ledger) == before_ledger,
		"the refusal of %s changed the ledger: %s -> %s" % [
			described, before_ledger, _ledger_snapshot(ledger),
		])
	return result


# --- Formatting ------------------------------------------------------------------------

## The COMPLETE run build as one line, to seventeen significant digits. Every
## atomicity claim in this suite is a comparison of two of these.
func _snapshot(build: RiftRunBuild) -> String:
	if build == null:
		return "no build"
	var parts: PackedStringArray = PackedStringArray()
	parts.append("pairs[%s]" % ", ".join(build.support_pairs()))
	parts.append("pair_count=%d" % build.support_count())
	var cards: PackedStringArray = PackedStringArray()
	for card_id: StringName in build.acquired_card_ids():
		cards.append("%s x%d {%s}" % [
			card_id, build.acquisitions_for(card_id), build.mechanical_identity_for(card_id),
		])
	parts.append("cards[%s]" % ", ".join(cards))
	parts.append("acquisitions=%d" % build.passive_acquisitions())
	for stat_id: StringName in PlayerStats.ALL:
		parts.append("%s=%s(%d)" % [
			stat_id, _exact(build.total_for(stat_id)), build.contribution_count_for(stat_id),
		])
	parts.append("empty=%s" % build.is_empty())
	return " | ".join(parts)


func _ledger_snapshot(ledger: RiftConsumptionLedger) -> String:
	if ledger == null:
		return "no ledger"
	return "count=%d seeds=[%s] empty=%s" % [
		ledger.count(), _seeds_line(ledger), ledger.is_empty(),
	]


func _seeds_line(ledger: RiftConsumptionLedger) -> String:
	var parts: PackedStringArray = PackedStringArray()
	for root_seed: int in ledger.consumed_seeds():
		parts.append(str(root_seed))
	return ", ".join(parts)


func _nonzero_stats(build: RiftRunBuild) -> String:
	var parts: PackedStringArray = PackedStringArray()
	for stat_id: StringName in PlayerStats.ALL:
		if build.total_for(stat_id) != 0.0 or build.contribution_count_for(stat_id) != 0:
			parts.append("%s=%s(%d)" % [
				stat_id, _exact(build.total_for(stat_id)),
				build.contribution_count_for(stat_id),
			])
	return ", ".join(parts)


## Seventeen decimal places. Every magnitude this foundation carries is well
## below 1, so seventeen places is more than the seventeen significant digits it
## takes to separate any two distinct doubles.
func _exact(value: float) -> String:
	return String.num(value, 17)


func _ids_line(values: Array[StringName]) -> String:
	var parts: PackedStringArray = PackedStringArray()
	for value: StringName in values:
		parts.append(String(value))
	return ", ".join(parts)


## Every line that is not a whole-line comment. See `DEFERRED_MEMBER_TOKENS` for
## why exactly this treatment exists.
func _code_only(source: String) -> String:
	var out: PackedStringArray = PackedStringArray()
	for line: String in source.split("\n"):
		if line.strip_edges().begins_with("#"):
			continue
		out.append(line)
	return "\n".join(out)


## Whether `code` names `token` as a deferred member. Tokens listed in
## `WORD_MATCHED_TOKENS` must appear at an identifier-word boundary — a letter or
## a digit on either side disqualifies the match, while an underscore does not —
## and every other token is an ordinary substring. See `WORD_MATCHED_TOKENS` for
## why the distinction exists and what it costs.
func _names_deferred_member(code: String, token: String) -> bool:
	if not WORD_MATCHED_TOKENS.has(token):
		return code.contains(token)
	var from: int = 0
	while true:
		var at: int = code.find(token, from)
		if at < 0:
			return false
		var before_ok: bool = at == 0 or not _is_word_character(code[at - 1])
		var after: int = at + token.length()
		var after_ok: bool = after >= code.length() or not _is_word_character(code[after])
		if before_ok and after_ok:
			return true
		from = at + 1
	return false


## A letter or a digit. The underscore is deliberately NOT one: `award_xp` must
## be caught and `expose` must not.
func _is_word_character(character: String) -> bool:
	return character.length() == 1 and (
		(character >= "a" and character <= "z")
		or (character >= "A" and character <= "Z")
		or (character >= "0" and character <= "9")
	)


func _methods_of(path: String) -> PackedStringArray:
	var out: PackedStringArray = PackedStringArray()
	var script: GDScript = load(path) as GDScript
	if script == null:
		return out
	for entry: Dictionary in script.get_script_method_list():
		out.append(String(entry.get("name", "")))
	return out


func _fields_of(instance: Object) -> PackedStringArray:
	var out: PackedStringArray = PackedStringArray()
	for entry: Dictionary in instance.get_property_list():
		if int(entry.get("usage", 0)) & PROPERTY_USAGE_SCRIPT_VARIABLE != 0:
			out.append(String(entry.get("name", "")))
	return out


## Whether `path` is an authorized reader that is granted `name`. Per file AND
## per class: a file listed for one class is still refused every other, which is
## what keeps the row from becoming a blanket exemption.
func _reader_may_name(path: String, name: String) -> bool:
	for row: Array in AUTHORIZED_READERS:
		if String(row[0]) != path:
			continue
		for granted: String in row[1]:
			if granted == name:
				return true
		return false
	return false


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
