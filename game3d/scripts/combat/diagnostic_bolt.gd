class_name DiagnosticBolt
extends Node3D

## THE ONE DIAGNOSTIC PROJECTILE.
##
## ============================================================================
## THIS IS NOT A SKILL.
## ============================================================================
## `CLAUDE.md` section 3.5 permits exactly ONE explicitly diagnostic,
## non-canonical projectile action, WHICH MUST BE LABELLED DIAGNOSTIC IN THE
## RUNTIME. This is it, and there is exactly one of them.
##
## It is NOT a Huntress Skill. It is NOT the Mage spell (original P1C criterion
## C9, which remains TRANSFERRED to the future Mage art phase and must not be
## attempted here). It is NOT canonical and it defines NO class mechanic.
##
## ITS GEOMETRY IS AN ENGINE PRIMITIVE, ON PURPOSE. Using a real arrow mesh
## would imply archery the corpus cannot animate (0 bow clips of 85) and would
## invite reading a diagnostic as the Huntress's weapon. A glowing capsule
## cannot be mistaken for production art.
##
## Every number it uses is PROVISIONAL.

var direction: Vector3 = Vector3.FORWARD
var travelled: float = 0.0
var alive: bool = true

## Diagnostics the suite reads.
var hit_something: bool = false
var hit_at_distance: float = -1.0
var expired: bool = false
var steps: int = 0

## Recorded AT THE MOMENT OF THE HIT, because the bolt frees itself immediately
## afterwards and a check that reads a freed object reads nothing.
static var last_hit_steps: int = -1
static var last_hit_distance: float = -1.0

var _shape := SphereShape3D.new()

func build(dir: Vector3) -> void:
	direction = dir.normalized()
	direction.y = 0.0
	if direction.length() < 0.001:
		direction = Vector3.FORWARD
	direction = direction.normalized()
	_shape.radius = ProdConfig.BOLT_RADIUS_M

	var mi := MeshInstance3D.new()
	var caps := CapsuleMesh.new()
	caps.radius = 0.09
	caps.height = 0.46
	mi.mesh = caps
	var m := StandardMaterial3D.new()
	m.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	m.albedo_color = ProdConfig.COL_RIFT_VIOLET
	m.emission_enabled = true
	m.emission = ProdConfig.COL_RIFT_VIOLET
	m.emission_energy_multiplier = 3.0
	mi.material_override = m
	# A capsule's long axis is local +Y; lay it along the direction of travel.
	mi.rotation_degrees = Vector3(90, 0, 0)
	var holder := Node3D.new()
	holder.add_child(mi)
	add_child(holder)
	holder.basis = Basis.looking_at(direction, Vector3.UP)

	var l := OmniLight3D.new()
	l.light_color = ProdConfig.COL_RIFT_VIOLET
	l.light_energy = 1.7
	l.omni_range = 3.0
	l.shadow_enabled = false
	add_child(l)

func _physics_process(delta: float) -> void:
	step(delta)

## Separated so the suite can drive exact steps.
func step(delta: float) -> void:
	if not alive:
		return
	steps += 1

	# ========================================================================
	# THE OVERLAP TEST RUNS BEFORE THE MOVE, ON EVERY STEP INCLUDING THE FIRST.
	# ========================================================================
	# This project names the defect explicitly: "a shape query blind to what it
	# already overlaps (point-blank)". A projectile that only tests the segment
	# it swept THIS frame never sees a target it spawned inside, so a shot at an
	# enemy already touching the actor silently misses. Testing the current
	# position first -- before any movement has happened -- is what makes the
	# point-blank case hit, and the suite asserts exactly that case.
	if _test_overlap():
		return

	var move := ProdConfig.BOLT_SPEED_MPS * delta
	global_position += direction * move
	travelled += move
	if travelled >= ProdConfig.BOLT_RANGE_M:
		expired = true
		alive = false
		queue_free()

func _test_overlap() -> bool:
	var space := get_world_3d().direct_space_state
	if space == null:
		return false
	var q := PhysicsShapeQueryParameters3D.new()
	q.shape = _shape
	q.transform = Transform3D(Basis.IDENTITY, global_position)
	q.collision_mask = 2                    # enemies
	q.collide_with_areas = false
	q.collide_with_bodies = true
	var hits := space.intersect_shape(q, 4)
	for h in hits:
		var c = h.get("collider")
		if c == null or not is_instance_valid(c):
			continue
		if c.has_method("receive_damage"):
			c.receive_damage(ProdConfig.BOLT_DAMAGE, global_position)
			hit_something = true
			hit_at_distance = travelled
			last_hit_steps = steps
			last_hit_distance = travelled
			alive = false
			queue_free()
			return true
	return false
