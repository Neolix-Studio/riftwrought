extends Node
## Riftwrought — Roguelite Replayability V1: automated verification (D-222).
##
## THIS IS NOT A GATE, AND IT DELIBERATELY DOES NOT RE-PROVE HISTORY. Quick
## Strike, the Graveblade state machine, click-to-move, the D-178 controller
## cone, the modal contract, the item comparison AND the accepted core loop's
## own hub / gate / reward / reset behaviour are proven by suites this review
## does not edit. Re-running them here would be verification theatre. What THIS
## suite proves is the one thing no existing suite can know: that a SEED picks
## a route through an authored library reproducibly, that two seeds pick
## visibly different routes, that the beat categories are preserved, that the
## one temporary reward is offered as exactly two readable choices and applied
## correctly, that both choices are genuinely run-scoped, and that the accepted
## core loop is untouched underneath.
##
## IT PORTS D-211's OWED-SET DISCIPLINE. Every check function records reaching
## its LAST line, and the suite compares that set to what it owes in BOTH
## directions. That is the only thing that catches an un-awaited coroutine
## check: Zone Composer Phase 1 shipped a suite where five of seven assertions
## never ran while it reported PASS.
##
## IT ALSO PORTS GATE F's ON-SCREEN MEASUREMENT, for the reason it was written:
## reading the right words out of a Control tree proves the words EXIST, not
## that anyone can see them.
##
## Run:  godot --headless --path game \
##         res://scenes/roguelite/roguelite_replayability_review.tscn -- --verify-replay

const RUNTIME_SCRIPT: String = "res://scripts/roguelite/replayability/roguelite_replayability_runtime.gd"
const LIBRARY_SCRIPT: String = "res://scripts/roguelite/replayability/roguelite_room_library.gd"
const VARIANT_SCRIPT: String = "res://scripts/roguelite/replayability/roguelite_variant_room_module.gd"
const PLAN_SCRIPT: String = "res://scripts/roguelite/replayability/roguelite_seeded_run_plan.gd"
const BOON_SCRIPT: String = "res://scripts/roguelite/replayability/roguelite_run_boon.gd"
const PANEL_SCRIPT: String = "res://scripts/roguelite/replayability/roguelite_boon_choice_panel.gd"
const HUD_SCRIPT: String = "res://scripts/roguelite/replayability/roguelite_replayability_hud.gd"
const SUMMARY_SCRIPT: String = "res://scripts/roguelite/replayability/roguelite_replayability_summary_panel.gd"

const REVIEW_SCRIPTS: Array[String] = [
	RUNTIME_SCRIPT, LIBRARY_SCRIPT, VARIANT_SCRIPT, PLAN_SCRIPT,
	BOON_SCRIPT, PANEL_SCRIPT, HUD_SCRIPT, SUMMARY_SCRIPT,
]

## The accepted core-loop files this review builds on and must not disturb.
const ACCEPTED_MODULE_SCRIPT: String = "res://scripts/roguelite/roguelite_room_module.gd"
const ACCEPTED_RUNTIME_SCRIPT: String = "res://scripts/roguelite/roguelite_core_loop_runtime.gd"
const ACCEPTED_LOOP_SCENE: String = "res://scenes/roguelite/roguelite_core_loop.tscn"

const EXPECTED_ACTIONS_COUNT: int = 31
const EXPECTED_LIBRARY_ROOMS: int = 9
const EXPECTED_BEATS: int = 3
const EXPECTED_MODULES: int = 10
const EXPECTED_ROUTES: int = 27
const EXPECTED_ENEMIES: int = 15

const ACCEPTED_CAMERA_DISTANCE: float = 19.0
const ACCEPTED_CAMERA_PITCH: float = 55.0
const ACCEPTED_CAMERA_FOV: float = 45.0
const ACCEPTED_MAX_SPEED: float = 5.0
const ACCEPTED_ACTION_TIME: float = 0.80
const ACCEPTED_RELEASE_MARKER: float = 0.325
const ACCEPTED_REACH: float = 1.65
const ORDINARY_LIFE: float = 300.0
const ELITE_LIFE: float = 600.0
const WORN_DAMAGE: float = 100.0
const EXPEDITION_DAMAGE: float = 150.0
const QUICKENED_ACTION_TIME: float = 0.64

## THE TWO DOCUMENTED SEEDS, PINNED AS ROUTES RATHER THAN AS A CLAIM. They are
## chosen because they differ in ALL THREE beats, which is the strongest form
## of "visibly different" the library can produce, and they are asserted room
## for room — a test that only asserted "the two routes differ" would pass on a
## single differing beat and would still pass if the selection silently changed.
const SEED_A: int = 99
const SEED_B: int = 404
const ROUTE_A: Array[StringName] = [&"opening_pillar_court", &"reward_alcove", &"elite_broad_hall"]
const ROUTE_B: Array[StringName] = [&"opening_dogleg", &"reward_crossing", &"elite_pinch"]

## How many seeds the category-preservation sweep walks. Large enough that every
## one of the nine authored rooms must be reachable from some seed, which is the
## property that catches a selection collapsing onto a subset.
const SWEEP_SEEDS: int = 512

## Every check function this suite owes, compared to what actually ran in BOTH
## directions. D-211: a suite that reports PASS cannot see the assertions it
## never reached.
const OWED_CHECKS: Array[String] = [
	"engine_and_assembly",
	"isolation_from_the_landing_track",
	"input_map_untouched",
	"accepted_values_reused",
	"the_accepted_core_loop_is_untouched",
	"room_library_is_coherent",
	"modules_are_one_reusable_builder",
	"modules_are_disjoint",
	"every_room_centre_is_reachable",
	"reward_position_is_clear_of_every_gate",
	"same_seed_reproduces_the_route",
	"two_documented_seeds_differ",
	"every_seed_is_category_preserving",
	"the_selection_is_not_a_reorder",
	"hub_is_safe",
	"the_run_follows_the_selected_route",
	"combat_gate_holds_and_opens",
	"the_cache_offers_exactly_two_choices",
	"the_blade_reproduces_the_damage_proof",
	"only_one_boon_per_run",
	"a_completed_run_clears_its_boon",
	"a_second_run_takes_a_different_route",
	"the_edge_reuses_the_established_property",
	"death_clears_the_boon",
	"abandon_clears_the_boon",
	"the_next_run_starts_clean",
	"writes_nothing",
	"excluded_systems_absent",
	"surfaces_are_on_screen",
]

var loop: RogueliteReplayabilityRuntime
var arguments: PackedStringArray = PackedStringArray()

var _failures: PackedStringArray = PackedStringArray()
var _checks: int = 0
var _reached: Dictionary = {}
var _shot_dir: String = ""

## Recorded by the gate check and asserted by the damage-proof check, so the
## claim "three Hits, then two" is owed by the one function that makes it.
var _worn_hits: int = -1


func _ready() -> void:
	await run()


func run() -> void:
	print("")
	print("=== Roguelite Replayability V1 verification (D-222) ===")
	_shot_dir = _argument_value("--shots")
	await _settle(10)
	await _await_navigation()

	_check_engine_and_assembly()
	_check_isolation_from_the_landing_track()
	_check_input_map_untouched()
	_check_accepted_values_reused()
	_check_the_accepted_core_loop_is_untouched()
	_check_room_library_is_coherent()
	_check_modules_are_one_reusable_builder()
	_check_modules_are_disjoint()
	_check_every_room_centre_is_reachable()
	_check_reward_position_is_clear_of_every_gate()
	_check_same_seed_reproduces_the_route()
	_check_two_documented_seeds_differ()
	_check_every_seed_is_category_preserving()
	_check_the_selection_is_not_a_reorder()
	_check_hub_is_safe()

	await _check_the_run_follows_the_selected_route()
	await _check_combat_gate_holds_and_opens()
	await _check_the_cache_offers_exactly_two_choices()
	await _check_the_blade_reproduces_the_damage_proof()
	_check_only_one_boon_per_run()
	await _check_a_completed_run_clears_its_boon()
	await _check_a_second_run_takes_a_different_route()
	await _check_the_edge_reuses_the_established_property()
	await _check_death_clears_the_boon()
	await _check_abandon_clears_the_boon()
	await _check_the_next_run_starts_clean()

	_check_writes_nothing()
	_check_excluded_systems_absent()
	await _check_surfaces_are_on_screen()

	if not _shot_dir.is_empty():
		await _capture_evidence()

	_check_every_check_ran()

	print("")
	if _failures.is_empty():
		print("ROGUELITE REPLAYABILITY VERIFICATION: PASS (%d checks)" % _checks)
		get_tree().quit(0)
	else:
		for failure: String in _failures:
			printerr("  FAIL: %s" % failure)
		printerr("ROGUELITE REPLAYABILITY VERIFICATION: %d FAILURE(S) of %d checks" % [
			_failures.size(), _checks,
		])
		get_tree().quit(1)


# --- 1. Assembly and inheritance ------------------------------------------------

func _check_engine_and_assembly() -> void:
	print("")
	print("--- The review assembles the whole library from ONE bake")
	_expect(Engine.get_version_info()["string"].begins_with("4.7.2"),
		"engine is %s, not 4.7.2" % Engine.get_version_info()["string"])
	_expect(loop != null, "the verification was not handed the runtime")
	_expect(loop is RogueliteCoreLoopRuntime,
		"the runtime does not extend the accepted core loop")
	_expect(loop is BrokenWatchSlice,
		"the runtime is not a BrokenWatchSlice, so it cannot bind the proven Gate 1D surfaces")
	_expect(loop.all_modules.size() == EXPECTED_MODULES,
		"%d module(s) built, not %d" % [loop.all_modules.size(), EXPECTED_MODULES])
	_expect(loop.variant_modules.size() == EXPECTED_LIBRARY_ROOMS,
		"%d library room(s), not %d" % [loop.variant_modules.size(), EXPECTED_LIBRARY_ROOMS])
	_expect(loop.room_modules.size() == EXPECTED_BEATS,
		"%d selected room(s), not %d" % [loop.room_modules.size(), EXPECTED_BEATS])
	_expect(loop.graveblades.size() == EXPECTED_ENEMIES,
		"%d enemies, not %d" % [loop.graveblades.size(), EXPECTED_ENEMIES])
	## ONE bake for the WHOLE library, and it stays one for the whole session.
	## That is what lets a second run take a different route without a rebuild;
	## if selecting a route ever re-baked, this number would move.
	_expect(loop.bake_count == 1,
		"the navigation mesh was baked %d times, not once" % loop.bake_count)
	_expect(loop.navmesh_polygon_count > 0 and loop.navmesh_area > 0.0,
		"the navigation bake produced nothing")
	var footprint: float = 0.0
	for module: RogueliteRoomModule in loop.all_modules:
		footprint += module.footprint_area()
	print("  %d modules (%d library rooms), %d enemies, %d navmesh polygons over %.1f m^2 from %d bake" % [
		loop.all_modules.size(), loop.variant_modules.size(), loop.graveblades.size(),
		loop.navmesh_polygon_count, loop.navmesh_area, loop.bake_count,
	])
	print("  authored footprint %.0f m^2 across the whole library; %.0f m^2 in any one run" % [
		footprint, loop.hub_module.footprint_area()
			+ loop.room_modules[0].footprint_area()
			+ loop.room_modules[1].footprint_area()
			+ loop.room_modules[2].footprint_area(),
	])
	_done("engine_and_assembly")


