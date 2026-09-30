class_name QuickStrikeAction
extends Node
## Prototype Zero — Gate C Quick Strike kernel (specification §10 states, §11
## targeting, §12 timing, cost, and single release).
##
## Owns the attack half of the player's action state: wind-up, release, recovery,
## the buffered and held repeat, cancellation, the stable Skill Use ID, the one
## release query per use, and the Mana cost. Movement, facing, and animation
## remain the player's; this node tells the player what the action needs and the
## player obeys.
##
## THE CONTRACT THIS FILE EXISTS TO KEEP
##
##   * One Skill Use ID per attempt, allocated when the attempt begins and stable
##     through release OR cancellation.
##   * Exactly one release query per released use. Never zero, never two.
##   * The release fires at the animation-aligned marker: `windup_time()` after
##     the attempt starts, which is `release_marker_normalized` of the action —
##     the same normalised position as the visible contact pose in the retimed
##     clip. Timing is advanced on physics frames so the query is deterministic
##     and frame-rate independent; the agreement with the visible pose is then
##     PROVEN by sampling the live AnimationPlayer when the query fires
##     (`gate_c_verification.gd`), not merely asserted here.
##   * Movement before the marker cancels with no effect and drops the buffered
##     repeat. Movement after the marker keeps the effect and only ends recovery.
##   * Insufficient Mana stops the attempt from beginning at all, and consumes
##     no input as though the attack had happened.
##
## Gate D added the damage half. The release still resolves onto ONE target and
## still runs exactly one query per use; what changed is that when that target
## reports a `combat_actor()`, the release now builds exactly one `DamageEvent`
## and hands it over. An inert practice post reports no actor and therefore still
## takes no damage, which is how the same swing can be a Gate C regression check
## and a Gate D kill.
##
## Roguelite I13 (D-318) moved exactly one thing: the number that event carries. It
## is the player's `outgoing_hit_damage()` of the equipped weapon's RAW base, asked
## at the release that creates the event — so a Global Damage total the run's build
## holds reaches the Hit exactly once, and a weapon equipped after the total was
## written is evaluated through its own base with nothing to refresh. A refused
## answer is reported and deals no damage at all; it is never replaced by a guess.

enum Phase {
	READY,
	APPROACH,
	WINDUP,
	RELEASE,
	RECOVERY,
}

## THE RUNTIME RECORD THIS ACTION OBEYS. It is a PRIVATE per-action copy from
## the moment the node enters the tree; see `adopt_private_data()`.
@export var data: QuickStrikeData

## The canonical authored record the runtime copy was taken from — normally
## `data/prototype_zero/quick_strike.tres`. It is READ ONLY. Anything that scales
## a value for a setting must compute from THIS and write to `data`, so a
## repeated change recomputes from the authored number instead of compounding on
## its own previous result.
var canonical_data: QuickStrikeData = null

## Specification §12.2. Gate C always runs at 0.0; Gate E owns the passive that
## raises it. Every phase, the animation rate, the repeat cadence, and the cancel
## windows are derived from it, so nothing can stay locked after the visual ends.
var increased_attack_speed: float = 0.0

var phase: Phase = Phase.READY
var phase_time: float = 0.0
var use_id: int = 0

## The explicit target this attempt is committed to, if any.
var target: PrototypeTargetable = null
## Planar direction the attempt is aimed along.
var aim: Vector3 = Vector3.FORWARD
var attack_in_place: bool = false

var holding: bool = false
## A held attack button that a movement command has superseded. It commands again
## only after a genuine re-press, exactly as a held stick does for movement.
var holding_stale: bool = false
var buffered: bool = false

# --- Instrumentation (specification §22) -------------------------------------
var uses_started: int = 0
var uses_released: int = 0
var uses_cancelled_before_release: int = 0
var recoveries_cancelled: int = 0
var release_queries: int = 0
var rejected_for_mana: int = 0
var buffered_consumed: int = 0
var mana_spent_total: float = 0.0
var last_release: Dictionary = {}
var last_damage_dealt: DamageEvent = null
## Never more than `uses_released`, and never more than one per Skill Use.
var damage_events: int = 0
var last_acquisition: String = "none"
var last_cancel: String = "none"
var last_repeat_interval: float = 0.0

