class_name RiftOfferChoiceResult
extends RefCounted
## Riftwrought — Roguelite Foundation D3: the outcome of one attempt to take one
## lane of one Rift offer.
##
## ITS ONE COLLECTION IS PRIVATE AND IS READ THROUGH A DUPLICATING ACCESSOR
## (D-249). It was a public `PackedStringArray` field, and a value type read out
## of an object is not necessarily a value: the read aliased, so a caller could
## mutate the identity inside an accepted result and make this type's own
## `problem()` fail. See `_chosen_identity` for the measurement. Nothing else
## about this type moved AT THAT CORRECTION — not the ordering, not the lane
## shapes, not the transaction order, not which side owns the new build or the new
## ledger, and not what a refusal attributes. Foundation F4 later added three
## scalars and two readings; see the paragraph below rather than reading this one
## as a claim about the whole history of the type.
##
## IT IS EITHER A COMPLETE NEW STATE OR NOTHING AT ALL, AND THE TYPE ENFORCES
## THAT RATHER THAN DOCUMENTING IT. A success carries the lane that was taken,
## the seed that was spent, the mechanical identities that were granted, and the
## two INDEPENDENT new values the transaction produced. A refusal carries the
## question and the reason, and carries no identity, no build and no ledger — so
## there is no arrangement in which a caller reads a half-applied choice out of a
## result that says it failed.
##
## A REFUSAL ECHOES ONLY THE QUESTION. The root seed and the requested lane are
## what the attempt WAS, not what it produced; without them a refusal cannot be
## diagnosed at all, and with anything more a refusal starts leaking an answer it
## did not earn. `root_seed_known` exists because every integer is a legal seed:
## there is no value that could mean "no seed", so the absence is carried as its
## own fact rather than encoded in a sentinel a caller could mistake for a seed.
##
## THE LANE IS ONE FIELD BECAUSE IT IS ONE FACT. On a success it is the lane that
## was chosen; on a refusal it is the lane that was requested. Those are the same
## question read at two moments, and giving them two fields would be inviting
## them to disagree.
##
## `problem()` REJECTS CONTRADICTORY SHAPES, INCLUDING ONE NOTHING CURRENTLY
## BUILDS. It re-asks the new ledger whether it really records the seed this
## result claims to have consumed, which is the one cross-check neither
## constructor can make for itself: a result that says a seed was spent while
## carrying a ledger that never recorded it would otherwise be a perfectly
## well-formed lie.
##
## A SUCCESSFUL SUPPORT CHOICE RETAINS THE MECHANICAL PROGRESSION IT CONSUMED
## (Foundation F4, decision D-257). Which operation was taken and the two ranks
## it moved between are as much a part of what happened as the Skill and the
## support are, and a caller that had to re-derive them would be re-deriving them
## from a build that has already moved. THEY ARE NOT PART OF THE IDENTITY: the
## support lane still grants exactly two ordered ids, because an identity is WHAT
## was granted and a progression is WHICH OPERATION was performed on it, and
## appending either to that array would change what every consumer of a lane
## identity is looking at.
##
## A PASSIVE SUCCESS AND EVERY REFUSAL CARRY NO PROGRESSION AT ALL, and
## `problem()` enforces exactly that in both directions — a passive lane that
## declared an operation, or a refusal that exposed a rank, is as incoherent as a
## refusal that exposed a build.
##
## THE UNRESOLVED KIND IS READ FROM THE OFFER CONTRACT rather than restated, so
## there is one spelling of "no operation" in the project. The two ranks use
## `NO_RANK` instead, and that asymmetry is deliberate and measured; see the
## constant.
##
## THE FROZEN TRANSITION IS RE-CHECKED THROUGH THE OFFER'S OWN SHARED VALIDATOR
## AND NOT THROUGH A SECOND COPY OF THE RULE. `RiftOffer.support_transition_problem()`
## is the single definition of what a legal step is; this file asks it rather than
## restating "a new pair goes from absent to first" beside the file that froze it.
##
##
## PERMANENT COHERENCE AND A POINT-IN-TIME AUDIT ARE TWO DIFFERENT QUESTIONS, AND
## CONFLATING THEM WAS A REAL DEFECT (D-258)
## ---------------------------------------------------------------------------
## `problem()` first shipped requiring the pair's rank IN THE CARRIED BUILD to
## equal `support_rank_after`. That is true at the instant the transaction
## commits, and it stops being true the moment the caller does the ordinary next
## thing with the value it was handed: raise that same support again. The result
## itself had not changed in any way — same lane, same seed, same identity, same
## frozen kind and ranks, same ledger record — and yet it began reporting itself
## incoherent, which made a correct historical record look like a malformed one
## and made "is this result well-formed?" un-askable after the run moved on.
##
## THE LINE IS NOW DRAWN BY LIFETIME. `problem()` owns the STABLE TRANSACTION
## FACTS: what lane was taken, which seed was spent, what identity was granted,
## which operation the progression declares and whether its two ranks are a legal
## step, that the ledger really records the spend, and that both new values are
## present. `support_progression_build_problem()` owns the ONE fact that is
## allowed to stop being true — whether the build being carried still sits at the
## rank this choice reached — and it is a diagnostic a caller asks deliberately
## rather than a rule the type enforces forever.
##
## NEITHER GUARD WAS WEAKENED BY THE MOVE, AND THAT IS THE POINT RATHER THAN A
## CONSOLATION. The TRANSACTION still reads the staged rank back out of the build
## it mutated and refuses, atomically and before the seed is spent, if it did not
## land on the offer's frozen after-rank. A success against a build that never
## reached that rank still cannot be constructed at all. What moved is only the
## question a FINISHED result answers about a build it no longer controls.
##
##
## A SUCCESSFUL SUPPORT CHOICE CARRIES ONE OF TWO KINDS OF CONTENT (Roguelite
## Foundation I8, decision D-308)
## ---------------------------------------------------------------------------
## Since Foundation I7 the Support lane of an offer carries either a support
## progression or, when support progression is honestly used up, the one passive
## card the accepted exhausted-support fallback chose. This result now says which
## of the two a successful Support choice consumed, in `support_content_kind`,
## written by the constructor that built the result and never inferred from the
## identity's length, from which fields happen to be empty, or from any text.
##
## FOUR SHAPES ARE COHERENT AND `problem()` REJECTS EVERY MIXTURE OF THEM:
##
##   Support progression     two ids, a progression, no fallback category
##   Support fallback        one card id, no progression, the fallback's category
##   ordinary passive lane   one card id, no progression, no fallback category
##   refusal                 nothing at all
##
## A FALLBACK SUCCESS KEEPS ONE FACT OF THE FALLBACK AND NO MORE. The card is
## already the identity, so a second copy of its id would be a second place for
## one fact. The category is the one thing the identity cannot say — which of the
## two passive categories the fallback drew from — and the transaction copies it
## from the fallback result it validated, never from the lane. No offer, no
## fallback derivation, no ticket, no weight, no stat, no amount and no name is
## stored here.
##
## THE ACCEPTED ONE-ARGUMENT SHAPE READING IS PRESERVED, AND A CONTENT-AWARE ONE
## SITS BESIDE IT. `identity_size_for(lane)` still answers two for the Support
## lane, because accepted downstream readers ask it about a Support result they
## expect to carry a progression, and changing what it means before they are
## taught the second kind would change their answers without anyone deciding it.
## `identity_size_for_content(lane, kind)` answers for both kinds, and it is the
## one this file's own `problem()` and the transaction's fallback staging ask.
##
## THE ACCEPTED CONSTRUCTOR STILL BUILDS EXACTLY THE TWO SHAPES IT ALWAYS BUILT.
## `chosen()` writes the support-progression kind for the Support lane and no
## Support content at all for a passive lane — the constructor declaring what it
## builds, exactly as the offer's own two constructors do. The fallback shape has
## its own constructor, `chosen_support_fallback()`, which requires the category
## and cannot take a progression. See `chosen()` for what that did to the
## sentence there about there being one constructor.
##
## THE POINT-IN-TIME AUDIT STAYS PROGRESSION-ONLY. A fallback card is a
## repeatable acquisition, and a caller that takes the same card again later has
## not made the historical choice wrong — so neither `problem()` nor the audit
## asks the carried build how many times it now holds the card.
##
## IT IS INERT. No node, no signal, no clock, no random source, no file. It
## describes a transaction that has already happened and performs none of its
## own.

