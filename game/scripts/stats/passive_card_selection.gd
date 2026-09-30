class_name PassiveCardSelection
extends RefCounted
## Riftwrought — Roguelite Foundation C3: deterministic weighted selection of
## exactly ONE passive card from ONE requested category (decision D-234).
##
## THE ONE QUESTION THIS FILE ANSWERS: given a complete set of card records, one
## category, and one ticket, which single card does that ticket own? It answers
## exactly that and stops. It composes nothing, offers nothing, remembers
## nothing and applies nothing.
##
## IT IS DELIBERATELY NOT AN OFFER. A later decision may build a three-card
## level-up offer out of several calls to this function — one per lane — but the
## composition, the lane vocabulary, the de-duplication between lanes, the
## presentation and the acquisition are all that decision's, not this one's.
## Building any of it here would be building the offer under the name of a
## selector, and the suite proves the absence rather than promising it.
##
## IT NAMES NOTHING CONCRETE, AND THE SUITE SCANS THE RAW SOURCE TO PROVE IT. No
## card, no catalogue, no stat, no lane, no review instrument and no upgrade kind
## is named here in code or in a comment. Everything it works on arrives as
## arguments — a selector that knows one card's name is a selector that can be
## tuned for it, and the tuning would then live in the mechanism rather than in
## the record.
##
## IT NEVER READS A PRESENTATION NAME. Not to compare, not to sort, not to
## report. The whole point of the record layer separating a stable id from
## display copy is that renaming a card must never be a balance change, and the
## only way that guarantee survives is for the mechanism to be unable to see the
## copy at all. The suite scans this file for the field itself and drives the
## property by renaming every card and re-running the draw.
##
##
## THE ALGORITHM, IN ORDER, AND THE ORDER IS PART OF THE CONTRACT
## ---------------------------------------------------------------------------
##   1. Refuse a negative ticket.
##   2. Refuse an absent or empty record set.
##   3. VALIDATE EVERY SUPPLIED RECORD, AS GIVEN, BEFORE ANYTHING IS FILTERED —
##      ONE PASS in supplied order, testing each record's own contract and then
##      its id's uniqueness before moving to the next record.
##
##      SO THE REASON A REFUSAL GIVES IS THE FIRST FAULT IN SUPPLIED ORDER, which
##      is stated here rather than left to be discovered: a duplicate id at
##      position 1 is reported ahead of a malformed record at position 2, because
##      position 1 is reached first. It is deliberately NOT two passes. THE
##      RESULT DOES NOT DEPEND ON INPUT ORDER AND THE REASON MAY — a refusal is
##      a diagnosis of a set that is broken however it is ordered, while a
##      SELECTION is proved order-independent over 1,800 draws.
##   4. Refuse an unrecognised category.
##   4a. Refuse an exclusion that names no supplied record, or names one twice
##      (Roguelite Foundation I6, D-304 — see EXCLUSION below).
##   5. Sort the whole set by stable id, then keep the records whose DERIVED
##      category matches the requested one and whose id is not excluded.
##   6. Refuse an empty match — in its own words when exclusion emptied it.
##   7. Sum the weights into a ladder, refusing an impossible one.
##   8. Reduce the ticket into `[0, total)` and walk the ladder once.
##
## STEP 3 COMES BEFORE STEP 4 AND BEFORE THE FILTER, WHICH IS THE WHOLE POINT.
## An invalid record in the category nobody asked for still refuses the entire
## selection. Validating after the filter would be tidier and would mean a
## mistyped weight in one lane went unreported for as long as nobody drew from
## that lane — and it would be reported, when it finally was, as a fault in a
## draw that had nothing to do with it. A record set is coherent or it is not.
##
## THE SORT IS BY STABLE ID AND HAPPENS BEFORE THE FILTER, so the candidate
## ladder is always a sub-sequence of one globally ordered set. The order the
## caller happened to build its array in — and the order a catalogue happened to
## declare its records in — cannot move a result. Inserting a record at the top
## of a catalogue file is an editing convenience and must not be a balance
## change.
##
## THE CATEGORY IS DERIVED FROM EACH CARD'S CANONICAL STAT DEFINITION and is
## never restated, read from a second list, or inferred from a name. A card
## belongs to the lane its stat belongs to, and there is exactly one place that
## is written down.
##
##
## DETERMINISM, AND WHAT IS AND IS NOT PROMISED
## ---------------------------------------------------------------------------
## `select_with_ticket()` IS THE WHOLE MECHANISM and it is pure: same records,
## same category, same ticket, same answer, forever. It is separated from the
## seeded entry point so the ticket ladder can be driven at its exact boundaries
## by a test — a property that cannot be proved by feeding seeds in and hoping
## one lands on a boundary — and so a caller with its own deterministic stream
## can supply tickets from it instead of from a seed.
##
## A ticket is a non-negative integer of ANY size; it is reduced into the ladder
## here, so a caller never has to know a range only this function can compute. A
## NEGATIVE ticket is REFUSED rather than folded, which is the convention the
## project's earlier selector already set: the two sensible foldings of a
## negative disagree with each other, so accepting one would be choosing an
## arithmetic convention silently.
##
## `select()` derives that ticket from a seed. Nothing here reads a global random
## source, a clock, the filesystem, the project's own settings or its input
## bindings, and the suite scans this file for the name of every one of those.
##
## THAT SCAN IS RAW AND INCLUDES COMMENTS, WHICH IS WHY THIS PARAGRAPH DOES NOT
## SPELL ANY OF THEM OUT — naming one here would breach the rule just as surely
## as reading one would, and the guard duly refused an earlier draft of this very
## sentence. It reads no node either, which is covered by a different proof
## rather than by that scan: this is a `RefCounted`, its declared methods are
## enumerated from the engine and pinned by name, and it carries ZERO instance
## fields — so there is nowhere for a node, a cache or a memory of the last draw
## to live.
##
## THE SEEDED STREAM IS SALTED BY CATEGORY, AND THAT IS A DELIVERY JUDGEMENT
## RATHER THAN A REQUIREMENT. Without it, one seed asked about two categories
## returns the same ORDINAL position in each — the second card of one lane and
## the second card of the other, every time, for every seed — because the two
## ladders are the same length. That is a correlation a later composition would
## inherit without ever being told about it. Salting the stream by the requested
## category removes it. It lives ENTIRELY in `ticket_for()`: the pure core is
## category-agnostic in its ticket handling, so ticket N means exactly the same
## thing in either lane and this judgement can be reversed by editing one
## function.
##
## THE MIXER IS THIS FILE'S OWN, AND THE DUPLICATION IS DELIBERATE AND STATED.
## The same well-known 32-bit avalanche finalizer already exists twice in this
## project — inside a temporary review instrument, and inside an earlier
## Skill-facing foundation. Reusing either would make this file name a class the
## purity scan forbids, and extracting a shared mixer would mean editing an
## accepted file this work is not authorized to touch. So the same arithmetic
## exists a third time, on purpose, and this sentence is the record of why. It is
## recorded debt rather than a discovery waiting to be made.
##
##
## FAIL CLOSED, ALWAYS, AND NEVER PARTIALLY
## ---------------------------------------------------------------------------
## An invalid record REFUSES THE WHOLE SELECTION rather than being quietly
## skipped. Skipping is the tempting behaviour and it is the wrong one: a
## mistyped weight would then silently remove a card from the game while every
## draw still looked perfectly normal, and nothing would ever report it.
## Refusing is loud, and loud is recoverable.
##
## Every refusal returns a result that names its reason and carries no partial
## selection.
##
##
## EXCLUSION, AND WHO DECIDES IT (Roguelite Foundation I6, decision D-304)
## ---------------------------------------------------------------------------
## A caller may name stable card ids that must own NO ticket in a draw — which a
## later decision needs when an offer already shows some cards and a further lane
## must not show one of them twice. WHICH ids are excluded, and why, remains
## entirely the caller's decision; this file only honours it, and honours it in
## exactly one place, so there is still one ladder walk for a passive card.
##
## THE WHOLE SUPPLIED SET IS STILL VALIDATED FIRST, EXCLUDED RECORDS INCLUDED.
## An exclusion is applied to a coherent set and is never a way to hide an
## incoherent one: a malformed record the caller happens to exclude refuses the
## draw exactly as it always has. An exclusion naming no supplied record — or
## naming one twice — is refused rather than ignored, because a misspelt
## exclusion would otherwise leave the very card it meant to remove on the ladder.
##
## AN EXCLUDED CARD IS NOT ON THE LADDER AT ALL. It owns no ticket and adds
## nothing to the total, so the weight ceiling is checked over the cards that can
## actually be drawn. With nothing excluded the draw is exactly the one this file
## has always made: `select_with_ticket()` IS that call with an empty list, and
## its answers, its refusals and the order they are reported in are unchanged.
##
## THE RECORD CHECK IS PUBLIC SO THAT A CALLER NEED NOT COPY IT.
## `records_problem()` is step 3 above, moved rather than rewritten, so a caller
## that must know a set is coherent before it decides anything asks this file
## instead of keeping a second copy of the rule.
##
##
## STILL ABSENT, AND DELIBERATELY: no offer, no lane composition, no acquisition,
## no already-held rule, no stacking, no cap, no diminishing return, no rarity
## tier, no luck stat, no weight bonus, no pity counter, no reroll, no shop, no
## currency, no depth or difficulty scaling, no application, no UI and no
## persistence. This file draws one card and stops.

