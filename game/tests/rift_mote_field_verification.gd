extends SceneTree
## Riftwrought — Roguelite Foundation H5 verification: the run-owned Experience Mote
## field and its deterministic collection sweep.
##
## ONE FOCUSED HEADLESS TEST. Foundation H5 is two pure-logic scripts under
## `scripts/pickups/` — a field that belongs to one exact signed run seed, makes and
## owns its Experience Mote drops, and sweeps every uncollected drop in insertion
## order; and the value one sweep answers with. It runs as a `SceneTree` script
## exactly as every earlier foundation suite does.
##
## IT PORTS D-211's OWED-SET DISCIPLINE. Every check function records reaching its
## LAST line, and the suite compares that set against what it owes in BOTH
## directions, so a check that dies half way cannot leave a green run behind it.
##
## THE HARNESS NEVER PERFORMS THE SWEEP IT CHECKS, AND WRITES NO PRIVATE STATE.
## Every collection below was made by a field under test. The experience that
## reaches a level's requirement is collected BY THE FIELD'S OWN SWEEP wherever a
## check needs it; the harness only opens and resolves offers through the run's
## own public contract, and the Magnetism card is OFFERED and CHOSEN, never
## injected. The one private read — the run's current lifecycle, by name — only
## shows that a refusal left the run where it was; nothing is written, into a run,
## a field, a drop or a result's private indices.
##
## EVERY EXPECTED ANSWER IS EITHER A TYPED LITERAL OR THE ACCEPTED MECHANISM'S OWN
## ANSWER, asked directly with the same inputs — the drop's own problem, the drop's
## own attempt on a control drop in a control run, or the pickup-range query's own
## reading. Never a distance, radius or experience this file computed for the field.
##
## THE VALUES 25 AND 1.7e+308 ARE TEST EVIDENCE ONLY. Neither is an enemy-experience
## value, and nothing here claims performance or capacity.
##
## IT READS NO OTHER SUITE. It names no file under `tests/` but its own, which the
## runner asserts.

# --- The files ----------------------------------------------------------------------

const FIELD_FILE: String = "res://scripts/pickups/rift_mote_field.gd"
const RESULT_FILE: String = "res://scripts/pickups/rift_mote_sweep_result.gd"
const THIS_FILE: String = "res://tests/rift_mote_field_verification.gd"
const H5_FILES: Array[String] = [FIELD_FILE, RESULT_FILE]

const FIELD_CLASS: String = "RiftMoteField"
const RESULT_CLASS: String = "RiftMoteSweepResult"

## `scripts/pickups/` after H5: H2's two scripts, H3's two, H4's one and H5's two.
const PICKUP_SCRIPTS: Array[String] = [
	"res://scripts/pickups/rift_mote_collection_attempt.gd",
	"res://scripts/pickups/rift_mote_collection_result.gd",
	"res://scripts/pickups/rift_mote_drop.gd",
	"res://scripts/pickups/rift_mote_field.gd",
	"res://scripts/pickups/rift_mote_pickup_query.gd",
	"res://scripts/pickups/rift_mote_pickup_reading.gd",
	"res://scripts/pickups/rift_mote_sweep_result.gd",
]

const SCANNED_ROOTS: Array[String] = [
	"res://scripts", "res://scenes", "res://data", "res://addons",
]
const PROJECT_SETTINGS_FILE: String = "res://project.godot"

## Everything that would mean something that runs creates, fills or sweeps a field.
const UNWIRED_TOKENS: Array[String] = [
	"RiftMoteField", "rift_mote_field", "RiftMoteSweepResult", "rift_mote_sweep_result",
	"spawn_drop(", "sweep_collection(",
]

## THE ONLY FILES OUTSIDE H5 THAT MAY NAME AN UNWIRED TOKEN, PER FILE AND PER TOKEN.
## D-281: Foundation H6's enemy mote emission is handed a field and asks it to make
## one drop; it is granted the field's class and the drop-making call — never either
## file name, the sweep's result or the sweep. Nothing that runs creates an
## emission. This replaces the blanket "no other file" one for one: the same single
## assertion is made either way, and the pinned count does not move.
## D-283: Foundation H7's Graveblade mote binding is handed a field, asks it only its
## own problem and run seed, and passes it to its one emission when its Graveblade
## dies — so it is granted the field's class alone: never the drop-making call,
## either file name, the sweep's result or the sweep. Nothing that runs creates a
## binding. The same single assertion is made, and the pinned count does not move.
## D-286: Foundation H8's Experience Mote runtime makes and owns one field of its run,
## reads its counts, hands it to each binding it makes, and asks it to sweep itself
## into that run, answering the sweep's own value — so it is granted the field's
## class, the result's class and the sweep call: never the drop-making call or either
## file name. Nothing that runs creates a runtime. The same single assertion is made,
## and the pinned count does not move.
## D-288: the Roguelite Experience Collection Greybox Review — an isolated scene
## launched by name — reads the value H8's sweep answers with, to mirror each
## collected index onto its marker, so it is granted the result's class alone: never
## the field's class, the drop-making call, the sweep call or either file name. It
## sweeps only through H8. The same single assertion is made, and the pinned count
## does not move.
const AUTHORIZED_READERS: Array = [
	["res://scripts/experience/rift_enemy_mote_emission.gd", ["RiftMoteField", "spawn_drop("]],
	["res://scripts/experience/rift_graveblade_mote_binding.gd", ["RiftMoteField"]],
	["res://scripts/experience/rift_mote_runtime.gd", ["RiftMoteField", "RiftMoteSweepResult", "sweep_collection("]],
	["res://scripts/roguelite/experience/roguelite_experience_collection_review.gd", ["RiftMoteSweepResult"]],
]

## THE ONLY PROJECT CLASSES EACH FILE MAY NAME, checked against the engine's own
## global class list in both directions. The field names itself, the drops it makes
## and owns (H4), the answer each drop's attempt returns (H3's result), the run it is
## swept into (G4), and the value it answers with. Not the mote, the attempt, the
## pickup query or reading, the stat totals, the build, the run-level record. The
## result names itself and nothing else.
const FIELD_NAMES: Array[String] = [
	"RiftMoteCollectionResult", "RiftMoteDrop", "RiftMoteField", "RiftMoteSweepResult",
	"RiftRunLevelCoordinator",
]
const RESULT_NAMES: Array[String] = ["RiftMoteSweepResult"]

## Every method, in declaration order, with its full signature. The engine reports
## a constructor's return as an object, whatever the source declares.
const FIELD_SIGNATURES: Array[String] = [
	"_init(for_run_seed: int) -> Object",
	"spawn_drop(drop_position: Vector3, base_experience: float) -> String",
	"run_seed() -> int",
	"drop_count() -> int",
	"uncollected_count() -> int",
	"collected_count() -> int",
	"problem() -> String",
	"sweep_collection(player_position: Vector3, run: Object) -> Object",
	"describe() -> String",
]
const RESULT_SIGNATURES: Array[String] = [
	"refused(reason: String, for_total_count: int) -> Object",
	"completed(for_total_count: int, for_skipped_count: int, for_attempted_count: int, for_collected_indices: PackedInt32Array, for_out_of_range_count: int, for_item_refusal_count: int, for_first_item_refusal_reason: String) -> Object",
	"collected_indices() -> PackedInt32Array",
	"collected_count() -> int",
	"problem() -> String",
	"describe() -> String",
]

## THE FIELD'S WHOLE STATE: TWO PRIVATE FIELDS AND NO THIRD, each declared bare.
const FIELD_FIELDS: Array[String] = ["_run_seed", "_drops"]
const FIELD_DECLARATIONS: Array[String] = [
	"var _run_seed: int",
	"var _drops: Array[RiftMoteDrop]",
]
const RESULT_FIELDS: Array[String] = [
	"ok", "failure_reason", "total_count", "skipped_count", "attempted_count",
	"out_of_range_count", "item_refusal_count", "first_item_refusal_reason", "_collected_indices",
]

## THE ORDERS, AS THE CODE MUST SPELL THEM, first occurrence to first occurrence
## inside each method, each step exactly once.
const SPAWN_ORDER: Array[String] = [
	"var drop: RiftMoteDrop = RiftMoteDrop.new(_run_seed, drop_position, base_experience)",
	"var invalid: String = drop.problem()",
	"if not invalid.is_empty():",
	"return invalid",
	"_drops.append(drop)",
	"return \"\"",
]
const PROBLEM_ORDER: Array[String] = [
	"for index: int in _drops.size():",
	"var drop: RiftMoteDrop = _drops[index]",
	"if drop == null:",
	"var invalid: String = drop.problem()",
	"if not invalid.is_empty():",
	"if drop.run_seed() != _run_seed:",
]
const SWEEP_ORDER: Array[String] = [
	"if run == null:",
	"var incoherent: String = problem()",
	"if not incoherent.is_empty():",
	"if run.run_seed() != _run_seed:",
	"for index: int in _drops.size():",
	"var drop: RiftMoteDrop = _drops[index]",
	"if drop.is_collected():",
	"skipped += 1",
	"continue",
	"attempted += 1",
	"var answer: RiftMoteCollectionResult = drop.attempt_collection(player_position, run)",
	"if answer.is_collected():",
	"collected.append(index)",
	"elif answer.is_out_of_range():",
	"out_of_range += 1",
	"else:",
	"item_refusals += 1",
	"if first_item_refusal.is_empty():",
	"first_item_refusal = answer.failure_reason",
	"return RiftMoteSweepResult.completed(",
]

## Every gate, per method, each of which must return on its very next line.
const RETURNING_GATES: Array = [
	["func spawn_drop(", "if not invalid.is_empty():"],
	["func problem(", "if drop == null:"],
	["func problem(", "if not invalid.is_empty():"],
	["func problem(", "if drop.run_seed() != _run_seed:"],
	["func sweep_collection(", "if run == null:"],
	["func sweep_collection(", "if not incoherent.is_empty():"],
	["func sweep_collection(", "if run.run_seed() != _run_seed:"],
]

## EVERY `return` IN THE FIELD, EXACTLY. None hands out the drop list or a drop.
const FIELD_RETURNS: Array[String] = [
	"return invalid",
	"return \"\"",
	"return _run_seed",
	"return _drops.size()",
	"return uncollected",
	"return _drops.size() - uncollected_count()",
	"return \"entry %d of this Experience Mote field holds no drop\" % index",
	"return \"entry %d of this Experience Mote field is not a valid drop: %s\" % [index, invalid]",
	"return \"entry %d of this Experience Mote field belongs to run seed %d, not to the field's run seed %d\" % [",
	"return \"\"",
	"return RiftMoteSweepResult.refused(",
	"return RiftMoteSweepResult.refused(incoherent, _drops.size())",
	"return RiftMoteSweepResult.refused(",
	"return RiftMoteSweepResult.completed(",
	"return \"Experience Mote field of run seed %d: %d drops, %d collected, %d not collected\" % [",
]

## Content, formula constants, other mechanisms' members and every accepted scan's
## guarded tokens this foundation is not granted. Scanned RAW over both files,
## comments included — D-215's lesson.
const FORBIDDEN_TOKENS: Array[String] = [
	"card_", "Magnetism", "magnetism", "quick_strike", "Graveblade", "Skill", "enemy", "Enemy",
	"PICKUP_RADIUS", "EXPERIENCE_GAIN", "BASE_PICKUP_RADIUS", "RiftMotePickupQuery",
	"RiftMotePickupReading", "RiftMoteCollectionAttempt", "PlayerStat", "RiftRunBuild",
	"RiftRunLevelUpResult", "RiftLevelRequirement", "RiftLevelOfferSeed", "RiftOffer",
	"requirement_for", "offer_root_seed", "open_current_offer", "award_experience",
	"next_level_coordinator", "collect_into", "RiftExperienceMote", "rift_experience_mote",
	"rift_mote_drop", "rift_mote_collection", "rift_mote_pickup", ".tscn", "scenes/",
]

