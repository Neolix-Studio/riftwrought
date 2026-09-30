extends SceneTree
## Riftwrought — Roguelite Foundation H6 verification: the run-owned, one-time
## Experience Mote emission of one defeated enemy.
##
## ONE FOCUSED HEADLESS TEST. Foundation H6 is one pure-logic script under
## `scripts/experience/` — the record of the one Experience Mote reward one future
## enemy owns, which emits exactly one drop into the mote field of its own run, and
## only once. It runs as a `SceneTree` script exactly as every earlier foundation
## suite does.
##
## IT PORTS D-211's OWED-SET DISCIPLINE. Every check function records reaching its
## LAST line, and the suite compares that set against what it owes in BOTH
## directions, so a check that dies half way cannot leave a green run behind it.
##
## THE HARNESS NEVER EMITS FOR AN EMISSION, AND WRITES NO PRIVATE STATE. Every drop
## an emission is credited with was made by that emission's own `emit_at()`. The
## harness makes drops directly through the field's public `spawn_drop()` only for
## CONTROL and TWIN fields, and for the prior entries a field already held before
## an emission arrived; it collects only through the field's own public sweep; and
## it reads no private member and writes none — of an emission, a field, a drop or
## a run.
##
## EVERY EXPECTED ANSWER IS EITHER A TYPED LITERAL OR THE ACCEPTED MECHANISM'S OWN
## ANSWER, asked directly with the same inputs — H1's own `problem()` for an amount,
## a control field's own `spawn_drop()` for a position, and a twin field's own sweep
## for what an emitted drop is worth and exactly where it lies. Never a rule or an
## amount this file restated for the emission.
##
## THE VALUES 25, 0.1, 7.5, 12.5, 17.5, 5e-324 AND 1.7e+308 ARE TEST EVIDENCE ONLY.
## None is an enemy-experience value, and nothing here decides one.
##
## IT READS NO OTHER SUITE. It names no file under `tests/` but its own, which the
## runner asserts.

# --- The files ----------------------------------------------------------------------

const EMISSION_FILE: String = "res://scripts/experience/rift_enemy_mote_emission.gd"
const THIS_FILE: String = "res://tests/rift_enemy_mote_emission_verification.gd"

const EMISSION_CLASS: String = "RiftEnemyMoteEmission"

## `scripts/experience/` after H6: E1's two scripts, H1's mote and H6's emission.
## D-283: Foundation H7's Graveblade mote binding shares the directory.
## D-286: so does Foundation H8's Experience Mote runtime, which names no emission.
const EXPERIENCE_SCRIPTS: Array[String] = [
	"res://scripts/experience/rift_enemy_mote_emission.gd",
	"res://scripts/experience/rift_experience_mote.gd",
	"res://scripts/experience/rift_experience_reading.gd",
	"res://scripts/experience/rift_experience_track.gd",
	"res://scripts/experience/rift_graveblade_mote_binding.gd",
	"res://scripts/experience/rift_mote_runtime.gd",
]

const SCANNED_ROOTS: Array[String] = [
	"res://scripts", "res://scenes", "res://data", "res://addons",
]
const PROJECT_SETTINGS_FILE: String = "res://project.godot"

## Everything that would mean something that runs creates an emission or emits one.
const UNWIRED_TOKENS: Array[String] = [
	"RiftEnemyMoteEmission", "rift_enemy_mote_emission", "emit_at(",
]

## THE ONLY FILES OTHER THAN THE EMISSION THAT MAY NAME AN UNWIRED TOKEN, PER FILE AND
## PER TOKEN. D-283: Foundation H7's Graveblade mote binding makes one emission for
## the one Graveblade it is bound to and, when that Graveblade dies, asks it to emit
## once — so it is granted the emission's class and the emitting call, and never the
## emission's file name. Nothing that runs creates a binding. This replaces the
## blanket "no other file" one for one: the same single assertion is made either
## way, and the pinned count does not move.
const AUTHORIZED_READERS: Array = [
	["res://scripts/experience/rift_graveblade_mote_binding.gd", ["RiftEnemyMoteEmission", "emit_at("]],
]

## THE ONLY PROJECT CLASSES THE EMISSION MAY NAME, and it must name all three:
## itself, the mote whose own rule validates its amount (H1), and the field it emits
## into (H5). Checked against the engine's own global class list in both
## directions — the drop, the attempt, the pickup query, the sweep's result, the
## run, its lifecycle, the track, the build and every stat, card and enemy class
## are refused.
const EMISSION_NAMES: Array[String] = ["RiftEnemyMoteEmission", "RiftExperienceMote", "RiftMoteField"]

## Every method, in declaration order, with its full signature. The engine reports
## a constructor's return as an object, whatever the source declares.
const EMISSION_SIGNATURES: Array[String] = [
	"_init(for_run_seed: int, for_base_experience: float) -> Object",
	"run_seed() -> int",
	"base_experience() -> float",
	"is_emitted() -> bool",
	"problem() -> String",
	"emit_at(defeat_position: Vector3, field: Object) -> String",
	"describe() -> String",
]

## THE EMISSION'S WHOLE STATE: THREE PRIVATE FIELDS AND NO FOURTH.
const EMISSION_FIELDS: Array[String] = ["_run_seed", "_base_experience", "_emitted"]
const EMISSION_TYPES: Array[int] = [TYPE_INT, TYPE_FLOAT, TYPE_BOOL]
const EMISSION_DECLARATIONS: Array[String] = [
	"var _run_seed: int",
	"var _base_experience: float",
	"var _emitted: bool = false",
]

## The ONLY writes to a field anywhere in the file, in source order.
const EMISSION_WRITES: Array[String] = [
	"_run_seed = for_run_seed",
	"_base_experience = for_base_experience",
	"_emitted = true",
]

## THE EMISSION ORDER, AS THE CODE MUST SPELL IT, first occurrence to first
## occurrence inside `emit_at()`, each step exactly once.
const EMIT_ORDER: Array[String] = [
	"if _emitted:",
	"return \"this enemy's Experience Mote has already been emitted; it emits nothing again\"",
	"var invalid: String = problem()",
	"if not invalid.is_empty():",
	"return invalid",
	"if field == null:",
	"return \"an enemy's Experience Mote must be emitted into a mote field, and none was given\"",
	"var incoherent: String = field.problem()",
	"if not incoherent.is_empty():",
	"return incoherent",
	"if field.run_seed() != _run_seed:",
	"var refusal: String = field.spawn_drop(defeat_position, _base_experience)",
	"if not refusal.is_empty():",
	"return refusal",
	"_emitted = true",
	"return \"\"",
]

## Every gate in `emit_at()`, each of which must return on its very next line.
const RETURNING_GATES: Array[String] = [
	"if _emitted:", "if not invalid.is_empty():", "if field == null:",
	"if not incoherent.is_empty():", "if field.run_seed() != _run_seed:", "if not refusal.is_empty():",
]

## EVERY `return` IN THE FILE, EXACTLY. None hands out a mote, a drop or the field.
const EMISSION_RETURNS: Array[String] = [
	"return _run_seed",
	"return _base_experience",
	"return _emitted",
	"return RiftExperienceMote.new(_base_experience).problem()",
	"return \"this enemy's Experience Mote has already been emitted; it emits nothing again\"",
	"return invalid",
	"return \"an enemy's Experience Mote must be emitted into a mote field, and none was given\"",
	"return incoherent",
	"return \"this enemy's Experience Mote belongs to run seed %d, not to the mote field's run seed %d; it may be emitted only into a field of its own run\" % [",
	"return refusal",
	"return \"\"",
	"return \"Enemy Experience Mote emission of run seed %d, worth %s base experience; %s\" % [",
]

## The only members of the field the emission may ask, with how often each is
## called.
const FIELD_CALLS: Array = [["problem", 1], ["run_seed", 2], ["spawn_drop", 1]]

## Enemy content and its experience balance. No production value here names an
## enemy, a family or an experience amount. Scanned RAW, comments included.
const ENEMY_TOKENS: Array[String] = [
	"Graveblade", "graveblade", "GRAVEBLADE", "Vanguard", "vanguard", "VANGUARD",
	"Skeleton", "Mauler", "Marrowshot", "Tombknife", "Acolyte", "Cantor", "Warden",
	"Ossuary", "Elite", "Guardian", "XP",
]

