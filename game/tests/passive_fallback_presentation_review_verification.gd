extends SceneTree
## Riftwrought — Roguelite I10: Three-Card Passive-Fallback Presentation Review:
## automated, rendered verification (decision D-312, corrected under D-313).
##
## THE D-313 CORRECTION, AND WHAT IT ADDS HERE. A fallback receipt now reads the card's name
## and canonical effect — "Support — Power (+10% Global Damage)" — over its own category line;
## and while any offer stands the previous receipt is hidden, only the receipt heading and the
## standing line showing behind the modal. So every standing moment is read (check 21), each
## Level 5 choice is read on both sides of its input, and two more expeditions, D and E, take
## an ORDINARY passive lane of the same fallback offer to prove those receipts unchanged (22).
##
## THE ONE QUESTION: when an exhausted Support lane carries the passive card the accepted
## fallback chose (I7), does the accepted three-card panel (I2) show it honestly, take it
## through the accepted choice path (I8), and give the right receipt (I9)?
##
## IT OWNS NO SCENE AND ADDS NO ENTRY POINT TO ANY RUNTIME. This is a SceneTree script: it
## loads the accepted I2 scene, `roguelite_level_up_choice_review.tscn`, exactly as it
## ships, and drives it from outside. The scene answers only its own I2 flag, which this
## harness does not pass, so no accepted suite starts in it.
##
## A passive fallback exists only once both shipped supports are at their maximum rank,
## which takes four Support choices. Since Roguelite I11 (D-314) the playable scene asks
## EACH level's offer on its own tick once that level's requirement is met; this suite still
## opens Levels 2–5 itself, in the same call as each award, before the review's next tick can
## ask — so its openings stay its own, exactly as accepted under D-313. It DELIBERATELY
## PREPARES A VALID LATER-RUN STATE through accepted public operations only, and then shows
## the next offer through the review's own panel:
##
##   1. a deterministic expedition of run seed 99 begins through the Rift Gate;
##   2. each level's exact requirement, read from G1, is awarded explicitly: one production
##      Graveblade per award, registered with the expedition's own H8 runtime for exactly
##      that amount, killed through its own `receive_damage()`, and its mote collected by
##      one explicit H8 sweep at the spot it fell;
##   3. at Level 1 the review opens its accepted offer ON ITS OWN, and Support is taken with
##      Enter on the panel; at Levels 2, 3 and 4 the offer is opened explicitly through H8
##      and shown in the review's own panel from the review's own `standing_offer_cards()`
##      reading, and Support is taken with Enter on that panel — so every preparation
##      choice is the accepted H8 -> G4 -> E2 -> D3 transaction through the accepted card
##      path;
##   4. both supports are then at their maximum rank, and the Level 5 offer — opened and
##      shown the same way — carries the passive fallback.
##
## No private field is written, no special constructor is called, no debug command or state
## injector exists, no loop repeats a level-up — the four are four written steps — and no
## InputMap action is added. Check 1 asserts all of that from this file's own code.
##
## TWO TWINS ARE DRIVEN IN LOCKSTEP BESIDE THE REVIEW'S OWN RUN, from the same seed, the
## same awards and the same catalogues: a G4 run, whose ledger is readable, and an E2
## lifecycle chained level by level through `next_level_coordinator()` with G1's
## requirement and G2's root seed — the only way to ask E2's own reading, because G4 never
## hands its lifecycle out.
##
## STAGED, AND STATED WHERE IT HAPPENS:
##   - expeditions B, C, D and E are handed seed 99 again by replacing the Nexus's next run
##     plan (D-294 ruling 4);
##   - the Teaching Hall's Graveblade has its AI turned off, so play between choices cannot
##     reach the player;
##   - the awards of step 2, their fixture Graveblades and their explicit sweeps, after each
##     of which H9's review panel is asked to refresh, because an explicit sweep does not
##     pass through H9's own presentation of a sweep;
##   - the offers after Level 1 are opened and shown by this suite, as step 3 states;
##   - the refused choices hand the review's card entry point lanes 7 and -1, which no card
##     can produce.
##
## EVERY EXPECTED ANSWER IS A TYPED LITERAL — measured once by a scratch probe outside the
## project before this suite was written — OR THE ACCEPTED MECHANISM'S OWN ANSWER.
##
## IT PORTS D-211's OWED-SET DISCIPLINE and GATE F's ON-SCREEN MEASUREMENT. The evidence
## frames add no assertion, so the headless and rendered runs pin the same count.
##
## Run: godot --headless --path game --script res://tests/passive_fallback_presentation_review_verification.gd -- --seed 99

const REVIEW_SCENE: String = "res://scenes/roguelite/roguelite_level_up_choice_review.tscn"
const REVIEW_SCRIPT: String = "res://scripts/roguelite/level_up/roguelite_level_up_choice_review.gd"
const PANEL_SCRIPT: String = "res://scripts/roguelite/level_up/rift_level_up_offer_panel.gd"
const E2_FILE: String = "res://scripts/levels/rift_level_up_coordinator.gd"
const G4_FILE: String = "res://scripts/levels/rift_run_level_coordinator.gd"
const H8_FILE: String = "res://scripts/experience/rift_mote_runtime.gd"
const THIS_FILE: String = "res://tests/passive_fallback_presentation_review_verification.gd"
const GRAVEBLADE_SCENE: String = "res://scenes/actors/prototype_graveblade.tscn"
const PROJECT_SETTINGS_FILE: String = "res://project.godot"
const ENTRYPOINT: String = "res://scenes/app/prototype_app.tscn"
const EXPECTED_ACTIONS: int = 31

const ROUTE_SEED: int = 99
const SUPPORT: int = 0

## The accepted sentinels and kinds, typed independently and asserted against the owners.
const NO_CONTENT: int = -1
const NO_CATEGORY: int = -1
const PROGRESSION: int = 0
const FALLBACK: int = 1
const NO_RANK: int = 0

## Seed 99's chain, measured by the scratch probe before this suite was written.
const REQUIREMENTS: Array[float] = [100.0, 125.0, 150.0, 175.0, 200.0]
const NEXT_REQUIREMENT: float = 225.0
const ROOTS: Array[int] = [99, 1000102, 2000105, 3000108, 4000111]
const PREPARATION_IDENTITIES: Array = [
	[["quick_strike", "sweeping_edge"], ["card_celerity"], ["card_fleetness"]],
	[["quick_strike", "reaching_edge"], ["card_power"], ["card_magnetism"]],
	[["quick_strike", "reaching_edge"], ["card_vitality"], ["card_fleetness"]],
	[["quick_strike", "sweeping_edge"], ["card_power"], ["card_magnetism"]],
]
const PREPARATION_PROGRESSIONS: Array[String] = [
	"a new compatible pair, rank 0 -> 1", "a new compatible pair, rank 0 -> 1",
	"another rank of a held pair, rank 1 -> 2", "another rank of a held pair, rank 1 -> 2",
]
const PREPARATION_CHOICES: Array[String] = [
	"Support — Quick Strike → Sweeping Edge", "Support — Quick Strike → Reaching Edge",
	"Support — Quick Strike → Reaching Edge", "Support — Quick Strike → Sweeping Edge",
]
## Seed 99's accepted Level 1 cards, word for word (D-293, accepted under D-294).
const LEVEL_ONE_CARDS: Array = [
	["Support", "Sweeping Edge", "Applies to Quick Strike"],
	["Combat and Defence", "Celerity", "+10% Skill Speed"],
	["Utility", "Fleetness", "+10% Movement Speed"],
]
const FALLBACK_IDENTITIES: Array = [["card_power"], ["card_vitality"], ["card_fleetness"]]
const FALLBACK_CARDS: Array = [
	["Support", "Power", "Supports maxed — +10% Global Damage"],
	["Combat and Defence", "Vitality", "+15% Maximum Life"],
	["Utility", "Fleetness", "+10% Movement Speed"],
]
const FALLBACK_CAPTIONS: Array[String] = ["Choose Power", "Choose Vitality", "Choose Fleetness"]
const FALLBACK_CARD: StringName = &"card_power"
const FALLBACK_CATEGORY: int = 0
## The fallback receipt's choice line: the card's name and its canonical effect (D-313).
const FALLBACK_CHOICE: String = "Support — Power (+10% Global Damage)"
const FALLBACK_SECONDARY: String = "Passive fallback from Combat and Defence"
## The two ordinary passive lanes of the same fallback offer, taken in expeditions D and E,
## and the receipt each gives, word for word in I2's accepted form (D-293).
const COMBAT: int = 1
const UTILITY: int = 2
const PASSIVE_RECEIPTS: Array[String] = [
	"", "Combat and Defence — Vitality (+15% Maximum Life)", "Utility — Fleetness (+10% Movement Speed)",
]
const FALLBACK_LEVEL_LINE: String = "Rift level 5 → 6 · 0 XP carried over"
const FALLBACK_DIAGNOSTIC: String = "passive fallback: card_power, drawn from Combat and Defence"
const QUICK_STRIKE: StringName = &"quick_strike"
const SWEEPING_EDGE: StringName = &"sweeping_edge"
const REACHING_EDGE: StringName = &"reaching_edge"
const MAXIMUM_RANK: int = 2
const HELD_PAIRS: Array[String] = ["quick_strike -> reaching_edge", "quick_strike -> sweeping_edge"]

const GREYBOX_NOTE: String = "Choices are recorded in this expedition's temporary build. Applying their effects to the playable character is not part of this review."
const OFFER_STANDING_TEXT: String = "Level-up offer open — choose one of the three cards."
const RECEIPT_TITLE_TEXT: String = "Temporary build — this expedition"
const RECEIPT_NOTE: String = "Recorded in the temporary build; not applied to the character in this review."
const NO_OFFER: String = "no offer is open; one must be opened before a lane may be taken"
const REFUSAL_PREFIX: String = "That choice was refused: "
## Everything the receipt section may show while an offer stands (D-313).
const STANDING_LINES: Array[String] = [RECEIPT_TITLE_TEXT, OFFER_STANDING_TEXT]

## The accepted live values (D-175, D-178 and the canonical Quick Strike record).
const ACCEPTED_MAX_SPEED: float = 5.0
const ACCEPTED_ACTION_TIME: float = 0.80
const ACCEPTED_REACH: float = 1.65
const ACCEPTED_ARC: float = 100.0
const ACCEPTED_CONE: float = 65.0

## H9's review-panel text controls, in its `text_controls()` order.
const HUD_LEVEL: int = 2
const HUD_EXPERIENCE: int = 3
const HUD_LEVEL_UP: int = 8
const HUD_LEVEL_UP_NOTE: int = 9

## The receipt section's controls, in `receipt_controls()` order.
const RECEIPT_TITLE: int = 0
const RECEIPT_STATUS: int = 1
const RECEIPT_CHOICE: int = 2
const RECEIPT_PROGRESSION: int = 3
const RECEIPT_LEVEL: int = 4
const RECEIPT_NOTE_LINE: int = 5

## Words and fragments no card may show: internal vocabulary and stable ids. Every catalogue
## id, the offer's seeds and the fallback's tickets are added at the moment they are read.
const VISIBLE_FORBIDDEN: Array[String] = [
	"fallback", "Fallback", "FALLBACK", "ticket", "Ticket", "weight", "Weight", "category",
	"Category", "card_", "PASSIVE", "PROGRESSION", "content kind", "x100", "rank",
]

## What this harness must never do to the review or the run: write a private field, swap
## the runtime, call a special constructor, reflect, inject a state, script a debug path or
## touch the InputMap. Read over this file's own CODE, comments removed and strings emptied.
const INJECTION_PATTERNS: Array[String] = [
	"mote_runtime = ", "review._", ".mote_runtime._", "with_state(", ".set(", ".set_script(",
	".call(", ".callv(", "set_meta(", "_offer_attempted", "_open_offer_when_ready",
	"add_action(", "action_add_event(", "while ", "_receipt_from(", "_card_for(",
]

const OWED_CHECKS: Array[String] = [
	"the_harness_is_isolated_and_the_playable_scene_asks_each_level_once",
	"the_reading_seam_is_one_line_per_layer_and_stores_nothing",
	"the_unresolved_answers_hold_with_no_offer_and_on_progression_offers",
	"the_accepted_seed_99_level_one_panel_and_receipt_are_unchanged",
	"each_preparation_level_is_awarded_exactly_and_consumes_one_distinct_seed",
	"both_supports_reach_their_maximum_rank_before_the_fallback_composes",
	"the_next_offer_is_a_passive_fallback_at_all_three_layers",
	"the_panel_shows_the_fallback_honestly_in_the_support_lane",
	"no_raw_id_number_or_fallback_term_is_visible_on_a_card",
	"the_fallback_panel_is_legible_and_centred",
	"refused_and_invalid_choices_keep_the_same_panel_open_and_paused",
	"offer_readings_do_not_alias_stored_state",
	"the_fallback_chosen_by_keyboard_closes_resumes_and_is_received",
	"the_fallback_receipt_is_legible_and_shows_no_progression",
	"the_fallback_card_is_held_once_more_and_no_support_moves",
	"the_next_offer_opens_on_its_own_after_the_fallback_choice",
	"the_fallback_chosen_by_controller_takes_the_same_transaction",
	"the_fallback_chosen_by_mouse_takes_the_same_transaction",
	"the_live_character_is_unchanged",
	"every_expedition_ends_clean",
	## Roguelite I10's correction (D-313).
	"the_previous_receipt_is_hidden_while_any_offer_stands",
	"ordinary_passive_receipts_on_the_fallback_offer_are_unchanged",
]

