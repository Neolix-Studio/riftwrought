class_name HuntressReviewHud
extends CanvasLayer

## THE SPLINTER SHOT REVIEW HUD (D-392) — small, playable, and nothing more.
##
## ============================================================================
## REVIEW TOOLING. IT IS NOT A UI FOUNDATION, NOT A PRODUCTION HUD, NOT A STYLE.
## ============================================================================
## The owner asked for "a small playable review HUD" for Splinter Shot and the
## action state (D-392; its third subject was removed with the mechanic under
## D-393). So it shows ONLY:
##   * how to use Splinter Shot, and whether it can be used now;
##   * the action state and its PROVISIONAL timing;
##   * facing -- mechanical against visual, and the alignment at release;
##   * what the last arrow did;
##   * Mana against the cost, because a refusal for Mana must be explicable.
## P1A's transferred UI debt is UNCHANGED.
##
## IT OWNS NO NUMBER: every value is read at draw time from
## `HuntressRuntime.review_snapshot()`, which reads the live controller,
## commitment, loadout, pool and animator. The D-392 suite scans this
## file's CODE for a numeric gameplay literal and proves the scan can find one.
##
## IT NEVER EATS A CLICK: click-to-move is canonical, so every Control here is
## `MOUSE_FILTER_IGNORE`.

var runtime: HuntressRuntime = null
var enabled: bool = false
var toggles: int = 0
var refreshes: int = 0
var body: PanelContainer
var lines: Dictionary = {}
var last_text: String = ""

const LINE_KEYS := ["title", "input", "state", "timing", "facing", "arrow", "mana"]

## Every text line, composed from the live snapshot.
func compose_lines() -> Dictionary:
	var s := runtime.review_snapshot()
	var state := "READY — press or hold to shoot"
	if bool(s["deactivated"]):
		state = "DEACTIVATED by the loadout (Capacity) — see the F2 panel"
	elif bool(s["splinter"]):
		var ph := String(s["phase"])
		if ph == "windup":
			state = "DRAW %.2f / %.2f s — committed; movement is BUFFERED" \
				% [float(s["elapsed"]), float(s["release_at"])]
		else:
			state = "RECOVERY %.2f / %.2f s — MOVE to cancel it; the arrow is already away" \
				% [float(s["elapsed"]), float(s["duration"])]
	elif bool(s["committed"]):
		state = "another action is committed (%s)" % String(s["label"])
	elif String(s["last_refusal"]) != "" and String(s["last_refusal"]).findn("mana") >= 0:
		state = "REFUSED — %s" % String(s["last_refusal"])
	var facing := "FACING: follows the aim"
	if bool(s["hold"]):
		var gap := absf(rad_to_deg(wrapf(float(s["visual_yaw"]) - float(s["mechanical_yaw"]), -PI, PI)))
		facing = "FACING: SNAPPED to the sampled aim · visual %s (%.1f° off)" \
			% ["aligned" if gap <= HuntressConfig.VISUAL_ALIGN_TOLERANCE_DEG else "blending", gap]
	elif int(s["uses"]) > 0:
		facing = "FACING: follows the aim · last release: visual %.1f° from the snapped facing%s" \
			% [float(s["last_alignment_deg"]),
			   "" if int(s["late_visual_alignments"]) == 0 else " · LATE %d" % int(s["late_visual_alignments"])]
	var arrow := "ARROW: none yet"
	var lo: Dictionary = s["last_outcome"]
	if not lo.is_empty():
		match String(lo["outcome"]):
			"hit":
				arrow = "ARROW %s: HIT %s at %.2f m%s" % [String(lo["use_id"]), String(lo["id"]),
					float(lo["distance_m"]),
					"" if (lo["tie_set"] as Array).size() <= 1
					else " · TIE %s → lowest ID" % str(lo["tie_set"])]
			"wall":
				arrow = "ARROW %s: STOPPED BY WORLD GEOMETRY at %.2f m — no Hit" \
					% [String(lo["use_id"]), float(lo["distance_m"])]
			_:
				arrow = "ARROW %s: expired at its range — no Hit" % String(lo["use_id"])
	if int(s["arrows"]) > 0:
		arrow += " · %d arrow(s) / %d use(s)" % [int(s["arrows"]), int(s["uses"])]
	return {
		"title": HuntressConfig.HUD_TITLE,
		"input": "SPLINTER SHOT — %s (binding %d) · hold to repeat" % [_input_hint(), int(s["binding"])],
		"state": "ACTION: " + state,
		"timing": "release %.2f s · recovery %.3f s · clip ×%.2f (derived) — PROVISIONAL, not locked"
			% [float(s["release_at"]), float(s["recovery"]), float(s["playback_rate"])],
		"facing": facing,
		"arrow": arrow,
		"mana": "MANA %.0f / %.0f usable · Splinter Shot costs %.1f" % [float(s["mana_current"]),
			float(s["mana_usable"]), float(s["cost"])],
	}

