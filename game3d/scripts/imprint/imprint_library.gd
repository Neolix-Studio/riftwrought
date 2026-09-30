class_name ImprintLibrary
extends RefCounted

## THE IMPRINT LIBRARY — permanent, per-character, and the only place a mastery
## record exists.
##
## ============================================================================
## LEARNED IMPRINTS LIVE HERE PERMANENTLY. LEARNING CONSUMES NOTHING.
## ============================================================================
## `design/SKILLS_AND_SKILL_MODIFICATION.md` section 3 and section 17:
##   "Learning a Skill adds it permanently to the character's Skill Library."
##   "The learned Augment may be used simultaneously in any number of compatible
##    Skill Configurations without acquiring duplicate copies."
##
## So `learn()` is IDEMPOTENT: a second learn of the same Imprint is counted and
## ignored, and it never resets mastery or XP. A check attacks that directly.
##
## ---------------------------------------------------------------------------
## ONE MASTERY RECORD PER IMPRINT, HOWEVER MANY CONFIGURATIONS USE IT.
## ---------------------------------------------------------------------------
## This is the structural reason reuse cannot multiply XP: the mastery and XP
## live HERE, keyed by Imprint id, not on the Configuration. A per-Configuration
## record would make double-counting the default and the fix an afterthought.
##
## ---------------------------------------------------------------------------
## XP COMES FROM AWARDED COMBAT PROGRESS, NOT FROM BUTTON PRESSES.
## ---------------------------------------------------------------------------
## The owner's instruction: "Equipped Imprints receive combat XP from awarded
## combat progress, not from button-use frequency." There is deliberately NO
## code path from a Skill use to `grant_xp`, and the suite proves it by making
## many uses with no awarded progress and asserting ZERO XP.
##
## EVERY VALUE IT USES IS PROVISIONAL, INCLUDING THE CURVE AND THE CAP.

## id -> Imprint
var learned: Dictionary = {}
## id -> int, the highest rank permanently learned. IT NEVER DECREASES.
var _mastered: Dictionary = {}
## id -> float, progress toward the next rank.
var _xp: Dictionary = {}

## ============================================================================
## THE CHARACTER'S OWN PROGRESSION RANK — the reference the catch-up rule uses.
## ============================================================================
## It is a DIAGNOSTIC stand-in for character progression, not a character level
## system, and no progression pacing is implemented. PROVISIONAL.
var character_progress_rank: int = ImprintConfig.RANK_MIN

## Diagnostics the suite and the panel read.
var learn_calls: int = 0
var duplicate_learns_ignored: int = 0
var awards: int = 0
var xp_grants: int = 0
var last_award_rows: Array = []
var last_award_collapsed: int = 0

## ============================================================================
## THE ACQUISITION RECORD, AND THE DECLARED DIAGNOSTIC SEEDING. (OD-01; D-380)
## ============================================================================
## id -> {"rank": int, "xp": float} at the moment of learning. ALWAYS rank 1 and
## 0 XP, because `learn()` has no way to say anything else -- recorded so a check
## can read it rather than trust it.
var _acquired: Dictionary = {}
## id -> the Mastered Rank DIAGNOSTIC SEEDING raised it to after learning.
var _seeded: Dictionary = {}
var diagnostic_seeds: int = 0

# ------------------------------------------------------------------ learning --

## ============================================================================
## A NEWLY LEARNED IMPRINT STARTS AT MASTERED RANK 1 WITH 0 XP. NO FLOOR EXISTS.
## ============================================================================
## D-378 OD-01: "Every newly learned Imprint starts at Mastered Rank 1 with 0 XP
## toward rank 2. No acquisition-time rank floor."
##
## From D-375 until D-380 this read `learn(imp, mastered_rank = RANK_MIN)`. The
## DEFAULT was already rank 1 -- which is why D-378 read OD-01 as holding -- but
## the PARAMETER made an acquisition-time floor representable, and the
## diagnostic content used it to learn Imprints at ranks up to 20. D-380 REMOVES
## THE PARAMETER, so a floor is not merely unused but UNREPRESENTABLE. An
## established character's earned ranks are stood in for SEPARATELY, AFTER
## learning, by `diagnostic_seed_prior_mastery()` -- labelled, counted, printed.
##
## Adds an Imprint permanently. A second call for the same id is IGNORED and
## counted -- it does not duplicate, reset mastery, or reset XP.
func learn(imp: Imprint) -> bool:
	learn_calls += 1
	if learned.has(imp.id):
		duplicate_learns_ignored += 1
		return false
	learned[imp.id] = imp
	_mastered[imp.id] = ImprintConfig.RANK_MIN
	_xp[imp.id] = 0.0
	_acquired[imp.id] = {"rank": ImprintConfig.RANK_MIN, "xp": 0.0}
	return true

