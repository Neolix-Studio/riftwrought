class_name SupportExhaustionPassiveFallbackResult
extends RefCounted
## Riftwrought — Roguelite Foundation I6: the outcome of one exhausted-support
## passive fallback decision, and everything needed to explain and reproduce it
## (decision D-304).
##
## THREE OUTCOMES, TOLD APART BY STORED FACTS AND NEVER BY A SENTENCE:
##   - a SUCCESS (`ok`): one category and one card, with the derivation that
##     chose them;
##   - FALLBACK UNAVAILABLE (`is_unavailable()`): the inputs were valid and no
##     passive card remains once the two already offered are excluded — valid
##     catalogue exhaustion, which is neither malformed input nor the support
##     lane's own exhaustion;
##   - an ordinary REFUSAL: everything else — activation refused, a missing,
##     incoherent, refused or swapped source, a malformed record set, a draw that
##     cannot be made.
## The support lane's own exhaustion is a classification on a different record
## of a different type, so all four are distinguishable without reading text.
##
## A SUCCESS CARRIES THE DERIVATION, NOT A RESTATEMENT OF ANY CARD. It names the
## chosen category and card, the categories that were candidates in canonical
## order, the two excluded card ids, both tickets exactly as supplied, the
## reduced category ticket, and the accepted passive selector's own result for
## the card draw — whose ladder, weights, total and walked ticket are the card
## stage's whole derivation. No magnitude, stat, presentation copy or weight is
## copied into a field here.
##
## IT RE-DERIVES RATHER THAN BELIEVES. `problem()` reduces the reported category
## ticket over the reported categories and requires the reported category; asks
## the nested result whether it is coherent; requires it to have chosen the
## reported card in the reported category from a ladder holding neither excluded
## card; and requires its walked ticket to be the supplied card ticket reduced
## over that ladder. Those are separate pieces of reported data, so a fault in
## any one of them makes them disagree.
##
## COLLECTIONS ARE PRIVATE AND HANDED OUT AS COPIES. The candidate categories,
## the excluded ids and the nested draw are held privately; each accessor returns
## a fresh copy — the nested draw rebuilt through its own accepted success
## constructor — so nothing a reader is given can change what is stored. The
## remaining fields are plain values and cannot alias anything.
##
## A REFUSAL CARRIES NO PARTIAL FALLBACK: a reason, the one classification that
## separates the unavailable case, and nothing else — no category, no card, no
## ticket, no candidate and no nested draw. The two refusal constructors are the
## only ways to build one.
##
## IT IS INERT. No node, no signal, no clock, no random source, no file. It
## describes a decision that has already been made and makes none of its own.

## What `selected_category` and `category_for_ticket()` answer when there is no
## category — the accepted passive result's own sentinel, reused rather than
## restated, so one "no category" value exists in the project.
const UNRESOLVED_CATEGORY: int = PassiveCardSelectionResult.UNRESOLVED_CATEGORY


var ok: bool = false

## Empty exactly when `ok`. Otherwise the single plain-language reason.
var failure_reason: String = ""

## Whether this REFUSAL is valid catalogue exhaustion: the inputs were valid and
## no card remained. Set only by `fallback_unavailable()`. Always false on a
## success, which `problem()` requires.
var unavailable: bool = false

# --- What was decided ----------------------------------------------------------

## A canonical category on success, `UNRESOLVED_CATEGORY` on a refusal.
var selected_category: int = UNRESOLVED_CATEGORY

var selected_card_id: StringName = &""

# --- The derivation, enough to reproduce it -------------------------------------

## Both tickets EXACTLY AS SUPPLIED to the pure core, so handing them back to it
## reproduces the answer without the seed.
var category_ticket: int = 0
var card_ticket: int = 0

## The category ticket AFTER it was reduced over the candidate categories — the
## position that was actually walked.
var normalized_category_ticket: int = 0

## The available categories in canonical order: the category stage's ladder, on
## which each owns exactly one position. Private; see `candidate_categories()`.
var _candidate_categories: Array[int] = []

## The two card ids the offer already carries, which own no ticket. Private; see
## `excluded_card_ids()`.
var _excluded_card_ids: Array[StringName] = []

