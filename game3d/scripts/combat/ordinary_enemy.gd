class_name OrdinaryEnemy
extends CharacterBody3D

## THE ORDINARY-ENEMY DIAGNOSTIC LOOP.
##
## The ruling asks for "one ordinary-enemy diagnostic loop sufficient to verify
## navigation, acquisition, telegraphing, attacking, receiving damage and death."
## SIX NAMED CAPABILITIES. Each is a state or a transition below, and each is a
## criterion in the owed inventory.
##
## ============================================================================
## THIS IS AN ORDINARY ENEMY. IT IS NOT A BOSS AND NOTHING HERE MAY BE CITED
## FOR ONE.
## ============================================================================
## The ruling forbids importing the boss encounter into production during this
## foundation, and D-369's humanoid-boss result is bounded to `game3d_boss_spike/`.
##
## It is also NOT a canonical Riftwrought enemy: no enemy family, role or Elite
## modifier is specified or implied. Every number is PROVISIONAL.
##
## THE ACTOR'S POSITION IS ITS GROUND POINT.

signal telegraph_shown()
signal committed()
signal died()

enum State { IDLE, CHASE, WINDUP, COMMIT, RECOVER, DYING, DEAD }

var state: State = State.IDLE
var player: Node3D
var life := Damageable.new(ProdConfig.ENEMY_HEALTH)

var agent: NavigationAgent3D
var follower := NavService.PathFollower.new()
var visual: Node3D
var anim: AnimationPlayer
var skeleton: Skeleton3D
var telegraph: Telegraph

## Diagnostics the suite reads.
var acquired: bool = false
var acquisitions: int = 0
var commits: int = 0
var telegraph_shown_at_state: Array[String] = []
var damage_dealt: float = 0.0
var last_commit_hit_player: bool = false
var death_clip_length: float = 0.0
var death_elapsed: float = 0.0
var path_points_last: int = 0

## Test seams. False / null in normal play; the suite asserts they are clear.
var debug_freeze_ai: bool = false
var debug_suppress_movement: bool = false

var _t: float = 0.0
var _cooldown: float = 0.0
var _yaw := YawDriver.new()
## Deliberately far in the past so the FIRST chase frame repaths. Starting it
## at 0.0 left the agent pathing to the world origin for one frame, which is
## invisible in play and poison in a measurement.
var _last_repath: float = -1000.0

## PROVISIONAL. How hard local separation pulls against the path direction.
const SEPARATION_WEIGHT := 1.35
const SEPARATION_MARGIN := 0.55

## Diagnostics the suite reads.
var separation_events: int = 0

## A planar push away from other actor bodies that are too close. Returns ZERO
## when nothing is crowding, so the ordinary case is unaffected.
func _separation() -> Vector3:
	var space := get_world_3d().direct_space_state
	if space == null:
		return Vector3.ZERO
	var q := PhysicsShapeQueryParameters3D.new()
	var sphere := SphereShape3D.new()
	sphere.radius = ProdConfig.ENEMY_BODY_RADIUS + SEPARATION_MARGIN
	q.shape = sphere
	q.transform = Transform3D(Basis.IDENTITY, global_position + Vector3(0, 0.8, 0))
	q.collision_mask = 1 | 2                 # the player and other enemies
	q.collide_with_areas = false
	q.exclude = [get_rid()]
	var push := Vector3.ZERO
	for h in space.intersect_shape(q, 8):
		var c = h.get("collider")
		if c == null or not is_instance_valid(c) or c == self:
			continue
		# NEVER separate from the thing being chased, or the enemy can never
		# close to attack range.
		if c == player:
			continue
		var away := global_position - (c as Node3D).global_position
		away.y = 0.0
		var d := away.length()
		if d < 0.0001:
			continue
		push += away.normalized() * (1.0 - clampf(d / (ProdConfig.ENEMY_BODY_RADIUS
			+ SEPARATION_MARGIN + ProdConfig.ENEMY_BODY_RADIUS), 0.0, 1.0))
	if push.length() > 0.0001:
		separation_events += 1
		# NOT normalised. Normalising the sum threw the distance weighting away,
		# so a neighbour 1.33 m off -- barely inside the query at all -- produced
		# a FULL-STRENGTH push. Blended against the path direction that turned a
		# gentle sidestep into a hard shove straight into a wall, and the enemy
		# stopped dead: measured, 5.57 m short of its target, for nine seconds.
		# The weight is the whole point of the weight.
		return push.limit_length(1.0)
	return Vector3.ZERO

