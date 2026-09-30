extends Node
## Prototype Zero — Gate C automated verification.
##
## Specification §25 forbids a test framework and states plainly that automated
## tests cannot certify feel. These checks assert only what a machine CAN settle
## about the Quick Strike kernel: that the derived timing adds up to the locked
## action, that the visible contact pose and the release query are the same
## instant, that exactly one release query happens per Skill Use, that targeting
## chooses and refuses for stated reasons, that cancellation keeps or drops the
## right things, that the buffer and the repeat run on the clock they claim, and
## that Mana is charged exactly once to an action that actually happened.
##
## Whether any of it feels good is the project owner's judgement, and the
## controller half of that judgement is still outstanding (D-175).
##
## Run:  godot --headless --path game -- --verify-c
##       godot --path game --resolution 1280x720 -- --verify-c --shots <dir>

const TICK: float = 1.0 / 60.0

var room: PrototypeZeroRoom
var player: PrototypePlayer
var action: QuickStrikeAction
var data: QuickStrikeData

var _failures: PackedStringArray = PackedStringArray()
var _checks: int = 0
var _shot_dir: String = ""

## Live trace of the kernel, recorded from its own signals.
var _events: Array[Dictionary] = []
var _clock: float = 0.0
var _release_animation_positions: Array[float] = []
var _release_blade_angles: Array[float] = []
var _release_blade_reach: Array[float] = []
var _blade_tip_local: Vector3 = Vector3.ZERO


func run(owner_room: PrototypeZeroRoom, arguments: PackedStringArray) -> void:
	room = owner_room
	player = owner_room.player
	action = player.attack
	data = action.data
	_shot_dir = _argument_value(arguments, "--shots")

	print("")
	print("=== Gate C verification ===")
	await _settle(10)
	_blade_tip_local = _measure_blade_tip()

	action.use_started.connect(_on_started)
	action.use_released.connect(_on_released)
	action.use_cancelled.connect(_on_cancelled)
	action.phase_changed.connect(_on_phase)

	_check_locked_data()
	await _check_state_machine()
	await _check_release_marker_alignment()
	await _check_attack_speed_compression()
	await _check_mouse_targeting()
	await _check_approach()
	await _check_attack_in_place()
	await _check_release_arc_and_reach()
	await _check_obstruction()
	await _check_single_target()
	await _check_release_validation_contract()
	await _check_controller_soft_targeting()
	await _check_arbitration_and_cancellation()
	await _check_buffer_and_repeat()
	await _check_mana()
	_check_scope()

	if _shot_dir != "":
		await _capture_evidence()

	print("")
	if _failures.is_empty():
		print("GATE C VERIFICATION: PASS (%d checks)" % _checks)
		get_tree().quit(0)
	else:
		for failure: String in _failures:
			printerr("  FAIL: %s" % failure)
		printerr("GATE C VERIFICATION: %d FAILURE(S) of %d checks" % [_failures.size(), _checks])
		get_tree().quit(1)


# --- 1. The locked record ----------------------------------------------------

func _check_locked_data() -> void:
	print("")
	print("--- Quick Strike data (D-168 timing and cost, D-169 targeting)")
	_expect(data.problem().is_empty(), "quick_strike.tres is incoherent: %s" % data.problem())

	var expectations: Array[Dictionary] = [
		{"what": "wind-up", "got": data.windup_time(), "want": 0.26, "unit": "s"},
		{"what": "release window", "got": data.release_window, "want": 0.06, "unit": "s"},
		{"what": "recovery", "got": data.recovery_time(), "want": 0.48, "unit": "s"},
		{"what": "total action time", "got": data.action_time, "want": 0.80, "unit": "s"},
		{"what": "release marker", "got": data.release_marker_normalized, "want": 0.325, "unit": "of the action"},
		{"what": "input buffer", "got": data.input_buffer, "want": 0.12, "unit": "s"},
		{"what": "reach", "got": data.reach, "want": 1.65, "unit": "m"},
		{"what": "release arc", "got": data.release_arc_degrees, "want": 100.0, "unit": "deg"},
		{"what": "Mana cost", "got": data.mana_cost, "want": 5.0, "unit": ""},
		{"what": "maximum Mana", "got": player.max_mana, "want": 100.0, "unit": ""},
		{"what": "Mana regeneration", "got": player.mana_regeneration, "want": 10.0, "unit": "per second"},
		{"what": "soft-target distance", "got": data.soft_target_distance, "want": 5.0, "unit": "m"},
		{"what": "soft-target cone", "got": data.soft_target_cone_degrees, "want": 65.0, "unit": "deg TOTAL (D-178)"},
		{"what": "cone half-angle", "got": data.soft_target_cone_half_degrees(), "want": 32.5, "unit": "deg either side"},
		{"what": "cone total, enforced", "got": data.soft_target_cone_total_degrees(), "want": 65.0, "unit": "deg"},
		{"what": "angle tie band", "got": data.soft_target_angle_tie_degrees, "want": 12.0, "unit": "deg"},
		{"what": "target retention", "got": data.soft_target_retention, "want": 0.35, "unit": "s"},
	]
	for expectation: Dictionary in expectations:
		print("  %-22s %7.3f %s" % [expectation["what"], expectation["got"], expectation["unit"]])
		_expect(is_equal_approx(float(expectation["got"]), float(expectation["want"])),
			"%s is %.4f, locked value is %.4f" % [
				expectation["what"], expectation["got"], expectation["want"],
			])

	_expect(is_equal_approx(data.windup_time() + data.release_window + data.recovery_time(), data.action_time),
		"the three phases do not add up to the total action time")
	_expect(is_equal_approx(data.release_marker_normalized, 0.26 / 0.80),
		"the release marker is not the locked 0.26 s wind-up expressed in normalised action time")
	# Specification §12.2. Gate E owns the passive; the relationship is the
	# kernel's, and must already be exact.
	print("  0.80 / 1.25           %.4f s   (the Quickened Form relationship, Gate E)" % data.effective_action_time(0.25))
	_expect(is_equal_approx(data.effective_action_time(0.25), 0.64),
		"0.80 s at 25%% increased attack speed is %.4f s, not 0.64 s" % data.effective_action_time(0.25))

	# D-178: the exported number is a TOTAL cone, and the half-angle the query
	# actually compares against is exactly half of it.
	_expect(is_equal_approx(data.soft_target_cone_half_degrees(), data.soft_target_cone_degrees * 0.5),
		"the enforced half-cone is not half of the exported total cone")
	_expect(is_equal_approx(rad_to_deg(data.soft_target_cone_half_radians()), 32.5),
		"the half-cone in radians is %.4f deg, not 32.5" % rad_to_deg(data.soft_target_cone_half_radians()))
	# The D-178 priority boundary is the release reach itself, not a second
	# tunable that could drift away from it.
	print("  in-reach priority     %.2f m   (the release reach itself, D-178)" % data.reach)


# --- 2. States and their measured durations ----------------------------------

func _check_state_machine() -> void:
	print("")
	print("--- Action states (specification §10)")
	await _reset()
	await _teleport(EMPTY_GROUND)
	await _face(Vector3(0.0, 0.0, -1.0))
	_begin_trace()
	_swing_at_empty_ground()
	_expect(action.target == null, "the \"empty ground\" swing found a target; the test spot is not empty")
	var order: PackedStringArray = PackedStringArray()
	var seen_idle: bool = false
	for i: int in 90:
		await _step()
		var name: String = player.action_state_name()
		if order.is_empty() or order[order.size() - 1] != name:
			order.append(name)
		if name == "IDLE" and order.size() > 1:
			seen_idle = true
			break
	print("  observed: %s" % " -> ".join(order))
	_expect(seen_idle, "the action never returned to IDLE")
	_expect(order.has("ATTACK_WINDUP") and order.has("ATTACK_RELEASE") and order.has("ATTACK_RECOVERY"),
		"the wind-up, release, and recovery states were not all observed: %s" % str(order))
	_expect(order.find("ATTACK_WINDUP") < order.find("ATTACK_RELEASE"),
		"release was observed before wind-up")
	_expect(order.find("ATTACK_RELEASE") < order.find("ATTACK_RECOVERY"),
		"recovery was observed before release")

	var durations: Dictionary = _measured_phase_durations()
	print("  measured  wind-up %.3f s, release %.3f s, recovery %.3f s, total %.3f s" % [
		durations.get("ATTACK_WINDUP", 0.0), durations.get("ATTACK_RELEASE", 0.0),
		durations.get("ATTACK_RECOVERY", 0.0), _traced_action_time(),
	])
	_expect(absf(float(durations.get("ATTACK_WINDUP", 0.0)) - 0.26) <= 2.0 * TICK,
		"the measured wind-up was %.3f s, not 0.26 s" % durations.get("ATTACK_WINDUP", 0.0))
	_expect(absf(_traced_action_time() - 0.80) <= 3.0 * TICK,
		"the measured total action was %.3f s, not 0.80 s" % _traced_action_time())

	var started: int = _count("started")
	var released: int = _count("released")
	print("  one use: %d started, %d released, %d release queries" % [started, released, action.release_queries])
	_expect(started == 1 and released == 1, "one press produced %d starts and %d releases" % [started, released])


# --- 3. The release marker really is the visible contact ---------------------

func _check_release_marker_alignment() -> void:
	print("")
	print("--- The release marker is the visible contact (specification §12.1)")
	var clip: StringName = &"prototype/Quick_Strike_Slice"
	var animation_player: AnimationPlayer = _rig().animation_player
	_expect(animation_player.has_animation(clip), "the retimed local clip is not registered on the rig")
	if not animation_player.has_animation(clip):
		return
	var retimed: Animation = animation_player.get_animation(clip)
	print("  retimed clip length   %.4f s (normalised: clip time IS action time), loop=%d" % [
		retimed.length, retimed.loop_mode,
	])
	_expect(is_equal_approx(retimed.length, 1.0), "the retimed clip is %.4f s, not normalised to 1.000 s" % retimed.length)
	_expect(retimed.loop_mode == Animation.LOOP_NONE, "the attack clip loops")
	print("  blade tip in socket   %.3f m from handslot.r" % _blade_tip_local.length())

	_release_animation_positions.clear()
	_release_blade_angles.clear()
	_release_blade_reach.clear()
	await _reset()
	await _teleport(EMPTY_GROUND)
	await _face(Vector3(0.0, 0.0, -1.0))
	for i: int in 3:
		_swing_at_empty_ground()
		await _await_ready(2.0)
	print("  measured at each release, from the LIVE skeleton, not from the plan:")
	for i: int in _release_blade_angles.size():
		print("    release %d: clip at %.4f, blade %.2f deg off the facing, %.3f m ahead" % [
			i + 1, _release_animation_positions[i], _release_blade_angles[i], _release_blade_reach[i],
		])
	_expect(_release_blade_angles.size() == 3, "expected three releases, recorded %d" % _release_blade_angles.size())
	for i: int in _release_blade_angles.size():
		_expect(absf(_release_animation_positions[i] - data.release_marker_normalized) < 0.001,
			"release %d fired with the clip at %.4f rather than the %.4f marker" % [
				i + 1, _release_animation_positions[i], data.release_marker_normalized,
			])
		_expect(absf(_release_blade_angles[i]) <= 3.0,
			"at release %d the blade was %.1f deg off the character's facing" % [i + 1, _release_blade_angles[i]])
		# The mechanical reach must not promise more than the swing shows.
		_expect(_release_blade_reach[i] >= data.reach - 0.05,
			"at release %d the blade reached only %.3f m against a %.2f m mechanical reach" % [
				i + 1, _release_blade_reach[i], data.reach,
			])
	print("  the visible blade is on the facing axis, %.3f m out, against a %.2f m reach" % [
		_release_blade_reach[0] if not _release_blade_reach.is_empty() else 0.0, data.reach,
	])


