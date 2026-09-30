class_name FirstMvpWeaponRecord
extends PrototypeWeaponData
## First-MVP — Gate 1E: an ordinary authored weapon (D-219).
##
## WHY THIS EXTENDS A PROTOTYPE ZERO RESOURCE, WHICH IS A REAL TENSION AND IS
## RECORDED RATHER THAN GLOSSED OVER.
##
## `PrototypeWeaponData`'s own header says it is "deliberately the wrong shape"
## to become the item system, and that "a later gate that wants any of those has
## to change this file rather than slip a field in." That warning is about
## SLIPPING FIELDS IN — quietly widening the Prototype Zero record until it has
## become an item system nobody decided to build. This class does the opposite:
## the parent file is untouched, still says exactly what it says, and the
## additional fields live in a visible, separately named first-MVP file.
##
## The reason for inheriting rather than starting clean is composition, which is
## this project's standing rule:
##
##   * `PrototypePlayer.weapon` is typed `PrototypeWeaponData`, and
##     `QuickStrikeAction` reads `_player.physical_damage` from it. Inheriting
##     means the proven, accepted, playtested combat kernel is reused
##     COMPLETELY UNMODIFIED with a Foundation weapon equipped. A separate type
##     would need an adapter that builds a `PrototypeWeaponData` per equip, and
##     that adapter is a second place for damage to live.
##   * Gate 1D's `PlayerLoadout` holds `Array[PrototypeWeaponData]` and already
##     implements exactly the owned-versus-equipped idempotence the Gate 1E
##     brief asks to preserve. Inheriting reuses it unedited.
##
## STILL NOT THE ITEM SYSTEM. There is no rarity, no Implicit ROLL, no Prefix or
## Suffix, no affix, no Tier, no conflict group, no Local/Global scope, no
## Wrought Modifier, no Unique mechanic, no procedural generation, no Crafting
## Strain, and no Field Pack position. The brief is explicit that these
## tutorial foundations "may be pre-authored ordinary items", and they are:
## three authored records with fixed numbers.
##
## `implicit_text` is a canonical DESCRIPTION quoted from
## `design/FIRST_MVP_CONTENT_AND_REWARD_CATALOGUE.md` §4.1, displayed truthfully
## as an authored property. It is not an implemented modifier and the comparison
## says so — inventing a mechanical implicit here would be exactly the "affix
## system slipped in" this file exists not to be.

enum Hands {
	ONE_HANDED,
	## Occupies Main Hand AND Off Hand (design/ITEMS_AND_RARITY_STRUCTURE.md).
	TWO_HANDED,
}

@export_group("Base Type")
## The canonical Base Type name, e.g. "Two-Handed Sword".
@export var base_type: String = ""
## The family a Skill's weapon requirement is stated against, e.g. &"two_handed_sword".
@export var weapon_family: StringName = &""
@export var hands: Hands = Hands.ONE_HANDED

@export_group("Item")
## Stable save key. Distinct from `weapon_id`, which the parent uses for the
## Prototype Zero comparison line.
@export var item_id: StringName = &""
@export var item_level: int = 1
@export var required_level: int = 1

@export_group("Authored identity")
## Quoted from FIRST_MVP_CONTENT_AND_REWARD_CATALOGUE.md §4.1. Described, not
## implemented — see the header.
@export var implicit_text: String = ""
@export var identity_line: String = ""


func occupies_off_hand() -> bool:
	return hands == Hands.TWO_HANDED


func hands_name() -> String:
	return "Two-handed" if hands == Hands.TWO_HANDED else "One-handed"


## Overrides the parent's Prototype-Zero-specific validation. The parent refuses
## any non-Physical damage type and any non-zero attack-speed modifier with
## messages that cite Prototype Zero specification §13; neither sentence is true
## of a first-MVP item, so this states the first-MVP rules instead.
##
## Weapon damage stays Physical for all three Foundation weapons, and that is a
## fact about weapons rather than about Skills: a Spell's damage is
## SPELL-DEFINED (design/SKILLS_AND_SKILL_MODIFICATION.md), so the Cantor Wand
## being a Physical-damage object takes nothing away from Emberbolt's Fire.
func problem() -> String:
	if display_name.strip_edges().is_empty():
		return "display_name must not be empty"
	if String(item_id).strip_edges().is_empty():
		return "item_id must not be empty"
	if String(weapon_id).strip_edges().is_empty():
		return "weapon_id must not be empty"
	if base_type.strip_edges().is_empty():
		return "%s: base_type must not be empty" % item_id
	if String(weapon_family).strip_edges().is_empty():
		return "%s: weapon_family must not be empty" % item_id
	if physical_damage <= 0.0:
		return "%s: physical_damage must be positive" % item_id
	if damage_type != "Physical":
		return "%s: weapon damage in the first MVP is Physical; Spell damage is Skill-defined" % item_id
	if item_level < 1:
		return "%s: item_level must be 1 or greater" % item_id
	if required_level < 1:
		return "%s: required_level must be 1 or greater" % item_id
	if implicit_text.strip_edges().is_empty():
		return "%s: implicit_text must quote the catalogue entry" % item_id
	return ""


func describe() -> String:
	return "%s — %s (%s), %.0f raw %s, Item Level %d, requires Level %d" % [
		display_name, base_type, hands_name().to_lower(), physical_damage, damage_type,
		item_level, required_level,
	]
