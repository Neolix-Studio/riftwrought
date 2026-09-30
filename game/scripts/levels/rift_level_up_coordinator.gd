class_name RiftLevelUpCoordinator
extends RefCounted
## Riftwrought — Roguelite Foundation E2: ONE complete Rift level-up lifecycle,
## start to finish, as a pure in-memory coordinator.
##
## THE ONE THING IT PROVES. Experience accumulates; a caller-supplied threshold
## is reached; one three-lane offer is composed; exactly one of those lanes is
## taken; the level advances by exactly one; the resulting run build and
## consumption record are retained; and the coordinator is then permanently
## finished. That whole sequence, once, and nothing beyond it.
##
##
## IT SUPPORTS EXACTLY ONE LEVEL-UP, AND THAT IS A DELIBERATE STOPPING POINT
## RATHER THAN AN OVERSIGHT
## ---------------------------------------------------------------------------
## The project has not chosen what happens when the support pool is exhausted.
## The accepted composition mechanism refuses honestly once no compatible pair is
## available, and with a small support catalogue a SECOND offer can reach exactly
## that condition. So this foundation represents one real level-up without
## silently beginning multiple levels: after its one successful choice it accepts
## no further award, opens no further offer and takes no further lane. A second
## level-up is a later decision with its own authorization, and a coordinator
## that quietly produced a second offer would have made that decision by
## accident.
##
## THE FIRST TWO SENTENCES ABOVE ARE HISTORY NOW, AND ARE CORRECTED HERE RATHER
## THAN LEFT TO MISLEAD (decision D-260). Foundations F2 and F3 answered
## exhaustion — an exhausted Support lane now offers one further rank of a held
## pair instead of refusing — and F4 made the choice transaction consume that
## offer, so this coordinator's one level-up can complete through a rank. THE
## BOUNDARY ITSELF STANDS, for the reason the rest of the paragraph gives: a
## second level-up is still its own authorization, and nothing here moved it.
##
## THERE IS NO RESET AND NO REUSE, FOR THE SAME REASON EVERY FOUNDATION BEFORE
## IT HAS NONE. A new lifecycle is a new coordinator. Saying so is cheaper than
## inventing a lifecycle nobody has authorized, and the suite pins this script's
## method list by name so one cannot arrive quietly with a plausible name.
##
## A COMPLETED LIFECYCLE MAY HAND ITS RESULTING STATE TO A NEW ONE, AND THAT IS
## STILL NOT REUSE (Foundation G3, decision D-267). `next_level_coordinator()`
## answers null until this coordinator has completed, and afterwards answers a
## NEW coordinator built through `with_state()` from independent copies of the
## level, the retained experience, the run build and the ledger this one ended
## with. This coordinator stays completed and is not touched; the new one begins
## its own single level-up with no offer and no frozen requirement, held to every
## rule in this file exactly as this one was. It is a state transfer and not a
## loop: nothing here asks for a requirement, derives a seed or opens an offer on
## anyone's behalf, and nothing that runs calls it.
##
##
## IT COORDINATES; IT DECIDES NOTHING
## ---------------------------------------------------------------------------
## Not one rule any accepted foundation already owns is restated here. The
## percentage arithmetic belongs to the accepted stat accumulator; the award
## validation, the threshold reading and the single advance belong to the
## accepted experience track; the three lane seeds, the two weighted ladders and
## the fixed offer shape belong to the accepted composition mechanism; the pair
## rule, the card fingerprint rule and the repeat rule belong to the accepted run
## build; and the single-consumption protection and the whole choice transaction
## belong to the accepted choice mechanism. This file contains no multiplication,
## no division, no addition and no floating-point literal but zero — asserted
## from the source rather than promised here, because a level curve or an
## experience value would arrive as exactly a float literal while naming nothing
## forbidden at all.
##
## WHAT IT ADDS IS THE ONE THING NONE OF THEM CAN HAVE: THE ORDER. Which
## operation is legal when, what is frozen while an offer stands, and the exact
## sequence in which a choice becomes a level. Every foundation below is
## individually atomic; being atomic in sequence is a property only something
## holding all of them can have, and it is what this file is for.
##
## IT NAMES NOTHING CONCRETE. No Skill, no support, no card, no catalogue, no
## character class, no room, no presentation label and no offer weight appears
## here in code or in a comment. The equipped Skill profiles, the support
## definitions and the complete card record set all arrive as arguments, and the
## root offer seed arrives as an argument too.
##
##
## THE THRESHOLD IS SUPPLIED, AND THE OFFER SEED IS SUPPLIED
## ---------------------------------------------------------------------------
## No level curve exists here, exactly as none exists in the accepted experience
## track: the requirement for the current level is handed in when an offer is
## opened, and the exact requirement that was handed in is FROZEN beside the
## offer so that the advance which follows cannot be measured against a different
## number than the one the caller was told about. Deriving an offer seed from a
## run seed and a level is deferred; the root seed is explicit.
##
##
## EXPERIENCE GAIN IS READ AT AWARD TIME AND IS NOT RETROACTIVE
## ---------------------------------------------------------------------------
## Every award hands the accepted track a FRESH snapshot of the run build's stat
## totals, taken at that moment, and the track reads it once and never stores it.
## So a card acquired later cannot raise experience already accumulated — not
## because this file remembers not to, but because there is nothing anywhere to
## re-evaluate. The snapshot is a copy, which is also what keeps a caller from
## reaching the build's accumulator through it.
##
##
## THE ACTIVE-OFFER BOUNDARY
## ---------------------------------------------------------------------------
## While an offer stands, the state it was composed against must not move. So no
## award is accepted, no second offer may open, and the only operation that can
## succeed is taking one lane of that exact stored offer. The level does NOT
## advance when an offer opens: an offer is a question, and advancing on the
## question rather than on the answer is how a level gets gained for a choice
## nobody made.
##
## THE LIVE OFFER IS NEVER HANDED OUT. Inspection answers scalars and copies —
## whether an offer is active, its root seed, its lanes in the composed order,
## each lane's mechanical identities, the level, the accumulated experience and
## the frozen requirement. A caller holding the offer itself could not change it
## in any way that mattered today, and would be holding the one object whose
## identity the whole consumption protection is keyed on.
##
##
## THE CHOICE IS ONE TRANSACTION AND THE COMMIT IS ONE BLOCK
## ---------------------------------------------------------------------------
## Three independent copies are staged; the accepted choice mechanism resolves
## the stored offer and the requested lane against them; the staged track then
## advances once against the FROZEN requirement; and only after BOTH have
## succeeded is anything committed. Either refusal leaves every field exactly as
## it was and leaves the offer open, so a caller may take a different lane of the
## same offer.
##
## THE STAGED BUILD AND LEDGER ARE DEFENCE IN DEPTH AND THE STAGED TRACK IS NOT,
## AND THE DIFFERENCE IS STATED RATHER THAN LEFT TO BE ASSUMED. The accepted
## choice mechanism duplicates both of those values itself and returns two new
## ones, so it cannot reach the originals however this file calls it; staging
## them here means the objects it works on were already not ours. The TRACK has
## no such protection — advancing it is a direct mutation — so the copy is the
## only thing that makes an advance abandonable, and it is load-bearing.
##
## THE COMMITTED VALUES ARE THE ONES THE TRANSACTION RETURNED, AND THEY ARE
## UNREACHABLE FROM ANY CALLER. Its result never leaves this file, which is
## precisely why this foundation returns its own result type: handing that one
## out would hand a caller live references to the build and ledger this
## coordinator has just adopted as its own.
##
## THE RECEIPT IS BUILT FROM THAT RESULT WHOLE, AND THIS FILE READS NONE OF ITS
## PROGRESSION (Foundation F5, decision D-260). Which Support operation the choice
## consumed, and the two ranks it moved between, travel into the receipt exactly
## as the accepted transaction returned them — copied by the receipt's own
## constructor out of the one successful result, beside the seed, the lane and
## the identity it copies out of the same object. This file hands that result
## over and does not interpret it: it asks no build whether a pair is held, reads
## no rank, and never sees the progression at all, so it has nothing from which
## to re-derive one. The receipt copies scalars and an independent identity and
## keeps no reference to the result, so the build and ledger this coordinator
## adopts are still reachable only through the duplicating readings below.
##
##
## STILL ABSENT, AND DELIBERATELY: experience sources of any kind, enemy
## experience values, a level-requirement curve, offer-seed derivation, more than
## one level inside one coordinator — a continuation is a separate coordinator,
## and nothing here strings two together — any rank decision of this file's own — ranks and exhaustion
## continuation belong to the foundations below it, and the receipt only carries
## what they decided — application of any
## support effect, application of accumulated totals to anything that lives,
## Maximum-Life behaviour, offer presentation, controller navigation, scenes,
## nodes, clocks, files, saving and balance. Nothing that runs calls this file.
##
## IT IS A COORDINATOR, NOT A STORE. No node, no signal, no clock, no random
## source, no file, no schema version.

