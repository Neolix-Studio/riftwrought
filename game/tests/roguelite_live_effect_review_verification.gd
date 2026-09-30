extends Node
## Riftwrought — Roguelite I3: Live Level-Up Effect Application Review V1: automated
## verification (decision D-295).
##
## THIS IS NOT A GATE, AND IT RE-PROVES NO FOUNDATION. C1, D2, G4, H8, I1, the
## catalogues, H9 and I2 prove their own mechanisms in their own suites. What only
## this suite can know is whether the LAYER behaves: that the seed-99 choice the
## accepted I2 panel takes is applied to the playable character from the run's WHOLE
## temporary build before another frame runs; that the live values are exactly C1's
## answers and the catalogue's rank-one review values; that the REAL Quick Strike, the
## REAL release query, the REAL controller soft-target search and REAL movement use
## them; that nothing compounds, nothing canonical is written and nothing uncovered is
## claimed; and that every way an expedition ends puts every baseline back.
##
## IT WALKS THE ROUTE FOUR TIMES, EVERY TIME WITH SEED 99, one lane per expedition:
##   A — Support (Sweeping Edge) by Enter, and the expedition ends by DEATH;
##   B — Combat and Defence (Celerity) by the D-pad and (A), and it ends by F5;
##   C — Utility (Fleetness) by a left click, and it ends by COMPLETION; then the
##       next expedition begins;
##   D — the focused mechanism: Reaching Edge's rank-one value, two targets inside
##       the wider arc, the whole build, the uncovered stats and every refusal, all
##       through the one seam on the live player — and it ends by F5.
##
## WHAT IS STAGED, STATED WHERE IT HAPPENS:
##   1. every expedition after the first is handed the route's seed again, by
##      replacing the Nexus's next run plan with a fresh plan of seed 99 before its
##      Rift Gate is entered (D-294 ruling 4 — a fresh run each time);
##   2. every Graveblade is placed with its own `place_at()` and its AI switched off,
##      so an angle, a distance and a Life can be measured exactly;
##   3. in D, and once in the Nexus before D begins, the HARNESS hands the seam a
##      build it composed itself — the only way to reach Reaching Edge, two held
##      cards of one kind, the uncovered stats and an unsupported rank, none of which
##      a seed-99 level-up can produce. Every live value those stagings move is read
##      back from the real actor, and the seam is the production seam.
##
## EVERY SWING IS THE REAL ONE: the controller's Quick Strike button pushed through
## the viewport, the accepted aim provider, the kernel's own phases and its one release
## query. Every expected value is a typed literal from the brief or the accepted
## mechanism's own answer — C1's `value_of()` asked directly, a G4 run driven directly.
##
## IT PORTS D-211's OWED-SET DISCIPLINE and GATE F's ON-SCREEN MEASUREMENT. The rendered
## evidence frames add NO assertion, so the headless and rendered runs pin one count.
##
## Run: godot --headless --path game res://scenes/roguelite/roguelite_live_effect_review.tscn -- --seed 99 --verify-live-effects

const REVIEW_SCRIPT: String = "res://scripts/roguelite/live_effects/roguelite_live_effect_review.gd"
const SEAM_SCRIPT: String = "res://scripts/roguelite/live_effects/rift_build_application.gd"
const RESULT_SCRIPT: String = "res://scripts/roguelite/live_effects/rift_build_application_result.gd"
const REVIEW_SCENE_FILE: String = "res://scenes/roguelite/roguelite_live_effect_review.tscn"
const I2_SCENE: String = "res://scenes/roguelite/roguelite_level_up_choice_review.tscn"
const I2_SCRIPT: String = "res://scripts/roguelite/level_up/roguelite_level_up_choice_review.gd"
const I2_PANEL_SCRIPT: String = "res://scripts/roguelite/level_up/rift_level_up_offer_panel.gd"
const H9_SCRIPT: String = "res://scripts/roguelite/experience/roguelite_experience_collection_review.gd"
const CORE_LOOP_SCRIPT: String = "res://scripts/roguelite/roguelite_core_loop_runtime.gd"
const SLICE_SCRIPT: String = "res://scripts/first_mvp/severed_threshold/broken_watch_slice.gd"
const H8_SCRIPT: String = "res://scripts/experience/rift_mote_runtime.gd"
const CANONICAL_QUICK_STRIKE: String = "res://data/prototype_zero/quick_strike.tres"
const PROJECT_SETTINGS_FILE: String = "res://project.godot"
const ENTRYPOINT: String = "res://scenes/app/prototype_app.tscn"
const THIS_FILE: String = "res://tests/roguelite_live_effect_review_verification.gd"

const ROUTE_SEED: int = 99
const REVIEW_AMOUNT: float = 25.0
const LEVEL_ONE_REQUIREMENT: float = 100.0
const LEVEL_TWO_REQUIREMENT: float = 125.0
const EXPECTED_ACTIONS: int = 31
const EXPECTED_EXPEDITIONS: int = 4

## The accepted live baselines (D-175, D-178 and the canonical Quick Strike record).
const ACCEPTED_MAX_SPEED: float = 5.0
const ACCEPTED_ACTION_TIME: float = 0.80
const ACCEPTED_REACH: float = 1.65
const ACCEPTED_ARC: float = 100.0
const ACCEPTED_CONE: float = 65.0
const ACCEPTED_MARGIN: float = 0.10
const ACCEPTED_MARKER: float = 0.325

## The I3 greybox rank-one review values and the one-card totals, typed from the brief.
const SWEPT_ARC: float = 180.0
const SWEPT_CONE: float = 110.0
const REACHED: float = 2.65
const ONE_CARD: float = 0.10
const FLEET_SPEED: float = 5.5
const SPEED_TOLERANCE: float = 0.01

## The controller's Quick Strike button (project.godot: joypad button 2).
const QUICK_STRIKE_BUTTON: JoyButton = JOY_BUTTON_X
## How far a target stands inside the arc, and outside reach but inside the cone.
const NEAR_TARGET: float = 1.2
const FAR_TARGET: float = 3.0
const SAMPLE_TICK: int = 8

const SEED_99_IDENTITIES: Array = [
	["quick_strike", "sweeping_edge"], ["card_celerity"], ["card_fleetness"],
]
const EXPECTED_CHOICES: Array[String] = [
	"Support — Quick Strike → Sweeping Edge",
	"Combat and Defence — Celerity (+10% Skill Speed)",
	"Utility — Fleetness (+10% Movement Speed)",
]
const SWEEPING_LIVE: String = "Live now — arc 100° → 180° · cone 65° → 110° · one target"
const CELERITY_LIVE: String = "Live now — action time 0.80 s → 0.727 s"
const FLEETNESS_LIVE: String = "Live now — movement speed 5.0 m/s → 5.5 m/s"
const EXPECTED_LIVE: Array[String] = [SWEEPING_LIVE, CELERITY_LIVE, FLEETNESS_LIVE]

## The receipt for builds no seed-99 choice produces, typed independently (D-297): the
## held stats sit under their own heading, and "Live now" heads only a written value.
## Roguelite I13 (D-318) made Global Damage live, so both builds moved one for one: the
## held-only build is now Vitality alone — Maximum Life is the one held stat left — and the
## build beside a written value is Power and Vitality, whose written value is the damage.
## Roguelite I14 (D-320) made Maximum Life live, so both builds moved one for one again: the only
## held stats left are the run's own mote-path stats, so the held-only build is Insight alone, and
## the build beside written values is Power, Vitality and Insight — damage and Maximum Life written,
## Experience Gain held on the run's own path.
const HELD_ONLY_RECEIPT: String = "Held, not live on the character:\nExperience Gain +10% — applied by the run's own mote path"
const MIXED_RECEIPT: String = "Live now — damage 100 → 110\nMaximum Life 500 → 575 · Life preserved at 100%\nHeld, not live on the character:\nExperience Gain +10% — applied by the run's own mote path"

const PANEL_NOTE: String = "Covered effects are applied immediately for this expedition. Final values and presentation are not locked."
const I2_GREYBOX_NOTE: String = "Choices are recorded in this expedition's temporary build. Applying their effects to the playable character is not part of this review."
const I2_RECEIPT_NOTE: String = "Recorded in the temporary build; not applied to the character in this review."
const RECEIPT_LIVE_NOTE: String = "Applied to the character now; every value returns to its baseline when this expedition ends."
const SUPPORT_PROGRESSION: String = "a new compatible pair, rank 0 -> 1"
const NO_OFFER: String = "no offer is open; one must be opened before a lane may be taken"

## The seam's own refusals, typed independently. Roguelite I4 (D-298) gave rank two a
## reviewed record, so the unsupported rank this suite drives moved one for one from
## rank two to rank three, and the refusal now names the exact ranks the catalogue holds.
const RANK_THREE_REFUSAL: String = "sweeping_edge on quick_strike is held at rank 3, and the catalogue holds reviewed values only for ranks 1 and 2; nothing was applied"
const FOREIGN_PAIR_REFUSAL: String = "the build holds 1 Skill/support pair(s), and only 0 belong to quick_strike, the one Skill the player equips; nothing was applied"
const NO_BUILD_REFUSAL: String = "an application needs a run build, and none was given"
const NO_PLAYER_REFUSAL: String = "an application needs the playable player, and none was given"
const NO_ACTION_REFUSAL: String = "the player holds no Quick Strike action for a build to reach"
const CANONICAL_REFUSAL: String = "Quick Strike's live record is its canonical record rather than a private runtime copy; writing it would write the canonical record, so nothing was applied"

## The inherited methods the review overrides — exactly these, and each but the flag
## calls the method it overrides.
const EXPECTED_OVERRIDES: Array[String] = [
	"_build_run_surfaces", "_discard_mote_runtime", "_maybe_start_verification", "_refresh_receipt",
	"choose_offered_lane",
]

## The I2 panel's delivered functions (D-293). I3 may add exactly one: the note setter.
## First-MVP UI J1 (D-322) removed one, `_input`: its left-press routing moved into the
## shared `FirstMvpModal` contract. Same count.
const ACCEPTED_PANEL_FUNCTIONS: Array[String] = [
	"modal_name", "cancel_closes", "default_focus", "bind_room", "build_contents", "_build_card",
	"open_for_offer", "refresh_contents", "show_refusal", "_on_card_pressed",
	"_set_button_caption", "card_count", "card_buttons", "lane_for_slot", "card_lines", "card_block",
	"refusal_text", "note_text", "text_controls",
]

## The only project classes each shipping script may name, against the engine's own
## global class list, in both directions.
const REVIEW_NAMES: Array[String] = [
	"RiftBuildApplication", "RiftBuildApplicationResult", "RiftRunBuild", "RogueliteExperienceReviewHud",
	"RogueliteLevelUpChoiceReview", "RogueliteLiveEffectReview",
]
const SEAM_NAMES: Array[String] = [
	"PlayerStatTotals", "PlayerStatValue", "PlayerStats", "PrototypePlayer", "QuickStrikeAction",
	"QuickStrikeData", "RiftBuildApplication", "RiftBuildApplicationResult", "RiftRunBuild",
	"SkillSupportCatalogue",
]
## Roguelite I14 (D-320) moved the result's set one for one: it now also names the player's class,
## for the player's two pure static Life functions it re-derives a transition through, and nothing
## else of it. The seam's and the runtime's sets did not move.
const RESULT_NAMES: Array[String] = [
	"PlayerStatTotals", "PlayerStatValue", "PlayerStats", "PrototypePlayer", "QuickStrikeData",
	"RiftBuildApplication", "RiftBuildApplicationResult",
]

## Concrete Skill, support and card ids and names and the effect words: none may appear
## in the review runtime or its scene at all, comments included (D-215).
const CONCRETE_TOKENS: Array[String] = [
	"quick_strike", "Quick Strike", "QuickStrike", "sweeping_edge", "Sweeping Edge",
	"reaching_edge", "Reaching Edge", "card_power", "card_celerity", "card_vitality",
	"card_fleetness", "card_insight", "card_magnetism", "Celerity", "Vitality", "Fleetness",
	"Insight", "Magnetism", "Skill Speed", "Movement Speed", "Global Damage", "Maximum Life",
	"Experience Gain", "Pickup Radius", "10%",
]

## Anything that would mean the review runtime computed an effect itself, read the
## receipt or the card to decide one, or reached past H8 into the run. Read over CODE
## with its comments removed and its strings emptied.
const RUNTIME_RESTATED_TOKENS: Array[String] = [
	"max_speed", "increased_attack_speed", "set_increased", "reach", "release_arc", "soft_target",
	"value_of", "PlayerStat", "total_for", "stat_totals", "support_rank", "SkillSupportCatalogue",
	"PassiveCardCatalogue", "last_choice_record", "_receipt_from", "granted_identity", "level_up()",
	"RiftLevelUpResult", "RiftRunLevelUpResult", "offer_identity_for", "choose_level_up_lane",
	"open_level_up_offer", "attack.data", "canonical_data", "paused = ", "InputMap", "time_scale",
	"duplicate",
]

