class_name BowRetargeter
extends RefCounted

## ============================================================================
## PORTED UNDER D-392 FROM THE ACCEPTED D-388 SPIKE -- TEMPORARY PLACEHOLDER.
## ============================================================================
## Source: game3d_huntress_spike/scripts/spike/bow_retargeter.gd, accepted under D-389 as
## PROTOTYPE FEASIBILITY EVIDENCE ("viable for prototype only"). The owner's
## D-392 ruling: "The CC0 KayKit bow clips and the D-388 retarget/hand-contact
## approach may be ported only as explicitly temporary placeholder animation.
## Preserve provenance. Do not present them as final production animation or fix
## the five accepted polish debts." NOTHING here is final animation. The spike
## itself is NOT edited and NOT referenced at runtime: this is a copy, adapted as
## stated below, and every value it reads lives in HuntressConfig.
## ADAPTED: it reads HuntressConfig. The five accepted polish debts (finger, shoulder, string,
## hood-intersection, foot-sliding) are CARRIED, NOT fixed.
## (The paragraphs below are the spike's own documentation, kept as provenance;
## where they say "the spike" they mean the source this was ported from.)

## THE RETARGET: the KayKit 23-joint source -> the current 65-joint Huntress.
##
## ============================================================================
## AN EXPLICIT MAP, IN GODOT'S OWN VOCABULARY.
## ============================================================================
## Two `BoneMap` resources on one `SkeletonProfileHumanoid`: one names the
## KayKit bone for each profile bone, the other the Huntress bone. A retarget
## PAIR is a profile bone mapped in BOTH. Every pair, every DERIVED bone, every
## REST-HELD bone and every UNMAPPED source bone is named and printed (A-02).
##
## ============================================================================
## THE TRANSFER: A REST-RELATIVE, MODEL-SPACE ROTATION TRANSFER.
## ============================================================================
## For a pair (s -> t):
##     R_target_model(t) = [R_src_model(s) * R_src_rest_model(s)^-1] * R_tgt_rest_model(t)
## i.e. the bone turns, in model space, by exactly the rotation its source
## counterpart turned away from ITS rest. This is correct when both rigs rest in
## the SAME reference pose and orientation -- measured, not assumed: both are a
## T-pose facing +Z with +Y up (A-01).
##
## POSITIONS: every bone keeps the HUNTRESS's own bone lengths. Only the pelvis
## translates, by the source hips' rest-relative offset scaled by the MEASURED
## leg-length ratio -- so a crouch in a short-legged rig becomes a proportionate
## crouch in a long-legged one.
##
## WHY NOT GODOT'S IMPORT-TIME RETARGETER: it re-rests the Huntress at import and
## makes the unmapped bones and every correction implicit. Here she loads EXACTLY
## as game3d/ loads her, and everything this file does is visible.
##
## ============================================================================
## BOUNDED CORRECTIONS -- each named, each switchable, each measured.
## ============================================================================
##   * DERIVED spine_02 / neck_01: halfway between their mapped neighbours.
##   * STATIC GRIP: a finger curl on each hand (the source has no fingers).
##   * AIM ALIGNMENT: a yaw about the ground point, supplied by the caller.
##   * HAND-CONTACT IK: an analytic two-bone solve per arm (see `setup_ik`).
##
## ============================================================================
## WHY HAND-CONTACT IK EXISTS -- MEASURED FIRST, RENDERED SECOND
## ============================================================================
## Rotation transfer preserves POSES, not CONTACTS (D-386 §3.1 item 2 predicted
## it; D-387 accepted "tested retargeting plus hand correction"). Rendered, the
## uncorrected full draw leaves the Huntress's string hand beside her right
## SHOULDER, with the arrow crossing in front of her chest: the KayKit anchor
## works only because the chibi's chin sits against its shoulder. KayKit also
## animates the upper arms' TRANSLATION (up to 0.123 m) in place of the clavicles
## its rig lacks, which a rotation transfer cannot carry.
##
## So each arm is solved so that, AT FULL DRAW, the string hand's nock point sits
## at a jaw ANCHOR and the bow hand's grip sits on the ARROW LINE at arm's reach
## -- and through the rest of the action each hand keeps the SOURCE's own
## trajectory RELATIVE TO its full-draw position (scaled by the arm-length ratio).
## The draw still draws, the snap still snaps; only where they happen moves. The
## hand ORIENTATION stays the retargeted one. Its weight is supplied per frame by
## the driver; it is 0 for idle and locomotion, so they are pure retargets.

