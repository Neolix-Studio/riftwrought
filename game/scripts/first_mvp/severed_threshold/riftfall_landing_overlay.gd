class_name RiftfallLandingOverlay
extends Control
## First-MVP Gate 1C — the compact developer overlay of the Riftfall Landing
## review wrapper (D-208 §9).
##
## THE DEFAULT VIEW IS CLEAN. §9: "no grid, path, collision role, developer
## labels, or measurement volumes", and only "a small line may identify the scene
## as a developer review build". So exactly one short line is drawn at launch and
## every diagnostic panel is hidden until F3. That is the opposite of both Gate 1B
## instruments, whose panels opened visible — and it is deliberate, because this is
## the first scene whose job is to be LOOKED AT rather than measured.
##
## IT IS NOT UI. Not the Prototype Zero §17 HUD, not the first-MVP interface, not
## final art, and not a story surface. It states so on screen.
##
## EVERY DRAWN CONTROL INTERCEPTS POINTER INPUT. The panels, the identity line and
## the click-test button all use `MOUSE_FILTER_STOP`, so a click on any of them is
## absorbed and the wrapper counts it instead of issuing a world command. The
## transparent full-screen root is the one exception and must be
## `MOUSE_FILTER_IGNORE`: a root that intercepted would absorb every click in the
## scene and the Landing would not be walkable at all.
##
## Anchors AND offsets are set together everywhere. A full-rect anchor over a
## zero-size rect collapses every child to the origin; that defect cost Prototype
## Zero an entire invisible HUD at Gate F and is not repeated here.

const SLATE: Color = Color(0.070, 0.076, 0.092, 0.90)
const IRON: Color = Color(0.24, 0.26, 0.30)
const COPPER: Color = Color(0.85, 0.58, 0.30)
const RIFT: Color = Color(0.72, 0.56, 0.92)
const TEXT: Color = Color(0.84, 0.86, 0.90)
const DIM: Color = Color(0.55, 0.58, 0.64)

var review: RiftfallLandingReview

var _identity: PanelContainer
var _panels: Array[Control] = []
var _world_text: RichTextLabel
var _route_text: RichTextLabel
var _loop_text: RichTextLabel
var _assets_text: RichTextLabel
var _session_text: RichTextLabel
var _log_text: RichTextLabel
var _leak_label: Label
var _leak_clicks: int = 0


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	_build()


func bind(owner_review: RiftfallLandingReview) -> void:
	review = owner_review


func set_panels_visible(value: bool) -> void:
	for panel: Control in _panels:
		panel.visible = value


func panels_visible() -> bool:
	return not _panels.is_empty() and _panels[0].visible


