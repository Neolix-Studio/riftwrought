extends Node
## Riftwrought — Roguelite I2: Playable Three-Lane Level-Up Choice Review V1:
## automated verification (decision D-293).
##
## THIS IS NOT A GATE, AND IT RE-PROVES NO FOUNDATION. H8, I1, G4, the catalogues and
## the accepted Experience Collection Review (H9) prove their own mechanisms in their
## own suites. What only this suite can know is whether the LAYER behaves: that
## reaching exactly the Level 1 requirement through real Experience Motes opens one
## three-card panel on its own, holds the world and the sweep still, shows the
## standing offer's three accepted lanes in their accepted order with every name and
## effect read from the catalogues, refuses every way out but a card, keeps the same
## offer open over a refused choice, and — on a successful choice — records exactly
## what G4 records when driven directly, closes, resumes play at Level 2 with the
## right surplus, opens nothing more, and leaves the live character unchanged.
##
## IT WALKS THE ROUTE SEVEN TIMES, EVERY TIME WITH SEED 99. Expedition A takes Support
## with the keyboard at exactly 100, with the Elite Hall escort still alive and moving
## when the panel opens; B takes Combat and Defence with the controller at 100, with a
## pending mote under the player; C takes Utility with the mouse at 100; D, E and F
## take each lane from 125; G meets a refused opening.
##
## THREE THINGS ARE STAGED, AND EACH IS STATED WHERE IT HAPPENS:
##   1. every expedition after the first is handed the route's seed again, by
##      replacing the Nexus's next run plan with a fresh plan of seed 99 before its
##      Rift Gate is entered — so each lane is chosen from an equivalent fresh
##      expedition of the same seed in one process;
##   2. in B the player is placed ON a pending mote while the panel holds the world
##      still — which a player cannot do — to prove nothing collects it while paused;
##   3. in G the harness sweeps the Experience Mote runtime and opens its offer
##      itself, so the review's own one attempt meets a refusal no real route can
##      produce — the only way to prove a refused opening is shown and never retried.
## Beside those, the refused CHOICE of check 13 hands the runtime's own card entry
## point an undeclared lane, because no card can produce one.
##
## EVERY KILL IS THE REAL ACTOR'S OWN, through the Graveblade's public
## `receive_damage()`, and every Graveblade is moved only through its own
## `place_at()` to whole-metre coordinates. Every card is activated by a real input
## event pushed through the viewport — Enter, the D-pad and (A), a left click — and
## reaches the runtime only through the panel's own button.
##
## EVERY EXPECTED ANSWER IS A TYPED LITERAL OR THE ACCEPTED MECHANISM'S OWN ANSWER:
## seed 99's three identities and card texts are typed from D-291/D-292, and every
## choice is compared field for field with a G4 run driven directly from the same
## seed and the same catalogues.
##
## IT PORTS D-211's OWED-SET DISCIPLINE and GATE F's ON-SCREEN MEASUREMENT. The
## rendered evidence frames add NO assertion, so the headless and rendered runs pin
## the same count.
##
## Run: godot --headless --path game res://scenes/roguelite/roguelite_level_up_choice_review.tscn -- --seed 99 --verify-level-up

const REVIEW_SCRIPT: String = "res://scripts/roguelite/level_up/roguelite_level_up_choice_review.gd"
const PANEL_SCRIPT: String = "res://scripts/roguelite/level_up/rift_level_up_offer_panel.gd"
const REVIEW_SCENE_FILE: String = "res://scenes/roguelite/roguelite_level_up_choice_review.tscn"
const H9_SCENE: String = "res://scenes/roguelite/roguelite_experience_collection_review.tscn"
const H9_SCRIPT: String = "res://scripts/roguelite/experience/roguelite_experience_collection_review.gd"
const CORE_LOOP_SCRIPT: String = "res://scripts/roguelite/roguelite_core_loop_runtime.gd"
const SLICE_SCRIPT: String = "res://scripts/first_mvp/severed_threshold/broken_watch_slice.gd"
const MODAL_SCRIPT: String = "res://scripts/ui/first_mvp_modal.gd"
const PROJECT_SETTINGS_FILE: String = "res://project.godot"
const ENTRYPOINT: String = "res://scenes/app/prototype_app.tscn"

const ROUTE_SEED: int = 99
const ROUTE_SEED_TEXT: String = "00000063"
const REVIEW_AMOUNT: float = 25.0
const LEVEL_ONE_REQUIREMENT: float = 100.0
const LEVEL_TWO_REQUIREMENT: float = 125.0
const EXPECTED_ACTIONS: int = 31
const EXPECTED_EXPEDITIONS: int = 7

## The accepted live values (D-175, D-178 and the canonical Quick Strike record).
const ACCEPTED_MAX_SPEED: float = 5.0
const ACCEPTED_ACTION_TIME: float = 0.80
const ACCEPTED_REACH: float = 1.65
const ACCEPTED_ARC: float = 100.0
const ACCEPTED_CONE: float = 65.0
const SPEED_TOLERANCE: float = 0.01

## `Death_A` is 0.80 s and does not loop: a frame of a corpse waits this long.
const DEATH_CLIP_SETTLE_SECONDS: float = 1.2

## Seed 99's Level 1 offer, typed from D-291 and accepted under D-292, in D1's order.
const SEED_99_IDENTITIES: Array = [
	["quick_strike", "sweeping_edge"], ["card_celerity"], ["card_fleetness"],
]
## What each card must show: its lane, its name and its one detail line.
const SEED_99_CARDS: Array = [
	["Support", "Sweeping Edge", "Applies to Quick Strike"],
	["Combat and Defence", "Celerity", "+10% Skill Speed"],
	["Utility", "Fleetness", "+10% Movement Speed"],
]
## The receipt's choice line for each lane.
const EXPECTED_CHOICES: Array[String] = [
	"Support — Quick Strike → Sweeping Edge",
	"Combat and Defence — Celerity (+10% Skill Speed)",
	"Utility — Fleetness (+10% Movement Speed)",
]
const GREYBOX_NOTE: String = "Choices are recorded in this expedition's temporary build. Applying their effects to the playable character is not part of this review."
const SUPPORT_PROGRESSION: String = "a new compatible pair, rank 0 -> 1"
const NO_OFFER: String = "no offer is open; one must be opened before a lane may be taken"
const ALREADY_OPEN: String = "level 1 already has an offer open; only a lane of that offer may be taken"
const UNDECLARED_LANE: int = 7
const UNDECLARED_LANE_PREFIX: String = "lane 7 is not one of the offer's lanes"
const OFFER_STANDING_TEXT: String = "Level-up offer open — choose one of the three cards."
const RECEIPT_NOTE: String = "Recorded in the temporary build; not applied to the character in this review."

## The inherited methods the review overrides — exactly these, and each but the
## last calls the method it overrides.
const EXPECTED_OVERRIDES: Array[String] = [
	"_any_modal_open", "_build_run_surfaces", "_discard_mote_runtime", "_physics_process",
	"experience_review_reading", "_maybe_start_verification",
]

## The only project classes each shipping script may name, checked against the
## engine's own global class list in both directions.
const REVIEW_NAMES: Array[String] = [
	"PassiveCardCatalogue", "PassiveCardDefinition", "RiftLevelUpOfferPanel", "RiftLevelUpResult",
	"RiftOffer", "RiftRunLevelUpResult", "RogueliteExperienceCollectionReview",
	"RogueliteExperienceReviewHud", "RogueliteLevelUpChoiceReview", "SkillSupportCatalogue",
	"SkillTagProfile", "SupportDefinition",
]
const PANEL_NAMES: Array[String] = [
	"BrokenWatchSlice", "FirstMvpModal", "RiftLevelUpOfferPanel", "RogueliteLevelUpChoiceReview",
]

## Anything that would mean the runtime restated a mechanism it composes, touched
## the live character, or reached past I1 into the run. Read over CODE with its
## comments removed and its strings emptied.
const RESTATED_TOKENS: Array[String] = [
	"award_experience", "open_current_offer", "choose(", "sweep_at(", "sweep_collection", "spawn_drop",
	"requirement_for", "RiftLevelRequirement", "RiftLevelOfferSeed", "offer_root_seed",
	"frozen_offer_requirement", "LANE_ORDER", "run_build", "consumption_ledger", "has_consumed",
	"RiftRunLevelCoordinator", "paused = ", "InputMap", "time_scale", "max_speed",
	"increased_attack_speed", "equip_weapon", "PlayerStat", "total_for", "stat_totals",
	"duplicate", "100",
]

