class_name CinderReviewHud
extends CanvasLayer

## THE CINDER FIELD REVIEW HUD (D-402) — compact, click-through, and nothing more.
##
## ============================================================================
## REVIEW TOOLING. IT IS NOT A UI FOUNDATION, NOT A PRODUCTION HUD, NOT A STYLE.
## ============================================================================
## The owner: "Add a compact diagnostic review HUD that does not obstruct play
## and shows: Cinder Field's binding and readiness; active trap count and
## provisional cap; armed/dormant/sprung state; current provisional timings; Hit
## and Ground damage events separately; why a placement or trigger was refused."
##
## It shows ONLY those six and its title. Nothing else is added, and no
## production UI is begun -- `design/UI_AND_USER_EXPERIENCE.md` is byte-identical.
##
## ---------------------------------------------------------------------------
## IT OWNS NO NUMBER.
## ---------------------------------------------------------------------------
## Every value is read at draw time from the live `CinderRuntime`, the live
## `SkillRuntime` and `CinderConfig`. The D-402 suite scans this file's CODE for
## a numeric gameplay literal and PROVES the scan can find a planted one.
##
## ---------------------------------------------------------------------------
## IT NEVER EATS A CLICK, AND IT SITS WHERE NOTHING ELSE DOES.
## ---------------------------------------------------------------------------
## Click-to-move is the canonical mouse scheme, so every Control here is
## `MOUSE_FILTER_IGNORE`. It sits in the RIGHT COLUMN, BELOW the D-396 Kindred
## Hounds HUD: clear of the screen centre where the character is, clear of the
## D-392 HUD at bottom-right, clear of the D-398 HUD at bottom-centre, and clear
## of the F1 overlay's column down the left edge. The D-402 suite MEASURES the
## live rectangles and asserts no overlap rather than trusting this comment.

var runtime: CinderRuntime = null
var enabled: bool = false
var toggles: int = 0
var refreshes: int = 0
var body: PanelContainer
var lines: Dictionary = {}
var last_text: String = ""

## RE-SCOPED ONE FOR ONE AT DELIVERY (D-402, 2026-09-20): 8 + 1 = 9 lines.
## FOUND BY LOOKING AT A RENDERED FRAME, not by any check: four of the eight
## lines were CUT with an ellipsis at 1920 x 1080 -- the binding, the states,
## the timings and whichever damage line had just fired -- so the HUD's own
## numbers were unreadable in the picture that was meant to show them. The
## project has made this exact mistake before (D-398, two cut-off HUD lines).
## The fix is two-part: the cap rises to the SAME 100 the ACCEPTED D-396 HUD
## uses in the SAME column -- which is measured, not guessed, because that HUD
## renders a 93-character line there without clipping -- and the one genuinely
## over-long line is SPLIT into its timings and its geometry, which a reviewer
## wants separately anyway.
const LINE_KEYS := ["title", "binding", "instances", "states", "timings", "geometry", "hit", "ground", "refusal"]
## LAYOUT, not gameplay: a line longer than this is cut with an ellipsis, so the
## HUD keeps to its column.
const MAX_LINE_CHARS := 100
## LAYOUT, not gameplay: the D-396 HUD occupies the top of the right column
## (16 px margin plus its own height). This clearance puts this HUD beneath it.
const TOP_CLEARANCE_PX := 212.0

