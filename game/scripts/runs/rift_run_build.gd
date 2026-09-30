class_name RiftRunBuild
extends RefCounted
## Riftwrought — Roguelite Foundation D2: the build ONE Rift run accumulates,
## as a pure in-memory VALUE (decision D-241, corrected under D-242).
##
## WHAT IT HOLDS, AND NOTHING ELSE. Three things: which Skill/support pairs this
## run has acquired, how many times each passive card has been acquired, and the
## stat modifiers those cards contributed. That is the whole record. It offers
## nothing, chooses nothing, applies nothing to any actor, spends nothing, saves
## nothing and knows nothing about experience, levels, lanes, death, the Nexus or
## a scene. Each of those is a later decision with its own authorization.
##
## SINCE FOUNDATION F1 AN ACQUIRED PAIR ALSO CARRIES A RANK, AND THE RANK IS
## STILL THE ACQUISITION RECORD'S TO OWN. This state gained one operation and
## two readings and no storage of its own: `rank_support()` delegates to the
## accepted record exactly as `acquire_support()` already did, so the pair rule,
## the scoping rule and the representational ceiling are all still written in one
## place. A rank RECORDS PROGRESSION AND APPLIES NOTHING — there is no per-rank
## value, no multiplier and no effect anywhere in this file or behind it.
##
## `support_count()` DID NOT CHANGE MEANING AND MUST NOT. It is the number of
## DISTINCT pairs, which is what decides whether a pair is still available;
## `total_support_ranks()` is the sum of those pairs' ranks, and the two are
## different numbers the moment anything is raised. Reporting either where the
## other was meant would exhaust a pool that still had entries in it.
##
## IT OWNS NO ARITHMETIC AND NO STORAGE SHAPE OF ITS OWN, WHICH IS THE POINT OF
## THE FILE. The pair rule lives in the accepted acquisition record; the
## add-before-applying rule lives in the accepted accumulator; the record
## contract lives in the accepted card definition. This state COMPOSES those
## three and adds two things none of them has: a count of how many times each
## card was taken, and the mechanical identity that count belongs to.
## Reimplementing any of the three here would create a second place for one rule
## to be written, and therefore a way for the two to disagree — which is exactly
## how two `+10%` modifiers quietly become `1.21` instead of `1.20` in a file
## that never meant to multiply anything.
##
## ONE CARD ID IS ONE MECHANICAL PASSIVE FOR THE LIFE OF A RUN, AND THAT HAD TO
## BE MADE TRUE RATHER THAN ASSUMED (D-242). A count keyed on a card id is only
## meaningful if the id means one thing, and nothing upstream guarantees that:
## two records can both be perfectly VALID, carry the same stable id, and
## disagree about the stat they move, the amount they move it by, or whether they
## may be taken twice. Counting them together would let one id accumulate
## unrelated effects — three acquisitions of "the same" card granting Life,
## Damage and Movement Speed — and, worse, would let a once-only card be taken
## again simply by presenting a second record that says it is repeatable, because
## the repeat rule would be read from whatever arrived last.
##
## SO THE FIRST SUCCESSFUL ACQUISITION BINDS THE ID TO A FINGERPRINT, and every
## later acquisition of that id must match it exactly before anything is counted:
## the stat, the exact normalized magnitude, and the repeat flag. THAT MISMATCH
## GATE IS THE LOAD-BEARING PART, and it is measured as such: removing it lets
## every conflicting record through and turns this file's suite red in a dozen
## places.
##
## THE REPEAT RULE AND THE MODIFIER ARE THEN BOTH READ FROM THE RECORDED
## FINGERPRINT RATHER THAN FROM THE RECORD THAT JUST ARRIVED — and the honest
## account of that is that it is DEFENCE IN DEPTH, not a second lock on a
## reachable hole. Past the mismatch gate the two are provably identical, so no
## behavioural test can tell them apart, and swapping either one back to the
## supplied record changes no observable answer today. They stay because the
## recorded fingerprint is the correct source of truth for a rule about what this
## run already holds, and because that reading survives a later reordering of
## these gates while reading the newcomer would silently stop being equivalent.
## The verification pins it structurally instead of behaviourally, and says so.
##
## THE FINGERPRINT IS MECHANICAL ONLY, AND THE OMISSIONS ARE DELIBERATE. The
## presentation name is not in it, so copy may be rewritten mid-run without
## invalidating anything a player already holds. The offer weight is not in it
## either: how often something is REACHED FOR cannot change what it DID once it
## has been taken, and folding a selection-time number into an acquired card's
## identity would make a reweighting a migration.
##
## THE ONLY NUMBER THIS FILE COMPUTES IS AN INTEGER COUNT. A magnitude is read
## once, carried in the fingerprint, handed to the accumulator, and never
## operated on: this source contains no multiplication, no division and no
## floating-point literal at all, and the verification asserts each of those from
## the source rather than trusting this paragraph.
##
## EVERY MUTATION IS ALL OR NOTHING, AND THE LOAD-BEARING HALF IS THE ORDER
## RATHER THAN THE STAGING. Both accepted records this state delegates to are
## already fail-closed: a repeated pair is refused by the acquisition record
## without it mutating, and a refused modifier is refused by the accumulator
## without it mutating. So the `duplicated()` staging below is defence in depth
## — MEASURED as such, not assumed: replacing the staged accumulator with the
## live one changes no observable behaviour today.
##
## WHAT IS ACTUALLY LOAD-BEARING IS THE HOLD — the count and the fingerprint,
## which are the state this file owns and no accepted record protects. They are
## committed TOGETHER, in one assignment, only after the delegated mutation has
## returned success. Moving that line above the delegation is a real, reachable
## defect: a magnitude that is finite on its own but whose SUM with what is
## already held is not is accepted by the card record and refused by the
## accumulator, and a hold committed first would survive that refusal as an
## acquisition with no modifier behind it. The verification drives exactly that
## input, and it was confirmed to go red when the two lines are swapped — because
## a guard nothing can reach is not a guard.
##
## THE COUNT AND THE FINGERPRINT SHARE ONE ENTRY FOR THE SAME REASON. Two maps
## would be two places for one fact, and a refusal that updated one and not the
## other would be invisible to any check that read only the other.
##
## NOTHING LIVE EVER LEAVES. Every inspection answers with a scalar or with an
## independent copy. A caller that receives the acquisition record or the
## accumulator receives a duplicate, so a caller cannot change this run's build
## through a reference it was only given to read — and, just as importantly, a
## later choice resolver can be handed the acquisition record to ask "what is
## still available?" without that question being able to answer itself. The
## fingerprint store is never handed out at all: the one public reading of it is
## a formatted scalar, which cannot be mutated back into anything.
##
## IT DOES NOT VALIDATE ELIGIBILITY, AND THE ABSENCE IS DELIBERATE. Whether a
## support may attach to a Skill, and whether a pair came from a coherent
## proposal, are questions the accepted eligibility rule and a later choice
## resolver answer. This state records an AUTHORIZED pair. Re-deriving
## eligibility here would be a second copy of a rule that already exists, and it
## would make this record disagree with that rule the day one of them changed.
##
## CREATING A NEW STATE IS THE RESET MODEL. There is no `clear()`, no `reset()`,
## no death rule, no abandon rule and no persistence: a new run is a new value,
## and a new value is a new set of fingerprints. Saying so is cheaper than
## inventing a lifecycle nobody has authorized, and the verification pins the
## method list by name so one cannot arrive quietly.
##
## IT IS A VALUE, NOT A STORE. No node, no signal, no clock, no random source, no
## file, no schema version.

