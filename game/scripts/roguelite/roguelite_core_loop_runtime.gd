class_name RogueliteCoreLoopRuntime
extends BrokenWatchSlice
## Riftwrought — the ISOLATED Roguelite Core Loop Review (decision D-220).
##
## Nexus -> Enter Rift -> three authored greybox rooms -> temporary reward ->
## elite -> Nexus. The smallest honest version of the intended loop, built to
## be PLAYED and judged, not to be extended.
##
##
## WHY THIS EXTENDS `BrokenWatchSlice` AND THEN DOES NOT CALL ITS `_ready()`
## -----------------------------------------------------------------------
## This is the one architectural decision in the review that deserves an
## explanation rather than a line, because both obvious readings of it are
## wrong.
##
## `FirstMvpModal`, `FirstMvpCombatHud`, `FirstMvpItemComparison` and
## `FirstMvpFallenOverlay` all declare `var room: BrokenWatchSlice` and
## `func bind_room(owner_room: BrokenWatchSlice)`. A runtime that is not a
## `BrokenWatchSlice` cannot bind ANY of those four proven surfaces, and would
## need copies of them — which would put a THIRD copy of the modal contract in
## a project whose own handoff records "no third copy of it anywhere" as a
## result worth keeping. So the review extends.
##
## But `BrokenWatchSlice._ready()` is structurally married to Riftfall Landing
## and Broken Watch: it resolves `$Composition/NavigationRegion3D/Landing`,
## `.../BrokenWatch` and `$Composition/LandingDressing` into STATICALLY TYPED
## variables, builds the Landing's accepted visual-review dressing, spawns two
## Graveblades at Broken Watch's authored sockets, and puts the player at the
## Landing's own player start. Calling it would drag roughly 1,306 m^2 of
## Riftfall Landing plus the whole five-room Broken Watch — and the registered
## third-party dressing on top of them — into a review whose entire brief is
## "deliberately greyboxed", "no assets or art pass", and "Riftfall Landing is
## no longer the active environment-art track".
##
## So this class overrides `_ready()` and DELIBERATELY DOES NOT CALL
## `super._ready()`. It inherits the TYPE and the proven behaviour; it does not
## inherit the world. The consequences are stated rather than left to be
## discovered:
##
##   * `landing_layout`, `landing_dressing`, `broken_watch`, `lighting` and
##     `treatment` stay NULL for this scene's whole life. Every inherited
##     method that reads one of them is overridden below — `route_forward()`,
##     `_check_exit()`, `restart_current_slice()`, `set_grid_visible()`,
##     `graveblade_max_life()`, `measurements()` and
##     `_maybe_start_verification()` — and the verification asserts both that
##     the fields are null AND that no Riftfall Landing or Broken Watch node
##     exists anywhere in the tree, so the claim is measured rather than
##     argued.
##   * `_on_first_graveblade_died()` and `_place_drop()` are inherited, read
##     `broken_watch` / Gate 1D's own `.tres` path, and are NEVER CONNECTED OR
##     CALLED here. This review connects `_on_encounter_enemy_died()` instead
##     and places its own record. The verification asserts the Gate 1D
##     Watchsteel record is not loaded.
##
## Everything else is reused exactly as Gate 1D proved it: per-use mouse
## targeting with no stored field, controller soft targeting under D-178's
## cone, the held-click cadence, hover info that can never leak into
## acquisition, the ground nameplate, the item comparison and equip path, the
## Fallen delay, the neutral-input latch, and the whole `_unhandled_input`
## ordering. None of those files is edited.
##
##
## WHAT IS DELIBERATELY NOT HERE
## -----------------------------
## No saving of any kind — this scene constructs no settings or state store and
## names no storage path, so nothing it does can reach `user://`. No permanent
## progression, no meta-progression, no run currency, no unlocks, no
## experience, no Passive Web, no Rift Shards or Rift Echo, no Augments, no
## Forge, no crafting, no Archive, no Vault, no Reliquary, no dialogue, no NPC,
## no boss system, no new enemy family, no procedural generation, no Run Graph,
## no Dungeon Recipe, no room-connector solving, no new asset, no art pass, no
## audio, and no new InputMap action.
##
## Run it directly (it is NOT the project entrypoint and must never become it):
##   /Applications/Godot.app/Contents/MacOS/Godot --path game \
##     res://scenes/roguelite/roguelite_core_loop.tscn
##
## Optional: `-- --seed 12345` to enter a named run.
## Controls are Gate 1D's, unchanged: left click move, right mouse / (X) Quick
## Strike, Shift attack in place, Enter / (A) inspect a ground item, F5 abandon
## the run and return to the Nexus. Review keys are PHYSICAL: F6 grid,
## `[` `]` camera distance, `\` reset.

