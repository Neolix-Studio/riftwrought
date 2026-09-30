class_name PassiveCardCatalogue
extends RefCounted
## Riftwrought — Roguelite Foundation C2: the six review passive cards, as
## records (decision D-231).
##
## WHAT THIS FILE IS. Six authored records, one per stat in the accepted
## vocabulary, plus the rules that decide whether a set of records is a coherent
## catalogue. That is all it is. NOTHING SELECTS FROM IT, nothing offers a card
## from it, nothing displays one and nothing applies one — there is no selector,
## no offer generator, no pool, no draw, no run state and no application
## anywhere in this foundation, and the verification proves each of those
## absences rather than promising them.
##
## THE SIX REVIEW PASSIVES:
##
##   Power       +10% Global Damage
##   Celerity    +10% Skill Speed
##   Vitality    +15% Maximum Life
##   Fleetness   +10% Movement Speed
##   Insight     +10% Experience Gain
##   Magnetism   +25% Pickup Radius
##
## ONE CARD PER STAT, WHICH IS A REVIEW SHAPE RATHER THAN A DESIGN RULE. Six
## stats and six cards is the smallest catalogue that can prove every stat is
## reachable from a card and that every card resolves to a real stat, in both
## directions. Nothing here says a stat may have only one card, and nothing here
## says every stat must have one.
##
## THE IDS ARE DELIBERATELY NOT THE NAMES. `card_power` is not "Power", and the
## difference is not cosmetic: an id is a mechanical identity that must never
## change once anything can hold one, while a name is copy that should be free to
## change without invalidating a stored record. Deriving one from the other is
## how those two facts get welded together, so they are separate strings and the
## verification asserts they never coincide.
##
## THE SIX NAMES ARE ACCEPTED AS GREYBOX REVIEW LABELS, NOT AS FINAL COPY
## (D-232). Power, Celerity, Vitality, Fleetness, Insight and Magnetism are
## approved for this review at exactly that level. **The stable ids remain the
## authoritative identity**, and any of the six labels may be renamed later
## WITHOUT A MIGRATION — which is only true because nothing keys on a name: the
## id is what a record, a lookup and any future store hold, and the six ids
## obey the enforced `lower_snake_case` contract.
##
## THE SIX WEIGHTS ARE EQUAL ON PURPOSE. A weight says how often a future offer
## should reach for a card; it says nothing about whether the card is legal or
## what it does. The six shipped values are EQUAL so that a catalogue does not
## arrive already preferring one card over another — a foundation that shipped a
## preference would be shipping a balance opinion inside a mechanism. The value
## 100 is a round base to express a later preference against; a card judged twice
## as likely would be written 200, and the number carries no other meaning.
## **These are review weights, not final balance**, and weighted selection is
## deliberately not implemented here.
##
## ALL SIX ARE REPEATABLE FOR THIS REVIEW, AND THAT RECORDS AN INTENT RATHER
## THAN A MECHANISM. `repeatable` says the same card may be taken more than
## once. It does NOT say what happens when it is: there is no stacking
## arithmetic, no stack cap, no diminishing return, no rarity tier and no
## already-held rule in this foundation. Those are balance decisions, they are
## deferred, and the flag is honest about being only a flag.
##
## THE MAGNITUDES ARE NORMALIZED AND THE ODD ONES OUT ARE ODD ON PURPOSE.
## 0.10 is +10%. Vitality is 0.15 and Magnetism is 0.25 because a review
## catalogue in which every number is identical cannot show that a magnitude is
## carried per card rather than assumed — and because the vocabulary's own
## record already states that doubling a pickup radius quadruples the ground it
## covers, so a radius card wants a visibly different step from a damage card.
## **They are review magnitudes, not final balance.**
##
## THE CATEGORY, THE MODE AND THE UNIT APPEAR NOWHERE IN THIS FILE. Every record
## below names a stat and lets the vocabulary answer for the rest. That is why
## Celerity — the one card whose stat DIVIDES rather than multiplies — reads
## exactly like the other five here: the difference lives in the vocabulary,
## where it is declared once.
##
## IT IS INERT. No node, no signal, no clock, no random source, no file, no
## selection and no application.

# --- The six stable identifiers ------------------------------------------------
#
# snake_case, mechanical, never displayed, and deliberately distinct from the
# presentation names beside them.

const POWER_ID: StringName = &"card_power"
const CELERITY_ID: StringName = &"card_celerity"
const VITALITY_ID: StringName = &"card_vitality"
const FLEETNESS_ID: StringName = &"card_fleetness"
const INSIGHT_ID: StringName = &"card_insight"
const MAGNETISM_ID: StringName = &"card_magnetism"

# --- The six presentation names ------------------------------------------------

const POWER_NAME: String = "Power"
const CELERITY_NAME: String = "Celerity"
const VITALITY_NAME: String = "Vitality"
const FLEETNESS_NAME: String = "Fleetness"
const INSIGHT_NAME: String = "Insight"
const MAGNETISM_NAME: String = "Magnetism"

# --- The six normalized magnitudes ---------------------------------------------
#
# 0.10 is +10%. Review values, not final balance.

const POWER_MAGNITUDE: float = 0.10
const CELERITY_MAGNITUDE: float = 0.10
const VITALITY_MAGNITUDE: float = 0.15
const FLEETNESS_MAGNITUDE: float = 0.10
const INSIGHT_MAGNITUDE: float = 0.10
const MAGNETISM_MAGNITUDE: float = 0.25

## The one base offer weight every review card carries. Written once rather than
## six times, so "the six are equal" is a property of the file instead of a
## coincidence six separate constants would have to keep agreeing on.
const REVIEW_BASE_WEIGHT: int = 100

