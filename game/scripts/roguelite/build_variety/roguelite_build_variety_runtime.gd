class_name RogueliteBuildVarietyRuntime
extends RogueliteReplayabilityRuntime
## Riftwrought — the ISOLATED ROGUELITE BUILD VARIETY V1 REVIEW (D-223).
##
## Nexus -> Rift Gate -> a seeded route of three authored rooms -> TWO seeded
## temporary-upgrade choices, one after the opening room and one after the
## reward room -> elite -> Nexus. The smallest honest version of "two runs can
## PLAY differently", built to be PLAYED and judged.
##
## THE QUESTION IT EXISTS TO MAKE ASKABLE: do temporary upgrade COMBINATIONS
## create meaningfully different play styles, using the rooms, enemies, gates,
## combat and reset behaviour the project owner has already accepted?
##
##
## WHAT IT ADDS TO THE ACCEPTED D-222 REVIEW, AND NOTHING ELSE
## ---------------------------------------------------------------------------
##   * A SECOND choice moment. D-222 offered one, after the reward room; this
##     offers one after the opening room as well. Both are cache beats and both
##     use the same sealed-gate rule.
##   * A POOL OF FOUR instead of a fixed pair, offered two at a time, never
##     repeating what is held.
##   * TWO SPATIAL upgrades — reach and release arc — which are the two
##     properties a player can feel in where they stand rather than in a number.
##   * A brief on-ground outline of the swing that actually happened, so those
##     two are judgeable by eye (`RogueliteStrikeEnvelope`).
##   * The four live values on the banner, and a build summary at the end.
##
## IT ADDS NO ROOM, NO ENEMY, NO BEAT AND NO CATEGORY. The nine authored rooms,
## the fifteen enemies, the three beats, the seeded route selection, the gate
## rule, the reward placement, the Nexus, the death path, the abandon path and
## every control are D-222's and D-220's, inherited and unedited.
##
##
## WHY IT OVERRIDES `_ready()` AND DELIBERATELY DOES NOT CALL `super()`
## ---------------------------------------------------------------------------
## For the third time in this chain, and for the same reason each time: the
## parent's assembly constructs its plan class BY NAME —
## `plan = RogueliteSeededRunPlan.new(...)` — and that class is precisely what a
## build-variety review has to replace, because offers come off the same seed as
## rooms. A constructor call is not virtual, so there is no override that can
## redirect it. Every OTHER line of the accepted assembly is reached here by
## calling the same inherited helpers in the same order, and every one of them
## dispatches to this class's overrides where it has any.
##
## `_build_run_surfaces()` is overridden without `super()` for the same shape of
## reason: the parent binds three script paths as CONSTANTS naming the D-222
## surfaces, and a subclass cannot redirect a parent's constant.
##
##
## HOW AN UPGRADE REACHES THE COMBAT QUERY, AND WHY NO KERNEL IS EDITED
## ---------------------------------------------------------------------------
## `QuickStrikeAction` takes a PRIVATE runtime copy of its record the moment it
## enters the tree and keeps the authored one beside it read-only (D-191). That
## private copy is the object `TargetAcquisition.resolve_release()` is handed on
## every swing. So an upgrade writes ONE FIELD of it and the query changes with
## it — no kernel edit, no new modifier type, no second formula, and
## `data/prototype_zero/quick_strike.tres` never written to at all.
##
##   Expedition Blade  -> the accepted ground drop and `PlayerLoadout` doors
##   Quickened Edge    -> `player.set_increased_attack_speed()`
##   Reaching Edge     -> `data.reach`
##   Sweeping Edge     -> `data.release_arc_degrees` (+ the soft-target cone)
##
## THE FOUR WRITE FOUR DIFFERENT FIELDS, WHICH IS WHY ANY TWO COEXIST BY
## CONSTRUCTION rather than by arrangement. There is no combination table, no
## ordering rule and no interaction code, because there is nothing for two
## upgrades to contend over.
##
## RESTORATION IS FROM THE CANONICAL RECORD, NEVER FROM A CAPTURED BASELINE, and
## that is D-191's own rule rather than a preference: Gate F captured a baseline
## from the shared record, scaled it in place, and every later room scaled the
## already-scaled numbers — 78.0 deg, then 93.6, then 112.3. Reading the
## authored value back out of `canonical_data` on every reset makes compounding
## structurally impossible.
##
##
## WHAT IS DELIBERATELY NOT HERE
## ---------------------------------------------------------------------------
## No new room, no room category, no room enlargement, no crowd-scale test, no
## new enemy, no boss, no upgrade level, no rank, no rarity, no reroll, no shop,
## no currency, no skill tree, no permanent unlock, no saving, no permanent or
## meta progression, no procedural generation, no Run Graph, no Dungeon Recipe,
## no branching, no depth scaling, no asset, no art pass, no shader, no VFX
## polish, no audio, no dialogue, no new InputMap action, and no change to the
## project entrypoint.
##
## Run it directly (it is NOT the project entrypoint and must never become one):
##   /Applications/Godot.app/Contents/MacOS/Godot --path game \
##     res://scenes/roguelite/roguelite_build_variety_review.tscn
##
## Optional: `-- --seed 12345`. Controls are Gate 1D's, unchanged. Review keys
## are PHYSICAL: F6 grid, F7 next seeded route (Nexus only), F8 the swing
## outline, `[` `]` camera distance, `\` reset, F5 abandon the run.

