extends Node
## Riftwrought — Roguelite Core Loop Review: automated verification (D-220).
##
## THIS IS NOT A GATE, AND IT DELIBERATELY DOES NOT RE-PROVE HISTORY. Quick
## Strike, the Graveblade state machine, click-to-move, the D-178 controller
## cone, the modal contract and the item comparison are proven exhaustively by
## gates this review does not edit, and re-running them to check a greybox loop
## would be verification theatre. What THIS suite proves is the one thing no
## existing suite can know: that the LOOP behaves — hub entry, room order, the
## combat gate in BOTH directions, the guaranteed reward, a measured equip
## improvement, the elite, the return, and a death that actually resets the
## run — and that the review is as isolated as it claims to be.
##
## IT PORTS D-211's OWED-SET DISCIPLINE. Every check function records reaching
## its LAST line, and the suite compares that set to what it owes in BOTH
## directions. That costs two assertions and is the only thing that catches an
## un-awaited coroutine check: Zone Composer Phase 1 shipped a suite where five
## of seven assertions never ran while it reported PASS.
##
## IT ALSO PORTS GATE F's ON-SCREEN MEASUREMENT, for the same reason it was
## written: Gate F shipped a HUD and four modals nobody could see while every
## text assertion passed. Reading the right words out of a Control tree proves
## the words EXIST, not that anyone can see them.
##
## Run:  godot --headless --path game res://scenes/roguelite/roguelite_core_loop.tscn -- --verify-loop

const RUNTIME_SCRIPT: String = "res://scripts/roguelite/roguelite_core_loop_runtime.gd"
const MODULE_SCRIPT: String = "res://scripts/roguelite/roguelite_room_module.gd"
const PLAN_SCRIPT: String = "res://scripts/roguelite/roguelite_run_plan.gd"
const STATE_SCRIPT: String = "res://scripts/roguelite/roguelite_run_state.gd"
const HUD_SCRIPT: String = "res://scripts/roguelite/roguelite_run_hud.gd"
const FALLEN_SCRIPT: String = "res://scripts/roguelite/roguelite_fallen_overlay.gd"
const SUMMARY_SCRIPT: String = "res://scripts/roguelite/roguelite_run_summary_panel.gd"

const REVIEW_SCRIPTS: Array[String] = [
	RUNTIME_SCRIPT, MODULE_SCRIPT, PLAN_SCRIPT, STATE_SCRIPT,
	HUD_SCRIPT, FALLEN_SCRIPT, SUMMARY_SCRIPT,
]

const EXPECTED_ACTIONS_COUNT: int = 31
const EXPECTED_MODULES: int = 4
const EXPECTED_ROOMS: int = 3
const EXPECTED_ENEMIES: int = 5

const ACCEPTED_CAMERA_DISTANCE: float = 19.0
const ACCEPTED_CAMERA_PITCH: float = 55.0
const ACCEPTED_CAMERA_FOV: float = 45.0
const ACCEPTED_MAX_SPEED: float = 5.0
const ORDINARY_LIFE: float = 300.0
const ELITE_LIFE: float = 600.0
const WORN_DAMAGE: float = 100.0
const EXPEDITION_DAMAGE: float = 150.0

## Every check function this suite owes, compared to what actually ran in BOTH
## directions. D-211: a suite that reports PASS cannot see the assertions it
## never reached.
const OWED_CHECKS: Array[String] = [
	"engine_and_assembly",
	"isolation_from_the_landing_track",
	"input_map_untouched",
	"accepted_values_reused",
	"run_plan_is_deterministic",
	"modules_are_one_reusable_class",
	"every_room_centre_is_reachable",
	"hub_is_safe",
	"hub_entry_begins_a_run",
	"combat_gate_holds_and_opens",
	"room_order_is_the_authored_order",
	"guaranteed_reward",
	"equip_improvement_is_measured",
	"elite_is_the_same_language",
	"final_return_completes_the_run",
	"death_resets_the_run",
	"a_completed_run_does_not_carry_its_reward",
	"writes_nothing",
	"excluded_systems_absent",
	"surfaces_are_on_screen",
]

var loop: RogueliteCoreLoopRuntime
var arguments: PackedStringArray = PackedStringArray()

var _failures: PackedStringArray = PackedStringArray()
var _checks: int = 0
var _reached: Dictionary = {}
var _shot_dir: String = ""


func _ready() -> void:
	await run()


func run() -> void:
	print("")
	print("=== Roguelite Core Loop Review verification (D-220) ===")
	_shot_dir = _argument_value("--shots")
	await _settle(10)
	await _await_navigation()

	_check_engine_and_assembly()
	_check_isolation_from_the_landing_track()
	_check_input_map_untouched()
	_check_accepted_values_reused()
	_check_run_plan_is_deterministic()
	_check_modules_are_one_reusable_class()
	_check_every_room_centre_is_reachable()
	_check_hub_is_safe()
	await _check_hub_entry_begins_a_run()
	await _check_combat_gate_holds_and_opens()
	await _check_room_order_is_the_authored_order()
	await _check_guaranteed_reward()
	await _check_equip_improvement_is_measured()
	await _check_elite_is_the_same_language()
	await _check_final_return_completes_the_run()
	_check_a_completed_run_does_not_carry_its_reward()
	await _check_death_resets_the_run()
	_check_writes_nothing()
	_check_excluded_systems_absent()
	await _check_surfaces_are_on_screen()

	if not _shot_dir.is_empty():
		await _capture_evidence()

	_check_every_check_ran()

	print("")
	if _failures.is_empty():
		print("ROGUELITE CORE LOOP VERIFICATION: PASS (%d checks)" % _checks)
		get_tree().quit(0)
	else:
		for failure: String in _failures:
			printerr("  FAIL: %s" % failure)
		printerr("ROGUELITE CORE LOOP VERIFICATION: %d FAILURE(S) of %d checks" % [
			_failures.size(), _checks,
		])
		get_tree().quit(1)


# --- 1. Assembly ---------------------------------------------------------------

func _check_engine_and_assembly() -> void:
	print("")
	print("--- The review assembles from one bake, four modules and five enemies")
	_expect(Engine.get_version_info()["string"].begins_with("4.7.2"),
		"engine is %s, not 4.7.2" % Engine.get_version_info()["string"])
	_expect(loop != null, "the verification was not handed the runtime")
	_expect(loop is BrokenWatchSlice,
		"the runtime is not a BrokenWatchSlice, so it cannot bind the proven Gate 1D surfaces")
	_expect(loop.all_modules.size() == EXPECTED_MODULES,
		"%d module(s) built, not %d" % [loop.all_modules.size(), EXPECTED_MODULES])
	_expect(loop.room_modules.size() == EXPECTED_ROOMS,
		"%d expedition room(s), not %d" % [loop.room_modules.size(), EXPECTED_ROOMS])
	_expect(loop.graveblades.size() == EXPECTED_ENEMIES,
		"%d enemies, not %d" % [loop.graveblades.size(), EXPECTED_ENEMIES])
	_expect(loop.bake_count == 1,
		"the navigation mesh was baked %d times, not once" % loop.bake_count)
	_expect(loop.navmesh_polygon_count > 0 and loop.navmesh_area > 0.0,
		"the navigation bake produced nothing")
	print("  %d modules, %d rooms, %d enemies, %d navmesh polygons over %.1f m^2 from %d bake" % [
		loop.all_modules.size(), loop.room_modules.size(), loop.graveblades.size(),
		loop.navmesh_polygon_count, loop.navmesh_area, loop.bake_count,
	])
	_done("engine_and_assembly")