## A pure record reads no ambient state and asks no physics, collision, navigation
## or scene question. Scanned raw.
const AMBIENT_TOKENS: Array[String] = [
	"randi", "randf", "randomize", "RandomNumberGenerator", "rand_from_seed",
	"Time.", "OS.", "Engine.", "ProjectSettings", "InputMap",
	"FileAccess", "ConfigFile", "ResourceSaver", "ResourceLoader", "user://",
	"preload(", "load(", "get_tree", "get_node", "Node3D", "Area3D", "CollisionShape",
	"PhysicsServer", "NavigationServer", "NavigationAgent", "distance_to",
	"distance_squared_to", "length(", "global_position", "Transform3D",
]

## What neither file may do, as tokens over CODE lines only: no distance or radius
## formula, no coordinate read, no stat or build question, no offer step, no
## sorting, no removal, no signal, no node.
const RESTATEMENT_TOKENS: Array[String] = [
	"sqrt(", "abs(", "pow(", "min(", "max(", "clamp", "value_of", "total_for", ".x", ".y", ".z",
	"distance", "radius", "stat_totals", "run_build", "choose(", "open_", "evaluate(",
	"Dictionary", "set(", "setget", "signal", "emit", "connect(", "Node", "Area", "Shape",
	"sort", "shuffle", "reverse", "bsearch", "erase", "remove", "clear(", "pop_", "insert(",
	"resize", "fill(", "append_array", "push_front", "free(", "await", "_process",
]

## Member names that would mean a field can remove, reset, copy, transfer, tear
## down, store or hand out drops — none may name a method.
const DEFERRED_MEMBER_TOKENS: Array[String] = [
	"remove", "erase", "clear", "reset", "pop", "prune", "purge", "transfer", "duplicate",
	"clone", "copy", "teardown", "tear", "free", "save", "load", "persist", "insert",
	"set_", "assign", "owner", "move", "attract", "tick", "process", "pool", "despawn",
	"drops", "drop_at", "get_drop", "mote",
]

# --- The fixtures, stated independently -----------------------------------------------

## Test evidence only.
const TEST_MOTE: float = 25.0
const HUGE_MOTE: float = 1.7e308
const FIRST_REQUIREMENT: float = 100.0

## An ordinary owning run and one run that does not own the field.
const OWNER_SEED: int = 99
const STRANGER_SEED: int = 100

## The greybox base and the +25% radius, typed here rather than read from H2.
const BASE_RADIUS: float = 2.5
const MAGNETISM_RADIUS: float = 3.125
const MAGNETISM_TOTAL: float = 0.25

## Run seed 0 offers the shipped Pickup Radius card in its Level 1 Utility lane —
## measured under D-275 and asserted below rather than assumed.
const MAGNETISM_SEED: int = 0
const MAGNETISM_CARD: StringName = &"card_magnetism"

## 2^32: agrees with 0 in every one of its low 32 bits.
const TWO_TO_THE_32: int = 4294967296

## SIX SIGNED SEEDS IN TWO FAMILIES THAT AGREE IN THEIR LOW 32 BITS, each with its
## exact decimal spelling typed here.
const SEED_FAMILIES: Array = [
	[0, "0"],
	[4294967296, "4294967296"],
	[-9223372036854775808, "-9223372036854775808"],
	[-1, "-1"],
	[4294967295, "4294967295"],
	[9223372036854775807, "9223372036854775807"],
]
const LOW_32_MASK: int = 0xFFFFFFFF

## The spacing of this engine's world-position components between 2 m and 4 m:
## 2^-22 m.
const SPACING_2_TO_4: float = 1.0 / 4194304.0

## A player away from the origin and off the ground, and drop positions measured
## from them on the ground plane.
const PLAYER: Vector3 = Vector3(10.0, 0.5, -6.0)
const NEAR_DROP: Vector3 = Vector3(10.0, 0.5, -4.5)
const THREE_METRE_DROP: Vector3 = Vector3(13.0, 0.5, -6.0)

## THE BASELINE LAYOUT, in insertion order, with the answer each index owes from
## PLAYER at the 2.5 m base radius. Index 7 is the NEAREST drop of all and is
## inserted LAST, so an order chosen by nearness would collect it first.
const BASELINE_LAYOUT: Array = [
	["1.5 m", Vector3(10.0, 0.5, -4.5)],
	["3.0 m", Vector3(13.0, 0.5, -6.0)],
	["2.5 m on -x", Vector3(7.5, 0.5, -6.0)],
	["2.5 m on a 3-4-5 diagonal", Vector3(11.5, 0.5, -4.0)],
	["one spacing beyond 2.5 m", Vector3(10.0, 0.5, -3.5 + 1.0 / 4194304.0)],
	["one spacing within 2.5 m", Vector3(10.0, 0.5, -3.5 - 1.0 / 4194304.0)],
	["4.0 m", Vector3(10.0, 0.5, -10.0)],
	["0.0 m, 2.5 m above", Vector3(10.0, 3.0, -6.0)],
]
const BASELINE_COLLECTED: Array[int] = [0, 2, 3, 5, 7]

## The many-drop layout: a 20 × 12 grid at 0.5 m around the origin.
const GRID_COLUMNS: int = 20
const GRID_ROWS: int = 12
const GRID_SEED: int = 7

## The accepted wordings this suite quotes, typed independently.
const OFFER_OPEN_REFUSAL: String = "an offer is open; it must be resolved before further experience is recorded"
const NO_RUN_REFUSAL: String = "an Experience Mote field must be swept into a run, and none was given"
const OVERFLOW_REFUSAL: String = "adding 1.7e+308 to 1.7e+308 would make the stored progress unusable"

const UNUSABLE_BASES: Array = [
	["zero", 0.0], ["negative", -25.0], ["not a number", NAN],
	["positive infinity", INF], ["negative infinity", -INF],
]

const OWED_CHECKS: Array[String] = [
	"a_field_requires_an_explicit_seed_and_an_empty_field_sweeps_to_zero",
	"valid_drops_append_in_insertion_order",
	"an_invalid_drop_is_refused_atomically_and_nothing_is_transformed",
	"equal_drops_stay_independent",
	"a_wrong_run_is_refused_whole_before_any_drop_is_asked",
	"seeds_agreeing_in_their_low_32_bits_are_distinct_owners",
	"the_baseline_sweep_collects_exactly_the_in_range_indices",
	"out_of_range_drops_are_reconsidered_and_collected_drops_are_never_paid_again",
	"a_later_refusal_never_undoes_an_earlier_collection",
	"reaching_a_requirement_during_a_sweep_opens_nothing",
	"an_active_offer_refuses_in_range_drops_and_the_field_collects_after_the_choice",
	"magnetism_turns_a_resweep_of_a_3_metre_drop_into_a_collection",
	"a_many_drop_field_conserves_every_count_in_insertion_order",
	"the_sweep_result_is_a_coherent_value_whose_indices_are_copies",
	"no_drop_or_mote_can_be_obtained_from_the_field",
	"the_field_holds_two_fields_and_no_removal_reset_or_transfer",
	"the_field_restates_nothing_and_names_only_what_it_composes",
	"nothing_that_runs_creates_or_sweeps_a_field_and_the_directory_holds_seven_scripts",
]

var _failures: PackedStringArray = PackedStringArray()
var _checks: int = 0
var _reached: Dictionary = {}
var _whole_refusals: int = 0
var _completed_sweeps: int = 0
var _collected: int = 0


func _initialize() -> void:
	print("")
	print("=== Roguelite Foundation H5 — Run-Owned Mote Field and Deterministic Collection Sweep (D-279) ===")

	_check_seed_and_empty_field()
	_check_insertion_order()
	_check_invalid_drops()
	_check_equal_drops()
	_check_a_wrong_run()
	_check_low_32_bit_owners()
	_check_the_baseline_sweep()
	_check_resweeps()
	_check_a_later_refusal()
	_check_the_requirement()
	_check_an_active_offer()
	_check_magnetism()
	_check_many_drops()
	_check_the_result_value()
	_check_nothing_leaks()
	_check_the_fields_and_members()
	_check_the_shape()
	_check_nothing_runs_it()

	_check_every_check_ran()

	print("")
	if _failures.is_empty():
		print("RIFT MOTE FIELD VERIFICATION: PASS (%d checks)" % _checks)
		quit(0)
	else:
		for failure: String in _failures:
			printerr("  FAIL: %s" % failure)
		printerr("RIFT MOTE FIELD VERIFICATION: %d FAILURE(S) of %d checks" % [
			_failures.size(), _checks,
		])
		quit(1)


# --- 1. The seed, and the empty field -----------------------------------------------------------

func _check_seed_and_empty_field() -> void:
	print("")
	print("--- 1. A field needs an explicit signed run seed, and an empty field sweeps to a completed zero-count result")
	var script: GDScript = load(FIELD_FILE) as GDScript
	var constructor_args: int = -1
	var defaults: PackedStringArray = PackedStringArray()
	for entry: Dictionary in script.get_script_method_list():
		if String(entry.get("name", "")) == "_init":
			constructor_args = (entry.get("args", []) as Array).size()
		if not (entry.get("default_args", []) as Array).is_empty():
			defaults.append(String(entry.get("name", "")))
	_expect(constructor_args == 1 and defaults.is_empty(),
		"the constructor takes %d arguments; these methods default one: %s" % [constructor_args, ", ".join(defaults)])

	var exact: int = 0
	for row: Array in SEED_FAMILIES:
		var field: RiftMoteField = RiftMoteField.new(int(row[0]))
		if field.run_seed() == int(row[0]) and str(field.run_seed()) == String(row[1]):
			exact += 1
		_expect(field.drop_count() == 0 and field.uncollected_count() == 0 and field.collected_count() == 0
				and field.problem().is_empty(),
			"a fresh field of seed %s reads %s (%s)" % [String(row[1]), _field(field), field.problem()])
	_expect(exact == SEED_FAMILIES.size(), "%d of %d fields read back their exact seed" % [exact, SEED_FAMILIES.size()])

	var empty: RiftMoteField = RiftMoteField.new(OWNER_SEED)
	var run: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(OWNER_SEED)
	var before: String = _snapshot(run)
	var result: RiftMoteSweepResult = empty.sweep_collection(PLAYER, run)
	_expect_completed(result, "the empty field's sweep")
	_expect(result.total_count == 0 and result.skipped_count == 0 and result.attempted_count == 0
			and result.collected_indices().is_empty() and result.out_of_range_count == 0
			and result.item_refusal_count == 0 and result.first_item_refusal_reason.is_empty(),
		"the empty sweep reads %s" % _sweep(result))
	_expect(_snapshot(run) == before, "the empty sweep moved the run: %s" % _snapshot(run))
	## An empty field is still owned: a stranger is refused, not given an empty sweep.
	var stranger: RiftMoteSweepResult = empty.sweep_collection(PLAYER, RiftRunLevelCoordinator.new(STRANGER_SEED))
	_expect_whole_refusal(stranger, "the empty field swept into run seed 100", 0)
	_expect(stranger.failure_reason == _ownership_sentence("99", "100"), "the empty field answered: %s" % stranger.failure_reason)
	print("  the constructor takes %d argument and no method defaults one; %d of %d fields read back their exact signed seed; each starts with 0 drops"
		% [constructor_args, exact, SEED_FAMILIES.size()])
	print("  the empty field's sweep: %s; a stranger run is still refused whole" % result.describe())
	_done("a_field_requires_an_explicit_seed_and_an_empty_field_sweeps_to_zero")


# --- 2. Insertion order ----------------------------------------------------------------------------

func _check_insertion_order() -> void:
	print("")
	print("--- 2. Valid drops append at the end, and every sweep reports them by the index they were made at")
	var field: RiftMoteField = RiftMoteField.new(OWNER_SEED)
	var counts: PackedStringArray = PackedStringArray()
	## Even indices lie 1.5 m from the player, odd ones 3.0 m.
	for index: int in 6:
		var place: Vector3 = NEAR_DROP if index % 2 == 0 else THREE_METRE_DROP
		_expect(field.spawn_drop(place, TEST_MOTE).is_empty(), "drop %d was refused" % index)
		counts.append(str(field.drop_count()))
	_expect(", ".join(counts) == "1, 2, 3, 4, 5, 6", "the count grew as %s" % ", ".join(counts))
	var run: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(OWNER_SEED)
	var result: RiftMoteSweepResult = field.sweep_collection(PLAYER, run)
	_expect_completed(result, "the alternating field")
	_expect(result.collected_indices() == PackedInt32Array([0, 2, 4]) and result.out_of_range_count == 3
			and result.attempted_count == 6 and result.skipped_count == 0,
		"the alternating field swept as %s" % _sweep(result))
	_expect(run.experience() == 3.0 * TEST_MOTE and field.collected_count() == 3 and field.uncollected_count() == 3,
		"the alternating field left %s and %s" % [_field(field), _snapshot(run)])
	print("  the count grew %s; from the player the even entries (1.5 m) collected at %s and the odd ones (3.0 m) were %d out of range"
		% [", ".join(counts), result.collected_indices(), result.out_of_range_count])
	_done("valid_drops_append_in_insertion_order")


