extends Node
## Riftwrought — Roguelite Build Variety V1: automated verification (D-223).
##
## THIS IS NOT A GATE, AND IT DELIBERATELY DOES NOT RE-PROVE HISTORY. Quick
## Strike, the Graveblade state machine, click-to-move, the D-178 controller
## cone, the modal contract, the item comparison, the accepted core loop's
## hub / gate / reward / reset behaviour AND the accepted D-222 review's room
## library, seeded route selection and run-scoped reset are all proven by suites
## this review does not edit. Re-running them here would be verification
## theatre; the SHELL RUNNER runs both of those suites once instead, because
## "the existing reviews remain behaviourally intact" is a promise and a promise
## nothing measures is a hope.
##
## WHAT THIS SUITE PROVES is the one thing no existing suite can know: that TWO
## temporary-upgrade choices happen at the right moments, that their offers come
## off the seed deterministically and differ between documented seeds, that an
## upgrade already held is never offered or acquired again, that each of the
## four upgrades moves the REAL combat property it claims, that two of them
## coexist, and that all four baseline values come back on death, on abandon, on
## completion and at the start of the next run.
##
## THE SPATIAL UPGRADES ARE PROVED IN BOTH DIRECTIONS AGAINST THE REAL QUERY.
## `TargetAcquisition.resolve_release()` is the exact function
## `QuickStrikeAction._fire_release()` calls, and it is called here with the
## exact live record the kernel is handed, so a target placed just outside a
## boundary must MISS before the upgrade and HIT after it. A test that only
## proved the hit would pass on a query that ignored the boundary entirely.
##
## IT PORTS D-211's OWED-SET DISCIPLINE. Every check function records reaching
## its LAST line, and the suite compares that set to what it owes in BOTH
## directions — the only thing that catches an un-awaited coroutine check.
##
## IT ALSO PORTS GATE F's ON-SCREEN MEASUREMENT, for the reason it was written:
## reading the right words out of a Control tree proves the words EXIST, not
## that anyone can see them.
##
## Run:  godot --headless --path game \
##         res://scenes/roguelite/roguelite_build_variety_review.tscn -- --verify-build

const RUNTIME_SCRIPT: String = "res://scripts/roguelite/build_variety/roguelite_build_variety_runtime.gd"
const UPGRADE_SCRIPT: String = "res://scripts/roguelite/build_variety/roguelite_upgrade.gd"
const BUILD_STATE_SCRIPT: String = "res://scripts/roguelite/build_variety/roguelite_build_state.gd"
const PLAN_SCRIPT: String = "res://scripts/roguelite/build_variety/roguelite_build_variety_run_plan.gd"
const ENVELOPE_SCRIPT: String = "res://scripts/roguelite/build_variety/roguelite_strike_envelope.gd"
const PANEL_SCRIPT: String = "res://scripts/roguelite/build_variety/roguelite_upgrade_choice_panel.gd"
const HUD_SCRIPT: String = "res://scripts/roguelite/build_variety/roguelite_build_variety_hud.gd"
const SUMMARY_SCRIPT: String = "res://scripts/roguelite/build_variety/roguelite_build_variety_summary_panel.gd"

const REVIEW_SCRIPTS: Array[String] = [
	RUNTIME_SCRIPT, UPGRADE_SCRIPT, BUILD_STATE_SCRIPT, PLAN_SCRIPT,
	ENVELOPE_SCRIPT, PANEL_SCRIPT, HUD_SCRIPT, SUMMARY_SCRIPT,
]

## The two accepted reviews this one builds on and must not disturb.
const ACCEPTED_LOOP_RUNTIME: String = "res://scripts/roguelite/roguelite_core_loop_runtime.gd"
const ACCEPTED_LOOP_SCENE: String = "res://scenes/roguelite/roguelite_core_loop.tscn"
const ACCEPTED_REPLAY_RUNTIME: String = "res://scripts/roguelite/replayability/roguelite_replayability_runtime.gd"
const ACCEPTED_REPLAY_SCENE: String = "res://scenes/roguelite/roguelite_replayability_review.tscn"
const ACCEPTED_BOON_SCRIPT: String = "res://scripts/roguelite/replayability/roguelite_run_boon.gd"
const ACCEPTED_BOON_PANEL: String = "res://scripts/roguelite/replayability/roguelite_boon_choice_panel.gd"
const ACCEPTED_LIBRARY_SCRIPT: String = "res://scripts/roguelite/replayability/roguelite_room_library.gd"
const CANONICAL_QUICK_STRIKE: String = "res://data/prototype_zero/quick_strike.tres"
const ACCEPTED_REPLAY_HUD: String = "res://scripts/roguelite/replayability/roguelite_replayability_hud.gd"
const ACCEPTED_REPLAY_SUMMARY: String = "res://scripts/roguelite/replayability/roguelite_replayability_summary_panel.gd"
const ACCEPTED_RUN_HUD: String = "res://scripts/roguelite/roguelite_run_hud.gd"
const ACCEPTED_RUN_SUMMARY: String = "res://scripts/roguelite/roguelite_run_summary_panel.gd"
const ACCEPTED_QUICK_STRIKE_ACTION: String = "res://scripts/combat/quick_strike_action.gd"
const ACCEPTED_TARGET_ACQUISITION: String = "res://scripts/combat/target_acquisition.gd"
const ACCEPTED_QUICK_STRIKE_DATA: String = "res://scripts/combat/quick_strike_data.gd"

const ACCEPTED_FILES: Array[String] = [
	ACCEPTED_LOOP_RUNTIME, ACCEPTED_LOOP_SCENE, ACCEPTED_REPLAY_RUNTIME,
	ACCEPTED_REPLAY_SCENE, ACCEPTED_BOON_SCRIPT, ACCEPTED_BOON_PANEL,
	ACCEPTED_LIBRARY_SCRIPT, CANONICAL_QUICK_STRIKE,
	ACCEPTED_REPLAY_HUD, ACCEPTED_REPLAY_SUMMARY, ACCEPTED_RUN_HUD,
	ACCEPTED_RUN_SUMMARY, ACCEPTED_QUICK_STRIKE_ACTION,
	ACCEPTED_TARGET_ACQUISITION, ACCEPTED_QUICK_STRIKE_DATA,
]

const EXPECTED_ACTIONS_COUNT: int = 31
const EXPECTED_LIBRARY_ROOMS: int = 9
const EXPECTED_MODULES: int = 10
const EXPECTED_ENEMIES: int = 15
const EXPECTED_POOL: int = 4
const EXPECTED_CHOICES: int = 2
const EXPECTED_OPTIONS: int = 2

## Accepted values, restated here so a drift shows up as a failure in this
## review rather than as a surprise in a later one.
const ACCEPTED_CAMERA_DISTANCE: float = 19.0
const ACCEPTED_CAMERA_PITCH: float = 55.0
const ACCEPTED_CAMERA_FOV: float = 45.0
const ACCEPTED_MAX_SPEED: float = 5.0
const ACCEPTED_ACTION_TIME: float = 0.80
const ACCEPTED_RELEASE_MARKER: float = 0.325
const ACCEPTED_REACH: float = 1.65
const ACCEPTED_ARC: float = 100.0
const ACCEPTED_SOFT_CONE: float = 65.0
const QUICKENED_ACTION_TIME: float = 0.64
const ORDINARY_LIFE: float = 300.0
const ELITE_LIFE: float = 600.0
const WORN_DAMAGE: float = 100.0
const EXPEDITION_DAMAGE: float = 150.0

## THE REVIEW VALUES, RESTATED INDEPENDENTLY OF THE SOURCE. They are compared
## against `RogueliteUpgrade`'s constants rather than read from them, so an edit
## to the pool that quietly changed what "Reaching Edge" means fails here
## instead of passing by agreeing with itself.
const REVIEW_REACH: float = 2.65
const REVIEW_ARC: float = 180.0
const REVIEW_SOFT_CONE: float = 110.0

## The boundary probes. Each sits strictly between the accepted value and the
## review value, with real margin either side, so a pass cannot be a rounding
## artefact: 2.20 m is 0.55 m outside 1.65 and 0.45 m inside 2.65; 70 degrees
## off the facing axis is 20 degrees outside the accepted +/-50 and 20 degrees
## inside the review +/-90.
const PROBE_DISTANCE: float = 2.20
const PROBE_ANGLE_DEGREES: float = 70.0
## A control probe, comfortably inside BOTH envelopes. A boundary test whose
## "inside" case were never exercised could pass by rejecting everything.
const PROBE_INSIDE_DISTANCE: float = 1.20
const PROBE_INSIDE_ANGLE_DEGREES: float = 10.0

## The controller soft-target probe. 45° off the intended direction is 12.5°
## outside the accepted +/-32.5 and 10° inside the review +/-55, and 3.00 m is
## comfortably inside the accepted 5.0 m acquisition distance so only the ANGLE
## is under test.
const SOFT_CONE_PROBE_DISTANCE: float = 3.00
const SOFT_CONE_PROBE_ANGLE_DEGREES: float = 45.0

## The two documented seeds, pinned ROOM FOR ROOM and UPGRADE FOR UPGRADE. A
## test of the weaker shape — "the two differ" — would pass on a single
## differing beat and would still pass if the selection silently changed.
const SEED_A: int = 99
const SEED_B: int = 404
const ROUTE_A: Array[StringName] = [&"opening_pillar_court", &"reward_alcove", &"elite_broad_hall"]
const ROUTE_B: Array[StringName] = [&"opening_dogleg", &"reward_crossing", &"elite_pinch"]

## Seed 99 never offers the Expedition Blade and seed 404 never offers the
## Sweeping Edge, which is why the two documented runs reach genuinely different
## builds rather than the same build by two routes.
const OFFER_A_FIRST: Array[int] = [RogueliteUpgrade.Kind.QUICKENED_EDGE, RogueliteUpgrade.Kind.REACHING_EDGE]
const OFFER_A_SECOND_AFTER_REACH: Array[int] = [
	RogueliteUpgrade.Kind.QUICKENED_EDGE, RogueliteUpgrade.Kind.SWEEPING_EDGE,
]
const OFFER_B_FIRST: Array[int] = [RogueliteUpgrade.Kind.QUICKENED_EDGE, RogueliteUpgrade.Kind.EXPEDITION_BLADE]
const OFFER_B_SECOND_AFTER_BLADE: Array[int] = [
	RogueliteUpgrade.Kind.QUICKENED_EDGE, RogueliteUpgrade.Kind.REACHING_EDGE,
]

const PURITY_CALLS: int = 100
const SWEEP_SEEDS: int = 512

const OWED_CHECKS: Array[String] = [
	"engine_and_assembly",
	"isolation_from_the_landing_track",
	"input_map_untouched",
	"accepted_values_reused",
	"the_accepted_reviews_are_untouched",
	"the_upgrade_pool_is_four_and_readable",
	"offers_are_pure_and_deterministic",
	"documented_seeds_differ_in_rooms_and_offers",
	"no_duplicate_is_ever_offered_or_acquired",
	"two_choices_occur_at_the_correct_moments",
	"the_blade_reproduces_the_damage_proof",
	"the_quickened_edge_changes_the_real_action_time",
	"the_reaching_edge_changes_the_real_reach",
	"the_sweeping_edge_changes_the_real_arc",
	"two_upgrades_combine_correctly",
	"the_swing_outline_reads_the_live_record",
	"death_restores_every_baseline_value",
	"abandon_restores_every_baseline_value",
	"the_next_run_starts_from_baseline",
	"a_completed_run_clears_its_build",
	"the_canonical_record_is_never_written",
	"writes_nothing",
	"excluded_systems_absent",
	"surfaces_are_on_screen",
]

var loop: RogueliteBuildVarietyRuntime
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
	print("=== Roguelite Build Variety V1 verification (D-223) ===")
	_shot_dir = _argument_value("--shots")
	await _settle(10)
	await _await_navigation()

	_check_engine_and_assembly()
	_check_isolation_from_the_landing_track()
	_check_input_map_untouched()
	_check_accepted_values_reused()
	_check_the_accepted_reviews_are_untouched()
	_check_the_upgrade_pool_is_four_and_readable()
	_check_offers_are_pure_and_deterministic()
	_check_documented_seeds_differ_in_rooms_and_offers()
	_check_no_duplicate_is_ever_offered_or_acquired()

	await _check_two_choices_occur_at_the_correct_moments()
	await _check_the_blade_reproduces_the_damage_proof()
	await _check_the_quickened_edge_changes_the_real_action_time()
	await _check_the_reaching_edge_changes_the_real_reach()
	await _check_the_sweeping_edge_changes_the_real_arc()
	await _check_two_upgrades_combine_correctly()
	await _check_the_swing_outline_reads_the_live_record()
	await _check_death_restores_every_baseline_value()
	await _check_abandon_restores_every_baseline_value()
	await _check_the_next_run_starts_from_baseline()
	await _check_a_completed_run_clears_its_build()

	_check_the_canonical_record_is_never_written()
	_check_writes_nothing()
	_check_excluded_systems_absent()
	await _check_surfaces_are_on_screen()

	if not _shot_dir.is_empty():
		await _capture_evidence()

	_check_every_check_ran()

	print("")
	if _failures.is_empty():
		print("ROGUELITE BUILD VARIETY VERIFICATION: PASS (%d checks)" % _checks)
		get_tree().quit(0)
	else:
		for failure: String in _failures:
			printerr("  FAIL: %s" % failure)
		printerr("ROGUELITE BUILD VARIETY VERIFICATION: %d FAILURE(S) of %d checks" % [
			_failures.size(), _checks,
		])
		get_tree().quit(1)


# --- 1. Assembly and inheritance --------------------------------------------