## How many mechanical identifiers each lane grants. The support lane grants a
## Skill and a support; each passive lane grants one card. Written here and read
## by the transaction, so the shape a lane produces and the shape a result is
## checked against are one statement rather than two.
const SUPPORT_IDENTITY_SIZE: int = 2
const PASSIVE_IDENTITY_SIZE: int = 1

## What a lane that is not one of the three declared members grants: nothing.
const NO_IDENTITY_SIZE: int = 0

## What both rank fields read as when this result carries no support progression:
## a passive success and every refusal.
##
## ZERO, NOT THE OFFER RECORD'S NEGATIVE `UNRESOLVED_RANK`, AND THE ASYMMETRY IS
## DELIBERATE RATHER THAN AN OVERSIGHT. An OFFER must be able to distinguish "no
## progression was decided" from "a new pair beginning at rank zero", because
## both are things an offer can legitimately be, so its unresolved rank has to sit
## outside every real rank. A RESULT cannot be in that position: whether it
## carries a progression at all is answered by `carries_support_progression()`,
## which reads the KIND, exactly as `root_seed_known` above answers for a seed
## whose own field defaults to a perfectly legal zero. Given a flag that already
## answers the question, a stand-in is more honest than a sentinel — and a reader
## that ignores the flag gets a zero rather than a negative number it might
## mistake for arithmetic.
const NO_RANK: int = 0

