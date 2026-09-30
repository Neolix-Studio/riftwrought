class_name GateHud
extends CanvasLayer

## THE DEBUG OVERLAY for the D-368 gate.
##
## ============================================================================
## THE OWNER ASKED FOR: "A debug overlay listing the exact source clip currently
## playing."
##
## So the clip readout is taken from `AnimationPlayer.current_animation` VIA
## `AnimDirector.live_clip()` -- the LIVE value, read every frame. It is never
## the director's own record of what it asked for, because that would prove
## only that we intended something. If a clip silently failed to play, THIS
## OVERLAY SHOWS THAT, which is the entire point.
##
## It also keeps the DESIGN NAME and the SOURCE CLIP NAME on separate, labelled
## lines. "A2 Slam" is a design name; `TreeChopping` is the stock clip. Showing
## only the first would let a composed attack pass as an authored animation, and
## this gate's whole honesty rests on that distinction being visible.
## ============================================================================

var boss: BossPuglin
var control: OrdinaryEnemy
var player: PlayerProbe
var cam: IsoCamera
var arena: Arena

var visible_overlay: bool = true

var _title: RichTextLabel
var _clips: RichTextLabel
var _facts: RichTextLabel
var _denials: RichTextLabel
var _hooks: RichTextLabel
var _last_hooks: Array[String] = []

const MONO_SIZE := 15

func _font_label(anchor_l: float, anchor_t: float, anchor_r: float,
		anchor_b: float, size: int) -> RichTextLabel:
	var l := RichTextLabel.new()
	l.bbcode_enabled = true
	l.scroll_active = false
	l.fit_content = false
	l.anchor_left = anchor_l
	l.anchor_top = anchor_t
	l.anchor_right = anchor_r
	l.anchor_bottom = anchor_b
	l.offset_left = 16
	l.offset_top = 12
	l.offset_right = -16
	l.offset_bottom = -12
	l.add_theme_font_size_override("normal_font_size", size)
	l.add_theme_font_size_override("bold_font_size", size)
	add_child(l)
	return l

func setup() -> void:
	layer = 10
	var bg := ColorRect.new()
	bg.color = Color(0, 0, 0, 0.46)
	bg.anchor_right = 1.0
	bg.anchor_bottom = 0.0
	bg.offset_bottom = 96
	add_child(bg)

	var bg2 := ColorRect.new()
	bg2.color = Color(0, 0, 0, 0.46)
	bg2.anchor_top = 1.0
	bg2.anchor_right = 1.0
	bg2.anchor_bottom = 1.0
	bg2.offset_top = -196
	add_child(bg2)

	_title = _font_label(0, 0, 1, 0, 17)
	_title.offset_bottom = 96

	_clips = _font_label(0, 1, 0.56, 1, MONO_SIZE)
	_clips.offset_top = -190
	_clips.offset_bottom = -10

	_facts = _font_label(0.56, 1, 1, 1, MONO_SIZE)
	_facts.offset_top = -190
	_facts.offset_bottom = -10

	_denials = _font_label(0, 0.5, 0.40, 0.5, 13)
	_denials.offset_top = -86
	_denials.offset_bottom = 120

	_hooks = _font_label(0.62, 0.5, 1.0, 0.5, 13)
	_hooks.offset_top = -86
	_hooks.offset_bottom = 120

func _process(_delta: float) -> void:
	if not visible_overlay:
		_title.visible = false
		_clips.visible = false
		_facts.visible = false
		_denials.visible = false
		_hooks.visible = false
		return
	_title.visible = true
	_clips.visible = true
	_facts.visible = true
	_denials.visible = true
	_hooks.visible = true
	_update_title()
	_update_clips()
	_update_facts()
	_update_denials()
	_update_hooks()

func _update_title() -> void:
	_title.clear()
	_title.append_text("[b]RIFTWROUGHT — BOSS ANIMATION FEASIBILITY GATE (%s, %s)[/b]\n"
		% [GateConfig.GATE_DECISION, GateConfig.GATE_DATE])
	_title.append_text("[color=#ffd166]STATE: %s[/color]   " % GateConfig.GATE_STATE)
	_title.append_text("[color=#ff8b8b]THIS GATE IS NOT THE PRODUCTION PIVOT · "
		+ "NOT proof that all bosses are feasible · NOT A PRODUCT LOCK[/color]\n")
	_title.append_text("[color=#9ecbff]EVERY NUMBER HERE REMAINS PROVISIONAL. "
		+ "Boss clips are STOCK UAL1/UAL2 clips RECOMPOSED — no keyframe is authored.[/color]")