# --- 3. Invalid drops --------------------------------------------------------------------------------

func _check_invalid_drops() -> void:
	print("")
	print("--- 3. A drop the accepted drop calls invalid is refused with its own problem, and the field does not change")
	var field: RiftMoteField = RiftMoteField.new(OWNER_SEED)
	_expect(field.spawn_drop(NEAR_DROP, TEST_MOTE).is_empty() and field.spawn_drop(NEAR_DROP, TEST_MOTE).is_empty(),
		"the two leading drops were refused")
	var before: String = _field(field)
	var refused: int = 0
	var verbatim: int = 0
	for component: int in 3:
		for bad: float in [NAN, INF, -INF]:
			var place: Vector3 = NEAR_DROP
			place[component] = bad
			var answer: String = field.spawn_drop(place, TEST_MOTE)
			var own: String = RiftMoteDrop.new(OWNER_SEED, place, TEST_MOTE).problem()
			refused += int(not answer.is_empty())
			verbatim += int(not own.is_empty() and answer == own)
			_expect(_field(field) == before and field.problem().is_empty(),
				"the refused drop at %s moved the field: %s" % [place, _field(field)])
	for row: Array in UNUSABLE_BASES:
		var answer: String = field.spawn_drop(NEAR_DROP, float(row[1]))
		var own: String = RiftMoteDrop.new(OWNER_SEED, NEAR_DROP, float(row[1])).problem()
		refused += int(not answer.is_empty())
		verbatim += int(not own.is_empty() and answer == own)
		_expect(_field(field) == before and field.problem().is_empty(),
			"the refused %s drop moved the field: %s" % [String(row[0]), _field(field)])
	var both: String = field.spawn_drop(Vector3(NAN, 0.0, 0.0), 0.0)
	_expect(both == RiftMoteDrop.new(OWNER_SEED, Vector3(NAN, 0.0, 0.0), 0.0).problem() and both.contains("position"),
		"a drop wrong in both answered '%s'" % both)
	_expect(refused == 14 and verbatim == 14, "%d of 14 refused, %d quoting the drop's own problem" % [refused, verbatim])

	## The refusals took no index: the next valid drop is entry 2.
	_expect(field.spawn_drop(NEAR_DROP, TEST_MOTE).is_empty(), "the trailing drop was refused")
	var run: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(OWNER_SEED)
	var result: RiftMoteSweepResult = field.sweep_collection(PLAYER, run)
	_expect_completed(result, "the field after 15 refusals")
	_expect(result.total_count == 3 and result.collected_indices() == PackedInt32Array([0, 1, 2]),
		"after the refusals the field swept as %s" % _sweep(result))

	## NOTHING IS TRANSFORMED: the smallest positive double and 1.7e+308 are valid
	## drops, and each reaches an unmodified run exactly.
	var smallest: float = 1.0
	while smallest / 2.0 > 0.0:
		smallest /= 2.0
	var extremes: RiftMoteField = RiftMoteField.new(OWNER_SEED)
	_expect(extremes.spawn_drop(NEAR_DROP, smallest).is_empty(), "the smallest positive double was refused")
	var tiny_run: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(OWNER_SEED)
	_expect_completed(extremes.sweep_collection(PLAYER, tiny_run), "the smallest drop's sweep")
	var huge: RiftMoteField = RiftMoteField.new(OWNER_SEED)
	_expect(huge.spawn_drop(Vector3(10.0, 3.4e38, -4.5), HUGE_MOTE).is_empty(), "the 1.7e+308 drop was refused")
	var huge_run: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(OWNER_SEED)
	_expect_completed(huge.sweep_collection(PLAYER, huge_run), "the 1.7e+308 drop's sweep")
	_expect(tiny_run.experience() == smallest and huge_run.experience() == HUGE_MOTE,
		"the extremes delivered %s and %s" % [_exact(tiny_run.experience()), _exact(huge_run.experience())])
	print("  9 non-finite positions and 5 unusable amounts: %d of 14 refused, %d quoting the drop's own problem word for word; the field unchanged; a drop wrong in both answers '%s'"
		% [refused, verbatim, both])
	print("  the refusals took no index (the next valid drop swept as entry %d); %s and %s were kept as given and each paid exactly"
		% [result.collected_indices()[2], _exact(smallest), _exact(HUGE_MOTE)])
	_done("an_invalid_drop_is_refused_atomically_and_nothing_is_transformed")


# --- 4. Equal drops ------------------------------------------------------------------------------------

func _check_equal_drops() -> void:
	print("")
	print("--- 4. Two equal drops at one position are two drops")
	var field: RiftMoteField = RiftMoteField.new(OWNER_SEED)
	field.spawn_drop(NEAR_DROP, TEST_MOTE)
	field.spawn_drop(NEAR_DROP, TEST_MOTE)
	var run: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(OWNER_SEED)
	var result: RiftMoteSweepResult = field.sweep_collection(PLAYER, run)
	_expect_completed(result, "the two equal drops")
	_expect(result.collected_indices() == PackedInt32Array([0, 1]) and run.experience() == 2.0 * TEST_MOTE,
		"two equal drops swept as %s and delivered %s" % [_sweep(result), _exact(run.experience())])

	## Equal, at one position, and ONE of them pays while the other is refused: the
	## second 1.7e+308 would take the run's progress past every finite number.
	var pair: RiftMoteField = RiftMoteField.new(OWNER_SEED)
	pair.spawn_drop(NEAR_DROP, HUGE_MOTE)
	pair.spawn_drop(NEAR_DROP, HUGE_MOTE)
	var pair_run: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(OWNER_SEED)
	var split: RiftMoteSweepResult = pair.sweep_collection(PLAYER, pair_run)
	_expect_completed(split, "the two equal 1.7e+308 drops")
	_expect(split.collected_indices() == PackedInt32Array([0]) and split.item_refusal_count == 1
			and split.first_item_refusal_reason == OVERFLOW_REFUSAL,
		"the equal pair swept as %s" % _sweep(split))
	_expect(pair.collected_count() == 1 and pair.uncollected_count() == 1 and pair_run.experience() == HUGE_MOTE,
		"the equal pair left %s and %s" % [_field(pair), _exact(pair_run.experience())])
	print("  2 equal drops of 25 delivered %s, each once; 2 equal drops of 1.7e+308 at one position: entry 0 collected, entry 1 refused ('%s') and still uncollected"
		% [_exact(run.experience()), split.first_item_refusal_reason])
	_done("equal_drops_stay_independent")


# --- 5. A wrong run ------------------------------------------------------------------------------------

func _check_a_wrong_run() -> void:
	print("")
	print("--- 5. A run that does not own the field is refused whole, before any drop is asked, and nothing moves")
	var field: RiftMoteField = RiftMoteField.new(OWNER_SEED)
	for place: Vector3 in [NEAR_DROP, THREE_METRE_DROP, NEAR_DROP]:
		field.spawn_drop(place, TEST_MOTE)
	var owner: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(OWNER_SEED)
	var stranger: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(STRANGER_SEED)
	var expected: String = _ownership_sentence("99", "100")
	var owner_before: String = _snapshot(owner)
	var stranger_before: String = _snapshot(stranger)
	var lifecycle: int = _lifecycle_of(stranger).get_instance_id()
	var field_before: String = _field(field)
	var answers: Array[RiftMoteSweepResult] = []

	answers.append(field.sweep_collection(PLAYER, stranger))

	## NO DROP WAS ASKED: at a player position that is not a number, every drop
	## would have been refused with the pickup query's reason — as a twin field swept
	## into its own run shows — and the wrong run is answered for ownership instead.
	var garbage: Vector3 = Vector3(NAN, INF, -INF)
	answers.append(field.sweep_collection(garbage, stranger))
	var twin: RiftMoteField = RiftMoteField.new(OWNER_SEED)
	for place: Vector3 in [NEAR_DROP, THREE_METRE_DROP, NEAR_DROP]:
		twin.spawn_drop(place, TEST_MOTE)
	var twin_answer: RiftMoteSweepResult = twin.sweep_collection(garbage, RiftRunLevelCoordinator.new(OWNER_SEED))
	_expect_completed(twin_answer, "the twin field at a non-finite position")
	_expect(twin_answer.item_refusal_count == 3 and twin_answer.first_item_refusal_reason != expected
			and twin_answer.first_item_refusal_reason.begins_with("the player position must have a finite"),
		"the twin field swept as %s" % _sweep(twin_answer))

	## NO DROP REACHED THE RUN: a wrong run holding an open offer would refuse the
	## in-range drops with its own sentence.
	var busy: RiftRunLevelCoordinator = _run_with_an_open_offer(STRANGER_SEED)
	var busy_before: String = _snapshot(busy)
	answers.append(field.sweep_collection(PLAYER, busy))
	_expect(_snapshot(busy) == busy_before and busy.is_offer_active(), "the busy wrong run moved: %s" % _snapshot(busy))

	for answer: RiftMoteSweepResult in answers:
		_expect_whole_refusal(answer, "a sweep into run seed 100", 3)
	_expect(_field(field) == field_before and _snapshot(stranger) == stranger_before
			and _lifecycle_of(stranger).get_instance_id() == lifecycle and _snapshot(owner) == owner_before,
		"a wrong-run sweep moved something: %s | %s" % [_field(field), _snapshot(stranger)])

	var no_run: RiftMoteSweepResult = field.sweep_collection(PLAYER, null)
	_expect_whole_refusal(no_run, "a sweep with no run", 3)
	_expect(no_run.failure_reason == NO_RUN_REFUSAL, "the missing run answered '%s'" % no_run.failure_reason)

	## THE OWNING RUN THEN SWEEPS THE SAME FIELD.
	var owned: RiftMoteSweepResult = field.sweep_collection(PLAYER, owner)
	_expect_completed(owned, "the owning run's sweep")
	_expect(owned.collected_indices() == PackedInt32Array([0, 2]) and owned.out_of_range_count == 1,
		"the owning run swept as %s" % _sweep(owned))

	## A PARTLY, THEN WHOLLY, COLLECTED FIELD IS STILL REFUSED FOR OWNERSHIP — never
	## answered with a sweep of skipped entries.
	answers.append(field.sweep_collection(PLAYER, stranger))
	_expect_completed(field.sweep_collection(THREE_METRE_DROP, owner), "the owning run's second sweep")
	_expect(field.uncollected_count() == 0, "the field still holds %d uncollected drops" % field.uncollected_count())
	answers.append(field.sweep_collection(PLAYER, stranger))
	var owned_answers: int = 0
	for answer: RiftMoteSweepResult in answers:
		if not answer.ok and answer.failure_reason == expected and answer.attempted_count == 0 \
				and answer.skipped_count == 0 and answer.collected_indices().is_empty():
			owned_answers += 1
	_expect_whole_refusal(answers[3], "the partly collected field swept into run seed 100", 3)
	_expect_whole_refusal(answers[4], "the wholly collected field swept into run seed 100", 3)
	_expect(owned_answers == 5, "%d of 5 wrong-run sweeps answered ownership and nothing counted" % owned_answers)
	_expect(_snapshot(stranger) == stranger_before and stranger.experience() == 0.0 and owner.experience() == 3.0 * TEST_MOTE,
		"after everything the wrong run reads %s and the owner %s" % [_snapshot(stranger), _exact(owner.experience())])
	print("  run seed 100 refused ('%s')" % expected)
	print("  %d of 5 wrong-run sweeps answered exactly that with nothing attempted, skipped or collected — at the player, at %s, against an open offer, and after one and after every collection — where a twin field in its own run answers '%s' for all 3 drops"
		% [owned_answers, garbage, twin_answer.first_item_refusal_reason])
	print("  no run: '%s'; the owning run then collected %s of the same field and, after moving, %s" % [
		no_run.failure_reason, owned.collected_indices(), _exact(owner.experience())])
	_done("a_wrong_run_is_refused_whole_before_any_drop_is_asked")


