class_name HuntressBowAnimator
extends Node

## THE HUNTRESS'S PLACEHOLDER ANIMATION LAYER (D-392) — the D-388 timeline,
## ported, and applied OVER the accepted AnimationPlayer.
##
## ============================================================================
## MECHANICAL TIMING IS AUTHORITATIVE OVER ANIMATION TIMING.
## ============================================================================
## This node runs AFTER the accepted controller has stepped (it is the player's
## child, added after the visual) and after the accepted AnimationPlayer has
## applied its clip. It reads the ACCEPTED commitment -- `elapsed`, `duration`,
## `release_marker` -- and derives the pose from them. IT NEVER TELLS THE
## CONTROLLER WHEN TO RELEASE: the controller releases at
## `elapsed >= duration * release_marker`, and this node decides "released" with
## THAT SAME EXPRESSION, so the frame the pose enters `Ranged_Bow_Release` and the
## frame the arrow leaves are the same frame by construction.
##
## The clip's PLAYBACK RATE is DERIVED so its authored release lands on the
## mechanical one: rate = t_rel (measured, authored) / SPLINTER_RELEASE_S. It is
## reported, never chosen, and it is NOT attack speed.
##
## ============================================================================
## OVER THE ACCEPTED ANIMATION PLAYER, NOT INSTEAD OF IT.
## ============================================================================
## The accepted `PlayerController` keeps its UAL AnimationPlayer and keeps asking
## it for "Idle" / "Walk" / "Jog_Fwd": every accepted clip check still reads it.
## Rendered, UAL `Idle` carries the bow HORIZONTALLY AT THE HIP (the D-392 lab
## probe), so this layer shows the KayKit carried-bow clips instead -- PLACEHOLDER
## animation -- through a `SkeletonModifier3D`, which Godot applies after the
## mixer every frame. The F1 overlay states what is SHOWN beside what the
## controller REQUESTS, so a borrowed clip is never presented as the accepted one.
##
## ============================================================================
## THE FIVE ACCEPTED D-389 POLISH DEBTS ARE CARRIED, NOT FIXED.
## ============================================================================
## Static grip (finger), rest-held clavicles (shoulder), the nock-moment string
## jump (string), the recovery string crossing the hood (hood-intersection), the
## source's stance swivel (foot-sliding). The owner: "do not ... fix the five
## accepted polish debts." Nothing here corrects any of them.

var player: PlayerController
var source: KayKitClipSource
var retarget: BowRetargeter
var skel: Skeleton3D
var pres: BowPresentation
var modifier: HuntressPoseModifier

## THE TIMELINE (authored seconds) -- MEASURED at build, by the D-388 rule.
var t_full: float = 0.0
var t_rel: float = 0.0
var release_len: float = 0.0
var bow_hand: String = ""
var alpha: float = 0.0                 ## the aim-line yaw offset at full draw (radians)
var nock_tau: float = 0.0              ## the authored draw time the arrow is nocked
var measured: Dictionary = {}
var ready_ok: bool = false

## THE DERIVED PLAYBACK RATE: authored release / mechanical release.
var playback_rate: float = 1.0
## TEST SEAM ONLY -- scales the ANIMATION's clock and nothing else, so the suite
## can prove the MECHANICAL release does not move with it. 1.0 in normal play.
var debug_playback_scale: float = 1.0

var _hold_from: BonePose
var _release_from: BonePose
var _leg_mask: PackedInt32Array = PackedInt32Array()

## Per-use state.
var in_action: bool = false
var use_id: String = ""
var released: bool = false
var tau: float = 0.0
var phase: String = "IDLE"
var align_w: float = 0.0
var ik_w: float = 0.0
var _snapshot: BonePose
var _cancels_at_start: int = 0
## The decorative tail: the Release clip may FINISH after the mechanical end,
## unless anything else is asked for. It roots nothing and blocks nothing.
var tail_active: bool = false
var _tail_t: float = 0.0

## Locomotion state.
var loco_state: String = "idle"
var _from: BonePose = null
var _blend_t: float = 0.0
var _blend_dur: float = 0.0
var _align_from: float = 0.0
var _ik_from: float = 0.0
var idle_t: float = 0.0
var run_t: float = 0.0

## What is SHOWN, for the overlay and the HUD -- truthfully, beside what the
## accepted controller requests.
var last_pose: BonePose
var last_globals: Array = []
var shown_clip: String = ""
var shown_time: float = 0.0
var frames: int = 0

## Diagnostics the suite reads.
var actions_begun: int = 0
var release_frames: Array[int] = []
var log_enabled: bool = false
var frame_log: Array = []