var _player: Node                     ## PrototypePlayer; typed loosely to avoid a cycle
var _acquire: TargetAcquisition
var _next_use_id: int = 1
var _release_fired_for_use: bool = false
var _mana_spent_for_use: bool = false
var _facing_locked: bool = false
var _time_since_last_release: float = 0.0
var _released_at_least_once: bool = false
var _approach_requested_once: bool = false
## Latches while Mana is short, so a HELD attack produces one refusal rather than
## sixty per second. Specification §12.4 asks for "one restrained invalid cue".
var _mana_refusal_latched: bool = false
var _aim_provider: Callable = Callable()
var _candidate_provider: Callable = Callable()
var _log: Callable = Callable()
var _data_is_private: bool = false

signal use_started(id: int)
signal use_released(id: int, outcome: Dictionary)
signal use_cancelled(id: int, reason: String, before_release: bool)
signal phase_changed(new_phase: Phase)


func _ready() -> void:
	adopt_private_data()


## D-191. Godot caches a loaded Resource, so every instance of
## `prototype_player.tscn` in one process is handed the SAME `QuickStrikeData`
## object: the canonical `data/prototype_zero/quick_strike.tres`. That was
## harmless while nothing wrote to it, and stopped being harmless when Gate F
## scaled the soft-target cone and acquisition distance on it for the §21 aim
## assistance setting. The write went THROUGH to the canonical record, so the
## next laboratory in the same process captured its baseline from the
## already-scaled object and scaled it again:
##
##   assistance 100:  first room 78.0 deg / 6.00 m,  next room 93.6 deg / 7.20 m
##   assistance   0:  first room 39.0 deg / 3.00 m,  next room 23.4 deg / 1.80 m
##
## The default hid it perfectly, because 70 / 100 scales by exactly 1.000.
##
## Each action therefore takes a private runtime copy the moment it enters the
## tree, and keeps the canonical record beside it as the read-only baseline. Two
## players cannot reach each other's numbers, a room replacement starts from the
## authored 65.0 deg / 5.0 m every time, and the canonical `.tres` is never
## written to at all.
func adopt_private_data() -> void:
	if data == null or _data_is_private:
		return
	canonical_data = data
	var private: QuickStrikeData = data.duplicate(true) as QuickStrikeData
	# A duplicate must not inherit the cache entry of the file it came from,
	# or "private" would be a word rather than a fact.
	if not private.resource_path.is_empty():
		private.resource_path = ""
	private.resource_name = "%s (runtime copy)" % (
		data.resource_name if data.resource_name != "" else "quick_strike"
	)
	data = private
	_data_is_private = true


## True once this action owns its own record. Read by the checks rather than
## inferred from object identity alone.
func data_is_private() -> bool:
	return _data_is_private and data != canonical_data


func setup(
	player: Node,
	acquisition: TargetAcquisition,
	aim_provider: Callable,
	candidate_provider: Callable,
	log_sink: Callable
) -> void:
	_player = player
	_acquire = acquisition
	_aim_provider = aim_provider
	_candidate_provider = candidate_provider
	_log = log_sink
	var problem: String = "quick strike data is missing" if data == null else data.problem()
	assert(problem.is_empty(), "QuickStrikeAction: %s" % problem)


# --- Derived timing ----------------------------------------------------------

func speed_multiplier() -> float:
	return 1.0 + maxf(increased_attack_speed, -0.95)


func effective_action_time() -> float:
	return data.effective_action_time(increased_attack_speed)


func windup_time() -> float:
	return data.windup_time() / speed_multiplier()


func release_window_time() -> float:
	return data.release_window / speed_multiplier()


func recovery_time() -> float:
	return data.recovery_time() / speed_multiplier()


## Seconds until the action becomes legal again. Used for the input buffer.
func time_until_ready() -> float:
	match phase:
		Phase.WINDUP:
			return maxf(windup_time() - phase_time, 0.0) + release_window_time() + recovery_time()
		Phase.RELEASE:
			return maxf(release_window_time() - phase_time, 0.0) + recovery_time()
		Phase.RECOVERY:
			return maxf(recovery_time() - phase_time, 0.0)
		_:
			return 0.0


## Normalised position inside the whole action, which is also normalised time in
## the retimed animation clip.
func action_normalized_time() -> float:
	match phase:
		Phase.WINDUP:
			return clampf(phase_time / maxf(windup_time(), 0.0001), 0.0, 1.0) * data.release_marker_normalized
		Phase.RELEASE:
			return data.release_marker_normalized + clampf(
				phase_time / maxf(release_window_time(), 0.0001), 0.0, 1.0
			) * (data.release_window / data.action_time)
		Phase.RECOVERY:
			var released_through: float = data.release_marker_normalized + data.release_window / data.action_time
			return released_through + clampf(
				phase_time / maxf(recovery_time(), 0.0001), 0.0, 1.0
			) * (data.recovery_time() / data.action_time)
		_:
			return 0.0


