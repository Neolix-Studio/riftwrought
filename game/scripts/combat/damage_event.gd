class_name DamageEvent
extends RefCounted
## Prototype Zero — the minimal damage record (specification §12.3).
##
## The whole contract, verbatim from the specification:
##
##     DamageEvent
##         use_id
##         source
##         target
##         raw_physical_damage
##         final_life_damage
##
##     For Prototype Zero:  final_life_damage = raw_physical_damage
##
## There is no Critical Strike roll, defence, resistance, conversion, ailment,
## Block, Evade, damage variance, or random damage roll, and this class is
## deliberately the wrong shape to grow one quietly: the only constructor states
## the Physical rule in one place, so a later gate that wants a pipeline has to
## change this file rather than slip a coefficient in somewhere.
##
## It is a plain record. It applies nothing and knows nothing about Life; the
## actor that receives it owns that.

## The attacker's stable Skill Use / attack-use identifier. One use produces at
## most one DamageEvent, which is what makes duplicate detection possible.
var use_id: int = 0
var source: Node = null
var target: Node = null
var raw_physical_damage: float = 0.0
var final_life_damage: float = 0.0


## The one place the Prototype Zero rule `final = raw` is written down.
static func physical(id: int, from: Node, to: Node, raw: float) -> DamageEvent:
	var event: DamageEvent = DamageEvent.new()
	event.use_id = id
	event.source = from
	event.target = to
	event.raw_physical_damage = raw
	event.final_life_damage = raw
	return event


func source_name() -> String:
	return source.name if source != null else "unknown"


func target_name() -> String:
	return target.name if target != null else "unknown"


func describe() -> String:
	return "use %d: %s -> %s, %.0f raw Physical, %.0f Life damage" % [
		use_id, source_name(), target_name(), raw_physical_damage, final_life_damage,
	]
