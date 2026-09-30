class_name RogueliteRoomModule
extends Node3D
## Riftwrought — Roguelite Core Loop Review: ONE reusable authored greybox
## module, with defined entry and exit points (decision D-220).
##
## THIS IS THE ARCHITECTURAL POINT OF THE WHOLE REVIEW. There is exactly ONE
## module class. The hub and all three combat rooms are the SAME script
## configured by a record in `MODULES`, so "add a room" is "add a record",
## never "add a script". That is what makes the later shuffle system a
## selection problem rather than a rewrite.
##
## EACH MODULE IS AUTHORED IN ITS OWN LOCAL FRAME, entry at the origin, the
## route running toward local -Z. Nothing in a record knows where the module
## sits in the world; the runtime places the node and the sockets follow
## through `global_transform`. That is deliberate, and it is the project's own
## recorded lesson: `route_forward()` read Riftfall Landing's centreline in
## WORLD space, the composition carries a 45 degree yaw, and a dot product
## built on it was wrong by tens of metres while an axis assertion reported
## 15.56 m of offset for two points sharing an x coordinate exactly. Measure
## in the module's own local frame, where the route runs along local -Z by
## construction and no rotation can move it.
##
## PRIMITIVE GEOMETRY ONLY. Every surface, mass, post and marker in this file
## is a Godot `BoxMesh` / `TorusMesh` / `PlaneMesh` / `ImmediateMesh` in a flat
## `StandardMaterial3D`. No mesh is loaded, no texture, no shader file, no
## particle system, and this file names no path under the project's asset
## tree at all. The review is deliberately greyboxed and this is where that
## promise is kept or broken.
##
## STRUCTURE VS DRESSING is the same line every layout in this project draws:
## the ground plates are collision-bearing walkable surface, every non-ground
## solid ALSO carves its own footprint out of the baked navigation mesh, and
## nothing decorative carries collision. The carve is the Gate 1A
## "open-topped well" fix — a box whose top sits inside the bake volume
## otherwise rasterises as a walkable phantom interior, and the defect is
## CONCEALED by any obstacle narrower than 2x the agent radius (0.80 m), so it
## is not a rule a layout can safely skip because it looks fine.
##
## PERIMETER WALLS ARE DERIVED, NOT TYPED. A record lists walkable rectangles;
## this file generates each rectangle's four perimeter walls and then subtracts
## every walkable rectangle back out of them. A seam between two walkable
## rectangles therefore opens BY CONSTRUCTION rather than by an author
## remembering to split a wall around it. That is the direct answer to the
## Gate 1E defect where the Nexus Threshold's WEST_ALCOVE shipped completely
## sealed — 70 m^2 baking as an unreachable island — because it had no socket
## and every socket check passed over it.

const WORLD_LAYER: int = 1

const WALL_THICKNESS: float = 1.5
const WALL_HEIGHT: float = 4.0
const GROUND_THICKNESS: float = 0.20

## The gate frame the player walks into to leave a module. Two posts and a
## lintel around a flat curtain; the posts are solid and carve, the curtain is
## presentation and does not, because the player walks through it.
const GATE_HALF_WIDTH: float = 1.90
const GATE_POST: float = 0.60
const GATE_HEIGHT: float = 3.20
const GATE_TRIGGER_RADIUS: float = 1.70

const GROUND_COLOUR: Color = Color(0.520, 0.535, 0.560)
const HUB_GROUND_COLOUR: Color = Color(0.470, 0.500, 0.575)
const WALL_COLOUR: Color = Color(0.300, 0.305, 0.330)
const PILLAR_COLOUR: Color = Color(0.345, 0.340, 0.360)
const GATE_FRAME_COLOUR: Color = Color(0.400, 0.380, 0.330)
const GATE_SEALED_COLOUR: Color = Color(0.780, 0.250, 0.220, 0.55)
const GATE_OPEN_COLOUR: Color = Color(0.620, 0.420, 0.950, 0.62)
const ENTRY_MARKER_COLOUR: Color = Color(0.35, 0.80, 0.95)
const EXIT_MARKER_COLOUR: Color = Color(0.90, 0.75, 0.30)
const SPAWN_MARKER_COLOUR: Color = Color(0.85, 0.30, 0.28)

