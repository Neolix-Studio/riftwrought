class_name RiftExperienceMote
extends RefCounted
## Riftwrought — Roguelite Foundation H1: one Experience Mote, as a temporary
## in-memory object that can deliver its base experience into a run exactly once.
##
## THE ONE THING IT PROVES. A mote carries one base-experience amount and one
## fact about itself — whether it has been collected. Collecting it hands that
## exact amount to the accepted run-level coordinator (Foundation G4) and marks
## the mote collected only if the run accepted the award. A refused award leaves
## the mote exactly as it was, so it may be collected later; an accepted one can
## never be paid out again by this object.
##
##
## IT HOLDS TWO THINGS, AND NOTHING ELSE
## ---------------------------------------------------------------------------
## The base experience, exactly as the mote was made with it, and whether this
## particular mote has been collected. There is no position, movement,
## attraction, collection distance, source, owner, timestamp, rarity, pool or
## persistence: where a mote lies, how it reaches the character and what dropped
## it are all decided elsewhere, and none of them is decided yet.
##
## THE AMOUNT IS REQUIRED, NEVER DEFAULTED. The constructor takes the base
## experience as a required argument, so no mote exists with an amount nobody
## chose — a default here would silently become the game's first enemy-experience
## value, chosen by whoever needed a test to compile.
##
## A COLLECTED MOTE STAYS COLLECTED FOR AS LONG AS THIS OBJECT LIVES. There is no
## reset, respawn or copy. Two motes of the same amount are two objects, and each
## may be collected once.
##
##
## WHAT IS VALID HERE, AND WHAT IS NOT DECIDED HERE
## ---------------------------------------------------------------------------
## `problem()` asks only whether the mote is a well-formed record: its base
## experience must be finite and strictly positive. It does NOT ask whether the
## award will be recordable once Experience Gain has been applied — the run's
## accepted award path owns that question, answers it at collection time against
## what the run holds at that moment, and may still refuse a perfectly valid
## mote. In that case the mote simply stays uncollected.
##
##
## THE COLLECTION ORDER IS THE CONTRACT
## ---------------------------------------------------------------------------
## 1. A mote already collected refuses first, whatever else is true.
## 2. A mote that is not a valid record refuses next, with its own problem.
## 3. A missing run refuses next.
## 4. The exact stored base experience is handed to the run's award path — not
##    scaled, rounded or checked against anything here.
## 5. If the run refuses, its reason is returned verbatim and the mote is left
##    uncollected.
## 6. Only after the run has accepted the award is the mote marked collected.
##
## NO PERCENTAGE ARITHMETIC, NO THRESHOLD, NO SEED AND NO OFFER. Experience Gain,
## the level requirement, the offer root seed and the offer itself all belong to
## the run's accepted mechanisms, and this file asks the run to do one thing and
## decides none of them. Collecting enough experience for a level opens nothing
## and advances nothing: the caller still asks the run to open and to choose.
##
## TERMINOLOGY. This is an Experience Mote in the sense the owner fixed. It is
## not yet classified for automatic pickup, it reads no Pickup Radius, and it
## changes nothing about which run resources that stat will one day apply to.
##
## STILL ABSENT, AND DELIBERATELY: enemy experience values and death hooks,
## spawning, attraction, movement and collection distance, a Pickup Radius base,
## automatic-pickup classification, pooling, offer presentation, pausing, input,
## scenes, saving and balance. No node, no signal, no clock, no random source, no
## file. Nothing that runs creates or collects a mote.

## The base experience this mote delivers, exactly as it was made with it.
var _base_experience: float

## Whether THIS mote has been collected. Written once, and only after a run has
## accepted its award.
var _collected: bool = false


## A new, uncollected mote worth `for_base_experience`. The amount is stored as
## given; `problem()` says whether it is one a mote may carry.
func _init(for_base_experience: float) -> void:
	_base_experience = for_base_experience


# --- Reading the mote -------------------------------------------------------------
#
# Scalars only, and deliberately no setter for either.

func base_experience() -> float:
	return _base_experience


func is_collected() -> bool:
	return _collected


## Returns "" when this mote is a well-formed record, or the single
## plain-language reason it is not. Record shape only: whether its award is
## recordable after Experience Gain is the run's question, not this one.
func problem() -> String:
	if not is_finite(_base_experience):
		return "an Experience Mote's base experience must be a finite number, not %s" \
			% String.num_scientific(_base_experience)
	if _base_experience <= 0.0:
		return "an Experience Mote's base experience must be positive, not %s" \
			% String.num_scientific(_base_experience)
	return ""


# --- Collecting --------------------------------------------------------------------

## Delivers this mote's exact base experience into `run`, once. Returns "" when
## the run accepted it, or the single plain-language reason it did not. A refusal
## leaves the mote uncollected and asks the run for nothing it could move.
func collect_into(run: RiftRunLevelCoordinator) -> String:
	if _collected:
		return "this Experience Mote has already been collected; it delivers nothing again"
	var invalid: String = problem()
	if not invalid.is_empty():
		return invalid
	if run == null:
		return "an Experience Mote must be collected into a run, and none was given"
	var refusal: String = run.award_experience(_base_experience)
	if not refusal.is_empty():
		return refusal
	_collected = true
	return ""


# --- Presentation ---------------------------------------------------------------
#
# Reached by nothing above.

func describe() -> String:
	return "Experience Mote worth %s base experience; %s" % [
		String.num_scientific(_base_experience),
		"collected" if _collected else "not collected",
	]
