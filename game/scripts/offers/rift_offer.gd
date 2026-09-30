class_name RiftOffer
extends RefCounted
## Riftwrought — Roguelite Foundation D1: one composed Rift offer, and
## everything needed to inspect how it was composed (decision D-239).
##
## THE SHAPE IS FIXED AT 1 + 1 + 1 AND IS NOT NEGOTIABLE. A successful offer
## carries exactly three lanes in exactly this order — `SUPPORT`,
## `COMBAT_DEFENCE`, `UTILITY` — and a refusal carries none of them. There is no
## variable lane count, no substitution of a missing support by a second
## passive, and no partially filled offer anywhere in this file: the failure
## constructor is the only way to build a refusal and it sets nothing but the
## question and the lane that answered it.
##
## TWO SENTENCES ABOVE WERE NARROWED BY FOUNDATION I7 (decision D-306), AND THE
## CORRECTION IS RECORDED HERE RATHER THAN LEFT TO MISLEAD. A missing support is
## still never replaced by anything; an EXHAUSTED Support lane — every compatible
## pair already held at its maximum rank — now carries the one passive card the
## accepted exhausted-support fallback chooses, which is a third card and never a
## copy of either passive lane's. And one second refusal constructor exists,
## `refused_as_fallback_unavailable()`, which is the first one plus a single
## classification. The count is still 1 + 1 + 1, and a refusal still carries no
## lane.
##
## LANE IDENTITY IS MECHANICAL. Each lane is a `Lane` enum member, carried
## explicitly in `lanes` and answered by `identity_for()`, `seed_for()` and
## `derivation_for_lane()` through a match on that member. It is never inferred
## from an array position and never from display text. The stable order IS
## asserted — `lanes` must equal `LANE_ORDER` exactly — but the order is a
## SECOND statement of the contract rather than the only one, which is the point:
## a reader that finds a lane by index and a reader that asks for it by name must
## be looking at the same thing, and here they cannot fail to.
##
## IT HOLDS THE NESTED DERIVATIONS THEMSELVES, NOT A COPY OF THEM. The two
## accepted selectors already return results that carry their whole derivation —
## the tickets, the ladders, the totals, the weights and the bonuses that
## matched — and each of those results re-checks itself through its own
## `problem()`. Restating any of it here would create a second place for one fact
## to be written and therefore a way for the two to disagree. So the objects the
## selectors returned are kept as they were returned, and `problem()` re-asks
## each of them whether it is coherent rather than believing that it is.
##
## THE FOUR IDENTITY FIELDS ARE THE ONE DELIBERATE CONVENIENCE, AND THEY ARE
## PROVED AGAINST THE DERIVATIONS RATHER THAN TRUSTED. `skill_id`, `support_id`,
## `combat_card_id` and `utility_card_id` are what a caller actually wants, and
## digging two objects deep for each of them is how a caller starts copying them
## somewhere else. They are required to equal the nested results' own answers,
## checked in `problem()`, so the convenience cannot drift from the derivation.
##
## THE SUPPORT LANE CARRIES A FROZEN PROGRESSION, NOT ONLY A PAIR (Foundation
## F3, decision D-255). The lane may now represent either the acquisition of a
## compatible pair that is not held yet or ONE further rank of a pair that is,
## and which of the two it is was decided when the offer was composed. So an
## offer records the accepted continuation decision itself, the MECHANICAL kind
## that decision declared, and the exact rank the pair held before the choice
## beside the exact rank it would hold after it.
##
## THE FROZEN TRANSITION'S LEGALITY RULE LIVES IN ONE FUNCTION AND IS SHARED
## (Foundation F4, decision D-257). `support_transition_problem()` is the single
## definition of what `0 -> 1` and `N -> N + 1` mean; `problem()` below calls it
## and returns its answer verbatim, and the accepted choice transaction's result
## calls the same function when it re-checks a progression it has consumed. It
## was extracted from inside `problem()` and it changed no reachable answer.
##
## WHY THE RANKS ARE FROZEN RATHER THAN LOOKED UP LATER, AND THIS IS THE WHOLE
## REASON THEY ARE HERE. An offer is composed against one run state and may be
## answered against another. A later choice resolver must be able to reject an
## offer that no longer describes the run it was composed against — an old
## new-pair offer for a pair that has since been acquired, or an old `1 -> 2`
## offer when the build now holds rank 2 — and it can only do that by comparing
## what the offer FROZE against what the run currently holds. Without the
## before-rank, a stale rank offer would silently raise whatever rank happens to
## be current, which is a reward that quietly grants something nobody offered.
## Freezing it is mechanical offer PROVENANCE; it is not presentation
## convenience, and it is not a promise that the offer is still takeable.
##
## THE FROZEN RANKS ARE MEASURED RATHER THAN CALCULATED, and the measuring is
## done by the composer against a private duplicate of the supplied acquisition
## record — so the numbers here are what the accepted ranked-ownership state
## itself answered, never a second implementation of its rules. This record
## re-checks the SHAPE of that transition (a new pair steps from absent to first,
## a rank increase steps by exactly one from a rank that was held) against the
## accepted record's own two named ranks, which is a check rather than a
## restatement.
##
## THE PROGRESSION KIND AND THE RANKS ARE DELIBERATELY NOT PART OF A LANE'S
## IDENTITY. `identity_for()` still answers exactly the Skill id and the support
## id for the support lane, because an identity is WHAT was offered and the
## progression is WHICH OPERATION was offered on it. Appending either to that
## array would change what every consumer of a lane identity is looking at.
##
## THE SUPPORT LANE CARRIES ONE OF TWO KINDS OF CONTENT, AND WHICH ONE IS STORED
## (Roguelite Foundation I7, decision D-306). A successful offer records, in
## `support_content_kind`, exactly one of:
##
##   - `SUPPORT_PROGRESSION` — the Skill, the support, the continuation decision,
##     its kind and its two frozen ranks, every one of them exactly as before;
##   - `PASSIVE_FALLBACK` — the exhausted continuation it falls back from and the
##     complete accepted I6 fallback result, whose one card is the lane's whole
##     identity.
##
## The kind is never inferred from an identity's length, from which fields happen
## to be empty, from text, or from whether a card exists. It is written by the
## constructor that built the offer, and `problem()` proves each kind in BOTH
## directions: everything it must carry, and everything the other kind carries
## that it must not.
##
## A FALLBACK LANE BORROWS NO SUPPORT FIELD. Its card lives in
## `support_fallback_card_id` — the fifth identity convenience, proved against the
## fallback result exactly as the other four are proved against theirs — and never
## in `skill_id` or `support_id`. It declares no progression kind, freezes no rank
## and carries no weighted support derivation, because it offers no support
## operation at all. What it DOES keep is the exhausted continuation, which is the
## one fact that allowed a fallback to exist, and `problem()` re-asks it.
##
## IT IS COMPOSED HONESTLY AND IS NOT CONSUMABLE YET. Nothing in this file takes a
## lane. The accepted choice transaction reads a Support identity as a Skill and a
## support and refuses one of any other size before a seed is spent, so a fallback
## lane is refused there; taking one is a later, separate authorization.
##
## IT NAMES NO SKILL, NO SUPPORT, NO CARD, NO CLASS AND NO PRESENTATION NAME OF
## ANY RECORD, and the suite scans the raw source to prove it. The only words in
## this file are the LANE's own — `Support` is Foundation D1's own vocabulary,
## and the two passive lanes' labels are READ from the canonical stat vocabulary
## through the accepted passive result's own formatter rather than restated here,
## so a lane and the category it draws from can never display two different names
## for one thing.
##
## IT IS INERT. No node, no signal, no clock, no random source, no file. It
## describes a composition that has already happened and makes none of its own.