## What the seam must never do: write a canonical record or a file, touch a tag, a
## target count, a weapon, Life or a timing it does not cover, scale a rank, read a
## receipt, an offer or a card, or reach the temporary D-223 instrument. Over CODE.
## Roguelite I13 (D-318) made Global Damage live, and the seam now READS the equipped
## weapon's raw damage to derive it — so `physical_damage` moved one for one to
## `physical_damage =`: the seam may read that base and may still never write it. The
## token count does not move, and `weapon` stays: the seam still never names one. Roguelite I14
## (D-320) made Maximum Life live, and the seam now READS the player's current Life maximum to
## derive the Life transition — so `max_life` moved one for one to `max_life =`: the seam may read
## that maximum and may still never write it; only the player's own entry point does.
const SEAM_FORBIDDEN_TOKENS: Array[String] = [
	".tres", "ResourceSaver", "FileAccess", "user://", "save(", "maximum_targets =", "tags",
	"SkillTags", "AREA", "Area", "physical_damage =", "max_life =", "weapon", "acceleration", "braking",
	"arrival", "action_time =", "input_buffer", "mana", "cooldown", "RogueliteUpgrade", "RogueliteBuild",
	"build_variety", "Envelope", "RiftLevelUpResult", "RiftRunLevelUpResult", "receipt", "offer", "lane",
	"card", "RiftExperience", "RiftMotePickup", "BASE_PICKUP_RADIUS", "award", "sweep", "collect",
	"rank *", "* rank", "rank +", "+ rank", "rank -", "rank /",
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
const HUD_LEVEL: int = 2
const HUD_EXPERIENCE: int = 3

## The receipt section's controls, in I2's `receipt_controls()` order.
const RECEIPT_TITLE: int = 0
const RECEIPT_STATUS: int = 1
const RECEIPT_CHOICE: int = 2
const RECEIPT_PROGRESSION: int = 3
const RECEIPT_LEVEL: int = 4
const RECEIPT_NOTE_LINE: int = 5

const OWED_CHECKS: Array[String] = [
	"the_review_is_isolated_and_extends_the_accepted_choice_review",
	"the_input_map_entrypoint_and_canonical_record_are_unchanged",
	"the_accepted_i2_defaults_are_preserved",
	"the_nexus_starts_at_every_baseline",
	"the_baseline_strike_misses_at_seventy_degrees_and_the_cone_refuses_forty_five",
	"the_panel_states_this_reviews_note_while_the_offer_stands",
	"sweeping_edge_is_live_before_another_frame_from_the_whole_build",
	"h8_holds_three_fields_and_hands_out_a_copied_build",
	"sweeping_edge_widens_the_real_release_and_soft_target_and_stays_one_target",
	"the_live_receipt_is_legible_and_play_resumes",
	"death_restores_every_baseline",
	"celerity_times_the_real_quick_strike_by_c1s_answer",
	"applying_the_same_build_twice_compounds_nothing",
	"abandon_restores_every_baseline",
	"fleetness_moves_the_character_at_c1s_speed",
	"completion_restores_every_baseline",
	"the_next_expedition_begins_at_every_baseline",
	"reaching_edge_rank_one_moves_the_real_reach",
	"two_targets_in_the_wider_arc_are_still_one_hit",
	"the_whole_build_is_applied_never_the_newest_card",
	"experience_gain_and_pickup_radius_stay_on_their_accepted_path",
	"power_and_maximum_life_are_live_and_only_the_run_path_is_held",
	"unsupported_ranks_and_incoherent_inputs_refuse_without_a_partial_write",
	"restoration_needs_no_memory_of_the_choice",
	"the_seam_and_runtime_restate_nothing_and_write_only_covered_values",
]

var review: RogueliteLiveEffectReview
var arguments: PackedStringArray = PackedStringArray()

var _failures: PackedStringArray = PackedStringArray()
var _checks: int = 0
var _reached: Dictionary = {}
var _shot_dir: String = ""
var _next_use_id: int = 95000
var _deaths_driven: int = 0
var _swings: int = 0
var _expeditions: int = 0
var _staged_plans: int = 0
var _staged_builds: int = 0
var _calls_at_expedition_start: int = 0
var _baseline_live: Dictionary = {}
var _teardowns: PackedStringArray = PackedStringArray()
var _twin_a: RiftRunLevelCoordinator = null
var _baseline_swing: Dictionary = {}
var _baseline_cadence: Dictionary = {}
var _baseline_walk: Dictionary = {}


func _ready() -> void:
	await run()


func run() -> void:
	print("")
	print("=== Roguelite I3 — Live Level-Up Effect Application Review V1 verification (D-295) ===")
	_shot_dir = _argument_value("--shots")
	await _settle(10)
	await _await_navigation()

	_check_the_review_is_isolated_and_extends_the_accepted_choice_review()
	_check_the_input_map_entrypoint_and_canonical_record_are_unchanged()
	await _check_the_accepted_i2_defaults_are_preserved()
	_check_the_nexus_starts_at_every_baseline()

	## Expedition A — Sweeping Edge by Enter; it ends by death.
	await _begin_expedition("A")
	await _route_to_the_elite_hall()
	await _check_the_baseline_strike_misses_at_seventy_degrees_and_the_cone_refuses_forty_five()
	await _open_with_the_escort_alive()
	await _check_the_panel_states_this_reviews_note_while_the_offer_stands()
	await _check_sweeping_edge_is_live_before_another_frame_from_the_whole_build()
	_check_h8_holds_three_fields_and_hands_out_a_copied_build()
	await _check_sweeping_edge_widens_the_real_release_and_soft_target_and_stays_one_target()
	await _check_the_live_receipt_is_legible_and_play_resumes()
	await _check_death_restores_every_baseline()

	## Expedition B — Celerity by the D-pad and (A); it ends by F5.
	await _begin_expedition("B")
	await _route_to_the_elite_hall()
	await _quiet_the_elite_hall()
	_baseline_swing = await _swing()
	_baseline_cadence = await _cadence()
	await _open_at(_elite_hall_near(), _elite_hall_far())
	await _check_celerity_times_the_real_quick_strike_by_c1s_answer()
	await _check_applying_the_same_build_twice_compounds_nothing()
	await _check_abandon_restores_every_baseline()

	## Expedition C — Fleetness by a left click; it ends by completion, and D begins.
	await _begin_expedition("C")
	await _route_to_the_elite_hall()
	await _quiet_the_elite_hall()
	_baseline_walk = await _walk(_elite_hall_near(), _elite_hall_far())
	await _open_at(_elite_hall_near(), _elite_hall_far())
	await _check_fleetness_moves_the_character_at_c1s_speed()
	await _check_completion_restores_every_baseline()
	await _check_the_next_expedition_begins_at_every_baseline()

	## Expedition D — the focused mechanism, staged through the one seam; it ends by F5.
	await _check_reaching_edge_rank_one_moves_the_real_reach()
	await _check_two_targets_in_the_wider_arc_are_still_one_hit()
	_check_the_whole_build_is_applied_never_the_newest_card()
	_check_experience_gain_and_pickup_radius_stay_on_their_accepted_path()
	_check_power_and_maximum_life_are_live_and_only_the_run_path_is_held()
	_check_unsupported_ranks_and_incoherent_inputs_refuse_without_a_partial_write()
	await _check_restoration_needs_no_memory_of_the_choice()
	_check_the_seam_and_runtime_restate_nothing_and_write_only_covered_values()

	_check_every_check_ran()

	print("")
	print("  %d expeditions walked (%d given seed %d again by staging), %d Graveblade deaths driven, %d real Quick Strike presses measured, %d builds staged through the seam, %d applications and %d restorations made by the review"
		% [_expeditions, _staged_plans, ROUTE_SEED, _deaths_driven, _swings, _staged_builds,
			review.applications_made, review.restorations_made])
	if _failures.is_empty():
		print("ROGUELITE LIVE EFFECT REVIEW VERIFICATION: PASS (%d checks)" % _checks)
		get_tree().quit(0)
	else:
		for failure: String in _failures:
			printerr("  FAIL: %s" % failure)
		printerr("ROGUELITE LIVE EFFECT REVIEW VERIFICATION: %d FAILURE(S) of %d checks" % [
			_failures.size(), _checks,
		])
		get_tree().quit(1)


# --- 1. Isolation --------------------------------------------------------------------------

func _check_the_review_is_isolated_and_extends_the_accepted_choice_review() -> void:
	print("")
	print("--- 1. The review inherits I2's accepted scene, extends I2's runtime, and the seam and its result are values, not nodes")
	var statements: PackedStringArray = _scene_statements(FileAccess.get_file_as_string(REVIEW_SCENE_FILE))
	var nodes: int = 0
	var externals: int = 0
	var subs: int = 0
	var scripts: int = 0
	var instance_of_i2: bool = false
	for statement: String in statements:
		if statement.begins_with("[node "):
			nodes += 1
			instance_of_i2 = statement.contains("instance=ExtResource(")
		elif statement.begins_with("[ext_resource "):
			externals += 1
		elif statement.begins_with("[sub_resource "):
			subs += 1
		elif statement.begins_with("script = ExtResource("):
			scripts += 1
	var names_i2: bool = "\n".join(statements).contains("path=\"%s\"" % I2_SCENE)
	_expect(nodes == 1 and externals == 2 and subs == 0 and scripts == 1 and instance_of_i2 and names_i2,
		"the scene is not one inherited instance of I2's scene with its script replaced (%d nodes, %d externals, %d subs)"
			% [nodes, externals, subs])
	var script: GDScript = review.get_script() as GDScript
	_expect(script.resource_path == REVIEW_SCRIPT and script.get_base_script().resource_path == I2_SCRIPT
			and review is RogueliteLevelUpChoiceReview and review is RogueliteExperienceCollectionReview
			and review is RogueliteCoreLoopRuntime,
		"the runtime does not extend I2's accepted runtime")
	var seam: GDScript = load(SEAM_SCRIPT) as GDScript
	var result: GDScript = load(RESULT_SCRIPT) as GDScript
	_expect(seam.get_instance_base_type() == &"RefCounted" and result.get_instance_base_type() == &"RefCounted"
			and seam.get_script_signal_list().is_empty() and result.get_script_signal_list().is_empty(),
		"the seam or its result is a node or declares a signal")
	_expect(review.get_node_or_null("RogueliteLevelUpChoiceReviewVerification") == null
			and review.get_node_or_null("RogueliteExperienceCollectionReviewVerification") == null
			and review.get_node_or_null("RogueliteCoreLoopVerification") == null,
		"an accepted suite started in this scene")
	var live: Label = review.live_receipt_control()
	var box: Node = review.experience_hud.panel.get_child(0)
	var controls: Array[Control] = review.receipt_controls()
	_expect(live != null and live.get_parent() == box
			and live.get_index() == controls[RECEIPT_LEVEL].get_index() + 1
			and live.get_index() == controls[RECEIPT_NOTE_LINE].get_index() - 1,
		"the live line is not between I2's level line and its note, inside H9's review panel")

	## Exactly five overrides, and each but the flag calls the method it overrides.
	var source: String = FileAccess.get_file_as_string(REVIEW_SCRIPT)
	var inherited: PackedStringArray = PackedStringArray()
	for path: String in [I2_SCRIPT, H9_SCRIPT, CORE_LOOP_SCRIPT, SLICE_SCRIPT]:
		inherited.append_array(_declared_functions(FileAccess.get_file_as_string(path)))
	var overrides: PackedStringArray = PackedStringArray()
	for name: String in _declared_functions(source):
		if inherited.has(name):
			overrides.append(name)
	overrides.sort()
	var calling: int = 0
	for name: String in EXPECTED_OVERRIDES:
		if name != "_maybe_start_verification" and _function_body(source, name).contains("super("):
			calling += 1
	_expect(overrides == PackedStringArray(EXPECTED_OVERRIDES) and calling == EXPECTED_OVERRIDES.size() - 1,
		"the review overrides %s, %d calling the method it overrides" % [", ".join(overrides), calling])
	var flag: String = _function_body(source, "_maybe_start_verification")
	_expect(flag.contains("--verify-live-effects") and not flag.contains("--verify-level-up")
			and not flag.contains("--verify-experience"),
		"the review does not answer its own verification flag only")

	## The project classes each shipping script names, in both directions.
	var review_names: PackedStringArray = _names_in(source)
	var seam_names: PackedStringArray = _names_in(FileAccess.get_file_as_string(SEAM_SCRIPT))
	var result_names: PackedStringArray = _names_in(FileAccess.get_file_as_string(RESULT_SCRIPT))
	_expect(review_names == PackedStringArray(REVIEW_NAMES) and seam_names == PackedStringArray(SEAM_NAMES)
			and result_names == PackedStringArray(RESULT_NAMES),
		"the runtime names %s; the seam %s; the result %s" % [", ".join(review_names), ", ".join(seam_names),
			", ".join(result_names)])
	print("  inherited instance of %s; the runtime extends %s; %d overrides (%s), %d calling the method they override"
		% [I2_SCENE.get_file(), I2_SCRIPT.get_file(), overrides.size(), ", ".join(overrides), calling])
	print("  the seam and its result are RefCounted values with no signal; the live line sits between I2's level line and its note in H9's panel")
	print("  the runtime names %s" % ", ".join(review_names))
	print("  the seam names %s" % ", ".join(seam_names))
	print("  the result names %s" % ", ".join(result_names))
	_done("the_review_is_isolated_and_extends_the_accepted_choice_review")


# --- 2. The InputMap, the entrypoint and the canonical record ------------------------------------

func _check_the_input_map_entrypoint_and_canonical_record_are_unchanged() -> void:
	print("")
	print("--- 2. The InputMap, the entrypoint and project.godot are untouched, and the canonical Quick Strike record is the accepted one")
	var actions: int = 0
	for action: StringName in InputMap.get_actions():
		if String(action).begins_with("ui_") and not String(action) in ["ui_confirm", "ui_cancel"]:
			continue
		actions += 1
	_expect(actions == EXPECTED_ACTIONS, "the InputMap holds %d project actions, not %d" % [actions, EXPECTED_ACTIONS])
	_expect(String(ProjectSettings.get_setting("application/run/main_scene", "")) == ENTRYPOINT,
		"the entrypoint is %s" % ProjectSettings.get_setting("application/run/main_scene", ""))
	var settings: String = FileAccess.get_file_as_string(PROJECT_SETTINGS_FILE)
	_expect(not settings.contains("[autoload]") and not settings.contains("live_effect")
			and not settings.contains("RogueliteLiveEffect") and not settings.contains("RiftBuildApplication"),
		"project.godot gained an autoload or names this review")
	var canonical: QuickStrikeData = load(CANONICAL_QUICK_STRIKE) as QuickStrikeData
	_expect(_is_canonical(canonical) and review.player.attack.canonical_data == canonical
			and review.player.attack.data_is_private() and review.player.attack.data != canonical,
		"the canonical record reads %s, or the live record is not a private copy of it" % _record_line(canonical))
	print("  %d actions; the entrypoint is %s; project.godot declares no [autoload] and names nothing of this review"
		% [actions, ENTRYPOINT.get_file()])
	print("  canonical %s; the live record is a private copy of it" % _record_line(canonical))
	_done("the_input_map_entrypoint_and_canonical_record_are_unchanged")


# --- 3. I2's accepted defaults ---------------------------------------------------------------------

func _check_the_accepted_i2_defaults_are_preserved() -> void:
	print("")
	print("--- 3. I2's accepted note, receipt note and panel are unchanged by default; only this scene states its own")
	_expect(RiftLevelUpOfferPanel.GREYBOX_NOTE == I2_GREYBOX_NOTE
			and RogueliteLevelUpChoiceReview.RECEIPT_NOTE == I2_RECEIPT_NOTE,
		"I2's accepted copy moved")
	## A fresh panel from I2's own script, built with nothing calling the setter, shows
	## I2's accepted note — the default this review must not have changed.
	var holder: CanvasLayer = CanvasLayer.new()
	holder.name = "FreshI2Panel"
	add_child(holder)
	var fresh: RiftLevelUpOfferPanel = (load(I2_PANEL_SCRIPT) as GDScript).new() as RiftLevelUpOfferPanel
	holder.add_child(fresh)
	await _await_process_frames(1)
	var fresh_note: String = fresh.note_text()
	holder.queue_free()
	await _await_process_frames(1)
	_expect(fresh_note == I2_GREYBOX_NOTE, "a fresh I2 panel reads '%s'" % fresh_note)
	## The panel's functions are exactly I2's delivered set plus the one setter, and the
	## setter is named by exactly one other file in the project: this review's runtime.
	var declared: PackedStringArray = _declared_functions(FileAccess.get_file_as_string(I2_PANEL_SCRIPT))
	var expected: PackedStringArray = PackedStringArray(ACCEPTED_PANEL_FUNCTIONS)
	expected.append("set_note_text")
	declared.sort()
	expected.sort()
	var callers: PackedStringArray = PackedStringArray()
	for root: String in ["res://scripts", "res://scenes", "res://data", "res://addons"]:
		for path: String in _files_under(root, [".gd", ".tscn", ".tres"]):
			if path != I2_PANEL_SCRIPT and FileAccess.get_file_as_string(path).contains("set_note_text("):
				callers.append(path)
	_expect(declared == expected and callers == PackedStringArray([REVIEW_SCRIPT]),
		"the panel declares %s; set_note_text( is named by %s" % [", ".join(declared), ", ".join(callers)])
	_expect(review.level_up_panel.note_text() == PANEL_NOTE
			and (review.receipt_controls()[RECEIPT_NOTE_LINE] as Label).text == RECEIPT_LIVE_NOTE,
		"this scene's notes read '%s' / '%s'" % [review.level_up_panel.note_text(),
			(review.receipt_controls()[RECEIPT_NOTE_LINE] as Label).text])
	print("  a fresh I2 panel reads its accepted note; the panel adds exactly set_note_text, called only by %s; this scene states: %s"
		% [REVIEW_SCRIPT.get_file(), review.level_up_panel.note_text()])
	_done("the_accepted_i2_defaults_are_preserved")


# --- 4. The Nexus ---------------------------------------------------------------------------------

func _check_the_nexus_starts_at_every_baseline() -> void:
	print("")
	print("--- 4. The Nexus holds no runtime and the character stands at every accepted baseline")
	_baseline_live = _live()
	_expect(_is_baseline(_baseline_live), "the character does not start at the accepted baselines: %s" % str(_baseline_live))
	_expect(review.loop_state == RogueliteCoreLoopRuntime.LoopState.HUB and review.mote_runtime == null
			and review.last_application == null and review.applications_made == 0
			and not review.live_receipt_control().is_visible_in_tree() and review.live_receipt_text().is_empty(),
		"the Nexus holds a runtime, an application or a live line")
	print("  %s" % _live_line(_baseline_live))
	_done("the_nexus_starts_at_every_baseline")


# --- 5. The baseline strike ------------------------------------------------------------------------

func _check_the_baseline_strike_misses_at_seventy_degrees_and_the_cone_refuses_forty_five() -> void:
	print("")
	print("--- 5. Before any choice the real Quick Strike misses a Graveblade 70° off its facing, and the controller cone refuses one 45° off it")
	await _quiet_the_elite_hall()
	var centre: Vector3 = _elite_hall_centre()
	var forward: Vector3 = _forward()
	var escort: PrototypeGraveblade = review.room_enemies[2][1]
	var life_before: float = escort.life
	escort.place_at(centre + forward.rotated(Vector3.UP, deg_to_rad(70.0)) * NEAR_TARGET)
	_stand_facing(centre, forward)
	var swung: Dictionary = await _swing()
	var record: Dictionary = _considered_for(swung["outcome"], escort)
	_expect(int(swung["began"]) == QuickStrikeAction.Phase.WINDUP and swung["target"] == null
			and int(swung["family"]) == InputFamilyTracker.Family.CONTROLLER
			and String(swung["acquisition"]).begins_with("no eligible target in the 65 deg cone")
			and String((swung["outcome"] as Dictionary).get("outcome", "")) == "miss" and int(swung["damage"]) == 0
			and int(swung["queries"]) == 1 and escort.life == life_before
			and absf(float(record.get("angle_degrees", -1.0)) - 70.0) < 0.5
			and String(record.get("rejected", "")).contains("outside the 100 deg release arc"),
		"the baseline swing at 70° answered %s against %s" % [str(swung["outcome"].get("outcome")), str(record)])
	## The same real query, asked directly with the live record, answers the same.
	_stand_facing(centre, forward)
	var direct: Dictionary = _release_query(review.player.attack.data)
	_expect(String(direct.get("outcome", "")) == "miss", "the direct baseline query at 70° answered %s" % direct.get("outcome"))

	escort.place_at(centre + forward.rotated(Vector3.UP, deg_to_rad(45.0)) * FAR_TARGET)
	_stand_facing(centre, forward)
	var soft: Dictionary = _soft_query(review.player.attack.data)
	var soft_record: Dictionary = _considered_for(soft, escort)
	_expect(soft.get("target") == null
			and String(soft_record.get("rejected", "")).contains("outside the 32.5 deg half-cone (65 deg total)"),
		"the baseline cone at 45° answered %s / %s" % [str(soft.get("target")), str(soft_record)])
	var pressed: Dictionary = await _swing()
	_expect(int(pressed["began"]) == QuickStrikeAction.Phase.WINDUP and pressed["target"] == null
			and int(pressed["family"]) == InputFamilyTracker.Family.CONTROLLER
			and String(pressed["acquisition"]).contains("no eligible target in the 65 deg cone")
			and String((pressed["outcome"] as Dictionary).get("outcome", "")) == "miss",
		"the baseline controller press at 45° began %d targeting %s (%s)" % [int(pressed["began"]),
			str(pressed["target"]), pressed["acquisition"]])
	print("  70° at %.1f m: %s — %s; the direct query answers %s" % [NEAR_TARGET,
		swung["outcome"].get("outcome"), record.get("rejected"), direct.get("outcome")])
	print("  45° at %.1f m: the cone refused it (%s); the real press swung untargeted: '%s'" % [FAR_TARGET,
		soft_record.get("rejected"), pressed["acquisition"]])
	_done("the_baseline_strike_misses_at_seventy_degrees_and_the_cone_refuses_forty_five")


# --- 6. The panel's note ------------------------------------------------------------------------------

func _check_the_panel_states_this_reviews_note_while_the_offer_stands() -> void:
	print("")
	print("--- 6. The accepted panel opens over seed 99's offer and states this review's note, on screen")
	var panel: RiftLevelUpOfferPanel = review.level_up_panel
	_expect(panel.is_open and get_tree().paused and review.mote_runtime.is_offer_active()
			and review.mote_runtime.experience() == LEVEL_ONE_REQUIREMENT and review.mote_runtime.level() == 1,
		"the panel did not open at exactly 100: %s" % _state())
	var identities: PackedStringArray = PackedStringArray()
	for lane: int in review.mote_runtime.offer_lanes():
		identities.append(", ".join(review.mote_runtime.offer_identity_for(lane)))
	_expect(identities == PackedStringArray(["quick_strike, sweeping_edge", "card_celerity", "card_fleetness"]),
		"seed 99's offer is %s" % str(identities))
	await _await_process_frames(4)
	var viewport: Rect2 = Rect2(Vector2.ZERO, Vector2(get_viewport().get_visible_rect().size))
	var controls: Array[Control] = panel.text_controls()
	var visible: int = 0
	for control: Control in controls:
		if control.is_visible_in_tree():
			visible += 1
	var shown: int = _measure_text(controls, viewport, "level-up panel")
	var note: Control = controls[controls.size() - 1]
	_expect(panel.note_text() == PANEL_NOTE and note.is_visible_in_tree() and shown == visible
			and visible == controls.size() - 1 and _smallest_font(controls) >= 12,
		"the panel note reads '%s'; %d of %d visible controls on screen" % [panel.note_text(), shown, visible])
	print("  the offer holds [%s]; %d of %d visible panel controls on screen, smallest %d px; the note reads: %s"
		% [" | ".join(identities), shown, visible, _smallest_font(controls), panel.note_text()])
	_done("the_panel_states_this_reviews_note_while_the_offer_stands")


# --- 7. Sweeping Edge, live before another frame --------------------------------------------------------

func _check_sweeping_edge_is_live_before_another_frame_from_the_whole_build() -> void:
	print("")
	print("--- 7. Enter takes Support exactly as G4 does, and the whole build is live before another frame runs")
	_twin_a = _twin_opened(4)
	var expected: RiftRunLevelUpResult = _twin_a.choose(RiftOffer.Lane.SUPPORT)
	var before: Dictionary = _before_choice()
	_push_key(KEY_ENTER, true)
	var taken: Dictionary = _taken_reading()
	_push_key(KEY_ENTER, false)
	await _await_process_frames(1)
	_expect_live_choice("A Support by Enter", RiftOffer.Lane.SUPPORT, _twin_a, expected, taken, before)
	var live: Dictionary = taken["live"]
	_expect(float(live["arc"]) == SWEPT_ARC and float(live["cone"]) == SWEPT_CONE
			and float(live["reach"]) == ACCEPTED_REACH and float(live["max_speed"]) == ACCEPTED_MAX_SPEED
			and float(live["increased"]) == 0.0 and float(live["effective"]) == ACCEPTED_ACTION_TIME
			and int(live["targets"]) == 1,
		"Sweeping Edge left %s" % str(live))
	var result: RiftBuildApplicationResult = review.last_application
	_expect(result != null and result.supports_applied == PackedStringArray(["quick_strike -> sweeping_edge rank 1"])
			and result.run_path_stats.is_empty() and result.deferred_stats.is_empty(),
		"the application applied %s" % ("nothing" if result == null else ", ".join(result.supports_applied)))
	print("  %s" % _live_line(live))
	print("  applied from the run's build: %s" % result.describe())
	_done("sweeping_edge_is_live_before_another_frame_from_the_whole_build")


# --- 8. H8 ---------------------------------------------------------------------------------------------

func _check_h8_holds_three_fields_and_hands_out_a_copied_build() -> void:
	print("")
	print("--- 8. H8 still holds exactly three fields, and its one build reading hands out a copy")
	var probe: RiftMoteRuntime = RiftMoteRuntime.new(ROUTE_SEED)
	var fields: PackedStringArray = PackedStringArray()
	for entry: Dictionary in probe.get_property_list():
		if int(entry.get("usage", 0)) & PROPERTY_USAGE_SCRIPT_VARIABLE != 0:
			fields.append(String(entry.get("name", "")))
	var body: String = _function_body(FileAccess.get_file_as_string(H8_SCRIPT), "run_build").strip_edges()
	_expect(fields == PackedStringArray(["_run", "_field", "_bindings"]) and body == "return _run.run_build()",
		"H8 holds %s and its build reading reads '%s'" % [", ".join(fields), body])
	var first: RiftRunBuild = review.mote_runtime.run_build()
	var second: RiftRunBuild = review.mote_runtime.run_build()
	var twin_line: String = _twin_a.run_build().describe()
	_expect(first != null and second != null and first != second and first.describe() == second.describe()
			and first.describe() == twin_line and first.has_support(&"quick_strike", &"sweeping_edge"),
		"two readings answered %s and %s; the twin's build is %s" % [str(first), str(second), twin_line])
	## Changing the copy it handed out reaches nothing: not the run, not the character.
	var live_before: Dictionary = _live()
	var granted: String = first.acquire_passive_card(PassiveCardCatalogue.record(PassiveCardCatalogue.POWER_ID))
	var third: RiftRunBuild = review.mote_runtime.run_build()
	_expect(granted.is_empty() and first.acquisitions_for(PassiveCardCatalogue.POWER_ID) == 1
			and third.acquisitions_for(PassiveCardCatalogue.POWER_ID) == 0 and third.describe() == twin_line
			and _live() == live_before,
		"a changed copy reached the run or the character: %s" % third.describe())
	print("  H8 holds %s; run_build() is '%s'; two readings are two objects reading '%s', equal to the directly driven G4 run's"
		% [", ".join(fields), body, twin_line])
	print("  a card added to one copy left the run's next copy and the character unchanged")
	_done("h8_holds_three_fields_and_hands_out_a_copied_build")


# --- 9. Sweeping Edge in the real queries ------------------------------------------------------------------

func _check_sweeping_edge_widens_the_real_release_and_soft_target_and_stays_one_target() -> void:
	print("")
	print("--- 9. The real Quick Strike now reaches 70° off its facing, the controller cone takes 45°, and it is still one target")
	await _until_neutral()
	var centre: Vector3 = _elite_hall_centre()
	var forward: Vector3 = _forward()
	var escort: PrototypeGraveblade = review.room_enemies[2][1]
	var area: PrototypeTargetable = _area(escort)
	escort.place_at(centre + forward.rotated(Vector3.UP, deg_to_rad(70.0)) * NEAR_TARGET)
	_stand_facing(centre, forward)
	var live_query: Dictionary = _release_query(review.player.attack.data)
	var base_query: Dictionary = _release_query(review.player.attack.canonical_data)
	_expect(String(live_query.get("outcome", "")) == "hit" and live_query.get("target") == area
			and String(base_query.get("outcome", "")) == "miss",
		"at 70° the live record answered %s and the canonical record %s" % [live_query.get("outcome"), base_query.get("outcome")])
	var life_before: float = escort.life
	var swung: Dictionary = await _swing()
	var outcome: Dictionary = swung["outcome"]
	_expect(int(swung["began"]) == QuickStrikeAction.Phase.WINDUP and swung["target"] == null
			and int(swung["family"]) == InputFamilyTracker.Family.CONTROLLER
			and String(swung["acquisition"]).begins_with("no eligible target in the 110 deg cone")
			and String(outcome.get("outcome", "")) == "hit" and outcome.get("target") == area
			and int(swung["damage"]) == 1 and int(swung["queries"]) == 1
			and escort.life == life_before - review.player.physical_damage,
		"the real swing at 70° answered %s; the escort's Life went %.0f -> %.0f" % [outcome.get("outcome"), life_before, escort.life])

	escort.place_at(centre + forward.rotated(Vector3.UP, deg_to_rad(45.0)) * FAR_TARGET)
	_stand_facing(centre, forward)
	var soft_live: Dictionary = _soft_query(review.player.attack.data)
	var soft_base: Dictionary = _soft_query(review.player.attack.canonical_data)
	_expect(soft_live.get("target") == area and String(soft_live.get("group", "")) == "approach"
			and soft_base.get("target") == null,
		"at 45° the live cone chose %s and the canonical cone %s" % [str(soft_live.get("target")), str(soft_base.get("target"))])
	await _until_neutral()
	await _as_controller()
	_stand_facing(centre, forward)
	_push_joy(QUICK_STRIKE_BUTTON, true)
	var family: int = review.input_family.family
	var began: int = review.player.attack.phase
	var target: PrototypeTargetable = review.player.attack.target
	var acquisition: String = review.player.attack.last_acquisition
	_push_joy(QUICK_STRIKE_BUTTON, false)
	_swings += 1
	_stand(centre)
	await _settle(2)
	_expect(began == QuickStrikeAction.Phase.APPROACH and target == area and acquisition.contains("approach: 45 deg off intent")
			and family == InputFamilyTracker.Family.CONTROLLER,
		"the real controller press at 45° began %d toward %s (%s)" % [began, str(target), acquisition])

	## One target and no Area: the record still resolves exactly one, and the Skill's
	## tag profile is what it was.
	var profile: SkillTagProfile = SkillSupportCatalogue.quick_strike_profile()
	_expect(review.player.attack.data.maximum_targets == 1 and review.player.attack.data.problem().is_empty()
			and not profile.carries(SkillTags.AREA) and profile.carries(SkillTags.STRIKE),
		"Sweeping Edge moved the target count or the Area tag: %d targets, tags %s" % [
			review.player.attack.data.maximum_targets, profile.tag_line()])

	if not _shot_dir.is_empty():
		escort.place_at(centre + forward.rotated(Vector3.UP, deg_to_rad(70.0)) * NEAR_TARGET)
		_stand_facing(centre, forward)
		var overlay: Node3D = _show_envelope(centre, forward, escort.global_position)
		await _capture("01_sweeping_edge_live")
		overlay.queue_free()
	print("  70° at %.1f m: the live record's query %s, the canonical record's %s; the real swing hit it once — Life %.0f -> %.0f"
		% [NEAR_TARGET, live_query.get("outcome"), base_query.get("outcome"), life_before, escort.life])
	print("  45° at %.1f m: the live cone chose it (%s), the canonical cone refused it; the real press began its approach: '%s'"
		% [FAR_TARGET, soft_live.get("group"), acquisition])
	print("  maximum targets %d; Quick Strike's tags %s — no Area" % [review.player.attack.data.maximum_targets, profile.tag_line()])
	_done("sweeping_edge_widens_the_real_release_and_soft_target_and_stays_one_target")


# --- 10. The receipt on screen -------------------------------------------------------------------------

func _check_the_live_receipt_is_legible_and_play_resumes() -> void:
	print("")
	print("--- 10. The receipt reports the live result inside H9's review panel, clear of every other surface")
	await _await_process_frames(4)
	var viewport: Rect2 = Rect2(Vector2.ZERO, Vector2(get_viewport().get_visible_rect().size))
	var controls: Array[Control] = review.receipt_controls()
	controls.append(review.live_receipt_control())
	var shown: int = _measure_text(controls, viewport, "receipt")
	var host: Rect2 = review.experience_hud.panel.get_global_rect()
	var outside_host: int = 0
	for control: Control in controls:
		if control.is_visible_in_tree() and not host.encloses(control.get_global_rect()):
			outside_host += 1
	_expect(shown == 6 and outside_host == 0 and viewport.encloses(host) and _smallest_font(controls) >= 12,
		"%d receipt lines on screen, %d outside the review panel %s" % [shown, outside_host, host])
	_expect(review.live_receipt_text() == SWEEPING_LIVE and review.live_receipt_control().text == SWEEPING_LIVE
			and (controls[RECEIPT_NOTE_LINE] as Label).text == RECEIPT_LIVE_NOTE
			and not get_tree().paused,
		"the receipt reads %s" % str(_receipt_lines()))

	## Every other surface, with its transient parts forced visible while a modal holds
	## the world still — H9's and I2's own measurement.
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
	print("  %s; smallest %d px; inside the review panel, clear of %d other surfaces and the centre"
		% [" | ".join(_receipt_lines()), _smallest_font(controls), measured])
	print("  review panel %s in a %s viewport" % [host, viewport.size])
	_done("the_live_receipt_is_legible_and_play_resumes")


# --- 11. Death --------------------------------------------------------------------------------------------

func _check_death_restores_every_baseline() -> void:
	print("")
	print("--- 11. Death ends the expedition at the Fallen overlay's return to the Nexus, and every baseline comes back")
	await _until_neutral()
	var live_before: Dictionary = _live()
	var restorations: int = review.restorations_made
	var escort: PrototypeGraveblade = review.room_enemies[2][1]
	review.player.receive_damage(DamageEvent.physical(_use(), escort, review.player, review.player.life + 1000.0))
	var fell: bool = not review.player.is_alive()
	await get_tree().create_timer(BrokenWatchSlice.FALLEN_DELAY + 0.4).timeout
	await _await_process_frames(4)
	var while_fallen: Dictionary = _live()
	_expect(fell and review.fallen_overlay.is_open and get_tree().paused and review.mote_runtime != null
			and while_fallen == live_before,
		"the player did not fall to the Fallen overlay with the expedition's values still standing")
	await _key(KEY_ENTER)
	await _settle(4)
	await _await_process_frames(2)
	var after: Dictionary = _live()
	_expect(review.loop_state == RogueliteCoreLoopRuntime.LoopState.HUB and review.mote_runtime == null
			and review.player.is_alive() and not review.fallen_overlay.is_open and not get_tree().paused
			and after == _baseline_live and review.restorations_made == restorations + 1
			and review.last_restoration != null and review.last_restoration.ok and review.last_restoration.committed
			and review.last_application == null and not review.live_receipt_control().is_visible_in_tree(),
		"death did not restore every baseline: %s" % str(after))
	_teardowns.append("A by death")
	print("  while Fallen: arc %.0f°, cone %.0f° still standing; after the return to the Nexus: %s"
		% [float(while_fallen["arc"]), float(while_fallen["cone"]), _live_line(after)])
	_done("death_restores_every_baseline")


# --- 12. Celerity --------------------------------------------------------------------------------------------

func _check_celerity_times_the_real_quick_strike_by_c1s_answer() -> void:
	print("")
	print("--- 12. The D-pad and (A) take Celerity; the real Quick Strike completes at C1's answer, one release per use, its pose on the marker")
	var twin: RiftRunLevelCoordinator = _twin_opened(4)
	var expected: RiftRunLevelUpResult = twin.choose(RiftOffer.Lane.COMBAT_DEFENCE)
	await _joy(JOY_BUTTON_DPAD_RIGHT)
	_expect(get_viewport().gui_get_focus_owner() == review.level_up_panel.card_buttons()[1],
		"the D-pad did not move focus to card 2")
	var before: Dictionary = _before_choice()
	_push_joy(JOY_BUTTON_A, true)
	var taken: Dictionary = _taken_reading()
	_push_joy(JOY_BUTTON_A, false)
	await _await_process_frames(1)
	_expect_live_choice("B Combat and Defence by (A)", RiftOffer.Lane.COMBAT_DEFENCE, twin, expected, taken, before)

	## C1's own answer, asked directly: 0.80 s at +10% increased Skill Speed.
	var c1: PlayerStatTotals = PlayerStatTotals.new()
	_expect_quiet(c1.add(PlayerStats.SKILL_SPEED, ONE_CARD).is_empty(), "C1 refused one Celerity")
	var answer: PlayerStatValue = c1.value_of(PlayerStats.SKILL_SPEED, ACCEPTED_ACTION_TIME)
	var effective: float = review.player.attack.effective_action_time()
	_expect(answer.ok and review.player.increased_attack_speed() == ONE_CARD and effective == answer.value
			and effective == ACCEPTED_ACTION_TIME / (1.0 + ONE_CARD) and review.player.attack.data.action_time == ACCEPTED_ACTION_TIME,
		"the live action time is %.9f s at +%.3f against C1's %.9f s" % [effective, review.player.increased_attack_speed(), answer.value])
	await _quiet_the_elite_hall()
	var swung: Dictionary = await _swing()
	var cadence: Dictionary = await _cadence()
	var dt: float = _dt()
	var windup: float = effective * ACCEPTED_MARKER
	_expect(_ticks_match(int(_baseline_swing["finish"]), ACCEPTED_ACTION_TIME)
			and _ticks_match(int(_baseline_swing["release"]), ACCEPTED_ACTION_TIME * ACCEPTED_MARKER),
		"the baseline swing finished at tick %d and released at tick %d" % [int(_baseline_swing["finish"]), int(_baseline_swing["release"])])
	_expect(_ticks_match(int(swung["finish"]), effective) and _ticks_match(int(swung["release"]), windup)
			and int(swung["finish"]) < int(_baseline_swing["finish"]),
		"the Celerity swing finished at tick %d (%.4f s) and released at tick %d, against %.4f s and %.4f s"
			% [int(swung["finish"]), int(swung["finish"]) * dt, int(swung["release"]), effective, windup])
	_expect(int(swung["queries"]) == 1 and int(swung["releases"]) == 1 and int(_baseline_swing["queries"]) == 1
			and int(swung["family"]) == InputFamilyTracker.Family.CONTROLLER
			and int(_baseline_swing["family"]) == InputFamilyTracker.Family.CONTROLLER
			and int(cadence["family"]) == InputFamilyTracker.Family.CONTROLLER
			and int(_baseline_cadence["family"]) == InputFamilyTracker.Family.CONTROLLER
			and absf(float(swung["anim_release"]) - ACCEPTED_MARKER) < 0.0001
			and absf(float(_baseline_swing["anim_release"]) - ACCEPTED_MARKER) < 0.0001,
		"one release per use or the pose at release failed: %s / %s" % [str(swung), str(_baseline_swing)])
	## The animation is driven by the changed value: SAMPLE_TICK ticks in, the rig stands
	## at the normalized time that tick count means at each speed.
	var ticks: int = int(swung["sample_tick"])
	var base_ticks: int = int(_baseline_swing["sample_tick"])
	_expect(ticks == SAMPLE_TICK and base_ticks == SAMPLE_TICK
			and absf(float(swung["sample_anim"]) - ticks * dt * (1.0 + ONE_CARD) / ACCEPTED_ACTION_TIME) < 0.0001
			and absf(float(_baseline_swing["sample_anim"]) - base_ticks * dt / ACCEPTED_ACTION_TIME) < 0.0001
			and absf(float(swung["sample_anim"]) - float(swung["sample_norm"])) < 0.0001,
		"the rig stood at %.5f / %.5f %d ticks in" % [float(swung["sample_anim"]), float(_baseline_swing["sample_anim"]), ticks])
	_expect(int(cadence["releases"]) == 5 and int(cadence["queries"]) == 5 and int(_baseline_cadence["queries"]) == 5
			and absf(float(cadence["mean"]) - effective) <= dt / 4.0 + 0.0001
			and absf(float(_baseline_cadence["mean"]) - ACCEPTED_ACTION_TIME) <= dt / 4.0 + 0.0001,
		"a held Quick Strike released every %.4f s (baseline %.4f s)" % [float(cadence["mean"]), float(_baseline_cadence["mean"])])
	await _capture("02_celerity_live")
	print("  %s" % _live_line(taken["live"]))
	print("  C1: 0.80 s at +10%% = %.9f s; the kernel's effective action time %.9f s — the same number" % [answer.value, effective])
	print("  one real press: released at tick %d and finished at tick %d (%.4f s) against the baseline's %d and %d (%.4f s); 1 query and 1 release each; the pose at release %.4f"
		% [int(swung["release"]), int(swung["finish"]), int(swung["finish"]) * dt,
			int(_baseline_swing["release"]), int(_baseline_swing["finish"]), int(_baseline_swing["finish"]) * dt,
			float(swung["anim_release"])])
	print("  %d ticks in, the rig stood at %.5f (baseline %.5f); a held press released every %.4f s over 4 repeats (baseline %.4f s), 5 queries for 5 releases"
		% [ticks, float(swung["sample_anim"]), float(_baseline_swing["sample_anim"]), float(cadence["mean"]),
			float(_baseline_cadence["mean"])])
	_done("celerity_times_the_real_quick_strike_by_c1s_answer")


# --- 13. Idempotence ----------------------------------------------------------------------------------------

func _check_applying_the_same_build_twice_compounds_nothing() -> void:
	print("")
	print("--- 13. The same build applied twice more leaves every value exactly where the choice put it")
	var once: Dictionary = _live()
	var signals: Dictionary = {"n": 0}
	var counter: Callable = func(_increased: float, _time: float) -> void:
		signals["n"] = int(signals["n"]) + 1
	review.player.attack_speed_changed.connect(counter)
	var first: RiftBuildApplicationResult = RiftBuildApplication.apply(review.mote_runtime.run_build(), review.player, ACCEPTED_MAX_SPEED)
	var after_first: Dictionary = _live()
	var second: RiftBuildApplicationResult = RiftBuildApplication.apply(review.mote_runtime.run_build(), review.player, ACCEPTED_MAX_SPEED)
	var after_second: Dictionary = _live()
	review.player.attack_speed_changed.disconnect(counter)
	_staged_builds += 2
	_expect(first.ok and second.ok and first.committed and second.committed and first.describe() == second.describe()
			and once == after_first and after_first == after_second and int(signals["n"]) == 0
			and float(after_second["effective"]) == ACCEPTED_ACTION_TIME / (1.0 + ONE_CARD)
			and float(after_second["increased"]) == ONE_CARD,
		"a second and third application moved something: %s -> %s -> %s (%d signals)" % [str(once), str(after_first),
			str(after_second), int(signals["n"])])
	var canonical: QuickStrikeData = load(CANONICAL_QUICK_STRIKE) as QuickStrikeData
	_expect(_is_canonical(canonical) and _is_canonical(review.player.attack.canonical_data)
			and review.player.attack.data_is_private(),
		"an application wrote the canonical record: %s" % _record_line(canonical))
	print("  applied twice more from the run's own build: identical to the choice, 0 speed-change signals; +%.0f%% is still %.9f s, never compounded"
		% [100.0 * ONE_CARD, float(after_second["effective"])])
	print("  the canonical record still reads %s" % _record_line(canonical))
	_done("applying_the_same_build_twice_compounds_nothing")


# --- 14. Abandon ------------------------------------------------------------------------------------------------

func _check_abandon_restores_every_baseline() -> void:
	print("")
	print("--- 14. F5 abandons the expedition, and every baseline comes back")
	var restorations: int = review.restorations_made
	var live_before: Dictionary = _live()
	await _key(KEY_F5)
	await _settle(4)
	var after: Dictionary = _live()
	_expect(not _is_baseline(live_before) and review.loop_state == RogueliteCoreLoopRuntime.LoopState.HUB
			and review.mote_runtime == null and after == _baseline_live and review.restorations_made == restorations + 1
			and review.last_restoration.ok and review.last_application == null
			and not review.live_receipt_control().is_visible_in_tree() and not get_tree().paused,
		"F5 did not restore every baseline: %s" % str(after))
	_teardowns.append("B by F5")
	print("  %s -> %s" % [_live_line(live_before), _live_line(after)])
	_done("abandon_restores_every_baseline")


# --- 15. Fleetness -----------------------------------------------------------------------------------------------

func _check_fleetness_moves_the_character_at_c1s_speed() -> void:
	print("")
	print("--- 15. A left click takes Fleetness; the character's speed is C1's answer, and a real walk reaches it")
	var twin: RiftRunLevelCoordinator = _twin_opened(4)
	var expected: RiftRunLevelUpResult = twin.choose(RiftOffer.Lane.UTILITY)
	var button: Button = review.level_up_panel.card_buttons()[2]
	var before: Dictionary = _before_choice()
	_hover(button)
	await _await_process_frames(1)
	before = _before_choice()
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
	_expect_live_choice("C Utility by left click", RiftOffer.Lane.UTILITY, twin, expected, taken, before)
	var c1: PlayerStatTotals = PlayerStatTotals.new()
	_expect_quiet(c1.add(PlayerStats.MOVEMENT_SPEED, ONE_CARD).is_empty(), "C1 refused one Fleetness")
	var answer: PlayerStatValue = c1.value_of(PlayerStats.MOVEMENT_SPEED, ACCEPTED_MAX_SPEED)
	var live: Dictionary = _live()
	_expect(answer.ok and answer.value == FLEET_SPEED and float(live["max_speed"]) == answer.value
			and float(live["acceleration"]) == float(_baseline_live["acceleration"])
			and float(live["braking"]) == float(_baseline_live["braking"])
			and float(live["arrival"]) == float(_baseline_live["arrival"]),
		"the live speed is %.6f against C1's %.6f, or acceleration, braking or arrival moved" % [float(live["max_speed"]), answer.value])
	await _clear_hover()
	var walk: Dictionary = await _walk(_elite_hall_near(), _elite_hall_far())
	_expect(absf(float(_baseline_walk["top"]) - ACCEPTED_MAX_SPEED) <= SPEED_TOLERANCE
			and absf(float(_baseline_walk["plateau"]) - ACCEPTED_MAX_SPEED) <= SPEED_TOLERANCE
			and absf(float(walk["top"]) - FLEET_SPEED) <= SPEED_TOLERANCE
			and absf(float(walk["plateau"]) - FLEET_SPEED) <= SPEED_TOLERANCE,
		"the walks measured %.3f / %.3f m/s before and %.3f / %.3f m/s after" % [float(_baseline_walk["top"]),
			float(_baseline_walk["plateau"]), float(walk["top"]), float(walk["plateau"])])
	await _capture("03_fleetness_live")
	print("  %s" % _live_line(live))
	print("  C1: 5.0 m/s at +10%% = %.6f m/s; the live speed %.6f m/s — the same number; acceleration, braking and arrival unchanged"
		% [answer.value, float(live["max_speed"])])
	print("  a real %.1f m walk: top %.3f m/s and %.3f m/s over a 12-tick plateau, against %.3f and %.3f m/s before the choice"
		% [float(walk["distance"]), float(walk["top"]), float(walk["plateau"]), float(_baseline_walk["top"]),
			float(_baseline_walk["plateau"])])
	_done("fleetness_moves_the_character_at_c1s_speed")


# --- 16. Completion -------------------------------------------------------------------------------------------------

func _check_completion_restores_every_baseline() -> void:
	print("")
	print("--- 16. Walking out of the cleared Elite Hall completes the expedition, and every baseline is back behind the summary")
	var restorations: int = review.restorations_made
	var live_before: Dictionary = _live()
	_expect(review.run_state.is_cleared(2), "the Elite Hall is not cleared: %s" % _state())
	await _walk_into_gate(review.room_modules[2].exit_point())
	await _await_process_frames(4)
	var after: Dictionary = _live()
	_expect(not _is_baseline(live_before) and review.loop_state == RogueliteCoreLoopRuntime.LoopState.RUN_COMPLETE
			and review.summary_panel.is_open and get_tree().paused and review.mote_runtime == null
			and after == _baseline_live and review.restorations_made == restorations + 1 and review.last_restoration.ok,
		"completion did not restore every baseline behind the summary: %s" % str(after))
	await _key(KEY_ENTER)
	await _settle(4)
	_expect(not review.summary_panel.is_open and not get_tree().paused and _live() == _baseline_live,
		"the summary did not close onto the Nexus at every baseline")
	_teardowns.append("C by completion")
	print("  behind the run summary: %s; the summary closed onto the Nexus at every baseline" % _live_line(after))
	_done("completion_restores_every_baseline")


# --- 17. The next expedition --------------------------------------------------------------------------------------

func _check_the_next_expedition_begins_at_every_baseline() -> void:
	print("")
	print("--- 17. The next expedition begins at every baseline — even over values a staged build left on the character in the Nexus")
	## STAGED: no real route leaves an effect standing in the Nexus, so the harness puts
	## one there through the seam, and the next expedition's beginning must remove it.
	var staged: RiftRunBuild = RiftRunBuild.new()
	_expect_quiet(staged.acquire_passive_card(PassiveCardCatalogue.record(PassiveCardCatalogue.CELERITY_ID)).is_empty(), "stage")
	_expect_quiet(staged.acquire_passive_card(PassiveCardCatalogue.record(PassiveCardCatalogue.FLEETNESS_ID)).is_empty(), "stage")
	_expect_quiet(staged.acquire_support(&"quick_strike", &"reaching_edge").is_empty(), "stage")
	var put: RiftBuildApplicationResult = RiftBuildApplication.apply(staged, review.player, ACCEPTED_MAX_SPEED)
	_staged_builds += 1
	var in_nexus: Dictionary = _live()
	var restorations: int = review.restorations_made
	await _begin_expedition("D")
	var begun: Dictionary = _live()
	_expect(put.ok and not _is_baseline(in_nexus) and begun == _baseline_live
			and review.restorations_made == restorations + 1 and review.mote_runtime.run_build().is_empty(),
		"the next expedition began at %s over %s" % [str(begun), str(in_nexus)])
	print("  staged in the Nexus: %s; the Rift Gate began expedition D at: %s" % [_live_line(in_nexus), _live_line(begun)])
	_done("the_next_expedition_begins_at_every_baseline")


# --- 18. Reaching Edge ----------------------------------------------------------------------------------------------

func _check_reaching_edge_rank_one_moves_the_real_reach() -> void:
	print("")
	print("--- 18. Reaching Edge at rank one: the seam sets 2.65 m, and the real approach and release query use it")
	_quiet_room(0)
	await _clear_hover()
	var hall: Vector3 = _rounded(review.room_modules[0].room_centres()[0])
	var forward: Vector3 = _forward()
	var enemy: PrototypeGraveblade = review.room_enemies[0][0]
	enemy.place_at(hall + forward * 4.0)
	_stand_facing(hall, forward)
	var base_run: Dictionary = await _swing()
	## STAGED: a seed-99 level-up offers Sweeping Edge, never Reaching Edge.
	var build: RiftRunBuild = RiftRunBuild.new()
	_expect_quiet(build.acquire_support(&"quick_strike", &"reaching_edge").is_empty(), "stage")
	var result: RiftBuildApplicationResult = RiftBuildApplication.apply(build, review.player, ACCEPTED_MAX_SPEED)
	_staged_builds += 1
	var live: Dictionary = _live()
	_expect(result.ok and result.committed and result.supports_applied == PackedStringArray(["quick_strike -> reaching_edge rank 1"])
			and float(live["reach"]) == REACHED and float(live["arc"]) == ACCEPTED_ARC and float(live["cone"]) == ACCEPTED_CONE
			and int(live["targets"]) == 1 and review.player.attack.data.problem().is_empty(),
		"Reaching Edge left %s" % str(live))
	enemy.place_at(hall + forward * 4.0)
	_stand_facing(hall, forward)
	var reach_run: Dictionary = await _swing()
	var stop_base: float = ACCEPTED_REACH - ACCEPTED_MARGIN
	var stop_reach: float = REACHED - ACCEPTED_MARGIN
	var step: float = ACCEPTED_MAX_SPEED * _dt() + 0.001
	_expect(int(base_run["began"]) == QuickStrikeAction.Phase.APPROACH and int(reach_run["began"]) == QuickStrikeAction.Phase.APPROACH
			and int(base_run["family"]) == InputFamilyTracker.Family.CONTROLLER
			and int(reach_run["family"]) == InputFamilyTracker.Family.CONTROLLER
			and String(base_run["acquisition"]).contains("approach: 0 deg off intent")
			and String(reach_run["acquisition"]).contains("approach: 0 deg off intent")
			and float(base_run["windup_distance"]) <= stop_base and float(base_run["windup_distance"]) > stop_base - step
			and float(reach_run["windup_distance"]) <= stop_reach and float(reach_run["windup_distance"]) > stop_reach - step
			and String((base_run["outcome"] as Dictionary).get("outcome", "")) == "hit"
			and String((reach_run["outcome"] as Dictionary).get("outcome", "")) == "hit",
		"the approaches stopped at %.3f m and %.3f m" % [float(base_run["windup_distance"]), float(reach_run["windup_distance"])])
	enemy.place_at(hall + forward * 2.3)
	_stand_facing(hall, forward)
	var live_query: Dictionary = _release_query(review.player.attack.data)
	var base_query: Dictionary = _release_query(review.player.attack.canonical_data)
	var record: Dictionary = _considered_for(base_query, enemy)
	_expect(String(live_query.get("outcome", "")) == "hit" and String(base_query.get("outcome", "")) == "miss"
			and String(record.get("rejected", "")).contains("beyond the 1.65 m reach"),
		"at 2.3 m the live record answered %s and the canonical %s (%s)" % [live_query.get("outcome"),
			base_query.get("outcome"), record.get("rejected")])
	print("  %s" % _live_line(live))
	print("  a real controller approach to a Graveblade 4.0 m ahead stopped %.3f m from it before (reach 1.65 m less the 0.10 m margin) and %.3f m after (2.65 m less 0.10 m); both releases hit"
		% [float(base_run["windup_distance"]), float(reach_run["windup_distance"])])
	print("  2.3 m ahead: the live record's query %s, the canonical record's %s — '%s'" % [live_query.get("outcome"),
		base_query.get("outcome"), record.get("rejected")])
	_kill(enemy)
	_stand(enemy.global_position)
	await _settle(3)
	await _walk_into_gate(review.room_modules[0].exit_point())
	_done("reaching_edge_rank_one_moves_the_real_reach")


# --- 19. Two targets -----------------------------------------------------------------------------------------------

func _check_two_targets_in_the_wider_arc_are_still_one_hit() -> void:
	print("")
	print("--- 19. Two Graveblades inside Sweeping Edge's 180° arc: one real release, one hit")
	_quiet_room(1)
	await _clear_hover()
	var cache: Vector3 = _rounded(review.room_modules[1].room_centres()[0])
	var forward: Vector3 = _forward()
	## STAGED, as in check 18.
	var build: RiftRunBuild = RiftRunBuild.new()
	_expect_quiet(build.acquire_support(&"quick_strike", &"sweeping_edge").is_empty(), "stage")
	var result: RiftBuildApplicationResult = RiftBuildApplication.apply(build, review.player, ACCEPTED_MAX_SPEED)
	_staged_builds += 1
	var near: PrototypeGraveblade = review.room_enemies[1][0]
	var far: PrototypeGraveblade = review.room_enemies[1][1]
	near.place_at(cache + forward.rotated(Vector3.UP, deg_to_rad(70.0)) * NEAR_TARGET)
	far.place_at(cache + forward.rotated(Vector3.UP, deg_to_rad(-70.0)) * (NEAR_TARGET + 0.2))
	_stand_facing(cache, forward)
	var near_life: float = near.life
	var far_life: float = far.life
	var swung: Dictionary = await _swing()
	var outcome: Dictionary = swung["outcome"]
	var legal: int = 0
	for record: Dictionary in outcome.get("considered", []):
		if String(record.get("rejected", "")).is_empty():
			legal += 1
	_expect(result.ok and float(_live()["arc"]) == SWEPT_ARC and String(outcome.get("outcome", "")) == "hit"
			and int(swung["family"]) == InputFamilyTracker.Family.CONTROLLER
			and String(swung["acquisition"]).begins_with("no eligible target in the 110 deg cone")
			and outcome.get("target") == _area(near) and legal == 2 and int(swung["damage"]) == 1
			and near.life == near_life - review.player.physical_damage and far.life == far_life
			and review.player.attack.data.maximum_targets == 1,
		"two legal targets produced %d damage event(s): %.0f -> %.0f and %.0f -> %.0f" % [int(swung["damage"]),
			near_life, near.life, far_life, far.life])
	print("  2 legal targets at +70° %.1f m and -70° %.1f m: 1 release, 1 damage event, the nearer %.0f -> %.0f, the other untouched at %.0f"
		% [NEAR_TARGET, NEAR_TARGET + 0.2, near_life, near.life, far.life])
	_done("two_targets_in_the_wider_arc_are_still_one_hit")


# --- 20. The whole build ----------------------------------------------------------------------------------------------

func _check_the_whole_build_is_applied_never_the_newest_card() -> void:
	print("")
	print("--- 20. The whole build is applied: two Celerity cards are +20%, never the newest +10%, beside everything else it holds")
	var build: RiftRunBuild = RiftRunBuild.new()
	for card: StringName in [PassiveCardCatalogue.CELERITY_ID, PassiveCardCatalogue.FLEETNESS_ID, PassiveCardCatalogue.CELERITY_ID]:
		_expect_quiet(build.acquire_passive_card(PassiveCardCatalogue.record(card)).is_empty(), "stage %s" % card)
	_expect_quiet(build.acquire_support(&"quick_strike", &"sweeping_edge").is_empty(), "stage")
	var c1: PlayerStatTotals = PlayerStatTotals.new()
	_expect_quiet(c1.add(PlayerStats.SKILL_SPEED, ONE_CARD).is_empty() and c1.add(PlayerStats.SKILL_SPEED, ONE_CARD).is_empty(), "C1")
	var twice: PlayerStatValue = c1.value_of(PlayerStats.SKILL_SPEED, ACCEPTED_ACTION_TIME)
	var result: RiftBuildApplicationResult = RiftBuildApplication.apply(build, review.player, ACCEPTED_MAX_SPEED)
	_staged_builds += 1
	var live: Dictionary = _live()
	_expect(result.ok and result.increased_skill_speed == build.total_for(PlayerStats.SKILL_SPEED)
			and float(live["increased"]) == twice.total_increased and float(live["effective"]) == twice.value
			and float(live["effective"]) != ACCEPTED_ACTION_TIME / (1.0 + ONE_CARD)
			and float(live["max_speed"]) == FLEET_SPEED and float(live["arc"]) == SWEPT_ARC and float(live["cone"]) == SWEPT_CONE,
		"the whole build left %s against C1's %.9f s" % [str(live), twice.value])
	## Deriving writes nothing: a derivation of a different build leaves the character as it is.
	var other: RiftRunBuild = RiftRunBuild.new()
	_expect_quiet(other.acquire_support(&"quick_strike", &"reaching_edge").is_empty(), "stage")
	var derived: RiftBuildApplicationResult = RiftBuildApplication.derive(other, review.player, ACCEPTED_MAX_SPEED)
	_expect(derived.ok and not derived.committed and derived.reach == REACHED and derived.release_arc_degrees == ACCEPTED_ARC
			and _live() == live and derived.problem().is_empty() and result.problem().is_empty(),
		"a derivation moved the character or did not derive: %s" % derived.describe())
	## The review reads the whole build and nothing about the choice to apply it.
	var apply_body: String = _function_body(_bare(FileAccess.get_file_as_string(REVIEW_SCRIPT)), "_apply_expedition_build")
	_expect(apply_body.count("mote_runtime.run_build()") == 1 and not apply_body.contains("last_choice_record")
			and not apply_body.contains("_receipt_from") and not apply_body.contains("receipt_text(")
			and not apply_body.contains("_receipt[") and not apply_body.contains("granted_identity")
			and not apply_body.contains("level_up()") and not apply_body.contains("lane"),
		"the review's application reads something beside the run's whole build")
	print("  Celerity x2 + Fleetness + Quick Strike -> Sweeping Edge: +%.0f%% -> %.9f s (C1 %.9f s; the newest card alone would be %.9f s), %.1f m/s, arc %.0f°, cone %.0f°"
		% [100.0 * float(live["increased"]), float(live["effective"]), twice.value, ACCEPTED_ACTION_TIME / (1.0 + ONE_CARD),
			float(live["max_speed"]), float(live["arc"]), float(live["cone"])])
	print("  a derivation of another build answered reach %.2f m and wrote nothing; the review's application reads mote_runtime.run_build() once and no receipt, record or lane"
		% derived.reach)
	_done("the_whole_build_is_applied_never_the_newest_card")


# --- 21. Experience Gain and Pickup Radius -------------------------------------------------------------------------

func _check_experience_gain_and_pickup_radius_stay_on_their_accepted_path() -> void:
	print("")
	print("--- 21. Experience Gain and Pickup Radius are named as the run's own and applied to nothing here")
	var build: RiftRunBuild = RiftRunBuild.new()
	_expect_quiet(build.acquire_passive_card(PassiveCardCatalogue.record(PassiveCardCatalogue.INSIGHT_ID)).is_empty(), "stage")
	_expect_quiet(build.acquire_passive_card(PassiveCardCatalogue.record(PassiveCardCatalogue.MAGNETISM_ID)).is_empty(), "stage")
	var result: RiftBuildApplicationResult = RiftBuildApplication.apply(build, review.player, ACCEPTED_MAX_SPEED)
	_staged_builds += 1
	var lines: PackedStringArray = result.live_lines()
	_expect(result.ok and result.run_path_stats.size() == 2
			and result.run_path_stats[0] == PlayerStats.EXPERIENCE_GAIN and result.run_path_stats[1] == PlayerStats.PICKUP_RADIUS
			and result.deferred_stats.is_empty() and _live() == _baseline_live
			and lines == PackedStringArray(["Experience Gain +10% — applied by the run's own mote path",
				"Pickup Radius +25% — applied by the run's own mote path"]),
		"the run-path stats answered %s and left %s" % [str(lines), str(_live())])
	var bare: String = _bare(FileAccess.get_file_as_string(SEAM_SCRIPT))
	## Roguelite I13 (D-318) moved this count one for one from 2 to 3: the seam now also
	## evaluates Global Damage through the same calculation path. Roguelite I14 (D-320) moved it
	## one for one again, from 3 to 4: Maximum Life too.
	_expect(bare.count("value_of(") == 4 and bare.count("PlayerStats.EXPERIENCE_GAIN") == 1
			and bare.count("PlayerStats.PICKUP_RADIUS") == 1 and not bare.contains("RiftExperience")
			and not bare.contains("RiftMotePickup") and not bare.contains("award") and not bare.contains("sweep"),
		"the seam evaluates or reimplements a mote-path stat")
	print("  %s; every covered value at its baseline" % " | ".join(lines))
	print("  the seam calls value_of() four times (Global Damage, Skill Speed, Maximum Life, Movement Speed) and names the two mote-path stats once each, in a list; it names no experience track, pickup query, award or sweep")
	_done("experience_gain_and_pickup_radius_stay_on_their_accepted_path")


# --- 22. Power and Maximum Life -----------------------------------------------------------------------------------

## Roguelite I13 (D-318) made Global Damage live, and this check moved one for one: Power is
## now applied at C1's own answer and says so under "Live now", Maximum Life is still held and
## said to be unapplied, the weapon and Life still do not move, and the D-297 held-only
## receipt is proved on the one held stat left. Two builds are staged, as before.
##
## Roguelite I14 (D-320) made Maximum Life live, and this check moved one for one again: Power and
## Vitality are both applied at C1's own answers and say so under "Live now", the Life keeps its
## fraction by the player's own rule, the weapon still does not move, and the D-297 held-only
## receipt is proved on Insight's Experience Gain — the run's own mote-path stat, the only kind of
## held stat left. Two builds are staged, as before: the applied one also carries Insight, so the
## written values and a held stat still sit side by side.
func _check_power_and_maximum_life_are_live_and_only_the_run_path_is_held() -> void:
	print("")
	print("--- 22. Global Damage and Maximum Life are live at C1's answers; the run-path stat is held and said to be; the weapon does not move")
	var build: RiftRunBuild = RiftRunBuild.new()
	_expect_quiet(build.acquire_passive_card(PassiveCardCatalogue.record(PassiveCardCatalogue.POWER_ID)).is_empty(), "stage")
	_expect_quiet(build.acquire_passive_card(PassiveCardCatalogue.record(PassiveCardCatalogue.VITALITY_ID)).is_empty(), "stage")
	_expect_quiet(build.acquire_passive_card(PassiveCardCatalogue.record(PassiveCardCatalogue.INSIGHT_ID)).is_empty(), "stage")
	var damage: float = review.player.physical_damage
	var max_life: float = review.player.max_life
	var life: float = review.player.life
	## C1's own answers, asked directly: the weapon's raw damage at +10% increased Global Damage, and
	## the unmodified maximum at the Vitality record's own increase; the Life the player's rule keeps.
	var c1: PlayerStatTotals = PlayerStatTotals.new()
	_expect_quiet(c1.add(PlayerStats.GLOBAL_DAMAGE, ONE_CARD).is_empty(), "C1 refused one Power")
	_expect_quiet(c1.add(PlayerStats.MAXIMUM_LIFE,
		PassiveCardCatalogue.record(PassiveCardCatalogue.VITALITY_ID).magnitude).is_empty(), "C1 refused one Vitality")
	var answer: PlayerStatValue = c1.value_of(PlayerStats.GLOBAL_DAMAGE, damage)
	var maximum: PlayerStatValue = c1.value_of(PlayerStats.MAXIMUM_LIFE, review.player.maximum_life_baseline())
	var kept: float = PrototypePlayer.preserved_life(life, max_life, maximum.value)
	var result: RiftBuildApplicationResult = RiftBuildApplication.apply(build, review.player, ACCEPTED_MAX_SPEED)
	_staged_builds += 1
	var lines: PackedStringArray = result.live_lines()
	var outgoing: PlayerStatValue = review.player.outgoing_hit_damage(review.player.physical_damage)
	var live: Dictionary = _live()
	var baseline: Dictionary = _baseline_live.duplicate()
	live.erase("max_life")
	baseline.erase("max_life")
	_expect(result.ok and result.deferred_stats.is_empty() and result.run_path_stats.size() == 1
			and result.run_path_stats[0] == PlayerStats.EXPERIENCE_GAIN and live == baseline
			and review.player.physical_damage == damage and maximum.ok and result.maximum_life.value == maximum.value
			and review.player.max_life == maximum.value and review.player.life == kept and result.life_after == kept
			and answer.ok and result.global_damage.value == answer.value and outgoing.ok and outgoing.value == answer.value
			and review.player.increased_global_damage() == answer.total_increased
			and lines == PackedStringArray(["damage 100 → 110", "Maximum Life 500 → 575 · Life preserved at 100%",
				"Experience Gain +10% — applied by the run's own mote path"]),
		"the application answered %s; the outgoing damage %s against C1's %s; Life %.0f / %.0f against %s"
			% [str(lines), outgoing.describe(), answer.describe(), review.player.life, review.player.max_life, maximum.describe()])
	## THE RECEIPT NEVER CALLS A HELD STAT LIVE (D-297): the review's own composer, read for
	## that build — whose written values are the damage and the maximum — and for a held-only
	## build, which is only derived, so nothing is written.
	var mixed_receipt: String = RogueliteLiveEffectReview.live_receipt_for(result)
	var held: RiftRunBuild = RiftRunBuild.new()
	_expect_quiet(held.acquire_passive_card(PassiveCardCatalogue.record(PassiveCardCatalogue.INSIGHT_ID)).is_empty(), "stage")
	var held_result: RiftBuildApplicationResult = RiftBuildApplication.derive(held, review.player, ACCEPTED_MAX_SPEED)
	_staged_builds += 1
	var held_receipt: String = RogueliteLiveEffectReview.live_receipt_for(held_result)
	var after_derive: Dictionary = _live()
	after_derive.erase("max_life")
	_expect(held_receipt == HELD_ONLY_RECEIPT and not held_receipt.contains("Live now")
			and mixed_receipt == MIXED_RECEIPT and not mixed_receipt.get_slice("Held, not live on the character:", 1).contains("Maximum Life")
			and not held_result.committed and after_derive == baseline,
		"a held-only build's receipt reads '%s'; beside the written values, '%s'"
			% [held_receipt.replace("\n", " / "), mixed_receipt.replace("\n", " / ")])
	print("  %s; weapon damage %.0f raw and %.0f outgoing — C1's answer — maximum Life %.0f -> %.0f and Life %.0f -> %.0f, its fraction kept"
		% [" | ".join(lines), damage, outgoing.value, max_life, review.player.max_life, life, review.player.life])
	print("  the receipt for a held-only build: '%s'; beside the written values: '%s'"
		% [held_receipt.replace("\n", " / "), mixed_receipt.replace("\n", " / ")])
	_done("power_and_maximum_life_are_live_and_only_the_run_path_is_held")


# --- 23. Refusals --------------------------------------------------------------------------------------------------

func _check_unsupported_ranks_and_incoherent_inputs_refuse_without_a_partial_write() -> void:
	print("")
	print("--- 23. An unsupported rank, a pair on an unequipped Skill and every incoherent input are refused, and nothing is written")
	var standing: RiftRunBuild = RiftRunBuild.new()
	_expect_quiet(standing.acquire_passive_card(PassiveCardCatalogue.record(PassiveCardCatalogue.CELERITY_ID)).is_empty(), "stage")
	_expect_quiet(standing.acquire_support(&"quick_strike", &"sweeping_edge").is_empty(), "stage")
	_expect_quiet(RiftBuildApplication.apply(standing, review.player, ACCEPTED_MAX_SPEED).ok, "stage")
	_staged_builds += 1
	var snapshot: Dictionary = _live()
	var signals: Dictionary = {"n": 0}
	var counter: Callable = func(_increased: float, _time: float) -> void:
		signals["n"] = int(signals["n"]) + 1
	review.player.attack_speed_changed.connect(counter)

	## Every covered value a partial write could move is moved by this build: +20%, Fleetness,
	## and a rank the catalogue has no value for — rank three since D-298 gave rank two its
	## reviewed record; moved one for one, and the count does not move.
	var rank_three: RiftRunBuild = RiftRunBuild.new()
	for card: StringName in [PassiveCardCatalogue.CELERITY_ID, PassiveCardCatalogue.CELERITY_ID, PassiveCardCatalogue.FLEETNESS_ID]:
		_expect_quiet(rank_three.acquire_passive_card(PassiveCardCatalogue.record(card)).is_empty(), "stage")
	_expect_quiet(rank_three.acquire_support(&"quick_strike", &"sweeping_edge").is_empty(), "stage")
	_expect_quiet(rank_three.rank_support(&"quick_strike", &"sweeping_edge").is_empty(), "stage")
	_expect_quiet(rank_three.rank_support(&"quick_strike", &"sweeping_edge").is_empty(), "stage")
	var foreign: RiftRunBuild = RiftRunBuild.new()
	_expect_quiet(foreign.acquire_passive_card(PassiveCardCatalogue.record(PassiveCardCatalogue.FLEETNESS_ID)).is_empty(), "stage")
	_expect_quiet(foreign.acquire_support(&"splinter_shot", &"reaching_edge").is_empty(), "stage")

	var detached: PrototypePlayer = PrototypePlayer.new()
	var canonical_player: PrototypePlayer = PrototypePlayer.new()
	var canonical_action: QuickStrikeAction = QuickStrikeAction.new()
	canonical_action.data = load(CANONICAL_QUICK_STRIKE) as QuickStrikeData
	canonical_action.canonical_data = canonical_action.data
	canonical_player.attack = canonical_action

	var cases: Array = [
		["an unsupported rank", RiftBuildApplication.apply(rank_three, review.player, ACCEPTED_MAX_SPEED), RANK_THREE_REFUSAL],
		["a pair on an unequipped Skill", RiftBuildApplication.apply(foreign, review.player, ACCEPTED_MAX_SPEED), FOREIGN_PAIR_REFUSAL],
		["no build", RiftBuildApplication.apply(null, review.player, ACCEPTED_MAX_SPEED), NO_BUILD_REFUSAL],
		["no player", RiftBuildApplication.apply(rank_three, null, ACCEPTED_MAX_SPEED), NO_PLAYER_REFUSAL],
		["a player with no Quick Strike action", RiftBuildApplication.apply(standing, detached, ACCEPTED_MAX_SPEED), NO_ACTION_REFUSAL],
		["a live record that is the canonical record", RiftBuildApplication.apply(standing, canonical_player, ACCEPTED_MAX_SPEED), CANONICAL_REFUSAL],
		["a zero movement baseline", RiftBuildApplication.apply(standing, review.player, 0.0), "the movement baseline 0.0 is not a positive finite speed"],
		["a movement baseline that is not a number", RiftBuildApplication.apply(standing, review.player, NAN), "the movement baseline nan is not a positive finite speed"],
	]
	review.player.attack_speed_changed.disconnect(counter)
	var wrong: PackedStringArray = PackedStringArray()
	for case: Array in cases:
		var answer: RiftBuildApplicationResult = case[1]
		if answer.ok or answer.committed or answer.failure_reason != String(case[2]) or not answer.problem().is_empty():
			wrong.append("%s: %s" % [case[0], answer.describe()])
	_expect(wrong.is_empty(), "refusals answered: %s" % "; ".join(wrong))
	_expect(_live() == snapshot and int(signals["n"]) == 0 and _is_canonical(canonical_action.data)
			and _is_canonical(load(CANONICAL_QUICK_STRIKE) as QuickStrikeData),
		"a refusal wrote something: %s against %s (%d signals)" % [str(_live()), str(snapshot), int(signals["n"])])
	## The catalogue itself holds nothing for rank zero or rank three — rank two has held a
	## reviewed record since D-298, proved by the I4 suite — or for any pair but its two.
	_expect(SkillSupportCatalogue.support_rank_values(&"quick_strike", &"sweeping_edge", 3).is_empty()
			and SkillSupportCatalogue.support_rank_values(&"quick_strike", &"sweeping_edge", 0).is_empty()
			and SkillSupportCatalogue.support_rank_values(&"splinter_shot", &"sweeping_edge", 1).is_empty()
			and SkillSupportCatalogue.support_rank_values(&"quick_strike", &"invented_support", 1).is_empty()
			and SkillSupportCatalogue.support_rank_values(&"quick_strike", &"reaching_edge", 1) == {&"reach": REACHED}
			and SkillSupportCatalogue.support_rank_values(&"quick_strike", &"sweeping_edge", 1)
				== {&"release_arc_degrees": SWEPT_ARC, &"soft_target_cone_degrees": SWEPT_CONE},
		"the catalogue's rank values are not exactly rank one's two records")
	detached.free()
	canonical_player.free()
	canonical_action.free()
	for case: Array in cases:
		print("  %s: '%s'" % [case[0], (case[1] as RiftBuildApplicationResult).failure_reason])
	print("  8 of 8 refused with nothing committed; every live value and the canonical record unchanged; 0 speed-change signals; the catalogue answers nothing for ranks 0 and 3")
	_done("unsupported_ranks_and_incoherent_inputs_refuse_without_a_partial_write")


# --- 24. Restoration remembers nothing ------------------------------------------------------------------------------

func _check_restoration_needs_no_memory_of_the_choice() -> void:
	print("")
	print("--- 24. F5 restores every baseline over values the review never applied and never saw")
	var restorations: int = review.restorations_made
	var live_before: Dictionary = _live()
	_expect(not _is_baseline(live_before) and review.last_application == null and review.applications_made == 3
			and review.mote_runtime.run_build().is_empty(),
		"the review saw an application this expedition: %s" % str(review.last_application))
	await _key(KEY_F5)
	await _settle(4)
	var after: Dictionary = _live()
	_expect(review.loop_state == RogueliteCoreLoopRuntime.LoopState.HUB and review.mote_runtime == null
			and after == _baseline_live and review.restorations_made == restorations + 1 and review.last_restoration.ok,
		"F5 did not restore every baseline over the staged values: %s" % str(after))
	_teardowns.append("D by F5")
	print("  %s -> %s, with the review holding no application and the run's build empty" % [_live_line(live_before), _live_line(after)])
	print("  %d expeditions ended (%s), each at every baseline" % [_teardowns.size(), ", ".join(_teardowns)])
	_done("restoration_needs_no_memory_of_the_choice")


# --- 25. Nothing restated ------------------------------------------------------------------------------------------

func _check_the_seam_and_runtime_restate_nothing_and_write_only_covered_values() -> void:
	print("")
	print("--- 25. The seam writes only its covered values, and only after deriving them; the review computes no effect; nothing names storage or an asset")
	var seam: String = _bare(FileAccess.get_file_as_string(SEAM_SCRIPT))
	var writes: PackedStringArray = PackedStringArray()
	var pattern: RegEx = RegEx.create_from_string("(?m)^\\s*(live|player|canonical|action|candidate|result)\\.([A-Za-z_]+)\\s*=[^=]")
	for found: RegExMatch in pattern.search_all(seam):
		writes.append("%s.%s" % [found.get_string(1), found.get_string(2)])
	var derive_body: String = _function_body(seam, "derive")
	var forbidden: PackedStringArray = PackedStringArray()
	for token: String in SEAM_FORBIDDEN_TOKENS:
		if seam.contains(token):
			forbidden.append(token)
	_expect(writes == PackedStringArray(["candidate.resource_path", "candidate.reach", "candidate.release_arc_degrees",
			"candidate.soft_target_cone_degrees", "live.reach", "live.release_arc_degrees", "live.soft_target_cone_degrees",
			"player.max_speed", "result.committed"])
			and seam.count("set_increased_attack_speed(") == 1 and not derive_body.contains("live.")
			and not derive_body.contains("max_speed =") and not derive_body.contains("set_increased_attack_speed")
			and forbidden.is_empty(),
		"the seam writes %s and names %s" % [", ".join(writes), ", ".join(forbidden)])
	_expect(seam.count("SkillSupportCatalogue.support_rank_values(") == 1 and seam.count(".stat_totals()") == 1
			and seam.count("support_rank_for(") == 1 and seam.count("canonical_data") == 1,
		"the seam asks the catalogue, the build or the canonical record other than once each")
	var runtime: String = _bare(FileAccess.get_file_as_string(REVIEW_SCRIPT))
	var restated: PackedStringArray = PackedStringArray()
	for token: String in RUNTIME_RESTATED_TOKENS:
		if runtime.contains(token):
			restated.append(token)
	_expect(restated.is_empty() and runtime.count("RiftBuildApplication.apply(") == 2
			and runtime.count("run_build()") == 1 and runtime.count("RiftRunBuild.new()") == 1
			and runtime.count("set_note_text(") == 1,
		"the review runtime names %s" % ", ".join(restated))
	var result: String = _bare(FileAccess.get_file_as_string(RESULT_SCRIPT))
	_expect(not result.contains("player") and not result.contains("max_speed =") and not result.contains("set_increased")
			and not result.contains(".data"),
		"the result writes to the character")
	var concrete: PackedStringArray = PackedStringArray()
	var storage: PackedStringArray = PackedStringArray()
	var assets: PackedStringArray = PackedStringArray()
	for path: String in [REVIEW_SCRIPT, REVIEW_SCENE_FILE]:
		var raw: String = FileAccess.get_file_as_string(path)
		for token: String in CONCRETE_TOKENS:
			if raw.contains(token):
				concrete.append("%s: %s" % [path.get_file(), token])
	for path: String in [REVIEW_SCRIPT, SEAM_SCRIPT, RESULT_SCRIPT, REVIEW_SCENE_FILE]:
		var raw: String = FileAccess.get_file_as_string(path)
		var code: String = _bare(raw) if path.ends_with(".gd") else "\n".join(_scene_statements(raw))
		for token: String in STORAGE_TOKENS:
			if code.contains(token):
				storage.append("%s: %s" % [path.get_file(), token])
		for token: String in ASSET_TOKENS:
			if raw.contains(token):
				assets.append("%s: %s" % [path.get_file(), token])
	_expect(concrete.is_empty() and storage.is_empty() and assets.is_empty(),
		"concrete %s; storage %s; assets %s" % [", ".join(concrete), ", ".join(storage), ", ".join(assets)])
	var own: String = FileAccess.get_file_as_string(THIS_FILE)
	var found_here: int = 0
	for token: String in RUNTIME_RESTATED_TOKENS + CONCRETE_TOKENS + SEAM_FORBIDDEN_TOKENS:
		if own.contains(token):
			found_here += 1
	_expect(found_here > 60, "the scans found only %d of their own tokens in this file and may be inert" % found_here)
	print("  the seam writes only %s, and set_increased_attack_speed() once, all outside derive(); 0 of %d forbidden tokens"
		% [", ".join(writes), SEAM_FORBIDDEN_TOKENS.size()])
	print("  the review runtime: 0 of %d restated tokens; the seam called twice, the build read once, one empty build made; 0 of %d concrete tokens in it or its scene; 0 storage and 0 asset tokens in the four shipping files"
		% [RUNTIME_RESTATED_TOKENS.size(), CONCRETE_TOKENS.size()])
	_done("the_seam_and_runtime_restate_nothing_and_write_only_covered_values")


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


# --- Expeditions -----------------------------------------------------------------------------------------------------

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
			and review.mote_runtime.run_build().is_empty() and not review.offer_attempted()
			and not review.level_up_panel.is_open and review.last_application == null
			and not review.live_receipt_control().is_visible_in_tree() and _live() == _baseline_live,
		"expedition %s did not begin fresh at every baseline: %s / %s" % [label, _state(), str(_live())])
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


