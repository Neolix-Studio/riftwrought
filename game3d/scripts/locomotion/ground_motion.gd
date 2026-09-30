class_name GroundMotion
extends RefCounted

## THE REDIRECTION ARITHMETIC — pure, static, and measurable EXACTLY (D-400).
##
## ============================================================================
## GROUND MOVEMENT HAS SCALAR SPEED BUT NO DIRECTIONAL INERTIA.
## ============================================================================
## The owner's finding: at high movement speed the actor kept travelling in a
## direction nobody had asked for any more. THE CAUSE, read in code rather than
## guessed: the accepted motor moved the whole VELOCITY VECTOR toward its target
## with `move_toward`, so a change of direction was served by turning the vector
## through the intermediate directions at the acceleration rate. At 3.889 m/s a
## 180 degree reversal therefore spent 2 x 3.889 / 30.0 = 0.259 s travelling the
## OLD way; at the D-398 EXTREME diagnostic speed it spent the same 0.259 s
## covering three times the ground. THAT IS DIRECTIONAL INERTIA, and it is
## exactly what the ruling removes.
##
## ---------------------------------------------------------------------------
## THE MODEL, IN ONE SENTENCE.
## ---------------------------------------------------------------------------
## The actor carries a SCALAR SPEED and moves along the COMMANDED DIRECTION. A
## change of commanded direction moves the scalar onto the new direction IN THE
## SAME STEP; the scalar itself still accelerates and still brakes, at rates that
## scale with the current maximum so their RESPONSE TIME never changes.
##
## ---------------------------------------------------------------------------
## WHAT THIS DELIBERATELY DOES NOT DO.
## ---------------------------------------------------------------------------
##   * it does not touch the ACTION brake (LD-02);
##   * it does not touch collision response: `move_and_slide` still resolves it,
##     so legitimate sliding ALONG a wall is untouched (item 7);
##   * it does not know about input devices, navigation, animation or the camera;
##   * it introduces no tunable of its own. The redirection is an identity, and
##     the two numbers it reads live in `LocomotionConfig`.
##
## Every function here is STATIC and PURE, so the verification suite can measure
## the arithmetic EXACTLY instead of sampling a moving character and hoping --
## the same reason `LocomotionMotor` was a plain object in the accepted
## foundation.

## The ratio the accepted rates are scaled by. 1.0 at the accepted speed, so the
## accepted acceleration and braking are unchanged where they were accepted.
static func rate_scale(top_speed: float) -> float:
	if LocomotionConfig.RATE_REFERENCE_MPS <= 0.0:
		return 1.0
	return maxf(0.0, top_speed) / LocomotionConfig.RATE_REFERENCE_MPS

## Acceleration at the CURRENT maximum. PROVISIONAL, and derived: the accepted
## constant times the ratio above.
static func accel_rate(top_speed: float) -> float:
	return ProdConfig.ACCEL_MPS2 * rate_scale(top_speed)

## ORDINARY braking at the current maximum. The ACTION brake is NOT this and is
## NOT scaled -- see `LocomotionMotor.brake` and LD-02.
static func brake_rate(top_speed: float) -> float:
	return ProdConfig.DECEL_MPS2 * rate_scale(top_speed)

## The planar direction of a wish vector, and its magnitude, clamped to 1.
## Returns [direction (Vector3, zero when there is no order), magnitude].
static func wish_parts(wish: Vector3) -> Array:
	var w := wish
	w.y = 0.0
	var l := w.length()
	if l <= LocomotionConfig.WISH_EPSILON:
		return [Vector3.ZERO, 0.0]
	if l > 1.0:
		return [w / l, 1.0]
	return [w / l, l]