var review: RogueliteLevelUpChoiceReview
var arguments: PackedStringArray = PackedStringArray()

var _failures: PackedStringArray = PackedStringArray()
var _checks: int = 0
var _reached: Dictionary = {}
var _shot_dir: String = ""
var _stage: Node3D
var _next_use_id: int = 94000
var _fixtures: int = 0
var _deaths_driven: int = 0
var _expeditions: int = 0
var _staged_plans: int = 0
var _baseline: Dictionary = {}

## The two twins of the current expedition.
var _twin: RiftRunLevelCoordinator
var _chain: RiftLevelUpCoordinator

## Evidence gathered while preparing, read by the checks.
var _sentinel_readings: int = 0
var _sentinel_problems: PackedStringArray = PackedStringArray()
var _progression_readings: int = 0
var _progression_problems: PackedStringArray = PackedStringArray()
var _preparation_levels: int = 0
var _preparation_problems: PackedStringArray = PackedStringArray()
var _consumed_by_expedition: Dictionary = {}
var _level_one_cards: Array = []
var _level_one_receipt: PackedStringArray = PackedStringArray()
var _opened_by: PackedStringArray = PackedStringArray()
var _rank_problems: PackedStringArray = PackedStringArray()
var _rank_lines: PackedStringArray = PackedStringArray()
var _fallback_problems: PackedStringArray = PackedStringArray()
var _fallback_line: String = ""
var _choice_problems: Dictionary = {}
var _choice_lines: Dictionary = {}
var _build_lines: Dictionary = {}
var _build_problems: PackedStringArray = PackedStringArray()
var _live_problems: PackedStringArray = PackedStringArray()
var _live_readings: int = 0
var _quiet_problems: PackedStringArray = PackedStringArray()
var _teardowns: PackedStringArray = PackedStringArray()
## D-313: the receipt section read at every moment an offer stands, and at every choice.
var _hidden_readings: int = 0
var _hidden_problems: PackedStringArray = PackedStringArray()
var _appearances: int = 0
var _appearance_problems: PackedStringArray = PackedStringArray()
var _passive_receipt_lines: Dictionary = {}


func _initialize() -> void:
	_main.call_deferred()


func _main() -> void:
	arguments = OS.get_cmdline_user_args()
	_shot_dir = _argument_value("--shots")
	print("")
	print("=== Roguelite I10 — Three-Card Passive-Fallback Presentation Review verification (D-312, corrected under D-313) ===")
	_stage = Node3D.new()
	_stage.name = "I10FixtureStage"
	root.add_child(_stage)
	var changed: Error = change_scene_to_packed(load(REVIEW_SCENE) as PackedScene)
	for frame: int in 20:
		await process_frame
		if current_scene != null:
			break
	review = current_scene as RogueliteLevelUpChoiceReview
	if changed != OK or review == null:
		printerr("ROGUELITE PASSIVE-FALLBACK PRESENTATION REVIEW VERIFICATION: the accepted review scene did not load")
		quit(1)
		return
	await _settle(10)
	await _await_navigation()

	_check_the_harness_is_isolated_and_the_playable_scene_asks_each_level_once()
	_check_the_reading_seam_is_one_line_per_layer_and_stores_nothing()

	## Expedition A — prepared, then the fallback taken with the keyboard.
	await _begin_expedition("A")
	_baseline = _live_values()
	await _prepare_to_the_fallback("A")
	_check_the_accepted_seed_99_level_one_panel_and_receipt_are_unchanged()
	_check_each_preparation_level_is_awarded_exactly_and_consumes_one_distinct_seed()
	_check_both_supports_reach_their_maximum_rank_before_the_fallback_composes()
	_check_the_next_offer_is_a_passive_fallback_at_all_three_layers()
	await _check_the_panel_shows_the_fallback_honestly_in_the_support_lane()
	_check_no_raw_id_number_or_fallback_term_is_visible_on_a_card()
	await _check_the_fallback_panel_is_legible_and_centred()
	_check_refused_and_invalid_choices_keep_the_same_panel_open_and_paused()
	_check_offer_readings_do_not_alias_stored_state()
	_check_the_fallback_chosen_by_keyboard_closes_resumes_and_is_received()
	await _check_the_fallback_receipt_is_legible_and_shows_no_progression()
	_check_the_fallback_card_is_held_once_more_and_no_support_moves()
	await _check_the_next_offer_opens_on_its_own_after_the_fallback_choice()
	await _end_expedition("A")

	## Expedition B — prepared again, then the fallback taken with the controller.
	await _begin_expedition("B")
	await _prepare_to_the_fallback("B")
	await _check_the_fallback_chosen_by_controller_takes_the_same_transaction()
	await _end_expedition("B")

	## Expedition C — prepared again, then the fallback taken with the mouse.
	await _begin_expedition("C")
	await _prepare_to_the_fallback("C")
	await _check_the_fallback_chosen_by_mouse_takes_the_same_transaction()
	await _end_expedition("C")

	## Expeditions D and E (D-313) — prepared again, then an ORDINARY passive lane of the
	## same fallback offer taken: Combat and Defence with the keyboard, Utility with the mouse.
	await _begin_expedition("D")
	await _prepare_to_the_fallback("D")
	await _take_a_passive_lane("D", COMBAT)
	await _end_expedition("D")
	await _begin_expedition("E")
	await _prepare_to_the_fallback("E")
	await _take_a_passive_lane("E", UTILITY)
	await _end_expedition("E")
	_check_ordinary_passive_receipts_on_the_fallback_offer_are_unchanged()

	## Read last, over everything the five expeditions gathered.
	_check_the_unresolved_answers_hold_with_no_offer_and_on_progression_offers()
	_check_the_previous_receipt_is_hidden_while_any_offer_stands()
	_check_the_live_character_is_unchanged()
	_check_every_expedition_ends_clean()

	_check_every_check_ran()

	print("")
	print("  %d expeditions (%d given seed %d again by staging), %d fixture Graveblades registered and killed, %d level-ups taken through the review's panel, %d offer opening(s) asked by the review itself across this suite"
		% [_expeditions, _staged_plans, ROUTE_SEED, _fixtures, review.choices_taken, review.offer_open_calls])
	if _failures.is_empty():
		print("ROGUELITE PASSIVE-FALLBACK PRESENTATION REVIEW VERIFICATION: PASS (%d checks)" % _checks)
		quit(0)
	else:
		for failure: String in _failures:
			printerr("  FAIL: %s" % failure)
		printerr("ROGUELITE PASSIVE-FALLBACK PRESENTATION REVIEW VERIFICATION: %d FAILURE(S) of %d checks" % [
			_failures.size(), _checks,
		])
		quit(1)


# --- 1. Isolation ------------------------------------------------------------------------

func _check_the_harness_is_isolated_and_the_playable_scene_asks_each_level_once() -> void:
	print("")
	print("--- 1. The harness drives the accepted I2 scene unchanged, and that scene asks each level's offer once (Roguelite I11, D-314)")
	var script: GDScript = review.get_script() as GDScript
	_expect(review.scene_file_path == REVIEW_SCENE and script.resource_path == REVIEW_SCRIPT
			and review.get_node_or_null("RogueliteLevelUpChoiceReviewVerification") == null
			and review.get_node_or_null("RogueliteExperienceCollectionReviewVerification") == null
			and review.get_node_or_null("RogueliteCoreLoopVerification") == null,
		"the loaded scene is %s running %s, or an accepted suite started in it" % [review.scene_file_path, script.resource_path])
	var source: String = FileAccess.get_file_as_string(REVIEW_SCRIPT)
	var bare: String = _bare(source)
	## Roguelite I11 (D-314) moved this assertion one for one: the review no longer opens only
	## its Level 1 offer, it asks EACH level's offer once, from its one opening call, recorded
	## against that level, and shows every offer through standing_offer_cards() in one place.
	var opening: String = _function_body(bare, "_open_offer_when_ready")
	var asking: String = _function_body(bare, "_ask_for_current_offer")
	_expect(RogueliteLevelUpChoiceReview.NO_LEVEL_ASKED == 0 and not bare.contains("OFFERED_LEVEL")
			and asking.contains("_offer_attempted_level = mote_runtime.level()") and asking.count("open_level_up_offer(") == 1
			and bare.count("open_level_up_offer(") == 1 and bare.count("func standing_offer_cards()") == 1
			and bare.count("standing_offer_cards()") == 2
			and _function_body(bare, "_present_standing_offer").count("standing_offer_cards()") == 1
			and opening.contains("_current_level_is_owed_an_offer()")
			and not opening.contains("for ") and not opening.contains("while "),
		"the review no longer asks each level's offer once, from one opening call, showing it through standing_offer_cards() in one place")
	var flag: String = _function_body(source, "_maybe_start_verification")
	_expect(flag.contains("--verify-level-up") and not flag.contains("fallback") and not arguments.has("--verify-level-up"),
		"the review answers another flag, or this harness passed I2's")
	var actions: int = 0
	for action: StringName in InputMap.get_actions():
		if String(action).begins_with("ui_") and not String(action) in ["ui_confirm", "ui_cancel"]:
			continue
		actions += 1
	var settings: String = FileAccess.get_file_as_string(PROJECT_SETTINGS_FILE)
	_expect(actions == EXPECTED_ACTIONS
			and String(ProjectSettings.get_setting("application/run/main_scene", "")) == ENTRYPOINT
			and not settings.contains("[autoload]") and not settings.contains("passive_fallback_presentation"),
		"the InputMap holds %d actions, or project.godot moved" % actions)
	var own: String = _bare(FileAccess.get_file_as_string(THIS_FILE))
	var injected: PackedStringArray = PackedStringArray()
	for pattern: String in INJECTION_PATTERNS:
		if own.contains(pattern):
			injected.append(pattern)
	var raw_own: String = FileAccess.get_file_as_string(THIS_FILE)
	var listed: int = 0
	for pattern: String in INJECTION_PATTERNS:
		if raw_own.contains("\"%s\"" % pattern):
			listed += 1
	_expect(injected.is_empty() and listed == INJECTION_PATTERNS.size() and own.length() > 20000,
		"this harness's code names %s (%d of %d patterns listed)" % [", ".join(injected), listed, INJECTION_PATTERNS.size()])
	print("  the accepted scene %s runs %s; no accepted suite started; since I11 (D-314) the review asks each level's offer once, from one opening call, and asks standing_offer_cards() only where an offer is shown"
		% [REVIEW_SCENE.get_file(), REVIEW_SCRIPT.get_file()])
	print("  %d actions; the entrypoint is %s; project.godot declares no [autoload]; 0 of %d injection patterns in this harness's code"
		% [actions, ENTRYPOINT.get_file(), INJECTION_PATTERNS.size()])
	_done("the_harness_is_isolated_and_the_playable_scene_asks_each_level_once")


# --- 2. The reading seam ---------------------------------------------------------------------

