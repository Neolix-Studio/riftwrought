extends SceneTree
## Riftwrought — Roguelite Foundation H8 verification: the Experience Mote subsystem
## of one Rift run — its run, one mote field of the same seed, and every Graveblade
## binding it connected — behind two operations and a handful of scalar readings.
##
## ONE FOCUSED HEADLESS TEST, ON THE REAL ACTOR. Every Graveblade here is the
## production scene, and every one of them dies through its own public
## `receive_damage()` — the entry every accepted attacker calls — and its own
## mechanical death. Nothing kills a Graveblade any other way, and nothing emits its
## `died` signal but the Graveblade itself.
##
## THE SCENE TREE IS ENTERED ONCE. Nodes added during `_initialize()` do not enter
## the tree until the first frame (D-283's first finding), so the suite waits exactly
## one process frame and then runs every check synchronously — except the one check
## that exists to let frames pass, which runs LAST among the behavioural checks, so
## nothing after it depends on where a Graveblade stands.
##
## IT PORTS D-211's OWED-SET DISCIPLINE. Every check function records reaching its
## LAST line, and the suite compares that set against what it owes in BOTH
## directions, so a check that dies half way — or a coroutine that is never awaited —
## cannot leave a green run behind it.
##
## THE HARNESS NEVER REACHES INSIDE THE RUNTIME. It reads and writes no private
## member of the runtime, a binding, a field or a run. It registers only through
## `register_graveblade()`, sweeps only through `sweep_at()`, and reads only the
## runtime's own scalars. It connects only its own observers to a Graveblade's
## signals, and counts that Graveblade's `died` connections through the engine's
## public signal API. It makes drops directly only in TWIN fields, and awards
## experience directly only to TWIN runs. It places a Graveblade through `position`
## before it enters the tree and through the actor's own `place_at()` afterwards, and
## restores a dead one only through `reset_encounter()`.
##
## EVERY EXPECTED ANSWER IS EITHER A TYPED LITERAL OR THE ACCEPTED MECHANISM'S OWN
## ANSWER, asked directly with the same inputs — H1's own `problem()` and a fresh H7
## binding's own refusal for an amount or a dead Graveblade, G1's own requirement
## for Level 1, and a twin field and twin run for what a drop is worth and where it
## lies.
##
## THE VALUES 25, 12.5, 40 AND 100 ARE TEST EVIDENCE ONLY. 100 is the accepted
## starter Quick Strike's Physical damage, used so a Graveblade dies to the hits it
## is accepted to die to; the rest are mote amounts. None is an enemy-experience
## value, and nothing here decides one.
##
## IT READS NO OTHER SUITE. It names no file under `tests/` but its own, which the
## runner asserts.

# --- The files ----------------------------------------------------------------------

const RUNTIME_FILE: String = "res://scripts/experience/rift_mote_runtime.gd"
const THIS_FILE: String = "res://tests/rift_mote_runtime_verification.gd"

const RUNTIME_CLASS: String = "RiftMoteRuntime"

## The production Graveblade scene, read here only to build real Graveblades.
const GRAVEBLADE_SCENE: String = "res://scenes/actors/prototype_graveblade.tscn"

## `scripts/experience/` after H8, sorted: H6's emission, H1's mote, E1's two
## scripts, H7's binding and H8's runtime.
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

## Everything that would mean something that runs creates a runtime.
const UNWIRED_TOKENS: Array[String] = ["RiftMoteRuntime", "rift_mote_runtime"]

## THE ONLY FILE OTHER THAN THE RUNTIME THAT MAY NAME AN UNWIRED TOKEN, PER FILE AND
## PER TOKEN. D-288: the Roguelite Experience Collection Greybox Review — an isolated
## review scene launched by name, never the project entrypoint — makes exactly one
## runtime per expedition from that expedition's seed, registers the fixed route's
## Graveblades with it, sweeps it from one tick and lets it go when the expedition
## ends (D-287's one-runtime-per-run invariant) — so it is granted the runtime's class
## and never the runtime's file name. This replaces the blanket "no other file" one for
## one: the same single assertion is made either way, and the pinned count does not move.
const AUTHORIZED_READERS: Array = [
	["res://scripts/roguelite/experience/roguelite_experience_collection_review.gd", ["RiftMoteRuntime"]],
]

## THE ONLY PROJECT CLASSES THE RUNTIME MAY NAME, and it must name all eleven: itself,
## the actor it registers, the binding it makes for that actor (H7), the field it
## owns (H5), the value a sweep answers with (H5), and the run it owns (G4) — and,
## since Foundation I1 (D-291), the three record types a caller hands its offer
## opening and the run's own level-up record its lane choice hands back — and, since
## Roguelite I3 (D-295), the type of the copied build its one build reading hands on.
## Checked against the engine's own global class list in both directions.
const RUNTIME_NAMES: Array[String] = [
	"PassiveCardDefinition", "PrototypeGraveblade", "RiftGravebladeMoteBinding", "RiftMoteField",
	"RiftMoteRuntime", "RiftMoteSweepResult", "RiftRunBuild", "RiftRunLevelCoordinator",
	"RiftRunLevelUpResult", "SkillTagProfile", "SupportDefinition",
]

## Every method, in declaration order, with its full signature. The engine reports
## a constructor's return as an object, whatever the source declares. Foundation I1
## (D-291) added exactly the six offer delegations after the sweep, and Roguelite I3
## (D-295) exactly one build reading after them; Roguelite I10 (D-312) added exactly two
## readings of the standing offer after its identity reading; the engine reports a typed
## array as an Array and a packed string array as type 34.
const RUNTIME_SIGNATURES: Array[String] = [
	"_init(for_run_seed: int) -> Object",
	"register_graveblade(enemy: Object, base_experience: float) -> String",
	"sweep_at(player_position: Vector3) -> Object",
	"open_level_up_offer(profiles: Array, definitions: Array, cards: Array) -> String",
	"offer_root_seed() -> int",
	"offer_lanes() -> Array",
	"offer_identity_for(lane: int) -> type 34",
	"offer_support_content_kind() -> int",
	"offer_support_fallback_category() -> int",
	"frozen_offer_requirement() -> float",
	"choose_level_up_lane(lane: int) -> Object",
	"run_build() -> Object",
	"run_seed() -> int",
	"level() -> int",
	"experience() -> float",
	"is_offer_active() -> bool",
	"binding_count() -> int",
	"drop_count() -> int",
	"collected_count() -> int",
	"uncollected_count() -> int",
	"is_registered(enemy: Object) -> bool",
	"has_observed_death(enemy: Object) -> bool",
	"emission_answer(enemy: Object) -> String",
	"problem() -> String",
	"_owned_problem() -> String",
]

## THE RUNTIME'S WHOLE STATE: THREE PRIVATE FIELDS AND NO FOURTH — no run seed of
## its own among them.
const RUNTIME_FIELDS: Array[String] = ["_run", "_field", "_bindings"]
const RUNTIME_TYPES: Array[int] = [TYPE_OBJECT, TYPE_OBJECT, TYPE_DICTIONARY]
const RUNTIME_DECLARATIONS: Array[String] = [
	"var _run: RiftRunLevelCoordinator",
	"var _field: RiftMoteField",
	"var _bindings: Dictionary[PrototypeGraveblade, RiftGravebladeMoteBinding] = {}",
]

## The ONLY writes to a field anywhere in the file, in source order.
const RUNTIME_WRITES: Array[String] = [
	"_run = RiftRunLevelCoordinator.new(for_run_seed)",
	"_field = RiftMoteField.new(for_run_seed)",
	"_bindings[enemy] = binding",
]

## The runtime's own wordings, typed independently.
const NO_ENEMY: String = "a run's Experience Mote runtime registers a Graveblade, and none was given"
const ALREADY_REGISTERED: String = "this Graveblade is already registered with this run's Experience Mote runtime; it registers nothing again"
const NOT_REGISTERED: String = "that Graveblade is not registered with this run's Experience Mote runtime, so it has no emission answer"
const FREED: String = "a Graveblade registered with this run's Experience Mote runtime no longer exists"
const NO_RUN: String = "this Experience Mote runtime holds no run"
const NO_FIELD: String = "this Experience Mote runtime holds no mote field"
const NOT_KEYED: String = "an entry of this run's Experience Mote runtime is not keyed by a Graveblade"
const NO_BINDING: String = "an entry of this run's Experience Mote runtime holds no Graveblade binding"
const NEVER_CONNECTED: String = "an entry of this run's Experience Mote runtime holds a binding that never connected"
## Foundation H7's accepted D-284 diagnostic, typed independently and also asked of a
## fresh binding directly.
const ALREADY_DEAD: String = "the bound Graveblade is already dead; its Experience Mote binding must be connected before death"