## Separates one category's seeded stream from another's, so a seed that
## produces a familiar card in one lane cannot, for that reason alone, produce
## the same ordinal in another. The value is the standard 32-bit fractional
## constant of the golden ratio; only its being a large odd constant matters.
const CATEGORY_STREAM_SALT: int = 0x9E37_79B9

## The ceiling on the summed weight of one category's candidates, and it is the
## STREAM'S OWN WIDTH rather than a round number. It is checked BY SUBTRACTION
## before each addition, so the sum can never approach — let alone wrap — the
## 64-bit limit. A guard that waits for a wraparound and then inspects the damage
## is not a guard.
##
## WHY THIS EXACT VALUE, AND WHY IT DELIBERATELY DIVERGES FROM THE ROUND ONE THE
## PROJECT'S EARLIER SELECTOR USES. `ticket_for()` is masked to 32 bits, so a
## seeded ticket is at most 4,294,967,295. If a ladder were allowed to total more
## than that, `ticket % total` would return the ticket unchanged and every
## candidate sitting above 4,294,967,295 on that ladder would be UNREACHABLE FROM
## A SEED — silently, with no refusal and no visible symptom, because the draw
## would still look perfectly ordinary. Setting the ceiling to the stream's own
## width makes the two agree BY CONSTRUCTION instead of by a comment asking
## nobody to exceed it. The explicit-ticket core was never affected, since a
## caller may hand it any non-negative ticket.
##
## THE PROJECT'S EARLIER SELECTOR CARRIED THE SAME MISMATCH — a 32-bit stream
## paired with a ceiling 232.8 times wider — and it was reported from here rather
## than edited from here, because that file was accepted and closed. The project
## owner then authorized the narrow correction, and it now uses this same
## contract, so THE TWO SELECTORS AGREE and neither has an unreachable ladder.
## Nothing else in that file moved.
const MAXIMUM_TOTAL_WEIGHT: int = 0xFFFF_FFFF


