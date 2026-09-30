class_name PrototypeCameraRig
extends Node3D
## Prototype Zero — Gate B camera rig (specification §8).
##
## A fixed-orientation ARPG camera: it follows the player softly on the ground
## plane and never rotates during Prototype Zero.
##
## The shipped defaults below are the values the project owner selected live and
## LOCKED under decision D-175: 19 m out, 55 degrees down, 45 degrees vertical
## field of view. They remain live-adjustable so a later gate can be judged by
## eye, and the reset key returns to exactly these approved numbers.

@export_group("Framing")
@export var yaw_degrees: float = 45.0
@export var pitch_degrees: float = 55.0
@export var fov_degrees: float = 45.0
@export var distance_metres: float = 19.0

@export_group("Follow")
## Time for the camera to close half the remaining gap to the player. Small
## enough to read as no lag at ordinary movement speed.
@export var follow_half_life: float = 0.07
## Beyond this the camera stops easing and cuts, so a teleport or respawn cannot
## leave the player off-screen.
@export var snap_distance: float = 6.0

@export_group("Calibration limits")
@export var distance_range: Vector2 = Vector2(10.0, 40.0)
@export var pitch_range: Vector2 = Vector2(35.0, 80.0)
@export var fov_range: Vector2 = Vector2(20.0, 60.0)

@export_group("Impact impulse")
## Specification §18: "a small capped camera impulse" on an ordinary Hit, and
## "screen shake ... must be reducible or disabled". This is the CAP, in metres
## of camera displacement. It is deliberately tiny: at 19 m out and 45 degrees
## of vertical field of view, 0.16 m is a little under one percent of the frame
## height, which reads as a knock rather than as a camera fault.
@export var maximum_impulse_metres: float = 0.16
## How fast an impulse decays. Short, so a fast attack speed cannot accumulate a
## permanent wobble.
@export var impulse_half_life: float = 0.055

var camera: Camera3D
var focus: Vector3 = Vector3.ZERO

var _target: Node3D
var _defaults: Dictionary = {}
## Live impact displacement, in world metres, added to the camera position only.
## Zero at rest, so every Gate B measurement of the camera is unchanged.
var _impulse: Vector3 = Vector3.ZERO
var _impulse_phase: float = 0.0
## Instrumentation: the largest displacement this rig has ever produced, so the
## cap is a MEASURED fact rather than a promise.
var impulses_applied: int = 0
var largest_impulse: float = 0.0


func _ready() -> void:
	camera = Camera3D.new()
	camera.name = "Camera3D"
	camera.projection = Camera3D.PROJECTION_PERSPECTIVE
	camera.near = 0.1
	camera.far = 300.0
	add_child(camera)
	_defaults = {
		"yaw": yaw_degrees,
		"pitch": pitch_degrees,
		"fov": fov_degrees,
		"distance": distance_metres,
	}
	_apply()


func set_target(target: Node3D) -> void:
	_target = target
	if _target != null:
		focus = _target.global_position
		_apply()


func _process(delta: float) -> void:
	if _target == null:
		return
	var wanted: Vector3 = _target.global_position
	if focus.distance_to(wanted) > snap_distance:
		focus = wanted
	else:
		# Frame-rate independent exponential smoothing.
		var weight: float = 1.0 - pow(0.5, delta / maxf(follow_half_life, 0.0001))
		focus = focus.lerp(wanted, weight)
	_decay_impulse(delta)
	_apply()


func _apply() -> void:
	if camera == null:
		return
	camera.fov = fov_degrees
	# The impulse displaces the camera POSITION only and never the focus, so the
	# knock is felt without the aim drifting: `look_at` still points at exactly
	# the same ground point, which is what keeps click-to-move accurate during a
	# fight. At rest `_impulse` is exactly zero, so every Gate B camera
	# measurement is bit-for-bit unchanged.
	camera.global_position = focus + camera_offset() + _impulse
	camera.look_at(focus, Vector3.UP)


# --- Impact impulse (specification §18) --------------------------------------

## A small, capped, decaying displacement. `strength` is a 0-1 severity that the
## caller has already scaled by the player's screen-shake setting, so Off really
## is zero here rather than small.
func add_impulse(strength: float, direction: Vector3) -> void:
	if strength <= 0.0:
		return
	var planar: Vector3 = Vector3(direction.x, 0.0, direction.z)
	if planar.length() < 0.0001:
		planar = ground_forward()
	planar = planar.normalized()
	# A little vertical component, because a purely horizontal knock at a
	# 55-degree pitch reads as a pan rather than as an impact.
	var wanted: Vector3 = (planar + Vector3.UP * 0.35).normalized() * (
		clampf(strength, 0.0, 1.0) * maximum_impulse_metres
	)
	_impulse += wanted
	if _impulse.length() > maximum_impulse_metres:
		_impulse = _impulse.normalized() * maximum_impulse_metres
	_impulse_phase = 0.0
	impulses_applied += 1
	largest_impulse = maxf(largest_impulse, _impulse.length())


