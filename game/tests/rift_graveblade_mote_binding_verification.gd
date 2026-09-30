extends SceneTree
## Riftwrought — Roguelite Foundation H7 verification: one real Graveblade's
## death, heard once through its own `died` signal, becomes its one Experience
## Mote drop in the mote field of its run.
##
## ONE FOCUSED HEADLESS TEST, AND THE FIRST H-SERIES SUITE WITH A REAL ACTOR IN IT.
## Every Graveblade here is the production scene, instantiated as the roguelite
## runtimes instantiate it, and every one of them dies through its own public
## `receive_damage()` — the entry every accepted attacker calls — and its own
## mechanical death. Nothing kills a Graveblade any other way, and nothing emits
## its `died` signal but the Graveblade itself.
##
## THE SCENE TREE IS ENTERED ONCE. Nodes added during `_initialize()` do not enter
## the tree until the first frame — measured while this suite was being written:
## `_ready()` never ran and every `global_position` read was refused — so the suite
## waits exactly one process frame and then runs every check synchronously. No
## physics step runs between a Graveblade's placement and its death, so every
## position is exactly the one placed.
##
## IT PORTS D-211's OWED-SET DISCIPLINE. Every check function records reaching its
## LAST line, and the suite compares that set against what it owes in BOTH
## directions, so a check that dies half way cannot leave a green run behind it.
##
## THE HARNESS NEVER EMITS, NEVER CONNECTS FOR A BINDING, AND WRITES NO PRIVATE
## STATE. Every drop a binding is credited with was made by that binding's own
## callback, reached through the Graveblade's own `died`. The harness connects only
## its own observers; makes drops directly only in TWIN fields; collects only
## through the field's public sweep; and reads and writes no private member of a
## binding, an emission, a field or a run. It places a Graveblade through
## `position` before it enters the tree and through the actor's own `place_at()`
## afterwards, and moves one to a non-finite place through the engine's public
## `global_position` — the one lawful route to the only emission refusal a
## connected binding can still meet. It restores a dead Graveblade only through
## `reset_encounter()`, the public restore both roguelite runtimes call, and gives
## one Graveblade attack permission only through the actor's existing
## `begin_attack_for_verification()`.
##
## EVERY EXPECTED ANSWER IS EITHER A TYPED LITERAL OR THE ACCEPTED MECHANISM'S OWN
## ANSWER, asked directly with the same inputs — H1's own `problem()` for an
## amount, a control field's own answer for a position, and a twin field's own
## sweep for what a drop is worth and exactly where it lies.
##
## THE VALUES 25, 12.5, 40 AND 100 ARE TEST EVIDENCE ONLY. 100 is the accepted
## starter Quick Strike's Physical damage, used so a Graveblade dies to the hits it
## is accepted to die to; the rest are mote amounts. None is an enemy-experience
## value, and nothing here decides one.
##
## IT READS NO OTHER SUITE. It names no file under `tests/` but its own, which the
## runner asserts.

# --- The files ----------------------------------------------------------------------

const BINDING_FILE: String = "res://scripts/experience/rift_graveblade_mote_binding.gd"
const THIS_FILE: String = "res://tests/rift_graveblade_mote_binding_verification.gd"

const BINDING_CLASS: String = "RiftGravebladeMoteBinding"

## The production Graveblade scene and the two accepted Graveblade records, read
## here only to build real Graveblades and to show what the records do NOT decide.
const GRAVEBLADE_SCENE: String = "res://scenes/actors/prototype_graveblade.tscn"
const ORDINARY_RECORD: String = "res://data/prototype_zero/graveblade.tres"
const ELITE_RECORD: String = "res://data/roguelite/graveblade_elite.tres"

## `scripts/experience/` after H7, sorted: H6's emission, H1's mote, E1's two
## scripts and H7's binding.
const EXPERIENCE_SCRIPTS: Array[String] = [
	"res://scripts/experience/rift_enemy_mote_emission.gd",
	"res://scripts/experience/rift_experience_mote.gd",
	"res://scripts/experience/rift_experience_reading.gd",
	"res://scripts/experience/rift_experience_track.gd",
	"res://scripts/experience/rift_graveblade_mote_binding.gd",
	## D-286: and Foundation H8's Experience Mote runtime, which shares the directory.
	"res://scripts/experience/rift_mote_runtime.gd",
]

const SCANNED_ROOTS: Array[String] = [
	"res://scripts", "res://scenes", "res://data", "res://addons",
]
const PROJECT_SETTINGS_FILE: String = "res://project.godot"

## Everything that would mean something that runs creates or connects a binding.
const UNWIRED_TOKENS: Array[String] = [
	"RiftGravebladeMoteBinding", "rift_graveblade_mote_binding", "connect_to_death(",
]

## THE ONLY FILES OTHER THAN THE BINDING THAT MAY NAME AN UNWIRED TOKEN, PER FILE AND
## PER TOKEN. D-286: Foundation H8's Experience Mote runtime makes one binding for each
## Graveblade registered with it, asks it to connect, and owns it strongly for the run
## (D-285) — so it is granted the binding's class and the connecting call, and never
## the binding's file name. Nothing that runs creates a runtime. This replaces the
## blanket "no other file" one for one: the same single assertion is made either way,
## and the pinned count does not move.
const AUTHORIZED_READERS: Array = [
	["res://scripts/experience/rift_mote_runtime.gd", ["RiftGravebladeMoteBinding", "connect_to_death("]],
]

## THE ONLY PROJECT CLASSES THE BINDING MAY NAME, and it must name all five:
## itself, the actor whose death it hears, the event that death arrives with, the
## emission it asks (H6) and the field it emits into (H5). Checked against the
## engine's own global class list in both directions.
const BINDING_NAMES: Array[String] = [
	"DamageEvent", "PrototypeGraveblade", "RiftEnemyMoteEmission", "RiftGravebladeMoteBinding", "RiftMoteField",
]

## Every method, in declaration order, with its full signature. The engine reports
## a constructor's return as an object, whatever the source declares.
const BINDING_SIGNATURES: Array[String] = [
	"_init(for_run_seed: int, for_enemy: Object, for_field: Object, for_base_experience: float) -> Object",
	"connect_to_death() -> String",
	"_on_enemy_died(_event: Object) -> void",
	"has_connected() -> bool",
	"has_observed_death() -> bool",
	"is_emitted() -> bool",
	"emission_answer() -> String",
	"describe() -> String",
]

## THE BINDING'S WHOLE STATE: SIX PRIVATE FIELDS AND NO SEVENTH.
const BINDING_FIELDS: Array[String] = [
	"_enemy", "_field", "_emission", "_connected", "_death_observed", "_emission_answer",
]
const BINDING_TYPES: Array[int] = [TYPE_OBJECT, TYPE_OBJECT, TYPE_OBJECT, TYPE_BOOL, TYPE_BOOL, TYPE_STRING]
const BINDING_DECLARATIONS: Array[String] = [
	"var _enemy: PrototypeGraveblade",
	"var _field: RiftMoteField",
	"var _emission: RiftEnemyMoteEmission",
	"var _connected: bool = false",
	"var _death_observed: bool = false",
	"var _emission_answer: String = \"\"",
]

## The ONLY writes to a field anywhere in the file, in source order.
const BINDING_WRITES: Array[String] = [
	"_enemy = for_enemy",
	"_field = for_field",
	"_emission = RiftEnemyMoteEmission.new(for_run_seed, for_base_experience)",
	"_connected = true",
	"_emission_answer = _emission.emit_at(defeat_position, _field)",
	"_death_observed = true",
]

## The accepted and new wordings this suite quotes, typed independently.
const NO_ENEMY: String = "a Graveblade's Experience Mote binding needs the Graveblade whose death it hears, and there is none"
const NO_FIELD: String = "a Graveblade's Experience Mote binding needs the mote field of its run, and none was given"
const ALREADY_CONNECTED: String = "this Graveblade's Experience Mote binding has already connected or already heard a death; it connects nothing again"
const ALREADY_LISTENING: String = "this Graveblade's Experience Mote binding is already listening for its Graveblade's death; it connects nothing again"
## D-284: the final pre-connection gate's diagnostic, pinned verbatim.
const ALREADY_DEAD: String = "the bound Graveblade is already dead; its Experience Mote binding must be connected before death"
## Where a Graveblade under a Node3D parent stands once ONE component of its place is
## not finite: the parent's transform multiplies a zero by that component, so every
## component of its world position reads back as not a number.
const NON_FINITE_EXAMPLE: String = "an Experience Mote drop's position must have a finite x, y and z, not (nan, nan, nan)"

## THE CONNECTION ORDER, AS THE CODE MUST SPELL IT, first occurrence to first
## occurrence inside `connect_to_death()`, each step exactly once.
const CONNECT_ORDER: Array[String] = [
	"if _enemy == null:",
	"return \"" + NO_ENEMY + "\"",
	"if _field == null:",
	"return \"" + NO_FIELD + "\"",
	"var invalid: String = _emission.problem()",
	"if not invalid.is_empty():",
	"return invalid",
	"var incoherent: String = _field.problem()",
	"if not incoherent.is_empty():",
	"return incoherent",
	"if _field.run_seed() != _emission.run_seed():",
	"if _connected or _death_observed:",
	"return \"" + ALREADY_CONNECTED + "\"",
	"if _enemy.died.is_connected(_on_enemy_died):",
	"return \"" + ALREADY_LISTENING + "\"",
	"if not _enemy.is_alive():",
	"return \"" + ALREADY_DEAD + "\"",
	"_enemy.died.connect(_on_enemy_died)",
	"_connected = true",
	"return \"\"",
]

## Every gate in `connect_to_death()`, each of which must return on its next line.
const RETURNING_GATES: Array[String] = [
	"if _enemy == null:", "if _field == null:", "if not invalid.is_empty():", "if not incoherent.is_empty():",
	"if _field.run_seed() != _emission.run_seed():", "if _connected or _death_observed:",
	"if _enemy.died.is_connected(_on_enemy_died):", "if not _enemy.is_alive():",
]

## THE WHOLE CALLBACK, line for line: the guard first, then the position read from
## the bound Graveblade, then the one attempt, then the record that it was heard.
const CALLBACK_BODY: Array[String] = [
	"func _on_enemy_died(_event: DamageEvent) -> void:",
	"if _death_observed:",
	"return",
	"var defeat_position: Vector3 = _enemy.global_position",
	"_emission_answer = _emission.emit_at(defeat_position, _field)",
	"_death_observed = true",
]

## EVERY `return` IN THE FILE, EXACTLY. None hands out the Graveblade, the field or
## the emission.
const BINDING_RETURNS: Array[String] = [
	"return \"" + NO_ENEMY + "\"",
	"return \"" + NO_FIELD + "\"",
	"return invalid",
	"return incoherent",
	"return \"this Graveblade's Experience Mote belongs to run seed %d, not to the mote field's run seed %d; it may be bound only to a field of its own run\" % [",
	"return \"" + ALREADY_CONNECTED + "\"",
	"return \"" + ALREADY_LISTENING + "\"",
	"return \"" + ALREADY_DEAD + "\"",
	"return \"\"",
	"return",
	"return _connected",
	"return _death_observed",
	"return _emission.is_emitted()",
	"return _emission_answer",
	"return \"Graveblade Experience Mote binding, %s, %s; %s\" % [",
]

