class_name GateCDebugVisuals
extends Node3D
## Prototype Zero — Gate C combat debug drawing (specification §22: "Debug
## toggles may additionally: ... show melee range and release arc").
##
## Draws the Quick Strike reach and release arc around the player, the controller
## soft-target cone at its real TOTAL width, the D-178 in-reach priority ring,
## and a short-lived flash of the arc that a release actually used.
##
## Gate D added the enemy's side of the same picture: the Graveblade's 1.65 m
## reach and 90-degree attack arc, drawn around its COMMITTED direction once it
## commits so the lock is visible, and a hit/miss flash of the arc its release
## actually used. Those two are how a genuine miss can be seen rather than only
## read in a log.
##
## It is development instrumentation: nothing in the player-facing loop depends
## on it, and it is hidden unless the debug overlay is open.

const REACH_COLOUR: Color = Color(0.95, 0.72, 0.35, 0.85)
const CONE_COLOUR: Color = Color(0.45, 0.68, 0.92, 0.55)
## D-178's priority boundary: anything eligible inside this ring is chosen before
## any approach candidate, so the ring is worth being able to see.
const IN_REACH_COLOUR: Color = Color(0.52, 0.86, 0.70, 0.50)
const HIT_COLOUR: Color = Color(0.55, 0.95, 0.60, 0.95)
const MISS_COLOUR: Color = Color(0.92, 0.42, 0.38, 0.95)
const FLASH_SECONDS: float = 0.35

## Gate D. The enemy arc is drawn in two states so the commitment reads: amber
## while it is still tracking, hot orange once the direction is LOCKED.
const ENEMY_TRACKING_COLOUR: Color = Color(0.86, 0.74, 0.36, 0.55)
const ENEMY_COMMITTED_COLOUR: Color = Color(0.98, 0.52, 0.22, 0.95)
const COMMIT_MARK_SECONDS: float = 0.60
## How far outside the live arc the hit/miss flash is drawn, so the two can be
## told apart while the release state is still on screen.
const FLASH_RADIUS_OFFSET: float = 0.18

var _room: Node
var _live: MeshInstance3D
var _flash: MeshInstance3D
var _flash_left: float = 0.0
var _enemy_flash: MeshInstance3D
var _enemy_flash_left: float = 0.0
var _commit_mark_left: float = 0.0


func _ready() -> void:
	_live = _make_view("LiveArcs")
	_flash = _make_view("ReleaseFlash")
	_enemy_flash = _make_view("EnemyReleaseFlash")
	visible = false


func _make_view(node_name: String) -> MeshInstance3D:
	var instance: MeshInstance3D = MeshInstance3D.new()
	instance.name = node_name
	instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	add_child(instance)
	return instance


func bind(room: Node) -> void:
	_room = room


func _process(delta: float) -> void:
	_commit_mark_left = maxf(_commit_mark_left - delta, 0.0)
	if _flash_left > 0.0:
		_flash_left = maxf(_flash_left - delta, 0.0)
		if _flash_left <= 0.0:
			_flash.mesh = null
	if _enemy_flash_left > 0.0:
		_enemy_flash_left = maxf(_enemy_flash_left - delta, 0.0)
		if _enemy_flash_left <= 0.0:
			_enemy_flash.mesh = null


## Release arc, and — on a controller — the soft-target cone at its real
## acquisition distance and TOTAL width plus the D-178 in-reach priority ring,
## all drawn from the same data the queries use. The cone is centred on facing,
## which is the intended direction whenever the stick is neutral and within a
## frame or two of it whenever the stick is driving.
func refresh() -> void:
	if not visible or _room == null:
		return
	var player: PrototypePlayer = _room.player
	var data: QuickStrikeData = player.attack.data
	var origin: Vector3 = player.global_position
	var facing: Vector3 = player.facing_direction()

	var mesh: ImmediateMesh = ImmediateMesh.new()
	mesh.surface_begin(Mesh.PRIMITIVE_LINES, _line_material())
	_arc(mesh, origin, facing, data.reach, data.release_arc_degrees, REACH_COLOUR, true)
	if _room.input_family.family == InputFamilyTracker.Family.CONTROLLER:
		# TOTAL width, straight from the record the query reads: 65 deg, +/-32.5.
		_arc(mesh, origin, facing, data.soft_target_distance,
			data.soft_target_cone_total_degrees(), CONE_COLOUR, true)
		# The full in-reach priority circle, not an arc: the group is decided by
		# distance alone, in every direction.
		_arc(mesh, origin, facing, data.reach, 360.0, IN_REACH_COLOUR, false)
	_draw_enemy(mesh)
	mesh.surface_end()
	_live.mesh = mesh


