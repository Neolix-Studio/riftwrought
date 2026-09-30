class_name HoundReviewHud
extends CanvasLayer

## THE KINDRED HOUNDS REVIEW HUD (D-396) — compact, click-through, and nothing more.
##
## ============================================================================
## REVIEW TOOLING. IT IS NOT A UI FOUNDATION, NOT A PRODUCTION HUD, NOT A STYLE.
## ============================================================================
## The owner: "Add a compact, click-through review HUD showing the Persistent
## state, reservation resource, living/returning hound count and a concise
## targeting reason. F1/F2 developer surfaces remain hidden at launch." So it
## shows ONLY:
##   * the Persistent state -- ACTIVE, UNEQUIPPED or DEACTIVATED with the accepted
##     revalidation's own reason -- and the Imprint's rank and XP;
##   * what the pack reserves, of which resource, and what that leaves usable;
##   * how many hounds are living and how many are returning;
##   * ONE concise targeting reason per hound, H1 and H2 -- the labels over the
##     stand-ins in the world;
##   * the two review controls, read from the InputMap.
## It sits TOP-RIGHT: the D-392 Splinter Shot HUD stays where it was accepted,
## bottom-right, and the F1 overlay -- hidden at launch, top-left -- grows DOWN
## the left edge when shown, far enough to cover a bottom-left panel (measured by
## the D-396 suite, B39). P1A's transferred UI debt is UNCHANGED.
##
## IT OWNS NO NUMBER: every value is read at draw time from
## `HoundRuntime.review_snapshot()`, which reads the live loadout, pool, library
## and hounds. The D-396 suite scans this file's CODE for a numeric gameplay
## literal and proves the scan can find one.
##
## IT NEVER EATS A CLICK: click-to-move is canonical, so every Control here is
## `MOUSE_FILTER_IGNORE`.

var runtime: HoundRuntime = null
var enabled: bool = false
var toggles: int = 0
var refreshes: int = 0
var body: PanelContainer
var lines: Dictionary = {}
var last_text: String = ""

const LINE_KEYS := ["title", "persistent", "reservation", "pack", "h1", "h2", "controls"]
## A LAYOUT limit, not a gameplay value: a line longer than this is cut with an
## ellipsis, so the HUD keeps to its corner and never reaches the D-392 HUD.
const MAX_LINE_CHARS := 100

## Every text line, composed from the live snapshot.
func compose_lines() -> Dictionary:
	var s := runtime.review_snapshot()
	var persistent := "PERSISTENT Kindred Hounds: %s — %s · rank %d (mastered %d, %.0f XP)" \
		% [String(s["state"]), String(s["reason"]), int(s["rank"]), int(s["mastered"]), float(s["xp"])]
	var reservation := "RESERVES nothing — no pack is sustained"
	if String(s["state"]) == "ACTIVE":
		match String(s["resource"]):
			"mana":
				reservation = "RESERVES %.1f%% of max Mana = %.0f · usable Mana %.0f / %.0f · regen %.1f/s (from unreserved max)" \
					% [float(s["fraction"]) * 100.0, float(s["amount"]), float(s["mana_usable"]),
					   float(s["mana_max"]), float(s["regen"])]
			"life":
				reservation = "RESERVES %.1f%% of max Life (%.1f%% of Mana × %.3f) = %.0f · usable Health %.0f / %.0f" \
					% [float(s["fraction"]) * 100.0, float(s["mana_basis"]) * 100.0, float(s["ratio"]),
					   float(s["amount"]), float(s["life_usable"]), float(s["life_max"])]
	var pack := "PACK none — %s" % String(s["state"])
	if int(s["pack_size"]) > 0:
		pack = "PACK %d living · %d returning" % [int(s["living"]), int(s["returning"])]
	var per := {}
	for h in s["hounds"]:
		per[int(h["index"])] = _reason_line(h)
	return {
		"title": HoundConfig.HUD_TITLE,
		"persistent": persistent,
		"reservation": reservation,
		"pack": pack,
		"h1": String(per.get(0, "H1 — no hound (the Persistent is not active)")),
		"h2": String(per.get(1, "H2 — no hound (the Persistent is not active)")),
		"controls": "%s: Persistent OFF → MANA → LIFE · %s: fell a hound (DIAGNOSTIC review control)"
			% [_keys_of(SkillRuntime.RESERVATION_CYCLE_ACTION), _keys_of(HoundConfig.FALL_ACTION)],
	}

