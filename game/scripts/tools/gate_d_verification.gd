extends Node
## Prototype Zero — Gate D automated verification.
##
## Specification §25 forbids a test framework and states plainly that automated
## tests cannot certify feel. These checks assert only what a machine CAN settle
## about the one-Graveblade encounter: that every locked value is the locked
## value, that the state machine goes where it says, that the enemy asks before
## it commits, that its committed direction really is locked, that reach, arc,
## obstruction, and that commitment each decide hit from miss at their exact
## boundaries, that repositioning after the commit produces a genuine miss, that
## Life moves in the exact locked steps in both directions, that death is
## immediate and complete, that Hit precedes kill and neither can happen twice,
## and that the fight measured here is still the one-Graveblade fight the project
## owner accepted under D-183 — the Gate E director suspended, one enemy, no
## progression, and the Graveblade itself reused unchanged.
##
## Whether the fight FEELS readable is the project owner's judgement, and it is
## outstanding: D-181 does not close until they play it with mouse and controller.
##
## Run:  godot --headless --path game -- --verify-d
##       godot --path game --resolution 1280x720 -- --verify-d --shots <dir>

const TICK: float = 1.0 / 60.0

var room: PrototypeZeroRoom
var player: PrototypePlayer
var action: QuickStrikeAction
var quick_strike: QuickStrikeData
var enemy: PrototypeGraveblade
var data: GravebladeData

var _failures: PackedStringArray = PackedStringArray()
var _checks: int = 0
var _shot_dir: String = ""

## Live trace of the encounter, recorded from its own signals.
var _states: Array[Dictionary] = []
var _clock: float = 0.0
var _release_animation_positions: Array[float] = []
## What the Graveblade's death decoration looked like AT the kill event, read
## from inside the mechanical call stack: -1 while it has not started, and the
## physics frame it started on once it has (Gate F report §10a.5).
var _animation_frame_at_kill_event: int = -99


func run(owner_room: PrototypeZeroRoom, arguments: PackedStringArray) -> void:
	room = owner_room
	player = owner_room.player
	action = player.attack
	quick_strike = action.data
	enemy = owner_room.graveblade
	_shot_dir = _argument_value(arguments, "--shots")

	print("")
	print("=== Gate D verification ===")
	await _settle(10)

	if enemy == null:
		printerr("GATE D VERIFICATION: the room has no Graveblade to verify")
		get_tree().quit(1)
		return
	data = enemy.data
	enemy.state_changed.connect(_on_state_changed)
	enemy.attack_released.connect(_on_enemy_released)

	_check_locked_data()
	await _check_shared_targeting_protocol()
	await _check_awareness_and_chase()
	await _check_state_machine()
	await _check_attack_permission()
	await _check_commitment()
	await _check_release_boundaries()
	await _check_genuine_miss_by_repositioning()
	await _check_single_release_query()
	await _check_player_life_progression()
	await _check_enemy_life_progression()
	await _check_hit_reaction_does_not_interrupt()
	await _check_death_disables_everything()
	await _check_duplicate_protection()
	await _check_event_ordering()
	await _check_navigation_around_barrier()
	await _check_scope()

	if _shot_dir != "":
		await _capture_evidence()

	print("")
	if _failures.is_empty():
		print("GATE D VERIFICATION: PASS (%d checks)" % _checks)
		get_tree().quit(0)
	else:
		for failure: String in _failures:
			printerr("  FAIL: %s" % failure)
		printerr("GATE D VERIFICATION: %d FAILURE(S) of %d checks" % [_failures.size(), _checks])
		get_tree().quit(1)


# --- 1. The locked record ----------------------------------------------------

func _check_locked_data() -> void:
	print("")
	print("--- Graveblade data (specification §14.1, decision D-181)")
	_expect(data.problem().is_empty(), "graveblade.tres is incoherent: %s" % data.problem())

	for expectation: Dictionary in [
		{"what": "maximum Life", "got": data.max_life, "want": 300.0, "unit": ""},
		{"what": "Physical damage", "got": data.physical_damage, "want": 125.0, "unit": ""},
		{"what": "movement speed", "got": data.move_speed, "want": 3.4, "unit": "m/s"},
		{"what": "awareness distance", "got": data.awareness_distance, "want": 10.0, "unit": "m"},
		{"what": "preferred distance", "got": data.preferred_attack_distance, "want": 1.40, "unit": "m"},
		{"what": "attack reach", "got": data.attack_reach, "want": 1.65, "unit": "m"},
		{"what": "attack arc", "got": data.attack_arc_degrees, "want": 90.0, "unit": "deg TOTAL"},
		{"what": "anticipation", "got": data.anticipation, "want": 0.55, "unit": "s"},
		{"what": "release window", "got": data.release_window, "want": 0.08, "unit": "s"},
		{"what": "recovery", "got": data.recovery, "want": 0.62, "unit": "s"},
		{"what": "commitment gap", "got": data.minimum_commitment_interval, "want": 0.35, "unit": "s minimum"},
		{"what": "action time", "got": data.action_time(), "want": 1.25, "unit": "s (derived)"},
		{"what": "release marker", "got": data.release_marker_normalized(), "want": 0.44, "unit": "of the action"},
		{"what": "XP reward", "got": float(data.experience_reward), "want": 10.0, "unit": "INERT in Gate D"},
	]:
		print("  %-22s %8.3f %s" % [expectation["what"], expectation["got"], expectation["unit"]])
		_expect(is_equal_approx(float(expectation["got"]), float(expectation["want"])),
			"%s is %.4f, the locked value is %.4f" % [
				expectation["what"], expectation["got"], expectation["want"],
			])

	_expect(is_equal_approx(data.anticipation + data.release_window + data.recovery, data.action_time()),
		"the three attack phases do not add up to the action time")
	_expect(is_equal_approx(data.release_marker_normalized(), 0.55 / 1.25),
		"the release marker is not the locked anticipation in normalised action time")
	_expect(is_equal_approx(rad_to_deg(data.attack_arc_half_radians()), 45.0),
		"the enforced half-arc is %.2f deg, not half of the 90 deg total" % rad_to_deg(data.attack_arc_half_radians()))

	print("")
	print("--- The player, unchanged from Gate C except for Life and Hit damage")
	for expectation: Dictionary in [
		{"what": "maximum Life", "got": player.max_life, "want": 500.0, "unit": ""},
		{"what": "Physical per Hit", "got": player.physical_damage, "want": 100.0, "unit": ""},
		{"what": "maximum Mana", "got": player.max_mana, "want": 100.0, "unit": "(Gate C)"},
		{"what": "Quick Strike reach", "got": quick_strike.reach, "want": 1.65, "unit": "m (Gate C)"},
		{"what": "Quick Strike action", "got": quick_strike.action_time, "want": 0.80, "unit": "s (Gate C)"},
		{"what": "maximum speed", "got": player.max_speed, "want": 5.0, "unit": "m/s (D-175)"},
	]:
		print("  %-22s %8.3f %s" % [expectation["what"], expectation["got"], expectation["unit"]])
		_expect(is_equal_approx(float(expectation["got"]), float(expectation["want"])),
			"%s is %.4f, the locked value is %.4f" % [
				expectation["what"], expectation["got"], expectation["want"],
			])

	# The exact starter relationship D-181 exists to prove, from the data alone.
	print("")
	print("  the three-Hit starter relationship, from the records:")
	print("    ceil(%.0f Graveblade Life / %.0f Quick Strike damage) = %d Hits" % [
		data.max_life, player.physical_damage, data.hits_to_defeat(player.physical_damage),
	])
	print("    ceil(%.0f player Life / %.0f Graveblade damage)       = %d Hits" % [
		player.max_life, data.physical_damage, int(ceil(player.max_life / data.physical_damage)),
	])
	_expect(data.hits_to_defeat(player.physical_damage) == 3,
		"the Graveblade takes %d Quick Strikes, not three" % data.hits_to_defeat(player.physical_damage))
	_expect(int(ceil(player.max_life / data.physical_damage)) == 4,
		"the player survives %d Graveblade Hits, not four" % int(ceil(player.max_life / data.physical_damage)))


# --- 2. One targeting protocol, two kinds of target --------------------------

