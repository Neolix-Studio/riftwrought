class_name BowPoseDriver
extends Node

## ONE TIMELINE, TWO BODIES: the pose both visuals show, every physics frame.
##
## ============================================================================
## MECHANICAL TIMING IS AUTHORITATIVE OVER ANIMATION TIMING.
## ============================================================================
## This node runs AFTER the verbatim controller has stepped (it is the probe's
## child, and child physics runs after the parent's). It reads the ACCEPTED
## commitment -- `elapsed`, `duration`, `release_marker` -- and derives the pose
## from them. It never tells the controller when to release: the controller
## fires the release at `elapsed >= duration * release_marker`, and this node
## decides "released" with THAT SAME EXPRESSION, so the frame the clip crosses
## into Ranged_Bow_Release and the frame the arrow leaves are the same frame by
## construction (A-12, B-08).
##
## ============================================================================
## BOTH BODIES ARE POSED FROM THE SAME SOURCE POSE, EVERY FRAME.
## ============================================================================
## The retargeted Huntress and the native KayKit control never disagree about
## clip, time or blend. The comparison switch changes only which one is VISIBLE
## -- never the simulation (R-03).

var probe: Node3D                        ## HuntressSpikeProbe
var source: KayKitClipSource
var retarget: BowRetargeter
var huntress_skel: Skeleton3D
var huntress_body: Node3D                ## the Armature node, hidden for the comparison
var ranger_root: Node3D
var ranger_skel: Skeleton3D
var pres_h: BowPresentation
var pres_r: BowPresentation
var show_ranger: bool = false

## Native control data: source bone index -> Ranger bone index, and its FK.
var _r_index: PackedInt32Array = PackedInt32Array()
var _r_parent: PackedInt32Array = PackedInt32Array()
var _r_order: PackedInt32Array = PackedInt32Array()
var _r_names: Array[String] = []

## THE TIMELINE (authored seconds) -- MEASURED at build.
var t_full: float = 0.0
var t_rel: float = 0.0
var t_total: float = 0.0
var release_len: float = 0.0
var bow_hand: String = ""                ## "l" or "r", measured

## Per-visual measurements, made at build.
var measured: Dictionary = {}            ## "huntress" / "ranger" -> {...}
var alpha_h: float = 0.0                 ## aim-line yaw offset (radians)
var alpha_r: float = 0.0
var nock_tau_h: float = 0.0
var nock_tau_r: float = 0.0

## Fixed crossfade sources.
var _hold_from: BonePose
var _release_from: BonePose
var _leg_mask: PackedInt32Array = PackedInt32Array()

## Per-use state.
var in_action: bool = false
var use_rate: float = 1.0
var use_id: int = 0
var _snapshot: BonePose
var _cancels_at_start: int = 0
var tau: float = 0.0
var released: bool = false
var phase: String = "IDLE"
var align_w: float = 0.0
## The hand-contact IK weight this frame: 0 in idle and locomotion.
var ik_w: float = 0.0
var _ik_from: float = 0.0

## Locomotion state.
var loco_state: String = "idle"
var _loco_from: BonePose = null
var _loco_blend_t: float = 0.0
var _loco_blend_dur: float = 0.0
var _align_from: float = 0.0
var idle_t: float = 0.0
var run_t: float = 0.0

var last_pose: BonePose
var last_h: Dictionary = {}              ## last retarget result (Huntress)
var last_r_global: Array[Transform3D] = []
var last_r_local: BonePose
## Per-frame log for the suite: [physics_frame, phase, tau, released, clip]
var log_enabled: bool = false
var frame_log: Array = []
var current_clip: String = ""
var current_clip_time: float = 0.0

