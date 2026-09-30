class_name SupportExhaustionPassiveFallback
extends RefCounted
## Riftwrought — Roguelite Foundation I6: deterministic selection of the passive
## card the support lane falls back to once support progression is honestly
## exhausted (decision D-304).
##
## THE ONE QUESTION THIS FILE ANSWERS: once the accepted support continuation has
## reported, in its own machine-readable classification, that every compatible
## support pair is held at its highest rank — which single passive card would a
## three-card offer carry in that lane instead, given the two passive cards the
## same offer already carries? It answers exactly that and stops. It composes no
## offer, adds no lane, labels nothing, applies nothing and records nothing, and
## NOTHING THAT RUNS CALLS IT: wiring it into the offer, the choice transaction,
## the level-up panel or the runtime is a later authorization, and the suite
## proves the absence rather than promising it.
##
##
## THE POLICY, AS THE PROJECT OWNER GAVE IT
## ---------------------------------------------------------------------------
##   - It activates only after a coherent support continuation reports exhaustion.
##   - It draws from the supplied passive card records — the existing catalogue,
##     handed in rather than named here.
##   - It excludes the Combat and Defence card and the Utility card the same offer
##     already carries. Cards acquired earlier in the run stay eligible: every
##     shipped card is repeatable, and "already held" is not "already offered".
##   - When both stat categories keep at least one card, the CATEGORY is chosen
##     uniformly — one ticket each — so a category's depth buys it nothing.
##   - Within the chosen category the card is chosen by the accepted passive
##     selector's own integer weights.
##   - No card appears twice in one offer.
##
##
## THE ORDER, AND THE ORDER IS PART OF THE CONTRACT
## ---------------------------------------------------------------------------
##   1. Refuse a negative category ticket or card ticket.
##   2. ACTIVATION. The support continuation must be supplied, coherent by its own
##      `problem()`, not a decision, and classified exhausted by its own
##      predicate. Anything else refuses: a new pair, a rank increase, an ordinary
##      refusal, an invalid or above-maximum support state.
##   3. The two passive-lane derivations: each supplied, coherent, successful and
##      drawn from its own canonical category, and the two cards they name must
##      differ. A swapped pair is refused, never repaired. Their card ids are READ
##      from those derivations; a caller never restates them.
##   4. THE WHOLE SUPPLIED RECORD SET, validated by the accepted selector's own
##      record check before anything is excluded or counted — so a malformed
##      record refuses the fallback even when it is one of the two excluded cards
##      or sits in the category no ticket would ever reach.
##   5. Both offered cards must be among those records, filed under the category
##      their lane drew them from.
##   6. For each canonical category, in canonical order, count the records not
##      excluded. A category with at least one is AVAILABLE.
##   7. EVERY AVAILABLE CATEGORY'S DRAW IS RESOLVED BEFORE ANY CATEGORY IS CHOSEN,
##      through the accepted selector with both offered cards excluded, and if
##      either draw cannot be made the whole fallback refuses. This is D-302's
##      rule for the support selector applied here: a ticket chooses among valid
##      pools, and must never decide whether the problem it was handed is valid.
##   8. No available category is VALID CATALOGUE EXHAUSTION: an explicit
##      unavailable result — never a malformed refusal, never an excluded card,
##      never an invented one.
##   9. Stage one: the category ticket, reduced over the available categories in
##      canonical order, chooses one.
##  10. Stage two: that category's already-resolved draw is the answer.
##
## NOTHING IS READ OUT OF A SENTENCE. Activation reads the continuation's stored
## classification; availability is counted from records; every refusal quoted
## here is quoted, never inspected, matched or split.
##
##
## IT DELEGATES; IT DOES NOT COPY
## ---------------------------------------------------------------------------
## Record validation, card sorting, weights, the weight ceiling, ticket reduction
## and the ladder walk all belong to the accepted passive selector and are asked
## of it through its public entry points. This file counts cards per category and
## reduces one ticket over at most two categories, and does nothing else with a
## number.
##
##
## DETERMINISM
## ---------------------------------------------------------------------------
## `select_with_tickets()` is the whole mechanism and is pure: the same inputs and
## the same two tickets give the same answer forever. `select()` derives both
## tickets from one fallback seed and delegates, so there is exactly one place a
## card is chosen. The derivation reuses the accepted passive selector's PUBLIC
## seeded stream rather than a fifth private copy of the project's mixer: each
## stage ticket is that stream, keyed by the fallback seed combined with the
## stage's own fixed domain. The caller will eventually hand in the accepted
## support lane's seed; which seed that is, and the wiring that passes it, are
## not this file's.
##
## It reads no global random source, no clock, no node, no file, no scene, no
## input and no saved state; it mutates none of its arguments; and it carries
## zero instance fields, so it cannot remember a previous fallback.
##
## IT NAMES NOTHING CONCRETE: no Skill, no support, no card and no catalogue, in
## code or in a comment. Everything it works on arrives as an argument.
##
##
## STILL ABSENT, AND DELIBERATELY: no offer field, no fallback lane, no display
## label, no choice, no application, no rarity, no luck, no pity, no reroll, no
## further rank, no repeated level-up, no persistence and no balance claim.

