class_name RiftOfferComposition
extends RefCounted
## Riftwrought — Roguelite Foundation D1: deterministic composition of exactly
## ONE complete Rift offer from the accepted foundations (decision D-239).
##
## THE ONE QUESTION THIS FILE ANSWERS: given what is equipped, what supports are
## defined, what is already held, the complete set of passive card records, and
## one root offer seed — which single three-lane offer does that seed produce?
## It answers exactly that and stops.
##
## IT COMPOSES; IT DOES NOT SELECT. Both draws already exist and are accepted:
## one decides the whole support lane, the other chooses one passive card from
## one requested category. Neither ladder is reimplemented here, neither weight
## is read here, and neither eligibility rule is restated here — this file
## derives three independent lane seeds, delegates three times, and refuses the
## whole offer if any of the three refuses. Re-deriving a candidate pool or a
## weight here would be building a third selector under the name of a composer,
## and the suite proves the absence rather than promising it: this file's methods
## are enumerated from the engine and pinned by name.
##
##
## THE SUPPORT LANE IS DECIDED BY THE ACCEPTED CONTINUATION SELECTOR (Foundation
## F3, D-255), NOT BY THIS FILE AND NOT BY THE WEIGHTED SELECTOR DIRECTLY
## ---------------------------------------------------------------------------
## The support lane may now offer either a compatible pair that is not held yet
## or ONE further rank of a pair that is. WHICH of those two it is, and on which
## pair, is one accepted decision with its own global rule — new pairs anywhere
## before any rank, everywhere — and this file asks that decision for it. It does
## not restate the new-first policy, does not compute eligibility, does not read
## a weight, does not mix a second stream and does not ask the weighted selector
## itself: the lane's existing seed goes in unchanged and one decision comes
## back. The suite asserts by token that this file never calls the weighted
## selector directly, because reaching around the continuation would be a second,
## subtly different copy of a rule that already exists.
##
## THE RANK TRANSITION IS FROZEN HERE, AND IT IS MEASURED RATHER THAN CALCULATED.
## An offer records the rank the decided pair held when it was composed and the
## rank it would hold after it is taken, because a later resolver can only refuse
## an offer that no longer matches its run by comparing the two. This file does
## NOT work those numbers out from the decision's kind — that would be a second
## copy of the ranked-ownership rules living inside a composer. It STAGES the
## decided operation on a PRIVATE DUPLICATE of the supplied acquisition record,
## through that record's own accepted API, and READS the two ranks back off it.
## The duplicate is discarded; the supplied record is observationally unchanged,
## which the suite measures in both the success and the refusal direction.
##
## IF THE DECISION CANNOT BE STAGED EXACTLY AS IT WAS CLASSIFIED, THE SUPPORT
## LANE REFUSES AND THE WHOLE OFFER REFUSES WITH IT. No partial offer, no
## guessed transition, no silent reclassification.
##
## IT NAMES NOTHING CONCRETE, AND THE SUITE SCANS THE RAW SOURCE TO PROVE IT. No
## Skill, no class, no support, no card, no catalogue, no review instrument and
## no presentation name of any record appears here in code or in a comment.
## Everything it works on arrives as arguments. A composer that knows one card's
## name is a composer that can be tuned for it, and the tuning would then live in
## the mechanism rather than in the record.
##
##
## THE FIXED SHAPE, AND WHY IT CANNOT FLEX
## ---------------------------------------------------------------------------
## A successful offer is exactly one support lane, one Combat and Defence lane
## and one Utility lane, in that order, always. A missing support is NEVER
## replaced by a second passive and a missing passive is never replaced by
## anything at all: if any lane cannot be resolved, the OFFER refuses. An offer
## whose shape depends on what happened to be available is an offer a player
## cannot learn, and a composer that quietly substitutes is a balance decision
## wearing a mechanism's clothes.
##
## ONE SUBSTITUTION IS NOW AUTHORIZED, AND IT IS NAMED RATHER THAN SLIPPED IN
## (Roguelite Foundation I7, decision D-306). A support lane with NO compatible
## pair is still never replaced by anything. A support lane that is EXHAUSTED —
## every compatible pair already held at its maximum rank — carries one passive
## card chosen by the accepted exhausted-support fallback: a third card, never a
## copy of either passive lane's, in the same first position. The shape is still
## 1 + 1 + 1, and the policy that fills it is the project owner's, not this file's.
##
##
## THREE LANES, THREE DOMAINS, AND DELIBERATELY NOT ONE STREAM
## ---------------------------------------------------------------------------
## Each lane's seed is derived from the ROOT SEED and a FIXED LANE DOMAIN, and
## from nothing else:
##
##     lane seed = mix((root seed & 0xFFFFFFFF) XOR the lane's domain)
##
## THE ALTERNATIVE — one sequential stream drawn three times — WOULD HAVE BEEN
## SIMPLER AND WOULD HAVE BEEN WRONG. A sequential stream makes each lane's
## result depend on how many values the lanes before it consumed, so adding one
## candidate to the support pool would silently move both passive lanes, and a
## reviewer comparing two offers could not tell a weight change from a
## rearranged stream. Here a lane's seed depends on the root seed alone, so
## nothing that happens in one lane's pool can reach another lane at all. That is
## a property of the derivation rather than a discipline the code has to keep.
##
## THE THREE LANE SEEDS ARE ALWAYS DISTINCT, BY CONSTRUCTION RATHER THAN BY LUCK.
## `_mix()` is a bijection on the 32-bit range — every step is invertible: an
## xor with a right shift, and a multiplication by an odd constant modulo 2^32 —
## so two distinct domains xored against one root can never mix to one value.
## The suite measures it over a corpus anyway, because a proof in a comment and a
## measurement are different kinds of evidence.
##
## THE DOMAIN VALUES ARE PART OF THE SHIPPED CONTRACT. Once an offer can be
## reproduced from a seed, changing a domain changes every offer every seed has
## ever produced. They are pinned by the suite for exactly that reason.
##
## THE NESTED SELECTORS' OWN STREAM SEPARATION IS UNTOUCHED AND SITS BELOW THIS
## ONE. The support selector splits its lane seed into a Skill stream and a
## support stream; the passive selector salts its ticket by the category it was
## asked for. Both are accepted mechanisms, neither is replaced, and this
## derivation composes with them rather than around them.
##
##
## DETERMINISM, AND WHAT IS AND IS NOT PROMISED
## ---------------------------------------------------------------------------
## `compose()` takes an explicit root seed. Nothing here reads a global random
## source, a clock, the filesystem, a node, project settings or any other ambient
## state, and the suite scans this file for every one of those. The same root
## seed with the same inputs returns the same offer forever.
##
## "The same inputs" is exact and includes what is already ACQUIRED, because an
## already-held pair is unavailable to the support lane — so the second offer of
## a session legitimately depends on what was taken from the first. That
## dependency belongs to the support lane alone and cannot reach either passive
## lane, which is measured rather than argued.
##
##
## FAIL CLOSED, ALWAYS, NEVER PARTIALLY, AND ALWAYS BY LANE
## ---------------------------------------------------------------------------
## ALL THREE LANES ARE RESOLVED BEFORE ANY OF THEM IS COMMITTED, and all three
## are resolved even when the first refuses. Both selectors are pure, so
## resolving a lane costs nothing but arithmetic; what it buys is that the lane a
## refusal NAMES is chosen by the fixed lane order rather than by the order this
## function happens to evaluate in, and that a refusal can honestly say how many
## lanes refused rather than only that one did.
##
## WHEN MORE THAN ONE LANE REFUSES, THE FIRST IN LANE ORDER IS NAMED, and the
## reason says how many refused in total. That is stated here rather than left to
## be discovered, exactly as the accepted passive selector states which fault its
## refusals report first.
##
## ONE LANE NOW WAITS FOR TWO OTHERS, AND THE REFUSING LANE MEANS WHAT IT SAYS
## (Foundation I7). An exhausted support lane's fallback excludes the two cards the
## passive lanes carry, so it is attempted only after both have succeeded. If
## either refused, the fallback is never attempted and the support lane has no
## answer of its own: the refusal names the first PASSIVE lane that refused, the
## "N of 3" count counts only lanes that were resolved and refused, and the reason
## says in words that the fallback was not attempted. Once both passive lanes are
## sound, any fallback refusal — fallback-unavailable included — is the support
## lane's.
##
## A REFUSED OFFER EXPOSES NOTHING FROM A LANE THAT SUCCEEDED. Not a Skill, not a
## support, not a card, not a derivation — only the reason, the lane and the root
## seed the question was asked with. A half-filled offer is how a caller ends up
## presenting a card that was never offered.
##
##
## STILL ABSENT, AND DELIBERATELY: no experience, no level threshold, no second
## offer, no choosing, no applying, no acquisition, no rank raise, no passive
## stack state, no per-rank effect, no rank cap, no reroll, no skip, no ban, no
## lock, no luck, no rarity, no pity, no affix group, no UI, no controller
## navigation, no scene, no persistence and no balance. This file composes one
## offer and stops. NOTHING HERE CONSUMES THE OFFER IT COMPOSES: staging is done
## on a discarded duplicate purely to measure, and no run state anywhere is
## moved.
##
## ONE CONDITION IS NO LONGER A REFUSAL AND THE CHANGE IS NAMED RATHER THAN LEFT
## TO BE FOUND: with a small support catalogue, a later offer can legitimately
## find every eligible pair already acquired. That used to refuse the whole
## offer. It now composes, as ONE FURTHER RANK of a held pair, because the
## accepted continuation decision says so. What still refuses is a genuinely
## empty support lane — no compatible pair anywhere, held or not — and that
## refusal is unchanged in shape.
##
## AND ONE CONDITION REFUSED FOR ONE FOUNDATION AND NOW COMPOSES, AND THE CHANGE IS
## NAMED RATHER THAN LEFT TO BE FOUND (Roguelite Foundations I5 and I7, decisions
## D-300 and D-306). Once every compatible pair is held at its maximum rank there
## is nothing new to acquire and nothing held to raise, and the accepted
## continuation reports the support lane EXHAUSTED. Under I5 the whole offer
## refused with it. Under I7 the support lane asks the accepted exhausted-support
## fallback for one passive card instead, as the section below describes. No
## passive LANE is duplicated, no seed is redrawn, no fourth lane appears, and no
## rank beyond a maximum is ever staged.
##
##
## THE EXHAUSTED SUPPORT LANE, IN THE ORDER ITS DEPENDENCY FORCES (Foundation I7)
## ---------------------------------------------------------------------------
##   1. The three lane seeds and the three delegated resolutions are made exactly
##      as before: one root seed, one set of card records, three independent lanes.
##   2. A continuation that DECIDED composes the accepted progression exactly as
##      before, and an ordinary refusal is a support refusal exactly as before.
##   3. A continuation that is coherent and classified EXHAUSTED — its stored
##      classification, never its sentence — activates the fallback, but only once
##      BOTH passive lanes are coherent successes; otherwise the fallback is never
##      called and the offer refuses as the first passive lane that refused.
##   4. With both sound, the accepted fallback is asked with that exact
##      continuation, those two exact selections, the SAME supplied card records
##      and the support lane's OWN seed. A success composes a passive-fallback
##      support lane. Any refusal refuses the whole offer as the support lane, and
##      fallback-unavailable travels as the offer's own classification.
##
## ONE CATALOGUE FEEDS ALL THREE LANES, which is D-305 ruling 3's provenance
## requirement met by construction rather than re-checked: the records the two
## passive lanes drew from are the very records the fallback draws from. It follows
## that the fallback's own malformed-record and over-ceiling refusals cannot be
## reached through this file — the passive lanes validate the same whole set and
## refuse it first, before any seed is read — so its ordinary-refusal branch below
## is defence in depth, and fallback-unavailable is the only refusal the fallback
## can actually give here.

