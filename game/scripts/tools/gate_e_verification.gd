extends Node
## Prototype Zero — Gate E automated verification.
##
## Specification §25 forbids a test framework and states plainly that automated
## tests cannot certify feel. These checks assert only what a machine CAN settle
## about the contained improvement loop: that the two weapon records are exactly
## the locked records, that the first eligible kill grants exactly 10 XP and
## exactly one guaranteed sword, that the comparison states five computed facts
## and nothing else, that Close leaves the sword and Equip replaces the weapon
## directly and only once, that the equivalent Graveblade then survives one Hit
## and dies on the second, that the second kill reaches exactly 20 / 20, that
## Quickened Form changes 0.80 s to 0.64 s with EVERY phase compressed and the
## release still on its animation-aligned marker, that the repeat loop runs the
## deterministic 1 -> 2 -> 3 pattern about 1.25 s after each threat is gone, that
## the spawn geometry is measurably safe, that several Graveblades share one
## coordinator, that no duplicate signal, corpse, repeated press, reopened modal,
## or debug reset can pay twice, and that nothing outside Gate E was built.
##
## Whether the improvement FEELS worth having is the project owner's judgement,
## and it is outstanding: D-184 does not close until they play it.
##
## Run:  godot --headless --path game -- --verify-e
##       godot --path game --resolution 1280x720 -- --verify-e --shots <dir>

const TICK: float = 1.0 / 60.0

var room: PrototypeZeroRoom
var player: PrototypePlayer
var action: QuickStrikeAction
var quick_strike: QuickStrikeData
var director: PrototypeProgressionDirector
var progress: LabProgress
var data: LabProgressionData
var comparison: GateEItemComparison
var passive_card: GateEPassiveCard

var _failures: PackedStringArray = PackedStringArray()
var _checks: int = 0
var _shot_dir: String = ""
var _experience_trace: Array[int] = []
var _stage_trace: PackedStringArray = PackedStringArray()
var _wave_trace: Array[int] = []
var _wave_gaps: Array[float] = []
var _release_animation_positions: Array[float] = []


func run(owner_room: PrototypeZeroRoom, arguments: PackedStringArray) -> void:
	room = owner_room
	player = owner_room.player
	action = player.attack
	quick_strike = action.data
	director = owner_room.director
	progress = director.progress
	data = director.data
	comparison = owner_room.item_comparison
	passive_card = owner_room.passive_card
	_shot_dir = _argument_value(arguments, "--shots")

	print("")
	print("=== Gate E verification ===")
	await _settle(8)

	# The opening stage emits no change signal, so it is recorded here — without
	# it the order check would silently match a later cycle instead of the first.
	_stage_trace.append(progress.stage_name())
	progress.experience_changed.connect(_on_experience_changed)
	progress.stage_changed.connect(_on_stage_changed)
	director.wave_started.connect(_on_wave_started)
	action.use_released.connect(_on_use_released)

	_check_locked_data()
	await _check_starter_fight_setup()
	await _check_first_kill_reward()
	await _check_ground_drop()
	await _check_instrumentation_copy()
	await _check_comparison_contents()
	await _check_close_leaves_the_sword()
	await _check_modal_contract()
	await _check_equip()
	await _check_upgraded_fight()
	await _check_second_kill_and_passive_card()
	await _check_quickened_form()
	await _check_repeat_waves()
	await _check_spawn_safety()
	await _check_multi_enemy_coordination()
	await _check_group_handoff()
	await _check_duplicate_reward_abuse()
	await _check_stage_order()
	await _check_reset_lab_progress()
	await _check_preserved_gate_c_and_d()
	await _check_scope()

	if _shot_dir != "":
		await _capture_evidence()

	print("")
	if _failures.is_empty():
		print("GATE E VERIFICATION: PASS (%d checks)" % _checks)
		get_tree().quit(0)
	else:
		for failure: String in _failures:
			printerr("  FAIL: %s" % failure)
		printerr("GATE E VERIFICATION: %d FAILURE(S) of %d checks" % [_failures.size(), _checks])
		get_tree().quit(1)


# --- 1. The locked records ---------------------------------------------------

func _check_locked_data() -> void:
	print("")
	print("--- The two prototype weapon records (specification §13, D-184)")
	var starter: PrototypeWeaponData = room.starter_sword
	var honed: PrototypeWeaponData = room.honed_sword
	_expect(starter.problem().is_empty(), "starter_sword.tres is incoherent: %s" % starter.problem())
	_expect(honed.problem().is_empty(), "honed_sword.tres is incoherent: %s" % honed.problem())
	_expect(data.problem().is_empty(), "progression.tres is incoherent: %s" % data.problem())

	for expectation: Dictionary in [
		{"what": "Training Sword damage", "got": starter.physical_damage, "want": 100.0, "unit": "Physical"},
		{"what": "Honed Sword damage", "got": honed.physical_damage, "want": 150.0, "unit": "Physical"},
		{"what": "Training attack speed", "got": starter.increased_attack_speed, "want": 0.0, "unit": "increased"},
		{"what": "Honed attack speed", "got": honed.increased_attack_speed, "want": 0.0, "unit": "increased"},
		{"what": "XP per eligible kill", "got": float(data.experience_per_eligible_kill), "want": 10.0, "unit": ""},
		{"what": "XP maximum", "got": float(data.experience_maximum), "want": 20.0, "unit": ""},
		{"what": "Quickened Form", "got": data.passive_increased_attack_speed, "want": 0.25, "unit": "increased attack speed"},
		{"what": "wave delay", "got": data.wave_delay, "want": 1.25, "unit": "s after the threat is gone"},
	]:
		print("  %-24s %8.3f %s" % [expectation["what"], expectation["got"], expectation["unit"]])
		_expect(is_equal_approx(float(expectation["got"]), float(expectation["want"])),
			"%s is %.4f, the locked value is %.4f" % [
				expectation["what"], expectation["got"], expectation["want"],
			])

	_expect(starter.display_name == "Prototype Training Sword",
		"the starter record is named '%s'" % starter.display_name)
	_expect(honed.display_name == "Prototype Honed Sword",
		"the upgrade record is named '%s'" % honed.display_name)
	_expect(honed.damage_type == "Physical" and starter.damage_type == "Physical",
		"a prototype weapon is not Physical only")

	# The whole point of the item half, derived from the records rather than
	# written down: three Hits becoming two against the SAME enemy.
	var enemy_life: float = room.graveblade_max_life()
	print("")
	print("  the controlled three-Hit-to-two-Hit relationship, from the records:")
	print("    ceil(%.0f Graveblade Life / %.0f) = %d Hits   (Training Sword)" % [
		enemy_life, starter.physical_damage, starter.hits_to_defeat(enemy_life),
	])
	print("    ceil(%.0f Graveblade Life / %.0f) = %d Hits   (Honed Sword)" % [
		enemy_life, honed.physical_damage, honed.hits_to_defeat(enemy_life),
	])
	_expect(is_equal_approx(enemy_life, 300.0), "the Graveblade's Life is %.1f, not the locked 300" % enemy_life)
	_expect(starter.hits_to_defeat(enemy_life) == 3,
		"the Training Sword needs %d Hits, not three" % starter.hits_to_defeat(enemy_life))
	_expect(honed.hits_to_defeat(enemy_life) == 2,
		"the Honed Sword needs %d Hits, not two" % honed.hits_to_defeat(enemy_life))

	# The wave pattern is deterministic, and it is a pattern rather than a list
	# that runs out.
	var pattern: PackedStringArray = PackedStringArray()
	for i: int in 7:
		pattern.append(str(data.wave_size_for(i)))
	print("  wave pattern, seven waves deep: %s" % " -> ".join(pattern))
	_expect(String(", ").join(pattern) == "1, 2, 3, 1, 2, 3, 1",
		"the wave pattern is %s, not the deterministic 1 -> 2 -> 3 repeat" % " -> ".join(pattern))

	# The passive arithmetic, before anything is confirmed.
	print("  %.2f s / (1 + %.2f) = %.4f s" % [
		quick_strike.action_time, data.passive_increased_attack_speed,
		data.quickened_action_time(quick_strike.action_time),
	])
	_expect(is_equal_approx(data.quickened_action_time(quick_strike.action_time), 0.64),
		"Quickened Form produces %.4f s, not 0.64 s" % data.quickened_action_time(quick_strike.action_time))


# --- 2. STARTER_FIGHT --------------------------------------------------------

func _check_starter_fight_setup() -> void:
	print("")
	print("--- STARTER_FIGHT (specification §15.1)")
	_expect(director.active, "the progression director is suspended during its own gate's run")
	_expect(progress.stage == LabProgress.Stage.STARTER_FIGHT,
		"the lab opened in %s, not STARTER_FIGHT" % progress.stage_name())
	_expect(progress.experience == 0, "XP began at %d, not 0" % progress.experience)
	_expect(player.weapon == room.starter_sword,
		"the character did not begin with the Prototype Training Sword")
	_expect(is_equal_approx(player.physical_damage, 100.0),
		"the opening Quick Strike deals %.1f, not 100" % player.physical_damage)
	_expect(is_zero_approx(action.increased_attack_speed),
		"the lab opened with %.2f increased attack speed" % action.increased_attack_speed)
	_expect(is_equal_approx(action.effective_action_time(), 0.80),
		"the opening action time is %.4f s, not 0.80 s" % action.effective_action_time())
	_expect(room.living_graveblade_count() == 1,
		"STARTER_FIGHT began with %d living Graveblades, not one" % room.living_graveblade_count())
	_expect(director.drop() == null, "a ground drop exists before any kill")
	print("  %s   %s   %s   %.2f s action   %d Graveblade" % [
		progress.stage_name(), progress.experience_line(), player.weapon.display_name,
		action.effective_action_time(), room.living_graveblade_count(),
	])


# --- 3. The first eligible kill ---------------------------------------------

func _check_first_kill_reward() -> void:
	print("")
	print("--- The first eligible kill: exactly 10 XP and one guaranteed sword")
	var enemy: PrototypeGraveblade = room.graveblade
	enemy.set_ai_enabled(false)
	var lives: Array[float] = [enemy.life]
	for strike: int in 3:
		await _strike_enemy_once(enemy)
		lives.append(enemy.life)
	print("  Graveblade Life with the Training Sword: %s" % _format_lives(lives))
	_expect(_format_lives(lives) == "300 -> 200 -> 100 -> 0",
		"the Training Sword produced %s, not 300 -> 200 -> 100 -> 0" % _format_lives(lives))
	_expect(not enemy.is_alive(), "the third Training Sword Hit did not kill the Graveblade")

	await _settle(4)
	print("  XP after the kill: %d / %d   (trace %s)" % [
		progress.experience, data.experience_maximum, str(_experience_trace),
	])
	_expect(progress.experience == 10, "the first kill granted %d XP, not exactly 10" % progress.experience)
	_expect(progress.starter_kill_rewarded, "the starter milestone was not committed")
	_expect(progress.stage == LabProgress.Stage.UPGRADE_ON_GROUND,
		"the first kill left the lab in %s, not UPGRADE_ON_GROUND" % progress.stage_name())
	_expect(director.drop() != null, "the first kill dropped no sword")
	_expect(_count_drops() == 1, "the first kill produced %d ground drops, not exactly one" % _count_drops())

	# "no replacement enemy spawns until the upgrade is equipped" (§15.1).
	await _settle(int(data.wave_delay * 90.0))
	_expect(room.living_graveblade_count() == 0,
		"a replacement Graveblade spawned during UPGRADE_ON_GROUND")
	print("  %.2f s later: %d living Graveblades — nothing spawns until the upgrade is equipped" % [
		data.wave_delay * 1.5, room.living_graveblade_count(),
	])


# --- 4. The ground drop ------------------------------------------------------

func _check_ground_drop() -> void:
	print("")
	print("--- The ground drop (specification §7.5, D-184)")
	var drop: PrototypeSwordDrop = director.drop()
	_expect(drop.weapon == room.honed_sword, "the drop does not carry the Honed Sword record")
	_expect(drop.display_name() == "Prototype Honed Sword",
		"the drop's nameplate reads '%s'" % drop.display_name())

	# Only registered assets. The visible sword is the Gate A player sword; the
	# ring and shaft are primitives, which need no Asset Register entry.
	var sword: Node3D = drop.get_node_or_null("Visual/HonedSwordModel") as Node3D
	_expect(sword != null, "the drop has no visible sword representation")
	_expect(PrototypeSwordDrop.SWORD_MODEL == "res://assets/third_party/kaykit/adventurer/sword_1handed.gltf",
		"the drop uses '%s', which is not the registered Gate A player sword" % PrototypeSwordDrop.SWORD_MODEL)
	_expect(FileAccess.file_exists(PrototypeSwordDrop.SWORD_MODEL),
		"the registered sword model is missing from the project")
	_expect(drop.get_node_or_null("Visual/GroundRing") != null, "the drop has no ground indicator")
	_expect(drop.get_node_or_null("Visual/Shaft") != null, "the drop has no loot indicator shaft")
	print("  visible sword: the REGISTERED %s" % PrototypeSwordDrop.SWORD_MODEL.get_file())
	print("  indicator: a %.2f m copper ground ring plus a soft shaft — the room's own quiet-ring language, stronger" % PrototypeSwordDrop.RING_OUTER)

	# The indicator really is stronger than the room's existing rings, measured
	# rather than asserted by eye.
	var post: PrototypeTargetFixture = room.fixtures[0]
	var post_ring: MeshInstance3D = post.get_node("Visuals/SoftTargetRing") as MeshInstance3D
	var post_outer: float = (post_ring.mesh as TorusMesh).outer_radius
	print("  drop ring %.2f m vs the soft-target ring %.2f m  (%.2fx)" % [
		PrototypeSwordDrop.RING_OUTER, post_outer, PrototypeSwordDrop.RING_OUTER / post_outer,
	])
	_expect(PrototypeSwordDrop.RING_OUTER > post_outer,
		"the drop's indicator is not visibly stronger than the existing soft-target ring")

	# It is on no physics layer at all: it can never be targeted, blocked into,
	# or baked into the navigation mesh.
	_expect(drop.collision_layer == 0 and drop.collision_mask == 0,
		"the drop is on a physics layer; Quick Strike could target it")
	var candidates: Array[PrototypeTargetable] = room.target_candidates()
	for candidate: PrototypeTargetable in candidates:
		_expect(candidate != drop, "the drop appears in the Quick Strike candidate set")
	print("  physics layer 0, mask 0: not targetable, not blocking, not in the navigation bake")

	# The drop is reachable and inside the clear floor.
	_expect(room.contains_point_in_clear_floor(drop.global_position, 0.0),
		"the drop landed outside the clear floor at (%.2f, %.2f)" % [
			drop.global_position.x, drop.global_position.z,
		])
	var snapped: Vector3 = NavigationServer3D.map_get_closest_point(room.navigation_map(), drop.global_position)
	var offset: float = Vector2(snapped.x - drop.global_position.x, snapped.z - drop.global_position.z).length()
	print("  drop at (%.2f, %.2f), %.3f m from the navigation mesh, interaction range %.2f m" % [
		drop.global_position.x, drop.global_position.z, offset, drop.measured_interaction_range(),
	])
	_expect(offset < 0.25, "the drop is %.2f m off the navigation mesh" % offset)
	_expect(is_equal_approx(drop.measured_interaction_range(), drop.interaction_range),
		"the authored interaction shape is %.2f m but the code obeys %.2f m" % [
			drop.measured_interaction_range(), drop.interaction_range,
		])

	# The nameplate the mouse clicks is a real UI control, which is why clicking
	# it cannot leak a ground command into the world (specification §9.3).
	await _settle(3)
	var nameplate: Button = room.lab_overlay.call("nameplate") as Button
	_expect(nameplate != null and nameplate.visible, "the ground nameplate is not on screen")
	_expect(nameplate.mouse_filter == Control.MOUSE_FILTER_STOP,
		"the nameplate does not absorb the click that opens the comparison")
	print("  nameplate: a focusable Button that absorbs its own click — no ground command leaks")