## EVERY METHOD'S WHOLE BODY, line for line, as the code must spell it. The
## registration order, the one-line sweep, the constructor that looks nothing up,
## every reading asking its owner, and the collection walked only through its keys
## and its values are all in here.
const METHOD_BODIES: Array = [
	[
		"func _init(for_run_seed: int) -> void:",
		"_run = RiftRunLevelCoordinator.new(for_run_seed)",
		"_field = RiftMoteField.new(for_run_seed)",
	],
	[
		"func register_graveblade(enemy: PrototypeGraveblade, base_experience: float) -> String:",
		"if enemy == null:",
		"return \"" + NO_ENEMY + "\"",
		"var incoherent: String = _owned_problem()",
		"if not incoherent.is_empty():",
		"return incoherent",
		"if _bindings.has(enemy):",
		"return \"" + ALREADY_REGISTERED + "\"",
		"var binding: RiftGravebladeMoteBinding = RiftGravebladeMoteBinding.new(_run.run_seed(), enemy, _field, base_experience)",
		"var refusal: String = binding.connect_to_death()",
		"if not refusal.is_empty():",
		"return refusal",
		"_bindings[enemy] = binding",
		"return \"\"",
	],
	[
		"func sweep_at(player_position: Vector3) -> RiftMoteSweepResult:",
		"return _field.sweep_collection(player_position, _run)",
	],
	## Foundation I1 (D-291): six delegations, one line each, to the run's own offer
	## operations — no readiness, seed, lane, identity, build change or level decided,
	## checked or copied here.
	[
		"func open_level_up_offer(",
		"profiles: Array[SkillTagProfile],",
		"definitions: Array[SupportDefinition],",
		"cards: Array[PassiveCardDefinition]",
		") -> String:",
		"return _run.open_current_offer(profiles, definitions, cards)",
	],
	["func offer_root_seed() -> int:", "return _run.offer_root_seed()"],
	["func offer_lanes() -> Array[int]:", "return _run.offer_lanes()"],
	["func offer_identity_for(lane: int) -> PackedStringArray:", "return _run.offer_identity_for(lane)"],
	## Roguelite I10 (D-312): two delegations, one line each, to the run's own readings of
	## the standing offer's Support content kind and passive-fallback category.
	["func offer_support_content_kind() -> int:", "return _run.offer_support_content_kind()"],
	["func offer_support_fallback_category() -> int:", "return _run.offer_support_fallback_category()"],
	["func frozen_offer_requirement() -> float:", "return _run.frozen_requirement()"],
	["func choose_level_up_lane(lane: int) -> RiftRunLevelUpResult:", "return _run.choose(lane)"],
	## Roguelite I3 (D-295): one delegation, one line, to the run's own build reading —
	## the run's independent copy handed on, nothing kept, checked or copied here.
	["func run_build() -> RiftRunBuild:", "return _run.run_build()"],
	["func run_seed() -> int:", "return _run.run_seed()"],
	["func level() -> int:", "return _run.level()"],
	["func experience() -> float:", "return _run.experience()"],
	["func is_offer_active() -> bool:", "return _run.is_offer_active()"],
	["func binding_count() -> int:", "return _bindings.size()"],
	["func drop_count() -> int:", "return _field.drop_count()"],
	["func collected_count() -> int:", "return _field.collected_count()"],
	["func uncollected_count() -> int:", "return _field.uncollected_count()"],
	[
		"func is_registered(enemy: PrototypeGraveblade) -> bool:",
		"return enemy != null and _bindings.has(enemy)",
	],
	[
		"func has_observed_death(enemy: PrototypeGraveblade) -> bool:",
		"return is_registered(enemy) and _bindings[enemy].has_observed_death()",
	],
	[
		"func emission_answer(enemy: PrototypeGraveblade) -> String:",
		"if not is_registered(enemy):",
		"return \"" + NOT_REGISTERED + "\"",
		"return _bindings[enemy].emission_answer()",
	],
	[
		"func problem() -> String:",
		"var owned: String = _owned_problem()",
		"if not owned.is_empty():",
		"return owned",
		"for key: Variant in _bindings.keys():",
		"if key == null:",
		"return \"" + FREED + "\"",
		"if not (key is PrototypeGraveblade):",
		"return \"" + NOT_KEYED + "\"",
		"for value: Variant in _bindings.values():",
		"if value == null or not (value is RiftGravebladeMoteBinding):",
		"return \"" + NO_BINDING + "\"",
		"if not (value as RiftGravebladeMoteBinding).has_connected():",
		"return \"" + NEVER_CONNECTED + "\"",
		"return \"\"",
	],
	[
		"func _owned_problem() -> String:",
		"if _run == null:",
		"return \"" + NO_RUN + "\"",
		"if _field == null:",
		"return \"" + NO_FIELD + "\"",
		"var incoherent: String = _field.problem()",
		"if not incoherent.is_empty():",
		"return incoherent",
		"if _field.run_seed() != _run.run_seed():",
		"return \"this Experience Mote runtime's mote field belongs to run seed %d, not to its run's seed %d; it registers nothing\" % [",
		"_field.run_seed(), _run.run_seed(),",
		"]",
		"return \"\"",
	],
]

## The only members of each held object the runtime may reach, with how often.
## Foundation I1 (D-291) added the run's six offer members, each asked exactly once,
## and Roguelite I3 (D-295) the run's build reading, asked exactly once, and Roguelite
## I10 (D-312) the run's two Support-content readings, each asked exactly once.
const RUN_CALLS: Array = [
	["run_seed", 4], ["level", 1], ["experience", 1], ["is_offer_active", 1],
	["open_current_offer", 1], ["offer_root_seed", 1], ["offer_lanes", 1], ["offer_identity_for", 1],
	["offer_support_content_kind", 1], ["offer_support_fallback_category", 1],
	["frozen_requirement", 1], ["choose", 1], ["run_build", 1],
]
const FIELD_CALLS: Array = [
	["sweep_collection", 1], ["drop_count", 1], ["collected_count", 1], ["uncollected_count", 1],
	["problem", 1], ["run_seed", 2],
]
const BINDINGS_CALLS: Array = [["has", 2], ["size", 1], ["keys", 1], ["values", 1]]

## Enemy content, experience balance, the project's OTHER experience records, every
## other foundation's class, file and member the runtime is not granted, and ambient
## state. Scanned RAW over the runtime, comments included — D-215's lesson.
const FORBIDDEN_TOKENS: Array[String] = [
	"GravebladeData", "experience_reward", "GRAVEBLADE_EXPERIENCE", "ExperienceTable", "experience_table",
	"CharacterState", "LabProgress", "progression", "max_life", "Vanguard", "vanguard", "VANGUARD",
	## Lower-case "elite" is anchored, because a bare token fails on "Roguelite".
	"Elite", " elite", "_elite", "ELITE", "XP", "Mauler", "Marrowshot", "Tombknife", "Acolyte", "Cantor", "Warden",
	".tres", ".tscn", "res://", "user://",
	"RiftExperienceMote", "rift_experience_mote", "collect_into", "RiftMoteDrop", "rift_mote_drop",
	"attempt_collection", "RiftMoteCollection", "RiftMotePickup", "rift_mote_field", "rift_mote_sweep_result",
	"spawn_drop", "RiftEnemyMoteEmission", "rift_enemy_mote_emission", "emit_at", "rift_graveblade_mote_binding",
	"RiftRunLevelUpResult", "RiftLevelUpCoordinator", "next_level_coordinator", "open_current_offer", "open_offer",
	"choose(", "award_experience", "RiftExperienceTrack", "RiftExperienceReading", "RiftRunBuild",
	"RiftConsumptionLedger", "RiftLevelRequirement", "RiftLevelOfferSeed", "requirement_reading", "PlayerStat",
	"SkillSupportCatalogue", "PassiveCard", "DamageEvent",
	"RogueliteCoreLoopRuntime", "RogueliteReplayabilityRuntime", "RogueliteBuildVariety",
	"ConfigFile", "FileAccess", "ResourceSaver", "ResourceLoader", "RandomNumberGenerator", "randi", "randf",
	"Time.", "Engine.", "ProjectSettings", "InputMap",
]

## What the runtime may not DO, as tokens over CODE with its strings emptied: tick,
## wait, signal, reach into the scene, identify a Graveblade another way, touch the
## actor, hold another collection, load anything, remove or reorder anything, or name
## a room, round, wave or encounter.
const BEHAVIOUR_TOKENS: Array[String] = [
	"_process", "Timer", "create_timer", "await", "emit_signal", ".emit(", "signal ", "connect(", "disconnect",
	"get_node", "get_tree", "find_child", "get_parent", "get_children", "get_instance_id", "instance_from_id",
	".name", "display_name", ".data", "global_position", "place_at", "receive_damage", "reset_encounter",
	"is_alive", "died", "Node", "while ", "match ", "Array", "Packed", "load(", "erase(", "clear(",
	"duplicate(", "remove", "sort", "shuffle", "static", "const ", "enum ", "room", "round", "wave",
	"encounter", "family", "is_instance_valid", "print", "push_error", "assert",
]

## Words that would mean a runtime can be reset, pruned, re-armed, transferred,
## stored, ticked, or asked to open, choose or award anything.
const DEFERRED_MEMBER_TOKENS: Array[String] = [
	"open", "choose", "lane", "reset", "clear", "unregister", "remove", "prune", "erase", "transfer", "rearm",
	"retry", "save", "load", "set_", "timer", "tick", "process", "poll", "track", "award", "spawn", "emit",
	"copy", "clone", "reuse", "disconnect", "free",
]

## FOUNDATION I1 (D-291) — EXACTLY WHAT IT GRANTS, AND NOTHING WIDER.
##
## The six offer delegations, by name. They alone are lifted out of the deferred-member
## words above — "open", "choose" and "lane" among them — which still hold for every
## other member; and with `is_offer_active` they are the only members allowed to say
## "offer", in declaration order.
const I1_METHODS: Array[String] = [
	"open_level_up_offer", "offer_root_seed", "offer_lanes", "offer_identity_for",
	"frozen_offer_requirement", "choose_level_up_lane",
]
## Roguelite I10 (D-312) adds exactly its two readings of the standing offer to the members
## allowed to say "offer", in declaration order. They name no deferred word, so nothing is
## lifted out of that list for them.
const OFFER_MEMBERS: Array[String] = [
	"open_level_up_offer", "offer_root_seed", "offer_lanes", "offer_identity_for",
	"offer_support_content_kind", "offer_support_fallback_category",
	"frozen_offer_requirement", "is_offer_active",
]
## The five code lines that must name a typed collection, each pinned whole in
## `METHOD_BODIES`. Only these exact lines are lifted out before the behaviour scan,
## whose "Array" and "Packed" still hold over every other line of code.
const I1_DECLARATION_LINES: Array[String] = [
	"profiles: Array[SkillTagProfile],", "definitions: Array[SupportDefinition],",
	"cards: Array[PassiveCardDefinition]", "func offer_lanes() -> Array[int]:",
	"func offer_identity_for(lane: int) -> PackedStringArray:",
]
## The four forbidden tokens the delegations must name, each owed EXACTLY ONCE in the
## raw file, comments included. Every other forbidden token is still owed zero times,
## and a second mention of any of these four — a second choice, the opening asked
## twice, a catalogue named even in a comment — fails exactly as any mention did before.
const I1_GRANTED_TOKENS: Array = [
	["open_current_offer", 1], ["choose(", 1], ["RiftRunLevelUpResult", 1], ["PassiveCard", 1],
]

## ROGUELITE I3 (D-295) — EXACTLY WHAT IT GRANTS, AND NOTHING WIDER. One forbidden
## token moves out of the zero-occurrence scan: D2's build type, owed EXACTLY ONCE in
## the raw file — the return type of the one-line build reading. A second mention,
## even in a comment, fails exactly as any mention did before.
const I3_GRANTED_TOKENS: Array = [
	["RiftRunBuild", 1],
]

# --- The fixtures, stated independently -----------------------------------------------

## Test evidence only.
const HIT: float = 100.0
const TEST_MOTE: float = 25.0
const LESSER_MOTE: float = 12.5
const GREATER_MOTE: float = 40.0

## The inclusive base Pickup Radius every fresh run answers with.
const BOUNDARY: float = 2.5

## What four test motes add up to, and what G1 must answer Level 1 requires.
const FOUR_MOTES: float = 100.0

const UNUSABLE_BASES: Array = [
	["zero", 0.0], ["negative", -25.0], ["not a number", NAN],
	["positive infinity", INF], ["negative infinity", -INF],
]

const OWNER_SEED: int = 99

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