## The accepted passive selector's result for the card stage, stored exactly as it
## was returned. Private; see `selection()`.
var _selection: PassiveCardSelectionResult = null


## The only way to build an ordinary refusal. It sets nothing but the reason.
static func failed(reason: String) -> SupportExhaustionPassiveFallbackResult:
	var result: SupportExhaustionPassiveFallbackResult = SupportExhaustionPassiveFallbackResult.new()
	result.ok = false
	result.failure_reason = reason if not reason.strip_edges().is_empty() \
		else "the fallback refused for an unstated reason"
	return result


## The only way to build a FALLBACK-UNAVAILABLE refusal: exactly `failed()` plus
## the one classification.
static func fallback_unavailable(reason: String) -> SupportExhaustionPassiveFallbackResult:
	var result: SupportExhaustionPassiveFallbackResult = SupportExhaustionPassiveFallbackResult.new()
	result.ok = false
	result.unavailable = true
	result.failure_reason = reason if not reason.strip_edges().is_empty() \
		else "no passive card remains once the cards already offered are excluded"
	return result


static func chosen(
	for_selected_category: int,
	for_candidate_categories: Array[int],
	for_excluded_card_ids: Array[StringName],
	for_category_ticket: int,
	for_card_ticket: int,
	for_normalized_category_ticket: int,
	for_selection: PassiveCardSelectionResult
) -> SupportExhaustionPassiveFallbackResult:
	var result: SupportExhaustionPassiveFallbackResult = SupportExhaustionPassiveFallbackResult.new()
	result.ok = true
	result.failure_reason = ""
	result.selected_category = for_selected_category
	result.selected_card_id = for_selection.selected_card_id if for_selection != null else &""
	result.category_ticket = for_category_ticket
	result.card_ticket = for_card_ticket
	result.normalized_category_ticket = for_normalized_category_ticket
	result._candidate_categories = for_candidate_categories.duplicate()
	result._excluded_card_ids = for_excluded_card_ids.duplicate()
	result._selection = for_selection
	return result


# --- Reading the decision ------------------------------------------------------

## Whether this refusal is valid catalogue exhaustion. Read from the stored fact,
## never from `failure_reason`.
func is_unavailable() -> bool:
	return not ok and unavailable


## A copy of the candidate categories, in canonical order.
func candidate_categories() -> Array[int]:
	return _candidate_categories.duplicate()


## A copy of the two excluded card ids, Combat and Defence first.
func excluded_card_ids() -> Array[StringName]:
	return _excluded_card_ids.duplicate()


## A COPY of the card stage's accepted result, rebuilt through that result's own
## constructor, or null on a refusal. Mutating what this returns cannot reach the
## stored derivation.
func selection() -> PassiveCardSelectionResult:
	if _selection == null:
		return null
	if not _selection.ok:
		return PassiveCardSelectionResult.failed(
			_selection.failure_reason, _selection.requested_category
		)
	return PassiveCardSelectionResult.chosen(
		_selection.requested_category, _selection.candidate_ids,
		_selection.candidate_weights, _selection.total_weight,
		_selection.normalized_ticket, _selection.selected_card_id
	)


## Which category owns the category-ladder POSITION `ticket`, or
## `UNRESOLVED_CATEGORY`. Like the passive result's own audit path it does not
## reduce: only `[0, number of candidate categories)` is answerable, so a reported
## position that is out of range is exposed rather than folded.
func category_for_ticket(ticket: int) -> int:
	if ticket < 0 or ticket >= _candidate_categories.size():
		return UNRESOLVED_CATEGORY
	return _candidate_categories[ticket]


