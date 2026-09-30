class_name RiftEnemyMoteEmission
extends RefCounted
## Riftwrought — Roguelite Foundation H6: the one Experience Mote reward that
## belongs to one defeated enemy, emitted into its own run's mote field exactly
## once.
##
## THE ONE THING IT PROVES. One enemy reward becomes one drop. An emission is made
## for one future enemy instance, with the exact seed of the run that enemy belongs
## to and the base experience its mote will carry. Asked to emit at the place the
## enemy fell, into the mote field of its own run, it asks that field to make one
## drop there worth exactly that amount, and records that it has emitted only after
## the field confirms the drop was appended. It never emits again. Asked to emit
## into another run's field, it refuses before that field is asked to make anything.
##
##
## IT HOLDS THREE THINGS, AND NOTHING ELSE
## ---------------------------------------------------------------------------
## The run seed, exactly as it was given; the base experience, exactly as it was
## given; and whether this emission has emitted. There is no enemy object, enemy
## id, enemy family, position, field, run, drop, mote, result, timestamp, round,
## level, derived seed or balance table. Where the enemy fell is the caller's to
## say at the moment of emission, and the field is the caller's to supply.
##
## EVERY VALUE IS REQUIRED, NEVER DEFAULTED. The constructor takes both the run
## seed and the amount, so no emission exists with an owner or an amount nobody
## chose. The amount is the caller's and establishes no balance value: no enemy's
## experience is decided here.
##
## THE RUN SEED IS COMPARED WHOLE. Every signed 64-bit integer is a run seed, so
## none is masked, folded, normalized or refused here. Two seeds that agree only in
## their low 32 bits belong to two different runs.
##
## AN EMISSION THAT HAS EMITTED STAYS EMITTED FOR AS LONG AS THIS OBJECT LIVES.
## There is no reset, re-arm, copy or transfer. Two emissions of the same amount
## are two enemies' rewards, and each may emit once.
##
##
## WHAT IS VALID HERE
## ---------------------------------------------------------------------------
## `problem()` asks Foundation H1 whether the stored amount is one an Experience
## Mote may carry, by making a temporary mote of that amount and returning that
## mote's own answer word for word. The temporary mote is never stored and never
## handed out, and this file states no amount rule of its own. The run seed needs
## no rule: every one is valid.
##
##
## THE EMISSION ORDER IS THE CONTRACT
## ---------------------------------------------------------------------------
## 1. An emission that has already emitted refuses first, whatever else is true.
## 2. An emission whose stored amount is not valid refuses next, with H1's reason.
## 3. A missing field refuses next.
## 4. The field is asked for its own problem, and any answer is returned unchanged.
## 5. The field's run seed is compared with this emission's, whole. If they differ
##    the emission is refused HERE, naming both seeds, before the field is asked to
##    make anything — so neither the field nor this emission moves.
## 6. Only then is the field asked to make one drop at the defeat position, worth
##    the stored amount, neither value transformed.
## 7. If the field refuses, its reason — the new drop's own — is returned verbatim,
##    nothing was appended, and this emission stays available for a later valid
##    attempt.
## 8. Only after the field has confirmed the drop was appended is this emission
##    marked emitted.
##
## WHAT IT DOES NOT DO. It awards no experience, opens no offer and advances no
## level: the drop it causes is collected only when a caller sweeps that field into
## its run. It measures no distance, computes no amount, reads no enemy record,
## listens to no death, creates no field, scans no world, moves nothing and hands
## out nothing. No node, no signal, no scene, no clock, no random source, no file.
## Nothing that runs creates an emission.

## The seed of the one run this enemy's reward belongs to, exactly as it was given.
var _run_seed: int

## The base experience this reward's one mote will carry, exactly as it was given.
var _base_experience: float

## Whether THIS emission has emitted its one drop. Written once, and only after the
## field confirmed the drop was appended.
var _emitted: bool = false


## A new emission that has not emitted, belonging to the run seeded `for_run_seed`
## and worth `for_base_experience`. Both are stored as given; `problem()` says
## whether the amount is one a mote may carry.
func _init(for_run_seed: int, for_base_experience: float) -> void:
	_run_seed = for_run_seed
	_base_experience = for_base_experience


# --- Reading the emission ---------------------------------------------------------
#
# Scalars only, and deliberately no setter for any of them.

func run_seed() -> int:
	return _run_seed


func base_experience() -> float:
	return _base_experience


func is_emitted() -> bool:
	return _emitted


## Returns "" when the stored amount is one an Experience Mote may carry, or H1's
## own plain-language reason it is not, word for word. The temporary mote that
## answers is made here and let go here.
func problem() -> String:
	return RiftExperienceMote.new(_base_experience).problem()


# --- Emitting ----------------------------------------------------------------------

## Emits this enemy's one Experience Mote into `field`, lying at `defeat_position`,
## in the order the header states. Returns "" when the field appended the drop, or
## the single plain-language reason it did not. A refusal leaves this emission
## exactly as it was, so it may emit later.
func emit_at(defeat_position: Vector3, field: RiftMoteField) -> String:
	if _emitted:
		return "this enemy's Experience Mote has already been emitted; it emits nothing again"
	var invalid: String = problem()
	if not invalid.is_empty():
		return invalid
	if field == null:
		return "an enemy's Experience Mote must be emitted into a mote field, and none was given"
	var incoherent: String = field.problem()
	if not incoherent.is_empty():
		return incoherent
	if field.run_seed() != _run_seed:
		return "this enemy's Experience Mote belongs to run seed %d, not to the mote field's run seed %d; it may be emitted only into a field of its own run" % [
			_run_seed, field.run_seed(),
		]
	var refusal: String = field.spawn_drop(defeat_position, _base_experience)
	if not refusal.is_empty():
		return refusal
	_emitted = true
	return ""


# --- Presentation -------------------------------------------------------------------
#
# Reached by nothing above.

func describe() -> String:
	return "Enemy Experience Mote emission of run seed %d, worth %s base experience; %s" % [
		_run_seed, String.num_scientific(_base_experience),
		"emitted" if _emitted else "not emitted",
	]