func build(p_probe: Node3D, p_source: KayKitClipSource, h_visual: Node3D, r_root: Node3D) -> bool:
	probe = p_probe
	source = p_source
	huntress_skel = RigCorpus.find_skeleton(h_visual)
	huntress_body = huntress_skel.get_parent() as Node3D
	ranger_root = r_root
	ranger_skel = RigCorpus.find_skeleton(r_root)
	retarget = BowRetargeter.new()
	if not retarget.setup(source, huntress_skel):
		return false
	for i in ranger_skel.get_bone_count():
		_r_names.append(ranger_skel.get_bone_name(i))
		_r_parent.append(ranger_skel.get_bone_parent(i))
	_r_order = KayKitClipSource._topological_order(_r_parent)
	_r_index.resize(source.bone_count())
	for s in source.bone_count():
		_r_index[s] = ranger_skel.find_bone(source.bone_names[s])
	for n in ["root", "hips", "upperleg.l", "lowerleg.l", "foot.l", "toes.l",
			"upperleg.r", "lowerleg.r", "foot.r", "toes.r"]:
		_leg_mask.append(int(source.index_of[n]))
	_measure_timeline()
	# THE HAND-CONTACT IK is prepared from the full-draw pose (Aiming_Idle at 0,
	# which IS Draw's end pose) -- after the bow hand is known.
	retarget.setup_ik(source.sample(SpikeConfig.CLIP_AIM_IDLE, 0.0), bow_hand)
	last_pose = source.sample(SpikeConfig.CLIP_BOW_IDLE, 0.0)
	return true

# ------------------------------------------------------------- measurement --

## T_full, the release point and the bow hand, MEASURED from the source clips.
func _measure_timeline() -> void:
	var draw_len := source.length_of(SpikeConfig.CLIP_DRAW)
	release_len = source.length_of(SpikeConfig.CLIP_RELEASE)
	var hr: int = source.index_of["hand.r"]
	var hl: int = source.index_of["hand.l"]
	# Which hand holds the bow: the one extended FORWARD at the end of the draw.
	var ge := source.globals(source.sample(SpikeConfig.CLIP_DRAW, draw_len))
	bow_hand = "l" if ge[hl].origin.z > ge[hr].origin.z else "r"
	var string_i: int = hr if bow_hand == "l" else hl
	# T_full: the first sample after which the string hand stays below the
	# declared speed for the rest of the clip.
	var dt := 1.0 / 60.0
	var n := int(floor(draw_len / dt))
	var speeds: Array[float] = []
	var prev := source.globals(source.sample(SpikeConfig.CLIP_DRAW, 0.0))[string_i].origin
	for k in range(1, n + 1):
		var p := source.globals(source.sample(SpikeConfig.CLIP_DRAW, k * dt))[string_i].origin
		speeds.append(p.distance_to(prev) / dt)
		prev = p
	var first_ok := n
	for k in range(speeds.size() - 1, -1, -1):
		if speeds[k] >= SpikeConfig.FULL_DRAW_SPEED_MPS:
			break
		first_ok = k
	t_full = float(first_ok) * dt
	t_rel = t_full + SpikeConfig.HOLD_S
	t_total = t_rel + release_len
	_hold_from = source.sample(SpikeConfig.CLIP_DRAW, t_full)
	_release_from = source.sample(SpikeConfig.CLIP_AIM_IDLE, SpikeConfig.HOLD_S, true)

## The normalised release marker handed to the ACCEPTED commitment.
func marker() -> float:
	return t_rel / t_total

func duration_at(rate: float) -> float:
	return t_total / rate

## Per-visual solves at the FULL-DRAW pose (Aiming_Idle at 0 == Draw's end).
## Must run after the presentations exist and the visuals are in the tree.
func solve_presentations(p_h: BowPresentation, p_r: BowPresentation) -> void:
	pres_h = p_h
	pres_r = p_r
	var full := source.sample(SpikeConfig.CLIP_AIM_IDLE, 0.0)
	# --- the Huntress -------------------------------------------------------
	var rh := retarget.retarget(full, 0.0, 1.0)
	var gh: Array[Transform3D] = rh["global"]
	var carry_h := gh[retarget.index_of["hand_" + bow_hand]]
	var grip_h := _grip_huntress(gh)
	var nock_h := _nock_huntress(gh)
	var v := grip_h - nock_h
	alpha_h = atan2(v.x, v.z)
	var sh := pres_h.solve(carry_h, grip_h, nock_h)
	# --- the native control ------------------------------------------------
	var gr := _ranger_globals(_ranger_local(full, 0.0))
	var carry_r := gr[ranger_skel.find_bone("handslot." + bow_hand)]
	var grip_r := carry_r.origin
	var nock_r := _nock_ranger(gr)
	var vr := grip_r - nock_r
	alpha_r = atan2(vr.x, vr.z)
	var sr := pres_r.solve(carry_r, grip_r, nock_r)
	measured["huntress"] = sh
	measured["ranger"] = sr
	measured["huntress"]["alpha_deg"] = rad_to_deg(alpha_h)
	measured["ranger"]["alpha_deg"] = rad_to_deg(alpha_r)
	# --- the nock moment, per visual ----------------------------------------
	nock_tau_h = _nock_moment(true)
	nock_tau_r = _nock_moment(false)