var src: KayKitClipSource
var skel: Skeleton3D

var names: Array[String] = []
var parent: PackedInt32Array = PackedInt32Array()
var rest: Array[Transform3D] = []
var rest_global: Array[Transform3D] = []
var order: PackedInt32Array = PackedInt32Array()
var index_of: Dictionary = {}

var profile: SkeletonProfileHumanoid
var map_source: BoneMap
var map_target: BoneMap

## [{profile, s, t, s_name, t_name}]
var pairs: Array = []
## target index -> source index, for pairs
var pair_of: Dictionary = {}
## [{t, a, b, name}] where a/b are TARGET indices of mapped neighbours
var derived: Array = []
## Huntress bones neither mapped nor derived -- they keep their rest rotation
## (plus the grip curl, for fingers).
var rest_held: Array[String] = []
## Source bones with no pair.
var unmapped_source: Array[String] = []

var pelvis_t: int = -1
var hips_s: int = -1
var root_t: int = -1
var leg_ratio: float = 1.0

## Corrections, individually switchable (the suite measures with and without).
var use_derived: bool = true
var use_grip: bool = true
## target index -> extra LOCAL rotation for the grip
var grip_extra: Dictionary = {}

var planted_refusals: int = 0

## --- hand-contact IK (a bounded correction) ---------------------------------
var use_ik: bool = true
var ik_ready: bool = false
var k_arm: float = 1.0
var anchor_model: Vector3 = Vector3.ZERO        ## the jaw anchor at full draw (pre-yaw)
var arrow_dir_model: Vector3 = Vector3.FORWARD   ## the source's full-draw arrow line, planar
var _src_full_r: Vector3 = Vector3.ZERO
var _src_full_l: Vector3 = Vector3.ZERO
var _wrist_r_full: Vector3 = Vector3.ZERO
var _wrist_l_full: Vector3 = Vector3.ZERO
var ik_report: Dictionary = {}
var ik_solves: int = 0
var ik_clamped: int = 0

