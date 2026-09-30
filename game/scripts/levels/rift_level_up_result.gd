class_name RiftLevelUpResult
extends RefCounted
## Riftwrought — Roguelite Foundation E2: the outcome of the ONE attempt to take
## one lane of the ONE offer a level-up coordinator ever opens.
##
## WHY THIS TYPE EXISTS AT ALL, GIVEN THAT EVERY ACCEPTED MUTATION RETURNS A
## PLAIN STRING. Two facts force it, and both are about what a caller cannot
## otherwise learn.
##
## THE FIRST IS THAT THE ACCEPTED CHOICE TRANSACTION'S OWN RESULT MUST NEVER
## LEAVE THE COORDINATOR. That result carries the two new values the transaction
## produced, and those are exactly the values the coordinator goes on to commit
## as its own — so handing it out would hand a caller a live reference to
## committed state it was only ever meant to read. Returning this instead is what
## makes "never expose partially committed state" a property of the type rather
## than a discipline the coordinator has to keep.
##
## THE SECOND IS THAT THE GRANTED IDENTITY IS UNRECOVERABLE AFTERWARDS. A
## successful choice ends the coordinator's one offer, so the lane identity a
## caller would want to report is no longer inspectable anywhere the moment it
## becomes true. A plain string would throw away the one piece of information the
## transaction produced that nothing else still holds.
##
## AND IT CARRIES STRICTLY LESS THAN THE TRANSACTION'S RESULT, WHICH IS THE
## WHOLE POINT. No run build, no consumption ledger, no experience track — each
## asserted absent by the suite rather than promised here. The shape of a lane's
## identity is not restated either: it is read from the one place that shape is
## written, so this type and the transaction it reports on cannot come to two
## different answers about how many identifiers a lane grants.
##
## IT DELIBERATELY CARRIES NO LEVEL AND NO EXPERIENCE, AND THAT IS AN APPLIED
## OWNER RULING RATHER THAN A PREFERENCE. Decision D-247 ruled that the level
## stays out of the experience track's own reading type, because duplicating it
## would create another value that could drift; the same reasoning reaches
## further here. The level and the accumulated experience belong to the track,
## are answered by the coordinator, and are not copied into the record of what
## one choice granted.
##
## AND IT CARRIES ITS ONE COLLECTION PRIVATELY, WHICH IS THE SHAPE BOTH RESULT
## TYPES NOW USE. A value type read out of an object is not necessarily a value:
## a `PackedStringArray` read from a script VARIABLE aliases rather than copying,
## so a public field of that type is one a caller can rewrite through a reference
## it was only given to read. E2 was built this way from the start; the accepted
## transaction's result was corrected to match under D-249, after this
## foundation's delivery measured the defect there.
##
## A REFUSAL ECHOES ONLY THE QUESTION AND CARRIES NO PARTIAL MEASUREMENT. The
## root seed and the requested lane are what the attempt WAS, not what it
## produced. `root_seed_known` exists because every integer is a legal seed:
## there is no value that could mean "no seed", so the absence is carried as its
## own fact rather than encoded in a stand-in a caller could mistake for a seed.
##
##
## A SUCCESSFUL SUPPORT LEVEL-UP CARRIES THE PROGRESSION IT CONSUMED
## (Foundation F5, decision D-260)
## ---------------------------------------------------------------------------
## For exactly the reason the granted identity is carried. Whether the Support
## choice took a NEW pair from absent to first rank or RAISED a held pair by one
## rank is part of what the level-up WAS, and the offer that froze it is released
## the moment the choice commits — so a caller that did not receive it here could
## only re-derive it from the build, which by then has already moved. Three
## public scalars say it: the progression kind and the two ranks it moved between.
## They are NOT part of the identity, which is still exactly the Skill id then
## the support id, because an identity is WHAT was granted and a progression is
## WHICH OPERATION was performed on it.
##
## THEY ARE COPIED, NEVER RE-DERIVED, AND THE CONSTRUCTOR IS WHAT MAKES THAT
## STRUCTURAL. `taken()` accepts the successful choice result WHOLE and copies
## the seed, the lane, the identity and the progression out of that one object,
## so there is no call site at which an identity from one outcome could be paired
## with a progression from another, and nothing here consults whether the pair is
## held, what rank the build now reports, how long the identity is or what a
## lane is called. The choice result itself is not kept: it carries the mutable
## run build and ledger the coordinator adopts, and those must never reach a
## caller through the receipt of the choice that produced them.
##
## PASSIVE LEVEL-UPS AND EVERY REFUSAL CARRY NO PROGRESSION AT ALL, spelled with
## the accepted conventions rather than a third invented one: the unresolved
## kind is the offer contract's own, and the two ranks rest at the choice
## result's own no-rank value — whose presence is decided by the KIND, which is
## what `carries_support_progression()` reads, exactly as it does there.
##
## THE TRANSITION IS VALIDATED THROUGH THE ONE SHARED RULE. `problem()` asks the
## offer contract's `support_transition_problem()` whether the frozen step is
## legal and restates no step of it, which is the arrangement the offer and the
## choice result already share. And because this receipt deliberately carries no
## build, there is nothing to audit it against: its progression is a frozen fact
## about a choice that has already happened, and it stays true however the run
## moves on afterwards.
##
## IT IS INERT. No node, no signal, no clock, no random source, no file, no
## schema. It describes a transaction that has already happened and performs none
## of its own.
##
##
## IT CAN BE COPIED, AND A COPY IS THE ONLY THING ANOTHER RECORD MAY KEEP
## (Foundation G4, decision D-269)
## ---------------------------------------------------------------------------
## The run-level record of a level-up carries one of these inside it. It must keep
## a receipt nobody else holds and hand out a receipt it does not keep, or a
## caller holding either could rewrite the other. `duplicated()` is that copy,
## written once, here, beside the fields it copies — so the rule for what a copy
## of this receipt is lives with the receipt rather than in every place that
## keeps one. It adds no field, re-derives nothing and judges nothing.
##
##
## A SUCCESSFUL SUPPORT LEVEL-UP SAYS WHICH KIND OF CONTENT IT CONSUMED
## (Roguelite Foundation I9, decision D-310)
## ---------------------------------------------------------------------------
## Since Foundation I8 a Support choice consumes one of two kinds of content: a
## support progression or, when progression is honestly used up, the one passive
## card the accepted fallback chose. The choice result states which in two stable
## scalars, and this receipt now carries the same two — `support_content_kind` and
## `support_fallback_category` — appended after every accepted field, so each of
## those keeps its place. Without them a consumed fallback reached this receipt as
## a Support success granting one id, which the identity rule below correctly
## called incoherent, and nothing here could say what had actually been taken.
##
## THEY ARE COPIED BY `taken()` OUT OF THE SAME ONE SUCCESSFUL CHOICE RESULT THE
## SEED, THE LANE, THE IDENTITY AND THE PROGRESSION ARE COPIED OUT OF, so no call
## site can pair the identity of one choice with the content of another. The kind
## is never inferred from the identity's length, from which fields are empty, or
## from any text: it is whatever the choice result declared.
##
## FOUR SUCCESS SHAPES ARE COHERENT, AND `problem()` REJECTS EVERY MIXTURE OF THEM:
##
##   Support progression     two ids, a legal progression, no fallback category
##   Support fallback        one card id, no progression, a passive category
##   ordinary passive lane   one card id, no progression, no Support content
##
## and a refusal carries none of it: no identity, no Support content kind, no
## progression and no fallback category. They are the choice result's own four
## shapes, written with its own sentinels rather than a third spelling of "none".
##
## A FALLBACK RECEIPT KEEPS EXACTLY ONE FACT OF THE FALLBACK. The card is already
## the one-element granted identity, so its id is not stored a second time; the
## category is the one thing the identity cannot say. No choice result, no offer,
## no fallback derivation, no build, ledger or track, and no name, stat, amount or
## weight is stored here.
##
## HOW MANY IDENTIFIERS A SUCCESS OWES IS NOW ASKED OF THE CONTENT-AWARE READING
## THE CHOICE RESULT OWNS, `identity_size_for_content()`. For every shape this
## receipt accepted before, that reading answers exactly what the one-argument
## reading answered, so no accepted receipt's verdict moved; a Support fallback
## owes one card.
##
## NEITHER COORDINATOR MOVED FOR THIS. The one-level coordinator already hands the
## whole successful choice result to `taken()`, and the run-level record already
## keeps and hands out copies made by `duplicated()`; extending the receipt and its
## copy is what makes both coherent for a fallback, and there is still exactly one
## way to build a successful receipt.