# --- 6. Low 32 bits ------------------------------------------------------------------------------------

func _check_low_32_bit_owners() -> void:
	print("")
	print("--- 6. Run seeds 0 and 4,294,967,296 are two owners, and every signed seed keeps exact ownership")
	_expect(TWO_TO_THE_32 & LOW_32_MASK == 0 and TWO_TO_THE_32 != 0, "2^32's low 32 bits read %d" % [TWO_TO_THE_32 & LOW_32_MASK])
	var zero_field: RiftMoteField = RiftMoteField.new(0)
	var wide_field: RiftMoteField = RiftMoteField.new(TWO_TO_THE_32)
	zero_field.spawn_drop(NEAR_DROP, TEST_MOTE)
	wide_field.spawn_drop(NEAR_DROP, TEST_MOTE)
	var zero_run: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(0)
	var wide_run: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(TWO_TO_THE_32)
	var crossed_a: RiftMoteSweepResult = zero_field.sweep_collection(PLAYER, wide_run)
	var crossed_b: RiftMoteSweepResult = wide_field.sweep_collection(PLAYER, zero_run)
	_expect_whole_refusal(crossed_a, "the seed-0 field swept into run seed 4294967296", 1)
	_expect_whole_refusal(crossed_b, "the seed-4294967296 field swept into run seed 0", 1)
	_expect(crossed_a.failure_reason == _ownership_sentence("0", "4294967296")
			and crossed_b.failure_reason == _ownership_sentence("4294967296", "0"),
		"the crossed sweeps answered '%s' / '%s'" % [crossed_a.failure_reason, crossed_b.failure_reason])
	_expect(zero_run.experience() == 0.0 and wide_run.experience() == 0.0, "a crossed sweep paid")
	_expect_completed(zero_field.sweep_collection(PLAYER, zero_run), "the seed-0 field into its own run")
	_expect_completed(wide_field.sweep_collection(PLAYER, wide_run), "the seed-4294967296 field into its own run")
	_expect(zero_run.experience() == TEST_MOTE and wide_run.experience() == TEST_MOTE,
		"the owners hold %s and %s" % [_exact(zero_run.experience()), _exact(wide_run.experience())])

	var completed: int = 0
	var refused: int = 0
	var colliding: int = 0
	var misfits: PackedStringArray = PackedStringArray()
	for field_row: Array in SEED_FAMILIES:
		for run_row: Array in SEED_FAMILIES:
			var field_seed: int = int(field_row[0])
			var run_seed: int = int(run_row[0])
			var field: RiftMoteField = RiftMoteField.new(field_seed)
			field.spawn_drop(NEAR_DROP, TEST_MOTE)
			field.spawn_drop(THREE_METRE_DROP, TEST_MOTE)
			var run: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(run_seed)
			var result: RiftMoteSweepResult = field.sweep_collection(PLAYER, run)
			if field_seed == run_seed:
				_expect_completed(result, "the field of run seed %s into its own run" % String(field_row[1]))
				if result.collected_indices() == PackedInt32Array([0]) and result.out_of_range_count == 1 \
						and run.experience() == TEST_MOTE:
					completed += 1
				else:
					misfits.append("%s -> %s: %s" % [String(field_row[1]), String(run_row[1]), _sweep(result)])
			else:
				_expect_whole_refusal(result, "the field of run seed %s into run seed %s" % [String(field_row[1]), String(run_row[1])], 2)
				if result.failure_reason == _ownership_sentence(String(field_row[1]), String(run_row[1])) \
						and run.experience() == 0.0 and field.uncollected_count() == 2:
					refused += 1
					if field_seed & LOW_32_MASK == run_seed & LOW_32_MASK:
						colliding += 1
				else:
					misfits.append("%s -> %s: %s" % [String(field_row[1]), String(run_row[1]), result.failure_reason])
			_expect(field.run_seed() == field_seed and field.problem().is_empty(),
				"the field of seed %s reads seed %d (%s)" % [String(field_row[1]), field.run_seed(), field.problem()])
	_expect(misfits.is_empty(), "these pairs misbehaved: %s" % " | ".join(misfits))
	_expect(completed == 6 and refused == 30 and colliding == 12,
		"%d owners swept, %d strangers refused, %d of them colliding in the low 32 bits" % [completed, refused, colliding])
	print("  0 and 4294967296 each refused the other's field ('%s' / '%s') and each collected its own"
		% [crossed_a.failure_reason, crossed_b.failure_reason])
	print("  seeds 0, 4294967296, -9223372036854775808, -1, 4294967295, 9223372036854775807: %d of 36 field-run pairs swept (each field by its own run); %d refused whole naming both seeds in full, %d of them seeds that agree in their low 32 bits"
		% [completed, refused, colliding])
	_done("seeds_agreeing_in_their_low_32_bits_are_distinct_owners")


# --- 7. The baseline sweep ------------------------------------------------------------------------------

func _check_the_baseline_sweep() -> void:
	print("")
	print("--- 7. A baseline sweep collects exactly the in-range indices, the inclusive boundary included, in insertion order")
	var field: RiftMoteField = _baseline_field()
	var run: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(OWNER_SEED)
	## THE PICKUP QUERY'S OWN ANSWER FOR EVERY POSITION, asked on the run's own totals.
	var oracle: PackedInt32Array = PackedInt32Array()
	var nearest: int = -1
	var nearest_distance: float = INF
	for index: int in BASELINE_LAYOUT.size():
		var reading: RiftMotePickupReading = RiftMotePickupQuery.evaluate(
			PLAYER, BASELINE_LAYOUT[index][1], run.run_build().stat_totals())
		_expect(reading.ok and reading.effective_radius == BASE_RADIUS, "the query refused entry %d" % index)
		if reading.in_range:
			oracle.append(index)
		if reading.planar_distance < nearest_distance:
			nearest = index
			nearest_distance = reading.planar_distance
	_expect(oracle == PackedInt32Array(BASELINE_COLLECTED), "the query calls %s in range" % oracle)
	var result: RiftMoteSweepResult = field.sweep_collection(PLAYER, run)
	_expect_completed(result, "the baseline sweep")
	_expect(result.collected_indices() == PackedInt32Array(BASELINE_COLLECTED) and result.collected_indices() == oracle
			and result.out_of_range_count == 3 and result.item_refusal_count == 0
			and result.attempted_count == 8 and result.skipped_count == 0 and result.total_count == 8,
		"the baseline swept as %s" % _sweep(result))
	_expect(run.experience() == 5.0 * TEST_MOTE and field.collected_count() == 5 and field.uncollected_count() == 3,
		"the baseline left %s and %s" % [_field(field), _snapshot(run)])

	## THE INDICES ARE ASCENDING, AND A COPY CANNOT CHANGE THE ANSWER.
	var read: PackedInt32Array = result.collected_indices()
	read.append(99)
	read.set(0, 42)
	read.reverse()
	_expect(result.collected_indices() == PackedInt32Array(BASELINE_COLLECTED) and result.problem().is_empty(),
		"changing a reading changed the result to %s" % result.collected_indices())
	var labels: PackedStringArray = PackedStringArray()
	for index: int in result.collected_indices():
		labels.append(String(BASELINE_LAYOUT[index][0]))
	## The nearest drop was inserted last, so an order chosen by nearness would have
	## put it first.
	var order: PackedInt32Array = result.collected_indices()
	_expect(nearest == BASELINE_LAYOUT.size() - 1 and order[order.size() - 1] == nearest and order[0] != nearest,
		"the nearest drop, entry %d, sits at position %d of %s" % [nearest, order.find(nearest), order])
	print("  the pickup query calls entries %s in range at %s m; the sweep collected %s (%s) and found %d out of range"
		% [oracle, _exact(BASE_RADIUS), result.collected_indices(), ", ".join(labels), result.out_of_range_count])
	print("  the nearest drop, entry %d at %s m, was collected at position %d of %d; a reading changed three ways left the result at %s"
		% [nearest, _exact(nearest_distance), order.find(nearest) + 1, order.size(), result.collected_indices()])
	_done("the_baseline_sweep_collects_exactly_the_in_range_indices")


# --- 8. Resweeps -----------------------------------------------------------------------------------------

func _check_resweeps() -> void:
	print("")
	print("--- 8. Out-of-range drops stay and are reconsidered; collected drops are skipped and never paid again")
	var field: RiftMoteField = _baseline_field()
	var run: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(OWNER_SEED)
	_expect_completed(field.sweep_collection(PLAYER, run), "the first baseline sweep")
	var trail: PackedStringArray = PackedStringArray()
	for step: Array in [
			[THREE_METRE_DROP, [1], 5],
			[Vector3(10.0, 0.5, -3.5), [4], 6],
			[Vector3(10.0, 0.5, -10.0), [6], 7]]:
		var result: RiftMoteSweepResult = field.sweep_collection(step[0], run)
		_expect_completed(result, "the sweep from %s" % step[0])
		_expect(result.collected_indices() == PackedInt32Array(step[1]) and result.skipped_count == int(step[2])
				and result.attempted_count == 8 - int(step[2]),
			"the sweep from %s read %s" % [step[0], _sweep(result)])
		trail.append("%s skipping %d" % [result.collected_indices(), result.skipped_count])
	_expect(field.uncollected_count() == 0 and field.collected_count() == 8 and run.experience() == 8.0 * TEST_MOTE,
		"after four sweeps %s, %s" % [_field(field), _exact(run.experience())])

	## EVERY LATER SWEEP SKIPS EVERYTHING AND PAYS NOTHING.
	var before: String = _snapshot(run)
	var lifecycle: int = _lifecycle_of(run).get_instance_id()
	var idle: int = 0
	for place: Vector3 in [PLAYER, THREE_METRE_DROP, Vector3(10.0, 0.5, -10.0), Vector3(NAN, 0.0, 0.0)]:
		var result: RiftMoteSweepResult = field.sweep_collection(place, run)
		_expect_completed(result, "a sweep of the spent field from %s" % place)
		if result.skipped_count == 8 and result.attempted_count == 0 and result.collected_indices().is_empty():
			idle += 1
	_expect(idle == 4 and _snapshot(run) == before and _lifecycle_of(run).get_instance_id() == lifecycle,
		"%d of 4 later sweeps skipped everything; the run reads %s" % [idle, _snapshot(run)])
	print("  after the baseline collected 5, three sweeps from new positions collected %s; the field then held 8 collected and delivered %s"
		% [" then ".join(trail), _exact(run.experience())])
	print("  %d of 4 later sweeps — one from a non-finite position — skipped all 8, attempted 0 and paid nothing" % idle)
	_done("out_of_range_drops_are_reconsidered_and_collected_drops_are_never_paid_again")


# --- 9. A later refusal ------------------------------------------------------------------------------------

