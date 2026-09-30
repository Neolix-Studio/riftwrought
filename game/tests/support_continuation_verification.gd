extends SceneTree
## Riftwrought — Roguelite Foundation F2 verification: Deterministic
## Support-Lane Continuation Selection.
##
## ONE FOCUSED HEADLESS TEST. The foundation is two pure-logic scripts that
## delegate every drawing decision to the accepted weighted selector, so it
## needs no scene, no camera, no navigation, no rendering and no evidence frame,
## and it deliberately gets none. It runs as a `SceneTree` script exactly as
## Foundations A, B, C3, D1, D2, D3, E1, E2 and F1 do.
##
## IT PORTS THE OWED-SET DISCIPLINE. Every check function records reaching its
## LAST line, and the suite compares that set against what it owes in BOTH
## directions, so a check that dies half way cannot leave a green run behind it.
##
## EVERY DISTRIBUTION CLAIM IS WALKED, NEVER SAMPLED. The continuation selector
## takes a SEED and has no ticket-level entry point of its own — deliberately,
## because a second public stream would be a second place a decision could be
## made. So a claim about ticket ownership is walked on the ACCEPTED selector's
## own ticket ladder, and F2's agreement with that ladder is then asserted PER
## SEED by exact equality of the whole derivation. Composing an exact ladder
## with an exact per-seed equality is a stronger statement than either half.
##
## THE FIXTURES BELOW ARE NOT PLAYABLE CONTENT. They exist inside this file
## only, are registered in no catalogue, ship in no scene, no `.tres` and no
## library, and are not canon. They are `zz_` prefixed so they can never be
## mistaken for content and so a future catalogue entry cannot collide with one.
##
## THE RANK PHASE IS BOUNDED SINCE FOUNDATION I5 (D-300), AND THIS SUITE'S RANK
## CLAIMS ARE MADE BELOW THE MAXIMUM. Every fixture definition declares
## `FIXTURE_MAXIMUM_RANK`, far above every rank this suite holds a pair at, so the
## rank phase is reachable exactly where it always was and each rank claim here is
## a claim about pairs that can still be raised. The rank decision is now the
## accepted selector's RANK-INCREASE draw against the real record, so checks 4, 9
## and 12 ask that draw directly — moved one for one from the empty-record draw
## that was the rank phase before a maximum existed. What happens AT a maximum —
## filtering, exhaustion and its classification — is the I5 suite's to prove.

const F2_FILES: Array[String] = [
	"res://scripts/continuation/support_continuation_result.gd",
	"res://scripts/continuation/support_continuation.gd",
]

const CONTINUATION_FILE: String = "res://scripts/continuation/support_continuation.gd"
const RESULT_FILE: String = "res://scripts/continuation/support_continuation_result.gd"

## The two global class names F2 introduces. Nothing that runs may name either
## except an authorized reader below.
const F2_CLASSES: Array[String] = ["SupportContinuationResult", "SupportContinuation"]

## THE FILES AUTHORIZED TO NAME A FOUNDATION F2 CLASS, AND THE EXACT CLASSES EACH
## MAY NAME (Foundation F3, decision D-255). The accepted three-lane offer composer DELEGATES its
## whole support lane to this decision, so it names the selector and the record
## that decision comes back in; the accepted offer RETAINS that record and reads
## its mechanical kind, so it names the record. Neither may name the other's, and
## nothing else may name either.
##
## ONE SUBSTRING IS RECORDED RATHER THAN LEFT TO BE FOUND: `SupportContinuation`
## is contained in `SupportContinuationResult`, so a file naming the record is
## reported as naming the selector too, and a grant for the record must carry
## both. The stronger property — that the OFFER never CALLS the selector — is
## asserted by the Foundation D1 and F3 suites, which own that boundary.
##
## THIS REPLACES THE BLANKET "no project file names either class" ONE FOR ONE:
## the same single assertion is made either way, it still fails for any other
## file AND for any class a listed file is not granted, and the pinned count does
## not move.
##
## TWO MORE READERS SINCE FOUNDATION F4 (decision D-257), AND BOTH READ THE
## RECORD'S DECLARATIONS RATHER THAN MAKING ITS DECISION. The accepted choice
## transaction routes on the progression kind an offer FROZE, so it names the two
## operations where they are declared — inferring which one an offer meant from
## anything else would be a second, subtly different copy of this policy — and the
## choice RESULT names the record for its own `kind_label()`, so a decision, an
## offer and a choice can never name one operation three different ways. Neither
## may CALL `SupportContinuation.select`, which is asserted by the Foundation D3
## suite where that boundary belongs.
##
## ONE MORE READER SINCE FOUNDATION F5 (decision D-260), AND IT READS FOR THE SAME
## ONE REASON THE CHOICE RESULT DOES. The level-up receipt now carries the Support
## progression its choice consumed and renders it through this record's own
## `kind_label()`, so a decision, an offer, a choice and its level-up can never
## name one operation four different ways. It makes no decision and CALLS no
## selector, which the Foundation F5 suite asserts by name. Same single assertion,
## same count.
const AUTHORIZED_READERS: Array = [
	["res://scripts/offers/rift_offer_composition.gd", [
		"SupportContinuationResult", "SupportContinuation",
	]],
	["res://scripts/offers/rift_offer.gd", [
		"SupportContinuationResult", "SupportContinuation",
	]],
	["res://scripts/choices/rift_offer_choice.gd", [
		"SupportContinuationResult", "SupportContinuation",
	]],
	["res://scripts/choices/rift_offer_choice_result.gd", [
		"SupportContinuationResult", "SupportContinuation",
	]],
	["res://scripts/levels/rift_level_up_result.gd", [
		"SupportContinuationResult", "SupportContinuation",
	]],
	## ONE MORE READER SINCE ROGUELITE FOUNDATION I6 (decision D-304), AND IT READS
	## THE RECORD'S CLASSIFICATION RATHER THAN MAKING ITS DECISION. The
	## exhausted-support passive fallback is handed a continuation result and may
	## activate only when that record is coherent and classified exhausted by its
	## own predicate, so it names the record — and, by the substring above, the
	## selector. It CALLS no selector of this foundation. Same single assertion,
	## same count.
	["res://scripts/fallback/support_exhaustion_passive_fallback.gd", [
		"SupportContinuationResult", "SupportContinuation",
	]],
]

## Concrete Skill, support, card, catalogue and instrument names. A file that
## must hold no Skill-specific knowledge may name none of them, in code OR in a
## comment — an illustrative name in a comment breaches the rule just as surely
## as a real one, because the rule exists so a reader can trust the file holds
## none.
const FORBIDDEN_TOKENS: Array[String] = [
	"quick_strike", "Quick Strike", "QuickStrike",
	"reaching_edge", "Reaching Edge", "sweeping_edge", "Sweeping Edge",
	"RogueliteUpgrade", "Expedition Blade", "Quickened Edge",
	"SkillSupportCatalogue", "FirstMvpSkill",
	"Graveblade", "Riftfall", "BrokenWatch",
]

## A deterministic, pure selector may read no ambient state whatsoever.
const AMBIENT_TOKENS: Array[String] = [
	"randi", "randf", "randomize", "RandomNumberGenerator", "rand_from_seed",
	"Time.", "OS.", "Engine.", "ProjectSettings", "InputMap",
	"FileAccess", "ConfigFile", "ResourceSaver", "ResourceLoader", "user://",
]

## THE SIX RANKED-OWNERSHIP MEMBERS F2 MUST NEVER CALL. Ranks do not change
## eligibility, weight, probability or ticket arithmetic here, so a rank must
## not be readable from inside a selection decision at all — which is asserted
## by name rather than argued. F2 asks only whether a pair is HELD.
const RANK_MEMBER_TOKENS: Array[String] = [
	"rank_for(", "increase_rank(", "total_ranks(",
	"rank_support(", "support_rank_for(", "total_support_ranks(",
]

## THE DEFERRED CONCEPTS, BY TOKEN. Each names something F2 explicitly does not
## implement, and each arrives as a plausible-looking member rather than as an
## obvious mistake. Asked of the CODE ONLY: saying in a comment that a concept is
## deliberately absent is exactly the documentation this project wants, while
## CALLING one is the fault.
##
## `"lane"` IS DELIBERATELY NOT ON THIS LIST, and the omission is recorded rather
## than left to look like a gap. The support LANE is this foundation's own
## subject — the brief names it in its own title — so forbidding the word here
## would forbid the file from saying what it is. What a lane could actually be
## COMPOSED into is refused instead, by name, through the offer, run-build,
## level-up and card tokens below.
const DEFERRED_TOKENS: Array[String] = [
	"rank_cap", "max_rank", "maximum_rank", "diminish",
	"rarity", "luck", "pity", "reroll", "refund", "synergy",
	"RiftOffer", "RiftRunBuild", "RiftLevelUp", "PassiveCard",
	"experience", "mote", "level", "xp", "offer", "consume",
	"save", "persist", "storage", "schema",
	"magnitude", "apply(",
]

## The classes each F2 file is entitled to name, asked of the ENGINE's own
## global class list rather than of a denylist somebody has to remember to
## extend.
const AUTHORIZED_CLASSES: Array = [
	[RESULT_FILE, [
		"SupportContinuationResult", "SupportContinuation",
		"SupportSelectionResult", "SupportSelection",
	]],
	[CONTINUATION_FILE, [
		"SupportContinuationResult", "SupportContinuation",
		"SupportSelectionResult", "SupportSelection",
		"SupportDefinition", "AcquiredSupports", "SkillTagProfile",
	]],
]

## THE TWO ACCEPTED SUITES WHOSE ALLOWLISTS F2 MOVED ONE FOR ONE, and the exact
## grants each must now carry. Read from those suites' own sources: a grant
## nobody can see is a grant that quietly stops meaning anything.
const AUTHORIZING_SUITES: Array = [
	["res://tests/skill_tag_eligibility_verification.gd", "A", [CONTINUATION_FILE]],
	["res://tests/support_selection_verification.gd", "B", [CONTINUATION_FILE, RESULT_FILE]],
]

const SCANNED_ROOTS: Array[String] = [
	"res://scripts", "res://scenes", "res://data", "res://addons",
]

const PROJECT_SETTINGS_FILE: String = "res://project.godot"
const CANONICAL_QUICK_STRIKE: String = "res://data/prototype_zero/quick_strike.tres"

## The methods each F2 file declares, IN DECLARATION ORDER. Pinned by name
## rather than by count, because the faults this guards against — a rank
## reading, a second stream, an offer composition, an application step — arrive
## as an extra method with a plausible name.
## Foundation I5 (D-300) added exactly two methods, `exhaustion` and
## `is_exhausted`, and one field, `exhausted`, in the positions below; no existing
## row moved. The same two assertions pin the same record, and none was added.
const EXPECTED_RESULT_METHODS: Array[String] = [
	"failed", "exhaustion", "new_pair", "rank_increase", "_decided",
	"is_new_pair", "is_rank_increase", "is_exhausted", "pair", "kind_label",
	"problem", "describe",
]

const EXPECTED_CONTINUATION_METHODS: Array[String] = ["select"]

const EXPECTED_RESULT_FIELDS: Array[String] = [
	"ok", "failure_reason", "kind", "skill_id", "support_id",
	"selection", "held_when_classified", "exhausted",
]

# --- Test-only identities ------------------------------------------------------

const SKILL_ONE: StringName = &"zz_skill_one"
const SKILL_TWO: StringName = &"zz_skill_two"
const SKILL_THREE: StringName = &"zz_skill_three"

const SUPPORT_ALPHA: StringName = &"zz_t1_alpha"
const SUPPORT_BETA: StringName = &"zz_t2_beta"
const SUPPORT_GAMMA: StringName = &"zz_t3_gamma"

## The three fixture weights and the ladder they build. Written out here rather
## than summed from the records being checked, so a weight that moved turns this
## suite red instead of moving with it.
const WEIGHT_ALPHA: int = 4
const WEIGHT_BETA: int = 6
const WEIGHT_GAMMA: int = 5
const LADDER_TOTAL: int = 15

## THE MAXIMUM RANK EVERY FIXTURE DEFINITION DECLARES (Foundation I5, D-300). A
## definition that declares none is refused by every rank-increase question, so
## the fixtures declare one — deliberately far above the highest rank this suite
## ever holds a pair at (977), so every rank claim below is made about pairs that
## can still be raised. It is test data, not a balance value.
const FIXTURE_MAXIMUM_RANK: int = 1000

## How many distinct seeds every phase claim is made over.
const SEED_SAMPLES: int = 256

## How many identical calls a reproduction claim is made over.
const REPEAT_CALLS: int = 100

## How many first-stage tickets a uniformity sweep walks. Every ticket, not a
## sample: an excluded Skill must be UNREACHABLE rather than merely unlikely.
const SWEEP_TICKETS: int = 600

## How far the incoherence fixture's seed search is allowed to run before the
## suite reports that it could not build the case it owes.
const SEED_SEARCH_LIMIT: int = 4096

