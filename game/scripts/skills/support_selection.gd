class_name SupportSelection
extends RefCounted
## Riftwrought — Roguelite Foundation B: deterministic weighted selection of one
## compatible, pre-targeted `equipped Skill -> support` pair (decision D-227).
##
## THE ONE QUESTION THIS FILE ANSWERS: given what is equipped, what is defined,
## and what is already held, which single pair does this seed produce? It
## produces a PAIR rather than a support, because a support with no Skill
## attached is not yet an offer: someone would still have to decide which Skill
## it lands on, and deciding that later is how an offer becomes impossible to
## reproduce from its seed.
##
## IT NAMES NOTHING CONCRETE, AND THE SUITE SCANS THE RAW SOURCE TO PROVE IT.
## No Skill, no class, no support, no review instrument and no upgrade kind is
## named here in code or in a comment. Everything it works on arrives as
## arguments. A selector that knows one support's name is a selector that can be
## tuned for it, and the tuning would then live in the mechanism rather than in
## the record.
##
##
## THE TWO STAGES, AND WHY THERE ARE TWO
## ---------------------------------------------------------------------------
##   1. Uniformly choose one equipped Skill FROM THOSE THAT HAVE AT LEAST ONE
##      available eligible support.
##   2. Choose one of THAT Skill's available supports by effective weight.
##
## A single flat draw over every legal pair would be simpler and would be
## wrong: a Skill would become more likely purely because the catalogue happens
## to contain more supports written for it. Cataloguing is an authoring
## activity, and authoring more content for a Skill must not silently make that
## Skill the one the game keeps offering. Splitting the draw makes first-stage
## probability depend on the number of ELIGIBLE SKILLS and on nothing else, by
## construction rather than by tuning.
##
## THE FIRST STAGE SEES ONLY SKILLS THAT CAN ACTUALLY RECEIVE SOMETHING. A Skill
## with no available support is not a candidate, so the second stage can never
## be handed an empty pool — the two stages cannot disagree about who is
## eligible, because the second stage's pool is the very thing the first stage
## filtered on.
##
##
## DETERMINISM, AND WHAT IS AND IS NOT PROMISED
## ---------------------------------------------------------------------------
## `select()` takes an explicit seed. Nothing here reads a global random source,
## a clock, the filesystem, a node, project settings or any other ambient state,
## and the suite scans this file for every one of those. The same seed with the
## same inputs returns the same pair forever.
##
## "The same inputs" is exact and includes what is already ACQUIRED, because an
## already-held pair is unavailable — so the second offer of a session
## legitimately depends on what was taken from the first. That dependency is the
## requirement working rather than a weakness in the reproduction, and it is the
## same honest nuance D-222 recorded for seeded room selection.
##
## EVERY CANDIDATE IS SORTED BY ITS STABLE ID BEFORE EITHER DRAW, so the order
## the caller happened to build its arrays in — and the order a catalogue
## happened to declare its records in — cannot move a seeded result. Inserting a
## record at the top of a catalogue file is an editing convenience and must not
## be a balance change.
##
## THE MIXER IS THIS FILE'S OWN, AND THE DUPLICATION IS DELIBERATE AND STATED.
## The project already contains the same well-known 32-bit avalanche finalizer
## inside a temporary review instrument. Reusing it would couple a durable,
## class-agnostic Skill-facing foundation to a review that is expected to be
## replaced, and it would make this file name a class the purity scan forbids.
## Extracting a shared mixer would instead mean editing that review's own base
## class, which this work is explicitly not authorized to touch. So the same
## arithmetic exists twice, on purpose, and this sentence is the record of why.
##
##
## FAIL CLOSED, ALWAYS, AND NEVER PARTIALLY
## ---------------------------------------------------------------------------
## An invalid definition REFUSES THE WHOLE SELECTION rather than being quietly
## skipped. Skipping is the tempting behaviour and it is the wrong one: a
## mistyped weight would then silently remove a support from the game while
## every offer still looked perfectly normal, and nothing would ever report it.
## Refusing is loud, and loud is recoverable.
##
## Every refusal returns a `SupportSelectionResult` that names its reason and
## carries no partial selection.
##
## EVERY CANDIDATE POOL IS VALIDATED BEFORE EITHER STAGE DRAWS (Foundation B
## correction, D-302). A seed chooses AMONG valid candidate pools; it must never
## decide whether the selection problem it was handed is valid. So once the records
## and the acquisition state are valid, each draw builds the complete candidate pool
## of every equipped Skill in stable Skill order, then builds and validates EVERY
## non-empty pool's integer weight ladder — an effective weight below one, a sum
## past `MAXIMUM_TOTAL_WEIGHT`, a total below one — before stage one reads a ticket.
## One unusable pool refuses the whole selection, naming the first unusable Skill in
## stable Skill-ID order, whatever order the caller built its arrays in. Until D-302
## a ladder was built only for the Skill stage one had already chosen, so the same
## malformed inputs selected a valid Skill's pair on some seeds and refused on
## others. No valid selection moved: a valid pool builds exactly the ladder it always
## built, and stage one still sees exactly the Skills it always saw.
##
## ONLY ACTUAL CANDIDATES ARE WEIGHED. A pool holds the pairs that are candidates in
## the current mode — eligible and unacquired for a new pair; eligible, held and
## below the maximum for a rank increase — so a definition that is not a candidate
## in that mode belongs to no ladder and can never cause an overflow.
##
## EACH LADDER IS BUILT ONCE PER CALL, AND STAGE TWO WALKS THAT SAME LADDER.
## `_ladder_problem()` builds every candidate Skill's weights and total; `_draw()`
## computes no weight and checks no ceiling, so it cannot build a different ladder
## after a Skill has been chosen. Nothing is kept past the call.
##
## AN EMPTY CANDIDATE SET IS THE ONE REFUSAL THAT IS CLASSIFIED (D-301). When the
## inputs were valid and the walk found nothing to draw, the refusal is built by
## `SupportSelectionResult.no_candidates_found()`; every other refusal — a record
## that fails validation, an invalid acquisition state, an unusable weight, a ladder
## over the ceiling — is an ordinary `failed()`. A caller that must decide what to
## ask next reads that classification and never the sentence. It moves no ticket and
## no successful draw: it only says which kind of refusal a refusal is.
##
##
## THE RANK-INCREASE SELECTION (Foundation I5, D-300): THE SAME DRAW, A DIFFERENT
## POOL
## ---------------------------------------------------------------------------
## `select_rank_increase()` answers the second question a support lane can ask:
## which HELD pair does this seed raise by one rank? It is not a second selector.
## It runs the same validation, the same stable ordering, the same two stages and
## the same integer weight ladder as `select()` — the shared code below — and it
## differs in exactly one place: which pairs are candidates. A pair is a candidate
## only when its support is eligible for that Skill, the pair is already held, and
## its current rank is BELOW the maximum rank its definition declares.
##
## A PAIR AT ITS MAXIMUM OWNS NO TICKET, AND A SKILL LEFT WITH ONLY SUCH PAIRS IS
## NOT IN THE FIRST STAGE, for the same reason a Skill with nothing new is not in
## the new-pair draw: the second stage can never be handed an empty pool, and a
## Skill whose every held pair is finished cannot absorb a first-stage ticket that
## another Skill could use. Stage one stays uniform over the Skills that still have
## something to raise, so catalogue depth still cannot become balance.
##
## THE RANK IS READ, NEVER WEIGHED. A pair at rank one and a pair one step below its
## maximum own exactly the same tickets. The current rank decides only whether a
## pair is a candidate at all, which is the whole of what a maximum is.
##
## A USABLE MAXIMUM IS PART OF EVERY DEFINITION'S VALIDITY (D-301), so BOTH draws
## refuse a definition without one — skipping it would make an unrankable support
## look exactly like one that had merely reached its maximum, and acquiring it would
## hold a pair nothing could ever raise.
##
## A PAIR HELD ABOVE ITS DECLARED MAXIMUM IS AN INVALID ACQUISITION STATE, AND BOTH
## DRAWS REFUSE IT BEFORE ANY POOL IS BUILT (D-301). It is corrupted or stale data,
## never exhaustion, never clamped and never read as "at its maximum" — and the
## new-pair draw refuses it too, because drawing a fresh pair over a record that
## disagrees with its own definitions would hand out a pair while the corruption
## stood. This is the one place the new-pair draw reads a rank: to validate the
## record, never to weigh or filter a candidate.
##
## EXHAUSTION IS PROVED, NOT INFERRED. `is_rank_exhausted()` answers, over the same
## validation and the same per-pair standing the rank draw asks, whether at least
## one eligible pair exists and every one of them is held at exactly its maximum —
## nothing new to select and nothing held to raise. It reads no refusal sentence,
## so rewording a refusal can never move it.
##
##
## STILL ABSENT, AND DELIBERATELY: no rarity tier, no luck stat, no dynamic
## build synergy, no pity counter, no reroll, no affix group, no shop, no
## currency, no depth or difficulty scaling, no raising of a rank — the
## rank-increase selection chooses a held pair and raises nothing — no modifier
## application, no UI and no persistence. This file selects a pair and stops.