## What `frozen_requirement()` answers while no offer stands. Zero is not a
## stand-in a reader has to be warned about: the accepted track refuses any
## requirement that is not strictly positive, so zero is a value that could never
## have been frozen, and the suite asserts that in both directions.
const NO_REQUIREMENT: float = 0.0

## What `offer_root_seed()` answers while no offer stands.
##
## IT IS A STAND-IN AND NOT A SENTINEL, AND THE DISTINCTION IS THE WHOLE COMMENT.
## Every integer is a legal offer seed — the worked example in this foundation's
## own verification uses zero — so no value could honestly mean "no seed".
## `is_offer_active()` is therefore the authority on whether the seed says
## anything at all, exactly as the accepted choice result carries its own
## `root_seed_known` beside a seed that defaults to zero.
const UNSTATED_ROOT_SEED: int = 0

## The accumulated experience and the level. Private, and handed out only as
## scalars or through a reading: the level moves through one advance inside one
## commit, and the experience through `award_experience()`, so there is exactly
## one way for each to change.
var _track: RiftExperienceTrack = RiftExperienceTrack.new()

## What this run has acquired. Private, and never handed out live — a caller
## receives `run_build()`, which is a duplicate.
var _build: RiftRunBuild = RiftRunBuild.new()

## Which offers this run has spent. Private for the same reason, and handed out
## as `consumption_ledger()`, which is a duplicate.
var _ledger: RiftConsumptionLedger = RiftConsumptionLedger.new()

