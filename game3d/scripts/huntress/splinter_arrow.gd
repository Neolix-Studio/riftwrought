class_name SplinterArrow
extends Node3D

## THE SPLINTER SHOT ARROW — one per Skill Use, a physical projectile (D-392).
##
## ============================================================================
## SWEPT, BY EXACT TIME OF IMPACT. ONE HIT, THEN IT STOPS.
## ============================================================================
## Every physics step the arrow's HEAD sweeps a segment of the plane. Against
## every REGISTERED, ELIGIBLE enemy (`HitEligibility`) it computes the exact contact point
## (`ArrowCollision.segment_circle_toi`); against WORLD GEOMETRY a physics shape
## cast gives the first blocking contact. The earliest wins; a tie within the
## PROVISIONAL tolerance goes to the lower combat-entity ID (D-391 ruling 5).
## UNMODIFIED (D-390 ruling 4; the D-392 ruling's item 9): it Hits the first
## eligible target and STOPS -- no Pierce, Chain, Fork, extra projectile or
## explosion exists here.
##
## ---------------------------------------------------------------------------
## THE POINT-BLANK RULE, CARRIED: THE FIRST SWEEP STARTS AT HER GROUND POINT.
## ---------------------------------------------------------------------------
## Canon (combat section 0.5): "a projectile must test what it already overlaps
## at spawn, before its first motion step." The arrow leaves the bow half a metre
## in front of her, so its FIRST sweep runs from her ground point to its head at
## release: a target touching her is Hit rather than skipped.
##
## ---------------------------------------------------------------------------
## WORLD GEOMETRY STOPS IT, WITHOUT A HIT.
## ---------------------------------------------------------------------------
## Canon (combat section 0.2): "there is no projectile that passes over a wall".
## Scenery is never Hit and never damaged. (The accepted diagnostic
## projectiles pass through walls; they are unchanged, and this is not them.)
##
## ---------------------------------------------------------------------------
## NOT ELIGIBLE -> PASSED THROUGH. UNREGISTERED -> NEVER A CANDIDATE.
## ---------------------------------------------------------------------------
## A dead, dying, allied, untargetable or invulnerable entity is passed through
## and recorded as such, so the "first ELIGIBLE target" rule is visible. A body
## the registry does not hold (the accepted diagnostic beasts, the player) is
## never a candidate at all.
##
## IT LIVES IN THE WORLD, NOT ON THE ARCHER: a recovery cancellation cancels an
## ANIMATION and never touches it. Planar flight: its height is presentation.

## Diagnostics the suite reads. Static, because an arrow frees itself.
static var spawned: int = 0
static var hits: int = 0
static var wall_stops: int = 0
static var expired_count: int = 0
static var last_outcome: String = ""
static var last_hit_id: String = ""
static var last_tie_set: Array = []

static func reset_counters() -> void:
	spawned = 0
	hits = 0
	wall_stops = 0
	expired_count = 0
	last_outcome = ""
	last_hit_id = ""
	last_tie_set = []

var use_id: String = ""
var configuration_id: String = ""
var direction: Vector3 = Vector3.FORWARD
var damage: float = 0.0
var registry: CombatEntityRegistry = null
## Called ONCE when the arrow ends: (outcome, record, info). outcome is "hit",
## "wall" or "expired"; record is the Hit entity's registry record, or {}.
var report: Callable = Callable()

var alive: bool = true
var outcome: String = "flying"
var hit_record: Dictionary = {}
var length_m: float = 0.6
var visual_height: float = 1.3
## Where the HEAD is on the plane, and how far along its swept path it has come.
var head: Vector2 = Vector2.ZERO
var path_m: float = 0.0
var travelled: float = 0.0
var steps: int = 0
var sweeps: int = 0
var spawn_frame: int = -1
var end_frame: int = -1
var passed_through: Array = []        ## [id, reason] of registered entities it passed
var last_candidates: Array = []

var _archer_ground: Vector2 = Vector2.ZERO
var _first_sweep_done: bool = false
var _stuck_t: float = 0.0
var _mesh: MeshInstance3D
var _trail: MeshInstance3D
var _trail_im: ImmediateMesh
var _trail_pts: Array = []
var _wall_shape := SphereShape3D.new()

