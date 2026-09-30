extends SceneTree
## Gate A asset probe.
##
## Headless inspection of the imported registered KayKit candidates.
## Reports rig, bone, socket, scale, animation, and root-motion facts so the
## Gate A findings in assets/third_party/kaykit/SOURCE_AND_LICENSE.md are
## measured rather than guessed.
##
## Run:
##   godot --headless --path game --script res://scripts/tools/gate_a_asset_report.gd

const CHARACTERS: Array[String] = [
	"res://assets/third_party/kaykit/adventurer/Knight.glb",
	"res://assets/third_party/kaykit/skeleton/Skeleton_Warrior.glb",
]

const PROPS: Array[String] = [
	"res://assets/third_party/kaykit/adventurer/sword_1handed.gltf",
	"res://assets/third_party/kaykit/skeleton/Skeleton_Blade.gltf",
	"res://assets/third_party/kaykit/dungeon/floor_tile_large.gltf",
	"res://assets/third_party/kaykit/dungeon/wall.gltf",
	"res://assets/third_party/kaykit/dungeon/wall_corner.gltf",
	"res://assets/third_party/kaykit/dungeon/wall_pillar.gltf",
]

const ANIMATION_SOURCES: Array[String] = [
	"res://assets/third_party/kaykit/animations/Rig_Medium_General.glb",
	"res://assets/third_party/kaykit/animations/Rig_Medium_MovementBasic.glb",
	"res://assets/third_party/kaykit/animations/Rig_Medium_CombatMelee.glb",
]

const REQUIRED_CLIPS: Array[String] = [
	"Idle_A",
	"Running_A",
	"Melee_1H_Attack_Slice_Horizontal",
	"Melee_1H_Attack_Chop",
	"Hit_A",
	"Death_A",
	"PickUp",
]

var _failures: int = 0


func _initialize() -> void:
	print("=== Riftwrought Gate A asset report ===")
	print("Godot: %s" % Engine.get_version_info().get("string", "unknown"))
	print("")

	var rigs: Dictionary = {}
	for path: String in CHARACTERS:
		rigs[path] = _report_character(path)
	_compare_rigs(rigs)
	for path: String in PROPS:
		_report_prop(path)
	_report_animations()

	print("")
	if _failures == 0:
		print("GATE A ASSET REPORT: PASS")
	else:
		printerr("GATE A ASSET REPORT: %d FAILURE(S)" % _failures)
	quit(0 if _failures == 0 else 1)


func _fail(message: String) -> void:
	_failures += 1
	printerr("  FAIL: %s" % message)


func _load_scene(path: String) -> Node:
	var packed: PackedScene = load(path) as PackedScene
	if packed == null:
		_fail("could not load %s" % path)
		return null
	return packed.instantiate()


func _report_character(path: String) -> PackedStringArray:
	print("--- character: %s" % path)
	var root: Node = _load_scene(path)
	if root == null:
		return PackedStringArray()

	print("  root node: %s (%s)" % [root.name, root.get_class()])

	var skeleton: Skeleton3D = _find_first(root, "Skeleton3D") as Skeleton3D
	if skeleton == null:
		_fail("no Skeleton3D under %s" % path)
		root.free()
		return PackedStringArray()

	var bone_names: PackedStringArray = PackedStringArray()
	for i: int in skeleton.get_bone_count():
		bone_names.append(skeleton.get_bone_name(i))
	print("  Skeleton3D: %s  bones=%d" % [skeleton.name, skeleton.get_bone_count()])

	for socket: String in ["handslot.r", "handslot.l"]:
		var idx: int = skeleton.find_bone(socket)
		if idx == -1:
			_fail("socket bone '%s' missing" % socket)
			continue
		var parent_name: String = skeleton.get_bone_name(skeleton.get_bone_parent(idx))
		var rest: Transform3D = skeleton.get_bone_rest(idx)
		var global_rest: Transform3D = skeleton.get_bone_global_rest(idx)
		print("  socket '%s' idx=%d parent='%s'" % [socket, idx, parent_name])
		print("      local rest origin  = %s" % _v(rest.origin))
		print("      global rest origin = %s" % _v(global_rest.origin))

	var head_index: int = skeleton.find_bone(&"head")
	if head_index == -1:
		_fail("'head' bone missing from %s" % path)
	else:
		print("  rest 'head' bone height = %.4f m" % skeleton.get_bone_global_rest(head_index).origin.y)

	var meshes: Array[Node] = []
	_collect(root, "MeshInstance3D", meshes)
	var aabb: AABB = AABB()
	var first: bool = true
	for node: Node in meshes:
		var mi: MeshInstance3D = node as MeshInstance3D
		var world: AABB = _relative_transform(mi, root) * mi.get_aabb()
		if first:
			aabb = world
			first = false
		else:
			aabb = aabb.merge(world)
	print("  surfaces: %d MeshInstance3D" % meshes.size())
	print("  rest AABB position = %s" % _v(aabb.position))
	print("  rest AABB size     = %s" % _v(aabb.size))
	print("  rest height        = %.3f m   floor offset = %.4f m" % [aabb.size.y, aabb.position.y])
	if absf(aabb.position.y) > 0.02:
		_fail("%s rest pose does not sit on y=0 (offset %.4f)" % [path, aabb.position.y])

	var players: Array[Node] = []
	_collect(root, "AnimationPlayer", players)
	print("  AnimationPlayer nodes: %d" % players.size())
	root.free()
	return bone_names


