class_name PrototypeGraveblade
extends CharacterBody3D
## Prototype Zero — Gate D: the one Graveblade (specification §14, decision
## D-181).
##
## Presented through the registered KayKit Skeleton Warrior carrying the
## registered Skeleton Blade. The player-facing prototype name is "Graveblade";
## "Skeleton Warrior" stays an acceptable debug identifier.
##
## It owns exactly what §14.2 lists and nothing else: detection, pursuit, an
## attack-permission request, a committed and readable attack, one release query
## per use, deterministic Physical damage, Life, and mechanical death. There is
## no XP award, no loot, no wave logic, and no second enemy.
##
## THE FOUR CONTRACTS THIS FILE EXISTS TO KEEP
##
##   * It asks the room's `AttackCoordinator` BEFORE it commits, every time, and
##     it gives the permission back when its action ends or it dies.
##   * It tracks the player through the first part of the anticipation and then
##     LOCKS its release direction, visibly, before contact. After that lock it
##     cannot follow the player, which is what makes stepping aside a real miss
##     rather than a cosmetic one.
##   * Exactly one release query per attack use, fired from the animation-aligned
##     marker after the marker has driven the rig pose — the same arrangement
##     Gate C proved for Quick Strike, for the same reason.
##   * Death is mechanical and immediate. Targeting, damage in and out,
##     navigation, movement blocking, and attack permission all stop on the frame
##     Life reaches zero. The death animation is decoration played afterwards and
##     never delays the kill event.
##
## An ordinary player Hit produces a visible reaction and NEVER interrupts the
## current action (§14.2).

## Specification §14.2, exactly.
enum State {
	SPAWN,
	IDLE,
	CHASE,
	WAIT_FOR_ATTACK_PERMISSION,
	ATTACK_WINDUP,
	ATTACK_RELEASE,
	ATTACK_RECOVERY,
	DEAD,
}

const IDLE_CLIP: StringName = &"Idle_A"
const RUN_CLIP: StringName = &"Running_A"
const HIT_CLIP: StringName = &"Hit_A"
const DEATH_CLIP: StringName = &"Death_A"
const ATTACK_CLIP: StringName = &"Graveblade_Attack"

## Layer 4, "enemy". The Graveblade blocks the player and is blocked by the
## world, but it is NOT on the world layer, so it never enters the navigation
## bake and cannot change a Gate B navigation result.
const ENEMY_LAYER: int = 8
const ENEMY_MASK: int = 1 | 2  ## world + player

@export var data: GravebladeData
@export var rig_path: NodePath = ^"VisualRoot/GravebladeRig"
## Local editable copy of the attack clip, retimed so its measured visible
## contact sits on the release marker. Built by, and only by,
## scripts/tools/build_graveblade_animation.gd.
@export var attack_library: AnimationLibrary
@export var attack_library_name: StringName = &"prototype"
## Speed at which the run cycle plays at its authored rate.
@export var run_cycle_reference_speed: float = 3.4

@export_group("Movement")
@export var acceleration: float = 22.0
@export var braking: float = 30.0
@export var turn_rate_degrees: float = 540.0
## Slack above `preferred_attack_distance` at which the Graveblade is willing to
## commit. It chooses its fight at the preferred distance and its strike still
## LANDS out to `attack_reach`, and that gap is deliberate: it is what makes a
## small step backwards a near miss and a real one a clean miss.
@export var commit_tolerance: float = 0.15

var state: State = State.SPAWN
var state_time: float = 0.0
var life: float = 300.0
var attack_use_id: int = 0

## The direction the current attack will strike along. Tracks the player until
## `commit_time()`, then is frozen — `committed` says which.
var release_direction: Vector3 = Vector3.FORWARD
var committed: bool = false

var target_player: Node3D = null
var aware: bool = false
## Verification seam (see the bottom of this file). True in all ordinary play.
var ai_enabled: bool = true