## The three mechanical facts a card id is bound to on its first successful
## acquisition. Written as the record's own field names so a refusal names the
## field a reader can go and look at.
const FIELD_STAT: String = "stat_id"
const FIELD_MAGNITUDE: String = "magnitude"
const FIELD_REPEATABLE: String = "repeatable"

## Compared in this order, one at a time, so a refusal names WHICH fact was
## contradicted rather than merely that one was.
const MECHANICAL_FIELDS: Array[String] = [FIELD_STAT, FIELD_MAGNITUDE, FIELD_REPEATABLE]

## The two halves of one hold, committed together and never apart.
const HOLD_FINGERPRINT: int = 0
const HOLD_COUNT: int = 1

## How many decimal places the public identity line renders the magnitude to.
## Enough to separate any two distinct doubles this foundation can carry, so the
## line a diagnostic compares is as exact as the comparison the code makes.
const IDENTITY_DECIMALS: int = 17

## The pairs this run has acquired. Private, and never handed out live: callers
## receive `acquired_supports()`, which is a duplicate.
var _supports: AcquiredSupports = AcquiredSupports.new()

## The modifiers the acquired cards contributed. Private for the same reason,
## and for one more: the accumulator is the ONLY place a total is computed, and
## a caller holding the live object could add a modifier no card ever granted.
var _totals: PlayerStatTotals = PlayerStatTotals.new()

