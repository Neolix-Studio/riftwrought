class_name SpikeLineup
extends RefCounted

## E-05 — THE RETARGETED HUNTRESS AND THE NATIVE KAYKIT CONTROL, SIDE BY SIDE,
## AT EQUIVALENT NORMALISED POSES.
##
## A comparison SHEET, not a scene: display-only copies of both bodies, each
## posed from the SAME source clip at the SAME clip time -- the Huntress through
## the retarget, the control natively -- with the bow, string and arrow placed by
## the same presentation code the live probe uses. TOP row: the retargeted
## Huntress, raised so the two rows never overlap in an orthographic view.
## BOTTOM row: the native control. Nothing here is simulated.
##
## A right-handed archer turns her BACK to a viewer on her bow side, so the
## sheets look from her STRING-HAND side: a front-right three-quarter view (face,
## anchor, string and arrow) and a right profile (the draw's geometry).

const SPACING_M := 2.55
const ROW_GAP_M := 2.85

static func poses(d: BowPoseDriver) -> Array:
	var rec_t := 0.60
	var rec_w := 1.0 - clampf((rec_t - SpikeConfig.RELEASE_SNAP_WINDOW_S)
		/ (d.release_len - SpikeConfig.RELEASE_SNAP_WINDOW_S), 0.0, 1.0)
	return [
		["DRAW — the nock moment", SpikeConfig.CLIP_DRAW, d.nock_tau_h, BonePose.ease(d.nock_tau_h / d.t_full), true, d.ik_weight_at_draw(d.nock_tau_h)],
		["FULL DRAW — the aiming hold", SpikeConfig.CLIP_AIM_IDLE, 0.05, 1.0, true, 1.0],
		["RELEASE — the snap, +1/30 s", SpikeConfig.CLIP_RELEASE, 1.0 / 30.0, 1.0, false, 1.0],
		["RECOVERY — Release at 0.60 s", SpikeConfig.CLIP_RELEASE, rec_t, rec_w, false, rec_w],
	]