# --- Instrumentation (specification §22) -------------------------------------
var attacks_started: int = 0
var attacks_released: int = 0
var release_queries: int = 0
var attacks_hit: int = 0
var attacks_missed: int = 0
var permission_requests: int = 0
var permission_refusals: int = 0
var damage_taken_events: int = 0
var hit_reactions: int = 0
var last_release: Dictionary = {}
var last_damage_taken: DamageEvent = null
var last_damage_dealt: DamageEvent = null
var died_at_msec: int = 0
var death_animation_started_at_msec: int = 0
## THE SAME TWO MOMENTS ON THE SIMULATION TIMELINE, and the ones Gate D asserts
## on (Gate F report §10a.5).
##
## `_die()` is one synchronous sequence, and what the check is really asking is
## whether presentation work got in between the mechanical kill and the
## decoration that sequence ends with. That is a question about frames and about
## what had run yet — not about milliseconds, which on a loaded machine measure
## the operating system rather than this code and once read 4 ms against a 1 ms
## tolerance. The millisecond stamps above stay for the log.
var died_at_physics_frame: int = -1
var died_at_process_frame: int = -1
var death_animation_started_at_physics_frame: int = -1
var death_animation_started_at_process_frame: int = -1

var _coordinator: AttackCoordinator
var _acquire: TargetAcquisition
var _agent: NavigationAgent3D
var _visual_root: Node3D
var _rig: MediumRigVisual
var _target_area: PrototypeTargetable
var _life_bar: Node3D
var _log: Callable = Callable()

var _facing_yaw: float = 0.0
var _current_clip: StringName = &""
var _attack_clip: StringName = &""
var _release_fired_for_use: bool = false
var _next_use_id: int = 1
var _commitment_cooldown: float = 0.0
var _reaction_flash: float = 0.0
var _spawn_position: Vector3 = Vector3.ZERO
## Guards against one attacker's single use landing twice, whatever the caller
## does. Keyed by source instance id -> last accepted use id.
var _accepted_use_ids: Dictionary = {}

var _gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity", 9.8)

signal state_changed(from: State, to: State)
signal took_damage(event: DamageEvent)
signal died(event: DamageEvent)
signal attack_committed(direction: Vector3)
signal attack_released(event_or_miss: Dictionary)


func _ready() -> void:
	_agent = $NavigationAgent3D
	_visual_root = $VisualRoot
	_rig = get_node(rig_path) as MediumRigVisual
	_target_area = $TargetArea as PrototypeTargetable
	_life_bar = $LifeBar
	var problem: String = "graveblade data is missing" if data == null else data.problem()
	assert(problem.is_empty(), "PrototypeGraveblade: %s" % problem)
	life = data.max_life
	_facing_yaw = _visual_root.rotation.y
	_spawn_position = global_position
	_agent.path_desired_distance = 0.40
	_agent.target_desired_distance = 0.30
	_agent.radius = 0.40
	_agent.avoidance_enabled = false
	collision_layer = ENEMY_LAYER
	collision_mask = ENEMY_MASK
	_register_attack_clip()
	_enter(State.SPAWN)


## The retimed clip is added at runtime from this scene rather than being written
## into `graveblade_rig.tscn`, so the Gate A rig scenes and the preserved Gate A
## spike stay byte-for-byte unchanged — the same arrangement the player uses.
func _register_attack_clip() -> void:
	if _rig == null or attack_library == null:
		return
	var animation_player: AnimationPlayer = _rig.animation_player
	if not animation_player.has_animation_library(attack_library_name):
		animation_player.add_animation_library(attack_library_name, attack_library)
	_attack_clip = StringName("%s/%s" % [attack_library_name, ATTACK_CLIP])
	assert(animation_player.has_animation(_attack_clip),
		"PrototypeGraveblade: retimed clip '%s' is missing; rebuild it with build_graveblade_animation.gd" % _attack_clip)


func setup(player: Node3D, coordinator: AttackCoordinator, acquisition: TargetAcquisition, log_sink: Callable) -> void:
	target_player = player
	_coordinator = coordinator
	_acquire = acquisition
	_log = log_sink
	_emit("graveblade ready", data.describe())


# --- Derived timing ----------------------------------------------------------

func action_time() -> float:
	return data.action_time()


## Normalised position inside the whole attack action, which is also normalised
## time in the retimed clip.
func action_normalized_time() -> float:
	match state:
		State.ATTACK_WINDUP:
			return clampf(state_time / maxf(data.anticipation, 0.0001), 0.0, 1.0) * data.release_marker_normalized()
		State.ATTACK_RELEASE:
			return data.release_marker_normalized() + clampf(
				state_time / maxf(data.release_window, 0.0001), 0.0, 1.0
			) * (data.release_window / action_time())
		State.ATTACK_RECOVERY:
			var released_through: float = data.release_marker_normalized() + data.release_window / action_time()
			return released_through + clampf(
				state_time / maxf(data.recovery, 0.0001), 0.0, 1.0
			) * (data.recovery / action_time())
		_:
			return 0.0