var ok: bool = false

## Empty exactly when `ok`. Otherwise the single plain-language reason, quoted
## verbatim from whichever accepted mechanism refused.
var failure_reason: String = ""

## The root seed the attempt was made against — spent on a success, merely
## echoed on a refusal. Meaningful only when `root_seed_known`.
var root_seed: int = 0

## Whether `root_seed` above says anything at all. False only when the attempt
## found no open offer to read a seed from.
var root_seed_known: bool = false

## The lane, as a `RiftOffer.Lane` member on a success and as whatever was
## requested on a refusal — which may be a value outside the declared set,
## because that is one of the things a refusal exists to report.
var lane: int = RiftOffer.UNRESOLVED_LANE

## WHICH PROGRESSION OPERATION THE SUPPORT CHOICE CONSUMED, as the accepted
## continuation vocabulary's kind member, and the two ranks it moved the pair
## between — COPIED from the successful choice result and never measured again
## here.
##
## MEANINGFUL ONLY ON A SUCCESSFUL SUPPORT LEVEL-UP. On a passive success and on
## every refusal the kind is the offer contract's own unresolved value and both
## ranks sit at the choice result's own no-rank value; `problem()` requires
## exactly that shape in both directions.
##
## PUBLIC SCALARS FOR THE REASON THE FIELDS ABOVE ARE: an int read out of an
## object cannot reach the object.
var support_progression_kind: int = RiftOffer.UNRESOLVED_PROGRESSION_KIND