func _build() -> void:
	# The one line §9 permits in the clean default view. It says what this build
	# is and nothing else — no measurement, no story, no objective.
	_identity = _panel(COPPER)
	_identity.name = "IdentityLine"
	_identity.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_LEFT)
	_identity.grow_vertical = Control.GROW_DIRECTION_BEGIN
	_identity.offset_left = 20
	_identity.offset_right = 700
	_identity.offset_top = -46
	_identity.offset_bottom = -18
	_identity.add_child(_label(
		"Riftfall Landing — DEVELOPER REVIEW BUILD   ·   F3 diagnostics   ·   not final presentation",
		14, DIM
	))
	add_child(_identity)

	var left: VBoxContainer = VBoxContainer.new()
	left.name = "LeftColumn"
	left.set_anchors_and_offsets_preset(Control.PRESET_TOP_LEFT)
	left.position = Vector2(20, 18)
	left.custom_minimum_size = Vector2(660, 0)
	left.add_theme_constant_override("separation", 7)
	left.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(left)
	_panels.append(left)

	var heading: PanelContainer = _panel(COPPER)
	var heading_box: VBoxContainer = VBoxContainer.new()
	heading_box.add_theme_constant_override("separation", 3)
	heading_box.add_child(_label(
		"Riftwrought — RIFTFALL LANDING  ·  first-MVP Gate 1C", 21, COPPER
	))
	heading_box.add_child(_label(
		"Canonical safe exterior opening of The Severed Threshold. No combat, no enemy,",
		14, DIM
	))
	heading_box.add_child(_label(
		"no reward, no progression, no save. Developer instrumentation, not final UI.",
		14, DIM
	))
	heading_box.add_child(_label(
		"%s  %s" % [RiftfallLandingLayout.CREDIT_KAYKIT, RiftfallLandingLayout.CREDIT_KENNEY],
		12, DIM
	))
	heading.add_child(heading_box)
	left.add_child(heading)

	var world_panel: PanelContainer = _panel()
	_world_text = _rich(14)
	world_panel.add_child(_world_text)
	left.add_child(world_panel)

	var route_panel: PanelContainer = _panel()
	_route_text = _rich(14)
	route_panel.add_child(_route_text)
	left.add_child(route_panel)

	var loop_panel: PanelContainer = _panel(RIFT)
	_loop_text = _rich(14)
	loop_panel.add_child(_loop_text)
	left.add_child(loop_panel)

	var right: VBoxContainer = VBoxContainer.new()
	right.name = "RightColumn"
	right.set_anchors_and_offsets_preset(Control.PRESET_TOP_RIGHT)
	right.grow_horizontal = Control.GROW_DIRECTION_BEGIN
	right.offset_left = -604
	right.offset_right = -20
	right.offset_top = 18
	right.custom_minimum_size = Vector2(584, 0)
	right.add_theme_constant_override("separation", 7)
	right.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(right)
	_panels.append(right)

	var assets_panel: PanelContainer = _panel()
	_assets_text = _rich(13)
	assets_panel.add_child(_assets_text)
	right.add_child(assets_panel)

	var session_panel: PanelContainer = _panel()
	_session_text = _rich(13)
	session_panel.add_child(_session_text)
	right.add_child(session_panel)

	# A deliberate interface target over the play field, so §13's "click every
	# visible interface surface and confirm no movement leaks through" can be
	# tested by hand as well as by the suite.
	var leak: PanelContainer = _panel()
	leak.name = "InterfaceLeakTest"
	leak.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_RIGHT)
	leak.grow_horizontal = Control.GROW_DIRECTION_BEGIN
	leak.grow_vertical = Control.GROW_DIRECTION_BEGIN
	leak.offset_left = -372
	leak.offset_right = -20
	leak.offset_top = -146
	leak.offset_bottom = -20
	var leak_box: VBoxContainer = VBoxContainer.new()
	leak_box.add_theme_constant_override("separation", 5)
	leak_box.add_child(_label("Interface leak test", 15, COPPER))
	leak_box.add_child(_label(
		"Clicking any panel must not move the body,\nplace a marker, or change the loop.", 12, DIM
	))
	var button: Button = Button.new()
	button.text = "Click me"
	button.pressed.connect(_on_leak_button)
	leak_box.add_child(button)
	_leak_label = _label("panel presses: 0   ·   clicks absorbed: 0", 12, TEXT)
	leak_box.add_child(_leak_label)
	leak.add_child(leak_box)
	add_child(leak)
	_panels.append(leak)

	var log_panel: PanelContainer = _panel()
	log_panel.name = "LogPanel"
	log_panel.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_LEFT)
	log_panel.grow_vertical = Control.GROW_DIRECTION_BEGIN
	log_panel.offset_left = 20
	log_panel.offset_right = 860
	log_panel.offset_top = -186
	log_panel.offset_bottom = -54
	_log_text = _rich(12)
	log_panel.add_child(_log_text)
	add_child(log_panel)
	_panels.append(log_panel)


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
	label.mouse_filter = Control.MOUSE_FILTER_STOP
	return label


func _rich(size: int) -> RichTextLabel:
	var rich: RichTextLabel = RichTextLabel.new()
	rich.bbcode_enabled = true
	rich.fit_content = true
	rich.scroll_active = false
	rich.add_theme_font_size_override("normal_font_size", size)
	rich.add_theme_font_size_override("bold_font_size", size)
	rich.add_theme_color_override("default_color", TEXT)
	rich.mouse_filter = Control.MOUSE_FILTER_STOP
	return rich