## THE THREE LANE DOMAINS. Distinct, fixed, and stable once shipped: they are
## part of what a root seed MEANS, so changing one would silently rewrite every
## offer ever reproduced from a seed.
##
## The values are the 32-bit fractional parts of the square roots of 2, 3 and 5 —
## the same well-known constants a widely used digest uses for its first three
## words. Nothing about their arithmetic matters beyond their being fixed and
## pairwise distinct; they are chosen from a published set so that no reader has
## to wonder whether a magic number was tuned for an outcome. They are
## deliberately NOT the constant either accepted selector already uses as a
## stream salt, so a lane domain and a nested stream salt can never coincide.
const SUPPORT_LANE_DOMAIN: int = 0x6A09_E667
const COMBAT_DEFENCE_LANE_DOMAIN: int = 0xBB67_AE85
const UTILITY_LANE_DOMAIN: int = 0x3C6E_F372

## What `lane_domain_for()` and `lane_seed_for()` answer for a lane that is not
## one of the three. Negative, so it can never be mistaken for a real domain or a
## real lane seed — both of which are masked to 32 bits and therefore
## non-negative. `compose()` cannot reach it, because it walks the fixed lane
## order; a caller deriving a seed by hand can, and must be told rather than
## handed a plausible number.
const UNRECOGNISED_LANE: int = -1