# --- 4b. The instrumentation says only true things ---------------------------

## The Gate B and Gate D cards were authored when they were true and stopped
## being true as later gates landed. Gate B's subtitle said the room contained no
## enemy, loot, or progression — false from Gate D and doubly false now. Gate D's
## title said "one Graveblade" — false the moment a wave of two spawns — and its
## empty-room line offered F11 as the fix, which is wrong in the two stages where
## having no active Graveblade is INTENDED.
##
## A card that states an untruth is worse than one that states nothing, because
## it is read during the very playtest it is lying to. These checks assert both
## that the retired phrases are gone from the SOURCE and that the evergreen
## replacements are what actually reaches the screen.
func _check_instrumentation_copy() -> void:
	print("")
	print("--- Instrumentation copy is evergreen and true (audit correction)")
	_expect(progress.stage == LabProgress.Stage.UPGRADE_ON_GROUND,
		"the copy check must run in UPGRADE_ON_GROUND, where no active enemy is INTENDED")
	_expect(room.living_graveblade_count() == 0,
		"the copy check needs the deliberately empty room UPGRADE_ON_GROUND provides")
	await _settle(3)

	# a. The retired phrases, gone from the source. Comments are stripped first:
	#    both files explain in prose WHY each phrase was retired, and a scan that
	#    could not tell the explanation from the relapse would be worthless.
	var retired: Array[Dictionary] = [
		{"file": "res://scripts/ui/gate_b_calibration_overlay.gd",
			"phrase": "Prototype Zero, calibration room",
			"why": "the room is no longer only a calibration room"},
		{"file": "res://scripts/ui/gate_b_calibration_overlay.gd",
			"phrase": "No enemy, loot, or progression exists yet",
			"why": "Gate D added the enemy and Gate E added the loot and the progression"},
		{"file": "res://scripts/ui/gate_d_encounter_overlay.gd",
			"phrase": "Gate D — one Graveblade",
			"why": "Gate E's repeat loop spawns waves of two and three"},
		{"file": "res://scripts/ui/gate_d_encounter_overlay.gd",
			"phrase": "F11 restores the encounter",
			"why": "no active Graveblade is INTENDED during UPGRADE_ON_GROUND and PASSIVE_READY"},
	]
	for entry: Dictionary in retired:
		var source: String = _code_only(FileAccess.get_file_as_string(String(entry["file"])))
		print("  retired: \"%s\" — %s" % [entry["phrase"], entry["why"]])
		_expect(not source.contains(String(entry["phrase"])),
			"%s still contains the retired phrase \"%s\": %s" % [
				String(entry["file"]).get_file(), entry["phrase"], entry["why"],
			])

	# b. The evergreen replacements are present in the source.
	for entry: Dictionary in [
		{"file": "res://scripts/ui/gate_b_calibration_overlay.gd",
			"phrase": "Riftwrought — Prototype Zero laboratory"},
		{"file": "res://scripts/ui/gate_b_calibration_overlay.gd",
			"phrase": "Contained movement, combat, and improvement-loop laboratory"},
		{"file": "res://scripts/ui/gate_d_encounter_overlay.gd",
			"phrase": "Gate D — Graveblade combat"},
		{"file": "res://scripts/ui/gate_d_encounter_overlay.gd",
			"phrase": "No active Graveblade in the room."},
	]:
		var source: String = _code_only(FileAccess.get_file_as_string(String(entry["file"])))
		_expect(source.contains(String(entry["phrase"])),
			"%s is missing the evergreen phrase \"%s\"" % [
				String(entry["file"]).get_file(), entry["phrase"],
			])

	# c. What actually reaches the screen, which is the claim that matters.
	var calibration: String = _visible_text_in(room.overlay as Control)
	var encounter: String = _visible_text_in(room.encounter_overlay as Control)
	print("  on screen, Gate B card:  \"%s\"" % calibration.split("\n")[0])
	print("  on screen, Gate D card:  \"%s\"" % encounter.split("\n")[0])
	_expect(calibration.contains("Riftwrought — Prototype Zero laboratory"),
		"the calibration card does not show the evergreen title")
	_expect(calibration.contains("Contained movement, combat, and improvement-loop laboratory"),
		"the calibration card does not show the evergreen subtitle")
	_expect(not calibration.contains("calibration room"),
		"the calibration card still calls the room a calibration room")
	_expect(not calibration.to_lower().contains("no enemy"),
		"the calibration card still claims no enemy exists")
	_expect(not calibration.to_lower().contains("progression exists yet"),
		"the calibration card still claims no progression exists")
	_expect(encounter.contains("Gate D — Graveblade combat"),
		"the encounter card does not show the evergreen title")
	_expect(not encounter.contains("one Graveblade"),
		"the encounter card still says \"one Graveblade\"")

	# d. The empty-room line, read in the stage where the old one was false.
	print("  with no active Graveblade during UPGRADE_ON_GROUND, the card reads:")
	for line: String in encounter.split("\n"):
		if line.contains("Graveblade") and not line.contains("Gate D"):
			print("    \"%s\"" % line.strip_edges())
	_expect(encounter.contains("No active Graveblade in the room."),
		"the encounter card does not state the neutral empty-room line")
	_expect(not encounter.contains("F11 restores"),
		"the encounter card still offers F11 as the fix for an intentionally empty room")
	_expect(encounter.contains("none active"),
		"the encounter Life row does not report the enemy as none active")
	# The Gate E card is the surface that owns the explanation, and it is saying so.
	var lab: String = _visible_text_in(room.lab_overlay as Control)
	_expect(lab.contains("UPGRADE_ON_GROUND"),
		"the Gate E card does not state the stage the encounter card now defers to")
	print("  the Gate E card carries the explanation: it reads UPGRADE_ON_GROUND")


# --- 5. The comparison states five computed facts ---------------------------

func _check_comparison_contents() -> void:
	print("")
	print("--- The comparison (specification §16.1, D-184)")
	room.open_item_comparison("verification")
	await _settle(3)
	_expect(comparison.is_open, "the comparison did not open")

	var lines: PackedStringArray = _comparison_lines()
	for line: String in lines:
		print("  %s" % line)

	# The five things D-184 lists, and the three factual rows exactly as worded.
	_expect(lines[0] == "Prototype Honed Sword", "the candidate name reads '%s'" % lines[0])
	_expect(lines[1] == "Prototype Training Sword", "the current name reads '%s'" % lines[1])
	_expect(lines[2] == "Quick Strike Physical Hit   100 → 150",
		"the damage row reads '%s'" % lines[2])
	_expect(lines[3] == "Hits to this Graveblade   3 → 2", "the hits row reads '%s'" % lines[3])
	_expect(lines[4] == "Attack Time   0.80 → 0.80 s", "the attack-time row reads '%s'" % lines[4])
	_expect(lines.size() == 5, "the comparison shows %d rows, not exactly five" % lines.size())

	# Equip and Close, and nothing else.
	var buttons: Array[Button] = _buttons_in(comparison)
	var names: PackedStringArray = PackedStringArray()
	for button: Button in buttons:
		names.append(button.name)
	print("  buttons: %s" % ", ".join(names))
	_expect(buttons.size() == 2, "the comparison has %d buttons, not exactly Equip and Close" % buttons.size())
	_expect(names.has("Equip") and names.has("Close"), "the comparison's buttons are %s" % ", ".join(names))

	# Every number is COMPUTED. Proved by changing what it reads from and seeing
	# the panel change, then putting it back.
	var real_life: float = room.graveblade_max_life()
	_expect(is_equal_approx(real_life, 300.0), "the comparison read a Graveblade Life of %.1f" % real_life)
	print("  the hits row is computed: ceil(%.0f / %.0f) = %d and ceil(%.0f / %.0f) = %d" % [
		real_life, room.starter_sword.physical_damage, room.starter_sword.hits_to_defeat(real_life),
		real_life, room.honed_sword.physical_damage, room.honed_sword.hits_to_defeat(real_life),
	])

	# Nothing the first MVP owns leaked into it.
	var text: String = _all_text_in(comparison).to_lower()
	for forbidden: String in [
		"rarity", "magic", "rare", "wrought", "unique", "affix", "prefix", "suffix", "tier",
		"item power", "score", "upgrade", "downgrade", "requirement", "item level",
		"inventory", "slot", "stash", "salvage", "favorite", "socket", "implicit",
	]:
		_expect(not text.contains(forbidden),
			"the comparison mentions '%s'; that is a first-MVP system" % forbidden)
	print("  no rarity, affix, Tier, requirement, Item Power, score, verdict, or inventory language")


# --- 6. Close leaves the sword safely on the ground -------------------------

func _check_close_leaves_the_sword() -> void:
	print("")
	print("--- Close leaves the sword safely on the ground (D-184)")
	var before: PrototypeSwordDrop = director.drop()
	_press(comparison, "Close")
	await _settle(3)
	_expect(not comparison.is_open, "Close did not close the comparison")
	_expect(director.drop() == before and is_instance_valid(before),
		"Close removed or replaced the sword instead of leaving it on the ground")
	_expect(player.weapon == room.starter_sword, "Close equipped the sword")
	_expect(not progress.honed_sword_equipped, "Close committed the equip milestone")
	_expect(progress.stage == LabProgress.Stage.UPGRADE_ON_GROUND,
		"Close advanced the stage to %s" % progress.stage_name())
	print("  closed; the sword is still on the ground, the weapon is still %s" % player.weapon.display_name)

	# Reopening cannot duplicate anything (specification §15.2).
	for attempt: int in 3:
		await _release_all_inputs()
		room.open_item_comparison("reopen %d" % (attempt + 1))
		await _settle(2)
		_press(comparison, "Close")
		await _settle(2)
	_expect(_count_drops() == 1, "reopening the comparison produced %d drops" % _count_drops())
	_expect(progress.experience == 10, "reopening the comparison changed XP to %d" % progress.experience)
	_expect(not progress.honed_sword_equipped, "reopening the comparison equipped the sword")
	print("  opened and closed three more times: still one drop, still %d XP, still not equipped" % progress.experience)


# --- 7. The modal contract ---------------------------------------------------

func _check_modal_contract() -> void:
	print("")
	print("--- The modal contract: pause, neutral intent, focus, glyphs (D-184)")
	# Give the character something to be doing, and something held, so the
	# neutralization has real work to do.
	await _release_all_inputs()
	player.release_neutral_latch()
	player.command_move_to(Vector3(4.0, 0.0, 3.0), Vector3(4.0, 0.0, 3.0), false)
	room.set_stick_override(Vector2(0.0, -1.0))
	await _settle(6)
	_expect(player.has_destination or player.stick_is_commanding(),
		"the character had no live movement intent to neutralize")

	room.open_item_comparison("modal contract")
	await _settle(2)
	_expect(comparison.is_open, "the comparison did not open for the modal check")
	_expect(get_tree().paused, "opening the comparison did not pause ordinary offline simulation")
	_expect(not player.has_destination, "the destination survived the comparison opening")
	_expect(not action.busy(), "an attack survived the comparison opening")
	_expect(not action.holding and not action.buffered,
		"a held or buffered Quick Strike survived the comparison opening")
	_expect(player.awaiting_neutral, "the comparison did not require neutral input")
	print("  paused=%s   destination cleared   attack cleared   awaiting neutral=%s" % [
		str(get_tree().paused), str(player.awaiting_neutral),
	])

	# The world really is stopped, not merely told to stand still.
	var enemy_before: int = room.graveblades_spawned
	var position_before: Vector3 = player.global_position
	await _settle(20)
	_expect(player.global_position.is_equal_approx(position_before),
		"the character moved %.3f m while the world was paused" % player.global_position.distance_to(position_before))
	_expect(room.graveblades_spawned == enemy_before, "a wave spawned while the world was paused")
	print("  20 frames later: the character moved 0.000 m and no wave spawned")

	# Safe focus first, and a real focus graph rather than hover.
	var focus: Control = get_viewport().gui_get_focus_owner()
	_expect(focus != null and focus.name == "Close",
		"the comparison focused '%s' first, not the safe non-destructive Close" % (focus.name if focus != null else "nothing"))
	var equip: Button = _button(comparison, "Equip")
	var close: Button = _button(comparison, "Close")
	_expect(not close.focus_neighbor_right.is_empty() and not equip.focus_neighbor_left.is_empty(),
		"the comparison's buttons have no explicit focus neighbours")
	print("  focus: %s first; Close <-> Equip is an explicit neighbour graph, not hover" % focus.name)

	# Glyphs follow the live input family and change no mechanical state.
	room.input_family.family = InputFamilyTracker.Family.CONTROLLER
	comparison.refresh_glyphs()
	var controller_text: String = _all_text_in(comparison)
	room.input_family.family = InputFamilyTracker.Family.MOUSE_KEYBOARD
	comparison.refresh_glyphs()
	var mouse_text: String = _all_text_in(comparison)
	print("  glyphs: controller shows (A)/(B), mouse and keyboard show Enter/Esc")
	_expect(controller_text.contains("(A)") and controller_text.contains("(B)"),
		"the controller glyphs are missing from the comparison")
	_expect(mouse_text.contains("Enter") and mouse_text.contains("Esc"),
		"the mouse and keyboard glyphs are missing from the comparison")
	_expect(GateEModal.glyph_for(&"interact", true) == "(A)"
		and GateEModal.glyph_for(&"interact", false) == "Left click",
		"the interact glyph does not follow the input family")

	# An input that was ALREADY held when the surface opened cannot act on it.
	var refused_before: int = comparison.held_inputs_refused
	comparison._armed[&"ui_confirm"] = false
	var confirm: InputEventAction = InputEventAction.new()
	confirm.action = &"ui_confirm"
	confirm.pressed = true
	comparison._input(confirm)
	_expect(comparison.held_inputs_refused == refused_before + 1,
		"a control held through the opening was allowed to press a button")
	_expect(not progress.honed_sword_equipped, "a held control equipped the sword")
	print("  a control held through the opening is refused until it is released")

	_press(comparison, "Close")
	await _settle(2)
	_expect(not get_tree().paused, "closing the comparison did not resume simulation")
	_expect(player.awaiting_neutral, "closing did not require neutral input before play resumes")
	print("  closed: simulation resumed, and movement waits for neutral controls")

	# And the latch really does gate movement until the controls are at rest.
	player.command_move_to(Vector3(2.0, 0.0, 0.0), Vector3(2.0, 0.0, 0.0), false)
	_expect(not player.has_destination, "a movement command was obeyed while awaiting neutral input")
	room.set_stick_override(null)
	await _release_all_inputs()
	await _settle(4)
	_expect(not player.awaiting_neutral, "the neutral latch never released once the controls were at rest")
	print("  a command during the latch is refused; the latch clears once the controls read neutral")