const BUILD_VERIFICATION_SCRIPT: String = "res://tests/roguelite_build_variety_verification.gd"

const VARIETY_HUD_SCRIPT: String = "res://scripts/roguelite/build_variety/roguelite_build_variety_hud.gd"
const VARIETY_SUMMARY_SCRIPT: String = "res://scripts/roguelite/build_variety/roguelite_build_variety_summary_panel.gd"
const CHOICE_PANEL_SCRIPT: String = "res://scripts/roguelite/build_variety/roguelite_upgrade_choice_panel.gd"
const STRIKE_ENVELOPE_SCRIPT: String = "res://scripts/roguelite/build_variety/roguelite_strike_envelope.gd"

## The temporary build this expedition holds. Run-scoped in the strictest sense:
## the shared `_reset_run_scoped_state()` REPLACES it and returns every combat
## value to the authored baseline, and death, abandon, completion and the start
## of the next run all pass through that one function.
var build: RogueliteBuildState = null

## The build the LAST COMPLETED run finished with, kept only so the run-summary
## panel can report a run whose state has already been cleared — the accepted
## panel is opened after the reset, on purpose, because the Nexus banner behind
## it must already be telling the truth.
var completed_build: RogueliteBuildState = null

var choice_panel: RogueliteUpgradeChoicePanel
var strike_envelope: RogueliteStrikeEnvelope

## Instrumentation, in the same spirit as every other counter in this chain.
var choices_offered: int = 0
var upgrades_taken: int = 0
var duplicate_offers_refused: int = 0
## Records an `acquire()` that was refused after a choice was committed. It
## cannot happen — offers are drawn from `available()` — so it is asserted EMPTY
## rather than trusted, the same way Gate 1E recorded `unimplemented_live_nodes`
## instead of asserting in a branch that a release build would strip.
var refused_acquisitions: PackedStringArray = PackedStringArray()

## The offer currently on screen, or the last one shown. Read by the checks.
var last_offer: Array[int] = []

var _choice_pending: bool = false
var _choice_delay: float = -1.0
var _pending_choice_index: int = 0
var _pending_room_index: int = -1


# --- Assembly ---------------------------------------------------------------

## Deliberately does NOT call `super()`. See the class header.
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
	assert(library_problem.is_empty(), "RogueliteBuildVarietyRuntime: %s" % library_problem)

	plan = RogueliteBuildVarietyRunPlan.new(_seed_from_arguments(), 0)
	var plan_problem: String = plan.problem()
	assert(plan_problem.is_empty(), "RogueliteBuildVarietyRuntime: %s" % plan_problem)
	run_state = RogueliteRunState.new(plan)
	build = RogueliteBuildState.new()

	_build_modules()
	_configure_navigation()
	bake_navigation()

	_spawn_player_in_hub()
	_spawn_combat_kernel()
	_spawn_encounters()
	_apply_selection("assembled")
	_build_strike_envelope()

	hud.bind_room(self)
	item_comparison.bind_room(self)
	fallen_overlay.bind_room(self)
	_build_run_surfaces()

	camera_rig.set_target(player)
	camera_rig.reset_calibration()
	input_family.family_changed.connect(_on_family_changed)

	_build_nameplate()

	log_event("roguelite build variety v1", "isolated review assembled; writes nothing, loads no scene")
	log_event("room library", RogueliteRoomLibrary.describe())
	log_event("upgrade pool", "%d temporary upgrade(s): %s" % [
		RogueliteUpgrade.POOL.size(), ", ".join(_pool_names()),
	])
	log_event("run plan", plan.describe())
	log_event("baseline", "Quick Strike %s" % _values_line(baseline_combat_values()))

	_enter_hub("assembled")

	await _await_navigation_synchronized()
	_maybe_start_verification()