## Where check 4's Graveblade enters, where it dies, and where its attacker stands.
const LETHAL_SPAWN: Vector3 = Vector3(-12.0, 0.0, 8.0)
const LETHAL_DEATH: Vector3 = Vector3(6.0, 0.0, -6.0)
const LETHAL_ATTACKER: Vector3 = Vector3(30.0, 0.0, 30.0)

const OWED_CHECKS: Array[String] = [
	"a_new_runtime_holds_its_exact_seed_level_one_and_nothing_and_connects_nothing",
	"registering_one_live_graveblade_commits_exactly_one_binding",
	"the_runtime_alone_keeps_each_binding_alive_and_letting_it_go_retires_them",
	"one_death_drops_one_mote_and_only_an_explicit_in_range_sweep_pays_it_once",
	"a_second_registration_of_the_same_graveblade_is_refused_atomically",
	"graveblades_sharing_a_name_register_independently_and_drop_in_death_order",
	"a_refused_registration_keeps_nothing_and_a_corrected_one_succeeds",
	"an_already_dead_graveblade_is_refused_with_h7s_own_reason_and_nothing_is_kept",
	"seeds_agreeing_in_their_low_32_bits_make_different_runtimes",
	"negative_minimum_and_maximum_seeds_run_the_whole_chain",
	"four_motes_reach_exactly_the_level_one_requirement_and_nothing_levels",
	"a_freed_registered_graveblade_is_reported_and_changes_nothing_else",
	"nothing_collects_on_its_own_while_frames_pass",
	"the_runtime_holds_three_fields_and_every_method_is_pinned",
	"the_runtime_names_no_balance_and_only_what_it_composes",
	"nothing_that_runs_creates_a_runtime_and_the_directory_holds_six_scripts",
]

var _failures: PackedStringArray = PackedStringArray()
var _checks: int = 0
var _reached: Dictionary = {}
var _refusals: int = 0
var _deaths_driven: int = 0
var _sweeps: int = 0

var _stage: Node3D
var _use: int = 0
## Per Graveblade instance id: how many times its own `died` and `took_damage`
## fired, counted by observers this harness connects before anything else.
var _deaths: Dictionary = {}
var _hits: Dictionary = {}


func _initialize() -> void:
	_run()


func _run() -> void:
	await process_frame
	print("")
	print("=== Roguelite Foundation H8 — Run-Owned Experience-Mote Runtime (D-286) ===")
	_stage = Node3D.new()
	_stage.name = "H8Stage"
	root.add_child(_stage)
	_expect(root.is_inside_tree() and _stage.is_inside_tree(), "the stage did not enter the tree")

	_check_a_new_runtime()
	_check_one_registration()
	_check_the_runtime_keeps_its_bindings()
	_check_one_death_and_explicit_sweeps()
	_check_a_duplicate_registration()
	_check_same_name_and_death_order()
	_check_refused_then_corrected()
	_check_an_already_dead_graveblade()
	_check_low_32_bit_runtimes()
	_check_every_signed_seed()
	_check_four_motes_to_the_requirement()
	_check_a_freed_graveblade()
	await _check_nothing_collects_on_its_own()
	_check_the_fields_and_bodies()
	_check_the_shape()
	_check_nothing_runs_it()

	_check_every_check_ran()

	print("")
	if _failures.is_empty():
		print("RIFT MOTE RUNTIME VERIFICATION: PASS (%d checks)" % _checks)
		quit(0)
	else:
		for failure: String in _failures:
			printerr("  FAIL: %s" % failure)
		printerr("RIFT MOTE RUNTIME VERIFICATION: %d FAILURE(S) of %d checks" % [
			_failures.size(), _checks,
		])
		quit(1)


# --- 1. A new runtime -------------------------------------------------------------------

func _check_a_new_runtime() -> void:
	print("")
	print("--- 1. A new runtime reports its exact seed, Level 1, no progress, no offer, no binding and no drop — and construction connects nothing")
	var script: GDScript = load(RUNTIME_FILE) as GDScript
	var constructor_args: int = -1
	var defaults: PackedStringArray = PackedStringArray()
	for entry: Dictionary in script.get_script_method_list():
		if String(entry.get("name", "")) == "_init":
			constructor_args = (entry.get("args", []) as Array).size()
		if not (entry.get("default_args", []) as Array).is_empty():
			defaults.append(String(entry.get("name", "")))
	_expect(constructor_args == 1 and defaults.is_empty(),
		"the constructor takes %d arguments; these methods default one: %s" % [constructor_args, ", ".join(defaults)])

	var bystander: PrototypeGraveblade = _graveblade("Bystander", Vector3(0.0, 0.0, 0.0), _stage)
	var connections_before: int = bystander.died.get_connections().size()
	var runtime: RiftMoteRuntime = RiftMoteRuntime.new(OWNER_SEED)
	var connections_after: int = bystander.died.get_connections().size()
	var twin_run: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(OWNER_SEED)
	var twin_field: RiftMoteField = RiftMoteField.new(OWNER_SEED)
	var reading: String = _snapshot(runtime)
	var expected: String = "seed=%d level=%d experience=%s offer=%s bindings=0 drops=%d collected=%d uncollected=%d problem=''" % [
		twin_run.run_seed(), twin_run.level(), _exact(twin_run.experience()), str(twin_run.is_offer_active()),
		twin_field.drop_count(), twin_field.collected_count(), twin_field.uncollected_count(),
	]
	_expect(runtime.run_seed() == OWNER_SEED and runtime.level() == 1 and runtime.experience() == 0.0
			and not runtime.is_offer_active() and runtime.binding_count() == 0 and runtime.drop_count() == 0
			and runtime.collected_count() == 0 and runtime.uncollected_count() == 0 and runtime.problem().is_empty(),
		"a new runtime reads %s" % reading)
	_expect(reading == expected, "a new runtime reads %s, while a run and a field made directly read %s" % [reading, expected])
	_expect(connections_after == connections_before and _binding_connections(bystander) == 0
			and runtime.get_incoming_connections().is_empty() and script.get_script_signal_list().is_empty()
			and not runtime.is_registered(bystander) and not runtime.has_observed_death(bystander),
		"construction connected something: %d -> %d connections on a Graveblade in the tree" % [connections_before, connections_after])
	print("  the constructor takes %d argument and no method defaults one; a new runtime reads %s" % [constructor_args, reading])
	print("  construction left a Graveblade already in the tree at %d died connection (the harness's own observer), %d of them a binding's; the runtime has %d incoming connections and declares %d signals"
		% [connections_after, _binding_connections(bystander), runtime.get_incoming_connections().size(),
			script.get_script_signal_list().size()])
	_done("a_new_runtime_holds_its_exact_seed_level_one_and_nothing_and_connects_nothing")


# --- 2. One registration -------------------------------------------------------------------

func _check_one_registration() -> void:
	print("")
	print("--- 2. Registering one live Graveblade commits exactly one binding and connects exactly one callback")
	var enemy: PrototypeGraveblade = _graveblade("Registered", Vector3(10.0, 0.0, 0.0), _stage)
	var runtime: RiftMoteRuntime = RiftMoteRuntime.new(OWNER_SEED)
	var baseline: int = enemy.died.get_connections().size()
	var before: String = _snapshot(runtime)
	var answer: String = runtime.register_graveblade(enemy, TEST_MOTE)
	var after: String = _snapshot(runtime)
	_expect(answer.is_empty() and runtime.binding_count() == 1 and runtime.is_registered(enemy)
			and not runtime.has_observed_death(enemy) and runtime.emission_answer(enemy).is_empty()
			and runtime.problem().is_empty(),
		"the registration answered '%s': %s" % [answer, _whole(runtime, enemy)])
	_expect(enemy.died.get_connections().size() == baseline + 1 and _binding_connections(enemy) == 1,
		"the registration left %d of %d connections, %d of them a binding's" % [
			enemy.died.get_connections().size(), baseline, _binding_connections(enemy)])
	_expect(runtime.drop_count() == 0 and runtime.experience() == 0.0 and runtime.level() == 1
			and not runtime.is_offer_active() and enemy.is_alive(),
		"the registration moved the run or the field: %s" % after)
	print("  register_graveblade(): '%s' — %s became %s; %d died connection added, exactly %d of them a binding's"
		% [answer, before, after, enemy.died.get_connections().size() - baseline, _binding_connections(enemy)])
	_done("registering_one_live_graveblade_commits_exactly_one_binding")


# --- 3. The runtime keeps its bindings ---------------------------------------------------------

func _check_the_runtime_keeps_its_bindings() -> void:
	print("")
	print("--- 3. The runtime alone keeps each binding alive after registration returns; letting the runtime go retires every connection")
	var kept_enemy: PrototypeGraveblade = _graveblade("KeptAlive", Vector3(20.0, 0.0, 0.0), _stage)
	var attacker: Node3D = _node("KeptAttacker", Vector3(20.0, 0.0, 1.2))
	## Every reference made while registering lives and dies inside the helper: here,
	## only the runtime and the Graveblade are held.
	var runtime: RiftMoteRuntime = _runtime_registering(OWNER_SEED, kept_enemy, TEST_MOTE)
	var connected_after_return: int = _binding_connections(kept_enemy)
	var ladder: PackedStringArray = _kill(kept_enemy, attacker, kept_enemy)
	_expect(runtime.binding_count() == 1 and connected_after_return == 1 and _died(kept_enemy) == 1
			and runtime.drop_count() == 1 and runtime.has_observed_death(kept_enemy)
			and runtime.emission_answer(kept_enemy).is_empty(),
		"after registration returned: %d binding connections; then %s" % [connected_after_return, _whole(runtime, kept_enemy)])

	var released_enemy: PrototypeGraveblade = _graveblade("LetGo", Vector3(24.0, 0.0, 0.0), _stage)
	var baseline: int = released_enemy.died.get_connections().size()
	var released_answer: String = _register_and_let_go(OWNER_SEED, released_enemy)
	var after_release: int = released_enemy.died.get_connections().size()
	var released_ladder: PackedStringArray = _kill(released_enemy, attacker, released_enemy)
	_expect(released_answer.is_empty() and after_release == baseline and _binding_connections(released_enemy) == 0
			and _died(released_enemy) == 1,
		"a runtime registered ('%s') and let go left %d of %d connections, %d of them a binding's" % [
			released_answer, after_release, baseline, _binding_connections(released_enemy)])
	print("  a runtime returned from the helper that registered with it: %d binding connection survived the return; the death (%s) was heard and made %d drop"
		% [connected_after_return, " -> ".join(ladder), runtime.drop_count()])
	print("  a runtime registered ('%s') and let go: the Graveblade's died went back to %d connection, %d of them a binding's; its death (%s) reached nothing"
		% [released_answer, after_release, _binding_connections(released_enemy), " -> ".join(released_ladder)])
	_done("the_runtime_alone_keeps_each_binding_alive_and_letting_it_go_retires_them")


