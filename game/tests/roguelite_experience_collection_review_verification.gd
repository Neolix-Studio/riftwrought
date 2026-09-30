extends Node
## Riftwrought — Roguelite Experience Collection Greybox Review V1: automated
## verification (decision D-288).
##
## THIS IS NOT A GATE, AND IT RE-PROVES NO FOUNDATION. H1–H8, G1 and the core loop
## prove their own mechanisms in their own suites. What only this suite can know is
## whether the LAYER behaves: that the review makes exactly one Experience Mote
## runtime per expedition from that expedition's exact seed, registers the fixed
## route's Graveblades before any of them can die, mirrors every accepted drop with
## exactly one marker at the same index, lets the sweep's own answer decide every
## collection, reaches G1's Level 1 requirement with four review motes and opens
## nothing, and throws all of it away on completion, on death and on F5 — while
## the accepted loop underneath keeps behaving exactly as it was accepted.
##
## IT WALKS THE DOCUMENTED ROUTE, WITH SEED 99. Nexus, the Rift Gate, F8 off, the
## Teaching Hall kill, the inclusive boundary, the Cache Room in reverse death
## order, the Elite Hall to 100 and then 125, completion, a second run, F5, and a
## third run ended by death.
##
## EVERY KILL IS THE REAL ACTOR'S OWN. Each Graveblade dies through its own public
## `receive_damage()` and its own mechanical death. The harness never emits `died`,
## never touches a binding, never writes a member of H8 or of anything H8 owns, and
## reads H8 only through its own scalar readings. It moves a Graveblade only through
## the actor's own `place_at()`, and only to whole-metre world coordinates, so the
## inclusive pickup boundary can be stated EXACTLY in the single-precision
## coordinates the engine stores. It never frees one.
##
## THE ONE PRESENTATION SEAM IT DRIVES DIRECTLY is `_present_sweep()`, handed two
## sweep values built by H5's own constructors, to prove a refusal is SHOWN rather
## than hidden and that an index no marker mirrors hides nothing. Those values never
## reach H8 and move no experience.
##
## EVERY EXPECTED ANSWER IS A TYPED LITERAL OR THE ACCEPTED MECHANISM'S OWN ANSWER:
## 25.0 is the review's amount, 100 is G1's Level 1 requirement (asked of G1 as
## well), 2.5 m is H2's own base radius constant, and 99 is the route's seed.
##
## D-289 LIFTED THE ORB AND LEFT THE DROP WHERE IT WAS, and this suite proves both
## halves from the review's own marker record and the accepted sweep outcomes
## alone: the ring and the orb keep the death position's exact X and Z at their two
## fixed heights whatever the player or camera does and whichever Graveblade fell,
## while one float32 step outside the pickup boundary on every side still refuses,
## the exact boundary still collects, and the collected indices are the ones D-288
## measured before the orb moved.
##
## IT PORTS D-211's OWED-SET DISCIPLINE — every check records reaching its last line
## and the set is compared in both directions — and GATE F's ON-SCREEN MEASUREMENT,
## because reading the right words out of a Control proves they exist, not that
## anyone can see them. The rendered evidence frames add NO assertion, so the
## headless and rendered runs pin the same count.
##
## Run: godot --headless --path game res://scenes/roguelite/roguelite_experience_collection_review.tscn -- --seed 99 --verify-experience

const REVIEW_SCRIPT: String = "res://scripts/roguelite/experience/roguelite_experience_collection_review.gd"
const HUD_SCRIPT: String = "res://scripts/roguelite/experience/roguelite_experience_review_hud.gd"
const REVIEW_SCENE_FILE: String = "res://scenes/roguelite/roguelite_experience_collection_review.tscn"
const ACCEPTED_SCENE: String = "res://scenes/roguelite/roguelite_core_loop.tscn"
const ACCEPTED_RUNTIME_SCRIPT: String = "res://scripts/roguelite/roguelite_core_loop_runtime.gd"
const ACCEPTED_SLICE_SCRIPT: String = "res://scripts/first_mvp/severed_threshold/broken_watch_slice.gd"
const ORDINARY_RECORD: String = "res://data/prototype_zero/graveblade.tres"
const ELITE_RECORD: String = "res://data/roguelite/graveblade_elite.tres"
const PROJECT_SETTINGS_FILE: String = "res://project.godot"
const ENTRYPOINT: String = "res://scenes/app/prototype_app.tscn"

const ROUTE_SEED: int = 99
const ROUTE_SEED_TEXT: String = "00000063"
const REVIEW_AMOUNT: float = 25.0
const LEVEL_ONE_REQUIREMENT: int = 100
const EXPECTED_ROUTE_ENEMIES: int = 5
const EXPECTED_ENEMIES_PER_ROOM: Array[int] = [1, 2, 2]
const EXPECTED_ACTIONS: int = 31
const PRODUCTION_EXPERIENCE_REWARD: int = 10
const NONLETHAL_HIT: float = 100.0

## The accepted capsule (1 unit = 1 m; D-175): a marker must be narrower and lower.
const PLAYER_WIDTH: float = 0.80
const PLAYER_HEIGHT: float = 1.80

## D-289 ruling 1: the orb's fixed review height, and the band the ring's
## anti-z-fighting offset must lie in — typed here, compared with the review's own.
const ORB_REVIEW_HEIGHT: float = 0.70
const RING_OFFSET_MIN: float = 0.02
const RING_OFFSET_MAX: float = 0.03
const FLASH_SECONDS: float = 0.32

## `Death_A` is 0.80 s and does not loop (the KayKit source record). An evidence
## frame of a corpse waits this long, so it shows the corpse the run keeps rather
## than one still falling — which is what D-288's first frames showed.
const DEATH_CLIP_SETTLE_SECONDS: float = 1.2

## The death-order indices D-288 measured, sweep by sweep, before the orb moved.
const EXPECTED_COLLECTED_SEQUENCE: String = "[[0], [2], [1], [3], [4]]"

const ACCEPTED_CAMERA_DISTANCE: float = 19.0
const ACCEPTED_CAMERA_PITCH: float = 55.0
const ACCEPTED_CAMERA_FOV: float = 45.0
const ACCEPTED_MAX_SPEED: float = 5.0

## The inherited methods the review overrides — exactly these, and each of the
## first eight calls the accepted one.
const EXPECTED_OVERRIDES: Array[String] = [
	"_begin_run", "_build_run_surfaces", "_complete_run", "_handle_review_keys",
	"_maybe_start_verification", "_physics_process", "_process", "_refresh_run_hud",
	"restart_current_slice",
]

## The accepted assembly the review must NOT re-implement.
const ASSEMBLY_METHODS: Array[String] = [
	"_ready", "_build_modules", "_build_module", "_configure_navigation",
	"_await_navigation_synchronized", "_spawn_player_in_hub", "_spawn_combat_kernel",
	"_spawn_encounters", "_spawn_room_enemy", "_enter_room", "_advance_room", "_check_exit",
	"_enter_hub", "_place_player_at", "_reset_run_scoped_state", "_reset_all_encounters",
	"_on_encounter_enemy_died", "_on_room_cleared", "_place_run_reward", "bake_navigation",
	"_unhandled_input", "_input",
]

## The only project classes each review file may name, checked against the
## engine's own global class list in both directions.
const REVIEW_NAMES: Array[String] = [
	"DamageEvent", "PrototypeGraveblade", "RiftLevelRequirementCurve",
	"RiftLevelRequirementReading", "RiftMoteRuntime", "RiftMoteSweepResult",
	"RogueliteCoreLoopRuntime", "RogueliteExperienceCollectionReview",
	"RogueliteExperienceReviewHud",
]
const HUD_NAMES: Array[String] = [
	"RogueliteExperienceCollectionReview", "RogueliteExperienceReviewHud",
]

## Anything that would mean the layer restated a mechanism it composes, read a
## production experience value, opened an offer, reached a foundation it does not
## own, or touched the InputMap or the clock.
const RESTATED_TOKENS: Array[String] = [
	"BASE_PICKUP_RADIUS", "PICKUP_RADIUS", "MAGNETISM", "Magnetism", "EXPERIENCE_GAIN",
	"PlayerStat", "distance_to", "distance_squared_to", ".length()", "sqrt(",
	"award_experience", "BASE_REQUIREMENT", "REQUIREMENT_STEP", "open_offer",
	"open_current_offer", "choose(", "spawn_drop", "sweep_collection", "attempt_collection",
	"collect_into", "experience_reward", "GravebladeData", "RiftMoteField", "RiftMoteDrop",
	"RiftRunLevelCoordinator", "RiftGravebladeMoteBinding", "RiftEnemyMoteEmission",
	"RiftExperienceMote", "RiftExperienceTrack", "RiftMotePickup", "RiftMoteCollection",
	"RiftLevelOfferSeed", "paused = true", "InputMap", "time_scale", "2.5",
]

const STORAGE_TOKENS: Array[String] = [
	"user://", "ConfigFile", "ResourceSaver", "FileAccess", "DirAccess", "store_string",
	"save_png", "PrototypeSettings", "PrototypeLabState", "CharacterSave",
]

const ASSET_TOKENS: Array[String] = [
	"res://assets/", ".gltf", ".glb", ".png", ".import", "kaykit", "kenney", "k0rveen",
	"quaternius", "lelu", "GPUParticles", "CPUParticles", "ShaderMaterial", ".gdshader",
	"AudioStream", "Texture2D",
]

## The review panel's text controls, in `text_controls()` order.
const HUD_SEED: int = 1
const HUD_LEVEL: int = 2
const HUD_EXPERIENCE: int = 3
const HUD_REGISTERED: int = 4
const HUD_MOTES: int = 5
const HUD_PICKUP: int = 6
const HUD_REFUSAL: int = 7
const HUD_LEVEL_UP: int = 8
const HUD_LEVEL_UP_NOTE: int = 9

const LEVEL_UP_TEXT: String = "LEVEL-UP READY"
const LEVEL_UP_NOTE: String = "The three-card offer is the next review; this scene does not open it."

const OWED_CHECKS: Array[String] = [
	"the_review_is_isolated_and_reuses_the_accepted_assembly",
	"the_input_map_is_unchanged_and_f8_is_a_physical_key",
	"the_nexus_holds_no_runtime",
	"a_run_owns_one_runtime_of_its_exact_seed",
	"production_experience_is_untouched",
	"nonlethal_hits_make_nothing",
	"a_lethal_hit_makes_one_aligned_marker",
	"pickup_off_sweeps_nothing",
	"the_lifted_orb_is_fixed_against_the_player_and_camera",
	"the_inclusive_boundary_decides_collection",
	"a_collected_marker_never_returns",
	"death_order_indexing_hides_only_the_collected_marker",
	"four_motes_reach_the_requirement_and_nothing_opens",
	"the_review_surface_is_legible_and_unobstructed",
	"a_fifth_mote_still_opens_nothing",
	"completion_tears_everything_down",
	"a_new_run_binds_afresh_and_old_callbacks_stay_silent",
	"refusals_are_shown_not_hidden",
	"a_mote_left_behind_stays_until_teardown",
	"abandoning_tears_everything_down",
	"death_tears_everything_down",
	"the_review_restates_no_mechanism_and_writes_nothing",
]

var review: RogueliteExperienceCollectionReview
var arguments: PackedStringArray = PackedStringArray()

var _failures: PackedStringArray = PackedStringArray()
var _checks: int = 0
var _reached: Dictionary = {}
var _shot_dir: String = ""
var _next_use_id: int = 88000
var _deaths_driven: int = 0
var _experience_steps: Array[float] = []
var _collected_sequence: Array = []