# --- 4. Attack speed compresses everything together --------------------------

func _check_attack_speed_compression() -> void:
	print("")
	print("--- Attack speed compresses every phase together (specification §12.2)")
	await _reset()
	await _teleport(EMPTY_GROUND)
	await _face(Vector3(0.0, 0.0, -1.0))
	action.increased_attack_speed = 0.25
	_release_animation_positions.clear()
	_release_blade_angles.clear()
	_release_blade_reach.clear()
	_begin_trace()
	_swing_at_empty_ground()
	await _await_ready(2.0)
	var total: float = _traced_action_time()
	var durations: Dictionary = _measured_phase_durations()
	print("  at 25%% increased attack speed: wind-up %.3f s, total %.3f s (target 0.208 / 0.640)" % [
		durations.get("ATTACK_WINDUP", 0.0), total,
	])
	_expect(absf(total - 0.64) <= 3.0 * TICK, "the sped-up action ran %.3f s, not 0.64 s" % total)
	_expect(absf(float(durations.get("ATTACK_WINDUP", 0.0)) - 0.208) <= 2.0 * TICK,
		"the sped-up wind-up ran %.3f s, not 0.208 s" % durations.get("ATTACK_WINDUP", 0.0))
	_expect(not _release_animation_positions.is_empty()
		and absf(_release_animation_positions[0] - data.release_marker_normalized) < 0.001,
		"the release marker moved when attack speed changed")
	_expect(not _release_blade_angles.is_empty() and absf(_release_blade_angles[0]) <= 3.0,
		"the visible contact pose drifted at higher attack speed")
	print("  the marker and the visible pose are unchanged; nothing stays locked after the visual ends")
	action.increased_attack_speed = 0.0


# --- 5. Mouse targeting ------------------------------------------------------

func _check_mouse_targeting() -> void:
	print("")
	print("--- Mouse targeting (specification §11.1)")
	await _reset()
	room.input_family.family = InputFamilyTracker.Family.MOUSE_KEYBOARD
	var post: PrototypeTargetFixture = _post("Practice Post A")
	await _teleport(post.global_position - Vector3(1.2, 0.0, 0.0))

	_aim_cursor_at(post.targeting_point())
	var picked: Dictionary = room.resolve_quick_strike_aim()
	print("  cursor over %s -> %s" % [post.fixture_name, picked["reason"]])
	_expect(picked["target"] == post, "the cursor over a post did not select it")

	# An empty patch of floor selects nothing and aims where the cursor points.
	var ground: Vector3 = player.global_position + Vector3(0.0, 0.0, 3.0)
	_aim_cursor_at(ground)
	var directional: Dictionary = room.resolve_quick_strike_aim()
	print("  cursor over open floor -> %s" % directional["reason"])
	_expect(directional["target"] == null, "an empty floor click selected a target anyway")
	var aim: Vector3 = directional["direction"]
	var wanted: Vector3 = Vector3(ground.x - player.global_position.x, 0.0, ground.z - player.global_position.z).normalized()
	_expect(Vector3(aim.x, 0.0, aim.z).normalized().dot(wanted) > 0.97,
		"the directional swing did not aim toward the cursor")

	# D-178 changed the CONTROLLER cone and priority only. The mouse path has no
	# cone, no acquisition distance, and no in-reach priority group: the cursor
	# picks exactly what it is over. Each of those is asserted rather than
	# assumed, because a shared helper is exactly how such a rule leaks.
	await _reset()
	room.input_family.family = InputFamilyTracker.Family.MOUSE_KEYBOARD
	await _teleport(Vector3(0.0, 0.0, -3.0))
	await _face(Vector3(1.0, 0.0, 0.0))
	var wide_probe: PrototypeTargetFixture = room.add_probe_fixture(
		"Mouse Wide Probe", _polar(60.0, 4.0, Vector3(0.0, 0.0, -3.0))
	)
	await _step()
	_aim_cursor_at(wide_probe.targeting_point())
	var wide_pick: Dictionary = room.resolve_quick_strike_aim()
	print("  cursor over a post 60 deg off the facing (outside the %.1f deg controller half-cone) -> %s" % [
		data.soft_target_cone_half_degrees(), wide_pick["reason"],
	])
	_expect(wide_pick["target"] == wide_probe, "the mouse pick obeyed the controller cone")
	_expect(String(wide_pick.get("group", "")) == "cursor",
		"the mouse pick reported a controller priority group")

	var distant_probe: PrototypeTargetFixture = room.add_probe_fixture(
		"Mouse Distant Probe", _polar(0.0, 8.0, Vector3(0.0, 0.0, -3.0))
	)
	await _step()
	_aim_cursor_at(distant_probe.targeting_point())
	var distant_pick: Dictionary = room.resolve_quick_strike_aim()
	print("  cursor over a post 8.00 m away (beyond the %.1f m controller acquisition distance) -> %s" % [
		data.soft_target_distance, distant_pick["reason"],
	])
	_expect(distant_pick["target"] == distant_probe, "the mouse pick obeyed the controller acquisition distance")

	# An explicit cursor pick still wins over something at arm's length: the
	# in-reach priority group is a controller rule, not a global one.
	var arm_probe: PrototypeTargetFixture = room.add_probe_fixture(
		"Mouse Arm Probe", _polar(0.0, 1.2, Vector3(0.0, 0.0, -3.0))
	)
	await _step()
	_aim_cursor_at(distant_probe.targeting_point())
	var over_the_shoulder: Dictionary = room.resolve_quick_strike_aim()
	print("  a post 1.20 m away and the cursor on one 8.00 m away -> %s" % over_the_shoulder["reason"])
	_expect(_planar_distance(player.global_position, arm_probe.global_position) <= data.reach,
		"the arm's-length probe is not inside reach, so this proves nothing")
	_expect(over_the_shoulder["target"] == distant_probe,
		"the mouse pick was overridden by an in-reach post; D-178 leaked into the mouse path")
	room.remove_probe_fixture(wide_probe)
	room.remove_probe_fixture(distant_probe)
	room.remove_probe_fixture(arm_probe)
	room.set_cursor_override(null)


# --- 6. Automatic approach ---------------------------------------------------

func _check_approach() -> void:
	print("")
	print("--- Automatic approach (specification §10, §11.1)")
	await _reset()
	var post: PrototypeTargetFixture = _post("Practice Post A")
	# `place_at` moves a post's REST position as well as the post, and this check
	# deliberately moves one mid-approach. Remember where the scene authored it so
	# the layout every later check and every evidence screenshot sees is the
	# authored one. (Without this, Post A stayed 3 m north for the rest of the run
	# and the soft-target evidence shot became ambiguous.)
	var authored_home: Vector3 = post.home_position()
	await _teleport(Vector3(-3.0, 0.0, 0.0))
	var start_distance: float = _planar_distance(player.global_position, post.global_position)
	_aim_cursor_at(post.targeting_point())
	_begin_trace()
	room.press_quick_strike()
	action.release_input()
	await _step()
	print("  pressed at %.2f m: state %s" % [start_distance, player.action_state_name()])
	_expect(player.action_state == PrototypePlayer.ActionState.APPROACH_TARGET,
		"a distant target did not enter APPROACH_TARGET")
	_expect(action.use_id == 0 or _count("started") == 0, "the wind-up began before the approach finished")

	var walked: float = await _await_phase(QuickStrikeAction.Phase.WINDUP, 6.0)
	var stopped_at: float = _planar_distance(player.global_position, post.global_position)
	print("  approached for %.2f s and began the wind-up at %.3f m (reach %.2f, margin %.2f)" % [
		walked, stopped_at, data.reach, data.approach_stop_margin,
	])
	_expect(walked < 6.0, "the approach never reached the target")
	_expect(stopped_at <= data.reach - data.approach_stop_margin + 0.10,
		"the wind-up began at %.3f m, outside %.3f m" % [stopped_at, data.reach - data.approach_stop_margin])
	await _await_ready(2.0)
	_expect(post.release_hits > 0, "the approach ended without the release connecting")

	# §11.1: "Re-evaluate range during approach; do not walk to the enemy's old
	# position after it moves or dies."
	await _reset()
	await _teleport(Vector3(-3.0, 0.0, 0.0))
	_aim_cursor_at(post.targeting_point())
	room.press_quick_strike()
	action.release_input()
	await _settle(20)
	post.place_at(Vector3(post.global_position.x, 0.0, post.global_position.z + 3.0))
	await _await_phase(QuickStrikeAction.Phase.WINDUP, 6.0)
	var chased: float = _planar_distance(player.global_position, post.global_position)
	print("  the target moved 3.0 m mid-approach; the wind-up began %.3f m from its NEW position" % chased)
	_expect(chased <= data.reach, "the approach walked to the target's old position")
	await _await_ready(2.0)
	post.reset()
	await _step()

	# A target that stops being valid clears instead of stranding the approach.
	await _reset()
	await _teleport(Vector3(-3.0, 0.0, 0.0))
	_aim_cursor_at(post.targeting_point())
	room.press_quick_strike()
	action.release_input()
	await _settle(12)
	post.set_active(false)
	await _settle(6)
	print("  the target became invalid mid-approach: state %s, attack phase %s" % [
		player.action_state_name(), action.phase_name(),
	])
	_expect(action.phase == QuickStrikeAction.Phase.READY, "an invalid approach target did not clear the attempt")
	_expect(action.release_queries == _releases_before_invalid, "an invalid target still produced a release query")
	post.place_at(authored_home)
	post.reset()
	print("  %s restored to its authored position %s" % [post.fixture_name, str(post.position)])
	_expect(post.position.is_equal_approx(authored_home),
		"%s did not return to the position the scene authored" % post.fixture_name)
	room.set_cursor_override(null)


var _releases_before_invalid: int = 0


# --- 7. Attack in place ------------------------------------------------------

func _check_attack_in_place() -> void:
	print("")
	print("--- Attack in place (specification §9.1, §11.1)")
	await _reset()
	var post: PrototypeTargetFixture = _post("Practice Post A")
	await _teleport(post.global_position - Vector3(4.0, 0.0, 0.0))
	var before: Vector3 = player.global_position
	var hits_before: int = post.release_hits

	Input.action_press(&"attack_in_place")
	_aim_cursor_at(post.targeting_point())
	room.press_quick_strike()
	action.release_input()
	await _step()
	print("  Shift held on a target 4.00 m away: state %s" % player.action_state_name())
	_expect(player.action_state == PrototypePlayer.ActionState.ATTACK_WINDUP,
		"attack-in-place still walked toward the target")
	await _await_ready(2.0)
	var travelled: float = _planar_distance(before, player.global_position)
	print("  moved %.3f m, %s" % [travelled, "clean miss" if post.release_hits == hits_before else "CONNECTED"])
	_expect(travelled < 0.05, "attack-in-place moved the character %.3f m" % travelled)
	_expect(post.release_hits == hits_before, "an out-of-reach attack-in-place still connected")
	_expect(String(action.last_release.get("outcome", "")) == "miss", "the out-of-reach swing did not miss cleanly")
	Input.action_release(&"attack_in_place")
	room.set_cursor_override(null)


# --- 8. Release arc and reach ------------------------------------------------

