class_name ScaleCalibrationGeometry
extends Node3D
## First-MVP Gate 1A — the Scale Calibration Hall's architecture.
##
## One broad rectangular developer space assembled from the registered KayKit
## dungeon kit, with its own explicit box collision, exactly as the accepted
## Prototype Zero calibration room does. NO asset was downloaded, extracted, or
## added for it: `floor_tile_large`, `wall`, and `wall_pillar` are the same three
## pieces Gate A imported, and everything else — rails, thresholds, ground
## markers, the half-wall barrier — is project-authored primitive geometry.
##
## Measured kit dimensions, from the imported glTF rather than assumed
## (assets/third_party/kaykit/SOURCE_AND_LICENSE.md §3.3):
##
##   floor_tile_large   4.000 x 4.000 footprint, top surface at local y = +0.05
##   wall               4.000 wide x 1.000 deep x 4.000 tall, centred on origin
##   wall_pillar        4.000 wide x 1.500 deep x 4.000 tall, centred on origin
##
## EVERY DIMENSION REPORTED BY THIS NODE IS MEASURED FROM THE BUILT WORLD, not
## repeated from the target that asked for it. `_solids` records the exact
## collision box of every piece of architecture as it is added, and the gate and
## clear-floor measurements scan those boxes for the free span around a probe
## point. That is why the overlay and the report can state an ACTUAL clear width:
## if a wall is one centimetre out of place, the number moves.
##
## The hall is a temporary developer instrument. It is not a Bastion room, it is
## not canonical, and it carries no story, encounter, or reward.

const FLOOR_TILE: String = "res://assets/third_party/kaykit/dungeon/floor_tile_large.gltf"
const WALL: String = "res://assets/third_party/kaykit/dungeon/wall.gltf"
const WALL_PILLAR: String = "res://assets/third_party/kaykit/dungeon/wall_pillar.gltf"

const TILE_SIZE: float = 4.0
const TILE_TOP_OFFSET: float = 0.05  ## floor_tile_large top surface, local y
const WALL_DEPTH: float = 1.0
const WALL_HEIGHT: float = 4.0
const PILLAR_DEPTH: float = 1.5

## Layer 1 is "world": floor, walls, partitions, pillar, wall section, and the
## half-wall. Click raycasts, character collision, and the navigation bake all
## read this one layer, exactly as in Prototype Zero.
const WORLD_LAYER: int = 1

# --- Authored layout ----------------------------------------------------------
#
# 13 x 8 floor modules = 52.0 x 32.0 m of floor, 50.0 x 30.0 m of it clear of the
# walls. The §4.1 target is 64P x 36P = 51.2 x 28.8 m; on a 4.000 m module the
# closest achievable pair IS 50.0 x 30.0, which is 1.2 m — 0.3 of one module —
# from the target on each axis, inside the "at most one coherent floor module"
# allowance. The alternatives are 46.0 / 54.0 and 26.0, all further away.

const TILES_X: int = 13
const TILES_Z: int = 8

## The straight west-to-east through-route. It passes the entrance threshold, the
## 4P stress gate, the 10P broad connector, the close ordinary lane, and the exit
## threshold without a single turn, which is what makes it read as a spine rather
## than as a corridor.
const SPINE_Z: float = -5.4

## The two doorway-test partitions, as X positions of their wall centres.
const PARTITION_ONE_X: float = -16.0
const PARTITION_TWO_X: float = -11.0

## Combat-lane extent along the hall's long axis.
const LANE_FROM_X: float = -10.5
const LANE_TO_X: float = 7.0
## The rail that bounds the close ordinary lane against the broad formation lane.
const CLOSE_LANE_RAIL_Z: float = -3.8
const BROAD_LANE_RAIL_Z: float = -2.6

## The eastern block: ranged gallery, occlusion test, telegraph and hazard court.
const EAST_BLOCK_FROM_X: float = 7.0
const RANGED_AXIS_Z: float = -12.0
const RANGED_ORIGIN_X: float = 8.0