func _check_engine_and_assembly() -> void:
	print("")
	print("--- Engine, assembly, and what this review actually added")
	_expect(Engine.get_version_info()["string"].begins_with("4.7.2"),
		"engine is %s, not 4.7.2" % Engine.get_version_info()["string"])
	_expect(loop != null, "the runtime was not bound")
	_expect(loop is RogueliteBuildVarietyRuntime, "the runtime is not a RogueliteBuildVarietyRuntime")
	## The whole chain, asserted rather than assumed: this review must inherit
	## the accepted D-222 review, which inherits the accepted core loop, which
	## inherits Gate 1D for its TYPE.
	_expect(loop is RogueliteReplayabilityRuntime, "the runtime does not extend the accepted D-222 review")
	_expect(loop is RogueliteCoreLoopRuntime, "the runtime does not extend the accepted core loop")
	_expect(loop is BrokenWatchSlice, "the runtime does not extend the accepted Gate 1D slice")

	_expect(loop.all_modules.size() == EXPECTED_MODULES,
		"%d module(s) built, expected %d" % [loop.all_modules.size(), EXPECTED_MODULES])
	_expect(RogueliteRoomLibrary.VARIANTS.size() == EXPECTED_LIBRARY_ROOMS,
		"the library holds %d room(s), expected %d — this review adds none" % [
			RogueliteRoomLibrary.VARIANTS.size(), EXPECTED_LIBRARY_ROOMS])
	_expect(loop.graveblades.size() == EXPECTED_ENEMIES,
		"%d enemies, expected %d — this review adds none" % [loop.graveblades.size(), EXPECTED_ENEMIES])
	_expect(loop.bake_count == 1, "the navigation mesh baked %d time(s), expected exactly 1" % loop.bake_count)
	_expect(loop.room_modules.size() == 3, "a run selects %d room(s), expected 3" % loop.room_modules.size())

	_expect(loop.plan is RogueliteBuildVarietyRunPlan, "the plan cannot offer upgrades")
	_expect(loop.plan is RogueliteSeededRunPlan, "the plan is not the accepted seeded plan")
	_expect(loop.build != null, "the runtime has no build state")
	_expect(loop.build.is_empty(), "the build is not empty before any run")
	_expect(loop.choice_panel != null, "the upgrade choice panel was not built")
	_expect(loop.strike_envelope != null, "the swing outline was not built")

	## THE ACCEPTED D-222 BOON PANEL IS ASSERTED ABSENT TWICE, because a null
	## field could have been cleared while an absent node could not.
	_expect(loop.boon_panel == null, "the D-222 boon panel field is still set")
	_expect(_count_nodes_of_script(loop, "RogueliteBoonChoicePanel") == 0,
		"a D-222 boon choice panel node still exists in the tree")
	_expect(_count_nodes_of_script(loop, "RogueliteUpgradeChoicePanel") == 1,
		"expected exactly one upgrade choice panel node")
	## The three replaced surfaces are asserted by EXACT script class rather
	## than by `is`, because every one of them IS-A its D-222 parent.
	_expect(_count_nodes_of_script(loop, "RogueliteBuildVarietyHud") == 1,
		"the run banner is not this review's HUD")
	_expect(_count_nodes_of_script(loop, "RogueliteReplayabilityHud") == 0,
		"a bare D-222 HUD node still exists in the tree")
	_expect(_count_nodes_of_script(loop, "RogueliteBuildVarietySummaryPanel") == 1,
		"the run summary is not this review's panel")
	_expect(_count_nodes_of_script(loop, "RogueliteStrikeEnvelope") == 1,
		"expected exactly one swing outline node")

	print("  %d modules, %d library rooms, %d enemies, 1 bake; pool of %d, %d choice(s) of %d" % [
		loop.all_modules.size(), RogueliteRoomLibrary.VARIANTS.size(), loop.graveblades.size(),
		RogueliteUpgrade.POOL.size(), RogueliteBuildVarietyRunPlan.CHOICES_PER_RUN,
		RogueliteBuildVarietyRunPlan.OPTIONS_PER_CHOICE,
	])
	_done("engine_and_assembly")


## The runtime extends Gate 1D for its TYPE and deliberately never calls its
## `_ready()`; this asserts the isolation TWICE — the fields are null AND no
## node of either layout class exists — because a null field could have been
## cleared while an absent node could not.
func _check_isolation_from_the_landing_track() -> void:
	print("")
	print("--- Riftfall Landing and Broken Watch are not in this scene at all")
	_expect(loop.landing_layout == null, "a Riftfall Landing layout was built")
	_expect(loop.landing_dressing == null, "Riftfall Landing dressing was built")
	_expect(loop.broken_watch == null, "a Broken Watch layout was built")
	_expect(_count_nodes_of_script(loop, "RiftfallLandingGreyboxLayout") == 0,
		"a Riftfall Landing greybox node exists in the tree")
	_expect(_count_nodes_of_script(loop, "BrokenWatchLayout") == 0,
		"a Broken Watch layout node exists in the tree")
	_done("isolation_from_the_landing_track")


func _check_input_map_untouched() -> void:
	print("")
	print("--- No InputMap action was added: every review key is PHYSICAL")
	## Counted exactly as the two accepted reviews count it — `ui_confirm` and
	## `ui_cancel` are project-declared overrides of built-in actions and are
	## part of the accepted 31, while every other `ui_` action is Godot's own.
	## A second, subtly different way of counting the same set would be a way
	## for two suites to disagree about an unchanged file.
	var project_actions: int = 0
	for action: StringName in InputMap.get_actions():
		if String(action).begins_with("ui_") and not String(action) in ["ui_confirm", "ui_cancel"]:
			continue
		project_actions += 1
	_expect(project_actions == EXPECTED_ACTIONS_COUNT,
		"%d project InputMap action(s), expected the accepted %d" % [
			project_actions, EXPECTED_ACTIONS_COUNT])
	_expect(ProjectSettings.get_setting("application/run/main_scene", "") == "res://scenes/app/prototype_app.tscn",
		"run/main_scene is no longer the Prototype App")
	## Named individually: Gate B, Gate E and Gate F each emit one assertion per
	## key event, so a single new action would silently move three locked counts.
	for forbidden: String in [
		"toggle_swing_outline", "swing_outline", "upgrade_choice", "take_upgrade",
		"next_route", "toggle_envelope", "build_summary",
	]:
		_expect(not InputMap.has_action(StringName(forbidden)),
			"a new InputMap action '%s' was declared" % forbidden)
	print("  %d project actions, unchanged; F6 / F7 / F8 / [ / ] / \\ are physical keys" % project_actions)
	_done("input_map_untouched")


func _check_accepted_values_reused() -> void:
	print("")
	print("--- Every accepted value this review stands on is unmoved")
	_expect(is_equal_approx(loop.camera_rig.distance_metres, ACCEPTED_CAMERA_DISTANCE),
		"camera distance is %.2f m, not the accepted %.2f" % [
			loop.camera_rig.distance_metres, ACCEPTED_CAMERA_DISTANCE])
	_expect(is_equal_approx(loop.camera_rig.pitch_degrees, ACCEPTED_CAMERA_PITCH),
		"camera pitch is %.1f deg, not the accepted %.1f" % [
			loop.camera_rig.pitch_degrees, ACCEPTED_CAMERA_PITCH])
	_expect(is_equal_approx(loop.camera_rig.fov_degrees, ACCEPTED_CAMERA_FOV),
		"camera FOV is %.1f deg, not the accepted %.1f" % [
			loop.camera_rig.fov_degrees, ACCEPTED_CAMERA_FOV])
	_expect(is_equal_approx(loop.player.max_speed, ACCEPTED_MAX_SPEED),
		"maximum speed is %.2f m/s, not the accepted %.2f" % [
			loop.player.max_speed, ACCEPTED_MAX_SPEED])

	var canonical: QuickStrikeData = loop.canonical_quick_strike_record()
	_expect(is_equal_approx(canonical.action_time, ACCEPTED_ACTION_TIME),
		"the authored action time is %.3f s, not the locked %.2f" % [canonical.action_time, ACCEPTED_ACTION_TIME])
	_expect(is_equal_approx(canonical.release_marker_normalized, ACCEPTED_RELEASE_MARKER),
		"the release marker moved to %.4f" % canonical.release_marker_normalized)
	_expect(is_equal_approx(canonical.reach, ACCEPTED_REACH),
		"the authored reach is %.3f m, not the locked %.2f" % [canonical.reach, ACCEPTED_REACH])
	_expect(is_equal_approx(canonical.release_arc_degrees, ACCEPTED_ARC),
		"the authored release arc is %.1f deg, not the authored %.1f" % [
			canonical.release_arc_degrees, ACCEPTED_ARC])
	_expect(is_equal_approx(canonical.soft_target_cone_degrees, ACCEPTED_SOFT_CONE),
		"the authored soft-target cone is %.1f deg, not the D-178 locked %.1f" % [
			canonical.soft_target_cone_degrees, ACCEPTED_SOFT_CONE])

	## The Quickened value is SHARED with the accepted D-222 boon rather than
	## retyped, so there is one 0.25 in the project and not two.
	_expect(is_equal_approx(RogueliteUpgrade.QUICKENED_INCREASE, RogueliteRunBoon.QUICKENED_INCREASE),
		"the Quickened increase is not the accepted D-222 value")
	_expect(is_equal_approx(canonical.effective_action_time(RogueliteUpgrade.QUICKENED_INCREASE),
		QUICKENED_ACTION_TIME),
		"the Quickened action time computes to %.4f s, not %.2f" % [
			canonical.effective_action_time(RogueliteUpgrade.QUICKENED_INCREASE), QUICKENED_ACTION_TIME])

	var worn: PrototypeWeaponData = loop.worn_blade_record()
	var blade: PrototypeWeaponData = loop.expedition_blade_record()
	_expect(is_equal_approx(worn.physical_damage, WORN_DAMAGE),
		"the Worn Blade deals %.0f, not %.0f" % [worn.physical_damage, WORN_DAMAGE])
	_expect(is_equal_approx(blade.physical_damage, EXPEDITION_DAMAGE),
		"the Expedition Blade deals %.0f, not %.0f" % [blade.physical_damage, EXPEDITION_DAMAGE])
	print("  19 m / 55° / 45° camera, 5.0 m/s, 0.80 s, 1.65 m, 100° arc, 65° cone, 100 → 150")
	_done("accepted_values_reused")


## The two accepted reviews are read from disk and compared with what this
## review's own scripts say about them. Their BEHAVIOUR is proved by the shell
## runner, which runs both of their verifications once; what is proved here is
## that neither of their files was edited to make this one work.
func _check_the_accepted_reviews_are_untouched() -> void:
	print("")
	print("--- Both accepted reviews are preserved, and this one edits neither")
	## THE LIST IS EVERY ACCEPTED FILE THIS REVIEW'S SUBCLASSES ACTUALLY STAND
	## ON, not only the ones it obviously extends. The first version named eight
	## and omitted the combat kernel, the targeting query and the two accepted
	## HUD/summary parents — so an edit to `target_acquisition.gd`'s rejection
	## wording would have been followed silently by the boundary checks that read
	## it. The AUTHORITY on "nothing was edited" is still the runner's SHA-256
	## fingerprint of 78 files taken before and after; this is the in-engine
	## cross-check, and its honest limit is stated in the report: neither can see
	## an edit made before the run began.
	for path: String in ACCEPTED_FILES:
		_expect(FileAccess.file_exists(path), "%s no longer exists" % path)
		var source: String = FileAccess.get_file_as_string(path)
		_expect(not source.is_empty(), "%s is empty" % path)
		## The accepted files must name nothing of this review. A one-way scan
		## is enough: this review's files may name them, and do.
		_expect(not source.contains("build_variety"),
			"%s names this review — an accepted file was edited" % path)
		_expect(not source.contains("RogueliteUpgrade"),
			"%s names this review's upgrade pool" % path)

	## The accepted D-222 plan still selects rooms on its own terms, so the
	## subclass has not changed what the parent does.
	var accepted_plan: RogueliteSeededRunPlan = RogueliteSeededRunPlan.new(SEED_A, 0)
	var offering_plan: RogueliteBuildVarietyRunPlan = RogueliteBuildVarietyRunPlan.new(SEED_A, 0)
	_expect(accepted_plan.ordered_modules() == offering_plan.ordered_modules(),
		"the offering plan selects a different route than the accepted seeded plan for the same seed")
	_expect(accepted_plan.run_id() == offering_plan.run_id(),
		"the offering plan produces a different run id than the accepted plan for the same seed")
	print("  %d accepted files present and unedited; the same seed gives the same route and id in both plans"
		% ACCEPTED_FILES.size())
	_done("the_accepted_reviews_are_untouched")


# --- 2. The pool ------------------------------------------------------------