func _check_release_arc_and_reach() -> void:
	print("")
	print("--- Release arc and reach (specification §11.3)")
	await _reset()
	room.input_family.family = InputFamilyTracker.Family.MOUSE_KEYBOARD
	var forward: Vector3 = Vector3(0.0, 0.0, 1.0)
	var probe: PrototypeTargetFixture = room.add_probe_fixture("Arc Probe", Vector3.ZERO)

	for trial: Dictionary in [
		{"angle": 0.0, "distance": 1.20, "hit": true, "why": "dead ahead, well inside reach"},
		{"angle": 45.0, "distance": 1.20, "hit": true, "why": "inside the 50 deg half-arc"},
		{"angle": 49.0, "distance": 1.20, "hit": true, "why": "just inside the half-arc"},
		{"angle": 55.0, "distance": 1.20, "hit": false, "why": "just outside the half-arc"},
		{"angle": 90.0, "distance": 1.20, "hit": false, "why": "beside the character"},
		{"angle": 0.0, "distance": 1.60, "hit": true, "why": "just inside the 1.65 m reach"},
		{"angle": 0.0, "distance": 1.75, "hit": false, "why": "just beyond the 1.65 m reach"},
		{"angle": 0.0, "distance": 3.00, "hit": false, "why": "far beyond reach"},
	]:
		await _reset()
		await _teleport(Vector3(0.0, 0.0, -3.0))
		await _face(forward)
		var angle: float = deg_to_rad(float(trial["angle"]))
		var offset: Vector3 = Vector3(sin(angle), 0.0, cos(angle)) * float(trial["distance"])
		probe.place_at(player.global_position + offset)
		probe.reset()
		await _step()
		# Attack in place and straight ahead, so the swing does not approach and
		# the facing is exactly the one this trial set.
		Input.action_press(&"attack_in_place")
		_aim_cursor_at(player.global_position + forward * 3.0)
		room.press_quick_strike()
		action.release_input()
		await _await_ready(2.0)
		Input.action_release(&"attack_in_place")
		var connected: bool = probe.release_hits > 0
		print("  %5.1f deg at %.2f m -> %-4s  (%s)" % [
			trial["angle"], trial["distance"], "hit" if connected else "miss", trial["why"],
		])
		_expect(connected == bool(trial["hit"]),
			"a probe %.0f deg away at %.2f m %s, which is wrong" % [
				trial["angle"], trial["distance"], "connected" if connected else "missed",
			])
	room.remove_probe_fixture(probe)
	room.set_cursor_override(null)


# --- 9. Obstruction ----------------------------------------------------------

func _check_obstruction() -> void:
	print("")
	print("--- Obstruction (specification §11.3, \"unobstructed\")")
	await _reset()
	var half: Vector2 = room.clear_half_extent()
	# Stand close to the west wall with a probe on the far side of it: inside
	# reach, dead ahead, and separated by world geometry.
	var stand: Vector3 = Vector3(-half.x + 0.55, 0.0, 0.0)
	await _teleport(stand)
	await _face(Vector3(-1.0, 0.0, 0.0))
	var probe: PrototypeTargetFixture = room.add_probe_fixture("Obstruction Probe", Vector3(-half.x - 0.90, 0.0, 0.0))
	await _step()
	var distance: float = _planar_distance(player.global_position, probe.global_position)
	var blocked: bool = room.acquisition.is_obstructed(
		player.global_position + Vector3.UP * 1.10, probe.targeting_point()
	)
	print("  probe %.2f m ahead (inside the %.2f m reach), wall between: obstructed=%s" % [
		distance, data.reach, str(blocked),
	])
	_expect(distance < data.reach, "the obstruction probe was placed outside reach, so the test proves nothing")
	_expect(blocked, "the wall between the character and the probe was not detected")

	Input.action_press(&"attack_in_place")
	_aim_cursor_at(probe.targeting_point())
	room.press_quick_strike()
	action.release_input()
	await _await_ready(2.0)
	Input.action_release(&"attack_in_place")
	print("  release outcome: %s — %s" % [
		action.last_release.get("outcome", "?"), action.last_release.get("reason", "?"),
	])
	_expect(probe.release_hits == 0, "the release reached through a wall")
	_expect(String(action.last_release.get("outcome", "")) == "miss", "an obstructed release did not miss")

	# Control: the same distance and angle with nothing in the way must connect,
	# so the miss above is attributable to the wall and not to reach or arc. The
	# probe moves to the ROOM side and the character turns to face it.
	probe.place_at(player.global_position + Vector3(distance, 0.0, 0.0))
	probe.reset()
	await _face(Vector3(1.0, 0.0, 0.0))
	await _step()
	var control_blocked: bool = room.acquisition.is_obstructed(
		player.global_position + Vector3.UP * 1.10, probe.targeting_point()
	)
	Input.action_press(&"attack_in_place")
	_aim_cursor_at(probe.targeting_point())
	room.press_quick_strike()
	action.release_input()
	await _await_ready(2.0)
	Input.action_release(&"attack_in_place")
	print("  control: same distance and angle on THIS side of the wall, obstructed=%s -> %s" % [
		str(control_blocked), action.last_release.get("outcome", "?"),
	])
	_expect(not control_blocked, "the control probe was reported obstructed with nothing in the way")
	_expect(probe.release_hits == 1, "the unobstructed control probe did not connect")
	room.remove_probe_fixture(probe)
	room.set_cursor_override(null)


# --- 10. One target per use --------------------------------------------------

func _check_single_target() -> void:
	print("")
	print("--- One target per use, and the explicit target is preferred (§11.3)")
	await _reset()
	await _teleport(Vector3(0.0, 0.0, -3.0))
	await _face(Vector3(0.0, 0.0, 1.0))
	var near: PrototypeTargetFixture = room.add_probe_fixture("Near Probe", player.global_position + Vector3(-0.55, 0.0, 1.00))
	var far: PrototypeTargetFixture = room.add_probe_fixture("Far Probe", player.global_position + Vector3(0.55, 0.0, 1.40))
	await _step()

	Input.action_press(&"attack_in_place")
	_aim_cursor_at(far.targeting_point())
	room.press_quick_strike()
	action.release_input()
	await _await_ready(2.0)
	Input.action_release(&"attack_in_place")
	print("  two posts inside the arc, cursor on the farther one: near %d hit(s), far %d hit(s)" % [
		near.release_hits, far.release_hits,
	])
	_expect(near.release_hits + far.release_hits == 1, "one release resolved onto %d targets" % (near.release_hits + far.release_hits))
	_expect(far.release_hits == 1, "the explicit target was not preferred over a nearer one")

	# With no explicit target the nearest legal one inside the arc is chosen.
	near.reset()
	far.reset()
	await _reset()
	await _teleport(Vector3(0.0, 0.0, -3.0))
	await _face(Vector3(0.0, 0.0, 1.0))
	near.place_at(player.global_position + Vector3(-0.55, 0.0, 1.00))
	far.place_at(player.global_position + Vector3(0.55, 0.0, 1.40))
	await _step()
	Input.action_press(&"attack_in_place")
	_aim_cursor_at(player.global_position + Vector3(0.0, 0.0, 4.0))
	room.press_quick_strike()
	action.release_input()
	await _await_ready(2.0)
	Input.action_release(&"attack_in_place")
	print("  no explicit target: near %d hit(s), far %d hit(s)" % [near.release_hits, far.release_hits])
	_expect(near.release_hits == 1 and far.release_hits == 0,
		"without an explicit target the nearest legal post was not chosen")
	room.remove_probe_fixture(near)
	room.remove_probe_fixture(far)
	room.set_cursor_override(null)


# --- 10b. Release validation is untouched by D-178 ---------------------------

## Specification §11.3, asserted by calling `resolve_release` directly rather
## than through a swing, so every clause is separable: the 1.65 m reach, the 100
## degree arc, the explicit-target preference, the nearest-legal fallback, the
## one-target maximum, and validity. Obstruction is asserted twice elsewhere —
## end to end against the west wall in check 9, and through this same direct call
## against the barrier in check 11.
##
## This exists because D-178 changed how a target is CHOSEN. It must not have
## changed how a release is VALIDATED: release validation has no cone, no
## acquisition distance, and no in-reach priority group.
func _check_release_validation_contract() -> void:
	print("")
	print("--- Release validation is unchanged by D-178 (specification §11.3)")
	await _reset()
	var origin: Vector3 = Vector3(0.0, 0.0, -3.0)
	await _teleport(origin)
	var facing: Vector3 = Vector3(0.0, 0.0, 1.0)
	await _face(facing)

	var ahead: PrototypeTargetFixture = room.add_probe_fixture("Release Ahead", origin + Vector3(0.0, 0.0, 1.20))
	var wide: PrototypeTargetFixture = room.add_probe_fixture("Release Wide", origin + Vector3(0.70, 0.0, 1.21))
	var beyond: PrototypeTargetFixture = room.add_probe_fixture("Release Beyond", origin + Vector3(0.0, 0.0, 2.50))
	var outside: PrototypeTargetFixture = room.add_probe_fixture("Release Outside Arc", origin + Vector3(1.13, 0.0, 0.41))
	await _step()
	var all: Array[PrototypeTargetable] = [ahead, wide, beyond, outside]

	print("  probes: ahead %.2f m / 0 deg, wide %.2f m / 30 deg, beyond %.2f m, outside-arc %.0f deg" % [
		_planar_distance(origin, ahead.global_position),
		_planar_distance(origin, wide.global_position),
		_planar_distance(origin, beyond.global_position),
		rad_to_deg(facing.angle_to((outside.global_position - origin).normalized())),
	])

	# No explicit target: the nearest legal candidate inside the arc.
	var nearest: Dictionary = room.acquisition.resolve_release(origin, facing, null, all, data)
	print("  no explicit target -> %s on %s (%s)" % [
		nearest["outcome"],
		(nearest["target"] as PrototypeTargetFixture).fixture_name if nearest["target"] != null else "nothing",
		nearest["reason"],
	])
	_expect(nearest["target"] == ahead, "release validation did not choose the nearest legal candidate")

	# The explicit target is preferred even though it is not the nearest.
	var explicit: Dictionary = room.acquisition.resolve_release(origin, facing, wide, all, data)
	print("  explicit target 30 deg off and farther -> %s (%s)" % [explicit["outcome"], explicit["reason"]])
	_expect(explicit["target"] == wide, "release validation did not prefer the explicit target")

	# An explicit target that is no longer legal falls back rather than reaching.
	var stale: Dictionary = room.acquisition.resolve_release(origin, facing, beyond, all, data)
	print("  explicit target out of reach -> %s on %s" % [
		stale["outcome"],
		(stale["target"] as PrototypeTargetFixture).fixture_name if stale["target"] != null else "nothing",
	])
	_expect(stale["target"] == ahead, "an out-of-reach explicit target was struck anyway")
	_expect(stale["target"] != beyond, "release validation extended past the reach to rescue a bad target")

	# Every rejection reason is stated, and each is the right one.
	var rejections: Dictionary = {}
	for record: Dictionary in stale["considered"]:
		rejections[(record["fixture"] as PrototypeTargetable).target_display_name()] = String(record["rejected"])
	print("  rejections: beyond -> \"%s\"; outside arc -> \"%s\"" % [
		rejections.get("Release Beyond", ""), rejections.get("Release Outside Arc", ""),
	])
	_expect(String(rejections.get("Release Beyond", "")).contains("reach"),
		"a target past the reach was not rejected for the reach")
	_expect(String(rejections.get("Release Outside Arc", "")).contains("arc"),
		"a target outside the release arc was not rejected for the arc")

	# One target maximum, whatever is standing in the arc.
	ahead.reset()
	wide.reset()
	Input.action_press(&"attack_in_place")
	_aim_cursor_at(origin + facing * 4.0)
	room.press_quick_strike()
	action.release_input()
	await _await_ready(2.0)
	Input.action_release(&"attack_in_place")
	print("  one swing with four probes present: %d total release hit(s)" % (
		ahead.release_hits + wide.release_hits + beyond.release_hits + outside.release_hits))
	_expect(ahead.release_hits + wide.release_hits + beyond.release_hits + outside.release_hits == 1,
		"one release resolved onto more than the %d permitted target" % data.maximum_targets)

	# Validity, with nothing else legal to fall back to.
	ahead.set_active(false)
	var invalid_only: Array[PrototypeTargetable] = [ahead]
	var invalid: Dictionary = room.acquisition.resolve_release(origin, facing, ahead, invalid_only, data)
	print("  the only candidate is invalid -> %s (%s)" % [invalid["outcome"], invalid["reason"]])
	_expect(String(invalid["outcome"]) == "miss", "an invalid target was struck")
	ahead.set_active(true)

	for probe: PrototypeTargetable in all:
		room.remove_probe_fixture(probe)
	room.set_cursor_override(null)