## "" when the result is internally coherent, or the first inconsistency found.
func problem() -> String:
	if not ok:
		if failure_reason.strip_edges().is_empty():
			return "a refused result must state a reason"
		if selected_category != UNRESOLVED_CATEGORY:
			return "a refused result must not name a category"
		if not String(selected_card_id).is_empty():
			return "a refused result must not name a card"
		if category_ticket != 0 or card_ticket != 0 or normalized_category_ticket != 0:
			return "a refused result must carry no ticket"
		if not _candidate_categories.is_empty() or not _excluded_card_ids.is_empty():
			return "a refused result must carry no partial derivation"
		if _selection != null:
			return "a refused result must carry no nested draw"
		return ""
	if unavailable:
		return "a successful result must not declare the fallback unavailable"
	if not failure_reason.is_empty():
		return "a successful result must state no failure reason"
	if category_ticket < 0 or card_ticket < 0:
		return "a successful result reports a negative ticket"

	var canonical: Array[int] = SupportExhaustionPassiveFallback.CANONICAL_CATEGORIES
	if _candidate_categories.is_empty() or _candidate_categories.size() > canonical.size():
		return "%d candidate categories against %d canonical ones" % [
			_candidate_categories.size(), canonical.size(),
		]
	for index: int in _candidate_categories.size():
		var category: int = _candidate_categories[index]
		if not canonical.has(category):
			return "%d is not a canonical passive category" % category
		if index > 0 and not (_candidate_categories[index - 1] < category):
			return "the candidate categories are not in ascending canonical order"
	if normalized_category_ticket != category_ticket % _candidate_categories.size():
		return "category ticket %d reduces to %d over %d categories, not the reported %d" % [
			category_ticket, category_ticket % _candidate_categories.size(),
			_candidate_categories.size(), normalized_category_ticket,
		]
	if category_for_ticket(normalized_category_ticket) != selected_category:
		return "category position %d belongs to %s, but %s was reported" % [
			normalized_category_ticket,
			PassiveCardSelectionResult.category_label(
				category_for_ticket(normalized_category_ticket)),
			PassiveCardSelectionResult.category_label(selected_category),
		]

	if _excluded_card_ids.size() != 2 \
			or String(_excluded_card_ids[0]).is_empty() \
			or String(_excluded_card_ids[1]).is_empty() \
			or _excluded_card_ids[0] == _excluded_card_ids[1]:
		return "a successful result must exclude exactly the two distinct cards the offer already carries"

	if _selection == null:
		return "a successful result must carry the draw that chose its card"
	if not _selection.ok:
		return "a successful result carries a refused draw: %s" % _selection.failure_reason
	var nested: String = _selection.problem()
	if not nested.is_empty():
		return "the nested draw is incoherent: %s" % nested
	if _selection.requested_category != selected_category:
		return "the nested draw was made in %s, not in the chosen %s" % [
			PassiveCardSelectionResult.category_label(_selection.requested_category),
			PassiveCardSelectionResult.category_label(selected_category),
		]
	if _selection.selected_card_id != selected_card_id:
		return "%s is reported, but the nested draw chose %s" % [
			selected_card_id, _selection.selected_card_id,
		]
	for card_id: StringName in _excluded_card_ids:
		if _selection.candidate_ids.has(card_id):
			return "%s is excluded but owns tickets on the nested ladder" % card_id
	if _selection.normalized_ticket != card_ticket % _selection.total_weight:
		return "card ticket %d reduces to %d on a ladder of %d, but the nested draw walked %d" % [
			card_ticket, card_ticket % _selection.total_weight,
			_selection.total_weight, _selection.normalized_ticket,
		]
	return ""


# --- Presentation --------------------------------------------------------------
#
# Deliberately separate from the fields and the re-derivation above, and reached
# by nothing in either. No formatted string is compared, parsed or fed back.

func describe() -> String:
	if not ok:
		if unavailable:
			return "fallback unavailable — %s" % failure_reason
		return "no fallback — %s" % failure_reason
	var labels: PackedStringArray = PackedStringArray()
	for category: int in _candidate_categories:
		labels.append(PassiveCardSelectionResult.category_label(category))
	var excluded: PackedStringArray = PackedStringArray()
	for card_id: StringName in _excluded_card_ids:
		excluded.append(String(card_id))
	return "%s: %s from category position %d of %d [%s], excluding [%s]; %s" % [
		PassiveCardSelectionResult.category_label(selected_category), selected_card_id,
		normalized_category_ticket, _candidate_categories.size(), ", ".join(labels),
		", ".join(excluded), _selection.describe() if _selection != null else "no draw",
	]
