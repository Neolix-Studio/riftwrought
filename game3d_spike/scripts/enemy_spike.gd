class_name EnemySpike
extends CharacterBody3D

## ONE enemy type for the D-366 feasibility spike: the Quaternius Bestiary Imp.
##
## MEASURED: Imp.glb contains ZERO animations of its own. Every clip below comes
## from UAL2 and is named TRUTHFULLY -- nothing is renamed to imply it is
## something it is not.
##
## STATE COVERAGE, "as far as supplied animations allow":
##   idle  -> UAL2 'Zombie_Idle_Loop'      (supplied)
##   chase -> UAL2 'Zombie_Walk_Fwd_Loop'  (supplied)
##   hit   -> UAL2 'Hit_Knockback'         (supplied -- it IS a hit reaction)
##   death -> NO DEATH CLIP EXISTS IN UAL2 STANDARD. 0 of 43 clips match.
##            Death is therefore a CODE-DRIVEN topple-and-sink, and is reported
##            as a DEFERRED animation state rather than faked with another clip.

signal event_logged(kind: String, at: Vector3)

enum State { IDLE, CHASE, WINDUP, HIT, DYING, DEAD }

var state: State = State.IDLE
var health: float = SpikeConfig.ENEMY_HEALTH
var passive: bool = false          # density-mode enemies do not act
var player: Node3D
var telegraph: Node3D
var loot_scene_owner: Node3D

var _anim: AnimationPlayer
var _visual: Node3D
var _hit_timer: float = 0.0
var _windup: float = 0.0
var _die_t: float = 0.0
var _atk_cd: float = 0.0
var _rift_light: OmniLight3D

const WINDUP_TIME := 1.15          # PROVISIONAL
const ATTACK_COOLDOWN := 2.9       # PROVISIONAL -- keeps telegraphs staggered
const ATTACK_RANGE := 2.2          # PROVISIONAL
const AGGRO_RANGE := 14.0          # PROVISIONAL
const HIT_STUN := 0.38             # PROVISIONAL
const DIE_TIME := 1.25             # PROVISIONAL

# Truthful per-state records the verification suite reads.
var took_hit_at_frame: int = -1
var died_at_frame: int = -1
var loot_spawned_at_frame: int = -1

func setup(lib: AnimationLibrary) -> void:
	collision_layer = 2
	collision_mask = 1
	var cs := CollisionShape3D.new()
	var cyl := CylinderShape3D.new()
	cyl.radius = SpikeConfig.ENEMY_BODY_RADIUS
	cyl.height = 1.6
	cs.shape = cyl
	cs.position = Vector3(0, 0.8, 0)
	add_child(cs)

	var built := RigAssembly.build_imp_visual(lib)
	_visual = built["root"]
	_anim = built["anim"]
	add_child(_visual)

	# PROVISIONAL treatment. The Imp KEEPS its own imported PBR material
	# (BaseColor / Normal / ORM / Emissive). Only the emission channel is
	# retinted, so the pack's own emissive mask decides WHERE the violet Rift
	# accent lands -- it stays on the creature, not on the architecture.
	RigAssembly.apply_rift_accent(_visual,
		Color(0.62, 0.56, 0.72),          # MODULATES the pack albedo: cooler, less red
		SpikeConfig.COL_RIFT_VIOLET, 2.2)

	_rift_light = OmniLight3D.new()
	_rift_light.light_color = SpikeConfig.COL_RIFT_VIOLET
	_rift_light.light_energy = 0.55           # PROVISIONAL, deliberately small
	_rift_light.omni_range = 2.6
	_rift_light.position = Vector3(0, 1.3, 0)
	_rift_light.shadow_enabled = false
	add_child(_rift_light)

	# A per-enemy attack phase, so six enemies never telegraph in unison.
	var rng := RandomNumberGenerator.new()
	rng.seed = hash(name)
	_atk_cd = rng.randf_range(0.0, ATTACK_COOLDOWN)

	_play(SpikeConfig.CLIP_ENEMY_IDLE)

