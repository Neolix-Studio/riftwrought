class_name PrototypeSettingsPanel
extends VBoxContainer
## Prototype Zero — Gate F: the shared settings surface (specification §21,
## decision D-189).
##
## ONE surface, hosted in two places: the title screen, where there is no world,
## and the in-room settings modal reached from Pause. Building it twice would let
## the two drift, and §21's list is short enough that one panel is not a
## framework.
##
## It contains exactly §21's list and nothing else:
##
##   Controls       detected input family (read-only), controller deadzone,
##                  aim assistance, vibration
##   Presentation   damage numbers, screen shake, bright flashes
##   Audio          Master volume
##   Display        Windowed / Fullscreen, safe resolutions, Apply with a timed
##                  Keep / Revert
##   General        Restore Defaults, Reset Lab Progress behind a confirmation
##
## CONTROLLER-COMPLETE, and not by accident. Every row is a focusable Godot
## control in one vertical focus chain: continuous values are `HSlider`s, which
## already answer `ui_left` / `ui_right`, and enumerated values are Buttons that
## cycle on activate with the same two actions stepping them. There is no
## drag-only control, no typed field, and no hover-dependent affordance
## anywhere — `design/UI_AND_USER_EXPERIENCE.md` forbids all three, and a
## settings screen you cannot reach without a mouse is exactly the trap §23.3
## ("pause, resume, die, and restart entirely without a mouse") is testing for.
##
## EVERY CHANGE APPLIES IMMEDIATELY except the display mode and resolution, which
## are staged behind Apply because §4.3 requires a timed Keep / Revert around
## them. Master volume in particular applies on the frame the slider moves, which
## is §19's "Master volume applies immediately".
##
## It is a `VBoxContainer` rather than an anchored `Control` so that both hosts
## can put it inside a `ScrollContainer` and let it report the height its rows
## actually need. §21's list is taller than the §4.3 minimum tested window of
## 1280 x 720, and a settings screen whose last four rows sit below the bottom
## edge is a settings screen where Back and Restore Defaults cannot be reached.

const SLATE: Color = Color(0.075, 0.082, 0.098, 0.96)
const SLATE_DEEP: Color = Color(0.055, 0.060, 0.072, 0.98)
const IRON: Color = Color(0.28, 0.30, 0.35)
const COPPER: Color = Color(0.85, 0.58, 0.30)
const TEXT: Color = Color(0.84, 0.86, 0.90)
const TEXT_DIM: Color = Color(0.55, 0.58, 0.64)
const WARN: Color = Color(0.92, 0.62, 0.36)

var settings: PrototypeSettings
var display: PrototypeDisplayManager
var audio: PrototypeAudioDirector
var input_family: InputFamilyTracker

## Staged display choices, applied only by Apply.
var staged_window_mode: PrototypeSettings.WindowMode = PrototypeSettings.WindowMode.WINDOWED
var staged_resolution_index: int = 0

var _family_value: Label
var _deadzone: HSlider
var _deadzone_value: Label
var _aim: HSlider
var _aim_value: Label
var _vibration: Button
var _damage_numbers: Button
var _shake: Button
var _flashes: Button
var _master: HSlider
var _master_value: Label
var _window_mode: Button
var _resolution: Button
var _apply: Button
var _restore: Button
var _reset_lab: Button
var _back: Button
var _status: Label
var _first_focus: Control

signal back_requested()
signal reset_lab_requested()
signal apply_display_requested(mode: PrototypeSettings.WindowMode, resolution_index: int)


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	process_mode = Node.PROCESS_MODE_ALWAYS
	add_theme_constant_override("separation", 7)


func configure(
	store: PrototypeSettings,
	display_manager: PrototypeDisplayManager,
	audio_director: PrototypeAudioDirector,
	tracker: InputFamilyTracker,
	show_reset_lab: bool
) -> void:
	settings = store
	display = display_manager
	audio = audio_director
	input_family = tracker
	staged_window_mode = store.window_mode
	staged_resolution_index = store.resolution_index
	_build(show_reset_lab)
	refresh()