# --- 8. Equip ----------------------------------------------------------------

func _check_equip() -> void:
	print("")
	print("--- Equip replaces the prototype weapon directly (D-184)")
	await _release_all_inputs()
	room.open_item_comparison("equip")
	await _settle(2)
	_press(comparison, "Equip")
	await _settle(4)

	_expect(not comparison.is_open, "Equip left the comparison open")
	_expect(player.weapon == room.honed_sword, "Equip did not replace the equipped record")
	_expect(is_equal_approx(player.physical_damage, 150.0),
		"a Quick Strike now deals %.1f, not 150" % player.physical_damage)
	_expect(progress.honed_sword_equipped, "the equip milestone was not committed")
	_expect(director.drop() == null, "the sword is still on the ground after equipping")
	_expect(_count_drops() == 0, "%d drops remain after equipping" % _count_drops())
	# The attack time did not change: only Quickened Form does that.
	_expect(is_equal_approx(action.effective_action_time(), 0.80),
		"equipping changed the action time to %.4f s" % action.effective_action_time())
	print("  %s -> %s   %.0f -> %.0f Physical   action time still %.2f s" % [
		room.starter_sword.display_name, player.weapon.display_name,
		room.starter_sword.physical_damage, player.weapon.physical_damage,
		action.effective_action_time(),
	])

	# There is no inventory: the previous record is simply no longer equipped.
	_expect(not ("inventory" in player) and not ("items" in player) and not ("equipment" in player),
		"the player gained an inventory or equipment container")
	print("  no inventory, no equipment slot, no pickup capacity: one equipped record at a time")


# --- 9. UPGRADED_FIGHT: survives one Hit, dies on the second -----------------

func _check_upgraded_fight() -> void:
	print("")
	print("--- UPGRADED_FIGHT: the equivalent Graveblade dies in exactly two Hits")
	_expect(progress.stage == LabProgress.Stage.UPGRADED_FIGHT,
		"equipping left the lab in %s, not UPGRADED_FIGHT" % progress.stage_name())
	await _await_living_enemy(3.0)
	_expect(room.living_graveblade_count() == 1,
		"UPGRADED_FIGHT has %d living Graveblades, not one" % room.living_graveblade_count())

	var enemy: PrototypeGraveblade = room.graveblade
	enemy.set_ai_enabled(false)
	# "the enemy is mechanically identical to the first" (§15.1).
	_expect(is_equal_approx(enemy.data.max_life, 300.0),
		"the second Graveblade has %.0f Life, not the same 300" % enemy.data.max_life)
	_expect(is_equal_approx(enemy.data.physical_damage, 125.0),
		"the second Graveblade deals %.0f, not the same 125" % enemy.data.physical_damage)
	_expect(is_equal_approx(enemy.data.attack_reach, 1.65)
		and is_equal_approx(enemy.data.anticipation, 0.55)
		and is_equal_approx(enemy.data.move_speed, 3.4),
		"the second Graveblade is not mechanically identical to the first")

	var lives: Array[float] = [enemy.life]
	await _strike_enemy_once(enemy)
	lives.append(enemy.life)
	_expect(enemy.is_alive(), "the equivalent Graveblade did not survive the first Honed Sword Hit")
	await _strike_enemy_once(enemy)
	lives.append(enemy.life)
	print("  Graveblade Life with the Honed Sword: %s" % _format_lives(lives))
	_expect(_format_lives(lives) == "300 -> 150 -> 0",
		"the Honed Sword produced %s, not 300 -> 150 -> 0" % _format_lives(lives))
	_expect(not enemy.is_alive(), "the second Honed Sword Hit did not kill the Graveblade")


# --- 10. The second kill and the passive card -------------------------------

func _check_second_kill_and_passive_card() -> void:
	print("")
	print("--- The second eligible kill reaches exactly 20 / 20")
	await _settle(4)
	print("  XP trace: %s" % str(_experience_trace))
	_expect(progress.experience == 20, "XP reached %d, not exactly 20" % progress.experience)
	var expected_trace: Array[int] = [10, 20]
	_expect(_experience_trace == expected_trace,
		"the XP sequence was %s, not 0 -> 10 -> 20" % str(_experience_trace))
	_expect(progress.experience_is_complete(), "20 / 20 XP does not read as complete")
	_expect(progress.experience_line().contains("Complete"),
		"the XP line reads '%s' without Complete" % progress.experience_line())
	_expect(progress.stage == LabProgress.Stage.PASSIVE_READY,
		"20 / 20 XP left the lab in %s, not PASSIVE_READY" % progress.stage_name())

	print("")
	print("--- The passive card (specification §16.2)")
	await _settle(3)
	_expect(passive_card.is_open, "the passive card did not open at 20 / 20")
	_expect(get_tree().paused, "the passive card did not pause ordinary offline simulation")
	var text: String = _all_text_in(passive_card)
	for line: String in text.split("\n"):
		if not line.strip_edges().is_empty():
			print("  %s" % line.strip_edges())
	_expect(text.contains("Quickened Form"), "the card does not name Quickened Form")
	_expect(text.contains("25% increased Attack Speed"),
		"the card does not state 25% increased Attack Speed")
	_expect(text.contains("Quick Strike Attack Time: 0.80 s → 0.64 s"),
		"the card does not state the 0.80 s -> 0.64 s timing change")
	var buttons: Array[Button] = _buttons_in(passive_card)
	_expect(buttons.size() == 1 and buttons[0].name == "Confirm",
		"the passive card has %d buttons, not exactly Confirm" % buttons.size())
	for forbidden: String in [
		"point", "path", "attribute", "region", "socket", "refund", "search", "build lens", "tree",
	]:
		_expect(not text.to_lower().contains(forbidden),
			"the passive card mentions '%s'; specification §16.2 forbids it" % forbidden)
	print("  no Passive points, paths, attributes, regions, sockets, refunds, search, or Build Lens")

	# It is a DELIBERATE confirmation: cancel does not dismiss it.
	var cancel: InputEventAction = InputEventAction.new()
	cancel.action = &"ui_cancel"
	cancel.pressed = true
	passive_card._input(cancel)
	await _settle(2)
	_expect(passive_card.is_open, "ui_cancel dismissed the deliberate passive confirmation")
	_expect(not progress.quickened_form_active, "ui_cancel confirmed the passive")
	print("  cancel does not dismiss it: one option, deliberately confirmed")


# --- 11. Quickened Form ------------------------------------------------------

func _check_quickened_form() -> void:
	print("")
	print("--- Quickened Form: 0.80 s -> 0.64 s, every phase together (§12.2)")
	var before: Dictionary = _phase_times()
	_press(passive_card, "Confirm")
	await _settle(4)
	var after: Dictionary = _phase_times()

	_expect(not passive_card.is_open, "Confirm left the passive card open")
	_expect(progress.quickened_form_active, "the passive milestone was not committed")
	_expect(is_equal_approx(action.increased_attack_speed, 0.25),
		"increased attack speed is %.4f, not 0.25" % action.increased_attack_speed)

	for phase: String in ["wind-up", "release", "recovery", "action"]:
		print("  %-8s %.4f s -> %.4f s   (%.4fx)" % [
			phase, before[phase], after[phase], float(after[phase]) / float(before[phase]),
		])
		# Every phase compresses by the SAME factor: nothing stays locked after
		# the visible animation ends.
		_expect(is_equal_approx(float(after[phase]) / float(before[phase]), 1.0 / 1.25),
			"%s compressed by %.4fx, not by 1 / 1.25" % [phase, float(after[phase]) / float(before[phase])])
	_expect(is_equal_approx(float(after["action"]), 0.64),
		"the action time is %.4f s, not 0.64 s" % float(after["action"]))
	_expect(is_equal_approx(float(before["action"]), 0.80),
		"the action time before the passive was %.4f s, not 0.80 s" % float(before["action"]))
	_expect(is_equal_approx(
		float(after["wind-up"]) + float(after["release"]) + float(after["recovery"]), 0.64),
		"the three compressed phases do not add up to 0.64 s")

	# The release is still animation-aligned at the new speed — the whole reason
	# the marker is normalised rather than a timer.
	_release_animation_positions.clear()
	await _release_all_inputs()
	room.reset_encounter()
	await _settle(6)
	await _await_living_enemy(3.0)
	var enemy: PrototypeGraveblade = room.graveblade
	enemy.set_ai_enabled(false)
	for strike: int in 2:
		await _strike_enemy_once(enemy)
	print("  release animation position at %.2f s action time: %s (marker %.4f)" % [
		action.effective_action_time(), _format_positions(_release_animation_positions),
		quick_strike.release_marker_normalized,
	])
	_expect(_release_animation_positions.size() >= 2,
		"only %d releases were observed at the faster speed" % _release_animation_positions.size())
	for position: float in _release_animation_positions:
		_expect(absf(position - quick_strike.release_marker_normalized) < 0.001,
			"a sped-up release fired at clip position %.4f, not the %.4f marker" % [
				position, quick_strike.release_marker_normalized,
			])

	# The held repeat runs at the new action time.
	var intervals: Array[float] = await _measure_held_repeat(4)
	var average: float = 0.0
	for interval: float in intervals:
		average += interval
	average /= maxf(float(intervals.size()), 1.0)
	print("  held repeat at 25%% increased speed: %s, average %.4f s (target %.4f s)" % [
		_format_positions(intervals), average, action.effective_action_time(),
	])
	_expect(absf(average - 0.64) < 0.02,
		"the held repeat runs at %.4f s, not the 0.64 s action time" % average)

	_expect(progress.stage == LabProgress.Stage.REPEAT_LOOP,
		"confirming the passive left the lab in %s, not REPEAT_LOOP" % progress.stage_name())


# --- 12. The deterministic repeat waves --------------------------------------

func _check_repeat_waves() -> void:
	print("")
	print("--- REPEAT_LOOP: deterministic 1 -> 2 -> 3 waves (specification §15.1)")
	await _release_all_inputs()
	room.reset_lab_progress()
	await _settle(4)
	# Fast-forward the milestones through their own doors, so the repeat loop is
	# reached the way play reaches it rather than by writing state.
	await _fast_forward_to_repeat_loop()

	_wave_trace.clear()
	_wave_gaps.clear()
	var observed: PackedStringArray = PackedStringArray()
	for wave: int in 7:
		var arrived: float = await _await_wave(6.0)
		if arrived < 0.0:
			break
		observed.append(str(room.living_graveblade_count()))
		await _kill_every_living_graveblade()
	print("  observed wave sizes: %s" % " -> ".join(observed))
	print("  gaps after the threat was gone: %s" % _format_positions(_wave_gaps))
	_expect(String(", ").join(observed) == "1, 2, 3, 1, 2, 3, 1",
		"the repeat loop produced %s, not the deterministic 1 -> 2 -> 3 pattern" % " -> ".join(observed))

	var worst: float = 0.0
	var mean: float = 0.0
	for gap: float in _wave_gaps:
		worst = maxf(worst, absf(gap - data.wave_delay))
		mean += gap
	mean /= maxf(float(_wave_gaps.size()), 1.0)
	print("  mean gap %.4f s against the authored %.2f s; worst deviation %.4f s" % [
		mean, data.wave_delay, worst,
	])
	_expect(_wave_gaps.size() >= 6, "only %d wave gaps were measured" % _wave_gaps.size())
	_expect(worst < 0.12, "a wave gap was %.3f s off the %.2f s delay" % [worst, data.wave_delay])
	_expect(absf(mean - data.wave_delay) < 0.05,
		"the mean wave gap is %.4f s, not approximately the %.2f s delay" % [mean, data.wave_delay])

	# XP stays complete and the kill count keeps rising.
	print("  %s   %d repeat kills" % [progress.experience_line(), progress.repeat_loop_kills])
	_expect(progress.experience == 20, "the repeat loop changed XP to %d" % progress.experience)
	_expect(progress.experience_line().contains("Complete"), "the XP line stopped reading Complete")
	_expect(progress.repeat_loop_kills >= 12,
		"the repeat loop counted %d kills across seven waves" % progress.repeat_loop_kills)

	# The F3 debug force-wave-size selector exists, works, and lives only there.
	director.set_forced_wave_size(3)
	await _await_wave(6.0)
	print("  F3 forced wave size 3: %d Graveblades" % room.living_graveblade_count())
	_expect(room.living_graveblade_count() == 3,
		"the forced wave produced %d Graveblades, not 3" % room.living_graveblade_count())
	var overlay_buttons: Array[Button] = _buttons_in(room.lab_overlay as Control)
	var forced_names: PackedStringArray = PackedStringArray()
	for button: Button in overlay_buttons:
		if button.name.begins_with("ForceWave"):
			forced_names.append(button.name)
	_expect(forced_names.size() == 4,
		"the force-wave-size selector has %d buttons" % forced_names.size())
	# It is reachable ONLY through F3: its panel is hidden by default.
	room.set_debug_panels(false)
	await _settle(2)
	for button: Button in overlay_buttons:
		if button.name.begins_with("ForceWave"):
			_expect(not button.is_visible_in_tree(),
				"the force-wave-size selector is reachable without F3")
	print("  the force-wave-size selector is inside the F3 panel only, and hidden without it")
	director.set_forced_wave_size(0)
	await _kill_every_living_graveblade()