const PILLAR_AT: Vector2 = Vector2(10.0, -1.0)
const WALL_SECTION_AT: Vector2 = Vector2(16.0, -3.0)
const HALF_WALL_AT: Vector2 = Vector2(16.0, 1.0)
const HALF_WALL_SIZE: Vector3 = Vector3(4.0, 1.2, 0.8)

const MAULER_ARC_AT: Vector2 = Vector2(10.5, 9.0)
const CINDER_SEAL_AT: Vector2 = Vector2(20.5, 9.0)
## The Mauler's commitment points along +X, toward the Cinder Seal, so the two
## footprints are judged against each other and against the escape space between.
const MAULER_ARC_FACING_DEGREES: float = 0.0

const PLAYER_SPAWN: Vector2 = Vector2(-21.0, SPINE_Z)
## Where the six-strong surround group stands, inside the broad formation lane.
const SURROUND_CENTRE: Vector2 = Vector2(-2.0, 7.0)
## The single Graveblade-sized reference silhouette, inside the close lane.
const REFERENCE_SILHOUETTE_AT: Vector2 = Vector2(-4.0, -9.0)

@export var data: ScaleCalibrationData
@export var grid_visible: bool = false

var _visuals: Node3D
var _collision: StaticBody3D
var _obstacles: Node3D
var _grid: MeshInstance3D

## Every world-layer collision box this node added, in hall-local space, so the
## measurements below read the built world rather than the authored intent.
var _solids: Array[Dictionary] = []
## Non-colliding measurement geometry (lane rails, thresholds), recorded the same
## way, because a lane bounded by a rail on one side is still measured from a
## real object that exists on screen.
var _markers: Dictionary = {}


func _ready() -> void:
	if data == null:
		data = load("res://data/first_mvp/calibration/scale_calibration.tres") as ScaleCalibrationData
	var problem: String = data.problem()
	assert(problem.is_empty(), "ScaleCalibrationGeometry: %s" % problem)
	_build()


# --- Measured geometry --------------------------------------------------------

## Full floor extent, walls included.
func floor_extent() -> Vector2:
	return Vector2(float(TILES_X) * TILE_SIZE, float(TILES_Z) * TILE_SIZE)


## The clear playable floor inside the wall faces, MEASURED from the four outer
## wall collision boxes rather than recomputed from the tile count.
func clear_extent() -> Vector2:
	var north: Dictionary = _solid("WallNorth")
	var south: Dictionary = _solid("WallSouth")
	var west: Dictionary = _solid("WallWest")
	var east: Dictionary = _solid("WallEast")
	if north.is_empty() or south.is_empty() or west.is_empty() or east.is_empty():
		return floor_extent() - Vector2(WALL_DEPTH, WALL_DEPTH) * 2.0
	var box_west: AABB = west["aabb"]
	var box_east: AABB = east["aabb"]
	var box_north: AABB = north["aabb"]
	var box_south: AABB = south["aabb"]
	return Vector2(
		box_east.position.x - box_west.end.x,
		box_south.position.z - box_north.end.z
	)


func clear_half_extent() -> Vector2:
	return clear_extent() * 0.5


func clear_area() -> float:
	var extent: Vector2 = clear_extent()
	return extent.x * extent.y


func contains_point(point: Vector3, margin: float = 0.0) -> bool:
	var half: Vector2 = clear_half_extent()
	return absf(point.x) <= half.x + margin and absf(point.z) <= half.y + margin


## The maximal free span along Z at a given X, around a probe point. This is the
## measurement behind every gate width: it asks the built collision boxes where
## the solid geometry actually is.
func free_span_z(at_x: float, probe_z: float) -> Vector2:
	var low: float = -clear_half_extent().y
	var high: float = clear_half_extent().y
	for solid: Dictionary in _solids:
		var box: AABB = solid["aabb"]
		if String(solid["name"]) == "Floor":
			continue
		if at_x < box.position.x - 0.0001 or at_x > box.end.x + 0.0001:
			continue
		if probe_z >= box.position.z and probe_z <= box.end.z:
			return Vector2(probe_z, probe_z)  # the probe is inside solid geometry
		if box.end.z <= probe_z:
			low = maxf(low, box.end.z)
		elif box.position.z >= probe_z:
			high = minf(high, box.position.z)
	return Vector2(low, high)


