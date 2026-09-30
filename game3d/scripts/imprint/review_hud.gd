class_name ReviewHud
extends CanvasLayer

## THE D-378 REVIEW HUD — a compact DIAGNOSTIC surface for reviewing the D-378
## alignment WHILE PLAYING (D-381, 2026-09-18).
##
## ============================================================================
## THIS IS NOT A UI FOUNDATION, NOT A PRODUCTION HUD AND NOT A FINAL STYLE.
## ============================================================================
## It exists because the owner could not play and read the developer panel at
## the same time: *"The large developer panel prevents me from playing and
## understanding the resource behaviour simultaneously."* So the panel is now
## hidden by default (F2 still opens it) and this small corner surface shows only
## what the D-378 review needs. P1A's transferred UI debt is UNCHANGED, and
## `CLAUDE.md` section 12 still forbids beginning a UI foundation.
##
## ---------------------------------------------------------------------------
## IT DISPLAYS THE LIVE GAMEPLAY STATE. IT OWNS NO NUMBER.
## ---------------------------------------------------------------------------
## Every value is read, at draw time, from the SAME objects gameplay uses:
##   * Mana and every reservation   <- `SkillRuntime.pool` (what Skill Uses spend);
##   * current and maximum Health   <- the player's `Damageable` (what enemies hit);
##   * the reservation state        <- `SkillRuntime.reservation_state()`, read
##                                     from the live loadout;
##   * learning and Configurations  <- the live Imprint Library and loadout.
## There is no resource constant in this file, and the D-380 suite scans its
## CODE for one (and proves the scan can find a planted one).
##
## ---------------------------------------------------------------------------
## RESERVED IS SHOWN BY SHAPE, NOT ONLY BY COLOUR.
## ---------------------------------------------------------------------------
## The reserved portion of a bar is a HATCHED zone, set off from the usable
## portion by a bright BOUNDARY TICK and labelled RESERVED -- three cues, none of
## them colour. `bar_model()` is the geometry the bars draw, so a check can read
## exactly what a viewer sees.
##
## ---------------------------------------------------------------------------
## ONE PRE-EXISTING PROTOTYPE LIMIT WAS SHOWN, NOT HIDDEN -- AND D-382 FIXED IT.
## ---------------------------------------------------------------------------
## The paragraph below was true from D-381 until D-382. The owner then ruled that
## a Life reservation must lower live Health (`Damageable.set_ceiling`); the
## warning line is now an alarm that can only fire if that rule breaks.
## Since D-375 the reservation of LIFE has been a CEILING in `ResourcePool`; the
## player's live Health ledger (`Damageable`, accepted foundation behaviour) is
## NOT reduced by it. So with the reservation converted to Life, live Health can
## sit ABOVE usable Health. This HUD draws that truthfully -- the Health fill runs
## on into the hatched zone -- and prints a warning line. Enforcing the cap would
## change gameplay, which this correction is not authorized to do.

const TITLE := "D-378 REVIEW HUD · DIAGNOSTIC, not a UI foundation"

var runtime: SkillRuntime
var player: PlayerController
var enabled: bool = false
var toggles: int = 0
var refreshes: int = 0

var body: PanelContainer
var health_bar: ReviewBar
var mana_bar: ReviewBar
var lines: Dictionary = {}
var last_text: String = ""

# =============================================================================
# THE BAR — draws ONLY the model it is given
# =============================================================================