## The only members of each held object the binding may reach, with how often.
const ENEMY_CALLS: Array = [["died", 2], ["global_position", 1], ["is_alive", 1]]
const FIELD_CALLS: Array = [["problem", 1], ["run_seed", 2]]
const EMISSION_CALLS: Array = [["problem", 1], ["run_seed", 2], ["emit_at", 1], ["is_emitted", 1], ["describe", 1]]

## Enemy content, experience balance, the project's OTHER experience records, and
## every other foundation's class, file and member the binding is not granted.
## Scanned RAW over the binding, comments included — D-215's lesson.
const FORBIDDEN_TOKENS: Array[String] = [
	"GravebladeData", "experience_reward", "GRAVEBLADE_EXPERIENCE", "ExperienceTable", "experience_table",
	"CharacterState", "LabProgress", "progression", "max_life", "Vanguard", "vanguard", "VANGUARD",
	## Lower-case "elite" is anchored, because a bare token fails on "Roguelite".
	"Elite", " elite", "_elite", "ELITE", "XP", "Mauler", "Marrowshot", "Tombknife", "Acolyte", "Cantor", "Warden",
	".tres", ".tscn", "res://", "user://",
	"RiftExperienceMote", "rift_experience_mote", "collect_into", "RiftMoteDrop", "rift_mote_drop",
	"attempt_collection", "RiftMoteCollection", "RiftMotePickup", "rift_mote_field", "RiftMoteSweepResult",
	"sweep_collection", "spawn_drop", "rift_enemy_mote_emission", "RiftRunLevelCoordinator",
	"award_experience", "RiftExperienceTrack", "RiftExperienceReading", "RiftRunBuild", "PlayerStat",
	"RogueliteCoreLoopRuntime", "RogueliteReplayabilityRuntime", "RogueliteBuildVariety",
	"ConfigFile", "FileAccess", "ResourceSaver", "RandomNumberGenerator", "randi", "randf",
	"Time.", "Engine.", "ProjectSettings", "InputMap",
]

## What the binding may not DO, as tokens over CODE lines only: read the event,
## identify the Graveblade any other way, read its record or Life, disconnect,
## retry, wait, tick, signal, loop, hold a collection, load anything, move a
## Graveblade, or reach any further step of the field or the run. D-284: the
## Graveblade's own alive reading is granted, exactly once, as the last gate before
## the connection — counted by ENEMY_CALLS and placed by the connection's pinned tail.
const BEHAVIOUR_TOKENS: Array[String] = [
	"_event.", ".source", ".target", "display_name", ".name", "get_node", "find_child", "get_parent",
	"get_tree", "get_instance_id", "get_children", "life", "data", "disconnect", "retry",
	"await", "Timer", "create_timer", "_process", "call_deferred", "emit_signal", ".emit(", "signal ",
	"for ", "while ", "match ", "Array", "Dictionary", "Packed", "load(", "position =", "place_at",
	"reset", "sweep", "collect", "award", "spawn", "is_instance_valid", "static", "const ", "enum ",
]

## Words that would mean a binding can be reset, re-armed, retried, copied,
## transferred, stored, polled or asked to hand something out.
const DEFERRED_MEMBER_TOKENS: Array[String] = [
	"retry", "reset", "rearm", "disconnect", "copy", "clone", "transfer", "set_", "save", "load",
	"persist", "sweep", "collect", "award", "spawn", "poll", "position", "drop", "timer", "tick", "again",
]

# --- The fixtures, stated independently -----------------------------------------------

## Test evidence only.
const HIT: float = 100.0
const TEST_MOTE: float = 25.0
const LESSER_MOTE: float = 12.5
const GREATER_MOTE: float = 40.0

## The inclusive base Pickup Radius every fresh run answers with.
const BOUNDARY: float = 2.5

const UNUSABLE_BASES: Array = [
	["zero", 0.0], ["negative", -25.0], ["not a number", NAN],
	["positive infinity", INF], ["negative infinity", -INF],
]

const OWNER_SEED: int = 99
const STRANGER_SEED: int = 100

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

## The places check 3 measures from: where the Graveblade entered the tree, where it
## stands when it dies, and where the lethal event's attacker and target stand.
const LETHAL_SPAWN: Vector3 = Vector3(-12.0, 0.0, 8.0)
const LETHAL_DEATH: Vector3 = Vector3(6.0, 0.0, -6.0)
const LETHAL_ATTACKER: Vector3 = Vector3(30.0, 0.0, 30.0)
const LETHAL_TARGET: Vector3 = Vector3(-30.0, 0.0, -30.0)

const OWED_CHECKS: Array[String] = [
	"construction_connects_nothing_and_one_connection_connects_exactly_once",
	"a_binding_nobody_keeps_is_released_with_its_connection",
	"a_nonlethal_hit_emits_nothing_and_records_no_death",
	"a_lethal_hit_emits_one_drop_where_the_bound_graveblade_died",
	"the_event_cannot_redirect_the_drop_to_another_graveblade",
	"a_repeated_death_signal_adds_no_drop_and_replaces_no_outcome",
	"two_bound_graveblades_emit_two_independently_ordered_drops",
	"deaths_award_nothing_and_a_later_sweep_collects_both_in_order",
	"every_configuration_refusal_happens_before_connection",
	"seeds_agreeing_in_their_low_32_bits_are_different_owners",
	"a_callback_refusal_is_kept_word_for_word_and_never_retried",
	"a_fresh_binding_refuses_an_already_dead_graveblade_until_it_is_restored",
	"the_mechanical_death_is_complete_when_the_callback_hears_it",
	"the_graveblade_record_does_not_decide_the_amount",
	"the_binding_holds_six_fields_and_its_orders_are_pinned",
	"the_binding_names_no_balance_and_only_what_it_composes",
	"nothing_that_runs_creates_a_binding_and_the_directory_holds_six_scripts",
]

var _failures: PackedStringArray = PackedStringArray()
var _checks: int = 0
var _reached: Dictionary = {}
var _refusals: int = 0
var _deaths_driven: int = 0

var _stage: Node3D
var _ordinary: GravebladeData
var _elite: GravebladeData
var _use: int = 0
## Per Graveblade instance id: how many times its own `died` and `took_damage`
## fired, counted by observers this harness connects before any binding.
var _deaths: Dictionary = {}
var _hits: Dictionary = {}


func _initialize() -> void:
	_run()


func _run() -> void:
	await process_frame
	print("")
	print("=== Roguelite Foundation H7 — Graveblade Death-to-Mote Binding (D-283) ===")
	_stage = Node3D.new()
	_stage.name = "H7Stage"
	root.add_child(_stage)
	_ordinary = load(ORDINARY_RECORD) as GravebladeData
	_elite = load(ELITE_RECORD) as GravebladeData
	_expect(root.is_inside_tree() and _stage.is_inside_tree() and _ordinary != null and _elite != null,
		"the stage did not enter the tree, or a Graveblade record did not load")

	_check_construction_and_one_connection()
	_check_a_binding_nobody_keeps()
	_check_a_nonlethal_hit()
	_check_a_lethal_hit()
	_check_the_event_cannot_redirect()
	_check_a_repeated_death()
	_check_two_bound_graveblades()
	_check_deaths_award_nothing()
	_check_configuration_refusals()
	_check_low_32_bit_owners()
	_check_a_callback_refusal()
	_check_an_already_dead_graveblade()
	_check_the_death_order()
	_check_the_record_does_not_decide()
	_check_the_fields_and_orders()
	_check_the_shape()
	_check_nothing_runs_it()

	_check_every_check_ran()

	print("")
	if _failures.is_empty():
		print("RIFT GRAVEBLADE MOTE BINDING VERIFICATION: PASS (%d checks)" % _checks)
		quit(0)
	else:
		for failure: String in _failures:
			printerr("  FAIL: %s" % failure)
		printerr("RIFT GRAVEBLADE MOTE BINDING VERIFICATION: %d FAILURE(S) of %d checks" % [
			_failures.size(), _checks,
		])
		quit(1)


# --- 1. Construction and one connection ---------------------------------------------------------

func _check_construction_and_one_connection() -> void:
	print("")
	print("--- 1. Construction connects nothing; one explicit connection connects exactly once; a second is refused")
	var script: GDScript = load(BINDING_FILE) as GDScript
	var constructor_args: int = -1
	var defaults: PackedStringArray = PackedStringArray()
	for entry: Dictionary in script.get_script_method_list():
		if String(entry.get("name", "")) == "_init":
			constructor_args = (entry.get("args", []) as Array).size()
		if not (entry.get("default_args", []) as Array).is_empty():
			defaults.append(String(entry.get("name", "")))
	_expect(constructor_args == 4 and defaults.is_empty(),
		"the constructor takes %d arguments; these methods default one: %s" % [constructor_args, ", ".join(defaults)])

	var enemy: PrototypeGraveblade = _graveblade("ConnectsOnce", Vector3(0.0, 0.0, 0.0), null, _stage)
	var field: RiftMoteField = RiftMoteField.new(OWNER_SEED)
	var baseline: int = enemy.died.get_connections().size()
	var binding: RiftGravebladeMoteBinding = RiftGravebladeMoteBinding.new(OWNER_SEED, enemy, field, TEST_MOTE)
	var constructed: int = enemy.died.get_connections().size()
	var unconnected: String = binding.describe()
	var connected_when_made: bool = binding.has_connected()
	_expect(constructed == baseline and not binding.has_connected() and not binding.has_observed_death()
			and not binding.is_emitted() and binding.emission_answer().is_empty()
			and _connections_to(enemy, binding) == 0 and unconnected.contains("not connected"),
		"construction moved something: %d -> %d connections; %s" % [baseline, constructed, _binding(binding)])

	var first: String = binding.connect_to_death()
	var after_first: int = enemy.died.get_connections().size()
	_expect(first.is_empty() and binding.has_connected() and after_first == baseline + 1
			and _connections_to(enemy, binding) == 1,
		"the connection answered '%s' and left %d connections (%d of them the binding's)" % [
			first, after_first, _connections_to(enemy, binding)])
	var second: String = binding.connect_to_death()
	_expect_refused(second, ALREADY_CONNECTED, "a second connection of the same binding")
	_expect(enemy.died.get_connections().size() == after_first and _connections_to(enemy, binding) == 1
			and binding.has_connected() and not binding.has_observed_death() and field.drop_count() == 0,
		"the refused second connection moved something: %s, %d drops" % [_binding(binding), field.drop_count()])
	print("  the constructor takes %d arguments and no method defaults one; construction left the Graveblade's died at %d connection (the harness's own observer) and the binding %s"
		% [constructor_args, constructed, "connected" if connected_when_made else "not connected"])
	print("  connect_to_death(): '%s' — %d connection added, exactly 1 of them the binding's; a second answered '%s' and added 0"
		% [first, after_first - baseline, second])
	_done("construction_connects_nothing_and_one_connection_connects_exactly_once")


# --- 2. A binding nobody keeps ----------------------------------------------------------------------

