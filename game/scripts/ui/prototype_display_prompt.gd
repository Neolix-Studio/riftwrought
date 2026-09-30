class_name PrototypeDisplayPrompt
extends Control
## Prototype Zero — Gate F: the timed display Keep / Revert confirmation
## (specification §4.3, §21 Display, §23.6, decision D-189).
##
## §4.3: "Resolution changes require a timed keep/revert confirmation so a bad
## display choice cannot trap the user."
##
## THE DEFAULT ANSWER IS REVERT, three times over:
##
##   * `Revert` takes focus, so a confirm pressed without reading reverts.
##   * `ui_cancel` reverts.
##   * The countdown reverts.
##
## Keeping the new mode requires deliberately moving to `Keep` and confirming it.
## That is the correct asymmetry for a control whose failure mode is a screen the
## player cannot read.
##
## IT IS NOT A `GateEModal`, on purpose. It can appear on top of the settings
## modal, which has already paused the world, and a second modal closing would
## UNPAUSE while the first was still open. So this one records whether it was the
## thing that paused, and restores exactly that on close.
##
## It lives on the persistent app rather than in the room, because the display
## can be changed from the title screen where there is no room at all.

const SLATE: Color = Color(0.075, 0.082, 0.098, 0.98)
const SLATE_DEEP: Color = Color(0.055, 0.060, 0.072, 1.0)
const IRON: Color = Color(0.28, 0.30, 0.35)
const COPPER: Color = Color(0.85, 0.58, 0.30)
const TEXT: Color = Color(0.84, 0.86, 0.90)
const TEXT_DIM: Color = Color(0.55, 0.58, 0.64)

var display: PrototypeDisplayManager
var audio: PrototypeAudioDirector

var is_open: bool = false

var _title: Label
var _detail: Label
var _countdown: Label
var _keep: Button
var _revert: Button
var _paused_by_me: bool = false
var _previous_focus: Control = null


func _ready() -> void:
	# `set_anchors_and_offsets_preset`, not `set_anchors_preset`. The latter sets
	# the anchors and leaves the OFFSETS where they were, which for a Control
	# created in code is (0, 0, 0, 0) — a full-rect anchor over a zero-size rect.
	# Everything anchored inside it then collapses to the origin or off the top of
	# the screen. The scene-instanced Gate E surfaces never hit this because their
	# `.tscn` writes both.
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	process_mode = Node.PROCESS_MODE_ALWAYS
	mouse_filter = Control.MOUSE_FILTER_STOP
	visible = false
	_build()


func bind(manager: PrototypeDisplayManager, audio_director: PrototypeAudioDirector) -> void:
	display = manager
	audio = audio_director
	display.confirmation_opened.connect(_on_opened)
	display.confirmation_ticked.connect(_on_ticked)
	display.confirmation_closed.connect(_on_closed)


func _build() -> void:
	var dim: ColorRect = ColorRect.new()
	dim.name = "Dim"
	dim.color = Color(0.02, 0.022, 0.028, 0.72)
	dim.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	dim.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(dim)

	var panel: PanelContainer = PanelContainer.new()
	panel.name = "Panel"
	var style: StyleBoxFlat = StyleBoxFlat.new()
	style.bg_color = SLATE
	style.border_color = IRON
	style.set_border_width_all(1)
	style.set_corner_radius_all(3)
	style.set_content_margin_all(22)
	panel.add_theme_stylebox_override("panel", style)
	panel.set_anchors_preset(Control.PRESET_CENTER)
	panel.custom_minimum_size = Vector2(520, 0)
	panel.mouse_filter = Control.MOUSE_FILTER_STOP

	var box: VBoxContainer = VBoxContainer.new()
	box.add_theme_constant_override("separation", 12)
	_title = _line("Keep this display mode?", 20, COPPER)
	box.add_child(_title)
	_detail = _line("", 13, TEXT)
	box.add_child(_detail)
	_countdown = _line("", 15, TEXT_DIM)
	box.add_child(_countdown)

	var buttons: HBoxContainer = HBoxContainer.new()
	buttons.alignment = BoxContainer.ALIGNMENT_END
	buttons.add_theme_constant_override("separation", 10)
	_revert = _button("Revert")
	_revert.pressed.connect(_on_revert_pressed)
	_keep = _button("Keep")
	_keep.pressed.connect(_on_keep_pressed)
	buttons.add_child(_revert)
	buttons.add_child(_keep)
	box.add_child(buttons)
	panel.add_child(box)
	add_child(panel)