## The one offer, while it stands, or null. Never handed out: it is the object
## whose root seed the single-consumption protection is keyed on.
var _offer: RiftOffer = null

## The exact requirement that was handed in when `_offer` opened, frozen so that
## the advance which follows is measured against the number the caller was told
## about. `NO_REQUIREMENT` while no offer stands, and committed and released
## together with the offer so the two can never disagree about whether one is
## open.
var _requirement: float = NO_REQUIREMENT

## Whether the one level-up has happened. Once true it is never false again:
## there is no reset, and a new lifecycle is a new coordinator.
var _completed: bool = false


## A coordinator built on INDEPENDENT COPIES of the three supplied values, for a
## verification that needs a lifecycle to begin somewhere other than at the
## start. Every one of them is duplicated, so the caller keeps what it handed in
## and this coordinator can never be moved through a reference somebody else
## still holds.
##
## A NULL MEANS "THE DEFAULT", which is the honest reading of an absent value and
## is exactly what the accepted composition mechanism already does with an absent
## acquisition record. There is no other defaulting anywhere in this file.
##
## IT IS ALSO THE ONE SEAM A CONTINUATION IS BUILT THROUGH (Foundation G3,
## decision D-267). `next_level_coordinator()` hands this function a completed
## coordinator's three private values and nothing else, so the copying rule a
## continuation obeys is this function's, written once.
static func with_state(
	track: RiftExperienceTrack,
	build: RiftRunBuild,
	ledger: RiftConsumptionLedger
) -> RiftLevelUpCoordinator:
	var coordinator: RiftLevelUpCoordinator = RiftLevelUpCoordinator.new()
	if track != null:
		coordinator._track = track.duplicated()
	if build != null:
		coordinator._build = build.duplicated()
	if ledger != null:
		coordinator._ledger = ledger.duplicated()
	return coordinator


# --- Reading the lifecycle -------------------------------------------------------
#
# Scalars and copies only. Nothing here can move anything, and nothing here
# hands out an object this coordinator still uses.

## The level, forwarded from the accepted track, which is the only thing that
## knows it. Not stored a second time here: a second copy of a number is a second
## thing that can be wrong.
func level() -> int:
	return _track.level()


## The effective experience accumulated toward the next level, fractions
## included. The accepted track's own progress, forwarded under this
## foundation's word for it.
func experience() -> float:
	return _track.progress()