func _check_a_binding_nobody_keeps() -> void:
	print("")
	print("--- 2. A binding nobody keeps is released with its connection: the connection names it without holding it")
	var enemy: PrototypeGraveblade = _graveblade("Unkept", Vector3(4.0, 0.0, 0.0), null, _stage)
	var field: RiftMoteField = RiftMoteField.new(OWNER_SEED)
	var baseline: int = enemy.died.get_connections().size()
	var answer: String = _connect_and_let_go(enemy, field)
	var afterwards: int = enemy.died.get_connections().size()
	var ladder: PackedStringArray = _kill(enemy, _node("UnkeptAttacker", Vector3(4.0, 0.0, 1.0)), enemy)
	_expect(answer.is_empty() and afterwards == baseline and _died(enemy) == 1 and field.drop_count() == 0,
		"an unkept binding answered '%s', left %d of %d connections, and the death made %d drops" % [
			answer, afterwards, baseline, field.drop_count()])
	print("  a binding connected ('%s') and then let go left the Graveblade's died at %d connections, its own gone; the death (%s) made %d drops"
		% [answer, afterwards, " -> ".join(ladder), field.drop_count()])
	_done("a_binding_nobody_keeps_is_released_with_its_connection")


func _connect_and_let_go(enemy: PrototypeGraveblade, field: RiftMoteField) -> String:
	return RiftGravebladeMoteBinding.new(OWNER_SEED, enemy, field, TEST_MOTE).connect_to_death()


# --- 3. A nonlethal hit ---------------------------------------------------------------------------------

func _check_a_nonlethal_hit() -> void:
	print("")
	print("--- 3. Accepted nonlethal hits land, and emit no drop and record no death")
	var enemy: PrototypeGraveblade = _graveblade("Nonlethal", Vector3(10.0, 0.0, 0.0), null, _stage)
	var attacker: Node3D = _node("NonlethalAttacker", Vector3(10.0, 0.0, 1.2))
	var field: RiftMoteField = RiftMoteField.new(OWNER_SEED)
	var binding: RiftGravebladeMoteBinding = RiftGravebladeMoteBinding.new(OWNER_SEED, enemy, field, TEST_MOTE)
	_expect_accepted(binding.connect_to_death(), "the nonlethal binding")
	var ladder: PackedStringArray = PackedStringArray([_life(enemy.life)])
	for _hit: int in 2:
		_strike(enemy, attacker, enemy)
		ladder.append(_life(enemy.life))
	_expect(" -> ".join(ladder) == "300 -> 200 -> 100" and _took(enemy) == 2 and enemy.damage_taken_events == 2
			and _died(enemy) == 0 and enemy.is_alive(),
		"two accepted hits read %s with %d took_damage and %d died" % [" -> ".join(ladder), _took(enemy), _died(enemy)])
	_expect(not binding.has_observed_death() and not binding.is_emitted() and binding.emission_answer().is_empty()
			and field.drop_count() == 0,
		"a nonlethal hit moved the binding or the field: %s, %d drops" % [_binding(binding), field.drop_count()])
	print("  2 accepted hits of %s: Life %s, took_damage %d, died %d — %d drops, death heard: %s, emitted: %s"
		% [_exact(HIT), " -> ".join(ladder), _took(enemy), _died(enemy), field.drop_count(),
			str(binding.has_observed_death()), str(binding.is_emitted())])
	_done("a_nonlethal_hit_emits_nothing_and_records_no_death")


# --- 4. A lethal hit ------------------------------------------------------------------------------------

func _check_a_lethal_hit() -> void:
	print("")
	print("--- 4. A genuine lethal hit makes one died and one drop, exactly where the bound Graveblade stood — not where it entered, nor where the event's attacker or target stood")
	var enemy: PrototypeGraveblade = _graveblade("Lethal", LETHAL_SPAWN, null, _stage)
	var attacker: Node3D = _node("LethalAttacker", LETHAL_ATTACKER)
	var target: Node3D = _node("LethalTarget", LETHAL_TARGET)
	var field: RiftMoteField = RiftMoteField.new(OWNER_SEED)
	var binding: RiftGravebladeMoteBinding = RiftGravebladeMoteBinding.new(OWNER_SEED, enemy, field, TEST_MOTE)
	var heard_before: Array = []
	enemy.died.connect(func(_event: DamageEvent) -> void:
		heard_before.append([enemy.global_position, field.drop_count(), binding.has_observed_death()]))
	_expect_accepted(binding.connect_to_death(), "the lethal binding")
	var heard_after: Array = []
	enemy.died.connect(func(_event: DamageEvent) -> void:
		heard_after.append([field.drop_count(), binding.has_observed_death(), binding.is_emitted()]))
	var entered_at: Vector3 = enemy.global_position
	enemy.place_at(LETHAL_DEATH)
	var ladder: PackedStringArray = _kill(enemy, attacker, target)
	_expect(entered_at == LETHAL_SPAWN and enemy.global_position == LETHAL_DEATH,
		"the Graveblade entered at %s and died at %s" % [str(entered_at), str(enemy.global_position)])
	_expect(" -> ".join(ladder) == "300 -> 200 -> 100 -> 0" and _took(enemy) == 3 and _died(enemy) == 1
			and not enemy.is_alive(),
		"the kill read %s with %d took_damage and %d died" % [" -> ".join(ladder), _took(enemy), _died(enemy)])
	var lethal: DamageEvent = enemy.last_damage_taken
	_expect(lethal != null and lethal.source == attacker and lethal.target == target
			and attacker.global_position == LETHAL_ATTACKER and target.global_position == LETHAL_TARGET,
		"the lethal event was not the attacker-and-decoy event it was built as")
	_expect(heard_before.size() == 1 and heard_before[0] == [LETHAL_DEATH, 0, false]
			and heard_after.size() == 1 and heard_after[0] == [1, true, true],
		"around the binding's callback the observers saw %s then %s" % [str(heard_before), str(heard_after)])
	_expect(field.drop_count() == 1 and field.uncollected_count() == 1 and field.problem().is_empty()
			and binding.has_observed_death() and binding.is_emitted() and binding.emission_answer().is_empty(),
		"after the death: %d drops; %s" % [field.drop_count(), _binding(binding)])
	var twin: RiftMoteField = RiftMoteField.new(OWNER_SEED)
	_expect_accepted(twin.spawn_drop(LETHAL_DEATH, TEST_MOTE), "the twin's drop")
	var elsewhere: Array[Vector3] = [LETHAL_SPAWN, LETHAL_ATTACKER, LETHAL_TARGET]
	var held: int = _pin_drop(field, twin, OWNER_SEED, LETHAL_DEATH, TEST_MOTE, elsewhere)
	_expect(held == elsewhere.size() + 5, "%d of %d position probes held" % [held, elsewhere.size() + 5])
	print("  Life %s: took_damage %d, died %d; the lethal event's source stood at %s and its target at %s"
		% [" -> ".join(ladder), _took(enemy), _died(enemy), str(LETHAL_ATTACKER), str(LETHAL_TARGET)])
	print("  the Graveblade entered at %s and died at %s; just before the binding's callback the field held %d drops, just after it %d"
		% [str(LETHAL_SPAWN), str(LETHAL_DEATH), int(heard_before[0][1]) if heard_before.size() == 1 else -1,
			int(heard_after[0][0]) if heard_after.size() == 1 else -1])
	print("  %d of %d probes held: nothing in range from where it entered, the attacker or the target; nothing one float32 spacing beyond 2.5 m on any of four sides; collected exactly 2.5 m away and paid %s — as a twin given the drop directly answered"
		% [held, elsewhere.size() + 5, _exact(TEST_MOTE)])
	_done("a_lethal_hit_emits_one_drop_where_the_bound_graveblade_died")


# --- 5. The event cannot redirect ---------------------------------------------------------------------

func _check_the_event_cannot_redirect() -> void:
	print("")
	print("--- 5. Killed by an event whose source and target are two OTHER bound Graveblades of the same name, the dead one's binding alone emits, where it died")
	var names: PackedStringArray = PackedStringArray()
	var fallen: PrototypeGraveblade = _graveblade("Graveblade", Vector3(40.0, 0.0, 0.0), null, _parent("RoomA"))
	var source: PrototypeGraveblade = _graveblade("Graveblade", Vector3(48.0, 0.0, 0.0), null, _parent("RoomB"))
	var target: PrototypeGraveblade = _graveblade("Graveblade", Vector3(40.0, 0.0, 8.0), null, _parent("RoomC"))
	for enemy: PrototypeGraveblade in [fallen, source, target]:
		names.append("%s/%s" % [enemy.name, enemy.data.display_name])
	var field: RiftMoteField = RiftMoteField.new(OWNER_SEED)
	var fallen_binding: RiftGravebladeMoteBinding = RiftGravebladeMoteBinding.new(OWNER_SEED, fallen, field, TEST_MOTE)
	var source_binding: RiftGravebladeMoteBinding = RiftGravebladeMoteBinding.new(OWNER_SEED, source, field, LESSER_MOTE)
	var target_binding: RiftGravebladeMoteBinding = RiftGravebladeMoteBinding.new(OWNER_SEED, target, field, GREATER_MOTE)
	for binding: RiftGravebladeMoteBinding in [fallen_binding, source_binding, target_binding]:
		_expect_accepted(binding.connect_to_death(), "one of three bindings")
	var ladder: PackedStringArray = _kill(fallen, source, target)
	_expect(names == PackedStringArray(["Graveblade/Graveblade", "Graveblade/Graveblade", "Graveblade/Graveblade"])
			and fallen.get_path() != source.get_path() and fallen.get_path() != target.get_path(),
		"the three Graveblades were not three nodes of one name and one display name: %s" % ", ".join(names))
	_expect(fallen.last_damage_taken != null and fallen.last_damage_taken.source == source
			and fallen.last_damage_taken.target == target,
		"the lethal event did not name the other two Graveblades")
	_expect(_died(fallen) == 1 and _died(source) == 0 and _died(target) == 0 and source.is_alive() and target.is_alive()
			and source.life == 300.0 and target.life == 300.0,
		"died fired %d / %d / %d" % [_died(fallen), _died(source), _died(target)])
	_expect(field.drop_count() == 1 and fallen_binding.is_emitted() and fallen_binding.has_observed_death()
			and not source_binding.has_observed_death() and not target_binding.has_observed_death()
			and not source_binding.is_emitted() and not target_binding.is_emitted(),
		"the bindings read %s | %s | %s with %d drops" % [
			_binding(fallen_binding), _binding(source_binding), _binding(target_binding), field.drop_count()])
	var twin: RiftMoteField = RiftMoteField.new(OWNER_SEED)
	_expect_accepted(twin.spawn_drop(fallen.global_position, TEST_MOTE), "the twin's drop")
	var elsewhere: Array[Vector3] = [source.global_position, target.global_position]
	var held: int = _pin_drop(field, twin, OWNER_SEED, fallen.global_position, TEST_MOTE, elsewhere)
	_expect(held == elsewhere.size() + 5, "%d of %d position probes held" % [held, elsewhere.size() + 5])
	print("  three Graveblades named %s under three rooms; the one killed (%s) by an event from the second at the third: died 1 / 0 / 0, 1 drop, the source's and target's bindings unheard"
		% [", ".join(names), " -> ".join(ladder)])
	print("  %d of %d probes held: the drop lies where the killed Graveblade died and pays its own %s — not the source's %s or the target's %s"
		% [held, elsewhere.size() + 5, _exact(TEST_MOTE), _exact(LESSER_MOTE), _exact(GREATER_MOTE)])
	_done("the_event_cannot_redirect_the_drop_to_another_graveblade")