## What `support_fallback_category` reads as whenever this result carries no
## passive fallback: a Support progression, an ordinary passive lane and every
## refusal (Foundation I8, D-308). It is the offer contract's own "no category"
## rather than a third spelling of one, and it sits outside both passive
## categories, so it can never be mistaken for either.
const NO_FALLBACK_CATEGORY: int = RiftOffer.NO_CATEGORY


var ok: bool = false

## Empty exactly when `ok`. Otherwise the single plain-language reason.
var failure_reason: String = ""

## The root seed this attempt was made against — spent on a success, merely
## echoed on a refusal. Meaningful only when `root_seed_known`.
var root_seed: int = 0

## Whether `root_seed` above says anything at all. False only when the attempt
## carried no offer to read a seed from.
var root_seed_known: bool = false

## The lane, as a `RiftOffer.Lane` member on a success and as whatever was
## requested on a refusal — which may be a value outside the declared set,
## because that is one of the things a refusal exists to report.
var lane: int = RiftOffer.UNRESOLVED_LANE

## WHICH PROGRESSION OPERATION THIS CHOICE CONSUMED, as a
## `SupportContinuationResult.Kind` member — read through the offer contract's own
## unresolved value so there is one spelling of "none" — and the two ranks that
## operation moved the pair between.
##
## MEANINGFUL ONLY ON A SUCCESSFUL SUPPORT CHOICE. They are the offer's FROZEN
## values rather than a second measurement: the transaction proved the staged
## build actually reached the after-rank before it spent anything, and `problem()`
## below asks the carried build that same question again for itself.
##
## THEY ARE PUBLIC SCALARS FOR THE REASON D-249 MEASURED: an int read out of an
## object cannot reach the object. The one collection here is private and copied
## on the way out, and these are not a collection.
var support_progression_kind: int = RiftOffer.UNRESOLVED_PROGRESSION_KIND

var support_rank_before: int = NO_RANK

var support_rank_after: int = NO_RANK

## The mechanical identifiers this choice granted, in the offer's own lane order:
## the Skill and then the support for the support lane, the card for a passive
## lane. Empty on every refusal.
##
## PRIVATE, AND READ THROUGH `chosen_identity()`, WHICH DUPLICATES — AND THAT IS
## A CORRECTION OF A MEASURED DEFECT RATHER THAN A STYLE CHOICE (D-249). This
## was a PUBLIC field, and the paragraph that stood here said a
## `PackedStringArray` is copied on assignment so a caller reading it could not
## reach the value inside the result. **That is not what this engine does when
## the source is a script VARIABLE.** Reading such a field into a typed local and
## appending to it mutated the array held here, which meant a caller could grow
## the identity of a choice it was only given to read — and `problem()` below
## then reported this very result as incoherent, because the lane's identifier
## count no longer matched the shape its lane owes. A result that a reader can
## turn into a lie is worse than one that merely says too much.
##
## THE NEIGHBOURING READINGS WERE NEVER AFFECTED, AND THE CONTRAST IS WHAT
## LOCATES THE DEFECT PRECISELY: the offer's own lane identity and the ledger's
## own seed list BUILD a fresh array on every call, and the offer's lane order
## duplicates. The aliasing belonged to a STORED FIELD of packed-array type, and
## nothing else.
##
## THE SCALARS ABOVE STAY PUBLIC FIELDS FOR THE REASON THIS ONE DOES NOT: a
## bool, an int or a String read out of an object cannot reach anything. The
## asymmetry is the measurement rather than a preference.
var _chosen_identity: PackedStringArray = PackedStringArray()

