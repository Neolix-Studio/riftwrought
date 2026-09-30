class_name PassiveCardSelectionResult
extends RefCounted
## Riftwrought — Roguelite Foundation C3: the outcome of one deterministic
## passive card draw, and everything needed to explain it afterwards
## (decision D-234).
##
## A SELECTION THAT CANNOT BE EXPLAINED CANNOT BE REVIEWED. A weighted draw is
## the exact place where "it felt wrong" and "it was wrong" are hard to tell
## apart: the same complaint fits a bad weight, a bad category, a bad ticket and
## a correct-but-unlucky roll. So the result carries the whole derivation rather
## than the answer alone — the category that was asked for, the ordered
## candidates, the weight each of them owns, the total those weights sum to, and
## the reduced ticket that was actually walked against that ladder. Every one of
## those is a number a reviewer can check by hand, and this file re-checks them
## itself rather than trusting the selector that filled them in.
##
## IT RE-DERIVES THE ANSWER RATHER THAN BELIEVING IT. `problem()` walks the
## ladder again with the reported ticket and requires that it lands on the
## reported card. That is the one assertion that cannot be satisfied by a
## selector agreeing with itself: the ladder and the answer are two separate
## pieces of reported data, and a fault in either makes them disagree.
##
## SUCCESS AND FAILURE ARE THE SAME TYPE AND CANNOT BE CONFUSED. `ok` is the one
## flag, `failure_reason` is empty exactly when `ok` is true, and A FAILED
## RESULT CARRIES NO PARTIAL SELECTION: no card, no candidates, no weights, no
## total and no ticket. A half-filled result is how a caller ends up acting on a
## card that was never drawn, so the failure constructor is the only way to build
## one and it sets nothing else.
##
## THE ONE THING A FAILURE DOES CARRY IS THE QUESTION, NOT AN ANSWER. The
## requested category is echoed on a refusal, because "which lane refused" is the
## first thing a reader wants and it is not a selection. It is declared as an
## `int` rather than as the enum, and it defaults to `UNRESOLVED_CATEGORY`, for
## the reason the card record already states about its own derived members: an
## enum-typed field is an int at run time, so an unrecognised value is reachable
## and must be reportable — and defaulting to the enum's zero member would make
## every unstated failure claim it was asked about combat and defence.
##
## IT IS INERT. No node, no signal, no clock, no random source, no file. It
## describes a decision that has already been made and makes none of its own.

## What `requested_category` reads as when nothing has been asked for.
## Deliberately outside every declared category: a caller that reads it without
## reading `ok` gets a value that is obviously wrong rather than one that is
## quietly plausible.
##
## ONE COLLISION IS RECORDED RATHER THAN LEFT TO BE FOUND: a caller may also ASK
## for -1, and that refusal echoes -1, so the field alone cannot separate "asked
## for the sentinel" from "nothing was asked for". No CONSTRUCTED result is
## ambiguous — a refusal always carries a reason naming the value, and a
## default-constructed result carries none, which `problem()` refuses outright.
## The ambiguity is therefore reachable only by reading one field of an object
## that `problem()` already rejects, and the suite drives exactly that.
const UNRESOLVED_CATEGORY: int = -1


var ok: bool = false

## Empty exactly when `ok`. Otherwise the single plain-language reason.
var failure_reason: String = ""

## The category the draw was asked for, echoed on success and on failure. A
## `PlayerStatDefinition.Category` member, or `UNRESOLVED_CATEGORY`, or — on the
## refusal that exists for exactly this — whatever unrecognised value was asked
## for, so the reason and the field agree.
var requested_category: int = UNRESOLVED_CATEGORY

# --- The ladder the draw was made against -------------------------------------

## Every card in the requested category, by stable id, in ascending id order.
## The order is the ladder's order: candidate `i` owns the tickets immediately
## after those of candidate `i - 1`.
var candidate_ids: Array[StringName] = []

## The weight each candidate owns, positionally matched to `candidate_ids`.
var candidate_weights: Array[int] = []

## The sum of `candidate_weights` — the denominator the ticket was reduced
## against.
var total_weight: int = 0

## The ticket AFTER it was reduced into `[0, total_weight)`. The reduced number
## is reported rather than the supplied one, so the value a reviewer checks
## against the ladder is always the value that was actually walked.
var normalized_ticket: int = 0

# --- What was selected ---------------------------------------------------------

var selected_card_id: StringName = &""


## The only way to build a failure. It deliberately sets nothing but the reason
## and the question, so a partial selection cannot be read out of a result that
## did not select.
static func failed(reason: String, for_requested_category: int) -> PassiveCardSelectionResult:
	var result: PassiveCardSelectionResult = PassiveCardSelectionResult.new()
	result.ok = false
	result.failure_reason = reason if not reason.strip_edges().is_empty() \
		else "the selection failed for an unstated reason"
	result.requested_category = for_requested_category
	return result


static func chosen(
	for_requested_category: int,
	for_candidate_ids: Array[StringName],
	for_candidate_weights: Array[int],
	for_total_weight: int,
	for_normalized_ticket: int,
	for_selected_card_id: StringName
) -> PassiveCardSelectionResult:
	var result: PassiveCardSelectionResult = PassiveCardSelectionResult.new()
	result.ok = true
	result.failure_reason = ""
	result.requested_category = for_requested_category
	result.candidate_ids = for_candidate_ids.duplicate()
	result.candidate_weights = for_candidate_weights.duplicate()
	result.total_weight = for_total_weight
	result.normalized_ticket = for_normalized_ticket
	result.selected_card_id = for_selected_card_id
	return result