var support_rank_before: int = RiftOfferChoiceResult.NO_RANK

var support_rank_after: int = RiftOfferChoiceResult.NO_RANK

## The mechanical identifiers the taken lane granted, in the offer's own order.
## Empty on every refusal.
##
## PRIVATE, AND READ THROUGH AN ACCESSOR THAT DUPLICATES, BECAUSE THE OBVIOUS
## ARRANGEMENT IS MEASURABLY UNSAFE. A `PackedStringArray` is widely believed to
## be copied on assignment in GDScript; it is not, when the source is a script
## VARIABLE. Reading such a field into a typed local and appending to it mutates
## the array inside the object — measured in this foundation's suite on a
## purpose-built probe, in both directions — so a public field of this type is a
## value a caller can rewrite through a reference it was only given to read, and
## a result whose identity list has grown is one its own `problem()` then reports
## as incoherent. That measurement is what D-249 corrected in the accepted
## transaction's own result type.
##
## THE SCALARS ABOVE STAY PUBLIC FIELDS FOR THE SAME REASON THIS ONE DOES NOT: a
## bool, an int or a String read out of an object cannot reach anything. The
## asymmetry is the measurement rather than a preference.
var _granted_identity: PackedStringArray = PackedStringArray()

## WHICH KIND OF CONTENT A SUCCESSFUL SUPPORT LEVEL-UP CONSUMED (Foundation I9,
## D-310): the offer contract's `SupportContentKind.SUPPORT_PROGRESSION` or
## `.PASSIVE_FALLBACK`, COPIED from the successful choice result. An ordinary
## passive level-up and every refusal read the offer contract's own unresolved
## value, so there is one spelling of "no Support content" in the project.
##
## PUBLIC SCALARS FOR THE REASON THE OTHERS ARE: an int read out of an object
## cannot reach the object.
var support_content_kind: int = RiftOffer.UNRESOLVED_SUPPORT_CONTENT_KIND

## WHICH PASSIVE CATEGORY A CONSUMED FALLBACK DREW FROM, as the canonical category
## integer the choice result carries, copied from it. The choice result's own
## `NO_FALLBACK_CATEGORY` on every other receipt.
var support_fallback_category: int = RiftOfferChoiceResult.NO_FALLBACK_CATEGORY


