class_name BrokenWatchLayout
extends Node3D
## Riftwrought — Gate 1D: Broken Watch, the canonical first combat-and-loot
## space (decision D-217, `design/FIRST_MVP_GATE_1D_BROKEN_WATCH_COMBAT_AND_LOOT_SLICE_SPECIFICATION.md`).
##
## A FIXED authored space outside the procedural room pool, built the SAME way
## Riftfall Landing itself was: project-authored walkable regions and
## collision, with already-registered third-party meshes dressed onto it
## PURELY as non-colliding decoration (CLAUDE.md: "Reuse this pattern for the
## canonical route when it is authorized"). It is a SIBLING of Riftfall
## Landing's own accepted Greybox V2 layout under one shared
## `NavigationRegion3D` (see `broken_watch_slice.gd`), so the whole space bakes
## as one continuous navigation mesh rather than two separately-joined maps.
##
## DELIBERATELY SIMPLE, per the Gate 1D brief: five plain rectangular rooms in
## a single straight chain — no branch, no secret room, no puzzle. A little
## over 1,200 m^2, inside the brief's "approximately 2-3 CF" target measured
## the same way Riftfall Landing's own footprint was (roughly 587 m^2 per CF,
## the Gate B camera-footprint unit the room-library blueprint uses).
##
##   Watch Threshold   (entry, right past Riftfall Landing's Way Out)
##   Guardroom         (first Graveblade encounter — room to reposition)
##   Narrows           (connector)
##   Inner Court       (second, comparable Graveblade encounter)
##   Broken Archway    (exit alcove, toward the unbuilt Nexus Threshold)
##
## FOUR SOCKETS, plain `Marker3D`-equivalent Vector3 accessors exactly as
## Riftfall Landing's own layout exposes its five: `entry()`,
## `first_encounter_spawn()`, `second_encounter_spawn()`,
## `exit_to_nexus_threshold()`. No metadata, no marker class, no resource —
## the same "no fourth thing the running game must understand" discipline
## Riftfall Landing and the Zone Composer both keep.
##
## STRUCTURE VS DRESSING, THE SAME LINE RIFTFALL LANDING DRAWS. Every
## collision-bearing wall is project-authored primitive geometry (`BoxMesh` /
## `BoxShape3D`), each carrying a `NavigationObstacle3D` carve — the Gate 1A
## "open-topped well" lesson: any solid whose top sits inside the bake volume
## must carve its own footprint or it rasterises as a walkable phantom
## interior. Dressing is a SMALL, restrained set of already-registered KayKit
## Dungeon pieces (read from `RiftfallLandingLayout.payload()` and
## `approved_environment_palette.gd`'s `PAYLOADS` — never a new asset, never a
## retyped path) placed as decoration ONLY: no `CollisionShape3D`, no
## `NavigationObstacle3D` of their own. That split is what makes the collision
## geometry easy to reason about and prove watertight while still giving the
## space a "ruined watch garrison" identity beyond flat grey boxes.

const WORLD_LAYER: int = 1
const APPROVED_PALETTE_SCRIPT: String = "res://scripts/environment/approved_environment_palette.gd"

const WALL_THICKNESS: float = 1.5
const WALL_HEIGHT: float = 4.0
const CAP_HEIGHT: float = 2.6

const GROUND_COLOUR: Color = Color(0.700, 0.680, 0.640)
const WALL_COLOUR: Color = Color(0.360, 0.350, 0.360)

## --- The five rooms, a single straight chain. `Rect2` is an XZ footprint:
## `position.x`/`size.x` is world X, `position.y`/`size.y` is world Z — the
## same convention `RiftfallLandingGreyboxLayout` uses, so the two layouts
## read as one coordinate language under their shared `Composition` node.
const WATCH_THRESHOLD: Rect2 = Rect2(Vector2(-3.0, -35.0), Vector2(12.0, 8.0))
const GUARDROOM: Rect2 = Rect2(Vector2(-9.0, -59.0), Vector2(24.0, 24.0))
const NARROWS: Rect2 = Rect2(Vector2(-1.0, -67.0), Vector2(8.0, 8.0))
const INNER_COURT: Rect2 = Rect2(Vector2(-8.0, -87.0), Vector2(22.0, 20.0))
const BROKEN_ARCHWAY: Rect2 = Rect2(Vector2(-1.0, -93.0), Vector2(8.0, 6.0))

const WALKABLE: Array[Rect2] = [WATCH_THRESHOLD, GUARDROOM, NARROWS, INNER_COURT, BROKEN_ARCHWAY]