## The three lanes, in the order they are composed and reported in. The values
## are positional and stable: an offer's `lanes` array is compared against
## `LANE_ORDER` member for member, and a future fourth lane would be a different
## decision with its own authorization.
enum Lane {
	## One compatible `equipped Skill -> support` pair.
	SUPPORT,
	## One passive card drawn from the Combat and Defence category.
	COMBAT_DEFENCE,
	## One passive card drawn from the Utility category.
	UTILITY,
}

## What `refusing_lane` reads as on a successful offer, and what a lane-keyed
## accessor answers for a lane it does not recognise. Deliberately outside every
## declared member: a caller that reads it without reading `ok` gets a value that
## is obviously wrong rather than one that is quietly plausible.
##
## THE SAME COLLISION THE PASSIVE RESULT RECORDS APPLIES HERE AND IS RECORDED
## RATHER THAN LEFT TO BE FOUND: a caller may also ask `seed_for(-1)`, which
## answers `UNRESOLVED_SEED` for the same reason. No CONSTRUCTED offer is
## ambiguous — a refusal always names a declared lane, which `problem()`
## enforces.
const UNRESOLVED_LANE: int = -1

## What a lane-keyed seed accessor answers when it cannot answer. A real lane
## seed is masked to 32 bits by the composer and is therefore never negative, so
## this value cannot be mistaken for one.
const UNRESOLVED_SEED: int = -1

## What `category_for_lane()` answers for the support lane and for an
## unrecognised one. The support lane draws from no stat category at all, and
## saying so with a value outside the vocabulary's enum is more honest than
## borrowing a plausible member.
const NO_CATEGORY: int = -1

## What `support_progression_kind` reads as on a refusal. It is READ from the
## accepted continuation record rather than restated, so there is exactly one
## value in the project meaning "no progression operation was decided" and a
## reader cannot be handed two spellings of it.
const UNRESOLVED_PROGRESSION_KIND: int = SupportContinuationResult.UNRESOLVED_KIND

## What `support_rank_before` and `support_rank_after` read as on a refusal.
## NEGATIVE on purpose: the accepted ranked-ownership state answers zero for a
## pair it does not hold and one or more for a pair it does, so every real rank
## is non-negative and this value can never be mistaken for one. A refusal that
## reported a plausible zero would be indistinguishable from a real new-pair
## offer's before-rank.
const UNRESOLVED_RANK: int = -1

## The fixed lane order. Written out as a constant rather than derived from the
## enum's own value list, because the ORDER is part of the contract and deriving
## it from the declaration would mean a reordered enum silently reordered the
## offer.
const LANE_ORDER: Array[int] = [Lane.SUPPORT, Lane.COMBAT_DEFENCE, Lane.UTILITY]

## WHAT THE SUPPORT LANE OF A SUCCESSFUL OFFER CARRIES (Roguelite Foundation I7,
## decision D-306). Exactly one of the two, stored by the constructor and never
## inferred. The values are positional and stable, exactly as `Lane`'s are.
enum SupportContentKind {
	## One compatible pair and one progression operation on it: the accepted
	## Support lane, unchanged.
	SUPPORT_PROGRESSION,
	## One passive card, chosen by the accepted exhausted-support fallback because
	## support progression is honestly exhausted.
	PASSIVE_FALLBACK,
}

## What `support_content_kind` reads as on a refusal. Outside both declared
## members, so a reader that forgets to read `ok` gets a value that is obviously
## wrong rather than one that is quietly plausible.
const UNRESOLVED_SUPPORT_CONTENT_KIND: int = -1


var ok: bool = false

## Empty exactly when `ok`. Otherwise the single plain-language reason, which
## NAMES THE LANE that prevented composition and quotes that lane's own refusal.
var failure_reason: String = ""

## The lane that prevented composition, as a `Lane` member, or `UNRESOLVED_LANE`
## on a successful offer. The mechanical half of the reason above: a reader that
## must branch on which lane failed reads this rather than parsing a sentence.
##
## WHAT "REFUSED" MEANS ONCE ONE LANE DEPENDS ON OTHERS (Foundation I7, D-306). It
## names the first lane, in the fixed order, whose OWN resolution refused. A lane
## is resolved only after everything it depends on has resolved: an exhausted
## Support lane's passive fallback must exclude the two passive lanes' cards, so it
## is attempted only after both have succeeded. When either passive lane refuses,
## the Support lane is never resolved, has no answer of its own, and is neither
## named here nor counted among the lanes that refused. Once both passive lanes
## are sound, any failure of the fallback is the Support lane's.
var refusing_lane: int = UNRESOLVED_LANE