func setup(p_player: PlayerController) -> bool:
	player = p_player
	skel = RigCorpus.find_skeleton(player.visual)
	if skel == null:
		push_error("D-392: the Huntress visual has no Skeleton3D")
		return false
	source = KayKitClipSource.new()
	if not source.load_all():
		push_error("D-392: the KayKit placeholder clips did not load")
		return false
	retarget = BowRetargeter.new()
	if not retarget.setup(source, skel):
		return false
	for n in ["root", "hips", "upperleg.l", "lowerleg.l", "foot.l", "toes.l",
			"upperleg.r", "lowerleg.r", "foot.r", "toes.r"]:
		_leg_mask.append(int(source.index_of[n]))
	_measure_timeline()
	retarget.setup_ik(source.sample(HuntressConfig.CLIP_AIM_IDLE, 0.0), bow_hand)
	playback_rate = t_rel / HuntressConfig.SPLINTER_RELEASE_S
	# THE PRESENTATION IS THE PLAYER'S CHILD, NOT THE VISUAL'S: nothing it holds
	# is part of the accepted body, and every node in it is top-level.
	pres = BowPresentation.new()
	pres.name = "BowPresentation_PLACEHOLDER"
	player.add_child(pres)
	pres.build("huntress", _mesh_height(player.visual.get_node("Armature"))
		* HuntressConfig.BOW_LENGTH_PER_HEIGHT)
	_solve_presentation()
	modifier = HuntressPoseModifier.new()
	modifier.name = "HuntressPoseModifier_PLACEHOLDER"
	skel.add_child(modifier)
	modifier.influence = 1.0
	last_pose = source.sample(HuntressConfig.CLIP_BOW_IDLE, 0.0)
	ready_ok = true
	return true

# ------------------------------------------------------------- measurement --

## T_full, the release point and the bow hand, MEASURED from the source clips --
## the D-388 rule, unchanged.
func _measure_timeline() -> void:
	var draw_len := source.length_of(HuntressConfig.CLIP_DRAW)
	release_len = source.length_of(HuntressConfig.CLIP_RELEASE)
	var hr: int = source.index_of["hand.r"]
	var hl: int = source.index_of["hand.l"]
	var ge := source.globals(source.sample(HuntressConfig.CLIP_DRAW, draw_len))
	bow_hand = "l" if ge[hl].origin.z > ge[hr].origin.z else "r"
	var string_i: int = hr if bow_hand == "l" else hl
	var dt := 1.0 / 60.0
	var n := int(floor(draw_len / dt))
	var speeds: Array[float] = []
	var prev := source.globals(source.sample(HuntressConfig.CLIP_DRAW, 0.0))[string_i].origin
	for k in range(1, n + 1):
		var p := source.globals(source.sample(HuntressConfig.CLIP_DRAW, k * dt))[string_i].origin
		speeds.append(p.distance_to(prev) / dt)
		prev = p
	var first_ok := n
	for k in range(speeds.size() - 1, -1, -1):
		if speeds[k] >= HuntressConfig.FULL_DRAW_SPEED_MPS:
			break
		first_ok = k
	t_full = float(first_ok) * dt
	t_rel = t_full + HuntressConfig.HOLD_S
	_hold_from = source.sample(HuntressConfig.CLIP_DRAW, t_full)
	_release_from = source.sample(HuntressConfig.CLIP_AIM_IDLE, HuntressConfig.HOLD_S, true)

func _solve_presentation() -> void:
	var full := source.sample(HuntressConfig.CLIP_AIM_IDLE, 0.0)
	var rh := retarget.retarget(full, 0.0, 1.0)
	var g: Array[Transform3D] = rh["global"]
	var carry := g[retarget.index_of["hand_" + bow_hand]]
	var grip := retarget.grip_point(g, bow_hand)
	var nock := retarget.nock_point(g, "r" if bow_hand == "l" else "l")
	var v := grip - nock
	alpha = atan2(v.x, v.z)
	measured = pres.solve(carry, grip, nock)
	measured["alpha_deg"] = rad_to_deg(alpha)
	nock_tau = _nock_moment()

func ik_weight_at_draw(t: float) -> float:
	return BonePose.ease(t / HuntressConfig.IK_RAMP_S)

func _nock_moment() -> float:
	var best := INF
	var best_t := 0.0
	var dt := 1.0 / 60.0
	var k := 0
	while k * dt <= t_full:
		var p := source.sample(HuntressConfig.CLIP_DRAW, k * dt)
		var g: Array[Transform3D] = retarget.retarget(p, 0.0, ik_weight_at_draw(k * dt))["global"]
		var carry: Transform3D = g[retarget.index_of["hand_" + bow_hand]]
		var nock := retarget.nock_point(g, "r" if bow_hand == "l" else "l")
		var rest_c := pres.bow_transform_for(carry) * (BowPresentation.STRING_REST_LOCAL * pres.bow_scale)
		var d := nock.distance_to(rest_c)
		if d < best:
			best = d
			best_t = k * dt
		k += 1
	measured["nock_gap_m"] = best
	return best_t