func _check_isolation_from_the_landing_track() -> void:
	print("")
	print("--- No Riftfall Landing or Broken Watch content exists in this scene")
	_expect(loop.landing_layout == null, "landing_layout is not null — a base _ready() ran")
	_expect(loop.landing_dressing == null, "landing_dressing is not null — the dressing was built")
	_expect(loop.broken_watch == null, "broken_watch is not null — Broken Watch was instanced")
	_expect(loop.lighting == null, "lighting is not null — the exterior lighting component was configured")
	_expect(loop.treatment == null, "treatment is not null — the exterior material treatment was constructed")
	for type_name: String in [
		"RiftfallLandingGreyboxLayout", "RiftfallLandingVisualReviewDressing", "BrokenWatchLayout",
	]:
		_expect(_count_nodes_of_script(loop, type_name) == 0,
			"a %s node exists in the review scene" % type_name)
	_expect(_count_nodes_of_script(loop, "RogueliteVariantRoomModule") == EXPECTED_MODULES,
		"the scene does not hold exactly %d RogueliteVariantRoomModule nodes" % EXPECTED_MODULES)
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
		&"enter_rift", &"next_room", &"abandon_run", &"next_route", &"reroll_seed",
		&"choose_boon", &"take_boon", &"open_cache",
	]:
		_expect(not InputMap.has_action(invented),
			"a new InputMap action %s was declared — Gate B, E and F each emit one assertion per key event" % invented)
	_expect(ProjectSettings.get_setting("application/run/main_scene", "") == "res://scenes/app/prototype_app.tscn",
		"run/main_scene is no longer the Prototype App")
	print("  %d actions, no invented action, entrypoint unchanged" % declared)
	_done("input_map_untouched")


func _check_accepted_values_reused() -> void:
	print("")
	print("--- Every accepted value is reused, not re-derived")
	_expect(is_equal_approx(loop.camera_rig.distance_metres, ACCEPTED_CAMERA_DISTANCE),
		"camera distance is %.2f m, not %.2f" % [loop.camera_rig.distance_metres, ACCEPTED_CAMERA_DISTANCE])
	_expect(is_equal_approx(loop.camera_rig.pitch_degrees, ACCEPTED_CAMERA_PITCH),
		"camera pitch is %.2f deg, not %.2f" % [loop.camera_rig.pitch_degrees, ACCEPTED_CAMERA_PITCH])
	_expect(is_equal_approx(loop.camera_rig.fov_degrees, ACCEPTED_CAMERA_FOV),
		"camera FOV is %.2f deg, not %.2f" % [loop.camera_rig.fov_degrees, ACCEPTED_CAMERA_FOV])
	_expect(is_equal_approx(loop.player.max_speed, ACCEPTED_MAX_SPEED),
		"player max speed is %.2f m/s, not %.2f" % [loop.player.max_speed, ACCEPTED_MAX_SPEED])

	var strike: QuickStrikeData = loop.canonical_quick_strike_record()
	_expect(is_equal_approx(strike.action_time, ACCEPTED_ACTION_TIME),
		"the canonical Quick Strike action time moved from %.2f s" % ACCEPTED_ACTION_TIME)
	_expect(is_equal_approx(strike.release_marker_normalized, ACCEPTED_RELEASE_MARKER),
		"the canonical Quick Strike release marker moved from %.3f" % ACCEPTED_RELEASE_MARKER)
	_expect(is_equal_approx(strike.reach, ACCEPTED_REACH),
		"the canonical Quick Strike reach moved from %.2f m" % ACCEPTED_REACH)

	var canonical_enemy: GravebladeData = load("res://data/prototype_zero/graveblade.tres") as GravebladeData
	_expect(is_equal_approx(canonical_enemy.max_life, ORDINARY_LIFE),
		"the canonical Graveblade Life moved from %.0f" % ORDINARY_LIFE)
	_expect(is_equal_approx(canonical_enemy.physical_damage, 125.0),
		"the canonical Graveblade damage moved from 125")
	var elite: GravebladeData = load("res://data/roguelite/graveblade_elite.tres") as GravebladeData
	_expect(is_equal_approx(elite.max_life, ELITE_LIFE),
		"the accepted Elite Life moved from %.0f" % ELITE_LIFE)

	## The ordinary enemies use the canonical record BY IDENTITY, not a copy of
	## its numbers — a copy could drift.
	var ordinary_count: int = 0
	var elite_count: int = 0
	for enemy: PrototypeGraveblade in loop.graveblades:
		if enemy.data == canonical_enemy:
			ordinary_count += 1
		elif enemy.data == elite:
			elite_count += 1
	_expect(ordinary_count == 12,
		"%d enemies use the canonical Graveblade record itself, not 12" % ordinary_count)
	## One Elite per elite-beat room, and never more: an index-keyed Elite would
	## have moved to whichever room happened to be third.
	_expect(elite_count == 3,
		"%d enemies use the accepted Elite record, not one per elite room" % elite_count)

	_expect(is_equal_approx(loop.worn_blade_record().physical_damage, WORN_DAMAGE),
		"the starting weapon does not deal %.0f Physical" % WORN_DAMAGE)
	_expect(is_equal_approx(loop.expedition_blade_record().physical_damage, EXPEDITION_DAMAGE),
		"the Expedition Blade does not deal %.0f Physical" % EXPEDITION_DAMAGE)
	_expect(loop.worn_blade_record().problem().is_empty(),
		"the starting weapon record is incoherent: %s" % loop.worn_blade_record().problem())
	print("  19 m / 55 deg / 45 deg camera, 5.0 m/s, 0.80 s / 0.325 / 1.65 m, 300 / 600 Life, 100 / 150 damage")
	_done("accepted_values_reused")


## The review builds ON the accepted core loop; this proves it did not build
## OVER it. The byte-identity of every accepted file is proved by the runner in
## the shell; what is proved here is that the accepted BEHAVIOUR is still the
## accepted behaviour when this scene is the one running.
func _check_the_accepted_core_loop_is_untouched() -> void:
	print("")
	print("--- The accepted core loop still behaves exactly as it was accepted")
	_expect(RogueliteRoomModule.MODULES.size() == 4,
		"the accepted module records hold %d entries, not 4" % RogueliteRoomModule.MODULES.size())
	for id: StringName in [&"nexus_hub", &"teaching_hall", &"cache_room", &"elite_hall"]:
		_expect(RogueliteRoomModule.MODULES.has(id),
			"the accepted module records no longer hold %s" % id)
	_expect(RogueliteRunPlan.AUTHORED_ORDER == ([&"teaching_hall", &"cache_room", &"elite_hall"] as Array[StringName]),
		"the accepted authored order changed")

	## The accepted plan class must still answer exactly as it was accepted:
	## fixed order, no shuffle, and it must say so.
	var accepted: RogueliteRunPlan = RogueliteRunPlan.new(SEED_A, 0)
	var accepted_other: RogueliteRunPlan = RogueliteRunPlan.new(SEED_B, 0)
	_expect(not accepted.is_shuffled(), "the ACCEPTED plan now claims to shuffle")
	_expect(accepted.ordered_modules() == RogueliteRunPlan.AUTHORED_ORDER,
		"the ACCEPTED plan no longer returns the authored order")
	_expect(accepted.ordered_modules() == accepted_other.ordered_modules(),
		"the ACCEPTED plan's order now depends on the seed")
	_expect(accepted.selection_mode().contains("not implemented"),
		"the ACCEPTED plan no longer says plainly that shuffling is not implemented")

	## And this review is a SUBCLASS of the accepted runtime rather than a
	## rewrite of it — the whole reuse claim in one assertion.
	var script: GDScript = loop.get_script() as GDScript
	_expect(script != null and script.resource_path == RUNTIME_SCRIPT,
		"the scene does not run this review's own runtime script")
	var base: GDScript = script.get_base_script() as GDScript
	_expect(base != null and base.resource_path == ACCEPTED_RUNTIME_SCRIPT,
		"this review's runtime does not extend the accepted core loop runtime")
	_expect(FileAccess.file_exists(ACCEPTED_LOOP_SCENE),
		"the accepted core loop scene no longer exists")
	print("  4 accepted records, the accepted fixed order, and this runtime extends the accepted one")
	_done("the_accepted_core_loop_is_untouched")


# --- 2. The library --------------------------------------------------------------

func _check_room_library_is_coherent() -> void:
	print("")
	print("--- The library is three beats, three authored rooms each, and it says so")
	_expect(RogueliteRoomLibrary.problem().is_empty(),
		"the room library is incoherent: %s" % RogueliteRoomLibrary.problem())
	_expect(RogueliteRoomLibrary.VARIANTS.size() == EXPECTED_LIBRARY_ROOMS,
		"the library holds %d rooms, not %d" % [RogueliteRoomLibrary.VARIANTS.size(), EXPECTED_LIBRARY_ROOMS])
	_expect(RogueliteRoomLibrary.BEAT_ORDER.size() == EXPECTED_BEATS,
		"the library declares %d beats, not %d" % [RogueliteRoomLibrary.BEAT_ORDER.size(), EXPECTED_BEATS])
	_expect(RogueliteRoomLibrary.total_routes() == EXPECTED_ROUTES,
		"the library offers %d routes, not %d" % [RogueliteRoomLibrary.total_routes(), EXPECTED_ROUTES])
	for beat: StringName in RogueliteRoomLibrary.BEAT_ORDER:
		var variants: Array[StringName] = RogueliteRoomLibrary.variants_for(beat)
		## An EXACT count, not "at least two". A `>=` guard would accept a beat
		## that had quietly lost a room, which is precisely the shape of failure
		## a replayability review cannot afford to tolerate.
		_expect(variants.size() == 3,
			"beat %s has %d authored room(s), not 3" % [beat, variants.size()])
		for id: StringName in variants:
			_expect(RogueliteRoomLibrary.beat_of(id) == beat,
				"%s is listed under %s but declares beat %s" % [id, beat, RogueliteRoomLibrary.beat_of(id)])
			_expect(not RogueliteRoomModule.MODULES.has(id),
				"%s collides with an accepted core-loop module id" % id)
			_expect(loop.LIBRARY_PLACEMENTS.has(id), "%s has no placement" % id)
		print("  %s: %s" % [
			RogueliteRoomLibrary.beat_caption(beat),
			", ".join(PackedStringArray(variants.map(
				func(id: StringName) -> String: return RogueliteRoomLibrary.display_name_of(id)))),
		])
	## The hub is the ACCEPTED record itself, by identity — not a copy that
	## could drift away from the safe space the owner already played.
	_expect(loop.hub_module.record() == RogueliteRoomModule.MODULES[RogueliteRunPlan.HUB_MODULE],
		"the Rift Nexus is not the accepted core-loop hub record")
	_expect(loop.hub_module.is_hub(), "the Rift Nexus is not a hub module")
	print("  %s" % RogueliteRoomLibrary.describe())
	_done("room_library_is_coherent")