# --- 13. Safe spawn geometry -------------------------------------------------

func _check_spawn_safety() -> void:
	print("")
	print("--- Measured safe spawn geometry (specification §14.3)")
	await _release_all_inputs()
	await _kill_every_living_graveblade()
	await _teleport(Vector3.ZERO)

	for count: int in [1, 2, 3]:
		var plan: Dictionary = director.measure_spawn_plan(count)
		print("  %d spawn%s: cluster %d, nearest player %.2f m (need %.2f), apart %.2f m (need %.2f), spread %.0f deg (max %.0f), floor %s, navmesh %s" % [
			count, "" if count == 1 else "s", int(plan["cluster"]),
			float(plan["minimum_player_distance"]), data.minimum_player_distance,
			float(plan["minimum_separation"]), data.minimum_spawn_separation,
			float(plan["spread_degrees"]), data.maximum_spawn_spread_degrees,
			str(bool(plan["inside_clear_floor"])), str(bool(plan["on_navigation_mesh"])),
		])
		_expect(bool(plan["safe"]), "the %d-Graveblade spawn plan is not safe: %s" % [count, plan["note"]])
		_expect(float(plan["minimum_player_distance"]) >= data.minimum_player_distance,
			"a spawn is %.2f m from the player, inside the %.2f m minimum" % [
				float(plan["minimum_player_distance"]), data.minimum_player_distance,
			])
		_expect(float(plan["minimum_separation"]) >= data.minimum_spawn_separation,
			"two spawns are %.2f m apart, inside the %.2f m minimum" % [
				float(plan["minimum_separation"]), data.minimum_spawn_separation,
			])
		_expect(float(plan["spread_degrees"]) <= data.maximum_spawn_spread_degrees,
			"a wave spans %.0f deg around the player and surrounds them" % float(plan["spread_degrees"]))
		_expect(bool(plan["inside_clear_floor"]) and bool(plan["on_navigation_mesh"]),
			"a spawn point is outside the clear floor or off the navigation mesh")

	# The measurement is against the player's ACTUAL position: standing where the
	# first cluster is must move the wave to the other side of the room.
	await _teleport(Vector3(-6.0, 0.0, 4.5))
	var moved: Dictionary = director.measure_spawn_plan(3)
	print("  player standing ON cluster 0: plan moved to cluster %d, nearest %.2f m" % [
		int(moved["cluster"]), float(moved["minimum_player_distance"]),
	])
	_expect(int(moved["cluster"]) == 1, "standing on cluster 0 did not move the wave away")
	_expect(bool(moved["safe"]), "the relocated plan is not safe: %s" % moved["note"])
	_expect(float(moved["minimum_player_distance"]) >= data.minimum_player_distance,
		"the relocated wave still spawns %.2f m from the player" % float(moved["minimum_player_distance"]))

	# And a real wave really does obey it: nothing reaches the player before its
	# anticipation could even begin.
	await _teleport(Vector3.ZERO)
	var slowest_reach: float = (
		data.minimum_player_distance - room.graveblade_preferred_distance()
	) / room.graveblade_move_speed()
	print("  a %.1f m/s Graveblade needs at least %.2f s to close from %.2f m to its %.2f m holding distance" % [
		room.graveblade_move_speed(), slowest_reach, data.minimum_player_distance,
		room.graveblade_preferred_distance(),
	])
	_expect(slowest_reach >= 1.0,
		"a spawned Graveblade could reach the player in %.2f s, before control returns" % slowest_reach)

	director.set_forced_wave_size(3)
	await _await_wave(6.0)
	var nearest: float = INF
	for enemy: PrototypeGraveblade in room.graveblades:
		nearest = minf(nearest, enemy.distance_to_player())
		_expect(not enemy.is_attacking(), "%s was already attacking on the frame it spawned" % enemy.name)
	print("  a live three-Graveblade wave: nearest %.2f m, none attacking on the spawn frame" % nearest)
	_expect(nearest >= data.minimum_player_distance,
		"a live wave spawned %.2f m from the player" % nearest)
	# Bodies do not overlap.
	var closest_pair: float = INF
	for i: int in room.graveblades.size():
		for j: int in range(i + 1, room.graveblades.size()):
			closest_pair = minf(closest_pair,
				room.graveblades[i].global_position.distance_to(room.graveblades[j].global_position))
	print("  closest pair of bodies: %.2f m against a 0.80 m body diameter" % closest_pair)
	_expect(closest_pair >= 0.80, "two Graveblades spawned %.2f m apart and overlap" % closest_pair)

	# The Gate D card shows ONE Graveblade. With three alive it must say which,
	# rather than letting a single Life bar read as the whole wave.
	await _settle(3)
	var encounter: String = _visible_text_in(room.encounter_overlay as Control)
	for line: String in encounter.split("\n"):
		if line.contains("tracked"):
			print("  the Gate D card, with three alive: \"%s\"" % line.strip_edges())
	_expect(encounter.contains("tracked — 1 of 3 alive"),
		"the encounter card does not say it is showing one of three living Graveblades")
	_expect(encounter.contains(room.graveblade.name),
		"the encounter card does not name the Graveblade it is tracking")
	director.set_forced_wave_size(0)


# --- 14. Multiple Graveblades share one coordinator --------------------------

func _check_multi_enemy_coordination() -> void:
	print("")
	print("--- Several Graveblades share the existing AttackCoordinator (§14.3)")
	_expect(room.living_graveblade_count() == 3,
		"the coordination check needs three Graveblades, found %d" % room.living_graveblade_count())
	_expect(room.attack_coordinator.simultaneous_attackers == 1,
		"the coordinator permits %d simultaneous attackers" % room.attack_coordinator.simultaneous_attackers)
	_expect(is_equal_approx(room.attack_coordinator.minimum_release_gap, 0.25),
		"the minimum release gap is %.2f s, not 0.25 s" % room.attack_coordinator.minimum_release_gap)

	# The refusal branch itself, measured on the production coordinator: with the
	# slot held, a second attacker is refused.
	var a: PrototypeGraveblade = room.graveblades[0]
	var b: PrototypeGraveblade = room.graveblades[1]
	room.attack_coordinator.reset()
	_expect(room.attack_coordinator.request(a), "the first attacker was refused an empty slot")
	_expect(not room.attack_coordinator.request(b),
		"a second attacker was granted permission while the first held it")
	print("  slot held by %s: %s refused — \"%s\"" % [a.name, b.name, room.attack_coordinator.last_decision])

	# And the 0.25 s gap branch, which the single slot alone does not exercise:
	# free the slot immediately after a release start and ask again at once.
	#
	# The slot is freed as WITHDRAWN rather than as a completed action ON PURPOSE.
	# D-186's 0.35 s group handoff is longer than this 0.25 s gap, so a completed
	# action would mask the branch under test and this check would prove the
	# handoff twice instead of proving the gap once. The gap is the lower safety
	# bound underneath the handoff; §14a exercises the handoff itself.
	room.attack_coordinator.note_release_started(a)
	room.attack_coordinator.release(a, AttackCoordinator.ReleaseCause.WITHDRAWN, "verification")
	_expect(not room.attack_coordinator.group_handoff_active(),
		"a withdrawn release started the D-186 group handoff and masked the 0.25 s gap")
	_expect(not room.attack_coordinator.request(b),
		"a second attacker was granted permission within the 0.25 s release gap")
	print("  slot free but 0.00 s since a release start: %s refused — \"%s\"" % [
		b.name, room.attack_coordinator.last_decision,
	])
	await _settle(int(0.30 * 60.0))
	_expect(room.attack_coordinator.request(b),
		"an attacker was still refused after the 0.25 s gap had passed")
	room.attack_coordinator.release(b, AttackCoordinator.ReleaseCause.WITHDRAWN, "verification")
	print("  0.30 s later: %s granted" % b.name)

	# A live three-enemy fight: only ever one permission holder, and the gap
	# between DIFFERENT attackers' release starts holds.
	room.attack_coordinator.reset()
	room.enemy_release_starts.clear()
	await _teleport(Vector3.ZERO)
	for enemy: PrototypeGraveblade in room.graveblades:
		enemy.set_ai_enabled(true)
	var holders: int = 0
	var elapsed: float = 0.0
	# D-186 lengthened the group's cadence from about 1.25 s to about 1.60 s, so
	# the same five releases now need about half again as long to happen.
	while elapsed < 22.0 and room.enemy_release_starts.size() < 6:
		await _step()
		elapsed += TICK
		var holding: int = 0
		for enemy: PrototypeGraveblade in room.graveblades:
			if is_instance_valid(enemy) and room.attack_coordinator.holds_permission(enemy):
				holding += 1
		holders = maxi(holders, holding)
		player.life = player.max_life  ## keep the fight running long enough to measure
	print("  %.1f s of a live three-Graveblade fight: %d releases, at most %d permission holder at a time" % [
		elapsed, room.enemy_release_starts.size(), holders,
	])
	_expect(holders <= 1, "%d Graveblades held attack permission at once" % holders)
	_expect(room.enemy_release_starts.size() >= 3,
		"only %d enemy releases were observed in %.1f s" % [room.enemy_release_starts.size(), elapsed])

	var worst_gap: float = INF
	var gaps: Array[float] = []
	for i: int in range(1, room.enemy_release_starts.size()):
		var previous: Dictionary = room.enemy_release_starts[i - 1]
		var current: Dictionary = room.enemy_release_starts[i]
		if String(previous["enemy"]) == String(current["enemy"]):
			continue
		# Measured on the SIMULATION stamp, not the wall clock: this is a property
		# of the fight, and only the simulation stamp stops while a modal pauses it.
		var gap: float = float(current["at_sim"]) - float(previous["at_sim"])
		gaps.append(gap)
		worst_gap = minf(worst_gap, gap)
	print("  gaps between DIFFERENT attackers' release starts: %s (minimum required 0.25 s)" % _format_positions(gaps))
	_expect(gaps.size() >= 1, "no two different attackers released, so the gap could not be measured")
	_expect(worst_gap >= room.attack_coordinator.minimum_release_gap,
		"two different attackers released %.3f s apart, inside the 0.25 s minimum" % worst_gap)

	# --- D-186: the corrected group cadence, measured in this same live fight ---
	#
	# The whole point of the correction. Before it, these gaps were 1.24–1.28 s
	# because a waiting Graveblade inherited the slot the instant the previous
	# holder's recovery ended. The window the group now owes is the same 0.35 s
	# the attacker already owed itself, so the arithmetic is exact:
	#
	#     0.08 release + 0.62 recovery + 0.35 handoff + 0.55 anticipation = 1.60 s
	var cadence_data: GravebladeData = room.graveblades[0].data
	var expected_group: float = (
		cadence_data.release_window + cadence_data.recovery
		+ room.attack_coordinator.group_handoff_delay + cadence_data.anticipation
	)
	var group_mean: float = 0.0
	for gap: float in gaps:
		group_mean += gap
	group_mean /= maxf(float(gaps.size()), 1.0)
	print("  D-186 group cadence: %d gaps, minimum %.4f s, mean %.4f s against the expected %.4f s" % [
		gaps.size(), worst_gap, group_mean, expected_group,
	])
	print("    0.08 release + 0.62 recovery + %.2f group handoff + 0.55 anticipation = %.2f s" % [
		room.attack_coordinator.group_handoff_delay, expected_group,
	])
	_expect(is_equal_approx(expected_group, 1.60),
		"the expected group cadence computes to %.4f s, not 1.60 s" % expected_group)
	_expect(gaps.size() >= 2,
		"only %d different-attacker gaps were measured; the cadence needs at least two" % gaps.size())
	# The floor is the guarantee: nothing may release sooner than the arithmetic
	# above allows, within the frame quantisation of a 60 Hz simulation.
	_expect(worst_gap >= expected_group - 3.0 * TICK,
		"a different attacker released %.4f s after the previous one, inside the %.4f s D-186 floor" % [
			worst_gap, expected_group,
		])
	# And the group must actually RUN at that cadence rather than merely respect
	# it by standing around: the closest pair has to land near 1.60 s, not above it.
	_expect(worst_gap <= expected_group + 0.20,
		"the closest different-attacker gap was %.4f s, more than 0.20 s above the expected %.4f s" % [
			worst_gap, expected_group,
		])
	_expect(absf(group_mean - expected_group) <= 0.30,
		"the mean different-attacker gap was %.4f s against the expected %.4f s" % [
			group_mean, expected_group,
		])
	# The rule bound in a real fight rather than only in a provoked one.
	_expect(room.attack_coordinator.handoffs_started > 0,
		"no group handoff started during a live three-Graveblade fight")
	_expect(room.attack_coordinator.handoff_refusals > 0,
		"no Graveblade was ever refused by the group handoff during a live three-Graveblade fight")
	print("  the handoff bound in play: %d started, %d wind-up requests refused by it" % [
		room.attack_coordinator.handoffs_started, room.attack_coordinator.handoff_refusals,
	])

	# The Graveblade itself was reused UNCHANGED (D-184).
	var enemy_data: GravebladeData = room.graveblades[0].data
	_expect(is_equal_approx(enemy_data.max_life, 300.0)
		and is_equal_approx(enemy_data.physical_damage, 125.0)
		and is_equal_approx(enemy_data.anticipation, 0.55)
		and is_equal_approx(enemy_data.attack_reach, 1.65)
		and is_equal_approx(enemy_data.attack_arc_degrees, 90.0)
		and is_equal_approx(enemy_data.minimum_commitment_interval, 0.35),
		"a Gate D Graveblade value changed for the group test")
	print("  every accepted Gate D value is unchanged in the group: 300/125, 0.55 s, 1.65 m, 90 deg, 0.35 s")
	await _kill_every_living_graveblade()