# --- 11. Controller soft targeting -------------------------------------------

## Fixed world point for the soft-targeting checks. Probe positions are measured
## from THIS, not from `player.global_position`: a live stick override moves the
## character, and placing probes against a moving origin made the geometry depend
## on how process and physics frames happened to interleave.
const AIM_ORIGIN: Vector3 = Vector3(0.0, 0.0, -3.0)

## Where the barrier sub-check stands. The optional F4 barrier is a 4.0 x 1.5 m
## box at (-4.5, -3.5), so a character just north-east of its corner can have a
## near candidate behind it and a far candidate on a bearing that clears it.
const BARRIER_AIM_ORIGIN: Vector3 = Vector3(-2.2, 0.0, -1.5)

## The point `_pin()` returns the character to between aims.
var _pin_point: Vector3 = AIM_ORIGIN


## Probe placement in polar coordinates about the pin point, with 0 degrees along
## +X. Every soft-targeting case below is stated as "this many degrees off the
## intended direction, this far away", so the geometry reads like the rule.
func _polar(degrees: float, distance: float, about: Vector3 = AIM_ORIGIN) -> Vector3:
	var radians: float = deg_to_rad(degrees)
	return about + Vector3(cos(radians) * distance, 0.0, sin(radians) * distance)


## A soft-target decision with retention deliberately cleared, so a block that is
## testing PRIORITY is not silently answered by the previous pick. There is no
## awaited frame between clearing and deciding, so nothing can re-acquire.
func _fresh_soft_target() -> Dictionary:
	_set_soft_target_directly(null)
	return room.resolve_quick_strike_aim()


func _target_name(answer: Dictionary) -> String:
	var fixture: PrototypeTargetable = answer.get("target", null) as PrototypeTargetable
	return fixture.target_display_name() if fixture != null else "no target"


func _check_controller_soft_targeting() -> void:
	print("")
	print("--- Controller soft targeting (specification §11.2, D-169, D-178)")
	print("  cone %.0f deg TOTAL (+/-%.1f deg), acquisition %.1f m, in-reach priority inside %.2f m" % [
		data.soft_target_cone_total_degrees(), data.soft_target_cone_half_degrees(),
		data.soft_target_distance, data.reach,
	])
	await _reset()
	room.input_family.family = InputFamilyTracker.Family.CONTROLLER
	_pin_point = AIM_ORIGIN
	await _teleport(AIM_ORIGIN)
	await _face(Vector3(0.0, 0.0, 1.0))

	var east: PrototypeTargetFixture = room.add_probe_fixture("East Probe", AIM_ORIGIN + Vector3(3.0, 0.0, 0.0))
	var north: PrototypeTargetFixture = room.add_probe_fixture("North Probe", AIM_ORIGIN + Vector3(0.0, 0.0, 3.0))
	await _step()
	_pin()
	_expect(absf(_planar_distance(player.global_position, east.global_position) - 3.0) < 0.01
		and absf(_planar_distance(player.global_position, north.global_position) - 3.0) < 0.01,
		"the soft-targeting probes are not 3.00 m from the character; the geometry under test is wrong")

	for trial: Dictionary in [
		{"world": Vector3(1.0, 0.0, 0.0), "want": east, "why": "stick toward the east probe"},
		{"world": Vector3(0.0, 0.0, 1.0), "want": north, "why": "stick toward the north probe"},
		{"world": Vector3(0.0, 0.0, -1.0), "want": null, "why": "stick away from both, nothing behind"},
		{"world": Vector3(-1.0, 0.0, 0.0), "want": null, "why": "stick west, both probes far outside the cone"},
	]:
		await _aim_pinned(trial["world"])
		var answer: Dictionary = _fresh_soft_target()
		print("  %-46s -> %-14s (%s)" % [trial["why"], _target_name(answer), answer["reason"]])
		_expect(answer["target"] == trial["want"], "%s selected %s" % [trial["why"], _target_name(answer)])

	# No surprising backwards snap: a target directly behind is never chosen.
	var behind: PrototypeTargetFixture = room.add_probe_fixture("Behind Probe", AIM_ORIGIN + Vector3(0.0, 0.0, -2.0))
	await _step()
	await _aim_pinned(Vector3(0.0, 0.0, 1.0))
	var forward_answer: Dictionary = _fresh_soft_target()
	print("  a probe 180 deg behind, stick forward -> %s" % _target_name(forward_answer))
	_expect(forward_answer["target"] != behind, "aim assistance snapped to a target behind the intended direction")
	room.remove_probe_fixture(behind)

	# Acquisition distance is a real boundary.
	east.place_at(AIM_ORIGIN + Vector3(6.0, 0.0, 0.0))
	await _aim_pinned(Vector3(1.0, 0.0, 0.0))
	var too_far: Dictionary = _fresh_soft_target()
	print("  the east probe at 6.00 m, beyond the %.1f m acquisition distance -> %s" % [
		data.soft_target_distance, "no target" if too_far["target"] == null else "SELECTED",
	])
	_expect(too_far["target"] == null, "a target beyond the acquisition distance was selected")
	east.place_at(AIM_ORIGIN + Vector3(4.5, 0.0, 0.0))
	await _aim_pinned(Vector3(1.0, 0.0, 0.0))
	_expect(_fresh_soft_target()["target"] == east, "a target at 4.50 m inside the cone was not selected")

	await _check_cone_boundary(east, north)
	await _check_in_reach_priority(east, north)
	await _check_distant_wins_when_near_is_ineligible(east, north)
	await _check_angle_first_without_an_in_reach_target(east, north)
	await _check_soft_target_retention(east, north)
	await _check_retention_cannot_outrank_in_reach(east, north)
	await _check_facing_fallback_and_untargeted_swing(east, north)

	room.remove_probe_fixture(east)
	room.remove_probe_fixture(north)
	room.set_stick_override(null)
	room.input_family.family = InputFamilyTracker.Family.MOUSE_KEYBOARD


## D-178's boundary. The cone is 65 degrees TOTAL, so 32.5 either side: 32 deg
## off the intended direction is eligible and 33 deg is not. Both probes sit at
## 4.00 m, outside the release reach, so the in-reach tier cannot answer this.
func _check_cone_boundary(east: PrototypeTargetFixture, north: PrototypeTargetFixture) -> void:
	print("")
	print("  the %.0f deg TOTAL cone is a real boundary at +/-%.1f deg (D-178)" % [
		data.soft_target_cone_total_degrees(), data.soft_target_cone_half_degrees(),
	])
	north.place_at(AIM_ORIGIN + Vector3(-6.0, 0.0, 0.0))  # parked: behind and beyond
	for trial: Dictionary in [
		{"degrees": 0.0, "eligible": true},
		{"degrees": 32.0, "eligible": true},
		{"degrees": 33.0, "eligible": false},
		{"degrees": 64.0, "eligible": false},
	]:
		east.place_at(_polar(float(trial["degrees"]), 4.0))
		await _aim_pinned(Vector3(1.0, 0.0, 0.0))
		var answer: Dictionary = _fresh_soft_target()
		var selected: bool = answer["target"] == east
		print("    %5.1f deg off intent at 4.00 m -> %-11s (%s)" % [
			trial["degrees"], "eligible" if selected else "rejected", answer["reason"],
		])
		_expect(selected == bool(trial["eligible"]),
			"a candidate %.1f deg off intent was %s against a %.1f deg half-cone" % [
				trial["degrees"], "selected" if selected else "rejected",
				data.soft_target_cone_half_degrees(),
			])


## The D-178 headline: a candidate already inside the release reach outranks a
## better-aimed candidate that would need an approach.
func _check_in_reach_priority(east: PrototypeTargetFixture, north: PrototypeTargetFixture) -> void:
	print("")
	print("  in-reach priority: a post at arm's length is not walked past (D-178)")
	east.place_at(AIM_ORIGIN + Vector3(4.5, 0.0, 0.1))
	north.place_at(AIM_ORIGIN + Vector3(1.4, 0.0, 0.5))
	await _aim_pinned(Vector3(1.0, 0.0, 0.0))
	var near_distance: float = _planar_distance(player.global_position, north.global_position)
	var far_distance: float = _planar_distance(player.global_position, east.global_position)
	var answer: Dictionary = _fresh_soft_target()
	print("    1.3 deg at %.2f m against 19.7 deg at %.2f m (inside the %.2f m reach) -> %s" % [
		far_distance, near_distance, data.reach, _target_name(answer),
	])
	print("    group: %s" % answer["group"])
	_expect(near_distance <= data.reach,
		"the near probe is %.3f m away, outside the %.2f m reach, so this proves nothing" % [
			near_distance, data.reach,
		])
	_expect(far_distance > data.reach, "the far probe is inside reach, so this proves nothing")
	_expect(answer["target"] == north,
		"the better-aimed approach target beat a candidate already inside reach")
	_expect(String(answer["group"]) == "in reach", "the decision did not report the in-reach group")

	# Pressing it must strike where it stands rather than entering APPROACH.
	var before: Vector3 = player.global_position
	north.reset()
	north.place_at(AIM_ORIGIN + Vector3(1.4, 0.0, 0.5))
	await _step()
	_pin()
	room.press_quick_strike()
	action.release_input()
	await _step()
	print("    pressed with that choice: state %s" % player.action_state_name())
	_expect(player.action_state == PrototypePlayer.ActionState.ATTACK_WINDUP,
		"an in-reach soft target still entered APPROACH_TARGET")
	await _await_ready(2.0)
	print("    it connected: %d release hit(s) on the in-reach post, %.3f m travelled" % [
		north.release_hits, _planar_distance(before, player.global_position),
	])
	_expect(north.release_hits == 1, "the in-reach soft target was not struck")
	north.reset()


## The other half of the same rule: when the near candidate is not eligible, the
## distant well-aimed candidate is chosen exactly as it was before D-178.
func _check_distant_wins_when_near_is_ineligible(
	east: PrototypeTargetFixture, north: PrototypeTargetFixture
) -> void:
	print("")
	print("  the distant aligned post wins when the near one is not eligible")
	east.place_at(AIM_ORIGIN + Vector3(4.5, 0.0, 0.1))

	# (i) the near candidate is inside reach but outside the cone.
	north.place_at(_polar(40.0, 1.4866))
	await _aim_pinned(Vector3(1.0, 0.0, 0.0))
	var outside: Dictionary = _fresh_soft_target()
	print("    near post 40.0 deg off intent at %.2f m (outside the cone) -> %s [%s]" % [
		_planar_distance(player.global_position, north.global_position),
		_target_name(outside), outside["group"],
	])
	_expect(outside["target"] == east, "an in-reach post outside the cone was selected anyway")
	_expect(String(outside["group"]) == "approach", "the group was not the approach group")

	# (ii) the near candidate is inside reach and inside the cone, but invalid.
	north.place_at(AIM_ORIGIN + Vector3(1.4, 0.0, 0.5))
	north.set_active(false)
	await _aim_pinned(Vector3(1.0, 0.0, 0.0))
	var invalid: Dictionary = _fresh_soft_target()
	print("    near post inside reach and inside the cone but INVALID -> %s [%s]" % [
		_target_name(invalid), invalid["group"],
	])
	_expect(invalid["target"] == east, "an invalid in-reach post was selected")
	_expect(String(invalid["group"]) == "approach", "the group was not the approach group")
	north.set_active(true)
	await _step()

	# (iii) the near candidate is inside reach and inside the cone, but a wall is
	#       between. The F4 barrier is the only obstacle small enough for the far
	#       candidate's bearing to clear it, so this sub-case moves house.
	await _check_obstructed_near_candidate(east, north)


