class_name ScaleCalibrationOverlay
extends Control
## First-MVP Gate 1A — the developer calibration overlay (specification §8).
##
## Its job is to make the project owner's judgement REPRODUCIBLE: every number on
## screen is either measured from the built world or read from the authoritative
## local calibration record, never typed here independently of what the scene
## uses. `ScaleCalibrationHall.measurements()` is the single source, and this
## file only formats it.
##
## It is a developer instrument. It is NOT the §17 Prototype HUD, NOT the
## first-MVP interface, and NOT final art: there is no Life or Mana reservoir, no
## Skill bank, no objective, no minimap, and no combat state, because the hall
## has no combat. The colour direction only nods at Wroughtstone (dark slate,
## iron, muted copper).

const SLATE: Color = Color(0.075, 0.082, 0.098, 0.90)
const IRON: Color = Color(0.24, 0.26, 0.30)
const COPPER: Color = Color(0.85, 0.58, 0.30)
const WARN: Color = Color(0.93, 0.62, 0.42)
const TEXT: Color = Color(0.84, 0.86, 0.90)
const DIM: Color = Color(0.55, 0.58, 0.64)

var hall: ScaleCalibrationHall

var _scale_text: RichTextLabel
var _hall_text: RichTextLabel
var _gate_text: RichTextLabel
var _lane_text: RichTextLabel
var _ranged_text: RichTextLabel
var _marker_text: RichTextLabel
var _controls_text: RichTextLabel
var _log_text: RichTextLabel
var _leak_label: Label
var _leak_clicks: int = 0


func _ready() -> void:
	# Built in code, so anchors AND offsets are set together. A full-rect anchor
	# over a zero-size rect collapses every child to the origin; that defect cost
	# Prototype Zero an entire invisible HUD at Gate F and is not repeated here.
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	_build()


func bind(owner_hall: ScaleCalibrationHall) -> void:
	hall = owner_hall


# --- Construction ---------------------------------------------------------------

func _build() -> void:
	var left: VBoxContainer = VBoxContainer.new()
	left.name = "LeftColumn"
	left.set_anchors_and_offsets_preset(Control.PRESET_TOP_LEFT)
	left.position = Vector2(26, 22)
	left.custom_minimum_size = Vector2(640, 0)
	left.add_theme_constant_override("separation", 9)
	left.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(left)

	# The conspicuous statement specification §8 requires. It names what this
	# place IS rather than what it lacks, so no later gate can make it stale.
	var identity: PanelContainer = _panel(WARN)
	var identity_box: VBoxContainer = VBoxContainer.new()
	identity_box.add_theme_constant_override("separation", 3)
	identity_box.add_child(_label(
		"Riftwrought — SCALE CALIBRATION HALL  ·  first-MVP Gate 1A", 23, COPPER
	))
	identity_box.add_child(_label(
		"TEMPORARY DEVELOPER CALIBRATION SCENE. Not final UI, not canonical story space,",
		15, WARN
	))
	identity_box.add_child(_label(
		"not a Bastion room, no combat. Every value here is a CANDIDATE awaiting your play.",
		15, WARN
	))
	identity.add_child(identity_box)
	left.add_child(identity)

	var scale_panel: PanelContainer = _panel()
	_scale_text = _rich(15)
	scale_panel.add_child(_scale_text)
	left.add_child(scale_panel)

	var hall_panel: PanelContainer = _panel()
	_hall_text = _rich(15)
	hall_panel.add_child(_hall_text)
	left.add_child(hall_panel)

	var controls_panel: PanelContainer = _panel()
	_controls_text = _rich(14)
	controls_panel.add_child(_controls_text)
	left.add_child(controls_panel)

	var right: VBoxContainer = VBoxContainer.new()
	right.name = "RightColumn"
	right.set_anchors_and_offsets_preset(Control.PRESET_TOP_RIGHT)
	right.grow_horizontal = Control.GROW_DIRECTION_BEGIN
	right.offset_left = -606
	right.offset_right = -26
	right.offset_top = 22
	right.custom_minimum_size = Vector2(580, 0)
	right.add_theme_constant_override("separation", 9)
	right.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(right)

	var gate_panel: PanelContainer = _panel()
	_gate_text = _rich(14)
	gate_panel.add_child(_gate_text)
	right.add_child(gate_panel)

	var lane_panel: PanelContainer = _panel()
	_lane_text = _rich(14)
	lane_panel.add_child(_lane_text)
	right.add_child(lane_panel)

	var ranged_panel: PanelContainer = _panel()
	_ranged_text = _rich(14)
	ranged_panel.add_child(_ranged_text)
	right.add_child(ranged_panel)

	var marker_panel: PanelContainer = _panel()
	_marker_text = _rich(14)
	marker_panel.add_child(_marker_text)
	right.add_child(marker_panel)

	# A deliberate interface target over the play field, so the §7 rule that
	# "developer UI absorbs pointer input and cannot issue movement commands" can
	# be tested by hand as well as by the suite.
	var leak: PanelContainer = _panel()
	leak.name = "InterfaceLeakTest"
	leak.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_RIGHT)
	leak.grow_horizontal = Control.GROW_DIRECTION_BEGIN
	leak.grow_vertical = Control.GROW_DIRECTION_BEGIN
	leak.offset_left = -366
	leak.offset_right = -26
	leak.offset_top = -156
	leak.offset_bottom = -26
	leak.mouse_filter = Control.MOUSE_FILTER_STOP
	var leak_box: VBoxContainer = VBoxContainer.new()
	leak_box.add_theme_constant_override("separation", 5)
	leak_box.add_child(_label("Interface leak test", 16, COPPER))
	leak_box.add_child(_label(
		"Clicking this panel must not move the character,\nplace a marker, or change the count below.", 13, DIM
	))
	var button: Button = Button.new()
	button.text = "Click me"
	button.pressed.connect(_on_leak_button)
	leak_box.add_child(button)
	_leak_label = _label("panel presses: 0   ·   movement commands issued: 0", 13, TEXT)
	leak_box.add_child(_leak_label)
	leak.add_child(leak_box)
	add_child(leak)

	var log_panel: PanelContainer = _panel()
	log_panel.name = "LogPanel"
	log_panel.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_LEFT)
	log_panel.grow_vertical = Control.GROW_DIRECTION_BEGIN
	log_panel.offset_left = 26
	log_panel.offset_right = 806
	log_panel.offset_top = -186
	log_panel.offset_bottom = -26
	_log_text = _rich(13)
	log_panel.add_child(_log_text)
	add_child(log_panel)