## THE SWING OUTLINE IS DRIVEN BY A SIGNAL THE ACCEPTED KERNEL ALREADY EMITS.
## `use_released` fires synchronously inside `QuickStrikeAction._fire_release()`
## immediately after the query, carrying the exact facing the query used — so
## the outline is drawn from the same frame's values without one line of the
## combat kernel being edited to make it possible.
func _build_strike_envelope() -> void:
	strike_envelope = (load(STRIKE_ENVELOPE_SCRIPT) as GDScript).new() as RogueliteStrikeEnvelope
	strike_envelope.name = "StrikeEnvelope"
	add_child(strike_envelope)
	player.attack.use_released.connect(_on_use_released)


func _on_use_released(_use_id: int, outcome: Dictionary) -> void:
	if strike_envelope == null or player == null:
		return
	strike_envelope.draw_for(
		player.global_position,
		float(outcome.get("facing_degrees", 0.0)),
		player.attack.data,
		canonical_quick_strike_record()
	)


## Overridden without `super()` because the parent binds three script paths as
## CONSTANTS naming the D-222 surfaces, and a subclass cannot redirect a
## parent's constant. The node names, the ordering and the `move_child` are the
## parent's exactly, so the inherited refresh and the accepted modal contract
## behave identically.
func _build_run_surfaces() -> void:
	run_hud = (load(VARIETY_HUD_SCRIPT) as GDScript).new() as RogueliteBuildVarietyHud
	run_hud.name = "RunHud"
	$CanvasLayer.add_child(run_hud)
	## Immediately after the combat HUD and BEFORE the modals — a CanvasLayer
	## draws its children in order, and appending put the accepted run banner on
	## top of the item comparison's own dim backdrop.
	$CanvasLayer.move_child(run_hud, 1)
	run_hud.bind_runtime(self)

	# The accepted roguelite Fallen overlay, reused unchanged: its copy already
	# reads "Return to the Nexus" and "F5 also abandons the run".
	var replacement: RogueliteFallenOverlay = (load(FALLEN_OVERLAY_SCRIPT) as GDScript).new() as RogueliteFallenOverlay
	replacement.name = "RogueliteFallenOverlay"
	var stale: FirstMvpFallenOverlay = fallen_overlay
	$CanvasLayer.add_child(replacement)
	replacement.bind_room(self)
	fallen_overlay = replacement
	stale.queue_free()

	summary_panel = (load(VARIETY_SUMMARY_SCRIPT) as GDScript).new() as RogueliteBuildVarietySummaryPanel
	summary_panel.name = "RunSummary"
	$CanvasLayer.add_child(summary_panel)
	summary_panel.bind_room(self)

	choice_panel = (load(CHOICE_PANEL_SCRIPT) as GDScript).new() as RogueliteUpgradeChoicePanel
	choice_panel.name = "UpgradeChoice"
	$CanvasLayer.add_child(choice_panel)
	choice_panel.bind_room(self)
	choice_panel.chosen.connect(_on_upgrade_chosen)

	## THE ACCEPTED D-222 BOON PANEL IS DELIBERATELY NOT BUILT, AND THE FIELD IS
	## NULLED RATHER THAN LEFT DANGLING. Its `build_contents()` asserts a fixed
	## two-item list this review does not use, and a second unused choice
	## surface in the tree is a thing a future reader would have to rule out.
	## Every inherited reference to it — `_tick_boon_delay()`,
	## `_reset_run_scoped_state()`, `_any_modal_open()` — is already null-
	## guarded, so nulling it is safe rather than merely convenient, and the
	## verification asserts BOTH that the field is null AND that no node of that
	## class exists anywhere in the tree, because a null field could have been
	## cleared while an absent node could not.
	boon_panel = null