func _check_the_upgrade_pool_is_four_and_readable() -> void:
	print("")
	print("--- The pool is exactly four, distinct, readable, and reuses accepted properties")
	_expect(RogueliteUpgrade.POOL.size() == EXPECTED_POOL,
		"the pool holds %d upgrade(s), expected %d" % [RogueliteUpgrade.POOL.size(), EXPECTED_POOL])
	var seen: Dictionary = {}
	for kind: int in RogueliteUpgrade.POOL:
		_expect(not seen.has(kind), "%d appears twice in the pool" % kind)
		seen[kind] = true
		_expect(kind != RogueliteUpgrade.Kind.NONE, "NONE is in the pool")
		_expect(not RogueliteUpgrade.name_of(kind).is_empty(), "%d has no name" % kind)
		_expect(not RogueliteUpgrade.summary_of(kind).is_empty(),
			"%s has no summary" % RogueliteUpgrade.name_of(kind))
		_expect(not RogueliteUpgrade.delivery_of(kind).is_empty(),
			"%s has no delivery line" % RogueliteUpgrade.name_of(kind))

	## Exactly one is delivered as the ground weapon — the branch that keeps the
	## established pickup / comparison / equip proof.
	var weapons: int = 0
	for kind: int in RogueliteUpgrade.POOL:
		if RogueliteUpgrade.is_weapon_kind(kind):
			weapons += 1
	_expect(weapons == 1, "%d upgrade(s) are delivered as a weapon, expected exactly 1" % weapons)

	## THE REVIEW VALUES, COMPARED AGAINST AN INDEPENDENT RESTATEMENT rather
	## than read from the source they came from.
	_expect(is_equal_approx(RogueliteUpgrade.REACHING_EDGE_REACH, REVIEW_REACH),
		"the Reaching Edge reach is %.3f m, expected the recorded review value %.2f" % [
			RogueliteUpgrade.REACHING_EDGE_REACH, REVIEW_REACH])
	_expect(is_equal_approx(RogueliteUpgrade.SWEEPING_EDGE_ARC_DEGREES, REVIEW_ARC),
		"the Sweeping Edge arc is %.1f deg, expected the recorded review value %.1f" % [
			RogueliteUpgrade.SWEEPING_EDGE_ARC_DEGREES, REVIEW_ARC])
	_expect(is_equal_approx(RogueliteUpgrade.SWEEPING_EDGE_SOFT_CONE_DEGREES, REVIEW_SOFT_CONE),
		"the Sweeping Edge soft cone is %.1f deg, expected the recorded review value %.1f" % [
			RogueliteUpgrade.SWEEPING_EDGE_SOFT_CONE_DEGREES, REVIEW_SOFT_CONE])
	## Every review value must be a real increase over the accepted one, or the
	## upgrade would be an upgrade in name only.
	_expect(REVIEW_REACH > ACCEPTED_REACH, "the Reaching Edge does not increase the reach")
	_expect(REVIEW_ARC > ACCEPTED_ARC, "the Sweeping Edge does not widen the release arc")
	_expect(REVIEW_SOFT_CONE > ACCEPTED_SOFT_CONE, "the Sweeping Edge does not widen the soft-target cone")
	## And the widened cone must still respect the kernel's own backwards-snap
	## guard rather than merely approach it.
	_expect(REVIEW_SOFT_CONE * 0.5 < 89.0,
		"the widened soft cone half-angle reaches the kernel's backwards-snap guard")

	## The pool is a VALUE, not a system. Each of these is a first-MVP system
	## with its own authorization and none is in scope.
	var pool_source: String = _code_only(FileAccess.get_file_as_string(UPGRADE_SCRIPT)
		+ FileAccess.get_file_as_string(BUILD_STATE_SCRIPT))
	for forbidden: String in [
		"rarity", "affix", "tier", "currency", "reroll", "shop", "unlock",
		"save", "load_from", "serialize", "user://", "schema_version",
	]:
		_expect(not pool_source.to_lower().contains(forbidden),
			"the pool or the build state names '%s'" % forbidden)
	print("  4 distinct upgrades; reach %.2f → %.2f m, arc %.0f → %.0f°, cone %.0f → %.0f°" % [
		ACCEPTED_REACH, REVIEW_REACH, ACCEPTED_ARC, REVIEW_ARC, ACCEPTED_SOFT_CONE, REVIEW_SOFT_CONE])
	_done("the_upgrade_pool_is_four_and_readable")


# --- 3. The offers ----------------------------------------------------------

func _check_offers_are_pure_and_deterministic() -> void:
	print("")
	print("--- The same seed reproduces the same offers, and the function is pure")
	var first: RogueliteBuildVarietyRunPlan = RogueliteBuildVarietyRunPlan.new(SEED_A, 0)
	var second: RogueliteBuildVarietyRunPlan = RogueliteBuildVarietyRunPlan.new(SEED_A, 0)
	_expect(first.problem().is_empty(), "the plan reports a problem: %s" % first.problem())
	var reference: Array[int] = first.offer_for(0, [] as Array[int])
	_expect(second.offer_for(0, [] as Array[int]) == reference,
		"two independently constructed plans on the same seed offer different first choices")

	## PURITY: the same plan answers identically however many times it is asked.
	## A selection that cached, consumed a stream, or read a clock would drift.
	var drifted: int = 0
	for call: int in PURITY_CALLS:
		if first.offer_for(0, [] as Array[int]) != reference:
			drifted += 1
		if first.offer_for(1, [reference[0]] as Array[int]) != second.offer_for(1, [reference[0]] as Array[int]):
			drifted += 1
	_expect(drifted == 0, "the offer selection drifted on %d of %d repeated calls" % [drifted, PURITY_CALLS * 2])

	## The successor plan is still an OFFERING plan. D-222 recorded why this
	## matters: a base-class successor would silently drop the added behaviour
	## on the second run of a session.
	var successor: RogueliteRunPlan = first.next()
	_expect(successor is RogueliteBuildVarietyRunPlan,
		"the next run's plan cannot offer upgrades — every run after the first would have lost them")
	_expect(successor.problem().is_empty(), "the successor plan reports a problem: %s" % successor.problem())

	## Nothing reads the clock, the filesystem or an unseeded generator.
	var plan_source: String = _code_only(FileAccess.get_file_as_string(PLAN_SCRIPT))
	for forbidden: String in [
		"RandomNumberGenerator", "randi", "randf", "Time.get_unix", "Time.get_ticks", "OS.get_",
	]:
		_expect(not plan_source.contains(forbidden),
			"the offer selection names '%s' — it is not purely seeded" % forbidden)
	print("  %d repeated calls, 0 drift; the successor still offers" % (PURITY_CALLS * 2))
	_done("offers_are_pure_and_deterministic")


func _check_documented_seeds_differ_in_rooms_and_offers() -> void:
	print("")
	print("--- The two documented seeds differ in ROOMS and in OFFERS, pinned exactly")
	var plan_a: RogueliteBuildVarietyRunPlan = RogueliteBuildVarietyRunPlan.new(SEED_A, 0)
	var plan_b: RogueliteBuildVarietyRunPlan = RogueliteBuildVarietyRunPlan.new(SEED_B, 0)

	## Room for room, not "the routes differ": the weaker test would pass on a
	## single differing beat and would still pass if the selection changed.
	_expect(plan_a.ordered_modules() == ROUTE_A,
		"seed %d selects %s, expected %s" % [SEED_A, plan_a.ordered_modules(), ROUTE_A])
	_expect(plan_b.ordered_modules() == ROUTE_B,
		"seed %d selects %s, expected %s" % [SEED_B, plan_b.ordered_modules(), ROUTE_B])
	var differing_beats: int = 0
	for index: int in 3:
		if plan_a.ordered_modules()[index] != plan_b.ordered_modules()[index]:
			differing_beats += 1
	_expect(differing_beats == 3,
		"the two documented seeds share %d of 3 rooms" % (3 - differing_beats))

	## Upgrade for upgrade, and BOTH choices — the second one for the pick the
	## documented test route actually takes.
	_expect(plan_a.offer_for(0, [] as Array[int]) == OFFER_A_FIRST,
		"seed %d first offer is %s, expected %s" % [SEED_A, _names(plan_a.offer_for(0, [] as Array[int])), _names(OFFER_A_FIRST)])
	_expect(plan_b.offer_for(0, [] as Array[int]) == OFFER_B_FIRST,
		"seed %d first offer is %s, expected %s" % [SEED_B, _names(plan_b.offer_for(0, [] as Array[int])), _names(OFFER_B_FIRST)])
	var held_a: Array[int] = [RogueliteUpgrade.Kind.REACHING_EDGE]
	var held_b: Array[int] = [RogueliteUpgrade.Kind.EXPEDITION_BLADE]
	_expect(plan_a.offer_for(1, held_a) == OFFER_A_SECOND_AFTER_REACH,
		"seed %d second offer after the Reaching Edge is %s, expected %s" % [
			SEED_A, _names(plan_a.offer_for(1, held_a)), _names(OFFER_A_SECOND_AFTER_REACH)])
	_expect(plan_b.offer_for(1, held_b) == OFFER_B_SECOND_AFTER_BLADE,
		"seed %d second offer after the Expedition Blade is %s, expected %s" % [
			SEED_B, _names(plan_b.offer_for(1, held_b)), _names(OFFER_B_SECOND_AFTER_BLADE)])

	## AND THE BUILDS THEY REACH ARE DIFFERENT, which is the requirement the
	## brief actually states — different seeds must produce different BUILDS as
	## well as different rooms. The documented route for seed 99 takes the
	## Reaching Edge then the Sweeping Edge; for seed 404 the Expedition Blade
	## then the Quickened Edge. No upgrade is shared.
	var build_a: Array[int] = [RogueliteUpgrade.Kind.REACHING_EDGE, RogueliteUpgrade.Kind.SWEEPING_EDGE]
	var build_b: Array[int] = [RogueliteUpgrade.Kind.EXPEDITION_BLADE, RogueliteUpgrade.Kind.QUICKENED_EDGE]
	for kind: int in build_a:
		_expect(not build_b.has(kind),
			"the two documented builds share %s" % RogueliteUpgrade.name_of(kind))
	_expect(plan_a.offer_for(0, [] as Array[int]).has(build_a[0]),
		"seed %d's first offer cannot reach its documented build" % SEED_A)
	_expect(plan_a.offer_for(1, [build_a[0]] as Array[int]).has(build_a[1]),
		"seed %d's second offer cannot reach its documented build" % SEED_A)
	_expect(plan_b.offer_for(0, [] as Array[int]).has(build_b[0]),
		"seed %d's first offer cannot reach its documented build" % SEED_B)
	_expect(plan_b.offer_for(1, [build_b[0]] as Array[int]).has(build_b[1]),
		"seed %d's second offer cannot reach its documented build" % SEED_B)

	print("  %d: %s | first offer %s" % [SEED_A, plan_a.route_line(), _names(OFFER_A_FIRST)])
	print("  %d: %s | first offer %s" % [SEED_B, plan_b.route_line(), _names(OFFER_B_FIRST)])
	_done("documented_seeds_differ_in_rooms_and_offers")


## Exhaustive over every reachable held set, swept over many seeds. Two rules
## are proved together because they fail together: an offer never repeats an
## option within itself, and never offers something already held.
func _check_no_duplicate_is_ever_offered_or_acquired() -> void:
	print("")
	print("--- No duplicate is ever offered or acquired, over %d seeds" % SWEEP_SEEDS)
	var violations: int = 0
	var offers_examined: int = 0
	var distinct_first_offers: Dictionary = {}
	var kinds_offered: Dictionary = {}
	for step: int in SWEEP_SEEDS:
		var seed_value: int = (SEED_A + step * 7919) & 0xFFFFFFFF
		var plan: RogueliteBuildVarietyRunPlan = RogueliteBuildVarietyRunPlan.new(seed_value, 0)
		if not plan.problem().is_empty():
			violations += 1
			continue
		var first: Array[int] = plan.offer_for(0, [] as Array[int])
		distinct_first_offers["%d-%d" % [first[0], first[1]]] = true
		if first.size() != EXPECTED_OPTIONS or first[0] == first[1]:
			violations += 1
			continue
		for kind: int in first:
			kinds_offered[kind] = true
		for taken: int in first:
			var held: Array[int] = [taken]
			var second: Array[int] = plan.offer_for(1, held)
			offers_examined += 1
			if second.size() != EXPECTED_OPTIONS:
				violations += 1
			elif second[0] == second[1]:
				violations += 1
			elif second.has(taken):
				violations += 1
			else:
				for kind: int in second:
					kinds_offered[kind] = true
					if not RogueliteUpgrade.POOL.has(kind):
						violations += 1
	_expect(violations == 0, "%d duplicate or malformed offer(s) over %d seeds" % [violations, SWEEP_SEEDS])
	_expect(offers_examined == SWEEP_SEEDS * EXPECTED_OPTIONS,
		"examined %d second offers, expected %d" % [offers_examined, SWEEP_SEEDS * EXPECTED_OPTIONS])
	## Every upgrade must be reachable. This is what catches a selection quietly
	## collapsing onto a subset of the pool — the same property D-222 asserted
	## about all nine rooms.
	_expect(kinds_offered.size() == EXPECTED_POOL,
		"only %d of %d upgrades were ever offered across the sweep" % [kinds_offered.size(), EXPECTED_POOL])
	_expect(distinct_first_offers.size() > 1,
		"every seed produced the same first offer — the seed is not reaching the selection")

	## And the door itself refuses a duplicate, so the rule holds even if a
	## future caller reaches `acquire()` some other way.
	var state: RogueliteBuildState = RogueliteBuildState.new()
	_expect(state.acquire(RogueliteUpgrade.Kind.REACHING_EDGE), "a first acquisition was refused")
	_expect(not state.acquire(RogueliteUpgrade.Kind.REACHING_EDGE), "a duplicate acquisition was accepted")
	_expect(state.count() == 1, "a refused duplicate still changed the build")
	_expect(state.refusals == 1, "the refusal was not counted")
	_expect(not state.available().has(RogueliteUpgrade.Kind.REACHING_EDGE),
		"a held upgrade is still in the available list")
	_expect(state.available().size() == EXPECTED_POOL - 1,
		"%d upgrade(s) available after holding one, expected %d" % [
			state.available().size(), EXPECTED_POOL - 1])
	_expect(not state.acquire(RogueliteUpgrade.Kind.NONE), "NONE was accepted as an upgrade")
	print("  %d first offers, %d second offers, %d distinct first pairs, all %d upgrades reachable, 0 violations" % [
		SWEEP_SEEDS, offers_examined, distinct_first_offers.size(), kinds_offered.size()])
	_done("no_duplicate_is_ever_offered_or_acquired")


# --- 4. The two choice moments ----------------------------------------------

