class_name PrototypeProgressionDirector
extends Node
## Prototype Zero — Gate E: the deterministic progression director
## (specification §15, decision D-184).
##
## It owns the five explicit stages and nothing else:
##
##   STARTER_FIGHT      one Graveblade, the 100-damage Training Sword, XP 0 / 20.
##                      The first eligible kill grants exactly 10 XP and the one
##                      guaranteed Honed Sword. No replacement enemy spawns.
##   UPGRADE_ON_GROUND  the sword waits on the floor. Close leaves it there;
##                      Equip replaces the prototype weapon directly and spawns
##                      the next equivalent Graveblade.
##   UPGRADED_FIGHT     a mechanically identical Graveblade that dies in two
##                      Hits. Its kill grants the second 10 XP, reaching 20 / 20.
##   PASSIVE_READY      the one contained Quickened Form card, deliberately
##                      confirmed.
##   REPEAT_LOOP        deterministic waves of 1, then 2, then 3, repeating,
##                      each starting about 1.25 s after the previous threat is
##                      gone. XP stays 20 / 20 and reads Complete.
##
## EVERY REWARD GOES THROUGH `LabProgress`, which refuses a second grant and says
## so. This class holds no milestone state of its own: a duplicate kill signal, a
## corpse, a repeated press, a reopened modal, and the debug current-stage reset
## all end up at the same five doors.
##
## GATE D COMPATIBILITY. `set_active(false)` puts the director in the exact
## arrangement Gate D was accepted in: one Graveblade at the authored spawn
## marker, no rewards, no waves, and no corpse removal. The Gate B, Gate C, and
## Gate D suites all run that way, because a live progression director spawning
## waves would change what they measure — the same reasoning that already removes
## the Graveblade for the Gate B and Gate C runs.

const GRAVEBLADE_SCENE: String = "res://scenes/actors/prototype_graveblade.tscn"
const DROP_SCENE: String = "res://scenes/items/prototype_sword_drop.tscn"

## Deterministic authored spawn clusters. Two sets of three points on opposite
## sides of the room, each set chosen so that from the room centre every point is
## at least the minimum player distance away, no two are closer than the minimum
## separation, and the three together span far less than the maximum spread — a
## wave arrives from one side rather than encircling (specification §14.3).
##
## The first cluster's first point is the Gate D spawn marker's position, so the
## opening fight is literally the fight the project owner accepted under D-183.
## Cluster B exists for the one case cluster A cannot answer: a player standing
## in the west of the room. `measure_spawn_plan()` picks between them by
## measurement, and the choice is a pure function of where the player is.
const SPAWN_CLUSTERS: Array[Array] = [
	[Vector3(-6.0, 0.0, 4.5), Vector3(-7.4, 0.0, 1.5), Vector3(-4.6, 0.0, 5.6)],
	[Vector3(6.6, 0.0, -4.6), Vector3(7.6, 0.0, -1.2), Vector3(4.2, 0.0, -5.6)],
]

@export var data: LabProgressionData

var active: bool = true
var progress: LabProgress
## Gate F (specification §20.3). Set by the room from the persistent app before
## `begin()`. Null for a new laboratory; a validated `PrototypeLabState` when
## Continue was chosen. The director never reads or writes the FILE — it is
## handed a validated record — which is what keeps the disk entirely on the app's
## side of the line and `LabProgress` entirely in memory (D-184).
var saved_state: PrototypeLabState = null
## Gate F (specification §20.2): "restore the current wave at full Life". The
## size of the wave currently being fought, so Restart rebuilds THIS fight rather
## than the next one in the pattern.
var current_wave_size: int = 1
## True only while `_begin_from_saved()` is walking the reward doors. The
## milestone commits it produces must NOT trigger a save: the file being read is
## already the file that would be written, and writing it mid-reconstruction
## overwrites the very record the reconstruction is still reading.
var reconstructing: bool = false

## Seconds still to wait before the next repeat-loop wave. Negative means no wave
## is pending.
var wave_countdown: float = -1.0
## F3 debug only (specification §22: "force wave size 1, 2, or 3 after the main
## sequence"). Zero means follow the deterministic pattern.
var forced_wave_size: int = 0

