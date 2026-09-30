class_name GateBCalibrationOverlay
extends Control
## Prototype Zero — Gate B calibration overlay.
##
## Instructional and diagnostic only. This is NOT the Prototype HUD from
## specification §17 and NOT the first-MVP interface: there is no Life or Mana
## reservoir, no Skill bank, no objective, and no minimap, because none of those
## systems exist at Gate B. It exists so the project owner can judge locomotion
## and report the calibration values they actually want.
##
## Colour direction only nods at Wroughtstone (dark slate, iron, muted copper).
## Final art is not decided here.

const SLATE: Color = Color(0.075, 0.082, 0.098, 0.88)
const IRON: Color = Color(0.24, 0.26, 0.30)
const COPPER: Color = Color(0.85, 0.58, 0.30)
const TEXT: Color = Color(0.84, 0.86, 0.90)
const DIM: Color = Color(0.55, 0.58, 0.64)

var room: PrototypeZeroRoom

var _family_label: Label
var _mouse_panel: PanelContainer
var _mouse_text: RichTextLabel
var _controller_panel: PanelContainer
var _controller_text: RichTextLabel
var _calibration_text: RichTextLabel
var _log_text: RichTextLabel
var _debug_panel: PanelContainer
var _debug_text: RichTextLabel
var _leak_label: Label
var _leak_clicks: int = 0


func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	_build()


func bind_room(owner_room: PrototypeZeroRoom) -> void:
	room = owner_room


func toggle_debug() -> void:
	_debug_panel.visible = not _debug_panel.visible


func set_debug_visible(value: bool) -> void:
	_debug_panel.visible = value


# --- Construction ------------------------------------------------------------

func _build() -> void:
	var left: VBoxContainer = VBoxContainer.new()
	left.set_anchors_preset(Control.PRESET_TOP_LEFT)
	left.position = Vector2(28, 24)
	left.custom_minimum_size = Vector2(560, 0)
	left.add_theme_constant_override("separation", 10)
	left.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(left)

	var title: PanelContainer = _panel()
	var title_box: VBoxContainer = VBoxContainer.new()
	title_box.add_theme_constant_override("separation", 2)
	# EVERGREEN COPY, deliberately. This card was authored in Gate B, when the
	# room really did contain only locomotion, and its subtitle then said that no
	# enemy, loot, or progression existed. Gate D made the first half false and
	# Gate E made the rest of it false, and a card that states an untruth is worse
	# than one that states nothing — it is read during the very playtest it is
	# lying to. The replacement names what this place IS rather than what it
	# currently lacks, so no later gate can make it stale again.
	var heading: Label = _label("Riftwrought — Prototype Zero laboratory", 22, COPPER)
	var subtitle: Label = _label(
		"Contained movement, combat, and improvement-loop laboratory. Instrumentation is not final UI.",
		15, DIM
	)
	title_box.add_child(heading)
	title_box.add_child(subtitle)
	_family_label = _label("Input family: Mouse & Keyboard", 17, TEXT)
	title_box.add_child(_family_label)
	title.add_child(title_box)
	left.add_child(title)

	_mouse_panel = _panel()
	_mouse_text = _rich(15)
	_mouse_panel.add_child(_mouse_text)
	left.add_child(_mouse_panel)

	_controller_panel = _panel()
	_controller_text = _rich(15)
	_controller_panel.add_child(_controller_text)
	left.add_child(_controller_panel)

	var keys: PanelContainer = _panel()
	var keys_text: RichTextLabel = _rich(14)
	keys_text.text = (
		"[color=#d9954c]Calibration keys[/color]   " +
		"[b]F3[/b] debug overlay   [b]F4[/b] barrier   [b]F6[/b] 1 m grid\n" +
		"[b][ ][/b] camera distance   [b], .[/b] camera pitch   " +
		"[b]; '[/b] field of view   [b]- =[/b] movement speed   [b]\\[/b] reset all"
	)
	keys.add_child(keys_text)
	left.add_child(keys)

	# Deliberate interface target sitting over the play field, so the
	# "clicking UI never leaks a ground command" rule can be tested by hand.
	var leak: PanelContainer = _panel()
	leak.set_anchors_preset(Control.PRESET_TOP_RIGHT)
	leak.position = Vector2(-380, 24)
	leak.custom_minimum_size = Vector2(340, 0)
	leak.mouse_filter = Control.MOUSE_FILTER_STOP
	var leak_box: VBoxContainer = VBoxContainer.new()
	leak_box.add_theme_constant_override("separation", 6)
	leak_box.add_child(_label("Interface leak test", 16, COPPER))
	leak_box.add_child(_label("Clicking this panel must not move\nthe character or place a marker.", 13, DIM))
	var button: Button = Button.new()
	button.text = "Click me"
	button.pressed.connect(_on_leak_button)
	leak_box.add_child(button)
	_leak_label = _label("interface clicks absorbed: 0", 13, TEXT)
	leak_box.add_child(_leak_label)
	leak.add_child(leak_box)
	add_child(leak)

	var bottom: PanelContainer = _panel()
	bottom.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
	bottom.position = Vector2(28, -232)
	bottom.custom_minimum_size = Vector2(900, 0)
	var bottom_box: HBoxContainer = HBoxContainer.new()
	bottom_box.add_theme_constant_override("separation", 28)
	_calibration_text = _rich(14)
	_calibration_text.custom_minimum_size = Vector2(430, 148)
	_log_text = _rich(13)
	_log_text.custom_minimum_size = Vector2(430, 148)
	bottom_box.add_child(_calibration_text)
	bottom_box.add_child(_log_text)
	bottom.add_child(bottom_box)
	add_child(bottom)

	_debug_panel = _panel()
	_debug_panel.set_anchors_preset(Control.PRESET_TOP_RIGHT)
	_debug_panel.position = Vector2(-380, 210)
	_debug_panel.custom_minimum_size = Vector2(340, 0)
	_debug_text = _rich(13)
	_debug_panel.add_child(_debug_text)
	_debug_panel.visible = false
	add_child(_debug_panel)