func first_focus() -> Control:
	return _first_focus


func refresh() -> void:
	if settings == null:
		return
	_family_value.text = input_family.family_label() if input_family != null else "Mouse & Keyboard"
	_deadzone.set_value_no_signal(settings.controller_deadzone)
	_deadzone_value.text = "%.2f" % settings.controller_deadzone
	_aim.set_value_no_signal(float(settings.aim_assistance))
	_aim_value.text = "%d / 100   (soft-target cone ×%.2f)" % [
		settings.aim_assistance, settings.aim_assist_scale(),
	]
	_vibration.text = "Vibration:  %s" % settings.level_name(settings.vibration)
	_damage_numbers.text = "Damage numbers:  %s" % ("On" if settings.damage_numbers else "Off")
	_shake.text = "Screen shake:  %s" % settings.level_name(settings.screen_shake)
	_flashes.text = "Bright flashes:  %s" % settings.level_name(settings.bright_flashes)
	_master.set_value_no_signal(settings.master_volume * 100.0)
	_master_value.text = "%d%%" % int(round(settings.master_volume * 100.0))
	_window_mode.text = "Window:  %s" % (
		"Fullscreen" if staged_window_mode == PrototypeSettings.WindowMode.FULLSCREEN else "Windowed"
	)
	var staged_size: Vector2i = PrototypeSettings.SAFE_RESOLUTIONS[staged_resolution_index]
	_resolution.text = "Resolution:  %d × %d" % [staged_size.x, staged_size.y]
	_resolution.disabled = staged_window_mode == PrototypeSettings.WindowMode.FULLSCREEN
	var staged: bool = (
		staged_window_mode != settings.window_mode
		or staged_resolution_index != settings.resolution_index
	)
	_apply.disabled = not staged
	_apply.text = "Apply display change" if staged else "Display: %s %s" % [
		settings.window_mode_name(), settings.resolution_name(),
	]
	_status.text = "" if settings.is_default() else "Settings differ from the §21 defaults."


# --- Build -------------------------------------------------------------------

func _build(show_reset_lab: bool) -> void:
	add_child(_heading("Controls"))
	_family_value = _line("Mouse & Keyboard", 13, TEXT)
	add_child(_read_only_row("Detected input", _family_value))
	var deadzone_row: Control = _slider_row(
		"Controller deadzone", PrototypeSettings.DEADZONE_RANGE.x,
		PrototypeSettings.DEADZONE_RANGE.y, 0.01
	)
	_deadzone = deadzone_row.get_meta("slider") as HSlider
	_deadzone_value = deadzone_row.get_meta("value") as Label
	_deadzone.value_changed.connect(_on_deadzone_changed)
	add_child(deadzone_row)
	var aim_row: Control = _slider_row("Aim assistance", 0.0, 100.0, 5.0)
	_aim = aim_row.get_meta("slider") as HSlider
	_aim_value = aim_row.get_meta("value") as Label
	_aim.value_changed.connect(_on_aim_changed)
	add_child(aim_row)
	_vibration = _cycle_button("Vibration", Callable(self, "_cycle_vibration"))
	add_child(_vibration)

	add_child(_heading("Presentation"))
	_damage_numbers = _cycle_button("Damage numbers", Callable(self, "_cycle_damage_numbers"))
	add_child(_damage_numbers)
	_shake = _cycle_button("Screen shake", Callable(self, "_cycle_shake"))
	add_child(_shake)
	_flashes = _cycle_button("Bright flashes", Callable(self, "_cycle_flashes"))
	add_child(_flashes)

	add_child(_heading("Audio"))
	var master_row: Control = _slider_row("Master volume", 0.0, 100.0, 5.0)
	_master = master_row.get_meta("slider") as HSlider
	_master_value = master_row.get_meta("value") as Label
	_master.value_changed.connect(_on_master_changed)
	add_child(master_row)

	add_child(_heading("Display"))
	_window_mode = _cycle_button("Window", Callable(self, "_cycle_window_mode"))
	add_child(_window_mode)
	_resolution = _cycle_button("Resolution", Callable(self, "_cycle_resolution"))
	add_child(_resolution)
	_apply = _cycle_button("Apply display change", Callable(self, "_on_apply_pressed"))
	add_child(_apply)

	add_child(_heading("General"))
	_restore = _cycle_button("Restore Defaults", Callable(self, "_on_restore_pressed"))
	add_child(_restore)
	if show_reset_lab:
		_reset_lab = _cycle_button("Reset Lab Progress…", Callable(self, "_on_reset_lab_pressed"))
		_reset_lab.add_theme_color_override("font_color", WARN)
		add_child(_reset_lab)

	_status = _line("", 12, WARN)
	add_child(_status)
	_back = _cycle_button("Back", Callable(self, "_on_back_pressed"))
	add_child(_back)

	# The first focus is the first control, not the destructive one at the bottom.
	_first_focus = _deadzone