## The same measurement along X.
func free_span_x(at_z: float, probe_x: float) -> Vector2:
	var low: float = -clear_half_extent().x
	var high: float = clear_half_extent().x
	for solid: Dictionary in _solids:
		var box: AABB = solid["aabb"]
		if String(solid["name"]) == "Floor":
			continue
		if at_z < box.position.z - 0.0001 or at_z > box.end.z + 0.0001:
			continue
		if probe_x >= box.position.x and probe_x <= box.end.x:
			return Vector2(probe_x, probe_x)
		if box.end.x <= probe_x:
			low = maxf(low, box.end.x)
		elif box.position.x >= probe_x:
			high = minf(high, box.position.x)
	return Vector2(low, high)


## The four §4.2 gates, each with its target and its MEASURED clear width.
func gate_records() -> Array[Dictionary]:
	var records: Array[Dictionary] = []
	for authored: Dictionary in _authored_gates():
		var span: Vector2 = free_span_z(float(authored["at_x"]), float(authored["probe_z"]))
		records.append({
			"name": authored["name"],
			"meaning": authored["meaning"],
			"target_p": authored["target_p"],
			"target_metres": data.metres_for_p(float(authored["target_p"])),
			"measured_metres": span.y - span.x,
			"measured_p": data.p_for_metres(span.y - span.x),
			"span": span,
			"centre": Vector3(float(authored["at_x"]), 0.0, (span.x + span.y) * 0.5),
			"traversal_from": Vector3(float(authored["at_x"]) - 2.5, 0.0, (span.x + span.y) * 0.5),
			"traversal_to": Vector3(float(authored["at_x"]) + 2.5, 0.0, (span.x + span.y) * 0.5),
		})
	return records


func _authored_gates() -> Array[Dictionary]:
	return [
		{
			"name": "stress gate", "meaning": "deliberate lower-bound comparison",
			"target_p": data.stress_gate_p, "at_x": PARTITION_ONE_X, "probe_z": -5.4,
		},
		{
			"name": "ordinary connector", "meaning": "ordinary traversal candidate",
			"target_p": data.ordinary_connector_p, "at_x": PARTITION_ONE_X, "probe_z": 4.6,
		},
		{
			"name": "broad connector", "meaning": "comfortable combat-facing connection",
			"target_p": data.broad_connector_p, "at_x": PARTITION_TWO_X, "probe_z": -5.0,
		},
		{
			"name": "major gate", "meaning": "broad entrance/exit and formation threshold",
			"target_p": data.major_gate_p, "at_x": PARTITION_TWO_X, "probe_z": 9.4,
		},
	]


## The two §4.2 combat lanes. Each is bounded by one outer wall face and one
## visible rail, and its width is measured between those two real objects.
func lane_records() -> Array[Dictionary]:
	var south_wall: AABB = _solid("WallSouth")["aabb"]
	var north_wall: AABB = _solid("WallNorth")["aabb"]
	var close_rail: AABB = _markers["CloseLaneRail"]
	var broad_rail: AABB = _markers["BroadLaneRail"]
	return [
		{
			"name": "close ordinary lane",
			"meaning": "narrow end of ordinary combat space",
			"target_p": data.close_lane_p,
			"target_metres": data.metres_for_p(data.close_lane_p),
			"measured_metres": close_rail.position.z - north_wall.end.z,
			"measured_p": data.p_for_metres(close_rail.position.z - north_wall.end.z),
			"from_z": north_wall.end.z,
			"to_z": close_rail.position.z,
			"centre": Vector3(
				(LANE_FROM_X + LANE_TO_X) * 0.5, 0.0,
				(north_wall.end.z + close_rail.position.z) * 0.5
			),
		},
		{
			"name": "broad formation lane",
			"meaning": "multi-enemy and lateral-movement comparison",
			"target_p": data.broad_lane_p,
			"target_metres": data.metres_for_p(data.broad_lane_p),
			"measured_metres": south_wall.position.z - broad_rail.end.z,
			"measured_p": data.p_for_metres(south_wall.position.z - broad_rail.end.z),
			"from_z": broad_rail.end.z,
			"to_z": south_wall.position.z,
			"centre": Vector3(
				(LANE_FROM_X + LANE_TO_X) * 0.5, 0.0,
				(broad_rail.end.z + south_wall.position.z) * 0.5
			),
		},
	]