## THE ENTRY POINT, AND THE WHOLE MECHANISM.
##
## `acquired` may be null, which means nothing has been acquired yet; that is the
## honest reading of an absent record and it is the only defaulting this file
## does — and it is not even done here, but delegated to the accepted support
## selector, which already decided it.
static func compose(
	profiles: Array[SkillTagProfile],
	definitions: Array[SupportDefinition],
	acquired: AcquiredSupports,
	cards: Array[PassiveCardDefinition],
	root_seed: int
) -> RiftOffer:
	# --- Three independent lane seeds, from the root seed alone ---------------
	var support_seed: int = lane_seed_for(root_seed, RiftOffer.Lane.SUPPORT)
	var combat_seed: int = lane_seed_for(root_seed, RiftOffer.Lane.COMBAT_DEFENCE)
	var utility_seed: int = lane_seed_for(root_seed, RiftOffer.Lane.UTILITY)

	# --- Three delegated resolutions, all of them, before any commitment ------
	#
	# Validation of the records themselves belongs to the selectors and is not
	# repeated here: each already refuses a null, a duplicate id, a malformed
	# record and an impossible weight, and each does so over the WHOLE supplied
	# set rather than only over what it went on to draw from. A second copy of
	# those rules here would be a second place for them to disagree.
	#
	# The category each passive lane draws from is read from the single place the
	# lane vocabulary meets the stat vocabulary. If that mapping ever answered
	# something the vocabulary does not declare, the passive selector refuses it
	# by name — which is the delegation working rather than a gap in it.
	var continuation: SupportContinuationResult = SupportContinuation.select(
		profiles, definitions, acquired, support_seed
	)
	var combat: PassiveCardSelectionResult = PassiveCardSelection.select(
		cards, RiftOffer.category_for_lane(RiftOffer.Lane.COMBAT_DEFENCE), combat_seed
	)
	var utility: PassiveCardSelectionResult = PassiveCardSelection.select(
		cards, RiftOffer.category_for_lane(RiftOffer.Lane.UTILITY), utility_seed
	)

	# --- The support lane's frozen rank transition ----------------------------
	#
	# Staged only once the decision itself is sound, because staging an
	# incoherent decision would be asking a question about an answer that does
	# not exist. A staging failure is folded into the SUPPORT lane's own verdict
	# below rather than reported separately, so the fixed lane order still
	# decides which lane a multi-lane refusal names and the "N of 3 lanes
	# refused" arithmetic stays true.
	var support_ok: bool = continuation.ok
	var support_reason: String = continuation.failure_reason
	var support_problem: String = continuation.problem()
	var rank_before: int = RiftOffer.UNRESOLVED_RANK
	var rank_after: int = RiftOffer.UNRESOLVED_RANK
	if support_ok and support_problem.is_empty():
		var staged: Dictionary = _stage_support_progression(acquired, continuation)
		if bool(staged["ok"]):
			rank_before = int(staged["rank_before"])
			rank_after = int(staged["rank_after"])
		else:
			support_ok = false
			support_reason = String(staged["reason"])

	# --- The exhausted support lane's passive fallback (Foundation I7) --------
	#
	# Activated by the continuation's STORED classification and by nothing else,
	# and only once both passive lanes are coherent successes, because the
	# fallback excludes the very cards they carry. It is handed that exact
	# continuation, those two exact selections, the SAME supplied card records the
	# passive lanes drew from, and the support lane's OWN seed. Nothing is redrawn,
	# and no refusal sentence is read to decide anything.
	var exhausted: bool = support_problem.is_empty() and continuation.is_exhausted()
	var passive_lanes_sound: bool = combat.ok and combat.problem().is_empty() \
		and utility.ok and utility.problem().is_empty()
	var fallback: SupportExhaustionPassiveFallbackResult = null
	var fallback_unavailable: bool = false
	if exhausted and passive_lanes_sound:
		var answered: SupportExhaustionPassiveFallbackResult = SupportExhaustionPassiveFallback.select(
			continuation, combat, utility, cards, support_seed
		)
		var answered_problem: String = answered.problem()
		if answered.ok and answered_problem.is_empty():
			fallback = answered
			support_ok = true
			support_reason = ""
			support_problem = answered_problem
		elif answered.is_unavailable():
			fallback_unavailable = true
			support_reason = "%s; and its passive fallback is unavailable: %s" % [
				continuation.failure_reason, answered.failure_reason,
			]
		elif not answered.ok:
			## DEFENCE IN DEPTH, AND UNREACHABLE THROUGH THIS FILE: with one
			## catalogue feeding all three lanes, every input the fallback would
			## refuse is refused first by a passive lane (see the header). It is
			## still a support refusal rather than a silent pass.
			support_reason = "%s; and its passive fallback refused: %s" % [
				continuation.failure_reason, answered.failure_reason,
			]
		else:
			## DEFENCE IN DEPTH, AND UNREACHABLE: the accepted fallback re-derives
			## every success it returns.
			support_reason = "%s; and its passive fallback is incoherent: %s" % [
				continuation.failure_reason, answered_problem,
			]

	# --- Refuse the whole offer if any lane did, naming the lane --------------
	#
	# THE SUPPORT ROW IS LEFT OUT EXACTLY WHEN THE SUPPORT LANE WAS NEVER RESOLVED
	# (Foundation I7): an exhausted lane whose fallback was not attempted because a
	# passive lane it depends on refused. Such a lane has no answer of its own, so
	# it is neither named nor counted. In every other case the three rows are the
	# three rows they always were.
	var support_resolved: bool = not exhausted or passive_lanes_sound
	var rows: Array = []
	if support_resolved:
		rows.append([RiftOffer.Lane.SUPPORT, support_ok, support_reason, support_problem])
	rows.append([RiftOffer.Lane.COMBAT_DEFENCE, combat.ok, combat.failure_reason, combat.problem()])
	rows.append([RiftOffer.Lane.UTILITY, utility.ok, utility.failure_reason, utility.problem()])
	var refusals: PackedStringArray = PackedStringArray()
	var refusing_lanes: Array[int] = []
	for row: Array in rows:
		var lane: int = int(row[0])
		if not bool(row[1]):
			refusing_lanes.append(lane)
			refusals.append("the %s lane refused: %s" % [
				RiftOffer.lane_label(lane), String(row[2]),
			])
			continue
		## DEFENCE IN DEPTH, AND DELIBERATELY UNREACHABLE TODAY: a selector that
		## reported success while contradicting its own reported derivation would
		## be committed here without this. Both accepted selectors re-derive their
		## own answers, so no supplied input can drive this branch and the suite
		## does not pretend to drive it. It stays because a composer that trusts
		## a `true` without asking what it is a `true` about is how an incoherent
		## lane reaches a player.
		if not String(row[3]).is_empty():
			refusing_lanes.append(lane)
			refusals.append("the %s lane returned an incoherent selection: %s" % [
				RiftOffer.lane_label(lane), String(row[3]),
			])

	if not refusing_lanes.is_empty():
		var reason: String = refusals[0]
		if refusing_lanes.size() > 1:
			reason += " (%d of %d lanes refused)" % [
				refusing_lanes.size(), RiftOffer.LANE_ORDER.size(),
			]
		if not support_resolved:
			reason += "; the exhausted Support lane's passive fallback was not attempted"
		if fallback_unavailable and refusing_lanes[0] == RiftOffer.Lane.SUPPORT:
			return RiftOffer.refused_as_fallback_unavailable(reason, root_seed)
		return RiftOffer.refused(reason, refusing_lanes[0], root_seed)

	var lane_seeds: Array[int] = [support_seed, combat_seed, utility_seed]
	if fallback != null:
		return RiftOffer.composed_with_passive_fallback(
			root_seed, lane_seeds, continuation, fallback, combat, utility)
	return RiftOffer.composed(
		root_seed, lane_seeds, continuation, rank_before, rank_after, combat, utility)