func setup(p_src: KayKitClipSource, p_skel: Skeleton3D) -> bool:
	src = p_src
	skel = p_skel
	for i in skel.get_bone_count():
		names.append(skel.get_bone_name(i))
		index_of[skel.get_bone_name(i)] = i
		parent.append(skel.get_bone_parent(i))
		rest.append(skel.get_bone_rest(i))
	order = KayKitClipSource._topological_order(parent)
	rest_global.resize(names.size())
	for i in order:
		rest_global[i] = rest[i] if parent[i] < 0 else rest_global[parent[i]] * rest[i]

	profile = SkeletonProfileHumanoid.new()
	map_source = BoneMap.new()
	map_source.profile = profile
	map_target = BoneMap.new()
	map_target.profile = profile
	for pb in HuntressConfig.MAP_KAYKIT.keys():
		map_source.set_skeleton_bone_name(StringName(pb), StringName(HuntressConfig.MAP_KAYKIT[pb]))
	for pb in HuntressConfig.MAP_HUNTRESS.keys():
		map_target.set_skeleton_bone_name(StringName(pb), StringName(HuntressConfig.MAP_HUNTRESS[pb]))

	# PAIRS: profile bones named in BOTH maps -- read back from the BoneMaps
	# themselves, in profile order, so the map is the resource, not a dictionary.
	var mapped_t := {}
	var mapped_s := {}
	for pi in profile.bone_size:
		var pb := profile.get_bone_name(pi)
		var sn := String(map_source.get_skeleton_bone_name(pb))
		var tn := String(map_target.get_skeleton_bone_name(pb))
		if sn == "" or tn == "":
			continue
		if not src.index_of.has(sn) or not index_of.has(tn):
			push_error("D-392: retarget map names a bone that does not exist: %s -> %s / %s" % [pb, sn, tn])
			return false
		var s: int = src.index_of[sn]
		var t: int = index_of[tn]
		pairs.append({"profile": String(pb), "s": s, "t": t, "s_name": sn, "t_name": tn})
		pair_of[t] = s
		mapped_t[t] = true
		mapped_s[s] = true
	for d in HuntressConfig.DERIVED:
		var t: int = index_of.get(String(d[0]), -1)
		var a: int = index_of.get(String(map_target.get_skeleton_bone_name(StringName(d[1]))), -1)
		var b: int = index_of.get(String(map_target.get_skeleton_bone_name(StringName(d[2]))), -1)
		if t < 0 or a < 0 or b < 0 or not pair_of.has(a) or not pair_of.has(b):
			push_error("D-392: derived bone %s has an unmapped neighbour" % str(d))
			return false
		derived.append({"t": t, "a": a, "b": b, "name": String(d[0])})
	var derived_t := {}
	for d in derived:
		derived_t[int(d["t"])] = true
	for i in names.size():
		if not mapped_t.has(i) and not derived_t.has(i):
			rest_held.append(names[i])
	for j in src.bone_count():
		if not mapped_s.has(j):
			unmapped_source.append(src.bone_names[j])

	pelvis_t = index_of.get("pelvis", -1)
	root_t = index_of.get("root", -1)
	hips_s = src.index_of.get("hips", -1)
	# THE LEG-LENGTH RATIO, MEASURED from both rests: hip joint to ankle.
	var tl := rest_global[index_of["thigh_l"]].origin.y - rest_global[index_of["foot_l"]].origin.y
	var sl: float = src.rest_global[src.index_of["upperleg.l"]].origin.y \
		- src.rest_global[src.index_of["foot.l"]].origin.y
	leg_ratio = tl / sl if sl > 0.0 else 1.0
	_build_grip()
	return true

## Would a map naming `bone` resolve? Used by the suite to prove the resolver
## REFUSES a planted bad name (A-02) -- a guard nothing can reach is not a guard.
func resolves_target(bone: String) -> bool:
	if not index_of.has(bone):
		planted_refusals += 1
		return false
	return true

# --------------------------------------------------------------- the grip ----

func _build_grip() -> void:
	grip_extra = {}
	for side in [["l", HuntressConfig.GRIP_BOW_HAND, Vector3(0, 0, -1)],
			["r", HuntressConfig.GRIP_STRING_HAND, Vector3(0, 0, 1)]]:
		var sfx: String = side[0]
		var spec: Dictionary = side[1]
		# The curl axis in the REST pose: for a T-pose with palms down, a finger
		# bends toward the palm (-Y). For the left hand fingers point +X, so the
		# axis is +X x -Y = -Z; for the right hand, -X x -Y = +Z.
		var axis_world: Vector3 = side[2]
		for finger in spec.keys():
			var angles: Array = spec[finger]
			for k in 3:
				var bn := "%s_%02d_%s" % [finger, k + 1, sfx]
				if not index_of.has(bn):
					continue
				var bi: int = index_of[bn]
				var axis_local: Vector3 = (rest_global[bi].basis.get_rotation_quaternion().inverse() * axis_world).normalized()
				grip_extra[bi] = Quaternion(axis_local, deg_to_rad(float(angles[k])))

# ------------------------------------------------------------ the transfer ----

