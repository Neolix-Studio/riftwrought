class_name DiagBeast
extends CharacterBody3D

## AN AUTONOMOUS DIAGNOSTIC BEAST — a minion, and NOTHING the player drives.
##
## ============================================================================
## THERE IS NO COMMAND PATH INTO THIS CLASS. THAT IS THE REQUIREMENT.
## ============================================================================
## The ruling: "Summon autonomous beasts that follow, acquire targets and attack
## through AI. NO MANUAL PET MOVEMENT, TARGET MICROMANAGEMENT OR WoW-STYLE PET
## ROTATION."
##
## So this class exposes NO command, order, recall, focus or attack-target
## method, and NO input action anywhere in the project addresses a beast. The
## suite asserts both -- by scanning the InputMap for any beast/pet/command
## action AND by driving the beasts with every input seam held at zero and
## requiring them to acquire and deal damage anyway.
##
## **The future rare command beast is NOT created here**, and the ruling says so
## explicitly. Nothing in this file may be cited for one.
##
## ---------------------------------------------------------------------------
## A MINION DOES NOT OBSTRUCT THE PLAYER.
## ---------------------------------------------------------------------------
## Canon, section 15: "Minions do not physically obstruct the player."
## Implemented structurally rather than behaviourally: the beast sits on its OWN
## collision layer, which NOTHING else masks, and it masks only the world. A rule
## enforced by a layer cannot be forgotten by a state machine, and the suite
## measures the player walking through the spot a beast occupies.
##
## ---------------------------------------------------------------------------
## IT REUSES THE ALREADY-DECLARED IMP. ZERO NEW ASSETS.
## ---------------------------------------------------------------------------
## `CLAUDE.md` section 12 forbids new assets, and the Atlas's companion guardrail
## asks for an asset-cost review. THE ASSET COST OF THIS STAGE IS ZERO: the beast
## is the same `Imp.glb` the ordinary enemy uses, scaled down with a runtime
## material treatment. IT IS A PLACEHOLDER AND NOTHING HERE IS FINAL ART.
##
## ---------------------------------------------------------------------------
## IT STEERS WITH THE PROJECT'S OWN PathFollower, FOR A MEASURED REASON.
## ---------------------------------------------------------------------------
## `NavigationAgent3D` advances along its path by 3D distance, and Recast lays
## the baked surface a measured 0.30 m above the collision floor. D-370 measured
## agents STALLING on exactly that gap. The same failure would recur verbatim for
## a minion, so the same planar-advance follower is reused.
##
## EVERY NUMBER IT USES IS PROVISIONAL. THE BEASTS TAKE NO DAMAGE IN THIS
## PROTOTYPE, WHICH IS RECORDED AS A DEFERRED ROW RATHER THAN AS A FEATURE.

## Its own layer. Nothing masks it, so it can obstruct nobody.
const BEAST_COLLISION_LAYER := 8

enum State { FOLLOW, PURSUE, STRIKE }

var player: Node3D
var enemies_provider: Callable = Callable()
var damage: float = ImprintConfig.BEAST_DAMAGE_AT_RANK_1
var origin_configuration: String = ""
## What the Persistent aura adds, as a fraction. Applied at strike time so the
## panel's "the aura supports the beasts" claim is a live number.
var aura_bonus: float = 0.0

var state: int = State.FOLLOW
var strikes: int = 0
var acquisitions: int = 0
var damage_dealt: float = 0.0
var target: Node3D = null

var _visual: Node3D
var _anim: AnimationPlayer
var _follower := NavService.PathFollower.new()
var _strike_cooldown: float = 0.0
var _repath: float = -1000.0
var _t: float = 0.0

## Diagnostics the suite reads, across the whole pack.
static var summoned_total: int = 0
static var strikes_total: int = 0
static var damage_total: float = 0.0
static var dismissed_total: int = 0

static func reset_counters() -> void:
	summoned_total = 0
	strikes_total = 0
	damage_total = 0.0
	dismissed_total = 0

func setup(corpus: AnimationLibrary) -> void:
	summoned_total += 1
	collision_layer = BEAST_COLLISION_LAYER
	# THE WORLD ONLY. Not the player, not the enemies, not other beasts.
	collision_mask = 4
	var cs := CollisionShape3D.new()
	var cyl := CylinderShape3D.new()
	cyl.radius = ImprintConfig.BEAST_BODY_RADIUS
	cyl.height = 1.0
	cs.shape = cyl
	cs.position = Vector3(0, 0.5, 0)
	add_child(cs)

	var ps := load(AssetManifest.IMP) as PackedScene
	if ps != null:
		_visual = ps.instantiate()
		_visual.name = "BeastVisual"
		add_child(_visual)
		_visual.position = Vector3.ZERO
		_visual.scale = Vector3.ONE * ImprintConfig.BEAST_VISUAL_SCALE
		_anim = RigCorpus.attach_player(_visual, corpus, 0.12)
		# ====================================================================
		# THE MODULATION IS STRONG BECAUSE A RENDERED FRAME SHOWED IT WAS NOT.
		# ====================================================================
		# The first treatment used a near-white albedo modulation and relied on
		# the pack's own emissive MASK to carry the green accent. In a rendered
		# frame the beasts read as SMALLER ENEMIES: same body, same red-violet
		# cast, only the scale telling them apart. A player cannot be asked to
		# tell friend from foe by size alone.
		#
		# So the albedo modulation now carries the distinction. It is still a
		# RUNTIME OVERRIDE -- no source mesh or texture is edited -- and it is
		# still a PLACEHOLDER: minion/enemy distinguishability in PRODUCTION is
		# a carried presentation debt, not something this stage settles.
		RigCorpus.apply_character_treatment(_visual, Color(0.34, 1.25, 0.62),
			ImprintConfig.COL_BEAST, 2.6)
		RigCorpus.play_guarded(_anim, ProdConfig.CLIP_ENEMY_IDLE)

	GroundShadow.attach_to(self, ImprintConfig.BEAST_BODY_RADIUS)