## --- THE MODULE RECORDS ----------------------------------------------------
##
## `Rect2` is an XZ footprint in the module's own local frame:
## `position.x` / `size.x` is local X, `position.y` / `size.y` is local Z — the
## same convention `BrokenWatchLayout` and `RiftfallLandingGreyboxLayout` use,
## so all three read as one coordinate language.
##
## Every module runs from local z = 0 (entry end) toward negative z (exit end).
##
## `kind` is "hub" (safe, no combat) or "combat".
## `exit_caption` completes the sentence "Rift Gate open — walk in to ___", so
## it is a lower-case verb phrase rather than a title. A rendered frame read
## "walk in to onward" before this was fixed.
## `spawns` are encounter positions; an empty array means no encounter.
## `pillars` are solid repositioning cover, each `{at, size}`.
const MODULES: Dictionary = {
	&"nexus_hub": {
		"display_name": "Rift Nexus",
		"subtitle": "Safe. No combat here.",
		"kind": "hub",
		"walkable": [Rect2(Vector2(-12.0, -20.0), Vector2(24.0, 20.0))],
		"entry": Vector2(0.0, -4.5),
		"exit": Vector2(0.0, -18.4),
		"spawns": [],
		"pillars": [
			{"at": Vector2(-8.5, -12.0), "size": Vector2(1.2, 1.2)},
			{"at": Vector2(8.5, -12.0), "size": Vector2(1.2, 1.2)},
		],
		"exit_caption": "begin an expedition",
	},
	&"teaching_hall": {
		"display_name": "Teaching Hall",
		"subtitle": "One Graveblade. Learn Quick Strike.",
		"kind": "combat",
		"walkable": [Rect2(Vector2(-10.0, -28.0), Vector2(20.0, 28.0))],
		"entry": Vector2(0.0, -3.5),
		"exit": Vector2(0.0, -26.4),
		"spawns": [Vector2(0.0, -17.0)],
		"pillars": [],
		"exit_caption": "continue",
	},
	&"cache_room": {
		"display_name": "Cache Room",
		"subtitle": "Two Graveblades. Clearing it leaves something behind.",
		"kind": "combat",
		"walkable": [
			Rect2(Vector2(-12.0, -22.0), Vector2(24.0, 22.0)),
			## The reward alcove. It shares the z = -22 seam with the main
			## room over x -4..4, so the derived perimeter opens there by
			## construction. Gate 1E's sealed WEST_ALCOVE is exactly the
			## failure this generation rule exists to make impossible.
			Rect2(Vector2(-4.0, -28.0), Vector2(8.0, 6.0)),
		],
		"entry": Vector2(0.0, -3.5),
		"exit": Vector2(0.0, -26.6),
		"spawns": [Vector2(-5.5, -12.5), Vector2(5.5, -15.0)],
		"pillars": [
			{"at": Vector2(-9.0, -17.5), "size": Vector2(1.5, 1.5)},
			{"at": Vector2(9.0, -8.5), "size": Vector2(1.5, 1.5)},
		],
		"exit_caption": "continue",
	},
	&"elite_hall": {
		"display_name": "Elite Hall",
		"subtitle": "A heavier Graveblade, and one escort.",
		"kind": "combat",
		"walkable": [Rect2(Vector2(-13.0, -30.0), Vector2(26.0, 30.0))],
		"entry": Vector2(0.0, -3.5),
		"exit": Vector2(0.0, -28.4),
		## Index 0 is the Elite; the runtime reads it that way.
		"spawns": [Vector2(0.0, -18.0), Vector2(-7.0, -12.5)],
		"pillars": [
			{"at": Vector2(-8.0, -21.0), "size": Vector2(1.5, 1.5)},
			{"at": Vector2(8.0, -21.0), "size": Vector2(1.5, 1.5)},
		],
		"exit_caption": "return to the Nexus",
	},
}