func _check_a_later_refusal() -> void:
	print("")
	print("--- 9. An item refusal does not stop the sweep and never undoes an earlier collection")
	## Entry 1 is NEARER than entry 0 and just as large. In insertion order entry 0
	## pays and entry 1 would take the progress past every finite number; an order
	## chosen by nearness would have paid entry 1 and refused entry 0.
	var field: RiftMoteField = RiftMoteField.new(OWNER_SEED)
	field.spawn_drop(Vector3(10.0, 0.5, -4.0), HUGE_MOTE)
	field.spawn_drop(Vector3(10.0, 0.5, -5.5), HUGE_MOTE)
	field.spawn_drop(NEAR_DROP, TEST_MOTE)
	field.spawn_drop(THREE_METRE_DROP, TEST_MOTE)
	var run: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(OWNER_SEED)
	## The accepted mechanism's own answer to the refused step, on a control drop.
	var control_run: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(OWNER_SEED)
	var control_first: RiftMoteDrop = RiftMoteDrop.new(OWNER_SEED, NEAR_DROP, HUGE_MOTE)
	control_first.attempt_collection(PLAYER, control_run)
	var control: RiftMoteCollectionResult = RiftMoteDrop.new(OWNER_SEED, NEAR_DROP, HUGE_MOTE).attempt_collection(PLAYER, control_run)
	var result: RiftMoteSweepResult = field.sweep_collection(PLAYER, run)
	_expect_completed(result, "the overflow sweep")
	_expect(result.collected_indices() == PackedInt32Array([0, 2]) and result.item_refusal_count == 1
			and result.out_of_range_count == 1 and result.attempted_count == 4,
		"the overflow sweep read %s" % _sweep(result))
	_expect(control.is_refused() and result.first_item_refusal_reason == control.failure_reason
			and result.first_item_refusal_reason == OVERFLOW_REFUSAL,
		"the sweep kept '%s' where the drop's own attempt answers '%s'" % [result.first_item_refusal_reason, control.failure_reason])
	_expect(run.experience() == HUGE_MOTE + TEST_MOTE and field.collected_count() == 2,
		"entry 0 was undone: the run holds %s, the field %s" % [_exact(run.experience()), _field(field)])

	## THE FIRST REFUSAL IS KEPT, NOT THE LAST: a non-finite player position refuses
	## every drop with the query's reason, and the count is every attempted drop.
	var again: RiftMoteSweepResult = field.sweep_collection(Vector3(NAN, 0.0, 0.0), run)
	_expect_completed(again, "the sweep from a non-finite position")
	_expect(again.skipped_count == 2 and again.item_refusal_count == 2 and again.collected_indices().is_empty()
			and again.first_item_refusal_reason.begins_with("the player position must have a finite"),
		"the non-finite sweep read %s" % _sweep(again))
	_expect(run.experience() == HUGE_MOTE + TEST_MOTE, "the non-finite sweep moved the run")
	print("  entries 0 and 1 hold 1.7e+308, entry 1 nearer: collected %s, %d refused ('%s', equal to the drop's own answer), %d out of range; entry 0 stayed paid"
		% [result.collected_indices(), result.item_refusal_count, result.first_item_refusal_reason, result.out_of_range_count])
	print("  from a non-finite position: %d skipped, %d refused, first reason '%s'; nothing moved"
		% [again.skipped_count, again.item_refusal_count, again.first_item_refusal_reason])
	_done("a_later_refusal_never_undoes_an_earlier_collection")


# --- 10. The requirement ------------------------------------------------------------------------------------

func _check_the_requirement() -> void:
	print("")
	print("--- 10. Reaching and passing the requirement during a sweep opens no offer and advances no level")
	var field: RiftMoteField = RiftMoteField.new(OWNER_SEED)
	for _index: int in 5:
		field.spawn_drop(NEAR_DROP, TEST_MOTE)
	var run: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(OWNER_SEED)
	var needed: RiftLevelRequirementReading = run.requirement_reading()
	_expect(needed.ok and needed.experience_requirement() == FIRST_REQUIREMENT,
		"level 1 requires %s" % needed.describe())
	var result: RiftMoteSweepResult = field.sweep_collection(PLAYER, run)
	_expect_completed(result, "the five-drop sweep")
	_expect(result.collected_indices() == PackedInt32Array([0, 1, 2, 3, 4]),
		"the sweep stopped early: %s" % _sweep(result))
	_expect(run.level() == 1 and not run.is_offer_active() and run.experience() == 5.0 * TEST_MOTE,
		"the sweep left %s" % _snapshot(run))
	print("  level 1 requires %s; the sweep collected %s and delivered %s: still level %d, offer open: %s"
		% [_exact(needed.experience_requirement()), result.collected_indices(), _exact(run.experience()), run.level(),
			str(run.is_offer_active())])
	_done("reaching_a_requirement_during_a_sweep_opens_nothing")


# --- 11. An active offer --------------------------------------------------------------------------------------

func _check_an_active_offer() -> void:
	print("")
	print("--- 11. While an offer stands, in-range drops are refused with G4's reason, and the same field collects after the choice")
	var field: RiftMoteField = RiftMoteField.new(OWNER_SEED)
	for _index: int in 4:
		field.spawn_drop(NEAR_DROP, TEST_MOTE)
	var run: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(OWNER_SEED)
	## THE FIELD'S OWN SWEEP reaches the requirement; the caller opens the offer.
	_expect_completed(field.sweep_collection(PLAYER, run), "the sweep that reaches the requirement")
	_expect(run.experience() == FIRST_REQUIREMENT and not run.is_offer_active(), "the reaching sweep left %s" % _snapshot(run))
	_expect_accepted(_open(run), "the level 1 offer")
	for place: Vector3 in [NEAR_DROP, THREE_METRE_DROP, NEAR_DROP, THREE_METRE_DROP]:
		field.spawn_drop(place, TEST_MOTE)
	var standing: String = _snapshot(run)
	var lifecycle: int = _lifecycle_of(run).get_instance_id()
	var control: RiftMoteCollectionResult = RiftMoteDrop.new(OWNER_SEED, NEAR_DROP, TEST_MOTE).attempt_collection(
		PLAYER, _run_with_an_open_offer(OWNER_SEED))

	var refusals: int = 0
	var out_of_range: int = 0
	for attempt: int in 2:
		var result: RiftMoteSweepResult = field.sweep_collection(PLAYER, run)
		_expect_completed(result, "the sweep while the offer stands, attempt %d" % (attempt + 1))
		_expect(result.skipped_count == 4 and result.attempted_count == 4 and result.collected_indices().is_empty()
				and result.item_refusal_count == 2 and result.out_of_range_count == 2
				and result.first_item_refusal_reason == OFFER_OPEN_REFUSAL
				and result.first_item_refusal_reason == control.failure_reason,
			"the sweep while the offer stands read %s" % _sweep(result))
		refusals += result.item_refusal_count
		out_of_range += result.out_of_range_count
	_expect(_snapshot(run) == standing and _lifecycle_of(run).get_instance_id() == lifecycle and run.is_offer_active()
			and field.uncollected_count() == 4,
		"a sweep against the offer moved something: %s | %s" % [_snapshot(run), _field(field)])

	var outcome: RiftRunLevelUpResult = run.choose(RiftOffer.Lane.COMBAT_DEFENCE)
	_expect(outcome.succeeded() and run.level() == 2 and run.experience() == 0.0 and not run.is_offer_active(),
		"resolving the offer left %s (%s)" % [_snapshot(run), outcome.failure_reason()])
	var after: RiftMoteSweepResult = field.sweep_collection(PLAYER, run)
	_expect_completed(after, "the sweep after the choice")
	_expect(after.collected_indices() == PackedInt32Array([4, 6]) and after.out_of_range_count == 2 and after.skipped_count == 4,
		"the sweep after the choice read %s" % _sweep(after))
	_expect(run.experience() == 2.0 * TEST_MOTE and run.level() == 2, "after the choice the run reads %s" % _snapshot(run))
	print("  the field's own sweep reached %s; while the offer stood two sweeps refused %d in-range drops ('%s', equal to the drop's own answer) and found %d out of range, collecting nothing; the run unmoved"
		% [_exact(FIRST_REQUIREMENT), refusals, control.failure_reason, out_of_range])
	print("  after the choice (level %d) the same field collected %s and still found %d out of range" % [
		run.level(), after.collected_indices(), after.out_of_range_count])
	_done("an_active_offer_refuses_in_range_drops_and_the_field_collects_after_the_choice")


# --- 12. Magnetism --------------------------------------------------------------------------------------------

func _check_magnetism() -> void:
	print("")
	print("--- 12. Magnetism, offered and chosen through the run, turns a resweep of a 3.0 m drop into a collection")
	var field: RiftMoteField = RiftMoteField.new(MAGNETISM_SEED)
	for place: Vector3 in [NEAR_DROP, THREE_METRE_DROP, NEAR_DROP, NEAR_DROP, NEAR_DROP]:
		field.spawn_drop(place, TEST_MOTE)
	var run: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(MAGNETISM_SEED)
	var baseline: RiftMoteSweepResult = field.sweep_collection(PLAYER, run)
	_expect_completed(baseline, "the baseline sweep of the Magnetism field")
	_expect(baseline.collected_indices() == PackedInt32Array([0, 2, 3, 4]) and baseline.out_of_range_count == 1
			and run.experience() == FIRST_REQUIREMENT and not run.is_offer_active(),
		"the baseline read %s, leaving %s" % [_sweep(baseline), _snapshot(run)])

	## THE ACCEPTED RUN PATH: an explicit open and an explicit choice of the lane that
	## OFFERS the card. Nothing is injected, and the experience was the field's own.
	_expect_accepted(_open(run), "the level 1 offer")
	var offered: PackedStringArray = run.offer_identity_for(RiftOffer.Lane.UTILITY)
	_expect(offered == PackedStringArray([String(MAGNETISM_CARD)]),
		"run seed %d's level 1 Utility lane offers %s" % [MAGNETISM_SEED, str(offered)])
	var outcome: RiftRunLevelUpResult = run.choose(RiftOffer.Lane.UTILITY)
	_expect(outcome.succeeded() and run.level() == 2 and run.experience() == 0.0,
		"the Utility choice left %s (%s)" % [_snapshot(run), outcome.failure_reason()])
	var build: RiftRunBuild = run.run_build()
	_expect(build.acquired_card_ids().size() == 1 and build.acquired_card_ids()[0] == MAGNETISM_CARD
			and build.total_for(PlayerStats.PICKUP_RADIUS) == MAGNETISM_TOTAL,
		"the build holds %s with Pickup Radius %s" % [str(build.acquired_card_ids()), _exact(build.total_for(PlayerStats.PICKUP_RADIUS))])
	var reading: RiftMotePickupReading = RiftMotePickupQuery.evaluate(PLAYER, THREE_METRE_DROP, run.run_build().stat_totals())
	_expect(reading.ok and reading.in_range and reading.effective_radius == MAGNETISM_RADIUS,
		"the query now reads %s" % reading.describe())

	var resweep: RiftMoteSweepResult = field.sweep_collection(PLAYER, run)
	_expect_completed(resweep, "the resweep on the Magnetism build")
	_expect(resweep.collected_indices() == PackedInt32Array([1]) and resweep.skipped_count == 4
			and resweep.attempted_count == 1 and resweep.out_of_range_count == 0,
		"the resweep read %s" % _sweep(resweep))
	_expect(run.experience() == TEST_MOTE and field.uncollected_count() == 0, "the resweep left %s" % _snapshot(run))
	_expect(baseline.collected_indices() == PackedInt32Array([0, 2, 3, 4]) and baseline.out_of_range_count == 1,
		"the answer given before the card now reads %s" % _sweep(baseline))
	print("  the baseline sweep collected %s and left entry 1 out of range at %s m; it delivered %s, and no offer opened by itself"
		% [baseline.collected_indices(), _exact(BASE_RADIUS), _exact(FIRST_REQUIREMENT)])
	print("  run seed %d, level 1 Utility lane: %s chosen; Pickup Radius total %s; the resweep skipped %d and collected %s within %s m; the award stayed %s"
		% [MAGNETISM_SEED, MAGNETISM_CARD, _exact(build.total_for(PlayerStats.PICKUP_RADIUS)), resweep.skipped_count,
			resweep.collected_indices(), _exact(reading.effective_radius), _exact(run.experience())])
	_done("magnetism_turns_a_resweep_of_a_3_metre_drop_into_a_collection")


# --- 13. Many drops ----------------------------------------------------------------------------------------------

