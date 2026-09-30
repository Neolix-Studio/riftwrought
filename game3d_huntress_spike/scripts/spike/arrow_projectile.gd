class_name ArrowProjectile
extends Node3D

## THE DIAGNOSTIC ARROW — one per released use, and no other.
##
## ============================================================================
## NOT A SKILL. NOT SPLINTER SHOT. NO IMPORTED EFFECT.
## ============================================================================
## Its body is the authorized `Arrow.obj`, scaled to the arrow the visual had
## nocked. Its TRAIL and its IMPACT are generated here from engine primitives --
## an ImmediateMesh ribbon and a torus-and-sphere flash -- because the ruling
## says: "Do not use BattleFX ... adapting a melee effect would answer the wrong
## question." Nothing here loads a shader, texture or particle resource.
##
## ---------------------------------------------------------------------------
## THE ACCEPTED POINT-BLANK RULE, CARRIED
## ---------------------------------------------------------------------------
## The overlap test runs BEFORE the move, on every step including the first --
## the rule `DiagnosticBolt` established, so a target already touching the spawn
## point is hit rather than silently skipped.
##
## ---------------------------------------------------------------------------
## IT LIVES IN THE WORLD, NOT ON THE ARCHER
## ---------------------------------------------------------------------------
## Parented to the world, it flies on after the archer's recovery is cancelled
## and can still hit (C-05). Cancelling an animation never touches it.
##
## Planar flight: height is presentation, never a gameplay coordinate.

static var spawned: int = 0
static var hits: int = 0
static var expired_count: int = 0
static var multi_target_hits: int = 0

var use_id: int = 0
var direction: Vector3 = Vector3.FORWARD
var travelled: float = 0.0
var alive: bool = true
var hit_target: Node = null
var hit_frame: int = -1
var spawn_frame: int = -1
var spawn_point: Vector3 = Vector3.ZERO
var steps: int = 0
var _on_hit: Callable = Callable()
var _shape := SphereShape3D.new()
var _mesh: MeshInstance3D
var _trail: MeshInstance3D
var _trail_im: ImmediateMesh
var _trail_pts: Array = []           ## [world position, age]
var _stuck_t: float = 0.0
## The arrow's length in metres: the overlap test runs at its POINT, not at its
## nock, so a hit registers when the head arrives rather than the fletching.
var length_m: float = 0.0

func launch(origin: Vector3, dir: Vector3, arrow_scale: float, p_use: int, on_hit: Callable,
		gameplay_length_m: float = -1.0) -> void:
	use_id = p_use
	_on_hit = on_hit
	direction = Vector3(dir.x, 0.0, dir.z).normalized()
	if direction.length() < 0.001:
		direction = Vector3.FORWARD
	_shape.radius = SpikeConfig.ARROW_RADIUS_M
	global_position = origin
	spawn_point = origin
	spawn_frame = Engine.get_physics_frames()
	spawned += 1
	_mesh = MeshInstance3D.new()
	_mesh.name = "ArrowMesh"
	_mesh.mesh = load(AssetManifest.ARROW) as Mesh
	_mesh.scale = Vector3.ONE * arrow_scale
	add_child(_mesh)
	# The hit test's length is the GAMEPLAY length (the Huntress's arrow), not the
	# length of whichever mesh happens to be drawn.
	length_m = gameplay_length_m if gameplay_length_m > 0.0 else BowPresentation.ARROW_MODEL_LENGTH * arrow_scale
	# Model +Z is the arrow's point.
	var z := direction
	var x := Vector3.UP.cross(z).normalized()
	var y := z.cross(x).normalized()
	basis = Basis(x, y, z)
	_trail_im = ImmediateMesh.new()
	_trail = MeshInstance3D.new()
	_trail.name = "DiagnosticTrail_code_generated"
	_trail.top_level = true
	_trail.mesh = _trail_im
	_trail.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	var m := StandardMaterial3D.new()
	m.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	m.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	m.blend_mode = BaseMaterial3D.BLEND_MODE_ADD
	m.vertex_color_use_as_albedo = true
	m.cull_mode = BaseMaterial3D.CULL_DISABLED
	_trail.material_override = m
	add_child(_trail)
	_trail.global_transform = Transform3D.IDENTITY