func _on_leak_button() -> void:
	_leak_clicks += 1


func _panel(border: Color = IRON) -> PanelContainer:
	var panel: PanelContainer = PanelContainer.new()
	var style: StyleBoxFlat = StyleBoxFlat.new()
	style.bg_color = SLATE
	style.border_color = border
	style.set_border_width_all(1)
	style.set_corner_radius_all(3)
	style.set_content_margin_all(11)
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


# --- Live content ------------------------------------------------------------------

func _process(_delta: float) -> void:
	if hall == null or hall.player == null:
		return
	var m: Dictionary = hall.measurements()
	_update_scale(m)
	_update_hall(m)
	_update_gates(m)
	_update_lanes(m)
	_update_ranged(m)
	_update_markers(m)
	_update_controls(m)
	_update_log()
	# Both halves matter, and neither alone would show the rule holding: the panel
	# press count proves the click landed, and the movement-command count proves it
	# did not also reach the world. `ui_clicks_absorbed` stays at zero here on
	# purpose — a panel with MOUSE_FILTER_STOP consumes the click before the hall
	# ever sees it, which is the stronger of the two absorptions.
	_leak_label.text = "panel presses: %d   ·   movement commands issued: %d" % [
		_leak_clicks, hall.accepted_commands + hall.adjusted_commands,
	]


func _update_scale(m: Dictionary) -> void:
	var baseline: String = (
		"[color=#7fae7f]at the Gate 1A baseline[/color]" if bool(m["is_baseline"])
		else "[color=#e39c6b]changed this session — \\ resets it; nothing is written to disk[/color]"
	)
	_scale_text.text = (
		"[color=#d9954c]World scale and calibration[/color]   %s\n" % baseline
		+ "1 Godot unit = [b]%.2f m[/b]     P = [b]%.2f m[/b]     1 P = %.2f units\n" % [
			float(m["world_unit_metres"]), float(m["player_unit_metres"]),
			float(m["player_unit_metres"]) / maxf(float(m["world_unit_metres"]), 0.0001),
		]
		+ "camera   [b]%.1f m[/b] out, pitch [b]%.1f deg[/b], fov [b]%.1f deg[/b], yaw %.1f deg\n" % [
			float(m["camera_distance"]), float(m["camera_pitch"]),
			float(m["camera_fov"]), float(m["camera_yaw"]),
		]
		+ "movement [b]%.2f m/s[/b] maximum\n" % float(m["max_speed"])
		+ "player   measured collision [b]%.2f m[/b] across (%.2f P), %.2f m tall" % [
			float(m["player_diameter"]),
			float(m["player_diameter"]) / maxf(float(m["player_unit_metres"]), 0.0001),
			float(m["player_height"]),
		]
	)


