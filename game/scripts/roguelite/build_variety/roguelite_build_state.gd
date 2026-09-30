class_name RogueliteBuildState
extends RefCounted
## Riftwrought — Roguelite Build Variety V1: the temporary BUILD one expedition
## acquires, and nothing that outlives it (decision D-223).
##
## THIS OBJECT IS THE DEFINITION OF "TEMPORARY UPGRADE COMBINATION", AND THE
## WHOLE RESET RULE IS "THROW IT AWAY AND BUILD A NEW ONE" — the same shape
## `RogueliteRunState` chose, for the same recorded reason: a `clear()` that
## forgets one field is exactly how the Gate 1E adversarial review found Start
## Fresh writing the old character straight back on the next autosave. The
## runtime replaces the whole object, so a field added later cannot be
## forgotten.
##
## THE ACQUIRED SET IS THE AUTHORITY ON BOTH QUESTIONS THE OFFER RULES ASK, and
## it is ONE list rather than two counters. "Which upgrades do I hold?" and "how
## many choices have I made?" are both derived from it — `held()` and
## `count()` — so there is no second number that can drift out of step with the
## first. That is the same discipline `PassiveWeb.spent()` used at Gate 1E,
## where points were conserved BY CONSTRUCTION because the spent total was
## derived from the allocated set rather than counted beside it.
##
## IT IS DELIBERATELY NOT PROGRESSION. There is no experience, no level, no
## passive point, no currency, no unlock, no permanent record, no profile and no
## schema version. Nothing here is written to disk: this class has no save,
## load, serialize, storage_path or `user://` anywhere in it, and the review's
## verification asserts that by scanning the source.
##
## `design/FIRST_MVP_SCOPE_LOCK_AND_INTEGRATION_AUDIT.md` §11 names exactly
## three save-state buckets. Everything here is §11.3 Active-Run State, exactly
## as the accepted temporary weapon and the accepted D-222 boon are.

## Every upgrade this expedition holds, in the order it was taken. Typed
## `Array[int]` rather than `Array[RogueliteUpgrade.Kind]`: GDScript typed
## arrays accept built-in types and classes, not enum hints, and an enum value
## is an int.
var acquired: Array[int] = []

## The live values as they stood the moment the run ENDED, captured before the
## run-scoped reset returns everything to baseline. Empty until `capture()` is
## called. It exists for exactly one reason: `_complete_run()` resets the run
## and only then opens the summary, deliberately, so the Nexus banner behind the
## panel is already telling the truth — which means the panel cannot read the
## live values it is reporting on.
var final_values: Dictionary = {}

## Refusal instrumentation, the same shape `PlayerLoadout`, `LabProgress` and
## `RogueliteRunState` all carry: a door that refuses says so and counts it.
var refusals: int = 0
var last_refusal: String = "none"


func count() -> int:
	return acquired.size()


func is_empty() -> bool:
	return acquired.is_empty()


func held(kind: int) -> bool:
	return acquired.has(kind)


## The one door an upgrade enters through. Idempotent by construction: an
## upgrade already held is REFUSED and counted rather than appended twice, which
## is what makes "no duplicate upgrade is acquired" a property of the data
## rather than a promise about every call site.
func acquire(kind: int) -> bool:
	if kind == RogueliteUpgrade.Kind.NONE:
		return _refuse("NONE is not an upgrade")
	if not RogueliteUpgrade.POOL.has(kind):
		return _refuse("%d is not in the upgrade pool" % kind)
	if acquired.has(kind):
		return _refuse("%s is already held" % RogueliteUpgrade.name_of(kind))
	acquired.append(kind)
	return true


## The upgrades still available to be OFFERED: the pool, in its stable authored
## order, minus everything already held. The offer selection reads exactly this,
## which is why "do not offer an upgrade the player already owns" cannot be
## forgotten at a call site — there is no other list to choose from.
func available() -> Array[int]:
	var open: Array[int] = []
	for kind: int in RogueliteUpgrade.POOL:
		if not acquired.has(kind):
			open.append(kind)
	return open


func names() -> PackedStringArray:
	var found: PackedStringArray = PackedStringArray()
	for kind: int in acquired:
		found.append(RogueliteUpgrade.name_of(kind))
	return found


## The build, in one line, for the HUD and the run summary. Both read this, so
## the two surfaces cannot describe the same build differently.
func build_line() -> String:
	if acquired.is_empty():
		return "none yet"
	return " + ".join(names())


## Records the live combat values at the end of a run. Every number is passed in
## from the runtime, which reads them off the kernel the game is actually
## obeying — never recomputed here from the upgrade list, because a summary that
## derived its own numbers could agree with the upgrades and still disagree with
## the game.
func capture(values: Dictionary) -> void:
	final_values = values.duplicate(true)


func has_capture() -> bool:
	return not final_values.is_empty()


func _refuse(reason: String) -> bool:
	refusals += 1
	last_refusal = reason
	return false


func describe() -> String:
	return "%d upgrade(s): %s, %d refusal(s)" % [count(), build_line(), refusals]