# --- Instrumentation (specification §22) -------------------------------------
var last_spawn_plan: Dictionary = {}
var last_message: String = ""
var last_message_at_msec: int = 0
var audio_cues_emitted: int = 0
var last_audio_cue: String = "none"
## The moment the repeat loop first observed no living threat. The wave delay is
## measured from HERE, so the interval that gets verified is the interval the
## director actually produced rather than one a checker's own pacing imposed.
var last_threat_clear_msec: int = 0

## THE SAME MOMENT ON THIS DIRECTOR'S OWN SIMULATION CLOCK, and the reading the
## wave interval is now verified against (Gate F report §10a.5).
##
## `wave_countdown` is decremented by the `delta` this director is handed, so
## "how long after the threat was gone did the next wave arrive?" is a question
## about the sum of those deltas. Asking the wall clock instead answers a
## different question — one that includes every millisecond the process spent
## stalled by something with nothing to do with the game — and on a loaded
## machine the two answers diverged by up to 0.9 s and reported a Gate E
## regression that had not happened.
##
## `simulation_seconds` is that sum and `last_threat_clear_seconds` is a reading
## of it. Both are §22 instrumentation and nothing else: no rule, countdown,
## spawn, or reward reads either of them, and the millisecond stamp above is
## still what the log prints.
var simulation_seconds: float = 0.0
var last_threat_clear_seconds: float = -1.0

var _room: PrototypeZeroRoom
var _drop: PrototypeSwordDrop = null
var _corpses: Array[Dictionary] = []
var _threat_clear_logged: bool = false

signal stage_changed(from: LabProgress.Stage, to: LabProgress.Stage)
signal sword_dropped(drop: PrototypeSwordDrop)
signal sword_taken()
signal passive_ready()
signal passive_confirmed()
signal wave_started(size: int, plan: Dictionary)
signal transient_message(text: String)


func bind(room: PrototypeZeroRoom) -> void:
	_room = room
	var problem: String = "progression data is missing" if data == null else data.problem()
	assert(problem.is_empty(), "PrototypeProgressionDirector: %s" % problem)
	progress = LabProgress.new(data)
	progress.stage_changed.connect(_on_stage_changed)
	progress.milestone_committed.connect(_on_milestone_committed)


## Gate D and earlier measure their own gates in isolation. Called before
## `begin()` by the room when a Gate B, C, or D verification run starts.
func set_active(value: bool) -> void:
	active = value


func begin() -> void:
	if not active:
		# The exact Gate D arrangement: one Graveblade at the authored marker,
		# no rewards, no waves, no corpse removal.
		var spawn: Marker3D = _room.get_node("Actors/GravebladeSpawn") as Marker3D
		_spawn_graveblade_at(spawn.position)
		_log("director suspended", "Gate D compatibility: one Graveblade, no progression")
		return
	if saved_state != null and saved_state.valid:
		_begin_from_saved()
		return
	_apply_progress_to_player()
	_log("lab progression", data.describe())
	_enter_starter_fight()


## Specification §20.3: "On Continue, reconstruct the nearest valid beginning of
## the saved stage."
##
## The reconstruction walks the SAME five idempotent reward doors ordinary play
## walks, in the same order, and stops at the saved milestone
## (`PrototypeLabState.reconstruct_into`). Two things follow from that, and both
## are the point:
##
##   * Continue cannot duplicate XP, the sword, or the passive. Each door returns
##     false the second time it is called, whoever is calling it, so continuing
##     into a record that already holds a milestone changes nothing.
##   * There is no second progression path to keep in step with the first.
##
## Then the stage's own start condition is rebuilt — the same call ordinary play
## makes when it arrives there — so a continued laboratory is in a state the loop
## itself produces rather than in one only Continue can reach.
func _begin_from_saved() -> void:
	# READ FIRST, then reconstruct. The saved record is a live object the app also
	# writes to, so the stage to rebuild is taken before anything can change it.
	var target_stage: String = saved_state.stage_to_enter()
	var described: String = saved_state.describe()
	reconstructing = true
	var opened: PackedStringArray = saved_state.reconstruct_into(progress)
	_apply_progress_to_player()
	_log("continued", "%s; reopened %d milestone door%s: %s" % [
		described, opened.size(), "" if opened.size() == 1 else "s",
		"none" if opened.is_empty() else "; ".join(opened),
	])
	_enter_saved_stage(target_stage)
	reconstructing = false