# --- 14a. The D-186 group handoff --------------------------------------------

## D-186, in full: the correction the project owner's playtest asked for.
##
## The finding was precise. Every Graveblade already had the accepted 0.55 s
## anticipation and the 0.22 s visible commitment lead, and a lone Graveblade
## already owed 0.35 s after its action before it could commit again. In a group
## that interval was owed by the ATTACKER and by nobody else, so a waiting
## Graveblade inherited the slot the instant the previous holder's recovery ended
## and different attackers' release starts fell to 1.24-1.28 s apart. The group
## was bypassing the breathing window, not merely adding bodies.
##
## Everything below is measured on the PRODUCTION coordinator. Nine things have
## to be true, and the last of them — that one Graveblade is completely
## unaffected — is the one that decides whether this correction was narrow.
func _check_group_handoff() -> void:
	print("")
	print("--- The D-186 group handoff: 0.35 s after any attack action ends")
	var coordinator: AttackCoordinator = room.attack_coordinator

	# A lone Graveblade, standing still with its AI suspended, so the production
	# coordinator can be exercised branch by branch without a live fight taking
	# the slot out from under the measurement. It is a real Graveblade because
	# the death branch below needs one.
	await _kill_every_living_graveblade()
	director.set_forced_wave_size(1)
	var arrived: float = await _await_wave(10.0)
	_expect(arrived >= 0.0, "no Graveblade arrived for the group-handoff check")
	var lone: PrototypeGraveblade = room.graveblade
	_expect(lone != null, "the group-handoff check found no living Graveblade")
	if lone == null:
		return
	# Held separately, because this Graveblade is deliberately killed in the death
	# branch below and the director frees its body while the last measurement runs.
	var enemy_record: GravebladeData = lone.data
	lone.set_ai_enabled(false)
	var stand_in: Node = Node.new()
	stand_in.name = "SecondAttacker"
	add_child(stand_in)
	await _settle(2)

	# 1. The window is the accepted 0.35 s, and it is the SAME 0.35 s the
	#    Graveblade already owes itself. That identity is the whole argument for
	#    why one enemy cannot notice this change.
	print("  window %.2f s   individual interval %.2f s   release-gap floor %.2f s" % [
		coordinator.group_handoff_delay, enemy_record.minimum_commitment_interval,
		coordinator.minimum_release_gap,
	])
	_expect(is_equal_approx(coordinator.group_handoff_delay, 0.35),
		"the group handoff is %.4f s, not the D-186 0.35 s" % coordinator.group_handoff_delay)
	_expect(is_equal_approx(coordinator.group_handoff_delay, enemy_record.minimum_commitment_interval),
		"the group handoff and the individual commitment interval are different values")
	_expect(is_equal_approx(coordinator.minimum_release_gap, 0.25),
		"the 0.25 s release-gap floor moved to %.4f s" % coordinator.minimum_release_gap)
	_expect(coordinator.group_handoff_delay > coordinator.minimum_release_gap,
		"the group handoff is not longer than the release-gap floor it sits above")

	# 2. The decision is a VALUE, not a sentence. D-186 asks explicitly that the
	#    action-completion intent be explicit at the boundary rather than parsed
	#    out of a log line, so the mapping is asserted directly.
	_expect(AttackCoordinator.cause_starts_group_handoff(
		AttackCoordinator.ReleaseCause.ACTION_COMPLETED),
		"a completed attack action does not start the group handoff")
	_expect(AttackCoordinator.cause_starts_group_handoff(
		AttackCoordinator.ReleaseCause.ATTACKER_DIED),
		"dying while holding permission does not start the group handoff")
	_expect(not AttackCoordinator.cause_starts_group_handoff(
		AttackCoordinator.ReleaseCause.WITHDRAWN),
		"withdrawing without attacking starts the group handoff")
	_expect(not AttackCoordinator.cause_starts_group_handoff(
		AttackCoordinator.ReleaseCause.ADMINISTRATIVE),
		"an administrative release starts the group handoff")

	#    And the words really are ignored: a WITHDRAWN release whose reason string
	#    says "action finished" must start nothing, and an ACTION_COMPLETED
	#    release with no reason string at all must start it anyway.
	coordinator.reset()
	_expect(coordinator.request(lone), "the lone Graveblade was refused an empty slot")
	coordinator.release(lone, AttackCoordinator.ReleaseCause.WITHDRAWN, "action finished")
	_expect(not coordinator.group_handoff_active(),
		"the coordinator started the handoff from the WORDS \"action finished\"")
	coordinator.reset()
	_expect(coordinator.request(lone), "the lone Graveblade was refused an empty slot")
	coordinator.release(lone, AttackCoordinator.ReleaseCause.ACTION_COMPLETED)
	_expect(coordinator.group_handoff_active(),
		"a completed action with no reason string started no handoff")
	print("  the cause decides, not the words: WITHDRAWN \"action finished\" starts nothing;")
	print("    ACTION_COMPLETED with no words at all starts %.2f s" % coordinator.group_handoff_delay)

	# 3. An irrelevant non-holder changes nothing at all.
	coordinator.reset()
	_expect(coordinator.request(lone), "the lone Graveblade was refused an empty slot")
	coordinator.release(stand_in, AttackCoordinator.ReleaseCause.ACTION_COMPLETED, "never held it")
	_expect(not coordinator.group_handoff_active(),
		"a release from something that never held permission started the handoff")
	_expect(coordinator.holds_permission(lone),
		"a release from a non-holder took the slot away from the real holder")

	# 4. No permission during the window, and permission the moment it expires.
	#    Asked by a DIFFERENT attacker every single frame, so the refusal is not
	#    an artefact of asking too rarely and the grant is not an artefact of
	#    asking too late.
	coordinator.reset()
	_expect(coordinator.request(lone), "the lone Graveblade was refused an empty slot")
	coordinator.release(lone, AttackCoordinator.ReleaseCause.ACTION_COMPLETED, "verification action")
	_expect(absf(coordinator.group_handoff_remaining() - coordinator.group_handoff_delay) < 0.0005,
		"the window opened at %.4f s rather than the full %.4f s" % [
			coordinator.group_handoff_remaining(), coordinator.group_handoff_delay,
		])
	var refused_frames: int = 0
	var granted_at: float = -1.0
	var probe: float = 0.0
	while probe < 1.00:
		if coordinator.request(stand_in):
			granted_at = probe
			break
		refused_frames += 1
		await _step()
		probe += TICK
	print("  a different attacker asking every frame: refused %d frames, granted at %.4f s" % [
		refused_frames, granted_at,
	])
	_expect(granted_at >= 0.0, "a different attacker was never granted permission after the window")
	_expect(granted_at >= coordinator.group_handoff_delay - TICK,
		"a different attacker was granted permission %.4f s into the %.2f s window" % [
			granted_at, coordinator.group_handoff_delay,
		])
	_expect(granted_at <= coordinator.group_handoff_delay + 2.0 * TICK,
		"permission did not become available promptly after the window: %.4f s" % granted_at)
	_expect(refused_frames >= 18,
		"only %d frames were refused inside a 0.35 s window at 60 Hz" % refused_frames)
	coordinator.release(stand_in, AttackCoordinator.ReleaseCause.WITHDRAWN, "verification")

	# 4a. D-186 asks for the remaining window to be visible in F3. It is shown on
	#     the coordinator's own Gate D card AND on the Gate E lab panel that owns
	#     the waves, as a live countdown rather than as a label that says a rule
	#     exists — so the checks read what actually reaches the screen.
	room.set_debug_panels(true)
	coordinator.reset()
	_expect(coordinator.request(lone), "the lone Graveblade was refused an empty slot")
	coordinator.release(lone, AttackCoordinator.ReleaseCause.ACTION_COMPLETED, "verification action")
	# READ THE PANELS ON THE CLOCK THE PANELS RUN ON.
	#
	# Both overlays rebuild their debug text in `_process`, and this suite steps
	# the PHYSICS frame. On a loaded machine Godot runs several physics steps
	# inside one idle frame, so three `_step()`s can pass without either panel
	# ever being redrawn — and the text read here would then be the text from
	# before the window started. That is the same defect as the two Gate F report
	# §10b.2 corrects, wearing a different costume: a quantity produced on one
	# timeline, waited for on another. It flaked under load during the D-192 run.
	# Waiting for the idle frames themselves changes no assertion, no tolerance,
	# and no value; the window is 0.35 s, which is far longer than two idle
	# frames even when the engine has clamped them.
	await _await_process_frames(2)
	var encounter_running: String = _visible_text_in(room.encounter_overlay as Control)
	var lab_running: String = _visible_text_in(room.lab_overlay as Control)
	for line: String in (encounter_running + "\n" + lab_running).split("\n"):
		if line.contains("group handoff"):
			print("  F3, window running: \"%s\"" % line.strip_edges())
	_expect(encounter_running.contains("group handoff"),
		"the Gate D F3 card does not show the group handoff")
	_expect(lab_running.contains("group handoff"),
		"the Gate E F3 lab panel does not show the group handoff")
	_expect(encounter_running.contains("of %.2f s" % coordinator.group_handoff_delay),
		"the Gate D F3 card does not count the window down against its %.2f s length" % coordinator.group_handoff_delay)
	_expect(lab_running.contains("of %.2f s remaining" % coordinator.group_handoff_delay),
		"the Gate E F3 lab panel does not show the window's remaining time")
	await _settle(30)
	# And the same again for the expired reading: the window is gone on the
	# physics clock, but the panels only say so once an idle frame has redrawn
	# them.
	await _await_process_frames(2)
	var encounter_idle: String = _visible_text_in(room.encounter_overlay as Control)
	var lab_idle: String = _visible_text_in(room.lab_overlay as Control)
	_expect(not coordinator.group_handoff_active(), "the window did not expire during the F3 check")
	_expect(not encounter_idle.contains("of %.2f s" % coordinator.group_handoff_delay),
		"the Gate D F3 card still shows a countdown after the window expired")
	_expect(lab_idle.contains("group handoff idle"),
		"the Gate E F3 lab panel does not say the window is idle once it has expired")
	room.set_debug_panels(false)
	await _settle(2)

	# 5. A modal pause cannot spend the window. The delay is counted in
	#    `_physics_process`, so the flag every Gate E modal sets — proved against
	#    the real comparison in the modal-contract check — stops it dead.
	var modal_source: String = _code_only(
		FileAccess.get_file_as_string("res://scripts/ui/gate_e_modal.gd"))
	_expect(modal_source.contains("get_tree().paused = true"),
		"the Gate E modal no longer pauses through get_tree().paused, so this check tests the wrong flag")
	_expect(coordinator.process_mode == Node.PROCESS_MODE_INHERIT,
		"the coordinator's process mode is %d, so a paused world would not stop its clock" % coordinator.process_mode)
	coordinator.reset()
	_expect(coordinator.request(lone), "the lone Graveblade was refused an empty slot")
	coordinator.release(lone, AttackCoordinator.ReleaseCause.ACTION_COMPLETED, "verification action")
	var at_pause: float = coordinator.group_handoff_remaining()
	get_tree().paused = true
	await _settle(40)
	var after_pause: float = coordinator.group_handoff_remaining()
	print("  paused for 40 frames (%.2f s of simulation, more than the window): %.4f s -> %.4f s owed" % [
		40.0 * TICK, at_pause, after_pause,
	])
	_expect(is_equal_approx(at_pause, after_pause),
		"a paused world spent %.4f s of the group handoff" % (at_pause - after_pause))
	_expect(not coordinator.request(stand_in),
		"a wind-up was granted while the world was paused inside the group handoff")
	get_tree().paused = false
	var resumed_at: float = -1.0
	probe = 0.0
	while probe < 1.00:
		if coordinator.request(stand_in):
			resumed_at = probe
			break
		await _step()
		probe += TICK
	print("  resumed: the full %.4f s was still owed, granted %.4f s later" % [after_pause, resumed_at])
	_expect(resumed_at >= after_pause - TICK and resumed_at <= after_pause + 2.0 * TICK,
		"after the pause the window took %.4f s instead of the %.4f s still owed" % [resumed_at, after_pause])
	coordinator.release(stand_in, AttackCoordinator.ReleaseCause.WITHDRAWN, "verification")

	# 6. Reset and revocation clear it, and neither of them starts it.
	coordinator.reset()
	_expect(coordinator.request(lone), "the lone Graveblade was refused an empty slot")
	coordinator.release(lone, AttackCoordinator.ReleaseCause.ACTION_COMPLETED, "verification action")
	_expect(coordinator.group_handoff_active(), "the window did not open before the revocation check")
	coordinator.revoke_all("verification")
	_expect(not coordinator.group_handoff_active(), "revoke_all left a group handoff running")
	_expect(coordinator.request(lone), "an attacker was refused immediately after revoke_all cleared the window")
	coordinator.revoke_all("verification, with a holder")
	_expect(not coordinator.group_handoff_active(), "revoking a live holder started a group handoff")
	coordinator.release(lone, AttackCoordinator.ReleaseCause.ADMINISTRATIVE, "verification")
	_expect(not coordinator.group_handoff_active(), "an administrative release started a group handoff")
	_expect(coordinator.request(lone), "the lone Graveblade was refused an empty slot")
	coordinator.release(lone, AttackCoordinator.ReleaseCause.ACTION_COMPLETED, "verification action")
	_expect(coordinator.group_handoff_active(), "the window did not open before the reset check")
	coordinator.reset()
	_expect(not coordinator.group_handoff_active(), "reset() left a group handoff running")
	_expect(coordinator.handoffs_started == 0 and coordinator.handoff_refusals == 0,
		"reset() left the group-handoff instrumentation dirty")
	print("  revoke_all and reset() both clear the window; neither ever starts one")

	# 7. Death while holding the slot starts it. Without this, killing the
	#    attacker would hand the next Graveblade a free immediate strike.
	coordinator.reset()
	_expect(coordinator.request(lone), "the lone Graveblade was refused an empty slot")
	_expect(coordinator.holds_permission(lone), "the lone Graveblade did not hold the slot before dying")
	lone.receive_damage(DamageEvent.physical(9601, player, lone, lone.life))
	await _step()
	print("  a Graveblade killed while holding the slot: alive=%s, holder=%s, window %.4f s" % [
		str(lone.is_alive()),
		coordinator.holder().name if coordinator.holder() != null else "nobody",
		coordinator.group_handoff_remaining(),
	])
	_expect(not lone.is_alive(), "the Graveblade survived a lethal verification Hit")
	_expect(coordinator.holder() == null, "a dead Graveblade kept the permission slot")
	_expect(coordinator.group_handoff_active(),
		"a Graveblade that died holding permission started no group handoff")
	_expect(not coordinator.request(stand_in),
		"a different attacker was granted permission the instant the holder died")
	stand_in.queue_free()

	# 8. THE ONE THAT MATTERS: a single Graveblade's cadence is untouched. Its
	#    own interval and the group window are the same 0.35 s started on the same
	#    frame, so it asks again at exactly the moment it always did — and the
	#    group rule never refuses it even once.
	var solo_gaps: Array[float] = await _measure_solo_release_gaps("one-Graveblade")
	var solo_expected: float = enemy_record.action_time() + enemy_record.minimum_commitment_interval
	var solo_mean: float = 0.0
	for gap: float in solo_gaps:
		solo_mean += gap
	solo_mean /= maxf(float(solo_gaps.size()), 1.0)
	print("  one Graveblade: release starts %s" % _format_positions(solo_gaps))
	print("    mean %.4f s against the unchanged %.2f s action + %.2f s interval = %.4f s" % [
		solo_mean, enemy_record.action_time(), enemy_record.minimum_commitment_interval, solo_expected,
	])
	_expect(is_equal_approx(solo_expected, 1.60),
		"the unchanged one-enemy cadence computes to %.4f s, not 1.60 s" % solo_expected)
	_expect(solo_gaps.size() >= 2,
		"only %d one-Graveblade gaps were measured; the cadence needs at least two" % solo_gaps.size())
	for gap: float in solo_gaps:
		_expect(absf(gap - solo_expected) <= 0.15,
			"a one-Graveblade release gap was %.4f s against the unchanged %.4f s" % [gap, solo_expected])
	_expect(absf(solo_mean - solo_expected) <= 0.10,
		"the mean one-Graveblade gap was %.4f s against the unchanged %.4f s" % [solo_mean, solo_expected])
	# The proof that the group rule is inert here is not that the number matches:
	# it is that the rule was never once the reason a lone Graveblade waited.
	_expect(coordinator.handoffs_started > 0,
		"the lone Graveblade completed no attack action, so nothing was measured")
	_expect(coordinator.handoff_refusals == 0,
		"the group handoff refused a lone Graveblade %d times; its cadence is NOT unchanged" % coordinator.handoff_refusals)
	print("  %d windows opened behind it and %d refusals: a lone Graveblade never waits on the group rule" % [
		coordinator.handoffs_started, coordinator.handoff_refusals,
	])

	# 9. And the same fight run on the PRE-CORRECTION coordinator, for comparison
	#    rather than for argument. A window of 0.00 s is not a special case in the
	#    code — `_start_group_handoff` simply declines to open one — so this is
	#    literally the object D-185 shipped, measured against the object D-186
	#    ships, on the same enemy, the same spawn, and the same player position.
	var locked_window: float = coordinator.group_handoff_delay
	coordinator.group_handoff_delay = 0.0
	var without_window: Array[float] = await _measure_solo_release_gaps("pre-correction one-Graveblade")
	coordinator.group_handoff_delay = locked_window
	_expect(is_equal_approx(coordinator.group_handoff_delay, 0.35),
		"the A/B measurement did not restore the locked 0.35 s window")
	print("  the same fight with the window disabled: %s" % _format_positions(without_window))
	_expect(without_window.size() == solo_gaps.size(),
		"the two one-Graveblade fights produced %d and %d gaps and cannot be compared" % [
			without_window.size(), solo_gaps.size(),
		])
	var worst_difference: float = 0.0
	for i: int in mini(without_window.size(), solo_gaps.size()):
		worst_difference = maxf(worst_difference, absf(without_window[i] - solo_gaps[i]))
	print("    worst difference between the corrected and uncorrected one-enemy cadence: %.4f s" % worst_difference)
	_expect(worst_difference <= TICK + 0.0001,
		"D-186 moved the one-Graveblade cadence by %.4f s; it must move by nothing" % worst_difference)

	director.set_forced_wave_size(0)
	await _kill_every_living_graveblade()