## The root offer seed this composition was asked for, echoed on success AND on
## failure. It is the QUESTION rather than an answer — the same reasoning the
## accepted passive result records for echoing its requested category — and
## without it a refusal cannot be reproduced.
var root_seed: int = 0

# --- The three lanes ------------------------------------------------------------
#
# All four of the arrays and objects below are empty or null on a refusal, and
# `problem()` enforces exactly that. A refused offer exposes NO Skill, NO
# support and NO card identity, including from a lane that succeeded.

## The lanes this offer carries, in composition order. Always equal to
## `LANE_ORDER` on a successful offer, and always empty on a refusal.
var lanes: Array[int] = []

## The derived lane seed for each lane, positionally matched to `lanes`. Each is
## a non-negative 32-bit value derived from `root_seed` alone.
var lane_seeds: Array[int] = []

# --- What was offered -----------------------------------------------------------

## The equipped Skill the support lane attached its support to.
var skill_id: StringName = &""

## The support that lane selected for that Skill.
var support_id: StringName = &""

## WHICH PROGRESSION OPERATION THE SUPPORT LANE OFFERS, as a
## `SupportContinuationResult.Kind` member, or `UNRESOLVED_PROGRESSION_KIND` on a
## refusal. It is the accepted continuation decision's OWN mechanical answer,
## copied from it and re-checked against it — never inferred from a sentence, a
## label or from whether a rank happens to be greater than zero.
var support_progression_kind: int = UNRESOLVED_PROGRESSION_KIND

## THE RANK THE OFFERED PAIR HELD WHEN THIS OFFER WAS COMPOSED, and the rank it
## would hold after the offer is taken. `UNRESOLVED_RANK` on a refusal.
##
## They are the offer's PROVENANCE rather than a prediction: they say what run
## state this offer was composed against, which is exactly what a later resolver
## needs in order to refuse an offer whose support action no longer matches the
## run. Nothing in THIS file consumes them.
##
## SOMETHING ELSE NOW DOES, AND THE CORRECTION IS RECORDED RATHER THAN LEFT
## STALE (Foundation F4, decision D-257). This paragraph used to end "and this
## foundation implements no such check", which was true of F3 and stopped being
## true of the project: the accepted choice transaction now compares
## `support_rank_before` against the rank the run currently holds and refuses a
## stale offer outright, applies the operation `support_progression_kind`
## declares, and requires the rank it reaches to equal `support_rank_after`.
## NOTHING ABOUT THESE THREE FIELDS MOVED for that — not their names, not their
## types, not their unresolved values, not what freezes them and not the shape
## `problem()` requires of them. They are read by one more file than they were.
var support_rank_before: int = UNRESOLVED_RANK

var support_rank_after: int = UNRESOLVED_RANK

var combat_card_id: StringName = &""

var utility_card_id: StringName = &""

# --- How it was derived ----------------------------------------------------------
#
# The results the two accepted selectors actually returned, kept as they were
# returned. Each carries its own complete derivation and re-checks itself.

## The accepted CONTINUATION decision the support lane was composed from, kept
## exactly as it was returned. It carries its own kind, its own measured
## held-when-classified fact and the whole Foundation B derivation underneath it,
## and it re-checks itself; `problem()` re-asks it rather than believing it.
var support_continuation: SupportContinuationResult = null

## The accepted weighted selection underneath that decision. It is the SAME
## object the continuation carries rather than a copy of it — `problem()`
## requires exactly that — so the two can never describe different draws.
var support_derivation: SupportSelectionResult = null

var combat_derivation: PassiveCardSelectionResult = null

var utility_derivation: PassiveCardSelectionResult = null

# --- What the Support lane carries (Roguelite Foundation I7, D-306) --------------
#
# Appended rather than interleaved, so every field above keeps its place. On a
# refusal all four read their unresolved values except the one classification,
# which a single constructor may set.

## `SupportContentKind.SUPPORT_PROGRESSION` or `.PASSIVE_FALLBACK` on a successful
## offer; `UNRESOLVED_SUPPORT_CONTENT_KIND` on a refusal.
var support_content_kind: int = UNRESOLVED_SUPPORT_CONTENT_KIND

## The one card a passive-fallback Support lane offers, or empty. A convenience
## proved against `support_fallback` in `problem()`, exactly as the four identity
## fields above are proved against their derivations.
var support_fallback_card_id: StringName = &""

## The accepted exhausted-support fallback result the Support lane was composed
## from, kept exactly as it was returned, or null. It carries its own category and
## card stages, both tickets, the two excluded cards and the nested card draw, and
## re-checks itself; `problem()` re-asks it.
var support_fallback: SupportExhaustionPassiveFallbackResult = null

## Whether this REFUSAL is the Support lane's fallback being unavailable: the
## Support lane was exhausted, both passive lanes were sound, and no passive card
## remained once their two cards were excluded. Set only by
## `refused_as_fallback_unavailable()`; always false on a success. It is the
## accepted fallback's own machine-readable classification carried forward, so a
## caller never has to read the sentence to learn it.
var support_fallback_unavailable: bool = false


## The only way to build a refusal. It sets the reason, the lane that answered
## it and the root seed the question was asked with, and NOTHING ELSE — so no
## Skill, support or card identity from a lane that succeeded can be read out of
## an offer that did not compose.
static func refused(reason: String, for_refusing_lane: int, for_root_seed: int) -> RiftOffer:
	var offer: RiftOffer = RiftOffer.new()
	offer.ok = false
	offer.failure_reason = reason if not reason.strip_edges().is_empty() \
		else "the offer failed for an unstated reason"
	offer.refusing_lane = for_refusing_lane
	offer.root_seed = for_root_seed
	return offer