func _enter_saved_stage(milestone: String) -> void:
	match milestone:
		"UPGRADE_ON_GROUND":
			# The sword's floor POSITION is deliberately not persisted — §20.3's
			# allowlist has six values and none of them is a coordinate — so the
			# nearest valid beginning of this stage is the sword placed at a
			# deterministic, reachable point beside the player spawn. The reward
			# itself is not re-granted: `grant_starter_kill_reward()` already
			# refused the second call during the reconstruction above.
			progress.enter_stage(LabProgress.Stage.UPGRADE_ON_GROUND)
			_place_drop(_room.player.global_position + Vector3(2.5, 0.0, 0.0))
		"UPGRADED_FIGHT":
			_enter_upgraded_fight()
		"PASSIVE_READY":
			_enter_passive_ready()
		"REPEAT_LOOP":
			_enter_repeat_loop()
		_:
			_enter_starter_fight()


# --- Stage entry -------------------------------------------------------------

func _enter_starter_fight() -> void:
	progress.enter_stage(LabProgress.Stage.STARTER_FIGHT)
	_clear_drop("starter fight restarted")
	_spawn_wave(1, "starter fight")


func _enter_upgrade_on_ground(at: Vector3) -> void:
	progress.enter_stage(LabProgress.Stage.UPGRADE_ON_GROUND)
	_place_drop(at)


func _enter_upgraded_fight() -> void:
	progress.enter_stage(LabProgress.Stage.UPGRADED_FIGHT)
	_spawn_wave(1, "upgraded fight")


func _enter_passive_ready() -> void:
	progress.enter_stage(LabProgress.Stage.PASSIVE_READY)
	passive_ready.emit()


func _enter_repeat_loop() -> void:
	progress.enter_stage(LabProgress.Stage.REPEAT_LOOP)
	# The first repeat wave arrives on the same delay as every later one, so the
	# rhythm the project owner judges is one rhythm — and the clock it is
	# measured from starts HERE, because confirming the passive is the moment the
	# previous threat is gone.
	wave_countdown = data.wave_delay
	last_threat_clear_msec = Time.get_ticks_msec()
	last_threat_clear_seconds = simulation_seconds
	_threat_clear_logged = true


# --- Per-frame ---------------------------------------------------------------

func _process(delta: float) -> void:
	if not active or _room == null or progress == null:
		return
	# The director's own clock, advanced by exactly the delta `wave_countdown` is
	# decremented by — and read by nothing that decides anything.
	simulation_seconds += delta
	_tick_corpses(delta)
	if progress.stage != LabProgress.Stage.REPEAT_LOOP:
		return
	if _room.living_graveblade_count() > 0:
		wave_countdown = -1.0
		_threat_clear_logged = false
		return
	if wave_countdown < 0.0:
		# Specification §15.1: the delay is measured from the moment the previous
		# wave's LAST threat is gone, not from when its body disappears.
		wave_countdown = data.wave_delay
		last_threat_clear_msec = Time.get_ticks_msec()
		last_threat_clear_seconds = simulation_seconds
		if not _threat_clear_logged:
			_threat_clear_logged = true
			_log("wave complete", "threat gone; next wave in %.2f s" % data.wave_delay)
		return
	wave_countdown -= delta
	if wave_countdown <= 0.0:
		wave_countdown = -1.0
		_spawn_next_repeat_wave()


func _spawn_next_repeat_wave() -> void:
	var size: int = forced_wave_size if forced_wave_size > 0 else progress.next_wave_size()
	var label: String = "repeat wave %d" % (progress.waves_started + 1)
	if forced_wave_size > 0:
		label += " (F3 debug forced size)"
	else:
		progress.advance_wave()
	_spawn_wave(size, label)


# --- Waves and safe spawn geometry -------------------------------------------