# --- 6. A repeated death -------------------------------------------------------------------------------

func _check_a_repeated_death() -> void:
	print("")
	print("--- 6. Hits on a dead Graveblade change nothing, and a second lawful death after reset_encounter() reaches the binding and adds no drop")
	var spawn: Vector3 = Vector3(-20.0, 0.0, -20.0)
	var first_death: Vector3 = Vector3(-26.0, 0.0, -20.0)
	var enemy: PrototypeGraveblade = _graveblade("Repeated", spawn, null, _stage)
	var attacker: Node3D = _node("RepeatedAttacker", Vector3(-26.0, 0.0, -18.8))
	var field: RiftMoteField = RiftMoteField.new(OWNER_SEED)
	var binding: RiftGravebladeMoteBinding = RiftGravebladeMoteBinding.new(OWNER_SEED, enemy, field, TEST_MOTE)
	_expect_accepted(binding.connect_to_death(), "the repeated-death binding")
	enemy.place_at(first_death)
	var first: PackedStringArray = _kill(enemy, attacker, enemy)
	var first_answer: String = binding.emission_answer()
	_expect(_died(enemy) == 1 and field.drop_count() == 1 and binding.is_emitted() and first_answer.is_empty(),
		"the first death left %d died, %d drops, %s" % [_died(enemy), field.drop_count(), _binding(binding)])

	var events_before: int = enemy.damage_taken_events
	for _hit: int in 3:
		_strike(enemy, attacker, enemy)
	_expect(enemy.life == 0.0 and enemy.damage_taken_events == events_before and _took(enemy) == 3 and _died(enemy) == 1
			and field.drop_count() == 1,
		"hits on the dead Graveblade moved it: Life %s, %d events, %d died, %d drops" % [
			_life(enemy.life), enemy.damage_taken_events, _died(enemy), field.drop_count()])
	_expect_refused(binding.connect_to_death(), ALREADY_CONNECTED, "a connection after the death")

	enemy.reset_encounter()
	var restored: bool = enemy.is_alive() and enemy.life == 300.0 and enemy.global_position == spawn
	_expect(restored and _connections_to(enemy, binding) == 1,
		"reset_encounter() left alive=%s, Life %s at %s, %d binding connections" % [
			str(enemy.is_alive()), _life(enemy.life), str(enemy.global_position), _connections_to(enemy, binding)])
	var second: PackedStringArray = _kill(enemy, attacker, enemy)
	_expect(_died(enemy) == 2 and field.drop_count() == 1 and binding.has_observed_death() and binding.is_emitted()
			and binding.emission_answer() == first_answer and _connections_to(enemy, binding) == 1,
		"the second death left %d died, %d drops, %s" % [_died(enemy), field.drop_count(), _binding(binding)])
	var twin: RiftMoteField = RiftMoteField.new(OWNER_SEED)
	_expect_accepted(twin.spawn_drop(first_death, TEST_MOTE), "the twin's drop")
	var elsewhere: Array[Vector3] = [spawn]
	var held: int = _pin_drop(field, twin, OWNER_SEED, first_death, TEST_MOTE, elsewhere)
	_expect(held == elsewhere.size() + 5, "%d of %d position probes held" % [held, elsewhere.size() + 5])
	print("  first death (%s) at %s: 1 drop; 3 hits on the dead Graveblade were ignored — Life %s, died still 1, 1 drop"
		% [" -> ".join(first), str(first_death), _life(enemy.life) if not enemy.is_alive() else "0"])
	print("  reset_encounter() restored it at %s with the binding still connected; the second death (%s) fired died a second time and the field still holds 1 drop, emitted, answer '%s'"
		% [str(spawn), " -> ".join(second), binding.emission_answer()])
	print("  %d of %d probes held: the one drop lies where the FIRST death happened, not the second" % [held, elsewhere.size() + 5])
	_done("a_repeated_death_signal_adds_no_drop_and_replaces_no_outcome")


# --- 7. Two bound Graveblades ---------------------------------------------------------------------------

func _check_two_bound_graveblades() -> void:
	print("")
	print("--- 7. Two independently bound Graveblades emit two drops into one field, in the order they DIED")
	var bound_first: PrototypeGraveblade = _graveblade("BoundFirst", Vector3(60.0, 0.0, 0.0), null, _stage)
	var bound_second: PrototypeGraveblade = _graveblade("BoundSecond", Vector3(60.0, 0.0, 12.0), null, _stage)
	var attacker: Node3D = _node("PairAttacker", Vector3(60.0, 0.0, 6.0))
	var field: RiftMoteField = RiftMoteField.new(OWNER_SEED)
	var first_binding: RiftGravebladeMoteBinding = RiftGravebladeMoteBinding.new(OWNER_SEED, bound_first, field, TEST_MOTE)
	var second_binding: RiftGravebladeMoteBinding = RiftGravebladeMoteBinding.new(OWNER_SEED, bound_second, field, LESSER_MOTE)
	_expect_accepted(first_binding.connect_to_death(), "the first-bound binding")
	_expect_accepted(second_binding.connect_to_death(), "the second-bound binding")
	_kill(bound_second, attacker, bound_second)
	_expect(field.drop_count() == 1 and second_binding.is_emitted() and not first_binding.is_emitted(),
		"the second-bound Graveblade's death moved the first binding")
	_kill(bound_first, attacker, bound_first)
	_expect(field.drop_count() == 2 and first_binding.is_emitted() and second_binding.is_emitted(),
		"two deaths left %d drops" % field.drop_count())
	var run: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(OWNER_SEED)
	var twin: RiftMoteField = RiftMoteField.new(OWNER_SEED)
	var twin_run: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(OWNER_SEED)
	_expect_accepted(twin.spawn_drop(bound_second.global_position, LESSER_MOTE), "the twin's first drop")
	_expect_accepted(twin.spawn_drop(bound_first.global_position, TEST_MOTE), "the twin's second drop")
	var at_second: RiftMoteSweepResult = field.sweep_collection(bound_second.global_position, run)
	var paid_second: float = run.experience()
	var twin_at_second: RiftMoteSweepResult = twin.sweep_collection(bound_second.global_position, twin_run)
	var at_first: RiftMoteSweepResult = field.sweep_collection(bound_first.global_position, run)
	var paid_first: float = run.experience() - paid_second
	var twin_at_first: RiftMoteSweepResult = twin.sweep_collection(bound_first.global_position, twin_run)
	_expect(at_second.collected_indices() == PackedInt32Array([0]) and paid_second == LESSER_MOTE
			and at_first.collected_indices() == PackedInt32Array([1]) and paid_first == TEST_MOTE,
		"the sweeps answered %s (paid %s) then %s (paid %s)" % [_sweep(at_second), _exact(paid_second), _sweep(at_first), _exact(paid_first)])
	_expect(_sweep(at_second) == _sweep(twin_at_second) and _sweep(at_first) == _sweep(twin_at_first)
			and _snapshot(run) == _snapshot(twin_run),
		"the field and a twin given the same two drops directly answered differently")
	print("  bound first (%s) and second (%s), killed second-bound first: from where the second-bound fell the sweep collected %s paying %s; from where the first-bound fell, %s paying %s — as a twin answered"
		% [_exact(TEST_MOTE), _exact(LESSER_MOTE), str(at_second.collected_indices()), _exact(paid_second),
			str(at_first.collected_indices()), _exact(paid_first)])
	_done("two_bound_graveblades_emit_two_independently_ordered_drops")


# --- 8. Deaths award nothing -----------------------------------------------------------------------------

func _check_deaths_award_nothing() -> void:
	print("")
	print("--- 8. Deaths award no experience; a later sweep through the matching run collects both drops in insertion order and pays the exact sum")
	var run: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(OWNER_SEED)
	var before: String = _snapshot(run)
	var north: PrototypeGraveblade = _graveblade("North", Vector3(80.0, 0.0, -1.5), null, _stage)
	var south: PrototypeGraveblade = _graveblade("South", Vector3(80.0, 0.0, 1.5), null, _stage)
	var attacker: Node3D = _node("SweepAttacker", Vector3(81.2, 0.0, 0.0))
	var field: RiftMoteField = RiftMoteField.new(OWNER_SEED)
	var north_binding: RiftGravebladeMoteBinding = RiftGravebladeMoteBinding.new(OWNER_SEED, north, field, TEST_MOTE)
	var south_binding: RiftGravebladeMoteBinding = RiftGravebladeMoteBinding.new(OWNER_SEED, south, field, LESSER_MOTE)
	_expect_accepted(north_binding.connect_to_death(), "the north binding")
	_expect_accepted(south_binding.connect_to_death(), "the south binding")
	_kill(south, attacker, south)
	var after_one: String = _snapshot(run)
	_kill(north, attacker, north)
	var after_both: String = _snapshot(run)
	_expect(after_one == before and after_both == before and field.drop_count() == 2 and field.collected_count() == 0,
		"the deaths moved the run: %s -> %s -> %s" % [before, after_one, after_both])
	var midpoint: Vector3 = Vector3(80.0, 0.0, 0.0)
	var result: RiftMoteSweepResult = field.sweep_collection(midpoint, run)
	_expect(result.ok and result.collected_indices() == PackedInt32Array([0, 1])
			and run.experience() == LESSER_MOTE + TEST_MOTE and run.level() == 1 and not run.is_offer_active(),
		"the sweep answered %s and the run reads %s" % [_sweep(result), _snapshot(run)])
	var paid: String = _snapshot(run)
	var again: RiftMoteSweepResult = field.sweep_collection(midpoint, run)
	_expect(again.ok and again.skipped_count == 2 and again.attempted_count == 0 and _snapshot(run) == paid,
		"a resweep answered %s" % _sweep(again))
	print("  2 deaths left the run exactly as it was (%s) and the field 2 drops, 0 collected"
		% before)
	print("  one sweep 1.5 m from both collected %s and delivered %s = %s + %s; a resweep skipped both and paid nothing"
		% [str(result.collected_indices()), _exact(run.experience()), _exact(LESSER_MOTE), _exact(TEST_MOTE)])
	_done("deaths_award_nothing_and_a_later_sweep_collects_both_in_order")


# --- 9. Configuration refusals ---------------------------------------------------------------------------