const RUNTIME_VERIFICATION_SCRIPT: String = "res://tests/roguelite_core_loop_verification.gd"

const WORN_BLADE_PATH: String = "res://data/roguelite/worn_blade.tres"
const EXPEDITION_BLADE_PATH: String = "res://data/roguelite/expedition_blade.tres"
const ELITE_DATA_PATH: String = "res://data/roguelite/graveblade_elite.tres"
const ORDINARY_DATA_PATH: String = "res://data/prototype_zero/graveblade.tres"

const MODULE_SCRIPT: String = "res://scripts/roguelite/roguelite_room_module.gd"
const RUN_HUD_SCRIPT: String = "res://scripts/roguelite/roguelite_run_hud.gd"
const FALLEN_OVERLAY_SCRIPT: String = "res://scripts/roguelite/roguelite_fallen_overlay.gd"
const SUMMARY_PANEL_SCRIPT: String = "res://scripts/roguelite/roguelite_run_summary_panel.gd"

## Which room index carries the one guaranteed reward, and which carries the
## Elite. Both are indices into the run plan's ordered modules, so a reordered
## plan moves them without editing a room.
const REWARD_ROOM_INDEX: int = 1
const ELITE_ROOM_INDEX: int = 2

## Where each module is placed, in the shared `Composition` frame. Modules are
## DISJOINT: an expedition room is entered through its gate, not walked into
## from the previous room, which is what makes each one an independently
## selectable module rather than a segment of one corridor. The gaps are wide
## (29 m at the narrowest) so no two modules can accidentally join in the bake.
const PLACEMENTS: Dictionary = {
	&"nexus_hub": Vector2(0.0, 0.0),
	&"teaching_hall": Vector2(54.0, 0.0),
	&"cache_room": Vector2(54.0, -58.0),
	&"elite_hall": Vector2(0.0, -58.0),
}

## Walking into a gate is the transition. It needs no key, works identically
## for mouse and controller, and cannot be missed the way a prompt can.
const GATE_ENTER_RADIUS: float = 1.70
const GATE_PROMPT_RADIUS: float = 7.00

## How far back from the gate the guaranteed reward is laid, along the line the
## player walks to reach it.
##
## THIS CONSTANT EXISTS BECAUSE THE FIRST IMPLEMENTATION PUT THE REWARD INSIDE
## THE GATE. It dropped the item at the reward room's alcove centre, which
## measured **1.60 m** from the gate — inside `GATE_ENTER_RADIUS` — so walking
## to the item WAS walking into the gate: the player was teleported to the next
## room and the reward they had just earned was stranded behind them forever.
## The verification even printed "1.60 m from the gate" as though it were good
## news, because its assertion was `<= 4.0` and it never asked the opposite
## question. It is now asserted as a BAND, with a stated margin over the
## trigger.
const REWARD_GATE_CLEARANCE: float = 4.60

enum LoopState {
	## In the Nexus, no expedition in progress.
	HUB,
	## Inside an expedition room.
	IN_RUN,
	## Back in the Nexus with a completed expedition on the board.
	RUN_COMPLETE,
}

var loop_state: LoopState = LoopState.HUB
var plan: RogueliteRunPlan
var run_state: RogueliteRunState

var hub_module: RogueliteRoomModule
var room_modules: Array[RogueliteRoomModule] = []
var all_modules: Array[RogueliteRoomModule] = []

var run_hud: RogueliteRunHud
var summary_panel: RogueliteRunSummaryPanel

## Enemies grouped by the room index that owns them. `graveblades` (inherited)
## holds every enemy in the scene, because the inherited targeting and hover
## code reads that list.
var room_enemies: Array = []

var runs_started: int = 0
var runs_completed: int = 0
var transitions: int = 0

var _gate_prompt_shown: String = ""


# --- Assembly ---------------------------------------------------------------

## Deliberately does NOT call `super._ready()`. See the class header.
func _ready() -> void:
	composition = $Composition
	composition.rotation_degrees = Vector3(0.0, COMPOSITION_YAW_DEGREES, 0.0)
	nav_region = $Composition/NavigationRegion3D
	camera_rig = $CameraRig
	marker = $DestinationMarker
	input_family = $InputFamilyTracker
	hud = $CanvasLayer/Hud
	item_comparison = $CanvasLayer/ItemComparison
	fallen_overlay = $CanvasLayer/FallenOverlay

	plan = RogueliteRunPlan.new(_seed_from_arguments(), 0)
	var plan_problem: String = plan.problem()
	assert(plan_problem.is_empty(), "RogueliteCoreLoopRuntime: %s" % plan_problem)
	run_state = RogueliteRunState.new(plan)

	_build_modules()
	_configure_navigation()
	bake_navigation()

	_spawn_player_in_hub()
	_spawn_combat_kernel()
	_spawn_encounters()

	hud.bind_room(self)
	item_comparison.bind_room(self)
	fallen_overlay.bind_room(self)
	_build_run_surfaces()

	camera_rig.set_target(player)
	camera_rig.reset_calibration()
	input_family.family_changed.connect(_on_family_changed)

	_build_nameplate()

	log_event("roguelite core loop", "isolated review assembled; writes nothing, loads no scene")
	log_event("run plan", plan.describe())
	for module: RogueliteRoomModule in all_modules:
		log_event("module", module.describe())

	_enter_hub("assembled")

	await _await_navigation_synchronized()
	_maybe_start_verification()


