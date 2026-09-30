class_name SupportContinuationResult
extends RefCounted
## Riftwrought — Roguelite Foundation F2: the outcome of one support-lane
## continuation decision, and everything needed to explain it afterwards.
##
## THE ONE QUESTION THIS RECORD ANSWERS: which PROGRESSION OPERATION was chosen,
## and on which pair? There are exactly two operations — offer a compatible pair
## that is not held yet, or offer another rank of a pair that is already held —
## and they are distinguished MECHANICALLY by `kind` rather than by reading a
## sentence. A caller that must branch on which of the two happened reads an
## enum member; a caller that must explain it to a person reads `describe()`.
##
## AND SINCE FOUNDATION I5 (D-300) ONE REFUSAL IS CLASSIFIED: EXHAUSTION. When
## compatible pairs exist and every one of them is held at its maximum rank there
## is nothing to decide — no new pair to offer and no held pair to raise. That is
## not a third operation, not a malformed input and not a fallback, so it is a
## REFUSAL, and `exhausted` is the one stored fact that tells it apart from every
## other refusal. A caller branches on `is_exhausted()`; nothing anywhere reads the
## sentence to find out.
##
## IT HOLDS THE ACCEPTED DERIVATION ITSELF RATHER THAN A COPY OF IT. The
## accepted weighted selector already returns a result carrying its whole
## derivation — the two tickets, the ladder total, the base weight, the bonuses
## that matched and the effective weight — and that result re-checks itself
## through its own `problem()`. Restating any of it here would create a second
## place for one fact to be written and therefore a way for the two to disagree,
## so the object the accepted selector returned is kept exactly as it was
## returned and `problem()` re-asks it whether it is coherent rather than
## believing that it is. That is the same reading the accepted three-lane offer
## records for the same nested result.
##
## THE TWO IDENTITY FIELDS ARE A DELIBERATE CONVENIENCE AND ARE PROVED AGAINST
## THE DERIVATION RATHER THAN TRUSTED. `skill_id` and `support_id` are what a
## caller actually wants, and reaching two objects deep for each of them is how
## a caller starts copying them somewhere else. They are required to EQUAL the
## nested result's own answers, checked in `problem()`, so the convenience
## cannot drift from the derivation it summarises.
##
## WHAT IT DELIBERATELY DOES NOT CARRY, AND WHY EACH ABSENCE IS A DECISION
## ---------------------------------------------------------------------------
## NO CURRENT RANK AND NO NEXT RANK. This record says which operation was
## chosen. The accepted ranked-ownership state remains the single authority for
## what any pair currently holds, and a number copied out of it into here would
## be a second copy of a fact that can move. An EXHAUSTED refusal carries no rank
## either: which rank every pair stopped at is the definitions' and the held
## record's to say, not this record's.
##
## NO EFFECT MAGNITUDE AND NO PRESENTATION TEXT beyond the plain descriptions
## below. A rank applies no mechanical effect yet, and inventing a magnitude
## here would be inventing balance inside a mechanism.
##
## NO ACQUISITION SNAPSHOT. Classifying a decision as a rank increase requires
## knowing that the pair really is held, but RETAINING the live record that
## answered that question would hand every reader a mutable collection it was
## only given to read, and would let a later mutation silently make a finished
## result describe a state that no longer exists. So exactly one SCALAR fact is
## kept — `held_when_classified` — which is what the coherence rule below
## actually needs and nothing more.
##
## SUCCESS AND FAILURE ARE THE SAME TYPE AND CANNOT BE CONFUSED. `ok` is the one
## flag, `failure_reason` is empty exactly when `ok` is true, and A FAILED
## RESULT CARRIES NO DECISION AT ALL: no kind, no Skill, no support, and no
## nested derivation. A half-filled result is how a caller ends up acting on a
## pair that was never chosen, so the two refusal constructors are the only ways
## to build one and they set nothing else — `exhaustion()` sets exactly one fact
## more than `failed()`, and that fact is the classification.
##
## IT IS INERT. No node, no signal, no clock, no random source, no file. It
## describes a decision that has already been made and makes none of its own.

## The two progression operations the support lane can offer, and there are
## exactly two. A third would be a different decision with its own
## authorization.
enum Kind {
	## A compatible pair that is not held yet.
	NEW_PAIR,
	## Another rank of a pair that is already held.
	RANK_INCREASE,
}

## What `kind` reads as when nothing was decided. Deliberately outside every
## declared member, so a caller that reads it without reading `ok` gets a value
## that is obviously wrong rather than one that is quietly plausible.
const UNRESOLVED_KIND: int = -1


var ok: bool = false

## Empty exactly when `ok`. Otherwise the single plain-language reason.
var failure_reason: String = ""

## A `Kind` member on success, `UNRESOLVED_KIND` on a refusal.
var kind: int = UNRESOLVED_KIND

# --- What was decided ---------------------------------------------------------

var skill_id: StringName = &""
var support_id: StringName = &""

## The accepted weighted selection that produced the pair, kept exactly as it
## was returned. Null on a refusal.
var selection: SupportSelectionResult = null

## Whether the selected pair was ALREADY HELD at the moment this decision was
## classified. It is MEASURED against the supplied acquisition state rather than
## inferred from `kind`, which is what makes the coherence rule below a real
## check instead of a restatement: a rank decision whose pair was not held, or a
## new-pair decision whose pair was, is reported as incoherent.
var held_when_classified: bool = false

