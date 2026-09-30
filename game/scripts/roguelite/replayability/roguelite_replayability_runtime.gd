class_name RogueliteReplayabilityRuntime
extends RogueliteCoreLoopRuntime
## Riftwrought — the ISOLATED ROGUELITE REPLAYABILITY V1 REVIEW (D-222).
##
## Nexus -> Rift Gate -> a SEEDED route of three authored rooms -> a choice of
## exactly two temporary rewards -> elite -> Nexus. The smallest honest version
## of "two runs can feel different", built to be PLAYED and judged.
##
## THE QUESTION IT EXISTS TO MAKE ASKABLE: does a seeded route through a small
## authored library make two expeditions feel different, using the combat the
## project owner has already accepted?
##
##
## WHY THIS EXTENDS THE ACCEPTED CORE LOOP AND THEN OVERRIDES ITS `_ready()`
## ----------------------------------------------------------------------
## `RogueliteCoreLoopRuntime` is the accepted, playtested loop: the walk-in
## gate test, the room transitions, the guaranteed reward placement and its
## measured clearance from the gate, the run-scoped reset both the death path
## and the success path share, the Nexus restore, the teleport contract, the
## camera fix, the already-counted set keyed on the node that emitted the
## signal, the Fallen cancellation, and the whole Gate 1D inheritance beneath
## it. Re-implementing any of that would be a second subtly different copy of
## an accepted thing, which this project has recorded the cost of more than
## once. So this review EXTENDS it and inherits all of it.
##
## It overrides `_ready()` and deliberately does NOT call `super._ready()` for
## exactly one reason: the accepted assembly hard-codes `RogueliteRunPlan` (the
## authored fixed order) and `RogueliteRoomModule` (the four accepted records),
## and those two classes are precisely what a replayability review has to
## replace. Every other line of the accepted assembly is reached here by
## calling the same inherited helpers in the same order —
## `_configure_navigation()`, `bake_navigation()`, `_spawn_player_in_hub()`,
## `_spawn_combat_kernel()`, `_build_nameplate()`, `_enter_hub()` — rather than
## by copying their bodies. The base is not edited and stays byte-identical;
## the core loop's own runner fingerprints it on every run.
##
##
## WHAT IS ACTUALLY NEW, AND IT IS FOUR THINGS
## -------------------------------------------
##   1. A LIBRARY. Nine authored greybox rooms in three beats
##      (`RogueliteRoomLibrary`), read by `RogueliteVariantRoomModule`, which
##      overrides exactly one function of the accepted module builder.
##   2. A SEEDED SELECTION. `RogueliteSeededRunPlan` replaces the one function
##      the accepted plan named as the seam, and nothing else.
##   3. A CHOICE. One temporary reward, offered as exactly two readable
##      options, of which one is the accepted Expedition Blade so the
##      established 100 -> 150 damage / three-Hit -> two-Hit proof survives
##      intact and is still verified through the accepted comparison panel.
##   4. TWO DISPLAY LINES. The selected room sequence and the active boon, on
##      the accepted banner and in the accepted run summary.
##
## EVERY ROOM IS BUILT ONCE, UP FRONT, AND THE BAKE HAPPENS EXACTLY ONCE. All
## ten modules exist from assembly; a run SELECTS three of them. That is what
## lets consecutive expeditions in one session take different routes without a
## rebuild or a second navigation bake — which is the difference between a
## review the owner can actually compare two runs in and one that needs a
## relaunch to say anything.
##
##
## WHAT IS DELIBERATELY NOT HERE
## -----------------------------
## No branching route, no optional room, no random terrain, no endless mode, no
## room-count scaling, no difficulty curve, no Run Graph, no Dungeon Recipe, no
## connector solving, no procedural generation of any kind. No saving — this
## scene constructs no store and names no storage path. No permanent
## progression, no meta-progression, no run currency, no unlocks, no
## experience, no Passive Web, no Rift Shards or Rift Echo, no Augments, no
## Forge, no crafting, no Archive, no Vault, no Reliquary, no dialogue, no NPC,
## no boss, no new enemy family, no Elite Modifier, no random loot, no affix,
## no ailment, no new asset, no art pass, no audio, and no new InputMap action.
##
## Run it directly (it is NOT the project entrypoint and must never become one):
##   /Applications/Godot.app/Contents/MacOS/Godot --path game \
##     res://scenes/roguelite/roguelite_replayability_review.tscn
##
## Optional: `-- --seed 12345` to enter a named run.
## Controls are Gate 1D's, unchanged: left click move, right mouse / (X) Quick
## Strike, Shift attack in place, Enter / (A) inspect a ground item, F5 abandon
## the run. Review keys are PHYSICAL: F6 grid, F7 next seeded route (in the
## Nexus only), `[` `]` camera distance, `\` reset.