## The module this node builds. Assigned by the runtime BEFORE the node enters
## the tree, exactly as `PrototypeGraveblade.data` must be.
@export var module_id: StringName = &"nexus_hub"

var grid_visible: bool = false
var exit_gate_open: bool = false

var _visuals: Node3D
var _collision: StaticBody3D
var _obstacles: Node3D
var _markers: Node3D
var _grid: MeshInstance3D
var _gate_curtain: MeshInstance3D
var _gate_material: StandardMaterial3D

var _wall_rects: Array[Rect2] = []
var _solid_count: int = 0


func _ready() -> void:
	build()


func record() -> Dictionary:
	assert(MODULES.has(module_id), "RogueliteRoomModule: unknown module id %s" % module_id)
	return MODULES[module_id]


func display_name() -> String:
	return String(record()["display_name"])


func subtitle() -> String:
	return String(record()["subtitle"])


func is_hub() -> bool:
	return String(record()["kind"]) == "hub"


func exit_caption() -> String:
	return String(record()["exit_caption"])


# --- Build ------------------------------------------------------------------

func build() -> void:
	for child: Node in get_children():
		child.free()
	_wall_rects.clear()
	_solid_count = 0

	_visuals = Node3D.new()
	_visuals.name = "Visuals"
	add_child(_visuals)

	_collision = StaticBody3D.new()
	_collision.name = "WorldCollision"
	_collision.collision_layer = WORLD_LAYER
	_collision.collision_mask = 0
	add_child(_collision)

	_obstacles = Node3D.new()
	_obstacles.name = "NavigationObstacles"
	add_child(_obstacles)

	_markers = Node3D.new()
	_markers.name = "Markers"
	add_child(_markers)

	_build_ground()
	_build_walls()
	_build_pillars()
	_build_gate()
	_build_sockets()
	_build_grid()
	set_exit_gate_open(exit_gate_open)


func _build_ground() -> void:
	var colour: Color = HUB_GROUND_COLOUR if is_hub() else GROUND_COLOUR
	for rect: Rect2 in walkable_rects():
		var size: Vector3 = Vector3(rect.size.x, GROUND_THICKNESS, rect.size.y)
		var at: Vector3 = Vector3(
			rect.position.x + rect.size.x * 0.5,
			-GROUND_THICKNESS * 0.5,
			rect.position.y + rect.size.y * 0.5
		)
		var plate: MeshInstance3D = _box(_stem("Ground", rect.position), size, at, colour)
		_visuals.add_child(plate)
		## Ground is the ONE solid that must not carve: it IS the walkable
		## surface the bake is looking for.
		_add_collision(plate.name, size, at)


## Perimeter walls are DERIVED from the walkable set and then have the walkable
## set subtracted back out of them, so a seam between two rooms opens by
## construction. See the class header.
func _build_walls() -> void:
	var rects: Array[Rect2] = walkable_rects()
	for rect: Rect2 in rects:
		var t: float = WALL_THICKNESS
		var candidates: Array[Dictionary] = [
			{"rect": Rect2(Vector2(rect.position.x - t, rect.position.y), Vector2(t, rect.size.y)), "along_x": false},
			{"rect": Rect2(Vector2(rect.end.x, rect.position.y), Vector2(t, rect.size.y)), "along_x": false},
			{"rect": Rect2(Vector2(rect.position.x - t, rect.end.y), Vector2(rect.size.x + t * 2.0, t)), "along_x": true},
			{"rect": Rect2(Vector2(rect.position.x - t, rect.position.y - t), Vector2(rect.size.x + t * 2.0, t)), "along_x": true},
		]
		for candidate: Dictionary in candidates:
			for piece: Rect2 in _subtract_walkable(candidate["rect"], bool(candidate["along_x"]), rects):
				_wall_block(piece, WALL_HEIGHT, WALL_COLOUR)


