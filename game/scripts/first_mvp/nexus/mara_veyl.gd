class_name MaraVeyl
extends Node3D
## First-MVP — Gate 1E: Mara Veyl, the Last Surveyor (D-219).
##
## `design/NARRATIVE_WORLD_AND_FIRST_REGION.md` §20 is the whole brief for who
## she is: "Mara maintains what remains of the Nexus's physical Anchor
## instruments and maps which routes can still support living passage." She is
## practical, observant, "cautious with claims she cannot prove", "accustomed to
## recording contradictions without pretending to understand all of them",
## "unable to survive deep Rift exposure herself", and interested in the
## Riftmarked "as a person and an unprecedented phenomenon, not merely a
## weapon". She is NOT omniscient, not a prophecy dispenser, not a merchant, not
## a faction leader, and not required to operate every menu.
##
## HER PRESENTATION IS A DELIBERATE PLACEHOLDER, AND THE CANON AUTHORIZES IT.
## §20: "She can reuse the established humanoid production family. Text-first
## dialogue and a small reusable pose and gesture set are sufficient. Full voice
## acting is not required."
##
## The project's entire extracted humanoid inventory is TWO bodies: the KayKit
## Knight and the KayKit Skeleton Warrior. The Skeleton Warrior is the enemy the
## player has just been killed by, so Mara is built on the Knight rig — the same
## body the player wears. Three things separate her from the player, and each
## was chosen because it works with what exists rather than because it is right:
##
##   1. NO WEAPON. `knight_rig.tscn` instances `StarterSword` into the
##      `handslot.r` socket; this hides it. A person who is not fighting is not
##      holding a sword, and the empty hand is the single clearest read.
##   2. A DISTINCT MATERIAL OVERLAY. The KayKit characters SHARE their imported
##      materials between every instance, so tinting the mesh albedo would tint
##      the player too. `MeshInstance3D.material_overlay` is per-instance —
##      exactly the mechanism `MediumRigVisual` already uses for its Gate F
##      impact flash, reused here for a steady, cool surveyor's tint.
##   3. SHE IS STILL. She plays `Idle_A` and never moves, so she reads as a
##      person at a station rather than as another adventurer.
##
## NO ASSET WAS DOWNLOADED OR EXTRACTED FOR HER, and the third-party inventory
## is unchanged. The brief: "Do not download or extract a special NPC asset ...
## use the cleanest reusable placeholder from the existing family rather than
## starting an asset search." A real distinct body for Mara is an art decision
## with its own authorization, and the Gate 1E report says so plainly.
##
## NO FACIAL ANIMATION, NO CINEMATIC, NO VOICE, NO DIALOGUE WHEEL. Every one is
## named in the brief's exclusion list.
##
## She owns her own presence and her own nameplate reach, and NOTHING else. The
## conversation is `FirstMvpDialogue`; the panel is `NexusDialoguePanel`; the
## rewards are `CharacterState`'s. Mara is a person standing in a room.

const KNIGHT_RIG_SCENE: String = "res://scenes/actors/knight_rig.tscn"

## How close the character must be for the interaction prompt to offer her.
const INTERACTION_RANGE: float = 3.20

const DISPLAY_NAME: String = "Mara Veyl"
const TITLE: String = "the Last Surveyor"

## A cool, desaturated overlay: field leathers and dust rather than the player's
## polished plate. Applied per-instance so the player's own body is untouched.
const SURVEYOR_TINT: Color = Color(0.34, 0.40, 0.46, 0.42)

var rig: MediumRigVisual
var _overlay: StandardMaterial3D
var _meshes: Array[MeshInstance3D] = []
var _log: Callable = Callable()


func _ready() -> void:
	_build()


func configure(log_sink: Callable) -> void:
	_log = log_sink


func _build() -> void:
	rig = (load(KNIGHT_RIG_SCENE) as PackedScene).instantiate() as MediumRigVisual
	rig.name = "MaraRig"
	add_child(rig)

	# She carries nothing. `knight_rig.tscn` puts `StarterSword` in the socket;
	# hiding it rather than freeing it leaves that scene untouched and reversible.
	var socket: Node = rig.get_node_or_null("WeaponSocket")
	if socket != null:
		var sword: Node3D = socket.get_node_or_null("StarterSword") as Node3D
		if sword != null:
			sword.visible = false

	_apply_surveyor_tint()
	rig.play(MediumRigVisual.IDLE)
	if _log.is_valid():
		_log.call("mara veyl", "the Last Surveyor is present; placeholder presentation on the Knight rig")


## Per-instance overlay, NOT an albedo change. The KayKit bodies share imported
## materials between every instance, so writing albedo here would recolour the
## player as well. `material_overlay` is a property of the MeshInstance3D rather
## than of the material, which is why it can be per-instance at all — the same
## reason `MediumRigVisual` uses it for its impact flash.
func _apply_surveyor_tint() -> void:
	_overlay = StandardMaterial3D.new()
	_overlay.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	_overlay.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	_overlay.blend_mode = BaseMaterial3D.BLEND_MODE_MIX
	_overlay.cull_mode = BaseMaterial3D.CULL_BACK
	_overlay.albedo_color = SURVEYOR_TINT
	_meshes.clear()
	_collect_meshes(rig)
	for mesh: MeshInstance3D in _meshes:
		mesh.material_overlay = _overlay


func _collect_meshes(node: Node) -> void:
	for child: Node in node.get_children():
		var mesh: MeshInstance3D = child as MeshInstance3D
		if mesh != null and mesh.visible:
			_meshes.append(mesh)
		_collect_meshes(child)


func face_towards(point: Vector3) -> void:
	var span: Vector3 = Vector3(point.x - global_position.x, 0.0, point.z - global_position.z)
	if span.length() < 0.0001:
		return
	# The KayKit medium rig faces +Z at identity, not Godot's -Z convention
	# (Gate B measured this; see kaykit/SOURCE_AND_LICENSE.md §3.6).
	rotation = Vector3(0.0, atan2(span.x, span.z), 0.0)


func planar_distance_to(point: Vector3) -> float:
	return Vector2(point.x - global_position.x, point.z - global_position.z).length()


func player_is_in_range(player_position: Vector3) -> bool:
	return planar_distance_to(player_position) <= INTERACTION_RANGE


func label_anchor() -> Vector3:
	return global_position + Vector3(0.0, 2.10, 0.0)


func full_name() -> String:
	return "%s, %s" % [DISPLAY_NAME, TITLE]


## Proves the placeholder presentation is actually applied, for the checks: she
## must carry an overlay on every visible mesh and no visible weapon.
func presentation() -> Dictionary:
	var socket: Node = rig.get_node_or_null("WeaponSocket") if rig != null else null
	var sword: Node3D = socket.get_node_or_null("StarterSword") as Node3D if socket != null else null
	var overlaid: int = 0
	for mesh: MeshInstance3D in _meshes:
		if is_instance_valid(mesh) and mesh.material_overlay == _overlay:
			overlaid += 1
	return {
		"meshes": _meshes.size(),
		"overlaid": overlaid,
		"weapon_visible": sword != null and sword.visible,
		"has_weapon_node": sword != null,
		"clip": rig.animation_player.current_animation if rig != null else "",
	}