## Barrier sub-case, run as a controlled pair: the SAME geometry with the barrier
## off must choose the near post, and with the barrier on must choose the far
## one. Without the control, "the far one won" would not prove the wall did it.
func _check_obstructed_near_candidate(
	east: PrototypeTargetFixture, north: PrototypeTargetFixture
) -> void:
	_pin_point = BARRIER_AIM_ORIGIN
	await _teleport(BARRIER_AIM_ORIGIN)
	var intent: Vector3 = Vector3(0.0, 0.0, -1.0)
	await _face(intent)
	# Near: 1.49 m at 19.7 deg, just past the barrier's north face.
	north.place_at(Vector3(-2.70, 0.0, -2.90))
	# Far: 4.50 m at 1.3 deg, on a bearing that misses the barrier entirely.
	east.place_at(Vector3(-2.098, 0.0, -5.999))
	await _step()
	_pin()
	var near_distance: float = _planar_distance(player.global_position, north.global_position)
	var far_distance: float = _planar_distance(player.global_position, east.global_position)
	_expect(near_distance <= data.reach and far_distance > data.reach,
		"the barrier sub-case geometry is wrong: near %.2f m, far %.2f m" % [near_distance, far_distance])

	await _aim_pinned(intent)
	var control: Dictionary = _fresh_soft_target()
	print("    control, barrier OFF: near %.2f m / far %.2f m -> %s [%s]" % [
		near_distance, far_distance, _target_name(control), control["group"],
	])
	_expect(control["target"] == north, "the control run did not choose the in-reach post")

	room.room.set_barrier_enabled(true)
	await _settle(6)
	_pin()
	await _aim_pinned(intent)
	var blocked: Dictionary = _fresh_soft_target()
	print("    barrier ON, the near post is behind it -> %s [%s]" % [
		_target_name(blocked), blocked["group"],
	])
	_expect(blocked["target"] == east, "an obstructed in-reach post was still selected")
	_expect(String(blocked["group"]) == "approach", "the group was not the approach group")

	# Release validation obeys the same obstruction, called directly.
	await _face(Vector3(north.global_position - player.global_position).normalized())
	var candidates: Array[PrototypeTargetable] = [north]
	var obstructed_release: Dictionary = room.acquisition.resolve_release(
		player.global_position, player.facing_direction(), north, candidates, data
	)
	print("    resolve_release on the obstructed post -> %s (%s)" % [
		obstructed_release["outcome"], obstructed_release["reason"],
	])
	_expect(String(obstructed_release["outcome"]) == "miss", "release validation reached through the barrier")

	room.room.set_barrier_enabled(false)
	await _settle(6)
	var clear_release: Dictionary = room.acquisition.resolve_release(
		player.global_position, player.facing_direction(), north, candidates, data
	)
	print("    barrier OFF again: resolve_release -> %s; navigation %d polygons, %.1f m^2" % [
		clear_release["outcome"], room.navmesh_polygon_count, room.navmesh_area,
	])
	_expect(String(clear_release["outcome"]) == "hit",
		"the control release missed with nothing in the way, so the barrier proved nothing")
	_expect(room.navmesh_polygon_count == 2 and absf(room.navmesh_area - 218.7) < 1.0,
		"the barrier sub-case left the navigation mesh at %d polygons, %.1f m^2" % [
			room.navmesh_polygon_count, room.navmesh_area,
		])

	_pin_point = AIM_ORIGIN
	await _teleport(AIM_ORIGIN)
	await _face(Vector3(1.0, 0.0, 0.0))


## With NOTHING inside the release reach, the pre-D-178 order is untouched: angle
## is primary, distance decides only a near tie.
func _check_angle_first_without_an_in_reach_target(
	east: PrototypeTargetFixture, north: PrototypeTargetFixture
) -> void:
	print("")
	print("  no in-reach candidate: angle first, distance second, unchanged")

	# (i) inside the tie band: the nearer post wins.
	east.place_at(_polar(2.0, 4.5))
	north.place_at(_polar(7.6, 2.5))
	await _aim_pinned(Vector3(1.0, 0.0, 0.0))
	var near_tie: Dictionary = _fresh_soft_target()
	print("    2.0 deg at 4.50 m against 7.6 deg at 2.50 m (inside the %.0f deg tie band) -> %s [%s]" % [
		data.soft_target_angle_tie_degrees, _target_name(near_tie), near_tie["group"],
	])
	_expect(_planar_distance(player.global_position, north.global_position) > data.reach,
		"the tie-band probe is inside reach, so this no longer tests the tie band")
	_expect(near_tie["target"] == north, "inside the tie band the nearer post did not win")
	_expect(String(near_tie["group"]) == "approach", "the group was not the approach group")

	# (ii) outside the tie band: the better angle wins even though it is farther.
	east.place_at(_polar(1.3, 4.5))
	north.place_at(_polar(19.7, 2.5))
	await _aim_pinned(Vector3(1.0, 0.0, 0.0))
	var wide: Dictionary = _fresh_soft_target()
	print("    1.3 deg at 4.50 m against 19.7 deg at 2.50 m (outside the tie band) -> %s [%s]" % [
		_target_name(wide), wide["group"],
	])
	_expect(_planar_distance(player.global_position, north.global_position) > data.reach,
		"the wide probe is inside reach, so this no longer tests the angle order")
	_expect(wide["target"] == east,
		"the better-aimed post did not win outside the tie band, which is the specification order")


## Retention is bounded in time: it holds a still-eligible but now-worse target
## briefly, then lets go. The stick stays neutral so the character does not walk
## out of its own test while the window runs; with a neutral stick the intended
## direction is the facing, which is priority 5 of the same list.
func _check_soft_target_retention(
	east: PrototypeTargetFixture, north: PrototypeTargetFixture
) -> void:
	print("")
	print("  the %.2f s retention window holds a near tie, then lets go" % data.soft_target_retention)
	room.set_stick_override(Vector2.ZERO)
	_pin()
	east.place_at(_polar(0.0, 3.0))
	north.place_at(_polar(40.0, 2.6))
	await _step()
	_pin()
	await _face(Vector3(1.0, 0.0, 0.0))
	_expect(_fresh_soft_target()["target"] == east, "the retention test did not start on the east probe")

	# Swing the intent to 24 deg, where east sits 24 deg off and north 16 deg: a
	# NEAR TIE, both inside the 12 deg band and both outside reach, with north
	# nearer. Without retention north wins immediately on distance.
	await _face(Vector3(cos(deg_to_rad(24.0)), 0.0, sin(deg_to_rad(24.0))))
	var held: Dictionary = room.resolve_quick_strike_aim()
	var remaining: float = room.soft_target_retention_remaining()
	print("    near tie, north 8 deg better and 0.4 m nearer, %.2f s of retention left -> %s" % [
		remaining, _target_name(held),
	])
	_expect(held["target"] == east and remaining > 0.0,
		"the brief retention permitted by §11.2 did not hold the previous target")

	await _settle(int(data.soft_target_retention / TICK) + 8)
	var released: Dictionary = room.resolve_quick_strike_aim()
	print("    after the %.2f s window expires -> %s (%s)" % [
		data.soft_target_retention, _target_name(released), released["reason"],
	])
	_expect(released["target"] == north,
		"retention outlived its window and kept a target that was no longer the sensible one")


## D-178's last rule: retention may not preserve an out-of-reach approach target
## once a valid in-reach target appears, even well inside the stability window.
func _check_retention_cannot_outrank_in_reach(
	east: PrototypeTargetFixture, north: PrototypeTargetFixture
) -> void:
	print("")
	print("  retention cannot keep an out-of-reach target when an in-reach one appears")
	room.set_stick_override(Vector2.ZERO)
	east.place_at(_polar(0.0, 3.0))
	north.place_at(_polar(80.0, 4.0))  # parked outside the cone to start with
	await _step()
	_pin()
	await _face(Vector3(1.0, 0.0, 0.0))
	var start: Dictionary = _fresh_soft_target()
	print("    starts on the out-of-reach east probe at 3.00 m -> %s [%s]" % [
		_target_name(start), start["group"],
	])
	_expect(start["target"] == east and String(start["group"]) == "approach",
		"the retention/in-reach test did not start on an out-of-reach approach target")

	# A valid in-reach post appears, WORSE on angle than the retained one.
	north.place_at(_polar(19.7, 1.45))
	await _step()
	_pin()
	var remaining: float = room.soft_target_retention_remaining()
	var answer: Dictionary = room.resolve_quick_strike_aim()
	print("    an in-reach post appears 19.7 deg off at 1.45 m with %.2f s of retention still owed -> %s [%s]" % [
		remaining, _target_name(answer), answer["group"],
	])
	_expect(remaining > 0.0,
		"the retention window had already expired, so this did not test retention")
	_expect(answer["target"] == north,
		"retention preserved an out-of-reach approach target over a valid in-reach target")
	_expect(String(answer["group"]) == "in reach", "the decision did not report the in-reach group")


## Priority 5 and priority 6 of §11.2: current facing supplies the intended
## direction when the stick is neutral, and with no sensible target the attack is
## an untargeted directional swing with no automatic movement.
func _check_facing_fallback_and_untargeted_swing(
	east: PrototypeTargetFixture, north: PrototypeTargetFixture
) -> void:
	print("")
	print("  facing fallback and the untargeted directional swing")
	east.place_at(_polar(0.0, 3.0))
	north.place_at(_polar(90.0, 3.0))
	room.set_stick_override(Vector2.ZERO)
	await _step()
	_pin()
	await _face(Vector3(1.0, 0.0, 0.0))
	var neutral: Dictionary = _fresh_soft_target()
	print("    stick neutral, facing east -> %s (%s)" % [_target_name(neutral), neutral["source"]])
	_expect(neutral["target"] == east, "the neutral-stick facing fallback did not choose the target ahead")
	_expect(String(neutral["source"]).contains("facing"), "the neutral stick did not report a facing fallback")

	# Nothing sensible anywhere: a directional swing along the facing, no walking.
	east.place_at(_polar(180.0, 3.0))
	north.place_at(_polar(90.0, 3.0))
	await _step()
	_pin()
	await _reset()
	room.set_stick_override(Vector2.ZERO)
	_pin()
	await _face(Vector3(1.0, 0.0, 0.0))
	var before: Vector3 = player.global_position
	var facing: Vector3 = player.facing_direction()
	var empty: Dictionary = _fresh_soft_target()
	_expect(empty["target"] == null, "a swing with nothing in the cone still found a target")
	_expect(Vector3(empty["direction"]).normalized().dot(facing) > 0.999,
		"the untargeted swing did not aim along the current facing")
	room.press_quick_strike()
	action.release_input()
	await _step()
	print("    no eligible target, stick neutral: state %s, aim %s" % [
		player.action_state_name(), empty["reason"],
	])
	_expect(player.action_state == PrototypePlayer.ActionState.ATTACK_WINDUP,
		"an untargeted swing entered %s instead of winding up in place" % player.action_state_name())
	await _await_ready(2.0)
	var travelled: float = _planar_distance(before, player.global_position)
	print("    it swung in place: %.3f m travelled, outcome %s" % [
		travelled, action.last_release.get("outcome", "?"),
	])
	_expect(travelled < 0.05, "an untargeted swing walked %.3f m" % travelled)
	_expect(String(action.last_release.get("outcome", "")) == "miss",
		"an untargeted swing with nothing in reach did not miss cleanly")

	# The same with the stick held toward empty space: the aim follows the stick,
	# and there is still no approach.
	await _reset()
	await _aim_pinned(Vector3(0.0, 0.0, -1.0))
	var stick_aim: Dictionary = _fresh_soft_target()
	_expect(stick_aim["target"] == null, "the empty stick direction found a target")
	var stick_direction: Vector3 = room.camera_rig.ground_right() * room.read_stick_raw().x \
		+ room.camera_rig.ground_forward() * -room.read_stick_raw().y
	_expect(Vector3(stick_aim["direction"]).normalized().dot(stick_direction.normalized()) > 0.999,
		"the untargeted swing did not aim along the stick direction")
	room.press_quick_strike()
	action.release_input()
	await _step()
	print("    stick held toward empty space: state %s, source %s" % [
		player.action_state_name(), stick_aim["source"],
	])
	_expect(player.action_state == PrototypePlayer.ActionState.ATTACK_WINDUP,
		"an untargeted swing with the stick held entered %s" % player.action_state_name())
	_expect(String(stick_aim["source"]).contains("stick"), "a held stick did not report the stick direction")
	await _await_ready(2.0)
	room.set_stick_override(null)


