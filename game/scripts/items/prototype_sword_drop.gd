class_name PrototypeSwordDrop
extends Area3D
## Prototype Zero — Gate E: the one guaranteed ground drop (specification §7.5,
## §13, §16.1, decision D-184).
##
## An `Area3D`, as §7.5 names, carrying:
##
##   a visible sword representation   the REGISTERED `sword_1handed.gltf`, the
##                                    same model the player already carries
##   a readable ground nameplate      a 2D control the lab overlay places over
##                                    this drop; see `gate_e_lab_overlay.gd`
##   a subtle loot indicator          a copper ground ring and a soft vertical
##                                    shaft, in the room's existing quiet-ring
##                                    language
##   an interaction range             the CollisionShape3D below, so the range is
##                                    authored geometry rather than a literal
##   a soft-selection state           `set_soft_targeted()`, the same word the
##                                    practice posts and the Graveblade use
##   the pre-authored upgrade record  `weapon`
##
## NO ASSET WAS ADDED. D-184: "Use the existing registered player-sword model or
## another already registered/reused prototype representation with a visibly
## stronger but related ground indicator and nameplate; do not invent or download
## an asset." The sword is `assets/third_party/kaykit/adventurer/sword_1handed.gltf`,
## already extracted under Gate A. The ring and shaft are primitives built here,
## so they need no Asset Register entry either.
##
## "STRONGER BUT RELATED" is measured against the room's existing indicator
## language rather than invented: the destination marker and the two soft-target
## rings are quiet flat rings about 0.60 m across. This drop uses the same ring,
## 1.4 times wider and in copper rather than slate-blue, and adds one thing they
## do not have — a soft vertical shaft — so it reads as more important without
## becoming a different visual family. It is deliberately NOT a rarity beam:
## there is no Normal / Magic / Rare / Wrought / Unique framing anywhere in
## Prototype Zero (specification §13).
##
## THIS IS NOT AN INVENTORY ITEM ENTITY. It has no stack, no slot, no position in
## a Field Pack, no rarity frame, no affix list, and no serialization. It is on NO
## physics layer at all, so Quick Strike can never target it, it can never block
## movement, and it can never enter the navigation bake.

## The Gate A registered player sword, reused rather than replaced.
const SWORD_MODEL: String = "res://assets/third_party/kaykit/adventurer/sword_1handed.gltf"

## The room's quiet indicator language, from `destination_marker.gd` and the two
## soft-target rings, kept so this reads as the same family.
const RING_INNER: float = 0.74
const RING_OUTER: float = 0.86
const COPPER: Color = Color(0.85, 0.58, 0.30, 0.85)
const COPPER_BRIGHT: Color = Color(1.00, 0.82, 0.52, 0.95)
const SHAFT_COLOUR: Color = Color(0.92, 0.68, 0.38, 0.15)

@export var weapon: PrototypeWeaponData
## Specification §7.5 "interaction range". Read from the CollisionShape3D so the
## number in the scene and the number the code obeys cannot drift apart.
@export var interaction_range: float = 2.20
## Slow bob and turn, so the drop reads as an object waiting to be taken rather
## than a prop that happens to be lying there.
@export var hover_height: float = 0.78
## The sword is a hand prop at its authored size and reads as a sliver on the
## floor from 19 m at 55 degrees. Enlarging the PRESENTATION of an already
## registered model is the placeholder rule working as intended (§26); it adds no
## asset and changes no gameplay value.
@export var model_scale: float = 1.45
@export var hover_amplitude: float = 0.09
@export var hover_period: float = 3.2
@export var spin_degrees_per_second: float = 34.0

var soft_selected: bool = false

var _visual: Node3D
var _sword: Node3D
var _ring: MeshInstance3D
var _ring_material: StandardMaterial3D
var _shaft: MeshInstance3D
var _phase: float = 0.0


func _ready() -> void:
	# On no physics layer and monitoring nothing: proximity is measured in
	# `player_is_in_range()` instead, so this can never be acquired by the
	# soft-target cone, resolved onto by a release query, or walked into.
	collision_layer = 0
	collision_mask = 0
	monitoring = false
	monitorable = false
	_build()


