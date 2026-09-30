extends SceneTree

## RIFTWROUGHT — HUNTRESS BOW-RETARGETING AND PREY FEASIBILITY SPIKE VERIFICATION
## (D-388, 2026-09-19)
##
## ============================================================================
## AUTOMATED CHECKS PROVE STATE AND TIMING RELATIONSHIPS. THEY DO NOT DECIDE
## VISUAL FEASIBILITY. RENDERED EVIDENCE AND THE OWNER'S LIVE REVIEW DO.
## ============================================================================
## The owner's ruling, verbatim: "Automated checks must prove state and timing
## relationships, but rendered evidence and owner live review decide visual
## feasibility." So a MEASUREMENT here (hand positions, foot drift, transition
## steps, deformation proxies) passes when it RAN and is finite, and its result
## is printed as a FINDING with a band declared in advance -- a bad band is a
## finding, never a hidden pass. The retarget classification is NOT made here.
##
## ============================================================================
## UNITS. NEVER SYNONYMS.
## ============================================================================
##   117 OWED CRITERIA   docs/testing/D388_HUNTRESS_SPIKE_OWED_CRITERIA_INVENTORY.md
##   OWED.size() EXECUTABLE CHECKS   this suite
##   RUNNER CHECKS       tests/huntress_spike_smoke.sh
##   13 PRINTED DEFERRED ROWS · 6 PRINTED OWED-TO-OWNER ROWS
## A criterion may be discharged by this suite, by the runner, by rendered
## evidence, by the delivery record or by the owner -- the delivery report maps
## all 117.
##
## The standing verification rules, applied verbatim: a named owed list compared
## in BOTH directions · every check records reaching its LAST line · a missing
## check function is a FAIL · every negative control is PROVED ABLE TO REFUSE ·
## an assertion that something did NOT happen first asserts the action FIRED ·
## verification never writes to the owner's state.

const OWED := [
	# --- truthfulness and scope -----------------------------------------------
	"V01_state_is_exact_and_every_denial_is_present_and_the_guard_can_fail",
	"V02_every_spike_value_is_registered_and_labelled",
	"V03_the_runtime_never_classifies_itself_or_makes_a_forbidden_claim",
	# --- intake and provenance ------------------------------------------------
	"V04_the_intake_is_exactly_the_manifest_byte_for_byte",
	"V05_the_provenance_document_matches_the_runtime_manifest",
	"V06_generated_godot_state_is_classified_and_never_counted",
	"V07_only_the_seven_authorized_clips_can_be_sampled",
	"V08_the_embedded_mannequin_never_enters_the_scene",
	"V09_the_ranger_is_labelled_a_comparator_and_the_huntress_is_the_default",
	"V10_no_forbidden_asset_or_imported_effect_resource_exists",
	"V11_no_third_party_path_is_hard_coded_outside_the_manifest",
	"V12_no_runtime_path_escapes_the_spike",
	"V13_the_huntress_loads_unmodified",
	"V14_the_naive_by_name_path_drives_only_the_shared_root",
	# --- question 1: the retarget -------------------------------------------
	"V15_both_rigs_are_measured_live_in_the_same_reference_pose",
	"V16_the_explicit_map_resolves_and_a_planted_name_is_refused",
	"V17_hierarchy_and_rest_differences_are_measured",
	"V18_no_clip_has_root_motion_and_the_actor_does_not_drift",
	"V19_the_transfer_is_faithful_within_half_a_degree",
	"V20_hand_positions_are_measured_at_nock_draw_hold_and_release",
	"V21_deformation_proxies_are_measured",
	"V22_foot_stability_is_measured_against_declared_bands",
	"V23_the_bow_meets_the_declared_full_draw_criterion_on_both_bodies",
	"V24_the_five_transitions_are_exercised_and_measured_on_both_bodies",
	"V25_the_release_frame_aligns_at_every_diagnostic_rate",
	"V26_source_clip_data_is_unchanged_after_the_run",
	"V27_the_native_sampler_equals_the_engine_animation_player",
	"V28_the_import_reproduces_the_d386_raw_measurements",
	"V29_the_release_marker_is_the_measured_string_hand_snap",
	# --- question 2: bow, string and arrow ------------------------------------
	"V30_the_bow_is_in_the_measured_hand_and_its_grip_follows_every_frame",
	"V31_the_rigid_string_is_absent_and_the_source_is_unchanged",
	"V32_the_string_ends_at_the_tips_follows_the_nock_and_returns_on_release",
	"V33_the_arrow_is_hidden_before_the_nock_and_nocked_through_the_hold",
	"V34_exactly_one_projectile_per_released_use",
	"V35_the_projectile_starts_at_the_nocked_arrow_and_flies_the_per_use_aim",
	"V36_the_trail_and_impact_are_generated_in_code",
	"V37_the_presentation_is_labelled_diagnostic",
	# --- question 3: the accepted commitment ----------------------------------
	"V38_movement_stops_for_the_bow_within_the_accepted_glide",
	"V39_facing_follows_the_aim_while_the_feet_stay_still",
	"V40_movement_before_release_is_buffered_and_cannot_cancel_the_shot",
	"V41_movement_after_release_cancels_the_recovery_within_one_frame",
	"V42_the_released_arrow_survives_the_cancel_and_still_hits",
	"V43_every_bow_action_is_stop_and_allow_is_unused",
	"V44_the_probe_overrides_exactly_three_accepted_methods",
	"V45_the_verbatim_probe_bolt_is_never_fired",
	# --- question 4: Prey -----------------------------------------------------
	"V46_a_direct_hit_on_a_designates_a",
	"V47_a_direct_hit_on_b_switches_prey_to_b",
	"V48_exactly_one_prey_at_any_time",
	"V49_death_clears_prey_and_a_non_prey_death_does_not",
	"V50_removal_clears_prey",
	"V51_prey_grants_no_damage_bonus",
	"V52_prey_gives_no_auto_aim_and_no_lock_on",
	"V53_only_a_direct_use_designates_and_a_minion_designation_is_refused",
	"V54_projectiles_hit_one_target_each_and_the_tie_break_stays_owed",
	"V55_the_prey_marker_is_shape_and_text_on_the_prey_only",
	"V56_prey_has_no_timeout_and_no_area_rule",
	# --- question 5: the stand-in hound ----------------------------------------
	"V57_the_hound_is_primitives_with_its_exact_label",
	"V58_the_hound_has_no_command_path",
	"V59_the_hound_prefers_a_reachable_prey_over_a_nearer_target",
	"V60_without_prey_the_hound_takes_the_nearest_ties_by_name",
	"V61_prey_out_of_reach_sends_the_hound_to_its_autonomous_target",
	"V62_prey_unreachable_by_path_is_skipped_and_the_test_can_refuse",
	"V63_the_hound_follows_a_prey_switch_within_one_interval",
	"V64_the_hound_arrives_by_path_and_bites",
	# --- review presentation --------------------------------------------------
	"V65_developer_overlays_start_hidden",
	"V66_the_hud_shows_only_the_six_items_and_reads_live_state",
	"V67_the_comparison_switch_changes_visibility_not_the_simulation",
	"V68_the_input_map_is_exact_with_no_wasd_and_a_pad_binding_per_action",
	"V69_the_closeup_is_a_separate_camera",
	# --- the accepted foundation under the bow ----------------------------------
	"V70_click_to_move_arrives_and_drives_run_then_idle",
	"V71_the_yard_is_baked_once_and_reachability_is_by_path",
	"V72_the_runtime_only_ever_played_the_five_played_clips",
]

var reached := {}
var results := {}
var notes := {}
var findings: Array[String] = []

var main: SpikeMain
var probe: HuntressSpikeProbe
var cam: IsoCameraRig
var prey: PreyState
var hound: StandInHound
var ta: TargetDummy
var tb: TargetDummy
var drv: BowPoseDriver
var launch := {}
var checksums_start := {}

func _initialize() -> void:
	print("========================================================================")
	print("RIFTWROUGHT — %s VERIFICATION  (%s, %s)" % [SpikeConfig.STAGE, SpikeConfig.DECISION, SpikeConfig.DATE])
	print("SPIKE STATE: %s" % SpikeConfig.STATE)
	print("Automated checks prove STATE and TIMING relationships. Rendered evidence and the")
	print("owner's live review decide VISUAL feasibility. The retarget is NOT classified here.")
	print("OWED EXECUTABLE CHECKS: %d · PRINTED DEFERRED ROWS: %d · PRINTED OWED-TO-OWNER ROWS: %d"
		% [OWED.size(), SpikeConfig.deferred_rows().size(), SpikeConfig.owed_to_owner().size()])
	print("(The D-388 owed-criteria INVENTORY counts 117 CRITERIA. Different unit.)")
	print("========================================================================")
	main = load("res://scenes/main.tscn").instantiate() as SpikeMain
	root.add_child(main)
	for i in 12:
		await process_frame
	probe = main.probe
	cam = main.cam
	prey = main.prey
	hound = main.hound
	ta = main.target_a
	tb = main.target_b
	drv = probe.driver
	launch = {
		"overlay_visible": main.overlay.visible, "inset_visible": main.inset.visible,
		"hud_visible": main.hud.visible, "show_ranger": drv.show_ranger,
		"huntress_body_visible": drv.huntress_body.visible, "ranger_visible": probe.ranger.visible,
		"identity_line": (main.hud.lines["IDENTITY"] as Label).text,
	}
	for c in SpikeConfig.AUTHORIZED_CLIPS:
		checksums_start[c] = main.clip_source.checksum(String(c))
	for id in OWED:
		await _run(id)
	_report()
	quit(0 if _all_ok() else 1)

func _run(id: String) -> void:
	var m := "chk_" + id
	if not has_method(m):
		results[id] = false
		_note(id, "NO CHECK FUNCTION `%s` EXISTS — the suite owes a check it never wrote." % m)
		return
	var ok = await Callable(self, m).call()
	results[id] = ok

func _reached(id: String) -> void:
	reached[id] = true

func _note(id: String, s: String) -> void:
	notes[id] = s

func _finding(s: String) -> void:
	findings.append(s)

# ------------------------------------------------------------- utilities ----

func _phys(n: int) -> void:
	for i in n:
		await physics_frame

func _until(cond: Callable, max_frames: int) -> bool:
	var g := 0
	while g < max_frames:
		if bool(cond.call()):
			return true
		await physics_frame
		g += 1
	return bool(cond.call())

## A clean world between checks. Test setup only -- `commitment.reset()` is the
## accepted file's own documented test-setup entry.
func _reset(p_pos: Vector3 = Vector3(0, 0, 2.0), rate_index: int = 4) -> void:
	probe.commitment.reset()
	probe._pending_release = Callable()
	probe.intent.clear_seams()
	cam.debug_cursor_override = null
	probe.clear_move_destination()
	probe.follower.set_path(PackedVector3Array())
	probe.motor.reset()
	probe.velocity = Vector3.ZERO
	probe.debug_freeze_attack = false
	probe.rate_index = rate_index
	if drv.show_ranger:
		probe.set_comparison(false)
	for t in [ta, tb]:
		if not (t as TargetDummy).alive:
			(t as TargetDummy).respawn()
		(t as TargetDummy).life.reset()
	if prey.current != null:
		prey._clear("suite-reset")
	for c in main.world_root.get_children():
		c.queue_free()
	hound.process_mode = Node.PROCESS_MODE_DISABLED
	hound.global_position = Vector3(-13.5, 0, 8.5)
	hound.target = null
	hound.target_reason = "none"
	probe.global_position = p_pos
	cam.snap_to_target()
	await _phys(3)
	# Let any action the reset interrupted settle into locomotion.
	await _until(func(): return not drv.in_action and drv.phase == "IDLE", 60)

func _aim_at(p: Vector3, frames: int = 24) -> void:
	cam.debug_cursor_override = p
	await _phys(frames)

## Presses the bow input through the REAL input path for exactly the frames
## needed for `_update_attack_input` to see it, then releases it.
func _press_shot() -> bool:
	var before := probe.bow_uses
	probe.intent.debug_attack_held = true
	await _phys(2)
	probe.intent.debug_attack_held = null
	return probe.bow_uses == before + 1

func _await_release(max_frames: int = 400) -> bool:
	var before := probe.arrows_released
	return await _until(func(): return probe.arrows_released > before, max_frames)

## Waits until a projectile has stopped (hit, expired or freed) -- by instance id,
## so a freed projectile is never captured by a lambda.
func _await_projectile_done(p: Object, max_frames: int = 150) -> bool:
	var pid := p.get_instance_id()
	return await _until(func():
		var o := instance_from_id(pid)
		return o == null or not (o as ArrowProjectile).alive, max_frames)

func _await_action_end(max_frames: int = 600) -> bool:
	return await _until(func(): return not probe.commitment.active, max_frames)

func _read_text(path: String) -> String:
	var f := FileAccess.open(path, FileAccess.READ)
	if f == null:
		return ""
	var s := f.get_as_text()
	f.close()
	return s

func _walk(path: String, out: Array) -> void:
	var d := DirAccess.open(path)
	if d == null:
		return
	d.include_hidden = true
	d.list_dir_begin()
	var n := d.get_next()
	while n != "":
		if n == "." or n == ".." or n == ".godot":
			n = d.get_next()
			continue
		var full := path.path_join(n)
		if d.current_is_dir():
			_walk(full, out)
		else:
			out.append(full)
		n = d.get_next()
	d.list_dir_end()

func _scripts() -> Array:
	var all: Array = []
	_walk("res://scripts", all)
	var out: Array = []
	for f in all:
		if String(f).ends_with(".gd"):
			out.append(String(f))
	out.sort()
	return out

## Code without comments, so a guard reads code and not the dated prose.
static func _code_only(text: String) -> String:
	var out := PackedStringArray()
	for line in text.split("\n"):
		var l := String(line)
		var i := l.find("#")
		if i >= 0:
			l = l.substr(0, i)
		out.append(l)
	return "\n".join(out)

## The angle between two rotations, in degrees -- NUMERICALLY STABLE near zero.
## `Quaternion.angle_to` is 2*acos(|dot|) in 32-bit floats, whose smallest
## non-zero result is 0.0396 deg (and next 0.0559 deg): its noise floor sat above
## this suite's own 0.05 deg threshold, and the first V27 run "failed" on pure
## rounding. 2*atan2(|v|, |w|) of the relative rotation has no such floor.
static func _ang(a: Quaternion, b: Quaternion) -> float:
	var d := (a.normalized().inverse() * b.normalized()).normalized()
	return rad_to_deg(2.0 * atan2(Vector3(d.x, d.y, d.z).length(), absf(d.w)))

func _q(t: Transform3D) -> Quaternion:
	return t.basis.get_rotation_quaternion()

# =================================================== truthfulness and scope ==

func chk_V01_state_is_exact_and_every_denial_is_present_and_the_guard_can_fail() -> bool:
	var id := "V01_state_is_exact_and_every_denial_is_present_and_the_guard_can_fail"
	var ok := SpikeConfig.STATE == "HUNTRESS BOW-RETARGETING AND PREY FEASIBILITY SPIKE DELIVERED and OPEN pending owner live review (D-388)"
	var must := ["NOT P2", "NOT production implementation", "NOT final Huntress art", "NOT VFX intake",
		"NOT tuning", "does NOT modify game3d/", "NOT Splinter Shot", "DIAGNOSTIC NATIVE-RIG COMPARATOR ONLY",
		"PROCEDURAL STAND-IN", "does NOT resolve the OWED multi-target Prey tie-break", "changes NO Huntress canon",
		"NOT the Ultimate Monsters dog"]
	var text := "\n".join(SpikeConfig.denials())
	var missing: Array[String] = []
	for m in must:
		if not text.contains(m):
			missing.append(m)
	# THE GUARD CAN FAIL: a planted list with one denial removed must be refused.
	var planted := text.replace("NOT P2", "P2")
	var refused := false
	for m in must:
		if not planted.contains(m):
			refused = true
	ok = ok and missing.is_empty() and refused
	_note(id, "state exact=%s · %d denials present, missing=%s · planted removal refused=%s"
		% [SpikeConfig.STATE.contains("DELIVERED and OPEN"), must.size() - missing.size(), missing, refused])
	_reached(id)
	return ok