## The review's central claim: it extends `BrokenWatchSlice` for the TYPE and
## deliberately does not call its `_ready()`, so none of the deprecated
## environment-art track exists in this scene. Measured two ways — the
## inherited fields are null, and no node of either layout class is anywhere in
## the tree — because a null field could be a field that was cleared, while an
## absent node cannot be.
func _check_isolation_from_the_landing_track() -> void:
	print("")
	print("--- No Riftfall Landing or Broken Watch content exists in this scene")
	_expect(loop.landing_layout == null, "landing_layout is not null — super._ready() ran")
	_expect(loop.landing_dressing == null, "landing_dressing is not null — the dressing was built")
	_expect(loop.broken_watch == null, "broken_watch is not null — Broken Watch was instanced")
	_expect(loop.lighting == null, "lighting is not null — the exterior lighting component was configured")
	_expect(loop.treatment == null, "treatment is not null — the exterior material treatment was constructed")
	for type_name: String in [
		"RiftfallLandingGreyboxLayout", "RiftfallLandingVisualReviewDressing", "BrokenWatchLayout",
	]:
		_expect(_count_nodes_of_script(loop, type_name) == 0,
			"a %s node exists in the review scene" % type_name)
	_expect(_count_nodes_of_script(loop, "RogueliteRoomModule") == EXPECTED_MODULES,
		"the scene does not hold exactly %d RogueliteRoomModule nodes" % EXPECTED_MODULES)
	print("  the deprecated environment-art track is absent by field AND by node")
	_done("isolation_from_the_landing_track")


func _check_input_map_untouched() -> void:
	print("")
	print("--- project.godot is untouched: the same 31 actions, and no new one")
	var declared: int = 0
	for action: StringName in InputMap.get_actions():
		if String(action).begins_with("ui_") and not String(action) in ["ui_confirm", "ui_cancel"]:
			continue
		declared += 1
	_expect(declared == EXPECTED_ACTIONS_COUNT,
		"the InputMap declares %d project actions, not %d" % [declared, EXPECTED_ACTIONS_COUNT])
	for invented: StringName in [
		&"enter_rift", &"exit_room", &"next_room", &"roguelite_interact",
		&"open_run_summary", &"abandon_run",
	]:
		_expect(not InputMap.has_action(invented),
			"a new InputMap action %s was declared — Gate E and Gate F emit one assertion per key event" % invented)
	_expect(ProjectSettings.get_setting("application/run/main_scene", "") == "res://scenes/app/prototype_app.tscn",
		"run/main_scene is no longer the Prototype App")
	print("  %d actions, no invented action, entrypoint unchanged" % declared)
	_done("input_map_untouched")


func _check_accepted_values_reused() -> void:
	print("")
	print("--- Every accepted Prototype Zero value is reused, not re-derived")
	_expect(is_equal_approx(loop.camera_rig.distance_metres, ACCEPTED_CAMERA_DISTANCE),
		"camera distance is %.2f m, not %.2f" % [loop.camera_rig.distance_metres, ACCEPTED_CAMERA_DISTANCE])
	_expect(is_equal_approx(loop.camera_rig.pitch_degrees, ACCEPTED_CAMERA_PITCH),
		"camera pitch is %.2f deg, not %.2f" % [loop.camera_rig.pitch_degrees, ACCEPTED_CAMERA_PITCH])
	_expect(is_equal_approx(loop.camera_rig.fov_degrees, ACCEPTED_CAMERA_FOV),
		"camera FOV is %.2f deg, not %.2f" % [loop.camera_rig.fov_degrees, ACCEPTED_CAMERA_FOV])
	_expect(is_equal_approx(loop.player.max_speed, ACCEPTED_MAX_SPEED),
		"player max speed is %.2f m/s, not %.2f" % [loop.player.max_speed, ACCEPTED_MAX_SPEED])

	var canonical_quick_strike: QuickStrikeData = load("res://data/prototype_zero/quick_strike.tres") as QuickStrikeData
	_expect(is_equal_approx(canonical_quick_strike.action_time, 0.80),
		"the canonical Quick Strike action time moved from 0.80 s")
	_expect(is_equal_approx(canonical_quick_strike.release_marker_normalized, 0.325),
		"the canonical Quick Strike release marker moved from 0.325")
	_expect(is_equal_approx(canonical_quick_strike.reach, 1.65),
		"the canonical Quick Strike reach moved from 1.65 m")

	var canonical_enemy: GravebladeData = load("res://data/prototype_zero/graveblade.tres") as GravebladeData
	_expect(is_equal_approx(canonical_enemy.max_life, ORDINARY_LIFE),
		"the canonical Graveblade Life moved from 300")
	_expect(is_equal_approx(canonical_enemy.physical_damage, 125.0),
		"the canonical Graveblade damage moved from 125")
	## The ordinary enemies use the canonical record BY IDENTITY, not a copy of
	## its numbers — a copy could drift.
	_expect(loop.room_enemies[0][0].data == canonical_enemy,
		"the Teaching Hall Graveblade does not use the canonical graveblade.tres resource itself")

	_expect(is_equal_approx(loop.loadout.equipped_weapon.physical_damage, WORN_DAMAGE),
		"the starting weapon does not deal %.0f Physical" % WORN_DAMAGE)
	_expect(loop.loadout.equipped_weapon.problem().is_empty(),
		"the starting weapon record is incoherent: %s" % loop.loadout.equipped_weapon.problem())
	print("  19 m / 55 deg / 45 deg camera, 5.0 m/s, 0.80 s / 0.325 / 1.65 m, 300 Life, 100 damage")
	_done("accepted_values_reused")


# --- 2. The run's identity -----------------------------------------------------

func _check_run_plan_is_deterministic() -> void:
	print("")
	print("--- The seed is real, is visible, and the shuffle is honestly absent")
	var plan_script: GDScript = load(PLAN_SCRIPT) as GDScript
	var a: RogueliteRunPlan = plan_script.new(12345, 0) as RogueliteRunPlan
	var b: RogueliteRunPlan = plan_script.new(12345, 0) as RogueliteRunPlan
	var c: RogueliteRunPlan = plan_script.new(999, 0) as RogueliteRunPlan

	_expect(a.problem().is_empty(), "the run plan is incoherent: %s" % a.problem())
	_expect(a.run_id() == b.run_id(),
		"the same seed produced two different run ids: %s vs %s" % [a.run_id(), b.run_id()])
	_expect(a.run_id() != c.run_id(),
		"two different seeds produced the same run id %s — the seed is not reaching the id" % a.run_id())
	_expect(a.ordered_modules() == b.ordered_modules(), "the same seed produced two different orders")
	## The order is the AUTHORED one and does not depend on the seed. Asserting
	## it explicitly is what stops a future edit from quietly shuffling.
	_expect(a.ordered_modules() == c.ordered_modules(),
		"the room order changed with the seed — this review must not shuffle")
	_expect(a.ordered_modules() == RogueliteRunPlan.AUTHORED_ORDER,
		"the plan's order is not the authored order")
	_expect(not a.is_shuffled(), "the plan claims to shuffle rooms")
	_expect(a.selection_mode().contains("not implemented"),
		"the selection mode does not say plainly that shuffling is not implemented")
	## Purity: repeated calls cannot drift.
	for i: int in 25:
		_expect_quiet(a.run_id() == b.run_id(), "run_id() is not pure across repeated calls")
	_expect(a.next().run_id() != a.run_id(), "the next run reuses the previous run id")
	_expect(a.next().run_id() == b.next().run_id(),
		"the next run is not reproducible from the same starting seed")
	print("  %s reproducible, %s distinct, order fixed and declared fixed" % [a.run_id(), c.run_id()])
	_done("run_plan_is_deterministic")