func _runtime_registering(run_seed: int, enemy: PrototypeGraveblade, amount: float) -> RiftMoteRuntime:
	var made: RiftMoteRuntime = RiftMoteRuntime.new(run_seed)
	_expect_accepted(made.register_graveblade(enemy, amount), "the helper's registration")
	return made


func _register_and_let_go(run_seed: int, enemy: PrototypeGraveblade) -> String:
	return RiftMoteRuntime.new(run_seed).register_graveblade(enemy, TEST_MOTE)


# --- 4. One death, and explicit sweeps --------------------------------------------------------

func _check_one_death_and_explicit_sweeps() -> void:
	print("")
	print("--- 4. Two nonlethal hits drop nothing; the lethal hit drops one uncollected mote and pays nothing; only an explicit sweep in range pays it, and only once")
	var runtime: RiftMoteRuntime = RiftMoteRuntime.new(OWNER_SEED)
	var enemy: PrototypeGraveblade = _graveblade("Lethal", LETHAL_SPAWN, _stage)
	var attacker: Node3D = _node("LethalAttacker", LETHAL_ATTACKER)
	_expect_accepted(runtime.register_graveblade(enemy, TEST_MOTE), "the lethal Graveblade's registration")
	enemy.place_at(LETHAL_DEATH)
	var ladder: PackedStringArray = PackedStringArray([_life(enemy.life)])
	for _hit: int in 2:
		_strike(enemy, attacker, enemy)
		ladder.append(_life(enemy.life))
	var nonlethal: String = " -> ".join(ladder)
	var nonlethal_reading: String = "took_damage %d, died %d — %d drops, death heard: %s, experience %s" % [
		_took(enemy), _died(enemy), runtime.drop_count(), str(runtime.has_observed_death(enemy)), _exact(runtime.experience())]
	_expect(nonlethal == "300 -> 200 -> 100" and _took(enemy) == 2 and _died(enemy) == 0 and enemy.is_alive()
			and runtime.drop_count() == 0 and not runtime.has_observed_death(enemy) and runtime.experience() == 0.0,
		"two nonlethal hits read %s: %s" % [nonlethal, _whole(runtime, enemy)])
	_strike(enemy, attacker, enemy)
	ladder.append(_life(enemy.life))
	_deaths_driven += 1
	_expect(" -> ".join(ladder) == "300 -> 200 -> 100 -> 0" and _took(enemy) == 3 and _died(enemy) == 1
			and not enemy.is_alive() and enemy.global_position == LETHAL_DEATH,
		"the kill read %s with %d took_damage and %d died" % [" -> ".join(ladder), _took(enemy), _died(enemy)])
	var after_death: String = _whole(runtime, enemy)
	_expect(runtime.drop_count() == 1 and runtime.uncollected_count() == 1 and runtime.collected_count() == 0
			and runtime.experience() == 0.0 and runtime.level() == 1 and not runtime.is_offer_active()
			and runtime.has_observed_death(enemy) and runtime.emission_answer(enemy).is_empty()
			and runtime.binding_count() == 1 and runtime.problem().is_empty(),
		"after the lethal hit: %s" % after_death)

	## A TWIN field given the same drop directly, swept into a TWIN run from the same
	## places, answers every probe.
	var twin_field: RiftMoteField = RiftMoteField.new(OWNER_SEED)
	var twin_run: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(OWNER_SEED)
	_expect_accepted(twin_field.spawn_drop(LETHAL_DEATH, TEST_MOTE), "the twin's drop")
	var probes: Array[Vector3] = [
		LETHAL_SPAWN, LETHAL_ATTACKER,
		Vector3(_beyond(LETHAL_DEATH.x + BOUNDARY, 1.0), LETHAL_DEATH.y, LETHAL_DEATH.z),
		Vector3(_beyond(LETHAL_DEATH.x - BOUNDARY, -1.0), LETHAL_DEATH.y, LETHAL_DEATH.z),
		Vector3(LETHAL_DEATH.x, LETHAL_DEATH.y, _beyond(LETHAL_DEATH.z + BOUNDARY, 1.0)),
		Vector3(LETHAL_DEATH.x, LETHAL_DEATH.y, _beyond(LETHAL_DEATH.z - BOUNDARY, -1.0)),
	]
	var out_of_range: int = 0
	for probe: Vector3 in probes:
		var result: RiftMoteSweepResult = runtime.sweep_at(probe)
		var twin_result: RiftMoteSweepResult = twin_field.sweep_collection(probe, twin_run)
		_sweeps += 1
		if (result.ok and result.problem().is_empty() and result.attempted_count == 1 and result.out_of_range_count == 1
				and result.collected_indices().is_empty() and runtime.experience() == 0.0
				and runtime.uncollected_count() == 1 and _sweep(result) == _sweep(twin_result)):
			out_of_range += 1
	_expect(out_of_range == probes.size(), "%d of %d far sweeps found the mote out of range and paid nothing" % [
		out_of_range, probes.size()])
	var edge: Vector3 = Vector3(LETHAL_DEATH.x, LETHAL_DEATH.y, LETHAL_DEATH.z - BOUNDARY)
	var collected: RiftMoteSweepResult = runtime.sweep_at(edge)
	var twin_collected: RiftMoteSweepResult = twin_field.sweep_collection(edge, twin_run)
	_sweeps += 1
	_expect(edge.z == LETHAL_DEATH.z - BOUNDARY and collected.ok and collected.problem().is_empty()
			and collected.collected_indices() == PackedInt32Array([0]) and runtime.experience() == TEST_MOTE
			and runtime.collected_count() == 1 and runtime.uncollected_count() == 0 and runtime.level() == 1
			and not runtime.is_offer_active() and _sweep(collected) == _sweep(twin_collected)
			and runtime.experience() == twin_run.experience(),
		"exactly 2.5 m away the sweep answered %s and the runtime reads %s" % [_sweep(collected), _snapshot(runtime)])
	var paid: String = _snapshot(runtime)
	var again: RiftMoteSweepResult = runtime.sweep_at(LETHAL_DEATH)
	_sweeps += 1
	_expect(again.ok and again.skipped_count == 1 and again.attempted_count == 0 and again.collected_indices().is_empty()
			and _snapshot(runtime) == paid,
		"a later sweep answered %s and the runtime moved from %s to %s" % [_sweep(again), paid, _snapshot(runtime)])
	print("  2 accepted hits of %s: Life %s, %s" % [_exact(HIT), nonlethal, nonlethal_reading])
	print("  the lethal hit (%s) at %s: %s" % [" -> ".join(ladder), str(LETHAL_DEATH), after_death])
	print("  %d of %d sweeps found it out of range and paid nothing — from where it entered, from the attacker, and one float32 spacing beyond 2.5 m on each of four sides; exactly 2.5 m away the sweep collected %s and paid %s — as a twin given the drop directly answered"
		% [out_of_range, probes.size(), str(collected.collected_indices()), _exact(runtime.experience())])
	print("  a later sweep skipped %d, attempted %d and paid nothing: %s" % [again.skipped_count, again.attempted_count, paid])
	_done("one_death_drops_one_mote_and_only_an_explicit_in_range_sweep_pays_it_once")


# --- 5. A duplicate registration -------------------------------------------------------------

func _check_a_duplicate_registration() -> void:
	print("")
	print("--- 5. A second registration of the same Graveblade is refused before any binding is made, and moves nothing")
	var runtime: RiftMoteRuntime = RiftMoteRuntime.new(OWNER_SEED)
	var enemy: PrototypeGraveblade = _graveblade("Duplicated", Vector3(40.0, 0.0, 0.0), _stage)
	var attacker: Node3D = _node("DuplicatedAttacker", Vector3(40.0, 0.0, 1.2))
	_expect_accepted(runtime.register_graveblade(enemy, TEST_MOTE), "the first registration")
	var registered: String = _whole(runtime, enemy)
	## The same amount, another amount, and an amount H1 refuses: the duplicate gate
	## comes before the binding is made, so every one gets the duplicate sentence.
	var amounts: Array = [["the same amount", TEST_MOTE], ["another amount", GREATER_MOTE], ["an unusable amount", NAN]]
	var atomic: int = 0
	for row: Array in amounts:
		var answer: String = runtime.register_graveblade(enemy, float(row[1]))
		_expect_refused(answer, ALREADY_REGISTERED, "a second registration with %s" % String(row[0]))
		var after: String = _whole(runtime, enemy)
		_expect(after == registered, "a second registration with %s moved %s to %s" % [String(row[0]), registered, after])
		if answer == ALREADY_REGISTERED and after == registered:
			atomic += 1
	var ladder: PackedStringArray = _kill(enemy, attacker, enemy)
	var result: RiftMoteSweepResult = runtime.sweep_at(enemy.global_position)
	_sweeps += 1
	_expect(_died(enemy) == 1 and runtime.drop_count() == 1 and result.collected_indices() == PackedInt32Array([0])
			and runtime.experience() == TEST_MOTE and runtime.binding_count() == 1 and _binding_connections(enemy) == 1,
		"after the refused duplicates the death made %d drops and paid %s: %s" % [
			runtime.drop_count(), _exact(runtime.experience()), _whole(runtime, enemy)])
	print("  %d of %d second registrations — %s, %s and %s — answered '%s' and moved nothing: %s"
		% [atomic, amounts.size(), _exact(TEST_MOTE), _exact(GREATER_MOTE), "not a number", ALREADY_REGISTERED, registered])
	print("  the death (%s) fired died %d time(s) into exactly %d binding connection, made %d drop, and one sweep paid %s — the first registration's amount, not %s or the sum"
		% [" -> ".join(ladder), _died(enemy), _binding_connections(enemy), runtime.drop_count(), _exact(runtime.experience()),
			_exact(GREATER_MOTE)])
	_done("a_second_registration_of_the_same_graveblade_is_refused_atomically")


# --- 6. Two Graveblades sharing a name -------------------------------------------------------------

