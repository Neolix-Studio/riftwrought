extends SceneTree
## Reference Landing Recreation -- Session 1 headless check (NON-CANONICAL).
##
## Walks ReferenceLandingBlueprint.CENTERLINE, prints the measured total arc
## length and the estimated direct-traversal time at the accepted 5.0 m/s, and
## exits non-zero (still with zero SCRIPT ERROR lines) if the length falls
## outside the session brief's stated +/-10% tolerance around 150 m.
##
## Run with:
##   godot --headless --path game --import
##   godot --headless --path game --script res://scripts/concepts/reference_landing_recreation/blueprint_check.gd

const TARGET_LENGTH_METERS: float = 150.0
const LENGTH_TOLERANCE_FRACTION: float = 0.10
const ACCEPTED_MAX_SPEED: float = 5.0

func _initialize() -> void:
	print("=== Reference Landing Recreation -- Session 1 blueprint check ===")

	var length: float = ReferenceLandingBlueprint.total_arc_length()
	var travel_seconds: float = ReferenceLandingBlueprint.traversal_time_seconds(ACCEPTED_MAX_SPEED)

	print("")
	print("waypoints: %d" % ReferenceLandingBlueprint.CENTERLINE.size())
	for i in range(ReferenceLandingBlueprint.CENTERLINE.size()):
		print("  [%d] %s" % [i, ReferenceLandingBlueprint.CENTERLINE[i]])
	print("SPAWN    = %s" % ReferenceLandingBlueprint.SPAWN)
	print("MIDPOINT = %s" % ReferenceLandingBlueprint.MIDPOINT)
	print("PORTAL   = %s" % ReferenceLandingBlueprint.PORTAL)
	print("")
	print("total centerline arc length: %.3f m" % length)
	print("estimated direct-traversal time at %.1f m/s: %.3f s" % [ACCEPTED_MAX_SPEED, travel_seconds])

	var lower: float = TARGET_LENGTH_METERS * (1.0 - LENGTH_TOLERANCE_FRACTION)
	var upper: float = TARGET_LENGTH_METERS * (1.0 + LENGTH_TOLERANCE_FRACTION)
	var length_ok: bool = length >= lower and length <= upper
	print("")
	print("length within +/-10%% of %.0f m [%.3f, %.3f]: %s" % [
		TARGET_LENGTH_METERS, lower, upper, "PASS" if length_ok else "FAIL",
	])

	if length_ok:
		print("BLUEPRINT CHECK: PASS")
		quit(0)
	else:
		printerr("BLUEPRINT CHECK: FAIL")
		quit(1)
