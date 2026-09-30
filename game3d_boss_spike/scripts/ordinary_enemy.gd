class_name OrdinaryEnemy
extends CharacterBody3D

## The ORDINARY enemies for the D-368 gate: one Puglin CONTROL and the Imp
## minions.
##
## ============================================================================
## WHY THE PUGLIN CONTROL EXISTS AT ALL
##   The gate's first question is "Can this stock rig and existing animation
##   corpus produce a boss that FEELS DISTINCT FROM AN ORDINARY PUGLIN?"
##
##   Without an ordinary Puglin standing in the same arena, under the same
##   camera, on the same rig and mesh, that question could only ever be
##   ASSERTED. With one, the difference is something the owner can look at and
##   the suite can measure. The control is therefore not decoration -- it is the
##   instrument the whole first question is measured with.
## ============================================================================
##
## The control is DELIBERATELY SIMPLE, and its simplicity is the contrast:
##   * ONE attack, with a PLAIN DISC marker -- the ordinary vocabulary;
##   * clips at a SINGLE playback rate, never speed-shaped;
##   * it FLINCHES ON EVERY HIT ('Hit_Chest'), with no poise gate;
##   * ONE phase;
##   * NO silhouette attachments at all;
##   * a faster, lighter continuous yaw.
##
## It is the same unmodified Puglin mesh and the same 55-joint rig as the boss.
## Only the composition differs -- which is exactly the thing under test.

signal event_logged(kind: String, detail: String, at_frame: int)

enum Kind { PUGLIN_CONTROL, IMP_MINION }
enum State { IDLE, CHASE, WINDUP, HIT, DYING, DEAD }

var kind: Kind = Kind.PUGLIN_CONTROL
var state: State = State.IDLE
var health: float = GateConfig.CONTROL_HEALTH
var player: Node3D

# --- recorded facts the suite reads ---------------------------------------
var events: Array = []
var hit_frames: Array[int] = []
var interrupt_count: int = 0
var interrupted_during_windup: int = 0
var died_at_frame: int = -1
var death_clip_completed: bool = false
var death_clip_reported_length: float = -1.0
var death_elapsed: float = 0.0
var silhouette_attachment_names: Array[String] = []
var yaw_samples: Array[float] = []

var _dir: AnimDirector
var _visual: Node3D
var _skel: Skeleton3D
var _ap: AnimationPlayer
var _telegraph: Telegraph
var _yaw: float = 0.0
var _t: float = 0.0
var _cooldown: float = 0.0
var _speed: float = 0.0
var _turn: float = 0.0
var _scale: float = 1.0
var _clip_idle: String
var _clip_move: String
var _clip_attack: String
var _clip_hit: String

const WINDUP_S := 0.95                  # PROVISIONAL, single value -- no shaping
const DISC_RADIUS_M := 2.1              # PROVISIONAL. A plain circle.
const ATTACK_COOLDOWN_S := 2.6
const ATTACK_DAMAGE := 9.0
const AGGRO_RANGE := 18.0
const HIT_STUN_S := 0.34