func _quiet_the_elite_hall() -> void:
	_quiet_room(2)
	var centre: Vector3 = _elite_hall_centre()
	var forward: Vector3 = _forward()
	## Both beyond reach and beyond the 5 m acquisition distance, so no swing reaches them.
	for index: int in review.room_enemies[2].size():
		var enemy: PrototypeGraveblade = review.room_enemies[2][index]
		if enemy.is_alive():
			enemy.place_at(centre - forward * 7.0 + forward.rotated(Vector3.UP, PI * 0.5) * (2.0 * index - 1.0) * 3.0)
	_stand_facing(centre, forward)
	await _settle(2)


## A: the Elite dies with pickup off, the player stands on its mote and pickup turns on;
## the escort stays alive, still and out of reach.
func _open_with_the_escort_alive() -> void:
	_quiet_room(2)
	await _set_pickup(false)
	var centre: Vector3 = _elite_hall_centre()
	var elite: PrototypeGraveblade = review.room_enemies[2][0]
	var escort: PrototypeGraveblade = review.room_enemies[2][1]
	escort.place_at(centre - _forward() * 7.0)
	elite.place_at(centre + _forward() * 2.0)
	_kill(elite)
	_stand(centre + _forward() * 2.0)
	await _set_pickup(true)
	await _settle(3)
	_expect(review.level_up_panel.is_open and escort.is_alive() and review.mote_runtime.experience() == LEVEL_ONE_REQUIREMENT,
		"A did not open at exactly 100 with the escort alive: %s" % _state())


