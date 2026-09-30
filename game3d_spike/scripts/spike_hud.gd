class_name SpikeHUD
extends CanvasLayer

## EVERY PROVISIONAL VALUE IS LABELLED PROVISIONAL ON SCREEN, as the ruling
## requires, in addition to being labelled provisional in code.

var _top: Label
var _left: Label
var _bottom: Label
var main: Node

func _build_label(anchor_left: float, anchor_top: float, sz: int,
		col: Color) -> Label:
	var l := Label.new()
	l.add_theme_font_size_override("font_size", sz)
	l.add_theme_color_override("font_color", col)
	l.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.92))
	l.add_theme_constant_override("outline_size", 5)
	l.anchor_left = anchor_left
	l.anchor_top = anchor_top
	l.offset_left = 22.0
	l.offset_top = 16.0
	add_child(l)
	return l

func _ready() -> void:
	layer = 10
	_top = _build_label(0.0, 0.0, 17, Color(1.0, 0.86, 0.55))
	_left = _build_label(0.0, 0.0, 13, Color(0.80, 0.86, 0.96))
	_left.offset_top = 126.0
	_bottom = _build_label(0.0, 0.0, 12, Color(0.74, 0.70, 0.86))
	_bottom.offset_top = 902.0

	_top.text = ("RIFTWROUGHT — 3D FEASIBILITY SPIKE  (%s, %s)\n"
		+ "BOUNDED + ISOLATED.  NOT production · NOT P2 · NOT a completed pivot\n"
		+ "NOT the final Huntress · NOT final art · NOT acceptance of this asset style\n"
		+ "%s") % [SpikeConfig.SPIKE_DECISION, SpikeConfig.SPIKE_DATE,
			SpikeConfig.SPIKE_STATE.to_upper()]

	var lim := "\n".join(SpikeConfig.ANIM_LIMITATIONS)
	_bottom.text = ("MEASURED THIRD-PARTY ANIMATION LIMITATIONS (stated, not hidden):\n"
		+ lim + "\n"
		+ "Third-party placeholder art © Quaternius — 5 packs CC0, Bestiary under QAL v1.0.\n"
		+ "Riftwrought claims no ownership of it.")

func _process(_d: float) -> void:
	if main == null:
		return
	var cam: IsoCamera = main.get("cam")
	var pl: HuntressSpike = main.get("player")
	var mode: String = main.get("mode_name")
	var alive: int = main.get("alive_count")
	var total: int = main.get("enemy_total")
	var loot: int = main.get("loot_count")

	var speed_line := "PROVISIONAL top speed %.2f m/s — RE-EVALUATED, NOT INHERITED." \
		% SpikeConfig.TOP_SPEED_MPS
	var view_w := (cam.size * 16.0 / 9.0) if cam != null else 0.0
	var ratio := (SpikeConfig.CF_2D_LOCKED_WIDTH_M / view_w) if view_w > 0.0 else 0.0
	var matched := SpikeConfig.TOP_SPEED_2D_PROTOTYPE_MPS / ratio if ratio > 0.0 else 0.0
	var cmp_line := ("   2D prototype used %.1f m/s inside a LOCKED 32.00 m wide "
		+ "footprint (game2d/, D-356 — NOT promoted here).\n"
		+ "   This spike's PROVISIONAL framing is %.3f m wide at the CURRENT zoom, so "
		+ "the same m/s reads %.3fx faster.\n"
		+ "   Framing-matched equivalent at this zoom = %.3f m/s "
		+ "(%.3f m/s at default zoom). STILL AN OPEN OWNER JUDGMENT.") % [
			SpikeConfig.TOP_SPEED_2D_PROTOTYPE_MPS, view_w, ratio, matched,
			SpikeConfig.FRAMING_MATCHED_SPEED_MPS]

	_left.text = ("MODE: %s   enemies alive %d / %d   loot on ground %d\n"
		+ "CAMERA: ORTHOGRAPHIC, rotation LOCKED at pitch %.1f° yaw %.1f° "
		+ "(violations: %d)\n"
		+ "ZOOM: %.2f m  [bounded %.1f – %.1f, PROVISIONAL]   view %.2f × %.2f m\n"
		+ "OUTPUT: %d × %d — A COMPARISON OUTPUT, **NOT** A PRODUCT LOCK\n"
		+ "%s\n%s\n"
		+ "PROJECTILE: %s — the ONE diagnostic, non-canonical action. "
		+ "NOT a designed Skill.\n"
		+ "PLAYER ATTACK CLIP: UAL2 '%s' = A THROW, **NOT** A BOW ANIMATION "
		+ "(placeholder)\n"
		+ "ENEMY DEATH: code-driven topple — UAL2 Standard HAS NO DEATH CLIP "
		+ "(DEFERRED)\n"
		+ "MOVE WASD / left stick · AIM mouse (independent) · FIRE LMB/RT · "
		+ "ZOOM wheel · F2 density") % [
			mode, alive, total, loot,
			SpikeConfig.CAM_PITCH_DEG, SpikeConfig.CAM_YAW_DEG,
			cam.rotation_violations if cam else -1,
			cam.size if cam else 0.0,
			SpikeConfig.CAM_SIZE_MIN, SpikeConfig.CAM_SIZE_MAX,
			(cam.size * 16.0 / 9.0) if cam else 0.0, cam.size if cam else 0.0,
			SpikeConfig.OUTPUT_WIDTH, SpikeConfig.OUTPUT_HEIGHT,
			speed_line, cmp_line,
			SpikeConfig.PROJECTILE_LABEL,
			SpikeConfig.CLIP_PLAYER_ATTACK]
	if pl != null:
		pass