## Separates the two stages' streams so that a seed which produces a familiar
## Skill cannot, for that reason alone, produce a familiar support. The values
## are the standard 32-bit fractional constants of the golden ratio and of the
## finalizer's own second multiplier; only their distinctness matters.
const SKILL_STREAM_SALT: int = 0x9E37_79B9
const SUPPORT_STREAM_SALT: int = 0x85EB_CA6B

## The ceiling on the summed weight of one Skill's available supports, and it is
## THE SEED STREAM'S OWN WIDTH rather than a round number (D-236). It is checked
## BY SUBTRACTION before each addition, so the sum can never approach — let alone
## wrap — the 64-bit limit. A guard that waits for a wraparound and then inspects
## the damage is not a guard.
##
## WHY THIS EXACT VALUE. `support_ticket_for()` is masked to 32 bits, so a
## seed-derived ticket is at most 4,294,967,295. The first delivery paired that
## stream with a ceiling of 1,000,000,000,000 — 232.8 times wider — and the two
## did not agree about what the mechanism could address. A pool totalling more
## than the stream's width would leave `support_ticket % total` returning the
## ticket unchanged, so EVERY SUPPORT SITTING PAST 4,294,967,295 ON THAT LADDER
## WOULD HAVE BEEN UNREACHABLE FROM A SEED — silently, with no refusal and no
## visible symptom, because the draw would still look perfectly ordinary.
##
## Setting the ceiling to the stream's own width makes the two agree BY
## CONSTRUCTION instead of by a comment asking nobody to exceed it, and the suite
## pins the equality rather than the number. The explicit-ticket core was never
## affected: `select_with_tickets()` accepts any non-negative ticket, and a
## caller supplying its own stream may address whatever it can reach.
##
## NOTHING ELSE MOVED. The mismatch was reported by Foundation C3, which met the
## same question and answered it this way first; this correction aligns the two
## and changes no algorithm, no ordering, no mixer, no weight, no eligibility
## rule and no tag. The shipped pool totals 200, so no shipped selection could
## ever have been affected — which is measured rather than argued, by a seed
## corpus captured before the change and pinned after it.
##
## SINCE D-302 IT IS CHECKED FOR EVERY CANDIDATE SKILL BEFORE STAGE ONE, not only
## for the Skill a seed happens to draw; the value did not move.
const MAXIMUM_TOTAL_WEIGHT: int = 0xFFFF_FFFF

