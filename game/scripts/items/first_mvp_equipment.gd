class_name FirstMvpEquipment
extends PlayerLoadout
## First-MVP — Gate 1E: equipment SLOTS on top of Gate 1D's proven ownership (D-219).
##
## Gate 1D's `PlayerLoadout` already draws the one line that matters and the
## Gate 1E brief asks to preserve: `owned_items` (what the character carries) is
## distinct from `equipped_weapon` (what a Skill actually swings), `pick_up()`
## only ever adds to the first, `equip()` is the only thing that changes the
## second and refuses an unowned record. None of that is re-implemented here —
## this class EXTENDS it, so every idempotence rule and refusal counter Gate 1D
## proved still runs unchanged.
##
## What Gate 1E adds is the one thing the brief names that Gate 1D had no reason
## to have: SLOTS, and specifically a two-handed weapon occupying Main Hand and
## Off Hand together (design/ITEMS_AND_RARITY_STRUCTURE.md, and the brief:
## "two-handed weapons occupy Main Hand + Off Hand capacity where applicable").
##
## THE MAIN HAND IS `equipped_weapon`, NOT A SECOND FIELD. A parallel
## `main_hand` variable would be a second source of truth that could disagree
## with the parent's, which is exactly how "the comparison says one thing and
## the swing does another" bugs happen. `main_hand()` reads the parent.
##
## DISPLACED EQUIPMENT IS NEVER DESTROYED — the brief: "Do not destroy the
## Watchsteel Sword when a Foundation weapon is equipped ... displaced equipment
## moves safely into owned item storage." That is already true by construction
## rather than by a rule that has to be remembered: `equip()` only reassigns
## which owned record `equipped_weapon` points at, and nothing anywhere removes
## from `owned_items`. `displaced_by_equipping()` names it explicitly so the
## interface can say so before the player commits.
##
## OFF HAND HOLDS NOTHING IN GATE 1E. No shield, no quiver, no dual wield — the
## first MVP has no off-hand item yet and dual wield is outside it entirely. The
## slot exists so the two-handed rule is a real, testable property rather than a
## sentence in a document, and `off_hand_occupant()` answers truthfully.
##
## STILL NOT THE FIELD PACK. No 6x6 grid, no cell position, no rotation, no
## stack, no rarity frame, no Favorite, no Mark for Salvage, no Vault, no
## Recovery Cache. Those are the canonical inventory and each is outside Gate 1E.

enum Slot {
	MAIN_HAND,
	OFF_HAND,
}


func main_hand() -> PrototypeWeaponData:
	return equipped_weapon


## The record occupying the Off Hand. In Gate 1E that is either nothing, or the
## two-handed weapon in the Main Hand — never an independent item.
func off_hand_occupant() -> PrototypeWeaponData:
	var record: FirstMvpWeaponRecord = equipped_weapon as FirstMvpWeaponRecord
	if record != null and record.occupies_off_hand():
		return record
	return null


func off_hand_is_blocked() -> bool:
	return off_hand_occupant() != null


func off_hand_reason() -> String:
	var record: FirstMvpWeaponRecord = off_hand_occupant() as FirstMvpWeaponRecord
	if record == null:
		return "Empty"
	return "%s (two-handed, occupies both hands)" % record.display_name


## What equipping `record` would displace, WITHOUT changing anything. Returns
## null when nothing is equipped yet or the record is already equipped.
func displaced_by_equipping(record: PrototypeWeaponData) -> PrototypeWeaponData:
	if record == null or record == equipped_weapon:
		return null
	return equipped_weapon


## True when the character meets `record`'s Level requirement. An ordinary
## authored record with `required_level` 1 is always satisfiable at the
## canonical starting Level.
func meets_requirements(record: PrototypeWeaponData, character_level: int) -> bool:
	var typed: FirstMvpWeaponRecord = record as FirstMvpWeaponRecord
	if typed == null:
		return true
	return character_level >= typed.required_level


func requirement_line(record: PrototypeWeaponData) -> String:
	var typed: FirstMvpWeaponRecord = record as FirstMvpWeaponRecord
	if typed == null:
		return "No requirement"
	return "Requires Level %d" % typed.required_level


## The weapon family the equipped record belongs to, which is what a Skill's
## weapon requirement is answered against. Prototype Zero's own two records
## carry no family; they are the canonical one-handed sword the player starts
## with, so they answer as such rather than as "unknown" — a `null` family here
## would disable Quick Strike on the starting weapon, which would be wrong.
func equipped_family() -> StringName:
	var typed: FirstMvpWeaponRecord = equipped_weapon as FirstMvpWeaponRecord
	if typed != null:
		return typed.weapon_family
	return FirstMvpSkillData.FAMILY_ONE_HANDED_SWORD


func equipped_record() -> FirstMvpWeaponRecord:
	return equipped_weapon as FirstMvpWeaponRecord


## Every owned record, in ownership order. A stable order matters because the
## save writes item ids in it and the interface lists them in it.
func owned_ids() -> Array[StringName]:
	var ids: Array[StringName] = []
	for record: PrototypeWeaponData in owned_items:
		var typed: FirstMvpWeaponRecord = record as FirstMvpWeaponRecord
		ids.append(typed.item_id if typed != null else record.weapon_id)
	return ids


func find_owned(item_id: StringName) -> PrototypeWeaponData:
	for record: PrototypeWeaponData in owned_items:
		var typed: FirstMvpWeaponRecord = record as FirstMvpWeaponRecord
		var id: StringName = typed.item_id if typed != null else record.weapon_id
		if id == item_id:
			return record
	return null


func describe_slots() -> String:
	return "Main Hand: %s · Off Hand: %s" % [
		equipped_weapon.display_name if equipped_weapon != null else "Empty", off_hand_reason(),
	]
