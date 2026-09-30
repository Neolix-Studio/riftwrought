extends SceneTree
## Builds the single Prototype Zero medium-rig AnimationLibrary.
##
## The three registered KayKit medium-rig GLBs import as separate scenes, each
## with its own AnimationPlayer. Every clip addresses the same track paths
## ("Rig_Medium/Skeleton3D:<bone>"), so the approved Prototype Zero clips can be
## merged into one library that both the Knight and the Skeleton Warrior use.
##
## Regenerate with:
##   godot --headless --path game --script res://scripts/tools/build_rig_medium_library.gd

const OUTPUT_PATH: String = "res://assets/third_party/kaykit/animations/rig_medium_prototype_library.res"

## clip name -> [source glb, looping]
const CLIPS: Dictionary = {
	"Idle_A": ["res://assets/third_party/kaykit/animations/Rig_Medium_General.glb", true],
	"Hit_A": ["res://assets/third_party/kaykit/animations/Rig_Medium_General.glb", false],
	"Death_A": ["res://assets/third_party/kaykit/animations/Rig_Medium_General.glb", false],
	"PickUp": ["res://assets/third_party/kaykit/animations/Rig_Medium_General.glb", false],
	"Running_A": ["res://assets/third_party/kaykit/animations/Rig_Medium_MovementBasic.glb", true],
	"Melee_1H_Attack_Slice_Horizontal": ["res://assets/third_party/kaykit/animations/Rig_Medium_CombatMelee.glb", false],
	"Melee_1H_Attack_Chop": ["res://assets/third_party/kaykit/animations/Rig_Medium_CombatMelee.glb", false],
}


func _initialize() -> void:
	var sources: Dictionary = {}
	var library: AnimationLibrary = AnimationLibrary.new()
	var failures: int = 0

	for clip_name: String in CLIPS:
		var entry: Array = CLIPS[clip_name]
		var source_path: String = entry[0]
		var looping: bool = entry[1]

		if not sources.has(source_path):
			var packed: PackedScene = load(source_path) as PackedScene
			if packed == null:
				printerr("FAIL: cannot load %s" % source_path)
				failures += 1
				continue
			sources[source_path] = packed.instantiate()

		var root: Node = sources[source_path]
		var player: AnimationPlayer = _find_player(root)
		if player == null or not player.has_animation(clip_name):
			printerr("FAIL: clip '%s' not found in %s" % [clip_name, source_path])
			failures += 1
			continue

		var animation: Animation = (player.get_animation(clip_name) as Animation).duplicate(true)
		animation.resource_name = clip_name
		animation.loop_mode = Animation.LOOP_LINEAR if looping else Animation.LOOP_NONE
		library.add_animation(clip_name, animation)
		print("  + %-34s %-30s %6.4f s  loop=%s" % [clip_name, source_path.get_file(), animation.length, looping])

	for root: Node in sources.values():
		root.free()

	if failures > 0:
		printerr("BUILD FAILED with %d error(s)" % failures)
		quit(1)
		return

	var error: Error = ResourceSaver.save(library, OUTPUT_PATH)
	if error != OK:
		printerr("FAIL: could not save %s (error %d)" % [OUTPUT_PATH, error])
		quit(1)
		return

	print("Wrote %s with %d clips." % [OUTPUT_PATH, library.get_animation_list().size()])
	quit(0)


func _find_player(node: Node) -> AnimationPlayer:
	var player: AnimationPlayer = node as AnimationPlayer
	if player != null:
		return player
	for child: Node in node.get_children():
		var hit: AnimationPlayer = _find_player(child)
		if hit != null:
			return hit
	return null
