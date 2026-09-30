class_name PlayerStatValue
extends RefCounted
## Riftwrought — Roguelite Foundation C1: the outcome of applying one total
## increased percentage to one base value, and everything needed to check it by
## hand afterwards (decision D-229).
##
## A NUMBER THAT CANNOT BE CHECKED CANNOT BE REVIEWED. "My damage feels wrong"
## fits a wrong base, a wrong total, a wrong mode and a correct calculation
## equally well, and the four are indistinguishable from the answer alone. So a
## value carries its whole derivation — the base it started from, the total it
## was given, the scale that total produced, the mode that consumed the scale,
## and the final value — and `problem()` RE-DERIVES the last of those from the
## first four rather than trusting it.
##
## SUCCESS AND FAILURE ARE THE SAME TYPE AND CANNOT BE CONFUSED. `ok` is the one
## flag, `failure_reason` is non-empty exactly when `ok` is false, and A FAILED
## VALUE CARRIES NO PARTIAL NUMBER: the stat id is empty and every number is
## zero. A half-filled result is how a caller ends up applying a modifier that
## was refused, so the failure constructor is the only way to build one and it
## sets nothing else. Zero is deliberately not a usable answer here — a caller
## that reads `value` without reading `ok` gets a number that is obviously wrong
## rather than one that is quietly plausible.
##
## IT IS INERT. No node, no signal, no clock, no random source, no file. It
## describes a calculation that has already happened and performs none.

var ok: bool = false

## Non-empty exactly when `ok` is false. Otherwise the single plain-language
## reason, naming what was refused rather than merely that something was.
var failure_reason: String = ""

# --- What was calculated ------------------------------------------------------

var stat_id: StringName = &""

## The unmodified value the calculation started from.
var base_value: float = 0.0

## The sum of every increased modifier, normalized: 0.10 is 10% increased.
var total_increased: float = 0.0

## 1 + total_increased. Always strictly positive for a successful value, which
## is the property that makes the rate mode safe to divide by.
var scale: float = 0.0

## The mode that consumed `scale`. Carried so the derivation can be re-checked
## exactly rather than by trying both arrangements and accepting either.
var mode: PlayerStatDefinition.Mode = PlayerStatDefinition.Mode.INCREASED_MULTIPLIER

var value: float = 0.0


## The only way to build a failure. It deliberately sets nothing but the reason,
## so no partial number can be read out of a calculation that did not happen.
static func failed(reason: String) -> PlayerStatValue:
	var result: PlayerStatValue = PlayerStatValue.new()
	result.ok = false
	result.failure_reason = reason if not reason.strip_edges().is_empty() \
		else "the calculation failed for an unstated reason"
	return result


static func computed(
	for_stat_id: StringName,
	for_base_value: float,
	for_total_increased: float,
	for_scale: float,
	for_mode: PlayerStatDefinition.Mode,
	for_value: float
) -> PlayerStatValue:
	var result: PlayerStatValue = PlayerStatValue.new()
	result.ok = true
	result.failure_reason = ""
	result.stat_id = for_stat_id
	result.base_value = for_base_value
	result.total_increased = for_total_increased
	result.scale = for_scale
	result.mode = for_mode
	result.value = for_value
	return result


## Returns "" when the value is internally coherent, or the first inconsistency
## found. The fields above are a DERIVATION, and a derivation that is never
## re-checked is one that can quietly stop matching the thing it describes.
func problem() -> String:
	if not ok:
		if failure_reason.strip_edges().is_empty():
			return "a failed value must state a reason"
		if not String(stat_id).is_empty():
			return "a failed value must not name a stat"
		if not is_zero_approx(base_value) or not is_zero_approx(total_increased) \
				or not is_zero_approx(scale) or not is_zero_approx(value):
			return "a failed value must carry no partial number"
		return ""
	if not failure_reason.is_empty():
		return "a successful value must state no failure reason"
	if String(stat_id).is_empty():
		return "a successful value must name its stat"
	if not is_finite(base_value) or not is_finite(total_increased) \
			or not is_finite(scale) or not is_finite(value):
		return "%s: a successful value must be finite throughout" % stat_id
	if base_value < 0.0:
		return "%s: a successful value must not start from a negative base" % stat_id
	if scale <= 0.0:
		return "%s: the scale %.6f is not positive" % [stat_id, scale]
	if not is_equal_approx(scale, 1.0 + total_increased):
		return "%s: the scale %.6f does not equal 1 plus the total increased %.6f" % [
			stat_id, scale, total_increased,
		]
	var expected: float = 0.0
	match mode:
		PlayerStatDefinition.Mode.INCREASED_MULTIPLIER:
			expected = base_value * scale
		PlayerStatDefinition.Mode.INCREASED_RATE:
			expected = base_value / scale
		_:
			return "%s: carries calculation mode %d, which cannot be re-derived" % [stat_id, mode]
	if not is_equal_approx(value, expected):
		return "%s: the value %.6f does not match its own derivation %.6f" % [
			stat_id, value, expected,
		]
	if value < 0.0:
		return "%s: produced the negative value %.6f" % [stat_id, value]
	return ""


# --- Presentation -------------------------------------------------------------

func describe() -> String:
	if not ok:
		return "no value — %s" % failure_reason
	if mode == PlayerStatDefinition.Mode.INCREASED_RATE:
		return "%s: %.4f / %.4f = %.4f" % [stat_id, base_value, scale, value]
	return "%s: %.4f x %.4f = %.4f" % [stat_id, base_value, scale, value]
