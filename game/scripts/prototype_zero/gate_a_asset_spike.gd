extends Node3D
## Prototype Zero — Gate A asset and rig spike.
##
## Proves the registered KayKit import before any gameplay system exists:
## coherent Knight / Graveblade scale against the dungeon kit, the selected
## medium-rig clips playing on both bodies, and both handslot.r weapon
## attachments following the animated bone.
##
## Gate B replaces this scene with the real calibration room. It deliberately
## contains no navigation, collision, input mapping, combat, or progression.
##
## Interactive:  godot --path game
##   Space / Enter  advance to the next clip
##
## Automated:    godot --path game -- --verify [--shots <dir>] [--hold <sec>]
##   Runs the Gate A assertions, optionally writes screenshots, then exits
##   with 0 on pass and 1 on failure.

const CLIP_SEQUENCE: Array[StringName] = [
	&"Idle_A",
	&"Running_A",
	&"Melee_1H_Attack_Slice_Horizontal",
	&"Melee_1H_Attack_Chop",
	&"Hit_A",
	&"Death_A",
	&"PickUp",
]

const SOCKET_BONE: StringName = &"handslot.r"
const ATTACHMENT_TOLERANCE_M: float = 0.001
const IN_PLACE_TOLERANCE_M: float = 0.001

@onready var _knight: MediumRigVisual = $Actors/KnightRig
@onready var _graveblade: MediumRigVisual = $Actors/GravebladeRig
@onready var _label: Label = $CanvasLayer/ClipLabel
@onready var _camera: Camera3D = $Camera3D

var _clip_index: int = 0
var _failures: PackedStringArray = PackedStringArray()
var _shot_dir: String = ""


func _ready() -> void:
	_show_clip(0)
	var arguments: PackedStringArray = OS.get_cmdline_user_args()
	if arguments.has("--verify"):
		_shot_dir = _argument_value(arguments, "--shots")
		# Deliberately not awaited: verification drives itself across frames and
		# quits the tree when it finishes.
		_run_verification(arguments)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"ui_accept"):
		_show_clip(_clip_index + 1)


func _show_clip(index: int, blend: float = 0.15) -> void:
	_clip_index = posmod(index, CLIP_SEQUENCE.size())
	var clip: StringName = CLIP_SEQUENCE[_clip_index]
	_knight.play(clip, 1.0, blend)
	_graveblade.play(clip, 1.0, blend)
	_label.text = "Gate A asset spike — clip %d/%d: %s\nSpace / Enter for the next clip." % [
		_clip_index + 1, CLIP_SEQUENCE.size(), clip,
	]


# --- Gate A verification -----------------------------------------------------

func _run_verification(arguments: PackedStringArray) -> void:
	print("=== Gate A rig verification ===")
	var hold_text: String = _argument_value(arguments, "--hold")
	var hold_seconds: float = float(hold_text) if hold_text != "" else 0.0

	for rig: MediumRigVisual in [_knight, _graveblade]:
		await _verify_rig(rig)

	if _shot_dir != "":
		print("")
		await _capture_clip_sheet()
		await _capture_socket_details()

	if hold_seconds > 0.0:
		await get_tree().create_timer(hold_seconds).timeout

	print("")
	if _failures.is_empty():
		print("GATE A RIG VERIFICATION: PASS")
		get_tree().quit(0)
	else:
		for failure: String in _failures:
			printerr("  FAIL: %s" % failure)
		printerr("GATE A RIG VERIFICATION: %d FAILURE(S)" % _failures.size())
		get_tree().quit(1)


