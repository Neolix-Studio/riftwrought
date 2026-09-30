class_name PassiveCardDefinition
extends RefCounted
## Riftwrought — Roguelite Foundation C2: one passive card as a RECORD, and
## nothing more (decision D-231).
##
## WHAT A CARD IS HERE. Six authored facts: a stable id, a presentation name,
## the player stat it moves, how much it moves it by, how often a future offer
## should reach for it, and whether it may be taken more than once. That is the
## whole record. It is not selected, not displayed, not offered and not applied
## by anything — those are later decisions with their own authorization.
##
## THE SIX AUTHORED FACTS, AND NOTHING ELSE:
##
##   card_id        the stable identifier; lower_snake_case, never displayed,
##                  and ENFORCED rather than merely intended (D-232)
##   display_name   the presentation name; displayed, never compared
##   stat_id        the player stat this card moves, named in the vocabulary
##   magnitude      the normalized increase; 0.10 is +10%, and it is positive
##   base_weight    a positive integer; how often an offer should reach for it
##   repeatable     whether the same card may be taken more than once
##
## THE CATEGORY, THE ARITHMETIC MODE AND THE UNIT ARE DERIVED, NEVER RESTATED,
## AND THAT IS THE POINT OF THE FILE. A card that carried its own copy of the
## three could disagree with the vocabulary about what "+10%" even does — one
## record calling a quantity a rate and another calling it a magnitude is how a
## percentage quietly starts dividing where it used to multiply. So they are
## READ from the canonical player stat definition every time they are asked
## for, and there is no field here to write a second answer into. This is the
## same discipline the support layer already keeps, where a definition reads its
## id and its name from the rule it holds rather than restating them.
##
## RESTATEMENT IS STILL POLICED, BECAUSE "IMPOSSIBLE HERE" IS NOT "IMPOSSIBLE".
## A caller holding its own stat definition can hand one in, and if that record
## disagrees with the vocabulary about the category, the mode or the unit, the
## disagreement is REFUSED by name rather than believed. That is what
## `problem_against()` exists for, and it is the entry point the redundancy
## refusals are driven through — a guard nothing can reach is not a guard.
##
## THE MAGNITUDE IS NORMALIZED AND STRICTLY POSITIVE. 0.10 is +10%, everywhere,
## in every field and every argument. Zero is refused rather than treated as "a
## card that does nothing": a card that cannot change a number is an absent card,
## not a zero one, which is exactly the reasoning the weight floor already uses.
## A negative magnitude is refused too — a card that takes something away is a
## different design with its own authorization, and it must not arrive by
## someone typing a minus sign.
##
## IT IS INERT. No node, no signal, no clock, no random source, no file, no
## selection, no offer, no stacking rule, no cap, no rarity, no diminishing
## return and no application. It describes a card and changes nothing.

## The stable-id contract (D-232): a card id is lower_snake_case, matching
## `^[a-z][a-z0-9_]*$` exactly. It is written here as a pattern for a reader and
## implemented below as a character test for the machine, because a validation a
## record layer runs on every call should allocate nothing; the suite proves the
## two agree by running the owner's literal pattern over a table of ids.
##
## IT IS ENFORCED HERE AND DELIBERATELY NOWHERE ELSE. This is Foundation C2's own
## contract for its own ids. It is not a project-wide identifier policy, it does
## not reach the vocabulary's stat ids or either earlier foundation's records,
## and reconciling those is recorded debt rather than part of this rule.
const ID_PATTERN: String = "^[a-z][a-z0-9_]*$"

## The smallest legal base weight. A card that can never be offered is an absent
## card, not a zero-weight one, so zero is refused rather than treated as "never
## offer this". The value and the reasoning are the support layer's, unchanged.
const MINIMUM_BASE_WEIGHT: int = 1

## What the derived accessors answer when the vocabulary does not recognise this
## card's stat. Deliberately outside every declared enum: a caller that reads it
## without reading `problem()` gets a value that is obviously wrong rather than
## one that is quietly plausible.
const UNRESOLVED: int = -1


var card_id: StringName = &""

## Presentation only. Never compared, never used as a key.
var display_name: String = ""

## The player stat this card moves. Must be one the vocabulary declares.
var stat_id: StringName = &""

## The normalized increase this card grants: 0.10 is +10%. Strictly positive.
var magnitude: float = 0.0

var base_weight: int = MINIMUM_BASE_WEIGHT

## Whether the same card may be held more than once. It records the intent only;
## no stacking arithmetic, cap or diminishing return exists in this foundation.
var repeatable: bool = false