const OWED_CHECKS: Array[String] = [
	"nothing_acquired_reproduces_the_accepted_selection_as_a_new_pair",
	"a_held_pair_is_never_offered_again_as_new",
	"an_exhausted_skill_never_ranks_while_another_skill_has_something_new",
	"catalogue_depth_does_not_move_the_uniform_first_stage_rule",
	"only_a_completely_exhausted_pool_reaches_the_rank_phase",
	"a_rank_decision_always_names_a_pair_held_for_that_exact_skill",
	"the_same_support_stays_new_for_another_eligible_skill",
	"existing_rank_values_do_not_move_the_seeded_rank_selection",
	"rank_selection_equals_the_accepted_rank_increase_selection",
	"new_pair_selection_equals_direct_selection_against_the_real_record",
	"array_order_and_duplicate_tags_move_neither_phase",
	"exact_ticket_boundaries_stay_owned_by_the_same_records_in_rank_mode",
	"every_invalid_and_empty_case_refuses_whole",
	"a_refused_new_pair_draw_is_never_advanced_past",
	"a_null_acquisition_state_can_only_produce_a_new_pair",
	"inputs_and_ranked_ownership_are_observationally_unchanged",
	"identical_inputs_and_seed_reproduce_the_complete_result",
	"the_result_validates_its_own_coherence",
	"the_foundation_is_generic_reads_nothing_ambient_and_is_unwired",
	"nothing_existing_changed",
]

var _failures: PackedStringArray = PackedStringArray()
var _checks: int = 0
var _reached: Dictionary = {}
var _refusals: int = 0


func _initialize() -> void:
	print("")
	print("=== Roguelite Foundation F2 — Deterministic Support-Lane Continuation Selection ===")

	_check_nothing_acquired_reproduces_the_accepted_selection_as_a_new_pair()
	_check_a_held_pair_is_never_offered_again_as_new()
	_check_an_exhausted_skill_never_ranks_while_another_skill_has_something_new()
	_check_catalogue_depth_does_not_move_the_uniform_first_stage_rule()
	_check_only_a_completely_exhausted_pool_reaches_the_rank_phase()
	_check_a_rank_decision_always_names_a_pair_held_for_that_exact_skill()
	_check_the_same_support_stays_new_for_another_eligible_skill()
	_check_existing_rank_values_do_not_move_the_seeded_rank_selection()
	_check_rank_selection_equals_the_accepted_rank_increase_selection()
	_check_new_pair_selection_equals_direct_selection_against_the_real_record()
	_check_array_order_and_duplicate_tags_move_neither_phase()
	_check_exact_ticket_boundaries_stay_owned_by_the_same_records_in_rank_mode()
	_check_every_invalid_and_empty_case_refuses_whole()
	_check_a_refused_new_pair_draw_is_never_advanced_past()
	_check_a_null_acquisition_state_can_only_produce_a_new_pair()
	_check_inputs_and_ranked_ownership_are_observationally_unchanged()
	_check_identical_inputs_and_seed_reproduce_the_complete_result()
	_check_the_result_validates_its_own_coherence()
	_check_the_foundation_is_generic_reads_nothing_ambient_and_is_unwired()
	_check_nothing_existing_changed()

	_check_every_check_ran()

	print("")
	if _failures.is_empty():
		print("SUPPORT CONTINUATION VERIFICATION: PASS (%d checks)" % _checks)
		quit(0)
	else:
		for failure: String in _failures:
			printerr("  FAIL: %s" % failure)
		printerr("SUPPORT CONTINUATION VERIFICATION: %d FAILURE(S) of %d checks" % [
			_failures.size(), _checks,
		])
		quit(1)


# --- 1. With nothing acquired, F2 IS the accepted selection -------------------

func _check_nothing_acquired_reproduces_the_accepted_selection_as_a_new_pair() -> void:
	print("")
	print("--- 1. With nothing acquired, F2 returns EXACTLY the accepted selection, as a NEW PAIR")

	var profiles: Array[SkillTagProfile] = _two_melee_skills()
	var definitions: Array[SupportDefinition] = _three_melee_supports()

	var drifted: PackedStringArray = PackedStringArray()
	var wrong_kind: int = 0
	var claimed_held: int = 0
	var incoherent: int = 0
	for seed_value: int in SEED_SAMPLES:
		var direct: SupportSelectionResult = SupportSelection.select(
			profiles, definitions, AcquiredSupports.new(), seed_value
		)
		var continued: SupportContinuationResult = SupportContinuation.select(
			profiles, definitions, AcquiredSupports.new(), seed_value
		)
		if not continued.problem().is_empty():
			incoherent += 1
		if not continued.is_new_pair():
			wrong_kind += 1
		if continued.held_when_classified:
			claimed_held += 1
		if _selection_signature(continued.selection) != _selection_signature(direct) \
				or continued.skill_id != direct.skill_id \
				or continued.support_id != direct.support_id:
			drifted.append("seed %d: %s against %s" % [
				seed_value, continued.describe(), direct.describe(),
			])
	_expect(drifted.is_empty(),
		"%d of %d seeds disagreed with the accepted selector: %s" % [
			drifted.size(), SEED_SAMPLES, ", ".join(drifted),
		])
	_expect(wrong_kind == 0,
		"%d of %d seeds were not classified as a new pair" % [wrong_kind, SEED_SAMPLES])
	_expect(claimed_held == 0,
		"%d of %d new-pair decisions claimed the pair was already held"
			% [claimed_held, SEED_SAMPLES])
	_expect(incoherent == 0, "%d of %d results were internally incoherent"
		% [incoherent, SEED_SAMPLES])

	## THE DECISION KIND IS MECHANICAL, NOT TEXTUAL. A caller branching on it
	## reads an enum member; the description is presentation and is asserted
	## separately so a copy change can never move a decision.
	var one: SupportContinuationResult = SupportContinuation.select(
		profiles, definitions, AcquiredSupports.new(), 4242
	)
	_expect(one.kind == SupportContinuationResult.Kind.NEW_PAIR,
		"the decision kind is %d, not NEW_PAIR" % one.kind)
	_expect(not one.is_rank_increase(), "a new pair also reports itself as a rank increase")
	_expect(one.pair() == one.selection.pair(),
		"the decision's pair %s is not the selection's %s" % [one.pair(), one.selection.pair()])
	_expect(one.describe().contains("a new compatible pair"),
		"the description does not name the decision: %s" % one.describe())

	## THE WHOLE DERIVATION SURVIVES, not merely the pair. Every field a reviewer
	## would check by hand is asserted to be the accepted selector's own.
	var direct_one: SupportSelectionResult = SupportSelection.select(
		profiles, definitions, AcquiredSupports.new(), 4242
	)
	_expect(one.selection.rolled_ticket == direct_one.rolled_ticket
			and one.selection.total_eligible_weight == direct_one.total_eligible_weight
			and one.selection.skill_ticket == direct_one.skill_ticket
			and one.selection.eligible_skill_count == direct_one.eligible_skill_count
			and one.selection.base_weight == direct_one.base_weight
			and one.selection.effective_weight == direct_one.effective_weight
			and one.selection.matched_bonuses == direct_one.matched_bonuses,
		"the carried derivation differs from the accepted one: %s against %s" % [
			one.selection.describe(), direct_one.describe(),
		])

	print("  %d seeds: F2 == the accepted selector exactly, all NEW_PAIR, 0 claimed held"
		% SEED_SAMPLES)
	_done("nothing_acquired_reproduces_the_accepted_selection_as_a_new_pair")


# --- 2. A held pair is never offered again as new ----------------------------

func _check_a_held_pair_is_never_offered_again_as_new() -> void:
	print("")
	print("--- 2. With one pair held and another available, the held pair is NEVER selected")

	var profiles: Array[SkillTagProfile] = _one_melee_skill()
	var definitions: Array[SupportDefinition] = _two_melee_supports()
	var held: AcquiredSupports = AcquiredSupports.new()
	_expect(held.acquire(SKILL_ONE, SUPPORT_ALPHA), "the fixture could not acquire its pair")

	var offered_held: int = 0
	var not_new: int = 0
	var other: int = 0
	for seed_value: int in SEED_SAMPLES:
		var result: SupportContinuationResult = SupportContinuation.select(
			profiles, definitions, held, seed_value
		)
		if not result.ok:
			continue
		if result.support_id == SUPPORT_ALPHA:
			offered_held += 1
		if result.support_id == SUPPORT_BETA:
			other += 1
		if not result.is_new_pair():
			not_new += 1
	_expect(offered_held == 0,
		"the already-held pair was offered %d times over %d seeds" % [offered_held, SEED_SAMPLES])
	_expect(other == SEED_SAMPLES,
		"the remaining new pair was offered %d of %d times" % [other, SEED_SAMPLES])
	_expect(not_new == 0, "%d results were not classified as a new pair" % not_new)

	## AND WITH TWO SKILLS, where the held pair belongs to only one of them.
	var two: Array[SkillTagProfile] = _two_melee_skills()
	var held_two: AcquiredSupports = AcquiredSupports.new()
	_expect(held_two.acquire(SKILL_ONE, SUPPORT_ALPHA), "the two-Skill fixture refused a pair")
	var pairs_seen: Dictionary = {}
	for seed_value: int in SEED_SAMPLES:
		var result: SupportContinuationResult = SupportContinuation.select(
			two, definitions, held_two, seed_value
		)
		if result.ok:
			pairs_seen[result.pair()] = true
	_expect(not pairs_seen.has("%s -> %s" % [SKILL_ONE, SUPPORT_ALPHA]),
		"the held pair reappeared among %s" % ", ".join(PackedStringArray(pairs_seen.keys())))
	_expect(pairs_seen.has("%s -> %s" % [SKILL_TWO, SUPPORT_ALPHA]),
		"the same support on the OTHER Skill was never offered: %s"
			% ", ".join(PackedStringArray(pairs_seen.keys())))
	_expect(pairs_seen.size() == 3,
		"%d distinct pairs were reachable, not the 3 that remain: %s" % [
			pairs_seen.size(), ", ".join(PackedStringArray(pairs_seen.keys())),
		])

	print("  the held pair is offered 0 times over %d seeds; the remaining 3 pairs are reachable"
		% SEED_SAMPLES)
	_done("a_held_pair_is_never_offered_again_as_new")


# --- 3. New pairs GLOBALLY outrank rank candidates ---------------------------

func _check_an_exhausted_skill_never_ranks_while_another_skill_has_something_new() -> void:
	print("")
	print("--- 3. An EXHAUSTED Skill never ranks while another Skill still has something new")

	## Skill one is eligible for two supports and holds BOTH. Skill two is
	## eligible for one different support and holds none. If the phase rule were
	## asked per Skill instead of globally, the exhausted Skill would take a rank
	## on every seed whose first-stage ticket pointed at it.
	var profiles: Array[SkillTagProfile] = []
	profiles.append(_profile(SKILL_ONE, [
		SkillTags.ATTACK, SkillTags.HIT, SkillTags.MELEE, SkillTags.PHYSICAL,
	] as Array[StringName]))
	profiles.append(_profile(SKILL_TWO, [
		SkillTags.SPELL, SkillTags.HIT, SkillTags.FIRE,
	] as Array[StringName]))

	var definitions: Array[SupportDefinition] = []
	definitions.append(_definition(SUPPORT_ALPHA, [SkillTags.MELEE] as Array[StringName],
		[] as Array[StringName], WEIGHT_ALPHA, {}))
	definitions.append(_definition(SUPPORT_BETA, [SkillTags.MELEE] as Array[StringName],
		[] as Array[StringName], WEIGHT_BETA, {}))
	definitions.append(_definition(SUPPORT_GAMMA, [SkillTags.FIRE] as Array[StringName],
		[] as Array[StringName], WEIGHT_GAMMA, {}))

	var held: AcquiredSupports = AcquiredSupports.new()
	_expect(held.acquire(SKILL_ONE, SUPPORT_ALPHA) and held.acquire(SKILL_ONE, SUPPORT_BETA),
		"the exhausted Skill's fixture could not be built")
	_expect(held.size() == 2, "the fixture holds %d pairs, not 2" % held.size())

	var ranked: int = 0
	var wrong_skill: int = 0
	var refused: int = 0
	for seed_value: int in SEED_SAMPLES:
		var result: SupportContinuationResult = SupportContinuation.select(
			profiles, definitions, held, seed_value
		)
		if not result.ok:
			refused += 1
			continue
		if result.is_rank_increase():
			ranked += 1
		if result.skill_id != SKILL_TWO or result.support_id != SUPPORT_GAMMA:
			wrong_skill += 1
	_expect(ranked == 0,
		"the exhausted Skill took a rank on %d of %d seeds while another Skill had something new"
			% [ranked, SEED_SAMPLES])
	_expect(refused == 0, "%d of %d seeds refused" % [refused, SEED_SAMPLES])
	_expect(wrong_skill == 0,
		"%d of %d results named a Skill or support other than the one with something new"
			% [wrong_skill, SEED_SAMPLES])

	## A PARTIALLY EXHAUSTED POOL NEVER FALLS THROUGH EITHER. Here the SAME Skill
	## holds one of its two supports: one new pair remains anywhere in the pool,
	## so the rank phase must stay unreachable.
	var partial: AcquiredSupports = AcquiredSupports.new()
	_expect(partial.acquire(SKILL_ONE, SUPPORT_ALPHA)
			and partial.acquire(SKILL_TWO, SUPPORT_GAMMA),
		"the partial fixture could not be built")
	var partial_ranked: int = 0
	var partial_pairs: Dictionary = {}
	for seed_value: int in SEED_SAMPLES:
		var result: SupportContinuationResult = SupportContinuation.select(
			profiles, definitions, partial, seed_value
		)
		if result.ok and result.is_rank_increase():
			partial_ranked += 1
		if result.ok:
			partial_pairs[result.pair()] = true
	_expect(partial_ranked == 0,
		"a partially exhausted pool fell through to ranking on %d of %d seeds"
			% [partial_ranked, SEED_SAMPLES])
	_expect(partial_pairs.size() == 1
			and partial_pairs.has("%s -> %s" % [SKILL_ONE, SUPPORT_BETA]),
		"the one remaining new pair was not the only outcome: %s"
			% ", ".join(PackedStringArray(partial_pairs.keys())))

	print("  an exhausted Skill ranked 0 times over %d seeds; a partial pool ranked 0 times"
		% SEED_SAMPLES)
	_done("an_exhausted_skill_never_ranks_while_another_skill_has_something_new")