func is_attacking() -> bool:
	return phase == Phase.WINDUP or phase == Phase.RELEASE or phase == Phase.RECOVERY


func is_approaching() -> bool:
	return phase == Phase.APPROACH


func is_committed() -> bool:
	return phase == Phase.WINDUP


func facing_is_locked() -> bool:
	return _facing_locked


func busy() -> bool:
	return phase != Phase.READY


# --- Input -------------------------------------------------------------------

## A genuine press of the Quick Strike control. Always a new intent.
func press() -> void:
	holding = true
	holding_stale = false
	# A deliberate press always earns its own answer, including a refusal.
	_mana_refusal_latched = false
	match phase:
		Phase.READY:
			_begin_attempt("pressed")
		Phase.APPROACH:
			# Already approaching this target; re-press just refreshes the aim.
			_refresh_approach_aim()
		_:
			if time_until_ready() <= data.input_buffer:
				if not buffered:
					buffered = true
					_emit("quick strike buffered", "use %d, %.3f s before the next legal action" % [
						use_id, time_until_ready(),
					])
			else:
				_emit("quick strike ignored", "use %d still has %.3f s to run, outside the %.2f s buffer" % [
					use_id, time_until_ready(), data.input_buffer,
				])


func release_input() -> void:
	holding = false
	holding_stale = false


func set_attack_in_place(value: bool) -> void:
	attack_in_place = value


## A newer movement intent. Specification §10: before the marker this cancels the
## attempt outright; after it the effect stands and only recovery ends.
func cancel_for_movement(reason: String) -> void:
	# A deliberate movement command outranks an old attack repeat (§10), so a
	# still-held attack button stops commanding until it is pressed again.
	if holding:
		holding_stale = true
	buffered = false
	match phase:
		Phase.APPROACH:
			_emit("approach cancelled", "%s" % reason)
			last_cancel = "approach: %s" % reason
			_end_attempt()
		Phase.WINDUP:
			uses_cancelled_before_release += 1
			last_cancel = "wind-up at %.3f s of %.3f s: %s" % [phase_time, windup_time(), reason]
			_emit("quick strike cancelled", "use %d cancelled %.3f s into a %.3f s wind-up (%s); no release" % [
				use_id, phase_time, windup_time(), reason,
			])
			use_cancelled.emit(use_id, reason, true)
			_end_attempt()
		Phase.RELEASE, Phase.RECOVERY:
			recoveries_cancelled += 1
			last_cancel = "recovery after use %d: %s" % [use_id, reason]
			_emit("recovery cancelled", "use %d kept its release; %s" % [use_id, reason])
			use_cancelled.emit(use_id, reason, false)
			_end_attempt()
		_:
			pass


## Hard stop with no "the hit stands" nuance: focus loss, disconnect, teleport.
func clear(reason: String) -> void:
	if phase == Phase.WINDUP:
		uses_cancelled_before_release += 1
		use_cancelled.emit(use_id, reason, true)
	holding = false
	holding_stale = false
	buffered = false
	last_cancel = reason
	# The repeat trace measures consecutive releases of one held run. A hard stop
	# ends that run, so the next release must not report the pause as a cadence.
	_released_at_least_once = false
	_time_since_last_release = 0.0
	last_repeat_interval = 0.0
	_end_attempt()


# --- Advance -----------------------------------------------------------------

## Phase boundaries CARRY their remainder instead of truncating to the physics
## frame they were crossed on. Without that, every boundary rounded up by up to
## one tick and a held repeat ran at 0.833 s against a 0.800 s action — a 4%
## drift that would have quietly muddied the 0.80 s to 0.64 s change Gate E has
## to make perceptible.
func tick(delta: float) -> void:
	if _mana_refusal_latched and _player.has_mana_for(data.mana_cost):
		_mana_refusal_latched = false
	_time_since_last_release += delta
	phase_time += delta
	# Bounded: each pass either advances a phase or stops. The guard only exists
	# so an absurdly small action time cannot spin.
	for _pass: int in 8:
		if not _advance_phase():
			return


