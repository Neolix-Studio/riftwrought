class_name ExteriorSpikeOverlay
extends Control
## First-MVP Gate 1B — the compact review and measurement overlay (§6, F3).
##
## Its job is to make the project owner's visual judgement REPRODUCIBLE: it says
## which review modes are active, what the treatment actually does, and what
## every candidate MEASURES, so a reaction to a frame can be traced to the
## numbers behind it. `ExteriorAssetCompatibilitySpike.measurements()` is the one
## source; this file only formats it.
##
## It is developer instrumentation. It is NOT the §17 Prototype HUD, NOT the
## first-MVP interface, and NOT final art. It also states, permanently and
## conspicuously, the two things a reader of a screenshot most needs to know:
## that this is a temporary spike rather than Riftfall Landing, and that no
## classification has been made — §9 leaves that entirely to the owner.
##
## It carries the CC BY 4.0 credit k0rveen's licence requires, on screen, for as
## long as a k0rveen mesh can be seen.

const SLATE: Color = Color(0.075, 0.082, 0.098, 0.90)
const IRON: Color = Color(0.24, 0.26, 0.30)
const COPPER: Color = Color(0.85, 0.58, 0.30)
const WARN: Color = Color(0.93, 0.62, 0.42)
const TEXT: Color = Color(0.84, 0.86, 0.90)
const DIM: Color = Color(0.55, 0.58, 0.64)

var spike: ExteriorAssetCompatibilitySpike

var _scale_text: RichTextLabel
var _modes_text: RichTextLabel
var _controls_text: RichTextLabel
var _kaykit_text: RichTextLabel
var _k0rveen_text: RichTextLabel
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


func bind(owner_spike: ExteriorAssetCompatibilitySpike) -> void:
	spike = owner_spike