## Walks a real run and proves the two caches open after the OPENING room and
## after the REWARD room, that the elite room offers nothing, and — the part
## that matters most — that each room's Rift Gate stays SEALED until the choice
## is taken.
func _check_two_choices_occur_at_the_correct_moments() -> void:
	print("")
	print("--- Two choices, after the opening room and after the reward room, gate sealed until taken")
	_expect(loop.choice_index_for_room(0) == 0, "the opening room does not carry the first choice")
	_expect(loop.choice_index_for_room(1) == 1, "the reward room does not carry the second choice")
	_expect(loop.choice_index_for_room(2) == -1, "the elite room carries a choice")
	_expect(loop.opening_beat_index() == 0, "the opening beat is not room 1")
	_expect(loop.reward_beat_index() == 1, "the reward beat is not room 2")
	_expect(loop.elite_beat_index() == 2, "the elite beat is not room 3")

	await _start_run()
	_expect(loop.run_state.current_room_index == 0, "the run did not start in the opening room")
	_expect(not loop.room_modules[0].exit_gate_open, "the opening room's gate is open before it is cleared")
	_expect(loop.build.is_empty(), "the build is not empty at the start of a run")

	## Room 1 — clear it and the cache must open rather than the gate.
	_worn_hits = await _clear_room(0)
	_expect(loop.awaiting_upgrade_choice(), "clearing the opening room did not open a cache")
	_expect(not loop.run_state.is_cleared(0),
		"the opening room was marked cleared before its choice was taken")
	_expect(not loop.room_modules[0].exit_gate_open,
		"THE GATE OPENED BEFORE THE CHOICE — the player could walk out and lose the upgrade")
	await _await_choice_panel()
	_expect(loop.choice_panel.is_open, "the first choice panel never opened")
	_expect(loop.choice_panel.option_count() == EXPECTED_OPTIONS,
		"the first choice shows %d option(s), expected %d" % [
			loop.choice_panel.option_count(), EXPECTED_OPTIONS])
	_expect(loop.choice_panel.choice_index() == 0, "the first panel does not report itself as choice 1")
	var first_offer: Array[int] = loop.choice_panel.offered_kinds()
	_expect(first_offer.size() == EXPECTED_OPTIONS, "the first offer is not two options")
	_expect(first_offer[0] != first_offer[1], "the first offer shows the same upgrade twice")
	_expect(not loop.choice_panel.cancel_closes(),
		"the choice panel can be cancelled — the run would strand behind a sealed gate")
	var panel_text: String = _text_of(loop.choice_panel.text_controls())
	for kind: int in first_offer:
		_expect(panel_text.contains(RogueliteUpgrade.name_of(kind)),
			"the panel does not name its own offered %s" % RogueliteUpgrade.name_of(kind))
	_expect(panel_text.contains("choice 1 of %d" % EXPECTED_CHOICES),
		"the panel does not say which choice it is")

	## THE BANNER MUST NOT SAY THE GATE IS OPEN WHILE IT IS SEALED. Found by
	## looking at a rendered frame, not by an assertion: the inherited banner
	## writes "Cleared — the Rift Gate is open" the moment the last enemy falls,
	## which is true in the accepted core loop and false here.
	loop.run_hud.refresh()
	var banner_while_sealed: String = _text_of(loop.run_hud.text_controls())
	_expect(not banner_while_sealed.contains("Cleared — the Rift Gate is open"),
		"the banner says the Rift Gate is open while it is sealed pending a choice")
	_expect(banner_while_sealed.contains("stays sealed until you choose"),
		"the banner does not tell the player why the gate will not let them through")

	await _take_choice(first_offer[0])
	_expect(loop.build.count() == 1, "taking the first choice did not add exactly one upgrade")
	_expect(loop.build.held(first_offer[0]), "the upgrade taken is not the upgrade held")
	_expect(loop.run_state.is_cleared(0), "the opening room was not cleared by taking the choice")
	_expect(loop.room_modules[0].exit_gate_open, "the gate did not open when the choice was taken")

	## Room 2 — the same rule, and the second offer must exclude what is held.
	await _advance_to_next_room()
	_expect(loop.run_state.current_room_index == 1, "the run did not advance to the reward room")
	await _clear_room(1)
	_expect(loop.awaiting_upgrade_choice(), "clearing the reward room did not open a cache")
	_expect(not loop.room_modules[1].exit_gate_open,
		"the reward room's gate opened before its choice was taken")
	await _await_choice_panel()
	_expect(loop.choice_panel.choice_index() == 1, "the second panel does not report itself as choice 2")
	var second_offer: Array[int] = loop.choice_panel.offered_kinds()
	_expect(not second_offer.has(first_offer[0]),
		"the second choice offered %s, which is already held" % RogueliteUpgrade.name_of(first_offer[0]))
	_expect(second_offer[0] != second_offer[1], "the second offer shows the same upgrade twice")
	await _take_choice(second_offer[0])
	_expect(loop.build.count() == 2, "the build does not hold two upgrades after two choices")
	_expect(loop.room_modules[1].exit_gate_open, "the reward room's gate did not open")

	## Room 3 — no third cache. Clearing the elite room opens its gate directly.
	await _advance_to_next_room()
	_expect(loop.run_state.current_room_index == 2, "the run did not advance to the elite room")
	await _clear_room(2)
	_expect(not loop.awaiting_upgrade_choice(), "the elite room opened a third cache")
	_expect(loop.run_state.is_cleared(2), "the elite room was not cleared by clearing it")
	_expect(loop.room_modules[2].exit_gate_open, "the elite room's gate did not open on clear")
	_expect(loop.choices_offered == EXPECTED_CHOICES,
		"%d cache(s) were offered this run, expected %d" % [loop.choices_offered, EXPECTED_CHOICES])
	_expect(loop.upgrades_taken == EXPECTED_CHOICES,
		"%d upgrade(s) were taken this run, expected %d" % [loop.upgrades_taken, EXPECTED_CHOICES])
	_expect(loop.refused_acquisitions.is_empty(),
		"an acquisition was refused after a choice was committed: %s" % ", ".join(loop.refused_acquisitions))

	## The banner names both, which is the readability requirement.
	var banner: String = _text_of(loop.run_hud.text_controls())
	for kind: int in loop.build.acquired:
		_expect(banner.contains(RogueliteUpgrade.name_of(kind)),
			"the run banner does not name the held %s" % RogueliteUpgrade.name_of(kind))
	print("  choice 1 after room 1, choice 2 after room 2, none after room 3; both gates stayed sealed")
	_done("two_choices_occur_at_the_correct_moments")


# --- 5. Every upgrade changes the property it claims -------------------------

## The accepted D-222 / D-220 proof, reproduced through the new choice path: the
## Expedition Blade still moves 100 -> 150 and three Hits to two, read off the
## live records AND measured by killing a Graveblade with each weapon.
func _check_the_blade_reproduces_the_damage_proof() -> void:
	print("")
	print("--- The Expedition Blade still proves 100 → 150 and three Hits → two")
	_expect(_worn_hits == 3,
		"the Worn Blade took %d Hits to a %.0f-Life Graveblade, expected 3" % [_worn_hits, ORDINARY_LIFE])

	await _restart_to_hub("blade proof")
	await _start_run_with(_seed_offering(RogueliteUpgrade.Kind.EXPEDITION_BLADE, 0, [] as Array[int]))
	await _clear_room(0)
	await _await_choice_panel()
	await _take_choice(RogueliteUpgrade.Kind.EXPEDITION_BLADE)
	_expect(loop.build.held(RogueliteUpgrade.Kind.EXPEDITION_BLADE),
		"the Expedition Blade was not granted when it was chosen")

	## It arrives as the accepted GROUND DROP, on the walked line, clear of the
	## gate — not applied silently. That is what keeps the established pickup /
	## comparison / equip path intact rather than merely restated.
	_expect(loop._active_drop != null, "taking the Expedition Blade placed no ground item")
	_expect(loop.run_state.reward_granted, "the reward door did not record the grant")
	var gate: Vector3 = loop.room_modules[0].exit_point()
	## Guarded rather than assumed: a throw inside a check function aborts the
	## WHOLE function, and D-201 is this project's own record of six assertions
	## silently not running while the suite still reported PASS.
	var drop_at: Vector3 = gate if loop._active_drop == null else loop._active_drop.global_position
	var clearance: float = Vector2(drop_at.x - gate.x, drop_at.z - gate.z).length()
	_expect(clearance > RogueliteCoreLoopRuntime.GATE_ENTER_RADIUS,
		"the drop sits %.2f m from a gate that triggers at %.2f m" % [
			clearance, RogueliteCoreLoopRuntime.GATE_ENTER_RADIUS])
	_expect(is_equal_approx(clearance, RogueliteCoreLoopRuntime.REWARD_GATE_CLEARANCE),
		"the drop is %.2f m back from the gate, expected the accepted %.2f" % [
			clearance, RogueliteCoreLoopRuntime.REWARD_GATE_CLEARANCE])

	## EQUIPPED THROUGH THE PRODUCTION PATH, NOT BY THE HARNESS, AND THE FIRST
	## VERSION OF THIS CHECK DID IT THE OTHER WAY. Calling `loadout.pick_up()`,
	## `loadout.equip()` and `player.equip_weapon()` directly proves that the
	## Expedition Blade RECORD deals 150 — it does not prove a player can obtain
	## it. Break the Equip button's wiring and a suite shaped like that still
	## prints "100 → 150, 3 Hits → 2" while the blade is unobtainable in play:
	## the "after" state was written by the test and then read back by the test.
	##
	## What runs here instead is the real route the brief asks to be preserved:
	## `open_item_comparison()` → `FirstMvpItemComparison.open_for()` → the
	## Equip button's own `pressed` signal → `_on_equip_pressed()` →
	## `loadout.pick_up()` / `loadout.equip()` → `room.on_weapon_equipped()`.
	loop.open_item_comparison("verification: the player inspects the drop")
	await _await_process_frames(4)
	_expect(loop.item_comparison.is_open, "the item comparison did not open over the ground drop")

	## AND ITS ROWS ARE READ, because a comparison that lies is worse than none.
	## These are the panel's own labels, filled by its own `refresh_contents()`
	## from the live records — not values this suite supplied.
	var rows: Array = loop.item_comparison._rows
	_expect(rows.size() >= 2, "the item comparison shows %d row(s)" % rows.size())
	var damage_row: Dictionary = rows[0]
	var hits_row: Dictionary = rows[1]
	_expect((damage_row["from"] as Label).text == "100" and (damage_row["to"] as Label).text == "150",
		"the comparison's damage row reads %s → %s, not 100 → 150" % [
			(damage_row["from"] as Label).text, (damage_row["to"] as Label).text])
	_expect((hits_row["from"] as Label).text == "3" and (hits_row["to"] as Label).text == "2",
		"the comparison's Hits row reads %s → %s, not 3 → 2" % [
			(hits_row["from"] as Label).text, (hits_row["to"] as Label).text])

	## And it is measured ON SCREEN, which no other check in this suite did —
	## Gate F shipped four modals nobody could see while every text assertion
	## passed.
	var comparison_controls: Array = []
	for row: Dictionary in rows:
		comparison_controls.append(row["from"])
		comparison_controls.append(row["to"])
	comparison_controls.append(loop.item_comparison._equip)
	var comparison_visible: int = _measure_text(comparison_controls,
		Rect2(Vector2.ZERO, Vector2(get_viewport().get_visible_rect().size)), "item comparison")
	_expect(comparison_visible == comparison_controls.size(),
		"%d of %d item-comparison controls are on screen" % [
			comparison_visible, comparison_controls.size()])

	_expect(not loop.item_comparison._equip.disabled,
		"the Equip button is disabled for an item the player does not hold")
	loop.item_comparison._equip.pressed.emit()
	await _settle(2)
	await _await_process_frames(2)
	_expect(not loop.item_comparison.is_open, "the comparison did not close when Equip was pressed")
	_expect(loop.run_state.reward_equipped,
		"the production equip path did not record the reward as equipped")
	_expect(loop._active_drop == null, "the ground item survived being equipped")
	_expect(loop.loadout.is_equipped(loop.expedition_blade_record()),
		"the loadout does not hold the Expedition Blade as equipped")
	_expect(is_equal_approx(loop.player.physical_damage, EXPEDITION_DAMAGE),
		"the equipped weapon deals %.0f, not %.0f" % [loop.player.physical_damage, EXPEDITION_DAMAGE])
	## The banner follows the production path rather than a flag this suite set.
	_expect(loop.build_effect_line().contains("equipped"),
		"the banner still says the blade is waiting on the ground after it was equipped")

	await _advance_to_next_room()
	var upgraded_hits: int = await _kill(loop.room_enemies[1][0])
	_expect(upgraded_hits == 2,
		"the Expedition Blade took %d Hits to a %.0f-Life Graveblade, expected 2" % [
			upgraded_hits, ORDINARY_LIFE])
	_expect(_worn_hits > upgraded_hits,
		"the upgrade did not reduce the Hits needed (%d then %d)" % [_worn_hits, upgraded_hits])
	## The record's own arithmetic must agree with the behaviour, not replace it.
	_expect(loop.expedition_blade_record().hits_to_defeat(ORDINARY_LIFE) == upgraded_hits,
		"the record says %d Hits and the fight took %d" % [
			loop.expedition_blade_record().hits_to_defeat(ORDINARY_LIFE), upgraded_hits])
	print("  100 → 150 Physical; %d Hits → %d against %.0f Life; drop %.2f m clear of a %.2f m gate" % [
		_worn_hits, upgraded_hits, ORDINARY_LIFE, clearance, RogueliteCoreLoopRuntime.GATE_ENTER_RADIUS])
	_done("the_blade_reproduces_the_damage_proof")


