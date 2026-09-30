class_name PlayerStatDefinition
extends RefCounted
## Riftwrought — Roguelite Foundation C1: one shared player stat as the
## arithmetic sees it — its stable id, its presentation name, its browse
## category, how a percentage is applied to it, and what its final value is
## measured in (decision D-229).
##
## WHY A RECORD RATHER THAN SIX FIELDS SOMEWHERE. A percentage means nothing on
## its own. "+30%" is a larger number for one quantity and a smaller one for
## another, and the difference is not a matter of taste: applied to a magnitude
## it multiplies, applied to a duration it divides. A stat that did not declare
## which of the two it is would leave every future caller to remember, and a
## caller that remembers wrongly produces a plausible number rather than an
## error. So the mode is declared here, once, beside the id it belongs to.
##
## THE FIVE DECLARED FACTS, AND NOTHING ELSE:
##
##   stat_id        the stable identifier; snake_case, never displayed
##   display_name   the presentation name; displayed, never compared
##   category       which browse group a future offer would file it under
##   mode           how a total increased percentage becomes a final value
##   unit           what the FINAL VALUE is measured in, for presentation
##
## THE ID AND THE NAME ARE SEPARATE ON PURPOSE, and the separation is the same
## one the project already draws everywhere else: an id is a mechanical
## identity and must never change once anything can hold it, while a name is
## copy and should be free to change without invalidating a single stored
## record. Comparing on the name, or displaying the id, is how those two facts
## get welded together.
##
## THE UNIT DESCRIBES THE FINAL VALUE, NOT THE MODIFIER. Every modifier in this
## foundation is a percentage; the unit answers the other question — what the
## number that comes out is measured in. That is why a rate stat's unit is
## SECONDS even though its percentage makes the value smaller: seconds is what
## an action time IS.
##
## THE MODE AND THE UNIT MUST AGREE, AND THAT IS VALIDATED RATHER THAN TRUSTED.
## A rate stat divides a duration, so it must be measured in SECONDS; a
## multiplier stat scales a magnitude, so it must not be. Allowing a duration to
## be multiplied would mean "increased speed makes the action slower", which is
## exactly the confusion the two modes exist to prevent, and it would read as
## perfectly ordinary code.
##
## IT IS INERT. No node, no signal, no clock, no random source, no file, no
## default value for any stat, and no opinion about balance. It describes a
## quantity and computes nothing.

## Which browse group a future offer would file this stat under. Grouping is
## presentation and organisation; it changes no arithmetic, and the calculation
## path never reads it.
enum Category {
	## Damage dealt and damage survived.
	COMBAT_DEFENCE,
	## Everything else the character carries around with them.
	UTILITY,
}

## How a total increased percentage becomes a final value. There are exactly two
## because there are exactly two things a percentage can be applied to here: a
## magnitude, and a duration produced by a rate.
enum Mode {
	## final value = base value x (1 + total increased)
	##
	## The canonical form for a magnitude. `design/ATTRIBUTES_AND_DAMAGE_MODEL.md`
	## section 17 states it directly: "80% increased Damage / 20% reduced Damage
	## / = 60% increased Damage / = a multiplier of 1.60".
	INCREASED_MULTIPLIER,
	## final value = base value / (1 + total increased)
	##
	## What `design/PASSIVE_PROGRESSION.md` section 14 calls "the ordinary rate
	## relationship": an increased RATE shortens the interval it produces, so the
	## percentage divides rather than multiplies. Applying the multiplier form to
	## a duration would make an increase slow the character down.
	INCREASED_RATE,
}

## What the FINAL VALUE is measured in. Presentation only — no conversion, no
## arithmetic and no cross-unit comparison exists or is implied.
enum Unit {
	DAMAGE_POINTS,
	SECONDS,
	LIFE_POINTS,
	METRES_PER_SECOND,
	EXPERIENCE_POINTS,
	METRES,
}


var stat_id: StringName = &""

## Presentation only. Never compared, never used as a key.
var display_name: String = ""

