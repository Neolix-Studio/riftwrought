class_name RiftOfferChoice
extends RefCounted
## Riftwrought — Roguelite Foundation D3: taking exactly ONE lane of exactly ONE
## Rift offer, once, as a pure transaction over pure values.
##
## IT TAKES A CHOICE THAT HAS ALREADY BEEN MADE AND RECORDS IT. It displays no
## offer, receives no input, composes nothing, resolves no ticket, applies
## nothing to any actor or base value, grants no experience and generates no
## second offer. It is handed one coherent offer, one lane, the run build so far
## and the record of which offers this run has already spent, and it answers with
## the two values that follow — or with a reason and nothing else.
##
## THE TRANSACTION IS PURE, AND THAT IS THE WHOLE SHAPE OF THE FILE. Both
## supplied values are DUPLICATED before anything is staged, every mutation
## happens on the duplicates, and the originals are never reachable from any
## statement below. A caller therefore keeps exactly what it handed in whether
## the choice succeeded or failed, and a failure cannot leave a half-applied
## build behind because the object a failure would have half-applied is
## discarded rather than returned.
##
## THE SEED IS COMMITTED LAST, AND THE ORDER IS THE LOAD-BEARING PART. The
## consumption is recorded only after the build mutation has returned success. A
## consumption committed first would spend an offer that granted nothing — the
## exact shape of an offer that vanishes without paying — and it is reachable:
## a stale support pair and a passive whose canonical record contradicts what
## this run already holds are both refused after the offer has been fully
## validated. The verification drives both, and the commit order is proved by
## measuring that a refused attempt leaves the ledger's count where it was.
##
## THE COMPLETE ROOT SEED IS THE CONSUMPTION IDENTITY, NEVER ITS DERIVED FORM.
## The composition mechanism draws its three lane streams from the low 32 bits of
## the root seed, so two different full seeds can pose one composition question.
## They are still two offers, and this file consults the ledger with the whole
## signed integer, which is why they stay independently spendable. The converse
## matters just as much and is easier to get wrong: two seeds that happened to
## compose the same Skill, support and cards are also two offers, and nothing
## here compares what an offer CONTAINS in order to decide whether it may be
## taken.
##
## THE STABLE CARD ID IS THE CHOICE AUTHORITY AND THE CANONICAL RECORD IS THE
## EFFECT. A passive lane offers an id; this file resolves that id through the
## canonical catalogue and acquires THAT record, not the one the offer was
## composed from. So a presentation label cannot change a transaction, and an
## offer composed against a record set that disagrees with the catalogue cannot
## smuggle a different magnitude in behind a familiar id. Applying the currently
## registered record is the accepted reading for a temporary, non-persisted run
## mechanism: there is no saved run to migrate, so there is no version to
## reconcile, and effect-version migration is deferred until persistence exists
## and is authorized.
##
## IT RE-DERIVES NOTHING IT WAS GIVEN. Support compatibility belongs to the
## accepted rule the composition already applied; the pair rule, the card
## fingerprint rule, the repeat rule and the whole of the additive arithmetic
## belong to the accepted run-build state. This file asks those questions of the
## objects that own them and reports their answers verbatim. The one thing it
## adds is the question none of them can answer: whether this particular offer
## has already been spent.
##
##
## THE SUPPORT LANE CONSUMES A FROZEN PROGRESSION, NOT MERELY A PAIR (Foundation
## F4, decision D-257)
## ---------------------------------------------------------------------------
## Since Foundation F3 the support lane of an offer carries the MECHANICAL
## OPERATION it was composed to offer — acquire a compatible pair that is not
## held, or raise one that is — together with the exact rank the pair held when
## the offer was composed and the exact rank it would hold afterwards. This
## transaction now consumes that, and the offer is the authority on all four
## facts: the Skill, the support, the operation and the two ranks.
##
## THE PRECONDITION IS AN EQUALITY, NOT A REBASE, AND THAT IS THE LOAD-BEARING
## SENTENCE. Before anything is staged the run's CURRENT rank for that exact pair
## is compared with the rank the offer FROZE. If the two differ the whole
## transaction is refused as a stale support offer, naming the pair, the rank the
## offer was composed against and the rank the run now holds — and no seed is
## spent, no build state moves and no identity or progression is exposed. An old
## offer is never quietly re-pointed at whatever the current rank happens to be:
## a rank the player was never shown is a reward nobody offered, and silently
## granting one is exactly the failure the frozen ranks exist to make impossible.
## It refuses in BOTH directions — a run that has since moved ahead of the offer
## and a run that is somehow behind it are the same disagreement.
##
## THE OPERATION IS READ, NEVER INFERRED. Whether this is a first acquisition or
## a further rank is decided by the offer's own progression kind, and the two
## kinds route to the two SEPARATE accepted operations on the run build. Deciding
## it here from whether the pair happens to be held would be a second, subtly
## different copy of the accepted continuation policy — and it would be wrong the
## first time a run held a pair that an old new-pair offer still named, which is
## precisely the case the precondition above is for.
##
## AND THE RESULT IS VERIFIED BEFORE THE SEED IS SPENT. After the staged mutation
## returns success the pair's rank is READ BACK OUT OF THE STAGED BUILD and
## required to equal the rank the offer froze. Only then is the consumption
## staged and committed. A mutation that succeeded while landing somewhere other
## than where the offer promised is refused atomically, with the staged build
## discarded exactly as every other refusal discards it — because an offer that
## pays something other than what it said is worse than one that pays nothing.
##
## IT APPLIES NO SUPPORT EFFECT AND KNOWS OF NONE. A rank RECORDS PROGRESSION
## here exactly as it does in the accepted ranked-ownership state: there is no
## per-rank value, no magnitude, no ceiling and no refund anywhere in this file
## or behind it.
##
## THE VALIDATION ORDER IS THE CONTRACT. An offer must exist, must have composed,
## must be internally coherent, and must carry the lane being asked for, before
## the current values are required and before the ledger is consulted — and every
## one of those happens before a single duplicate is made. A refusal from any of
## them is indistinguishable from never having called this function at all.
##
##
## THE SUPPORT LANE MAY CARRY A PASSIVE FALLBACK, AND IT IS TAKEN AS ONE PASSIVE
## CARD (Roguelite Foundation I8, decision D-308)
## ---------------------------------------------------------------------------
## Since Foundation I7 an offer whose support progression is honestly used up
## carries, in its Support lane, the one passive card the accepted
## exhausted-support fallback chose. This transaction now takes it. It routes on
## the offer's STORED Support content kind — never on the identity's length and
## never on which fields are empty — so a support-progression lane is taken by
## exactly the F4 staging above, unchanged, and a passive-fallback lane by its
## own staging, which is one passive-card acquisition and nothing else.
##
## THE FALLBACK STAGING IS TEN STEPS AND THE ORDER IS THE CONTRACT. The identity
## must be exactly one card id. The carried fallback result must be present,
## successful and coherent. The offer's fallback card, the fallback's own
## selection and the identity must be one card. The category is READ from the
## fallback result, never inferred from the lane. The card is resolved through
## the canonical catalogue, which must hold a valid record for it in exactly that
## category. The build's acquisition count for the card is read; the canonical
## record is acquired through the accepted run-build operation; the count is read
## again and must have moved by exactly one; and no support pair and no support
## rank may have moved. Only then may the seed be spent, exactly as for every
## other lane.
##
## MOST OF THOSE GATES ARE DEFENCE IN DEPTH, AND THAT IS STATED RATHER THAN LEFT
## TO BE ASSUMED. The offer is required internally coherent before anything is
## staged, and a coherent offer already guarantees the one-card identity, a
## coherent successful fallback and the three-way agreement, so no supplied offer
## reaches those three gates; and the accepted run build already guarantees that a
## passive acquisition it accepted moved its count by one and touched no pair, so
## no supplied build reaches the last two. The canonical-record gates ARE
## reachable — an offer composed from a record set that disagrees with the
## catalogue arrives perfectly coherent — and so is the run build's own refusal.
## Every refusal is atomic by the same construction as every other: the build is
## a duplicate the caller cannot reach, and nothing here can touch the ledger.
##
## AN ALREADY-HELD REPEATABLE CARD IS TAKEN AGAIN. The run build owns the repeat
## rule and the card fingerprint rule; its refusal is returned verbatim and spends
## nothing.
##
## IT CARRIES NOTHING FURTHER. The result records that a fallback was consumed and
## which category it drew from; carrying that anywhere beyond this transaction is
## a later, separate authorization.
##
## IT IS INERT. No node, no signal, no clock, no random source, no file, no
## schema. Nothing that runs calls it.