## With pickup off, the Elite dies at `near` and the escort at `far`; the player stands
## on the Elite's mote and pickup turns on, reaching exactly 100.
func _open_at(near: Vector3, far: Vector3) -> void:
	_quiet_room(2)
	await _set_pickup(false)
	var elite: PrototypeGraveblade = review.room_enemies[2][0]
	var escort: PrototypeGraveblade = review.room_enemies[2][1]
	elite.place_at(near)
	escort.place_at(far)
	_kill(elite)
	_kill(escort)
	_stand(near)
	await _set_pickup(true)
	await _settle(3)
	_expect(review.level_up_panel.is_open and review.mote_runtime.experience() == LEVEL_ONE_REQUIREMENT
			and review.mote_runtime.uncollected_count() == 1,
		"the offer did not open at 100 with the escort's mote pending: %s" % _state())


# --- Choices ---------------------------------------------------------------------------------------------------------

func _before_choice() -> Dictionary:
	return {
		"attempts": review.choice_attempts, "taken": review.choices_taken, "calls": review.offer_open_calls,
		"applications": review.applications_made, "physics": Engine.get_physics_frames(),
		"process": Engine.get_process_frames(),
	}


## Read in the same call stack as the activating input, before any frame passes.
func _taken_reading() -> Dictionary:
	return {
		"open": review.level_up_panel.is_open, "paused": get_tree().paused,
		"active": review.mote_runtime.is_offer_active(), "level": review.mote_runtime.level(),
		"experience": review.mote_runtime.experience(),
		"hud_level": _hud_text(HUD_LEVEL), "hud_experience": _hud_text(HUD_EXPERIENCE),
		"physics": Engine.get_physics_frames(), "process": Engine.get_process_frames(),
		"applications": review.applications_made, "applied_at": review.last_application_physics_frame,
		"live": _live(), "live_line": review.live_receipt_text(),
	}


