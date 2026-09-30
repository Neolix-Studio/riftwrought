class_name RiftMoteDrop
extends RefCounted
## Riftwrought — Roguelite Foundation H4: one Experience Mote dropped into one run,
## as a pure in-memory object that binds a run seed, a world position and one
## privately owned Experience Mote together.
##
## THE ONE THING IT PROVES. A drop belongs to exactly one run — the run whose seed
## it was made with — and may be collected only into that run. Offered to any
## other run it refuses before anything is measured or collected, and nothing
## moves. Offered to its own run it hands the whole attempt to the accepted
## single-mote collection attempt (Foundation H3), which asks the accepted
## pickup-range query (Foundation H2) and the accepted mote (Foundation H1) exactly
## as it always does, and its answer is returned unchanged.
##
## This is where the mote's deferred ownership question is answered, at the level
## of the state a spawner would hold (D-272 ruling 2): the mote itself stays run
## agnostic, and the drop around it carries the owner.
##
##
## IT HOLDS THREE THINGS, AND NOTHING ELSE
## ---------------------------------------------------------------------------
## The run seed, exactly as it was given; the world position the drop lies at,
## exactly as it was given; and one Experience Mote, which this drop makes itself
## and never hands out. There is no radius, distance, owner object, run
## reference, source, timestamp, lifetime, velocity, pool or persistence.
##
## THE RUN SEED IS COMPARED WHOLE. Every signed 64-bit integer is a run seed the
## accepted run answers for, so none is masked, folded, normalized or refused
## here, and ownership is decided by comparing the complete integer. Two seeds that
## agree only in their low 32 bits belong to two different runs.
##
## THE POSITION NEVER MOVES. There is no attraction, movement or teleportation, and
## no setter for the position or the run seed. Reading the position hands out a
## value, not the field.
##
## THE MOTE IS MADE HERE AND NEVER HANDED OUT. The constructor takes the base
## experience and builds the mote from it, so no caller can hold the mote this drop
## will pay with, collect it behind the drop's back, or pass the same mote to two
## drops. No reading returns it. There is no duplication either: a copy would be a
## second authority over the same conceptual drop, able to pay it twice.
##
## EVERY VALUE IS REQUIRED, NEVER DEFAULTED. No run seed, position or amount exists
## that nobody chose. The amount is the caller's, and establishes no balance
## value.
##
##
## THE COLLECTION ORDER IS THE CONTRACT
## ---------------------------------------------------------------------------
## 1. A drop that is not a valid record refuses, with its own problem.
## 2. A missing run refuses.
## 3. The drop's run seed is compared with the run's, whole. If they differ, the
##    attempt is refused HERE, naming both seeds: the pickup range is not
##    measured and the mote is not asked, so neither run and not the drop can move.
## 4. Only then is the whole attempt handed to the accepted single-mote collection
##    attempt, with the player's position, this drop's fixed position, this drop's
##    mote and the run.
## 5. Its answer — collected, out of range or refused — is returned exactly as it
##    was given. An already collected mote, an active offer and a mote beyond the
##    effective radius are all that attempt's answers, not this file's.
##
## WHAT IS VALID HERE. `problem()` asks only whether the drop is a well-formed
## record: its position must be finite in x, y and z, it must hold its mote, and
## the mote must be a valid record by the mote's own rule. It adds no rule of its
## own about the amount. A malformed drop stays unusable; nothing here clamps or
## repairs it.
##
## WHAT IT DOES NOT DO. It measures no distance, reads no Pickup Radius, computes no
## percentage, derives no requirement and no offer seed, and names no card, Skill or
## enemy. It spawns nothing, registers nothing, scans no list and no world, moves
## nothing, and tears nothing down. No node, no signal, no scene, no collision, no
## clock, no random source, no file. Nothing that runs creates a drop.

## The seed of the one run this drop belongs to, exactly as it was given.
var _run_seed: int

## Where this drop lies in the world, exactly as it was given. Never moved.
var _position: Vector3

## The one Experience Mote this drop pays with. Made by the constructor, and never
## handed out.
var _mote: RiftExperienceMote


## A new, uncollected drop belonging to the run seeded `for_run_seed`, lying at
## `for_position`, and holding a new mote worth `for_base_experience`. Every value
## is stored as given; `problem()` says whether they make a drop that may be
## collected.
func _init(for_run_seed: int, for_position: Vector3, for_base_experience: float) -> void:
	_run_seed = for_run_seed
	_position = for_position
	_mote = RiftExperienceMote.new(for_base_experience)


# --- Reading the drop -------------------------------------------------------------
#
# Scalars and values only, and deliberately no setter for any of them.

func run_seed() -> int:
	return _run_seed


func position() -> Vector3:
	return _position


func base_experience() -> float:
	return _mote.base_experience()


func is_collected() -> bool:
	return _mote.is_collected()


## Returns "" when this drop is a well-formed record, or the single
## plain-language reason it is not. The amount is the mote's own question.
func problem() -> String:
	if not _position.is_finite():
		return "an Experience Mote drop's position must have a finite x, y and z, not %s" % _position
	if _mote == null:
		return "an Experience Mote drop must hold its Experience Mote, and holds none"
	return _mote.problem()


# --- Collecting -------------------------------------------------------------------

## Attempts to collect this drop into `run`, for a player standing at
## `player_position`, in the order the header states. Always answers one result:
## refused, out of range, or collected.
func attempt_collection(player_position: Vector3, run: RiftRunLevelCoordinator) -> RiftMoteCollectionResult:
	var invalid: String = problem()
	if not invalid.is_empty():
		return RiftMoteCollectionResult.refused(invalid)
	if run == null:
		return RiftMoteCollectionResult.refused(
			"an Experience Mote drop must be collected into a run, and none was given")
	if run.run_seed() != _run_seed:
		return RiftMoteCollectionResult.refused(
			"this Experience Mote drop belongs to run seed %d, not to run seed %d; it may be collected only into the run that dropped it" % [_run_seed, run.run_seed()])
	return RiftMoteCollectionAttempt.attempt(player_position, _position, _mote, run)


# --- Presentation -----------------------------------------------------------------
#
# Reached by nothing above.

func describe() -> String:
	return "Experience Mote drop of run seed %d at %s, worth %s base experience; %s" % [
		_run_seed, _position, String.num_scientific(base_experience()),
		"collected" if is_collected() else "not collected",
	]
