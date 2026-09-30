class_name DebugOverlay
extends CanvasLayer

## THE DEBUG OVERLAY — a DEVELOPER surface, and nothing else.
##
## ============================================================================
## THIS IS NOT A UI FOUNDATION AND MUST NEVER BE MISTAKEN FOR ONE.
## ============================================================================
## P1A transferred out "HUD, menu, text and accessibility suitability at
## arbitrary output resolutions" to a later UI foundation, and that debt is
## UNCHANGED. Final UI is explicitly out of scope for this ruling. Nothing here
## is styled, scaled, localised or made accessible, and none of it is a claim
## about the eventual HUD.
##
## It CAN BE DISABLED (F1, or controller Y) for visual review, and it IS
## disabled in every rendered evidence capture. The suite asserts both.
##
## ---------------------------------------------------------------------------
## IT SEPARATES THE DESIGN NAME FROM THE SOURCE CLIP NAME.
## ---------------------------------------------------------------------------
## Every clip in this project is BORROWED from a third-party library. Printing
## only a friendly design name would quietly present a borrowed clip as a
## designed move; printing only the clip name would hide what the action is
## meant to be. Both are shown, side by side, with the source library.

var main: Node
var label: RichTextLabel
var enabled: bool = true

## Diagnostics the suite reads.
var toggles: int = 0
var last_text: String = ""

func build() -> void:
	layer = 10
	var panel := PanelContainer.new()
	panel.name = "OverlayPanel"
	panel.set_anchors_preset(Control.PRESET_TOP_LEFT)
	panel.position = Vector2(16, 16)
	panel.custom_minimum_size = Vector2(700, 0)
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(0, 0, 0, 0.62)
	sb.content_margin_left = 12
	sb.content_margin_right = 12
	sb.content_margin_top = 8
	sb.content_margin_bottom = 8
	panel.add_theme_stylebox_override("panel", sb)
	add_child(panel)

	label = RichTextLabel.new()
	label.name = "OverlayText"
	label.bbcode_enabled = true
	label.fit_content = true
	label.scroll_active = false
	label.custom_minimum_size = Vector2(676, 0)
	panel.add_child(label)

func set_enabled(on: bool) -> void:
	if enabled != on:
		toggles += 1
	enabled = on
	visible = on

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("toggle_overlay"):
		set_enabled(not enabled)
	if enabled:
		refresh()

func refresh() -> void:
	if main == null or label == null:
		return
	label.text = compose()
	last_text = label.get_parsed_text()