## `profile` = the RIGHT profile; otherwise the FRONT-RIGHT three-quarter view.
## `raw_bottom` = the bottom row is the Huntress RETARGETED WITHOUT the hand-
## contact IK, instead of the native control -- the sheet that shows WHY the
## bounded correction exists.
static func build_and_frame(main: SpikeMain, profile: bool, raw_bottom: bool = false) -> void:
	main.hud.set_enabled(false)
	main.inset.set_enabled(false)
	var d := main.probe.driver
	var root := Node3D.new()
	root.name = "LineupSheet_DISPLAY_ONLY"
	main.add_child(root)
	root.global_position = Vector3(0, 0, 70)
	var cam := Camera3D.new()
	cam.name = "LineupCamera"
	cam.projection = Camera3D.PROJECTION_ORTHOGONAL
	cam.size = 6.6
	cam.near = 0.05
	cam.far = 200.0
	root.add_child(cam)
	# The view: PROFILE from the bow side (+X of a figure facing +Z), or a
	# THREE-QUARTER view from its front-left.
	var view_dir := Vector3(-1, 0, 0) if profile else Vector3(-1, 0, 1).normalized()
	var centre := root.global_position + Vector3(0, 2.55, 0)
	cam.global_position = centre + view_dir * 40.0 + Vector3(0, 4.0 if not profile else 1.5, 0)
	cam.look_at(centre, Vector3.UP)
	# A key light on the camera's side, local to the sheet (it is 70 m from the
	# yard, far beyond this light's range).
	for off in [Vector3(0, 3.0, 0), Vector3(0, 6.5, 0)]:
		var key := OmniLight3D.new()
		key.light_energy = 3.0
		key.omni_range = 16.0
		key.shadow_enabled = false
		root.add_child(key)
		key.global_position = root.global_position + view_dir * 6.0 + off
	var right := cam.global_transform.basis.x
	right.y = 0.0
	right = right.normalized()
	var ps := poses(d)
	var n := ps.size()
	for k in n:
		var spec: Array = ps[k]
		var src_pose := d.source.sample(String(spec[1]), float(spec[2]), true)
		var w: float = spec[3]
		var drawn: bool = spec[4]
		var base := root.global_position + right * ((float(k) - (n - 1) * 0.5) * SPACING_M)
		# --- the retargeted Huntress (top row) ---------------------------------
		var h := (load(AssetManifest.OUTFIT_RANGER) as PackedScene).instantiate() as Node3D
		h.name = "LineupHuntress_%d" % k
		root.add_child(h)
		h.global_position = base + Vector3(0, ROW_GAP_M, 0)
		var hs := RigCorpus.find_skeleton(h)
		var rt := BowRetargeter.new()
		rt.setup(d.source, hs)
		rt.setup_ik(d.source.sample(SpikeConfig.CLIP_AIM_IDLE, 0.0), d.bow_hand)
		var res := rt.retarget(src_pose, -d.alpha_h * w, float(spec[5]))
		BowRetargeter.apply(hs, res["local"])
		var gh: Array[Transform3D] = res["global"]
		var ph := BowPresentation.new()
		root.add_child(ph)
		ph.build("lineup_h%d" % k, _bow_len(d.pres_h))
		ph.copy_solution_from(d.pres_h)
		var hx := h.global_transform
		ph.update(hx * gh[rt.index_of["hand_" + d.bow_hand]], hx * d._nock_huntress(gh), drawn, drawn)
		if raw_bottom:
			# --- the Huntress, retargeted WITHOUT the hand-contact IK ----------
			var h2 := (load(AssetManifest.OUTFIT_RANGER) as PackedScene).instantiate() as Node3D
			h2.name = "LineupHuntressRaw_%d" % k
			root.add_child(h2)
			h2.global_position = base + Vector3(0, 0.35, 0)
			var hs2 := RigCorpus.find_skeleton(h2)
			var rt2 := BowRetargeter.new()
			rt2.setup(d.source, hs2)
			var res2 := rt2.retarget(src_pose, -d.alpha_h * w, 0.0)
			BowRetargeter.apply(hs2, res2["local"])
			var gh2: Array[Transform3D] = res2["global"]
			var ph2 := BowPresentation.new()
			root.add_child(ph2)
			ph2.build("lineup_raw%d" % k, _bow_len(d.pres_h))
			ph2.copy_solution_from(d.pres_h)
			var hx2 := h2.global_transform
			ph2.update(hx2 * gh2[rt2.index_of["hand_" + d.bow_hand]], hx2 * rt2.nock_point(gh2, "r"), drawn, drawn)
			_label(root, String(spec[0]), base + Vector3(0, ROW_GAP_M + 2.2, 0), 22, Color(0.95, 0.95, 0.95))
			continue
		# --- the native control (bottom row) ----------------------------------
		var r := (load(AssetManifest.KAYKIT_RANGER) as PackedScene).instantiate() as Node3D
		r.name = "LineupNativeControl_%d" % k
		root.add_child(r)
		r.global_position = base
		var rs := RigCorpus.find_skeleton(r)
		var rl := d._ranger_local(src_pose, -d.alpha_r * w)
		BowRetargeter.apply(rs, rl)
		var gr := d._ranger_globals(rl)
		var pr := BowPresentation.new()
		root.add_child(pr)
		pr.build("lineup_r%d" % k, _bow_len(d.pres_r))
		pr.copy_solution_from(d.pres_r)
		var rx := r.global_transform
		pr.update(rx * gr[rs.find_bone("handslot." + d.bow_hand)], rx * d._nock_ranger(gr), drawn, drawn)
		_label(root, String(spec[0]), base + Vector3(0, ROW_GAP_M + 2.2, 0), 22, Color(0.95, 0.95, 0.95))
		_label(root, "clip %s @ %.3f s" % [spec[1], float(spec[2])], base + Vector3(0, ROW_GAP_M + 2.0, 0), 16, Color(0.75, 0.80, 0.90))
	var mid := root.global_position
	if raw_bottom:
		_label(root, "TOP ROW: RETARGET + the bounded hand-contact IK (what the live probe shows)", mid + Vector3(0, ROW_GAP_M + 2.55, 0), 24, Color(1.0, 0.85, 0.55))
		_label(root, "BOTTOM ROW: the SAME retarget with NO IK — rotation transfer alone preserves poses, not contacts", mid + Vector3(0, 0.05, 0), 24, Color(1.0, 0.55, 0.45))
		_label(root, "DIAGNOSTIC SHEET (D-388) — same source clip and time per column · %s · not final art" % ("RIGHT PROFILE" if profile else "FRONT-RIGHT THREE-QUARTER"), mid + Vector3(0, -0.22, 0), 18, Color(0.72, 0.76, 0.86))
		cam.current = true
		await main.get_tree().process_frame
		await main.get_tree().process_frame
		return
	_label(root, "TOP ROW: RETARGETED HUNTRESS — KayKit clips on the 65-joint Huntress", mid + Vector3(0, ROW_GAP_M + 2.55, 0), 24, Color(1.0, 0.85, 0.55))
	_label(root, "BOTTOM ROW: NATIVE KAYKIT CONTROL — 23-joint Ranger, DIAGNOSTIC COMPARATOR, NOT the Huntress", mid + Vector3(0, -0.30, 0), 24, Color(0.60, 0.85, 1.0))
	_label(root, "DIAGNOSTIC SHEET (D-388) — same source clip, same clip time, per column · %s · not final art" % ("RIGHT PROFILE (string-hand side)" if profile else "FRONT-RIGHT THREE-QUARTER"), mid + Vector3(0, -0.55, 0), 18, Color(0.72, 0.76, 0.86))
	cam.current = true
	await main.get_tree().process_frame
	await main.get_tree().process_frame

