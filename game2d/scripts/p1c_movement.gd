class_name P1CMovement
extends RefCounted

## P1C-H — continuous movement. **No grid locking** (D-347 ruling 1).
##
## Pure arithmetic so the headless suite can measure speed, acceleration and braking
## exactly rather than sampling a running scene. A sampled measurement is not a measurement
## of the thing you designed.

## **The accepted 3D locomotion value, RE-TESTED in 2D — not inherited as a 2D lock.**
## Gate B locked 5.0 m/s in the 3D project; P1A established that 3D measurements are
## evidence about Riftwrought, not automatic 2D values. This proof measures what 5.0 m/s
## feels like on the locked 2D lattice and reports it.
const TOP_SPEED_MPS: float = 5.0

## **PROPOSED by this proof, not locks.** The owner rules on them.
const ACCELERATION_MPS2: float = 25.0
const BRAKING_MPS2: float = 30.0

## C5's radial deadzone. Radial, not per-axis: a per-axis deadzone makes a stick's
## diagonals reach further than its cardinals, which is a different control feel.
const DEADZONE: float = 0.20

## A stick that stops reporting must not leave the actor gliding. Anything at or below this
## magnitude is treated as released.
const STALE_STICK_EPSILON: float = 0.001


## The stick vector after the radial deadzone, rescaled so the live range still spans 0..1.
static func apply_deadzone(raw: Vector2) -> Vector2:
	var m: float = raw.length()
	if m <= DEADZONE:
		return Vector2.ZERO
	var scaled: float = (m - DEADZONE) / (1.0 - DEADZONE)
	return raw.normalized() * minf(scaled, 1.0)


## One integration step, in metres per second. `wish` is the post-deadzone stick.
static func step(velocity_mps: Vector2, wish: Vector2, dt: float) -> Vector2:
	if wish.length() <= STALE_STICK_EPSILON:
		# Braking: reduce toward zero, never past it.
		var speed: float = velocity_mps.length()
		if speed <= 0.0:
			return Vector2.ZERO
		var shed: float = BRAKING_MPS2 * dt
		if shed >= speed:
			return Vector2.ZERO
		return velocity_mps - velocity_mps.normalized() * shed
	var target: Vector2 = wish * TOP_SPEED_MPS
	var delta: Vector2 = target - velocity_mps
	var gain: float = ACCELERATION_MPS2 * dt
	if delta.length() <= gain:
		return target
	return velocity_mps + delta.normalized() * gain


## Seconds to reach `fraction` of top speed from rest under full input.
static func time_to_fraction_of_top(fraction: float, dt: float) -> float:
	var v: Vector2 = Vector2.ZERO
	var t: float = 0.0
	var target: float = TOP_SPEED_MPS * fraction
	for _i: int in range(100000):
		v = step(v, Vector2.RIGHT, dt)
		t += dt
		if v.length() >= target:
			return t
	return -1.0


## Seconds to come to rest from top speed with no input.
static func time_to_stop(dt: float) -> float:
	var v: Vector2 = Vector2.RIGHT * TOP_SPEED_MPS
	var t: float = 0.0
	for _i: int in range(100000):
		v = step(v, Vector2.ZERO, dt)
		t += dt
		if v.length() <= 0.0:
			return t
	return -1.0