func occluder_records() -> Array[Dictionary]:
	var records: Array[Dictionary] = []
	for solid_name: String in ["OcclusionPillar", "OcclusionWallSection", "OcclusionHalfWall"]:
		var solid: Dictionary = _solid(solid_name)
		if solid.is_empty():
			continue
		var box: AABB = solid["aabb"]
		records.append({
			"name": solid_name,
			"size": box.size,
			"centre": box.get_center(),
		})
	return records


func spine_z() -> float:
	return SPINE_Z


func entrance_point() -> Vector3:
	return Vector3(-clear_half_extent().x + 1.5, 0.0, SPINE_Z)


func exit_point() -> Vector3:
	return Vector3(clear_half_extent().x - 1.5, 0.0, SPINE_Z)


func player_spawn() -> Vector3:
	return Vector3(PLAYER_SPAWN.x, 0.0, PLAYER_SPAWN.y)


func _solid(solid_name: String) -> Dictionary:
	for solid: Dictionary in _solids:
		if String(solid["name"]) == solid_name:
			return solid
	return {}


# --- Construction -------------------------------------------------------------

func _build() -> void:
	for child: Node in get_children():
		child.free()
	_solids.clear()
	_markers.clear()

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

	# Structural invariants of the authored layout, asserted rather than trusted:
	# every eastern-block fixture really is east of the combat court, and the
	# lanes really are west of the eastern block.
	assert(RANGED_ORIGIN_X >= EAST_BLOCK_FROM_X and PILLAR_AT.x >= EAST_BLOCK_FROM_X
		and WALL_SECTION_AT.x >= EAST_BLOCK_FROM_X and HALF_WALL_AT.x >= EAST_BLOCK_FROM_X
		and MAULER_ARC_AT.x >= EAST_BLOCK_FROM_X and CINDER_SEAL_AT.x >= EAST_BLOCK_FROM_X,
		"an eastern-block fixture sits inside the combat court")
	assert(LANE_TO_X <= EAST_BLOCK_FROM_X,
		"the combat lanes overlap the eastern block")

	_build_void_plane()
	_build_floor()
	_build_outer_walls()
	_build_outer_collision()
	_build_partitions()
	_build_occluders()
	_build_lane_rails()
	_build_thresholds_and_spine()
	_build_grid()


## A large unlit dark plane well below the wall tops, so the hall does not sit in
## visible void at a camera that sees several metres past the far wall.
func _build_void_plane() -> void:
	var plane: MeshInstance3D = MeshInstance3D.new()
	plane.name = "VoidGround"
	var mesh: PlaneMesh = PlaneMesh.new()
	mesh.size = Vector2(400.0, 400.0)
	plane.mesh = mesh
	var material: StandardMaterial3D = StandardMaterial3D.new()
	material.albedo_color = Color(0.062, 0.068, 0.080)
	material.roughness = 1.0
	material.specular_mode = BaseMaterial3D.SPECULAR_DISABLED
	plane.material_override = material
	plane.position = Vector3(0.0, -0.06, 0.0)
	plane.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	_visuals.add_child(plane)


