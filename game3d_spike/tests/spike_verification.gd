extends SceneTree

## RIFTWROUGHT — 3D FEASIBILITY SPIKE VERIFICATION (D-366, 2026-09-17)
##
## This suite follows the project's standing verification rules verbatim:
##   * A passing COUNT proves the assertions that EXIST, not the ones that
##     should. So the suite OWES a named list and compares owed vs reached
##     IN BOTH DIRECTIONS.
##   * Every check records reaching its LAST line. A throw mid-check therefore
##     shows up as UNREACHED rather than as a silent pass.
##   * A guard that accepts everything protects nothing, and a guard nothing can
##     reach is not a guard -- so several checks PROVE their own guard refuses a
##     planted bad value.
##   * An assertion that something did NOT happen can pass because the action
##     never ran -- so each such check asserts the action fired first.
##   * An unperformed check is recorded DEFERRED, never as a pass, and names
##     where it must return.
##
## IT VERIFIES A FEASIBILITY SPIKE. It does not accept a visual direction, does
## not complete a phase, and grants nothing.

const OWED := [
	"C01_project_resources_resolve",
	"C02_licences_and_provenance_present",
	"C03_rig_outfit_animation_aligned",
	"C04_no_hidden_base_body",
	"C05_clip_names_truthful_and_guard_can_fail",
	"C06_no_runtime_mirroring",
	"C07_bow_on_correct_bone",
	"C08_bow_rides_bone_through_animation",
	"C09_camera_is_orthographic",
	"C10_camera_rotation_locked_across_states",
	"C11_zoom_bounded_and_both_bounds_reachable",
	"C12_movement_changes_position_not_aim",
	"C13_aim_changes_aim_not_position",
	"C14_projectile_is_labelled_diagnostic",
	"C15_projectile_hit_cleanup",
	"C16_projectile_miss_cleanup",
	"C17_enemy_hit_precedes_death",
	"C18_loot_only_after_death",
	"C19_normal_encounter_is_six",
	"C20_density_mode_is_24_and_passive",
	"C21_provisional_labels_in_runtime_and_code",
	"C22_top_speed_re_evaluated_not_inherited",
	"C23_truthfulness_denials_present",
	"C24_no_2d_lock_promoted",
	"C25_test_seam_disabled_in_normal_play",
]

## Rows this spike does NOT pass and does NOT pretend to. Printed and counted
## every run, as TRANSFERRED / DEFERRED -- never as passes.
const DEFERRED_ROWS := [
	["D01_truthful_bow_attack_animation",
	 "UAL2 Standard contains NO bow/archery clip (0 of 43). The attack uses "
	 + "'OverhandThrow', a THROW, labelled as a placeholder in code and on "
	 + "screen. RETURNS TO: a future animation source with a real bow clip."],
	["D02_enemy_death_animation",
	 "UAL2 Standard contains NO death clip (0 of 43). Death is a code-driven "
	 + "topple-and-sink. RETURNS TO: the same future animation source."],
	["D03_neutral_locomotion_clip",
	 "UAL2 Standard contains NO neutral walk or run. 'Walk_Carry' (a CARRY "
	 + "walk) is used and named truthfully. RETURNS TO: the same."],
	["D04_controller_hardware",
	 "The controller INPUT PATH is mapped and asserted; no physical gamepad can "
	 + "be attached in this environment. RETURNS TO: owner live review."],
	["D05_head_under_hood",
	 "The free-tier base character is ONE full-body skinned mesh, so the pack's "
	 + "'head only' instruction cannot be executed without editing a source "
	 + "mesh, which is forbidden here. RETURNS TO: the SOURCE tier, or an "
	 + "owner-authored head."],
]

var reached := {}
var results := {}
var notes := {}
var main: Node
var errors: Array[String] = []

