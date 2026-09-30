class_name RogueliteUpgrade
extends RefCounted
## Riftwrought — Roguelite Build Variety V1: the SMALL POOL of temporary
## upgrades one expedition can acquire (decision D-223).
##
## IT IS A VALUE, NOT A SYSTEM, AND THE SHAPE SAYS SO — the same discipline
## `RogueliteRunBoon` recorded for its two, carried unchanged to four. There is
## no level, no rank, no rarity, no tier, no affix, no weight, no reroll, no
## currency, no shop, no cost, no cooldown, no stacking, no unlock, no skill
## tree, no persistence and no schema version. Each of those is a first-MVP
## system with its own authorization and none of them is in scope.
##
## THE FOUR ARE WRITTEN DOWN HERE RATHER THAN GENERATED, and every one of them
## moves a property the Quick Strike kernel ALREADY OBEYS:
##
##   EXPEDITION BLADE  the accepted `data/roguelite/expedition_blade.tres`, the
##                     accepted core loop's own temporary weapon, granted
##                     through the same ground drop, the same
##                     `PlayerLoadout.pick_up()` / `equip()` doors and the same
##                     `FirstMvpItemComparison` the project owner has already
##                     played. That is what keeps the established 100 -> 150
##                     damage / three-Hit -> two-Hit proof VERIFIABLE rather
##                     than restated.
##
##   QUICKENED EDGE    writes `QuickStrikeAction.increased_attack_speed` through
##                     `PrototypePlayer.set_increased_attack_speed()` at
##                     Prototype Zero's own accepted Quickened Form value —
##                     reused from `RogueliteRunBoon.QUICKENED_INCREASE` rather
##                     than typed again, so there is ONE 0.25 in the project and
##                     not two. 0.80 s -> 0.64 s.
##
##   REACHING EDGE     writes `QuickStrikeData.reach` on the action's PRIVATE
##                     runtime copy. That field is read by
##                     `TargetAcquisition.resolve_release()` for the distance
##                     test, by `QuickStrikeAction._tick_approach()` for where
##                     an approach stops, and by `soft_target()` for D-178's
##                     in-reach priority group — so this upgrade moves the real
##                     query in all three places at once, not a caption.
##
##   SWEEPING EDGE     writes `QuickStrikeData.release_arc_degrees` — the TOTAL
##                     horizontal arc `resolve_release()` actually sweeps — and
##                     widens `soft_target_cone_degrees` with it so controller
##                     aim assistance can reach what the wider swing can now
##                     hit. See `SWEEPING_*` below for why BOTH move and why
##                     the arc is the headline.
##
## NOTHING HERE INVENTS A COMBAT PROPERTY, AND NOTHING HERE EDITS A KERNEL.
## Every write lands on a field that already existed and was already obeyed;
## the four writes are on four different fields, which is why any two of them
## coexist by construction rather than by arrangement.
##
## NO NUMBER HERE IS CANON. `EXPEDITION` and `QUICKENED` restate ACCEPTED values
## (D-184, Gate E, Gate 1D, D-222). `REACHING_EDGE_REACH`,
## `SWEEPING_EDGE_ARC_DEGREES` and `SWEEPING_EDGE_SOFT_CONE_DEGREES` are REVIEW
## VALUES chosen to be unmistakable while being played and trivially checkable
## while being verified — they are recorded explicitly, and they amend no
## canonical tuning record. `data/prototype_zero/quick_strike.tres` is never
## written to at all (D-191's private-copy rule), which the verification proves
## rather than promises.
##
## RUN-SCOPED-NESS IS A PROPERTY OF THE RUNTIME, NOT OF THIS OBJECT. Nothing
## here can persist: the class has no save, load, serialize, storage path or
## `user://` anywhere in it.

enum Kind {
	## No upgrade — an empty slot, never an offered choice.
	NONE,
	## The accepted 150-damage weapon, granted as a ground drop.
	EXPEDITION_BLADE,
	## The accepted attack-speed increase, applied at once.
	QUICKENED_EDGE,
	## A longer Quick Strike reach, applied at once.
	REACHING_EDGE,
	## A wider Quick Strike release arc, applied at once.
	SWEEPING_EDGE,
}

## THE POOL, IN ONE PLACE AND IN A STABLE ORDER. The offer selection indexes
## this list, so the order is part of what a seed reproduces; it is written
## here once and read everywhere rather than repeated.
const POOL: Array[int] = [
	Kind.EXPEDITION_BLADE,
	Kind.QUICKENED_EDGE,
	Kind.REACHING_EDGE,
	Kind.SWEEPING_EDGE,
]

## Prototype Zero's accepted Quickened Form increase, taken from the accepted
## D-222 boon rather than retyped. 0.80 / (1 + 0.25) = 0.64 s.
const QUICKENED_INCREASE: float = RogueliteRunBoon.QUICKENED_INCREASE

## REVIEW VALUE — the temporary Quick Strike reach, against the locked 1.65 m.
## Chosen as exactly +1.00 m for two reasons that are both about being able to
## judge it: a whole metre is unmistakable at the accepted 19 m camera, and it
## makes the boundary arithmetic trivial — a target at 2.20 m is OUTSIDE the
## baseline and INSIDE the upgrade with 0.55 m of margin either way, so a check
## that passes cannot be passing on a rounding error.
##
## It stays firmly a contact-melee number: the Graveblade's own accepted
## `preferred_attack_distance` is 1.40 m, so this buys a real standoff without
## becoming a ranged attack, and `approach_stop_margin` (0.10 m) remains a small
## distance inside reach exactly as `QuickStrikeData.problem()` requires.
const REACHING_EDGE_REACH: float = 2.65

