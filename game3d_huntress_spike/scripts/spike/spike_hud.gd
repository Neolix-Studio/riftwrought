class_name SpikeHud
extends CanvasLayer

## THE COMPACT DIAGNOSTIC HUD — SIX ITEMS, AND ONLY SIX.
##
## ============================================================================
## THE RULING'S LIST, VERBATIM IN SUBSTANCE, AND NOTHING ELSE:
## ============================================================================
##   1. the current animation phase (with the diagnostic playback rate);
##   2. whether release has occurred;
##   3. the current Prey;
##   4. the stand-in hound's current target;
##   5. native control versus retargeted Huntress identity;
##   6. the diagnostic / prototype disclaimers.
## The suite asserts the line set exactly (R-02). IT OWNS NO NUMBER: every line
## is read from live state on every frame (R-04). It is NOT a UI foundation.

const ITEMS := ["PHASE", "RELEASE", "PREY", "HOUND", "IDENTITY", "DIAGNOSTIC"]

var probe: HuntressSpikeProbe
var prey: PreyState
var hound: StandInHound
var lines: Dictionary = {}
var _panel: PanelContainer

func build() -> void:
	layer = 20
	_panel = PanelContainer.new()
	_panel.name = "SpikeHudPanel"
	_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(0.03, 0.04, 0.07, 0.78)
	sb.border_color = Color(0.45, 0.50, 0.62, 0.8)
	sb.set_border_width_all(1)
	sb.set_content_margin_all(10)
	sb.set_corner_radius_all(4)
	_panel.add_theme_stylebox_override("panel", sb)
	add_child(_panel)
	var vb := VBoxContainer.new()
	vb.mouse_filter = Control.MOUSE_FILTER_IGNORE
	vb.add_theme_constant_override("separation", 2)
	_panel.add_child(vb)
	for k in ITEMS:
		var l := Label.new()
		l.name = "Hud_" + k
		l.mouse_filter = Control.MOUSE_FILTER_IGNORE
		l.add_theme_font_size_override("font_size", 17 if k != "DIAGNOSTIC" else 13)
		l.add_theme_color_override("font_color",
			Color(0.93, 0.94, 0.97) if k != "DIAGNOSTIC" else Color(0.72, 0.76, 0.86))
		vb.add_child(l)
		lines[k] = l
	refresh()

func _process(_delta: float) -> void:
	refresh()

func refresh() -> void:
	if probe == null:
		return
	var d := probe.driver
	var ph := d.phase
	(lines["PHASE"] as Label).text = "PHASE: %s   ·   diagnostic playback rate ×%.2f" % [ph, probe.current_rate()]
	var rel := "RELEASE: —  (no bow use yet)"
	if probe.bow_uses > 0:
		if d.in_action and not d.released:
			rel = "RELEASE: not yet  (use #%d, drawing)" % probe.bow_uses
		else:
			rel = "RELEASE: YES  (use #%d — arrow released)" % probe.bow_uses \
				if probe.last_use_released else "RELEASE: no  (use #%d)" % probe.bow_uses
	(lines["RELEASE"] as Label).text = rel
	(lines["PREY"] as Label).text = "PREY: %s" % (prey.current_name() if prey != null else "none")
	var ht := "HOUND TARGET: none — following the Huntress"
	# A skipped Prey says why even when nothing else is eligible -- the first
	# rendered frame 04 showed Prey A 8.3 m away and an unexplained "none".
	if hound != null and hound.target_name() == "none" and hound.prey_skip_reason != "":
		ht += "  (the Prey is %s)" % hound.prey_skip_reason
	if hound != null and hound.target_name() != "none":
		var why := "prefers Prey"
		if hound.target_reason != "PREY":
			why = "autonomous acquisition" if hound.prey_skip_reason == "" \
				else "autonomous — the Prey is %s" % hound.prey_skip_reason
		ht = "HOUND TARGET: %s  (%s)" % [hound.target_name(), why]
	(lines["HOUND"] as Label).text = ht
	(lines["IDENTITY"] as Label).text = "VISIBLE: " + (SpikeConfig.RANGER_LABEL
		if probe.showing_native_control() else SpikeConfig.HUNTRESS_LABEL)
	(lines["DIAGNOSTIC"] as Label).text = "DIAGNOSTIC SPIKE (D-388), DELIVERED and OPEN · NOT P2 · NOT final art · the bow shot is NOT a Skill\nhound = procedural stand-in, NO hound art proven · NO imported VFX · every value provisional"
	_place()

func _place() -> void:
	var vp := _panel.get_viewport_rect().size
	_panel.reset_size()
	var s := _panel.get_combined_minimum_size()
	_panel.position = Vector2(vp.x - s.x - 18.0, vp.y - s.y - 18.0)

func line_texts() -> Array:
	var out: Array = []
	for k in ITEMS:
		out.append((lines[k] as Label).text)
	return out

func set_enabled(v: bool) -> void:
	visible = v
