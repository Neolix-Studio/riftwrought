class_name RiftGravebladeMoteBinding
extends RefCounted
## Riftwrought — Roguelite Foundation H7: one real Graveblade's death, heard once
## through its own `died` signal, becomes that Graveblade's one Experience Mote
## drop in the mote field of its run.
##
## THE ONE THING IT PROVES. The chain
##
##     real Graveblade death -> the bound Graveblade's position -> H6 emission -> H5 drop
##
## One binding is made for one PrototypeGraveblade, the mote field of that
## Graveblade's run, the exact seed of that run and the base experience its mote
## will carry. Asked explicitly, it checks all of that and only then listens to
## the Graveblade's existing `died` signal. When the Graveblade dies, it reads
## where THAT Graveblade stands at that moment and asks its one enemy mote
## emission (Foundation H6) to emit there, into that field, once. It keeps H6's
## exact answer. It never asks again.
##
##
## THE BOUND GRAVEBLADE IS THE ONLY AUTHORITY, AND THE EVENT IS NOT
## ---------------------------------------------------------------------------
## `died` hands its listener the lethal DamageEvent, and the callback accepts it
## only because the signal supplies it: it reads nothing from it. The event's
## source is the ATTACKER, not the defeated enemy — the roguelite core loop's
## documented defect was keying on it — and its target is only what the attacker
## aimed at. Which Graveblade fell, and where, is answered by the one Graveblade
## this binding was given: never by the event's source or target, a display name,
## a node lookup, a room, or an index.
##
##
## IT HOLDS SIX THINGS, AND NOTHING ELSE
## ---------------------------------------------------------------------------
## The bound Graveblade; the field; one H6 emission, made here from the run seed
## and the amount exactly as they were given; whether this binding has connected;
## whether it has heard a death; and H6's answer to the one emission attempt,
## which must outlive the signal callback that received it. No position is stored
## — it is read at the moment of death — and no seed, amount, drop, run, event,
## enemy record or result object is kept beside the emission, which already holds
## the seed and the amount and is the only thing that decides what they allow.
##
## EVERY VALUE IS REQUIRED, NEVER DEFAULTED. The amount is the caller's and names
## no balance value: no enemy's experience is decided, read or looked up here.
##
## CONSTRUCTION CONNECTS NOTHING. Only `connect_to_death()` connects, so a caller
## can read a configuration refusal before anything listens.
##
##
## THE CONNECTION ORDER IS THE CONTRACT
## ---------------------------------------------------------------------------
## 1. No Graveblade refuses.
## 2. No field refuses.
## 3. The emission is asked for its own problem — H1's reason for an unusable
##    amount, reached through H6 — and any answer is returned unchanged.
## 4. The field is asked for its own problem, and any answer is returned unchanged.
## 5. The field's run seed is compared with the emission's, whole. Seeds that
##    agree only in their low 32 bits belong to two different runs.
## 6. A binding that has already connected, or already heard a death, refuses.
## 7. A binding whose callback is already listening to that `died` refuses.
## 8. A Graveblade that is already dead refuses: a binding must be connected before
##    the death it hears (D-284). The Graveblade's own alive reading is asked last,
##    immediately before the connection. A binding refused for this reason stays
##    unused, so if that same Graveblade is lawfully restored it may still connect,
##    and hear its next death, once.
## 9. Only then is the callback connected, and the binding marked connected.
## A refusal connects nothing and moves nothing.
##
##
## THE DEATH ORDER IS THE CONTRACT
## ---------------------------------------------------------------------------
## 1. A binding that has already heard a death returns at once, so a later `died`
##    can neither make a second drop nor replace the first answer.
## 2. The bound Graveblade's world position is read, then, inside the callback.
## 3. The one emission is asked to emit there, into the bound field.
## 4. Its answer is kept exactly as it came back.
## 5. The death is recorded as heard.
##
## The Graveblade emits `died` from inside its own mechanical death, after it has
## stopped being a target, stopped blocking, stopped navigating and given back
## attack permission, and before its death animation starts. The drop is made
## there, inside that same call.
##
##
## ONE ATTEMPT, AND NO RETRY
## ---------------------------------------------------------------------------
## One heard death is one emission attempt. If H6 refuses it, the refusal is kept
## word for word and the emission stays pending, exactly as H6 leaves it. Nothing
## here invents another position, moves the drop to where the Graveblade was
## placed, tries again later, emits into another field, awards experience, or
## reports a refusal as success. Whether a pending reward is ever recovered
## belongs to the future runtime owner; there is deliberately no retry.
##
## WHAT IT DOES NOT DO. It awards no experience, opens no offer and advances no
## level: the drop is collected only when a caller later sweeps the field into its
## run. It creates no field, makes no enemy, polls no player, moves nothing, shows
## nothing, saves nothing, and changes nothing about the Graveblade. It is not a
## node: no scene, no clock, no timer, no random source, no file. Nothing that runs
## creates a binding.
##
## IT DOES NOT KEEP ITSELF ALIVE. A signal connection names this object without
## holding it, so whoever makes a binding must keep it for as long as its
## Graveblade can die.
##
## THE RUNTIME THAT SPAWNS A GRAVEBLADE OWNS ITS BINDING (D-284). Exactly one binding
## for each Graveblade in a run, keyed by that Graveblade, is the owner's invariant:
## nothing here searches for another binding or keeps a registry. A binding hears at
## most the first death it is connected for, and restoring the Graveblade does not
## re-arm it. A new run makes a new field, new emissions and new bindings, and
## letting go of the old bindings lets them and their connections go.