func _check_shared_targeting_protocol() -> void:
	print("")
	print("--- Posts and the Graveblade share one targeting protocol (D-181)")
	var post: PrototypeTargetFixture = _post("Practice Post A")
	var area: PrototypeTargetable = _enemy_area()
	_expect(post is PrototypeTargetable, "the practice post is not a PrototypeTargetable")
	_expect(area is PrototypeTargetable, "the Graveblade's target area is not a PrototypeTargetable")
	print("  both are PrototypeTargetable on physics layer 3, \"target\"")
	_expect(post.collision_layer == PrototypeTargetable.TARGET_LAYER
		and area.collision_layer == PrototypeTargetable.TARGET_LAYER,
		"a target is not on the target layer")

	# The one difference, and the whole reason a Graveblade is not a fixture.
	print("  post.combat_actor()       = %s" % str(post.combat_actor()))
	print("  graveblade.combat_actor() = %s" % str(area.combat_actor()))
	_expect(post.combat_actor() == null, "an inert practice post reports a combat actor")
	_expect(area.combat_actor() == enemy, "the Graveblade's target area does not report the Graveblade")

	# The Graveblade really is in the candidate set the release query reads.
	await _reset()
	var candidates: Array[PrototypeTargetable] = room.target_candidates()
	_expect(candidates.has(area), "the Graveblade is not among Quick Strike's target candidates")
	_expect(candidates.size() == room.fixtures.size() + 1,
		"the candidate set holds %d targets; expected %d posts plus one Graveblade" % [
			candidates.size(), room.fixtures.size(),
		])
	print("  candidates: %d practice posts + 1 Graveblade" % room.fixtures.size())

	# Striking a post still produces no DamageEvent, which is what stops Gate C's
	# regression fixtures becoming enemies by accident.
	var events_before: int = action.damage_events
	await _park_enemy_away()
	await _teleport(post.global_position - Vector3(1.25, 0.0, 0.0))
	await _face_player(Vector3(1.0, 0.0, 0.0))
	Input.action_press(&"attack_in_place")
	_aim_cursor_at(post.targeting_point())
	room.press_quick_strike()
	action.release_input()
	await _await_action_ready(2.0)
	Input.action_release(&"attack_in_place")
	print("  a release onto a practice post produced %d DamageEvents" % (action.damage_events - events_before))
	_expect(post.release_hits > 0, "the control swing did not resolve onto the post at all")
	_expect(action.damage_events == events_before,
		"striking an inert practice post produced a DamageEvent")
	room.set_cursor_override(null)


# --- 3. Awareness and chase --------------------------------------------------

func _check_awareness_and_chase() -> void:
	print("")
	print("--- Awareness and chase (specification §14.1, §14.2)")
	# Just outside the 10.0 m awareness distance: no engagement.
	await _reset()
	enemy.set_ai_enabled(true)
	enemy.place_at(Vector3(-6.0, 0.0, 0.0))
	await _teleport(Vector3(4.6, 0.0, 0.0))
	await _settle(30)
	var far_distance: float = enemy.distance_to_player()
	print("  player at %.2f m (outside the %.1f m awareness): state %s" % [
		far_distance, data.awareness_distance, enemy.state_name(),
	])
	_expect(far_distance > data.awareness_distance, "the far probe is inside awareness; it proves nothing")
	_expect(enemy.state == PrototypeGraveblade.State.IDLE and not enemy.aware,
		"the Graveblade engaged a player outside its awareness distance")

	# Just inside it: chase begins.
	await _teleport(Vector3(3.4, 0.0, 0.0))
	await _settle(12)
	var near_distance: float = enemy.distance_to_player()
	print("  player at %.2f m (inside it): state %s, aware=%s" % [
		near_distance, enemy.state_name(), str(enemy.aware),
	])
	_expect(near_distance < data.awareness_distance, "the near probe is outside awareness")
	_expect(enemy.aware, "the Graveblade did not notice a player inside its awareness distance")

	# It closes and then HOLDS at its preferred distance rather than walking in.
	var closed: float = await _await_enemy_within(enemy.commit_distance(), 6.0)
	print("  closed to %.2f m in %.2f s (preferred %.2f m, commits at %.2f m)" % [
		enemy.distance_to_player(), closed, data.preferred_attack_distance, enemy.commit_distance(),
	])
	_expect(closed < 6.0, "the chase never reached commitment distance")
	_expect(enemy.distance_to_player() >= data.preferred_attack_distance - 0.35,
		"the Graveblade walked to %.2f m, inside its %.2f m preferred distance" % [
			enemy.distance_to_player(), data.preferred_attack_distance,
		])
	await _park_enemy_away()


# --- 4. The eight states, in order -------------------------------------------

func _check_state_machine() -> void:
	print("")
	print("--- The eight Graveblade states (specification §14.2)")
	for wanted: String in [
		"SPAWN", "IDLE", "CHASE", "WAIT_FOR_ATTACK_PERMISSION",
		"ATTACK_WINDUP", "ATTACK_RELEASE", "ATTACK_RECOVERY", "DEAD",
	]:
		_expect(PrototypeGraveblade.State.has(wanted), "the Graveblade has no %s state" % wanted)
	print("  declared: SPAWN, IDLE, CHASE, WAIT_FOR_ATTACK_PERMISSION,")
	print("            ATTACK_WINDUP, ATTACK_RELEASE, ATTACK_RECOVERY, DEAD")

	await _reset()
	enemy.set_ai_enabled(true)
	enemy.place_at(Vector3(-4.0, 0.0, 0.0))
	await _teleport(Vector3(-2.2, 0.0, 0.0))
	_states.clear()
	var order: PackedStringArray = PackedStringArray()
	for i: int in 260:
		await _step()
		if order.is_empty() or order[order.size() - 1] != enemy.state_name():
			order.append(enemy.state_name())
		if order.size() >= 2 and order[order.size() - 1] == "CHASE" and order.has("ATTACK_RECOVERY"):
			break
	print("  observed: %s" % " -> ".join(order))
	for wanted_state: String in ["CHASE", "WAIT_FOR_ATTACK_PERMISSION", "ATTACK_WINDUP", "ATTACK_RELEASE", "ATTACK_RECOVERY"]:
		_expect(order.has(wanted_state), "%s was never observed: %s" % [wanted_state, str(order)])
	_expect(order.find("WAIT_FOR_ATTACK_PERMISSION") < order.find("ATTACK_WINDUP"),
		"the wind-up began before the permission request")
	_expect(order.find("ATTACK_WINDUP") < order.find("ATTACK_RELEASE"),
		"the release was observed before the wind-up")
	_expect(order.find("ATTACK_RELEASE") < order.find("ATTACK_RECOVERY"),
		"the recovery was observed before the release")

	var measured: Dictionary = _measured_state_durations()
	print("  measured  anticipation %.3f s, release %.3f s, recovery %.3f s" % [
		measured.get("ATTACK_WINDUP", 0.0), measured.get("ATTACK_RELEASE", 0.0),
		measured.get("ATTACK_RECOVERY", 0.0),
	])
	_expect(absf(float(measured.get("ATTACK_WINDUP", 0.0)) - data.anticipation) <= 2.0 * TICK,
		"the measured anticipation was %.3f s, not %.2f s" % [measured.get("ATTACK_WINDUP", 0.0), data.anticipation])
	_expect(absf(float(measured.get("ATTACK_RELEASE", 0.0)) - data.release_window) <= 2.0 * TICK,
		"the measured release window was %.3f s, not %.2f s" % [measured.get("ATTACK_RELEASE", 0.0), data.release_window])
	_expect(absf(float(measured.get("ATTACK_RECOVERY", 0.0)) - data.recovery) <= 2.0 * TICK,
		"the measured recovery was %.3f s, not %.2f s" % [measured.get("ATTACK_RECOVERY", 0.0), data.recovery])
	await _park_enemy_away()


# --- 5. Attack permission ----------------------------------------------------