## The authored time the arrow leaves, and the mechanical one it is mapped to.
func release_real_time() -> float:
	return t_rel / playback_rate

# ----------------------------------------------------------------- per use --

## Called by the Huntress runtime on the frame a Splinter Shot use BEGINS.
func begin_action(p_use_id: String) -> void:
	in_action = true
	tail_active = false
	use_id = p_use_id
	released = false
	tau = 0.0
	_snapshot = last_pose.copy()
	_cancels_at_start = player.recovery_cancels
	actions_begun += 1

func _physics_process(delta: float) -> void:
	step(delta)

## Separated so the suite can drive exact steps.
func step(delta: float) -> void:
	if not ready_ok:
		return
	frames += 1
	var c: ActionCommitment = player.commitment
	var splinter := c.active and c.label == HuntressConfig.SPLINTER_ACTION_LABEL
	var pose: BonePose
	if splinter and in_action:
		pose = _action_pose(c)
	else:
		if in_action:
			_end_action()
		pose = _rest_pose(delta)
	last_pose = pose
	_present(pose)
	if log_enabled:
		frame_log.append({"frame": Engine.get_physics_frames(), "phase": phase, "tau": tau,
			"released": released, "clip": shown_clip, "t": shown_time, "in_action": in_action,
			"ik_w": ik_w, "align_w": align_w, "arrow": pres.arrow_visible, "drawn": pres.drawn,
			"string": pres.string_centre_world, "string_rest": pres.string_rest_world,
			"arrow_xf": pres.arrow_world, "visual_yaw": player.visual.rotation.y})

func _action_pose(c: ActionCommitment) -> BonePose:
	tau = c.elapsed * playback_rate * debug_playback_scale
	# THE SAME EXPRESSION THE CONTROLLER RELEASES ON. Not a re-derivation.
	var was := released
	released = c.elapsed >= c.duration * c.release_marker
	if released and not was:
		release_frames.append(Engine.get_physics_frames())
	var pose: BonePose
	if not released:
		if tau < t_full:
			phase = "DRAW"
			shown_clip = HuntressConfig.CLIP_DRAW
			shown_time = tau
			pose = source.sample(HuntressConfig.CLIP_DRAW, tau)
			if tau < HuntressConfig.XFADE_INTO_DRAW_S and _snapshot != null:
				pose = BonePose.blend(_snapshot, pose, BonePose.ease(tau / HuntressConfig.XFADE_INTO_DRAW_S))
			align_w = BonePose.ease(tau / t_full)
			ik_w = ik_weight_at_draw(tau)
		else:
			phase = "HOLD"
			var th := tau - t_full
			shown_clip = HuntressConfig.CLIP_AIM_IDLE
			shown_time = th
			pose = source.sample(HuntressConfig.CLIP_AIM_IDLE, th, true)
			if th < HuntressConfig.XFADE_DRAW_TO_HOLD_S:
				pose = BonePose.blend(_hold_from, pose, BonePose.ease(th / HuntressConfig.XFADE_DRAW_TO_HOLD_S))
			align_w = 1.0
			ik_w = 1.0
	else:
		# THE RELEASE CLIP FROM ITS FIRST FRAME, ON THE MECHANICAL RELEASE FRAME,
		# whatever the animation clock says -- mechanical timing is authoritative.
		var tr := maxf(0.0, (c.elapsed - c.duration * c.release_marker) * playback_rate * debug_playback_scale)
		pose = _release_pose(tr)
	return pose

## The Release clip at authored time `tr` after the snap -- shared by the
## recovery and the decorative tail, so the two can never disagree.
func _release_pose(tr: float) -> BonePose:
	shown_clip = HuntressConfig.CLIP_RELEASE
	shown_time = tr
	var pose := source.sample(HuntressConfig.CLIP_RELEASE, tr)
	# THE UPPER BODY SWITCHES AT ONCE -- the snap is the whole point of the clip --
	# while the legs ease across the measured gap.
	if tr < HuntressConfig.XFADE_HOLD_TO_RELEASE_LEGS_S:
		pose = BonePose.blend(_release_from, pose,
			BonePose.ease(tr / HuntressConfig.XFADE_HOLD_TO_RELEASE_LEGS_S), _leg_mask)
	phase = "RELEASE" if tr < HuntressConfig.RELEASE_SNAP_WINDOW_S else "RECOVERY"
	var rec := clampf((tr - HuntressConfig.RELEASE_SNAP_WINDOW_S)
		/ maxf(0.001, release_len - HuntressConfig.RELEASE_SNAP_WINDOW_S), 0.0, 1.0)
	align_w = 1.0 - rec
	ik_w = 1.0 - rec
	return pose

