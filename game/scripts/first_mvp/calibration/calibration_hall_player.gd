class_name CalibrationHallPlayer
extends CharacterBody3D
## First-MVP Gate 1A — the Scale Calibration Hall's player.
##
## LOCOMOTION AND THE TEMPORARY VISUAL SILHOUETTE ONLY. Specification §3: "The
## hall player has locomotion and the temporary visual silhouette only. It
## exposes no Quick Strike, attack input, target acquisition, Life/Mana combat
## HUD, damage eligibility, or enemy interaction." There is deliberately no
## `attack`, `life`, `mana`, `weapon`, `receive_damage`, `experience`, `target`,
## `inventory`, or `save` member on this class, and the Gate 1A suite asserts
## each of those absences BY NAME rather than trusting this comment.
##
## The movement itself is not a second implementation. Every tuning value below
## is D-175's accepted Prototype Zero value, and the behaviour behind them is the
## SHARED `PrototypeLocomotion` kernel that `PrototypePlayer` also uses — the
## same §9.5 stick deadzone and staleness rules, the same acceleration and
## braking model, the same braked navigation-path arrival, and the same measured
## +Z facing rule. If this hall feels different from the Prototype Zero room, it
## is the space that changed, which is the entire point of Gate 1A.
##
## The Knight body is the existing temporary test adventurer. It is NOT the
## Riftmarked, it selects no class, and Gate 1A does not begin player identity.

enum MovementMode {
	NONE,
	MOUSE_PATH,
	CONTROLLER_DIRECT,
}

@export_group("Locomotion, metres — D-175 accepted Prototype Zero values")
@export var max_speed: float = 5.0
@export var acceleration: float = 30.0
@export var braking: float = 40.0
@export var turn_rate_degrees: float = 720.0
@export var arrival_tolerance: float = 0.20

@export_group("Controller — D-175 accepted Prototype Zero values")
@export var stick_deadzone: float = 0.20
@export var stick_response_curve: float = 1.0
@export var substantial_turn_degrees: float = 35.0

@export_group("Presentation")
@export var rig_path: NodePath = ^"VisualRoot/KnightRig"
## Speed at which the run cycle plays at its authored rate.
@export var run_cycle_reference_speed: float = 5.0
@export var run_animation_threshold: float = 0.20
@export var idle_animation_threshold: float = 0.10

const IDLE_CLIP: StringName = &"Idle_A"
const RUN_CLIP: StringName = &"Running_A"

var movement_mode: MovementMode = MovementMode.NONE

## Set while an interruption (focus loss, controller disconnect) requires every
## movement control to return to neutral before it is obeyed again.
var awaiting_neutral: bool = false
var neutral_reason: String = ""

var destination: Vector3 = Vector3.ZERO
var has_destination: bool = false
var last_requested_point: Vector3 = Vector3.ZERO
var last_destination_was_adjusted: bool = false

## The ONE shared locomotion kernel. See scripts/movement/prototype_locomotion.gd.
var _locomotion: PrototypeLocomotion = PrototypeLocomotion.new()

var stick_raw: Vector2:
	get:
		return _locomotion.raw
var stick_magnitude: float:
	get:
		return _locomotion.magnitude

var _agent: NavigationAgent3D
var _visual_root: Node3D
var _rig: MediumRigVisual
var _current_clip: StringName = &""

var _gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity", 9.8)

signal movement_command_resolved(status: String, requested: Vector3, resolved: Vector3)
signal arrived_at_destination(point: Vector3)
signal movement_intent_cleared(reason: String)
signal movement_mode_changed(mode: MovementMode)


func _ready() -> void:
	_agent = $NavigationAgent3D
	_visual_root = $VisualRoot
	_rig = get_node(rig_path) as MediumRigVisual
	_locomotion.facing_yaw = _visual_root.rotation.y
	_agent.path_desired_distance = 0.40
	_agent.target_desired_distance = arrival_tolerance
	_agent.radius = 0.40
	_agent.avoidance_enabled = false
	_locomotion.configure(stick_deadzone, stick_response_curve, substantial_turn_degrees)


## The measured collision diameter — P — read from the shape rather than from a
## constant, so the overlay states what the body actually is.
func collision_diameter() -> float:
	var shape: CollisionShape3D = $CollisionShape3D
	var capsule: CapsuleShape3D = shape.shape as CapsuleShape3D
	return capsule.radius * 2.0


func collision_height() -> float:
	var shape: CollisionShape3D = $CollisionShape3D
	var capsule: CapsuleShape3D = shape.shape as CapsuleShape3D
	return capsule.height


## The hall hands the camera's ground basis down so stick directions are read in
## screen space, not world space.
func set_ground_basis(forward: Vector3, right: Vector3) -> void:
	_locomotion.set_ground_basis(forward, right)


# --- Intent --------------------------------------------------------------------