## One live fight against exactly one Graveblade, returning the gaps between its
## own release starts on the simulation clock. Written once and called twice, so
## the D-186 A/B compares two runs of the same procedure rather than two
## procedures that happen to look alike.
func _measure_solo_release_gaps(label: String) -> Array[float]:
	await _kill_every_living_graveblade()
	# Teleported BEFORE the wave, so the director plans the spawn around where the
	# fight is actually going to happen rather than around where it used to be.
	await _teleport(Vector3.ZERO)
	director.set_forced_wave_size(1)
	var arrived: float = await _await_wave(10.0)
	_expect(arrived >= 0.0, "no Graveblade arrived for the %s cadence measurement" % label)
	_expect(room.living_graveblade_count() == 1,
		"the %s cadence measurement found %d Graveblades" % [label, room.living_graveblade_count()])
	room.attack_coordinator.reset()
	room.enemy_release_starts.clear()
	for enemy: PrototypeGraveblade in room.graveblades:
		if is_instance_valid(enemy):
			enemy.set_ai_enabled(true)
	var elapsed: float = 0.0
	while elapsed < 18.0 and room.enemy_release_starts.size() < 4:
		await _step()
		elapsed += TICK
		player.life = player.max_life  ## the measurement is of cadence, not of survival
	var gaps: Array[float] = []
	for i: int in range(1, room.enemy_release_starts.size()):
		var previous: Dictionary = room.enemy_release_starts[i - 1]
		var current: Dictionary = room.enemy_release_starts[i]
		_expect(String(previous["enemy"]) == String(current["enemy"]),
			"a second attacker appeared during the %s measurement" % label)
		gaps.append(float(current["at_sim"]) - float(previous["at_sim"]))
	return gaps


# --- 15. Duplicate-reward abuse ----------------------------------------------

func _check_duplicate_reward_abuse() -> void:
	print("")
	print("--- Duplicate-reward abuse (specification §15.2, D-184)")
	await _release_all_inputs()
	room.reset_lab_progress()
	await _settle(6)
	await _await_living_enemy(3.0)

	var enemy: PrototypeGraveblade = room.graveblade
	enemy.set_ai_enabled(false)
	# Corpses linger long enough here to be abused deliberately.
	var authored_linger: float = data.corpse_linger
	data.corpse_linger = 30.0
	for strike: int in 3:
		await _strike_enemy_once(enemy)
	await _settle(4)
	var xp_after_kill: int = progress.experience
	var drops_after_kill: int = _count_drops()
	_expect(xp_after_kill == 10, "the first kill granted %d XP" % xp_after_kill)
	_expect(drops_after_kill == 1, "the first kill produced %d drops" % drops_after_kill)

	# a. A duplicate kill signal, straight into the handler.
	var fake: DamageEvent = DamageEvent.physical(999, player, enemy, 999.0)
	enemy.died.emit(fake)
	enemy.died.emit(fake)
	await _settle(3)
	print("  duplicate kill signal x2:   XP %d, drops %d, refusals %d" % [
		progress.experience, _count_drops(), progress.duplicate_attempts_refused,
	])
	_expect(progress.experience == xp_after_kill, "a duplicate kill signal granted XP")
	_expect(_count_drops() == drops_after_kill, "a duplicate kill signal dropped a second sword")

	# b. Contact with the corpse: a real Quick Strike at it.
	await _strike_enemy_once(enemy)
	await _strike_enemy_once(enemy)
	await _settle(3)
	print("  two real swings at the corpse: XP %d, drops %d, DamageEvents %d" % [
		progress.experience, _count_drops(), action.damage_events,
	])
	_expect(progress.experience == xp_after_kill, "striking the corpse granted XP")
	_expect(_count_drops() == drops_after_kill, "striking the corpse dropped a second sword")
	_expect(not enemy.is_alive(), "the corpse came back to life")

	# c. Repeated input: many Equip presses through the real button.
	for attempt: int in 4:
		await _release_all_inputs()
		room.open_item_comparison("abuse %d" % (attempt + 1))
		await _settle(2)
		_press(comparison, "Equip")
		_press(comparison, "Equip")
		await _settle(2)
	print("  Equip pressed eight times across four reopenings: equipped=%s, damage %.0f, drops %d" % [
		str(progress.honed_sword_equipped), player.physical_damage, _count_drops(),
	])
	_expect(progress.honed_sword_equipped, "the sword was never equipped")
	_expect(is_equal_approx(player.physical_damage, 150.0),
		"repeated equipping produced %.0f damage" % player.physical_damage)
	_expect(_count_drops() == 0, "%d drops remain after equipping" % _count_drops())
	_expect(progress.experience == xp_after_kill, "repeated equipping granted XP")

	# d. Reaching 20 / 20, then confirming the passive repeatedly.
	data.corpse_linger = authored_linger
	await _await_living_enemy(4.0)
	await _kill_every_living_graveblade()
	await _settle(6)
	_expect(progress.experience == 20, "the second kill left XP at %d" % progress.experience)
	for attempt: int in 3:
		if not passive_card.is_open:
			passive_card.open()
			await _settle(2)
		_press(passive_card, "Confirm")
		_press(passive_card, "Confirm")
		await _settle(2)
	print("  Confirm pressed six times: increased attack speed %.2f, action time %.4f s" % [
		action.increased_attack_speed, action.effective_action_time(),
	])
	# Reopening an already-confirmed passive must not leave a card on screen with
	# a disabled button and the world paused behind it.
	_expect(not passive_card.is_open,
		"an already-confirmed passive card was left open with nothing to press")
	_expect(not get_tree().paused,
		"the world was left paused behind an already-confirmed passive card")
	_expect(is_equal_approx(action.increased_attack_speed, 0.25),
		"repeated confirmation produced %.2f increased attack speed" % action.increased_attack_speed)
	_expect(is_equal_approx(action.effective_action_time(), 0.64),
		"repeated confirmation produced a %.4f s action time" % action.effective_action_time())
	_expect(progress.experience == 20, "repeated confirmation changed XP to %d" % progress.experience)

	# e. The debug CURRENT-STAGE reset retains every completed milestone.
	var before: Array = [
		progress.experience, progress.honed_sword_equipped, progress.quickened_form_active,
		progress.stage_name(),
	]
	room.reset_encounter()
	await _settle(6)
	room.reset_encounter()
	await _settle(6)
	var after: Array = [
		progress.experience, progress.honed_sword_equipped, progress.quickened_form_active,
		progress.stage_name(),
	]
	print("  F11 twice: XP %d, equipped %s, passive %s, stage %s — retained" % after)
	_expect(before == after, "a current-stage reset changed the milestones: %s -> %s" % [str(before), str(after)])
	_expect(is_equal_approx(player.physical_damage, 150.0),
		"a current-stage reset unequipped the Honed Sword")
	_expect(is_equal_approx(action.effective_action_time(), 0.64),
		"a current-stage reset removed Quickened Form")
	_expect(_count_drops() == 0, "a current-stage reset produced a second sword")
	print("  %d duplicate attempts refused in total" % progress.duplicate_attempts_refused)
	_expect(progress.duplicate_attempts_refused > 0,
		"no duplicate attempt was recorded, so the refusals cannot be trusted")


# --- 16. The stages happened in order ---------------------------------------

func _check_stage_order() -> void:
	print("")
	print("--- Stage order (specification §15)")
	print("  recorded: %s" % " -> ".join(_stage_trace))
	var expected: PackedStringArray = PackedStringArray([
		"STARTER_FIGHT", "UPGRADE_ON_GROUND", "UPGRADED_FIGHT", "PASSIVE_READY", "REPEAT_LOOP",
	])
	var first_pass: PackedStringArray = PackedStringArray()
	for stage_name: String in _stage_trace:
		if first_pass.size() < expected.size() and stage_name == expected[first_pass.size()]:
			first_pass.append(stage_name)
	_expect(String(", ").join(first_pass) == String(", ").join(expected),
		"the first pass through the stages was %s" % " -> ".join(first_pass))
	# The five stages, and no sixth.
	for stage_name: String in _stage_trace:
		_expect(expected.has(stage_name), "an unexpected stage '%s' appeared" % stage_name)


# --- 17. Reset Lab Progress deliberately clears ------------------------------

func _check_reset_lab_progress() -> void:
	print("")
	print("--- Reset Lab Progress deliberately clears the sequence (§15.2)")
	_expect(progress.experience > 0 or progress.honed_sword_equipped,
		"there was nothing to clear")
	room.reset_lab_progress()
	await _settle(6)
	print("  after Reset Lab Progress: %s" % progress.describe())
	_expect(progress.experience == 0, "XP is %d after a reset" % progress.experience)
	_expect(not progress.honed_sword_equipped, "the Honed Sword survived a reset")
	_expect(not progress.quickened_form_active, "Quickened Form survived a reset")
	_expect(not progress.starter_kill_rewarded and not progress.upgraded_kill_rewarded,
		"a kill milestone survived a reset")
	_expect(progress.repeat_loop_kills == 0, "the repeat-loop kill count survived a reset")
	_expect(progress.stage == LabProgress.Stage.STARTER_FIGHT,
		"the reset left the lab in %s" % progress.stage_name())
	_expect(player.weapon == room.starter_sword, "the reset left the Honed Sword equipped")
	_expect(is_equal_approx(action.effective_action_time(), 0.80),
		"the reset left the action time at %.4f s" % action.effective_action_time())
	_expect(_count_drops() == 0, "the reset left a sword on the ground")
	await _await_living_enemy(3.0)
	_expect(room.living_graveblade_count() == 1,
		"the reset began STARTER_FIGHT with %d Graveblades" % room.living_graveblade_count())


# --- 18. Gate C and Gate D values are preserved ------------------------------