## A refusal made before an open offer was available to read a seed from.
## Separate from `refused()` rather than folded into it behind a flag, so a call
## site cannot claim a seed it never saw.
static func refused_without_a_seed(reason: String, requested_lane: int) -> RiftLevelUpResult:
	var result: RiftLevelUpResult = RiftLevelUpResult.new()
	result.ok = false
	result.failure_reason = _stated(reason)
	result.root_seed_known = false
	result.lane = requested_lane
	return result


## A refusal that can name the seed the attempt was made against. It sets the
## question and NOTHING else, so no granted identity can be read out of a choice
## that did not happen.
static func refused(
	reason: String, for_root_seed: int, requested_lane: int
) -> RiftLevelUpResult:
	var result: RiftLevelUpResult = RiftLevelUpResult.new()
	result.ok = false
	result.failure_reason = _stated(reason)
	result.root_seed = for_root_seed
	result.root_seed_known = true
	result.lane = requested_lane
	return result


## The only way to build a success, and it takes the SUCCESSFUL CHOICE RESULT
## WHOLE rather than its parts.
##
## ONE ARGUMENT, ON PURPOSE (Foundation F5, decision D-260). It used to take the
## seed, the lane and the identity separately, which was safe while those were
## all a success carried. With a progression beside them, separate arguments would
## let a call site pair the identity of one outcome with the progression of
## another; reading every stable fact out of ONE object makes that arrangement
## unwritable rather than merely unlikely. What is copied is exactly the stable
## receipt: the seed and whether it is known, the lane, an independent copy of
## the identity — the accepted accessor duplicates, so nothing here aliases the
## choice result's own array — and the three progression scalars. The choice
## result's run build and ledger are never read and the object is not kept.
##
## AND, SINCE FOUNDATION I9 (D-310), THE TWO SUPPORT-CONTENT SCALARS, out of the
## same object and for the same reason: which kind of content a Support choice
## consumed, and a fallback's category. Still one argument, still no build.
##
## IT CANNOT BUILD A SUCCESS OUT OF SOMETHING THAT WAS NOT ONE. A null or refused
## choice result yields a refusal naming no seed and no lane, because a receipt
## claiming a level-up for a choice that did not happen would be a well-formed
## lie. The coordinator never hands it one — it quotes a refused choice through
## `refused()` first — so this is the constructor's own contract, and the
## verification drives it directly.
static func taken(from_choice: RiftOfferChoiceResult) -> RiftLevelUpResult:
	if from_choice == null or not from_choice.ok:
		return refused_without_a_seed(
			"a level-up can only be taken from a successful choice",
			RiftOffer.UNRESOLVED_LANE)
	var result: RiftLevelUpResult = RiftLevelUpResult.new()
	result.ok = true
	result.failure_reason = ""
	result.root_seed = from_choice.root_seed
	result.root_seed_known = from_choice.root_seed_known
	result.lane = from_choice.lane
	result._granted_identity = from_choice.chosen_identity()
	result.support_progression_kind = from_choice.support_progression_kind
	result.support_rank_before = from_choice.support_rank_before
	result.support_rank_after = from_choice.support_rank_after
	result.support_content_kind = from_choice.support_content_kind
	result.support_fallback_category = from_choice.support_fallback_category
	return result


## The identifiers the taken lane granted, as an INDEPENDENT COPY. Empty on
## every refusal. Appending to what this answers cannot change what the next call
## answers, which is the whole reason it is a method rather than a field.
func granted_identity() -> PackedStringArray:
	return _granted_identity.duplicate()


## Whether this receipt carries a consumed Support progression, which is the ONE
## authority on whether the two rank fields say anything at all.
##
## IT READS THE KIND RATHER THAN THE LANE, exactly as the choice result's own
## reading does and for the same reason: a Support success whose kind was never
## set is precisely the incoherent shape `problem()` catches, and a flag derived
## from the lane would report it as healthy.
func carries_support_progression() -> bool:
	return ok and support_progression_kind != RiftOffer.UNRESOLVED_PROGRESSION_KIND