func _on_leak_button() -> void:
	_leak_clicks += 1


func _panel() -> PanelContainer:
	var panel: PanelContainer = PanelContainer.new()
	var style: StyleBoxFlat = StyleBoxFlat.new()
	style.bg_color = SLATE
	style.border_color = IRON
	style.set_border_width_all(1)
	style.set_corner_radius_all(3)
	style.set_content_margin_all(12)
	panel.add_theme_stylebox_override("panel", style)
	panel.mouse_filter = Control.MOUSE_FILTER_STOP
	return panel


func _label(text: String, size: int, colour: Color) -> Label:
	var label: Label = Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", size)
	label.add_theme_color_override("font_color", colour)
	return label


func _rich(size: int) -> RichTextLabel:
	var rich: RichTextLabel = RichTextLabel.new()
	rich.bbcode_enabled = true
	rich.fit_content = true
	rich.scroll_active = false
	rich.mouse_filter = Control.MOUSE_FILTER_IGNORE
	rich.add_theme_font_size_override("normal_font_size", size)
	rich.add_theme_font_size_override("bold_font_size", size)
	rich.add_theme_color_override("default_color", TEXT)
	return rich


# --- Live content ------------------------------------------------------------

func _process(_delta: float) -> void:
	if room == null or room.player == null:
		return
	_update_family()
	_update_instructions()
	_update_calibration()
	_update_log()
	if _debug_panel.visible:
		_update_debug()


func _update_family() -> void:
	var tracker: InputFamilyTracker = room.input_family
	_family_label.text = "Input family: %s" % tracker.family_label()
	_family_label.add_theme_color_override("font_color", COPPER)
	_leak_label.text = "interface clicks absorbed: %d (button %d)" % [room.ui_clicks_absorbed, _leak_clicks]


func _update_instructions() -> void:
	var active: bool = room.input_family.family == InputFamilyTracker.Family.MOUSE_KEYBOARD
	_mouse_text.text = _scheme_text(
		"Mouse — click to move", active,
		"Left click or hold on the floor to move. Holding refreshes the destination.\n" +
		"Clicking a wall or beyond the room resolves to the nearest walkable point.\n" +
		"There is no WASD movement, by design."
	)
	_controller_text.text = _scheme_text(
		"Controller — direct movement", not active,
		"Left stick moves directly, with no path following. Speed follows how far\n" +
		"you push it. Below the %d%% deadzone the stick is at rest.\n" % int(room.player.stick_deadzone * 100.0) +
		"A live stick overrides an older click destination."
	)