class ReviewBar extends Control:
	var model: Dictionary = {}
	var fill_color: Color = Color(0.8, 0.8, 0.8)

	func _draw() -> void:
		var w := size.x
		var h := size.y
		draw_rect(Rect2(0, 0, w, h), Color(0.07, 0.07, 0.10, 0.95))
		if model.is_empty() or float(model.get("max", 0.0)) <= 0.0:
			return
		var cur_x := w * clampf(float(model["current_fraction"]), 0.0, 1.0)
		var use_x := w * clampf(float(model["usable_fraction"]), 0.0, 1.0)
		# The live current value, as a solid fill.
		draw_rect(Rect2(0, 0, cur_x, h), fill_color)
		if float(model["reserved"]) > 0.0 and use_x < w:
			# RESERVED: a dimmed, HATCHED zone -- a pattern, not just a hue.
			draw_rect(Rect2(use_x, 0, w - use_x, h), Color(0.0, 0.0, 0.0, 0.45))
			var x := use_x - h
			while x < w:
				var sx := maxf(x, use_x)
				var ex := minf(x + h, w)
				if ex > sx:
					draw_line(Vector2(sx, h - (sx - x)), Vector2(ex, h - (ex - x)),
						Color(0.93, 0.93, 0.96, 0.95), 1.5)
				x += 6.0
			# THE BOUNDARY between usable and reserved -- a shape cue.
			draw_line(Vector2(use_x, -4), Vector2(use_x, h + 4), Color(1.0, 0.93, 0.45), 3.0)
			if w - use_x > 64.0:
				var font := ThemeDB.fallback_font
				var label_x := use_x + 4.0
				draw_rect(Rect2(label_x - 2.0, 1.0, 58.0, h - 2.0), Color(0.0, 0.0, 0.0, 0.75))
				draw_string(font, Vector2(label_x, h - 4.0), "RESERVED", HORIZONTAL_ALIGNMENT_LEFT,
					-1, 10, Color(1.0, 0.95, 0.7))
		# The usable portion, outlined; the whole bar, framed.
		draw_rect(Rect2(0, 0, use_x, h), Color(1, 1, 1, 0.85), false, 1.5)
		draw_rect(Rect2(0, 0, w, h), Color(0.75, 0.75, 0.82, 0.9), false, 1.0)

# =============================================================================
# THE LIVE MODEL
# =============================================================================

## The objects the values come from -- exposed so a check can prove IDENTITY with
## the gameplay objects rather than equality with a copy.
func pool_source() -> ResourcePool:
	return runtime.pool if runtime != null else null

func health_source() -> Damageable:
	return player.life if player != null else null

## Everything the HUD shows, read NOW from the live objects.
func snapshot() -> Dictionary:
	var pool := pool_source()
	var life := health_source()
	var lib := runtime.library
	var lo := runtime.loadout
	var at_rank_1 := 0
	var pre_earned := 0
	for id in lib.ids():
		var rec := lib.acquisition_record(String(id))
		if int(rec.get("rank", -1)) == ImprintConfig.RANK_MIN \
				and is_equal_approx(float(rec.get("xp", -1.0)), 0.0):
			at_rank_1 += 1
		if lib.seeded_rank(String(id)) > ImprintConfig.RANK_MIN:
			pre_earned += 1
	var mana_fraction := 0.0
	var life_basis := 0.0
	var ratio := 0.0
	for row in lo.reservation()["rows"]:
		if String(row["resource"]) == "mana":
			mana_fraction += float(row["fraction"])
		elif String(row["resource"]) == "life":
			life_basis += float(row["mana_basis"])
			ratio = float(row["ratio"])
	return {
		"health_current": life.life, "health_max": life.max_life,
		"health_reserved": pool.life_reserved, "health_usable": pool.life_usable(),
		"mana_current": pool.mana_current, "mana_max": pool.mana_max,
		"mana_reserved": pool.mana_reserved, "mana_usable": pool.mana_usable(),
		"mana_regen": pool.regen_per_second(), "mana_unreserved": pool.unreserved_maximum(),
		"state": runtime.reservation_state(),
		"mana_reserve_fraction": mana_fraction, "life_mana_basis": life_basis,
		"conversion_ratio": ratio,
		"learned": lib.count(), "learned_at_rank_1": at_rank_1, "pre_earned": pre_earned,
		"equipped": lo.equipped_active_count(), "bindings": lo.binding_count(),
		# D-392: how many of the equipped Configurations hold a CANONICAL Skill
		# Imprint (Splinter Shot) rather than a diagnostic one. Read live.
		"canonical_equipped": _canonical_equipped(lo),
	}

func _canonical_equipped(lo: ImprintLoadout) -> int:
	var n := 0
	for id in lo.active_configuration_ids():
		var cfg := lo.configuration(String(id)) as SkillConfiguration
		if cfg != null and cfg.skill() != null and cfg.skill().canonical:
			n += 1
	return n