## The rank and XP an Imprint was LEARNED at. Rank 1 and 0 XP, always.
func acquisition_record(id: String) -> Dictionary:
	return _acquired.get(id, {})

## ============================================================================
## DIAGNOSTIC SEEDING — A STAND-IN FOR PROGRESSION ALREADY EARNED. NOT A FLOOR.
## ============================================================================
## The live review needs an ESTABLISHED character -- uneven Mastered Ranks are
## what make the Mastered / Effective split and the catch-up rule visible -- and
## this project has no save and no progression history to load one from. So the
## diagnostic content LEARNS every Imprint at rank 1 / 0 XP, exactly as OD-01
## requires, and THEN raises it to a rank that stands in for XP the character
## would already have earned.
##
## IT IS NOT AN ACQUISITION RULE: it runs only after `learn()`, only on an Imprint
## that is already known, it can never lower a rank, and every call is counted
## and printed. D-378 section 2 read these start-up ranks as "diagnostic
## seeding"; D-380 makes that reading structural rather than a description.
func diagnostic_seed_prior_mastery(id: String, rank: int) -> bool:
	if not learned.has(id):
		return false
	set_mastered_at_least(id, rank)
	_seeded[id] = mastered(id)
	diagnostic_seeds += 1
	return true

func seeded_rank(id: String) -> int:
	return int(_seeded.get(id, 0))

func knows(id: String) -> bool:
	return learned.has(id)

func get_imprint(id: String) -> Imprint:
	return learned.get(id, null)

func ids() -> Array:
	var out: Array = learned.keys()
	out.sort()
	return out

func count() -> int:
	return learned.size()

func count_of_kind(kind: int) -> int:
	var n := 0
	for id in learned:
		if (learned[id] as Imprint).kind == kind:
			n += 1
	return n

# --------------------------------------------------------------------- rank --

func mastered(id: String) -> int:
	return int(_mastered.get(id, 0))

## Raises the mastered rank directly, for setup. IT CANNOT LOWER ONE -- a
## mastered rank that could fall would make "Effective Rank may not exceed
## Mastered Rank" enforceable and meaningless at the same time.
func set_mastered_at_least(id: String, rank: int) -> void:
	if not learned.has(id):
		return
	_mastered[id] = maxi(mastered(id), clampi(rank, ImprintConfig.RANK_MIN, ImprintConfig.RANK_MAX))

## The ranks an Imprint may be used at, right now. THE WHOLE POINT OF THE
## MASTERED / EFFECTIVE SPLIT IS THAT THIS LIST ONLY EVER GROWS: levelling an
## Imprint can never remove a rank the player could previously choose, so it can
## never brick it.
func selectable_ranks(id: String) -> Array:
	var out: Array = []
	for r in range(ImprintConfig.RANK_MIN, mastered(id) + 1):
		out.append(r)
	return out

# ----------------------------------------------------------------------- xp --

func xp(id: String) -> float:
	return float(_xp.get(id, 0.0))

## XP needed to advance FROM `rank` TO `rank + 1`. PROVISIONAL and linear on
## purpose: the ruling says the curve is provisional, so a more elaborate curve
## would only be a more expensive guess.
static func xp_to_advance_from(rank: int) -> float:
	return ImprintConfig.XP_PER_RANK_STEP * float(rank)

func xp_to_next(id: String) -> float:
	if mastered(id) >= ImprintConfig.RANK_MAX:
		return 0.0
	return xp_to_advance_from(mastered(id))

