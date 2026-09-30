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

var velocity: Vector3 = Vector3.ZERO
var steps: int = 0

## `wish` is a direction (length <= 1). Returns the new velocity.
func step(wish: Vector3, top_speed: float, delta: float) -> Vector3:
	steps += 1
	var w := wish
	w.y = 0.0
	if w.length() > 1.0:
		w = w.normalized()
	var target := w * top_speed
	var rate := ProdConfig.ACCEL_MPS2 if w.length() > 0.001 else ProdConfig.DECEL_MPS2
	velocity = velocity.move_toward(target, rate * delta)
	velocity.y = 0.0
	return velocity

## Brakes toward rest at an EXPLICIT rate, instead of the ordinary deceleration.
##
## A committed action needs to stop the actor promptly; ordinary braking is tuned
## for how movement should feel when it ENDS NORMALLY, and reusing it here made
## the actor glide 0.199 m through its own attack. Two different jobs, two
## different rates, and the rate is passed in so the motor still owns no policy.
func brake(rate: float, delta: float) -> Vector3:
	steps += 1
	velocity = velocity.move_toward(Vector3.ZERO, rate * delta)
	velocity.y = 0.0
	return velocity

func speed() -> float:
	return velocity.length()

func reset() -> void:
	velocity = Vector3.ZERO