## The physical inputs of the binding that holds Splinter Shot, read from the
## InputMap so the hint stays true if rebound.
func _input_hint() -> String:
	var action := String(SkillRuntime.BINDING_ACTIONS[HuntressContent.BINDING_INDEX])
	var parts: Array[String] = []
	if InputMap.has_action(action):
		for ev in InputMap.action_get_events(action):
			if ev is InputEventMouseButton:
				parts.append("right mouse" if (ev as InputEventMouseButton).button_index == MOUSE_BUTTON_RIGHT
					else "mouse %d" % (ev as InputEventMouseButton).button_index)
			elif ev is InputEventKey:
				parts.append("key " + OS.get_keycode_string((ev as InputEventKey).physical_keycode))
			elif ev is InputEventJoypadButton:
				parts.append("pad button %d" % (ev as InputEventJoypadButton).button_index)
	return " / ".join(parts) if not parts.is_empty() else "(unbound)"

func build() -> void:
	layer = 9
	var frame := Control.new()
	frame.name = "SplinterHudFrame"
	frame.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	frame.offset_left = 16.0
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
	# BOTTOM-RIGHT, like the D-381 HUD it replaces at launch: clear of the centre
	# and of the F1 overlay's left column.
	var left_spacer := Control.new()
	left_spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	left_spacer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	row.add_child(left_spacer)
	body = PanelContainer.new()
	body.name = "SplinterHudBody"
	body.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(0.02, 0.02, 0.05, 0.78)
	sb.content_margin_left = 10
	sb.content_margin_right = 10
	sb.content_margin_top = 6
	sb.content_margin_bottom = 6
	body.add_theme_stylebox_override("panel", sb)
	row.add_child(body)
	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 2)
	v.mouse_filter = Control.MOUSE_FILTER_IGNORE
	body.add_child(v)
	var colors := {"title": Color(0.62, 0.83, 1.0), "input": Color(1, 1, 1),
		"state": Color(1.0, 0.86, 0.47), "timing": Color(0.80, 0.80, 0.86),
		"facing": Color(0.86, 0.92, 1.0), "arrow": Color(1, 1, 1),
		"mana": Color(0.62, 0.74, 1.0)}
	for k in LINE_KEYS:
		var l := Label.new()
		l.name = "Line_%s" % k
		l.mouse_filter = Control.MOUSE_FILTER_IGNORE
		l.add_theme_font_size_override("font_size", 15)
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
	if runtime == null or body == null:
		return
	refreshes += 1
	var t := compose_lines()
	var joined: Array[String] = []
	for k in LINE_KEYS:
		(lines[k] as Label).text = String(t[k])
		joined.append(String(t[k]))
	last_text = "\n".join(joined)

func body_rect() -> Rect2:
	return body.get_global_rect() if body != null else Rect2()