## The live clip readout. This is the owner's requested feature and the gate's
## honesty surface at the same time.
func _update_clips() -> void:
	_clips.clear()
	_clips.append_text("[b]SOURCE CLIP NOW PLAYING (live from AnimationPlayer)[/b]\n")
	for row in _actors():
		var label: String = row[0]
		var d: AnimDirector = row[1]
		if d == null:
			continue
		var live := d.live_clip()
		var lib := d.live_library()
		var len_s := d.live_length()
		var pos := d.live_position()
		var lib_txt: String = lib if lib != "" else "UNKNOWN"
		var colour := "#8bffa0"
		if live == "":
			colour = "#ff8b8b"
			live = "(none — stopped)"
		_clips.append_text("[color=#cfd6e4]%s[/color]\n" % label)
		# DESIGN NAME and SOURCE CLIP are deliberately separate lines.
		_clips.append_text("   design state : [color=#9ecbff]%s[/color]\n" % d.design_state)
		_clips.append_text("   source clip  : [color=%s][b]%s[/b][/color]  [color=#ffd166](%s)[/color]\n"
			% [colour, live, lib_txt])
		_clips.append_text("   clip time    : %.3f / %.3f s   speed x%.2f\n"
			% [pos, len_s, d.live_speed()])

func _actors() -> Array:
	var out: Array = []
	if boss != null and is_instance_valid(boss):
		out.append(["BOSS — %s" % GateConfig.BOSS_DISPLAY_NAME, boss.director()])
	if control != null and is_instance_valid(control):
		out.append(["CONTROL — %s" % GateConfig.CONTROL_DISPLAY_NAME, control.director()])
	if player != null and is_instance_valid(player):
		out.append(["PLAYER PROBE — placeholder, not the Huntress", player.director()])
	return out

func _update_facts() -> void:
	_facts.clear()
	_facts.append_text("[b]ENCOUNTER STATE / PROVISIONAL VALUES[/b]\n")
	if boss != null and is_instance_valid(boss):
		_facts.append_text("boss    : %s  phase %d  hp %.0f/%.0f  poise %.0f/%.0f%s\n"
			% [boss.state_name(), boss.phase, maxf(0.0, boss.health),
			   GateConfig.BOSS_HEALTH, maxf(0.0, boss.poise), GateConfig.BOSS_POISE,
			   "  [INVULN]" if boss.invulnerable else ""])
		_facts.append_text("yaw     : %.2f deg (CONTINUOUS, rate-limited %.0f deg/s)%s\n"
			% [boss.current_yaw_deg(), GateConfig.BOSS_TURN_RATE_DEG,
			   "  [COMMITTED]" if boss.yaw_is_committed() else ""])
		var t := boss.telegraph()
		if t != null and is_instance_valid(t):
			_facts.append_text("danger  : %s  extent %.2f m  fill %.0f%%\n"
				% [Telegraph.shape_name(t.shape), t.extent_m(), t.progress * 100.0])
		else:
			_facts.append_text("danger  : (none — no telegraph outside a windup)\n")
		_facts.append_text("silhouette attachments: %d %s\n"
			% [boss.silhouette_attachment_names.size(),
			   str(boss.silhouette_attachment_names)])
	if cam != null:
		var ext := cam.view_extent_m()
		_facts.append_text("camera  : ortho %.2f m (bounds %.1f-%.1f, PROVISIONAL), "
			% [cam.ortho_size, GateConfig.CAM_SIZE_MIN, GateConfig.CAM_SIZE_MAX])
		_facts.append_text("view %.3f x %.2f m, pitch %.1f deg\n"
			% [ext.x, ext.y, GateConfig.CAM_PITCH_DEG])
	_facts.append_text("[color=#ffd166]player top speed %.3f m/s — %s[/color]\n"
		% [GateConfig.TOP_SPEED_MPS, GateConfig.TOP_SPEED_STATUS])
	_facts.append_text("[color=#9ecbff]scale x%.2f is SUPPORT, NOT IDENTITY "
		% GateConfig.BOSS_VISUAL_SCALE
		+ "(Puglin posed %.4f m; the Imp is TALLER at %.4f m)[/color]"
		% [GateConfig.PUGLIN_MEASURED_POSED_HEIGHT_M,
		   GateConfig.IMP_MEASURED_POSED_HEIGHT_M])

func _update_denials() -> void:
	_denials.clear()
	_denials.append_text("[b]WHAT THIS GATE IS NOT[/b]\n")
	for d in GateConfig.DENIALS:
		_denials.append_text("[color=#ff8b8b]· %s[/color]\n" % d)
	_denials.append_text("[color=#ff8b8b]· %s[/color]" % GateConfig.BOSS_NOT_NAME)

func _update_hooks() -> void:
	_hooks.clear()
	_hooks.append_text("[b]SOUND HOOKS — HOOKS, NOT SOUNDS[/b]\n")
	_hooks.append_text("[color=#9ecbff]%d audio assets in this project. A hook is a "
		% GateConfig.AUDIO_ASSETS_ADDED
		+ "named emission point; no audio is added or claimed.[/color]\n")
	if boss != null and is_instance_valid(boss):
		var recent := boss.hooks_fired.slice(maxi(0, boss.hooks_fired.size() - 5))
		for h in recent:
			_hooks.append_text("[color=#8bffa0]› %s[/color]\n" % h)