## card_id -> [fingerprint, count]. The two facts none of the three accepted
## records carries, held in one entry so they cannot drift apart.
var _card_holds: Dictionary = {}


# --- Acquisition ---------------------------------------------------------------

## Records one authorized Skill/support pair. Returns "" when it was accepted,
## or the single plain-language reason it was refused. A refused acquisition
## changes nothing anywhere in this state.
##
## THE PAIR IS STORED BY THE ACCEPTED RECORD, NOT HERE. The "same pair twice"
## rule and the "same support for two Skills" rule are both that record's, and
## delegating to it is what keeps this state from being a second, subtly
## different answer to the same question.
func acquire_support(skill_id: StringName, support_id: StringName) -> String:
	if String(skill_id).strip_edges().is_empty():
		return "a support acquisition must name the Skill it is attached to"
	if String(support_id).strip_edges().is_empty():
		return "%s: a support acquisition must name the support it records" % skill_id
	var staged: AcquiredSupports = _supports.duplicated()
	if not staged.acquire(skill_id, support_id):
		return "%s: %s is already acquired for that Skill" % [skill_id, support_id]
	_supports = staged
	return ""


## Raises one ALREADY ACQUIRED Skill/support pair by exactly one rank. Returns
## "" when it was accepted, or the single plain-language reason it was refused. A
## refused increase changes nothing anywhere in this state.
##
## IT IS A SEPARATE OPERATION FROM ACQUIRING, ON PURPOSE. Folding the two into
## one call would make "take this pair" and "raise this pair" the same request,
## and a caller could then no longer say which of the two it meant — which is
## exactly the distinction the long-term policy rests on.
##
## THE RANK RULE IS THE ACCEPTED RECORD'S, NOT THIS FILE'S. The not-held refusal
## is asked here only so the reason can name WHICH of the two refusals happened;
## the record refuses the same case on its own, and would still refuse it if this
## line were deleted.
##
## THE STAGING IS DEFENCE IN DEPTH, AND THAT IS MEASURED RATHER THAN CLAIMED.
## The accepted record is already fail-closed — it refuses before writing in both
## of its branches — so replacing the staged copy with the live record changes no
## observable behaviour today. It stays because it is the shape that keeps being
## correct if a second committed fact is ever added beside this one, which is the
## same reading D-241 recorded for the staging beside it.
func rank_support(skill_id: StringName, support_id: StringName) -> String:
	if String(skill_id).strip_edges().is_empty():
		return "a support rank increase must name the Skill it is attached to"
	if String(support_id).strip_edges().is_empty():
		return "%s: a support rank increase must name the support it raises" % skill_id
	if not _supports.has(skill_id, support_id):
		return "%s: %s has not been acquired for that Skill" % [skill_id, support_id]
	var staged: AcquiredSupports = _supports.duplicated()
	if not staged.increase_rank(skill_id, support_id):
		return "%s: %s already holds the highest recordable rank" % [skill_id, support_id]
	_supports = staged
	return ""