var category: Category = Category.COMBAT_DEFENCE
var mode: Mode = Mode.INCREASED_MULTIPLIER
var unit: Unit = Unit.DAMAGE_POINTS


func _init(
	for_stat_id: StringName = &"",
	for_display_name: String = "",
	for_category: Category = Category.COMBAT_DEFENCE,
	for_mode: Mode = Mode.INCREASED_MULTIPLIER,
	for_unit: Unit = Unit.DAMAGE_POINTS
) -> void:
	stat_id = for_stat_id
	display_name = for_display_name
	category = for_category
	mode = for_mode
	unit = for_unit


static func of(
	for_stat_id: StringName,
	for_display_name: String,
	for_category: Category,
	for_mode: Mode,
	for_unit: Unit
) -> PlayerStatDefinition:
	return PlayerStatDefinition.new(
		for_stat_id, for_display_name, for_category, for_mode, for_unit
	)


# --- Record integrity ---------------------------------------------------------

## Returns "" when the definition is coherent, or the FIRST problem found, in
## plain language. Every invalid case the calculation refuses is reported here,
## so a caller can find out what is wrong without performing a calculation.
##
## The three enum-membership tests are not redundant with the type declarations
## above: an enum-typed field is an int at run time, and an int can be cast into
## one, so a value outside the declared set is reachable and must be refused
## rather than silently reaching a `match` that has no branch for it.
func problem() -> String:
	if String(stat_id).strip_edges().is_empty():
		return "a player stat definition must carry a stable id"
	if display_name.strip_edges().is_empty():
		return "%s: a player stat definition must carry a presentation name" % stat_id
	if not Category.values().has(category):
		return "%s: declares category %d, which is not a recognised category" % [
			stat_id, category,
		]
	if not Mode.values().has(mode):
		return "%s: declares calculation mode %d, which is not a recognised mode" % [
			stat_id, mode,
		]
	if not Unit.values().has(unit):
		return "%s: declares unit %d, which is not a recognised unit" % [stat_id, unit]
	if mode == Mode.INCREASED_RATE and unit != Unit.SECONDS:
		return "%s: a rate stat divides a duration and must be measured in seconds, not %s" % [
			stat_id, unit_name(),
		]
	if mode == Mode.INCREASED_MULTIPLIER and unit == Unit.SECONDS:
		return "%s: a duration must use the rate mode; multiplying it would make an increase slower" % (
			stat_id
		)
	return ""


func is_rate() -> bool:
	return mode == Mode.INCREASED_RATE


func is_combat_defence() -> bool:
	return category == Category.COMBAT_DEFENCE


# --- Presentation -------------------------------------------------------------
#
# Deliberately separate from the ids and the arithmetic above. Nothing in the
# calculation path calls anything in this section, and no assertion about a
# number is made against a formatted string.

func category_name() -> String:
	match category:
		Category.COMBAT_DEFENCE:
			return "Combat and Defence"
		Category.UTILITY:
			return "Utility"
		_:
			return "unrecognised category %d" % category


func mode_name() -> String:
	match mode:
		Mode.INCREASED_MULTIPLIER:
			return "multiplied"
		Mode.INCREASED_RATE:
			return "rate"
		_:
			return "unrecognised mode %d" % mode


func unit_name() -> String:
	match unit:
		Unit.DAMAGE_POINTS:
			return "damage"
		Unit.SECONDS:
			return "seconds"
		Unit.LIFE_POINTS:
			return "Life"
		Unit.METRES_PER_SECOND:
			return "metres per second"
		Unit.EXPERIENCE_POINTS:
			return "experience"
		Unit.METRES:
			return "metres"
		_:
			return "unrecognised unit %d" % unit


## The arithmetic this stat obeys, written out, so a reader never has to infer
## it from the mode's spelling.
func formula_line() -> String:
	if is_rate():
		return "final value = base value / (1 + total increased)"
	return "final value = base value x (1 + total increased)"


func describe() -> String:
	return "%s (%s) — %s, %s, in %s" % [
		display_name, stat_id, category_name(), formula_line(), unit_name(),
	]