func _process(_delta: float) -> void:
	if review == null or not panels_visible():
		return
	var m: Dictionary = review.measurements()
	_update_world(m)
	_update_route(m)
	_update_loop(m)
	_update_assets(m)
	_update_session(m)
	_update_log()


func _update_world(m: Dictionary) -> void:
	var cf: Vector2 = m["cf_metres"]
	_world_text.text = (
		"[color=#d9954c]Accepted world, camera and movement — unchanged by Gate 1C[/color]\n"
		+ "1 unit = %.1f m   ·   P = %.2f m   ·   body %.2f x %.2f m\n" % [
			float(m["world_unit_metres"]), float(m["player_unit_metres"]),
			float(m["player_diameter"]), float(m["player_height"]),
		]
		+ "camera %.1f m (default %.1f) · pitch %.1f deg · fov %.1f deg · yaw %.1f deg\n" % [
			float(m["camera_distance"]), float(m["camera_distance_default"]),
			float(m["camera_pitch"]), float(m["camera_fov"]), float(m["camera_yaw"]),
		]
		+ "maximum movement speed %.1f m/s   ·   CF %.2f x %.2f m at aspect %.3f\n" % [
			float(m["max_speed"]), cf.x, cf.y, float(m["reference_aspect"]),
		]
		+ "[color=#8c9099]CF is measured at the fixed reference aspect, not at the live window "
		+ "(%.3f).[/color]" % float(m["live_aspect"])
	)


func _update_route(m: Dictionary) -> void:
	var clearance: Dictionary = m["minimum_solid_clearance"]
	var silhouette: Dictionary = m["silhouette"]
	_route_text.text = (
		"[color=#d9954c]Measured from the geometry that was actually built[/color]\n"
		+ "authored movement footprint [b]%.1f m^2[/b] = [b]%.3f CF[/b]   ·   %.1f%% clear of collision\n" % [
			float(m["footprint_area"]), float(m["footprint_cf"]),
			float(m["clear_fraction"]) * 100.0,
		]
		+ "navigation mesh [b]%.1f m^2[/b] over [b]%d[/b] polygons, baked [b]%d[/b] time(s) in %d ms\n" % [
			float(m["navmesh_area"]), int(m["navmesh_polygons"]), int(m["bake_count"]),
			int(m["bake_msec"]),
		]
		+ "geometric centreline [b]%.2f m[/b] · resolved path [b]%.2f m[/b] · walked [b]%.2f m[/b] in [b]%.1f s[/b]\n" % [
			float(m["centreline_metres"]), float(m["resolved_path_metres"]),
			float(m["walked_metres"]), float(m["walked_seconds"]),
		]
		+ "widths: [b]%d[/b] of %d stations in 10-14 m, %d wider, narrowest [b]%.2f m[/b]\n" % [
			int(m["widths_ordinary"]), int(m["width_samples"]), int(m["widths_wider"]),
			float(m["narrowest_clearance"]),
		]
		+ "Watch breach [b]%.3f m[/b]   ·   nearest other solid to the centreline %.2f m (%s)\n" % [
			float(m["breach_clearance"]), float(clearance["metres"]), String(clearance["solid"]),
		]
		+ "[color=#8c9099]This camera shows ground from %.1f m behind to %.1f m ahead and never "
		% [float(silhouette["ground_visible_behind"]), float(silhouette["ground_visible_ahead"])]
		+ "the horizon, so nothing beyond that is on screen however tall it is. The Watch\n"
		+ "massing (%.1f m) first enters the frame %.1f m along the route.[/color]" % [
			float(silhouette["tallest_mass"]), float(silhouette["visible_from_along"]),
		]
	)