## THE FROZEN RANK TRANSITION, MEASURED ON A DISCARDED DUPLICATE.
##
## Returns `{ok, reason, rank_before, rank_after}`. It applies the operation the
## accepted continuation decision ALREADY CLASSIFIED — it does not reclassify,
## and it does not choose. Nothing that survives this function was mutated: the
## duplicate is local, the supplied record is never touched, and a null record is
## read as an empty one exactly as every accepted mechanism above reads it.
##
## IT DERIVES NO RANK ARITHMETIC OF ITS OWN, WHICH IS THE POINT. The before-rank
## and the after-rank are both READ back from the accepted ranked-ownership
## record through its own accessor, on either side of that record's own accepted
## operation. So "a new pair begins at the first rank" and "a rank increase steps
## by exactly one" are facts this function OBSERVES rather than rules it repeats,
## and they stay true if that record ever changes what they are.
##
## THE TWO REFUSALS ARE DEFENCE IN DEPTH AND CANNOT BE REACHED THROUGH THE
## ACCEPTED DECISION, WHICH IS STATED RATHER THAN HIDDEN. A new-pair decision is
## classified only for a pair the record does not hold, so acquiring it cannot
## fail; a rank decision is classified only for a pair it does, so raising it can
## fail only at the record's representational ceiling, which is the engine's
## largest positive integer and is unreachable by counting. No seam was
## manufactured to drive either, and the suite pins them structurally and says
## so — the same rule the ranked-ownership record's own suite applies to that
## ceiling. They stay because a composer that trusted a classification it had not
## applied is how an offer promising rank 3 quietly raises rank 7.
static func _stage_support_progression(
	acquired: AcquiredSupports,
	continuation: SupportContinuationResult
) -> Dictionary:
	var staged: AcquiredSupports = acquired.duplicated() if acquired != null \
		else AcquiredSupports.new()
	var skill_id: StringName = continuation.skill_id
	var support_id: StringName = continuation.support_id
	var before: int = staged.rank_for(skill_id, support_id)
	var applied: bool = false
	match continuation.kind:
		SupportContinuationResult.Kind.NEW_PAIR:
			applied = staged.acquire(skill_id, support_id)
		SupportContinuationResult.Kind.RANK_INCREASE:
			applied = staged.increase_rank(skill_id, support_id)
	if not applied:
		return {
			"ok": false,
			"reason": "%s -> %s could not be staged as %s against the supplied acquisition state"
				% [skill_id, support_id,
					SupportContinuationResult.kind_label(continuation.kind)],
			"rank_before": RiftOffer.UNRESOLVED_RANK,
			"rank_after": RiftOffer.UNRESOLVED_RANK,
		}
	var after: int = staged.rank_for(skill_id, support_id)
	if after != before + 1:
		return {
			"ok": false,
			"reason": "staging %s -> %s as %s moved its rank %d -> %d rather than by one step"
				% [skill_id, support_id,
					SupportContinuationResult.kind_label(continuation.kind), before, after],
			"rank_before": RiftOffer.UNRESOLVED_RANK,
			"rank_after": RiftOffer.UNRESOLVED_RANK,
		}
	return {"ok": true, "reason": "", "rank_before": before, "rank_after": after}