func is_attacking() -> bool:
	return state == State.ATTACK_WINDUP or state == State.ATTACK_RELEASE or state == State.ATTACK_RECOVERY


func is_alive() -> bool:
	return state != State.DEAD


func commitment_cooldown_remaining() -> float:
	return maxf(_commitment_cooldown, 0.0)


func facing_direction() -> Vector3:
	return Vector3(sin(_facing_yaw), 0.0, cos(_facing_yaw))


func targeting_point() -> Vector3:
	return global_position + Vector3(0.0, 1.10, 0.0)


func distance_to_player() -> float:
	if target_player == null:
		return INF
	return _planar_distance(global_position, target_player.global_position)


# --- Simulation --------------------------------------------------------------

func _physics_process(delta: float) -> void:
	if state == State.DEAD:
		_apply_gravity_only(delta)
		return

	state_time += delta
	_commitment_cooldown = maxf(_commitment_cooldown - delta, 0.0)

	var desired: Vector3 = Vector3.ZERO
	match state:
		State.SPAWN:
			if ai_enabled and state_time >= data.spawn_settle:
				_enter(State.IDLE)
		State.IDLE:
			if ai_enabled and _player_is_engageable() and distance_to_player() <= data.awareness_distance:
				aware = true
				_emit("graveblade aware", "player at %.2f m, inside the %.1f m awareness distance" % [
					distance_to_player(), data.awareness_distance,
				])
				_enter(State.CHASE)
		State.CHASE:
			if ai_enabled:
				desired = _chase_velocity()
				if _may_request_permission():
					_enter(State.WAIT_FOR_ATTACK_PERMISSION)
		State.WAIT_FOR_ATTACK_PERMISSION:
			if ai_enabled:
				desired = _chase_velocity()
				_tick_permission()
		State.ATTACK_WINDUP:
			_tick_windup()
		State.ATTACK_RELEASE:
			if state_time >= data.release_window:
				var carried: float = state_time - data.release_window
				_enter(State.ATTACK_RECOVERY)
				state_time = carried
		State.ATTACK_RECOVERY:
			if state_time >= data.recovery:
				var carried_recovery: float = state_time - data.recovery
				_finish_attack()
				state_time = carried_recovery
		_:
			pass

	_apply_planar_velocity(desired, delta)
	if is_on_floor():
		velocity.y = 0.0
	else:
		velocity.y -= _gravity * delta
	move_and_slide()
	_update_facing(delta)
	_update_animation()


func _process(delta: float) -> void:
	if _reaction_flash > 0.0:
		_reaction_flash = maxf(_reaction_flash - delta * 3.0, 0.0)
	_update_life_bar()


func _player_is_engageable() -> bool:
	if target_player == null:
		return false
	if target_player.has_method("is_alive"):
		return bool(target_player.call("is_alive"))
	return true


## Chase toward the player but hold at the preferred distance rather than walking
## into them. Navigation-mesh path following, so the pursuit rounds the world
## collision and the optional barrier instead of grinding along them.
func _chase_velocity() -> Vector3:
	if not _player_is_engageable():
		aware = false
		_enter(State.IDLE)
		return Vector3.ZERO
	var distance: float = distance_to_player()
	if distance <= data.preferred_attack_distance:
		return Vector3.ZERO
	var goal: Vector3 = target_player.global_position
	if _agent.target_position.distance_to(goal) > 0.25:
		_agent.target_position = goal
	var step: Vector3 = _planar(_agent.get_next_path_position() - global_position)
	if step.length() < 0.0001:
		step = _planar(goal - global_position)
	if step.length() < 0.0001:
		return Vector3.ZERO
	# Brake into the holding distance so the approach settles instead of
	# overshooting and correcting.
	var remaining: float = distance - data.preferred_attack_distance
	var arrival_speed: float = sqrt(2.0 * braking * maxf(remaining, 0.0))
	return step.normalized() * minf(data.move_speed, arrival_speed)