## The new run build, independent of the one the transaction was handed. Null on
## every refusal.
var new_build: RiftRunBuild = null

## The new consumption ledger, independent of the one the transaction was handed.
## Null on every refusal.
var new_ledger: RiftConsumptionLedger = null

## WHICH KIND OF CONTENT A SUCCESSFUL SUPPORT CHOICE CONSUMED (Foundation I8,
## D-308): the offer contract's `SupportContentKind.SUPPORT_PROGRESSION` or
## `.PASSIVE_FALLBACK`. Every other result — an ordinary passive lane and every
## refusal — reads the offer contract's own unresolved value, so there is one
## spelling of "no Support content" in the project. Appended after every accepted
## field, so each of those keeps its place.
var support_content_kind: int = RiftOffer.UNRESOLVED_SUPPORT_CONTENT_KIND

## WHICH PASSIVE CATEGORY A CONSUMED FALLBACK DREW FROM, copied from the fallback
## result the transaction validated. `NO_FALLBACK_CATEGORY` on every other
## result. A public scalar for the reason the others are: an int read out of an
## object cannot reach the object.
var support_fallback_category: int = NO_FALLBACK_CATEGORY


## How many identifiers `lane` grants when its Support lane carries a support
## progression, or `NO_IDENTITY_SIZE` for a lane outside the declared set.
##
## PRESERVED EXACTLY FOR THE ACCEPTED READERS THAT ALREADY ASK IT (Foundation I8,
## D-308). It answers the Support lane's PROGRESSION shape and knows of no other,
## which is what every accepted caller of it expects. A reader that must allow
## for a passive fallback asks `identity_size_for_content()` below, which reads
## these same numbers rather than restating them.
static func identity_size_for(for_lane: int) -> int:
	match for_lane:
		RiftOffer.Lane.SUPPORT:
			return SUPPORT_IDENTITY_SIZE
		RiftOffer.Lane.COMBAT_DEFENCE, RiftOffer.Lane.UTILITY:
			return PASSIVE_IDENTITY_SIZE
	return NO_IDENTITY_SIZE


## How many identifiers `lane` grants when it carries `content_kind`
## (Foundation I8, D-308): two for a Support progression, one card for a Support
## passive fallback, one card for an ordinary passive lane that carries no
## Support content — and `NO_IDENTITY_SIZE` for any other pairing, because a
## lane and a content kind that do not belong together grant nothing coherent.
##
## THE TWO ONE-VERSUS-TWO MISTAKES ARE BOTH CAUGHT HERE, and they are the reason
## it exists: a Support progression that granted one id and a Support fallback
## that granted two are each refused by the same single comparison `problem()`
## makes, with no reader having to know which kind it is looking at first.
static func identity_size_for_content(for_lane: int, for_content_kind: int) -> int:
	match for_lane:
		RiftOffer.Lane.SUPPORT:
			match for_content_kind:
				RiftOffer.SupportContentKind.SUPPORT_PROGRESSION:
					return identity_size_for(RiftOffer.Lane.SUPPORT)
				RiftOffer.SupportContentKind.PASSIVE_FALLBACK:
					return PASSIVE_IDENTITY_SIZE
			return NO_IDENTITY_SIZE
		RiftOffer.Lane.COMBAT_DEFENCE, RiftOffer.Lane.UTILITY:
			if for_content_kind == RiftOffer.UNRESOLVED_SUPPORT_CONTENT_KIND:
				return identity_size_for(for_lane)
			return NO_IDENTITY_SIZE
	return NO_IDENTITY_SIZE