## THE SEEDED ENTRY POINT. A convenience over the core below and nothing more:
## it derives one ticket and delegates, so there is exactly one place a card is
## chosen.
static func select(
	records: Array[PassiveCardDefinition],
	requested_category: int,
	seed_value: int
) -> PassiveCardSelectionResult:
	return select_with_ticket(
		records, requested_category, ticket_for(seed_value, requested_category)
	)


## THE PURE CORE, with the ticket supplied.
##
## `requested_category` is declared `int` rather than as the enum on purpose. An
## enum-typed parameter is an int at run time and a value outside the declared
## set is reachable, so the unrecognised-category refusal is a real branch that a
## caller can actually drive — and a signature promising the enum would be
## promising something it cannot enforce.
static func select_with_ticket(
	records: Array[PassiveCardDefinition],
	requested_category: int,
	ticket: int
) -> PassiveCardSelectionResult:
	## SINCE ROGUELITE FOUNDATION I6 (D-304) THIS IS THE EXCLUSION-AWARE DRAW
	## BELOW WITH NOTHING EXCLUDED, so there is still exactly one ladder walk.
	## Every answer, every refusal and the order refusals are reported in are
	## unchanged, which the I6 suite measures over every ticket of both shipped
	## ladders and every refusal C3's own suite drives.
	var nothing_excluded: Array[StringName] = []
	return select_with_ticket_excluding(
		records, requested_category, ticket, nothing_excluded
	)