## The entry point, and the whole mechanism.
##
## `offer` must be one successful, coherent offer; `lane` one of the three lanes
## that offer carries; `build` and `ledger` the run's current values. Neither
## supplied value is modified on success or on failure.
static func choose(
	offer: RiftOffer,
	lane: int,
	build: RiftRunBuild,
	ledger: RiftConsumptionLedger
) -> RiftOfferChoiceResult:
	# --- Validation, complete, before anything at all is staged --------------
	if offer == null:
		return RiftOfferChoiceResult.refused_without_a_seed(
			"a choice must carry an offer", lane)
	if not offer.ok:
		## A default-constructed offer reaches here with no reason at all, and a
		## refusal that quotes an empty string is a refusal nobody can act on.
		var stated: String = offer.failure_reason if not offer.failure_reason.strip_edges().is_empty() \
			else "no reason stated"
		return RiftOfferChoiceResult.refused(
			"the offer did not compose: %s" % stated, offer.root_seed, lane)
	var incoherent: String = offer.problem()
	if not incoherent.is_empty():
		return RiftOfferChoiceResult.refused(
			"the offer is not internally coherent: %s" % incoherent, offer.root_seed, lane)

	## ONE TEST FOR "DECLARED" AND "CARRIED" TOGETHER, AND IT IS REACHABLE
	## RATHER THAN DEFENSIVE. A coherent offer carries exactly the three declared
	## lanes in the fixed order — that is what the check above has just required
	## — so asking whether this offer carries the lane is the same question as
	## asking whether the lane exists, and a single test cannot answer the two
	## halves differently.
	if not offer.lane_order().has(lane):
		return RiftOfferChoiceResult.refused(
			"lane %d is not one of the offer's lanes (%s)" % [lane, offer.seed_line()],
			offer.root_seed, lane)

	if build == null:
		return RiftOfferChoiceResult.refused(
			"a choice must carry the current run build", offer.root_seed, lane)
	if ledger == null:
		return RiftOfferChoiceResult.refused(
			"a choice must carry the consumption ledger", offer.root_seed, lane)
	if ledger.has_consumed(offer.root_seed):
		return RiftOfferChoiceResult.refused(
			"root seed %d has already been consumed by this run" % offer.root_seed,
			offer.root_seed, lane)

	# --- Staged on duplicates; the originals are unreachable from here -------
	var staged_build: RiftRunBuild = build.duplicated()
	var staged_ledger: RiftConsumptionLedger = ledger.duplicated()
	var identity: PackedStringArray = offer.identity_for(lane)

	var refusal: String = _stage(staged_build, offer, lane, identity)
	if not refusal.is_empty():
		return RiftOfferChoiceResult.refused(refusal, offer.root_seed, lane)

	## THE COMMIT, AND ONLY NOW. `consume()` cannot refuse here — the ledger was
	## asked the same question above and nothing between the two statements can
	## have recorded anything — so this branch is defence in depth rather than a
	## reachable hole, and it is written as a refusal rather than as an assert
	## because an assert is stripped from a release build and would leave a
	## silently unspent seed behind.
	if not staged_ledger.consume(offer.root_seed):
		return RiftOfferChoiceResult.refused(
			"root seed %d could not be recorded as consumed" % offer.root_seed,
			offer.root_seed, lane)

	## A PASSIVE-FALLBACK SUPPORT LANE HAS ITS OWN SUCCESS SHAPE (Foundation I8).
	## The category is read from the carried fallback result — the same object the
	## staging has just validated — and never from the lane.
	if lane == RiftOffer.Lane.SUPPORT \
			and offer.support_content_kind == RiftOffer.SupportContentKind.PASSIVE_FALLBACK:
		return RiftOfferChoiceResult.chosen_support_fallback(
			offer.root_seed, identity, offer.support_fallback.selected_category,
			staged_build, staged_ledger)

	## THE CONSUMED PROGRESSION IS THE OFFER'S OWN, AND ONLY A SUPPORT-PROGRESSION
	## LANE HAS ONE — the passive-fallback lane returned above. The two passive
	## lanes carry the unresolved kind and no rank at all,
	## written explicitly rather than defaulted, so a result cannot acquire a
	## progression by omission. The three values handed over are the FROZEN ones —
	## which `_stage_support()` has just proved the staged build actually reached,
	## and which the result re-checks against that build for itself.
	var takes_progression: bool = lane == RiftOffer.Lane.SUPPORT
	return RiftOfferChoiceResult.chosen(
		offer.root_seed, lane, identity,
		offer.support_progression_kind if takes_progression \
			else RiftOffer.UNRESOLVED_PROGRESSION_KIND,
		offer.support_rank_before if takes_progression else RiftOfferChoiceResult.NO_RANK,
		offer.support_rank_after if takes_progression else RiftOfferChoiceResult.NO_RANK,
		staged_build, staged_ledger)