func _check_attack_permission() -> void:
	print("")
	print("--- Attack permission (specification §14.3)")
	var coordinator: AttackCoordinator = room.attack_coordinator
	# The D-186 group handoff is printed, not asserted, here. It is a GROUP rule
	# and Gate D has one Graveblade, so the honest Gate D statement about it is
	# that this suite's one-enemy result did not move: the window and the enemy's
	# own interval are the same 0.35 s and run together. Its value and every one
	# of its branches are asserted in the Gate E suite, where the group exists.
	print("  coordinator: %d simultaneous attacker(s), %.2f s minimum release gap, %.2f s group handoff" % [
		coordinator.simultaneous_attackers, coordinator.minimum_release_gap,
		coordinator.group_handoff_delay,
	])
	_expect(coordinator.simultaneous_attackers == 1, "more than one attacker may commit at a time")
	_expect(is_equal_approx(coordinator.minimum_release_gap, 0.25),
		"the minimum release gap is %.2f s, not the specified 0.25 s" % coordinator.minimum_release_gap)

	# The Graveblade holds the slot for exactly the duration of its action.
	await _reset()
	await _park_for_attack(1.20)
	_expect(coordinator.holder() == null, "somebody held permission before the attack began")
	var began: bool = await _force_attack()
	_expect(began, "the Graveblade could not obtain permission in an empty room")
	print("  during the wind-up the holder is %s" % (
		coordinator.holder().name if coordinator.holder() != null else "nobody"))
	_expect(coordinator.holds_permission(enemy), "the Graveblade did not hold permission while committing")

	# A second requester is refused while the slot is held.
	var stand_in: Node = Node.new()
	stand_in.name = "SecondAttacker"
	add_child(stand_in)
	var refusals_before: int = coordinator.refusals
	var second: bool = coordinator.request(stand_in)
	print("  a second attacker asking mid-commitment: %s (%s)" % [
		"granted" if second else "refused", coordinator.last_decision,
	])
	_expect(not second, "a second attacker was granted permission during a commitment")
	_expect(coordinator.refusals == refusals_before + 1, "the refusal was not recorded")
	stand_in.queue_free()

	await _await_enemy_ready(4.0)
	print("  after the action the holder is %s" % (
		coordinator.holder().name if coordinator.holder() != null else "nobody"))
	_expect(coordinator.holder() == null, "the Graveblade kept permission after its action ended")

	# The minimum commitment interval gates the next request.
	print("  cooldown after recovery: %.3f s owed of the locked %.2f s" % [
		enemy.commitment_cooldown_remaining(), data.minimum_commitment_interval,
	])
	_expect(enemy.commitment_cooldown_remaining() > 0.0,
		"the minimum commitment interval was not owed immediately after recovery")
	_expect(enemy.commitment_cooldown_remaining() <= data.minimum_commitment_interval + 0.01,
		"the commitment interval is longer than the locked %.2f s" % data.minimum_commitment_interval)
	await _park_enemy_away()


# --- 6. Facing, then commitment ----------------------------------------------

func _check_commitment() -> void:
	print("")
	print("--- Facing during anticipation, then a locked committed direction")
	await _reset()
	await _park_for_attack(1.20)
	await _force_attack()
	await _step()
	_expect(not enemy.committed, "the Graveblade committed on the frame the wind-up began")

	# Early anticipation: the direction tracks the player.
	var early: Vector3 = enemy.release_direction
	await _teleport(_polar_from_enemy(35.0, 1.20))
	await _settle(6)
	var tracked: Vector3 = enemy.release_direction
	var tracked_turn: float = rad_to_deg(early.angle_to(tracked))
	print("  early anticipation: the player moved 35 deg and the direction followed %.1f deg" % tracked_turn)
	_expect(tracked_turn > 5.0, "the release direction did not track the player during early anticipation")

	# Past the commit point: the direction is locked and stops following.
	var elapsed: float = await _await_commitment(1.0)
	print("  committed %.3f s into the %.2f s anticipation (locked value %.2f s), %.2f s before contact" % [
		elapsed, data.anticipation, data.commit_time(), data.committed_lead_time(),
	])
	_expect(enemy.committed, "the Graveblade never committed its release direction")
	_expect(absf(elapsed - data.commit_time()) <= 3.0 * TICK,
		"the commitment landed %.3f s in, not the locked %.3f s" % [elapsed, data.commit_time()])
	_expect(data.committed_lead_time() > 0.15,
		"only %.3f s of visible commitment before contact" % data.committed_lead_time())

	var locked: Vector3 = enemy.release_direction
	await _teleport(_polar_from_enemy(-70.0, 1.20))
	await _settle(6)
	var after: Vector3 = enemy.release_direction
	print("  after the commit the player moved 105 deg and the direction moved %.3f deg" % rad_to_deg(locked.angle_to(after)))
	_expect(rad_to_deg(locked.angle_to(after)) < 0.01,
		"the committed direction followed the player after the commit")
	await _await_enemy_ready(4.0)
	await _park_enemy_away()


# --- 7. Reach, arc, obstruction, and the committed direction -----------------

func _check_release_boundaries() -> void:
	print("")
	print("--- Release validation boundaries (specification §14.2)")
	await _reset()
	await _park_for_attack(1.20)
	var origin: Vector3 = enemy.global_position
	var committed: Vector3 = Vector3(0.0, 0.0, 1.0)

	# Measured on the enemy's OWN release validation, at exact geometry a moving
	# fight cannot reproduce reliably.
	for trial: Dictionary in [
		{"angle": 0.0, "distance": 1.20, "hit": true, "why": "dead ahead, well inside reach"},
		{"angle": 44.0, "distance": 1.20, "hit": true, "why": "just inside the 45 deg half-arc"},
		{"angle": 46.0, "distance": 1.20, "hit": false, "why": "just outside the half-arc"},
		{"angle": 90.0, "distance": 1.20, "hit": false, "why": "beside the committed direction"},
		{"angle": 180.0, "distance": 1.20, "hit": false, "why": "directly behind the commitment"},
		{"angle": 0.0, "distance": 1.60, "hit": true, "why": "just inside the 1.65 m reach"},
		{"angle": 0.0, "distance": 1.70, "hit": false, "why": "just beyond the 1.65 m reach"},
		{"angle": 0.0, "distance": 3.00, "hit": false, "why": "far beyond reach"},
	]:
		var radians: float = deg_to_rad(float(trial["angle"]))
		var at: Vector3 = origin + Vector3(sin(radians), 0.0, cos(radians)) * float(trial["distance"])
		var outcome: Dictionary = enemy.evaluate_release(at, committed)
		var connected: bool = String(outcome["outcome"]) == "hit"
		print("  %6.1f deg at %.2f m -> %-4s  (%s)" % [
			trial["angle"], trial["distance"], "hit" if connected else "miss", trial["why"],
		])
		_expect(connected == bool(trial["hit"]),
			"a target %.0f deg from the commitment at %.2f m %s, which is wrong" % [
				trial["angle"], trial["distance"], "connected" if connected else "missed",
			])
		if not connected:
			_expect(not String(outcome["reason"]).is_empty(), "a miss gave no reason")

	# Obstruction, as a control pair with the SAME origin and the SAME distance,
	# one direction blocked by the room's west wall and one not.
	#
	# It is measured on the release validation rather than on two walking bodies
	# because the room cannot put two 0.80 m bodies within the 1.65 m reach of
	# each other across any of its 1.00 m walls or its 1.50 m barrier — the
	# distance test would answer first and prove nothing about obstruction.
	print("")
	print("  obstruction, as a control pair across the room's 1.00 m west wall:")
	var inner_face: float = -room.clear_half_extent().x
	enemy.place_at(Vector3(inner_face + 0.42, 0.0, 0.0))
	await _settle(2)
	var separation: float = 1.62
	var through_wall: Vector3 = enemy.global_position + Vector3(-separation, 0.0, 0.0)
	var open_floor: Vector3 = enemy.global_position + Vector3(separation, 0.0, 0.0)
	var blocked_outcome: Dictionary = enemy.evaluate_release(through_wall, Vector3(-1.0, 0.0, 0.0))
	var clear_outcome: Dictionary = enemy.evaluate_release(open_floor, Vector3(1.0, 0.0, 0.0))
	print("    %.2f m west, through the wall -> %s (%s)" % [
		separation, blocked_outcome["outcome"], blocked_outcome["reason"],
	])
	print("    %.2f m east, open floor       -> %s (%s)" % [
		separation, clear_outcome["outcome"], clear_outcome["reason"],
	])
	_expect(separation <= data.attack_reach,
		"the obstruction control pair is %.2f m apart, outside the %.2f m reach" % [separation, data.attack_reach])
	_expect(String(clear_outcome["outcome"]) == "hit", "the unobstructed control did not connect")
	_expect(String(blocked_outcome["outcome"]) == "miss", "a target behind a wall was still struck")
	_expect(String(blocked_outcome["reason"]) == "obstructed",
		"the blocked release missed for the wrong reason: %s" % blocked_outcome["reason"])

	await _park_enemy_away()


# --- 8. Moving after the commit creates a genuine miss -----------------------

