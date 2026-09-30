class_name ScaleCalibrationData
extends Resource
## First-MVP Gate 1A — the authoritative local calibration record.
##
## Specification §8: "Measurements must be derived from the scene geometry or
## the authoritative local calibration record. Do not type expected numbers into
## a label independently of what the scene uses." This resource is that record.
## The hall BUILDS from it and the overlay MEASURES the result, so a number on
## screen is either something this record asked for or something the geometry
## actually is — never a third, hand-typed opinion.
##
## Every value here is a CANDIDATE first-MVP calibration value under D-195, not
## a decision and not permission to rewrite Prototype Zero's accepted defaults.
## The §4 block reproduces D-175's accepted Prototype Zero measurements as the
## Gate 1A starting values; the marker block below it holds test inputs whose
## sizes the project owner has not chosen.

@export_group("Specification §4 — candidate spatial baseline")
## 1 Godot unit = this many metres. Locked at 1.0 for Prototype Zero by D-175.
@export var world_unit_metres: float = 1.0
## P — the player's approximate collision diameter, in metres.
@export var player_unit_metres: float = 0.80
@export var camera_distance_metres: float = 19.0
@export var camera_pitch_degrees: float = 55.0
@export var camera_fov_degrees: float = 45.0
@export var maximum_movement_speed: float = 5.0

@export_group("Specification §4.1 — hall footprint target, in P")
@export var target_hall_length_p: float = 64.0
@export var target_hall_width_p: float = 36.0
## Coherent KayKit module dimensions may move either axis by at most one floor
## module. The module is 4.000 m measured from the imported glTF.
@export var floor_module_metres: float = 4.0

@export_group("Specification §4.2 — width comparisons, in P")
## Deliberately uncomfortable lower-bound comparison. NOT an approved ordinary
## production doorway.
@export var stress_gate_p: float = 4.0
@export var ordinary_connector_p: float = 6.0
@export var broad_connector_p: float = 10.0
@export var major_gate_p: float = 14.0
@export var close_lane_p: float = 14.0
@export var broad_lane_p: float = 22.0

@export_group("Specification §6.2 — ranged reading gallery")
## Exact ground-distance marks from the labelled firing origin, in metres.
@export var ranged_mark_metres: PackedFloat32Array = PackedFloat32Array([5.0, 10.0, 15.0])
## The inert reading probe's travel speed. A TEST INPUT for judging readability,
## not a Marrowshot projectile value — Gate 1A authorizes no projectile system.
@export var probe_speed_metres_per_second: float = 18.0
@export var probe_height_metres: float = 1.00

@export_group("Specification §6.1 — role-space placeholders")
## Graveblade-sized. Matches the measured player capsule diameter, which is also
## the Prototype Zero Graveblade's body width.
@export var graveblade_body_diameter_metres: float = 0.80
@export var graveblade_body_height_metres: float = 1.90
## Mauler role-space only. PROVISIONAL: the Mauler has no registered visual
## choice, no AI, no attack, no Life, and no approved body size.
@export var mauler_body_diameter_metres: float = 1.60
@export var mauler_body_height_metres: float = 2.60
## Marrowshot role-space only, same provisional status.
@export var marrowshot_body_diameter_metres: float = 0.80
@export var marrowshot_body_height_metres: float = 1.90
## Radius of the six-strong surround ring around the marked player stand.
@export var surround_ring_radius_metres: float = 1.90
@export var surround_ring_count: int = 6

@export_group("Specification §6.3 — telegraph and hazard test inputs")
## Mauler-sized directional commitment / impact area. TEST INPUTS.
@export var mauler_arc_radius_metres: float = 4.00
@export var mauler_arc_degrees: float = 90.0
## Circular Cinder Seal-sized hazard footprint. A TEST INPUT.
@export var cinder_seal_radius_metres: float = 3.00
## The two alternative presets the court can be cycled to, as multipliers on the
## candidate sizes above, so the owner can feel a smaller and a larger footprint
## without editing anything.
@export var marker_preset_scales: PackedFloat32Array = PackedFloat32Array([1.0, 0.65, 1.45])

@export_group("Verification tolerances")
## How far a built clear width may sit from its authored target before the
## geometry is considered wrong. This is a construction tolerance, not a design
## allowance.
@export var geometry_tolerance_metres: float = 0.02


func metres_for_p(p: float) -> float:
	return p * player_unit_metres


func p_for_metres(metres: float) -> float:
	return metres / maxf(player_unit_metres, 0.0001)


## The §4.1 target footprint in metres, at this record's own conversion.
func target_hall_extent_metres() -> Vector2:
	return Vector2(metres_for_p(target_hall_length_p), metres_for_p(target_hall_width_p))


func problem() -> String:
	if world_unit_metres <= 0.0:
		return "world_unit_metres must be positive"
	if player_unit_metres <= 0.0:
		return "player_unit_metres (P) must be positive"
	if ranged_mark_metres.size() != 3:
		return "specification §6.2 requires exactly three ranged marks"
	if marker_preset_scales.size() < 1 or not is_equal_approx(marker_preset_scales[0], 1.0):
		return "the first marker preset must be the unscaled candidate size"
	return ""