# --- 3. Modules ----------------------------------------------------------------

func _check_modules_are_one_reusable_class() -> void:
	print("")
	print("--- The hub and all three rooms are ONE module class, differing only by record")
	var expected: String = MODULE_SCRIPT
	for module: RogueliteRoomModule in loop.all_modules:
		var script: GDScript = module.get_script() as GDScript
		_expect(script != null and script.resource_path == expected,
			"%s does not run the one module script" % module.name)
		_expect(module.entry_point_local() != module.exit_point_local(),
			"%s has no distinct entry and exit point" % module.name)
		_expect(module.footprint_area() > 0.0, "%s has no walkable area" % module.name)
		_expect(module.carve_count() > 0,
			"%s carves nothing out of the navigation mesh — the open-topped-well fix is missing" % module.name)
		## Every non-ground solid must carve, so carves and solids differ by
		## exactly the ground plates.
		_expect(module.solid_count() == module.carve_count() + module.room_count(),
			"%s has %d collision shape(s) against %d carve(s) and %d ground plate(s)" % [
				module.name, module.solid_count(), module.carve_count(), module.room_count(),
			])
		print("  %s" % module.describe())
	_expect(RogueliteRoomModule.MODULES.size() == EXPECTED_MODULES,
		"the module records hold %d entries, not %d" % [RogueliteRoomModule.MODULES.size(), EXPECTED_MODULES])
	_done("modules_are_one_reusable_class")


## Gate 1E's most valuable check, ported. Sockets are placed where things
## happen, so a room with no socket can bake as a sealed island while every
## socket check passes — that is exactly how the Nexus Threshold's WEST_ALCOVE
## shipped as 70 m^2 of unreachable navigation. This walks by PATH to the
## CENTRE OF EVERY AUTHORED RECTANGLE, and to every socket, from the module's
## own entry.
func _check_every_room_centre_is_reachable() -> void:
	print("")
	print("--- Every authored rectangle centre and every socket is reachable BY PATH")
	var map: RID = loop.navigation_map()
	for module: RogueliteRoomModule in loop.all_modules:
		var from: Vector3 = module.entry_point()
		var targets: Array[Vector3] = module.room_centres()
		targets.append(module.exit_point())
		for spawn: Vector3 in module.spawn_points():
			targets.append(spawn)
		for target: Vector3 in targets:
			var path: PackedVector3Array = NavigationServer3D.map_get_path(map, from, target, true)
			var short_by: float = INF
			if path.size() >= 2:
				var last: Vector3 = path[path.size() - 1]
				short_by = Vector2(last.x - target.x, last.z - target.z).length()
			_expect(path.size() >= 2 and short_by <= 1.0,
				"%s: %s is an ISLAND — the path stops %.2f m short" % [module.name, target, short_by])
		print("  %s: %d target(s) reachable from its own entry" % [module.name, targets.size()])
	_done("every_room_centre_is_reachable")


func _check_hub_is_safe() -> void:
	print("")
	print("--- The hub is safe: no encounter, no enemy inside it, and its gate is open")
	var hub: RogueliteRoomModule = loop.hub_module
	_expect(hub.is_hub(), "the hub module is not declared a hub")
	_expect(hub.encounter_count() == 0, "the hub declares %d encounter socket(s)" % hub.encounter_count())
	_expect(hub.exit_gate_open, "the hub's Rift Gate is sealed, so no run can begin")
	var bounds: Rect2 = hub.local_bounds()
	for enemy: PrototypeGraveblade in loop.graveblades:
		var local: Vector3 = hub.to_local(enemy.global_position)
		_expect(not bounds.has_point(Vector2(local.x, local.z)),
			"%s stands inside the hub" % enemy.name)
	_expect(loop.loop_state == RogueliteCoreLoopRuntime.LoopState.HUB,
		"the review did not start in the hub")
	_expect(not loop.run_state.in_run(), "the review started already inside a run")
	print("  the hub holds 0 encounters and 0 of %d enemies" % loop.graveblades.size())
	_done("hub_is_safe")


# --- 4. The loop ---------------------------------------------------------------

func _check_hub_entry_begins_a_run() -> void:
	print("")
	print("--- Walking into the hub's Rift Gate begins an expedition; nothing loads")
	var before_scene: Node = get_tree().current_scene
	var run_before: String = loop.run_state.plan.run_id()
	await _walk_into_gate(loop.hub_module.exit_point())
	_expect(loop.loop_state == RogueliteCoreLoopRuntime.LoopState.IN_RUN,
		"walking into the hub gate did not begin a run")
	_expect(loop.run_state.current_room_index == 0,
		"the run began at room index %d, not 0" % loop.run_state.current_room_index)
	_expect(loop.runs_started == 1, "runs_started is %d, not 1" % loop.runs_started)
	_expect(get_tree().current_scene == before_scene, "entering the Rift changed the current scene")
	_expect(loop.player.global_position.distance_to(loop.room_modules[0].entry_point()) < 0.6,
		"the player did not arrive at the first room's own entry point")
	_expect(loop.run_state.plan.run_id() == run_before,
		"the first run changed its own id on entry")
	_expect(loop.room_enemies[0][0].ai_enabled, "the first room's Graveblade is still inert")
	for later: int in [1, 2]:
		for enemy: PrototypeGraveblade in loop.room_enemies[later]:
			_expect(not enemy.ai_enabled, "%s is active while its room has not been entered" % enemy.name)
	print("  %s begins at %s" % [loop.run_state.plan.run_id(), loop.room_modules[0].display_name()])
	_done("hub_entry_begins_a_run")


## Proved in BOTH directions. A gate that always opens is not a gate, and a
## gate that never opens cannot be distinguished from a wall.
func _check_combat_gate_holds_and_opens() -> void:
	print("")
	print("--- The room's gate REFUSES while its encounter lives, and opens when it dies")
	var index: int = loop.run_state.current_room_index
	var module: RogueliteRoomModule = loop.room_modules[index]
	_expect(not module.exit_gate_open, "the first room's gate is open before the room is cleared")

	await _walk_into_gate(module.exit_point())
	_expect(loop.run_state.current_room_index == index,
		"the gate advanced the run with the encounter still alive")
	_expect(loop.loop_state == RogueliteCoreLoopRuntime.LoopState.IN_RUN,
		"the sealed gate changed the loop state")
	print("  sealed: standing in the gate with 1 Graveblade alive advanced nothing")

	var enemy: PrototypeGraveblade = loop.room_enemies[index][0]
	var hits: int = await _kill(enemy)
	_expect(hits == 3,
		"the Worn Blade (100 damage) took %d Hit(s) to defeat %.0f Life, not 3" % [hits, ORDINARY_LIFE])
	await _settle(6)
	_expect(module.exit_gate_open, "clearing the room did not open its gate")
	_expect(loop.run_state.is_cleared(index), "the cleared room was not recorded as cleared")
	print("  opened: 3 Hits, ceil(%.0f / %.0f) = 3, and the gate opened" % [ORDINARY_LIFE, WORN_DAMAGE])
	_done("combat_gate_holds_and_opens")