func _grip_huntress(g: Array[Transform3D]) -> Vector3:
	return retarget.grip_point(g, bow_hand)

func _nock_huntress(g: Array[Transform3D]) -> Vector3:
	return retarget.nock_point(g, "r" if bow_hand == "l" else "l")

## The IK weight at authored action time `t` (the same schedule the live action
## uses -- so the nock moment is measured on the pose that is actually shown).
func ik_weight_at_draw(t: float) -> float:
	return BonePose.ease(t / SpikeConfig.IK_RAMP_S)

func _nock_ranger(g: Array[Transform3D]) -> Vector3:
	var s := "r" if bow_hand == "l" else "l"
	return g[ranger_skel.find_bone("handslot." + s)].origin

## The draw time at which the nock point is nearest the string's REST centre --
## the moment the arrow is nocked and the string is taken. Also records how far
## apart they still are then: that distance is a visible pop, and is reported.
func _nock_moment(huntress: bool) -> float:
	var best := INF
	var best_t := 0.0
	var dt := 1.0 / 60.0
	var k := 0
	while k * dt <= t_full:
		var p := source.sample(SpikeConfig.CLIP_DRAW, k * dt)
		var carry: Transform3D
		var nock: Vector3
		var pres: BowPresentation
		if huntress:
			var g: Array[Transform3D] = retarget.retarget(p, 0.0, ik_weight_at_draw(k * dt))["global"]
			carry = g[retarget.index_of["hand_" + bow_hand]]
			nock = _nock_huntress(g)
			pres = pres_h
		else:
			var g2 := _ranger_globals(_ranger_local(p, 0.0))
			carry = g2[ranger_skel.find_bone("handslot." + bow_hand)]
			nock = _nock_ranger(g2)
			pres = pres_r
		var bw := pres.bow_transform_for(carry)
		var rest_c := bw * (BowPresentation.STRING_REST_LOCAL * pres.bow_scale)
		var d := nock.distance_to(rest_c)
		if d < best:
			best = d
			best_t = k * dt
		k += 1
	measured["huntress" if huntress else "ranger"]["nock_gap_m"] = best
	return best_t

# ---------------------------------------------------------- the native pose --

func _ranger_local(p: BonePose, yaw: float) -> BonePose:
	var out := BonePose.sized(ranger_skel.get_bone_count())
	for i in ranger_skel.get_bone_count():
		var r := ranger_skel.get_bone_rest(i)
		out.pos[i] = r.origin
		out.rot[i] = r.basis.get_rotation_quaternion()
		out.scl[i] = r.basis.get_scale()
	for s in source.bone_count():
		var ri := _r_index[s]
		if ri < 0:
			continue
		# A CHANNEL the clip does NOT animate keeps the Ranger's OWN rest.
		var bits: int = p.tracked[s] if s < p.tracked.size() else 7
		if bits & 1:
			out.pos[ri] = p.pos[s]
		if bits & 2:
			out.rot[ri] = p.rot[s]
		if bits & 4:
			out.scl[ri] = p.scl[s]
	if absf(yaw) > 0.0:
		var root := ranger_skel.find_bone("root")
		var qy := Quaternion(Vector3.UP, yaw)
		out.rot[root] = (qy * out.rot[root]).normalized()
		out.pos[root] = qy * out.pos[root]
	return out

func _ranger_globals(p: BonePose) -> Array[Transform3D]:
	var g: Array[Transform3D] = []
	g.resize(p.size())
	for i in _r_order:
		var l := p.local_transform(i)
		g[i] = l if _r_parent[i] < 0 else g[_r_parent[i]] * l
	return g

# ----------------------------------------------------------------- per use --

