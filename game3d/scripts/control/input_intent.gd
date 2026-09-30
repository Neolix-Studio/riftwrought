class_name InputIntent
extends RefCounted

## THE INPUT LAYER — devices in, INTENT out. Nothing else.
##
## This class knows about keys, buttons, sticks and the cursor. It knows nothing
## about movement, navigation, animation or combat. The layers above it consume
## an intent and never poll a device, which is what makes movement and aiming
## independently testable at all.
##
## ---------------------------------------------------------------------------
## THERE IS NO W / A / S / D PATH HERE, DELIBERATELY.
## ---------------------------------------------------------------------------
## CLAUDE.md section 8: "Click-to-move is the canonical mouse control scheme.
## There is no WASD binding in the MVP." Both 3D spikes bound WASD; they were
## spikes. The canonical schemes are:
##   * MOUSE      -> click-to-move (`move_command`), aim from the cursor;
##   * CONTROLLER -> left stick moves, right stick aims.
##
## Every field below is also individually injectable, so the verification suite
## can drive an intent without a physical device. THE SEAMS ARE ASSERTED NULL IN
## NORMAL PLAY by the suite's own final check.

## Sampled intent.
var move_axis: Vector2 = Vector2.ZERO        ## controller stick, deadzoned
var move_command_held: bool = false          ## click-to-move, held
var move_command_just: bool = false          ## click-to-move, edge
var aim_axis: Vector2 = Vector2.ZERO         ## controller right stick, deadzoned
var attack_held: bool = false

## Test seams. Null in normal play.
var debug_move_axis = null
var debug_move_command_held = null
var debug_move_command_just = null
var debug_aim_axis = null
var debug_attack_held = null

## A radial deadzone, applied to the vector's LENGTH rather than per-axis.
## A per-axis deadzone makes a stick's diagonal reachable at a smaller
## displacement than its cardinals, which is a real and measurable input defect.
static func radial_deadzone(v: Vector2, dz: float) -> Vector2:
	var l := v.length()
	if l <= dz:
		return Vector2.ZERO
	if l >= 1.0:
		return v / l
	return v.normalized() * ((l - dz) / (1.0 - dz))

func sample() -> void:
	var raw_move := Input.get_vector("stick_left", "stick_right", "stick_up", "stick_down")
	move_axis = radial_deadzone(raw_move, ProdConfig.STICK_DEADZONE)
	var raw_aim := Input.get_vector("aim_left", "aim_right", "aim_up", "aim_down")
	aim_axis = radial_deadzone(raw_aim, ProdConfig.STICK_DEADZONE)
	move_command_held = Input.is_action_pressed("move_command")
	move_command_just = Input.is_action_just_pressed("move_command")
	attack_held = Input.is_action_pressed("diagnostic_attack")

	if debug_move_axis != null:
		move_axis = debug_move_axis
	if debug_aim_axis != null:
		aim_axis = debug_aim_axis
	if debug_move_command_held != null:
		move_command_held = debug_move_command_held
	if debug_move_command_just != null:
		move_command_just = debug_move_command_just
		# An edge is consumed once, exactly as a real edge is.
		debug_move_command_just = null
	if debug_attack_held != null:
		attack_held = debug_attack_held

func seams_clear() -> bool:
	return debug_move_axis == null and debug_move_command_held == null \
		and debug_move_command_just == null and debug_aim_axis == null \
		and debug_attack_held == null

func clear_seams() -> void:
	debug_move_axis = null
	debug_move_command_held = null
	debug_move_command_just = null
	debug_aim_axis = null
	debug_attack_held = null