## Removes every walkable rectangle from `wall`, along its long axis, and
## returns what survives. Overlap is judged by AREA, so two rectangles that
## merely touch along an edge do not open each other.
static func _subtract_walkable(wall: Rect2, along_x: bool, rects: Array[Rect2]) -> Array[Rect2]:
	var cuts: Array[Vector2] = []
	for rect: Rect2 in rects:
		var overlap: Rect2 = wall.intersection(rect)
		if overlap.size.x <= 0.0001 or overlap.size.y <= 0.0001:
			continue
		cuts.append(Vector2(overlap.position.x, overlap.end.x) if along_x
			else Vector2(overlap.position.y, overlap.end.y))
	var low: float = wall.position.x if along_x else wall.position.y
	var high: float = wall.end.x if along_x else wall.end.y
	cuts.sort_custom(func(a: Vector2, b: Vector2) -> bool: return a.x < b.x)

	var pieces: Array[Rect2] = []
	var cursor: float = low
	for cut: Vector2 in cuts:
		if cut.x > cursor + 0.0001:
			pieces.append(_span(wall, along_x, cursor, minf(cut.x, high)))
		cursor = maxf(cursor, cut.y)
	if cursor < high - 0.0001:
		pieces.append(_span(wall, along_x, cursor, high))
	return pieces


static func _span(wall: Rect2, along_x: bool, from: float, to: float) -> Rect2:
	if along_x:
		return Rect2(Vector2(from, wall.position.y), Vector2(to - from, wall.size.y))
	return Rect2(Vector2(wall.position.x, from), Vector2(wall.size.x, to - from))


func _wall_block(rect: Rect2, height: float, colour: Color) -> void:
	var size: Vector3 = Vector3(rect.size.x, height, rect.size.y)
	var at: Vector3 = Vector3(
		rect.position.x + rect.size.x * 0.5, height * 0.5, rect.position.y + rect.size.y * 0.5
	)
	_visuals.add_child(_box(_stem("Wall", rect.position), size, at, colour))
	_wall_rects.append(rect)
	_add_solid_with_carve(_stem("Wall", rect.position), size, at)


func _build_pillars() -> void:
	for entry: Dictionary in record()["pillars"]:
		var at2: Vector2 = entry["at"]
		var footprint: Vector2 = entry["size"]
		var size: Vector3 = Vector3(footprint.x, WALL_HEIGHT, footprint.y)
		var at: Vector3 = Vector3(at2.x, WALL_HEIGHT * 0.5, at2.y)
		_visuals.add_child(_box(_stem("Pillar", at2), size, at, PILLAR_COLOUR))
		_add_solid_with_carve(_stem("Pillar", at2), size, at)


## Two posts, a lintel, and a flat curtain between them. The posts are solid
## and carve; the curtain is presentation only, because the player walks
## THROUGH it — a gate you cannot enter is a wall.
func _build_gate() -> void:
	var exit_at: Vector2 = exit_point_local()
	for side: int in [-1, 1]:
		var at: Vector3 = Vector3(exit_at.x + float(side) * GATE_HALF_WIDTH, GATE_HEIGHT * 0.5, exit_at.y)
		var size: Vector3 = Vector3(GATE_POST, GATE_HEIGHT, GATE_POST)
		var post_name: String = "GatePost%s" % ("W" if side < 0 else "E")
		_visuals.add_child(_box(post_name, size, at, GATE_FRAME_COLOUR))
		_add_solid_with_carve(post_name, size, at)

	var lintel_size: Vector3 = Vector3(GATE_HALF_WIDTH * 2.0 + GATE_POST, 0.55, GATE_POST)
	var lintel_at: Vector3 = Vector3(exit_at.x, GATE_HEIGHT + 0.275, exit_at.y)
	_visuals.add_child(_box("GateLintel", lintel_size, lintel_at, GATE_FRAME_COLOUR))

	_gate_curtain = MeshInstance3D.new()
	_gate_curtain.name = "GateCurtain"
	var curtain: PlaneMesh = PlaneMesh.new()
	curtain.size = Vector2(GATE_HALF_WIDTH * 2.0 - GATE_POST * 0.5, GATE_HEIGHT - 0.10)
	curtain.orientation = PlaneMesh.FACE_Z
	_gate_curtain.mesh = curtain
	_gate_material = _unshaded_material(GATE_SEALED_COLOUR)
	_gate_curtain.material_override = _gate_material
	_gate_curtain.position = Vector3(exit_at.x, (GATE_HEIGHT - 0.10) * 0.5, exit_at.y)
	_gate_curtain.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	_visuals.add_child(_gate_curtain)