## Called by the probe on the frame a bow use begins.
func begin_action(p_use_id: int, rate: float) -> void:
	in_action = true
	use_id = p_use_id
	use_rate = rate
	_snapshot = last_pose.copy()
	_cancels_at_start = int(probe.get("recovery_cancels"))
	released = false

func _physics_process(delta: float) -> void:
	step(delta)

## Separated so the suite can drive exact steps.
func step(delta: float) -> void:
	var c: ActionCommitment = probe.get("commitment")
	var bow_active := c.active and c.label == SpikeConfig.BOW_ACTION_LABEL
	var pose: BonePose
	if bow_active:
		pose = _action_pose(c)
	else:
		if in_action:
			_end_action()
		pose = _loco_pose(delta)
	last_pose = pose
	_present(pose)
	if log_enabled:
		frame_log.append({"frame": Engine.get_physics_frames(), "phase": phase, "tau": tau,
			"released": released, "clip": current_clip, "t": current_clip_time,
			"in_action": in_action, "ik_w": ik_w, "align_w": align_w,
			"arrow_h": pres_h.arrow_visible if pres_h != null else false,
			"drawn_h": pres_h.drawn if pres_h != null else false,
			"string_h": pres_h.string_centre_world if pres_h != null else Vector3.ZERO,
			"string_rest_h": pres_h.string_rest_world if pres_h != null else Vector3.ZERO,
			"arrow_xf_h": pres_h.arrow_world if pres_h != null else Transform3D.IDENTITY})

func _action_pose(c: ActionCommitment) -> BonePose:
	tau = c.elapsed * use_rate
	# THE SAME EXPRESSION THE CONTROLLER RELEASES ON. Not a re-derivation.
	released = c.elapsed >= c.duration * c.release_marker
	var pose: BonePose
	if not released:
		if tau < t_full:
			phase = "DRAW"
			current_clip = SpikeConfig.CLIP_DRAW
			current_clip_time = tau
			pose = source.sample(SpikeConfig.CLIP_DRAW, tau)
			if tau < SpikeConfig.XFADE_INTO_DRAW_S:
				pose = BonePose.blend(_snapshot, pose, BonePose.ease(tau / SpikeConfig.XFADE_INTO_DRAW_S))
			align_w = BonePose.ease(tau / t_full)
			ik_w = ik_weight_at_draw(tau)
		else:
			phase = "HOLD"
			var th := tau - t_full
			current_clip = SpikeConfig.CLIP_AIM_IDLE
			current_clip_time = th
			pose = source.sample(SpikeConfig.CLIP_AIM_IDLE, th, true)
			if th < SpikeConfig.XFADE_DRAW_TO_HOLD_S:
				pose = BonePose.blend(_hold_from, pose, BonePose.ease(th / SpikeConfig.XFADE_DRAW_TO_HOLD_S))
			align_w = 1.0
			ik_w = 1.0
	else:
		var tr := maxf(0.0, tau - t_rel)
		current_clip = SpikeConfig.CLIP_RELEASE
		current_clip_time = tr
		pose = source.sample(SpikeConfig.CLIP_RELEASE, tr)
		# THE UPPER BODY SWITCHES AT ONCE -- the snap is the whole point of the
		# clip -- while the legs ease across the measured gap.
		if tr < SpikeConfig.XFADE_HOLD_TO_RELEASE_LEGS_S:
			pose = BonePose.blend(_release_from, pose,
				BonePose.ease(tr / SpikeConfig.XFADE_HOLD_TO_RELEASE_LEGS_S), _leg_mask)
		phase = "RELEASE" if tr < SpikeConfig.RELEASE_SNAP_WINDOW_S else "RECOVERY"
		var rec := clampf((tr - SpikeConfig.RELEASE_SNAP_WINDOW_S)
			/ maxf(0.001, release_len - SpikeConfig.RELEASE_SNAP_WINDOW_S), 0.0, 1.0)
		align_w = 1.0 - rec
		ik_w = 1.0 - rec
	return pose