# --- 12. Held-input arbitration and cancellation -----------------------------

func _check_arbitration_and_cancellation() -> void:
	print("")
	print("--- Held-input arbitration and cancellation (specification §9.5, §10)")

	# A held stick that was already down must AIM the attack, not cancel it.
	await _reset()
	room.input_family.family = InputFamilyTracker.Family.CONTROLLER
	await _teleport(EMPTY_GROUND)
	await _face(Vector3(0.0, 0.0, -1.0))
	_aim_stick_world(Vector3(0.0, 0.0, -1.0))
	await _settle(12)
	_expect(action.target == null and room.soft_target == null,
		"the arbitration test spot is not clear of practice posts")
	_expect(player.movement_mode == PrototypePlayer.MovementMode.CONTROLLER_DIRECT,
		"the stick was not driving before the attack")
	room.press_quick_strike()
	await _settle(6)
	print("  stick held, then attack pressed: phase %s, stick stale %s, suspended %s" % [
		action.phase_name(), str(player.stick_is_stale()), str(player.movement_is_suspended_by_attack()),
	])
	_expect(action.phase == QuickStrikeAction.Phase.WINDUP,
		"a still-held stick cancelled the wind-up on the next frame")
	_expect(player.stick_is_stale(), "the held stick was not suspended for the attack")

	# ... and after release it resumes, cancelling only the recovery.
	var before_release: int = action.release_queries
	await _await_phase(QuickStrikeAction.Phase.RELEASE, 1.0)
	_expect(action.release_queries == before_release + 1, "the release did not happen")
	await _settle(4)
	print("  after release, still holding the stick: state %s, recoveries cut %d" % [
		player.action_state_name(), action.recoveries_cancelled,
	])
	_expect(action.recoveries_cancelled >= 1, "the held stick did not resume and cancel the recovery")
	_expect(not action.busy(), "the action was still running after the recovery was cancelled")
	room.set_stick_override(null)
	room.input_family.family = InputFamilyTracker.Family.MOUSE_KEYBOARD
	await _settle(4)

	# The mouse half of the same rule: a left button held through the attack
	# resumes at release and ends the recovery, rather than being forgotten.
	await _reset()
	await _teleport(Vector3(0.0, 0.0, 0.0))
	await _face(Vector3(0.0, 0.0, 1.0))
	var held_probe: PrototypeTargetFixture = room.add_probe_fixture("Held Mouse Probe", Vector3(0.0, 0.0, 1.2))
	await _step()
	_aim_cursor_at(Vector3(-5.0, 0.0, 0.0))
	_press_mouse(true)
	await _settle(8)
	_expect(player.has_destination, "the held left button never issued a movement command")
	_aim_cursor_at(held_probe.targeting_point())
	Input.action_press(&"attack_in_place")
	room.press_quick_strike()
	action.release_input()
	await _settle(6)
	print("  left button held, then attack pressed: phase %s, destination held %s" % [
		action.phase_name(), str(player.has_destination),
	])
	_expect(action.phase == QuickStrikeAction.Phase.WINDUP,
		"a still-held left button cancelled the wind-up on the next frame")
	_expect(not player.has_destination, "the held click destination was not suspended for the attack")
	var mouse_cuts_before: int = action.recoveries_cancelled
	_aim_cursor_at(Vector3(-5.0, 0.0, 0.0))
	await _await_phase(QuickStrikeAction.Phase.RELEASE, 1.0)
	await _settle(10)
	print("  after release with the button still down: hit kept (%d), recovery cut (%d), state %s" % [
		held_probe.release_hits, action.recoveries_cancelled - mouse_cuts_before, player.action_state_name(),
	])
	_expect(held_probe.release_hits == 1, "the suspended-then-resumed mouse hold lost the release")
	_expect(action.recoveries_cancelled == mouse_cuts_before + 1,
		"a held left button did not resume and cancel the recovery")
	_press_mouse(false)
	Input.action_release(&"attack_in_place")
	room.remove_probe_fixture(held_probe)
	room.set_cursor_override(null)
	await _await_arrival(6.0)

	# Movement DURING the wind-up cancels with no release at all.
	await _reset()
	await _teleport(Vector3(0.0, 0.0, 0.0))
	await _face(Vector3(0.0, 0.0, 1.0))
	var probe: PrototypeTargetFixture = room.add_probe_fixture("Cancel Probe", Vector3(0.0, 0.0, 1.2))
	var queries_before: int = action.release_queries
	var mana_before: float = player.mana
	Input.action_press(&"attack_in_place")
	_aim_cursor_at(probe.targeting_point())
	room.press_quick_strike()
	await _settle(6)
	_expect(action.phase == QuickStrikeAction.Phase.WINDUP, "the wind-up did not start")
	var cancelled_use: int = action.use_id
	var elapsed: float = action.phase_time
	var destination: Vector3 = room.resolve_to_navigation(Vector3(4.0, 0.0, 0.0))["point"]
	player.command_move_to(destination, destination, false)
	await _settle(4)
	Input.action_release(&"attack_in_place")
	print("  moved %.3f s into a %.3f s wind-up: use %d cancelled, %d release queries, %.0f Mana spent" % [
		elapsed, data.windup_time(), cancelled_use, action.release_queries - queries_before,
		mana_before - player.mana,
	])
	_expect(action.release_queries == queries_before, "a cancelled wind-up still produced a release query")
	_expect(probe.release_hits == 0, "a cancelled wind-up still connected")
	_expect(player.mana >= mana_before - 0.001, "a cancelled wind-up still spent Mana")
	_expect(not action.buffered, "a cancelled wind-up kept its buffered repeat")
	_expect(player.action_state == PrototypePlayer.ActionState.NAVIGATE,
		"the character did not move after cancelling the wind-up")
	await _await_arrival(6.0)

	# Movement AFTER the release keeps the hit and only ends the recovery.
	await _reset()
	await _teleport(Vector3(0.0, 0.0, 0.0))
	await _face(Vector3(0.0, 0.0, 1.0))
	probe.reset()
	probe.place_at(Vector3(0.0, 0.0, 1.2))
	await _step()
	Input.action_press(&"attack_in_place")
	_aim_cursor_at(probe.targeting_point())
	room.press_quick_strike()
	await _await_phase(QuickStrikeAction.Phase.RECOVERY, 2.0)
	Input.action_release(&"attack_in_place")
	var cut_before: int = action.recoveries_cancelled
	var into_recovery: float = action.phase_time
	var target_point: Vector3 = room.resolve_to_navigation(Vector3(-4.0, 0.0, 0.0))["point"]
	player.command_move_to(target_point, target_point, false)
	await _settle(3)
	print("  moved %.3f s into a %.3f s recovery: hit kept (%d), recovery cut (%d), state %s" % [
		into_recovery, data.recovery_time(), probe.release_hits,
		action.recoveries_cancelled - cut_before, player.action_state_name(),
	])
	_expect(probe.release_hits == 1, "cancelling the recovery removed an effect that had already been released")
	_expect(action.recoveries_cancelled == cut_before + 1, "the recovery was not cancelled")
	_expect(player.action_state == PrototypePlayer.ActionState.NAVIGATE, "the character did not move immediately")
	await _await_arrival(6.0)

	# A movement command outranks an old attack repeat: a still-held attack
	# button does not restart on its own.
	await _reset()
	await _teleport(Vector3(0.0, 0.0, 0.0))
	probe.reset()
	probe.place_at(Vector3(0.0, 0.0, 1.2))
	Input.action_press(&"attack_in_place")
	_aim_cursor_at(probe.targeting_point())
	room.press_quick_strike()
	await _await_phase(QuickStrikeAction.Phase.RECOVERY, 2.0)
	var walk_to: Vector3 = room.resolve_to_navigation(Vector3(3.0, 0.0, 3.0))["point"]
	player.command_move_to(walk_to, walk_to, false)
	await _settle(60)
	print("  attack button still held after a movement command: holding %s, stale %s, phase %s" % [
		str(action.holding), str(action.holding_stale), action.phase_name(),
	])
	_expect(action.holding and action.holding_stale, "the held attack was not marked stale by a movement command")
	_expect(action.phase == QuickStrikeAction.Phase.READY, "a superseded held attack restarted on its own")
	action.release_input()
	Input.action_release(&"attack_in_place")
	room.remove_probe_fixture(probe)
	room.set_cursor_override(null)
	await _await_arrival(6.0)


# --- 13. Buffer and repeat ---------------------------------------------------

func _check_buffer_and_repeat() -> void:
	print("")
	print("--- Input buffer and held repeat (specification §12.1)")
	await _reset()
	await _teleport(Vector3(0.0, 0.0, 0.0))
	await _face(Vector3(0.0, 0.0, 1.0))
	Input.action_press(&"attack_in_place")
	_aim_cursor_at(player.global_position + Vector3(0.0, 0.0, 4.0))

	# A press well outside the buffer window is ignored, not stored.
	room.press_quick_strike()
	await _settle(4)
	action.release_input()
	room.press_quick_strike()
	action.release_input()
	print("  pressed %.3f s before the action ends (buffer is %.2f s): buffered=%s" % [
		action.time_until_ready(), data.input_buffer, str(action.buffered),
	])
	_expect(not action.buffered, "a press far outside the buffer window was stored anyway")
	await _await_ready(2.0)

	# A press inside the buffer window starts the next use immediately.
	await _reset()
	await _teleport(Vector3(0.0, 0.0, 0.0))
	await _face(Vector3(0.0, 0.0, 1.0))
	_aim_cursor_at(player.global_position + Vector3(0.0, 0.0, 4.0))
	room.press_quick_strike()
	action.release_input()
	while action.busy() and action.time_until_ready() > data.input_buffer * 0.6:
		await _step()
	var remaining: float = action.time_until_ready()
	var used_before: int = action.buffered_consumed
	room.press_quick_strike()
	action.release_input()
	print("  pressed %.3f s before the action ends: buffered=%s" % [remaining, str(action.buffered)])
	_expect(action.buffered, "a press inside the %.2f s buffer window was dropped" % data.input_buffer)
	await _settle(int(remaining / TICK) + 3)
	print("  the buffered press consumed a use: %d -> %d, phase now %s" % [
		used_before, action.buffered_consumed, action.phase_name(),
	])
	_expect(action.buffered_consumed == used_before + 1, "the buffered press never ran")
	_expect(action.busy(), "the buffered use did not begin as soon as the action was legal again")
	await _await_ready(3.0)

	# Held repeat cadence is the effective action time, at both speeds.
	for speed: float in [0.0, 0.25]:
		await _reset()
		await _teleport(Vector3(0.0, 0.0, 0.0))
		await _face(Vector3(0.0, 0.0, 1.0))
		action.increased_attack_speed = speed
		_aim_cursor_at(player.global_position + Vector3(0.0, 0.0, 4.0))
		_begin_trace()
		room.press_quick_strike()
		await _settle(int(3.5 * data.effective_action_time(speed) / TICK))
		action.release_input()
		var intervals: Array[float] = _release_intervals()
		var wanted: float = data.effective_action_time(speed)
		print("  held repeat at %.0f%% increased speed: %d releases, intervals %s (target %.3f s)" % [
			speed * 100.0, _count("released"), _format_intervals(intervals), wanted,
		])
		_expect(_count("released") >= 3, "a held attack produced only %d releases in three action times" % _count("released"))
		for interval: float in intervals:
			_expect(absf(interval - wanted) <= 3.0 * TICK,
				"a repeat interval of %.3f s does not match the %.3f s action time" % [interval, wanted])
	action.increased_attack_speed = 0.0
	await _await_ready(3.0)
	Input.action_release(&"attack_in_place")
	room.set_cursor_override(null)