## --- Sockets, local XZ (pre-`Composition`-yaw, exactly as
## `RiftfallLandingGreyboxLayout`'s own `PLAYER_START`/`WAY_OUT` are stored).
## First-MVP Gameplay J10 (decision D-340): the entry was (3, -33), 1.0 m inside the
## Landing's Watch Breach far cap (a solid at x 1-9, z -34 to -30 in this same frame),
## so a body placed there was pushed 1.40 m out. It now stands 0.75 m past that cap's
## face, clear of it and on the navigation mesh, still inside the Watch Threshold.
const ENTRY_POINT: Vector2 = Vector2(3.0, -34.75)
const FIRST_ENCOUNTER_SPAWN: Vector2 = Vector2(3.0, -47.0)
const SECOND_ENCOUNTER_SPAWN: Vector2 = Vector2(3.0, -77.0)
const EXIT_POINT: Vector2 = Vector2(3.0, -90.0)

## --- Boundary walls: `{rect, height}`. Every side gets a wall EXCEPT where a
## room opens into its neighbour — those gaps are exactly the connecting
## room's own width, so the chain reads as one continuous space rather than a
## string of sealed boxes with doors punched through afterwards.
const BOUNDARY_WALLS: Array[Dictionary] = [
	# Watch Threshold: open north (Riftfall Landing's Way Out) and south
	# (Guardroom); only the two long sides are walled.
	{"rect": Rect2(Vector2(-4.5, -35.0), Vector2(1.5, 8.0)), "height": WALL_HEIGHT},
	{"rect": Rect2(Vector2(9.0, -35.0), Vector2(1.5, 8.0)), "height": WALL_HEIGHT},

	# Guardroom: full west/east; north and south each split around their
	# doorway (Watch Threshold's and Narrows' own widths).
	{"rect": Rect2(Vector2(-10.5, -59.0), Vector2(1.5, 24.0)), "height": WALL_HEIGHT},
	{"rect": Rect2(Vector2(15.0, -59.0), Vector2(1.5, 24.0)), "height": WALL_HEIGHT},
	{"rect": Rect2(Vector2(-9.0, -36.5), Vector2(6.0, 1.5)), "height": WALL_HEIGHT},
	{"rect": Rect2(Vector2(9.0, -36.5), Vector2(6.0, 1.5)), "height": WALL_HEIGHT},
	{"rect": Rect2(Vector2(-9.0, -59.0), Vector2(8.0, 1.5)), "height": WALL_HEIGHT},
	{"rect": Rect2(Vector2(7.0, -59.0), Vector2(8.0, 1.5)), "height": WALL_HEIGHT},

	# Narrows: open north (Guardroom) and south (Inner Court).
	{"rect": Rect2(Vector2(-2.5, -67.0), Vector2(1.5, 8.0)), "height": WALL_HEIGHT},
	{"rect": Rect2(Vector2(7.0, -67.0), Vector2(1.5, 8.0)), "height": WALL_HEIGHT},

	# Inner Court: full west/east; north and south split around Narrows' and
	# Broken Archway's widths.
	{"rect": Rect2(Vector2(-9.5, -87.0), Vector2(1.5, 20.0)), "height": WALL_HEIGHT},
	{"rect": Rect2(Vector2(14.0, -87.0), Vector2(1.5, 20.0)), "height": WALL_HEIGHT},
	{"rect": Rect2(Vector2(-8.0, -68.5), Vector2(7.0, 1.5)), "height": WALL_HEIGHT},
	{"rect": Rect2(Vector2(7.0, -68.5), Vector2(7.0, 1.5)), "height": WALL_HEIGHT},
	{"rect": Rect2(Vector2(-8.0, -87.0), Vector2(7.0, 1.5)), "height": WALL_HEIGHT},
	{"rect": Rect2(Vector2(7.0, -87.0), Vector2(7.0, 1.5)), "height": WALL_HEIGHT},

	# Broken Archway: open north (Inner Court); a low far cap beyond the exit
	# socket, so the room reads as a threshold rather than trailing into void
	# — the unbuilt Nexus Threshold begins past it, and this gate stops here.
	{"rect": Rect2(Vector2(-2.5, -93.0), Vector2(1.5, 6.0)), "height": WALL_HEIGHT},
	{"rect": Rect2(Vector2(7.0, -93.0), Vector2(1.5, 6.0)), "height": WALL_HEIGHT},
	{"rect": Rect2(Vector2(-3.0, -96.0), Vector2(12.0, 2.0)), "height": CAP_HEIGHT},
]