## Every review card is repeatable. Written once, for the same reason.
const REVIEW_REPEATABLE: bool = true

## Every card, in the canonical reading order this catalogue is declared in.
## Every list this file emits uses this order, so two callers can never disagree
## about which card comes first.
const ALL: Array[StringName] = [
	POWER_ID, CELERITY_ID, VITALITY_ID,
	FLEETNESS_ID, INSIGHT_ID, MAGNETISM_ID,
]


## The six records, built fresh on every call so a caller cannot alter the
## catalogue through a reference it was only given to read.
##
## Each record names a STAT and stops. The category, the arithmetic mode and the
## unit are the vocabulary's to answer, and there is no argument here they could
## be written into.
static func records() -> Array[PassiveCardDefinition]:
	var out: Array[PassiveCardDefinition] = []

	out.append(PassiveCardDefinition.of(
		POWER_ID, POWER_NAME, PlayerStats.GLOBAL_DAMAGE,
		POWER_MAGNITUDE, REVIEW_BASE_WEIGHT, REVIEW_REPEATABLE
	))

	out.append(PassiveCardDefinition.of(
		CELERITY_ID, CELERITY_NAME, PlayerStats.SKILL_SPEED,
		CELERITY_MAGNITUDE, REVIEW_BASE_WEIGHT, REVIEW_REPEATABLE
	))

	out.append(PassiveCardDefinition.of(
		VITALITY_ID, VITALITY_NAME, PlayerStats.MAXIMUM_LIFE,
		VITALITY_MAGNITUDE, REVIEW_BASE_WEIGHT, REVIEW_REPEATABLE
	))

	out.append(PassiveCardDefinition.of(
		FLEETNESS_ID, FLEETNESS_NAME, PlayerStats.MOVEMENT_SPEED,
		FLEETNESS_MAGNITUDE, REVIEW_BASE_WEIGHT, REVIEW_REPEATABLE
	))

	out.append(PassiveCardDefinition.of(
		INSIGHT_ID, INSIGHT_NAME, PlayerStats.EXPERIENCE_GAIN,
		INSIGHT_MAGNITUDE, REVIEW_BASE_WEIGHT, REVIEW_REPEATABLE
	))

	out.append(PassiveCardDefinition.of(
		MAGNETISM_ID, MAGNETISM_NAME, PlayerStats.PICKUP_RADIUS,
		MAGNETISM_MAGNITUDE, REVIEW_BASE_WEIGHT, REVIEW_REPEATABLE
	))

	return out


static func is_known(card_id: StringName) -> bool:
	return ALL.has(card_id)


## The record for `card_id`, or null when the catalogue does not hold it. Null
## rather than a placeholder: a card that does not exist must not be quietly
## given a default magnitude.
static func record(card_id: StringName) -> PassiveCardDefinition:
	for candidate: PassiveCardDefinition in records():
		if candidate.card_id == card_id:
			return candidate
	return null


# --- Catalogue integrity -------------------------------------------------------

## Every problem with the shipped catalogue, or an empty array. A whole list
## rather than a first problem, because a catalogue is validated once and a
## reader wants every fault at once rather than one per run.
static func problems() -> PackedStringArray:
	return problems_in(records())


## The same rules, over an ARBITRARY set of records.
##
## IT TAKES A SET SO THAT A BROKEN ONE CAN ACTUALLY REACH IT. The shipped six
## are built from the constants above and are therefore complete, so a
## missing-record or duplicate-id refusal that only `problems()` could deliver
## would be a guard nothing can reach. `ALL` is the expected review set, so a
## candidate is measured against it in BOTH directions: a record that is absent
## is reported, and so is one that does not belong.
static func problems_in(candidate: Array[PassiveCardDefinition]) -> PackedStringArray:
	var found: PackedStringArray = PackedStringArray()
	var seen: Array[StringName] = []
	for entry: PassiveCardDefinition in candidate:
		if entry == null:
			found.append("the catalogue holds an empty record")
			continue
		var entry_problem: String = entry.problem()
		if not entry_problem.is_empty():
			found.append(entry_problem)
		if seen.has(entry.card_id):
			found.append("duplicate card id %s" % _named(entry.card_id))
		seen.append(entry.card_id)
		if not ALL.has(entry.card_id):
			found.append("%s is defined but is not one of the six review cards"
				% _named(entry.card_id))
	for card_id: StringName in ALL:
		if not seen.has(card_id):
			found.append("%s is a review card but the catalogue does not hold it" % card_id)
	if candidate.size() != ALL.size():
		found.append("%d records against %d review cards" % [candidate.size(), ALL.size()])
	return found


# --- Presentation --------------------------------------------------------------
#
# Deliberately separate from the records and the validation above, and reached by
# nothing in either.

## The six factual descriptions — `+10% Movement Speed` and its five siblings —
## in canonical order. Every one is derived: the percentage from the
## vocabulary's own formatter, the stat name from the referenced definition.
static func effect_lines() -> PackedStringArray:
	var out: PackedStringArray = PackedStringArray()
	for entry: PassiveCardDefinition in records():
		out.append(entry.effect_line())
	return out


static func lines() -> PackedStringArray:
	var out: PackedStringArray = PackedStringArray()
	for entry: PassiveCardDefinition in records():
		out.append(entry.describe())
	return out


# --- Internals -----------------------------------------------------------------

## An empty id reads as nothing at all inside a refusal, which makes the reason
## unreadable exactly when it matters most.
static func _named(card_id: StringName) -> String:
	var text: String = String(card_id)
	return text if not text.strip_edges().is_empty() else "<an unnamed card>"