## MEASURED IN PHYSICS FRAMES, not read back off the record. The record could
## say 0.64 while the kernel ran at 0.80; only the clock the action advances on
## can tell them apart.
func _check_the_quickened_edge_changes_the_real_action_time() -> void:
	print("")
	print("--- The Quickened Edge changes the REAL action time, measured on the simulation clock")
	await _restart_to_hub("quickened proof")
	await _start_run_with(_seed_offering(RogueliteUpgrade.Kind.QUICKENED_EDGE, 0, [] as Array[int]))
	var baseline_frames: int = await _measure_action_frames()
	var baseline_time: float = loop.player.attack.effective_action_time()
	_expect(is_equal_approx(baseline_time, ACCEPTED_ACTION_TIME),
		"the baseline action time is %.4f s, not %.2f" % [baseline_time, ACCEPTED_ACTION_TIME])

	await _clear_room(0)
	await _await_choice_panel()
	await _take_choice(RogueliteUpgrade.Kind.QUICKENED_EDGE)
	var upgraded_time: float = loop.player.attack.effective_action_time()
	_expect(is_equal_approx(upgraded_time, QUICKENED_ACTION_TIME),
		"the upgraded action time is %.4f s, expected %.2f" % [upgraded_time, QUICKENED_ACTION_TIME])
	_expect(is_equal_approx(loop.player.increased_attack_speed(), RogueliteUpgrade.QUICKENED_INCREASE),
		"the attack-speed field is %.3f, expected %.2f" % [
			loop.player.increased_attack_speed(), RogueliteUpgrade.QUICKENED_INCREASE])
	var upgraded_frames: int = await _measure_action_frames()
	_expect(upgraded_frames < baseline_frames,
		"the swing took %d frames before and %d after — no measurable change" % [
			baseline_frames, upgraded_frames])
	var ratio: float = float(upgraded_frames) / float(maxi(baseline_frames, 1))
	_expect(absf(ratio - (QUICKENED_ACTION_TIME / ACCEPTED_ACTION_TIME)) < 0.06,
		"the measured ratio is %.3f, expected about %.3f" % [
			ratio, QUICKENED_ACTION_TIME / ACCEPTED_ACTION_TIME])

	## NOTHING ELSE MOVED. The upgrade owns one field.
	var data: QuickStrikeData = loop.player.attack.data
	_expect(is_equal_approx(data.reach, ACCEPTED_REACH), "the Quickened Edge moved the reach")
	_expect(is_equal_approx(data.release_arc_degrees, ACCEPTED_ARC), "the Quickened Edge moved the release arc")
	_expect(is_equal_approx(data.release_marker_normalized, ACCEPTED_RELEASE_MARKER),
		"the Quickened Edge moved the release marker")
	print("  0.80 s → %.2f s, measured %d → %d physics frames (%.3f×)" % [
		upgraded_time, baseline_frames, upgraded_frames, ratio])
	_done("the_quickened_edge_changes_the_real_action_time")


## PROVED IN BOTH DIRECTIONS AGAINST THE REAL QUERY. A target 2.20 m away must
## MISS at the accepted 1.65 m reach and HIT at the review's 2.65 m — and the
## function asked is `TargetAcquisition.resolve_release()`, which is exactly the
## function `QuickStrikeAction._fire_release()` calls, handed exactly the record
## the kernel is handed.
func _check_the_reaching_edge_changes_the_real_reach() -> void:
	print("")
	print("--- The Reaching Edge changes the REAL release query, proved in both directions")
	await _restart_to_hub("reach proof")
	await _start_run_with(_seed_offering(RogueliteUpgrade.Kind.REACHING_EDGE, 0, [] as Array[int]))

	var before: Dictionary = await _release_query(PROBE_DISTANCE, 0.0)
	_expect(String(before["outcome"]) == "miss",
		"a target %.2f m away was HIT at the accepted %.2f m reach" % [PROBE_DISTANCE, ACCEPTED_REACH])
	_expect(String(_rejection_for(before)).contains("beyond"),
		"the miss was not a reach rejection: %s" % _rejection_for(before))
	## The control: something comfortably inside must already hit, or the
	## "miss" above could be a query that rejects everything.
	var control_before: Dictionary = await _release_query(PROBE_INSIDE_DISTANCE, 0.0)
	_expect(String(control_before["outcome"]) == "hit",
		"a target %.2f m away MISSED at the accepted reach — the query rejects everything" % PROBE_INSIDE_DISTANCE)
	var damaged_before: bool = await _strike_in_place_at(PROBE_DISTANCE, 0.0)
	_expect(not damaged_before,
		"a real swing damaged a target %.2f m away at the accepted %.2f m reach" % [
			PROBE_DISTANCE, ACCEPTED_REACH])

	await _clear_room(0)
	await _await_choice_panel()
	await _take_choice(RogueliteUpgrade.Kind.REACHING_EDGE)
	_expect(is_equal_approx(loop.player.attack.data.reach, REVIEW_REACH),
		"the live reach is %.3f m, expected %.2f" % [loop.player.attack.data.reach, REVIEW_REACH])

	await _advance_to_next_room()
	var after: Dictionary = await _release_query(PROBE_DISTANCE, 0.0)
	_expect(String(after["outcome"]) == "hit",
		"a target %.2f m away still MISSED at the upgraded %.2f m reach" % [PROBE_DISTANCE, REVIEW_REACH])
	var damaged_after: bool = await _strike_in_place_at(PROBE_DISTANCE, 0.0)
	_expect(damaged_after,
		"a real swing did not damage a target %.2f m away at the upgraded %.2f m reach" % [
			PROBE_DISTANCE, REVIEW_REACH])

	## Still bounded: the upgrade lengthens the reach, it does not remove it.
	var far: Dictionary = await _release_query(REVIEW_REACH + 1.0, 0.0)
	_expect(String(far["outcome"]) == "miss",
		"a target %.2f m away was hit at a %.2f m reach — the boundary is gone" % [
			REVIEW_REACH + 1.0, REVIEW_REACH])

	## NOTHING ELSE MOVED.
	_expect(is_equal_approx(loop.player.attack.data.release_arc_degrees, ACCEPTED_ARC),
		"the Reaching Edge moved the release arc")
	_expect(is_equal_approx(loop.player.attack.effective_action_time(), ACCEPTED_ACTION_TIME),
		"the Reaching Edge moved the action time")
	print("  %.2f m: MISS at %.2f m reach, HIT at %.2f m; still a miss at %.2f m" % [
		PROBE_DISTANCE, ACCEPTED_REACH, REVIEW_REACH, REVIEW_REACH + 1.0])
	_done("the_reaching_edge_changes_the_real_reach")


## The same shape for the arc, and it is the check that answers the brief's
## "cone" upgrade. THE PROPERTY THAT MOVES IS `release_arc_degrees`, which is
## what `resolve_release()` sweeps and therefore what decides what a swing hits,
## for the mouse and the controller alike. The D-178 soft-target cone is widened
## with it and is asserted separately below, because it is aim ASSISTANCE and
## decides nothing for a mouse player.
func _check_the_sweeping_edge_changes_the_real_arc() -> void:
	print("")
	print("--- The Sweeping Edge changes the REAL release arc, proved in both directions")
	await _restart_to_hub("arc proof")
	await _start_run_with(_seed_offering(RogueliteUpgrade.Kind.SWEEPING_EDGE, 0, [] as Array[int]))

	var before: Dictionary = await _release_query(PROBE_INSIDE_DISTANCE, PROBE_ANGLE_DEGREES)
	_expect(String(before["outcome"]) == "miss",
		"a target %.0f° off the facing axis was HIT at the authored %.0f° arc" % [
			PROBE_ANGLE_DEGREES, ACCEPTED_ARC])
	_expect(String(_rejection_for(before)).contains("release arc"),
		"the miss was not an arc rejection: %s" % _rejection_for(before))
	var control_before: Dictionary = await _release_query(PROBE_INSIDE_DISTANCE, PROBE_INSIDE_ANGLE_DEGREES)
	_expect(String(control_before["outcome"]) == "hit",
		"a target %.0f° off axis MISSED at the authored arc — the query rejects everything" % (
			PROBE_INSIDE_ANGLE_DEGREES))
	var damaged_before: bool = await _strike_in_place_at(PROBE_INSIDE_DISTANCE, PROBE_ANGLE_DEGREES)
	_expect(not damaged_before,
		"a real swing damaged a target %.0f° off the facing axis at the authored %.0f° arc" % [
			PROBE_ANGLE_DEGREES, ACCEPTED_ARC])

	await _clear_room(0)
	await _await_choice_panel()
	await _take_choice(RogueliteUpgrade.Kind.SWEEPING_EDGE)
	_expect(is_equal_approx(loop.player.attack.data.release_arc_degrees, REVIEW_ARC),
		"the live release arc is %.1f°, expected %.1f" % [
			loop.player.attack.data.release_arc_degrees, REVIEW_ARC])
	## The second field, and it is stated rather than buried: controller aim
	## assistance widens with the swing so the two cannot disagree.
	_expect(is_equal_approx(loop.player.attack.data.soft_target_cone_degrees, REVIEW_SOFT_CONE),
		"the live soft-target cone is %.1f°, expected %.1f" % [
			loop.player.attack.data.soft_target_cone_degrees, REVIEW_SOFT_CONE])
	_expect(is_equal_approx(loop.player.attack.data.soft_target_cone_half_degrees(), REVIEW_SOFT_CONE * 0.5),
		"the widened cone is not read as a TOTAL width (D-178)")

	await _advance_to_next_room()
	var after: Dictionary = await _release_query(PROBE_INSIDE_DISTANCE, PROBE_ANGLE_DEGREES)
	_expect(String(after["outcome"]) == "hit",
		"a target %.0f° off axis still MISSED at the upgraded %.0f° arc" % [
			PROBE_ANGLE_DEGREES, REVIEW_ARC])
	var damaged_after: bool = await _strike_in_place_at(PROBE_INSIDE_DISTANCE, PROBE_ANGLE_DEGREES)
	_expect(damaged_after,
		"a real swing did not damage a target %.0f° off axis at the upgraded %.0f° arc" % [
			PROBE_ANGLE_DEGREES, REVIEW_ARC])

	## THE WIDENED SOFT-TARGET CONE IS PROVED AGAINST THE REAL AIM-ASSIST QUERY,
	## NOT READ BACK OFF THE RECORD. Reading `data.soft_target_cone_degrees`
	## back out of the same object `_apply_upgrade()` wrote it into proves the
	## assignment, not the behaviour — and this is the field the brief's own
	## "65° total attack cone" actually names, so it owes a real proof.
	## `TargetAcquisition.soft_target()` is the exact function the controller
	## path calls (`BrokenWatchSlice._controller_aim_provider()`).
	var cone_probe: PrototypeGraveblade = await _probe_setup(
		SOFT_CONE_PROBE_DISTANCE, SOFT_CONE_PROBE_ANGLE_DEGREES)
	var intended: Vector3 = loop.player.facing_direction()
	var acquired_after: Dictionary = loop.acquisition.soft_target(
		loop.player.global_position, intended, loop._target_candidates(),
		loop.player.attack.data, null)
	_expect(acquired_after["target"] != null,
		"a candidate %.0f° off the stick direction was NOT acquired at the upgraded %.0f° cone" % [
			SOFT_CONE_PROBE_ANGLE_DEGREES, REVIEW_SOFT_CONE])
	## And the other direction, against the AUTHORED record — the same query,
	## the same candidate, the accepted 65° cone.
	var acquired_before: Dictionary = loop.acquisition.soft_target(
		loop.player.global_position, intended, loop._target_candidates(),
		loop.canonical_quick_strike_record(), null)
	_expect(acquired_before["target"] == null,
		"a candidate %.0f° off the stick direction was acquired at the accepted %.0f° cone" % [
			SOFT_CONE_PROBE_ANGLE_DEGREES, ACCEPTED_SOFT_CONE])
	_expect(String(acquired_before["reason"]).contains("cone"),
		"the refusal was not a cone refusal: %s" % acquired_before["reason"])
	cone_probe.reset_encounter()
	cone_probe.set_ai_enabled(false)

	## Still bounded: 180° total is +/- 90, so directly behind is still a miss.
	var behind: Dictionary = await _release_query(PROBE_INSIDE_DISTANCE, 170.0)
	_expect(String(behind["outcome"]) == "miss",
		"a target 170° off the facing axis was hit — the arc boundary is gone")

	## NOTHING ELSE MOVED.
	_expect(is_equal_approx(loop.player.attack.data.reach, ACCEPTED_REACH),
		"the Sweeping Edge moved the reach")
	_expect(is_equal_approx(loop.player.attack.effective_action_time(), ACCEPTED_ACTION_TIME),
		"the Sweeping Edge moved the action time")
	print("  %.0f° off axis: MISS at %.0f° arc, HIT at %.0f°; 170° is still a miss; cone %.0f° → %.0f°" % [
		PROBE_ANGLE_DEGREES, ACCEPTED_ARC, REVIEW_ARC, ACCEPTED_SOFT_CONE, REVIEW_SOFT_CONE])
	_done("the_sweeping_edge_changes_the_real_arc")