## Everything one successful live choice owes: G4's own record, the panel closed and play
## resumed by that very input, the build applied in that same call before any frame, one
## level, the receipt with its live line, and the root seed spent once.
func _expect_live_choice(
	label: String, lane: int, twin: RiftRunLevelCoordinator, expected: RiftRunLevelUpResult,
	taken: Dictionary, before: Dictionary
) -> void:
	var record: RiftRunLevelUpResult = review.last_choice_record
	var receipt: RiftLevelUpResult = null if record == null else record.level_up()
	var identity: PackedStringArray = PackedStringArray(SEED_99_IDENTITIES[lane])
	_expect(record != null and receipt != null and record.succeeded() and record.problem().is_empty()
			and record.run_seed == ROUTE_SEED and record.source_level == 1 and receipt.lane == lane
			and receipt.root_seed == ROUTE_SEED and receipt.granted_identity() == identity
			and _record(record) == _record(expected),
		"%s answered %s where G4 answered %s" % [label, _record(record), _record(expected)])
	_expect(not bool(taken["open"]) and not bool(taken["paused"]) and not bool(taken["active"])
			and review.choice_attempts == int(before["attempts"]) + 1 and review.choices_taken == int(before["taken"]) + 1
			and review.offer_open_calls == int(before["calls"]),
		"%s did not close the panel and resume play in the same input: %s" % [label, str(taken)])
	## THE APPLICATION HAPPENED IN THAT SAME INPUT: the frame counters had not moved when
	## the live values were read, and the review recorded the application on that frame.
	_expect(int(taken["physics"]) == int(before["physics"]) and int(taken["process"]) == int(before["process"])
			and int(taken["applied_at"]) == int(before["physics"]) and int(taken["applications"]) == int(before["applications"]) + 1
			and String(taken["live_line"]) == EXPECTED_LIVE[lane],
		"%s was applied on frame %d after input on frame %d, or reads '%s'" % [label, int(taken["applied_at"]),
			int(before["physics"]), String(taken["live_line"])])
	_expect(int(taken["level"]) == 2 and float(taken["experience"]) == 0.0 and twin.level() == 2
			and String(taken["hud_level"]) == "Rift level 2"
			and String(taken["hud_experience"]) == "XP 0 / %d" % int(LEVEL_TWO_REQUIREMENT),
		"%s left level %d with %s" % [label, int(taken["level"]), str(taken["experience"])])
	## The application is the seam's own answer for the run's whole build — derived again
	## now from a fresh copy, it is the same.
	var again: RiftBuildApplicationResult = RiftBuildApplication.derive(review.mote_runtime.run_build(), review.player, ACCEPTED_MAX_SPEED)
	var applied: RiftBuildApplicationResult = review.last_application
	_expect(applied != null and applied.ok and applied.committed and again.ok and not again.committed
			and applied.describe().replace("; committed", "") == again.describe().replace("; derived only", "")
			and review.mote_runtime.run_build().describe() == twin.run_build().describe(),
		"%s's application is not the whole build's derivation: %s / %s" % [label,
			"none" if applied == null else applied.describe(), again.describe()])
	var taken_again: RiftRunLevelUpResult = review.mote_runtime.choose_level_up_lane(lane)
	_expect(twin.consumption_ledger().count() == 1 and twin.consumption_ledger().has_consumed(ROUTE_SEED)
			and not taken_again.succeeded() and taken_again.failure_reason() == NO_OFFER and review.mote_runtime.level() == 2,
		"%s: root seed %d was not spent exactly once (%s)" % [label, ROUTE_SEED, taken_again.failure_reason()])
	_expect(review.receipt_text("choice") == EXPECTED_CHOICES[lane]
			and review.receipt_text("level") == "Rift level 1 → 2 · 0 XP carried over"
			and review.receipt_text("progression") == (SUPPORT_PROGRESSION if lane == RiftOffer.Lane.SUPPORT else "")
			and review.live_receipt_control().is_visible_in_tree() and review.live_receipt_text() == EXPECTED_LIVE[lane],
		"%s's receipt reads %s" % [label, str(_receipt_lines())])
	print("  %s: granted [%s] from root seed %d; the same record as G4's; applied on physics frame %d, the input's own; receipt '%s' / '%s'"
		% [label, ", ".join(receipt.granted_identity()), receipt.root_seed, int(taken["applied_at"]),
			review.receipt_text("choice"), review.live_receipt_text()])