func _init(
	for_card_id: StringName = &"",
	for_display_name: String = "",
	for_stat_id: StringName = &"",
	for_magnitude: float = 0.0,
	for_base_weight: int = MINIMUM_BASE_WEIGHT,
	for_repeatable: bool = false
) -> void:
	card_id = for_card_id
	display_name = for_display_name
	stat_id = for_stat_id
	magnitude = for_magnitude
	base_weight = for_base_weight
	repeatable = for_repeatable


static func of(
	for_card_id: StringName,
	for_display_name: String,
	for_stat_id: StringName,
	for_magnitude: float,
	for_base_weight: int,
	for_repeatable: bool
) -> PassiveCardDefinition:
	return PassiveCardDefinition.new(
		for_card_id, for_display_name, for_stat_id,
		for_magnitude, for_base_weight, for_repeatable
	)


# --- The stable-id contract ----------------------------------------------------

## Whether `candidate` satisfies `ID_PATTERN`. Pure, total and static: one
## lower-case letter, then any number of lower-case letters, digits and
## underscores, and nothing else — so a leading digit, a leading underscore, a
## capital, a hyphen, a dot and any whitespace at all are each refused.
static func is_legal_id(candidate: StringName) -> bool:
	var text: String = String(candidate)
	if text.is_empty():
		return false
	if not _is_lower_letter(text.unicode_at(0)):
		return false
	for index: int in range(1, text.length()):
		var code: int = text.unicode_at(index)
		if _is_lower_letter(code) or _is_digit(code) or code == 95:
			continue
		return false
	return true


static func _is_lower_letter(code: int) -> bool:
	return code >= 97 and code <= 122


static func _is_digit(code: int) -> bool:
	return code >= 48 and code <= 57


# --- Derived facts -------------------------------------------------------------
#
# Read from the canonical player stat definition, never restated here. There is
# deliberately no field any of these could be written into.

## The canonical definition this card's category, mode and unit are read from,
## or null when the vocabulary does not recognise `stat_id` — which `problem()`
## refuses, so a validated card always resolves.
func stat_definition() -> PlayerStatDefinition:
	return PlayerStats.definition(stat_id)


## The browse category, as a `PlayerStatDefinition.Category` member, or
## `UNRESOLVED`. Declared `int` rather than the enum type on purpose: the
## unresolved answer is deliberately outside the enum, and a function that
## promised the enum type would be promising something it cannot deliver for an
## unrecognised stat.
func category() -> int:
	var record: PlayerStatDefinition = stat_definition()
	return record.category if record != null else UNRESOLVED


## The arithmetic mode, as a `PlayerStatDefinition.Mode` member, or `UNRESOLVED`.
func mode() -> int:
	var record: PlayerStatDefinition = stat_definition()
	return record.mode if record != null else UNRESOLVED


## The unit the FINAL VALUE is measured in, as a `PlayerStatDefinition.Unit`
## member, or `UNRESOLVED`.
func unit() -> int:
	var record: PlayerStatDefinition = stat_definition()
	return record.unit if record != null else UNRESOLVED


## The stat's presentation name — the one a description shows. Read from the
## vocabulary, so a card and the stat it moves can never display two different
## names for one quantity.
func stat_display_name() -> String:
	var record: PlayerStatDefinition = stat_definition()
	return record.display_name if record != null else ""


# --- Record integrity ----------------------------------------------------------

## Returns "" when the card is coherent, or the FIRST problem found, in plain
## language.
##
## It is a LOOKUP in front of `problem_against()` and holds no rule of its own,
## so there is exactly one place a card is validated.
func problem() -> String:
	return problem_against(stat_definition())