func _check_many_drops() -> void:
	print("")
	print("--- 13. A modest many-drop field conserves every count and keeps insertion order (no performance claim)")
	var field: RiftMoteField = _grid_field()
	var twin: RiftMoteField = _grid_field()
	var total: int = GRID_COLUMNS * GRID_ROWS
	var run: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(GRID_SEED)
	var twin_run: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(GRID_SEED)
	var positions: Array[Vector3] = _grid_positions()
	var shown: PackedStringArray = PackedStringArray()
	var collected_total: int = 0
	## Every index an earlier sweep of this check reported collected — read off the
	## answers, never out of the field.
	var already: PackedInt32Array = PackedInt32Array()
	for player: Vector3 in [Vector3.ZERO, Vector3(3.0, 0.0, 0.0), Vector3(-3.5, 0.0, 1.0), Vector3.ZERO]:
		## THE PICKUP QUERY'S OWN ANSWER for every drop not yet collected.
		var oracle: PackedInt32Array = PackedInt32Array()
		var remaining: int = field.uncollected_count()
		for index: int in total:
			if already.has(index):
				continue
			if RiftMotePickupQuery.evaluate(player, positions[index], run.run_build().stat_totals()).in_range:
				oracle.append(index)
		var result: RiftMoteSweepResult = field.sweep_collection(player, run)
		var mirror: RiftMoteSweepResult = twin.sweep_collection(player, twin_run)
		_expect_completed(result, "the grid sweep from %s" % player)
		_expect_completed(mirror, "the twin grid sweep from %s" % player)
		_expect(result.total_count == total and result.skipped_count == total - remaining
				and result.attempted_count == remaining
				and result.skipped_count + result.attempted_count == result.total_count
				and result.collected_count() + result.out_of_range_count + result.item_refusal_count == result.attempted_count
				and result.item_refusal_count == 0,
			"the grid sweep from %s did not conserve its counts: %s" % [player, _sweep(result)])
		_expect(result.collected_indices() == oracle, "the grid sweep from %s collected %d where the query calls %d in range"
			% [player, result.collected_count(), oracle.size()])
		_expect(_sweep(result) == _sweep(mirror), "the twin field answered %s" % _sweep(mirror))
		already.append_array(result.collected_indices())
		collected_total += result.collected_count()
		_expect(field.collected_count() == collected_total and field.uncollected_count() == total - collected_total
				and run.experience() == float(collected_total) * TEST_MOTE,
			"after the sweep from %s: %s, %s" % [player, _field(field), _exact(run.experience())])
		shown.append("%d skipped + %d attempted = %d; %d collected + %d out of range + %d refused"
			% [result.skipped_count, result.attempted_count, result.total_count, result.collected_count(),
				result.out_of_range_count, result.item_refusal_count])
	print("  a %d-drop grid swept 4 times: %s" % [total, " | ".join(shown)])
	print("  every collected list equal to the pickup query's own in-range entries, ascending; a twin field answered identically every time; %d collected, %d not, %s delivered"
		% [field.collected_count(), field.uncollected_count(), _exact(run.experience())])
	_done("a_many_drop_field_conserves_every_count_in_insertion_order")


# --- 14. The result value ----------------------------------------------------------------------------------------

func _check_the_result_value() -> void:
	print("")
	print("--- 14. A sweep result is a coherent value: its indices are copies, and problem() refuses every contradiction")
	## THE COPY IS LOAD-BEARING: in this engine an assigned packed array is shared.
	var shared: PackedInt32Array = PackedInt32Array([1])
	var alias: PackedInt32Array = shared
	alias.append(2)
	_expect(shared.size() == 2, "an assigned packed array was not shared, so the copy proves nothing here")

	var mine: PackedInt32Array = PackedInt32Array([0, 2])
	var built: RiftMoteSweepResult = RiftMoteSweepResult.completed(3, 0, 3, mine, 1, 0, "")
	mine.append(1)
	mine.set(0, 2)
	var read: PackedInt32Array = built.collected_indices()
	read.append(9)
	read.set(1, 7)
	_expect(built.collected_indices() == PackedInt32Array([0, 2]) and built.problem().is_empty(),
		"the caller's or the reader's array changed the value to %s" % built.collected_indices())

	var refused: RiftMoteSweepResult = RiftMoteSweepResult.refused("", 4)
	_expect(not refused.ok and not refused.failure_reason.strip_edges().is_empty() and refused.problem().is_empty(),
		"a refusal with no stated reason reads '%s' (%s)" % [refused.failure_reason, refused.problem()])

	## EVERY CONTRADICTION, BUILT THROUGH THE PUBLIC CONSTRUCTORS AND FIELDS.
	var tampered: Array[RiftMoteSweepResult] = []
	var blank: RiftMoteSweepResult = RiftMoteSweepResult.refused("x", 1)
	blank.failure_reason = " "
	tampered.append(blank)
	tampered.append(RiftMoteSweepResult.refused("x", -1))
	for field_name: String in ["skipped_count", "attempted_count", "out_of_range_count", "item_refusal_count"]:
		var bad: RiftMoteSweepResult = RiftMoteSweepResult.refused("x", 1)
		bad.set(field_name, 1)
		tampered.append(bad)
	var with_reason: RiftMoteSweepResult = RiftMoteSweepResult.refused("x", 1)
	with_reason.first_item_refusal_reason = "y"
	tampered.append(with_reason)
	var with_indices: RiftMoteSweepResult = RiftMoteSweepResult.completed(1, 0, 0, PackedInt32Array([0]), 0, 0, "")
	with_indices.ok = false
	with_indices.failure_reason = "x"
	tampered.append(with_indices)
	var claims_both: RiftMoteSweepResult = RiftMoteSweepResult.refused("x", 1)
	claims_both.ok = true
	tampered.append(claims_both)
	tampered.append(RiftMoteSweepResult.completed(-1, 0, -1, PackedInt32Array(), -1, 0, ""))
	tampered.append(RiftMoteSweepResult.completed(3, 1, 1, PackedInt32Array([2]), 0, 0, ""))
	tampered.append(RiftMoteSweepResult.completed(3, 0, 3, PackedInt32Array([0]), 1, 0, ""))
	tampered.append(RiftMoteSweepResult.completed(3, 0, 3, PackedInt32Array([2, 1, 0]), 0, 0, ""))
	tampered.append(RiftMoteSweepResult.completed(3, 0, 3, PackedInt32Array([1, 1]), 1, 0, ""))
	tampered.append(RiftMoteSweepResult.completed(3, 0, 3, PackedInt32Array([0, 3]), 1, 0, ""))
	tampered.append(RiftMoteSweepResult.completed(3, 0, 3, PackedInt32Array([-1, 0]), 1, 0, ""))
	tampered.append(RiftMoteSweepResult.completed(3, 0, 3, PackedInt32Array([0]), 1, 1, " "))
	tampered.append(RiftMoteSweepResult.completed(3, 0, 3, PackedInt32Array([0]), 2, 0, "z"))
	var caught: int = 0
	for index: int in tampered.size():
		if not tampered[index].problem().is_empty():
			caught += 1
		else:
			_expect(false, "tampered result %d reads as coherent: %s" % [index, _sweep(tampered[index])])
	_expect(caught == tampered.size(), "%d of %d contradictions caught" % [caught, tampered.size()])
	var controls: int = 0
	for control: RiftMoteSweepResult in [
			RiftMoteSweepResult.refused("x", 0), RiftMoteSweepResult.refused("x", 7),
			RiftMoteSweepResult.completed(0, 0, 0, PackedInt32Array(), 0, 0, ""),
			RiftMoteSweepResult.completed(4, 1, 3, PackedInt32Array([0, 3]), 0, 1, "r")]:
		controls += int(control.problem().is_empty())
	_expect(controls == 4, "%d of 4 coherent controls read as coherent" % controls)

	## NO OBJECT REFERENCE, on a real sweep's answer.
	var field: RiftMoteField = _baseline_field()
	var answer: RiftMoteSweepResult = field.sweep_collection(PLAYER, RiftRunLevelCoordinator.new(OWNER_SEED))
	var references: int = 0
	var fields: PackedStringArray = PackedStringArray()
	for entry: Dictionary in answer.get_property_list():
		if int(entry.get("usage", 0)) & PROPERTY_USAGE_SCRIPT_VARIABLE != 0:
			fields.append(String(entry.get("name", "")))
			if int(entry.get("type", 0)) == TYPE_OBJECT:
				references += 1
	_expect(", ".join(fields) == ", ".join(PackedStringArray(RESULT_FIELDS)), "the result carries: %s" % ", ".join(fields))
	_expect(references == 0, "the result holds %d object references" % references)
	_expect(_signatures_of(RESULT_FILE) == PackedStringArray(RESULT_SIGNATURES),
		"the result declares: %s" % ", ".join(_signatures_of(RESULT_FILE)))
	print("  an assigned packed array is shared in this engine; the value's indices stayed %s after the caller's array and a reading were each changed"
		% built.collected_indices())
	print("  %d of %d contradictions caught by problem(), %d of 4 coherent controls accepted; %d fields, %d object references"
		% [caught, tampered.size(), controls, fields.size(), references])
	_done("the_sweep_result_is_a_coherent_value_whose_indices_are_copies")


# --- 15. Nothing leaks -------------------------------------------------------------------------------------------

func _check_nothing_leaks() -> void:
	print("")
	print("--- 15. No reading hands out a drop, a mote or the drop list")
	var field: RiftMoteField = _baseline_field()
	var script: GDScript = load(FIELD_FILE) as GDScript
	var readings: int = 0
	var objects: PackedStringArray = PackedStringArray()
	var answers_objects: PackedStringArray = PackedStringArray()
	for entry: Dictionary in script.get_script_method_list():
		var name: String = String(entry.get("name", ""))
		if int((entry.get("return", {}) as Dictionary).get("type", 0)) in [TYPE_OBJECT, TYPE_ARRAY]:
			answers_objects.append(name)
		if name == "_init" or not (entry.get("args", []) as Array).is_empty():
			continue
		var value: Variant = field.call(name)
		readings += 1
		if typeof(value) == TYPE_OBJECT or typeof(value) == TYPE_ARRAY:
			objects.append(name)
	_expect(readings == 6 and objects.is_empty(), "%d readings; these answer an object or array: %s" % [readings, ", ".join(objects)])
	_expect(", ".join(answers_objects) == "_init, sweep_collection",
		"these methods declare an object or array answer: %s" % ", ".join(answers_objects))
	var spawned: Variant = field.call("spawn_drop", NEAR_DROP, TEST_MOTE)
	_expect(typeof(spawned) == TYPE_STRING and String(spawned).is_empty(), "spawn_drop answered %s" % str(spawned))
	var swept: Variant = field.call("sweep_collection", PLAYER, RiftRunLevelCoordinator.new(OWNER_SEED))
	_expect(swept is RiftMoteSweepResult and not (swept is RiftMoteDrop), "sweep_collection answered %s" % str(swept))
	print("  %d argument-free readings answer %d objects or arrays; the methods declaring an object answer are %s, and the sweep's is the value checked above"
		% [readings, objects.size(), ", ".join(answers_objects)])
	_done("no_drop_or_mote_can_be_obtained_from_the_field")


# --- 16. Fields and members --------------------------------------------------------------------------------------