## A refusal made before an offer was available to read a seed from — which is
## exactly one case, a null offer. Separate from `refused()` rather than folded
## into it behind a flag, so a call site cannot claim a seed it never saw.
static func refused_without_a_seed(reason: String, requested_lane: int) -> RiftOfferChoiceResult:
	var result: RiftOfferChoiceResult = RiftOfferChoiceResult.new()
	result.ok = false
	result.failure_reason = _stated(reason)
	result.root_seed_known = false
	result.lane = requested_lane
	return result


## A refusal that can name the seed the attempt was made against. It sets the
## question and NOTHING ELSE, so no identity, build or ledger can be read out of
## a choice that did not happen.
static func refused(
	reason: String, for_root_seed: int, requested_lane: int
) -> RiftOfferChoiceResult:
	var result: RiftOfferChoiceResult = RiftOfferChoiceResult.new()
	result.ok = false
	result.failure_reason = _stated(reason)
	result.root_seed = for_root_seed
	result.root_seed_known = true
	result.lane = requested_lane
	return result


## The only way to build a success. Every field is required, because a success
## that could be built without one of them is a success that can be built wrong.
## THE THREE PROGRESSION VALUES ARE REQUIRED TOO, AND THERE IS STILL ONE
## CONSTRUCTOR. A second one taking a support progression would let a call site
## build a support success without stating an operation simply by picking the
## other function; requiring all three of every success means a passive lane has
## to say, explicitly, that it consumed none — and `problem()` refuses the
## combination either of them could get wrong.
##
## THE SENTENCE ABOVE ABOUT ONE CONSTRUCTOR WAS NARROWED BY FOUNDATION I8
## (D-308), AND THE CORRECTION IS RECORDED HERE RATHER THAN LEFT TO MISLEAD. This
## is still the only way to build a Support PROGRESSION or an ordinary passive
## success, and it now also writes which Support content that is: the
## progression kind for the Support lane, none for a passive lane. A Support lane
## that consumed a passive fallback is a third shape with its own constructor,
## `chosen_support_fallback()`, and picking that one does not let a call site
## skip stating an operation — it states a DIFFERENT content kind, requires a
## category, and `problem()` refuses a fallback that carries any progression and
## a progression that names any fallback category.
static func chosen(
	for_root_seed: int,
	for_lane: int,
	for_identity: PackedStringArray,
	for_progression_kind: int,
	for_rank_before: int,
	for_rank_after: int,
	for_build: RiftRunBuild,
	for_ledger: RiftConsumptionLedger
) -> RiftOfferChoiceResult:
	var result: RiftOfferChoiceResult = RiftOfferChoiceResult.new()
	result.ok = true
	result.failure_reason = ""
	result.root_seed = for_root_seed
	result.root_seed_known = true
	result.lane = for_lane
	result._chosen_identity = for_identity.duplicate()
	result.support_progression_kind = for_progression_kind
	result.support_rank_before = for_rank_before
	result.support_rank_after = for_rank_after
	result.new_build = for_build
	result.new_ledger = for_ledger
	result.support_content_kind = RiftOffer.SupportContentKind.SUPPORT_PROGRESSION \
		if for_lane == RiftOffer.Lane.SUPPORT else RiftOffer.UNRESOLVED_SUPPORT_CONTENT_KIND
	result.support_fallback_category = NO_FALLBACK_CATEGORY
	return result


## The only way to build a success whose Support lane consumed a PASSIVE
## FALLBACK (Foundation I8, D-308). The lane is the Support lane by construction;
## the identity is the one card; the category is the one the fallback drew from.
## Every progression field is written explicitly as absent, so a fallback success
## cannot acquire a progression by omission.
static func chosen_support_fallback(
	for_root_seed: int,
	for_identity: PackedStringArray,
	for_fallback_category: int,
	for_build: RiftRunBuild,
	for_ledger: RiftConsumptionLedger
) -> RiftOfferChoiceResult:
	var result: RiftOfferChoiceResult = RiftOfferChoiceResult.new()
	result.ok = true
	result.failure_reason = ""
	result.root_seed = for_root_seed
	result.root_seed_known = true
	result.lane = RiftOffer.Lane.SUPPORT
	result._chosen_identity = for_identity.duplicate()
	result.support_progression_kind = RiftOffer.UNRESOLVED_PROGRESSION_KIND
	result.support_rank_before = NO_RANK
	result.support_rank_after = NO_RANK
	result.new_build = for_build
	result.new_ledger = for_ledger
	result.support_content_kind = RiftOffer.SupportContentKind.PASSIVE_FALLBACK
	result.support_fallback_category = for_fallback_category
	return result