## Whether the one level-up has already happened. A completed coordinator
## refuses every operation and answers every reading truthfully forever.
func is_completed() -> bool:
	return _completed


func is_offer_active() -> bool:
	return _offer != null


## The root seed of the offer that stands, or `UNSTATED_ROOT_SEED`. Meaningful
## only when `is_offer_active()`; see that constant for why the flag rather than
## the value is the authority.
func offer_root_seed() -> int:
	if _offer == null:
		return UNSTATED_ROOT_SEED
	return _offer.root_seed


## The lanes the standing offer carries, in the composed order, as a copy. Empty
## while no offer stands.
##
## READ FROM THE OFFER RATHER THAN RESTATED, which is what keeps this
## coordinator from carrying a second opinion about the fixed offer shape.
func offer_lanes() -> Array[int]:
	if _offer == null:
		return []
	return _offer.lane_order()


## The mechanical identities one lane of the standing offer would grant, as a
## copy: ids only, never a presentation label. Empty for a lane the offer does
## not carry and empty while no offer stands.
func offer_identity_for(lane: int) -> PackedStringArray:
	if _offer == null:
		return PackedStringArray()
	return _offer.identity_for(lane)


## WHICH KIND OF CONTENT THE STANDING OFFER'S SUPPORT LANE CARRIES (Roguelite I10,
## decision D-312): the offer contract's `SupportContentKind` member exactly as the
## offer stored it, or the contract's own unresolved value while no offer stands. A
## scalar read from the offer and never inferred here — not from how many ids a lane
## grants, and not from which fields happen to be empty.
func offer_support_content_kind() -> int:
	if _offer == null:
		return RiftOffer.UNRESOLVED_SUPPORT_CONTENT_KIND
	return _offer.support_content_kind


## WHICH PASSIVE CATEGORY A STANDING PASSIVE-FALLBACK SUPPORT LANE DRAWS FROM (Roguelite
## I10, D-312), read from the fallback result the offer carries — exactly where the
## accepted choice transaction reads it. The choice result's no-fallback sentinel while
## no offer stands and for a Support progression offer, decided by the offer's STORED
## kind rather than by whether a field is empty.
func offer_support_fallback_category() -> int:
	if _offer == null or _offer.support_content_kind != RiftOffer.SupportContentKind.PASSIVE_FALLBACK:
		return RiftOfferChoiceResult.NO_FALLBACK_CATEGORY
	return _offer.support_fallback.selected_category


## The exact requirement frozen when the standing offer opened, or
## `NO_REQUIREMENT` while none stands.
func frozen_requirement() -> float:
	return _requirement


## The honest answer to "is a level-up available against this requirement?",
## delegated whole to the accepted track. Pure: it grants nothing, opens nothing
## and moves nothing, which is what lets a caller ask before it commits to
## asking for an offer.
func reading_for(requirement: float) -> RiftExperienceReading:
	return _track.reading_for(requirement)


## An INDEPENDENT COPY of what this run has acquired. Changing the copy cannot
## change this lifecycle.
func run_build() -> RiftRunBuild:
	return _build.duplicated()


## An INDEPENDENT COPY of which offers this run has spent, for the same reason.
func consumption_ledger() -> RiftConsumptionLedger:
	return _ledger.duplicated()


# --- Awarding experience ---------------------------------------------------------

## Records one experience award of `base_experience`, as modified by what this
## run holds AT THIS MOMENT. Returns "" when it was accepted, or the single
## plain-language reason it was refused.
##
## THE TWO REFUSALS HERE CANNOT BOTH HOLD, and the completed one is asked first
## because it is the permanent condition: a commit releases the offer and marks
## the lifecycle finished in one block, so a completed coordinator never has one
## standing. The suite asserts that pair rather than trusting this paragraph.
##
## EVERYTHING ELSE IS THE ACCEPTED TRACK'S. Whether the award is finite and
## positive, whether the modified value is worth recording, and whether the sum
## is usable are all its questions, and its refusal is returned verbatim. It is
## already atomic, so no staging is needed and none is done: a refused award
## leaves this coordinator exactly as it was because the one operation it
## performs leaves the track exactly as it was.
func award_experience(base_experience: float) -> String:
	if _completed:
		return "this coordinator has finished its one level-up and records no further experience"
	if _offer != null:
		return "an offer is open; it must be resolved before further experience is recorded"
	return _track.award(base_experience, _build.stat_totals())