func _verify_rig(rig: MediumRigVisual) -> void:
	print("")
	print("--- %s" % rig.name)
	var skeleton: Skeleton3D = rig.skeleton()
	var socket: BoneAttachment3D = rig.weapon_socket
	var player: AnimationPlayer = rig.animation_player

	# 1. Every approved clip is present on this body.
	for clip: StringName in CLIP_SEQUENCE:
		if not player.has_animation(clip):
			_fail("%s is missing clip '%s'" % [rig.name, clip])
	print("  clips available: %d/%d" % [
		CLIP_SEQUENCE.size() - _missing_clip_count(player), CLIP_SEQUENCE.size(),
	])

	# 2. The socket resolved by NAME, not by a guessed index.
	var socket_index: int = socket.bone_idx
	var socket_name: String = skeleton.get_bone_name(socket_index) if socket_index != -1 else "<unbound>"
	print("  socket bone: idx=%d name='%s' (expected '%s')" % [socket_index, socket_name, SOCKET_BONE])
	if socket_name != String(SOCKET_BONE):
		_fail("%s weapon socket bound to '%s' instead of '%s'" % [rig.name, socket_name, SOCKET_BONE])

	# 3. A weapon mesh actually hangs off that socket.
	var weapon: Node3D = socket.get_child(0) as Node3D if socket.get_child_count() > 0 else null
	if weapon == null:
		_fail("%s has no weapon under its socket" % rig.name)
		return
	print("  weapon node: %s" % weapon.name)

	# 4. Static scale reference, measured from the live rig.
	var head_index: int = skeleton.find_bone(&"head")
	var head_y: float = (skeleton.global_transform * skeleton.get_bone_global_pose(head_index)).origin.y
	print("  head bone height: %.3f m (floor tile top y = 0.000, wall height = 4.000)" % head_y)

	# 5. The socket tracks the ANIMATED bone, not the rest pose.
	# Blending would contaminate the sampled poses, so cut straight to the clip.
	var samples: Array[Vector3] = []
	rig.play(&"Melee_1H_Attack_Slice_Horizontal", 1.0, 0.0)
	for step: int in 12:
		var sample_time: float = 0.1 * float(step)
		player.seek(sample_time, true)
		await get_tree().process_frame
		await get_tree().process_frame
		var expected: Vector3 = (skeleton.global_transform * skeleton.get_bone_global_pose(socket_index)).origin
		var actual: Vector3 = socket.global_position
		var error: float = actual.distance_to(expected)
		samples.append(actual)
		if error > ATTACHMENT_TOLERANCE_M:
			_fail("%s socket drifted %.4f m from bone '%s' at t=%.2f" % [rig.name, error, SOCKET_BONE, sample_time])
	var travel: float = 0.0
	for i: int in range(1, samples.size()):
		travel += samples[i - 1].distance_to(samples[i])
	print("  socket follows swing: %.3f m of arc travel over %d samples" % [travel, samples.size()])
	if travel < 0.5:
		_fail("%s weapon socket barely moves during the attack clip (%.3f m); the rig may not be animating" % [rig.name, travel])

	# 6. In-place locomotion: the run cycle must not translate the actor.
	var rig_origin_before: Vector3 = rig.global_position
	rig.play(&"Running_A", 1.0, 0.0)
	player.seek(0.0, true)
	await get_tree().process_frame
	var hips_index: int = skeleton.find_bone(&"hips")
	var hips_start: Vector3 = skeleton.get_bone_global_pose(hips_index).origin
	player.seek(player.get_animation(&"Running_A").length, true)
	await get_tree().process_frame
	await get_tree().process_frame
	var hips_end: Vector3 = skeleton.get_bone_global_pose(hips_index).origin
	var planar_drift: float = Vector2(hips_end.x - hips_start.x, hips_end.z - hips_start.z).length()
	var actor_drift: float = rig.global_position.distance_to(rig_origin_before)
	print("  Running_A hips planar drift: %.5f m   actor drift: %.5f m" % [planar_drift, actor_drift])
	if planar_drift > IN_PLACE_TOLERANCE_M or actor_drift > IN_PLACE_TOLERANCE_M:
		_fail("%s Running_A is not in-place (hips %.5f m, actor %.5f m)" % [rig.name, planar_drift, actor_drift])

	rig.play(&"Idle_A", 1.0, 0.0)


func _capture_clip_sheet() -> void:
	for clip: StringName in CLIP_SEQUENCE:
		_show_clip(CLIP_SEQUENCE.find(clip), 0.0)
		_knight.animation_player.seek(_pose_time(clip), true)
		_graveblade.animation_player.seek(_pose_time(clip), true)
		await RenderingServer.frame_post_draw
		await RenderingServer.frame_post_draw
		var image: Image = get_viewport().get_texture().get_image()
		var path: String = "%s/gate_a_%s.png" % [_shot_dir, clip]
		image.save_png(path)
		print("  screenshot: %s" % path)


## Close-ups of each weapon socket at the release pose, so the Gate A record
## contains visual proof of the attachment and not only numbers.
func _capture_socket_details() -> void:
	var wide_size: float = _camera.size
	var wide_position: Vector3 = _camera.global_position
	for rig: MediumRigVisual in [_knight, _graveblade]:
		rig.play(&"Melee_1H_Attack_Slice_Horizontal", 1.0, 0.0)
		rig.animation_player.seek(0.70, true)
		_frame(rig.global_position + Vector3(0.0, 1.1, 0.0), 3.4)
		_label.text = "Gate A — %s weapon socket '%s' at the release pose" % [rig.name, SOCKET_BONE]
		await RenderingServer.frame_post_draw
		await RenderingServer.frame_post_draw
		var path: String = "%s/gate_a_socket_%s.png" % [_shot_dir, rig.name]
		get_viewport().get_texture().get_image().save_png(path)
		print("  screenshot: %s" % path)
		rig.play(&"Idle_A", 1.0, 0.0)
	_camera.size = wide_size
	_camera.global_position = wide_position


## Repositions the orthographic camera without changing its angle.
func _frame(target: Vector3, ortho_size: float) -> void:
	_camera.size = ortho_size
	_camera.global_position = target + _camera.global_transform.basis.z * 20.0


## A pose time that shows each clip at its most legible moment.
func _pose_time(clip: StringName) -> float:
	match clip:
		&"Melee_1H_Attack_Slice_Horizontal":
			return 0.70
		&"Melee_1H_Attack_Chop":
			return 0.55
		&"Running_A":
			return 0.20
		&"Death_A":
			return 0.75
		&"PickUp":
			return 0.65
		&"Hit_A":
			return 0.20
		_:
			return 0.30


func _missing_clip_count(player: AnimationPlayer) -> int:
	var missing: int = 0
	for clip: StringName in CLIP_SEQUENCE:
		if not player.has_animation(clip):
			missing += 1
	return missing


func _fail(message: String) -> void:
	_failures.append(message)


func _argument_value(arguments: PackedStringArray, flag: String) -> String:
	var index: int = arguments.find(flag)
	if index == -1 or index + 1 >= arguments.size():
		return ""
	return arguments[index + 1]
