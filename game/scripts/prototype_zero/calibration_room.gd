class_name CalibrationRoom
extends Node3D
## Prototype Zero — Gate B calibration room.
##
## One clear rectangular room assembled from the registered KayKit dungeon kit,
## with its own explicit box collision and one optional removable barrier.
##
## Every dimension here is a MEASURED PROVISIONAL CALIBRATION VALUE, not final
## first-MVP scale. The kit pieces were measured from the imported glTF, not
## assumed (see assets/third_party/kaykit/SOURCE_AND_LICENSE.md §3.3 and the
## Gate B report):
##
##   floor_tile_large   4.000 x 4.000 footprint, top surface at local y = +0.05
##   wall               4.000 wide x 1.000 deep x 4.000 tall, centred on origin
##   wall_pillar        4.000 wide x 1.500 deep x 4.000 tall, centred on origin
##
## Visual geometry is built from those pieces; collision is built from exact
## boxes that match the visible inner faces, so navigation, physics, and the
## rendered room cannot drift apart.

const FLOOR_TILE: String = "res://assets/third_party/kaykit/dungeon/floor_tile_large.gltf"
const WALL: String = "res://assets/third_party/kaykit/dungeon/wall.gltf"
const WALL_PILLAR: String = "res://assets/third_party/kaykit/dungeon/wall_pillar.gltf"

const TILE_SIZE: float = 4.0
const TILE_TOP_OFFSET: float = 0.05  ## floor_tile_large top surface, local y
const WALL_DEPTH: float = 1.0
const WALL_HEIGHT: float = 4.0
const PILLAR_DEPTH: float = 1.5

## Layer 1 is "world": walls, floor, and the barrier. Click raycasts, character
## collision, and the navigation bake all read this one layer.
const WORLD_LAYER: int = 1

@export_group("Room, in provisional metres")
## Floor tiles along X. 5 tiles = 20 m of floor, 18 m of it clear of walls.
@export var tiles_x: int = 5
## Floor tiles along Z. 4 tiles = 16 m of floor, 14 m of it clear of walls.
@export var tiles_z: int = 4

@export_group("Optional barrier")
## Specification §8: "An optional removable barrier may test click navigation
## around one obstacle, but it cannot become combat clutter." Off by default so
## the first locomotion judgement happens in a genuinely empty room.
@export var barrier_enabled: bool = false
@export var barrier_position: Vector3 = Vector3(-4.5, 0.0, -3.5)

@export_group("Calibration aids")
@export var grid_visible: bool = false

var _visuals: Node3D
var _collision: StaticBody3D
var _barrier_visual: Node3D
var _barrier_body: StaticBody3D
var _grid: MeshInstance3D

signal geometry_changed


func _ready() -> void:
	_build()


# --- Measured geometry -------------------------------------------------------

## Full floor extent, walls included.
func floor_extent() -> Vector2:
	return Vector2(float(tiles_x) * TILE_SIZE, float(tiles_z) * TILE_SIZE)


## The clear playable floor inside the wall faces — the value the specification
## states as "approximately 18 m x 14 m".
func clear_extent() -> Vector2:
	return floor_extent() - Vector2(WALL_DEPTH, WALL_DEPTH) * 2.0


func clear_half_extent() -> Vector2:
	return clear_extent() * 0.5


## True when a planar point lies inside the clear floor, with an optional margin.
func contains_point(point: Vector3, margin: float = 0.0) -> bool:
	var half: Vector2 = clear_half_extent()
	return absf(point.x) <= half.x + margin and absf(point.z) <= half.y + margin


func barrier_aabb() -> AABB:
	return AABB(
		barrier_position - Vector3(TILE_SIZE * 0.5, 0.0, PILLAR_DEPTH * 0.5),
		Vector3(TILE_SIZE, WALL_HEIGHT, PILLAR_DEPTH)
	)


# --- Construction ------------------------------------------------------------

func _build() -> void:
	for child: Node in get_children():
		child.free()

	_visuals = Node3D.new()
	_visuals.name = "Visuals"
	add_child(_visuals)

	_collision = StaticBody3D.new()
	_collision.name = "WorldCollision"
	_collision.collision_layer = WORLD_LAYER
	_collision.collision_mask = 0
	add_child(_collision)

	_build_void_plane()
	_build_floor()
	_build_walls()
	_build_collision()
	_build_grid()
	_apply_barrier()


## A large unlit dark plane well below the wall tops. The camera looks 55 deg
## down and still sees several metres past the far wall; without this the room
## would sit in visible void, which specification §8 forbids.
func _build_void_plane() -> void:
	var plane: MeshInstance3D = MeshInstance3D.new()
	plane.name = "VoidGround"
	var mesh: PlaneMesh = PlaneMesh.new()
	mesh.size = Vector2(220.0, 220.0)
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
	for ix: int in tiles_x:
		for iz: int in tiles_z:
			var node: Node3D = tile.instantiate() as Node3D
			node.name = "Floor_%d_%d" % [ix, iz]
			node.position = Vector3(
				origin.x + float(ix) * TILE_SIZE,
				-TILE_TOP_OFFSET,
				origin.y + float(iz) * TILE_SIZE
			)
			_visuals.add_child(node)


