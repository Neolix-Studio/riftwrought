class_name GateEModal
extends Control
## Prototype Zero — Gate E: the shared contract behind the item comparison and
## the passive card (specification §16, §9.2, decision D-184).
##
## D-184: "These modal surfaces pause ordinary offline simulation, neutralize
## held intent, restore safe focus, and require neutral input before play
## resumes."
##
## All four are implemented here once, so the two surfaces cannot drift apart:
##
##   PAUSE            `get_tree().paused` really stops the world. The modal sets
##                    its own `process_mode` to WHEN_PAUSED so it keeps running
##                    while everything else — the player, the Graveblades, the
##                    coordinator, the director, the room's own input — does not.
##                    Nothing is faked by zeroing a velocity.
##   NEUTRALIZE       opening clears the destination, the stick, the held mouse
##                    button, the attack, its buffer, and its held repeat through
##                    the SAME `clear_movement_intent` path that focus loss and
##                    controller disconnect already use.
##   FOCUS AND GLYPHS the safe, non-destructive control takes focus first;
##                    controller navigation is Godot's own focus graph; and the
##                    glyphs follow the live input family without touching
##                    mechanical state (specification §9.2).
##   NEUTRAL INPUT    a control that was ALREADY held when the modal opened
##                    cannot act on it, and closing re-arms the room's existing
##                    neutral latch, so movement resumes only after every
##                    physical control has returned to rest.
##
## Presentation is restrained flat Wroughtstone-adjacent placeholder anchored to
## the registered KayKit palette: broad dark slate, iron edges, muted copper.
## It is NOT final UI, it copies no other ARPG's panel, and it uses no
## screenshot, promotional art, rarity frame, or Rift Shard.

## The KayKit-derived Wroughtstone placeholder palette, shared with the Gate B,
## C, and D instrumentation so the whole prototype reads as one surface.
const SLATE: Color = Color(0.075, 0.082, 0.098, 0.96)
const SLATE_DEEP: Color = Color(0.055, 0.060, 0.072, 0.98)
const IRON: Color = Color(0.28, 0.30, 0.35)
const COPPER: Color = Color(0.85, 0.58, 0.30)
const TEXT: Color = Color(0.84, 0.86, 0.90)
const TEXT_DIM: Color = Color(0.55, 0.58, 0.64)
const IMPROVED: Color = Color(0.62, 0.86, 0.58)
const UNCHANGED: Color = Color(0.70, 0.73, 0.78)

var room: PrototypeZeroRoom
var director: PrototypeProgressionDirector

var is_open: bool = false
## Instrumentation: opens, closes, and inputs the neutral rule refused.
var opens: int = 0
var closes: int = 0
var held_inputs_refused: int = 0
var last_focus_name: String = "none"

var _dim: ColorRect
var _glyph_labels: Array[Dictionary] = []
var _previous_focus: Control = null
## Actions that were already down when the modal opened. Each is re-armed only
## after it has been observed released, so an input the player was holding for
## something else cannot press a button here.
var _armed: Dictionary = {}

signal opened()
signal closed(reason: String)


func _ready() -> void:
	# `set_anchors_and_offsets_preset`, not `set_anchors_preset`. The latter sets
	# the anchors and leaves the OFFSETS where they were, which for a Control
	# created in code is (0, 0, 0, 0) — a full-rect anchor over a zero-size rect.
	# Everything anchored inside it then collapses to the origin or off the top of
	# the screen. The scene-instanced Gate E surfaces never hit this because their
	# `.tscn` writes both.
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	# WHEN_PAUSED is absolute for this node and its inheriting children, so the
	# modal and its buttons keep processing and receiving input while the paused
	# world does not.
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	visible = false
	_build_backdrop()
	build_contents()


func bind_room(owner_room: PrototypeZeroRoom) -> void:
	room = owner_room
	director = owner_room.director
	room.input_family.family_changed.connect(_on_family_changed)
	refresh_glyphs()


# --- Subclass hooks ----------------------------------------------------------

## Build the panel. Called once, from `_ready`.
func build_contents() -> void:
	pass


## Fill in live values. Called every time the surface opens.
func refresh_contents() -> void:
	pass