## How one eligible pair stands for a rank increase. The rank-increase draw and the
## exhaustion proof both ask `_rank_standing()` for it, so they cannot disagree about
## which pairs could still be raised.
enum _RankStanding {
	## The support does not accept this Skill.
	REFUSED,
	## The pair is not held, so there is nothing to raise.
	NOT_HELD,
	## Held below its maximum rank: the only standing that is a candidate.
	RAISABLE,
	## Held at exactly its maximum rank.
	AT_MAXIMUM,
	## Held above the maximum its definition declares — an invalid acquisition state
	## `_acquisition_problem()` refuses before any walk, answered here only so no
	## caller can ever read it as a candidate or as exhaustion.
	ABOVE_MAXIMUM,
}


## THE SEEDED ENTRY POINT. `acquired` may be null, which means nothing has been
## acquired yet; that is the honest reading of an absent record and it is the
## only defaulting this file does.
static func select(
	profiles: Array[SkillTagProfile],
	definitions: Array[SupportDefinition],
	acquired: AcquiredSupports,
	seed_value: int
) -> SupportSelectionResult:
	return select_with_tickets(
		profiles, definitions, acquired,
		skill_ticket_for(seed_value), support_ticket_for(seed_value)
	)


## THE PURE CORE, with both tickets supplied. Separated from `select()` so that
## the ticket ladder can be driven at its exact boundaries by a test — a
## property that cannot be proved by feeding seeds in and hoping one lands on a
## boundary — and so that a caller with its own deterministic stream can supply
## tickets from it instead of from a seed.
##
## Tickets are non-negative integers of any size; each is reduced into its own
## range here, so a caller never has to know a range that only this function can
## compute.
static func select_with_tickets(
	profiles: Array[SkillTagProfile],
	definitions: Array[SupportDefinition],
	acquired: AcquiredSupports,
	skill_ticket: int,
	support_ticket: int
) -> SupportSelectionResult:
	var refusal: String = _input_problem(profiles, definitions, skill_ticket, support_ticket)
	if not refusal.is_empty():
		return SupportSelectionResult.failed(refusal)

	var held: AcquiredSupports = acquired if acquired != null else AcquiredSupports.new()
	var ordered_profiles: Array[SkillTagProfile] = _sorted_profiles(profiles)
	var ordered_definitions: Array[SupportDefinition] = _sorted_definitions(definitions)
	refusal = _acquisition_problem(ordered_profiles, ordered_definitions, held)
	if not refusal.is_empty():
		return SupportSelectionResult.failed(refusal)

	# --- The candidate pools: the Skills that can actually receive something --
	var eligible_profiles: Array[SkillTagProfile] = []
	var eligible_pools: Array = []
	var already_held: int = 0
	var refused: int = 0
	for profile: SkillTagProfile in ordered_profiles:
		var pool: Array[SupportDefinition] = []
		for definition: SupportDefinition in ordered_definitions:
			if held.has(profile.skill_id, definition.support_id()):
				already_held += 1
				continue
			if not definition.allows(profile):
				refused += 1
				continue
			pool.append(definition)
		if not pool.is_empty():
			eligible_profiles.append(profile)
			eligible_pools.append(pool)

	# --- Every candidate pool's ladder, validated before either stage (D-302) --
	var ladders: Array = []
	var totals: Array[int] = []
	refusal = _ladder_problem(eligible_profiles, eligible_pools, ladders, totals)
	if not refusal.is_empty():
		return SupportSelectionResult.failed(refusal)

	if eligible_profiles.is_empty():
		## VALID INPUTS, NOTHING TO DRAW — classified, so a caller can tell this apart
		## from every refusal above without reading the sentence (D-301).
		return SupportSelectionResult.no_candidates_found(
			"no equipped Skill has an available eligible support"
			+ " (%d pair(s) already acquired, %d refused by eligibility)" % [already_held, refused]
		)

	return _draw(eligible_profiles, eligible_pools, ladders, totals, skill_ticket, support_ticket)