func set_exit_gate_open(value: bool) -> void:
	exit_gate_open = value
	if _gate_material != null:
		_gate_material.albedo_color = GATE_OPEN_COLOUR if value else GATE_SEALED_COLOUR
		_gate_material.emission_enabled = true
		_gate_material.emission = Color(
			_gate_material.albedo_color.r, _gate_material.albedo_color.g, _gate_material.albedo_color.b
		)
		_gate_material.emission_energy_multiplier = 1.6 if value else 0.5


func _build_sockets() -> void:
	_socket_ring("ModuleEntry", entry_point_local(), ENTRY_MARKER_COLOUR)
	_socket_ring("ModuleExit", exit_point_local(), EXIT_MARKER_COLOUR)
	var index: int = 0
	for at: Vector2 in record()["spawns"]:
		_socket_ring("EncounterSpawn%d" % index, at, SPAWN_MARKER_COLOUR)
		index += 1


func _socket_ring(marker_name: String, at: Vector2, colour: Color) -> void:
	var ring: MeshInstance3D = MeshInstance3D.new()
	ring.name = "%sRing" % marker_name
	var torus: TorusMesh = TorusMesh.new()
	torus.inner_radius = 0.45
	torus.outer_radius = 0.62
	torus.rings = 20
	ring.mesh = torus
	ring.material_override = _unshaded_material(colour)
	ring.position = Vector3(at.x, 0.05, at.y)
	ring.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	ring.visible = grid_visible
	_markers.add_child(ring)


## The grid is a child of THIS module, so its vertices are in the module's own
## LOCAL space. It must therefore be built from `local_bounds()`, not from
## `bake_rect()` — `bake_rect()` already adds the module's own offset for the
## parent's navigation volume, so using it here applied that offset TWICE and
## drew each module's grid at double its position. The hub sits at the origin
## and so looked perfectly correct, which is exactly why only an overhead frame
## of all four modules at once could show it.
func _build_grid() -> void:
	var bounds: Rect2 = local_bounds()
	var mesh: ImmediateMesh = ImmediateMesh.new()
	var material: StandardMaterial3D = StandardMaterial3D.new()
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.vertex_color_use_as_albedo = true
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	var minor: Color = Color(0.20, 0.20, 0.22, 0.35)
	var major: Color = Color(0.35, 0.75, 0.90, 0.75)
	var x: float = floorf(bounds.position.x)
	while x <= bounds.end.x + 0.001:
		mesh.surface_set_color(major if is_zero_approx(fmod(absf(x), 5.0)) else minor)
		mesh.surface_add_vertex(Vector3(x, 0.02, bounds.position.y))
		mesh.surface_add_vertex(Vector3(x, 0.02, bounds.end.y))
		x += 1.0
	var z: float = floorf(bounds.position.y)
	while z <= bounds.end.y + 0.001:
		mesh.surface_set_color(major if is_zero_approx(fmod(absf(z), 5.0)) else minor)
		mesh.surface_add_vertex(Vector3(bounds.position.x, 0.02, z))
		mesh.surface_add_vertex(Vector3(bounds.end.x, 0.02, z))
		z += 1.0
	mesh.surface_end()
	_grid = MeshInstance3D.new()
	_grid.name = "ReviewGrid"
	_grid.mesh = mesh
	_grid.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	_grid.visible = grid_visible
	_visuals.add_child(_grid)