func _check_genuine_miss_by_repositioning() -> void:
	print("")
	print("--- Repositioning after the commit produces a genuine miss (D-181)")

	# a) Stand still: the same setup connects.
	await _reset()
	await _park_for_attack(1.20)
	var life_before: float = player.life
	await _force_attack()
	await _await_enemy_ready(4.0)
	print("  standing still: %s, player Life %.0f -> %.0f" % [
		enemy.last_release["outcome"], life_before, player.life,
	])
	_expect(String(enemy.last_release["outcome"]) == "hit", "the control attack did not connect")
	_expect(is_equal_approx(player.life, life_before - data.physical_damage),
		"the control attack did not apply exactly %.0f damage" % data.physical_damage)

	# b) Step out of reach after the commit.
	await _reset()
	await _park_for_attack(1.20)
	life_before = player.life
	await _force_attack()
	await _await_commitment(1.0)
	var stepped_to: Vector3 = _polar_from_enemy(0.0, 2.40)
	await _teleport(stepped_to)
	await _await_enemy_ready(4.0)
	print("  stepped back to %.2f m after the commit: %s (%s)" % [
		enemy.distance_to_player(), enemy.last_release["outcome"], enemy.last_release["reason"],
	])
	_expect(player.is_alive(), "the step-back miss was measured against a dead player, so it proves nothing")
	_expect(String(enemy.last_release["outcome"]) == "miss", "stepping out of reach after the commit still connected")
	_expect(is_equal_approx(player.life, life_before), "a missed attack still changed player Life")

	# c) Step around the committed direction without leaving reach. This is the
	#    one that proves the ARC is centred on the commitment rather than on the
	#    Graveblade's current facing.
	await _reset()
	await _park_for_attack(1.20)
	life_before = player.life
	await _force_attack()
	await _await_commitment(1.0)
	var committed: Vector3 = enemy.release_direction
	await _teleport(_polar_from_enemy(80.0, 1.20))
	await _await_enemy_ready(4.0)
	var moved_angle: float = rad_to_deg(committed.angle_to(
		_planar(player.global_position - enemy.global_position).normalized()))
	print("  side-stepped to %.2f m and %.0f deg off the commitment: %s (%s)" % [
		enemy.distance_to_player(), moved_angle,
		enemy.last_release["outcome"], enemy.last_release["reason"],
	])
	_expect(enemy.distance_to_player() <= data.attack_reach,
		"the side-step left reach, so it does not prove the arc")
	_expect(moved_angle > data.attack_arc_degrees * 0.5,
		"the side-step stayed inside the arc, so it should have connected")
	_expect(player.is_alive(), "the side-step miss was measured against a dead player, so it proves nothing")
	_expect(String(enemy.last_release["outcome"]) == "miss",
		"stepping outside the committed arc while staying in reach still connected")
	_expect(is_equal_approx(player.life, life_before), "a missed attack still changed player Life")
	await _park_enemy_away()


# --- 9. Exactly one release query per attack use -----------------------------

func _check_single_release_query() -> void:
	print("")
	print("--- Exactly one release query, and at most one DamageEvent, per use")
	await _reset()
	await _park_for_attack(1.20)
	var started: int = enemy.attacks_started
	var queries: int = enemy.release_queries
	var damage_events: int = player.damage_taken_events

	for i: int in 3:
		await _force_attack()
		await _await_enemy_ready(4.0)
		player.life = player.max_life
		await _step()

	print("  three attacks: %d started, %d released, %d release queries, %d hits, %d DamageEvents" % [
		enemy.attacks_started - started, enemy.attacks_released - (queries),
		enemy.release_queries - queries, enemy.attacks_hit,
		player.damage_taken_events - damage_events,
	])
	_expect(enemy.attacks_started - started == 3, "three requests did not produce three attacks")
	_expect(enemy.release_queries - queries == 3, "three attacks did not produce exactly three release queries")
	_expect(enemy.release_queries == enemy.attacks_released,
		"%d release queries for %d released attacks" % [enemy.release_queries, enemy.attacks_released])
	_expect(player.damage_taken_events - damage_events == 3,
		"three connecting attacks produced %d DamageEvents" % (player.damage_taken_events - damage_events))

	# The marker really is the visible contact pose, measured from the live clip.
	print("  release fired with the attack clip at %s (marker %.3f)" % [
		_format_positions(_release_animation_positions), data.release_marker_normalized(),
	])
	for position: float in _release_animation_positions:
		_expect(absf(position - data.release_marker_normalized()) < 0.001,
			"a release fired with the clip at %.4f rather than the %.4f marker" % [
				position, data.release_marker_normalized(),
			])
	await _park_enemy_away()


# --- 10. Player Life: 500 -> 375 -> 250 -> 125 -> 0 --------------------------

func _check_player_life_progression() -> void:
	print("")
	print("--- Player Life progression (specification §14.1)")
	await _reset()
	await _park_for_attack(1.20)
	player.life = player.max_life
	var wanted: Array[float] = [375.0, 250.0, 125.0, 0.0]
	var observed: Array[float] = []
	for i: int in 4:
		if not player.is_alive():
			break
		await _force_attack()
		await _await_enemy_ready(4.0)
		observed.append(player.life)
		print("    Hit %d: player Life %.0f" % [i + 1, player.life])
	print("  observed: 500 -> %s" % _format_lives(observed))
	_expect(observed.size() == 4, "four attacks produced %d Life steps" % observed.size())
	for i: int in mini(observed.size(), wanted.size()):
		_expect(is_equal_approx(observed[i], wanted[i]),
			"after Hit %d player Life was %.0f, not %.0f" % [i + 1, observed[i], wanted[i]])
	_expect(not player.is_alive(), "the player survived four 125-damage Graveblade Hits")
	_expect(player.action_state == PrototypePlayer.ActionState.FALLEN,
		"the player is at zero Life but not FALLEN")

	# Specification §20.1: everything the fall must cancel.
	print("  on falling: state %s, destination %s, attack phase %s, buffered %s, awaiting neutral %s" % [
		player.action_state_name(), str(player.has_destination), action.phase_name(),
		str(action.buffered), str(player.awaiting_neutral),
	])
	_expect(not player.has_destination, "a fallen player kept a navigation destination")
	_expect(action.phase == QuickStrikeAction.Phase.READY, "a fallen player kept an attack in flight")
	_expect(not action.buffered and not action.holding, "a fallen player kept buffered or held attack input")
	_expect(action.target == null and room.soft_target == null,
		"a fallen player kept a selected target")
	_expect(player.awaiting_neutral, "a fallen player did not latch input to neutral")
	_expect(player.velocity.length() < 0.001, "a fallen player kept moving")
	_expect(room.attack_coordinator.holder() == null,
		"the Graveblade kept attack permission after the player fell")

	# Damage eligibility is gone: a further Hit changes nothing.
	var events_before: int = player.damage_taken_events
	player.receive_damage(DamageEvent.physical(9001, enemy, player, data.physical_damage))
	print("  a further Hit on a fallen player: %d new DamageEvents, Life %.0f" % [
		player.damage_taken_events - events_before, player.life,
	])
	_expect(player.damage_taken_events == events_before, "a fallen player still took damage")
	_expect(is_equal_approx(player.life, 0.0), "a fallen player's Life moved below zero")

	# A fallen player cannot be commanded.
	player.command_move_to(Vector3(2.0, 0.0, 2.0), Vector3(2.0, 0.0, 2.0), false)
	_expect(not player.has_destination, "a fallen player accepted a movement command")
	room.reset_encounter()
	await _settle(6)
	_expect(player.is_alive() and is_equal_approx(player.life, player.max_life),
		"the debug encounter reset did not restore the player")
	await _park_enemy_away()


# --- 11. Enemy Life: 300 -> 200 -> 100 -> 0 ---------------------------------

func _check_enemy_life_progression() -> void:
	print("")
	print("--- Graveblade Life progression and the three-Hit relationship")
	await _reset()
	room.reset_encounter()
	await _settle(6)
	enemy = room.graveblade
	enemy.set_ai_enabled(false)
	await _settle(2)

	var wanted: Array[float] = [200.0, 100.0, 0.0]
	var observed: Array[float] = []
	var kills_before: int = _count_events("kill")
	for i: int in 3:
		await _strike_enemy_once()
		observed.append(enemy.life)
		print("    Hit %d: Graveblade Life %.0f, alive=%s" % [i + 1, enemy.life, str(enemy.is_alive())])
		if i < 2:
			_expect(enemy.is_alive(), "the Graveblade died on Hit %d instead of the third" % (i + 1))
	print("  observed: 300 -> %s" % _format_lives(observed))
	_expect(observed.size() == 3, "three Quick Strikes produced %d Life steps" % observed.size())
	for i: int in mini(observed.size(), wanted.size()):
		_expect(is_equal_approx(observed[i], wanted[i]),
			"after Hit %d Graveblade Life was %.0f, not %.0f" % [i + 1, observed[i], wanted[i]])
	_expect(not enemy.is_alive(), "the Graveblade survived three 100-damage Quick Strikes")
	_expect(_count_events("kill") == kills_before + 1,
		"the third Hit produced %d kill events, not exactly one" % (_count_events("kill") - kills_before))


# --- 12. The hit reaction never interrupts -----------------------------------