static func _pool_names() -> PackedStringArray:
	var names: PackedStringArray = PackedStringArray()
	for kind: int in RogueliteUpgrade.POOL:
		names.append(RogueliteUpgrade.name_of(kind))
	return names


# --- The two choice moments -------------------------------------------------

## The opening beat's index, derived from the library rather than written down.
func opening_beat_index() -> int:
	return RogueliteRoomLibrary.BEAT_ORDER.find(RogueliteRoomLibrary.BEAT_OPENING)


## Which of the run's choices a room carries, or -1 for a room that carries
## none. Derived from the BEAT rather than from a literal index, exactly as
## D-222 derived eliteness from the beat rather than from a run index.
func choice_index_for_room(room_index: int) -> int:
	if room_index == opening_beat_index():
		return 0
	if room_index == reward_beat_index():
		return 1
	return -1


func awaiting_upgrade_choice() -> bool:
	return _choice_pending


## Overrides the accepted D-222 accessor so the INHERITED route panel still
## reports "cache open" at the right moments. This review never sets
## `_boon_pending`, so the inherited answer would always have been false.
func awaiting_boon_choice() -> bool:
	return _choice_pending


## Overrides the accepted clear handler for the two CACHE beats only; the elite
## beat is the inherited behaviour, unchanged, reached by calling `super()`.
##
## THE ROOM IS NOT MARKED CLEARED UNTIL THE CHOICE IS MADE. That is D-222's own
## rule, applied to both caches rather than one: the accepted `_check_exit()`
## decides whether the Rift Gate lets the player through by asking
## `run_state.is_cleared(index)`, so opening the gate first and the panel a
## moment later would let a player walk straight out during the delay and lose
## the upgrade they had just earned, silently.
func _on_room_cleared(room_index: int) -> void:
	var choice: int = choice_index_for_room(room_index)
	if choice < 0:
		super(room_index)
		return
	if run_state.is_cleared(room_index) or _choice_pending:
		return
	_choice_pending = true
	_pending_choice_index = choice
	_pending_room_index = room_index
	_choice_delay = BOON_CHOICE_DELAY
	hud.show_message("%s cleared — a cache is opening" % room_modules[room_index].display_name())
	log_event("cache armed", "choice %d of %d opens in %.2f s; the Rift Gate stays sealed until it is taken" % [
		choice + 1, RogueliteBuildVarietyRunPlan.CHOICES_PER_RUN, BOON_CHOICE_DELAY,
	])
	_refresh_run_hud()


func _process(delta: float) -> void:
	super(delta)
	_tick_choice_delay(delta)


func _tick_choice_delay(delta: float) -> void:
	if _choice_delay < 0.0:
		return
	_choice_delay -= delta
	if _choice_delay > 0.0:
		return
	_choice_delay = -1.0
	if not _choice_pending or choice_panel == null or choice_panel.is_open:
		return
	_open_choice()


## THE OFFER IS DRAWN FROM THE RUN'S OWN PLAN AND THE RUN'S OWN HELD SET. Both
## are passed to a pure function, so the same seed and the same held set always
## produce the same pair, and an upgrade already held cannot be drawn at all —
## there is no other list for the selection to choose from.
func _open_choice() -> void:
	var offering: RogueliteBuildVarietyRunPlan = run_state.plan as RogueliteBuildVarietyRunPlan
	assert(offering != null, "RogueliteBuildVarietyRuntime: the run's plan cannot offer upgrades")
	var offer: Array[int] = offering.offer_for(_pending_choice_index, build.acquired)
	for kind: int in offer:
		if build.held(kind):
			duplicate_offers_refused += 1
	last_offer = offer.duplicate()
	choices_offered += 1
	log_event("cache opened", "choice %d of %d — %s or %s" % [
		_pending_choice_index + 1, RogueliteBuildVarietyRunPlan.CHOICES_PER_RUN,
		RogueliteUpgrade.name_of(offer[0]), RogueliteUpgrade.name_of(offer[1]),
	])
	choice_panel.open_for(offer, _pending_choice_index, build.acquired)


