class_name ExteriorCohesionOverlay
extends Control
## First-MVP Gate 1B — the compact review and measurement overlay for the
## Exterior Cohesion Comparison (§6, F3).
##
## Its job is to make the project owner's visual judgement REPRODUCIBLE: it says
## which comparison axis is where, what the treatment actually does, what the
## route MEASURES, and what every candidate measures — so a reaction to a frame
## can be traced to the numbers behind it.
## `ExteriorCohesionComparison.measurements()` is the one source; this file only
## formats it.
##
## It is developer instrumentation. It is NOT the §17 Prototype HUD, NOT the
## first-MVP interface, and NOT final art. It states, permanently and
## conspicuously, the two things a reader of a screenshot most needs to know: that
## this is a temporary comparison rather than Riftfall Landing, and that no
## classification has been made — §10 leaves that entirely to the owner.
##
## It also states the traceability condition the owner has to know about while
## looking at the picture. At D-203 delivery that was a warning: the two 2025
## Kenney kits declared an external colour atlas the manifest did not include, so
## their colour could not be judged. D-204 restored both atlases, so the panel now
## records the resolved dependency instead — and states the one consequence it
## carries, that a textured surface takes the treatment's shader branch, which
## renders `cull_back` where the imported source material is double-sided.

const SLATE: Color = Color(0.075, 0.082, 0.098, 0.90)
const IRON: Color = Color(0.24, 0.26, 0.30)
const COPPER: Color = Color(0.85, 0.58, 0.30)
const WARN: Color = Color(0.93, 0.62, 0.42)
const TEXT: Color = Color(0.84, 0.86, 0.90)
const DIM: Color = Color(0.55, 0.58, 0.64)

var comparison: ExteriorCohesionComparison

var _axes_text: RichTextLabel
var _route_text: RichTextLabel
var _controls_text: RichTextLabel
var _candidates_text: RichTextLabel
var _traceability_text: RichTextLabel
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


func bind(owner_comparison: ExteriorCohesionComparison) -> void:
	comparison = owner_comparison