func _seed_from_arguments() -> int:
	var arguments: PackedStringArray = OS.get_cmdline_user_args()
	var index: int = arguments.find("--seed")
	if index == -1 or index + 1 >= arguments.size():
		return RogueliteRunPlan.BASE_SEED
	return int(arguments[index + 1])


func _build_modules() -> void:
	var script: GDScript = load(MODULE_SCRIPT) as GDScript
	hub_module = _build_module(script, RogueliteRunPlan.HUB_MODULE)
	for id: StringName in plan.ordered_modules():
		var module: RogueliteRoomModule = _build_module(script, id)
		room_modules.append(module)
		room_enemies.append([] as Array[PrototypeGraveblade])


func _build_module(script: GDScript, id: StringName) -> RogueliteRoomModule:
	var module: RogueliteRoomModule = script.new() as RogueliteRoomModule
	module.name = String(id).to_pascal_case()
	# Both are set BEFORE the node enters the tree: `module_id` because
	# `_ready()` builds from it, and `position` because `bake_rect()` is read
	# by `_configure_navigation()` in the same frame.
	module.module_id = id
	var at: Vector2 = PLACEMENTS[id]
	module.position = Vector3(at.x, 0.0, at.y)
	nav_region.add_child(module)
	all_modules.append(module)
	return module


## Overrides the base, which merges only Riftfall Landing's and Broken Watch's
## bake rectangles. Every module's rectangle is merged here, so all four spaces
## bake from ONE call into ONE continuous navigation mesh — disjoint islands by
## design, because an expedition room is entered through its gate.
func _configure_navigation() -> void:
	var mesh: NavigationMesh = NavigationMesh.new()
	mesh.geometry_parsed_geometry_type = NavigationMesh.PARSED_GEOMETRY_STATIC_COLLIDERS
	mesh.geometry_collision_mask = WORLD_MASK
	mesh.geometry_source_geometry_mode = NavigationMesh.SOURCE_GEOMETRY_ROOT_NODE_CHILDREN
	mesh.cell_size = nav_cell_size
	mesh.cell_height = nav_cell_size
	mesh.agent_radius = agent_radius
	mesh.agent_height = agent_height
	mesh.agent_max_climb = agent_max_climb
	mesh.agent_max_slope = agent_max_slope
	var rect: Rect2 = all_modules[0].bake_rect()
	for module: RogueliteRoomModule in all_modules:
		rect = rect.merge(module.bake_rect())
	mesh.filter_baking_aabb = AABB(
		Vector3(rect.position.x, bake_floor, rect.position.y),
		Vector3(rect.size.x, bake_ceiling - bake_floor, rect.size.y)
	)
	nav_region.navigation_mesh = mesh


## Overrides the base, which probes Riftfall Landing's player start.
func _await_navigation_synchronized() -> void:
	var probe: Vector3 = hub_module.entry_point()
	for frame: int in 40:
		if NavigationServer3D.map_get_iteration_id(navigation_map()) == 0:
			await get_tree().physics_frame
			continue
		var answer: Vector3 = NavigationServer3D.map_get_closest_point(navigation_map(), probe)
		if Vector2(answer.x - probe.x, answer.z - probe.z).length() < 0.35:
			log_event("navigation ready", "map answers queries after %d physics frame(s)" % frame)
			return
		await get_tree().physics_frame
	push_warning("RogueliteCoreLoopRuntime: the navigation map did not become queryable")


func _spawn_player_in_hub() -> void:
	var worn: PrototypeWeaponData = load(WORN_BLADE_PATH) as PrototypeWeaponData
	loadout = PlayerLoadout.new(worn)

	player = (load(PLAYER_SCENE) as PackedScene).instantiate() as PrototypePlayer
	player.name = "Player"
	player.max_speed = ACCEPTED_MAX_SPEED
	player.weapon = worn
	$Actors.add_child(player)
	player.global_position = hub_module.entry_point()
	player.face_instantly(hub_module.route_forward())

	player.movement_command_resolved.connect(_on_movement_command_resolved)
	player.arrived_at_destination.connect(_on_arrived)
	player.movement_intent_cleared.connect(_on_intent_cleared)
	player.fell.connect(_on_player_fell)
	player.weapon_changed.connect(_on_weapon_changed)