func _initialize() -> void:
	print("========================================================================")
	print("RIFTWROUGHT 3D FEASIBILITY SPIKE — VERIFICATION  (%s, %s)"
		% [SpikeConfig.SPIKE_DECISION, SpikeConfig.SPIKE_DATE])
	print("Verifying a BOUNDED FEASIBILITY SPIKE. This suite accepts no visual")
	print("direction, completes no phase, and authorizes nothing.")
	print("OWED CHECKS: %d   DEFERRED/TRANSFERRED ROWS: %d" % [OWED.size(), DEFERRED_ROWS.size()])
	print("========================================================================")

	main = load("res://scenes/main.tscn").instantiate()
	root.add_child(main)
	for i in 8:
		await process_frame

	await _run("C01_project_resources_resolve", c01)
	await _run("C02_licences_and_provenance_present", c02)
	await _run("C03_rig_outfit_animation_aligned", c03)
	await _run("C04_no_hidden_base_body", c04)
	await _run("C05_clip_names_truthful_and_guard_can_fail", c05)
	await _run("C06_no_runtime_mirroring", c06)
	await _run("C07_bow_on_correct_bone", c07)
	await _run("C08_bow_rides_bone_through_animation", c08)
	await _run("C09_camera_is_orthographic", c09)
	await _run("C10_camera_rotation_locked_across_states", c10)
	await _run("C11_zoom_bounded_and_both_bounds_reachable", c11)
	await _run("C12_movement_changes_position_not_aim", c12)
	await _run("C13_aim_changes_aim_not_position", c13)
	await _run("C14_projectile_is_labelled_diagnostic", c14)
	await _run("C15_projectile_hit_cleanup", c15)
	await _run("C16_projectile_miss_cleanup", c16)
	await _run("C17_enemy_hit_precedes_death", c17)
	await _run("C18_loot_only_after_death", c18)
	await _run("C19_normal_encounter_is_six", c19)
	await _run("C20_density_mode_is_24_and_passive", c20)
	await _run("C21_provisional_labels_in_runtime_and_code", c21)
	await _run("C22_top_speed_re_evaluated_not_inherited", c22)
	await _run("C23_truthfulness_denials_present", c23)
	await _run("C24_no_2d_lock_promoted", c24)
	await _run("C25_test_seam_disabled_in_normal_play", c25)

	_report()
	quit(0 if _all_ok() else 1)

func _run(id: String, fn: Callable) -> void:
	var ok = await fn.call()
	results[id] = ok

func _reached(id: String) -> void:
	reached[id] = true

func _note(id: String, s: String) -> void:
	notes[id] = s

# ---------------------------------------------------------------- checks ----

func c01() -> bool:
	var id := "C01_project_resources_resolve"
	var want := [
		RigAssembly.OUTFIT_RANGER, RigAssembly.BASE_FEMALE, RigAssembly.UAL2,
		RigAssembly.IMP, RigAssembly.BOW, RigAssembly.ARROW,
	]
	for m in ["Floor_Standard", "Wall_Broken", "Torch", "Chest_Gold", "Statue_Stag"]:
		want.append(Courtyard.R % m)
	var missing: Array[String] = []
	for p in want:
		if not ResourceLoader.exists(p) or load(p) == null:
			missing.append(p)
	# Textures the character materials depend on must resolve too.
	var tex_missing := 0
	var stack: Array = [main]
	var checked := 0
	while stack.size() > 0:
		var n = stack.pop_back()
		if n is MeshInstance3D and n.mesh != null:
			for s in range(n.mesh.get_surface_count()):
				var m = n.mesh.surface_get_material(s)
				if m is BaseMaterial3D and m.albedo_texture != null:
					checked += 1
					if m.albedo_texture.get_width() <= 0:
						tex_missing += 1
		for c in n.get_children():
			stack.append(c)
	_note(id, "%d resources checked, %d missing; %d bound albedo textures, %d unresolved"
		% [want.size(), missing.size(), checked, tex_missing])
	var ok := missing.is_empty() and tex_missing == 0 and checked > 0
	_reached(id)
	return ok

func c02() -> bool:
	var id := "C02_licences_and_provenance_present"
	var base := "res://assets/third_party/quaternius/"
	var need := [
		base + "SOURCE_AND_LICENSE.md",
		base + "licenses/LICENSE_modular_character_outfits_fantasy_CC0.txt",
		base + "licenses/LICENSE_universal_animation_library_2_CC0.txt",
		base + "licenses/LICENSE_universal_base_characters_CC0.txt",
		base + "licenses/LICENSE_medieval_weapons_CC0.txt",
		base + "licenses/LICENSE_ultimate_modular_ruins_CC0.txt",
		base + "licenses/LICENSE_bestiary_dungeon_monsters_QAL_v1.0.txt",
	]
	var missing: Array[String] = []
	for f in need:
		if not FileAccess.file_exists(f):
			missing.append(f)
	# The QAL restriction must be recorded ACCURATELY, not blanket-claimed CC0.
	var prov := ""
	if FileAccess.file_exists(base + "SOURCE_AND_LICENSE.md"):
		prov = FileAccess.get_file_as_string(base + "SOURCE_AND_LICENSE.md")
	var qal_ok := prov.findn("QAL") >= 0 \
		and prov.findn("standalone") >= 0 \
		and prov.findn("claims NO ownership") >= 0
	var cc0_blanket := prov.findn("all assets are CC0") >= 0
	_note(id, "%d licence/provenance files, %d missing; QAL restriction recorded=%s; blanket-CC0 claim present=%s"
		% [need.size(), missing.size(), str(qal_ok), str(cc0_blanket)])
	var ok := missing.is_empty() and qal_ok and not cc0_blanket
	_reached(id)
	return ok

