class_name HuntressPoseModifier
extends SkeletonModifier3D

## APPLIES THE PLACEHOLDER POSE AFTER THE ACCEPTED ANIMATION PLAYER (D-392).
##
## Godot processes a `SkeletonModifier3D` after the AnimationMixer has written its
## clip, every frame -- measured in the D-392 lab probe: the player's physics
## step, then the mixer, then later nodes, then the modifiers, then
## `skeleton_updated`. So the accepted AnimationPlayer keeps running untouched
## underneath, and this writes the pose `HuntressBowAnimator` computed on top.
## `influence` 1.0 shows the placeholder fully; the accepted player's pose is what
## an influence of 0.0 would show.
##
## PRESENTATION ONLY. Nothing in gameplay reads a bone: the actor's position is its
## ground point, and visual height is never a coordinate.

var pose: BonePose = null
var applications: int = 0

func _process_modification_with_delta(_delta: float) -> void:
	var sk := get_skeleton()
	if sk == null or pose == null or pose.size() != sk.get_bone_count():
		return
	applications += 1
	BowRetargeter.apply(sk, pose)