## Specification §14.3: "Enemy spawn points must avoid body overlap and must not
## surround the player before control returns."
##
## Every one of those words is MEASURED here, on the authored clusters, against
## the player's ACTUAL position, and the result is returned so the debug surface
## and the Gate E checks read the same numbers ordinary play uses. Nothing is
## random: the cluster preference order is fixed and the tests are pure.
func measure_spawn_plan(count: int) -> Dictionary:
	var player_position: Vector3 = _room.player.global_position
	var wanted: int = clampi(count, 1, data.largest_wave())
	var occupied: Array[Vector3] = []
	for enemy: PrototypeGraveblade in _room.graveblades:
		if is_instance_valid(enemy) and enemy.is_alive():
			occupied.append(enemy.global_position)

	var attempts: Array[Dictionary] = []
	for cluster_index: int in SPAWN_CLUSTERS.size():
		var plan: Dictionary = _evaluate_cluster(cluster_index, wanted, player_position, occupied)
		attempts.append(plan)
		if not bool(plan["safe"]):
			_log("spawn cluster rejected", "cluster %d — player %.2f m (need %.2f), apart %.2f m (need %.2f), spread %.0f deg (max %.0f), floor %s, navmesh %s (worst offset %.3f m)" % [
				cluster_index, float(plan["minimum_player_distance"]), data.minimum_player_distance,
				float(plan["minimum_separation"]), data.minimum_spawn_separation,
				float(plan["spread_degrees"]), data.maximum_spawn_spread_degrees,
				str(bool(plan["inside_clear_floor"])), str(bool(plan["on_navigation_mesh"])),
				float(plan["worst_navigation_offset"]),
			])
		if bool(plan["safe"]):
			plan["attempts"] = attempts.size()
			last_spawn_plan = plan
			return plan

	# Neither authored cluster is safe from where the player is standing. Rather
	# than inventing a point, take the cluster that is FURTHEST from the player
	# and say plainly that the guarantee was not met, so a spawn can never
	# silently appear next to the character.
	var best: Dictionary = attempts[0]
	for plan: Dictionary in attempts:
		if float(plan["minimum_player_distance"]) > float(best["minimum_player_distance"]):
			best = plan
	best["attempts"] = attempts.size()
	best["note"] = "no authored cluster met every rule from the player's position; used the furthest"
	last_spawn_plan = best
	return best


func _evaluate_cluster(
	cluster_index: int, count: int, player_position: Vector3, occupied: Array[Vector3]
) -> Dictionary:
	var cluster: Array = SPAWN_CLUSTERS[cluster_index]
	var points: Array[Vector3] = []
	for i: int in count:
		points.append(cluster[i] as Vector3)

	var minimum_player: float = INF
	var minimum_separation: float = INF
	var inside_floor: bool = true
	var on_navigation: bool = true
	var worst_navigation_offset: float = 0.0
	var bearings: Array[float] = []

	for point: Vector3 in points:
		minimum_player = minf(minimum_player, _planar_distance(point, player_position))
		bearings.append(rad_to_deg(atan2(point.x - player_position.x, point.z - player_position.z)))
		if not _room.contains_point_in_clear_floor(point, -data.spawn_floor_margin):
			inside_floor = false
		var snapped: Vector3 = NavigationServer3D.map_get_closest_point(_room.navigation_map(), point)
		var offset: float = _planar_distance(snapped, point)
		worst_navigation_offset = maxf(worst_navigation_offset, offset)
		if offset > 0.25:
			on_navigation = false
		for other: Vector3 in occupied:
			minimum_separation = minf(minimum_separation, _planar_distance(point, other))

	for i: int in points.size():
		for j: int in range(i + 1, points.size()):
			minimum_separation = minf(minimum_separation, _planar_distance(points[i], points[j]))
	if minimum_separation == INF:
		minimum_separation = 999.0

	var spread: float = _angular_spread(bearings)
	var safe: bool = (
		minimum_player >= data.minimum_player_distance
		and minimum_separation >= data.minimum_spawn_separation
		and spread <= data.maximum_spawn_spread_degrees
		and inside_floor
		and on_navigation
	)
	return {
		"cluster": cluster_index,
		"points": points,
		"safe": safe,
		"minimum_player_distance": minimum_player,
		"minimum_separation": minimum_separation,
		"spread_degrees": spread,
		"inside_clear_floor": inside_floor,
		"on_navigation_mesh": on_navigation,
		"worst_navigation_offset": worst_navigation_offset,
		"note": "",
	}


## The widest angle the points span as seen FROM THE PLAYER, measured the only
## way that survives the -180/+180 wrap: sort the bearings, take the largest gap
## between neighbours on the circle, and the spread is what is left over.
func _angular_spread(bearings: Array[float]) -> float:
	if bearings.size() < 2:
		return 0.0
	var sorted: Array[float] = bearings.duplicate()
	sorted.sort()
	var widest_gap: float = 360.0 - (sorted[sorted.size() - 1] - sorted[0])
	for i: int in range(1, sorted.size()):
		widest_gap = maxf(widest_gap, sorted[i] - sorted[i - 1])
	return 360.0 - widest_gap