## The gate on asking at all: a living player, close enough to be worth
## committing, and past the minimum interval since the previous commitment ended.
##
## "Close enough" is the PREFERRED distance plus its tolerance, not the reach.
## The Graveblade decides to strike at about 1.55 m and its release still
## validates out to the full 1.65 m, so the last 0.10 m is honest slack rather
## than a second reach.
func commit_distance() -> float:
	return data.preferred_attack_distance + commit_tolerance


func _may_request_permission() -> bool:
	if not _player_is_engageable():
		return false
	if _commitment_cooldown > 0.0:
		return false
	return distance_to_player() <= commit_distance()


func _tick_permission() -> void:
	if not _may_request_permission():
		# WITHDRAWN, not ACTION_COMPLETED: nothing was committed and nothing was
		# spent, so D-186's group window is not owed for walking back out of range.
		_coordinator.release(self, AttackCoordinator.ReleaseCause.WITHDRAWN,
			"no longer in range to commit")
		_enter(State.CHASE)
		return
	permission_requests += 1
	if _coordinator.request(self):
		_begin_windup()
		return
	permission_refusals += 1
	if state_time > 1.0:
		# Nothing in Gate D can hold the slot this long, so a refusal that
		# persists is worth seeing rather than waiting in silence.
		_emit("attack permission refused", _coordinator.last_decision)
		state_time = 0.0


func _begin_windup() -> void:
	attack_use_id = _next_use_id
	_next_use_id += 1
	attacks_started += 1
	_release_fired_for_use = false
	committed = false
	release_direction = _direction_to_player()
	_enter(State.ATTACK_WINDUP)
	_emit("graveblade wind-up", "use %d, %.2f s anticipation, commits at %.2f s, player %.2f m away" % [
		attack_use_id, data.anticipation, data.commit_time(), distance_to_player(),
	])


## Specification §14.2: "face the player during early anticipation" and "visibly
## commit its final release direction before contact".
func _tick_windup() -> void:
	if not committed and state_time < data.commit_time():
		release_direction = _direction_to_player()
	elif not committed:
		committed = true
		attack_committed.emit(release_direction)
		_emit("graveblade committed", "use %d locked its release direction %.0f deg, %.2f s before contact" % [
			attack_use_id, rad_to_deg(atan2(release_direction.x, release_direction.z)),
			data.committed_lead_time(),
		])
	if state_time >= data.anticipation:
		var carried: float = state_time - data.anticipation
		_fire_release()
		state_time = carried


## The one release query for this attack use, fired from the animation-aligned
## marker. The marker is applied to the rig FIRST, so the query resolves against
## the pose the player can see rather than one the renderer reaches a frame
## later — the arrangement Gate C measured and proved for Quick Strike.
func _fire_release() -> void:
	assert(not _release_fired_for_use,
		"PrototypeGraveblade: use %d tried to release twice" % attack_use_id)
	_release_fired_for_use = true
	if not committed:
		committed = true
		attack_committed.emit(release_direction)
	sync_attack_pose(data.release_marker_normalized())
	_enter(State.ATTACK_RELEASE)
	attacks_released += 1
	_coordinator.note_release_started(self)

	var outcome: Dictionary = _resolve_release()
	release_queries += 1
	outcome["use_id"] = attack_use_id
	last_release = outcome
	if String(outcome["outcome"]) == "hit":
		attacks_hit += 1
		var event: DamageEvent = DamageEvent.physical(
			attack_use_id, self, target_player, data.physical_damage
		)
		last_damage_dealt = event
		outcome["event"] = event
		target_player.call("receive_damage", event)
		_emit("graveblade hit", "%s" % event.describe())
	else:
		attacks_missed += 1
		_emit("graveblade missed", "use %d: %s" % [attack_use_id, outcome["reason"]])
	attack_released.emit(outcome)


## Validates everything §14.2 requires at release: range, the arc, obstruction,
## and the COMMITTED direction.
func _resolve_release() -> Dictionary:
	if not _player_is_engageable():
		return {"outcome": "miss", "reason": "no living player to strike"}
	return evaluate_release(target_player.global_position, release_direction)