## The Support lane's fallback-unavailable refusal (Foundation I7). Exactly
## `refused()` on the Support lane plus the one classification: no content kind,
## no card, no derivation, no lane — only the reason, the lane, the root seed and
## the fact that the fallback had nothing left to offer.
static func refused_as_fallback_unavailable(reason: String, for_root_seed: int) -> RiftOffer:
	var offer: RiftOffer = refused(reason, Lane.SUPPORT, for_root_seed)
	offer.support_fallback_unavailable = true
	return offer


## The only way to build a successful offer. The four identity fields and the
## progression kind are READ from the three derivations rather than passed in
## separately, so the convenience and the derivation cannot be given two
## different answers at the call site.
##
## THE TWO RANKS ARE THE ONE THING THAT MUST BE PASSED IN, and that is honest
## rather than convenient: they are not a property of the continuation decision
## at all, they are a MEASUREMENT of the acquisition state that decision was made
## against, and only the composer holds that state. It measures them by staging
## the decided operation on a private duplicate through the accepted
## ranked-ownership record's own API; `problem()` then re-checks the SHAPE of
## what it was handed.
static func composed(
	for_root_seed: int,
	for_lane_seeds: Array[int],
	for_continuation: SupportContinuationResult,
	for_rank_before: int,
	for_rank_after: int,
	for_combat: PassiveCardSelectionResult,
	for_utility: PassiveCardSelectionResult
) -> RiftOffer:
	var offer: RiftOffer = RiftOffer.new()
	offer.ok = true
	offer.failure_reason = ""
	offer.refusing_lane = UNRESOLVED_LANE
	offer.root_seed = for_root_seed
	offer.lanes = LANE_ORDER.duplicate()
	offer.lane_seeds = for_lane_seeds.duplicate()
	offer.support_content_kind = SupportContentKind.SUPPORT_PROGRESSION
	offer.support_continuation = for_continuation
	offer.support_derivation = for_continuation.selection
	offer.combat_derivation = for_combat
	offer.utility_derivation = for_utility
	offer.skill_id = for_continuation.skill_id
	offer.support_id = for_continuation.support_id
	offer.support_progression_kind = for_continuation.kind
	offer.support_rank_before = for_rank_before
	offer.support_rank_after = for_rank_after
	offer.combat_card_id = for_combat.selected_card_id
	offer.utility_card_id = for_utility.selected_card_id
	return offer


## The only way to build a successful offer whose Support lane is a PASSIVE
## FALLBACK (Foundation I7). The card is READ from the fallback result rather than
## passed in, so the convenience and the derivation cannot be handed two answers.
## Every support-progression field keeps its unresolved value: no Skill, no
## support, no weighted derivation, no progression kind and no frozen rank. The
## exhausted continuation is kept because it is what allowed the fallback at all.
static func composed_with_passive_fallback(
	for_root_seed: int,
	for_lane_seeds: Array[int],
	for_exhausted: SupportContinuationResult,
	for_fallback: SupportExhaustionPassiveFallbackResult,
	for_combat: PassiveCardSelectionResult,
	for_utility: PassiveCardSelectionResult
) -> RiftOffer:
	var offer: RiftOffer = RiftOffer.new()
	offer.ok = true
	offer.failure_reason = ""
	offer.refusing_lane = UNRESOLVED_LANE
	offer.root_seed = for_root_seed
	offer.lanes = LANE_ORDER.duplicate()
	offer.lane_seeds = for_lane_seeds.duplicate()
	offer.support_content_kind = SupportContentKind.PASSIVE_FALLBACK
	offer.support_continuation = for_exhausted
	offer.support_fallback = for_fallback
	offer.support_fallback_card_id = for_fallback.selected_card_id
	offer.combat_derivation = for_combat
	offer.utility_derivation = for_utility
	offer.combat_card_id = for_combat.selected_card_id
	offer.utility_card_id = for_utility.selected_card_id
	return offer


# --- The lane contract ------------------------------------------------------------

## The stat category a lane draws its card from, as a
## `PlayerStatDefinition.Category` member — or `NO_CATEGORY` for the support
## lane, which draws from no category at all, and for an unrecognised lane.
##
## THIS IS THE ONE PLACE THE LANE VOCABULARY MEETS THE STAT VOCABULARY. The
## composer asks this rather than carrying its own copy of the mapping, and
## `problem()` re-checks each passive derivation's requested category against it,
## so a lane that drew from the wrong category is caught by the same single
## statement that decided what it should draw from.
static func category_for_lane(lane: int) -> int:
	match lane:
		Lane.COMBAT_DEFENCE:
			return PlayerStatDefinition.Category.COMBAT_DEFENCE
		Lane.UTILITY:
			return PlayerStatDefinition.Category.UTILITY
	return NO_CATEGORY


## Whether `lane` is one of the three declared members. Declared as an `int`
## parameter throughout this file on purpose: an enum-typed parameter is an int
## at run time and a value outside the declared set is reachable, so every
## accessor must be able to answer for one.
static func is_declared_lane(lane: int) -> bool:
	return LANE_ORDER.has(lane)