func _check_configuration_refusals() -> void:
	print("")
	print("--- 9. No Graveblade, no field, an unusable amount and another run's field are each refused before anything connects")
	var enemy: PrototypeGraveblade = _graveblade("Refused", Vector3(100.0, 0.0, 0.0), null, _stage)
	var field: RiftMoteField = RiftMoteField.new(OWNER_SEED)
	var stranger: RiftMoteField = RiftMoteField.new(STRANGER_SEED)
	var baseline: int = enemy.died.get_connections().size()
	var nan_reason: String = RiftExperienceMote.new(NAN).problem()
	var doomed: PrototypeGraveblade = _graveblade("Doomed", Vector3(104.0, 0.0, 0.0), null, _stage)
	var doomed_binding: RiftGravebladeMoteBinding = RiftGravebladeMoteBinding.new(OWNER_SEED, doomed, field, TEST_MOTE)
	doomed.free()

	var cases: Array = [
		["no Graveblade", RiftGravebladeMoteBinding.new(OWNER_SEED, null, field, TEST_MOTE), NO_ENEMY],
		["a Graveblade that no longer exists", doomed_binding, NO_ENEMY],
		["no field", RiftGravebladeMoteBinding.new(OWNER_SEED, enemy, null, TEST_MOTE), NO_FIELD],
		["another run's field", RiftGravebladeMoteBinding.new(OWNER_SEED, enemy, stranger, TEST_MOTE), _wrong_run("99", "100")],
		["no Graveblade before no field, an unusable amount and another run", RiftGravebladeMoteBinding.new(OWNER_SEED, null, null, NAN), NO_ENEMY],
		["no field before an unusable amount", RiftGravebladeMoteBinding.new(OWNER_SEED, enemy, null, NAN), NO_FIELD],
		["an unusable amount before another run's field", RiftGravebladeMoteBinding.new(OWNER_SEED, enemy, stranger, NAN), nan_reason],
	]
	var amounts: PackedStringArray = PackedStringArray()
	for row: Array in UNUSABLE_BASES:
		var amount: float = float(row[1])
		var own: String = RiftExperienceMote.new(amount).problem()
		_expect(not own.is_empty() and RiftEnemyMoteEmission.new(OWNER_SEED, amount).problem() == own,
			"%s: H6 does not answer with H1's own reason" % String(row[0]))
		cases.append([String(row[0]), RiftGravebladeMoteBinding.new(OWNER_SEED, enemy, field, amount), own])
		amounts.append(String(row[0]))

	var verbatim: int = 0
	var refused_bindings: Array[RiftGravebladeMoteBinding] = []
	for row: Array in cases:
		var binding: RiftGravebladeMoteBinding = row[1] as RiftGravebladeMoteBinding
		var answer: String = binding.connect_to_death()
		_expect_refused(answer, String(row[2]), String(row[0]))
		if answer == String(row[2]):
			verbatim += 1
		_expect(not binding.has_connected() and enemy.died.get_connections().size() == baseline
				and _connections_to(enemy, binding) == 0 and field.drop_count() == 0 and stranger.drop_count() == 0,
			"%s connected or moved something: %s" % [String(row[0]), _binding(binding)])
		refused_bindings.append(binding)
	var ladder: PackedStringArray = _kill(enemy, _node("RefusedAttacker", Vector3(100.0, 0.0, 1.2)), enemy)
	var heard: int = 0
	for binding: RiftGravebladeMoteBinding in refused_bindings:
		if binding.has_observed_death() or binding.is_emitted():
			heard += 1
	_expect(_died(enemy) == 1 and heard == 0 and field.drop_count() == 0 and stranger.drop_count() == 0,
		"the Graveblade's death reached %d refused bindings and made %d + %d drops" % [heard, field.drop_count(), stranger.drop_count()])
	print("  %d of %d refusals word for word — no Graveblade, one that no longer exists, no field, another run's field, three in precedence order, and %s with H1's own reason — each connecting nothing"
		% [verbatim, cases.size(), ", ".join(amounts)])
	print("  no Graveblade: '%s'; no field: '%s'; another run: '%s'" % [NO_ENEMY, NO_FIELD, _wrong_run("99", "100")])
	print("  the Graveblade then died (%s): died %d, %d refused bindings heard it, 0 drops anywhere" % [" -> ".join(ladder), _died(enemy), heard])
	_done("every_configuration_refusal_happens_before_connection")


# --- 10. Low 32 bits ---------------------------------------------------------------------------------------

func _check_low_32_bit_owners() -> void:
	print("")
	print("--- 10. Run seeds that share their low 32 bits are different owners, across negative, minimum and maximum seeds")
	var shared: PrototypeGraveblade = _graveblade("SeedRefusals", Vector3(120.0, 0.0, 0.0), null, _stage)
	var baseline: int = shared.died.get_connections().size()
	var refused_fields: Array[RiftMoteField] = []
	var refused: int = 0
	var low_agreeing: int = 0
	var accepted: int = 0
	var collected: int = 0
	var column: int = 0
	for emission_row: Array in SEED_FAMILIES:
		for field_row: Array in SEED_FAMILIES:
			var binding_seed: int = int(emission_row[0])
			var field_seed: int = int(field_row[0])
			var field: RiftMoteField = RiftMoteField.new(field_seed)
			if binding_seed == field_seed:
				column += 1
				var own: PrototypeGraveblade = _graveblade("Seed%d" % column, Vector3(120.0, 0.0, 8.0 * column), null, _stage)
				var binding: RiftGravebladeMoteBinding = RiftGravebladeMoteBinding.new(binding_seed, own, field, TEST_MOTE)
				_expect_accepted(binding.connect_to_death(), "seed %s's own binding" % String(emission_row[1]))
				_kill(own, own, own)
				var run: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(binding_seed)
				var result: RiftMoteSweepResult = field.sweep_collection(own.global_position, run)
				if binding.is_emitted() and result.collected_indices() == PackedInt32Array([0]) and run.experience() == TEST_MOTE:
					accepted += 1
				continue
			var binding_refused: RiftGravebladeMoteBinding = RiftGravebladeMoteBinding.new(binding_seed, shared, field, TEST_MOTE)
			var answer: String = binding_refused.connect_to_death()
			_expect_refused(answer, _wrong_run(String(emission_row[1]), String(field_row[1])),
				"seed %s bound to seed %s's field" % [String(emission_row[1]), String(field_row[1])])
			if not answer.is_empty() and not binding_refused.has_connected():
				refused += 1
			if (binding_seed & LOW_32_MASK) == (field_seed & LOW_32_MASK):
				low_agreeing += 1
			refused_fields.append(field)
	_kill(shared, shared, shared)
	var untouched: int = 0
	for field: RiftMoteField in refused_fields:
		if field.drop_count() == 0:
			untouched += 1
	_expect(accepted == 6 and refused == 30 and low_agreeing == 12 and untouched == 30
			and shared.died.get_connections().size() == baseline and _died(shared) == 1,
		"%d accepted and collected, %d refused (%d agreeing in their low 32 bits), %d fields untouched by the death" % [
			accepted, refused, low_agreeing, untouched])
	var spellings: PackedStringArray = PackedStringArray()
	for row: Array in SEED_FAMILIES:
		spellings.append(String(row[1]))
	print("  seeds %s: %d of 36 binding-field pairs connected, and each Graveblade's drop was collected by its own run; %d refused naming both seeds in full, %d of them seeds that agree in their low 32 bits"
		% [", ".join(spellings), accepted, refused, low_agreeing])
	print("  the Graveblade all %d refused bindings named then died: %d of %d of their fields hold 0 drops" % [refused, untouched, refused_fields.size()])
	print("  0 and 4294967296: '%s'" % _wrong_run("0", "4294967296"))
	_done("seeds_agreeing_in_their_low_32_bits_are_different_owners")


# --- 11. A callback refusal ---------------------------------------------------------------------------------

func _check_a_callback_refusal() -> void:
	print("")
	print("--- 11. A refusal met inside the callback is kept word for word, makes no drop, leaves H6 pending, and is never retried")
	var places: Array = [
		["x not a number", Vector3(NAN, 0.0, 0.0)],
		["y positive infinity", Vector3(0.0, INF, 0.0)],
		["z negative infinity", Vector3(0.0, 0.0, -INF)],
	]
	var kept: int = 0
	var not_retried: int = 0
	var spread: int = 0
	var first_answer: String = ""
	for index: int in places.size():
		var row: Array = places[index]
		var spawn: Vector3 = Vector3(140.0 + 6.0 * index, 0.0, 0.0)
		var enemy: PrototypeGraveblade = _graveblade("Unplaceable%d" % index, spawn, null, _stage)
		var field: RiftMoteField = RiftMoteField.new(OWNER_SEED)
		var binding: RiftGravebladeMoteBinding = RiftGravebladeMoteBinding.new(OWNER_SEED, enemy, field, TEST_MOTE)
		_expect_accepted(binding.connect_to_death(), "the %s binding" % String(row[0]))
		## THE EXPECTED ANSWER IS THE FIELD'S OWN, FOR WHERE THE GRAVEBLADE ACTUALLY
		## STANDS — read back from the engine, not the value assigned. Under a Node3D
		## parent one non-finite component spreads to all three.
		enemy.global_position = row[1]
		var stands: Vector3 = enemy.global_position
		if str(stands) == "(nan, nan, nan)" and str(row[1]) != str(stands):
			spread += 1
		var expected: String = RiftMoteField.new(OWNER_SEED).spawn_drop(stands, TEST_MOTE)
		_kill(enemy, enemy, enemy)
		var answer: String = binding.emission_answer()
		_refusals += 1
		_expect(not expected.is_empty() and answer == expected and binding.has_observed_death() and not binding.is_emitted()
				and field.drop_count() == 0 and _died(enemy) == 1 and binding.describe().contains("refused: " + expected),
			"%s: the callback kept '%s' (the field answers '%s'); %s, %d drops" % [
				String(row[0]), answer, expected, _binding(binding), field.drop_count()])
		if answer == expected:
			kept += 1
		if index == 0:
			first_answer = answer

		## NO RE-ARM AND NO RETRY. A connection is refused; then the Graveblade is
		## restored at its finite spawn, where a fresh emission WOULD succeed, and dies
		## again — and the binding still does not ask.
		_expect_refused(binding.connect_to_death(), ALREADY_CONNECTED, "%s: a connection after the refused death" % String(row[0]))
		enemy.reset_encounter()
		var control: RiftMoteField = RiftMoteField.new(OWNER_SEED)
		var would: String = RiftEnemyMoteEmission.new(OWNER_SEED, TEST_MOTE).emit_at(enemy.global_position, control)
		_kill(enemy, enemy, enemy)
		if would.is_empty() and control.drop_count() == 1 and enemy.global_position == spawn and _died(enemy) == 2 \
				and binding.emission_answer() == expected and not binding.is_emitted() and field.drop_count() == 0:
			not_retried += 1
	_expect(kept == places.size() and not_retried == places.size() and spread == places.size()
			and first_answer == NON_FINITE_EXAMPLE,
		"%d of %d refusals kept, %d of %d not retried, %d of %d world positions read back as (nan, nan, nan); the first read '%s'" % [
			kept, places.size(), not_retried, places.size(), spread, places.size(), first_answer])
	print("  %d of %d Graveblades given one non-finite component under a Node3D parent — x not a number, y positive infinity, z negative infinity — stood at (nan, nan, nan) by the engine's own reading"
		% [spread, places.size()])
	print("  %d of %d dying there: the callback kept the field's own answer for that place word for word — '%s' — with 0 drops, the death heard and H6 pending"
		% [kept, places.size(), first_answer])
	print("  %d of %d then refused a reconnection, were restored at a finite spawn where a fresh emission would have emitted, and died again: still 0 drops and the same answer — nothing retried"
		% [not_retried, places.size()])
	_done("a_callback_refusal_is_kept_word_for_word_and_never_retried")


# --- 12. An already-dead Graveblade (D-284) ------------------------------------------------------------