func _on_opened(_seconds: float) -> void:
	is_open = true
	visible = true
	_paused_by_me = not get_tree().paused
	if _paused_by_me:
		get_tree().paused = true
	_detail.text = "Now showing %s %s.  Reverting to %s %s if you do nothing." % [
		display.settings.window_mode_name(), display.settings.resolution_name(),
		"Fullscreen" if display.previous_mode == PrototypeSettings.WindowMode.FULLSCREEN else "Windowed",
		"%d × %d" % [
			PrototypeSettings.SAFE_RESOLUTIONS[display.previous_resolution_index].x,
			PrototypeSettings.SAFE_RESOLUTIONS[display.previous_resolution_index].y,
		],
	]
	_previous_focus = get_viewport().gui_get_focus_owner()
	# REVERT takes focus. A confirm pressed without reading must undo, not keep.
	_revert.grab_focus()
	if audio != null:
		audio.play("menu_open")


func _on_ticked(seconds_left: float) -> void:
	_countdown.text = "Reverting in %.0f s…" % ceilf(seconds_left)


func _on_closed(kept: bool, reason: String) -> void:
	is_open = false
	visible = false
	if _paused_by_me:
		get_tree().paused = false
		_paused_by_me = false
	if _previous_focus != null and is_instance_valid(_previous_focus):
		_previous_focus.grab_focus()
	_previous_focus = null
	if audio != null:
		audio.play("menu_confirm" if kept else "menu_close")
	_countdown.text = reason


func _input(event: InputEvent) -> void:
	if not is_open:
		return
	if event.is_action_pressed(&"ui_cancel"):
		get_viewport().set_input_as_handled()
		display.revert("cancelled")
		return
	if event.is_action_pressed(&"ui_confirm"):
		get_viewport().set_input_as_handled()
		var focus: Control = get_viewport().gui_get_focus_owner()
		var button: Button = focus as Button
		if button != null:
			button.emit_signal("pressed")
		else:
			display.revert("no button focused")


func _on_keep_pressed() -> void:
	display.keep()


func _on_revert_pressed() -> void:
	display.revert("reverted by the player")


func _line(text: String, size: int, colour: Color) -> Label:
	var label: Label = Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", size)
	label.add_theme_color_override("font_color", colour)
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.custom_minimum_size = Vector2(470, 0)
	return label


func _button(text: String) -> Button:
	var button: Button = Button.new()
	button.name = text
	button.text = text
	button.focus_mode = Control.FOCUS_ALL
	button.custom_minimum_size = Vector2(150, 42)
	button.add_theme_font_size_override("font_size", 15)
	button.add_theme_color_override("font_color", TEXT)
	button.add_theme_color_override("font_focus_color", Color(1, 1, 1))
	for state: String in ["normal", "hover", "pressed", "focus", "disabled"]:
		var style: StyleBoxFlat = StyleBoxFlat.new()
		style.bg_color = SLATE_DEEP if state != "focus" else Color(0.12, 0.13, 0.15, 1.0)
		style.border_color = COPPER if state == "focus" or state == "hover" else IRON
		style.set_border_width_all(2 if state == "focus" else 1)
		style.set_corner_radius_all(2)
		style.set_content_margin_all(8)
		button.add_theme_stylebox_override(state, style)
	return button