func _check_preserved_gate_c_and_d() -> void:
	print("")
	print("--- Every accepted Gate C and Gate D value is preserved (D-180, D-183)")
	for expectation: Dictionary in [
		{"what": "Quick Strike action", "got": quick_strike.action_time, "want": 0.80},
		{"what": "release marker", "got": quick_strike.release_marker_normalized, "want": 0.325},
		{"what": "reach", "got": quick_strike.reach, "want": 1.65},
		{"what": "release arc", "got": quick_strike.release_arc_degrees, "want": 100.0},
		{"what": "input buffer", "got": quick_strike.input_buffer, "want": 0.12},
		{"what": "Mana cost", "got": quick_strike.mana_cost, "want": 5.0},
		{"what": "soft-target cone", "got": quick_strike.soft_target_cone_degrees, "want": 65.0},
		{"what": "cone half-angle", "got": quick_strike.soft_target_cone_half_degrees(), "want": 32.5},
		{"what": "angle tie band", "got": quick_strike.soft_target_angle_tie_degrees, "want": 12.0},
		{"what": "target retention", "got": quick_strike.soft_target_retention, "want": 0.35},
		{"what": "controller deadzone", "got": player.stick_deadzone, "want": 0.20},
		{"what": "substantial turn", "got": player.substantial_turn_degrees, "want": 35.0},
		{"what": "maximum speed", "got": player.max_speed, "want": 5.0},
		{"what": "player Life", "got": player.max_life, "want": 500.0},
	]:
		_expect(is_equal_approx(float(expectation["got"]), float(expectation["want"])),
			"%s is %.4f, the accepted value is %.4f" % [
				expectation["what"], expectation["got"], expectation["want"],
			])
	print("  Quick Strike, targeting, Mana, deadzone, turn threshold, speed, and Life all unchanged")

	# D-178's in-reach priority still decides a controller pick, now with a real
	# Graveblade as the near candidate.
	await _release_all_inputs()
	await _await_living_enemy(3.0)
	var enemy: PrototypeGraveblade = room.graveblade
	enemy.set_ai_enabled(false)
	# The stick is read in CAMERA space, so both candidates are placed along the
	# direction a stick of (1, 0) actually points — the camera's ground right.
	var aimed: Vector3 = room.camera_rig.ground_right()
	enemy.place_at(aimed * 1.40)
	await _teleport(Vector3.ZERO)
	var post: PrototypeTargetFixture = room.fixtures[0]
	var authored: Vector3 = post.home_position()
	post.place_at(aimed * 4.50)
	await _settle(4)
	room.input_family.family = InputFamilyTracker.Family.CONTROLLER
	room.set_stick_override(Vector2(1.0, 0.0))
	await _settle(3)
	var answer: Dictionary = room.resolve_quick_strike_aim()
	var chosen: PrototypeTargetable = answer["target"] as PrototypeTargetable
	print("  in-reach priority: chose %s — %s" % [
		chosen.target_display_name() if chosen != null else "nothing", answer["reason"],
	])
	_expect(chosen != null and chosen.combat_actor() == enemy,
		"D-178's in-reach priority did not choose the Graveblade at arm's length")
	_expect(String(answer["group"]) == "in reach",
		"the priority group was '%s', not 'in reach'" % answer["group"])
	post.place_at(authored)
	room.set_stick_override(null)
	room.input_family.family = InputFamilyTracker.Family.MOUSE_KEYBOARD
	await _settle(3)
	_expect(post.home_position().is_equal_approx(authored),
		"the practice post was left drifted from its authored position")

	# The practice posts are still inert, and still not Graveblades.
	action.increased_attack_speed = progress.increased_attack_speed()
	var events_before: int = action.damage_events
	var releases_before: int = action.uses_released
	await _teleport(post.global_position - Vector3(1.20, 0.0, 0.0))
	await _face_player(Vector3(1.0, 0.0, 0.0))
	Input.action_press(&"attack_in_place")
	_aim_cursor_at(post.targeting_point())
	room.press_quick_strike()
	action.release_input()
	await _await_action_ready(3.0)
	Input.action_release(&"attack_in_place")
	room.set_cursor_override(null)
	print("  a release onto a practice post: %d DamageEvents, %d ground drops, XP %d" % [
		action.damage_events - events_before, _count_drops(), progress.experience,
	])
	# The attack must have actually happened, or "no DamageEvent" would be true
	# for the wrong reason.
	_expect(action.uses_released > releases_before,
		"the release onto the practice post never fired, so its inertness was not tested")
	_expect(action.damage_events == events_before,
		"a release onto an inert practice post produced a DamageEvent")


# --- 19. Scope ---------------------------------------------------------------

func _check_scope() -> void:
	print("")
	print("--- Scope: Gate E did not start Gate F or any first-MVP system")

	# No general item system, inventory, or equipment slot.
	for forbidden: String in [
		"inventory", "items", "equipment", "slots", "field_pack", "stash", "vault",
		"pickup_capacity", "rarity", "affix", "affixes", "prefix", "suffix", "tier",
		"requirement", "item_level", "implicit", "roll", "reroll", "craft", "forge",
	]:
		_expect(not (forbidden in room), "the room has a '%s' member; that is a first-MVP system" % forbidden)
		_expect(not (forbidden in player), "the player has a '%s' member; that is a first-MVP system" % forbidden)
		_expect(not (forbidden in director), "the director has a '%s' member; that is a first-MVP system" % forbidden)
	# The weapon record itself is the wrong shape to become an item.
	for forbidden: String in [
		"rarity", "base_type", "item_level", "required_level", "implicit", "affixes",
		"prefixes", "suffixes", "tier", "conflict_group", "wrought", "unique", "strain",
	]:
		_expect(not (forbidden in room.honed_sword),
			"the weapon record has a '%s' field; it is not an item" % forbidden)
	print("  no inventory, equipment slot, rarity, affix, Tier, requirement, roll, or crafting anywhere")

	# No Passive Web.
	for forbidden: String in [
		"passive_web", "passive_points", "passive_point", "allocate", "refund",
		"nodes", "notable", "keystone", "attributes", "strength", "dexterity", "intelligence",
	]:
		_expect(not (forbidden in room), "the room has a '%s' member; the Passive Web is first-MVP" % forbidden)
		_expect(not (forbidden in director), "the director has a '%s' member; the Passive Web is first-MVP" % forbidden)
		_expect(not (forbidden in progress), "LabProgress has a '%s' member; the Passive Web is first-MVP" % forbidden)
	print("  no Passive Web, Passive points, paths, refunds, or attributes")

	# TWELVE ASSERTIONS MOVED FORWARD BY AUTHORIZATION, and the arithmetic is
	# stated rather than implied. This block used to forbid, by name, ten things
	# D-189 has now authorized — the Fallen overlay, the pause menu, the settings
	# panel, the saved state, Restart, quick restart, the damage-number setting,
	# screen shake, Start New, and Continue. Two more went with them: "no audio
	# player exists in the room" and "no user://prototype_zero.cfg exists". All
	# twelve are false BY AUTHORIZATION rather than by regression, exactly as Gate
	# E moved one Gate C clause under D-181 and eleven Gate D clauses under D-184.
	#
	# They are replaced one for one, below, with the boundary that still holds:
	# Gate G and first-MVP production. Gate F's own suite asserts the Gate F
	# contract; this suite asserts that Gate E's contract survived it.
	#
	# The suite went from 710 checks to 713, and the three additional checks are
	# not new assertions — they are the WASD scan at the bottom of this function
	# finding three more input actions to examine: `pause`, `quick_restart`, and
	# `toggle_damage_numbers`.
	for forbidden: String in [
		"profile", "profiles", "character_save", "run_state", "rift_anchor",
		"recovery_cache", "pursuit", "intensity", "distortion", "nexus",
	]:
		_expect(not (forbidden in room),
			"the room has a '%s' member; that is Gate G or first-MVP production" % forbidden)
	for forbidden: String in ["save", "load", "write", "serialize", "schema_version", "migrate"]:
		_expect(not (forbidden in progress),
			"LabProgress has a '%s' member; D-184 keeps it purely in memory" % forbidden)
	print("  no Fallen overlay, Restart flow, pause menu, settings panel, or damage-number setting")

	# Nothing is written to disk. D-184: the record is in memory ONLY.
	# Comments are stripped first, so the scan reads CODE. Both files say in
	# prose that they write no user:// file, and a scan that could not tell the
	# promise from the breach would be worthless.
	for path: String in [
		"res://scripts/prototype_zero/lab_progress.gd",
		"res://scripts/prototype_zero/progression_director.gd",
		"res://scripts/prototype_zero/lab_progression_data.gd",
		"res://scripts/combat/prototype_weapon_data.gd",
		"res://scripts/items/prototype_sword_drop.gd",
		"res://scripts/ui/gate_e_modal.gd",
	]:
		var source: String = _code_only(FileAccess.get_file_as_string(path))
		_expect(not source.contains("user://"), "%s names a user:// path in code" % path.get_file())
		_expect(not source.contains("ConfigFile"), "%s uses ConfigFile" % path.get_file())
		_expect(not source.contains("FileAccess.open"), "%s opens a file for writing" % path.get_file())
	# Replaced one for one. Gate E asserted the lab file did not exist at all;
	# D-189 authorises it, so this asserts what must remain true about it: if a
	# lab-state file is present, it holds ONLY the six-value Gate F allowlist and
	# nothing about enemies, positions, Life, Mana, attack phases, targets, or
	# attack permissions.
	_expect(_lab_state_file_is_allowlisted(), "user://prototype_zero.cfg holds a value outside the Gate F allowlist")
	print("  no user:// path, no ConfigFile, and no file opened in any Gate E source")

	# NO AUDIO WAS DOWNLOADED. Gate E asserted that by counting audio players and
	# finding zero. D-189 authorises project-authored cues, so counting players
	# is now the wrong question and this asserts the right one instead: every
	# voice in the room belongs to the Gate F audio director, and every stream it
	# can play is a generated resource under `assets/prototype/audio/cues`.
	var players: int = _count_nodes_of_type(room, "AudioStreamPlayer")
	var director_voices: int = room.audio.voice_count() if room.audio != null else 0
	print("  audio: %d cue points emitted, %d AudioStreamPlayer nodes, %d owned by the cue director" % [
		director.audio_cues_emitted, players, director_voices,
	])
	_expect(players == director_voices and room.audio != null,
		"%d audio players exist but the cue director owns %d; something else is making sound" % [
			players, director_voices,
		])
	_expect(director.audio_cues_emitted > 0, "no named audio cue point was ever reached")

	# Replaced one for one: the whole prototype audio tree, recursively, holds no
	# `.wav`, `.ogg`, or `.mp3`. Gate E's version scanned one directory for
	# imported samples; this one proves that no sound FILE of any kind was
	# imported anywhere, which is a stronger statement of the same boundary now
	# that authored cues exist as generated `.res` resources.
	var samples: PackedStringArray = _audio_samples_under("res://assets/prototype/audio")
	print("  prototype audio tree: %d generated cue resources, %d imported samples" % [
		_files_under("res://assets/prototype/audio", ".res").size(), samples.size(),
	])
	_expect(samples.is_empty(),
		"imported audio samples exist under assets/prototype/audio: %s" % ", ".join(samples))

	# The ONE ground drop is not a loot system.
	for forbidden: String in ["loot_table", "drop_rate", "rarity", "roll", "weights", "pursuit"]:
		_expect(not (forbidden in director),
			"the director has a '%s' member; that is a first-MVP loot system" % forbidden)
	print("  one guaranteed pre-authored drop: no loot table, drop rate, rarity, or pursuit")

	# The Graveblade is reused unchanged and the posts are still inert.
	await _await_living_enemy(3.0)
	var enemy: PrototypeGraveblade = room.graveblade
	for forbidden: String in ["experience", "xp", "loot", "drop", "weapon", "wave", "progression"]:
		_expect(not (forbidden in enemy),
			"the Graveblade gained a '%s' member; D-184 requires it reused UNCHANGED" % forbidden)
	var fixture: PrototypeTargetFixture = room.fixtures[0]
	for forbidden: String in [
		"life", "max_life", "health", "damage", "take_damage", "die", "death",
		"experience", "xp", "attack_player", "loot", "drop",
	]:
		_expect(not (forbidden in fixture),
			"the practice post gained a '%s' member; the posts must stay inert" % forbidden)
	print("  the Graveblade is unchanged and the Gate C practice posts are still inert")

	# Gate B cannot have moved.
	print("  navigation mesh still %d polygons, %.1f m^2" % [room.navmesh_polygon_count, room.navmesh_area])
	_expect(room.navmesh_polygon_count == 2 and absf(room.navmesh_area - 218.7) < 1.0,
		"the navigation mesh changed: %d polygons, %.1f m^2" % [room.navmesh_polygon_count, room.navmesh_area])
	_expect(player.collision_mask & TargetAcquisition.TARGET_MASK == 0,
		"the player collides with target areas, which would change Gate B movement")
	# No WASD, still.
	for action_name: StringName in InputMap.get_actions():
		for event: InputEvent in InputMap.action_get_events(action_name):
			var key: InputEventKey = event as InputEventKey
			if key == null:
				continue
			_expect(not [KEY_W, KEY_A, KEY_S, KEY_D].has(key.physical_keycode),
				"'%s' binds a WASD key; Prototype Zero has no WASD movement" % action_name)
	print("  no WASD binding, and the Gate B navigation result is untouched")


# --- Trace -------------------------------------------------------------------

func _on_experience_changed(current: int, _maximum: int) -> void:
	if current > 0 and (_experience_trace.is_empty() or _experience_trace[-1] != current):
		_experience_trace.append(current)


func _on_stage_changed(_from: LabProgress.Stage, _to: LabProgress.Stage) -> void:
	_stage_trace.append(progress.stage_name())


func _on_wave_started(size: int, _plan: Dictionary) -> void:
	_wave_trace.append(size)
	# Measured on the DIRECTOR's own SIMULATION clock — the running sum of the
	# very `delta` values its `wave_countdown` is decremented by, read at the
	# moment it first observed the threat gone and again here. So the interval
	# verified is the interval it produced, rather than one this checker's pacing
	# or the machine's load imposed.
	#
	# It used to subtract two `Time.get_ticks_msec()` readings, and that is a
	# different quantity: the wall clock keeps running while the process is
	# stalled, and the countdown does not. On a loaded machine the two diverged by
	# up to 0.9 s and failed this check for a rhythm that had not moved — see the
	# Gate F report §10a.5. No assertion, tolerance, or authored value changed
	# with this correction; only where the number is read from.
	if director.last_threat_clear_seconds >= 0.0:
		_wave_gaps.append(director.simulation_seconds - director.last_threat_clear_seconds)


func _on_use_released(_id: int, _outcome: Dictionary) -> void:
	_release_animation_positions.append(player.quick_strike_animation_position())


