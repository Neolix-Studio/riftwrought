class_name FirstMvpSkillAction
extends Node
## First-MVP — Gate 1E: ONE Skill machine, three Skills (D-219).
##
## The brief: "Every direct Skill follows Input -> Wind-up -> Release ->
## Recovery. Costs are checked/paid at use start. Movement normally cannot
## cancel committed wind-up but may cancel unnecessary recovery after release."
## Those are properties of THIS FILE, so no individual Skill can get them wrong.
##
## MODELLED ON `QuickStrikeAction`, WHICH IS NOT MODIFIED AND NOT REPLACED.
## Prototype Zero's kernel is closed, accepted, and playtested through Gates C
## to F and again in Gate 1D; migrating Quick Strike onto this machine would
## edit proven code to gain nothing Gate 1E needs. So the phase enum, the
## remainder-carrying `tick()`, the `_release_fired_for_use` / `_mana_spent_for_use`
## latches, the buffered and held repeat, the animation-aligned marker, and the
## Mana rule are all deliberately the SAME SHAPE here, so that a later
## consolidation is a merge rather than a translation. Where this file differs
## from Quick Strike, it differs because a heavy Area attack or a projectile
## genuinely needs something Quick Strike does not — and each of those places
## says so.
##
## WHAT IS GENUINELY DIFFERENT, AND WHY:
##
##   * RELEASE RESOLUTION IS PER ARCHETYPE. Quick Strike resolves one target
##     through `TargetAcquisition.resolve_release()`, which is typed
##     `data: QuickStrikeData` and returns exactly one target. An Area Hit needs
##     many and a projectile needs none at release time, so this file resolves
##     its own. `TargetAcquisition` is READ (its `TARGET_MASK` and
##     `is_obstructed`) and never edited — Gates C, D, E and F call its existing
##     functions directly and changing a signature would break them.
##   * MELEE_SINGLE IS DECLARED AND REFUSED. The archetype exists because it is
##     the canonical shape Quick Strike occupies and the Skill library names it,
##     but this machine will not run one: re-implementing the proven contact
##     kernel is exactly the duplication the brief asks to avoid. The refusal is
##     plain-language and reachable, and the verification proves it reachable —
##     a guard nothing can reach is not a guard (the D-215 lesson).
##   * NO APPROACH FOR A RANGED SKILL. The brief: "Splinter Shot and Emberbolt
##     should normally activate from current position." Faultbreaker may
##     approach, because it is contact melee. `data.archetype` decides, not a
##     per-Skill branch at the call site.
##
## PER-USE TARGETING, D-193, PRODUCTION RULE. The aim provider is called ONCE
## per attempt and nothing it returns survives into the next attempt. There is
## no "current target" field a later frame can read, so a held or repeated use
## re-evaluates the cursor every time simply by asking again. This copies
## `BrokenWatchSlice._mouse_aim_provider()`, which is the production pattern,
## and deliberately NOT `PrototypeZeroRoom.soft_target`, which is laboratory
## tooling that conflates controller retention with a persistent mouse
## indicator.
##
## PRIVATE RUNTIME RECORD, D-191. Godot caches a loaded Resource, so every
## instance of a Skill in one process would otherwise share one record and a
## runtime scale would compound across scene reloads (measured: 78.0 deg /
## 6.00 m becoming 93.6 deg / 7.20 m). This node duplicates its record on
## entering the tree and keeps the canonical one beside it, read-only.
##
## OUTGOING DAMAGE, Roguelite I13 (D-318). Each Hit's base — the equipped weapon's
## raw damage scaled by the record, or a Spell's own damage — is evaluated through
## the player's `outgoing_hit_damage()` at the moment the damage is committed: once
## per area release, for every target it strikes, and once per projectile at launch,
## where the projectile stores the answer. A projectile in flight therefore keeps the
## damage it launched with, whatever the build does afterwards. A refused answer
## deals nothing and launches nothing. No record is written: the scale, the Spell's
## damage and the weapon's damage are all read.

enum Phase {
	READY,
	APPROACH,
	WINDUP,
	RELEASE,
	RECOVERY,
}

## The runtime record this action obeys — a PRIVATE per-action copy.
@export var data: FirstMvpSkillData
## The authored record the copy was taken from. READ ONLY.
var canonical_data: FirstMvpSkillData = null

## Increased Attack and Cast Speed from passives. Gate 1E's only contributor is
## First Fracture at 0.10; every phase, the animation rate, the repeat cadence,
## and the cancel windows derive from it.
var increased_attack_speed: float = 0.0

