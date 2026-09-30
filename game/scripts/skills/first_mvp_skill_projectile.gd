class_name FirstMvpSkillProjectile
extends Area3D
## First-MVP — Gate 1E: the one reusable projectile (D-219).
##
## ONE FILE FOR BOTH PROJECTILE SKILLS. Splinter Shot is a Physical Projectile
## Attack and Emberbolt is a Fire Projectile Spell, and the ONLY differences
## between them here are the damage number, the damage type, and the colour —
## all three read from the `FirstMvpSkillData` record that spawned it. That is
## the whole point of the brief's "reusable production contracts for ...
## projectile creation": a third projectile Skill is a record, not a file.
##
## PHYSICS LAYERS, chosen against a closed-gate assertion rather than for
## convenience. `PrototypePlayer.collision_mask = 9` deliberately EXCLUDES the
## target layer so a target area can never change a Gate B locomotion result,
## and Gates C, D and E each assert `player.collision_mask & TARGET_MASK == 0`.
## A projectile therefore gets its OWN body: `collision_layer = 0` (nothing
## collides with it) and `collision_mask = WORLD | TARGET` (it detects walls and
## enemies). It is on no layer at all, so it cannot enter a navigation bake, be
## picked by the cursor ray, be found by a soft-target cone, or block movement.
##
## IT MOVES ON PHYSICS FRAMES AND SWEEPS RATHER THAN SAMPLES. At 26 m/s and 60 Hz
## a projectile advances 0.43 m per step, and a 0.80 m-wide Graveblade sampled
## once per step would be missed roughly half the time from the side. Each step
## therefore performs a shape sweep along the segment it is about to travel and
## resolves at the FIRST thing it meets — the same "exact arithmetic, not a
## sampler" lesson Gate 1C learned when a 5 cm width probe under-reported an
## 8.000 m breach.
##
## EXACTLY ONE HIT PER PROJECTILE. Baseline is one projectile that resolves once
## and stops. Pierce, Chain, Return, Fork, and additional projectiles are
## Augments and every one of them is outside Gate 1E; the brief names them
## individually. `_resolved` is a real boolean rather than an assert, because
## `assert()` is stripped in release builds.
##
## RANGE IS BOUNDED BY WHAT THE PLAYER CAN SEE. The accepted 19 m / 55 deg /
## 45 deg camera shows ground from 7.448 m behind the body to 13.532 m ahead of
## it (Gate 1C report §8.1), so a projectile whose range exceeded that would fly
## at things off the top of the frame. Both records stay inside it.

const WORLD_MASK: int = 1
const TARGET_MASK: int = 4

var data: FirstMvpSkillData
var shooter: Node = null
var use_id: int = 0
var damage: float = 0.0
var direction: Vector3 = Vector3.FORWARD

var travelled: float = 0.0
var resolved: bool = false
var resolution: String = "in flight"

var _visual: MeshInstance3D
var _material: StandardMaterial3D
var _log: Callable = Callable()

## Emitted exactly once, whether the projectile hit something or expired.
signal finished(outcome: Dictionary)

const PHYSICAL_COLOUR: Color = Color(0.86, 0.85, 0.80)
const FIRE_COLOUR: Color = Color(1.00, 0.52, 0.18)


func setup(
	record: FirstMvpSkillData, from: Node, id: int, aim: Vector3, hit_damage: float,
	log_sink: Callable = Callable()
) -> void:
	data = record
	shooter = from
	use_id = id
	damage = hit_damage
	direction = Vector3(aim.x, 0.0, aim.z).normalized()
	_log = log_sink


func _ready() -> void:
	collision_layer = 0
	collision_mask = WORLD_MASK | TARGET_MASK
	monitoring = false
	monitorable = false
	_build_visual()


func _build_visual() -> void:
	_visual = MeshInstance3D.new()
	_visual.name = "Bolt"
	var capsule: CapsuleMesh = CapsuleMesh.new()
	capsule.radius = data.projectile_radius if data != null else 0.22
	capsule.height = capsule.radius * 4.0
	capsule.radial_segments = 8
	capsule.rings = 2
	_visual.mesh = capsule
	_material = StandardMaterial3D.new()
	_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	var colour: Color = FIRE_COLOUR if (data != null and data.damage_type == "Fire") else PHYSICAL_COLOUR
	_material.albedo_color = colour
	_visual.material_override = _material
	_visual.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	# Lie the capsule along travel rather than along its own +Y axis.
	_visual.rotation_degrees = Vector3(90.0, 0.0, 0.0)
	add_child(_visual)
	look_at_direction()


func look_at_direction() -> void:
	if direction.length() < 0.0001:
		return
	rotation = Vector3(0.0, atan2(direction.x, direction.z), 0.0)


func _physics_process(delta: float) -> void:
	if resolved:
		return
	var step: float = data.projectile_speed * delta
	var remaining: float = data.projectile_range - travelled
	if step >= remaining:
		step = remaining
	var from: Vector3 = global_position
	var to: Vector3 = from + direction * step
	var struck: Dictionary = _sweep(from, to)
	if not struck.is_empty():
		global_position = struck["point"]
		_resolve_on(struck)
		return
	global_position = to
	travelled += step
	if travelled >= data.projectile_range - 0.0001:
		_expire()


