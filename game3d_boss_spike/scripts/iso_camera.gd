class_name IsoCamera
extends Node3D

## The fixed orthographic isometric camera for the D-368 gate.
##
## ============================================================================
## THE ACCEPTED PROVISIONAL FRAMING, CARRIED AS THE STARTING POINT
##   The owner's instruction: "Keep the accepted provisional camera framing as
##   the starting point." These are the D-366 values the owner reviewed live and
##   judged right at D-367 -- and D-367 is explicit that PRAISE IS NOT A LOCK.
##   Pitch -52 deg, yaw 45 deg, orthographic size 14.0 m, bounds 11.0-18.0 m.
##   ALL OF THEM REMAIN PROVISIONAL. This gate changes none of them and locks
##   none of them.
## ============================================================================
##
## ROTATION IS RE-ASSERTED EVERY FRAME, on purpose. A fixed isometric camera
## that is merely SET once can be rotated later by a parent, a tween, a follow
## routine or a stray line, and the defect would only ever show up in a
## rendered frame. Re-asserting it makes the guarantee structural, and the
## verification suite samples the basis at rest, while moving, while zooming,
## during every attack and during the phase transition.

var cam: Camera3D
var ortho_size: float = GateConfig.CAM_SIZE_DEFAULT
var target: Node3D

## Test seam: lets the suite supply a cursor ray without a real mouse. MUST be
## null in normal play, and the suite asserts that it is.
var debug_cursor_override = null

var _follow: Vector3 = Vector3.ZERO
var _bounds_hit_min: bool = false
var _bounds_hit_max: bool = false

func setup(follow: Node3D) -> void:
	target = follow
	name = "IsoCameraRig"
	cam = Camera3D.new()
	cam.name = "IsoCamera"
	cam.projection = Camera3D.PROJECTION_ORTHOGONAL
	cam.size = ortho_size
	cam.near = 0.05
	cam.far = 250.0
	cam.position = Vector3(0, 0, GateConfig.CAM_BOOM_DISTANCE)
	add_child(cam)
	if target != null:
		_follow = target.global_position
	_assert_rotation()

func _assert_rotation() -> void:
	# Yaw then pitch, in that order, every frame.
	rotation = Vector3.ZERO
	rotate_y(deg_to_rad(GateConfig.CAM_YAW_DEG))
	rotate_object_local(Vector3.RIGHT, deg_to_rad(GateConfig.CAM_PITCH_DEG))
	rotate_object_local(Vector3.FORWARD, deg_to_rad(GateConfig.CAM_ROLL_DEG))

func _process(delta: float) -> void:
	if target != null and is_instance_valid(target):
		_follow = _follow.lerp(target.global_position,
			clampf(delta * GateConfig.CAM_FOLLOW_LAG, 0.0, 1.0))
	global_position = _follow
	_assert_rotation()
	if cam != null:
		cam.size = ortho_size

## Gentle, BOUNDED zoom. Both bounds are reachable, and input beyond a bound
## cannot pass it -- an unreachable bound is not a guard, and a bound that can
## be exceeded is not a bound.
func zoom(steps: float) -> void:
	ortho_size = clampf(ortho_size + steps * GateConfig.CAM_ZOOM_STEP,
		GateConfig.CAM_SIZE_MIN, GateConfig.CAM_SIZE_MAX)
	if is_equal_approx(ortho_size, GateConfig.CAM_SIZE_MIN):
		_bounds_hit_min = true
	if is_equal_approx(ortho_size, GateConfig.CAM_SIZE_MAX):
		_bounds_hit_max = true
	if cam != null:
		cam.size = ortho_size

## Places the rig on its target immediately, with no follow lag. Used by the
## evidence captures, where a half-lagged camera would frame the wrong thing.
func snap_to_target() -> void:
	if target != null and is_instance_valid(target):
		_follow = target.global_position
		global_position = _follow
	_assert_rotation()

func bounds_reached() -> Array[bool]:
	return [_bounds_hit_min, _bounds_hit_max]

func basis_signature() -> String:
	# Rounded so float noise does not make an identical basis look different,
	# but tight enough that a real rotation shows up.
	var b := global_transform.basis
	return "%.5f,%.5f,%.5f|%.5f,%.5f,%.5f|%.5f,%.5f,%.5f" % [
		b.x.x, b.x.y, b.x.z, b.y.x, b.y.y, b.y.z, b.z.x, b.z.y, b.z.z]

## The visible world extent at the current zoom, in metres. Exact arithmetic,
## not sampled.
func view_extent_m() -> Vector2:
	var vp := Vector2(float(GateConfig.OUTPUT_WIDTH), float(GateConfig.OUTPUT_HEIGHT))
	var aspect := vp.x / vp.y
	return Vector2(ortho_size * aspect, ortho_size)

## Metres-per-pixel at the current zoom, for the readability measurement.
func metres_per_pixel() -> float:
	return ortho_size / float(GateConfig.OUTPUT_HEIGHT)

## Projects a world point to screen pixels through the LIVE camera.
func project(world_point: Vector3) -> Vector2:
	if cam == null:
		return Vector2.ZERO
	return cam.unproject_position(world_point)

## The ground point under the cursor, on the y=0 plane.
func cursor_ground_point() -> Vector3:
	if debug_cursor_override != null:
		return debug_cursor_override as Vector3
	if cam == null:
		return Vector3.ZERO
	var vp := cam.get_viewport()
	if vp == null:
		return Vector3.ZERO
	var mouse := vp.get_mouse_position()
	var from := cam.project_ray_origin(mouse)
	var dir := cam.project_ray_normal(mouse)
	if absf(dir.y) < 0.0001:
		return Vector3.ZERO
	var t := -from.y / dir.y
	return from + dir * t