## The complete release validation, as a pure function of where the target is and
## where the strike was committed. The arc is centred on the COMMITTED direction,
## not on the current facing, which is exactly why stepping aside after the commit
## is a genuine miss rather than a cosmetic one.
##
## It is public so `gate_d_verification.gd` can measure the reach, arc, and
## obstruction boundaries on THIS code rather than on a copy of it. That matters
## for obstruction in particular: the room cannot physically place two 0.80 m
## bodies within the 1.65 m reach of each other across a 1.5 m barrier, so the
## only honest way to exercise that branch end to end is to call it.
func evaluate_release(target_position: Vector3, committed: Vector3) -> Dictionary:
	var to_player: Vector3 = _planar(target_position - global_position)
	var distance: float = to_player.length()
	if distance < 0.0001:
		return {"outcome": "miss", "reason": "the target has no separation to measure"}
	var angle: float = committed.angle_to(to_player.normalized())
	if distance > data.attack_reach:
		return {
			"outcome": "miss",
			"reason": "%.2f m is beyond the %.2f m reach" % [distance, data.attack_reach],
			"distance": distance, "angle_degrees": rad_to_deg(angle),
		}
	if angle > data.attack_arc_half_radians():
		return {
			"outcome": "miss",
			"reason": "%.0f deg from the committed direction is outside the %.0f deg arc" % [
				rad_to_deg(angle), data.attack_arc_degrees,
			],
			"distance": distance, "angle_degrees": rad_to_deg(angle),
		}
	if _acquire != null and _acquire.is_obstructed(
		targeting_point(), target_position + Vector3(0.0, 1.10, 0.0)
	):
		return {
			"outcome": "miss", "reason": "obstructed",
			"distance": distance, "angle_degrees": rad_to_deg(angle),
		}
	return {
		"outcome": "hit",
		"reason": "%.2f m at %.0f deg from the committed direction" % [distance, rad_to_deg(angle)],
		"distance": distance, "angle_degrees": rad_to_deg(angle),
	}


func _finish_attack() -> void:
	# D-186: the cause is stated as a VALUE, not as the words "action finished".
	# ACTION_COMPLETED is what starts the coordinator's 0.35-second group handoff,
	# so the rule cannot be broken by rewording a log line.
	_coordinator.release(self, AttackCoordinator.ReleaseCause.ACTION_COMPLETED, "action finished")
	# Specification §14.2 and D-181: return to chase only after recovery AND the
	# minimum commitment interval. The interval is a gate on the NEXT commitment,
	# not a fourth attack phase, so the Graveblade is chasing again while it runs.
	#
	# This line and the group handoff above are the SAME 0.35 seconds, started on
	# the same frame from the same value. They run concurrently and do not stack,
	# which is exactly why one Graveblade's cadence is untouched by D-186: it
	# still asks again at the moment its own interval ends, and the window it
	# would otherwise wait for is already spent.
	_commitment_cooldown = data.minimum_commitment_interval
	committed = false
	_emit("graveblade recovered", "use %d finished a %.2f s action; %.2f s before another commitment" % [
		attack_use_id, action_time(), data.minimum_commitment_interval,
	])
	_enter(State.CHASE)


# --- Damage, Life, and death -------------------------------------------------

## The Graveblade's half of the Hit contract. Applies Life exactly once, emits
## the Hit, and only then — from inside the same call — the kill, so the ordering
## is a property of the code rather than of two listeners racing.
func receive_damage(event: DamageEvent) -> void:
	if state == State.DEAD:
		_emit("graveblade damage ignored", "already dead; use %d produced no damage and no second kill" % event.use_id)
		return
	var source_key: int = event.source.get_instance_id() if event.source != null else 0
	if _accepted_use_ids.get(source_key, -1) == event.use_id:
		_emit("graveblade damage ignored", "use %d already applied; duplicate refused" % event.use_id)
		return
	_accepted_use_ids[source_key] = event.use_id

	damage_taken_events += 1
	last_damage_taken = event
	var before: float = life
	life = maxf(life - event.final_life_damage, 0.0)
	# A lethal Hit gets no flinch: the death response is the reaction, and playing
	# both would start `Hit_A` and abandon it one line later.
	_react_to_hit(life > 0.0)
	_emit("graveblade damaged", "%s; Life %.0f -> %.0f of %.0f" % [
		event.describe(), before, life, data.max_life,
	])
	took_damage.emit(event)
	if life <= 0.0:
		_die(event)