## The one place an upgrade is ever granted.
func _on_upgrade_chosen(kind: int) -> void:
	var index: int = _pending_room_index
	_choice_pending = false
	_choice_delay = -1.0
	if index < 0 or index >= room_modules.size():
		log_event("upgrade refused", "no cache room is pending")
		return
	if run_state.is_cleared(index):
		log_event("upgrade refused", "that room's cache was already resolved this run")
		return
	if not run_state.mark_cleared(index):
		log_event("upgrade refused", run_state.last_refusal)
		return

	var module: RogueliteRoomModule = room_modules[index]
	## The gate opens with the choice and never before it, and the D-222 guard
	## is armed in the same breath so a gate that opens under the player's feet
	## does not fire on the same step.
	module.set_exit_gate_open(true)
	_arm_gate_guard(index)

	if build.acquire(kind):
		upgrades_taken += 1
		_apply_upgrade(kind, module)
		log_event("upgrade taken", "%s — build is now %s" % [
			RogueliteUpgrade.name_of(kind), build.build_line(),
		])
	else:
		## Unreachable by construction, and RECORDED rather than asserted: an
		## `assert()` is stripped from a release build, so a shipped build would
		## have opened the gate and granted nothing in silence. The gate is
		## opened above regardless, so a refusal cannot strand the run.
		refused_acquisitions.append("%s: %s" % [RogueliteUpgrade.name_of(kind), build.last_refusal])
		push_error("RogueliteBuildVarietyRuntime: %s" % build.last_refusal)
		log_event("upgrade refused", build.last_refusal)

	_refresh_run_hud()


## Writes exactly one property per upgrade, onto the action's PRIVATE runtime
## record — never onto the canonical authored one.
func _apply_upgrade(kind: int, module: RogueliteRoomModule) -> void:
	assert(player.attack.data_is_private(),
		"RogueliteBuildVarietyRuntime: the Quick Strike action has not taken its private record")
	var data: QuickStrikeData = player.attack.data
	match kind:
		RogueliteUpgrade.Kind.EXPEDITION_BLADE:
			## The accepted path, completely unchanged: the weapon is laid on
			## the walked line a measured distance short of the gate, and the
			## player still inspects it, still reads the comparison, and still
			## chooses to equip it. That is what keeps the established
			## 100 -> 150 damage / three-Hit -> two-Hit proof VERIFIABLE rather
			## than merely restated.
			run_state.grant_reward()
			_place_run_reward(module)
		RogueliteUpgrade.Kind.QUICKENED_EDGE:
			player.set_increased_attack_speed(RogueliteUpgrade.QUICKENED_INCREASE)
		RogueliteUpgrade.Kind.REACHING_EDGE:
			data.reach = RogueliteUpgrade.REACHING_EDGE_REACH
		RogueliteUpgrade.Kind.SWEEPING_EDGE:
			data.release_arc_degrees = RogueliteUpgrade.SWEEPING_EDGE_ARC_DEGREES
			data.soft_target_cone_degrees = RogueliteUpgrade.SWEEPING_EDGE_SOFT_CONE_DEGREES
		_:
			push_error("RogueliteBuildVarietyRuntime: %d is not an applicable upgrade" % kind)

	## The record checks itself after every write, so a review value that made
	## the kernel incoherent fails loudly here instead of quietly retuning
	## combat two rooms later.
	var problem: String = data.problem()
	assert(problem.is_empty(), "RogueliteBuildVarietyRuntime: %s" % problem)
	if not kind == RogueliteUpgrade.Kind.EXPEDITION_BLADE:
		hud.show_message("%s — %s" % [
			RogueliteUpgrade.name_of(kind), RogueliteUpgrade.summary_of(kind),
		])
	log_event("combat values", "Quick Strike %s" % _values_line(live_combat_values()))


# --- The live values every surface reads ------------------------------------

## THE FOUR NUMBERS, READ OFF THE KERNEL THE GAME IS ACTUALLY OBEYING. `data` is
## the private runtime record `TargetAcquisition.resolve_release()` is handed on
## every swing, and `physical_damage` reads the equipped weapon. Nothing here is
## derived from the upgrade list: a surface that recomputed these from "I hold a
## Reaching Edge" would agree with the list and could still disagree with the
## game.
func live_combat_values() -> Dictionary:
	var data: QuickStrikeData = player.attack.data
	var damage: float = player.physical_damage
	return {
		"damage": damage,
		"hits": _hits_to_defeat(damage),
		"action_time": player.attack.effective_action_time(),
		"reach": data.reach,
		"arc": data.release_arc_degrees,
		"soft_cone": data.soft_target_cone_degrees,
	}


