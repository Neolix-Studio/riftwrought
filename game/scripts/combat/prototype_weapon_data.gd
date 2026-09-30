class_name PrototypeWeaponData
extends Resource
## Prototype Zero — Gate E: one of exactly TWO deterministic prototype weapon
## records (specification §13, decision D-184).
##
## THIS IS NOT THE BEGINNING OF THE ITEM SYSTEM, and the shape of this file is
## deliberately the wrong shape to become one. There is no Base Type, no Item
## Level, no Required Level, no attribute requirement, no rarity, no Implicit, no
## Prefix or Suffix capacity, no affix, no Tier, no conflict group, no Local or
## Global scope, no Wrought Modifier, no Unique mechanic, no procedural roll, no
## crafting Strain, no inventory position, and no equipment slot. A later gate
## that wants any of those has to change this file rather than slip a field in.
##
## The whole of Gate E's item content is two records:
##
##   Prototype Training Sword   100 raw Physical per Quick Strike
##   Prototype Honed Sword      150 raw Physical per Quick Strike
##
## Against the locked 300-Life Graveblade that is exactly the controlled
## three-Hit-to-two-Hit relationship Prototype Zero exists to prove:
##
##   ceil(300 / 100) = 3 Hits
##   ceil(300 / 150) = 2 Hits
##
## Neither record changes attack speed. Quickened Form does, and it is a passive
## rather than an item, which is precisely what keeps the two halves of the
## improvement loop separable when the project owner judges them.

@export_group("Identity")
## The player-facing name, shown in the comparison and in the quiet weapon line.
@export var display_name: String = "Prototype Training Sword"
## A stable identifier for the in-memory lab-progress record. It is NOT a
## database key, an item id, or the start of an item catalogue.
@export var weapon_id: StringName = &"training_sword"
## Prototype Zero is Physical only. There is no damage-type system yet.
@export var damage_type: String = "Physical"

@export_group("Deterministic values")
## Raw Physical damage one released Quick Strike deals. Deterministic: there is
## no minimum, no maximum, no variance, and no roll.
@export var physical_damage: float = 100.0
## Specification §13: BOTH prototype swords are "attack-speed change: none".
## The field exists so the comparison can state "Attack Time 0.80 -> 0.80 s" from
## the records rather than from a hard-coded string, and Gate E asserts that both
## records carry 0.0.
@export var increased_attack_speed: float = 0.0


## Effective Quick Strike action time while this weapon is equipped, under a
## separate passive contribution. The weapon and the passive are added before the
## single ordinary increased-speed division, so there is exactly one place in the
## project where "increased attack speed" becomes a time (specification §12.2).
func effective_action_time(base_action_time: float, passive_increase: float) -> float:
	return base_action_time / (1.0 + maxf(increased_attack_speed + passive_increase, -0.95))


## Hits this weapon needs to defeat a target with `target_life` Life. The
## comparison's "Hits to this Graveblade" line is computed through here from the
## Graveblade's own record, never written down as a literal.
func hits_to_defeat(target_life: float) -> int:
	if physical_damage <= 0.0:
		return 0
	return int(ceil(target_life / physical_damage))


## Returns "" when the record is coherent, or the first problem found. Called on
## ready so a bad edit fails loudly instead of quietly retuning the loop
## (specification §25).
func problem() -> String:
	if display_name.strip_edges().is_empty():
		return "display_name must not be empty"
	if String(weapon_id).strip_edges().is_empty():
		return "weapon_id must not be empty"
	if physical_damage <= 0.0:
		return "physical_damage must be positive"
	if damage_type != "Physical":
		return "Prototype Zero has Physical damage only"
	if not is_zero_approx(increased_attack_speed):
		return "specification §13: neither prototype sword changes attack speed"
	return ""


func describe() -> String:
	return "%s — %.0f raw %s per Quick Strike, no attack-speed change, no other modifiers" % [
		display_name, physical_damage, damage_type,
	]