func _scheme_text(heading: String, active: bool, body: String) -> String:
	var colour: String = "#d9954c" if active else "#6b727d"
	var marker: String = "▶ " if active else "   "
	return "[color=%s][b]%s%s[/b][/color]\n[color=%s]%s[/color]" % [
		colour, marker, heading, "#d6dae1" if active else "#7b828d", body,
	]


func _update_calibration() -> void:
	var summary: Dictionary = room.calibration_summary()
	_calibration_text.text = (
		"[color=#d9954c][b]Measured calibration (locked, D-175)[/b][/color]\n" +
		"world unit          1 unit = 1 m\n" +
		"clear floor         %.1f x %.1f m\n" % [summary["clear_floor"].x, summary["clear_floor"].y] +
		"P, player diameter  %.2f m     capsule %.2f m tall\n" % [
			summary["player_collision_diameter_P"], summary["player_collision_height"]
		] +
		"max speed           %.1f m/s  (long axis in %.1f s)\n" % [
			summary["max_speed"], summary["crossing_time_long_axis"]
		] +
		"camera              %.0f m, pitch %.1f deg, fov %.1f deg\n" % [
			summary["camera_distance"], summary["camera_pitch"], summary["camera_fov"]
		] +
		"CF ground footprint %.1f m wide x %.1f m deep\n" % [summary["cf_focus_width"], summary["cf_depth"]] +
		"room                %.2f CF\n" % summary["room_in_cf"] +
		"navigation mesh     %d polygons, %.0f m^2" % [summary["navmesh_polygons"], summary["navmesh_area"]]
	)


func _update_log() -> void:
	var lines: String = "[color=#d9954c][b]Recent events[/b][/color]\n"
	for line: String in room.log_lines:
		lines += "[color=#7b828d]%s[/color]\n" % line
	_log_text.text = lines


func _update_debug() -> void:
	var player: PrototypePlayer = room.player
	var tracker: InputFamilyTracker = room.input_family
	var raw: Vector2 = room.read_stick_raw()
	_debug_text.text = (
		"[color=#d9954c][b]Gate B debug (F3)[/b][/color]\n" +
		"fps %d   physics %d Hz\n" % [Engine.get_frames_per_second(), Engine.physics_ticks_per_second] +
		"input family     %s\n" % tracker.family_name() +
		"controller       %s\n" % (tracker.controller_name if tracker.has_controller() else "none connected") +
		"family switches  %d\n" % tracker.switch_count +
		"action state     %s\n" % player.action_state_name() +
		"movement mode    %s\n" % player.movement_mode_name() +
		"position         (%.2f, %.2f)\n" % [player.global_position.x, player.global_position.z] +
		"speed            %.2f / %.2f m/s\n" % [player.planar_speed(), player.max_speed] +
		"destination      %s\n" % (
			"(%.2f, %.2f)" % [player.destination.x, player.destination.z] if player.has_destination else "none"
		) +
		"navigation       %s\n" % player.navigation_status() +
		"last click       %s\n" % (
			"adjusted from (%.2f, %.2f)" % [player.last_requested_point.x, player.last_requested_point.z]
			if player.last_destination_was_adjusted else "walkable as clicked"
		) +
		"stick raw        (%.2f, %.2f) len %.2f\n" % [raw.x, raw.y, raw.length()] +
		"stick magnitude  %.2f  deadzone %.2f%s\n" % [
			player.stick_magnitude, player.stick_deadzone, "  [stale]" if player.stick_is_stale() else ""
		] +
		"awaiting neutral %s\n" % (player.neutral_reason if player.awaiting_neutral else "no") +
		"commands         %d accepted, %d adjusted, %d rejected\n" % [
			room.accepted_commands, room.adjusted_commands, room.rejected_commands
		] +
		"ui absorbed      %d\n" % room.ui_clicks_absorbed +
		"navmesh          %d polys, %.0f m^2, baked in %d ms\n" % [
			room.navmesh_polygon_count, room.navmesh_area, room.last_bake_msec
		] +
		"barrier          %s" % ("on" if room.room.barrier_enabled else "off")
	)