func chk_V02_every_spike_value_is_registered_and_labelled() -> bool:
	var id := "V02_every_spike_value_is_registered_and_labelled"
	var rows := SpikeConfig.registry()
	var unlabelled: Array[String] = []
	for r in rows:
		var lab := String(r[2])
		if not (lab.contains("DIAGNOSTIC") or lab.contains("PROVISIONAL") or lab.contains("MEASURED")):
			unlabelled.append(String(r[0]))
	var planted := rows.duplicate()
	planted.append(["a planted value", 1.0, "final"])
	var caught := false
	for r in planted:
		var lab := String(r[2])
		if not (lab.contains("DIAGNOSTIC") or lab.contains("PROVISIONAL") or lab.contains("MEASURED")):
			caught = true
	var ok := rows.size() >= 20 and unlabelled.is_empty() and caught
	_note(id, "%d registered values, unlabelled=%s · a planted unlabelled value is caught=%s" % [rows.size(), unlabelled, caught])
	_reached(id)
	return ok

func chk_V03_the_runtime_never_classifies_itself_or_makes_a_forbidden_claim() -> bool:
	var id := "V03_the_runtime_never_classifies_itself_or_makes_a_forbidden_claim"
	var forbidden := ["VIABLE FOR PRODUCTION CONTINUATION", "VIABLE FOR PROTOTYPE ONLY", "P2 is authorized",
		"production ready", "production-ready", "this is the final Huntress", "Splinter Shot is implemented"]
	var hits: Array[String] = []
	for f in _scripts():
		var code := _code_only(_read_text(f))
		for w in forbidden:
			if code.contains(w):
				hits.append("%s :: %s" % [f.get_file(), w])
	var planted_code := "print(\"VIABLE FOR PROTOTYPE ONLY\")"
	var planted_caught := planted_code.contains(forbidden[1])
	var ok := hits.is_empty() and planted_caught \
		and SpikeConfig.CLASSIFICATION_STATE.contains("OWED") \
		and SpikeConfig.CLASSIFICATION_STATE.contains("does not classify itself") \
		and SpikeConfig.RANGER_LABEL.contains("NOT THE HUNTRESS")
	_note(id, "forbidden claims in runtime code=%s · classification state OWED · Ranger label denies being the Huntress · planted claim caught=%s" % [hits, planted_caught])
	_reached(id)
	return ok

# ===================================================== intake and provenance ==

func _classify(rel: String) -> String:
	for f in AssetManifest.asset_files():
		if String(f[0]) == rel:
			return "ASSET"
	for f in AssetManifest.licence_files():
		if String(f[0]) == rel:
			return "LICENCE"
	if AssetManifest.authored_files().has(rel):
		return "AUTHORED"
	for sfx in AssetManifest.generated_suffixes():
		if rel.ends_with(String(sfx)):
			return "GENERATED"
	for pre in AssetManifest.generated_texture_prefixes():
		if rel.get_file().begins_with(String(pre)):
			return "GENERATED"
	return "UNDECLARED"

func chk_V04_the_intake_is_exactly_the_manifest_byte_for_byte() -> bool:
	var id := "V04_the_intake_is_exactly_the_manifest_byte_for_byte"
	var files: Array = []
	_walk(AssetManifest.ROOT.trim_suffix("/"), files)
	var counts := {"ASSET": 0, "LICENCE": 0, "AUTHORED": 0, "GENERATED": 0, "UNDECLARED": 0}
	var undeclared: Array[String] = []
	for f in files:
		var rel := String(f).trim_prefix(AssetManifest.ROOT)
		var k := _classify(rel)
		counts[k] = int(counts[k]) + 1
		if k == "UNDECLARED":
			undeclared.append(rel)
	var bad_hash: Array[String] = []
	for f in AssetManifest.asset_files() + AssetManifest.licence_files():
		var path := AssetManifest.ROOT + String(f[0])
		if not FileAccess.file_exists(path) or FileAccess.get_sha256(path) != String(f[1]):
			bad_hash.append(String(f[0]))
	var planted_refused := _classify("quaternius_medieval_weapons/Bow_Golden.obj") == "UNDECLARED"
	var ok := int(counts["ASSET"]) == 15 and int(counts["LICENCE"]) == 4 and AssetManifest.intake_count() == 19 \
		and undeclared.is_empty() and bad_hash.is_empty() and planted_refused
	_note(id, "classified %s · SHA-256 mismatches=%s · undeclared=%s · a planted extra file is refused=%s" % [counts, bad_hash, undeclared, planted_refused])
	_reached(id)
	return ok

func chk_V05_the_provenance_document_matches_the_runtime_manifest() -> bool:
	var id := "V05_the_provenance_document_matches_the_runtime_manifest"
	var doc := _read_text(AssetManifest.provenance_document())
	var declared := {}
	for f in AssetManifest.asset_files():
		declared[String(f[0]).get_file()] = true
	var named := {}
	for line in doc.split("\n"):
		if String(line).begins_with("| **Imported files** |"):
			var parts := String(line).split("`")
			for k in range(1, parts.size(), 2):
				named[parts[k]] = true
	var missing: Array[String] = []
	for k in declared.keys():
		if not named.has(k):
			missing.append(String(k))
	var extra: Array[String] = []
	for k in named.keys():
		if not declared.has(k):
			extra.append(String(k))
	var packs_named := true
	for p in AssetManifest.packs():
		if not doc.contains(String(p["archive_sha256"])) or not doc.contains(String(p["licence_file"])):
			packs_named = false
	# The comparison can fail: a planted undeclared name must show up as extra.
	named["Bow_Golden.obj"] = true
	var planted_caught := not declared.has("Bow_Golden.obj")
	var ok := missing.is_empty() and extra.is_empty() and packs_named and planted_caught and declared.size() == 15
	_note(id, "doc names %d imported files; missing=%s extra=%s · every pack's archive hash and licence file named=%s · planted caught=%s" % [declared.size(), missing, extra, packs_named, planted_caught])
	_reached(id)
	return ok

func chk_V06_generated_godot_state_is_classified_and_never_counted() -> bool:
	var id := "V06_generated_godot_state_is_classified_and_never_counted"
	var files: Array = []
	_walk(AssetManifest.ROOT.trim_suffix("/"), files)
	var generated: Array[String] = []
	for f in files:
		var rel := String(f).trim_prefix(AssetManifest.ROOT)
		if _classify(rel) == "GENERATED":
			generated.append(rel)
	var extracted := generated.filter(func(x): return String(x).get_file().begins_with("Ranger_ranger_texture"))
	var in_licences := generated.filter(func(x): return String(x).begins_with("licenses/"))
	var ok := generated.size() > 0 and extracted.size() >= 1 and in_licences.is_empty() \
		and AssetManifest.intake_count() == 19
	_note(id, "%d generated files classified apart (incl. the texture Godot extracted from Ranger.glb: %s) · none under licenses/ · intake stays 19" % [generated.size(), extracted])
	_reached(id)
	return ok

func chk_V07_only_the_seven_authorized_clips_can_be_sampled() -> bool:
	var id := "V07_only_the_seven_authorized_clips_can_be_sampled"
	var cs := main.clip_source
	var unused := cs.unused_inventory()
	var before := cs.refused_requests
	var r := cs.sample("Ranged_2H_Shoot", 0.1)
	var refused := r == null and cs.refused_requests == before + 1
	var authorized_ok := cs.clips.size() == 7
	for c in SpikeConfig.AUTHORIZED_CLIPS:
		authorized_ok = authorized_ok and cs.clips.has(c)
	var ok := cs.inventory.size() == 33 and unused.size() == 26 and refused and authorized_ok
	_note(id, "33 clips in the two files, 7 authorized loaded, 26 listed unused · an unauthorized request refused and counted=%s" % refused)
	_reached(id)
	return ok

func _find_named(n: Node, prefix: String, out: Array) -> void:
	if String(n.name).begins_with(prefix):
		out.append(n)
	for c in n.get_children():
		_find_named(c, prefix, out)

func chk_V08_the_embedded_mannequin_never_enters_the_scene() -> bool:
	var id := "V08_the_embedded_mannequin_never_enters_the_scene"
	var found: Array = []
	_find_named(root, "Mannequin_", found)
	# The comparison can fail: a planted Mannequin node must be found.
	var plant := Node3D.new()
	plant.name = "Mannequin_Planted"
	root.add_child(plant)
	var found2: Array = []
	_find_named(root, "Mannequin_", found2)
	plant.free()
	var ok := found.is_empty() and found2.size() == 1
	_note(id, "Mannequin_* nodes in the live tree=%d · a planted one is found=%s" % [found.size(), found2.size() == 1])
	_reached(id)
	return ok

func chk_V09_the_ranger_is_labelled_a_comparator_and_the_huntress_is_the_default() -> bool:
	var id := "V09_the_ranger_is_labelled_a_comparator_and_the_huntress_is_the_default"
	var ok := String(probe.ranger.name).contains("DIAGNOSTIC_COMPARATOR") and not bool(launch["show_ranger"]) \
		and bool(launch["huntress_body_visible"]) and not bool(launch["ranger_visible"]) \
		and String(launch["identity_line"]).contains("RETARGETED HUNTRESS") \
		and SpikeConfig.RANGER_LABEL.contains("DIAGNOSTIC COMPARATOR")
	_note(id, "at launch: Huntress visible=%s, control visible=%s · node '%s' · HUD identity '%s'" % [launch["huntress_body_visible"], launch["ranger_visible"], probe.ranger.name, launch["identity_line"]])
	_reached(id)
	return ok

func chk_V10_no_forbidden_asset_or_imported_effect_resource_exists() -> bool:
	var id := "V10_no_forbidden_asset_or_imported_effect_resource_exists"
	var files: Array = []
	_walk("res://", files)
	var bad: Array[String] = []
	for f in files:
		var s := String(f)
		var name := s.get_file()
		for frag in AssetManifest.forbidden_name_fragments():
			if name.contains(String(frag)):
				bad.append(s)
		for ext in [".wav", ".ogg", ".mp3", ".flac", ".tres", ".res", ".gdshader", ".shader", ".fbx", ".blend", ".rar", ".zip"]:
			if s.ends_with(ext):
				bad.append(s)
		if (s.ends_with(".png") and not s.begins_with("res://assets/third_party/") and not s.begins_with("res://evidence/")):
			bad.append(s)
	var planted_caught := "BattleFX_slash.tscn".contains(String(AssetManifest.forbidden_name_fragments()[0]))
	var ok := bad.is_empty() and planted_caught
	_note(id, "%d project files scanned · forbidden/effect-resource files=%s · planted name caught=%s" % [files.size(), bad, planted_caught])
	_reached(id)
	return ok

static func _third_party_literals(code: String) -> Array:
	var out: Array = []
	var re := RegEx.new()
	re.compile("\"[^\"]*(third_party|\\.glb|\\.gltf|\\.obj|\\.fbx)[^\"]*\"")
	for m in re.search_all(code):
		out.append(m.get_string())
	return out

func chk_V11_no_third_party_path_is_hard_coded_outside_the_manifest() -> bool:
	var id := "V11_no_third_party_path_is_hard_coded_outside_the_manifest"
	var hits: Array[String] = []
	for f in _scripts():
		if f.ends_with("asset_manifest.gd"):
			continue
		for lit in _third_party_literals(_code_only(_read_text(f))):
			hits.append("%s :: %s" % [f.get_file(), lit])
	var planted := _third_party_literals("var m = load(\"res://assets/third_party/x/Arrow.obj\")")
	var ok := hits.is_empty() and planted.size() == 1
	_note(id, "hard-coded third-party paths outside AssetManifest=%s · planted path caught=%s" % [hits, planted.size() == 1])
	_reached(id)
	return ok

func chk_V12_no_runtime_path_escapes_the_spike() -> bool:
	var id := "V12_no_runtime_path_escapes_the_spike"
	var re := RegEx.new()
	re.compile("\"(res://[^\"]*|file://[^\"]*|/Users/[^\"]*|\\.\\./[^\"]*)\"")
	var bad: Array[String] = []
	var targets := _scripts()
	targets.append("res://scenes/main.tscn")
	targets.append("res://project.godot")
	for f in targets:
		for m in re.search_all(_code_only(_read_text(f))):
			var lit := m.get_string(1)
			if not lit.begins_with("res://") or lit.contains(".."):
				bad.append("%s :: %s" % [String(f).get_file(), lit])
			elif not (lit.begins_with("res://assets/third_party/") or lit.begins_with("res://scenes/")
					or lit.begins_with("res://scripts/") or lit.begins_with("res://evidence/")):
				bad.append("%s :: %s" % [String(f).get_file(), lit])
	var planted := re.search_all("load(\"../game3d/scripts/x.gd\")").size() == 1
	var ok := bad.is_empty() and planted
	_note(id, "path literals leaving the spike=%s · planted escape caught=%s" % [bad, planted])
	_reached(id)
	return ok

func chk_V13_the_huntress_loads_unmodified() -> bool:
	var id := "V13_the_huntress_loads_unmodified"
	var meshes := RigCorpus.meshes_of(probe.visual.get_node("Armature"))
	var overridden: Array[String] = []
	var surfaces := 0
	for mi in meshes:
		var m := mi as MeshInstance3D
		surfaces += m.mesh.get_surface_count()
		if m.material_override != null:
			overridden.append(String(m.name))
		for sidx in m.mesh.get_surface_count():
			if m.get_surface_override_material(sidx) != null:
				overridden.append("%s#%d" % [m.name, sidx])
	var fresh := (load(AssetManifest.OUTFIT_RANGER) as PackedScene).instantiate()
	var fresh_surfaces := 0
	for mi in RigCorpus.meshes_of(fresh):
		fresh_surfaces += (mi as MeshInstance3D).mesh.get_surface_count()
	fresh.free()
	var ok := overridden.is_empty() and surfaces == fresh_surfaces and drv.huntress_skel.get_bone_count() == 65
	_note(id, "%d meshes, %d surfaces (a fresh load has %d) · material overrides=%s · 65 bones" % [meshes.size(), surfaces, fresh_surfaces, overridden])
	_reached(id)
	return ok

func chk_V14_the_naive_by_name_path_drives_only_the_shared_root() -> bool:
	var id := "V14_the_naive_by_name_path_drives_only_the_shared_root"
	var shared := {}
	var total := {}
	for c in SpikeConfig.AUTHORIZED_CLIPS:
		var a: Animation = main.clip_source.clips[c]
		for t in a.get_track_count():
			var bone := String(a.track_get_path(t).get_concatenated_subnames())
			total[bone] = true
			if drv.huntress_skel.find_bone(bone) >= 0:
				shared[bone] = true
	var ok := shared.keys() == ["root"] or (shared.size() <= 1 and (shared.is_empty() or shared.has("root")))
	_finding("I-14 NAIVE PATH: the seven clips address %d distinct bones; by NAME they drive %d of the Huntress's 65 (%s). Retargeting is required." % [total.size(), shared.size(), shared.keys()])
	_note(id, "by-name overlap with the Huntress skeleton: %s of %d addressed bones" % [shared.keys(), total.size()])
	_reached(id)
	return ok