func _check_the_reading_seam_is_one_line_per_layer_and_stores_nothing() -> void:
	print("")
	print("--- 2. E2 reads the offer's stored kind and category; G4 and H8 each delegate one line; nothing is stored")
	_expect(RiftOffer.UNRESOLVED_SUPPORT_CONTENT_KIND == NO_CONTENT and RiftOfferChoiceResult.NO_FALLBACK_CATEGORY == NO_CATEGORY
			and RiftOffer.NO_CATEGORY == NO_CATEGORY and RiftOffer.SupportContentKind.SUPPORT_PROGRESSION == PROGRESSION
			and RiftOffer.SupportContentKind.PASSIVE_FALLBACK == FALLBACK and RiftOffer.Lane.SUPPORT == SUPPORT
			and RiftOffer.Lane.COMBAT_DEFENCE == COMBAT and RiftOffer.Lane.UTILITY == UTILITY
			and RiftOfferChoiceResult.NO_RANK == NO_RANK,
		"the accepted sentinels or kinds are not the typed ones")
	var e2: String = _code(E2_FILE)
	var g4: String = _code(G4_FILE)
	var h8: String = _code(H8_FILE)
	var bodies: PackedStringArray = PackedStringArray([
		"|".join(_body_after(e2, "func offer_support_content_kind() -> int:")),
		"|".join(_body_after(e2, "func offer_support_fallback_category() -> int:")),
		"|".join(_body_after(g4, "func offer_support_content_kind() -> int:")),
		"|".join(_body_after(g4, "func offer_support_fallback_category() -> int:")),
		"|".join(_body_after(h8, "func offer_support_content_kind() -> int:")),
		"|".join(_body_after(h8, "func offer_support_fallback_category() -> int:")),
	])
	_expect(bodies == PackedStringArray([
			"if _offer == null:|return RiftOffer.UNRESOLVED_SUPPORT_CONTENT_KIND|return _offer.support_content_kind",
			"if _offer == null or _offer.support_content_kind != RiftOffer.SupportContentKind.PASSIVE_FALLBACK:|return RiftOfferChoiceResult.NO_FALLBACK_CATEGORY|return _offer.support_fallback.selected_category",
			"return _current.offer_support_content_kind()",
			"return _current.offer_support_fallback_category()",
			"return _run.offer_support_content_kind()",
			"return _run.offer_support_fallback_category()",
		]),
		"the six readings are %s" % " / ".join(bodies))
	## Declared right after each layer's own identity reading, answering an int, with no field added.
	var placed: PackedStringArray = PackedStringArray()
	for path: String in [E2_FILE, G4_FILE, H8_FILE]:
		var names: PackedStringArray = _declared_functions(FileAccess.get_file_as_string(path))
		var at: int = names.find("offer_identity_for")
		if at >= 0 and at + 2 < names.size() and names[at + 1] == "offer_support_content_kind" \
				and names[at + 2] == "offer_support_fallback_category":
			placed.append(path.get_file())
	var fields: PackedStringArray = PackedStringArray([
		", ".join(_script_fields(RiftLevelUpCoordinator.new())),
		", ".join(_script_fields(RiftRunLevelCoordinator.new(ROUTE_SEED))),
		", ".join(_script_fields(RiftMoteRuntime.new(ROUTE_SEED))),
	])
	_expect(placed.size() == 3 and fields == PackedStringArray([
			"_track, _build, _ledger, _offer, _requirement, _completed", "_run_seed, _current", "_run, _field, _bindings"]),
		"the readings follow the identity reading in %s; the fields are %s" % [", ".join(placed), " / ".join(fields)])
	## The review reads the kind once and never infers it from an identity's size.
	var review_bare: String = _bare(FileAccess.get_file_as_string(REVIEW_SCRIPT))
	var cards: String = _function_body(review_bare, "standing_offer_cards")
	var card_for: String = _function_body(review_bare, "_card_for")
	var receipt_from: String = _function_body(review_bare, "_receipt_from")
	_expect(review_bare.count("offer_support_content_kind()") == 1 and cards.count("mote_runtime.offer_support_content_kind()") == 1
			and not review_bare.contains("offer_support_fallback_category")
			and card_for.contains("support_content == RiftOffer.SupportContentKind.SUPPORT_PROGRESSION")
			and card_for.contains("support_content == RiftOffer.SupportContentKind.PASSIVE_FALLBACK")
			and receipt_from.contains("receipt.carries_support_fallback()")
			and receipt_from.contains("receipt.support_content_kind") and receipt_from.contains("receipt.support_fallback_category")
			and not card_for.contains(".size()") and not receipt_from.contains(".size()") and not cards.contains(".size()")
			and review_bare.count("level_up_panel.opened.connect(_refresh_receipt)") == 1
			and receipt_from.count("_with_effect(") == 2 and receipt_from.count("_passive_lines(") == 1
			and review_bare.count("% [name, effect]") == 1
			and _function_body(review_bare, "_refresh_receipt").contains("not _receipt.is_empty() and not standing"),
		"the review does not read the Support content kind once, infers it from an identity's size, or does not refresh its receipt when the panel opens")
	var declared: PackedStringArray = PackedStringArray()
	for line: String in review_bare.split("\n"):
		if line.begins_with("var "):
			declared.append(line.substr(4).get_slice(":", 0))
	_expect(", ".join(declared) == "level_up_panel, offer_open_calls, offer_open_refusals, last_offer_refusal, choice_attempts, choice_refusals, choices_taken, last_choice_record, last_retained_experience, _offer_attempted_level, _receipt, _receipt_rule, _receipt_title, _receipt_status, _receipt_choice, _receipt_progression, _receipt_level, _receipt_note",
		"the review declares %s" % ", ".join(declared))
	print("  E2 reads the standing offer's stored support_content_kind and, for a PASSIVE_FALLBACK only, its fallback's selected_category; G4 and H8 each hand both on in one line; each follows its layer's offer_identity_for(); fields %s"
		% " / ".join(fields))
	print("  the review asks offer_support_content_kind() once, in standing_offer_cards(); the card and the receipt branch on the stored kind and read no identity's size; its receipt section refreshes whenever the panel opens; the review declares the same 18 fields")
	_done("the_reading_seam_is_one_line_per_layer_and_stores_nothing")


# --- Preparation ----------------------------------------------------------------------------

## The whole preparation of one expedition: four Support level-ups written as four steps,
## then the Level 5 offer opened and shown.
func _prepare_to_the_fallback(label: String) -> void:
	_twin = RiftRunLevelCoordinator.new(ROUTE_SEED)
	_chain = RiftLevelUpCoordinator.new()
	await _take_support_at(label, 1)
	await _take_support_at(label, 2)
	await _take_support_at(label, 3)
	await _take_support_at(label, 4)
	await _open_the_fallback(label)


func _take_support_at(label: String, level: int) -> void:
	var index: int = level - 1
	var requirement: float = REQUIREMENTS[index]
	var moment: String = "%s at level %d" % [label, level]
	_note_sentinels("%s before its offer" % moment)
	var g1: RiftLevelRequirementReading = RiftLevelRequirementCurve.requirement_for(level)
	var g2: RiftLevelOfferSeedReading = RiftLevelOfferSeedDerivation.offer_root_seed_for(ROUTE_SEED, level)
	if not (g1.ok and g1.experience_requirement() == requirement and g2.ok and g2.offer_root_seed == ROOTS[index]):
		_preparation_problems.append("%s: G1 answers %s and G2 %d" % [moment, str(g1.experience_requirement()), g2.offer_root_seed])
	var calls_before: int = review.offer_open_calls
	if not (_award(requirement) and review.mote_runtime.level() == level and review.mote_runtime.experience() == requirement):
		_preparation_problems.append("%s: %s was not awarded exactly (%s)" % [moment, _amount_text(requirement), _state()])
	_expect_quiet(_twin.award_experience(requirement).is_empty() and _chain.award_experience(requirement).is_empty(),
		"%s: a twin refused the award" % moment)
	if level == 1:
		## The review's own automatic opening — the one the playable scene makes.
		await _settle(3)
		_opened_by.append("%s L1 by the review itself (%d call)" % [label, review.offer_open_calls - calls_before])
		if review.offer_open_calls != calls_before + 1 or not review.level_up_panel.is_open or not paused:
			_preparation_problems.append("%s: the review did not open its own offer (%s)" % [moment, _state()])
	else:
		var answer: String = review.mote_runtime.open_level_up_offer(
			SkillSupportCatalogue.skill_profiles(), SkillSupportCatalogue.support_definitions(), PassiveCardCatalogue.records())
		var shown: bool = review.level_up_panel.open_for_offer(review.standing_offer_cards())
		_opened_by.append("%s L%d explicitly" % [label, level])
		if not answer.is_empty() or not shown or review.offer_open_calls != calls_before or not paused:
			_preparation_problems.append("%s: the explicit opening answered '%s', shown %s" % [moment, answer, str(shown)])
		await _await_process_frames(2)
	_note_hidden("%s, its offer standing" % moment)
	_expect_quiet(_twin.open_current_offer(SkillSupportCatalogue.skill_profiles(), SkillSupportCatalogue.support_definitions(),
		PassiveCardCatalogue.records()).is_empty(), "%s: the G4 twin did not open" % moment)
	_expect_quiet(_chain.open_offer(requirement, SkillSupportCatalogue.skill_profiles(), SkillSupportCatalogue.support_definitions(),
		PassiveCardCatalogue.records(), ROOTS[index]).is_empty(), "%s: the E2 chain did not open" % moment)

	## The standing progression offer, as all three layers read it.
	var expected_line: String = _line(ROOTS[index], [0, 1, 2], PREPARATION_IDENTITIES[index], PROGRESSION, NO_CATEGORY)
	var lines: PackedStringArray = PackedStringArray([_h8_line(), _g4_line(), _e2_line()])
	_progression_readings += 1
	if lines != PackedStringArray([expected_line, expected_line, expected_line]):
		_progression_problems.append("%s: %s" % [moment, " / ".join(lines)])
	if level == 1 and label == "A":
		for slot: int in 3:
			_level_one_cards.append(Array(review.level_up_panel.card_lines(slot)))
	var support_card: PackedStringArray = review.level_up_panel.card_lines(0)
	var definition: SupportDefinition = SkillSupportCatalogue.support_definition(StringName(PREPARATION_IDENTITIES[index][0][1]))
	if support_card != PackedStringArray(["Support", definition.display_name(), "Applies to Quick Strike"]):
		_preparation_problems.append("%s: the Support card reads %s" % [moment, " / ".join(support_card)])

	## Support, with Enter, on the review's own panel.
	var attempts: int = review.choice_attempts
	_push_key(KEY_ENTER, true)
	_push_key(KEY_ENTER, false)
	var taken: Dictionary = _taken_reading()
	var twin_record: RiftRunLevelUpResult = _twin.choose(SUPPORT)
	var chain_receipt: RiftLevelUpResult = _chain.choose(SUPPORT)
	var record: RiftRunLevelUpResult = review.last_choice_record
	var receipt: RiftLevelUpResult = null if record == null else record.level_up()
	var identity: PackedStringArray = PackedStringArray(PREPARATION_IDENTITIES[index][0])
	if record == null or receipt == null or not record.succeeded() or not record.problem().is_empty() \
			or record.run_seed != ROUTE_SEED or record.source_level != level or receipt.root_seed != ROOTS[index] \
			or receipt.lane != SUPPORT or receipt.granted_identity() != identity \
			or receipt.support_content_kind != PROGRESSION or receipt.support_fallback_category != NO_CATEGORY \
			or receipt.support_progression_line() != PREPARATION_PROGRESSIONS[index] or receipt.carries_support_fallback():
		_preparation_problems.append("%s: the review took %s" % [moment, _record(record)])
	if _record(record) != _record(twin_record) or chain_receipt.describe() != receipt.describe() or not chain_receipt.problem().is_empty():
		_preparation_problems.append("%s: the review took %s where G4 took %s and E2 %s" % [
			moment, _record(record), _record(twin_record), chain_receipt.describe()])
	if bool(taken["open"]) or bool(taken["paused"]) or bool(taken["active"]) or int(taken["level"]) != level + 1 \
			or float(taken["experience"]) != 0.0 or review.choice_attempts != attempts + 1:
		_preparation_problems.append("%s: the choice left %s" % [moment, str(taken)])
	var level_line: String = "Rift level %d → %d · 0 XP carried over" % [level, level + 1]
	if review.receipt_text("choice") != PREPARATION_CHOICES[index] or review.receipt_text("progression") != PREPARATION_PROGRESSIONS[index] \
			or review.receipt_text("level") != level_line:
		_preparation_problems.append("%s: the receipt reads '%s' / '%s' / '%s'" % [moment, review.receipt_text("choice"),
			review.receipt_text("progression"), review.receipt_text("level")])
	if level == 1 and label == "A":
		_level_one_receipt = _receipt_lines()
	var again: RiftRunLevelUpResult = review.mote_runtime.choose_level_up_lane(SUPPORT)
	if again.succeeded() or again.failure_reason() != NO_OFFER or review.mote_runtime.level() != level + 1:
		_preparation_problems.append("%s: taking Support again answered '%s'" % [moment, again.failure_reason()])
	var consumed: PackedInt64Array = _twin.consumption_ledger().consumed_seeds()
	if consumed.size() != level or not consumed.has(ROOTS[index]):
		_preparation_problems.append("%s: the G4 twin's ledger holds %s" % [moment, str(consumed)])
	_consumed_by_expedition[label] = consumed
	_note_live("%s after Level %d's choice" % [label, level])
	_chain = _chain.next_level_coordinator()
	_preparation_levels += 1
	await _await_process_frames(2)