func _check_modules_are_one_reusable_builder() -> void:
	print("")
	print("--- Every room is the ACCEPTED module builder, reading one more record source")
	var variant_script: GDScript = load(VARIANT_SCRIPT) as GDScript
	var base: GDScript = variant_script.get_base_script() as GDScript
	_expect(base != null and base.resource_path == ACCEPTED_MODULE_SCRIPT,
		"the variant module does not extend the accepted module builder")
	for module: RogueliteRoomModule in loop.all_modules:
		var script: GDScript = module.get_script() as GDScript
		_expect(script != null and script.resource_path == VARIANT_SCRIPT,
			"%s does not run the one module script" % module.name)
		_expect(module.entry_point_local() != module.exit_point_local(),
			"%s has no distinct entry and exit point" % module.name)
		_expect(module.footprint_area() > 0.0, "%s has no walkable area" % module.name)
		_expect(module.carve_count() > 0,
			"%s carves nothing out of the navigation mesh — the open-topped-well fix is missing" % module.name)
		## Every non-ground solid must carve, so collision shapes and carves
		## differ by exactly the number of ground plates.
		_expect(module.solid_count() == module.carve_count() + module.room_count(),
			"%s has %d collision shape(s) against %d carve(s) and %d ground plate(s)" % [
				module.name, module.solid_count(), module.carve_count(), module.room_count(),
			])
	## Encounter counts are a property of the BEAT, and the review's whole
	## premise is that swapping a room does not change what the beat is.
	for beat: StringName in RogueliteRoomLibrary.BEAT_ORDER:
		var wanted: int = 1 if beat == RogueliteRoomLibrary.BEAT_OPENING else 2
		for id: StringName in RogueliteRoomLibrary.variants_for(beat):
			var module: RogueliteVariantRoomModule = loop.variant_modules[id]
			_expect(module.encounter_count() == wanted,
				"%s has %d encounter socket(s); every %s room must have %d" % [
					id, module.encounter_count(), beat, wanted,
				])
	_expect(loop.hub_module.encounter_count() == 0, "the Rift Nexus has an encounter socket")
	print("  %d modules on one builder; opening 1 enemy, reward 2, elite 2 (one of them the Elite)" % loop.all_modules.size())
	_done("modules_are_one_reusable_builder")


## Modules are DISJOINT on purpose: a room is entered through its gate, not
## walked into from the previous room, which is exactly what makes each one
## independently selectable. Measured on the OCCUPIED rectangle — walkable plus
## derived walls — because `bake_rect()` carries a 2 m navigation margin and
## would under-report every gap by 4 m.
func _check_modules_are_disjoint() -> void:
	print("")
	print("--- No two modules touch, and the narrowest gap is measured rather than promised")
	var narrowest: float = INF
	var overlaps: int = 0
	var pairs: int = 0
	for i: int in loop.all_modules.size():
		for j: int in range(i + 1, loop.all_modules.size()):
			var a: Rect2 = (loop.all_modules[i] as RogueliteVariantRoomModule).occupied_rect()
			var b: Rect2 = (loop.all_modules[j] as RogueliteVariantRoomModule).occupied_rect()
			var gap: float = _rect_gap(a, b)
			pairs += 1
			if gap <= 0.0:
				overlaps += 1
				_expect_quiet(false, "%s and %s overlap or touch" % [
					loop.all_modules[i].name, loop.all_modules[j].name,
				])
			narrowest = minf(narrowest, gap)
	_expect(overlaps == 0, "%d module pair(s) overlap or touch" % overlaps)
	_expect(pairs == 45, "%d pairs measured, not the 45 that 10 modules make" % pairs)
	_expect(narrowest >= 20.0,
		"the narrowest gap between two modules is %.2f m — they are close enough to join in the bake" % narrowest)
	print("  %d pairs, narrowest gap %.2f m, 0 overlaps" % [pairs, narrowest])
	_done("modules_are_disjoint")


## Gate 1E's single most valuable check, ported and widened to the whole
## library. Sockets are placed where things happen, so a room with no socket
## can bake as a sealed island while every socket check passes — that is
## exactly how the Nexus Threshold's WEST_ALCOVE shipped as 70 m^2 of
## unreachable navigation. This walks BY PATH to the CENTRE OF EVERY AUTHORED
## RECTANGLE, and to every socket, in every one of the ten modules.
func _check_every_room_centre_is_reachable() -> void:
	print("")
	print("--- Every authored rectangle centre and every socket is reachable BY PATH, in all 10 modules")
	var map: RID = loop.navigation_map()
	var targets_total: int = 0
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
		targets_total += targets.size()
		print("  %s: %d target(s) reachable from its own entry" % [module.name, targets.size()])
	_expect(targets_total == 42,
		"%d reachability targets walked, not the 42 the library owes" % targets_total)
	_done("every_room_centre_is_reachable")


## THE DEFECT THIS EXISTS FOR WAS REAL AND WAS PRINTED AS GOOD NEWS. The
## accepted core loop's first implementation dropped the guaranteed reward
## 1.60 m from a gate whose enter radius is 1.70 m, so walking to the item WAS
## walking into the gate: the player was teleported onward and the reward was
## stranded. With three reward rooms instead of one, the same arithmetic has to
## hold in all three — and each has a different shape, so it is genuinely three
## different answers rather than one repeated.
func _check_reward_position_is_clear_of_every_gate() -> void:
	print("")
	print("--- In EVERY reward room the guaranteed drop lands clear of the gate, and reachable")
	var map: RID = loop.navigation_map()
	for id: StringName in RogueliteRoomLibrary.variants_for(RogueliteRoomLibrary.REWARD_BEAT):
		var module: RogueliteVariantRoomModule = loop.variant_modules[id]
		var wanted: Vector3 = loop._reward_position(module)
		var resolved: Dictionary = PrototypeGroundPointer.resolve_to_navigation(map, wanted)
		var at: Vector3 = Vector3(resolved["point"].x, 0.0, resolved["point"].z)
		var gate: Vector3 = module.exit_point()
		var to_gate: float = Vector2(at.x - gate.x, at.z - gate.z).length()
		## A BAND, IN BOTH DIRECTIONS, AND THE LOWER BOUND IS THE ONE THAT
		## MATTERS: near enough that leaving without seeing it takes effort, far
		## enough that reaching for it cannot trigger the gate.
		_expect(to_gate > RogueliteCoreLoopRuntime.GATE_ENTER_RADIUS + 1.5,
			"%s: the reward would land %.2f m from a gate that triggers at %.2f m" % [
				id, to_gate, RogueliteCoreLoopRuntime.GATE_ENTER_RADIUS,
			])
		_expect(to_gate <= 8.0,
			"%s: the reward would land %.2f m from the gate — a player can walk out without passing it" % [
				id, to_gate,
			])
		var path: PackedVector3Array = NavigationServer3D.map_get_path(map, module.entry_point(), at, true)
		var short_by: float = INF
		if path.size() >= 2:
			short_by = Vector2(path[path.size() - 1].x - at.x, path[path.size() - 1].z - at.z).length()
		_expect(path.size() >= 2 and short_by <= 1.0,
			"%s: the reward position is not reachable by path (%.2f m short)" % [id, short_by])
		print("  %s: reward lands %.2f m back from its gate, reachable" % [
			RogueliteRoomLibrary.display_name_of(id), to_gate,
		])
	_done("reward_position_is_clear_of_every_gate")


# --- 3. The seed ------------------------------------------------------------------

func _check_same_seed_reproduces_the_route() -> void:
	print("")
	print("--- The same seed always produces the same run id AND the same route")
	var plan_script: GDScript = load(PLAN_SCRIPT) as GDScript
	var a: RogueliteSeededRunPlan = plan_script.new(SEED_A, 0) as RogueliteSeededRunPlan
	var b: RogueliteSeededRunPlan = plan_script.new(SEED_A, 0) as RogueliteSeededRunPlan
	_expect(a.problem().is_empty(), "the seeded plan is incoherent: %s" % a.problem())
	_expect(a.run_id() == b.run_id(),
		"the same seed produced two different run ids: %s vs %s" % [a.run_id(), b.run_id()])
	_expect(a.ordered_modules() == b.ordered_modules(),
		"the same seed produced two different routes: %s vs %s" % [a.route_line(), b.route_line()])
	## Purity across repeated calls: nothing in the selection may drift, cache
	## or consume a stream.
	var drifts: int = 0
	for i: int in 100:
		if a.ordered_modules() != b.ordered_modules() or a.run_id() != b.run_id():
			drifts += 1
	_expect(drifts == 0, "the selection drifted on %d of 100 repeated calls" % drifts)
	## And a session is reproducible from its first seed: the successor of the
	## same plan is the same successor, route and all.
	_expect(a.next().run_id() == b.next().run_id(), "the next run is not reproducible")
	_expect(a.next().ordered_modules() == b.next().ordered_modules(),
		"the next run's route is not reproducible")
	_expect(a.next().run_id() != a.run_id(), "the next run reuses the previous run id")
	_expect(a.next() is RogueliteSeededRunPlan,
		"the next run is not a SEEDED plan — every run after the first would use the authored order")
	print("  %s reproduces %s across 100 calls, and so does its successor" % [a.run_id(), a.route_line()])
	_done("same_seed_reproduces_the_route")