## The validation itself, against a supplied stat definition rather than the one
## the vocabulary would look up.
##
## IT TAKES A RECORD SO THAT A RESTATED ONE CAN ACTUALLY REACH IT. Every
## definition the vocabulary can return already agrees with the vocabulary, so a
## redundancy refusal that only `problem()` could deliver would be a guard
## nothing can reach. This entry point is the one a caller holding its own copy
## of a stat's facts will use, and it is the one the restatement refusals below
## are driven through.
func problem_against(record: PlayerStatDefinition) -> String:
	if String(card_id).strip_edges().is_empty():
		return "a passive card must carry a stable id"
	if not is_legal_id(card_id):
		return "'%s' is not a legal card id: an id must be lower_snake_case, matching %s" % [
			card_id, ID_PATTERN,
		]
	if display_name.strip_edges().is_empty():
		return "%s: a passive card must carry a presentation name" % card_id
	if String(stat_id).strip_edges().is_empty():
		return "%s: a passive card must name the player stat it moves" % card_id
	if not PlayerStats.is_known(stat_id):
		return "%s: names %s, which is not a recognised player stat" % [card_id, stat_id]
	if not is_finite(magnitude):
		return "%s: the magnitude is not a finite number" % card_id
	if magnitude <= 0.0:
		return "%s: the magnitude %.6f is not positive" % [card_id, magnitude]
	if base_weight < MINIMUM_BASE_WEIGHT:
		return "%s: base weight %d is below the minimum of %d" % [
			card_id, base_weight, MINIMUM_BASE_WEIGHT,
		]
	if record == null:
		return "%s: a validation needs a stat definition" % card_id
	if record.stat_id != stat_id:
		return "%s: moves %s but was validated against the definition of %s" % [
			card_id, stat_id, record.stat_id,
		]
	var record_problem: String = record.problem()
	if not record_problem.is_empty():
		return "%s: %s" % [card_id, record_problem]

	## THE REDUNDANCY RULE. `record` is a second copy of facts this card is
	## supposed to DERIVE, so it may agree with the vocabulary and may not
	## disagree with it. Each of the three is compared separately, so the reason
	## names which fact was restated wrongly rather than merely that one was.
	var canonical: PlayerStatDefinition = PlayerStats.definition(stat_id)
	if canonical == null:
		## DEFENCE IN DEPTH, AND DELIBERATELY UNREACHABLE FROM HERE: the
		## recognised-stat test a few lines above already refuses every id the
		## vocabulary cannot answer for, so this branch cannot fire today and the
		## suite does not pretend to drive it. It stays because a lookup with no
		## null branch is how a later vocabulary change starts comparing against
		## nothing instead of reporting one.
		return "%s: the vocabulary has no definition for %s" % [card_id, stat_id]
	if record.category != canonical.category:
		return "%s: restates the category of %s as %s where the vocabulary declares %s" % [
			card_id, stat_id, record.category_name(), canonical.category_name(),
		]
	if record.mode != canonical.mode:
		return "%s: restates the calculation mode of %s as %s where the vocabulary declares %s" % [
			card_id, stat_id, record.mode_name(), canonical.mode_name(),
		]
	if record.unit != canonical.unit:
		return "%s: restates the unit of %s as %s where the vocabulary declares %s" % [
			card_id, stat_id, record.unit_name(), canonical.unit_name(),
		]
	return ""


# --- Presentation --------------------------------------------------------------
#
# Deliberately separate from the record and the validation above. A formatted
# string is never compared, parsed or fed back into a number, and nothing in the
# validation path reads anything in this section.

## The factual description of what this card grants, derived end to end:
## `+10% Movement Speed`. The percentage comes from the vocabulary's own
## formatter and the name from the referenced stat definition, so a card cannot
## display a percentage in one style or a stat under one name while the
## vocabulary uses another.
##
## IT DELIBERATELY TAKES NO RECORD, UNLIKE `problem_against()`. A validation
## entry point that accepts a supplied definition makes a restatement REACHABLE
## so it can be refused; a formatter that accepted one would make a restatement
## PRINTABLE. The three facts `problem_against()` polices are the category, the
## mode and the unit — not the presentation name — so a supplied record could
## agree on all three and still carry a different name, and the line above would
## have rendered it. The name is therefore read from the vocabulary and from
## nowhere else, which is the only arrangement in which the guarantee this
## section states is actually true.
##
## ONE HONEST LIMIT: the vocabulary's formatter renders whole percents, so a
## magnitude below 0.005 is legal here and displays as "+0%". Every shipped
## magnitude is an exact whole percent, and a resolution rule is a decision this
## foundation does not have.
func effect_line() -> String:
	var record: PlayerStatDefinition = stat_definition()
	if record == null:
		return PlayerStats.format_increased(magnitude)
	return "%s %s" % [PlayerStats.format_increased(magnitude), record.display_name]


## Everything the record declares, as one line. Used for diagnostics; nothing
## reads it back.
func describe() -> String:
	var record: PlayerStatDefinition = stat_definition()
	var derived: String = record.describe() if record != null \
		else "%s is not a recognised player stat" % stat_id
	return "%s (%s) — %s; weight %d; %s — %s" % [
		display_name, card_id, effect_line(), base_weight,
		"repeatable" if repeatable else "once only", derived,
	]