## Restrained edge dressing: registered KayKit Dungeon pieces only, read from
## the two accepted asset records — never a new path. `{key, at, yaw}`, `at`
## local XZ in the same rotated frame as everything else in this file.
## Fourteen instances of eight distinct types — a "ruined watch garrison"
## identity told through a handful of pieces at doorways and corners, not a
## second environment-art pass.
const DRESSING_PLACEMENTS: Array[Dictionary] = [
	# Watch Threshold: the broken frame the player arrives through.
	{"key": "wall_broken", "at": Vector2(-3.6, -34.5), "yaw": 90.0, "source": "d215"},
	{"key": "wall_broken", "at": Vector2(9.6, -34.5), "yaw": 90.0, "source": "d215"},

	# Guardroom: pillars flanking the first encounter, one fallen stretch.
	{"key": "pillar", "at": Vector2(-8.0, -46.0), "yaw": 0.0, "source": "d215"},
	{"key": "pillar", "at": Vector2(14.0, -46.0), "yaw": 0.0, "source": "d215"},
	{"key": "rubble_large", "at": Vector2(11.0, -53.0), "yaw": -20.0, "source": "d215"},
	{"key": "column", "at": Vector2(-7.0, -38.0), "yaw": 0.0, "source": "d215"},
	{"key": "banner_shield_red", "at": Vector2(-8.5, -42.0), "yaw": 90.0, "source": "d215"},
	{"key": "torch_mounted", "at": Vector2(13.5, -42.0), "yaw": -90.0, "source": "d215"},

	# Narrows: a pinch dressed with broken masonry either side.
	{"key": "wall_cracked", "at": Vector2(-1.5, -63.0), "yaw": 90.0, "source": "d215"},
	{"key": "rubble_half", "at": Vector2(5.5, -62.0), "yaw": 10.0, "source": "d215"},

	# Inner Court: the second, comparable encounter room.
	{"key": "pillar", "at": Vector2(-7.0, -70.0), "yaw": 0.0, "source": "d215"},
	{"key": "pillar", "at": Vector2(13.0, -70.0), "yaw": 0.0, "source": "d215"},
	{"key": "sword_shield_broken", "at": Vector2(12.5, -83.0), "yaw": -90.0, "source": "d215"},
	{"key": "barrel_large", "at": Vector2(-6.5, -83.0), "yaw": 15.0, "source": "d215"},

	# Broken Archway: the last built stone before the unbuilt route.
	{"key": "wall_endcap", "at": Vector2(6.0, -91.0), "yaw": -90.0, "source": "d215"},
]

var _visuals: Node3D
var _collision: StaticBody3D
var _obstacles: Node3D
var _markers: Node3D
var _dressing: Node3D
var _grid: MeshInstance3D
var grid_visible: bool = false

var _boundary_rects: Array[Rect2] = []
var _dressing_instance_count: int = 0
var _dressing_used_keys: Dictionary = {}


func _ready() -> void:
	_build()


func _build() -> void:
	for child: Node in get_children():
		child.free()
	_boundary_rects.clear()
	_dressing_instance_count = 0
	_dressing_used_keys.clear()

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

	_dressing = Node3D.new()
	_dressing.name = "Dressing"
	add_child(_dressing)

	_build_ground()
	_build_walls()
	_build_dressing()
	_build_sockets()
	_build_grid()


func _build_ground() -> void:
	for rect: Rect2 in WALKABLE:
		var plate: MeshInstance3D = MeshInstance3D.new()
		plate.name = "Ground_%d_%d" % [int(rect.position.x * 10.0), int(rect.position.y * 10.0)]
		var mesh: BoxMesh = BoxMesh.new()
		mesh.size = Vector3(rect.size.x, 0.20, rect.size.y)
		plate.mesh = mesh
		plate.material_override = _lit_material(GROUND_COLOUR)
		plate.position = Vector3(
			rect.position.x + rect.size.x * 0.5, -0.10, rect.position.y + rect.size.y * 0.5
		)
		_visuals.add_child(plate)
		_add_ground_collision(plate.name, Vector3(rect.size.x, 0.20, rect.size.y), plate.position)


func _build_walls() -> void:
	for entry: Dictionary in BOUNDARY_WALLS:
		var rect: Rect2 = entry["rect"]
		var height: float = float(entry["height"])
		_wall_block(rect, height)