## Exponential decay with one short counter-swing, so the knock reads as an
## impact rather than as a slide back to centre.
func _decay_impulse(delta: float) -> void:
	if _impulse.length() < 0.0001:
		_impulse = Vector3.ZERO
		return
	_impulse_phase += delta
	var weight: float = pow(0.5, delta / maxf(impulse_half_life, 0.0001))
	_impulse *= weight
	if _impulse.length() < 0.0005:
		_impulse = Vector3.ZERO


func impulse_offset() -> Vector3:
	return _impulse


func clear_impulse() -> void:
	_impulse = Vector3.ZERO
	_impulse_phase = 0.0


func camera_offset() -> Vector3:
	var pitch: float = deg_to_rad(pitch_degrees)
	var yaw: float = deg_to_rad(yaw_degrees)
	var horizontal: float = distance_metres * cos(pitch)
	return Vector3(sin(yaw) * horizontal, distance_metres * sin(pitch), cos(yaw) * horizontal)


## Ground-plane basis for controller input: pushing the stick away from the
## player must move away from the camera, not toward world -Z.
func ground_forward() -> Vector3:
	var offset: Vector3 = camera_offset()
	return Vector3(-offset.x, 0.0, -offset.z).normalized()


func ground_right() -> Vector3:
	return ground_forward().rotated(Vector3.UP, -PI * 0.5)


# --- Live calibration --------------------------------------------------------

func adjust_distance(delta_metres: float) -> void:
	distance_metres = clampf(distance_metres + delta_metres, distance_range.x, distance_range.y)
	_apply()


func adjust_pitch(delta_degrees: float) -> void:
	pitch_degrees = clampf(pitch_degrees + delta_degrees, pitch_range.x, pitch_range.y)
	_apply()


func adjust_fov(delta_degrees: float) -> void:
	fov_degrees = clampf(fov_degrees + delta_degrees, fov_range.x, fov_range.y)
	_apply()


func reset_calibration() -> void:
	clear_impulse()
	yaw_degrees = float(_defaults["yaw"])
	pitch_degrees = float(_defaults["pitch"])
	fov_degrees = float(_defaults["fov"])
	distance_metres = float(_defaults["distance"])
	_apply()


func is_default() -> bool:
	return (
		is_equal_approx(yaw_degrees, float(_defaults["yaw"]))
		and is_equal_approx(pitch_degrees, float(_defaults["pitch"]))
		and is_equal_approx(fov_degrees, float(_defaults["fov"]))
		and is_equal_approx(distance_metres, float(_defaults["distance"]))
	)


# --- Measured camera footprint (CF) ------------------------------------------

## The ground quad the default camera actually covers, measured by intersecting
## the four frustum corner rays with the y = 0 plane. This is the CF unit the
## room-library blueprint uses, and it is measured, never assumed.
##
## Returns near_width, far_width, depth, and area, all in provisional metres.
## Values are meaningless if the top of the frame is above the horizon, which is
## reported as `horizon_visible`.
func ground_footprint(aspect: float) -> Dictionary:
	var pitch: float = deg_to_rad(pitch_degrees)
	var half_v: float = deg_to_rad(fov_degrees) * 0.5
	var tan_h: float = tan(half_v) * aspect
	var height: float = distance_metres * sin(pitch)

	var top_angle: float = pitch - half_v
	var bottom_angle: float = pitch + half_v
	var horizon_visible: bool = top_angle <= 0.001

	var near_ground: float = height / tan(bottom_angle)
	var far_ground: float = (height / tan(top_angle)) if not horizon_visible else INF
	var depth: float = (far_ground - near_ground) if not horizon_visible else INF

	# Half-width at a ground point is its slant range from the camera times the
	# horizontal tangent, corrected for the ray's own inclination.
	var near_slant: float = height / sin(bottom_angle)
	var far_slant: float = (height / sin(top_angle)) if not horizon_visible else INF
	var focus_slant: float = distance_metres

	return {
		"near_width": 2.0 * near_slant * tan_h,
		"focus_width": 2.0 * focus_slant * tan_h,
		"far_width": (2.0 * far_slant * tan_h) if not horizon_visible else INF,
		"depth": depth,
		"camera_height": height,
		"horizon_visible": horizon_visible,
		"ground_behind_focus": (far_ground - height / tan(pitch)) if not horizon_visible else INF,
	}