## The two documented seeds, asserted room for room. A test that only asserted
## "the routes differ" would pass on one differing beat, and would still pass
## if the selection silently changed.
func _check_two_documented_seeds_differ() -> void:
	print("")
	print("--- Two documented seeds produce visibly different routes, in ALL THREE beats")
	var a: RogueliteSeededRunPlan = RogueliteSeededRunPlan.new(SEED_A, 0)
	var b: RogueliteSeededRunPlan = RogueliteSeededRunPlan.new(SEED_B, 0)
	_expect(a.ordered_modules() == ROUTE_A,
		"seed %d selects %s, not the documented %s" % [SEED_A, a.ordered_modules(), ROUTE_A])
	_expect(b.ordered_modules() == ROUTE_B,
		"seed %d selects %s, not the documented %s" % [SEED_B, b.ordered_modules(), ROUTE_B])
	var differing: int = 0
	for index: int in RogueliteRoomLibrary.BEAT_ORDER.size():
		if a.ordered_modules()[index] != b.ordered_modules()[index]:
			differing += 1
	_expect(differing == RogueliteRoomLibrary.BEAT_ORDER.size(),
		"the two documented seeds share %d of %d beats" % [
			RogueliteRoomLibrary.BEAT_ORDER.size() - differing, RogueliteRoomLibrary.BEAT_ORDER.size(),
		])
	_expect(a.run_id() != b.run_id(), "two different seeds produced the same run id")
	print("  seed %d → %s" % [SEED_A, a.route_line()])
	print("  seed %d → %s" % [SEED_B, b.route_line()])
	_done("two_documented_seeds_differ")


## Category preservation is the property that makes the selection safe: an
## opening room can never fill the elite beat. Proved over a sweep rather than
## over one seed, because one seed proves one route.
func _check_every_seed_is_category_preserving() -> void:
	print("")
	print("--- Over %d seeds: always three rooms, always opening → reward → elite" % SWEEP_SEEDS)
	var violations: int = 0
	var problems: int = 0
	var wrong_length: int = 0
	var seen_routes: Dictionary = {}
	var seen_rooms: Dictionary = {}
	for seed_value: int in SWEEP_SEEDS:
		var plan: RogueliteSeededRunPlan = RogueliteSeededRunPlan.new(seed_value, 0)
		if not plan.problem().is_empty():
			problems += 1
		var selected: Array[StringName] = plan.ordered_modules()
		if selected.size() != RogueliteRoomLibrary.BEAT_ORDER.size():
			wrong_length += 1
			continue
		for index: int in selected.size():
			if RogueliteRoomLibrary.beat_of(selected[index]) != RogueliteRoomLibrary.BEAT_ORDER[index]:
				violations += 1
			seen_rooms[selected[index]] = true
		seen_routes[plan.route_line()] = true
	_expect(problems == 0, "%d of %d seeds produced an incoherent plan" % [problems, SWEEP_SEEDS])
	_expect(wrong_length == 0, "%d of %d seeds produced the wrong number of rooms" % [wrong_length, SWEEP_SEEDS])
	_expect(violations == 0, "%d beat-category violations across %d seeds" % [violations, SWEEP_SEEDS])
	## Every authored room must be reachable from SOME seed, or part of the
	## library is dead content and the selection has quietly collapsed.
	_expect(seen_rooms.size() == EXPECTED_LIBRARY_ROOMS,
		"only %d of %d authored rooms are ever selected" % [seen_rooms.size(), EXPECTED_LIBRARY_ROOMS])
	_expect(seen_routes.size() == EXPECTED_ROUTES,
		"%d distinct routes appeared across %d seeds, not the %d the library offers" % [
			seen_routes.size(), SWEEP_SEEDS, EXPECTED_ROUTES,
		])
	print("  0 violations, %d distinct routes, all %d authored rooms selected at least once" % [
		seen_routes.size(), seen_rooms.size(),
	])
	_done("every_seed_is_category_preserving")


## The seed SELECTS; it does not REORDER. The two claims are kept apart on
## purpose, and both are asserted, because a plan that shuffled the beat spine
## would be a different game.
func _check_the_selection_is_not_a_reorder() -> void:
	print("")
	print("--- The seed selects rooms; the beat order is fixed and says so on screen")
	var plan: RogueliteSeededRunPlan = RogueliteSeededRunPlan.new(SEED_A, 0)
	_expect(plan.is_shuffled(),
		"the seeded plan claims the seed does not reach the route — it does")
	_expect(not plan.is_reordered(), "the seeded plan claims to reorder the beats")
	_expect(plan.ordered_beats() == RogueliteRoomLibrary.BEAT_ORDER,
		"the plan's beat order is not the authored one")
	var mode: String = plan.selection_mode()
	_expect(mode.contains("seeded"), "the selection mode does not say it is seeded: '%s'" % mode)
	_expect(mode.contains("fixed") and mode.contains("never shuffled"),
		"the selection mode does not say plainly that the beat order is fixed: '%s'" % mode)
	for seed_value: int in [1, 7, 42, 99, 404, 12345]:
		var other: RogueliteSeededRunPlan = RogueliteSeededRunPlan.new(seed_value, 0)
		var beats: Array[StringName] = []
		for id: StringName in other.ordered_modules():
			beats.append(RogueliteRoomLibrary.beat_of(id))
		_expect(beats == RogueliteRoomLibrary.BEAT_ORDER,
			"seed %d produced the beat order %s" % [seed_value, beats])
	print("  \"%s\"" % mode)
	_done("the_selection_is_not_a_reorder")


func _check_hub_is_safe() -> void:
	print("")
	print("--- The Rift Nexus is the safe run start and return point")
	_expect(loop.hub_module.encounter_count() == 0, "the Rift Nexus has an encounter socket")
	_expect(loop.hub_module.exit_gate_open, "the Rift Nexus's own gate is not open")
	_expect(loop.loop_state != RogueliteCoreLoopRuntime.LoopState.IN_RUN,
		"the review did not start in the Nexus")
	var hub: Rect2 = (loop.hub_module as RogueliteVariantRoomModule).occupied_rect()
	for enemy: PrototypeGraveblade in loop.graveblades:
		_expect(not hub.has_point(Vector2(enemy.global_position.x, enemy.global_position.z)),
			"%s stands inside the Rift Nexus" % enemy.name)
		_expect(not enemy.ai_enabled, "%s is active while the player is in the Nexus" % enemy.name)
	_expect(loop.player.global_position.distance_to(loop.hub_module.entry_point()) < 0.6,
		"the player did not start at the hub's own entry point")
	print("  %d enemies, all outside the Nexus and all inert" % loop.graveblades.size())
	_done("hub_is_safe")


# --- 4. A run on the selected route ------------------------------------------------

func _check_the_run_follows_the_selected_route() -> void:
	print("")
	print("--- Walking into the Rift Gate begins the run the Nexus advertised")
	## Entering a run through the hub gate, with the plan the Nexus is showing.
	loop.plan = RogueliteSeededRunPlan.new(SEED_A, 0)
	loop.run_state = RogueliteRunState.new(loop.plan)
	loop._refresh_run_hud()
	var advertised: Array[StringName] = (loop.plan as RogueliteSeededRunPlan).ordered_modules()
	_expect(advertised == ROUTE_A, "the Nexus is advertising %s, not the documented route" % [advertised])

	var bakes_before: int = loop.bake_count
	await _walk_into_gate(loop.hub_module.exit_point())
	_expect(loop.loop_state == RogueliteCoreLoopRuntime.LoopState.IN_RUN,
		"walking into the Rift Gate did not begin a run")
	_expect(loop.selected_ids() == advertised,
		"the run took %s, not the route the Nexus advertised" % [loop.selected_ids()])
	## SELECTING A ROUTE MUST NOT REBUILD OR RE-BAKE ANYTHING. The whole library
	## exists from assembly; a run is three references into it.
	_expect(loop.bake_count == bakes_before,
		"starting a run baked the navigation mesh again (%d → %d)" % [bakes_before, loop.bake_count])
	_expect(loop.run_state.current_room_index == 0, "the run did not start at room 1")
	_expect(loop.room_modules[0].module_id == ROUTE_A[0],
		"room 1 is %s, not the selected %s" % [loop.room_modules[0].module_id, ROUTE_A[0]])
	_expect(loop.player.global_position.distance_to(loop.room_modules[0].entry_point()) < 0.6,
		"the player did not arrive at room 1's own entry point")
	## The enemies of THIS room are live and no others are.
	var live: int = 0
	for enemy: PrototypeGraveblade in loop.graveblades:
		if enemy.ai_enabled:
			live += 1
	_expect(live == loop.room_modules[0].encounter_count(),
		"%d enemies are active on entering room 1, not %d" % [live, loop.room_modules[0].encounter_count()])
	print("  %s → %s" % [loop.run_state.plan.run_id(), (loop.plan as RogueliteSeededRunPlan).route_line()])
	_done("the_run_follows_the_selected_route")


func _check_combat_gate_holds_and_opens() -> void:
	print("")
	print("--- The room's gate is sealed until it is cleared, and the route cannot change mid-run")
	var module: RogueliteRoomModule = loop.room_modules[0]
	_expect(not module.exit_gate_open, "room 1's gate is open before the room was cleared")
	await _walk_into_gate(module.exit_point())
	_expect(loop.run_state.current_room_index == 0,
		"a sealed gate let the player through before the room was cleared")

	## F7 changes the route only in the Nexus. Changing it under a player
	## standing in room two would be a different thing entirely.
	var route_before: Array[StringName] = loop.selected_ids()
	var reselections_before: int = loop.route_reselections
	loop._reroll_route()
	_expect(loop.selected_ids() == route_before, "the route changed during a run")
	_expect(loop.route_reselections == reselections_before,
		"a mid-run route reselection was counted rather than refused")

	## THE WORN BLADE BASELINE, MEASURED AGAINST A REAL ENEMY. Recorded here and
	## asserted by the damage-proof check, so the claim "three Hits, then two"
	## is owed by the one function that makes it.
	_worn_hits = await _kill(loop.room_enemies[0][0])
	await _settle(6)
	_expect(module.exit_gate_open, "clearing room 1 did not open its gate")
	_expect(loop.run_state.is_cleared(0), "room 1 was not recorded as cleared")

	await _walk_into_gate(module.exit_point())
	_expect(loop.run_state.current_room_index == 1,
		"the opened gate did not advance the run to room 2")
	_expect(loop.room_modules[1].module_id == ROUTE_A[1],
		"room 2 is %s, not the selected %s" % [loop.room_modules[1].module_id, ROUTE_A[1]])
	print("  sealed → cleared in %d Hit(s) → open → room 2 (%s)" % [
		_worn_hits, RogueliteRoomLibrary.display_name_of(ROUTE_A[1]),
	])
	_done("combat_gate_holds_and_opens")