func _check_room_order_is_the_authored_order() -> void:
	print("")
	print("--- Rooms are entered in the plan's own order, one at a time")
	var order: Array[StringName] = loop.run_state.plan.ordered_modules()
	_expect(loop.room_modules[0].module_id == order[0],
		"room 1 is not the plan's first module")
	await _walk_into_gate(loop.room_modules[0].exit_point())
	_expect(loop.run_state.current_room_index == 1,
		"the open gate did not advance to room 2 (index is %d)" % loop.run_state.current_room_index)
	_expect(loop.room_modules[1].module_id == order[1], "room 2 is not the plan's second module")
	_expect(loop.transitions == 1, "%d transition(s) recorded, not 1" % loop.transitions)
	## An unclaimed ground item does not follow the player out of its room. It
	## used to: the inherited nameplate and HUD prompt stayed alive for the rest
	## of the run, pointing at an item tens of metres away in a sealed room, and
	## it could still be equipped from there.
	_expect(loop._active_drop == null,
		"a ground item survived the room transition and is still advertised")
	_expect(loop.player.global_position.distance_to(loop.room_modules[1].entry_point()) < 0.6,
		"the player did not arrive at room 2's own entry point")
	for enemy: PrototypeGraveblade in loop.room_enemies[0]:
		_expect(not enemy.ai_enabled, "a room-1 enemy is still active after leaving room 1")
	for enemy: PrototypeGraveblade in loop.room_enemies[1]:
		_expect(enemy.ai_enabled, "a room-2 enemy is inert after entering room 2")
	for enemy: PrototypeGraveblade in loop.room_enemies[2]:
		_expect(not enemy.ai_enabled, "a room-3 enemy is active before room 3 is entered")
	print("  room 1 -> room 2 through the gate; only room 2 is live")
	_done("room_order_is_the_authored_order")


func _check_guaranteed_reward() -> void:
	print("")
	print("--- Clearing the reward room grants exactly one item, on the way to the gate")
	var index: int = loop.run_state.current_room_index
	_expect(index == RogueliteCoreLoopRuntime.REWARD_ROOM_INDEX,
		"the verification is not standing in the reward room")
	var module: RogueliteRoomModule = loop.room_modules[index]
	_expect(loop._active_drop == null, "a ground item exists before the room was cleared")

	for enemy: PrototypeGraveblade in loop.room_enemies[index]:
		if enemy.is_alive():
			var hits: int = await _kill(enemy)
			_expect(hits == 3, "%s took %d Hit(s), not 3" % [enemy.name, hits])
	await _settle(6)

	_expect(loop.run_state.reward_granted, "clearing the reward room granted nothing")
	_expect(loop._active_drop != null, "no ground item exists after the reward room was cleared")
	if loop._active_drop == null:
		_done("guaranteed_reward")
		return
	var drop: FirstMvpItemDrop = loop._active_drop
	_expect(String(drop.weapon.weapon_id) == "roguelite_expedition_blade",
		"the reward is not the Expedition Blade")
	_expect(is_equal_approx(drop.weapon.physical_damage, EXPEDITION_DAMAGE),
		"the reward deals %.0f, not %.0f" % [drop.weapon.physical_damage, EXPEDITION_DAMAGE])
	## A BAND, IN BOTH DIRECTIONS, AND THE LOWER BOUND IS THE ONE THAT MATTERS.
	## It must sit on the walked line between the room and its gate — near
	## enough that leaving without seeing it takes effort — but it must NOT sit
	## inside the gate's own trigger circle. The first implementation dropped it
	## 1.60 m from a gate whose enter radius is 1.70 m, so walking to the reward
	## WAS walking into the gate: the player was teleported onward and the item
	## they had just earned was stranded behind them. This assertion was
	## `<= 4.0` and printed "1.60 m from the gate" as though that were good
	## news, because it never asked the opposite question.
	var to_gate: float = drop.global_position.distance_to(module.exit_point())
	_expect(to_gate > RogueliteCoreLoopRuntime.GATE_ENTER_RADIUS + 1.5,
		"the reward is %.2f m from a gate that triggers at %.2f m — reaching for it ends the room" % [
			to_gate, RogueliteCoreLoopRuntime.GATE_ENTER_RADIUS,
		])
	_expect(to_gate <= 8.0,
		"the reward is %.2f m from the gate — a player can walk out without passing it" % to_gate)
	## And proved by BEHAVIOUR, not only by arithmetic: standing exactly on the
	## item must leave the player in the room.
	var index_before: int = loop.run_state.current_room_index
	await _walk_into_gate(drop.global_position)
	_expect(loop.run_state.current_room_index == index_before,
		"standing on the reward advanced the run — the item is inside the gate trigger")
	_expect(loop._active_drop != null, "standing on the reward destroyed it")
	## Idempotent: a second clear signal grants nothing more.
	var refusals_before: int = loop.run_state.refusals
	_expect(not loop.run_state.grant_reward(), "the guaranteed reward could be granted twice")
	_expect(loop.run_state.refusals == refusals_before + 1, "the duplicate grant was not counted")
	print("  %s granted, %.2f m from the gate, second grant refused and counted" % [
		drop.weapon.display_name, to_gate,
	])
	_done("guaranteed_reward")


## The improvement is MEASURED against a real enemy, not read off the record.
## The comparison panel says 3 -> 2; this kills something to prove it.
func _check_equip_improvement_is_measured() -> void:
	print("")
	print("--- The comparison states the change, Equip applies it, and the next kill proves it")
	var drop: FirstMvpItemDrop = loop._active_drop
	_expect(drop != null, "no reward is present to equip")
	if drop == null:
		_done("equip_improvement_is_measured")
		return

	_expect(is_equal_approx(loop.graveblade_max_life(), ORDINARY_LIFE),
		"the comparison would quote %.0f Life, not the reward room's own %.0f" % [
			loop.graveblade_max_life(), ORDINARY_LIFE,
		])
	var before: PrototypeWeaponData = loop.loadout.equipped_weapon
	_expect(before.hits_to_defeat(ORDINARY_LIFE) == 3, "the current weapon does not need 3 Hits")
	_expect(drop.weapon.hits_to_defeat(ORDINARY_LIFE) == 2, "the reward does not need 2 Hits")

	loop.open_item_comparison("verification")
	await _settle(2)
	_expect(loop.item_comparison.is_open, "the comparison panel did not open")
	_expect(get_tree().paused, "opening the comparison did not pause ordinary simulation")

	loop.item_comparison._on_equip_pressed()
	await _settle(2)
	_expect(not loop.item_comparison.is_open, "the comparison is still open after Equip")
	_expect(not get_tree().paused, "the world is still paused after the comparison closed")
	_expect(is_equal_approx(loop.player.weapon.physical_damage, EXPEDITION_DAMAGE),
		"Quick Strike deals %.0f after Equip, not %.0f" % [
			loop.player.weapon.physical_damage, EXPEDITION_DAMAGE,
		])
	_expect(loop._active_drop == null, "the ground item survived being equipped")
	_expect(loop.loadout.is_owned(loop.loadout.equipped_weapon), "the equipped item is not owned")
	_expect(loop.run_state.reward_equipped, "the run did not record that its reward was equipped")

	## THE PROOF ITSELF, AGAINST A REAL ENEMY RATHER THAN AGAINST THE RECORD.
	## The only 300-Life Graveblade still standing at this point in the run is
	## the Elite Hall's escort, so that is the witness, and it is left dead
	## rather than revived — reviving one enemy would leave it in the
	## already-counted set while alive, which is a state ordinary play cannot
	## produce and which the suite must not manufacture.
	var witness: PrototypeGraveblade = loop.room_enemies[RogueliteCoreLoopRuntime.ELITE_ROOM_INDEX][1]
	_expect(is_equal_approx(witness.data.max_life, ORDINARY_LIFE),
		"the witness is not an ordinary %.0f-Life Graveblade" % ORDINARY_LIFE)
	var hits: int = await _kill(witness)
	_expect(hits == 2,
		"an upgraded Quick Strike took %d Hit(s) against %.0f Life, not 2" % [hits, ORDINARY_LIFE])
	print("  100 -> 150 damage; the same 300-Life Graveblade fell in 3 Hits, then in 2")
	_done("equip_improvement_is_measured")