## The control that takes focus first: the safe, non-destructive one.
func default_focus() -> Control:
	return null


## What `ui_cancel` does. The comparison closes; the passive card, which is a
## deliberate confirmation with one option, does not.
func cancel_closes() -> bool:
	return true


func modal_name() -> String:
	return "modal"


# --- Open and close ----------------------------------------------------------

func open() -> void:
	if is_open:
		# Specification §15.2 and D-184: "reopening UI ... must never duplicate".
		# A second open of an already open surface is not a second surface.
		return
	is_open = true
	opens += 1
	visible = true

	# 1. Neutralize held movement AND combat intent, through the same path focus
	#    loss and controller disconnect already use.
	room.neutralize_for_modal("%s opened" % modal_name())

	# 2. Pause ordinary offline simulation.
	get_tree().paused = true

	# 3. Arm the neutral-input rule: anything already held is refused until it is
	#    released. A modal opened BY a button press must not immediately act on
	#    that same still-down button.
	_armed.clear()
	for action: StringName in [&"ui_confirm", &"ui_cancel", &"interact", &"quick_strike", &"move_point"]:
		_armed[action] = not Input.is_action_pressed(action)

	refresh_contents()
	refresh_glyphs()

	# 4. Safe focus first.
	_previous_focus = get_viewport().gui_get_focus_owner()
	var focus: Control = default_focus()
	if focus != null:
		focus.grab_focus()
		last_focus_name = focus.name
	director.note_cue("%s_open" % modal_name())
	opened.emit()


func close(reason: String = "closed") -> void:
	if not is_open:
		return
	is_open = false
	closes += 1
	visible = false
	get_tree().paused = false

	# Closing re-arms the room's existing neutral latch, so movement and combat
	# resume only once every physical control has returned to rest. The latch
	# itself is released by the room, exactly as it is after focus loss.
	room.restore_after_modal("%s %s" % [modal_name(), reason])
	if _previous_focus != null and is_instance_valid(_previous_focus):
		_previous_focus.grab_focus()
	_previous_focus = null
	closed.emit(reason)


# --- Input -------------------------------------------------------------------

func _input(event: InputEvent) -> void:
	if not is_open:
		return
	for action: StringName in _armed.keys():
		if not bool(_armed[action]) and event.is_action_released(action):
			_armed[action] = true

	if event.is_action_pressed(&"ui_cancel"):
		get_viewport().set_input_as_handled()
		if not _consume(&"ui_cancel"):
			return
		if cancel_closes():
			close("cancelled")
		return
	if event.is_action_pressed(&"ui_confirm") or event.is_action_pressed(&"interact"):
		var action: StringName = &"ui_confirm" if event.is_action_pressed(&"ui_confirm") else &"interact"
		get_viewport().set_input_as_handled()
		if not _consume(action):
			return
		activate_focused()
		return
	# The world is paused, but a still-held attack or movement control must not
	# leak through this surface either.
	if event.is_action_pressed(&"quick_strike") or event.is_action_pressed(&"move_point"):
		get_viewport().set_input_as_handled()


## Presses Godot's own focused button, so controller confirm and a mouse click
## take exactly the same path.
func activate_focused() -> void:
	var focus: Control = get_viewport().gui_get_focus_owner()
	var button: Button = focus as Button
	if button != null and not button.disabled:
		button.emit_signal("pressed")


func _consume(action: StringName) -> bool:
	if bool(_armed.get(action, true)):
		return true
	held_inputs_refused += 1
	return false


## True when every control this surface reads is either at rest or has been
## released since the surface opened.
func inputs_are_armed() -> bool:
	for action: StringName in _armed.keys():
		if not bool(_armed[action]):
			return false
	return true


# --- Glyphs ------------------------------------------------------------------

func _on_family_changed(_family: InputFamilyTracker.Family, _reason: String) -> void:
	refresh_glyphs()


## Registers a label whose text is the glyph for `action` in the live input
## family. Specification §9.2: the glyph family changes without any mechanical
## state changing.
func register_glyph(label: Label, action: StringName) -> void:
	_glyph_labels.append({"label": label, "action": action})