## The authored baseline, read from the canonical records rather than captured.
func baseline_combat_values() -> Dictionary:
	var canonical: QuickStrikeData = canonical_quick_strike_record()
	var worn: PrototypeWeaponData = worn_blade_record()
	return {
		"damage": worn.physical_damage,
		"hits": worn.hits_to_defeat(graveblade_max_life()),
		"action_time": canonical.action_time,
		"reach": canonical.reach,
		"arc": canonical.release_arc_degrees,
		"soft_cone": canonical.soft_target_cone_degrees,
	}


## What the live values WOULD become if `kind` were taken now. The choice panel
## reads this for its "after" column, so the panel's arithmetic and the
## runtime's are the same arithmetic.
func projected_combat_values(kind: int) -> Dictionary:
	var values: Dictionary = live_combat_values()
	var canonical: QuickStrikeData = canonical_quick_strike_record()
	match kind:
		RogueliteUpgrade.Kind.EXPEDITION_BLADE:
			var blade: PrototypeWeaponData = expedition_blade_record()
			values["damage"] = blade.physical_damage
			values["hits"] = blade.hits_to_defeat(graveblade_max_life())
		RogueliteUpgrade.Kind.QUICKENED_EDGE:
			values["action_time"] = canonical.effective_action_time(RogueliteUpgrade.QUICKENED_INCREASE)
		RogueliteUpgrade.Kind.REACHING_EDGE:
			values["reach"] = RogueliteUpgrade.REACHING_EDGE_REACH
		RogueliteUpgrade.Kind.SWEEPING_EDGE:
			values["arc"] = RogueliteUpgrade.SWEEPING_EDGE_ARC_DEGREES
			values["soft_cone"] = RogueliteUpgrade.SWEEPING_EDGE_SOFT_CONE_DEGREES
	return values


func _hits_to_defeat(per_hit: float) -> int:
	var life: float = graveblade_max_life()
	if per_hit <= 0.0:
		return 0
	return int(ceil(life / per_hit))


static func _values_line(values: Dictionary) -> String:
	return "%.0f Physical · %.2f s · %.2f m · %.0f° arc · %.0f° soft cone" % [
		float(values.get("damage", 0.0)), float(values.get("action_time", 0.0)),
		float(values.get("reach", 0.0)), float(values.get("arc", 0.0)),
		float(values.get("soft_cone", 0.0)),
	]


## The one delivery nuance the banner needs: the Expedition Blade is the only
## upgrade that is not active the moment it is taken.
func build_effect_line() -> String:
	if build == null or not build.held(RogueliteUpgrade.Kind.EXPEDITION_BLADE):
		return ""
	if run_state.reward_equipped:
		return "Expedition Blade equipped"
	return "Expedition Blade waiting on the ground — inspect it and equip it to use it"


# --- The run-scoped reset ---------------------------------------------------

## Extends the accepted reset rather than replacing it. The inherited function
## already clears the ground item, the drop latch, every encounter, the loadout,
## the D-222 boon and the attack-speed field, and it is reached by the death
## path, the abandon path, the completion path AND the start of every run.
## Adding the build here — rather than at four call sites — is the same
## discipline the accepted runtime recorded when it moved the reward reset out
## of the death path: a reset that lives in one place cannot forget a field on
## one route and remember it on another.
##
## THE BUILD IS REPLACED, NOT CLEARED. A `clear()` that forgets one field is how
## a stale reward survives a reset, and this project has been bitten by exactly
## that more than once.
func _reset_run_scoped_state() -> void:
	super()
	build = RogueliteBuildState.new()
	last_offer.clear()
	_choice_pending = false
	_choice_delay = -1.0
	_pending_choice_index = 0
	_pending_room_index = -1
	_restore_baseline_combat_values()
	if choice_panel != null and choice_panel.is_open:
		choice_panel.close("run reset")
	if strike_envelope != null:
		strike_envelope.hide_now()