func _check_the_fields_and_members() -> void:
	print("")
	print("--- 16. Two private fields, nine methods, no default, and no removal, reset, copy or transfer")
	var field: RiftMoteField = RiftMoteField.new(OWNER_SEED)
	var names: PackedStringArray = _fields_of(field)
	_expect(", ".join(names) == ", ".join(PackedStringArray(FIELD_FIELDS)), "the field carries: %s" % ", ".join(names))
	var types: PackedStringArray = PackedStringArray()
	for entry: Dictionary in field.get_property_list():
		if int(entry.get("usage", 0)) & PROPERTY_USAGE_SCRIPT_VARIABLE != 0:
			types.append("%s:%s%s" % [String(entry.get("name", "")), _type_name(int(entry.get("type", 0))),
				"" if String(entry.get("hint_string", "")).is_empty() else "<%s>" % String(entry.get("hint_string", ""))])
	_expect(", ".join(types) == "_run_seed:int, _drops:Array<RiftMoteDrop>", "the field's fields are typed %s" % ", ".join(types))
	## Two fields, two arrays: a bare typed array is made per field, not shared.
	var other: RiftMoteField = RiftMoteField.new(OWNER_SEED)
	field.spawn_drop(NEAR_DROP, TEST_MOTE)
	_expect(field.drop_count() == 1 and other.drop_count() == 0, "a drop made in one field appeared in another")

	var script: GDScript = load(FIELD_FILE) as GDScript
	var signatures: PackedStringArray = _signatures_of(FIELD_FILE)
	_expect(signatures == PackedStringArray(FIELD_SIGNATURES), "the field declares: %s" % ", ".join(signatures))
	var deferred: PackedStringArray = PackedStringArray()
	for entry: Dictionary in script.get_script_method_list():
		var name: String = String(entry.get("name", ""))
		for token: String in DEFERRED_MEMBER_TOKENS:
			if name.contains(token):
				deferred.append(name)
		for argument: Dictionary in entry.get("args", []):
			if String(argument.get("class_name", "")) == "RiftMoteDrop":
				deferred.append("%s takes a drop" % name)
	_expect(deferred.is_empty(), "these methods remove, reset, copy, transfer or take a drop: %s" % ", ".join(deferred))
	_expect(script.get_script_constant_map().is_empty(), "the field declares constants: %s" % str(script.get_script_constant_map()))
	_expect(script.get_script_signal_list().is_empty(), "the field declares signals")

	var code: String = _code_only(FileAccess.get_file_as_string(FIELD_FILE))
	var top_level: PackedStringArray = PackedStringArray()
	var declared: PackedStringArray = PackedStringArray()
	for line: String in code.split("\n"):
		for opener: String in ["var ", "static ", "const ", "@", "signal ", "enum ", "class "]:
			if line.begins_with(opener):
				if FIELD_DECLARATIONS.has(line):
					declared.append(line)
				else:
					top_level.append(line)
	_expect(declared == PackedStringArray(FIELD_DECLARATIONS) and top_level.is_empty(),
		"the field declares [%s] and [%s]" % [" | ".join(declared), " | ".join(top_level)])
	## The seed is written only by the constructor; the list only by one append. Every
	## assignment to either field, every member called on the list, and every
	## subscript of it, collected from the code.
	var writes: PackedStringArray = PackedStringArray()
	for hit: RegExMatch in RegEx.create_from_string("(_run_seed|_drops)\\s*=[^=]").search_all(code):
		writes.append(hit.get_string().strip_edges())
	var members: Dictionary = {}
	for hit: RegExMatch in RegEx.create_from_string("_drops\\.([a-z_]+)\\(").search_all(code):
		members[hit.get_string(1)] = int(members.get(hit.get_string(1), 0)) + 1
	var subscripts: int = RegEx.create_from_string("_drops\\[").search_all(code).size()
	_expect(", ".join(writes) == "_run_seed =" and code.count("_run_seed = for_run_seed") == 1
			and str(members) == "{ \"append\": 1, \"size\": 8 }"
			and code.count("_drops.append(drop)") == 1 and subscripts == 2
			and code.count("var drop: RiftMoteDrop = _drops[index]") == 2,
		"the fields are written by [%s]; the list is asked %s and subscripted %d times" % [
			" | ".join(writes), str(members), subscripts])
	print("  %d fields (%s), declared bare; the seed written only by the constructor and the list only by one append; %d methods pinned, none defaulting an argument or taking a drop; 0 removal, reset, copy, transfer, teardown, setter or signal members"
		% [names.size(), ", ".join(types), signatures.size()])
	_done("the_field_holds_two_fields_and_no_removal_reset_or_transfer")


# --- 17. The shape -------------------------------------------------------------------------------------------------

func _check_the_shape() -> void:
	print("")
	print("--- 17. The field restates nothing, sorts nothing, and names only what it composes")
	var field_raw: String = FileAccess.get_file_as_string(FIELD_FILE)
	var result_raw: String = FileAccess.get_file_as_string(RESULT_FILE)
	var field_code: String = _code_only(field_raw)
	var result_code: String = _code_only(result_raw)
	_expect(field_raw.length() > 2000 and field_code.length() > 500 and result_raw.length() > 2000 and result_code.length() > 500,
		"the files read as %d / %d and %d / %d characters" % [field_raw.length(), field_code.length(), result_raw.length(), result_code.length()])

	## THE ORDERS, EACH STEP ONCE, EACH GATE RETURNING ON ITS NEXT LINE.
	var ordered: PackedStringArray = PackedStringArray()
	for row: Array in [["func spawn_drop(", SPAWN_ORDER], ["func problem(", PROBLEM_ORDER],
			["func sweep_collection(", SWEEP_ORDER]]:
		var body: PackedStringArray = _method_code(field_code, String(row[0]))
		var previous: int = -1
		for step: String in row[1]:
			var at: int = body.find(step)
			if at <= previous or body.count(step) != 1:
				ordered.append("%s: %s" % [String(row[0]), step])
			previous = at
	_expect(ordered.is_empty(), "steps out of order or repeated: %s" % " | ".join(ordered))
	var returning: int = 0
	for row: Array in RETURNING_GATES:
		var body: PackedStringArray = _method_code(field_code, String(row[0]))
		var at: int = body.find(String(row[1]))
		if at >= 0 and at + 1 < body.size() and body[at + 1].begins_with("return "):
			returning += 1
	_expect(returning == RETURNING_GATES.size(), "%d of %d gates return on their next line" % [returning, RETURNING_GATES.size()])
	var returns: PackedStringArray = PackedStringArray()
	for line: String in field_code.split("\n"):
		if line.strip_edges().begins_with("return "):
			returns.append(line.strip_edges())
	_expect(returns == PackedStringArray(FIELD_RETURNS), "the field returns: %s" % " | ".join(returns))
	_expect(field_code.count("RiftMoteDrop.new(") == 1 and field_code.count(".new(") == 1
			and field_code.count("_drops.append(") == 1 and field_code.count(".attempt_collection(") == 1
			and field_code.count("RiftMoteSweepResult.refused(") == 3 and field_code.count("RiftMoteSweepResult.completed(") == 1
			and field_code.count("problem()") == 4,
		"the field asks its mechanisms the wrong number of times")

	## ARITHMETIC: counting only. `+` only as the five `+= 1` counters, one derived
	## subtraction; the result's three sums of its own counts; `%` only formatting.
	var hits: PackedStringArray = PackedStringArray()
	for row: Array in [["field", field_code, 5, 1, ["0", "1"]], ["result", result_code, 3, 1, ["0", "1"]]]:
		var bare: String = RegEx.create_from_string("\"([^\"\\\\]|\\\\.)*\"").sub(String(row[1]), "\"\"", true)
		for operator: String in ["*", "/", "&", "|", "^", "<<", ">>"]:
			if bare.contains(operator):
				hits.append("%s: %s" % [String(row[0]), operator])
		if bare.count("+") != int(row[2]):
			hits.append("%s: %d '+'" % [String(row[0]), bare.count("+")])
		if bare.replace("->", "").count("-") != int(row[3]):
			hits.append("%s: %d '-'" % [String(row[0]), bare.replace("->", "").count("-")])
		var formats: int = RegEx.create_from_string("\"\"\\s*%").search_all(bare).size()
		if bare.count("%") != formats:
			hits.append("%s: %% outside formatting" % String(row[0]))
		var literals: PackedStringArray = _numeric_literals(String(row[1]))
		if literals != PackedStringArray(row[4]):
			hits.append("%s: literals %s" % [String(row[0]), str(literals)])
	_expect(field_code.count("+= 1") == 5, "the field counts with %d increments" % field_code.count("+= 1"))
	for token: String in FORBIDDEN_TOKENS + AMBIENT_TOKENS:
		if field_raw.contains(token):
			hits.append("field: %s" % token)
		if result_raw.contains(token):
			hits.append("result: %s" % token)
	for token: String in RESTATEMENT_TOKENS + ["duplicate"]:
		if field_code.contains(token):
			hits.append("field code: %s" % token)
	for token: String in RESTATEMENT_TOKENS:
		if result_code.contains(token):
			hits.append("result code: %s" % token)
	_expect(result_code.count(".duplicate()") == 2, "the result copies its indices %d times" % result_code.count(".duplicate()"))
	var loops: PackedStringArray = PackedStringArray()
	for line: String in field_code.split("\n") + result_code.split("\n"):
		var stripped: String = line.strip_edges()
		if stripped.begins_with("for ") or stripped.begins_with("while ") or stripped.begins_with("match "):
			loops.append(stripped)
	_expect(", ".join(loops) == "for drop: RiftMoteDrop in _drops:, for index: int in _drops.size():, for index: int in _drops.size():, for index: int in _collected_indices:",
		"the loops are: %s" % " | ".join(loops))
	_expect(hits.is_empty(), "H5 names or does: %s" % ", ".join(hits))

	## PER-FILE CLASS ALLOWLIST FROM THE ENGINE'S OWN CLASS LIST, BOTH DIRECTIONS.
	var all_classes: PackedStringArray = PackedStringArray()
	for entry: Dictionary in ProjectSettings.get_global_class_list():
		all_classes.append(String(entry.get("class", "")))
	_expect(all_classes.size() > 100 and all_classes.has(FIELD_CLASS) and all_classes.has(RESULT_CLASS),
		"%d project classes were enumerated" % all_classes.size())
	var overlaps: PackedStringArray = PackedStringArray()
	for own: String in [FIELD_CLASS, RESULT_CLASS]:
		for class_id: String in all_classes:
			if class_id != own and (class_id.contains(own) or own.contains(class_id)):
				overlaps.append("%s / %s" % [own, class_id])
	_expect(overlaps.is_empty(), "H5's class names overlap: %s" % ", ".join(overlaps))
	var misnamed: PackedStringArray = PackedStringArray()
	for row: Array in [["field", field_raw, FIELD_NAMES], ["result", result_raw, RESULT_NAMES]]:
		for class_id: String in all_classes:
			var named: bool = String(row[1]).contains(class_id)
			if named != (row[2] as Array).has(class_id):
				misnamed.append("%s %s %s" % [String(row[0]), "names" if named else "does not name", class_id])
	_expect(misnamed.is_empty(), "the allowlist does not hold: %s" % ", ".join(misnamed))
	print("  %d spawn, %d validity and %d sweep steps in order, each once; %d gates each return on the next line; %d return lines pinned, none handing out a drop or the list"
		% [SPAWN_ORDER.size(), PROBLEM_ORDER.size(), SWEEP_ORDER.size(), returning, returns.size()])
	print("  %d hits for distance or radius formulas, percentages, experience arithmetic, requirements, offer seeds, content, sorting, removal, nodes, signals, scenes, physics or files; literals %s in the field and %s in the result"
		% [hits.size(), str(_numeric_literals(field_code)), str(_numeric_literals(result_code))])
	print("  the field names only %s; the result names only %s; their names overlap %d other class names; %d project classes read"
		% [", ".join(PackedStringArray(FIELD_NAMES)), ", ".join(PackedStringArray(RESULT_NAMES)), overlaps.size(), all_classes.size()])
	_done("the_field_restates_nothing_and_names_only_what_it_composes")


# --- 18. Unwired ---------------------------------------------------------------------------------------------------

func _check_nothing_runs_it() -> void:
	print("")
	print("--- 18. Nothing that runs creates or sweeps a field, and scripts/pickups/ holds seven scripts")
	var project_files: int = 0
	var referenced: PackedStringArray = PackedStringArray()
	for root: String in SCANNED_ROOTS:
		for path: String in _files_under(root, [".gd", ".tscn", ".tres"]):
			if H5_FILES.has(path):
				continue
			project_files += 1
			var text: String = FileAccess.get_file_as_string(path)
			for token: String in UNWIRED_TOKENS:
				if text.contains(token) and not _reader_may_name(path, token):
					referenced.append("%s names %s" % [path.get_file(), token])
	var result_raw: String = FileAccess.get_file_as_string(RESULT_FILE)
	for token: String in UNWIRED_TOKENS:
		if token != RESULT_CLASS and result_raw.contains(token):
			referenced.append("the result names %s" % token)
	var settings: String = FileAccess.get_file_as_string(PROJECT_SETTINGS_FILE)
	for token: String in UNWIRED_TOKENS:
		if settings.contains(token):
			referenced.append("project.godot names %s" % token)
	_expect(referenced.is_empty(), "something that runs creates or sweeps a field: %s" % ", ".join(referenced))
	_expect(project_files > 100, "only %d project files were scanned" % project_files)
	_expect(not settings.contains("[autoload]"), "project.godot declares an [autoload] section")
	_expect(String(ProjectSettings.get_setting("application/run/main_scene", ""))
			== "res://scenes/app/prototype_app.tscn",
		"the entrypoint moved")
	var actions: int = 0
	for action: StringName in InputMap.get_actions():
		if String(action).begins_with("ui_") and not String(action) in ["ui_confirm", "ui_cancel"]:
			continue
		actions += 1
	_expect(actions == 31, "the InputMap holds %d project actions, not 31" % actions)

	var pickup_scripts: PackedStringArray = _files_under("res://scripts/pickups", [".gd"])
	pickup_scripts.sort()
	_expect(pickup_scripts == PackedStringArray(PICKUP_SCRIPTS), "scripts/pickups/ holds: %s" % ", ".join(pickup_scripts))
	print("  %d unauthorized project files create, fill or sweep a field (%d readers granted by file and token); scripts/pickups/ holds %d scripts; %d actions; %d files scanned"
		% [referenced.size(), AUTHORIZED_READERS.size(), pickup_scripts.size(), actions, project_files])
	print("  %d whole-sweep refusals and %d completed sweeps collecting %d drops were asserted across this suite"
		% [_whole_refusals, _completed_sweeps, _collected])
	_done("nothing_that_runs_creates_or_sweeps_a_field_and_the_directory_holds_seven_scripts")


