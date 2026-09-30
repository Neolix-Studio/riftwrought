class_name DirectClickOrder
extends RefCounted

## ONE MOUSE MOVEMENT ORDER, AND THE ONE SWEEP THAT MOVES IT (D-404).
##
## ============================================================================
## STRAIGHT AT THE CLICKED POINT. STOP AT THE FIRST BLOCKER. NOTHING ELSE.
## ============================================================================
## The owner: "I want the player to move directly toward the clicked point and
## run into the obstacle. The player should have to issue additional movement
## clicks to navigate around it."
##
## This object is two things, kept apart on purpose:
##   * the STATE of the current order -- where it was clicked, where it started,
##     how it ended, and the first contact -- which the review HUD and the suite
##     read and which NOTHING in gameplay reads back;
##   * `sweep()`, the collision resolution for ONE click step. It is static and
##     takes the body, so the controller keeps its single `move_and_slide()` for
##     the stick and for braking, and this file owns the one place a click step
##     meets the world.
##
## IT ASKS NAVIGATION FOR NOTHING. There is no path here, no closest-point query
## and no follower: the two counters below exist so a reviewer can SEE zero, and
## no code in the project can raise them, which the suite proves by scanning.

## How the current (or last) order ended. "" while it is still travelling.
const STOP_NONE := ""
const STOP_ARRIVED := "ARRIVED"
const STOP_COLLIDED := "COLLIDED"
const STOP_CANCELLED := "CANCELLED"

var active: bool = false
## The clicked ground point, EXACTLY as clicked, y = 0. Never snapped.
var destination: Vector3 = Vector3.ZERO
## Her ground point when the order was issued: the start of the straight segment.
var origin: Vector3 = Vector3.ZERO
var stop_reason: String = STOP_NONE
var travelled_m: float = 0.0

## The FIRST blocking contact of this order, if it had one.
var has_contact: bool = false
var contact_point: Vector3 = Vector3.ZERO
var contact_normal: Vector3 = Vector3.ZERO
var contact_collider: String = ""
## True when the order was stopped by a contact she was ALREADY touching, so it
## never moved at all (a held cursor behind a wall, frame after frame).
var stopped_at_existing_contact: bool = false

## ZERO, ALWAYS. Shown on the review HUD so the absence is visible. Nothing in
## the project increments either, and the suite proves it by scanning.
var path_points: int = 0
var path_queries: int = 0

## Diagnostic LOGS across orders. Read by the HUD and the suite; never by gameplay.
var orders_issued: int = 0
var arrivals: int = 0
var collisions: int = 0
var cancellations: int = 0
var sweeps: int = 0
var floor_resweeps: int = 0

func begin(from: Vector3, to: Vector3) -> void:
	active = true
	destination = Vector3(to.x, 0.0, to.z)
	origin = Vector3(from.x, 0.0, from.z)
	stop_reason = STOP_NONE
	travelled_m = 0.0
	has_contact = false
	contact_point = Vector3.ZERO
	contact_normal = Vector3.ZERO
	contact_collider = ""
	stopped_at_existing_contact = false
	orders_issued += 1

func finish(reason: String) -> void:
	if not active:
		return
	active = false
	stop_reason = reason
	if reason == STOP_ARRIVED:
		arrivals += 1
	elif reason == STOP_COLLIDED:
		collisions += 1
	elif reason == STOP_CANCELLED:
		cancellations += 1

func record_contact(point: Vector3, normal: Vector3, collider: String) -> void:
	if has_contact:
		return
	has_contact = true
	contact_point = point
	contact_normal = Vector3(normal.x, 0.0, normal.z).normalized()
	contact_collider = collider

## The straight segment this order asks for, as [start, end].
func segment() -> Array:
	return [origin, destination]

## ============================================================================
## ONE CLICK STEP: A CONTINUOUS SWEEP THAT STOPS AT THE FIRST BLOCKER.
## ============================================================================
## `move_and_collide()` sweeps the body's own shape along `motion` and stops it
## AT the first contact -- continuously, so no step of any length can pass
## through anything, which is what "prevent tunnelling at every diagnostic speed"
## needs. It does NOT slide: whatever of the motion is left over after a contact
## is simply not used. That is the whole of "stop at the collision" and "no
## tangential wall sliding".
##
## THE FLOOR IS NOT A BLOCKER. The actor's cylinder rests on the floor slab and a
## horizontal sweep can graze it; a contact whose normal is mostly vertical is
## the floor, and the rest of the motion is swept again, flattened. A contact
## whose normal is mostly HORIZONTAL is a blocker -- a wall, a prop or a body --
## and it ends the step.
##
## Returns {"moved": Vector3, "blocked": bool, "point": Vector3,
##          "normal": Vector3, "collider": String, "sweeps": int}.
static func sweep(body: CharacterBody3D, motion: Vector3) -> Dictionary:
	var out := {"moved": Vector3.ZERO, "blocked": false, "point": Vector3.ZERO,
		"normal": Vector3.ZERO, "collider": "", "sweeps": 0}
	var remaining := Vector3(motion.x, 0.0, motion.z)
	for i in DirectClickConfig.MAX_SWEEPS:
		if remaining.length() <= 0.000001:
			break
		out["sweeps"] = int(out["sweeps"]) + 1
		var before := body.global_position
		var col := body.move_and_collide(remaining, false, body.safe_margin, false, 4)
		var d := body.global_position - before
		d.y = 0.0                 # the plane: a floor recovery is not travel
		out["moved"] = Vector3(out["moved"]) + d
		if col == null:
			break
		var blocker := -1
		for k in col.get_collision_count():
			if absf(col.get_normal(k).y) < DirectClickConfig.WALL_NORMAL_MAX_Y:
				blocker = k
				break
		if blocker >= 0:
			out["blocked"] = true
			out["point"] = col.get_position(blocker)
			out["normal"] = col.get_normal(blocker)
			# WHAT IT HIT, IN WORDS A REVIEWER CAN READ. The arena's duplicate static
			# bodies carry engine-generated names ("@StaticBody3D@338"), which the
			# first rendered frame showed on the HUD (D-404); world geometry is
			# therefore named as such, and a BODY -- an enemy -- by its own name.
			var who = col.get_collider(blocker)
			if who is StaticBody3D:
				out["collider"] = "world geometry"
			elif who is Node:
				out["collider"] = String((who as Node).name)
			else:
				out["collider"] = "?"
			break
		# ONLY THE FLOOR WAS TOUCHED: sweep what is left, flattened.
		remaining = col.get_remainder()
		remaining.y = 0.0
	return out
