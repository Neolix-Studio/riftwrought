class_name CohortReviewHud
extends CanvasLayer

## THE MOBILE MINION COHESION REVIEW HUD (D-398) — compact, click-through, and
## nothing more.
##
## ============================================================================
## REVIEW TOOLING. IT IS NOT A UI FOUNDATION, NOT A PRODUCTION HUD, NOT A STYLE.
## ============================================================================
## The owner: "Provide a compact click-through review HUD showing diagnostic
## population, speed mode, formation/regrouping state, furthest lagging distance
## and soft-recovery count. Developer panels remain hidden at launch." So it
## shows ONLY those five, its title and the two review controls:
##   * the DIAGNOSTIC population -- the pack plus stress minions;
##   * the DIAGNOSTIC travel speed -- its mode, its scale and the speed it gives;
##   * the formation / regrouping state, with how many members are in each mode;
##   * the furthest lag of any member from its slot, and how far the farthest
##     member is from her;
##   * the soft recoveries, by cause.
## It sits BOTTOM-CENTRE: right of the F1 overlay's column (hidden at launch),
## left of the D-392 HUD at bottom-right, below the central play area. The D-396
## HUD stays top-right.
##
## IT OWNS NO NUMBER: every value is read at draw time from the live cohort, the
## live runtime and the live diagnostics. The D-398 suite scans this file's CODE
## for a numeric gameplay literal and proves the scan can find one.
##
## IT NEVER EATS A CLICK: click-to-move is canonical, so every Control here is
## `MOUSE_FILTER_IGNORE`.

var runtime: HoundRuntime = null
var diagnostics: CohortDiagnostics = null
var enabled: bool = false
var toggles: int = 0
var refreshes: int = 0
var body: PanelContainer
var lines: Dictionary = {}
var last_text: String = ""

const LINE_KEYS := ["title", "population", "speed", "formation", "lag", "recovery", "controls"]
## LAYOUT, not gameplay: a line longer than this is cut with an ellipsis, so the
## HUD keeps to its gap between the F1 overlay's column and the D-392 HUD.
const MAX_LINE_CHARS := 74
## LAYOUT, not gameplay: the F1 overlay's column (16 px margin + 700 px panel)
## plus a gap -- so this HUD never sits under the overlay when it is shown.
const LEFT_CLEARANCE_PX := 716.0

## Every text line, composed from the live objects.
func compose_lines() -> Dictionary:
	var c := runtime.cohort
	var pack_n := runtime.pack.size()
	var stress_n := runtime.stress.size()
	var population := "DIAGNOSTIC POPULATION %d · %d Kindred Hounds + %d DIAGNOSTIC stress minions" \
		% [pack_n + stress_n, pack_n, stress_n]
	if pack_n == 0:
		population = "DIAGNOSTIC POPULATION %d chosen · no pack (the Persistent is not active)" % diagnostics.population()
	var speed := "DIAGNOSTIC SPEED %s ×%.2f = %.2f m/s · accepted %.3f m/s unchanged" \
		% [diagnostics.speed_name(), diagnostics.speed_scale(),
		   ProdConfig.TOP_SPEED_MPS * diagnostics.speed_scale(), ProdConfig.TOP_SPEED_MPS]
	var formation := "%s %s · form %d · combat %d · regroup %d · rejoin %d" \
		% [c.profile.profile_name, c.formation_state, c.count_in(MobileCohort.Mode.FORMATION),
		   c.count_in(MobileCohort.Mode.ENGAGED), c.count_in(MobileCohort.Mode.REGROUP),
		   c.count_in(MobileCohort.Mode.RECOVER)]
	var lag := "FURTHEST LAG %.2f m from its slot (%s) · farthest %.1f m from her" \
		% [c.furthest_lag, c.furthest_lag_id if c.furthest_lag_id != "" else "none", c.farthest_from_her]
	var recovery := "SOFT RECOVERIES %d — path failure %d · far behind %d · regroup %d" \
		% [c.total_recoveries(), int(c.recoveries[MobileCohort.CAUSE_PATH]),
		   int(c.recoveries[MobileCohort.CAUSE_FAR]), int(c.recoveries[MobileCohort.CAUSE_REGROUP])]
	return {
		"title": CohortConfig.HUD_TITLE,
		"population": population,
		"speed": speed,
		"formation": formation,
		"lag": lag,
		"recovery": recovery,
		"controls": "%s: population · %s: speed — DIAGNOSTIC, not commands"
			% [_keys_of(CohortConfig.POPULATION_ACTION), _keys_of(CohortConfig.SPEED_ACTION)],
	}