func _wall_block(rect: Rect2, height: float) -> void:
	var name_stem: String = "Wall_%d_%d" % [int(rect.position.x * 10.0), int(rect.position.y * 10.0)]
	var mass: MeshInstance3D = MeshInstance3D.new()
	mass.name = name_stem
	var mesh: BoxMesh = BoxMesh.new()
	mesh.size = Vector3(rect.size.x, height, rect.size.y)
	mass.mesh = mesh
	mass.material_override = _lit_material(WALL_COLOUR)
	mass.position = Vector3(
		rect.position.x + rect.size.x * 0.5, height * 0.5, rect.position.y + rect.size.y * 0.5
	)
	_visuals.add_child(mass)
	_boundary_rects.append(rect)
	_add_solid_with_carve(name_stem, Vector3(rect.size.x, height, rect.size.y), mass.position)


func _build_sockets() -> void:
	_add_socket_marker("BrokenWatchEntry", ENTRY_POINT, Color(0.35, 0.80, 0.95))
	_add_socket_marker("FirstEncounterSpawn", FIRST_ENCOUNTER_SPAWN, Color(0.85, 0.30, 0.28))
	_add_socket_marker("SecondEncounterSpawn", SECOND_ENCOUNTER_SPAWN, Color(0.85, 0.30, 0.28))
	_add_socket_marker("ExitToNexusThreshold", EXIT_POINT, Color(0.90, 0.75, 0.30))


func _add_socket_marker(marker_name: String, at: Vector2, colour: Color) -> void:
	var ring: MeshInstance3D = MeshInstance3D.new()
	ring.name = "%sRing" % marker_name
	var torus: TorusMesh = TorusMesh.new()
	torus.inner_radius = 0.45
	torus.outer_radius = 0.62
	torus.rings = 20
	ring.mesh = torus
	ring.material_override = _unshaded_material(colour, 1.0)
	ring.position = Vector3(at.x, 0.05, at.y)
	ring.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	ring.visible = grid_visible
	_markers.add_child(ring)


func _build_grid() -> void:
	var bounds: Rect2 = bake_rect()
	var mesh: ImmediateMesh = ImmediateMesh.new()
	var material: StandardMaterial3D = StandardMaterial3D.new()
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.vertex_color_use_as_albedo = true
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	var minor: Color = Color(0.20, 0.20, 0.22, 0.35)
	var major: Color = Color(0.35, 0.75, 0.90, 0.75)
	var x: float = floor(bounds.position.x)
	while x <= bounds.position.x + bounds.size.x + 0.001:
		mesh.surface_set_color(major if is_zero_approx(fmod(absf(x), 5.0)) else minor)
		mesh.surface_add_vertex(Vector3(x, 0.02, bounds.position.y))
		mesh.surface_add_vertex(Vector3(x, 0.02, bounds.position.y + bounds.size.y))
		x += 1.0
	var z: float = floor(bounds.position.y)
	while z <= bounds.position.y + bounds.size.y + 0.001:
		mesh.surface_set_color(major if is_zero_approx(fmod(absf(z), 5.0)) else minor)
		mesh.surface_add_vertex(Vector3(bounds.position.x, 0.02, z))
		mesh.surface_add_vertex(Vector3(bounds.position.x + bounds.size.x, 0.02, z))
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


# --- Dressing: registered pieces only, non-colliding --------------------------

func _build_dressing() -> void:
	for entry: Dictionary in DRESSING_PLACEMENTS:
		_place_dressing(String(entry["key"]), entry["at"], float(entry["yaw"]), String(entry["source"]))


func _payload_for(key: String, source: String) -> Dictionary:
	if source == "gate_1c":
		return RiftfallLandingLayout.payload(key)
	var palette: GDScript = load(APPROVED_PALETTE_SCRIPT) as GDScript
	for record: Dictionary in palette.PAYLOADS:
		if String(record["key"]) == key:
			return record
	return {}