## THE PURE CORE, WITH STABLE CARD IDS THAT MUST OWN NO TICKET (Roguelite
## Foundation I6, decision D-304). See EXCLUSION in the header.
##
## The exclusions are checked only AFTER the whole supplied set has been
## validated and the category recognised, so every refusal this file could
## already give is still given first and in the same words. An excluded id may
## belong to either category: it is simply not a candidate anywhere.
static func select_with_ticket_excluding(
	records: Array[PassiveCardDefinition],
	requested_category: int,
	ticket: int,
	excluded_card_ids: Array[StringName]
) -> PassiveCardSelectionResult:
	if ticket < 0:
		return PassiveCardSelectionResult.failed(
			"a ticket must not be negative (%d)" % ticket, requested_category
		)

	# --- Validate every record BEFORE anything is filtered or excluded --------
	var records_fault: String = records_problem(records)
	if not records_fault.is_empty():
		return PassiveCardSelectionResult.failed(records_fault, requested_category)

	if not PlayerStatDefinition.Category.values().has(requested_category):
		return PassiveCardSelectionResult.failed(
			"%d is not a recognised passive card category" % requested_category,
			requested_category
		)

	# --- The exclusions, checked against the WHOLE supplied set ---------------
	var supplied_ids: Array[StringName] = []
	for record: PassiveCardDefinition in records:
		supplied_ids.append(record.card_id)
	var excluded: Array[StringName] = []
	for card_id: StringName in excluded_card_ids:
		if not supplied_ids.has(card_id):
			return PassiveCardSelectionResult.failed(
				"the excluded card id '%s' is not among the supplied records" % card_id,
				requested_category
			)
		if excluded.has(card_id):
			return PassiveCardSelectionResult.failed(
				"the card id %s is excluded more than once" % card_id, requested_category
			)
		excluded.append(card_id)

	# --- Sort by stable id, then keep the requested category ------------------
	#
	# An excluded record is dropped HERE — after validation and after the sort —
	# so it owns no ticket and adds nothing to the total below.
	var candidates: Array[PassiveCardDefinition] = []
	var matched: int = 0
	for record: PassiveCardDefinition in _sorted_records(records):
		if record.category() != requested_category:
			continue
		matched += 1
		if excluded.has(record.card_id):
			continue
		candidates.append(record)

	if candidates.is_empty():
		if matched > 0:
			return PassiveCardSelectionResult.failed(
				"every supplied passive card in the %s category is excluded"
					% PassiveCardSelectionResult.category_label(requested_category),
				requested_category
			)
		return PassiveCardSelectionResult.failed(
			"no supplied passive card belongs to the %s category"
				% PassiveCardSelectionResult.category_label(requested_category),
			requested_category
		)

	# --- The ladder ----------------------------------------------------------
	var candidate_ids: Array[StringName] = []
	var weights: Array[int] = []
	var total: int = 0
	for record: PassiveCardDefinition in candidates:
		var weight: int = record.base_weight
		if weight < PassiveCardDefinition.MINIMUM_BASE_WEIGHT:
			return PassiveCardSelectionResult.failed(
				"%s carries a base weight of %d, below the minimum of %d" % [
					record.card_id, weight, PassiveCardDefinition.MINIMUM_BASE_WEIGHT,
				],
				requested_category
			)
		if total > MAXIMUM_TOTAL_WEIGHT - weight:
			return PassiveCardSelectionResult.failed(
				"the total weight in the %s category would exceed the ceiling of %d" % [
					PassiveCardSelectionResult.category_label(requested_category),
					MAXIMUM_TOTAL_WEIGHT,
				],
				requested_category
			)
		candidate_ids.append(record.card_id)
		weights.append(weight)
		total += weight

	if total < 1:
		## DEFENCE IN DEPTH, AND DELIBERATELY UNREACHABLE FROM HERE: every
		## candidate has already been proved to carry at least the minimum
		## weight and the list is non-empty, so the sum is at least one. It stays
		## because a denominator with no guard is how a later change starts
		## dividing by zero.
		return PassiveCardSelectionResult.failed(
			"the total weight in the %s category is %d" % [
				PassiveCardSelectionResult.category_label(requested_category), total,
			],
			requested_category
		)

	# --- One draw ------------------------------------------------------------
	var normalized: int = ticket % total
	var running: int = 0
	for index: int in candidate_ids.size():
		running += weights[index]
		if normalized < running:
			return PassiveCardSelectionResult.chosen(
				requested_category, candidate_ids, weights, total,
				normalized, candidate_ids[index]
			)

	## UNREACHABLE while `normalized < total` and the weights sum to `total`,
	## which the loop above guarantees. It is written anyway rather than left to
	## fall off the end returning null, because a selector that can return
	## nothing is a selector every caller has to null-check forever.
	return PassiveCardSelectionResult.failed(
		"the ticket %d fell past every candidate of a total weight of %d" % [normalized, total],
		requested_category
	)


