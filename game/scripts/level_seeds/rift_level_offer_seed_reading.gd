class_name RiftLevelOfferSeedReading
extends RefCounted
## Riftwrought — Roguelite Foundation G2: one answer to "which root seed should
## this run's offer at this Rift level be composed from?", as a pure VALUE.
##
## WHY A TYPE RATHER THAN A NUMBER. A bare integer cannot say "there is no offer
## seed for that level", and every integer it could return instead is a
## real-looking answer: zero is a perfectly good seed, and so is every other
## non-negative 32-bit number. So the answer comes back with `ok`, and
## `failure_reason` is non-empty exactly when `ok` is false.
##
## A REFUSED READING CARRIES NO USABLE SEED. Its stored seed is `UNRESOLVED_SEED`,
## which is -1, and -1 is unambiguous here for one reason: every seed a derivation
## can produce lies in 0 … `LARGEST_OFFER_ROOT_SEED`, so a negative number is a
## value no successful reading can ever hold.
##
## THAT DISTINCTION EXISTS ONLY INSIDE THIS TYPE, AND IT IS STATED RATHER THAN
## LEFT TO BE FOUND. The accepted offer composer masks every root seed it is
## handed to its low 32 bits, so a -1 handed onward WITHOUT asking `ok` is read
## there as 2^32 - 1 — a real seed, and one a successful reading can itself carry.
## -1 is therefore safe to STORE beside `ok`, and it is NOT safe to hand onward
## as a number: `ok` is the authority, and a caller must ask it first.
##
## THE QUESTION TRAVELS WITH THE ANSWER. The original signed run seed and the
## requested level are kept on a success AND on a refusal, because they are the
## two inputs a reader needs to ask the question again. A reading is therefore
## its own reproduction receipt: asking again with its `run_seed` and its `level`
## gives the same answer.
##
## IT OWNS NO FORMULA. It records what was asked and what was answered; which
## seed belongs to which run and level is decided by the derivation alone, and
## re-deriving it here would either restate that rule a second time or make the
## two files name each other. `problem()` checks this value's own SHAPE — never
## whether its seed is the right one for its run and level. The suite proves
## that.
##
## IT IS INERT. Scalar fields only — no collection, no object reference, no
## node, no signal, no clock, no random source, no file. It describes an answer
## that has already been given and performs nothing.

## The width of the seed the accepted offer composer actually uses. That composer
## masks every root seed it is handed to its low 32 bits, so its effective seed
## domain is 32 bits wide, and a derived seed never needs to be wider.
const UNSIGNED_SEED_BITS: int = 32

## 2^32 - 1: the largest root seed a successful reading may carry. Every whole
## number from zero up to this one is a distinct seed in the composer's domain.
## A representation boundary, never a level cap and never a balance value.
const LARGEST_OFFER_ROOT_SEED: int = (1 << UNSIGNED_SEED_BITS) - 1

## What a refused reading carries as its seed. Negative, because every derived
## seed is non-negative; see the header for why it is unambiguous only beside
## `ok`.
const UNRESOLVED_SEED: int = -1

var ok: bool = false

## Non-empty exactly when `ok` is false. Otherwise the single plain-language
## reason, naming what was refused rather than merely that something was.
var failure_reason: String = ""

## The signed 64-bit run seed the question was asked with, exactly as given — on
## a success and, as diagnostic input, on a refusal as well.
var run_seed: int = 0

## The current Rift level the question was asked about — on a success and, as
## diagnostic input, on a refusal as well.
var level: int = 0

## The derived root seed for that level's offer, in 0 … `LARGEST_OFFER_ROOT_SEED`.
## `UNRESOLVED_SEED` on a refusal.
var offer_root_seed: int = UNRESOLVED_SEED


## The only way to build a refusal. It sets the question and the reason and
## deliberately nothing else, so no partial seed can ride along with one.
static func refused(for_run_seed: int, for_level: int, reason: String) -> RiftLevelOfferSeedReading:
	var result: RiftLevelOfferSeedReading = RiftLevelOfferSeedReading.new()
	result.ok = false
	result.failure_reason = reason if not reason.strip_edges().is_empty() \
		else "the offer root seed was refused for an unstated reason"
	result.run_seed = for_run_seed
	result.level = for_level
	result.offer_root_seed = UNRESOLVED_SEED
	return result


static func derived(
	for_run_seed: int,
	for_level: int,
	for_offer_root_seed: int
) -> RiftLevelOfferSeedReading:
	var result: RiftLevelOfferSeedReading = RiftLevelOfferSeedReading.new()
	result.ok = true
	result.failure_reason = ""
	result.run_seed = for_run_seed
	result.level = for_level
	result.offer_root_seed = for_offer_root_seed
	return result


## Returns "" when the reading is internally coherent, or the first
## inconsistency found. It checks the SHAPE of the answer — a refusal carries a
## reason and no usable seed, a success carries no reason, a level that is an
## ordinal, and a seed inside the composer's 32-bit domain — and never which seed
## belongs to which run and level, which is the derivation's alone. The run seed
## is never checked, because every signed 64-bit run seed is a valid question.
func problem() -> String:
	if not ok:
		if failure_reason.strip_edges().is_empty():
			return "a refused reading must state a reason"
		if offer_root_seed != UNRESOLVED_SEED:
			return "a refused reading must carry no usable offer root seed, not %d" % offer_root_seed
		return ""
	if not failure_reason.is_empty():
		return "a successful reading must state no failure reason"
	## A level is a player-facing ordinal, so a successful answer is for a
	## positive one. Stated as positivity rather than against the derivation's
	## first level, which this type deliberately does not name.
	if level <= 0:
		return "a successful reading must be for a positive level, not %d" % level
	if offer_root_seed < 0:
		return "a successful reading must carry a non-negative offer root seed, not %d" % offer_root_seed
	if offer_root_seed > LARGEST_OFFER_ROOT_SEED:
		return "a successful reading carries %d, beyond %d, the largest 32-bit offer root seed" % [
			offer_root_seed, LARGEST_OFFER_ROOT_SEED,
		]
	return ""


# --- Presentation -------------------------------------------------------------
#
# Deliberately separate from the answer above, and reached by nothing in it. No
# formatted string is compared, parsed or fed back into a number.

func describe() -> String:
	if not ok:
		return "refused — %s" % failure_reason
	return "run seed %d at level %d offers from root seed %d" % [run_seed, level, offer_root_seed]