# --- 4. Catalogue depth does not move the uniform first stage ----------------

func _check_catalogue_depth_does_not_move_the_uniform_first_stage_rule() -> void:
	print("")
	print("--- 4. A Skill matching THREE supports is no likelier than one matching ONE")

	## The accepted first stage is uniform over the Skills that currently have
	## something available, so authoring more supports for a Skill must not make
	## that Skill the one the lane keeps reaching for. The claim is WALKED on the
	## accepted ticket ladder — every first-stage ticket, counted — and F2's
	## agreement with that ladder is asserted per seed by exact equality below
	## and in checks 9 and 10.
	var profiles: Array[SkillTagProfile] = []
	profiles.append(_profile(SKILL_ONE, [
		SkillTags.ATTACK, SkillTags.HIT, SkillTags.MELEE, SkillTags.PHYSICAL,
	] as Array[StringName]))
	profiles.append(_profile(SKILL_TWO, [
		SkillTags.SPELL, SkillTags.HIT, SkillTags.FIRE,
	] as Array[StringName]))

	## Three supports for the first Skill, one for the second — and the three
	## deliberately carry a thousand times the weight, so a flat draw over legal
	## pairs would be visible immediately.
	var definitions: Array[SupportDefinition] = []
	definitions.append(_definition(&"zz_t1_deep_a", [SkillTags.MELEE] as Array[StringName],
		[] as Array[StringName], 1000, {}))
	definitions.append(_definition(&"zz_t2_deep_b", [SkillTags.MELEE] as Array[StringName],
		[] as Array[StringName], 1000, {}))
	definitions.append(_definition(&"zz_t3_deep_c", [SkillTags.MELEE] as Array[StringName],
		[] as Array[StringName], 1000, {}))
	definitions.append(_definition(&"zz_t4_shallow", [SkillTags.FIRE] as Array[StringName],
		[] as Array[StringName], 1, {}))

	var new_phase: Dictionary = _sweep_skill_tickets(
		profiles, definitions, AcquiredSupports.new(), SWEEP_TICKETS
	)
	_expect(int(new_phase.get(SKILL_ONE, 0)) == SWEEP_TICKETS / 2
			and int(new_phase.get(SKILL_TWO, 0)) == SWEEP_TICKETS / 2,
		"the new-pair phase's first stage is not an even split over %d tickets: %s"
			% [SWEEP_TICKETS, new_phase])

	## AND IN RANK MODE. With every eligible pair held below its maximum, the rank
	## phase asks the accepted selector's RANK-INCREASE draw against the real record
	## — moved one for one by Foundation I5 (D-300) from the same selector against an
	## EMPTY record, which was the rank phase before a maximum existed — so the same
	## uniformity must hold: 1 support against 3 is still 50 / 50.
	var exhausted: AcquiredSupports = AcquiredSupports.new()
	for definition: SupportDefinition in definitions:
		for profile: SkillTagProfile in profiles:
			if definition.allows(profile):
				exhausted.acquire(profile.skill_id, definition.support_id())
	_expect(exhausted.size() == 4, "the exhausted fixture holds %d pairs, not 4" % exhausted.size())

	var rank_phase: Dictionary = _sweep_rank_skill_tickets(
		profiles, definitions, exhausted, SWEEP_TICKETS
	)
	_expect(rank_phase == new_phase,
		"the rank-increase ladder the rank phase draws against differs from the new-pair one: %s"
			% rank_phase)

	var ranked_skills: Dictionary = {}
	var not_ranked: int = 0
	for seed_value: int in SEED_SAMPLES:
		var result: SupportContinuationResult = SupportContinuation.select(
			profiles, definitions, exhausted, seed_value
		)
		if not result.is_rank_increase():
			not_ranked += 1
			continue
		ranked_skills[result.skill_id] = int(ranked_skills.get(result.skill_id, 0)) + 1
	_expect(not_ranked == 0,
		"%d of %d seeds did not reach the rank phase with every pair held"
			% [not_ranked, SEED_SAMPLES])
	_expect(ranked_skills.size() == 2,
		"the rank phase reached %d of the 2 Skills: %s" % [ranked_skills.size(), ranked_skills])

	print("  first stage %d / %d over %d tickets in both phases; both Skills reachable when ranking"
		% [int(new_phase.get(SKILL_ONE, 0)), int(new_phase.get(SKILL_TWO, 0)), SWEEP_TICKETS])
	_done("catalogue_depth_does_not_move_the_uniform_first_stage_rule")


# --- 5. Only a completely exhausted pool ranks -------------------------------

func _check_only_a_completely_exhausted_pool_reaches_the_rank_phase() -> void:
	print("")
	print("--- 5. The rank phase is unreachable until EVERY eligible pair is held")

	var profiles: Array[SkillTagProfile] = _two_melee_skills()
	var definitions: Array[SupportDefinition] = _three_melee_supports()

	## Both Skills are eligible for all three supports, so the pool is six pairs.
	## They are acquired one at a time in a fixed order, and after each one the
	## whole seed range is asked which phase it is in.
	var order: Array = []
	for skill: StringName in [SKILL_ONE, SKILL_TWO]:
		for support: StringName in [SUPPORT_ALPHA, SUPPORT_BETA, SUPPORT_GAMMA]:
			order.append([skill, support])
	_expect(order.size() == 6, "the exhaustion fixture has %d pairs, not 6" % order.size())

	var held: AcquiredSupports = AcquiredSupports.new()
	var premature: PackedStringArray = PackedStringArray()
	var taken: int = 0
	for row: Array in order:
		_expect(held.acquire(row[0] as StringName, row[1] as StringName),
			"the exhaustion fixture could not acquire %s -> %s" % [row[0], row[1]])
		taken += 1
		var ranked: int = 0
		for seed_value: int in SEED_SAMPLES:
			var result: SupportContinuationResult = SupportContinuation.select(
				profiles, definitions, held, seed_value
			)
			if result.ok and result.is_rank_increase():
				ranked += 1
		if taken < order.size():
			if ranked != 0:
				premature.append("%d of 6 held: %d ranked" % [taken, ranked])
		else:
			_expect(ranked == SEED_SAMPLES,
				"with all 6 pairs held only %d of %d seeds ranked" % [ranked, SEED_SAMPLES])
	_expect(premature.is_empty(),
		"the rank phase was reached before the pool was exhausted: %s" % ", ".join(premature))
	_expect(held.size() == 6, "the exhausted record holds %d pairs, not 6" % held.size())

	print("  0 rank decisions at 1-5 of 6 pairs held; %d of %d seeds rank at 6 of 6"
		% [SEED_SAMPLES, SEED_SAMPLES])
	_done("only_a_completely_exhausted_pool_reaches_the_rank_phase")


# --- 6. A rank decision names a pair held for that exact Skill ---------------

func _check_a_rank_decision_always_names_a_pair_held_for_that_exact_skill() -> void:
	print("")
	print("--- 6. Every rank decision names a pair ALREADY HELD for that exact Skill")

	var profiles: Array[SkillTagProfile] = _two_melee_skills()
	var definitions: Array[SupportDefinition] = _three_melee_supports()
	var held: AcquiredSupports = _exhausted_record(profiles, definitions)
	_expect(held.size() == 6, "the exhausted record holds %d pairs, not 6" % held.size())

	var not_held: PackedStringArray = PackedStringArray()
	var unknown_skill: int = 0
	var mislabelled: int = 0
	var reached: Dictionary = {}
	for seed_value: int in SEED_SAMPLES:
		var result: SupportContinuationResult = SupportContinuation.select(
			profiles, definitions, held, seed_value
		)
		if not result.is_rank_increase():
			mislabelled += 1
			continue
		if not held.has(result.skill_id, result.support_id):
			not_held.append("seed %d: %s" % [seed_value, result.pair()])
		if result.skill_id != SKILL_ONE and result.skill_id != SKILL_TWO:
			unknown_skill += 1
		if not result.held_when_classified:
			mislabelled += 1
		reached[result.pair()] = true
	_expect(not_held.is_empty(),
		"a rank decision named a pair that is not held: %s" % ", ".join(not_held))
	_expect(unknown_skill == 0, "%d rank decisions named an unequipped Skill" % unknown_skill)
	_expect(mislabelled == 0, "%d rank decisions were mislabelled or unclassified" % mislabelled)

	## THE PAIR IS SCOPED TO ITS SKILL, NOT TO THE SUPPORT. A record holding
	## `SKILL_ONE -> ALPHA` alone must not let a rank decision name
	## `SKILL_TWO -> ALPHA`, which is exactly the collision a support-only record
	## would have produced.
	var one_pair: AcquiredSupports = AcquiredSupports.new()
	_expect(one_pair.acquire(SKILL_ONE, SUPPORT_ALPHA), "the scoped fixture refused its pair")
	var scoped_profiles: Array[SkillTagProfile] = _two_melee_skills()
	var only_alpha: Array[SupportDefinition] = []
	only_alpha.append(_definition(SUPPORT_ALPHA, [SkillTags.MELEE] as Array[StringName],
		[] as Array[StringName], WEIGHT_ALPHA, {}))
	var cross_ranked: int = 0
	for seed_value: int in SEED_SAMPLES:
		var result: SupportContinuationResult = SupportContinuation.select(
			scoped_profiles, only_alpha, one_pair, seed_value
		)
		if result.ok and result.is_rank_increase():
			cross_ranked += 1
	_expect(cross_ranked == 0,
		"%d seeds ranked while the other Skill still had that same support available"
			% cross_ranked)

	_expect(reached.size() >= 2,
		"only %d distinct pairs were ever ranked, so the sweep is degenerate" % reached.size())

	print("  %d rank decisions, all held for their own Skill; %d distinct pairs reached"
		% [SEED_SAMPLES, reached.size()])
	_done("a_rank_decision_always_names_a_pair_held_for_that_exact_skill")


# --- 7. The same support stays new for another eligible Skill ----------------

func _check_the_same_support_stays_new_for_another_eligible_skill() -> void:
	print("")
	print("--- 7. One support held for one Skill is still a NEW pair for another")

	var profiles: Array[SkillTagProfile] = _three_melee_skills()
	var definitions: Array[SupportDefinition] = []
	definitions.append(_definition(SUPPORT_ALPHA, [SkillTags.MELEE] as Array[StringName],
		[] as Array[StringName], WEIGHT_ALPHA, {}))

	var held: AcquiredSupports = AcquiredSupports.new()
	_expect(held.acquire(SKILL_ONE, SUPPORT_ALPHA), "the fixture refused its pair")

	var pairs_seen: Dictionary = {}
	var ranked: int = 0
	for seed_value: int in SEED_SAMPLES:
		var result: SupportContinuationResult = SupportContinuation.select(
			profiles, definitions, held, seed_value
		)
		if not result.ok:
			continue
		pairs_seen[result.pair()] = true
		if result.is_rank_increase():
			ranked += 1
	_expect(ranked == 0,
		"%d seeds ranked while the same support was still new for two other Skills" % ranked)
	_expect(not pairs_seen.has("%s -> %s" % [SKILL_ONE, SUPPORT_ALPHA]),
		"the held pair was offered again: %s" % ", ".join(PackedStringArray(pairs_seen.keys())))
	_expect(pairs_seen.has("%s -> %s" % [SKILL_TWO, SUPPORT_ALPHA])
			and pairs_seen.has("%s -> %s" % [SKILL_THREE, SUPPORT_ALPHA]),
		"the same support was not offered to both remaining Skills: %s"
			% ", ".join(PackedStringArray(pairs_seen.keys())))
	_expect(pairs_seen.size() == 2,
		"%d distinct pairs were reachable, not the 2 that remain: %s" % [
			pairs_seen.size(), ", ".join(PackedStringArray(pairs_seen.keys())),
		])

	print("  1 support, 3 Skills, 1 pair held: the other 2 stay new and the held one never returns")
	_done("the_same_support_stays_new_for_another_eligible_skill")


