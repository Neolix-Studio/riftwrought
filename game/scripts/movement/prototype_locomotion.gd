class_name PrototypeLocomotion
extends RefCounted
## The ONE shared locomotion kernel: the accepted Prototype Zero movement
## contract, extracted so a second scene can reuse it instead of cloning it.
##
## Extracted under D-195 and the Gate 1A specification §3: "Reuse proven
## behavior where its contract is genuinely shared. Do not clone a second subtly
## different click-to-move or controller locomotion implementation." Every line
## below was MOVED from `scripts/actors/prototype_player.gd`, not rewritten:
## the §9.5 stick deadzone / staleness state machine, the acceleration and
## braking model, the braked navigation-path arrival, the measured +Z facing
## rule, and the camera-relative stick basis. `PrototypePlayer` now delegates to
## this object and keeps every one of its own public names, so the Gate B, C, D,
## E, and F suites read exactly what they read before.
##
## Values live on the OWNER, not here. `PrototypePlayer.stick_deadzone` is
## written at runtime from the §21 settings panel, so this kernel is handed the
## owner's live tuning on every `set_stick_raw()` rather than caching its own
## copy — a cached copy is exactly the kind of second, subtly different
## implementation the extraction exists to prevent.
##
## It holds NO combat, Life, Mana, attack, weapon, XP, or progression state. The
## Gate 1A hall reuses it for locomotion alone.

# --- Owner tuning, pushed in before use --------------------------------------

## Radial deadzone. Below this the stick is treated as at rest, so drift can
## neither move the character nor steal the input family.
var deadzone: float = 0.20
## 1.0 is linear above the deadzone. Raise for finer control near centre.
var response_curve: float = 1.0
## Specification §9.5: a post-start direction change this large is a NEW
## movement intent rather than the same held one.
var substantial_turn_degrees: float = 35.0

# --- Stick state (specification §9.5) ----------------------------------------

var raw: Vector2 = Vector2.ZERO
var magnitude: float = 0.0
var direction: Vector2 = Vector2.ZERO
## A held control that has been superseded is "stale": it keeps reporting a
## deflection but no longer counts as a command until it is released, re-crosses
## the deadzone, or turns substantially.
var stale: bool = false
var stale_direction: Vector2 = Vector2.ZERO
var was_live: bool = false

# --- Camera-relative basis and facing ----------------------------------------

var ground_forward: Vector3 = Vector3(-0.7071, 0.0, -0.7071)
var ground_right: Vector3 = Vector3(-0.7071, 0.0, 0.7071)
var facing_yaw: float = 0.0


func configure(deadzone_value: float, curve: float, substantial_turn: float) -> void:
	deadzone = deadzone_value
	response_curve = curve
	substantial_turn_degrees = substantial_turn


func set_ground_basis(forward: Vector3, right: Vector3) -> void:
	ground_forward = forward
	ground_right = right


## Raw left-stick reading, fed once per physics frame by the owning scene.
func set_stick_raw(value: Vector2) -> void:
	raw = value
	var length: float = minf(value.length(), 1.0)
	if length <= deadzone:
		magnitude = 0.0
		direction = Vector2.ZERO
		if was_live:
			was_live = false
		# Releasing to neutral always clears staleness: the next deflection is a
		# new press, and a new press is always a new intent.
		stale = false
		return
	var scaled: float = (length - deadzone) / (1.0 - deadzone)
	magnitude = clampf(pow(scaled, response_curve), 0.0, 1.0)
	direction = value.normalized()
	if stale:
		var turned: float = rad_to_deg(stale_direction.angle_to(direction))
		if absf(turned) >= substantial_turn_degrees:
			stale = false
	if not was_live:
		was_live = true


## A newer command outranks a stick that is merely still held. That stick only
## commands again once it is released, re-crosses the deadzone, or turns
## substantially.
func supersede_hold() -> void:
	if magnitude > 0.0:
		stale = true
		stale_direction = direction


## The same rule, but only when the hold is not already stale, and reporting
## whether it actually suspended anything so the caller can remember to revive
## it. This is the variant `suspend_held_movement_for_attack()` needs.
func suspend_hold() -> bool:
	if magnitude > 0.0 and not stale:
		stale = true
		stale_direction = direction
		return true
	return false


## Clears the physical reading. `direction` is deliberately NOT cleared, exactly
## as the accepted implementation left it: nothing reads it while the magnitude
## is zero, and clearing it would be a behaviour change dressed up as tidiness.
func reset() -> void:
	raw = Vector2.ZERO
	magnitude = 0.0
	stale = false
	was_live = false


