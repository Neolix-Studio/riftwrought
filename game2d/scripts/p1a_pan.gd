class_name P1APan
extends RefCounted

## P1A — the deterministic five-second diagonal camera pan.
##
## Deterministic means what it says: the pan is a pure function of a frame index. It
## never reads `delta`, never reads the clock and never reads input, so two runs on two
## machines produce the same camera positions and the captured frames are comparable.

const DURATION_S: float = 5.0
const STEP_S: float = 1.0 / 60.0
const FRAME_COUNT: int = 300  ## 300 * 1/60 s = 5.000 s exactly

## Illustrative only. 5.0 m/s is the ACCEPTED 3D maximum movement speed, used here so
## the pan moves at a speed the owner will recognise. **P1A canonizes no 2D value.**
const SPEED_MPS: float = 5.0

## Deliberately not axis-aligned and deliberately not a whole number of pixels per
## frame: a pan that happened to land on whole pixels every frame would hide exactly
## the defect this stage exists to find.
const DIRECTION: Vector2 = Vector2(0.70710678, 0.70710678)


static func elapsed_s(frame: int) -> float:
	return float(frame) * STEP_S


## The camera's UNSNAPPED target, in world pixels, at a frame index.
static func target(frame: int, px_per_m: float, origin: Vector2) -> Vector2:
	var t: float = elapsed_s(frame)
	return origin + DIRECTION * (SPEED_MPS * t * px_per_m)


## The camera position each approach actually uses, and the sub-pixel remainder that
## approach 3 hands to the display.
static func snapped(approach: int, frame: int, px_per_m: float, origin: Vector2) -> Dictionary:
	var want: Vector2 = target(frame, px_per_m, origin)
	match approach:
		P1ARenderMode.Approach.PIXEL_SNAPPED_CANVAS:
			# Whole WORLD pixels. The canvas scale is fractional, so a whole world pixel
			# is a fractional number of device pixels — which is the crawl this
			# approach is being measured for.
			return {"camera": want.floor(), "remainder": Vector2.ZERO}
		_:
			# Whole BASE pixels for both 1 and 3; only 3 uses the remainder.
			var base_px: Vector2 = want.floor()
			return {"camera": base_px, "remainder": want - base_px}