## THE SEEDED RANK-INCREASE ENTRY POINT (Foundation I5, D-300). The same two
## streams as `select()`, from the same seed, with nothing added to either — so a
## reviewer reproduces a rank decision with this one call. `acquired` may be null,
## which holds nothing and therefore has nothing to raise.
static func select_rank_increase(
	profiles: Array[SkillTagProfile],
	definitions: Array[SupportDefinition],
	acquired: AcquiredSupports,
	seed_value: int
) -> SupportSelectionResult:
	return select_rank_increase_with_tickets(
		profiles, definitions, acquired,
		skill_ticket_for(seed_value), support_ticket_for(seed_value)
	)


## THE PURE RANK-INCREASE CORE, with both tickets supplied, for exactly the reason
## `select_with_tickets()` exists: so its ladder can be walked at its boundaries.
##
## IT DIFFERS FROM THE NEW-PAIR CORE IN ITS POOL AND NOWHERE ELSE. The validation —
## the records, every definition's maximum and the acquisition state — the stable
## ordering, both stages and the ladder are the same code. A candidate is a HELD pair
## whose current rank is below its definition's maximum.
static func select_rank_increase_with_tickets(
	profiles: Array[SkillTagProfile],
	definitions: Array[SupportDefinition],
	acquired: AcquiredSupports,
	skill_ticket: int,
	support_ticket: int
) -> SupportSelectionResult:
	var refusal: String = _input_problem(profiles, definitions, skill_ticket, support_ticket)
	if not refusal.is_empty():
		return SupportSelectionResult.failed(refusal)

	var held: AcquiredSupports = acquired if acquired != null else AcquiredSupports.new()
	var ordered_profiles: Array[SkillTagProfile] = _sorted_profiles(profiles)
	var ordered_definitions: Array[SupportDefinition] = _sorted_definitions(definitions)
	refusal = _acquisition_problem(ordered_profiles, ordered_definitions, held)
	if not refusal.is_empty():
		return SupportSelectionResult.failed(refusal)

	# --- The candidate pools: the Skills holding a pair that can still be raised
	var eligible_profiles: Array[SkillTagProfile] = []
	var eligible_pools: Array = []
	var not_held: int = 0
	var at_maximum: int = 0
	var refused: int = 0
	for profile: SkillTagProfile in ordered_profiles:
		var pool: Array[SupportDefinition] = []
		for definition: SupportDefinition in ordered_definitions:
			match _rank_standing(profile, definition, held):
				_RankStanding.RAISABLE:
					pool.append(definition)
				_RankStanding.NOT_HELD:
					not_held += 1
				_RankStanding.AT_MAXIMUM:
					at_maximum += 1
				_RankStanding.ABOVE_MAXIMUM:
					## DEFENCE IN DEPTH, AND UNREACHABLE WHILE `_acquisition_problem()`
					## runs first over the same Skills and definitions. Written as a
					## refusal rather than folded into AT_MAXIMUM, so a regression in the
					## validation could never turn corruption into a quiet "finished".
					return SupportSelectionResult.failed(_above_maximum_reason(profile, definition, held))
				_RankStanding.REFUSED:
					refused += 1
		if not pool.is_empty():
			eligible_profiles.append(profile)
			eligible_pools.append(pool)

	# --- Every candidate pool's ladder, validated before either stage (D-302) --
	var ladders: Array = []
	var totals: Array[int] = []
	refusal = _ladder_problem(eligible_profiles, eligible_pools, ladders, totals)
	if not refusal.is_empty():
		return SupportSelectionResult.failed(refusal)

	if eligible_profiles.is_empty():
		## VALID INPUTS, NOTHING TO RAISE — classified (D-301).
		return SupportSelectionResult.no_candidates_found(
			"no equipped Skill has an eligible support held below its maximum rank"
			+ " (%d pair(s) not held, %d at their maximum rank, %d refused by eligibility)" % [
				not_held, at_maximum, refused,
			]
		)

	return _draw(eligible_profiles, eligible_pools, ladders, totals, skill_ticket, support_ticket)