func c03() -> bool:
	var id := "C03_rig_outfit_animation_aligned"
	var p: HuntressSpike = main.get("player")
	var skel: Skeleton3D = p.skeleton()
	var lib: AnimationLibrary = main.get("anim_lib")
	var bones := {}
	for i in range(skel.get_bone_count()):
		bones[skel.get_bone_name(i)] = true
	# Every clip the spike asks for must exist in the imported library.
	var absent: Array[String] = []
	for clip in SpikeConfig.REQUIRED_CLIPS:
		if not lib.has_animation(clip):
			absent.append(clip)
	# The Imp's skeleton must be a SUBSET of the Huntress rig (measured claim).
	var es: Array = main.get("enemies")
	var imp_skel: Skeleton3D = RigAssembly.find_skeleton(es[0])
	var extra: Array[String] = []
	for i in range(imp_skel.get_bone_count()):
		if not bones.has(imp_skel.get_bone_name(i)):
			extra.append(imp_skel.get_bone_name(i))
	_note(id, "huntress bones=%d, imp bones=%d, imp-bones-not-in-huntress=%d, clips absent=%d, lib clips=%d"
		% [skel.get_bone_count(), imp_skel.get_bone_count(), extra.size(),
		   absent.size(), lib.get_animation_list().size()])
	var ok := skel.get_bone_count() == 65 and absent.is_empty() \
		and extra.is_empty() and imp_skel.get_bone_count() == 55
	_reached(id)
	return ok

func c04() -> bool:
	var id := "C04_no_hidden_base_body"
	var p: HuntressSpike = main.get("player")
	var names: Array[String] = []
	var stack: Array = [p.visual()]
	while stack.size() > 0:
		var n = stack.pop_back()
		if n is MeshInstance3D:
			names.append(n.name)
		for c in n.get_children():
			stack.append(c)
	# The full base body mesh must NOT be instantiated under the outfit.
	var has_full_body := names.has("Superhero_Female")
	_note(id, "character meshes=%s ; full base body instantiated=%s"
		% [str(names), str(has_full_body)])
	var ok := not has_full_body and names.has("Female_Ranger_Head_Hood")
	_reached(id)
	return ok

func c05() -> bool:
	var id := "C05_clip_names_truthful_and_guard_can_fail"
	# (a) nothing the spike actually plays may be missing
	var real_missing := RigAssembly.missing_clips.size()
	# (b) PROVE THE GUARD CAN REFUSE. A guard nothing can reach is not a guard.
	var p: HuntressSpike = main.get("player")
	var ap: AnimationPlayer = p.visual().get_node("SpikeAnimationPlayer")
	var before := RigAssembly.missing_clips.size()
	RigAssembly.play_guarded(ap, "Bow_Draw_Release_THIS_DOES_NOT_EXIST")
	var grew := RigAssembly.missing_clips.size() == before + 1
	RigAssembly.missing_clips.erase("Bow_Draw_Release_THIS_DOES_NOT_EXIST")
	# (c) the attack clip must be named for what it IS
	var honest := SpikeConfig.CLIP_PLAYER_ATTACK == "OverhandThrow"
	_note(id, "clips missing in real use=%d; planted bad clip refused=%s; attack clip named truthfully='%s'"
		% [real_missing, str(grew), SpikeConfig.CLIP_PLAYER_ATTACK])
	var ok := real_missing == 0 and grew and honest
	_reached(id)
	return ok

func c06() -> bool:
	var id := "C06_no_runtime_mirroring"
	var bad: Array[String] = []
	var checked := 0
	var stack: Array = [main]
	while stack.size() > 0:
		var n = stack.pop_back()
		if n is Node3D:
			checked += 1
			var b: Basis = (n as Node3D).transform.basis
			if b.determinant() < 0.0:
				bad.append(n.name)
			var sc: Vector3 = (n as Node3D).scale
			if sc.x < 0.0 or sc.y < 0.0 or sc.z < 0.0:
				bad.append(n.name + "(neg scale)")
		for c in n.get_children():
			stack.append(c)
	_note(id, "%d Node3D checked, %d mirrored/negative-scaled: %s"
		% [checked, bad.size(), str(bad)])
	var ok := bad.is_empty() and checked > 50
	_reached(id)
	return ok

func c07() -> bool:
	var id := "C07_bow_on_correct_bone"
	var p: HuntressSpike = main.get("player")
	var att: BoneAttachment3D = p.bow_attachment()
	var skel: Skeleton3D = p.skeleton()
	var on_left := String(att.bone_name) == SpikeConfig.BONE_BOW_HAND
	var bone_exists := skel.find_bone(SpikeConfig.BONE_BOW_HAND) >= 0
	var parented := att.get_parent() == skel
	_note(id, "attachment bone='%s' (want '%s'), bone exists=%s, parented to Skeleton3D=%s"
		% [att.bone_name, SpikeConfig.BONE_BOW_HAND, str(bone_exists), str(parented)])
	var ok := on_left and bone_exists and parented
	_reached(id)
	return ok