## Whether this receipt records a consumed Support passive fallback (Foundation
## I9, D-310) — the one authority on whether `support_fallback_category` says
## anything at all. It reads the stored content kind rather than the lane or the
## identity's length, for the reason the reading above reads the kind: a flag
## derived from anything else would report an incoherent receipt as healthy.
func carries_support_fallback() -> bool:
	return ok and support_content_kind == RiftOffer.SupportContentKind.PASSIVE_FALLBACK


## Returns "" when this result is internally coherent, or the FIRST
## contradiction found, in plain language. The fields above are a report, and a
## report that is never re-checked is one that can quietly stop describing what
## happened.
##
## EVERY FACT IT CHECKS IS ONE THAT STAYS TRUE. This receipt holds no build, so
## there is no point-in-time comparison to separate out of it: the progression is
## a frozen record of the choice, checked for its shape and nothing else.
func problem() -> String:
	if not ok:
		if failure_reason.strip_edges().is_empty():
			return "a refused level-up must state a reason"
		if not _granted_identity.is_empty():
			return "a refused level-up must expose no granted identity"
		## A REFUSAL EXPOSES NO PROGRESSION EITHER. Which operation would have been
		## taken, and the ranks it would have moved between, are answers as much
		## as a granted id is — and a level-up that did not happen has none.
		if support_progression_kind != RiftOffer.UNRESOLVED_PROGRESSION_KIND:
			return "a refused level-up must declare no support progression kind, not %d" \
				% support_progression_kind
		if support_rank_before != RiftOfferChoiceResult.NO_RANK \
				or support_rank_after != RiftOfferChoiceResult.NO_RANK:
			return "a refused level-up must expose no support rank, not %d -> %d" % [
				support_rank_before, support_rank_after,
			]
		## AND NO SUPPORT CONTENT (Foundation I9). Which kind the Support lane
		## would have consumed, and a fallback's category, are answers as much as
		## a granted id is.
		if support_content_kind != RiftOffer.UNRESOLVED_SUPPORT_CONTENT_KIND:
			return "a refused level-up must declare no Support content kind, not %d" \
				% support_content_kind
		if support_fallback_category != RiftOfferChoiceResult.NO_FALLBACK_CATEGORY:
			return "a refused level-up must name no fallback category, not %d" \
				% support_fallback_category
		return ""

	if not failure_reason.is_empty():
		return "a successful level-up must state no failure reason"
	if not root_seed_known:
		return "a successful level-up must name the root seed it consumed"
	if not RiftOffer.is_declared_lane(lane):
		return "a successful level-up names lane %d, which is not a declared lane" % lane

	## THE SUPPORT CONTENT BELONGS TO ITS LANE (Foundation I9). A Support success
	## declares one of the two kinds; a passive success declares none. Asked before
	## the identity, because how many ids a lane owes depends on it.
	if lane == RiftOffer.Lane.SUPPORT:
		if support_content_kind != RiftOffer.SupportContentKind.SUPPORT_PROGRESSION \
				and support_content_kind != RiftOffer.SupportContentKind.PASSIVE_FALLBACK:
			return "the Support level-up declares the unknown Support content kind %d" \
				% support_content_kind
	elif support_content_kind != RiftOffer.UNRESOLVED_SUPPORT_CONTENT_KIND:
		return "the %s lane declares Support content kind %d" % [
			RiftOffer.lane_label(lane), support_content_kind,
		]

	## THE SHAPE IS READ, NEVER RESTATED. How many identifiers a lane grants is
	## written in exactly one place in the project, and asking it here is what
	## keeps this type from becoming a second opinion about it. Since Foundation
	## I9 it is asked of the CONTENT-AWARE reading, which for every shape accepted
	## before answers exactly what the one-argument reading answered — so this
	## message and the receipts that reach it are unchanged — and owes a Support
	## fallback one card. Both one-versus-two mistakes fail this one comparison.
	var owed: int = RiftOfferChoiceResult.identity_size_for_content(lane, support_content_kind)
	if _granted_identity.size() != owed:
		return "the %s lane granted %d identifiers, not %d" % [
			RiftOffer.lane_label(lane), _granted_identity.size(), owed,
		]
	for granted: String in _granted_identity:
		if granted.strip_edges().is_empty():
			return "the %s lane granted an unnamed identifier" % RiftOffer.lane_label(lane)

	if lane == RiftOffer.Lane.SUPPORT \
			and support_content_kind == RiftOffer.SupportContentKind.PASSIVE_FALLBACK:
		## A CONSUMED FALLBACK CARRIES NO PROGRESSION AND ONE CATEGORY (Foundation
		## I9). The category must be one a passive lane draws from, read from the
		## one place the lane vocabulary meets the stat vocabulary — exactly the
		## question the choice result asks of its own.
		if support_progression_kind != RiftOffer.UNRESOLVED_PROGRESSION_KIND:
			return "the Support level-up's passive fallback declares support progression kind %d" \
				% support_progression_kind
		if support_rank_before != RiftOfferChoiceResult.NO_RANK \
				or support_rank_after != RiftOfferChoiceResult.NO_RANK:
			return "the Support level-up's passive fallback exposes the support ranks %d -> %d" % [
				support_rank_before, support_rank_after,
			]
		if support_fallback_category != RiftOffer.category_for_lane(RiftOffer.Lane.COMBAT_DEFENCE) \
				and support_fallback_category != RiftOffer.category_for_lane(RiftOffer.Lane.UTILITY):
			return "the Support level-up's passive fallback names category %d, which no passive lane draws from" \
				% support_fallback_category
	elif lane == RiftOffer.Lane.SUPPORT:
		## THE CONSUMED PROGRESSION, CHECKED THROUGH THE ONE SHARED RULE. Whether the
		## frozen step is legal is the offer contract's question and is asked THROUGH
		## it, so the offer that froze this step, the choice result that consumed it
		## and this receipt of it all answer from one definition. A Support success
		## whose kind is unresolved is refused by that same rule, which is why an
		## unset progression cannot pass here as "nothing to check".
		var transition: String = RiftOffer.support_transition_problem(
			support_progression_kind, support_rank_before, support_rank_after)
		if not transition.is_empty():
			return "the Support level-up granted an illegal progression: %s" % transition
		if support_fallback_category != RiftOfferChoiceResult.NO_FALLBACK_CATEGORY:
			return "a Support progression names the fallback category %d" \
				% support_fallback_category
	else:
		## THE TWO PASSIVE LANES CARRY NO PROGRESSION, ASSERTED RATHER THAN ASSUMED.
		if support_progression_kind != RiftOffer.UNRESOLVED_PROGRESSION_KIND:
			return "the %s lane declares support progression kind %d" % [
				RiftOffer.lane_label(lane), support_progression_kind,
			]
		if support_rank_before != RiftOfferChoiceResult.NO_RANK \
				or support_rank_after != RiftOfferChoiceResult.NO_RANK:
			return "the %s lane exposes the support ranks %d -> %d" % [
				RiftOffer.lane_label(lane), support_rank_before, support_rank_after,
			]
		## AND NO FALLBACK CATEGORY (Foundation I9): only a consumed fallback has one.
		if support_fallback_category != RiftOfferChoiceResult.NO_FALLBACK_CATEGORY:
			return "the %s lane names the fallback category %d" % [
				RiftOffer.lane_label(lane), support_fallback_category,
			]
	return ""


