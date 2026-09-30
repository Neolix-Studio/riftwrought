class_name PlayerStatTotals
extends RefCounted
## Riftwrought — Roguelite Foundation C1: the pure accumulator that collects
## increased-percentage modifiers and adds them up before anything is applied
## (decision D-229).
##
## ADDING BEFORE APPLYING IS THE WHOLE POINT, AND IT IS STRUCTURAL RATHER THAN
## REMEMBERED. `design/ATTRIBUTES_AND_DAMAGE_MODEL.md` section 17 requires that
## increased modifiers "combine additively", producing one multiplier. The
## tempting implementation applies each modifier to the running value as it
## arrives, which is one line shorter and silently multiplicative: two +10%
## modifiers become 1.21 instead of 1.20, and by ten modifiers the two answers
## are a different game. So this record holds the MODIFIERS and never a value,
## the sum happens in one place, and there is no method here that could apply
## one modifier on its own even if a caller wanted to.
##
## THE SUM IS ORDER-INDEPENDENT TO THE LAST BIT, AND THAT NEEDED A DECISION.
## Floating-point addition is not associative, so summing the same modifiers in
## two different orders can produce two totals that differ in their final bit —
## enough to make one build's number reproduce and another's not, for no reason
## a player or a reviewer could ever see. `total_for()` therefore sorts a copy
## of the contributions into ascending numerical order before summing, so any
## permutation of the same multiset produces one identical float. Insertion
## order is still kept, because it is what a diagnostic wants; it simply decides
## nothing.
##
## A DUPLICATE IS AN ADDITION, NOT A COLLISION. Two modifiers of +10% for one
## stat are +20%, exactly as two cards granting the same thing would be. There is
## no set, no deduplication and no "already held" rule here — a stat's
## contributions are a list, and the same number may appear in it as often as it
## was granted.
##
## IT FAILS CLOSED AND NEVER PARTIALLY. A refused modifier is NOT recorded: the
## record is unchanged and the reason is returned in plain language. That is the
## opposite of the tempting behaviour, which is to record it and let the
## calculation refuse later — by which point the record is already wrong and the
## reason no longer names the modifier that caused it.
##
## IT IS A VALUE, NOT A STORE. Nothing here writes to disk, reads a save,
## carries a schema version, knows what a run is, or holds a base value for any
## stat. Where a base value comes from, when totals are cleared, and whether they
## survive anything are all later decisions.

## stat_id -> the contributions granted for it, in the order they were granted.
var _by_stat: Dictionary = {}


## Records one increased-percentage modifier, normalized: 0.10 is 10% increased.
## Returns "" when it was accepted, or the single plain-language reason it was
## refused. A refused modifier changes nothing.
##
## Zero is accepted deliberately: a modifier of +0% is a no-op rather than an
## error, and refusing it would make a legitimate authored value fail.
func add(stat_id: StringName, increased: float) -> String:
	if not PlayerStats.is_known(stat_id):
		return "%s is not a recognised player stat" % _named(stat_id)
	if not is_finite(increased):
		return "%s: a modifier must be a finite number" % stat_id
	var candidate: PackedFloat64Array = _contributions(stat_id).duplicate()
	candidate.append(increased)
	var candidate_total: float = _sum(candidate)
	if not is_finite(candidate_total):
		return "%s: adding %.6f would make the total unusable" % [stat_id, increased]
	if candidate_total <= PlayerStats.MINIMUM_TOTAL_INCREASED:
		return "%s: adding %.6f would take the total to %.6f, and a scale of %.6f is not positive" % [
			stat_id, increased, candidate_total, 1.0 + candidate_total,
		]
	_by_stat[stat_id] = candidate
	return ""


## Removes every contribution for one stat. Returns false when there was
## nothing to remove, so a caller can tell "cleared" from "was already empty".
func clear_stat(stat_id: StringName) -> bool:
	if not _by_stat.has(stat_id):
		return false
	_by_stat.erase(stat_id)
	return true


func clear() -> void:
	_by_stat = {}


## The contributions granted for one stat, as a copy in the order they were
## granted. A copy, because handing out the live array would let a caller change
## the record through a reference it was only given to read.
func contributions_for(stat_id: StringName) -> PackedFloat64Array:
	return _contributions(stat_id).duplicate()


func count_for(stat_id: StringName) -> int:
	return _contributions(stat_id).size()


## The sum of every contribution for one stat, normalized. Zero for a stat with
## no contributions and for one this vocabulary does not recognise — both mean
## "nothing has been granted", and neither can be created by this record's own
## `add()`, which refuses an unrecognised stat outright.
func total_for(stat_id: StringName) -> float:
	return _sum(_contributions(stat_id))


## The stats that carry at least one contribution, in the vocabulary's canonical
## order rather than in insertion order, so a diagnostic never depends on the
## order things were granted in.
func stats() -> Array[StringName]:
	var out: Array[StringName] = []
	for stat_id: StringName in PlayerStats.ALL:
		if _by_stat.has(stat_id):
			out.append(stat_id)
	return out


## The number of MODIFIERS held, across every stat — the only count that means
## anything here, since two stats each holding one modifier is two grants.
func size() -> int:
	var total: int = 0
	for stat_id: Variant in _by_stat:
		total += _contributions(stat_id as StringName).size()
	return total


func is_empty() -> bool:
	return size() == 0


## Applies this record's total for `stat_id` to `base_value`, through the one
## calculation path. There is deliberately no arithmetic in this file beyond the
## sum: applying a percentage happens in exactly one place in this foundation.
func value_of(stat_id: StringName, base_value: float) -> PlayerStatValue:
	return PlayerStats.apply(stat_id, base_value, total_for(stat_id))


## An independent copy. Changing the copy cannot change this record, which is
## what lets a caller ask "what would this modifier do?" without granting it.
func duplicated() -> PlayerStatTotals:
	var copy: PlayerStatTotals = PlayerStatTotals.new()
	for stat_id: Variant in _by_stat:
		copy._by_stat[stat_id] = _contributions(stat_id as StringName).duplicate()
	return copy


# --- Presentation -------------------------------------------------------------

func describe() -> String:
	if is_empty():
		return "no modifiers"
	var parts: PackedStringArray = PackedStringArray()
	for stat_id: StringName in stats():
		parts.append("%s %s" % [stat_id, PlayerStats.format_increased(total_for(stat_id))])
	return ", ".join(parts)


# --- Internals ----------------------------------------------------------------

func _contributions(stat_id: StringName) -> PackedFloat64Array:
	if not _by_stat.has(stat_id):
		return PackedFloat64Array()
	var held: PackedFloat64Array = _by_stat[stat_id]
	return held


## Sorted into ascending numerical order before summing, so two orderings of the
## same modifiers cannot produce two different floats. See the header.
static func _sum(values: PackedFloat64Array) -> float:
	var ordered: PackedFloat64Array = values.duplicate()
	ordered.sort()
	var total: float = 0.0
	for value: float in ordered:
		total += value
	return total


static func _named(stat_id: StringName) -> String:
	var text: String = String(stat_id)
	return text if not text.strip_edges().is_empty() else "<an unnamed stat>"