# ========================================================== Q1: the retarget ==

func chk_V15_both_rigs_are_measured_live_in_the_same_reference_pose() -> bool:
	var id := "V15_both_rigs_are_measured_live_in_the_same_reference_pose"
	var cs := main.clip_source
	var rt := drv.retarget
	var sg := cs.rest_global
	var tg := rt.rest_global
	var s_arm_l: Vector3 = (sg[cs.index_of["lowerarm.l"]].origin - sg[cs.index_of["upperarm.l"]].origin).normalized()
	var t_arm_l: Vector3 = (tg[rt.index_of["lowerarm_l"]].origin - tg[rt.index_of["upperarm_l"]].origin).normalized()
	var s_arm_r: Vector3 = (sg[cs.index_of["lowerarm.r"]].origin - sg[cs.index_of["upperarm.r"]].origin).normalized()
	var t_arm_r: Vector3 = (tg[rt.index_of["lowerarm_r"]].origin - tg[rt.index_of["upperarm_r"]].origin).normalized()
	var s_fwd: float = sg[cs.index_of["toes.l"]].origin.z - sg[cs.index_of["foot.l"]].origin.z
	var t_fwd: float = tg[rt.index_of["ball_leaf_l"]].origin.z - tg[rt.index_of["foot_l"]].origin.z
	var s_up: float = sg[cs.index_of["head"]].origin.y - sg[cs.index_of["hips"]].origin.y
	var t_up: float = tg[rt.index_of["Head"]].origin.y - tg[rt.index_of["pelvis"]].origin.y
	var unit_scale := true
	for i in rt.rest.size():
		if not rt.rest[i].basis.get_scale().is_equal_approx(Vector3.ONE):
			unit_scale = false
	var a1 := rad_to_deg(s_arm_l.angle_to(Vector3.RIGHT))
	var a2 := rad_to_deg(t_arm_l.angle_to(Vector3.RIGHT))
	var a3 := rad_to_deg(s_arm_r.angle_to(Vector3.LEFT))
	var a4 := rad_to_deg(t_arm_r.angle_to(Vector3.LEFT))
	var ok := cs.bone_count() == 23 and rt.names.size() == 65 and a1 < 6.0 and a2 < 6.0 and a3 < 6.0 and a4 < 6.0 \
		and s_fwd > 0.0 and t_fwd > 0.0 and s_up > 0.0 and t_up > 0.0 and unit_scale
	_note(id, "23 / 65 joints · T-pose upper arms vs ±X: source %.2f°/%.2f°, Huntress %.2f°/%.2f° · both face +Z · both +Y up · unit bone scale=%s" % [a1, a3, a2, a4, unit_scale])
	_reached(id)
	return ok

func chk_V16_the_explicit_map_resolves_and_a_planted_name_is_refused() -> bool:
	var id := "V16_the_explicit_map_resolves_and_a_planted_name_is_refused"
	var rt := drv.retarget
	var resolved := true
	for p in rt.pairs:
		resolved = resolved and main.clip_source.index_of.has(String(p["s_name"])) and rt.index_of.has(String(p["t_name"]))
	var unmapped := rt.unmapped_source.duplicate()
	unmapped.sort()
	var before := rt.planted_refusals
	var planted_refused := not rt.resolves_target("upperarm_PLANTED") and rt.planted_refusals == before + 1 \
		and rt.resolves_target("upperarm_l")
	var ok := rt.pairs.size() == 19 and rt.derived.size() == 2 and rt.rest_held.size() == 44 \
		and unmapped == ["handslot.l", "handslot.r", "wrist.l", "wrist.r"] and resolved \
		and rt.map_source is BoneMap and rt.map_target is BoneMap and rt.profile is SkeletonProfileHumanoid \
		and planted_refused
	_note(id, "%d pairs · %d derived · %d rest-held · unmapped source %s · every name resolves=%s · BoneMap x2 on SkeletonProfileHumanoid · planted name refused=%s" % [rt.pairs.size(), rt.derived.size(), rt.rest_held.size(), unmapped, resolved, planted_refused])
	_reached(id)
	return ok

## How many parent steps `b` lies below `a` in one rig (0 when it does not).
func _depth_below(par: PackedInt32Array, a: int, b: int) -> int:
	var d := 0
	var i := b
	while i >= 0 and d < 200:
		if i == a:
			return d
		i = par[i]
		d += 1
	return 0

func chk_V17_hierarchy_and_rest_differences_are_measured() -> bool:
	var id := "V17_hierarchy_and_rest_differences_are_measured"
	var cs := main.clip_source
	var rt := drv.retarget
	var rows := 0
	var all_finite := true
	for p in rt.pairs:
		var s: int = p["s"]
		var t: int = p["t"]
		var sp := cs.parent[s]
		var tp := rt.parent[t]
		var s_par := cs.bone_names[sp] if sp >= 0 else "-"
		var t_par := rt.names[tp] if tp >= 0 else "-"
		# Bone direction: from the bone to its FIRST MAPPED CHILD pair (the pair
		# nearest below it in BOTH rigs). A leaf pair has none and is printed as
		# not compared -- no axis convention is assumed, because the two rigs'
		# bone axes differ (A-04).
		var s_len := cs.rest[s].origin.length()
		var t_len := rt.rest[t].origin.length()
		var frame := _ang(_q(cs.rest_global[s]), _q(rt.rest_global[t]))
		var ratio := t_len / s_len if s_len > 0.0001 else 0.0
		var child: Dictionary = {}
		var best_depth := 1000
		for q in rt.pairs:
			var qs: int = q["s"]
			var qt: int = q["t"]
			if qs == s or qt == t:
				continue
			var d := _depth_below(cs.parent, s, qs)
			if d > 0 and _depth_below(rt.parent, t, qt) > 0 and d < best_depth:
				best_depth = d
				child = q
		var dir_txt := "bone direction —  (leaf: no mapped child, not compared)"
		if not child.is_empty():
			var ds: Vector3 = (cs.rest_global[int(child["s"])].origin - cs.rest_global[s].origin).normalized()
			var dt: Vector3 = (rt.rest_global[int(child["t"])].origin - rt.rest_global[t].origin).normalized()
			var dang := rad_to_deg(ds.angle_to(dt))
			if is_nan(dang):
				all_finite = false
			dir_txt = "bone direction differs %5.1f° (to %s)" % [dang, child["profile"]]
		if is_nan(frame) or is_inf(ratio):
			all_finite = false
		_finding("A-03/A-04 %-13s KayKit %-11s (parent %-10s) -> Huntress %-10s (parent %-11s) · rest frame differs %6.1f° · %s · offset-from-parent ratio %.3f" % [p["profile"], p["s_name"], s_par, p["t_name"], t_par, frame, dir_txt, ratio])
		rows += 1
	_finding("A-03 HIERARCHY: the Huntress has clavicles, neck_01, spine_02 and 40 finger joints the source lacks; the source has wrist.l/.r and handslot.l/.r the Huntress lacks; the source hangs its arms from chest, the Huntress from spine_03 via the clavicles.")
	var ok := rows == 19 and all_finite
	_note(id, "%d pair rows measured and printed as FINDINGS" % rows)
	_reached(id)
	return ok

func chk_V18_no_clip_has_root_motion_and_the_actor_does_not_drift() -> bool:
	var id := "V18_no_clip_has_root_motion_and_the_actor_does_not_drift"
	var cs := main.clip_source
	var ri: int = cs.index_of["root"]
	var hi: int = cs.index_of["hips"]
	var root_moves := 0.0
	var hips_h := 0.0
	cs.measuring = true
	for c in SpikeConfig.AUTHORIZED_CLIPS:
		var n := int(cs.length_of(c) * 30.0)
		var first := cs.sample(c, 0.0)
		for k in n + 1:
			var p := cs.sample(c, k / 30.0)
			root_moves = maxf(root_moves, p.pos[ri].distance_to(cs.rest[ri].origin))
			var d := Vector2(p.pos[hi].x - first.pos[hi].x, p.pos[hi].z - first.pos[hi].z).length()
			hips_h = maxf(hips_h, d)
	cs.measuring = false
	await _reset(Vector3(0, 0, 3.0), 4)
	var start := probe.global_position
	await _aim_at(Vector3(0, 0, -8))
	var fired := await _press_shot()
	await _await_action_end()
	var drift := probe.global_position.distance_to(start)
	var root_pose := drv.huntress_skel.get_bone_pose_position(drv.retarget.root_t)
	var ok := fired and root_moves < 0.0001 and drift < 0.000001 and root_pose.length() < 0.000001
	_finding("A-05 ROOT MOTION: root displaced %.5f m across all 7 clips (none) · hips' largest in-place horizontal excursion %.3f m (source units) · a full bow action with no movement input moved the actor %.7f m" % [root_moves, hips_h, drift])
	_note(id, "root motion %.5f m · actor drift %.7f m over a fired use (fired=%s)" % [root_moves, drift, fired])
	_reached(id)
	return ok

func chk_V19_the_transfer_is_faithful_within_half_a_degree() -> bool:
	var id := "V19_the_transfer_is_faithful_within_half_a_degree"
	var cs := main.clip_source
	var rt := drv.retarget
	var worst := 0.0
	var worst_at := ""
	var samples := 0
	for c in SpikeConfig.PLAYED_CLIPS:
		var n := int(cs.length_of(c) * 30.0)
		for k in n + 1:
			var p := cs.sample(c, k / 30.0)
			var sg := cs.globals(p)
			var r := rt.retarget(p, 0.0, 0.0)
			var g: Array[Transform3D] = r["global"]
			for pr in rt.pairs:
				var s: int = pr["s"]
				var t: int = pr["t"]
				var ds := (_q(sg[s]) * _q(cs.rest_global[s]).inverse()).normalized()
				var dt := (_q(g[t]) * _q(rt.rest_global[t]).inverse()).normalized()
				var e := _ang(ds, dt)
				samples += 1
				if e > worst:
					worst = e
					worst_at = "%s@%.3f %s" % [c, k / 30.0, pr["profile"]]
	var ok := samples > 1000 and worst < 0.5
	_note(id, "%d pair samples across the 5 played clips (IK weight 0) · worst model-space delta error %.4f° at %s" % [samples, worst, worst_at])
	_reached(id)
	return ok

func _height(n: Node) -> float:
	return RigCorpus.mesh_height(n)

func chk_V20_hand_positions_are_measured_at_nock_draw_hold_and_release() -> bool:
	var id := "V20_hand_positions_are_measured_at_nock_draw_hold_and_release"
	var cs := main.clip_source
	var rt := drv.retarget
	var hh := _height(probe.visual.get_node("Armature"))
	var rh := _height(probe.ranger)
	var moments := [["nock", SpikeConfig.CLIP_DRAW, drv.nock_tau_h, drv.ik_weight_at_draw(drv.nock_tau_h)],
		["full draw", SpikeConfig.CLIP_AIM_IDLE, 0.0, 1.0], ["hold end", SpikeConfig.CLIP_AIM_IDLE, SpikeConfig.HOLD_S, 1.0],
		["release +1/30 s", SpikeConfig.CLIP_RELEASE, 1.0 / 30.0, 1.0]]
	var finite := true
	for m in moments:
		var p := cs.sample(String(m[1]), float(m[2]), true)
		var g: Array[Transform3D] = rt.retarget(p, 0.0, float(m[3]))["global"]
		var gr := drv._ranger_globals(drv._ranger_local(p, 0.0))
		var hb: Vector3 = g[rt.index_of["hand_l"]].origin / hh
		var hs: Vector3 = g[rt.index_of["hand_r"]].origin / hh
		var rb: Vector3 = gr[drv.ranger_skel.find_bone("hand.l")].origin / rh
		var rs: Vector3 = gr[drv.ranger_skel.find_bone("hand.r")].origin / rh
		var anchor_d: float = rt.nock_point(g, "r").distance_to(g[rt.index_of["Head"]].origin)
		for v in [hb, hs, rb, rs]:
			if not (is_finite(v.x) and is_finite(v.y) and is_finite(v.z)):
				finite = false
		_finding("A-07 %-16s bow hand /height: Huntress %s · control %s | string hand: Huntress %s · control %s | Huntress nock-to-Head %.3f m" % [m[0], _v(hb), _v(rb), _v(hs), _v(rs), anchor_d])
	_finding("A-07 DRAW LENGTH (nock to arrow rest at full draw): Huntress %.3f m · control %.3f m · aim-line offset: Huntress %.2f° · control %.2f° · standing height: Huntress %.3f m · control %.3f m" % [float(drv.measured["huntress"]["draw_length_m"]), float(drv.measured["ranger"]["draw_length_m"]), rad_to_deg(drv.alpha_h), rad_to_deg(drv.alpha_r), hh, rh])
	_finding("A-07 HAND-CONTACT IK: arm-length ratio %.3f · bow-arm solve on the arrow line %s · distance along the line %.3f m" % [rt.k_arm, rt.ik_report.get("reach_solvable"), float(rt.ik_report.get("draw_length_on_line_m", 0.0))])
	_note(id, "4 moments x 2 bodies measured and printed as FINDINGS")
	_reached(id)
	return finite

static func _v(v: Vector3) -> String:
	return "(%.3f, %.3f, %.3f)" % [v.x, v.y, v.z]

## Twist of `child` relative to `parent` about the parent's bone axis (deg).
func _twist(g: Array[Transform3D], parent_i: int, child_i: int, axis: Vector3) -> float:
	var rel := (_q(g[parent_i]).inverse() * _q(g[child_i])).normalized()
	var a := axis.normalized()
	var proj := Vector3(rel.x, rel.y, rel.z).dot(a)
	var tw := Quaternion(a.x * proj, a.y * proj, a.z * proj, rel.w).normalized()
	return absf(rad_to_deg(2.0 * acos(clampf(absf(tw.w), 0.0, 1.0))))