func _end_action() -> void:
	in_action = false
	var cancelled := player.recovery_cancels > _cancels_at_start
	var tr := maxf(0.0, tau - t_rel)
	if cancelled or not released:
		# RECOVERY CANCELLED: ease from the pose on screen into locomotion.
		_start_blend_from_current(HuntressConfig.XFADE_CANCEL_TO_LOCO_S)
		tail_active = false
	else:
		# NATURAL MECHANICAL END: the Release clip may FINISH as a decorative tail.
		tail_active = true
		_tail_t = tr
	tau = 0.0

func _start_blend_from_current(dur: float) -> void:
	_from = last_pose.copy()
	_blend_t = 0.0
	_blend_dur = dur
	_align_from = align_w
	_ik_from = ik_w

## Everything that is NOT the committed action: the decorative tail, then the
## carried-bow idle or run the controller's locomotion asks for.
func _rest_pose(delta: float) -> BonePose:
	var want := "idle" if player.live_design_name == "idle" else "run"
	# THE TAIL IS DECORATIVE: any locomotion request, or any other committed
	# action, ends it at once with a blend -- it roots nothing.
	if tail_active:
		if want != "idle" or player.commitment.active:
			tail_active = false
			_start_blend_from_current(HuntressConfig.XFADE_CANCEL_TO_LOCO_S)
			loco_state = want
		else:
			_tail_t += delta * playback_rate
			if _tail_t < release_len:
				return _release_pose(_tail_t)
			# Release ends EXACTLY in Bow_Idle's first pose (D-388, measured).
			tail_active = false
			loco_state = "idle"
			idle_t = 0.0
			align_w = 0.0
			ik_w = 0.0
	if want != loco_state:
		_start_blend_from_current(HuntressConfig.XFADE_LOCO_S)
		loco_state = want
		if want == "run":
			run_t = 0.0
		else:
			idle_t = 0.0
	var pose: BonePose
	if loco_state == "idle":
		idle_t += delta
		shown_clip = HuntressConfig.CLIP_BOW_IDLE
		shown_time = fposmod(idle_t, source.length_of(shown_clip))
		pose = source.sample(HuntressConfig.CLIP_BOW_IDLE, idle_t, true)
		phase = "IDLE"
	else:
		var sp: float = player.motor.speed()
		run_t += delta * clampf(sp / ProdConfig.TOP_SPEED_MPS, 0.35, 1.6)
		shown_clip = HuntressConfig.CLIP_RUN_BOW
		shown_time = fposmod(run_t, source.length_of(shown_clip))
		pose = source.sample(HuntressConfig.CLIP_RUN_BOW, run_t, true)
		phase = "RUN"
	if _from != null and _blend_t < _blend_dur:
		var w := BonePose.ease(_blend_t / _blend_dur)
		pose = BonePose.blend(_from, pose, w)
		align_w = _align_from * (1.0 - w)
		ik_w = _ik_from * (1.0 - w)
		_blend_t += delta
	else:
		_from = null
		align_w = 0.0
		ik_w = 0.0
	return pose

# ---------------------------------------------------------------- present ---

func _present(pose: BonePose) -> void:
	var h := retarget.retarget(pose, -alpha * align_w, ik_w)
	modifier.pose = h["local"]
	last_globals = h["global"]
	var drawn := in_action and not released and tau >= nock_tau
	var vis_xf: Transform3D = player.visual.global_transform
	var g: Array[Transform3D] = h["global"]
	pres.update(vis_xf * g[retarget.index_of["hand_" + bow_hand]],
		vis_xf * retarget.nock_point(g, "r" if bow_hand == "l" else "l"), drawn, drawn)

## A bone's world transform in the pose just computed.
func bone_world(bone: String) -> Transform3D:
	var vis_xf: Transform3D = player.visual.global_transform
	return vis_xf * (last_globals[retarget.index_of[bone]] as Transform3D)

## The nocked arrow the projectile takes over from, on the release frame.
func nocked_arrow() -> Dictionary:
	return pres.nocked_arrow()

static func _mesh_height(n: Node) -> float:
	var lo := INF
	var hi := -INF
	for mi in _meshes(n):
		var a: AABB = (mi as MeshInstance3D).get_aabb()
		lo = minf(lo, a.position.y)
		hi = maxf(hi, a.position.y + a.size.y)
	return hi - lo if hi > lo else 0.0

static func _meshes(n: Node) -> Array:
	var out: Array = []
	if n is MeshInstance3D:
		out.append(n)
	for c in n.get_children():
		out.append_array(_meshes(c))
	return out