## Whether one FROZEN support progression is a legal transition, or the single
## plain-language reason it is not. THE ONE DEFINITION OF THAT RULE IN THE
## PROJECT (Foundation F4, decision D-257).
##
## IT IS AN EXTRACTION RATHER THAN A NEW RULE, AND THAT IS THE WHOLE POINT.
## These three branches were written inline inside `problem()` below, which is
## still their only caller here and still returns their answer verbatim. The
## accepted choice transaction's own result now asks the SAME function, because
## the alternative was a second copy of "a new pair steps from absent to first"
## and "a rank increase steps by exactly one" living in the file that CONSUMES a
## progression beside the file that FROZE it — and two copies of one rule are a
## way for the offer and the resolver to answer one question differently.
##
## THE TWO RANKS ARE STILL READ FROM THE ACCEPTED RANKED-OWNERSHIP RECORD'S OWN
## TWO NAMED RANKS rather than written here as 0 and 1. A pair nothing holds
## reads as absent, and a first acquisition begins at the first rank; restating
## either number would be a second copy of a fact that belongs to that record.
##
## IT IS A PURE QUERY ABOUT THREE INTEGERS. It reads no offer, no run state and
## no acquisition record, stages nothing and decides nothing — which is exactly
## what lets a resolver ask it about a progression it is about to consume without
## the asking being able to grant anything.
static func support_transition_problem(kind: int, before: int, after: int) -> String:
	match kind:
		SupportContinuationResult.Kind.NEW_PAIR:
			if before != AcquiredSupports.ABSENT_RANK \
					or after != AcquiredSupports.FIRST_RANK:
				return "a new pair must freeze %d -> %d, not %d -> %d" % [
					AcquiredSupports.ABSENT_RANK, AcquiredSupports.FIRST_RANK,
					before, after,
				]
		SupportContinuationResult.Kind.RANK_INCREASE:
			if before < AcquiredSupports.FIRST_RANK:
				return "a rank increase freezes the before-rank %d, which is not a held rank" \
					% before
			if after != before + 1:
				return "a rank increase must freeze a single step, not %d -> %d" % [
					before, after,
				]
		_:
			## DEFENCE IN DEPTH, AND DELIBERATELY UNREACHABLE THROUGH EITHER
			## CALLER. `problem()` below has already required the kind to equal
			## the nested decision's own, and that decision refuses an undeclared
			## kind by name; the choice result reaches this only for a lane whose
			## offer was required coherent first. Neither suite pretends to drive
			## it. It stays because a `match` whose default silently accepts is how
			## a third operation added upstream becomes a legal transition nobody
			## wrote a rule for.
			##
			## THE WORDING IS THE ONE TEXTUAL DIFFERENCE THE F4 EXTRACTION MAKES,
			## AND IT IS RECORDED RATHER THAN GLOSSED: inline, this branch read "a
			## successful offer declares the unknown support progression kind %d",
			## which is a sentence about an OFFER and would be false in the mouth
			## of the result. It is neutral now so both callers can quote it, and
			## nothing asserts the old text — the branch is unreachable from either
			## side, and the three reachable messages above are byte-identical.
			return "the unknown support progression kind %d" % kind
	return ""


# --- Reading one lane ---------------------------------------------------------------
#
# Keyed on the lane MEMBER, never on an index into an array. A caller that knows
# which lane it wants never has to know where that lane sits.

## The lane order this offer actually carries, as a copy. A copy, because handing
## out the live array would let a caller reorder the contract through a reference
## it was only given to read.
func lane_order() -> Array[int]:
	return lanes.duplicate()


## Whether this refusal is the Support lane's fallback being unavailable. Read
## from the stored classification, never from `failure_reason`.
func is_support_fallback_unavailable() -> bool:
	return not ok and support_fallback_unavailable


## The derived seed for one lane, or `UNRESOLVED_SEED` when this offer does not
## carry that lane — which is every lane of a refusal.
func seed_for(lane: int) -> int:
	var index: int = lanes.find(lane)
	if index < 0 or index >= lane_seeds.size():
		return UNRESOLVED_SEED
	return lane_seeds[index]


## The MECHANICAL identities one lane offers, in a stable order: the support
## lane answers its Skill and then its support, and each passive lane answers its
## single card. Empty for a lane this offer does not carry, and empty for every
## lane of a refusal.
##
## IT ANSWERS IDS AND NEVER A DISPLAY NAME, which is what makes it safe to
## compare: renaming a card, a Skill or a support must never change what an
## offer IS.
func identity_for(lane: int) -> PackedStringArray:
	var out: PackedStringArray = PackedStringArray()
	if not ok or not lanes.has(lane):
		return out
	match lane:
		Lane.SUPPORT:
			## A PASSIVE-FALLBACK LANE'S IDENTITY IS ITS ONE CARD (Foundation I7),
			## chosen by the stored kind and never by which fields are empty. Every
			## other offer answers the Skill and the support exactly as before.
			if support_content_kind == SupportContentKind.PASSIVE_FALLBACK:
				out.append(String(support_fallback_card_id))
			else:
				out.append(String(skill_id))
				out.append(String(support_id))
		Lane.COMBAT_DEFENCE:
			out.append(String(combat_card_id))
		Lane.UTILITY:
			out.append(String(utility_card_id))
	return out


## Whether one lane's DERIVATION reports itself coherent. Answers false for a
## lane this offer does not carry, so a caller cannot read a missing lane as a
## healthy one.
##
## THE SUPPORT LANE'S ANSWER IS ABOUT ITS WEIGHTED DERIVATION AND DELIBERATELY
## NOT ABOUT ITS PROGRESSION. The continuation decision, the progression kind and
## the frozen rank transition are checked in `problem()`, in their own named
## statements, so a fault in one of them reports what is actually wrong instead
## of the generic "this lane has no coherent derivation".
func lane_is_coherent(lane: int) -> bool:
	match lane:
		Lane.SUPPORT:
			## A PASSIVE-FALLBACK LANE'S DERIVATION IS THE FALLBACK RESULT
			## (Foundation I7); everything else about it is checked by name in
			## `problem()`, exactly as the progression is.
			if support_content_kind == SupportContentKind.PASSIVE_FALLBACK:
				return support_fallback != null and support_fallback.ok \
					and support_fallback.problem().is_empty()
			return support_derivation != null and support_derivation.ok \
				and support_derivation.problem().is_empty()
		Lane.COMBAT_DEFENCE:
			return combat_derivation != null and combat_derivation.ok \
				and combat_derivation.problem().is_empty()
		Lane.UTILITY:
			return utility_derivation != null and utility_derivation.ok \
				and utility_derivation.problem().is_empty()
	return false


# --- Re-derivation -----------------------------------------------------------------