## THE TWO STAGE DOMAINS. Fixed, and part of what a fallback seed MEANS once
## shipped: changing either changes every fallback every seed has ever produced.
## They are the 32-bit fractional parts of the square roots of 7 and 11 — the
## fourth and fifth words of the same published set the three accepted offer lane
## domains are the first three of — so neither is a number tuned for an outcome.
const CATEGORY_STAGE_DOMAIN: int = 0xA54F_F53A
const CARD_STAGE_DOMAIN: int = 0x510E_527F

## The canonical category whose accepted seeded stream both stage tickets are
## read from. That stream asks for a category and neither stage belongs to one,
## so both read the first canonical category's stream and are kept apart by their
## own domains above. It is a fixed constant and carries no other meaning.
const STAGE_STREAM_CATEGORY: int = PlayerStatDefinition.Category.COMBAT_DEFENCE

## The two canonical passive categories. Exactly two: the owner's policy is a
## uniform choice between these, not between whatever the vocabulary may one day
## declare.
const CANONICAL_CATEGORIES: Array[int] = [
	PlayerStatDefinition.Category.COMBAT_DEFENCE,
	PlayerStatDefinition.Category.UTILITY,
]


## THE SEEDED ENTRY POINT. A convenience over the core below and nothing more: it
## derives the two tickets and delegates.
static func select(
	continuation: SupportContinuationResult,
	combat_selection: PassiveCardSelectionResult,
	utility_selection: PassiveCardSelectionResult,
	records: Array[PassiveCardDefinition],
	fallback_seed: int
) -> SupportExhaustionPassiveFallbackResult:
	return select_with_tickets(
		continuation, combat_selection, utility_selection, records,
		category_ticket_for(fallback_seed), card_ticket_for(fallback_seed)
	)


## THE PURE CORE, with both tickets supplied. A ticket is a non-negative integer
## of any size; each is reduced by the stage that uses it, so a caller never has
## to know a range only that stage can compute.
static func select_with_tickets(
	continuation: SupportContinuationResult,
	combat_selection: PassiveCardSelectionResult,
	utility_selection: PassiveCardSelectionResult,
	records: Array[PassiveCardDefinition],
	category_ticket: int,
	card_ticket: int
) -> SupportExhaustionPassiveFallbackResult:
	# --- 1. Tickets --------------------------------------------------------------
	if category_ticket < 0:
		return SupportExhaustionPassiveFallbackResult.failed(
			"a category ticket must not be negative (%d)" % category_ticket
		)
	if card_ticket < 0:
		return SupportExhaustionPassiveFallbackResult.failed(
			"a card ticket must not be negative (%d)" % card_ticket
		)

	# --- 2. Activation -----------------------------------------------------------
	var activation: String = _activation_problem(continuation)
	if not activation.is_empty():
		return SupportExhaustionPassiveFallbackResult.failed(activation)

	# --- 3. The two passive-lane derivations ------------------------------------
	var combat_problem: String = _lane_problem(
		combat_selection, PlayerStatDefinition.Category.COMBAT_DEFENCE
	)
	if not combat_problem.is_empty():
		return SupportExhaustionPassiveFallbackResult.failed(combat_problem)
	var utility_problem: String = _lane_problem(
		utility_selection, PlayerStatDefinition.Category.UTILITY
	)
	if not utility_problem.is_empty():
		return SupportExhaustionPassiveFallbackResult.failed(utility_problem)
	if combat_selection.selected_card_id == utility_selection.selected_card_id:
		return SupportExhaustionPassiveFallbackResult.failed(
			"both passive lanes already offer %s, so the offer would hold one card twice"
				% combat_selection.selected_card_id
		)
	var excluded: Array[StringName] = [
		combat_selection.selected_card_id, utility_selection.selected_card_id,
	]

	# --- 4. The whole supplied record set ---------------------------------------
	var records_fault: String = PassiveCardSelection.records_problem(records)
	if not records_fault.is_empty():
		return SupportExhaustionPassiveFallbackResult.failed(
			"the supplied passive card records cannot be drawn from: %s" % records_fault
		)

	# --- 5. The offered cards are among them, where their lanes put them ---------
	for offered: PassiveCardSelectionResult in [combat_selection, utility_selection]:
		var found: PassiveCardDefinition = null
		for record: PassiveCardDefinition in records:
			if record.card_id == offered.selected_card_id:
				found = record
				break
		var lane_label: String = PassiveCardSelectionResult.category_label(
			offered.requested_category
		)
		if found == null:
			return SupportExhaustionPassiveFallbackResult.failed(
				"%s, offered by the %s lane, is not among the supplied passive card records"
					% [offered.selected_card_id, lane_label]
			)
		if found.category() != offered.requested_category:
			return SupportExhaustionPassiveFallbackResult.failed(
				"%s, offered by the %s lane, is filed under %s by the supplied records" % [
					offered.selected_card_id, lane_label,
					PassiveCardSelectionResult.category_label(found.category()),
				]
			)

	# --- 6 and 7. Every available category, resolved before any is chosen --------
	var categories: Array[int] = CANONICAL_CATEGORIES.duplicate()
	categories.sort()
	var available: Array[int] = []
	var draws: Array[PassiveCardSelectionResult] = []
	for category: int in categories:
		var remaining: int = 0
		for record: PassiveCardDefinition in records:
			if record.category() == category and not excluded.has(record.card_id):
				remaining += 1
		if remaining == 0:
			continue
		var draw: PassiveCardSelectionResult = PassiveCardSelection.select_with_ticket_excluding(
			records, category, card_ticket, excluded
		)
		if not draw.ok:
			return SupportExhaustionPassiveFallbackResult.failed(
				"the %s draw cannot be made, so no category may be chosen: %s" % [
					PassiveCardSelectionResult.category_label(category), draw.failure_reason,
				]
			)
		var draw_problem: String = draw.problem()
		if not draw_problem.is_empty():
			## DEFENCE IN DEPTH, AND DELIBERATELY UNREACHABLE: the accepted selector
			## re-derives every success it returns, so no supplied input can drive
			## this branch and the suite pins it structurally rather than pretending
			## to. It stays because a fallback that trusted a `true` without asking
			## what it is a `true` about is how an incoherent card reaches a player.
			return SupportExhaustionPassiveFallbackResult.failed(
				"the %s draw is incoherent: %s" % [
					PassiveCardSelectionResult.category_label(category), draw_problem,
				]
			)
		available.append(category)
		draws.append(draw)

	# --- 8. Valid catalogue exhaustion ------------------------------------------
	if available.is_empty():
		return SupportExhaustionPassiveFallbackResult.fallback_unavailable(
			"no passive card remains in either category once the two cards this offer already carries are excluded"
		)

	# --- 9 and 10. Stage one chooses a category; its resolved draw is the card ---
	var normalized: int = category_ticket % available.size()
	return SupportExhaustionPassiveFallbackResult.chosen(
		available[normalized], available, excluded,
		category_ticket, card_ticket, normalized, draws[normalized]
	)