func _physics_process(delta: float) -> void:
	step(delta)

func step(delta: float) -> void:
	steps += 1
	_age_trail(delta)
	if not alive:
		_stuck_t += delta
		if _stuck_t > 1.2:
			queue_free()
		return
	if _test_overlap():
		return
	var mv := SpikeConfig.ARROW_SPEED_MPS * delta
	global_position += direction * mv
	travelled += mv
	_trail_pts.append([global_position, 0.0])
	if travelled >= SpikeConfig.ARROW_RANGE_M:
		alive = false
		expired_count += 1
		queue_free()

func _test_overlap() -> bool:
	var space := get_world_3d().direct_space_state
	if space == null:
		return false
	var q := PhysicsShapeQueryParameters3D.new()
	q.shape = _shape
	q.transform = Transform3D(Basis.IDENTITY, tip())
	q.collision_mask = 2
	q.collide_with_areas = false
	q.collide_with_bodies = true
	var found := space.intersect_shape(q, 4)
	var targets: Array = []
	for h in found:
		var c = h.get("collider")
		if c != null and is_instance_valid(c) and c.has_method("receive_damage") and c.get("alive") == true:
			targets.append(c)
	if targets.is_empty():
		return false
	# SINGLE-TARGET: a projectile Hits ONE target. If two overlap at once, the
	# nearer wins, ties by name -- a rule for THIS diagnostic projectile's
	# collision only. It is NOT the OWED multi-target Prey tie-break (DF-01), and
	# the count of such frames is printed so nobody mistakes it for one.
	if targets.size() > 1:
		multi_target_hits += 1
		targets.sort_custom(func(a, b):
			var da: float = tip().distance_to((a as Node3D).global_position)
			var db: float = tip().distance_to((b as Node3D).global_position)
			if absf(da - db) > 0.0001:
				return da < db
			return String((a as Node).name) < String((b as Node).name))
	var t: Node = targets[0]
	t.call("receive_damage", SpikeConfig.ARROW_DAMAGE, global_position, "direct_use")
	hit_target = t
	hit_frame = Engine.get_physics_frames()
	hits += 1
	alive = false
	_spawn_impact()
	if _on_hit.is_valid():
		_on_hit.call(t, use_id, self)
	return true

func tip() -> Vector3:
	return global_position + direction * length_m

func _spawn_impact() -> void:
	var fx := ImpactEffect.new()
	fx.name = "DiagnosticImpact_code_generated"
	get_parent().add_child(fx)
	fx.global_position = tip()
	fx.play(direction)

func _age_trail(delta: float) -> void:
	for p in _trail_pts:
		p[1] = float(p[1]) + delta
	while not _trail_pts.is_empty() and float(_trail_pts[0][1]) > SpikeConfig.TRAIL_SECONDS:
		_trail_pts.pop_front()
	_trail_im.clear_surfaces()
	if _trail_pts.size() < 2:
		return
	_trail_im.surface_begin(Mesh.PRIMITIVE_TRIANGLE_STRIP)
	var side := Vector3.UP.cross(direction).normalized() * 0.035
	for p in _trail_pts:
		var a := 1.0 - clampf(float(p[1]) / SpikeConfig.TRAIL_SECONDS, 0.0, 1.0)
		var c := Color(1.0, 0.86, 0.62, 0.55 * a)
		var pos: Vector3 = p[0]
		_trail_im.surface_set_color(c)
		_trail_im.surface_add_vertex(pos + side * a)
		_trail_im.surface_set_color(c)
		_trail_im.surface_add_vertex(pos - side * a)
	_trail_im.surface_end()