func _build_floor() -> void:
	var tile: PackedScene = load(FLOOR_TILE) as PackedScene
	var origin: Vector2 = _grid_origin()
	for ix: int in TILES_X:
		for iz: int in TILES_Z:
			var node: Node3D = tile.instantiate() as Node3D
			node.name = "Floor_%d_%d" % [ix, iz]
			node.position = Vector3(
				origin.x + float(ix) * TILE_SIZE,
				-TILE_TOP_OFFSET,
				origin.y + float(iz) * TILE_SIZE
			)
			_visuals.add_child(node)


func _build_outer_walls() -> void:
	var wall: PackedScene = load(WALL) as PackedScene
	var half: Vector2 = floor_extent() * 0.5
	var wall_centre: float = WALL_DEPTH * 0.5

	for ix: int in TILES_X:
		var x: float = _grid_origin().x + float(ix) * TILE_SIZE
		_add_wall_piece(wall, "WallNorth_%d" % ix, Vector3(x, 0.0, -half.y + wall_centre), 0.0)
		_add_wall_piece(wall, "WallSouth_%d" % ix, Vector3(x, 0.0, half.y - wall_centre), PI)

	# The side walls overlap the end walls in the corner squares. A 1 cm drop
	# keeps their wall-top faces from being coplanar there; it is invisible at any
	# play distance and never touches collision, which uses exact boxes.
	for iz: int in TILES_Z:
		var z: float = _grid_origin().y + float(iz) * TILE_SIZE
		_add_wall_piece(wall, "WallWest_%d" % iz, Vector3(-half.x + wall_centre, -0.01, z), PI * 0.5)
		_add_wall_piece(wall, "WallEast_%d" % iz, Vector3(half.x - wall_centre, -0.01, z), -PI * 0.5)


func _add_wall_piece(scene: PackedScene, node_name: String, at: Vector3, yaw: float) -> void:
	var node: Node3D = scene.instantiate() as Node3D
	node.name = node_name
	node.position = at
	node.rotation = Vector3(0.0, yaw, 0.0)
	_visuals.add_child(node)


func _build_outer_collision() -> void:
	var full: Vector2 = floor_extent()
	var half: Vector2 = full * 0.5
	var wall_y: float = WALL_HEIGHT * 0.5

	_add_solid("Floor", Vector3(full.x, 0.4, full.y), Vector3(0.0, -0.2, 0.0))
	_add_solid("WallNorth", Vector3(full.x, WALL_HEIGHT, WALL_DEPTH),
		Vector3(0.0, wall_y, -half.y + WALL_DEPTH * 0.5))
	_add_solid("WallSouth", Vector3(full.x, WALL_HEIGHT, WALL_DEPTH),
		Vector3(0.0, wall_y, half.y - WALL_DEPTH * 0.5))
	_add_solid("WallWest", Vector3(WALL_DEPTH, WALL_HEIGHT, full.y),
		Vector3(-half.x + WALL_DEPTH * 0.5, wall_y, 0.0))
	_add_solid("WallEast", Vector3(WALL_DEPTH, WALL_HEIGHT, full.y),
		Vector3(half.x - WALL_DEPTH * 0.5, wall_y, 0.0))


## The two doorway-test partitions. Each is a run of whole 4 m wall pieces with
## authored gaps; the gaps ARE the gates, and their widths are then measured back
## off the collision boxes rather than trusted.
func _build_partitions() -> void:
	var half: Vector2 = clear_half_extent()
	_build_partition("PartitionOne", PARTITION_ONE_X, [
		Vector2(-half.y, -7.0), Vector2(-3.8, 2.2), Vector2(7.0, half.y),
	])
	_build_partition("PartitionTwo", PARTITION_TWO_X, [
		Vector2(-half.y, -9.0), Vector2(-1.0, 3.8),
	])