## Gate D: the Graveblade's own reach and attack arc, centred on the direction it
## will actually strike along. Before the commit that direction still tracks the
## player; after it, it is locked, and the colour change is the visible commitment
## the specification asks for.
func _draw_enemy(mesh: ImmediateMesh) -> void:
	# Gate E: every Graveblade in the roster draws its own arc, so a wave of
	# three shows three commitments rather than one.
	for enemy: PrototypeGraveblade in _room.graveblades:
		if is_instance_valid(enemy):
			_draw_one_enemy(mesh, enemy)


func _draw_one_enemy(mesh: ImmediateMesh, enemy: PrototypeGraveblade) -> void:
	if not enemy.is_alive() or not enemy.is_attacking():
		return
	var enemy_data: GravebladeData = enemy.data
	var colour: Color = ENEMY_COMMITTED_COLOUR if enemy.committed else ENEMY_TRACKING_COLOUR
	_arc(mesh, enemy.global_position, enemy.release_direction,
		enemy_data.attack_reach, enemy_data.attack_arc_degrees, colour, true)
	if not enemy.committed:
		return
	# A single line straight down the committed direction, so the lock is legible
	# even when the arc edges are off screen.
	mesh.surface_set_color(ENEMY_COMMITTED_COLOUR)
	var height: float = enemy.global_position.y + 0.08
	mesh.surface_add_vertex(Vector3(enemy.global_position.x, height, enemy.global_position.z))
	mesh.surface_add_vertex(Vector3(
		enemy.global_position.x + enemy.release_direction.x * enemy_data.attack_reach, height,
		enemy.global_position.z + enemy.release_direction.z * enemy_data.attack_reach))


func show_release(origin: Vector3, facing: Vector3, reach: float, arc_degrees: float, hit: bool) -> void:
	if not visible:
		return
	var mesh: ImmediateMesh = ImmediateMesh.new()
	mesh.surface_begin(Mesh.PRIMITIVE_LINES, _line_material())
	_arc(mesh, origin, facing, reach, arc_degrees, HIT_COLOUR if hit else MISS_COLOUR, true)
	mesh.surface_end()
	_flash.mesh = mesh
	_flash_left = FLASH_SECONDS


## Gate D: the arc an enemy release actually used, green when it connected and
## red when it genuinely missed.
func show_enemy_release(origin: Vector3, direction: Vector3, reach: float, arc_degrees: float, hit: bool) -> void:
	if not visible:
		return
	var mesh: ImmediateMesh = ImmediateMesh.new()
	mesh.surface_begin(Mesh.PRIMITIVE_LINES, _line_material())
	# Drawn a little OUTSIDE the live committed arc. At the same radius the two
	# coincide exactly and the hit/miss colour is invisible underneath the arc
	# still being drawn for the release state.
	_arc(mesh, origin, direction, reach + FLASH_RADIUS_OFFSET, arc_degrees,
		HIT_COLOUR if hit else MISS_COLOUR, true)
	mesh.surface_end()
	_enemy_flash.mesh = mesh
	_enemy_flash_left = FLASH_SECONDS


## Gate D: the instant the enemy locked its release direction. Held briefly so
## the commitment can be seen even at full speed.
func show_enemy_commitment(_direction: Vector3) -> void:
	_commit_mark_left = COMMIT_MARK_SECONDS


func commitment_mark_remaining() -> float:
	return _commit_mark_left


func _line_material() -> StandardMaterial3D:
	var material: StandardMaterial3D = StandardMaterial3D.new()
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	material.vertex_color_use_as_albedo = true
	material.no_depth_test = true
	return material


func _arc(
	mesh: ImmediateMesh, origin: Vector3, facing: Vector3,
	radius: float, total_degrees: float, colour: Color, with_edges: bool
) -> void:
	var centre: float = atan2(facing.x, facing.z)
	var half: float = deg_to_rad(total_degrees * 0.5)
	var height: float = origin.y + 0.06
	var steps: int = maxi(int(total_degrees / 4.0), 8)
	mesh.surface_set_color(colour)
	var previous: Vector3 = Vector3.ZERO
	for i: int in steps + 1:
		var angle: float = centre - half + (2.0 * half) * float(i) / float(steps)
		var point: Vector3 = Vector3(origin.x + sin(angle) * radius, height, origin.z + cos(angle) * radius)
		if i > 0:
			mesh.surface_add_vertex(previous)
			mesh.surface_add_vertex(point)
		previous = point
	if not with_edges:
		return
	for edge: float in [centre - half, centre + half]:
		mesh.surface_add_vertex(Vector3(origin.x, height, origin.z))
		mesh.surface_add_vertex(Vector3(origin.x + sin(edge) * radius, height, origin.z + cos(edge) * radius))
