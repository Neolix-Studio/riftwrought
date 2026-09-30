class_name HuntressSpike
extends CharacterBody3D

## HUNTRESS PLACEHOLDER — D-366 feasibility spike.
##
## ============================================================================
## THIS IS NOT THE FINAL HUNTRESS AND NOT FINAL ART.
## ============================================================================
## It is a third-party Quaternius placeholder assembled to test rig, outfit and
## animation compatibility. The Huntress remains ART ONLY: NO canonical class
## specification exists, none is written here, and one remains a P2
## prerequisite. Accepting this placeholder would promote NO class mechanic.
##
## The actor's POSITION IS ITS GROUND POINT (the feet), exactly as the project's
## medium-independent rule requires. Nothing reads the visual's position, and
## visual height is never a gameplay coordinate.

signal fired(at: Vector3)

var cam: IsoCamera
var arrow_parent: Node3D

var _anim: AnimationPlayer
var _visual: Node3D
var _rig: Dictionary
var _cooldown: float = 0.0
var _attack_t: float = -1.0
var _pending_shot: bool = false
var aim_point: Vector3 = Vector3.FORWARD
var aim_dir: Vector3 = Vector3.FORWARD

# Diagnostics the verification suite reads.
var shots_fired: int = 0
var last_move_input: Vector2 = Vector2.ZERO

func setup(lib: AnimationLibrary, use_eyes: bool) -> void:
	collision_layer = 1
	collision_mask = 2
	var cs := CollisionShape3D.new()
	var cyl := CylinderShape3D.new()
	cyl.radius = SpikeConfig.PLAYER_BODY_RADIUS
	cyl.height = 1.7
	cs.shape = cyl
	cs.position = Vector3(0, 0.85, 0)
	add_child(cs)

	_rig = RigAssembly.build_huntress_visual(lib, use_eyes)
	_visual = _rig["root"]
	_anim = _rig["anim"]
	add_child(_visual)

	# THE HUNTRESS PLACEHOLDER KEEPS THE PACK'S OWN IMPORTED PBR MATERIALS
	# (T_Ranger BaseColor / Normal / ORM, and the base character's skin maps).
	# Overriding them with flat colours would discard the very thing this spike
	# exists to evaluate. NO source mesh and NO source material is edited; the
	# environment around her is what recedes, by its own material overrides.
	# A soft, shadowless read-light travelling with the hero, so the player is
	# never lost against a moody environment. This is the "identity concentrates
	# in characters" clause of the D-366 target expressed in lighting.
	# PROVISIONAL.
	var key := OmniLight3D.new()
	key.name = "HeroReadLight"
	key.light_color = Color(0.92, 0.94, 1.0)
	key.light_energy = 2.2
	key.omni_range = 4.2
	key.omni_attenuation = 1.8
	key.shadow_enabled = false
	key.position = Vector3(0.0, 2.3, 0.8)
	add_child(key)

	_play(SpikeConfig.CLIP_PLAYER_IDLE)

## Solves the bow's local offset ONCE against the LIVE animated pose, so the
## grip reads correctly in the idle stance and then RIDES the bone through every
## clip. The mesh's long axis is local +Y and its belly local +X (MEASURED from
## its AABB); the target is: long axis up, belly forward in the character's own
## frame. Nothing here is eyeballed and nothing is re-solved per frame -- a
## per-frame re-solve would hide exactly the drift this spike must be able to
## detect.
func align_bow() -> void:
	var att := bow_attachment()
	var bw := bow_node()
	if att == null or bw == null or _visual == null:
		return
	# Columns are assigned EXPLICITLY. The Basis(a, b, c) constructor's argument
	# order was measured to transpose here, which put the bow's long axis along
	# world -X instead of up. Assigning .x/.y/.z (the columns) removes the
	# ambiguity entirely rather than encoding a guess about the constructor.
	# MEASURED, not reasoned. Hand-building the basis from axis vectors kept
	# failing because Basis.x/.y/.z are ROWS: setting .y and reading .y back
	# agreed with each other while the bow actually lay along world -X. That is
	# the project's own rule in miniature -- a check that reads the value it
	# just wrote proves the value was written, not that it is right -- and the
	# rendered picture, not the number, is what caught it.
	#
	# The offset below was found by sweeping candidate rotations and measuring
	# the bow's WORLD-SPACE AABB each time, then taking the one whose vertical
	# extent was greatest. At this offset the bow measures 1.196 m tall,
	# 0.091 m wide and 0.327 m deep in world space: upright, as a carried bow
	# should be. The mesh is authored upright already, so the offset is small.
	var want := Basis.from_euler(Vector3(0.0, 0.0, PI)) \
		* Basis.from_euler(Vector3(deg_to_rad(14.0), 0.0, 0.0))
	var want_global := _visual.global_transform.basis.orthonormalized() * want
	# Assign the GLOBAL transform directly and let Godot derive the local one.
	# Deriving it by hand from the parent's inverse basis produced a measurably
	# wrong result, and the picture agreed with the number -- so this uses the
	# unambiguous API instead of encoding a guess. Once set, the local transform
	# is fixed and the bow RIDES the bone from then on.
	bw.global_transform = Transform3D(
		want_global.scaled(Vector3.ONE * SpikeConfig.WEAPON_SCALE),
		att.global_transform.origin)
	bow_local_at_align = bw.transform
	bow_aligned = true

var bow_aligned: bool = false
var bow_local_at_align: Transform3D = Transform3D.IDENTITY
var _align_frames: int = 0

func bow_node() -> Node3D:
	return _rig.get("bow", null)