## Overrides the base, which builds Broken Watch's two Graveblades. Every
## authored encounter socket in every expedition room gets one Graveblade, all
## created up front and all inert until their room is entered — so entering a
## room is enabling AI, never instancing geometry, and the navigation mesh is
## baked exactly once for the whole session.
func _spawn_encounters() -> void:
	var ordinary: GravebladeData = load(ORDINARY_DATA_PATH) as GravebladeData
	var elite: GravebladeData = load(ELITE_DATA_PATH) as GravebladeData
	for index: int in room_modules.size():
		var module: RogueliteRoomModule = room_modules[index]
		var spawns: Array[Vector3] = module.spawn_points()
		var group: Array[PrototypeGraveblade] = []
		for slot: int in spawns.size():
			# Index 0 of the Elite room is the Elite; everything else is an
			# ordinary Graveblade on the untouched accepted record.
			var is_elite: bool = index == ELITE_ROOM_INDEX and slot == 0
			var enemy: PrototypeGraveblade = _spawn_room_enemy(
				"Room%dEnemy%d" % [index + 1, slot], spawns[slot],
				elite if is_elite else ordinary, module
			)
			enemy.died.connect(_on_encounter_enemy_died.bind(index, enemy))
			group.append(enemy)
			graveblades.append(enemy)
		room_enemies[index] = group


func _spawn_room_enemy(
	node_name: String, at: Vector3, data: GravebladeData, module: RogueliteRoomModule
) -> PrototypeGraveblade:
	var enemy: PrototypeGraveblade = (load(GRAVEBLADE_SCENE) as PackedScene).instantiate() as PrototypeGraveblade
	enemy.name = node_name
	# `data` before `add_child` because `_ready()` reads it and sets Life from
	# it; `global_position` before `add_child` because `_ready()` latches
	# `_spawn_position`, and `reset_encounter()` returns the enemy there —
	# setting it afterwards sends every reset to world origin.
	enemy.data = data
	enemy.position = at
	$Actors.add_child(enemy)
	enemy.face_instantly(-module.route_forward())
	enemy.setup(player, attack_coordinator, acquisition, _log_combat_event)
	enemy.set_ai_enabled(false)
	return enemy


func _build_run_surfaces() -> void:
	run_hud = (load(RUN_HUD_SCRIPT) as GDScript).new() as RogueliteRunHud
	run_hud.name = "RunHud"
	$CanvasLayer.add_child(run_hud)
	## Immediately after the combat HUD and BEFORE the modals. A CanvasLayer
	## draws its children in order, so appending had put the run banner and the
	## gate prompt on top of the item comparison's own dim backdrop.
	$CanvasLayer.move_child(run_hud, 1)
	run_hud.bind_runtime(self)

	# Gate 1D's own Fallen overlay is replaced by a subclass of it, not edited:
	# its copy reads "Restart Broken Watch", which is accurate for Gate 1D and
	# wrong here. Subclassing keeps the whole proven modal contract — pause,
	# neutralize, safe focus, held-input refusal, live glyphs — and changes two
	# strings and one behaviour.
	var replacement: RogueliteFallenOverlay = (load(FALLEN_OVERLAY_SCRIPT) as GDScript).new() as RogueliteFallenOverlay
	replacement.name = "RogueliteFallenOverlay"
	var stale: FirstMvpFallenOverlay = fallen_overlay
	$CanvasLayer.add_child(replacement)
	replacement.bind_room(self)
	fallen_overlay = replacement
	stale.queue_free()

	summary_panel = (load(SUMMARY_PANEL_SCRIPT) as GDScript).new() as RogueliteRunSummaryPanel
	summary_panel.name = "RunSummary"
	$CanvasLayer.add_child(summary_panel)
	summary_panel.bind_room(self)


# --- The loop ---------------------------------------------------------------

## Overrides the base's Broken Watch exit test. This is the whole core loop:
## the hub gate starts an expedition, a room's gate advances it once the room
## is cleared, and the last room's gate returns to the Nexus.
func _check_exit(position: Vector3) -> void:
	if _any_modal_open():
		return
	var gate: Vector3 = _active_gate_position()
	var distance: float = _planar(position - gate).length()
	_update_gate_prompt(distance)
	if distance > GATE_ENTER_RADIUS:
		return
	match loop_state:
		LoopState.HUB, LoopState.RUN_COMPLETE:
			_begin_run("entered the Rift Gate")
		LoopState.IN_RUN:
			if not run_state.is_cleared(run_state.current_room_index):
				return
			_advance_room()