# --- 14. Mana ----------------------------------------------------------------

func _check_mana() -> void:
	print("")
	print("--- Mana (specification §12.4)")
	await _reset()
	await _teleport(Vector3(0.0, 0.0, 0.0))
	await _face(Vector3(0.0, 0.0, 1.0))
	Input.action_press(&"attack_in_place")
	_aim_cursor_at(player.global_position + Vector3(0.0, 0.0, 4.0))

	# Regeneration rate, measured.
	player.mana = 40.0
	await _settle(60)
	print("  regeneration over one second: 40.0 -> %.1f" % player.mana)
	_expect(absf(player.mana - 50.0) <= 0.4, "Mana regenerated to %.2f in one second, not 50" % player.mana)

	# One released use costs exactly the listed cost, once. Regeneration is parked
	# for the measurement, because 10 Mana per second would otherwise refund half
	# the cost during the 0.26 s wind-up and hide the actual spend.
	player.mana_regeneration = 0.0
	player.mana = 60.0
	var before: float = player.mana
	var queries: int = action.release_queries
	var spent_marker: float = action.mana_spent_total
	room.press_quick_strike()
	action.release_input()
	await _await_phase(QuickStrikeAction.Phase.RELEASE, 2.0)
	var immediately_after: float = player.mana
	print("  one release with regeneration parked: %.1f -> %.1f  (%d release query, %.1f charged)" % [
		before, immediately_after, action.release_queries - queries, action.mana_spent_total - spent_marker,
	])
	_expect(is_equal_approx(before - immediately_after, data.mana_cost),
		"one release changed Mana by %.2f, not %.0f" % [before - immediately_after, data.mana_cost])
	_expect(is_equal_approx(action.mana_spent_total - spent_marker, data.mana_cost),
		"one release charged %.2f, not %.0f" % [action.mana_spent_total - spent_marker, data.mana_cost])
	await _await_ready(2.0)
	player.mana_regeneration = 10.0

	# Four held repeats cost exactly four times the listed cost.
	player.mana = player.max_mana
	var spent_before: float = action.mana_spent_total
	var released_before: int = action.uses_released
	room.press_quick_strike()
	await _settle(int(4.2 * data.action_time / TICK))
	action.release_input()
	await _await_ready(2.0)
	var releases: int = action.uses_released - released_before
	var spent: float = action.mana_spent_total - spent_before
	print("  %d held repeats spent %.0f Mana (%.0f each)" % [releases, spent, spent / maxf(releases, 1)])
	_expect(absf(spent - releases * data.mana_cost) < 0.001,
		"%d releases spent %.2f Mana rather than %.2f" % [releases, spent, releases * data.mana_cost])

	# Insufficient Mana stops the action from beginning at all.
	player.mana = data.mana_cost - 0.5
	player.mana_regeneration = 0.0
	var refused_before: int = action.rejected_for_mana
	var queries_before: int = action.release_queries
	var uses_before: int = action.uses_started
	room.press_quick_strike()
	action.release_input()
	await _settle(6)
	print("  pressed with %.1f of %.0f Mana: phase %s, refusals %d, uses started %d, queries %d" % [
		player.mana, data.mana_cost, action.phase_name(),
		action.rejected_for_mana - refused_before,
		action.uses_started - uses_before, action.release_queries - queries_before,
	])
	_expect(action.rejected_for_mana == refused_before + 1, "an unaffordable press was not refused")
	_expect(action.phase == QuickStrikeAction.Phase.READY, "an unaffordable press still started an action")
	_expect(action.uses_started == uses_before, "an unaffordable press still allocated a Skill Use")
	_expect(action.release_queries == queries_before, "an unaffordable press still produced a release query")
	_expect(player.mana >= data.mana_cost - 0.5 - 0.001, "an unaffordable press still spent Mana")

	# Specification §12.4 asks for ONE restrained invalid cue. Holding the button
	# with no Mana must not produce one per physics frame.
	var latched_before: int = action.rejected_for_mana
	room.press_quick_strike()
	await _settle(45)
	action.release_input()
	print("  held for 0.75 s with too little Mana: %d refusal(s), not one per frame" % (
		action.rejected_for_mana - latched_before))
	_expect(action.rejected_for_mana - latched_before == 1,
		"a held unaffordable attack produced %d refusals instead of one" % (
			action.rejected_for_mana - latched_before))
	player.mana_regeneration = 10.0
	player.mana = player.max_mana

	# Skill Use IDs are stable and strictly increasing across everything above.
	var ids: Array[int] = []
	for event: Dictionary in _events:
		if event["kind"] == "started":
			ids.append(event["id"])
	var increasing: bool = true
	for i: int in range(1, ids.size()):
		if ids[i] <= ids[i - 1]:
			increasing = false
	print("  Skill Use IDs: %d allocated, strictly increasing = %s" % [ids.size(), str(increasing)])
	_expect(increasing, "Skill Use IDs were reused or went backwards")
	print("  totals: %d started, %d released, %d release queries, %d cancelled pre-release" % [
		action.uses_started, action.uses_released, action.release_queries, action.uses_cancelled_before_release,
	])
	_expect(action.release_queries == action.uses_released,
		"%d release queries for %d released uses" % [action.release_queries, action.uses_released])
	Input.action_release(&"attack_in_place")
	room.set_cursor_override(null)


# --- 15. Scope ---------------------------------------------------------------

## Gate C's own boundary, kept and rerun after Gate D. Two of these moved when
## Gate D was authorised and both moves are deliberate:
##
##   * The PLAYER now has Life, because Gate D owns mechanical death (D-181). The
##     assertion that used to forbid it now guards the NEXT boundary instead —
##     no XP and no progression, which are Gate E.
##   * The practice posts are unchanged and still asserted inert by name. That
##     matters more since Gate D, not less: the Graveblade must not have been
##     built by giving a fixture Life.
func _check_scope() -> void:
	print("")
	print("--- Scope: the Gate C kernel stayed inside its own boundary")
	var fixture: PrototypeTargetFixture = room.fixtures[0]
	for forbidden: String in [
		"life", "max_life", "health", "damage", "take_damage", "die", "death",
		"experience", "xp", "attack_player", "loot", "drop",
	]:
		_expect(not (forbidden in fixture), "the target fixture has a '%s' property; that is Gate D" % forbidden)
	# ONE assertion moved forward by authorization, exactly as Gate D moved the
	# one before it. This said "the player has no XP and no weapon record, which
	# are Gate E". D-184 IS the gate that gives the player a weapon record, so
	# that clause is now false by authorization and was replaced one for one with
	# the next boundary: no inventory. XP is unchanged and still forbidden here,
	# because Gate E deliberately put it on the authoritative LabProgress record
	# rather than on the character. Gate C's suite is still 209 checks.
	_expect(not ("experience" in player) and not ("xp" in player) and not ("inventory" in player),
		"the player has XP or an inventory; XP lives on LabProgress and inventory is not Prototype Zero")
	print("  target fixtures carry no Life, damage, death, XP, or loot property")
	print("  the player carries Life, Mana, and one weapon record; no XP, no inventory")

	# Fixtures must not be able to change a Gate B locomotion result.
	_expect(player.collision_mask & TargetAcquisition.TARGET_MASK == 0,
		"the player collides with target fixtures, which would change Gate B movement")
	_expect(room.nav_region.navigation_mesh.geometry_collision_mask & TargetAcquisition.TARGET_MASK == 0,
		"target fixtures are inside the navigation bake mask")
	print("  fixtures are on the target layer only: no player collision, not in the navigation bake")
	print("  navigation mesh still %d polygons, %.1f m^2" % [room.navmesh_polygon_count, room.navmesh_area])
	_expect(room.navmesh_polygon_count == 2 and absf(room.navmesh_area - 218.7) < 1.0,
		"the navigation mesh changed: %d polygons, %.1f m^2" % [room.navmesh_polygon_count, room.navmesh_area])


# --- Trace -------------------------------------------------------------------

func _on_started(id: int) -> void:
	_events.append({"kind": "started", "id": id, "at": _clock})


func _on_released(id: int, outcome: Dictionary) -> void:
	_events.append({"kind": "released", "id": id, "at": _clock, "outcome": outcome["outcome"]})
	_release_animation_positions.append(player.quick_strike_animation_position())
	var measured: Dictionary = _measure_live_blade()
	_release_blade_angles.append(measured["angle"])
	_release_blade_reach.append(measured["reach"])


func _on_cancelled(id: int, reason: String, before_release: bool) -> void:
	_events.append({"kind": "cancelled", "id": id, "at": _clock, "before_release": before_release, "reason": reason})


func _on_phase(new_phase: QuickStrikeAction.Phase) -> void:
	_events.append({"kind": "phase", "phase": new_phase, "at": _clock})


func _begin_trace() -> void:
	_events.clear()


func _count(kind: String) -> int:
	var total: int = 0
	for event: Dictionary in _events:
		if event["kind"] == kind:
			total += 1
	return total


## Wall-clock time each attack phase actually occupied, from the phase-change
## trace rather than from the values the kernel claims.
func _measured_phase_durations() -> Dictionary:
	var names: Dictionary = {
		QuickStrikeAction.Phase.WINDUP: "ATTACK_WINDUP",
		QuickStrikeAction.Phase.RELEASE: "ATTACK_RELEASE",
		QuickStrikeAction.Phase.RECOVERY: "ATTACK_RECOVERY",
	}
	var durations: Dictionary = {}
	var open_phase: Variant = null
	var opened_at: float = 0.0
	for event: Dictionary in _events:
		if event["kind"] != "phase":
			continue
		if open_phase != null and names.has(open_phase):
			durations[names[open_phase]] = event["at"] - opened_at
		open_phase = event["phase"]
		opened_at = event["at"]
	return durations


func _traced_action_time() -> float:
	var first: float = -1.0
	for event: Dictionary in _events:
		if event["kind"] == "started" and first < 0.0:
			first = event["at"]
		if first >= 0.0 and event["kind"] == "phase" and event["phase"] == QuickStrikeAction.Phase.READY:
			return event["at"] - first
	return -1.0


func _release_intervals() -> Array[float]:
	var times: Array[float] = []
	for event: Dictionary in _events:
		if event["kind"] == "released":
			times.append(event["at"])
	var intervals: Array[float] = []
	for i: int in range(1, times.size()):
		intervals.append(times[i] - times[i - 1])
	return intervals


func _format_intervals(intervals: Array[float]) -> String:
	var parts: PackedStringArray = PackedStringArray()
	for interval: float in intervals:
		parts.append("%.3f" % interval)
	return "[%s]" % ", ".join(parts)


# --- Live pose measurement ---------------------------------------------------

func _rig() -> MediumRigVisual:
	return player.get_node("VisualRoot/KnightRig") as MediumRigVisual