## Mechanical death, complete on this frame. The decoration comes afterwards and
## cannot delay any of it (specification §14.2, §18).
func _die(event: DamageEvent) -> void:
	died_at_msec = Time.get_ticks_msec()
	died_at_physics_frame = int(Engine.get_physics_frames())
	died_at_process_frame = int(Engine.get_process_frames())
	_enter(State.DEAD)
	velocity = Vector3.ZERO
	aware = false

	# 1. Stops being a target: acquisition, the soft-target cone, and the release
	#    query all refuse it from here.
	if _target_area != null:
		_target_area.set_soft_targeted(false)
		_target_area.collision_layer = 0
		_target_area.monitorable = false
	# 2. Stops blocking movement.
	collision_layer = 0
	collision_mask = 0
	# 3. Stops navigating.
	_agent.target_position = global_position
	# 4. Gives back attack permission, so nothing waits on a dead enemy. D-186:
	#    dying while holding the slot still owes the group its breathing window —
	#    otherwise killing the attacker would hand the next Graveblade a free,
	#    immediate strike, which is the opposite of what the correction is for.
	if _coordinator != null:
		_coordinator.release(self, AttackCoordinator.ReleaseCause.ATTACKER_DIED, "died")
	# 5. Stops threatening: no wind-up in flight can still resolve.
	_release_fired_for_use = true
	committed = false
	if _life_bar != null:
		_life_bar.visible = false

	_emit("graveblade killed", "use %d was lethal; threat, targeting, navigation, blocking, and attack permission are off" % event.use_id)
	died.emit(event)

	# Decoration only, and only after every mechanical consequence above.
	death_animation_started_at_msec = Time.get_ticks_msec()
	death_animation_started_at_physics_frame = int(Engine.get_physics_frames())
	death_animation_started_at_process_frame = int(Engine.get_process_frames())
	if _rig != null:
		_current_clip = DEATH_CLIP
		_rig.play(DEATH_CLIP, 1.0, 0.10)
		_rig.animation_player.speed_scale = 1.0


## Specification §14.2: "The ordinary hit reaction is visual feedback and does not
## mechanically interrupt the Graveblade's current action."
##
## Mid-attack that is enforced by not touching the clip at all — a material flash
## is the whole reaction, because swapping to `Hit_A` would fight the marker-driven
## attack pose the release query depends on. Outside an attack the registered
## `Hit_A` clip plays, which still changes no state, no timer, and no committed
## direction.
func _react_to_hit(survived: bool) -> void:
	hit_reactions += 1
	_reaction_flash = 1.0
	if not survived or is_attacking() or _rig == null:
		return
	_current_clip = HIT_CLIP
	_rig.play(HIT_CLIP, 1.0, 0.08)
	_rig.animation_player.speed_scale = 1.0


func reaction_flash() -> float:
	return _reaction_flash


# --- Presentation ------------------------------------------------------------

func _update_facing(delta: float) -> void:
	var wanted: Vector3 = Vector3.ZERO
	if is_attacking():
		# Once committed the body holds the direction it committed to. Before
		# that it tracks, which is the readable "it is choosing where to strike".
		wanted = release_direction
	elif _planar(velocity).length() > 0.15:
		wanted = _planar(velocity).normalized()
	elif ai_enabled and aware and _player_is_engageable():
		wanted = _direction_to_player()
	if wanted.length() < 0.0001:
		_visual_root.rotation.y = _facing_yaw
		return
	# MEASURED, not assumed: the KayKit medium rig faces +Z at identity
	# (SOURCE_AND_LICENSE.md §3.6), so facing uses atan2(x, z).
	_facing_yaw = rotate_toward(_facing_yaw, atan2(wanted.x, wanted.z), deg_to_rad(turn_rate_degrees) * delta)
	_visual_root.rotation.y = _facing_yaw


func _update_animation() -> void:
	if _rig == null:
		return
	if is_attacking() and _attack_clip != &"":
		# The retimed clip is exactly 1.000 s long and its measured visible
		# contact sits at `release_marker_normalized()`, so clip position IS
		# normalised action time. The action drives that position directly rather
		# than letting the clip free-run at a matched rate, for the same reason
		# Gate C does: the blade is sweeping fast enough at contact that a single
		# frame of drift would be tens of degrees of blade.
		if _current_clip != _attack_clip:
			_current_clip = _attack_clip
			_rig.play(_attack_clip, 1.0, 0.0)
		_rig.animation_player.speed_scale = 0.0
		sync_attack_pose(action_normalized_time())
		return
	if state == State.DEAD:
		return
	if _current_clip == HIT_CLIP and _rig.animation_player.is_playing():
		return
	var speed: float = _planar(velocity).length()
	var wanted: StringName = RUN_CLIP if speed >= 0.20 else IDLE_CLIP
	if wanted != _current_clip:
		_current_clip = wanted
		_rig.play(wanted, 1.0, 0.12)
	_rig.animation_player.speed_scale = (
		clampf(speed / maxf(run_cycle_reference_speed, 0.01), 0.45, 1.60) if wanted == RUN_CLIP else 1.0
	)