# --- The record check -----------------------------------------------------------

## STEP 3 OF THE ALGORITHM, MOVED HERE UNCHANGED so that a caller which must know
## a set is coherent before it decides anything need not keep a second copy of
## the rule (Roguelite Foundation I6, D-304). Returns "" when the supplied set is
## coherent, or the FIRST fault in supplied order, in exactly the words a draw
## over the same set refuses with — because the draw returns this very string.
static func records_problem(records: Array[PassiveCardDefinition]) -> String:
	## THE NULL HALF OF THIS TEST IS DEFENCE IN DEPTH AND IS DELIBERATELY NOT
	## DRIVEN BY THE SUITE, WHICH IS MEASURED RATHER THAN ASSUMED: the engine
	## refuses to convert `null` into the typed parameter and reports
	## "Cannot convert argument 1 from Nil to Array" BEFORE this body runs, so no
	## statically typed caller can reach it. It stays for an untyped call path
	## that does not exist today, and the suite does not pretend to drive it.
	if records == null or records.is_empty():
		return "no passive card records were given"

	# --- Validate every record BEFORE anything is filtered --------------------
	#
	# Validation runs over the array AS GIVEN, before it is sorted. Sorting first
	# would be tidier and would hide exactly one case: the same record passed in
	# twice would be quietly deduplicated by the sort instead of being reported
	# as the duplicate id it is.
	var seen: Array[StringName] = []
	for record: PassiveCardDefinition in records:
		if record == null:
			return "a passive card record is null"
		var record_problem: String = record.problem()
		if not record_problem.is_empty():
			return "invalid passive card record: %s" % record_problem
		if seen.has(record.card_id):
			return "duplicate card id %s among the supplied records" % record.card_id
		seen.append(record.card_id)
	return ""


# --- The deterministic stream --------------------------------------------------

## The ticket for a seed, in one category's own stream. Masked to 32 bits, so it
## is always non-negative and the pure core's negative refusal can never be
## reached from a seed.
##
## The category is folded in as `category + 1` so that the first declared
## category — whose value is zero — still salts the stream rather than leaving it
## bare.
static func ticket_for(seed_value: int, requested_category: int) -> int:
	var stream: int = ((requested_category + 1) * CATEGORY_STREAM_SALT) & 0xFFFFFFFF
	return _mix((seed_value & 0xFFFFFFFF) ^ stream)


## The standard 32-bit avalanche finalizer. See the header for why this file
## carries its own copy.
static func _mix(value: int) -> int:
	var x: int = value & 0xFFFFFFFF
	x = (x ^ (x >> 16)) * 0x7FEB_352D & 0xFFFFFFFF
	x = (x ^ (x >> 15)) * 0x846C_A68B & 0xFFFFFFFF
	x = x ^ (x >> 16)
	return x & 0xFFFFFFFF


# --- Stable ordering ------------------------------------------------------------

## Sorted through `PackedStringArray` for the same reason every other stable
## order in this project is: StringName ordering is an implementation detail, and
## a deterministic result must not rest on one.
##
## It runs AFTER validation, so every entry is non-null and every id is unique —
## which is what lets this be an exact reordering rather than a best effort that
## could drop or duplicate an entry.
static func _sorted_records(
	records: Array[PassiveCardDefinition]
) -> Array[PassiveCardDefinition]:
	var by_id: Dictionary = {}
	var text: PackedStringArray = PackedStringArray()
	for record: PassiveCardDefinition in records:
		by_id[record.card_id] = record
		text.append(String(record.card_id))
	text.sort()
	var out: Array[PassiveCardDefinition] = []
	for value: String in text:
		out.append(by_id[StringName(value)])
	return out