## The identifiers this choice granted, as an INDEPENDENT COPY, in the offer's
## own lane order. Empty on every refusal.
##
## A METHOD RATHER THAN A FIELD, AND THE DIFFERENCE IS THE WHOLE POINT: appending
## to what this answers cannot change what the next call answers, and two callers
## holding two answers cannot reach each other. The ordering, the lane shapes and
## the ids themselves are exactly what they were — only the route in is safe now.
func chosen_identity() -> PackedStringArray:
	return _chosen_identity.duplicate()


## Whether this result carries a consumed support progression, which is the ONE
## authority on whether the two rank fields say anything at all.
##
## IT READS THE KIND RATHER THAN THE LANE, and the difference is the whole reason
## it exists: a result whose lane is the support lane but whose kind was never set
## is exactly the incoherent shape `problem()` catches, and a flag derived from
## the lane would report it as healthy. Reading the field that carries the answer
## means this cannot disagree with what is actually there.
func carries_support_progression() -> bool:
	return ok and support_progression_kind != RiftOffer.UNRESOLVED_PROGRESSION_KIND


## Whether this result consumed a Support passive fallback (Foundation I8,
## D-308) — the one authority on whether `support_fallback_category` says
## anything at all. It reads the stored content kind rather than the lane or the
## identity's length, for the reason the reading above reads the kind: a flag
## derived from anything else would report an incoherent result as healthy.
func carries_support_fallback() -> bool:
	return ok and support_content_kind == RiftOffer.SupportContentKind.PASSIVE_FALLBACK