## One hound's concise reason: what it is doing and why, in one line.
func _reason_line(h: Dictionary) -> String:
	var tag := "H%d" % (int(h["index"]) + 1)
	var hound: KindredHound = null
	for p in runtime.pack:
		if p != null and is_instance_valid(p) and (p as KindredHound).index == int(h["index"]):
			hound = p
	if String(h["state"]) == "FALLEN":
		return "%s FALLEN — returns by itself in %.1f s (no input, no cost)" % [tag, maxf(0.0, float(h["returning_in"]))]
	# D-398: the shared cohort's two new states, in the hound's own words.
	if String(h["state"]) == "RECOVER" and hound != null:
		return "%s SOFT RECOVERY — %s; it bites nothing until it has rejoined" % [tag, hound.recover_cause]
	if String(h["state"]) == "REGROUP":
		# The abandoned target's ID only: its code would repeat this line's own words
		# (found at delivery -- the rendered frame showed it doubled and cut).
		var left := hound.abandon_id if hound != null and hound.abandon_id != "" else "no target"
		return "%s RETURNING TO HER — REGROUPING: she is beyond the %.1f m leash · left %s" % [tag, HoundConfig.LEASH_RANGE_M, left]
	var code := String(h["code"])
	var id := String(h["target"])
	if id != "":
		var why := "nearest to %s inside %.1f m of her" % [tag, HoundConfig.ACQUISITION_RANGE_M]
		if code == HoundTargeting.RETAINED:
			why = "still valid: eligible, reachable, inside the %.1f m leash" % HoundConfig.LEASH_RANGE_M
		elif code == HoundTargeting.ACQUIRED_TIE:
			why = "exact distance tie → the lower combat-entity ID"
		return "%s %s ▸ %s · %s — %s" % [tag, String(h["state"]), id, code, why]
	if hound != null and hound.abandon_code != "":
		return "%s RETURNING TO HER — %s %s" % [tag, hound.abandon_code, hound.abandon_id]
	return "%s FOLLOWING — no eligible, reachable enemy inside %.1f m of her" % [tag, HoundConfig.ACQUISITION_RANGE_M]

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
	frame.name = "HoundHudFrame"
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
	var row := HBoxContainer.new()
	row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	column.add_child(row)
	var left_spacer := Control.new()
	left_spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	left_spacer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	row.add_child(left_spacer)
	# TOP-RIGHT: clear of the centre, of the F1 overlay down the left edge, and of
	# the D-392 HUD at bottom-right. A bottom spacer keeps the row at the top.
	body = PanelContainer.new()
	body.name = "HoundHudBody"
	body.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(0.02, 0.04, 0.05, 0.78)
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
	var colors := {"title": Color(0.55, 0.92, 0.96), "persistent": Color(1, 1, 1),
		"reservation": Color(0.62, 0.74, 1.0), "pack": Color(1.0, 0.86, 0.47),
		"h1": Color(0.80, 0.96, 1.0), "h2": Color(0.80, 0.96, 1.0), "controls": Color(0.78, 0.78, 0.84)}
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
		var line := _fit(String(t[k]))
		(lines[k] as Label).text = line
		joined.append(line)
	last_text = "\n".join(joined)

static func _fit(line: String) -> String:
	return line if line.length() <= MAX_LINE_CHARS else line.left(MAX_LINE_CHARS - 1) + "…"

func body_rect() -> Rect2:
	return body.get_global_rect() if body != null else Rect2()