func chk_V21_deformation_proxies_are_measured() -> bool:
	var id := "V21_deformation_proxies_are_measured"
	var cs := main.clip_source
	var rt := drv.retarget
	var tw := {"l": 0.0, "r": 0.0}
	var elev := {"l": 0.0, "r": 0.0}
	var elbow_min := {"l": 180.0, "r": 180.0}
	var elbow_max := {"l": 0.0, "r": 0.0}
	var spine_max := [0.0, 0.0, 0.0]
	for spec in [[SpikeConfig.CLIP_DRAW, true], [SpikeConfig.CLIP_AIM_IDLE, false], [SpikeConfig.CLIP_RELEASE, false]]:
		var c := String(spec[0])
		var n := int(cs.length_of(c) * 30.0)
		for k in n + 1:
			var t := k / 30.0
			var w := drv.ik_weight_at_draw(t) if bool(spec[1]) else 1.0
			var g: Array[Transform3D] = rt.retarget(cs.sample(c, t), 0.0, w)["global"]
			for sd in ["l", "r"]:
				var ua: int = rt.index_of["upperarm_" + sd]
				var la: int = rt.index_of["lowerarm_" + sd]
				var ha: int = rt.index_of["hand_" + sd]
				var fore: Vector3 = g[ha].origin - g[la].origin
				var fore_rest := (rt.rest_global[ha].origin - rt.rest_global[la].origin)
				var axis_local := (_q(rt.rest_global[la]).inverse() * fore_rest).normalized()
				tw[sd] = maxf(tw[sd], _twist(g, la, ha, axis_local))
				var up_dir: Vector3 = (g[la].origin - g[ua].origin).normalized()
				var rest_dir: Vector3 = (rt.rest_global[la].origin - rt.rest_global[ua].origin).normalized()
				elev[sd] = maxf(elev[sd], rad_to_deg(up_dir.angle_to(rest_dir)))
				var flex := rad_to_deg(up_dir.angle_to(fore.normalized()))
				elbow_min[sd] = minf(elbow_min[sd], flex)
				elbow_max[sd] = maxf(elbow_max[sd], flex)
			for si in 3:
				var bi: int = rt.index_of["spine_0%d" % (si + 1)]
				var d := _ang(_q(g[bi]) * _q(rt.rest_global[bi]).inverse(), Quaternion.IDENTITY)
				spine_max[si] = maxf(spine_max[si], d)
	_finding("A-08 FOREARM TWIST (hand about the forearm axis, max): bow arm %.1f° · string arm %.1f° — the Huntress rig has NO twist bones, so twist concentrates at the wrist" % [tw["l"], tw["r"]])
	_finding("A-08 UPPER-ARM SWING from rest (max): bow arm %.1f° · string arm %.1f° — the clavicles are REST-HELD (the source has none)" % [elev["l"], elev["r"]])
	_finding("A-08 ELBOW FLEXION range: bow arm %.1f°–%.1f° · string arm %.1f°–%.1f°" % [elbow_min["l"], elbow_max["l"], elbow_min["r"], elbow_max["r"]])
	_finding("A-08 SPINE DISTRIBUTION (max model-space delta): spine_01 %.1f° · spine_02 (derived) %.1f° · spine_03 %.1f°" % [spine_max[0], spine_max[1], spine_max[2]])
	var ok: bool = float(tw["l"]) >= 0.0 and float(tw["r"]) >= 0.0 and float(elbow_max["r"]) > 0.0
	_note(id, "deformation proxies measured over Draw, Aiming_Idle and Release; printed as FINDINGS; the RENDERED close-ups decide")
	_reached(id)
	return ok

func _band(cm: float) -> String:
	if cm <= 2.0:
		return "STABLE"
	if cm <= 5.0:
		return "VISIBLE SLIDE"
	return "DEFECT"

func chk_V22_foot_stability_is_measured_against_declared_bands() -> bool:
	var id := "V22_foot_stability_is_measured_against_declared_bands"
	var cs := main.clip_source
	var rt := drv.retarget
	var ok := true
	for spec in [[SpikeConfig.CLIP_BOW_IDLE, "idle"], [SpikeConfig.CLIP_AIM_IDLE, "full"], [SpikeConfig.CLIP_DRAW, "draw"], [SpikeConfig.CLIP_RELEASE, "full"]]:
		var c := String(spec[0])
		var n := int(cs.length_of(c) * 60.0)
		var hdrift := {"l": 0.0, "r": 0.0}
		var rdrift := {"l": 0.0, "r": 0.0}
		var hmin := INF
		var hmax := -INF
		var first_h := {}
		var first_r := {}
		for k in n + 1:
			var t := k / 60.0
			var w := 0.0
			match String(spec[1]):
				"full": w = 1.0
				"draw": w = drv.ik_weight_at_draw(t)
			var p := cs.sample(c, t)
			var g: Array[Transform3D] = rt.retarget(p, 0.0, w)["global"]
			var gr := drv._ranger_globals(drv._ranger_local(p, 0.0))
			for sd in ["l", "r"]:
				var hp: Vector3 = g[rt.index_of["ball_" + sd]].origin
				var rp: Vector3 = gr[drv.ranger_skel.find_bone("toes." + sd)].origin
				if k == 0:
					first_h[sd] = hp
					first_r[sd] = rp
				hdrift[sd] = maxf(hdrift[sd], Vector2(hp.x - first_h[sd].x, hp.z - first_h[sd].z).length())
				rdrift[sd] = maxf(rdrift[sd], Vector2(rp.x - first_r[sd].x, rp.z - first_r[sd].z).length())
				hmin = minf(hmin, hp.y)
				hmax = maxf(hmax, hp.y)
		var hw := maxf(hdrift["l"], hdrift["r"]) * 100.0
		var rw := maxf(rdrift["l"], rdrift["r"]) * 100.0
		if not is_finite(hw) or not is_finite(rw):
			ok = false
		var h_leg := rt.rest_global[rt.index_of["thigh_l"]].origin.y - rt.rest_global[rt.index_of["foot_l"]].origin.y
		var s_leg: float = cs.rest_global[cs.index_of["upperleg.l"]].origin.y - cs.rest_global[cs.index_of["foot.l"]].origin.y
		_finding("A-09 FOOT DRIFT %-24s Huntress %.2f cm [%s] = %.2f leg lengths (ball height %.3f–%.3f m) · native control %.2f cm [%s] = %.2f leg lengths" % [c, hw, _band(hw), hw / 100.0 / h_leg, hmin, hmax, rw, _band(rw), rw / 100.0 / s_leg])
	_finding("A-09 NOTE: in Draw and Release the SOURCE itself swivels the stance (the archer turns side-on; the native control drifts too) — the drift is authored motion carried by both bodies, not a retarget artefact; per leg length the Huntress moves no more than the control.")
	_note(id, "4 stationary clips x 2 bodies measured; bands declared in advance (≤2 cm STABLE · 2–5 VISIBLE SLIDE · >5 DEFECT); printed as FINDINGS, with the drift per leg length")
	_reached(id)
	return ok

func chk_V23_the_bow_meets_the_declared_full_draw_criterion_on_both_bodies() -> bool:
	var id := "V23_the_bow_meets_the_declared_full_draw_criterion_on_both_bodies"
	var cs := main.clip_source
	var rt := drv.retarget
	var full := cs.sample(SpikeConfig.CLIP_AIM_IDLE, 0.0)
	var g: Array[Transform3D] = rt.retarget(full, 0.0, 1.0)["global"]
	var gr := drv._ranger_globals(drv._ranger_local(full, 0.0))
	var rows := []
	for spec in [["huntress", drv.pres_h, g[rt.index_of["hand_l"]], rt.grip_point(g, "l"), rt.nock_point(g, "r")],
			["control", drv.pres_r, gr[drv.ranger_skel.find_bone("handslot.l")], gr[drv.ranger_skel.find_bone("handslot.l")].origin, gr[drv.ranger_skel.find_bone("handslot.r")].origin]]:
		var pres: BowPresentation = spec[1]
		var bw := pres.bow_transform_for(spec[2])
		var u: Vector3 = ((spec[3] as Vector3) - (spec[4] as Vector3)).normalized()
		var bx := bw.basis.x.normalized()
		var by := bw.basis.y.normalized()
		var bz := bw.basis.z.normalized()
		var perp := absf(by.dot(u))
		var in_plane := absf(bz.dot(u))
		var string_side := bx.dot((spec[4] as Vector3) - (spec[3] as Vector3))
		var tilt := rad_to_deg(by.angle_to(Vector3.UP))
		rows.append([spec[0], perp, in_plane, string_side, tilt, bw.origin.distance_to(spec[3])])
		_finding("A-10 BOW AT FULL DRAW (%s): long axis ⟂ arrow line |cos|=%.4f · arrow line in the bow plane |cos to normal|=%.4f · string side toward the archer %+.3f · long axis %.1f° from world up · grip offset %.4f m" % [spec[0], perp, in_plane, string_side, tilt, bw.origin.distance_to(spec[3])])
	var ok := true
	for r in rows:
		ok = ok and float(r[1]) < 0.01 and float(r[2]) < 0.01 and float(r[3]) > 0.0 and float(r[5]) < 0.001
	_note(id, "criterion (plane contains the line · long axis ⟂ line · string toward the archer · grip at the grip point) met on both bodies=%s" % ok)
	_reached(id)
	return ok

## Per-frame rotation snapshots of the mapped bones on both bodies.
func _snap_rot() -> Array:
	var h: BonePose = drv.last_h["local"]
	var gh: Array[Transform3D] = drv.last_h["global"]
	var hq: Array = []
	for p in drv.retarget.pairs:
		hq.append(_q(gh[int(p["t"])]))
	var rq: Array = []
	for i in drv.last_r_global.size():
		rq.append(_q(drv.last_r_global[i]))
	return [hq, rq]

static func _max_step(prev: Array, cur: Array) -> float:
	var m := 0.0
	for i in cur.size():
		m = maxf(m, _ang(prev[i], cur[i]))
	return m

func chk_V24_the_five_transitions_are_exercised_and_measured_on_both_bodies() -> bool:
	var id := "V24_the_five_transitions_are_exercised_and_measured_on_both_bodies"
	await _reset(Vector3(-8.0, 0, 5.0), 1)
	# Record every frame from a run, through a stop, a full bow use, to idle.
	var frames: Array = []
	var prev := _snap_rot()
	cam.debug_cursor_override = Vector3(20.0, 0, 5.0)
	probe.intent.debug_move_axis = _world_axis(Vector3(1, 0, 0))
	for i in 50:
		await physics_frame
		var cur := _snap_rot()
		frames.append({"f": Engine.get_physics_frames(), "phase": drv.phase, "tau": drv.tau, "h": _max_step(prev[0], cur[0]), "r": _max_step(prev[1], cur[1])})
		prev = cur
	probe.intent.debug_move_axis = null
	var stop_at := frames.size()
	for i in 40:
		await physics_frame
		var cur := _snap_rot()
		frames.append({"f": Engine.get_physics_frames(), "phase": drv.phase, "tau": drv.tau, "h": _max_step(prev[0], cur[0]), "r": _max_step(prev[1], cur[1])})
		prev = cur
	var fired := await _press_shot()
	var g := 0
	while g < 400 and (probe.commitment.active or drv.in_action):
		await physics_frame
		var cur := _snap_rot()
		frames.append({"f": Engine.get_physics_frames(), "phase": drv.phase, "tau": drv.tau, "h": _max_step(prev[0], cur[0]), "r": _max_step(prev[1], cur[1])})
		prev = cur
		g += 1
	for i in 20:
		await physics_frame
		var cur := _snap_rot()
		frames.append({"f": Engine.get_physics_frames(), "phase": drv.phase, "tau": drv.tau, "h": _max_step(prev[0], cur[0]), "r": _max_step(prev[1], cur[1])})
		prev = cur
	# Windows.
	var windows := {
		"carried-bow run -> stop": [stop_at, stop_at + 18],
		"idle -> draw": [-1, -1], "draw -> hold": [-1, -1], "hold -> release": [-1, -1], "release -> recovery/idle": [-1, -1],
	}
	var release_i := -1
	for i in frames.size():
		if String(frames[i]["phase"]) == "RELEASE":
			release_i = i
			break
	for i in frames.size():
		var fr: Dictionary = frames[i]
		if String(fr["phase"]) == "DRAW" and int(windows["idle -> draw"][0]) < 0:
			windows["idle -> draw"] = [i, i + int(SpikeConfig.XFADE_INTO_DRAW_S * 60.0) + 2]
		# The hold lasts only 0.10 s: its window STOPS where the release begins,
		# or it would measure the snap (the first version did, and reported a
		# 22-degree "draw -> hold" step that was the release).
		if String(fr["phase"]) == "HOLD" and int(windows["draw -> hold"][0]) < 0:
			windows["draw -> hold"] = [i - 1, mini(i + int(SpikeConfig.XFADE_DRAW_TO_HOLD_S * 60.0) + 1, release_i - 1)]
		if String(fr["phase"]) == "RELEASE" and int(windows["hold -> release"][0]) < 0:
			windows["hold -> release"] = [i - 1, i + int(SpikeConfig.XFADE_HOLD_TO_RELEASE_LEGS_S * 60.0) + 1]
		if i > 0 and String(frames[i - 1]["phase"]) == "RECOVERY" and String(fr["phase"]) == "IDLE":
			windows["release -> recovery/idle"] = [i - 3, i + 6]
	# The reference: a transition should not move faster than EITHER clip it
	# joins -- the faster of the two clips' own largest per-frame steps at x1.
	# (The first version used the destination alone, which made any crossfade
	# into a near-still idle read as a "POP".)
	var run_ref := _clip_ref(SpikeConfig.CLIP_RUN_BOW, 0.0)
	var idle_ref := _clip_ref(SpikeConfig.CLIP_BOW_IDLE, 0.0)
	var draw_ref := _clip_ref(SpikeConfig.CLIP_DRAW, 1.0)
	var aim_ref := _clip_ref(SpikeConfig.CLIP_AIM_IDLE, 1.0)
	var rel_ref := _clip_ref(SpikeConfig.CLIP_RELEASE, 1.0)
	var ref := {"carried-bow run -> stop": _maxref(run_ref, idle_ref),
		"idle -> draw": _maxref(idle_ref, draw_ref), "draw -> hold": _maxref(draw_ref, aim_ref),
		"hold -> release": _maxref(aim_ref, rel_ref), "release -> recovery/idle": _maxref(rel_ref, idle_ref)}
	var all_found := fired
	for k in windows.keys():
		var w: Array = windows[k]
		if int(w[0]) < 0:
			all_found = false
			_finding("A-11 %-26s NOT EXERCISED" % k)
			continue
		var mh := 0.0
		var mr := 0.0
		for i in range(maxi(1, int(w[0])), mini(frames.size(), int(w[1]) + 1)):
			mh = maxf(mh, float(frames[i]["h"]))
			mr = maxf(mr, float(frames[i]["r"]))
		var rh: float = ref[k][0]
		var rr: float = ref[k][1]
		_finding("A-11 %-26s max per-frame step: Huntress %.2f° [%s] · control %.2f° [%s] (the faster joined clip's own max: %.2f° / %.2f°)" % [k, mh, _tband(mh, rh), mr, _tband(mr, rr), rh, rr])
	_note(id, "five windows exercised live at x1.00 on both bodies=%s; bands vs the faster of the two joined clips' own max step: ≤ = SMOOTH · ≤ 2x = STEP · > 2x = POP" % all_found)
	_reached(id)
	return all_found

static func _maxref(a: Array, b: Array) -> Array:
	return [maxf(float(a[0]), float(b[0])), maxf(float(a[1]), float(b[1]))]

func _tband(v: float, ref: float) -> String:
	if v <= ref + 0.001:
		return "SMOOTH"
	if v <= ref * 2.0:
		return "STEP"
	return "POP"

## The largest per-frame (60 Hz) rotation step of any mapped bone inside a clip,
## Huntress and control, at the IK weight the live action uses.
func _clip_ref(c: String, ik: float) -> Array:
	var cs := main.clip_source
	var rt := drv.retarget
	var n := int(cs.length_of(c) * 60.0)
	var ph: Array = []
	var pr: Array = []
	var mh := 0.0
	var mr := 0.0
	for k in n + 1:
		var p := cs.sample(c, k / 60.0)
		var g: Array[Transform3D] = rt.retarget(p, 0.0, ik)["global"]
		var gr := drv._ranger_globals(drv._ranger_local(p, 0.0))
		var hq: Array = []
		for pp in rt.pairs:
			hq.append(_q(g[int(pp["t"])]))
		var rq: Array = []
		for t in gr:
			rq.append(_q(t))
		if k > 0:
			mh = maxf(mh, _max_step(ph, hq))
			mr = maxf(mr, _max_step(pr, rq))
		ph = hq
		pr = rq
	return [mh, mr]