func _check_same_name_and_death_order() -> void:
	print("")
	print("--- 6. Two Graveblades sharing one name register independently, drop in the order they DIED, and keep their readings after death")
	var runtime: RiftMoteRuntime = RiftMoteRuntime.new(OWNER_SEED)
	var first: PrototypeGraveblade = _graveblade("Graveblade", Vector3(60.0, 0.0, 0.0), _parent("RoomA"))
	var second: PrototypeGraveblade = _graveblade("Graveblade", Vector3(60.0, 0.0, 12.0), _parent("RoomB"))
	var stranger: PrototypeGraveblade = _graveblade("Graveblade", Vector3(60.0, 0.0, 24.0), _parent("RoomC"))
	var attacker: Node3D = _node("SameNameAttacker", Vector3(60.0, 0.0, 6.0))
	var names: String = "%s/%s and %s/%s" % [first.name, first.data.display_name, second.name, second.data.display_name]
	_expect(first.name == second.name and first.data.display_name == second.data.display_name and first != second
			and first.get_path() != second.get_path(),
		"the two Graveblades were not two nodes of one name and one display name: %s" % names)
	_expect_accepted(runtime.register_graveblade(first, TEST_MOTE), "the first-registered Graveblade")
	_expect_accepted(runtime.register_graveblade(second, LESSER_MOTE), "the second-registered Graveblade of the same name")
	var registered_bindings: int = runtime.binding_count()
	_expect(runtime.binding_count() == 2 and runtime.is_registered(first) and runtime.is_registered(second)
			and not runtime.is_registered(stranger) and _binding_connections(first) == 1
			and _binding_connections(second) == 1 and _binding_connections(stranger) == 0,
		"two registrations of one name left %d bindings" % runtime.binding_count())

	var second_ladder: PackedStringArray = _kill(second, attacker, second)
	var after_second: int = runtime.drop_count()
	_expect(after_second == 1 and runtime.has_observed_death(second) and not runtime.has_observed_death(first),
		"the second-registered Graveblade's death moved the first: %d drops" % after_second)
	var first_ladder: PackedStringArray = _kill(first, attacker, first)
	_expect(runtime.drop_count() == 2 and runtime.has_observed_death(first), "two deaths left %d drops" % runtime.drop_count())

	var twin_field: RiftMoteField = RiftMoteField.new(OWNER_SEED)
	var twin_run: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(OWNER_SEED)
	_expect_accepted(twin_field.spawn_drop(second.global_position, LESSER_MOTE), "the twin's first drop")
	_expect_accepted(twin_field.spawn_drop(first.global_position, TEST_MOTE), "the twin's second drop")
	var at_second: RiftMoteSweepResult = runtime.sweep_at(second.global_position)
	var paid_second: float = runtime.experience()
	var twin_at_second: RiftMoteSweepResult = twin_field.sweep_collection(second.global_position, twin_run)
	var at_first: RiftMoteSweepResult = runtime.sweep_at(first.global_position)
	var paid_first: float = runtime.experience() - paid_second
	var twin_at_first: RiftMoteSweepResult = twin_field.sweep_collection(first.global_position, twin_run)
	_sweeps += 2
	_expect(at_second.collected_indices() == PackedInt32Array([0]) and paid_second == LESSER_MOTE
			and at_first.collected_indices() == PackedInt32Array([1]) and paid_first == TEST_MOTE,
		"the sweeps answered %s (paid %s) then %s (paid %s)" % [
			_sweep(at_second), _exact(paid_second), _sweep(at_first), _exact(paid_first)])
	_expect(_sweep(at_second) == _sweep(twin_at_second) and _sweep(at_first) == _sweep(twin_at_first)
			and runtime.experience() == twin_run.experience(),
		"the runtime and a twin given the same two drops directly answered differently")

	## After both deaths and both collections: every binding is still owned, and each
	## one's observation and exact answer are still readable.
	_expect(runtime.binding_count() == 2 and runtime.is_registered(first) and runtime.is_registered(second)
			and runtime.has_observed_death(first) and runtime.has_observed_death(second)
			and runtime.emission_answer(first).is_empty() and runtime.emission_answer(second).is_empty()
			and runtime.problem().is_empty(),
		"after death the readings were %s and %s" % [_whole(runtime, first), _whole(runtime, second)])
	## Failing closed: a Graveblade never registered here, and no Graveblade at all.
	_expect(not runtime.is_registered(stranger) and not runtime.has_observed_death(stranger)
			and runtime.emission_answer(stranger) == NOT_REGISTERED and not runtime.is_registered(null)
			and not runtime.has_observed_death(null) and runtime.emission_answer(null) == NOT_REGISTERED,
		"an unregistered Graveblade reads %s; none reads '%s'" % [_enemy_state(runtime, stranger), runtime.emission_answer(null)])
	var stranger_ladder: PackedStringArray = _kill(stranger, attacker, stranger)
	_expect(_died(stranger) == 1 and runtime.drop_count() == 2 and not runtime.has_observed_death(stranger)
			and runtime.emission_answer(stranger) == NOT_REGISTERED,
		"an unregistered Graveblade's death moved the runtime to %d drops" % runtime.drop_count())
	print("  two Graveblades named %s under two rooms: both registered, %d bindings" % [names, registered_bindings])
	print("  killed second-registered first (%s) then first-registered (%s): from where the second fell the sweep collected %s paying %s; from where the first fell, %s paying %s — death order, as a twin answered"
		% [" -> ".join(second_ladder), " -> ".join(first_ladder), str(at_second.collected_indices()), _exact(paid_second),
			str(at_first.collected_indices()), _exact(paid_first)])
	print("  after both deaths: %d bindings still owned; heard %s / %s; answers '%s' / '%s'"
		% [runtime.binding_count(), str(runtime.has_observed_death(first)), str(runtime.has_observed_death(second)),
			runtime.emission_answer(first), runtime.emission_answer(second)])
	print("  a Graveblade of the same name never registered here, and no Graveblade at all: registered false, heard false, answer '%s'; its death (%s) left %d drops"
		% [NOT_REGISTERED, " -> ".join(stranger_ladder), runtime.drop_count()])
	_done("graveblades_sharing_a_name_register_independently_and_drop_in_death_order")


# --- 7. Refused, then corrected ----------------------------------------------------------------------

func _check_refused_then_corrected() -> void:
	print("")
	print("--- 7. A refused registration keeps nothing and connects nothing; the same live Graveblade then registers with an accepted amount")
	var runtime: RiftMoteRuntime = RiftMoteRuntime.new(OWNER_SEED)
	var enemy: PrototypeGraveblade = _graveblade("Corrected", Vector3(80.0, 0.0, 0.0), _stage)
	var attacker: Node3D = _node("CorrectedAttacker", Vector3(80.0, 0.0, 1.2))
	var before: String = _whole(runtime, enemy)
	var cases: Array = [
		["no Graveblade", null, TEST_MOTE, NO_ENEMY],
		["no Graveblade before an unusable amount", null, NAN, NO_ENEMY],
	]
	var amounts: PackedStringArray = PackedStringArray()
	var lower: int = 0
	for row: Array in UNUSABLE_BASES:
		var amount: float = float(row[1])
		var own: String = RiftExperienceMote.new(amount).problem()
		## The binding's own answer for this amount, asked of a fresh binding directly —
		## it refuses before it connects, so nothing listens afterwards.
		var through_h7: String = RiftGravebladeMoteBinding.new(OWNER_SEED, enemy, RiftMoteField.new(OWNER_SEED), amount).connect_to_death()
		if not own.is_empty() and through_h7 == own:
			lower += 1
		cases.append([String(row[0]), enemy, amount, own])
		amounts.append(String(row[0]))
	_expect(lower == UNUSABLE_BASES.size() and _binding_connections(enemy) == 0,
		"%d of %d unusable amounts answer H1's own reason through a fresh binding" % [lower, UNUSABLE_BASES.size()])
	var verbatim: int = 0
	for row: Array in cases:
		var answer: String = runtime.register_graveblade(row[1] as PrototypeGraveblade, float(row[2]))
		_expect_refused(answer, String(row[3]), String(row[0]))
		var after: String = _whole(runtime, enemy)
		_expect(after == before, "%s moved %s to %s" % [String(row[0]), before, after])
		if answer == String(row[3]) and after == before:
			verbatim += 1
	var corrected: String = runtime.register_graveblade(enemy, TEST_MOTE)
	_expect(corrected.is_empty() and runtime.binding_count() == 1 and runtime.is_registered(enemy)
			and _binding_connections(enemy) == 1,
		"the corrected registration answered '%s': %s" % [corrected, _whole(runtime, enemy)])
	var ladder: PackedStringArray = _kill(enemy, attacker, enemy)
	var result: RiftMoteSweepResult = runtime.sweep_at(enemy.global_position)
	_sweeps += 1
	_expect(runtime.drop_count() == 1 and result.collected_indices() == PackedInt32Array([0])
			and runtime.experience() == TEST_MOTE,
		"after the corrected registration the death paid %s" % _exact(runtime.experience()))
	print("  %d of %d refusals word for word — no Graveblade, no Graveblade before an unusable amount, and %s with H1's own reason as a fresh binding answers it — each keeping nothing: %s"
		% [verbatim, cases.size(), ", ".join(amounts), before])
	print("  no Graveblade: '%s'" % NO_ENEMY)
	print("  the same living Graveblade then registered with %s ('%s'), 1 binding connection; its death (%s) made 1 drop and one sweep paid %s"
		% [_exact(TEST_MOTE), corrected, " -> ".join(ladder), _exact(runtime.experience())])
	_done("a_refused_registration_keeps_nothing_and_a_corrected_one_succeeds")


# --- 8. An already-dead Graveblade ---------------------------------------------------------------

