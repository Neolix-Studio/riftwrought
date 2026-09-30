class_name FirstMvpDamageEvent
extends DamageEvent
## First-MVP — Gate 1E: a damage record that knows its damage type (D-219).
##
## Prototype Zero was Physical only, and `DamageEvent`'s own header says so
## plainly: "There is no Critical Strike roll, defence, resistance, conversion,
## ailment, Block, Evade, damage variance, or random damage roll, and this class
## is deliberately the wrong shape to grow one quietly." Emberbolt is the first
## Fire Skill in the project, so a Hit now has a type.
##
## THIS EXTENDS RATHER THAN EDITS, and the reason is measured rather than
## cautious. `DamageEvent.physical()` is called directly by `gate_d_verification.gd`
## (seven times), `gate_f_verification.gd` (four), `quick_strike_action.gd`,
## `prototype_graveblade.gd`, and `prototype_player.gd`; `raw_physical_damage`
## and `final_life_damage` are read by all of them. Adding a field to that file
## would work, but subclassing costs nothing and keeps a closed, accepted
## Prototype Zero record byte-identical — the same decision, for the same
## reason, that `FirstMvpWeaponRecord` makes about `PrototypeWeaponData`.
##
## `PrototypeGraveblade.receive_damage(event: DamageEvent)` and
## `PrototypePlayer.receive_damage(event: DamageEvent)` therefore accept one of
## these with no edit at all, and read exactly the fields they always read.
##
## ONE NAMING DEBT, RECORDED RATHER THAN HIDDEN. The inherited field is called
## `raw_physical_damage`, and a Fire Hit stores its raw damage there. Renaming it
## would touch four closed verification suites and both Prototype Zero actors, so
## it keeps its name and `raw_damage()` below is the honest accessor. This is the
## same call the project made when it left `CalibrationHallPlayer` named after a
## hall it no longer only serves.
##
## STILL NOT A DAMAGE PIPELINE. `final_life_damage = raw` remains the whole rule.
## There is no resistance, no mitigation, no conversion, no Critical Strike, no
## ailment, and no variance — every one of those is outside Gate 1E and each
## would have to be added here on purpose.

const PHYSICAL: String = "Physical"
const FIRE: String = "Fire"

## The damage type this Hit dealt. Physical for both Attack foundations; Fire
## for Emberbolt.
var damage_type: String = PHYSICAL


## The one place a first-MVP Skill's Hit becomes a record. `type` must be one of
## the two types the first MVP implements; anything else is a programming error
## rather than a data possibility, so it is asserted rather than clamped.
static func of_type(
	id: int, from: Node, to: Node, raw: float, type: String
) -> FirstMvpDamageEvent:
	assert(type == PHYSICAL or type == FIRE,
		"FirstMvpDamageEvent: the first MVP implements Physical and Fire only, not '%s'" % type)
	var event: FirstMvpDamageEvent = FirstMvpDamageEvent.new()
	event.use_id = id
	event.source = from
	event.target = to
	event.raw_physical_damage = raw
	event.final_life_damage = raw
	event.damage_type = type
	return event


## The raw damage this Hit dealt, whatever its type. Prefer this to reading the
## inherited `raw_physical_damage` in first-MVP code — see the naming note above.
func raw_damage() -> float:
	return raw_physical_damage


func is_fire() -> bool:
	return damage_type == FIRE


func describe() -> String:
	return "use %d: %s -> %s, %.0f raw %s, %.0f Life damage" % [
		use_id, source_name(), target_name(), raw_physical_damage, damage_type, final_life_damage,
	]