## Sweeps the projectile's own sphere along the segment and returns the FIRST
## thing it meets, preferring a target over a wall at the same distance so a
## Graveblade standing against a wall is still hit.
func _sweep(from: Vector3, to: Vector3) -> Dictionary:
	var space: PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
	var shape: SphereShape3D = SphereShape3D.new()
	shape.radius = data.projectile_radius
	var query: PhysicsShapeQueryParameters3D = PhysicsShapeQueryParameters3D.new()
	query.shape = shape
	query.transform = Transform3D(Basis.IDENTITY, from)
	query.collision_mask = WORLD_MASK | TARGET_MASK
	query.collide_with_areas = true
	query.collide_with_bodies = true
	if shooter is CollisionObject3D:
		query.exclude = [(shooter as CollisionObject3D).get_rid()]
	# The start-overlap test below runs with NO motion; the sweep sets it after.
	query.motion = Vector3.ZERO
	# CAST_MOTION IS BLIND TO WHAT THE SHAPE ALREADY OVERLAPS AT ITS START.
	# It answers "how far can this shape travel before it first touches
	# something", and a shape that is ALREADY touching something reports a safe
	# fraction of 1.0 — indistinguishable from a clear path. A point-blank shot,
	# or one launched with a Graveblade or a wall already inside the 0.20 m
	# muzzle sphere, would therefore fly straight through it.
	#
	# So the start position is queried FIRST, with the same "what is actually
	# there" intersect the contact resolution below already uses.
	var at_start: Array[Dictionary] = space.intersect_shape(query, 8)
	if not at_start.is_empty():
		var immediate: Dictionary = _classify(at_start)
		if not immediate.is_empty():
			immediate["point"] = from
			return immediate

	query.motion = to - from
	var fraction: PackedFloat32Array = space.cast_motion(query)
	if fraction.is_empty():
		return {}
	var safe: float = fraction[0]
	if safe >= 1.0:
		return {}
	var contact: Vector3 = from + (to - from) * safe
	# Ask what is actually there at the contact position.
	query.transform = Transform3D(Basis.IDENTITY, contact + (to - from).normalized() * 0.01)
	query.motion = Vector3.ZERO
	var hits: Array[Dictionary] = space.intersect_shape(query, 8)
	# Named `outcome` rather than `resolved`, which is a member of this class.
	var outcome: Dictionary = _classify(hits)
	if outcome.is_empty():
		return {}
	outcome["point"] = contact
	return outcome


## Turns a set of overlaps into a resolution, preferring a valid target over a
## wall at the same place so a Graveblade standing against stone is still hit.
## Returns {} when nothing here resolves the projectile.
func _classify(hits: Array[Dictionary]) -> Dictionary:
	var targetable: PrototypeTargetable = null
	var wall: bool = false
	for hit: Dictionary in hits:
		var collider: Object = hit.get("collider")
		var area: PrototypeTargetable = collider as PrototypeTargetable
		if area != null and area.is_valid_target():
			targetable = area
			break
		if collider is CollisionObject3D:
			var body: CollisionObject3D = collider as CollisionObject3D
			if (body.collision_layer & WORLD_MASK) != 0:
				wall = true
	if targetable == null and not wall:
		return {}
	return {"target": targetable, "wall": wall}


func _resolve_on(struck: Dictionary) -> void:
	resolved = true
	var target: PrototypeTargetable = struck.get("target", null) as PrototypeTargetable
	var outcome: Dictionary = {
		"use_id": use_id, "travelled": travelled, "target": target,
		"damage": 0.0, "damage_type": data.damage_type,
	}
	if target != null:
		target.note_release(use_id)
		var actor: Node = target.combat_actor()
		if actor != null:
			var event: FirstMvpDamageEvent = FirstMvpDamageEvent.of_type(
				use_id, shooter, actor, damage, data.damage_type
			)
			outcome["event"] = event
			outcome["damage"] = damage
			actor.call("receive_damage", event)
			resolution = "hit %s for %.0f %s" % [
				target.target_display_name(), damage, data.damage_type,
			]
		else:
			resolution = "struck %s, which has no Life" % target.target_display_name()
	else:
		resolution = "struck the world after %.2f m" % travelled
	outcome["resolution"] = resolution
	_emit(outcome)


func _expire() -> void:
	resolved = true
	resolution = "expired at its %.2f m range" % data.projectile_range
	_emit({
		"use_id": use_id, "travelled": travelled, "target": null, "damage": 0.0,
		"damage_type": data.damage_type, "resolution": resolution,
	})


func _emit(outcome: Dictionary) -> void:
	if _log.is_valid():
		_log.call("%s projectile" % data.display_name.to_lower(), resolution)
	finished.emit(outcome)
	queue_free()
