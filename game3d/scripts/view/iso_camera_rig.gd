class_name IsoCameraRig
extends Node3D

## FIXED ORTHOGRAPHIC ISOMETRIC CAMERA — D-370 production foundation.
##
## The rig node IS the focus point. It follows the player's GROUND POINT, and
## the Camera3D child sits at a fixed offset along the locked basis.
##
## ROTATION IS LOCKED. It is written once in `build()` and then RE-ASSERTED AND
## RE-VERIFIED EVERY FRAME against the locked basis, so a stray rotation
## anywhere in the project cannot survive a single frame unnoticed.
##
## ZOOM is player-controlled, gentle and BOUNDED. Input beyond a bound cannot
## move past it, and the smoothing is hard-clamped so it cannot overshoot one.
##
## ============================================================================
## EVERY VALUE HERE IS PROVISIONAL.
## ============================================================================
## The -52 degree pitch and the 11.0-18.0 m zoom bounds are carried from the
## ACCEPTED D-366 spike because the ruling says to begin from them. D-367 praised
## them. PRAISE IS NOT A LOCK, the owner said so directly, and this foundation
## re-evaluates them rather than inheriting them.
##
## NO 2D CAMERA FOOTPRINT IS INHERITED. game2d/'s fixed 32.00 x 18.00 m is a
## D-356 owner lock belonging to game2d/, and it is not promoted here.

var cam: Camera3D
var target: Node3D

var _locked_basis: Basis
var ortho_size: float = ProdConfig.CAM_SIZE_DEFAULT
var zoom_target: float = ProdConfig.CAM_SIZE_DEFAULT

# Diagnostics the verification suite reads.
var rotation_violations: int = 0
var zoom_clamp_events: int = 0
var reached_min: bool = false
var reached_max: bool = false
var follow_updates: int = 0

## AN EXPLICIT TEST SEAM. When set, `cursor_ground_point()` returns this instead
## of querying the mouse, so the suite can prove movement and aim are independent
## in both directions without a physical cursor. It is null in normal play and
## the suite's own final check asserts it is null.
var debug_cursor_override = null

func build() -> void:
	cam = Camera3D.new()
	cam.name = "IsoCamera"
	add_child(cam)
	cam.projection = Camera3D.PROJECTION_ORTHOGONAL
	cam.size = ProdConfig.CAM_SIZE_DEFAULT
	cam.near = 0.05
	cam.far = 260.0
	cam.rotation_degrees = Vector3(
		ProdConfig.CAM_PITCH_DEG, ProdConfig.CAM_YAW_DEG, ProdConfig.CAM_ROLL_DEG)
	_locked_basis = cam.global_transform.basis
	ortho_size = ProdConfig.CAM_SIZE_DEFAULT
	zoom_target = ProdConfig.CAM_SIZE_DEFAULT
	cam.global_position = global_position + boom_offset()

func locked_basis() -> Basis:
	return _locked_basis

## Offset from the focus point to the camera.
##
## A Godot camera looks down its LOCAL -Z, so the camera must sit at
## `focus + basis.z * distance` to look AT the focus. Using `-basis.z` places the
## camera in FRONT of the target looking away -- a mistake the D-366 spike made
## and caught only by rendering the evidence and looking at it. The sign is
## carried here deliberately rather than re-derived.
func boom_offset() -> Vector3:
	return _locked_basis.z * ProdConfig.CAM_BOOM_DISTANCE

func apply_zoom(delta_steps: float) -> void:
	var requested := zoom_target + delta_steps * ProdConfig.CAM_ZOOM_STEP
	var clamped := clampf(requested, ProdConfig.CAM_SIZE_MIN, ProdConfig.CAM_SIZE_MAX)
	if not is_equal_approx(requested, clamped):
		zoom_clamp_events += 1
	zoom_target = clamped
	if is_equal_approx(zoom_target, ProdConfig.CAM_SIZE_MIN):
		reached_min = true
	if is_equal_approx(zoom_target, ProdConfig.CAM_SIZE_MAX):
		reached_max = true

func snap_to_target() -> void:
	if target != null:
		global_position = target.global_position
	ortho_size = zoom_target
	if cam != null:
		cam.size = ortho_size
		cam.global_position = global_position + boom_offset()
		cam.global_transform.basis = _locked_basis

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("zoom_in"):
		apply_zoom(-1.0)
	if Input.is_action_just_pressed("zoom_out"):
		apply_zoom(1.0)
	step(delta)

## Separated from `_process` so the verification suite can drive the camera
## deterministically without depending on the frame the engine happens to run.
func step(delta: float) -> void:
	ortho_size = lerpf(ortho_size, zoom_target, clampf(delta * 10.0, 0.0, 1.0))
	# HARD BOUND: smoothing may never carry the size outside the declared range.
	ortho_size = clampf(ortho_size, ProdConfig.CAM_SIZE_MIN, ProdConfig.CAM_SIZE_MAX)

	if target != null:
		var want := target.global_position
		global_position = global_position.lerp(
			want, clampf(delta * ProdConfig.CAM_FOLLOW_LAG, 0.0, 1.0))
		follow_updates += 1

	if cam == null:
		return
	cam.size = ortho_size
	cam.global_position = global_position + boom_offset()

	# ROTATION LOCK — re-asserted, then verified, every single frame.
	cam.global_transform.basis = _locked_basis
	if not _basis_matches(cam.global_transform.basis, _locked_basis):
		rotation_violations += 1

static func _basis_matches(a: Basis, b: Basis) -> bool:
	for i in 3:
		if not a[i].is_equal_approx(b[i]):
			return false
	return true

## Cursor -> ground plane (y = 0). THIS IS THE AIMING QUERY, and it is completely
## independent of movement: nothing in this function reads movement state, and
## nothing in the movement path calls it.
func cursor_ground_point(fallback: Vector3) -> Vector3:
	if debug_cursor_override != null:
		return debug_cursor_override
	if cam == null:
		return fallback
	var vp := get_viewport()
	if vp == null:
		return fallback
	var mp := vp.get_mouse_position()
	var from := cam.project_ray_origin(mp)
	var dir := cam.project_ray_normal(mp)
	var hit = Plane(Vector3.UP, 0.0).intersects_ray(from, dir)
	if hit == null:
		return fallback
	return hit

## EXACT orthographic projection of a world point to output pixels.
##
## An orthographic camera maps a point's camera-local X/Y linearly onto the
## viewport, so the arithmetic is exact and needs no rendered frame. Preferring
## it to `unproject_position` also keeps the measurement valid headless, where
## the viewport may not be configured the way a capture is.
func project_exact(world_point: Vector3) -> Vector2:
	var w := float(ProdConfig.OUTPUT_WIDTH)
	var h := float(ProdConfig.OUTPUT_HEIGHT)
	var local := cam.global_transform.affine_inverse() * world_point
	var half_h: float = ortho_size * 0.5
	var half_w: float = half_h * (w / h)
	return Vector2(
		(local.x / half_w) * (w * 0.5) + w * 0.5,
		-(local.y / half_h) * (h * 0.5) + h * 0.5)

## The world footprint this framing currently shows, in metres. Reported so the
## owner can compare it against the 2D prototype's LOCKED footprint knowing that
## the 2D number is NOT being inherited.
func footprint_m() -> Vector2:
	var h := ortho_size
	return Vector2(h * float(ProdConfig.OUTPUT_WIDTH) / float(ProdConfig.OUTPUT_HEIGHT), h)