## RESTORES FROM THE CANONICAL AUTHORED RECORD, NEVER FROM A CAPTURED BASELINE.
## See the class header: Gate F's aim-assistance setting captured a baseline
## from the shared record and scaled it in place, and every later room scaled
## the already-scaled numbers. Reading the authored value back out on every
## reset makes that compounding structurally impossible here.
##
## The attack-speed field is NOT written here on purpose — the inherited reset
## already zeroes it through the very same `set_increased_attack_speed()` call
## the upgrade applies with, so there is one path in and one path out.
func _restore_baseline_combat_values() -> void:
	if player == null or player.attack == null:
		return
	var data: QuickStrikeData = player.attack.data
	var canonical: QuickStrikeData = canonical_quick_strike_record()
	data.reach = canonical.reach
	data.release_arc_degrees = canonical.release_arc_degrees
	data.soft_target_cone_degrees = canonical.soft_target_cone_degrees


func _begin_run(reason: String) -> void:
	completed_build = null
	super(reason)


## Captured BEFORE the accepted completion runs, because that path resets the
## run on purpose — the Nexus banner behind the summary must already be telling
## the truth about what the player is holding, which means the panel cannot read
## the live values it is reporting on.
func _complete_run() -> void:
	completed_build = build
	if completed_build != null:
		completed_build.capture(live_combat_values())
	super()


# --- Review controls --------------------------------------------------------

## F8 toggles the swing outline. It is a PHYSICAL key, exactly like F6, F7, `[`,
## `]` and `\`. No InputMap action is declared: Gate B, Gate E and Gate F each
## emit one assertion per key event, so a single new action would silently move
## three locked counts.
func _handle_review_keys(event: InputEvent) -> void:
	var key: InputEventKey = event as InputEventKey
	if key != null and key.pressed and not key.echo and key.physical_keycode == KEY_F8:
		_toggle_strike_envelope()
		return
	super(event)


func _toggle_strike_envelope() -> void:
	if strike_envelope == null:
		return
	strike_envelope.set_enabled(not strike_envelope.enabled)
	hud.show_message("Swing outline %s" % ("on" if strike_envelope.enabled else "off"))
	log_event("swing outline", "enabled=%s" % str(strike_envelope.enabled))


func _any_modal_open() -> bool:
	return super() or (choice_panel != null and choice_panel.is_open)


func measurements() -> Dictionary:
	var measured: Dictionary = super()
	measured["upgrade_pool"] = RogueliteUpgrade.POOL.size()
	measured["choices_per_run"] = RogueliteBuildVarietyRunPlan.CHOICES_PER_RUN
	measured["options_per_choice"] = RogueliteBuildVarietyRunPlan.OPTIONS_PER_CHOICE
	measured["choices_offered"] = choices_offered
	measured["upgrades_taken"] = upgrades_taken
	measured["build"] = "none" if build == null else build.build_line()
	measured["duplicate_offers_refused"] = duplicate_offers_refused
	measured["refused_acquisitions"] = refused_acquisitions.size()
	measured["envelope_draws"] = 0 if strike_envelope == null else strike_envelope.draws
	var live: Dictionary = live_combat_values()
	measured["quick_strike_damage"] = live["damage"]
	measured["quick_strike_action_time"] = live["action_time"]
	measured["quick_strike_reach"] = live["reach"]
	measured["quick_strike_arc"] = live["arc"]
	measured["quick_strike_soft_cone"] = live["soft_cone"]
	return measured


## Overrides the accepted prefix. A log line is evidence, and a line that names
## the wrong review is a line a future reader will believe.
func log_event(kind: String, detail: String) -> void:
	var line: String = "[build-variety] %-24s %s" % [kind, detail]
	log_lines.append(line)
	print(line)


## Overrides the accepted starter so neither `--verify-1d`, `--verify-loop` nor
## `--verify-replay` can start another review's suite in this scene, and so this
## review's suite has its own flag.
func _maybe_start_verification() -> void:
	var arguments: PackedStringArray = OS.get_cmdline_user_args()
	if not arguments.has("--verify-build"):
		return
	var script: GDScript = load(BUILD_VERIFICATION_SCRIPT) as GDScript
	var runner: Node = Node.new()
	runner.name = "RogueliteBuildVarietyVerification"
	runner.set_script(script)
	runner.set("loop", self)
	runner.set("arguments", arguments)
	add_child(runner)