# --- Staging one lane -------------------------------------------------------------
#
# Each returns "" when the staged build accepted the lane, or the single
# plain-language reason it did not. None of them touches the ledger: a lane that
# cannot be staged must not be able to spend anything, and the simplest way to
# guarantee that is for these functions to have nothing to spend it with.

## Routes one lane to its rule. The lane is already known to be one of the three,
## so the closing line is unreachable; it is written anyway because a fourth lane
## added upstream must fail loudly here rather than fall through to a passive
## rule that was never meant for it.
static func _stage(
	build: RiftRunBuild, offer: RiftOffer, lane: int, identity: PackedStringArray
) -> String:
	match lane:
		RiftOffer.Lane.SUPPORT:
			## ROUTED ON THE STORED CONTENT KIND (Foundation I8). The closing line of
			## this branch is unreachable for the same reason the one below is — a
			## coherent offer declares one of the two kinds — and is written for the
			## same reason: a third kind added upstream must fail loudly here.
			match offer.support_content_kind:
				RiftOffer.SupportContentKind.SUPPORT_PROGRESSION:
					return _stage_support(build, offer, identity)
				RiftOffer.SupportContentKind.PASSIVE_FALLBACK:
					return _stage_support_fallback(build, offer, identity)
			return "the Support lane carries no content this transaction can take (kind %d)" \
				% offer.support_content_kind
		RiftOffer.Lane.COMBAT_DEFENCE, RiftOffer.Lane.UTILITY:
			return _stage_passive(build, lane, identity)
	return "lane %d carries no rule for taking it" % lane


