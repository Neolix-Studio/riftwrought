class_name SupportContinuation
extends RefCounted
## Riftwrought — Roguelite Foundation F2: deterministic support-lane
## CONTINUATION selection — should the lane offer a new compatible pair, or
## another rank of a pair that is already held, and which pair is it?
##
## THE ONE QUESTION THIS FILE ANSWERS, and it answers no other. Given the
## equipped Skills' tag profiles, the support definitions, what is already held,
## and one explicit seed, it returns exactly one of four things: a NEW PAIR
## decision, a RANK INCREASE decision, an EXHAUSTED refusal (Foundation I5,
## D-300), or an ordinary refusal. It composes nothing, it consumes nothing, it
## applies nothing, it records nothing, and nothing that runs calls it except the
## accepted three-lane composer's support lane.
##
##
## THE POLICY, WRITTEN ONCE SO IT CAN BE QUOTED
## ---------------------------------------------------------------------------
## Selection has exactly two phases of availability, the first one is GLOBAL,
## and since Foundation I5 the second one is bounded:
##
##   1. NEW-PAIR PHASE. If at least one unacquired eligible pair exists ANYWHERE
##      among the equipped Skills, a new pair is selected. No already-held pair
##      may be returned.
##   2. RANK PHASE. Only when no unacquired eligible pair exists anywhere, but
##      at least one eligible pair does exist, is an already-held pair selected
##      to gain one rank — and only a pair still BELOW the maximum rank its
##      support declares. A pair at its maximum is not a candidate.
##   3. EXHAUSTION. When compatible pairs exist and every one of them is held at
##      its maximum rank, there is nothing to select at all. That is an explicit,
##      machine-readable EXHAUSTED refusal: not a decision, not a malformed
##      input, and never a rank that nothing has defined.
##
## "GLOBAL" IS THE WHOLE POINT OF THE FIRST PHASE AND IT IS EASY TO GET WRONG. A
## Skill whose compatible supports are exhausted must NOT receive rank offers
## while another equipped Skill still has a new compatible support available.
## The tempting implementation asks the question per Skill and falls through to
## ranking for whichever Skill the draw happened to land on; that would make an
## exhausted Skill silently outrank a Skill with something new to give, purely
## because a ticket pointed at it. Here the question is asked of the WHOLE pool
## first, and the fall-through is unreachable until every eligible pair anywhere
## is held.
##
## THE PHASE ADVANCES ONLY ON ABSENCE, NEVER ON FAILURE (Foundation I5 correction,
## D-301). The rank phase is entered only when the accepted selector reports, in its
## result's machine-readable classification, that the VALID new-pair candidate set
## is EMPTY. A new-pair draw that refused for any other reason — a malformed profile
## or definition, a definition without a usable maximum, an invalid acquisition
## state, an unusable weight, a ladder over the ceiling — refuses the whole
## continuation, here, with no pair, no rank and no exhaustion. The first delivery
## advanced after ANY refusal it could not otherwise explain, so a pool over the
## weight ceiling on one Skill could send the lane on to raise a held pair while
## another Skill still had a new compatible pair — the one outcome the global rule
## above forbids. Absence and invalidity are now two different results, told apart
## by a classification rather than by a sentence.
##
## A RANK DECIDES ONLY WHETHER A HELD PAIR CAN STILL BE RAISED, AND THIS FILE DOES
## NOT DECIDE EVEN THAT. A rank does not alter eligibility, a support's weight, a
## Skill's probability or a ticket ladder: every pair below its maximum owns
## exactly the tickets it always owned, whatever its rank. Whether a pair is below
## its maximum is asked of the accepted weighted selector's rank-increase mode,
## which owns that one rule, so nothing in this file reads a rank at all.
##
##
## IT DELEGATES; IT DOES NOT FORK
## ---------------------------------------------------------------------------
## Every piece of the decision that the accepted weighted selector already owns
## is asked OF that selector: validation, eligibility, stable sorting, the
## two-stage draw, the effective-weight model, ticket reduction, the seed mixer,
## the weight ceiling, the maximum-rank rule, the acquisition-state rule and every
## failure rule. None of it is copied here, none of it is restated here, and none of
## it is re-implemented here. A second, subtly different copy of an accepted
## mechanism is the one outcome this file exists to avoid.
##
## THE DELEGATION SEQUENCE, EXACTLY
## ---------------------------------------------------------------------------
##   1. Run the accepted selector with the REAL acquisition state. A success is the
##      new-pair decision. Done.
##   2. If it refused for anything but a VALID EMPTY CANDIDATE SET, refuse here:
##      the rank phase is never entered.
##   3. Otherwise ask the accepted selector's RANK-INCREASE mode, with the SAME seed,
##      against the REAL acquisition state. A success is the rank decision.
##   4. If that refused for anything but a valid empty candidate set, refuse,
##      quoting it.
##   5. Both candidate sets are validly empty. ASK the accepted selector whether the
##      lane is exhausted — at least one eligible pair, every one at exactly its
##      maximum. If it is, return EXHAUSTED.
##   6. Otherwise no compatible pair exists at all: refuse.
##
## EVERY PHASE DECISION READS A CLASSIFICATION AND NEVER A SENTENCE. Refusal text
## is quoted, never inspected, matched, split or classified — rewording an accepted
## refusal is a documentation change with no behavioural intent, and it must never
## change which decision this foundation makes.
##
## ONE QUERY IS ASKED ONLY TO WORD A REFUSAL, AND IT DECIDES NOTHING. When the
## continuation refuses in step 2 or step 6, the accepted selector is asked the same
## question against an EMPTY acquisition record. If that refuses too, the accepted
## diagnostic says so — "and with nothing acquired the same inputs still refuse" —
## because the sentence is then true; if it succeeds, only the first refusal is
## quoted, because the sentence would not be. Either way the continuation has
## already refused: this query chooses words, not a phase. Before D-301 the same
## query also chose the pair to raise (until D-300) and then supplied a witness for
## an incoherence guard; the classification made both roles unnecessary, and the
## guard's one reachable case — the ceiling overflow above — now refuses in step 2.
##
## THE SEED IS THE SAME FOR EVERY QUERY, AND NOTHING IS ADDED TO IT. No salt,
## no mixer, no second stream, no random source, no retry, no reroll and no
## ticket adjustment. The rank phase therefore selects exactly what the accepted
## rank-increase selection selects for that seed against the real record, which
## is a property a reviewer can check by making that one call by hand.
##
##
## IT NAMES NOTHING CONCRETE. No Skill, no support, no card, no class, no review
## instrument and no presentation name appears here in code or in a comment, and
## the suite scans the raw source to prove it. Everything it works on arrives as
## an argument.
##
## IT READS NO RANK. The accepted ranked-ownership state remains the single
## authority for what a pair currently holds; this file asks only whether a pair
## is held, through the accepted membership query, and leaves every question about
## a rank to the accepted selector — so a rank cannot leak into a decision through
## this seam by any second route.
##
## IT IS PURE. Nothing here writes, records, acquires, consumes, mutates an
## argument, reads a clock, a file, a node, project settings or a global random
## source. Asking the same question twice returns the same answer forever.
##
##
## STILL ABSENT, AND DELIBERATELY: any fallback for an exhausted lane — a
## substitute card, a reroll, a refund or an invented rank; consuming a rank
## choice; raising a rank; multiple level-ups; support effects; per-rank values;
## rarity, luck, pity, synergy or balance; UI, scenes, input, saving and
## persistence. Each is its own decision with its own authorization.