## A directly driven G4 run of the route's seed, given the same experience in the
## review's amount and opened from the same catalogues.
func _twin_opened(motes: int) -> RiftRunLevelCoordinator:
	var twin: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(ROUTE_SEED)
	for mote: int in motes:
		_expect_quiet(twin.award_experience(REVIEW_AMOUNT).is_empty(), "the twin refused an award")
	_expect_quiet(twin.open_current_offer(SkillSupportCatalogue.skill_profiles(), SkillSupportCatalogue.support_definitions(),
		PassiveCardCatalogue.records()).is_empty(), "the twin did not open its offer")
	return twin


# --- The live character ------------------------------------------------------------------------------------------------

func _live() -> Dictionary:
	var strike: QuickStrikeData = review.player.attack.data
	return {
		"max_speed": review.player.max_speed,
		"increased": review.player.increased_attack_speed(),
		"effective": review.player.attack.effective_action_time(),
		"action_time": strike.action_time,
		"reach": strike.reach,
		"arc": strike.release_arc_degrees,
		"cone": strike.soft_target_cone_degrees,
		"targets": strike.maximum_targets,
		"margin": strike.approach_stop_margin,
		"soft_distance": strike.soft_target_distance,
		"mana_cost": strike.mana_cost,
		"weapon_damage": review.player.physical_damage,
		"max_life": review.player.max_life,
		"acceleration": review.player.acceleration,
		"braking": review.player.braking,
		"arrival": review.player.arrival_tolerance,
	}