## The support lane: the exact Skill, the exact support and the exact PROGRESSION
## OPERATION the offer named, applied to the run build through the one accepted
## operation that operation names.
##
## COMPATIBILITY IS NOT RE-DERIVED HERE, AND NEITHER IS THE OPERATION. Whether
## that support may attach to that Skill was decided by the accepted rule the
## composition applied; WHICH of the two operations this offer represents was
## decided by the accepted continuation and frozen into the offer. Asking either
## again would be a second copy of a rule that already exists — one that would
## start disagreeing the day either changed. Nothing about a support's effect, its
## strength or how it combines with anything else is read, written or implied:
## this records that the pair advanced and nothing more.
##
## THE THREE GATES, IN THIS ORDER, AND THE ORDER IS THE CONTRACT.
##
## FIRST THE PRECONDITION, BEFORE A SINGLE MUTATION IS STAGED. The run's current
## rank for this exact pair must EQUAL the rank the offer froze. It is an
## equality rather than a floor or a ceiling because an offer is a statement
## about one run state: a run that moved on and a run that is somehow behind are
## the same disagreement, and both mean this offer no longer describes this run.
## The refusal names the pair and BOTH numbers, because "this offer is stale" is
## not something a caller can act on.
##
## THEN THE OPERATION THE OFFER DECLARED, ROUTED ON THE KIND ITSELF. A new pair
## goes to the acquisition operation and a rank increase to the rank operation,
## and they are separate calls on the run build for the same reason they are
## separate operations there: folding them together would make "take this pair"
## and "raise this pair" one request that no caller could tell apart. The
## accepted operation's own refusal is returned verbatim.
##
## THEN THE OUTCOME, READ BACK RATHER THAN ASSUMED. The pair's rank is read out
## of the STAGED build and must equal the rank the offer froze as the one it
## would reach. Only when it does may the caller go on to spend the seed. This is
## the gate that makes the transaction honest about what it paid rather than only
## about what it attempted, and it is cheap: it is one reading of the state that
## was just written.
##
## A REFUSAL FROM ANY OF THE THREE IS ATOMIC BY CONSTRUCTION rather than by
## unwinding. The build this function mutates is a duplicate the caller cannot
## reach and the transaction discards on any refusal, and nothing here can touch
## the ledger — a lane that cannot be staged must not be able to spend anything,
## and the simplest way to guarantee that is for this function to have nothing to
## spend it with.
static func _stage_support(
	build: RiftRunBuild, offer: RiftOffer, identity: PackedStringArray
) -> String:
	var owed: int = RiftOfferChoiceResult.identity_size_for(RiftOffer.Lane.SUPPORT)
	if identity.size() != owed:
		return "the support lane named %d identifiers, not %d" % [identity.size(), owed]
	var skill_id: StringName = StringName(identity[0])
	var support_id: StringName = StringName(identity[1])

	## THE PRECONDITION. The run build is the only thing that knows what this run
	## currently holds; asking it is delegation, and deciding it here would be a
	## second rule. An offer composed against a rank this run no longer has is
	## refused whole rather than rebased onto the current one, because rebasing
	## grants a step nobody was offered while looking exactly like a reward.
	var current: int = build.support_rank_for(skill_id, support_id)
	if current != offer.support_rank_before:
		return "%s -> %s is a stale support offer: it was composed against rank %d and this run now holds rank %d" % [
			skill_id, support_id, offer.support_rank_before, current,
		]

	## THE CLASSIFIED OPERATION, READ FROM THE OFFER RATHER THAN INFERRED FROM
	## WHETHER THE PAIR IS HELD. The two kinds are the accepted continuation
	## vocabulary's own, named here so there is exactly one place in the project
	## where those two operations are declared.
	var refusal: String = ""
	match offer.support_progression_kind:
		SupportContinuationResult.Kind.NEW_PAIR:
			refusal = build.acquire_support(skill_id, support_id)
		SupportContinuationResult.Kind.RANK_INCREASE:
			refusal = build.rank_support(skill_id, support_id)
		_:
			## DEFENCE IN DEPTH, AND DELIBERATELY UNREACHABLE. The offer was
			## required internally coherent before anything got this far, and that
			## coherence refuses a kind outside the declared two through the same
			## shared validator the result re-checks a consumed progression with.
			## The suite does not pretend to drive it, and drives the tampering it
			## guards against at the gate that really catches it. It is written as
			## a refusal rather than as an assert because an assert is stripped
			## from a release build, and a silently unrouted lane would spend a
			## seed for nothing.
			return "%s -> %s carries no progression operation this transaction can take (kind %d)" % [
				skill_id, support_id, offer.support_progression_kind,
			]
	if not refusal.is_empty():
		return refusal

	## THE OUTCOME. Read back out of the staged build, compared with the rank the
	## offer froze, and refused before the seed can be spent if the two disagree.
	var reached: int = build.support_rank_for(skill_id, support_id)
	if reached != offer.support_rank_after:
		return "%s -> %s reached rank %d where this offer froze rank %d" % [
			skill_id, support_id, reached, offer.support_rank_after,
		]
	return ""