var phase: Phase = Phase.READY
var phase_time: float = 0.0
var use_id: int = 0

var target: PrototypeTargetable = null
var aim: Vector3 = Vector3.FORWARD
var attack_in_place: bool = false

var holding: bool = false
var holding_stale: bool = false
var buffered: bool = false

# --- Instrumentation, the same fields Quick Strike carries --------------------
var uses_started: int = 0
var uses_released: int = 0
var uses_cancelled_before_release: int = 0
var recoveries_cancelled: int = 0
var release_queries: int = 0
var rejected_for_mana: int = 0
var rejected_for_weapon: int = 0
var rejected_for_archetype: int = 0
var buffered_consumed: int = 0
var mana_spent_total: float = 0.0
var projectiles_spawned: int = 0
var damage_events: int = 0
var last_release: Dictionary = {}
var last_damage_dealt: FirstMvpDamageEvent = null
var last_acquisition: String = "none"
var last_cancel: String = "none"
var last_refusal: String = "none"
var last_repeat_interval: float = 0.0

var _player: Node
var _acquire: TargetAcquisition
var _projectile_parent: Node
var _weapon_family_provider: Callable = Callable()
var _next_use_id: int = 1
var _release_fired_for_use: bool = false
var _mana_spent_for_use: bool = false
var _facing_locked: bool = false
var _time_since_last_release: float = 0.0
var _released_at_least_once: bool = false
var _mana_refusal_latched: bool = false
var _weapon_refusal_latched: bool = false
var _aim_provider: Callable = Callable()
var _candidate_provider: Callable = Callable()
var _log: Callable = Callable()
var _data_is_private: bool = false

signal use_started(id: int)
signal use_released(id: int, outcome: Dictionary)
signal use_cancelled(id: int, reason: String, before_release: bool)
signal use_refused(reason: String)
signal phase_changed(new_phase: Phase)


func _ready() -> void:
	adopt_private_data()


## D-191's rule, applied to every Skill rather than only to Quick Strike.
func adopt_private_data() -> void:
	if data == null or _data_is_private:
		return
	canonical_data = data
	var private: FirstMvpSkillData = data.duplicate(true) as FirstMvpSkillData
	# A duplicate must not inherit the cache entry of the file it came from, or
	# "private" would be a word rather than a fact.
	if not private.resource_path.is_empty():
		private.resource_path = ""
	private.resource_name = "%s (runtime copy)" % (
		data.resource_name if data.resource_name != "" else String(data.skill_id)
	)
	data = private
	_data_is_private = true


func data_is_private() -> bool:
	return _data_is_private and data != canonical_data


func setup(
	player: Node,
	acquisition: TargetAcquisition,
	aim_provider: Callable,
	candidate_provider: Callable,
	log_sink: Callable,
	projectile_parent: Node = null,
	weapon_family_provider: Callable = Callable()
) -> void:
	_player = player
	_acquire = acquisition
	_aim_provider = aim_provider
	_candidate_provider = candidate_provider
	_log = log_sink
	_projectile_parent = projectile_parent if projectile_parent != null else get_parent()
	_weapon_family_provider = weapon_family_provider
	var problem: String = "skill data is missing" if data == null else data.problem()
	assert(problem.is_empty(), "FirstMvpSkillAction: %s" % problem)


# --- Derived timing, identical in shape to QuickStrikeAction ------------------

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
## the presenting clip.
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


# --- Weapon requirement --------------------------------------------------------

## The equipped family, asked of the owner rather than stored, so equipping a
## different weapon takes effect on the very next use with nothing to refresh.
func equipped_family() -> StringName:
	if _weapon_family_provider.is_valid():
		return _weapon_family_provider.call() as StringName
	return &""


func requirement_is_met() -> bool:
	if not data.has_weapon_requirement():
		return true
	return data.accepts_weapon_family(equipped_family())


func requirement_status() -> String:
	if requirement_is_met():
		return "Ready"
	return data.requirement_text


# --- Input ---------------------------------------------------------------------

func press() -> void:
	holding = true
	holding_stale = false
	_mana_refusal_latched = false
	_weapon_refusal_latched = false
	match phase:
		Phase.READY:
			_begin_attempt("pressed")
		Phase.APPROACH:
			_refresh_approach_aim()
		_:
			if time_until_ready() <= data.input_buffer:
				if not buffered:
					buffered = true
					_emit("%s buffered" % data.display_name.to_lower(), "use %d, %.3f s before the next legal action" % [
						use_id, time_until_ready(),
					])
			else:
				_emit("%s ignored" % data.display_name.to_lower(), "use %d still has %.3f s to run, outside the %.2f s buffer" % [
					use_id, time_until_ready(), data.input_buffer,
				])