## Places the arrow. `tail_world` is where the NOCKED arrow's nock was on the
## release frame, `dir` the SAMPLED aim, `archer_ground` her ground point.
func launch(tail_world: Vector3, dir: Vector3, p_length_m: float, arrow_scale: float,
		archer_ground: Vector3, p_use_id: String, p_damage: float,
		p_registry: CombatEntityRegistry, p_report: Callable, p_configuration_id: String = "") -> void:
	use_id = p_use_id
	configuration_id = p_configuration_id
	damage = p_damage
	registry = p_registry
	report = p_report
	direction = Vector3(dir.x, 0.0, dir.z)
	if direction.length() < 0.001:
		direction = Vector3.FORWARD
	direction = direction.normalized()
	length_m = maxf(0.05, p_length_m)
	visual_height = tail_world.y
	global_position = tail_world
	var d2 := ArrowCollision.planar(direction)
	head = ArrowCollision.planar(tail_world) + d2 * length_m
	_archer_ground = ArrowCollision.planar(archer_ground)
	_wall_shape.radius = HuntressConfig.ARROW_RADIUS_M
	spawn_frame = Engine.get_physics_frames()
	spawned += 1
	var z := direction
	var x := Vector3.UP.cross(z).normalized()
	var y := z.cross(x).normalized()
	basis = Basis(x, y, z)
	_mesh = MeshInstance3D.new()
	_mesh.name = "ArrowMesh_PLACEHOLDER"
	_mesh.mesh = load(AssetManifest.ARROW) as Mesh
	_mesh.scale = Vector3.ONE * arrow_scale
	add_child(_mesh)
	_trail_im = ImmediateMesh.new()
	_trail = MeshInstance3D.new()
	_trail.name = "Trail_code_generated_PLACEHOLDER"
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

## Separated so the suite can drive exact steps.
func step(delta: float) -> void:
	steps += 1
	_age_trail(delta)
	if not alive:
		_stuck_t += delta
		if _stuck_t > 0.9:
			queue_free()
		return
	# 1. THE SPAWN SEGMENT, BEFORE ANY MOTION: her ground point -> the head.
	if not _first_sweep_done:
		_first_sweep_done = true
		if _sweep(_archer_ground, head, 0.0):
			return
	# 2. THE MOTION SEGMENT: this step's travel, clamped to the range left.
	var mv := minf(HuntressConfig.ARROW_SPEED_MPS * delta,
		maxf(0.0, HuntressConfig.ARROW_RANGE_M - travelled))
	var d2 := ArrowCollision.planar(direction)
	var a := head
	var b := head + d2 * mv
	if _sweep(a, b, path_m):
		return
	head = b
	path_m += mv
	travelled += mv
	_place_visual()
	_trail_pts.append([_tail_world(), 0.0])
	if travelled >= HuntressConfig.ARROW_RANGE_M - 0.0001:
		_end("expired", {}, {"distance_m": path_m})
		expired_count += 1
		queue_free()

## Sweeps a -> b. Returns true if the arrow ENDED on this segment.
func _sweep(a: Vector2, b: Vector2, path_before: float) -> bool:
	sweeps += 1
	var seg := a.distance_to(b)
	var candidates: Array = []
	if registry != null:
		for rec in registry.records():
			var node = rec["node"]
			if node == null or not is_instance_valid(node):
				continue
			var r := _body_radius(node) + HuntressConfig.ARROW_RADIUS_M
			var c := ArrowCollision.planar((node as Node3D).global_position)
			var t := ArrowCollision.segment_circle_toi(a, b, c, r)
			if t < 0.0:
				continue
			var e := HitEligibility.evaluate(rec)
			if not bool(e["eligible"]):
				# PASSED THROUGH -- recorded, never Hit.
				var pid := String(rec["id"])
				var seen := false
				for p in passed_through:
					if String(p[0]) == pid:
						seen = true
				if not seen:
					passed_through.append([pid, String(e["reason"])])
				continue
			candidates.append({"id": String(rec["id"]), "distance_m": path_before + t * seg,
				"t": t, "record": rec})
	last_candidates = candidates
	var winner := ArrowCollision.choose(candidates, registry, HuntressConfig.COLLISION_TIE_TOLERANCE_M) \
		if registry != null else {}
	var wall_t := _wall_toi(a, b)
	var wall_d := path_before + wall_t * seg if wall_t >= 0.0 else INF
	# WORLD GEOMETRY WINS ONLY IF IT IS STRICTLY EARLIER, beyond the tolerance.
	if not winner.is_empty() and float(winner["distance_m"]) <= wall_d + HuntressConfig.COLLISION_TIE_TOLERANCE_M:
		var at := a.lerp(b, float(winner["t"]))
		_move_head_to(at, float(winner["distance_m"]))
		last_tie_set = ArrowCollision.tie_set(candidates, HuntressConfig.COLLISION_TIE_TOLERANCE_M)
		_hit(winner["record"], float(winner["distance_m"]))
		return true
	if wall_t >= 0.0:
		_move_head_to(a.lerp(b, wall_t), wall_d)
		wall_stops += 1
		_end("wall", {}, {"distance_m": wall_d})
		_spawn_impact()
		return true
	return false