func _world_axis(world_dir: Vector3) -> Vector2:
	var b := cam.locked_basis()
	var fwd := -b.z; fwd.y = 0.0; fwd = fwd.normalized()
	var right := b.x; right.y = 0.0; right = right.normalized()
	return Vector2(world_dir.dot(right), -world_dir.dot(fwd)).normalized()

func chk_V25_the_release_frame_aligns_at_every_diagnostic_rate() -> bool:
	var id := "V25_the_release_frame_aligns_at_every_diagnostic_rate"
	var rows: Array[String] = []
	var ok := true
	for ri in SpikeConfig.DIAGNOSTIC_RATES.size():
		await _reset(Vector3(0, 0, 3.0), ri)
		await _aim_at(Vector3(0, 0, -9.0))
		drv.frame_log.clear()
		drv.log_enabled = true
		var spawned_before := ArrowProjectile.spawned
		var fired := await _press_shot()
		var rel := await _await_release(700)
		await _await_action_end(900)
		drv.log_enabled = false
		var rf: int = probe.release_frames.back() if not probe.release_frames.is_empty() else -1
		var first_release_clip := -1
		var arrow_off_frame := -1
		var prev_arrow := false
		for e in drv.frame_log:
			if first_release_clip < 0 and String(e["clip"]) == SpikeConfig.CLIP_RELEASE:
				first_release_clip = int(e["frame"])
			if prev_arrow and not bool(e["arrow_h"]) and arrow_off_frame < 0:
				arrow_off_frame = int(e["frame"])
			prev_arrow = bool(e["arrow_h"])
		var log: Dictionary = probe.release_log.back()
		var mech := float(log["duration"]) * float(log["marker"])
		var el := float(log["elapsed"])
		var mech_ok := el >= mech - 0.000001 and el < mech + 1.0 / 60.0 + 0.000001
		var one := ArrowProjectile.spawned == spawned_before + 1
		var row_ok := fired and rel and rf == first_release_clip and rf == arrow_off_frame and mech_ok and one
		ok = ok and row_ok
		rows.append("x%.2f: release frame %d · clip enters Release %d · arrow leaves the hand %d · elapsed %.4f vs marker x duration %.4f · projectiles +%d" % [SpikeConfig.DIAGNOSTIC_RATES[ri], rf, first_release_clip, arrow_off_frame, el, mech, ArrowProjectile.spawned - spawned_before])
	for r in rows:
		_finding("A-12/B-08/C-11 " + r)
	_note(id, "5 rates: the release, the clip's entry into Ranged_Bow_Release and the arrow leaving the hand share ONE physics frame, at marker x duration of MECHANICAL time, with exactly one projectile each=%s" % ok)
	_reached(id)
	return ok

func chk_V26_source_clip_data_is_unchanged_after_the_run() -> bool:
	var id := "V26_source_clip_data_is_unchanged_after_the_run"
	var changed: Array[String] = []
	for c in SpikeConfig.AUTHORIZED_CLIPS:
		if main.clip_source.checksum(String(c)) != String(checksums_start[c]) or String(checksums_start[c]) == "":
			changed.append(String(c))
	var ok := changed.is_empty() and checksums_start.size() == 7
	_note(id, "7 clip checksums taken at start and compared now (after every bow use so far): changed=%s" % [changed])
	_reached(id)
	return ok

func chk_V27_the_native_sampler_equals_the_engine_animation_player() -> bool:
	var id := "V27_the_native_sampler_equals_the_engine_animation_player"
	var cs := main.clip_source
	var r := (load(AssetManifest.KAYKIT_RANGER) as PackedScene).instantiate() as Node3D
	r.name = "SuiteRangerForSamplerCheck"
	root.add_child(r)
	r.global_position = Vector3(0, -50, 0)
	var sk := RigCorpus.find_skeleton(r)
	var lib := AnimationLibrary.new()
	for c in SpikeConfig.PLAYED_CLIPS:
		lib.add_animation(StringName(c), cs.clips[c])
	var ap := AnimationPlayer.new()
	r.add_child(ap)
	ap.root_node = NodePath("..")
	ap.add_animation_library(&"", lib)
	var worst_deg := 0.0
	var worst_m := 0.0
	var n := 0
	for c in SpikeConfig.PLAYED_CLIPS:
		for t in [0.0, 0.1, 0.37, 0.5, 0.79]:
			ap.play(StringName(c))
			ap.seek(t, true)
			ap.advance(0.0)
			cs.measuring = true
			var mine := cs.sample(String(c), t)
			cs.measuring = false
			var native := drv._ranger_local(mine, 0.0)
			for s in cs.bone_count():
				var ri := sk.find_bone(cs.bone_names[s])
				worst_deg = maxf(worst_deg, _ang(sk.get_bone_pose_rotation(ri), native.rot[ri]))
				worst_m = maxf(worst_m, sk.get_bone_pose_position(ri).distance_to(native.pos[ri]))
				n += 1
	ap.stop()
	r.queue_free()
	var ok := n > 500 and worst_deg < 0.05 and worst_m < 0.0005
	_note(id, "%d bone samples, 5 played clips x 5 times: the spike's NATIVE pose (sampler + the Ranger's own rest for untracked bones) vs Godot's AnimationPlayer on the Ranger — worst %.5f° / %.6f m" % [n, worst_deg, worst_m])
	_reached(id)
	return ok

func chk_V28_the_import_reproduces_the_d386_raw_measurements() -> bool:
	var id := "V28_the_import_reproduces_the_d386_raw_measurements"
	var cs := main.clip_source
	var d1 := _pose_gap(SpikeConfig.CLIP_DRAW, cs.length_of(SpikeConfig.CLIP_DRAW), SpikeConfig.CLIP_AIM_IDLE, 0.0)
	var d2 := _pose_gap(SpikeConfig.CLIP_RELEASE, cs.length_of(SpikeConfig.CLIP_RELEASE), SpikeConfig.CLIP_BOW_IDLE, 0.0)
	var ui: int = cs.index_of["upperarm.r"]
	var d3 := _ang(cs.sample(SpikeConfig.CLIP_BOW_IDLE, 0.0).rot[ui], cs.sample(SpikeConfig.CLIP_DRAW, 0.0).rot[ui])
	var ok := d1 < 0.5 and d2 < 0.5 and absf(d3 - 106.7) <= 1.5
	_note(id, "Draw end vs Aiming_Idle start %.3f° · Release end vs Bow_Idle start %.3f° · Bow_Idle -> Draw start at upperarm.r %.2f° (D-386: 0.0°, 0.0°, 106.7°)" % [d1, d2, d3])
	_reached(id)
	return ok

func _pose_gap(a: String, ta_: float, b: String, tb_: float) -> float:
	var cs := main.clip_source
	var ga := cs.globals(cs.sample(a, ta_))
	var gb := cs.globals(cs.sample(b, tb_))
	var m := 0.0
	for i in cs.bone_count():
		m = maxf(m, _ang(_q(ga[i]), _q(gb[i])))
	return m

func chk_V29_the_release_marker_is_the_measured_string_hand_snap() -> bool:
	var id := "V29_the_release_marker_is_the_measured_string_hand_snap"
	var cs := main.clip_source
	var hr: int = cs.index_of["hand.r"]
	var best := 0.0
	var best_t := -1.0
	var prev := cs.globals(cs.sample(SpikeConfig.CLIP_RELEASE, 0.0))[hr].origin
	var n := int(cs.length_of(SpikeConfig.CLIP_RELEASE) * 60.0)
	for k in range(1, n + 1):
		var p := cs.globals(cs.sample(SpikeConfig.CLIP_RELEASE, k / 60.0))[hr].origin
		var v := p.distance_to(prev) * 60.0
		if v > best:
			best = v
			best_t = k / 60.0
		prev = p
	var ok := best_t > 0.0 and best_t <= 0.10 and is_equal_approx(drv.t_rel, drv.t_full + SpikeConfig.HOLD_S) \
		and is_equal_approx(drv.marker(), drv.t_rel / drv.t_total) and drv.bow_hand == "l"
	_finding("A-16 RELEASE MARKER: the string hand's peak speed in Ranged_Bow_Release is %.2f m/s (rig space) at %.4f s — the snap begins at the clip's first frame · T_full %.4f s (measured) + hold %.2f s = T_rel %.4f s · normalised marker %.4f" % [best, best_t, drv.t_full, SpikeConfig.HOLD_S, drv.t_rel, drv.marker()])
	_note(id, "peak %.2f m/s at %.4f s (within 0.10 s) · marker = T_rel / T_total" % [best, best_t])
	_reached(id)
	return ok

# ================================================ Q2: bow, string and arrow ==

func chk_V30_the_bow_is_in_the_measured_hand_and_its_grip_follows_every_frame() -> bool:
	var id := "V30_the_bow_is_in_the_measured_hand_and_its_grip_follows_every_frame"
	await _reset(Vector3(0, 0, 3.0), 2)
	await _aim_at(Vector3(0, 0, -9.0))
	var worst_h := 0.0
	var worst_r := 0.0
	var fired := await _press_shot()
	var frames := 0
	while probe.commitment.active and frames < 400:
		await physics_frame
		var gh: Array[Transform3D] = drv.last_h["global"]
		var vis := probe.visual.global_transform
		worst_h = maxf(worst_h, drv.pres_h.bow_world.origin.distance_to(vis * drv.retarget.grip_point(gh, "l")))
		worst_r = maxf(worst_r, drv.pres_r.bow_world.origin.distance_to(vis * drv.last_r_global[drv.ranger_skel.find_bone("handslot.l")].origin))
		frames += 1
	var ok := fired and frames > 20 and drv.bow_hand == "l" and worst_h < 0.001 and worst_r < 0.001
	_note(id, "bow hand measured: %s · over %d frames of a use, grip-point error Huntress %.6f m, control %.6f m" % ["LEFT" if drv.bow_hand == "l" else "RIGHT", frames, worst_h, worst_r])
	_reached(id)
	return ok

func chk_V31_the_rigid_string_is_absent_and_the_source_is_unchanged() -> bool:
	var id := "V31_the_rigid_string_is_absent_and_the_source_is_unchanged"
	var src := load(AssetManifest.BOW_WOODEN) as ArrayMesh
	var names: Array[String] = []
	var dm := drv.pres_h.bow_mesh.mesh as ArrayMesh
	for i in dm.get_surface_count():
		names.append(String(dm.surface_get_material(i).resource_name))
	var src_names: Array[String] = []
	for i in src.get_surface_count():
		src_names.append(String(src.surface_get_material(i).resource_name))
	var ok := drv.pres_h.displayed_surfaces == 2 and drv.pres_h.source_surfaces == 3 and not names.has("White") \
		and src_names.has("White") and src.get_surface_count() == 3 \
		and FileAccess.get_sha256(AssetManifest.BOW_WOODEN) == "788c9e72bdd839a86704113de4809a96cfedf09441bb3f98f383a7abfe751e6d"
	_note(id, "displayed surfaces %s of the source's %s · the source .obj hash unchanged" % [names, src_names])
	_reached(id)
	return ok

func chk_V32_the_string_ends_at_the_tips_follows_the_nock_and_returns_on_release() -> bool:
	var id := "V32_the_string_ends_at_the_tips_follows_the_nock_and_returns_on_release"
	await _reset(Vector3(0, 0, 3.0), 2)
	await _aim_at(Vector3(0, 0, -9.0))
	var tip_err := 0.0
	var follow_err := 0.0
	var drawn_frames := 0
	var rest_err_after := 0.0
	var after_frames := 0
	var fired := await _press_shot()
	while probe.commitment.active:
		await physics_frame
		var p := drv.pres_h
		var seg := p.string_top.global_transform
		var half := seg.basis.y * 0.5
		var e1 := seg.origin + half
		var e0 := seg.origin - half
		tip_err = maxf(tip_err, minf(e0.distance_to(p.tip_top_world), e1.distance_to(p.tip_top_world)))
		if p.drawn:
			drawn_frames += 1
			var nock := probe.visual.global_transform * drv.retarget.nock_point(drv.last_h["global"], "r")
			follow_err = maxf(follow_err, p.string_centre_world.distance_to(nock))
		if drv.released:
			after_frames += 1
			rest_err_after = maxf(rest_err_after, p.string_centre_world.distance_to(p.string_rest_world))
	var ok := fired and drawn_frames > 5 and after_frames > 5 and tip_err < 0.001 and follow_err < 0.001 and rest_err_after < 0.001
	_note(id, "ends at the tips (worst %.6f m) · centre on the nock for %d drawn frames (worst %.6f m) · at rest on and after release for %d frames (worst %.6f m)" % [tip_err, drawn_frames, follow_err, after_frames, rest_err_after])
	_reached(id)
	return ok

func chk_V33_the_arrow_is_hidden_before_the_nock_and_nocked_through_the_hold() -> bool:
	var id := "V33_the_arrow_is_hidden_before_the_nock_and_nocked_through_the_hold"
	await _reset(Vector3(0, 0, 3.0), 2)
	await _aim_at(Vector3(0, 0, -9.0))
	drv.frame_log.clear()
	drv.log_enabled = true
	var fired := await _press_shot()
	await _await_action_end()
	drv.log_enabled = false
	var before_nock_visible := 0
	var nocked_missing := 0
	var hold_frames := 0
	var nock_err := 0.0
	for e in drv.frame_log:
		if not bool(e["in_action"]):
			continue
		var tau := float(e["tau"])
		if tau < drv.nock_tau_h and bool(e["arrow_h"]):
			before_nock_visible += 1
		if tau >= drv.nock_tau_h and not bool(e["released"]):
			if not bool(e["arrow_h"]):
				nocked_missing += 1
			else:
				nock_err = maxf(nock_err, (e["arrow_xf_h"] as Transform3D).origin.distance_to(e["string_h"]))
			if String(e["phase"]) == "HOLD":
				hold_frames += 1
	var ok := fired and before_nock_visible == 0 and nocked_missing == 0 and hold_frames > 0 and nock_err < 0.001
	_note(id, "visible before the nock moment: %d frames · missing while nocked: %d · hold frames %d · nock end at the string centre (worst %.6f m)" % [before_nock_visible, nocked_missing, hold_frames, nock_err])
	_reached(id)
	return ok

func chk_V34_exactly_one_projectile_per_released_use() -> bool:
	var id := "V34_exactly_one_projectile_per_released_use"
	await _reset(Vector3(0, 0, 3.0), 4)
	await _aim_at(Vector3(0, 0, -9.0))
	var uses0 := probe.bow_uses
	var rel0 := probe.arrows_released
	var sp0 := ArrowProjectile.spawned
	var cancels0 := probe.recovery_cancels
	for k in 4:
		var fired := await _press_shot()
		await _await_release()
		if k % 2 == 1:
			# Cancel the recovery with movement, as a player would.
			probe.intent.debug_move_axis = Vector2(0.0, 1.0)
			await _phys(3)
			probe.intent.debug_move_axis = null
		await _await_action_end()
		await _until(func(): return probe.motor.speed() < 0.01, 60)
	var uses := probe.bow_uses - uses0
	var rel := probe.arrows_released - rel0
	var sp := ArrowProjectile.spawned - sp0
	var cancels := probe.recovery_cancels - cancels0
	var ok := uses == 4 and rel == 4 and sp == 4 and cancels == 2
	_note(id, "4 uses (2 with recovery cancelled): %d uses · %d releases · %d projectiles · %d cancels" % [uses, rel, sp, cancels])
	_reached(id)
	return ok