func _build() -> void:
	var left: VBoxContainer = VBoxContainer.new()
	left.name = "LeftColumn"
	left.set_anchors_and_offsets_preset(Control.PRESET_TOP_LEFT)
	left.position = Vector2(24, 20)
	left.custom_minimum_size = Vector2(660, 0)
	left.add_theme_constant_override("separation", 8)
	left.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(left)

	var identity: PanelContainer = _panel(WARN)
	var identity_box: VBoxContainer = VBoxContainer.new()
	identity_box.add_theme_constant_override("separation", 3)
	identity_box.add_child(_label(
		"Riftwrought — EXTERIOR ASSET COMPATIBILITY SPIKE  ·  first-MVP Gate 1B", 22, COPPER
	))
	identity_box.add_child(_label(
		"TEMPORARY DEVELOPER REVIEW SCENE. Not Riftfall Landing, not the Severed Threshold,",
		15, WARN
	))
	identity_box.add_child(_label(
		"not a Bastion room, no combat. Every treatment here is a CANDIDATE awaiting your judgement.",
		15, WARN
	))
	identity_box.add_child(_label(ExteriorAssetCatalogue.K0RVEEN_CREDIT, 14, DIM))
	identity.add_child(identity_box)
	left.add_child(identity)

	var modes_panel: PanelContainer = _panel()
	_modes_text = _rich(15)
	modes_panel.add_child(_modes_text)
	left.add_child(modes_panel)

	var scale_panel: PanelContainer = _panel()
	_scale_text = _rich(15)
	scale_panel.add_child(_scale_text)
	left.add_child(scale_panel)

	var controls_panel: PanelContainer = _panel()
	_controls_text = _rich(14)
	controls_panel.add_child(_controls_text)
	left.add_child(controls_panel)

	var right: VBoxContainer = VBoxContainer.new()
	right.name = "RightColumn"
	right.set_anchors_and_offsets_preset(Control.PRESET_TOP_RIGHT)
	right.grow_horizontal = Control.GROW_DIRECTION_BEGIN
	right.offset_left = -598
	right.offset_right = -24
	right.offset_top = 20
	right.custom_minimum_size = Vector2(574, 0)
	right.add_theme_constant_override("separation", 8)
	right.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(right)

	var kaykit_panel: PanelContainer = _panel()
	_kaykit_text = _rich(13)
	kaykit_panel.add_child(_kaykit_text)
	right.add_child(kaykit_panel)

	var k0rveen_panel: PanelContainer = _panel()
	_k0rveen_text = _rich(13)
	k0rveen_panel.add_child(_k0rveen_text)
	right.add_child(k0rveen_panel)

	# A deliberate interface target over the play field, so the §6 rule that
	# "interface clicks must not issue movement commands" can be tested by hand
	# as well as by the suite.
	var leak: PanelContainer = _panel()
	leak.name = "InterfaceLeakTest"
	leak.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_RIGHT)
	leak.grow_horizontal = Control.GROW_DIRECTION_BEGIN
	leak.grow_vertical = Control.GROW_DIRECTION_BEGIN
	leak.offset_left = -360
	leak.offset_right = -24
	leak.offset_top = -152
	leak.offset_bottom = -24
	leak.mouse_filter = Control.MOUSE_FILTER_STOP
	var leak_box: VBoxContainer = VBoxContainer.new()
	leak_box.add_theme_constant_override("separation", 5)
	leak_box.add_child(_label("Interface leak test", 16, COPPER))
	leak_box.add_child(_label(
		"Clicking this panel must not move the character,\nplace a marker, or change the count below.",
		13, DIM
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
	log_panel.offset_left = 24
	log_panel.offset_right = 828
	log_panel.offset_top = -168
	log_panel.offset_bottom = -24
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
	style.set_content_margin_all(10)
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


# --- Live content -------------------------------------------------------------

func _process(_delta: float) -> void:
	if spike == null or spike.player == null:
		return
	var m: Dictionary = spike.measurements()
	_update_modes(m)
	_update_scale(m)
	_update_controls(m)
	_update_candidates(m)
	_update_log()
	_leak_label.text = "panel presses: %d   ·   movement commands issued: %d" % [
		_leak_clicks, spike.accepted_commands + spike.adjusted_commands,
	]


func _update_modes(m: Dictionary) -> void:
	var launch: String = (
		"[color=#7fae7f]at the launch state[/color]" if bool(m["is_launch_state"])
		else "[color=#e39c6b]changed this session — \\ resets it; nothing is written to disk[/color]"
	)
	_modes_text.text = (
		"[color=#d9954c]Review modes[/color]   %s\n" % launch
		+ "lighting   [b]%s[/b]\n" % m["lighting_mode"]
		+ "materials  [b]%s[/b] over %d registered surfaces\n" % [
			"candidate treatment" if bool(m["materials_candidate"]) else "imported source",
			int(m["treated_surfaces"]),
		]
		+ "           treatment = saturation x %.2f, value x %.2f, cool tint (%.2f, %.2f, %.2f)\n" % [
			ExteriorReviewTreatment.SATURATION, ExteriorReviewTreatment.VALUE,
			ExteriorReviewTreatment.TINT.r, ExteriorReviewTreatment.TINT.g,
			ExteriorReviewTreatment.TINT.b,
		]
		+ "k0rveen    [b]%s[/b]     1 m grid [b]%s[/b]\n" % [
			"shown" if bool(m["k0rveen_visible"]) else "hidden",
			"shown" if bool(m["grid_visible"]) else "hidden",
		]
		+ "[color=#8c9099]The treatment never writes to an imported material: it is a per-surface\n"
		+ "scene override, and returning to source clears every one of them.[/color]"
	)


func _update_scale(m: Dictionary) -> void:
	var cf: Vector2 = m["cf_metres"]
	var ground: Vector2 = m["ground_metres"]
	var court: Vector2 = m["court_metres"]
	var position: Vector3 = m["player_position"]
	_scale_text.text = (
		"[color=#d9954c]Accepted world relationship — unchanged by this spike[/color]\n"
		+ "1 unit = [b]%.2f m[/b]   P = [b]%.2f m[/b]   player measured [b]%.2f m[/b] across, %.2f m tall\n" % [
			float(m["world_unit_metres"]), float(m["player_unit_metres"]),
			float(m["player_diameter"]), float(m["player_height"]),
		]
		+ "camera [b]%.1f m[/b] out (accepted default %.1f), pitch %.1f deg, fov %.1f deg   ·   CF %.1f x %.1f m\n" % [
			float(m["camera_distance"]), float(m["camera_distance_default"]),
			float(m["camera_pitch"]), float(m["camera_fov"]), cf.x, cf.y,
		]
		+ "movement [b]%.2f m/s[/b] maximum   ·   review ground %.0f x %.0f m (NOT a room target)\n" % [
			float(m["max_speed"]), ground.x, ground.y,
		]
		+ "hybrid court %.0f x %.0f m, [b]%.1f%%[/b] clear of decoration   ·   dungeon doorway [b]%.3f m[/b]\n" % [
			court.x, court.y, float(m["court_clear_fraction"]) * 100.0,
			float(m["dungeon_doorway"]),
		]
		+ "player at (%.1f, %.1f)   moving: [b]%s[/b]   input: [b]%s[/b]   nav %d polys, %.0f m^2" % [
			position.x, position.z, m["movement_mode"], m["input_family"],
			int(m["navmesh_polygons"]), float(m["navmesh_area"]),
		]
	)


func _update_controls(_m: Dictionary) -> void:
	_controls_text.text = (
		"[color=#d9954c]Review controls[/color]   "
		+ "[b]F1[/b] neutral <-> candidate lighting   [b]F2[/b] source <-> candidate materials\n"
		+ "[b]F4[/b] k0rveen shown/hidden   [b]F6[/b] 1 m grid   [b]F3[/b] this overlay   "
		+ "[b][ ][/b] camera distance\n"
		+ "[b]\\[/b] reset every review mode and the player position\n"
		+ "[color=#8c9099]Left click or hold to move; left stick to move directly. "
		+ "No WASD, and no attack input exists here.[/color]"
	)


func _update_candidates(m: Dictionary) -> void:
	var kaykit: String = "[color=#d9954c]KayKit candidates — measured at root scale 1.0[/color]\n"
	var k0rveen: String = "[color=#d9954c]k0rveen candidates — measured at root scale 1.0[/color]\n"
	for row: Dictionary in m["candidates"]:
		var size: Vector3 = row["size"]
		var line: String = "%-22s %5.2f x %5.2f x %5.2f m  %d/%d  x%d\n" % [
			row["display"], size.x, size.y, size.z,
			int(row["meshes"]), int(row["surfaces"]), int(row["instances"]),
		]
		if String(row["family"]) == ExteriorAssetCatalogue.FAMILY_K0RVEEN:
			k0rveen += line
		else:
			kaykit += line
	kaykit += "[color=#8c9099]size · meshes/surfaces · instances placed. One shared atlas per pack.[/color]"
	k0rveen += (
		"[color=#8c9099]No texture: flat colour materials, meant to be replaced.\n"
		+ "Background candidates only in this spike — not navigable terrain.\n"
		+ "Foreground / background-only / rejected is YOUR call, not the suite's.[/color]"
	)
	_kaykit_text.text = kaykit
	_k0rveen_text.text = k0rveen


func _update_log() -> void:
	var lines: PackedStringArray = spike.log_lines
	var from: int = maxi(lines.size() - 8, 0)
	var text: String = "[color=#d9954c]Log[/color]\n"
	for i: int in range(from, lines.size()):
		text += "%s\n" % lines[i]
	_log_text.text = text