## Weak references only: a strong one held here would keep a discarded runtime
## alive and make every teardown proof pass for the wrong reason.
var _first_runtime: WeakRef = null
var _second_runtime: WeakRef = null
var _third_runtime: WeakRef = null


func _ready() -> void:
	await run()


func run() -> void:
	print("")
	print("=== Roguelite Experience Collection Greybox Review V1 verification (D-288, corrected under D-289) ===")
	_shot_dir = _argument_value("--shots")
	await _settle(10)
	await _await_navigation()

	_check_the_review_is_isolated_and_reuses_the_accepted_assembly()
	await _check_the_input_map_is_unchanged_and_f8_is_a_physical_key()
	_check_the_nexus_holds_no_runtime()
	await _check_a_run_owns_one_runtime_of_its_exact_seed()
	_check_production_experience_is_untouched()
	await _check_nonlethal_hits_make_nothing()
	_check_a_lethal_hit_makes_one_aligned_marker()
	await _check_pickup_off_sweeps_nothing()
	await _check_the_lifted_orb_is_fixed_against_the_player_and_camera()
	await _check_the_inclusive_boundary_decides_collection()
	await _check_a_collected_marker_never_returns()
	await _check_death_order_indexing_hides_only_the_collected_marker()
	await _check_four_motes_reach_the_requirement_and_nothing_opens()
	await _check_the_review_surface_is_legible_and_unobstructed()
	await _check_a_fifth_mote_still_opens_nothing()
	await _check_completion_tears_everything_down()
	await _check_a_new_run_binds_afresh_and_old_callbacks_stay_silent()
	_check_refusals_are_shown_not_hidden()
	await _check_a_mote_left_behind_stays_until_teardown()
	await _check_abandoning_tears_everything_down()
	await _check_death_tears_everything_down()
	_check_the_review_restates_no_mechanism_and_writes_nothing()

	_check_every_check_ran()

	print("")
	print("  %d Graveblade deaths were driven and %d automatic sweeps were made across this suite" % [
		_deaths_driven, review.sweeps_made,
	])
	if _failures.is_empty():
		print("ROGUELITE EXPERIENCE COLLECTION REVIEW VERIFICATION: PASS (%d checks)" % _checks)
		get_tree().quit(0)
	else:
		for failure: String in _failures:
			printerr("  FAIL: %s" % failure)
		printerr("ROGUELITE EXPERIENCE COLLECTION REVIEW VERIFICATION: %d FAILURE(S) of %d checks" % [
			_failures.size(), _checks,
		])
		get_tree().quit(1)


# --- 1. Isolation and reuse -----------------------------------------------------------

func _check_the_review_is_isolated_and_reuses_the_accepted_assembly() -> void:
	print("")
	print("--- 1. The review is isolated, is not the entrypoint, and IS the accepted assembly")
	var entry: String = String(ProjectSettings.get_setting("application/run/main_scene", ""))
	_expect(entry == ENTRYPOINT, "the entrypoint is %s, not %s" % [entry, ENTRYPOINT])
	var settings: String = FileAccess.get_file_as_string(PROJECT_SETTINGS_FILE)
	_expect(settings.length() > 1000, "project.godot could not be read")
	_expect(not settings.contains("experience_collection") and not settings.contains("RogueliteExperience"),
		"project.godot names this review")
	_expect(not settings.contains("[autoload]"), "project.godot declares an [autoload] section")
	_expect(review.scene_file_path == REVIEW_SCENE_FILE,
		"the running scene is %s, not the review's own" % review.scene_file_path)

	## The scene is one inherited instance of the accepted scene with its script
	## replaced — measured structurally, so an editor that later adds uids to its
	## headers cannot turn this red, while any copied node, resource or second
	## instance would.
	var statements: PackedStringArray = _scene_statements(FileAccess.get_file_as_string(REVIEW_SCENE_FILE))
	var nodes: int = 0
	var ext_resources: int = 0
	var sub_resources: int = 0
	var scripts_set: int = 0
	var instances_accepted: bool = false
	var accepted_id: String = ""
	for line: String in statements:
		if line.begins_with("[ext_resource"):
			ext_resources += 1
			if line.contains("path=\"%s\"" % ACCEPTED_SCENE) and line.contains("type=\"PackedScene\""):
				accepted_id = line.get_slice("id=\"", 1).get_slice("\"", 0)
		elif line.begins_with("[sub_resource"):
			sub_resources += 1
		elif line.begins_with("[node"):
			nodes += 1
			instances_accepted = not accepted_id.is_empty() and line.contains("instance=ExtResource(\"%s\")" % accepted_id)
		elif line.begins_with("script = ExtResource("):
			scripts_set += 1
	_expect(nodes == 1 and ext_resources == 2 and sub_resources == 0 and scripts_set == 1 and instances_accepted,
		"the scene is not one inherited instance of %s with its script replaced (%d node, %d ext, %d sub, %d script, instances accepted %s)" % [
			ACCEPTED_SCENE, nodes, ext_resources, sub_resources, scripts_set, str(instances_accepted),
		])

	_expect(review is RogueliteCoreLoopRuntime, "the review is not the accepted runtime's type")
	var base: Script = (review.get_script() as Script).get_base_script()
	_expect(base != null and base.resource_path == ACCEPTED_RUNTIME_SCRIPT,
		"the review's script does not extend %s" % ACCEPTED_RUNTIME_SCRIPT)

	## Its assembly is the accepted one, measured rather than argued.
	var ids: PackedStringArray = PackedStringArray()
	for module: RogueliteRoomModule in review.room_modules:
		ids.append(String(module.module_id))
	_expect(review.all_modules.size() == 4 and ids == PackedStringArray(["teaching_hall", "cache_room", "elite_hall"]),
		"the route is %s over %d modules, not the accepted fixed order" % [", ".join(ids), review.all_modules.size()])
	var per_room: Array[int] = []
	for group: Array in review.room_enemies:
		per_room.append(group.size())
	_expect(per_room == EXPECTED_ENEMIES_PER_ROOM and review.graveblades.size() == EXPECTED_ROUTE_ENEMIES,
		"the route holds %s Graveblades per room (%d total), not the accepted %s" % [
			str(per_room), review.graveblades.size(), str(EXPECTED_ENEMIES_PER_ROOM),
		])
	_expect(review.bake_count == 1, "the navigation mesh was baked %d times, not once" % review.bake_count)
	_expect(is_equal_approx(review.camera_rig.distance_metres, ACCEPTED_CAMERA_DISTANCE)
			and is_equal_approx(review.camera_rig.pitch_degrees, ACCEPTED_CAMERA_PITCH)
			and is_equal_approx(review.camera_rig.fov_degrees, ACCEPTED_CAMERA_FOV),
		"the camera is not the accepted 19 m / 55 deg / 45 deg")
	_expect(is_equal_approx(review.player.max_speed, ACCEPTED_MAX_SPEED), "the player's speed moved")
	_expect(review.landing_layout == null and review.broken_watch == null,
		"a Riftfall Landing or Broken Watch layout was assembled")
	for index: int in review.room_modules.size():
		var spawns: Array[Vector3] = review.room_modules[index].spawn_points()
		for slot: int in review.room_enemies[index].size():
			var enemy: PrototypeGraveblade = review.room_enemies[index][slot]
			_expect(_planar_gap(enemy.global_position, spawns[slot]) < 0.5 and not enemy.ai_enabled
					and enemy.is_alive() and is_equal_approx(enemy.life, enemy.data.max_life),
				"%s is not inert, alive and at its own authored spawn in the Nexus" % enemy.name)

	## The review declares no assembly of its own, and overrides exactly nine
	## inherited methods, eight of them calling the accepted one.
	var review_source: String = FileAccess.get_file_as_string(REVIEW_SCRIPT)
	var declared: PackedStringArray = _declared_functions(review_source)
	var inherited: PackedStringArray = _declared_functions(FileAccess.get_file_as_string(ACCEPTED_RUNTIME_SCRIPT))
	inherited.append_array(_declared_functions(FileAccess.get_file_as_string(ACCEPTED_SLICE_SCRIPT)))
	var overrides: PackedStringArray = PackedStringArray()
	var reimplemented: PackedStringArray = PackedStringArray()
	for name: String in declared:
		if inherited.has(name):
			overrides.append(name)
		if ASSEMBLY_METHODS.has(name):
			reimplemented.append(name)
	overrides.sort()
	_expect(overrides == PackedStringArray(EXPECTED_OVERRIDES),
		"the review overrides %s" % ", ".join(overrides))
	_expect(reimplemented.is_empty(), "the review re-implements the accepted assembly: %s" % ", ".join(reimplemented))
	var calls_to_super: int = _bare(review_source).count("super(")
	_expect(calls_to_super == EXPECTED_OVERRIDES.size() - 1,
		"%d overrides call the accepted method, not %d" % [calls_to_super, EXPECTED_OVERRIDES.size() - 1])
	_expect(review.mote_marker_root != null and review.mote_marker_root.get_parent() == review,
		"the mote-marker root is not the review's own child")
	print("  inherited instance of %s; %d modules, route %s, Graveblades per room %s, 1 bake, camera %.0f m / %.0f deg / %.0f deg, speed %.1f m/s"
		% [ACCEPTED_SCENE.get_file(), review.all_modules.size(), ", ".join(ids), str(per_room),
			review.camera_rig.distance_metres, review.camera_rig.pitch_degrees, review.camera_rig.fov_degrees,
			review.player.max_speed])
	print("  %d overrides (%s), %d calling the accepted method; 0 of %d assembly methods re-implemented"
		% [overrides.size(), ", ".join(overrides), calls_to_super, ASSEMBLY_METHODS.size()])
	_done("the_review_is_isolated_and_reuses_the_accepted_assembly")


# --- 2. The InputMap, and F8 ----------------------------------------------------------

func _check_the_input_map_is_unchanged_and_f8_is_a_physical_key() -> void:
	print("")
	print("--- 2. The InputMap is unchanged and F8 is a physical review key")
	var actions: int = 0
	var suspicious: PackedStringArray = PackedStringArray()
	var f8_actions: PackedStringArray = PackedStringArray()
	for action: StringName in InputMap.get_actions():
		var name: String = String(action)
		if name.begins_with("ui_") and not name in ["ui_confirm", "ui_cancel"]:
			continue
		actions += 1
		for fragment: String in ["mote", "pickup", "experience"]:
			if name.contains(fragment):
				suspicious.append(name)
		for event: InputEvent in InputMap.action_get_events(action):
			var key: InputEventKey = event as InputEventKey
			if key != null and (key.physical_keycode == KEY_F8 or key.keycode == KEY_F8):
				f8_actions.append(name)
	_expect(actions == EXPECTED_ACTIONS, "the InputMap holds %d project actions, not %d" % [actions, EXPECTED_ACTIONS])
	_expect(suspicious.is_empty(), "an action names the review: %s" % ", ".join(suspicious))
	## F8 is already Prototype Zero's `toggle_slow_motion` key in the shared
	## InputMap. Nothing in this scene answers that action, so the review reads the
	## physical key exactly as the core loop reads F6 — and the clock never moves.
	_expect(f8_actions == PackedStringArray(["toggle_slow_motion"]),
		"F8 is bound to %s" % ", ".join(f8_actions))
	var started_on: bool = review.automatic_pickup
	await _press_key(KEY_F8)
	var after_first: bool = review.automatic_pickup
	await _press_key(KEY_F8)
	var after_second: bool = review.automatic_pickup
	_expect(started_on and not after_first and after_second,
		"F8 did not toggle automatic pickup ON -> OFF -> ON (%s, %s, %s)" % [started_on, after_first, after_second])
	_expect(is_equal_approx(Engine.time_scale, 1.0), "F8 changed the engine's time scale to %s" % Engine.time_scale)
	print("  %d actions; none names the review; F8 is bound only to %s, which nothing here answers; pickup ON -> %s -> %s by the physical key; time scale %.1f"
		% [actions, ", ".join(f8_actions), "ON" if after_first else "OFF", "ON" if after_second else "OFF", Engine.time_scale])
	_done("the_input_map_is_unchanged_and_f8_is_a_physical_key")


