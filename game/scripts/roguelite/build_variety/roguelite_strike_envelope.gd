class_name RogueliteStrikeEnvelope
extends Node3D
## Riftwrought — Roguelite Build Variety V1: a brief, restrained outline of the
## Quick Strike release envelope, drawn where the swing actually landed
## (decision D-223).
##
## WHY IT EXISTS. Two of the four upgrades are SPATIAL — Reaching Edge moves
## `QuickStrikeData.reach`, Sweeping Edge moves `release_arc_degrees` — and a
## number on a banner is not a way to judge whether a longer or a wider swing
## changes how the game is played. This draws the envelope the release query
## actually used, for a moment, on the ground, so the project owner can SEE the
## difference they are being asked about instead of reading it.
##
## IT READS THE LIVE RECORD, WHICH IS WHAT MAKES IT EVIDENCE RATHER THAN
## DECORATION. The radius is `player.attack.data.reach` and the sweep is
## `player.attack.data.release_arc_degrees` — the SAME private runtime record
## `TargetAcquisition.resolve_release()` was handed on the same frame, read on
## the frame it was used. The picture therefore cannot disagree with the query:
## there is no second copy of either number and no second formula. The project's
## own recorded lesson is that a derivation checked only against itself proves
## its arithmetic is repeatable, and its other one is that some defects are only
## visible in a picture; this is the second lesson answered without reopening
## the first.
##
## THE BASELINE IS DRAWN BESIDE IT, DIMLY, AND ONLY WHEN IT DIFFERS. A lone
## brighter arc says nothing about whether it grew. `QuickStrikeAction` already
## keeps the authored record beside its runtime copy as `canonical_data`
## (D-191), so the unupgraded 1.65 m / 100 deg envelope is available without
## capturing, remembering or recomputing anything — and reading it from there
## rather than from a captured baseline is the same rule D-191 wrote: compute
## from the canonical record, never from your own previous result.
##
## IT IS DIAGNOSTIC INSTRUMENTATION AND NOT A GAME EFFECT. No particle system,
## no shader file, no texture, no asset, no audio: one `ImmediateMesh` of
## unshaded lines, rebuilt per swing and faded out on the idle clock. It is not
## a telegraph, it is not a targeting aid, it does not persist, it does not
## follow the player, and it changes no query — nothing reads it back. It can be
## switched off entirely (F8) and the game underneath is bit-for-bit the same.
##
## IT IS DRIVEN BY A SIGNAL THE ACCEPTED KERNEL ALREADY EMITS.
## `QuickStrikeAction.use_released(id, outcome)` fires synchronously inside
## `_fire_release()`, immediately after the query, carrying the exact
## `facing_degrees` the query used. Nothing in the combat kernel is edited to
## make this drawing possible.

## How long one envelope stays on screen before it has fully faded. Long enough
## to read at the accepted 19 m camera, short enough that a held repeat at the
## upgraded 0.64 s action time never stacks two at full strength.
const LIFETIME: float = 0.45

## Height above the ground plane. The review grid sits at 0.02 and the ground
## plates' top face is 0.00, so this clears both without floating.
const HEIGHT: float = 0.06

## How many line segments the rim is drawn with, per full turn. The rim is a
## fraction of a turn, so a 100 degree arc gets 20 segments and a 180 degree arc
## gets 36 — smooth enough to read as an arc at either width.
const SEGMENTS_PER_TURN: int = 72

## The project's own placeholder instrumentation palette: violet for the live
## envelope, muted copper for the baseline. THE BASELINE WAS FIRST DRAWN IN A
## DIM GREY, AND A RENDERED FRAME SHOWED IT WAS EFFECTIVELY INVISIBLE against
## the pale greybox floor — which defeats the only reason it is drawn at all,
## since a lone brighter arc says nothing about whether the envelope grew.
const CURRENT_COLOUR: Color = Color(0.72, 0.58, 0.98, 0.95)
const BASELINE_COLOUR: Color = Color(0.92, 0.62, 0.28, 0.90)

## Set false by F8. When off, nothing is drawn at all — the node stays in the
## tree and stays bound, so the toggle cannot change what the game does.
var enabled: bool = true

## Instrumentation, the same spirit as every other counter in this review.
var draws: int = 0
var last_reach: float = 0.0
var last_arc_degrees: float = 0.0
var last_baseline_reach: float = 0.0
var last_baseline_arc_degrees: float = 0.0
var last_facing_degrees: float = 0.0
var last_origin: Vector3 = Vector3.ZERO
var last_differs_from_baseline: bool = false

var _mesh_instance: MeshInstance3D
var _material: StandardMaterial3D
var _remaining: float = 0.0


func _ready() -> void:
	_material = StandardMaterial3D.new()
	_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	_material.vertex_color_use_as_albedo = true
	_material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	_material.cull_mode = BaseMaterial3D.CULL_DISABLED
	## Drawn on top of the ground rather than z-fighting with it. The project
	## made the same call for the Zone Composer's marker gizmos, and for the same
	## reason: an outline the reader has to hunt for behind geometry is worse
	## than no outline.
	_material.no_depth_test = true

	_mesh_instance = MeshInstance3D.new()
	_mesh_instance.name = "Envelope"
	_mesh_instance.mesh = ImmediateMesh.new()
	_mesh_instance.material_override = _material
	_mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	_mesh_instance.visible = false
	add_child(_mesh_instance)