## The geometry a bar draws, computed from the snapshot. `kind` is "health" or
## "mana". Fractions are of that resource's LIVE maximum.
func bar_model(kind: String) -> Dictionary:
	var s := snapshot()
	var mx := float(s[kind + "_max"])
	var cur := float(s[kind + "_current"])
	var use := float(s[kind + "_usable"])
	var res := float(s[kind + "_reserved"])
	var segments: Array = []
	if mx <= 0.0:
		return {"kind": kind, "max": mx, "segments": segments}
	segments.append({"part": "current", "from": 0.0, "to": clampf(cur / mx, 0.0, 1.0),
		"pattern": "solid"})
	if res > 0.0:
		segments.append({"part": "reserved", "from": clampf(use / mx, 0.0, 1.0), "to": 1.0,
			"pattern": "hatched"})
		segments.append({"part": "usable_boundary", "at": clampf(use / mx, 0.0, 1.0),
			"pattern": "tick"})
	return {
		"kind": kind, "max": mx, "current": cur, "usable": use, "reserved": res,
		"current_fraction": cur / mx, "usable_fraction": use / mx, "reserved_fraction": res / mx,
		"current_exceeds_usable": cur > use + 0.001,
		"segments": segments,
	}

## The input hint, derived from the InputMap so it stays true if rebound.
func control_hint() -> String:
	var parts: Array[String] = []
	for ev in InputMap.action_get_events(SkillRuntime.RESERVATION_CYCLE_ACTION):
		if ev is InputEventKey:
			parts.append(OS.get_keycode_string((ev as InputEventKey).physical_keycode))
		elif ev is InputEventJoypadButton:
			var idx := (ev as InputEventJoypadButton).button_index
			parts.append("right-stick click" if idx == JOY_BUTTON_RIGHT_STICK else "pad button %d" % idx)
	return "[%s] cycle: OFF → MANA RESERVATION → LIFE CONVERSION → OFF" % " / ".join(parts)

func panel_hint() -> String:
	return "%s panel · %s overlay" \
		% [_keys_of("imprint_panel"), _keys_of("toggle_overlay")]

func _keys_of(action: String) -> String:
	var parts: Array[String] = []
	if InputMap.has_action(action):
		for ev in InputMap.action_get_events(action):
			if ev is InputEventKey:
				parts.append(OS.get_keycode_string((ev as InputEventKey).physical_keycode))
	return " / ".join(parts) if not parts.is_empty() else "(unbound)"

## Every text line, composed from the snapshot, keyed so the layout and a check
## read the same strings.
func compose_lines() -> Dictionary:
	var s := snapshot()
	var state := String(s["state"])
	var detail := "no Persistent reservation"
	if state == "MANA RESERVATION":
		detail = "%.1f%% of max Mana, paid from Mana" \
			% (float(s["mana_reserve_fraction"]) * 100.0)
	elif state == "LIFE CONVERSION":
		detail = "%.1f%% Mana basis × %.4f → %.0f Life; Mana reserves 0" \
			% [float(s["life_mana_basis"]) * 100.0, float(s["conversion_ratio"]),
			   float(s["health_reserved"])]
	var out := {
		"title": "%s · %s" % [TITLE, panel_hint()],
		"health": "%.0f current · %.0f usable · %.0f max · %.0f reserved"
			% [float(s["health_current"]), float(s["health_usable"]), float(s["health_max"]),
			   float(s["health_reserved"])],
		"mana": "%.0f current · %.0f usable · %.0f max · %.0f reserved · regen %.2f/s"
			% [float(s["mana_current"]), float(s["mana_usable"]), float(s["mana_max"]),
			   float(s["mana_reserved"]), float(s["mana_regen"])],
		"state": "RESERVATION: %s — %s" % [state, detail],
		# A successful cycle is already visible in the state line; only a
		# REFUSAL (the safe-state gate) needs saying.
		"hint": control_hint() + ("" if runtime.last_reservation_result == ""
			or runtime.last_reservation_result.contains(" -> ")
			else " · REFUSED: " + runtime.last_reservation_result),
		"imprints": "IMPRINTS: newly learned = Rank 1 · 0 XP (%d of %d) · higher = DIAGNOSTIC PRE-EARNED PROGRESS (%d)"
			% [int(s["learned_at_rank_1"]), int(s["learned"]), int(s["pre_earned"])],
		# D-392: the line read "... — diagnostic, not production Skills" of EVERY
		# equipped Configuration until D-392 -- true when written. Since D-392 one
		# holds the canonical Splinter Shot, and the line says so.
		# MEASURED NO WIDER than the HUD's widest accepted line (681 px at 14 px:
		# this wording is 670), so the HUD keeps its accepted 701 x 208 geometry.
		# The first D-392 wording made it 971 px wide and pushed it off the
		# bottom-right -- found by the accepted A30, fixed here, never in A30.
		# With no canonical Configuration equipped it is EXACTLY the accepted line.
		"configurations": ("ACTIVE CONFIGURATIONS: %d equipped / %d supported — diagnostic, not production Skills"
			% [int(s["equipped"]), int(s["bindings"])]) if int(s["canonical_equipped"]) == 0
			else ("ACTIVE CONFIGURATIONS: %d equipped / %d supported: %d canonical, %d diagnostic, not production Skills"
			% [int(s["equipped"]), int(s["bindings"]), int(s["canonical_equipped"]),
			   int(s["equipped"]) - int(s["canonical_equipped"])]),
		"warning": "",
	}
	# Since D-382 live Health can no longer exceed usable Health, so this line is
	# an INVARIANT ALARM: it appears only if the rule is ever broken. From D-381
	# until D-382 it read "LIVE HEALTH IS NOT REDUCED BY LIFE RESERVATION —
	# disclosed prototype limit" and appeared whenever Life was reserved.
	if bool(bar_model("health").get("current_exceeds_usable", false)):
		out["warning"] = "! INVARIANT BROKEN: live Health above usable Health — this is a defect"
	return out

