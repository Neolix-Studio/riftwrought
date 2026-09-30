class_name RiftLevelRequirementReading
extends RefCounted
## Riftwrought — Roguelite Foundation G1: one answer to "how much effective
## experience does this current Rift level require to reach the next one?", as a
## pure VALUE.
##
## WHY A TYPE RATHER THAN A NUMBER. A bare integer cannot say "there is no
## requirement for that level", and every integer it could return instead is a
## real-looking answer: zero reads as "free", a negative number reads as a
## refund, and a huge number reads as "very expensive". So the answer comes back
## with `ok`, and `failure_reason` is non-empty exactly when `ok` is false.
##
## A REFUSED READING CARRIES NO USABLE REQUIREMENT. Its STORED requirement is
## `NO_REQUIREMENT`, which is zero, and zero is unambiguous here for one reason:
## every requirement the curve can produce is strictly positive, so zero is a
## value no successful reading can ever hold. It is only meaningful beside `ok`,
## which is the authority. The requested level is kept on a refusal too, because
## it is the one input a reader needs to reproduce the question.
##
## THE STORED ZERO AND THE CONVERTED INFINITY ARE DIFFERENT THINGS ON PURPOSE
## (decision D-263). Zero is safe to STORE because `ok` stands beside it. It is not
## safe to HAND OUT as a number, because a number travels without its `ok`: a
## caller that compares `progress >= requirement` without asking `ok` first would
## read a zero as "already satisfied". So a refused reading CONVERTS to positive
## infinity instead — see `experience_requirement()`.
##
## THE REQUIREMENT IS A WHOLE NUMBER, AND THIS TYPE OWNS ITS CONVERSION. The
## accepted experience track measures experience as a double-precision number,
## and every whole number is exactly a double only up to 2^53. Above that the
## doubles are two apart, then four, and a whole number either survives the
## conversion or is silently replaced by a neighbour. `LARGEST_EXACT_REQUIREMENT`
## is the last whole number below which every whole number is exact AND distinct
## from both of its neighbours, and a successful reading never carries more.
## `experience_requirement()` is the one place the whole number becomes the
## track's number, and it is exact for every requirement this type can coherently
## hold.
##
## IT OWNS NO FORMULA. It records what was asked and what was answered; which
## number belongs to which level is decided by the curve alone, and re-deriving it
## here would either restate that rule a second time or make the two files name
## each other. `problem()` checks this value's own SHAPE — never whether its
## requirement is the right one for its level. The suite proves that.
##
## IT IS INERT. No node, no signal, no clock, no random source, no file. It
## describes an answer that has already been given and performs nothing.

## The number of significant bits a double carries, counting the implicit one.
## It is what bounds exactness, and it is the only reason the bound below exists.
const EXACT_INTEGER_BITS: int = 53

## 2^53 - 1: the largest whole number such that it and every whole number below
## it convert to a double exactly and distinctly. 2^53 itself converts exactly
## but is the same double as 2^53 + 1, so a double of that size no longer says
## which whole number it came from. A representation boundary, never a balance
## value and never a level cap.
const LARGEST_EXACT_REQUIREMENT: int = (1 << EXACT_INTEGER_BITS) - 1

## What a refused reading carries as its requirement. Zero, because no successful
## requirement is ever zero; see the header for why it is unambiguous only beside
## `ok`.
const NO_REQUIREMENT: int = 0

var ok: bool = false

## Non-empty exactly when `ok` is false. Otherwise the single plain-language
## reason, naming what was refused rather than merely that something was.
var failure_reason: String = ""

## The current level that was asked about — on a success and, as diagnostic
## input, on a refusal as well.
var level: int = 0

## The effective experience that level requires to reach the next one, as an
## exact whole number. `NO_REQUIREMENT` on a refusal.
var requirement: int = NO_REQUIREMENT


## The only way to build a refusal. It sets the question and the reason and
## deliberately nothing else, so no partial requirement can ride along with one.
static func refused(for_level: int, reason: String) -> RiftLevelRequirementReading:
	var result: RiftLevelRequirementReading = RiftLevelRequirementReading.new()
	result.ok = false
	result.failure_reason = reason if not reason.strip_edges().is_empty() \
		else "the level requirement was refused for an unstated reason"
	result.level = for_level
	result.requirement = NO_REQUIREMENT
	return result


static func measured(for_level: int, for_requirement: int) -> RiftLevelRequirementReading:
	var result: RiftLevelRequirementReading = RiftLevelRequirementReading.new()
	result.ok = true
	result.failure_reason = ""
	result.level = for_level
	result.requirement = for_requirement
	return result


## The requirement in the accepted experience track's own numeric type, converted
## only now that the exact whole number is known. Exact for every coherent
## success, because a coherent success never exceeds `LARGEST_EXACT_REQUIREMENT`.
##
## A REFUSED READING CONVERTS TO POSITIVE INFINITY. That is a FAIL-SAFE
## CONVERSION VALUE: it is not a requirement, it is not a very large requirement,
## and it is not a partial success — the stored requirement is still zero and `ok`
## is still false, and a careful caller asks `ok` before it ever converts. It
## exists for the careless caller. A finite comparison such as
## `progress >= reading.experience_requirement()` is FALSE for every finite
## progress when handed infinity, where a zero would make the same comparison
## true and read a requirement that does not exist as already met. And the
## accepted experience track refuses any requirement that is not finite, so
## handing the conversion onward is refused there too and moves nothing.
##
## Positive infinity, never negative infinity (which every finite progress would
## exceed) and never NaN (which no ordinary comparison can reason about).
func experience_requirement() -> float:
	if not ok:
		return INF
	return float(requirement)


## Returns "" when the reading is internally coherent, or the first
## inconsistency found. It checks the SHAPE of the answer — a refusal carries a
## reason and nothing usable, a success carries no reason, a level that is an
## ordinal, and a positive requirement that converts exactly — and never which
## number belongs to which level, which is the curve's alone.
func problem() -> String:
	if not ok:
		if failure_reason.strip_edges().is_empty():
			return "a refused reading must state a reason"
		if requirement != NO_REQUIREMENT:
			return "a refused reading must carry no requirement, not %d" % requirement
		return ""
	if not failure_reason.is_empty():
		return "a successful reading must state no failure reason"
	## A level is a player-facing ordinal, so a successful answer is for a
	## positive one. Stated as positivity rather than against the curve's first
	## level, which this type deliberately does not name.
	if level <= 0:
		return "a successful reading must be for a positive level, not %d" % level
	if requirement <= NO_REQUIREMENT:
		return "a successful reading must carry a positive requirement, not %d" % requirement
	if requirement > LARGEST_EXACT_REQUIREMENT:
		return "a successful reading carries %d, beyond %d, the largest exact requirement" % [
			requirement, LARGEST_EXACT_REQUIREMENT,
		]
	return ""


# --- Presentation -------------------------------------------------------------
#
# Deliberately separate from the answer above, and reached by nothing in it. No
# formatted string is compared, parsed or fed back into a number.

func describe() -> String:
	if not ok:
		return "refused — %s" % failure_reason
	return "level %d requires %d experience to reach the next level" % [level, requirement]