func _check_the_cache_offers_exactly_two_choices() -> void:
	print("")
	print("--- Clearing the reward room offers EXACTLY TWO readable choices, gate still sealed")
	var index: int = loop.reward_beat_index()
	_expect(loop.run_state.current_room_index == index,
		"the verification is not standing in the reward room")
	var module: RogueliteRoomModule = loop.room_modules[index]
	_expect(loop._active_drop == null, "a ground item exists before the room was cleared")

	for enemy: PrototypeGraveblade in loop.room_enemies[index]:
		if enemy.is_alive():
			var hits: int = await _kill(enemy)
			_expect(hits == 3, "%s took %d Hit(s) on the Worn Blade, not 3" % [enemy.name, hits])
	await _settle(4)
	_expect(loop.awaiting_boon_choice(), "clearing the reward room did not open the cache")
	_expect(not module.exit_gate_open,
		"the reward room's gate opened before the boon was taken — the reward can be walked past")
	_expect(not loop.run_state.is_cleared(index),
		"the reward room counts as cleared before its boon was taken")
	## And the gate genuinely refuses, not merely looks shut.
	await _walk_into_gate(module.exit_point())
	_expect(loop.run_state.current_room_index == index,
		"the player left the reward room before taking the guaranteed reward")

	await _await_boon_panel()
	_expect(loop.boon_panel.is_open, "the boon choice panel did not open")
	_expect(get_tree().paused, "opening the boon choice did not pause ordinary simulation")
	_expect(loop.boon_panel.choice_count() == 2,
		"the cache offers %d choices, not exactly two" % loop.boon_panel.choice_count())
	## Cancel must not dismiss it: the gate is sealed until a choice is made, so
	## a dismissable panel would strand the run behind a gate it cannot open.
	_expect(not loop.boon_panel.cancel_closes(), "the boon choice can be cancelled without choosing")

	var captions: PackedStringArray = PackedStringArray()
	for button: Button in loop.boon_panel.choice_buttons():
		var caption: String = _button_caption(button)
		_expect(not caption.strip_edges().is_empty(), "a choice button has no readable caption")
		captions.append(caption)
	_expect(captions.size() == 2 and captions[0] != captions[1],
		"the two choices are not distinguishable: %s" % str(captions))
	_expect(captions[0].contains("Expedition Blade"),
		"the first choice is not the Expedition Blade: '%s'" % captions[0])
	_expect(captions[1].contains("Quickened Edge"),
		"the second choice is not the Quickened Edge: '%s'" % captions[1])
	print("  \"%s\"  |  \"%s\"" % [captions[0], captions[1]])

	## Take the blade through the real button, not through the handler.
	loop.boon_panel.choice_buttons()[0].emit_signal("pressed")
	await _settle(4)
	_expect(not loop.boon_panel.is_open, "the boon panel is still open after a choice")
	_expect(not get_tree().paused, "the world is still paused after the boon panel closed")
	_expect(loop.run_boon != null and loop.run_boon.is_weapon(),
		"the chosen boon is not the Expedition Blade")
	_expect(module.exit_gate_open, "taking the boon did not open the reward room's gate")
	_expect(loop.run_state.is_cleared(index), "taking the boon did not clear the reward room")
	_expect(loop.boons_offered == 1 and loop.boons_taken == 1,
		"the cache was offered %d time(s) and taken %d" % [loop.boons_offered, loop.boons_taken])
	_done("the_cache_offers_exactly_two_choices")


## The established proof, preserved intact: 100 → 150 damage, three Hits → two
## against the same 300-Life Graveblade, read off the accepted comparison panel
## and then measured against a real enemy rather than against the record.
func _check_the_blade_reproduces_the_damage_proof() -> void:
	print("")
	print("--- The Expedition Blade still proves 100 → 150 and three Hits → two")
	_expect(_worn_hits == 3,
		"the Worn Blade took %d Hit(s) against %.0f Life, not 3" % [_worn_hits, ORDINARY_LIFE])
	var drop: FirstMvpItemDrop = loop._active_drop
	_expect(drop != null, "taking the Expedition Blade placed no ground item")
	if drop == null:
		_done("the_blade_reproduces_the_damage_proof")
		return
	var module: RogueliteRoomModule = loop.room_modules[loop.reward_beat_index()]
	_expect(String(drop.weapon.weapon_id) == "roguelite_expedition_blade",
		"the ground item is not the accepted Expedition Blade")
	var to_gate: float = drop.global_position.distance_to(module.exit_point())
	_expect(to_gate > RogueliteCoreLoopRuntime.GATE_ENTER_RADIUS + 1.5,
		"the reward is %.2f m from a gate that triggers at %.2f m" % [
			to_gate, RogueliteCoreLoopRuntime.GATE_ENTER_RADIUS,
		])
	## Proved by BEHAVIOUR as well as by arithmetic: standing exactly on the
	## item must leave the player in the room.
	await _walk_into_gate(drop.global_position)
	_expect(loop.run_state.current_room_index == loop.reward_beat_index(),
		"standing on the reward advanced the run — the item is inside the gate trigger")
	_expect(loop._active_drop != null, "standing on the reward destroyed it")

	_expect(is_equal_approx(loop.graveblade_max_life(), ORDINARY_LIFE),
		"the comparison would quote %.0f Life, not the reward room's own %.0f" % [
			loop.graveblade_max_life(), ORDINARY_LIFE,
		])
	_expect(loop.loadout.equipped_weapon.hits_to_defeat(ORDINARY_LIFE) == 3,
		"the current weapon does not need 3 Hits")
	_expect(drop.weapon.hits_to_defeat(ORDINARY_LIFE) == 2, "the reward does not need 2 Hits")

	loop.open_item_comparison("verification")
	await _settle(2)
	_expect(loop.item_comparison.is_open, "the accepted comparison panel did not open")
	loop.item_comparison._on_equip_pressed()
	await _settle(2)
	_expect(not loop.item_comparison.is_open, "the comparison is still open after Equip")
	_expect(is_equal_approx(loop.player.weapon.physical_damage, EXPEDITION_DAMAGE),
		"Quick Strike deals %.0f after Equip, not %.0f" % [
			loop.player.weapon.physical_damage, EXPEDITION_DAMAGE,
		])
	_expect(loop._active_drop == null, "the ground item survived being equipped")
	_expect(loop.run_state.reward_equipped, "the run did not record that its reward was equipped")
	## The blade must not have quietly changed anything else.
	_expect(is_zero_approx(loop.player.increased_attack_speed()),
		"equipping the Expedition Blade also changed attack speed")

	## THE PROOF ITSELF, AGAINST A REAL ENEMY. The only ordinary 300-Life
	## Graveblade still standing is the elite room's escort, so that is the
	## witness, and it is left dead rather than revived.
	await _walk_into_gate(loop.room_modules[loop.reward_beat_index()].exit_point())
	_expect(loop.run_state.current_room_index == loop.elite_beat_index(),
		"the run did not advance to the elite room")
	_expect(loop.room_modules[2].module_id == ROUTE_A[2],
		"room 3 is %s, not the selected %s" % [loop.room_modules[2].module_id, ROUTE_A[2]])
	var escort: PrototypeGraveblade = loop.room_enemies[2][1]
	_expect(is_equal_approx(escort.data.max_life, ORDINARY_LIFE),
		"the witness is not an ordinary %.0f-Life Graveblade" % ORDINARY_LIFE)
	var upgraded_hits: int = await _kill(escort)
	_expect(upgraded_hits == 2,
		"an upgraded Quick Strike took %d Hit(s) against %.0f Life, not 2" % [upgraded_hits, ORDINARY_LIFE])
	## And the Elite is still the same fight with one number moved.
	var elite: PrototypeGraveblade = loop.room_enemies[2][0]
	_expect(is_equal_approx(elite.data.max_life, ELITE_LIFE),
		"the elite room's first enemy is not the %.0f-Life Vanguard" % ELITE_LIFE)
	var elite_hits: int = await _kill(elite)
	_expect(elite_hits == 4,
		"the Elite took %d upgraded Hit(s) against %.0f Life, not 4" % [elite_hits, ELITE_LIFE])
	await _settle(6)
	print("  100 → 150 damage; the same 300-Life Graveblade fell in %d Hits, then in %d; the Elite in %d" % [
		_worn_hits, upgraded_hits, elite_hits,
	])
	_done("the_blade_reproduces_the_damage_proof")


func _check_only_one_boon_per_run() -> void:
	print("")
	print("--- Exactly one boon per expedition; a second choice is refused and counted")
	var taken_before: int = loop.boons_taken
	var refusals_before: int = loop.run_state.refusals
	loop._on_boon_chosen(RogueliteRunBoon.Kind.QUICKENED_EDGE)
	_expect(loop.boons_taken == taken_before, "a second boon was taken in the same expedition")
	_expect(loop.run_boon.is_weapon(), "a second choice replaced the boon already taken")
	_expect(is_zero_approx(loop.player.increased_attack_speed()),
		"a refused second choice still applied its effect")
	_expect(not loop.awaiting_boon_choice(), "the cache is still pending after a boon was taken")
	## The guaranteed reward door is idempotent in the accepted sense too.
	_expect(not loop.run_state.grant_reward(), "the guaranteed reward could be granted twice")
	_expect(loop.run_state.refusals > refusals_before, "the duplicate grant was not counted")
	print("  second choice refused; still holding %s" % loop.run_boon.display_name())
	_done("only_one_boon_per_run")