func _open_the_fallback(label: String) -> void:
	var moment: String = "%s at level 5" % label
	_note_sentinels("%s before its offer" % moment)
	var build: RiftRunBuild = review.mote_runtime.run_build()
	var twin_build: RiftRunBuild = _twin.run_build()
	var ranks: String = "%s: reaching_edge %d / %d, sweeping_edge %d / %d, twin %d / %d, %d card(s), pairs [%s]" % [
		label, build.support_rank_for(QUICK_STRIKE, REACHING_EDGE), SkillSupportCatalogue.support_maximum_rank(REACHING_EDGE),
		build.support_rank_for(QUICK_STRIKE, SWEEPING_EDGE), SkillSupportCatalogue.support_maximum_rank(SWEEPING_EDGE),
		twin_build.support_rank_for(QUICK_STRIKE, REACHING_EDGE), twin_build.support_rank_for(QUICK_STRIKE, SWEEPING_EDGE),
		build.passive_acquisitions(), ", ".join(build.support_pairs())]
	_rank_lines.append(ranks)
	if build.support_rank_for(QUICK_STRIKE, REACHING_EDGE) != MAXIMUM_RANK or build.support_rank_for(QUICK_STRIKE, SWEEPING_EDGE) != MAXIMUM_RANK \
			or SkillSupportCatalogue.support_maximum_rank(REACHING_EDGE) != MAXIMUM_RANK \
			or SkillSupportCatalogue.support_maximum_rank(SWEEPING_EDGE) != MAXIMUM_RANK \
			or twin_build.support_rank_for(QUICK_STRIKE, REACHING_EDGE) != MAXIMUM_RANK \
			or twin_build.support_rank_for(QUICK_STRIKE, SWEEPING_EDGE) != MAXIMUM_RANK \
			or build.passive_acquisitions() != 0 or build.support_pairs() != PackedStringArray(HELD_PAIRS):
		_rank_problems.append(ranks)
	var requirement: float = REQUIREMENTS[4]
	if not (_award(requirement) and review.mote_runtime.level() == 5 and review.mote_runtime.experience() == requirement):
		_fallback_problems.append("%s: %s was not awarded exactly (%s)" % [moment, _amount_text(requirement), _state()])
	_expect_quiet(_twin.award_experience(requirement).is_empty() and _chain.award_experience(requirement).is_empty(),
		"%s: a twin refused the award" % moment)
	var calls_before: int = review.offer_open_calls
	var answer: String = review.mote_runtime.open_level_up_offer(
		SkillSupportCatalogue.skill_profiles(), SkillSupportCatalogue.support_definitions(), PassiveCardCatalogue.records())
	var g2: RiftLevelOfferSeedReading = RiftLevelOfferSeedDerivation.offer_root_seed_for(ROUTE_SEED, 5)
	_expect_quiet(_twin.open_current_offer(SkillSupportCatalogue.skill_profiles(), SkillSupportCatalogue.support_definitions(),
		PassiveCardCatalogue.records()).is_empty(), "%s: the G4 twin did not open" % moment)
	_expect_quiet(_chain.open_offer(requirement, SkillSupportCatalogue.skill_profiles(), SkillSupportCatalogue.support_definitions(),
		PassiveCardCatalogue.records(), g2.offer_root_seed).is_empty(), "%s: the E2 chain did not open" % moment)
	var expected_line: String = _line(ROOTS[4], [0, 1, 2], FALLBACK_IDENTITIES, FALLBACK, FALLBACK_CATEGORY)
	var lines: PackedStringArray = PackedStringArray([_h8_line(), _g4_line(), _e2_line()])
	var record: PassiveCardDefinition = PassiveCardCatalogue.record(FALLBACK_CARD)
	_fallback_line = "H8 %s | G4 %s | E2 %s" % [lines[0], lines[1], lines[2]]
	if not answer.is_empty() or review.offer_open_calls != calls_before or not g2.ok or g2.offer_root_seed != ROOTS[4] \
			or lines != PackedStringArray([expected_line, expected_line, expected_line]) \
			or record == null or record.category() != FALLBACK_CATEGORY:
		_fallback_problems.append("%s: opened '%s'; %s" % [moment, answer, _fallback_line])
	var shown: bool = review.level_up_panel.open_for_offer(review.standing_offer_cards())
	if not shown or not review.level_up_panel.is_open or not paused:
		_fallback_problems.append("%s: the panel did not show the standing offer" % moment)
	await _await_process_frames(3)
	_note_hidden("%s, the fallback offer standing" % moment)


# --- 3. The unresolved answers ----------------------------------------------------------------

func _check_the_unresolved_answers_hold_with_no_offer_and_on_progression_offers() -> void:
	print("")
	print("--- 3. With no offer every layer answers the unresolved kind and the no-fallback category; on a progression offer the category stays unresolved")
	var fresh: PackedStringArray = PackedStringArray([
		str(RiftLevelUpCoordinator.new().offer_support_content_kind()), str(RiftLevelUpCoordinator.new().offer_support_fallback_category()),
		str(RiftRunLevelCoordinator.new(ROUTE_SEED).offer_support_content_kind()), str(RiftRunLevelCoordinator.new(ROUTE_SEED).offer_support_fallback_category()),
		str(RiftMoteRuntime.new(ROUTE_SEED).offer_support_content_kind()), str(RiftMoteRuntime.new(ROUTE_SEED).offer_support_fallback_category()),
	])
	_expect(fresh == PackedStringArray(["-1", "-1", "-1", "-1", "-1", "-1"]), "a fresh E2, G4 and H8 answer %s" % ", ".join(fresh))
	_expect(_sentinel_problems.is_empty() and _sentinel_readings == 31,
		"%d no-offer readings; %s" % [_sentinel_readings, "; ".join(_sentinel_problems)])
	_expect(_progression_problems.is_empty() and _progression_readings == 20,
		"%d progression-offer readings; %s" % [_progression_readings, "; ".join(_progression_problems)])
	print("  a fresh E2, G4 and H8 each answer kind -1 and category -1; %d no-offer readings of all three layers — before each of the 5 offers and after the Level 5 choice, in 5 expeditions, and after the Level 6 choice — all -1 / -1 with no offer standing"
		% _sentinel_readings)
	print("  %d progression offers (Levels 1–4 in 5 expeditions): all three layers read SUPPORT_PROGRESSION (0) and category -1, with the same root seed, lanes and identities" % _progression_readings)
	_done("the_unresolved_answers_hold_with_no_offer_and_on_progression_offers")


# --- 4. The accepted Level 1 ---------------------------------------------------------------------

func _check_the_accepted_seed_99_level_one_panel_and_receipt_are_unchanged() -> void:
	print("")
	print("--- 4. Seed 99's accepted Level 1 panel and Support receipt read word for word as accepted")
	_expect(_level_one_cards == LEVEL_ONE_CARDS, "Level 1's cards read %s" % str(_level_one_cards))
	_expect(_level_one_receipt == PackedStringArray([RECEIPT_TITLE_TEXT, PREPARATION_CHOICES[0], PREPARATION_PROGRESSIONS[0],
			"Rift level 1 → 2 · 0 XP carried over", RECEIPT_NOTE]),
		"Level 1's receipt reads %s" % str(_level_one_receipt))
	var lines: PackedStringArray = PackedStringArray()
	for card: Array in _level_one_cards:
		lines.append("%s: %s — %s" % [card[0], card[1], card[2]])
	print("  %s" % "; ".join(lines))
	print("  %s" % " | ".join(_level_one_receipt))
	_done("the_accepted_seed_99_level_one_panel_and_receipt_are_unchanged")


# --- 5. Preparation -----------------------------------------------------------------------------

func _check_each_preparation_level_is_awarded_exactly_and_consumes_one_distinct_seed() -> void:
	print("")
	print("--- 5. Each preparation level is awarded its exact requirement and consumes one distinct derived root seed, once")
	_expect(_preparation_problems.is_empty() and _preparation_levels == 4, "; ".join(_preparation_problems))
	var distinct: Dictionary = {}
	for root_seed: int in ROOTS:
		distinct[root_seed] = true
	var consumed: PackedInt64Array = _consumed_by_expedition.get("A", PackedInt64Array())
	_expect(distinct.size() == 5 and consumed == PackedInt64Array([99, 1000102, 2000105, 3000108]),
		"%d distinct roots; expedition A's twin consumed %s" % [distinct.size(), str(consumed)])
	_expect(_opened_by == PackedStringArray(["A L1 by the review itself (1 call)", "A L2 explicitly", "A L3 explicitly", "A L4 explicitly"]),
		"the openings were %s" % ", ".join(_opened_by))
	print("  Levels 1–4 awarded exactly 100, 125, 150 and 175 through fixture motes; the review opened Level 1 on its own and Levels 2–4 were opened explicitly through H8 and shown in its panel; Support taken with Enter at each")
	print("  root seeds 99, 1000102, 2000105, 3000108 — each G2's own for its level, each consumed once (taking Support again answered '%s'), each record identical to the G4 twin's and to the E2 chain's" % NO_OFFER)
	print("  receipts: %s" % " / ".join(PREPARATION_CHOICES))
	_done("each_preparation_level_is_awarded_exactly_and_consumes_one_distinct_seed")


# --- 6. Maximum rank ------------------------------------------------------------------------------

func _check_both_supports_reach_their_maximum_rank_before_the_fallback_composes() -> void:
	print("")
	print("--- 6. Both shipped supports are genuinely at their maximum rank before the Level 5 offer composes")
	_expect(_rank_problems.is_empty() and _rank_lines.size() == 1, "; ".join(_rank_problems))
	print("  %s" % _rank_lines[0])
	_done("both_supports_reach_their_maximum_rank_before_the_fallback_composes")


# --- 7. The fallback offer -------------------------------------------------------------------------

func _check_the_next_offer_is_a_passive_fallback_at_all_three_layers() -> void:
	print("")
	print("--- 7. The Level 5 offer reports PASSIVE_FALLBACK and one fallback category through E2, G4 and H8")
	_expect(_fallback_problems.is_empty(), "; ".join(_fallback_problems))
	var kinds: PackedInt32Array = PackedInt32Array([review.mote_runtime.offer_support_content_kind(),
		_twin.offer_support_content_kind(), _chain.offer_support_content_kind()])
	var categories: PackedInt32Array = PackedInt32Array([review.mote_runtime.offer_support_fallback_category(),
		_twin.offer_support_fallback_category(), _chain.offer_support_fallback_category()])
	_expect(kinds == PackedInt32Array([FALLBACK, FALLBACK, FALLBACK])
			and categories == PackedInt32Array([FALLBACK_CATEGORY, FALLBACK_CATEGORY, FALLBACK_CATEGORY])
			and PassiveCardCatalogue.record(FALLBACK_CARD).category() == FALLBACK_CATEGORY,
		"the layers read kinds %s and categories %s" % [str(kinds), str(categories)])
	print("  %s" % _fallback_line)
	print("  the fallback card_power's canonical category is %d, and all three layers answer it" % FALLBACK_CATEGORY)
	_done("the_next_offer_is_a_passive_fallback_at_all_three_layers")


# --- 8. The panel ---------------------------------------------------------------------------------