func _play(clip: String) -> void:
	RigAssembly.play_guarded(_anim, clip)

func take_hit(dmg: float, _from: Vector3) -> void:
	if state == State.DEAD or state == State.DYING:
		return
	health -= dmg
	took_hit_at_frame = Engine.get_physics_frames()
	event_logged.emit("hit", global_position)
	if health <= 0.0:
		_begin_death()
	else:
		state = State.HIT
		_hit_timer = HIT_STUN
		_clear_telegraph()
		_play(SpikeConfig.CLIP_ENEMY_HIT)

func _begin_death() -> void:
	state = State.DYING
	_die_t = 0.0
	died_at_frame = Engine.get_physics_frames()
	event_logged.emit("death", global_position)
	_clear_telegraph()
	collision_layer = 0
	collision_mask = 0
	# NO DEATH ANIMATION EXISTS. Stop the clip rather than substitute one.
	if _anim != null:
		_anim.stop()

func _clear_telegraph() -> void:
	if telegraph != null and is_instance_valid(telegraph):
		telegraph.queue_free()
	telegraph = null

func _physics_process(delta: float) -> void:
	if state == State.DEAD:
		return

	if state == State.DYING:
		_die_t += delta
		var t := clampf(_die_t / DIE_TIME, 0.0, 1.0)
		if _visual != null:
			_visual.rotation_degrees.x = -88.0 * t          # topple
			_visual.position.y = -1.1 * maxf(0.0, t - 0.45) / 0.55
		if _rift_light != null:
			_rift_light.light_energy = 0.55 * (1.0 - t)
		if t >= 1.0:
			state = State.DEAD
			if loot_scene_owner != null and loot_spawned_at_frame < 0:
				# LOOT APPEARS ONLY AFTER DEATH. Never before.
				loot_spawned_at_frame = Engine.get_physics_frames()
				event_logged.emit("loot", global_position)
			visible = false
		return

	if passive:
		_play(SpikeConfig.CLIP_ENEMY_IDLE)
		return

	if state == State.HIT:
		_hit_timer -= delta
		if _hit_timer <= 0.0:
			state = State.IDLE
		return

	if player == null:
		return
	var to := player.global_position - global_position
	to.y = 0.0
	var dist := to.length()

	if dist > AGGRO_RANGE:
		state = State.IDLE
		_play(SpikeConfig.CLIP_ENEMY_IDLE)
		velocity = Vector3.ZERO
		_clear_telegraph()
	elif dist > ATTACK_RANGE:
		state = State.CHASE
		_play(SpikeConfig.CLIP_ENEMY_CHASE)
		velocity = to.normalized() * SpikeConfig.ENEMY_SPEED_MPS
		_clear_telegraph()
		move_and_slide()
	else:
		velocity = Vector3.ZERO
		_atk_cd = maxf(0.0, _atk_cd - delta)
		if _atk_cd > 0.0:
			# Recovering. No windup, and therefore NO telegraph: a marker that is
			# always on is not a telegraph, it is wallpaper.
			state = State.IDLE
			_play(SpikeConfig.CLIP_ENEMY_IDLE)
			_clear_telegraph()
		else:
			state = State.WINDUP
			_play(SpikeConfig.CLIP_ENEMY_ATTACK)
			_windup += delta
			if telegraph == null:
				telegraph = TelegraphRing.make(ATTACK_RANGE * 0.82)
				add_child(telegraph)
			(telegraph as TelegraphRing).set_progress(
				clampf(_windup / WINDUP_TIME, 0.0, 1.0))
			if _windup >= WINDUP_TIME:
				_windup = 0.0
				_atk_cd = ATTACK_COOLDOWN
				_clear_telegraph()
				event_logged.emit("enemy_attack", global_position)

	if _visual != null and dist > 0.05 and state == State.CHASE:
		var want := atan2(to.x, to.z)
		_visual.rotation.y = lerp_angle(_visual.rotation.y, want, clampf(delta * 9.0, 0.0, 1.0))