func _physics_process(delta: float) -> void:
	step(delta)

## Separated so the suite can drive exact steps.
func step(delta: float) -> void:
	_t += delta
	_strike_cooldown = maxf(0.0, _strike_cooldown - delta)
	target = _acquire()
	if target != null:
		var d := NavService.planar_distance(global_position, target.global_position)
		if d <= ImprintConfig.BEAST_ATTACK_RANGE:
			state = State.STRIKE
			_strike()
			velocity = Vector3.ZERO
		else:
			state = State.PURSUE
			_move_toward(target.global_position, 0.0, delta)
	elif player != null:
		state = State.FOLLOW
		_move_toward(player.global_position, ImprintConfig.BEAST_FOLLOW_DISTANCE, delta)
	else:
		velocity = Vector3.ZERO
	move_and_slide()
	global_position.y = 0.0
	_update_clip()

## ============================================================================
## AUTONOMOUS ACQUISITION. NOTHING OUTSIDE THIS FUNCTION CHOOSES THE TARGET.
## ============================================================================
## The nearest living enemy inside the acquire radius, re-evaluated every frame.
## There is no lock, no retention, no player-supplied target and no way to give
## it one -- which is the "per-use, not persistent" rule applied to a minion.
func _acquire() -> Node3D:
	if not enemies_provider.is_valid():
		return null
	var best: Node3D = null
	var best_d := INF
	for e in enemies_provider.call():
		if e == null or not is_instance_valid(e):
			continue
		if e.has_method("is_dead") and e.is_dead():
			continue
		var d := NavService.planar_distance(global_position, (e as Node3D).global_position)
		if d <= ImprintConfig.BEAST_ACQUIRE_RANGE and d < best_d:
			best_d = d
			best = e
	if best != null and target != best:
		acquisitions += 1
	return best

func _move_toward(dest: Vector3, stop_within: float, delta: float) -> void:
	var d := NavService.planar_distance(global_position, dest)
	if d <= maxf(0.05, stop_within):
		velocity = Vector3.ZERO
		return
	if _t - _repath >= ProdConfig.REPATH_INTERVAL_S:
		_repath = _t
		_follower.repath(NavService.map_rid_for(self), global_position, dest)
	var dir := _follower.steer(global_position)
	if dir == Vector3.ZERO:
		# The path ran out before the destination did. Falling back to a straight
		# planar direction is honest for a minion that obstructs nothing: it has
		# no body to push past and no architecture it can be wedged against that
		# the navmesh did not already model.
		dir = (dest - global_position)
		dir.y = 0.0
		dir = dir.normalized() if dir.length() > 0.001 else Vector3.ZERO
	velocity = dir * ImprintConfig.BEAST_SPEED_MPS
	if _visual != null and dir != Vector3.ZERO:
		_visual.rotation.y = YawDriver.yaw_to(dir)

func _strike() -> void:
	if _strike_cooldown > 0.0 or target == null:
		return
	_strike_cooldown = ImprintConfig.BEAST_ATTACK_INTERVAL
	var dealt := damage * (1.0 + aura_bonus)
	if target.has_method("receive_damage"):
		target.receive_damage(dealt, global_position)
	strikes += 1
	strikes_total += 1
	damage_dealt += dealt
	damage_total += dealt
	# THE LEDGER SOURCE IS THE BEAST. That separation is the whole of "ordinary
	# bow damage versus autonomous beast-primary damage".
	SkillRuntime.record_damage("beast", dealt, origin_configuration)
	RigCorpus.play_guarded(_anim, ProdConfig.CLIP_ENEMY_ATTACK, 1.0, -1.0, true)

func _update_clip() -> void:
	if _anim == null:
		return
	if state == State.STRIKE:
		return
	if velocity.length() > 0.15:
		RigCorpus.play_guarded(_anim, ProdConfig.CLIP_ENEMY_CHASE)
	else:
		RigCorpus.play_guarded(_anim, ProdConfig.CLIP_ENEMY_IDLE)

func state_name() -> String:
	return ["FOLLOW", "PURSUE", "STRIKE"][int(state)]

func dismiss() -> void:
	dismissed_total += 1
	queue_free()

func ground_point() -> Vector3:
	return global_position