func c08() -> bool:
	var id := "C08_bow_rides_bone_through_animation"
	var p: HuntressSpike = main.get("player")
	var att: BoneAttachment3D = p.bow_attachment()
	var bw: Node3D = p.bow_node()
	var skel: Skeleton3D = p.skeleton()
	var bi := skel.find_bone(SpikeConfig.BONE_BOW_HAND)
	var max_off := 0.0
	var bone_travel := 0.0
	var first: Vector3 = skel.global_transform * skel.get_bone_global_pose(bi).origin
	var lo := first
	var hi := first
	for i in 90:
		await process_frame
		var bone_world: Vector3 = skel.global_transform * skel.get_bone_global_pose(bi).origin
		lo = Vector3(minf(lo.x, bone_world.x), minf(lo.y, bone_world.y), minf(lo.z, bone_world.z))
		hi = Vector3(maxf(hi.x, bone_world.x), maxf(hi.y, bone_world.y), maxf(hi.z, bone_world.z))
		max_off = maxf(max_off, bw.global_position.distance_to(bone_world))
	bone_travel = (hi - lo).length()
	# A REST-POSE-ONLY CHECK WOULD BE FAIL BY CONSTRUCTION. The bone must be
	# proved to have MOVED, or "the bow tracked it" proves nothing.
	_note(id, "hand bone travelled %.4f m over 90 frames; max bow-to-bone offset %.4f m"
		% [bone_travel, max_off])
	var ok := bone_travel > 0.005 and max_off < 0.05
	_reached(id)
	return ok

func c09() -> bool:
	var id := "C09_camera_is_orthographic"
	var cam: IsoCamera = main.get("cam")
	var ok := cam.projection == Camera3D.PROJECTION_ORTHOGONAL and cam.current
	_note(id, "projection=%d (PROJECTION_ORTHOGONAL=%d), current=%s"
		% [cam.projection, Camera3D.PROJECTION_ORTHOGONAL, str(cam.current)])
	_reached(id)
	return ok

func c10() -> bool:
	var id := "C10_camera_rotation_locked_across_states"
	var cam: IsoCamera = main.get("cam")
	var p: HuntressSpike = main.get("player")
	var base := cam.global_transform.basis
	var samples := 0
	var drift := 0.0
	# rest
	await process_frame
	drift = maxf(drift, _basis_delta(base, cam.global_transform.basis)); samples += 1
	# after movement
	Input.action_press("move_right")
	for i in 20:
		await process_frame
	Input.action_release("move_right")
	drift = maxf(drift, _basis_delta(base, cam.global_transform.basis)); samples += 1
	# after zoom
	cam.apply_zoom(-6.0)
	for i in 20:
		await process_frame
	drift = maxf(drift, _basis_delta(base, cam.global_transform.basis)); samples += 1
	# during combat
	p._release_arrow()
	for i in 20:
		await process_frame
	drift = maxf(drift, _basis_delta(base, cam.global_transform.basis)); samples += 1
	# PROVE THE LOCK CAN REFUSE: shove the camera and require it to snap back.
	cam.global_transform.basis = Basis.from_euler(Vector3(0.4, 0.9, 0.3))
	await process_frame
	await process_frame
	var recovered := _basis_delta(base, cam.global_transform.basis) < 1e-5
	cam.apply_zoom(6.0)
	_note(id, "%d state samples, max basis drift %.9f; forced rotation recovered=%s; violations counter=%d"
		% [samples, drift, str(recovered), cam.rotation_violations])
	var ok := samples == 4 and drift < 1e-5 and recovered
	_reached(id)
	return ok

func _basis_delta(a: Basis, b: Basis) -> float:
	var d := 0.0
	for i in 3:
		d = maxf(d, (a[i] - b[i]).length())
	return d