## Returns "" when this result is internally coherent, or the FIRST
## contradiction found, in plain language.
func problem() -> String:
	if not ok:
		if failure_reason.strip_edges().is_empty():
			return "a refused choice must state a reason"
		if not _chosen_identity.is_empty():
			return "a refused choice must expose no chosen identity"
		if new_build != null:
			return "a refused choice must expose no updated run build"
		if new_ledger != null:
			return "a refused choice must expose no updated consumption ledger"
		## A REFUSAL EXPOSES NO PROGRESSION RESULT EITHER. Which operation would
		## have been taken, and the ranks it would have moved between, are answers
		## as much as a granted id is — and a choice that did not happen has none.
		if support_progression_kind != RiftOffer.UNRESOLVED_PROGRESSION_KIND:
			return "a refused choice must declare no support progression kind, not %d" \
				% support_progression_kind
		if support_rank_before != NO_RANK or support_rank_after != NO_RANK:
			return "a refused choice must expose no support rank, not %d -> %d" % [
				support_rank_before, support_rank_after,
			]
		## AND NO SUPPORT CONTENT (Foundation I8). Which kind the Support lane
		## would have consumed, and a fallback's category, are answers as much as
		## a granted id is.
		if support_content_kind != RiftOffer.UNRESOLVED_SUPPORT_CONTENT_KIND:
			return "a refused choice must declare no Support content kind, not %d" \
				% support_content_kind
		if support_fallback_category != NO_FALLBACK_CATEGORY:
			return "a refused choice must name no fallback category, not %d" \
				% support_fallback_category
		return ""

	if not failure_reason.is_empty():
		return "a successful choice must state no failure reason"
	if not root_seed_known:
		return "a successful choice must name the root seed it consumed"
	if not RiftOffer.is_declared_lane(lane):
		return "a successful choice names lane %d, which is not a declared lane" % lane
	if new_build == null:
		return "a successful choice must carry the new run build"
	if new_ledger == null:
		return "a successful choice must carry the new consumption ledger"

	## THE SUPPORT CONTENT BELONGS TO ITS LANE (Foundation I8). A Support success
	## declares one of the two kinds; a passive success declares none. Asked
	## before the identity, because how many ids a lane owes depends on it.
	if lane == RiftOffer.Lane.SUPPORT:
		if support_content_kind != RiftOffer.SupportContentKind.SUPPORT_PROGRESSION \
				and support_content_kind != RiftOffer.SupportContentKind.PASSIVE_FALLBACK:
			return "the Support lane declares the unknown Support content kind %d" \
				% support_content_kind
	elif support_content_kind != RiftOffer.UNRESOLVED_SUPPORT_CONTENT_KIND:
		return "the %s lane declares Support content kind %d" % [
			RiftOffer.lane_label(lane), support_content_kind,
		]

	## THE SHAPE, ASKED OF THE CONTENT-AWARE READING. For every shape the
	## accepted constructor builds it answers exactly what the one-argument
	## reading answered, so this message and the cases that reach it are
	## unchanged; a Support fallback owes one card.
	var owed: int = identity_size_for_content(lane, support_content_kind)
	if _chosen_identity.size() != owed:
		return "the %s lane granted %d identifiers, not %d" % [
			RiftOffer.lane_label(lane), _chosen_identity.size(), owed,
		]
	for granted: String in _chosen_identity:
		if granted.strip_edges().is_empty():
			return "the %s lane granted an unnamed identifier" % RiftOffer.lane_label(lane)

	## THE CONSUMED PROGRESSION, AND IT IS A STABLE FACT RATHER THAN A READING OF
	## THE BUILD. Whether the frozen transition is a legal step is the offer
	## contract's rule and is asked THROUGH it, so there is one definition of that
	## rule in the project rather than one here and one there.
	##
	## WHAT IS DELIBERATELY *NOT* ASKED HERE ANY MORE (D-258): whether the build
	## this result carries still holds that pair at the rank the choice reached.
	## That comparison lives in `support_progression_build_problem()` below. See
	## this file's header for why it had to move.
	if lane == RiftOffer.Lane.SUPPORT \
			and support_content_kind == RiftOffer.SupportContentKind.PASSIVE_FALLBACK:
		## A CONSUMED FALLBACK CARRIES NO PROGRESSION AND ONE CATEGORY (Foundation
		## I8). The category must be one a passive lane draws from, read from the
		## one place the lane vocabulary meets the stat vocabulary.
		if support_progression_kind != RiftOffer.UNRESOLVED_PROGRESSION_KIND:
			return "the Support lane's passive fallback declares support progression kind %d" \
				% support_progression_kind
		if support_rank_before != NO_RANK or support_rank_after != NO_RANK:
			return "the Support lane's passive fallback exposes the support ranks %d -> %d" % [
				support_rank_before, support_rank_after,
			]
		if support_fallback_category != RiftOffer.category_for_lane(RiftOffer.Lane.COMBAT_DEFENCE) \
				and support_fallback_category != RiftOffer.category_for_lane(RiftOffer.Lane.UTILITY):
			return "the Support lane's passive fallback names category %d, which no passive lane draws from" \
				% support_fallback_category
	elif lane == RiftOffer.Lane.SUPPORT:
		var transition: String = RiftOffer.support_transition_problem(
			support_progression_kind, support_rank_before, support_rank_after)
		if not transition.is_empty():
			return "the support lane consumed an illegal progression: %s" % transition
		if support_fallback_category != NO_FALLBACK_CATEGORY:
			return "a Support progression names the fallback category %d" \
				% support_fallback_category
	else:
		## THE OTHER TWO LANES CARRY NO PROGRESSION, ASSERTED RATHER THAN ASSUMED.
		## A passive success that declared an operation would be describing
		## something that never happened, and nothing downstream reads a lane
		## before it reads a kind.
		if support_progression_kind != RiftOffer.UNRESOLVED_PROGRESSION_KIND:
			return "the %s lane declares support progression kind %d" % [
				RiftOffer.lane_label(lane), support_progression_kind,
			]
		if support_rank_before != NO_RANK or support_rank_after != NO_RANK:
			return "the %s lane exposes the support ranks %d -> %d" % [
				RiftOffer.lane_label(lane), support_rank_before, support_rank_after,
			]
		if support_fallback_category != NO_FALLBACK_CATEGORY:
			return "the %s lane names the fallback category %d" % [
				RiftOffer.lane_label(lane), support_fallback_category,
			]

	## THE ONE CROSS-CHECK NEITHER CONSTRUCTOR CAN MAKE. A success asserts that a
	## seed was spent; the ledger it carries is the only thing that can confirm
	## it, and asking is cheaper than a result that is well-formed and untrue.
	if not new_ledger.has_consumed(root_seed):
		return "the new ledger does not record root seed %d as consumed" % root_seed
	return ""


