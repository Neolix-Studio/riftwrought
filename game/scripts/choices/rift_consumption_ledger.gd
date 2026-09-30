class_name RiftConsumptionLedger
extends RefCounted
## Riftwrought — Roguelite Foundation D3: the temporary record of which Rift
## offers this run has already spent, as a pure in-memory VALUE.
##
## IT HOLDS ONE THING: A SET OF COMPLETE ROOT SEEDS. An offer's root seed is its
## consumption identity for the life of one run. Nothing else is stored — not
## which lane was taken, not what it granted, not when, not how many were
## refused — because none of that is needed to answer the one question this
## value exists to answer, and every extra field is another thing a later reader
## could believe.
##
## THE SEED IS RECORDED WHOLE AND IS NEVER MASKED, WHICH IS THE POINT OF THE
## FILE. The composition mechanism derives its three streams from the low 32 bits
## of the root seed, so two different full seeds can pose the same composition
## question and produce the same three answers. They are still two different
## offers: one was made, the other was not. Masking here would silently make the
## second unspendable, and a player who never saw it would never know why. So the
## key is the complete signed integer exactly as it arrived, and two seeds that
## agree in their low 32 bits are two independent entries.
##
## THE CONVERSE IS ALSO DELIBERATE AND IS THE EASIER HALF TO GET WRONG: two
## different root seeds that happen to compose the SAME Skill, support and cards
## are still two offers, and both may be consumed. Deduplicating on what an offer
## turned out to contain would refuse the second one for a reason that has
## nothing to do with whether it was made — and it would make the rule depend on
## the catalogues, so widening a pool would change which offers are spendable.
##
## AND REUSING ONE ROOT SEED WITH DIFFERENT POOLS IS STILL REUSE. The identity is
## the seed, not the seed together with whatever it was composed against; a
## caller that changed the records and asked again is asking a second question
## with a spent identity, and it is refused.
##
## IT IS TEMPORARY, IN-MEMORY AND RUN-SCOPED. There is no `clear()`, no
## `reset()`, no death rule, no abandon rule, no file, no schema and no
## persistence: a new run is a new ledger, exactly as a new run is a new build.
## Saying so is cheaper than inventing a lifecycle nobody has authorized, and the
## verification pins this script's method list by name so one cannot arrive
## quietly with a plausible name.
##
## NOTHING LIVE EVER LEAVES. The one reading of the set is a `PackedInt64Array`,
## which GDScript copies on assignment, so a caller cannot reach the stored set
## through the value it was handed to read.
##
## IT IS A VALUE, NOT A STORE. No node, no signal, no clock, no random source, no
## file.

## The consumed root seeds, as a set. `root_seed -> true`; the value carries no
## information and exists only because a Dictionary is the set this engine has.
var _consumed: Dictionary = {}


## Records `root_seed` as consumed. Returns true when it was recorded, and false
## when this ledger already held it — which is the whole protection, and the
## reason the answer is a value a caller must read rather than a silent no-op.
##
## A REFUSED CONSUMPTION MUTATES NOTHING. The membership test happens before the
## insertion and there is no other statement in the function, so there is no
## arrangement in which a refusal leaves a partial entry behind.
func consume(root_seed: int) -> bool:
	if _consumed.has(root_seed):
		return false
	_consumed[root_seed] = true
	return true


## Whether `root_seed` has already been consumed by this ledger.
func has_consumed(root_seed: int) -> bool:
	return _consumed.has(root_seed)


## How many distinct root seeds this ledger has recorded.
func count() -> int:
	return _consumed.size()


func is_empty() -> bool:
	return _consumed.is_empty()


## The consumed root seeds in ascending order, as a copy.
##
## SORTED RATHER THAN IN INSERTION ORDER, because this is a diagnostic and a
## diagnostic that changes when nothing changed is one a reader stops trusting.
## `PackedInt64Array` rather than an untyped array on purpose: GDScript copies a
## packed array on assignment, so the returned value cannot be a reference into
## the set above however a caller stores it.
func consumed_seeds() -> PackedInt64Array:
	var out: PackedInt64Array = PackedInt64Array()
	for root_seed: Variant in _consumed:
		out.append(int(root_seed))
	out.sort()
	return out


## An independent copy. Consuming a seed in the copy cannot consume it here, and
## consuming one here cannot consume it in the copy — which is what lets a
## transaction stage a consumption and abandon it without leaving a trace.
func duplicated() -> RiftConsumptionLedger:
	var copy: RiftConsumptionLedger = RiftConsumptionLedger.new()
	copy._consumed = _consumed.duplicate()
	return copy


# --- Presentation ---------------------------------------------------------------
#
# Reached by nothing above. No formatted string is compared, parsed or fed back
# into an identity.

func describe() -> String:
	if _consumed.is_empty():
		return "no offer consumed"
	var parts: PackedStringArray = PackedStringArray()
	for root_seed: int in consumed_seeds():
		parts.append(str(root_seed))
	return "%d consumed: %s" % [_consumed.size(), ", ".join(parts)]