func _check_a_completed_run_clears_its_boon() -> void:
	print("")
	print("--- Clearing the last room returns to the Nexus and the boon goes with the run")
	_expect(loop.room_modules[2].exit_gate_open, "clearing the elite room did not open its gate")
	var completed_id: String = loop.run_state.plan.run_id()
	await _walk_into_gate(loop.room_modules[2].exit_point())
	_expect(loop.loop_state == RogueliteCoreLoopRuntime.LoopState.RUN_COMPLETE,
		"the last gate did not complete the run")
	_expect(loop.runs_completed == 1, "runs_completed is %d, not 1" % loop.runs_completed)
	_expect(loop.player.global_position.distance_to(loop.hub_module.entry_point()) < 0.6,
		"the player did not return to the hub's own entry point")
	_expect(loop.summary_panel.is_open, "the run-complete panel did not open")
	## THE CAMERA MUST ALREADY BE AT THE NEXUS BEHIND THE PANEL — the accepted
	## runtime's own recorded defect, re-asserted because this review adds a
	## surface in front of it.
	var camera_to_hub: float = loop.camera_rig.camera.global_position.distance_to(loop.hub_module.entry_point())
	var camera_to_last: float = loop.camera_rig.camera.global_position.distance_to(loop.room_modules[2].exit_point())
	_expect(camera_to_hub < camera_to_last,
		"the run-complete panel opened over the room just left (%.1f m from the Nexus, %.1f m from the room)" % [
			camera_to_hub, camera_to_last,
		])
	_expect(loop.run_state.cleared_rooms.size() == EXPECTED_BEATS,
		"%d room(s) recorded as cleared, not %d" % [loop.run_state.cleared_rooms.size(), EXPECTED_BEATS])

	## The panel must be able to report a run whose state has already been
	## cleared — that is exactly why the completed boon is captured first.
	_expect(loop.completed_run_boon != null and loop.completed_run_boon.is_weapon(),
		"the run summary cannot report which boon the finished run was taken with")
	var summary_text: String = _text_of(loop.summary_panel.text_controls())
	_expect(summary_text.contains("Expedition Blade"),
		"the run summary does not name the boon that was taken")
	_expect(summary_text.contains(RogueliteRoomLibrary.display_name_of(ROUTE_A[0])),
		"the run summary does not name the route it was run on")

	## And the boon is gone in every sense, at the moment the panel says so.
	_expect(loop.run_boon == null, "the completed run kept its boon object")
	_expect(is_equal_approx(loop.player.weapon.physical_damage, WORN_DAMAGE),
		"a completed run kept its %.0f-damage weapon" % loop.player.weapon.physical_damage)
	_expect(String(loop.loadout.equipped_weapon.weapon_id) == "roguelite_worn_blade",
		"the equipped weapon after a completed run is not the Worn Blade")
	for owned: PrototypeWeaponData in loop.loadout.owned_items:
		_expect(String(owned.weapon_id) != "roguelite_expedition_blade",
			"the Expedition Blade is still OWNED after a completed run")
	_expect(is_zero_approx(loop.player.increased_attack_speed()),
		"a completed run kept an attack-speed boon")
	_expect(not loop._drop_granted, "the drop latch survived a completed run")

	loop.summary_panel.close("verification")
	await _settle(2)
	_expect(not get_tree().paused, "closing the run summary left the world paused")
	_expect(loop.plan.run_id() != completed_id,
		"the Nexus is still advertising the run that just finished")
	print("  %s complete on %s; Worn Blade back, nothing owned, attack speed 0" % [
		completed_id, (loop.run_state.plan as RogueliteSeededRunPlan).route_line(),
	])
	_done("a_completed_run_clears_its_boon")


# --- 5. A second run, a different route, the other boon -----------------------------

func _check_a_second_run_takes_a_different_route() -> void:
	print("")
	print("--- A second expedition in the SAME session takes a different route, with no rebuild")
	var previous: Array[StringName] = ROUTE_A
	var bakes_before: int = loop.bake_count
	var reselections_before: int = loop.route_reselections

	## F7 in the Nexus: the same deterministic successor a finished run takes,
	## reachable without leaving the hub so two runs can be compared.
	loop._reroll_route()
	_expect(loop.route_reselections == reselections_before + 1,
		"F7 in the Nexus did not reselect the route")

	## And then the documented second seed, so the comparison is reproducible.
	loop.plan = RogueliteSeededRunPlan.new(SEED_B, 0)
	loop.run_state = RogueliteRunState.new(loop.plan)
	await _walk_into_gate(loop.hub_module.exit_point())
	_expect(loop.loop_state == RogueliteCoreLoopRuntime.LoopState.IN_RUN,
		"a second run could not be started after the first completed")
	_expect(loop.selected_ids() == ROUTE_B,
		"the second run took %s, not the documented %s" % [loop.selected_ids(), ROUTE_B])
	var differing: int = 0
	for index: int in EXPECTED_BEATS:
		if loop.selected_ids()[index] != previous[index]:
			differing += 1
	_expect(differing == EXPECTED_BEATS,
		"the second run shares %d of %d rooms with the first" % [EXPECTED_BEATS - differing, EXPECTED_BEATS])
	_expect(loop.bake_count == bakes_before,
		"taking a different route re-baked the navigation mesh (%d → %d)" % [bakes_before, loop.bake_count])
	_expect(loop.runs_started == 2, "runs_started is %d, not 2" % loop.runs_started)
	_expect(loop.run_state.current_room_index == 0, "the second run did not start at room 1")
	_expect(loop.room_modules[0].module_id == ROUTE_B[0],
		"the second run's first room is %s" % loop.room_modules[0].module_id)
	print("  run 1 %s" % " → ".join(PackedStringArray(previous.map(
		func(id: StringName) -> String: return RogueliteRoomLibrary.display_name_of(id)))))
	print("  run 2 %s — same session, same bake" % (loop.plan as RogueliteSeededRunPlan).route_line())
	_done("a_second_run_takes_a_different_route")


## The second choice reuses an ESTABLISHED, working combat property and nothing
## else: `QuickStrikeAction.increased_attack_speed`, the same single field
## Prototype Zero's Quickened Form and Gate 1E's First Fracture both used, at
## the same accepted 0.25. It is measured two ways — the derived numbers, which
## are exact, and the actual number of physics frames one Quick Strike takes,
## which is the behaviour.
func _check_the_edge_reuses_the_established_property() -> void:
	print("")
	print("--- The Quickened Edge moves ONE established field, and the swing is measurably faster")
	var strike: QuickStrikeData = loop.canonical_quick_strike_record()
	_expect(is_zero_approx(loop.player.increased_attack_speed()),
		"the run began with an attack-speed modifier already applied")
	var baseline_frames: int = await _measure_action_frames()

	## Clear the opening room and the reward room of this route.
	await _kill(loop.room_enemies[0][0])
	await _settle(4)
	await _walk_into_gate(loop.room_modules[0].exit_point())
	_expect(loop.run_state.current_room_index == 1, "the second run did not reach its reward room")
	for enemy: PrototypeGraveblade in loop.room_enemies[1]:
		if enemy.is_alive():
			await _kill(enemy)
	await _settle(4)
	await _await_boon_panel()
	_expect(loop.boon_panel.is_open, "the cache did not open on the second run")

	loop.boon_panel.choice_buttons()[1].emit_signal("pressed")
	await _settle(4)
	_expect(loop.run_boon != null and loop.run_boon.is_attack_speed(),
		"the second choice did not grant the attack-speed boon")
	## It is not an item, and it must not have become one.
	_expect(loop._active_drop == null, "the Quickened Edge placed a ground item")
	_expect(is_equal_approx(loop.player.weapon.physical_damage, WORN_DAMAGE),
		"the Quickened Edge changed the weapon's damage to %.0f" % loop.player.weapon.physical_damage)
	_expect(String(loop.loadout.equipped_weapon.weapon_id) == "roguelite_worn_blade",
		"the Quickened Edge replaced the equipped weapon")

	## The one established field, at the accepted value.
	_expect(is_equal_approx(loop.player.increased_attack_speed(), RogueliteRunBoon.QUICKENED_INCREASE),
		"increased attack speed is %.3f, not the accepted %.3f" % [
			loop.player.increased_attack_speed(), RogueliteRunBoon.QUICKENED_INCREASE,
		])
	_expect(is_equal_approx(loop.player.attack.effective_action_time(), QUICKENED_ACTION_TIME),
		"the Quick Strike action time is %.4f s, not %.2f" % [
			loop.player.attack.effective_action_time(), QUICKENED_ACTION_TIME,
		])
	_expect(is_equal_approx(loop.player.attack.windup_time(),
			strike.windup_time() / (1.0 + RogueliteRunBoon.QUICKENED_INCREASE)),
		"the wind-up did not scale with the action")
	## D-191's rule: the canonical authored record is never written to.
	_expect(is_equal_approx(strike.action_time, ACCEPTED_ACTION_TIME),
		"the canonical quick_strike.tres was written to — it now reads %.4f s" % strike.action_time)
	_expect(loop.player.attack.data_is_private(),
		"the Quick Strike action is not using its own private runtime copy")
	## Nothing else in the kernel moved.
	_expect(is_equal_approx(loop.player.attack.data.reach, ACCEPTED_REACH),
		"the boon changed Quick Strike's reach")
	_expect(is_equal_approx(loop.player.attack.data.release_marker_normalized, ACCEPTED_RELEASE_MARKER),
		"the boon moved the release marker")

	## AND MEASURED AS BEHAVIOUR, in physics frames, not read off the record.
	var boosted_frames: int = await _measure_action_frames()
	var ratio: float = float(boosted_frames) / maxf(float(baseline_frames), 1.0)
	_expect(absi(baseline_frames - 48) <= 2,
		"an unmodified Quick Strike took %d physics frames, not about 48 (0.80 s at 60 Hz)" % baseline_frames)
	_expect(absi(boosted_frames - 38) <= 2,
		"a quickened Quick Strike took %d physics frames, not about 38 (0.64 s at 60 Hz)" % boosted_frames)
	_expect(absf(ratio - 0.80) <= 0.04,
		"the quickened swing took %.3f of the baseline, not about 0.80" % ratio)
	print("  +%.0f%% attack speed: %.2f s → %.2f s, measured %d → %d physics frames (%.3f×)" % [
		RogueliteRunBoon.QUICKENED_INCREASE * 100.0, strike.action_time,
		loop.player.attack.effective_action_time(), baseline_frames, boosted_frames, ratio,
	])
	_done("the_edge_reuses_the_established_property")


