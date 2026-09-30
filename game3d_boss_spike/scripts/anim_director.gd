class_name AnimDirector
extends RefCounted

## THE COMPOSITION LAYER for the D-368 gate.
##
## ============================================================================
## THE OWNER'S PERMITTED TOOLKIT, VERBATIM:
##   "Existing clips combined with timing, blending, playback-speed changes,
##    procedural tracking/recoil/leaning, VFX, lighting and sound hooks."
## ============================================================================
##
## This class is that toolkit, and it is the honest answer to what the gate
## actually proves. It authors NO keyframes. Every pose it produces comes from a
## stock clip; what it contributes is WHEN, HOW FAST, HOW BLENDED, and what
## PROCEDURAL OFFSET rides on top.
##
## WHY THIS IS NOT ANIMATION AUTHORING, stated plainly so the report cannot
## drift into claiming otherwise: a procedural offset is a runtime transform
## driven by live state. It has no keys, no curves, no authored timing, and it
## cannot be exported as an animation. It CANNOT substitute for a signature
## move, and the gate's `COMMISSION_REQUIRED` list says exactly which moves it
## therefore cannot supply.
##
## It also keeps the DESIGN NAME and the SOURCE CLIP NAME strictly separate, so
## the debug overlay can show both and a composed attack is never mistaken for
## an authored clip.

## What the design calls the current behaviour, e.g. "A2 Slam — windup".
var design_state: String = "—"
## The stock clip actually playing, e.g. "TreeChopping". NEVER a design name.
var source_clip: String = ""
## Which library it came from. DERIVED, via RigCompat.attribute().
var source_library: String = ""
var requested_speed: float = 1.0

var _ap: AnimationPlayer
var _skel: Skeleton3D
var _visual: Node3D

# --- procedural layer state -------------------------------------------------
var track_enabled: bool = true
var _track_yaw: float = 0.0            # radians, upper-body tracking
var _recoil_deg: float = 0.0           # decaying recoil magnitude
var _recoil_axis: Vector3 = Vector3.RIGHT
var _recoil_shove: Vector3 = Vector3.ZERO
var _lean: Vector2 = Vector2.ZERO      # x = pitch, y = roll, degrees
var _track_bone_idx: int = -1
var _spine_rest: Transform3D
var _have_spine_rest: bool = false

func setup(ap: AnimationPlayer, skel: Skeleton3D, visual: Node3D) -> void:
	_ap = ap
	_skel = skel
	_visual = visual
	if _skel != null:
		_track_bone_idx = _skel.find_bone(RigCompat.BONE_UPPER_SPINE)
		if _track_bone_idx >= 0:
			_spine_rest = _skel.get_bone_pose(_track_bone_idx)
			_have_spine_rest = true

# --------------------------------------------------------- clip direction ----

## Plays a stock clip under a design name, at a chosen playback rate and blend.
##
## `speed` is the whole point of several of the boss's attacks: the same clip
## played at 0.30x reads as a slow, weighty ANTICIPATION and at 1.55x as a fast
## RELEASE. That shaping is composition, not authoring.
func play(design: String, clip: String, speed: float = 1.0,
		blend: float = -1.0, restart: bool = false) -> bool:
	design_state = design
	requested_speed = speed
	var ok := RigCompat.play_guarded(_ap, clip, speed, blend, restart)
	if ok:
		source_clip = clip
		source_library = RigCompat.attribute(clip)
	return ok

## Holds a clip at a fixed normalized position -- used to freeze a pose at the
## top of an anticipation so the silhouette reads before the strike lands.
func hold_at(design: String, clip: String, normalized: float) -> bool:
	design_state = design
	requested_speed = 0.0
	if _ap == null or not _ap.has_animation(clip):
		return RigCompat.play_guarded(_ap, clip, 0.0)
	if _ap.current_animation != clip:
		_ap.play(clip, GateConfig.BLEND_ATTACK_S, 0.0)
	source_clip = clip
	source_library = RigCompat.attribute(clip)
	var a := _ap.get_animation(clip)
	_ap.seek(a.length * clampf(normalized, 0.0, 1.0), true)
	_ap.speed_scale = 0.0
	return true

func set_speed(speed: float) -> void:
	requested_speed = speed
	if _ap != null:
		_ap.speed_scale = speed

func stop_clip() -> void:
	if _ap != null:
		_ap.stop()
	source_clip = ""
	source_library = ""

# ------------------------------------------------------------- live facts ----

## The clip ACTUALLY playing, read from the AnimationPlayer rather than from
## this object's own bookkeeping. The overlay uses THIS, so the readout cannot
## drift from reality -- reporting our own intention would prove only that we
## intended it.
func live_clip() -> String:
	if _ap == null:
		return ""
	return _ap.current_animation

func live_library() -> String:
	return RigCompat.attribute(live_clip())

func live_position() -> float:
	if _ap == null:
		return 0.0
	return _ap.current_animation_position

func live_length() -> float:
	if _ap == null or _ap.current_animation == "":
		return 0.0
	return _ap.current_animation_length

func live_speed() -> float:
	if _ap == null:
		return 0.0
	return _ap.speed_scale