## Retargets one SOURCE local pose. `yaw` (radians) turns the whole body about
## the ground point -- the AIM ALIGNMENT correction. Returns:
##   "local":  the Huntress BonePose to apply
##   "global": model-space transforms, WITH the yaw applied
##   "delta":  target index -> the model-space rotation delta applied (pairs and
##             derived), for the fidelity check (A-06)
func retarget(src_pose: BonePose, yaw: float = 0.0, ik_w: float = 0.0) -> Dictionary:
	var sg := src.globals(src_pose)
	var delta := {}
	for p in pairs:
		var s: int = p["s"]
		var d: Quaternion = sg[s].basis.get_rotation_quaternion() \
			* src.rest_global[s].basis.get_rotation_quaternion().inverse()
		delta[int(p["t"])] = d.normalized()
	if use_derived:
		for d in derived:
			var qa: Quaternion = delta[int(d["a"])]
			var qb: Quaternion = delta[int(d["b"])]
			delta[int(d["t"])] = qa.slerp(qb, 0.5).normalized()
	var n := names.size()
	var out := BonePose.sized(n)
	var g: Array[Transform3D] = []
	g.resize(n)
	for t in order:
		var p := parent[t]
		var pg: Transform3D = g[p] if p >= 0 else Transform3D.IDENTITY
		var pg_rot := pg.basis.get_rotation_quaternion()
		var rot_model: Quaternion
		if delta.has(t):
			rot_model = (delta[t] as Quaternion) * rest_global[t].basis.get_rotation_quaternion()
		else:
			var lr := rest[t].basis.get_rotation_quaternion()
			if use_grip and grip_extra.has(t):
				lr = lr * (grip_extra[t] as Quaternion)
			rot_model = pg_rot * lr
		var pos_model: Vector3
		if t == pelvis_t and hips_s >= 0:
			var off: Vector3 = sg[hips_s].origin - src.rest_global[hips_s].origin
			pos_model = rest_global[t].origin + off * leg_ratio
		else:
			pos_model = pg * rest[t].origin
		var local_rot := (pg_rot.inverse() * rot_model).normalized()
		var local_pos := pg.affine_inverse() * pos_model if p >= 0 else pos_model
		out.rot[t] = local_rot
		out.pos[t] = local_pos
		out.scl[t] = rest[t].basis.get_scale()
		g[t] = Transform3D(Basis(rot_model).scaled(out.scl[t]), pos_model)
	# HAND-CONTACT IK -- only inside the bow action, only when enabled.
	if use_ik and ik_ready and ik_w > 0.0:
		var off_r: Vector3 = (sg[src.index_of["hand.r"]].origin - _src_full_r) * k_arm
		var off_l: Vector3 = (sg[src.index_of["hand.l"]].origin - _src_full_l) * k_arm
		var ir: int = index_of["hand_r"]
		var il: int = index_of["hand_l"]
		var tr: Vector3 = g[ir].origin.lerp(_wrist_r_full + off_r, ik_w)
		var tl: Vector3 = g[il].origin.lerp(_wrist_l_full + off_l, ik_w)
		_solve_two_bone(g, out, index_of["upperarm_r"], index_of["lowerarm_r"], ir, tr, HuntressConfig.IK_POLE_HINT_RIGHT)
		_solve_two_bone(g, out, index_of["upperarm_l"], index_of["lowerarm_l"], il, tl, HuntressConfig.IK_POLE_HINT_LEFT)
		_fk(out, g)
	# AIM ALIGNMENT: a yaw about the ground point, applied at the root so that
	# every bone -- and every attachment computed from these globals -- turns.
	if absf(yaw) > 0.0 and root_t >= 0:
		var qy := Quaternion(Vector3.UP, yaw)
		out.rot[root_t] = (qy * out.rot[root_t]).normalized()
		out.pos[root_t] = qy * out.pos[root_t]
		var ty := Transform3D(Basis(qy), Vector3.ZERO)
		for i in n:
			g[i] = ty * g[i]
	return {"local": out, "global": g, "delta": delta, "source_global": sg}

func _fk(pose: BonePose, g: Array[Transform3D]) -> void:
	for t in order:
		var l := pose.local_transform(t)
		g[t] = l if parent[t] < 0 else g[parent[t]] * l

