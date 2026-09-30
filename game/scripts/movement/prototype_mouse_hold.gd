class_name PrototypeMouseHold
extends RefCounted
## The ONE shared click-and-HOLD refresh timer, extracted from
## `scripts/prototype_zero/prototype_zero.gd` under D-195 and Gate 1A
## specification §3.
##
## Holding the mouse button re-issues the movement command on a fixed cadence so
## the destination follows the cursor. The cadence is part of how click-to-move
## FEELS, which is exactly why the second scene must not carry its own copy of
## the number.
##
## `PrototypeZeroRoom` keeps its `_mouse_hold_active` and `_hold_timer` names as
## forwarding properties, so every one of its fourteen existing call sites is
## untouched and only the tick itself moved.

const REFRESH_SECONDS: float = 0.10

var active: bool = false
var timer: float = 0.0


## A fresh press is always a new intent (specification §9.5), and it re-issues
## immediately rather than waiting out a refresh interval.
func press() -> void:
	active = true
	timer = 0.0


func release() -> void:
	active = false


## True when the held command should be re-issued this frame. A button that is
## no longer down simply ends the hold.
func should_reissue(delta: float, still_held: bool) -> bool:
	if not active:
		return false
	if not still_held:
		active = false
		return false
	timer -= delta
	if timer > 0.0:
		return false
	timer = REFRESH_SECONDS
	return true