func _is_baseline(live: Dictionary) -> bool:
	return float(live["max_speed"]) == ACCEPTED_MAX_SPEED and float(live["increased"]) == 0.0 \
		and float(live["effective"]) == ACCEPTED_ACTION_TIME and float(live["action_time"]) == ACCEPTED_ACTION_TIME \
		and float(live["reach"]) == ACCEPTED_REACH and float(live["arc"]) == ACCEPTED_ARC \
		and float(live["cone"]) == ACCEPTED_CONE and int(live["targets"]) == 1


func _is_canonical(record: QuickStrikeData) -> bool:
	return record != null and record.action_time == ACCEPTED_ACTION_TIME and record.reach == ACCEPTED_REACH \
		and record.release_arc_degrees == ACCEPTED_ARC and record.soft_target_cone_degrees == ACCEPTED_CONE \
		and record.maximum_targets == 1 and record.release_marker_normalized == ACCEPTED_MARKER


func _live_line(live: Dictionary) -> String:
	return "movement %.1f m/s, Skill Speed +%.0f%% (action time %.4f s), reach %.2f m, arc %.0f°, cone %.0f°, %d target(s)" % [
		float(live["max_speed"]), 100.0 * float(live["increased"]), float(live["effective"]), float(live["reach"]),
		float(live["arc"]), float(live["cone"]), int(live["targets"]),
	]