## Places the rig at an exact normalised position in the attack clip. The release
## marker uses this immediately before its query, so the pose the query resolves
## against is the pose on screen.
func sync_attack_pose(normalized: float) -> void:
	if _rig == null or _attack_clip == &"":
		return
	var animation_player: AnimationPlayer = _rig.animation_player
	if animation_player.current_animation != String(_attack_clip):
		animation_player.play(_attack_clip, 0.0, 1.0)
		animation_player.speed_scale = 0.0
		_current_clip = _attack_clip
	var length: float = animation_player.get_animation(_attack_clip).length
	animation_player.seek(clampf(normalized, 0.0, 1.0) * length, true)


## Where the attack animation actually is, as a fraction of the clip. Used by the
## Gate D verification to prove the visible contact pose and the release query
## agree instead of assuming they do.
func attack_animation_position() -> float:
	if _rig == null or _current_clip != _attack_clip or _attack_clip == &"":
		return -1.0
	var length: float = _rig.animation_player.get_animation(_attack_clip).length
	return _rig.animation_player.current_animation_position / maxf(length, 0.0001)


## A restrained diagnostic Life bar above the body, so enemy Life can be judged
## while playing. Explicitly NOT the specification §17 HUD, which is Gate F.
func _update_life_bar() -> void:
	if _life_bar == null:
		return
	var visible_now: bool = state != State.DEAD and (aware or life < data.max_life)
	_life_bar.visible = visible_now
	if not visible_now:
		return
	var fill: MeshInstance3D = _life_bar.get_node("Fill") as MeshInstance3D
	var fraction: float = clampf(life / maxf(data.max_life, 0.0001), 0.0, 1.0)
	# Scaling shrinks about the quad's centre, so the bar is shifted left by half
	# of what it lost to keep its left edge fixed. The 1.10 is the fill quad's own
	# width; a bar that emptied from both ends would read as a shrinking pill.
	fill.scale.x = maxf(fraction, 0.001)
	fill.position.x = -(1.0 - fraction) * 1.10 * 0.5
	var material: StandardMaterial3D = fill.material_override as StandardMaterial3D
	material.albedo_color = Color(0.78, 0.26, 0.24).lerp(Color(1.0, 0.86, 0.55), _reaction_flash)
	_life_bar.global_position = global_position + Vector3(0.0, 2.30, 0.0)
	var camera: Camera3D = get_viewport().get_camera_3d()
	if camera != null:
		_life_bar.global_basis = Basis(camera.global_basis.get_rotation_quaternion())


# --- Reset (debug only) ------------------------------------------------------

## Restores the encounter for repeated testing. Gate D owns mechanical death
## only; the trusted Restart flow, save state, and Fallen overlay are Gate F.
func reset_encounter() -> void:
	if _coordinator != null:
		# ADMINISTRATIVE: a debug reset is not a fight event, so D-186's group
		# window is neither owed nor started by it.
		_coordinator.release(self, AttackCoordinator.ReleaseCause.ADMINISTRATIVE, "encounter reset")
	state = State.SPAWN
	state_time = 0.0
	life = data.max_life
	aware = false
	committed = false
	attack_use_id = 0
	_release_fired_for_use = false
	_commitment_cooldown = 0.0
	_reaction_flash = 0.0
	_accepted_use_ids.clear()
	last_release = {}
	last_damage_taken = null
	last_damage_dealt = null
	died_at_msec = 0
	death_animation_started_at_msec = 0
	died_at_physics_frame = -1
	died_at_process_frame = -1
	death_animation_started_at_physics_frame = -1
	death_animation_started_at_process_frame = -1
	attacks_started = 0
	attacks_released = 0
	release_queries = 0
	attacks_hit = 0
	attacks_missed = 0
	permission_requests = 0
	permission_refusals = 0
	damage_taken_events = 0
	hit_reactions = 0
	global_position = _spawn_position
	velocity = Vector3.ZERO
	collision_layer = ENEMY_LAYER
	collision_mask = ENEMY_MASK
	if _target_area != null:
		_target_area.collision_layer = PrototypeTargetable.TARGET_LAYER
		_target_area.monitorable = true
		_target_area.set_soft_targeted(false)
	_agent.target_position = global_position
	if _rig != null:
		_current_clip = IDLE_CLIP
		_rig.play(IDLE_CLIP, 1.0, 0.0)
		_rig.animation_player.speed_scale = 1.0
	_emit("graveblade reset", "restored at %s with %.0f Life" % [str(_spawn_position), life])


