extends SceneTree
## Riftwrought — Roguelite Foundation B verification: Deterministic Weighted
## Support Selection (decision D-227).
##
## ONE FOCUSED HEADLESS TEST. The foundation is pure logic — a definition, an
## acquisition record, a result, and a selector — so it needs no scene, no
## camera, no navigation, no rendering and no evidence frame, and it
## deliberately gets none. It runs as a `SceneTree` script exactly as Foundation
## A's own suite does.
##
## IT PORTS D-211's OWED-SET DISCIPLINE. Every check function records reaching
## its LAST line, and the suite compares that set against what it owes in BOTH
## directions, so a check that dies half way cannot leave a green run behind it.
##
## A WEIGHTED DRAW IS PROVED BY ENUMERATION, NOT BY SAMPLING. Every distribution
## claim below is made by walking EVERY ticket value in range and counting the
## outcome, so "a higher weight is more likely" is an exact statement about how
## many ticket values each candidate owns rather than a statistical impression
## that a different seed could contradict. The D-223 lesson — that the most
## comfortable place to write a weak assertion is one where the test performs
## the action itself and then reads its own result back — is why the ticket
## ladder is driven at its exact boundaries rather than fed seeds until one of
## them happens to land on one.
##
## THE GENERIC PROFILES AND SUPPORTS BELOW ARE NOT PLAYABLE CONTENT. They exist
## inside this file only, are registered in no catalogue, ship in no scene, no
## `.tres` and no library, and are not canon. They are the second and third
## Skills the shipped catalogue does not have yet, and without them the
## multiple-Skill behaviour of a two-stage selector could not be tested at all.

const FOUNDATION_B_FILES: Array[String] = [
	"res://scripts/skills/support_definition.gd",
	"res://scripts/skills/acquired_supports.gd",
	"res://scripts/skills/support_selection_result.gd",
	"res://scripts/skills/support_selection.gd",
]

## The selector and the three records it works on. NONE of them may name a
## Skill, a class or a support. Scanned RAW, comments included — D-215's lesson:
## an illustrative name in a comment breaches the rule just as surely as a real
## one, because the rule exists so a reader can trust the file holds no such
## knowledge.
const GENERIC_FILES: Array[String] = [
	"res://scripts/skills/support_definition.gd",
	"res://scripts/skills/acquired_supports.gd",
	"res://scripts/skills/support_selection_result.gd",
	"res://scripts/skills/support_selection.gd",
]

const FORBIDDEN_TOKENS: Array[String] = [
	"quick_strike", "Quick Strike", "QuickStrike",
	"reaching_edge", "Reaching Edge", "sweeping_edge", "Sweeping Edge",
	"RogueliteUpgrade", "Expedition Blade", "Quickened Edge",
	"SkillSupportCatalogue", "FirstMvpSkill",
]

## A deterministic selector may read no ambient state whatsoever.
const AMBIENT_TOKENS: Array[String] = [
	"randi", "randf", "randomize", "RandomNumberGenerator", "rand_from_seed",
	"Time.", "OS.", "Engine.", "ProjectSettings", "InputMap",
	"FileAccess", "ConfigFile", "ResourceSaver", "ResourceLoader", "user://",
]

## The four global class names Foundation B introduces. Only the shipped
## catalogue may reference any of them; nothing that RUNS may.
const FOUNDATION_B_CLASSES: Array[String] = [
	"SupportDefinition", "AcquiredSupports", "SupportSelectionResult", "SupportSelection",
]

## The single file outside Foundation B that is allowed to name one of its
## classes — the shipped catalogue, which is where a weight is authored.
const PERMITTED_CONSUMER: String = "res://scripts/skills/skill_support_catalogue.gd"

## THE FILES AUTHORIZED TO NAME A FOUNDATION B CLASS, AND THE EXACT CLASSES EACH
## OF THEM MAY NAME (D-239). The shipped catalogue is where a weight is authored,
## so it builds a definition; the Foundation D1 offer composer DELEGATES the
## whole support lane to this selector, so it names the selector, its result, the
## definition record and the acquisition record; and the D1 offer holds the
## result the selector returned, so it names that.
##
## THIS REPLACES THE SINGLE HARD-CODED `PERMITTED_CONSUMER` EXEMPTION ONE FOR
## ONE: the same single assertion is made either way, the catalogue's grant is
## unchanged in meaning, it still fails for any other file AND for any class a
## listed file is not granted, and the pinned count does not move.
##
## ONE SUBSTRING IS RECORDED RATHER THAN LEFT TO BE FOUND: `SupportSelection` is
## contained in `SupportSelectionResult`, so a file naming the result is reported
## as naming the selector too, and a grant for the result must carry both. The
## stronger property — that the D1 offer never CALLS the selector — is asserted
## by the D1 suite, which owns that boundary.
const AUTHORIZED_READERS: Array = [
	["res://scripts/skills/skill_support_catalogue.gd", ["SupportDefinition"]],
	## FOUNDATION F3 (D-255) NARROWED THE COMPOSER'S GRANT AND WIDENED THE OFFER'S, AND
	## BOTH MOVED ONE FOR ONE. The composer no longer names this selector or its
	## result at all: its support lane is now decided by the accepted CONTINUATION
	## selector, which delegates the draw here itself. Its grant is narrowed to
	## what it actually names rather than left carrying two classes it does not —
	## a grant that cannot fail is not a boundary. The OFFER gained the acquisition
	## record, and for exactly one reason: it reads that record's own two named
	## ranks so the rank transition it freezes is checked against Foundation F1's
	## vocabulary instead of against two integers retyped inside an offer. It
	## constructs no record and holds no acquisition state, which the D1 suite
	## asserts separately. The same single assertion is made either way, it still
	## fails for any other file AND for any class a listed file is not granted, and
	## the pinned count does not move.
	["res://scripts/offers/rift_offer_composition.gd", [
		"SupportDefinition", "AcquiredSupports",
	]],
	["res://scripts/offers/rift_offer.gd", [
		"AcquiredSupports", "SupportSelectionResult", "SupportSelection",
	]],
	## D-241: the Foundation D2 run-build state HOLDS one acquisition record for
	## the run it describes and delegates every pair rule to it, so naming that
	## record is the whole point of it rather than a breach of the boundary. It
	## names the acquisition record and NOTHING else here — not the selector, not
	## the result, not the definition — and the per-class grant is what keeps that
	## true. Added ONE FOR ONE: the same single assertion is made either way, it
	## still fails for any other file AND for any class this file is not granted,
	## and the pinned count does not move.
	["res://scripts/runs/rift_run_build.gd", ["AcquiredSupports"]],
	## D-248: the Foundation E2 level-up coordinator is handed the support
	## definitions and forwards them to the accepted composition mechanism. It
	## names the DEFINITION and nothing else here — not the selector, not the
	## result, and deliberately not the acquisition record, because it forwards
	## the run build's own snapshot without ever naming its type. Added one for
	## one, and the pinned count does not move.
	["res://scripts/levels/rift_level_up_coordinator.gd", ["SupportDefinition"]],
	## Foundation F2: the support-lane CONTINUATION selector DELEGATES its whole
	## decision to this selector, running it twice with the same seed — once
	## against the real acquisition state and, only if that refuses, once against
	## an empty one — so it names the selector, its result, the definition record
	## and the acquisition record for exactly the reasons the D1 composer does.
	## Its RESULT record holds the result this selector returned and names that
	## and nothing else. Added ONE FOR ONE: the same single assertion is made
	## either way, it still fails for any other file AND for any class a listed
	## file is not granted, and the pinned count does not move.
	["res://scripts/continuation/support_continuation.gd", [
		"SupportDefinition", "AcquiredSupports", "SupportSelectionResult", "SupportSelection",
	]],
	["res://scripts/continuation/support_continuation_result.gd", [
		"SupportSelectionResult", "SupportSelection",
	]],
	## Foundation G4 (decision D-269): the repeated run-level coordinator is handed
	## the support definitions and forwards them, unread, to the accepted one-level
	## coordinator when it opens the current level's offer. It names the DEFINITION
	## and nothing else here, exactly as that coordinator's own row does. Added one
	## for one, and the pinned count does not move.
	["res://scripts/levels/rift_run_level_coordinator.gd", ["SupportDefinition"]],
	## Foundation I1 (decision D-291): the H8 Experience-Mote runtime is handed the
	## support definitions when its owner asks it to open the current level's offer,
	## and hands them, unread, straight to that coordinator. It names the DEFINITION
	## and nothing else here, and holds none. Added one for one, and the pinned count
	## does not move.
	["res://scripts/experience/rift_mote_runtime.gd", ["SupportDefinition"]],
	## Roguelite I2 (decision D-293): the Playable Three-Lane Level-Up Choice Review — an
	## isolated scene launched by name — asks the shipped catalogue for the support
	## definitions when it opens its one level-up offer, and for the one definition a
	## Support card names so the card can show its display name. It names the DEFINITION
	## and nothing else here, and holds none. Added one for one, and the pinned count
	## does not move.
	["res://scripts/roguelite/level_up/roguelite_level_up_choice_review.gd", ["SupportDefinition"]],
]