# --- 8. Existing rank values do not move the seeded selection ----------------

func _check_existing_rank_values_do_not_move_the_seeded_rank_selection() -> void:
	print("")
	print("--- 8. Ranks 1, 2 and 977, all below the maximum, produce the SAME seeded rank selection")

	## BELOW ITS MAXIMUM, A RANK MOVES NO SELECTION (D-254 ruling 4, bounded by
	## D-299). Whether a pair has REACHED its maximum is now the one thing a rank can
	## decide — the I5 suite proves that — and every rank here is below
	## `FIXTURE_MAXIMUM_RANK`, so these four records must still answer identically.
	var profiles: Array[SkillTagProfile] = _two_melee_skills()
	var definitions: Array[SupportDefinition] = _three_melee_supports()

	var at_one: AcquiredSupports = _exhausted_record(profiles, definitions)
	var at_two: AcquiredSupports = _raised_to(_exhausted_record(profiles, definitions), 2)
	var at_many: AcquiredSupports = _raised_to(_exhausted_record(profiles, definitions), 977)
	## A MIXED record too, because "every pair at the same rank" is the one shape
	## an implementation reading a rank could still get right by accident.
	var mixed: AcquiredSupports = _exhausted_record(profiles, definitions)
	_expect(mixed.increase_rank(SKILL_ONE, SUPPORT_BETA), "the mixed fixture refused a raise")
	for _step: int in 40:
		mixed.increase_rank(SKILL_TWO, SUPPORT_GAMMA)

	_expect(at_one.total_ranks() == 6, "the rank-1 record sums to %d, not 6" % at_one.total_ranks())
	_expect(at_two.total_ranks() == 12, "the rank-2 record sums to %d, not 12" % at_two.total_ranks())
	_expect(at_many.total_ranks() == 6 * 977,
		"the rank-977 record sums to %d, not %d" % [at_many.total_ranks(), 6 * 977])
	_expect(at_many.rank_for(SKILL_ONE, SUPPORT_ALPHA) == 977,
		"the raised fixture holds rank %d, not 977" % at_many.rank_for(SKILL_ONE, SUPPORT_ALPHA))
	_expect(mixed.total_ranks() == 47,
		"the mixed record sums to %d, not 47" % mixed.total_ranks())
	_expect(at_one.size() == at_many.size() and at_one.size() == mixed.size(),
		"the four records do not hold the same pairs")

	var drifted: PackedStringArray = PackedStringArray()
	for seed_value: int in SEED_SAMPLES:
		var baseline: String = _full(SupportContinuation.select(
			profiles, definitions, at_one, seed_value))
		for row: Array in [[at_two, "rank 2"], [at_many, "rank 977"], [mixed, "mixed ranks"]]:
			var other: String = _full(SupportContinuation.select(
				profiles, definitions, row[0] as AcquiredSupports, seed_value))
			if other != baseline:
				drifted.append("seed %d at %s: %s against %s" % [
					seed_value, row[1], other, baseline,
				])
	_expect(drifted.is_empty(),
		"a rank value moved a seeded selection: %s" % ", ".join(drifted))

	print("  %d seeds identical at ranks 1, 2, 977 and mixed — below the declared maximum of %d,"
		% [SEED_SAMPLES, FIXTURE_MAXIMUM_RANK] + " rank 1 and rank 977 are selection-equivalent")
	_done("existing_rank_values_do_not_move_the_seeded_rank_selection")


# --- 9. Rank selection == the accepted rank-increase selection -----------------

func _check_rank_selection_equals_the_accepted_rank_increase_selection() -> void:
	print("")
	print("--- 9. A rank decision equals the accepted RANK-INCREASE selection against the REAL record")

	## MOVED ONE FOR ONE BY FOUNDATION I5 (D-300). Before a maximum existed the rank
	## decision WAS the accepted selector's draw against an EMPTY record; it is now
	## the accepted selector's rank-increase draw against the real one, which is the
	## only draw that can see a maximum. Every assertion below is the same assertion
	## made of that draw. With every held pair below its maximum the two are the same
	## pool and the same tickets, which the I5 suite measures.
	var profiles: Array[SkillTagProfile] = _two_melee_skills()
	var definitions: Array[SupportDefinition] = _three_melee_supports()
	var held: AcquiredSupports = _raised_to(_exhausted_record(profiles, definitions), 3)

	var drifted: PackedStringArray = PackedStringArray()
	var not_ranked: int = 0
	for seed_value: int in SEED_SAMPLES:
		var result: SupportContinuationResult = SupportContinuation.select(
			profiles, definitions, held, seed_value
		)
		if not result.is_rank_increase():
			not_ranked += 1
			continue
		var direct: SupportSelectionResult = SupportSelection.select_rank_increase(
			profiles, definitions, held, seed_value
		)
		if _selection_signature(result.selection) != _selection_signature(direct):
			drifted.append("seed %d: %s against %s" % [
				seed_value, result.selection.describe(), direct.describe(),
			])
	_expect(not_ranked == 0, "%d of %d seeds did not rank" % [not_ranked, SEED_SAMPLES])
	_expect(drifted.is_empty(),
		"a rank decision's derivation differs from the accepted rank-increase selection: %s"
			% ", ".join(drifted))

	## AND THE SEED IS THE SAME ONE. No salt, no second stream, no adjustment: a
	## reviewer reproduces a rank decision with ONE call to the accepted
	## rank-increase selection.
	var sample: SupportContinuationResult = SupportContinuation.select(
		profiles, definitions, held, 987654
	)
	var reproduced: SupportSelectionResult = SupportSelection.select_rank_increase(
		profiles, definitions, held, 987654
	)
	_expect(sample.is_rank_increase() and sample.pair() == reproduced.pair(),
		"the worked rank example does not reproduce: %s against %s" % [
			sample.describe(), reproduced.describe(),
		])
	_expect(sample.selection.rolled_ticket == reproduced.rolled_ticket
			and sample.selection.skill_ticket == reproduced.skill_ticket,
		"the worked rank example's tickets differ from the accepted selector's")

	print("  %d rank decisions reproduce the accepted rank-increase selection exactly, same seed"
		% SEED_SAMPLES)
	_done("rank_selection_equals_the_accepted_rank_increase_selection")


# --- 10. New-pair selection == the accepted selection against the real record -

func _check_new_pair_selection_equals_direct_selection_against_the_real_record() -> void:
	print("")
	print("--- 10. A new-pair decision equals the accepted selection against the REAL record")

	var profiles: Array[SkillTagProfile] = _two_melee_skills()
	var definitions: Array[SupportDefinition] = _three_melee_supports()

	## A genuinely PARTIAL record, so the real state and an empty one disagree —
	## otherwise this check would prove nothing that check 1 did not.
	var held: AcquiredSupports = AcquiredSupports.new()
	_expect(held.acquire(SKILL_ONE, SUPPORT_ALPHA)
			and held.acquire(SKILL_ONE, SUPPORT_BETA)
			and held.acquire(SKILL_TWO, SUPPORT_GAMMA),
		"the partial fixture could not be built")
	_expect(held.size() == 3, "the partial fixture holds %d pairs, not 3" % held.size())

	var drifted: PackedStringArray = PackedStringArray()
	var differs_from_empty: int = 0
	for seed_value: int in SEED_SAMPLES:
		var result: SupportContinuationResult = SupportContinuation.select(
			profiles, definitions, held, seed_value
		)
		var direct: SupportSelectionResult = SupportSelection.select(
			profiles, definitions, held, seed_value
		)
		if not result.is_new_pair() \
				or _selection_signature(result.selection) != _selection_signature(direct):
			drifted.append("seed %d: %s against %s" % [
				seed_value, result.describe(), direct.describe(),
			])
		var empty_state: SupportSelectionResult = SupportSelection.select(
			profiles, definitions, AcquiredSupports.new(), seed_value
		)
		if empty_state.pair() != direct.pair():
			differs_from_empty += 1
	_expect(drifted.is_empty(),
		"a new-pair decision differs from the real-record selection: %s" % ", ".join(drifted))
	_expect(differs_from_empty > 0,
		"the real record and an empty one agree on every seed, so this fixture proves nothing")

	print("  %d new-pair decisions reproduce the real-record selection; %d of them differ from"
		% [SEED_SAMPLES, differs_from_empty] + " the empty-record answer")
	_done("new_pair_selection_equals_direct_selection_against_the_real_record")


# --- 11. Array order and duplicate tags move neither phase -------------------

func _check_array_order_and_duplicate_tags_move_neither_phase() -> void:
	print("")
	print("--- 11. Reversing the arrays and duplicating every tag moves NEITHER phase")

	var profiles: Array[SkillTagProfile] = _two_melee_skills()
	var definitions: Array[SupportDefinition] = _three_melee_supports()

	var reversed_profiles: Array[SkillTagProfile] = _reversed_profiles(profiles)
	var reversed_definitions: Array[SupportDefinition] = _reversed_definitions(definitions)
	## THE REVERSAL MUST BE A GENUINELY DIFFERENT ARRAY, or the comparison below
	## is a list being compared with itself.
	_expect(reversed_profiles[0].skill_id != profiles[0].skill_id,
		"the reversed profile array is not actually different")
	_expect(reversed_definitions[0].support_id() != definitions[0].support_id(),
		"the reversed definition array is not actually different")

	var retagged: Array[SkillTagProfile] = _retagged_profiles(profiles)
	_expect(retagged[0].tags.size() == profiles[0].tags.size() * 2,
		"the retagged profile carries %d tags, not twice %d" % [
			retagged[0].tags.size(), profiles[0].tags.size(),
		])
	_expect(retagged[0].tags[0] != profiles[0].tags[0],
		"the retagged profile's tag order did not actually change")

	var partial: AcquiredSupports = AcquiredSupports.new()
	_expect(partial.acquire(SKILL_ONE, SUPPORT_ALPHA), "the order fixture refused its pair")
	var exhausted: AcquiredSupports = _raised_to(_exhausted_record(profiles, definitions), 5)

	var moved: PackedStringArray = PackedStringArray()
	for row: Array in [[partial, "new-pair"], [exhausted, "rank"]]:
		var record: AcquiredSupports = row[0] as AcquiredSupports
		for seed_value: int in SEED_SAMPLES:
			var baseline: String = _full(SupportContinuation.select(
				profiles, definitions, record, seed_value))
			var by_order: String = _full(SupportContinuation.select(
				reversed_profiles, reversed_definitions, record, seed_value))
			var by_tags: String = _full(SupportContinuation.select(
				retagged, reversed_definitions, record, seed_value))
			if by_order != baseline:
				moved.append("%s seed %d reordered: %s against %s" % [
					row[1], seed_value, by_order, baseline,
				])
			if by_tags != baseline:
				moved.append("%s seed %d retagged: %s against %s" % [
					row[1], seed_value, by_tags, baseline,
				])
	_expect(moved.is_empty(),
		"order or tag duplication moved a decision: %s" % ", ".join(moved))

	print("  %d seeds in both phases: reversed arrays and doubled, reversed tags change nothing"
		% SEED_SAMPLES)
	_done("array_order_and_duplicate_tags_move_neither_phase")


# --- 12. Exact ticket boundaries in rank mode --------------------------------