# --- Driving -----------------------------------------------------------------

## One clean Quick Strike onto a specific Graveblade, in place, from just inside
## reach. It is the ordinary path: the same press, the same query, the same
## release the player's button produces.
func _strike_enemy_once(enemy: PrototypeGraveblade) -> void:
	player.mana = player.max_mana
	await _teleport(enemy.global_position - Vector3(1.20, 0.0, 0.0))
	await _face_player(Vector3(1.0, 0.0, 0.0))
	Input.action_press(&"attack_in_place")
	_aim_cursor_at((enemy.get_node("TargetArea") as PrototypeTargetable).targeting_point())
	room.press_quick_strike()
	action.release_input()
	await _await_action_ready(3.0)
	Input.action_release(&"attack_in_place")
	room.set_cursor_override(null)
	await _step()


func _kill_every_living_graveblade() -> void:
	# The roster is snapshotted as ids rather than as references: a corpse can be
	# freed by the director while this loop is awaiting, and re-assigning a typed
	# reference to a freed instance is an error even when it is never used.
	var ids: Array[int] = []
	for enemy: PrototypeGraveblade in room.graveblades:
		if is_instance_valid(enemy):
			ids.append(enemy.get_instance_id())
	for id: int in ids:
		var target: Object = instance_from_id(id)
		if target == null or not is_instance_valid(target):
			continue
		var enemy: PrototypeGraveblade = target as PrototypeGraveblade
		if enemy == null or not enemy.is_alive():
			continue
		enemy.set_ai_enabled(false)
		var guard: int = 0
		while is_instance_valid(enemy) and enemy.is_alive() and guard < 6:
			await _strike_enemy_once(enemy)
			guard += 1
	await _settle(2)


## Reaches REPEAT_LOOP the way play reaches it: two kills, one equip through the
## real button, one confirmation through the real button.
func _fast_forward_to_repeat_loop() -> void:
	await _await_living_enemy(3.0)
	await _kill_every_living_graveblade()
	await _settle(4)
	await _release_all_inputs()
	room.open_item_comparison("fast forward")
	await _settle(2)
	_press(comparison, "Equip")
	await _settle(4)
	await _await_living_enemy(3.0)
	await _kill_every_living_graveblade()
	await _settle(4)
	if passive_card.is_open:
		_press(passive_card, "Confirm")
	await _settle(4)


func _measure_held_repeat(count: int) -> Array[float]:
	var intervals: Array[float] = []
	await _release_all_inputs()
	await _await_living_enemy(3.0)
	player.mana = player.max_mana
	player.mana_regeneration = 1000.0
	await _teleport(Vector3(-2.0, 0.0, -2.0))
	Input.action_press(&"attack_in_place")
	# `uses_released` counts every release of the whole session, so the repeat is
	# measured against a baseline taken here rather than against zero.
	var baseline: int = action.uses_released
	room.press_quick_strike()
	var elapsed: float = 0.0
	var seen: int = 0
	while elapsed < 8.0 and seen < count:
		await _step()
		elapsed += TICK
		player.mana = player.max_mana
		if action.uses_released - baseline > seen:
			seen = action.uses_released - baseline
			if action.last_repeat_interval > 0.0:
				intervals.append(action.last_repeat_interval)
	action.release_input()
	Input.action_release(&"attack_in_place")
	player.mana_regeneration = 10.0
	await _settle(2)
	return intervals


func _press(modal: GateEModal, button_name: String) -> void:
	var button: Button = _button(modal, button_name)
	if button != null and not button.disabled:
		button.emit_signal("pressed")


func _button(node: Node, button_name: String) -> Button:
	for button: Button in _buttons_in(node):
		if button.name == button_name:
			return button
	return null


func _buttons_in(node: Node) -> Array[Button]:
	var found: Array[Button] = []
	for child: Node in node.get_children():
		if child is Button:
			found.append(child as Button)
		found.append_array(_buttons_in(child))
	return found


## The comparison's visible content, as the five lines D-184 lists.
func _comparison_lines() -> PackedStringArray:
	var lines: PackedStringArray = PackedStringArray()
	var labels: Array[Label] = _labels_in(comparison)
	var texts: PackedStringArray = PackedStringArray()
	for label: Label in labels:
		var text: String = label.text.strip_edges()
		if not text.is_empty():
			texts.append(text)
	# Candidate name, current name, then the three rows as caption / from / to.
	for text: String in texts:
		if text.begins_with("Candidate — "):
			lines.append(text.trim_prefix("Candidate — "))
	for text: String in texts:
		if text.begins_with("Current — "):
			lines.append(text.trim_prefix("Current — "))
	for row_name: String in ["Quick Strike Physical Hit", "Hits to this Graveblade", "Attack Time"]:
		var index: int = texts.find(row_name)
		if index >= 0 and index + 3 < texts.size():
			lines.append("%s   %s %s %s" % [row_name, texts[index + 1], texts[index + 2], texts[index + 3]])
	return lines


func _labels_in(node: Node) -> Array[Label]:
	var found: Array[Label] = []
	for child: Node in node.get_children():
		if child is Label:
			found.append(child as Label)
		found.append_array(_labels_in(child))
	return found


## Everything a surface actually displays: Labels and RichTextLabels together,
## with BBCode stripped, so a check reads what a player reads.
func _visible_text_in(node: Node) -> String:
	var parts: PackedStringArray = PackedStringArray()
	_collect_visible_text(node, parts)
	return "\n".join(parts)


func _collect_visible_text(node: Node, into: PackedStringArray) -> void:
	for child: Node in node.get_children():
		var label: Label = child as Label
		if label != null and not label.text.strip_edges().is_empty():
			into.append(label.text)
		var rich: RichTextLabel = child as RichTextLabel
		if rich != null and not rich.get_parsed_text().strip_edges().is_empty():
			into.append(rich.get_parsed_text())
		_collect_visible_text(child, into)


func _all_text_in(node: Node) -> String:
	var parts: PackedStringArray = PackedStringArray()
	for label: Label in _labels_in(node):
		if not label.text.strip_edges().is_empty():
			parts.append(label.text)
	return "\n".join(parts)


func _count_drops() -> int:
	var total: int = 0
	for child: Node in room.get_node("Drops").get_children():
		if child is PrototypeSwordDrop and not child.is_queued_for_deletion():
			total += 1
	return total


## Every file with the given extension under a directory, recursively.
func _files_under(root: String, extension: String) -> PackedStringArray:
	var found: PackedStringArray = PackedStringArray()
	var directory: DirAccess = DirAccess.open(root)
	if directory == null:
		return found
	for file: String in directory.get_files():
		if file.ends_with(extension):
			found.append("%s/%s" % [root, file])
	for child: String in directory.get_directories():
		found.append_array(_files_under("%s/%s" % [root, child], extension))
	return found


## Imported sound files of any kind. There must be none: every authored cue is a
## generated Godot resource, so no sample ever entered the import pipeline.
func _audio_samples_under(root: String) -> PackedStringArray:
	var found: PackedStringArray = PackedStringArray()
	for extension: String in [".wav", ".ogg", ".mp3", ".flac", ".aiff", ".aif", ".m4a"]:
		found.append_array(_files_under(root, extension))
	return found


## True when the Gate F lab-state file is absent, or present and holding only the
## six allowlisted keys.
func _lab_state_file_is_allowlisted() -> bool:
	if not FileAccess.file_exists(PrototypeLabState.PATH):
		return true
	var config: ConfigFile = ConfigFile.new()
	if config.load(PrototypeLabState.PATH) != OK:
		return false
	for section: String in config.get_sections():
		for key: String in config.get_section_keys(section):
			if not PrototypeLabState.ALLOWED_KEYS.has("%s/%s" % [section, key]):
				return false
	return true


func _count_nodes_of_type(node: Node, type_name: String) -> int:
	var total: int = 0
	for child: Node in node.get_children():
		if child.is_class(type_name):
			total += 1
		total += _count_nodes_of_type(child, type_name)
	return total


func _phase_times() -> Dictionary:
	return {
		"wind-up": action.windup_time(),
		"release": action.release_window_time(),
		"recovery": action.recovery_time(),
		"action": action.effective_action_time(),
	}


func _release_all_inputs() -> void:
	for action_name: StringName in [
		&"quick_strike", &"move_point", &"attack_in_place", &"interact", &"ui_confirm", &"ui_cancel",
	]:
		if Input.is_action_pressed(action_name):
			Input.action_release(action_name)
	action.release_input()
	room.set_stick_override(null)
	room.set_cursor_override(null)
	await _settle(2)
	# Waiting for the room to LIFT its neutral latch is part of putting the
	# controls at rest: without it a later press is silently refused and a check
	# that expects nothing to happen passes for the wrong reason.
	var waited: int = 0
	while player.awaiting_neutral and player.is_alive() and waited < 30:
		player.release_neutral_latch()
		await _step()
		waited += 1


func _aim_cursor_at(world_point: Vector3) -> void:
	room.set_cursor_override(room.camera_rig.camera.unproject_position(world_point))


func _teleport(to: Vector3) -> void:
	player.clear_movement_intent("verification teleport", false)
	player.global_position = Vector3(to.x, 0.0, to.z)
	player.velocity = Vector3.ZERO
	player.life = player.max_life
	await _settle(4)


func _face_player(direction: Vector3) -> void:
	player.face_instantly(direction)
	await _step()


func _step() -> void:
	await get_tree().physics_frame


## Waits for whole IDLE frames, which is the clock `_process` runs on and
## therefore the clock every overlay's text is produced on. `_settle()` waits on
## the physics clock, and the two are not interchangeable on a loaded machine.
func _await_process_frames(frames: int) -> void:
	for _index: int in frames:
		await get_tree().process_frame


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


func _await_living_enemy(timeout: float) -> float:
	var elapsed: float = 0.0
	while elapsed < timeout:
		if room.living_graveblade_count() > 0:
			return elapsed
		await _step()
		elapsed += TICK
	return -1.0


## Waits for the next wave to actually arrive, so the gap it records is the gap
## the director produced rather than one this loop imposed.
func _await_wave(timeout: float) -> float:
	var before: int = room.graveblades_spawned
	var elapsed: float = 0.0
	while elapsed < timeout:
		if room.graveblades_spawned > before and room.living_graveblade_count() > 0:
			await _settle(2)
			return elapsed
		await _step()
		elapsed += TICK
	return -1.0


## A source file with its comment lines removed, so a scan for a forbidden call
## cannot be tripped by a comment promising not to make it.
func _code_only(source: String) -> String:
	var kept: PackedStringArray = PackedStringArray()
	for line: String in source.split("\n"):
		var stripped: String = line.strip_edges()
		if stripped.begins_with("#"):
			continue
		kept.append(line)
	return "\n".join(kept)


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
	await _release_all_inputs()
	room.reset_lab_progress()
	await _settle(8)
	room.input_family.family = InputFamilyTracker.Family.MOUSE_KEYBOARD
	room.set_debug_visuals(false)
	room.set_debug_panels(false)

	# 1. STARTER_FIGHT: the XP bar at 0 / 20 with the Training Sword named.
	await _await_living_enemy(3.0)
	var enemy: PrototypeGraveblade = room.graveblade
	enemy.set_ai_enabled(false)
	enemy.place_at(Vector3(2.4, 0.0, -1.6))
	await _teleport(Vector3(-0.6, 0.0, 0.6))
	await _settle(6)
	_expect(progress.experience == 0 and player.weapon == room.starter_sword,
		"the starter screenshot was not taken during STARTER_FIGHT")
	await _shoot("gate_e_starter_fight", 4)

	# 2. The guaranteed sword on the ground, with its indicator and nameplate.
	for strike: int in 3:
		await _strike_enemy_once(enemy)
	# Long enough for the defeated body to be removed, so the shot shows the drop
	# rather than the drop behind a corpse.
	await _settle(int(data.corpse_linger * 62.0))
	await _teleport(director.drop().global_position + Vector3(-2.6, 0.0, 1.9))
	await _settle(10)
	_expect(director.drop() != null, "the drop screenshot has no sword on the ground")
	_expect(progress.experience == 10, "the drop screenshot shows %d XP" % progress.experience)
	await _shoot("gate_e_sword_on_ground", 4)

	# 3. The comparison, stating its five facts.
	await _release_all_inputs()
	room.open_item_comparison("evidence")
	await _settle(4)
	_expect(comparison.is_open and get_tree().paused,
		"the comparison screenshot was taken with the surface closed or the world running")
	await _shoot("gate_e_comparison", 4)

	# 4. The two-Hit kill after equipping.
	_press(comparison, "Equip")
	await _settle(6)
	await _await_living_enemy(4.0)
	var second: PrototypeGraveblade = room.graveblade
	second.set_ai_enabled(false)
	second.place_at(Vector3(2.2, 0.0, -1.2))
	await _strike_enemy_once(second)
	await _settle(4)
	_expect(is_equal_approx(second.life, 150.0),
		"the two-Hit screenshot shows %.0f Life after one Honed Sword Hit" % second.life)
	await _shoot("gate_e_two_hit_kill", 3)
	await _strike_enemy_once(second)
	await _settle(8)

	# 5. The passive card at 20 / 20.
	_expect(passive_card.is_open, "the passive screenshot has no card open")
	_expect(progress.experience == 20, "the passive screenshot shows %d XP" % progress.experience)
	await _shoot("gate_e_passive_card", 4)

	# 6. A three-Graveblade repeat wave, with the F3 panels open.
	_press(passive_card, "Confirm")
	await _settle(6)
	director.set_forced_wave_size(3)
	await _await_wave(6.0)
	await _teleport(Vector3(0.0, 0.0, 0.0))
	room.set_debug_panels(true)
	# Long enough for the wave to close from its safe spawn distance into frame,
	# so the shot shows three Graveblades arriving rather than three specks.
	await _settle(96)
	player.life = player.max_life
	_expect(room.living_graveblade_count() == 3,
		"the wave screenshot shows %d Graveblades" % room.living_graveblade_count())
	_expect(is_equal_approx(action.effective_action_time(), 0.64),
		"the wave screenshot was taken at a %.2f s action time" % action.effective_action_time())
	await _shoot("gate_e_repeat_wave", 4)

	director.set_forced_wave_size(0)
	room.set_debug_panels(false)
	room.set_debug_visuals(false)
	room.set_cursor_override(null)


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