func c11() -> bool:
	var id := "C11_zoom_bounded_and_both_bounds_reachable"
	var cam: IsoCamera = main.get("cam")
	# push hard past the inner bound, then let the smoothing settle. (A 10-frame
	# wait made this fail at size 14.60 while the TARGET was already clamped to
	# 11.00 -- the bound held, the lerp simply had not arrived. The check now
	# asserts BOTH the clamped target and the settled actual, so it measures the
	# bound rather than the smoothing rate.)
	for i in 60:
		cam.apply_zoom(-1.0)
	var min_target := cam.zoom_target
	for i in 90:
		await process_frame
	var at_min := cam.size
	var min_held := cam.size >= SpikeConfig.CAM_SIZE_MIN - 1e-4 \
		and is_equal_approx(min_target, SpikeConfig.CAM_SIZE_MIN)
	var reached_min := cam.reached_min
	# push hard past the outer bound
	for i in 120:
		cam.apply_zoom(1.0)
	var max_target := cam.zoom_target
	for i in 90:
		await process_frame
	var at_max := cam.size
	var max_held := cam.size <= SpikeConfig.CAM_SIZE_MAX + 1e-4 \
		and is_equal_approx(max_target, SpikeConfig.CAM_SIZE_MAX)
	var reached_max := cam.reached_max
	# restore
	cam.zoom_target = SpikeConfig.CAM_SIZE_DEFAULT
	for i in 10:
		await process_frame
	_note(id, "min bound %.2f: target %.4f, settled size %.4f, reached=%s held=%s | max bound %.2f: target %.4f, settled size %.4f, reached=%s held=%s | clamp refusals=%d"
		% [SpikeConfig.CAM_SIZE_MIN, min_target, at_min, str(reached_min), str(min_held),
		   SpikeConfig.CAM_SIZE_MAX, max_target, at_max, str(reached_max), str(max_held),
		   cam.zoom_clamp_events])
	# BOTH bounds must be REACHABLE and NEITHER may be exceeded. A bound that
	# cannot be reached is not a bound.
	var ok := min_held and max_held and reached_min and reached_max \
		and cam.zoom_clamp_events > 0 \
		and absf(at_min - SpikeConfig.CAM_SIZE_MIN) < 0.05 \
		and absf(at_max - SpikeConfig.CAM_SIZE_MAX) < 0.05
	_reached(id)
	return ok

func c12() -> bool:
	var id := "C12_movement_changes_position_not_aim"
	var p: HuntressSpike = main.get("player")
	var cam: IsoCamera = main.get("cam")
	# The independent quantity is the aim POINT (where she is aiming AT), not
	# the aim DIRECTION -- a direction must rotate as she moves relative to a
	# fixed world point, and that is correct behaviour, not a dependency.
	var fixed_target := Vector3(7.0, 0.0, -2.0)
	cam.debug_cursor_override = fixed_target
	for i in 8:
		await process_frame
	var pos0 := p.global_position
	var aim_pt0 := p.aim_point
	Input.action_press("move_right")
	for i in 30:
		await process_frame
	Input.action_release("move_right")
	for i in 10:
		await process_frame
	var moved := pos0.distance_to(p.global_position)
	var aim_pt_drift := aim_pt0.distance_to(p.aim_point)
	var target_drift := fixed_target.distance_to(p.aim_point)
	cam.debug_cursor_override = null
	_note(id, "moved %.4f m on move input; aim POINT drift %.9f m; aim point still equals the fixed world target within %.9f m"
		% [moved, aim_pt_drift, target_drift])
	# Assert the ACTION FIRED (she really moved) before asserting what did not.
	var ok := moved > 0.5 and aim_pt_drift < 1e-4 and target_drift < 1e-4
	_reached(id)
	return ok

func c13() -> bool:
	var id := "C13_aim_changes_aim_not_position"
	var p: HuntressSpike = main.get("player")
	var cam: IsoCamera = main.get("cam")
	p.velocity = Vector3.ZERO
	cam.debug_cursor_override = p.global_position + Vector3(6.0, 0.0, 0.0)
	for i in 10:
		await process_frame
	var aim0 := p.aim_dir
	var pos0 := p.global_position
	cam.debug_cursor_override = p.global_position + Vector3(0.0, 0.0, -6.0)
	for i in 20:
		await process_frame
	var aim_delta := aim0.distance_to(p.aim_dir)
	var pos_delta := pos0.distance_to(p.global_position)
	cam.debug_cursor_override = null
	_note(id, "aim changed by %.4f with NO move input; position changed by %.6f m"
		% [aim_delta, pos_delta])
	# Again: prove the aim actually changed before claiming position did not.
	var ok := aim_delta > 0.5 and pos_delta < 0.01
	_reached(id)
	return ok

func c14() -> bool:
	var id := "C14_projectile_is_labelled_diagnostic"
	var runtime_says := SpikeConfig.PROJECTILE_LABEL.findn("DIAGNOSTIC") >= 0 \
		and SpikeConfig.PROJECTILE_LABEL.findn("non-canonical") >= 0
	var hud_says := false
	var hud: SpikeHUD = main.get("hud")
	for c in hud.get_children():
		if c is Label and (c as Label).text.findn("DIAGNOSTIC") >= 0 \
				and (c as Label).text.findn("NOT a designed Skill") >= 0:
			hud_says = true
	_note(id, "label='%s'; on-screen diagnostic + 'NOT a designed Skill' present=%s"
		% [SpikeConfig.PROJECTILE_LABEL, str(hud_says)])
	var ok := runtime_says and hud_says and ArrowSpike.DIAGNOSTIC
	_reached(id)
	return ok