## The whole point of a BUILD: two upgrades held at once, both effective, and
## neither undoing the other. The probe is placed outside BOTH baselines at
## once — 2.20 m AND 70° off axis — so it can only be hit if both writes took.
func _check_two_upgrades_combine_correctly() -> void:
	print("")
	print("--- Two upgrades coexist: a probe outside BOTH baselines is hit by neither alone")
	await _restart_to_hub("combination proof")
	await _start_run_with(_seed_offering_both(
		RogueliteUpgrade.Kind.REACHING_EDGE, RogueliteUpgrade.Kind.SWEEPING_EDGE))

	var neither: Dictionary = await _release_query(PROBE_DISTANCE, PROBE_ANGLE_DEGREES)
	_expect(String(neither["outcome"]) == "miss", "the combined probe was hit with no upgrades at all")

	await _clear_room(0)
	await _await_choice_panel()
	await _take_choice(RogueliteUpgrade.Kind.REACHING_EDGE)
	var reach_only: Dictionary = await _release_query(PROBE_DISTANCE, PROBE_ANGLE_DEGREES)
	_expect(String(reach_only["outcome"]) == "miss",
		"the combined probe was hit with the Reaching Edge alone — the arc is not being tested")

	await _advance_to_next_room()
	await _clear_room(1)
	await _await_choice_panel()
	await _take_choice(RogueliteUpgrade.Kind.SWEEPING_EDGE)
	_expect(loop.build.count() == 2, "the build does not hold two upgrades")
	_expect(loop.build.held(RogueliteUpgrade.Kind.REACHING_EDGE), "the first upgrade was lost")
	_expect(loop.build.held(RogueliteUpgrade.Kind.SWEEPING_EDGE), "the second upgrade was not held")

	## BOTH writes are still in the live record. A second upgrade that reset the
	## record before writing would pass every single-upgrade check and fail here.
	var data: QuickStrikeData = loop.player.attack.data
	_expect(is_equal_approx(data.reach, REVIEW_REACH),
		"the reach fell back to %.3f m after the second upgrade" % data.reach)
	_expect(is_equal_approx(data.release_arc_degrees, REVIEW_ARC),
		"the release arc is %.1f° after the second upgrade" % data.release_arc_degrees)

	await _advance_to_next_room()
	var both: Dictionary = await _release_query(PROBE_DISTANCE, PROBE_ANGLE_DEGREES)
	_expect(String(both["outcome"]) == "hit",
		"the combined probe was still missed with both upgrades held")
	var damaged: bool = await _strike_in_place_at(PROBE_DISTANCE, PROBE_ANGLE_DEGREES)
	_expect(damaged, "a real swing did not damage the combined probe with both upgrades held")

	## The banner reports the combination, and reports it from the KERNEL.
	var live: Dictionary = loop.live_combat_values()
	_expect(is_equal_approx(float(live["reach"]), REVIEW_REACH), "the banner's reach disagrees with the kernel")
	_expect(is_equal_approx(float(live["arc"]), REVIEW_ARC), "the banner's arc disagrees with the kernel")
	var banner: String = _text_of(loop.run_hud.text_controls())
	_expect(banner.contains("Reaching Edge") and banner.contains("Sweeping Edge"),
		"the run banner does not name both held upgrades")
	## AND THE OPPOSITE ORDER, BECAUSE THE CLOBBER PROPERTY IS SYMMETRIC AND ONE
	## DIRECTION IS NOT A PROOF. Every combination above takes the Reaching Edge
	## first, so only the second-applied write is ever exercised as a potential
	## clobberer. An `_apply_upgrade()` branch that restored the record before
	## writing its own field would pass every single-upgrade check AND this one
	## — and would silently undo the first upgrade for any player whose seed
	## offered the two the other way round, which the 512-seed sweep proves is
	## reachable.
	await _restart_to_hub("reverse combination proof")
	await _start_run_with(_seed_offering_both(
		RogueliteUpgrade.Kind.SWEEPING_EDGE, RogueliteUpgrade.Kind.REACHING_EDGE))
	await _clear_room(0)
	await _await_choice_panel()
	await _take_choice(RogueliteUpgrade.Kind.SWEEPING_EDGE)
	_expect(is_equal_approx(loop.player.attack.data.release_arc_degrees, REVIEW_ARC),
		"the Sweeping Edge did not apply when it was taken first")
	await _advance_to_next_room()
	await _clear_room(1)
	await _await_choice_panel()
	await _take_choice(RogueliteUpgrade.Kind.REACHING_EDGE)
	var reversed: QuickStrikeData = loop.player.attack.data
	_expect(is_equal_approx(reversed.release_arc_degrees, REVIEW_ARC),
		"taking the Reaching Edge SECOND clobbered the arc back to %.1f°" % reversed.release_arc_degrees)
	_expect(is_equal_approx(reversed.reach, REVIEW_REACH),
		"the Reaching Edge did not apply when it was taken second")
	_expect(loop.build.count() == 2, "the reversed build does not hold two upgrades")
	await _advance_to_next_room()
	var reversed_probe: Dictionary = await _release_query(PROBE_DISTANCE, PROBE_ANGLE_DEGREES)
	_expect(String(reversed_probe["outcome"]) == "hit",
		"the combined probe was missed when the two upgrades were taken in the opposite order")

	print("  %.2f m at %.0f° off axis: missed with neither and with each alone, hit with both — in BOTH orders" % [
		PROBE_DISTANCE, PROBE_ANGLE_DEGREES])
	_done("two_upgrades_combine_correctly")


## The outline exists to make the two spatial upgrades judgeable by eye, so what
## has to be true is that it draws THE VALUES THE QUERY USED — not a copy, not a
## recomputation. It also has to change nothing: switching it off must leave the
## query identical.
func _check_the_swing_outline_reads_the_live_record() -> void:
	print("")
	print("--- The swing outline draws the live record, and changes nothing")
	var envelope: RogueliteStrikeEnvelope = loop.strike_envelope
	_expect(envelope.enabled, "the swing outline is off by default")
	var data: QuickStrikeData = loop.player.attack.data
	var draws_before: int = envelope.draws
	## VISIBILITY IS SAMPLED AT THE RELEASE, NOT AFTER THE SWING. The outline
	## lives 0.45 s and a whole action runs 0.80 s, so by the time the action
	## returns to READY it has correctly faded — a check that looked afterwards
	## would be measuring the fade, not the draw. The probe connects AFTER the
	## envelope's own handler, so it observes the state the player would see.
	var showing_at_release: Array = [false]
	var probe: Callable = func(_use_id: int, _outcome: Dictionary) -> void:
		showing_at_release[0] = envelope.is_showing()
	loop.player.attack.use_released.connect(probe)
	await _strike_in_place_at(PROBE_INSIDE_DISTANCE, 0.0)
	loop.player.attack.use_released.disconnect(probe)
	_expect(bool(showing_at_release[0]), "the outline was not visible at the moment of release")
	_expect(envelope.draws == draws_before + 1,
		"one swing produced %d outline(s), expected exactly 1" % (envelope.draws - draws_before))
	_expect(is_equal_approx(envelope.last_reach, data.reach),
		"the outline drew a %.3f m reach while the query used %.3f" % [envelope.last_reach, data.reach])
	_expect(is_equal_approx(envelope.last_arc_degrees, data.release_arc_degrees),
		"the outline drew a %.1f° arc while the query used %.1f" % [
			envelope.last_arc_degrees, data.release_arc_degrees])
	_expect(is_equal_approx(envelope.last_baseline_reach, ACCEPTED_REACH),
		"the outline's baseline reach is %.3f m, not the authored %.2f" % [
			envelope.last_baseline_reach, ACCEPTED_REACH])
	_expect(envelope.last_differs_from_baseline,
		"the outline did not report a difference while two spatial upgrades were held")
	_expect(envelope.global_position.distance_to(
		Vector3(loop.player.global_position.x, envelope.global_position.y, loop.player.global_position.z)) < 0.01,
		"the outline was not drawn where the swing happened")

	## OFF must mean off — and must change nothing about the query.
	envelope.set_enabled(false)
	var draws_off: int = envelope.draws
	var query_off: Dictionary = await _release_query(PROBE_DISTANCE, PROBE_ANGLE_DEGREES)
	await _strike_in_place_at(PROBE_INSIDE_DISTANCE, 0.0)
	_expect(envelope.draws == draws_off, "the outline drew while it was switched off")
	_expect(not envelope.is_showing(), "the outline is still visible while switched off")
	## And it fades on its own rather than being cleared by the next swing.
	_expect(envelope.LIFETIME < ACCEPTED_ACTION_TIME,
		"the outline outlives a whole Quick Strike action and could stack")
	envelope.set_enabled(true)
	var query_on: Dictionary = await _release_query(PROBE_DISTANCE, PROBE_ANGLE_DEGREES)
	_expect(String(query_off["outcome"]) == String(query_on["outcome"]),
		"the release query answered differently with the outline off and on")
	print("  %d outline(s) drawn; reach %.2f m and arc %.0f° match the live record exactly" % [
		envelope.draws, envelope.last_reach, envelope.last_arc_degrees])
	_done("the_swing_outline_reads_the_live_record")


# --- 6. Every reset path restores every baseline value -----------------------

func _check_death_restores_every_baseline_value() -> void:
	print("")
	print("--- Death clears the build and restores ALL FOUR baseline values")
	await _restart_to_hub("death proof")
	await _start_run_with(_seed_offering_both(
		RogueliteUpgrade.Kind.REACHING_EDGE, RogueliteUpgrade.Kind.SWEEPING_EDGE))
	await _clear_room(0)
	await _await_choice_panel()
	await _take_choice(RogueliteUpgrade.Kind.REACHING_EDGE)
	await _advance_to_next_room()
	await _clear_room(1)
	await _await_choice_panel()
	await _take_choice(RogueliteUpgrade.Kind.SWEEPING_EDGE)
	_expect(loop.build.count() == 2, "the build was not assembled before the death test")

	## KILLED BY THE GAME'S OWN DAMAGE PATH AND RETURNED BY THE GAME'S OWN
	## FALLEN BUTTON. The first version of this check dealt the lethal damage
	## and then called `restart_current_slice()` ITSELF, which proves the reset
	## function and not the death route: unwire the Fallen overlay's Restart and
	## a player who dies holding two upgrades would keep them, while a check
	## shaped like that still passed.
	loop.player.receive_damage(DamageEvent.physical(
		9001, loop.room_enemies[loop.run_state.current_room_index][0], loop.player, 9999.0))
	await _settle(6)
	_expect(not loop.player.is_alive(), "the lethal hit did not kill the player")
	## The accepted 0.90 s delay runs on `_process`, so the wait is on the
	## CONDITION with a generous cap rather than on a frame count.
	for frame: int in 600:
		if loop.fallen_overlay.is_open:
			break
		await get_tree().process_frame
	_expect(loop.fallen_overlay.is_open, "the Fallen overlay never opened after a lethal hit")
	var fallen_text: String = _text_of(loop.fallen_overlay.text_controls())
	_expect(fallen_text.contains("Fallen"), "the Fallen overlay does not say what it is")
	var restart_button: Button = loop.fallen_overlay.default_focus() as Button
	_expect(restart_button != null, "the Fallen overlay has no focusable way out")
	if restart_button != null:
		restart_button.pressed.emit()
	await _settle(6)
	await _await_process_frames(4)
	_expect(not loop.fallen_overlay.is_open, "the Fallen overlay stayed open after its own button")
	_assert_baseline_restored("death")
	_expect(loop.loop_state == RogueliteCoreLoopRuntime.LoopState.HUB, "death did not return to the Nexus")
	_done("death_restores_every_baseline_value")


func _check_abandon_restores_every_baseline_value() -> void:
	print("")
	print("--- F5 abandon clears the build and restores ALL FOUR baseline values")
	await _start_run_with(_seed_offering(RogueliteUpgrade.Kind.QUICKENED_EDGE, 0, [] as Array[int]))
	await _clear_room(0)
	await _await_choice_panel()
	await _take_choice(RogueliteUpgrade.Kind.QUICKENED_EDGE)
	_expect(loop.build.count() == 1, "the build was not assembled before the abandon test")
	_expect(is_equal_approx(loop.player.attack.effective_action_time(), QUICKENED_ACTION_TIME),
		"the upgrade was not active before the abandon test")

	## DISPATCHED AS A REAL INPUT EVENT, NOT BY CALLING THE FUNCTION F5 REACHES.
	## `quick_restart` is a bound action, and the project's own recorded lesson
	## is that `Input.action_press()` sets an action's STATE without producing an
	## `InputEvent` at all — so a check that used it would never reach
	## `_unhandled_input`. `parse_input_event()` goes through the ordinary
	## pipeline, so what is proved is that pressing the key abandons the run.
	var abandon: InputEventAction = InputEventAction.new()
	abandon.action = &"quick_restart"
	abandon.pressed = true
	Input.parse_input_event(abandon)
	await _await_process_frames(4)
	await _settle(6)
	var released: InputEventAction = InputEventAction.new()
	released.action = &"quick_restart"
	released.pressed = false
	Input.parse_input_event(released)
	await _await_process_frames(2)
	_assert_baseline_restored("abandon")
	_expect(loop.loop_state == RogueliteCoreLoopRuntime.LoopState.HUB, "abandon did not return to the Nexus")
	_done("abandon_restores_every_baseline_value")