func _spawn_wave(size: int, label: String) -> void:
	var plan: Dictionary = measure_spawn_plan(size)
	var points: Array[Vector3] = plan["points"]
	# Gate F: Restart rebuilds THIS wave, so its size has to be remembered rather
	# than recomputed from the pattern — recomputing would restart the fight after
	# the one the player actually lost.
	current_wave_size = points.size()
	for point: Vector3 in points:
		_spawn_graveblade_at(point)
	_log("wave started", "%s — %d Graveblade%s, cluster %d, nearest %.2f m from the player, %.2f m apart, %.0f deg spread%s" % [
		label, points.size(), "" if points.size() == 1 else "s", int(plan["cluster"]),
		float(plan["minimum_player_distance"]), float(plan["minimum_separation"]),
		float(plan["spread_degrees"]),
		"" if bool(plan["safe"]) else "  UNSAFE: %s" % String(plan["note"]),
	])
	wave_started.emit(points.size(), plan)
	if points.size() > 1:
		_emit_message("%s — %d Graveblades" % [label.capitalize(), points.size()])


func _spawn_graveblade_at(point: Vector3) -> PrototypeGraveblade:
	var enemy: PrototypeGraveblade = (load(GRAVEBLADE_SCENE) as PackedScene).instantiate() as PrototypeGraveblade
	# Names stay unique so the coordinator's log and the debug surface can tell
	# three identical Graveblades apart.
	enemy.name = "Graveblade%d" % (_room.graveblades_spawned + 1)
	enemy.position = Vector3(point.x, 0.0, point.z)
	_room.register_graveblade(enemy)
	enemy.died.connect(_on_graveblade_died.bind(enemy))
	return enemy


# --- Rewards -----------------------------------------------------------------

## The single entry point for a kill. Everything idempotent about Gate E passes
## through here: the per-enemy claim first, then the stage's own milestone door,
## each of which refuses a second grant on its own.
func _on_graveblade_died(event: DamageEvent, enemy: PrototypeGraveblade) -> void:
	_corpses.append({"enemy": enemy, "left": data.corpse_linger})
	if not active:
		return
	if not progress.claim_kill_reward(enemy):
		_log("reward refused", progress.last_refusal)
		return

	match progress.stage:
		LabProgress.Stage.STARTER_FIGHT:
			if not progress.grant_starter_kill_reward():
				_log("reward refused", progress.last_refusal)
				return
			_log("XP awarded", "%d XP for %s (use %d); %s" % [
				data.experience_per_eligible_kill, enemy.name, event.use_id, progress.experience_line(),
			])
			_enter_upgrade_on_ground(enemy.global_position)
		LabProgress.Stage.UPGRADED_FIGHT:
			if not progress.grant_upgraded_kill_reward():
				_log("reward refused", progress.last_refusal)
				return
			_log("XP awarded", "%d XP for %s (use %d); %s" % [
				data.experience_per_eligible_kill, enemy.name, event.use_id, progress.experience_line(),
			])
			_enter_passive_ready()
		LabProgress.Stage.REPEAT_LOOP:
			progress.count_repeat_loop_kill()
			_log("repeat loop kill", "%d equivalent kills since the loop began; %s" % [
				progress.repeat_loop_kills, progress.experience_line(),
			])
			_emit_message("Repeat kills: %d" % progress.repeat_loop_kills)
		_:
			_log("kill outside a rewarding stage", "%s during %s; nothing granted" % [
				enemy.name, progress.stage_name(),
			])


## Called by the item comparison. Equipping replaces the deterministic prototype
## weapon directly — there is no inventory and nothing is destroyed.
func equip_honed_sword() -> bool:
	if not progress.equip_honed_sword():
		_log("equip refused", progress.last_refusal)
		return false
	_cue("equip")
	_apply_progress_to_player()
	_clear_drop("equipped")
	sword_taken.emit()
	_emit_message("Equipped %s — %.0f Physical per Quick Strike" % [
		_room.honed_sword.display_name, _room.honed_sword.physical_damage,
	])
	_enter_upgraded_fight()
	return true


