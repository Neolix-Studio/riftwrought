class_name PrototypeTargetable
extends Area3D
## Prototype Zero — the smallest thing Quick Strike's targeting needs a target to
## be (specification §11).
##
## Gate C acquired, approached, and struck inert practice posts. Gate D adds a
## real Graveblade. Both have to be selectable by the cursor, eligible for the
## controller soft-target cone, and resolvable by the release query — and the
## Graveblade must be able to take damage and die, which a practice post must
## never be able to do.
##
## So the shared piece is exactly this: a body-shaped Area3D on the "target"
## physics layer that can say whether it is still a valid target, where a strike
## should be aimed, what to call it, and whether anything behind it owns Life.
## `combat_actor()` returning null IS the difference between the two: an inert
## post reports no actor and a release onto it produces no DamageEvent at all,
## while the Graveblade reports the enemy body and a release onto it produces
## exactly one.
##
## This is deliberately NOT an entity-component framework (specification §4.4).
## It is one base class with six methods, added because Gate D needs two kinds of
## target and pretending a Graveblade is a practice fixture would have been the
## only alternative.

## Layer 3, "target". Shared so nothing has to remember the bit.
const TARGET_LAYER: int = 4


## Gate C's stand-in for "living" was a switched-off fixture; Gate D's is a dead
## Graveblade. Either way an invalid target is refused by acquisition, by the
## soft-target cone, and by the release query.
func is_valid_target() -> bool:
	return true


## Where a strike is aimed and where line-of-sight is tested to. Roughly chest
## height on a body of this size.
func targeting_point() -> Vector3:
	return global_position + Vector3(0.0, 1.10, 0.0)


func target_display_name() -> String:
	return name


## The quiet controller soft-target indicator (specification §11.2).
func set_soft_targeted(_value: bool) -> void:
	pass


## A release query resolved onto this target. Presentation and record only —
## damage is the caller's business, through `combat_actor()`.
func note_release(_use_id: int) -> void:
	pass


## The actor that owns Life and can receive a DamageEvent, or null when there is
## nothing behind this target to damage. Inert practice posts return null.
func combat_actor() -> Node:
	return null