func _build_partition(partition_name: String, at_x: float, segments: Array) -> void:
	var wall: PackedScene = load(WALL) as PackedScene
	var index: int = 0
	for segment: Vector2 in segments:
		var length: float = segment.y - segment.x
		assert(length >= TILE_SIZE - 0.0001,
			"%s segment %.2f m is shorter than one %.2f m wall piece" % [
				partition_name, length, TILE_SIZE])
		var pieces: int = int(ceil(length / TILE_SIZE - 0.0001))
		for piece: int in pieces:
			var t: float = 0.0 if pieces == 1 else float(piece) / float(pieces - 1)
			var centre_z: float = lerpf(
				segment.x + TILE_SIZE * 0.5, segment.y - TILE_SIZE * 0.5, t
			)
			# Overlapping pieces inside one run would z-fight on their coplanar
			# faces; a 1 cm alternation removes that without touching collision.
			var drop: float = -0.01 if piece % 2 == 1 else 0.0
			_add_wall_piece(
				wall, "%s_%d_%d" % [partition_name, index, piece],
				Vector3(at_x, drop, centre_z), PI * 0.5
			)
		_add_solid(
			"%s_%d" % [partition_name, index],
			Vector3(WALL_DEPTH, WALL_HEIGHT, length),
			Vector3(at_x, WALL_HEIGHT * 0.5, (segment.x + segment.y) * 0.5)
		)
		index += 1


## Specification §6.4: one full-height pillar, one wall section, and one
## half-wall or barrier. The first two are registered KayKit pieces; the
## half-wall is project-authored primitive geometry, because the registered kit
## holds no half-height barrier and Gate 1A authorizes no new asset.
func _build_occluders() -> void:
	var pillar: Node3D = (load(WALL_PILLAR) as PackedScene).instantiate() as Node3D
	pillar.name = "OcclusionPillarVisual"
	pillar.position = Vector3(PILLAR_AT.x, 0.0, PILLAR_AT.y)
	_visuals.add_child(pillar)
	_add_solid("OcclusionPillar", Vector3(TILE_SIZE, WALL_HEIGHT, PILLAR_DEPTH),
		Vector3(PILLAR_AT.x, WALL_HEIGHT * 0.5, PILLAR_AT.y))

	var section: Node3D = (load(WALL) as PackedScene).instantiate() as Node3D
	section.name = "OcclusionWallSectionVisual"
	section.position = Vector3(WALL_SECTION_AT.x, 0.0, WALL_SECTION_AT.y)
	_visuals.add_child(section)
	_add_solid("OcclusionWallSection", Vector3(TILE_SIZE, WALL_HEIGHT, WALL_DEPTH),
		Vector3(WALL_SECTION_AT.x, WALL_HEIGHT * 0.5, WALL_SECTION_AT.y))

	var barrier: MeshInstance3D = MeshInstance3D.new()
	barrier.name = "OcclusionHalfWallVisual"
	var box: BoxMesh = BoxMesh.new()
	box.size = HALF_WALL_SIZE
	barrier.mesh = box
	barrier.material_override = _stone_material(Color(0.235, 0.247, 0.278))
	barrier.position = Vector3(HALF_WALL_AT.x, HALF_WALL_SIZE.y * 0.5, HALF_WALL_AT.y)
	_visuals.add_child(barrier)
	_add_solid("OcclusionHalfWall", HALF_WALL_SIZE,
		Vector3(HALF_WALL_AT.x, HALF_WALL_SIZE.y * 0.5, HALF_WALL_AT.y))


## The lane boundaries. They are real, visible objects — a low rail with a post
## at each end — and they carry NO collision, deliberately: a lane the player
## cannot step out of would turn the ordinary combat court into the chain of
## boxes specification §4.2 forbids, and it would change a locomotion result the
## hall is supposed to be measuring.
func _build_lane_rails() -> void:
	# `outward` places the rail body just OUTSIDE the lane it bounds, so the lane
	# boundary is the rail's own inner face rather than its centre line and the
	# measured width is a distance between two real surfaces.
	_add_rail("CloseLaneRail", CLOSE_LANE_RAIL_Z, 1.0, Color(0.83, 0.56, 0.30))
	_add_rail("BroadLaneRail", BROAD_LANE_RAIL_Z, -1.0, Color(0.52, 0.63, 0.76))