func setup(corpus: AnimationLibrary) -> void:
	collision_layer = 2
	# World geometry, the player and other enemies.
	collision_mask = 4 | 1 | 2
	var cs := CollisionShape3D.new()
	var cyl := CylinderShape3D.new()
	cyl.radius = ProdConfig.ENEMY_BODY_RADIUS
	cyl.height = 1.6
	cs.shape = cyl
	cs.position = Vector3(0, 0.8, 0)
	add_child(cs)

	# See PlayerController: the agent declares the radius, the PathFollower does
	# the steering.
	agent = NavigationAgent3D.new()
	agent.name = "NavAgent"
	agent.radius = ProdConfig.NAV_AGENT_RADIUS
	agent.height = ProdConfig.NAV_AGENT_HEIGHT
	agent.avoidance_enabled = false
	add_child(agent)

	var ps := load(AssetManifest.IMP) as PackedScene
	visual = ps.instantiate()
	visual.name = "EnemyVisual"
	add_child(visual)
	visual.position = Vector3.ZERO
	skeleton = RigCorpus.find_skeleton(visual)
	anim = RigCorpus.attach_player(visual, corpus, 0.14)
	# The pack ships real PBR maps INCLUDING an emissive mask, so only albedo
	# modulation and emission are touched. NO SOURCE FILE IS EDITED.
	RigCorpus.apply_character_treatment(visual, Color(0.86, 0.84, 0.92),
		ProdConfig.COL_RIFT_VIOLET, 1.6)

	telegraph = Telegraph.new()
	telegraph.name = "Telegraph"
	add_child(telegraph)
	telegraph.build(ProdConfig.ENEMY_ATTACK_RANGE_M + 0.6, ProdConfig.ENEMY_ATTACK_ARC_DEG)
	telegraph.visible = false

	GroundShadow.attach_to(self, ProdConfig.ENEMY_BODY_RADIUS)

	death_clip_length = RigCorpus.clip_length(anim, ProdConfig.CLIP_ENEMY_DEATH)
	_play(ProdConfig.CLIP_ENEMY_IDLE)

func _play(clip: String, speed: float = 1.0, restart: bool = false) -> void:
	RigCorpus.play_guarded(anim, clip, speed, -1.0, restart)

func live_clip() -> String:
	return anim.current_animation if anim != null else ""

# ---------------------------------------------------------------- damage ----

## Called by the diagnostic bolt. Named so the projectile can find it by
## capability rather than by class, which keeps the combat layer decoupled.
func receive_damage(amount: float, from: Vector3) -> void:
	if state == State.DYING or state == State.DEAD:
		return
	if not life.apply(amount, from):
		return
	if life.dead:
		_enter_dying()
		return
	# A hit reaction that does not interrupt the commit window, so a telegraph
	# that has already committed still resolves. PROVISIONAL.
	if state != State.COMMIT:
		_play(ProdConfig.CLIP_ENEMY_HIT, 1.0, true)

# --------------------------------------------------------------- physics ----

func _physics_process(delta: float) -> void:
	step(delta)

func step(delta: float) -> void:
	if debug_freeze_ai:
		return
	_t += delta
	_cooldown = maxf(0.0, _cooldown - delta)

	match state:
		State.IDLE:      _step_idle(delta)
		State.CHASE:     _step_chase(delta)
		State.WINDUP:    _step_windup(delta)
		State.COMMIT:    _step_commit(delta)
		State.RECOVER:   _step_recover(delta)
		State.DYING:     _step_dying(delta)
		State.DEAD:      pass

	global_position.y = 0.0

func _distance_to_player() -> float:
	if player == null:
		return INF
	return NavService.planar_distance(global_position, player.global_position)

func _face_player(delta: float) -> void:
	if player == null or visual == null:
		return
	var d := player.global_position - global_position
	d.y = 0.0
	if d.length() < 0.001:
		return
	visual.rotation.y = _yaw.step(YawDriver.yaw_to(d), delta)

# --- ACQUISITION -------------------------------------------------------------

func _step_idle(delta: float) -> void:
	_play(ProdConfig.CLIP_ENEMY_IDLE)
	velocity = Vector3.ZERO
	if _distance_to_player() <= ProdConfig.ENEMY_ACQUIRE_RADIUS_M:
		acquired = true
		acquisitions += 1
		state = State.CHASE

# --- NAVIGATION --------------------------------------------------------------