## Records one acquisition of `card`. Returns "" when it was accepted, or the
## single plain-language reason it was refused. A refused acquisition leaves
## every support pair, every card count, every recorded fingerprint and every
## stat total unchanged.
##
## THE ORDER OF THE FOUR GATES IS THE CONTRACT. The record validates itself
## first, because a malformed record has no fingerprint worth comparing. Then the
## mechanical identity, because an id that means two things makes every later
## question meaningless. Then the repeat rule, read from what this run REMEMBERS
## rather than from what just arrived. Only then is the modifier staged, and only
## if that succeeds is the hold committed.
func acquire_passive_card(card: PassiveCardDefinition) -> String:
	if card == null:
		return "a passive acquisition must carry a card record"
	var record_problem: String = card.problem()
	if not record_problem.is_empty():
		return record_problem
	var card_id: StringName = card.card_id
	var candidate: Dictionary = _fingerprint_of(card)
	var already: int = acquisitions_for(card_id)
	var identity: Dictionary = candidate
	if already > 0:
		identity = _fingerprint_for(card_id)
		var conflict: String = _mechanical_conflict(card_id, identity, candidate)
		if not conflict.is_empty():
			return conflict
		if not bool(identity[FIELD_REPEATABLE]):
			return "%s is not repeatable and has already been acquired" % card_id
	var staged: PlayerStatTotals = _totals.duplicated()
	var refusal: String = staged.add(
		identity[FIELD_STAT] as StringName, float(identity[FIELD_MAGNITUDE])
	)
	if not refusal.is_empty():
		return "%s: %s" % [card_id, refusal]
	_totals = staged
	_card_holds[card_id] = [identity.duplicate(), already + 1]
	return ""


# --- Reading the supports -------------------------------------------------------

func has_support(skill_id: StringName, support_id: StringName) -> bool:
	return _supports.has(skill_id, support_id)


## The supports acquired for one Skill, as a copy in a stable order.
func supports_for(skill_id: StringName) -> Array[StringName]:
	return _supports.for_skill(skill_id)


## Every acquired pair as `skill -> support`, in a stable order that does not
## depend on the order they were acquired in.
func support_pairs() -> PackedStringArray:
	return _supports.pairs()


## The number of PAIRS acquired: two Skills each holding the same support is two.
func support_count() -> int:
	return _supports.size()


## The rank one acquired pair currently holds: zero for a pair this run has not
## acquired, and one or more for a pair it has.
func support_rank_for(skill_id: StringName, support_id: StringName) -> int:
	return _supports.rank_for(skill_id, support_id)


## The sum of every acquired pair's rank. DISTINCT from `support_count()` on
## purpose: one pair raised once is one pair and two ranks, and a reading that
## answered the sum where the count was meant would report a pool as more
## exhausted than it is.
func total_support_ranks() -> int:
	return _supports.total_ranks()


## An INDEPENDENT COPY of the acquisition record, which is what a later selector
## or resolver is handed when it needs to ask what is still available. Changing
## the copy cannot change this run's build.
func acquired_supports() -> AcquiredSupports:
	return _supports.duplicated()


# --- Reading the passives -------------------------------------------------------

## How many times one card has been acquired. Zero for a card this run has never
## taken, which is the same answer for a card that does not exist — both mean
## "nothing has been acquired", and neither can be created by `acquire_passive_card()`.
func acquisitions_for(card_id: StringName) -> int:
	if not _card_holds.has(card_id):
		return 0
	var hold: Array = _card_holds[card_id]
	return int(hold[HOLD_COUNT])


## The mechanical identity one card id is bound to for the life of this run, as
## one line: the stat, the exact magnitude, and whether it may be taken again.
## Empty for a card this run has not acquired.
##
## A FORMATTED SCALAR RATHER THAN THE FINGERPRINT ITSELF, ON PURPOSE. The store
## behind it is the one piece of this state that must never be reachable: a
## caller holding it could rewrite what an id means and every later acquisition
## would agree with the rewrite. A string cannot be mutated back into anything.
func mechanical_identity_for(card_id: StringName) -> String:
	var recorded: Dictionary = _fingerprint_for(card_id)
	if recorded.is_empty():
		return ""
	return "%s %s %s" % [
		recorded[FIELD_STAT],
		String.num(float(recorded[FIELD_MAGNITUDE]), IDENTITY_DECIMALS),
		"repeatable" if bool(recorded[FIELD_REPEATABLE]) else "once only",
	]


## The cards this run has acquired at least once, in a stable sorted order.
## Sorted through `PackedStringArray`, because StringName ordering is an
## implementation detail and a stable diagnostic must not rest on one.
func acquired_card_ids() -> Array[StringName]:
	var text: PackedStringArray = PackedStringArray()
	for card_id: Variant in _card_holds:
		text.append(String(card_id))
	text.sort()
	var out: Array[StringName] = []
	for value: String in text:
		out.append(StringName(value))
	return out


## The total number of card ACQUISITIONS, which is the only count that means
## anything here: one card taken twice is two acquisitions.
func passive_acquisitions() -> int:
	var total: int = 0
	for card_id: Variant in _card_holds:
		total += acquisitions_for(card_id as StringName)
	return total