func _end_action() -> void:
	in_action = false
	var cancelled := int(probe.get("recovery_cancels")) > _cancels_at_start
	if cancelled:
		# RECOVERY CANCELLED: ease from the pose on screen into locomotion.
		_loco_from = last_pose.copy()
		_loco_blend_t = 0.0
		_loco_blend_dur = SpikeConfig.XFADE_CANCEL_TO_LOCO_S
		_align_from = align_w
		_ik_from = ik_w
	else:
		# NATURAL END: Release ends EXACTLY in Bow_Idle's first pose (measured).
		_loco_from = null
		_align_from = 0.0
		align_w = 0.0
		_ik_from = 0.0
		ik_w = 0.0
		idle_t = 0.0
		loco_state = "idle"
	tau = 0.0

func _loco_pose(delta: float) -> BonePose:
	var want := "idle" if String(probe.get("loco_request")) == "idle" else "run"
	if want != loco_state:
		_loco_from = last_pose.copy()
		_loco_blend_t = 0.0
		_loco_blend_dur = SpikeConfig.XFADE_LOCO_S
		_align_from = align_w
		_ik_from = ik_w
		loco_state = want
		if want == "run":
			run_t = 0.0
		else:
			idle_t = 0.0
	var pose: BonePose
	if loco_state == "idle":
		idle_t += delta
		current_clip = SpikeConfig.CLIP_BOW_IDLE
		current_clip_time = fposmod(idle_t, source.length_of(current_clip))
		pose = source.sample(SpikeConfig.CLIP_BOW_IDLE, idle_t, true)
		phase = "IDLE"
	else:
		var sp: float = (probe.get("motor") as LocomotionMotor).speed()
		run_t += delta * clampf(sp / SpikeConfig.RUN_CLIP_REFERENCE_SPEED_MPS, 0.35, 1.6)
		current_clip = SpikeConfig.CLIP_RUN_BOW
		current_clip_time = fposmod(run_t, source.length_of(current_clip))
		pose = source.sample(SpikeConfig.CLIP_RUN_BOW, run_t, true)
		phase = "RUN"
	if _loco_from != null and _loco_blend_t < _loco_blend_dur:
		var w := BonePose.ease(_loco_blend_t / _loco_blend_dur)
		pose = BonePose.blend(_loco_from, pose, w)
		align_w = _align_from * (1.0 - w)
		ik_w = _ik_from * (1.0 - w)
		_loco_blend_t += delta
	else:
		_loco_from = null
		align_w = 0.0
		ik_w = 0.0
	return pose

# ---------------------------------------------------------------- present ---

func _present(pose: BonePose) -> void:
	var h := retarget.retarget(pose, -alpha_h * align_w, ik_w)
	BowRetargeter.apply(huntress_skel, h["local"])
	last_h = h
	var rl := _ranger_local(pose, -alpha_r * align_w)
	BowRetargeter.apply(ranger_skel, rl)
	last_r_local = rl
	last_r_global = _ranger_globals(rl)
	if pres_h == null:
		return
	var drawn_h := in_action and not released and tau >= nock_tau_h
	var drawn_r := in_action and not released and tau >= nock_tau_r
	var vis_xf: Transform3D = (probe.get("visual") as Node3D).global_transform
	var gh: Array[Transform3D] = h["global"]
	pres_h.update(vis_xf * gh[retarget.index_of["hand_" + bow_hand]], vis_xf * _nock_huntress(gh),
		drawn_h, drawn_h)
	var gr := last_r_global
	pres_r.update(vis_xf * gr[ranger_skel.find_bone("handslot." + bow_hand)], vis_xf * _nock_ranger(gr),
		drawn_r, drawn_r)

## The visible visual's presentation -- where the projectile takes over.
func visible_presentation() -> BowPresentation:
	return pres_r if show_ranger else pres_h

func set_show_ranger(v: bool) -> void:
	show_ranger = v
	huntress_body.visible = not v
	ranger_root.visible = v
	pres_h.set_shown(not v)
	pres_r.set_shown(v)

## World transforms of named bones of the VISIBLE-OR-NAMED visual, for the suite.
func huntress_world(bone: String) -> Transform3D:
	var vis_xf: Transform3D = (probe.get("visual") as Node3D).global_transform
	return vis_xf * (last_h["global"] as Array)[retarget.index_of[bone]]

func ranger_world(bone: String) -> Transform3D:
	var vis_xf: Transform3D = (probe.get("visual") as Node3D).global_transform
	return vis_xf * last_r_global[ranger_skel.find_bone(bone)]