# --- Handlers ----------------------------------------------------------------

func _on_deadzone_changed(value: float) -> void:
	settings.set_controller_deadzone(value)
	refresh()


func _on_aim_changed(value: float) -> void:
	settings.set_aim_assistance(int(round(value)))
	refresh()


## §19: "Master volume applies immediately." Not on Back, not on close, not on
## save — on the frame the slider moves.
func _on_master_changed(value: float) -> void:
	settings.set_master_volume(value / 100.0)
	if audio != null:
		audio.apply_master_volume(settings.master_volume)
	refresh()


func _cycle_vibration() -> void:
	settings.set_vibration(_next_level(settings.vibration))
	_click()
	refresh()


func _cycle_damage_numbers() -> void:
	settings.set_damage_numbers(not settings.damage_numbers)
	_click()
	refresh()


func _cycle_shake() -> void:
	settings.set_screen_shake(_next_level(settings.screen_shake))
	_click()
	refresh()


func _cycle_flashes() -> void:
	settings.set_bright_flashes(_next_level(settings.bright_flashes))
	_click()
	refresh()


func _cycle_window_mode() -> void:
	staged_window_mode = (
		PrototypeSettings.WindowMode.WINDOWED
		if staged_window_mode == PrototypeSettings.WindowMode.FULLSCREEN
		else PrototypeSettings.WindowMode.FULLSCREEN
	)
	_click()
	refresh()


func _cycle_resolution() -> void:
	staged_resolution_index = (staged_resolution_index + 1) % PrototypeSettings.SAFE_RESOLUTIONS.size()
	_click()
	refresh()


func _on_apply_pressed() -> void:
	_click()
	apply_display_requested.emit(staged_window_mode, staged_resolution_index)
	refresh()


func _on_restore_pressed() -> void:
	settings.restore_defaults()
	staged_window_mode = settings.window_mode
	staged_resolution_index = settings.resolution_index
	if audio != null:
		audio.apply_master_volume(settings.master_volume)
	_click()
	refresh()


func _on_reset_lab_pressed() -> void:
	_click()
	reset_lab_requested.emit()


func _on_back_pressed() -> void:
	_click()
	back_requested.emit()


## Keeps the staged display choices honest after an Apply that was reverted.
func resync_staged() -> void:
	if settings == null:
		return
	staged_window_mode = settings.window_mode
	staged_resolution_index = settings.resolution_index
	refresh()


func _next_level(level: PrototypeSettings.Level) -> PrototypeSettings.Level:
	return ((int(level) + 1) % 3) as PrototypeSettings.Level


func _click() -> void:
	if audio != null:
		audio.play("menu_confirm")


# --- Builders ----------------------------------------------------------------