func _check_the_panel_shows_the_fallback_honestly_in_the_support_lane() -> void:
	print("")
	print("--- 8. The accepted panel shows three cards in lane order, the fallback as a Support card, and no duplicate")
	var panel: RiftLevelUpOfferPanel = review.level_up_panel
	var lanes: Array[int] = []
	var shown: Array = []
	var captions: Array[String] = []
	for slot: int in panel.card_count():
		lanes.append(panel.lane_for_slot(slot))
		shown.append(Array(panel.card_lines(slot)))
		captions.append(_caption(panel.card_buttons()[slot]))
	_expect(panel.is_open and paused and panel.card_count() == 3 and lanes == RiftOffer.LANE_ORDER and lanes == [0, 1, 2],
		"the panel shows %d cards in lanes %s (open %s, paused %s)" % [panel.card_count(), str(lanes), str(panel.is_open), str(paused)])
	_expect(shown == FALLBACK_CARDS and captions == FALLBACK_CAPTIONS, "the cards read %s with captions %s" % [str(shown), str(captions)])
	var derived: Array = []
	for lane: int in [0, 1, 2]:
		var identity: PackedStringArray = review.mote_runtime.offer_identity_for(lane)
		var record: PassiveCardDefinition = PassiveCardCatalogue.record(StringName(identity[0]))
		var detail: String = record.effect_line()
		if lane == SUPPORT:
			detail = "Supports maxed — %s" % detail
		derived.append([RiftOffer.lane_label(lane), record.display_name, detail])
	_expect(shown == derived, "the cards are not the catalogue's own: %s" % str(derived))
	var ids: PackedStringArray = PackedStringArray([review.mote_runtime.offer_identity_for(0)[0],
		review.mote_runtime.offer_identity_for(1)[0], review.mote_runtime.offer_identity_for(2)[0]])
	_expect(not [ids[1], ids[2]].has(ids[0]) and not [shown[1][1], shown[2][1]].has(shown[0][1])
			and ids[0] == String(FALLBACK_CARD),
		"the fallback slot duplicates an ordinary card: %s" % ", ".join(ids))
	_expect(root.gui_get_focus_owner() == panel.card_buttons()[0] and panel.note_text() == GREYBOX_NOTE
			and _receipt_visible(RECEIPT_STATUS) and _receipt_text(RECEIPT_STATUS) == OFFER_STANDING_TEXT
			and not _hud_visible(HUD_LEVEL_UP) and not _hud_visible(HUD_LEVEL_UP_NOTE),
		"focus, the note, the standing line or H9's withheld lines moved")
	## D-313: behind the open modal only the receipt heading and the standing line show. Level
	## 4's receipt is still held — hidden, not cleared — and H9's level and XP still read.
	_expect(_receipt_lines() == PackedStringArray(STANDING_LINES) and review.receipt_text("choice") == PREPARATION_CHOICES[3]
			and not _receipt_visible(RECEIPT_CHOICE) and not _receipt_visible(RECEIPT_PROGRESSION)
			and not _receipt_visible(RECEIPT_LEVEL) and not _receipt_visible(RECEIPT_NOTE_LINE)
			and _hud_text(HUD_LEVEL) == "Rift level 5" and _hud_text(HUD_EXPERIENCE) == "XP 200 / 200",
		"behind the open fallback modal the receipt section reads %s" % str(_receipt_lines()))
	await _capture("01_passive_fallback_offer")
	var rows: PackedStringArray = PackedStringArray()
	for slot: int in 3:
		rows.append("%s: %s — %s" % [shown[slot][0], shown[slot][1], shown[slot][2]])
	print("  lanes %s = D1's %s; %s" % [str(lanes), str(RiftOffer.LANE_ORDER), "; ".join(rows)])
	print("  captions %s; the Support card is card_power, which neither ordinary lane carries (card_vitality, card_fleetness); focus on card 1; the note, the standing receipt line and H9's withheld lines unchanged"
		% ", ".join(captions))
	print("  behind the modal H9's panel reads 'Rift level 5' / 'XP 200 / 200' and the receipt section only '%s' | '%s'; Level 4's receipt is held but hidden"
		% [RECEIPT_TITLE_TEXT, OFFER_STANDING_TEXT])
	_done("the_panel_shows_the_fallback_honestly_in_the_support_lane")


# --- 9. Nothing raw ----------------------------------------------------------------------------------

func _check_no_raw_id_number_or_fallback_term_is_visible_on_a_card() -> void:
	print("")
	print("--- 9. No stable id, category number, seed, weight, ticket or internal fallback term is visible")
	var forbidden: Array[String] = VISIBLE_FORBIDDEN.duplicate()
	for profile: SkillTagProfile in SkillSupportCatalogue.skill_profiles():
		forbidden.append(String(profile.skill_id))
	for definition: SupportDefinition in SkillSupportCatalogue.support_definitions():
		forbidden.append(String(definition.support_id()))
	for record: PassiveCardDefinition in PassiveCardCatalogue.records():
		forbidden.append(String(record.card_id))
	var support_seed: int = RiftOfferComposition.lane_seed_for(ROOTS[4], SUPPORT)
	var numbers: PackedStringArray = PackedStringArray([str(ROOTS[4]),
		str(support_seed), str(RiftOfferComposition.lane_seed_for(ROOTS[4], 1)), str(RiftOfferComposition.lane_seed_for(ROOTS[4], 2)),
		str(SupportExhaustionPassiveFallback.category_ticket_for(support_seed)),
		str(SupportExhaustionPassiveFallback.card_ticket_for(support_seed))])
	for number: String in numbers:
		forbidden.append(number)
	var visible: PackedStringArray = PackedStringArray()
	for control: Control in review.level_up_panel.text_controls():
		if control.is_visible_in_tree():
			visible.append(_visible_text(control))
	var text: String = "\n".join(visible)
	var found: PackedStringArray = PackedStringArray()
	for token: String in forbidden:
		if text.contains(token):
			found.append(token)
	var card: PackedStringArray = review.level_up_panel.card_lines(0)
	_expect(found.is_empty() and visible.size() == 15 and review.level_up_panel.refusal_text().is_empty(),
		"%d visible panel lines; they show %s" % [visible.size(), ", ".join(found)])
	_expect(card == PackedStringArray(FALLBACK_CARDS[0]) and _caption(review.level_up_panel.card_buttons()[0]) == FALLBACK_CAPTIONS[0],
		"the Support card reads %s" % " / ".join(card))
	print("  %d visible panel lines scanned for %d forbidden fragments — every catalogue id, the root seed, the three lane seeds, both fallback tickets, the weight and the internal terms: 0 found"
		% [visible.size(), forbidden.size()])
	_done("no_raw_id_number_or_fallback_term_is_visible_on_a_card")


# --- 10. Legibility ----------------------------------------------------------------------------------

func _check_the_fallback_panel_is_legible_and_centred() -> void:
	print("")
	print("--- 10. The fallback panel is on screen, readable, its three cards apart, and centred")
	await _await_process_frames(4)
	var viewport: Rect2 = Rect2(Vector2.ZERO, Vector2(root.get_visible_rect().size))
	var panel: RiftLevelUpOfferPanel = review.level_up_panel
	var controls: Array[Control] = panel.text_controls()
	var visible: int = 0
	for control: Control in controls:
		if control.is_visible_in_tree():
			visible += 1
	var shown: int = _measure_text(controls, viewport, "fallback panel")
	_expect(shown == visible and visible == controls.size() - 1, "%d of %d visible panel controls are on screen" % [shown, visible])
	var smallest: int = _smallest_font(controls)
	var overlapping: int = 0
	for a: int in 3:
		for b: int in range(a + 1, 3):
			if panel.card_block(a).get_global_rect().intersects(panel.card_block(b).get_global_rect()):
				overlapping += 1
	var narrowest: float = 99999.0
	for slot: int in 3:
		narrowest = minf(narrowest, panel.card_block(slot).get_global_rect().size.x)
	_expect(smallest >= 12 and overlapping == 0 and narrowest >= RiftLevelUpOfferPanel.CARD_WIDTH - 0.5,
		"smallest %d px; %d card pair(s) overlap; the narrowest card is %.1f px" % [smallest, overlapping, narrowest])
	var content: Rect2 = (panel.get_node("Panel") as Control).get_global_rect()
	var offset: Vector2 = content.get_center() - viewport.get_center()
	_expect(viewport.encloses(content) and panel.get_global_rect().encloses(viewport)
			and absf(offset.x) <= 1.0 and absf(offset.y) <= 1.0,
		"the panel %s sits %s from the centre of %s, or its backdrop does not cover it" % [content, offset, viewport])
	var detail: Label = null
	for control: Control in controls:
		if control is Label and (control as Label).text == FALLBACK_CARDS[0][2]:
			detail = control as Label
	_expect(detail != null and detail.is_visible_in_tree() and panel.card_block(0).get_global_rect().encloses(detail.get_global_rect()),
		"the fallback detail line is not inside its own card")
	print("  %d of %d visible text controls on screen, smallest %d px; 3 cards, 0 overlapping, each at least %.0f px wide; the panel centred within 1 px; the fallback detail line inside its own card"
		% [shown, visible, smallest, RiftLevelUpOfferPanel.CARD_WIDTH])
	print("  panel %s in a %s viewport" % [content, viewport.size])
	_done("the_fallback_panel_is_legible_and_centred")


# --- 11. Refusals --------------------------------------------------------------------------------------

func _check_refused_and_invalid_choices_keep_the_same_panel_open_and_paused() -> void:
	print("")
	print("--- 11. A refused or invalid choice keeps the same panel, the same offer, the pause and the run exactly as they were")
	var shown: PackedStringArray = PackedStringArray()
	for lane: int in [7, -1]:
		var before: String = "%s | %s | %s" % [_h8_line(), ", ".join(_cards_text()), _state()]
		var held: int = review.mote_runtime.run_build().passive_acquisitions()
		var taken: int = review.choices_taken
		review.choose_offered_lane(lane)
		var record: RiftRunLevelUpResult = review.last_choice_record
		var after: String = "%s | %s | %s" % [_h8_line(), ", ".join(_cards_text()), _state()]
		var reason: String = "" if record == null else record.failure_reason()
		_expect(record != null and not record.succeeded() and record.problem().is_empty()
				and reason.begins_with("lane %d is not one of the offer's lanes" % lane)
				and review.level_up_panel.refusal_text() == REFUSAL_PREFIX + reason
				and before == after and review.level_up_panel.is_open and paused and review.choices_taken == taken
				and review.mote_runtime.level() == 5 and review.mote_runtime.experience() == REQUIREMENTS[4]
				and review.mote_runtime.run_build().passive_acquisitions() == held
				and _receipt_lines() == PackedStringArray(STANDING_LINES),
			"lane %d: '%s'; before %s; after %s; the receipt section reads %s" % [lane, reason, before, after, str(_receipt_lines())])
		_note_hidden("A after the refused lane %d" % lane)
		shown.append("lane %d: '%s'" % [lane, reason])
	print("  %s; each shown word for word; the same offer (%s) still open, paused, level 5, 200.0, nothing acquired, the previous receipt still hidden" % ["; ".join(shown), _h8_line()])
	_done("refused_and_invalid_choices_keep_the_same_panel_open_and_paused")


# --- 12. No aliasing --------------------------------------------------------------------------------------

func _check_offer_readings_do_not_alias_stored_state() -> void:
	print("")
	print("--- 12. Every offer reading is a copy or a scalar: rewriting what a reading returned moves nothing it came from")
	var before: PackedStringArray = PackedStringArray([_h8_line(), _g4_line(), _e2_line()])
	for lanes: Array[int] in [review.mote_runtime.offer_lanes(), _twin.offer_lanes(), _chain.offer_lanes()]:
		lanes.append(7)
		lanes[0] = 2
	for identity: PackedStringArray in [review.mote_runtime.offer_identity_for(0), _twin.offer_identity_for(0), _chain.offer_identity_for(0)]:
		identity.append("invented_card")
		identity[0] = "card_insight"
	var copy: RiftRunBuild = review.mote_runtime.run_build()
	var refused: String = copy.acquire_passive_card(PassiveCardCatalogue.record(&"card_insight"))
	var after: PackedStringArray = PackedStringArray([_h8_line(), _g4_line(), _e2_line()])
	_expect(before == after and refused.is_empty() and copy.acquisitions_for(&"card_insight") == 1
			and review.mote_runtime.run_build().acquisitions_for(&"card_insight") == 0,
		"a rewritten reading moved the offer: %s against %s" % [" / ".join(after), " / ".join(before)])
	print("  lane readings rewritten to [2, 1, 2, 7], identity readings to [card_insight, invented_card] and a copied build given card_insight — all three layers still read %s; the kind and the category are ints" % after[0])
	_done("offer_readings_do_not_alias_stored_state")


# --- 13, 17, 18. Taking the fallback ------------------------------------------------------------------------

func _check_the_fallback_chosen_by_keyboard_closes_resumes_and_is_received() -> void:
	print("")
	print("--- 13. Enter takes the fallback through the accepted choice path: the panel closes, play resumes, one level, one seed, the I9 receipt")
	## First-MVP UI J1 (D-322): the panel no longer counts left presses, so what is read is the
	## keyboard path itself — Enter acts once, on the focused Support card.
	var focused: bool = root.gui_get_focus_owner() == review.level_up_panel.card_buttons()[0]
	var attempts: int = review.choice_attempts
	_take_the_fallback("A", "Enter")
	_expect((_choice_problems["A"] as PackedStringArray).is_empty(), "; ".join(_choice_problems["A"]))
	_expect(focused and review.choice_attempts == attempts + 1, "Enter did not act once on the focused Support card")
	print("  %s" % _choice_lines["A"])
	_done("the_fallback_chosen_by_keyboard_closes_resumes_and_is_received")


## Expedition B's own preparation evidence, gathered by the same code as A's, is asserted
## here with its choice — no expedition's preparation goes unread.
func _check_the_fallback_chosen_by_controller_takes_the_same_transaction() -> void:
	print("")
	print("--- 17. The controller's (A) on the focused Support card takes the same transaction")
	var focused: bool = root.gui_get_focus_owner() == review.level_up_panel.card_buttons()[0]
	_take_the_fallback("B", "(A)")
	_expect((_choice_problems["B"] as PackedStringArray).is_empty() and _preparation_problems.is_empty()
			and _preparation_levels == 8 and _rank_problems.is_empty() and _rank_lines.size() == 2
			and _fallback_problems.is_empty() and _build_problems.is_empty(),
		"; ".join(_choice_problems["B"] + _preparation_problems + _rank_problems + _fallback_problems + _build_problems))
	_expect(focused and _choice_lines["B"] == (_choice_lines["A"] as String).replace("A by Enter", "B by (A)")
			and _build_lines["B"] == _build_lines["A"],
		"(A) did not reach the focused Support card, or its outcome differs: %s" % _choice_lines["B"])
	print("  %s" % _choice_lines["B"])
	await _settle(2)
	_done("the_fallback_chosen_by_controller_takes_the_same_transaction")


