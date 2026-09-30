class_name DirectClickReviewHud
extends CanvasLayer

## THE D-404 DIRECT-CLICK REVIEW HUD — compact, click-through, and nothing more.
##
## The owner asked for "only enough diagnostic presentation to review the
## correction": the actual clicked destination, the straight intended segment,
## the first blocking contact, whether the order stopped because it ARRIVED or
## COLLIDED, and zero player path points / queries. That is what it shows, and
## nothing else. The world markers (`DirectClickGizmo`) draw the same three
## things on the ground.
##
## IT IS REVIEW TOOLING, NOT A UI FOUNDATION. It owns no number: every value is
## read at draw time from the live order and the live player. Every Control is
## MOUSE_FILTER_IGNORE, because click-to-move is the canonical mouse scheme and a
## HUD that ate a click would change the very thing it exists to show.
##
## TOP-CENTRE, MEASURED. It was first placed top-left -- and a live measurement
## at 1920 x 1080 found the F1 overlay's panel spans the WHOLE left column,
## (16, 16) at 700 x 1580, and the accepted HUD checks refuse any overlap with it
## even though it launches hidden. So it starts at x = 724, the same left edge the
## accepted D-398 HUD uses beside that overlay, and must stay narrower than the
## gap to the D-396 HUD at x = 1182. F1 and F2 stay HIDDEN at launch (D-382).

var player: PlayerController = null
var diagnostics: CohortDiagnostics = null
var gizmo: DirectClickGizmo = null
var enabled: bool = false
var toggles: int = 0
var refreshes: int = 0
var body: PanelContainer
var lines: Dictionary = {}
var last_text: String = ""

const LINE_KEYS := ["title", "order", "state", "contact", "path", "speed", "counts"]
## STRUCTURAL: the widest line this band shows. The band between the F1
## overlay and the D-396 HUD is about 450 px, so the lines are kept short.
const MAX_LINE_CHARS := 60
## STRUCTURAL: the band's left edge, beside the F1 overlay (16 + 700 + 8).
const LEFT_PX := 724.0

static func _v(p: Vector3) -> String:
	return "(%.2f, %.2f)" % [p.x, p.z]

## The lines, composed from LIVE values only.
func compose_lines() -> Dictionary:
	var o := player.click_order
	var title := "D-404 DIRECT CLICK — review tooling, not a UI"
	var order := "NO CLICK ORDER YET"
	var state := "—"
	var contact := "CONTACT none"
	if o.orders_issued > 0:
		var seg: Array = o.segment()
		var length := NavService.planar_distance(Vector3(seg[0]), Vector3(seg[1]))
		order = "CLICK %s · straight %.2f m" % [_v(o.destination), length]
		if o.active:
			state = "TRAVELLING straight, %.2f of %.2f m" % [o.travelled_m, length]
		elif o.stop_reason == DirectClickOrder.STOP_ARRIVED:
			state = "ARRIVED %.2f m from the click" \
				% NavService.planar_distance(player.global_position, o.destination)
		elif o.stop_reason == DirectClickOrder.STOP_COLLIDED:
			state = "COLLIDED %s, %.2f m short" \
				% ["holding, did not move" if o.stopped_at_existing_contact else "at first contact",
				   NavService.planar_distance(player.global_position, o.destination)]
		elif o.stop_reason == DirectClickOrder.STOP_CANCELLED:
			state = "CANCELLED by stick, action or new order"
		if o.has_contact:
			contact = "CONTACT %s %s n(%.2f, %.2f)" \
				% [_v(o.contact_point), o.contact_collider, o.contact_normal.x, o.contact_normal.z]
	var path := "PLAYER PATH %d points · %d queries" % [o.path_points, o.path_queries]
	var mode := diagnostics.speed_name() if diagnostics != null else "?"
	var top := ProdConfig.TOP_SPEED_MPS * player.diagnostic_travel_speed_scale
	var speed := "%s x%.2f · max %.3f · now %.3f m/s" \
		% [mode, player.diagnostic_travel_speed_scale, top, player.motor.speed()]
	var counts := "orders %d · arrived %d · collided %d · cancelled %d" \
		% [o.orders_issued, o.arrivals, o.collisions, o.cancellations]
	return {"title": title, "order": order, "state": state, "contact": contact,
		"path": path, "speed": speed, "counts": counts}

func build() -> void:
	layer = 9
	var frame := Control.new()
	frame.name = "DirectClickHudFrame"
	frame.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	frame.offset_left = LEFT_PX
	frame.offset_top = 16.0
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
	body = PanelContainer.new()
	body.name = "DirectClickHudBody"
	body.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(0.02, 0.04, 0.07, 0.78)
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
	var bottom_spacer := Control.new()
	bottom_spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	bottom_spacer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	column.add_child(bottom_spacer)
	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 2)
	v.mouse_filter = Control.MOUSE_FILTER_IGNORE
	body.add_child(v)
	var colors := {"title": Color(0.62, 0.86, 1.0), "order": DirectClickGizmo.COL_DESTINATION,
		"state": Color(1, 1, 1), "contact": DirectClickGizmo.COL_CONTACT,
		"path": Color(0.72, 0.92, 0.72), "speed": Color(0.78, 0.82, 0.92),
		"counts": Color(0.80, 0.80, 0.86)}
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
	if gizmo != null:
		gizmo.visible = on

func _process(_delta: float) -> void:
	if enabled:
		refresh()

func refresh() -> void:
	if player == null or body == null:
		return
	refreshes += 1
	var t := compose_lines()
	var joined: Array[String] = []
	for k in LINE_KEYS:
		var line := _fit(String(t[k]))
		(lines[k] as Label).text = line
		joined.append(line)
	last_text = "\n".join(joined)
	if gizmo != null:
		gizmo.redraw()

static func _fit(line: String) -> String:
	return line if line.length() <= MAX_LINE_CHARS else line.left(MAX_LINE_CHARS - 1) + "…"

func body_rect() -> Rect2:
	return body.get_global_rect() if body != null else Rect2()
