class_name GravebladeTargetArea
extends PrototypeTargetable
## Prototype Zero — Gate D: the Graveblade's targetable surface.
##
## The Graveblade is a `CharacterBody3D` on the "enemy" physics layer, because it
## has to block the player and be blocked by the world. Quick Strike's cursor
## pick, soft-target cone, and release query all read the "target" layer instead,
## so the enemy carries this small Area3D for them — exactly as the inert
## practice posts ARE such an area.
##
## It answers the shared `PrototypeTargetable` protocol by asking the Graveblade,
## and the one line that matters is `combat_actor()` returning that body rather
## than null: that is what makes a release onto a Graveblade produce a DamageEvent
## and a release onto a practice post produce none.

const RING_COLOUR: Color = Color(0.92, 0.62, 0.55, 0.80)

## Chest height on the medium rig, matching the practice posts, so acquisition
## distances mean the same thing for a body as for a post.
@export var targeting_height: float = 1.10
@export var body_radius: float = 0.40
@export var body_height: float = 1.80

var _graveblade: PrototypeGraveblade
var _ring: MeshInstance3D


func _ready() -> void:
	collision_layer = TARGET_LAYER
	collision_mask = 0
	monitorable = true
	monitoring = false
	_graveblade = get_parent() as PrototypeGraveblade
	assert(_graveblade != null, "GravebladeTargetArea: must be a child of a PrototypeGraveblade.")
	_build()


func _build() -> void:
	var shape: CollisionShape3D = CollisionShape3D.new()
	shape.name = "TargetShape"
	var capsule: CapsuleShape3D = CapsuleShape3D.new()
	capsule.radius = body_radius
	capsule.height = body_height
	shape.shape = capsule
	shape.position = Vector3(0.0, body_height * 0.5, 0.0)
	add_child(shape)

	# The same quiet ground ring the practice posts use, in a warmer colour so a
	# living target reads differently from a training prop without becoming a
	# permanent hard-lock presentation (specification §11.2).
	_ring = MeshInstance3D.new()
	_ring.name = "SoftTargetRing"
	var torus: TorusMesh = TorusMesh.new()
	torus.inner_radius = 0.52
	torus.outer_radius = 0.60
	torus.rings = 20
	_ring.mesh = torus
	var material: StandardMaterial3D = StandardMaterial3D.new()
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	material.albedo_color = RING_COLOUR
	_ring.material_override = material
	_ring.position = Vector3(0.0, 0.035, 0.0)
	_ring.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	_ring.visible = false
	add_child(_ring)


# --- The shared targeting protocol -------------------------------------------

## A dead Graveblade is not a valid target: acquisition, the soft-target cone,
## and the release query all refuse it from the frame it dies.
func is_valid_target() -> bool:
	return _graveblade != null and _graveblade.is_alive()


func targeting_point() -> Vector3:
	return global_position + Vector3(0.0, targeting_height, 0.0)


func target_display_name() -> String:
	return _graveblade.data.display_name if _graveblade != null and _graveblade.data != null else "Graveblade"


func set_soft_targeted(value: bool) -> void:
	if _ring != null:
		_ring.visible = value and is_valid_target()


## Presentation is the Graveblade's own business — it flashes when it takes
## damage, not when a query happens to resolve onto it — so this records nothing.
## The damage itself travels through `combat_actor()`.
func note_release(_use_id: int) -> void:
	pass


## The whole difference between this and an inert practice post.
func combat_actor() -> Node:
	return _graveblade
