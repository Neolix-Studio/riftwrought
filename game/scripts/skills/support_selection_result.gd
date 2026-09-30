class_name SupportSelectionResult
extends RefCounted
## Riftwrought — Roguelite Foundation B: the outcome of one weighted support
## selection, and everything needed to explain it afterwards (decision D-227).
##
## A SELECTION THAT CANNOT BE EXPLAINED CANNOT BE REVIEWED. A weighted draw is
## the exact place where "it felt wrong" and "it was wrong" are hard to tell
## apart: the same complaint fits a bad weight, a bad eligibility rule, a bad
## ticket and a correct-but-unlucky roll. So the result carries the whole
## derivation rather than the answer alone — the ticket that was rolled, the
## total it was rolled against, the base weight, the bonuses that actually
## matched, and the effective weight they add up to. Every one of those is a
## number a reviewer can check by hand.
##
## SUCCESS AND FAILURE ARE THE SAME TYPE AND CANNOT BE CONFUSED. `ok` is the one
## flag, `failure_reason` is empty exactly when `ok` is true, and a FAILED
## RESULT CARRIES NO PARTIAL SELECTION: every id is empty and every number is
## zero. A half-filled result is how a caller ends up acting on a Skill that was
## never chosen, so the failure constructor is the only way to build one and it
## sets nothing else.
##
## ONE REFUSAL IS CLASSIFIED: AN EMPTY CANDIDATE SET (Foundation I5 correction,
## D-301). `no_candidates` is set — by `no_candidates_found()` alone — when the
## inputs were VALID and the walk simply found nothing to draw: every eligible pair
## already held, no eligible pair at all, or, in the rank-increase draw, nothing
## below its maximum. Every other refusal — a malformed record, an invalid
## acquisition state, an unusable weight, a ladder over the ceiling, a negative
## ticket — leaves it false. It exists because a caller deciding what to ask NEXT
## must tell "nothing is available" from "these inputs cannot be drawn from" without
## reading a sentence: the support-lane continuation advances from its new-pair
## phase to its rank phase only on the first. It is a classification, not a partial
## selection — a failed result still names no Skill, no support and no number — and
## it changes no successful draw and no ticket anyone owns.
##
## IT IS INERT. No node, no signal, no clock, no random source, no file. It
## describes a decision that has already been made and makes none of its own.

var ok: bool = false

## Empty exactly when `ok`. Otherwise the single plain-language reason.
var failure_reason: String = ""

# --- What was selected --------------------------------------------------------

var skill_id: StringName = &""
var support_id: StringName = &""

# --- How it was selected ------------------------------------------------------

## How many equipped Skills had at least one available eligible support. The
## first-stage draw is uniform over exactly this many candidates.
var eligible_skill_count: int = 0

## The first-stage ticket, already reduced into `[0, eligible_skill_count)`.
var skill_ticket: int = 0

## The second-stage ticket, already reduced into `[0, total_eligible_weight)`.
## This is the number that must be checked against the weight ladder below.
var rolled_ticket: int = 0

## The sum of the effective weights of every support available to the SELECTED
## Skill — the denominator the ticket was drawn against.
var total_eligible_weight: int = 0

# --- Why the selected support weighed what it did ------------------------------

var base_weight: int = 0

## Canonical tag -> bonus, for the bonuses that actually matched this Skill's
## tags, in canonical vocabulary order. Empty is the ordinary case.
var matched_bonuses: Dictionary = {}

## base_weight + the matched bonuses. Always equal to that sum for a successful
## result, which `problem()` re-derives rather than trusting.
var effective_weight: int = 0

## Whether this refusal is a VALID EMPTY CANDIDATE SET rather than an invalid input
## or an unusable ladder (D-301). Set only by `no_candidates_found()`; always false
## on a success, which `problem()` requires.
var no_candidates: bool = false


## The only way to build an ordinary failure. It deliberately sets nothing but the
## reason, so a partial selection cannot be read out of a result that did not select.
static func failed(reason: String) -> SupportSelectionResult:
	var result: SupportSelectionResult = SupportSelectionResult.new()
	result.ok = false
	result.failure_reason = reason if not reason.strip_edges().is_empty() \
		else "the selection failed for an unstated reason"
	return result