func _check_hit_reaction_does_not_interrupt() -> void:
	print("")
	print("--- An ordinary player Hit does not interrupt the Graveblade (§14.2)")
	room.reset_encounter()
	await _settle(6)
	enemy = room.graveblade
	await _reset()
	await _park_for_attack(1.20)
	await _force_attack()
	await _settle(12)

	var state_before: PrototypeGraveblade.State = enemy.state
	var use_before: int = enemy.attack_use_id
	var phase_before: float = enemy.state_time
	var reactions_before: int = enemy.hit_reactions
	enemy.receive_damage(DamageEvent.physical(9101, player, enemy, player.physical_damage))
	await _step()
	print("  struck %.3f s into the wind-up: state %s -> %s, use %d -> %d, reactions %d -> %d" % [
		phase_before, _state_name(state_before), enemy.state_name(),
		use_before, enemy.attack_use_id, reactions_before, enemy.hit_reactions,
	])
	_expect(enemy.state == state_before, "an ordinary Hit changed the Graveblade's action state")
	_expect(enemy.attack_use_id == use_before, "an ordinary Hit restarted the Graveblade's attack")
	_expect(enemy.state_time > phase_before, "an ordinary Hit reset the Graveblade's phase timer")
	_expect(enemy.hit_reactions == reactions_before + 1, "the Hit produced no visible reaction at all")
	_expect(enemy.life < data.max_life, "the interrupt check applied no damage")

	# Struck again after the commit: the committed direction must not move.
	var committed: Vector3 = Vector3.ZERO
	await _await_commitment(1.0)
	committed = enemy.release_direction
	enemy.receive_damage(DamageEvent.physical(9102, player, enemy, player.physical_damage))
	await _step()
	print("  struck again after the commit: committed direction moved %.4f deg" % rad_to_deg(
		committed.angle_to(enemy.release_direction)))
	_expect(rad_to_deg(committed.angle_to(enemy.release_direction)) < 0.01,
		"an ordinary Hit moved the committed release direction")

	var queries_before: int = enemy.release_queries
	await _await_enemy_ready(4.0)
	print("  the interrupted attack still released once: %d query" % (enemy.release_queries - queries_before))
	_expect(enemy.release_queries - queries_before == 1,
		"the twice-struck attack produced %d release queries" % (enemy.release_queries - queries_before))
	await _park_enemy_away()


# --- 13. Death disables everything, immediately ------------------------------

func _check_death_disables_everything() -> void:
	print("")
	print("--- Death is mechanical, immediate, and complete (specification §14.2)")
	room.reset_encounter()
	await _settle(6)
	enemy = room.graveblade
	enemy.set_ai_enabled(false)
	await _settle(2)

	enemy.life = player.physical_damage  ## one Hit from death
	var area: PrototypeTargetable = _enemy_area()
	_expect(area.is_valid_target(), "the Graveblade was not a valid target before dying")

	# Observed from INSIDE the kill event. The room connected to `died` when the
	# Graveblade spawned, so this handler runs after the room's own and still
	# before `_die()` reaches the line that starts the death clip — which is the
	# only way to see, rather than infer, that the decoration had not begun.
	_animation_frame_at_kill_event = -99
	enemy.died.connect(_on_kill_event_observed)
	await _strike_enemy_once()
	if is_instance_valid(enemy) and enemy.died.is_connected(_on_kill_event_observed):
		enemy.died.disconnect(_on_kill_event_observed)

	print("  targeting     is_valid_target()=%s, target layer %d" % [
		str(area.is_valid_target()), area.collision_layer,
	])
	print("  blocking      body layer %d, mask %d" % [enemy.collision_layer, enemy.collision_mask])
	print("  navigation    agent target is its own position, velocity %.3f m/s" % enemy.velocity.length())
	print("  coordinator   holder %s" % (
		room.attack_coordinator.holder().name if room.attack_coordinator.holder() != null else "nobody"))
	_expect(not area.is_valid_target(), "a dead Graveblade is still a valid target")
	_expect(area.collision_layer == 0, "a dead Graveblade is still on the target layer")
	_expect(enemy.collision_layer == 0 and enemy.collision_mask == 0,
		"a dead Graveblade still blocks movement")
	_expect(room.attack_coordinator.holder() == null, "a dead Graveblade still holds attack permission")
	_expect(enemy.state == PrototypeGraveblade.State.DEAD, "the Graveblade is at zero Life but not DEAD")

	# It is gone from the candidate set, so nothing can acquire or approach it.
	var candidates: Array[PrototypeTargetable] = room.target_candidates()
	print("  candidates    %d, the dead Graveblade %s among them" % [
		candidates.size(), "is" if candidates.has(area) else "is NOT",
	])
	_expect(not candidates.has(area), "a dead Graveblade is still a Quick Strike candidate")

	# It cannot attack any more. Asked DIRECTLY rather than through `_force_attack`
	# on purpose: a dead Graveblade is refused before the coordinator is consulted
	# at all, so the refusal here cannot be a D-186 group handoff wearing the
	# wrong label.
	var could_attack: bool = enemy.begin_attack_for_verification()
	_expect(not could_attack, "a dead Graveblade could still begin an attack")
	print("  threat        a dead Graveblade could%s begin an attack" % ("" if could_attack else " NOT"))

	# The decorative death animation started AFTER the kill event and inside the
	# SAME simulation step, so no presentation work sits between the two.
	#
	# BOTH FACTS ARE READ FROM THE SIMULATION TIMELINE, not from the wall clock
	# (Gate F report §10a.5). This check used to assert that the two millisecond
	# stamps were within 1 ms of each other, which measures the machine's load
	# rather than this code: at a load average of 15 on eight cores it read 4 ms
	# and failed for a sequence that had not changed. The millisecond figure is
	# still printed, because it is useful to see; it is no longer what is
	# asserted, and no tolerance, ordering, or authored value moved with the
	# correction.
	print("  decoration    kill event on physics frame %d / process frame %d; death animation on %d / %d" % [
		enemy.died_at_physics_frame, enemy.died_at_process_frame,
		enemy.death_animation_started_at_physics_frame, enemy.death_animation_started_at_process_frame,
	])
	print("                at the kill event the death animation had %s (%d ms of bookkeeping in between)" % [
		"NOT started" if _animation_frame_at_kill_event == -1 else "already started",
		enemy.death_animation_started_at_msec - enemy.died_at_msec,
	])
	_expect(_animation_frame_at_kill_event == -1,
		"the death animation had already started when the kill event fired (stamp %d)" % (
			_animation_frame_at_kill_event))
	_expect(
		enemy.death_animation_started_at_physics_frame == enemy.died_at_physics_frame
		and enemy.death_animation_started_at_process_frame == enemy.died_at_process_frame,
		"the kill event and its decoration are %d physics frames and %d process frames apart; presentation must not sit inside a mechanical call stack" % [
			enemy.death_animation_started_at_physics_frame - enemy.died_at_physics_frame,
			enemy.death_animation_started_at_process_frame - enemy.died_at_process_frame,
		])

	# The player's mechanical death is the mirror of it, checked in §10 above.
	await _settle(30)
	_expect(enemy.state == PrototypeGraveblade.State.DEAD and enemy.velocity.length() < 0.01,
		"the corpse moved after death")


# --- 14. No duplicate damage, no duplicate kill ------------------------------