# --- Re-derivation -------------------------------------------------------------

## Which candidate owns the ladder position `ticket`, walked from the reported
## ladder alone, or `&""` when the ladder cannot answer. Pure and total: it reads
## no field but the two arrays, and it is safe on a failed result.
##
## IT TAKES A POSITION ON THE LADDER, NOT A RAW TICKET, AND IT DELIBERATELY DOES
## NOT REDUCE. Only `[0, total_weight)` is answerable; anything else — negative,
## or at or beyond the total — answers `&""` rather than being folded. That is
## the opposite of the selector's own entry points, which DO wrap, and the
## difference is the point: this function exists so `problem()` can re-derive the
## selection from the REPORTED numbers, and a reducing version would quietly
## answer for a reported ticket that was out of range instead of exposing it.
##
## THIS IS THE AUDIT ENTRY POINT. A reviewer holding a result can ask it who owns
## any position on that ladder and compare the answer against the selector's,
## without running the selector at all.
func card_for_ticket(ticket: int) -> StringName:
	if ticket < 0:
		return &""
	if candidate_ids.size() != candidate_weights.size():
		return &""
	var running: int = 0
	for index: int in candidate_ids.size():
		running += candidate_weights[index]
		if ticket < running:
			return candidate_ids[index]
	return &""


## Returns "" when the result is internally coherent, or the first inconsistency
## found. This exists because the fields above are a DERIVATION, and a
## derivation that is never re-checked is a derivation that can quietly stop
## matching the thing it describes.
func problem() -> String:
	if not ok:
		if failure_reason.strip_edges().is_empty():
			return "a failed result must state a reason"
		if not String(selected_card_id).is_empty():
			return "a failed result must not name a selection"
		if not candidate_ids.is_empty() or not candidate_weights.is_empty():
			return "a failed result must carry no candidate ladder"
		if total_weight != 0 or normalized_ticket != 0:
			return "a failed result must carry no partial selection"
		return ""
	if not failure_reason.is_empty():
		return "a successful result must state no failure reason"
	if not PlayerStatDefinition.Category.values().has(requested_category):
		return "a successful result reports the unrecognised category %d" % requested_category
	if String(selected_card_id).is_empty():
		return "a successful result must name the card it selected"
	if candidate_ids.is_empty():
		return "a successful result must carry the ladder it drew from"
	if candidate_ids.size() != candidate_weights.size():
		return "%d candidates against %d weights" % [
			candidate_ids.size(), candidate_weights.size(),
		]

	## THE LADDER IS ORDERED BY STABLE ID, RE-DERIVED RATHER THAN TRUSTED. A
	## strict comparison rather than a loose one, because equal neighbours would
	## be a duplicate id the selector is required to have refused.
	for index: int in range(1, candidate_ids.size()):
		if not (String(candidate_ids[index - 1]) < String(candidate_ids[index])):
			return "the candidate ladder is not in ascending id order at %s" % (
				candidate_ids[index]
			)

	var summed: int = 0
	for index: int in candidate_weights.size():
		var weight: int = candidate_weights[index]
		if weight < PassiveCardDefinition.MINIMUM_BASE_WEIGHT:
			return "%s owns a weight of %d, below the minimum of %d" % [
				candidate_ids[index], weight, PassiveCardDefinition.MINIMUM_BASE_WEIGHT,
			]
		summed += weight
	if summed != total_weight:
		return "the reported total weight %d does not equal the sum of the ladder (%d)" % [
			total_weight, summed,
		]
	if normalized_ticket < 0 or normalized_ticket >= total_weight:
		return "the normalized ticket %d is outside [0, %d)" % [
			normalized_ticket, total_weight,
		]
	if not candidate_ids.has(selected_card_id):
		return "%s was selected but is not on the ladder it was drawn from" % selected_card_id

	## THE ONE THAT CANNOT PASS BY AGREEING WITH ITSELF: walk the reported
	## ladder with the reported ticket and require the reported answer.
	var walked: StringName = card_for_ticket(normalized_ticket)
	if walked != selected_card_id:
		return "ticket %d lands on %s, but %s was reported as selected" % [
			normalized_ticket, walked, selected_card_id,
		]
	return ""


# --- Presentation --------------------------------------------------------------
#
# Deliberately separate from the fields and the re-derivation above, and reached
# by nothing in either. No formatted string is compared, parsed or fed back into
# a number.

## The category's own presentation label, DERIVED from the canonical vocabulary
## rather than restated here — the same discipline the card record keeps for its
## category, mode and unit. An unrecognised value says so instead of borrowing a
## plausible label.
static func category_label(category: int) -> String:
	for record: PlayerStatDefinition in PlayerStats.definitions():
		if record.category == category:
			return record.category_name()
	return "unrecognised category %d" % category


## The ladder as `id x weight` pairs, in ticket order.
func ladder_line() -> String:
	var parts: PackedStringArray = PackedStringArray()
	for index: int in candidate_ids.size():
		var weight: int = candidate_weights[index] if index < candidate_weights.size() else 0
		parts.append("%s x%d" % [candidate_ids[index], weight])
	return ", ".join(parts) if not parts.is_empty() else "no candidates"


func describe() -> String:
	if not ok:
		return "no selection (%s) — %s" % [
			category_label(requested_category), failure_reason,
		]
	return "%s: %s from ticket %d of %d over [%s]" % [
		category_label(requested_category), selected_card_id,
		normalized_ticket, total_weight, ladder_line(),
	]