# --- Helpers -----------------------------------------------------------------

func state_name() -> String:
	match state:
		State.SPAWN:
			return "SPAWN"
		State.IDLE:
			return "IDLE"
		State.CHASE:
			return "CHASE"
		State.WAIT_FOR_ATTACK_PERMISSION:
			return "WAIT_FOR_ATTACK_PERMISSION"
		State.ATTACK_WINDUP:
			return "ATTACK_WINDUP"
		State.ATTACK_RELEASE:
			return "ATTACK_RELEASE"
		State.ATTACK_RECOVERY:
			return "ATTACK_RECOVERY"
		_:
			return "DEAD"


func _enter(next: State) -> void:
	if next == state:
		state_time = 0.0
		return
	var previous: State = state
	state = next
	state_time = 0.0
	state_changed.emit(previous, next)


func _direction_to_player() -> Vector3:
	if target_player == null:
		return facing_direction()
	var to_player: Vector3 = _planar(target_player.global_position - global_position)
	if to_player.length() < 0.0001:
		return facing_direction()
	return to_player.normalized()


func _apply_planar_velocity(desired: Vector3, delta: float) -> void:
	var current: Vector3 = _planar(velocity)
	var rate: float = acceleration if desired.length() > current.length() else braking
	if desired.length() < 0.001:
		rate = braking
	var next: Vector3 = current.move_toward(desired, rate * delta)
	velocity.x = next.x
	velocity.z = next.z


func _apply_gravity_only(delta: float) -> void:
	velocity.x = 0.0
	velocity.z = 0.0
	if not is_on_floor():
		velocity.y -= _gravity * delta
		move_and_slide()


func _planar(vector: Vector3) -> Vector3:
	return Vector3(vector.x, 0.0, vector.z)


func _planar_distance(a: Vector3, b: Vector3) -> float:
	return Vector2(b.x - a.x, b.z - a.z).length()


func _emit(event: String, detail: String) -> void:
	if _log.is_valid():
		_log.call(event, detail)


# --- Verification seams ------------------------------------------------------
#
# The same pattern Gate B established with `set_stick_override` and Gate C with
# `face_instantly` and `set_cursor_override`: a small, named, commented hook the
# checks use to reach an exact starting state. Ordinary play never touches any of
# them, and none of them can produce an outcome the ordinary path could not.

## Suspends only the DECISION states — spawn, idle, chase, and waiting for
## permission — so a check can park the Graveblade at an exact position and
## distance. An attack already in flight still runs its whole timeline, which is
## the point: the attack under measurement is the ordinary one.
func set_ai_enabled(value: bool) -> void:
	ai_enabled = value
	if not value:
		aware = false
		velocity = Vector3.ZERO


func place_at(at: Vector3) -> void:
	global_position = Vector3(at.x, 0.0, at.z)
	velocity = Vector3.ZERO
	_agent.target_position = global_position


func face_instantly(direction: Vector3) -> void:
	var planar: Vector3 = _planar(direction)
	if planar.length() < 0.0001:
		return
	_facing_yaw = atan2(planar.x, planar.z)
	_visual_root.rotation.y = _facing_yaw


## Runs the ordinary permission request and, if it is granted, the ordinary
## wind-up. Returns whether the attack actually began.
func begin_attack_for_verification() -> bool:
	if state == State.DEAD or _coordinator == null:
		return false
	permission_requests += 1
	if not _coordinator.request(self):
		permission_refusals += 1
		return false
	_begin_windup()
	return true