const REPLAY_VERIFICATION_SCRIPT: String = "res://tests/roguelite_replayability_verification.gd"

const VARIANT_MODULE_SCRIPT: String = "res://scripts/roguelite/replayability/roguelite_variant_room_module.gd"
const REPLAY_HUD_SCRIPT: String = "res://scripts/roguelite/replayability/roguelite_replayability_hud.gd"
const REPLAY_SUMMARY_SCRIPT: String = "res://scripts/roguelite/replayability/roguelite_replayability_summary_panel.gd"
const BOON_PANEL_SCRIPT: String = "res://scripts/roguelite/replayability/roguelite_boon_choice_panel.gd"

## Where every module is placed, in the shared `Composition` frame. Modules are
## DISJOINT and never touch: a room is ENTERED THROUGH ITS GATE, not walked
## into from the previous room, which is exactly what makes each one
## independently selectable. The library is laid out as one column per beat and
## one row per variant, purely so the overhead review frame reads as a library
## rather than as a maze; nothing in the game depends on the arrangement.
##
## The narrowest gap between any two modules' occupied rectangles is measured
## by the verification rather than asserted here, because a placement typed by
## hand is exactly the kind of number that drifts.
const LIBRARY_PLACEMENTS: Dictionary = {
	&"nexus_hub": Vector2(0.0, 0.0),

	&"opening_long_hall": Vector2(68.0, 0.0),
	&"opening_pillar_court": Vector2(68.0, -68.0),
	&"opening_dogleg": Vector2(68.0, -136.0),

	&"reward_alcove": Vector2(136.0, 0.0),
	&"reward_spine": Vector2(136.0, -68.0),
	&"reward_crossing": Vector2(136.0, -136.0),

	&"elite_broad_hall": Vector2(204.0, 0.0),
	&"elite_split": Vector2(204.0, -68.0),
	&"elite_pinch": Vector2(204.0, -136.0),
}

## How long the cache waits after the last enemy falls before the choice panel
## opens. It exists for two reasons and both matter: it lets the kill land
## before the world pauses, and — more importantly — it keeps a modal out of a
## MECHANICAL CALL STACK. The project has already measured presentation built
## inside a `took_damage` handler pushing an enemy's own death animation
## measurably later.
const BOON_CHOICE_DELAY: float = 0.75

## Every module in the library, by id. `all_modules` (inherited) holds the same
## nodes; this is the lookup a selection needs.
var variant_modules: Dictionary = {}

## Every module's own enemies, by module id. `room_enemies` (inherited) is
## re-pointed at three of these entries when a run is selected, and
## `graveblades` (inherited) holds every enemy in the scene because the
## inherited targeting and hover code reads that list.
var _enemies_by_module: Dictionary = {}

## The boon chosen this run, or null. Run-scoped in the strictest sense: the
## shared `_reset_run_scoped_state()` throws it away and zeroes its effect, and
## BOTH the death path and the success path pass through that one function.
var run_boon: RogueliteRunBoon = null

## The boon the LAST COMPLETED run was taken with, kept only so the run-summary
## panel can report a run whose state has already been cleared — the accepted
## panel is opened after the reset, on purpose, because the Nexus banner behind
## it must already be telling the truth.
var completed_run_boon: RogueliteRunBoon = null

var boon_panel: RogueliteBoonChoicePanel

## Instrumentation, in the same spirit as the accepted runtime's own counters.
var boons_offered: int = 0
var boons_taken: int = 0
var routes_selected: int = 0
var route_reselections: int = 0

var _boon_delay: float = -1.0
var _boon_pending: bool = false

## Set when a room's gate OPENS while the player is already standing inside its
## trigger circle. See `_check_exit()`.
var _gate_needs_rearm: bool = false


# --- Assembly ---------------------------------------------------------------