## Returns "" when the offer is internally coherent, or the FIRST inconsistency
## found, in plain language. This exists because the fields above are a
## DERIVATION, and a derivation that is never re-checked is a derivation that can
## quietly stop matching the thing it describes.
##
## IT RE-ASKS THE NESTED RESULTS RATHER THAN BELIEVING THEM. Each accepted
## selector's result already re-derives its own answer from its own reported
## ladder; this asks each of them that question again and then asks the one
## question neither of them can: whether the three lanes together are the offer
## this file promises.
func problem() -> String:
	if not ok:
		if failure_reason.strip_edges().is_empty():
			return "a refused offer must state a reason"
		if not is_declared_lane(refusing_lane):
			return "a refused offer must name the lane that refused, not %d" % refusing_lane
		if not String(skill_id).is_empty() or not String(support_id).is_empty() \
				or not String(combat_card_id).is_empty() \
				or not String(utility_card_id).is_empty():
			return "a refused offer must expose no Skill, support or card identity"
		if not lanes.is_empty() or not lane_seeds.is_empty():
			return "a refused offer must carry no lane"
		if support_continuation != null or support_derivation != null \
				or combat_derivation != null or utility_derivation != null:
			return "a refused offer must carry no lane derivation"
		## A REFUSAL EXPOSES NO PROGRESSION EITHER. Which operation the support
		## lane WOULD have offered, and the ranks it would have moved between, are
		## answers as much as a Skill id is — and an offer that did not compose has
		## none of them.
		if support_progression_kind != UNRESOLVED_PROGRESSION_KIND:
			return "a refused offer must declare no support progression kind, not %d" \
				% support_progression_kind
		if support_rank_before != UNRESOLVED_RANK or support_rank_after != UNRESOLVED_RANK:
			return "a refused offer must freeze no support rank transition, not %d -> %d" % [
				support_rank_before, support_rank_after,
			]
		## AND NO SUPPORT CONTENT (Foundation I7). Which kind the Support lane
		## would have carried, and a fallback card, are answers as much as a Skill
		## id is. The one thing a refusal may carry is the classification, and only
		## the Support lane can own it.
		if support_content_kind != UNRESOLVED_SUPPORT_CONTENT_KIND:
			return "a refused offer must declare no Support content kind, not %d" \
				% support_content_kind
		if support_fallback != null or not String(support_fallback_card_id).is_empty():
			return "a refused offer must expose no passive fallback"
		if support_fallback_unavailable and refusing_lane != Lane.SUPPORT:
			return "only the Support lane refuses because its passive fallback is unavailable, not the %s lane" \
				% lane_label(refusing_lane)
		return ""

	if not failure_reason.is_empty():
		return "a successful offer must state no failure reason"
	if refusing_lane != UNRESOLVED_LANE:
		return "a successful offer names lane %d as having refused" % refusing_lane
	if support_fallback_unavailable:
		return "a successful offer must not declare its passive fallback unavailable"

	## THE FIXED SHAPE, ASSERTED MEMBER FOR MEMBER RATHER THAN BY LENGTH. A
	## three-entry array in the wrong order is exactly the failure a length test
	## cannot see.
	if lanes.size() != LANE_ORDER.size():
		return "a successful offer carries %d lanes, not %d" % [
			lanes.size(), LANE_ORDER.size(),
		]
	for index: int in LANE_ORDER.size():
		if lanes[index] != LANE_ORDER[index]:
			return "lane %d of the offer is %d where the fixed order declares %d" % [
				index, lanes[index], LANE_ORDER[index],
			]
	if lane_seeds.size() != LANE_ORDER.size():
		return "a successful offer carries %d lane seeds, not %d" % [
			lane_seeds.size(), LANE_ORDER.size(),
		]

	## THE THREE LANE SEEDS ARE DISTINCT, WHICH IS THE WHOLE POINT OF DERIVING
	## THEM SEPARATELY. Two lanes sharing a seed would be two lanes sharing a
	## stream, and that is the failure this foundation exists to make impossible.
	for index: int in lane_seeds.size():
		if lane_seeds[index] < 0:
			return "the %s lane seed is negative (%d)" % [
				lane_label(lanes[index]), lane_seeds[index],
			]
		for other: int in range(index + 1, lane_seeds.size()):
			if lane_seeds[index] == lane_seeds[other]:
				return "the %s and %s lanes share the seed %d" % [
					lane_label(lanes[index]), lane_label(lanes[other]), lane_seeds[index],
				]

	## THE SUPPORT LANE DECLARES ONE OF THE TWO KINDS (Foundation I7). Asked before
	## the lanes' derivations, because which derivation the Support lane owes
	## depends on it.
	if support_content_kind != SupportContentKind.SUPPORT_PROGRESSION \
			and support_content_kind != SupportContentKind.PASSIVE_FALLBACK:
		return "a successful offer declares the unknown Support content kind %d" \
			% support_content_kind

	## EVERY LANE RESOLVED, AND EVERY LANE'S OWN DERIVATION AGREES WITH ITSELF.
	for lane: int in LANE_ORDER:
		if not lane_is_coherent(lane):
			return "the %s lane carries no coherent derivation" % lane_label(lane)

	## THE SUPPORT LANE, BY THE KIND OF CONTENT IT CARRIES (Foundation I7). Each
	## kind has its own named re-derivation below; the kind itself was checked
	## above, so exactly one of the two runs.
	var support_fault: String = _passive_fallback_problem() \
		if support_content_kind == SupportContentKind.PASSIVE_FALLBACK \
		else _support_progression_problem()
	if not support_fault.is_empty():
		return support_fault

	if combat_derivation.selected_card_id != combat_card_id:
		return "the combat lane offers %s but its derivation selected %s" % [
			combat_card_id, combat_derivation.selected_card_id,
		]
	if utility_derivation.selected_card_id != utility_card_id:
		return "the utility lane offers %s but its derivation selected %s" % [
			utility_card_id, utility_derivation.selected_card_id,
		]

	## EACH PASSIVE LANE DREW FROM ITS OWN CATEGORY AND FROM NO OTHER, CHECKED
	## AGAINST THE ONE PLACE THE MAPPING IS WRITTEN.
	if combat_derivation.requested_category != category_for_lane(Lane.COMBAT_DEFENCE):
		return "the combat lane drew from category %d, not %d" % [
			combat_derivation.requested_category, category_for_lane(Lane.COMBAT_DEFENCE),
		]
	if utility_derivation.requested_category != category_for_lane(Lane.UTILITY):
		return "the utility lane drew from category %d, not %d" % [
			utility_derivation.requested_category, category_for_lane(Lane.UTILITY),
		]

	## THE TWO PASSIVE LANES CANNOT OFFER THE SAME CARD. It is impossible by
	## construction — a card belongs to exactly one category and the two lanes
	## draw from different ones — which is precisely why it is asserted rather
	## than assumed: an impossibility nobody checks is how a later category change
	## starts offering the same card twice.
	if combat_card_id == utility_card_id:
		return "both passive lanes offer %s" % combat_card_id

	## THE SUPPORT LANE IS NAMED BY WHAT ITS KIND CARRIES (Foundation I7): a
	## progression lane by its Skill and its support exactly as before, a fallback
	## lane by its one card.
	var support_named: bool = not String(support_fallback_card_id).is_empty() \
		if support_content_kind == SupportContentKind.PASSIVE_FALLBACK \
		else (not String(skill_id).is_empty() and not String(support_id).is_empty())
	if not support_named \
			or String(combat_card_id).is_empty() or String(utility_card_id).is_empty():
		return "a successful offer must name every lane's selection"
	return ""