func _check_an_already_dead_graveblade() -> void:
	print("")
	print("--- 8. An already-dead Graveblade is refused with the binding's own D-284 reason, and nothing is kept")
	var runtime: RiftMoteRuntime = RiftMoteRuntime.new(OWNER_SEED)
	var spawn: Vector3 = Vector3(100.0, 0.0, 0.0)
	var death: Vector3 = Vector3(104.0, 0.0, 0.0)
	var enemy: PrototypeGraveblade = _graveblade("AlreadyDead", spawn, _stage)
	var attacker: Node3D = _node("AlreadyDeadAttacker", Vector3(100.0, 0.0, 1.2))
	var first: PackedStringArray = _kill(enemy, attacker, enemy)
	var through_h7: String = RiftGravebladeMoteBinding.new(OWNER_SEED, enemy, RiftMoteField.new(OWNER_SEED), TEST_MOTE).connect_to_death()
	_expect(through_h7 == ALREADY_DEAD and not enemy.is_alive(), "a fresh binding answered '%s'" % through_h7)
	var before: String = _whole(runtime, enemy)
	var refused: int = 0
	for attempt: int in 2:
		var answer: String = runtime.register_graveblade(enemy, TEST_MOTE)
		_expect_refused(answer, ALREADY_DEAD, "registration attempt %d of an already-dead Graveblade" % (attempt + 1))
		var after: String = _whole(runtime, enemy)
		_expect(after == before, "registration attempt %d moved %s to %s" % [attempt + 1, before, after])
		if answer == ALREADY_DEAD and after == before:
			refused += 1
	## Nothing was kept, so after a lawful restore the same Graveblade may register.
	enemy.reset_encounter()
	var restored: String = runtime.register_graveblade(enemy, TEST_MOTE)
	_expect(enemy.is_alive() and restored.is_empty() and runtime.binding_count() == 1 and _binding_connections(enemy) == 1,
		"after reset_encounter() the registration answered '%s': %s" % [restored, _whole(runtime, enemy)])
	enemy.place_at(death)
	var second: PackedStringArray = _kill(enemy, attacker, enemy)
	var result: RiftMoteSweepResult = runtime.sweep_at(death)
	_sweeps += 1
	_expect(_died(enemy) == 2 and runtime.drop_count() == 1 and runtime.emission_answer(enemy).is_empty()
			and result.collected_indices() == PackedInt32Array([0]) and runtime.experience() == TEST_MOTE,
		"the restored Graveblade's death left %s" % _whole(runtime, enemy))
	print("  a Graveblade killed with nothing registered (%s): %d of 2 registrations answered '%s' — the same words a fresh binding answers — and kept nothing: %s"
		% [" -> ".join(first), refused, ALREADY_DEAD, before])
	print("  reset_encounter() restored it; it then registered ('%s'), died again at %s (%s, died %d) and one sweep paid %s"
		% [restored, str(death), " -> ".join(second), _died(enemy), _exact(runtime.experience())])
	_done("an_already_dead_graveblade_is_refused_with_h7s_own_reason_and_nothing_is_kept")


# --- 9. Seeds agreeing in their low 32 bits -------------------------------------------------------------

func _check_low_32_bit_runtimes() -> void:
	print("")
	print("--- 9. Runtimes seeded 0 and 4294967296 — equal in their low 32 bits — are two runs with two fields that share nothing")
	var low: RiftMoteRuntime = RiftMoteRuntime.new(0)
	var high: RiftMoteRuntime = RiftMoteRuntime.new(4294967296)
	_expect(low.run_seed() == 0 and high.run_seed() == 4294967296 and str(high.run_seed()) == "4294967296"
			and (low.run_seed() & LOW_32_MASK) == (high.run_seed() & LOW_32_MASK) and low.run_seed() != high.run_seed()
			and low.problem().is_empty() and high.problem().is_empty(),
		"the two runtimes read seeds %d and %d" % [low.run_seed(), high.run_seed()])
	var low_enemy: PrototypeGraveblade = _graveblade("LowSeeded", Vector3(120.0, 0.0, 0.0), _stage)
	var high_enemy: PrototypeGraveblade = _graveblade("HighSeeded", Vector3(120.0, 0.0, 20.0), _stage)
	_expect_accepted(low.register_graveblade(low_enemy, TEST_MOTE), "the seed-0 runtime's registration")
	_expect_accepted(high.register_graveblade(high_enemy, TEST_MOTE), "the seed-4294967296 runtime's registration")
	_expect(low.is_registered(low_enemy) and not low.is_registered(high_enemy) and high.is_registered(high_enemy)
			and not high.is_registered(low_enemy) and low.binding_count() == 1 and high.binding_count() == 1,
		"registration crossed runtimes")
	_kill(low_enemy, low_enemy, low_enemy)
	var after_low: String = "%d / %d" % [low.drop_count(), high.drop_count()]
	_kill(high_enemy, high_enemy, high_enemy)
	var after_high: String = "%d / %d" % [low.drop_count(), high.drop_count()]
	var low_result: RiftMoteSweepResult = low.sweep_at(low_enemy.global_position)
	var paid: String = "%s / %s" % [_exact(low.experience()), _exact(high.experience())]
	var high_result: RiftMoteSweepResult = high.sweep_at(high_enemy.global_position)
	_sweeps += 2
	_expect(after_low == "1 / 0" and after_high == "1 / 1" and paid == "%s / %s" % [_exact(TEST_MOTE), _exact(0.0)]
			and low_result.collected_indices() == PackedInt32Array([0]) and high_result.collected_indices() == PackedInt32Array([0])
			and low.experience() == TEST_MOTE and high.experience() == TEST_MOTE,
		"drops after each death %s then %s; paid %s after the first sweep" % [after_low, after_high, paid])
	print("  seeds %d and %d agree in their low 32 bits (%d) and read back whole; each registered its own Graveblade and not the other's"
		% [low.run_seed(), high.run_seed(), low.run_seed() & LOW_32_MASK])
	print("  drops (seed 0 / seed 4294967296) after the first death %s, after the second %s; the first sweep paid %s; each run was paid only by its own sweep"
		% [after_low, after_high, paid])
	_done("seeds_agreeing_in_their_low_32_bits_make_different_runtimes")


# --- 10. Every signed seed family ----------------------------------------------------------------------------

func _check_every_signed_seed() -> void:
	print("")
	print("--- 10. Negative, minimum and maximum signed 64-bit seeds each run the whole chain")
	var whole: int = 0
	var spellings: PackedStringArray = PackedStringArray()
	for index: int in SEED_FAMILIES.size():
		var row: Array = SEED_FAMILIES[index]
		var run_seed: int = int(row[0])
		spellings.append(String(row[1]))
		var runtime: RiftMoteRuntime = RiftMoteRuntime.new(run_seed)
		var enemy: PrototypeGraveblade = _graveblade("Seeded%d" % index, Vector3(140.0, 0.0, 8.0 * index), _stage)
		var answer: String = runtime.register_graveblade(enemy, TEST_MOTE)
		_kill(enemy, enemy, enemy)
		var result: RiftMoteSweepResult = runtime.sweep_at(enemy.global_position)
		_sweeps += 1
		var held: bool = (runtime.run_seed() == run_seed and str(runtime.run_seed()) == String(row[1])
			and runtime.level() == 1 and runtime.problem().is_empty() and answer.is_empty()
			and runtime.drop_count() == 1 and result.collected_indices() == PackedInt32Array([0])
			and runtime.experience() == TEST_MOTE and not runtime.is_offer_active())
		_expect(held, "seed %s: %s" % [String(row[1]), _snapshot(runtime)])
		if held:
			whole += 1
	print("  seeds %s: %d of %d read back whole, registered, dropped on death and paid %s to their own run"
		% [", ".join(spellings), whole, SEED_FAMILIES.size(), _exact(TEST_MOTE)])
	_done("negative_minimum_and_maximum_seeds_run_the_whole_chain")


# --- 11. Four motes, to the requirement ----------------------------------------------------------------

func _check_four_motes_to_the_requirement() -> void:
	print("")
	print("--- 11. Four independent test motes of 25.0 sweep to exactly Level 1's requirement, and nothing opens or advances")
	var runtime: RiftMoteRuntime = RiftMoteRuntime.new(OWNER_SEED)
	var centre: Vector3 = Vector3(200.0, 0.0, 0.0)
	var places: Array[Vector3] = [
		Vector3(199.0, 0.0, 0.0), Vector3(201.0, 0.0, 0.0), Vector3(200.0, 0.0, -1.0), Vector3(200.0, 0.0, 1.0),
	]
	var enemies: Array[PrototypeGraveblade] = []
	for index: int in places.size():
		var enemy: PrototypeGraveblade = _graveblade("Quartet%d" % index, places[index], _stage)
		_expect_accepted(runtime.register_graveblade(enemy, TEST_MOTE), "quartet registration %d" % index)
		enemies.append(enemy)
	for enemy: PrototypeGraveblade in enemies:
		_kill(enemy, enemy, enemy)
	var before_sweep: String = _snapshot(runtime)
	_expect(runtime.binding_count() == 4 and runtime.drop_count() == 4 and runtime.uncollected_count() == 4
			and runtime.experience() == 0.0,
		"four deaths left %s" % before_sweep)
	var result: RiftMoteSweepResult = runtime.sweep_at(centre)
	_sweeps += 1
	var requirement: RiftLevelRequirementReading = RiftLevelRequirementCurve.requirement_for(1)
	var needed: float = requirement.experience_requirement() if requirement.ok else -1.0
	var at_requirement: String = _snapshot(runtime)
	_expect(result.ok and result.collected_indices() == PackedInt32Array([0, 1, 2, 3])
			and runtime.experience() == FOUR_MOTES and needed == FOUR_MOTES and runtime.level() == 1
			and not runtime.is_offer_active() and runtime.collected_count() == 4,
		"one sweep answered %s; the runtime reads %s against a requirement of %s" % [_sweep(result), at_requirement, _exact(needed)])
	## Nothing advances on its own: another sweep, with nothing left to collect, moves nothing.
	var again: RiftMoteSweepResult = runtime.sweep_at(centre)
	_sweeps += 1
	_expect(again.ok and again.skipped_count == 4 and again.attempted_count == 0 and _snapshot(runtime) == at_requirement,
		"a further sweep answered %s and moved the runtime to %s" % [_sweep(again), _snapshot(runtime)])
	## A TWIN run given the same four amounts directly holds the same progress, and opens
	## an offer the moment it is explicitly asked to — so the runtime's closed offer is
	## a runtime that was never asked, not a requirement that was not met.
	var twin: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(OWNER_SEED)
	for _mote: int in 4:
		_expect_accepted(twin.award_experience(TEST_MOTE), "a twin award")
	var twin_progress: float = twin.experience()
	var opened: String = twin.open_current_offer(
		SkillSupportCatalogue.skill_profiles(), SkillSupportCatalogue.support_definitions(), PassiveCardCatalogue.records())
	_expect(twin_progress == runtime.experience() and opened.is_empty() and twin.is_offer_active() and twin.level() == 1
			and not runtime.is_offer_active() and runtime.level() == 1,
		"a twin run at %s answered '%s' when asked to open; the runtime reads %s" % [_exact(twin_progress), opened, _snapshot(runtime)])
	print("  %d Graveblades registered at %s each and killed: %s" % [enemies.size(), _exact(TEST_MOTE), before_sweep])
	print("  one sweep collected %s: experience %s = G1's Level 1 requirement %s; level %d, offer %s"
		% [str(result.collected_indices()), _exact(runtime.experience()), _exact(needed), runtime.level(),
			str(runtime.is_offer_active())])
	print("  a further sweep skipped %d and moved nothing; a twin run awarded the same 4 x %s directly holds %s and opened an offer when explicitly asked ('%s') — the runtime, never asked, is still level %d with no offer"
		% [again.skipped_count, _exact(TEST_MOTE), _exact(twin_progress), opened, runtime.level()])
	_done("four_motes_reach_exactly_the_level_one_requirement_and_nothing_levels")


# --- 12. A freed registered Graveblade ------------------------------------------------------------------