const CANONICAL_QUICK_STRIKE: String = "res://data/prototype_zero/quick_strike.tres"

## How many identical calls a determinism claim is made over.
const REPEAT_CALLS: int = 100

## How many distinct seeds a reproduction claim is made over.
const SEED_SAMPLES: int = 256

## The widest ticket either deterministic stream can produce. Both
## `skill_ticket_for()` and `support_ticket_for()` end in a 32-bit mask, so this
## is the whole addressable range — and since D-236 it is also the ceiling on a
## weighted pool's total, so the two agree by construction.
const REACHABLE_TICKET_CEILING: int = 0xFFFFFFFF

## The shipped pool's seeded outcomes, CAPTURED BEFORE THE D-236 CEILING
## CORRECTION AND PINNED AFTER IT. seed, Skill, support, reduced ticket, total.
##
## THIS IS THE EVIDENCE THAT THE CORRECTION MOVED NOTHING THAT WAS ALREADY
## VALID. The shipped pool totals 200, which is four hundred thousand times
## below even the corrected ceiling, so no shipped selection could have been
## touched — but "could not have been" is an argument and this is a measurement.
## Negative and 64-bit seeds are in the corpus on purpose.
const SHIPPED_SEED_CORPUS: Array = [
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

## The shipped ladder's total, written out rather than summed from the records,
## so a weight that moved would turn this red instead of moving with it.
const SHIPPED_LADDER_TOTAL: int = 200

const OWED_CHECKS: Array[String] = [
	"the_shipped_weights_are_equal_and_valid",
	"ineligible_supports_never_enter_the_pool",
	"a_higher_weight_owns_more_tickets",
	"exact_ticket_boundaries_select_the_right_candidate",
	"the_same_seed_and_inputs_always_agree",
	"insertion_and_tag_order_change_nothing",
	"the_first_stage_is_uniform_over_skills",
	"more_supports_earns_no_extra_first_stage_probability",
	"tag_bonuses_alter_only_matching_skills",
	"an_acquired_pair_is_removed_for_its_own_skill_only",
	"every_invalid_case_fails_closed",
	"the_selector_is_generic_and_reads_nothing_ambient",
	"nothing_existing_changed",
]

var _failures: PackedStringArray = PackedStringArray()
var _checks: int = 0
var _reached: Dictionary = {}


func _initialize() -> void:
	print("")
	print("=== Roguelite Foundation B — Deterministic Weighted Support Selection (D-227) ===")

	_check_the_shipped_weights_are_equal_and_valid()
	_check_ineligible_supports_never_enter_the_pool()
	_check_a_higher_weight_owns_more_tickets()
	_check_exact_ticket_boundaries_select_the_right_candidate()
	_check_the_same_seed_and_inputs_always_agree()
	_check_insertion_and_tag_order_change_nothing()
	_check_the_first_stage_is_uniform_over_skills()
	_check_more_supports_earns_no_extra_first_stage_probability()
	_check_tag_bonuses_alter_only_matching_skills()
	_check_an_acquired_pair_is_removed_for_its_own_skill_only()
	_check_every_invalid_case_fails_closed()
	_check_the_selector_is_generic_and_reads_nothing_ambient()
	_check_nothing_existing_changed()

	_check_every_check_ran()

	print("")
	if _failures.is_empty():
		print("SUPPORT SELECTION VERIFICATION: PASS (%d checks)" % _checks)
		quit(0)
	else:
		for failure: String in _failures:
			printerr("  FAIL: %s" % failure)
		printerr("SUPPORT SELECTION VERIFICATION: %d FAILURE(S) of %d checks" % [
			_failures.size(), _checks,
		])
		quit(1)


# --- 1. The two shipped review weights ---------------------------------------

func _check_the_shipped_weights_are_equal_and_valid() -> void:
	print("")
	print("--- 1. The two shipped supports carry EQUAL review weights and no tag bonus")

	var definitions: Array[SupportDefinition] = SkillSupportCatalogue.support_definitions()
	_expect(definitions.size() == 2,
		"the catalogue holds %d weighted definitions, not 2" % definitions.size())
	_expect(SkillSupportCatalogue.problems().is_empty(),
		"the catalogue reports problems: %s" % ", ".join(SkillSupportCatalogue.problems()))

	## THE ID AND THE NAME ARE DERIVED, so a definition and its rule cannot
	## disagree about which support they describe. Asserted rather than assumed,
	## because the derivation is the only thing preventing two records of one
	## fact.
	for definition: SupportDefinition in definitions:
		_expect(definition.problem().is_empty(),
			"%s reports: %s" % [definition.support_id(), definition.problem()])
		_expect(definition.support_id() == definition.eligibility.support_id,
			"%s does not derive its id from its rule" % definition.support_id())
		_expect(definition.display_name() == definition.eligibility.display_name,
			"%s does not derive its name from its rule" % definition.support_id())
		_expect(definition.tag_bonuses.is_empty(),
			"%s declares a tag bonus, and neither shipped support should"
				% definition.support_id())

	var first: SupportDefinition = SkillSupportCatalogue.support_definition(
		SkillSupportCatalogue.REACHING_EDGE_ID
	)
	var second: SupportDefinition = SkillSupportCatalogue.support_definition(
		SkillSupportCatalogue.SWEEPING_EDGE_ID
	)
	_expect(first != null and second != null, "a shipped support definition could not be found")
	_expect(SkillSupportCatalogue.support_definition(&"not_a_support") == null,
		"an unknown support id returned a definition")
	_expect(first.base_weight == second.base_weight,
		"the two shipped base weights differ: %d and %d" % [
			first.base_weight, second.base_weight,
		])
	_expect(first.base_weight == 100,
		"the shipped review base weight is %d, not the pinned 100" % first.base_weight)

	## EQUALLY LIKELY IS MEASURED, NOT DECLARED. Every ticket value is walked and
	## the outcomes counted, so this is an exact statement about ownership of the
	## ladder rather than an impression from a handful of seeds.
	var profiles: Array[SkillTagProfile] = []
	profiles.append(SkillSupportCatalogue.quick_strike_profile())
	var effective_first: int = first.effective_weight_for(profiles[0])
	var effective_second: int = second.effective_weight_for(profiles[0])
	_expect(effective_first == effective_second,
		"the two shipped supports resolve to %d and %d for the shipped Skill" % [
			effective_first, effective_second,
		])

	## THE SHIPPED LADDER IS EXACTLY 200 TICKETS AND IS SPLIT 100 / 100, and both
	## halves of that sentence are asserted. The total is pinned against a number
	## typed in this suite rather than summed from the records it is checking, so
	## a weight that moved turns this red instead of moving with it.
	_expect(effective_first + effective_second == SHIPPED_LADDER_TOTAL,
		"the shipped ladder totals %d, not %d" % [
			effective_first + effective_second, SHIPPED_LADDER_TOTAL,
		])
	var counts: Dictionary = _sweep_support_tickets(profiles, definitions, null,
		SHIPPED_LADDER_TOTAL)
	_expect(counts.size() == 2, "the shipped sweep selected %d distinct supports" % counts.size())
	_expect(int(counts.get(SkillSupportCatalogue.REACHING_EDGE_ID, 0)) == effective_first
			and int(counts.get(SkillSupportCatalogue.SWEEPING_EDGE_ID, 0)) == effective_second,
		"the shipped ticket sweep is not an even split: %s" % counts)
	_expect(int(counts.get(SkillSupportCatalogue.REACHING_EDGE_ID, 0)) == 100
			and int(counts.get(SkillSupportCatalogue.SWEEPING_EDGE_ID, 0)) == 100,
		"the shipped ladder is not 100 / 100 over its %d tickets: %s" % [
			SHIPPED_LADDER_TOTAL, counts,
		])

	## THE SHIPPED POOL IS NOWHERE NEAR THE CEILING, which is what makes the
	## D-236 correction incapable of having touched it. Stated as a measurement
	## rather than left to be inferred from two constants sitting far apart.
	_expect(SHIPPED_LADDER_TOTAL < SupportSelection.MAXIMUM_TOTAL_WEIGHT,
		"the shipped ladder is not below the ceiling")

	## AND THE SEEDED OUTCOMES ARE THE ONES CAPTURED BEFORE THE CORRECTION.
	var moved: PackedStringArray = PackedStringArray()
	for row: Array in SHIPPED_SEED_CORPUS:
		var seeded: SupportSelectionResult = SupportSelection.select(
			profiles, definitions, null, int(row[0])
		)
		if not seeded.ok or String(seeded.skill_id) != String(row[1]) \
				or String(seeded.support_id) != String(row[2]) \
				or seeded.rolled_ticket != int(row[3]) \
				or seeded.total_eligible_weight != int(row[4]):
			moved.append("seed %d -> %s at %d of %d" % [
				int(row[0]), seeded.pair(), seeded.rolled_ticket,
				seeded.total_eligible_weight,
			])
	_expect(moved.is_empty(),
		"the shipped seed corpus moved: %s" % ", ".join(moved))
	var corpus_supports: Dictionary = {}
	for row: Array in SHIPPED_SEED_CORPUS:
		corpus_supports[String(row[2])] = true
	_expect(corpus_supports.size() == 2,
		"the shipped corpus reaches %d of the 2 supports, so it is degenerate"
			% corpus_supports.size())

	print("  shipped weights: two supports at base %d, no tag bonus, %d tickets each; "
		% [first.base_weight, effective_first]
		+ "%d seeded rows unchanged across the ceiling correction" % SHIPPED_SEED_CORPUS.size())
	_done("the_shipped_weights_are_equal_and_valid")


# --- 2. An ineligible support can never be drawn -----------------------------

func _check_ineligible_supports_never_enter_the_pool() -> void:
	print("")
	print("--- 2. An INELIGIBLE support never enters the weighted pool at all")

	var strike: SkillTagProfile = _profile(&"s1_contact", [
		SkillTags.ATTACK, SkillTags.HIT, SkillTags.MELEE, SkillTags.STRIKE, SkillTags.PHYSICAL,
	] as Array[StringName])

	var definitions: Array[SupportDefinition] = []
	definitions.append(_definition(&"t1_needs_melee", [SkillTags.MELEE] as Array[StringName],
		[] as Array[StringName], 4, {}))
	## Refused by a REQUIREMENT the Skill does not carry, and given a weight far
	## larger than either legal candidate: if it ever entered the pool it would
	## dominate the ladder, so its absence is loud rather than subtle.
	definitions.append(_definition(&"t2_needs_projectile", [SkillTags.PROJECTILE] as Array[StringName],
		[] as Array[StringName], 900, {}))
	## Refused by an EXCLUSION rather than by a requirement — the other of the two
	## ways a rule can deny, so both are covered.
	definitions.append(_definition(&"t3_excludes_melee", [SkillTags.HIT] as Array[StringName],
		[SkillTags.MELEE] as Array[StringName], 900, {}))
	definitions.append(_definition(&"t4_needs_hit", [SkillTags.HIT] as Array[StringName],
		[] as Array[StringName], 6, {}))

	var profiles: Array[SkillTagProfile] = []
	profiles.append(strike)

	var result: SupportSelectionResult = SupportSelection.select_with_tickets(
		profiles, definitions, null, 0, 0
	)
	_expect(result.ok, "the selection failed: %s" % result.failure_reason)
	_expect_coherent(result)
	_expect(result.total_eligible_weight == 10,
		"the total eligible weight is %d, not the 4 + 6 of the two legal supports"
			% result.total_eligible_weight)

	var counts: Dictionary = _sweep_support_tickets(profiles, definitions, null, 10)
	_expect(not counts.has(&"t2_needs_projectile") and not counts.has(&"t3_excludes_melee"),
		"an ineligible support was selected: %s" % counts)
	_expect(int(counts.get(&"t1_needs_melee", 0)) == 4 and int(counts.get(&"t4_needs_hit", 0)) == 6,
		"the eligible ladder is %s, not 4 and 6" % counts)

	print("  2 of 4 supports eligible; total weight 10 of a possible 1810; ineligible drawn 0 times")
	_done("ineligible_supports_never_enter_the_pool")


# --- 3. A higher weight owns more tickets ------------------------------------

func _check_a_higher_weight_owns_more_tickets() -> void:
	print("")
	print("--- 3. A higher integer weight owns strictly MORE selectable ticket values")

	var profiles: Array[SkillTagProfile] = []
	profiles.append(_profile(&"s1_contact",
		[SkillTags.ATTACK, SkillTags.HIT, SkillTags.MELEE] as Array[StringName]))

	var definitions: Array[SupportDefinition] = []
	definitions.append(_definition(&"t1_light", [SkillTags.MELEE] as Array[StringName],
		[] as Array[StringName], 1, {}))
	definitions.append(_definition(&"t2_medium", [SkillTags.MELEE] as Array[StringName],
		[] as Array[StringName], 3, {}))
	definitions.append(_definition(&"t3_heavy", [SkillTags.MELEE] as Array[StringName],
		[] as Array[StringName], 16, {}))

	var counts: Dictionary = _sweep_support_tickets(profiles, definitions, null, 20)
	_expect(int(counts.get(&"t1_light", -1)) == 1, "the weight-1 support owns %d tickets"
		% int(counts.get(&"t1_light", -1)))
	_expect(int(counts.get(&"t2_medium", -1)) == 3, "the weight-3 support owns %d tickets"
		% int(counts.get(&"t2_medium", -1)))
	_expect(int(counts.get(&"t3_heavy", -1)) == 16, "the weight-16 support owns %d tickets"
		% int(counts.get(&"t3_heavy", -1)))
	_expect(int(counts.get(&"t3_heavy", 0)) > int(counts.get(&"t2_medium", 0))
			and int(counts.get(&"t2_medium", 0)) > int(counts.get(&"t1_light", 0)),
		"the ticket ownership is not strictly ordered by weight: %s" % counts)

	## A weight is an ABSOLUTE count of tickets, not a share: doubling one
	## candidate's weight must add exactly that many tickets and take none away
	## from anyone else. Proved by re-running the same sweep with one weight
	## doubled.
	var doubled: Array[SupportDefinition] = []
	doubled.append(_definition(&"t1_light", [SkillTags.MELEE] as Array[StringName],
		[] as Array[StringName], 1, {}))
	doubled.append(_definition(&"t2_medium", [SkillTags.MELEE] as Array[StringName],
		[] as Array[StringName], 6, {}))
	doubled.append(_definition(&"t3_heavy", [SkillTags.MELEE] as Array[StringName],
		[] as Array[StringName], 16, {}))
	var after: Dictionary = _sweep_support_tickets(profiles, doubled, null, 23)
	_expect(int(after.get(&"t2_medium", -1)) == 6, "the doubled weight owns %d tickets"
		% int(after.get(&"t2_medium", -1)))
	_expect(int(after.get(&"t1_light", -1)) == 1 and int(after.get(&"t3_heavy", -1)) == 16,
		"doubling one weight moved another candidate's ticket count: %s" % after)

	print("  ticket ownership 1 / 3 / 16 of 20; doubling one weight moved no other count")
	_done("a_higher_weight_owns_more_tickets")


# --- 4. Exact ticket boundaries ----------------------------------------------

func _check_exact_ticket_boundaries_select_the_right_candidate() -> void:
	print("")
	print("--- 4. The EXACT ticket boundaries select the correct candidate")

	var profiles: Array[SkillTagProfile] = []
	profiles.append(_profile(&"s1_contact",
		[SkillTags.ATTACK, SkillTags.HIT, SkillTags.MELEE] as Array[StringName]))

	## Weights 4, 6 and 5 over a sorted ladder, so every boundary is a distinct
	## number and an off-by-one cannot hide behind a degenerate weight of 1.
	var definitions: Array[SupportDefinition] = []
	definitions.append(_definition(&"t1_first", [SkillTags.MELEE] as Array[StringName],
		[] as Array[StringName], 4, {}))
	definitions.append(_definition(&"t2_second", [SkillTags.MELEE] as Array[StringName],
		[] as Array[StringName], 6, {}))
	definitions.append(_definition(&"t3_third", [SkillTags.MELEE] as Array[StringName],
		[] as Array[StringName], 5, {}))

	var boundaries: Array = [
		[0, &"t1_first"], [3, &"t1_first"],
		[4, &"t2_second"], [9, &"t2_second"],
		[10, &"t3_third"], [14, &"t3_third"],
	]
	for pair: Array in boundaries:
		var ticket: int = int(pair[0])
		var expected: StringName = pair[1]
		var result: SupportSelectionResult = SupportSelection.select_with_tickets(
			profiles, definitions, null, 0, ticket
		)
		_expect(result.ok and result.support_id == expected,
			"ticket %d selected %s, not %s" % [ticket, result.support_id, expected])
		_expect(result.rolled_ticket == ticket,
			"ticket %d was reported back as %d" % [ticket, result.rolled_ticket])

	## A ticket at or beyond the total wraps by modulo rather than falling off
	## the ladder, and the reported ticket is the REDUCED one — so the number a
	## reviewer checks against the total is always the number that was used.
	var wrapped: SupportSelectionResult = SupportSelection.select_with_tickets(
		profiles, definitions, null, 0, 15
	)
	_expect(wrapped.ok and wrapped.support_id == &"t1_first",
		"a ticket equal to the total selected %s, not the first candidate" % wrapped.support_id)
	_expect(wrapped.rolled_ticket == 0,
		"the wrapped ticket was reported as %d, not the reduced 0" % wrapped.rolled_ticket)
	_expect_coherent(wrapped)

	print("  boundaries 0/3 -> first, 4/9 -> second, 10/14 -> third; 15 wraps to 0")
	_done("exact_ticket_boundaries_select_the_right_candidate")


# --- 5. The same seed and inputs always agree --------------------------------

func _check_the_same_seed_and_inputs_always_agree() -> void:
	print("")
	print("--- 5. The same seed and the same inputs always return the SAME pair")

	var profiles: Array[SkillTagProfile] = _two_melee_skills()
	var definitions: Array[SupportDefinition] = _three_melee_supports()

	var first: SupportSelectionResult = SupportSelection.select(profiles, definitions, null, 12345)
	_expect(first.ok, "the seeded selection failed: %s" % first.failure_reason)
	_expect_coherent(first)

	var drifted: int = 0
	for call: int in REPEAT_CALLS:
		var again: SupportSelectionResult = SupportSelection.select(
			profiles, definitions, null, 12345
		)
		if again.pair() != first.pair() or again.rolled_ticket != first.rolled_ticket \
				or again.skill_ticket != first.skill_ticket:
			drifted += 1
	_expect(drifted == 0, "%d of %d repeated calls disagreed with the first"
		% [drifted, REPEAT_CALLS])

	## Rebuilt from scratch rather than reused: the same seed against freshly
	## constructed records must agree, or the reproduction would only be a
	## property of these particular objects.
	var rebuilt: SupportSelectionResult = SupportSelection.select(
		_two_melee_skills(), _three_melee_supports(), null, 12345
	)
	_expect(rebuilt.pair() == first.pair() and rebuilt.rolled_ticket == first.rolled_ticket,
		"rebuilt records produced %s, not %s" % [rebuilt.pair(), first.pair()])

	## Two different seeds must be able to produce different pairs, or "the same
	## seed reproduces the pair" would be true of a constant.
	var distinct: Dictionary = {}
	var incoherent: int = 0
	for offset: int in SEED_SAMPLES:
		var sampled: SupportSelectionResult = SupportSelection.select(
			profiles, definitions, null, 1000 + offset
		)
		if not sampled.ok or not sampled.problem().is_empty():
			incoherent += 1
		distinct[sampled.pair()] = true
		if SupportSelection.select(profiles, definitions, null, 1000 + offset).pair() \
				!= sampled.pair():
			drifted += 1
	_expect(incoherent == 0, "%d of %d seeded results were incoherent"
		% [incoherent, SEED_SAMPLES])
	_expect(drifted == 0, "a seeded result was not reproducible")
	_expect(distinct.size() == 6,
		"%d distinct pairs were produced over %d seeds, not the 6 that exist"
			% [distinct.size(), SEED_SAMPLES])

	## The two streams are separated: a seed that fixes the Skill must not fix
	## the support. Proved by finding both stages varying across the sample.
	var skills_seen: Dictionary = {}
	var supports_seen: Dictionary = {}
	for offset: int in SEED_SAMPLES:
		var sampled: SupportSelectionResult = SupportSelection.select(
			profiles, definitions, null, 1000 + offset
		)
		skills_seen[sampled.skill_id] = true
		supports_seen[sampled.support_id] = true
	_expect(skills_seen.size() == 2, "the seeded first stage produced %d distinct Skills"
		% skills_seen.size())
	_expect(supports_seen.size() == 3, "the seeded second stage produced %d distinct supports"
		% supports_seen.size())

	print("  same seed reproduces the pair over %d calls and %d seeds; 6 of 6 pairs reachable"
		% [REPEAT_CALLS, SEED_SAMPLES])
	_done("the_same_seed_and_inputs_always_agree")


# --- 6. Insertion order and tag order change nothing -------------------------

func _check_insertion_and_tag_order_change_nothing() -> void:
	print("")
	print("--- 6. Catalogue insertion order and tag ordering cannot change a seeded result")

	var profiles: Array[SkillTagProfile] = _two_melee_skills()
	var definitions: Array[SupportDefinition] = _three_melee_supports()

	var mismatched_order: int = 0
	var mismatched_tags: int = 0
	for offset: int in SEED_SAMPLES:
		var seed_value: int = 7000 + offset
		var baseline: SupportSelectionResult = SupportSelection.select(
			profiles, definitions, null, seed_value
		)
		if SupportSelection.select(
			_reversed_profiles(profiles), _reversed_definitions(definitions), null, seed_value
		).describe() != baseline.describe():
			mismatched_order += 1
		if SupportSelection.select(
			_retagged_profiles(profiles), definitions, null, seed_value
		).describe() != baseline.describe():
			mismatched_tags += 1
	_expect(mismatched_order == 0,
		"%d of %d seeds changed answer when the arrays were reversed"
			% [mismatched_order, SEED_SAMPLES])
	_expect(mismatched_tags == 0,
		"%d of %d seeds changed answer when tag order and duplicates changed"
			% [mismatched_tags, SEED_SAMPLES])

	## And the reversal really was a different array, or the check above would be
	## comparing a list with itself.
	var reversed: Array[SupportDefinition] = _reversed_definitions(definitions)
	_expect(reversed.size() == definitions.size()
			and reversed[0].support_id() != definitions[0].support_id(),
		"the reversed definition array is not actually in a different order")
	var retagged: Array[SkillTagProfile] = _retagged_profiles(profiles)
	_expect(retagged[0].tags.size() > profiles[0].tags.size(),
		"the retagged profile did not actually gain duplicate tags")

	print("  %d seeds unchanged under reversed arrays and reversed, duplicated tag lists"
		% SEED_SAMPLES)
	_done("insertion_and_tag_order_change_nothing")


# --- 7. The first stage is uniform over Skills -------------------------------

func _check_the_first_stage_is_uniform_over_skills() -> void:
	print("")
	print("--- 7. Two eligible equipped Skills are selected UNIFORMLY at the first stage")

	var profiles: Array[SkillTagProfile] = _two_melee_skills()
	var definitions: Array[SupportDefinition] = _three_melee_supports()

	var counts: Dictionary = _sweep_skill_tickets(profiles, definitions, null, 600)
	_expect(counts.size() == 2, "the first-stage sweep produced %d distinct Skills" % counts.size())
	_expect(int(counts.get(&"s1_contact", -1)) == 300 and int(counts.get(&"s2_contact", -1)) == 300,
		"the first stage is not uniform over two Skills: %s" % counts)

	## Three Skills, to prove the uniformity is over the CANDIDATE COUNT rather
	## than a coincidence of two.
	var three: Array[SkillTagProfile] = _two_melee_skills()
	three.append(_profile(&"s3_contact",
		[SkillTags.ATTACK, SkillTags.HIT, SkillTags.MELEE] as Array[StringName]))
	var triple: Dictionary = _sweep_skill_tickets(three, definitions, null, 600)
	_expect(triple.size() == 3, "the three-Skill sweep produced %d distinct Skills" % triple.size())
	_expect(int(triple.get(&"s1_contact", -1)) == 200
			and int(triple.get(&"s2_contact", -1)) == 200
			and int(triple.get(&"s3_contact", -1)) == 200,
		"the first stage is not uniform over three Skills: %s" % triple)

	## A Skill with NO eligible support is not a candidate at all, so it neither
	## appears nor dilutes the others.
	var with_ineligible: Array[SkillTagProfile] = _two_melee_skills()
	with_ineligible.append(_profile(&"s4_ranged",
		[SkillTags.SPELL, SkillTags.HIT, SkillTags.PROJECTILE, SkillTags.FIRE]
			as Array[StringName]))
	var filtered: Dictionary = _sweep_skill_tickets(with_ineligible, definitions, null, 600)
	_expect(filtered.size() == 2, "an ineligible Skill entered the first stage: %s" % filtered)
	_expect(int(filtered.get(&"s1_contact", -1)) == 300
			and int(filtered.get(&"s2_contact", -1)) == 300,
		"an ineligible Skill diluted the first stage: %s" % filtered)

	print("  first stage: 300/300 over two Skills, 200/200/200 over three, ineligible excluded")
	_done("the_first_stage_is_uniform_over_skills")


# --- 8. More supports earns no extra first-stage probability -----------------

func _check_more_supports_earns_no_extra_first_stage_probability() -> void:
	print("")
	print("--- 8. A Skill with MORE compatible supports gains no first-stage advantage")

	## `s1` matches exactly one support; `s2` matches all three. If the first
	## stage drew over PAIRS rather than over Skills, `s2` would take three
	## quarters of the draws instead of half.
	var profiles: Array[SkillTagProfile] = []
	profiles.append(_profile(&"s1_contact",
		[SkillTags.ATTACK, SkillTags.HIT, SkillTags.MELEE] as Array[StringName]))
	profiles.append(_profile(&"s2_contact_area", [
		SkillTags.ATTACK, SkillTags.HIT, SkillTags.MELEE, SkillTags.AREA, SkillTags.PHYSICAL,
	] as Array[StringName]))

	var definitions: Array[SupportDefinition] = []
	definitions.append(_definition(&"t1_any_melee", [SkillTags.MELEE] as Array[StringName],
		[] as Array[StringName], 5, {}))
	definitions.append(_definition(&"t2_area_only", [SkillTags.AREA] as Array[StringName],
		[] as Array[StringName], 5, {}))
	definitions.append(_definition(&"t3_area_hit",
		[SkillTags.AREA, SkillTags.HIT] as Array[StringName],
		[] as Array[StringName], 5, {}))

	var eligible_for_first: int = 0
	var eligible_for_second: int = 0
	for definition: SupportDefinition in definitions:
		if definition.allows(profiles[0]):
			eligible_for_first += 1
		if definition.allows(profiles[1]):
			eligible_for_second += 1
	_expect(eligible_for_first == 1 and eligible_for_second == 3,
		"the fixture is wrong: %d and %d eligible supports"
			% [eligible_for_first, eligible_for_second])

	var counts: Dictionary = _sweep_skill_tickets(profiles, definitions, null, 600)
	_expect(int(counts.get(&"s1_contact", -1)) == 300
			and int(counts.get(&"s2_contact_area", -1)) == 300,
		"the Skill with three compatible supports took a different share: %s" % counts)

	## And the same is true when the extra supports are HEAVY as well as many: a
	## second-stage weight must not leak into the first stage.
	var heavy: Array[SupportDefinition] = []
	heavy.append(_definition(&"t1_any_melee", [SkillTags.MELEE] as Array[StringName],
		[] as Array[StringName], 1, {}))
	heavy.append(_definition(&"t2_area_only", [SkillTags.AREA] as Array[StringName],
		[] as Array[StringName], 500, {}))
	heavy.append(_definition(&"t3_area_hit",
		[SkillTags.AREA, SkillTags.HIT] as Array[StringName],
		[] as Array[StringName], 500, {}))
	var weighted: Dictionary = _sweep_skill_tickets(profiles, heavy, null, 600)
	_expect(int(weighted.get(&"s1_contact", -1)) == 300
			and int(weighted.get(&"s2_contact_area", -1)) == 300,
		"a heavy second-stage weight leaked into the first stage: %s" % weighted)

	print("  1 compatible support vs 3: 300/300; and 1 vs 1000 total weight: 300/300")
	_done("more_supports_earns_no_extra_first_stage_probability")


# --- 9. Tag bonuses alter only matching Skills -------------------------------

func _check_tag_bonuses_alter_only_matching_skills() -> void:
	print("")
	print("--- 9. An explicit tag bonus alters ONLY the Skills carrying that tag")

	var bonus_definition: SupportDefinition = _definition(
		&"t1_bonus", [SkillTags.MELEE] as Array[StringName], [] as Array[StringName],
		10, {SkillTags.STRIKE: 90}
	)
	_expect(bonus_definition.problem().is_empty(),
		"the bonus definition reports: %s" % bonus_definition.problem())

	var carries: SkillTagProfile = _profile(&"s1_contact", [
		SkillTags.ATTACK, SkillTags.HIT, SkillTags.MELEE, SkillTags.STRIKE,
	] as Array[StringName])
	var lacks: SkillTagProfile = _profile(&"s2_contact",
		[SkillTags.ATTACK, SkillTags.HIT, SkillTags.MELEE] as Array[StringName])
	_expect(bonus_definition.effective_weight_for(carries) == 100,
		"a Skill carrying the weighted tag resolves to %d, not 100"
			% bonus_definition.effective_weight_for(carries))
	_expect(bonus_definition.effective_weight_for(lacks) == 10,
		"a Skill lacking the weighted tag resolves to %d, not the base 10"
			% bonus_definition.effective_weight_for(lacks))

	## TAG COUNT ALONE MUST NOT MOVE A WEIGHT. A Skill carrying five tags and one
	## carrying three resolve identically when neither carries the weighted tag.
	var wide: SkillTagProfile = _profile(&"s3_contact", [
		SkillTags.ATTACK, SkillTags.HIT, SkillTags.MELEE, SkillTags.AREA, SkillTags.PHYSICAL,
	] as Array[StringName])
	_expect(bonus_definition.effective_weight_for(wide) == 10,
		"a Skill with five tags and no weighted tag resolves to %d, not the base 10"
			% bonus_definition.effective_weight_for(wide))

	## A DUPLICATED TAG MUST NOT PAY TWICE. The weight loop walks the vocabulary
	## rather than the Skill's own array, so this is structural — but a structural
	## guarantee that is never driven is a guarantee nobody has checked.
	var duplicated: SkillTagProfile = _profile(&"s4_contact", [
		SkillTags.MELEE, SkillTags.STRIKE, SkillTags.STRIKE, SkillTags.MELEE, SkillTags.HIT,
	] as Array[StringName])
	_expect(bonus_definition.effective_weight_for(duplicated) == 100,
		"a duplicated weighted tag paid its bonus %d times"
			% ((bonus_definition.effective_weight_for(duplicated) - 10) / 90))

	## An unweighted tag pays nothing however many the Skill carries.
	var unweighted: SupportDefinition = _definition(
		&"t2_plain", [SkillTags.MELEE] as Array[StringName], [] as Array[StringName], 10, {}
	)
	_expect(unweighted.effective_weight_for(carries) == 10,
		"a definition with no bonus resolved to %d" % unweighted.effective_weight_for(carries))

	## The diagnostics report exactly the bonuses that matched, and in the
	## canonical vocabulary order rather than in the order they were written.
	var matched: Dictionary = bonus_definition.matching_bonuses_for(carries)
	_expect(matched.size() == 1 and int(matched.get(SkillTags.STRIKE, 0)) == 90,
		"the matched bonuses are %s" % matched)
	_expect(bonus_definition.matching_bonuses_for(lacks).is_empty(),
		"a bonus matched a Skill that does not carry its tag")

	var two_bonuses: SupportDefinition = _definition(
		&"t3_two", [SkillTags.MELEE] as Array[StringName], [] as Array[StringName],
		10, {SkillTags.PHYSICAL: 5, SkillTags.MELEE: 7}
	)
	var ordered: PackedStringArray = PackedStringArray()
	for tag: Variant in two_bonuses.matching_bonuses_for(wide):
		ordered.append(String(tag))
	_expect(Array(ordered) == ["Melee", "Physical"],
		"the matched bonuses are not in canonical vocabulary order: %s" % ordered)

	## And the bonus changes the LADDER, not merely a reported number.
	var profiles: Array[SkillTagProfile] = []
	profiles.append(carries)
	var definitions: Array[SupportDefinition] = []
	definitions.append(bonus_definition)
	definitions.append(unweighted)
	var counts: Dictionary = _sweep_support_tickets(profiles, definitions, null, 110)
	_expect(int(counts.get(&"t1_bonus", -1)) == 100 and int(counts.get(&"t2_plain", -1)) == 10,
		"the bonus did not move the ticket ladder: %s" % counts)

	print("  bonus +90 applies to the tagged Skill only: 100 vs 10; duplicates pay once")
	_done("tag_bonuses_alter_only_matching_skills")


# --- 10. An acquired pair is removed for its own Skill only ------------------

func _check_an_acquired_pair_is_removed_for_its_own_skill_only() -> void:
	print("")
	print("--- 10. An acquired PAIR is unavailable to its own Skill and to no other")

	var profiles: Array[SkillTagProfile] = _two_melee_skills()
	var definitions: Array[SupportDefinition] = []
	definitions.append(_definition(&"t1_any_melee", [SkillTags.MELEE] as Array[StringName],
		[] as Array[StringName], 10, {}))

	var before: SupportSelectionResult = SupportSelection.select_with_tickets(
		profiles, definitions, null, 0, 0
	)
	_expect(before.ok and before.eligible_skill_count == 2,
		"before acquisition %d Skills were eligible, not 2" % before.eligible_skill_count)

	var acquired: AcquiredSupports = AcquiredSupports.new()
	_expect(acquired.acquire(&"s1_contact", &"t1_any_melee"), "the first acquisition was refused")
	_expect(not acquired.acquire(&"s1_contact", &"t1_any_melee"),
		"the same pair was acquired twice")
	_expect(acquired.size() == 1, "the record holds %d pairs, not 1" % acquired.size())

	## THE OTHER SKILL KEEPS IT. This is the whole reason the record is keyed on
	## the pair: a support-only record would have removed it from both.
	_expect(acquired.has(&"s1_contact", &"t1_any_melee"), "the acquired pair is not recorded")
	_expect(not acquired.has(&"s2_contact", &"t1_any_melee"),
		"acquiring for one Skill also marked it acquired for another")

	var after: SupportSelectionResult = SupportSelection.select_with_tickets(
		profiles, definitions, acquired, 0, 0
	)
	_expect(after.ok, "the selection after acquisition failed: %s" % after.failure_reason)
	_expect(after.eligible_skill_count == 1,
		"%d Skills remained eligible, not 1" % after.eligible_skill_count)
	_expect(after.skill_id == &"s2_contact",
		"the remaining eligible Skill is %s, not the one that had not acquired it"
			% after.skill_id)

	## Every ticket, not merely ticket zero: the excluded Skill must be
	## unreachable rather than merely unlikely.
	var counts: Dictionary = _sweep_skill_tickets(profiles, definitions, acquired, 600)
	_expect(counts.size() == 1 and int(counts.get(&"s2_contact", -1)) == 600,
		"the Skill holding the pair was still reachable: %s" % counts)

	## Acquiring the last available pair for the last Skill leaves nothing, and
	## that is a stated refusal rather than an empty success.
	_expect(acquired.acquire(&"s2_contact", &"t1_any_melee"), "the second acquisition was refused")
	var exhausted: SupportSelectionResult = SupportSelection.select_with_tickets(
		profiles, definitions, acquired, 0, 0
	)
	_expect(not exhausted.ok, "an exhausted catalogue still returned a selection")
	_expect(exhausted.failure_reason.contains("2 pair(s) already acquired"),
		"the exhaustion reason does not name the acquired pairs: %s" % exhausted.failure_reason)
	_expect_coherent(exhausted)

	## A separator character in an identifier cannot merge two different pairs,
	## because the record has no separator to merge on.
	var tricky: AcquiredSupports = AcquiredSupports.new()
	tricky.acquire(&"a|b", &"c")
	_expect(not tricky.has(&"a", &"b|c"),
		"two different pairs collided through a joined key")
	_expect(tricky.release(&"a|b", &"c") and tricky.is_empty(),
		"the released pair was not removed")

	print("  acquired s1 -> t1: s1 unreachable over 600 tickets, s2 keeps it; exhaustion refuses")
	_done("an_acquired_pair_is_removed_for_its_own_skill_only")


# --- 11. Every invalid case fails closed -------------------------------------

func _check_every_invalid_case_fails_closed() -> void:
	print("")
	print("--- 11. Every invalid definition and every empty case FAILS CLOSED with a reason")

	var profiles: Array[SkillTagProfile] = []
	profiles.append(_profile(&"s1_contact",
		[SkillTags.ATTACK, SkillTags.HIT, SkillTags.MELEE] as Array[StringName]))
	var legal: SupportDefinition = _definition(&"t1_any_melee",
		[SkillTags.MELEE] as Array[StringName], [] as Array[StringName], 10, {})

	## A POSITIVE CONTROL FIRST. A guard that refuses everything protects
	## nothing, so the legal case must be shown to succeed before any refusal
	## means anything.
	var control: Array[SupportDefinition] = []
	control.append(legal)
	var accepted: SupportSelectionResult = SupportSelection.select_with_tickets(
		profiles, control, null, 0, 0
	)
	_expect(accepted.ok, "the positive control was refused: %s" % accepted.failure_reason)

	var cases: Array = [
		["a base weight below 1",
			_definition(&"t2_zero", [SkillTags.MELEE] as Array[StringName],
				[] as Array[StringName], 0, {}), "below the minimum"],
		["a negative base weight",
			_definition(&"t2_negative", [SkillTags.MELEE] as Array[StringName],
				[] as Array[StringName], -5, {}), "below the minimum"],
		["a negative tag bonus",
			_definition(&"t2_negative_bonus", [SkillTags.MELEE] as Array[StringName],
				[] as Array[StringName], 10, {SkillTags.STRIKE: -1}), "must not be negative"],
		["an unknown weighted tag",
			_definition(&"t2_unknown_bonus", [SkillTags.MELEE] as Array[StringName],
				[] as Array[StringName], 10, {&"NotATag": 5}), "not a recognised tag"],
		["a non-integer bonus",
			_definition(&"t2_float_bonus", [SkillTags.MELEE] as Array[StringName],
				[] as Array[StringName], 10, {SkillTags.MELEE: 1.5}), "not an integer"],
		["a bonus key that is not a tag identifier",
			_definition(&"t2_string_key", [SkillTags.MELEE] as Array[StringName],
				[] as Array[StringName], 10, {"Melee": 5}), "not a tag identifier"],
		["a missing stable id",
			_definition(&"", [SkillTags.MELEE] as Array[StringName],
				[] as Array[StringName], 10, {}), "support_id"],
		["a maximum possible weight above the ceiling",
			_definition(&"t2_ceiling", [SkillTags.MELEE] as Array[StringName],
				[] as Array[StringName], SupportDefinition.MAXIMUM_WEIGHT,
				{SkillTags.MELEE: 1}), "exceeds the ceiling"],
		["a rule stating nothing at all",
			_definition(&"t2_silent", [] as Array[StringName],
				[] as Array[StringName], 10, {}), "at least one requirement"],
	]
	for entry: Array in cases:
		var described: String = entry[0]
		var broken: SupportDefinition = entry[1]
		var expected: String = entry[2]
		_expect(broken.problem().contains(expected),
			"%s reported '%s', which does not name '%s'"
				% [described, broken.problem(), expected])
		var mixed: Array[SupportDefinition] = []
		mixed.append(legal)
		mixed.append(broken)
		var refused: SupportSelectionResult = SupportSelection.select_with_tickets(
			profiles, mixed, null, 0, 0
		)
		## THE WHOLE SELECTION IS REFUSED RATHER THAN THE BAD RECORD SKIPPED. A
		## skipped record would silently remove a support from the game while
		## every offer still looked normal.
		_expect(not refused.ok,
			"%s was silently skipped and a selection was still returned" % described)
		_expect(refused.failure_reason.contains(expected),
			"%s produced the reason '%s'" % [described, refused.failure_reason])
		_expect_no_partial_result(refused, described)

	## A duplicate stable id.
	var duplicated: Array[SupportDefinition] = []
	duplicated.append(legal)
	duplicated.append(_definition(&"t1_any_melee", [SkillTags.MELEE] as Array[StringName],
		[] as Array[StringName], 20, {}))
	var duplicate_result: SupportSelectionResult = SupportSelection.select_with_tickets(
		profiles, duplicated, null, 0, 0
	)
	_expect(not duplicate_result.ok and duplicate_result.failure_reason.contains("duplicate support id"),
		"a duplicate support id produced: %s" % duplicate_result.describe())
	_expect_no_partial_result(duplicate_result, "a duplicate support id")

	## A duplicate Skill id, which is the same defect on the other argument.
	var duplicate_skills: Array[SkillTagProfile] = []
	duplicate_skills.append(profiles[0])
	duplicate_skills.append(_profile(&"s1_contact", [SkillTags.MELEE] as Array[StringName]))
	var duplicate_skill_result: SupportSelectionResult = SupportSelection.select_with_tickets(
		duplicate_skills, control, null, 0, 0
	)
	_expect(not duplicate_skill_result.ok
			and duplicate_skill_result.failure_reason.contains("duplicate Skill id"),
		"a duplicate Skill id produced: %s" % duplicate_skill_result.describe())

	## The empty and null cases.
	var empty_profiles: Array[SkillTagProfile] = []
	var empty_definitions: Array[SupportDefinition] = []
	var null_definition: Array[SupportDefinition] = []
	null_definition.append(null)
	var null_profile: Array[SkillTagProfile] = []
	null_profile.append(null)
	var incoherent_profile: Array[SkillTagProfile] = []
	incoherent_profile.append(SkillTagProfile.of(&"s9_bad", "Bad",
		[&"NotATag"] as Array[StringName]))
	var no_eligible: Array[SkillTagProfile] = []
	no_eligible.append(_profile(&"s9_ranged",
		[SkillTags.SPELL, SkillTags.HIT, SkillTags.PROJECTILE] as Array[StringName]))

	var empties: Array = [
		["no equipped Skills", SupportSelection.select_with_tickets(
			empty_profiles, control, null, 0, 0), "no equipped Skill profiles"],
		["no support definitions", SupportSelection.select_with_tickets(
			profiles, empty_definitions, null, 0, 0), "no support definitions"],
		["a null definition", SupportSelection.select_with_tickets(
			profiles, null_definition, null, 0, 0), "is null"],
		["a null profile", SupportSelection.select_with_tickets(
			null_profile, control, null, 0, 0), "is null"],
		["an incoherent profile", SupportSelection.select_with_tickets(
			incoherent_profile, control, null, 0, 0), "unrecognised tag"],
		["an empty eligible candidate set", SupportSelection.select_with_tickets(
			no_eligible, control, null, 0, 0), "no equipped Skill has an available"],
		["a negative ticket", SupportSelection.select_with_tickets(
			profiles, control, null, -1, 0), "must not be negative"],
	]
	for entry: Array in empties:
		var described: String = entry[0]
		var result: SupportSelectionResult = entry[1]
		var expected: String = entry[2]
		_expect(not result.ok, "%s returned a selection" % described)
		_expect(result.failure_reason.contains(expected),
			"%s produced the reason '%s'" % [described, result.failure_reason])
		_expect_no_partial_result(result, described)

	## THE CEILING IS THE SEED STREAM'S OWN WIDTH (D-236), AND THAT EQUALITY IS
	## WHAT IS PINNED — not the number. A ceiling wider than the stream would
	## leave every support past the stream's reach unselectable from a seed,
	## silently: `support_ticket % total` returns the ticket unchanged once the
	## total exceeds it, so the draw still looks perfectly ordinary.
	_expect(SupportSelection.MAXIMUM_TOTAL_WEIGHT == REACHABLE_TICKET_CEILING,
		"the total-weight ceiling is %d, not the stream's reachable width %d" % [
			SupportSelection.MAXIMUM_TOTAL_WEIGHT, REACHABLE_TICKET_CEILING,
		])

	## And the stream really is that wide, measured rather than assumed: every
	## seeded ticket over the corpus lands inside [0, ceiling], in both stages.
	var outside: PackedStringArray = PackedStringArray()
	for row: Array in SHIPPED_SEED_CORPUS:
		var seed_value: int = int(row[0])
		for produced: int in [
			SupportSelection.skill_ticket_for(seed_value),
			SupportSelection.support_ticket_for(seed_value),
		]:
			if produced < 0 or produced > REACHABLE_TICKET_CEILING:
				outside.append("seed %d produced %d" % [seed_value, produced])
	_expect(outside.is_empty(),
		"a seeded ticket left [0, %d]: %s" % [REACHABLE_TICKET_CEILING, ", ".join(outside)])

	## THE TOTAL-WEIGHT CEILING IS REACHABLE, AND PROVED IN BOTH DIRECTIONS. A
	## guard nothing can reach is not a guard; a guard that refuses the legal
	## case beside it is worse than none.
	var at_ceiling: Array[SupportDefinition] = _definitions_totalling(
		SupportSelection.MAXIMUM_TOTAL_WEIGHT
	)
	var over_ceiling: Array[SupportDefinition] = _definitions_totalling(
		SupportSelection.MAXIMUM_TOTAL_WEIGHT + 1
	)
	var accepted_ceiling: SupportSelectionResult = SupportSelection.select_with_tickets(
		profiles, at_ceiling, null, 0, 0
	)
	_expect(accepted_ceiling.ok,
		"exactly the ceiling was refused: %s" % accepted_ceiling.failure_reason)
	_expect(accepted_ceiling.total_eligible_weight == SupportSelection.MAXIMUM_TOTAL_WEIGHT,
		"the at-ceiling total is %d" % accepted_ceiling.total_eligible_weight)
	var refused_ceiling: SupportSelectionResult = SupportSelection.select_with_tickets(
		profiles, over_ceiling, null, 0, 0
	)
	_expect(not refused_ceiling.ok and refused_ceiling.failure_reason.contains("exceed the ceiling"),
		"one weight past the ceiling produced: %s" % refused_ceiling.describe())
	## THE REASON MUST BE USEFUL, not merely present: it names the Skill whose
	## pool overflowed and quotes the ceiling it overflowed.
	_expect(refused_ceiling.failure_reason.contains(str(SupportSelection.MAXIMUM_TOTAL_WEIGHT)),
		"the ceiling refusal does not quote the ceiling: %s" % refused_ceiling.failure_reason)
	_expect(refused_ceiling.failure_reason.contains(String(profiles[0].skill_id)),
		"the ceiling refusal does not name the Skill: %s" % refused_ceiling.failure_reason)
	_expect_no_partial_result(refused_ceiling, "a total weight past the ceiling")

	## The two pools differ by exactly one unit of weight, so the refusal above
	## is an off-by-one away from the acceptance beside it rather than a
	## comfortable distance from it.
	var accepted_total: int = 0
	for definition: SupportDefinition in at_ceiling:
		accepted_total += definition.base_weight
	var refused_total: int = 0
	for definition: SupportDefinition in over_ceiling:
		refused_total += definition.base_weight
	_expect(refused_total == accepted_total + 1,
		"the two ceiling pools differ by %d, not 1" % (refused_total - accepted_total))

	print("  9 invalid definitions, 2 duplicate ids, 7 empty or null cases; "
		+ "the ceiling is the stream width %d, accepted exactly and refused at +1"
			% SupportSelection.MAXIMUM_TOTAL_WEIGHT)
	_done("every_invalid_case_fails_closed")


# --- 12. The selector is generic and reads nothing ambient -------------------

func _check_the_selector_is_generic_and_reads_nothing_ambient() -> void:
	print("")
	print("--- 12. The selector names NO Skill, class or support, and reads nothing ambient")

	for path: String in GENERIC_FILES:
		var source: String = FileAccess.get_file_as_string(path)
		_expect(not source.is_empty(), "%s could not be read" % path)
		var named: PackedStringArray = PackedStringArray()
		for token: String in FORBIDDEN_TOKENS:
			if source.contains(token):
				named.append(token)
		_expect(named.is_empty(),
			"%s names %s — a generic selector must name no Skill, class or support"
				% [path.get_file(), ", ".join(named)])
		var ambient: PackedStringArray = PackedStringArray()
		for token: String in AMBIENT_TOKENS:
			if source.contains(token):
				ambient.append(token)
		_expect(ambient.is_empty(),
			"%s reads ambient state: %s" % [path.get_file(), ", ".join(ambient)])

	## AND THE SCAN IS PROVED CAPABLE OF FAILING. A token list that matched
	## nothing anywhere would pass over any file at all, so it is shown finding
	## the very things it looks for in the one file that legitimately holds them.
	var catalogue: String = FileAccess.get_file_as_string(PERMITTED_CONSUMER)
	var found_in_catalogue: int = 0
	for token: String in FORBIDDEN_TOKENS:
		if catalogue.contains(token):
			found_in_catalogue += 1
	_expect(found_in_catalogue >= 4,
		"the forbidden-token scan found only %d of its tokens in the file that does name them"
			% found_in_catalogue)

	## The selection is pure: repeated calls agree and neither argument is
	## mutated. Purity is what makes a seeded claim reproducible across a
	## session, a process and a machine.
	var profiles: Array[SkillTagProfile] = _two_melee_skills()
	var definitions: Array[SupportDefinition] = _three_melee_supports()
	var tags_before: Array[StringName] = profiles[0].tags.duplicate()
	var bonuses_before: Dictionary = definitions[0].tag_bonuses.duplicate()
	var weight_before: int = definitions[0].base_weight
	var acquired: AcquiredSupports = AcquiredSupports.new()

	var first: SupportSelectionResult = SupportSelection.select(
		profiles, definitions, acquired, 4242
	)
	var drifted: int = 0
	for call: int in REPEAT_CALLS:
		if SupportSelection.select(profiles, definitions, acquired, 4242).describe() \
				!= first.describe():
			drifted += 1
	_expect(drifted == 0, "%d of %d repeated calls disagreed" % [drifted, REPEAT_CALLS])
	_expect(profiles[0].tags == tags_before, "the selection mutated a Skill's tag list")
	_expect(definitions[0].tag_bonuses == bonuses_before,
		"the selection mutated a definition's tag bonuses")
	_expect(definitions[0].base_weight == weight_before,
		"the selection mutated a definition's base weight")
	## SELECTING IS NOT ACQUIRING. The selector reports a pair; recording it is
	## the caller's decision, and a selector that quietly acquired what it drew
	## could never be asked the same question twice.
	_expect(acquired.is_empty(), "the selection recorded an acquisition by itself")

	## The two seeded streams are separate functions of the seed and are not
	## equal to each other.
	var identical: int = 0
	for offset: int in SEED_SAMPLES:
		if SupportSelection.skill_ticket_for(offset) == SupportSelection.support_ticket_for(offset):
			identical += 1
		if SupportSelection.skill_ticket_for(offset) < 0 \
				or SupportSelection.support_ticket_for(offset) < 0:
			drifted += 1
	_expect(identical == 0, "%d of %d seeds produced the same ticket for both stages"
		% [identical, SEED_SAMPLES])
	_expect(drifted == 0, "a stream produced a negative ticket")

	print("  %d generic files name nothing concrete and read nothing ambient; %d pure calls agree"
		% [GENERIC_FILES.size(), REPEAT_CALLS])
	_done("the_selector_is_generic_and_reads_nothing_ambient")


# --- 13. Nothing that already existed changed --------------------------------

func _check_nothing_existing_changed() -> void:
	print("")
	print("--- 13. Nothing that already existed changed, and the selector is UNWIRED")

	## THE SELECTOR IS NOT WIRED INTO ANYTHING. Only the shipped catalogue may
	## name a Foundation B class, and it may name only the definition record —
	## the selector, the result and the acquisition record are reachable from no
	## running code at all.
	var referenced: PackedStringArray = PackedStringArray()
	var scanned: int = 0
	for root: String in ["res://scripts", "res://scenes", "res://data", "res://addons"]:
		for path: String in _files_under(root, [".gd", ".tscn", ".tres"]):
			if FOUNDATION_B_FILES.has(path):
				continue
			scanned += 1
			var source: String = FileAccess.get_file_as_string(path)
			for name: String in FOUNDATION_B_CLASSES:
				if not source.contains(name):
					continue
				if _is_authorized_reader(path, name):
					continue
				referenced.append("%s names %s" % [path.get_file(), name])
	_expect(referenced.is_empty(),
		"Foundation B is referenced by code that runs: %s" % ", ".join(referenced))
	_expect(FileAccess.get_file_as_string(PERMITTED_CONSUMER).contains("SupportDefinition"),
		"the shipped catalogue does not build a weighted definition, so the scan above proves nothing")

	## Foundation A still answers exactly as it did.
	_expect(SkillSupportCatalogue.supports().size() == 2,
		"the catalogue holds %d eligibility rules, not 2"
			% SkillSupportCatalogue.supports().size())
	_expect(SkillSupportCatalogue.skill_profiles().size() == 1,
		"the catalogue holds %d Skill profiles, not 1"
			% SkillSupportCatalogue.skill_profiles().size())
	_expect(SkillSupportCatalogue.eligible_supports_for(
			SkillSupportCatalogue.quick_strike_profile()).size() == 2,
		"the shipped Skill is no longer accepted by both shipped supports")

	## Build Variety V1's own values, unmoved.
	_expect(RogueliteUpgrade.POOL.size() == 4,
		"the upgrade pool holds %d entries, not 4" % RogueliteUpgrade.POOL.size())
	_expect(is_equal_approx(RogueliteUpgrade.REACHING_EDGE_REACH, 2.65),
		"REACHING_EDGE_REACH moved to %.4f" % RogueliteUpgrade.REACHING_EDGE_REACH)
	_expect(is_equal_approx(RogueliteUpgrade.SWEEPING_EDGE_ARC_DEGREES, 180.0),
		"SWEEPING_EDGE_ARC_DEGREES moved to %.4f" % RogueliteUpgrade.SWEEPING_EDGE_ARC_DEGREES)
	_expect(is_equal_approx(RogueliteUpgrade.SWEEPING_EDGE_SOFT_CONE_DEGREES, 110.0),
		"SWEEPING_EDGE_SOFT_CONE_DEGREES moved to %.4f"
			% RogueliteUpgrade.SWEEPING_EDGE_SOFT_CONE_DEGREES)
	_expect(SkillSupportCatalogue.REACHING_EDGE_NAME
			== RogueliteUpgrade.name_of(RogueliteUpgrade.Kind.REACHING_EDGE)
			and SkillSupportCatalogue.SWEEPING_EDGE_NAME
			== RogueliteUpgrade.name_of(RogueliteUpgrade.Kind.SWEEPING_EDGE),
		"a shipped display name disagrees with the review's own name")

	## The canonical combat record, untouched.
	var canonical: QuickStrikeData = load(CANONICAL_QUICK_STRIKE) as QuickStrikeData
	_expect(canonical != null, "the canonical Quick Strike record failed to load")
	_expect(is_equal_approx(canonical.reach, 1.65), "reach moved to %.4f" % canonical.reach)
	_expect(is_equal_approx(canonical.release_arc_degrees, 100.0),
		"release_arc_degrees moved to %.4f" % canonical.release_arc_degrees)
	_expect(is_equal_approx(canonical.soft_target_cone_degrees, 65.0),
		"soft_target_cone_degrees moved to %.4f" % canonical.soft_target_cone_degrees)
	_expect(canonical.maximum_targets == 1,
		"maximum_targets moved to %d" % canonical.maximum_targets)

	## The entrypoint and the InputMap, untouched. Counted exactly as every
	## existing suite counts it.
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

	print("  %d project files scanned, only the catalogue names a Foundation B class; 31 actions"
		% scanned)
	_done("nothing_existing_changed")


# --- Fixtures ----------------------------------------------------------------
#
# Generic and test-only: registered in no catalogue, saved in no resource, and
# not canon. They are the second and third Skills the project does not have yet.

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


func _profile(id: StringName, tags: Array[StringName]) -> SkillTagProfile:
	return SkillTagProfile.of(id, "Test Skill %s" % id, tags)


## THE MAXIMUM RANK EVERY FIXTURE DEFINITION DECLARES (Foundation I5, D-301). A
## usable maximum is part of a definition's validity, so a fixture that declared
## none would be refused by every selection; this suite never raises a rank, and the
## value is test data rather than balance. Every invalid case below keeps its own
## fault, which `problem()` still reports first.
const FIXTURE_MAXIMUM_RANK: int = 1000


func _definition(
	id: StringName,
	required_all: Array[StringName],
	excluded: Array[StringName],
	weight: int,
	bonuses: Dictionary
) -> SupportDefinition:
	return SupportDefinition.of(
		SupportEligibility.of(id, "Test Support %s" % id, required_all,
			[] as Array[StringName], excluded),
		weight, bonuses, FIXTURE_MAXIMUM_RANK
	)


func _two_melee_skills() -> Array[SkillTagProfile]:
	var out: Array[SkillTagProfile] = []
	out.append(_profile(&"s1_contact", [
		SkillTags.ATTACK, SkillTags.HIT, SkillTags.MELEE, SkillTags.STRIKE, SkillTags.PHYSICAL,
	] as Array[StringName]))
	out.append(_profile(&"s2_contact", [
		SkillTags.ATTACK, SkillTags.HIT, SkillTags.MELEE, SkillTags.PHYSICAL,
	] as Array[StringName]))
	return out


func _three_melee_supports() -> Array[SupportDefinition]:
	var out: Array[SupportDefinition] = []
	out.append(_definition(&"t1_light", [SkillTags.MELEE] as Array[StringName],
		[] as Array[StringName], 5, {}))
	out.append(_definition(&"t2_medium", [SkillTags.MELEE] as Array[StringName],
		[] as Array[StringName], 7, {}))
	out.append(_definition(&"t3_heavy", [SkillTags.MELEE] as Array[StringName],
		[] as Array[StringName], 11, {}))
	return out


## A pool whose weights sum to EXACTLY `total`, built from full per-definition
## chunks plus one remainder.
##
## IT TAKES A TARGET RATHER THAN A COUNT (D-236). The earlier helper took a
## count and relied on the total ceiling being an exact multiple of the
## per-definition ceiling — true of the round 10^12, and not true of the stream
## width that replaced it. Deriving the pool from the ceiling itself means this
## helper stays correct for any ceiling, and the ceiling's VALUE is pinned
## separately below rather than being smuggled in through a magic count.
func _definitions_totalling(total: int) -> Array[SupportDefinition]:
	var out: Array[SupportDefinition] = []
	var remaining: int = total
	var index: int = 0
	while remaining > 0:
		var weight: int = mini(remaining, SupportDefinition.MAXIMUM_WEIGHT)
		out.append(_definition(StringName("t%04d_bulk" % index),
			[SkillTags.MELEE] as Array[StringName], [] as Array[StringName],
			weight, {}))
		remaining -= weight
		index += 1
	return out


func _reversed_profiles(profiles: Array[SkillTagProfile]) -> Array[SkillTagProfile]:
	var out: Array[SkillTagProfile] = []
	for index: int in range(profiles.size() - 1, -1, -1):
		out.append(profiles[index])
	return out


func _reversed_definitions(definitions: Array[SupportDefinition]) -> Array[SupportDefinition]:
	var out: Array[SupportDefinition] = []
	for index: int in range(definitions.size() - 1, -1, -1):
		out.append(definitions[index])
	return out


## The same Skills with their tag lists reversed AND every tag duplicated, so
## both of the things a tag list can vary by are varied at once.
func _retagged_profiles(profiles: Array[SkillTagProfile]) -> Array[SkillTagProfile]:
	var out: Array[SkillTagProfile] = []
	for profile: SkillTagProfile in profiles:
		var scrambled: Array[StringName] = []
		for index: int in range(profile.tags.size() - 1, -1, -1):
			scrambled.append(profile.tags[index])
			scrambled.append(profile.tags[index])
		out.append(SkillTagProfile.of(profile.skill_id, profile.display_name, scrambled))
	return out


# --- Enumeration helpers -----------------------------------------------------
#
# Every distribution claim in this suite is made by walking EVERY ticket in
# range and counting, never by sampling.

func _sweep_support_tickets(
	profiles: Array[SkillTagProfile],
	definitions: Array[SupportDefinition],
	acquired: AcquiredSupports,
	total: int
) -> Dictionary:
	var counts: Dictionary = {}
	for ticket: int in total:
		var result: SupportSelectionResult = SupportSelection.select_with_tickets(
			profiles, definitions, acquired, 0, ticket
		)
		if not result.ok:
			counts[&"<refused>"] = int(counts.get(&"<refused>", 0)) + 1
			continue
		counts[result.support_id] = int(counts.get(result.support_id, 0)) + 1
	return counts


func _sweep_skill_tickets(
	profiles: Array[SkillTagProfile],
	definitions: Array[SupportDefinition],
	acquired: AcquiredSupports,
	tickets: int
) -> Dictionary:
	var counts: Dictionary = {}
	for ticket: int in tickets:
		var result: SupportSelectionResult = SupportSelection.select_with_tickets(
			profiles, definitions, acquired, ticket, 0
		)
		if not result.ok:
			counts[&"<refused>"] = int(counts.get(&"<refused>", 0)) + 1
			continue
		counts[result.skill_id] = int(counts.get(result.skill_id, 0)) + 1
	return counts


# --- Plumbing ----------------------------------------------------------------

func _expect_coherent(result: SupportSelectionResult) -> void:
	_expect(result.problem().is_empty(),
		"the result is internally incoherent: %s" % result.problem())


## A refusal must carry NO partial selection: no id, no weight, no ticket. This
## is the assertion that stops a caller reading a Skill out of a result that
## never selected one.
func _expect_no_partial_result(result: SupportSelectionResult, described: String) -> void:
	_expect(result.problem().is_empty(),
		"%s produced a partial result: %s" % [described, result.problem()])
	_expect(String(result.skill_id).is_empty() and String(result.support_id).is_empty()
			and result.effective_weight == 0 and result.total_eligible_weight == 0
			and result.rolled_ticket == 0 and result.eligible_skill_count == 0,
		"%s left selection fields populated: %s" % [described, result.describe()])


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