## REVIEW VALUE — the temporary TOTAL release arc, against the authored 100.0
## degrees. 180 degrees total is +/- 90: "the swing now covers everything in
## front of you", which is the most readable play-style statement the four can
## make, and again trivial to bound — a target 70 degrees off the facing axis is
## OUTSIDE the baseline (+/- 50) and INSIDE the upgrade (+/- 90) with 20 degrees
## of margin either way.
const SWEEPING_EDGE_ARC_DEGREES: float = 180.0

## REVIEW VALUE — the temporary TOTAL controller soft-target cone, against the
## D-178 locked 65.0.
##
## WHY A SECOND FIELD MOVES, STATED PLAINLY RATHER THAN BURIED. The two numbers
## answer different questions and the project's own records keep them apart:
## `release_arc_degrees` (100.0) is what `TargetAcquisition.resolve_release()`
## sweeps and is therefore THE COMBAT QUERY — it decides what a swing hits, for
## the mouse and the controller alike. `soft_target_cone_degrees` (65.0) is
## D-178 aim ASSISTANCE and only ever narrows what a controller may acquire; it
## decides nothing at all for a mouse player.
##
## An upgrade that widened only the assistance cone would be invisible to the
## project owner's own mouse play and would change no query, so the arc is the
## upgrade. But leaving the cone at 65 would then let a controller player SWING
## through 180 degrees while their aim assistance still refused to look past
## 32.5 either side — the two would disagree about the same swing. So the cone
## is widened with it, and it is stated here rather than discovered later.
##
## 110.0 total is +/- 55.0, comfortably inside `QuickStrikeData`'s own
## `_MAXIMUM_CONE_HALF_DEGREES` backwards-snap guard of 89.0, so the guard is
## respected rather than approached.
const SWEEPING_EDGE_SOFT_CONE_DEGREES: float = 110.0

var kind: Kind = Kind.NONE


func _init(for_kind: Kind = Kind.NONE) -> void:
	kind = for_kind


static func none() -> RogueliteUpgrade:
	return RogueliteUpgrade.new(Kind.NONE)


static func of(for_kind: Kind) -> RogueliteUpgrade:
	return RogueliteUpgrade.new(for_kind)


static func pool_size() -> int:
	return POOL.size()


static func name_of(for_kind: int) -> String:
	match for_kind:
		Kind.EXPEDITION_BLADE:
			return "Expedition Blade"
		Kind.QUICKENED_EDGE:
			return "Quickened Edge"
		Kind.REACHING_EDGE:
			return "Reaching Edge"
		Kind.SWEEPING_EDGE:
			return "Sweeping Edge"
		_:
			return "none"


## What the upgrade changes, in one plain sentence. Deliberately states the
## PROPERTY rather than a verdict: the project's standing rule against a
## universal upgrade score applies to an upgrade exactly as it applies to an
## item, and four upgrades on four different axes have no common scale.
static func summary_of(for_kind: int) -> String:
	match for_kind:
		Kind.EXPEDITION_BLADE:
			return "More damage per Quick Strike."
		Kind.QUICKENED_EDGE:
			return "A faster Quick Strike."
		Kind.REACHING_EDGE:
			return "A longer Quick Strike."
		Kind.SWEEPING_EDGE:
			return "A wider Quick Strike."
		_:
			return ""


## How the upgrade reaches the player. The two routes genuinely differ and
## hiding that would be the dishonest choice: the blade is laid on the ground on
## the way out and can still be walked past, exactly as the accepted core loop
## leaves it, while the three edges apply at once.
static func delivery_of(for_kind: int) -> String:
	match for_kind:
		Kind.EXPEDITION_BLADE:
			return "Left on the ground on your way out. Inspect it and equip it to use it."
		Kind.QUICKENED_EDGE, Kind.REACHING_EDGE, Kind.SWEEPING_EDGE:
			return "Applies at once, for the rest of this expedition."
		_:
			return ""


## The one-line build-summary form, e.g. "Reaching Edge — a longer Quick Strike".
static func one_line_of(for_kind: int) -> String:
	if for_kind == Kind.NONE:
		return "none"
	return "%s — %s" % [name_of(for_kind), summary_of(for_kind).trim_suffix(".").to_lower()]


## True for the one upgrade delivered as the accepted ground weapon — the branch
## that keeps the established pickup / comparison / equip path and its damage
## proof.
static func is_weapon_kind(for_kind: int) -> bool:
	return for_kind == Kind.EXPEDITION_BLADE


func display_name() -> String:
	return name_of(kind)


func delivery() -> String:
	return delivery_of(kind)


func summary() -> String:
	return summary_of(kind)


func one_line() -> String:
	return one_line_of(kind)


func is_none() -> bool:
	return kind == Kind.NONE


func is_weapon() -> bool:
	return is_weapon_kind(kind)


func is_attack_speed() -> bool:
	return kind == Kind.QUICKENED_EDGE


func is_reach() -> bool:
	return kind == Kind.REACHING_EDGE


func is_arc() -> bool:
	return kind == Kind.SWEEPING_EDGE


func describe() -> String:
	return "%s (%s)" % [display_name(), summary().trim_suffix(".").to_lower()]
