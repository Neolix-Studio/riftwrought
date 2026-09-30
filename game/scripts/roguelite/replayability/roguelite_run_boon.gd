class_name RogueliteRunBoon
extends RefCounted
## Riftwrought — Roguelite Replayability V1: the ONE temporary reward an
## expedition can produce, now offered as a choice of exactly two (D-222).
##
## IT IS A VALUE, NOT A SYSTEM, AND THE SHAPE SAYS SO. There are exactly two
## kinds and they are written down here rather than generated, weighted, rolled
## or unlocked. There is no rarity, no affix, no tier, no pool, no currency, no
## cost, no cooldown, no stacking, no upgrade path, no persistence and no
## schema version — each of those is a first-MVP system with its own
## authorization, and none of them is in scope.
##
## NEITHER CHOICE INVENTS A COMBAT PROPERTY, AND THAT IS THE POINT.
##
##   EXPEDITION BLADE  is the accepted `data/roguelite/expedition_blade.tres`
##                     the core loop already ships, granted through the same
##                     ground drop, the same `PlayerLoadout.pick_up()` /
##                     `equip()` doors and the same `FirstMvpItemComparison`
##                     the project owner has already played. That is what keeps
##                     the established 100 -> 150 damage / three-Hit ->
##                     two-Hit proof intact and verifiable rather than
##                     re-stated: the player still reads it off the comparison
##                     panel and still feels it on the next Graveblade.
##
##   QUICKENED EDGE    writes `QuickStrikeAction.increased_attack_speed`
##                     through the existing `PrototypePlayer`
##                     `set_increased_attack_speed()` path. That is the SAME
##                     single field Prototype Zero's accepted Quickened Form
##                     used at Gate E and Gate 1E's First Fracture used again,
##                     at the SAME accepted 0.25 that takes the locked 0.80 s
##                     Quick Strike to 0.64 s. No kernel is edited, no new
##                     modifier type exists, and nothing else in the action
##                     moves: the release still lands on its 0.325 marker and
##                     the reach, arc, targeting and Mana cost are untouched.
##
## THE TWO ARE DELIBERATELY NOT COMPARABLE ON ONE AXIS, and no score says which
## is better. One changes damage per Hit, the other changes Hits per second;
## the panel states both as measured before-and-after numbers computed from the
## records and offers no verdict. The project's standing rule against a
## universal upgrade verdict applies to a boon exactly as it applies to an
## item.
##
## RUN-SCOPED-NESS IS A PROPERTY OF THE RUNTIME, NOT OF THIS OBJECT. Nothing
## here can persist: the class has no save, load, serialize, storage path or
## `user://` anywhere in it. The runtime throws the whole object away and zeroes
## the effect on death, on abandon and at the start of every run, through the
## one shared `_reset_run_scoped_state()` both paths already pass through.

enum Kind {
	## No boon this run — the reward beat has not been resolved yet.
	NONE,
	## The accepted 150-damage weapon, granted as a ground drop.
	EXPEDITION_BLADE,
	## The accepted attack-speed increase, applied at once.
	QUICKENED_EDGE,
}

## Prototype Zero's accepted Quickened Form value, reused rather than
## re-derived: 0.80 / (1 + 0.25) = 0.64 s, exactly the D-184 relationship the
## project owner has already played and accepted.
const QUICKENED_INCREASE: float = 0.25

var kind: Kind = Kind.NONE


func _init(for_kind: Kind = Kind.NONE) -> void:
	kind = for_kind


static func none() -> RogueliteRunBoon:
	return RogueliteRunBoon.new(Kind.NONE)


static func of(for_kind: Kind) -> RogueliteRunBoon:
	return RogueliteRunBoon.new(for_kind)


## The two offered choices, in the order the panel shows them. Exactly two, and
## the panel asserts that rather than assuming it.
## Typed `Array[int]` rather than `Array[Kind]`: GDScript typed arrays accept
## built-in types and classes, not enum hints, and an enum value is an int.
static func offered_kinds() -> Array[int]:
	return [Kind.EXPEDITION_BLADE, Kind.QUICKENED_EDGE]


static func name_of(for_kind: Kind) -> String:
	match for_kind:
		Kind.EXPEDITION_BLADE:
			return "Expedition Blade"
		Kind.QUICKENED_EDGE:
			return "Quickened Edge"
		_:
			return "none"


## How the boon reaches the player, stated plainly, because the two routes
## genuinely differ and hiding that would be the dishonest choice. The blade is
## laid on the ground on the way out — so it can still be walked past, exactly
## as the accepted core loop leaves it — while the edge applies at once.
static func delivery_of(for_kind: Kind) -> String:
	match for_kind:
		Kind.EXPEDITION_BLADE:
			return "Left on the ground on your way out. Inspect it and equip it to use it."
		Kind.QUICKENED_EDGE:
			return "Applies at once, for the rest of this expedition."
		_:
			return ""


func display_name() -> String:
	return name_of(kind)


func delivery() -> String:
	return delivery_of(kind)


func is_none() -> bool:
	return kind == Kind.NONE


## True when this boon is delivered as the ground weapon — the branch that
## keeps the accepted pickup / comparison / equip path and its damage proof.
func is_weapon() -> bool:
	return kind == Kind.EXPEDITION_BLADE


## True when this boon is delivered by writing the established attack-speed
## field. `increase()` is the only number it can ever write.
func is_attack_speed() -> bool:
	return kind == Kind.QUICKENED_EDGE


func increase() -> float:
	return QUICKENED_INCREASE if is_attack_speed() else 0.0


func one_line() -> String:
	match kind:
		Kind.EXPEDITION_BLADE:
			return "Expedition Blade — more damage per Quick Strike"
		Kind.QUICKENED_EDGE:
			return "Quickened Edge — a faster Quick Strike"
		_:
			return "none chosen"


func describe() -> String:
	return "%s (%s)" % [display_name(), "weapon" if is_weapon() else (
		"attack speed +%.0f%%" % (increase() * 100.0) if is_attack_speed() else "none")]