## Deliberately does NOT call `super._ready()`. See the class header: the
## accepted assembly hard-codes the plan class and the module class, and those
## two are exactly what this review replaces. Everything else is the same
## inherited helper called in the same order.
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

	var library_problem: String = RogueliteRoomLibrary.problem()
	assert(library_problem.is_empty(), "RogueliteReplayabilityRuntime: %s" % library_problem)

	plan = RogueliteSeededRunPlan.new(_seed_from_arguments(), 0)
	var plan_problem: String = plan.problem()
	assert(plan_problem.is_empty(), "RogueliteReplayabilityRuntime: %s" % plan_problem)
	run_state = RogueliteRunState.new(plan)

	_build_modules()
	_configure_navigation()
	bake_navigation()

	_spawn_player_in_hub()
	_spawn_combat_kernel()
	_spawn_encounters()
	_apply_selection("assembled")

	hud.bind_room(self)
	item_comparison.bind_room(self)
	fallen_overlay.bind_room(self)
	_build_run_surfaces()

	camera_rig.set_target(player)
	camera_rig.reset_calibration()
	input_family.family_changed.connect(_on_family_changed)

	_build_nameplate()

	log_event("roguelite replayability v1", "isolated review assembled; writes nothing, loads no scene")
	log_event("room library", RogueliteRoomLibrary.describe())
	log_event("run plan", plan.describe())
	for module: RogueliteRoomModule in all_modules:
		log_event("module", (module as RogueliteVariantRoomModule).describe_variant())

	_enter_hub("assembled")

	await _await_navigation_synchronized()
	_maybe_start_verification()


## Overrides the accepted builder, which builds the hub plus the three modules
## of a fixed authored order. Here the WHOLE LIBRARY is built up front — the
## hub plus every variant of every beat — so a run is a SELECTION rather than a
## rebuild, and so consecutive expeditions in one session can take different
## routes without a second navigation bake.
func _build_modules() -> void:
	var script: GDScript = load(VARIANT_MODULE_SCRIPT) as GDScript
	hub_module = _build_variant_module(script, RogueliteRunPlan.HUB_MODULE)
	for beat: StringName in RogueliteRoomLibrary.BEAT_ORDER:
		for id: StringName in RogueliteRoomLibrary.variants_for(beat):
			variant_modules[id] = _build_variant_module(script, id)


func _build_variant_module(script: GDScript, id: StringName) -> RogueliteVariantRoomModule:
	assert(LIBRARY_PLACEMENTS.has(id), "RogueliteReplayabilityRuntime: %s has no placement" % id)
	var module: RogueliteVariantRoomModule = script.new() as RogueliteVariantRoomModule
	module.name = String(id).to_pascal_case()
	# Both are set BEFORE the node enters the tree: `module_id` because
	# `_ready()` builds from it, and `position` because `bake_rect()` is read by
	# `_configure_navigation()` in the same frame.
	module.module_id = id
	var at: Vector2 = LIBRARY_PLACEMENTS[id]
	module.position = Vector3(at.x, 0.0, at.y)
	nav_region.add_child(module)
	all_modules.append(module)
	return module


## Overrides the accepted spawner, which walks the three selected rooms. Here
## EVERY room in the library gets its enemies once, at assembly, all AI
## disabled — so entering a room is enabling AI, never instancing geometry, and
## a reselected route never has to spawn anything.
##
## WHICH ENEMY IS THE ELITE IS READ FROM THE MODULE'S OWN BEAT, NOT FROM A RUN
## INDEX. The accepted runtime could use the index because its route never
## changed; here it does, and an index-keyed Elite would move to whichever room
## happened to be third. Slot 0 of an elite-beat room is the Elite, wherever
## that room is placed and whichever run selects it.
func _spawn_encounters() -> void:
	var ordinary: GravebladeData = load(ORDINARY_DATA_PATH) as GravebladeData
	var elite: GravebladeData = load(ELITE_DATA_PATH) as GravebladeData
	for id: StringName in variant_modules:
		var module: RogueliteVariantRoomModule = variant_modules[id]
		var spawns: Array[Vector3] = module.spawn_points()
		var group: Array[PrototypeGraveblade] = []
		for slot: int in spawns.size():
			var is_elite: bool = module.is_elite_room() and slot == 0
			var enemy: PrototypeGraveblade = _spawn_room_enemy(
				"%s_Enemy%d" % [module.name, slot], spawns[slot],
				elite if is_elite else ordinary, module
			)
			## The MODULE is bound, not a room index. A run index is only
			## meaningful inside one route, and this review changes routes.
			enemy.died.connect(_on_variant_enemy_died.bind(module, enemy))
			group.append(enemy)
			graveblades.append(enemy)
		_enemies_by_module[id] = group