func set_grid_visible(value: bool) -> void:
	grid_visible = value
	if _grid != null:
		_grid.visible = value
	if _markers != null:
		for marker: Node in _markers.get_children():
			(marker as MeshInstance3D).visible = value


# --- Primitive builders -----------------------------------------------------

func _box(box_name: String, size: Vector3, at: Vector3, colour: Color) -> MeshInstance3D:
	var node: MeshInstance3D = MeshInstance3D.new()
	node.name = box_name
	var mesh: BoxMesh = BoxMesh.new()
	mesh.size = size
	node.mesh = mesh
	node.material_override = _lit_material(colour)
	node.position = at
	return node


func _stem(prefix: String, at: Vector2) -> String:
	_solid_count += 1
	return "%s_%d_%d_%d" % [prefix, int(roundf(at.x * 10.0)), int(roundf(at.y * 10.0)), _solid_count]


func _add_collision(solid_name: String, size: Vector3, at: Vector3) -> void:
	var shape: CollisionShape3D = CollisionShape3D.new()
	shape.name = solid_name
	var box: BoxShape3D = BoxShape3D.new()
	box.size = size
	shape.shape = box
	shape.position = at
	_collision.add_child(shape)


## Every non-ground solid also carves its own footprint out of the baked
## navigation mesh — the Gate 1A "open-topped well" fix. A box whose top lies
## inside the bake volume otherwise rasterises as an OPEN-TOPPED WELL with a
## perfectly walkable interior island sealed inside solid architecture, and the
## defect is concealed by any obstacle narrower than 2x the agent radius.
func _add_solid_with_carve(solid_name: String, size: Vector3, at: Vector3) -> void:
	_add_collision(solid_name, size, at)

	var obstacle: NavigationObstacle3D = NavigationObstacle3D.new()
	obstacle.name = "%sCarve" % solid_name
	obstacle.position = Vector3(at.x, 0.0, at.z)
	obstacle.height = size.y
	obstacle.affect_navigation_mesh = true
	obstacle.carve_navigation_mesh = true
	obstacle.avoidance_enabled = false
	var half_x: float = size.x * 0.5
	var half_z: float = size.z * 0.5
	obstacle.vertices = PackedVector3Array([
		Vector3(-half_x, 0.0, -half_z),
		Vector3(half_x, 0.0, -half_z),
		Vector3(half_x, 0.0, half_z),
		Vector3(-half_x, 0.0, half_z),
	])
	_obstacles.add_child(obstacle)


func _lit_material(colour: Color) -> StandardMaterial3D:
	var material: StandardMaterial3D = StandardMaterial3D.new()
	material.albedo_color = colour
	material.roughness = 0.92
	material.specular_mode = BaseMaterial3D.SPECULAR_DISABLED
	return material


func _unshaded_material(colour: Color) -> StandardMaterial3D:
	var material: StandardMaterial3D = StandardMaterial3D.new()
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.transparency = (BaseMaterial3D.TRANSPARENCY_ALPHA if colour.a < 0.999
		else BaseMaterial3D.TRANSPARENCY_DISABLED)
	material.cull_mode = BaseMaterial3D.CULL_DISABLED
	material.albedo_color = colour
	return material


# --- The module contract: sockets, bounds, measurement ----------------------

func walkable_rects() -> Array[Rect2]:
	var rects: Array[Rect2] = []
	for rect: Rect2 in record()["walkable"]:
		rects.append(rect)
	return rects


func entry_point_local() -> Vector2:
	return record()["entry"]


func exit_point_local() -> Vector2:
	return record()["exit"]


func spawn_points_local() -> Array[Vector2]:
	var points: Array[Vector2] = []
	for at: Vector2 in record()["spawns"]:
		points.append(at)
	return points


func _world(at: Vector2) -> Vector3:
	return global_transform * Vector3(at.x, 0.0, at.y)


func entry_point() -> Vector3:
	return _world(entry_point_local())


