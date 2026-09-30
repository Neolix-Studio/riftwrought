class_name FirstMvpModal
extends Control
## First-MVP — Gate 1D: the shared modal contract behind the item comparison
## and the Fallen overlay (decision D-217).
##
## The SAME contract Prototype Zero's `GateEModal` proved — pause, neutralize,
## safe focus, neutral-input arming, live input-family glyphs — reused as a
## PATTERN in a fresh file rather than by subclassing that Prototype-Zero-owned
## base, because `GateEModal` types its owner as `PrototypeZeroRoom` and this
## gate's owner is `BrokenWatchSlice`, a different class. Every rule below is
## unchanged from the proven one:
##
##   PAUSE            `get_tree().paused = true`; this node's own
##                    `process_mode` is WHEN_PAUSED, so it keeps running while
##                    the paused player, Graveblades, and coordinator do not.
##   NEUTRALIZE        opening clears movement and combat intent through the
##                    room's own neutral path — nothing here fakes it.
##   FOCUS AND GLYPHS  the safe, non-destructive control focuses first;
##                    controller navigation is Godot's own focus graph; glyphs
##                    follow the live input family without touching mechanics.
##   NEUTRAL INPUT     a control already held when the modal opened cannot act
##                    on it, and closing re-arms the room's own neutral latch.
##
## ONE RULE WAS ADDED AFTER THAT, AND THE PROVEN CONTRACT DID NOT HAVE IT: A LEFT
## PRESS REACHES THE GUI (First-MVP UI J1, decision D-322). Both `GateEModal` and
## this contract marked every `move_point` press handled in `_input()`, which Godot
## runs BEFORE the GUI, so a left click could never reach a button in a modal. A left
## press now continues to the GUI while the modal is open: Godot's own hit test finds
## the Button under the pointer and that button's own `pressed` connection answers,
## and a press anywhere else lands on the dim backdrop, which stops it. Nothing here
## finds, names or presses a button. The world is paused behind the backdrop, so the
## press reaches nothing but this modal. A left button already held when the modal
## opened still cannot act on it: its press came first and reached no button here,
## and the GUI delivers a release only to the control that took the press.
##
## Presentation is the same restrained flat Wroughtstone-adjacent placeholder
## every prior gate's instrumentation used: broad dark slate, iron edges,
## muted copper. Not final UI.

const SLATE: Color = Color(0.075, 0.082, 0.098, 0.96)
const SLATE_DEEP: Color = Color(0.055, 0.060, 0.072, 0.98)
const IRON: Color = Color(0.28, 0.30, 0.35)
const COPPER: Color = Color(0.85, 0.58, 0.30)
const TEXT: Color = Color(0.84, 0.86, 0.90)
const TEXT_DIM: Color = Color(0.55, 0.58, 0.64)
const IMPROVED: Color = Color(0.62, 0.86, 0.58)
const UNCHANGED: Color = Color(0.70, 0.73, 0.78)

var room: BrokenWatchSlice

var is_open: bool = false
var opens: int = 0
var closes: int = 0
var held_inputs_refused: int = 0
var last_focus_name: String = "none"

var _dim: ColorRect
var _glyph_labels: Array[Dictionary] = []
var _previous_focus: Control = null
var _armed: Dictionary = {}

signal opened()
signal closed(reason: String)


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	visible = false
	_build_backdrop()
	build_contents()


func bind_room(owner_room: BrokenWatchSlice) -> void:
	room = owner_room
	room.input_family.family_changed.connect(_on_family_changed)
	refresh_glyphs()


# --- Subclass hooks ------------------------------------------------------------

func build_contents() -> void:
	pass


func refresh_contents() -> void:
	pass


func default_focus() -> Control:
	return null


func cancel_closes() -> bool:
	return true


func modal_name() -> String:
	return "modal"


# --- Open and close --------------------------------------------------------

func open() -> void:
	if is_open:
		return
	is_open = true
	opens += 1
	visible = true

	room.neutralize_for_modal("%s opened" % modal_name())
	get_tree().paused = true

	_armed.clear()
	for action: StringName in [&"ui_confirm", &"ui_cancel", &"interact", &"quick_strike", &"move_point"]:
		_armed[action] = not Input.is_action_pressed(action)

	refresh_contents()
	refresh_glyphs()

	_previous_focus = get_viewport().gui_get_focus_owner()
	var focus: Control = default_focus()
	if focus != null:
		focus.grab_focus()
		last_focus_name = focus.name
	opened.emit()


func close(reason: String = "closed") -> void:
	if not is_open:
		return
	is_open = false
	closes += 1
	visible = false
	get_tree().paused = false

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
	## A left PRESS continues to the GUI (J1, D-322) — see the class header. Only the
	## press: its release has always continued, and nothing else is let through.
	var click: InputEventMouseButton = event as InputEventMouseButton
	if click != null and click.button_index == MOUSE_BUTTON_LEFT and click.pressed:
		return
	if event.is_action_pressed(&"quick_strike") or event.is_action_pressed(&"move_point"):
		get_viewport().set_input_as_handled()


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


func inputs_are_armed() -> bool:
	for action: StringName in _armed.keys():
		if not bool(_armed[action]):
			return false
	return true


# --- Glyphs ------------------------------------------------------------------

func _on_family_changed(_family: InputFamilyTracker.Family, _reason: String) -> void:
	refresh_glyphs()


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
		&"":
			# A control with no shortcut. Better an empty glyph than a "?" that
			# implies there is a key the player has not found.
			return ""
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
	style.border_width_top = 3
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