# --- Opening the one offer -------------------------------------------------------

## Opens the ONE offer this coordinator ever opens, against the caller-supplied
## `requirement` for the current level and the explicit `root_seed`. Returns ""
## when it was opened, or the single plain-language reason it was not. A refusal
## leaves no offer standing and changes nothing at all.
##
## THE ORDER OF THE GATES IS THE CONTRACT. The lifecycle's own two conditions
## first, because a finished coordinator and one already holding an offer are
## both answers that do not depend on any argument. Then the threshold, asked
## through the accepted track's single authoritative reading — which is what
## distinguishes "that is not a requirement" from "not yet" and is the reason
## this file asks for a reading rather than for a bool. Then the composition,
## whose refusal is quoted verbatim. Only then are the offer and its frozen
## requirement written, and they are written together.
##
## THE LEVEL DOES NOT MOVE HERE. An offer is the question; the advance belongs to
## the answer.
##
## THE COMPOSITION IS ASKED AGAINST THIS RUN'S OWN ACQUISITION SNAPSHOT, which is
## what makes the offered pair one this run does not already hold. That is a
## property of the derivation rather than a rule this file enforces, and the
## suite measures it over a corpus of seeds rather than arguing it.
func open_offer(
	requirement: float,
	profiles: Array[SkillTagProfile],
	definitions: Array[SupportDefinition],
	cards: Array[PassiveCardDefinition],
	root_seed: int
) -> String:
	if _completed:
		return "this coordinator has finished its one level-up and opens no further offer"
	if _offer != null:
		return "an offer is already open; only a lane of that offer may be taken"

	var reading: RiftExperienceReading = _track.reading_for(requirement)
	if not reading.ok:
		return reading.failure_reason
	if not reading.ready:
		return "no offer opens yet — %s" % reading.describe()

	var composed: RiftOffer = RiftOfferComposition.compose(
		profiles, definitions, _build.acquired_supports(), cards, root_seed
	)
	if not composed.ok:
		return "no offer composed: %s" % composed.failure_reason

	## DEFENCE IN DEPTH, AND DELIBERATELY UNREACHABLE TODAY. The accepted
	## composition mechanism re-derives its own answer and refuses an incoherent
	## lane itself, so no supplied input can drive this branch and the suite does
	## not pretend to drive one. It stays because this is the moment an offer
	## becomes something a caller can inspect, and an invariant about stored state
	## belongs where the state is stored rather than where it is spent — showing
	## a caller an offer that cannot be taken is worse than refusing to open one.
	var incoherent: String = composed.problem()
	if not incoherent.is_empty():
		return "the composed offer is not internally coherent: %s" % incoherent

	_offer = composed
	_requirement = requirement
	return ""


# --- Taking one lane -------------------------------------------------------------

## Takes exactly one lane of the standing offer, advances exactly one level, and
## finishes this coordinator. Returns a coherent result, or a refusal carrying
## the question and the reason and nothing else.
##
## THE TRANSACTION ORDER IS THE CONTRACT AND IS WORTH READING IN FULL. An offer
## must stand; the lifecycle must not be finished; three independent copies are
## staged; the accepted choice mechanism resolves the stored offer and the
## requested lane against the staged values; the staged track advances once
## against the frozen requirement; and only after BOTH of those have succeeded is
## anything written. A refusal from either leaves the offer open, so a caller may
## take a different lane of the same offer, and leaves every field exactly as it
## was.
##
## THE ADVANCE IS SECOND ON PURPOSE, AND WHAT THAT BUYS IS STATED HONESTLY. It
## cannot fail once an offer stands — the requirement was validated and found
## reached when the offer opened, no award can have moved the progress since, and
## the level is one increment away from a bound nine quintillion levels off — so
## the ordering is defence in depth rather than a fix for something reachable
## today, and the suite reports it as unobservable rather than manufacturing an
## assertion for it. It is the shape that stays correct if a later foundation
## ever makes an advance refusable.
func choose(lane: int) -> RiftLevelUpResult:
	if _offer == null:
		return RiftLevelUpResult.refused_without_a_seed(_no_offer_reason(), lane)
	## Unreachable while the gate above stands, because a commit releases the
	## offer and finishes the lifecycle in one block. It is written anyway
	## because the brief's transaction order names it, and because a finished
	## coordinator taking a lane is the one failure nothing downstream would
	## catch: every accepted mechanism below would happily resolve a second
	## choice.
	if _completed:
		return RiftLevelUpResult.refused(
			"this coordinator has finished its one level-up", _offer.root_seed, lane)

	var root_seed: int = _offer.root_seed
	var staged_track: RiftExperienceTrack = _track.duplicated()
	var staged_build: RiftRunBuild = _build.duplicated()
	var staged_ledger: RiftConsumptionLedger = _ledger.duplicated()

	var outcome: RiftOfferChoiceResult = RiftOfferChoice.choose(
		_offer, lane, staged_build, staged_ledger
	)
	if not outcome.ok:
		return RiftLevelUpResult.refused(outcome.failure_reason, root_seed, lane)

	var refusal: String = staged_track.advance_one_level(_requirement)
	if not refusal.is_empty():
		return RiftLevelUpResult.refused(refusal, root_seed, lane)

	# --- The commit, and only now, and all of it together --------------------
	_build = outcome.new_build
	_ledger = outcome.new_ledger
	_track = staged_track
	_offer = null
	_requirement = NO_REQUIREMENT
	_completed = true

	## THE WHOLE SUCCESSFUL RESULT, AND NOT ITS PARTS. The seed, lane, identity and
	## consumed progression are all copied out of this one object by the receipt's
	## constructor, so they cannot come from two different outcomes — and they are
	## the same seed and lane this method was already reporting, because the
	## accepted transaction stamps a success with exactly the offer's root seed and
	## the requested lane.
	return RiftLevelUpResult.taken(outcome)