## Analytic two-bone IK in MODEL space. Swings the upper and lower arm so the
## wrist reaches `target`; the elbow keeps the side it was already on (the pole
## is the current elbow, so the SOURCE's elbow character is kept); the hand keeps
## its model-space rotation. Out-of-reach targets clamp to a straight arm, and
## are counted.
func _solve_two_bone(g: Array[Transform3D], pose: BonePose, iu: int, il: int, ih: int, target: Vector3,
		pole_hint: Vector3 = Vector3.DOWN) -> void:
	ik_solves += 1
	var pu := g[iu].origin
	var pl := g[il].origin
	var ph := g[ih].origin
	var a := pu.distance_to(pl)
	var b := pl.distance_to(ph)
	var to := target - pu
	var dist := to.length()
	var d := clampf(dist, absf(a - b) + 0.0001, a + b - 0.0001)
	if not is_equal_approx(d, dist):
		ik_clamped += 1
	var dir := to / maxf(dist, 0.0001)
	# THE POLE: the retargeted elbow's side about the raw arm's OWN shoulder->
	# wrist axis, carried by the SAME swing that brings that axis onto the
	# target -- plus a small FIXED hint per arm for when the raw arm is straight.
	# History, measured: the first version took the raw elbow's side relative to
	# the shoulder->TARGET line (a different axis); mid-draw that direction spun
	# ~90 degrees in three frames and the elbow jumped 28-53 degrees per frame.
	var raw_dir := (ph - pu).normalized()
	var pole := (pl - pu) - raw_dir * (pl - pu).dot(raw_dir)
	if raw_dir.dot(dir) > -0.999:
		pole = Quaternion(raw_dir, dir) * pole
	pole = pole - dir * pole.dot(dir)
	var hint := pole_hint - dir * pole_hint.dot(dir)
	pole = pole + hint.normalized() * HuntressConfig.IK_POLE_HINT_M
	if pole.length() < 0.00001:
		pole = dir.cross(Vector3.UP)
	pole = pole.normalized()
	var cos_a := clampf((a * a + d * d - b * b) / (2.0 * a * d), -1.0, 1.0)
	var sin_a := sqrt(maxf(0.0, 1.0 - cos_a * cos_a))
	var e := pu + dir * (a * cos_a) + pole * (a * sin_a)
	var w := pu + dir * d
	var q_u := Quaternion((pl - pu).normalized(), (e - pu).normalized())
	var ru := (q_u * g[iu].basis.get_rotation_quaternion()).normalized()
	var lower_dir := q_u * (ph - pl)
	var q_l := Quaternion(lower_dir.normalized(), (w - e).normalized())
	var rl := (q_l * q_u * g[il].basis.get_rotation_quaternion()).normalized()
	var rh := g[ih].basis.get_rotation_quaternion()
	var pr := g[parent[iu]].basis.get_rotation_quaternion() if parent[iu] >= 0 else Quaternion.IDENTITY
	pose.rot[iu] = (pr.inverse() * ru).normalized()
	pose.rot[il] = (ru.inverse() * rl).normalized()
	pose.rot[ih] = (rl.inverse() * rh).normalized()

## THE HUNTRESS'S GRIP AND NOCK POINTS -- defined on HER hands, not the source's.
func grip_point(g: Array[Transform3D], side: String = "l") -> Vector3:
	return g[index_of["hand_" + side]].origin.lerp(g[index_of["middle_02_" + side]].origin, 0.55)

func nock_point(g: Array[Transform3D], side: String = "r") -> Vector3:
	return g[index_of["index_02_" + side]].origin.lerp(g[index_of["middle_02_" + side]].origin, 0.5)