func set_enabled(value: bool) -> void:
	enabled = value
	if not enabled:
		hide_now()


func hide_now() -> void:
	_remaining = 0.0
	if _mesh_instance != null:
		_mesh_instance.visible = false


## Draws one envelope. `current` is the action's live private record and
## `baseline` its canonical authored record — both passed in rather than looked
## up, so this node holds no reference to the player and cannot be the thing
## that keeps a freed actor alive.
func draw_for(
	origin: Vector3,
	facing_degrees: float,
	current: QuickStrikeData,
	baseline: QuickStrikeData
) -> void:
	if not enabled or _mesh_instance == null or current == null:
		return
	draws += 1
	last_origin = origin
	last_facing_degrees = facing_degrees
	last_reach = current.reach
	last_arc_degrees = current.release_arc_degrees
	last_baseline_reach = baseline.reach if baseline != null else current.reach
	last_baseline_arc_degrees = (baseline.release_arc_degrees if baseline != null
		else current.release_arc_degrees)
	last_differs_from_baseline = (not is_equal_approx(last_reach, last_baseline_reach)
		or not is_equal_approx(last_arc_degrees, last_baseline_arc_degrees))

	var mesh: ImmediateMesh = _mesh_instance.mesh as ImmediateMesh
	mesh.clear_surfaces()
	mesh.surface_begin(Mesh.PRIMITIVE_LINES)
	if last_differs_from_baseline:
		_add_envelope(mesh, last_baseline_reach, last_baseline_arc_degrees,
			facing_degrees, BASELINE_COLOUR)
	_add_envelope(mesh, last_reach, last_arc_degrees, facing_degrees, CURRENT_COLOUR)
	mesh.surface_end()

	## The mesh is authored around the origin in LOCAL space and the NODE is
	## moved to where the swing happened. Emitting world coordinates as local
	## vertices is precisely the defect the accepted core loop found in its own
	## debug grid, where every module drew at double its offset and only the hub
	## — which sits at the origin — looked correct.
	global_position = Vector3(origin.x, HEIGHT, origin.z)
	global_rotation = Vector3.ZERO
	_mesh_instance.visible = true
	_remaining = LIFETIME
	_apply_fade()


func _add_envelope(
	mesh: ImmediateMesh, radius: float, arc_degrees: float, facing_degrees: float, colour: Color
) -> void:
	if radius <= 0.0 or arc_degrees <= 0.0:
		return
	var half: float = deg_to_rad(minf(arc_degrees, 360.0) * 0.5)
	var centre: float = deg_to_rad(facing_degrees)
	var steps: int = maxi(2, int(round(SEGMENTS_PER_TURN * minf(arc_degrees, 360.0) / 360.0)))

	## The rim, from one arc edge to the other.
	var previous: Vector3 = _rim_point(centre - half, radius)
	for step: int in range(1, steps + 1):
		var angle: float = centre - half + (2.0 * half) * (float(step) / float(steps))
		var here: Vector3 = _rim_point(angle, radius)
		mesh.surface_set_color(colour)
		mesh.surface_add_vertex(previous)
		mesh.surface_set_color(colour)
		mesh.surface_add_vertex(here)
		previous = here

	## The two radial edges, so the arc reads as a sector rather than a stripe.
	for edge: float in [centre - half, centre + half]:
		mesh.surface_set_color(colour)
		mesh.surface_add_vertex(Vector3.ZERO)
		mesh.surface_set_color(colour)
		mesh.surface_add_vertex(_rim_point(edge, radius))


## The project's measured facing convention: the KayKit medium rig faces +Z at
## identity, so a yaw of `theta` points along (sin, 0, cos) — the same
## `atan2(x, z)` relationship `QuickStrikeAction` reports its facing with, read
## back the other way. Using the Godot -Z convention here would draw every
## envelope 180 degrees out.
static func _rim_point(angle: float, radius: float) -> Vector3:
	return Vector3(sin(angle) * radius, 0.0, cos(angle) * radius)


func _process(delta: float) -> void:
	if _remaining <= 0.0:
		return
	_remaining -= delta
	if _remaining <= 0.0:
		hide_now()
		return
	_apply_fade()


func _apply_fade() -> void:
	## Vertex colours carry the hue; the material's own alpha carries the fade,
	## so one write dims the whole envelope without rebuilding the mesh.
	_material.albedo_color = Color(1.0, 1.0, 1.0, clampf(_remaining / LIFETIME, 0.0, 1.0))


func is_showing() -> bool:
	return _mesh_instance != null and _mesh_instance.visible


func describe() -> String:
	if draws == 0:
		return "no swing drawn yet"
	return "%.2f m / %.0f deg%s, %d swing(s) drawn" % [
		last_reach, last_arc_degrees,
		(" against a %.2f m / %.0f deg baseline" % [last_baseline_reach, last_baseline_arc_degrees]
			if last_differs_from_baseline else " (baseline)"),
		draws,
	]