func _step_chase(delta: float) -> void:
	_play(ProdConfig.CLIP_ENEMY_CHASE)
	var dist := _distance_to_player()
	if dist > ProdConfig.ENEMY_DEACQUIRE_RADIUS_M:
		acquired = false
		state = State.IDLE
		return
	_face_player(delta)
	if dist <= ProdConfig.ENEMY_ATTACK_RANGE_M and _cooldown <= 0.0:
		_enter_windup()
		return
	if debug_suppress_movement or player == null or agent == null:
		velocity = Vector3.ZERO
		return
	# REPATH ON A CADENCE, not every frame. A path recomputed every physics
	# frame is both wasteful and jittery, and it hides whether the path is being
	# followed at all.
	if _t - _last_repath >= ProdConfig.REPATH_INTERVAL_S:
		_last_repath = _t
		follower.repath(NavService.map_rid_for(self), global_position,
			player.global_position)
	path_points_last = follower.point_count()
	var dir := follower.steer(global_position)
	if dir == Vector3.ZERO:
		velocity = Vector3.ZERO
	else:
		# LOCAL SEPARATION, blended into the path direction.
		#
		# A baked navigation mesh knows about the ARCHITECTURE and nothing about
		# the other actors standing on it. MEASURED here: an enemy whose path ran
		# through a stationary body stopped dead at 5.57 m from its target and
		# stayed there for nine seconds, repathing 43 times into the same wall of
		# flesh. The polygon count was right, the path was right, and the actor
		# never arrived -- which is exactly why the checks measure ARRIVAL rather
		# than the existence of a path.
		#
		# This is a MINIMUM: it unsticks the loop, and it is NOT crowd avoidance.
		# See the delivery report's production risks.
		velocity = (dir + _separation() * SEPARATION_WEIGHT).normalized() \
			* ProdConfig.ENEMY_SPEED_MPS
	move_and_slide()

# --- TELEGRAPHING ------------------------------------------------------------

func _enter_windup() -> void:
	state = State.WINDUP
	_t = 0.0
	velocity = Vector3.ZERO
	telegraph.visible = true
	telegraph.set_progress(0.0)
	if player != null:
		var d := player.global_position - global_position
		telegraph.face(d)
	telegraph_shown_at_state.append("WINDUP")
	telegraph_shown.emit()
	# A held pose during the windup. The overlay names the SOURCE CLIP, so this
	# borrowed pose is never presented as a designed move.
	_play(ProdConfig.CLIP_ENEMY_WINDUP, 1.0, true)

func _step_windup(delta: float) -> void:
	_face_player(delta)
	if player != null:
		telegraph.face(player.global_position - global_position)
	telegraph.set_progress(_t / ProdConfig.ENEMY_WINDUP_S)
	if _t >= ProdConfig.ENEMY_WINDUP_S:
		_enter_commit()

# --- ATTACKING ---------------------------------------------------------------

func _enter_commit() -> void:
	state = State.COMMIT
	_t = 0.0
	commits += 1
	telegraph.set_progress(1.0)
	_play(ProdConfig.CLIP_ENEMY_ATTACK, 1.0, true)
	committed.emit()
	# THE DAMAGE QUERY USES THE TELEGRAPH'S OWN `contains()`. One arithmetic,
	# two consumers, so the drawing and the damage cannot disagree.
	last_commit_hit_player = false
	if player != null and telegraph.contains(player.global_position):
		last_commit_hit_player = true
		damage_dealt += ProdConfig.ENEMY_ATTACK_DAMAGE
		if player.has_method("receive_damage"):
			player.receive_damage(ProdConfig.ENEMY_ATTACK_DAMAGE, global_position)
		elif player.get("life") != null:
			var l = player.get("life")
			l.apply(ProdConfig.ENEMY_ATTACK_DAMAGE, global_position)

func _step_commit(delta: float) -> void:
	if _t >= ProdConfig.ENEMY_COMMIT_S:
		state = State.RECOVER
		_t = 0.0
		# THE TELEGRAPH LEAVES ON RECOVERY. A telegraph that lingers past its
		# attack teaches the player the wrong thing.
		telegraph.visible = false
		telegraph.set_progress(0.0)

func _step_recover(delta: float) -> void:
	if _t >= ProdConfig.ENEMY_RECOVER_S:
		_cooldown = ProdConfig.ENEMY_COOLDOWN_S
		state = State.CHASE
		_t = 0.0

# --- DEATH -------------------------------------------------------------------

func _enter_dying() -> void:
	state = State.DYING
	_t = 0.0
	death_elapsed = 0.0
	velocity = Vector3.ZERO
	telegraph.visible = false
	# A REAL SOURCE DEATH CLIP. `Death01` comes from UAL1 and is used by its own
	# name. The D-366 spike had to improvise a code-driven topple because UAL2
	# alone has none; that improvisation is not needed here and is not used.
	_play(ProdConfig.CLIP_ENEMY_DEATH, 1.0, true)
	collision_layer = 0                 # a corpse is not a target
	died.emit()

func _step_dying(delta: float) -> void:
	death_elapsed += delta
	if death_elapsed >= death_clip_length:
		state = State.DEAD              # TERMINAL. Nothing leaves this state.

func is_dead() -> bool:
	return state == State.DYING or state == State.DEAD

func ground_point() -> Vector3:
	return global_position

func state_name() -> String:
	return ["IDLE", "CHASE", "WINDUP", "COMMIT", "RECOVER", "DYING", "DEAD"][int(state)]