func _check_duplicate_protection() -> void:
	print("")
	print("--- Duplicate damage and duplicate kill are both refused")
	# The Graveblade from the previous check is dead. Strike it again.
	var kills_before: int = _count_events("kill")
	var hits_before: int = _count_events("hit")
	var life_before: float = enemy.life
	enemy.receive_damage(DamageEvent.physical(9201, player, enemy, player.physical_damage))
	await _step()
	print("  striking a dead Graveblade: Life %.0f -> %.0f, %d new hits, %d new kills" % [
		life_before, enemy.life, _count_events("hit") - hits_before, _count_events("kill") - kills_before,
	])
	_expect(_count_events("kill") == kills_before, "striking a dead Graveblade produced a second kill")
	_expect(_count_events("hit") == hits_before, "striking a dead Graveblade produced damage")

	# A live Graveblade refuses the same use id twice.
	room.reset_encounter()
	await _settle(6)
	enemy = room.graveblade
	enemy.set_ai_enabled(false)
	await _settle(2)
	var event: DamageEvent = DamageEvent.physical(9301, player, enemy, player.physical_damage)
	enemy.receive_damage(event)
	var after_first: float = enemy.life
	enemy.receive_damage(event)
	print("  the same use id applied twice: Life %.0f then %.0f" % [after_first, enemy.life])
	_expect(is_equal_approx(after_first, data.max_life - player.physical_damage),
		"the first application of a use did not apply exactly %.0f damage" % player.physical_damage)
	_expect(is_equal_approx(enemy.life, after_first), "the same use id was applied twice")

	# The same thing through a REAL swing rather than a synthetic event: a dead
	# Graveblade is not a valid target, so the release itself refuses it.
	room.reset_encounter()
	await _settle(6)
	enemy = room.graveblade
	enemy.set_ai_enabled(false)
	await _settle(2)
	enemy.life = player.physical_damage
	await _strike_enemy_once()
	_expect(not enemy.is_alive(), "the set-up Hit did not kill the Graveblade")
	var kills_after_death: int = _count_events("kill")
	var events_before_swing: int = action.damage_events
	await _strike_enemy_once()
	print("  a real Quick Strike at a corpse: %s, %d new DamageEvents, %d new kills" % [
		action.last_release["outcome"], action.damage_events - events_before_swing,
		_count_events("kill") - kills_after_death,
	])
	_expect(String(action.last_release["outcome"]) == "miss",
		"a Quick Strike resolved onto a dead Graveblade")
	_expect(action.damage_events == events_before_swing, "a swing at a corpse produced a DamageEvent")
	_expect(_count_events("kill") == kills_after_death, "a swing at a corpse produced a second kill")

	# The kernel itself never produces more DamageEvents than released uses.
	print("  kernel totals: %d released uses, %d DamageEvents dealt" % [
		action.uses_released, action.damage_events,
	])
	_expect(action.damage_events <= action.uses_released,
		"%d DamageEvents for %d released uses" % [action.damage_events, action.uses_released])
	_expect(action.release_queries == action.uses_released,
		"%d release queries for %d released uses" % [action.release_queries, action.uses_released])


# --- 15. Hit and kill ordering -----------------------------------------------

func _check_event_ordering() -> void:
	print("")
	print("--- Hit and kill ordering (specification §18)")
	room.reset_encounter()
	await _settle(6)
	enemy = room.graveblade
	enemy.set_ai_enabled(false)
	await _settle(2)
	room.combat_events.clear()

	for i: int in 3:
		await _strike_enemy_once()
	var kinds: PackedStringArray = room.combat_event_kinds()
	print("  recorded: %s" % " -> ".join(kinds))
	_expect(kinds.size() == 4, "three Hits recorded %d events, expected three hits and one kill" % kinds.size())
	if kinds.size() == 4:
		_expect(kinds[0] == "hit" and kinds[1] == "hit" and kinds[2] == "hit",
			"the first three recorded events were not all Hits: %s" % str(kinds))
		_expect(kinds[3] == "kill", "the fourth recorded event was %s, not the kill" % kinds[3])
	var hit_time: int = 0
	var kill_time: int = 0
	for entry: Dictionary in room.combat_events:
		if String(entry["kind"]) == "hit":
			hit_time = int(entry["at_msec"])
		elif String(entry["kind"]) == "kill":
			kill_time = int(entry["at_msec"])
	_expect(kill_time >= hit_time, "the kill was recorded before its own Hit")
	var lethal_use: int = 0
	for entry: Dictionary in room.combat_events:
		if String(entry["kind"]) == "kill":
			lethal_use = int(entry["use_id"])
	_expect(lethal_use == int(room.combat_events[2]["use_id"]),
		"the kill was attributed to a different Skill Use than the third Hit")
	print("  the kill carries the third Hit's own Skill Use id, %d" % lethal_use)


# --- 16. Pursuit around the barrier, without disturbing Gate B ---------------

func _check_navigation_around_barrier() -> void:
	print("")
	print("--- Pursuit navigates around the barrier (D-181)")
	room.reset_encounter()
	await _settle(6)
	enemy = room.graveblade
	enemy.set_ai_enabled(true)

	# The barrier's own footprint, so the two stand on opposite sides of it.
	var barrier: AABB = room.room.barrier_aabb()
	var centre: Vector3 = barrier.get_center()
	var enemy_side: Vector3 = Vector3(centre.x, 0.0, barrier.position.z - 1.20)
	var player_side: Vector3 = Vector3(centre.x, 0.0, barrier.end.z + 1.20)
	room.room.set_barrier_enabled(true)
	await _settle(6)
	enemy.place_at(enemy_side)
	await _teleport(player_side)
	await _settle(10)

	var straight: float = enemy_side.distance_to(player_side)
	var direct_walk: float = maxf(straight - enemy.commit_distance(), 0.0)
	var walked: Dictionary = await _await_enemy_within_measuring_path(enemy.commit_distance(), 8.0)
	var path: float = float(walked["path"])
	print("  straight-line gap %.2f m through the barrier, so %.2f m of walking if it" % [straight, direct_walk])
	print("  could go through it. The Graveblade actually walked %.2f m in %.2f s — a" % [path, walked["elapsed"]])
	print("  %.2fx detour, which is the barrier being navigated around." % (path / maxf(direct_walk, 0.001)))
	_expect(float(walked["elapsed"]) < 8.0, "the Graveblade never reached the player around the barrier")
	_expect(path > direct_walk * 1.25,
		"the Graveblade walked %.2f m against a %.2f m direct approach; it did not detour" % [path, direct_walk])

	room.room.set_barrier_enabled(false)
	await _settle(8)
	print("  navigation mesh afterwards: %d polygons, %.1f m^2 (Gate B's own numbers)" % [
		room.navmesh_polygon_count, room.navmesh_area,
	])
	_expect(room.navmesh_polygon_count == 2 and absf(room.navmesh_area - 218.7) < 1.0,
		"the barrier pursuit left the navigation mesh changed")
	await _park_enemy_away()


# --- 17. Scope ---------------------------------------------------------------

