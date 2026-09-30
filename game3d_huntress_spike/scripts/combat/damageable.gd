class_name Damageable
extends RefCounted

## A plain damage ledger, deliberately NOT a node.
##
## It records ORDER as well as amount, because the project's rule is that
## HIT-BEFORE-KILL ORDERING must be provable: an assertion that something did not
## happen can pass because the action never ran, so the ledger lets a check
## assert the hit FIRED before asserting the death followed it.
##
## Every number that passes through here is PROVISIONAL.

signal damaged(amount: float, from: Vector3)
signal died()

var max_life: float = 1.0

## ============================================================================
## THE USABLE CEILING ON LIVE HEALTH — the owner's D-382 ruling on AD-11.
## ============================================================================
## *"Life reservation must affect live Health correctly."* A Life reservation
## lowers USABLE Health, and live Health may never sit above it. The ceiling is
## pushed here by the live `ResourcePool` in the SAME call that changes the
## reservation (`ResourcePool.set_reservation`), and:
##   * raising the reservation LOWERS the ceiling and clamps live Health DOWN:
##     `life = min(life, ceiling)` -- a ceiling change, NOT damage (no hit is
##     recorded, no signal fires, `hits_taken` and `total_damage` do not move);
##   * lowering or removing it RAISES the ceiling and leaves live Health where
##     it is -- REMOVING A RESERVATION IS NOT HEALING;
##   * every write that would raise live Health is capped by it, because the
##     setter below applies it to EVERY write. There is no healing mechanic in
##     this project; the one existing raise path is `reset()`.
## INF means "no ceiling": every enemy's ledger, and any ledger no pool governs.
## From D-370 until D-382 there was no ceiling at all, and D-381's review HUD
## showed live Health above usable Health (AD-11) -- true when written.
var ceiling: float = INF
var ceiling_clamps: int = 0

var life: float = 1.0:
	set(value):
		life = minf(value, ceiling)
var dead: bool = false

## An append-only record of what happened, in order.
var events: Array[String] = []
var hits_taken: int = 0
var total_damage: float = 0.0

func _init(maximum: float) -> void:
	max_life = maximum
	life = maximum

func apply(amount: float, from: Vector3) -> bool:
	if dead or amount <= 0.0:
		return false
	life = maxf(0.0, life - amount)
	hits_taken += 1
	total_damage += amount
	events.append("hit:%.2f" % amount)
	damaged.emit(amount, from)
	if life <= 0.0:
		dead = true
		events.append("death")
		died.emit()
	return true

## Sets the usable ceiling. A LOWER ceiling clamps live Health down to it; a
## HIGHER one heals nothing. Called only by the live `ResourcePool`.
func set_ceiling(value: float) -> void:
	ceiling = maxf(0.0, value)
	if life > ceiling:
		life = ceiling
		ceiling_clamps += 1

func fraction() -> float:
	return life / max_life if max_life > 0.0 else 0.0

## True only if a hit was recorded BEFORE the death, in this ledger's own order.
## Returns false when no death happened at all, so it can never pass vacuously.
func hit_preceded_death() -> bool:
	var d := events.find("death")
	if d < 0:
		return false
	for i in range(d):
		if events[i].begins_with("hit:"):
			return true
	return false

func reset() -> void:
	life = max_life
	dead = false
	events = []
	hits_taken = 0
	total_damage = 0.0