func _add_rail(rail_name: String, boundary_z: float, outward: float, colour: Color) -> void:
	const RAIL_WIDTH: float = 0.25
	var length: float = LANE_TO_X - LANE_FROM_X
	var centre_x: float = (LANE_FROM_X + LANE_TO_X) * 0.5
	var centre_z: float = boundary_z + outward * RAIL_WIDTH * 0.5

	var rail: MeshInstance3D = MeshInstance3D.new()
	rail.name = rail_name
	var box: BoxMesh = BoxMesh.new()
	box.size = Vector3(length, 0.12, RAIL_WIDTH)
	rail.mesh = box
	rail.material_override = _flat_material(colour, 1.0)
	rail.position = Vector3(centre_x, 0.06, centre_z)
	rail.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	_visuals.add_child(rail)

	for end_x: float in [LANE_FROM_X, LANE_TO_X]:
		var post: MeshInstance3D = MeshInstance3D.new()
		post.name = "%s_Post_%d" % [rail_name, int(end_x)]
		var post_mesh: BoxMesh = BoxMesh.new()
		post_mesh.size = Vector3(RAIL_WIDTH, 1.10, RAIL_WIDTH)
		post.mesh = post_mesh
		post.material_override = _flat_material(colour, 1.0)
		post.position = Vector3(end_x, 0.55, centre_z)
		post.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
		_visuals.add_child(post)

	_markers[rail_name] = AABB(
		Vector3(LANE_FROM_X, 0.0, centre_z - RAIL_WIDTH * 0.5),
		Vector3(length, 0.12, RAIL_WIDTH)
	)


## The broad entrance and exit thresholds and the straight spine between them.
## The hall is one closed instrument, so the thresholds are marked module
## boundaries rather than passages to a room Gate 1A is not authorized to build.
func _build_thresholds_and_spine() -> void:
	var half: Vector2 = clear_half_extent()
	var width: float = data.metres_for_p(data.major_gate_p)

	for side: Dictionary in [
		{"name": "EntranceThreshold", "x": -half.x + 0.75},
		{"name": "ExitThreshold", "x": half.x - 0.75},
	]:
		var band: MeshInstance3D = MeshInstance3D.new()
		band.name = String(side["name"])
		var box: BoxMesh = BoxMesh.new()
		box.size = Vector3(1.5, 0.06, width)
		band.mesh = box
		band.material_override = _flat_material(Color(0.85, 0.62, 0.36), 0.85)
		band.position = Vector3(float(side["x"]), 0.03, SPINE_Z)
		band.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
		_visuals.add_child(band)
		_markers[String(side["name"])] = AABB(
			Vector3(float(side["x"]) - 0.75, 0.0, SPINE_Z - width * 0.5),
			Vector3(1.5, 0.06, width)
		)

	var spine: MeshInstance3D = MeshInstance3D.new()
	spine.name = "SpineMarker"
	var spine_mesh: BoxMesh = BoxMesh.new()
	spine_mesh.size = Vector3(half.x * 2.0, 0.04, 0.18)
	spine.mesh = spine_mesh
	spine.material_override = _flat_material(Color(0.85, 0.62, 0.36), 0.35)
	spine.position = Vector3(0.0, 0.02, SPINE_Z)
	spine.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	_visuals.add_child(spine)