## The Support lane when it carries a PASSIVE FALLBACK (Foundation I8, decision
## D-308): the one card the accepted exhausted-support fallback chose, taken as
## ONE passive-card acquisition through the accepted run-build operation, in the
## ten steps the file header names. It never infers the category from the lane,
## and it touches no support pair and no rank.
##
## THE FIRST THREE GATES ARE DEFENCE IN DEPTH: the offer was required coherent
## before anything got this far, and a coherent fallback offer already carries a
## one-card identity equal to its fallback's own coherent selection. They are
## written as refusals rather than asserts for the reason every such gate here is.
## THE CANONICAL-RECORD GATES AND THE RUN BUILD'S OWN REFUSAL ARE REACHABLE. THE
## TWO GATES AFTER THE ACQUISITION ARE DEFENCE IN DEPTH AGAIN: the accepted run
## build counts one acquisition per success and never reaches a support pair from
## a passive one. They exist so this transaction reports what it PAID rather than
## what it attempted, and each is one reading of state that was just written.
static func _stage_support_fallback(
	build: RiftRunBuild, offer: RiftOffer, identity: PackedStringArray
) -> String:
	var owed: int = RiftOfferChoiceResult.identity_size_for_content(
		RiftOffer.Lane.SUPPORT, RiftOffer.SupportContentKind.PASSIVE_FALLBACK)
	if identity.size() != owed:
		return "the Support lane's passive fallback named %d identifiers, not %d" % [
			identity.size(), owed,
		]
	var card_id: StringName = StringName(identity[0])

	if offer.support_fallback == null:
		return "the Support lane carries no passive fallback result to take"
	if not offer.support_fallback.ok:
		return "the Support lane's passive fallback chose no card: %s" \
			% offer.support_fallback.failure_reason
	var fallback_problem: String = offer.support_fallback.problem()
	if not fallback_problem.is_empty():
		return "the Support lane's passive fallback is not coherent: %s" % fallback_problem

	var selected: StringName = offer.support_fallback.selected_card_id
	if card_id != selected or offer.support_fallback_card_id != selected:
		return "the Support lane names %s and offers %s, but its passive fallback selected %s" % [
			card_id, offer.support_fallback_card_id, selected,
		]

	## THE CATEGORY IS THE FALLBACK'S, READ FROM IT. The Support lane draws from
	## no category of its own, so there is nothing to infer one from.
	var category: int = offer.support_fallback.selected_category

	## THE CANONICAL RECORD IS THE EFFECT, EXACTLY AS FOR A PASSIVE LANE: the id
	## is the choice authority, and the record the catalogue holds for it is what
	## is acquired — never the record the offer was composed from.
	var record: PassiveCardDefinition = PassiveCardCatalogue.record(card_id)
	if record == null:
		return "%s is not a card the canonical catalogue holds" % card_id
	var record_problem: String = record.problem()
	if not record_problem.is_empty():
		return "%s is not a valid canonical record: %s" % [card_id, record_problem]
	if record.category() != category:
		return "%s derives category %d and the Support lane's passive fallback drew from category %d" % [
			card_id, record.category(), category,
		]

	## WHAT THE RUN HOLDS BEFORE, READ FROM THE RUN BUILD THAT OWNS IT.
	var held: int = build.acquisitions_for(card_id)
	var pairs: PackedStringArray = build.support_pairs()
	var ranks: int = build.total_support_ranks()

	## THE ACQUISITION, THROUGH THE ONE ACCEPTED OPERATION. Its refusal — a
	## fingerprint conflict, the repeat rule, a total it cannot use — is the run
	## build's to state and is returned verbatim.
	var refusal: String = build.acquire_passive_card(record)
	if not refusal.is_empty():
		return refusal

	## WHAT IT PAID, READ BACK RATHER THAN ASSUMED.
	var now_held: int = build.acquisitions_for(card_id)
	if now_held != held + 1:
		return "%s was held %d times and is now held %d times, where exactly one acquisition was owed" % [
			card_id, held, now_held,
		]
	if build.support_pairs() != pairs or build.total_support_ranks() != ranks:
		return "taking the passive fallback %s moved this run's support pairs or ranks" % card_id
	return ""


