class_name RiftLevelRequirementCurve
extends RefCounted
## Riftwrought — Roguelite Foundation G1: the deterministic greybox
## level-requirement curve, as a pure STATELESS rule.
##
## IT ANSWERS ONE QUESTION. How much effective experience does a given current
## Rift level require to advance to the next one? The answer is
##
##     requirement(level) = 100 + 25 x (level - 1),     level >= 1
##
## so Level 1 costs 100, Level 2 costs 125, and every level after costs exactly
## 25 more than the one before it. These are GREYBOX PACING VALUES chosen for
## review, not final balance, and nothing else in the project reads them yet.
##
## THIS FILE IS THE ONLY OWNER OF THAT FORMULA. It is written exactly once, in
## `requirement_for()`, and nowhere else in production: not in the accepted
## experience track, not in the accepted level-up coordinator, and not in the
## result type beside this file. The suite verifies it against independently
## calculated literals, never against a second copy of itself.
##
## IT IS DELIBERATELY UNWIRED. The accepted experience track and the accepted
## level-up coordinator still receive their requirement from whoever calls them,
## exactly as they were accepted; connecting this curve to either of them, gaining
## more than one level, keeping a cumulative total, and deriving an offer seed
## from a level are all later decisions with their own authorization.
##
##
## THERE IS NO DESIGNED MAXIMUM LEVEL
## ---------------------------------------------------------------------------
## The only refusal above Level 1 is a REPRESENTATION boundary. The requirement is
## computed as a whole number and handed onward as the experience track's own
## double-precision number, and that conversion is exact only while the
## requirement stays at or below the result type's `LARGEST_EXACT_REQUIREMENT`,
## 2^53 - 1. Solving the formula against that bound gives `MAX_SUPPORTED_LEVEL`
## below — about 360 trillion levels. It is derived, not chosen, and moving
## either formula constant moves it with them.
##
## A PER-VALUE "DOES IT SURVIVE THE CONVERSION?" TEST WOULD HAVE BEEN WRONG, and
## the reason is worth keeping. Above 2^53 some whole numbers still convert
## exactly and their neighbours do not — the would-be requirement one level past
## the boundary happens to be an even number that converts exactly, and the one
## after it does not. Accepting each level on its own merits would produce a
## supported range with holes in it. The boundary is the contiguous one instead.
##
##
## THE ARITHMETIC IS CHECKED BEFORE IT HAPPENS
## ---------------------------------------------------------------------------
## Whole-number arithmetic in this engine WRAPS silently: it does not stop, warn
## or become infinite. A level large enough makes `25 x (level - 1)` wrap to a
## small positive number, and a check made on the RESULT would then accept a
## requirement of about a hundred for a level near the top of the integer range —
## plausible, positive, exactly representable, and wrong. So every operation is
## guarded by a comparison made before it runs:
##
##   - the subtraction runs only after the level is known to be at least 1, so
##     it can neither go negative nor wrap;
##   - the multiplication runs only after `steps` is known to be at most
##     `LARGEST_EXACT_REQUIREMENT / REQUIREMENT_STEP`, which for positive whole
##     numbers is exactly the condition that the product stays at or below the
##     bound;
##   - the addition runs only after the growth is known to leave room for the
##     base beneath the bound.
##
## A refusal from any guard returns before the arithmetic it protects, carries
## the requested level and a reason, and carries no requirement at all.
##
##
## IT IS PURE AND STATELESS. No instance field of any kind, no node, no signal, no
## clock, no random source, no file, no project setting, no experience track, no
## run build, no offer and no global state. The same level always produces the
## same answer, whatever was asked before it and in whatever order.

## The first current level a requirement exists for. A level is a player-facing
## ordinal, so it begins at 1.
const FIRST_LEVEL: int = 1

## What the first level requires. A greybox review value.
const BASE_REQUIREMENT: int = 100

## How much each later level requires beyond the one before it. A greybox review
## value.
const REQUIREMENT_STEP: int = 25

## The largest current level whose requirement is still an exact requirement:
## the formula solved against the result type's representation bound. DERIVED,
## never typed, so it cannot quietly disagree with either formula constant.
## The suite proves this level succeeds and the next one refuses.
const MAX_SUPPORTED_LEVEL: int = \
	(RiftLevelRequirementReading.LARGEST_EXACT_REQUIREMENT - BASE_REQUIREMENT) \
	/ REQUIREMENT_STEP + FIRST_LEVEL

const _BEYOND_REPRESENTATION: String = "level %d would require more than %d experience, the largest requirement the experience track can hold exactly; the largest supported level is %d — a representation limit, not a level cap"


## The effective experience current level `level` requires to reach the next
## one. Always a reading: `ok` with the exact requirement, or a refusal carrying
## `level` and one reason and no requirement.
static func requirement_for(level: int) -> RiftLevelRequirementReading:
	if level < FIRST_LEVEL:
		return RiftLevelRequirementReading.refused(level,
			"there is no requirement for level %d; a Rift level is at least %d" % [
				level, FIRST_LEVEL,
			])
	var steps: int = level - FIRST_LEVEL
	if steps > RiftLevelRequirementReading.LARGEST_EXACT_REQUIREMENT / REQUIREMENT_STEP:
		return RiftLevelRequirementReading.refused(level, _beyond_representation(level))
	var growth: int = REQUIREMENT_STEP * steps
	if growth > RiftLevelRequirementReading.LARGEST_EXACT_REQUIREMENT - BASE_REQUIREMENT:
		return RiftLevelRequirementReading.refused(level, _beyond_representation(level))
	var requirement: int = BASE_REQUIREMENT + growth
	return RiftLevelRequirementReading.measured(level, requirement)


## The one reason both representation guards give, naming the boundary and the
## largest level that is inside it.
static func _beyond_representation(level: int) -> String:
	return _BEYOND_REPRESENTATION % [
		level, RiftLevelRequirementReading.LARGEST_EXACT_REQUIREMENT, MAX_SUPPORTED_LEVEL,
	]
