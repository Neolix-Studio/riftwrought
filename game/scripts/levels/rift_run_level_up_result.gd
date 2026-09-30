class_name RiftRunLevelUpResult
extends RefCounted
## Riftwrought — Roguelite Foundation G4: the outcome of ONE explicit attempt to
## take one lane of the current level's offer inside a run, recorded with the
## run-level provenance that names where in the run the attempt happened.
##
## WHY THIS TYPE EXISTS, GIVEN THAT THE ONE-LEVEL RECEIPT ALREADY DOES. The
## accepted one-level receipt (Foundation E2) says what one choice granted and
## which root seed it spent. It deliberately does not say which run or which level
## that seed belongs to, and it must not start to: decision D-266 made a level-up's
## run provenance the pair `run seed + current level`, and ruled that it is not to
## be retrofitted into that receipt. So this record carries exactly the pair, and
## the one-level receipt beside it, and nothing else.
##
## IT DOES NOT RESTATE THE RECEIPT IT CARRIES. There are no parallel copies of the
## granted identity, the lane, the root seed or the progression here: a caller that
## wants them asks `level_up()` for a copy of the whole receipt. Two stored
## statements of one fact is how two answers to one question start.
##
##
## THE RECEIPT INSIDE IS PRIVATE, AND EVERY WAY IN OR OUT OF IT IS A COPY
## ---------------------------------------------------------------------------
## `recorded()` keeps a duplicate of the receipt it is handed, so the caller's
## receipt and this record's cannot reach each other afterwards. `level_up()`
## hands out another duplicate, so rewriting what a caller was given cannot rewrite
## what this record keeps. The copying rule is the receipt's own `duplicated()`,
## written once beside the fields it copies.
##
##
## COHERENCE IS RE-DERIVED THROUGH THE ACCEPTED SEED DERIVATION, NEVER RESTATED
## ---------------------------------------------------------------------------
## Whenever the carried receipt knows a root seed — and a successful one always
## does — that seed must be exactly the one the accepted per-level derivation
## (Foundation G2) answers for this record's own run seed and source level. That is
## asked of the derivation itself, and its `ok` is asked before its seed is read,
## which D-266 ruling 1 makes mandatory. No formula is written here.
##
## A refusal made before any offer stood carries a receipt that knows no root
## seed. It is still coherent, and it still carries the run seed and the level,
## because those describe where the attempt was made rather than what it spent.
##
## THE RECEIPT'S OWN VALIDATION IS ASKED, NOT REPEATED. Whether a success names a
## declared lane, grants the right number of identifiers or carries a legal
## progression is the receipt's `problem()` to answer, and this record quotes it.
##
##
## IT IS INERT. It carries no run build, no ledger, no track, no coordinator, no
## offer, no requirement, no catalogue and no presentation label. No node, no
## signal, no clock, no random source, no file and no schema.

## The exact signed 64-bit run seed the run was begun with. Never masked, folded
## or normalized here: provenance is the seed exactly as it was given.
var run_seed: int = 0

## The level the run was at when this attempt was asked — the level whose offer
## was, or would have been, taken.
var source_level: int = 0

## A private copy of the one-level receipt this attempt produced, or null for a
## record built from nothing. Never handed out: `level_up()` answers a copy.
var _level_up: RiftLevelUpResult = null


## The only way to build a record, and it takes the one-level receipt WHOLE. Every
## input is copied: the two integers because they are integers, and the receipt
## through its own duplicating copy. A null receipt is kept as null, and
## `problem()` reports a record that carries none.
static func recorded(
	for_run_seed: int,
	at_source_level: int,
	from_level_up: RiftLevelUpResult
) -> RiftRunLevelUpResult:
	var result: RiftRunLevelUpResult = RiftRunLevelUpResult.new()
	result.run_seed = for_run_seed
	result.source_level = at_source_level
	if from_level_up != null:
		result._level_up = from_level_up.duplicated()
	return result


# --- Reading the record ---------------------------------------------------------

## Whether the attempt took a lane and advanced the run. Read from the carried
## receipt, which is the only thing that knows; a record carrying none did not.
func succeeded() -> bool:
	return _level_up != null and _level_up.ok


## Why the attempt was refused, quoted from the carried receipt. Empty exactly
## when it succeeded.
func failure_reason() -> String:
	if _level_up == null:
		return "the run level-up carries no one-level result"
	return _level_up.failure_reason


## A COPY of the one-level receipt this attempt produced, or null when the record
## carries none. Each call answers a new copy, so what one caller does to its copy
## cannot reach this record or another caller's.
func level_up() -> RiftLevelUpResult:
	if _level_up == null:
		return null
	return _level_up.duplicated()


## Returns "" when this record is internally coherent, or the FIRST contradiction
## found, in plain language.
##
## THE ORDER IS THE CONTRACT. A source level must be a positive ordinal; a
## receipt must be carried and must be coherent by its own rule; the accepted
## derivation is asked for this run seed and source level, and its `ok` is asked
## before its seed is read; and a receipt that succeeded, or that knows a root seed
## at all, must know exactly that one.
##
## THE DERIVATION'S REFUSAL CANNOT HAPPEN HERE TODAY, AND IS ASKED ANYWAY. It
## refuses only a level below 1, which the first gate has already refused. D-266
## ruling 1 makes asking `ok` before reading the seed mandatory rather than a
## judgement about reachability, so the question stays.
func problem() -> String:
	if source_level <= 0:
		return "a run level-up must be asked at a positive level, not %d" % source_level
	if _level_up == null:
		return "a run level-up must carry the one-level result it records"
	var carried: String = _level_up.problem()
	if not carried.is_empty():
		return "the one-level result it records is incoherent: %s" % carried
	var derived: RiftLevelOfferSeedReading = RiftLevelOfferSeedDerivation.offer_root_seed_for(
		run_seed, source_level)
	if not derived.ok:
		return "run seed %d at level %d derives no offer root seed: %s" % [
			run_seed, source_level, derived.failure_reason,
		]
	if _level_up.ok or _level_up.root_seed_known:
		if not _level_up.root_seed_known or _level_up.root_seed != derived.offer_root_seed:
			return "the one-level result names %s, where run seed %d at level %d derives root seed %d" % [
				_named_root(), run_seed, source_level, derived.offer_root_seed,
			]
	return ""


# --- Presentation ---------------------------------------------------------------
#
# Reached by nothing above except to name a seed inside a message. No formatted
# string is compared, parsed or fed back into a number or a seed.

func describe() -> String:
	var carried: String = "no one-level result"
	if _level_up != null:
		carried = _level_up.describe()
	return "run seed %d at level %d: %s" % [run_seed, source_level, carried]


func _named_root() -> String:
	if not _level_up.root_seed_known:
		return "no root seed"
	return "root seed %d" % _level_up.root_seed
