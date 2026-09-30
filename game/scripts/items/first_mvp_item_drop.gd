class_name FirstMvpItemDrop
extends Area3D
## First-MVP — Gate 1D: the one guaranteed ground drop in Broken Watch (D-217).
##
## The same proven Gate E shape (`PrototypeSwordDrop`), reused as a PATTERN in
## a fresh, Gate-1D-owned file rather than by editing or subclassing that
## Prototype-Zero-owned scaffolding: a visible weapon representation (the
## already-registered `sword_1handed.gltf`, the same model the player already
## carries — no new asset), a copper ground ring and soft shaft in the room's
## quiet-indicator language, an interaction range read from its own
## `CollisionShape3D` so the number in the scene and the number the code obeys
## cannot drift, and a soft-selection flag for the controller.
##
## ON NO PHYSICS LAYER. Exactly as the Gate E drop: `collision_layer = 0`,
## `monitoring = false`, so Quick Strike's cursor pick, soft-target cone, and
## release query can never see it, it can never block movement, and it can
## never enter the navigation bake. Proximity is measured manually.
##
## Mouse clicks the screen-projected nameplate from any distance (a cursor
## already is a reach); the controller's `interact` action only fires from
## inside `interaction_range`. Both funnel through the same
## `BrokenWatchSlice.open_item_comparison()` entry point.

const SWORD_MODEL: String = "res://assets/third_party/kaykit/adventurer/sword_1handed.gltf"

const RING_INNER: float = 0.74
const RING_OUTER: float = 0.86
const COPPER: Color = Color(0.85, 0.58, 0.30, 0.85)
const COPPER_BRIGHT: Color = Color(1.00, 0.82, 0.52, 0.95)
const SHAFT_COLOUR: Color = Color(0.92, 0.68, 0.38, 0.15)

@export var weapon: PrototypeWeaponData
@export var interaction_range: float = 2.20
@export var hover_height: float = 0.78
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
	_sword.name = "WeaponModel"
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
	column.top_radius = RING_INNER * 0.30
	column.bottom_radius = RING_INNER * 0.78
	column.height = 2.20
	column.radial_segments = 10
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

func label_anchor() -> Vector3:
	return global_position + Vector3(0.0, 2.15, 0.0)


func display_name() -> String:
	return weapon.display_name if weapon != null else "Ground item"


func planar_distance_to(point: Vector3) -> float:
	return Vector2(point.x - global_position.x, point.z - global_position.z).length()


func player_is_in_range(player_position: Vector3) -> bool:
	return planar_distance_to(player_position) <= interaction_range


func set_soft_targeted(value: bool) -> void:
	soft_selected = value


func measured_interaction_range() -> float:
	var shape: CollisionShape3D = get_node_or_null("InteractionRange") as CollisionShape3D
	if shape == null:
		return -1.0
	var cylinder: CylinderShape3D = shape.shape as CylinderShape3D
	return cylinder.radius if cylinder != null else -1.0