## Called by the passive card. Applies the one contained modifier through the
## kernel's existing attack-speed mechanism, so every phase compresses together.
func confirm_quickened_form() -> bool:
	if not progress.confirm_quickened_form():
		_log("passive refused", progress.last_refusal)
		return false
	_cue("passive_confirm")
	var before: float = _room.player.attack.effective_action_time()
	_apply_progress_to_player()
	var after: float = _room.player.attack.effective_action_time()
	_log("passive confirmed", "%s — %s; Quick Strike action time %.2f s -> %.2f s" % [
		data.passive_name, data.passive_effect_line, before, after,
	])
	_emit_message("%s applied — Quick Strike %.2f s → %.2f s" % [data.passive_name, before, after])
	passive_confirmed.emit()
	_enter_repeat_loop()
	return true


## The one place the authoritative record is pushed onto the live character, so
## every reset re-applies from the record rather than remembering separately.
func _apply_progress_to_player() -> void:
	_room.player.equip_weapon(
		_room.honed_sword if progress.honed_sword_equipped else _room.starter_sword
	)
	_room.player.set_increased_attack_speed(progress.increased_attack_speed())


# --- The ground drop ---------------------------------------------------------

func _place_drop(at: Vector3) -> void:
	_clear_drop("replaced")
	var point: Vector3 = _safe_drop_point(at)
	_drop = (load(DROP_SCENE) as PackedScene).instantiate() as PrototypeSwordDrop
	_drop.name = "HonedSwordDrop"
	_drop.position = point
	_room.get_node("Drops").add_child(_drop)
	_cue("sword_drop")
	_log("sword dropped", "%s on the ground at (%.2f, %.2f); Close leaves it there" % [
		_drop.display_name(), point.x, point.z,
	])
	_emit_message("%s — click its name or press Interact" % _drop.display_name())
	sword_dropped.emit(_drop)


## The kill can happen anywhere, including against a wall. Resolve to the
## navigation mesh and hold the drop inside the clear floor so it is always
## reachable and its nameplate is always on screen.
func _safe_drop_point(at: Vector3) -> Vector3:
	var half: Vector2 = _room.clear_half_extent()
	var margin: float = data.spawn_floor_margin
	var clamped: Vector3 = Vector3(
		clampf(at.x, -half.x + margin, half.x - margin), 0.0,
		clampf(at.z, -half.y + margin, half.y - margin)
	)
	return NavigationServer3D.map_get_closest_point(_room.navigation_map(), clamped)


func _clear_drop(reason: String) -> void:
	if _drop == null:
		return
	var name_taken: String = _drop.display_name()
	_drop.get_parent().remove_child(_drop)
	_drop.queue_free()
	_drop = null
	_log("ground drop cleared", "%s (%s)" % [name_taken, reason])


func drop() -> PrototypeSwordDrop:
	return _drop


# --- Corpses -----------------------------------------------------------------

## A defeated Graveblade is removed after `corpse_linger`, which is longer than
## the 0.80 s death clip and shorter than the wave delay, so the collapse
## finishes and the floor is clear before the next wave arrives.
##
## While the director is SUSPENDED nothing is removed, because Gate D's checks
## measure a corpse: that a dead target takes no damage, produces no second kill,
## and cannot be struck again.
func _tick_corpses(delta: float) -> void:
	if _corpses.is_empty():
		return
	var remaining: Array[Dictionary] = []
	for entry: Dictionary in _corpses:
		var enemy: PrototypeGraveblade = entry["enemy"] as PrototypeGraveblade
		if not is_instance_valid(enemy):
			continue
		entry["left"] = float(entry["left"]) - delta
		if float(entry["left"]) > 0.0:
			remaining.append(entry)
			continue
		progress.forget_enemy(enemy)
		_room.remove_graveblade(enemy, "defeated body removed after %.2f s" % data.corpse_linger)
	_corpses = remaining


# --- Debug resets ------------------------------------------------------------