## A passive lane: the offered card id, resolved through the canonical catalogue,
## checked against the category this lane draws from, and added through the
## accepted acquisition operation.
static func _stage_passive(
	build: RiftRunBuild, lane: int, identity: PackedStringArray
) -> String:
	var owed: int = RiftOfferChoiceResult.identity_size_for(lane)
	if identity.size() != owed:
		return "the %s lane named %d identifiers, not %d" % [
			RiftOffer.lane_label(lane), identity.size(), owed,
		]
	var card_id: StringName = StringName(identity[0])

	var record: PassiveCardDefinition = PassiveCardCatalogue.record(card_id)
	if record == null:
		return "%s is not a card the canonical catalogue holds" % card_id

	## THE CANONICAL RECORD MUST BE VALID BEFORE IT IS THE EFFECT. Unreachable
	## with the shipped set, whose coherence its own accepted suite proves — and
	## kept precisely because that is a fact about today's catalogue rather than a
	## property of this function, which must not be the place a malformed record
	## first becomes something a run holds.
	var record_problem: String = record.problem()
	if not record_problem.is_empty():
		return "%s is not a valid canonical record: %s" % [card_id, record_problem]

	## THE LANE DECIDES THE CATEGORY, READ FROM THE ONE PLACE THAT MAPPING IS
	## WRITTEN. The two sides of this comparison come from different places on
	## purpose: the lane's category from the offer contract, the record's from
	## the canonical vocabulary it derives. A card offered in a lane it does not
	## belong to is refused rather than taken from the wrong one.
	var owed_category: int = RiftOffer.category_for_lane(lane)
	if record.category() != owed_category:
		return "%s derives category %d and the %s lane draws from category %d" % [
			card_id, record.category(), RiftOffer.lane_label(lane), owed_category,
		]

	return build.acquire_passive_card(record)
