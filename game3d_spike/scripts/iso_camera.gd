class_name IsoCamera
extends Camera3D

## FIXED ORTHOGRAPHIC ISOMETRIC CAMERA — D-366 feasibility spike.
##
## ROTATION IS LOCKED. It is written once in _ready() and then re-asserted every
## frame against the locked basis, so a stray rotation anywhere in the project
## cannot survive a single frame unnoticed.
##
## ZOOM is player-controlled, gentle and BOUNDED between CAM_SIZE_MIN and
## CAM_SIZE_MAX. Input beyond a bound cannot move past it.
##
## PROVISIONAL. This framing is NOT a lock, and no 2D camera footprint is
## inherited here.

var _locked_basis: Basis
var target: Node3D
var zoom_target: float = SpikeConfig.CAM_SIZE_DEFAULT

# Diagnostics the verification suite reads.
var rotation_violations: int = 0
var zoom_clamp_events: int = 0
var reached_min: bool = false
var reached_max: bool = false

func _ready() -> void:
	projection = Camera3D.PROJECTION_ORTHOGONAL
	size = SpikeConfig.CAM_SIZE_DEFAULT
	zoom_target = SpikeConfig.CAM_SIZE_DEFAULT
	near = 0.05
	far = 200.0
	rotation_degrees = Vector3(
		SpikeConfig.CAM_PITCH_DEG, SpikeConfig.CAM_YAW_DEG, SpikeConfig.CAM_ROLL_DEG)
	_locked_basis = global_transform.basis

func locked_basis() -> Basis:
	return _locked_basis

## Offset from the focus point to the camera.
## A Godot camera looks down its LOCAL -Z, so the camera must sit at
## focus + basis.z * distance to look AT the focus. (Using -basis.z placed the
## camera in front of the target looking away -- caught by rendering the
## evidence and looking at it, which is exactly what that rule is for.)
func boom_offset() -> Vector3:
	return _locked_basis.z * SpikeConfig.CAM_BOOM_DISTANCE

func apply_zoom(delta_steps: float) -> void:
	var before := zoom_target
	zoom_target = clampf(
		zoom_target + delta_steps * SpikeConfig.CAM_ZOOM_STEP,
		SpikeConfig.CAM_SIZE_MIN, SpikeConfig.CAM_SIZE_MAX)
	if not is_equal_approx(before + delta_steps * SpikeConfig.CAM_ZOOM_STEP, zoom_target):
		zoom_clamp_events += 1
	if is_equal_approx(zoom_target, SpikeConfig.CAM_SIZE_MIN):
		reached_min = true
	if is_equal_approx(zoom_target, SpikeConfig.CAM_SIZE_MAX):
		reached_max = true

func snap_to_target() -> void:
	if target != null:
		global_position = target.global_position + boom_offset()
	size = zoom_target

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("spike_zoom_in"):
		apply_zoom(-1.0)
	if Input.is_action_just_pressed("spike_zoom_out"):
		apply_zoom(1.0)

	size = lerpf(size, zoom_target, clampf(delta * 10.0, 0.0, 1.0))
	# Hard bound: smoothing may never carry `size` outside the declared range.
	size = clampf(size, SpikeConfig.CAM_SIZE_MIN, SpikeConfig.CAM_SIZE_MAX)

	if target != null:
		var want := target.global_position + boom_offset()
		global_position = global_position.lerp(
			want, clampf(delta * SpikeConfig.CAM_FOLLOW_LAG, 0.0, 1.0))

	# ROTATION LOCK — re-asserted, then verified, every single frame.
	global_transform.basis = _locked_basis
	if not _basis_matches(global_transform.basis, _locked_basis):
		rotation_violations += 1

static func _basis_matches(a: Basis, b: Basis) -> bool:
	for i in 3:
		if not a[i].is_equal_approx(b[i]):
			return false
	return true

## AN EXPLICIT TEST SEAM. When set, cursor_ground_point() returns this instead
## of querying the mouse, so the verification suite can prove aim and movement
## are independent IN BOTH DIRECTIONS without a physical cursor. It is null in
## normal play and is asserted null by the suite's own final check.
var debug_cursor_override = null

## Cursor -> ground plane (y = 0). This is the aiming query, and it is
## completely independent of movement input.
func cursor_ground_point(fallback: Vector3) -> Vector3:
	if debug_cursor_override != null:
		return debug_cursor_override
	var vp := get_viewport()
	if vp == null:
		return fallback
	var mp := vp.get_mouse_position()
	var from := project_ray_origin(mp)
	var dir := project_ray_normal(mp)
	var hit = Plane(Vector3.UP, 0.0).intersects_ray(from, dir)
	if hit == null:
		return fallback
	return hit