## Walls sit on the outermost metre of the floor, so their inner faces bound the
## clear playable floor exactly.
func _build_walls() -> void:
	var wall: PackedScene = load(WALL) as PackedScene
	var half: Vector2 = floor_extent() * 0.5
	var wall_centre: float = WALL_DEPTH * 0.5

	for ix: int in tiles_x:
		var x: float = _grid_origin().x + float(ix) * TILE_SIZE
		_add_wall(wall, "WallNorth_%d" % ix, Vector3(x, 0.0, -half.y + wall_centre), 0.0)
		_add_wall(wall, "WallSouth_%d" % ix, Vector3(x, 0.0, half.y - wall_centre), PI)

	# The side walls overlap the end walls in the corner squares. A 1 cm drop
	# keeps their wall-top faces from being coplanar there; it is invisible at
	# any play distance and never touches collision, which uses exact boxes.
	for iz: int in tiles_z:
		var z: float = _grid_origin().y + float(iz) * TILE_SIZE
		_add_wall(wall, "WallWest_%d" % iz, Vector3(-half.x + wall_centre, -0.01, z), PI * 0.5)
		_add_wall(wall, "WallEast_%d" % iz, Vector3(half.x - wall_centre, -0.01, z), -PI * 0.5)


func _add_wall(scene: PackedScene, node_name: String, at: Vector3, yaw: float) -> void:
	var node: Node3D = scene.instantiate() as Node3D
	node.name = node_name
	node.position = at
	node.rotation = Vector3(0.0, yaw, 0.0)
	_visuals.add_child(node)


func _build_collision() -> void:
	var full: Vector2 = floor_extent()
	var half: Vector2 = full * 0.5

	_add_box(_collision, "Floor", Vector3(full.x, 0.4, full.y), Vector3(0.0, -0.2, 0.0))
	var wall_y: float = WALL_HEIGHT * 0.5
	_add_box(_collision, "WallNorth", Vector3(full.x, WALL_HEIGHT, WALL_DEPTH),
		Vector3(0.0, wall_y, -half.y + WALL_DEPTH * 0.5))
	_add_box(_collision, "WallSouth", Vector3(full.x, WALL_HEIGHT, WALL_DEPTH),
		Vector3(0.0, wall_y, half.y - WALL_DEPTH * 0.5))
	_add_box(_collision, "WallWest", Vector3(WALL_DEPTH, WALL_HEIGHT, full.y),
		Vector3(-half.x + WALL_DEPTH * 0.5, wall_y, 0.0))
	_add_box(_collision, "WallEast", Vector3(WALL_DEPTH, WALL_HEIGHT, full.y),
		Vector3(half.x - WALL_DEPTH * 0.5, wall_y, 0.0))


func _add_box(body: StaticBody3D, node_name: String, size: Vector3, at: Vector3) -> void:
	var shape: CollisionShape3D = CollisionShape3D.new()
	shape.name = node_name
	var box: BoxShape3D = BoxShape3D.new()
	box.size = size
	shape.shape = box
	shape.position = at
	body.add_child(shape)


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
	var minor: Color = Color(0.45, 0.62, 0.78, 0.20)
	var major: Color = Color(0.85, 0.62, 0.36, 0.55)
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
		-(float(tiles_x) - 1.0) * TILE_SIZE * 0.5,
		-(float(tiles_z) - 1.0) * TILE_SIZE * 0.5
	)


# --- Runtime toggles ---------------------------------------------------------

func set_barrier_enabled(enabled: bool) -> void:
	if enabled == barrier_enabled:
		return
	barrier_enabled = enabled
	_apply_barrier()
	geometry_changed.emit()


func set_grid_visible(visible_now: bool) -> void:
	grid_visible = visible_now
	if _grid != null:
		_grid.visible = visible_now


func _apply_barrier() -> void:
	# Removed from the tree before freeing: the navigation rebake happens in the
	# same frame, and a queued-but-still-parented collider would silently bake
	# the barrier back in.
	if _barrier_visual != null:
		_visuals.remove_child(_barrier_visual)
		_barrier_visual.queue_free()
		_barrier_visual = null
	if _barrier_body != null:
		remove_child(_barrier_body)
		_barrier_body.queue_free()
		_barrier_body = null
	if not barrier_enabled:
		return

	_barrier_visual = (load(WALL_PILLAR) as PackedScene).instantiate() as Node3D
	_barrier_visual.name = "BarrierVisual"
	_barrier_visual.position = barrier_position
	_visuals.add_child(_barrier_visual)

	_barrier_body = StaticBody3D.new()
	_barrier_body.name = "BarrierCollision"
	_barrier_body.collision_layer = WORLD_LAYER
	_barrier_body.collision_mask = 0
	_barrier_body.position = barrier_position
	add_child(_barrier_body)
	_add_box(_barrier_body, "Barrier", Vector3(TILE_SIZE, WALL_HEIGHT, PILLAR_DEPTH),
		Vector3(0.0, WALL_HEIGHT * 0.5, 0.0))