# --- Reading the stat totals ------------------------------------------------------

## The accumulated modifier total for one stat, normalized. COMPUTED BY THE
## ACCUMULATOR, never here: this function forwards the question and returns the
## answer, which is what makes "two `+10%` cards are `+20%`" a property of the
## accepted arithmetic rather than of this file.
func total_for(stat_id: StringName) -> float:
	return _totals.total_for(stat_id)


## How many separate contributions one stat has received. Distinct from the
## total on purpose: two cards granting the same amount are one total and two
## contributions, and a repeat that quietly replaced a contribution instead of
## adding one would move this and not that.
func contribution_count_for(stat_id: StringName) -> int:
	return _totals.count_for(stat_id)


## An INDEPENDENT COPY of the accumulator. Changing the copy cannot change this
## run's build, which is what lets a caller ask "what would this be worth?"
## without granting anything.
func stat_totals() -> PlayerStatTotals:
	return _totals.duplicated()


# --- The whole value ---------------------------------------------------------------

func is_empty() -> bool:
	return _supports.is_empty() and _card_holds.is_empty() and _totals.is_empty()


## An independent copy of the WHOLE state, fingerprints included.
##
## THE HOLD MAP IS DUPLICATED DEEPLY, AND THAT IS DEFENCE IN DEPTH RATHER THAN A
## FIX FOR SOMETHING REACHABLE — measured, not assumed. A commit REPLACES a
## hold rather than writing through one, so nothing here mutates a fingerprint in
## place and a shallow copy is behaviourally identical today. It is deep because
## the day one line does write through `_fingerprint_for()`, a shallow copy would
## have both states quietly agreeing about what a card id means for the rest of
## the run, and that is not a failure anyone would see.
func duplicated() -> RiftRunBuild:
	var copy: RiftRunBuild = RiftRunBuild.new()
	copy._supports = _supports.duplicated()
	copy._totals = _totals.duplicated()
	copy._card_holds = _card_holds.duplicate(true)
	return copy


# --- Presentation ---------------------------------------------------------------
#
# Deliberately separate from the record above, and reached by nothing in it. No
# formatted string is compared, parsed or fed back into a number, and the stat
# half is rendered by the accumulator's own formatter rather than by a second
# one written here.

func describe() -> String:
	return "%s; %s; %s" % [_supports.describe(), _passive_line(), _totals.describe()]


func _passive_line() -> String:
	var ids: Array[StringName] = acquired_card_ids()
	if ids.is_empty():
		return "no passive cards acquired"
	var parts: PackedStringArray = PackedStringArray()
	for card_id: StringName in ids:
		parts.append("%s x%d" % [card_id, acquisitions_for(card_id)])
	return ", ".join(parts)


# --- The mechanical identity ------------------------------------------------------

## The three mechanical facts of one record, and nothing else. The presentation
## name and the offer weight are absent by design; see the header.
func _fingerprint_of(card: PassiveCardDefinition) -> Dictionary:
	return {
		FIELD_STAT: card.stat_id,
		FIELD_MAGNITUDE: card.magnitude,
		FIELD_REPEATABLE: card.repeatable,
	}


## What this run remembers one card id means, or an empty dictionary for an id it
## has never acquired. Private, and the returned reference is never retained by
## anything: a commit REPLACES the hold with a fresh copy rather than writing
## through this.
func _fingerprint_for(card_id: StringName) -> Dictionary:
	if not _card_holds.has(card_id):
		return {}
	var hold: Array = _card_holds[card_id]
	return hold[HOLD_FINGERPRINT]


## "" when `candidate` is mechanically the same passive as `recorded`, or the
## single reason it is not — naming the card id and the first field that differs,
## because "these disagree" is not something a reader can act on.
func _mechanical_conflict(
	card_id: StringName, recorded: Dictionary, candidate: Dictionary
) -> String:
	for field: String in MECHANICAL_FIELDS:
		if recorded[field] == candidate[field]:
			continue
		return ("%s: was first acquired with %s %s and now carries %s — "
			+ "one card id is one mechanical passive for the life of a run") % [
				card_id, field, recorded[field], candidate[field],
			]
	return ""