## Expedition C's own preparation evidence is asserted here with its choice.
func _check_the_fallback_chosen_by_mouse_takes_the_same_transaction() -> void:
	print("")
	print("--- 18. A left click on the Support card's own button takes the same transaction")
	## First-MVP UI J1 (D-322): the panel no longer counts left presses; the click on card 1's own
	## button is read by what it took — exactly one attempt, and the same Support record as A's.
	var attempts: int = review.choice_attempts
	_take_the_fallback("C", "left click")
	_expect((_choice_problems["C"] as PackedStringArray).is_empty() and _preparation_problems.is_empty()
			and _preparation_levels == 12 and _rank_problems.is_empty() and _rank_lines.size() == 3
			and _fallback_problems.is_empty() and _build_problems.is_empty(),
		"; ".join(_choice_problems["C"] + _preparation_problems + _rank_problems + _fallback_problems + _build_problems))
	_expect(review.choice_attempts == attempts + 1
			and _choice_lines["C"] == (_choice_lines["A"] as String).replace("A by Enter", "C by left click")
			and _build_lines["C"] == _build_lines["A"],
		"the click took %d choice attempt(s), or its outcome differs: %s" % [review.choice_attempts - attempts, _choice_lines["C"]])
	print("  %s" % _choice_lines["C"])
	await _settle(2)
	_done("the_fallback_chosen_by_mouse_takes_the_same_transaction")


## Everything one fallback choice owes, read in the same call stack as the input that made
## it: the accepted record, the I9 receipt, the panel closed and play resumed by that very
## input, one level, the seed spent once, the card held once more, no support moved, the
## review's receipt, and the live character unchanged.
func _take_the_fallback(label: String, how: String) -> void:
	var problems: PackedStringArray = PackedStringArray()
	var attempts: int = review.choice_attempts
	var taken_before: int = review.choices_taken
	var calls: int = review.offer_open_calls
	var build_before: RiftRunBuild = review.mote_runtime.run_build()
	var at: Vector2 = review.level_up_panel.card_buttons()[0].get_global_rect().get_center()
	var before_lines: PackedStringArray = _receipt_lines()
	match how:
		"Enter":
			_push_key(KEY_ENTER, true)
			_push_key(KEY_ENTER, false)
		"(A)":
			_push_joy(JOY_BUTTON_A, true)
			_push_joy(JOY_BUTTON_A, false)
		"left click":
			var motion: InputEventMouseMotion = InputEventMouseMotion.new()
			motion.position = at
			motion.global_position = at
			root.push_input(motion, true)
			_push_mouse(at, MOUSE_BUTTON_LEFT, true)
			_push_mouse(at, MOUSE_BUTTON_LEFT, false)
	var taken: Dictionary = _taken_reading()
	var after_lines: PackedStringArray = _receipt_lines()
	var twin_record: RiftRunLevelUpResult = _twin.choose(SUPPORT)
	var chain_receipt: RiftLevelUpResult = _chain.choose(SUPPORT)
	var record: RiftRunLevelUpResult = review.last_choice_record
	var receipt: RiftLevelUpResult = null if record == null else record.level_up()
	if record == null or receipt == null or not record.succeeded() or not record.problem().is_empty() \
			or record.run_seed != ROUTE_SEED or record.source_level != 5:
		problems.append("the record is %s" % _record(record))
	elif not receipt.ok or not receipt.problem().is_empty() or receipt.lane != SUPPORT or not receipt.root_seed_known \
			or receipt.root_seed != ROOTS[4] or receipt.granted_identity() != PackedStringArray([String(FALLBACK_CARD)]) \
			or receipt.support_content_kind != FALLBACK or receipt.support_fallback_category != FALLBACK_CATEGORY \
			or not receipt.carries_support_fallback() or receipt.carries_support_progression() \
			or receipt.support_progression_kind != RiftOffer.UNRESOLVED_PROGRESSION_KIND \
			or receipt.support_rank_before != NO_RANK or receipt.support_rank_after != NO_RANK \
			or receipt.support_progression_line() != "no support progression" \
			or receipt.support_fallback_line() != FALLBACK_DIAGNOSTIC:
		problems.append("the I9 receipt is %s (%s)" % [_record(record), receipt.problem()])
	if _record(record) != _record(twin_record) or chain_receipt == null or not chain_receipt.problem().is_empty() \
			or receipt == null or chain_receipt.describe() != receipt.describe() \
			or chain_receipt.support_fallback_category != FALLBACK_CATEGORY:
		problems.append("the review took %s where G4 took %s and E2 %s" % [_record(record), _record(twin_record),
			"nothing" if chain_receipt == null else chain_receipt.describe()])
	if bool(taken["open"]) or bool(taken["paused"]) or bool(taken["active"]) or int(taken["level"]) != 6 \
			or float(taken["experience"]) != 0.0 or review.choice_attempts != attempts + 1 \
			or review.choices_taken != taken_before + 1 or review.offer_open_calls != calls \
			or String(taken["hud_level"]) != "Rift level 6" or String(taken["hud_experience"]) != "XP 0 / 225":
		problems.append("the input left %s" % str(taken))
	if review.receipt_text("choice") != FALLBACK_CHOICE or review.receipt_text("progression") != FALLBACK_SECONDARY \
			or review.receipt_text("level") != FALLBACK_LEVEL_LINE:
		problems.append("the review's receipt reads '%s' / '%s' / '%s'" % [review.receipt_text("choice"),
			review.receipt_text("progression"), review.receipt_text("level")])
	## D-313: the card's own name and canonical effect, read from the catalogue here too.
	var power: PassiveCardDefinition = PassiveCardCatalogue.record(FALLBACK_CARD)
	if review.receipt_text("choice") != "%s — %s (%s)" % [RiftOffer.lane_label(SUPPORT), power.display_name, power.effect_line()]:
		problems.append("the receipt's choice line '%s' is not the catalogue's own name and effect" % review.receipt_text("choice"))
	_note_appearance(label, before_lines, after_lines,
		PackedStringArray([RECEIPT_TITLE_TEXT, FALLBACK_CHOICE, FALLBACK_SECONDARY, FALLBACK_LEVEL_LINE, RECEIPT_NOTE]))
	var build_after: RiftRunBuild = review.mote_runtime.run_build()
	var build_line: String = "card_power %d -> %d, passive cards %d -> %d, pairs [%s] -> [%s], ranks %d / %d -> %d / %d, total %d -> %d" % [
		build_before.acquisitions_for(FALLBACK_CARD), build_after.acquisitions_for(FALLBACK_CARD),
		build_before.passive_acquisitions(), build_after.passive_acquisitions(),
		", ".join(build_before.support_pairs()), ", ".join(build_after.support_pairs()),
		build_before.support_rank_for(QUICK_STRIKE, REACHING_EDGE), build_before.support_rank_for(QUICK_STRIKE, SWEEPING_EDGE),
		build_after.support_rank_for(QUICK_STRIKE, REACHING_EDGE), build_after.support_rank_for(QUICK_STRIKE, SWEEPING_EDGE),
		build_before.total_support_ranks(), build_after.total_support_ranks()]
	if build_before.acquisitions_for(FALLBACK_CARD) != 0 or build_after.acquisitions_for(FALLBACK_CARD) != 1 \
			or build_after.passive_acquisitions() != build_before.passive_acquisitions() + 1 \
			or build_after.support_pairs() != build_before.support_pairs() or build_after.support_pairs() != PackedStringArray(HELD_PAIRS) \
			or build_after.total_support_ranks() != build_before.total_support_ranks() \
			or build_after.support_rank_for(QUICK_STRIKE, REACHING_EDGE) != MAXIMUM_RANK \
			or build_after.support_rank_for(QUICK_STRIKE, SWEEPING_EDGE) != MAXIMUM_RANK \
			or _twin.run_build().acquisitions_for(FALLBACK_CARD) != 1:
		_build_problems.append("%s: %s" % [label, build_line])
	var again: RiftRunLevelUpResult = review.mote_runtime.choose_level_up_lane(SUPPORT)
	var consumed: PackedInt64Array = _twin.consumption_ledger().consumed_seeds()
	if again.succeeded() or again.failure_reason() != NO_OFFER or review.mote_runtime.level() != 6 \
			or consumed != PackedInt64Array([99, 1000102, 2000105, 3000108, 4000111]):
		problems.append("the seed was not spent once: '%s', the twin consumed %s" % [again.failure_reason(), str(consumed)])
	_note_live("%s after the fallback" % label)
	_note_sentinels("%s after the fallback" % label)
	_choice_problems[label] = problems
	_build_lines[label] = build_line
	_choice_lines[label] = "%s by %s: granted [%s] from root seed %d — %s, category %d, no support progression; level 5 -> 6 with 0.0 retained; the same record as G4's and the E2 chain's; taken again: '%s'; receipt '%s' / '%s' / '%s'; %s" % [
		label, how, "" if receipt == null else ", ".join(receipt.granted_identity()), 0 if receipt == null else receipt.root_seed,
		"none" if receipt == null else ("PASSIVE_FALLBACK" if receipt.support_content_kind == FALLBACK else str(receipt.support_content_kind)),
		NO_CATEGORY if receipt == null else receipt.support_fallback_category, again.failure_reason(),
		review.receipt_text("choice"), review.receipt_text("progression"), review.receipt_text("level"), build_line]


# --- 14. The receipt on screen ---------------------------------------------------------------------------------

func _check_the_fallback_receipt_is_legible_and_shows_no_progression() -> void:
	print("")
	print("--- 14. The fallback receipt reads in the review panel, shows no progression or rank, and play has resumed")
	await _capture("02_passive_fallback_receipt", 1.2)
	await _await_process_frames(4)
	var viewport: Rect2 = Rect2(Vector2.ZERO, Vector2(root.get_visible_rect().size))
	var controls: Array[Control] = review.receipt_controls()
	var shown: int = _measure_text(controls, viewport, "receipt")
	var host: Rect2 = review.experience_hud.panel.get_global_rect()
	var outside_host: int = 0
	for control: Control in controls:
		if control.is_visible_in_tree() and not host.encloses(control.get_global_rect()):
			outside_host += 1
	var centre: Rect2 = Rect2(viewport.size * 0.25, viewport.size * 0.5)
	_expect(shown == 5 and not _receipt_visible(RECEIPT_STATUS) and outside_host == 0 and viewport.encloses(host)
			and not host.intersects(centre) and _smallest_font(controls) >= 12,
		"%d receipt lines on screen, %d outside the review panel %s" % [shown, outside_host, host])
	var lines: PackedStringArray = _receipt_lines()
	_expect(lines == PackedStringArray([RECEIPT_TITLE_TEXT, FALLBACK_CHOICE, FALLBACK_SECONDARY, FALLBACK_LEVEL_LINE, RECEIPT_NOTE]),
		"the receipt reads %s" % str(lines))
	## D-313: the choice line is the card's own name and canonical effect, and the category
	## keeps its own separate line.
	var power: PassiveCardDefinition = PassiveCardCatalogue.record(FALLBACK_CARD)
	_expect(lines.size() == 5
			and lines[1] == "%s — %s (%s)" % [RiftOffer.lane_label(SUPPORT), power.display_name, power.effect_line()]
			and lines[2] == "Passive fallback from %s" % RiftOffer.lane_label(COMBAT) and lines[1] != lines[2],
		"the fallback receipt is not the card's own name and effect over its own category line: %s" % str(lines))
	var joined: String = "\n".join(lines)
	_expect(not joined.contains("rank") and not joined.contains("pair") and not joined.contains("->")
			and not joined.contains("card_") and not joined.contains("category")
			and not paused and not review.level_up_panel.is_open
			and _hud_text(HUD_LEVEL) == "Rift level 6" and _hud_text(HUD_EXPERIENCE) == "XP 0 / 225",
		"the receipt shows a progression or an id, or play has not resumed: %s" % joined)
	print("  %s; smallest %d px; inside the review panel, clear of the centre; not paused; 'Rift level 6' / 'XP 0 / 225'"
		% [" | ".join(lines), _smallest_font(controls)])
	print("  review panel %s in a %s viewport" % [host, viewport.size])
	_done("the_fallback_receipt_is_legible_and_shows_no_progression")


# --- 15. The build ---------------------------------------------------------------------------------------------

func _check_the_fallback_card_is_held_once_more_and_no_support_moves() -> void:
	print("")
	print("--- 15. The fallback card is held exactly once more; every support pair and rank is where it was")
	_expect(_build_problems.is_empty() and _build_lines.has("A"), "; ".join(_build_problems))
	print("  %s" % _build_lines["A"])
	_done("the_fallback_card_is_held_once_more_and_no_support_moves")