func bow_attachment() -> BoneAttachment3D:
	return _rig.get("bow_attachment", null)

func skeleton() -> Skeleton3D:
	return _rig.get("skeleton", null)

func visual() -> Node3D:
	return _visual

func _play(clip: String) -> void:
	RigAssembly.play_guarded(_anim, clip)

## MOVEMENT: keyboard (WASD) and controller (left stick) map to the SAME action
## names, so both drive one code path. Movement is camera-relative on the
## ground plane and is COMPLETELY INDEPENDENT of aim.
func read_move_input() -> Vector2:
	return Input.get_vector("move_left", "move_right", "move_up", "move_down")

func _physics_process(delta: float) -> void:
	if not bow_aligned:
		_align_frames += 1
		if _align_frames >= 3:      # let the idle clip actually pose the arm
			align_bow()
	_cooldown = maxf(0.0, _cooldown - delta)

	var raw := read_move_input()
	last_move_input = raw
	var wish := Vector3.ZERO
	if raw.length() > 0.001 and cam != null:
		# Screen-relative on the ground plane, using the LOCKED camera basis.
		var b := cam.locked_basis()
		var fwd := -b.z; fwd.y = 0.0; fwd = fwd.normalized()
		var right := b.x; right.y = 0.0; right = right.normalized()
		wish = (right * raw.x + fwd * -raw.y).limit_length(1.0)

	var target_v := wish * SpikeConfig.TOP_SPEED_MPS
	var rate := SpikeConfig.ACCEL_MPS2 if wish.length() > 0.001 else SpikeConfig.DECEL_MPS2
	velocity = velocity.move_toward(target_v, rate * delta)
	velocity.y = 0.0
	move_and_slide()

	# AIM: sampled from the cursor, on its own, every frame. Changing aim does
	# not move the actor; moving the actor does not change aim.
	if cam != null:
		aim_point = cam.cursor_ground_point(global_position + aim_dir * 5.0)
		var d := aim_point - global_position
		d.y = 0.0
		if d.length() > 0.08:
			aim_dir = d.normalized()

	# The body faces where it AIMS, which is what an ARPG ranged character does.
	if _visual != null and aim_dir.length() > 0.001:
		var want := atan2(aim_dir.x, aim_dir.z)
		var max_step := deg_to_rad(SpikeConfig.TURN_RATE_DEG) * delta
		var cur := _visual.rotation.y
		var diff := wrapf(want - cur, -PI, PI)
		_visual.rotation.y = cur + clampf(diff, -max_step, max_step)

	# Locomotion clip
	if _attack_t < 0.0:
		if velocity.length() > 0.35:
			_play(SpikeConfig.CLIP_PLAYER_MOVE)
		else:
			_play(SpikeConfig.CLIP_PLAYER_IDLE)

	# MECHANICAL TIMING IS AUTHORITATIVE OVER ANIMATION TIMING.
	# The arrow leaves at FIRE_RELEASE_MARKER of the action's own normalised
	# time, NOT when the borrowed clip happens to look right.
	if _attack_t >= 0.0:
		_attack_t += delta
		var dur := SpikeConfig.FIRE_COOLDOWN_S
		if _pending_shot and _attack_t >= dur * SpikeConfig.FIRE_RELEASE_MARKER:
			_pending_shot = false
			_release_arrow()
		if _attack_t >= dur:
			_attack_t = -1.0

	if Input.is_action_pressed("spike_fire") and _cooldown <= 0.0:
		_begin_attack()

func _begin_attack() -> void:
	_cooldown = SpikeConfig.FIRE_COOLDOWN_S
	_attack_t = 0.0
	_pending_shot = true
	# PLACEHOLDER CLIP. UAL2 Standard has NO bow animation; this is a THROW.
	_play(SpikeConfig.CLIP_PLAYER_ATTACK)

func _release_arrow() -> void:
	if arrow_parent == null:
		return
	var a := ArrowSpike.new()
	a.direction = aim_dir
	var mi := MeshInstance3D.new()
	mi.mesh = load(RigAssembly.ARROW)
	mi.scale = Vector3.ONE * SpikeConfig.WEAPON_SCALE
	RigAssembly.tint_all(mi, [
		{"match": "LightWood", "color": Color(0.22, 0.16, 0.10), "rough": 0.7},
		{"match": "Steel", "color": Color(0.55, 0.40, 0.85), "rough": 0.35,
		 "emission": SpikeConfig.COL_RIFT_VIOLET, "energy": 2.6},
		{"match": "LightSteel", "color": Color(0.62, 0.48, 0.92), "rough": 0.3,
		 "emission": SpikeConfig.COL_RIFT_VIOLET, "energy": 2.2},
		{"match": "Red", "color": Color(0.40, 0.22, 0.62), "rough": 0.6,
		 "emission": SpikeConfig.COL_RIFT_VIOLET, "energy": 1.2},
	])
	a.add_child(mi)

	# A restrained violet trail light. Bounded on purpose.
	var l := OmniLight3D.new()
	l.light_color = SpikeConfig.COL_RIFT_VIOLET
	l.light_energy = 1.7
	l.omni_range = 3.2
	l.shadow_enabled = false
	a.add_child(l)

	arrow_parent.add_child(a)
	var muzzle := global_position + Vector3(0, 1.15, 0) + aim_dir * 0.45
	a.global_position = muzzle
	# The arrow mesh's long axis is +Z, so basis-look it down the aim direction.
	mi.look_at_from_position(Vector3.ZERO, aim_dir, Vector3.UP)
	mi.position = Vector3.ZERO
	shots_fired += 1
	fired.emit(muzzle)