# --- 3. The Nexus -------------------------------------------------------------------------

func _check_the_nexus_holds_no_runtime() -> void:
	print("")
	print("--- 3. The Nexus holds no Experience Mote runtime")
	_expect(review.loop_state == RogueliteCoreLoopRuntime.LoopState.HUB, "the review did not start in the Nexus")
	_expect(review.plan.seed_value == ROUTE_SEED, "the route was launched with seed %d, not %d" % [review.plan.seed_value, ROUTE_SEED])
	_expect(review.mote_runtime == null and review.runtimes_created == 0, "an Experience Mote runtime exists in the Nexus")
	_expect(review.marker_count() == 0 and review.mote_marker_root.get_child_count() == 0 and review.observer_count() == 0,
		"a marker or observer exists in the Nexus")
	var shapes: PackedStringArray = _shapes()
	_expect(_all_shapes(shapes, "R"), "a Graveblade's death is heard by something other than the accepted room counter: %s" % str(shapes))
	var reading: Dictionary = review.experience_review_reading()
	_expect(not bool(reading["active"]) and String(reading["seed"]) == ROUTE_SEED_TEXT,
		"the Nexus reading is %s" % str(reading))
	_expect(_hud_text(HUD_LEVEL) == "No expedition in progress" and _hud_text(HUD_SEED) == "Next run seed %s" % ROUTE_SEED_TEXT
			and not _hud_visible(HUD_LEVEL_UP),
		"the Nexus panel reads '%s' / '%s'" % [_hud_text(HUD_SEED), _hud_text(HUD_LEVEL)])
	print("  runtime null, 0 created, 0 markers, 0 observers; every died reads %s; the panel reads '%s' and '%s'"
		% [shapes[0], _hud_text(HUD_SEED), _hud_text(HUD_LEVEL)])
	_done("the_nexus_holds_no_runtime")


# --- 4. One runtime, one seed, one binding each ---------------------------------------------

func _check_a_run_owns_one_runtime_of_its_exact_seed() -> void:
	print("")
	print("--- 4. Entering the Rift Gate makes one runtime of the expedition's exact seed and registers every Graveblade once")
	await _walk_into_gate(review.hub_module.exit_point())
	_expect(review.loop_state == RogueliteCoreLoopRuntime.LoopState.IN_RUN and review.run_state.current_room_index == 0,
		"entering the Rift Gate did not start the expedition in the Teaching Hall")
	_expect(review.runtimes_created == 1 and review.mote_runtime != null, "the expedition did not make exactly one runtime")
	_first_runtime = weakref(review.mote_runtime)
	_expect(review.run_state.plan == review.plan, "the expedition does not run on the plan it was entered with")
	_expect(review.mote_runtime.run_seed() == review.run_state.plan.seed_value and review.mote_runtime.run_seed() == ROUTE_SEED,
		"the runtime holds seed %d, not the expedition's %d" % [review.mote_runtime.run_seed(), review.run_state.plan.seed_value])
	var participants: int = 0
	var unregistered: PackedStringArray = PackedStringArray()
	for group: Array in review.room_enemies:
		for enemy: PrototypeGraveblade in group:
			participants += 1
			if not review.mote_runtime.is_registered(enemy) or review.mote_runtime.has_observed_death(enemy) \
					or not enemy.is_alive() or not is_equal_approx(enemy.life, enemy.data.max_life):
				unregistered.append(enemy.name)
	_expect(participants == EXPECTED_ROUTE_ENEMIES and review.mote_runtime.binding_count() == participants
			and review.registration_refusals == 0 and review.observer_count() == participants,
		"%d of %d route Graveblades registered (%d refused, %d observed)" % [
			review.mote_runtime.binding_count(), participants, review.registration_refusals, review.observer_count(),
		])
	_expect(unregistered.is_empty(), "not registered alive, at full Life and unheard: %s" % ", ".join(unregistered))
	## Exactly one binding each, and the order of each death's listeners is the
	## contract: the accepted room counter, then the binding H8 just connected, then
	## this review's observer.
	var shapes: PackedStringArray = _shapes()
	_expect(_all_shapes(shapes, "RBR"), "a Graveblade's died connections read %s, not RBR" % str(shapes))
	_expect(review.mote_runtime.level() == 1 and review.mote_runtime.experience() == 0.0
			and review.mote_runtime.drop_count() == 0 and not review.mote_runtime.is_offer_active(),
		"a new runtime is not at level 1 with 0 experience, 0 drops and no offer")
	_expect(_hud_text(HUD_SEED) == "Run seed %s" % ROUTE_SEED_TEXT and _hud_text(HUD_EXPERIENCE) == "XP 0 / %d" % LEVEL_ONE_REQUIREMENT
			and _hud_text(HUD_REGISTERED) == "Registered enemies %d" % EXPECTED_ROUTE_ENEMIES,
		"the panel reads '%s' / '%s' / '%s'" % [_hud_text(HUD_SEED), _hud_text(HUD_EXPERIENCE), _hud_text(HUD_REGISTERED)])
	print("  expedition seed %d = runtime seed %d, shown '%s'; %d of %d route Graveblades registered once, alive and unheard; every died reads %s; '%s'"
		% [review.run_state.plan.seed_value, review.mote_runtime.run_seed(), _hud_text(HUD_SEED),
			review.mote_runtime.binding_count(), participants, shapes[0], _hud_text(HUD_EXPERIENCE)])
	_done("a_run_owns_one_runtime_of_its_exact_seed")


# --- 5. Production experience ---------------------------------------------------------------

func _check_production_experience_is_untouched() -> void:
	print("")
	print("--- 5. Every production experience value is untouched; the review's 25.0 is its own")
	var ordinary: GravebladeData = load(ORDINARY_RECORD) as GravebladeData
	var elite: GravebladeData = load(ELITE_RECORD) as GravebladeData
	_expect(ordinary.experience_reward == PRODUCTION_EXPERIENCE_REWARD and elite.experience_reward == PRODUCTION_EXPERIENCE_REWARD,
		"a Graveblade record's own experience moved: %d / %d" % [ordinary.experience_reward, elite.experience_reward])
	var carried: PackedStringArray = PackedStringArray()
	for enemy: PrototypeGraveblade in review.graveblades:
		carried.append(str(enemy.data.experience_reward))
	_expect(carried == PackedStringArray(["10", "10", "10", "10", "10"]), "the actors carry %s" % ", ".join(carried))
	_expect(RogueliteExperienceCollectionReview.GREYBOX_REVIEW_BASE_EXPERIENCE == REVIEW_AMOUNT,
		"the review amount is %s, not %s" % [RogueliteExperienceCollectionReview.GREYBOX_REVIEW_BASE_EXPERIENCE, REVIEW_AMOUNT])
	var bare: String = _bare(FileAccess.get_file_as_string(REVIEW_SCRIPT))
	_expect(not bare.contains("experience_reward") and not bare.contains("GravebladeData"),
		"the review reads a Graveblade record's own experience")
	_expect(bare.count("register_graveblade(enemy, GREYBOX_REVIEW_BASE_EXPERIENCE)") == 1 and bare.count("25.0") == 1,
		"the one review amount is not the only amount every Graveblade is registered with")
	print("  both records still carry %d and the 5 actors %s; every registration uses the review's own %.1f — a provisional greybox review value"
		% [ordinary.experience_reward, ", ".join(carried), RogueliteExperienceCollectionReview.GREYBOX_REVIEW_BASE_EXPERIENCE])
	_done("production_experience_is_untouched")


# --- 6. Nonlethal hits --------------------------------------------------------------------------

func _check_nonlethal_hits_make_nothing() -> void:
	print("")
	print("--- 6. F8 turns pickup OFF; nonlethal hits make no mote, logical or visible")
	_quiet_room(0)
	await _set_pickup(false)
	var enemy: PrototypeGraveblade = review.room_enemies[0][0]
	enemy.place_at(_rounded(review.room_modules[0].room_centres()[0]))
	## Turned, through the actor's own `face_instantly()`, toward the west, where the
	## first evidence frame's player stands — as a Graveblade in play turns to face
	## the player it fights — so its corpse falls away from that player. Facing moves
	## no position and no mechanism. The escort in the second frame keeps its spawn
	## facing and falls away from the camera, so both relationships between a
	## corpse and its lifted orb stay on record (D-289).
	enemy.face_instantly(Vector3(-1.0, 0.0, 0.0))
	var lives: PackedStringArray = PackedStringArray([str(int(enemy.life))])
	for hit: int in 2:
		enemy.receive_damage(DamageEvent.physical(_use(), review.player, enemy, NONLETHAL_HIT))
		lives.append(str(int(enemy.life)))
	_expect(lives == PackedStringArray(["300", "200", "100"]) and enemy.is_alive(),
		"two hits of 100 took Life %s" % " -> ".join(lives))
	_expect(review.mote_runtime.drop_count() == 0 and review.marker_count() == 0
			and not review.mote_runtime.has_observed_death(enemy) and review.mote_runtime.experience() == 0.0,
		"a nonlethal hit made a drop, a marker, a heard death or experience")
	print("  Life %s; drops %d, markers %d, death heard %s, experience %s"
		% [" -> ".join(lives), review.mote_runtime.drop_count(), review.marker_count(),
			str(review.mote_runtime.has_observed_death(enemy)), str(review.mote_runtime.experience())])
	_done("nonlethal_hits_make_nothing")


# --- 7. The lethal hit ---------------------------------------------------------------------------