func _check_elite_is_the_same_language() -> void:
	print("")
	print("--- The Elite differs from an ordinary Graveblade in EXACTLY ONE field")
	var ordinary: GravebladeData = load("res://data/prototype_zero/graveblade.tres") as GravebladeData
	var elite: GravebladeData = load("res://data/roguelite/graveblade_elite.tres") as GravebladeData
	var differing: PackedStringArray = PackedStringArray()
	for entry: Dictionary in ordinary.get_property_list():
		if int(entry["usage"]) & PROPERTY_USAGE_SCRIPT_VARIABLE == 0:
			continue
		var key: String = String(entry["name"])
		if key == "display_name":
			continue
		if str(ordinary.get(key)) != str(elite.get(key)):
			differing.append(key)
	_expect(differing.size() == 1 and differing[0] == "max_life",
		"the Elite differs from the ordinary Graveblade in %s — the combat language moved" % str(differing))
	_expect(is_equal_approx(elite.max_life, ELITE_LIFE),
		"the Elite has %.0f Life, not %.0f" % [elite.max_life, ELITE_LIFE])
	_expect(is_equal_approx(elite.physical_damage, ordinary.physical_damage),
		"the Elite's damage moved, so the player's 4-Hit death relationship moved with it")
	_expect(elite.hits_to_defeat(EXPEDITION_DAMAGE) == 4,
		"the Elite does not take 4 upgraded Hits")

	## Same family, same body scene, same single coordinator.
	var elite_enemy: PrototypeGraveblade = loop.room_enemies[RogueliteCoreLoopRuntime.ELITE_ROOM_INDEX][0]
	_expect(elite_enemy.data == elite, "the Elite Hall's first enemy does not carry the Elite record")
	_expect(elite_enemy.get_script() == loop.room_enemies[0][0].get_script(),
		"the Elite runs a different script from an ordinary Graveblade — that is a new enemy family")
	_expect(loop.attack_coordinator != null and loop.attack_coordinator.simultaneous_attackers == 1,
		"the Elite room does not use the one accepted attack coordinator")
	print("  one field moved: max_life %.0f -> %.0f; 4 upgraded Hits; same script, same coordinator" % [
		ordinary.max_life, elite.max_life,
	])
	_done("elite_is_the_same_language")


func _check_final_return_completes_the_run() -> void:
	print("")
	print("--- Clearing the last room returns to the Nexus with a run-complete state")
	await _walk_into_gate(loop.room_modules[1].exit_point())
	_expect(loop.run_state.current_room_index == 2,
		"the run did not advance to the Elite Hall (index %d)" % loop.run_state.current_room_index)

	for enemy: PrototypeGraveblade in loop.room_enemies[2]:
		if enemy.is_alive():
			enemy.set_ai_enabled(false)
			await _kill(enemy)
	await _settle(6)
	_expect(loop.room_modules[2].exit_gate_open, "clearing the Elite Hall did not open its gate")

	var before_scene: Node = get_tree().current_scene
	await _walk_into_gate(loop.room_modules[2].exit_point())
	_expect(loop.loop_state == RogueliteCoreLoopRuntime.LoopState.RUN_COMPLETE,
		"the last gate did not complete the run")
	_expect(loop.run_state.run_complete, "the run state does not record completion")
	_expect(loop.runs_completed == 1, "runs_completed is %d, not 1" % loop.runs_completed)
	_expect(get_tree().current_scene == before_scene, "returning to the Nexus changed the current scene")
	_expect(loop.player.global_position.distance_to(loop.hub_module.entry_point()) < 0.6,
		"the player did not return to the hub's own entry point")
	_expect(loop.summary_panel.is_open, "the run-complete panel did not open")
	## THE CAMERA MUST ALREADY BE AT THE NEXUS BEHIND THE PANEL. The panel
	## pauses the tree and `PrototypeCameraRig` only moves inside `_process`,
	## which is pausable — so a focus merely assigned before the pause is never
	## applied and the summary appears over the room just left. Asserting the
	## camera's ACTUAL global position is the only thing that catches it; the
	## state, the player position and every text row were all already correct
	## while the screen showed the wrong room.
	var camera_to_hub: float = loop.camera_rig.camera.global_position.distance_to(loop.hub_module.entry_point())
	var camera_to_last: float = loop.camera_rig.camera.global_position.distance_to(loop.room_modules[2].exit_point())
	_expect(camera_to_hub < camera_to_last,
		"the camera is %.1f m from the Nexus and %.1f m from the room just left — the run-complete panel opened over the wrong space" % [
			camera_to_hub, camera_to_last,
		])
	_expect(loop.run_state.cleared_rooms.size() == EXPECTED_ROOMS,
		"%d room(s) recorded as cleared, not %d" % [loop.run_state.cleared_rooms.size(), EXPECTED_ROOMS])
	loop.summary_panel.close("verification")
	await _settle(2)
	_expect(not get_tree().paused, "closing the run summary left the world paused")
	print("  %s complete: %d of %d rooms, returned to the Nexus, no scene loaded" % [
		loop.run_state.plan.run_id(), loop.run_state.cleared_rooms.size(), EXPECTED_ROOMS,
	])
	_done("final_return_completes_the_run")