func _heading(text: String) -> Control:
	var box: VBoxContainer = VBoxContainer.new()
	box.add_theme_constant_override("separation", 3)
	box.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var label: Label = _line(text.to_upper(), 11, COPPER)
	box.add_child(label)
	var rule: Panel = Panel.new()
	rule.custom_minimum_size = Vector2(0, 1)
	var style: StyleBoxFlat = StyleBoxFlat.new()
	style.bg_color = IRON
	rule.add_theme_stylebox_override("panel", style)
	rule.mouse_filter = Control.MOUSE_FILTER_IGNORE
	box.add_child(rule)
	return box


func _read_only_row(label_text: String, value: Label) -> Control:
	var row: HBoxContainer = HBoxContainer.new()
	row.add_theme_constant_override("separation", 12)
	row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var caption: Label = _line("%s:" % label_text, 13, TEXT_DIM)
	caption.custom_minimum_size = Vector2(190, 0)
	row.add_child(caption)
	row.add_child(value)
	return row


## A slider row. `HSlider` already answers `ui_left` / `ui_right` when focused,
## which is what makes the continuous values controller-complete without a
## bespoke widget.
func _slider_row(label_text: String, low: float, high: float, step: float) -> Control:
	var row: HBoxContainer = HBoxContainer.new()
	row.add_theme_constant_override("separation", 12)
	row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var caption: Label = _line("%s:" % label_text, 13, TEXT_DIM)
	caption.custom_minimum_size = Vector2(190, 0)
	row.add_child(caption)
	var slider: HSlider = HSlider.new()
	slider.min_value = low
	slider.max_value = high
	slider.step = step
	slider.custom_minimum_size = Vector2(230, 26)
	slider.focus_mode = Control.FOCUS_ALL
	slider.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(slider)
	var value: Label = _line("", 13, TEXT)
	value.custom_minimum_size = Vector2(220, 0)
	row.add_child(value)
	row.set_meta("slider", slider)
	row.set_meta("value", value)
	return row


func _cycle_button(text: String, action: Callable) -> Button:
	var button: Button = Button.new()
	button.name = text.replace(" ", "").replace("…", "")
	button.text = text
	button.focus_mode = Control.FOCUS_ALL
	button.alignment = HORIZONTAL_ALIGNMENT_LEFT
	button.custom_minimum_size = Vector2(0, 34)
	button.add_theme_font_size_override("font_size", 14)
	button.add_theme_color_override("font_color", TEXT)
	button.add_theme_color_override("font_focus_color", Color(1, 1, 1))
	button.add_theme_color_override("font_hover_color", Color(1, 1, 1))
	for state: String in ["normal", "hover", "pressed", "focus", "disabled"]:
		var style: StyleBoxFlat = StyleBoxFlat.new()
		style.bg_color = SLATE_DEEP if state != "focus" else Color(0.12, 0.13, 0.15, 1.0)
		style.border_color = COPPER if state == "focus" or state == "hover" else IRON
		style.set_border_width_all(2 if state == "focus" else 1)
		style.set_corner_radius_all(2)
		style.set_content_margin_all(7)
		button.add_theme_stylebox_override(state, style)
	button.pressed.connect(action)
	return button


func _line(text: String, size: int, colour: Color) -> Label:
	var label: Label = Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", size)
	label.add_theme_color_override("font_color", colour)
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return label


## The Buttons that cycle a value also step with `ui_left` / `ui_right`, so the
## stick and the d-pad change a setting the same way they change a slider. This
## is the difference between "reachable with a controller" and "usable with one".
func _unhandled_input(event: InputEvent) -> void:
	if not is_visible_in_tree():
		return
	if not (event.is_action_pressed(&"ui_left") or event.is_action_pressed(&"ui_right")):
		return
	var focus: Control = get_viewport().gui_get_focus_owner()
	var button: Button = focus as Button
	if button == null or button.disabled or not is_ancestor_of(button):
		return
	if button == _restore or button == _reset_lab or button == _back or button == _apply:
		return
	get_viewport().set_input_as_handled()
	button.emit_signal("pressed")