func _check_a_lethal_hit_makes_one_aligned_marker() -> void:
	print("")
	print("--- 7. A lethal hit makes exactly one drop and one marker where THAT Graveblade fell")
	var enemy: PrototypeGraveblade = review.room_enemies[0][0]
	var fell_at: Vector3 = enemy.global_position
	## The lethal event names an attacker and a target that are both far away, in
	## other rooms. Neither may redirect the marker.
	var far_source: PrototypeGraveblade = review.room_enemies[2][0]
	var far_target: PrototypeGraveblade = review.room_enemies[1][1]
	_kill(enemy, far_source, far_target)
	_expect(review.mote_runtime.drop_count() == 1 and review.marker_count() == 1 and review.markers_created == 1,
		"one death made %d drop(s) and %d marker(s)" % [review.mote_runtime.drop_count(), review.marker_count()])
	var at: Vector3 = review.marker_drop_position(0)
	_expect(at == fell_at, "the marker lies at %s, not where the Graveblade fell, %s" % [at, fell_at])
	## D-289: one entry on the complete death position; its ring on the same X/Z a
	## small fixed offset up; its orb on the same X/Z at the fixed review height.
	var ring: Vector3 = review.marker_ring_position(0)
	var orb: Vector3 = review.marker_orb_position(0)
	var ring_offset: float = RogueliteExperienceCollectionReview.MOTE_RING_FLOOR_OFFSET
	_expect(RogueliteExperienceCollectionReview.MOTE_ORB_REVIEW_HEIGHT == ORB_REVIEW_HEIGHT
			and ring_offset >= RING_OFFSET_MIN and ring_offset <= RING_OFFSET_MAX,
		"the orb's review height is %s and the ring's offset %s" % [
			RogueliteExperienceCollectionReview.MOTE_ORB_REVIEW_HEIGHT, ring_offset,
		])
	_expect(review.marker_node(0).global_position == fell_at,
		"the marker entry stands at %s, not on the complete death position %s" % [review.marker_node(0).global_position, fell_at])
	_expect(ring.x == fell_at.x and ring.z == fell_at.z
			and review.marker_ring_local_position(0) == Vector3(0.0, ring_offset, 0.0)
			and absf(ring.y - (fell_at.y + ring_offset)) < 0.000001,
		"the ring is at %s, not on the death position's X/Z %s raised %s" % [ring, fell_at, ring_offset])
	_expect(orb.x == fell_at.x and orb.z == fell_at.z
			and review.marker_orb_local_position(0) == Vector3(0.0, ORB_REVIEW_HEIGHT, 0.0)
			and absf(orb.y - (fell_at.y + ORB_REVIEW_HEIGHT)) < 0.000001,
		"the orb is at %s, not %s m straight above the death position %s" % [orb, ORB_REVIEW_HEIGHT, fell_at])
	var from_source: float = _planar_gap(at, far_source.global_position)
	var from_target: float = _planar_gap(at, far_target.global_position)
	_expect(from_source > 20.0 and from_target > 20.0,
		"the marker is %.2f m from the event's attacker and %.2f m from its target" % [from_source, from_target])
	_expect(review.mote_runtime.has_observed_death(enemy) and review.mote_runtime.emission_answer(enemy).is_empty(),
		"the binding did not hear the death and emit")
	_expect(review.mote_runtime.experience() == 0.0 and review.mote_runtime.uncollected_count() == 1
			and review.mote_runtime.collected_count() == 0 and review.mote_runtime.level() == 1,
		"a death awarded experience or collected its own drop")
	var node: Node3D = review.marker_node(0)
	var meshes: int = 0
	var physical: int = 0
	for child: Node in node.find_children("*", "", true, false):
		if child is MeshInstance3D:
			meshes += 1
			_expect_quiet((child as MeshInstance3D).cast_shadow == GeometryInstance3D.SHADOW_CASTING_SETTING_OFF,
				"a marker mesh casts a shadow")
		if child is CollisionObject3D or child is CollisionShape3D or child is GPUParticles3D or child is CPUParticles3D:
			physical += 1
	_expect(node.visible and meshes == 2 and physical == 0,
		"the marker is not a visible pair of meshes with no collision or particles (%d meshes, %d other)" % [meshes, physical])
	_expect(RogueliteExperienceCollectionReview.MOTE_RING_OUTER_RADIUS * 2.0 <= PLAYER_WIDTH
			and RogueliteExperienceCollectionReview.MOTE_ORB_REVIEW_HEIGHT + RogueliteExperienceCollectionReview.MOTE_ORB_RADIUS < PLAYER_HEIGHT,
		"a marker is larger than the player")
	_expect(review.run_state.is_cleared(0) and review.room_modules[0].exit_gate_open,
		"the accepted room counter did not count the same death")
	_expect(_hud_text(HUD_MOTES) == "Motes 1 total · 1 uncollected · 0 collected", "the panel reads '%s'" % _hud_text(HUD_MOTES))
	print("  1 drop, 1 marker at (%.2f, %.2f) where it fell; %.1f m from the event's attacker, %.1f m from its target; experience %s; 2 meshes, 0 collision; room cleared by the accepted counter"
		% [at.x, at.z, from_source, from_target, str(review.mote_runtime.experience())])
	print("  over the death position (%.3f, %.3f, %.3f): the ring at (%.3f, %.3f, %.3f) and the orb's centre at (%.3f, %.3f, %.3f) — its own X/Z, %.3f m and %.2f m straight above"
		% [fell_at.x, fell_at.y, fell_at.z, ring.x, ring.y, ring.z, orb.x, orb.y, orb.z, ring_offset, ORB_REVIEW_HEIGHT])
	_done("a_lethal_hit_makes_one_aligned_marker")


# --- 8. Pickup off --------------------------------------------------------------------------------

func _check_pickup_off_sweeps_nothing() -> void:
	print("")
	print("--- 8. Automatic pickup OFF performs no sweep, even standing on the mote")
	var mote: Vector3 = review.marker_drop_position(0)
	await _frame(mote + Vector3(-3.0, 0.0, 0.0), "01_uncollected_mote_pickup_off", DEATH_CLIP_SETTLE_SECONDS)
	var sweeps_before: int = review.sweeps_made
	_stand(mote)
	await _settle(8)
	await _await_process_frames(4)
	_expect(review.sweeps_made == sweeps_before, "%d sweep(s) ran with pickup OFF" % (review.sweeps_made - sweeps_before))
	_expect(review.mote_runtime.experience() == 0.0 and review.mote_runtime.uncollected_count() == 1
			and review.marker_is_shown(0) and not review.marker_is_collected(0),
		"standing on the mote with pickup OFF collected it")
	_expect(_hud_text(HUD_PICKUP) == "Automatic pickup OFF — F8 toggles", "the panel reads '%s'" % _hud_text(HUD_PICKUP))
	print("  %d sweeps while standing on the mote; experience %s; the marker is still shown; '%s'"
		% [review.sweeps_made - sweeps_before, str(review.mote_runtime.experience()), _hud_text(HUD_PICKUP)])
	_done("pickup_off_sweeps_nothing")


# --- 8a. The lifted orb does not follow anything ---------------------------------------

func _check_the_lifted_orb_is_fixed_against_the_player_and_camera() -> void:
	print("")
	print("--- 8a. The lifted orb and its ring stay put wherever the player stands and however the camera is set")
	var mote: Vector3 = review.marker_drop_position(0)
	var orb: Vector3 = review.marker_orb_position(0)
	var ring: Vector3 = review.marker_ring_position(0)
	var sweeps_before: int = review.sweeps_made
	var stances: Array[Vector3] = [
		Vector3(-3.0, 0.0, 0.0), Vector3(0.0, 0.0, 4.0), Vector3(5.0, 0.0, -5.0), Vector3(-6.0, 0.0, 6.0), Vector3.ZERO,
	]
	var followed: int = 0
	for offset: Vector3 in stances:
		_stand(mote + offset)
		await _settle(2)
		await _await_process_frames(2)
		if review.marker_orb_position(0) != orb or review.marker_ring_position(0) != ring:
			followed += 1
	var distance_before: float = review.camera_rig.distance_metres
	review.camera_rig.adjust_distance(6.0)
	await _await_process_frames(3)
	var zoomed_distance: float = review.camera_rig.distance_metres
	var zoomed_still: bool = review.marker_orb_position(0) == orb and review.marker_ring_position(0) == ring
	review.camera_rig.reset_calibration()
	await _await_process_frames(3)
	_expect(followed == 0, "the orb or ring moved at %d of %d player positions" % [followed, stances.size()])
	_expect(zoomed_still and not is_equal_approx(zoomed_distance, distance_before),
		"moving the camera from %.1f m to %.1f m moved the orb or ring" % [distance_before, zoomed_distance])
	_expect(is_equal_approx(review.camera_rig.distance_metres, ACCEPTED_CAMERA_DISTANCE) and review.sweeps_made == sweeps_before,
		"the camera was not restored, or a sweep ran with pickup OFF")
	print("  %d player positions and a camera moved %.1f m -> %.1f m and back: the orb stayed at (%.3f, %.3f, %.3f) and the ring at (%.3f, %.3f, %.3f)"
		% [stances.size(), distance_before, zoomed_distance, orb.x, orb.y, orb.z, ring.x, ring.y, ring.z])
	_done("the_lifted_orb_is_fixed_against_the_player_and_camera")


# --- 9. The inclusive boundary ---------------------------------------------------------------------

func _check_the_inclusive_boundary_decides_collection() -> void:
	print("")
	print("--- 9. Far and one float32 step outside leave the mote; the inclusive boundary collects it")
	var radius: float = RiftMotePickupQuery.BASE_PICKUP_RADIUS
	_expect(radius == 2.5, "H2's base radius is %s" % radius)
	var mote: Vector3 = review.marker_drop_position(0)
	var orb_before: Vector3 = review.marker_orb_position(0)
	_stand(Vector3(mote.x + 4.0, 0.0, mote.z))
	await _settle(2)
	var sweeps_before: int = review.sweeps_made
	await _set_pickup(true)
	await _settle(3)
	var far: RiftMoteSweepResult = review.last_sweep_result
	_expect(review.sweeps_made > sweeps_before and far != null and far.ok and far.attempted_count == 1
			and far.out_of_range_count == 1 and far.collected_count() == 0,
		"turning pickup ON 4 m away did not sweep and find the mote out of range")
	_expect(review.mote_runtime.experience() == 0.0 and review.marker_is_shown(0) and not review.marker_is_collected(0),
		"a far sweep collected the mote")

	var edge: Vector3 = Vector3(mote.x + radius, 0.0, mote.z)
	_expect(edge.x - mote.x == radius and edge.z == mote.z,
		"the boundary is not exactly %s m away in stored coordinates" % radius)
	## One float32 step outside the boundary on EACH of the four sides. With the exact
	## boundary collecting below, the accepted sweep outcomes alone pin the drop H7
	## made to the death position's X and Z in the engine's own stored coordinates —
	## with the orb lifted above it (D-289).
	var outside: Vector3 = Vector3(_beyond(edge.x, 1.0), 0.0, mote.z)
	var probes: Array[Vector3] = [
		outside,
		Vector3(_beyond(mote.x - radius, -1.0), 0.0, mote.z),
		Vector3(mote.x, 0.0, _beyond(mote.z + radius, 1.0)),
		Vector3(mote.x, 0.0, _beyond(mote.z - radius, -1.0)),
	]
	var refused_sides: int = 0
	for probe: Vector3 in probes:
		_stand(probe)
		await _settle(2)
		var beyond: RiftMoteSweepResult = review.last_sweep_result
		if review.last_sweep_position.x == probe.x and review.last_sweep_position.z == probe.z \
				and beyond.ok and beyond.out_of_range_count == 1 and beyond.collected_count() == 0 \
				and review.mote_runtime.experience() == 0.0 and not review.marker_is_collected(0):
			refused_sides += 1
	_expect(refused_sides == probes.size(),
		"only %d of %d sides one float32 step outside the boundary left the mote" % [refused_sides, probes.size()])

	_stand(edge)
	await _settle(2)
	## Every tick sweeps, so the sweep after this one already reports the drop as
	## skipped: the answer that matters is the one that COLLECTED, and where.
	var inside: RiftMoteSweepResult = review.last_collection_result
	_expect(review.collecting_sweeps == 1 and review.last_collection_position.x == edge.x
			and review.last_collection_position.z == edge.z,
		"%d sweep(s) collected, the last at %s — not one sweep on the boundary at %s" % [
			review.collecting_sweeps, review.last_collection_position, edge,
		])
	_expect(inside != null and inside.ok and inside.collected_indices() == PackedInt32Array([0])
			and review.mote_runtime.experience() == REVIEW_AMOUNT,
		"the inclusive boundary did not collect [0] paying %s: %s" % [REVIEW_AMOUNT, _describe(inside)])
	## The flash begins AT THE LIFTED ORB: collected, flashing, swelling in place, in
	## the flash colour, the orb exactly where it floated before (D-289).
	var orb_flashing: Vector3 = review.marker_orb_position(0)
	_expect(review.marker_is_collected(0) and review.marker_is_flashing(0) and orb_flashing == orb_before
			and review.marker_orb_scale(0) > 1.0
			and _rgb(review.marker_orb_colour(0)) == _rgb(RogueliteExperienceCollectionReview.MOTE_FLASH_COLOUR),
		"the flash did not begin at the lifted orb (orb %s -> %s, scale %.3f)" % [orb_before, orb_flashing, review.marker_orb_scale(0)])
	## The 0.32 s flash is presentation only: the drop is already collected and paid,
	## and the panel already says so, while the marker is still flashing.
	_expect(RogueliteExperienceCollectionReview.COLLECTION_FLASH_SECONDS == FLASH_SECONDS and review.marker_is_flashing(0)
			and review.mote_runtime.collected_count() == 1 and review.mote_runtime.experience() == REVIEW_AMOUNT
			and _hud_text(HUD_EXPERIENCE) == "XP 25 / %d" % LEVEL_ONE_REQUIREMENT,
		"collection or its award waited for the flash")
	## Pickup is measured to the logical GROUND position, never to the lifted orb: the
	## collecting sweep stood exactly the radius from the drop on the ground plane,
	## and further than the radius from the orb's centre in space.
	var on_ground: float = _planar_gap(review.last_collection_position, review.marker_drop_position(0))
	var to_orb: float = review.last_collection_position.distance_to(orb_flashing)
	_expect(on_ground == radius and to_orb > radius,
		"the collecting sweep stood %.4f m from the drop on the ground and %.4f m from the orb" % [on_ground, to_orb])
	if inside != null:
		_collected_sequence.append(str(inside.collected_indices()))
	_experience_steps.append(review.mote_runtime.experience())
	await _await_flash()
	_expect(not review.marker_is_shown(0) and not review.marker_is_flashing(0), "the collected marker did not flash and hide")
	_expect(_hud_text(HUD_EXPERIENCE) == "XP 25 / %d" % LEVEL_ONE_REQUIREMENT, "the panel reads '%s'" % _hud_text(HUD_EXPERIENCE))
	print("  4 m away: attempted 1, out of range 1; %.7f m (one float32 step outside): out of range, experience 0.0; exactly %.1f m: collected %s, experience %s; the marker flashed and hid; '%s'"
		% [outside.x - mote.x, edge.x - mote.x, str(_indices(inside)), str(review.mote_runtime.experience()),
			_hud_text(HUD_EXPERIENCE)])
	print("  %d of %d sides one float32 step outside refused; the flash began at the lifted orb (%.3f, %.3f, %.3f) with the drop already collected and 25.0 already paid; the collecting sweep stood %.4f m from the drop on the ground and %.2f m from the orb"
		% [refused_sides, probes.size(), orb_flashing.x, orb_flashing.y, orb_flashing.z, on_ground, to_orb])
	_done("the_inclusive_boundary_decides_collection")