func release_input() -> void:
	holding = false
	holding_stale = false


func set_attack_in_place(value: bool) -> void:
	attack_in_place = value


## The brief: "Movement normally cannot cancel committed wind-up but may cancel
## unnecessary recovery after release." Identical to Quick Strike's §10 rule.
func cancel_for_movement(reason: String) -> void:
	if holding:
		holding_stale = true
	buffered = false
	match phase:
		Phase.APPROACH:
			_emit("approach cancelled", reason)
			last_cancel = "approach: %s" % reason
			_end_attempt()
		Phase.WINDUP:
			uses_cancelled_before_release += 1
			last_cancel = "wind-up at %.3f s of %.3f s: %s" % [phase_time, windup_time(), reason]
			_emit("%s cancelled" % data.display_name.to_lower(),
				"use %d cancelled %.3f s into a %.3f s wind-up (%s); no release, no Mana spent" % [
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


func clear(reason: String) -> void:
	if phase == Phase.WINDUP:
		uses_cancelled_before_release += 1
		use_cancelled.emit(use_id, reason, true)
	holding = false
	holding_stale = false
	buffered = false
	last_cancel = reason
	_released_at_least_once = false
	_time_since_last_release = 0.0
	last_repeat_interval = 0.0
	_end_attempt()


# --- Advance -------------------------------------------------------------------

## Phase boundaries CARRY their remainder rather than truncating to the physics
## frame they were crossed on — Quick Strike's own rule, for the same reason: a
## truncating boundary drifts a held repeat by up to one tick per phase.
func tick(delta: float) -> void:
	if _mana_refusal_latched and _player.has_mana_for(data.mana_cost):
		_mana_refusal_latched = false
	_time_since_last_release += delta
	phase_time += delta
	for _pass: int in 8:
		if not _advance_phase():
			return


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
	var distance: float = _planar_distance(_player.global_position, target.global_position)
	if distance <= data.reach - data.approach_stop_margin:
		_begin_windup("approach reached %.2f m" % distance)


# --- Attempt lifecycle ---------------------------------------------------------

func _begin_attempt(source: String) -> void:
	# MELEE_SINGLE belongs to the proven Quick Strike kernel and is refused here
	# rather than re-implemented. Reachable, and proved reachable.
	if data.archetype == FirstMvpSkillData.Archetype.MELEE_SINGLE:
		rejected_for_archetype += 1
		last_refusal = "%s is a single-target contact Skill; it runs on the proven Quick Strike kernel, not on this machine" % data.display_name
		_emit("%s refused" % data.display_name.to_lower(), last_refusal)
		use_refused.emit(last_refusal)
		_end_attempt()
		return

	var request: Dictionary = _aim_provider.call()
	target = request.get("target", null) as PrototypeTargetable
	aim = request.get("direction", _player_forward()) as Vector3
	last_acquisition = String(request.get("reason", "no target"))

	# The brief: a ranged Skill "should normally activate from current position".
	# Only a contact-melee archetype may walk to its target first.
	var may_approach: bool = data.archetype == FirstMvpSkillData.Archetype.MELEE_AREA
	if may_approach and target != null and not attack_in_place:
		var distance: float = _planar_distance(_player.global_position, target.global_position)
		if distance > data.reach - data.approach_stop_margin:
			_enter(Phase.APPROACH)
			_emit("approach started", "%s -> %s at %.2f m (%s)" % [
				source, target.target_display_name(), distance, last_acquisition,
			])
			return
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
	# The brief: "Costs are checked/paid at use start" and "Skills become
	# enabled/disabled truthfully according to requirements". Both gates sit
	# BEFORE the action begins, so a refused use consumes no input and spends
	# nothing — Prototype Zero specification §12.4's rule, unchanged.
	if not requirement_is_met():
		if not _weapon_refusal_latched:
			_weapon_refusal_latched = true
			rejected_for_weapon += 1
			last_refusal = data.requirement_text
			_emit("%s refused" % data.display_name.to_lower(), "%s; the action did not begin" % data.requirement_text)
			use_refused.emit(last_refusal)
		buffered = false
		_end_attempt()
		return
	if not _player.has_mana_for(data.mana_cost):
		if not _mana_refusal_latched:
			_mana_refusal_latched = true
			rejected_for_mana += 1
			last_refusal = "%.1f of %.0f Mana needed" % [_player.mana, data.mana_cost]
			_emit("%s refused" % data.display_name.to_lower(), "%s; the action did not begin" % last_refusal)
			use_refused.emit(last_refusal)
		buffered = false
		_end_attempt()
		return
	_mana_refusal_latched = false
	_weapon_refusal_latched = false

	use_id = _next_use_id
	_next_use_id += 1
	uses_started += 1
	_release_fired_for_use = false
	_mana_spent_for_use = false
	_facing_locked = false

	if target != null and data.archetype != FirstMvpSkillData.Archetype.PROJECTILE:
		aim = _planar(target.global_position - _player.global_position)
	if aim.length() < 0.0001:
		aim = _player_forward()
	aim = aim.normalized()

	_enter(Phase.WINDUP)
	use_started.emit(use_id)
	_emit("%s started" % data.display_name.to_lower(), "use %d, %s, %s, aim %.0f deg" % [
		use_id, source,
		("target %s" % target.target_display_name()) if target != null else "no target (directional)",
		rad_to_deg(atan2(aim.x, aim.z)),
	])


## The one release for this Skill Use. Called exactly once, from the
## animation-aligned marker.
func _fire_release() -> void:
	# A real boolean, not only an assert: `assert()` is stripped in release
	# builds and this guard must hold in a shipped game.
	if _release_fired_for_use:
		return
	_release_fired_for_use = true
	_facing_locked = true

	# The marker is applied to the rig FIRST, so the query runs against the pose
	# the player can see rather than one the renderer reaches a frame later.
	if _player.has_method("sync_attack_pose"):
		_player.call("sync_attack_pose", data.release_marker_normalized)

	if not _mana_spent_for_use:
		_mana_spent_for_use = true
		var spent: float = _player.spend_mana(data.mana_cost)
		mana_spent_total += spent
		last_release = {"mana_spent": spent}

	var outcome: Dictionary = {}
	match data.archetype:
		FirstMvpSkillData.Archetype.MELEE_AREA:
			outcome = _resolve_area()
		FirstMvpSkillData.Archetype.PROJECTILE:
			outcome = _spawn_projectile()
		_:
			outcome = {"outcome": "refused", "reason": "unsupported archetype", "targets": 0}
	release_queries += 1
	uses_released += 1

	outcome["use_id"] = use_id
	outcome["mana_spent"] = float(last_release.get("mana_spent", 0.0))
	outcome["facing_degrees"] = rad_to_deg(atan2(_player.facing_direction().x, _player.facing_direction().z))
	last_release = outcome

	last_repeat_interval = _time_since_last_release if _released_at_least_once else 0.0
	_released_at_least_once = true
	_time_since_last_release = 0.0

	_enter(Phase.RELEASE)
	use_released.emit(use_id, outcome)
	_emit("%s released" % data.display_name.to_lower(), "use %d %s — %s; %.0f Mana spent, %.0f left" % [
		use_id, outcome.get("outcome", "resolved"), outcome.get("reason", ""),
		float(outcome["mana_spent"]), _player.mana,
	])

	if _player.has_method("revive_held_movement"):
		_player.call("revive_held_movement")


## An Area Hit centred on the character. Every valid target inside the radius,
## up to `maximum_targets`, receives exactly one `FirstMvpDamageEvent` — the
## same one-event-per-target-per-use rule Quick Strike keeps for its single
## target.
##
## Obstruction is honoured through `TargetAcquisition.is_obstructed()`, so a
## Graveblade behind a wall inside the radius is not hit. That function is READ,
## never edited.
func _resolve_area() -> Dictionary:
	var origin: Vector3 = _player.global_position
	var candidates: Array[PrototypeTargetable] = _candidate_provider.call()
	var struck: Array[PrototypeTargetable] = []
	var blocked: int = 0
	for candidate: PrototypeTargetable in candidates:
		if struck.size() >= data.maximum_targets:
			break
		if candidate == null or not candidate.is_valid_target():
			continue
		if _planar_distance(origin, candidate.global_position) > data.area_radius:
			continue
		# THE OBSTRUCTION RAY STARTS AT CHEST HEIGHT, NOT AT THE FEET.
		# `_player.global_position` is the character's FEET — the capsule sits at
		# +0.9 local — and every ground plate's top face is at exactly y = 0.0, so
		# a ray cast from `origin` starts precisely ON the ground plane and can be
		# reported as striking it. `TargetAcquisition.soft_target()` raises its own
		# origin by 1.10 m for exactly this reason and this is the same
		# convention; only the RAY moves, never the distance test below, which is
		# planar and must keep using the unraised origin.
		if _acquire != null and _acquire.is_obstructed(
			origin + Vector3.UP * 1.10, candidate.targeting_point()
		):
			blocked += 1
			continue
		struck.append(candidate)

	# Roguelite I13 (D-318): committed once for this release, and dealt to every
	# target it strikes.
	var outgoing: PlayerStatValue = _player.outgoing_hit_damage(data.hit_damage(_player.weapon))
	if not outgoing.ok:
		return _damage_refused(outgoing, struck.size())
	var damage: float = outgoing.value
	var events: int = 0
	for hit: PrototypeTargetable in struck:
		hit.note_release(use_id)
		var actor: Node = hit.combat_actor()
		if actor == null:
			continue
		var event: FirstMvpDamageEvent = FirstMvpDamageEvent.of_type(
			use_id, _player, actor, damage, data.damage_type
		)
		last_damage_dealt = event
		damage_events += 1
		events += 1
		actor.call("receive_damage", event)
	return {
		"outcome": "hit %d" % events if events > 0 else "no target in the area",
		"reason": "%.2f m radius, %d in range, %d obstructed, %.0f %s each" % [
			data.area_radius, struck.size(), blocked, damage, data.damage_type,
		],
		"targets": struck.size(),
		"events": events,
		"damage_each": damage,
	}


## One projectile, launched from the character along the committed aim. It
## resolves itself on collision; the Skill Use is complete the moment it leaves.
func _spawn_projectile() -> Dictionary:
	# Roguelite I13 (D-318): the damage is committed at LAUNCH and the projectile
	# stores it; nothing reaches into a projectile already in flight.
	var outgoing: PlayerStatValue = _player.outgoing_hit_damage(data.hit_damage(_player.weapon))
	if not outgoing.ok:
		return _damage_refused(outgoing, 0)
	var damage: float = outgoing.value
	var projectile: FirstMvpSkillProjectile = FirstMvpSkillProjectile.new()
	projectile.name = "%sProjectile%d" % [data.display_name.replace(" ", ""), use_id]
	projectile.setup(data, _player, use_id, aim, damage, _log)
	_projectile_parent.add_child(projectile)
	# Launched from chest height so it flies over ground clutter rather than
	# through the character's own feet.
	projectile.global_position = _player.global_position + Vector3(0.0, 1.05, 0.0) + aim * 0.55
	projectile.look_at_direction()
	projectile.finished.connect(_on_projectile_finished)
	projectiles_spawned += 1
	return {
		"outcome": "launched",
		"reason": "%.1f m/s over %.1f m, %.0f %s on Hit" % [
			data.projectile_speed, data.projectile_range, damage, data.damage_type,
		],
		"targets": 0,
		"damage_each": damage,
	}


func _on_projectile_finished(outcome: Dictionary) -> void:
	if outcome.has("event"):
		last_damage_dealt = outcome["event"] as FirstMvpDamageEvent
		damage_events += 1


## A refused outgoing-damage answer (Roguelite I13, D-318): no damage record, no
## projectile, and a reason that is reported rather than swallowed — `push_error`
## rather than `assert`, because an assert is stripped in release builds.
func _damage_refused(outgoing: PlayerStatValue, targets: int) -> Dictionary:
	last_refusal = "%s dealt no damage: %s" % [data.display_name, outgoing.failure_reason]
	push_error("FirstMvpSkillAction: use %d of %s dealt no damage; its outgoing damage was refused: %s"
		% [use_id, data.display_name, outgoing.failure_reason])
	return {
		"outcome": "refused",
		"reason": "outgoing damage refused: %s" % outgoing.failure_reason,
		"targets": targets,
		"events": 0,
		"damage_each": 0.0,
	}


func _finish_action() -> void:
	_emit("%s complete" % data.display_name.to_lower(), "use %d finished a %.3f s action" % [
		use_id, effective_action_time(),
	])
	_end_attempt()


func _end_attempt() -> void:
	target = null
	_facing_locked = false
	_enter(Phase.READY)


func _enter(next: Phase) -> void:
	if next == phase and next != Phase.READY:
		return
	phase = next
	phase_time = 0.0
	phase_changed.emit(phase)


# --- Helpers -------------------------------------------------------------------

func phase_name() -> String:
	match phase:
		Phase.APPROACH:
			return "APPROACH_TARGET"
		Phase.WINDUP:
			return "SKILL_WINDUP"
		Phase.RELEASE:
			return "SKILL_RELEASE"
		Phase.RECOVERY:
			return "SKILL_RECOVERY"
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


# --- Controller soft targeting --------------------------------------------------

## D-178's accepted geometry, applied to a `FirstMvpSkillData` instead of a
## `QuickStrikeData`.
##
## WHY THIS IS HERE AND NOT A CALL INTO `TargetAcquisition`. That class's own
## `soft_target()` is typed `data: QuickStrikeData` and is exercised directly by
## the closed Gate C (209), D (230), E (713) and F (1008) suites — Gate C alone
## calls it a dozen times. Changing its signature would edit a file four closed
## gates depend on. So the RULES are reproduced here against the new record and
## `TargetAcquisition` is only READ (`is_obstructed`), never changed.
##
## TWO RULES ARE DELIBERATELY DIFFERENT, AND BOTH DIFFERENCES ARE CANONICAL.
##
##   1. NO IN-REACH PRIORITY GROUP. D-178's "anything already inside the release
##      reach forms the first group" is explicitly a QUICK STRIKE / CONTACT-MELEE
##      rule — the project's own handoff says in as many words: "Do not
##      generalize it into a universal targeting rule for future ranged Skills,
##      whose intended relationship between aim direction and distance may
##      legitimately differ." A projectile has no reach to be inside.
##   2. NO RETENTION. The brief asks for "per-use correction; no mandatory
##      permanent lock-on", and retention is the one part of D-178 that
##      deliberately survives between uses for contact melee. A ranged Skill
##      re-decides every time it is used, which is also what makes the D-193
##      per-use rule trivially true for it: there is no field to survive.
##
## Everything else is D-178 exactly: the cone is a TOTAL width halved through
## `soft_target_cone_half_radians()`, the acquisition distance is a hard limit,
## obstruction is checked from chest height, angle leads, and the nearest
## candidate inside the tie band wins.
func soft_target(origin: Vector3, intended: Vector3, candidates: Array[PrototypeTargetable]) -> Dictionary:
	var considered: Array[Dictionary] = []
	var flat_intent: Vector3 = _planar(intended)
	if flat_intent.length() < 0.0001:
		return {"target": null, "reason": "no intended direction", "considered": considered}
	flat_intent = flat_intent.normalized()

	var half_cone: float = data.soft_target_cone_half_radians()
	for fixture: PrototypeTargetable in candidates:
		if fixture == null or not fixture.is_valid_target():
			continue
		var to_target: Vector3 = _planar(fixture.global_position - origin)
		var distance: float = to_target.length()
		if distance < 0.0001:
			continue
		var angle: float = flat_intent.angle_to(to_target.normalized())
		var record: Dictionary = {
			"fixture": fixture, "distance": distance,
			"angle_degrees": rad_to_deg(angle), "rejected": "",
		}
		if distance > data.soft_target_distance:
			record["rejected"] = "beyond %.1f m acquisition distance" % data.soft_target_distance
		elif angle > half_cone:
			record["rejected"] = "%.1f deg outside the %.1f deg half-cone (%.0f deg total)" % [
				rad_to_deg(angle), data.soft_target_cone_half_degrees(),
				data.soft_target_cone_total_degrees(),
			]
		elif _acquire != null and _acquire.is_obstructed(origin + Vector3.UP * 1.10, fixture.targeting_point()):
			record["rejected"] = "obstructed"
		considered.append(record)

	var eligible: Array[Dictionary] = []
	for record: Dictionary in considered:
		if String(record["rejected"]).is_empty():
			eligible.append(record)
	if eligible.is_empty():
		return {
			"target": null,
			"reason": "no eligible target in the %.0f deg cone" % data.soft_target_cone_total_degrees(),
			"considered": considered,
		}

	var best_angle: float = INF
	for record: Dictionary in eligible:
		best_angle = minf(best_angle, float(record["angle_degrees"]))
	var chosen: Dictionary = {}
	for record: Dictionary in eligible:
		if float(record["angle_degrees"]) > best_angle + data.soft_target_angle_tie_degrees:
			continue
		if chosen.is_empty() or float(record["distance"]) < float(chosen["distance"]):
			chosen = record
	return {
		"target": chosen["fixture"],
		"reason": "%.0f deg off intent, %.2f m away" % [chosen["angle_degrees"], chosen["distance"]],
		"considered": considered,
	}