func _compare_rigs(rigs: Dictionary) -> void:
	print("")
	print("--- rig compatibility")
	var keys: Array = rigs.keys()
	if keys.size() < 2:
		_fail("fewer than two character rigs to compare")
		return
	var a: PackedStringArray = rigs[keys[0]]
	var b: PackedStringArray = rigs[keys[1]]
	var set_a: Dictionary = {}
	var set_b: Dictionary = {}
	for n: String in a:
		set_a[n] = true
	for n: String in b:
		set_b[n] = true
	var missing_in_b: Array = []
	for n: String in set_a:
		if not set_b.has(n):
			missing_in_b.append(n)
	var missing_in_a: Array = []
	for n: String in set_b:
		if not set_a.has(n):
			missing_in_a.append(n)
	print("  Knight bones: %d   Skeleton_Warrior bones: %d" % [a.size(), b.size()])
	print("  identical bone-name sets: %s" % str(missing_in_a.is_empty() and missing_in_b.is_empty()))
	print("  identical bone ORDER:     %s" % str(a == b))
	if not missing_in_a.is_empty() or not missing_in_b.is_empty():
		_fail("bone-name sets differ (only in Knight: %s / only in Skeleton: %s)" % [missing_in_b, missing_in_a])
	print("  bone list: %s" % ", ".join(a))


func _report_prop(path: String) -> void:
	print("")
	print("--- prop: %s" % path)
	var root: Node = _load_scene(path)
	if root == null:
		return
	var meshes: Array[Node] = []
	_collect(root, "MeshInstance3D", meshes)
	var aabb: AABB = AABB()
	var first: bool = true
	for node: Node in meshes:
		var mi: MeshInstance3D = node as MeshInstance3D
		var world: AABB = _relative_transform(mi, root) * mi.get_aabb()
		if first:
			aabb = world
			first = false
		else:
			aabb = aabb.merge(world)
		var mesh: Mesh = mi.mesh
		for s: int in mesh.get_surface_count():
			var mat: Material = mesh.surface_get_material(s)
			var albedo: String = "<none>"
			var base: BaseMaterial3D = mat as BaseMaterial3D
			if base != null and base.albedo_texture != null:
				albedo = str(base.albedo_texture.resource_path)
			print("  surface %d material=%s albedo=%s" % [s, str(mat.resource_name), albedo])
	print("  AABB position = %s  size = %s" % [_v(aabb.position), _v(aabb.size)])
	root.free()


func _report_animations() -> void:
	print("")
	print("--- medium-rig animation libraries")
	var found: Dictionary = {}
	for path: String in ANIMATION_SOURCES:
		var root: Node = _load_scene(path)
		if root == null:
			continue
		var player: AnimationPlayer = _find_first(root, "AnimationPlayer") as AnimationPlayer
		if player == null:
			_fail("no AnimationPlayer in %s" % path)
			root.free()
			continue
		print("  %s" % path.get_file())
		for clip: String in player.get_animation_list():
			var anim: Animation = player.get_animation(clip)
			found[clip] = {"source": path.get_file(), "length": anim.length, "tracks": anim.get_track_count()}
		var names: PackedStringArray = player.get_animation_list()
		print("     %d clips: %s" % [names.size(), ", ".join(names)])
		root.free()

	print("")
	print("  required Prototype Zero clips:")
	for clip: String in REQUIRED_CLIPS:
		if not found.has(clip):
			_fail("required clip '%s' not present in any medium-rig library" % clip)
			continue
		var info: Dictionary = found[clip]
		print("     %-34s %-32s length=%.4f s tracks=%d" % [clip, info["source"], info["length"], info["tracks"]])


## Node3D.global_transform is unavailable outside the tree, so compose the
## transform up to the loaded scene root by hand.
func _relative_transform(node: Node3D, root: Node) -> Transform3D:
	var xform: Transform3D = Transform3D.IDENTITY
	var current: Node = node
	while current != null and current != root.get_parent():
		var spatial: Node3D = current as Node3D
		if spatial != null:
			xform = spatial.transform * xform
		current = current.get_parent()
	return xform


func _v(v: Vector3) -> String:
	return "(%.3f, %.3f, %.3f)" % [v.x, v.y, v.z]


func _find_first(node: Node, klass: String) -> Node:
	if node.is_class(klass):
		return node
	for child: Node in node.get_children():
		var hit: Node = _find_first(child, klass)
		if hit != null:
			return hit
	return null


func _collect(node: Node, klass: String, out: Array[Node]) -> void:
	if node.is_class(klass):
		out.append(node)
	for child: Node in node.get_children():
		_collect(child, klass, out)