## THE SUPPORT-PROGRESSION LANE'S OWN RE-DERIVATION, and it is the block that
## lived inline in `problem()` from Foundation D1 to Foundation I6 — moved here
## unchanged when Foundation I7 (decision D-306) gave the Support lane a second
## kind of content, so the two kinds are checked by two named statements rather
## than by one statement taught to skip half of itself. `problem()` calls it only
## for a `SUPPORT_PROGRESSION` lane, only once every lane's derivation has been
## required coherent, and returns its answer verbatim. Every message it can return
## is byte-identical to the one `problem()` returned before; the one check added
## at its end is new.
func _support_progression_problem() -> String:
	if support_derivation.skill_id != skill_id \
			or support_derivation.support_id != support_id:
		return "the support lane offers %s -> %s but its derivation selected %s" % [
			skill_id, support_id, support_derivation.pair(),
		]

	## THE SUPPORT LANE'S PROGRESSION, RE-ASKED RATHER THAN BELIEVED. The
	## continuation record already re-checks its own kind against the pair it was
	## classified on; this asks it that question again and then asks the one
	## question it cannot: whether the transition frozen beside it is the one that
	## kind owes.
	if support_continuation == null:
		return "a successful offer must carry the support lane's continuation decision"
	if not support_continuation.ok:
		return "the support lane carries a failed continuation: %s" \
			% support_continuation.failure_reason
	var continuation_problem: String = support_continuation.problem()
	if not continuation_problem.is_empty():
		return "the support lane's continuation is incoherent: %s" % continuation_problem
	## THE SAME OBJECT, NOT AN EQUAL ONE. Holding a second weighted result beside
	## the decision that produced it would be two places for one draw to be
	## written, which is exactly the drift every nested derivation here exists to
	## make impossible.
	if support_derivation != support_continuation.selection:
		return "the support lane's weighted derivation is not the one its continuation decided from"
	if support_continuation.skill_id != skill_id \
			or support_continuation.support_id != support_id:
		return "the support lane offers %s -> %s but its continuation decided %s" % [
			skill_id, support_id, support_continuation.pair(),
		]
	if support_progression_kind != support_continuation.kind:
		return "the support lane declares progression kind %d where its continuation decided %d" % [
			support_progression_kind, support_continuation.kind,
		]
	## THE FROZEN TRANSITION, ASKED OF THE ONE PLACE THAT RULE IS WRITTEN
	## (Foundation F4). The three branches this replaced are unchanged in every
	## reachable respect; they simply live in `support_transition_problem()` above
	## now, so the resolver that CONSUMES a frozen progression and this record
	## that FROZE it cannot start disagreeing about what a legal step is.
	var transition: String = support_transition_problem(
		support_progression_kind, support_rank_before, support_rank_after)
	if not transition.is_empty():
		return transition
	## A PROGRESSION LANE CARRIES NO FALLBACK (Foundation I7). The converse of the
	## fallback lane's own rule below, so neither kind can quietly carry the
	## other's content.
	if support_fallback != null or not String(support_fallback_card_id).is_empty():
		return "a support-progression lane must carry no passive fallback"
	return ""