## Points the inherited `room_modules` / `room_enemies` at the three rooms this
## plan selected. Nothing is built, moved or spawned: the whole library already
## exists, and a "route" is three references into it.
func _apply_selection(reason: String) -> void:
	var seeded: RogueliteSeededRunPlan = plan as RogueliteSeededRunPlan
	assert(seeded != null, "RogueliteReplayabilityRuntime: the plan is not a seeded plan")
	var problem: String = seeded.problem()
	assert(problem.is_empty(), "RogueliteReplayabilityRuntime: %s" % problem)

	room_modules.clear()
	room_enemies.clear()
	for id: StringName in seeded.ordered_modules():
		room_modules.append(variant_modules[id])
		room_enemies.append(_enemies_by_module[id])
	routes_selected += 1
	log_event("route selected", "%s (%s)" % [seeded.describe(), reason])


func selected_ids() -> Array[StringName]:
	var ids: Array[StringName] = []
	for module: RogueliteRoomModule in room_modules:
		ids.append(module.module_id)
	return ids


func _build_run_surfaces() -> void:
	run_hud = (load(REPLAY_HUD_SCRIPT) as GDScript).new() as RogueliteReplayabilityHud
	run_hud.name = "RunHud"
	$CanvasLayer.add_child(run_hud)
	## Immediately after the combat HUD and BEFORE the modals — a CanvasLayer
	## draws its children in order, and appending put the accepted run banner on
	## top of the item comparison's own dim backdrop.
	$CanvasLayer.move_child(run_hud, 1)
	run_hud.bind_runtime(self)

	# The accepted roguelite Fallen overlay, reused unchanged: its copy already
	# reads "Return to the Nexus" and "F5 also abandons the run", which is
	# correct here word for word.
	var replacement: RogueliteFallenOverlay = (load(FALLEN_OVERLAY_SCRIPT) as GDScript).new() as RogueliteFallenOverlay
	replacement.name = "RogueliteFallenOverlay"
	var stale: FirstMvpFallenOverlay = fallen_overlay
	$CanvasLayer.add_child(replacement)
	replacement.bind_room(self)
	fallen_overlay = replacement
	stale.queue_free()

	summary_panel = (load(REPLAY_SUMMARY_SCRIPT) as GDScript).new() as RogueliteReplayabilitySummaryPanel
	summary_panel.name = "RunSummary"
	$CanvasLayer.add_child(summary_panel)
	summary_panel.bind_room(self)

	boon_panel = (load(BOON_PANEL_SCRIPT) as GDScript).new() as RogueliteBoonChoicePanel
	boon_panel.name = "BoonChoice"
	$CanvasLayer.add_child(boon_panel)
	boon_panel.bind_room(self)
	boon_panel.chosen.connect(_on_boon_chosen)


# --- The loop ---------------------------------------------------------------

## The selection is applied BEFORE the accepted `_begin_run()` runs, because
## that function immediately enters room 0 and would otherwise enter the
## previous route's first room. `plan` has already been advanced by whichever
## path ended the previous run, so the route the Nexus advertised is the route
## the expedition actually takes.
func _begin_run(reason: String) -> void:
	completed_run_boon = null
	_apply_selection("expedition started")
	super(reason)


## Overrides the accepted clear handler for the REWARD beat only; every other
## beat is the accepted behaviour, unchanged.
##
## THE ROOM IS NOT MARKED CLEARED UNTIL THE CHOICE IS MADE, AND THAT IS THE
## WHOLE REASON THIS OVERRIDE EXISTS RATHER THAN A CALL AFTER `super()`. The
## accepted `_check_exit()` decides whether the Rift Gate lets the player
## through by asking `run_state.is_cleared(index)`. Opening the gate first and
## the panel a moment later would let a player walk straight out during the
## delay and lose the guaranteed reward they had just earned, silently — the
## same shape as the defect where a reward was stranded 1.60 m inside a gate
## that triggers at 1.70 m. The gate opens when, and only when, the boon is
## taken.
func _on_room_cleared(room_index: int) -> void:
	if room_index != reward_beat_index():
		super(room_index)
		_arm_gate_guard(room_index)
		return
	if run_state.is_cleared(room_index) or _boon_pending:
		return
	_boon_pending = true
	_boon_delay = BOON_CHOICE_DELAY
	hud.show_message("%s cleared — the cache is opening" % room_modules[room_index].display_name())
	log_event("reward beat cleared", "the cache opens in %.2f s; the Rift Gate stays sealed until it is taken" % BOON_CHOICE_DELAY)
	_refresh_run_hud()