func _check_an_already_dead_graveblade() -> void:
	print("")
	print("--- 12. A fresh binding refuses an already-dead Graveblade atomically, and the same unused binding connects once after a lawful restore")
	var spawn: Vector3 = Vector3(220.0, 0.0, 0.0)
	var death: Vector3 = Vector3(226.0, 0.0, 0.0)
	var enemy: PrototypeGraveblade = _graveblade("AlreadyDead", spawn, null, _stage)
	var attacker: Node3D = _node("AlreadyDeadAttacker", Vector3(220.0, 0.0, 1.2))
	var baseline: int = enemy.died.get_connections().size()

	## 1-2. No binding exists while the Graveblade dies through its own receive_damage().
	var first: PackedStringArray = _kill(enemy, attacker, enemy)
	_expect(" -> ".join(first) == "300 -> 200 -> 100 -> 0" and not enemy.is_alive() and _died(enemy) == 1
			and enemy.died.get_connections().size() == baseline,
		"the unbound Graveblade's death read %s with %d died" % [" -> ".join(first), _died(enemy)])

	## 3-11. A fresh, otherwise coherent binding is refused — atomically, and again.
	var field: RiftMoteField = RiftMoteField.new(OWNER_SEED)
	var binding: RiftGravebladeMoteBinding = RiftGravebladeMoteBinding.new(OWNER_SEED, enemy, field, TEST_MOTE)
	var made: String = _whole(enemy, binding, field)
	var untouched: String = binding.emission_answer()
	var refused: int = 0
	for attempt: int in 2:
		var answer: String = binding.connect_to_death()
		_expect_refused(answer, ALREADY_DEAD, "connection attempt %d to an already-dead Graveblade" % (attempt + 1))
		var after: String = _whole(enemy, binding, field)
		_expect(after == made and _connections_to(enemy, binding) == 0 and not binding.has_connected()
				and not binding.has_observed_death() and not binding.is_emitted()
				and binding.emission_answer() == untouched and untouched.is_empty() and field.drop_count() == 0
				and not enemy.is_alive(),
			"connection attempt %d moved something: %s became %s" % [attempt + 1, made, after])
		if answer == ALREADY_DEAD and after == made:
			refused += 1
	var while_dead: String = _binding(binding)
	var own_while_dead: int = _connections_to(enemy, binding)
	var drops_while_dead: int = field.drop_count()

	## 12-14. The same Graveblade, lawfully restored; the same unused binding connects
	## exactly once and hears its next death.
	enemy.reset_encounter()
	var restored_at: Vector3 = enemy.global_position
	var restored_life: String = _life(enemy.life)
	_expect(enemy.is_alive() and enemy.life == 300.0 and restored_at == spawn,
		"reset_encounter() left alive=%s, Life %s at %s" % [str(enemy.is_alive()), restored_life, str(restored_at)])
	var connected: String = binding.connect_to_death()
	var connections_after: int = enemy.died.get_connections().size()
	var again: String = binding.connect_to_death()
	_expect(connected.is_empty() and binding.has_connected() and connections_after == baseline + 1
			and _connections_to(enemy, binding) == 1 and enemy.died.get_connections().size() == connections_after,
		"after the restore the binding answered '%s' and left %d connections (%d of them its own)" % [
			connected, connections_after, _connections_to(enemy, binding)])
	_expect_refused(again, ALREADY_CONNECTED, "a second connection after the restore")
	enemy.place_at(death)
	var second: PackedStringArray = _kill(enemy, attacker, enemy)
	_expect(_died(enemy) == 2 and field.drop_count() == 1 and binding.has_observed_death() and binding.is_emitted()
			and binding.emission_answer().is_empty(),
		"the restored Graveblade's death left %d died, %d drops, %s" % [_died(enemy), field.drop_count(), _binding(binding)])
	var drops_after_second: int = field.drop_count()

	## 15. A further revive and death cannot re-arm or emit through the consumed binding.
	enemy.reset_encounter()
	var third: PackedStringArray = _kill(enemy, attacker, enemy)
	var reconnect: String = binding.connect_to_death()
	_expect_refused(reconnect, ALREADY_CONNECTED, "a connection after the third death")
	_expect(_died(enemy) == 3 and field.drop_count() == 1 and binding.is_emitted() and binding.emission_answer().is_empty()
			and _connections_to(enemy, binding) == 1,
		"the third death left %d died, %d drops, %s" % [_died(enemy), field.drop_count(), _binding(binding)])
	var twin: RiftMoteField = RiftMoteField.new(OWNER_SEED)
	_expect_accepted(twin.spawn_drop(death, TEST_MOTE), "the twin's drop")
	var elsewhere: Array[Vector3] = [spawn]
	var held: int = _pin_drop(field, twin, OWNER_SEED, death, TEST_MOTE, elsewhere)
	_expect(held == elsewhere.size() + 5, "%d of %d position probes held" % [held, elsewhere.size() + 5])
	print("  a Graveblade killed with no binding (%s), then given a fresh coherent binding: %d of 2 connection attempts while it stayed dead answered '%s' and moved nothing — %d callbacks connected, %s, the field %d drops"
		% [" -> ".join(first), refused, ALREADY_DEAD, own_while_dead, while_dead, drops_while_dead])
	print("  reset_encounter() restored the same Graveblade alive at %s with Life %s; the same unused binding then connected ('%s') exactly once — a second attempt answered '%s'"
		% [str(restored_at), restored_life, connected, again])
	print("  killed at %s (%s): died %d, %d drop, answer '%s'; a further revive and death (%s, died %d) refused a reconnection ('%s') and added no drop — the field still holds %d"
		% [str(death), " -> ".join(second), 2, drops_after_second, binding.emission_answer(), " -> ".join(third), _died(enemy),
			reconnect, field.drop_count()])
	print("  %d of %d probes held: the one drop lies where the restored Graveblade died, not where it was restored" % [held, elsewhere.size() + 5])
	_done("a_fresh_binding_refuses_an_already_dead_graveblade_until_it_is_restored")


# --- 13. The death order ---------------------------------------------------------------------------------------

func _check_the_death_order() -> void:
	print("")
	print("--- 13. When the callback hears the death, the Graveblade is already dead, untargetable, nonblocking and holds no attack permission")
	var coordinator: AttackCoordinator = AttackCoordinator.new()
	coordinator.name = "H7Coordinator"
	_stage.add_child(coordinator)
	var enemy: PrototypeGraveblade = _graveblade("DeathOrder", Vector3(200.0, 0.0, 0.0), null, _stage)
	var attacker: Node3D = _node("DeathOrderAttacker", Vector3(200.0, 0.0, 1.2))
	enemy.setup(attacker, coordinator, null, Callable())
	var area: Area3D = enemy.get_node("TargetArea") as Area3D
	var field: RiftMoteField = RiftMoteField.new(OWNER_SEED)
	var binding: RiftGravebladeMoteBinding = RiftGravebladeMoteBinding.new(OWNER_SEED, enemy, field, TEST_MOTE)
	var began: bool = enemy.begin_attack_for_verification()
	var living: String = _death_state(enemy, coordinator, area, field, binding)
	_expect(began and coordinator.holds_permission(enemy) and enemy.state_name() == "ATTACK_WINDUP"
			and enemy.collision_layer == PrototypeGraveblade.ENEMY_LAYER
			and area.collision_layer == PrototypeTargetable.TARGET_LAYER and area.monitorable,
		"before the kill the Graveblade read %s" % living)
	var heard_before: PackedStringArray = PackedStringArray()
	enemy.died.connect(func(_event: DamageEvent) -> void:
		heard_before.append(_death_state(enemy, coordinator, area, field, binding)))
	_expect_accepted(binding.connect_to_death(), "the death-order binding")
	var heard_after: PackedStringArray = PackedStringArray()
	enemy.died.connect(func(_event: DamageEvent) -> void:
		heard_after.append(_death_state(enemy, coordinator, area, field, binding)))
	var ladder: PackedStringArray = _kill(enemy, attacker, enemy)
	var dead: String = "alive=false state=DEAD layer=0 mask=0 target_layer=0 monitorable=false permission=false holder=none animation=-1"
	_expect(heard_before == PackedStringArray([dead + " drops=0 heard=false emitted=false"]),
		"just before the binding's callback the Graveblade read %s" % ", ".join(heard_before))
	_expect(heard_after == PackedStringArray([dead + " drops=1 heard=true emitted=true"]),
		"just after the binding's callback the Graveblade read %s" % ", ".join(heard_after))
	_expect(enemy.death_animation_started_at_physics_frame != -1 and enemy.died_at_physics_frame != -1,
		"the death animation never started after the callback")
	print("  before the kill: %s" % living)
	print("  heard just before the binding: %s" % (heard_before[0] if heard_before.size() == 1 else "nothing"))
	print("  heard just after the binding:  %s" % (heard_after[0] if heard_after.size() == 1 else "nothing"))
	print("  the kill read %s; the death animation started only after every listener, inside the same call" % " -> ".join(ladder))
	_done("the_mechanical_death_is_complete_when_the_callback_hears_it")


func _death_state(enemy: PrototypeGraveblade, coordinator: AttackCoordinator, area: Area3D, field: RiftMoteField,
		binding: RiftGravebladeMoteBinding) -> String:
	return "alive=%s state=%s layer=%d mask=%d target_layer=%d monitorable=%s permission=%s holder=%s animation=%d drops=%d heard=%s emitted=%s" % [
		str(enemy.is_alive()), enemy.state_name(), enemy.collision_layer, enemy.collision_mask, area.collision_layer,
		str(area.monitorable), str(coordinator.holds_permission(enemy)),
		"none" if coordinator.holder() == null else String(coordinator.holder().name),
		enemy.death_animation_started_at_physics_frame, field.drop_count(), str(binding.has_observed_death()),
		str(binding.is_emitted()),
	]


# --- 14. The record does not decide ----------------------------------------------------------------------------

func _check_the_record_does_not_decide() -> void:
	print("")
	print("--- 14. The ordinary and elite Graveblade records do not decide the amount: equal amounts make equal drops, and the caller's amount is what is paid")
	var rows: Array = [
		["ordinary", _ordinary, TEST_MOTE], ["elite", _elite, TEST_MOTE],
		["ordinary", _ordinary, GREATER_MOTE], ["elite", _elite, LESSER_MOTE],
	]
	var paid: PackedStringArray = PackedStringArray()
	var ladders: PackedStringArray = PackedStringArray()
	var exact: int = 0
	for index: int in rows.size():
		var row: Array = rows[index]
		var record: GravebladeData = row[1] as GravebladeData
		var amount: float = float(row[2])
		var enemy: PrototypeGraveblade = _graveblade("Record%d" % index, Vector3(160.0 + 10.0 * index, 0.0, 0.0), record, _stage)
		var field: RiftMoteField = RiftMoteField.new(OWNER_SEED)
		var binding: RiftGravebladeMoteBinding = RiftGravebladeMoteBinding.new(OWNER_SEED, enemy, field, amount)
		_expect_accepted(binding.connect_to_death(), "the %s binding worth %s" % [String(row[0]), _exact(amount)])
		var ladder: PackedStringArray = _kill(enemy, enemy, enemy)
		var run: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(OWNER_SEED)
		var result: RiftMoteSweepResult = field.sweep_collection(enemy.global_position, run)
		if result.collected_indices() == PackedInt32Array([0]) and run.experience() == amount and enemy.data == record:
			exact += 1
		paid.append("%s %s" % [String(row[0]), _exact(run.experience())])
		if index < 2:
			ladders.append("%s %s" % [String(row[0]), " -> ".join(ladder)])
	_expect(exact == rows.size(), "%d of %d drops paid exactly the caller's amount: %s" % [exact, rows.size(), ", ".join(paid)])
	_expect(_ordinary.experience_reward == _elite.experience_reward and float(_ordinary.experience_reward) != TEST_MOTE
			and float(_elite.experience_reward) != LESSER_MOTE and float(_ordinary.experience_reward) != GREATER_MOTE
			and _ordinary.max_life == 300.0 and _elite.max_life == 600.0,
		"the records do not read as expected: %d / %d experience_reward, %s / %s Life" % [
			_ordinary.experience_reward, _elite.experience_reward, _life(_ordinary.max_life), _life(_elite.max_life)])
	print("  %s" % "; ".join(ladders))
	print("  both records carry %d in their own reward field; %d of %d drops paid exactly the caller's amount: %s"
		% [_ordinary.experience_reward, exact, rows.size(), ", ".join(paid)])
	_done("the_graveblade_record_does_not_decide_the_amount")