func is_commanding() -> bool:
	return magnitude > 0.0 and not stale


## Desired planar velocity for a live stick, read in the camera's screen space
## rather than world space.
func stick_velocity(max_speed: float) -> Vector3:
	var planar_direction: Vector3 = (ground_right * raw.x + ground_forward * -raw.y)
	if planar_direction.length() > 0.0001:
		return planar_direction.normalized() * max_speed * magnitude
	return Vector3.ZERO


## Turns toward a planar direction at a bounded rate and returns the new yaw.
##
## MEASURED, not assumed: on the KayKit medium rig the cape sits at negative
## local Z, while the helmet visor and both toe bones point to positive Z. The
## body therefore faces +Z at identity, not the Godot -Z convention.
func turn_toward(towards: Vector3, turn_rate_degrees: float, delta: float) -> float:
	var wanted: float = atan2(towards.x, towards.z)
	facing_yaw = rotate_toward(facing_yaw, wanted, deg_to_rad(turn_rate_degrees) * delta)
	return facing_yaw


## Snaps the facing. Returns false when the direction is too short to name one.
func face_instantly(towards: Vector3) -> bool:
	var flat: Vector3 = planar(towards)
	if flat.length() < 0.0001:
		return false
	facing_yaw = atan2(flat.x, flat.z)
	return true


# --- Pure motion mathematics -------------------------------------------------

static func planar(v: Vector3) -> Vector3:
	return Vector3(v.x, 0.0, v.z)


## Moves the planar part of `velocity` toward `desired`, accelerating or braking.
## The vertical component is carried through untouched, because gravity and the
## floor own it.
static func advance_planar_velocity(
	velocity: Vector3, desired: Vector3, acceleration: float, braking: float, delta: float
) -> Vector3:
	var current: Vector3 = planar(velocity)
	var rate: float = acceleration if desired.length() > current.length() else braking
	if desired.length() < 0.001:
		rate = braking
	var next: Vector3 = current.move_toward(desired, rate * delta)
	return Vector3(next.x, velocity.y, next.z)


## Length of the path still to walk, so braking respects a detour instead of the
## straight-line distance through a wall.
static func remaining_path_length(
	agent: NavigationAgent3D, from: Vector3, destination: Vector3
) -> float:
	var path: PackedVector3Array = agent.get_current_navigation_path()
	var index: int = agent.get_current_navigation_path_index()
	if path.size() == 0 or index >= path.size():
		return planar(destination - from).length()
	var total: float = planar(path[index] - from).length()
	for i: int in range(index + 1, path.size()):
		total += planar(path[i] - path[i - 1]).length()
	return total


## Click-to-move path following. Returns `arrived` so the caller owns its own
## arrival signal, and `velocity` braked so arrival is clean instead of an
## overshoot and a correction — sqrt(2 a s) is the speed that stops exactly on
## the point.
static func path_velocity(
	agent: NavigationAgent3D,
	from: Vector3,
	destination: Vector3,
	max_speed: float,
	braking: float,
	arrival_tolerance: float
) -> Dictionary:
	var to_target: Vector3 = planar(destination - from)
	if to_target.length() <= arrival_tolerance or agent.is_navigation_finished():
		return {"arrived": true, "velocity": Vector3.ZERO}

	var next_point: Vector3 = agent.get_next_path_position()
	var step: Vector3 = planar(next_point - from)
	if step.length() < 0.0001:
		step = to_target
	var remaining: float = remaining_path_length(agent, from, destination)
	var arrival_speed: float = sqrt(2.0 * braking * maxf(remaining - arrival_tolerance * 0.5, 0.0))
	return {
		"arrived": false,
		"velocity": step.normalized() * minf(max_speed, arrival_speed),
	}


## Raw left-stick reading before any deadzone is applied. Nothing else in the
## project reads the sticks; the deadzone lives in the owner so one tunable
## value drives movement, and in the family tracker so one drift threshold
## drives glyphs.
static func read_stick_actions() -> Vector2:
	return Vector2(
		Input.get_action_raw_strength(&"move_vector_right")
			- Input.get_action_raw_strength(&"move_vector_left"),
		Input.get_action_raw_strength(&"move_vector_back")
			- Input.get_action_raw_strength(&"move_vector_forward")
	)