## TRUE EXACTLY WHEN THE SUPPORT LANE HAS NOTHING LEFT TO GIVE (Foundation I5,
## D-300): the inputs are valid, at least one eligible pair exists, and EVERY eligible
## pair is held at exactly its maximum rank — nothing new to select and nothing held
## to raise. False for anything else, invalid inputs and an invalid acquisition state
## included, so a caller can never read broken records as an exhausted lane.
##
## It asks the same validation and the same per-pair standing the rank-increase
## draw asks, and it reads no refusal sentence. Order does not matter to it — it is
## a statement about every pair — which is why it walks the arrays as given.
static func is_rank_exhausted(
	profiles: Array[SkillTagProfile],
	definitions: Array[SupportDefinition],
	acquired: AcquiredSupports
) -> bool:
	if not _records_problem(profiles, definitions).is_empty():
		return false
	var held: AcquiredSupports = acquired if acquired != null else AcquiredSupports.new()
	if not _acquisition_problem(profiles, definitions, held).is_empty():
		return false
	var eligible: int = 0
	for profile: SkillTagProfile in profiles:
		for definition: SupportDefinition in definitions:
			var standing: int = _rank_standing(profile, definition, held)
			if standing == _RankStanding.REFUSED:
				continue
			if standing != _RankStanding.AT_MAXIMUM:
				return false
			eligible += 1
	return eligible > 0