# --- 15. The fields and the orders -----------------------------------------------------------------------------

func _check_the_fields_and_orders() -> void:
	print("")
	print("--- 15. Six declared fields, written in six places; the connection order and the callback pinned step by step; nothing handed out")
	var raw: String = FileAccess.get_file_as_string(BINDING_FILE)
	var code: String = _code_only(raw)
	_expect(raw.length() > 3000 and code.length() > 1000, "the file reads as %d / %d characters" % [raw.length(), code.length()])

	var signatures: PackedStringArray = _signatures_of(BINDING_FILE)
	_expect(signatures == PackedStringArray(BINDING_SIGNATURES), "the binding declares: %s" % " | ".join(signatures))
	var script: GDScript = load(BINDING_FILE) as GDScript
	_expect(script.get_script_constant_map().is_empty() and script.get_script_signal_list().is_empty(),
		"the binding declares constants or signals")

	var declarations: PackedStringArray = PackedStringArray()
	for line: String in code.split("\n"):
		if line.begins_with("var ") or line.begins_with("static ") or line.begins_with("const ") \
				or line.begins_with("signal ") or line.begins_with("enum ") or line.begins_with("@"):
			declarations.append(line.strip_edges())
	_expect(declarations == PackedStringArray(BINDING_DECLARATIONS), "the top-level declarations are: %s" % " | ".join(declarations))

	var probe: RiftGravebladeMoteBinding = RiftGravebladeMoteBinding.new(OWNER_SEED, null, null, TEST_MOTE)
	var names: PackedStringArray = PackedStringArray()
	var typed: int = 0
	var collections: int = 0
	for entry: Dictionary in probe.get_property_list():
		if int(entry.get("usage", 0)) & PROPERTY_USAGE_SCRIPT_VARIABLE == 0:
			continue
		var type_id: int = int(entry.get("type", 0))
		if names.size() < BINDING_TYPES.size() and type_id == BINDING_TYPES[names.size()]:
			typed += 1
		if type_id == TYPE_ARRAY or type_id == TYPE_DICTIONARY:
			collections += 1
		names.append(String(entry.get("name", "")))
	_expect(names == PackedStringArray(BINDING_FIELDS) and typed == BINDING_FIELDS.size() and collections == 0,
		"the binding holds %s" % ", ".join(names))

	var writes: PackedStringArray = PackedStringArray()
	var write: RegEx = RegEx.create_from_string("^\\s*(_enemy|_field|_emission|_connected|_death_observed|_emission_answer)\\s*([-+*/]?=)(?!=)")
	for line: String in code.split("\n"):
		if write.search(line) != null:
			writes.append(line.strip_edges())
	_expect(writes == PackedStringArray(BINDING_WRITES), "the fields are written as: %s" % " | ".join(writes))

	## THE CONNECTION ORDER, EACH STEP ONCE, EACH GATE RETURNING ON ITS NEXT LINE,
	## AND THE CONNECTION AND ITS MARK LAST.
	var body: PackedStringArray = _method_code(code, "func connect_to_death(")
	var misplaced: PackedStringArray = PackedStringArray()
	var previous: int = -1
	for step: String in CONNECT_ORDER:
		var at: int = body.find(step)
		if at <= previous or body.count(step) != 1:
			misplaced.append(step)
		previous = at
	_expect(misplaced.is_empty(), "connection steps out of order or repeated: %s" % " | ".join(misplaced))
	var returning: int = 0
	for gate: String in RETURNING_GATES:
		var at: int = body.find(gate)
		if at >= 0 and at + 1 < body.size() and body[at + 1].begins_with("return "):
			returning += 1
	_expect(returning == RETURNING_GATES.size(), "%d of %d gates return on their next line" % [returning, RETURNING_GATES.size()])
	## D-284: THE DEAD-GRAVEBLADE GATE IS PLACED, NOT MERELY PRESENT — directly after the
	## delivered listening gate and its return, directly before the real connection.
	_expect(body.size() >= 7 and body[body.size() - 7] == "if _enemy.died.is_connected(_on_enemy_died):"
			and body[body.size() - 6] == "return \"" + ALREADY_LISTENING + "\""
			and body[body.size() - 5] == "if not _enemy.is_alive():"
			and body[body.size() - 4] == "return \"" + ALREADY_DEAD + "\""
			and body[body.size() - 3] == "_enemy.died.connect(_on_enemy_died)"
			and body[body.size() - 2] == "_connected = true" and body[body.size() - 1] == "return \"\"",
		"the dead-Graveblade gate, the connection and its mark are not the last steps of connect_to_death(): %s"
			% " | ".join(body.slice(maxi(body.size() - 7, 0))))

	var callback: PackedStringArray = _method_code(code, "func _on_enemy_died(")
	_expect(callback == PackedStringArray(CALLBACK_BODY), "the callback reads: %s" % " | ".join(callback))

	var returns: PackedStringArray = PackedStringArray()
	for line: String in code.split("\n"):
		var stripped: String = line.strip_edges()
		if stripped == "return" or stripped.begins_with("return "):
			returns.append(stripped)
	_expect(returns == PackedStringArray(BINDING_RETURNS), "the binding returns: %s" % " | ".join(returns))

	## EACH HELD OBJECT IS ASKED EXACTLY WHAT IT MAY BE ASKED, AND THE EVENT NOTHING.
	var asked: Array = [["_enemy", ENEMY_CALLS], ["_field", FIELD_CALLS], ["_emission", EMISSION_CALLS]]
	var reached: PackedStringArray = PackedStringArray()
	for row: Array in asked:
		var calls: Dictionary = {}
		for hit: RegExMatch in RegEx.create_from_string("\\b%s\\.([A-Za-z_]+)" % String(row[0])).search_all(code):
			calls[hit.get_string(1)] = int(calls.get(hit.get_string(1), 0)) + 1
		var expected_calls: Dictionary = {}
		for pair: Array in row[1]:
			expected_calls[String(pair[0])] = int(pair[1])
		_expect(calls == expected_calls, "%s is asked: %s" % [String(row[0]), str(calls)])
		reached.append("%s %s" % [String(row[0]), str(calls)])
	_expect(code.count("_event") == 1 and code.count(".new(") == 1
			and code.count("RiftEnemyMoteEmission.new(for_run_seed, for_base_experience)") == 1
			and code.count("emit_at(") == 1 and code.count("died.connect(") == 1,
		"the event is read, or the emission is made, asked or connected more than once")

	## NOTHING IS HANDED OUT: only the constructor declares an object answer, and
	## every reading of a live binding answers a scalar or a string.
	var object_answers: PackedStringArray = PackedStringArray()
	for signature: String in signatures:
		if signature.ends_with("-> Object"):
			object_answers.append(signature.get_slice("(", 0))
	var readings: Array = [probe.has_connected(), probe.has_observed_death(), probe.is_emitted(), probe.emission_answer(), probe.describe()]
	var leaked: int = 0
	for value: Variant in readings:
		if typeof(value) in [TYPE_OBJECT, TYPE_ARRAY, TYPE_DICTIONARY, TYPE_NIL]:
			leaked += 1
	_expect(object_answers == PackedStringArray(["_init"]) and leaked == 0,
		"these methods declare an object answer: %s; %d readings answered an object" % [", ".join(object_answers), leaked])

	var deferred: PackedStringArray = PackedStringArray()
	for signature: String in signatures:
		var method: String = signature.get_slice("(", 0)
		for token: String in DEFERRED_MEMBER_TOKENS:
			if method.contains(token):
				deferred.append("%s (%s)" % [method, token])
	_expect(deferred.is_empty(), "deferred members: %s" % ", ".join(deferred))
	print("  %d fields declared exactly (%s), %d collections; written only as %s"
		% [declarations.size(), ", ".join(names), collections, ", ".join(writes)])
	print("  %d methods pinned, none defaulting an argument, only _init declaring an object answer; %d connection steps in order, each once; %d gates each return on the next line; the dead-Graveblade gate last among them, immediately before the connection, and the connection and its mark last"
		% [signatures.size(), CONNECT_ORDER.size(), returning])
	print("  the callback is exactly: %s" % " | ".join(callback))
	print("  %d return lines pinned; asked: %s; the event is named once, in the callback's signature, and read never; %d reset, retry, re-arm, copy, setter or position members"
		% [returns.size(), "; ".join(reached), deferred.size()])
	_done("the_binding_holds_six_fields_and_its_orders_are_pinned")


# --- 16. The shape ---------------------------------------------------------------------------------------------

func _check_the_shape() -> void:
	print("")
	print("--- 16. The binding names no balance value, no enemy record and no other foundation's member, and names only what it composes")
	var raw: String = FileAccess.get_file_as_string(BINDING_FILE)
	var code: String = _code_only(raw)
	var hits: PackedStringArray = PackedStringArray()
	for token: String in FORBIDDEN_TOKENS:
		if raw.contains(token):
			hits.append(token)
	## Behaviour is read from CODE WITH ITS STRINGS EMPTIED: a refusal sentence may say
	## "listening for" without the binding looping over anything.
	var bare: String = RegEx.create_from_string("\"([^\"\\\\]|\\\\.)*\"").sub(code, "\"\"", true)
	for token: String in BEHAVIOUR_TOKENS:
		if bare.contains(token):
			hits.append("code: %s" % token)
	for operator: String in ["+", "*", "/", "&", "|", "^", "<<", ">>"]:
		if bare.contains(operator):
			hits.append("operator %s" % operator)
	if bare.replace("->", "").contains("-"):
		hits.append("operator -")
	var formats: int = RegEx.create_from_string("\"\"\\s*%").search_all(bare).size()
	if bare.count("%") != formats or formats != 3:
		hits.append("%% outside formatting (%d of %d)" % [formats, bare.count("%")])
	var literals: PackedStringArray = _numeric_literals(code)
	if not literals.is_empty():
		hits.append("literals %s" % str(literals))
	_expect(hits.is_empty(), "the binding names or does: %s" % ", ".join(hits))

	## PER-FILE CLASS ALLOWLIST FROM THE ENGINE'S OWN CLASS LIST, BOTH DIRECTIONS.
	var all_classes: PackedStringArray = PackedStringArray()
	for entry: Dictionary in ProjectSettings.get_global_class_list():
		all_classes.append(String(entry.get("class", "")))
	_expect(all_classes.size() > 100 and all_classes.has(BINDING_CLASS),
		"%d project classes were enumerated, the binding %s among them" % [
			all_classes.size(), "is" if all_classes.has(BINDING_CLASS) else "is NOT"])
	var overlaps: PackedStringArray = PackedStringArray()
	for class_id: String in all_classes:
		if class_id != BINDING_CLASS and (class_id.contains(BINDING_CLASS) or BINDING_CLASS.contains(class_id)):
			overlaps.append(class_id)
	_expect(overlaps.is_empty(), "the binding's class name overlaps: %s" % ", ".join(overlaps))
	var misnamed: PackedStringArray = PackedStringArray()
	for class_id: String in all_classes:
		var named: bool = raw.contains(class_id)
		if named != BINDING_NAMES.has(class_id):
			misnamed.append("%s %s" % ["names" if named else "does not name", class_id])
	_expect(misnamed.is_empty(), "the allowlist does not hold: %s" % ", ".join(misnamed))
	print("  %d hits for %d balance, record, enemy-content, storage and other-foundation tokens and %d behaviour tokens; no arithmetic; %% only in its %d formatted sentences; literals %s"
		% [hits.size(), FORBIDDEN_TOKENS.size(), BEHAVIOUR_TOKENS.size(), formats, str(literals)])
	print("  the binding names only %s; its name overlaps %d other class names; %d project classes read"
		% [", ".join(PackedStringArray(BINDING_NAMES)), overlaps.size(), all_classes.size()])
	_done("the_binding_names_no_balance_and_only_what_it_composes")