## ============================================================================
## ONE STEP. THE WHOLE OF THE REDIRECTION IS HERE.
## ============================================================================
## `top_speed` is the CURRENT allowed maximum -- the accepted top speed times the
## declared diagnostic travel-speed scale. `speed_ceiling` is an optional further
## cap for THIS step (the arrival ceiling); a negative value means none.
##
## THE RATES ARE KEYED OFF `top_speed`, NEVER OFF THE CEILING. Keying them off a
## ceiling that falls to zero at a destination would make the deceleration rate
## fall to zero with it, and the actor would never stop -- which is a real trap
## and is why the two are separate arguments.
static func step_velocity(velocity: Vector3, wish: Vector3, top_speed: float,
		delta: float, speed_ceiling: float = -1.0) -> Vector3:
	var v := velocity
	v.y = 0.0
	var speed := v.length()
	var cap := maxf(0.0, top_speed)
	var parts := wish_parts(wish)
	var dir: Vector3 = parts[0]
	var mag := float(parts[1])

	# NO ORDER: brake toward rest ALONG THE CURRENT DIRECTION, at the ordinary
	# rate. Releasing or completing an order still brakes to rest (item 5).
	if mag <= 0.0:
		if speed <= 0.0:
			return Vector3.ZERO
		var braked := maxf(0.0, speed - brake_rate(cap) * delta)
		if braked <= 0.0:
			return Vector3.ZERO
		var out_b := (v / speed) * braked
		out_b.y = 0.0
		return out_b

	# AN ORDER: THE SCALAR SPEED MOVES ONTO THE NEW DIRECTION IN THIS SAME STEP.
	#
	# `carried` is the speed the actor already has, clamped to the CURRENT allowed
	# maximum -- so a speed carried out of a faster diagnostic mode cannot become
	# an overspeed, and nothing is lost that the actor was allowed to keep. There
	# is NO burst and NO slowdown in the redirection itself: it is an identity on
	# the scalar.
	var carried := minf(speed, cap)
	var target := cap * mag
	if speed_ceiling >= 0.0:
		target = minf(target, speed_ceiling)
	# The scalar then accelerates or eases toward its target at the ordinary
	# acceleration rate, exactly as the accepted motor did along one direction.
	var moved := move_toward(carried, target, accel_rate(cap) * delta)
	var out := dir * moved
	out.y = 0.0
	return out

## ============================================================================
## THE ARRIVAL CEILING — item 10, with NO new tunable.
## ============================================================================
## The fastest speed from which the ordinary acceleration rate can still bring
## the actor to rest inside `remaining_m`: v = sqrt(2 a s). Both inputs are
## already in the project -- the rate is the registered one and the distance is
## the follower's own remaining path length.
##
## AT THE ACCEPTED SPEED IT NEVER BINDS, and the suite measures that: the order
## is cleared at `ProdConfig.ARRIVE_TOLERANCE_M`, and the ceiling at that
## distance is sqrt(2 x 30.0 x 0.35) = 4.583 m/s, which is above the accepted
## 3.889 m/s. So accepted arrival behaviour is unchanged, and the ceiling engages
## only where the diagnostic speeds put the actor beyond its own braking
## distance.
static func arrival_speed_ceiling(remaining_m: float, top_speed: float) -> float:
	var a := accel_rate(top_speed)
	if a <= 0.0:
		return maxf(0.0, top_speed)
	return sqrt(2.0 * a * maxf(0.0, remaining_m))

## The angle between two planar directions, in degrees. Zero-length returns 0.
static func direction_angle_deg(a: Vector3, b: Vector3) -> float:
	var x := a
	var y := b
	x.y = 0.0
	y.y = 0.0
	if x.length() < LocomotionConfig.WISH_EPSILON or y.length() < LocomotionConfig.WISH_EPSILON:
		return 0.0
	return rad_to_deg(x.normalized().angle_to(y.normalized()))

## THE MEASURE OF LEFTOVER INERTIA: how much of `velocity` is NOT along the
## commanded direction. It is exactly 0.0 after a redirect, and it is what the
## superseded model left behind.
static func lateral_speed(velocity: Vector3, commanded: Vector3) -> float:
	var v := velocity
	v.y = 0.0
	var c := commanded
	c.y = 0.0
	if c.length() < LocomotionConfig.WISH_EPSILON:
		return v.length()
	var n := c.normalized()
	return (v - n * v.dot(n)).length()
