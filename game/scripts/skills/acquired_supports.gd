class_name AcquiredSupports
extends RefCounted
## Riftwrought — Roguelite Foundation B: which supports are already held, per
## SKILL/SUPPORT PAIR (decision D-227), and at what RANK (Foundation F1).
##
## THE PAIR IS THE UNIT, AND THAT IS THE WHOLE POINT OF THIS FILE. A support
## attached to one equipped Skill says nothing about whether it may be attached
## to another: two Skills are two independent installations, and a record that
## tracked support ids alone would silently make the first acquisition remove
## that support from every Skill the character owns. Excluding a support from
## one Skill must not exclude it from another, and here that is a property of
## the storage shape rather than a rule the selector has to remember.
##
## IT IS A NESTED MAP RATHER THAN A JOINED STRING KEY, AND THE REASON IS A
## DEFECT THAT WOULD HAVE BEEN HARD TO SEE. The obvious implementation is a set
## of `"<skill>|<support>"` keys, which is correct only for as long as no
## identifier ever contains the separator; the day one does, two genuinely
## different pairs collapse into one and a support silently disappears from a
## Skill that never acquired it. A dictionary of dictionaries has no separator
## to collide on, so the failure cannot occur at all.
##
## A HELD PAIR NOW CARRIES A RANK, AND THE RANK IS SCOPED TO THE PAIR (F1). The
## inner map answers `support -> rank` rather than merely listing what is held,
## so the same support attached to two Skills has TWO INDEPENDENT RANKS for the
## same structural reason it is two independent acquisitions. A first
## acquisition begins at rank 1; there is no rank 0 entry, so an absent pair and
## a held one can never be confused, and `rank_for()` can answer "not held" with
## a number instead of demanding a second question.
##
## THE TWO COUNTS ARE DIFFERENT QUESTIONS AND ARE DELIBERATELY BOTH ANSWERED.
## `size()` is how many DISTINCT pairs are held and did not change meaning when
## ranks arrived; `total_ranks()` is the sum of those pairs' ranks. One pair
## raised once is ONE pair and TWO ranks, and a mechanism that reported the
## second where it meant the first would exhaust a pool that still had entries
## in it.
##
## RANKING IS NOT ACQUIRING, AND NEITHER IS ITS INVERSE. `acquire()` refuses a
## pair that is already held and LEAVES ITS RANK EXACTLY WHERE IT WAS — a
## re-acquisition that quietly reset a rank to 1 would be invisible to any test
## that only ever re-acquired a rank-1 pair. `increase_rank()` refuses a pair
## that is not held and creates nothing, not even the Skill's own entry.
## `release()` removes the PAIR and every rank it had accumulated; it is not a
## decrement, and reinterpreting it as one would silently turn a refund into a
## downgrade.
##
## THE CEILING IS REPRESENTATIONAL, NOT A BALANCE RULE. There is no gameplay
## maximum rank here, no diminishing return and no rarity: `increase_rank()`
## refuses only when no LARGER positive integer rank could be stored at all,
## and it refuses BEFORE adding rather than by noticing a wraparound afterwards
## — detecting an overflow that has already happened is not a guard. That
## boundary sits at the engine's own largest positive integer and therefore
## cannot be reached by calling this record; the verification proves the
## boundary itself as an engine property and pins the refusal structurally, and
## says out loud that no behavioural test of it exists.
##
## A RANK CARRIES NO EFFECT. This record says how many times a pair has been
## taken and nothing whatever about what that does. No modifier, no multiplier,
## no per-rank value and no application lives here.
##
## IT IS A VALUE, NOT A STORE. Nothing here writes to disk, reads a save,
## carries a schema version or knows what a run is. Persisting acquisitions is a
## separate, separately authorized concern.

## The rank a newly acquired pair begins at, and the number `rank_for()` answers
## for a pair that is not held. Named rather than written as bare literals so the
## two can never be read as the same kind of number.
const FIRST_RANK: int = 1
const ABSENT_RANK: int = 0

## THE LARGEST RANK THAT CAN BE STORED, WHICH IS A PROPERTY OF THE MACHINE AND
## NOT A DESIGN DECISION. It is the engine's own largest positive integer:
## adding one to it produces no larger positive integer at all, which the
## verification measures rather than assumes.
const MAXIMUM_RECORDABLE_RANK: int = 0x7FFF_FFFF_FFFF_FFFF

## skill_id -> Dictionary of support_id -> rank. Every stored rank is at least
## `FIRST_RANK`, and a pair that is not held has no entry rather than an entry of
## zero, so the two states cannot be confused by anything that reads this map.
var _by_skill: Dictionary = {}


## Records the pair at rank 1. Returns false when it was already held, so a
## caller can tell "recorded" from "already there" without asking twice.
##
## AN ALREADY-HELD PAIR IS LEFT COMPLETELY ALONE, RANK INCLUDED. The refusal
## comes first, so no rank is written over.
func acquire(skill_id: StringName, support_id: StringName) -> bool:
	if has(skill_id, support_id):
		return false
	var held: Dictionary = _ranks_for(skill_id)
	held[support_id] = FIRST_RANK
	_by_skill[skill_id] = held
	return true


