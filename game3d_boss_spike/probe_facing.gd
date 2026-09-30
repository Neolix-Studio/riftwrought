extends SceneTree
func _initialize() -> void:
	var lib_src: Node = (load(RigCompat.UAL1) as PackedScene).instantiate()
	root.add_child(lib_src)
	await process_frame
	var ap0: AnimationPlayer = RigCompat._find_ap(lib_src)
	var lib: AnimationLibrary = ap0.get_animation_library(&"").duplicate(true)
	lib_src.queue_free()
	await process_frame
	for entry in [["Puglin", RigCompat.PUGLIN], ["Imp", RigCompat.IMP],
			["Ranger", RigCompat.OUTFIT_RANGER]]:
		var inst: Node3D = (load(entry[1]) as PackedScene).instantiate()
		root.add_child(inst)
		var sk := RigCompat.find_skeleton(inst)
		var ap := AnimationPlayer.new()
		inst.add_child(ap)
		ap.add_animation_library(&"", lib)
		ap.root_node = NodePath("..")
		ap.play("Idle")
		ap.seek(0.4, true)
		for i in 3: await process_frame
		# TOE DIRECTION: foot -> ball, projected on XZ, is the facing direction.
		var res := {}
		for side in ["l", "r"]:
			var fi := sk.find_bone("foot_" + side)
			var bi := sk.find_bone("ball_" + side)
			if fi < 0 or bi < 0:
				res[side] = "missing"
				continue
			var fp := (sk.global_transform * sk.get_bone_global_pose(fi)).origin
			var bp := (sk.global_transform * sk.get_bone_global_pose(bi)).origin
			var v := bp - fp
			v.y = 0.0
			res[side] = "%s (len %.4f) -> z sign %s" % [str(v.normalized().snappedf(0.001)), v.length(), "+Z" if v.z > 0 else "-Z"]
		print("%-8s foot_l->ball_l %s" % [entry[0], res.get("l","?")])
		print("%-8s foot_r->ball_r %s" % [entry[0], res.get("r","?")])
		inst.queue_free()
		await process_frame
	quit(0)