func _check_death_clears_the_boon() -> void:
	print("")
	print("--- Death returns to the Nexus and the boon is genuinely gone")
	_expect(loop.run_boon != null and loop.run_boon.is_attack_speed(),
		"the death test does not begin with a boon to lose")
	var dying_run: String = loop.run_state.plan.run_id()

	var lethal: DamageEvent = DamageEvent.physical(
		90001, loop.room_enemies[1][0], loop.player, loop.player.max_life + 999.0
	)
	loop.player.receive_damage(lethal)
	_expect(not loop.player.is_alive(), "the player did not fall from a lethal DamageEvent")
	for frame: int in 200:
		if loop.fallen_overlay.is_open:
			break
		await get_tree().physics_frame
	_expect(loop.fallen_overlay.is_open, "the Fallen overlay did not open")
	_expect(loop.fallen_overlay is RogueliteFallenOverlay,
		"the Fallen overlay is Gate 1D's own, whose copy names Broken Watch")
	_expect(loop.fallen_overlay.killing_source.contains("Graveblade"),
		"Fallen does not name the Graveblade: '%s'" % loop.fallen_overlay.killing_source)

	loop.fallen_overlay._on_restart()
	await _settle(8)

	_expect(loop.loop_state == RogueliteCoreLoopRuntime.LoopState.HUB,
		"death did not return the player to the Nexus")
	_expect(loop.player.is_alive() and is_equal_approx(loop.player.life, loop.player.max_life),
		"the player is not back at full Life")
	_expect(loop.run_boon == null, "the boon object survived death")
	_expect(is_zero_approx(loop.player.increased_attack_speed()),
		"attack speed is still %.3f after death — the boon survived" % loop.player.increased_attack_speed())
	_expect(is_equal_approx(loop.player.attack.effective_action_time(), ACCEPTED_ACTION_TIME),
		"the Quick Strike action time is still %.4f s after death" % loop.player.attack.effective_action_time())
	_expect(is_equal_approx(loop.player.weapon.physical_damage, WORN_DAMAGE),
		"the weapon after death is not the Worn Blade")
	_expect(loop._active_drop == null, "a ground item survived death")
	_expect(not loop.run_state.reward_granted, "the new run inherited the previous run's reward state")
	_expect(loop.run_state.cleared_rooms.is_empty(), "the new run inherited cleared rooms")
	_expect(loop.run_state.plan.run_id() != dying_run,
		"the run after death reuses the dead run's id %s" % dying_run)

	## EVERY room in the library is restored, not only the three that were
	## selected: a room cleared on an earlier route and skipped by this one
	## would otherwise be re-entered already finished.
	var restored: int = 0
	for id: StringName in loop.variant_modules:
		var module: RogueliteVariantRoomModule = loop.variant_modules[id]
		_expect(not module.exit_gate_open, "%s's gate is still open after the reset" % module.name)
		var spawns: Array[Vector3] = module.spawn_points()
		for slot: int in loop._enemies_by_module[id].size():
			var enemy: PrototypeGraveblade = loop._enemies_by_module[id][slot]
			var expected_life: float = ELITE_LIFE if enemy.data.max_life == ELITE_LIFE else ORDINARY_LIFE
			_expect_quiet(enemy.is_alive() and is_equal_approx(enemy.life, expected_life),
				"%s is not restored to %.0f Life" % [enemy.name, expected_life])
			_expect_quiet(enemy.global_position.distance_to(spawns[slot]) < 0.5,
				"%s reset to %s, not its own spawn %s" % [enemy.name, enemy.global_position, spawns[slot]])
			_expect_quiet(not enemy.ai_enabled, "%s is active while the player is in the hub" % enemy.name)
			if enemy.is_alive() and not enemy.ai_enabled:
				restored += 1
	_expect(restored == EXPECTED_ENEMIES,
		"%d of %d enemies across the whole library were restored" % [restored, EXPECTED_ENEMIES])
	print("  Nexus, full Life, Worn Blade, attack speed 0, all %d enemies in all %d rooms restored" % [
		restored, loop.variant_modules.size(),
	])
	_done("death_clears_the_boon")


func _check_abandon_clears_the_boon() -> void:
	print("")
	print("--- Abandoning a run (F5) clears the boon by the same one path death uses")
	await _walk_into_gate(loop.hub_module.exit_point())
	_expect(loop.loop_state == RogueliteCoreLoopRuntime.LoopState.IN_RUN,
		"no run could be started after a death")
	await _kill(loop.room_enemies[0][0])
	await _settle(4)
	await _walk_into_gate(loop.room_modules[0].exit_point())
	for enemy: PrototypeGraveblade in loop.room_enemies[1]:
		if enemy.is_alive():
			await _kill(enemy)
	await _settle(4)
	await _await_boon_panel()
	loop.boon_panel.choice_buttons()[1].emit_signal("pressed")
	await _settle(4)
	_expect(loop.run_boon != null and loop.run_boon.is_attack_speed(),
		"the abandon test does not begin with a boon to lose")
	_expect(is_equal_approx(loop.player.increased_attack_speed(), RogueliteRunBoon.QUICKENED_INCREASE),
		"the boon was not applied before the abandon test")

	## Exactly what F5 does: the accepted overlay's button and the bound key
	## both route here, so the two can never drift apart.
	loop.restart_current_slice("quick restart")
	await _settle(6)
	_expect(loop.loop_state == RogueliteCoreLoopRuntime.LoopState.HUB,
		"abandoning did not return the player to the Nexus")
	_expect(loop.run_boon == null, "the boon object survived an abandon")
	_expect(is_zero_approx(loop.player.increased_attack_speed()),
		"attack speed is still %.3f after an abandon" % loop.player.increased_attack_speed())
	_expect(is_equal_approx(loop.player.weapon.physical_damage, WORN_DAMAGE),
		"the weapon after an abandon is not the Worn Blade")
	_expect(not loop.awaiting_boon_choice(), "a cache was left pending after an abandon")
	_expect(not loop.boon_panel.is_open, "the boon panel survived an abandon")
	print("  abandoned mid-run: Nexus, Worn Blade, attack speed 0, no pending cache")
	_done("abandon_clears_the_boon")


func _check_the_next_run_starts_clean() -> void:
	print("")
	print("--- The next expedition initialises clean, on its own route")
	var route_before: Array[StringName] = loop.selected_ids()
	await _walk_into_gate(loop.hub_module.exit_point())
	_expect(loop.loop_state == RogueliteCoreLoopRuntime.LoopState.IN_RUN,
		"no run could be started after an abandon")
	_expect(loop.run_boon == null, "the new run began holding a boon")
	_expect(is_zero_approx(loop.player.increased_attack_speed()),
		"the new run began with an attack-speed modifier")
	_expect(is_equal_approx(loop.player.weapon.physical_damage, WORN_DAMAGE),
		"the new run did not begin on the Worn Blade")
	_expect(not loop.run_state.reward_granted and not loop.run_state.reward_equipped,
		"the new run inherited a reward state")
	_expect(loop.run_state.cleared_rooms.is_empty(), "the new run began with cleared rooms")
	_expect(loop._active_drop == null, "a ground item survived into the new run")
	_expect(loop.completed_run_boon == null, "the new run began holding a finished run's boon")
	_expect(loop.selected_ids().size() == EXPECTED_BEATS,
		"the new run selected %d rooms" % loop.selected_ids().size())
	## The route is whatever the seed says; what matters is that it IS the
	## plan's own answer rather than a leftover.
	_expect(loop.selected_ids() == (loop.run_state.plan as RogueliteSeededRunPlan).ordered_modules(),
		"the run's rooms are not the ones its own plan selected")
	_expect(loop.bake_count == 1, "the session has baked %d times" % loop.bake_count)
	print("  %s on %s (previous route %s)" % [
		loop.run_state.plan.run_id(),
		(loop.run_state.plan as RogueliteSeededRunPlan).route_line(),
		" → ".join(PackedStringArray(route_before.map(
			func(id: StringName) -> String: return RogueliteRoomLibrary.display_name_of(id)))),
	])
	loop.restart_current_slice("verification tidy-up")
	await _settle(6)
	_done("the_next_run_starts_clean")


# --- 6. Boundaries -----------------------------------------------------------------

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
			"RunGraph", "run_graph", "DungeonRecipe", "RandomNumberGenerator",
			"randi", "randf", "Time.get_unix", "Time.get_ticks", "CharacterState",
			"ExperienceTable", "FoundationCache", "OriginRing", "Boss", "Warden",
			"EliteModifier", "currency", "Bindstone", "Resonance",
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
	## And no branching: the route is a flat list of one room per beat, and the
	## plan exposes no branch, no optional room and no depth.
	var plan: RogueliteSeededRunPlan = RogueliteSeededRunPlan.new(SEED_A, 0)
	for absent: String in ["branches", "optional_rooms", "depth", "difficulty", "rooms_per_run", "generate"]:
		_expect(not (absent in plan),
			"the seeded plan exposes %s — this review builds no route graph" % absent)
	for absent: String in ["experience", "currency", "unlocks", "meta", "save_path", "storage_path"]:
		_expect(not (absent in loop),
			"the runtime exposes %s — this review has no persistence or progression" % absent)
	var runtime_code: String = _code_only(FileAccess.get_file_as_string(RUNTIME_SCRIPT))
	_expect(not runtime_code.contains("watchsteel"),
		"the runtime loads Gate 1D's own Watchsteel record")
	print("  no excluded system, no branch, no generator, no asset path, no clock, no engine RNG")
	_done("excluded_systems_absent")


## Ported from Gate F for the reason it was written: reading the right words out
## of a Control tree proves the words EXIST, not that anyone can see them.
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
	## EXACTLY thirteen — the accepted banner's eight plus the boon line, the
	## route heading and the three route steps this review adds. A `>=` guard
	## would tolerate one label being invisible, which is precisely the Gate F
	## failure mode this check was ported to catch.
	_expect(hud_visible == 13, "%d of 13 run-HUD labels are visible on screen" % hud_visible)
	var hud_text: String = _text_of(loop.run_hud.text_controls())
	_expect(hud_text.contains("seed 0x"), "the run HUD does not display the seed")
	## Case-insensitive on purpose: the heading is "Route" inside a run and
	## "Next route" in the Nexus, and pinning one capitalisation would be
	## pinning the copy rather than the property the copy owes.
	_expect(hud_text.to_lower().contains("route"), "the run HUD does not display the route")
	## The route the HUD is SHOWING, which in the Nexus is the plan the next
	## expedition will use rather than the rooms the last one happened to run.
	## Comparing against `selected_ids()` here would compare the banner to a
	## finished run and fail for the wrong reason.
	var shown: RogueliteSeededRunPlan = (loop.run_state.plan if loop.loop_state
		== RogueliteCoreLoopRuntime.LoopState.IN_RUN else loop.plan) as RogueliteSeededRunPlan
	_expect(shown != null, "the plan the run HUD is showing is not a seeded plan")
	for id: StringName in shown.ordered_modules():
		_expect(hud_text.contains(RogueliteRoomLibrary.display_name_of(id)),
			"the run HUD does not name the room %s it is displaying" % id)

	loop.boon_panel.open()
	await _await_process_frames(6)
	_expect(loop.boon_panel.size.x >= viewport.size.x - 1.0
			and loop.boon_panel.size.y >= viewport.size.y - 1.0,
		"the boon panel's root does not cover the viewport (%s vs %s)" % [loop.boon_panel.size, viewport.size])
	var boon_visible: int = _measure_text(loop.boon_panel.text_controls(), viewport, "boon choice")
	_expect(boon_visible == 27, "%d of 27 boon-choice controls are visible on screen" % boon_visible)
	## AND THE PANEL ITSELF MUST FIT. `_measure_text` only asks for an
	## intersection, and Gate F's two real layout faults were a clipped column
	## and buttons BELOW the screen — both of which intersect.
	var body: Control = loop.boon_panel.get_node("Panel") as Control
	_expect(body != null and viewport.encloses(body.get_global_rect()),
		"the boon panel's own rectangle %s does not fit inside the %s viewport" % [
			"none" if body == null else str(body.get_global_rect()), viewport.size,
		])
	var boon_text: String = _text_of(loop.boon_panel.text_controls())
	_expect(boon_text.contains("Expedition Blade") and boon_text.contains("Quickened Edge"),
		"the boon panel does not name both choices")
	_expect(boon_text.contains("0.80 s") and boon_text.contains("0.64 s"),
		"the boon panel does not state the measured attack-time change")
	_expect(boon_text.contains("150"), "the boon panel does not state the Expedition Blade's damage")
	loop.boon_panel.close("verification")
	await _await_process_frames(2)

	loop.summary_panel.open_for(loop.run_state)
	await _await_process_frames(4)
	_expect(loop.summary_panel.size.x >= viewport.size.x - 1.0
			and loop.summary_panel.size.y >= viewport.size.y - 1.0,
		"the run summary's root does not cover the viewport")
	var summary_visible: int = _measure_text(loop.summary_panel.text_controls(), viewport, "run summary")
	_expect(summary_visible == 8, "%d of 8 run-summary controls are visible on screen" % summary_visible)
	loop.summary_panel.close("verification")
	await _await_process_frames(2)

	_expect(not get_tree().paused, "a measured surface left the world paused")
	_expect(not loop.item_comparison.is_open and not loop.summary_panel.is_open
			and not loop.boon_panel.is_open and not loop.fallen_overlay.is_open,
		"a modal was left open by the on-screen measurement")
	print("  run HUD %d, boon choice %d, run summary %d — 0 off screen" % [
		hud_visible, boon_visible, summary_visible,
	])
	_done("surfaces_are_on_screen")


