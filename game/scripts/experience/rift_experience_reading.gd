class_name RiftExperienceReading
extends RefCounted
## Riftwrought — Roguelite Foundation E1: one measurement of one caller-supplied
## experience requirement against one track, as a pure VALUE.
##
## WHY A TYPE RATHER THAN A BOOL AND A FLOAT. "Is the track ready?" and "how much
## is still needed?" are two readings of the same comparison, and both have an
## answer shape that cannot express a refusal. A bool answers `true` for a
## requirement of zero, because any progress at all is at least zero; a float
## answers `0.0` for a requirement that is not a number, because there is nothing
## sensible to subtract. Both of those are the WRONG answer wearing the right
## answer's clothes, and neither can say why. So the honest path returns this,
## where `ok` is the one flag and `failure_reason` is non-empty exactly when it
## is false.
##
## A FAILED READING CARRIES NO PARTIAL MEASUREMENT. Every number is zero and
## `ready` is false, so a caller that reads `remaining` without reading `ok` gets
## a number that is obviously wrong rather than one that is quietly plausible.
## The failure constructor is the only way to build one and it sets nothing else.
##
## IT DECIDES NO REQUIREMENT. The requirement it carries is the one it was
## measured against, supplied by whoever asked. This foundation holds no level
## curve, and this type would be the natural place for one to appear, which is
## exactly why it is written down here that there is none.
##
## IT IS INERT. No node, no signal, no clock, no random source, no file. It
## describes a comparison that has already happened and performs none.

var ok: bool = false

## Non-empty exactly when `ok` is false. Otherwise the single plain-language
## reason, naming what was refused rather than merely that something was.
var failure_reason: String = ""

# --- What was measured ---------------------------------------------------------

## The requirement this reading was taken against. Supplied by the caller, never
## chosen here.
var requirement: float = 0.0

## The effective experience the track held when the reading was taken.
var progress: float = 0.0

## Whether `progress` is at least `requirement`.
var ready: bool = false

## How much more is still required. Never negative: once the requirement is met
## the answer is exactly zero rather than a negative surplus, because "how much
## more is needed" has no negative answer. The surplus is not lost — it stays on
## the track, and advancing keeps it.
var remaining: float = 0.0


## The only way to build a failure. It deliberately sets nothing but the reason.
static func failed(reason: String) -> RiftExperienceReading:
	var result: RiftExperienceReading = RiftExperienceReading.new()
	result.ok = false
	result.failure_reason = reason if not reason.strip_edges().is_empty() \
		else "the reading failed for an unstated reason"
	return result


static func measured(
	for_requirement: float,
	for_progress: float,
	for_ready: bool,
	for_remaining: float
) -> RiftExperienceReading:
	var result: RiftExperienceReading = RiftExperienceReading.new()
	result.ok = true
	result.failure_reason = ""
	result.requirement = for_requirement
	result.progress = for_progress
	result.ready = for_ready
	result.remaining = for_remaining
	return result


## Returns "" when the reading is internally coherent, or the first
## inconsistency found. The fields above are a DERIVATION, and a derivation that
## is never re-checked is one that can quietly stop matching the thing it
## describes.
func problem() -> String:
	if not ok:
		if failure_reason.strip_edges().is_empty():
			return "a failed reading must state a reason"
		if not is_zero_approx(requirement) or not is_zero_approx(progress) \
				or not is_zero_approx(remaining):
			return "a failed reading must carry no partial measurement"
		if ready:
			return "a failed reading must not report readiness"
		return ""
	if not failure_reason.is_empty():
		return "a successful reading must state no failure reason"
	if not is_finite(requirement) or not is_finite(progress) or not is_finite(remaining):
		return "a successful reading must be finite throughout"
	if requirement <= 0.0:
		return "a successful reading must carry a positive requirement, not %s" % _shown(
			requirement)
	if progress < 0.0:
		return "a successful reading must not carry negative progress, %s" % _shown(progress)
	if ready != (progress >= requirement):
		return "reports ready %s against progress %s and requirement %s" % [
			str(ready), _shown(progress), _shown(requirement),
		]
	if remaining != maxf(requirement - progress, 0.0):
		return "the remaining %s does not match its own derivation %s" % [
			_shown(remaining), _shown(maxf(requirement - progress, 0.0)),
		]
	return ""


# --- Presentation -------------------------------------------------------------
#
# Deliberately separate from the measurement above, and reached by nothing in
# it. No formatted string is compared, parsed or fed back into a number.

func describe() -> String:
	if not ok:
		return "no reading — %s" % failure_reason
	if ready:
		return "ready: %s of the %s required" % [_shown(progress), _shown(requirement)]
	return "not ready: %s of the %s required, %s still needed" % [
		_shown(progress), _shown(requirement), _shown(remaining),
	]


## An alias for the scientific formatter this engine already carries, used
## because ordinary float printing renders the two extremes a refusal most needs
## to name as either "0.0" or as three hundred digits.
static func _shown(value: float) -> String:
	return String.num_scientific(value)