## Prepares the IK from ONE full-draw source pose (Aiming_Idle at 0, which IS
## Draw's end pose). Everything here is MEASURED from the two rigs, except the
## anchor's offset from the Head bone, which is a declared PROVISIONAL value.
func setup_ik(full_pose: BonePose, bow_side: String) -> void:
	var string_side := "r" if bow_side == "l" else "l"
	var sg := src.globals(full_pose)
	_src_full_r = sg[src.index_of["hand.r"]].origin
	_src_full_l = sg[src.index_of["hand.l"]].origin
	var line := (sg[src.index_of["hand." + bow_side]].origin - sg[src.index_of["hand." + string_side]].origin)
	line.y = 0.0
	arrow_dir_model = line.normalized()
	# The arm-length ratio: shoulder joint -> hand joint, Huntress over source.
	var h_arm := rest_global[index_of["upperarm_l"]].origin.distance_to(rest_global[index_of["lowerarm_l"]].origin) \
		+ rest_global[index_of["lowerarm_l"]].origin.distance_to(rest_global[index_of["hand_l"]].origin)
	var s_arm: float = src.rest_global[src.index_of["upperarm.l"]].origin.distance_to(src.rest_global[src.index_of["lowerarm.l"]].origin) \
		+ src.rest_global[src.index_of["lowerarm.l"]].origin.distance_to(src.rest_global[src.index_of["wrist.l"]].origin) \
		+ src.rest_global[src.index_of["wrist.l"]].origin.distance_to(src.rest_global[src.index_of["hand.l"]].origin)
	k_arm = h_arm / s_arm
	var raw := retarget(full_pose, 0.0, 0.0)
	var g: Array[Transform3D] = raw["global"]
	var head_i: int = index_of["Head"]
	var head_rest := rest_global[head_i]
	var anchor_local := head_rest.affine_inverse() * HuntressConfig.ANCHOR_REST_MODEL
	anchor_model = g[head_i] * anchor_local
	# The string hand's wrist, placed so its NOCK POINT sits on the anchor.
	var nock_off := nock_point(g, string_side) - g[index_of["hand_" + string_side]].origin
	var wrist_s := anchor_model - nock_off
	# The bow hand's wrist, placed so its GRIP sits on the arrow line, at a
	# declared fraction of the arm's reach from the shoulder.
	var grip_off := grip_point(g, bow_side) - g[index_of["hand_" + bow_side]].origin
	var s_l := g[index_of["upperarm_" + bow_side]].origin
	var reach := h_arm * HuntressConfig.BOW_ARM_REACH_FRACTION
	var o := anchor_model - grip_off - s_l
	var bq := arrow_dir_model.dot(o)
	var cq := o.dot(o) - reach * reach
	var disc := bq * bq - cq
	var t_ray := -bq + sqrt(maxf(0.0, disc))
	var wrist_b := anchor_model + arrow_dir_model * t_ray - grip_off
	if bow_side == "l":
		_wrist_l_full = wrist_b
		_wrist_r_full = wrist_s
	else:
		_wrist_r_full = wrist_b
		_wrist_l_full = wrist_s
	ik_ready = true
	ik_report = {"k_arm": k_arm, "huntress_arm_m": h_arm, "source_arm_m": s_arm,
		"anchor_model": anchor_model, "arrow_dir_model": arrow_dir_model,
		"draw_length_on_line_m": t_ray, "reach_solvable": disc >= 0.0,
		"source_arrow_offset_deg": rad_to_deg(atan2(arrow_dir_model.x, arrow_dir_model.z))}

static func apply(sk: Skeleton3D, pose: BonePose) -> void:
	for i in pose.size():
		sk.set_bone_pose_position(i, pose.pos[i])
		sk.set_bone_pose_rotation(i, pose.rot[i])
		sk.set_bone_pose_scale(i, pose.scl[i])

## Model-space rest data of any skeleton, for measurement.
static func rest_globals_of(sk: Skeleton3D) -> Array[Transform3D]:
	var par := PackedInt32Array()
	var r: Array[Transform3D] = []
	for i in sk.get_bone_count():
		par.append(sk.get_bone_parent(i))
		r.append(sk.get_bone_rest(i))
	var ord := KayKitClipSource._topological_order(par)
	var g: Array[Transform3D] = []
	g.resize(r.size())
	for i in ord:
		g[i] = r[i] if par[i] < 0 else g[par[i]] * r[i]
	return g