# --- The deterministic stream --------------------------------------------------

## The category-stage ticket for a fallback seed: the accepted passive selector's
## public seeded stream, keyed by the seed combined with the category stage's own
## domain. Masked to 32 bits by that stream, so it is never negative.
static func category_ticket_for(fallback_seed: int) -> int:
	return PassiveCardSelection.ticket_for(
		fallback_seed ^ CATEGORY_STAGE_DOMAIN, STAGE_STREAM_CATEGORY
	)


## The card-stage ticket for a fallback seed, from the same stream keyed by the
## card stage's own domain.
static func card_ticket_for(fallback_seed: int) -> int:
	return PassiveCardSelection.ticket_for(
		fallback_seed ^ CARD_STAGE_DOMAIN, STAGE_STREAM_CATEGORY
	)


# --- Validation ----------------------------------------------------------------

## "" when the continuation may activate the fallback, or the reason it may not.
## Every branch reads a stored fact or the record's own coherence test; the
## continuation's refusal text is quoted, never read.
static func _activation_problem(continuation: SupportContinuationResult) -> String:
	if continuation == null:
		return "no support continuation was supplied, so there is no exhaustion to fall back from"
	var continuation_problem: String = continuation.problem()
	if not continuation_problem.is_empty():
		return "the support continuation is incoherent, so it cannot activate the fallback: %s" \
			% continuation_problem
	if continuation.ok:
		return "the support lane is not exhausted: it decided %s (%s), so there is nothing to fall back from" % [
			SupportContinuationResult.kind_label(continuation.kind), continuation.pair(),
		]
	if not continuation.is_exhausted():
		return "the support lane refused without being exhausted, so the fallback does not activate: %s" \
			% continuation.failure_reason
	return ""


## "" when `selection` is a usable derivation for the lane that draws from
## `expected_category`, or the reason it is not.
static func _lane_problem(
	selection: PassiveCardSelectionResult,
	expected_category: int
) -> String:
	var label: String = PassiveCardSelectionResult.category_label(expected_category)
	if selection == null:
		return "no %s selection was supplied, so the card it offers cannot be excluded" % label
	var selection_problem: String = selection.problem()
	if not selection_problem.is_empty():
		return "the %s selection is incoherent: %s" % [label, selection_problem]
	if not selection.ok:
		return "the %s selection refused, so it offers no card to exclude: %s" % [
			label, selection.failure_reason,
		]
	if selection.requested_category != expected_category:
		return "the %s selection was drawn from the %s category; a swapped pair is refused rather than repaired" % [
			label, PassiveCardSelectionResult.category_label(selection.requested_category),
		]
	return ""