# --- 10. Never twice -------------------------------------------------------------------------------

func _check_a_collected_marker_never_returns() -> void:
	print("")
	print("--- 10. A collected mote is skipped forever, and its marker never returns")
	var experience: float = review.mote_runtime.experience()
	var collected_before: int = review.markers_collected
	await _settle(6)
	await _await_process_frames(4)
	var again: RiftMoteSweepResult = review.last_sweep_result
	_expect(again.ok and again.skipped_count == 1 and again.attempted_count == 0 and again.collected_count() == 0,
		"a later sweep did not skip the collected drop: %s" % again.describe())
	_expect(review.mote_runtime.experience() == experience and review.markers_collected == collected_before
			and review.mirror_refusals == 0 and review.collecting_sweeps == 1,
		"standing on a collected mote paid, collected or hid again")
	_expect(review.marker_is_collected(0) and not review.marker_is_shown(0) and not review.marker_is_flashing(0),
		"the collected marker reappeared")
	print("  a later sweep skipped %d and attempted %d; experience stayed %s; the marker stayed hidden"
		% [again.skipped_count, again.attempted_count, str(review.mote_runtime.experience())])
	_done("a_collected_marker_never_returns")


# --- 11. Death order ----------------------------------------------------------------------------------

func _check_death_order_indexing_hides_only_the_collected_marker() -> void:
	print("")
	print("--- 11. Two deaths in reverse order keep death-order indices; each collected index hides only its own marker")
	await _walk_into_gate(review.room_modules[0].exit_point())
	_expect(review.run_state.current_room_index == 1, "the Teaching Hall's gate did not lead to the Cache Room")
	_quiet_room(1)
	await _set_pickup(false)
	var centre: Vector3 = _rounded(review.room_modules[1].room_centres()[0])
	var first: PrototypeGraveblade = review.room_enemies[1][0]
	var second: PrototypeGraveblade = review.room_enemies[1][1]
	first.place_at(centre - Vector3(5.0, 0.0, 0.0))
	second.place_at(centre + Vector3(5.0, 0.0, 0.0))
	## The second-registered Graveblade dies first.
	_kill(second)
	_kill(first)
	_expect(review.mote_runtime.drop_count() == 3 and review.marker_count() == 3,
		"two more deaths made %d drops and %d markers" % [review.mote_runtime.drop_count(), review.marker_count()])
	_expect(review.marker_drop_position(1) == second.global_position and review.marker_drop_position(2) == first.global_position,
		"the markers are not in death order")

	_stand(review.marker_drop_position(2))
	await _set_pickup(true)
	await _settle(2)
	var one: RiftMoteSweepResult = review.last_collection_result
	_expect(review.collecting_sweeps == 2 and one != null and one.ok and one.collected_indices() == PackedInt32Array([2])
			and one.skipped_count == 1 and one.attempted_count == 2 and one.out_of_range_count == 1,
		"standing where the first-registered fell did not collect exactly [2] in one sweep: %s" % _describe(one))
	_collected_sequence.append(str(_indices(one)))
	_expect(review.marker_is_collected(2) and not review.marker_is_collected(1) and review.marker_is_shown(1)
			and review.marker_is_collected(0) and not review.marker_is_shown(0),
		"collecting [2] hid a marker other than marker 2")
	_experience_steps.append(review.mote_runtime.experience())

	_stand(review.marker_drop_position(1))
	await _settle(2)
	var two: RiftMoteSweepResult = review.last_collection_result
	_expect(review.collecting_sweeps == 3 and two != null and two.ok and two.collected_indices() == PackedInt32Array([1])
			and two.skipped_count == 2 and two.attempted_count == 1,
		"standing where the second-registered fell did not collect exactly [1] in one sweep: %s" % _describe(two))
	_collected_sequence.append(str(_indices(two)))
	_expect(review.marker_is_collected(1) and review.marker_drop_position(1) == second.global_position
			and review.marker_drop_position(2) == first.global_position,
		"collecting reordered the markers")
	_expect(review.mote_runtime.experience() == 3.0 * REVIEW_AMOUNT, "the Cache Room left experience at %s" % review.mote_runtime.experience())
	_experience_steps.append(review.mote_runtime.experience())
	print("  killed %s then %s: markers 1 and 2 at their own falls; a sweep at 2 collected %s (skipped %d, out of range %d) and left marker 1 shown; then %s; experience %s"
		% [second.name, first.name, str(one.collected_indices()), one.skipped_count, one.out_of_range_count,
			str(two.collected_indices()), str(review.mote_runtime.experience())])
	_done("death_order_indexing_hides_only_the_collected_marker")


# --- 12. One hundred -------------------------------------------------------------------------------

func _check_four_motes_reach_the_requirement_and_nothing_opens() -> void:
	print("")
	print("--- 12. The fourth 25-XP mote reaches G1's 100 exactly; Level 1 stands, nothing opens, LEVEL-UP READY shows")
	await _walk_into_gate(review.room_modules[1].exit_point())
	_expect(review.run_state.current_room_index == 2, "the Cache Room's gate did not lead to the Elite Hall")
	_quiet_room(2)
	await _set_pickup(false)
	var centre: Vector3 = _rounded(review.room_modules[2].room_centres()[0])
	var elite: PrototypeGraveblade = review.room_enemies[2][0]
	var escort: PrototypeGraveblade = review.room_enemies[2][1]
	elite.place_at(centre - Vector3(4.0, 0.0, 0.0))
	escort.place_at(centre + Vector3(4.0, 0.0, 0.0))
	_kill(elite)
	_kill(escort)
	_expect(review.mote_runtime.drop_count() == EXPECTED_ROUTE_ENEMIES and review.marker_count() == EXPECTED_ROUTE_ENEMIES,
		"the fixed route made %d drops and %d markers, not %d" % [
			review.mote_runtime.drop_count(), review.marker_count(), EXPECTED_ROUTE_ENEMIES,
		])
	var surfaces_before: int = review.get_node("CanvasLayer").get_child_count()

	## The Elite's corpse and every ordinary corpse get the same marker: each orb and
	## ring sits at exactly the same offset from its own logical death position.
	var orb_offset: Vector3 = review.marker_orb_position(0) - review.marker_drop_position(0)
	var ring_offset: Vector3 = review.marker_ring_position(0) - review.marker_drop_position(0)
	var differing: PackedStringArray = PackedStringArray()
	for index: int in review.marker_count():
		if review.marker_orb_position(index) - review.marker_drop_position(index) != orb_offset \
				or review.marker_ring_position(index) - review.marker_drop_position(index) != ring_offset:
			differing.append(str(index))
	_expect(differing.is_empty() and elite.data.max_life == 600.0 and escort.data.max_life == 300.0,
		"markers %s sit at a different offset from their death positions" % ", ".join(differing))
	_expect(orb_offset.x == 0.0 and orb_offset.z == 0.0 and absf(orb_offset.y - ORB_REVIEW_HEIGHT) < 0.000001
			and ring_offset.x == 0.0 and ring_offset.z == 0.0
			and absf(ring_offset.y - RogueliteExperienceCollectionReview.MOTE_RING_FLOOR_OFFSET) < 0.000001,
		"the shared offsets are orb %s and ring %s" % [orb_offset, ring_offset])

	_stand(review.marker_drop_position(3))
	await _set_pickup(true)
	await _settle(2)
	var fourth: RiftMoteSweepResult = review.last_collection_result
	_expect(review.collecting_sweeps == 4 and fourth != null and fourth.ok and fourth.collected_indices() == PackedInt32Array([3]),
		"standing where the Elite fell did not collect [3] in one sweep: %s" % _describe(fourth))
	_collected_sequence.append(str(_indices(fourth)))
	_experience_steps.append(review.mote_runtime.experience())
	var g1: RiftLevelRequirementReading = RiftLevelRequirementCurve.requirement_for(1)
	_expect(g1.ok and g1.requirement == LEVEL_ONE_REQUIREMENT, "G1 answers %s for Level 1" % g1.describe())
	_expect(_experience_steps == [25.0, 50.0, 75.0, 100.0], "four motes paid %s" % str(_experience_steps))
	_expect(review.mote_runtime.experience() == float(g1.requirement), "experience %s is not G1's %d" % [
		review.mote_runtime.experience(), g1.requirement,
	])
	_expect_nothing_opened(surfaces_before, "at 100")
	var reading: Dictionary = review.experience_review_reading()
	_expect(bool(reading["level_up_ready"]) and int(reading["requirement"]) == g1.requirement and bool(reading["requirement_ok"]),
		"the reading at 100 is %s" % str(reading))
	_expect(_hud_text(HUD_EXPERIENCE) == "XP 100 / 100" and _hud_visible(HUD_LEVEL_UP) and _hud_text(HUD_LEVEL_UP) == LEVEL_UP_TEXT
			and _hud_visible(HUD_LEVEL_UP_NOTE) and _hud_text(HUD_LEVEL_UP_NOTE) == LEVEL_UP_NOTE,
		"the panel at 100 reads '%s' with level-up %s" % [_hud_text(HUD_EXPERIENCE), str(_hud_visible(HUD_LEVEL_UP))])
	await _await_flash()
	await _frame(review.marker_drop_position(3), "02_level_up_ready", DEATH_CLIP_SETTLE_SECONDS)
	print("  experience %s after four motes; G1's Level 1 requirement %d; level %d; offer %s; paused %s; '%s' + '%s'"
		% [str(_experience_steps), g1.requirement, review.mote_runtime.level(), str(review.mote_runtime.is_offer_active()),
			str(get_tree().paused), _hud_text(HUD_EXPERIENCE), _hud_text(HUD_LEVEL_UP)])
	print("  %d markers — 4 ordinary Graveblades and the 600-Life Elite — each draw the orb %s and the ring %s from their own death position"
		% [review.marker_count(), _offset_text(orb_offset), _offset_text(ring_offset)])
	_done("four_motes_reach_the_requirement_and_nothing_opens")


