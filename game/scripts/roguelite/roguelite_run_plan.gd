class_name RogueliteRunPlan
extends RefCounted
## Riftwrought — Roguelite Core Loop Review: the run's visible deterministic
## identity, and the ONE function a future shuffle system replaces (D-220).
##
## THE SEED IS REAL AND THE SHUFFLE IS HONESTLY ABSENT, AND THOSE ARE TWO
## SEPARATE CLAIMS THIS FILE KEEPS APART ON PURPOSE.
##
## What is real: a run is identified by an integer seed, that seed derives a
## short human-readable run id through a pure function, the id is shown on
## screen, and the same seed always produces the same id. Nothing about the
## run is read from the clock, from the filesystem, or from an unseeded
## generator, so a run the project owner reports by its id can be re-entered
## exactly.
##
## What is NOT real, and is deliberately not faked: `ordered_modules()`
## returns the AUTHORED order and does not consult the seed at all.
## `selection_mode()` says so in one plain-language string that is displayed
## to the player rather than buried in a comment, and `is_shuffled()` returns
## false. The brief is explicit — "this first review uses a fixed order",
## "Do not implement broad procedural generation yet" — so a shuffle that
## happened to produce the authored order today would be a schedule wearing a
## generator's clothing, exactly the trap the project already named when it
## refused to set Level 2 at 20 XP so it would land on the last scripted kill.
##
## The seam is therefore precisely one function wide. A future run-selection
## system replaces `ordered_modules()` and changes nothing else: the seed
## already exists, is already deterministic, is already displayed, and is
## already asserted. There is no Run Graph here, no Dungeon Recipe, no
## validation pass, no connector solving, and no room pool beyond the three
## authored modules the review ships.

## The authored expedition. Every id must exist in `RogueliteRoomModule.MODULES`
## and must be a combat module; the hub is not part of the expedition.
const AUTHORED_ORDER: Array[StringName] = [&"teaching_hall", &"cache_room", &"elite_hall"]

const HUB_MODULE: StringName = &"nexus_hub"

## A fixed base so the FIRST run of a session is always the same run. Nothing
## here reads the clock: `Time` is never called, and an unseeded
## `RandomNumberGenerator` is never constructed.
const BASE_SEED: int = 0x5249_4654

const ALPHABET: String = "0123456789ABCDEF"

var seed_value: int = BASE_SEED
var run_index: int = 0


func _init(for_seed: int = BASE_SEED, index: int = 0) -> void:
	seed_value = for_seed
	run_index = index


## The next run in this session. A different seed, derived deterministically
## from this one, so a session's run ids differ visibly while the whole
## sequence is reproducible from the first.
func next() -> RogueliteRunPlan:
	return RogueliteRunPlan.new(_mix(seed_value), run_index + 1)


## A pure 32-bit avalanche mix. Deterministic, no engine RNG, no clock.
static func _mix(value: int) -> int:
	var x: int = value & 0xFFFFFFFF
	x = (x ^ (x >> 16)) * 0x7FEB_352D & 0xFFFFFFFF
	x = (x ^ (x >> 15)) * 0x846C_A68B & 0xFFFFFFFF
	x = x ^ (x >> 16)
	return x & 0xFFFFFFFF


## The visible run identifier, e.g. `RUN-3-A91C4F0B`. Pure: the same seed and
## index always produce the same string, and nothing else can change it.
func run_id() -> String:
	var digits: String = ""
	var value: int = seed_value & 0xFFFFFFFF
	for i: int in 8:
		digits = ALPHABET[value & 0xF] + digits
		value = value >> 4
	return "RUN-%d-%s" % [run_index + 1, digits]


## THE ONE FUNCTION A FUTURE SHUFFLE SYSTEM REPLACES. It ignores the seed, and
## `selection_mode()` says so on screen.
func ordered_modules() -> Array[StringName]:
	var order: Array[StringName] = []
	for id: StringName in AUTHORED_ORDER:
		order.append(id)
	return order


func is_shuffled() -> bool:
	return false


func selection_mode() -> String:
	return "authored fixed order — room shuffling is not implemented"


func room_count() -> int:
	return AUTHORED_ORDER.size()


## Returns "" when the plan is coherent, or the first problem found — the same
## `problem()` contract every tuning record in this project carries, so a bad
## edit fails loudly instead of quietly producing a run with no rooms.
func problem() -> String:
	if AUTHORED_ORDER.is_empty():
		return "a run must contain at least one module"
	if not RogueliteRoomModule.MODULES.has(HUB_MODULE):
		return "the hub module %s is not in the module records" % HUB_MODULE
	if String(RogueliteRoomModule.MODULES[HUB_MODULE]["kind"]) != "hub":
		return "%s is not a hub module" % HUB_MODULE
	for id: StringName in AUTHORED_ORDER:
		if not RogueliteRoomModule.MODULES.has(id):
			return "unknown module %s in the authored order" % id
		if String(RogueliteRoomModule.MODULES[id]["kind"]) != "combat":
			return "%s is not a combat module and cannot be an expedition room" % id
	return ""


func describe() -> String:
	return "%s — %d room(s), seed 0x%08X, %s" % [
		run_id(), room_count(), seed_value & 0xFFFFFFFF, selection_mode(),
	]