func _check_scope() -> void:
	print("")
	print("--- Scope: the accepted Gate D fight is exactly the fight measured here")
	#
	# THIRTEEN ASSERTIONS MOVED FORWARD BY AUTHORIZATION, and the count is
	# unchanged. This check used to forbid, by name, every system D-184 has now
	# authorized: waves, a progression director, XP, loot, a weapon record, and a
	# Drops node. Those clauses are false by authorization rather than by
	# regression, exactly as Gate D moved one Gate C clause under D-181.
	#
	# They were replaced one for one with the boundary that still holds — the
	# GRAVEBLADE ITSELF, which D-184 requires Gate E to "reuse unchanged", and
	# the arrangement this suite measures it in. The suite is still 230 checks.
	#
	# The Gate E suite asserts the far boundary — no inventory, rarity, affix,
	# Passive Web, damage-number setting, disk save, Fallen/Restart, pause, or
	# settings screen — because that is the gate those exclusions belong to now.

	# The Gate E director is SUSPENDED for this run, which is what makes every
	# measurement above the one-Graveblade measurement D-183 accepted.
	_expect(not room.director.active,
		"the progression director is live during the Gate D run; this suite measures one Graveblade in isolation")
	var enemies: int = 0
	for child: Node in room.get_node("Actors").get_children():
		if child is PrototypeGraveblade:
			enemies += 1
	print("  enemies in the room: %d, director suspended: %s" % [enemies, str(not room.director.active)])
	_expect(enemies == 1, "the room holds %d Graveblades; this run measures exactly one" % enemies)
	_expect(room.living_graveblade_count() <= 1,
		"more than one Graveblade is alive during the Gate D run")
	_expect(room.director.progress.stage == LabProgress.Stage.STARTER_FIGHT,
		"the suspended director left the lab past STARTER_FIGHT")
	print("  the director is suspended and produced the authored one-Graveblade arrangement")

	# The Graveblade is reused UNCHANGED (D-184). Its own record still carries
	# the 10 XP reward, and the Graveblade still neither reads nor awards it: the
	# director does, from outside, which is why the enemy needed no edit at all.
	print("  graveblade.experience_reward = %d, and the ENEMY still never reads it:" % data.experience_reward)
	for forbidden: String in [
		"experience", "xp", "award_experience", "grant_xp",
		"loot", "drop", "spawn_drop", "honed_sword", "weapon",
		"wave", "wave_size", "progression", "director",
	]:
		_expect(not (forbidden in enemy),
			"the Graveblade gained a '%s' member; D-184 requires it reused UNCHANGED" % forbidden)
	print("    no XP, loot, weapon, wave, or progression member on the Graveblade itself")

	# No XP on the character either: Gate E deliberately put it on the one
	# authoritative in-memory lab-progress record instead.
	for forbidden: String in ["experience", "xp", "award_experience", "grant_xp"]:
		_expect(not (forbidden in player),
			"the player has an '%s' member; XP belongs to LabProgress" % forbidden)
	print("  no XP member on the player; XP lives on the authoritative LabProgress record")

	# The eleven assertions that replace the eleven the authorization retired,
	# and they are a STRONGER statement of the same boundary. The old ones said
	# the room had no member called "xp". These say that this suite killed the
	# Graveblade repeatedly with the whole Gate E machinery present and loaded,
	# and it awarded nothing: no XP, no sword, no equip, no passive, no wave.
	# Absence proven against a live system beats absence proven against a gap.
	var lab: LabProgress = room.director.progress
	print("  after %d kills in this run, the lab progress record reads: %s" % [
		_count_events("kill"), lab.describe(),
	])
	_expect(lab.experience == 0, "the Gate D run granted %d XP" % lab.experience)
	_expect(not lab.starter_kill_rewarded, "the Gate D run committed the starter-kill milestone")
	_expect(not lab.upgraded_kill_rewarded, "the Gate D run committed the upgraded-kill milestone")
	_expect(not lab.honed_sword_equipped, "the Gate D run equipped the Honed Sword")
	_expect(not lab.quickened_form_active, "the Gate D run activated Quickened Form")
	_expect(lab.repeat_loop_kills == 0, "the Gate D run counted %d repeat-loop kills" % lab.repeat_loop_kills)
	_expect(lab.waves_started == 0, "the Gate D run started %d waves" % lab.waves_started)
	_expect(room.get_node("Drops").get_child_count() == 0,
		"the Gate D run left %d ground drops" % room.get_node("Drops").get_child_count())
	_expect(player.weapon == room.starter_sword,
		"the Gate D run is not being fought with the 100-damage Prototype Training Sword")
	_expect(is_zero_approx(action.increased_attack_speed),
		"the Gate D run has %.2f increased attack speed" % action.increased_attack_speed)
	_expect(not room.any_modal_is_open(), "a Gate E modal surface is open during the Gate D run")
	print("  no XP, no sword, no equip, no passive, no wave, no drop, and no modal — with all of it present")

	# The practice posts stayed inert: the Graveblade was NOT built by giving a
	# fixture Life.
	var fixture: PrototypeTargetFixture = room.fixtures[0]
	for forbidden: String in [
		"life", "max_life", "health", "damage", "take_damage", "die", "death",
		"experience", "xp", "attack_player", "loot", "drop",
	]:
		_expect(not (forbidden in fixture),
			"the practice post gained a '%s' member; the posts must stay inert" % forbidden)
	print("  the Gate C practice posts are still inert, asserted by name")

	# FIVE ASSERTIONS MOVED FORWARD BY AUTHORIZATION, and the count is unchanged.
	# This block forbade the Fallen overlay, the pause menu, the settings panel,
	# the saved state, and the Restart flow by name; D-189 authorises all five, so
	# they are false by authorization rather than by regression — exactly as Gate
	# D moved one Gate C clause under D-181 and Gate E moved eleven of Gate D's
	# under D-184.
	#
	# They are replaced one for one with the boundary that still holds. Gate F's
	# own suite asserts the Gate F contract; this suite asserts that the accepted
	# one-Graveblade fight survived it, which the 230 measurements above already
	# did with every Gate F surface present, loaded, and bound.
	for forbidden: String in ["profile", "rift_anchor", "recovery_cache", "pursuit", "intensity"]:
		_expect(not (forbidden in room),
			"the room has a '%s' member; that is Gate G or first-MVP production" % forbidden)
	print("  no profile, Anchor, Recovery Cache, Pursuit, or Intensity — Gate G is not started")

	# Gate D's own additions cannot change a Gate B result.
	_expect(player.collision_mask & TargetAcquisition.TARGET_MASK == 0,
		"the player collides with target areas, which would change Gate B movement")
	_expect(room.nav_region.navigation_mesh.geometry_collision_mask
		& PrototypeGraveblade.ENEMY_LAYER == 0,
		"the Graveblade is inside the navigation bake mask")
	print("  the Graveblade is on the enemy layer only: not in the navigation bake")
	print("  navigation mesh still %d polygons, %.1f m^2" % [room.navmesh_polygon_count, room.navmesh_area])
	_expect(room.navmesh_polygon_count == 2 and absf(room.navmesh_area - 218.7) < 1.0,
		"the navigation mesh changed: %d polygons, %.1f m^2" % [room.navmesh_polygon_count, room.navmesh_area])
	await _step()


# --- Trace -------------------------------------------------------------------

func _on_state_changed(from: PrototypeGraveblade.State, to: PrototypeGraveblade.State) -> void:
	_states.append({"from": from, "to": to, "at": _clock})


func _on_enemy_released(_outcome: Dictionary) -> void:
	_release_animation_positions.append(enemy.attack_animation_position())


func _measured_state_durations() -> Dictionary:
	var names: Dictionary = {
		PrototypeGraveblade.State.ATTACK_WINDUP: "ATTACK_WINDUP",
		PrototypeGraveblade.State.ATTACK_RELEASE: "ATTACK_RELEASE",
		PrototypeGraveblade.State.ATTACK_RECOVERY: "ATTACK_RECOVERY",
	}
	var durations: Dictionary = {}
	for i: int in _states.size():
		var entry: Dictionary = _states[i]
		if not names.has(entry["to"]) or i + 1 >= _states.size():
			continue
		durations[names[entry["to"]]] = float(_states[i + 1]["at"]) - float(entry["at"])
	return durations


func _count_events(kind: String) -> int:
	var total: int = 0
	for entry: Dictionary in room.combat_events:
		if String(entry["kind"]) == kind:
			total += 1
	return total


## Runs INSIDE `PrototypeGraveblade._die()`, after the room's own handler and
## before the line that starts the death clip. It records whether the decoration
## had begun, which is the honest way to assert the ordering: reading two
## timestamps afterwards only proves that a monotonic clock is monotonic.
func _on_kill_event_observed(_event: DamageEvent) -> void:
	if enemy != null and is_instance_valid(enemy):
		_animation_frame_at_kill_event = enemy.death_animation_started_at_physics_frame


# --- Driving -----------------------------------------------------------------

## One clean Quick Strike onto the Graveblade, in place, from just inside reach.
func _strike_enemy_once() -> void:
	player.mana = player.max_mana
	await _teleport(enemy.global_position - Vector3(1.20, 0.0, 0.0))
	await _face_player(Vector3(1.0, 0.0, 0.0))
	Input.action_press(&"attack_in_place")
	_aim_cursor_at(_enemy_area().targeting_point())
	room.press_quick_strike()
	action.release_input()
	await _await_action_ready(3.0)
	Input.action_release(&"attack_in_place")
	room.set_cursor_override(null)
	await _step()


## Parks the Graveblade with its AI suspended, facing the player, at an exact
## distance, so a check measures the attack rather than the walk to it.
func _park_for_attack(distance: float) -> void:
	enemy.set_ai_enabled(false)
	enemy.place_at(Vector3(0.0, 0.0, -2.0))
	await _teleport(enemy.global_position + Vector3(0.0, 0.0, distance))
	enemy.face_instantly(Vector3(0.0, 0.0, 1.0))
	await _settle(4)
	enemy.place_at(Vector3(0.0, 0.0, -2.0))
	await _step()


## Runs the ordinary forced attack, after waiting out D-186's group handoff.
##
## `begin_attack_for_verification()` asks the coordinator the ordinary way but
## deliberately skips the enemy's own commitment interval, so before D-186 it
## could start a new attack on the frame the previous one ended. The coordinator
## now owes the group 0.35 seconds after any action completes, so a forced attack
## has to wait out exactly the window a second Graveblade would. Gate D's own
## cadence is untouched: the interval this enemy already owed itself and the group
## window are the same 0.35 seconds, started together and ended together.
func _force_attack() -> bool:
	var waited: float = 0.0
	while room.attack_coordinator.group_handoff_active() and waited < 2.0:
		await _step()
		waited += TICK
	return enemy.begin_attack_for_verification()


## Moves the Graveblade far away with its AI suspended, so the NEXT check starts
## from a clean room rather than from wherever the previous one left the fight.
func _park_enemy_away() -> void:
	enemy.set_ai_enabled(false)
	enemy.place_at(Vector3(-7.5, 0.0, -5.5))
	room.attack_coordinator.revoke_all("check finished")
	await _settle(3)


## A point at `degrees` from the Graveblade's +Z axis, `distance` away.
func _polar_from_enemy(degrees: float, distance: float) -> Vector3:
	var radians: float = deg_to_rad(degrees)
	return enemy.global_position + Vector3(sin(radians), 0.0, cos(radians)) * distance


func _post(fixture_name: String) -> PrototypeTargetFixture:
	for fixture: PrototypeTargetFixture in room.fixtures:
		if fixture.fixture_name == fixture_name:
			return fixture
	return null


