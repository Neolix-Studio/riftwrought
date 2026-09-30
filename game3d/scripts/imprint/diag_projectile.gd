class_name DiagProjectile
extends Node3D

## THE REUSABLE DIAGNOSTIC PROJECTILE — one framework, consumed by TWO Skills.
##
## ============================================================================
## THIS IS NOT A SKILL, AND IT IS NOT THE FOUNDATION'S DIAGNOSTIC BOLT EITHER.
## ============================================================================
## The accepted `DiagnosticBolt` is UNCHANGED and untouched by this stage: it is
## the ONE diagnostic action the foundation declares, and `F51` still asserts
## exactly one of it.
##
## This is a SEPARATE projectile belonging to the D-375 Imprint stage, and it
## exists because the ruling requires a projectile whose COUNT and BEHAVIOUR are
## driven by Augment Imprints. Its spec comes from
## `SkillConfiguration.resolve()`, so the bow Skill and the ballista both fire
## the same implementation with different numbers -- which is the "one reusable
## behavior should serve every compatible Skill" rule, made real.
##
## ---------------------------------------------------------------------------
## THE OVERLAP TEST RUNS BEFORE THE MOVE, ON EVERY STEP INCLUDING THE FIRST.
## ---------------------------------------------------------------------------
## The project names this defect explicitly -- "a shape query blind to what it
## already overlaps (point-blank)" -- and the accepted bolt already solved it.
## THE SAME MISTAKE WOULD RECUR VERBATIM IN A SECOND PROJECTILE, so the technique
## is reused and declared, and the suite asserts the point-blank case here too.
##
## ---------------------------------------------------------------------------
## FORKING IS BOUNDED, AND THE BOUND IS THE POINT.
## ---------------------------------------------------------------------------
## Canon forbids a rule that can activate itself or "create an infinite event
## chain by default". A fork is the same shape of failure as a self-triggering
## trigger, so `generation` is compared against a maximum before a child is ever
## created, and the child is given the parent's victim in its EXCLUDE list so it
## cannot immediately re-hit what the parent just hit.
##
## EVERY NUMBER IT USES IS PROVISIONAL.

var direction: Vector3 = Vector3.FORWARD
var damage: float = 1.0
var speed: float = ImprintConfig.STORM_PROJECTILE_SPEED
var max_range: float = ImprintConfig.STORM_PROJECTILE_RANGE
var radius: float = ImprintConfig.STORM_PROJECTILE_RADIUS
var tint: Color = ImprintConfig.COL_STORM

## Forking, from the resolved Configuration.
var fork_children: int = 0
var fork_generations: int = 0
var fork_fraction: float = 0.0
var generation: int = 0

## Which Skill Configuration fired it, and which damage source it counts as.
## The ledger needs the source to answer "bow damage versus beast damage".
var source_label: String = "player_direct"
var origin_configuration: String = ""

var travelled: float = 0.0
var alive: bool = true
var steps: int = 0
var hit_something: bool = false

var _exclude: Array = []
var _shape := SphereShape3D.new()

## Diagnostics the suite reads. Static, because a projectile frees itself the
## instant it lands and a check that reads a freed object reads nothing.
static var spawned_total: int = 0
static var forks_spawned_total: int = 0
static var hits_total: int = 0
static var deepest_generation: int = 0

static func reset_counters() -> void:
	spawned_total = 0
	forks_spawned_total = 0
	hits_total = 0
	deepest_generation = 0

func build(dir: Vector3) -> void:
	direction = dir
	direction.y = 0.0
	if direction.length() < 0.001:
		direction = Vector3.FORWARD
	direction = direction.normalized()
	_shape.radius = radius
	spawned_total += 1
	deepest_generation = maxi(deepest_generation, generation)

	var mi := MeshInstance3D.new()
	var caps := CapsuleMesh.new()
	caps.radius = 0.075
	caps.height = 0.52
	mi.mesh = caps
	var m := StandardMaterial3D.new()
	m.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	m.albedo_color = tint
	m.emission_enabled = true
	m.emission = tint
	m.emission_energy_multiplier = 3.4
	mi.material_override = m
	mi.rotation_degrees = Vector3(90, 0, 0)
	var holder := Node3D.new()
	holder.add_child(mi)
	add_child(holder)
	holder.basis = Basis.looking_at(direction, Vector3.UP)

	var l := OmniLight3D.new()
	l.light_color = tint
	l.light_energy = 1.4
	l.omni_range = 2.6
	l.shadow_enabled = false
	add_child(l)

func exclude_body(rid: RID) -> void:
	if rid.is_valid():
		_exclude.append(rid)

func _physics_process(delta: float) -> void:
	step(delta)

## Separated so the suite can drive exact steps.
func step(delta: float) -> void:
	if not alive:
		return
	steps += 1
	# THE OVERLAP TEST FIRST, BEFORE ANY MOVEMENT HAS HAPPENED.
	if _test_overlap():
		return
	var move := speed * delta
	global_position += direction * move
	travelled += move
	global_position.y = maxf(0.6, global_position.y)
	if travelled >= max_range:
		alive = false
		queue_free()

func _test_overlap() -> bool:
	var space := get_world_3d().direct_space_state
	if space == null:
		return false
	var q := PhysicsShapeQueryParameters3D.new()
	q.shape = _shape
	q.transform = Transform3D(Basis.IDENTITY, global_position)
	q.collision_mask = 2                    # enemies only
	q.collide_with_areas = false
	q.collide_with_bodies = true
	q.exclude = _exclude
	for h in space.intersect_shape(q, 4):
		var c = h.get("collider")
		if c == null or not is_instance_valid(c):
			continue
		if not c.has_method("receive_damage"):
			continue
		c.receive_damage(damage, global_position)
		SkillRuntime.record_damage(source_label, damage, origin_configuration)
		hit_something = true
		hits_total += 1
		_spawn_forks(c)
		alive = false
		queue_free()
		return true
	return false

## ============================================================================
## THE FORK. BOUNDED BEFORE A CHILD EXISTS, NEVER AFTER.
## ============================================================================
func _spawn_forks(victim: Node) -> void:
	if fork_children <= 0 or generation >= fork_generations:
		return
	var parent := get_parent()
	if parent == null:
		return
	var vrid := RID()
	if victim is CollisionObject3D:
		vrid = (victim as CollisionObject3D).get_rid()
	for k in fork_children:
		var side: float = -1.0 if k % 2 == 0 else 1.0
		var spread: float = ImprintConfig.FORK_ANGLE_DEG * side \
			* (1.0 + floor(float(k) / 2.0) * 0.5)
		var d := direction.rotated(Vector3.UP, deg_to_rad(spread))
		var child := DiagProjectile.new()
		child.damage = damage * fork_fraction
		child.speed = speed
		child.max_range = max_range * 0.62
		child.radius = radius
		child.tint = tint
		child.fork_children = fork_children
		child.fork_generations = fork_generations
		child.fork_fraction = fork_fraction
		child.generation = generation + 1
		child.source_label = source_label
		child.origin_configuration = origin_configuration
		parent.add_child(child)
		child.build(d)
		# IT MUST NOT RE-HIT WHAT ITS PARENT JUST HIT.
		child.exclude_body(vrid)
		child.global_position = global_position + d * 0.35
		forks_spawned_total += 1
