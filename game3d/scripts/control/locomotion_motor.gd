class_name LocomotionMotor
extends RefCounted

## THE MOTOR — a wish direction in, a velocity out. Nothing else.
##
## It knows nothing about input devices, navigation, animation or the camera. It
## is deliberately a plain object rather than a node, so the verification suite
## can measure acceleration and braking EXACTLY, by stepping it with a known
## delta, instead of sampling a moving character and hoping.
##
## MOTION IS PLANAR. The simulation is one continuous plane: y is never a
## gameplay coordinate, so the motor zeroes it rather than trusting callers.
##
## All three values it uses are PROVISIONAL.
##
## ============================================================================
## D-400: THE ARITHMETIC MOVED TO `GroundMotion`, AND THE VECTOR GAINED NO
## INERTIA IN THE MOVE.
## ============================================================================
## Until D-400 `step()` read:
##     var target := w * top_speed
##     var rate := ProdConfig.ACCEL_MPS2 if w.length() > 0.001 else ProdConfig.DECEL_MPS2
##     velocity = velocity.move_toward(target, rate * delta)
## -- TRUE WHEN WRITTEN, and the accepted D-373 behaviour. Moving the whole
## VECTOR toward its target is what gave ground movement DIRECTIONAL INERTIA: a
## change of direction was served by turning the vector through the intermediate
## directions at the acceleration rate, so the actor kept travelling a way nobody
## had asked for. The owner's D-400 ruling removes exactly that.
##
## This object is now the STATE (a velocity, and diagnostics the suite reads) and
## `GroundMotion` is the ARITHMETIC. The signature is unchanged except for one
## OPTIONAL trailing argument, so every accepted caller -- including the accepted
## suite's own `F30` and `F77`, which step it with three arguments -- is untouched
## and still measures the accepted rates at the accepted speed.

var velocity: Vector3 = Vector3.ZERO
var steps: int = 0

## Diagnostics the suite and the captures read. These are LOGS, not control state.
var redirects: int = 0
var last_redirect_deg: float = 0.0
var last_redirect_speed_in: float = 0.0
var last_redirect_speed_out: float = 0.0
var worst_lateral_speed: float = 0.0

## `wish` is a direction (length <= 1). `top_speed` is the CURRENT allowed
## maximum. `speed_ceiling` is an optional further cap for THIS step, negative
## when there is none. Returns the new velocity.
func step(wish: Vector3, top_speed: float, delta: float,
		speed_ceiling: float = -1.0) -> Vector3:
	steps += 1
	var before := velocity
	velocity = GroundMotion.step_velocity(velocity, wish, top_speed, delta, speed_ceiling)
	# A REDIRECT IS RECORDED, NOT CAUSED, HERE. The turn has already happened in
	# the arithmetic above; this only measures it, so the log can never disagree
	# with the motion.
	var turn := GroundMotion.direction_angle_deg(before, velocity)
	if turn > 0.5 and before.length() > LocomotionConfig.WISH_EPSILON:
		redirects += 1
		last_redirect_deg = turn
		last_redirect_speed_in = before.length()
		last_redirect_speed_out = velocity.length()
	worst_lateral_speed = maxf(worst_lateral_speed, GroundMotion.lateral_speed(velocity, wish))
	return velocity

## Brakes toward rest at an EXPLICIT rate, instead of the ordinary deceleration.
##
## A committed action needs to stop the actor promptly; ordinary braking is tuned
## for how movement should feel when it ENDS NORMALLY, and reusing it here made
## the actor glide 0.199 m through its own attack. Two different jobs, two
## different rates, and the rate is passed in so the motor still owns no policy.
##
## D-400 LEAVES THIS EXACTLY AS ACCEPTED, AND DELIBERATELY DOES NOT SCALE IT.
## The ruling names "acceleration and ordinary braking"; the ACTION brake is
## neither, and item 11 forbids altering Skill timing. The consequence at the
## diagnostic speeds is MEASURED by the D-400 suite and carried as `LD-02`.
func brake(rate: float, delta: float) -> Vector3:
	steps += 1
	velocity = velocity.move_toward(Vector3.ZERO, rate * delta)
	velocity.y = 0.0
	return velocity

func speed() -> float:
	return velocity.length()

func reset() -> void:
	velocity = Vector3.ZERO