func _enemy_area() -> PrototypeTargetable:
	return enemy.get_node("TargetArea") as PrototypeTargetable


func _aim_cursor_at(world_point: Vector3) -> void:
	room.set_cursor_override(room.camera_rig.camera.unproject_position(world_point))


## Every check starts from a whole player. Without this a check that expects a
## MISS would pass for the wrong reason as soon as an earlier check had killed
## the player, because a release against a corpse misses too.
func _reset() -> void:
	action.release_input()
	action.clear("verification reset")
	player.clear_movement_intent("verification reset", false)
	room.set_stick_override(null)
	room.set_cursor_override(null)
	room.input_family.family = InputFamilyTracker.Family.MOUSE_KEYBOARD
	player.revive_for_testing()
	player.release_neutral_latch()
	await _settle(4)


func _teleport(to: Vector3) -> void:
	player.clear_movement_intent("verification teleport", false)
	player.global_position = Vector3(to.x, 0.0, to.z)
	player.velocity = Vector3.ZERO
	await _settle(4)


func _face_player(direction: Vector3) -> void:
	player.face_instantly(direction)
	await _step()


func _step() -> void:
	_clock += TICK
	await get_tree().physics_frame


func _settle(frames: int) -> void:
	for i: int in frames:
		await _step()


func _await_action_ready(timeout: float) -> float:
	var elapsed: float = 0.0
	while elapsed < timeout:
		await _step()
		elapsed += TICK
		if not action.busy():
			return elapsed
	return timeout


func _await_enemy_ready(timeout: float) -> float:
	var elapsed: float = 0.0
	while elapsed < timeout:
		await _step()
		elapsed += TICK
		if not enemy.is_attacking():
			return elapsed
	return timeout


## Returns how far into the wind-up the commitment landed, read from the enemy's
## OWN phase clock rather than from when this happened to be called.
func _await_commitment(timeout: float) -> float:
	var elapsed: float = 0.0
	while elapsed < timeout:
		if enemy.committed:
			return enemy.state_time
		await _step()
		elapsed += TICK
	return -1.0


## Like `_await_enemy_within`, but sums the distance actually walked each frame.
## Displacement is not enough here: going around a barrier and coming back to the
## same side would show as almost no displacement at all.
func _await_enemy_within_measuring_path(distance: float, timeout: float) -> Dictionary:
	var elapsed: float = 0.0
	var path: float = 0.0
	var previous: Vector3 = enemy.global_position
	while elapsed < timeout:
		await _step()
		elapsed += TICK
		path += previous.distance_to(enemy.global_position)
		previous = enemy.global_position
		if enemy.distance_to_player() <= distance:
			return {"elapsed": elapsed, "path": path}
	return {"elapsed": elapsed, "path": path}


func _await_enemy_within(distance: float, timeout: float) -> float:
	var elapsed: float = 0.0
	while elapsed < timeout:
		await _step()
		elapsed += TICK
		if enemy.distance_to_player() <= distance:
			return elapsed
	return timeout


func _planar(vector: Vector3) -> Vector3:
	return Vector3(vector.x, 0.0, vector.z)


func _state_name(value: PrototypeGraveblade.State) -> String:
	for key: String in PrototypeGraveblade.State:
		if PrototypeGraveblade.State[key] == value:
			return key
	return "?"


func _format_lives(values: Array[float]) -> String:
	var parts: PackedStringArray = PackedStringArray()
	for value: float in values:
		parts.append("%.0f" % value)
	return " -> ".join(parts)


func _format_positions(values: Array[float]) -> String:
	var parts: PackedStringArray = PackedStringArray()
	for value: float in values:
		parts.append("%.4f" % value)
	return "[%s]" % ", ".join(parts)


func _expect(condition: bool, failure_message: String) -> void:
	_checks += 1
	if not condition:
		_failures.append(failure_message)


func _argument_value(arguments: PackedStringArray, flag: String) -> String:
	var index: int = arguments.find(flag)
	if index == -1 or index + 1 >= arguments.size():
		return ""
	return arguments[index + 1]


# --- Rendered evidence -------------------------------------------------------

func _capture_evidence() -> void:
	print("")
	print("--- Rendered evidence")
	room.reset_encounter()
	await _settle(8)
	enemy = room.graveblade
	room.input_family.family = InputFamilyTracker.Family.MOUSE_KEYBOARD
	room.set_debug_visuals(false)
	room.set_debug_panels(false)

	# 1. Chase: the Graveblade closing on the player, near enough that its
	#    diagnostic Life bar reads and clear of the top-left instruction cards.
	# Placed so its approach projects to the RIGHT of the character under the
	# fixed 45-degree camera, into the one part of the frame no instrumentation
	# card occupies.
	enemy.set_ai_enabled(true)
	enemy.place_at(Vector3(4.5, 0.0, -4.5))
	await _teleport(Vector3(-1.5, 0.0, 1.5))
	await _await_enemy_within(4.4, 5.0)
	_expect(enemy.state == PrototypeGraveblade.State.CHASE,
		"the chase screenshot was taken in state %s" % enemy.state_name())
	var life_bar: Node3D = enemy.get_node("LifeBar") as Node3D
	_expect(life_bar.is_visible_in_tree(),
		"the Graveblade's diagnostic Life bar is not visible while it chases")
	print("  chase screenshot: %.2f m away, Life bar visible=%s" % [
		enemy.distance_to_player(), str(life_bar.is_visible_in_tree()),
	])
	await _shoot("gate_d_chase", 4)

	# 2. Wind-up with the committed direction locked and drawn.
	await _reset()
	room.set_debug_visuals(true)
	room.set_navigation_visuals(false)
	await _park_for_attack(1.30)
	await _force_attack()
	await _await_commitment(1.0)
	_expect(enemy.committed and enemy.state == PrototypeGraveblade.State.ATTACK_WINDUP,
		"the commitment screenshot was not taken during a committed wind-up")
	await _shoot("gate_d_windup_commit", 2)
	await _await_enemy_ready(4.0)

	# 3. A successful release, with the arc it actually used.
	await _reset()
	await _park_for_attack(1.20)
	player.life = player.max_life
	await _force_attack()
	await _await_commitment(1.0)
	await _settle(14)
	_expect(String(enemy.last_release.get("outcome", "")) == "hit",
		"the hit screenshot's release did not connect")
	await _shoot("gate_d_release_hit", 1)
	await _await_enemy_ready(4.0)

	# 4. A genuine miss, created by stepping out of the committed arc.
	await _reset()
	await _park_for_attack(1.20)
	player.life = player.max_life
	await _force_attack()
	await _await_commitment(1.0)
	await _teleport(_polar_from_enemy(80.0, 1.20))
	await _settle(14)
	_expect(String(enemy.last_release.get("outcome", "")) == "miss",
		"the miss screenshot's release connected after all")
	await _shoot("gate_d_genuine_miss", 1)
	await _await_enemy_ready(4.0)

	# 5. The exact third Hit, killing the Graveblade.
	room.reset_encounter()
	await _settle(8)
	enemy = room.graveblade
	enemy.set_ai_enabled(false)
	room.set_debug_panels(true)
	await _strike_enemy_once()
	await _strike_enemy_once()
	_expect(enemy.is_alive() and is_equal_approx(enemy.life, 100.0),
		"the Graveblade was not at 100 Life before the third Hit")
	await _strike_enemy_once()
	_expect(not enemy.is_alive(), "the third Hit did not kill the Graveblade")
	await _shoot("gate_d_third_hit_death", 3)

	# 6. Player mechanical death.
	room.reset_encounter()
	await _settle(8)
	enemy = room.graveblade
	await _park_for_attack(1.20)
	for i: int in 4:
		if not player.is_alive():
			break
		await _force_attack()
		await _await_enemy_ready(4.0)
	_expect(not player.is_alive(), "the FALLEN screenshot was taken with a living player")
	await _shoot("gate_d_player_fallen", 4)

	room.set_debug_panels(false)
	room.set_debug_visuals(false)
	room.set_cursor_override(null)
	room.reset_encounter()


func _shoot(name_stem: String, settle_frames: int) -> void:
	for i: int in settle_frames:
		await RenderingServer.frame_post_draw
	await RenderingServer.frame_post_draw
	var path: String = "%s/%s.png" % [_shot_dir, name_stem]
	# Checked, not assumed: a relative --shots path silently writes nothing, so a
	# run could report "evidence regenerated" while leaving stale images in place.
	var error: Error = get_viewport().get_texture().get_image().save_png(path)
	_expect(error == OK, "could not write %s (error %d); use an absolute --shots path" % [path, error])
	print("  screenshot: %s%s" % [path, "" if error == OK else "  FAILED"])