## Whether `path` is granted `token` in `AUTHORIZED_READERS`.
func _reader_may_name(path: String, token: String) -> bool:
	for row: Array in AUTHORIZED_READERS:
		if String(row[0]) == path:
			return (row[1] as Array).has(token)
	return false


# --- Fixtures ---------------------------------------------------------------------------------------------

## The field's ownership refusal, typed here from the two seeds' exact spellings.
func _ownership_sentence(field_seed: String, run_seed: String) -> String:
	return "this Experience Mote field belongs to run seed " + field_seed + ", not to run seed " + run_seed \
		+ "; it may be swept only into the run that dropped its motes"


func _baseline_field() -> RiftMoteField:
	var field: RiftMoteField = RiftMoteField.new(OWNER_SEED)
	for row: Array in BASELINE_LAYOUT:
		_expect(field.spawn_drop(row[1], TEST_MOTE).is_empty(), "the baseline drop at %s was refused" % String(row[0]))
	return field


## The grid's positions, in insertion order: columns along x, rows along z, every
## component a multiple of 0.5 m so each is held exactly.
func _grid_positions() -> Array[Vector3]:
	var out: Array[Vector3] = []
	for row: int in GRID_ROWS:
		for column: int in GRID_COLUMNS:
			out.append(Vector3(float(column) * 0.5 - 5.0, 0.0, float(row) * 0.5 - 3.0))
	return out


func _grid_field() -> RiftMoteField:
	var field: RiftMoteField = RiftMoteField.new(GRID_SEED)
	for place: Vector3 in _grid_positions():
		field.spawn_drop(place, TEST_MOTE)
	return field


func _open(run: RiftRunLevelCoordinator) -> String:
	return run.open_current_offer(
		SkillSupportCatalogue.skill_profiles(),
		SkillSupportCatalogue.support_definitions(),
		PassiveCardCatalogue.records()
	)


## A run at level 1 holding exactly its requirement and a standing offer, reached
## through the run's own public award and open — used only for runs no field under
## test is swept into for collection.
func _run_with_an_open_offer(for_seed: int) -> RiftRunLevelCoordinator:
	var run: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(for_seed)
	_expect_accepted(run.award_experience(FIRST_REQUIREMENT), "the offer fixture's award")
	_expect_accepted(_open(run), "the offer fixture's open")
	_expect(run.is_offer_active() and run.level() == 1, "the offer fixture did not open: %s" % _snapshot(run))
	return run


## The run's current lifecycle, READ by name — never written.
func _lifecycle_of(run: RiftRunLevelCoordinator) -> RiftLevelUpCoordinator:
	return run.get("_current") as RiftLevelUpCoordinator


# --- Assertions -------------------------------------------------------------------------------------------

func _expect_accepted(refusal: String, described: String) -> void:
	_expect(refusal.is_empty(), "%s was refused: %s" % [described, refusal])


func _expect_completed(result: RiftMoteSweepResult, described: String) -> void:
	_completed_sweeps += 1
	_expect(result.ok and result.failure_reason.is_empty(), "%s was not completed: %s" % [described, result.describe()])
	_expect(result.problem().is_empty(), "%s is incoherent: %s" % [described, result.problem()])
	_collected += result.collected_count()


## A whole-sweep refusal must carry a reason, the stored count, and NOTHING counted.
func _expect_whole_refusal(result: RiftMoteSweepResult, described: String, stored: int) -> void:
	_whole_refusals += 1
	_expect(not result.ok and not result.failure_reason.strip_edges().is_empty(),
		"%s was not refused whole: %s" % [described, result.describe()])
	_expect(result.problem().is_empty(), "%s is an incoherent refusal: %s" % [described, result.problem()])
	_expect(result.total_count == stored and result.skipped_count == 0 and result.attempted_count == 0
			and result.collected_indices().is_empty() and result.collected_count() == 0
			and result.out_of_range_count == 0 and result.item_refusal_count == 0
			and result.first_item_refusal_reason.is_empty(),
		"%s carries a partial sweep: %s" % [described, _sweep(result)])


# --- Snapshots -----------------------------------------------------------------------------------------------

## THE WHOLE RUN AS ONE LINE: the seed, the level, the experience to seventeen
## places, the offer's whole identity, the frozen requirement, the current
## requirement, every pair's rank, every card's count and identity, and the ledger.
func _snapshot(run: RiftRunLevelCoordinator) -> String:
	var lanes: PackedStringArray = PackedStringArray()
	for lane: int in run.offer_lanes():
		lanes.append("%d:%s" % [lane, " -> ".join(run.offer_identity_for(lane))])
	var build: RiftRunBuild = run.run_build()
	var ranks: PackedStringArray = PackedStringArray()
	for pair: String in build.support_pairs():
		var parts: PackedStringArray = pair.split(" -> ")
		ranks.append("%s@%d" % [pair, build.support_rank_for(StringName(parts[0]), StringName(parts[1]))])
	var cards: PackedStringArray = PackedStringArray()
	for card_id: StringName in build.acquired_card_ids():
		cards.append("%s x%d {%s}" % [
			card_id, build.acquisitions_for(card_id), build.mechanical_identity_for(card_id)])
	return "seed=%d level=%d experience=%s offer=%s root=%d frozen=%s lanes=[%s] needs=%s | ranks [%s] | cards [%s] | seeds %s" % [
		run.run_seed(), run.level(), _exact(run.experience()), str(run.is_offer_active()),
		run.offer_root_seed(), _exact(run.frozen_requirement()), ", ".join(lanes),
		run.requirement_reading().describe(), ", ".join(ranks), ", ".join(cards),
		str(run.consumption_ledger().consumed_seeds()),
	]


func _field(field: RiftMoteField) -> String:
	return "seed=%d drops=%d collected=%d uncollected=%d problem='%s'" % [
		field.run_seed(), field.drop_count(), field.collected_count(), field.uncollected_count(), field.problem()]


func _sweep(result: RiftMoteSweepResult) -> String:
	return "ok=%s reason='%s' total=%d skipped=%d attempted=%d collected=%s out=%d refused=%d first='%s'" % [
		str(result.ok), result.failure_reason, result.total_count, result.skipped_count, result.attempted_count,
		result.collected_indices(), result.out_of_range_count, result.item_refusal_count, result.first_item_refusal_reason,
	]


func _exact(value: float) -> String:
	if is_nan(value) or is_inf(value) or absf(value) >= 1.0e17 or (value != 0.0 and absf(value) < 1.0e-6):
		return String.num_scientific(value)
	return String.num(value, 17)


# --- Source reading ------------------------------------------------------------------------------------------

func _code_only(source: String) -> String:
	var out: PackedStringArray = PackedStringArray()
	for line: String in source.split("\n"):
		if line.strip_edges().begins_with("#"):
			continue
		out.append(line)
	return "\n".join(out)


## The non-blank, stripped code lines of one method, from its declaration to the
## next declaration.
func _method_code(code: String, declaration: String) -> PackedStringArray:
	var out: PackedStringArray = PackedStringArray()
	var start: int = code.find(declaration)
	if start < 0:
		return out
	var end: int = code.length()
	for marker: String in ["\nfunc ", "\nstatic func ", "\nclass "]:
		var next: int = code.find(marker, start + 1)
		if next >= 0 and next < end:
			end = next
	for line: String in code.substr(start, end - start).split("\n"):
		if not line.strip_edges().is_empty():
			out.append(line.strip_edges())
	return out


## Every numeric literal in code OUTSIDE string literals, deduplicated and sorted.
func _numeric_literals(code: String) -> PackedStringArray:
	var without_strings: String = RegEx.create_from_string("\"([^\"\\\\]|\\\\.)*\"").sub(code, "\"\"", true)
	var found: Dictionary = {}
	var number: RegEx = RegEx.create_from_string("(?<![A-Za-z0-9_.])[0-9][0-9_.]*(?![A-Za-z0-9_])")
	for hit: RegExMatch in number.search_all(without_strings):
		found[hit.get_string()] = true
	var out: PackedStringArray = PackedStringArray()
	for key: Variant in found:
		out.append(String(key))
	out.sort()
	return out


## Every method as `name(arg: Type, ...) -> Type`, in declaration order — the same
## rendering the accepted H1–H4 and G4 pins use.
func _signatures_of(path: String) -> PackedStringArray:
	var out: PackedStringArray = PackedStringArray()
	var script: GDScript = load(path) as GDScript
	if script == null:
		return out
	for entry: Dictionary in script.get_script_method_list():
		var args: PackedStringArray = PackedStringArray()
		for argument: Dictionary in entry.get("args", []):
			args.append("%s: %s" % [
				String(argument.get("name", "")),
				_type_name(int(argument.get("type", 0))),
			])
		var returns: Dictionary = entry.get("return", {}) as Dictionary
		out.append("%s(%s) -> %s" % [
			String(entry.get("name", "")), ", ".join(args),
			_type_name(int(returns.get("type", 0))),
		])
	return out


func _type_name(type_id: int) -> String:
	match type_id:
		TYPE_NIL:
			return "void"
		TYPE_BOOL:
			return "bool"
		TYPE_INT:
			return "int"
		TYPE_FLOAT:
			return "float"
		TYPE_STRING:
			return "String"
		TYPE_VECTOR3:
			return "Vector3"
		TYPE_OBJECT:
			return "Object"
		TYPE_ARRAY:
			return "Array"
		TYPE_PACKED_INT32_ARRAY:
			return "PackedInt32Array"
		_:
			return "type %d" % type_id


func _fields_of(instance: Object) -> PackedStringArray:
	var out: PackedStringArray = PackedStringArray()
	for entry: Dictionary in instance.get_property_list():
		if int(entry.get("usage", 0)) & PROPERTY_USAGE_SCRIPT_VARIABLE != 0:
			out.append(String(entry.get("name", "")))
	return out


func _files_under(root: String, extensions: Array[String]) -> PackedStringArray:
	var out: PackedStringArray = PackedStringArray()
	var dir: DirAccess = DirAccess.open(root)
	if dir == null:
		return out
	dir.list_dir_begin()
	var entry: String = dir.get_next()
	while not entry.is_empty():
		if entry != "." and entry != "..":
			var full: String = root.path_join(entry)
			if dir.current_is_dir():
				out.append_array(_files_under(full, extensions))
			else:
				for extension: String in extensions:
					if entry.ends_with(extension):
						out.append(full)
						break
		entry = dir.get_next()
	dir.list_dir_end()
	return out


# --- The owed set -----------------------------------------------------------------------------------------------

func _check_every_check_ran() -> void:
	print("")
	print("--- Every check this suite owes actually reached its last line")
	var missing: PackedStringArray = PackedStringArray()
	for owed: String in OWED_CHECKS:
		if not _reached.has(owed):
			missing.append(owed)
	var extra: PackedStringArray = PackedStringArray()
	for ran: Variant in _reached:
		if not OWED_CHECKS.has(String(ran)):
			extra.append(String(ran))
	_expect(missing.is_empty(), "check(s) never completed: %s" % ", ".join(missing))
	_expect(extra.is_empty(), "check(s) ran that the suite does not owe: %s" % ", ".join(extra))
	print("  %d of %d owed checks completed" % [_reached.size(), OWED_CHECKS.size()])


func _expect(condition: bool, failure_message: String) -> void:
	_checks += 1
	if not condition:
		_failures.append(failure_message)


func _done(check_name: String) -> void:
	_reached[check_name] = true