## F11. Specification §15.2 and D-184: a current-stage reset RETAINS completed
## milestones. It restores the player and rebuilds the current stage's own start
## condition — which for UPGRADE_ON_GROUND means the sword still on the floor and
## still no enemy, and for PASSIVE_READY means the card again.
##
## Every enemy it makes is a NEW instance, so no per-enemy reward claim survives
## it; the milestone latches in `LabProgress` are what stop a second payout.
func reset_current_stage() -> void:
	_room.attack_coordinator.reset()
	_room.combat_events.clear()
	_room.player.revive_for_testing()
	_room.player.global_position = (_room.get_node("Actors/PlayerSpawn") as Marker3D).position
	_corpses.clear()
	wave_countdown = -1.0
	last_threat_clear_msec = 0
	last_threat_clear_seconds = -1.0
	_threat_clear_logged = false

	if not active:
		# Gate D compatibility, and it has to be EXACT. Gate D's own reset
		# restored the SAME Graveblade in place, and its suite legitimately holds
		# a reference to that enemy across a reset. Freeing it and spawning a
		# replacement — which is right for Gate E, where a fresh instance is what
		# makes the per-enemy reward claim fresh — would leave those references
		# pointing at a freed instance. So the suspended path restores in place.
		var existing: PrototypeGraveblade = _room.graveblade
		if existing != null and is_instance_valid(existing):
			existing.reset_encounter()
		else:
			_spawn_graveblade_at((_room.get_node("Actors/GravebladeSpawn") as Marker3D).position)
		_log("encounter reset (debug)", "player and Graveblade restored at their spawns")
		return

	_room.clear_all_graveblades("current-stage reset (debug)")
	_apply_progress_to_player()
	match progress.stage:
		LabProgress.Stage.STARTER_FIGHT:
			_clear_drop("current-stage reset")
			_spawn_wave(1, "starter fight (reset)")
		LabProgress.Stage.UPGRADE_ON_GROUND:
			if _drop == null:
				_place_drop(_room.player.global_position + Vector3(2.5, 0.0, 0.0))
		LabProgress.Stage.UPGRADED_FIGHT:
			_spawn_wave(1, "upgraded fight (reset)")
		LabProgress.Stage.PASSIVE_READY:
			passive_ready.emit()
		LabProgress.Stage.REPEAT_LOOP:
			wave_countdown = data.wave_delay
			last_threat_clear_msec = Time.get_ticks_msec()
			last_threat_clear_seconds = simulation_seconds
	_log("current-stage reset (debug)", "%s restored; milestones retained — %s" % [
		progress.stage_name(), progress.describe(),
	])
	_emit_message("Debug: %s reset — milestones retained" % progress.stage_name())


## Specification §20.2, Gate F's TRUSTED Restart. It is not the F11 debug reset:
## that one is a development convenience and says so on screen, while this is the
## flow the project owner reaches from Fallen and from Pause.
##
## §20.2 asks for six things and this does all six:
##
##   restore full player Life and Mana        `revive_for_testing()`, which is the
##                                            same full restore the debug reset
##                                            uses — it is named for where it
##                                            arrived, not for where it is used
##   clear hostile projectiles or hit queries there are no projectiles; the hit
##                                            queries die with the enemies, and
##                                            the coordinator is reset outright
##   restore the current wave at full Life    a NEW wave of `current_wave_size`,
##                                            not the next size in the pattern
##   restore valid spawn positions            through `measure_spawn_plan()`, the
##                                            same measured geometry ordinary
##                                            play uses
##   retain saved sword and passive milestones nothing here touches a latch, and
##                                            `_apply_progress_to_player()` pushes
##                                            the record back onto the character
##   return through neutral-input protection  `revive_for_testing()` arms the
##                                            latch and the room leaves it armed
##
## AND IT DUPLICATES NOTHING. Every Graveblade it makes is a new instance, so no
## per-enemy reward claim survives; the four milestone latches in `LabProgress`
## are what refuse a second payout, and Restart never calls a reward door at all.
func restart_current_fight() -> void:
	_room.attack_coordinator.reset()
	_room.combat_events.clear()
	_room.clear_all_graveblades("Restart Current Fight")
	_corpses.clear()
	wave_countdown = -1.0
	last_threat_clear_msec = 0
	last_threat_clear_seconds = -1.0
	_threat_clear_logged = false
	_room.player.revive_for_testing()
	_room.player.global_position = (_room.get_node("Actors/PlayerSpawn") as Marker3D).position
	_apply_progress_to_player()

	match progress.stage:
		LabProgress.Stage.STARTER_FIGHT:
			_clear_drop("restart")
			_spawn_wave(1, "starter fight (restart)")
		LabProgress.Stage.UPGRADE_ON_GROUND:
			# The sword is the stage. Restarting must not remove it and must not
			# drop a second one: `_place_drop` clears any existing drop first, and
			# the reward latch is untouched either way.
			if _drop == null:
				_place_drop(_room.player.global_position + Vector3(2.5, 0.0, 0.0))
		LabProgress.Stage.UPGRADED_FIGHT:
			_spawn_wave(1, "upgraded fight (restart)")
		LabProgress.Stage.PASSIVE_READY:
			passive_ready.emit()
		LabProgress.Stage.REPEAT_LOOP:
			_spawn_wave(current_wave_size, "repeat wave %d (restart)" % progress.waves_started)
	_log("RESTART CURRENT FIGHT", "%s rebuilt at full Life; milestones retained — %s" % [
		progress.stage_name(), progress.describe(),
	])
	_emit_message("Restarted — %s" % progress.stage_name())


