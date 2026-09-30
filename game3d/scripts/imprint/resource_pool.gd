class_name ResourcePool
extends RefCounted

## LIFE AND MANA, WITH RESERVATION. Deliberately a plain object, not a node, so
## the suite can step it with exact arithmetic.
##
## ============================================================================
## RESERVATION IS NOT SPENDING.
## ============================================================================
## `design/ATTRIBUTES_AND_DAMAGE_MODEL.md` section 9 and
## `design/SKILLS_AND_SKILL_MODIFICATION.md` section 15:
##   "Reservation removes a flat amount or percentage of maximum Mana from the
##    usable pool while the Persistent Skill remains active."
##   "Reservation is not Mana spending and does not activate effects that
##    require Mana to be spent."
##
## The canonical worked example is implemented literally:
##   500 maximum Mana, 20 % reserved  ->  400 usable Mana.
##
## ---------------------------------------------------------------------------
## EXACTLY ONE RESOURCE IS RESERVED PER PERSISTENT CONFIGURATION, NEVER BOTH.
## ---------------------------------------------------------------------------
## The owner's instruction: "It must reserve one resource, not accidentally
## both." That is a negative control, so the pool keeps the two reservations in
## SEPARATE fields and the suite asserts that installing the Mana->Life
## conversion leaves the Mana reservation at EXACTLY ZERO, and vice versa.
## (D-380: the conversion is now PROPORTIONAL; it was a flat "Life tithe" from
## D-375 until D-380.)
##
## EVERY RESERVATION IT RECEIVES IS A PERCENTAGE OF A MAXIMUM (D-378 OD-06). The
## amounts `set_reservation()` receives are computed upstream, in
## `SkillConfiguration.resolve()`, as fraction x maximum; no Imprint and no
## Configuration declares a flat reservation amount anywhere.
##
## ---------------------------------------------------------------------------
## THIS POOL DOES NOT REPLACE THE ACCEPTED `Damageable` LEDGER.
## ---------------------------------------------------------------------------
## The player probe's live Life is still owned by its accepted `Damageable`.
## This pool models the RESERVATION CEILING for both resources and the Mana
## spend, which is what a Skill system needs. Two ledgers for one quantity would
## be a defect, so the division is stated here and nowhere else.
##
## EVERY VALUE IT USES IS PROVISIONAL.

var mana_max: float = ImprintConfig.MANA_MAX
var mana_current: float = ImprintConfig.MANA_MAX
var mana_reserved: float = 0.0

var life_max: float = ImprintConfig.LIFE_MAX
var life_reserved: float = 0.0

## ============================================================================
## THE LIVE HEALTH LEDGER THIS POOL'S LIFE RESERVATION GOVERNS (D-382).
## ============================================================================
## Only the LIVE pool is linked -- `SkillRuntime.compose()` links it to the
## player's own `Damageable`. Every scratch pool the trials build leaves it null
## and so can never touch anyone's Health. From D-375 until D-382 the pool
## modelled a Life reservation as a ceiling nothing read (AD-11).
var health: Damageable = null

## Diagnostics the suite and the panel read.
var spends: int = 0
var spends_refused: int = 0
var total_spent: float = 0.0

func mana_usable() -> float:
	return maxf(0.0, mana_max - mana_reserved)

func life_usable() -> float:
	return maxf(0.0, life_max - life_reserved)

## Sets BOTH reservations at once, so there is exactly one place where "not
## both" can be established -- and one place for a check to attack.
func set_reservation(mana_amount: float, life_amount: float) -> void:
	mana_reserved = maxf(0.0, mana_amount)
	life_reserved = maxf(0.0, life_amount)
	# Reservation reduces the usable pool. Current Mana above the new ceiling is
	# clamped DOWN to it, which is a ceiling change and not a spend.
	mana_current = minf(mana_current, mana_usable())
	# D-382: AND THE SAME TRANSITION MOVES LIVE HEALTH'S CEILING. Activating or
	# increasing a Life reservation clamps current Health to usable Health;
	# reducing or removing it heals nothing. A Mana reservation leaves usable
	# Health -- and so current Health -- exactly where it was.
	_push_health_ceiling()

func _push_health_ceiling() -> void:
	if health != null:
		health.set_ceiling(life_usable())

## True when BOTH reservations are non-zero at once. The defect the owner named,
## given a name of its own so a check can assert it never happens.
func reserves_both() -> bool:
	return mana_reserved > 0.0 and life_reserved > 0.0

## Canon, section 15: "The Skill cost is checked and paid when use begins. A
## Skill cannot begin without sufficient resources." Both halves are here, in
## one function, so neither can be performed without the other.
func spend_mana(amount: float) -> bool:
	if amount <= 0.0:
		spends += 1
		return true
	if mana_current < amount:
		spends_refused += 1
		return false
	mana_current -= amount
	spends += 1
	total_spent += amount
	return true

## ============================================================================
## REGENERATION IS A RATE OF *UNRESERVED MAXIMUM* MANA. (D-378, OD-05; D-380)
## ============================================================================
## "Base Mana regeneration is calculated from UNRESERVED MAXIMUM MANA ... never
## from fluctuating current Mana." Unreserved maximum is `mana_max -
## mana_reserved` -- which is exactly `mana_usable()` -- and it is a CEILING, so
## the rate is the same whether the pool is empty or nearly full. `mana_current`
## is deliberately NOT an input to the rate: it is only what the rate is added to.
##
## From D-375 until D-380 this added a FLAT 22.0 Mana/s whatever was reserved --
## true when written, and the divergence D-378 recorded.
##
## The formula is exposed on its own, with the rate as a parameter, so the
## owner's worked example (100 max, 20 reserved, 2 % -> 1.6 Mana/s) can be
## checked against the RULE rather than against this prototype's provisional
## rate.
static func regen_rate_of(unreserved_maximum: float, rate_fraction: float) -> float:
	return maxf(0.0, unreserved_maximum) * rate_fraction

func unreserved_maximum() -> float:
	return mana_usable()

func regen_per_second() -> float:
	return regen_rate_of(unreserved_maximum(), ImprintConfig.MANA_REGEN_FRACTION_OF_UNRESERVED_PER_S)

func regenerate(delta: float) -> void:
	mana_current = minf(mana_usable(), mana_current + regen_per_second() * delta)

func refill() -> void:
	mana_current = mana_usable()

func reset() -> void:
	mana_reserved = 0.0
	life_reserved = 0.0
	_push_health_ceiling()
	mana_current = mana_max
	spends = 0
	spends_refused = 0
	total_spent = 0.0