func _record_line(record: QuickStrikeData) -> String:
	if record == null:
		return "no record"
	return "%.2f s, reach %.2f m, arc %.0f°, cone %.0f°, %d target(s), marker %.3f" % [
		record.action_time, record.reach, record.release_arc_degrees, record.soft_target_cone_degrees,
		record.maximum_targets, record.release_marker_normalized,
	]


# --- Real swings, walks and queries ----------------------------------------------------------------------------------------

## One press and release of the controller's Quick Strike button through the viewport,
## followed until the action is READY again. Ticks are counted from the press: the
## release and the finish are the physics ticks on which the kernel fired them.
func _swing(sample_tick: int = SAMPLE_TICK) -> Dictionary:
	await _until_neutral()
	await _until_ready()
	await _as_controller()
	var attack: QuickStrikeAction = review.player.attack
	var marks: Dictionary = {
		"release": -1, "finish": -1, "anim_release": -1.0, "outcome": {}, "sample_tick": -1,
		"sample_anim": -1.0, "sample_norm": -1.0, "windup_distance": -1.0,
	}
	var start: int = Engine.get_physics_frames()
	var on_release: Callable = func(_id: int, outcome: Dictionary) -> void:
		if int(marks["release"]) < 0:
			marks["release"] = Engine.get_physics_frames() - start
			marks["anim_release"] = review.player.quick_strike_animation_position()
			marks["outcome"] = outcome
	var on_phase: Callable = func(next: int) -> void:
		if next == QuickStrikeAction.Phase.WINDUP and float(marks["windup_distance"]) < 0.0 and attack.target != null:
			marks["windup_distance"] = _planar_gap(review.player.global_position, attack.target.global_position)
		if next == QuickStrikeAction.Phase.READY and int(marks["finish"]) < 0:
			marks["finish"] = Engine.get_physics_frames() - start
	attack.use_released.connect(on_release)
	attack.phase_changed.connect(on_phase)
	var queries: int = attack.release_queries
	var releases: int = attack.uses_released
	var damage: int = attack.damage_events
	_push_joy(QUICK_STRIKE_BUTTON, true)
	## Which aim path the press was actually taken on — recorded, never assumed.
	marks["family"] = review.input_family.family
	var began: int = attack.phase
	var target: PrototypeTargetable = attack.target
	var acquisition: String = attack.last_acquisition
	_push_joy(QUICK_STRIKE_BUTTON, false)
	_swings += 1
	for i: int in 300:
		await get_tree().physics_frame
		## Resumed before this frame's tick: the ticks already processed since the press.
		var ticks: int = Engine.get_physics_frames() - start - 1
		if ticks == sample_tick and int(marks["sample_tick"]) < 0 and attack.phase == QuickStrikeAction.Phase.WINDUP:
			marks["sample_tick"] = ticks
			marks["sample_anim"] = review.player.quick_strike_animation_position()
			marks["sample_norm"] = attack.action_normalized_time()
		if int(marks["finish"]) >= 0 or began == QuickStrikeAction.Phase.READY:
			break
	attack.use_released.disconnect(on_release)
	attack.phase_changed.disconnect(on_phase)
	marks["began"] = began
	marks["target"] = target
	marks["acquisition"] = acquisition
	marks["queries"] = attack.release_queries - queries
	marks["releases"] = attack.uses_released - releases
	marks["damage"] = attack.damage_events - damage
	return marks


## The controller's Quick Strike button held through `releases` releases, then let go.
## The kernel measures each interval between consecutive releases itself.
func _cadence(releases: int = 5) -> Dictionary:
	await _until_neutral()
	await _until_ready()
	await _as_controller()
	var attack: QuickStrikeAction = review.player.attack
	var seen: Dictionary = {"n": 0, "intervals": []}
	var on_release: Callable = func(_id: int, _outcome: Dictionary) -> void:
		seen["n"] = int(seen["n"]) + 1
		if int(seen["n"]) > 1:
			(seen["intervals"] as Array).append(attack.last_repeat_interval)
	attack.use_released.connect(on_release)
	var queries: int = attack.release_queries
	_push_joy(QUICK_STRIKE_BUTTON, true)
	var family: int = review.input_family.family
	_swings += 1
	for i: int in 900:
		await get_tree().physics_frame
		if int(seen["n"]) >= releases:
			break
	_push_joy(QUICK_STRIKE_BUTTON, false)
	await _until_ready()
	attack.use_released.disconnect(on_release)
	var intervals: Array = seen["intervals"]
	var total: float = 0.0
	for interval: Variant in intervals:
		total += float(interval)
	return {
		"releases": int(seen["n"]), "queries": attack.release_queries - queries,
		"mean": total / maxf(float(intervals.size()), 1.0), "intervals": intervals, "family": family,
	}


## A real click-to-move command, followed for 90 physics ticks: the highest planar speed,
## and the highest speed over any 12-tick window of measured displacement.
func _walk(from: Vector3, to: Vector3) -> Dictionary:
	_stand(from)
	await _settle(2)
	await _until_neutral()
	var resolved: Dictionary = PrototypeGroundPointer.resolve_to_navigation(review.navigation_map(), to)
	review.player.command_move_to(resolved["point"], to, bool(resolved["adjusted"]))
	var positions: Array[Vector3] = []
	var top: float = 0.0
	for i: int in 90:
		await get_tree().physics_frame
		positions.append(review.player.global_position)
		top = maxf(top, review.player.planar_speed())
	var window: int = 12
	var plateau: float = 0.0
	for i: int in range(positions.size() - window):
		plateau = maxf(plateau, _planar_gap(positions[i], positions[i + window]) / (float(window) * _dt()))
	_stand(from)
	await _settle(2)
	return {"top": top, "plateau": plateau, "distance": _planar_gap(from, to)}


## The kernel's own release query, asked with `record` for the player where they stand.
func _release_query(record: QuickStrikeData) -> Dictionary:
	return review.acquisition.resolve_release(review.player.global_position, review.player.facing_direction(),
		null, review._target_candidates(), record)


## The kernel's own controller soft-target search, asked with `record` along the facing.
func _soft_query(record: QuickStrikeData) -> Dictionary:
	return review.acquisition.soft_target(review.player.global_position, review.player.facing_direction(),
		review._target_candidates(), record)


func _considered_for(outcome: Dictionary, enemy: PrototypeGraveblade) -> Dictionary:
	for record: Dictionary in outcome.get("considered", []):
		if record.get("fixture") == _area(enemy):
			return record
	return {}


func _area(enemy: PrototypeGraveblade) -> PrototypeTargetable:
	return enemy.get_node_or_null("TargetArea") as PrototypeTargetable


func _ticks_match(ticks: int, seconds: float) -> bool:
	var dt: float = _dt()
	return ticks * dt >= seconds - 0.000001 and ticks * dt < seconds + dt + 0.000001


func _dt() -> float:
	return 1.0 / float(Engine.physics_ticks_per_second)


func _until_neutral() -> void:
	for i: int in 30:
		if not review.player.awaiting_neutral and not get_tree().paused:
			return
		await _await_process_frames(1)


## Waits until the action is READY, and ALWAYS returns from the idle step, after every
## physics tick of this frame has run. A press pushed from inside a physics-frame resume
## is ticked by that same frame, so tick counts measured from it would read one short —
## which the first development run of this suite did, and recorded.
func _until_ready() -> void:
	for i: int in 300:
		if review.player.attack.phase == QuickStrikeAction.Phase.READY:
			break
		await get_tree().physics_frame
	await get_tree().process_frame


## THE CONTROLLER FAMILY, BEFORE EVERY CONTROLLER PRESS. The accepted input-family
## tracker refuses a family change within its 0.20 s anti-flicker cooldown, so a joypad
## press pushed a few milliseconds after a key — as this harness pushes them, and no
## hand does — is aimed by the MOUSE path, toward the cursor. The first development
## runs of this suite did exactly that after every level-up choice, and the swing turned
## the character toward the cursor; the 70° check still passed only because 34° is
## also inside 180°. So the harness waits out the cooldown before it presses, and every
## press records the family it was taken on.
func _as_controller() -> void:
	if review.input_family.family == InputFamilyTracker.Family.CONTROLLER:
		return
	await get_tree().create_timer(review.input_family.switch_cooldown_seconds + 0.05).timeout
	await get_tree().process_frame


# --- Places -------------------------------------------------------------------------------------------------------------

func _elite_hall_centre() -> Vector3:
	return _rounded(review.room_modules[2].room_centres()[0])


func _elite_hall_near() -> Vector3:
	return _elite_hall_centre() - Vector3(4.0, 0.0, 0.0)


func _elite_hall_far() -> Vector3:
	return _elite_hall_centre() + Vector3(4.0, 0.0, 0.0)


func _forward() -> Vector3:
	var facing: Vector3 = review.route_forward()
	facing.y = 0.0
	return facing.normalized()


func _stand_facing(at: Vector3, facing: Vector3) -> void:
	_stand(at)
	review.player.face_instantly(facing)


# --- Input, through the viewport --------------------------------------------------------------------------------------------

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


func _hover(control: Control) -> void:
	var at: Vector2 = control.get_global_rect().get_center()
	var motion: InputEventMouseMotion = InputEventMouseMotion.new()
	motion.position = at
	motion.global_position = at
	get_viewport().push_input(motion, true)


## Moves the pointer over the open world, so no interface control is left hovered when
## an attack is pressed.
func _clear_hover() -> void:
	var at: Vector2 = Vector2(get_viewport().get_visible_rect().size) * Vector2(0.5, 0.4)
	var motion: InputEventMouseMotion = InputEventMouseMotion.new()
	motion.position = at
	motion.global_position = at
	get_viewport().push_input(motion, true)
	await _await_process_frames(2)


func _push_mouse(at: Vector2, button: MouseButton, pressed: bool) -> void:
	var click: InputEventMouseButton = InputEventMouseButton.new()
	click.button_index = button
	click.pressed = pressed
	click.position = at
	click.global_position = at
	get_viewport().push_input(click, true)


func _set_pickup(value: bool) -> void:
	if review.automatic_pickup != value:
		await _key(KEY_F8)
	_expect(review.automatic_pickup == value, "F8 did not turn automatic pickup %s" % ("ON" if value else "OFF"))


# --- Evidence -----------------------------------------------------------------------------------------------------------

## Adds no assertion: the rendered runs pin the same count as the headless one.
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


## EVIDENCE INSTRUMENTATION, drawn only for a rendered frame and removed after it: the
## canonical release envelope in copper, the live one in violet, both read from the
## records the query reads on this frame, and a white line to the Graveblade 70° off.
func _show_envelope(origin: Vector3, facing: Vector3, target_at: Vector3) -> Node3D:
	var live: QuickStrikeData = review.player.attack.data
	var baseline: QuickStrikeData = review.player.attack.canonical_data
	var material: StandardMaterial3D = StandardMaterial3D.new()
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.vertex_color_use_as_albedo = true
	material.no_depth_test = true
	var mesh: ImmediateMesh = ImmediateMesh.new()
	mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	var yaw: float = atan2(facing.x, facing.z)
	_sector(mesh, baseline.reach, baseline.release_arc_degrees, yaw, Color(0.92, 0.62, 0.28))
	_sector(mesh, live.reach, live.release_arc_degrees, yaw, Color(0.72, 0.58, 0.98))
	var mark: Vector3 = target_at - origin
	mesh.surface_set_color(Color(1.0, 1.0, 1.0))
	mesh.surface_add_vertex(Vector3.ZERO)
	mesh.surface_set_color(Color(1.0, 1.0, 1.0))
	mesh.surface_add_vertex(Vector3(mark.x, 0.0, mark.z))
	mesh.surface_end()
	var node: MeshInstance3D = MeshInstance3D.new()
	node.name = "VerificationEnvelope"
	node.mesh = mesh
	node.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	review.add_child(node)
	node.global_position = Vector3(origin.x, 0.06, origin.z)
	return node


func _sector(mesh: ImmediateMesh, radius: float, arc_degrees: float, yaw: float, colour: Color) -> void:
	var half: float = deg_to_rad(arc_degrees * 0.5)
	var steps: int = maxi(2, int(round(72.0 * arc_degrees / 360.0)))
	var previous: Vector3 = Vector3(sin(yaw - half) * radius, 0.0, cos(yaw - half) * radius)
	for step: int in range(1, steps + 1):
		var angle: float = yaw - half + 2.0 * half * float(step) / float(steps)
		var here: Vector3 = Vector3(sin(angle) * radius, 0.0, cos(angle) * radius)
		mesh.surface_set_color(colour)
		mesh.surface_add_vertex(previous)
		mesh.surface_set_color(colour)
		mesh.surface_add_vertex(here)
		previous = here
	for edge: float in [yaw - half, yaw + half]:
		mesh.surface_set_color(colour)
		mesh.surface_add_vertex(Vector3.ZERO)
		mesh.surface_set_color(colour)
		mesh.surface_add_vertex(Vector3(sin(edge) * radius, 0.0, cos(edge) * radius))


func _argument_value(flag: String) -> String:
	var index: int = arguments.find(flag)
	if index == -1 or index + 1 >= arguments.size():
		return ""
	return arguments[index + 1]


# --- Helpers -----------------------------------------------------------------------------------------------------------------

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
		return "no runtime; loop=%d open=%s paused=%s" % [review.loop_state, str(review.level_up_panel.is_open), str(get_tree().paused)]
	return "level=%d experience=%.1f active=%s uncollected=%d calls=%d attempted=%s open=%s paused=%s" % [
		review.mote_runtime.level(), review.mote_runtime.experience(), str(review.mote_runtime.is_offer_active()),
		review.mote_runtime.uncollected_count(), review.offer_open_calls, str(review.offer_attempted()),
		str(review.level_up_panel.is_open), str(get_tree().paused)]


## Every field of a run-level record and the copy of the receipt it carries, as one line.
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


func _hud_text(index: int) -> String:
	return review.experience_hud.text_controls()[index].text


func _receipt_lines() -> PackedStringArray:
	var lines: PackedStringArray = PackedStringArray()
	var controls: Array[Control] = review.receipt_controls()
	controls.append(review.live_receipt_control())
	for control: Control in controls:
		if control.is_visible_in_tree():
			lines.append((control as Label).text.replace("\n", " / "))
	return lines


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
			if not line.is_empty() and not line.begins_with("\t") and not line.begins_with(" ") \
					and not line.begins_with(")"):
				break
			body.append(line)
	return "\n".join(body)


func _files_under(root: String, extensions: Array[String]) -> PackedStringArray:
	var out: PackedStringArray = PackedStringArray()
	var directory: DirAccess = DirAccess.open(root)
	if directory == null:
		return out
	directory.list_dir_begin()
	var entry: String = directory.get_next()
	while not entry.is_empty():
		var full: String = "%s/%s" % [root, entry]
		if directory.current_is_dir():
			if not entry.begins_with("."):
				out.append_array(_files_under(full, extensions))
		else:
			for extension: String in extensions:
				if entry.ends_with(extension):
					out.append(full)
					break
		entry = directory.get_next()
	directory.list_dir_end()
	return out


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