func c15() -> bool:
	var id := "C15_projectile_hit_cleanup"
	var p: HuntressSpike = main.get("player")
	var es: Array = main.get("enemies")
	var target: EnemySpike = null
	for e in es:
		if is_instance_valid(e) and e.state != EnemySpike.State.DEAD:
			target = e
			break
	var root_arrows: Node3D = main.get("arrows_root")
	for c in root_arrows.get_children():
		c.queue_free()
	await process_frame
	var hp_before := target.health
	p.global_position = target.global_position + Vector3(0, 0, 3.0)
	p.aim_dir = (target.global_position - p.global_position).normalized()
	p._release_arrow()
	await process_frame
	var spawned := root_arrows.get_child_count()
	for i in 60:
		await process_frame
		if root_arrows.get_child_count() == 0:
			break
	var left := root_arrows.get_child_count()
	var damaged := target.health < hp_before
	_note(id, "arrow spawned=%d, damage applied=%s (%.1f -> %.1f), arrows left after impact=%d"
		% [spawned, str(damaged), hp_before, target.health, left])
	var ok := spawned == 1 and damaged and left == 0
	_reached(id)
	return ok

func c16() -> bool:
	var id := "C16_projectile_miss_cleanup"
	var p: HuntressSpike = main.get("player")
	var root_arrows: Node3D = main.get("arrows_root")
	for c in root_arrows.get_children():
		c.queue_free()
	await process_frame
	# Fire straight up-range at nothing.
	p.aim_dir = Vector3(0, 0, 1).normalized()
	p.global_position = Vector3(0, 0, -8.0)
	p._release_arrow()
	await process_frame
	var spawned := root_arrows.get_child_count()
	var frames := 0
	while root_arrows.get_child_count() > 0 and frames < 240:
		await process_frame
		frames += 1
	var left := root_arrows.get_child_count()
	_note(id, "arrow spawned=%d, despawned after %d frames with no target, arrows left=%d (range %.1f m)"
		% [spawned, frames, left, SpikeConfig.ARROW_RANGE_M])
	# BOTH paths are exercised. Asserting only the hit path would not be a check.
	var ok := spawned == 1 and left == 0 and frames > 0
	_reached(id)
	return ok

func c17() -> bool:
	var id := "C17_enemy_hit_precedes_death"
	var es: Array = main.get("enemies")
	var e: EnemySpike = null
	for x in es:
		if is_instance_valid(x) and x.state != EnemySpike.State.DEAD and x.died_at_frame < 0:
			e = x
			break
	e.global_position = Vector3(14.0, 0, 14.0)   # out of the way
	e.take_hit(10.0, e.global_position)          # a NON-fatal hit first
	await process_frame
	var hit_frame := e.took_hit_at_frame
	var died_before_hit := e.died_at_frame >= 0
	e.take_hit(9999.0, e.global_position)        # now the fatal one
	await process_frame
	var death_frame := e.died_at_frame
	_note(id, "first (non-fatal) hit at physics frame %d; death at %d; any death before a hit=%s"
		% [hit_frame, death_frame, str(died_before_hit)])
	# The hit must be proved to have FIRED, and to have come first.
	var ok := hit_frame > 0 and not died_before_hit and death_frame >= hit_frame
	_reached(id)
	return ok

func c18() -> bool:
	var id := "C18_loot_only_after_death"
	var loot_root: Node3D = main.get("loot_root")
	var es: Array = main.get("enemies")
	var e: EnemySpike = null
	for x in es:
		if is_instance_valid(x) and x.state != EnemySpike.State.DEAD and x.loot_spawned_at_frame < 0:
			e = x
			break
	e.global_position = Vector3(-14.0, 0, -14.0)
	var loot_before := loot_root.get_child_count()
	# ZERO BEFORE is the half that makes this a real check.
	e.take_hit(1.0, e.global_position)
	for i in 10:
		await process_frame
	var loot_after_hit_only := loot_root.get_child_count()
	e.take_hit(9999.0, e.global_position)
	var frames := 0
	while e.state != EnemySpike.State.DEAD and frames < 300:
		await process_frame
		frames += 1
	for i in 5:
		await process_frame
	var loot_after_death := loot_root.get_child_count()
	_note(id, "loot before=%d, after a non-fatal hit=%d, after death=%d (death took %d frames); loot frame=%d death frame=%d"
		% [loot_before, loot_after_hit_only, loot_after_death, frames,
		   e.loot_spawned_at_frame, e.died_at_frame])
	var ok := loot_after_hit_only == loot_before \
		and loot_after_death == loot_before + 1 \
		and e.loot_spawned_at_frame >= e.died_at_frame
	_reached(id)
	return ok