## `point` is already resolved to the navigation mesh by the hall, which owns the
## unreachable-point rule. `adjusted` records that the clicked point was not
## itself walkable.
func command_move_to(point: Vector3, requested: Vector3, adjusted: bool) -> void:
	if awaiting_neutral:
		movement_command_resolved.emit("rejected: awaiting neutral input", requested, point)
		return
	last_requested_point = requested
	last_destination_was_adjusted = adjusted
	destination = point
	has_destination = true
	_agent.target_position = point
	_set_mode(MovementMode.MOUSE_PATH)
	# Specification §9.5: a fresh mouse command outranks a stick that is merely
	# still held.
	_locomotion.supersede_hold()
	movement_command_resolved.emit("adjusted" if adjusted else "accepted", requested, point)


func set_stick_raw(raw: Vector2) -> void:
	_locomotion.configure(stick_deadzone, stick_response_curve, substantial_turn_degrees)
	_locomotion.set_stick_raw(raw)


func clear_movement_intent(reason: String, require_neutral: bool = true) -> void:
	has_destination = false
	_agent.target_position = global_position
	_locomotion.reset()
	velocity = Vector3.ZERO
	_set_mode(MovementMode.NONE)
	if require_neutral:
		awaiting_neutral = true
		neutral_reason = reason
	movement_intent_cleared.emit(reason)


## Called by the hall once every physical movement control reads neutral.
func release_neutral_latch() -> void:
	if awaiting_neutral:
		awaiting_neutral = false
		neutral_reason = ""


func stick_is_commanding() -> bool:
	return _locomotion.is_commanding() and not awaiting_neutral


func stick_is_stale() -> bool:
	return _locomotion.stale


func facing_direction() -> Vector3:
	return Vector3(sin(_locomotion.facing_yaw), 0.0, cos(_locomotion.facing_yaw))


## Verification seam, matching the Prototype Zero player's. Ordinary play never
## calls it.
func face_instantly(direction: Vector3) -> void:
	if not _locomotion.face_instantly(direction):
		return
	_visual_root.rotation.y = _locomotion.facing_yaw


# --- Movement ---------------------------------------------------------------------

func _physics_process(delta: float) -> void:
	var desired: Vector3 = Vector3.ZERO

	if stick_is_commanding():
		if has_destination:
			# A live stick is the newest movement intent and outranks the older
			# navigation destination.
			has_destination = false
			movement_intent_cleared.emit("superseded by controller stick")
		_set_mode(MovementMode.CONTROLLER_DIRECT)
		desired = _locomotion.stick_velocity(max_speed)
	elif has_destination:
		_set_mode(MovementMode.MOUSE_PATH)
		desired = _path_velocity()
	elif movement_mode != MovementMode.NONE and planar_speed() < 0.01:
		_set_mode(MovementMode.NONE)

	velocity = PrototypeLocomotion.advance_planar_velocity(
		velocity, desired, acceleration, braking, delta
	)

	if is_on_floor():
		velocity.y = 0.0
	else:
		velocity.y -= _gravity * delta

	move_and_slide()
	_update_facing(delta)
	_update_animation()


func _path_velocity() -> Vector3:
	var step: Dictionary = PrototypeLocomotion.path_velocity(
		_agent, global_position, destination, max_speed, braking, arrival_tolerance
	)
	if bool(step["arrived"]):
		_arrive()
		return Vector3.ZERO
	return step["velocity"]


func remaining_path_length() -> float:
	return PrototypeLocomotion.remaining_path_length(_agent, global_position, destination)


func _arrive() -> void:
	if not has_destination:
		return
	has_destination = false
	arrived_at_destination.emit(destination)


func _update_facing(delta: float) -> void:
	var planar: Vector3 = PrototypeLocomotion.planar(velocity)
	if planar.length() < 0.15:
		_visual_root.rotation.y = _locomotion.facing_yaw
		return
	_visual_root.rotation.y = _locomotion.turn_toward(
		planar.normalized(), turn_rate_degrees, delta
	)


func _update_animation() -> void:
	if _rig == null:
		return
	var speed: float = planar_speed()
	var wanted: StringName = RUN_CLIP if speed >= run_animation_threshold else _current_clip
	if speed <= idle_animation_threshold:
		wanted = IDLE_CLIP
	if wanted == &"":
		wanted = IDLE_CLIP
	var scale: float = 1.0
	if wanted == RUN_CLIP:
		scale = clampf(speed / maxf(run_cycle_reference_speed, 0.01), 0.45, 1.60)
	if wanted != _current_clip:
		_current_clip = wanted
		_rig.play(wanted, 1.0, 0.10)
	_rig.animation_player.speed_scale = scale


# --- Small helpers ------------------------------------------------------------------

func planar_speed() -> float:
	return PrototypeLocomotion.planar(velocity).length()


func _set_mode(mode: MovementMode) -> void:
	if mode == movement_mode:
		return
	movement_mode = mode
	movement_mode_changed.emit(mode)


func movement_mode_name() -> String:
	match movement_mode:
		MovementMode.MOUSE_PATH:
			return "mouse path"
		MovementMode.CONTROLLER_DIRECT:
			return "controller direct"
		_:
			return "none"


func navigation_status() -> String:
	if not has_destination:
		return "no destination"
	if _agent.is_target_reachable():
		return "reachable, %.2f m of path left" % remaining_path_length()
	return "target unreachable"


func current_path() -> PackedVector3Array:
	if not has_destination:
		return PackedVector3Array()
	return _agent.get_current_navigation_path()