# --- 16. Nothing opens next -------------------------------------------------------------------------------------

func _check_the_next_offer_opens_on_its_own_after_the_fallback_choice() -> void:
	print("")
	print("--- 16. After the fallback choice, Level 6's requirement met opens Level 6's own offer on its own, once (Roguelite I11, D-314)")
	## Moved one for one under D-314: I11 makes every level's offer open on its own, so the
	## accepted "nothing opens at Level 6" became "Level 6's own offer opens, once".
	var calls: int = review.offer_open_calls
	var awarded: bool = _award(NEXT_REQUIREMENT)
	await _settle(30)
	await _await_process_frames(6)
	var g1: RiftLevelRequirementReading = RiftLevelRequirementCurve.requirement_for(6)
	var g2: RiftLevelOfferSeedReading = RiftLevelOfferSeedDerivation.offer_root_seed_for(ROUTE_SEED, 6)
	var opened: bool = (awarded and g1.ok and g1.experience_requirement() == NEXT_REQUIREMENT
		and review.mote_runtime.level() == 6 and review.mote_runtime.experience() == NEXT_REQUIREMENT
		and review.offer_open_calls == calls + 1 and review.mote_runtime.is_offer_active()
		and review.mote_runtime.offer_root_seed() == g2.offer_root_seed
		and review.level_up_panel.is_open and paused and review.offer_attempted())
	var root_seed: int = review.mote_runtime.offer_root_seed()
	## Its first card is taken with Enter so the expedition can end: F5 cannot pass a standing panel.
	_push_key(KEY_ENTER, true)
	_push_key(KEY_ENTER, false)
	_note_sentinels("A after the Level 6 choice")
	_expect(opened and review.mote_runtime.level() == 7 and not review.level_up_panel.is_open and not paused
			and review.offer_open_calls == calls + 1,
		"after the Level 6 award: opened %s; %s" % [str(opened), _state()])
	print("  225.0 awarded at Level 6 (G1's requirement): the review asked its own Level 6 opening on its next tick — root %d, G2's own — and nothing more; Enter took its first card to Level 7" % root_seed)
	_done("the_next_offer_opens_on_its_own_after_the_fallback_choice")


# --- 21, 22. The receipt while an offer stands, and the ordinary passive lanes (D-313) ------------------------

func _check_the_previous_receipt_is_hidden_while_any_offer_stands() -> void:
	print("")
	print("--- 21. While any offer stands the previous receipt is hidden; only a successful choice brings the new one up")
	_expect(_hidden_problems.is_empty() and _hidden_readings == 27,
		"%d standing readings; %s" % [_hidden_readings, "; ".join(_hidden_problems)])
	_expect(_appearance_problems.is_empty() and _appearances == 5,
		"%d choices read; %s" % [_appearances, "; ".join(_appearance_problems)])
	print("  %d readings with an offer standing — Levels 1–5 in 5 expeditions and after both refused lanes — each showing only '%s' | '%s', with H9's level and XP"
		% [_hidden_readings, RECEIPT_TITLE_TEXT, OFFER_STANDING_TEXT])
	print("  %d Level 5 choices (3 fallbacks, 2 ordinary passive lanes): the receipt hidden up to the press, and the new receipt shown by the same input that closed the panel"
		% _appearances)
	_done("the_previous_receipt_is_hidden_while_any_offer_stands")


func _check_ordinary_passive_receipts_on_the_fallback_offer_are_unchanged() -> void:
	print("")
	print("--- 22. An ordinary passive lane of the same fallback offer gives I2's ordinary passive receipt, word for word")
	_expect((_choice_problems["D"] as PackedStringArray).is_empty() and (_choice_problems["E"] as PackedStringArray).is_empty(),
		"; ".join(_choice_problems["D"] + _choice_problems["E"]))
	_expect(_preparation_problems.is_empty() and _preparation_levels == 20 and _rank_problems.is_empty()
			and _rank_lines.size() == 5 and _fallback_problems.is_empty() and _build_problems.is_empty(),
		"; ".join(_preparation_problems + _rank_problems + _fallback_problems + _build_problems))
	_expect(_passive_receipt_lines["D"] == PackedStringArray([RECEIPT_TITLE_TEXT, PASSIVE_RECEIPTS[COMBAT], FALLBACK_LEVEL_LINE, RECEIPT_NOTE])
			and _passive_receipt_lines["E"] == PackedStringArray([RECEIPT_TITLE_TEXT, PASSIVE_RECEIPTS[UTILITY], FALLBACK_LEVEL_LINE, RECEIPT_NOTE]),
		"the passive receipts read %s and %s" % [str(_passive_receipt_lines["D"]), str(_passive_receipt_lines["E"])])
	print("  %s" % _choice_lines["D"])
	print("  %s" % _choice_lines["E"])
	_done("ordinary_passive_receipts_on_the_fallback_offer_are_unchanged")


## An ORDINARY passive lane of the standing fallback offer, taken through the same panel —
## Combat and Defence with Right then Enter, Utility with a left click on its own button —
## and everything that choice owes, read in the input's own call stack (D-313).
func _take_a_passive_lane(label: String, lane: int) -> void:
	var problems: PackedStringArray = PackedStringArray()
	var panel: RiftLevelUpOfferPanel = review.level_up_panel
	var card: StringName = StringName(FALLBACK_IDENTITIES[lane][0])
	var before_lines: PackedStringArray = _receipt_lines()
	var build_before: RiftRunBuild = review.mote_runtime.run_build()
	var attempts: int = review.choice_attempts
	var how: String = "Right + Enter"
	if lane == COMBAT:
		_push_key(KEY_RIGHT, true)
		_push_key(KEY_RIGHT, false)
		await _await_process_frames(1)
		if root.gui_get_focus_owner() != panel.card_buttons()[1]:
			problems.append("Right did not move the focus to card 2")
		_push_key(KEY_ENTER, true)
		_push_key(KEY_ENTER, false)
	else:
		how = "left click"
		var at: Vector2 = panel.card_buttons()[2].get_global_rect().get_center()
		var motion: InputEventMouseMotion = InputEventMouseMotion.new()
		motion.position = at
		motion.global_position = at
		root.push_input(motion, true)
		_push_mouse(at, MOUSE_BUTTON_LEFT, true)
		_push_mouse(at, MOUSE_BUTTON_LEFT, false)
	var taken: Dictionary = _taken_reading()
	var after_lines: PackedStringArray = _receipt_lines()
	var twin_record: RiftRunLevelUpResult = _twin.choose(lane)
	var chain_receipt: RiftLevelUpResult = _chain.choose(lane)
	var record: RiftRunLevelUpResult = review.last_choice_record
	var receipt: RiftLevelUpResult = null if record == null else record.level_up()
	if record == null or receipt == null or not record.succeeded() or not record.problem().is_empty() \
			or record.run_seed != ROUTE_SEED or record.source_level != 5 or receipt.lane != lane \
			or receipt.root_seed != ROOTS[4] or receipt.granted_identity() != PackedStringArray([String(card)]) \
			or receipt.support_content_kind != NO_CONTENT or receipt.support_fallback_category != NO_CATEGORY \
			or receipt.carries_support_fallback() or receipt.carries_support_progression():
		problems.append("the record is %s" % _record(record))
	if _record(record) != _record(twin_record) or chain_receipt == null or receipt == null \
			or chain_receipt.describe() != receipt.describe():
		problems.append("the review took %s where G4 took %s" % [_record(record), _record(twin_record)])
	if bool(taken["open"]) or bool(taken["paused"]) or bool(taken["active"]) or int(taken["level"]) != 6 \
			or float(taken["experience"]) != 0.0 or review.choice_attempts != attempts + 1 \
			or String(taken["hud_level"]) != "Rift level 6" or String(taken["hud_experience"]) != "XP 0 / 225":
		problems.append("the input left %s" % str(taken))
	var definition: PassiveCardDefinition = PassiveCardCatalogue.record(card)
	var derived: String = "%s — %s (%s)" % [RiftOffer.lane_label(lane), definition.display_name, definition.effect_line()]
	if review.receipt_text("choice") != PASSIVE_RECEIPTS[lane] or review.receipt_text("choice") != derived \
			or not review.receipt_text("progression").is_empty() or review.receipt_text("level") != FALLBACK_LEVEL_LINE:
		problems.append("the receipt reads '%s' / '%s' / '%s'" % [review.receipt_text("choice"),
			review.receipt_text("progression"), review.receipt_text("level")])
	var build_after: RiftRunBuild = review.mote_runtime.run_build()
	if build_before.acquisitions_for(card) != 0 or build_after.acquisitions_for(card) != 1 \
			or build_after.acquisitions_for(FALLBACK_CARD) != 0 \
			or build_after.support_pairs() != PackedStringArray(HELD_PAIRS) \
			or build_after.total_support_ranks() != build_before.total_support_ranks():
		_build_problems.append("%s: %s held %d -> %d, card_power %d, pairs [%s]" % [label, card,
			build_before.acquisitions_for(card), build_after.acquisitions_for(card),
			build_after.acquisitions_for(FALLBACK_CARD), ", ".join(build_after.support_pairs())])
	var again: RiftRunLevelUpResult = review.mote_runtime.choose_level_up_lane(lane)
	var consumed: PackedInt64Array = _twin.consumption_ledger().consumed_seeds()
	if again.succeeded() or again.failure_reason() != NO_OFFER \
			or consumed != PackedInt64Array([99, 1000102, 2000105, 3000108, 4000111]):
		problems.append("the seed was not spent once: '%s', the twin consumed %s" % [again.failure_reason(), str(consumed)])
	_note_appearance(label, before_lines, after_lines,
		PackedStringArray([RECEIPT_TITLE_TEXT, PASSIVE_RECEIPTS[lane], FALLBACK_LEVEL_LINE, RECEIPT_NOTE]))
	_note_live("%s after its passive lane" % label)
	_note_sentinels("%s after its passive lane" % label)
	_choice_problems[label] = problems
	_passive_receipt_lines[label] = after_lines
	_choice_lines[label] = "%s by %s: granted [%s] from root seed %d — no Support content, no category, no support progression; level 5 -> 6 with 0.0 retained; the same record as G4's and the E2 chain's; receipt '%s' / '%s'; %s %d -> %d, card_power not acquired, pairs and ranks unchanged" % [
		label, how, "" if receipt == null else ", ".join(receipt.granted_identity()), 0 if receipt == null else receipt.root_seed,
		review.receipt_text("choice"), review.receipt_text("level"), card,
		build_before.acquisitions_for(card), build_after.acquisitions_for(card)]
	await _settle(2)


## D-313: while an offer stands the receipt section shows its heading and the standing line
## and nothing of the previous choice, and H9's level and XP still read.
func _note_hidden(moment: String) -> void:
	_hidden_readings += 1
	var lines: PackedStringArray = _receipt_lines()
	if lines != PackedStringArray(STANDING_LINES) or not review.level_up_panel.is_open \
			or not _hud_visible(HUD_LEVEL) or not _hud_visible(HUD_EXPERIENCE):
		_hidden_problems.append("%s: %s" % [moment, " | ".join(lines)])


## D-313: the receipt was hidden up to the press, and the input that closed the panel brought
## exactly the new receipt up.
func _note_appearance(label: String, before: PackedStringArray, after: PackedStringArray, expected: PackedStringArray) -> void:
	_appearances += 1
	if before != PackedStringArray(STANDING_LINES) or after != expected:
		_appearance_problems.append("%s: before %s; after %s" % [label, " | ".join(before), " | ".join(after)])


# --- 19. The live character ---------------------------------------------------------------------------------

func _check_the_live_character_is_unchanged() -> void:
	print("")
	print("--- 19. No live character value moved: this review presents and records, and applies nothing")
	_expect(_live_problems.is_empty() and _live_readings == 25
			and is_equal_approx(float(_baseline["max_speed"]), ACCEPTED_MAX_SPEED)
			and is_equal_approx(float(_baseline["action_time"]), ACCEPTED_ACTION_TIME)
			and is_equal_approx(float(_baseline["reach"]), ACCEPTED_REACH)
			and is_equal_approx(float(_baseline["arc"]), ACCEPTED_ARC)
			and is_equal_approx(float(_baseline["cone"]), ACCEPTED_CONE),
		"%d readings; baseline %s; %s" % [_live_readings, str(_baseline), "; ".join(_live_problems)])
	print("  max speed %.1f m/s, action time %.2f s (effective %.2f s), reach %.2f m, arc %.0f deg, cone %.0f deg, +%.0f%% attack speed — identical after all %d choices"
		% [float(_baseline["max_speed"]), float(_baseline["action_time"]), float(_baseline["effective_action_time"]),
			float(_baseline["reach"]), float(_baseline["arc"]), float(_baseline["cone"]),
			100.0 * float(_baseline["increased_attack_speed"]), _live_readings])
	_done("the_live_character_is_unchanged")