func _check_a_freed_graveblade() -> void:
	print("")
	print("--- 12. A registered Graveblade freed by its scene is reported by problem(); nothing is pruned, and registering and sweeping carry on")
	var runtime: RiftMoteRuntime = RiftMoteRuntime.new(OWNER_SEED)
	var untouched: RiftMoteRuntime = RiftMoteRuntime.new(OWNER_SEED)
	var freed: PrototypeGraveblade = _graveblade("Freed", Vector3(220.0, 0.0, 0.0), _stage)
	var later: PrototypeGraveblade = _graveblade("Later", Vector3(226.0, 0.0, 0.0), _stage)
	_expect_accepted(runtime.register_graveblade(freed, TEST_MOTE), "the soon-freed Graveblade's registration")
	var coherent: String = runtime.problem()
	var run_before: String = _run_readings(runtime)
	freed.free()
	var reported: String = runtime.problem()
	var kept_after_free: int = runtime.binding_count()
	_expect(coherent.is_empty() and reported == FREED and runtime.binding_count() == 1 and runtime.drop_count() == 0
			and _run_readings(runtime) == run_before,
		"after the free problem() answered '%s' with %d bindings and %d drops" % [reported, runtime.binding_count(), runtime.drop_count()])
	var later_answer: String = runtime.register_graveblade(later, TEST_MOTE)
	_expect(later_answer.is_empty() and runtime.binding_count() == 2 and runtime.is_registered(later),
		"a new Graveblade's registration after the free answered '%s'" % later_answer)
	var ladder: PackedStringArray = _kill(later, later, later)
	var result: RiftMoteSweepResult = runtime.sweep_at(later.global_position)
	_sweeps += 1
	_expect(runtime.drop_count() == 1 and result.collected_indices() == PackedInt32Array([0])
			and runtime.experience() == TEST_MOTE and runtime.problem() == FREED and untouched.problem().is_empty(),
		"after the free the chain answered %s and problem() '%s'" % [_sweep(result), runtime.problem()])
	print("  problem() read '%s' before the free and '%s' after it; %d binding kept — none pruned — and the run unchanged: %s"
		% [coherent, reported, kept_after_free, run_before])
	print("  a new Graveblade then registered ('%s'), died (%s), and one sweep paid %s; problem() still reads the freed entry; an untouched runtime reads '%s'"
		% [later_answer, " -> ".join(ladder), _exact(runtime.experience()), untouched.problem()])
	_done("a_freed_registered_graveblade_is_reported_and_changes_nothing_else")


# --- 13. Nothing collects on its own -----------------------------------------------------------------

## The one check that lets frames pass. It runs LAST among the behavioural checks, so
## no later check depends on where a Graveblade stands after them.
func _check_nothing_collects_on_its_own() -> void:
	print("")
	print("--- 13. A dropped mote stays uncollected, and no experience moves, while process and physics frames pass; only an explicit sweep collects it")
	var runtime: RiftMoteRuntime = RiftMoteRuntime.new(OWNER_SEED)
	var enemy: PrototypeGraveblade = _graveblade("Unswept", Vector3(240.0, 0.0, 0.0), _stage)
	_expect_accepted(runtime.register_graveblade(enemy, TEST_MOTE), "the unswept Graveblade's registration")
	_kill(enemy, enemy, enemy)
	var fell_at: Vector3 = enemy.global_position
	var before: String = _snapshot(runtime)
	var process_before: int = Engine.get_process_frames()
	var physics_before: int = Engine.get_physics_frames()
	for _frame: int in 3:
		await process_frame
	for _frame: int in 3:
		await physics_frame
	var processed: int = Engine.get_process_frames() - process_before
	var stepped: int = Engine.get_physics_frames() - physics_before
	var after: String = _snapshot(runtime)
	_expect(processed >= 3 and stepped >= 3 and after == before and runtime.uncollected_count() == 1
			and runtime.experience() == 0.0,
		"after %d process and %d physics frames the runtime moved from %s to %s" % [processed, stepped, before, after])
	var result: RiftMoteSweepResult = runtime.sweep_at(fell_at)
	_sweeps += 1
	_expect(result.collected_indices() == PackedInt32Array([0]) and runtime.experience() == TEST_MOTE,
		"the explicit sweep answered %s" % _sweep(result))
	print("  %s held unchanged while process and physics frames passed; then one explicit sweep collected %s and paid %s (%d process and %d physics frames)"
		% [before, str(result.collected_indices()), _exact(runtime.experience()), processed, stepped])
	_done("nothing_collects_on_its_own_while_frames_pass")


# --- 14. The fields and the bodies ------------------------------------------------------------------

func _check_the_fields_and_bodies() -> void:
	print("")
	print("--- 14. Three declared fields, written in three places; every method's whole body pinned; nothing handed out")
	var raw: String = FileAccess.get_file_as_string(RUNTIME_FILE)
	var code: String = _code_only(raw)
	_expect(raw.length() > 3000 and code.length() > 1000, "the file reads as %d / %d characters" % [raw.length(), code.length()])

	var signatures: PackedStringArray = _signatures_of(RUNTIME_FILE)
	_expect(signatures == PackedStringArray(RUNTIME_SIGNATURES), "the runtime declares: %s" % " | ".join(signatures))
	var script: GDScript = load(RUNTIME_FILE) as GDScript
	_expect(script.get_script_constant_map().is_empty() and script.get_script_signal_list().is_empty()
			and script.get_instance_base_type() == &"RefCounted",
		"the runtime declares constants or signals, or is not a RefCounted")

	var declarations: PackedStringArray = PackedStringArray()
	for line: String in code.split("\n"):
		if line.begins_with("var ") or line.begins_with("static ") or line.begins_with("const ") \
				or line.begins_with("signal ") or line.begins_with("enum ") or line.begins_with("@"):
			declarations.append(line.strip_edges())
	_expect(declarations == PackedStringArray(RUNTIME_DECLARATIONS), "the top-level declarations are: %s" % " | ".join(declarations))

	var probe: RiftMoteRuntime = RiftMoteRuntime.new(OWNER_SEED)
	var names: PackedStringArray = PackedStringArray()
	var typed: int = 0
	var keyed: String = ""
	for entry: Dictionary in probe.get_property_list():
		if int(entry.get("usage", 0)) & PROPERTY_USAGE_SCRIPT_VARIABLE == 0:
			continue
		var type_id: int = int(entry.get("type", 0))
		if names.size() < RUNTIME_TYPES.size() and type_id == RUNTIME_TYPES[names.size()]:
			typed += 1
		if String(entry.get("name", "")) == "_bindings":
			keyed = String(entry.get("hint_string", ""))
		names.append(String(entry.get("name", "")))
	_expect(names == PackedStringArray(RUNTIME_FIELDS) and typed == RUNTIME_FIELDS.size()
			and keyed.contains("PrototypeGraveblade") and keyed.contains("RiftGravebladeMoteBinding"),
		"the runtime holds %s (the collection typed '%s')" % [", ".join(names), keyed])

	var writes: PackedStringArray = PackedStringArray()
	var write: RegEx = RegEx.create_from_string("^\\s*(_run|_field|_bindings)(\\[[^\\]]*\\])?\\s*([-+*/]?=)(?!=)")
	for line: String in code.split("\n"):
		if write.search(line) != null:
			writes.append(line.strip_edges())
	_expect(writes == PackedStringArray(RUNTIME_WRITES), "the fields are written as: %s" % " | ".join(writes))

	## EVERY METHOD'S WHOLE BODY, LINE FOR LINE.
	var mismatched: PackedStringArray = PackedStringArray()
	for body: Array in METHOD_BODIES:
		var declaration: String = String(body[0])
		var found: PackedStringArray = _method_code(code, declaration.get_slice("(", 0) + "(")
		if found != PackedStringArray(body):
			mismatched.append("%s reads %s" % [declaration.get_slice("(", 0), " | ".join(found)])
	_expect(mismatched.is_empty() and METHOD_BODIES.size() == RUNTIME_SIGNATURES.size(),
		"method bodies differ: %s" % "; ".join(mismatched))
	## The duplicate gate stands before the one binding is made, and the binding is kept
	## only on the line after its refusal gate returns.
	var register: PackedStringArray = _method_code(code, "func register_graveblade(")
	var duplicate_gate: int = register.find("if _bindings.has(enemy):")
	var made: int = register.find("var binding: RiftGravebladeMoteBinding = RiftGravebladeMoteBinding.new(_run.run_seed(), enemy, _field, base_experience)")
	var kept: int = register.find("_bindings[enemy] = binding")
	_expect(duplicate_gate >= 0 and made == duplicate_gate + 2 and kept == made + 4
			and register[kept - 2] == "if not refusal.is_empty():" and register[kept - 1] == "return refusal",
		"the duplicate gate, the binding and its keeping are not in order: %d / %d / %d" % [duplicate_gate, made, kept])

	## EACH HELD OBJECT IS ASKED EXACTLY WHAT IT MAY BE ASKED.
	var asked: Array = [["_run", RUN_CALLS], ["_field", FIELD_CALLS], ["_bindings", BINDINGS_CALLS]]
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
	_expect(code.count(".new(") == 3 and code.count("connect_to_death()") == 1 and code.count("sweep_collection(") == 1
			and code.count("in _bindings:") == 0 and code.count("in _bindings.keys():") == 1
			and code.count("in _bindings.values():") == 1 and code.count("_bindings[") == 3,
		"the runtime makes, connects, sweeps or walks its collection other than once each")

	## NOTHING IS HANDED OUT: only the constructor and the sweep declare an object
	## answer, and every reading of a live runtime answers a scalar or a string.
	var object_answers: PackedStringArray = PackedStringArray()
	for signature: String in signatures:
		if signature.ends_with("-> Object"):
			object_answers.append(signature.get_slice("(", 0))
	var readings: Array = [
		probe.run_seed(), probe.level(), probe.experience(), probe.is_offer_active(), probe.binding_count(),
		probe.drop_count(), probe.collected_count(), probe.uncollected_count(), probe.is_registered(null),
		probe.has_observed_death(null), probe.emission_answer(null), probe.problem(),
	]
	var leaked: int = 0
	for value: Variant in readings:
		if typeof(value) in [TYPE_OBJECT, TYPE_ARRAY, TYPE_DICTIONARY, TYPE_NIL]:
			leaked += 1
	## Roguelite I3 (D-295): the one build reading declares an object answer too — the
	## run's own independent copy, which the I3 suite proves is a copy.
	_expect(object_answers == PackedStringArray(["_init", "sweep_at", "choose_level_up_lane", "run_build"]) and leaked == 0,
		"these methods declare an object answer: %s; %d readings answered an object" % [", ".join(object_answers), leaked])

	var deferred: PackedStringArray = PackedStringArray()
	var offering: PackedStringArray = PackedStringArray()
	for signature: String in signatures:
		var method: String = signature.get_slice("(", 0)
		for token: String in DEFERRED_MEMBER_TOKENS:
			if method.contains(token) and not I1_METHODS.has(method):
				deferred.append("%s (%s)" % [method, token])
		if method.contains("offer"):
			offering.append(method)
	_expect(deferred.is_empty() and offering == PackedStringArray(OFFER_MEMBERS),
		"deferred members: %s; offer members: %s" % [", ".join(deferred), ", ".join(offering)])
	print("  %d fields declared exactly (%s), the collection typed '%s'; written only as %s"
		% [declarations.size(), ", ".join(names), keyed, " | ".join(writes)])
	print("  %d methods pinned, none defaulting an argument, only _init, sweep_at, choose_level_up_lane and run_build declaring an object answer; every whole body pinned line for line; the duplicate gate two lines before the one binding is made, and the binding kept on the line after its refusal returns"
		% signatures.size())
	print("  asked: %s; 3 objects made, 1 connection asked for, 1 sweep; the collection walked only through its keys and its values; 0 open, choose, reset, prune, transfer, save or timer members but I1's six delegations, and no offer member but is_offer_active, I1's five and Roguelite I10's two"
		% "; ".join(reached))
	_done("the_runtime_holds_three_fields_and_every_method_is_pinned")