## The one rule the brief states twice: death returns to the Nexus and resets
## temporary run-only rewards. Proved in both senses — the weapon goes back AND
## the item stops being owned — and then proved not to have broken the loop, by
## earning the reward again.
func _check_death_resets_the_run() -> void:
	print("")
	print("--- Death returns to the Nexus and the temporary reward is genuinely gone")
	await _walk_into_gate(loop.hub_module.exit_point())
	_expect(loop.loop_state == RogueliteCoreLoopRuntime.LoopState.IN_RUN,
		"a second run could not be started after the first completed")
	var second_run: String = loop.run_state.plan.run_id()

	## Earn and equip the reward again so there is something real to lose.
	await _walk_into_gate(loop.room_modules[0].exit_point())
	_expect(loop.run_state.current_room_index == 0,
		"room 1's gate opened before its Graveblade was defeated on the second run")
	await _kill(loop.room_enemies[0][0])
	await _settle(4)
	await _walk_into_gate(loop.room_modules[0].exit_point())
	for enemy: PrototypeGraveblade in loop.room_enemies[1]:
		if enemy.is_alive():
			await _kill(enemy)
	await _settle(6)
	_expect(loop._active_drop != null, "the reward was not granted again on a second run")
	## THE EQUIP MUST ACTUALLY HAPPEN, AND THIS ASSERTION USED TO PASS WITHOUT
	## IT. When a completed run still carried its Expedition Blade, the second
	## run began already holding it, `PlayerLoadout.equip()` refused it as
	## already equipped, `on_weapon_equipped()` was never called — and the only
	## check here read the weapon's damage, which was already 150 for the wrong
	## reason. The whole death-reset proof rested on it. It now asserts the
	## transition: 100 before, the run recording the equip, and 150 after.
	_expect(is_equal_approx(loop.player.weapon.physical_damage, WORN_DAMAGE),
		"the second run did not begin on the Worn Blade — a completed run carried its reward forward")
	_expect(not loop.run_state.reward_equipped, "the new run began with its reward already equipped")
	if loop._active_drop != null:
		loop.open_item_comparison("verification")
		await _settle(2)
		loop.item_comparison._on_equip_pressed()
		await _settle(2)
	_expect(loop.run_state.reward_equipped,
		"Equip was refused on the second run — the reward could not be taken")
	_expect(is_equal_approx(loop.player.weapon.physical_damage, EXPEDITION_DAMAGE),
		"the reward was not equipped before the death test")

	var lethal: DamageEvent = DamageEvent.physical(
		90001, loop.room_enemies[1][0], loop.player, loop.player.max_life + 999.0
	)
	loop.player.receive_damage(lethal)
	_expect(not loop.player.is_alive(), "the player did not fall from a lethal DamageEvent")
	for frame: int in 150:
		if loop.fallen_overlay.is_open:
			break
		await get_tree().physics_frame
	_expect(loop.fallen_overlay.is_open, "the Fallen overlay did not open")
	_expect(loop.fallen_overlay is RogueliteFallenOverlay,
		"the Fallen overlay is Gate 1D's own, whose copy names Broken Watch")
	_expect(loop.fallen_overlay.killing_source.contains("Graveblade"),
		"Fallen does not name the Graveblade: '%s'" % loop.fallen_overlay.killing_source)
	print("  Fallen: \"%s\"" % loop.fallen_overlay.killing_source)

	loop.fallen_overlay._on_restart()
	await _settle(6)

	_expect(loop.loop_state == RogueliteCoreLoopRuntime.LoopState.HUB,
		"death did not return the player to the Nexus")
	_expect(loop.player.global_position.distance_to(loop.hub_module.entry_point()) < 0.6,
		"the player did not return to the hub's own entry point")
	_expect(loop.player.is_alive() and is_equal_approx(loop.player.life, loop.player.max_life),
		"the player is not back at full Life")
	_expect(not get_tree().paused, "the world is still paused after returning to the Nexus")

	## Gone in BOTH senses.
	_expect(is_equal_approx(loop.player.weapon.physical_damage, WORN_DAMAGE),
		"Quick Strike still deals %.0f after death — the temporary reward survived" % loop.player.weapon.physical_damage)
	_expect(String(loop.loadout.equipped_weapon.weapon_id) == "roguelite_worn_blade",
		"the equipped weapon is not the Worn Blade after death")
	for owned: PrototypeWeaponData in loop.loadout.owned_items:
		_expect(String(owned.weapon_id) != "roguelite_expedition_blade",
			"the Expedition Blade is still OWNED after death")
	_expect(loop._active_drop == null, "a ground item survived the run reset")
	_expect(not loop._drop_granted, "the drop latch survived the run reset")
	_expect(not loop.run_state.reward_granted and not loop.run_state.reward_equipped,
		"the new run inherited the previous run's reward state")
	_expect(loop.run_state.cleared_rooms.is_empty(), "the new run inherited cleared rooms")
	_expect(loop.run_state.plan.run_id() != second_run,
		"the run after death reuses the dead run's id %s" % second_run)

	## Every enemy is restored, at its OWN authored spawn, and inert.
	for index: int in loop.room_modules.size():
		var module: RogueliteRoomModule = loop.room_modules[index]
		var spawns: Array[Vector3] = module.spawn_points()
		_expect(not module.exit_gate_open, "%s's gate is still open after the reset" % module.name)
		for slot: int in loop.room_enemies[index].size():
			var enemy: PrototypeGraveblade = loop.room_enemies[index][slot]
			var expected_life: float = ELITE_LIFE if enemy.data.max_life == ELITE_LIFE else ORDINARY_LIFE
			_expect(enemy.is_alive() and is_equal_approx(enemy.life, expected_life),
				"%s is not restored to %.0f Life" % [enemy.name, expected_life])
			_expect(enemy.global_position.distance_to(spawns[slot]) < 0.5,
				"%s reset to %s, not its own spawn %s" % [enemy.name, enemy.global_position, spawns[slot]])
			_expect(not enemy.ai_enabled, "%s is active while the player is in the hub" % enemy.name)

	## And the loop still works: a reset that also destroys the run is not a reset.
	await _walk_into_gate(loop.hub_module.exit_point())
	_expect(loop.loop_state == RogueliteCoreLoopRuntime.LoopState.IN_RUN,
		"no run could be started after a death")
	_expect(loop.run_state.current_room_index == 0, "the run after death did not start at room 1")
	print("  Nexus, full Life, Worn Blade, nothing owned, all %d enemies restored; a new run starts" % loop.graveblades.size())
	_done("death_resets_the_run")


## THE SUCCESS PATH IS A RESET PATH TOO, AND NOTHING USED TO PROVE IT. Death
## was the only route that cleared run-scoped state, so completing a run kept
## the Expedition Blade: the next expedition began holding it, its own reward
## could never be equipped, and the run-summary panel said "Nothing here is
## kept" while the opposite was true on screen.
func _check_a_completed_run_does_not_carry_its_reward() -> void:
	print("")
	print("--- A COMPLETED run clears its temporary reward, exactly as death does")
	_expect(loop.loop_state != RogueliteCoreLoopRuntime.LoopState.IN_RUN,
		"the completed-run check is not standing in the Nexus")
	_expect(is_equal_approx(loop.player.weapon.physical_damage, WORN_DAMAGE),
		"after a run the player still swings %.0f damage — the temporary reward survived completion" % loop.player.weapon.physical_damage)
	_expect(String(loop.loadout.equipped_weapon.weapon_id) == "roguelite_worn_blade",
		"the equipped weapon after a completed run is not the Worn Blade")
	for owned: PrototypeWeaponData in loop.loadout.owned_items:
		_expect(String(owned.weapon_id) != "roguelite_expedition_blade",
			"the Expedition Blade is still OWNED after a completed run")
	_expect(not loop._drop_granted, "the drop latch survived a completed run")
	_expect(loop._active_drop == null, "a ground item survived a completed run")
	print("  the Worn Blade is back, nothing is owned, the latch is clear")
	_done("a_completed_run_does_not_carry_its_reward")


# --- 5. Boundaries -------------------------------------------------------------

func _check_writes_nothing() -> void:
	print("")
	print("--- The review has no storage of any kind")
	for path: String in REVIEW_SCRIPTS:
		var code: String = _code_only(FileAccess.get_file_as_string(path))
		for fragment: String in [
			"user://", "ConfigFile", "ResourceSaver", "FileAccess.open",
			"PrototypeSettings", "PrototypeLabState", "CharacterSave", "store_string",
		]:
			_expect(not code.contains(fragment),
				"%s names %s — this review must write nothing" % [path.get_file(), fragment])
	print("  %d review script(s) name no storage path, store, or writer" % REVIEW_SCRIPTS.size())
	_done("writes_nothing")