## Every text line, composed from the live objects.
func compose_lines() -> Dictionary:
	var s := runtime.review_snapshot()
	var ready := "READY"
	if String(s["state"]) != "ACTIVE":
		ready = String(s["state"])
	elif float(s["cooldown"]) > 0.0:
		ready = "COOLING %.2f s" % float(s["cooldown"])
	elif float(s["mana_current"]) < float(s["cost"]):
		ready = "NOT ENOUGH MANA"
	var binding := "BINDING %d (key 7) · %s · rank %d / mastered %d · %.0f XP · cost %.1f of %.0f Mana" \
		% [int(s["binding"]), ready, int(s["rank"]), int(s["mastered"]), float(s["xp"]),
		   float(s["cost"]), float(s["mana_current"])]
	var instances := "TRAPS %d of %d (PROVISIONAL cap) · burning fields %d · placed %d · refused %d" \
		% [int(s["dormant"]), int(s["cap"]), int(s["fields"]), int(s["placements"]), int(s["refusals"])]
	var states := "DORMANT %d · ARMED %d · SPRUNG %d — erupted %d · oldest replaced %d · expired harmlessly %d" \
		% [int(s["dormant"]) - int(s["armed"]), int(s["armed"]), int(s["sprung"]),
		   int(s["eruptions"]), int(s["replacements"]), int(s["expiries"])]
	var timings := "PROVISIONAL TIMINGS (s): arm %.2f · release %.2f of %.2f · dormant %.1f · field %.1f · tick %.2f" \
		% [CinderConfig.ARMING_DELAY_S, CinderConfig.RELEASE_S, CinderConfig.action_s(),
		   CinderConfig.DORMANT_DURATION_S, CinderConfig.GROUND_DURATION_S, CinderConfig.GROUND_TICK_S]
	var geometry := "PROVISIONAL AREA: trigger %.2f m · eruption %.2f m · burning ground %.2f m · action phase %s" \
		% [CinderConfig.TRIGGER_RADIUS_M, CinderConfig.ERUPTION_RADIUS_M, CinderConfig.GROUND_RADIUS_M,
		   String(s["phase"])]
	# THE BRIEF FORM OF EACH EVENT, so the line is not cut off. The FULL record is
	# printed in the run log and read by the suite; this HUD shows the short one.
	var hit := "HIT %.0f total in %d Fire Hits — %s" % [float(s["hit_damage"]), int(s["hit_events"]),
		String(s["last_hit_brief"]) if String(s["last_hit_brief"]) != "" else "no eruption yet"]
	var ground := "GROUND %.0f in %d contributions over %d ticks — %s" \
		% [float(s["ground_damage"]), int(s["ground_contributions"]), int(s["ground_ticks"]),
		   String(s["last_ground_brief"]) if String(s["last_ground_brief"]) != "" else "no burning ground yet"]
	var refusal := "LAST REFUSAL: %s" % (String(s["last_refusal_brief"]) if String(s["last_refusal_brief"]) != ""
		else "none — every placement so far was on walkable ground")
	return {
		"title": CinderConfig.HUD_TITLE,
		"binding": binding,
		"instances": instances,
		"states": states,
		"timings": timings,
		"geometry": geometry,
		"hit": hit,
		"ground": ground,
		"refusal": refusal,
	}

func build() -> void:
	layer = 9
	var frame := Control.new()
	frame.name = "CinderHudFrame"
	frame.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	frame.offset_left = 16.0
	frame.offset_top = TOP_CLEARANCE_PX
	frame.offset_right = -16.0
	frame.offset_bottom = -16.0
	frame.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(frame)
	var column := VBoxContainer.new()
	column.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	column.mouse_filter = Control.MOUSE_FILTER_IGNORE
	frame.add_child(column)
	var row := HBoxContainer.new()
	row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	column.add_child(row)
	var left_spacer := Control.new()
	left_spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	left_spacer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	row.add_child(left_spacer)
	# RIGHT COLUMN, BENEATH THE D-396 HUD: the bottom spacer keeps the row at the
	# top of this frame, which already starts below that HUD.
	body = PanelContainer.new()
	body.name = "CinderHudBody"
	body.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(0.05, 0.02, 0.01, 0.78)
	sb.content_margin_left = 10
	sb.content_margin_right = 10
	sb.content_margin_top = 6
	sb.content_margin_bottom = 6
	body.add_theme_stylebox_override("panel", sb)
	row.add_child(body)
	var bottom_spacer := Control.new()
	bottom_spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	bottom_spacer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	column.add_child(bottom_spacer)
	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 2)
	v.mouse_filter = Control.MOUSE_FILTER_IGNORE
	body.add_child(v)
	var colors := {"title": Color(1.0, 0.74, 0.42), "binding": Color(1, 1, 1),
		"instances": Color(1.0, 0.86, 0.55), "states": Color(0.96, 0.80, 0.62),
		"timings": Color(0.78, 0.82, 0.92), "geometry": Color(0.72, 0.78, 0.90),
		"hit": Color(1.0, 0.86, 0.47),
		"ground": Color(1.0, 0.62, 0.36), "refusal": Color(0.86, 0.80, 0.80)}
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
	if runtime == null or body == null:
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