# --- The whole value ------------------------------------------------------------

## AN INDEPENDENT COPY OF THIS RECEIPT, field for field (Foundation G4, decision
## D-269). Nothing either one answers afterwards can move the other.
##
## THE PUBLIC SCALARS ARE ASSIGNED AND THE ONE PRIVATE ARRAY IS DUPLICATED, AND
## THE DIFFERENCE IS THE SAME MEASUREMENT THAT MADE THE ARRAY PRIVATE. A bool, an
## int or a String read out of an object cannot reach the object, so assigning
## each is a copy. A packed array read out of a script variable aliases, so
## assigning `_granted_identity` would hand the copy the original's own array —
## which is why it is duplicated here rather than assigned. There were eight
## scalars; Foundation I9 (D-310) appended the two Support-content scalars, and
## they are assigned here exactly as the others are.
##
## IT COPIES WHAT IS THERE AND DECIDES NOTHING. It builds no success out of a
## refusal, checks no coherence and restates no shape: a copy of an incoherent
## receipt is the same incoherent receipt, and `problem()` says so of either.
func duplicated() -> RiftLevelUpResult:
	var copy: RiftLevelUpResult = RiftLevelUpResult.new()
	copy.ok = ok
	copy.failure_reason = failure_reason
	copy.root_seed = root_seed
	copy.root_seed_known = root_seed_known
	copy.lane = lane
	copy.support_progression_kind = support_progression_kind
	copy.support_rank_before = support_rank_before
	copy.support_rank_after = support_rank_after
	copy._granted_identity = _granted_identity.duplicate()
	copy.support_content_kind = support_content_kind
	copy.support_fallback_category = support_fallback_category
	return copy