func setup(corpus: AnimationLibrary, which: Kind) -> void:
	kind = which
	collision_layer = 2
	collision_mask = 1

	var src: String
	match kind:
		Kind.PUGLIN_CONTROL:
			src = RigCompat.PUGLIN
			health = GateConfig.CONTROL_HEALTH
			_speed = GateConfig.CONTROL_SPEED_MPS
			_turn = GateConfig.CONTROL_TURN_RATE_DEG
			_scale = GateConfig.CONTROL_VISUAL_SCALE
			_clip_idle = GateConfig.CLIP_CONTROL_IDLE
			_clip_move = GateConfig.CLIP_CONTROL_MOVE
			_clip_attack = GateConfig.CLIP_CONTROL_ATTACK
			_clip_hit = GateConfig.CLIP_CONTROL_HIT
		Kind.IMP_MINION:
			src = RigCompat.IMP
			health = GateConfig.IMP_HEALTH
			_speed = GateConfig.IMP_SPEED_MPS
			_turn = GateConfig.CONTROL_TURN_RATE_DEG
			_scale = 1.0
			_clip_idle = GateConfig.CLIP_IMP_IDLE
			_clip_move = GateConfig.CLIP_IMP_MOVE
			_clip_attack = GateConfig.CLIP_IMP_ATTACK
			_clip_hit = GateConfig.CLIP_IMP_HIT

	var radius: float = GateConfig.CONTROL_BODY_RADIUS if kind == Kind.PUGLIN_CONTROL \
		else GateConfig.IMP_BODY_RADIUS
	var cs := CollisionShape3D.new()
	var cyl := CylinderShape3D.new()
	cyl.radius = radius
	cyl.height = 1.5
	cs.shape = cyl
	cs.position = Vector3(0, 0.75, 0)
	add_child(cs)

	var ps := load(src) as PackedScene
	_visual = ps.instantiate()
	_visual.name = "OrdinaryVisual"
	add_child(_visual)
	_visual.scale = Vector3.ONE * _scale
	_skel = RigCompat.find_skeleton(_visual)
	_ap = RigCompat.attach_player(_visual, corpus, GateConfig.BLEND_DEFAULT_S)

	# The control keeps the mesh's OWN EMBEDDED colour variant (BaseColor_1,
	# the olive one). The boss samples the pack's variant 2 instead. Same asset,
	# same rig, a different one of the pack's own supplied variants -- and
	# nothing edited to achieve it.
	var mod: Color = GateConfig.CONTROL_ALBEDO_MOD if kind == Kind.PUGLIN_CONTROL \
		else GateConfig.IMP_ALBEDO_MOD
	RigCompat.apply_creature_treatment(_visual, mod, GateConfig.COL_RIFT_VIOLET,
		GateConfig.CONTROL_EMISSION_ENERGY, null)

	_dir = AnimDirector.new()
	_dir.setup(_ap, _skel, _visual)
	_dir.play("idle", _clip_idle, 1.0)

	# NO SILHOUETTE ATTACHMENTS. Deliberate, and asserted: the boss-vs-control
	# silhouette check needs this list to be provably empty.
	silhouette_attachment_names = []

	var rng := RandomNumberGenerator.new()
	rng.seed = hash(name)
	_cooldown = rng.randf_range(0.0, ATTACK_COOLDOWN_S)

func display_name() -> String:
	return GateConfig.CONTROL_DISPLAY_NAME if kind == Kind.PUGLIN_CONTROL \
		else "IMP MINION — ordinary"

# ------------------------------------------------------------------ damage ---

## THE CONTRAST WITH THE BOSS, IN ONE FUNCTION.
##
## There is no poise gate here. EVERY hit interrupts, every time. The boss
## takes the same hit, records procedural recoil and keeps swinging. That
## difference is what the suite measures in BOTH directions -- the boss proved
## not interrupted, the control proved interrupted, by the same damage value.
func take_hit(dmg: float, _poise_dmg: float, from: Vector3) -> void:
	if state == State.DEAD or state == State.DYING:
		return
	hit_frames.append(Engine.get_physics_frames())
	health -= dmg
	_dir.add_recoil(from, global_transform, GateConfig.RECOIL_IMPULSE_DEG * 0.6)
	if health <= 0.0:
		_begin_death()
		return
	if state == State.WINDUP:
		interrupted_during_windup += 1
		_clear_telegraph()
	interrupt_count += 1
	state = State.HIT
	_t = HIT_STUN_S
	_dir.play("hit (flinch — EVERY hit)", _clip_hit, 1.0,
		GateConfig.BLEND_STAGGER_S, true)
	_log("hit", "dmg %.0f -> flinch, clip %s (%s)"
		% [dmg, _dir.live_clip(), _dir.live_library()])

func _begin_death() -> void:
	state = State.DYING
	died_at_frame = Engine.get_physics_frames()
	death_elapsed = 0.0
	_clear_telegraph()
	collision_layer = 0
	collision_mask = 0
	# The same truthful source clip the boss uses. UAL1 'Death01' is real, so
	# nothing here is faked either.
	var clip: String = GateConfig.CLIP_CONTROL_DEATH if kind == Kind.PUGLIN_CONTROL \
		else GateConfig.CLIP_IMP_DEATH
	_dir.play("death", clip, 1.0, 0.12, true)
	death_clip_reported_length = _dir.live_length()
	_log("death_begin", "clip %s (%s) length %.4f s"
		% [_dir.live_clip(), _dir.live_library(), death_clip_reported_length])