func _active_gate_position() -> Vector3:
	if loop_state == LoopState.IN_RUN:
		return room_modules[run_state.current_room_index].exit_point()
	return hub_module.exit_point()


func _update_gate_prompt(distance: float) -> void:
	var text: String = ""
	var open: bool = true
	if distance <= GATE_PROMPT_RADIUS:
		if loop_state == LoopState.IN_RUN:
			var index: int = run_state.current_room_index
			open = run_state.is_cleared(index)
			text = ("Rift Gate open — walk in to %s" % room_modules[index].exit_caption()
				if open else "Rift Gate sealed — clear the room")
		else:
			text = "Rift Gate — walk in to %s" % hub_module.exit_caption()
	if text == _gate_prompt_shown:
		return
	_gate_prompt_shown = text
	if run_hud != null:
		## The state is PASSED, never inferred from the copy. Deciding the
		## colour by searching the sentence for the word "open" painted the
		## hub's own always-open gate in the SEALED colour, inverting the
		## language the rooms teach — and it would have broken again the first
		## time the copy was reworded. This also gives `exit_caption()` its
		## only reader, so a module's authored destination name is no longer
		## dead data.
		run_hud.show_gate_prompt(text, open)


## STARTING A RUN RESETS RUN-SCOPED STATE, AND THAT IS A CORRECTION AN
## ADVERSARIAL REVIEW FOUND AFTER THE SUITE WAS ALREADY GREEN. The reset used
## to live only in `restart_current_slice()` — i.e. only on DEATH — so a
## COMPLETED run kept its Expedition Blade, the next expedition began already
## holding it, `PlayerLoadout.equip()` then refused the new drop as already
## equipped, `on_weapon_equipped()` was never called, and the ground item could
## never be taken again. The run-summary panel meanwhile said "Nothing here is
## kept" on screen. **A temporary reward is scoped to the RUN, so the reset
## belongs at the start of a run, where BOTH the death path and the success
## path pass through it.**
##
## The plan is NOT advanced here. It is advanced exactly once, by whichever
## path ended the previous run, so the identifier the Nexus advertises is the
## identifier the next expedition actually uses.
func _begin_run(reason: String) -> void:
	run_state = RogueliteRunState.new(plan)
	runs_started += 1
	loop_state = LoopState.IN_RUN
	log_event("expedition started", "%s (%s)" % [plan.describe(), reason])
	_reset_run_scoped_state()
	_enter_room(0, "expedition started")


## Everything one expedition owns and nothing that outlives it. Called at the
## START of every run and again when one is ended early, so neither path can
## drift from the other and neither can forget a field the other remembers.
func _reset_run_scoped_state() -> void:
	_clear_active_drop("run-scoped reset")
	_drop_granted = false
	_reset_all_encounters()
	var worn: PrototypeWeaponData = load(WORN_BLADE_PATH) as PrototypeWeaponData
	loadout = PlayerLoadout.new(worn)
	player.equip_weapon(worn)


func _enter_room(index: int, reason: String) -> void:
	run_state.current_room_index = index
	var module: RogueliteRoomModule = room_modules[index]
	module.set_exit_gate_open(false)
	_place_player_at(module.entry_point(), module.route_forward(), reason)
	for enemy: PrototypeGraveblade in room_enemies[index]:
		enemy.set_ai_enabled(true)
	hud.show_message("%s — %s" % [module.display_name(), module.subtitle()])
	log_event("room entered", "%d of %d — %s (%d encounter(s))" % [
		index + 1, run_state.total_rooms(), module.display_name(), module.encounter_count(),
	])
	_refresh_run_hud()


func _advance_room() -> void:
	var from: int = run_state.current_room_index
	transitions += 1
	## An unclaimed reward stays in the room it was earned in. Leaving
	## `_active_drop` set kept the inherited nameplate and HUD prompt alive for
	## the rest of the run, pointing at an item tens of metres away in a room
	## the player can no longer reach — and let them equip it from there.
	if _active_drop != null:
		log_event("reward left behind", "%s was not taken" % _active_drop.display_name())
		_clear_active_drop("the room it was earned in was left")
	for enemy: PrototypeGraveblade in room_enemies[from]:
		enemy.set_ai_enabled(false)
	if from + 1 >= run_state.total_rooms():
		_complete_run()
		return
	log_event("room transition", "%d -> %d through the Rift Gate" % [from + 1, from + 2])
	_enter_room(from + 1, "advanced through the Rift Gate")