func _build() -> void:
	var shape: CollisionShape3D = CollisionShape3D.new()
	shape.name = "InteractionRange"
	var cylinder: CylinderShape3D = CylinderShape3D.new()
	cylinder.radius = interaction_range
	cylinder.height = 2.20
	shape.shape = cylinder
	shape.position = Vector3(0.0, 1.10, 0.0)
	add_child(shape)

	_visual = Node3D.new()
	_visual.name = "Visual"
	add_child(_visual)

	_sword = (load(SWORD_MODEL) as PackedScene).instantiate() as Node3D
	_sword.name = "HonedSwordModel"
	# Laid tip-forward and tilted, so the silhouette reads as a sword from the
	# fixed 55-degree camera rather than as a vertical sliver.
	_sword.rotation_degrees = Vector3(0.0, 0.0, 62.0)
	_sword.scale = Vector3.ONE * model_scale
	_sword.position = Vector3(0.0, hover_height, 0.0)
	_visual.add_child(_sword)

	_ring = MeshInstance3D.new()
	_ring.name = "GroundRing"
	var torus: TorusMesh = TorusMesh.new()
	torus.inner_radius = RING_INNER
	torus.outer_radius = RING_OUTER
	torus.rings = 24
	_ring.mesh = torus
	_ring_material = StandardMaterial3D.new()
	_ring_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	_ring_material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	_ring_material.albedo_color = COPPER
	_ring.material_override = _ring_material
	_ring.position = Vector3(0.0, 0.04, 0.0)
	_ring.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	_visual.add_child(_ring)

	_shaft = MeshInstance3D.new()
	_shaft.name = "Shaft"
	var column: CylinderMesh = CylinderMesh.new()
	# Tapered and faint: a soft column, not a rarity beam. Prototype Zero has no
	# Normal / Magic / Rare / Wrought / Unique framing to signal.
	column.top_radius = RING_INNER * 0.30
	column.bottom_radius = RING_INNER * 0.78
	column.height = 2.20
	column.radial_segments = 10  ## faceted, to sit beside the low-poly kit
	column.rings = 1
	_shaft.mesh = column
	var shaft_material: StandardMaterial3D = StandardMaterial3D.new()
	shaft_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	shaft_material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	shaft_material.albedo_color = SHAFT_COLOUR
	shaft_material.cull_mode = BaseMaterial3D.CULL_DISABLED
	_shaft.material_override = shaft_material
	_shaft.position = Vector3(0.0, 1.10, 0.0)
	_shaft.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	_visual.add_child(_shaft)


func _process(delta: float) -> void:
	_phase += delta
	if _sword != null:
		_sword.position.y = hover_height + sin(_phase * TAU / maxf(hover_period, 0.1)) * hover_amplitude
		_sword.rotation_degrees.y = fmod(_sword.rotation_degrees.y + spin_degrees_per_second * delta, 360.0)
	if _ring_material != null:
		var pulse: float = 0.5 + 0.5 * sin(_phase * TAU / maxf(hover_period, 0.1))
		var base: Color = COPPER_BRIGHT if soft_selected else COPPER
		_ring_material.albedo_color = base.lerp(COPPER_BRIGHT, pulse * (0.35 if soft_selected else 0.18))


# --- Interaction -------------------------------------------------------------

## Where the nameplate is anchored and where the interaction distance is measured
## from. Roughly the height the sword floats at, so the label sits beside it.
## Above the sword AND above a 1.80 m body standing beside it, so the nameplate
## is never read through the character.
func label_anchor() -> Vector3:
	return global_position + Vector3(0.0, 2.15, 0.0)


func display_name() -> String:
	return weapon.display_name if weapon != null else "Prototype Honed Sword"


func planar_distance_to(point: Vector3) -> float:
	return Vector2(point.x - global_position.x, point.z - global_position.z).length()


## Specification §7.5 "interaction range". The controller opens the comparison
## only from inside it; the cursor may click the nameplate from anywhere, because
## a cursor already IS a reach.
func player_is_in_range(player_position: Vector3) -> bool:
	return planar_distance_to(player_position) <= interaction_range


## The same word the practice posts and the Graveblade use for the quiet
## controller indicator (specification §11.2), so one vocabulary covers every
## selectable thing in the room.
func set_soft_targeted(value: bool) -> void:
	soft_selected = value


## Measured interaction geometry, for the debug surface and the Gate E checks.
## The checks read the SHAPE, so an edit to the scene cannot silently disagree
## with the range the code obeys.
func measured_interaction_range() -> float:
	var shape: CollisionShape3D = get_node_or_null("InteractionRange") as CollisionShape3D
	if shape == null:
		return -1.0
	var cylinder: CylinderShape3D = shape.shape as CylinderShape3D
	return cylinder.radius if cylinder != null else -1.0