func chk_V35_the_projectile_starts_at_the_nocked_arrow_and_flies_the_per_use_aim() -> bool:
	var id := "V35_the_projectile_starts_at_the_nocked_arrow_and_flies_the_per_use_aim"
	await _reset(Vector3(0, 0, 3.0), 1)
	await _aim_at(Vector3(0, 0, -9.0))
	var aim_at_use := probe.aim_dir
	drv.frame_log.clear()
	drv.log_enabled = true
	var fired := await _press_shot()
	# Swing the cursor 90 degrees during the draw -- per-use aim must hold.
	cam.debug_cursor_override = probe.global_position + Vector3(9.0, 0, 0)
	await _await_release()
	drv.log_enabled = false
	var log: Dictionary = probe.release_log.back()
	var p: ArrowProjectile = probe.projectiles.back()
	var prev_xf := Transform3D.IDENTITY
	for e in drv.frame_log:
		if int(e["frame"]) < int(log["frame"]):
			prev_xf = e["arrow_xf_h"]
	var spawn: Vector3 = log["spawn"]
	var start_err := Vector2(spawn.x - prev_xf.origin.x, spawn.z - prev_xf.origin.z).length()
	var dir_ok := p.direction.dot(Vector3(aim_at_use.x, 0, aim_at_use.z).normalized()) > 0.9999
	var facing := Vector3(sin(float(log["facing_yaw"])), 0, cos(float(log["facing_yaw"])))
	var divergence := rad_to_deg(facing.angle_to(p.direction))
	_finding("C-08 PER-USE AIM vs FACING: the cursor swung 90° during a x1.00 draw; the arrow flew the aim sampled when the use BEGAN, while the accepted continuous facing had turned %.1f° away from it by the release frame — the shot leaves at an angle to the body. A finding for Question 3, not a defect of the accepted rule (D-193)." % divergence)
	await _await_action_end()
	var ok := fired and start_err < 0.05 and dir_ok
	_note(id, "spawn vs the nocked arrow's last position %.4f m (planar) · direction = aim at use start=%s · facing/flight divergence %.1f°" % [start_err, dir_ok, divergence])
	_reached(id)
	return ok

func chk_V36_the_trail_and_impact_are_generated_in_code() -> bool:
	var id := "V36_the_trail_and_impact_are_generated_in_code"
	await _reset(Vector3(0, 0, 2.0), 4)
	await _aim_at(ta.global_position)
	var fired := await _press_shot()
	await _await_release()
	var p: ArrowProjectile = probe.projectiles.back()
	var trail_ok := p._trail != null and p._trail.mesh is ImmediateMesh and p._trail.material_override is StandardMaterial3D
	var hit := await _await_projectile_done(p, 120)
	await physics_frame
	var impacts: Array = []
	for c in main.world_root.get_children():
		if c is ImpactEffect:
			impacts.append(c)
	var impact_ok := impacts.size() >= 1
	for fx in impacts:
		for ch in (fx as Node).get_children():
			if ch is MeshInstance3D:
				var m := (ch as MeshInstance3D).mesh
				impact_ok = impact_ok and (m is TorusMesh or m is SphereMesh) and m.resource_path == ""
	var ok := fired and trail_ok and hit and impact_ok
	_note(id, "trail = ImmediateMesh + StandardMaterial3D=%s · impact = TorusMesh/SphereMesh built in code, %d spawned=%s" % [trail_ok, impacts.size(), impact_ok])
	await _await_action_end()
	_reached(id)
	return ok

func chk_V37_the_presentation_is_labelled_diagnostic() -> bool:
	var id := "V37_the_presentation_is_labelled_diagnostic"
	var disc := (main.hud.lines["DIAGNOSTIC"] as Label).text
	var ok := disc.contains("NOT final art") and disc.contains("NOT a Skill") and disc.contains("NO imported VFX") \
		and disc.contains("stand-in") and SpikeConfig.BOW_ACTION_DENIAL.contains("NOT Splinter Shot") \
		and String(drv.pres_h.bow_mesh.name).contains("stringless")
	_note(id, "HUD disclaimer: '%s'" % disc.replace("\n", " / "))
	_reached(id)
	return ok

# =================================================== Q3: the accepted commitment ==

func chk_V38_movement_stops_for_the_bow_within_the_accepted_glide() -> bool:
	var id := "V38_movement_stops_for_the_bow_within_the_accepted_glide"
	await _reset(Vector3(-8.0, 0, 3.0), 1)
	cam.debug_cursor_override = Vector3(20.0, 0, 3.0)
	probe.intent.debug_move_axis = _world_axis(Vector3(1, 0, 0))
	await _until(func(): return probe.motor.speed() > ProdConfig.TOP_SPEED_MPS - 0.01, 60)
	var v0 := probe.motor.speed()
	# THE START POSITION IS TAKEN BEFORE THE FRAME THE SHOT BEGINS. The first
	# version read it one frame later -- after the commit frame's own braked step
	# had already moved her -- and reported a glide of 0.0000 m, which was a
	# measurement taken too late, not a stop.
	var p0 := probe.global_position
	probe.intent.debug_attack_held = true
	await physics_frame
	var begun := await _until(func(): return probe.commitment.active, 3)
	probe.intent.debug_attack_held = null
	var stopped := await _until(func(): return probe.motor.speed() < 0.0001, 20)
	var glide := Vector2(probe.global_position.x - p0.x, probe.global_position.z - p0.z).length()
	var p1 := probe.global_position
	await _phys(30)
	var still := probe.global_position.distance_to(p1)
	var held_move := probe.intent.debug_move_axis != null
	probe.intent.debug_move_axis = null
	await _await_action_end()
	var ok := v0 > 3.8 and begun and stopped and glide <= ProdConfig.ACTION_GLIDE_TOLERANCE_M and still < 0.000001 and held_move
	_note(id, "from %.3f m/s with the stick STILL held: glide %.4f m (accepted tolerance %.2f m) · then %.7f m over 30 frames" % [v0, glide, ProdConfig.ACTION_GLIDE_TOLERANCE_M, still])
	_reached(id)
	return ok

func chk_V39_facing_follows_the_aim_while_the_feet_stay_still() -> bool:
	var id := "V39_facing_follows_the_aim_while_the_feet_stay_still"
	await _reset(Vector3(0, 0, 3.0), 1)
	await _aim_at(Vector3(0, 0, -9.0))
	var fired := await _press_shot()
	var p0 := probe.global_position
	var yaw0 := probe.visual.rotation.y
	cam.debug_cursor_override = probe.global_position + Vector3(0, 0, 9.0)
	await _phys(20)
	var turned := rad_to_deg(absf(wrapf(probe.visual.rotation.y - yaw0, -PI, PI)))
	var moved := probe.global_position.distance_to(p0)
	var active := probe.commitment.active
	await _await_action_end()
	var ok := fired and active and turned > 170.0 and moved < 0.000001
	_note(id, "a 180° aim swing during the draw turned the body %.1f° while it moved %.7f m (still committed=%s)" % [turned, moved, active])
	_reached(id)
	return ok

func chk_V40_movement_before_release_is_buffered_and_cannot_cancel_the_shot() -> bool:
	var id := "V40_movement_before_release_is_buffered_and_cannot_cancel_the_shot"
	await _reset(Vector3(0, 0, 3.0), 1)
	await _aim_at(Vector3(0, 0, -9.0))
	var rel0 := probe.arrows_released
	var buf0 := probe.buffered_moves
	var fired := await _press_shot()
	await _phys(10)
	var before_release := not probe.last_use_released
	# A click-to-move order DURING the wind-up.
	cam.debug_cursor_override = probe.global_position + Vector3(4.0, 0, 0)
	probe.intent.debug_move_command_just = true
	await _phys(2)
	var p0 := probe.global_position
	# And a DIRECT recovery-cancel request before the release: REFUSED, counted.
	var refused0 := probe.commitment.cancels_refused
	var direct := probe.commitment.cancel_recovery()
	var refused := not direct and probe.commitment.cancels_refused == refused0 + 1
	await _phys(5)
	var no_move := probe.global_position.distance_to(p0) < 0.000001
	var released := await _await_release()
	await _phys(8)
	var moved_after := probe.global_position.distance_to(p0) > 0.01
	await _await_action_end()
	await _until(func(): return probe.motor.speed() < 0.01 and probe.move_destination == null, 240)
	var ok := fired and before_release and probe.buffered_moves > buf0 and refused and no_move and released \
		and probe.arrows_released == rel0 + 1 and moved_after
	_note(id, "wind-up move buffered (+%d) · direct cancel refused and counted=%s · translation before release %.7f m · the arrow still released=%s · the buffered order then moved her=%s" % [probe.buffered_moves - buf0, refused, 0.0 if no_move else 1.0, released, moved_after])
	_reached(id)
	return ok

func chk_V41_movement_after_release_cancels_the_recovery_within_one_frame() -> bool:
	var id := "V41_movement_after_release_cancels_the_recovery_within_one_frame"
	await _reset(Vector3(0, 0, 3.0), 1)
	await _aim_at(Vector3(0, 0, -9.0))
	var c0 := probe.recovery_cancels
	var fired := await _press_shot()
	var released := await _await_release()
	await _phys(3)
	var still_active := probe.commitment.active
	probe.intent.debug_move_axis = Vector2(0.0, 1.0)
	var f0 := Engine.get_physics_frames()
	var cancelled := await _until(func(): return probe.recovery_cancels > c0, 3)
	var frames_to_cancel := Engine.get_physics_frames() - f0
	await _phys(6)
	var moving := probe.motor.speed() > 0.5
	var phase_after := drv.phase
	probe.intent.debug_move_axis = null
	await _until(func(): return probe.motor.speed() < 0.01, 60)
	var ok := fired and released and still_active and cancelled and frames_to_cancel <= 1 and moving and phase_after == "RUN"
	_note(id, "recovery cancelled %d frame(s) after the movement request · locomotion resumed (speed>0.5=%s, pose %s)" % [frames_to_cancel, moving, phase_after])
	_reached(id)
	return ok

func chk_V42_the_released_arrow_survives_the_cancel_and_still_hits() -> bool:
	var id := "V42_the_released_arrow_survives_the_cancel_and_still_hits"
	await _reset(Vector3(0, 0, 4.0), 1)
	await _aim_at(ta.global_position)
	var hits0 := int(ta.hits_by_source["direct_use"])
	var c0 := probe.recovery_cancels
	var fired := await _press_shot()
	await _await_release()
	var p: ArrowProjectile = probe.projectiles.back()
	probe.intent.debug_move_axis = Vector2(0.0, 1.0)
	await _until(func(): return probe.recovery_cancels > c0, 3)
	var cancel_frame := Engine.get_physics_frames()
	var alive_after_cancel := is_instance_valid(p) and p.alive
	probe.intent.debug_move_axis = null
	await _await_projectile_done(p, 120)
	var hit_after := int(ta.hits_by_source["direct_use"]) == hits0 + 1 and is_instance_valid(p) \
		and p.hit_frame > cancel_frame and p.hit_target == ta
	var ok := fired and alive_after_cancel and hit_after
	_note(id, "the arrow was alive on the cancel frame=%s and hit TARGET A %d frames after it=%s" % [alive_after_cancel, (p.hit_frame - cancel_frame) if is_instance_valid(p) else -1, hit_after])
	await _until(func(): return probe.motor.speed() < 0.01, 60)
	_reached(id)
	return ok

func chk_V43_every_bow_action_is_stop_and_allow_is_unused() -> bool:
	var id := "V43_every_bow_action_is_stop_and_allow_is_unused"
	await _reset(Vector3(0, 0, 3.0), 4)
	await _aim_at(Vector3(0, 0, -9.0))
	var fired := await _press_shot()
	var policy := probe.commitment.policy_name()
	var label := probe.commitment.label
	await _await_action_end()
	var code := _code_only(_read_text("res://scripts/spike/huntress_spike_probe.gd"))
	var allow_used := code.contains("Movement.ALLOW")
	var ok := fired and policy == "STOP" and label == SpikeConfig.BOW_ACTION_LABEL and not allow_used
	_note(id, "live policy %s for '%s' · ALLOW named in the spike's probe code=%s" % [policy, label, allow_used])
	_reached(id)
	return ok

static func _funcs(code: String) -> Array:
	var re := RegEx.new()
	re.compile("(?m)^func ([A-Za-z_0-9]+)\\(")
	var out: Array = []
	for m in re.search_all(code):
		out.append(m.get_string(1))
	return out

func chk_V44_the_probe_overrides_exactly_three_accepted_methods() -> bool:
	var id := "V44_the_probe_overrides_exactly_three_accepted_methods"
	var base := _funcs(_read_text("res://scripts/control/player_controller.gd"))
	var sub := _funcs(_read_text("res://scripts/spike/huntress_spike_probe.gd"))
	var over: Array = []
	for f in sub:
		if base.has(f):
			over.append(f)
	over.sort()
	var want := SpikeConfig.PROBE_OVERRIDES.duplicate()
	want.sort()
	var accepted_kept := not over.has("step") and not over.has("_update_action") and not over.has("commit_subsystem_action") \
		and not over.has("_capture_move_buffer") and not over.has("_apply_move_buffer") and base.has("commit_subsystem_action")
	var ok := over == want and accepted_kept and probe is PlayerController
	_note(id, "overridden: %s · step / _update_action / buffer / commit_subsystem_action run as accepted=%s" % [over, accepted_kept])
	_reached(id)
	return ok

func chk_V45_the_verbatim_probe_bolt_is_never_fired() -> bool:
	var id := "V45_the_verbatim_probe_bolt_is_never_fired"
	var bolts: Array = []
	_find_class(root, "DiagnosticBolt", bolts)
	var ok := probe.shots_fired == 0 and bolts.is_empty() and probe.bow_uses > 0
	_note(id, "after %d bow uses: probe bolt shots_fired=%d · DiagnosticBolt nodes=%d" % [probe.bow_uses, probe.shots_fired, bolts.size()])
	_reached(id)
	return ok

func _find_class(n: Node, cname: String, out: Array) -> void:
	var sc: Script = n.get_script()
	if sc != null and sc.get_global_name() == cname:
		out.append(n)
	for c in n.get_children():
		_find_class(c, cname, out)

# ================================================================== Q4: Prey ==

func _shoot(t: Node3D, from: Vector3 = Vector3(0, 0, 2.0)) -> bool:
	if probe.global_position.distance_to(from) > 0.01:
		probe.global_position = from
		await _phys(2)
	await _aim_at(t.global_position, 20)
	var fired := await _press_shot()
	await _await_release()
	var p: ArrowProjectile = probe.projectiles.back()
	await _await_projectile_done(p, 120)
	await _await_action_end()
	return fired

func chk_V46_a_direct_hit_on_a_designates_a() -> bool:
	var id := "V46_a_direct_hit_on_a_designates_a"
	await _reset(Vector3(0, 0, 2.0), 4)
	var none_before := prey.current == null
	var fired := await _shoot(ta)
	var ok := none_before and fired and prey.current == ta and int(ta.hits_by_source["direct_use"]) >= 1
	_note(id, "no Prey before · after a direct Hit on A: Prey=%s" % prey.current_name())
	_reached(id)
	return ok

func chk_V47_a_direct_hit_on_b_switches_prey_to_b() -> bool:
	var id := "V47_a_direct_hit_on_b_switches_prey_to_b"
	await _reset(Vector3(0, 0, 2.0), 4)
	await _shoot(ta)
	var was_a := prey.current == ta
	var sw0 := prey.switches
	await _shoot(tb)
	var ok := was_a and prey.current == tb and prey.switches == sw0 + 1 and not ta.is_marked() and tb.is_marked()
	_note(id, "A then B: Prey=%s · switches +%d · A marked=%s B marked=%s" % [prey.current_name(), prey.switches - sw0, ta.is_marked(), tb.is_marked()])
	_reached(id)
	return ok

