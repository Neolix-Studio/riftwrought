class_name P1CFacing
extends RefCounted

## P1C-H — eight-way facing with hysteresis.
##
## **Eight authored directions, never mirrored.** D-347 ruling 1 forbids mirroring an
## asymmetric character: a flip would move the bow to the wrong hand and the quiver to the
## wrong shoulder. This module returns an INDEX into the eight authored animations and
## nothing else — it never returns a flip, a transform or a scale.
##
## The sector index matches `P1AArt.DIRECTION_TOKENS` exactly:
## `0 e · 1 se · 2 s · 3 sw · 4 w · 5 nw · 6 n · 7 ne`, measured clockwise from screen +x
## with screen +y downward, which is the order the owner's art is authored in.

const SECTOR_COUNT: int = 8
const SECTOR_DEG: float = 360.0 / float(SECTOR_COUNT)   ## 45.0
const HALF_SECTOR_DEG: float = SECTOR_DEG * 0.5         ## 22.5

## **The hysteresis margin, in degrees beyond the sector boundary.** Facing changes only
## once the aim is further than `HALF_SECTOR_DEG + MARGIN` from the CURRENT sector's centre.
##
## **This is a different rule for a different job from the accepted substantial-turn
## threshold, and the two must never be conflated** (D-347 ruling 1). This one stops a
## drawn sprite flickering at a boundary; that one is a gameplay turn decision.
##
## **PROPOSED by this proof, not a lock.** The owner rules on it.
const MARGIN_DEG: float = 7.0


## The angle of a vector in screen space, degrees in [0, 360).
static func angle_of(v: Vector2) -> float:
	return fposmod(rad_to_deg(atan2(v.y, v.x)), 360.0)


## The centre angle of a sector index.
static func sector_centre_deg(index: int) -> float:
	return fposmod(float(index) * SECTOR_DEG, 360.0)


## The smallest signed difference between two angles, in (-180, 180].
static func angle_delta(a: float, b: float) -> float:
	return wrapf(a - b, -180.0, 180.0)


## The sector a direction falls in, with NO hysteresis. Used for a cold start and for the
## C1 measurement.
static func sector_of(v: Vector2) -> int:
	if v.length_squared() <= 0.0:
		return -1
	return int(roundf(angle_of(v) / SECTOR_DEG)) % SECTOR_COUNT


## The sector to draw, given the sector currently drawn.
##
## Returns `current` unchanged unless the aim has moved further than
## `HALF_SECTOR_DEG + MARGIN_DEG` from `current`'s centre. `current = -1` means nothing is
## drawn yet, so the nearest sector is taken immediately.
static func sector_with_hysteresis(v: Vector2, current: int) -> int:
	if v.length_squared() <= 0.0:
		return current
	if current < 0 or current >= SECTOR_COUNT:
		return sector_of(v)
	var drift: float = absf(angle_delta(angle_of(v), sector_centre_deg(current)))
	if drift <= HALF_SECTOR_DEG + MARGIN_DEG:
		return current
	return sector_of(v)


## The animation name for a sector index, straight from the accepted art's own tokens.
static func animation_for(index: int, tokens: Array) -> String:
	if index < 0 or index >= tokens.size():
		return ""
	return String(tokens[index])