## Where the blade tip actually is at this instant, in the character's own space.
## This is the independent proof that the pose on screen agrees with the query:
## the kernel does not report it, the skeleton does.
##
## The pose is flushed first. `AnimationPlayer.seek(..., true)` writes the bone
## poses but `Skeleton3D` recomputes its global poses lazily, so reading the
## attachment without forcing that flush measures the PREVIOUS frame's pose —
## which, at the ~2,600 deg/s the blade is sweeping here, is tens of degrees out.
func _measure_live_blade() -> Dictionary:
	var skeleton: Skeleton3D = _rig().skeleton()
	skeleton.force_update_all_bone_transforms()
	var socket_index: int = _rig().socket_bone_index()
	var socket_pose: Transform3D = skeleton.global_transform * skeleton.get_bone_global_pose(socket_index)
	var tip: Vector3 = socket_pose * _blade_tip_local
	var flat: Vector3 = Vector3(tip.x - player.global_position.x, 0.0, tip.z - player.global_position.z)
	var facing: Vector3 = player.facing_direction()
	if flat.length() < 0.0001:
		return {"angle": 180.0, "reach": 0.0}
	return {
		"angle": rad_to_deg(facing.signed_angle_to(flat.normalized(), Vector3.UP)),
		"reach": flat.length(),
	}


## Blade extent in socket space, measured from the imported sword rather than
## assumed. Matches what build_quick_strike_animation.gd measured offline.
func _measure_blade_tip() -> Vector3:
	var socket: BoneAttachment3D = _rig().weapon_socket
	var far: Vector3 = Vector3.ZERO
	var stack: Array[Node] = [socket]
	while not stack.is_empty():
		var current: Node = stack.pop_back()
		for child: Node in current.get_children():
			stack.append(child)
		if current is MeshInstance3D:
			var instance: MeshInstance3D = current as MeshInstance3D
			var box: AABB = instance.mesh.get_aabb()
			var to_socket: Transform3D = socket.global_transform.affine_inverse() * instance.global_transform
			for corner: int in 8:
				var point: Vector3 = to_socket * box.get_endpoint(corner)
				if point.length() > far.length():
					far = point
	return far


# --- Driving -----------------------------------------------------------------

func _post(fixture_name: String) -> PrototypeTargetFixture:
	for fixture: PrototypeTargetFixture in room.fixtures:
		if fixture.fixture_name == fixture_name:
			return fixture
	return null


func _aim_cursor_at(world_point: Vector3) -> void:
	room.set_cursor_override(room.camera_rig.camera.unproject_position(world_point))


## Clears the retained soft target, so a check measures a fresh decision rather
## than the permitted brief retention of the previous one.
func _set_soft_target_directly(next: PrototypeTargetFixture) -> void:
	if room.soft_target != null:
		room.soft_target.set_soft_targeted(false)
	room.soft_target = next
	room.soft_target_since_msec = 0


## A real engine-dispatched mouse button, so the room's own `_unhandled_input`
## path is exercised rather than a private flag being poked.
func _press_mouse(pressed: bool) -> void:
	var event: InputEventMouseButton = InputEventMouseButton.new()
	event.button_index = MOUSE_BUTTON_LEFT
	event.pressed = pressed
	Input.parse_input_event(event)


## Sets an aim direction and keeps the character where the geometry expects it.
## A live stick override genuinely drives movement, which is correct behaviour and
## exactly what makes an unpinned soft-targeting check depend on frame timing.
func _aim_pinned(direction: Vector3) -> void:
	_aim_stick_world(direction)
	await _step()
	_pin()


func _pin() -> void:
	player.global_position = _pin_point
	player.velocity = Vector3.ZERO


func _aim_stick_world(direction: Vector3) -> void:
	var forward: Vector3 = room.camera_rig.ground_forward()
	var right: Vector3 = room.camera_rig.ground_right()
	room.set_stick_override(Vector2(direction.dot(right), -direction.dot(forward)).normalized())


## A quiet corner of the room with no practice post within several metres, so a
## directional swing really is directional.
const EMPTY_GROUND: Vector3 = Vector3(5.0, 0.0, -4.5)


## Right-click empty ground straight ahead: a directional swing with no target.
func _swing_at_empty_ground() -> void:
	_aim_cursor_at(player.global_position + player.facing_direction() * 2.5)
	room.press_quick_strike()
	action.release_input()


func _reset() -> void:
	action.release_input()
	action.clear("verification reset")
	player.clear_movement_intent("verification reset", false)
	room.set_stick_override(null)
	room.set_cursor_override(null)
	player.mana = player.max_mana
	_releases_before_invalid = action.release_queries
	await _settle(4)


func _teleport(to: Vector3) -> void:
	player.clear_movement_intent("verification teleport", false)
	player.global_position = Vector3(to.x, 0.0, to.z)
	player.velocity = Vector3.ZERO
	# The camera cuts rather than eases beyond its snap distance, but it needs a
	# frame to do it, and `unproject_position` is only meaningful once it has.
	await _settle(6)


func _face(direction: Vector3) -> void:
	player.face_instantly(direction)
	await _step()


func _step() -> void:
	# Stamped before the await, so a signal emitted DURING the frame we are about
	# to resume from carries that frame's time rather than the previous one.
	_clock += TICK
	await get_tree().physics_frame


func _settle(frames: int) -> void:
	for i: int in frames:
		await _step()


func _await_ready(timeout: float) -> float:
	var elapsed: float = 0.0
	while elapsed < timeout:
		await _step()
		elapsed += TICK
		if not action.busy():
			return elapsed
	return timeout


func _await_phase(wanted: QuickStrikeAction.Phase, timeout: float) -> float:
	var elapsed: float = 0.0
	while elapsed < timeout:
		await _step()
		elapsed += TICK
		if action.phase == wanted:
			return elapsed
	return timeout


func _await_arrival(timeout: float) -> void:
	var elapsed: float = 0.0
	while elapsed < timeout:
		await _step()
		elapsed += TICK
		if not player.has_destination and player.planar_speed() < 0.15:
			return


func _planar_distance(a: Vector3, b: Vector3) -> float:
	return Vector2(b.x - a.x, b.z - a.z).length()


func _planar(vector: Vector3) -> Vector3:
	return Vector3(vector.x, 0.0, vector.z)


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
	await _reset()
	room.input_family.family = InputFamilyTracker.Family.MOUSE_KEYBOARD
	room.set_debug_visuals(false)
	room.set_debug_panels(false)
	for fixture: PrototypeTargetFixture in room.fixtures:
		fixture.reset()
	# The screenshots are the record of what the room looks like, so they must
	# show the layout the scene authored rather than wherever an earlier check
	# happened to leave a post.
	for entry: Dictionary in PrototypeZeroRoom.FIXTURE_LAYOUT:
		var authored: PrototypeTargetFixture = _post(String(entry["name"]))
		_expect(authored != null and authored.position.is_equal_approx(entry["at"]),
			"%s is at %s, not the authored %s; the evidence would show a drifted layout" % [
				entry["name"], str(authored.position) if authored != null else "missing", str(entry["at"]),
			])
	var post: PrototypeTargetFixture = _post("Practice Post A")

	# 1. The room with the inert practice posts, before anything happens.
	await _teleport(Vector3(-1.5, 0.0, -1.0))
	await _face(Vector3(1.0, 0.0, 0.4))
	await _shoot("gate_c_practice_posts", 6)

	# 2. Mid-approach toward a post that was right-clicked from range.
	await _reset()
	await _teleport(Vector3(-2.6, 0.0, 0.2))
	_aim_cursor_at(post.targeting_point())
	room.press_quick_strike()
	action.release_input()
	await _settle(20)
	await _shoot("gate_c_approach", 2)
	await _await_ready(4.0)

	# 3. The exact release frame. The navigation overlay stays off so the reach
	#    circle and the 100 degree release arc read against the real floor.
	await _reset()
	post.reset()
	room.combat_visuals.visible = true
	room.set_navigation_visuals(false)
	await _teleport(post.global_position - Vector3(1.25, 0.0, 0.0))
	await _face(Vector3(1.0, 0.0, 0.0))
	Input.action_press(&"attack_in_place")
	_aim_cursor_at(post.targeting_point())
	room.press_quick_strike()
	await _await_phase(QuickStrikeAction.Phase.RELEASE, 2.0)
	await _shoot("gate_c_release_marker", 1)
	action.release_input()
	Input.action_release(&"attack_in_place")
	await _await_ready(3.0)

	# 4. The controller soft-target cone at its D-178 width, aimed unambiguously
	#    at one of two candidate posts, with the quiet ring under the one that was
	#    chosen. The character is faced along the aim first, because the drawn
	#    cone is centred on facing — which is the intended direction whenever the
	#    stick is neutral or has been held for more than a frame — so the picture
	#    and the decision describe the same geometry.
	await _reset()
	room.input_family.family = InputFamilyTracker.Family.CONTROLLER
	await _teleport(Vector3(-0.4, 0.0, 0.6))
	var aimed: PrototypeTargetFixture = _post("Practice Post B")
	var other: PrototypeTargetFixture = _post("Practice Post A")
	var to_aimed: Vector3 = _planar(aimed.global_position - player.global_position).normalized()
	await _face(to_aimed)
	_set_soft_target_directly(null)
	_aim_stick_world(to_aimed)
	await _step()
	var chosen: Dictionary = room.resolve_quick_strike_aim()
	room.set_stick_override(null)
	await _settle(2)
	var excluded_angle: float = rad_to_deg(to_aimed.angle_to(
		_planar(other.global_position - player.global_position).normalized()))
	_expect(chosen["target"] == aimed,
		"the soft-target evidence shot aimed at %s and selected %s" % [
			aimed.fixture_name,
			(chosen["target"] as PrototypeTargetFixture).fixture_name if chosen["target"] != null else "nothing",
		])
	_expect(excluded_angle > data.soft_target_cone_half_degrees(),
		"the evidence shot's rival post is %.1f deg off, inside the %.1f deg half-cone, so the picture is ambiguous" % [
			excluded_angle, data.soft_target_cone_half_degrees(),
		])
	print("  soft-target evidence: aimed at %s, chose %s (%s)" % [
		aimed.fixture_name,
		(chosen["target"] as PrototypeTargetFixture).fixture_name if chosen["target"] != null else "nothing",
		chosen["reason"],
	])
	print("  the rival post sits %.1f deg off the aim, outside the %.1f deg half-cone" % [
		excluded_angle, data.soft_target_cone_half_degrees(),
	])
	await _shoot("gate_c_soft_target_cone", 2)
	room.input_family.family = InputFamilyTracker.Family.MOUSE_KEYBOARD

	# 5. The instrumentation itself, open, part-way through a wind-up.
	await _reset()
	room.set_debug_panels(true)
	room.combat_visuals.visible = true
	room.set_navigation_visuals(false)
	post.reset()
	await _teleport(post.global_position - Vector3(1.25, 0.0, 0.0))
	await _face(Vector3(1.0, 0.0, 0.0))
	Input.action_press(&"attack_in_place")
	_aim_cursor_at(post.targeting_point())
	room.press_quick_strike()
	await _settle(9)
	await _shoot("gate_c_debug_overlay", 2)
	action.release_input()
	Input.action_release(&"attack_in_place")
	await _await_ready(3.0)
	room.set_debug_panels(false)
	room.set_debug_visuals(false)
	room.set_cursor_override(null)


func _shoot(name_stem: String, settle_frames: int) -> void:
	for i: int in settle_frames:
		await RenderingServer.frame_post_draw
	await RenderingServer.frame_post_draw
	var path: String = "%s/%s.png" % [_shot_dir, name_stem]
	# Checked, not assumed: a relative --shots path silently wrote nothing, so a
	# run could report "evidence regenerated" while leaving stale images in place.
	var error: Error = get_viewport().get_texture().get_image().save_png(path)
	_expect(error == OK, "could not write %s (error %d); use an absolute --shots path" % [path, error])
	print("  screenshot: %s%s" % [path, "" if error == OK else "  FAILED"])