func _check_the_next_run_starts_from_baseline() -> void:
	print("")
	print("--- The next expedition begins from the baseline, whatever the last one held")
	await _start_run_with(_seed_offering(RogueliteUpgrade.Kind.REACHING_EDGE, 0, [] as Array[int]))
	await _clear_room(0)
	await _await_choice_panel()
	await _take_choice(RogueliteUpgrade.Kind.REACHING_EDGE)
	_expect(is_equal_approx(loop.player.attack.data.reach, REVIEW_REACH),
		"the upgrade was not active before the next-run test")
	## Abandon, then start again — the path a player actually takes.
	loop.restart_current_slice("verification: next-run setup")
	await _settle(4)

	## THE STATE IS DIRTIED ON PURPOSE BEFORE THE NEXT RUN BEGINS, AND WITHOUT
	## THAT THIS CHECK PROVED NOTHING. The abandon above already restored every
	## value, so an assertion taken straight after `_begin_run()` could not tell
	## "the next run reset" from "the previous abandon reset" — delete the shared
	## reset from `_begin_run()` entirely and a check of that shape stays green,
	## which is the exact defect D-221 records. These writes are what make the
	## run-start leg of the reset the only thing that can clean them up.
	loop.player.attack.data.reach = REVIEW_REACH
	loop.player.attack.data.release_arc_degrees = REVIEW_ARC
	loop.player.attack.data.soft_target_cone_degrees = REVIEW_SOFT_CONE
	loop.player.set_increased_attack_speed(RogueliteUpgrade.QUICKENED_INCREASE)
	loop.build.acquire(RogueliteUpgrade.Kind.REACHING_EDGE)
	_expect(not loop.build.is_empty(), "the deliberate dirty state did not take")
	_expect(is_equal_approx(loop.player.attack.data.reach, REVIEW_REACH),
		"the deliberate dirty reach did not take")

	await _start_run()
	_assert_baseline_restored("next run")
	_expect(loop.build.is_empty(), "the next expedition began holding an upgrade")
	_expect(loop.run_state.reward_granted == false, "the next expedition began with the reward already granted")
	## And it is a NEW build object, not a cleared one: the reset replaces
	## rather than clears, so a field added later cannot be forgotten.
	_expect(loop.build.refusals == 0, "the next expedition inherited the previous build's refusals")
	_done("the_next_run_starts_from_baseline")


func _check_a_completed_run_clears_its_build() -> void:
	print("")
	print("--- A COMPLETED run keeps nothing, and the summary still reports what it held")
	await _restart_to_hub("completion proof")
	await _start_run_with(_seed_offering_both(
		RogueliteUpgrade.Kind.REACHING_EDGE, RogueliteUpgrade.Kind.SWEEPING_EDGE))
	await _clear_room(0)
	await _await_choice_panel()
	await _take_choice(RogueliteUpgrade.Kind.REACHING_EDGE)
	await _advance_to_next_room()
	await _clear_room(1)
	await _await_choice_panel()
	await _take_choice(RogueliteUpgrade.Kind.SWEEPING_EDGE)
	await _advance_to_next_room()
	await _clear_room(2)
	await _advance_to_next_room()

	_expect(loop.loop_state == RogueliteCoreLoopRuntime.LoopState.RUN_COMPLETE,
		"clearing every room did not complete the run")
	_expect(loop.summary_panel.is_open, "the run summary did not open")
	## THE CRITICAL ONE: the accepted core loop shipped a defect where a
	## COMPLETED run kept its temporary reward, because run-scoped state was
	## cleared only on death. Every expedition after the first was broken while
	## the summary read "Nothing here is kept."
	_assert_baseline_restored("completion")
	_expect(loop.build.is_empty(), "a completed run kept its build")

	## The summary still reports the finished build, from a snapshot captured
	## before the reset — and it reports the baseline beside it.
	_expect(loop.completed_build != null, "the completed build was not captured")
	_expect(loop.completed_build.count() == 2, "the captured build does not hold two upgrades")
	_expect(loop.completed_build.has_capture(), "the completed build captured no values")
	_expect(is_equal_approx(float(loop.completed_build.final_values["reach"]), REVIEW_REACH),
		"the captured reach is %.3f m, expected %.2f" % [
			float(loop.completed_build.final_values["reach"]), REVIEW_REACH])
	var summary: String = _text_of(loop.summary_panel.text_controls())
	_expect(summary.contains("Reaching Edge") and summary.contains("Sweeping Edge"),
		"the run summary does not name both upgrades the run was played with")
	_expect(summary.contains("%.2f m" % REVIEW_REACH),
		"the run summary does not state the reach the run ended on")
	_expect(summary.contains("%.2f m" % ACCEPTED_REACH),
		"the run summary does not state the baseline it has returned to")
	loop.summary_panel.close("verification")
	await _settle(2)
	print("  completed holding %s; every value back to baseline" % loop.completed_build.build_line())
	_done("a_completed_run_clears_its_build")


# --- 7. Boundaries ----------------------------------------------------------

## D-191's rule, asserted as a fact about the file on disk AND about the object
## in memory: the canonical Quick Strike record is never written to.
func _check_the_canonical_record_is_never_written() -> void:
	print("")
	print("--- The canonical quick_strike.tres is never written to, in memory or on disk")
	var canonical: QuickStrikeData = loop.canonical_quick_strike_record()
	_expect(loop.player.attack.data_is_private(),
		"the Quick Strike action has not taken a private runtime record")
	_expect(loop.player.attack.data != canonical,
		"the action's live record IS the canonical record")
	_expect(is_equal_approx(canonical.reach, ACCEPTED_REACH),
		"the canonical reach was written to: %.3f m" % canonical.reach)
	_expect(is_equal_approx(canonical.release_arc_degrees, ACCEPTED_ARC),
		"the canonical release arc was written to: %.1f°" % canonical.release_arc_degrees)
	_expect(is_equal_approx(canonical.soft_target_cone_degrees, ACCEPTED_SOFT_CONE),
		"the canonical soft-target cone was written to: %.1f°" % canonical.soft_target_cone_degrees)

	## Re-read from disk, so an in-memory cache cannot answer for the file.
	var on_disk: String = FileAccess.get_file_as_string(CANONICAL_QUICK_STRIKE)
	_expect(on_disk.contains("reach = 1.65"), "quick_strike.tres no longer stores reach = 1.65")
	_expect(on_disk.contains("release_arc_degrees = 100.0"),
		"quick_strike.tres no longer stores release_arc_degrees = 100.0")
	_expect(on_disk.contains("soft_target_cone_degrees = 65.0"),
		"quick_strike.tres no longer stores soft_target_cone_degrees = 65.0")

	## And no file of this review writes to the canonical object.
	for path: String in REVIEW_SCRIPTS:
		var source: String = _code_only(FileAccess.get_file_as_string(path))
		_expect(not source.contains("canonical_data.reach ="),
			"%s writes to the canonical reach" % path)
		_expect(not source.contains("canonical_data.release_arc_degrees ="),
			"%s writes to the canonical release arc" % path)
	print("  private runtime copy in use; 1.65 m / 100° / 65° intact in memory and on disk")
	_done("the_canonical_record_is_never_written")


func _check_writes_nothing() -> void:
	print("")
	print("--- This review writes nothing to disk and names no storage path")
	for path: String in REVIEW_SCRIPTS:
		var source: String = _code_only(FileAccess.get_file_as_string(path))
		for forbidden: String in [
			"user://", "ConfigFile", "ResourceSaver", "FileAccess.open", "storage_path", "save_",
		]:
			_expect(not source.contains(forbidden),
				"%s names '%s' — this review writes nothing" % [path, forbidden])
	_expect(not FileAccess.file_exists("user://roguelite_build_variety.cfg"),
		"a build-variety store was written")
	_expect(not FileAccess.file_exists("user://roguelite_run.cfg"), "a run store was written")
	_done("writes_nothing")


func _check_excluded_systems_absent() -> void:
	print("")
	print("--- Everything the brief excludes is absent, asserted by name")
	var source: String = ""
	for path: String in REVIEW_SCRIPTS:
		source += _code_only(FileAccess.get_file_as_string(path))
	var lowered: String = source.to_lower()
	for forbidden: String in [
		"run_graph", "dungeon_recipe", "procedural", "meta_progression",
		"permanent_progression", "rift_shard", "rift_echo", "augment",
		"passive_web", "crafting", "reliquary", "vault", "pursuit", "distortion",
		"elite_modifier", "boss", "dialogue", "crowd_scale",
	]:
		_expect(not lowered.contains(forbidden), "this review names '%s'" % forbidden)
	## No new room, no new enemy: both are read from the accepted records.
	_expect(not source.contains("VARIANTS["), "this review writes into the accepted room library")
	_expect(RogueliteRoomLibrary.VARIANTS.size() == EXPECTED_LIBRARY_ROOMS,
		"the accepted room library changed size")
	_expect(loop.graveblades.size() == EXPECTED_ENEMIES, "the enemy roster changed size")
	## Still no shuffle of the beat ORDER, which D-222 kept apart from selection.
	_expect(not (loop.plan as RogueliteSeededRunPlan).is_reordered(),
		"the beat order is being reordered")
	_done("excluded_systems_absent")


## Gate F shipped a HUD and four modals nobody could see while every text
## assertion passed. The property that matters is a non-empty rectangle inside
## the viewport, not a non-empty string.
func _check_surfaces_are_on_screen() -> void:
	print("")
	print("--- Every surface this review adds is actually on screen")
	var viewport: Rect2 = Rect2(Vector2.ZERO, Vector2(get_viewport().get_visible_rect().size))
	await _restart_to_hub("surface measurement")
	var banner: int = _measure_text(loop.run_hud.text_controls(), viewport, "run banner")
	_expect(banner > 0, "the run banner shows nothing")
	_expect_enclosed(loop.run_hud.text_controls(), viewport, "run banner")

	await _start_run()
	await _clear_room(0)
	await _await_choice_panel()
	await _await_process_frames(4)
	_expect(loop.choice_panel.get_global_rect().encloses(viewport)
		or loop.choice_panel.get_global_rect().size.x >= viewport.size.x,
		"the choice panel does not cover the viewport")
	var choice: int = _measure_text(loop.choice_panel.text_controls(), viewport, "choice panel")
	_expect(choice > 0, "the choice panel shows nothing")
	await _take_choice(loop.choice_panel.offered_kinds()[0])
	await _await_process_frames(4)
	var banner_after: int = _measure_text(loop.run_hud.text_controls(), viewport, "run banner, upgraded")
	_expect(banner_after >= banner, "the run banner lost lines once an upgrade was held")
	_expect_enclosed(loop.run_hud.text_controls(), viewport, "run banner, upgraded")
	_expect_enclosed(loop.choice_panel.text_controls(), viewport, "choice panel")

	await _advance_to_next_room()
	await _clear_room(1)
	await _await_choice_panel()
	await _take_choice(loop.choice_panel.offered_kinds()[0])
	await _advance_to_next_room()
	await _clear_room(2)
	await _advance_to_next_room()
	await _await_process_frames(4)
	_expect(loop.summary_panel.is_open, "the run summary did not open for the surface measurement")
	var summary: int = _measure_text(loop.summary_panel.text_controls(), viewport, "run summary")
	_expect(summary > 0, "the run summary shows nothing")
	loop.summary_panel.close("verification")
	await _settle(2)
	print("  run banner %d, choice panel %d, run summary %d visible text controls, 0 off screen" % [
		banner_after, choice, summary])
	_done("surfaces_are_on_screen")


# --- Evidence ---------------------------------------------------------------

## FOUR FRAMES, AND NO MORE — the brief asks for evidence that is small and
## useful. Each one shows something no other frame does.
func _capture_evidence() -> void:
	print("")
	print("--- Rendered evidence (%s)" % _shot_dir)
	DirAccess.make_dir_recursive_absolute(_shot_dir)

	await _restart_to_hub("evidence")
	await _start_run_with(_seed_offering_both(
		RogueliteUpgrade.Kind.REACHING_EDGE, RogueliteUpgrade.Kind.SWEEPING_EDGE))
	await _clear_room(0)
	await _await_choice_panel()
	await _await_process_frames(6)
	await _shoot("01_first_choice")

	await _take_choice(RogueliteUpgrade.Kind.REACHING_EDGE)
	await _advance_to_next_room()
	await _clear_room(1)
	await _await_choice_panel()
	await _take_choice(RogueliteUpgrade.Kind.SWEEPING_EDGE)
	await _await_process_frames(6)
	## THE OUTLINE IS PHOTOGRAPHED AT THE RELEASE, NOT AFTER THE SWING, AND THE
	## FIRST VERSION OF THIS FRAME PROVED WHY. The outline lives 0.45 s and a
	## whole Quick Strike action runs 0.80 s, so a frame taken once the action
	## returned to READY had a correct HUD, a correct camera, a passing suite —
	## and no outline in it at all. That is the accepted D-222 review's own
	## empty-overhead defect, recurring. Render the evidence and look at it.
	await _shoot_at_release(PROBE_DISTANCE, PROBE_ANGLE_DEGREES,
		"02_two_upgrades_and_the_swing_outline")

	await _advance_to_next_room()
	await _clear_room(2)
	await _await_process_frames(4)
	await _shoot("03_elite_room_with_the_build")

	await _advance_to_next_room()
	await _await_process_frames(6)
	await _shoot("04_run_summary")
	if loop.summary_panel.is_open:
		loop.summary_panel.close("evidence captured")
	await _settle(2)


## Drives a real swing and captures the frame while the outline is actually on
## screen, then lets the action finish. Waiting on the OUTLINE's own visibility
## rather than on a frame count keeps it a property of the game rather than of
## the machine this runs on.
func _shoot_at_release(distance: float, angle_degrees: float, stem: String) -> void:
	var enemy: PrototypeGraveblade = await _probe_setup(distance, angle_degrees)
	var facing: Vector3 = loop.player.facing_direction()
	loop.camera_rig.set_target(loop.player)
	loop.player.attack.set_attack_in_place(true)
	loop.player.attack.press()
	loop.player.attack.release_input()
	loop.player.attack.target = null
	loop.player.attack.aim = facing
	var drawn: bool = false
	for frame: int in 200:
		await get_tree().physics_frame
		if loop.strike_envelope.is_showing():
			drawn = true
			break
	_expect_quiet(drawn, "the swing outline never appeared for the evidence frame")
	await _shoot(stem)
	for frame: int in 200:
		await get_tree().physics_frame
		if loop.player.attack.phase == QuickStrikeAction.Phase.READY:
			break
	loop.player.attack.set_attack_in_place(false)
	enemy.reset_encounter()
	enemy.set_ai_enabled(false)
	await _settle(2)


