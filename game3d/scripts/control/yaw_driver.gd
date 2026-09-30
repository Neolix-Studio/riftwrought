class_name YawDriver
extends RefCounted

## CONTINUOUS 3D YAW, rate-limited.
##
## ============================================================================
## D-367 CLOSED THE 3D FACING QUESTION: CONTINUOUS YAW.
## ============================================================================
## `design/COMBAT_IDENTITY_AND_MOMENT_TO_MOMENT.md` section 0.1 refused continuous
## yaw BECAUSE A PIXEL-ART SPRITE IS NEVER ROTATED -- a 2D-specific premise. The
## owner ruled directly that the eight-direction facing restriction of the
## pixel-art prototype is NOT preserved in 3D, and CLAUDE.md section 12.1 clause 3
## says plainly: do not reintroduce a quantised facing restriction.
##
## SO THERE IS NO SECTOR INDEX AND NO HYSTERESIS IN THIS FILE, and there must
## never be one. The 2D prototype's C1 and C2 keep their own passes in game2d/;
## they are not inherited here, and a rate limit is NOT a renamed hysteresis --
## it is a different mechanism for a different job.
##
## D-367 decided a DIRECTION and authorized no implementation, so the rate below
## is PROVISIONAL and is measured by the suite, never cited as settled.

var yaw: float = 0.0          ## radians
var steps: int = 0
var last_step_delta_rad: float = 0.0

## The yaw that faces a planar direction. Godot's forward is -Z, and the
## character meshes in this corpus face +Z, so the sign convention is stated
## once here and nowhere else in the project.
static func yaw_to(dir: Vector3) -> float:
	var d := dir
	d.y = 0.0
	if d.length() < 0.0001:
		return 0.0
	return atan2(d.x, d.z)

## Moves `yaw` toward `target` by at most the provisional rate, along the
## SHORT way round. Returns the new yaw.
func step(target: float, delta: float) -> float:
	steps += 1
	var max_step := deg_to_rad(ProdConfig.YAW_RATE_DEG_PER_S) * delta
	var diff := wrapf(target - yaw, -PI, PI)
	var applied := clampf(diff, -max_step, max_step)
	last_step_delta_rad = absf(applied)
	yaw = wrapf(yaw + applied, -PI, PI)
	return yaw

func snap(target: float) -> void:
	yaw = wrapf(target, -PI, PI)