## Concrete Skill, support and card ids and names, and the effect words: none may
## appear in a shipping file at all, comments included (D-215).
const CONCRETE_TOKENS: Array[String] = [
	"quick_strike", "Quick Strike", "QuickStrike", "sweeping_edge", "Sweeping Edge",
	"reaching_edge", "Reaching Edge", "card_power", "card_celerity", "card_vitality",
	"card_fleetness", "card_insight", "card_magnetism", "Celerity", "Vitality", "Fleetness",
	"Insight", "Magnetism", "Skill Speed", "Movement Speed", "Global Damage", "Maximum Life",
	"Experience Gain", "Pickup Radius", "10%",
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

## H9's review-panel text controls, in its `text_controls()` order.
const HUD_SEED: int = 1
const HUD_LEVEL: int = 2
const HUD_EXPERIENCE: int = 3
const HUD_REFUSAL: int = 7
const HUD_LEVEL_UP: int = 8
const HUD_LEVEL_UP_NOTE: int = 9

## The receipt section's controls, in `receipt_controls()` order.
const RECEIPT_TITLE: int = 0
const RECEIPT_STATUS: int = 1
const RECEIPT_CHOICE: int = 2
const RECEIPT_PROGRESSION: int = 3
const RECEIPT_LEVEL: int = 4
const RECEIPT_NOTE_LINE: int = 5

const OWED_CHECKS: Array[String] = [
	"the_review_is_isolated_and_extends_the_accepted_experience_review",
	"the_input_map_and_entrypoint_are_unchanged",
	"the_nexus_holds_no_offer",
	"no_offer_opens_below_the_requirement",
	"exactly_the_requirement_opens_the_panel_without_advancing",
	"the_panel_shows_three_accepted_lanes_in_order",
	"every_name_and_effect_is_the_catalogues_own",
	"the_cards_are_bound_to_lanes_not_content",
	"the_world_and_the_sweep_stop_while_the_panel_is_open",
	"focus_starts_on_the_first_card_and_hover_selects_nothing",
	"cancel_back_and_every_other_key_leave_the_panel_open",
	"the_panel_is_legible_and_unobstructed",
	"a_refused_choice_keeps_the_same_offer_open",
	"support_by_keyboard_advances_once_and_matches_g4",
	"the_receipt_is_legible_and_play_resumes",
	"a_pending_in_range_mote_waits_untouched",
	"combat_and_defence_by_controller_advances_once_and_matches_g4",
	"utility_by_mouse_advances_once_and_matches_g4",
	"from_125_every_lane_retains_25",
	"a_refused_opening_is_shown_once_and_never_retried",
	"live_movement_and_quick_strike_are_unchanged",
	"teardown_clears_every_expedition_offer_state",
	"the_review_restates_no_mechanism_and_writes_nothing",
]

var review: RogueliteLevelUpChoiceReview
var arguments: PackedStringArray = PackedStringArray()

var _failures: PackedStringArray = PackedStringArray()
var _checks: int = 0
var _reached: Dictionary = {}
var _shot_dir: String = ""
var _next_use_id: int = 93000
var _deaths_driven: int = 0
var _expeditions: int = 0
var _staged_plans: int = 0
var _baseline: Dictionary = {}
var _live_after: Array[Dictionary] = []
var _top_speeds: Array[float] = []
var _teardowns: PackedStringArray = PackedStringArray()
var _calls_at_expedition_start: int = 0


func _ready() -> void:
	await run()


func run() -> void:
	print("")
	print("=== Roguelite I2 — Playable Three-Lane Level-Up Choice Review V1 verification (D-293) ===")
	_shot_dir = _argument_value("--shots")
	await _settle(10)
	await _await_navigation()

	_check_the_review_is_isolated_and_extends_the_accepted_experience_review()
	_check_the_input_map_and_entrypoint_are_unchanged()
	_check_the_nexus_holds_no_offer()

	## Expedition A — Support with the keyboard, at exactly 100, the escort alive.
	await _begin_expedition("A")
	_baseline = _live_values()
	_top_speeds.append(await _top_speed(_rounded(review.room_modules[0].room_centres()[0])))
	await _check_no_offer_opens_below_the_requirement()
	await _check_exactly_the_requirement_opens_the_panel_without_advancing()
	_check_the_panel_shows_three_accepted_lanes_in_order()
	_check_every_name_and_effect_is_the_catalogues_own()
	_check_the_cards_are_bound_to_lanes_not_content()
	await _check_the_world_and_the_sweep_stop_while_the_panel_is_open()
	await _check_focus_starts_on_the_first_card_and_hover_selects_nothing()
	await _check_cancel_back_and_every_other_key_leave_the_panel_open()
	await _check_the_panel_is_legible_and_unobstructed()
	_check_a_refused_choice_keeps_the_same_offer_open()
	await _check_support_by_keyboard_advances_once_and_matches_g4()
	await _check_the_receipt_is_legible_and_play_resumes()
	await _end_expedition("A")

	## Expedition B — Combat and Defence with the controller, a pending mote underfoot.
	await _begin_expedition("B")
	await _route_to_the_elite_hall()
	await _check_a_pending_in_range_mote_waits_untouched()
	await _check_combat_and_defence_by_controller_advances_once_and_matches_g4()
	await _end_expedition("B")

	## Expedition C — Utility with the mouse.
	await _begin_expedition("C")
	await _route_to_the_elite_hall()
	await _check_utility_by_mouse_advances_once_and_matches_g4()
	await _end_expedition("C")

	## Expeditions D, E and F — each lane from 125.
	await _check_from_125_every_lane_retains_25()

	## Expedition G — a refused opening.
	await _check_a_refused_opening_is_shown_once_and_never_retried()

	_check_live_movement_and_quick_strike_are_unchanged()
	_check_teardown_clears_every_expedition_offer_state()
	_check_the_review_restates_no_mechanism_and_writes_nothing()

	_check_every_check_ran()

	print("")
	print("  %d expeditions walked (%d given seed %d again by staging), %d Graveblade deaths driven, %d automatic sweeps made, %d offer opening(s) asked, %d choice(s) attempted and %d taken across this suite"
		% [_expeditions, _staged_plans, ROUTE_SEED, _deaths_driven, review.sweeps_made, review.offer_open_calls,
			review.choice_attempts, review.choices_taken])
	if _failures.is_empty():
		print("ROGUELITE LEVEL-UP CHOICE REVIEW VERIFICATION: PASS (%d checks)" % _checks)
		get_tree().quit(0)
	else:
		for failure: String in _failures:
			printerr("  FAIL: %s" % failure)
		printerr("ROGUELITE LEVEL-UP CHOICE REVIEW VERIFICATION: %d FAILURE(S) of %d checks" % [
			_failures.size(), _checks,
		])
		get_tree().quit(1)


# --- 1. Isolation ------------------------------------------------------------------------

func _check_the_review_is_isolated_and_extends_the_accepted_experience_review() -> void:
	print("")
	print("--- 1. The review inherits H9's accepted scene, extends H9's runtime, and adds one modal on the accepted contract")
	var statements: PackedStringArray = _scene_statements(FileAccess.get_file_as_string(REVIEW_SCENE_FILE))
	var nodes: int = 0
	var externals: int = 0
	var subs: int = 0
	var scripts: int = 0
	var instance_of_h9: bool = false
	for statement: String in statements:
		if statement.begins_with("[node "):
			nodes += 1
			instance_of_h9 = statement.contains("instance=ExtResource(")
		elif statement.begins_with("[ext_resource "):
			externals += 1
		elif statement.begins_with("[sub_resource "):
			subs += 1
		elif statement.begins_with("script = ExtResource("):
			scripts += 1
	var names_h9: bool = "\n".join(statements).contains("path=\"%s\"" % H9_SCENE)
	_expect(nodes == 1 and externals == 2 and subs == 0 and scripts == 1 and instance_of_h9 and names_h9,
		"the scene is not one inherited instance of H9's scene with its script replaced (%d nodes, %d externals, %d subs)"
			% [nodes, externals, subs])
	var script: GDScript = review.get_script() as GDScript
	var panel_script: GDScript = review.level_up_panel.get_script() as GDScript
	_expect(script.resource_path == REVIEW_SCRIPT and script.get_base_script().resource_path == H9_SCRIPT
			and review is RogueliteExperienceCollectionReview and review is RogueliteCoreLoopRuntime,
		"the runtime does not extend H9's accepted runtime")
	_expect(panel_script.resource_path == PANEL_SCRIPT and panel_script.get_base_script().resource_path == MODAL_SCRIPT
			and review.level_up_panel is FirstMvpModal,
		"the panel does not extend the accepted FirstMvpModal")
	## Drawn over the combat HUD, the run banner, H9's panel and all three accepted
	## modals. The one surface after it is the accepted loop's ground-item nameplate,
	## which it builds last and which is hidden with no item on the ground.
	var layer: Node = review.get_node("CanvasLayer")
	var beneath: int = 0
	for surface: Control in [review.hud, review.run_hud, review.experience_hud, review.item_comparison,
			review.fallen_overlay, review.summary_panel]:
		if surface.get_parent() == layer and surface.get_index() < review.level_up_panel.get_index():
			beneath += 1
	var after: PackedStringArray = PackedStringArray()
	for index: int in range(review.level_up_panel.get_index() + 1, layer.get_child_count()):
		var node: CanvasItem = layer.get_child(index) as CanvasItem
		after.append("%s%s" % [node.name, " (visible)" if node.visible else ""])
	_expect(review.level_up_panel.get_parent() == layer and beneath == 6
			and after == PackedStringArray(["GroundNameplate"])
			and review.level_up_panel.process_mode == Node.PROCESS_MODE_WHEN_PAUSED,
		"the panel is drawn over %d of 6 surfaces, runs %d, and is followed by %s" % [
			beneath, review.level_up_panel.process_mode, ", ".join(after)])
	_expect(review.get_node_or_null("RogueliteExperienceCollectionReviewVerification") == null
			and review.get_node_or_null("RogueliteCoreLoopVerification") == null,
		"an accepted suite started in this scene")
	var receipt_box: Node = review.experience_hud.panel.get_child(0)
	_expect(review.receipt_controls()[RECEIPT_TITLE].get_parent() == receipt_box,
		"the receipt section is not inside H9's review panel")

	## Exactly six overrides, and each but the flag calls the method it overrides.
	var source: String = FileAccess.get_file_as_string(REVIEW_SCRIPT)
	var inherited: PackedStringArray = PackedStringArray()
	for path: String in [H9_SCRIPT, CORE_LOOP_SCRIPT, SLICE_SCRIPT]:
		inherited.append_array(_declared_functions(FileAccess.get_file_as_string(path)))
	var overrides: PackedStringArray = PackedStringArray()
	for name: String in _declared_functions(source):
		if inherited.has(name):
			overrides.append(name)
	overrides.sort()
	var expected: PackedStringArray = PackedStringArray(EXPECTED_OVERRIDES)
	expected.sort()
	var calling: PackedStringArray = PackedStringArray()
	for name: String in EXPECTED_OVERRIDES:
		if name != "_maybe_start_verification" and _function_body(source, name).contains("super("):
			calling.append(name)
	_expect(overrides == expected and calling.size() == EXPECTED_OVERRIDES.size() - 1,
		"the review overrides %s, %d calling the method it overrides" % [", ".join(overrides), calling.size()])
	var flag: String = _function_body(source, "_maybe_start_verification")
	_expect(flag.contains("--verify-level-up") and not flag.contains("--verify-experience"),
		"the review does not answer its own verification flag only")

	## The project classes each shipping script names, in both directions.
	var review_names: PackedStringArray = _names_in(source)
	var panel_names: PackedStringArray = _names_in(FileAccess.get_file_as_string(PANEL_SCRIPT))
	_expect(review_names == PackedStringArray(REVIEW_NAMES) and panel_names == PackedStringArray(PANEL_NAMES),
		"the runtime names %s and the panel %s" % [", ".join(review_names), ", ".join(panel_names)])
	print("  inherited instance of %s; the runtime extends %s and the panel %s; %d overrides (%s), %d calling the method they override"
		% [H9_SCENE.get_file(), H9_SCRIPT.get_file(), MODAL_SCRIPT.get_file(), overrides.size(),
			", ".join(overrides), calling.size()])
	print("  the runtime names %s; the panel names %s" % [", ".join(review_names), ", ".join(panel_names)])
	print("  the panel is drawn over %d of 6 surfaces — the combat HUD, the run banner, H9's panel and the 3 accepted modals — and is followed only by %s"
		% [beneath, ", ".join(after)])
	_done("the_review_is_isolated_and_extends_the_accepted_experience_review")


# --- 2. The InputMap and the entrypoint ---------------------------------------------------

func _check_the_input_map_and_entrypoint_are_unchanged() -> void:
	print("")
	print("--- 2. The InputMap, the entrypoint and project.godot are untouched")
	var actions: int = 0
	for action: StringName in InputMap.get_actions():
		if String(action).begins_with("ui_") and not String(action) in ["ui_confirm", "ui_cancel"]:
			continue
		actions += 1
	_expect(actions == EXPECTED_ACTIONS, "the InputMap holds %d project actions, not %d" % [actions, EXPECTED_ACTIONS])
	_expect(String(ProjectSettings.get_setting("application/run/main_scene", "")) == ENTRYPOINT,
		"the entrypoint is %s" % ProjectSettings.get_setting("application/run/main_scene", ""))
	var settings: String = FileAccess.get_file_as_string(PROJECT_SETTINGS_FILE)
	_expect(not settings.contains("[autoload]") and not settings.contains("level_up_choice")
			and not settings.contains("RogueliteLevelUp") and not settings.contains("RiftLevelUpOfferPanel"),
		"project.godot gained an autoload or names this review")
	print("  %d actions; the entrypoint is %s; project.godot declares no [autoload] and names nothing of this review"
		% [actions, ENTRYPOINT.get_file()])
	_done("the_input_map_and_entrypoint_are_unchanged")


# --- 3. The Nexus -----------------------------------------------------------------------

func _check_the_nexus_holds_no_offer() -> void:
	print("")
	print("--- 3. The Nexus holds no runtime, no offer, no panel and no receipt")
	_expect(review.loop_state == RogueliteCoreLoopRuntime.LoopState.HUB and review.plan.seed_value == ROUTE_SEED
			and review.mote_runtime == null,
		"the review did not start in the Nexus with seed %d and no runtime" % ROUTE_SEED)
	_expect(not review.offer_attempted() and review.offer_open_calls == 0 and not review.level_up_panel.is_open
			and not get_tree().paused and _receipt_visible_count() == 0,
		"the Nexus holds an offer attempt, a panel or a receipt")
	_expect(_hud_text(HUD_SEED) == "Next run seed %s" % ROUTE_SEED_TEXT and _hud_text(HUD_LEVEL) == "No expedition in progress",
		"the Nexus panel reads '%s' / '%s'" % [_hud_text(HUD_SEED), _hud_text(HUD_LEVEL)])
	print("  no runtime, 0 opening(s) asked, panel closed, not paused, 0 receipt lines shown; the panel reads '%s'"
		% _hud_text(HUD_SEED))
	_done("the_nexus_holds_no_offer")


# --- 4. Below the requirement ------------------------------------------------------------

func _check_no_offer_opens_below_the_requirement() -> void:
	print("")
	print("--- 4. Real motes at 25, 50 and 75 open nothing and ask nothing")
	var steps: PackedStringArray = PackedStringArray()
	_quiet_room(0)
	var hall: Vector3 = _rounded(review.room_modules[0].room_centres()[0])
	_stand(hall)
	var teaching: PrototypeGraveblade = review.room_enemies[0][0]
	teaching.place_at(hall)
	_kill(teaching)
	await _settle(3)
	_expect_below("at 25", 25.0)
	steps.append(_amount_text(review.mote_runtime.experience()))
	await _walk_into_gate(review.room_modules[0].exit_point())
	_quiet_room(1)
	var cache: Vector3 = _rounded(review.room_modules[1].room_centres()[0])
	_stand(cache)
	for enemy: PrototypeGraveblade in review.room_enemies[1]:
		enemy.place_at(cache)
		_kill(enemy)
		await _settle(3)
		_expect_below("at %s" % _amount_text(review.mote_runtime.experience()), review.mote_runtime.experience())
		steps.append(_amount_text(review.mote_runtime.experience()))
	await _walk_into_gate(review.room_modules[1].exit_point())
	_expect(review.run_state.current_room_index == 2 and review.mote_runtime.experience() == 3.0 * REVIEW_AMOUNT,
		"the route did not reach the Elite Hall at 75: %s" % _state())
	print("  experience %s through real motes; at each step 0 opening(s) asked, no panel, not paused, level 1, no offer"
		% " -> ".join(steps))
	_done("no_offer_opens_below_the_requirement")


func _expect_below(moment: String, experience: float) -> void:
	_expect(review.offer_open_calls == _calls_at_expedition_start and not review.offer_attempted()
			and not review.level_up_panel.is_open and not get_tree().paused
			and not review.mote_runtime.is_offer_active() and review.mote_runtime.level() == 1
			and experience < LEVEL_ONE_REQUIREMENT,
		"%s something opened or was asked: %s" % [moment, _state()])


# --- 5. Exactly one hundred ----------------------------------------------------------------

func _check_exactly_the_requirement_opens_the_panel_without_advancing() -> void:
	print("")
	print("--- 5. The fourth mote reaches exactly 100 and the panel opens on its own; nothing advances")
	var centre: Vector3 = _rounded(review.room_modules[2].room_centres()[0])
	var elite: PrototypeGraveblade = review.room_enemies[2][0]
	var escort: PrototypeGraveblade = review.room_enemies[2][1]
	await _set_pickup(false)
	elite.set_ai_enabled(false)
	elite.place_at(centre - Vector3(4.0, 0.0, 0.0))
	escort.place_at(centre + Vector3(4.0, 0.0, 0.0))
	_stand(centre - Vector3(4.0, 0.0, 0.0))
	_kill(elite)
	## The escort is ALIVE, its AI on as the accepted loop set it on entering the room,
	## and it pursues while the Elite's corpse settles.
	await get_tree().create_timer(DEATH_CLIP_SETTLE_SECONDS).timeout
	var escort_from: Vector3 = centre + Vector3(4.0, 0.0, 0.0)
	var calls_before: int = review.offer_open_calls
	await _set_pickup(true)
	await _settle(3)
	var collected: PackedInt32Array = PackedInt32Array() if review.last_collection_result == null \
		else review.last_collection_result.collected_indices()
	var g1: RiftLevelRequirementReading = RiftLevelRequirementCurve.requirement_for(1)
	var g2: RiftLevelOfferSeedReading = RiftLevelOfferSeedDerivation.offer_root_seed_for(ROUTE_SEED, 1)
	_expect(collected == PackedInt32Array([3]) and review.mote_runtime.experience() == LEVEL_ONE_REQUIREMENT
			and g1.ok and float(g1.requirement) == LEVEL_ONE_REQUIREMENT,
		"the fourth mote did not reach exactly G1's requirement: collected %s, %s" % [str(collected), _state()])
	_expect(review.offer_open_calls == calls_before + 1 and review.offer_attempted() and review.offer_open_refusals == 0,
		"reaching the requirement asked %d opening(s)" % (review.offer_open_calls - calls_before))
	_expect(review.level_up_panel.is_open and get_tree().paused and review.mote_runtime.is_offer_active(),
		"the panel did not open automatically over a standing offer: %s" % _state())
	_expect(review.mote_runtime.level() == 1 and review.mote_runtime.frozen_offer_requirement() == LEVEL_ONE_REQUIREMENT
			and review.mote_runtime.offer_root_seed() == g2.offer_root_seed and g2.offer_root_seed == ROUTE_SEED,
		"opening advanced the run or froze the wrong requirement or root: %s" % _state())
	_expect(escort.is_alive() and escort.ai_enabled and _planar_gap(escort.global_position, escort_from) > 0.5,
		"the escort was not alive and moving when the panel opened")
	## H9's own terms call this ready (100 of 100); in this scene its note would be false.
	_expect(_hud_text(HUD_EXPERIENCE) == "XP 100 / 100" and not _hud_visible(HUD_LEVEL_UP)
			and not _hud_visible(HUD_LEVEL_UP_NOTE)
			and _receipt_visible(RECEIPT_STATUS) and _receipt_text(RECEIPT_STATUS) == OFFER_STANDING_TEXT,
		"the review panel reads '%s' with H9's level-up lines %s and the receipt status '%s'"
			% [_hud_text(HUD_EXPERIENCE), str(_hud_visible(HUD_LEVEL_UP)), _receipt_text(RECEIPT_STATUS)])
	await _capture("01_three_card_offer")
	print("  the collecting sweep took [3]: experience 100.0 = G1's Level 1 requirement; 1 opening asked; the panel opened on its own; paused; level 1; frozen requirement 100.0; root seed %d (G2: %d)"
		% [review.mote_runtime.offer_root_seed(), g2.offer_root_seed])
	print("  the escort, alive and pursuing, had moved %.1f m; H9's 'LEVEL-UP READY' lines withheld; the receipt reads '%s'"
		% [_planar_gap(escort.global_position, escort_from), _receipt_text(RECEIPT_STATUS)])
	_done("exactly_the_requirement_opens_the_panel_without_advancing")


# --- 6. Three lanes -----------------------------------------------------------------------

func _check_the_panel_shows_three_accepted_lanes_in_order() -> void:
	print("")
	print("--- 6. Exactly three cards, in D1's lane order, showing seed 99's accepted Level 1 offer")
	var panel: RiftLevelUpOfferPanel = review.level_up_panel
	var lanes: Array[int] = review.mote_runtime.offer_lanes()
	var slots: Array[int] = []
	for slot: int in panel.card_count():
		slots.append(panel.lane_for_slot(slot))
	_expect(panel.card_count() == 3 and RiftLevelUpOfferPanel.CARD_SLOTS == RiftOffer.LANE_ORDER.size()
			and lanes == RiftOffer.LANE_ORDER and slots == lanes,
		"the panel holds %d card(s) on lanes %s; the offer's lanes are %s" % [panel.card_count(), str(slots), str(lanes)])
	var twin: RiftRunLevelCoordinator = _twin_opened(4)
	var shown: PackedStringArray = PackedStringArray()
	var mismatched: PackedStringArray = PackedStringArray()
	for slot: int in 3:
		var lane: int = lanes[slot]
		var lines: PackedStringArray = panel.card_lines(slot)
		var identity: PackedStringArray = review.mote_runtime.offer_identity_for(lane)
		if lines != PackedStringArray(SEED_99_CARDS[slot]) or lines[0] != RiftOffer.lane_label(lane) \
				or identity != PackedStringArray(SEED_99_IDENTITIES[slot]) or identity != twin.offer_identity_for(lane):
			mismatched.append("%d: %s / %s" % [slot, str(lines), str(identity)])
		shown.append("%s: %s — %s" % [lines[0], lines[1], lines[2]])
	_expect(mismatched.is_empty(), "cards differ from seed 99's accepted offer: %s" % ", ".join(mismatched))
	var captions: PackedStringArray = PackedStringArray()
	var ranked: int = 0
	for control: Control in panel.text_controls():
		var text: String = _visible_text(control)
		if text.contains("rank") or text.contains("->"):
			ranked += 1
	for slot: int in 3:
		captions.append(_caption(panel.card_buttons()[slot]))
	_expect(captions == PackedStringArray(["Choose Sweeping Edge", "Choose Celerity", "Choose Fleetness"]) and ranked == 0,
		"the buttons read %s and %d line(s) show a rank transition" % [str(captions), ranked])
	_expect(panel.note_text() == GREYBOX_NOTE and panel.refusal_text().is_empty() and not panel.cancel_closes(),
		"the greybox note reads '%s'" % panel.note_text())
	print("  lanes %s = D1's %s; %s" % [str(lanes), str(RiftOffer.LANE_ORDER), "; ".join(shown)])
	print("  3 of 3 identities equal the directly driven G4 run's; 0 lines show a rank before choosing; the note reads: %s"
		% panel.note_text())
	_done("the_panel_shows_three_accepted_lanes_in_order")


# --- 7. The catalogues' own names ----------------------------------------------------------

func _check_every_name_and_effect_is_the_catalogues_own() -> void:
	print("")
	print("--- 7. Every name and effect line on a card is the accepted catalogue's own, resolved from the offer's identity")
	var panel: RiftLevelUpOfferPanel = review.level_up_panel
	var support: PackedStringArray = review.mote_runtime.offer_identity_for(RiftOffer.Lane.SUPPORT)
	var skill: SkillTagProfile = SkillSupportCatalogue.skill_profile(StringName(support[0]))
	var definition: SupportDefinition = SkillSupportCatalogue.support_definition(StringName(support[1]))
	_expect(skill != null and definition != null and panel.card_lines(0)[1] == definition.display_name()
			and panel.card_lines(0)[2] == "Applies to %s" % skill.display_name,
		"the Support card is not the catalogue's support applied to the catalogue's Skill")
	var passive: PackedStringArray = PackedStringArray()
	for slot: int in [1, 2]:
		var identity: PackedStringArray = review.mote_runtime.offer_identity_for(panel.lane_for_slot(slot))
		var record: PassiveCardDefinition = PassiveCardCatalogue.record(StringName(identity[0]))
		_expect(record != null and panel.card_lines(slot)[1] == record.display_name
				and panel.card_lines(slot)[2] == record.effect_line() and record.magnitude == 0.10,
			"card %d is not %s's own name and effect line" % [slot + 1, identity[0]])
		passive.append("%s -> %s / %s" % [identity[0], record.display_name, record.effect_line()])
	var concrete: PackedStringArray = PackedStringArray()
	for path: String in [REVIEW_SCRIPT, PANEL_SCRIPT, REVIEW_SCENE_FILE]:
		var raw: String = FileAccess.get_file_as_string(path)
		for token: String in CONCRETE_TOKENS:
			if raw.contains(token):
				concrete.append("%s names %s" % [path.get_file(), token])
	var bare: String = _bare(FileAccess.get_file_as_string(REVIEW_SCRIPT))
	var once: PackedStringArray = PackedStringArray()
	for call: String in ["open_level_up_offer(", "SkillSupportCatalogue.skill_profiles()",
			"SkillSupportCatalogue.support_definitions()", "PassiveCardCatalogue.records()"]:
		once.append("%s x%d" % [call, bare.count(call)])
	_expect(concrete.is_empty(), "a shipping file names concrete content: %s" % ", ".join(concrete))
	_expect(once == PackedStringArray(["open_level_up_offer( x1", "SkillSupportCatalogue.skill_profiles() x1",
			"SkillSupportCatalogue.support_definitions() x1", "PassiveCardCatalogue.records() x1"]),
		"the I1 opening and the three catalogue sets are named %s" % ", ".join(once))
	print("  Support: %s -> %s, applied to %s -> %s; %s" % [support[1], definition.display_name(), support[0],
		skill.display_name, "; ".join(passive)])
	print("  0 of %d concrete ids, names or effect words in the runtime, the panel or the scene; the opening and each catalogue set named exactly once"
		% CONCRETE_TOKENS.size())
	_done("every_name_and_effect_is_the_catalogues_own")


# --- 8. Slots bound to lanes ------------------------------------------------------------------

func _check_the_cards_are_bound_to_lanes_not_content() -> void:
	print("")
	print("--- 8. Each button is bound to its slot, and a slot reads the lane the offer put there")
	var panel: RiftLevelUpOfferPanel = review.level_up_panel
	var bindings: PackedStringArray = PackedStringArray()
	for slot: int in 3:
		for connection: Dictionary in panel.card_buttons()[slot].pressed.get_connections():
			var callable: Callable = connection.get("callable", Callable()) as Callable
			bindings.append("%s.%s%s" % [
				"panel" if callable.get_object() == panel else str(callable.get_object()),
				callable.get_method(), str(callable.get_bound_arguments()),
			])
	_expect(bindings == PackedStringArray(["panel._on_card_pressed[0]", "panel._on_card_pressed[1]", "panel._on_card_pressed[2]"]),
		"the card buttons are connected as %s" % ", ".join(bindings))
	var panel_bare: String = _bare(FileAccess.get_file_as_string(PANEL_SCRIPT))
	var review_bare: String = _bare(FileAccess.get_file_as_string(REVIEW_SCRIPT))
	_expect(panel_bare.count("pressed.connect(_on_card_pressed.bind(slot))") == 1
			and panel_bare.count("_runtime.choose_offered_lane(_lanes[slot])") == 1
			and panel_bare.count("_lanes.append(int(card[\"\"]))") == 1
			and review_bare.count("mote_runtime.choose_level_up_lane(lane)") == 1,
		"a card reaches the run other than by its slot's lane")
	print("  3 buttons bound as %s; a press hands _lanes[slot] to choose_offered_lane(), which hands that lane to choose_level_up_lane()"
		% ", ".join(bindings))
	_done("the_cards_are_bound_to_lanes_not_content")


# --- 9. The world stands still ----------------------------------------------------------------

func _check_the_world_and_the_sweep_stop_while_the_panel_is_open() -> void:
	print("")
	print("--- 9. While the panel is open the world, the living escort and the sweep all stand still")
	var escort: PrototypeGraveblade = review.room_enemies[2][1]
	var before: Dictionary = _frozen_reading(escort)
	await _settle(30)
	await _await_process_frames(10)
	var after: Dictionary = _frozen_reading(escort)
	_expect(before == after and get_tree().paused and review.level_up_panel.is_open,
		"the world moved behind the panel: %s -> %s" % [str(before), str(after)])
	## H9's own tick, called directly while paused, sweeps nothing either.
	var sweeps: int = review.sweeps_made
	review._sweep_automatically()
	_expect(review.sweeps_made == sweeps, "H9's tick swept while the panel was open")
	print("  30 physics and 10 idle frames: 0 sweeps, the player, the escort (alive, AI on, state %s) and their Life unchanged, experience %s"
		% [str(escort.state), _amount_text(review.mote_runtime.experience())])
	_done("the_world_and_the_sweep_stop_while_the_panel_is_open")


func _frozen_reading(escort: PrototypeGraveblade) -> Dictionary:
	return {
		"sweeps": review.sweeps_made, "player": review.player.global_position, "life": review.player.life,
		"escort": escort.global_position, "escort_state": escort.state, "escort_time": escort.state_time,
		"escort_life": escort.life, "experience": review.mote_runtime.experience(),
		"drops": review.mote_runtime.drop_count(), "uncollected": review.mote_runtime.uncollected_count(),
		"attack": review.player.attack.phase, "level": review.mote_runtime.level(),
	}


# --- 10. Focus and hover -------------------------------------------------------------------------

func _check_focus_starts_on_the_first_card_and_hover_selects_nothing() -> void:
	print("")
	print("--- 10. The first card is focused on opening; the pointer hovering a card chooses nothing and moves no focus")
	var buttons: Array[Button] = review.level_up_panel.card_buttons()
	_expect(get_viewport().gui_get_focus_owner() == buttons[0] and review.level_up_panel.last_focus_name == buttons[0].name,
		"the panel opened with %s focused" % str(get_viewport().gui_get_focus_owner()))
	var attempts: int = review.choice_attempts
	var hovered: PackedStringArray = PackedStringArray()
	for slot: int in [1, 2]:
		_hover(buttons[slot])
		await _await_process_frames(2)
		hovered.append(str(get_viewport().gui_get_hovered_control() == buttons[slot]))
	_expect(hovered == PackedStringArray(["true", "true"]) and get_viewport().gui_get_focus_owner() == buttons[0]
			and review.choice_attempts == attempts and review.level_up_panel.is_open and review.mote_runtime.is_offer_active(),
		"hovering cards 2 and 3 (reached %s) chose or focused something" % str(hovered))
	print("  focus on %s; the pointer reached cards 2 and 3 in turn; 0 choices, focus still on card 1, the offer standing"
		% buttons[0].name)
	_done("focus_starts_on_the_first_card_and_hover_selects_nothing")


# --- 11. No way out ------------------------------------------------------------------------------

func _check_cancel_back_and_every_other_key_leave_the_panel_open() -> void:
	print("")
	print("--- 11. Esc, (B), F5, F8, F6, [, a right click and a left click on the backdrop all leave the panel open")
	var before: Dictionary = _leak_reading()
	await _key(KEY_ESCAPE)
	await _joy(JOY_BUTTON_B)
	for keycode: Key in [KEY_F5, KEY_F8, KEY_F6, KEY_BRACKETLEFT]:
		await _key(keycode)
	var middle: Vector2 = Vector2(get_viewport().get_visible_rect().size) * 0.5
	await _mouse_click(middle, MOUSE_BUTTON_RIGHT)
	await _mouse_click(Vector2(40.0, 40.0), MOUSE_BUTTON_LEFT)
	## First-MVP UI J1 (D-322): the left press reaches the GUI through the shared modal
	## contract, and the control it lands on is the panel's own dim backdrop, which stops it.
	var landed: Control = get_viewport().gui_get_hovered_control()
	await _settle(4)
	var after: Dictionary = _leak_reading()
	_expect(before == after and review.level_up_panel.is_open and get_tree().paused,
		"an input leaked past the panel: %s -> %s" % [str(before), str(after)])
	_expect(landed == review.level_up_panel.get_node("Dim") and not review.player.has_destination,
		"the backdrop's left press did not stop at the panel")
	print("  8 inputs: the panel still open over the same offer, paused, 0 choices, 0 closes; pickup, grid, camera %.1f m, expedition, attack and movement all unchanged"
		% float(after["camera"]))
	_done("cancel_back_and_every_other_key_leave_the_panel_open")


func _leak_reading() -> Dictionary:
	return {
		"closes": review.level_up_panel.closes, "attempts": review.choice_attempts,
		"loop": review.loop_state, "runs": review.runs_started, "pickup": review.automatic_pickup,
		"grid": review.grid_visible, "camera": review.camera_rig.distance_metres,
		"attacks": review.player.attack.uses_started, "destination": review.player.has_destination,
		"experience": review.mote_runtime.experience(), "level": review.mote_runtime.level(),
		"active": review.mote_runtime.is_offer_active(), "lanes": review.mote_runtime.offer_lanes(),
	}


# --- 12. On screen ------------------------------------------------------------------------------------

func _check_the_panel_is_legible_and_unobstructed() -> void:
	print("")
	print("--- 12. The panel is on screen, readable, its three cards apart, and above every other surface")
	await _await_process_frames(4)
	var viewport: Rect2 = Rect2(Vector2.ZERO, Vector2(get_viewport().get_visible_rect().size))
	var panel: RiftLevelUpOfferPanel = review.level_up_panel
	var controls: Array[Control] = panel.text_controls()
	var visible: int = 0
	for control: Control in controls:
		if control.is_visible_in_tree():
			visible += 1
	var shown: int = _measure_text(controls, viewport, "level-up panel")
	_expect(shown == visible and visible == controls.size() - 1, "%d of %d visible panel controls are on screen" % [shown, visible])
	var smallest: int = _smallest_font(controls)
	_expect(smallest >= 12, "a panel line is drawn at %d px" % smallest)
	var overlapping: int = 0
	for a: int in 3:
		for b: int in range(a + 1, 3):
			if panel.card_block(a).get_global_rect().intersects(panel.card_block(b).get_global_rect()):
				overlapping += 1
	var narrowest: float = 99999.0
	for slot: int in 3:
		narrowest = minf(narrowest, panel.card_block(slot).get_global_rect().size.x)
	_expect(overlapping == 0 and narrowest >= RiftLevelUpOfferPanel.CARD_WIDTH - 0.5,
		"%d card pair(s) overlap; the narrowest card is %.1f px" % [overlapping, narrowest])
	var content: Rect2 = (panel.get_node("Panel") as Control).get_global_rect()
	var nameplate: CanvasItem = review.get_node("CanvasLayer/GroundNameplate") as CanvasItem
	_expect(viewport.encloses(content) and panel.get_global_rect().encloses(viewport) and not nameplate.visible,
		"the panel %s leaves the viewport %s, its backdrop does not cover it, or the nameplate above it shows" % [
			content, viewport])
	print("  %d of %d visible text controls on screen, smallest %d px; 3 cards, 0 overlapping, each at least %.0f px wide; the backdrop covers the viewport and nothing visible draws above the panel"
		% [shown, visible, smallest, RiftLevelUpOfferPanel.CARD_WIDTH])
	print("  panel %s in a %s viewport" % [content, viewport.size])
	_done("the_panel_is_legible_and_unobstructed")


# --- 13. A refused choice -------------------------------------------------------------------------

func _check_a_refused_choice_keeps_the_same_offer_open() -> void:
	print("")
	print("--- 13. A refused choice keeps the panel open over the same offer, paused, showing the exact reason")
	var panel: RiftLevelUpOfferPanel = review.level_up_panel
	var offer_before: String = _offer_text()
	var cards_before: PackedStringArray = _cards_text()
	var refusals: int = review.choice_refusals
	## No card can produce an undeclared lane, so the runtime's own card entry point is
	## handed one directly.
	review.choose_offered_lane(UNDECLARED_LANE)
	var record: RiftRunLevelUpResult = review.last_choice_record
	_expect(record != null and not record.succeeded() and record.failure_reason().begins_with(UNDECLARED_LANE_PREFIX)
			and record.run_seed == ROUTE_SEED and record.source_level == 1 and record.problem().is_empty(),
		"lane %d was answered %s" % [UNDECLARED_LANE, _record(record)])
	_expect(panel.is_open and get_tree().paused and review.choice_refusals == refusals + 1 and review.choices_taken == 0
			and panel.refusal_text() == "That choice was refused: %s" % record.failure_reason(),
		"the refusal closed the panel, resumed play or was not shown word for word: '%s'" % panel.refusal_text())
	_expect(_offer_text() == offer_before and _cards_text() == cards_before and review.mote_runtime.level() == 1
			and review.mote_runtime.experience() == LEVEL_ONE_REQUIREMENT
			and get_viewport().gui_get_focus_owner() == panel.card_buttons()[0],
		"the refusal moved the offer or the cards: %s" % _offer_text())
	print("  lane %d: '%s'; shown word for word; the same offer (%s) still open, paused, level 1, 100.0"
		% [UNDECLARED_LANE, record.failure_reason(), _offer_text()])
	_done("a_refused_choice_keeps_the_same_offer_open")


# --- 14. Support by keyboard ----------------------------------------------------------------------

func _check_support_by_keyboard_advances_once_and_matches_g4() -> void:
	print("")
	print("--- 14. Enter on the focused Support card records the pair exactly as G4 does, closes, resumes, and advances once")
	var twin: RiftRunLevelCoordinator = _twin_opened(4)
	var expected: RiftRunLevelUpResult = twin.choose(RiftOffer.Lane.SUPPORT)
	var before: Dictionary = _choice_counters()
	_push_key(KEY_ENTER, true)
	var taken: Dictionary = _taken_reading()
	_push_key(KEY_ENTER, false)
	await _await_process_frames(1)
	_expect_choice("A Support by Enter", RiftOffer.Lane.SUPPORT, twin, expected, taken, 0.0, before)

	## The escort, frozen mid-pursuit, moves again; its mote then pays into Level 2.
	var escort: PrototypeGraveblade = review.room_enemies[2][1]
	var paused_at: Vector3 = escort.global_position
	await _settle(8)
	var moved: float = _planar_gap(escort.global_position, paused_at)
	_expect(escort.is_alive() and moved > 0.0 and review.sweeps_made > int(before["sweeps"]),
		"play did not resume: the escort moved %.3f m and %d sweep(s) ran" % [moved, review.sweeps_made - int(before["sweeps"])])
	var fell_at: Vector3 = escort.global_position
	_kill(escort)
	_stand(fell_at)
	await _settle(3)
	await _expect_no_second_offer("A", LEVEL_TWO_REQUIREMENT, REVIEW_AMOUNT)
	_top_speeds.append(await _top_speed(_far_side(_rounded(review.room_modules[2].room_centres()[0]))))
	print("  after the choice the escort moved %.2f m again and its mote paid 25.0 into Level 2" % moved)
	_done("support_by_keyboard_advances_once_and_matches_g4")


# --- 15. The receipt on screen -----------------------------------------------------------------------

func _check_the_receipt_is_legible_and_play_resumes() -> void:
	print("")
	print("--- 15. The receipt reads in the review panel, clear of every other surface; play has resumed")
	await _capture("02_support_receipt", DEATH_CLIP_SETTLE_SECONDS)
	await _await_process_frames(4)
	var viewport: Rect2 = Rect2(Vector2.ZERO, Vector2(get_viewport().get_visible_rect().size))
	var controls: Array[Control] = review.receipt_controls()
	var shown: int = _measure_text(controls, viewport, "receipt")
	var host: Rect2 = review.experience_hud.panel.get_global_rect()
	var outside_host: int = 0
	for control: Control in controls:
		if control.is_visible_in_tree() and not host.encloses(control.get_global_rect()):
			outside_host += 1
	_expect(shown == 5 and not _receipt_visible(RECEIPT_STATUS) and outside_host == 0 and viewport.encloses(host),
		"%d receipt lines on screen, %d outside the review panel %s" % [shown, outside_host, host])
	_expect(_receipt_text(RECEIPT_TITLE) == "Temporary build — this expedition"
			and _receipt_text(RECEIPT_CHOICE) == EXPECTED_CHOICES[0]
			and _receipt_text(RECEIPT_PROGRESSION) == SUPPORT_PROGRESSION
			and _receipt_text(RECEIPT_LEVEL) == "Rift level 1 → 2 · 0 XP carried over"
			and _receipt_text(RECEIPT_NOTE_LINE) == RECEIPT_NOTE,
		"the receipt reads %s" % str(_receipt_lines()))
	_expect(_smallest_font(controls) >= 12, "a receipt line is drawn below 12 px")
	_expect(not get_tree().paused and not review.player.awaiting_neutral and _hud_text(HUD_EXPERIENCE) == "XP 25 / 125",
		"play has not resumed: paused %s, awaiting neutral %s, '%s'" % [str(get_tree().paused),
			str(review.player.awaiting_neutral), _hud_text(HUD_EXPERIENCE)])

	## Every other surface, with its transient parts forced visible while a modal holds
	## the world still so nothing per-frame can hide them again — H9's own measurement.
	var overlaps: PackedStringArray = PackedStringArray()
	var measured: int = 0
	var overlay: RogueliteFallenOverlay = review.fallen_overlay as RogueliteFallenOverlay
	overlay.open_for(DamageEvent.physical(_use(), review.graveblades[0], review.player, 125.0))
	review.run_hud.show_gate_prompt("Rift Gate sealed — clear the room", false)
	review.hud.show_item_prompt("Expedition Blade — Left click")
	review.hud.show_message("Elite Hall — A heavier Graveblade, and one escort.")
	await _await_process_frames(4)
	for surface: Control in [review.hud, review.run_hud]:
		for child: Node in surface.get_children():
			var control: Control = child as Control
			if control == null or not control.is_visible_in_tree():
				continue
			measured += 1
			if control.get_global_rect().intersects(host):
				overlaps.append("%s/%s" % [surface.name, control.name])
	for control: Control in overlay.text_controls():
		if control.is_visible_in_tree():
			measured += 1
			if control.get_global_rect().intersects(host):
				overlaps.append("Fallen/%s" % control.name)
	overlay.close("verification")
	review.run_hud.show_gate_prompt("", false)
	review.hud.show_item_prompt("")
	await _await_process_frames(2)
	review.summary_panel.open_for(review.run_state)
	await _await_process_frames(4)
	for control: Control in review.summary_panel.text_controls():
		if control.is_visible_in_tree():
			measured += 1
			if control.get_global_rect().intersects(host):
				overlaps.append("Summary/%s" % control.name)
	review.summary_panel.close("verification")
	await _await_process_frames(2)
	var centre: Rect2 = Rect2(viewport.size * 0.25, viewport.size * 0.5)
	_expect(overlaps.is_empty() and measured >= 15 and not host.intersects(centre)
			and not get_tree().paused and not review.fallen_overlay.is_open and not review.summary_panel.is_open,
		"the review panel with its receipt overlaps %s (of %d measured) or the centre, or a measured modal was left open"
			% [", ".join(overlaps), measured])
	print("  %s; smallest %d px; inside the review panel, clear of %d other surfaces and the centre; not paused, neutral, 'XP 25 / 125'"
		% [" | ".join(_receipt_lines()), _smallest_font(controls), measured])
	print("  review panel %s in a %s viewport" % [host, viewport.size])
	_done("the_receipt_is_legible_and_play_resumes")


# --- 16. A pending mote -------------------------------------------------------------------------------

func _check_a_pending_in_range_mote_waits_untouched() -> void:
	print("")
	print("--- 16. A pending mote under the player stays uncollected, and experience stays at 100, while the panel is open")
	var centre: Vector3 = _rounded(review.room_modules[2].room_centres()[0])
	var near: Vector3 = centre - Vector3(4.0, 0.0, 0.0)
	var far: Vector3 = centre + Vector3(4.0, 0.0, 0.0)
	await _open_at(near, far, false)
	_expect(review.level_up_panel.is_open and review.mote_runtime.experience() == LEVEL_ONE_REQUIREMENT
			and review.mote_runtime.uncollected_count() == 1,
		"the offer did not open at 100 with the escort's mote pending: %s" % _state())
	## STAGED: the world is paused, so a player cannot walk here; the harness places them.
	review._place_player_at(far, review.route_forward(), "verification staging onto a pending mote")
	var gap: float = _planar_gap(review.player.global_position, review.marker_drop_position(4))
	var sweeps: int = review.sweeps_made
	await _settle(30)
	await _await_process_frames(10)
	_expect(gap == 0.0 and review.sweeps_made == sweeps and review.mote_runtime.uncollected_count() == 1
			and review.mote_runtime.experience() == LEVEL_ONE_REQUIREMENT and review.marker_is_shown(4)
			and not review.marker_is_collected(4) and review.level_up_panel.is_open and get_tree().paused,
		"the pending mote was touched while the panel was open: %s" % _state())
	print("  the player placed %.2f m from the escort's pending mote; 40 frames: 0 sweeps, still 1 uncollected, experience 100.0, its marker shown"
		% gap)
	_done("a_pending_in_range_mote_waits_untouched")


# --- 17. Combat and Defence by controller -----------------------------------------------------------

func _check_combat_and_defence_by_controller_advances_once_and_matches_g4() -> void:
	print("")
	print("--- 17. The D-pad and (A) take Combat and Defence exactly as G4 does; the pending mote pays only afterwards")
	var twin: RiftRunLevelCoordinator = _twin_opened(4)
	var expected: RiftRunLevelUpResult = twin.choose(RiftOffer.Lane.COMBAT_DEFENCE)
	await _joy(JOY_BUTTON_DPAD_RIGHT)
	_expect(get_viewport().gui_get_focus_owner() == review.level_up_panel.card_buttons()[1],
		"the D-pad did not move focus to card 2")
	var before: Dictionary = _choice_counters()
	_push_joy(JOY_BUTTON_A, true)
	var taken: Dictionary = _taken_reading()
	_push_joy(JOY_BUTTON_A, false)
	await _await_process_frames(1)
	_expect_choice("B Combat and Defence by (A)", RiftOffer.Lane.COMBAT_DEFENCE, twin, expected, taken, 0.0, before)
	await _settle(3)
	_expect(review.last_collection_result != null
			and review.last_collection_result.collected_indices() == PackedInt32Array([4]),
		"the pending mote was not the first thing collected after the choice")
	await _expect_no_second_offer("B", LEVEL_TWO_REQUIREMENT, REVIEW_AMOUNT)
	await _capture("03_passive_receipt", DEATH_CLIP_SETTLE_SECONDS)
	_top_speeds.append(await _top_speed(_far_side(_rounded(review.room_modules[2].room_centres()[0]))))
	print("  the first sweep after the choice collected [4] and paid 25.0 into Level 2")
	_done("combat_and_defence_by_controller_advances_once_and_matches_g4")


# --- 18. Utility by mouse ------------------------------------------------------------------------------

func _check_utility_by_mouse_advances_once_and_matches_g4() -> void:
	print("")
	print("--- 18. A left click on the Utility card takes it exactly as G4 does")
	var centre: Vector3 = _rounded(review.room_modules[2].room_centres()[0])
	var near: Vector3 = centre - Vector3(4.0, 0.0, 0.0)
	var far: Vector3 = centre + Vector3(4.0, 0.0, 0.0)
	await _open_at(near, far, false)
	var twin: RiftRunLevelCoordinator = _twin_opened(4)
	var expected: RiftRunLevelUpResult = twin.choose(RiftOffer.Lane.UTILITY)
	var button: Button = review.level_up_panel.card_buttons()[2]
	var before: Dictionary = _choice_counters()
	_hover(button)
	await _await_process_frames(1)
	## First-MVP UI J1 (D-322): the press reaches the card through the shared modal contract,
	## so what is read is the card itself — the control under the pointer is card 3's own
	## button, and the click is exactly one choice attempt.
	var under: Control = get_viewport().gui_get_hovered_control()
	var at: Vector2 = button.get_global_rect().get_center()
	_push_mouse(at, MOUSE_BUTTON_LEFT, true)
	_push_mouse(at, MOUSE_BUTTON_LEFT, false)
	var taken: Dictionary = _taken_reading()
	await _await_process_frames(1)
	_expect(under == button and review.choice_attempts == int(before["attempts"]) + 1,
		"the left press did not reach the card under the pointer exactly once")
	_expect_choice("C Utility by left click", RiftOffer.Lane.UTILITY, twin, expected, taken, 0.0, before)
	_stand(far)
	await _settle(3)
	await _expect_no_second_offer("C", LEVEL_TWO_REQUIREMENT, REVIEW_AMOUNT)
	_top_speeds.append(await _top_speed(near))
	print("  the click at (%.0f, %.0f) reached card 3's own button; walking to the escort's mote then paid 25.0 into Level 2" % [at.x, at.y])
	_done("utility_by_mouse_advances_once_and_matches_g4")


# --- 19. From 125 ------------------------------------------------------------------------------------

func _check_from_125_every_lane_retains_25() -> void:
	print("")
	print("--- 19. Five motes in one sweep reach 125; each lane, chosen from 125, leaves Level 2 with exactly 25")
	var labels: PackedStringArray = PackedStringArray(["D", "E", "F"])
	for lane: int in RiftOffer.LANE_ORDER:
		var label: String = labels[lane]
		await _begin_expedition(label)
		await _route_to_the_elite_hall()
		var centre: Vector3 = _rounded(review.room_modules[2].room_centres()[0])
		await _open_at(centre - Vector3(1.0, 0.0, 0.0), centre + Vector3(1.0, 0.0, 0.0), true)
		_expect(review.level_up_panel.is_open and review.mote_runtime.experience() == 5.0 * REVIEW_AMOUNT
				and review.mote_runtime.level() == 1 and review.mote_runtime.frozen_offer_requirement() == LEVEL_ONE_REQUIREMENT
				and review.last_collection_result != null
				and review.last_collection_result.collected_indices() == PackedInt32Array([3, 4]),
			"%s: one sweep did not reach 125 and open the panel at Level 1: %s" % [label, _state()])
		var twin: RiftRunLevelCoordinator = _twin_opened(5)
		var expected: RiftRunLevelUpResult = twin.choose(lane)
		## Support by Enter; Combat and Defence by Right then Enter; Utility by Left,
		## which wraps from the first card to the third.
		if lane == RiftOffer.Lane.COMBAT_DEFENCE:
			await _key(KEY_RIGHT)
		elif lane == RiftOffer.Lane.UTILITY:
			await _key(KEY_LEFT)
		_expect(get_viewport().gui_get_focus_owner() == review.level_up_panel.card_buttons()[lane],
			"%s: the keyboard did not focus card %d" % [label, lane + 1])
		var before: Dictionary = _choice_counters()
		_push_key(KEY_ENTER, true)
		var taken: Dictionary = _taken_reading()
		_push_key(KEY_ENTER, false)
		await _await_process_frames(1)
		_expect_choice("%s %s from 125" % [label, RiftOffer.lane_label(lane)], lane, twin, expected, taken, REVIEW_AMOUNT, before)
		await _expect_no_second_offer(label, LEVEL_TWO_REQUIREMENT, REVIEW_AMOUNT)
		await _end_expedition(label)
	print("  3 of 3 lanes chosen from 125 left Level 2 with 25 retained, 'Rift level 1 → 2 · 25 XP carried over', and opened nothing more")
	_done("from_125_every_lane_retains_25")


# --- 20. A refused opening ------------------------------------------------------------------------------

func _check_a_refused_opening_is_shown_once_and_never_retried() -> void:
	print("")
	print("--- 20. A refused opening is asked once, shown in the review panel, and never asked again")
	await _begin_expedition("G")
	await _route_to_the_elite_hall()
	_quiet_room(2)
	await _set_pickup(false)
	var centre: Vector3 = _rounded(review.room_modules[2].room_centres()[0])
	var elite: PrototypeGraveblade = review.room_enemies[2][0]
	elite.place_at(centre)
	_stand(centre)
	_kill(elite)
	## STAGED: the harness sweeps the runtime and opens its offer itself, so the
	## review's own one attempt meets G4's refusal. No real route can produce it.
	var swept: RiftMoteSweepResult = review.mote_runtime.sweep_at(centre)
	var opened: String = review.mote_runtime.open_level_up_offer(SkillSupportCatalogue.skill_profiles(),
		SkillSupportCatalogue.support_definitions(), PassiveCardCatalogue.records())
	var calls: int = review.offer_open_calls
	var refusals: int = review.offer_open_refusals
	await _settle(3)
	_expect(swept.ok and swept.collected_indices() == PackedInt32Array([3]) and opened.is_empty()
			and review.mote_runtime.experience() == LEVEL_ONE_REQUIREMENT,
		"the staging did not reach 100 and open an offer: %s / '%s'" % [str(swept.collected_indices()), opened])
	_expect(review.offer_open_calls == calls + 1 and review.offer_open_refusals == refusals + 1
			and review.last_offer_refusal == ALREADY_OPEN and review.offer_attempted()
			and not review.level_up_panel.is_open and not get_tree().paused,
		"the review's attempt was not asked once and refused: %s" % _state())
	_expect(_hud_text(HUD_REFUSAL) == "Last refusal: level-up offer did not open — %s" % ALREADY_OPEN
			and _receipt_visible(RECEIPT_STATUS)
			and _receipt_text(RECEIPT_STATUS) == "The level-up offer did not open: %s" % ALREADY_OPEN,
		"the refusal is not shown: '%s' / '%s'" % [_hud_text(HUD_REFUSAL), _receipt_text(RECEIPT_STATUS)])
	await _settle(60)
	await _await_process_frames(10)
	_expect(review.offer_open_calls == calls + 1 and not review.level_up_panel.is_open,
		"the opening was asked again: %d call(s)" % (review.offer_open_calls - calls))
	print("  1 opening asked and refused with '%s'; shown as '%s'; 70 frames later still 1, no panel, not paused"
		% [review.last_offer_refusal, _hud_text(HUD_REFUSAL)])
	await _end_expedition("G")
	_done("a_refused_opening_is_shown_once_and_never_retried")


# --- 21. The live character ----------------------------------------------------------------------------

func _check_live_movement_and_quick_strike_are_unchanged() -> void:
	print("")
	print("--- 21. The live character's movement and Quick Strike are the accepted ones before and after every choice")
	_expect(is_equal_approx(float(_baseline["max_speed"]), ACCEPTED_MAX_SPEED)
			and is_equal_approx(float(_baseline["action_time"]), ACCEPTED_ACTION_TIME)
			and is_equal_approx(float(_baseline["effective_action_time"]), ACCEPTED_ACTION_TIME)
			and is_equal_approx(float(_baseline["reach"]), ACCEPTED_REACH)
			and is_equal_approx(float(_baseline["arc"]), ACCEPTED_ARC)
			and is_equal_approx(float(_baseline["cone"]), ACCEPTED_CONE)
			and float(_baseline["increased_attack_speed"]) == 0.0,
		"the baseline is not the accepted character: %s" % str(_baseline))
	var differing: int = 0
	for after: Dictionary in _live_after:
		if after != _baseline:
			differing += 1
	_expect(_live_after.size() == 6 and differing == 0, "%d of %d after-choice readings differ" % [differing, _live_after.size()])
	var speeds: PackedStringArray = PackedStringArray()
	var off: int = 0
	for speed: float in _top_speeds:
		speeds.append("%.3f" % speed)
		if absf(speed - ACCEPTED_MAX_SPEED) > SPEED_TOLERANCE:
			off += 1
	_expect(_top_speeds.size() == 4 and off == 0, "the measured top speeds were %s" % ", ".join(speeds))
	print("  max speed %.1f m/s, action time %.2f s (effective %.2f s), reach %.2f m, arc %.0f deg, cone %.0f deg, +%.0f%% attack speed — identical after all 6 choices"
		% [float(_baseline["max_speed"]), float(_baseline["action_time"]), float(_baseline["effective_action_time"]),
			float(_baseline["reach"]), float(_baseline["arc"]), float(_baseline["cone"]),
			100.0 * float(_baseline["increased_attack_speed"])])
	print("  measured top walking speed before any choice and after Support, Combat and Defence and Utility: %s m/s"
		% ", ".join(speeds))
	_done("live_movement_and_quick_strike_are_unchanged")


# --- 22. Teardown ------------------------------------------------------------------------------------

func _check_teardown_clears_every_expedition_offer_state() -> void:
	print("")
	print("--- 22. Every expedition's end cleared its attempt, record, receipt and panel")
	_expect(_teardowns.size() == EXPECTED_EXPEDITIONS and _expeditions == EXPECTED_EXPEDITIONS
			and _staged_plans == EXPECTED_EXPEDITIONS - 1,
		"%d teardown(s) of %d expedition(s), %d staged" % [_teardowns.size(), _expeditions, _staged_plans])
	print("  %d of %d expeditions (%s) ended by F5 with no attempt, record or receipt left, the panel closed and the world running"
		% [_teardowns.size(), EXPECTED_EXPEDITIONS, ", ".join(_teardowns)])
	_done("teardown_clears_every_expedition_offer_state")


# --- 23. Nothing restated, nothing written -------------------------------------------------------------

func _check_the_review_restates_no_mechanism_and_writes_nothing() -> void:
	print("")
	print("--- 23. The runtime restates no mechanism and touches no live value; nothing names storage or an asset")
	var bare: String = _bare(FileAccess.get_file_as_string(REVIEW_SCRIPT))
	var restated: PackedStringArray = PackedStringArray()
	for token: String in RESTATED_TOKENS:
		if bare.contains(token):
			restated.append(token)
	_expect(restated.is_empty(), "the runtime names %s" % ", ".join(restated))
	var panel_bare: String = _bare(FileAccess.get_file_as_string(PANEL_SCRIPT))
	_expect(not panel_bare.contains("paused") and not panel_bare.contains("InputMap")
			and panel_bare.count("_runtime.") == 1,
		"the panel pauses, reads the InputMap or reaches the runtime more than once")
	var storage: PackedStringArray = PackedStringArray()
	var assets: PackedStringArray = PackedStringArray()
	for path: String in [REVIEW_SCRIPT, PANEL_SCRIPT, REVIEW_SCENE_FILE]:
		var raw: String = FileAccess.get_file_as_string(path)
		var code: String = _bare(raw) if path.ends_with(".gd") else "\n".join(_scene_statements(raw))
		for token: String in STORAGE_TOKENS:
			if code.contains(token):
				storage.append("%s: %s" % [path.get_file(), token])
		for token: String in ASSET_TOKENS:
			if raw.contains(token):
				assets.append("%s: %s" % [path.get_file(), token])
	_expect(storage.is_empty() and assets.is_empty(), "storage %s; assets %s" % [", ".join(storage), ", ".join(assets)])
	var own: String = FileAccess.get_file_as_string("res://tests/roguelite_level_up_choice_review_verification.gd")
	var found_here: int = 0
	for token: String in RESTATED_TOKENS + CONCRETE_TOKENS:
		if own.contains(token):
			found_here += 1
	_expect(found_here > 30, "the scans found only %d of their own tokens in this file and may be inert" % found_here)
	print("  0 of %d restated tokens in the runtime; the panel reaches the runtime once and pauses nothing itself; 0 storage and 0 asset tokens in the runtime, the panel and the scene"
		% RESTATED_TOKENS.size())
	_done("the_review_restates_no_mechanism_and_writes_nothing")


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


# --- Expeditions -----------------------------------------------------------------------------------------

## STAGED for every expedition after the first: the Nexus's next plan is replaced by a
## fresh plan of the route's seed, so each expedition is an equivalent fresh one.
func _begin_expedition(label: String) -> void:
	if review.plan.seed_value != ROUTE_SEED:
		review.plan = RogueliteRunPlan.new(ROUTE_SEED, review.plan.run_index)
		review._refresh_run_hud()
		_staged_plans += 1
	_calls_at_expedition_start = review.offer_open_calls
	await _walk_into_gate(review.hub_module.exit_point())
	_expeditions += 1
	_expect(review.loop_state == RogueliteCoreLoopRuntime.LoopState.IN_RUN and review.run_state.current_room_index == 0
			and review.mote_runtime != null and review.mote_runtime.run_seed() == ROUTE_SEED
			and review.mote_runtime.level() == 1 and review.mote_runtime.experience() == 0.0
			and not review.offer_attempted() and not review.level_up_panel.is_open and _receipt_visible_count() == 0,
		"expedition %s did not begin fresh at seed %d: %s" % [label, ROUTE_SEED, _state()])
	await _set_pickup(true)


## Clears the Teaching Hall and the Cache Room at the player's feet with pickup on,
## and walks into the Elite Hall at 75.
func _route_to_the_elite_hall() -> void:
	for index: int in [0, 1]:
		_quiet_room(index)
		var centre: Vector3 = _rounded(review.room_modules[index].room_centres()[0])
		_stand(centre)
		for enemy: PrototypeGraveblade in review.room_enemies[index]:
			enemy.place_at(centre)
			_kill(enemy)
		await _settle(3)
		await _walk_into_gate(review.room_modules[index].exit_point())
	_expect(review.run_state.current_room_index == 2 and review.mote_runtime.experience() == 3.0 * REVIEW_AMOUNT
			and not review.offer_attempted(),
		"the route did not reach the Elite Hall at 75: %s" % _state())


## With pickup off, the Elite dies at `elite_at` and the escort at `escort_at`; the
## player stands at `elite_at` and pickup turns on. With `both` the escort's mote is
## in range too.
func _open_at(elite_at: Vector3, escort_at: Vector3, both: bool) -> void:
	_quiet_room(2)
	await _set_pickup(false)
	var elite: PrototypeGraveblade = review.room_enemies[2][0]
	var escort: PrototypeGraveblade = review.room_enemies[2][1]
	elite.place_at(elite_at)
	escort.place_at(escort_at)
	_kill(elite)
	_kill(escort)
	_stand((elite_at + escort_at) * 0.5 if both else elite_at)
	await _set_pickup(true)
	await _settle(3)


func _end_expedition(label: String) -> void:
	await _key(KEY_F5)
	await _settle(4)
	_expect(review.loop_state == RogueliteCoreLoopRuntime.LoopState.HUB and review.mote_runtime == null
			and not review.offer_attempted() and review.last_choice_record == null and review.last_offer_refusal.is_empty()
			and _receipt_visible_count() == 0 and not review.level_up_panel.is_open and not get_tree().paused
			and _hud_text(HUD_LEVEL) == "No expedition in progress",
		"expedition %s's end left offer state behind: %s" % [label, _state()])
	_teardowns.append(label)


# --- Choices --------------------------------------------------------------------------------------------

func _choice_counters() -> Dictionary:
	return {
		"attempts": review.choice_attempts, "taken": review.choices_taken, "calls": review.offer_open_calls,
		"sweeps": review.sweeps_made,
	}


## Read in the same call stack as the activating input, before any frame passes.
func _taken_reading() -> Dictionary:
	return {
		"open": review.level_up_panel.is_open, "paused": get_tree().paused,
		"active": review.mote_runtime.is_offer_active(), "level": review.mote_runtime.level(),
		"experience": review.mote_runtime.experience(),
		"hud_level": _hud_text(HUD_LEVEL), "hud_experience": _hud_text(HUD_EXPERIENCE),
	}


## Everything one successful choice owes: G4's own record, the panel closed and play
## resumed by that very input, one level, the right surplus, the progression, the
## seed spent once, the receipt, and the live character unchanged.
func _expect_choice(
	label: String, lane: int, twin: RiftRunLevelCoordinator, expected: RiftRunLevelUpResult,
	taken: Dictionary, retained: float, before: Dictionary
) -> void:
	var record: RiftRunLevelUpResult = review.last_choice_record
	var receipt: RiftLevelUpResult = null if record == null else record.level_up()
	var identity: PackedStringArray = PackedStringArray(SEED_99_IDENTITIES[lane])
	_expect(record != null and receipt != null and record.succeeded() and record.problem().is_empty()
			and record.run_seed == ROUTE_SEED and record.source_level == 1 and receipt.lane == lane
			and receipt.root_seed_known and receipt.root_seed == ROUTE_SEED and receipt.granted_identity() == identity
			and _record(record) == _record(expected),
		"%s answered %s where G4 answered %s" % [label, _record(record), _record(expected)])
	_expect(not bool(taken["open"]) and not bool(taken["paused"]) and not bool(taken["active"])
			and review.choice_attempts == int(before["attempts"]) + 1 and review.choices_taken == int(before["taken"]) + 1
			and review.offer_open_calls == int(before["calls"]),
		"%s did not close the panel and resume play in the same input: %s" % [label, str(taken)])
	_expect(int(taken["level"]) == 2 and float(taken["experience"]) == retained
			and review.last_retained_experience == retained and twin.level() == 2 and twin.experience() == retained,
		"%s left level %d with %s, not level 2 with %s" % [label, int(taken["level"]), str(taken["experience"]), str(retained)])
	## H9's own panel, refreshed by the choice itself, reads the new level at once.
	_expect(String(taken["hud_level"]) == "Rift level 2"
			and String(taken["hud_experience"]) == "XP %d / %d" % [int(retained), int(LEVEL_TWO_REQUIREMENT)],
		"%s: the review panel read '%s' / '%s' right after the choice" % [label, taken["hud_level"], taken["hud_experience"]])
	var build: RiftRunBuild = twin.run_build()
	if lane == RiftOffer.Lane.SUPPORT:
		_expect(receipt != null and receipt.carries_support_progression()
				and receipt.support_progression_line() == SUPPORT_PROGRESSION
				and build.support_rank_for(StringName(identity[0]), StringName(identity[1])) == 1
				and build.passive_acquisitions() == 0,
			"%s carried no new pair at rank 1" % label)
	else:
		_expect(receipt != null and not receipt.carries_support_progression()
				and build.acquisitions_for(StringName(identity[0])) == 1 and build.support_count() == 0,
			"%s did not record exactly one %s" % [label, identity[0]])
	var again: RiftRunLevelUpResult = review.mote_runtime.choose_level_up_lane(lane)
	_expect(twin.consumption_ledger().count() == 1 and twin.consumption_ledger().has_consumed(ROUTE_SEED)
			and not again.succeeded() and again.failure_reason() == NO_OFFER and review.mote_runtime.level() == 2,
		"%s: root seed %d was not spent exactly once (%s)" % [label, ROUTE_SEED, again.failure_reason()])
	var level_line: String = "Rift level 1 → 2 · %d XP carried over" % int(retained)
	_expect(review.receipt_text("choice") == EXPECTED_CHOICES[lane] and review.receipt_text("level") == level_line
			and review.receipt_text("progression") == (SUPPORT_PROGRESSION if lane == RiftOffer.Lane.SUPPORT else ""),
		"%s's receipt reads '%s' / '%s' / '%s'" % [label, review.receipt_text("choice"),
			review.receipt_text("progression"), review.receipt_text("level")])
	var live: Dictionary = _live_values()
	_live_after.append(live)
	_expect(live == _baseline, "%s moved the live character: %s against %s" % [label, str(live), str(_baseline)])
	print("  %s: granted [%s] from root seed %d — %s; level 1 -> 2 with %s retained; the same record as G4's; taken again: '%s'; receipt '%s'"
		% [label, ", ".join(receipt.granted_identity()), receipt.root_seed, receipt.support_progression_line(),
			_amount_text(retained), again.failure_reason(), review.receipt_text("choice")])


## After a choice, frames pass and the run's experience moves only as a mote pays;
## no second opening is asked and no panel opens.
func _expect_no_second_offer(label: String, requirement: float, experience: float) -> void:
	await _settle(30)
	await _await_process_frames(6)
	var g1: RiftLevelRequirementReading = RiftLevelRequirementCurve.requirement_for(2)
	_expect(review.offer_open_calls == _calls_at_expedition_start + 1 and not review.level_up_panel.is_open
			and not get_tree().paused and not review.mote_runtime.is_offer_active()
			and review.mote_runtime.level() == 2 and review.mote_runtime.experience() == experience
			and g1.ok and float(g1.requirement) == requirement,
		"%s: a second offer was asked or the run moved: %s" % [label, _state()])


## A directly driven G4 run of the route's seed, given the same experience in the
## review's amount and opened from the same catalogues.
func _twin_opened(motes: int) -> RiftRunLevelCoordinator:
	var twin: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(ROUTE_SEED)
	for mote: int in motes:
		_expect_quiet(twin.award_experience(REVIEW_AMOUNT).is_empty(), "the twin refused an award")
	_expect_quiet(twin.open_current_offer(SkillSupportCatalogue.skill_profiles(), SkillSupportCatalogue.support_definitions(),
		PassiveCardCatalogue.records()).is_empty(), "the twin did not open its offer")
	return twin


# --- The live character ------------------------------------------------------------------------------------

func _live_values() -> Dictionary:
	var strike: QuickStrikeData = review.player.attack.data
	return {
		"max_speed": review.player.max_speed,
		"increased_attack_speed": review.player.increased_attack_speed(),
		"effective_action_time": review.player.attack.effective_action_time(),
		"action_time": strike.action_time,
		"reach": strike.reach,
		"arc": strike.release_arc_degrees,
		"cone": strike.soft_target_cone_degrees,
		"weapon_damage": review.player.weapon.physical_damage,
	}


## Commands a real walk of several metres and returns the highest planar speed the
## character reached, then puts it back.
func _top_speed(to: Vector3) -> float:
	var from: Vector3 = review.player.global_position
	for frame: int in 20:
		if not review.player.awaiting_neutral:
			break
		await _await_process_frames(1)
	var resolved: Dictionary = PrototypeGroundPointer.resolve_to_navigation(review.navigation_map(), to)
	review.player.command_move_to(resolved["point"], to, bool(resolved["adjusted"]))
	var top: float = 0.0
	for frame: int in 50:
		await get_tree().physics_frame
		top = maxf(top, review.player.planar_speed())
	_stand(from)
	await _settle(2)
	return top


## Whichever of the two Elite Hall spots is farther from where the player stands.
func _far_side(centre: Vector3) -> Vector3:
	var left: Vector3 = centre - Vector3(4.0, 0.0, 0.0)
	var right: Vector3 = centre + Vector3(4.0, 0.0, 0.0)
	var here: Vector3 = review.player.global_position
	return left if _planar_gap(here, left) > _planar_gap(here, right) else right


# --- Input, through the viewport ------------------------------------------------------------------------------

func _push_key(keycode: Key, pressed: bool) -> void:
	var event: InputEventKey = InputEventKey.new()
	event.keycode = keycode
	event.physical_keycode = keycode
	event.pressed = pressed
	get_viewport().push_input(event)


func _key(keycode: Key) -> void:
	_push_key(keycode, true)
	_push_key(keycode, false)
	await _await_process_frames(1)


func _push_joy(button: JoyButton, pressed: bool) -> void:
	var event: InputEventJoypadButton = InputEventJoypadButton.new()
	event.device = 0
	event.button_index = button
	event.pressed = pressed
	get_viewport().push_input(event)


func _joy(button: JoyButton) -> void:
	_push_joy(button, true)
	_push_joy(button, false)
	await _await_process_frames(1)


## A pointer movement over `control`, in the viewport's own coordinates, so the GUI's
## hovered control is updated the way a real pointer updates it.
func _hover(control: Control) -> void:
	var at: Vector2 = control.get_global_rect().get_center()
	var motion: InputEventMouseMotion = InputEventMouseMotion.new()
	motion.position = at
	motion.global_position = at
	get_viewport().push_input(motion, true)


func _push_mouse(at: Vector2, button: MouseButton, pressed: bool) -> void:
	var click: InputEventMouseButton = InputEventMouseButton.new()
	click.button_index = button
	click.pressed = pressed
	click.position = at
	click.global_position = at
	get_viewport().push_input(click, true)


func _mouse_click(at: Vector2, button: MouseButton) -> void:
	var motion: InputEventMouseMotion = InputEventMouseMotion.new()
	motion.position = at
	motion.global_position = at
	get_viewport().push_input(motion, true)
	_push_mouse(at, button, true)
	_push_mouse(at, button, false)
	await _await_process_frames(1)


func _set_pickup(value: bool) -> void:
	if review.automatic_pickup != value:
		await _key(KEY_F8)
	_expect(review.automatic_pickup == value, "F8 did not turn automatic pickup %s" % ("ON" if value else "OFF"))


# --- Evidence -------------------------------------------------------------------------------------------------

## Adds no assertion: the rendered runs pin the same count as the headless one. It
## moves nothing, so a frame taken while the panel holds the world still shows it
## exactly as it stands.
func _capture(stem: String, settle_seconds: float = 0.0) -> void:
	if _shot_dir.is_empty():
		return
	if settle_seconds > 0.0:
		await get_tree().create_timer(settle_seconds).timeout
	await _await_process_frames(6)
	for i: int in 7:
		await RenderingServer.frame_post_draw
	var path: String = "%s/%s.png" % [_shot_dir, stem]
	get_viewport().get_texture().get_image().save_png(path)
	print("  screenshot: %s" % path)


func _argument_value(flag: String) -> String:
	var index: int = arguments.find(flag)
	if index == -1 or index + 1 >= arguments.size():
		return ""
	return arguments[index + 1]


# --- Helpers --------------------------------------------------------------------------------------------------

func _stand(at: Vector3) -> void:
	review.player.global_position = Vector3(at.x, 0.0, at.z)
	review.player.velocity = Vector3.ZERO
	review.player.clear_movement_intent("verification", false)
	review.camera_rig.focus = review.player.global_position


func _kill(enemy: PrototypeGraveblade) -> void:
	enemy.receive_damage(DamageEvent.physical(_use(), review.player, enemy, enemy.life + 1000.0))
	_deaths_driven += 1
	_expect_quiet(not enemy.is_alive(), "%s did not die from a lethal hit" % enemy.name)


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


func _state() -> String:
	if review.mote_runtime == null:
		return "no runtime; attempted=%s calls=%d open=%s paused=%s" % [
			str(review.offer_attempted()), review.offer_open_calls, str(review.level_up_panel.is_open), str(get_tree().paused)]
	return "level=%d experience=%s active=%s uncollected=%d calls=%d attempted=%s open=%s paused=%s refusal='%s'" % [
		review.mote_runtime.level(), _amount_text(review.mote_runtime.experience()),
		str(review.mote_runtime.is_offer_active()), review.mote_runtime.uncollected_count(), review.offer_open_calls,
		str(review.offer_attempted()), str(review.level_up_panel.is_open), str(get_tree().paused), review.last_offer_refusal]


func _offer_text() -> String:
	var parts: PackedStringArray = PackedStringArray()
	for lane: int in review.mote_runtime.offer_lanes():
		parts.append("%d:[%s]" % [lane, ", ".join(review.mote_runtime.offer_identity_for(lane))])
	return "root %d %s" % [review.mote_runtime.offer_root_seed(), " ".join(parts)]


func _cards_text() -> PackedStringArray:
	var shown: PackedStringArray = PackedStringArray()
	for slot: int in review.level_up_panel.card_count():
		shown.append("%d=%d %s" % [slot, review.level_up_panel.lane_for_slot(slot), " / ".join(review.level_up_panel.card_lines(slot))])
	return shown


## Every field of a run-level record and the copy of the receipt it carries, as one
## line — the shape the I1 suite compares records in.
func _record(record: RiftRunLevelUpResult) -> String:
	if record == null:
		return "no record"
	var receipt: RiftLevelUpResult = record.level_up()
	if receipt == null:
		return "run_seed=%d source=%d no receipt" % [record.run_seed, record.source_level]
	return "run_seed=%d source=%d succeeded=%s reason='%s' | ok=%s known=%s root=%d lane=%d identity=[%s] kind=%d ranks=%d->%d | problem='%s'" % [
		record.run_seed, record.source_level, str(record.succeeded()), record.failure_reason(),
		str(receipt.ok), str(receipt.root_seed_known), receipt.root_seed, receipt.lane,
		", ".join(receipt.granted_identity()), receipt.support_progression_kind, receipt.support_rank_before,
		receipt.support_rank_after, record.problem()]


func _amount_text(value: float) -> String:
	return "%.1f" % value


func _hud_text(index: int) -> String:
	return review.experience_hud.text_controls()[index].text


func _hud_visible(index: int) -> bool:
	return review.experience_hud.text_controls()[index].is_visible_in_tree()


func _receipt_text(index: int) -> String:
	return (review.receipt_controls()[index] as Label).text


func _receipt_visible(index: int) -> bool:
	return review.receipt_controls()[index].is_visible_in_tree()


func _receipt_visible_count() -> int:
	var shown: int = 0
	for control: Control in review.receipt_controls():
		if control.is_visible_in_tree():
			shown += 1
	return shown


func _receipt_lines() -> PackedStringArray:
	var lines: PackedStringArray = PackedStringArray()
	for control: Control in review.receipt_controls():
		if control.is_visible_in_tree():
			lines.append((control as Label).text)
	return lines


## A control's visible words: a Label's text, or a button's caption.
func _visible_text(control: Control) -> String:
	if control is Label:
		return (control as Label).text
	if control is Button:
		return _caption(control as Button)
	return ""


func _caption(button: Button) -> String:
	for child: Node in button.get_children():
		for grandchild: Node in child.get_children():
			var label: Label = grandchild as Label
			if label != null:
				return label.text
	return button.text


func _smallest_font(controls: Array[Control]) -> int:
	var smallest: int = 999
	for control: Control in controls:
		if not control.is_visible_in_tree():
			continue
		if control is Label:
			smallest = mini(smallest, control.get_theme_font_size("font_size"))
		elif control is Button:
			for child: Node in control.find_children("*", "Label", true, false):
				smallest = mini(smallest, (child as Label).get_theme_font_size("font_size"))
	return smallest


func _measure_text(controls: Array[Control], viewport: Rect2, label: String) -> int:
	var visible: int = 0
	for control: Control in controls:
		if control == null or not control.is_visible_in_tree():
			continue
		var rect: Rect2 = control.get_global_rect()
		var inside: bool = rect.size.x > 0.0 and rect.size.y > 0.0 and viewport.encloses(rect)
		_expect_quiet(inside, "%s: a visible control has no rectangle inside the viewport (%s)" % [label, rect])
		if inside:
			visible += 1
	return visible


func _names_in(source: String) -> PackedStringArray:
	var names: PackedStringArray = PackedStringArray()
	for entry: Dictionary in ProjectSettings.get_global_class_list():
		var id: String = String(entry.get("class", ""))
		if not id.is_empty() and source.contains(id):
			names.append(id)
	names.sort()
	return names


func _declared_functions(source: String) -> PackedStringArray:
	var names: PackedStringArray = PackedStringArray()
	var pattern: RegEx = RegEx.create_from_string("(?m)^(?:static )?func ([A-Za-z0-9_]+)\\(")
	for found: RegExMatch in pattern.search_all(source):
		names.append(found.get_string(1))
	return names


## The indented body of top-level function `name`, up to the next unindented line.
func _function_body(source: String, name: String) -> String:
	var body: PackedStringArray = PackedStringArray()
	var inside: bool = false
	for line: String in source.split("\n"):
		if line.begins_with("func %s(" % name) or line.begins_with("static func %s(" % name):
			inside = true
			continue
		if inside:
			if not line.is_empty() and not line.begins_with("\t") and not line.begins_with(" "):
				break
			body.append(line)
	return "\n".join(body)


## A scene file's statements: every line that is neither blank nor a `;` comment.
func _scene_statements(source: String) -> PackedStringArray:
	var kept: PackedStringArray = PackedStringArray()
	for line: String in source.split("\n"):
		var stripped: String = line.strip_edges()
		if stripped.is_empty() or stripped.begins_with(";"):
			continue
		kept.append(stripped)
	return kept


## Code with every comment line removed and every string literal emptied.
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


## Records a failure without adding to the pinned count, inside loops whose length is
## incidental.
func _expect_quiet(condition: bool, failure_message: String) -> void:
	if not condition:
		_failures.append(failure_message)


func _done(check_name: String) -> void:
	_reached[check_name] = true