## Has the clip passed a normalized release marker?
##
## MECHANICAL TIMING IS AUTHORITATIVE OVER ANIMATION TIMING (CLAUDE.md 5), so
## the gate never uses this to DECIDE when damage lands. The attack's own timer
## decides that. This exists only to let the visual be checked against the
## mechanical moment, and the suite proves the marker still governs when the
## clip is played at a different speed.
func past_normalized(marker: float) -> bool:
	var l := live_length()
	if l <= 0.0:
		return false
	return (live_position() / l) >= marker

# ------------------------------------------------- procedural layers --------

## PROCEDURAL TRACKING. Aims the upper spine at a target within a stated limit,
## on top of whatever clip is playing. Gives the boss the sense of watching the
## player during a long channel, which no stock clip can do.
func set_track_target(world_target: Vector3, actor_global: Transform3D,
		delta: float) -> void:
	if _skel == null or _track_bone_idx < 0 or not _have_spine_rest:
		return
	var want := 0.0
	if track_enabled:
		var local := actor_global.affine_inverse() * world_target
		local.y = 0.0
		if local.length() > 0.05:
			want = clampf(atan2(local.x, -local.z),
				-deg_to_rad(GateConfig.TRACK_MAX_YAW_DEG),
				deg_to_rad(GateConfig.TRACK_MAX_YAW_DEG))
	_track_yaw = lerp_angle(_track_yaw, want,
		clampf(delta * GateConfig.TRACK_RATE, 0.0, 1.0))
	# Applied as an OFFSET ON THE REST POSE of one bone, so the clip's own
	# animation of that bone is preserved rather than overwritten.
	var t := _spine_rest
	t.basis = t.basis * Basis(Vector3.UP, _track_yaw)
	_skel.set_bone_pose_rotation(_track_bone_idx, t.basis.get_rotation_quaternion())

func tracking_yaw_deg() -> float:
	return rad_to_deg(_track_yaw)

## PROCEDURAL RECOIL. A hit that must be FELT without interrupting the clip.
## This is how the boss acknowledges every hit while still refusing to be
## staggered by most of them -- a distinction no single stock clip expresses.
func add_recoil(from_world: Vector3, actor_global: Transform3D,
		magnitude_deg: float) -> void:
	var local := actor_global.affine_inverse() * from_world
	local.y = 0.0
	if local.length() < 0.001:
		local = Vector3.BACK
	local = local.normalized()
	# Rotate AWAY from the impact: the axis is perpendicular to the incoming
	# direction, on the ground plane.
	_recoil_axis = Vector3(local.z, 0.0, -local.x).normalized()
	if _recoil_axis.length() < 0.001:
		_recoil_axis = Vector3.RIGHT
	_recoil_deg = maxf(_recoil_deg, magnitude_deg)
	_recoil_shove = -local * GateConfig.RECOIL_SHOVE_M

func recoil_deg() -> float:
	return _recoil_deg

## PROCEDURAL LEANING. Tilts into movement so locomotion has weight the
## 'Walk_Carry' clip does not supply on its own.
func set_lean_from_velocity(velocity: Vector3, actor_global: Transform3D,
		top_speed: float, delta: float) -> void:
	var want := Vector2.ZERO
	if top_speed > 0.0 and velocity.length() > 0.05:
		var local := actor_global.basis.inverse() * velocity
		var f: float = clampf(-local.z / top_speed, -1.0, 1.0)
		var r: float = clampf(local.x / top_speed, -1.0, 1.0)
		want = Vector2(f * GateConfig.LEAN_MAX_DEG, -r * GateConfig.LEAN_MAX_DEG)
	_lean = _lean.lerp(want, clampf(delta * GateConfig.LEAN_RATE, 0.0, 1.0))

func lean_deg() -> Vector2:
	return _lean

## Applies the accumulated procedural offsets to the visual root and decays
## the recoil. Called once per physics frame, AFTER the clip has posed the rig.
##
## PRESENTATION NEVER SITS INSIDE A MECHANICAL CALL STACK (CLAUDE.md 6): this
## only writes to the VISUAL node. It never moves the actor's ground point, and
## nothing mechanical reads it.
func apply_visual_offsets(delta: float, base_scale: float) -> void:
	if _visual == null:
		return
	_recoil_deg = maxf(0.0, _recoil_deg - _recoil_deg
		* clampf(delta * GateConfig.RECOIL_DECAY, 0.0, 1.0) - delta * 0.6)
	_recoil_shove = _recoil_shove.lerp(Vector3.ZERO,
		clampf(delta * GateConfig.RECOIL_DECAY, 0.0, 1.0))
	var b := Basis()
	b = b.rotated(Vector3.RIGHT, deg_to_rad(_lean.x))
	b = b.rotated(Vector3.FORWARD, deg_to_rad(_lean.y))
	if _recoil_deg > 0.01:
		b = b.rotated(_recoil_axis, deg_to_rad(_recoil_deg))
	_visual.transform.basis = b.scaled(Vector3.ONE * base_scale)
	_visual.position = _recoil_shove