# --- 17. Unwired ---------------------------------------------------------------------------------------------------

func _check_nothing_runs_it() -> void:
	print("")
	print("--- 17. Nothing that runs creates or connects a binding, and scripts/experience/ holds six scripts")
	var project_files: int = 0
	var referenced: PackedStringArray = PackedStringArray()
	for root_path: String in SCANNED_ROOTS:
		for path: String in _files_under(root_path, [".gd", ".tscn", ".tres"]):
			if path == BINDING_FILE:
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
	_expect(referenced.is_empty(), "something that runs creates or connects a binding: %s" % ", ".join(referenced))
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
	print("  %d unauthorized project files create or connect a binding (%d reader granted by file and token); scripts/experience/ holds %d scripts; %d actions; %d files scanned"
		% [referenced.size(), AUTHORIZED_READERS.size(), experience_scripts.size(), actions, project_files])
	print("  %d refusals were asserted and %d Graveblade deaths were driven across this suite"
		% [_refusals, _deaths_driven])
	_done("nothing_that_runs_creates_a_binding_and_the_directory_holds_six_scripts")


## Whether `path` is granted `token` in `AUTHORIZED_READERS`.
func _reader_may_name(path: String, token: String) -> bool:
	for row: Array in AUTHORIZED_READERS:
		if String(row[0]) == path:
			return (row[1] as Array).has(token)
	return false


# --- Fixtures ---------------------------------------------------------------------------------------------

## One production Graveblade, named `node_name`, placed at `at` BEFORE it enters the
## tree — so its own `_ready()` latches that place as its spawn — under `parent`,
## with `record` in place of the scene's own when one is given. Its `died` and
## `took_damage` are counted by this harness's own observers, connected first.
func _graveblade(node_name: String, at: Vector3, record: GravebladeData, parent: Node3D) -> PrototypeGraveblade:
	var enemy: PrototypeGraveblade = (load(GRAVEBLADE_SCENE) as PackedScene).instantiate() as PrototypeGraveblade
	enemy.name = node_name
	if record != null:
		enemy.data = record
	enemy.position = at
	parent.add_child(enemy)
	var id: int = enemy.get_instance_id()
	_deaths[id] = 0
	_hits[id] = 0
	enemy.died.connect(func(_event: DamageEvent) -> void: _deaths[id] = int(_deaths[id]) + 1)
	enemy.took_damage.connect(func(_event: DamageEvent) -> void: _hits[id] = int(_hits[id]) + 1)
	return enemy


func _node(node_name: String, at: Vector3) -> Node3D:
	var node: Node3D = Node3D.new()
	node.name = node_name
	node.position = at
	_stage.add_child(node)
	return node


func _parent(node_name: String) -> Node3D:
	return _node(node_name, Vector3.ZERO)


## One accepted hit of `HIT` through the Graveblade's own public `receive_damage()`,
## with a fresh use id and the given attacker and target.
func _strike(enemy: PrototypeGraveblade, source: Node, target: Node) -> void:
	_use += 1
	enemy.receive_damage(DamageEvent.physical(_use, source, target, HIT))


## Strikes until the Graveblade is dead — bounded — and returns its Life ladder.
func _kill(enemy: PrototypeGraveblade, source: Node, target: Node) -> PackedStringArray:
	var ladder: PackedStringArray = PackedStringArray([_life(enemy.life)])
	for _attempt: int in 20:
		if not enemy.is_alive():
			break
		_strike(enemy, source, target)
		ladder.append(_life(enemy.life))
	_deaths_driven += 1
	return ladder


func _died(enemy: PrototypeGraveblade) -> int:
	return int(_deaths.get(enemy.get_instance_id(), -1))


func _took(enemy: PrototypeGraveblade) -> int:
	return int(_hits.get(enemy.get_instance_id(), -1))


## How many of the Graveblade's `died` connections call into `binding`.
func _connections_to(enemy: PrototypeGraveblade, binding: RiftGravebladeMoteBinding) -> int:
	var count: int = 0
	for connection: Dictionary in enemy.died.get_connections():
		var callable: Callable = connection.get("callable", Callable()) as Callable
		if callable.get_object() == binding:
			count += 1
	return count


## The binding's ownership refusal, typed here from the two seeds' exact spellings.
func _wrong_run(binding_seed: String, field_seed: String) -> String:
	return "this Graveblade's Experience Mote belongs to run seed " + binding_seed \
		+ ", not to the mote field's run seed " + field_seed + "; it may be bound only to a field of its own run"


## Pins the ONE uncollected drop in `field` to `where` and to exactly `amount`,
## against `twin` — a field given that drop directly — by sweeping both from the
## same player positions into two fresh runs of `run_seed`: every place in
## `elsewhere`, then one float32 spacing beyond the inclusive 2.5 m boundary on each
## of the four axis sides of `where`, each of which must find nothing in range; then
## exactly 2.5 m from `where`, which must collect it and pay exactly `amount`. Every
## probe must answer as the twin does. Returns how many probes held.
func _pin_drop(field: RiftMoteField, twin: RiftMoteField, run_seed: int, where: Vector3, amount: float,
		elsewhere: Array[Vector3]) -> int:
	var run: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(run_seed)
	var twin_run: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(run_seed)
	var probes: Array[Vector3] = []
	probes.append_array(elsewhere)
	probes.append(Vector3(_beyond(where.x + BOUNDARY, 1.0), where.y, where.z))
	probes.append(Vector3(_beyond(where.x - BOUNDARY, -1.0), where.y, where.z))
	probes.append(Vector3(where.x, where.y, _beyond(where.z + BOUNDARY, 1.0)))
	probes.append(Vector3(where.x, where.y, _beyond(where.z - BOUNDARY, -1.0)))
	var held: int = 0
	for probe: Vector3 in probes:
		var across: float = probe.x - where.x
		var along: float = probe.z - where.z
		var result: RiftMoteSweepResult = field.sweep_collection(probe, run)
		var twin_result: RiftMoteSweepResult = twin.sweep_collection(probe, twin_run)
		if (sqrt(across * across + along * along) > BOUNDARY and result.ok and result.attempted_count == 1
				and result.out_of_range_count == 1 and result.collected_indices().is_empty() and run.experience() == 0.0
				and _sweep(result) == _sweep(twin_result)):
			held += 1
	var edge: Vector3 = Vector3(where.x, where.y, where.z - BOUNDARY)
	var collected: RiftMoteSweepResult = field.sweep_collection(edge, run)
	var twin_collected: RiftMoteSweepResult = twin.sweep_collection(edge, twin_run)
	if (edge.z == where.z - BOUNDARY and collected.ok and collected.collected_indices().size() == 1
			and run.experience() == amount and _sweep(collected) == _sweep(twin_collected)
			and _snapshot(run) == _snapshot(twin_run)):
		held += 1
	return held


## The next world-position component beyond `value` in `direction`, as the engine
## stores it: a Vector3 component is single precision, so this is one float32
## spacing, read back from a Vector3 rather than computed.
func _beyond(value: float, direction: float) -> float:
	var step: float = 1.0
	while Vector3(value + direction * step * 0.5, 0.0, 0.0).x != value:
		step *= 0.5
	return Vector3(value + direction * step, 0.0, 0.0).x


# --- Assertions -------------------------------------------------------------------------------------------

func _expect_accepted(refusal: String, described: String) -> void:
	_expect(refusal.is_empty(), "%s was refused: %s" % [described, refusal])


func _expect_refused(answer: String, expected: String, described: String) -> void:
	_refusals += 1
	_expect(not expected.is_empty() and answer == expected, "%s answered '%s', not '%s'" % [described, answer, expected])


# --- Snapshots -----------------------------------------------------------------------------------------------

func _snapshot(run: RiftRunLevelCoordinator) -> String:
	return "seed=%d level=%d experience=%s offer=%s" % [
		run.run_seed(), run.level(), _exact(run.experience()), str(run.is_offer_active())]


func _binding(binding: RiftGravebladeMoteBinding) -> String:
	return "connected=%s heard=%s emitted=%s answer='%s'" % [
		str(binding.has_connected()), str(binding.has_observed_death()), str(binding.is_emitted()), binding.emission_answer()]


func _field(field: RiftMoteField) -> String:
	return "seed=%d drops=%d collected=%d uncollected=%d problem='%s'" % [
		field.run_seed(), field.drop_count(), field.collected_count(), field.uncollected_count(), field.problem()]


## EVERYTHING A REFUSED CONNECTION COULD HAVE MOVED, AS ONE LINE: whether the
## Graveblade lives, every connection its `died` holds and how many are the binding's,
## the binding's four readings and description, and the whole field.
func _whole(enemy: PrototypeGraveblade, binding: RiftGravebladeMoteBinding, field: RiftMoteField) -> String:
	return "alive=%s connections=%d own=%d %s describe='%s' | %s" % [
		str(enemy.is_alive()), enemy.died.get_connections().size(), _connections_to(enemy, binding),
		_binding(binding), binding.describe(), _field(field)]


func _sweep(result: RiftMoteSweepResult) -> String:
	return "ok=%s reason='%s' total=%d skipped=%d attempted=%d collected=%s out=%d refused=%d first='%s'" % [
		str(result.ok), result.failure_reason, result.total_count, result.skipped_count, result.attempted_count,
		result.collected_indices(), result.out_of_range_count, result.item_refusal_count, result.first_item_refusal_reason,
	]


func _life(value: float) -> String:
	return String.num(value, 0)


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
## rendering the accepted H1–H6 and G4 pins use.
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
		_:
			return "type %d" % type_id


func _files_under(root_path: String, extensions: Array[String]) -> PackedStringArray:
	var out: PackedStringArray = PackedStringArray()
	var dir: DirAccess = DirAccess.open(root_path)
	if dir == null:
		return out
	dir.list_dir_begin()
	var entry: String = dir.get_next()
	while not entry.is_empty():
		if entry != "." and entry != "..":
			var full: String = root_path.path_join(entry)
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