## Raises one ALREADY HELD pair by exactly one rank. Returns false when the pair
## is not held — and creates nothing when it refuses, not even an empty entry for
## the Skill — or when no larger rank is representable.
func increase_rank(skill_id: StringName, support_id: StringName) -> bool:
	if not has(skill_id, support_id):
		return false
	var held: Dictionary = _ranks_for(skill_id)
	var current: int = int(held[support_id])
	if current >= MAXIMUM_RECORDABLE_RANK:
		return false
	held[support_id] = current + 1
	_by_skill[skill_id] = held
	return true


## Removes the pair AND every rank it accumulated. Returns false when it was not
## held. Present so a test — and a later refund — can undo exactly one pair
## without rebuilding the record.
##
## IT IS NOT A DECREMENT, AND THAT IS DELIBERATE. A pair is either held or it is
## not; stepping a rank back down is a different operation nobody has authorized,
## and giving this one that meaning would make a refund silently partial.
func release(skill_id: StringName, support_id: StringName) -> bool:
	if not has(skill_id, support_id):
		return false
	var held: Dictionary = _ranks_for(skill_id)
	held.erase(support_id)
	if held.is_empty():
		_by_skill.erase(skill_id)
	else:
		_by_skill[skill_id] = held
	return true


func has(skill_id: StringName, support_id: StringName) -> bool:
	return _ranks_for(skill_id).has(support_id)


## The rank one pair holds: `ABSENT_RANK` for a pair that is not held, and
## `FIRST_RANK` or more for one that is.
func rank_for(skill_id: StringName, support_id: StringName) -> int:
	var held: Dictionary = _ranks_for(skill_id)
	if not held.has(support_id):
		return ABSENT_RANK
	return int(held[support_id])


## The supports held for one Skill, as a copy in a stable alphabetical order.
## A copy, because handing out the live collection would let a caller change the
## record by accident through a reference it was only given to read.
func for_skill(skill_id: StringName) -> Array[StringName]:
	var held: Dictionary = _ranks_for(skill_id)
	var ids: Array[StringName] = []
	for support_id: Variant in held:
		ids.append(support_id as StringName)
	return _sorted(ids)


func skill_count() -> int:
	return _by_skill.size()


## The total number of PAIRS held, which is the count that decides availability:
## two Skills each holding the same support is two acquisitions. A pair raised to
## rank 5 is still ONE pair here; the ranks are counted by `total_ranks()`.
func size() -> int:
	var total: int = 0
	for skill_id: Variant in _by_skill:
		var held: Dictionary = _by_skill[skill_id]
		total += held.size()
	return total


## The sum of every held pair's rank, which is a DIFFERENT number from `size()`
## the moment any pair has been raised.
func total_ranks() -> int:
	var total: int = 0
	for skill_id: Variant in _by_skill:
		var held: Dictionary = _by_skill[skill_id]
		for support_id: Variant in held:
			total += int(held[support_id])
	return total


func is_empty() -> bool:
	return size() == 0


## Every held pair as `skill -> support`, in a stable order: Skills
## alphabetically, and each Skill's supports alphabetically. Deterministic so a
## diagnostic never depends on the order things were acquired in.
##
## THE RANK IS DELIBERATELY ABSENT FROM THIS LINE. It is the accepted listing
## every earlier foundation compares against, and a rank appearing in it would
## change what those comparisons mean. `rank_for()` answers the rank.
func pairs() -> PackedStringArray:
	var out: PackedStringArray = PackedStringArray()
	var skills: Array[StringName] = []
	for skill_id: Variant in _by_skill:
		skills.append(skill_id as StringName)
	for skill_id: StringName in _sorted(skills):
		for support_id: StringName in for_skill(skill_id):
			out.append("%s -> %s" % [skill_id, support_id])
	return out


## An independent copy, EVERY RANK PRESERVED EXACTLY. Changing the copy cannot
## change this record, which is what lets a caller ask "what would happen if I
## took this one?" safely.
##
## EACH INNER MAP IS DUPLICATED, AND THAT IS LOAD-BEARING RATHER THAN TIDY. A
## Dictionary read out of a Dictionary IS that Dictionary — measured on a
## purpose-built probe in the verification rather than believed — so copying only
## the outer map would leave both records writing their ranks into one place,
## and the copy would silently be the original.
func duplicated() -> AcquiredSupports:
	var copy: AcquiredSupports = AcquiredSupports.new()
	for skill_id: Variant in _by_skill:
		var held: Dictionary = _by_skill[skill_id]
		copy._by_skill[skill_id] = held.duplicate()
	return copy


func describe() -> String:
	if is_empty():
		return "no supports acquired"
	return "; ".join(pairs())


# --- Internals ----------------------------------------------------------------

## The live rank map for one Skill, or a fresh empty one for a Skill with no
## entry. PRIVATE, and never handed out: the empty answer is deliberately NOT
## stored, so a mere reading can never create a Skill entry that holds nothing.
func _ranks_for(skill_id: StringName) -> Dictionary:
	if not _by_skill.has(skill_id):
		return {}
	var held: Dictionary = _by_skill[skill_id]
	return held


## Sorted through `PackedStringArray`, because StringName ordering is an
## implementation detail and a stable diagnostic must not rest on one.
static func _sorted(values: Array[StringName]) -> Array[StringName]:
	var text: PackedStringArray = PackedStringArray()
	for value: StringName in values:
		text.append(String(value))
	text.sort()
	var out: Array[StringName] = []
	for value: String in text:
		out.append(StringName(value))
	return out