## The only way to build a refusal classified as an empty candidate set: exactly
## `failed()` plus that one classification, and no selection of any kind.
static func no_candidates_found(reason: String) -> SupportSelectionResult:
	var result: SupportSelectionResult = SupportSelectionResult.new()
	result.ok = false
	result.no_candidates = true
	result.failure_reason = reason if not reason.strip_edges().is_empty() \
		else "no candidate was available to select"
	return result


static func chosen(
	for_skill: StringName,
	for_support: StringName,
	for_base_weight: int,
	for_matched_bonuses: Dictionary,
	for_effective_weight: int,
	for_rolled_ticket: int,
	for_total_weight: int,
	for_eligible_skill_count: int,
	for_skill_ticket: int
) -> SupportSelectionResult:
	var result: SupportSelectionResult = SupportSelectionResult.new()
	result.ok = true
	result.failure_reason = ""
	result.skill_id = for_skill
	result.support_id = for_support
	result.base_weight = for_base_weight
	result.matched_bonuses = for_matched_bonuses.duplicate()
	result.effective_weight = for_effective_weight
	result.rolled_ticket = for_rolled_ticket
	result.total_eligible_weight = for_total_weight
	result.eligible_skill_count = for_eligible_skill_count
	result.skill_ticket = for_skill_ticket
	return result


## Whether the draw refused because its valid candidate set was empty. Read from the
## stored classification, never from `failure_reason`.
func has_no_candidates() -> bool:
	return not ok and no_candidates


## The selected pair, or "" when nothing was selected. Useful as a comparison
## key without reaching into two fields.
func pair() -> String:
	if not ok:
		return ""
	return "%s -> %s" % [skill_id, support_id]


func bonus_line() -> String:
	if matched_bonuses.is_empty():
		return "no matching tag bonus"
	var parts: PackedStringArray = PackedStringArray()
	for tag: Variant in matched_bonuses:
		parts.append("%s +%d" % [tag, int(matched_bonuses[tag])])
	return ", ".join(parts)


## Returns "" when the result is internally coherent, or the first inconsistency
## found. This exists because the fields above are a DERIVATION, and a
## derivation that is never re-checked is a derivation that can quietly stop
## matching the thing it describes.
func problem() -> String:
	if not ok:
		if failure_reason.strip_edges().is_empty():
			return "a failed result must state a reason"
		if not String(skill_id).is_empty() or not String(support_id).is_empty():
			return "a failed result must not name a selection"
		if base_weight != 0 or effective_weight != 0 or rolled_ticket != 0 \
				or total_eligible_weight != 0 or eligible_skill_count != 0 \
				or skill_ticket != 0 or not matched_bonuses.is_empty():
			return "a failed result must carry no partial selection"
		return ""
	if no_candidates:
		return "a successful result must not report an empty candidate set"
	if not failure_reason.is_empty():
		return "a successful result must state no failure reason"
	if String(skill_id).is_empty() or String(support_id).is_empty():
		return "a successful result must name both a Skill and a support"
	var summed: int = base_weight
	for tag: Variant in matched_bonuses:
		summed += int(matched_bonuses[tag])
	if summed != effective_weight:
		return "effective weight %d does not equal base %d plus its matched bonuses (%d)" % [
			effective_weight, base_weight, summed,
		]
	if effective_weight < 1:
		return "the selected support has an effective weight of %d" % effective_weight
	if total_eligible_weight < effective_weight:
		return "the total eligible weight %d is smaller than the selected weight %d" % [
			total_eligible_weight, effective_weight,
		]
	if rolled_ticket < 0 or rolled_ticket >= total_eligible_weight:
		return "the rolled ticket %d is outside [0, %d)" % [rolled_ticket, total_eligible_weight]
	if eligible_skill_count < 1:
		return "a successful result reports %d eligible Skills" % eligible_skill_count
	if skill_ticket < 0 or skill_ticket >= eligible_skill_count:
		return "the Skill ticket %d is outside [0, %d)" % [skill_ticket, eligible_skill_count]
	return ""


func describe() -> String:
	if not ok:
		return "no selection — %s" % failure_reason
	return "%s -> %s: Skill ticket %d of %d eligible; ticket %d of %d total; weight %d = base %d (%s)" % [
		skill_id, support_id, skill_ticket, eligible_skill_count,
		rolled_ticket, total_eligible_weight, effective_weight, base_weight, bonus_line(),
	]