# =============================================================================
# LAYOUT — the bottom-left corner, clear of the centre, the overlay and the panel
# =============================================================================

func build() -> void:
	layer = 9
	var frame := Control.new()
	frame.name = "ReviewHudFrame"
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
	# THE BOTTOM-RIGHT CORNER. The first render put the HUD bottom-LEFT and it sat
	# under the accepted F1 foundation overlay, which is ON at launch and fills
	# the whole left column -- found only by looking at the frame.
	var left_spacer := Control.new()
	left_spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	left_spacer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	row.add_child(left_spacer)

	body = PanelContainer.new()
	body.name = "ReviewHudBody"
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
	lines["title"] = _label(v, Color(0.62, 0.83, 1.0))
	health_bar = _bar_row(v, "HEALTH", Color(0.80, 0.22, 0.24))
	lines["health"] = _label(v, Color(1, 1, 1))
	mana_bar = _bar_row(v, "MANA", Color(0.30, 0.52, 0.98))
	lines["mana"] = _label(v, Color(1, 1, 1))
	lines["state"] = _label(v, Color(1.0, 0.86, 0.47))
	lines["hint"] = _label(v, Color(0.80, 0.80, 0.86))
	lines["imprints"] = _label(v, Color(0.80, 0.80, 0.86))
	lines["configurations"] = _label(v, Color(0.80, 0.80, 0.86))
	lines["warning"] = _label(v, Color(1.0, 0.55, 0.45))
	set_enabled(true)

func _label(parent: Control, color: Color) -> Label:
	var l := Label.new()
	l.mouse_filter = Control.MOUSE_FILTER_IGNORE
	l.add_theme_font_size_override("font_size", 14)
	l.add_theme_color_override("font_color", color)
	parent.add_child(l)
	return l

func _bar_row(parent: Control, caption: String, color: Color) -> ReviewBar:
	var h := HBoxContainer.new()
	h.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(h)
	var name_label := Label.new()
	name_label.text = caption
	name_label.custom_minimum_size = Vector2(62, 0)
	name_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	name_label.add_theme_font_size_override("font_size", 14)
	h.add_child(name_label)
	var bar := ReviewBar.new()
	bar.custom_minimum_size = Vector2(520, 20)
	bar.fill_color = color
	bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	h.add_child(bar)
	return bar

func set_enabled(on: bool) -> void:
	if enabled != on:
		toggles += 1
	enabled = on
	visible = on

func _process(_delta: float) -> void:
	if enabled:
		refresh()

## Pushes the live model into the labels and the bars. ONE place, so what is
## drawn and what a check reads cannot diverge.
func refresh() -> void:
	if runtime == null or player == null or body == null:
		return
	refreshes += 1
	var t := compose_lines()
	var joined: Array[String] = []
	for k in ["title", "health", "mana", "state", "hint", "imprints", "configurations", "warning"]:
		var line := String(t[k])
		(lines[k] as Label).text = line
		(lines[k] as Label).visible = line != ""
		if line != "":
			joined.append(line)
	health_bar.model = bar_model("health")
	mana_bar.model = bar_model("mana")
	health_bar.queue_redraw()
	mana_bar.queue_redraw()
	last_text = "\n".join(joined)

## The HUD body's rectangle in viewport pixels, for the placement check.
func body_rect() -> Rect2:
	return body.get_global_rect() if body != null else Rect2()