# --- Shared by both draws -------------------------------------------------------

## Everything either draw refuses BEFORE the acquisition state is read, in the order
## this selector has always refused it: a negative ticket first, then the records.
static func _input_problem(
	profiles: Array[SkillTagProfile],
	definitions: Array[SupportDefinition],
	skill_ticket: int,
	support_ticket: int
) -> String:
	if skill_ticket < 0 or support_ticket < 0:
		return "a ticket must not be negative (Skill %d, support %d)" % [skill_ticket, support_ticket]
	return _records_problem(profiles, definitions)


## Returns "" when every supplied record may be drawn from, or the first reason
## none of them may. A definition's own `problem()` includes its maximum rank since
## D-301, so a definition without a usable maximum is refused here, by both draws.
##
## Validation runs over the arrays AS GIVEN, before they are sorted. Sorting
## first would be tidier and would hide exactly one case: the same record
## passed in twice would be quietly deduplicated by the sort instead of being
## reported as the duplicate id it is.
static func _records_problem(
	profiles: Array[SkillTagProfile],
	definitions: Array[SupportDefinition]
) -> String:
	if profiles == null or profiles.is_empty():
		return "no equipped Skill profiles were given"
	if definitions == null or definitions.is_empty():
		return "no support definitions were given"

	var seen_skills: Array[StringName] = []
	for profile: SkillTagProfile in profiles:
		if profile == null:
			return "an equipped Skill profile is null"
		var profile_problem: String = profile.problem()
		if not profile_problem.is_empty():
			return "invalid Skill profile: %s" % profile_problem
		if seen_skills.has(profile.skill_id):
			return "duplicate Skill id %s among the equipped Skills" % profile.skill_id
		seen_skills.append(profile.skill_id)

	var seen_supports: Array[StringName] = []
	for definition: SupportDefinition in definitions:
		if definition == null:
			return "a support definition is null"
		var definition_problem: String = definition.problem()
		if not definition_problem.is_empty():
			return "invalid support definition: %s" % definition_problem
		if seen_supports.has(definition.support_id()):
			return "duplicate support id %s in the catalogue" % definition.support_id()
		seen_supports.append(definition.support_id())
	return ""


## "" when the supplied acquisition state agrees with the supplied definitions, or
## the first pair — in the order given — held ABOVE the maximum rank its definition
## declares (D-301). Every held pair of a supplied Skill and a supplied support is
## judged, eligible or not: a maximum is the support's, and a rank above it is
## corrupted or stale whatever the Skill. Both draws pass their SORTED arrays, so the
## pair a refusal names cannot depend on the order the caller built them in.
static func _acquisition_problem(
	profiles: Array[SkillTagProfile],
	definitions: Array[SupportDefinition],
	held: AcquiredSupports
) -> String:
	for profile: SkillTagProfile in profiles:
		for definition: SupportDefinition in definitions:
			if not held.has(profile.skill_id, definition.support_id()):
				continue
			if held.rank_for(profile.skill_id, definition.support_id()) > definition.maximum_rank:
				return _above_maximum_reason(profile, definition, held)
	return ""