func _update_loop(m: Dictionary) -> void:
	var stone: Vector3 = m["stone_position"]
	var rest: Vector3 = m["stone_rest"]
	var impact: Vector3 = m["stone_impact"]
	_loop_text.text = (
		"[color=#b78fea]The repeating stone — the Landing's only authored event[/color]\n"
		+ "state [b]%s[/b] for %.2f s   ·   completed cycles [b]%d[/b]   ·   event clock %.1f s\n" % [
			String(m["loop_state"]), float(m["loop_state_elapsed"]), int(m["loop_cycles"]),
			float(m["loop_seconds"]),
		]
		+ "start (%.2f, %.2f, %.2f) → now (%.2f, %.2f, %.2f) → strike (%.2f, %.2f, %.2f)\n" % [
			rest.x, rest.y, rest.z, stone.x, stone.y, stone.z, impact.x, impact.y, impact.z,
		]
		+ "[color=#8c9099]travel %.3f m · cycle %.2f s · no collision, no navigation carve, "
		% [float(m["loop_travel"]), float(m["loop_cycle_seconds"])]
		+ "no interaction, no stored state.[/color]"
	)


func _update_assets(m: Dictionary) -> void:
	var families: PackedStringArray = m["used_families"]
	var text: String = "[color=#d9954c]Registered payloads in use — the D-206 accepted vocabulary[/color]\n"
	for family: String in families:
		text += "· %s\n" % family
	text += "[b]%d[/b] of the %d approved payloads used, %d instances placed\n" % [
		int(m["used_payloads"]), RiftfallLandingLayout.PAYLOADS.size(), int(m["instances"]),
	]
	text += "%d authored surfaces registered with the treatment, %d Rift surfaces deliberately not\n" % [
		int(m["authored_surfaces"]), int(m["unregistered_authored_surfaces"]),
	]
	text += "treated surfaces [b]%d[/b]   ·   source-material drift [b]%d[/b]\n" % [
		int(m["treated_surfaces"]), int(m["source_drift"]),
	]
	text += (
		"[color=#8c9099]saturation x %.2f · value x %.2f · cool tint (%.2f, %.2f, %.2f), "
		% [
			ExteriorReviewTreatment.SATURATION, ExteriorReviewTreatment.VALUE,
			ExteriorReviewTreatment.TINT.r, ExteriorReviewTreatment.TINT.g,
			ExteriorReviewTreatment.TINT.b,
		]
		+ "applied permanently. Raw imported materials are never written to.[/color]"
	)
	_assets_text.text = text


func _update_session(m: Dictionary) -> void:
	var at: Vector3 = m["player_position"]
	_session_text.text = (
		"[color=#d9954c]This session[/color]\n"
		+ "body at (%.2f, %.2f, %.2f)   ·   %s   ·   input: %s\n" % [
			at.x, at.y, at.z, String(m["movement_mode"]), String(m["input_family"]),
		]
		+ "movement commands: %d accepted · %d adjusted · %d rejected\n" % [
			int(m["accepted_commands"]), int(m["adjusted_commands"]), int(m["rejected_commands"]),
		]
		+ "interface clicks absorbed [b]%d[/b]   ·   combat inputs refused [b]%d[/b]\n" % [
			int(m["ui_clicks_absorbed"]), int(m["refused_action_inputs"]),
		]
		+ "exit socket: [b]%s[/b]\n" % (
			"reached after %.2f m and %.1f s" % [
				float(m["exit_reached_metres"]), float(m["exit_reached_seconds"]),
			] if bool(m["exit_reached"]) else "not reached"
		)
		+ "[color=#8c9099]Reaching it is a measurement. Nothing loads, saves, or opens.[/color]"
	)
	_leak_label.text = "panel presses: %d   ·   clicks absorbed: %d" % [
		_leak_clicks, int(m["ui_clicks_absorbed"]),
	]


func _update_log() -> void:
	var lines: PackedStringArray = review.log_lines
	var from: int = maxi(lines.size() - 7, 0)
	var text: String = "[color=#d9954c]Log[/color]\n"
	for i: int in range(from, lines.size()):
		text += "%s\n" % lines[i]
	_log_text.text = text


func leak_clicks() -> int:
	return _leak_clicks