func _shoot(stem: String) -> void:
	await RenderingServer.frame_post_draw
	var image: Image = get_viewport().get_texture().get_image()
	var path: String = "%s/%s.png" % [_shot_dir, stem]
	image.save_png(path)
	print("  wrote %s (%d x %d)" % [path, image.get_width(), image.get_height()])


# --- Run-driving helpers -----------------------------------------------------

## Puts the loop back in the Nexus from wherever it is, through the same entry
## point F5 and the death path both use.
func _restart_to_hub(reason: String) -> void:
	if loop.summary_panel.is_open:
		loop.summary_panel.close(reason)
	if loop.choice_panel.is_open:
		loop.choice_panel.close(reason)
	loop.restart_current_slice("verification: %s" % reason)
	await _settle(4)
	await _await_process_frames(2)


func _start_run() -> void:
	loop._begin_run("verification")
	await _settle(4)
	await _await_process_frames(2)


## Starts a run on a chosen seed. Several checks need a SPECIFIC upgrade to be
## offered, and which upgrades a run offers is a property of its seed — so the
## honest way to test one is to enter a run that genuinely offers it, not to
## reach past the offer and grant it directly.
func _start_run_with(seed_value: int) -> void:
	loop.plan = RogueliteBuildVarietyRunPlan.new(seed_value, 0)
	await _start_run()


## The first seed in a FIXED, deterministic walk whose choice `index` offers
## `kind` given `held`. Deterministic by construction — the same seed comes back
## on every run of this suite — and it fails loudly rather than silently falling
## back if the pool ever stops being reachable.
func _seed_offering(kind: int, index: int, held: Array[int]) -> int:
	for step: int in 4096:
		var candidate: int = (SEED_A + step * 7919) & 0xFFFFFFFF
		var plan: RogueliteBuildVarietyRunPlan = RogueliteBuildVarietyRunPlan.new(candidate, 0)
		if plan.offer_for(index, held).has(kind):
			return candidate
	_expect_quiet(false, "no seed in the search offers %s at choice %d" % [
		RogueliteUpgrade.name_of(kind), index + 1])
	return SEED_A


## A seed that offers `first` at choice 1 AND `second` at choice 2 once `first`
## has been taken — the pair a combination test has to be able to reach by
## playing rather than by assignment.
func _seed_offering_both(first: int, second: int) -> int:
	for step: int in 4096:
		var candidate: int = (SEED_A + step * 7919) & 0xFFFFFFFF
		var plan: RogueliteBuildVarietyRunPlan = RogueliteBuildVarietyRunPlan.new(candidate, 0)
		if not plan.offer_for(0, [] as Array[int]).has(first):
			continue
		if plan.offer_for(1, [first] as Array[int]).has(second):
			return candidate
	_expect_quiet(false, "no seed in the search offers %s then %s" % [
		RogueliteUpgrade.name_of(first), RogueliteUpgrade.name_of(second)])
	return SEED_A


## Kills every enemy in a room and returns how many Hits the LAST one took.
func _clear_room(index: int) -> int:
	var hits: int = 0
	for enemy: PrototypeGraveblade in loop.room_enemies[index]:
		if enemy.is_alive():
			hits = await _kill(enemy)
	await _settle(4)
	await _await_process_frames(4)
	return hits


## Walks into the open gate the way the game does — by putting the player there
## and letting the runtime's own polled `_check_exit()` see it on an IDLE frame.
## `_check_exit` runs from `_process`, so waiting on physics alone would prove
## nothing: a loaded machine fits several physics steps inside one idle frame.
##
## The D-222 gate guard means a gate that opened under the player's feet does
## nothing until they step OUT of it once, so the walk starts well clear of it.
func _advance_to_next_room() -> void:
	var from: int = loop.run_state.current_room_index
	if from < 0:
		return
	var gate: Vector3 = loop.room_modules[from].exit_point()
	var away: Vector3 = loop.room_modules[from].entry_point()
	loop.player.global_position = Vector3(away.x, 0.0, away.z)
	loop.camera_rig.focus = loop.player.global_position
	await _await_process_frames(4)
	loop.player.global_position = Vector3(gate.x, 0.0, gate.z)
	loop.player.velocity = Vector3.ZERO
	loop.camera_rig.focus = loop.player.global_position
	await _await_process_frames(8)
	await _settle(4)


func _await_choice_panel() -> void:
	if not loop.awaiting_upgrade_choice():
		return
	for frame: int in 4000:
		if loop.choice_panel.is_open:
			return
		await get_tree().process_frame
	_expect_quiet(loop.choice_panel.is_open, "the upgrade choice panel never opened")


## Presses the button that offers `kind`, rather than calling the grant
## directly. A choice proved only by calling the grant proves the grant, not the
## button — and the buttons bind a SLOT, which is exactly the thing that could
## drift from what they display.
func _take_choice(kind: int) -> void:
	var offered: Array[int] = loop.choice_panel.offered_kinds()
	var slot: int = offered.find(kind)
	_expect_quiet(slot >= 0, "%s was not offered by this choice" % RogueliteUpgrade.name_of(kind))
	if slot < 0:
		slot = 0
	var caption: String = _button_caption(loop.choice_panel.choice_buttons()[slot])
	_expect_quiet(caption.contains(RogueliteUpgrade.name_of(offered[slot])),
		"button %d reads '%s' but its slot offers %s" % [
			slot, caption, RogueliteUpgrade.name_of(offered[slot])])
	loop.choice_panel.choice_buttons()[slot].pressed.emit()
	await _settle(2)
	await _await_process_frames(2)


## Asserts all four values are the authored baseline. One helper, called by
## every reset path, so no path can be checked less thoroughly than another.
func _assert_baseline_restored(route: String) -> void:
	var data: QuickStrikeData = loop.player.attack.data
	_expect(loop.build.is_empty(), "%s left %d upgrade(s) held" % [route, loop.build.count()])
	_expect(is_equal_approx(loop.player.physical_damage, WORN_DAMAGE),
		"%s left the weapon at %.0f damage, expected %.0f" % [route, loop.player.physical_damage, WORN_DAMAGE])
	_expect(is_equal_approx(loop.player.attack.effective_action_time(), ACCEPTED_ACTION_TIME),
		"%s left the action time at %.4f s, expected %.2f" % [
			route, loop.player.attack.effective_action_time(), ACCEPTED_ACTION_TIME])
	_expect(is_equal_approx(loop.player.increased_attack_speed(), 0.0),
		"%s left the attack-speed field at %.3f" % [route, loop.player.increased_attack_speed()])
	_expect(is_equal_approx(data.reach, ACCEPTED_REACH),
		"%s left the reach at %.3f m, expected %.2f" % [route, data.reach, ACCEPTED_REACH])
	_expect(is_equal_approx(data.release_arc_degrees, ACCEPTED_ARC),
		"%s left the release arc at %.1f°, expected %.1f" % [route, data.release_arc_degrees, ACCEPTED_ARC])
	_expect(is_equal_approx(data.soft_target_cone_degrees, ACCEPTED_SOFT_CONE),
		"%s left the soft-target cone at %.1f°, expected %.1f" % [
			route, data.soft_target_cone_degrees, ACCEPTED_SOFT_CONE])
	_expect(not loop.choice_panel.is_open, "%s left the choice panel open" % route)


# --- Combat-geometry helpers -------------------------------------------------

## Places the player at a clear point in the current room and ONE living enemy
## at an exact planar distance and angle from the player's facing, then asks the
## REAL release query. Every other enemy is at least 31 m away in another
## module, so the answer is about this one probe.
func _probe_setup(distance: float, angle_degrees: float) -> PrototypeGraveblade:
	var index: int = maxi(loop.run_state.current_room_index, 0)
	var module: RogueliteRoomModule = loop.room_modules[index]
	var centre: Vector3 = module.room_centres()[0]
	var enemy: PrototypeGraveblade = loop.room_enemies[index][0]
	enemy.reset_encounter()
	enemy.set_ai_enabled(false)
	loop.player.global_position = Vector3(centre.x, 0.0, centre.z)
	loop.player.velocity = Vector3.ZERO
	var facing: Vector3 = module.route_forward()
	loop.player.face_instantly(facing)
	var yaw: float = atan2(facing.x, facing.z) + deg_to_rad(angle_degrees)
	enemy.global_position = loop.player.global_position + Vector3(sin(yaw), 0.0, cos(yaw)) * distance
	enemy.velocity = Vector3.ZERO
	await _settle(3)
	return enemy


## The exact function `QuickStrikeAction._fire_release()` calls, handed the exact
## record the kernel is handed and the whole candidate list the game passes.
func _release_query(distance: float, angle_degrees: float) -> Dictionary:
	await _probe_setup(distance, angle_degrees)
	return loop.acquisition.resolve_release(
		loop.player.global_position, loop.player.facing_direction(), null,
		loop._target_candidates(), loop.player.attack.data
	)


## Why the probe was rejected, read out of the query's own reasoning rather than
## inferred — a miss for the wrong reason is not the miss the check wants.
## THE NEAREST considered candidate, not the first one in the list. The runtime
## passes the WHOLE roster to the query — fifteen enemies across a 293 m library
## — so the first rejected record was another module's enemy 126 m away, and the
## check was reading that enemy's reason for the probe's miss.
static func _rejection_for(outcome: Dictionary) -> String:
	var nearest: Dictionary = {}
	for record: Dictionary in outcome.get("considered", [] as Array):
		if nearest.is_empty() or float(record["distance"]) < float(nearest["distance"]):
			nearest = record
	return "" if nearest.is_empty() else String(nearest.get("rejected", ""))


## A REAL swing, in place, at a probe. It returns whether the enemy took damage.
##
## The target is deliberately NOT forced: forcing it would make
## `_update_facing()` turn the player toward the enemy, which is precisely the
## angle the arc test is measuring. Instead the two fields a directional swing
## would itself have set are written — a null target and an aim along the
## player's own facing — so the player keeps the facing this harness gave it.
func _strike_in_place_at(distance: float, angle_degrees: float) -> bool:
	var enemy: PrototypeGraveblade = await _probe_setup(distance, angle_degrees)
	var before: float = enemy.life
	var facing: Vector3 = loop.player.facing_direction()
	loop.player.attack.set_attack_in_place(true)
	loop.player.attack.press()
	loop.player.attack.release_input()
	loop.player.attack.target = null
	loop.player.attack.aim = facing
	for frame: int in 200:
		await get_tree().physics_frame
		if loop.player.attack.phase == QuickStrikeAction.Phase.READY:
			break
	loop.player.attack.set_attack_in_place(false)
	var damaged: bool = enemy.life < before
	enemy.reset_encounter()
	enemy.set_ai_enabled(false)
	await _settle(2)
	return damaged


## Kills an enemy with forced, deterministic Quick Strikes and returns how many
## it took. The AI is disabled first so the count measures the weapon, not the
## fight.
func _kill(enemy: PrototypeGraveblade) -> int:
	enemy.set_ai_enabled(false)
	var area: PrototypeTargetable = enemy.get_node("TargetArea") as PrototypeTargetable
	var hits: int = 0
	while enemy.is_alive() and hits < 12:
		await _strike(enemy, area)
		hits += 1
	_expect_quiet(not enemy.is_alive(), "%s survived %d forced Quick Strikes" % [enemy.name, hits])
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
	for frame: int in 200:
		await get_tree().physics_frame
		if loop.player.attack.phase == QuickStrikeAction.Phase.READY:
			break
	_expect_quiet(enemy.life < before_life or not enemy.is_alive(),
		"a forced Quick Strike produced no damage (Life stayed %.0f)" % before_life)


## How many PHYSICS frames one complete Quick Strike takes, press to ready.
## Measured on the simulation clock rather than the wall clock — the project's
## own recorded lesson: reading two `Time.get_ticks_msec()` values across a
## stall measures the stall.
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


# --- Plumbing ---------------------------------------------------------------

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


static func _names(kinds: Array[int]) -> String:
	var found: PackedStringArray = PackedStringArray()
	for kind: int in kinds:
		found.append(RogueliteUpgrade.name_of(kind))
	return " | ".join(found)


## `FirstMvpModal.make_button()` builds `Button -> HBoxContainer -> Label`, so a
## button's visible caption is a descendant Label's text, never `Button.text`.
static func _button_caption(button: Button) -> String:
	for child: Node in button.get_children():
		for grandchild: Node in child.get_children():
			var label: Label = grandchild as Label
			if label != null and not label.text.strip_edges().is_empty():
				return label.text
	return button.text


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
		_expect_quiet(inside, "%s: a visible control has no rectangle inside the viewport (%s)" % [label, rect])
		if inside:
			visible += 1
	return visible


## FULLY INSIDE THE VIEWPORT, NOT MERELY OVERLAPPING IT — and this exists
## because `_measure_text()` was satisfied by a control that was CLIPPED. A
## longer, non-wrapping line in the run banner made its PanelContainer wider than
## the window and pushed the whole banner past the right edge at 1280x720; every
## rectangle still intersected the viewport, so nothing failed. Only the picture
## showed it. This asserts the property that was actually owed.
func _expect_enclosed(controls: Array, viewport: Rect2, label: String) -> void:
	var outside: PackedStringArray = PackedStringArray()
	for entry: Variant in controls:
		var control: Control = entry as Control
		if control == null or not control.is_visible_in_tree():
			continue
		var rect: Rect2 = control.get_global_rect()
		if rect.size.x <= 0.0 or rect.size.y <= 0.0:
			continue
		if not viewport.encloses(rect):
			outside.append("%s at %s" % [control.name, rect])
	_expect(outside.is_empty(),
		"%s: %d control(s) are clipped by the window edge — %s" % [
			label, outside.size(), ", ".join(outside)])


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


func _argument_value(flag: String) -> String:
	for index: int in arguments.size():
		if arguments[index] == flag and index + 1 < arguments.size():
			return arguments[index + 1]
	return ""