static func _bow_len(p: BowPresentation) -> float:
	return BowPresentation.bow_model_length() * p.bow_scale

static func _label(root: Node3D, text: String, pos: Vector3, size: int, col: Color) -> void:
	var l := Label3D.new()
	l.text = text
	l.font_size = size
	l.outline_size = 8
	l.pixel_size = 0.006
	l.modulate = col
	l.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	l.no_depth_test = true
	root.add_child(l)
	l.global_position = pos


## E-01a — THE DRAW AS A FILMSTRIP, FEET AGAINST THE GROUND.
## Seven moments of one use at x1.00, on the retargeted Huntress (top) and the
## native control (bottom), each with a ground line, a tick at the ROOT (the
## ground point the simulation holds still) and a marker on each foot. Foot drift
## measured by V22 is judged HERE: a foot that moves relative to its root tick
## while it stays on the ground line is SLIDING; one that leaves the line is
## STEPPING.
static func build_filmstrip(main: SpikeMain) -> void:
	main.hud.set_enabled(false)
	main.inset.set_enabled(false)
	var d := main.probe.driver
	var root := Node3D.new()
	root.name = "DrawFilmstrip_DISPLAY_ONLY"
	main.add_child(root)
	root.global_position = Vector3(0, 0, 110)
	var cam := Camera3D.new()
	cam.projection = Camera3D.PROJECTION_ORTHOGONAL
	cam.size = 6.8
	cam.far = 200.0
	root.add_child(cam)
	var view_dir := Vector3(-1, 0, 0.35).normalized()
	var centre := root.global_position + Vector3(0, 2.4, 0)
	cam.global_position = centre + view_dir * 40.0 + Vector3(0, 1.2, 0)
	cam.look_at(centre, Vector3.UP)
	var right := cam.global_transform.basis.x
	right.y = 0.0
	right = right.normalized()
	for off in [Vector3(0, 3.0, 0), Vector3(0, 6.5, 0)]:
		var key := OmniLight3D.new()
		key.light_energy = 3.0
		key.omni_range = 18.0
		root.add_child(key)
		key.global_position = root.global_position + view_dir * 6.0 + off
	var moments := [["0.10 s", SpikeConfig.CLIP_DRAW, 0.10], ["0.30 s", SpikeConfig.CLIP_DRAW, 0.30],
		["0.50 s", SpikeConfig.CLIP_DRAW, 0.50], ["0.70 s", SpikeConfig.CLIP_DRAW, 0.70],
		["0.87 s full", SpikeConfig.CLIP_AIM_IDLE, 0.0], ["release", SpikeConfig.CLIP_RELEASE, 1.0 / 30.0],
		["recovery", SpikeConfig.CLIP_RELEASE, 0.60]]
	var mark := StandardMaterial3D.new()
	mark.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mark.albedo_color = Color(1.0, 0.35, 0.25)
	var tickm := StandardMaterial3D.new()
	tickm.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	tickm.albedo_color = Color(0.45, 0.85, 1.0)
	var n := moments.size()
	for k in n:
		var m: Array = moments[k]
		var clip := String(m[1])
		var t := float(m[2])
		var w_align := BonePose.ease(t / d.t_full) if clip == SpikeConfig.CLIP_DRAW else (0.595 if t > 0.5 else 1.0)
		var w_ik := d.ik_weight_at_draw(t) if clip == SpikeConfig.CLIP_DRAW else w_align
		var p := d.source.sample(clip, t)
		var base := root.global_position + right * ((float(k) - (n - 1) * 0.5) * 1.62)
		for row in 2:
			var fig: Node3D
			var feet: Array = []
			var y := 2.9 if row == 0 else 0.0
			if row == 0:
				fig = (load(AssetManifest.OUTFIT_RANGER) as PackedScene).instantiate() as Node3D
				root.add_child(fig)
				fig.global_position = base + Vector3(0, y, 0)
				var sk := RigCorpus.find_skeleton(fig)
				var rt := BowRetargeter.new()
				rt.setup(d.source, sk)
				rt.setup_ik(d.source.sample(SpikeConfig.CLIP_AIM_IDLE, 0.0), d.bow_hand)
				var res := rt.retarget(p, -d.alpha_h * w_align, w_ik)
				BowRetargeter.apply(sk, res["local"])
				var g: Array[Transform3D] = res["global"]
				feet = [g[rt.index_of["ball_l"]].origin, g[rt.index_of["ball_r"]].origin]
			else:
				fig = (load(AssetManifest.KAYKIT_RANGER) as PackedScene).instantiate() as Node3D
				root.add_child(fig)
				fig.global_position = base + Vector3(0, y, 0)
				fig.scale = Vector3.ONE * 0.79
				var rs := RigCorpus.find_skeleton(fig)
				var rl := d._ranger_local(p, -d.alpha_r * w_align)
				BowRetargeter.apply(rs, rl)
				var gr := d._ranger_globals(rl)
				feet = [gr[rs.find_bone("toes.l")].origin * 0.79, gr[rs.find_bone("toes.r")].origin * 0.79]
			var ground := MeshInstance3D.new()
			var gm := BoxMesh.new()
			gm.size = Vector3(1.7, 0.01, 1.7)
			ground.mesh = gm
			var gmat := StandardMaterial3D.new()
			gmat.albedo_color = Color(0.20, 0.20, 0.22)
			ground.material_override = gmat
			root.add_child(ground)
			ground.global_position = base + Vector3(0, y - 0.006, 0)
			var tick := MeshInstance3D.new()
			var tm := CylinderMesh.new()
			tm.top_radius = 0.015; tm.bottom_radius = 0.015; tm.height = 0.12
			tick.mesh = tm
			tick.material_override = tickm
			root.add_child(tick)
			tick.global_position = base + Vector3(0, y + 0.06, 0)
			for f in feet:
				var s := MeshInstance3D.new()
				var sm := SphereMesh.new()
				sm.radius = 0.045; sm.height = 0.09
				s.mesh = sm
				s.material_override = mark
				# Drawn on top: a marker inside a boot must still be seen.
				mark.no_depth_test = true
				mark.render_priority = 10
				root.add_child(s)
				s.global_position = base + Vector3(0, y, 0) + (f as Vector3)
		_label(root, String(m[0]), base + Vector3(0, 5.05, 0), 22, Color(0.95, 0.95, 0.95))
	_label(root, "THE DRAW, x1.00 — TOP: retargeted Huntress (with the bounded IK) · BOTTOM: native control (scaled to the Huntress's height)", root.global_position + Vector3(0, 5.5, 0), 22, Color(1.0, 0.85, 0.55))
	_label(root, "blue tick = the ROOT / ground point the simulation holds still · red = each foot (drawn through the boot) · a foot that moves along the plate is SLIDING · bows omitted: this sheet is about the feet", root.global_position + Vector3(0, -0.45, 0), 18, Color(0.72, 0.76, 0.86))
	cam.current = true
	await main.get_tree().process_frame
	await main.get_tree().process_frame