# --- 13. The review panel on screen -------------------------------------------------------------------

func _check_the_review_surface_is_legible_and_unobstructed() -> void:
	print("")
	print("--- 13. The review panel is on screen, clear of every other surface and the centre, and beneath every modal")
	await _await_process_frames(4)
	var viewport: Rect2 = Rect2(Vector2.ZERO, Vector2(get_viewport().get_visible_rect().size))
	var controls: Array[Label] = review.experience_hud.text_controls()
	var shown: int = _measure_text(controls, viewport, "review panel")
	_expect(shown == controls.size(), "%d of %d review-panel lines are visible on screen" % [shown, controls.size()])
	var mine: Rect2 = review.experience_hud.panel.get_global_rect()
	_expect(viewport.encloses(mine), "the review panel %s leaves the viewport %s" % [mine, viewport])
	var centre: Rect2 = Rect2(viewport.size * 0.25, viewport.size * 0.5)
	_expect(not mine.intersects(centre), "the review panel %s covers the central combat view %s" % [mine, centre])
	_expect(mine.position.y > viewport.size.y * 0.5, "the review panel reaches the upper half of the screen")
	var smallest: int = 999
	for label: Label in controls:
		smallest = mini(smallest, label.get_theme_font_size("font_size"))
	_expect(smallest >= 12, "a review-panel line is drawn at %d px" % smallest)

	## Every other surface, with its transient parts forced visible while a modal
	## holds the world still so nothing per-frame can hide them again.
	var overlay: RogueliteFallenOverlay = review.fallen_overlay as RogueliteFallenOverlay
	overlay.open_for(DamageEvent.physical(_use(), review.graveblades[0], review.player, 125.0))
	review.run_hud.show_gate_prompt("Rift Gate sealed — clear the room", false)
	review.hud.show_item_prompt("Expedition Blade — Left click")
	review.hud.show_message("Elite Hall — A heavier Graveblade, and one escort.")
	await _await_process_frames(4)
	var measured: int = 0
	var overlaps: PackedStringArray = PackedStringArray()
	for surface: Control in [review.hud, review.run_hud]:
		for child: Node in surface.get_children():
			var control: Control = child as Control
			if control == null or not control.is_visible_in_tree():
				continue
			measured += 1
			if control.get_global_rect().intersects(mine):
				overlaps.append("%s/%s" % [surface.name, control.get_class()])
	for control: Control in overlay.text_controls():
		if control.is_visible_in_tree():
			measured += 1
			if control.get_global_rect().intersects(mine):
				overlaps.append("Fallen/%s" % control.name)
	var layer: Node = review.experience_hud.get_parent()
	var index: int = review.experience_hud.get_index()
	var beneath: int = 0
	for modal: Control in [review.item_comparison, review.fallen_overlay, review.summary_panel]:
		if modal.get_parent() == layer and modal.get_index() > index:
			beneath += 1
	overlay.close("verification")
	review.run_hud.show_gate_prompt("", false)
	review.hud.show_item_prompt("")
	await _await_process_frames(2)

	review.summary_panel.open_for(review.run_state)
	await _await_process_frames(4)
	for control: Control in review.summary_panel.text_controls():
		if control.is_visible_in_tree():
			measured += 1
			if control.get_global_rect().intersects(mine):
				overlaps.append("Summary/%s" % control.name)
	review.summary_panel.close("verification")
	await _await_process_frames(2)

	_expect(measured >= 15, "only %d other surfaces were measured" % measured)
	_expect(overlaps.is_empty(), "the review panel overlaps: %s" % ", ".join(overlaps))
	_expect(layer == review.run_hud.get_parent() and index == review.run_hud.get_index() + 1 and beneath == 3,
		"the review panel is not directly after the run banner and beneath all 3 modals (%d)" % beneath)
	_expect(not get_tree().paused and not review.fallen_overlay.is_open and not review.summary_panel.is_open,
		"a measured modal was left open")
	print("  panel %s in a %s viewport; %d of %d lines visible, smallest %d px; %d other surface rectangles measured, %d overlapping; beneath %d of 3 modals"
		% [mine, viewport.size, shown, controls.size(), smallest, measured, overlaps.size(), beneath])
	_done("the_review_surface_is_legible_and_unobstructed")


# --- 14. One hundred and twenty-five --------------------------------------------------------------------

func _check_a_fifth_mote_still_opens_nothing() -> void:
	print("")
	print("--- 14. The fifth fixed-route mote reaches 125; still Level 1, still nothing opens")
	var surfaces_before: int = review.get_node("CanvasLayer").get_child_count()
	_stand(review.marker_drop_position(4))
	await _settle(2)
	var fifth: RiftMoteSweepResult = review.last_collection_result
	_expect(review.collecting_sweeps == 5 and fifth != null and fifth.ok and fifth.collected_indices() == PackedInt32Array([4]),
		"standing where the escort fell did not collect [4] in one sweep: %s" % _describe(fifth))
	_collected_sequence.append(str(_indices(fifth)))
	## Lifting the orb changed no sweep answer: the collected indices, sweep by sweep,
	## are the death-order indices D-288 measured before it moved.
	_expect(_sequence_text() == EXPECTED_COLLECTED_SEQUENCE,
		"the sweeps collected %s, not %s" % [_sequence_text(), EXPECTED_COLLECTED_SEQUENCE])
	_expect(review.mote_runtime.experience() == float(EXPECTED_ROUTE_ENEMIES) * REVIEW_AMOUNT,
		"five motes left experience at %s" % review.mote_runtime.experience())
	_expect(review.mote_runtime.uncollected_count() == 0 and review.mote_runtime.collected_count() == EXPECTED_ROUTE_ENEMIES,
		"not every route mote is collected")
	_expect_nothing_opened(surfaces_before, "at 125")
	_expect(_hud_text(HUD_EXPERIENCE) == "XP 125 / 100" and _hud_visible(HUD_LEVEL_UP),
		"the panel at 125 reads '%s'" % _hud_text(HUD_EXPERIENCE))
	print("  %d route Graveblades -> maximum review experience %s; level %d; offer %s; '%s'; LEVEL-UP READY still shown"
		% [EXPECTED_ROUTE_ENEMIES, str(review.mote_runtime.experience()), review.mote_runtime.level(),
			str(review.mote_runtime.is_offer_active()), _hud_text(HUD_EXPERIENCE)])
	print("  the five collecting sweeps answered %s — the indices D-288 measured before the orb was lifted"
		% _sequence_text())
	_done("a_fifth_mote_still_opens_nothing")


# --- 15. Completion ----------------------------------------------------------------------------------------

func _check_completion_tears_everything_down() -> void:
	print("")
	print("--- 15. Completing the expedition discards the runtime, every binding, observer and marker")
	await _walk_into_gate(review.room_modules[2].exit_point())
	_expect(review.loop_state == RogueliteCoreLoopRuntime.LoopState.RUN_COMPLETE and review.summary_panel.is_open,
		"the Elite Hall's gate did not complete the expedition")
	_expect_torn_down(_first_runtime, 1, "completion")
	var revived: int = 0
	for enemy: PrototypeGraveblade in review.graveblades:
		if enemy.is_alive() and is_equal_approx(enemy.life, enemy.data.max_life):
			revived += 1
	_expect(revived == EXPECTED_ROUTE_ENEMIES, "the accepted reset revived %d of %d Graveblades" % [revived, EXPECTED_ROUTE_ENEMIES])
	review.summary_panel.close("verification")
	await _await_process_frames(2)
	print("  runtime null and freed; 0 markers, 0 marker nodes, 0 observers; every died reads %s; %d of %d Graveblades revived by the accepted reset; '%s'"
		% [_shapes()[0], revived, EXPECTED_ROUTE_ENEMIES, _hud_text(HUD_LEVEL)])
	_done("completion_tears_everything_down")


# --- 16. A second expedition ----------------------------------------------------------------------------

func _check_a_new_run_binds_afresh_and_old_callbacks_stay_silent() -> void:
	print("")
	print("--- 16. The next expedition makes a new runtime with fresh bindings; the same revived Graveblades emit again, once")
	var next_seed: int = review.plan.seed_value
	_expect(next_seed != ROUTE_SEED, "the completed expedition's seed was reused")
	await _walk_into_gate(review.hub_module.exit_point())
	_expect(review.loop_state == RogueliteCoreLoopRuntime.LoopState.IN_RUN and review.runtimes_created == 2
			and review.mote_runtime != null and _first_runtime.get_ref() == null,
		"the second expedition did not make a second runtime")
	_second_runtime = weakref(review.mote_runtime)
	_expect(review.mote_runtime.run_seed() == next_seed and review.run_state.plan.seed_value == next_seed,
		"the second runtime holds seed %d, not the expedition's %d" % [review.mote_runtime.run_seed(), next_seed])
	_expect(review.mote_runtime.binding_count() == EXPECTED_ROUTE_ENEMIES and review.observer_count() == EXPECTED_ROUTE_ENEMIES
			and review.mote_runtime.experience() == 0.0 and review.mote_runtime.drop_count() == 0
			and review.mote_runtime.level() == 1 and review.marker_count() == 0
			and review.mote_marker_root.get_child_count() == 0,
		"the second runtime did not begin fresh")
	var shapes: PackedStringArray = _shapes()
	_expect(_all_shapes(shapes, "RBR"), "a Graveblade's died connections read %s after a second registration" % str(shapes))
	var seed_text: String = RogueliteExperienceCollectionReview.seed_presentation(next_seed)
	_expect(_hud_text(HUD_SEED) == "Run seed %s" % seed_text and _hud_text(HUD_EXPERIENCE) == "XP 0 / %d" % LEVEL_ONE_REQUIREMENT
			and not _hud_visible(HUD_LEVEL_UP),
		"the second expedition's panel reads '%s' / '%s'" % [_hud_text(HUD_SEED), _hud_text(HUD_EXPERIENCE)])
	await _frame(review.room_modules[0].entry_point(), "03_fresh_second_run")

	_quiet_room(0)
	var enemy: PrototypeGraveblade = review.room_enemies[0][0]
	_expect(_planar_gap(enemy.global_position, review.room_modules[0].spawn_points()[0]) < 0.5,
		"the revived Graveblade is not back at its own spawn")
	var fell_at: Vector3 = enemy.global_position
	_kill(enemy)
	_expect(review.mote_runtime.drop_count() == 1 and review.marker_count() == 1 and review.marker_drop_position(0) == fell_at,
		"the revived Graveblade's second death made %d drop(s) and %d marker(s)" % [
			review.mote_runtime.drop_count(), review.marker_count(),
		])
	_expect(review.stale_callbacks_refused == 0 and review.mirror_refusals == 0 and review.markers_created == EXPECTED_ROUTE_ENEMIES + 1,
		"an old callback fired or a mirror refused (%d stale, %d mirror, %d markers made)" % [
			review.stale_callbacks_refused, review.mirror_refusals, review.markers_created,
		])
	print("  seed %d shown '%s'; the first runtime is freed; %d fresh bindings; every died reads %s; the revived Teaching Hall Graveblade's death made 1 drop and 1 marker; 0 stale callbacks"
		% [next_seed, _hud_text(HUD_SEED), review.mote_runtime.binding_count(), shapes[0]])
	_done("a_new_run_binds_afresh_and_old_callbacks_stay_silent")