func _check_exact_ticket_boundaries_stay_owned_by_the_same_records_in_rank_mode() -> void:
	print("")
	print("--- 12. In RANK mode the weight ladder is owned by exactly the same records")

	## ONE Skill, so the ladder is unambiguous, and the three fixture weights
	## 4 / 6 / 5 over a total of 15. The bands are walked ticket by ticket
	## against the accepted selector's RANK-INCREASE draw over the held record —
	## which is the ladder the rank phase draws on since Foundation I5 (D-300),
	## moved one for one from the empty-record ladder it drew on before — and the
	## ownership is then required of F2's own rank decisions at the exact reduced
	## ticket each seed produces.
	var profiles: Array[SkillTagProfile] = _one_melee_skill()
	var definitions: Array[SupportDefinition] = _three_melee_supports()
	var held: AcquiredSupports = _raised_to(_exhausted_record(profiles, definitions), 4)
	_expect(held.size() == 3, "the ladder fixture holds %d pairs, not 3" % held.size())

	var owner_at: Array[StringName] = []
	var counts: Dictionary = {}
	for ticket: int in LADDER_TOTAL:
		var walked: SupportSelectionResult = SupportSelection.select_rank_increase_with_tickets(
			profiles, definitions, held, 0, ticket
		)
		_expect(walked.ok, "ticket %d refused: %s" % [ticket, walked.failure_reason])
		owner_at.append(walked.support_id)
		counts[walked.support_id] = int(counts.get(walked.support_id, 0)) + 1
	_expect(int(counts.get(SUPPORT_ALPHA, 0)) == WEIGHT_ALPHA
			and int(counts.get(SUPPORT_BETA, 0)) == WEIGHT_BETA
			and int(counts.get(SUPPORT_GAMMA, 0)) == WEIGHT_GAMMA,
		"the ladder is not owned %d / %d / %d: %s" % [
			WEIGHT_ALPHA, WEIGHT_BETA, WEIGHT_GAMMA, counts,
		])
	## THE EXACT BOUNDARIES, not merely the counts.
	_expect(owner_at[0] == SUPPORT_ALPHA and owner_at[3] == SUPPORT_ALPHA,
		"tickets 0 and 3 are not owned by the first record")
	_expect(owner_at[4] == SUPPORT_BETA and owner_at[9] == SUPPORT_BETA,
		"tickets 4 and 9 are not owned by the second record")
	_expect(owner_at[10] == SUPPORT_GAMMA and owner_at[14] == SUPPORT_GAMMA,
		"tickets 10 and 14 are not owned by the third record")

	var mismatched: PackedStringArray = PackedStringArray()
	var bands_reached: Dictionary = {}
	for seed_value: int in SEED_SAMPLES:
		var result: SupportContinuationResult = SupportContinuation.select(
			profiles, definitions, held, seed_value
		)
		if not result.is_rank_increase():
			mismatched.append("seed %d did not rank" % seed_value)
			continue
		var reduced: int = SupportSelection.support_ticket_for(seed_value) % LADDER_TOTAL
		if result.selection.rolled_ticket != reduced \
				or result.selection.total_eligible_weight != LADDER_TOTAL \
				or result.support_id != owner_at[reduced]:
			mismatched.append("seed %d: ticket %d owned by %s, got %s" % [
				seed_value, reduced, owner_at[reduced], result.support_id,
			])
		bands_reached[result.support_id] = true
	_expect(mismatched.is_empty(),
		"a rank decision did not honour the ladder: %s" % ", ".join(mismatched))
	_expect(bands_reached.size() == 3,
		"only %d of the 3 bands were reached, so the sweep is degenerate"
			% bands_reached.size())

	print("  ladder %d / %d / %d of %d walked ticket by ticket; %d rank decisions land in the"
		% [WEIGHT_ALPHA, WEIGHT_BETA, WEIGHT_GAMMA, LADDER_TOTAL, SEED_SAMPLES]
		+ " band their own reduced ticket names")
	_done("exact_ticket_boundaries_stay_owned_by_the_same_records_in_rank_mode")


# --- 13. Every invalid and empty case refuses whole --------------------------

func _check_every_invalid_and_empty_case_refuses_whole() -> void:
	print("")
	print("--- 13. Every invalid or empty case refuses WHOLE, exposing no partial decision")

	var valid_profiles: Array[SkillTagProfile] = _two_melee_skills()
	var valid_definitions: Array[SupportDefinition] = _three_melee_supports()

	## A POSITIVE CONTROL RUNS FIRST, because a guard that refuses everything
	## protects nothing.
	var control: SupportContinuationResult = SupportContinuation.select(
		valid_profiles, valid_definitions, AcquiredSupports.new(), 11
	)
	_expect(control.ok and control.problem().is_empty(),
		"the positive control refused: %s" % control.failure_reason)

	var null_profiles: Array[SkillTagProfile] = []
	null_profiles.append(null)
	null_profiles.append(valid_profiles[0])

	var bad_profile: Array[SkillTagProfile] = []
	bad_profile.append(_profile(&"", [SkillTags.MELEE] as Array[StringName]))

	var untagged: Array[SkillTagProfile] = []
	untagged.append(SkillTagProfile.of(SKILL_ONE, "Test Skill", [] as Array[StringName]))

	var duplicate_skills: Array[SkillTagProfile] = []
	duplicate_skills.append(valid_profiles[0])
	duplicate_skills.append(valid_profiles[0])

	var null_definitions: Array[SupportDefinition] = []
	null_definitions.append(null)

	var bad_weight: Array[SupportDefinition] = []
	bad_weight.append(_definition(SUPPORT_ALPHA, [SkillTags.MELEE] as Array[StringName],
		[] as Array[StringName], 0, {}))

	var negative_bonus: Array[SupportDefinition] = []
	negative_bonus.append(_definition(SUPPORT_ALPHA, [SkillTags.MELEE] as Array[StringName],
		[] as Array[StringName], 10, {SkillTags.MELEE: -5}))

	var unknown_bonus: Array[SupportDefinition] = []
	unknown_bonus.append(_definition(SUPPORT_ALPHA, [SkillTags.MELEE] as Array[StringName],
		[] as Array[StringName], 10, {&"zz_not_a_tag": 5}))

	var duplicate_supports: Array[SupportDefinition] = []
	duplicate_supports.append(valid_definitions[0])
	duplicate_supports.append(valid_definitions[0])

	## NO COMPATIBLE SUPPORT FOR ANY SKILL. Every definition demands a tag no
	## equipped Skill carries, so the pool is legal and empty.
	var incompatible: Array[SupportDefinition] = []
	incompatible.append(_definition(SUPPORT_ALPHA, [SkillTags.VOID] as Array[StringName],
		[] as Array[StringName], 10, {}))
	incompatible.append(_definition(SUPPORT_BETA, [SkillTags.MELEE] as Array[StringName],
		[SkillTags.PHYSICAL] as Array[StringName], 10, {}))

	var empty_profiles: Array[SkillTagProfile] = []
	var empty_definitions: Array[SupportDefinition] = []

	## THE TWO CASES THAT CANNOT BE DRIVEN, AND THE REASON IS THE TYPE SYSTEM
	## RATHER THAN AN OMISSION. The accepted selector defends against a null
	## PROFILES or DEFINITIONS array, but both parameters are typed `Array[...]`
	## and a typed array is a value: a statically typed call cannot pass null into
	## one at all. Those two guards are therefore unreachable through this
	## foundation, which delegates through exactly such a call, and manufacturing
	## a seam to reach them is not something this work is authorized to do. The
	## null ELEMENT cases below are reachable and are driven.
	var cases: Array = [
		["no equipped Skills", empty_profiles, valid_definitions],
		["a null Skill profile in the array", null_profiles, valid_definitions],
		["an invalid Skill profile", bad_profile, valid_definitions],
		["a Skill profile with no tags", untagged, valid_definitions],
		["a duplicate Skill id", duplicate_skills, valid_definitions],
		["no support definitions", valid_profiles, empty_definitions],
		["a null support definition", valid_profiles, null_definitions],
		["a base weight below the minimum", valid_profiles, bad_weight],
		["a negative tag bonus", valid_profiles, negative_bonus],
		["a bonus for an unrecognised tag", valid_profiles, unknown_bonus],
		["a duplicate support id", valid_profiles, duplicate_supports],
		["no compatible support for any Skill", valid_profiles, incompatible],
	]

	var accepted: PackedStringArray = PackedStringArray()
	for row: Array in cases:
		var described: String = String(row[0])
		var result: SupportContinuationResult = SupportContinuation.select(
			row[1] as Array[SkillTagProfile], row[2] as Array[SupportDefinition],
			AcquiredSupports.new(), 7
		)
		if result.ok:
			accepted.append(described)
			continue
		_refusals += 1
		_expect_no_partial_decision(result, described)
	_expect(accepted.is_empty(), "these invalid cases were ACCEPTED: %s" % ", ".join(accepted))
	_expect(_refusals == cases.size(),
		"%d of the %d invalid cases refused" % [_refusals, cases.size()])

	## AN INVALID CASE REFUSES IN BOTH PHASES, not only when nothing is held: a
	## broken definition must not become acceptable because a pool is exhausted.
	var exhausted: AcquiredSupports = _exhausted_record(valid_profiles, valid_definitions)
	var refused_when_exhausted: SupportContinuationResult = SupportContinuation.select(
		valid_profiles, bad_weight, exhausted, 7
	)
	_expect(not refused_when_exhausted.ok,
		"an invalid definition was accepted once the pool was exhausted")
	_expect_no_partial_decision(refused_when_exhausted, "an invalid definition with a full record")
	_refusals += 1

	## THE REASON QUOTES THE FIRST REFUSAL RATHER THAN INVENTING ONE, and says
	## that the same inputs refuse with nothing held — which is what separates
	## broken or absent inputs from an exhausted pool WITHOUT reading either
	## sentence.
	var direct: SupportSelectionResult = SupportSelection.select(
		valid_profiles, incompatible, AcquiredSupports.new(), 7
	)
	var quoted: SupportContinuationResult = SupportContinuation.select(
		valid_profiles, incompatible, AcquiredSupports.new(), 7
	)
	_expect(not direct.ok and not quoted.ok, "the quoting fixture did not refuse")
	_expect(quoted.failure_reason.contains(direct.failure_reason),
		"the refusal does not quote the accepted selector's own reason: %s"
			% quoted.failure_reason)
	_expect(quoted.failure_reason.contains("with nothing acquired the same inputs still refuse"),
		"the refusal does not report that the empty-record query refused too: %s"
			% quoted.failure_reason)

	print("  %d refusals driven, every one whole: no kind, no ids, no derivation" % _refusals)
	_done("every_invalid_and_empty_case_refuses_whole")


# --- 14. A refused new-pair draw is never advanced past ---------------------

func _check_a_refused_new_pair_draw_is_never_advanced_past() -> void:
	print("")
	print("--- 14. When the new-pair draw refuses for anything but an empty candidate set, F2 refuses without advancing")

	## MOVED ONE FOR ONE BY THE FOUNDATION I5 CORRECTION (D-301). This fixture was
	## built to reach the internal-incoherence guard: the real new-pair draw refuses on
	## the accepted weight ceiling while the empty-record draw — which then decided
	## whether the rank phase was entered — names a pair nothing holds. That guard no
	## longer exists, because its one reachable case was a FAIL-OPEN: a refusal caused
	## by an unusable ladder was treated as "nothing new is available", and on seeds
	## where the empty-record draw named a HELD pair the lane went on to raise it while
	## another Skill still had a new compatible pair. The continuation now advances only
	## on the selector's machine-readable EMPTY-CANDIDATE classification, so this same
	## fixture refuses at the new-pair phase. The same ten assertions, one for one: the
	## fixture is still the overflow case, and the refusal is now the ceiling refusal.
	##
	## MOVED ONE FOR ONE AGAIN BY THE FOUNDATION B CORRECTION (D-302). The accepted
	## selector now validates EVERY candidate Skill's ladder before its first stage, so
	## the empty-record draw — in which the over-ceiling pool is still a candidate —
	## refuses the same malformed inputs instead of naming a pair. The two assertions
	## that required it to succeed, and the one that looked for the pair it named, now
	## require that it refuses for the same reason, names the same Skill, and that the
	## lane's refusal names no support at all. The same ten assertions.
	var profiles: Array[SkillTagProfile] = []
	profiles.append(_profile(&"zz_skill_heavy", [
		SkillTags.ATTACK, SkillTags.MELEE,
	] as Array[StringName]))
	profiles.append(_profile(&"zz_skill_held", [
		SkillTags.ATTACK, SkillTags.PROJECTILE,
	] as Array[StringName]))
	profiles.append(_profile(&"zz_skill_light", [
		SkillTags.SPELL, SkillTags.FIRE,
	] as Array[StringName]))

	var definitions: Array[SupportDefinition] = []
	for index: int in 5:
		definitions.append(_definition(StringName("zz_t_heavy_%d" % index),
			[SkillTags.MELEE] as Array[StringName], [] as Array[StringName],
			SupportDefinition.MAXIMUM_WEIGHT, {}))
	for index: int in 2:
		definitions.append(_definition(StringName("zz_t_held_%d" % index),
			[SkillTags.PROJECTILE] as Array[StringName], [] as Array[StringName], 10, {}))
	for index: int in 2:
		definitions.append(_definition(StringName("zz_t_light_%d" % index),
			[SkillTags.FIRE] as Array[StringName], [] as Array[StringName], 10, {}))

	## The heavy Skill's own pool exceeds the accepted stream-width ceiling, so
	## the accepted selector refuses the whole selection, whatever a seed would draw.
	_expect(5 * SupportDefinition.MAXIMUM_WEIGHT > SupportSelection.MAXIMUM_TOTAL_WEIGHT,
		"the heavy pool does not exceed the accepted ceiling, so this fixture proves nothing")

	var held: AcquiredSupports = AcquiredSupports.new()
	_expect(held.acquire(&"zz_skill_held", &"zz_t_held_0")
			and held.acquire(&"zz_skill_held", &"zz_t_held_1"),
		"the overflow fixture could not hold the middle Skill's pairs")

	## SEARCHED RATHER THAN GUESSED, and the search is deterministic: the first
	## seed whose accepted first-stage ticket is even AND congruent to 2 modulo 3
	## sends the real draw to the over-ceiling Skill and the empty-record draw to an
	## unheld pair — the old incoherence case, kept so the move is one for one. Since
	## D-302 neither query reaches a draw on it, or on any seed.
	var chosen_seed: int = -1
	for seed_value: int in SEED_SEARCH_LIMIT:
		var ticket: int = SupportSelection.skill_ticket_for(seed_value)
		if ticket % 2 == 0 and ticket % 3 == 2:
			chosen_seed = seed_value
			break
	_expect(chosen_seed >= 0,
		"no seed below %d sends the two queries to different Skills" % SEED_SEARCH_LIMIT)

	if chosen_seed >= 0:
		var real_query: SupportSelectionResult = SupportSelection.select(
			profiles, definitions, held, chosen_seed
		)
		var empty_query: SupportSelectionResult = SupportSelection.select(
			profiles, definitions, AcquiredSupports.new(), chosen_seed
		)
		_expect(not real_query.ok and not real_query.has_no_candidates(),
			"the new-pair draw did not refuse on its ceiling, so this is not the overflow case: %s"
				% real_query.describe())
		_expect(not empty_query.ok and not empty_query.has_no_candidates(),
			"the empty-record query drew from, or found nothing in, the malformed inputs: %s"
				% empty_query.describe())
		_expect(empty_query.failure_reason == real_query.failure_reason,
			"the acquisition record moved the refusal: '%s' against '%s'"
				% [empty_query.failure_reason, real_query.failure_reason])

		var result: SupportContinuationResult = SupportContinuation.select(
			profiles, definitions, held, chosen_seed
		)
		_expect(not result.ok, "F2 advanced past a refused new-pair draw: %s" % result.describe())
		_refusals += 1
		_expect_no_partial_decision(result, "a refused new-pair draw")
		_expect(not result.is_exhausted() and result.failure_reason.contains(real_query.failure_reason),
			"the refusal does not quote the ceiling refusal, or claims exhaustion: %s" % result.failure_reason)
		_expect(not result.failure_reason.contains("zz_t_"),
			"the refusal names a support although no draw chose one: %s" % result.failure_reason)
		print("  seed %d: the new-pair draw and the empty-record draw both refuse the over-ceiling pool"
			% chosen_seed + " — not an empty candidate set — so F2 refuses without entering the rank phase")

	_done("a_refused_new_pair_draw_is_never_advanced_past")