## Returns true when the phase changed and the leftover time should be applied
## to whatever comes next.
func _advance_phase() -> bool:
	match phase:
		Phase.APPROACH:
			_tick_approach()
			return false
		Phase.WINDUP:
			if phase_time < windup_time():
				return false
			var after_windup: float = phase_time - windup_time()
			_fire_release()
			phase_time = after_windup
			return true
		Phase.RELEASE:
			if phase_time < release_window_time():
				return false
			var after_release: float = phase_time - release_window_time()
			_enter(Phase.RECOVERY)
			phase_time = after_release
			return true
		Phase.RECOVERY:
			if phase_time < recovery_time():
				return false
			var after_recovery: float = phase_time - recovery_time()
			_finish_action()
			phase_time = after_recovery
			return true
		Phase.READY:
			var carried: float = phase_time
			if buffered:
				buffered = false
				buffered_consumed += 1
				_begin_attempt("buffered")
			elif holding and not holding_stale:
				_begin_attempt("held repeat")
			else:
				return false
			if phase == Phase.WINDUP:
				phase_time = carried
				return true
			return false
	return false


func _tick_approach() -> void:
	if target == null or not target.is_valid_target():
		_emit("target cleared", "the approach target became invalid; obeying the newest input")
		last_acquisition = "cleared: target became invalid"
		_end_attempt()
		return
	# Range is re-evaluated every frame against the target's CURRENT position,
	# never the position it had when the approach began (specification §11.1).
	var distance: float = _planar_distance(_player.global_position, target.global_position)
	if distance <= data.reach - data.approach_stop_margin:
		_begin_windup("approach reached %.2f m" % distance)


# --- Attempt lifecycle -------------------------------------------------------

func _begin_attempt(source: String) -> void:
	var request: Dictionary = _aim_provider.call()
	target = request.get("target", null) as PrototypeTargetable
	aim = request.get("direction", _player_forward()) as Vector3
	last_acquisition = String(request.get("reason", "no target"))

	if target != null and not attack_in_place:
		var distance: float = _planar_distance(_player.global_position, target.global_position)
		if distance > data.reach - data.approach_stop_margin:
			_approach_requested_once = true
			_enter(Phase.APPROACH)
			_emit("approach started", "%s -> %s at %.2f m (%s)" % [
				source, target.target_display_name(), distance, last_acquisition,
			])
			return

	if target != null and attack_in_place:
		var held_distance: float = _planar_distance(_player.global_position, target.global_position)
		if held_distance > data.reach:
			_emit("attack in place", "%s is %.2f m away, beyond the %.2f m reach; swinging anyway" % [
				target.target_display_name(), held_distance, data.reach,
			])
	_begin_windup(source)


func _refresh_approach_aim() -> void:
	var request: Dictionary = _aim_provider.call()
	var refreshed: PrototypeTargetable = request.get("target", null) as PrototypeTargetable
	if refreshed != null and refreshed != target:
		target = refreshed
		last_acquisition = String(request.get("reason", "no target"))
		_emit("target changed", "approach retargeted to %s (%s)" % [
			target.target_display_name(), last_acquisition,
		])


func _begin_windup(source: String) -> void:
	# Specification §12.4: insufficient Mana stops the action from beginning, and
	# no input is consumed as though the attack occurred.
	if not _player.has_mana_for(data.mana_cost):
		if not _mana_refusal_latched:
			_mana_refusal_latched = true
			rejected_for_mana += 1
			_emit("quick strike refused", "%.1f of %.0f Mana needed; the action did not begin" % [
				_player.mana, data.mana_cost,
			])
		buffered = false
		_end_attempt()
		return
	_mana_refusal_latched = false

	use_id = _next_use_id
	_next_use_id += 1
	uses_started += 1
	_release_fired_for_use = false
	_mana_spent_for_use = false
	_facing_locked = false
	_approach_requested_once = false

	if target != null:
		aim = _planar(target.global_position - _player.global_position)
		if aim.length() < 0.0001:
			aim = _player_forward()
	aim = aim.normalized()

	_enter(Phase.WINDUP)
	use_started.emit(use_id)
	_emit("quick strike started", "use %d, %s, %s, aim %.0f deg%s" % [
		use_id, source,
		("target %s" % target.target_display_name()) if target != null else "no target (directional swing)",
		rad_to_deg(atan2(aim.x, aim.z)),
		", attack in place" if attack_in_place else "",
	])


