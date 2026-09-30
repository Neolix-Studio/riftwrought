class_name AnimationBoneSampler
extends RefCounted
## Composes a skeleton's bone poses directly from an `Animation`'s own tracks.
##
## Prototype Zero needs the Quick Strike release marker to be MEASURED from the
## clip rather than guessed, and the measurement must not depend on a running
## scene, a frame rate, or blend state. This walks the bone hierarchy, overriding
## each bone's rest with the animation's interpolated position / rotation / scale
## tracks where they exist.
##
## Tooling only. Nothing in the player-facing loop uses it.

var _skeleton: Skeleton3D
var _animation: Animation
var _position: Dictionary = {}
var _rotation: Dictionary = {}
var _scale: Dictionary = {}


func _init(skeleton: Skeleton3D, animation: Animation) -> void:
	_skeleton = skeleton
	_animation = animation
	for track: int in animation.get_track_count():
		var bone: int = skeleton.find_bone(animation.track_get_path(track).get_concatenated_subnames())
		if bone == -1:
			continue
		match animation.track_get_type(track):
			Animation.TYPE_POSITION_3D:
				_position[bone] = track
			Animation.TYPE_ROTATION_3D:
				_rotation[bone] = track
			Animation.TYPE_SCALE_3D:
				_scale[bone] = track


func bone_local_pose(bone: int, time: float) -> Transform3D:
	var rest: Transform3D = _skeleton.get_bone_rest(bone)
	var origin: Vector3 = rest.origin
	var rotation: Quaternion = rest.basis.get_rotation_quaternion()
	var scale: Vector3 = rest.basis.get_scale()
	if _position.has(bone):
		origin = _animation.position_track_interpolate(_position[bone], time)
	if _rotation.has(bone):
		rotation = _animation.rotation_track_interpolate(_rotation[bone], time)
	if _scale.has(bone):
		scale = _animation.scale_track_interpolate(_scale[bone], time)
	return Transform3D(Basis(rotation).scaled(scale), origin)


## Pose of `bone` in the skeleton's own space at `time`.
func bone_global_pose(bone: int, time: float) -> Transform3D:
	var pose: Transform3D = bone_local_pose(bone, time)
	var parent: int = _skeleton.get_bone_parent(bone)
	while parent != -1:
		pose = bone_local_pose(parent, time) * pose
		parent = _skeleton.get_bone_parent(parent)
	return pose


func animated_bone_count() -> int:
	var seen: Dictionary = {}
	for bone: int in _position:
		seen[bone] = true
	for bone: int in _rotation:
		seen[bone] = true
	for bone: int in _scale:
		seen[bone] = true
	return seen.size()