## The physical inputs of an action, read from the InputMap so the hint stays
## true if rebound.
func _keys_of(action: String) -> String:
	var parts: Array[String] = []
	if InputMap.has_action(action):
		for ev in InputMap.action_get_events(action):
			if ev is InputEventKey:
				parts.append(OS.get_keycode_string((ev as InputEventKey).physical_keycode))
			elif ev is InputEventJoypadButton:
				parts.append("pad %d" % (ev as InputEventJoypadButton).button_index)
	return " / ".join(parts) if not parts.is_empty() else "(unbound)"

func build() -> void:
	layer = 9
	var frame := Control.new()
	frame.name = "CohortHudFrame"
	frame.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	frame.offset_left = LEFT_CLEARANCE_PX + 8.0
	frame.offset_top = 16.0
	frame.offset_right = -16.0
	frame.offset_bottom = -16.0
	frame.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(frame)
	var column := VBoxContainer.new()
	column.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	column.mouse_filter = Control.MOUSE_FILTER_IGNORE
	frame.add_child(column)
	var top_spacer := Control.new()
	top_spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	top_spacer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	column.add_child(top_spacer)
	var row := HBoxContainer.new()
	row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	column.add_child(row)
	# BOTTOM, LEFT-ALIGNED inside the gap: the right spacer keeps it off the D-392
	# HUD at bottom-right.
	body = PanelContainer.new()
	body.name = "CohortHudBody"
	body.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(0.03, 0.03, 0.02, 0.78)
	sb.content_margin_left = 10
	sb.content_margin_right = 10
	sb.content_margin_top = 6
	sb.content_margin_bottom = 6
	body.add_theme_stylebox_override("panel", sb)
	row.add_child(body)
	var right_spacer := Control.new()
	right_spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	right_spacer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	row.add_child(right_spacer)
	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 2)
	v.mouse_filter = Control.MOUSE_FILTER_IGNORE
	body.add_child(v)
	var colors := {"title": Color(1.0, 0.86, 0.55), "population": Color(1, 1, 1),
		"speed": Color(0.62, 0.86, 1.0), "formation": Color(0.80, 0.96, 0.80),
		"lag": Color(1.0, 0.86, 0.47), "recovery": Color(0.95, 0.80, 0.95),
		"controls": Color(0.78, 0.78, 0.84)}
	for k in LINE_KEYS:
		var l := Label.new()
		l.name = "Line_%s" % k
		l.mouse_filter = Control.MOUSE_FILTER_IGNORE
		l.add_theme_font_size_override("font_size", 14)
		l.add_theme_color_override("font_color", colors[k])
		v.add_child(l)
		lines[k] = l
	set_enabled(true)

func set_enabled(on: bool) -> void:
	if enabled != on:
		toggles += 1
	enabled = on
	visible = on

func _process(_delta: float) -> void:
	if enabled:
		refresh()

func refresh() -> void:
	if runtime == null or diagnostics == null or runtime.cohort == null or body == null:
		return
	refreshes += 1
	var t := compose_lines()
	var joined: Array[String] = []
	for k in LINE_KEYS:
		var line := _fit(String(t[k]))
		(lines[k] as Label).text = line
		joined.append(line)
	last_text = "\n".join(joined)

static func _fit(line: String) -> String:
	return line if line.length() <= MAX_LINE_CHARS else line.left(MAX_LINE_CHARS - 1) + "…"

func body_rect() -> Rect2:
	return body.get_global_rect() if body != null else Rect2()