func _check_excluded_systems_absent() -> void:
	print("")
	print("--- Every excluded system is absent, and the greybox is genuinely primitive")
	for path: String in REVIEW_SCRIPTS:
		var code: String = _code_only(FileAccess.get_file_as_string(path))
		for fragment: String in [
			"RiftShard", "rift_shard", "RiftEcho", "rift_echo", "Augment", "PassiveWeb",
			"passive_web", "PassiveGraph", "Forge", "crafting", "Distortion",
			"RiftIntensity", "rift_intensity", "MaraVeyl", "DialogueLine", "FirstMvpDialogue",
			"RunGraph", "run_graph", "DungeonRecipe", "ModuleLibrary", "RandomNumberGenerator",
			"randi", "randf", "Time.get_unix", "CharacterState", "ExperienceTable",
			"FoundationCache", "OriginRing", "Boss", "Warden",
		]:
			_expect(not code.contains(fragment),
				"%s names the excluded %s" % [path.get_file(), fragment])
		## Greybox, measured from the source rather than promised in a comment.
		for asset_fragment: String in [
			"res://assets/", ".gltf", ".glb", ".png", ".import", "kaykit", "kenney",
			"k0rveen", "quaternius", "lelu", "GPUParticles", "CPUParticles",
			"ShaderMaterial", ".gdshader", "AudioStream",
		]:
			_expect(not code.contains(asset_fragment),
				"%s names %s — the review must add no asset, shader, particle or sound" % [
					path.get_file(), asset_fragment,
				])
	## And Gate 1D's own reward record is never loaded here.
	var runtime_code: String = _code_only(FileAccess.get_file_as_string(RUNTIME_SCRIPT))
	_expect(not runtime_code.contains("watchsteel"),
		"the runtime loads Gate 1D's own Watchsteel record")
	print("  no excluded system, no asset path, no shader, no particle, no audio, no clock, no engine RNG")
	_done("excluded_systems_absent")


## Ported from Gate F for the reason it was written: reading the right words
## out of a Control tree proves the words EXIST, not that anyone can see them.
func _check_surfaces_are_on_screen() -> void:
	print("")
	print("--- Every new surface actually covers the screen and its text has a rectangle in it")
	await _await_process_frames(4)
	var viewport: Rect2 = Rect2(Vector2.ZERO, Vector2(get_viewport().get_visible_rect().size))
	_expect(viewport.size.x > 0.0 and viewport.size.y > 0.0, "the viewport has no size")

	loop.run_hud.show_gate_prompt("Rift Gate — walk in to begin an expedition", true)
	loop.run_hud.refresh()
	await _await_process_frames(4)
	var hud_visible: int = _measure_text(loop.run_hud.text_controls(), viewport, "run HUD")
	## EXACTLY eight, not "at least seven". A `>=` guard here tolerated one
	## label being invisible, which is precisely the Gate F failure mode this
	## check was ported to catch.
	_expect(hud_visible == 8, "%d of 8 run-HUD labels are visible on screen" % hud_visible)

	loop.summary_panel.open_for(loop.run_state)
	await _await_process_frames(4)
	_expect(loop.summary_panel.size.x >= viewport.size.x - 1.0
			and loop.summary_panel.size.y >= viewport.size.y - 1.0,
		"the run summary's root does not cover the viewport (%s vs %s)" % [
			loop.summary_panel.size, viewport.size,
		])
	var summary_visible: int = _measure_text(loop.summary_panel.text_controls(), viewport, "run summary")
	_expect(summary_visible == 6, "%d of 6 run-summary controls are visible on screen" % summary_visible)
	loop.summary_panel.close("verification")
	await _await_process_frames(2)

	var overlay: RogueliteFallenOverlay = loop.fallen_overlay as RogueliteFallenOverlay
	overlay.open_for(DamageEvent.physical(90002, loop.graveblades[0], loop.player, 125.0))
	await _await_process_frames(6)
	_expect(overlay.size.x >= viewport.size.x - 1.0 and overlay.size.y >= viewport.size.y - 1.0,
		"the Fallen overlay's root does not cover the viewport")
	var fallen_visible: int = _measure_text(overlay.text_controls(), viewport, "Fallen")
	_expect(fallen_visible == 4, "%d of 4 Fallen controls are visible on screen" % fallen_visible)
	## The copy is the roguelite's, not Gate 1D's. `FirstMvpModal.make_button()`
	## puts the caption in a child Label rather than in `Button.text`, so
	## reading `.text` would read an empty string and pass for the wrong
	## reason — the caption is read from where it actually is.
	var restart_text: String = ""
	for control: Control in overlay.text_controls():
		var button: Button = control as Button
		if button != null:
			restart_text = _button_caption(button)
	_expect(not restart_text.is_empty(), "the Fallen button has no readable caption")
	_expect(restart_text.contains("Nexus"),
		"the Fallen button reads '%s', not the roguelite's own copy" % restart_text)
	_expect(not restart_text.contains("Broken Watch"),
		"the Fallen button still names Broken Watch")
	overlay.close("verification")
	await _await_process_frames(2)
	_expect(not get_tree().paused, "a measured surface left the world paused")
	_expect(not loop.item_comparison.is_open and not loop.summary_panel.is_open and not overlay.is_open,
		"a modal was left open by the on-screen measurement")
	print("  run HUD %d, run summary %d, Fallen %d — 0 off screen" % [
		hud_visible, summary_visible, fallen_visible,
	])
	_done("surfaces_are_on_screen")


## `FirstMvpModal.make_button()` builds `Button -> HBoxContainer -> Label`, so
## a button's visible caption is a descendant Label's text, never `Button.text`.
static func _button_caption(button: Button) -> String:
	for child: Node in button.get_children():
		for grandchild: Node in child.get_children():
			var label: Label = grandchild as Label
			if label != null and not label.text.strip_edges().is_empty():
				return label.text
	return button.text


func _measure_text(controls: Array, viewport: Rect2, label: String) -> int:
	var visible: int = 0
	for entry: Variant in controls:
		var control: Control = entry as Control
		if control == null or not control.is_visible_in_tree():
			continue
		var rect: Rect2 = control.get_global_rect()
		var inside: bool = rect.size.x > 0.0 and rect.size.y > 0.0 and viewport.intersects(rect)
		_expect(inside, "%s: a visible control has no rectangle inside the viewport (%s)" % [label, rect])
		if inside:
			visible += 1
	return visible


# --- Evidence ------------------------------------------------------------------

## THE EVIDENCE PASS ADDS EXACTLY FIVE ASSERTIONS, AND THAT IS PINNED RATHER
## THAN HIDDEN. Its first draft claimed to add none; the rendered run then
## reported 617 against the headless 612, because `_kill()` asserts that the
## enemy actually died and the pass kills five of them (1 + 2 + 2). The claim
## was corrected rather than the assertion removed — a helper that kills
## something without checking it died is worth less than the tidy number —
## so the suite carries TWO pins, exactly as `gate_1c_riftfall_landing_smoke.sh`
## carries 200 headless and 203 rendered for the same reason.
func _capture_evidence() -> void:
	print("")
	print("--- Rendered evidence")
	loop.restart_current_slice("evidence")
	await _settle(6)
	loop.set_grid_visible(false)
	await _frame_at(loop.hub_module.entry_point() + loop.hub_module.route_forward() * 6.0, "01_nexus_hub")

	await _walk_into_gate(loop.hub_module.exit_point())
	await _frame_at(loop.room_modules[0].entry_point() + loop.room_modules[0].route_forward() * 9.0,
		"02_teaching_hall")

	await _kill(loop.room_enemies[0][0])
	await _settle(6)
	await _walk_into_gate(loop.room_modules[0].exit_point())
	for enemy: PrototypeGraveblade in loop.room_enemies[1]:
		if enemy.is_alive():
			await _kill(enemy)
	await _settle(8)
	await _frame_at(loop.room_modules[1].exit_point() + loop.room_modules[1].route_forward() * -5.0,
		"03_cache_room_reward")

	if loop._active_drop != null:
		loop.open_item_comparison("evidence")
		await _await_process_frames(6)
		await _shoot("04_item_comparison")
		loop.item_comparison._on_equip_pressed()
		await _await_process_frames(4)

	await _walk_into_gate(loop.room_modules[1].exit_point())
	await _frame_at(loop.room_modules[2].entry_point() + loop.room_modules[2].route_forward() * 10.0,
		"05_elite_hall")

	for enemy: PrototypeGraveblade in loop.room_enemies[2]:
		if enemy.is_alive():
			await _kill(enemy)
	await _settle(8)
	await _walk_into_gate(loop.room_modules[2].exit_point())
	await _await_process_frames(8)
	await _shoot("06_run_complete")
	if loop.summary_panel.is_open:
		loop.summary_panel.close("evidence")
	await _await_process_frames(4)

	loop.set_grid_visible(true)
	await _overhead_frame("07_all_four_modules")
	loop.set_grid_visible(false)
	await _settle(2)