func xp_fraction(id: String) -> float:
	var need := xp_to_next(id)
	if need <= 0.0:
		return 1.0
	return clampf(xp(id) / need, 0.0, 1.0)

## ============================================================================
## THE BOUNDED CATCH-UP MULTIPLIER.
## ============================================================================
## Canon requires the behaviour (`SKILLS_AND_SKILL_MODIFICATION.md` section 4:
## newly learned Skills must not need "hours of use-based experience before they
## become viable on an established character"), and the ruling requires it to be
## BOUNDED.
##
## BOUNDED MATTERS: an unbounded multiplier would make a freshly learned Imprint
## level FASTER than an invested one, which is a different unfairness wearing the
## same coat. The ceiling is asserted, and so is the fact that a fully caught-up
## Imprint gets exactly 1.0x.
func catchup_multiplier(id: String) -> float:
	var behind := character_progress_rank - mastered(id)
	if behind <= 0:
		return 1.0
	return clampf(1.0 + float(behind) * ImprintConfig.CATCHUP_PER_RANK_BEHIND,
		1.0, ImprintConfig.CATCHUP_MULTIPLIER_MAX)

## Grants XP to ONE Imprint and returns how many ranks it gained.
##
## AT THE RANK CAP, XP IS NOT ACCUMULATED. Storing XP nobody can spend would
## make a mastered Imprint look like it was still progressing.
func grant_xp(id: String, amount: float) -> int:
	if not learned.has(id) or amount <= 0.0:
		return 0
	xp_grants += 1
	if mastered(id) >= ImprintConfig.RANK_MAX:
		_xp[id] = 0.0
		return 0
	_xp[id] = xp(id) + amount
	var gained := 0
	while mastered(id) < ImprintConfig.RANK_MAX and xp(id) >= xp_to_advance_from(mastered(id)):
		_xp[id] = xp(id) - xp_to_advance_from(mastered(id))
		_mastered[id] = mastered(id) + 1
		gained += 1
	if mastered(id) >= ImprintConfig.RANK_MAX:
		_xp[id] = 0.0
	return gained

## ============================================================================
## AWARDED COMBAT PROGRESS. ONE AWARD PER DISTINCT IMPRINT, ALWAYS.
## ============================================================================
## `equipped_ids` is whatever the loadout reports, DUPLICATES INCLUDED -- one
## Augment Imprint used in three Configurations arrives three times. This
## function collapses them to a set FIRST, and records how many it collapsed, so
## the de-duplication is a measured number rather than an invisible assumption.
##
## The ruling: "Reusing one Imprint in multiple Configurations must not multiply
## its XP award."
func award_combat_progress(amount: float, equipped_ids: Array) -> Dictionary:
	awards += 1
	last_award_rows = []
	var seen := {}
	var collapsed := 0
	for raw in equipped_ids:
		var id := String(raw)
		if seen.has(id):
			collapsed += 1
			continue
		seen[id] = true
	last_award_collapsed = collapsed
	var distinct: Array = seen.keys()
	distinct.sort()
	for id in distinct:
		if not learned.has(id):
			continue
		var mult := catchup_multiplier(String(id))
		var granted := amount * mult
		var before := mastered(String(id))
		var ranks := grant_xp(String(id), granted)
		last_award_rows.append({
			"id": String(id),
			"multiplier": mult,
			"granted": granted,
			"ranks_gained": ranks,
			"mastered_before": before,
			"mastered_after": mastered(String(id)),
		})
	return {
		"amount": amount,
		"distinct": distinct.size(),
		"duplicates_collapsed": collapsed,
		"rows": last_award_rows,
	}

## Total XP granted to one Imprint across the run, for the panel. Derived from
## rank and remainder rather than stored separately, so it cannot disagree with
## the mastery record.
func total_progress_units(id: String) -> float:
	var total := 0.0
	for r in range(ImprintConfig.RANK_MIN, mastered(id)):
		total += xp_to_advance_from(r)
	return total + xp(id)

func reset_progress() -> void:
	for id in learned:
		_mastered[id] = ImprintConfig.RANK_MIN
		_xp[id] = 0.0
	_seeded = {}
	awards = 0
	xp_grants = 0
	last_award_rows = []
	last_award_collapsed = 0