## Whether the build this result CURRENTLY carries still holds the offered pair at
## the rank this choice reached — a POINT-IN-TIME AUDIT, not a coherence rule.
##
## IT ANSWERS A QUESTION ABOUT NOW, WHICH IS EXACTLY WHY IT IS NOT IN `problem()`.
## A `RiftOfferChoiceResult` is a record of a transaction that already happened,
## and `new_build` is a LIVE object the caller was handed to go on using. Asking
## the two to agree forever means a caller who legitimately raises that same
## support again — the ordinary next step of a run — retroactively turns a
## historical, correct, already-committed result into an incoherent one. Nothing
## about the transaction changed; only the build moved on, which is what a build
## is for.
##
## SO THE OWNERSHIP LINE IS DRAWN BY LIFETIME RATHER THAN BY CONVENIENCE:
## `problem()` owns the facts that were TRUE AT COMMIT AND STAY TRUE — the lane,
## the seed, the identity, the frozen kind and its two ranks, the ledger's record
## of the spend, and the presence of both new values — and this owns the one fact
## that is allowed to stop being true.
##
## IT IS AN AUDIT AND NOT A SECOND GUARD, AND THE DIFFERENCE MATTERS. The
## transaction ITSELF still reads the staged rank back and refuses before spending
## the seed if it does not equal the offer's frozen after-rank, so a success can
## never be constructed against a build that did not reach it. This exists for a
## caller that wants to ask, later, whether the run it is holding still matches the
## choice it is looking at.
##
## Returns "" when there is nothing to compare — a passive success, any refusal,
## a result carrying no progression, and a purported success with no build at all,
## which `problem()` refuses in its own right rather than leaving to this. It reads
## and mutates nothing.
func support_progression_build_problem() -> String:
	if not carries_support_progression():
		return ""
	if new_build == null:
		return ""
	if _chosen_identity.size() != identity_size_for(RiftOffer.Lane.SUPPORT):
		return ""
	var skill_id: StringName = StringName(_chosen_identity[0])
	var support_id: StringName = StringName(_chosen_identity[1])
	var current: int = new_build.support_rank_for(skill_id, support_id)
	if current == support_rank_after:
		return ""
	return "%s -> %s was consumed at rank %d and the build now holds rank %d" % [
		skill_id, support_id, support_rank_after, current,
	]


# --- Presentation ---------------------------------------------------------------
#
# Deliberately separate from the fields and the re-derivation above, and reached
# by nothing in them except to quote a lane's name inside a message.

## What was granted, as one line. Ids only, never a presentation label: renaming
## anything must not change what a choice IS, and a line built out of names would
## be the first place that stopped being true.
func identity_line() -> String:
	if not ok:
		return "nothing granted"
	return " -> ".join(_chosen_identity)


## WHICH OPERATION THIS CHOICE CONSUMED AND THE RANK IT MOVED, in plain language.
##
## PRESENTATION ONLY, AND DELIBERATELY KEPT OUT OF `identity_line()` AND
## `describe()` — the same reading the offer record makes of its own progression
## line, and for the same reason: those two are what the accepted suites compare a
## result against, and a progression appearing inside them would change what those
## comparisons mean. The kind label is read from the accepted continuation record
## through the offer contract, so a decision, an offer and a choice can never name
## one operation three different ways — it is the SAME formatter the offer
## record's own progression line delegates to, reached directly here rather than
## copied, which is why this file names that vocabulary at all.
func support_progression_line() -> String:
	if not carries_support_progression():
		return "no support progression"
	return "%s, rank %d -> %d" % [
		SupportContinuationResult.kind_label(support_progression_kind),
		support_rank_before, support_rank_after,
	]


func describe() -> String:
	var seed_part: String = ("root seed %d" % root_seed) if root_seed_known else "no root seed"
	if not ok:
		return "no choice from %s — %s" % [seed_part, failure_reason]
	return "%s consumed; %s: %s" % [seed_part, RiftOffer.lane_label(lane), identity_line()]


## A reason a caller can act on, or a stated stand-in when a call site passed
## nothing. A refusal without a reason is a refusal nobody can report.
static func _stated(reason: String) -> String:
	return reason if not reason.strip_edges().is_empty() \
		else "the choice failed for an unstated reason"