static func _above_maximum_reason(
	profile: SkillTagProfile,
	definition: SupportDefinition,
	held: AcquiredSupports
) -> String:
	return "invalid acquisition state: %s -> %s is held at rank %d, above the maximum rank of %d its definition declares" % [
		profile.skill_id, definition.support_id(),
		held.rank_for(profile.skill_id, definition.support_id()),
		definition.maximum_rank,
	]


## Where one Skill/support pair stands for a rank increase. The current rank is
## compared with the definition's maximum and nothing else.
static func _rank_standing(
	profile: SkillTagProfile,
	definition: SupportDefinition,
	held: AcquiredSupports
) -> int:
	if not definition.allows(profile):
		return _RankStanding.REFUSED
	if not held.has(profile.skill_id, definition.support_id()):
		return _RankStanding.NOT_HELD
	var current: int = held.rank_for(profile.skill_id, definition.support_id())
	if current < definition.maximum_rank:
		return _RankStanding.RAISABLE
	if current == definition.maximum_rank:
		return _RankStanding.AT_MAXIMUM
	return _RankStanding.ABOVE_MAXIMUM


## EVERY CANDIDATE SKILL'S INTEGER WEIGHT LADDER, BUILT AND VALIDATED BEFORE EITHER
## STAGE DRAWS (D-302). Appends each candidate Skill's effective weights to `ladders`
## and each ladder's sum to `totals`, in the order given — both draws pass Skills and
## pools in stable id order — and returns "" when every ladder is usable, or the
## reason the FIRST unusable one is not: an effective weight below one, a sum that
## would pass `MAXIMUM_TOTAL_WEIGHT`, or a total below one. The sum is checked BY
## SUBTRACTION before each addition (D-236). It reads no ticket, so no seed can
## decide whether a pool is looked at, and every refusal is an ordinary one: an
## unusable ladder is never an empty candidate set.
static func _ladder_problem(
	candidate_profiles: Array[SkillTagProfile],
	candidate_pools: Array,
	ladders: Array,
	totals: Array[int]
) -> String:
	for index: int in candidate_profiles.size():
		var profile: SkillTagProfile = candidate_profiles[index]
		var pool: Array[SupportDefinition] = candidate_pools[index]
		var weights: Array[int] = []
		var total: int = 0
		for definition: SupportDefinition in pool:
			var weight: int = definition.effective_weight_for(profile)
			if weight < SupportDefinition.MINIMUM_BASE_WEIGHT:
				return "%s resolved to an effective weight of %d for %s" % [
					definition.support_id(), weight, profile.skill_id,
				]
			if total > MAXIMUM_TOTAL_WEIGHT - weight:
				return "the total eligible weight for %s would exceed the ceiling of %d" % [
					profile.skill_id, MAXIMUM_TOTAL_WEIGHT,
				]
			weights.append(weight)
			total += weight
		if total < 1:
			return "the total eligible weight for %s is %d" % [profile.skill_id, total]
		ladders.append(weights)
		totals.append(total)
	return ""