# --- 17. Refusals are shown --------------------------------------------------------------------------------

func _check_refusals_are_shown_not_hidden() -> void:
	print("")
	print("--- 17. A refused sweep and an index no marker mirrors are shown, and hide nothing")
	var experience: float = review.mote_runtime.experience()
	var collected_before: int = review.markers_collected
	var refused: RiftMoteSweepResult = RiftMoteSweepResult.refused("verification: a whole sweep refused", 1)
	_expect(refused.problem().is_empty(), "the refused value is not coherent: %s" % refused.problem())
	review._present_sweep(refused)
	_expect(review.last_refusal == "sweep refused — verification: a whole sweep refused"
			and _hud_text(HUD_REFUSAL) == "Last refusal: sweep refused — verification: a whole sweep refused",
		"a refused sweep reads '%s' on the panel" % _hud_text(HUD_REFUSAL))
	_expect(review.marker_is_shown(0) and not review.marker_is_collected(0) and review.whole_sweep_refusals == 1,
		"a refused sweep hid a marker")
	var beyond: RiftMoteSweepResult = RiftMoteSweepResult.completed(6, 0, 6, PackedInt32Array([5]), 4, 1, "verification: one mote refused")
	_expect(beyond.problem().is_empty(), "the completed value is not coherent: %s" % beyond.problem())
	review._present_sweep(beyond)
	_expect(review.mirror_refusals == 1 and review.item_refusals_seen == 1
			and review.last_refusal.begins_with("no marker hidden — the sweep collected drop 5"),
		"an index no marker mirrors reads '%s'" % review.last_refusal)
	_expect(review.marker_is_shown(0) and not review.marker_is_collected(0) and review.markers_collected == collected_before
			and review.mote_runtime.experience() == experience,
		"an index no marker mirrors hid a marker or moved experience")
	print("  '%s'; then an answer collecting drop 5 of 1 marker: 1 mirror refusal, 0 markers hidden, experience %s"
		% [_hud_text(HUD_REFUSAL), str(review.mote_runtime.experience())])
	_done("refusals_are_shown_not_hidden")


# --- 17a. A mote left behind ---------------------------------------------------------------------------------

func _check_a_mote_left_behind_stays_until_teardown() -> void:
	print("")
	print("--- 17a. A mote left behind by a room transition stays uncollected, unawarded, marked and counted until teardown")
	var mote: Vector3 = review.marker_drop_position(0)
	var orb: Vector3 = review.marker_orb_position(0)
	var experience: float = review.mote_runtime.experience()
	var collections: int = review.collecting_sweeps
	_expect(review.marker_count() == 1 and not review.marker_is_collected(0) and review.automatic_pickup
			and review.run_state.is_cleared(0),
		"the Teaching Hall is not cleared with one uncollected mote and pickup ON")
	await _walk_into_gate(review.room_modules[0].exit_point())
	_quiet_room(1)
	var sweeps_before: int = review.sweeps_made
	await _settle(6)
	var away: float = _planar_gap(review.player.global_position, mote)
	var answer: RiftMoteSweepResult = review.last_sweep_result
	_expect(review.run_state.current_room_index == 1 and away > 20.0,
		"the player did not pass into the Cache Room, far from the mote (%.1f m)" % away)
	_expect(review.sweeps_made > sweeps_before and answer != null and answer.ok and answer.attempted_count == 1
			and answer.out_of_range_count == 1 and answer.collected_count() == 0,
		"the sweeps in the next room did not keep attempting the left-behind drop and find it out of range: %s" % _describe(answer))
	_expect(review.mote_runtime.drop_count() == 1 and review.mote_runtime.uncollected_count() == 1
			and review.mote_runtime.experience() == experience and review.collecting_sweeps == collections,
		"leaving the room collected, removed or paid the mote")
	_expect(review.marker_count() == 1 and review.marker_is_shown(0) and not review.marker_is_collected(0)
			and review.marker_drop_position(0) == mote and review.marker_orb_position(0) == orb
			and review.marker_node(0).get_parent() == review.mote_marker_root,
		"the left-behind marker moved, hid or left the Teaching Hall")
	_expect(_hud_text(HUD_MOTES) == "Motes 1 total · 1 uncollected · 0 collected",
		"the panel reads '%s' after leaving the mote behind" % _hud_text(HUD_MOTES))
	print("  through the Teaching Hall's gate into the Cache Room, %.1f m away: drop 0 still attempted, out of range and uncollected at its index; experience %s; its marker still shown where it fell; '%s'"
		% [away, str(review.mote_runtime.experience()), _hud_text(HUD_MOTES)])
	_done("a_mote_left_behind_stays_until_teardown")


# --- 18. F5 ------------------------------------------------------------------------------------------------------

func _check_abandoning_tears_everything_down() -> void:
	print("")
	print("--- 18. F5 abandons the expedition and discards everything it owned")
	## The Teaching Hall mote left behind in 17a is still here, unreachable, until now.
	var left_behind: Node3D = review.marker_node(0)
	await _press_key(KEY_F5)
	await _settle(4)
	_expect(review.loop_state == RogueliteCoreLoopRuntime.LoopState.HUB, "F5 did not return to the Nexus")
	_expect_torn_down(_second_runtime, 2, "F5")
	_expect(not is_instance_valid(left_behind), "the left-behind mote's marker survived the teardown")
	_expect(review.player.is_alive() and _planar_gap(review.player.global_position, review.hub_module.entry_point()) < 0.6,
		"F5 did not return the player to the Nexus entry")
	print("  runtime null and freed; 0 markers, 0 marker nodes, 0 observers; every died reads %s; last refusal cleared; '%s'"
		% [_shapes()[0], _hud_text(HUD_LEVEL)])
	_done("abandoning_tears_everything_down")


# --- 19. Death ---------------------------------------------------------------------------------------------------

func _check_death_tears_everything_down() -> void:
	print("")
	print("--- 19. A fallen player sweeps nothing, and returning from Fallen discards everything")
	await _walk_into_gate(review.hub_module.exit_point())
	_expect(review.runtimes_created == 3 and review.mote_runtime != null and _second_runtime.get_ref() == null,
		"the third expedition did not make a third runtime")
	_third_runtime = weakref(review.mote_runtime)
	_expect(review.mote_runtime.drop_count() == 0 and review.mote_runtime.experience() == 0.0
			and review.marker_count() == 0 and review.mote_marker_root.get_child_count() == 0,
		"the run after F5 did not begin with zero logical and zero visual motes")
	_quiet_room(0)
	var enemy: PrototypeGraveblade = review.room_enemies[0][0]
	_kill(enemy)
	await _set_pickup(true)
	var mote: Vector3 = review.marker_drop_position(0)
	## Standing on the mote and falling happen in the same step, so no sweep can
	## have run between them.
	_stand(mote)
	var sweeps_before: int = review.sweeps_made
	var collections_before: int = review.collecting_sweeps
	review.player.receive_damage(DamageEvent.physical(_use(), enemy, review.player, review.player.max_life + 999.0))
	_expect(not review.player.is_alive(), "the player did not fall")
	for frame: int in 150:
		if review.fallen_overlay.is_open:
			break
		await get_tree().physics_frame
	_expect(review.fallen_overlay.is_open, "the Fallen overlay did not open")
	_expect(review.sweeps_made == sweeps_before and review.mote_runtime.uncollected_count() == 1
			and review.mote_runtime.experience() == 0.0,
		"a fallen player swept %d time(s)" % (review.sweeps_made - sweeps_before))
	## The pending mote and its experience stay exactly as they were until the
	## accepted teardown — nothing collects, pays, hides or discards them early.
	_expect(review.mote_runtime != null and review.mote_runtime.drop_count() == 1 and review.collecting_sweeps == collections_before
			and review.marker_count() == 1 and review.marker_is_shown(0) and not review.marker_is_collected(0),
		"the pending mote, its marker or the runtime changed before the accepted teardown")
	review.fallen_overlay._on_restart()
	await _settle(6)
	_expect(review.loop_state == RogueliteCoreLoopRuntime.LoopState.HUB and not get_tree().paused,
		"returning from Fallen did not reach the Nexus")
	_expect_torn_down(_third_runtime, 3, "death")
	_expect(review.player.is_alive() and is_equal_approx(review.player.life, review.player.max_life),
		"the player is not back at full Life")
	print("  0 sweeps while fallen on the mote; the mote stayed uncollected; Fallen's return discarded the runtime (freed), every marker and observer; every died reads %s"
		% _shapes()[0])
	_done("death_tears_everything_down")


# --- 20. Structure ----------------------------------------------------------------------------------------------

func _check_the_review_restates_no_mechanism_and_writes_nothing() -> void:
	print("")
	print("--- 20. The review restates no mechanism, names only what it composes, and writes nothing")
	var raw: String = FileAccess.get_file_as_string(REVIEW_SCRIPT)
	var bare: String = _bare(raw)
	var hud_raw: String = FileAccess.get_file_as_string(HUD_SCRIPT)
	var hud_bare: String = _bare(hud_raw)
	var scene_raw: String = FileAccess.get_file_as_string(REVIEW_SCENE_FILE)
	_expect(raw.length() > 1000 and hud_raw.length() > 1000 and scene_raw.length() > 100, "a review file could not be read")
	var foundation_constructions: int = RegEx.create_from_string("Rift[A-Za-z]*\\.new\\(").search_all(bare).size()
	_expect(bare.count("RiftMoteRuntime.new(run_state.plan.seed_value)") == 1 and foundation_constructions == 1,
		"the review does not make exactly one foundation object, the runtime, from the expedition's seed (%d foundation constructions)" % foundation_constructions)
	_expect(bare.count(".sweep_at(") == 1 and bare.count("register_graveblade(") == 1
			and bare.count("requirement_for(") == 1 and bare.count("collected_indices()") == 1,
		"the review does not sweep, register, ask G1 and read the collected indices exactly once each")
	## D-289: the two fixed heights are declared once and used once, in building a
	## marker; the player's position is read once, for the sweep; the review never
	## reads the camera — so nothing can steer where an orb or ring is drawn.
	_expect(bare.count("MOTE_ORB_REVIEW_HEIGHT") == 2 and bare.count("MOTE_RING_FLOOR_OFFSET") == 2
			and bare.count("player.global_position") == 1 and not bare.contains("camera"),
		"the orb's height, the ring's offset, the player or the camera is read somewhere other than it should be")
	var restated: PackedStringArray = PackedStringArray()
	for token: String in RESTATED_TOKENS:
		if bare.contains(token) or hud_bare.contains(token):
			restated.append(token)
	_expect(restated.is_empty(), "the review restates or reaches: %s" % ", ".join(restated))
	var hundred: RegEx = RegEx.create_from_string("(^|[^0-9.])100([^0-9]|$)")
	_expect(hundred.search(bare) == null and hundred.search(hud_bare) == null,
		"a review file carries the literal 100, so the requirement is not only G1's")
	_expect(bare.count("queue_free()") == 1 and bare.contains("marker.node.queue_free()") and not bare.contains(".free()"),
		"the review frees something other than its own marker nodes")

	var named: PackedStringArray = PackedStringArray()
	var hud_named: PackedStringArray = PackedStringArray()
	var classes: int = 0
	for entry: Dictionary in ProjectSettings.get_global_class_list():
		var name: String = String(entry.get("class", ""))
		classes += 1
		if raw.contains(name):
			named.append(name)
		if hud_raw.contains(name):
			hud_named.append(name)
	named.sort()
	hud_named.sort()
	_expect(classes > 100, "only %d project classes were read" % classes)
	_expect(named == PackedStringArray(REVIEW_NAMES), "the review names: %s" % ", ".join(named))
	_expect(hud_named == PackedStringArray(HUD_NAMES), "the review panel names: %s" % ", ".join(hud_named))

	var stored: PackedStringArray = PackedStringArray()
	var scene_statements: String = "\n".join(_scene_statements(scene_raw))
	for token: String in STORAGE_TOKENS:
		if bare.contains(token) or hud_bare.contains(token) or scene_statements.contains(token):
			stored.append(token)
	_expect(stored.is_empty(), "the review names storage: %s" % ", ".join(stored))
	var assets: PackedStringArray = PackedStringArray()
	for token: String in ASSET_TOKENS:
		if raw.contains(token) or hud_raw.contains(token) or scene_raw.contains(token):
			assets.append(token)
	_expect(assets.is_empty(), "the review names an asset, shader, particle or sound: %s" % ", ".join(assets))
	print("  1 runtime made from the expedition's seed; 1 sweep, 1 registration, 1 requirement asked, 1 index read; 0 of %d restated tokens; no literal 100; only marker nodes freed"
		% RESTATED_TOKENS.size())
	print("  of %d project classes the review names %s; its panel names %s"
		% [classes, ", ".join(named), ", ".join(hud_named)])
	print("  0 storage and 0 asset tokens in the review's two scripts and its scene")
	_done("the_review_restates_no_mechanism_and_writes_nothing")


