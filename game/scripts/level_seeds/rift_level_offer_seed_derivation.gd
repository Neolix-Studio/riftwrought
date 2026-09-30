class_name RiftLevelOfferSeedDerivation
extends RefCounted
## Riftwrought — Roguelite Foundation G2: deterministic per-level offer-seed
## derivation, as a pure STATELESS rule.
##
## IT ANSWERS ONE QUESTION. Given a signed 64-bit run seed and a positive current
## Rift level, what non-negative 32-bit root seed should the accepted three-lane
## offer composer (Foundation D1) be handed for that level's offer? The answer is
##
##     low             = run_seed & MASK_32
##     high            = (run_seed >> 32) & MASK_32
##     run_key         = (low + high x RUN_HIGH_FOLD_STEP) & MASK_32
##     level_index     = (level - 1) & MASK_32
##     offer_root_seed = (run_key + level_index x LEVEL_STEP) & MASK_32
##
## with the three constants below FROZEN by the owner's brief. Once anything
## reproduces an offer from a run seed and a level, changing either step rewrites
## every per-level offer every run seed has ever produced, so they are pinned by
## the suite for exactly that reason.
##
## IT IS DELIBERATELY UNWIRED. The accepted single level-up coordinator
## (Foundation E2) still receives its offer's root seed explicitly from its
## caller, exactly as it was accepted. Connecting this derivation to it, gaining
## more than one level, queueing offers and deciding when a level is earned are
## all later decisions with their own authorization.
##
##
## IT SCHEDULES; IT DOES NOT MIX
## ---------------------------------------------------------------------------
## There is deliberately no avalanche finalizer here. The offer composer already
## derives each of its three lane seeds by xoring the root seed with a frozen lane
## domain and passing the result through its own finalizer, so what it needs from
## this file is DISTINCT ROOT INPUTS, not well-mixed ones. A finalizer here would
## be a second mixer stacked on the first and a fifth copy of arithmetic the
## project already carries four times, and it would buy nothing: the composer's
## finalizer is a bijection on 32 bits, so distinct roots already become distinct
## lane seeds there.
##
##
## WHAT IS AND IS NOT PROMISED — THE HONEST MATHEMATICS
## ---------------------------------------------------------------------------
## - The output is ALWAYS in 0 … 4,294,967,295, the offer composer's effective
##   32-bit seed domain; the final mask guarantees it.
## - EVERY signed 64-bit run seed is valid, negative ones included, and every
##   positive level is valid, up to the largest positive integer. There is no
##   designed maximum level. The one refusal is a level below 1.
## - For ONE run key, consecutive levels differ by exactly LEVEL_STEP modulo 2^32.
##   LEVEL_STEP is odd, so it has a multiplicative inverse modulo 2^32, so the map
##   from a level index to a root seed is a PERMUTATION of the 32-bit residues:
##   the first 2^32 consecutive levels of a run all receive different root seeds.
## - THE SCHEDULE REPEATS EVERY 2^32 LEVELS. Levels 1 and 2^32 + 1 receive the
##   same root seed. That is a representation fact about a 32-bit seed domain, not
##   a gameplay limit, and it is stated rather than hidden.
## - DIFFERENT RUN SEEDS CAN COLLIDE. Sixty-four bits are folded into thirty-two,
##   so many run seeds share one run key and therefore every per-level root seed.
##   No global collision freedom is claimed. It is sufficient because the offer
##   composer's own effective seed domain is already 32 bits: no derivation could
##   hand it more distinct questions than that.
## - RUN_HIGH_FOLD_STEP is odd too, so for a fixed low half every high half
##   reaches a different run key, and for a fixed high half every low half does —
##   both halves of the run seed always matter. A collision needs both to differ.
## - For a run seed already in 0 … 2^32 - 1 the high half is zero, so Level 1's
##   root seed IS the run seed, exactly.
##
##
## THE ARITHMETIC NEVER DEPENDS ON WRAPAROUND
## ---------------------------------------------------------------------------
## Whole-number arithmetic in this engine wraps silently. Every value multiplied
## here is masked to 32 bits BEFORE it is multiplied, and the level is checked to
## be at least 1 before one is subtracted from it, so with the frozen constants
## the largest intermediate values are
##
##     low + high x RUN_HIGH_FOLD_STEP      <= (2^32 - 1) x 65,538    = 281,483,566,579,710
##     run_key + level_index x LEVEL_STEP   <= (2^32 - 1) x 1,000,004 = 4,294,984,474,869,180
##
## both far below 9,223,372,036,854,775,807, the largest signed 64-bit integer.
## Because wraparound modulo 2^64 is also congruent modulo 2^32, an unmasked
## version would happen to produce the same answers — which is exactly why the
## order is pinned structurally by the suite: the answer must be RIGHT BY
## CONSTRUCTION, not right because an overflow cancelled out.
##
##
## IT IS PURE AND STATELESS. No instance field of any kind, no node, no signal, no
## clock, no random source, no file, no project setting, no run state, no offer,
## no level curve and no global state. The same run seed and level always produce
## the same answer, whatever was asked before it and in whatever order.

## The first current level an offer root seed exists for. A level is a
## player-facing ordinal, so it begins at 1.
const FIRST_LEVEL: int = 1

## The low 32 bits. FROZEN.
const MASK_32: int = 0xFFFF_FFFF

## The odd multiplier the high half of the run seed is folded in with. FROZEN.
const RUN_HIGH_FOLD_STEP: int = 65_537

## The odd distance between the root seeds of consecutive levels. FROZEN.
const LEVEL_STEP: int = 1_000_003

const _BELOW_FIRST_LEVEL: String = "there is no offer root seed for level %d; a Rift level is at least %d"


## The root seed the offer at current level `level` should be composed from, for
## the run seeded with `run_seed`. Always a reading: `ok` with the derived seed,
## or a refusal carrying both inputs and one reason and no usable seed.
static func offer_root_seed_for(run_seed: int, level: int) -> RiftLevelOfferSeedReading:
	if level < FIRST_LEVEL:
		return RiftLevelOfferSeedReading.refused(run_seed, level,
			_BELOW_FIRST_LEVEL % [level, FIRST_LEVEL])
	var low: int = run_seed & MASK_32
	var high: int = (run_seed >> 32) & MASK_32
	var run_key: int = (low + high * RUN_HIGH_FOLD_STEP) & MASK_32
	var level_index: int = (level - FIRST_LEVEL) & MASK_32
	var offer_root_seed: int = (run_key + level_index * LEVEL_STEP) & MASK_32
	return RiftLevelOfferSeedReading.derived(run_seed, level, offer_root_seed)