func c19() -> bool:
	var id := "C19_normal_encounter_is_six"
	main.set_density_mode(false)
	for i in 6:
		await process_frame
	var es: Array = main.get("enemies")
	var passive_count := 0
	for e in es:
		if e.passive:
			passive_count += 1
	_note(id, "normal encounter spawned %d enemies (want %d); passive among them=%d; mode='%s'"
		% [es.size(), SpikeConfig.ENEMY_COUNT_NORMAL, passive_count, str(main.get("mode_name"))])
	var ok := es.size() == SpikeConfig.ENEMY_COUNT_NORMAL and passive_count == 0
	_reached(id)
	return ok

func c20() -> bool:
	var id := "C20_density_mode_is_24_and_passive"
	main.set_density_mode(true)
	for i in 30:
		await process_frame
	var es: Array = main.get("enemies")
	var passive_count := 0
	var moved := 0
	var before: Array[Vector3] = []
	for e in es:
		before.append(e.global_position)
		if e.passive:
			passive_count += 1
	for i in 40:
		await process_frame
	for i in range(es.size()):
		if before[i].distance_to(es[i].global_position) > 0.02:
			moved += 1
	_note(id, "density mode spawned %d enemies (want %d); passive=%d; enemies that moved over 40 frames=%d (want 0)"
		% [es.size(), SpikeConfig.ENEMY_COUNT_DENSITY, passive_count, moved])
	# "Passive" is asserted BEHAVIOURALLY, not just by the flag.
	var ok := es.size() == SpikeConfig.ENEMY_COUNT_DENSITY \
		and passive_count == SpikeConfig.ENEMY_COUNT_DENSITY and moved == 0
	main.set_density_mode(false)
	for i in 6:
		await process_frame
	_reached(id)
	return ok

func c21() -> bool:
	var id := "C21_provisional_labels_in_runtime_and_code"
	var hud: SpikeHUD = main.get("hud")
	var text := ""
	for c in hud.get_children():
		if c is Label:
			text += (c as Label).text + "\n"
	var on_screen := text.findn("PROVISIONAL") >= 0 \
		and text.findn("NOT** A PRODUCT LOCK") >= 0
	var in_code := FileAccess.get_file_as_string("res://scripts/spike_config.gd")
	var code_says := in_code.findn("EVERY NUMBER IN THIS FILE IS PROVISIONAL") >= 0 \
		and in_code.findn("TOP_SPEED_IS_PROVISIONAL") >= 0
	_note(id, "on-screen provisional labelling=%s ; in-code provisional labelling=%s"
		% [str(on_screen), str(code_says)])
	# BOTH surfaces are required. One without the other is a FAIL.
	var ok := on_screen and code_says
	_reached(id)
	return ok

func c22() -> bool:
	var id := "C22_top_speed_re_evaluated_not_inherited"
	var hud: SpikeHUD = main.get("hud")
	var text := ""
	for c in hud.get_children():
		if c is Label:
			text += (c as Label).text + "\n"
	var shows_reeval := text.findn("RE-EVALUATED, NOT INHERITED") >= 0 \
		and text.findn("Framing-matched equivalent") >= 0 \
		and text.findn("OPEN OWNER JUDGMENT") >= 0
	var cam: IsoCamera = main.get("cam")
	var view_w: float = cam.size * 16.0 / 9.0
	var ratio: float = SpikeConfig.CF_2D_LOCKED_WIDTH_M / view_w
	_note(id, "top speed %.2f m/s, PROVISIONAL=%s; 2D footprint %.2f m vs spike view %.3f m => %.3fx perceived; framing-matched %.3f m/s; on-screen re-evaluation=%s"
		% [SpikeConfig.TOP_SPEED_MPS, str(SpikeConfig.TOP_SPEED_IS_PROVISIONAL),
		   SpikeConfig.CF_2D_LOCKED_WIDTH_M, view_w, ratio,
		   SpikeConfig.TOP_SPEED_2D_PROTOTYPE_MPS / ratio, str(shows_reeval)])
	var ok := SpikeConfig.TOP_SPEED_IS_PROVISIONAL and shows_reeval
	_reached(id)
	return ok

func c23() -> bool:
	var id := "C23_truthfulness_denials_present"
	var hud: SpikeHUD = main.get("hud")
	var text := ""
	for c in hud.get_children():
		if c is Label:
			text += (c as Label).text + "\n"
	var want := ["NOT production", "NOT P2", "NOT a completed pivot",
		"NOT the final Huntress", "NOT final art", "NOT acceptance of this asset style"]
	var absent: Array[String] = []
	for w in want:
		if text.findn(w) < 0:
			absent.append(w)
	# PROVE THE CHECK CAN FAIL: a denial that is not present must be detected.
	var control_detected := text.findn("NOT a banana sandwich") < 0
	_note(id, "%d required denials on screen, %d absent: %s; negative control detected=%s"
		% [want.size(), absent.size(), str(absent), str(control_detected)])
	var ok := absent.is_empty() and control_detected
	_reached(id)
	return ok