## The project's OTHER experience concepts, and every other foundation's classes,
## files and members this one is not granted. Scanned RAW over the emission,
## comments included — D-215's lesson.
const FORBIDDEN_TOKENS: Array[String] = [
	"ExperienceTable", "experience_table", "CharacterState", "LabProgress",
	"progression", "quick_strike", "died", ".tres", ".tscn", "scenes/", "res://",
	"rift_experience_mote", "collect_into", "RiftMoteDrop", "rift_mote_drop",
	"attempt_collection", "RiftMoteCollection", "rift_mote_collection",
	"RiftMotePickup", "rift_mote_pickup", "rift_mote_field", "RiftMoteSweepResult",
	"rift_mote_sweep_result", "sweep_collection", "RiftRunLevelCoordinator",
	"RiftRunLevelUpResult", "RiftLevelUp", "RiftExperienceTrack", "RiftExperienceReading",
	"award_experience", "open_current_offer", "choose(", "next_level_coordinator",
	"RiftRunBuild", "PlayerStat", "PassiveCard", "card_", "EXPERIENCE_GAIN",
	"experience_gain", "PICKUP_RADIUS", "pickup_radius", "RiftOffer",
	"RiftLevelRequirement", "requirement_for", "RiftLevelOfferSeed", "offer_root_seed",
	"RiftConsumptionLedger",
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

## What the emission may not do, as tokens over CODE lines only: restate the
## amount or position rule, mask or fold a seed, measure, hold a collection, sort,
## remove, listen, signal, or ask any further step of the field or the run.
const RESTATEMENT_TOKENS: Array[String] = [
	"is_finite", "is_nan", "is_inf", "is_zero", "> 0", "<= 0", "< 0", "sqrt(", "abs(",
	"pow(", "min(", "max(", "clamp", "snapped", "round", "floor", "ceil", ".x", ".y",
	".z", "distance", "radius", "mask", "hash(", "Dictionary", "Array", "Packed",
	"set(", "get(", "setget", "duplicate", "free(", "sort", "erase", "remove", "clear(",
	"append", "signal", "emit_signal", ".emit(", "connect(", "await", "_process",
	"Node", "sweep", "collect", "award", "drop_count", "for ", "while ", "match ",
	"static", "const ", "enum ",
]

## Words that would mean an emission can be reset, re-armed, copied, transferred,
## stored, listened to or given a second payload — none may appear in a method name.
const DEFERRED_MEMBER_TOKENS: Array[String] = [
	"reset", "rearm", "arm", "copy", "clone", "duplicate", "transfer", "set_", "save",
	"load", "persist", "free", "enemy", "drop", "mote", "field", "result", "clear",
	"undo", "sweep", "collect", "award", "spawn", "attach", "connect", "listen",
	"position", "validator", "retry",
]

# --- The fixtures, stated independently -----------------------------------------------

## Test evidence only.
const TEST_MOTE: float = 25.0
const FIRST_REQUIREMENT: float = 100.0

## Amounts H1 accepts, each of which must arrive exactly. The smallest positive
## double joins them at run time, built by halving: this engine parses its literal
## as zero, which D-246 measured.
const KEPT_AMOUNTS: Array[float] = [25.0, 0.1, 1.7e308]

const UNUSABLE_BASES: Array = [
	["zero", 0.0], ["negative", -25.0], ["not a number", NAN],
	["positive infinity", INF], ["negative infinity", -INF],
]

## An ordinary owning run and one run that does not own the emission.
const OWNER_SEED: int = 99
const STRANGER_SEED: int = 100

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

## A player away from the origin and off the ground, and defeat positions measured
## from them on the ground plane. The spacing of this engine's world-position
## components between 2 m and 4 m is 2^-22 m.
const PLAYER: Vector3 = Vector3(10.0, 0.5, -6.0)
const DEFEAT: Vector3 = Vector3(10.0, 0.5, -4.5)
const WITHIN: Vector3 = Vector3(10.0, 0.5, -3.5 - 1.0 / 4194304.0)
const BEYOND: Vector3 = Vector3(10.0, 0.5, -3.5 + 1.0 / 4194304.0)
const FAR: Vector3 = Vector3(40.0, 0.5, -6.0)

## The entries a field already holds before an emission arrives, in insertion order:
## a label, a position measured from PLAYER, and an amount.
const PRIOR_LAYOUT: Array = [
	["1.5 m", Vector3(10.0, 0.5, -4.5), 7.5],
	["3.0 m", Vector3(13.0, 0.5, -6.0), 12.5],
	["4.0 m", Vector3(10.0, 0.5, -10.0), 17.5],
]

## The accepted and new wordings this suite quotes, typed independently.
const ALREADY_EMITTED: String = "this enemy's Experience Mote has already been emitted; it emits nothing again"
const NO_FIELD: String = "an enemy's Experience Mote must be emitted into a mote field, and none was given"
const POSITION_REFUSAL_EXAMPLE: String = "an Experience Mote drop's position must have a finite x, y and z, not (nan, 0.0, 0.0)"

const OWED_CHECKS: Array[String] = [
	"a_new_emission_reports_its_exact_seed_and_amount_and_has_not_emitted",
	"emitting_into_a_matching_empty_field_appends_exactly_one_drop",
	"emission_awards_nothing_opens_nothing_and_advances_nothing",
	"a_later_sweep_collects_the_emitted_drop_and_awards_the_exact_amount",
	"a_second_emission_is_refused_first_and_adds_no_drop",
	"two_emissions_each_append_one_drop_to_one_field",
	"a_missing_field_is_refused_and_the_emission_stays_available",
	"an_invalid_spawn_passes_the_fields_reason_through_and_a_retry_emits_once",
	"an_invalid_amount_passes_h1s_reason_through_and_never_emits",
	"a_wrong_run_field_is_refused_before_spawning_and_the_right_field_still_receives_it",
	"seeds_agreeing_in_their_low_32_bits_are_different_owners",
	"prior_drops_keep_their_entries_and_order_and_the_new_drop_lands_last",
	"neither_the_validator_nor_the_drop_can_be_obtained",
	"the_emission_holds_three_fields_and_its_order_is_pinned",
	"the_emission_restates_nothing_and_names_no_enemy_content",
	"nothing_that_runs_creates_an_emission_and_the_directory_holds_six_scripts",
]

var _failures: PackedStringArray = PackedStringArray()
var _checks: int = 0
var _reached: Dictionary = {}
var _refusals: int = 0
var _emissions: int = 0


func _initialize() -> void:
	print("")
	print("=== Roguelite Foundation H6 — Run-Owned One-Time Enemy Mote Emission (D-281) ===")

	_check_a_new_emission()
	_check_a_matching_empty_field()
	_check_emission_awards_nothing()
	_check_a_later_sweep()
	_check_a_second_emission()
	_check_two_emissions()
	_check_a_missing_field()
	_check_an_invalid_spawn()
	_check_an_invalid_amount()
	_check_a_wrong_run()
	_check_low_32_bit_owners()
	_check_prior_drops()
	_check_nothing_leaks()
	_check_the_fields_and_order()
	_check_the_shape()
	_check_nothing_runs_it()

	_check_every_check_ran()

	print("")
	if _failures.is_empty():
		print("RIFT ENEMY MOTE EMISSION VERIFICATION: PASS (%d checks)" % _checks)
		quit(0)
	else:
		for failure: String in _failures:
			printerr("  FAIL: %s" % failure)
		printerr("RIFT ENEMY MOTE EMISSION VERIFICATION: %d FAILURE(S) of %d checks" % [
			_failures.size(), _checks,
		])
		quit(1)


# --- 1. A new emission ---------------------------------------------------------------------------

func _check_a_new_emission() -> void:
	print("")
	print("--- 1. A new emission needs an explicit signed run seed and amount, reads both back exactly, and has not emitted")
	var script: GDScript = load(EMISSION_FILE) as GDScript
	var constructor_args: int = -1
	var defaults: PackedStringArray = PackedStringArray()
	for entry: Dictionary in script.get_script_method_list():
		if String(entry.get("name", "")) == "_init":
			constructor_args = (entry.get("args", []) as Array).size()
		if not (entry.get("default_args", []) as Array).is_empty():
			defaults.append(String(entry.get("name", "")))
	_expect(constructor_args == 2 and defaults.is_empty(),
		"the constructor takes %d arguments; these methods default one: %s" % [constructor_args, ", ".join(defaults)])

	var amounts: Array[float] = _kept_amounts()
	_expect(amounts.size() == 4 and amounts[2] > 0.0 and amounts[2] / 2.0 == 0.0,
		"the halving did not reach the smallest positive double: %s" % str(amounts))
	var exact: int = 0
	var made: int = 0
	for row: Array in SEED_FAMILIES:
		for amount: float in amounts:
			made += 1
			var emission: RiftEnemyMoteEmission = RiftEnemyMoteEmission.new(int(row[0]), amount)
			if emission.run_seed() == int(row[0]) and str(emission.run_seed()) == String(row[1]) \
					and emission.base_experience() == amount and not emission.is_emitted() \
					and emission.problem().is_empty():
				exact += 1
	_expect(exact == made and made == SEED_FAMILIES.size() * amounts.size(),
		"%d of %d emissions read back their exact seed and amount unemitted and valid" % [exact, made])
	var one: RiftEnemyMoteEmission = RiftEnemyMoteEmission.new(OWNER_SEED, TEST_MOTE)
	_expect(one.describe().contains("run seed 99") and one.describe().ends_with("not emitted"),
		"a fresh emission describes itself as: %s" % one.describe())
	print("  the constructor takes %d arguments and no method defaults one; %d of %d emissions over %d seeds and %d amounts read back their exact seed and amount; none has emitted"
		% [constructor_args, exact, made, SEED_FAMILIES.size(), amounts.size()])
	print("  %s" % one.describe())
	_done("a_new_emission_reports_its_exact_seed_and_amount_and_has_not_emitted")


# --- 2. A matching empty field -------------------------------------------------------------------

func _check_a_matching_empty_field() -> void:
	print("")
	print("--- 2. Emitting into a matching empty field appends exactly one drop, and only then marks the emission emitted")
	var field: RiftMoteField = RiftMoteField.new(OWNER_SEED)
	var emission: RiftEnemyMoteEmission = RiftEnemyMoteEmission.new(OWNER_SEED, TEST_MOTE)
	_expect(field.drop_count() == 0 and not emission.is_emitted(), "the fixture did not start empty: %s" % _field(field))
	var answer: String = emission.emit_at(DEFEAT, field)
	_expect_emitted(answer, emission, "the first emission into an empty field")
	_expect(field.drop_count() == 1 and field.uncollected_count() == 1 and field.collected_count() == 0
			and field.problem().is_empty(),
		"the field after one emission reads %s" % _field(field))
	_expect(emission.run_seed() == OWNER_SEED and emission.base_experience() == TEST_MOTE and emission.problem().is_empty(),
		"emitting moved the emission's seed or amount: %s" % _emission(emission))
	var twin: RiftMoteField = RiftMoteField.new(OWNER_SEED)
	_expect_accepted(twin.spawn_drop(DEFEAT, TEST_MOTE), "the twin's direct drop")
	_expect(field.describe() == twin.describe(), "the field reads '%s' where a twin given the same drop reads '%s'" % [field.describe(), twin.describe()])
	print("  into an empty field of run seed 99: '%s' — %d drop, %d collected; %s"
		% [answer, field.drop_count(), field.collected_count(), emission.describe()])
	print("  the field reads exactly as a twin given the same position and amount directly: %s" % field.describe())
	_done("emitting_into_a_matching_empty_field_appends_exactly_one_drop")


# --- 3. No award, no offer, no level ---------------------------------------------------------------

func _check_emission_awards_nothing() -> void:
	print("")
	print("--- 3. Emission itself awards no experience, opens no offer and advances no level")
	var run: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(OWNER_SEED)
	var before: String = _snapshot(run)
	var field: RiftMoteField = RiftMoteField.new(OWNER_SEED)
	var emitted: int = 0
	while emitted * TEST_MOTE < FIRST_REQUIREMENT:
		var emission: RiftEnemyMoteEmission = RiftEnemyMoteEmission.new(OWNER_SEED, TEST_MOTE)
		_expect_emitted(emission.emit_at(DEFEAT, field), emission, "emission %d toward a requirement" % emitted)
		emitted += 1
		_expect(_snapshot(run) == before, "emission %d moved the run: %s" % [emitted, _snapshot(run)])
	_expect(emitted == 4 and field.drop_count() == 4 and field.collected_count() == 0,
		"%d emissions left the field at %s" % [emitted, _field(field)])
	_expect(run.level() == 1 and run.experience() == 0.0 and not run.is_offer_active() and _snapshot(run) == before,
		"the run after the emissions: %s" % _snapshot(run))
	var held: float = run.experience()
	var level_held: int = run.level()
	var offer_held: bool = run.is_offer_active()
	var collected_held: int = field.collected_count()
	var result: RiftMoteSweepResult = field.sweep_collection(PLAYER, run)
	_expect(result.ok and result.collected_indices() == PackedInt32Array([0, 1, 2, 3]),
		"the field's own sweep answered %s" % _sweep(result))
	_expect(run.experience() == FIRST_REQUIREMENT and run.level() == 1 and not run.is_offer_active(),
		"after the sweep the run reads %s" % _snapshot(run))
	print("  %d emissions of %s — one level-1 requirement's worth — left the run at level %d with %s, offer open: %s, and the field %d collected"
		% [emitted, _exact(TEST_MOTE), level_held, _exact(held), str(offer_held), collected_held])
	print("  the field's own sweep then collected %s and delivered %s: still level %d, offer open: %s"
		% [str(result.collected_indices()), _exact(run.experience()), run.level(), str(run.is_offer_active())])
	_done("emission_awards_nothing_opens_nothing_and_advances_nothing")


# --- 4. A later sweep pays the exact amount ----------------------------------------------------------

func _check_a_later_sweep() -> void:
	print("")
	print("--- 4. Sweeping the field later through the accepted route collects the drop and awards exactly the amount supplied")
	var paid: PackedStringArray = PackedStringArray()
	for amount: float in _kept_amounts():
		var run: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(OWNER_SEED)
		var field: RiftMoteField = RiftMoteField.new(OWNER_SEED)
		var emission: RiftEnemyMoteEmission = RiftEnemyMoteEmission.new(OWNER_SEED, amount)
		_expect_emitted(emission.emit_at(DEFEAT, field), emission, "the emission of %s" % _exact(amount))
		var first: RiftMoteSweepResult = field.sweep_collection(PLAYER, run)
		_expect(first.ok and first.collected_indices() == PackedInt32Array([0]) and run.experience() == amount,
			"%s was swept as %s and paid %s" % [_exact(amount), _sweep(first), _exact(run.experience())])
		var after: String = _snapshot(run)
		var again: RiftMoteSweepResult = field.sweep_collection(PLAYER, run)
		_expect(again.ok and again.skipped_count == 1 and again.attempted_count == 0 and _snapshot(run) == after,
			"a resweep of %s answered %s" % [_exact(amount), _sweep(again)])
		if run.experience() == amount:
			paid.append(String.num_scientific(amount))

	## EXACTLY WHERE IT LIES: one spacing within the inclusive 2.5 m boundary, and one
	## spacing beyond it, against a twin given the same two positions directly.
	var boundary: RiftMoteField = RiftMoteField.new(OWNER_SEED)
	var within: RiftEnemyMoteEmission = RiftEnemyMoteEmission.new(OWNER_SEED, TEST_MOTE)
	var beyond: RiftEnemyMoteEmission = RiftEnemyMoteEmission.new(OWNER_SEED, TEST_MOTE)
	_expect_emitted(within.emit_at(WITHIN, boundary), within, "the emission one spacing within the boundary")
	_expect_emitted(beyond.emit_at(BEYOND, boundary), beyond, "the emission one spacing beyond the boundary")
	var twin: RiftMoteField = RiftMoteField.new(OWNER_SEED)
	_expect_accepted(twin.spawn_drop(WITHIN, TEST_MOTE), "the twin's drop within")
	_expect_accepted(twin.spawn_drop(BEYOND, TEST_MOTE), "the twin's drop beyond")
	var boundary_run: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(OWNER_SEED)
	var twin_run: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(OWNER_SEED)
	var swept: RiftMoteSweepResult = boundary.sweep_collection(PLAYER, boundary_run)
	var twin_swept: RiftMoteSweepResult = twin.sweep_collection(PLAYER, twin_run)
	_expect(swept.collected_indices() == PackedInt32Array([0]) and swept.out_of_range_count == 1,
		"the boundary pair swept as %s" % _sweep(swept))
	_expect(_sweep(swept) == _sweep(twin_swept) and _snapshot(boundary_run) == _snapshot(twin_run),
		"the emitted pair answered %s where the twin answered %s" % [_sweep(swept), _sweep(twin_swept)])
	print("  %s: each emitted drop was collected at entry 0 by a later sweep and paid exactly its amount; a resweep skipped it and paid nothing"
		% ", ".join(paid))
	print("  one spacing within 2.5 m collected, one spacing beyond out of range — identical to a twin given the same positions directly (%s)"
		% swept.describe())
	_done("a_later_sweep_collects_the_emitted_drop_and_awards_the_exact_amount")


# --- 5. A second emission ----------------------------------------------------------------------------

func _check_a_second_emission() -> void:
	print("")
	print("--- 5. A second emission attempt is refused first, whatever else is true, and adds no drop anywhere")
	var field: RiftMoteField = RiftMoteField.new(OWNER_SEED)
	var other: RiftMoteField = RiftMoteField.new(OWNER_SEED)
	var stranger: RiftMoteField = RiftMoteField.new(STRANGER_SEED)
	var emission: RiftEnemyMoteEmission = RiftEnemyMoteEmission.new(OWNER_SEED, TEST_MOTE)
	_expect_emitted(emission.emit_at(DEFEAT, field), emission, "the one emission")
	var attempts: Array = [
		["the same field", DEFEAT, field],
		["another matching field", DEFEAT, other],
		["no field", DEFEAT, null],
		["a stranger's field", DEFEAT, stranger],
		["a non-finite position", Vector3(NAN, 0.0, 0.0), field],
	]
	var matched: int = 0
	for row: Array in attempts:
		var answer: String = emission.emit_at(row[1], row[2] as RiftMoteField)
		_expect_refused(answer, ALREADY_EMITTED, emission, true, "a second emission into %s" % String(row[0]))
		if answer == ALREADY_EMITTED:
			matched += 1
	_expect(field.drop_count() == 1 and other.drop_count() == 0 and stranger.drop_count() == 0,
		"a second emission added a drop: %s / %s / %s" % [_field(field), _field(other), _field(stranger)])
	var run: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(OWNER_SEED)
	_expect(field.sweep_collection(PLAYER, run).collected_indices() == PackedInt32Array([0]),
		"the one drop was not collected")
	var after_collection: String = emission.emit_at(DEFEAT, field)
	_expect_refused(after_collection, ALREADY_EMITTED, emission, true, "an emission after its drop was collected")
	if after_collection == ALREADY_EMITTED:
		matched += 1
	_expect(field.drop_count() == 1 and field.collected_count() == 1 and run.experience() == TEST_MOTE,
		"collecting re-armed the emission: %s, run %s" % [_field(field), _exact(run.experience())])
	print("  after one emission, %d of %d further attempts — the same field, another matching field, no field, a stranger's field, a non-finite position, and after the drop was collected — answered '%s' and added %d drops"
		% [matched, attempts.size() + 1, ALREADY_EMITTED, field.drop_count() - 1 + other.drop_count() + stranger.drop_count()])
	_done("a_second_emission_is_refused_first_and_adds_no_drop")


# --- 6. Two emissions, one field -----------------------------------------------------------------------

func _check_two_emissions() -> void:
	print("")
	print("--- 6. Two separate emission records each append one drop to the same matching field")
	var field: RiftMoteField = RiftMoteField.new(OWNER_SEED)
	var first: RiftEnemyMoteEmission = RiftEnemyMoteEmission.new(OWNER_SEED, TEST_MOTE)
	var second: RiftEnemyMoteEmission = RiftEnemyMoteEmission.new(OWNER_SEED, TEST_MOTE)
	_expect_emitted(first.emit_at(DEFEAT, field), first, "the first of two emissions")
	_expect(field.drop_count() == 1 and not second.is_emitted(), "the first emission moved the second: %s" % _emission(second))
	_expect_emitted(second.emit_at(DEFEAT, field), second, "the second of two emissions")
	_expect_refused(first.emit_at(DEFEAT, field), ALREADY_EMITTED, first, true, "the first emission again")
	_expect_refused(second.emit_at(DEFEAT, field), ALREADY_EMITTED, second, true, "the second emission again")
	_expect(field.drop_count() == 2, "two emissions left %s" % _field(field))
	var run: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(OWNER_SEED)
	var result: RiftMoteSweepResult = field.sweep_collection(PLAYER, run)
	_expect(result.collected_indices() == PackedInt32Array([0, 1]) and run.experience() == 2.0 * TEST_MOTE,
		"the two drops swept as %s and paid %s" % [_sweep(result), _exact(run.experience())])
	print("  2 emissions of %s at one defeat position: %d drops, each emission emitted once; the sweep collected %s and delivered %s"
		% [_exact(TEST_MOTE), field.drop_count(), str(result.collected_indices()), _exact(run.experience())])
	_done("two_emissions_each_append_one_drop_to_one_field")


# --- 7. A missing field ----------------------------------------------------------------------------------

func _check_a_missing_field() -> void:
	print("")
	print("--- 7. A missing field is refused, moves nothing, and leaves the emission available")
	var emission: RiftEnemyMoteEmission = RiftEnemyMoteEmission.new(OWNER_SEED, TEST_MOTE)
	var before: String = _emission(emission)
	_expect_refused(emission.emit_at(DEFEAT, null), NO_FIELD, emission, false, "an emission into no field")
	var nowhere: Vector3 = Vector3(NAN, 0.0, 0.0)
	var control: String = RiftMoteField.new(OWNER_SEED).spawn_drop(nowhere, TEST_MOTE)
	_expect(control == POSITION_REFUSAL_EXAMPLE, "a control field answered a non-finite position with: %s" % control)
	_expect_refused(emission.emit_at(nowhere, null), NO_FIELD, emission, false, "an emission into no field at a non-finite position")
	_expect(_emission(emission) == before, "a missing field moved the emission: %s" % _emission(emission))
	var field: RiftMoteField = RiftMoteField.new(OWNER_SEED)
	_expect_emitted(emission.emit_at(DEFEAT, field), emission, "the same emission into its own field")
	_expect(field.drop_count() == 1, "the retry left %s" % _field(field))
	print("  no field: '%s' twice — once at a non-finite position, where a field would have answered '%s' — and the emission unmoved; it then emitted once into its own field"
		% [NO_FIELD, control])
	_done("a_missing_field_is_refused_and_the_emission_stays_available")


# --- 8. An invalid spawn --------------------------------------------------------------------------------

func _check_an_invalid_spawn() -> void:
	print("")
	print("--- 8. A spawn the field refuses passes its reason through word for word, appends nothing, and a retry emits once")
	var field: RiftMoteField = RiftMoteField.new(OWNER_SEED)
	var emission: RiftEnemyMoteEmission = RiftEnemyMoteEmission.new(OWNER_SEED, TEST_MOTE)
	var verbatim: int = 0
	var places: Array[Vector3] = _non_finite_positions()
	for place: Vector3 in places:
		var expected: String = RiftMoteField.new(OWNER_SEED).spawn_drop(place, TEST_MOTE)
		var answer: String = emission.emit_at(place, field)
		_expect_refused(answer, expected, emission, false, "an emission at %s" % str(place))
		if answer == expected:
			verbatim += 1
		_expect(field.drop_count() == 0 and field.problem().is_empty(), "a refused emission appended: %s" % _field(field))
	_expect(emission.emit_at(Vector3(NAN, 0.0, 0.0), field) == POSITION_REFUSAL_EXAMPLE,
		"the typed example was not answered word for word")
	_refusals += 1

	## A field already holding drops is left exactly as it was, too.
	var held: RiftMoteField = RiftMoteField.new(OWNER_SEED)
	_expect_accepted(held.spawn_drop(DEFEAT, TEST_MOTE), "a prior drop")
	_expect_accepted(held.spawn_drop(FAR, TEST_MOTE), "a second prior drop")
	var held_before: String = held.describe()
	_expect_refused(emission.emit_at(places[0], held), RiftMoteField.new(OWNER_SEED).spawn_drop(places[0], TEST_MOTE),
		emission, false, "an emission at a non-finite position into a field holding 2 drops")
	_expect(held.describe() == held_before, "the held field moved: %s" % held.describe())

	_expect_emitted(emission.emit_at(DEFEAT, field), emission, "the retry at a finite position")
	_expect(field.drop_count() == 1, "the retry left %s" % _field(field))
	_expect_refused(emission.emit_at(DEFEAT, field), ALREADY_EMITTED, emission, true, "a further retry")
	_expect(field.drop_count() == 1, "the further retry left %s" % _field(field))
	print("  %d non-finite defeat positions: %d of %d refused with the field's own answer word for word — '%s' for (nan, 0.0, 0.0) — nothing appended, a field holding 2 drops unmoved, and the emission not emitted"
		% [places.size(), verbatim, places.size(), POSITION_REFUSAL_EXAMPLE])
	print("  retried at a finite position the same emission emitted once, and once only: %s" % _field(field))
	_done("an_invalid_spawn_passes_the_fields_reason_through_and_a_retry_emits_once")


# --- 9. An invalid amount --------------------------------------------------------------------------------

func _check_an_invalid_amount() -> void:
	print("")
	print("--- 9. An invalid amount passes H1's own reason through unchanged, appends nothing, and never emits")
	var labels: PackedStringArray = PackedStringArray()
	var verbatim: int = 0
	var attempts: int = 0
	var field: RiftMoteField = RiftMoteField.new(OWNER_SEED)
	var stranger: RiftMoteField = RiftMoteField.new(STRANGER_SEED)
	var nowhere: Vector3 = Vector3(NAN, 0.0, 0.0)
	for row: Array in UNUSABLE_BASES:
		var amount: float = float(row[1])
		var own: String = RiftExperienceMote.new(amount).problem()
		var emission: RiftEnemyMoteEmission = RiftEnemyMoteEmission.new(OWNER_SEED, amount)
		_expect(not own.is_empty() and emission.problem() == own,
			"%s: the emission's problem '%s' is not H1's own '%s'" % [String(row[0]), emission.problem(), own])
		## The field would have named the position first — so answering the amount
		## proves the emission asked H1 before it asked the field anything.
		var field_first: String = RiftMoteField.new(OWNER_SEED).spawn_drop(nowhere, amount)
		_expect(field_first != own and field_first == POSITION_REFUSAL_EXAMPLE,
			"%s: a control field answered '%s'" % [String(row[0]), field_first])
		for attempt: Array in [[DEFEAT, field], [DEFEAT, field], [nowhere, field], [DEFEAT, null], [DEFEAT, stranger]]:
			var answer: String = emission.emit_at(attempt[0], attempt[1] as RiftMoteField)
			_expect_refused(answer, own, emission, false, "%s emitted at %s" % [String(row[0]), str(attempt[0])])
			attempts += 1
			if answer == own:
				verbatim += 1
		_expect(field.drop_count() == 0 and stranger.drop_count() == 0,
			"%s appended: %s / %s" % [String(row[0]), _field(field), _field(stranger)])
		labels.append(String(row[0]))
	print("  %s: %d of %d attempts refused with H1's own reason word for word — twice into the owning field, before a non-finite position the field would have named first, before a missing field and before ownership — nothing appended and none emitted"
		% [", ".join(labels), verbatim, attempts])
	print("  zero answers '%s'" % RiftExperienceMote.new(0.0).problem())
	_done("an_invalid_amount_passes_h1s_reason_through_and_never_emits")


# --- 10. A wrong run ---------------------------------------------------------------------------------------

func _check_a_wrong_run() -> void:
	print("")
	print("--- 10. A field of another run is refused before anything is spawned, and the right field can still receive the emission")
	var emission: RiftEnemyMoteEmission = RiftEnemyMoteEmission.new(OWNER_SEED, TEST_MOTE)
	var stranger: RiftMoteField = RiftMoteField.new(STRANGER_SEED)
	var sentence: String = _ownership_sentence("99", "100")
	_expect_refused(emission.emit_at(DEFEAT, stranger), sentence, emission, false, "an emission into run seed 100's field")
	var nowhere: Vector3 = Vector3(NAN, 0.0, 0.0)
	var stranger_first: String = RiftMoteField.new(STRANGER_SEED).spawn_drop(nowhere, TEST_MOTE)
	_expect(stranger_first == POSITION_REFUSAL_EXAMPLE, "the stranger's own field answered '%s'" % stranger_first)
	_expect_refused(emission.emit_at(nowhere, stranger), sentence, emission, false,
		"an emission into run seed 100's field at a non-finite position")
	var held: RiftMoteField = RiftMoteField.new(STRANGER_SEED)
	_expect_accepted(held.spawn_drop(DEFEAT, TEST_MOTE), "the stranger's prior drop")
	_expect_accepted(held.spawn_drop(FAR, TEST_MOTE), "the stranger's second prior drop")
	var held_before: String = held.describe()
	_expect_refused(emission.emit_at(DEFEAT, held), sentence, emission, false, "an emission into a stranger field holding 2 drops")
	_expect(stranger.drop_count() == 0 and held.describe() == held_before,
		"a stranger's field moved: %s / %s" % [_field(stranger), held.describe()])
	var own: RiftMoteField = RiftMoteField.new(OWNER_SEED)
	_expect_emitted(emission.emit_at(DEFEAT, own), emission, "the same emission into its own field")
	_expect(own.drop_count() == 1 and stranger.drop_count() == 0 and held.describe() == held_before,
		"after the correct emission: %s / %s / %s" % [_field(own), _field(stranger), held.describe()])
	var run: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(OWNER_SEED)
	_expect(own.sweep_collection(PLAYER, run).collected_indices() == PackedInt32Array([0]) and run.experience() == TEST_MOTE,
		"the owning run did not collect the emitted drop: %s" % _snapshot(run))
	print("  run seed 100's field refused ('%s') — at the defeat position, at a non-finite position that field would have named first ('%s'), and into a field already holding 2 drops — with 0 drops added"
		% [sentence, stranger_first])
	print("  the correct field then received it once, and its own run collected %s" % _exact(run.experience()))
	_done("a_wrong_run_field_is_refused_before_spawning_and_the_right_field_still_receives_it")


# --- 11. Low 32 bits ---------------------------------------------------------------------------------------

func _check_low_32_bit_owners() -> void:
	print("")
	print("--- 11. Run seeds that share their low 32 bits are different owners, across negative, minimum and maximum seeds")
	var zero: RiftEnemyMoteEmission = RiftEnemyMoteEmission.new(0, TEST_MOTE)
	var high: RiftEnemyMoteEmission = RiftEnemyMoteEmission.new(TWO_TO_THE_32, TEST_MOTE)
	var zero_field: RiftMoteField = RiftMoteField.new(0)
	var high_field: RiftMoteField = RiftMoteField.new(TWO_TO_THE_32)
	var into_high: String = zero.emit_at(DEFEAT, high_field)
	var into_zero: String = high.emit_at(DEFEAT, zero_field)
	_expect_refused(into_high, _ownership_sentence("0", "4294967296"), zero, false, "seed 0 into seed 2^32's field")
	_expect_refused(into_zero, _ownership_sentence("4294967296", "0"), high, false, "seed 2^32 into seed 0's field")
	_expect(zero_field.drop_count() == 0 and high_field.drop_count() == 0, "a refused pair appended a drop")
	_expect_emitted(zero.emit_at(DEFEAT, zero_field), zero, "seed 0 into its own field")
	_expect_emitted(high.emit_at(DEFEAT, high_field), high, "seed 2^32 into its own field")
	var zero_run: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(0)
	var high_run: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(TWO_TO_THE_32)
	_expect(zero_field.sweep_collection(PLAYER, zero_run).collected_indices() == PackedInt32Array([0])
			and high_field.sweep_collection(PLAYER, high_run).collected_indices() == PackedInt32Array([0])
			and zero_run.experience() == TEST_MOTE and high_run.experience() == TEST_MOTE,
		"each own run did not collect its own emitted drop")

	var accepted: int = 0
	var refused: int = 0
	var low_agreeing: int = 0
	var available_after: int = 0
	for emission_row: Array in SEED_FAMILIES:
		for field_row: Array in SEED_FAMILIES:
			var emission_seed: int = int(emission_row[0])
			var field_seed: int = int(field_row[0])
			var emission: RiftEnemyMoteEmission = RiftEnemyMoteEmission.new(emission_seed, TEST_MOTE)
			var field: RiftMoteField = RiftMoteField.new(field_seed)
			var answer: String = emission.emit_at(DEFEAT, field)
			if emission_seed == field_seed:
				_expect_emitted(answer, emission, "seed %s into its own field" % String(emission_row[1]))
				_expect(field.drop_count() == 1, "seed %s's own field holds %d drops" % [String(emission_row[1]), field.drop_count()])
				if answer.is_empty():
					accepted += 1
				continue
			_expect_refused(answer, _ownership_sentence(String(emission_row[1]), String(field_row[1])), emission, false,
				"seed %s into seed %s's field" % [String(emission_row[1]), String(field_row[1])])
			_expect(field.drop_count() == 0, "seed %s's field took a stranger's drop" % String(field_row[1]))
			if not answer.is_empty():
				refused += 1
			if (emission_seed & LOW_32_MASK) == (field_seed & LOW_32_MASK):
				low_agreeing += 1
			var own: RiftMoteField = RiftMoteField.new(emission_seed)
			if emission.emit_at(DEFEAT, own).is_empty() and emission.is_emitted() and own.drop_count() == 1:
				available_after += 1
			_emissions += 1
	_expect(accepted == 6 and refused == 30 and low_agreeing == 12 and available_after == 30,
		"%d emitted, %d refused (%d agreeing in their low 32 bits), %d available afterwards" % [accepted, refused, low_agreeing, available_after])
	var spellings: PackedStringArray = PackedStringArray()
	for row: Array in SEED_FAMILIES:
		spellings.append(String(row[1]))
	print("  0 and 4294967296 each refused the other's field ('%s' / '%s') and each emitted into its own, which its own run then collected"
		% [into_high, into_zero])
	print("  seeds %s: %d of 36 emission-field pairs emitted (each into its own run's field); %d refused naming both seeds in full, %d of them seeds that agree in their low 32 bits; %d of %d refused emissions then emitted into their own field"
		% [", ".join(spellings), accepted, refused, low_agreeing, available_after, refused])
	_done("seeds_agreeing_in_their_low_32_bits_are_different_owners")


# --- 12. Prior drops -----------------------------------------------------------------------------------------

func _check_prior_drops() -> void:
	print("")
	print("--- 12. A field holding prior drops receives the new drop only at the end; existing entries and their order are unchanged")
	var field: RiftMoteField = RiftMoteField.new(OWNER_SEED)
	var twin: RiftMoteField = RiftMoteField.new(OWNER_SEED)
	for row: Array in PRIOR_LAYOUT:
		_expect_accepted(field.spawn_drop(row[1], float(row[2])), "the prior drop at %s" % String(row[0]))
		_expect_accepted(twin.spawn_drop(row[1], float(row[2])), "the twin's prior drop at %s" % String(row[0]))
	var run: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(OWNER_SEED)
	var twin_run: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(OWNER_SEED)
	var opening: RiftMoteSweepResult = field.sweep_collection(PLAYER, run)
	var twin_opening: RiftMoteSweepResult = twin.sweep_collection(PLAYER, twin_run)
	_expect(opening.collected_indices() == PackedInt32Array([0]) and opening.out_of_range_count == 2
			and _sweep(opening) == _sweep(twin_opening),
		"the opening sweep answered %s (twin %s)" % [_sweep(opening), _sweep(twin_opening)])

	var emission: RiftEnemyMoteEmission = RiftEnemyMoteEmission.new(OWNER_SEED, TEST_MOTE)
	_expect_emitted(emission.emit_at(FAR, field), emission, "the emission into a field holding 3 drops")
	_expect_accepted(twin.spawn_drop(FAR, TEST_MOTE), "the twin's fourth drop")
	_expect(field.drop_count() == 4 and field.collected_count() == 1 and field.uncollected_count() == 3
			and field.describe() == twin.describe(),
		"after the emission the field reads %s (twin %s)" % [field.describe(), twin.describe()])

	var paid: PackedStringArray = PackedStringArray()
	var indices: PackedStringArray = PackedStringArray()
	var identical: int = 0
	var origins: Array = [["the player", PLAYER, []], ["the new drop", FAR, [3]], ["the 3.0 m drop", PRIOR_LAYOUT[1][1], [1]],
		["the 4.0 m drop", PRIOR_LAYOUT[2][1], [2]]]
	for row: Array in origins:
		var before: float = run.experience()
		var result: RiftMoteSweepResult = field.sweep_collection(row[1], run)
		var twin_result: RiftMoteSweepResult = twin.sweep_collection(row[1], twin_run)
		_expect(result.collected_indices() == PackedInt32Array(row[2]),
			"the sweep from %s collected %s, not %s" % [String(row[0]), str(result.collected_indices()), str(row[2])])
		if _sweep(result) == _sweep(twin_result) and _snapshot(run) == _snapshot(twin_run):
			identical += 1
		if not (row[2] as Array).is_empty():
			indices.append(str(result.collected_indices()))
			paid.append(_exact(run.experience() - before))
	_expect(identical == origins.size(), "%d of %d sweeps answered as the twin did" % [identical, origins.size()])
	_expect(", ".join(paid) == "25.0, 12.5, 17.5" and run.experience() == 7.5 + 25.0 + 12.5 + 17.5,
		"the sweeps paid %s and the run holds %s" % [", ".join(paid), _exact(run.experience())])
	print("  a field holding 3 prior drops (entry 0 already collected) received the emission as entry %d of %d"
		% [field.drop_count() - 1, field.drop_count()])
	print("  sweeps from the new drop and from each prior drop collected %s, paying %s — the field and a twin given the same four drops directly answered identically %d of %d times"
		% [", then ".join(indices), ", ".join(paid), identical, origins.size()])
	_done("prior_drops_keep_their_entries_and_order_and_the_new_drop_lands_last")


# --- 13. Nothing leaks ---------------------------------------------------------------------------------------

func _check_nothing_leaks() -> void:
	print("")
	print("--- 13. Neither the temporary validator nor the drop can be retrieved or mutated through the emission")
	var emission: RiftEnemyMoteEmission = RiftEnemyMoteEmission.new(OWNER_SEED, TEST_MOTE)
	var names: PackedStringArray = PackedStringArray()
	var types: PackedStringArray = PackedStringArray()
	var objects: int = 0
	var index: int = 0
	var typed: int = 0
	for entry: Dictionary in emission.get_property_list():
		if int(entry.get("usage", 0)) & PROPERTY_USAGE_SCRIPT_VARIABLE == 0:
			continue
		names.append(String(entry.get("name", "")))
		var type_id: int = int(entry.get("type", 0))
		types.append("%s:%s" % [String(entry.get("name", "")), _type_name(type_id)])
		if type_id == TYPE_OBJECT or type_id == TYPE_ARRAY or type_id == TYPE_DICTIONARY:
			objects += 1
		if index < EMISSION_TYPES.size() and type_id == EMISSION_TYPES[index]:
			typed += 1
		index += 1
	_expect(names == PackedStringArray(EMISSION_FIELDS) and typed == EMISSION_FIELDS.size() and objects == 0,
		"the emission holds %s" % ", ".join(types))

	## Every argument-free reading answers a scalar or a string, before and after.
	var readings: Array = []
	var field: RiftMoteField = RiftMoteField.new(OWNER_SEED)
	var leaked: int = 0
	var answers: Array = []
	for pass_index: int in 2:
		readings = [emission.run_seed(), emission.base_experience(), emission.is_emitted(), emission.problem(), emission.describe()]
		for value: Variant in readings:
			if typeof(value) in [TYPE_OBJECT, TYPE_ARRAY, TYPE_DICTIONARY, TYPE_NIL]:
				leaked += 1
		if pass_index == 0:
			var refusal: Variant = emission.emit_at(DEFEAT, null)
			var success: Variant = emission.emit_at(DEFEAT, field)
			answers = [typeof(refusal), typeof(success)]
			_refusals += 1
			_emissions += 1
	_expect(leaked == 0 and answers == [TYPE_STRING, TYPE_STRING],
		"%d readings answered an object; emit_at answered types %s" % [leaked, str(answers)])

	## Only the constructor declares an object answer.
	var object_answers: PackedStringArray = PackedStringArray()
	for signature: String in _signatures_of(EMISSION_FILE):
		if signature.ends_with("-> Object"):
			object_answers.append(signature.get_slice("(", 0))
	_expect(object_answers == PackedStringArray(["_init"]), "these methods declare an object answer: %s" % ", ".join(object_answers))

	## THE TEMPORARY VALIDATOR IS MADE INSIDE THE ONE STATEMENT THAT ANSWERS WITH ITS
	## PROBLEM, is never assigned, and asking again moves nothing.
	var code: String = _code_only(FileAccess.get_file_as_string(EMISSION_FILE))
	var problem_body: PackedStringArray = _method_code(code, "func problem(")
	_expect(problem_body == PackedStringArray(["func problem() -> String:", "return RiftExperienceMote.new(_base_experience).problem()"]),
		"problem() reads: %s" % " | ".join(problem_body))
	_expect(code.count("RiftExperienceMote.new(") == 1 and code.count(".new(") == 1
			and not code.contains(": RiftExperienceMote") and not code.contains("= RiftExperienceMote"),
		"the temporary mote is made more than once or assigned somewhere")
	var fresh: RiftEnemyMoteEmission = RiftEnemyMoteEmission.new(OWNER_SEED, -1.0)
	var first_answer: String = fresh.problem()
	var stable: int = 0
	for _attempt: int in 100:
		if fresh.problem() == first_answer and fresh.base_experience() == -1.0 and not fresh.is_emitted():
			stable += 1
	_expect(stable == 100 and not first_answer.is_empty(), "%d of 100 repeated problem() calls answered alike" % stable)
	print("  %d fields (%s), %d object references; %d argument-free readings answer 0 objects; emit_at answered a String %d of %d times"
		% [names.size(), ", ".join(types), objects, readings.size(), answers.count(TYPE_STRING), answers.size()])
	print("  the methods declaring an object answer are %s; the one temporary mote is made inside the one return statement that answers with its problem, and %d more problem() calls moved nothing"
		% [", ".join(object_answers), stable])
	_done("neither_the_validator_nor_the_drop_can_be_obtained")


# --- 14. The fields and the order ------------------------------------------------------------------------------

func _check_the_fields_and_order() -> void:
	print("")
	print("--- 14. Three declared fields, written in three places, and the emission order pinned step by step")
	var raw: String = FileAccess.get_file_as_string(EMISSION_FILE)
	var code: String = _code_only(raw)
	_expect(raw.length() > 2000 and code.length() > 500, "the file reads as %d / %d characters" % [raw.length(), code.length()])

	var signatures: PackedStringArray = _signatures_of(EMISSION_FILE)
	_expect(signatures == PackedStringArray(EMISSION_SIGNATURES), "the emission declares: %s" % " | ".join(signatures))
	var script: GDScript = load(EMISSION_FILE) as GDScript
	_expect(script.get_script_constant_map().is_empty() and script.get_script_signal_list().is_empty(),
		"the emission declares constants or signals")

	var declarations: PackedStringArray = PackedStringArray()
	for line: String in code.split("\n"):
		if line.begins_with("var ") or line.begins_with("static ") or line.begins_with("const ") \
				or line.begins_with("signal ") or line.begins_with("enum ") or line.begins_with("@"):
			declarations.append(line.strip_edges())
	_expect(declarations == PackedStringArray(EMISSION_DECLARATIONS), "the top-level declarations are: %s" % " | ".join(declarations))

	var writes: PackedStringArray = PackedStringArray()
	var write: RegEx = RegEx.create_from_string("^\\s*(_run_seed|_base_experience|_emitted)\\s*([-+*/]?=)(?!=)")
	for line: String in code.split("\n"):
		if write.search(line) != null:
			writes.append(line.strip_edges())
	_expect(writes == PackedStringArray(EMISSION_WRITES), "the fields are written as: %s" % " | ".join(writes))
	var constructor: PackedStringArray = _method_code(code, "func _init(")
	_expect(constructor.has("_run_seed = for_run_seed") and constructor.has("_base_experience = for_base_experience")
			and constructor.size() == 3,
		"the constructor reads: %s" % " | ".join(constructor))

	## THE ORDER, EACH STEP ONCE, EACH GATE RETURNING ON ITS NEXT LINE.
	var body: PackedStringArray = _method_code(code, "func emit_at(")
	var ordered: PackedStringArray = PackedStringArray()
	var previous: int = -1
	for step: String in EMIT_ORDER:
		var at: int = body.find(step)
		if at <= previous or body.count(step) != 1:
			ordered.append(step)
		previous = at
	_expect(ordered.is_empty(), "steps out of order or repeated: %s" % " | ".join(ordered))
	var returning: int = 0
	for gate: String in RETURNING_GATES:
		var at: int = body.find(gate)
		if at >= 0 and at + 1 < body.size() and body[at + 1].begins_with("return "):
			returning += 1
	_expect(returning == RETURNING_GATES.size(), "%d of %d gates return on their next line" % [returning, RETURNING_GATES.size()])
	var marked: int = body.find("_emitted = true")
	_expect(marked > body.find("if not refusal.is_empty():") and marked + 1 < body.size() and body[marked + 1] == "return \"\""
			and marked + 2 == body.size(),
		"_emitted = true is not the last step before the success answer")
	var returns: PackedStringArray = PackedStringArray()
	for line: String in code.split("\n"):
		if line.strip_edges().begins_with("return "):
			returns.append(line.strip_edges())
	_expect(returns == PackedStringArray(EMISSION_RETURNS), "the emission returns: %s" % " | ".join(returns))

	## THE FIELD IS ASKED THREE THINGS AND NOTHING ELSE.
	var calls: Dictionary = {}
	for hit: RegExMatch in RegEx.create_from_string("\\bfield\\.([A-Za-z_]+)\\(").search_all(code):
		calls[hit.get_string(1)] = int(calls.get(hit.get_string(1), 0)) + 1
	var expected_calls: Dictionary = {}
	for row: Array in FIELD_CALLS:
		expected_calls[String(row[0])] = int(row[1])
	_expect(calls == expected_calls, "the field is asked: %s" % str(calls))
	_expect(code.count("field.spawn_drop(defeat_position, _base_experience)") == 1 and code.count("problem()") == 4,
		"the drop is not asked for with the untransformed position and amount, once")

	var deferred: PackedStringArray = PackedStringArray()
	for signature: String in signatures:
		var method: String = signature.get_slice("(", 0)
		for token: String in DEFERRED_MEMBER_TOKENS:
			if method.contains(token):
				deferred.append("%s (%s)" % [method, token])
	_expect(deferred.is_empty(), "deferred members: %s" % ", ".join(deferred))
	print("  %d fields declared exactly (_emitted alone initialized, to false); written only as %s; %d methods pinned, none defaulting an argument; %d constants, signals, reset, re-arm, copy, transfer, setter or listener members"
		% [declarations.size(), ", ".join(writes), signatures.size(), deferred.size()])
	print("  %d emission steps in order, each once; %d gates each return on the next line; %d return lines pinned; the field is asked problem() %d, run_seed() %d and spawn_drop( %d times, and nothing else"
		% [EMIT_ORDER.size(), returning, returns.size(), int(calls.get("problem", 0)), int(calls.get("run_seed", 0)), int(calls.get("spawn_drop", 0))])
	_done("the_emission_holds_three_fields_and_its_order_is_pinned")


# --- 15. The shape ---------------------------------------------------------------------------------------------

func _check_the_shape() -> void:
	print("")
	print("--- 15. The emission restates no rule, names no enemy content or balance, and names only what it composes")
	var raw: String = FileAccess.get_file_as_string(EMISSION_FILE)
	var code: String = _code_only(raw)
	var hits: PackedStringArray = PackedStringArray()
	for token: String in ENEMY_TOKENS + FORBIDDEN_TOKENS + AMBIENT_TOKENS:
		if raw.contains(token):
			hits.append(token)
	for token: String in RESTATEMENT_TOKENS:
		if code.contains(token):
			hits.append("code: %s" % token)
	var bare: String = RegEx.create_from_string("\"([^\"\\\\]|\\\\.)*\"").sub(code, "\"\"", true)
	for operator: String in ["+", "*", "/", "&", "|", "^", "<<", ">>"]:
		if bare.contains(operator):
			hits.append("operator %s" % operator)
	if bare.replace("->", "").contains("-"):
		hits.append("operator -")
	var formats: int = RegEx.create_from_string("\"\"\\s*%").search_all(bare).size()
	if bare.count("%") != formats or formats != 2:
		hits.append("%% outside formatting (%d of %d)" % [formats, bare.count("%")])
	var literals: PackedStringArray = _numeric_literals(code)
	if not literals.is_empty():
		hits.append("literals %s" % str(literals))
	_expect(hits.is_empty(), "the emission names or does: %s" % ", ".join(hits))

	## PER-FILE CLASS ALLOWLIST FROM THE ENGINE'S OWN CLASS LIST, BOTH DIRECTIONS.
	var all_classes: PackedStringArray = PackedStringArray()
	for entry: Dictionary in ProjectSettings.get_global_class_list():
		all_classes.append(String(entry.get("class", "")))
	_expect(all_classes.size() > 100 and all_classes.has(EMISSION_CLASS),
		"%d project classes were enumerated, the emission %s among them" % [
			all_classes.size(), "is" if all_classes.has(EMISSION_CLASS) else "is NOT"])
	var overlaps: PackedStringArray = PackedStringArray()
	for class_id: String in all_classes:
		if class_id != EMISSION_CLASS and (class_id.contains(EMISSION_CLASS) or EMISSION_CLASS.contains(class_id)):
			overlaps.append(class_id)
	_expect(overlaps.is_empty(), "the emission's class name overlaps: %s" % ", ".join(overlaps))
	var misnamed: PackedStringArray = PackedStringArray()
	for class_id: String in all_classes:
		var named: bool = raw.contains(class_id)
		if named != EMISSION_NAMES.has(class_id):
			misnamed.append("%s %s" % ["names" if named else "does not name", class_id])
	_expect(misnamed.is_empty(), "the allowlist does not hold: %s" % ", ".join(misnamed))
	print("  %d hits for enemy content (%d names, Graveblade and Vanguard among them), the character and laboratory experience records, other foundations' members, amount or position rules, seed folding, arithmetic, loops, nodes, signals, scenes, physics or files; literals %s"
		% [hits.size(), ENEMY_TOKENS.size(), str(literals)])
	print("  the emission names only %s; its name overlaps %d other class names; %d project classes read"
		% [", ".join(PackedStringArray(EMISSION_NAMES)), overlaps.size(), all_classes.size()])
	_done("the_emission_restates_nothing_and_names_no_enemy_content")


# --- 16. Unwired ---------------------------------------------------------------------------------------------------

func _check_nothing_runs_it() -> void:
	print("")
	print("--- 16. Nothing that runs creates or emits an emission, and scripts/experience/ holds six scripts")
	var project_files: int = 0
	var referenced: PackedStringArray = PackedStringArray()
	for root: String in SCANNED_ROOTS:
		for path: String in _files_under(root, [".gd", ".tscn", ".tres"]):
			if path == EMISSION_FILE:
				continue
			project_files += 1
			var text: String = FileAccess.get_file_as_string(path)
			for token: String in UNWIRED_TOKENS:
				if text.contains(token) and not _reader_may_name(path, token):
					referenced.append("%s names %s" % [path.get_file(), token])
	var settings: String = FileAccess.get_file_as_string(PROJECT_SETTINGS_FILE)
	for token: String in UNWIRED_TOKENS:
		if settings.contains(token):
			referenced.append("project.godot names %s" % token)
	_expect(referenced.is_empty(), "something that runs creates or emits an emission: %s" % ", ".join(referenced))
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

	var experience_scripts: PackedStringArray = _files_under("res://scripts/experience", [".gd"])
	experience_scripts.sort()
	_expect(experience_scripts == PackedStringArray(EXPERIENCE_SCRIPTS), "scripts/experience/ holds: %s" % ", ".join(experience_scripts))
	print("  %d unauthorized project files create or emit an emission (%d reader granted by file and token); scripts/experience/ holds %d scripts; %d actions; %d files scanned"
		% [referenced.size(), AUTHORIZED_READERS.size(), experience_scripts.size(), actions, project_files])
	print("  %d refusals and %d emissions were asserted across this suite" % [_refusals, _emissions])
	_done("nothing_that_runs_creates_an_emission_and_the_directory_holds_six_scripts")


## Whether `path` is granted `token` in `AUTHORIZED_READERS`.
func _reader_may_name(path: String, token: String) -> bool:
	for row: Array in AUTHORIZED_READERS:
		if String(row[0]) == path:
			return (row[1] as Array).has(token)
	return false


# --- Fixtures ---------------------------------------------------------------------------------------------

## The emission's ownership refusal, typed here from the two seeds' exact spellings.
func _ownership_sentence(emission_seed: String, field_seed: String) -> String:
	return "this enemy's Experience Mote belongs to run seed " + emission_seed \
		+ ", not to the mote field's run seed " + field_seed + "; it may be emitted only into a field of its own run"


## The accepted amounts, with the smallest positive double built by halving and
## placed third.
func _kept_amounts() -> Array[float]:
	var smallest: float = 1.0
	while smallest / 2.0 > 0.0:
		smallest /= 2.0
	var out: Array[float] = []
	for amount: float in KEPT_AMOUNTS:
		out.append(amount)
	out.insert(2, smallest)
	return out


## NaN, +inf and -inf in each of x, y and z of an otherwise ordinary defeat position.
func _non_finite_positions() -> Array[Vector3]:
	var out: Array[Vector3] = []
	for axis: int in 3:
		for value: float in [NAN, INF, -INF]:
			var place: Vector3 = DEFEAT
			place[axis] = value
			out.append(place)
	return out


# --- Assertions -------------------------------------------------------------------------------------------

func _expect_accepted(refusal: String, described: String) -> void:
	_expect(refusal.is_empty(), "%s was refused: %s" % [described, refusal])


func _expect_emitted(answer: String, emission: RiftEnemyMoteEmission, described: String) -> void:
	_emissions += 1
	_expect(answer.is_empty() and emission.is_emitted(),
		"%s was not emitted: '%s' (%s)" % [described, answer, _emission(emission)])


## A refusal must be exactly the expected reason, and must leave the emission's
## emitted state exactly where it was.
func _expect_refused(answer: String, expected: String, emission: RiftEnemyMoteEmission, was_emitted: bool, described: String) -> void:
	_refusals += 1
	_expect(not expected.is_empty() and answer == expected, "%s answered '%s', not '%s'" % [described, answer, expected])
	_expect(emission.is_emitted() == was_emitted, "%s moved the emission: %s" % [described, _emission(emission)])


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


func _emission(emission: RiftEnemyMoteEmission) -> String:
	return "seed=%d base=%s emitted=%s problem='%s'" % [
		emission.run_seed(), _exact(emission.base_experience()), str(emission.is_emitted()), emission.problem()]


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
## rendering the accepted H1–H5 and G4 pins use.
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