## A GATE THAT OPENS UNDER THE PLAYER'S FEET MUST NOT FIRE ON THE SAME STEP,
## AND THIS IS A REAL DEFECT THIS REVIEW'S OWN VERIFICATION FOUND RATHER THAN A
## PRECAUTION.
##
## The accepted `_check_exit()` is polled every idle frame and acts the moment a
## cleared room's gate is within `GATE_ENTER_RADIUS`. So a player who walked up
## to the sealed gate and killed the last enemy from there — or, far more
## easily here, who walked to the sealed gate and then took their boon — was
## teleported onward on the very next frame, and the guaranteed reward that had
## just been laid behind them was cleared by `_advance_room()` as "left
## behind". Measured: the drop was placed and gone within one frame, and the
## suite reported "taking the Expedition Blade placed no ground item".
##
## This is the same family as the accepted review's own critical defect, where
## the reward was dropped 1.60 m inside a gate that triggers at 1.70 m. The fix
## is the general one rather than a nudge to one position: when a gate opens
## while the player is already inside its trigger, it does nothing until they
## have STEPPED OUT of it once. Walking back in then works exactly as it always
## did, and a player who was nowhere near the gate never notices the guard
## exists.
func _check_exit(position: Vector3) -> void:
	if _gate_needs_rearm:
		if loop_state != LoopState.IN_RUN:
			_gate_needs_rearm = false
		elif _planar(position - room_modules[run_state.current_room_index].exit_point()).length() > GATE_ENTER_RADIUS:
			_gate_needs_rearm = false
			log_event("gate guard cleared", "the player stepped clear of the gate; it is live again")
		else:
			return
	super(position)


## Arms the guard above, but only when it is actually needed: the player is
## inside the trigger of the gate that has just opened.
func _arm_gate_guard(index: int) -> void:
	var gate: Vector3 = room_modules[index].exit_point()
	_gate_needs_rearm = _planar(player.global_position - gate).length() <= GATE_ENTER_RADIUS
	if _gate_needs_rearm:
		log_event("gate guard armed",
			"%s's gate opened with the player already inside it; step clear to use it" % room_modules[index].display_name())


## Clears the guard on entering a room: a fresh room's gate is sealed and the
## player stands at its entry, so nothing is owed.
func _enter_room(index: int, reason: String) -> void:
	_gate_needs_rearm = false
	super(index, reason)


## Which room index carries the reward beat, derived from the library rather
## than written down, and cross-checked against the accepted constant so the
## two can never disagree silently.
func reward_beat_index() -> int:
	var index: int = RogueliteRoomLibrary.BEAT_ORDER.find(RogueliteRoomLibrary.REWARD_BEAT)
	assert(index == REWARD_ROOM_INDEX,
		"the reward beat is at %d but the accepted runtime rewards room %d" % [index, REWARD_ROOM_INDEX])
	return index


func elite_beat_index() -> int:
	var index: int = RogueliteRoomLibrary.BEAT_ORDER.find(RogueliteRoomLibrary.ELITE_BEAT)
	assert(index == ELITE_ROOM_INDEX,
		"the elite beat is at %d but the accepted runtime elites room %d" % [index, ELITE_ROOM_INDEX])
	return index


func awaiting_boon_choice() -> bool:
	return _boon_pending


func _tick_boon_delay(delta: float) -> void:
	if _boon_delay < 0.0:
		return
	_boon_delay -= delta
	if _boon_delay > 0.0:
		return
	_boon_delay = -1.0
	if not _boon_pending or boon_panel == null or boon_panel.is_open:
		return
	boons_offered += 1
	log_event("cache opened", "two temporary rewards offered; exactly one may be taken")
	boon_panel.open()


func _process(delta: float) -> void:
	super(delta)
	_tick_boon_delay(delta)