## The one Graveblade whose death this binding hears, exactly as it was given.
var _enemy: PrototypeGraveblade

## The mote field of that Graveblade's run, exactly as it was given.
var _field: RiftMoteField

## That Graveblade's one Experience Mote reward (Foundation H6), made from the run
## seed and the base experience exactly as they were given.
var _emission: RiftEnemyMoteEmission

## Whether THIS binding has ever successfully connected to its Graveblade's death —
## not whether the callback is present now: an outside disconnect does not make it
## eligible to connect again. Written once.
var _connected: bool = false

## Whether THIS binding has heard its Graveblade's death. Written once, after the
## one emission attempt.
var _death_observed: bool = false

## H6's exact answer to the one emission attempt: "" before a death is heard and
## when the drop was made, and the refusal, word for word, otherwise.
var _emission_answer: String = ""


## A new binding that has not connected, for `for_enemy`'s death, emitting into
## `for_field`, belonging to the run seeded `for_run_seed` and worth
## `for_base_experience`. Every value is stored or passed on as given; nothing is
## checked and nothing listens until `connect_to_death()` is asked.
func _init(for_run_seed: int, for_enemy: PrototypeGraveblade, for_field: RiftMoteField, for_base_experience: float) -> void:
	_enemy = for_enemy
	_field = for_field
	_emission = RiftEnemyMoteEmission.new(for_run_seed, for_base_experience)


# --- Connecting ---------------------------------------------------------------------

## Checks the binding in the order the header states and, only if every check
## passes, connects it to the bound Graveblade's existing `died` signal. Returns ""
## when it connected, or the single plain-language reason it did not — in which
## case nothing was connected and nothing moved.
func connect_to_death() -> String:
	if _enemy == null:
		return "a Graveblade's Experience Mote binding needs the Graveblade whose death it hears, and there is none"
	if _field == null:
		return "a Graveblade's Experience Mote binding needs the mote field of its run, and none was given"
	var invalid: String = _emission.problem()
	if not invalid.is_empty():
		return invalid
	var incoherent: String = _field.problem()
	if not incoherent.is_empty():
		return incoherent
	if _field.run_seed() != _emission.run_seed():
		return "this Graveblade's Experience Mote belongs to run seed %d, not to the mote field's run seed %d; it may be bound only to a field of its own run" % [
			_emission.run_seed(), _field.run_seed(),
		]
	if _connected or _death_observed:
		return "this Graveblade's Experience Mote binding has already connected or already heard a death; it connects nothing again"
	if _enemy.died.is_connected(_on_enemy_died):
		return "this Graveblade's Experience Mote binding is already listening for its Graveblade's death; it connects nothing again"
	if not _enemy.is_alive():
		return "the bound Graveblade is already dead; its Experience Mote binding must be connected before death"
	_enemy.died.connect(_on_enemy_died)
	_connected = true
	return ""


# --- Hearing the death ----------------------------------------------------------------

## Connected to the bound Graveblade's `died` by `connect_to_death()` and nothing
## else, in the order the header states. The event is accepted because the signal
## supplies it, and is read for nothing.
func _on_enemy_died(_event: DamageEvent) -> void:
	if _death_observed:
		return
	var defeat_position: Vector3 = _enemy.global_position
	_emission_answer = _emission.emit_at(defeat_position, _field)
	_death_observed = true


# --- Reading the binding --------------------------------------------------------------
#
# Scalars only, and deliberately no setter and no way to reach the Graveblade, the
# field or the emission.

func has_connected() -> bool:
	return _connected


func has_observed_death() -> bool:
	return _death_observed


## Whether the one emission has emitted — H6's own reading, never a copy of it.
func is_emitted() -> bool:
	return _emission.is_emitted()


## "" before a death is heard and when the drop was made; H6's refusal, word for
## word, when the one attempt was refused.
func emission_answer() -> String:
	return _emission_answer


# --- Presentation -----------------------------------------------------------------------
#
# Reached by nothing above.

func describe() -> String:
	var heard: String = "no death heard"
	if _death_observed and _emission_answer.is_empty():
		heard = "its death heard and its mote emitted"
	elif _death_observed:
		heard = "its death heard and its emission refused: %s" % _emission_answer
	return "Graveblade Experience Mote binding, %s, %s; %s" % [
		"connected" if _connected else "not connected", heard, _emission.describe(),
	]