# --- 15. The shape ---------------------------------------------------------------------------------------------

func _check_the_shape() -> void:
	print("")
	print("--- 15. The runtime names no balance value, no enemy content, no room, round or encounter, and no other foundation's member, and names only what it composes")
	var raw: String = FileAccess.get_file_as_string(RUNTIME_FILE)
	var code: String = _code_only(raw)
	var hits: PackedStringArray = PackedStringArray()
	## Every forbidden token is owed zero times, except the four Foundation I1 (D-291)
	## owes exactly once each.
	for token: String in FORBIDDEN_TOKENS:
		var owed: int = _granted_occurrences(token)
		if raw.count(token) != owed:
			hits.append(token if owed == 0 else "%s %d times, not %d" % [token, raw.count(token), owed])
	## Behaviour is read from CODE WITH ITS STRINGS EMPTIED: a refusal sentence may say
	## "registered" without the runtime doing anything about a room.
	var bare: String = RegEx.create_from_string("\"([^\"\\\\]|\\\\.)*\"").sub(code, "\"\"", true)
	## Only Foundation I1's five pinned declaration lines are lifted out; every behaviour
	## token still holds over every other line.
	var behaviour_lines: PackedStringArray = PackedStringArray()
	for line: String in bare.split("\n"):
		if not I1_DECLARATION_LINES.has(line.strip_edges()):
			behaviour_lines.append(line)
	var behaviour: String = "\n".join(behaviour_lines)
	for token: String in BEHAVIOUR_TOKENS:
		if behaviour.contains(token):
			hits.append("code: %s" % token)
	for operator: String in ["+", "*", "/", "&", "|", "^", "<<", ">>"]:
		if bare.contains(operator):
			hits.append("operator %s" % operator)
	if bare.replace("->", "").contains("-"):
		hits.append("operator -")
	var formats: int = RegEx.create_from_string("\"\"\\s*%").search_all(bare).size()
	if bare.count("%") != formats or formats != 1:
		hits.append("%% outside formatting (%d of %d)" % [formats, bare.count("%")])
	var literals: PackedStringArray = _numeric_literals(code)
	if not literals.is_empty():
		hits.append("literals %s" % str(literals))
	_expect(hits.is_empty(), "the runtime names or does: %s" % ", ".join(hits))

	## PER-FILE CLASS ALLOWLIST FROM THE ENGINE'S OWN CLASS LIST, BOTH DIRECTIONS.
	var all_classes: PackedStringArray = PackedStringArray()
	for entry: Dictionary in ProjectSettings.get_global_class_list():
		all_classes.append(String(entry.get("class", "")))
	_expect(all_classes.size() > 100 and all_classes.has(RUNTIME_CLASS),
		"%d project classes were enumerated, the runtime %s among them" % [
			all_classes.size(), "is" if all_classes.has(RUNTIME_CLASS) else "is NOT"])
	var overlaps: PackedStringArray = PackedStringArray()
	for class_id: String in all_classes:
		if class_id != RUNTIME_CLASS and (class_id.contains(RUNTIME_CLASS) or RUNTIME_CLASS.contains(class_id)):
			overlaps.append(class_id)
	_expect(overlaps.is_empty(), "the runtime's class name overlaps: %s" % ", ".join(overlaps))
	var misnamed: PackedStringArray = PackedStringArray()
	for class_id: String in all_classes:
		var named: bool = raw.contains(class_id)
		if named != RUNTIME_NAMES.has(class_id):
			misnamed.append("%s %s" % ["names" if named else "does not name", class_id])
	_expect(misnamed.is_empty(), "the allowlist does not hold: %s" % ", ".join(misnamed))
	print("  %d hits for %d balance, record, enemy-content, storage and other-foundation tokens and %d behaviour tokens; no arithmetic; %% only in its %d formatted sentence; literals %s"
		% [hits.size(), FORBIDDEN_TOKENS.size(), BEHAVIOUR_TOKENS.size(), formats, str(literals)])
	print("  the runtime names only %s; its name overlaps %d other class names; %d project classes read"
		% [", ".join(PackedStringArray(RUNTIME_NAMES)), overlaps.size(), all_classes.size()])
	_done("the_runtime_names_no_balance_and_only_what_it_composes")


# --- 16. Unwired ---------------------------------------------------------------------------------------------------

func _check_nothing_runs_it() -> void:
	print("")
	print("--- 16. Nothing that runs creates a runtime but its one granted review, and scripts/experience/ holds six scripts")
	var project_files: int = 0
	var referenced: PackedStringArray = PackedStringArray()
	for root_path: String in SCANNED_ROOTS:
		for path: String in _files_under(root_path, [".gd", ".tscn", ".tres"]):
			if path == RUNTIME_FILE:
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
	_expect(referenced.is_empty(), "something unauthorized creates a runtime: %s" % ", ".join(referenced))
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
	print("  %d unauthorized project files create a runtime (%d reader(s) granted by file and token); scripts/experience/ holds %d scripts; %d actions; %d files scanned"
		% [referenced.size(), AUTHORIZED_READERS.size(), experience_scripts.size(), actions, project_files])
	print("  %d refusals were asserted, %d Graveblade deaths were driven and %d sweeps were made across this suite"
		% [_refusals, _deaths_driven, _sweeps])
	_done("nothing_that_runs_creates_a_runtime_and_the_directory_holds_six_scripts")


## How many times Foundation I1 (D-291) owes `token` in the runtime's raw file — zero
## for every forbidden token it does not grant.
func _granted_occurrences(token: String) -> int:
	## Roguelite I3 (D-295) adds its one grant beside I1's, consulted the same way.
	for row: Array in I1_GRANTED_TOKENS + I3_GRANTED_TOKENS:
		if String(row[0]) == token:
			return int(row[1])
	return 0


## Whether `path` is granted `token` in `AUTHORIZED_READERS` (D-288).
func _reader_may_name(path: String, token: String) -> bool:
	for row: Array in AUTHORIZED_READERS:
		if String(row[0]) == path:
			return (row[1] as Array).has(token)
	return false


# --- Fixtures ---------------------------------------------------------------------------------------------

## One production Graveblade, named `node_name`, placed at `at` BEFORE it enters the
## tree — so its own `_ready()` latches that place as its spawn — under `parent`. Its
## `died` and `took_damage` are counted by this harness's own observers, connected
## first.
func _graveblade(node_name: String, at: Vector3, parent: Node3D) -> PrototypeGraveblade:
	var enemy: PrototypeGraveblade = (load(GRAVEBLADE_SCENE) as PackedScene).instantiate() as PrototypeGraveblade
	enemy.name = node_name
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


## How many of the Graveblade's `died` connections call into a binding — read through
## the engine's public signal API, never through the runtime.
func _binding_connections(enemy: PrototypeGraveblade) -> int:
	var count: int = 0
	for connection: Dictionary in enemy.died.get_connections():
		var callable: Callable = connection.get("callable", Callable()) as Callable
		if callable.get_object() is RiftGravebladeMoteBinding:
			count += 1
	return count


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

## Every scalar the runtime answers, as one line.
func _snapshot(runtime: RiftMoteRuntime) -> String:
	return "seed=%d level=%d experience=%s offer=%s bindings=%d drops=%d collected=%d uncollected=%d problem='%s'" % [
		runtime.run_seed(), runtime.level(), _exact(runtime.experience()), str(runtime.is_offer_active()),
		runtime.binding_count(), runtime.drop_count(), runtime.collected_count(), runtime.uncollected_count(),
		runtime.problem(),
	]


## The run's own readings alone, through the runtime.
func _run_readings(runtime: RiftMoteRuntime) -> String:
	return "seed=%d level=%d experience=%s offer=%s" % [
		runtime.run_seed(), runtime.level(), _exact(runtime.experience()), str(runtime.is_offer_active())]


## What the runtime answers about one Graveblade, and what that Graveblade's `died`
## holds.
func _enemy_state(runtime: RiftMoteRuntime, enemy: PrototypeGraveblade) -> String:
	return "registered=%s heard=%s answer='%s' alive=%s life=%s died=%d connections=%d binding_connections=%d" % [
		str(runtime.is_registered(enemy)), str(runtime.has_observed_death(enemy)), runtime.emission_answer(enemy),
		str(enemy.is_alive()), _life(enemy.life), _died(enemy), enemy.died.get_connections().size(),
		_binding_connections(enemy),
	]


## EVERYTHING A REFUSED REGISTRATION COULD HAVE MOVED, AS ONE LINE.
func _whole(runtime: RiftMoteRuntime, enemy: PrototypeGraveblade) -> String:
	return "%s | %s" % [_snapshot(runtime), _enemy_state(runtime, enemy)]


func _sweep(result: RiftMoteSweepResult) -> String:
	return "ok=%s reason='%s' total=%d skipped=%d attempted=%d collected=%s out=%d refused=%d first='%s' problem='%s'" % [
		str(result.ok), result.failure_reason, result.total_count, result.skipped_count, result.attempted_count,
		result.collected_indices(), result.out_of_range_count, result.item_refusal_count, result.first_item_refusal_reason,
		result.problem(),
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
## rendering the accepted H1–H7 and G4 pins use.
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
		TYPE_DICTIONARY:
			return "Dictionary"
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