# --- Presentation ---------------------------------------------------------------
#
# Deliberately separate from the fields and the re-derivation above, and reached
# by nothing in them except to quote a lane's name inside a message.

## What was granted, as one line. Ids only, never a presentation label: renaming
## anything must not change what a level-up WAS.
func identity_line() -> String:
	if not ok:
		return "nothing granted"
	return " -> ".join(_granted_identity)


## WHICH OPERATION THE SUPPORT CHOICE CONSUMED AND THE RANK IT MOVED, in plain
## language, for diagnostics.
##
## A SEPARATELY NAMED READING, AND DELIBERATELY KEPT OUT OF `identity_line()` AND
## `describe()`: both are accepted diagnostic strings, and a progression appearing
## inside them would change what they say about every level-up already taken. The
## kind label is the accepted continuation record's own formatter, reached
## directly — the one the offer's and the choice result's own progression lines
## use — so a decision, an offer, a choice and its level-up can never name one
## operation four different ways. That is the whole reason this file names that
## vocabulary.
func support_progression_line() -> String:
	if not carries_support_progression():
		return "no support progression"
	return "%s, rank %d -> %d" % [
		SupportContinuationResult.kind_label(support_progression_kind),
		support_rank_before, support_rank_after,
	]


## WHICH PASSIVE CARD A SUPPORT LEVEL-UP TOOK INSTEAD, AND FROM WHICH CATEGORY, in
## plain language, for diagnostics (Foundation I9, D-310).
##
## A SEPARATELY NAMED READING, KEPT OUT OF `identity_line()`, `describe()` AND
## `support_progression_line()` for the reason the progression line is kept out of
## the first two: each is an accepted diagnostic string, and a fallback appearing
## inside one would change what it says about every level-up already taken. The
## category's name is the passive lane's own label, reached through the one place
## the lane vocabulary meets the stat vocabulary, so a lane and the category it
## draws from are never named two ways. Nothing reads it back, and nothing that
## runs displays it.
func support_fallback_line() -> String:
	if not carries_support_fallback():
		return "no passive fallback"
	var drawn_from: String = "unrecognised category %d" % support_fallback_category
	for passive_lane: int in [RiftOffer.Lane.COMBAT_DEFENCE, RiftOffer.Lane.UTILITY]:
		if RiftOffer.category_for_lane(passive_lane) == support_fallback_category:
			drawn_from = RiftOffer.lane_label(passive_lane)
	return "passive fallback: %s, drawn from %s" % [identity_line(), drawn_from]


func describe() -> String:
	var seed_part: String = ("root seed %d" % root_seed) if root_seed_known else "no root seed"
	if not ok:
		return "no level-up from %s — %s" % [seed_part, failure_reason]
	return "%s spent; %s: %s" % [seed_part, RiftOffer.lane_label(lane), identity_line()]


## A reason a caller can act on, or a stated stand-in when a call site passed
## nothing. A refusal without a reason is a refusal nobody can report.
static func _stated(reason: String) -> String:
	return reason if not reason.strip_edges().is_empty() \
		else "the level-up failed for an unstated reason"