# --- 15. A null acquisition state can only produce a new pair ----------------

func _check_a_null_acquisition_state_can_only_produce_a_new_pair() -> void:
	print("")
	print("--- 15. A NULL acquisition state still means 'nothing acquired', so it cannot rank")

	var profiles: Array[SkillTagProfile] = _two_melee_skills()
	var definitions: Array[SupportDefinition] = _three_melee_supports()

	var ranked: int = 0
	var drifted: PackedStringArray = PackedStringArray()
	for seed_value: int in SEED_SAMPLES:
		var from_null: SupportContinuationResult = SupportContinuation.select(
			profiles, definitions, null, seed_value
		)
		var from_empty: SupportContinuationResult = SupportContinuation.select(
			profiles, definitions, AcquiredSupports.new(), seed_value
		)
		if from_null.ok and from_null.is_rank_increase():
			ranked += 1
		if _full(from_null) != _full(from_empty):
			drifted.append("seed %d: %s against %s" % [
				seed_value, _full(from_null), _full(from_empty),
			])
	_expect(ranked == 0, "a null acquisition state produced %d rank decisions" % ranked)
	_expect(drifted.is_empty(),
		"a null state and an empty record disagree: %s" % ", ".join(drifted))

	## AND WHEN THERE IS NOTHING ELIGIBLE AT ALL, a null state refuses rather
	## than ranking, because ranking would require something to already be held.
	var incompatible: Array[SupportDefinition] = []
	incompatible.append(_definition(SUPPORT_ALPHA, [SkillTags.VOID] as Array[StringName],
		[] as Array[StringName], 10, {}))
	var refused: SupportContinuationResult = SupportContinuation.select(
		profiles, incompatible, null, 3
	)
	_expect(not refused.ok, "a null state with no eligible support did not refuse")
	_refusals += 1
	_expect_no_partial_decision(refused, "a null state with nothing eligible")

	print("  %d seeds: a null state reproduces an empty record exactly and ranks 0 times"
		% SEED_SAMPLES)
	_done("a_null_acquisition_state_can_only_produce_a_new_pair")


# --- 16. Inputs and ranked ownership are observationally unchanged -----------

func _check_inputs_and_ranked_ownership_are_observationally_unchanged() -> void:
	print("")
	print("--- 16. Selection is PURE: no input moves, and no pair count or rank moves")

	var profiles: Array[SkillTagProfile] = _two_melee_skills()
	var definitions: Array[SupportDefinition] = _three_melee_supports()

	var tags_before: Array[StringName] = profiles[0].tags.duplicate()
	var name_before: String = profiles[0].display_name
	var weight_before: int = definitions[0].base_weight
	var bonuses_before: Dictionary = definitions[0].tag_bonuses.duplicate()
	var profile_count: int = profiles.size()
	var definition_count: int = definitions.size()

	## A record in a genuinely mixed state: some pairs held, some raised, so both
	## phases are exercised against something rather than against nothing.
	var record: AcquiredSupports = AcquiredSupports.new()
	_expect(record.acquire(SKILL_ONE, SUPPORT_ALPHA)
			and record.acquire(SKILL_ONE, SUPPORT_BETA)
			and record.acquire(SKILL_TWO, SUPPORT_GAMMA),
		"the purity fixture could not be built")
	for _step: int in 6:
		record.increase_rank(SKILL_ONE, SUPPORT_ALPHA)
	_expect(record.increase_rank(SKILL_TWO, SUPPORT_GAMMA), "the purity fixture refused a raise")

	var pairs_before: PackedStringArray = record.pairs()
	var size_before: int = record.size()
	var ranks_before: int = record.total_ranks()
	var alpha_before: int = record.rank_for(SKILL_ONE, SUPPORT_ALPHA)
	var gamma_before: int = record.rank_for(SKILL_TWO, SUPPORT_GAMMA)
	var describe_before: String = record.describe()
	_expect(size_before == 3 and ranks_before == 10 and alpha_before == 7 and gamma_before == 2,
		"the purity fixture is %d pairs / %d ranks / alpha %d / gamma %d, not 3 / 10 / 7 / 2" % [
			size_before, ranks_before, alpha_before, gamma_before,
		])

	## And the same facts read through the accepted run-build state, which is the
	## other surface a rank can be observed on.
	var build: RiftRunBuild = RiftRunBuild.new()
	_expect(build.acquire_support(SKILL_ONE, SUPPORT_ALPHA).is_empty(),
		"the run build refused its first pair")
	_expect(build.rank_support(SKILL_ONE, SUPPORT_ALPHA).is_empty(),
		"the run build refused its first raise")
	var build_count_before: int = build.support_count()
	var build_ranks_before: int = build.total_support_ranks()
	var build_rank_before: int = build.support_rank_for(SKILL_ONE, SUPPORT_ALPHA)
	_expect(build_count_before == 1 and build_ranks_before == 2 and build_rank_before == 2,
		"the run-build fixture is %d / %d / %d, not 1 / 2 / 2" % [
			build_count_before, build_ranks_before, build_rank_before,
		])

	var exhausted: AcquiredSupports = _raised_to(_exhausted_record(profiles, definitions), 3)
	var exhausted_pairs: PackedStringArray = exhausted.pairs()
	var exhausted_ranks: int = exhausted.total_ranks()

	for seed_value: int in SEED_SAMPLES:
		SupportContinuation.select(profiles, definitions, record, seed_value)
		SupportContinuation.select(profiles, definitions, exhausted, seed_value)
		SupportContinuation.select(profiles, definitions, build.acquired_supports(), seed_value)
		SupportContinuation.select(profiles, definitions, null, seed_value)

	_expect(profiles[0].tags == tags_before and profiles[0].display_name == name_before,
		"a Skill profile was mutated by a selection")
	_expect(definitions[0].base_weight == weight_before
			and definitions[0].tag_bonuses == bonuses_before,
		"a support definition was mutated by a selection")
	_expect(profiles.size() == profile_count and definitions.size() == definition_count,
		"an input array changed length during selection")

	_expect(record.pairs() == pairs_before and record.size() == size_before
			and record.total_ranks() == ranks_before
			and record.rank_for(SKILL_ONE, SUPPORT_ALPHA) == alpha_before
			and record.rank_for(SKILL_TWO, SUPPORT_GAMMA) == gamma_before
			and record.describe() == describe_before,
		"the acquisition record moved during selection: %s" % record.describe())
	_expect(exhausted.pairs() == exhausted_pairs and exhausted.total_ranks() == exhausted_ranks,
		"the exhausted record moved during selection")
	_expect(build.support_count() == build_count_before
			and build.total_support_ranks() == build_ranks_before
			and build.support_rank_for(SKILL_ONE, SUPPORT_ALPHA) == build_rank_before,
		"the run-build state moved during selection: %d pairs, %d ranks" % [
			build.support_count(), build.total_support_ranks(),
		])

	## SELECTING IS NOT ACQUIRING AND IT IS NOT RANKING. Nothing was recorded and
	## nothing was raised, which is asserted rather than assumed.
	var fresh: AcquiredSupports = AcquiredSupports.new()
	for seed_value: int in 32:
		SupportContinuation.select(profiles, definitions, fresh, seed_value)
	_expect(fresh.is_empty(), "the continuation recorded an acquisition by itself: %s"
		% fresh.describe())

	print("  %d seeds over 4 states: 0 inputs moved; 3 pairs / 10 ranks and 1 pair / 2 ranks"
		% SEED_SAMPLES + " unchanged on both surfaces")
	_done("inputs_and_ranked_ownership_are_observationally_unchanged")


# --- 17. Identical inputs and seed reproduce the complete result -------------

func _check_identical_inputs_and_seed_reproduce_the_complete_result() -> void:
	print("")
	print("--- 17. %d identical calls reproduce the COMPLETE result in both phases"
		% REPEAT_CALLS)

	var profiles: Array[SkillTagProfile] = _two_melee_skills()
	var definitions: Array[SupportDefinition] = _three_melee_supports()

	var partial: AcquiredSupports = AcquiredSupports.new()
	_expect(partial.acquire(SKILL_ONE, SUPPORT_ALPHA), "the repeat fixture refused its pair")
	var exhausted: AcquiredSupports = _raised_to(_exhausted_record(profiles, definitions), 2)

	var drifted: int = 0
	for row: Array in [[partial, "new-pair"], [exhausted, "rank"]]:
		var record: AcquiredSupports = row[0] as AcquiredSupports
		var first: String = _full(SupportContinuation.select(profiles, definitions, record, 20260909))
		for _call: int in REPEAT_CALLS:
			if _full(SupportContinuation.select(profiles, definitions, record, 20260909)) != first:
				drifted += 1
	_expect(drifted == 0, "%d repeated calls disagreed" % drifted)

	## AND FROM FRESHLY REBUILT RECORDS, so the reproduction is a property of the
	## inputs rather than of the objects that happen to be in memory.
	var rebuilt: PackedStringArray = PackedStringArray()
	for seed_value: int in SEED_SAMPLES:
		var a: String = _full(SupportContinuation.select(
			_two_melee_skills(), _three_melee_supports(),
			_raised_to(_exhausted_record(_two_melee_skills(), _three_melee_supports()), 9),
			seed_value))
		var b: String = _full(SupportContinuation.select(
			_two_melee_skills(), _three_melee_supports(),
			_raised_to(_exhausted_record(_two_melee_skills(), _three_melee_supports()), 9),
			seed_value))
		if a != b:
			rebuilt.append("seed %d: %s against %s" % [seed_value, a, b])
	_expect(rebuilt.is_empty(),
		"freshly rebuilt records disagreed: %s" % ", ".join(rebuilt))

	## TWO SEEDS DISAGREE, or the reproduction above would be the reproduction of
	## a constant.
	var varied: Dictionary = {}
	for seed_value: int in SEED_SAMPLES:
		varied[_full(SupportContinuation.select(
			profiles, definitions, exhausted, seed_value))] = true
	_expect(varied.size() > 1,
		"every seed produced the same rank decision, so determinism proves nothing here")

	print("  %d repeats in both phases agree; %d distinct rank outcomes over %d seeds"
		% [REPEAT_CALLS, varied.size(), SEED_SAMPLES])
	_done("identical_inputs_and_seed_reproduce_the_complete_result")


# --- 18. The result validates its own coherence ------------------------------