## THE PASSIVE-FALLBACK LANE'S RE-DERIVATION (Foundation I7, decision D-306).
## `problem()` calls it only for a `PASSIVE_FALLBACK` lane and only once every
## lane's derivation — the fallback result and both passive draws — has been
## required coherent, and returns its answer verbatim. It re-asks rather than
## believes, in both directions.
func _passive_fallback_problem() -> String:
	## NO SUPPORT FIELD IS BORROWED. A fallback lane offers no support operation, so
	## every field that describes one keeps its unresolved value.
	if not String(skill_id).is_empty() or not String(support_id).is_empty():
		return "a passive-fallback Support lane must name no Skill or support, not %s -> %s" % [
			skill_id, support_id,
		]
	if support_derivation != null:
		return "a passive-fallback Support lane must carry no weighted support derivation"
	if support_progression_kind != UNRESOLVED_PROGRESSION_KIND:
		return "a passive-fallback Support lane must declare no support progression kind, not %d" \
			% support_progression_kind
	if support_rank_before != UNRESOLVED_RANK or support_rank_after != UNRESOLVED_RANK:
		return "a passive-fallback Support lane must freeze no support rank transition, not %d -> %d" % [
			support_rank_before, support_rank_after,
		]

	## THE EXHAUSTION IT ANSWERS, RE-ASKED THROUGH THE RECORD'S OWN PREDICATE. A
	## fallback is legal only because support progression is honestly exhausted.
	if support_continuation == null:
		return "a passive-fallback Support lane must carry the exhausted continuation it falls back from"
	var continuation_problem: String = support_continuation.problem()
	if not continuation_problem.is_empty():
		return "the Support lane's exhausted continuation is incoherent: %s" % continuation_problem
	if not support_continuation.is_exhausted():
		return "a passive fallback may answer only an exhausted Support lane, not: %s" \
			% support_continuation.describe()

	## THE CARD IS THE FALLBACK'S OWN.
	if String(support_fallback_card_id).is_empty() \
			or support_fallback_card_id != support_fallback.selected_card_id:
		return "the Support lane offers the passive fallback %s but its fallback selected %s" % [
			support_fallback_card_id, support_fallback.selected_card_id,
		]

	## NEVER A CARD THIS OFFER ALREADY CARRIES, read from the two passive draws
	## themselves, and the fallback excluded exactly those two, in lane order.
	var carried: Array[StringName] = [
		combat_derivation.selected_card_id, utility_derivation.selected_card_id,
	]
	if carried.has(support_fallback_card_id):
		return "the Support lane's passive fallback %s is already offered by a passive lane" \
			% support_fallback_card_id
	var excluded: Array[StringName] = support_fallback.excluded_card_ids()
	if excluded != carried:
		return "the Support lane's passive fallback excluded %s, not the two passive lanes' %s in lane order" % [
			str(excluded), str(carried),
		]

	## ITS CATEGORY AND ITS NESTED CARD DRAW AGREE WITH THE CARD.
	var nested: PassiveCardSelectionResult = support_fallback.selection()
	if nested == null or nested.selected_card_id != support_fallback_card_id \
			or nested.requested_category != support_fallback.selected_category:
		return "the Support lane's passive fallback names %s in %s, but its nested draw does not agree" % [
			support_fallback_card_id,
			PassiveCardSelectionResult.category_label(support_fallback.selected_category),
		]

	## DRAWN FROM THIS OFFER'S OWN SUPPORT LANE SEED. Both stage tickets are
	## re-derived from the recorded seed through the accepted fallback's own public
	## stream, so a fallback drawn from any other seed is caught.
	var support_seed: int = seed_for(Lane.SUPPORT)
	if support_fallback.category_ticket != SupportExhaustionPassiveFallback.category_ticket_for(support_seed) \
			or support_fallback.card_ticket != SupportExhaustionPassiveFallback.card_ticket_for(support_seed):
		return "the Support lane's passive fallback was not drawn from the Support lane seed %d" \
			% support_seed
	return ""


# --- Presentation ---------------------------------------------------------------
#
# Deliberately separate from the fields and the re-derivation above. No formatted
# string is compared, parsed or fed back into an identity, and nothing in
# `problem()` reads one except to quote a lane's name inside a message.

## One lane's own name. The support lane's is Foundation D1's own word, because
## no vocabulary above this file has one; the two passive lanes' names are READ
## from the canonical stat vocabulary through the accepted passive result's own
## formatter, so a lane and the category it draws from can never be displayed
## under two different names.
static func lane_label(lane: int) -> String:
	match lane:
		Lane.SUPPORT:
			return "Support"
		Lane.COMBAT_DEFENCE, Lane.UTILITY:
			return PassiveCardSelectionResult.category_label(category_for_lane(lane))
	return "unrecognised lane %d" % lane


## WHICH OPERATION THE SUPPORT LANE OFFERS AND THE RANK IT WOULD MOVE, in plain
## language. PRESENTATION ONLY, and deliberately kept out of `offer_line()`,
## `seed_line()` and `describe()`: those three are what every accepted foundation
## compares an offer against, and a progression appearing inside them would
## change what those comparisons mean. The kind label is read from the accepted
## continuation record so a decision and an offer can never name one operation
## two different ways.
func support_progression_line() -> String:
	## A passive-fallback lane offers no progression (Foundation I7); a
	## progression lane and a refusal read exactly as they always have.
	if not ok or support_content_kind != SupportContentKind.SUPPORT_PROGRESSION:
		return "no support progression"
	return "%s, rank %d -> %d" % [
		SupportContinuationResult.kind_label(support_progression_kind),
		support_rank_before, support_rank_after,
	]


## WHICH PASSIVE CARD THE SUPPORT LANE CARRIES INSTEAD, AND HOW IT WAS CHOSEN
## (Foundation I7). PRESENTATION ONLY, and kept out of `offer_line()`,
## `seed_line()` and `describe()` for the reason the progression line above is.
## Nothing reads it back, and nothing that runs displays it.
func support_fallback_line() -> String:
	if ok and support_content_kind == SupportContentKind.PASSIVE_FALLBACK \
			and support_fallback != null:
		return "passive fallback: %s" % support_fallback.describe()
	if is_support_fallback_unavailable():
		return "passive fallback unavailable"
	return "no passive fallback"


## The three lanes and what each offers, in composition order.
func offer_line() -> String:
	if not ok:
		return "no offer"
	var parts: PackedStringArray = PackedStringArray()
	for lane: int in lanes:
		parts.append("%s: %s" % [lane_label(lane), " -> ".join(identity_for(lane))])
	return "; ".join(parts)


## The lane seeds, in composition order.
func seed_line() -> String:
	var parts: PackedStringArray = PackedStringArray()
	for lane: int in lanes:
		parts.append("%s %d" % [lane_label(lane), seed_for(lane)])
	return ", ".join(parts) if not parts.is_empty() else "no lane seeds"


func describe() -> String:
	if not ok:
		return "no offer from root seed %d — %s" % [root_seed, failure_reason]
	return "root seed %d [%s] — %s" % [root_seed, seed_line(), offer_line()]