func _complete_run() -> void:
	run_state.run_complete = true
	run_state.current_room_index = -1
	runs_completed += 1
	loop_state = LoopState.RUN_COMPLETE
	## THE RUN IS OVER, SO ITS RUN-SCOPED STATE IS OVER — AT THIS MOMENT, NOT AT
	## THE START OF THE NEXT RUN. The summary panel the player is about to read
	## says "Nothing here is kept", and the Nexus banner they stand in front of
	## says the reward was temporary; both are only true if the Worn Blade is
	## already back in hand while they read them. `run_state` is deliberately
	## NOT replaced here, so the summary can still report truthfully what the
	## finished run achieved.
	_reset_run_scoped_state()
	## The completed run's identifier is spent; the Nexus advertises the NEXT
	## one, which is the one `_begin_run()` will actually use.
	plan = plan.next()
	_enter_hub("expedition complete")
	log_event("expedition complete", "%s — %d room(s) cleared, reward %s" % [
		plan.run_id(), run_state.cleared_rooms.size(),
		"equipped" if run_state.reward_equipped else ("left behind" if run_state.reward_granted else "not granted"),
	])
	summary_panel.open_for(run_state)


## ARRIVING IN THE NEXUS RESTORES LIFE AND MANA, AND THAT IS A DESIGN DECISION
## RATHER THAN A CONVENIENCE. The hub is the safe space, and without it a run
## finished at low Life starts the NEXT run at that same low Life with no way
## to recover — the loop degrades into an unwinnable spiral that the review
## would then be asking the project owner to judge. It was found by looking at
## a rendered frame: the run-complete evidence shot showed 375 / 500 Life in
## the Nexus. `revive_for_testing()` is the existing full-restore path the
## Fallen route already uses, so both routes now leave the player in exactly
## the same state.
func _enter_hub(reason: String) -> void:
	if loop_state != LoopState.RUN_COMPLETE:
		loop_state = LoopState.HUB
	if player.is_alive():
		player.revive_for_testing()
	hub_module.set_exit_gate_open(true)
	_place_player_at(hub_module.entry_point(), hub_module.route_forward(), reason)
	_refresh_run_hud()


## The project's recorded teleport contract. Assigning `global_position` alone
## leaves `NavigationAgent3D.target_position` on the old destination and
## `has_destination` true, so the player immediately walks back the way they
## came; `clear_movement_intent()` is what actually ends the command. The
## camera focus is moved with the body so the frame does not sweep 60 m.
func _place_player_at(at: Vector3, facing: Vector3, reason: String) -> void:
	player.global_position = at
	player.velocity = Vector3.ZERO
	player.face_instantly(facing)
	player.clear_movement_intent(reason, false)
	# `set_target()` rather than assigning `focus`, and THAT IS THE FIX FOR A
	# REAL DEFECT A RENDERED FRAME FOUND. `PrototypeCameraRig` only moves the
	# camera inside `_apply()`, which is called from `_process` — and
	# `_process` is PAUSABLE. `_complete_run()` opens the run-summary modal,
	# which pauses the tree in the same frame, so a focus ASSIGNED here was
	# never applied: the summary appeared over the room the player had just
	# left, and the world only snapped to the Nexus when they closed it.
	# `set_target()` sets the focus and calls `_apply()` immediately, so the
	# camera is already at the Nexus behind the panel.
	camera_rig.set_target(player)
	camera_rig.clear_impulse()
	marker.hide_destination()
	## Clear the banner ITSELF, not merely the cache of what it last said.
	## Resetting only `_gate_prompt_shown` left the previous room's text on
	## screen and then made the change test compare "" against "" and
	## early-return, so a freshly entered SEALED room displayed "Rift Gate
	## open — walk in to continue".
	_gate_prompt_shown = ""
	if run_hud != null:
		run_hud.show_gate_prompt("", false)


# --- Encounters -------------------------------------------------------------

## THE ENEMY IS PASSED IN, NOT READ OFF THE EVENT, AND THAT IS A CORRECTION
## RATHER THAN A STYLE CHOICE. `DamageEvent.source` is the ATTACKER and
## `.target` is the victim, so keying the already-counted set on `event.source`
## keys it on the PLAYER — every kill after the first is then refused as a
## duplicate of the first. Gate 1D carries the same expression in
## `_on_first_graveblade_died()` and is unaffected only because it connects
## exactly one enemy's `died`, so the second call never arrives; that is a
## latent defect in a closed, accepted gate, reported rather than edited here.
## Binding the enemy removes the whole class of error: the node that emitted
## the signal is the node that is counted, and no field can misdirect it.
func _on_encounter_enemy_died(_event: DamageEvent, room_index: int, enemy: PrototypeGraveblade) -> void:
	if _rewarded_enemies.has(enemy.get_instance_id()):
		log_event("clear check refused", "duplicate kill signal from %s" % enemy.name)
		return
	_rewarded_enemies[enemy.get_instance_id()] = true
	log_event("enemy defeated", "%s in room %d" % [enemy.name, room_index + 1])
	if _enemies_alive_in(room_index) > 0:
		_refresh_run_hud()
		return
	_on_room_cleared(room_index)