## The one release query for this Skill Use. Called exactly once, from the
## animation-aligned marker.
func _fire_release() -> void:
	assert(not _release_fired_for_use, "QuickStrikeAction: use %d tried to release twice" % use_id)
	_release_fired_for_use = true
	_facing_locked = true

	# Specification §12.1: "resolved once from an animation release marker placed
	# at the visible contact moment". The marker is applied to the rig FIRST, so
	# the query runs against the pose the player can see rather than against a
	# pose the renderer will reach one frame later.
	_player.sync_attack_pose(data.release_marker_normalized)

	# Specification §12.4 and §12.1: the cost belongs to the Skill Use that
	# actually happens. A wind-up cancelled before this line spends nothing, and
	# this line can never run twice for one use.
	assert(not _mana_spent_for_use, "QuickStrikeAction: use %d tried to spend Mana twice" % use_id)
	_mana_spent_for_use = true
	var spent: float = _player.spend_mana(data.mana_cost)
	mana_spent_total += spent

	var origin: Vector3 = _player.global_position
	var facing: Vector3 = _player.facing_direction()
	var candidates: Array[PrototypeTargetable] = _candidate_provider.call()
	var outcome: Dictionary = _acquire.resolve_release(origin, facing, target, candidates, data)
	release_queries += 1
	uses_released += 1

	outcome["use_id"] = use_id
	outcome["mana_spent"] = spent
	outcome["facing_degrees"] = rad_to_deg(atan2(facing.x, facing.z))
	last_release = outcome

	# One resolved target, at most one DamageEvent. `combat_actor()` returning
	# null is the whole difference between striking an inert practice post and
	# striking something with Life: the query, the arc, the reach, and the Skill
	# Use ID are identical either way.
	var struck: PrototypeTargetable = outcome["target"] as PrototypeTargetable
	if struck != null:
		struck.note_release(use_id)
		var actor: Node = struck.combat_actor()
		if actor != null:
			# Roguelite I13 (D-318): the Hit's damage is committed HERE, from the
			# weapon's raw base through the player's one outgoing-damage query. A
			# refused answer is reported and deals nothing — never a guessed number.
			var outgoing: PlayerStatValue = _player.outgoing_hit_damage(_player.physical_damage)
			if outgoing.ok:
				var event: DamageEvent = DamageEvent.physical(
					use_id, _player, actor, outgoing.value
				)
				outcome["event"] = event
				last_damage_dealt = event
				damage_events += 1
				actor.call("receive_damage", event)
			else:
				outcome["damage_refused"] = outgoing.failure_reason
				push_error("QuickStrikeAction: use %d dealt no damage; its outgoing damage was refused: %s"
					% [use_id, outgoing.failure_reason])

	last_repeat_interval = _time_since_last_release if _released_at_least_once else 0.0
	_released_at_least_once = true
	_time_since_last_release = 0.0

	_enter(Phase.RELEASE)
	use_released.emit(use_id, outcome)
	_emit("quick strike released", "use %d %s — %s; %.0f Mana spent, %.0f left%s" % [
		use_id, outcome["outcome"], outcome["reason"], spent, _player.mana,
		("; %.3f s since the previous release" % last_repeat_interval) if last_repeat_interval > 0.0 else "",
	])

	# Specification §9.5: after release an already held movement intent may
	# resume immediately, which is what lets it cancel the remaining recovery.
	_player.revive_held_movement()


func _finish_action() -> void:
	_emit("quick strike complete", "use %d finished a %.3f s action" % [use_id, effective_action_time()])
	_end_attempt()


func _end_attempt() -> void:
	target = null
	_facing_locked = false
	_approach_requested_once = false
	_enter(Phase.READY)


func _enter(next: Phase) -> void:
	if next == phase and next != Phase.READY:
		return
	phase = next
	phase_time = 0.0
	phase_changed.emit(phase)


# --- Helpers -----------------------------------------------------------------

func phase_name() -> String:
	match phase:
		Phase.APPROACH:
			return "APPROACH_TARGET"
		Phase.WINDUP:
			return "ATTACK_WINDUP"
		Phase.RELEASE:
			return "ATTACK_RELEASE"
		Phase.RECOVERY:
			return "ATTACK_RECOVERY"
		_:
			return "READY"


func _player_forward() -> Vector3:
	return _player.facing_direction()


func _planar(vector: Vector3) -> Vector3:
	return Vector3(vector.x, 0.0, vector.z)


func _planar_distance(a: Vector3, b: Vector3) -> float:
	return Vector2(b.x - a.x, b.z - a.z).length()


func _emit(event: String, detail: String) -> void:
	if _log.is_valid():
		_log.call(event, detail)