## The clearly labelled Reset Lab Progress. Specification §15.2: it "deliberately
## clears the prototype test state and begins the complete path again". It is the
## ONLY thing in Gate E that may rewind a milestone.
func reset_lab_progress() -> void:
	_room.attack_coordinator.reset()
	_room.combat_events.clear()
	_room.clear_all_graveblades("Reset Lab Progress (debug)")
	_corpses.clear()
	_clear_drop("Reset Lab Progress")
	wave_countdown = -1.0
	last_threat_clear_msec = 0
	last_threat_clear_seconds = -1.0
	forced_wave_size = 0
	progress.reset_lab_progress()
	# Gate F: a cleared laboratory must not be re-reconstructed from the record
	# that was just discarded.
	saved_state = null
	current_wave_size = 1
	_room.player.revive_for_testing()
	_room.player.global_position = (_room.get_node("Actors/PlayerSpawn") as Marker3D).position
	_apply_progress_to_player()
	_log("RESET LAB PROGRESS (debug)", "the in-session sequence was deliberately cleared; %s" % progress.describe())
	_emit_message("Reset Lab Progress — starting the complete path again")
	_enter_starter_fight()


## F3 debug only (specification §22). Zero restores the deterministic pattern.
func set_forced_wave_size(size: int) -> void:
	forced_wave_size = clampi(size, 0, data.largest_wave())
	_log("debug wave size", "forced to %s" % ("the deterministic pattern" if forced_wave_size == 0 else str(forced_wave_size)))


# --- Named audio cue points (silent, by design) ------------------------------

## D-184: "Named audio hooks may remain silent; do not download unregistered
## audio." Specification §19 additionally forbids shipping an unregistered sound
## and forbids declaring the feel gate passed on diagnostic beeps.
##
## So Gate E creates the named cue POINTS and no AudioStreamPlayer at all: the
## cue is recorded in the same structured log every other event uses. Gate F owns
## registering and importing real audio and wiring it here. The Gate E suite
## asserts by name that no audio player exists.
## Gate E created these cue POINTS and left them silent, because D-184 forbade
## downloading audio and §19 forbids declaring the feel gate passed on beeps.
## Gate F fills them: D-189 authorises project-authored cues, the generator in
## `scripts/tools/build_prototype_audio.gd` made them, and the room's audio
## director routes the name to one. The cue POINTS did not move, which is why
## Gate E's own count of them is unchanged.
func _cue(cue_name: String) -> void:
	audio_cues_emitted += 1
	last_audio_cue = cue_name
	if _room != null and _room.audio != null:
		_room.audio.play(cue_name)
	_log("audio cue", "%s" % cue_name)


func note_cue(cue_name: String) -> void:
	_cue(cue_name)


# --- Messages and logging ----------------------------------------------------

func _emit_message(text: String) -> void:
	last_message = text
	last_message_at_msec = Time.get_ticks_msec()
	transient_message.emit(text)


func message_is_current() -> bool:
	if last_message.is_empty():
		return false
	return float(Time.get_ticks_msec() - last_message_at_msec) / 1000.0 < data.message_seconds


func _on_stage_changed(from: LabProgress.Stage, to: LabProgress.Stage) -> void:
	_log("stage", "%s -> %s" % [_stage_label(from), _stage_label(to)])
	stage_changed.emit(from, to)


func _on_milestone_committed(name: String) -> void:
	_log("milestone committed", "%s  (in memory only; Gate F owns the test-state file)" % name)


func _stage_label(value: LabProgress.Stage) -> String:
	var previous: LabProgress.Stage = progress.stage
	progress.stage = value
	var label: String = progress.stage_name()
	progress.stage = previous
	return label


func _log(event: String, detail: String) -> void:
	if _room != null:
		_room.log_progression(event, detail)


func _planar_distance(a: Vector3, b: Vector3) -> float:
	return Vector2(b.x - a.x, b.z - a.z).length()