func exit_point() -> Vector3:
	return _world(exit_point_local())


func spawn_points() -> Array[Vector3]:
	var points: Array[Vector3] = []
	for at: Vector2 in spawn_points_local():
		points.append(_world(at))
	return points


func encounter_count() -> int:
	return spawn_points_local().size()


## The centre of every authored walkable rectangle, in world space. Gate 1E's
## single most valuable new check walks to these rather than to sockets:
## sockets are placed where things happen, so a sealed room with no socket
## passes every socket check while being an unreachable island.
func room_centres() -> Array[Vector3]:
	var centres: Array[Vector3] = []
	for rect: Rect2 in walkable_rects():
		centres.append(_world(rect.get_center()))
	return centres


## The direction the route runs, measured in the module's OWN LOCAL FRAME and
## then rotated into the world — never read off a world-space span.
func route_forward() -> Vector3:
	var basis_forward: Vector3 = global_transform.basis * Vector3(0.0, 0.0, -1.0)
	return Vector3(basis_forward.x, 0.0, basis_forward.z).normalized()


func local_bounds() -> Rect2:
	var rects: Array[Rect2] = walkable_rects()
	var bounds: Rect2 = rects[0]
	for rect: Rect2 in rects:
		bounds = bounds.merge(rect)
	for rect: Rect2 in _wall_rects:
		bounds = bounds.merge(rect)
	return bounds.grow(2.0)


## The module's footprint in the PARENT's frame, for merging into one shared
## navigation bake volume. The module's own transform is a translation only, so
## an offset rectangle is exact rather than an approximation.
func bake_rect() -> Rect2:
	var bounds: Rect2 = local_bounds()
	var origin: Vector3 = position
	return Rect2(bounds.position + Vector2(origin.x, origin.z), bounds.size)


func footprint_area() -> float:
	return _rect_union_area(walkable_rects())


func room_count() -> int:
	return walkable_rects().size()


func solid_count() -> int:
	return _collision.get_child_count() if _collision != null else 0


func carve_count() -> int:
	return _obstacles.get_child_count() if _obstacles != null else 0


## Exact rather than sampled: a sweep-line union area over the walkable set.
## The project's own recorded lesson is that a sampled measurement is not a
## measurement of the thing you designed — marching a probe in 5 cm steps
## under-reported an 8.000 m breach as 7.90 m and failed it for no reason but
## the sampler.
static func _rect_union_area(rects: Array[Rect2]) -> float:
	if rects.is_empty():
		return 0.0
	var xs: Array[float] = []
	for r: Rect2 in rects:
		xs.append(r.position.x)
		xs.append(r.end.x)
	xs.sort()
	var total: float = 0.0
	for i: int in range(xs.size() - 1):
		var x0: float = xs[i]
		var x1: float = xs[i + 1]
		var width: float = x1 - x0
		if width <= 0.0000001:
			continue
		var xm: float = (x0 + x1) * 0.5
		var intervals: Array[Vector2] = []
		for r: Rect2 in rects:
			if xm >= r.position.x and xm <= r.end.x:
				intervals.append(Vector2(r.position.y, r.end.y))
		if intervals.is_empty():
			continue
		intervals.sort_custom(func(a: Vector2, b: Vector2) -> bool: return a.x < b.x)
		var merged: float = 0.0
		var cur_start: float = intervals[0].x
		var cur_end: float = intervals[0].y
		for j: int in range(1, intervals.size()):
			var iv: Vector2 = intervals[j]
			if iv.x <= cur_end + 0.0000001:
				cur_end = maxf(cur_end, iv.y)
			else:
				merged += cur_end - cur_start
				cur_start = iv.x
				cur_end = iv.y
		merged += cur_end - cur_start
		total += width * merged
	return total


func describe() -> String:
	return "%s — %.0f m^2 over %d rectangle(s), %d encounter socket(s), entry %s, exit %s" % [
		display_name(), footprint_area(), room_count(), encounter_count(),
		str(entry_point_local()), str(exit_point_local()),
	]