func _check_the_result_validates_its_own_coherence() -> void:
	print("")
	print("--- 18. The result record refuses to describe an incoherent decision")

	var profiles: Array[SkillTagProfile] = _one_melee_skill()
	var definitions: Array[SupportDefinition] = _two_melee_supports()
	var good: SupportSelectionResult = SupportSelection.select(
		profiles, definitions, AcquiredSupports.new(), 5
	)
	_expect(good.ok and good.problem().is_empty(), "the coherence fixture's selection refused")

	## A FAILURE CARRIES NOTHING AT ALL.
	var refused: SupportContinuationResult = SupportContinuationResult.failed("a stated reason")
	_expect(refused.problem().is_empty(), "a plain refusal reports: %s" % refused.problem())
	_expect(refused.kind == SupportContinuationResult.UNRESOLVED_KIND
			and String(refused.skill_id).is_empty() and String(refused.support_id).is_empty()
			and refused.selection == null and not refused.held_when_classified,
		"a refusal carries a partial decision: %s" % refused.describe())
	_expect(not refused.is_new_pair() and not refused.is_rank_increase(),
		"a refusal answers one of the decision predicates")
	_expect(refused.pair().is_empty(), "a refusal names the pair %s" % refused.pair())
	var unstated: SupportContinuationResult = SupportContinuationResult.failed("   ")
	_expect(not unstated.failure_reason.strip_edges().is_empty(),
		"a refusal with a blank reason was allowed to state nothing")
	_expect(unstated.problem().is_empty(),
		"a refusal with a substituted reason reports: %s" % unstated.problem())

	## A RANK DECISION WHOSE PAIR WAS NOT HELD IS INCOHERENT, and so is a new
	## pair whose pair WAS. This is the assertion that makes the measured
	## `held_when_classified` load-bearing instead of a restatement of the kind.
	var lying_rank: SupportContinuationResult = SupportContinuationResult.rank_increase(good, false)
	_expect(not lying_rank.problem().is_empty(),
		"a rank decision over an unheld pair reported itself as coherent")
	_expect(lying_rank.problem().contains("not held"),
		"the incoherence is not attributed: %s" % lying_rank.problem())
	var lying_new: SupportContinuationResult = SupportContinuationResult.new_pair(good, true)
	_expect(not lying_new.problem().is_empty(),
		"a new-pair decision over a held pair reported itself as coherent")

	## THE IDS MUST EQUAL THE NESTED DERIVATION'S OWN ANSWERS.
	var drifted: SupportContinuationResult = SupportContinuationResult.new_pair(good, false)
	drifted.support_id = &"zz_not_the_selected_support"
	_expect(not drifted.problem().is_empty(),
		"an identity field was allowed to drift from the derivation")

	## A SUCCESS MUST CARRY A SUCCESSFUL, COHERENT DERIVATION.
	var failed_selection: SupportSelectionResult = SupportSelectionResult.failed("nothing was drawn")
	var over_failure: SupportContinuationResult = SupportContinuationResult.new_pair(
		failed_selection, false
	)
	_expect(not over_failure.problem().is_empty(),
		"a decision built over a failed selection reported itself as coherent")
	var no_selection: SupportContinuationResult = SupportContinuationResult.new_pair(null, false)
	_expect(not no_selection.problem().is_empty(),
		"a decision with no derivation at all reported itself as coherent")
	## An INCOHERENT but nominally successful derivation: the effective weight
	## does not equal its own base plus bonuses.
	var incoherent_selection: SupportSelectionResult = SupportSelectionResult.chosen(
		SKILL_ONE, SUPPORT_ALPHA, 4, {}, 99, 0, 100, 1, 0
	)
	_expect(incoherent_selection.ok and not incoherent_selection.problem().is_empty(),
		"the incoherent-derivation fixture is not actually incoherent")
	var over_incoherent: SupportContinuationResult = SupportContinuationResult.new_pair(
		incoherent_selection, false
	)
	_expect(not over_incoherent.problem().is_empty(),
		"a decision carrying an incoherent derivation reported itself as coherent")
	_expect(over_incoherent.problem().contains("nested"),
		"the nested incoherence is not attributed: %s" % over_incoherent.problem())

	## AN UNDECLARED KIND IS REFUSED.
	var unknown_kind: SupportContinuationResult = SupportContinuationResult.new_pair(good, false)
	unknown_kind.kind = 7
	_expect(not unknown_kind.problem().is_empty(), "an unknown decision kind was accepted")
	var success_with_reason: SupportContinuationResult = SupportContinuationResult.new_pair(
		good, false
	)
	success_with_reason.failure_reason = "something went wrong"
	_expect(not success_with_reason.problem().is_empty(),
		"a success carrying a failure reason was accepted")

	## PRESENTATION IS PRESENTATION, and it names all three states.
	_expect(SupportContinuationResult.kind_label(SupportContinuationResult.Kind.NEW_PAIR)
			!= SupportContinuationResult.kind_label(
				SupportContinuationResult.Kind.RANK_INCREASE),
		"the two decision kinds share a label")
	_expect(SupportContinuationResult.kind_label(SupportContinuationResult.UNRESOLVED_KIND)
			== "no decision",
		"an unresolved kind does not label itself as no decision")

	print("  11 incoherent constructions refused; a refusal carries no kind, no ids, no derivation")
	_done("the_result_validates_its_own_coherence")


# --- 19. Generic, ambient-free, rank-blind and unwired -----------------------

func _check_the_foundation_is_generic_reads_nothing_ambient_and_is_unwired() -> void:
	print("")
	print("--- 19. F2 names nothing concrete, reads nothing ambient and no rank, and is UNWIRED")

	## SCANNED RAW, COMMENTS INCLUDED, for concrete names and ambient sources. An
	## illustrative name in a comment breaches the rule just as surely as a real
	## one, because the rule exists so a reader can trust the file holds none.
	var named: PackedStringArray = PackedStringArray()
	var ambient: PackedStringArray = PackedStringArray()
	var rank_reads: PackedStringArray = PackedStringArray()
	var deferred: PackedStringArray = PackedStringArray()
	for path: String in F2_FILES:
		var raw: String = FileAccess.get_file_as_string(path)
		_expect(not raw.is_empty(), "%s could not be read" % path)
		var code: String = _code_only(raw)
		for token: String in FORBIDDEN_TOKENS:
			if raw.contains(token):
				named.append("%s names %s" % [path.get_file(), token])
		for token: String in AMBIENT_TOKENS:
			if raw.contains(token):
				ambient.append("%s reads %s" % [path.get_file(), token])
		## RANK MEMBERS AND DEFERRED CONCEPTS ARE ASKED OF THE CODE ONLY, because
		## saying in a comment that a concept is deliberately absent is exactly
		## the documentation this project wants, while CALLING one is the fault.
		for token: String in RANK_MEMBER_TOKENS:
			if code.contains(token):
				rank_reads.append("%s calls %s" % [path.get_file(), token])
		for token: String in DEFERRED_TOKENS:
			if code.contains(token):
				deferred.append("%s carries %s" % [path.get_file(), token])
	_expect(named.is_empty(), "F2 names something concrete: %s" % ", ".join(named))
	_expect(ambient.is_empty(), "F2 reads ambient state: %s" % ", ".join(ambient))
	_expect(rank_reads.is_empty(),
		"F2 reads a rank, so a rank could move a selection: %s" % ", ".join(rank_reads))
	_expect(deferred.is_empty(), "F2 carries deferred concepts: %s" % ", ".join(deferred))

	## THE SCAN IS PROVED CAPABLE OF FAILING, by finding its own tokens where they
	## legitimately live.
	var catalogue_source: String = FileAccess.get_file_as_string(
		"res://scripts/skills/skill_support_catalogue.gd")
	var found_in_catalogue: int = 0
	for token: String in FORBIDDEN_TOKENS:
		if catalogue_source.contains(token):
			found_in_catalogue += 1
	_expect(found_in_catalogue >= 4,
		"the concrete-name scan found only %d of its tokens in the one file that legitimately"
			% found_in_catalogue + " holds them, so it may be inert")
	var record_source: String = FileAccess.get_file_as_string(
		"res://scripts/skills/acquired_supports.gd")
	var found_rank_members: int = 0
	for token: String in RANK_MEMBER_TOKENS:
		if record_source.contains(token):
			found_rank_members += 1
	_expect(found_rank_members >= 3,
		"the rank-member scan found only %d of its tokens in the record that declares them"
			% found_rank_members)

	## AN ALLOWLIST, NOT ONLY A DENYLIST. The engine is asked which project
	## classes exist, and each F2 file must name none of them but the ones it is
	## entitled to.
	var project_classes: PackedStringArray = PackedStringArray()
	for entry: Dictionary in ProjectSettings.get_global_class_list():
		var class_id: String = String(entry.get("class", ""))
		if not class_id.is_empty():
			project_classes.append(class_id)
	_expect(project_classes.size() > 20,
		"only %d project classes were enumerated; the allowlist may be inert"
			% project_classes.size())
	var unauthorized: PackedStringArray = PackedStringArray()
	for row: Array in AUTHORIZED_CLASSES:
		var path: String = String(row[0])
		var granted: Array = row[1]
		var raw: String = FileAccess.get_file_as_string(path)
		for class_id: String in project_classes:
			if raw.contains(class_id) and not granted.has(class_id):
				unauthorized.append("%s names %s" % [path.get_file(), class_id])
	_expect(unauthorized.is_empty(),
		"an F2 file names an unauthorized project class: %s" % ", ".join(unauthorized))
	## AND EACH GRANT IS EARNED, so a grant cannot quietly become a claim about
	## nothing while still passing.
	var unused: PackedStringArray = PackedStringArray()
	for row: Array in AUTHORIZED_CLASSES:
		var raw: String = FileAccess.get_file_as_string(String(row[0]))
		for class_id: String in row[1]:
			if not raw.contains(class_id):
				unused.append("%s is granted %s and does not name it" % [
					String(row[0]).get_file(), class_id,
				])
	_expect(unused.is_empty(), "an unearned grant: %s" % ", ".join(unused))

	## THE TWO ACCEPTED SUITES WHOSE ALLOWLISTS MOVED ONE FOR ONE STILL CARRY THE
	## GRANTS THIS FOUNDATION DEPENDS ON. Two independently typed copies of one
	## list is how they drift, so each grant is checked from this side as well.
	for row: Array in AUTHORIZING_SUITES:
		var suite_source: String = FileAccess.get_file_as_string(String(row[0]))
		_expect(not suite_source.is_empty(),
			"the Foundation %s suite could not be read" % String(row[1]))
		var listed: int = 0
		for path: String in row[2]:
			if suite_source.contains(path):
				listed += 1
		_expect(listed == (row[2] as Array).size(),
			"the Foundation %s suite authorizes %d of the %d F2 scripts it must" % [
				String(row[1]), listed, (row[2] as Array).size(),
			])

	## NOTHING NAMES F2 EXCEPT AN AUTHORIZED READER. This decision is composed into
	## the accepted three-lane offer by Foundation F3; the choice transaction, the
	## choice result and the level-up receipt read the record's declarations and
	## make no decision of their own; nothing applies or persists it — so both
	## classes must be reachable from no running code outside `AUTHORIZED_READERS`.
	var project_files: int = 0
	var referenced: PackedStringArray = PackedStringArray()
	for root: String in SCANNED_ROOTS:
		for path: String in _files_under(root, [".gd", ".tscn", ".tres"]):
			if F2_FILES.has(path):
				continue
			project_files += 1
			var source: String = FileAccess.get_file_as_string(path)
			for class_id: String in F2_CLASSES:
				if not source.contains(class_id):
					continue
				if _is_authorized_reader(path, class_id):
					continue
				referenced.append("%s names %s" % [path.get_file(), class_id])
	var settings: String = FileAccess.get_file_as_string(PROJECT_SETTINGS_FILE)
	for class_id: String in F2_CLASSES:
		if settings.contains(class_id):
			referenced.append("project.godot names %s" % class_id)
	_expect(referenced.is_empty(),
		"Foundation F2 is referenced by code that runs: %s" % ", ".join(referenced))
	_expect(project_files > 100,
		"only %d project files were scanned, so the scan proves nothing" % project_files)

	## THE DIRECTORY HOLDS EXACTLY WHAT IT SHOULD. A scratch probe left behind is
	## a project file nobody meant to ship, and every scan above that filters on a
	## known path is blind to it.
	var continuation_scripts: PackedStringArray = _files_under(
		"res://scripts/continuation", [".gd"])
	var sorted_scripts: PackedStringArray = PackedStringArray(continuation_scripts)
	sorted_scripts.sort()
	var owed_scripts: PackedStringArray = PackedStringArray()
	for path: String in F2_FILES:
		owed_scripts.append(path)
	owed_scripts.sort()
	_expect(", ".join(sorted_scripts) == ", ".join(owed_scripts),
		"scripts/continuation/ holds: %s" % ", ".join(sorted_scripts))

	## THE METHOD AND FIELD PINS. A token scan can only refuse names somebody
	## remembered; a second stream, a rank reading, an offer composition or an
	## application step each arrive as an extra method with a plausible name.
	_expect(", ".join(_methods_of(RESULT_FILE)) == ", ".join(EXPECTED_RESULT_METHODS),
		"the result record declares: %s" % ", ".join(_methods_of(RESULT_FILE)))
	_expect(", ".join(_methods_of(CONTINUATION_FILE)) == ", ".join(EXPECTED_CONTINUATION_METHODS),
		"the continuation selector declares: %s" % ", ".join(_methods_of(CONTINUATION_FILE)))
	var fields: PackedStringArray = PackedStringArray()
	for entry: Dictionary in SupportContinuationResult.new().get_property_list():
		if int(entry.get("usage", 0)) & PROPERTY_USAGE_SCRIPT_VARIABLE != 0:
			fields.append(String(entry.get("name", "")))
	_expect(", ".join(fields) == ", ".join(EXPECTED_RESULT_FIELDS),
		"the result record carries the fields: %s" % ", ".join(fields))
	var selector_fields: PackedStringArray = PackedStringArray()
	for entry: Dictionary in SupportContinuation.new().get_property_list():
		if int(entry.get("usage", 0)) & PROPERTY_USAGE_SCRIPT_VARIABLE != 0:
			selector_fields.append(String(entry.get("name", "")))
	_expect(selector_fields.is_empty(),
		"the selector carries state: %s" % ", ".join(selector_fields))

	## THE READER COUNT IS READ FROM THE AUTHORITATIVE LIST RATHER THAN TYPED (D-261):
	## it printed a literal 2 through two later reader additions.
	print("  %d project files scanned, only the %d authorized readers name an F2 class; "
		% [project_files, AUTHORIZED_READERS.size()]
		+ "%d project classes enumerated" % project_classes.size())
	print("  0 concrete names, 0 ambient reads, 0 rank readings, 0 deferred concepts")
	print("  %d refusals were driven across this suite" % _refusals)
	_done("the_foundation_is_generic_reads_nothing_ambient_and_is_unwired")