# --- The owed set -----------------------------------------------------------------------------------------------

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


# --- Shared assertions ----------------------------------------------------------------------------------------

func _expect_torn_down(runtime: WeakRef, discarded: int, path: String) -> void:
	_expect(review.mote_runtime == null and runtime != null and runtime.get_ref() == null,
		"%s left the expedition's runtime alive" % path)
	_expect(review.runtimes_discarded == discarded and review.runtimes_created == discarded,
		"%s: %d runtime(s) created and %d discarded, not %d and %d" % [
			path, review.runtimes_created, review.runtimes_discarded, discarded, discarded,
		])
	_expect(review.marker_count() == 0 and review.mote_marker_root.get_child_count() == 0 and review.observer_count() == 0,
		"%s left %d marker(s), %d marker node(s) and %d observer(s)" % [
			path, review.marker_count(), review.mote_marker_root.get_child_count(), review.observer_count(),
		])
	var shapes: PackedStringArray = _shapes()
	_expect(_all_shapes(shapes, "R"), "%s left died connections reading %s" % [path, str(shapes)])
	_expect(review.last_refusal.is_empty() and review.last_sweep_result == null and review.last_collection_result == null,
		"%s kept the expedition's last refusal, sweep or collection" % path)
	var reading: Dictionary = review.experience_review_reading()
	_expect(not bool(reading["active"]) and _hud_text(HUD_LEVEL) == "No expedition in progress"
			and _hud_text(HUD_EXPERIENCE) == "XP —" and not _hud_visible(HUD_LEVEL_UP),
		"%s left the panel reading '%s' / '%s'" % [path, _hud_text(HUD_LEVEL), _hud_text(HUD_EXPERIENCE)])


func _expect_nothing_opened(surfaces_before: int, moment: String) -> void:
	_expect(review.mote_runtime.level() == 1 and not review.mote_runtime.is_offer_active(),
		"%s the run is level %d with offer %s" % [moment, review.mote_runtime.level(), review.mote_runtime.is_offer_active()])
	_expect(not get_tree().paused and not review.item_comparison.is_open and not review.fallen_overlay.is_open
			and not review.summary_panel.is_open,
		"%s something paused the world or opened a modal" % moment)
	_expect(review.get_node("CanvasLayer").get_child_count() == surfaces_before,
		"%s a surface was added to the interface" % moment)


# --- Evidence -------------------------------------------------------------------------------------------------------

## Adds no assertion: the rendered runs pin the same count as the headless one.
## `settle_seconds` lets a corpse finish its death clip before the frame is taken.
func _frame(at: Vector3, stem: String, settle_seconds: float = 0.0) -> void:
	if _shot_dir.is_empty():
		return
	_stand(at)
	if settle_seconds > 0.0:
		await get_tree().create_timer(settle_seconds).timeout
	await _await_process_frames(6)
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


# --- Helpers ------------------------------------------------------------------------------------------------------------

func _stand(at: Vector3) -> void:
	review.player.global_position = Vector3(at.x, 0.0, at.z)
	review.player.velocity = Vector3.ZERO
	review.player.clear_movement_intent("verification", false)
	review.camera_rig.focus = review.player.global_position


## The real physical key, pushed through the viewport so it reaches the runtime's
## own `_unhandled_input()` exactly as a keyboard press would.
func _press_key(keycode: Key) -> void:
	for pressed: bool in [true, false]:
		var event: InputEventKey = InputEventKey.new()
		event.physical_keycode = keycode
		event.pressed = pressed
		get_viewport().push_input(event)
	await _await_process_frames(1)


func _set_pickup(value: bool) -> void:
	if review.automatic_pickup != value:
		await _press_key(KEY_F8)
	_expect(review.automatic_pickup == value, "F8 did not turn automatic pickup %s" % ("ON" if value else "OFF"))


func _kill(enemy: PrototypeGraveblade, source: Node = null, target: Node = null) -> void:
	var from: Node = review.player if source == null else source
	var to: Node = enemy if target == null else target
	enemy.receive_damage(DamageEvent.physical(_use(), from, to, enemy.life + 1000.0))
	_deaths_driven += 1
	_expect(not enemy.is_alive(), "%s did not die from a lethal hit" % enemy.name)


func _quiet_room(index: int) -> void:
	for enemy: PrototypeGraveblade in review.room_enemies[index]:
		enemy.set_ai_enabled(false)


func _use() -> int:
	_next_use_id += 1
	return _next_use_id


func _rounded(at: Vector3) -> Vector3:
	return Vector3(roundf(at.x), 0.0, roundf(at.z))


func _planar_gap(a: Vector3, b: Vector3) -> float:
	return Vector2(a.x - b.x, a.z - b.z).length()


## The next world-position component beyond `value` in `direction`, as the engine
## stores it: a Vector3 component is single precision, so this is one float32
## spacing, read back from a Vector3 rather than computed (the H8 suite's method).
func _beyond(value: float, direction: float) -> float:
	var step: float = 1.0
	while Vector3(value + direction * step * 0.5, 0.0, 0.0).x != value:
		step *= 0.5
	return Vector3(value + direction * step, 0.0, 0.0).x


func _await_flash() -> void:
	await get_tree().create_timer(RogueliteExperienceCollectionReview.COLLECTION_FLASH_SECONDS + 0.25).timeout
	await _await_process_frames(2)


## Every Graveblade's `died` connections, read through the engine's public signal
## API: R for a connection into the review node itself — the accepted room counter
## or the review's observer — B for a binding, and ? for anything else.
func _shapes() -> PackedStringArray:
	var shapes: PackedStringArray = PackedStringArray()
	for enemy: PrototypeGraveblade in review.graveblades:
		var shape: String = ""
		for connection: Dictionary in enemy.died.get_connections():
			var callable: Callable = connection.get("callable", Callable()) as Callable
			var target: Object = callable.get_object()
			if target == review:
				shape += "R"
			elif target is RiftGravebladeMoteBinding:
				shape += "B"
			else:
				shape += "?"
		shapes.append(shape)
	return shapes


func _describe(answer: RiftMoteSweepResult) -> String:
	return "no answer" if answer == null else answer.describe()


func _indices(answer: RiftMoteSweepResult) -> PackedInt32Array:
	return PackedInt32Array() if answer == null else answer.collected_indices()


## Each collecting sweep's indices, in order, as one line: `[[0], [2], ...]`.
func _sequence_text() -> String:
	return "[%s]" % ", ".join(PackedStringArray(_collected_sequence))


func _rgb(colour: Color) -> Vector3:
	return Vector3(colour.r, colour.g, colour.b)


func _offset_text(offset: Vector3) -> String:
	return "(%.2f, %.3f, %.2f)" % [offset.x, offset.y, offset.z]


func _all_shapes(shapes: PackedStringArray, expected: String) -> bool:
	if shapes.size() != EXPECTED_ROUTE_ENEMIES:
		return false
	for shape: String in shapes:
		if shape != expected:
			return false
	return true


func _hud_text(index: int) -> String:
	return review.experience_hud.text_controls()[index].text


func _hud_visible(index: int) -> bool:
	return review.experience_hud.text_controls()[index].is_visible_in_tree()


func _measure_text(controls: Array, viewport: Rect2, label: String) -> int:
	var visible: int = 0
	for entry: Variant in controls:
		var control: Control = entry as Control
		if control == null or not control.is_visible_in_tree():
			continue
		var rect: Rect2 = control.get_global_rect()
		var inside: bool = rect.size.x > 0.0 and rect.size.y > 0.0 and viewport.encloses(rect)
		_expect(inside, "%s: a visible control has no rectangle inside the viewport (%s)" % [label, rect])
		if inside:
			visible += 1
	return visible


func _walk_into_gate(gate: Vector3) -> void:
	_stand(gate)
	await _await_process_frames(6)
	await _settle(4)


func _await_navigation() -> void:
	for frame: int in 60:
		if NavigationServer3D.map_get_iteration_id(review.navigation_map()) > 0:
			return
		await get_tree().physics_frame


func _settle(frames: int) -> void:
	for i: int in frames:
		await get_tree().physics_frame


func _await_process_frames(frames: int) -> void:
	for i: int in frames:
		await get_tree().process_frame


func _declared_functions(source: String) -> PackedStringArray:
	var names: PackedStringArray = PackedStringArray()
	var pattern: RegEx = RegEx.create_from_string("(?m)^(?:static )?func ([A-Za-z0-9_]+)\\(")
	for found: RegExMatch in pattern.search_all(source):
		names.append(found.get_string(1))
	return names


## A scene file's statements: every line that is neither blank nor a `;` comment.
func _scene_statements(source: String) -> PackedStringArray:
	var kept: PackedStringArray = PackedStringArray()
	for line: String in source.split("\n"):
		var stripped: String = line.strip_edges()
		if stripped.is_empty() or stripped.begins_with(";"):
			continue
		kept.append(stripped)
	return kept


## Code with every comment line removed and every string literal emptied, so a
## scan reads what a file DOES rather than what it says.
func _bare(source: String) -> String:
	var kept: PackedStringArray = PackedStringArray()
	for line: String in source.split("\n"):
		if line.strip_edges().begins_with("#"):
			continue
		kept.append(line)
	var strings: RegEx = RegEx.create_from_string("\"([^\"\\\\]|\\\\.)*\"")
	return strings.sub("\n".join(kept), "\"\"", true)


func _expect(condition: bool, failure_message: String) -> void:
	_checks += 1
	if not condition:
		_failures.append(failure_message)


## Records a failure without adding to the pinned count, inside loops whose length
## is incidental.
func _expect_quiet(condition: bool, failure_message: String) -> void:
	if not condition:
		_failures.append(failure_message)


func _done(check_name: String) -> void:
	_reached[check_name] = true