## Composed as plain data so the verification suite can read exactly what a
## viewer reads. Reading the right words out of a control tree proves the words
## exist, not that anyone can see them -- which is why the rendered evidence is
## captured as well.
func compose() -> String:
	var player: PlayerController = main.get("player")
	var cam: IsoCameraRig = main.get("cam")
	var enemies: Array = main.get("enemies")
	var arena: ProductionArena = main.get("arena")

	var lines: Array[String] = []
	lines.append("[b]RIFTWROUGHT — 3D PRODUCTION FOUNDATION (%s, %s)[/b]"
		% [ProdConfig.DECISION, ProdConfig.DATE])
	lines.append("[color=#ffd479]STATE: %s[/color]" % ProdConfig.STATE)
	lines.append("[color=#ff9b9b]COMPLETES NO PHASE · DOES NOT COMPLETE P1 OR THE ORIGINAL P1C · "
		+ "DOES NOT AUTHORIZE P2 · LOCKS NO VALUE[/color]")
	lines.append("")

	if player != null:
		# D-392: this read "PLAYER PROBE (NOT the Huntress · no class specification
		# exists)" -- true when written, at D-370. Her canonical specification
		# exists since D-385 (design/, not here), and since D-392 this body is the
		# Huntress, with PLACEHOLDER animation and a PLACEHOLDER bow.
		lines.append("[b]THE HUNTRESS[/b]  (placeholder body and animation · her canonical specification lives in design/, not here)")
		lines.append("  ground point   %s" % _v3(player.ground_point()))
		lines.append("  speed          %.3f m/s   of a %.3f m/s [i]%s[/i]"
			% [player.motor.speed(), ProdConfig.TOP_SPEED_MPS, ProdConfig.TOP_SPEED_STATUS])
		lines.append("  yaw            %.2f deg  (CONTINUOUS — D-367; no sector index exists)"
			% rad_to_deg(player.yaw_driver.yaw))
		lines.append("  aim point      %s   [i]sampled independently of movement[/i]"
			% _v3(player.aim_point))
		var dest := "none"
		if player.move_destination != null:
			dest = _v3(player.move_destination)
		lines.append("  move order     %s   (click-to-move; NO WASD binding exists)" % dest)
		if player.commands_issued > 0:
			lines.append("  last order     %s"
				% ("REDIRECTED to the nearest navigable point, by %.2f m"
					% player.last_command_redirect_m if player.last_command_was_redirected
					else "accepted as clicked"))
		lines.append("  animation      design [b]%s[/b]  ->  source clip [b]%s[/b] (%s)"
			% [player.live_design_name, player.live_clip,
			   _lib(player.live_clip)])
		# D-392: WHAT IS ACTUALLY DRAWN. The accepted controller still REQUESTS the
		# UAL clip above from its accepted AnimationPlayer; the Huntress layer draws
		# a PLACEHOLDER over it. A borrowed clip must never read as the accepted one.
		var hr = main.get("huntress")
		if hr != null and (hr as HuntressRuntime).animator != null:
			var an := (hr as HuntressRuntime).animator
			lines.append("  SHOWN          [b]%s[/b] (KayKit, retargeted) — %s   [i]the UAL clip above is REQUESTED by the accepted controller and is NOT what is drawn[/i]"
				% [an.shown_clip, HuntressConfig.ANIMATION_LABEL])
			lines.append("  Splinter Shot  binding %d · uses %d · arrows %d   [i]%s[/i]"
				% [HuntressContent.BINDING_INDEX + 1, (hr as HuntressRuntime).uses_begun,
				   (hr as HuntressRuntime).arrows_released, HuntressConfig.PRESENTATION_LABEL])
		lines.append("  action         %s — %s"
			% [ProdConfig.DIAG_ATTACK_DESIGN_NAME, ProdConfig.DIAG_ATTACK_LABEL])
		lines.append("                 [color=#ff9b9b]TEST-ONLY since D-392: no physical input reaches it in normal play (right mouse and pad button 7 now activate binding 6 — Splinter Shot). The accepted suites still drive it directly.[/color]")
		for d in ProdConfig.DIAG_ATTACK_DENIALS:
			lines.append("                 [color=#ff9b9b]%s[/color]" % d)
		lines.append("  shots fired    %d" % player.shots_fired)
		var c: ActionCommitment = player.commitment
		lines.append("  action state   %s   policy [b]%s[/b]   phase %s   %.3f / %.3f s"
			% ["COMMITTED" if c.active else "free", c.policy_name(), c.phase(),
			   c.elapsed, c.duration])
		lines.append("                 cancel window %s   buffered %d, applied %d, discarded %d   "
			% ["OPEN — a movement request cancels the RECOVERY" if c.cancel_window_open()
			   else "closed — the attack cannot be cancelled before it releases",
			   player.buffered_moves, player.buffered_applied, player.buffered_discarded]
			+ "recovery cancels %d, refused %d" % [c.recovery_cancels, c.cancels_refused])
		lines.append("                 [i]a committed STOP action suppresses TRANSLATION and never "
			+ "FACING; all action timings are PROVISIONAL[/i]")
		lines.append("                 [i]cancelling the recovery cancels an ANIMATION, never the "
			+ "attack and never the released projectile[/i]")
		lines.append("                 [color=#ff9b9b]The action-movement commitment is NOT a Skill "
			+ "system and NOT an ability framework.[/color]")
	lines.append("")

	if cam != null:
		var fp := cam.footprint_m()
		lines.append("[b]CAMERA[/b]  fixed orthographic isometric, rotation locked every frame")
		lines.append("  pitch/yaw      %.1f / %.1f deg   [i]PROVISIONAL — carried from the accepted "
			% [ProdConfig.CAM_PITCH_DEG, ProdConfig.CAM_YAW_DEG] + "D-366 spike; praise is not a lock[/i]")
		lines.append("  ortho size     %.2f m   bounds [%.1f, %.1f]   [i]PROVISIONAL[/i]"
			% [cam.ortho_size, ProdConfig.CAM_SIZE_MIN, ProdConfig.CAM_SIZE_MAX])
		lines.append("  footprint      %.2f x %.2f m   [i]NOT the game2d/ 32.00 x 18.00 m lock, "
			% [fp.x, fp.y] + "which is NOT inherited[/i]")
		lines.append("  rotation viol. %d" % cam.rotation_violations)
	lines.append("")

	if enemies != null:
		var alive := 0
		for e in enemies:
			if is_instance_valid(e) and not e.is_dead():
				alive += 1
		lines.append("[b]ORDINARY ENEMIES[/b]  %d alive of %d   (NOT bosses; nothing here may be "
			% [alive, enemies.size()] + "cited for one)")
		for e in enemies:
			if not is_instance_valid(e):
				continue
			lines.append("  %-8s life %5.1f/%5.1f   clip [b]%s[/b] (%s)   telegraph %s"
				% [e.state_name(), e.life.life, e.life.max_life, e.live_clip(),
				   _lib(e.live_clip()),
				   ("VISIBLE %.0f%%" % (e.telegraph.progress * 100.0)) if e.telegraph.visible else "hidden"])
	lines.append("")

	if arena != null:
		var m := NavService.measure_mesh(arena.nav_mesh())
		lines.append("[b]WORLD[/b]  test arena — NOT a zone, NOT campaign content")
		lines.append("  pieces         %d   authored colliders %d   (per-piece, not one perimeter box)"
			% [arena.static_pieces, arena.collider_count()])
		lines.append("  navigation     %d polygons, %.1f m^2 walkable, y in [%.2f, %.2f]"
			% [m["polygons"], m["area"], m["min_y"], m["max_y"]])
		lines.append("  baked          %d time(s)" % arena.bake_count)
	lines.append("")
	lines.append("[color=#9fd3ff]F1 / controller Y toggles this overlay. It is DISABLED in every "
		+ "rendered evidence capture.[/color]")
	lines.append("[color=#9fd3ff]EVERY TUNING VALUE ABOVE IS PROVISIONAL. NONE IS A PRODUCT LOCK. "
		+ "NO 2D LOCK IS PROMOTED HERE.[/color]")
	return "\n".join(lines)

func _lib(clip: String) -> String:
	var s := RigCorpus.attribute(clip)
	return s if s != "" else "source library unknown"

func _v3(v: Vector3) -> String:
	return "(%.2f, %.2f, %.2f)" % [v.x, v.y, v.z]
