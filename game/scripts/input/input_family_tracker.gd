class_name InputFamilyTracker
extends Node
## Prototype Zero — Gate B input-family tracking (specification §9.2).
##
## Owns exactly one question: which control family produced the last MEANINGFUL
## input. It changes a glyph family and nothing mechanical. Analog noise below
## the deadzone and sub-threshold mouse drift are ignored, so a resting
## controller on a desk cannot make the glyphs flicker.

enum Family {
	MOUSE_KEYBOARD,
	CONTROLLER,
}

## Stick deflection that counts as a deliberate controller input. Matches the
## player's movement deadzone so the glyphs change on the same motion that
## starts moving the character.
@export var stick_threshold: float = 0.20
## Trigger/analog-button pressure that counts as deliberate.
@export var trigger_threshold: float = 0.35
## Mouse travel, in pixels, that counts as a deliberate pointer move. A single
## jittery pixel from a resting hand must not steal the family back.
@export var mouse_motion_threshold: float = 6.0
## Minimum time between family changes. Purely anti-flicker; it never delays a
## mechanical response, because mechanics do not read the family at all.
@export var switch_cooldown_seconds: float = 0.20

var family: Family = Family.MOUSE_KEYBOARD
var controller_device: int = -1
var controller_name: String = ""
var switch_count: int = 0
var last_reason: String = "startup default"

var _mouse_travel: float = 0.0
var _time_since_switch: float = 999.0

signal family_changed(new_family: Family, reason: String)
signal controller_connection_changed(device: int, connected: bool)


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	Input.joy_connection_changed.connect(_on_joy_connection_changed)
	for device: int in Input.get_connected_joypads():
		_remember_controller(device)


func _process(delta: float) -> void:
	_time_since_switch += delta


func family_name() -> String:
	return "Mouse & Keyboard" if family == Family.MOUSE_KEYBOARD else "Controller"


## Long-form label for the overlay: names the actual device when one is known.
func family_label() -> String:
	if family == Family.CONTROLLER:
		if controller_name.is_empty():
			return "Controller"
		return "Controller — %s (device %d)" % [controller_name, controller_device]
	return "Mouse & Keyboard"


func has_controller() -> bool:
	return not Input.get_connected_joypads().is_empty()


## Called from the owning scene's `_input`, so every event is seen once.
func observe(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var motion: InputEventMouseMotion = event as InputEventMouseMotion
		_mouse_travel += motion.relative.length()
		if _mouse_travel >= mouse_motion_threshold:
			_mouse_travel = 0.0
			_switch_to(Family.MOUSE_KEYBOARD, "mouse motion")
		return

	_mouse_travel = 0.0

	if event is InputEventMouseButton or event is InputEventKey:
		if event.is_pressed():
			_switch_to(Family.MOUSE_KEYBOARD, "mouse button or key")
		return

	if event is InputEventJoypadButton:
		var button: InputEventJoypadButton = event as InputEventJoypadButton
		if button.pressed:
			_remember_controller(button.device)
			_switch_to(Family.CONTROLLER, "controller button")
		return

	if event is InputEventJoypadMotion:
		var motion_event: InputEventJoypadMotion = event as InputEventJoypadMotion
		var threshold: float = trigger_threshold if _is_trigger(motion_event.axis) else stick_threshold
		if absf(motion_event.axis_value) >= threshold:
			_remember_controller(motion_event.device)
			_switch_to(Family.CONTROLLER, "controller stick or trigger")


func _is_trigger(axis: int) -> bool:
	return axis == JOY_AXIS_TRIGGER_LEFT or axis == JOY_AXIS_TRIGGER_RIGHT


func _switch_to(next: Family, reason: String) -> void:
	last_reason = reason
	if next == family:
		return
	if _time_since_switch < switch_cooldown_seconds:
		return
	family = next
	_time_since_switch = 0.0
	switch_count += 1
	family_changed.emit(family, reason)


func _remember_controller(device: int) -> void:
	controller_device = device
	controller_name = Input.get_joy_name(device)


func _on_joy_connection_changed(device: int, connected: bool) -> void:
	if connected:
		_remember_controller(device)
	elif device == controller_device:
		controller_device = -1
		controller_name = ""
		# Specification §9.2: a disconnect clears held intent. The player owns
		# that; the tracker only reports the fact and falls back to the family
		# the user can still actually use.
		_switch_to(Family.MOUSE_KEYBOARD, "controller disconnected")
	controller_connection_changed.emit(device, connected)