# --- 20. Teardown ----------------------------------------------------------------------------------------------

func _check_every_expedition_ends_clean() -> void:
	print("")
	print("--- 20. Every expedition ended with no runtime, record, receipt or panel left")
	_expect(_teardowns == PackedStringArray(["A", "B", "C", "D", "E"]) and _quiet_problems.is_empty(),
		"%s ended; %s" % [", ".join(_teardowns), "; ".join(_quiet_problems)])
	print("  5 of 5 expeditions (%s) ended by F5 with no runtime, attempt, record or receipt left, the panel closed and the world running" % ", ".join(_teardowns))
	_done("every_expedition_ends_clean")


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


# --- Expeditions -------------------------------------------------------------------------------------------

## STAGED for every expedition after the first: the Nexus's next plan is replaced by a fresh
## plan of the route's seed, so each expedition is an equivalent fresh one (D-294 ruling 4).
func _begin_expedition(label: String) -> void:
	if review.plan.seed_value != ROUTE_SEED:
		review.plan = RogueliteRunPlan.new(ROUTE_SEED, review.plan.run_index)
		_staged_plans += 1
	await _walk_into_gate(review.hub_module.exit_point())
	_expeditions += 1
	_expect_quiet(review.loop_state == RogueliteCoreLoopRuntime.LoopState.IN_RUN and review.run_state.current_room_index == 0
			and review.mote_runtime != null and review.mote_runtime.run_seed() == ROUTE_SEED
			and review.mote_runtime.level() == 1 and review.mote_runtime.experience() == 0.0
			and not review.offer_attempted() and not review.level_up_panel.is_open and review.automatic_pickup,
		"expedition %s did not begin fresh at seed %d: %s" % [label, ROUTE_SEED, _state()])
	## STAGED: the Teaching Hall's Graveblade stands still, so play between choices cannot reach the player.
	for enemy: PrototypeGraveblade in review.room_enemies[0]:
		enemy.set_ai_enabled(false)


func _end_expedition(label: String) -> void:
	await _key(KEY_F5)
	await _settle(4)
	if not (review.loop_state == RogueliteCoreLoopRuntime.LoopState.HUB and review.mote_runtime == null \
			and not review.offer_attempted() and review.last_choice_record == null and review.last_offer_refusal.is_empty() \
			and _receipt_visible_count() == 0 and not review.level_up_panel.is_open and not paused \
			and _hud_text(HUD_LEVEL) == "No expedition in progress"):
		_quiet_problems.append("expedition %s's end left offer state behind: %s" % [label, _state()])
	for fixture: Node in _stage.get_children():
		fixture.queue_free()
	await _await_process_frames(2)
	_teardowns.append(label)


## STAGED: `amount` awarded explicitly — one production Graveblade in the Nexus, registered
## with the expedition's own H8 runtime for exactly `amount`, killed through its own
## `receive_damage()`, and its mote collected by one explicit H8 sweep where it fell. H9's
## panel is then asked to refresh, because the sweep did not pass through H9's presentation.
func _award(amount: float) -> bool:
	_fixtures += 1
	var enemy: PrototypeGraveblade = (load(GRAVEBLADE_SCENE) as PackedScene).instantiate() as PrototypeGraveblade
	enemy.name = "I10Fixture%d" % _fixtures
	enemy.position = review.hub_module.room_centres()[0] + Vector3(1.5 * float(_fixtures % 6) - 4.0, 0.0, 2.0)
	_stage.add_child(enemy)
	enemy.set_ai_enabled(false)
	var before: float = review.mote_runtime.experience()
	var drops: int = review.mote_runtime.drop_count()
	var registered: String = review.mote_runtime.register_graveblade(enemy, amount)
	enemy.receive_damage(DamageEvent.physical(_use(), review.player, enemy, enemy.life + 1000.0))
	_deaths_driven += 1
	var fell: Vector3 = enemy.global_position
	var answer: RiftMoteSweepResult = review.mote_runtime.sweep_at(fell)
	review.experience_hud.refresh()
	return (registered.is_empty() and not enemy.is_alive() and review.mote_runtime.emission_answer(enemy).is_empty()
		and answer.ok and answer.collected_indices() == PackedInt32Array([drops])
		and review.mote_runtime.experience() == before + amount)


# --- Readings --------------------------------------------------------------------------------------------------

func _note_sentinels(moment: String) -> void:
	_sentinel_readings += 1
	var answers: Array[int] = [
		review.mote_runtime.offer_support_content_kind(), review.mote_runtime.offer_support_fallback_category(),
		_twin.offer_support_content_kind(), _twin.offer_support_fallback_category(),
		_chain.offer_support_content_kind(), _chain.offer_support_fallback_category(),
	]
	if answers != [NO_CONTENT, NO_CATEGORY, NO_CONTENT, NO_CATEGORY, NO_CONTENT, NO_CATEGORY] \
			or review.mote_runtime.is_offer_active() or _twin.is_offer_active() or _chain.is_offer_active():
		_sentinel_problems.append("%s: %s" % [moment, str(answers)])


func _note_live(moment: String) -> void:
	_live_readings += 1
	var live: Dictionary = _live_values()
	if live != _baseline:
		_live_problems.append("%s: %s" % [moment, str(live)])


func _line(root_seed: int, lanes: Array, identities: Array, kind: int, category: int) -> String:
	var parts: PackedStringArray = PackedStringArray()
	for identity: Variant in identities:
		parts.append("[%s]" % ", ".join(PackedStringArray(identity)))
	return "root %d lanes %s %s kind %d category %d" % [root_seed, str(lanes), " ".join(parts), kind, category]


func _h8_line() -> String:
	var r: RiftMoteRuntime = review.mote_runtime
	return _line(r.offer_root_seed(), r.offer_lanes(), [r.offer_identity_for(0), r.offer_identity_for(1), r.offer_identity_for(2)],
		r.offer_support_content_kind(), r.offer_support_fallback_category())


func _g4_line() -> String:
	return _line(_twin.offer_root_seed(), _twin.offer_lanes(),
		[_twin.offer_identity_for(0), _twin.offer_identity_for(1), _twin.offer_identity_for(2)],
		_twin.offer_support_content_kind(), _twin.offer_support_fallback_category())


func _e2_line() -> String:
	return _line(_chain.offer_root_seed(), _chain.offer_lanes(),
		[_chain.offer_identity_for(0), _chain.offer_identity_for(1), _chain.offer_identity_for(2)],
		_chain.offer_support_content_kind(), _chain.offer_support_fallback_category())


## Read in the same call stack as the activating input, before any frame passes.
func _taken_reading() -> Dictionary:
	return {
		"open": review.level_up_panel.is_open, "paused": paused,
		"active": review.mote_runtime.is_offer_active(), "level": review.mote_runtime.level(),
		"experience": review.mote_runtime.experience(),
		"hud_level": _hud_text(HUD_LEVEL), "hud_experience": _hud_text(HUD_EXPERIENCE),
	}


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
		"life": review.player.life,
	}


## Every field of a run-level record and the copy of the receipt it carries, as one line —
## the shape the I1 and I2 suites compare records in, with I9's two Support-content scalars.
func _record(record: RiftRunLevelUpResult) -> String:
	if record == null:
		return "no record"
	var receipt: RiftLevelUpResult = record.level_up()
	if receipt == null:
		return "run_seed=%d source=%d no receipt" % [record.run_seed, record.source_level]
	return "run_seed=%d source=%d succeeded=%s reason='%s' | ok=%s known=%s root=%d lane=%d identity=[%s] kind=%d ranks=%d->%d content=%d category=%d | problem='%s'" % [
		record.run_seed, record.source_level, str(record.succeeded()), record.failure_reason(),
		str(receipt.ok), str(receipt.root_seed_known), receipt.root_seed, receipt.lane,
		", ".join(receipt.granted_identity()), receipt.support_progression_kind, receipt.support_rank_before,
		receipt.support_rank_after, receipt.support_content_kind, receipt.support_fallback_category, record.problem()]


func _state() -> String:
	if review.mote_runtime == null:
		return "no runtime; attempted=%s calls=%d open=%s paused=%s" % [
			str(review.offer_attempted()), review.offer_open_calls, str(review.level_up_panel.is_open), str(paused)]
	return "level=%d experience=%s active=%s calls=%d attempted=%s open=%s paused=%s refusal='%s'" % [
		review.mote_runtime.level(), _amount_text(review.mote_runtime.experience()),
		str(review.mote_runtime.is_offer_active()), review.offer_open_calls,
		str(review.offer_attempted()), str(review.level_up_panel.is_open), str(paused), review.last_offer_refusal]


func _cards_text() -> PackedStringArray:
	var shown: PackedStringArray = PackedStringArray()
	for slot: int in review.level_up_panel.card_count():
		shown.append("%d=%d %s" % [slot, review.level_up_panel.lane_for_slot(slot), " / ".join(review.level_up_panel.card_lines(slot))])
	return shown



# --- Input, through the viewport -------------------------------------------------------------------------------

func _push_key(keycode: Key, pressed: bool) -> void:
	var event: InputEventKey = InputEventKey.new()
	event.keycode = keycode
	event.physical_keycode = keycode
	event.pressed = pressed
	root.push_input(event)


func _key(keycode: Key) -> void:
	_push_key(keycode, true)
	_push_key(keycode, false)
	await _await_process_frames(1)


func _push_joy(button: JoyButton, pressed: bool) -> void:
	var event: InputEventJoypadButton = InputEventJoypadButton.new()
	event.device = 0
	event.button_index = button
	event.pressed = pressed
	root.push_input(event)


func _push_mouse(at: Vector2, button: MouseButton, pressed: bool) -> void:
	var click: InputEventMouseButton = InputEventMouseButton.new()
	click.button_index = button
	click.pressed = pressed
	click.position = at
	click.global_position = at
	root.push_input(click, true)


# --- Evidence ----------------------------------------------------------------------------------------------------

## Adds no assertion: the rendered runs pin the same count as the headless one. Always
## awaited, so nothing moves while a frame is being taken.
func _capture(stem: String, settle_seconds: float = 0.0) -> void:
	if _shot_dir.is_empty():
		return
	if settle_seconds > 0.0:
		await create_timer(settle_seconds).timeout
	await _await_process_frames(6)
	for i: int in 7:
		await RenderingServer.frame_post_draw
	var path: String = "%s/%s.png" % [_shot_dir, stem]
	root.get_texture().get_image().save_png(path)
	print("  screenshot: %s" % path)


func _argument_value(flag: String) -> String:
	var index: int = arguments.find(flag)
	if index == -1 or index + 1 >= arguments.size():
		return ""
	return arguments[index + 1]


# --- Helpers ---------------------------------------------------------------------------------------------------

func _stand(at: Vector3) -> void:
	review.player.global_position = Vector3(at.x, 0.0, at.z)
	review.player.velocity = Vector3.ZERO
	review.player.clear_movement_intent("verification", false)
	review.camera_rig.focus = review.player.global_position


func _walk_into_gate(gate: Vector3) -> void:
	_stand(gate)
	await _await_process_frames(6)
	await _settle(4)


func _use() -> int:
	_next_use_id += 1
	return _next_use_id


func _await_navigation() -> void:
	for frame: int in 60:
		if NavigationServer3D.map_get_iteration_id(review.navigation_map()) > 0:
			return
		await physics_frame


func _settle(frames: int) -> void:
	for i: int in frames:
		await physics_frame


func _await_process_frames(frames: int) -> void:
	for i: int in frames:
		await process_frame


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


func _script_fields(instance: Object) -> PackedStringArray:
	var names: PackedStringArray = PackedStringArray()
	for property: Dictionary in instance.get_property_list():
		if int(property.get("usage", 0)) & PROPERTY_USAGE_SCRIPT_VARIABLE:
			names.append(String(property.get("name", "")))
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


## The stripped code lines of the function declared exactly as `declaration`.
func _body_after(code: String, declaration: String) -> PackedStringArray:
	var body: PackedStringArray = PackedStringArray()
	var inside: bool = false
	for line: String in code.split("\n"):
		if line.strip_edges() == declaration:
			inside = true
			continue
		if inside:
			if not line.is_empty() and not line.begins_with("\t") and not line.begins_with(" "):
				break
			if not line.strip_edges().is_empty():
				body.append(line.strip_edges())
	return body


## Code with every whole-line comment removed.
func _code(path: String) -> String:
	var kept: PackedStringArray = PackedStringArray()
	for line: String in FileAccess.get_file_as_string(path).split("\n"):
		if line.strip_edges().begins_with("#"):
			continue
		kept.append(line)
	return "\n".join(kept)


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