func refresh_glyphs() -> void:
	if room == null:
		return
	var controller: bool = room.input_family.family == InputFamilyTracker.Family.CONTROLLER
	for entry: Dictionary in _glyph_labels:
		var label: Label = entry["label"]
		if is_instance_valid(label):
			label.text = glyph_for(entry["action"] as StringName, controller)


## Text glyphs, not art. Prototype Zero has no glyph atlas and must not pretend
## to: these are the plain names of the controls the action contract in
## specification §9.1 actually binds.
static func glyph_for(action: StringName, controller: bool) -> String:
	match action:
		&"ui_confirm":
			return "(A)" if controller else "Enter"
		&"ui_cancel":
			return "(B)" if controller else "Esc"
		&"interact":
			return "(A)" if controller else "Left click"
		&"quick_strike":
			return "(X)" if controller else "Right mouse"
		_:
			return "?"


# --- Restrained Wroughtstone-adjacent placeholder builders -------------------

func _build_backdrop() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	_dim = ColorRect.new()
	_dim.name = "Dim"
	_dim.color = Color(0.02, 0.022, 0.028, 0.62)
	_dim.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_dim.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(_dim)


func make_panel(width: float) -> PanelContainer:
	var panel: PanelContainer = PanelContainer.new()
	panel.name = "Panel"
	var style: StyleBoxFlat = StyleBoxFlat.new()
	style.bg_color = SLATE
	style.border_color = IRON
	style.set_border_width_all(1)
	style.set_corner_radius_all(3)
	style.set_content_margin_all(22)
	# One quiet copper edge, the only ornament. It is the same accent the ground
	# ring, the drop nameplate, and the Gate D card already use.
	style.border_width_top = 3
	style.border_color = IRON
	panel.add_theme_stylebox_override("panel", style)
	panel.set_anchors_preset(Control.PRESET_CENTER)
	panel.custom_minimum_size = Vector2(width, 0)
	panel.mouse_filter = Control.MOUSE_FILTER_STOP
	return panel


func make_title(text: String) -> Label:
	var label: Label = Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", 20)
	label.add_theme_color_override("font_color", COPPER)
	return label


func make_line(text: String, size: int, colour: Color) -> Label:
	var label: Label = Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", size)
	label.add_theme_color_override("font_color", colour)
	return label


func make_rule() -> Panel:
	var rule: Panel = Panel.new()
	rule.custom_minimum_size = Vector2(0, 1)
	var style: StyleBoxFlat = StyleBoxFlat.new()
	style.bg_color = IRON
	rule.add_theme_stylebox_override("panel", style)
	rule.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return rule


func make_button(text: String, action: StringName) -> Button:
	var button: Button = Button.new()
	button.name = text
	button.focus_mode = Control.FOCUS_ALL
	button.custom_minimum_size = Vector2(168, 42)
	button.add_theme_font_size_override("font_size", 16)
	button.add_theme_color_override("font_color", TEXT)
	button.add_theme_color_override("font_focus_color", Color(1, 1, 1))
	button.add_theme_color_override("font_hover_color", Color(1, 1, 1))
	for state: String in ["normal", "hover", "pressed", "focus", "disabled"]:
		var style: StyleBoxFlat = StyleBoxFlat.new()
		style.bg_color = SLATE_DEEP if state != "focus" else Color(0.12, 0.13, 0.15, 1.0)
		style.border_color = COPPER if state == "focus" or state == "hover" else IRON
		style.set_border_width_all(2 if state == "focus" else 1)
		style.set_corner_radius_all(2)
		style.set_content_margin_all(8)
		button.add_theme_stylebox_override(state, style)
	var row: HBoxContainer = HBoxContainer.new()
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	row.add_theme_constant_override("separation", 10)
	row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	row.set_anchors_preset(Control.PRESET_FULL_RECT)
	var caption: Label = make_line(text, 16, TEXT)
	caption.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var glyph: Label = make_line("", 14, COPPER)
	glyph.mouse_filter = Control.MOUSE_FILTER_IGNORE
	row.add_child(caption)
	row.add_child(glyph)
	button.add_child(row)
	register_glyph(glyph, action)
	return button