func c24() -> bool:
	var id := "C24_no_2d_lock_promoted"
	var cfg := FileAccess.get_file_as_string("res://scripts/spike_config.gd")
	# The 2D locks may be QUOTED for comparison, but the file must say plainly
	# that they are NOT promoted -- and no 2D lock may be used as a 3D constant.
	var says_not_promoted := cfg.findn("NO 2D MEASUREMENT IS INHERITED AS A LOCK") >= 0 \
		and cfg.findn("belong to `game2d/` and are NOT promoted here") >= 0
	var cam: IsoCamera = main.get("cam")
	var view_w: float = SpikeConfig.CAM_SIZE_DEFAULT * 16.0 / 9.0
	# The spike's own framing must NOT be the 2D locked footprint.
	var not_same := absf(view_w - SpikeConfig.CF_2D_LOCKED_WIDTH_M) > 0.5 \
		and absf(SpikeConfig.CAM_SIZE_DEFAULT - 18.0) > 0.5
	_note(id, "config states no promotion=%s; spike default framing %.3f x %.2f m is distinct from the 2D locked 32.00 x 18.00 m=%s"
		% [str(says_not_promoted), view_w, SpikeConfig.CAM_SIZE_DEFAULT, str(not_same)])
	var ok := says_not_promoted and not_same
	_reached(id)
	return ok

func c25() -> bool:
	var id := "C25_test_seam_disabled_in_normal_play"
	var cam: IsoCamera = main.get("cam")
	var clear := cam.debug_cursor_override == null
	_note(id, "camera debug_cursor_override is null after the suite's use=%s" % str(clear))
	var ok := clear
	_reached(id)
	return ok

# ---------------------------------------------------------------- report ----

func _all_ok() -> bool:
	for id in OWED:
		if not reached.has(id) or results.get(id, false) != true:
			return false
	return reached.size() == OWED.size()

func _report() -> void:
	print("")
	print("------------------------------------------------------------------------")
	print("RESULTS")
	print("------------------------------------------------------------------------")
	var passed := 0
	var failed := 0
	for id in OWED:
		var r = results.get(id, null)
		var state := "FAIL"
		if not reached.has(id):
			state = "UNREACHED"
		elif r == true:
			state = "PASS"
			passed += 1
		if state != "PASS":
			failed += 1
		print("  [%-9s] %s" % [state, id])
		if notes.has(id):
			print("               %s" % notes[id])

	print("")
	print("DEFERRED / TRANSFERRED — recorded as such, NEVER as passes:")
	for row in DEFERRED_ROWS:
		print("  [DEFERRED ] %s" % row[0])
		print("               %s" % row[1])

	# OWED vs REACHED, IN BOTH DIRECTIONS.
	var owed_not_reached: Array[String] = []
	for id in OWED:
		if not reached.has(id):
			owed_not_reached.append(id)
	var reached_not_owed: Array[String] = []
	for id in reached.keys():
		if not OWED.has(id):
			reached_not_owed.append(id)

	print("")
	print("OWED vs REACHED (both directions):")
	print("  owed=%d  reached=%d  owed-but-not-reached=%d %s  reached-but-not-owed=%d %s"
		% [OWED.size(), reached.size(), owed_not_reached.size(),
		   str(owed_not_reached), reached_not_owed.size(), str(reached_not_owed)])

	print("")
	print("ANIMATION LIMITATIONS MEASURED IN THE THIRD-PARTY LIBRARY:")
	for l in SpikeConfig.ANIM_LIMITATIONS:
		print("  %s" % l)

	print("")
	print("TOP SPEED: %.2f m/s REMAINS PROVISIONAL — re-evaluated, not inherited."
		% SpikeConfig.TOP_SPEED_MPS)
	print("OUTPUT %d x %d IS A COMPARISON OUTPUT, NOT A PRODUCT LOCK."
		% [SpikeConfig.OUTPUT_WIDTH, SpikeConfig.OUTPUT_HEIGHT])
	print("")
	var verdict := "PASS" if _all_ok() else "FAIL"
	print("SPIKE VERIFICATION: %s (%d checks: %d passed, %d failed/unreached, %d deferred)"
		% [verdict, OWED.size(), passed, failed, DEFERRED_ROWS.size()])
	print("THIS IS A FEASIBILITY SPIKE RESULT. It accepts no visual direction,")
	print("completes no phase, and does not authorize P2 or a production pivot.")
	print("STATE: 3D feasibility spike %s" % SpikeConfig.SPIKE_STATE)
	print("------------------------------------------------------------------------")