func _on_room_cleared(room_index: int) -> void:
	if not run_state.mark_cleared(room_index):
		return
	var module: RogueliteRoomModule = room_modules[room_index]
	module.set_exit_gate_open(true)
	log_event("room cleared", "%s — the Rift Gate opens" % module.display_name())
	if room_index == REWARD_ROOM_INDEX and run_state.grant_reward():
		_place_run_reward(module)
	else:
		hud.show_message("%s cleared — the Rift Gate is open" % module.display_name())
	_refresh_run_hud()


func _enemies_alive_in(room_index: int) -> int:
	var alive: int = 0
	for enemy: PrototypeGraveblade in room_enemies[room_index]:
		if enemy.is_alive():
			alive += 1
	return alive


## The one guaranteed reward. It is placed in the reward room's own alcove —
## on the only path between the room and its gate — rather than where the last
## enemy happened to fall, so a player walking out cannot miss it. That is the
## geometry doing the teaching instead of a prompt.
func _place_run_reward(module: RogueliteRoomModule) -> void:
	var record: PrototypeWeaponData = load(EXPEDITION_BLADE_PATH) as PrototypeWeaponData
	var drop: FirstMvpItemDrop = (load(ITEM_DROP_SCRIPT) as GDScript).new()
	drop.name = "GuaranteedRunReward"
	drop.weapon = record
	drop.interaction_range = ITEM_INTERACTION_RANGE
	$Actors.add_child(drop)
	var near: Vector3 = _reward_position(module)
	var resolved: Dictionary = PrototypeGroundPointer.resolve_to_navigation(navigation_map(), near)
	drop.global_position = Vector3(resolved["point"].x, 0.0, resolved["point"].z)
	_active_drop = drop
	_drop_granted = true
	hud.show_message("The %s left something behind — %s" % [
		module.display_name(), record.display_name,
	])
	log_event("guaranteed reward", "%s placed on the way to the Rift Gate" % record.display_name)


## ON the line the player walks to the gate, but a stated distance SHORT of it
## — near enough that leaving without seeing the item takes effort, far enough
## that reaching for it cannot trigger the gate. See `REWARD_GATE_CLEARANCE`.
func _reward_position(module: RogueliteRoomModule) -> Vector3:
	var gate: Vector3 = module.exit_point()
	var centres: Array[Vector3] = module.room_centres()
	var nearest: Vector3 = centres[0]
	for centre: Vector3 in centres:
		if centre.distance_to(gate) < nearest.distance_to(gate):
			nearest = centre
	var back: Vector3 = _planar(nearest - gate)
	if back.length() < 0.01:
		back = -route_forward()
	return gate + back.normalized() * REWARD_GATE_CLEARANCE


func _clear_active_drop(reason: String) -> void:
	if _active_drop == null:
		return
	log_event("ground item removed", reason)
	_active_drop.queue_free()
	_active_drop = null
	hud.show_item_prompt("")


## Extends the base rather than replacing it: the base already equips through
## the loadout, reports it, and frees the drop. This adds the one run-scoped
## fact the base has no concept of.
func on_weapon_equipped(drop: FirstMvpItemDrop) -> void:
	super(drop)
	run_state.reward_equipped = true
	_refresh_run_hud()


## Overrides the base, which always reports `graveblades[0]`. The item
## comparison's "Hits to this Graveblade" row reads this, so with a mixed
## roster the base would quote the wrong enemy's Life. In the reward room this
## returns 300, which is exactly the accepted three-Hit-to-two-Hit proof.
func graveblade_max_life() -> float:
	if loop_state == LoopState.IN_RUN:
		var group: Array = room_enemies[run_state.current_room_index]
		if not group.is_empty():
			var first: PrototypeGraveblade = group[0]
			if first.data != null:
				return first.data.max_life
	return super()


# --- Death, abandon, and the run reset --------------------------------------