func _update_hall(m: Dictionary) -> void:
	var clear: Vector2 = m["clear_metres"]
	var clear_p: Vector2 = m["clear_p"]
	var cf: Vector2 = m["cf_metres"]
	var position: Vector3 = m["player_position"]
	_hall_text.text = (
		"[color=#d9954c]Measured hall[/color]\n"
		+ "clear floor  [b]%.2f x %.2f m[/b]   =  [b]%.1f P x %.1f P[/b]   =  %.0f m^2\n" % [
			clear.x, clear.y, clear_p.x, clear_p.y, float(m["clear_area"]),
		]
		+ "CF           %.1f x %.1f m = %.0f m^2 at this camera  ->  hall is [b]%.2f CF[/b]\n" % [
			cf.x, cf.y, float(m["cf_area"]), float(m["clear_in_cf"]),
		]
		+ "             measured at the fixed %.2f reference aspect; this window is %.2f\n" % [
			float(m["reference_aspect"]), float(m["live_aspect"]),
		]
		+ "navigation   %d polygons, %.1f m^2 walkable\n" % [
			int(m["navmesh_polygons"]), float(m["navmesh_area"]),
		]
		+ "player at    (%.2f, %.2f)   moving: [b]%s[/b]   input: [b]%s[/b]" % [
			position.x, position.z, m["movement_mode"], m["input_family"],
		]
	)


func _update_gates(m: Dictionary) -> void:
	var text: String = "[color=#d9954c]Doorway comparisons — measured clear width[/color]\n"
	for gate: Dictionary in m["gates"]:
		text += "%-19s [b]%6.3f m[/b]  = %5.2f P   (target %.1f P = %.2f m)   %s\n" % [
			gate["name"], float(gate["measured_metres"]), float(gate["measured_p"]),
			float(gate["target_p"]), float(gate["target_metres"]), gate["meaning"],
		]
	text += "[color=#8c9099]The 4 P stress gate is NOT an approved ordinary doorway.[/color]"
	_gate_text.text = text


func _update_lanes(m: Dictionary) -> void:
	var text: String = "[color=#d9954c]Combat lanes — measured clear width[/color]\n"
	for lane: Dictionary in m["lanes"]:
		text += "%-21s [b]%6.3f m[/b]  = %5.2f P   (target %.1f P = %.2f m)\n" % [
			lane["name"], float(lane["measured_metres"]), float(lane["measured_p"]),
			float(lane["target_p"]), float(lane["target_metres"]),
		]
	text += "[color=#8c9099]Rails are visible boundaries with no collision, so a lane never becomes a box.[/color]"
	_lane_text.text = text


func _update_ranged(m: Dictionary) -> void:
	var text: String = "[color=#d9954c]Ranged reading gallery — measured from the firing origin[/color]\n"
	for mark: Dictionary in m["ranged"]:
		text += "mark %5.1f m   measured [b]%.3f m[/b]\n" % [
			float(mark["target_metres"]), float(mark["measured_metres"]),
		]
	text += "[color=#8c9099]The probe has no collision, no damage, and no targeting.[/color]"
	_ranged_text.text = text


func _update_markers(m: Dictionary) -> void:
	var text: String = (
		"[color=#d9954c]Telegraph and hazard — TEST INPUTS, not decisions[/color]\n"
		+ "preset [b]%s[/b] (x%.2f)\n" % [m["marker_preset"], float(m["marker_scale"])]
		+ "Mauler commitment footprint  [b]%.2f m[/b] radius, %.0f deg\n" % [
			float(m["arc_radius"]), float(m["arc_degrees"]),
		]
		+ "Cinder Seal hazard footprint [b]%.2f m[/b] radius\n" % float(m["seal_radius"])
	)
	var escapes: String = ""
	for escape: Dictionary in m["escapes"]:
		escapes += "%s %.2f m   " % [escape["name"], float(escape["clear_metres"])]
	text += "clear run from the Seal rim to the nearest solid: %s\n" % escapes
	for role: Dictionary in m["roles"]:
		text += "%-34s %.2f m across, %.2f m tall%s\n" % [
			role["name"], float(role["diameter"]), float(role["height"]),
			"   [color=#e39c6b]PROVISIONAL[/color]" if bool(role["provisional"]) else "",
		]
	_marker_text.text = text.strip_edges()


func _update_controls(m: Dictionary) -> void:
	_controls_text.text = (
		"[color=#d9954c]Developer controls[/color]   "
		+ "[b]F3[/b] this overlay   [b]F6[/b] 1 m grid (%s)\n" % _on_off(bool(m["grid_visible"]))
		+ "[b]F1[/b] inert role fixtures (%s)   [b]F4[/b] telegraph and hazard court (%s)\n" % [
			_on_off(bool(m["role_fixtures_visible"])), m["marker_preset"],
		]
		+ "[b][ ][/b] camera distance   [b], .[/b] pitch   [b]; '[/b] field of view   "
		+ "[b]- =[/b] speed   [b]\\[/b] reset all\n"
		+ "[color=#8c9099]Left click or hold to move; left stick to move directly. "
		+ "No WASD, and no attack input exists here.[/color]"
	)


func _on_off(value: bool) -> String:
	return "shown" if value else "hidden"


func _update_log() -> void:
	var lines: PackedStringArray = hall.log_lines
	var from: int = maxi(lines.size() - 9, 0)
	var text: String = "[color=#d9954c]Log[/color]\n"
	for i: int in range(from, lines.size()):
		text += "%s\n" % lines[i]
	_log_text.text = text