## BOTH STAGES OF THE DRAW, over the pools and the ladders `_ladder_problem()` has
## already built and validated for EVERY candidate Skill (D-302). The first stage is
## uniform over `candidate_profiles`, which holds only Skills with a non-empty pool;
## the second walks the chosen Skill's own ladder exactly as it was validated. It
## computes no weight and checks no ceiling, so it cannot build a different ladder
## after a Skill has been chosen.
static func _draw(
	candidate_profiles: Array[SkillTagProfile],
	candidate_pools: Array,
	ladders: Array,
	totals: Array[int],
	skill_ticket: int,
	support_ticket: int
) -> SupportSelectionResult:
	var chosen_skill_index: int = skill_ticket % candidate_profiles.size()
	var chosen_profile: SkillTagProfile = candidate_profiles[chosen_skill_index]
	var pool: Array[SupportDefinition] = candidate_pools[chosen_skill_index]

	# --- Stage 2: the weighted draw over that Skill's already validated ladder --
	var weights: Array[int] = ladders[chosen_skill_index]
	var total: int = totals[chosen_skill_index]

	var ticket: int = support_ticket % total
	var running: int = 0
	for index: int in pool.size():
		running += weights[index]
		if ticket < running:
			var definition: SupportDefinition = pool[index]
			return SupportSelectionResult.chosen(
				chosen_profile.skill_id,
				definition.support_id(),
				definition.base_weight,
				definition.matching_bonuses_for(chosen_profile),
				weights[index],
				ticket,
				total,
				candidate_profiles.size(),
				chosen_skill_index
			)

	## UNREACHABLE while `ticket < total` and the weights sum to `total`, which
	## the loop above guarantees. It is written anyway rather than left to fall
	## off the end returning null, because a selector that can return nothing is
	## a selector every caller has to null-check forever.
	return SupportSelectionResult.failed(
		"the ticket %d fell past every candidate of a total weight of %d" % [ticket, total]
	)


# --- The deterministic streams ------------------------------------------------

## The first-stage ticket for a seed. Masked to 32 bits, so it is always
## non-negative and the two stages can never share a value by construction.
static func skill_ticket_for(seed_value: int) -> int:
	return _mix((seed_value & 0xFFFFFFFF) ^ SKILL_STREAM_SALT)


## The second-stage ticket for a seed. Advanced one further avalanche step than
## the first, so that two salts alone are not the only thing separating them.
static func support_ticket_for(seed_value: int) -> int:
	return _mix(_mix((seed_value & 0xFFFFFFFF) ^ SUPPORT_STREAM_SALT))


## The standard 32-bit avalanche finalizer. See the header for why this file
## carries its own copy.
static func _mix(value: int) -> int:
	var x: int = value & 0xFFFFFFFF
	x = (x ^ (x >> 16)) * 0x7FEB_352D & 0xFFFFFFFF
	x = (x ^ (x >> 15)) * 0x846C_A68B & 0xFFFFFFFF
	x = x ^ (x >> 16)
	return x & 0xFFFFFFFF


# --- Stable ordering ----------------------------------------------------------
#
# Sorted through `PackedStringArray` for the same reason every other stable
# order in this project is: StringName ordering is an implementation detail, and
# a seeded result must not rest on one.

## Both callers below run AFTER validation, so every entry is non-null and every
## id is unique — which is what lets these be an exact reordering rather than a
## best effort that could drop or duplicate an entry.

static func _sorted_profiles(profiles: Array[SkillTagProfile]) -> Array[SkillTagProfile]:
	var by_id: Dictionary = {}
	var ids: Array[StringName] = []
	for profile: SkillTagProfile in profiles:
		by_id[profile.skill_id] = profile
		ids.append(profile.skill_id)
	var out: Array[SkillTagProfile] = []
	for id: StringName in _sorted_ids(ids):
		out.append(by_id[id])
	return out


static func _sorted_definitions(definitions: Array[SupportDefinition]) -> Array[SupportDefinition]:
	var by_id: Dictionary = {}
	var ids: Array[StringName] = []
	for definition: SupportDefinition in definitions:
		by_id[definition.support_id()] = definition
		ids.append(definition.support_id())
	var out: Array[SupportDefinition] = []
	for id: StringName in _sorted_ids(ids):
		out.append(by_id[id])
	return out


static func _sorted_ids(ids: Array[StringName]) -> Array[StringName]:
	var text: PackedStringArray = PackedStringArray()
	for id: StringName in ids:
		text.append(String(id))
	text.sort()
	var out: Array[StringName] = []
	for value: String in text:
		out.append(StringName(value))
	return out