# --- 20. Nothing that already existed changed --------------------------------

func _check_nothing_existing_changed() -> void:
	print("")
	print("--- 20. Every accepted foundation still answers exactly as it did")

	## Foundation A.
	_expect(SkillSupportCatalogue.supports().size() == 2,
		"the catalogue holds %d eligibility rules, not 2" % SkillSupportCatalogue.supports().size())
	_expect(SkillSupportCatalogue.skill_profiles().size() == 1,
		"the catalogue holds %d Skill profiles, not 1"
			% SkillSupportCatalogue.skill_profiles().size())
	_expect(SkillSupportCatalogue.problems().is_empty(),
		"the catalogue reports problems: %s" % ", ".join(SkillSupportCatalogue.problems()))

	## Foundation B: the shipped ladder, walked rather than argued.
	var definitions: Array[SupportDefinition] = SkillSupportCatalogue.support_definitions()
	var profiles: Array[SkillTagProfile] = []
	profiles.append(SkillSupportCatalogue.quick_strike_profile())
	_expect(definitions.size() == 2, "the catalogue holds %d definitions, not 2" % definitions.size())
	var counts: Dictionary = {}
	for ticket: int in 200:
		var walked: SupportSelectionResult = SupportSelection.select_with_tickets(
			profiles, definitions, AcquiredSupports.new(), 0, ticket
		)
		counts[walked.support_id] = int(counts.get(walked.support_id, 0)) + 1
	_expect(counts.size() == 2 and int(counts.get(SkillSupportCatalogue.REACHING_EDGE_ID, 0)) == 100
			and int(counts.get(SkillSupportCatalogue.SWEEPING_EDGE_ID, 0)) == 100,
		"the shipped ladder is no longer 100 / 100 over 200 tickets: %s" % counts)
	_expect(SupportSelection.MAXIMUM_TOTAL_WEIGHT == 0xFFFFFFFF,
		"the accepted total-weight ceiling moved to %d" % SupportSelection.MAXIMUM_TOTAL_WEIGHT)

	## Foundation F1: the accepted ranked-ownership semantics, unmoved.
	var record: AcquiredSupports = AcquiredSupports.new()
	_expect(record.acquire(SKILL_ONE, SUPPORT_ALPHA), "a first acquisition was refused")
	_expect(record.rank_for(SKILL_ONE, SUPPORT_ALPHA) == AcquiredSupports.FIRST_RANK,
		"a first acquisition begins at rank %d" % record.rank_for(SKILL_ONE, SUPPORT_ALPHA))
	_expect(record.rank_for(SKILL_TWO, SUPPORT_ALPHA) == AcquiredSupports.ABSENT_RANK,
		"an absent pair reports rank %d" % record.rank_for(SKILL_TWO, SUPPORT_ALPHA))
	_expect(not record.acquire(SKILL_ONE, SUPPORT_ALPHA),
		"a duplicate acquisition was accepted")
	_expect(record.increase_rank(SKILL_ONE, SUPPORT_ALPHA)
			and record.rank_for(SKILL_ONE, SUPPORT_ALPHA) == 2,
		"a rank increase did not step by exactly one")
	_expect(record.size() == 1 and record.total_ranks() == 2,
		"the record reports %d pairs and %d ranks, not 1 and 2" % [
			record.size(), record.total_ranks(),
		])
	_expect(", ".join(record.pairs()) == "%s -> %s" % [SKILL_ONE, SUPPORT_ALPHA],
		"the accepted pair listing changed: %s" % ", ".join(record.pairs()))

	## Build Variety V1's own values, unmoved.
	_expect(RogueliteUpgrade.POOL.size() == 4,
		"the upgrade pool holds %d entries, not 4" % RogueliteUpgrade.POOL.size())
	_expect(is_equal_approx(RogueliteUpgrade.REACHING_EDGE_REACH, 2.65),
		"REACHING_EDGE_REACH moved to %.4f" % RogueliteUpgrade.REACHING_EDGE_REACH)
	_expect(is_equal_approx(RogueliteUpgrade.SWEEPING_EDGE_ARC_DEGREES, 180.0),
		"SWEEPING_EDGE_ARC_DEGREES moved to %.4f" % RogueliteUpgrade.SWEEPING_EDGE_ARC_DEGREES)

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

	## The entrypoint and the InputMap, counted exactly as every existing suite
	## counts them.
	var settings: String = FileAccess.get_file_as_string(PROJECT_SETTINGS_FILE)
	_expect(not settings.contains("[autoload]"), "project.godot declares an [autoload] section")
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

	print("  A, B and F1 answer exactly as before; the shipped ladder is 100 / 100; 31 actions")
	_done("nothing_existing_changed")


# --- Fixtures and helpers ------------------------------------------------------
#
# Generic and test-only: registered in no catalogue, saved in no resource, and
# not canon.

func _profile(id: StringName, tags: Array[StringName]) -> SkillTagProfile:
	return SkillTagProfile.of(id, "Test Skill %s" % id, tags)


## Every fixture definition declares `FIXTURE_MAXIMUM_RANK` (Foundation I5, D-300),
## so the rank phase this suite has always driven stays reachable.
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


func _one_melee_skill() -> Array[SkillTagProfile]:
	var out: Array[SkillTagProfile] = []
	out.append(_profile(SKILL_ONE, [
		SkillTags.ATTACK, SkillTags.HIT, SkillTags.MELEE, SkillTags.STRIKE, SkillTags.PHYSICAL,
	] as Array[StringName]))
	return out


func _two_melee_skills() -> Array[SkillTagProfile]:
	var out: Array[SkillTagProfile] = _one_melee_skill()
	out.append(_profile(SKILL_TWO, [
		SkillTags.ATTACK, SkillTags.HIT, SkillTags.MELEE, SkillTags.PHYSICAL,
	] as Array[StringName]))
	return out


func _three_melee_skills() -> Array[SkillTagProfile]:
	var out: Array[SkillTagProfile] = _two_melee_skills()
	out.append(_profile(SKILL_THREE, [
		SkillTags.ATTACK, SkillTags.MELEE, SkillTags.PHYSICAL,
	] as Array[StringName]))
	return out


func _two_melee_supports() -> Array[SupportDefinition]:
	var out: Array[SupportDefinition] = []
	out.append(_definition(SUPPORT_ALPHA, [SkillTags.MELEE] as Array[StringName],
		[] as Array[StringName], WEIGHT_ALPHA, {}))
	out.append(_definition(SUPPORT_BETA, [SkillTags.MELEE] as Array[StringName],
		[] as Array[StringName], WEIGHT_BETA, {}))
	return out


func _three_melee_supports() -> Array[SupportDefinition]:
	var out: Array[SupportDefinition] = _two_melee_supports()
	out.append(_definition(SUPPORT_GAMMA, [SkillTags.MELEE] as Array[StringName],
		[] as Array[StringName], WEIGHT_GAMMA, {}))
	return out


## Every eligible pair held, built by asking the accepted eligibility rule rather
## than by listing pairs by hand — a list typed out here could quietly stop
## matching the fixture it is meant to exhaust.
func _exhausted_record(
	profiles: Array[SkillTagProfile],
	definitions: Array[SupportDefinition]
) -> AcquiredSupports:
	var record: AcquiredSupports = AcquiredSupports.new()
	for profile: SkillTagProfile in profiles:
		for definition: SupportDefinition in definitions:
			if definition.allows(profile):
				record.acquire(profile.skill_id, definition.support_id())
	return record


## The same record with every held pair raised to exactly `rank`.
func _raised_to(record: AcquiredSupports, rank: int) -> AcquiredSupports:
	for line: String in record.pairs():
		var parts: PackedStringArray = line.split(" -> ")
		if parts.size() != 2:
			continue
		var skill: StringName = StringName(parts[0])
		var support: StringName = StringName(parts[1])
		while record.rank_for(skill, support) < rank:
			if not record.increase_rank(skill, support):
				break
	return record


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


## Every first-stage ticket walked and counted, never sampled: an excluded Skill
## must be UNREACHABLE rather than merely unlikely.
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


## The same walk over the accepted selector's RANK-INCREASE draw (Foundation I5,
## D-300): every first-stage ticket, counted, never sampled.
func _sweep_rank_skill_tickets(
	profiles: Array[SkillTagProfile],
	definitions: Array[SupportDefinition],
	acquired: AcquiredSupports,
	tickets: int
) -> Dictionary:
	var counts: Dictionary = {}
	for ticket: int in tickets:
		var result: SupportSelectionResult = SupportSelection.select_rank_increase_with_tickets(
			profiles, definitions, acquired, ticket, 0
		)
		if not result.ok:
			counts[&"<refused>"] = int(counts.get(&"<refused>", 0)) + 1
			continue
		counts[result.skill_id] = int(counts.get(result.skill_id, 0)) + 1
	return counts


# --- Plumbing ----------------------------------------------------------------

## EVERY FIELD, so a comparison cannot pass because the two results happen to
## agree about the pair while disagreeing about how it was reached — the
## exhaustion classification (Foundation I5, D-300) included.
func _full(result: SupportContinuationResult) -> String:
	if result == null:
		return "<null>"
	return "ok=%s kind=%d skill=%s support=%s held=%s exhausted=%s reason=%s | %s" % [
		result.ok, result.kind, result.skill_id, result.support_id,
		result.held_when_classified, result.exhausted, result.failure_reason,
		_selection_signature(result.selection),
	]


func _selection_signature(selection: SupportSelectionResult) -> String:
	if selection == null:
		return "<no selection>"
	return "ok=%s skill=%s support=%s skill_ticket=%d of %d ticket=%d of %d base=%d effective=%d bonuses=%s reason=%s" % [
		selection.ok, selection.skill_id, selection.support_id,
		selection.skill_ticket, selection.eligible_skill_count,
		selection.rolled_ticket, selection.total_eligible_weight,
		selection.base_weight, selection.effective_weight,
		selection.matched_bonuses, selection.failure_reason,
	]


## A refusal must carry NO decision at all: no kind, no ids, no derivation. This
## is the assertion that stops a caller reading a pair out of a result that
## decided nothing.
func _expect_no_partial_decision(result: SupportContinuationResult, described: String) -> void:
	_expect(result.problem().is_empty(),
		"%s produced a partial decision: %s" % [described, result.problem()])
	_expect(not result.failure_reason.strip_edges().is_empty(),
		"%s refused without stating a reason" % described)
	_expect(result.kind == SupportContinuationResult.UNRESOLVED_KIND
			and String(result.skill_id).is_empty() and String(result.support_id).is_empty()
			and result.selection == null and not result.held_when_classified,
		"%s left decision fields populated: %s" % [described, result.describe()])


## Every line that is not a whole-line comment. Used for the claims about what
## the code DOES, so that documenting a deliberate absence is not itself a fault.
func _code_only(source: String) -> String:
	var out: PackedStringArray = PackedStringArray()
	for line: String in source.split("\n"):
		if line.strip_edges().begins_with("#"):
			continue
		out.append(line)
	return "\n".join(out)


func _methods_of(path: String) -> PackedStringArray:
	var out: PackedStringArray = PackedStringArray()
	var script: GDScript = load(path) as GDScript
	if script == null:
		return out
	for entry: Dictionary in script.get_script_method_list():
		out.append(String(entry.get("name", "")))
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