# ----------------------------------------------------------------- process ---

func _physics_process(delta: float) -> void:
	if state == State.DEAD:
		return
	yaw_samples.append(_yaw)

	if state == State.DYING:
		death_elapsed += delta
		var l := death_clip_reported_length
		if l > 0.0 and death_elapsed >= l and not death_clip_completed:
			death_clip_completed = true
			_log("death_complete", "'%s' ran its full %.4f s" % [_dir.live_clip(), l])
		if death_clip_completed and death_elapsed >= l + 0.3:
			state = State.DEAD
			visible = false
		_dir.apply_visual_offsets(delta, _scale)
		return

	if state == State.HIT:
		_t -= delta
		if _t <= 0.0:
			state = State.IDLE
		_dir.apply_visual_offsets(delta, _scale)
		return

	if player == null:
		_dir.play("idle", _clip_idle, 1.0)
		_dir.apply_visual_offsets(delta, _scale)
		return

	var to := player.global_position - global_position
	to.y = 0.0
	var dist := to.length()
	_cooldown = maxf(0.0, _cooldown - delta)

	if dist > AGGRO_RANGE:
		state = State.IDLE
		_dir.play("idle", _clip_idle, 1.0)
		velocity = Vector3.ZERO
		_clear_telegraph()
	elif dist > DISC_RADIUS_M * 0.85:
		state = State.CHASE
		_dir.play("chase", _clip_move, 1.0)
		velocity = to.normalized() * _speed
		_clear_telegraph()
		move_and_slide()
	elif _cooldown > 0.0:
		state = State.IDLE
		_dir.play("idle", _clip_idle, 1.0)
		velocity = Vector3.ZERO
		_clear_telegraph()
	else:
		state = State.WINDUP
		velocity = Vector3.ZERO
		_t += delta
		# A SINGLE playback rate. No speed shaping, no composed anticipation.
		_dir.play("windup", _clip_attack, 1.0)
		if _telegraph == null:
			_telegraph = Telegraph.make_disc(DISC_RADIUS_M)
			add_child(_telegraph)
		_telegraph.set_progress(clampf(_t / WINDUP_S, 0.0, 1.0))
		if _t >= WINDUP_S:
			_t = 0.0
			_cooldown = ATTACK_COOLDOWN_S
			if _telegraph != null and player != null:
				if _telegraph.contains(player.global_position) \
						and player.has_method("take_boss_hit"):
					player.call("take_boss_hit", ATTACK_DAMAGE, global_position)
			_clear_telegraph()
			_log("attack", "%s disc r=%.2f" % [display_name(), DISC_RADIUS_M])

	# Continuous yaw here too -- lighter and faster than the boss's.
	if dist > 0.05:
		var want := atan2(to.x, to.z)
		var max_step := deg_to_rad(_turn) * delta
		var diff := wrapf(want - _yaw, -PI, PI)
		_yaw += clampf(diff, -max_step, max_step)
		rotation.y = _yaw
	_dir.set_lean_from_velocity(velocity, global_transform, _speed, delta)
	_dir.apply_visual_offsets(delta, _scale)

# --------------------------------------------------------------- helpers -----

func _clear_telegraph() -> void:
	if _telegraph != null and is_instance_valid(_telegraph):
		_telegraph.queue_free()
	_telegraph = null

func telegraph() -> Telegraph:
	return _telegraph

func director() -> AnimDirector:
	return _dir

func visual() -> Node3D:
	return _visual

func skeleton() -> Skeleton3D:
	return _skel

func attack_count() -> int:
	return 1

func shape_classes() -> Array[String]:
	return ["DISC"]

func phase_count() -> int:
	return 1

func state_name() -> String:
	match state:
		State.IDLE: return "IDLE"
		State.CHASE: return "CHASE"
		State.WINDUP: return "WINDUP"
		State.HIT: return "HIT"
		State.DYING: return "DYING"
		State.DEAD: return "DEAD"
	return "?"

func _log(kind_s: String, detail: String) -> void:
	var f := Engine.get_physics_frames()
	events.append([kind_s, detail, f])
	event_logged.emit(kind_s, detail, f)