## Why no lane may be taken, when no offer stands. ONE gate reading both facts
## rather than two gates that could disagree about which of them to report.
func _no_offer_reason() -> String:
	if _completed:
		return "this coordinator has finished its one level-up; no further lane may be taken"
	return "no offer is open; one must be opened before a lane may be taken"


# --- Continuing into a fresh lifecycle -------------------------------------------

## A NEW one-level coordinator that begins exactly where this COMPLETED one ended,
## or null. It reads this coordinator and never writes to it.
##
## NULL UNTIL THE ONE LEVEL-UP HAS HAPPENED, AND NULL IS NOT A REFUSAL. Before any
## offer, while one stands, and after any refused operation or refused choice,
## this coordinator has not completed, so there is nothing to carry forward yet.
## This is an optional construction rather than an attempted gameplay
## transaction, and because it can never move this coordinator it owes no reason
## string and no result type.
##
## BUILT THROUGH `with_state()` AND THROUGH NOTHING ELSE. The three private values
## are handed to that existing seam, which duplicates each of them: the level and
## the retained experience travel inside the track's own copy, the acquired pairs
## with their ranks and every card with its mechanical fingerprint and count
## travel inside the build's own copy, and every consumed root seed travels inside
## the ledger's own copy. Nothing is read out of any of them or restated here, and
## no field of either coordinator is assigned: the new one starts with no offer,
## no frozen requirement and an unfinished lifecycle because that is what
## `with_state()` has always produced.
##
## INDEPENDENT IN BOTH DIRECTIONS. Nothing the new coordinator does can reach this
## one, and nothing this one answers can reach the new one. Asking twice builds
## two separate coordinators holding identical state; which of them a run goes on
## with is its caller's business, and this file keeps no record of having been
## asked, because keeping one would be a seventh field.
##
## IT KNOWS NO REQUIREMENT AND NO SEED. What the next level requires and which
## root seed its offer is composed from are still supplied by whoever opens it.
func next_level_coordinator() -> RiftLevelUpCoordinator:
	if not _completed:
		return null
	return RiftLevelUpCoordinator.with_state(_track, _build, _ledger)


# --- Presentation ---------------------------------------------------------------
#
# Reached by nothing above. No formatted string is compared, parsed or fed back
# into a number, an identity or a seed, and every part of it is rendered by the
# accepted mechanism that owns the value rather than by a second formatter
# written here.

func describe() -> String:
	return "%s; %s; %s; %s" % [
		_track.describe(), _lifecycle_line(), _build.describe(), _ledger.describe(),
	]


func _lifecycle_line() -> String:
	if _completed:
		return "the one level-up is finished"
	if _offer == null:
		return "no offer open"
	return "offer open against %s: %s" % [
		String.num_scientific(_requirement), _offer.describe(),
	]