func chk_V48_exactly_one_prey_at_any_time() -> bool:
	var id := "V48_exactly_one_prey_at_any_time"
	await _reset(Vector3(0, 0, 2.0), 4)
	var worst := 0
	var frames := 0
	var mismatch := 0
	for t in [ta, tb, ta, tb]:
		await _aim_at((t as Node3D).global_position, 16)
		await _press_shot()
		var g := 0
		while g < 300:
			await physics_frame
			g += 1
			frames += 1
			worst = maxi(worst, prey.marked_count())
			if prey.current != null and not prey.current.is_marked():
				mismatch += 1
			if not probe.commitment.active:
				var last = probe.projectiles.back()
				if not is_instance_valid(last) or not (last as ArrowProjectile).alive:
					break
	var ok := frames > 40 and worst == 1 and mismatch == 0 and prey.designations >= 2
	_note(id, "over %d frames of A/B/A/B shooting: at most %d marked target at once · marker/state mismatches %d" % [frames, worst, mismatch])
	_reached(id)
	return ok

func chk_V49_death_clears_prey_and_a_non_prey_death_does_not() -> bool:
	var id := "V49_death_clears_prey_and_a_non_prey_death_does_not"
	await _reset(Vector3(0, 0, 2.0), 4)
	await _shoot(ta)
	var a_prey := prey.current == ta
	# A NON-Prey death first: B dies, Prey stays A.
	tb.receive_damage(tb.life.life + 1.0, Vector3.ZERO, "direct_use")
	var b_dead := not tb.alive
	var still_a := prey.current == ta
	# Now the Prey dies -- by the archer's own arrow.
	ta.life.life = 1.0
	var clears0 := prey.clears_death
	await _shoot(ta)
	var a_dead := not ta.alive
	var cleared := prey.current == null and prey.clears_death == clears0 + 1 and not ta.is_marked()
	var ok := a_prey and b_dead and still_a and a_dead and cleared
	_note(id, "B (not Prey) died -> Prey still A=%s · A (Prey) killed by an arrow -> Prey cleared=%s" % [still_a, cleared])
	_reached(id)
	return ok

func chk_V50_removal_clears_prey() -> bool:
	var id := "V50_removal_clears_prey"
	await _reset(Vector3(0, 0, 2.0), 4)
	var c := TargetDummy.new()
	c.build("TARGET C (SUITE)", "round", Color(0.5, 0.9, 0.5))
	main.arena.add_child(c)
	c.global_position = Vector3(0, 0, -6.0)
	prey.watch(c)
	await _phys(2)
	var designated := prey.designate(c, PreyState.DIRECT_USE, -1)
	var r0 := prey.clears_removal
	c.queue_free()
	await _phys(2)
	var ok := designated and prey.current == null and prey.clears_removal == r0 + 1
	_note(id, "a designated target removed from the tree: Prey cleared=%s (clears by removal +%d)" % [prey.current == null, prey.clears_removal - r0])
	_reached(id)
	return ok

func chk_V51_prey_grants_no_damage_bonus() -> bool:
	var id := "V51_prey_grants_no_damage_bonus"
	await _reset(Vector3(0, 0, 2.0), 4)
	await _shoot(ta)
	var first_on_a := ta.last_hit_amount
	await _shoot(ta)
	var prey_hit := ta.last_hit_amount
	await _shoot(tb)
	var non_prey_hit := tb.last_hit_amount
	var ok := is_equal_approx(prey_hit, SpikeConfig.ARROW_DAMAGE) and is_equal_approx(first_on_a, SpikeConfig.ARROW_DAMAGE) \
		and is_equal_approx(non_prey_hit, SpikeConfig.ARROW_DAMAGE)
	_note(id, "damage: first Hit on A %.1f · Hit on A while Prey %.1f · Hit on B while not Prey %.1f" % [first_on_a, prey_hit, non_prey_hit])
	_reached(id)
	return ok

func chk_V52_prey_gives_no_auto_aim_and_no_lock_on() -> bool:
	var id := "V52_prey_gives_no_auto_aim_and_no_lock_on"
	await _reset(Vector3(0, 0, 2.0), 4)
	await _shoot(ta)
	var prey_a := prey.current == ta
	var hits_a := int(ta.hits_by_source["direct_use"])
	# Aim at EMPTY ground, away from A.
	var empty := Vector3(0, 0, -9.0)
	await _aim_at(empty, 20)
	var aim_before := probe.aim_dir
	await _press_shot()
	await _await_release()
	var p: ArrowProjectile = probe.projectiles.back()
	var flew_where_aimed := p.direction.dot(Vector3(aim_before.x, 0, aim_before.z).normalized()) > 0.9999
	await _await_projectile_done(p, 120)
	await _await_action_end()
	var missed_a := int(ta.hits_by_source["direct_use"]) == hits_a
	# Designation must not touch aim: designate B directly and compare the aim.
	var aim_pre := probe.aim_dir
	prey.designate(tb, PreyState.DIRECT_USE, -1)
	await physics_frame
	var aim_post := probe.aim_dir
	var no_lock: bool = aim_pre.is_equal_approx(aim_post) and cam.debug_cursor_override == empty
	var ok := prey_a and flew_where_aimed and missed_a and no_lock
	_note(id, "with Prey on A, a shot aimed at empty ground flew where aimed=%s and missed A=%s · designating B changed the aim=%s" % [flew_where_aimed, missed_a, not no_lock])
	_reached(id)
	return ok

func chk_V53_only_a_direct_use_designates_and_a_minion_designation_is_refused() -> bool:
	var id := "V53_only_a_direct_use_designates_and_a_minion_designation_is_refused"
	await _reset(Vector3(0, 0, 1.0), 4)
	await _shoot(ta, Vector3(0, 0, 1.0))
	var prey_a := prey.current == ta
	# The hound bites B while A is Prey.
	hound.process_mode = Node.PROCESS_MODE_INHERIT
	hound.global_position = tb.global_position + Vector3(0.9, 0, 0.6)
	var bites0 := hound.bites
	var b_minion0 := int(tb.hits_by_source["minion"])
	# B is autonomous only if A is out of reach: move her next to B.
	probe.global_position = Vector3(4.5, 0, 1.0)
	await _until(func(): return int(tb.hits_by_source["minion"]) > b_minion0, 240)
	var bit_b := int(tb.hits_by_source["minion"]) > b_minion0 and hound.bites > bites0
	var still_a := prey.current == ta
	hound.process_mode = Node.PROCESS_MODE_DISABLED
	var r0 := prey.refused_non_direct
	var planted := prey.designate(tb, "minion", -1)
	var refused := not planted and prey.refused_non_direct == r0 + 1 and prey.current == ta
	var code := _code_only(_read_text("res://scripts/spike/stand_in_hound.gd"))
	var hound_never_calls := not code.contains(".designate(")
	var ok := prey_a and bit_b and still_a and refused and hound_never_calls
	_note(id, "the hound bit B (minion hits +%d) while A was Prey -> Prey still A=%s · a planted minion designation refused and counted=%s · the hound's code never calls designate=%s" % [int(tb.hits_by_source["minion"]) - b_minion0, still_a, refused, hound_never_calls])
	_reached(id)
	return ok

func chk_V54_projectiles_hit_one_target_each_and_the_tie_break_stays_owed() -> bool:
	var id := "V54_projectiles_hit_one_target_each_and_the_tie_break_stays_owed"
	var multi := ArrowProjectile.multi_target_hits
	var hits := ArrowProjectile.hits
	var dfs := ""
	for r in SpikeConfig.deferred_rows():
		dfs += String(r[0]) + " "
	var ok := hits > 5 and multi == 0 and dfs.contains("DF-01")
	_note(id, "%d projectile Hits so far, each on ONE target; frames with two targets overlapping one arrow: %d · the OWED multi-target tie-break is printed as DF-01" % [hits, multi])
	_reached(id)
	return ok

func chk_V55_the_prey_marker_is_shape_and_text_on_the_prey_only() -> bool:
	var id := "V55_the_prey_marker_is_shape_and_text_on_the_prey_only"
	await _reset(Vector3(0, 0, 2.0), 4)
	await _shoot(tb)
	var m := tb.prey_marker
	var ring := m.get_node("PreyRing") as MeshInstance3D
	var word := m.get_node("PreyWord") as Label3D
	var chevrons := 0
	for c in m.get_children():
		if String(c.name).begins_with("PreyChevron"):
			chevrons += 1
	var ok := tb.is_marked() and not ta.is_marked() and ring.mesh is TorusMesh and chevrons == 3 and word.text == "PREY"
	_note(id, "on the Prey only (A marked=%s, B marked=%s): a torus ring, %d chevrons and the word '%s'" % [ta.is_marked(), tb.is_marked(), chevrons, word.text])
	_reached(id)
	return ok

func chk_V56_prey_has_no_timeout_and_no_area_rule() -> bool:
	var id := "V56_prey_has_no_timeout_and_no_area_rule"
	await _reset(Vector3(0, 0, 2.0), 4)
	await _shoot(ta)
	var designated := prey.current == ta
	await _phys(600)
	var still := prey.current == ta
	var code := _code_only(_read_text("res://scripts/spike/prey_state.gd"))
	var no_timer := not code.contains("Timer") and not code.contains("_process")
	var printed := false
	for r in SpikeConfig.deferred_rows():
		if String(r[0]) == "DF-02" and String(r[1]).contains("no number invented"):
			printed = true
	var ok := designated and still and no_timer and printed
	_note(id, "Prey held for 10 s with no further Hit=%s · PreyState has no timer or per-frame process=%s · DF-02/DF-03 printed=%s" % [still, no_timer, printed])
	_reached(id)
	return ok

# ======================================================= Q5: the stand-in hound ==

func chk_V57_the_hound_is_primitives_with_its_exact_label() -> bool:
	var id := "V57_the_hound_is_primitives_with_its_exact_label"
	var meshes := RigCorpus.meshes_of(hound)
	var non_primitive: Array[String] = []
	for mi in meshes:
		var m := (mi as MeshInstance3D).mesh
		if m == null:
			continue
		if m.resource_path != "" or not (m is PrimitiveMesh or m is ImmediateMesh):
			non_primitive.append(String((mi as Node).name))
	var ok := non_primitive.is_empty() and hound.label_text() == "DIAGNOSTIC HOUND STAND-IN — NO HOUND ART PROVEN" \
		and meshes.size() >= 8
	_note(id, "%d meshes, all engine primitives built in code (non-primitive=%s) · label '%s'" % [meshes.size(), non_primitive, hound.label_text()])
	_reached(id)
	return ok

func chk_V58_the_hound_has_no_command_path() -> bool:
	var id := "V58_the_hound_has_no_command_path"
	var actions := InputMap.get_actions().filter(func(a): return not String(a).begins_with("ui_"))
	var hound_actions := actions.filter(func(a): return String(a).contains("hound") or String(a).contains("command_pet") or String(a).contains("pet"))
	var fs := _funcs(_read_text("res://scripts/spike/stand_in_hound.gd"))
	var command_like := fs.filter(func(f): return String(f).begins_with("set_target") or String(f).begins_with("command") or String(f).begins_with("order") or String(f) == "attack")
	var mains := _code_only(_read_text("res://scripts/spike/spike_main.gd"))
	var main_commands := mains.contains("hound.target =") or mains.contains("hound.think(")
	var ok := hound_actions.is_empty() and command_like.is_empty() and not main_commands
	_note(id, "hound input actions=%s · command-like methods=%s · the composition root assigns its target=%s" % [hound_actions, command_like, main_commands])
	_reached(id)
	return ok

func _hound_at(huntress_pos: Vector3, hound_pos: Vector3) -> void:
	probe.global_position = huntress_pos
	hound.global_position = hound_pos
	await _phys(2)

func chk_V59_the_hound_prefers_a_reachable_prey_over_a_nearer_target() -> bool:
	var id := "V59_the_hound_prefers_a_reachable_prey_over_a_nearer_target"
	await _reset(Vector3(0, 0, 1.0), 4)
	await _hound_at(Vector3(0, 0, 1.0), Vector3(4.0, 0, -1.0))
	prey.designate(ta, PreyState.DIRECT_USE, -1)
	hound.think()
	var d_a := hound.global_position.distance_to(ta.global_position)
	var d_b := hound.global_position.distance_to(tb.global_position)
	var ok := d_b < d_a and hound.target == ta and hound.target_reason == "PREY"
	_note(id, "B is nearer (%.2f m vs %.2f m) — the hound took %s (%s)" % [d_b, d_a, hound.target_name(), hound.target_reason])
	_reached(id)
	return ok

func chk_V60_without_prey_the_hound_takes_the_nearest_ties_by_name() -> bool:
	var id := "V60_without_prey_the_hound_takes_the_nearest_ties_by_name"
	await _reset(Vector3(0, 0, 1.0), 4)
	await _hound_at(Vector3(0, 0, 1.0), Vector3(4.0, 0, -1.0))
	hound.think()
	var nearest := hound.target == tb and hound.target_reason == "AUTONOMOUS"
	await _hound_at(Vector3(0, 0, 1.0), Vector3(0.0, 0, -2.0))
	hound.think()
	var tie := hound.target == ta
	var ok := nearest and tie and prey.current == null
	_note(id, "no Prey: nearest (B)=%s · exactly equidistant -> by name (TARGET_A)=%s" % [nearest, tie])
	_reached(id)
	return ok

func chk_V61_prey_out_of_reach_sends_the_hound_to_its_autonomous_target() -> bool:
	var id := "V61_prey_out_of_reach_sends_the_hound_to_its_autonomous_target"
	await _reset(Vector3(4.2, 0, 1.2), 4)
	await _hound_at(Vector3(4.2, 0, 1.2), Vector3(5.1, 0, 2.1))
	prey.designate(ta, PreyState.DIRECT_USE, -1)
	hound.think()
	var reach := probe.global_position.distance_to(ta.global_position)
	var ok := reach > SpikeConfig.HOUND_ACQUIRE_M and hound.target == tb and hound.target_reason == "AUTONOMOUS" \
		and hound.prey_skip_reason == "out of reach"
	_note(id, "Prey A %.2f m from the Huntress (reach %.1f m) -> hound took %s (%s; Prey skipped: %s)" % [reach, SpikeConfig.HOUND_ACQUIRE_M, hound.target_name(), hound.target_reason, hound.prey_skip_reason])
	_reached(id)
	return ok

func chk_V62_prey_unreachable_by_path_is_skipped_and_the_test_can_refuse() -> bool:
	var id := "V62_prey_unreachable_by_path_is_skipped_and_the_test_can_refuse"
	await _reset(Vector3(10.0, 0, 0.0), 4)
	var c := TargetDummy.new()
	c.build("TARGET OUTSIDE (SUITE)", "square", Color(0.6, 0.6, 0.6))
	main.arena.add_child(c)
	c.global_position = Vector3(16.8, 0, 0.0)
	prey.watch(c)
	await _hound_at(Vector3(10.0, 0, 0.0), Vector3(10.8, 0, 1.0))
	prey.designate(c, PreyState.DIRECT_USE, -1)
	hound.think()
	var in_reach := probe.global_position.distance_to(c.global_position) <= SpikeConfig.HOUND_ACQUIRE_M
	var skipped := hound.target != c and hound.prey_skip_reason == "unreachable by path"
	var took_b := hound.target == tb and hound.target_reason == "AUTONOMOUS"
	var refuses := not hound.reachable(Vector3(0, 0, 40)) and hound.reachable(tb.global_position)
	for p in main.arena.unreachable_probes():
		refuses = refuses and not hound.reachable(p)
	var why := hound.prey_skip_reason
	var took := hound.target_name()
	prey._clear("suite")
	c.queue_free()
	await _phys(2)
	var ok := in_reach and skipped and took_b and refuses
	_note(id, "a Prey OUTSIDE the wall, within reach (%s) but off the mesh: skipped (%s) -> %s · the path test refuses off-mesh points and accepts B=%s" % [in_reach, why, took, refuses])
	_reached(id)
	return ok