## Whether this REFUSAL is the support lane's valid exhaustion — every compatible
## pair held at its maximum rank — rather than a malformed input, an absent pool or
## an incoherence (Foundation I5, D-300). Set only by `exhaustion()`, and only after
## the accepted selector has PROVED the exhaustion; never inferred from a sentence.
## Always false on a success, which `problem()` requires.
var exhausted: bool = false


## The only way to build an ordinary refusal. It deliberately sets nothing but
## the reason, so no decision can be read out of a result that decided nothing.
static func failed(reason: String) -> SupportContinuationResult:
	var result: SupportContinuationResult = SupportContinuationResult.new()
	result.ok = false
	result.failure_reason = reason if not reason.strip_edges().is_empty() \
		else "the continuation failed for an unstated reason"
	return result


## The only way to build an EXHAUSTED refusal. Exactly `failed()` plus the one
## classification: no kind, no Skill, no support, no derivation, no rank and no
## partial choice — only the reason and the fact that the lane is exhausted.
static func exhaustion(reason: String) -> SupportContinuationResult:
	var result: SupportContinuationResult = SupportContinuationResult.new()
	result.ok = false
	result.exhausted = true
	result.failure_reason = reason if not reason.strip_edges().is_empty() \
		else "every compatible support pair is already held at its maximum rank"
	return result


## A compatible pair that is not held yet. `was_held` is the MEASURED answer
## rather than the assumed one; passing true here is an incoherent result and
## `problem()` says so.
static func new_pair(
	from_selection: SupportSelectionResult,
	was_held: bool
) -> SupportContinuationResult:
	return _decided(Kind.NEW_PAIR, from_selection, was_held)


## Another rank of a pair that is already held.
static func rank_increase(
	from_selection: SupportSelectionResult,
	was_held: bool
) -> SupportContinuationResult:
	return _decided(Kind.RANK_INCREASE, from_selection, was_held)


static func _decided(
	for_kind: int,
	from_selection: SupportSelectionResult,
	was_held: bool
) -> SupportContinuationResult:
	var result: SupportContinuationResult = SupportContinuationResult.new()
	result.ok = true
	result.failure_reason = ""
	result.kind = for_kind
	result.selection = from_selection
	result.skill_id = from_selection.skill_id if from_selection != null else &""
	result.support_id = from_selection.support_id if from_selection != null else &""
	result.held_when_classified = was_held
	return result


# --- Reading the decision ------------------------------------------------------

func is_new_pair() -> bool:
	return ok and kind == Kind.NEW_PAIR


func is_rank_increase() -> bool:
	return ok and kind == Kind.RANK_INCREASE


## Whether the support lane is exhausted: a refusal, classified as such when it was
## built. Read from the stored fact, never from `failure_reason`.
func is_exhausted() -> bool:
	return not ok and exhausted


## The decided pair, or "" when nothing was decided. Useful as a comparison key
## without reaching into two fields.
func pair() -> String:
	if not ok:
		return ""
	return "%s -> %s" % [skill_id, support_id]


## Presentation only, and never used to decide anything. `kind` is the
## mechanical answer.
static func kind_label(for_kind: int) -> String:
	match for_kind:
		Kind.NEW_PAIR:
			return "a new compatible pair"
		Kind.RANK_INCREASE:
			return "another rank of a held pair"
		_:
			return "no decision"


## Returns "" when the result is internally coherent, or the first inconsistency
## found. This exists because the fields above are a DERIVATION plus a
## classification, and neither is worth anything if it is never re-checked
## against the accepted result it was derived from.
func problem() -> String:
	if not ok:
		if failure_reason.strip_edges().is_empty():
			return "a failed result must state a reason"
		if kind != UNRESOLVED_KIND:
			return "a failed result must declare no decision kind"
		if not String(skill_id).is_empty() or not String(support_id).is_empty():
			return "a failed result must not name a selection"
		if selection != null:
			return "a failed result must carry no partial derivation"
		if held_when_classified:
			return "a failed result must classify nothing as held"
		return ""
	if exhausted:
		return "a successful result must not declare the support lane exhausted"
	if not failure_reason.is_empty():
		return "a successful result must state no failure reason"
	if kind != Kind.NEW_PAIR and kind != Kind.RANK_INCREASE:
		return "a successful result declares the unknown decision kind %d" % kind
	if String(skill_id).is_empty() or String(support_id).is_empty():
		return "a successful result must name both a Skill and a support"
	if selection == null:
		return "a successful result must carry the selection that produced it"
	if not selection.ok:
		return "a successful result carries a failed selection: %s" % selection.failure_reason
	var nested: String = selection.problem()
	if not nested.is_empty():
		return "the nested selection is incoherent: %s" % nested
	if skill_id != selection.skill_id or support_id != selection.support_id:
		return "%s does not match the selection's own %s" % [pair(), selection.pair()]
	if kind == Kind.RANK_INCREASE and not held_when_classified:
		return "a rank increase names %s, which was not held when it was classified" % pair()
	if kind == Kind.NEW_PAIR and held_when_classified:
		return "a new pair names %s, which was already held when it was classified" % pair()
	return ""


func describe() -> String:
	if not ok:
		if exhausted:
			return "support lane exhausted — %s" % failure_reason
		return "no continuation — %s" % failure_reason
	return "%s: %s (%s)" % [kind_label(kind), pair(), selection.describe()]