## Overrides the base completely. The base returns the player to Broken Watch's
## entry and DELIBERATELY PRESERVES the drop latch, the rewarded set, the
## ground item, the loadout and the completion flag — the exact opposite of
## what a run reset means. Here, death or abandonment returns to the Nexus and
## throws the entire `RogueliteRunState` away.
##
## The reset is by REPLACEMENT, not by clearing fields one at a time: a
## `clear()` that forgets a field is how a stale reward survives a reset, and
## the project has already been bitten by exactly that.
func restart_current_slice(reason: String) -> void:
	log_event("run ended", reason)
	player.revive_for_testing()
	attack_coordinator.reset()
	_soft_target = null

	## Cancel any Fallen the inherited delay has already armed. Without this,
	## pressing F5 inside the 0.90 s window between the killing blow and the
	## overlay returned the player to the Nexus and THEN opened a Fallen screen
	## over a living, full-Life character standing in the safe hub.
	_fallen_countdown = -1.0
	_pending_fallen_event = null
	if fallen_overlay.is_open:
		fallen_overlay.close("run reset")

	# The temporary reward is run-scoped in BOTH senses: the equipped weapon
	# goes back to the Worn Blade, and the item stops being owned at all,
	# because the loadout that owned it no longer exists. Shared with
	# `_begin_run()` so the two paths cannot drift.
	_reset_run_scoped_state()

	## Advanced HERE and nowhere else. Advancing in both this and `_begin_run()`
	## skipped an identifier on every death, so the id the Nexus advertised was
	## never the id that was played.
	plan = plan.next()
	run_state = RogueliteRunState.new(plan)
	loop_state = LoopState.HUB

	_enter_hub(reason)
	hud.show_message("Returned to the Nexus. Temporary rewards are gone.")
	log_event("run reset", "%s — next run is %s" % [run_state.describe(), plan.run_id()])


## CLEARING `_rewarded_enemies` BELONGS HERE, NOT AT THE CALL SITES, AND THE
## REVIEW'S OWN VERIFICATION IS WHAT PROVED IT. That dictionary is the
## already-counted set behind the room-clear test; every enemy this function
## revives is alive again, so its next death is a NEW event and it must not
## still be counted. It was originally cleared only in `restart_current_slice()`
## — which meant a second run entered from a COMPLETED run kept every kill from
## the first, refused every death as a duplicate, and could never clear a room
## again. The invariant is "a reset enemy has not been counted", and the only
## place that can hold it is the function that does the resetting.
func _reset_all_encounters() -> void:
	_rewarded_enemies.clear()
	for index: int in room_modules.size():
		room_modules[index].set_exit_gate_open(false)
		for enemy: PrototypeGraveblade in room_enemies[index]:
			enemy.reset_encounter()
			# `reset_encounter()` restores Life, position, layers and the
			# target area but deliberately does NOT touch `ai_enabled`.
			enemy.set_ai_enabled(false)
			enemy.visible = true


# --- Inherited overrides that would otherwise read a null layout ------------

## The base reads Riftfall Landing's centreline. Here the route direction is
## the ACTIVE module's own local -Z, rotated into the world — measured in the
## module's local frame, which no composition yaw can move.
func route_forward() -> Vector3:
	if loop_state == LoopState.IN_RUN:
		return room_modules[run_state.current_room_index].route_forward()
	return hub_module.route_forward()


func set_grid_visible(value: bool) -> void:
	grid_visible = value
	for module: RogueliteRoomModule in all_modules:
		module.set_grid_visible(value)
	log_event("review grid", "visible=%s" % str(value))


func _any_modal_open() -> bool:
	return item_comparison.is_open or fallen_overlay.is_open or summary_panel.is_open


func _refresh_run_hud() -> void:
	if run_hud != null:
		run_hud.refresh()


func measurements() -> Dictionary:
	var footprint: float = 0.0
	var solids: int = 0
	var carves: int = 0
	for module: RogueliteRoomModule in all_modules:
		footprint += module.footprint_area()
		solids += module.solid_count()
		carves += module.carve_count()
	return {
		"run_id": plan.run_id(),
		"seed": plan.seed_value,
		"modules": all_modules.size(),
		"expedition_rooms": room_modules.size(),
		"footprint_total": footprint,
		"solid_count": solids,
		"carve_count": carves,
		"navmesh_polygons": navmesh_polygon_count,
		"navmesh_area": navmesh_area,
		"bake_count": bake_count,
		"enemies": graveblades.size(),
		"runs_started": runs_started,
		"runs_completed": runs_completed,
		"transitions": transitions,
	}


## Overrides the base's `[broken-watch]` prefix. A log line is evidence, and a
## line that names the wrong space is a line a future reader will believe.
func log_event(kind: String, detail: String) -> void:
	var line: String = "[roguelite] %-24s %s" % [kind, detail]
	log_lines.append(line)
	print(line)


## Overrides the base so `--verify-1d` can never start Gate 1D's own suite in
## this scene, and so this review's suite has its own flag.
func _maybe_start_verification() -> void:
	var arguments: PackedStringArray = OS.get_cmdline_user_args()
	if not arguments.has("--verify-loop"):
		return
	var script: GDScript = load(RUNTIME_VERIFICATION_SCRIPT) as GDScript
	var runner: Node = Node.new()
	runner.name = "RogueliteCoreLoopVerification"
	runner.set_script(script)
	runner.set("loop", self)
	runner.set("arguments", arguments)
	add_child(runner)