func _build() -> void:
	var left: VBoxContainer = VBoxContainer.new()
	left.name = "LeftColumn"
	left.set_anchors_and_offsets_preset(Control.PRESET_TOP_LEFT)
	left.position = Vector2(24, 20)
	left.custom_minimum_size = Vector2(700, 0)
	left.add_theme_constant_override("separation", 8)
	left.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(left)

	var identity: PanelContainer = _panel(WARN)
	var identity_box: VBoxContainer = VBoxContainer.new()
	identity_box.add_theme_constant_override("separation", 3)
	identity_box.add_child(_label(
		"Riftwrought — EXTERIOR COHESION COMPARISON  ·  first-MVP Gate 1B", 22, COPPER
	))
	identity_box.add_child(_label(
		"TEMPORARY DEVELOPER REVIEW SCENE. Not Riftfall Landing, not the Severed Threshold,",
		15, WARN
	))
	identity_box.add_child(_label(
		"not Broken Watch, not a Bastion room, no combat. One composed route, swappable families.",
		15, WARN
	))
	identity_box.add_child(_label(
		"%s   %s" % [
			ExteriorCohesionCatalogue.CREDIT_KENNEY,
			ExteriorCohesionCatalogue.CREDIT_QUATERNIUS,
		], 13, DIM
	))
	identity.add_child(identity_box)
	left.add_child(identity)

	var axes_panel: PanelContainer = _panel()
	_axes_text = _rich(15)
	axes_panel.add_child(_axes_text)
	left.add_child(axes_panel)

	var route_panel: PanelContainer = _panel()
	_route_text = _rich(15)
	route_panel.add_child(_route_text)
	left.add_child(route_panel)

	var controls_panel: PanelContainer = _panel()
	_controls_text = _rich(14)
	controls_panel.add_child(_controls_text)
	left.add_child(controls_panel)

	var right: VBoxContainer = VBoxContainer.new()
	right.name = "RightColumn"
	right.set_anchors_and_offsets_preset(Control.PRESET_TOP_RIGHT)
	right.grow_horizontal = Control.GROW_DIRECTION_BEGIN
	right.offset_left = -614
	right.offset_right = -24
	right.offset_top = 20
	right.custom_minimum_size = Vector2(590, 0)
	right.add_theme_constant_override("separation", 8)
	right.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(right)

	var candidates_panel: PanelContainer = _panel()
	_candidates_text = _rich(13)
	candidates_panel.add_child(_candidates_text)
	right.add_child(candidates_panel)

	var traceability_panel: PanelContainer = _panel(WARN)
	_traceability_text = _rich(13)
	traceability_panel.add_child(_traceability_text)
	right.add_child(traceability_panel)

	# A deliberate interface target over the play field, so the §6 rule that
	# "Interface clicks must not move the player or change a comparison mode" can
	# be tested by hand as well as by the suite.
	var leak: PanelContainer = _panel()
	leak.name = "InterfaceLeakTest"
	leak.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_RIGHT)
	leak.grow_horizontal = Control.GROW_DIRECTION_BEGIN
	leak.grow_vertical = Control.GROW_DIRECTION_BEGIN
	leak.offset_left = -376
	leak.offset_right = -24
	leak.offset_top = -152
	leak.offset_bottom = -24
	leak.mouse_filter = Control.MOUSE_FILTER_STOP
	var leak_box: VBoxContainer = VBoxContainer.new()
	leak_box.add_theme_constant_override("separation", 5)
	leak_box.add_child(_label("Interface leak test", 16, COPPER))
	leak_box.add_child(_label(
		"Clicking this panel must not move the character,\nplace a marker, or change a comparison mode.",
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
	log_panel.offset_right = 852
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
	if comparison == null or comparison.player == null:
		return
	var m: Dictionary = comparison.measurements()
	_update_axes(m)
	_update_route(m)
	_update_controls(m)
	_update_candidates(m)
	_update_traceability(m)
	_update_log()
	_leak_label.text = "panel presses: %d   ·   movement commands issued: %d" % [
		_leak_clicks, comparison.accepted_commands + comparison.adjusted_commands,
	]


func _update_axes(m: Dictionary) -> void:
	var launch: String = (
		"[color=#7fae7f]at the launch baseline[/color]" if bool(m["is_launch_state"])
		else "[color=#e39c6b]changed this session — \\ resets it; nothing is written to disk[/color]"
	)
	_axes_text.text = (
		"[color=#d9954c]Comparison axes[/color]   %s\n" % launch
		+ "[b]F4[/b] terrain      [b]%s[/b]\n" % (
			"Kenney Nature topology" if bool(m["topology_visible"])
			else "existing flat baseline"
		)
		+ "[b]F5[/b] architecture [b]%s[/b]\n" % m["architecture"]
		+ "[b]F7[/b] dressing     [b]%s[/b]\n" % (
			"Kenney Graveyard on" if bool(m["dressing_visible"]) else "off"
		)
		+ "[b]F1[/b] lighting     [b]%s[/b]\n" % m["lighting_mode"]
		+ "[b]F2[/b] materials    [b]%s[/b] over %d registered surfaces\n" % [
			"candidate treatment" if bool(m["materials_candidate"]) else "imported source",
			int(m["treated_surfaces"]),
		]
		+ "                 treatment = saturation x %.2f, value x %.2f, cool tint (%.2f, %.2f, %.2f)\n" % [
			ExteriorReviewTreatment.SATURATION, ExteriorReviewTreatment.VALUE,
			ExteriorReviewTreatment.TINT.r, ExteriorReviewTreatment.TINT.g,
			ExteriorReviewTreatment.TINT.b,
		]
		+ "[color=#8c9099]The same route, the same stations, the same clearances in every combination.\n"
		+ "No review toggle touches collision, so navigation is baked once and never again.[/color]"
	)


func _update_route(m: Dictionary) -> void:
	var cf: Vector2 = m["cf_metres"]
	var position: Vector3 = m["player_position"]
	_route_text.text = (
		"[color=#d9954c]Accepted world relationship — unchanged by this comparison[/color]\n"
		+ "1 unit = [b]%.2f m[/b]   P = [b]%.2f m[/b]   player measured [b]%.2f m[/b] across, %.2f m tall\n" % [
			float(m["world_unit_metres"]), float(m["player_unit_metres"]),
			float(m["player_diameter"]), float(m["player_height"]),
		]
		+ "camera [b]%.1f m[/b] out (accepted default %.1f), pitch %.1f deg, fov %.1f deg   ·   CF %.1f x %.1f m\n" % [
			float(m["camera_distance"]), float(m["camera_distance_default"]),
			float(m["camera_pitch"]), float(m["camera_fov"]), cf.x, cf.y,
		]
		+ "movement [b]%.2f m/s[/b] maximum   ·   route centreline [b]%.1f m[/b] (NOT a room target)\n" % [
			float(m["max_speed"]), float(m["centreline_metres"]),
		]
		+ "clear corridor narrows to [b]%.1f m[/b] (%.1f P)   ·   threshold gap [b]%.3f m[/b] (%.2f P)\n" % [
			float(m["narrowest_corridor"]), float(m["narrowest_corridor"]) / 0.80,
			float(m["threshold_gap"]), float(m["threshold_gap"]) / 0.80,
		]
		+ "dungeon doorway [b]%.3f m[/b]   ·   route [b]%.1f%%[/b] clear of decoration   ·   nav %d polys, %.0f m^2, bake #%d\n" % [
			float(m["dungeon_doorway"]), float(m["route_clear_fraction"]) * 100.0,
			int(m["navmesh_polygons"]), float(m["navmesh_area"]), int(m["bake_count"]),
		]
		+ "player at (%.1f, %.1f)   moving: [b]%s[/b]   input: [b]%s[/b]   %d instances placed" % [
			position.x, position.z, m["movement_mode"], m["input_family"], int(m["instances"]),
		]
	)


func _update_controls(_m: Dictionary) -> void:
	_controls_text.text = (
		"[color=#d9954c]Review controls[/color]   "
		+ "[b]F1[/b] neutral <-> candidate lighting   [b]F2[/b] source <-> candidate materials\n"
		+ "[b]F4[/b] Kenney Nature topology   [b]F5[/b] cycle architecture   "
		+ "[b]F7[/b] Graveyard dressing\n"
		+ "[b]F6[/b] 1 m grid   [b]F3[/b] this overlay   [b][ ][/b] camera distance   "
		+ "[b]\\[/b] reset every mode, the camera, and the player\n"
		+ "[color=#8c9099]Left click or hold to move; left stick to move directly. "
		+ "No WASD, and no attack input exists here.[/color]"
	)


func _update_candidates(m: Dictionary) -> void:
	var by_family: Dictionary = {}
	for row: Dictionary in m["candidates"]:
		var family: String = String(row["family"])
		if not by_family.has(family):
			by_family[family] = ""
		var size: Vector3 = row["size"]
		by_family[family] += "%-21s %5.2f x %5.2f x %5.2f m  %d/%d  x%d\n" % [
			row["display"], size.x, size.y, size.z,
			int(row["meshes"]), int(row["surfaces"]), int(row["instances"]),
		]
	var text: String = "[color=#d9954c]D-202 candidates — measured at root scale 1.0[/color]\n"
	for family: String in ExteriorCohesionCatalogue.candidate_families():
		if not by_family.has(family):
			continue
		text += "[b]%s[/b]\n%s" % [family, by_family[family]]
	text += (
		"[color=#8c9099]size · meshes/surfaces · instances placed. "
		+ "Nothing is rescaled; a 1 m kit TILES to fill a 4 m role.\n"
		+ "Foreground / background-only / rejected is YOUR call, not the suite's.[/color]"
	)
	_candidates_text.text = text


func _update_traceability(m: Dictionary) -> void:
	_traceability_text.text = (
		"[color=#e39c6b]Measured module ladder, at 1 unit = 1 metre[/color]\n"
		+ "KayKit Dungeon / Halloween  [b]4.000 m[/b] module\n"
		+ "Quaternius Modular Ruins    [b]1.990 - 3.993 m[/b] modules\n"
		+ "Kenney Nature / Town / Graveyard  [b]1.000 m[/b] module\n"
		+ "[color=#e39c6b]Source materials: the colour atlas restored under D-204[/color]\n"
		+ "[b]%d[/b] of the 21 models declare an external colour atlas, "
			% int(m["atlas_dependent_models"])
		+ "'%s'.\n" % ExteriorCohesionCatalogue.DECLARED_EXTERNAL_URI
		+ "D-202 did not authorize it, so at first delivery all nine rendered untextured.\n"
		+ "[b]D-204 restored both atlases[/b] and every Kenney Fantasy Town and Graveyard\n"
		+ "piece now resolves its own kit's atlas, so [b]their colour IS being judged.[/b]\n"
		+ "[color=#8c9099]One consequence, stated rather than hidden: those nine are\n"
		+ "double-sided in source, and a TEXTURED surface takes the treatment's shader\n"
		+ "branch, which renders cull_back. They are single-sided under the treatment and\n"
		+ "double-sided under F2 source. The imported material itself is never changed.\n"
		+ "Kenney Nature and Quaternius carry no texture by design: flat named colour\n"
		+ "materials. Kenney Nature also imports fully METALLIC, which is why it is dark\n"
		+ "under source materials and correct under the candidate treatment.[/color]"
	)


func _update_log() -> void:
	var lines: PackedStringArray = comparison.log_lines
	var from: int = maxi(lines.size() - 8, 0)
	var text: String = "[color=#d9954c]Log[/color]\n"
	for i: int in range(from, lines.size()):
		text += "%s\n" % lines[i]
	_log_text.text = text