## A one-metre reference grid over the clear floor, so world scale can be judged
## by eye instead of trusted. Bright lines every five metres.
func _build_grid() -> void:
	var half: Vector2 = clear_half_extent()
	var mesh: ImmediateMesh = ImmediateMesh.new()
	var material: StandardMaterial3D = StandardMaterial3D.new()
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.vertex_color_use_as_albedo = true
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	# MEASURED, from the first rendered evidence run: at alpha 0.18 the metre lines
	# were invisible against the bright KayKit floor, which is the one thing this
	# grid exists to be. Prototype Zero's darker 18 x 14 m room did not show it.
	var minor: Color = Color(0.30, 0.48, 0.68, 0.42)
	var major: Color = Color(0.88, 0.58, 0.26, 0.85)
	var x: float = -half.x
	while x <= half.x + 0.001:
		mesh.surface_set_color(major if is_zero_approx(fmod(absf(x), 5.0)) else minor)
		mesh.surface_add_vertex(Vector3(x, 0.02, -half.y))
		mesh.surface_add_vertex(Vector3(x, 0.02, half.y))
		x += 1.0
	var z: float = -half.y
	while z <= half.y + 0.001:
		mesh.surface_set_color(major if is_zero_approx(fmod(absf(z), 5.0)) else minor)
		mesh.surface_add_vertex(Vector3(-half.x, 0.02, z))
		mesh.surface_add_vertex(Vector3(half.x, 0.02, z))
		z += 1.0
	mesh.surface_end()

	_grid = MeshInstance3D.new()
	_grid.name = "CalibrationGrid"
	_grid.mesh = mesh
	_grid.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	_grid.visible = grid_visible
	_visuals.add_child(_grid)


func _grid_origin() -> Vector2:
	return Vector2(
		-(float(TILES_X) - 1.0) * TILE_SIZE * 0.5,
		-(float(TILES_Z) - 1.0) * TILE_SIZE * 0.5
	)


func _add_solid(solid_name: String, size: Vector3, at: Vector3) -> void:
	var shape: CollisionShape3D = CollisionShape3D.new()
	shape.name = solid_name
	var box: BoxShape3D = BoxShape3D.new()
	box.size = size
	shape.shape = box
	shape.position = at
	_collision.add_child(shape)
	_solids.append({
		"name": solid_name,
		"aabb": AABB(at - size * 0.5, size),
	})
	if solid_name != "Floor":
		_carve_navigation(solid_name, size, at)


## MEASURED DEFECT, and the fix for it. A box collider whose TOP face lies
## outside the bake volume rasterises as an OPEN-TOPPED WELL: Recast fills no
## interiors, so the floor inside the box keeps four metres of clearance above it
## and bakes as a perfectly walkable island sealed inside solid architecture.
## Measured before this fix: the pillar's centre, (10.00, -1.00), answered
## `map_get_closest_point` with itself — distance 0.0000 m — while its own edges
## at z = -1.75 and -0.25 were correctly excluded. A click there would have
## resolved onto ground the character can never reach.
##
## Only the pillar showed it, because the island survives the 0.40 m agent-radius
## erosion on each side only when the box is deeper than 0.80 m: the pillar is
## 1.50 m deep and left 0.70 m of island, while the 1.00 m walls and the 0.80 m
## half-wall left nothing. That makes it a defect that a narrower obstacle hides
## rather than one the shape of this hall avoids.
##
## Every solid except the floor therefore also carves its exact footprint out of
## the baked mesh. The carve is not eroded by the agent radius and the collider
## still is, so the outer boundary is unchanged and only the phantom interior
## goes away.
func _carve_navigation(solid_name: String, size: Vector3, at: Vector3) -> void:
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


func _stone_material(colour: Color) -> StandardMaterial3D:
	var material: StandardMaterial3D = StandardMaterial3D.new()
	material.albedo_color = colour
	material.roughness = 0.95
	material.specular_mode = BaseMaterial3D.SPECULAR_DISABLED
	return material


func _flat_material(colour: Color, alpha: float) -> StandardMaterial3D:
	var material: StandardMaterial3D = StandardMaterial3D.new()
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	material.albedo_color = Color(colour.r, colour.g, colour.b, alpha)
	return material


# --- Runtime toggles ----------------------------------------------------------

func set_grid_visible(value: bool) -> void:
	grid_visible = value
	if _grid != null:
		_grid.visible = value