# --- Evidence ----------------------------------------------------------------------

## THE EVIDENCE PASS ADDS EXACTLY FIVE ASSERTIONS, AND THAT IS PINNED RATHER
## THAN HIDDEN. `_kill()` asserts that the enemy actually died, and the pass
## kills five of them (1 + 2 + 2). The accepted core loop's runner carries two
## pins for exactly this reason, and so does Gate 1C.
func _capture_evidence() -> void:
	print("")
	print("--- Rendered evidence")
	loop.restart_current_slice("evidence")
	await _settle(6)
	loop.plan = RogueliteSeededRunPlan.new(SEED_A, 0)
	loop.run_state = RogueliteRunState.new(loop.plan)
	loop._refresh_run_hud()
	loop.set_grid_visible(false)
	await _frame_at(loop.hub_module.entry_point() + loop.hub_module.route_forward() * 6.0, "01_nexus_hub")

	await _walk_into_gate(loop.hub_module.exit_point())
	await _frame_at(loop.room_modules[0].entry_point() + loop.room_modules[0].route_forward() * 9.0,
		"02_opening_room")

	await _kill(loop.room_enemies[0][0])
	await _settle(6)
	await _walk_into_gate(loop.room_modules[0].exit_point())
	for enemy: PrototypeGraveblade in loop.room_enemies[1]:
		if enemy.is_alive():
			await _kill(enemy)
	await _settle(6)
	await _await_boon_panel()
	await _await_process_frames(6)
	await _shoot("03_cache_two_choices")

	loop.boon_panel.choice_buttons()[0].emit_signal("pressed")
	await _await_process_frames(4)
	if loop._active_drop != null:
		loop.open_item_comparison("evidence")
		await _await_process_frames(6)
		await _shoot("04_item_comparison")
		loop.item_comparison._on_equip_pressed()
		await _await_process_frames(4)

	await _walk_into_gate(loop.room_modules[1].exit_point())
	await _frame_at(loop.room_modules[2].entry_point() + loop.room_modules[2].route_forward() * 10.0,
		"05_elite_room")

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
	await _overhead_frame("07_room_library")
	loop.set_grid_visible(false)
	await _settle(2)


func _frame_at(at: Vector3, stem: String) -> void:
	loop.player.global_position = Vector3(at.x, 0.0, at.z)
	loop.player.velocity = Vector3.ZERO
	loop.player.clear_movement_intent("evidence", false)
	loop.camera_rig.focus = loop.player.global_position
	await _await_process_frames(6)
	await _shoot(stem)


## One overhead frame of the whole authored library, so the ten disjoint
## modules, their three beat columns and the gaps between them are visible at
## once. The camera calibration is restored afterwards.
##
## `camera.far` IS RAISED FOR THIS FRAME, AND THAT IS A DEFECT THIS FILE HAD
## UNTIL A RENDERED PICTURE SHOWED IT. `PrototypeCameraRig` builds its camera
## with `far = 300.0`, which is generous for a 19 m gameplay camera and far too
## near for an overhead of a 293 x 293 m library: the first version pulled back
## to 390 m and captured a COMPLETELY EMPTY frame — correct HUD, correct
## camera, no world at all, because every module was behind the far plane. Two
## assertions and one measured distance would not have caught it; only looking
## at the picture did. The library needs 354 m of pull-back to fit in a 45
## degree vertical field of view, so the plane has to move for the shot and is
## put back afterwards.
func _overhead_frame(stem: String) -> void:
	var distance_before: Vector2 = loop.camera_rig.distance_range
	var pitch_before: Vector2 = loop.camera_rig.pitch_range
	var far_before: float = loop.camera_rig.camera.far
	loop.camera_rig.camera.far = 1500.0
	loop.camera_rig.distance_range = Vector2(10.0, 520.0)
	loop.camera_rig.pitch_range = Vector2(30.0, 89.0)
	loop.camera_rig.adjust_pitch(88.0 - loop.camera_rig.pitch_degrees)
	loop.camera_rig.adjust_distance(390.0 - loop.camera_rig.distance_metres)
	var centre: Vector3 = loop.composition.global_transform * Vector3(103.0, 0.0, -85.0)
	loop.player.global_position = Vector3(centre.x, 0.0, centre.z)
	loop.camera_rig.focus = loop.player.global_position
	await _await_process_frames(6)
	await _shoot(stem)
	loop.camera_rig.camera.far = far_before
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


# --- The owed set --------------------------------------------------------------------

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


# --- Helpers ---------------------------------------------------------------------------

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


## Waits for the cache to actually open. The delay is counted on the same
## `_process` clock the accepted Fallen delay uses, so the number of frames it
## takes is a property of the machine rather than of the game — the wait is
## therefore on the CONDITION, with a generous cap, never on a frame count.
func _await_boon_panel() -> void:
	if not loop.awaiting_boon_choice():
		return
	for frame: int in 4000:
		if loop.boon_panel.is_open:
			return
		await get_tree().process_frame
	_expect_quiet(loop.boon_panel.is_open, "the boon choice panel never opened")


## Kills an enemy with forced, deterministic Quick Strikes and returns how many
## it took. The enemy's AI is disabled first so the count measures the weapon,
## not the fight.
func _kill(enemy: PrototypeGraveblade) -> int:
	enemy.set_ai_enabled(false)
	var area: PrototypeTargetable = enemy.get_node("TargetArea") as PrototypeTargetable
	var hits: int = 0
	while enemy.is_alive() and hits < 12:
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
	for frame: int in 120:
		await get_tree().physics_frame
		if loop.player.attack.phase == QuickStrikeAction.Phase.READY:
			break
	_expect_quiet(enemy.life < before_life or not enemy.is_alive(),
		"a forced Quick Strike produced no damage (Life stayed %.0f)" % before_life)


## How many PHYSICS frames one complete Quick Strike takes, press to ready.
## Measured on the simulation clock rather than on the wall clock, which is the
## project's own recorded lesson: reading two `Time.get_ticks_msec()` values
## across a stall measures the stall.
##
## Every enemy's AI is suspended for the measurement and restored afterwards,
## so an approaching Graveblade cannot land a hit in the middle of the sample.
func _measure_action_frames() -> int:
	var was_enabled: Array[PrototypeGraveblade] = []
	for enemy: PrototypeGraveblade in loop.graveblades:
		if enemy.ai_enabled:
			was_enabled.append(enemy)
			enemy.set_ai_enabled(false)

	loop.player.attack.set_attack_in_place(true)
	for frame: int in 200:
		if loop.player.attack.phase == QuickStrikeAction.Phase.READY:
			break
		await get_tree().physics_frame
	loop.player.attack.press()
	loop.player.attack.release_input()
	var frames: int = 0
	for frame: int in 300:
		await get_tree().physics_frame
		frames += 1
		if loop.player.attack.phase == QuickStrikeAction.Phase.READY:
			break
	loop.player.attack.set_attack_in_place(false)

	for enemy: PrototypeGraveblade in was_enabled:
		enemy.set_ai_enabled(true)
	return frames


## The minimum distance between two axis-aligned rectangles, and 0.0 when they
## touch or overlap. Used on the OCCUPIED rectangle rather than on
## `bake_rect()`, which carries a 2 m navigation margin on every side.
static func _rect_gap(a: Rect2, b: Rect2) -> float:
	var dx: float = maxf(0.0, maxf(a.position.x - b.end.x, b.position.x - a.end.x))
	var dy: float = maxf(0.0, maxf(a.position.y - b.end.y, b.position.y - a.end.y))
	return sqrt(dx * dx + dy * dy)


## `FirstMvpModal.make_button()` builds `Button -> HBoxContainer -> Label`, so a
## button's visible caption is a descendant Label's text, never `Button.text`.
static func _button_caption(button: Button) -> String:
	for child: Node in button.get_children():
		for grandchild: Node in child.get_children():
			var label: Label = grandchild as Label
			if label != null and not label.text.strip_edges().is_empty():
				return label.text
	return button.text


## Everything a surface actually shows, gathered from where the text really is
## rather than from where it would be convenient to read it.
static func _text_of(controls: Array) -> String:
	var parts: PackedStringArray = PackedStringArray()
	for entry: Variant in controls:
		var button: Button = entry as Button
		if button != null:
			parts.append(_button_caption(button))
			continue
		var label: Label = entry as Label
		if label != null:
			parts.append(label.text)
	return "\n".join(parts)


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


func _await_navigation() -> void:
	for frame: int in 60:
		if NavigationServer3D.map_get_iteration_id(loop.navigation_map()) > 0:
			return
		await get_tree().physics_frame


func _settle(frames: int) -> void:
	for i: int in frames:
		await get_tree().physics_frame


## `_settle()` waits on PHYSICS. Anything built or polled in `_process` — the
## gate test, HUD text, a Control's rectangle, the cache delay — needs IDLE
## frames.
func _await_process_frames(frames: int) -> void:
	for i: int in frames:
		await get_tree().process_frame


func _expect(condition: bool, failure_message: String) -> void:
	_checks += 1
	if not condition:
		_failures.append(failure_message)


## Records a failure without adding to the pinned count. Used inside loops whose
## iteration count is incidental, so the pinned total cannot drift with a tuning
## value while a real failure is still reported.
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