## The one place a boon is ever granted. It completes the reward beat by hand
## rather than through the accepted `_on_room_cleared()`, because that function
## would place the ground weapon for BOTH choices.
func _on_boon_chosen(kind: int) -> void:
	var index: int = reward_beat_index()
	_boon_pending = false
	_boon_delay = -1.0
	if run_state.is_cleared(index):
		log_event("boon refused", "the reward beat was already resolved this run")
		return
	if not run_state.mark_cleared(index):
		log_event("boon refused", run_state.last_refusal)
		return

	var module: RogueliteRoomModule = room_modules[index]
	module.set_exit_gate_open(true)
	_arm_gate_guard(index)
	run_boon = RogueliteRunBoon.of(kind)
	boons_taken += 1
	run_state.grant_reward()

	if run_boon.is_weapon():
		## The accepted path, completely unchanged: the weapon is laid on the
		## walked line a measured distance short of the gate, and the player
		## still inspects it, still reads the comparison, and still chooses to
		## equip it. That is what keeps the established 100 -> 150 damage /
		## three-Hit -> two-Hit proof verifiable rather than merely restated.
		_place_run_reward(module)
	else:
		player.set_increased_attack_speed(run_boon.increase())
		hud.show_message("%s — %s" % [run_boon.display_name(), boon_effect_line()])

	log_event("boon taken", "%s — %s" % [run_boon.describe(), boon_effect_line()])
	_refresh_run_hud()


## What the active boon actually does, measured from live state rather than
## written down: the weapon rows come from the records the comparison reads,
## and the action time comes from the kernel's own derived value.
func boon_effect_line() -> String:
	if run_boon == null or run_boon.is_none():
		return ""
	if run_boon.is_weapon():
		var blade: PrototypeWeaponData = expedition_blade_record()
		var life: float = graveblade_max_life()
		if not run_state.reward_equipped:
			return "Waiting on the ground — inspect it and equip it to use it"
		return "Quick Strike %.0f Physical · %d Hit(s) to a %.0f-Life Graveblade" % [
			blade.physical_damage, blade.hits_to_defeat(life), life,
		]
	var strike: QuickStrikeData = canonical_quick_strike_record()
	return "Quick Strike action time %.2f s → %.2f s (+%.0f%% attack speed)" % [
		strike.action_time, player.attack.effective_action_time(),
		player.increased_attack_speed() * 100.0,
	]


## Captured BEFORE the accepted completion runs, because that path clears the
## run's state on purpose — the Nexus banner behind the summary must already be
## telling the truth about what the player is holding.
func _complete_run() -> void:
	completed_run_boon = run_boon
	super()


# --- The run-scoped reset ---------------------------------------------------

## Extends the accepted reset rather than replacing it. The accepted function
## already clears the ground item, the drop latch, every encounter and the
## loadout, and it is reached by BOTH the death path and the success path and
## by the start of every run. Adding the boon here — rather than at the three
## call sites — is the same discipline the accepted runtime recorded when it
## moved the reward reset out of the death path: a reset that lives in one
## place cannot forget a field on one route and remember it on another.
func _reset_run_scoped_state() -> void:
	super()
	run_boon = null
	_boon_pending = false
	_boon_delay = -1.0
	_gate_needs_rearm = false
	## The established field, returned to the established baseline. This is the
	## same call the boon uses to apply, so nothing else can be left behind.
	player.set_increased_attack_speed(0.0)
	if boon_panel != null and boon_panel.is_open:
		boon_panel.close("run reset")


## Overrides the accepted reset, which walks the three SELECTED rooms. Here the
## whole library must be reset: a room that was cleared in a previous run and
## is not in the current route would otherwise keep its dead enemies and its
## open gate, and would be re-entered already finished the next time a seed
## chose it.
func _reset_all_encounters() -> void:
	_rewarded_enemies.clear()
	for id: StringName in variant_modules:
		var module: RogueliteVariantRoomModule = variant_modules[id]
		module.set_exit_gate_open(false)
		for enemy: PrototypeGraveblade in _enemies_by_module[id]:
			enemy.reset_encounter()
			# `reset_encounter()` restores Life, position, layers and the target
			# area but deliberately does NOT touch `ai_enabled`.
			enemy.set_ai_enabled(false)
			enemy.visible = true


# --- Encounters -------------------------------------------------------------