## THE SEEDED ENTRY POINT, AND THE ONLY ONE. `acquired` may be null, which keeps
## the accepted selector's own meaning of "nothing has been acquired yet" — and
## with nothing acquired there is nothing to rank, so a null state can only ever
## produce a new-pair decision or a refusal.
static func select(
	profiles: Array[SkillTagProfile],
	definitions: Array[SupportDefinition],
	acquired: AcquiredSupports,
	seed_value: int
) -> SupportContinuationResult:
	## The state every membership question below is asked of. The accepted selector
	## already reads a null record as an empty one; this mirrors that reading so the
	## two cannot disagree.
	var held: AcquiredSupports = acquired if acquired != null else AcquiredSupports.new()

	## The refusal the lane quotes if it cannot continue. Stays null on every path
	## that returns a decision or a more specific refusal.
	var cannot_continue: SupportSelectionResult = null

	# --- Phase 1: is there anything NEW anywhere? ----------------------------
	#
	# Asked of the WHOLE equipped set through the accepted selector, using the
	# real acquisition state. The accepted stage one excludes a Skill with no
	# AVAILABLE eligible support, so this one call answers the global question.
	var new_pair_selection: SupportSelectionResult = SupportSelection.select(
		profiles, definitions, acquired, seed_value
	)
	if new_pair_selection.ok:
		## MEASURED, NOT ASSUMED. The accepted selector filters held pairs out of
		## its own pool, so this is false for every pair it can return; asking
		## anyway is what lets the result's own coherence rule catch a violation
		## of that guarantee instead of restating it.
		return SupportContinuationResult.new_pair(
			new_pair_selection,
			held.has(new_pair_selection.skill_id, new_pair_selection.support_id)
		)

	if not new_pair_selection.has_no_candidates():
		## THE INPUTS COULD NOT BE DRAWN FROM, WHICH IS NOT THE SAME AS NOTHING BEING
		## AVAILABLE. The rank phase is not entered (D-301).
		cannot_continue = new_pair_selection
	else:
		# --- Phase 2: the new-pair set is validly empty; raise a held pair ------
		#
		# Asked of the accepted selector's rank-increase mode, against the REAL
		# record, with the same seed. It owns the maximum-rank rule; this file asks.
		var rank_selection: SupportSelectionResult = SupportSelection.select_rank_increase(
			profiles, definitions, acquired, seed_value
		)
		if rank_selection.ok:
			## MEASURED, NOT ASSUMED, exactly as the new-pair classification is.
			return SupportContinuationResult.rank_increase(
				rank_selection,
				held.has(rank_selection.skill_id, rank_selection.support_id)
			)
		if not rank_selection.has_no_candidates():
			return SupportContinuationResult.failed(
				"the support lane cannot continue: no new pair is available, and the rank query refuses: %s"
					% rank_selection.failure_reason
			)

		# --- Both sets validly empty: exhaustion, proved rather than parsed -----
		if SupportSelection.is_rank_exhausted(profiles, definitions, acquired):
			return SupportContinuationResult.exhaustion(
				"the support lane is exhausted: every compatible support pair is already held at its maximum supported rank, so nothing new can be selected and nothing held can be raised"
			)
		## Nothing is exhausted because nothing compatible exists at all.
		cannot_continue = new_pair_selection

	# --- The lane cannot continue: word the refusal, decide nothing -----------
	#
	# The continuation has already refused. This query only establishes whether the
	# accepted diagnostic's second sentence is TRUE for these inputs.
	var empty_record_selection: SupportSelectionResult = SupportSelection.select(
		profiles, definitions, AcquiredSupports.new(), seed_value
	)
	if empty_record_selection.ok:
		return SupportContinuationResult.failed(
			"the support lane cannot continue: %s" % cannot_continue.failure_reason
		)
	return SupportContinuationResult.failed(
		"the support lane cannot continue: %s; and with nothing acquired the same inputs still refuse: %s"
			% [cannot_continue.failure_reason, empty_record_selection.failure_reason]
	)
