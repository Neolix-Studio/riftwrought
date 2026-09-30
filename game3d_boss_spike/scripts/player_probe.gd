class_name PlayerProbe
extends CharacterBody3D

## The PLAYER PROBE for the D-368 gate.
##
## ============================================================================
## THIS IS NOT THE HUNTRESS, AND IT IS NOT A CHARACTER.
##   It is a placeholder body whose only job is to occupy the arena, be
##   somewhere for the boss to aim at, and deliver the one diagnostic
##   projectile so the boss's reactions can be observed.
##
##   It writes NO canonical Huntress class specification -- that remains a P2
##   prerequisite (CLAUDE.md 3.5) and this gate does not touch it.
## ============================================================================
##
## TOP SPEED: 3.889 m/s, used as D-367's NEXT PROVISIONAL STARTING CANDIDATE and
## nothing more. D-367 is explicit that it is "not a value, not a target and not
## a lock", and this gate does not tune it, settle it or promote it.

signal fired(at: Vector3)
signal took_damage(amount: float, from: Vector3)

const OUTFIT_IS_PLACEHOLDER := true

var aim_dir: Vector3 = Vector3.FORWARD
var damage_taken: float = 0.0
var hits_taken: int = 0
var shots_fired: int = 0

## Test seam: lets the suite aim deterministically without a mouse. MUST be
## null in normal play, and the suite asserts that it is.
var debug_aim_override = null

var targets: Array = []
var arena: Node3D

var _dir: AnimDirector
var _visual: Node3D
var _skel: Skeleton3D
var _ap: AnimationPlayer
var _cooldown: float = 0.0
var _yaw: float = 0.0
var _bow_att: BoneAttachment3D

func setup(corpus: AnimationLibrary, arena_root: Node3D) -> void:
	arena = arena_root
	collision_layer = 1
	collision_mask = 2

	var cs := CollisionShape3D.new()
	var cap := CapsuleShape3D.new()
	cap.radius = GateConfig.PLAYER_BODY_RADIUS
	cap.height = 1.7
	cs.shape = cap
	cs.position = Vector3(0, 0.85, 0)
	add_child(cs)

	# The outfit is self-contained (hood, body, arms, legs, feet, pauldrons), so
	# THE BASE BODY IS NEVER INSTANTIATED -- which is how the pack's own "only
	# the head is required / the full body will clip" instruction is honoured
	# with the free-tier files, exactly as the D-366 spike recorded. The
	# Universal Base Characters pack is not imported into this gate at all.
	var ps := load(RigCompat.OUTFIT_RANGER) as PackedScene
	_visual = ps.instantiate()
	_visual.name = "PlayerPlaceholderVisual"
	add_child(_visual)
	_skel = RigCompat.find_skeleton(_visual)
	_ap = RigCompat.attach_player(_visual, corpus, GateConfig.BLEND_DEFAULT_S)

	if _skel != null:
		var bow_mesh: Mesh = load(RigCompat.BOW)
		_bow_att = BoneAttachment3D.new()
		_bow_att.name = "BowHand"
		_skel.add_child(_bow_att)
		# A right-handed archer holds the bow LEFT and draws right.
		_bow_att.bone_name = RigCompat.BONE_BOW_HAND
		var bow := MeshInstance3D.new()
		bow.name = "Bow_Wooden"
		bow.mesh = bow_mesh
		var fit := RigCompat.prop_scale_for(bow_mesh, 1.20)
		bow.scale = Vector3.ONE * float(fit["scale"])
		bow.rotation_degrees = Vector3(0, 0, 90)
		_bow_att.add_child(bow)
		RigCompat.tint_all(bow, [
			{"match": "Wood", "color": GateConfig.COL_WOOD, "rough": 0.92},
			{"match": "Metal", "color": GateConfig.COL_METAL, "rough": 0.45, "metal": 0.6},
		], GateConfig.COL_WOOD)

	_dir = AnimDirector.new()
	_dir.setup(_ap, _skel, _visual)
	_dir.track_enabled = false
	_dir.play("idle", GateConfig.CLIP_PLAYER_IDLE, 1.0)

func take_boss_hit(amount: float, from: Vector3) -> void:
	damage_taken += amount
	hits_taken += 1
	took_damage.emit(amount, from)
	_dir.add_recoil(from, global_transform, GateConfig.RECOIL_IMPULSE_DEG)

func _physics_process(delta: float) -> void:
	var input := Vector2.ZERO
	if not Engine.is_editor_hint():
		input = Input.get_vector("move_left", "move_right", "move_up", "move_down")

	# Camera-relative movement, so "up" means up-screen at the fixed isometric
	# yaw rather than up-world.
	var cam_yaw := deg_to_rad(GateConfig.CAM_YAW_DEG)
	var basis := Basis(Vector3.UP, cam_yaw)
	var wish := basis * Vector3(input.x, 0.0, input.y)
	if wish.length() > 1.0:
		wish = wish.normalized()

	var target_v := wish * GateConfig.TOP_SPEED_MPS
	var rate: float = GateConfig.ACCEL_MPS2 if wish.length() > 0.01 else GateConfig.DECEL_MPS2
	velocity = velocity.move_toward(target_v, rate * delta)
	velocity.y = 0.0
	move_and_slide()

	# Aim is INDEPENDENT of movement.
	var want_aim := aim_dir
	if debug_aim_override != null:
		want_aim = (debug_aim_override as Vector3)
	want_aim.y = 0.0
	if want_aim.length() > 0.01:
		aim_dir = want_aim.normalized()

	# Continuous yaw toward the aim direction, rate-limited.
	var want := atan2(aim_dir.x, aim_dir.z)
	var max_step := deg_to_rad(GateConfig.PLAYER_TURN_RATE_DEG) * delta
	var diff := wrapf(want - _yaw, -PI, PI)
	_yaw += clampf(diff, -max_step, max_step)
	rotation.y = _yaw

	_cooldown = maxf(0.0, _cooldown - delta)
	if velocity.length() > 0.15:
		_dir.play("move", GateConfig.CLIP_PLAYER_MOVE, 1.0)
	elif _dir.live_clip() != GateConfig.CLIP_PLAYER_ATTACK:
		_dir.play("idle", GateConfig.CLIP_PLAYER_IDLE, 1.0)

	_dir.set_lean_from_velocity(velocity, global_transform,
		GateConfig.TOP_SPEED_MPS, delta)
	_dir.apply_visual_offsets(delta, 1.0)

func fire() -> bool:
	if _cooldown > 0.0:
		return false
	_cooldown = GateConfig.FIRE_COOLDOWN_S
	shots_fired += 1
	# 'OverhandThrow' is a THROW, not a bow draw. It is named truthfully
	# everywhere and labelled a placeholder in the runtime -- the D-366 spike
	# measured that no bow/archery clip exists in either library, and UAL1 does
	# not add one. The gate does not pretend otherwise.
	_dir.play("attack (PLACEHOLDER — a throw, not a bow draw)",
		GateConfig.CLIP_PLAYER_ATTACK, 1.0, GateConfig.BLEND_ATTACK_S, true)
	var a := ArrowProbe.new()
	var host: Node = arena if arena != null else get_parent()
	host.add_child(a)
	a.global_position = global_position + Vector3(0, 1.15, 0) + aim_dir * 0.7
	a.setup(aim_dir, targets)
	fired.emit(a.global_position)
	return true

func director() -> AnimDirector:
	return _dir

func visual() -> Node3D:
	return _visual

func skeleton() -> Skeleton3D:
	return _skel

func yaw_deg() -> float:
	return rad_to_deg(_yaw)