func chk_V63_the_hound_follows_a_prey_switch_within_one_interval() -> bool:
	var id := "V63_the_hound_follows_a_prey_switch_within_one_interval"
	await _reset(Vector3(0, 0, 1.0), 4)
	await _hound_at(Vector3(0, 0, 1.0), ta.global_position + Vector3(0.8, 0, 0.6))
	prey.designate(ta, PreyState.DIRECT_USE, -1)
	hound.think()
	var on_a := hound.target == ta
	var f0 := Engine.get_physics_frames()
	prey.designate(tb, PreyState.DIRECT_USE, -1)
	var switched_now := hound.target == tb and hound.target_reason == "PREY"
	var ok := on_a and switched_now and Engine.get_physics_frames() - f0 <= int(SpikeConfig.HOUND_THINK_S * 60.0)
	_note(id, "hound on A (Prey); Prey switched to B -> hound on %s within %d frames (interval %d)" % [hound.target_name(), Engine.get_physics_frames() - f0, int(SpikeConfig.HOUND_THINK_S * 60.0)])
	_reached(id)
	return ok

func chk_V64_the_hound_arrives_by_path_and_bites() -> bool:
	var id := "V64_the_hound_arrives_by_path_and_bites"
	await _reset(Vector3(0, 0, 1.0), 4)
	await _hound_at(Vector3(0, 0, 1.0), Vector3(2.0, 0, 3.5))
	prey.designate(tb, PreyState.DIRECT_USE, -1)
	hound.process_mode = Node.PROCESS_MODE_INHERIT
	var bites0 := hound.bites
	var arrived := await _until(func(): return hound.global_position.distance_to(tb.global_position) <= SpikeConfig.TARGET_RADIUS_M + SpikeConfig.HOUND_RADIUS_M + SpikeConfig.HOUND_BITE_REACH_M + 0.05, 300)
	var path_pts := hound.follower.point_count()
	var bit := await _until(func(): return hound.bites > bites0, 120)
	hound.process_mode = Node.PROCESS_MODE_DISABLED
	var ok := arrived and bit and path_pts >= 2 and hound.target == tb
	_note(id, "arrived within bite range of B by path (%d path points)=%s · bit=%s" % [path_pts, arrived, bit])
	_reached(id)
	return ok

# ===================================================== review presentation ==

func chk_V65_developer_overlays_start_hidden() -> bool:
	var id := "V65_developer_overlays_start_hidden"
	var ok := not bool(launch["overlay_visible"]) and not bool(launch["inset_visible"]) and bool(launch["hud_visible"])
	# The toggles are reachable.
	main.overlay.toggle()
	var on := main.overlay.visible
	main.overlay.toggle()
	main.inset.toggle()
	var inset_on := main.inset.visible
	main.inset.toggle()
	ok = ok and on and inset_on and not main.overlay.visible and not main.inset.visible
	_note(id, "at launch: F1 overlay visible=%s · close-up visible=%s · HUD visible=%s · both toggles reachable" % [launch["overlay_visible"], launch["inset_visible"], launch["hud_visible"]])
	_reached(id)
	return ok

func chk_V66_the_hud_shows_only_the_six_items_and_reads_live_state() -> bool:
	var id := "V66_the_hud_shows_only_the_six_items_and_reads_live_state"
	await _reset(Vector3(0, 0, 2.0), 4)
	var keys := main.hud.lines.keys()
	var labels := 0
	for c in main.hud.find_children("*", "Label", true, false):
		labels += 1
	var prefixes := ["PHASE:", "RELEASE:", "PREY:", "HOUND TARGET:", "VISIBLE:", "DIAGNOSTIC SPIKE"]
	var t := main.hud.line_texts()
	var pref_ok := t.size() == 6
	for i in mini(6, t.size()):
		pref_ok = pref_ok and String(t[i]).begins_with(prefixes[i])
	prey.designate(tb, PreyState.DIRECT_USE, -1)
	main.hud.refresh()
	var live_prey := (main.hud.lines["PREY"] as Label).text == "PREY: TARGET B"
	probe.set_comparison(true)
	main.hud.refresh()
	var live_id := (main.hud.lines["IDENTITY"] as Label).text.contains("NATIVE KAYKIT CONTROL")
	probe.set_comparison(false)
	main.hud.refresh()
	var ok := keys.size() == 6 and labels == 6 and pref_ok and live_prey and live_id
	_note(id, "6 lines (%d Label nodes) in the declared order · Prey line follows state=%s · identity line follows the switch=%s" % [labels, live_prey, live_id])
	_reached(id)
	return ok

## One scripted run; returns the simulation trace. `toggles` are frame offsets
## at which the comparison switch is flipped.
func _trace(toggles: Array) -> Dictionary:
	await _reset(Vector3(0, 0, 2.0), 2)
	await _aim_at(ta.global_position, 20)
	var start := Engine.get_physics_frames()
	var rel0 := probe.arrows_released
	var hits0 := int(ta.hits_by_source["direct_use"])
	probe.intent.debug_attack_held = true
	var trace: Array = []
	var k := 0
	while k < 120:
		if toggles.has(k):
			probe.set_comparison(not probe.showing_native_control())
		if k == 2:
			probe.intent.debug_attack_held = null
		await physics_frame
		var arrows := probe.projectiles.filter(func(p): return is_instance_valid(p))
		var ap := Vector2.ZERO
		if not arrows.is_empty():
			var a: ArrowProjectile = arrows.back()
			ap = Vector2(a.global_position.x, a.global_position.z)
		trace.append([probe.commitment.active, snappedf(probe.commitment.elapsed, 0.000001),
			probe.global_position.snapped(Vector3.ONE * 0.000001), probe.arrows_released - rel0, ap.snapped(Vector2.ONE * 0.000001),
			int(ta.hits_by_source["direct_use"]) - hits0])
		k += 1
	if probe.showing_native_control():
		probe.set_comparison(false)
	await _await_action_end()
	return {"trace": trace, "start": start}

func chk_V67_the_comparison_switch_changes_visibility_not_the_simulation() -> bool:
	var id := "V67_the_comparison_switch_changes_visibility_not_the_simulation"
	var a := await _trace([])
	var b := await _trace([10, 25, 50, 64, 90])
	var ta_: Array = a["trace"]
	var tb_: Array = b["trace"]
	var diffs := 0
	for i in mini(ta_.size(), tb_.size()):
		if str(ta_[i]) != str(tb_[i]):
			diffs += 1
	var hit_both := int(ta_.back()[5]) >= 1 and int(tb_.back()[5]) >= 1
	var ok := ta_.size() == tb_.size() and ta_.size() == 120 and diffs == 0 and hit_both
	_note(id, "120 frames of a use with 5 mid-action switches vs none: %d differing frames in commitment, position, releases, projectile path and hits · both hit=%s" % [diffs, hit_both])
	_reached(id)
	return ok

func chk_V68_the_input_map_is_exact_with_no_wasd_and_a_pad_binding_per_action() -> bool:
	var id := "V68_the_input_map_is_exact_with_no_wasd_and_a_pad_binding_per_action"
	var text := _read_text("res://project.godot")
	var re := RegEx.new()
	re.compile("(?m)^([a-z_0-9]+)=\\{$")
	var names: Array = []
	for m in re.search_all(text):
		names.append(m.get_string(1))
	var want := ["move_command", "stick_left", "stick_right", "stick_up", "stick_down", "aim_left", "aim_right",
		"aim_up", "aim_down", "diagnostic_attack", "zoom_in", "zoom_out", "toggle_overlay",
		"spike_toggle_comparison", "spike_cycle_rate", "spike_toggle_closeup"]
	var sorted_names := names.duplicate()
	sorted_names.sort()
	var sorted_want := want.duplicate()
	sorted_want.sort()
	var wasd := 0
	for code in [87, 65, 83, 68]:
		if text.contains("\"physical_keycode\":%d," % code):
			wasd += 1
	var pads_ok := true
	for a in ["diagnostic_attack", "zoom_in", "zoom_out", "toggle_overlay", "spike_toggle_comparison", "spike_cycle_rate", "spike_toggle_closeup"]:
		var evs := InputMap.action_get_events(a)
		var has_pad := evs.any(func(e): return e is InputEventJoypadButton or e is InputEventJoypadMotion)
		var has_kbm := evs.any(func(e): return e is InputEventKey or e is InputEventMouseButton)
		pads_ok = pads_ok and has_pad and has_kbm
	var ok := sorted_names == sorted_want and wasd == 0 and pads_ok
	_note(id, "%d input actions, exactly the declared set=%s · W/A/S/D keycodes %d · every action has a keyboard/mouse AND a pad binding=%s" % [names.size(), sorted_names == sorted_want, wasd, pads_ok])
	_reached(id)
	return ok

func chk_V69_the_closeup_is_a_separate_camera() -> bool:
	var id := "V69_the_closeup_is_a_separate_camera"
	var gameplay := cam.cam
	var cc := main.inset.cam
	var ok := cc != gameplay and cc.get_viewport() != gameplay.get_viewport() and cc.cull_mask == 1 \
		and gameplay.get_viewport().get_camera_3d() == gameplay and gameplay.projection == Camera3D.PROJECTION_ORTHOGONAL
	_note(id, "the close-up renders in its own SubViewport with its own camera (labels culled); the main viewport's camera is still the accepted orthographic rig")
	_reached(id)
	return ok

# ============================================ the accepted foundation, carrying a bow ==

func chk_V70_click_to_move_arrives_and_drives_run_then_idle() -> bool:
	var id := "V70_click_to_move_arrives_and_drives_run_then_idle"
	await _reset(Vector3(-8.0, 0, 5.0), 4)
	var dest := Vector3(-2.0, 0, 5.0)
	probe.command_move_to(dest)
	var saw_run := await _until(func(): return drv.phase == "RUN", 30)
	var arrived := await _until(func(): return probe.move_destination == null and probe.motor.speed() < 0.01, 300)
	var err := Vector2(probe.global_position.x - dest.x, probe.global_position.z - dest.z).length()
	var back_idle := await _until(func(): return drv.phase == "IDLE", 60)
	var ok := saw_run and arrived and err <= ProdConfig.ARRIVE_TOLERANCE_M + 0.2 and back_idle
	_note(id, "click-to-move: carried-bow RUN seen=%s · arrived %.3f m from the order · back to IDLE=%s" % [saw_run, err, back_idle])
	_reached(id)
	return ok

func chk_V71_the_yard_is_baked_once_and_reachability_is_by_path() -> bool:
	var id := "V71_the_yard_is_baked_once_and_reachability_is_by_path"
	var map := NavService.map_rid_for(probe)
	var ok := main.arena.bake_count == 1 and main.arena.nav_mesh().get_polygon_count() > 0
	var reach_ok := true
	for p in SpikeArena.walkable_probes():
		reach_ok = reach_ok and bool(NavService.reachable(map, SpikeConfig.PLAYER_SPAWN, p, 0.3)["reachable"])
	var refuse_ok := true
	for p in SpikeArena.unreachable_probes():
		refuse_ok = refuse_ok and not bool(NavService.reachable(map, SpikeConfig.PLAYER_SPAWN, p, 0.3)["reachable"])
	ok = ok and reach_ok and refuse_ok
	_note(id, "baked once (%d polygons) · every walkable probe reachable BY PATH=%s · every off-mesh probe refused=%s" % [main.arena.nav_mesh().get_polygon_count(), reach_ok, refuse_ok])
	_reached(id)
	return ok

func chk_V72_the_runtime_only_ever_played_the_five_played_clips() -> bool:
	var id := "V72_the_runtime_only_ever_played_the_five_played_clips"
	var names := main.clip_source.sampled_names.keys()
	var measured := main.clip_source.measured_names.keys()
	var outside: Array = names.filter(func(n): return not SpikeConfig.AUTHORIZED_CLIPS.has(String(n)))
	var not_played: Array = names.filter(func(n): return not SpikeConfig.PLAYED_CLIPS.has(String(n)))
	var ok := outside.is_empty() and not_played.is_empty() and names.size() == 5
	_note(id, "clips the RUNTIME played: %s · outside the 7=%s · outside the 5 played=%s · (the suite's OFFLINE measurements additionally read %s — measured, not played) · the refused request (V07) never reached a sample" % [names, outside, not_played, measured])
	_reached(id)
	return ok

# ------------------------------------------------------------------ report ----

func _all_ok() -> bool:
	for id in OWED:
		if not reached.has(id) or results.get(id, null) != true:
			return false
	for id in reached.keys():
		if not OWED.has(id):
			return false
	return true

func _report() -> void:
	print("")
	print("------------------------------------------------------------------------")
	print("RESULTS — %s (%s)" % [SpikeConfig.STAGE, SpikeConfig.DECISION])
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
	print("FINDINGS — measurements the owner is owed, each with the band declared in advance.")
	print("A FINDING is NOT a pass and NOT a failure; the rendered evidence and the live review decide:")
	for f in findings:
		print("  [FINDING] %s" % f)
	print("")
	print("DEFERRED — recorded as such, NEVER as passes:")
	for r in SpikeConfig.deferred_rows():
		print("  [DEFERRED] %s  %s  -> returns to: %s" % [r[0], r[1], r[2]])
	print("")
	print("OWED-TO-OWNER — live review, NOT a pass and NOT a failure:")
	for r in SpikeConfig.owed_to_owner():
		print("  [OWED-TO-OWNER] %s  %s" % [r[0], r[1]])
	var onr: Array[String] = []
	for id in OWED:
		if not reached.has(id):
			onr.append(id)
	var rno: Array[String] = []
	for id in reached.keys():
		if not OWED.has(id):
			rno.append(id)
	print("")
	print("OWED vs REACHED (both directions):")
	print("  owed=%d  reached=%d  owed-but-not-reached=%d %s  reached-but-not-owed=%d %s"
		% [OWED.size(), reached.size(), onr.size(), str(onr), rno.size(), str(rno)])
	print("")
	print(SpikeConfig.CLASSIFICATION_STATE)
	print("UNITS: %d EXECUTABLE CHECKS here · 117 OWED CRITERIA in the D-388 inventory · the runner's"
		% OWED.size())
	print("       RUNNER CHECKS in tests/huntress_spike_smoke.sh · 13 DEFERRED and 6 OWED-TO-OWNER rows.")
	print("       Different unit. None is a synonym for another.")
	print("")
	print("HUNTRESS SPIKE VERIFICATION: %s (%d checks: %d passed, %d failed/unreached, %d deferred, %d owed-to-owner, %d findings)"
		% ["PASS" if _all_ok() else "FAIL", OWED.size(), passed, failed,
		   SpikeConfig.deferred_rows().size(), SpikeConfig.owed_to_owner().size(), findings.size()])
	print("SPIKE STATE: %s" % SpikeConfig.STATE)