# --- The lane-domain contract ---------------------------------------------------

## One lane's fixed domain, or `UNRECOGNISED_LANE`. The only place a lane is
## paired with its domain, so the three constants above cannot be applied to the
## wrong lane in one call site and the right one in another.
static func lane_domain_for(lane: int) -> int:
	match lane:
		RiftOffer.Lane.SUPPORT:
			return SUPPORT_LANE_DOMAIN
		RiftOffer.Lane.COMBAT_DEFENCE:
			return COMBAT_DEFENCE_LANE_DOMAIN
		RiftOffer.Lane.UTILITY:
			return UTILITY_LANE_DOMAIN
	return UNRECOGNISED_LANE


## THE DERIVATION, AND IT IS PUBLIC ON PURPOSE. A caller — and a reviewer holding
## nothing but an offer's reported root seed — can recompute any lane's seed
## without running the composer, which is what makes the reported lane seeds
## checkable rather than merely present.
##
## Masked to 32 bits, so a lane seed is always non-negative and can never be
## confused with `UNRECOGNISED_LANE`.
static func lane_seed_for(root_seed: int, lane: int) -> int:
	var domain: int = lane_domain_for(lane)
	if domain == UNRECOGNISED_LANE:
		return UNRECOGNISED_LANE
	return _mix((root_seed & 0xFFFFFFFF) ^ domain)


## The standard 32-bit avalanche finalizer.
##
## THIS IS THE FOURTH COPY OF THIS ARITHMETIC IN THE PROJECT, AND THE DUPLICATION
## IS DELIBERATE, STATED, AND RECORDED DEBT RATHER THAN A DISCOVERY WAITING TO BE
## MADE. The same finalizer already exists inside a temporary review instrument
## and inside each of the two accepted selectors this file delegates to. Calling
## either selector's copy would couple this composition to another mechanism's
## private internals — a rename there would break a lane seed here, silently
## rewriting every offer — and extracting a shared one would mean editing
## accepted files this work is not authorized to touch. So the same arithmetic
## exists a fourth time, on purpose, and the suite MEASURES that all four copies
## still agree rather than assuming they do.
static func _mix(value: int) -> int:
	var x: int = value & 0xFFFFFFFF
	x = (x ^ (x >> 16)) * 0x7FEB_352D & 0xFFFFFFFF
	x = (x ^ (x >> 15)) * 0x846C_A68B & 0xFFFFFFFF
	x = x ^ (x >> 16)
	return x & 0xFFFFFFFF
