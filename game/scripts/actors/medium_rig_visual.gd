class_name MediumRigVisual
extends Node3D
## Shared visual rig for the two registered KayKit medium-rig characters.
##
## Owns only presentation: clip playback and the weapon socket. It holds no
## combat, movement, or progression state — later Prototype Zero gates place
## this rig underneath a CharacterBody3D that owns those.
##
## The socket bone is `handslot.r`, measured from the imported skeletons rather
## than assumed; see assets/third_party/kaykit/SOURCE_AND_LICENSE.md.

const IDLE: StringName = &"Idle_A"
const RUN: StringName = &"Running_A"
const HIT: StringName = &"Hit_A"
const DEATH: StringName = &"Death_A"

@export var skeleton_path: NodePath
@export var weapon_socket_bone: StringName = &"handslot.r"

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var weapon_socket: BoneAttachment3D = $WeaponSocket

var _skeleton: Skeleton3D
## Gate F (specification §18: "brief enemy material flash"). One material
## OVERLAY, created lazily and owned by THIS rig instance.
##
## The obvious implementation — tinting the mesh's own albedo — would be wrong
## here: the KayKit characters share their imported materials between every
## instance, so flashing one Graveblade would flash all three. A per-instance
## `material_overlay` cannot do that, because `material_overlay` is a property of
## the MeshInstance3D rather than of the shared material.
var _flash_material: StandardMaterial3D = null
var _flash_meshes: Array[MeshInstance3D] = []
var _flash_amount: float = 0.0


func _ready() -> void:
	_skeleton = get_node_or_null(skeleton_path) as Skeleton3D
	assert(_skeleton != null, "MediumRigVisual: skeleton_path does not resolve to a Skeleton3D.")

	# Resolve the socket by name so a differing joint order between the two
	# imported rigs can never bind the weapon to the wrong bone.
	var socket_index: int = _skeleton.find_bone(weapon_socket_bone)
	assert(socket_index != -1, "MediumRigVisual: socket bone '%s' is absent from the rig." % weapon_socket_bone)
	weapon_socket.bone_idx = socket_index

	play(IDLE)


## Plays a clip from the shared medium-rig library.
## `speed_scale` exists so later gates can drive action time from data rather
## than from the imported clip length.
func play(clip: StringName, speed_scale: float = 1.0, blend: float = 0.15) -> void:
	assert(animation_player.has_animation(clip), "MediumRigVisual: unknown clip '%s'." % clip)
	animation_player.play(clip, blend, speed_scale)


## Sets the impact flash, 0.0 to 1.0. The caller owns the decay and the player's
## bright-flash setting has already been applied to `amount`, so Off is exactly
## zero here rather than dim.
func set_impact_flash(amount: float, tint: Color = Color(1.0, 0.90, 0.70)) -> void:
	var clamped: float = clampf(amount, 0.0, 1.0)
	if is_equal_approx(clamped, _flash_amount) and _flash_material != null:
		return
	_flash_amount = clamped
	if _flash_material == null:
		if clamped <= 0.0:
			return
		_build_flash_material()
	_flash_material.albedo_color = Color(tint.r, tint.g, tint.b, clamped)
	for mesh: MeshInstance3D in _flash_meshes:
		if is_instance_valid(mesh):
			mesh.material_overlay = _flash_material if clamped > 0.0 else null


func impact_flash() -> float:
	return _flash_amount


func _build_flash_material() -> void:
	_flash_material = StandardMaterial3D.new()
	_flash_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	_flash_material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	_flash_material.blend_mode = BaseMaterial3D.BLEND_MODE_ADD
	_flash_material.cull_mode = BaseMaterial3D.CULL_BACK
	_flash_material.no_depth_test = false
	_flash_meshes.clear()
	_collect_meshes(self)


func _collect_meshes(node: Node) -> void:
	for child: Node in node.get_children():
		var mesh: MeshInstance3D = child as MeshInstance3D
		if mesh != null:
			_flash_meshes.append(mesh)
		_collect_meshes(child)


func socket_bone_index() -> int:
	return weapon_socket.bone_idx


func skeleton() -> Skeleton3D:
	return _skeleton