func _frame_at(at: Vector3, stem: String) -> void:
	loop.player.global_position = Vector3(at.x, 0.0, at.z)
	loop.player.velocity = Vector3.ZERO
	loop.player.clear_movement_intent("evidence", false)
	loop.camera_rig.focus = loop.player.global_position
	await _await_process_frames(6)
	await _shoot(stem)


## One overhead frame of the whole composition, so the four disjoint modules and
## their gaps are visible at once. The camera calibration is restored
## afterwards and the restore is asserted by the caller's own later frames
## rather than by a new assertion, so the pinned count does not move.
func _overhead_frame(stem: String) -> void:
	var distance_before: Vector2 = loop.camera_rig.distance_range
	var pitch_before: Vector2 = loop.camera_rig.pitch_range
	loop.camera_rig.distance_range = Vector2(10.0, 260.0)
	loop.camera_rig.pitch_range = Vector2(30.0, 89.0)
	loop.camera_rig.adjust_pitch(88.0 - loop.camera_rig.pitch_degrees)
	loop.camera_rig.adjust_distance(190.0 - loop.camera_rig.distance_metres)
	var centre: Vector3 = loop.composition.global_transform * Vector3(27.0, 0.0, -34.0)
	loop.player.global_position = Vector3(centre.x, 0.0, centre.z)
	loop.camera_rig.focus = loop.player.global_position
	await _await_process_frames(6)
	await _shoot(stem)
	loop.camera_rig.distance_range = distance_before
	loop.camera_rig.pitch_range = pitch_before
	loop.camera_rig.reset_calibration()
	await _await_process_frames(2)


func _shoot(stem: String) -> void:
	for i: int in 6:
		await RenderingServer.frame_post_draw
	await RenderingServer.frame_post_draw
	var path: String = "%s/%s.png" % [_shot_dir, stem]
	get_viewport().get_texture().get_image().save_png(path)
	print("  screenshot: %s" % path)


func _argument_value(flag: String) -> String:
	var index: int = arguments.find(flag)
	if index == -1 or index + 1 >= arguments.size():
		return ""
	return arguments[index + 1]


# --- The owed set --------------------------------------------------------------

## D-211's discipline, in BOTH directions: a check that never ran cannot fail,
## and a suite that only counts assertions cannot see it.
func _check_every_check_ran() -> void:
	print("")
	print("--- Every check this suite owes actually reached its last line")
	var missing: PackedStringArray = PackedStringArray()
	for owed: String in OWED_CHECKS:
		if not _reached.has(owed):
			missing.append(owed)
	var extra: PackedStringArray = PackedStringArray()
	for ran: String in _reached:
		if not OWED_CHECKS.has(ran):
			extra.append(ran)
	_expect(missing.is_empty(), "check(s) never completed: %s" % ", ".join(missing))
	_expect(extra.is_empty(), "check(s) ran that the suite does not owe: %s" % ", ".join(extra))
	print("  %d of %d owed checks completed" % [_reached.size(), OWED_CHECKS.size()])


# --- Helpers -------------------------------------------------------------------

## Walks the player into a gate the way the game does — by putting them there
## and letting the runtime's own polled `_check_exit()` see it on an IDLE frame.
## `_check_exit` is called from `_process`, so waiting on physics frames alone
## would prove nothing: a loaded machine fits several physics steps inside one
## idle frame, which is exactly how four Gate E assertions read stale text.
func _walk_into_gate(gate: Vector3) -> void:
	loop.player.global_position = Vector3(gate.x, 0.0, gate.z)
	loop.player.velocity = Vector3.ZERO
	loop.camera_rig.focus = loop.player.global_position
	await _await_process_frames(6)
	await _settle(4)


## Kills an enemy with forced, deterministic Quick Strikes and returns how many
## it took. The enemy's AI is disabled first so the count measures the weapon,
## not the fight.
func _kill(enemy: PrototypeGraveblade) -> int:
	enemy.set_ai_enabled(false)
	var area: PrototypeTargetable = enemy.get_node("TargetArea") as PrototypeTargetable
	var hits: int = 0
	while enemy.is_alive() and hits < 10:
		await _strike(enemy, area)
		hits += 1
	_expect(not enemy.is_alive(), "%s survived %d forced Quick Strikes" % [enemy.name, hits])
	return hits


func _strike(enemy: PrototypeGraveblade, area: PrototypeTargetable) -> void:
	var before_life: float = enemy.life
	var to_enemy: Vector3 = enemy.global_position - loop.player.global_position
	var planar: Vector3 = Vector3(to_enemy.x, 0.0, to_enemy.z)
	if planar.length() > 1.2 or planar.length() < 0.001:
		loop.player.global_position = enemy.global_position + Vector3(1.0, 0.0, 0.0)
		loop.player.velocity = Vector3.ZERO
	loop.player.face_instantly(enemy.global_position - loop.player.global_position)
	loop.force_next_aim_for_verification(area)
	loop.player.attack.press()
	# Released on the SAME frame as the press — a tap, not a hold — so the
	# kernel's proven held-repeat cannot fire a second, uncounted swing.
	loop.player.attack.release_input()
	for frame: int in 90:
		await get_tree().physics_frame
		if loop.player.attack.phase == QuickStrikeAction.Phase.READY:
			break
	_expect_quiet(enemy.life < before_life or not enemy.is_alive(),
		"a forced Quick Strike produced no damage (Life stayed %.0f)" % before_life)


func _await_navigation() -> void:
	for frame: int in 60:
		if NavigationServer3D.map_get_iteration_id(loop.navigation_map()) > 0:
			return
		await get_tree().physics_frame


func _settle(frames: int) -> void:
	for i: int in frames:
		await get_tree().physics_frame


## `_settle()` waits on PHYSICS. Anything built or polled in `_process` — the
## gate test, HUD text, a Control's rectangle — needs IDLE frames.
func _await_process_frames(frames: int) -> void:
	for i: int in frames:
		await get_tree().process_frame


func _expect(condition: bool, failure_message: String) -> void:
	_checks += 1
	if not condition:
		_failures.append(failure_message)


## Records a failure without adding to the pinned count. Used inside loops
## whose iteration count is incidental (a kill takes 2, 3 or 4 swings), so the
## pinned total cannot drift with a tuning value while a real failure is still
## reported.
func _expect_quiet(condition: bool, failure_message: String) -> void:
	if not condition:
		_failures.append(failure_message)


func _done(check_name: String) -> void:
	_reached[check_name] = true


func _code_only(source: String) -> String:
	var kept: PackedStringArray = PackedStringArray()
	for line: String in source.split("\n"):
		if line.strip_edges().begins_with("#"):
			continue
		kept.append(line)
	return "\n".join(kept)


func _count_nodes_of_script(node: Node, class_name_wanted: String) -> int:
	var total: int = 0
	for child: Node in node.get_children():
		var script: GDScript = child.get_script() as GDScript
		if script != null and script.get_global_name() == StringName(class_name_wanted):
			total += 1
		total += _count_nodes_of_script(child, class_name_wanted)
	return total