## The accepted handler, with the room resolved from the MODULE that emitted
## the signal rather than from a bound index. The already-counted set is still
## keyed on the node itself, which is the correction the accepted runtime made
## after keying it on `DamageEvent.source` — the ATTACKER — refused every kill
## after the first as a duplicate.
func _on_variant_enemy_died(
	_event: DamageEvent, module: RogueliteVariantRoomModule, enemy: PrototypeGraveblade
) -> void:
	if _rewarded_enemies.has(enemy.get_instance_id()):
		log_event("clear check refused", "duplicate kill signal from %s" % enemy.name)
		return
	_rewarded_enemies[enemy.get_instance_id()] = true
	var index: int = room_modules.find(module)
	if index == -1:
		log_event("clear check refused", "%s is not in the selected route" % module.name)
		return
	log_event("enemy defeated", "%s in room %d (%s)" % [enemy.name, index + 1, module.display_name()])
	if _enemies_alive_in(index) > 0:
		_refresh_run_hud()
		return
	_on_room_cleared(index)


# --- Records the surfaces read ----------------------------------------------

func worn_blade_record() -> PrototypeWeaponData:
	return load(WORN_BLADE_PATH) as PrototypeWeaponData


func expedition_blade_record() -> PrototypeWeaponData:
	return load(EXPEDITION_BLADE_PATH) as PrototypeWeaponData


## The authored Quick Strike record the kernel keeps beside its private runtime
## copy. Read from the live action rather than loaded again, so the panel can
## never quote a record the running game is not obeying.
func canonical_quick_strike_record() -> QuickStrikeData:
	var canonical: QuickStrikeData = player.attack.canonical_data
	assert(canonical != null, "RogueliteReplayabilityRuntime: the Quick Strike action has no canonical record")
	return canonical


# --- Review controls --------------------------------------------------------

## F7 advances to the NEXT seeded route without leaving the Nexus, so two runs
## can be compared without relaunching. It is the SAME deterministic successor
## `plan.next()` that a completed or abandoned run already takes, so the whole
## session stays reproducible from the launch seed; it is refused inside a run,
## because changing the route under a player standing in room two would be a
## different thing entirely.
##
## It is a PHYSICAL key, exactly like F6, `[`, `]` and `\`. No InputMap action
## is declared: Gate B, Gate E and Gate F each emit one assertion per key
## event, so a single new action would silently move three locked counts.
func _handle_review_keys(event: InputEvent) -> void:
	var key: InputEventKey = event as InputEventKey
	if key != null and key.pressed and not key.echo and key.physical_keycode == KEY_F7:
		_reroll_route()
		return
	super(event)


func _reroll_route() -> void:
	if loop_state == LoopState.IN_RUN:
		hud.show_message("Finish or abandon this expedition before changing the route")
		log_event("route reselection refused", "an expedition is in progress")
		return
	plan = plan.next()
	run_state = RogueliteRunState.new(plan)
	loop_state = LoopState.HUB
	route_reselections += 1
	_apply_selection("F7 in the Nexus")
	hud.show_message("Next route: %s" % (plan as RogueliteSeededRunPlan).route_line())
	_refresh_run_hud()


func _any_modal_open() -> bool:
	return super() or (boon_panel != null and boon_panel.is_open)


func measurements() -> Dictionary:
	var measured: Dictionary = super()
	measured["library_rooms"] = RogueliteRoomLibrary.VARIANTS.size()
	measured["beats"] = RogueliteRoomLibrary.BEAT_ORDER.size()
	measured["possible_routes"] = RogueliteRoomLibrary.total_routes()
	measured["route"] = (plan as RogueliteSeededRunPlan).route_line()
	measured["boons_offered"] = boons_offered
	measured["boons_taken"] = boons_taken
	measured["routes_selected"] = routes_selected
	measured["route_reselections"] = route_reselections
	return measured


## Overrides the accepted prefix. A log line is evidence, and a line that names
## the wrong review is a line a future reader will believe.
func log_event(kind: String, detail: String) -> void:
	var line: String = "[replayability] %-24s %s" % [kind, detail]
	log_lines.append(line)
	print(line)


## Overrides the accepted starter so neither `--verify-1d` nor `--verify-loop`
## can start another review's suite in this scene, and so this review's suite
## has its own flag.
func _maybe_start_verification() -> void:
	var arguments: PackedStringArray = OS.get_cmdline_user_args()
	if not arguments.has("--verify-replay"):
		return
	var script: GDScript = load(REPLAY_VERIFICATION_SCRIPT) as GDScript
	var runner: Node = Node.new()
	runner.name = "RogueliteReplayabilityVerification"
	runner.set_script(script)
	runner.set("loop", self)
	runner.set("arguments", arguments)
	add_child(runner)