func _place_dressing(key: String, at: Vector2, yaw_degrees: float, source: String) -> void:
	var record: Dictionary = _payload_for(key, source)
	assert(not record.is_empty(), "BrokenWatchLayout: unknown dressing key %s (%s)" % [key, source])
	var scene: PackedScene = load(String(record["path"])) as PackedScene
	assert(scene != null, "BrokenWatchLayout: %s failed to load" % record["path"])
	var node: Node3D = scene.instantiate() as Node3D
	node.name = "%s_%d" % [key.replace("-", "_"), _dressing_instance_count]
	_dressing_instance_count += 1
	_dressing.add_child(node)
	_dressing_used_keys[key] = int(_dressing_used_keys.get(key, 0)) + 1

	var yaw: float = deg_to_rad(yaw_degrees)
	var contact: String = String(record.get("contact", "base"))
	if contact == "plant":
		node.position = Vector3(at.x, 0.0, at.y)
		node.rotation = Vector3(0.0, yaw, 0.0)
		return

	# "base": lay the piece by its measured AABB base, never by its bounding
	# box top — the Gate 1B lesson (`floor_dirt`'s pebble AABB) applies to any
	# solid pile just as much as to a flat surface.
	node.rotation = Vector3(0.0, yaw, 0.0)
	var probe_node: Node3D = scene.instantiate() as Node3D
	var measured: Dictionary = ExteriorAssetProbe.measure(probe_node)
	probe_node.free()
	var local_box: AABB = AABB(
		Vector3(measured["centre"].x - measured["size"].x * 0.5, measured["base_offset"],
			measured["centre"].z - measured["size"].z * 0.5),
		measured["size"]
	)
	var rotated: AABB = Transform3D(Basis.from_euler(Vector3(0.0, yaw, 0.0)), Vector3.ZERO) * local_box
	node.position = Vector3(
		at.x - rotated.get_center().x, -rotated.position.y, at.y - rotated.get_center().z
	)


func dressing_instance_count() -> int:
	return _dressing_instance_count


func dressing_used_keys() -> PackedStringArray:
	var keys: PackedStringArray = PackedStringArray()
	for key: String in _dressing_used_keys:
		keys.append(key)
	return keys


# --- Collision helpers ---------------------------------------------------------

func _add_ground_collision(solid_name: String, size: Vector3, at: Vector3) -> void:
	var shape: CollisionShape3D = CollisionShape3D.new()
	shape.name = solid_name
	var box: BoxShape3D = BoxShape3D.new()
	box.size = size
	shape.shape = box
	shape.position = at
	_collision.add_child(shape)


## Every non-ground solid also carves its own footprint out of the baked
## navigation mesh — the Gate 1A "open-topped well" fix every layout in this
## project now follows: a box whose top sits inside the bake volume otherwise
## rasterises as a walkable phantom interior.
func _add_solid_with_carve(solid_name: String, size: Vector3, at: Vector3) -> void:
	var shape: CollisionShape3D = CollisionShape3D.new()
	shape.name = solid_name
	var box: BoxShape3D = BoxShape3D.new()
	box.size = size
	shape.shape = box
	shape.position = at
	_collision.add_child(shape)

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


func _unshaded_material(colour: Color, alpha: float) -> StandardMaterial3D:
	var material: StandardMaterial3D = StandardMaterial3D.new()
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA if alpha < 0.999 else BaseMaterial3D.TRANSPARENCY_DISABLED
	material.albedo_color = Color(colour.r, colour.g, colour.b, alpha)
	return material


# --- Measurement, exact rather than sampled ------------------------------------

static func _rect_union_area(rects: Array[Rect2]) -> float:
	if rects.is_empty():
		return 0.0
	var xs: Array[float] = []
	for r: Rect2 in rects:
		xs.append(r.position.x)
		xs.append(r.position.x + r.size.x)
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
			if xm >= r.position.x and xm <= r.position.x + r.size.x:
				intervals.append(Vector2(r.position.y, r.position.y + r.size.y))
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


func footprint_area() -> float:
	return _rect_union_area(WALKABLE)


func room_count() -> int:
	return WALKABLE.size()


func _overall_bounds() -> Rect2:
	var bounds: Rect2 = WALKABLE[0]
	for rect: Rect2 in WALKABLE:
		bounds = bounds.merge(rect)
	for rect: Rect2 in _boundary_rects:
		bounds = bounds.merge(rect)
	return bounds.grow(2.0)


func bake_rect() -> Rect2:
	return _overall_bounds()


func entry() -> Vector3:
	return global_transform * Vector3(ENTRY_POINT.x, 0.0, ENTRY_POINT.y)


func first_encounter_spawn() -> Vector3:
	return global_transform * Vector3(FIRST_ENCOUNTER_SPAWN.x, 0.0, FIRST_ENCOUNTER_SPAWN.y)


func second_encounter_spawn() -> Vector3:
	return global_transform * Vector3(SECOND_ENCOUNTER_SPAWN.x, 0.0, SECOND_ENCOUNTER_SPAWN.y)


func exit_to_nexus_threshold() -> Vector3:
	return global_transform * Vector3(EXIT_POINT.x, 0.0, EXIT_POINT.y)


func socket_positions() -> Dictionary:
	return {
		"BrokenWatchEntry": entry(),
		"FirstEncounterSpawn": first_encounter_spawn(),
		"SecondEncounterSpawn": second_encounter_spawn(),
		"ExitToNexusThreshold": exit_to_nexus_threshold(),
	}