## THE ONE HIT: damage through the entity's own receiver, recorded in the
## ledger, then the arrow ends and reports what it did. The report only RECORDS
## the outcome; nothing designates, prefers or commands a target.
func _hit(rec: Dictionary, distance_m: float) -> void:
	var node = rec["node"]
	var at := Vector3(head.x, visual_height, head.y)
	node.call("receive_damage", damage, at)
	SkillRuntime.record_damage("player_direct", damage, configuration_id)
	hits += 1
	last_hit_id = String(rec["id"])
	hit_record = rec
	_end("hit", rec, {"distance_m": distance_m, "tie_set": last_tie_set.duplicate()})
	_spawn_impact()

func _end(p_outcome: String, rec: Dictionary, info: Dictionary) -> void:
	alive = false
	outcome = p_outcome
	last_outcome = p_outcome
	end_frame = Engine.get_physics_frames()
	if report.is_valid():
		report.call(p_outcome, rec, info)

func _move_head_to(at: Vector2, distance_m: float) -> void:
	travelled += maxf(0.0, distance_m - path_m)
	path_m = distance_m
	head = at
	_place_visual()

func _tail_world() -> Vector3:
	var tail := head - ArrowCollision.planar(direction) * length_m
	return Vector3(tail.x, visual_height, tail.y)

func _place_visual() -> void:
	global_position = _tail_world()

## The first blocking contact with WORLD GEOMETRY (layer 4) on a -> b, as a
## fraction of the segment, or -1.0. A start already inside a blocker is 0.
func _wall_toi(a: Vector2, b: Vector2) -> float:
	var w := get_world_3d()
	if w == null:
		return -1.0
	var space := w.direct_space_state
	if space == null:
		return -1.0
	var from := Vector3(a.x, HuntressConfig.WALL_PROBE_HEIGHT_M, a.y)
	var to := Vector3(b.x, HuntressConfig.WALL_PROBE_HEIGHT_M, b.y)
	var q := PhysicsShapeQueryParameters3D.new()
	q.shape = _wall_shape
	q.transform = Transform3D(Basis.IDENTITY, from)
	q.collision_mask = 4
	q.collide_with_areas = false
	q.collide_with_bodies = true
	if not space.intersect_shape(q, 1).is_empty():
		return 0.0
	if from.distance_to(to) < 0.00001:
		return -1.0
	q.motion = to - from
	var r := space.cast_motion(q)
	if r.size() == 2 and float(r[1]) < 1.0:
		return clampf(float(r[1]), 0.0, 1.0)
	return -1.0

## A body's radius on the plane, MEASURED from its own collision shape.
static func _body_radius(node: Node) -> float:
	if node.has_method("combat_body_radius"):
		return float(node.call("combat_body_radius"))
	for c in node.get_children():
		if c is CollisionShape3D:
			var sh = (c as CollisionShape3D).shape
			if sh is CylinderShape3D:
				return (sh as CylinderShape3D).radius
			if sh is SphereShape3D:
				return (sh as SphereShape3D).radius
			if sh is CapsuleShape3D:
				return (sh as CapsuleShape3D).radius
	return 0.0

func _spawn_impact() -> void:
	var p := get_parent()
	if p == null:
		return
	var fx := ImpactFlash.new()
	fx.name = "ImpactFlash_code_generated_PLACEHOLDER"
	p.add_child(fx)
	fx.global_position = Vector3(head.x, visual_height, head.y)
	fx.play(direction)

func _age_trail(delta: float) -> void:
	if _trail_im == null:
		return
	for p in _trail_pts:
		p[1] = float(p[1]) + delta
	while not _trail_pts.is_empty() and float(_trail_pts[0][1]) > HuntressConfig.TRAIL_SECONDS:
		_trail_pts.pop_front()
	_trail_im.clear_surfaces()
	if _trail_pts.size() < 2:
		return
	_trail_im.surface_begin(Mesh.PRIMITIVE_TRIANGLE_STRIP)
	var side := Vector3.UP.cross(direction).normalized() * 0.035
	for p in _trail_pts:
		var k := 1.0 - clampf(float(p[1]) / HuntressConfig.TRAIL_SECONDS, 0.0, 1.0)
		var col := Color(1.0, 0.86, 0.62, 0.55 * k)
		var pos: Vector3 = p[0]
		_trail_im.surface_set_color(col)
		_trail_im.surface_add_vertex(pos + side * k)
		_trail_im.surface_set_color(col)
		_trail_im.surface_add_vertex(pos - side * k)
	_trail_im.surface_end()
