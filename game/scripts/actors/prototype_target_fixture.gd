class_name PrototypeTargetFixture
extends PrototypeTargetable
## Prototype Zero — Gate C inert target fixture ("practice post").
##
## THIS IS NOT A GRAVEBLADE. It has no AI, no attack, no Life, no death, no XP,
## and no loot, and it never damages the player. It exists so Gate C can prove
## target acquisition, automatic approach, the release arc, obstruction, and
## controller priority without building any part of Gate D.
##
## Gate D added a real enemy and the small `PrototypeTargetable` protocol the two
## share, and this stayed inert: it still overrides `combat_actor()` to return
## null, which is exactly what stops a release onto a post producing a
## DamageEvent. The Gate C scope check still asserts by name that this class has
## no Life, damage, death, XP, or loot member.
##
## It is deliberately a wooden-and-iron post rather than a body, so nothing here
## can be mistaken for the enemy Gate D owns. It is built from primitives, so it
## adds no third-party asset and needs no Asset Register entry.
##
## It sits on the "target" physics layer only. It does NOT collide with the
## player and it is NOT baked into the navigation mesh, so adding these fixtures
## cannot change any Gate B locomotion result.

const STONE: Color = Color(0.30, 0.31, 0.34)
const IRON: Color = Color(0.38, 0.40, 0.45)
const COPPER: Color = Color(0.72, 0.46, 0.24)
const COPPER_STRUCK: Color = Color(1.00, 0.86, 0.55)

## Kept as its own field rather than folded into `target_display_name()`, because
## the Gate C checks and evidence address posts by this name.
@export var fixture_name: String = "Practice Post"
## Where a strike is aimed and measured from. Roughly a Graveblade's chest.
@export var targeting_height: float = 1.10
## Matches the player capsule, so acquisition distances mean the same thing for
## a post as they will for a body.
@export var body_radius: float = 0.40
@export var body_height: float = 1.80

@export_group("Debug behaviour")
## Off by default. Exists ONLY to exercise the specification §11.1 rule that
## approach re-evaluates range instead of walking to a stale position. It is a
## scripted sway on a prop, not enemy movement.
@export var drift_enabled: bool = false
@export var drift_amplitude: float = 1.6
@export var drift_period: float = 4.0

var active: bool = true
var release_hits: int = 0
var last_hit_use_id: int = 0

var _home: Vector3 = Vector3.ZERO
var _drift_phase: float = 0.0
var _band: MeshInstance3D
var _band_material: StandardMaterial3D
var _selection: MeshInstance3D
var _selection_material: StandardMaterial3D
var _flash: float = 0.0
var _visuals: Node3D

signal struck(fixture: PrototypeTargetFixture, use_id: int)


func _ready() -> void:
	collision_layer = TARGET_LAYER
	collision_mask = 0
	monitorable = true
	monitoring = false
	_home = position
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

	_visuals = Node3D.new()
	_visuals.name = "Visuals"
	add_child(_visuals)

	_add_cylinder("Base", 0.44, 0.18, 0.09, STONE)
	_add_cylinder("Post", 0.13, 1.62, 0.99, IRON)
	_band = _add_cylinder("Band", 0.21, 0.26, targeting_height, COPPER)
	_band_material = _band.material_override as StandardMaterial3D
	_add_cylinder("Cap", 0.19, 0.10, 1.85, STONE)

	# Quiet ground ring, shown only while this post is the current soft target
	# (specification §11.2: "A quiet indicator identifies the current soft
	# target ... without becoming a permanent hard-lock presentation").
	_selection = MeshInstance3D.new()
	_selection.name = "SoftTargetRing"
	var torus: TorusMesh = TorusMesh.new()
	torus.inner_radius = 0.52
	torus.outer_radius = 0.60
	torus.rings = 20
	_selection.mesh = torus
	_selection_material = StandardMaterial3D.new()
	_selection_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	_selection_material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	_selection_material.albedo_color = Color(0.62, 0.78, 0.92, 0.75)
	_selection.material_override = _selection_material
	_selection.position = Vector3(0.0, 0.035, 0.0)
	_selection.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	_selection.visible = false
	_visuals.add_child(_selection)


func _add_cylinder(node_name: String, radius: float, height: float, at_y: float, colour: Color) -> MeshInstance3D:
	var instance: MeshInstance3D = MeshInstance3D.new()
	instance.name = node_name
	var mesh: CylinderMesh = CylinderMesh.new()
	mesh.top_radius = radius
	mesh.bottom_radius = radius
	mesh.height = height
	mesh.radial_segments = 8  ## faceted, to sit beside the low-poly kit
	mesh.rings = 1
	instance.mesh = mesh
	var material: StandardMaterial3D = StandardMaterial3D.new()
	material.albedo_color = colour
	material.roughness = 0.85
	material.specular_mode = BaseMaterial3D.SPECULAR_DISABLED
	instance.material_override = material
	instance.position = Vector3(0.0, at_y, 0.0)
	_visuals.add_child(instance)
	return instance


func _process(delta: float) -> void:
	if _flash > 0.0:
		_flash = maxf(_flash - delta * 4.0, 0.0)
		_band_material.albedo_color = COPPER.lerp(COPPER_STRUCK, _flash)
	if drift_enabled and active:
		_drift_phase += delta
		position = _home + Vector3(sin(_drift_phase * TAU / maxf(drift_period, 0.1)) * drift_amplitude, 0.0, 0.0)
	elif not is_equal_approx(position.x, _home.x) or not is_equal_approx(position.z, _home.z):
		position = position.move_toward(_home, delta * 3.0)


# --- Targeting contract ------------------------------------------------------

## Gate C's stand-in for "living". A fixture that has been switched off is an
## invalid target, which is how the "target became invalid" rule is exercised
## without giving a fixture Life or death.
func is_valid_target() -> bool:
	return active


func targeting_point() -> Vector3:
	return global_position + Vector3(0.0, targeting_height, 0.0)


func target_display_name() -> String:
	return fixture_name


func set_active(value: bool) -> void:
	active = value
	visible = value
	set_soft_targeted(false)


func set_soft_targeted(value: bool) -> void:
	if _selection != null:
		_selection.visible = value and active


## Recorded, not damaged. A practice post has no damage pipeline: the release
## query reports the fixture it resolved onto and the fixture acknowledges it.
## The Graveblade's equivalent forwards to an actor that loses Life; this does
## not, and that difference is the whole of `combat_actor()` returning null.
func note_release(use_id: int) -> void:
	release_hits += 1
	last_hit_use_id = use_id
	_flash = 1.0
	struck.emit(self, use_id)


## Moves the post AND its rest position. Setting `position` alone is temporary:
## `_process` walks an off-home post back, which is what returns it after debug
## drift is switched off.
func place_at(at: Vector3) -> void:
	position = at
	_home = at
	_drift_phase = 0.0


func reset() -> void:
	release_hits = 0
	last_hit_use_id = 0
	_flash = 0.0
	drift_enabled = false
	_drift_phase = 0.0
	position = _home
	set_active(true)
	if _band_material != null:
		_band_material.albedo_color = COPPER


func home_position() -> Vector3:
	return _home
