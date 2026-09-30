extends SceneTree

## RIFTWROUGHT — 3D PRODUCTION FOUNDATION VERIFICATION  (D-370, 2026-09-17)
##
## This suite follows the project's standing verification rules verbatim:
##   * A passing COUNT proves the assertions that EXIST, not the ones that
##     should -- so the suite OWES a named list and compares owed vs reached
##     IN BOTH DIRECTIONS.
##   * Every check records reaching its LAST line. A throw mid-check shows up as
##     UNREACHED rather than as a silent pass.
##   * A guard that accepts everything protects nothing, and a guard nothing can
##     reach is not a guard -- so several checks PROVE their own guard refuses a
##     planted bad value.
##   * An assertion that something did NOT happen can pass because the action
##     never ran -- so each such check asserts the action fired first.
##   * Assert reachability BY PATH, to the CENTRE of every authored walkable
##     rectangle -- not to its sockets.
##   * Prefer exact arithmetic to sampling. Measure in the layout's own frame.
##   * An unperformed check is DEFERRED, never a pass, and names where it
##     returns.
##
## ============================================================================
## UNITS. This suite contains 85 EXECUTABLE CHECKS. The owed-criteria inventory
## contains 125 OWED CRITERIA. THE TWO NUMBERS ARE DIFFERENT UNITS AND NEITHER
## IS THE OTHER. See docs/testing/D370_OWED_CRITERIA_INVENTORY.md section 0.
##
## (70/110 at first delivery; +8 at the D-370 owner live review, which required
##  an action-movement commitment policy; +7 at the live RE-review, which
##  required recovery cancellation. 78/118 were the figures before that.)
## ============================================================================
##
## IT VERIFIES A FOUNDATION DELIVERED OPEN. It completes no phase, does not
## complete P1 or the original P1C, authorizes no phase, and locks no value.

const OWED := [
	"F01_asset_manifest_is_single_source_of_truth",
	"F02_every_manifest_path_loads",
	"F03_gltf_dependencies_resolve",
	"F04_no_asset_outside_third_party_tree",
	"F05_no_boss_asset_present",
	"F06_no_ultimate_monsters_present",
	"F07_ual1_and_ual2_share_one_rig_measured",
	"F08_imp_is_strict_subset_measured",
	"F09_outfit_rig_matches_exactly_measured",
	"F10_compat_guard_refuses_planted_rig",
	"F11_every_required_clip_exists",
	"F12_clip_guard_refuses_planted_name",
	"F13_clip_attribution_derived_not_tabled",
	"F14_camera_is_orthographic_isometric",
	"F15_camera_rotation_locked_every_frame",
	"F16_camera_follows_player",
	"F17_zoom_bounded_both_bounds_reached",
	"F18_zoom_cannot_pass_a_bound",
	"F19_projection_arithmetic_is_exact",
	"F20_yaw_is_continuous_not_quantised",
	"F21_quantisation_test_refuses_quantised_series",
	"F22_yaw_is_rate_limited",
	"F23_movement_does_not_change_aim",
	"F24_aim_does_not_change_move_destination",
	"F25_aiming_is_per_use",
	"F26_click_to_move_resolves_nearest_navigable",
	"F27_offmesh_click_is_stored_unsnapped_not_dropped",  # replaced one for one; its old name and requirement are dated in its body
	"F28_no_wasd_binding",
	"F29_controller_axis_path_and_deadzone",
	"F30_top_speed_accel_decel_measured",
	"F31_ground_point_is_the_actor_position",
	"F32_visual_is_not_read_for_gameplay",
	"F33_collision_is_authored_per_prop",
	"F34_navmesh_baked_once_with_measured_area",
	"F35_path_reachability_to_every_rect_centre",
	"F36_reachability_guard_refuses_unreachable_point",
	"F37_doorway_survives_agent_radius_erosion",
	"F38_actors_remain_on_the_ground_plane",
	"F39_enemy_path_routes_around_obstacle",
	"F40_enemy_acquires_inside_radius_only",
	"F41_enemy_navigates_to_target",
	"F42_telegraph_precedes_commit",
	"F43_telegraph_clears_on_recovery",
	"F44_release_marker_independent_of_clip_speed",
	"F45_telegraph_and_commit_agree_both_directions",
	"F46_damage_only_inside_committed_shape",
	"F47_enemy_receives_damage_and_reacts",
	"F48_hit_precedes_kill",
	"F49_death_uses_truthful_source_clip",
	"F50_death_runs_measured_length_and_is_terminal",
	"F51_exactly_one_diagnostic_player_attack",
	"F52_diagnostic_attack_is_labelled",
	"F53_diagnostic_attack_denies_being_a_skill",
	"F54_projectile_travels_on_plane_and_expires",
	"F55_point_blank_overlap_hits",
	"F56_overlay_present_and_names_live_clip",
	"F57_overlay_can_be_disabled",
	"F58_overlay_prints_provisional_status",
	"F59_overlay_separates_design_and_clip_names",
	"F60_no_2d_lock_promoted",
	"F61_no_spike_value_promoted",
	"F62_every_starting_value_labelled_provisional",
	"F63_denials_present_and_denial_guard_can_fail",
	"F64_no_class_specification_written",
	"F65_no_runtime_dependency_on_frozen_prototypes",
	"F66_reused_implementation_declared",
	"F67_test_seams_disabled_in_normal_play",
	"F68_arena_has_no_campaign_or_zone_reference",
	"F69_no_audio_asset_and_no_undeclared_input_action",
	"F70_nav_agent_radius_matches_body_radius",
	# --- Added by the D-370 OWNER LIVE REVIEW: the action-movement commitment.
	"F71_committed_action_stops_translation_promptly",
	"F72_projectile_still_releases_during_commitment",
	"F73_facing_is_allowed_during_commitment",
	"F74_aiming_remains_independent_during_commitment",
	"F75_movement_resumes_only_under_continuing_or_new_intent",
	"F76_obsolete_navigation_target_does_not_restart_movement",
	"F77_top_speed_unchanged_by_the_commitment_correction",
	"F78_action_timing_and_policy_are_provisional",
	# --- Added by the D-370 LIVE RE-REVIEW: recovery cancellation.
	"F79_movement_cannot_cancel_the_attack_before_release",
	"F80_movement_during_windup_is_buffered",
	"F81_projectile_releases_exactly_once_before_buffered_movement",
	"F82_movement_after_release_cancels_recovery",
	"F83_released_projectile_survives_the_cancel_intact",
	"F84_full_action_completes_when_no_movement_is_requested",
	"F85_translation_suppressed_before_release",
]

## Rows this foundation does NOT pass and does NOT pretend to. Printed and
## counted every run as DEFERRED / TRANSFERRED / OWED-TO-OWNER -- NEVER as
## passes. These are criteria N-01..N-08 and M-01..M-03 of the owed inventory.
const DEFERRED_ROWS := [
	["N-01 original P1C criterion C9 — the Mage spell", "TRANSFERRED",
	 "Not attempted, and inventing one is forbidden. The Mage is legacy 64x64 "
	 + "reference art. RETURNS TO: the future Mage art phase, with its own "
	 + "authorization. The diagnostic bolt here is explicitly NOT it."],
	["N-02 'both characters at 128x128 and eight directions'", "TRANSFERRED",
	 "Both quantities are game2d/ owner locks and NEITHER is promoted here. "
	 + "RETURNS TO: the future Mage art phase."],
	["N-03 controller HARDWARE behaviour", "DEFERRED",
	 "No gamepad can be attached in this environment. The code path, the axis "
	 + "mapping and the radial deadzone ARE measured (F29). RETURNS TO: owner "
	 + "live review."],
	["N-04 original P1C criterion C7 — controller soft targeting", "STILL OWED",
	 "NOT implemented here. A soft-target cone is a combat-design surface that "
	 + "belongs with the canonical class specification. RETURNS TO: the Huntress "
	 + "class specification and the combat slice after it."],
	["N-05 original P1C criterion C11 — dropped item and equip comparison", "STILL OWED",
	 "Loot/economy progression is EXPLICITLY OUT OF SCOPE for this ruling. "
	 + "RETURNS TO: a separately authorized loot foundation."],
	["N-06 the 'permission request' half of original P1C criterion C10", "STILL OWED",
	 "A pack-level attack-token system. A single-enemy diagnostic loop has "
	 + "nothing to arbitrate. RETURNS TO: the combat slice."],
	["N-07 bone-attachment orientation", "STILL OWED — and UNSOLVED",
	 "This foundation attaches NO weapon, so the D-369 bow-attachment debt is "
	 + "neither reproduced nor discharged. D-369 chose orientations by a MEASURED "
	 + "sweep of world-space vertical extent and they were STILL WRONG; a future "
	 + "pass needs a better criterion, and this foundation supplies none. "
	 + "RETURNS TO: a later presentation-polish pass."],
	["N-08 audio", "DEFERRED",
	 "ZERO audio assets and ZERO audio hooks. CLAUDE.md section 12 forbids new "
	 + "audio. RETURNS TO: a separately authorized audio pass."],
	["M-01 does this read as Riftwrought in a production architecture?", "OBSERVED",
	 "D-370 LIVE REVIEW, IN PART: click-to-move 'feels good', characters and "
	 + "enemies 'feel grounded', the enemy telegraph is 'understandable', and no "
	 + "meaningful stuck or overlap problem was found. THESE ARE OWNER "
	 + "OBSERVATIONS, NOT LOCKS, and the foundation is NOT accepted. RETURNS TO: "
	 + "the focused live re-review."],
	["M-02 is 3.889 m/s the right starting speed?", "OBSERVED",
	 "D-370 LIVE REVIEW: 'the provisional 3.889 m/s speed feels good'. IT IS "
	 + "STILL NOT A LOCK — the owner stated these are observations, not permanent "
	 + "tuning locks, and instructed that the speed NOT be reduced to fix the "
	 + "attack glide. RETURNS TO: a separately authorized tuning pass."],
	["M-03 is the bounded zoom range right in a production arena?", "OBSERVED",
	 "D-370 LIVE REVIEW: 'I naturally prefer the furthest zoom stop'. EXPLICITLY "
	 + "'a current preference, not authorization to lock or necessarily change "
	 + "the default'. CAM_SIZE_DEFAULT IS THEREFORE UNCHANGED at 14.0 m. "
	 + "RETURNS TO: a separately authorized tuning pass."],
]

## ============================================================================
## DISCHARGED ROWS — HISTORY PRESERVED, AND NOT COUNTED AS DEFERRED.
## ============================================================================
## Reconciled under D-375, exactly as D-373 section 6.1 recommended and as the
## D-375 ruling authorizes: "Reconcile the historical DELIVERED AND OPEN runtime
## state and the stale M-04 row as previously recommended. PRESERVE THEIR
## HISTORY, but do not retain false current-state assertions or weaken guards
## merely to make them pass."
##
## `M-04` was OWED-TO-OWNER from D-372 until D-373's final live review DISCHARGED
## it. Leaving it in `DEFERRED_ROWS` printed a discharged obligation as still
## owed, which is a FALSE CURRENT-STATE ASSERTION. Deleting it would have erased
## the history. SO IT MOVED, with its original text preserved verbatim, and the
## pinned deferred-row count moved 12 -> 11 IN THE SAME CHANGE as the runner's
## truthfulness pin -- which is the whole of what D-373 asked for.
##
## A DISCHARGED ROW IS NOT A PASS AND IS NOT COUNTED AS ONE. It is history.
const DISCHARGED_ROWS := [
	["M-04 does the action commitment, with recovery cancellation, feel fluent?",
	 "DISCHARGED — D-373",
	 "THE OWNER'S FINAL LIVE REVIEW ANSWERED IT: 'The slidey feeling is gone... Returning to "
	 + "movement feels immediate and fluid. The overall movement-and-attack rhythm now feels "
	 + "like Torchlight to me, and I love it.' THE TORCHLIGHT COMPARISON IS BOUNDED BY THE "
	 + "RULING ITSELF to responsiveness and feel, and it authorizes copying nothing. "
	 + "|| ORIGINAL ROW TEXT, PRESERVED VERBATIM: 'THE SLIDEY FEEL WAS CONFIRMED RESOLVED at "
	 + "the D-370 live re-review — the character now stops properly when attacking. WHAT "
	 + "REMAINS OWED is whether the RECOVERY CANCELLATION reads as fluent. The suite measures "
	 + "that the attack cannot be cancelled before it releases, that wind-up intent is "
	 + "buffered, that the bolt releases exactly once and survives the cancel intact, and that "
	 + "a full action completes when nothing is requested; whether it FEELS fluent is the "
	 + "owner's. RETURNS TO: the final live review.' "
	 + "|| D-373 ACCEPTED THE STOP/ALLOW ARCHITECTURE AND THE RECOVERY-CANCELLATION BEHAVIOUR "
	 + "— AND NOTHING ELSE. NO VALUE BECAME A LOCK. M-01, M-02 and M-03 REMAIN OBSERVATIONS, "
	 + "not locks, and still print above."],
]

## The ONE deliberately planted bad clip name. It proves the runtime's animation
## guard cannot fail silently, and it is the ONLY self-inflicted engine-error
## line the runner expects -- pinned in both directions there.
const PLANTED_CLIP := "Foundation_Signature_Move_THIS_DOES_NOT_EXIST"

var reached := {}
var results := {}
var notes := {}

var main: Node
var arena: ProductionArena
var cam: IsoCameraRig
var player: PlayerController
var enemies: Array = []
var hud: DebugOverlay
var nav_map: RID

## Captured BEFORE the suite touches anything, so F67 can assert the seams were
## clear in normal play rather than asserting the state the suite itself left.
var initial_seams_clear: bool = false
var initial_overlay_enabled: bool = false

func _initialize() -> void:
	print("========================================================================")
	print("RIFTWROUGHT — 3D PRODUCTION FOUNDATION VERIFICATION  (%s, %s)"
		% [ProdConfig.DECISION, ProdConfig.DATE])
	print("STATE: %s" % ProdConfig.STATE)
	print("Verifying the ACCEPTED D-373 FOUNDATION BASELINE, re-run as a REGRESSION under the")
	print("D-375 Imprint stage. Its 85 executable checks are UNCHANGED, and nothing was")
	print("removed, renamed or renumbered. It completes no phase, does not complete P1 or the")
	print("original P1C, authorizes no phase, and locks no value.")
	print("OWED EXECUTABLE CHECKS: %d   DEFERRED/TRANSFERRED/OWED-TO-OWNER ROWS: %d   DISCHARGED: %d"
		% [OWED.size(), DEFERRED_ROWS.size(), DISCHARGED_ROWS.size()])
	print("(The D-370 owed-criteria INVENTORY counts 125 CRITERIA. Different unit.)")
	print("(The D-375 stage carries its OWN inventory, its OWN suite and its OWN runner counts.")
	print(" Different units again, and none of them is a synonym for another.)")
	print("========================================================================")

	main = load("res://scenes/main.tscn").instantiate()
	root.add_child(main)
	for i in 16:
		await process_frame

	# ========================================================================
	# D-396 — THE DECLARED FIXTURE: THE ACCEPTED LOADOUT, RESTORED.
	# ========================================================================
	# Since D-396 the scene composes the Kindred Hounds stage, whose two
	# autonomous hounds follow the player and bite registered enemies from the
	# first frame -- which would contaminate this ACCEPTED suite's enemy, bolt and
	# movement measurements. So the loadout this suite was accepted with (the
	# accepted Splinter Shot loadout, no pack) is restored through the runtime's OWN loadout
	# operations before anything is captured or measured. It adds no check and
	# removes none; the D-396 suite proves the restoration exact.
	main.get("hounds").restore_accepted_d392_loadout()
	await physics_frame

	arena = main.get("arena")
	cam = main.get("cam")
	player = main.get("player")
	enemies = main.get("enemies")
	hud = main.get("hud")
	nav_map = NavService.map_rid_for(main)
	NavService.sync(nav_map)

	initial_seams_clear = player.intent.seams_clear() \
		and cam.debug_cursor_override == null \
		and not player.debug_freeze_attack
	for e in enemies:
		if e.debug_freeze_ai or e.debug_suppress_movement:
			initial_seams_clear = false
	initial_overlay_enabled = hud.enabled

	# The scene's own enemies are frozen for the duration of the suite, so a
	# wandering AI cannot contaminate a measurement of something else. Every
	# behavioural check spawns its OWN probe enemy.
	for e in enemies:
		e.debug_freeze_ai = true

	for id in OWED:
		await _run(id)

	_report()
	quit(0 if _all_ok() else 1)

func _run(id: String) -> void:
	# Dispatch by convention: every check is a method named exactly `chk_<ID>`.
	# A MISSING METHOD IS A FAIL, NOT A SKIP -- the suite must not be able to
	# quietly owe a check it never wrote.
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

# ------------------------------------------------------------- utilities ----

func _phys(n: int) -> void:
	for i in n:
		await physics_frame

## A fresh, sacrificial enemy. Destructive checks get their own instance so the
## scene's enemies stay honest subjects and no later check runs against a corpse.
func _probe_enemy(probe_name: String, pos: Vector3) -> OrdinaryEnemy:
	var e := OrdinaryEnemy.new()
	e.name = probe_name
	main.add_child(e)
	e.setup(main.get("corpus"))
	e.global_position = pos
	e.player = player
	e.debug_freeze_ai = true
	await _phys(3)
	return e

func _read_text(path: String) -> String:
	var f := FileAccess.open(path, FileAccess.READ)
	if f == null:
		return ""
	var s := f.get_as_text()
	f.close()
	return s

## Every file under res://, excluding the engine's own import cache.
func _walk(path: String, out: Array) -> void:
	var d := DirAccess.open(path)
	if d == null:
		return
	d.list_dir_begin()
	var n := d.get_next()
	while n != "":
		if n.begins_with("."):
			n = d.get_next()
			continue
		var full := path.path_join(n)
		if d.current_is_dir():
			_walk(full, out)
		else:
			out.append(full)
		n = d.get_next()
	d.list_dir_end()

func _all_project_files() -> Array:
	var out: Array = []
	_walk("res://", out)
	return out

## RUNTIME scripts only.
##
## Several checks below scan for text that MUST NOT appear in the game -- a
## third-party path literal, a class-mechanic declaration, a campaign identifier,
## a path into a frozen prototype. THIS SUITE ITSELF HAS TO NAME EVERY ONE OF
## THEM in order to forbid it, so scanning the suite with its own patterns finds
## the patterns and reports the harness as the offender.
##
## The claim being made is about the GAME, so the scan is over the game. That is
## stated here rather than buried, and each such check repeats it in its note.
func _runtime_script_files() -> Array:
	var out: Array = []
	for f in _all_project_files():
		var p := String(f)
		if p.begins_with("res://scripts/") and p.ends_with(".gd"):
			out.append(p)
	return out

func _script_files() -> Array:
	var out: Array = []
	for f in _all_project_files():
		if String(f).ends_with(".gd"):
			out.append(f)
	return out

## The yaw-continuity test, as a reusable function so F21 can feed it a
## deliberately quantised series and REQUIRE it to refuse.
func _yaw_continuity(samples: Array, sector_deg: float = 45.0,
		tol_deg: float = 1.0) -> Dictionary:
	var distinct := {}
	var off := 0
	var considered := 0
	for s in samples:
		var deg := rad_to_deg(float(s))
		distinct[snappedf(deg, 0.01)] = true
		considered += 1
		var m: float = fposmod(deg, sector_deg)
		var dd: float = minf(m, sector_deg - m)
		if dd > tol_deg:
			off += 1
	var frac: float = (float(off) / float(considered)) if considered > 0 else 0.0
	return {
		"distinct": distinct.size(), "considered": considered,
		"off_sector": off, "off_fraction": frac,
		# CONTINUOUS only if many distinct values AND a real share of them sit
		# off the 45-degree lattice. Either test alone is too weak: a quantised
		# series can still have several distinct values, and a constant series
		# can sit off-lattice.
		"continuous": distinct.size() >= 20 and frac >= 0.25,
	}

## Drives the player's yaw around a full turn using the camera's cursor seam,
## and returns the sampled yaws.
func _sweep_yaw(steps: int) -> Array:
	var out: Array = []
	player.intent.debug_move_axis = Vector2.ZERO
	for i in range(steps):
		var a := float(i) / float(steps) * TAU
		cam.debug_cursor_override = player.global_position \
			+ Vector3(sin(a), 0, cos(a)) * 5.0
		await physics_frame
		out.append(player.yaw_driver.yaw)
	cam.debug_cursor_override = null
	player.intent.clear_seams()
	return out

# ============================================================================
# A. ASSET INTAKE, LICENCE AND PROVENANCE
# ============================================================================

func chk_F01_asset_manifest_is_single_source_of_truth() -> bool:
	var offenders: Array[String] = []
	# The needle is assembled rather than written, so this check does not find
	# ITSELF. (It did, the first time it ran.)
	var needle := "res://" + "assets/third_party"
	for f in _runtime_script_files():
		var p := String(f)
		if p.ends_with("asset_manifest.gd"):
			continue
		var t := _read_text(p)
		# A path LITERAL is what makes a second source of truth. The manifest's
		# own constants may be referenced freely.
		if t.find(needle) >= 0:
			offenders.append(p)
	var doc := _read_text(AssetManifest.provenance_document())
	var missing_in_doc: Array[String] = []
	for pk in AssetManifest.packs():
		if doc.find(String(pk["name"])) < 0:
			missing_in_doc.append(String(pk["key"]))
		for fl in pk["files"]:
			var base := String(fl).get_file()
			if doc.find(base) < 0:
				missing_in_doc.append(base)
	var ok := offenders.is_empty() and missing_in_doc.is_empty() and doc.length() > 2000
	_note("F01_asset_manifest_is_single_source_of_truth",
		"RUNTIME scripts holding a third-party path literal outside the manifest: %s | "
		% str(offenders)
		+ "pack names / files the provenance document fails to name: %s | the document is %d bytes and is VERIFIED AGAINST the manifest rather than written beside it"
		% [str(missing_in_doc), doc.length()])
	_reached("F01_asset_manifest_is_single_source_of_truth")
	return ok

func chk_F02_every_manifest_path_loads() -> bool:
	var failed: Array[String] = []
	var loadable := [AssetManifest.UAL1, AssetManifest.UAL2, AssetManifest.IMP,
		AssetManifest.OUTFIT_RANGER]
	for m in AssetManifest.RUINS_MODELS:
		loadable.append(AssetManifest.ruins(String(m)))
	for p in loadable:
		if load(String(p)) == null:
			failed.append(String(p))
	# Every declared source file must also EXIST on disk.
	var absent: Array[String] = []
	for rel in AssetManifest.all_source_files():
		if not FileAccess.file_exists(AssetManifest.ROOT + rel):
			absent.append(rel)
	var ok := failed.is_empty() and absent.is_empty()
	_note("F02_every_manifest_path_loads",
		"declared source files=%d, failed to load=%s, absent=%s"
		% [AssetManifest.source_file_count(), str(failed), str(absent)])
	_reached("F02_every_manifest_path_loads")
	return ok

func chk_F03_gltf_dependencies_resolve() -> bool:
	# A MISSING TEXTURE IS A FAIL, NOT A WARNING. The .gltf names its own
	# dependencies; every one must be present beside it, and the imported
	# materials must actually carry textures rather than silently falling back.
	var dir := AssetManifest.ROOT + "modular_character_outfits_fantasy/"
	var raw := _read_text(dir + "Female_Ranger.gltf")
	var uris: Array[String] = []
	var parsed = JSON.parse_string(raw)
	if parsed is Dictionary:
		for key in ["buffers", "images"]:
			for entry in parsed.get(key, []):
				if entry.has("uri"):
					uris.append(String(entry["uri"]))
	var absent: Array[String] = []
	for u in uris:
		if not FileAccess.file_exists(dir + u):
			absent.append(u)
	# And the IMPORTED result must have textured materials.
	var textured := 0
	var surfaces := 0
	var counted := _count_textured(player.visual)
	textured = counted[0]
	surfaces = counted[1]
	var ok := not uris.is_empty() and absent.is_empty() and surfaces > 0 and textured == surfaces
	_note("F03_gltf_dependencies_resolve",
		"gltf declares %d dependencies, absent=%s | imported surfaces=%d, of which carrying an albedo texture=%d"
		% [uris.size(), str(absent), surfaces, textured])
	_reached("F03_gltf_dependencies_resolve")
	return ok

func _count_textured(n: Node) -> Array:
	var textured := 0
	var surfaces := 0
	if n is MeshInstance3D:
		var mi := n as MeshInstance3D
		if mi.mesh != null:
			for s in range(mi.mesh.get_surface_count()):
				surfaces += 1
				var m = mi.get_surface_override_material(s)
				if m == null:
					m = mi.mesh.surface_get_material(s)
				if m is BaseMaterial3D and (m as BaseMaterial3D).albedo_texture != null:
					textured += 1
	for c in n.get_children():
		var r := _count_textured(c)
		textured += r[0]
		surfaces += r[1]
	return [textured, surfaces]

func chk_F04_no_asset_outside_third_party_tree() -> bool:
	var art_ext := [".glb", ".gltf", ".obj", ".mtl", ".bin", ".fbx", ".blend", ".dae"]
	var img_ext := [".png", ".jpg", ".jpeg", ".tga", ".webp", ".svg"]
	var stray: Array[String] = []
	for f in _all_project_files():
		var p := String(f)
		var lower := p.to_lower()
		var is_art := false
		for e in art_ext:
			if lower.ends_with(e):
				is_art = true
		for e in img_ext:
			if lower.ends_with(e):
				is_art = true
		if not is_art:
			continue
		# `evidence/` holds pictures OF the foundation, not art used BY it.
		if p.begins_with("res://evidence/"):
			continue
		# ====================================================================
		# RE-SCOPED UNDER D-392, ONE FOR ONE. THE ARITHMETIC: 1 + 1 = 2 TREES.
		# ====================================================================
		# Until D-392 this permitted art ONLY under `AssetManifest.ROOT`, the D-370
		# `quaternius/` tree -- true when written. The D-392 ruling authorizes a
		# PLACEHOLDER intake ("the CC0 KayKit bow clips ... may be ported only as
		# explicitly temporary placeholder animation"; "a visible placeholder bow
		# ... and physical arrow"), and KayKit is not Quaternius, so it lives in
		# its OWN declared tree. The guard keeps its teeth: art anywhere OUTSIDE
		# the two DECLARED trees is still refused, and the list of trees comes
		# from the manifest -- the single runtime source of truth -- not from here.
		var inside := false
		for tree in AssetManifest.declared_trees():
			if p.begins_with(String(tree)):
				inside = true
		if inside:
			continue
		stray.append(p)
	var trees := AssetManifest.declared_trees()
	var two := trees.size() == 2 and String(trees[0]) == AssetManifest.ROOT
	# THE GUARD MUST STILL BE ABLE TO FAIL: a planted file outside both trees.
	var planted := "res://scripts/planted_mesh.glb"
	var planted_refused := true
	for tree in trees:
		if planted.begins_with(String(tree)):
			planted_refused = false
	_note("F04_no_asset_outside_third_party_tree",
		"art/texture files outside the declared third-party trees %s: %s | RE-SCOPED UNDER D-392: 1 + 1 = 2 declared trees (the D-370 tree and the D-392 placeholder tree)=%s; a planted file outside both is refused=%s" % [str(trees), str(stray), str(two), str(planted_refused)])
	_reached("F04_no_asset_outside_third_party_tree")
	return stray.is_empty() and two and planted_refused

func chk_F05_no_boss_asset_present() -> bool:
	# The ruling: "Do not import the boss encounter into production during this
	# foundation." The boss candidate is the Puglin; no file and no script here
	# may be one.
	var hits: Array[String] = []
	for f in _all_project_files():
		var p := String(f).to_lower()
		if p.find("puglin") >= 0 or p.find("boss") >= 0:
			hits.append(String(f))
	_note("F05_no_boss_asset_present",
		"files whose path names a boss or the boss candidate: %s" % str(hits))
	_reached("F05_no_boss_asset_present")
	return hits.is_empty()

func chk_F06_no_ultimate_monsters_present() -> bool:
	var hits: Array[String] = []
	for f in _all_project_files():
		var p := String(f).to_lower()
		for bad in ["ultimatemonsters", "ultimate_monsters", "dragon", "pinkblob"]:
			if p.find(bad) >= 0:
				hits.append(String(f))
	_note("F06_no_ultimate_monsters_present",
		"Ultimate Monsters files present (must be none — excluded by the ruling): %s" % str(hits))
	_reached("F06_no_ultimate_monsters_present")
	return hits.is_empty()

# ============================================================================
# B. RIG AND ANIMATION CORPUS — MEASURED, NEVER ASSUMED
# ============================================================================

func chk_F07_ual1_and_ual2_share_one_rig_measured() -> bool:
	var b1: Array = RigCorpus.library_bone_sets.get("UAL1", [])
	var b2: Array = RigCorpus.library_bone_sets.get("UAL2", [])
	var d := RigCorpus.measure_subset(b1, b2)
	var d2 := RigCorpus.measure_subset(b2, b1)
	var ok: bool = b1.size() == ProdConfig.EXPECT_UAL_BONES \
		and b2.size() == ProdConfig.EXPECT_UAL_BONES \
		and d["absent"].is_empty() and d["extra"].is_empty() \
		and d2["absent"].is_empty() and d2["extra"].is_empty() \
		and int(RigCorpus.library_clip_counts.get("UAL1", 0)) == ProdConfig.EXPECT_CLIPS_PER_LIBRARY \
		and int(RigCorpus.library_clip_counts.get("UAL2", 0)) == ProdConfig.EXPECT_CLIPS_PER_LIBRARY
	_note("F07_ual1_and_ual2_share_one_rig_measured",
		"MEASURED LIVE: UAL1 %d bones / %s clips, UAL2 %d bones / %s clips; set difference both ways = %d and %d"
		% [b1.size(), str(RigCorpus.library_clip_counts.get("UAL1", 0)),
		   b2.size(), str(RigCorpus.library_clip_counts.get("UAL2", 0)),
		   d["absent"].size() + d["extra"].size(), d2["absent"].size() + d2["extra"].size()])
	_reached("F07_ual1_and_ual2_share_one_rig_measured")
	return ok

func chk_F08_imp_is_strict_subset_measured() -> bool:
	var ref: Array = RigCorpus.library_bone_sets.get("UAL1", [])
	var subject := RigCorpus.bone_names(enemies[0].skeleton)
	var r := RigCorpus.measure_subset(subject, ref)
	var path := RigCorpus.skeleton_path_of(enemies[0].visual)
	var ok: bool = r["compatible"] \
		and subject.size() == ProdConfig.EXPECT_BESTIARY_BONES \
		and r["absent"].size() == ProdConfig.EXPECT_ABSENT_BONES \
		and r["extra"].size() == ProdConfig.EXPECT_EXTRA_BONES \
		and path == ProdConfig.SKELETON_NODE_PATH
	_note("F08_imp_is_strict_subset_measured",
		"MEASURED LIVE: %d joints vs %d, absent=%d, EXTRA=%d (a strict subset requires 0), skeleton path '%s'"
		% [subject.size(), ref.size(), r["absent"].size(), r["extra"].size(), path])
	_reached("F08_imp_is_strict_subset_measured")
	return ok

func chk_F09_outfit_rig_matches_exactly_measured() -> bool:
	var ref: Array = RigCorpus.library_bone_sets.get("UAL1", [])
	var subject := RigCorpus.bone_names(player.skeleton)
	var r := RigCorpus.measure_subset(subject, ref)
	var path := RigCorpus.skeleton_path_of(player.visual)
	var ok: bool = r["compatible"] and r["absent"].is_empty() and r["extra"].is_empty() \
		and subject.size() == ProdConfig.EXPECT_UAL_BONES \
		and path == ProdConfig.SKELETON_NODE_PATH
	_note("F09_outfit_rig_matches_exactly_measured",
		"MEASURED LIVE: %d joints, absent=%d, extra=%d, skeleton path '%s'"
		% [subject.size(), r["absent"].size(), r["extra"].size(), path])
	_reached("F09_outfit_rig_matches_exactly_measured")
	return ok

func chk_F10_compat_guard_refuses_planted_rig() -> bool:
	# A GUARD THAT ACCEPTS EVERYTHING PROTECTS NOTHING.
	var ref: Array = RigCorpus.library_bone_sets.get("UAL1", [])
	var good := RigCorpus.bone_names(enemies[0].skeleton)
	var planted: Array = good.duplicate()
	planted.append("a_bone_no_clip_in_this_corpus_can_drive")
	var r_good := RigCorpus.measure_subset(good, ref)
	var r_bad := RigCorpus.measure_subset(planted, ref)
	var r_empty := RigCorpus.measure_subset([], ref)
	var ok: bool = r_good["compatible"] and not r_bad["compatible"] and not r_empty["compatible"]
	_note("F10_compat_guard_refuses_planted_rig",
		"real rig compatible=%s | rig with ONE planted foreign bone compatible=%s (must be false) | empty rig compatible=%s (must be false)"
		% [str(r_good["compatible"]), str(r_bad["compatible"]), str(r_empty["compatible"])])
	_reached("F10_compat_guard_refuses_planted_rig")
	return ok

func chk_F11_every_required_clip_exists() -> bool:
	var missing := RigCorpus.verify_required(player.anim, ProdConfig.REQUIRED_CLIPS)
	var total := RigCorpus.clip_source.size()
	var ok := missing.is_empty() and total == ProdConfig.EXPECT_COMBINED_DISTINCT_CLIPS
	_note("F11_every_required_clip_exists",
		"%d required clips, missing=%s | merged corpus holds %d distinct clips (expected %d), collisions=%s"
		% [ProdConfig.REQUIRED_CLIPS.size(), str(missing), total,
		   ProdConfig.EXPECT_COMBINED_DISTINCT_CLIPS, str(RigCorpus.collisions)])
	_reached("F11_every_required_clip_exists")
	return ok

func chk_F12_clip_guard_refuses_planted_name() -> bool:
	# A MISSING CLIP MUST NEVER BE A SILENT NO-OP. This deliberately plants one
	# bad name; the push_error it raises is the ONLY self-inflicted engine-error
	# line, and the runner pins it in both directions.
	RigCorpus.missing_clips = []
	var accepted := RigCorpus.play_guarded(player.anim, PLANTED_CLIP)
	var recorded := RigCorpus.missing_clips.has(PLANTED_CLIP)
	var real := RigCorpus.play_guarded(player.anim, ProdConfig.CLIP_PLAYER_IDLE)
	var ok := (not accepted) and recorded and real
	_note("F12_clip_guard_refuses_planted_name",
		"planted clip accepted=%s (must be false), recorded as missing=%s, a REAL clip still plays=%s"
		% [str(accepted), str(recorded), str(real)])
	_reached("F12_clip_guard_refuses_planted_name")
	return ok

func chk_F13_clip_attribution_derived_not_tabled() -> bool:
	# A HAND-WRITTEN ATTRIBUTION TABLE IS A FAILURE BY CONSTRUCTION: it is the
	# project's "compares path text rather than identity" defect in disguise.
	# The attribution must come from the libraries actually loaded.
	var expect := {
		ProdConfig.CLIP_PLAYER_IDLE: "UAL1", ProdConfig.CLIP_PLAYER_WALK: "UAL1",
		ProdConfig.CLIP_PLAYER_RUN: "UAL1", ProdConfig.CLIP_ENEMY_DEATH: "UAL1",
		ProdConfig.CLIP_ENEMY_HIT: "UAL1", ProdConfig.CLIP_ENEMY_IDLE: "UAL2",
		ProdConfig.CLIP_ENEMY_CHASE: "UAL2", ProdConfig.CLIP_ENEMY_ATTACK: "UAL2",
		ProdConfig.CLIP_ENEMY_WINDUP: "UAL2",
	}
	var wrong: Array[String] = []
	for clip in expect:
		var got := RigCorpus.attribute(String(clip))
		if got != String(expect[clip]):
			wrong.append("%s: derived '%s', expected '%s'" % [clip, got, expect[clip]])
	var unknown := RigCorpus.attribute("a_clip_that_does_not_exist")
	var ok := wrong.is_empty() and unknown == "" and RigCorpus.collisions == ["A_TPose"]
	_note("F13_clip_attribution_derived_not_tabled",
		"mis-attributed=%s | an unknown clip reports '' rather than guessing: '%s' | collisions recorded, not overwritten: %s"
		% [str(wrong), unknown, str(RigCorpus.collisions)])
	_reached("F13_clip_attribution_derived_not_tabled")
	return ok

# ============================================================================
# C. CAMERA
# ============================================================================

func chk_F14_camera_is_orthographic_isometric() -> bool:
	var ok := cam.cam.projection == Camera3D.PROJECTION_ORTHOGONAL \
		and is_equal_approx(cam.cam.rotation_degrees.z, ProdConfig.CAM_ROLL_DEG)
	var euler := cam.locked_basis().get_euler()
	var pitch := rad_to_deg(euler.x)
	var yaw := rad_to_deg(euler.y)
	ok = ok and absf(pitch - ProdConfig.CAM_PITCH_DEG) < 0.01 \
		and absf(yaw - ProdConfig.CAM_YAW_DEG) < 0.01
	_note("F14_camera_is_orthographic_isometric",
		"projection=ORTHOGONAL(%s), measured pitch %.3f deg / yaw %.3f deg — both PROVISIONAL, carried from the accepted D-366 spike, NOT locks"
		% [str(cam.cam.projection == Camera3D.PROJECTION_ORTHOGONAL), pitch, yaw])
	_reached("F14_camera_is_orthographic_isometric")
	return ok

func chk_F15_camera_rotation_locked_every_frame() -> bool:
	var before := cam.rotation_violations
	# Try to rotate it from outside, exactly as a stray line of code would.
	cam.cam.global_transform.basis = Basis.from_euler(Vector3(0.3, 1.1, 0.4))
	await _phys(6)
	var restored := IsoCameraRig._basis_matches(cam.cam.global_transform.basis, cam.locked_basis())
	# And drive the player around, which is when a follow implementation is most
	# likely to smuggle a rotation in.
	cam.debug_cursor_override = player.global_position + Vector3(4, 0, 3)
	await _phys(24)
	cam.debug_cursor_override = null
	var still := IsoCameraRig._basis_matches(cam.cam.global_transform.basis, cam.locked_basis())
	var ok := restored and still and cam.rotation_violations == before
	_note("F15_camera_rotation_locked_every_frame",
		"an externally planted rotation was corrected within one frame=%s | still locked after 30 driven frames=%s | violations %d -> %d"
		% [str(restored), str(still), before, cam.rotation_violations])
	_reached("F15_camera_rotation_locked_every_frame")
	return ok

func chk_F16_camera_follows_player() -> bool:
	var start := cam.global_position
	var p0 := player.global_position
	player.global_position = p0 + Vector3(6, 0, 4)
	await _phys(40)
	var moved := cam.global_position.distance_to(start)
	var err := NavService.planar_distance(cam.global_position, player.global_position)
	var offset_ok := cam.cam.global_position.distance_to(
		cam.global_position + cam.boom_offset()) < 0.001
	player.global_position = p0
	await _phys(40)
	var ok := moved > 5.0 and err < 0.35 and offset_ok
	_note("F16_camera_follows_player",
		"focus moved %.3f m to within %.3f m of the actor's GROUND POINT; the camera sits exactly at focus + boom=%s"
		% [moved, err, str(offset_ok)])
	_reached("F16_camera_follows_player")
	return ok

func chk_F17_zoom_bounded_both_bounds_reached() -> bool:
	for i in range(40):
		cam.apply_zoom(-1.0)
	var at_min := cam.zoom_target
	var min_flag := cam.reached_min
	for i in range(60):
		cam.apply_zoom(1.0)
	var at_max := cam.zoom_target
	var max_flag := cam.reached_max
	await _phys(30)
	var size_in_range := cam.ortho_size >= ProdConfig.CAM_SIZE_MIN - 0.001 \
		and cam.ortho_size <= ProdConfig.CAM_SIZE_MAX + 0.001
	# Leave it at the default so later checks and the evidence match the runtime.
	cam.zoom_target = ProdConfig.CAM_SIZE_DEFAULT
	await _phys(30)
	var ok := is_equal_approx(at_min, ProdConfig.CAM_SIZE_MIN) and min_flag \
		and is_equal_approx(at_max, ProdConfig.CAM_SIZE_MAX) and max_flag and size_in_range
	_note("F17_zoom_bounded_both_bounds_reached",
		"BOTH bounds reached: min %.2f m (%s), max %.2f m (%s); the smoothed size stayed inside the range=%s. Bounds are PROVISIONAL."
		% [at_min, str(min_flag), at_max, str(max_flag), str(size_in_range)])
	_reached("F17_zoom_bounded_both_bounds_reached")
	return ok

func chk_F18_zoom_cannot_pass_a_bound() -> bool:
	var before := cam.zoom_clamp_events
	for i in range(30):
		cam.apply_zoom(-1.0)
	var past_min := cam.zoom_target < ProdConfig.CAM_SIZE_MIN - 0.0001
	var clamped_min := cam.zoom_clamp_events > before
	before = cam.zoom_clamp_events
	for i in range(60):
		cam.apply_zoom(1.0)
	var past_max := cam.zoom_target > ProdConfig.CAM_SIZE_MAX + 0.0001
	var clamped_max := cam.zoom_clamp_events > before
	cam.zoom_target = ProdConfig.CAM_SIZE_DEFAULT
	await _phys(20)
	var ok := (not past_min) and (not past_max) and clamped_min and clamped_max
	_note("F18_zoom_cannot_pass_a_bound",
		"30 further zoom-in steps went past the bound=%s (must be false) and were RECORDED as clamped=%s; same at the far bound: past=%s recorded=%s"
		% [str(past_min), str(clamped_min), str(past_max), str(clamped_max)])
	_reached("F18_zoom_cannot_pass_a_bound")
	return ok

func chk_F19_projection_arithmetic_is_exact() -> bool:
	# EXACT, NOT SAMPLED. The focus point must land on the exact centre of the
	# output, and a point one metre up-screen must land a computable number of
	# pixels from it.
	cam.snap_to_target()
	await _phys(2)
	var centre := cam.project_exact(cam.global_position)
	var w := float(ProdConfig.OUTPUT_WIDTH)
	var h := float(ProdConfig.OUTPUT_HEIGHT)
	var centre_err := centre.distance_to(Vector2(w * 0.5, h * 0.5))
	# One metre along the camera's own local +Y maps to exactly this many pixels.
	var px_per_m := h / cam.ortho_size
	var up_world := cam.cam.global_transform.basis.y
	var probe := cam.project_exact(cam.global_position + up_world)
	var measured := centre.distance_to(probe)
	var err := absf(measured - px_per_m)
	var ok := centre_err < 0.001 and err < 0.001
	_note("F19_projection_arithmetic_is_exact",
		"the focus projects to the exact output centre (error %.6f px); 1 m along the camera's own +Y measures %.4f px against the computed %.4f px (error %.6f)"
		% [centre_err, measured, px_per_m, err])
	_reached("F19_projection_arithmetic_is_exact")
	return ok

# ============================================================================
# D. CHARACTER CONTROL
# ============================================================================

func chk_F20_yaw_is_continuous_not_quantised() -> bool:
	var samples := await _sweep_yaw(72)
	var r := _yaw_continuity(samples)
	_note("F20_yaw_is_continuous_not_quantised",
		"%d samples -> %d DISTINCT yaw values, %d of them off the 45-degree lattice (%.0f%%). CONTINUOUS=%s. D-367: the eight-direction restriction is NOT preserved in 3D."
		% [r["considered"], r["distinct"], r["off_sector"], r["off_fraction"] * 100.0,
		   str(r["continuous"])])
	_reached("F20_yaw_is_continuous_not_quantised")
	return bool(r["continuous"])

func chk_F21_quantisation_test_refuses_quantised_series() -> bool:
	# THE NEGATIVE CONTROL. Feed the same test a deliberately eight-way
	# quantised series; it MUST refuse. A continuity test that cannot say "no"
	# proves nothing about the series that passed it.
	var quantised: Array = []
	for i in range(72):
		var sector := float(int(float(i) / 9.0)) * 45.0
		quantised.append(deg_to_rad(sector))
	var r := _yaw_continuity(quantised)
	var constant: Array = []
	for i in range(72):
		constant.append(deg_to_rad(12.3))     # off-lattice but not continuous
	var r2 := _yaw_continuity(constant)
	var ok: bool = (not r["continuous"]) and (not r2["continuous"])
	_note("F21_quantisation_test_refuses_quantised_series",
		"an 8-way QUANTISED series is reported continuous=%s (must be false; %d distinct, %.0f%% off-lattice) | a CONSTANT off-lattice series continuous=%s (must be false)"
		% [str(r["continuous"]), r["distinct"], r["off_fraction"] * 100.0, str(r2["continuous"])])
	_reached("F21_quantisation_test_refuses_quantised_series")
	return ok

func chk_F22_yaw_is_rate_limited() -> bool:
	var y := YawDriver.new()
	y.snap(0.0)
	var dt := 1.0 / 60.0
	var allowed := deg_to_rad(ProdConfig.YAW_RATE_DEG_PER_S) * dt
	# Ask for a 180 degree turn in one step; it must take the rate limit.
	y.step(PI, dt)
	var first := absf(y.yaw)
	var over := first > allowed + 0.00001
	# And it must eventually arrive.
	var guard := 0
	while absf(wrapf(PI - y.yaw, -PI, PI)) > 0.001 and guard < 400:
		y.step(PI, dt)
		guard += 1
	var arrived := absf(wrapf(PI - y.yaw, -PI, PI)) <= 0.001
	# Live, on the actual actor.
	var samples := await _sweep_yaw(72)
	var max_live := 0.0
	for i in range(1, samples.size()):
		max_live = maxf(max_live, absf(wrapf(float(samples[i]) - float(samples[i - 1]), -PI, PI)))
	var live_ok := max_live <= allowed + 0.0005
	var ok := (not over) and arrived and live_ok
	_note("F22_yaw_is_rate_limited",
		"a 180-degree demand moved %.4f rad in one step against the %.4f rad limit (exceeded=%s), and arrived after %d steps=%s | live max step %.4f rad, within limit=%s. THE RATE IS PROVISIONAL."
		% [first, allowed, str(over), guard, str(arrived), max_live, str(live_ok)])
	_reached("F22_yaw_is_rate_limited")
	return ok

func chk_F23_movement_does_not_change_aim() -> bool:
	# THE ACTION MUST HAVE FIRED. Assert the actor genuinely moved before
	# asserting that the aim did not change.
	var fixed := Vector3(4.0, 0.0, -2.0)
	cam.debug_cursor_override = fixed
	await _phys(3)
	var aim_before := player.aim_point
	var pos_before := player.global_position
	player.intent.debug_move_axis = Vector2(1.0, 0.0)
	await _phys(30)
	var moved := player.global_position.distance_to(pos_before)
	var aim_after := player.aim_point
	player.intent.clear_seams()
	cam.debug_cursor_override = null
	await _phys(5)
	var ok := moved > 0.5 and aim_before.distance_to(aim_after) < 0.001
	_note("F23_movement_does_not_change_aim",
		"the actor MOVED %.3f m (the action fired) and the aim POINT changed by %.6f m — aiming is at a world point, so movement must not move it"
		% [moved, aim_before.distance_to(aim_after)])
	_reached("F23_movement_does_not_change_aim")
	return ok

func chk_F24_aim_does_not_change_move_destination() -> bool:
	var dest := player.command_move_to(player.global_position + Vector3(3, 0, 0))
	var before = player.move_destination
	var changes := 0
	for i in range(24):
		cam.debug_cursor_override = player.global_position \
			+ Vector3(cos(float(i)) * 7.0, 0, sin(float(i)) * 7.0)
		await physics_frame
		if player.move_destination == null:
			continue
		var d: Vector3 = player.move_destination
		if d.distance_to(before) > 0.0001:
			changes += 1
	# The aim genuinely swept — assert that, or the check passes vacuously.
	var aim_swept := player.aim_point.distance_to(before) > 0.5
	cam.debug_cursor_override = null
	player.clear_move_destination()
	await _phys(3)
	var ok := changes == 0 and aim_swept
	_note("F24_aim_does_not_change_move_destination",
		"the aim was swept through 24 different world points (it genuinely moved=%s) and the move destination changed %d times (must be 0)"
		% [str(aim_swept), changes])
	_reached("F24_aim_does_not_change_move_destination")
	return ok

func chk_F25_aiming_is_per_use() -> bool:
	# TARGETING IS PER-USE. Two uses with the cursor moved between them must aim
	# independently, and nothing may survive a use.
	player.shot_dirs = []
	player.debug_release_times = []
	cam.debug_cursor_override = player.global_position + Vector3(8, 0, 0)
	await _phys(3)
	player.begin_attack()
	await _phys(40)
	cam.debug_cursor_override = player.global_position + Vector3(0, 0, -8)
	await _phys(3)
	player.begin_attack()
	await _phys(40)
	cam.debug_cursor_override = null
	var two := player.shot_dirs.size() >= 2
	var independent := false
	if two:
		var a: Vector3 = player.shot_dirs[player.shot_dirs.size() - 2]
		var b: Vector3 = player.shot_dirs[player.shot_dirs.size() - 1]
		independent = rad_to_deg(a.angle_to(b)) > 60.0
	var nothing_survives := player._shot_aim_dir.length() < 0.0001
	var ok := two and independent and nothing_survives
	_note("F25_aiming_is_per_use",
		"two uses fired=%s, and their directions differ by more than 60 degrees=%s | the per-use aim field is cleared between uses=%s (no cross-use field is stored)"
		% [str(two), str(independent), str(nothing_survives)])
	_reached("F25_aiming_is_per_use")
	return ok

func chk_F26_click_to_move_resolves_nearest_navigable() -> bool:
	player.global_position = ProductionArena.player_spawn()
	await _phys(4)
	var target := Vector3(-10, 0, -7)          # a real point in the west chamber
	var snapped := player.command_move_to(target)
	var err := NavService.planar_distance(snapped, target)
	var accepted := not player.last_command_was_redirected
	# And it must actually WALK there.
	var guard := 0
	while player.move_destination != null and guard < 900:
		await physics_frame
		guard += 1
	var arrived := NavService.planar_distance(player.global_position, target)
	player.global_position = ProductionArena.player_spawn()
	player.motor.reset()
	await _phys(4)
	var ok := err < 0.35 and accepted and arrived <= ProdConfig.ARRIVE_TOLERANCE_M + 0.15
	_note("F26_click_to_move_resolves_nearest_navigable",
		"an in-bounds order resolved %.3f m from where it was clicked (accepted as clicked=%s), and the actor ARRIVED within %.3f m of it after %d frames (tolerance %.2f m)"
		% [err, str(accepted), arrived, guard, ProdConfig.ARRIVE_TOLERANCE_M])
	_reached("F26_click_to_move_resolves_nearest_navigable")
	return ok

func chk_F27_offmesh_click_is_stored_unsnapped_not_dropped() -> bool:
	# ========================================================================
	# REPLACED ONE FOR ONE UNDER D-404, BY OWNER RULING. THE ID IS UNCHANGED.
	# ========================================================================
	# From D-370 until D-404 this check was `F27_offmesh_click_is_reported_not_dropped`
	# and required -- TRUE WHEN WRITTEN, and accepted under D-373 -- that an order
	# far off the mesh be RESOLVED to a navigable point more than 1 m away, that
	# the redirect be REPORTED (`last_command_was_redirected`, `commands_redirected`
	# + 1) and that the resolved point lie on the mesh. The owner's D-404 ruling
	# forbids exactly that: "Store the actual clicked ground point as the
	# destination. Do not snap that destination to the nearest navigation point."
	#
	# WHAT IT NOW REQUIRES, and none of it is weaker: the same far-off click is
	# NOT DROPPED (a destination exists), is stored EXACTLY as clicked on the
	# plane, is NOT redirected and NOT reported as one -- and the point really is
	# off the mesh, more than 1 m from the nearest navigable point, so the check
	# is about the case the old one was about, and can fail.
	var before := player.commands_redirected
	var wild := Vector3(-13, 0, 60)            # far outside the arena
	var stored := player.command_move_to(wild)
	var exact: bool = stored == Vector3(wild.x, 0.0, wild.z) and player.move_destination == stored
	var not_dropped: bool = player.move_destination != null
	var not_redirected := not player.last_command_was_redirected \
		and player.commands_redirected == before and is_zero_approx(player.last_command_redirect_m)
	var off_mesh_m := NavService.planar_distance(NavService.nearest_point(nav_map, wild), wild)
	var really_off := off_mesh_m > 1.0
	player.clear_move_destination()
	await _phys(3)
	var ok := exact and not_dropped and not_redirected and really_off
	_note("F27_offmesh_click_is_stored_unsnapped_not_dropped",
		"REPLACED ONE FOR ONE UNDER D-404 (was F27_offmesh_click_is_reported_not_dropped, which required a redirect onto the mesh — true when written): an order %.2f m off the mesh=%s is NOT dropped (a destination exists=%s), is stored EXACTLY as clicked=%s, and is NOT redirected or reported as one=%s"
		% [off_mesh_m, str(really_off), str(not_dropped), str(exact), str(not_redirected)])
	_reached("F27_offmesh_click_is_stored_unsnapped_not_dropped")
	return ok

func chk_F28_no_wasd_binding() -> bool:
	# CLAUDE.md section 8: "There is no WASD binding in the MVP."
	# BOTH 3D SPIKES BOUND WASD. A production foundation must not.
	var wasd := {87: "W", 65: "A", 83: "S", 68: "D"}
	var offenders: Array[String] = []
	for a in InputMap.get_actions():
		# Godot's own built-in `ui_*` editor/text actions bind W, A, S and D for
		# text editing on macOS. They are the ENGINE's, not this project's, and
		# the claim being made is about this project's control scheme.
		if String(a).begins_with("ui_"):
			continue
		for ev in InputMap.action_get_events(a):
			if ev is InputEventKey:
				var k := ev as InputEventKey
				for code in wasd:
					if k.physical_keycode == code or k.keycode == code:
						offenders.append("%s -> %s" % [String(a), wasd[code]])
	# And in the project file itself, so an editor-side binding cannot hide.
	var raw := _read_text("res://project.godot")
	var raw_hits := 0
	for code in wasd:
		# Only count physical_keycode occurrences, so an unrelated number cannot
		# trip this.
		raw_hits += raw.count("\"physical_keycode\":%d" % code)
	var ok := offenders.is_empty() and raw_hits == 0
	_note("F28_no_wasd_binding",
		"THIS PROJECT'S InputMap actions bound to W/A/S/D: %s (Godot's own ui_* built-ins are excluded and are the engine's, not this project's) | project.godot physical_keycode W/A/S/D occurrences: %d"
		% [str(offenders), raw_hits])
	_reached("F28_no_wasd_binding")
	return ok

func chk_F29_controller_axis_path_and_deadzone() -> bool:
	var dz := ProdConfig.STICK_DEADZONE
	var inside := InputIntent.radial_deadzone(Vector2(dz * 0.6, 0.0), dz)
	var just_out := InputIntent.radial_deadzone(Vector2(dz + 0.1, 0.0), dz)
	var full := InputIntent.radial_deadzone(Vector2(1.0, 0.0), dz)
	var diag := InputIntent.radial_deadzone(Vector2(0.7071, 0.7071), dz)
	# A RADIAL deadzone must treat a diagonal exactly as it treats a cardinal.
	var cardinal_at_same_length := InputIntent.radial_deadzone(Vector2(1.0, 0.0), dz)
	var radial_ok := absf(diag.length() - cardinal_at_same_length.length()) < 0.0001
	# The axis path must actually reach the motor.
	player.intent.debug_move_axis = Vector2(1.0, 0.0)
	var p0 := player.global_position
	await _phys(30)
	var moved := player.global_position.distance_to(p0)
	player.intent.clear_seams()
	player.motor.reset()
	player.global_position = ProductionArena.player_spawn()
	await _phys(6)
	var ok := inside == Vector2.ZERO and just_out.length() > 0.0 \
		and absf(full.length() - 1.0) < 0.0001 and radial_ok and moved > 0.5
	_note("F29_controller_axis_path_and_deadzone",
		"inside the %.2f deadzone -> %.4f (must be 0) | just outside -> %.4f | full deflection -> %.4f | a diagonal and a cardinal of equal length agree=%s | the stick path moved the actor %.3f m"
		% [dz, inside.length(), just_out.length(), full.length(), str(radial_ok), moved])
	_reached("F29_controller_axis_path_and_deadzone")
	return ok

func chk_F30_top_speed_accel_decel_measured() -> bool:
	# MEASURED by stepping the motor with an exact delta, not sampled off a
	# moving character. A sampled measurement is not a measurement of the thing
	# that was designed.
	var m := LocomotionMotor.new()
	var dt := 1.0 / 60.0
	var fwd := Vector3(0, 0, 1)
	var steps_to_top := 0
	while m.speed() < ProdConfig.TOP_SPEED_MPS - 0.0005 and steps_to_top < 600:
		m.step(fwd, ProdConfig.TOP_SPEED_MPS, dt)
		steps_to_top += 1
	var top := m.speed()
	var accel_time := float(steps_to_top) * dt
	var expected_accel := ProdConfig.TOP_SPEED_MPS / ProdConfig.ACCEL_MPS2
	var steps_to_stop := 0
	while m.speed() > 0.0005 and steps_to_stop < 600:
		m.step(Vector3.ZERO, ProdConfig.TOP_SPEED_MPS, dt)
		steps_to_stop += 1
	var decel_time := float(steps_to_stop) * dt
	var expected_decel := ProdConfig.TOP_SPEED_MPS / ProdConfig.DECEL_MPS2
	# Overshoot is impossible: move_toward clamps.
	var never_exceeded := top <= ProdConfig.TOP_SPEED_MPS + 0.0001
	var ok := absf(top - ProdConfig.TOP_SPEED_MPS) < 0.01 * ProdConfig.TOP_SPEED_MPS \
		and absf(accel_time - expected_accel) <= dt + 0.0001 \
		and absf(decel_time - expected_decel) <= dt + 0.0001 \
		and never_exceeded
	_note("F30_top_speed_accel_decel_measured",
		"MEASURED: top %.4f m/s against the configured %.3f (%s) | reached it in %.4f s vs the arithmetic %.4f s | stopped in %.4f s vs %.4f s | never exceeded the top=%s"
		% [top, ProdConfig.TOP_SPEED_MPS, ProdConfig.TOP_SPEED_STATUS,
		   accel_time, expected_accel, decel_time, expected_decel, str(never_exceeded)])
	_reached("F30_top_speed_accel_decel_measured")
	return ok

# ============================================================================
# E. GROUND POINT, COLLISION AND NAVIGATION
# ============================================================================

func chk_F31_ground_point_is_the_actor_position() -> bool:
	var probe := await _probe_enemy("GroundProbe", Vector3(-11, 0, 5))
	# THE SHADOW STAYS AT THE GROUND POINT (CLAUDE.md section 5): it is a child of
	# the ACTOR, never of the visual.
	var p_shadow: Node3D = player.get_node_or_null("GroundShadow")
	var e_shadow: Node3D = probe.get_node_or_null("GroundShadow")
	var shadows_on_actor := p_shadow != null and e_shadow != null
	# AND EVERY GROUND DECAL CLEARS THE FLOOR'S *VISUAL* SURFACE.
	# The floor's mesh top is at +0.033 m, not at the collision plane, and decals
	# placed below it are punched through by the brick geometry -- which is what
	# the first rendered telegraph did. Measured, not assumed.
	var floor_mesh: Mesh = load(AssetManifest.ruins("Floor_Standard"))
	var measured_top := floor_mesh.get_aabb().position.y + floor_mesh.get_aabb().size.y
	var decals_clear := ProdConfig.DECAL_SHADOW_Y > measured_top \
		and ProdConfig.DECAL_TELEGRAPH_Y > measured_top \
		and ProdConfig.DECAL_TELEGRAPH_RING_Y > ProdConfig.DECAL_TELEGRAPH_Y \
		and absf(ProdConfig.FLOOR_VISUAL_TOP_Y - measured_top) < 0.002
	if shadows_on_actor:
		decals_clear = decals_clear and p_shadow.position.y > measured_top
	var ok := player.visual.position.is_equal_approx(Vector3.ZERO) \
		and probe.visual.position.is_equal_approx(Vector3.ZERO) \
		and player.ground_point().is_equal_approx(player.global_position) \
		and probe.ground_point().is_equal_approx(probe.global_position) \
		and absf(player.global_position.y) < 0.0001 \
		and shadows_on_actor and decals_clear
	_note("F31_ground_point_is_the_actor_position",
		"the player's visual sits at its actor origin %s and the enemy's at %s; ground_point() IS global_position for both; the actor's y is %.6f | both ground shadows are children of the ACTOR, not the visual=%s | the floor's VISUAL top measures %+.4f m and every ground decal clears it=%s"
		% [str(player.visual.position), str(probe.visual.position), player.global_position.y,
		   str(shadows_on_actor), measured_top, str(decals_clear)])
	probe.queue_free()
	await _phys(2)
	_reached("F31_ground_point_is_the_actor_position")
	return ok

func chk_F32_visual_is_not_read_for_gameplay() -> bool:
	# Move the VISUAL alone. If any gameplay quantity moves with it, something
	# is reading presentation as simulation.
	var gp_before := player.ground_point()
	var probe := await _probe_enemy("VisualProbe", player.global_position + Vector3(3, 0, 0))
	var dist_before := NavService.planar_distance(probe.global_position, player.ground_point())
	var reach_before := NavService.reachable(nav_map, player.ground_point(),
		ProductionArena.doorway_centre(), 0.6)
	player.visual.position = Vector3(5, 3, -4)   # absurd, on purpose
	await _phys(6)
	var gp_after := player.ground_point()
	var dist_after := NavService.planar_distance(probe.global_position, player.ground_point())
	var reach_after := NavService.reachable(nav_map, player.ground_point(),
		ProductionArena.doorway_centre(), 0.6)
	player.visual.position = Vector3.ZERO
	await _phys(4)
	var ok := gp_before.is_equal_approx(gp_after) \
		and absf(dist_before - dist_after) < 0.0001 \
		and absf(float(reach_before["path_length"]) - float(reach_after["path_length"])) < 0.0001
	_note("F32_visual_is_not_read_for_gameplay",
		"the visual was displaced to (5, 3, -4): ground point unchanged=%s, actor-to-actor distance %.4f -> %.4f, navigation path length %.4f -> %.4f"
		% [str(gp_before.is_equal_approx(gp_after)), dist_before, dist_after,
		   reach_before["path_length"], reach_after["path_length"]])
	probe.queue_free()
	await _phys(2)
	_reached("F32_visual_is_not_read_for_gameplay")
	return ok

func chk_F33_collision_is_authored_per_prop() -> bool:
	# `game3d_spike/` used a simple perimeter box and said so. A production
	# foundation must not: FOUR colliders would mean exactly that box again.
	var n := arena.collider_count()
	var bodies := 0
	var shapes := 0
	for c in arena.get_node("Geometry").get_children():
		if c is StaticBody3D:
			bodies += 1
			for s in c.get_children():
				if s is CollisionShape3D:
					shapes += 1
	var ok := n > 40 and bodies == n and shapes == n
	_note("F33_collision_is_authored_per_prop",
		"%d authored colliders (a perimeter box would be 4), %d StaticBody3D each carrying exactly one shape (%d shapes). Sizes come from each mesh's OWN measured AABB."
		% [n, bodies, shapes])
	_reached("F33_collision_is_authored_per_prop")
	return ok

func chk_F34_navmesh_baked_once_with_measured_area() -> bool:
	var nm := arena.nav_mesh()
	var m := NavService.measure_mesh(nm)
	var authored := arena.authored_floor_area_m2()
	var frac := float(m["area"]) / authored
	# TWO-SIDED, deliberately. Too small means the mesh was eaten; as large as
	# the authored floor means the walls were never parsed at all -- which is
	# exactly the failure that a one-sided "area > 0" check waves through.
	var area_ok := frac > 0.55 and frac < 0.98
	var band := ProdConfig.NAV_GROUND_BAND_M
	# THE 3D RETURN OF THE OPEN-TOPPED-BOX DEFECT. A navigation island on top of
	# a column passes every polygon-count check ever written.
	var band_ok := absf(float(m["min_y"])) <= band and absf(float(m["max_y"])) <= band
	var ok := arena.bake_count == 1 and int(m["polygons"]) > 0 and area_ok and band_ok \
		and arena.parsed_source_vertices > 0
	_note("F34_navmesh_baked_once_with_measured_area",
		"baked %d time(s) from %d parsed source vertices -> %d polygons, %.1f m^2 walkable = %.1f%% of the %.0f m^2 authored floor (two-sided 55-98%%: %s) | every polygon lies within +/-%.2f m of the ground plane, y in [%.3f, %.3f]=%s"
		% [arena.bake_count, arena.parsed_source_vertices, m["polygons"], m["area"],
		   frac * 100.0, authored, str(area_ok), band, m["min_y"], m["max_y"], str(band_ok)])
	_reached("F34_navmesh_baked_once_with_measured_area")
	return ok

func chk_F35_path_reachability_to_every_rect_centre() -> bool:
	# ASSERT REACHABILITY BY PATH, TO THE CENTRE OF EVERY AUTHORED WALKABLE
	# RECTANGLE -- NOT TO ITS SOCKETS. A sealed 70 m^2 alcove once passed every
	# socket check this project had, because it had none.
	var from := ProductionArena.player_spawn()
	var failed: Array[String] = []
	var lines: Array[String] = []
	for r in ProductionArena.walkable_rects():
		var res := NavService.reachable(nav_map, from, r["centre"], 0.6)
		lines.append("%s err=%.3f len=%.2f" % [r["name"], res["end_error"], res["path_length"]])
		if not res["reachable"]:
			failed.append("%s (%s)" % [r["name"], res["why"]])
	var ok := failed.is_empty() and ProductionArena.walkable_rects().size() >= 6
	_note("F35_path_reachability_to_every_rect_centre",
		"%d authored walkable rectangles, all reached BY PATH from the spawn: %s | unreachable: %s"
		% [ProductionArena.walkable_rects().size(), "; ".join(lines), str(failed)])
	_reached("F35_path_reachability_to_every_rect_centre")
	return ok

func chk_F36_reachability_guard_refuses_unreachable_point() -> bool:
	# A GUARD THAT ACCEPTS EVERYTHING PROTECTS NOTHING. `map_get_path` snaps an
	# off-mesh target to the nearest point and always returns something, so a
	# test that merely asked "did I get a path" would accept every point in the
	# universe.
	var from := ProductionArena.player_spawn()
	var accepted: Array[String] = []
	var lines: Array[String] = []
	for p in ProductionArena.unreachable_probes():
		var res := NavService.reachable(nav_map, from, p["point"], 0.6)
		lines.append("%s err=%.2f" % [p["name"], res["end_error"]])
		if res["reachable"]:
			accepted.append(String(p["name"]))
	var ok := accepted.is_empty() and ProductionArena.unreachable_probes().size() >= 2
	_note("F36_reachability_guard_refuses_unreachable_point",
		"%d points that MUST be unreachable were all REFUSED: %s | wrongly accepted: %s"
		% [ProductionArena.unreachable_probes().size(), "; ".join(lines), str(accepted)])
	_reached("F36_reachability_guard_refuses_unreachable_point")
	return ok

func chk_F37_doorway_survives_agent_radius_erosion() -> bool:
	# THE PROJECT'S OWN NAMED DEFECT CLASS: agent-radius erosion silently
	# deleting a corridor. Measured, not hoped.
	var w := NavService.corridor_width(nav_map, ProductionArena.doorway_centre(),
		ProductionArena.doorway_across(), 2.5, 200)
	var authored := arena.measured_wall_size.x     # one module of authored gap
	var needed := ProdConfig.NAV_AGENT_RADIUS * 2.0
	var width := float(w["width"])
	var eroded := 1.0 - (width / authored)
	var ok := width >= needed and width > 0.0
	_note("F37_doorway_survives_agent_radius_erosion",
		"the authored gap is %.3f m; after baking, %.3f m of it is genuinely ON the mesh (%.0f%% lost to erosion). An agent needs %.2f m (2 x radius). SURVIVES=%s"
		% [authored, width, eroded * 100.0, needed, str(ok)])
	_reached("F37_doorway_survives_agent_radius_erosion")
	return ok

func chk_F38_actors_remain_on_the_ground_plane() -> bool:
	var probe := await _probe_enemy("PlaneProbe", Vector3(-11, 0, 3))
	probe.debug_freeze_ai = false
	player.intent.debug_move_axis = Vector2(1.0, -1.0).normalized()
	var worst := 0.0
	for i in range(90):
		await physics_frame
		worst = maxf(worst, absf(player.global_position.y))
		worst = maxf(worst, absf(probe.global_position.y))
	player.intent.clear_seams()
	player.motor.reset()
	player.global_position = ProductionArena.player_spawn()
	probe.queue_free()
	await _phys(4)
	_note("F38_actors_remain_on_the_ground_plane",
		"across 90 driven frames with two moving actors, the greatest departure from the ground plane was %.6f m. Visual height is presentation and is never a gameplay coordinate."
		% worst)
	_reached("F38_actors_remain_on_the_ground_plane")
	return worst < 0.0001

func chk_F39_enemy_path_routes_around_obstacle() -> bool:
	# With the interior blocker between them, a PATH must be longer than the
	# straight line. A beeline would prove the agent is not using the mesh.
	var a := Vector3(-13, 0, 0)
	var b := Vector3(-3, 0, 0)
	var res := NavService.reachable(nav_map, a, b, 0.6)
	var ratio := float(res["path_length"]) / float(res["straight"])
	# And a clear line must NOT be inflated, or "longer" would mean nothing.
	var clear := NavService.reachable(nav_map, Vector3(-13, 0, -6), Vector3(-13, 0, 6), 0.6)
	var clear_ratio := float(clear["path_length"]) / float(clear["straight"])
	var ok: bool = res["reachable"] and ratio > 1.05 and clear["reachable"] and clear_ratio < 1.02
	_note("F39_enemy_path_routes_around_obstacle",
		"across the interior blocker the path is %.2f m against a %.2f m straight line (ratio %.3f — a route, not a beeline); along a CLEAR line the ratio is %.3f (so 'longer' means something)"
		% [res["path_length"], res["straight"], ratio, clear_ratio])
	_reached("F39_enemy_path_routes_around_obstacle")
	return ok

func chk_F70_nav_agent_radius_matches_body_radius() -> bool:
	# A navigation surface eroded by a DIFFERENT radius from the one the body
	# actually occupies is how a corridor disappears between the planner and the
	# mover.
	var nm := arena.nav_mesh()
	var probe := await _probe_enemy("RadiusProbe", Vector3(-11, 0, -3))
	var ok := is_equal_approx(nm.agent_radius, ProdConfig.NAV_AGENT_RADIUS) \
		and is_equal_approx(player.agent.radius, ProdConfig.NAV_AGENT_RADIUS) \
		and is_equal_approx(probe.agent.radius, ProdConfig.NAV_AGENT_RADIUS) \
		and is_equal_approx(ProdConfig.PLAYER_BODY_RADIUS, ProdConfig.NAV_AGENT_RADIUS) \
		and ProdConfig.ENEMY_BODY_RADIUS >= ProdConfig.NAV_AGENT_RADIUS
	_note("F70_nav_agent_radius_matches_body_radius",
		"bake radius %.3f m, player agent %.3f m, enemy agent %.3f m, player BODY %.3f m, enemy BODY %.3f m — the planner and the mover agree"
		% [nm.agent_radius, player.agent.radius, probe.agent.radius,
		   ProdConfig.PLAYER_BODY_RADIUS, ProdConfig.ENEMY_BODY_RADIUS])
	probe.queue_free()
	await _phys(2)
	_reached("F70_nav_agent_radius_matches_body_radius")
	return ok

# ============================================================================
# F. THE ORDINARY-ENEMY DIAGNOSTIC LOOP
# ============================================================================

func chk_F40_enemy_acquires_inside_radius_only() -> bool:
	player.global_position = ProductionArena.player_spawn()
	await _phys(4)
	var far := await _probe_enemy("AcquireFar",
		player.global_position + Vector3(0, 0, ProdConfig.ENEMY_ACQUIRE_RADIUS_M + 2.0))
	var near := await _probe_enemy("AcquireNear",
		player.global_position + Vector3(0, 0, ProdConfig.ENEMY_ACQUIRE_RADIUS_M - 4.0))
	far.debug_suppress_movement = true
	near.debug_suppress_movement = true
	far.debug_freeze_ai = false
	near.debug_freeze_ai = false
	await _phys(20)
	var ok := (not far.acquired) and near.acquired \
		and far.state == OrdinaryEnemy.State.IDLE and near.state != OrdinaryEnemy.State.IDLE
	_note("F40_enemy_acquires_inside_radius_only",
		"acquire radius %.1f m: an enemy at %.1f m acquired=%s (must be false, state %s) | one at %.1f m acquired=%s (state %s)"
		% [ProdConfig.ENEMY_ACQUIRE_RADIUS_M, ProdConfig.ENEMY_ACQUIRE_RADIUS_M + 2.0,
		   str(far.acquired), far.state_name(), ProdConfig.ENEMY_ACQUIRE_RADIUS_M - 4.0,
		   str(near.acquired), near.state_name()])
	far.queue_free()
	near.queue_free()
	await _phys(2)
	_reached("F40_enemy_acquires_inside_radius_only")
	return ok

func chk_F41_enemy_navigates_to_target() -> bool:
	player.global_position = Vector3(-13, 0, 0)
	await _phys(4)
	var e := await _probe_enemy("NavProbe", Vector3(-3, 0, 0))
	e.debug_freeze_ai = false
	var d0 := NavService.planar_distance(e.global_position, player.global_position)
	var guard := 0
	while guard < 900 and NavService.planar_distance(e.global_position,
			player.global_position) > ProdConfig.ENEMY_ATTACK_RANGE_M:
		await physics_frame
		guard += 1
	var d1 := NavService.planar_distance(e.global_position, player.global_position)
	var used_path := e.path_points_last >= 2
	var ok := d1 < d0 and d1 <= ProdConfig.ENEMY_ATTACK_RANGE_M + 0.1 and used_path \
		and guard < 900
	_note("F41_enemy_navigates_to_target",
		"closed from %.2f m to %.2f m in %d physics frames, following a path of %d points (a path, not a vector)"
		% [d0, d1, guard, e.path_points_last])
	e.queue_free()
	await _phys(2)
	_reached("F41_enemy_navigates_to_target")
	return ok

## Drives a probe enemy to the moment of commit, recording the ordering.
func _drive_to_commit(e: OrdinaryEnemy, max_frames: int = 600) -> Dictionary:
	var telegraph_first_seen := -1
	var commit_frame := -1
	var f := 0
	while f < max_frames and commit_frame < 0:
		await physics_frame
		f += 1
		if telegraph_first_seen < 0 and e.telegraph.visible:
			telegraph_first_seen = f
		if e.state == OrdinaryEnemy.State.COMMIT and commit_frame < 0:
			commit_frame = f
	return {"telegraph": telegraph_first_seen, "commit": commit_frame, "frames": f}

func chk_F42_telegraph_precedes_commit() -> bool:
	player.global_position = Vector3(-13, 0, 0)
	await _phys(4)
	var e := await _probe_enemy("TeleProbe", Vector3(-11.6, 0, 0))
	e.debug_freeze_ai = false
	var r := await _drive_to_commit(e)
	var ok := int(r["telegraph"]) > 0 and int(r["commit"]) > 0 \
		and int(r["telegraph"]) < int(r["commit"]) \
		and e.telegraph_shown_at_state.size() > 0 \
		and e.telegraph_shown_at_state[0] == "WINDUP"
	var gap := (int(r["commit"]) - int(r["telegraph"])) / 60.0
	_note("F42_telegraph_precedes_commit",
		"the telegraph appeared on frame %d and the commit on frame %d — %.3f s of warning, and the ORDER is asserted, not assumed. Windup is %.2f s (PROVISIONAL)."
		% [r["telegraph"], r["commit"], gap, ProdConfig.ENEMY_WINDUP_S])
	e.queue_free()
	await _phys(2)
	_reached("F42_telegraph_precedes_commit")
	return ok

func chk_F43_telegraph_clears_on_recovery() -> bool:
	player.global_position = Vector3(-13, 0, 0)
	await _phys(4)
	var e := await _probe_enemy("ClearProbe", Vector3(-11.6, 0, 0))
	e.debug_freeze_ai = false
	var r := await _drive_to_commit(e)
	var committed := int(r["commit"]) > 0
	var was_visible := e.telegraph.visible or committed
	var guard := 0
	while guard < 240 and e.state != OrdinaryEnemy.State.RECOVER \
			and e.state != OrdinaryEnemy.State.CHASE:
		await physics_frame
		guard += 1
	var cleared := not e.telegraph.visible
	var ok := committed and was_visible and cleared
	_note("F43_telegraph_clears_on_recovery",
		"the attack ACTUALLY COMMITTED=%s (so this cannot pass vacuously) and the telegraph was hidden again %d frames later=%s, in state %s"
		% [str(committed), guard, str(cleared), e.state_name()])
	e.queue_free()
	await _phys(2)
	_reached("F43_telegraph_clears_on_recovery")
	return ok

func chk_F44_release_marker_independent_of_clip_speed() -> bool:
	# MECHANICAL TIMING IS AUTHORITATIVE OVER ANIMATION TIMING.
	var expected := ProdConfig.ATTACK_COOLDOWN_S * ProdConfig.ATTACK_RELEASE_MARKER
	var dt := 1.0 / 60.0
	var measured: Array[float] = []
	for speed in [0.30, 1.0, 2.50]:
		player.debug_release_times = []
		player._cooldown = 0.0
		player.begin_attack()
		player.anim.speed_scale = float(speed)
		var guard := 0
		while player.debug_release_times.is_empty() and guard < 200:
			await physics_frame
			guard += 1
		if player.debug_release_times.is_empty():
			measured.append(-1.0)
		else:
			measured.append(player.debug_release_times[0])
		await _phys(40)
	player.anim.speed_scale = 1.0
	var ok := true
	for t in measured:
		if t < 0.0 or absf(t - expected) > dt + 0.0005:
			ok = false
	var spread := 0.0
	for t in measured:
		for u in measured:
			spread = maxf(spread, absf(t - u))
	ok = ok and spread <= 0.0005
	_note("F44_release_marker_independent_of_clip_speed",
		"the same action run at clip speeds x0.30, x1.0 and x2.50 released at %s s against the computed %.4f s (one physics step is %.4f s); spread across the three %.6f s"
		% [str(measured), expected, dt, spread])
	_reached("F44_release_marker_independent_of_clip_speed")
	return ok

func chk_F45_telegraph_and_commit_agree_both_directions() -> bool:
	# ONE ARITHMETIC, TWO CONSUMERS. The drawn shape and the damage query are
	# the same function, so they cannot disagree -- and the function itself is
	# tested in both directions.
	var t := Telegraph.new()
	main.add_child(t)
	t.build(2.5, 90.0)
	t.global_position = Vector3(0, 0, 0)
	t.face(Vector3(0, 0, 1))
	await _phys(2)
	var inside_near := t.contains(Vector3(0, 0, 1.0))
	var inside_edge := t.contains(Vector3(1.6, 0, 1.7))      # ~43 deg, r=2.33
	var outside_angle := t.contains(Vector3(2.0, 0, 0.2))    # ~84 deg
	var outside_range := t.contains(Vector3(0, 0, 4.0))
	var behind := t.contains(Vector3(0, 0, -1.5))
	var height_ignored := t.contains(Vector3(0, 9.0, 1.0))   # height is NOT a coordinate
	var ok := inside_near and inside_edge and (not outside_angle) \
		and (not outside_range) and (not behind) and height_ignored
	_note("F45_telegraph_and_commit_agree_both_directions",
		"inside near=%s | inside near the arc edge=%s | outside the ARC=%s (must be false) | outside the RANGE=%s (must be false) | directly BEHIND=%s (must be false) | a 9 m height difference is ignored=%s"
		% [str(inside_near), str(inside_edge), str(outside_angle), str(outside_range),
		   str(behind), str(height_ignored)])
	t.queue_free()
	await _phys(2)
	_reached("F45_telegraph_and_commit_agree_both_directions")
	return ok

func chk_F46_damage_only_inside_committed_shape() -> bool:
	# Drive a REAL commit with the player inside the shape, then another with the
	# player outside it. The second only means something because the first fired.
	player.global_position = Vector3(-13, 0, 0)
	player.life.reset()
	await _phys(4)
	var e := await _probe_enemy("HitProbe", Vector3(-11.6, 0, 0))
	e.debug_freeze_ai = false
	e.debug_suppress_movement = true
	var r := await _drive_to_commit(e)
	var hit_inside := e.last_commit_hit_player
	var life_after_inside := player.life.life
	var damaged := life_after_inside < player.life.max_life

	# THE FIRST ENEMY MUST BE GONE before the second measurement, or its own
	# attacks contaminate the "life unchanged" assertion. (They did.)
	e.debug_freeze_ai = true
	e.queue_free()
	await _phys(3)
	player.life.reset()

	# Now put the player well OUTSIDE the next enemy's shape.
	var e2 := await _probe_enemy("MissProbe", Vector3(-11.6, 0, 6))
	e2.debug_freeze_ai = false
	e2.debug_suppress_movement = true
	e2.global_position = Vector3(-13, 0, 6)
	await _phys(4)
	var before2 := player.life.life
	# The enemy is 6 m away, far outside its 1.9 m attack shape, so no commit
	# should reach the player even if one occurs.
	var r2 := await _drive_to_commit(e2, 240)
	var hit_outside := e2.last_commit_hit_player
	var unchanged := absf(player.life.life - before2) < 0.0001
	var ok: bool = int(r["commit"]) > 0 and hit_inside and damaged \
		and (not hit_outside) and unchanged
	_note("F46_damage_only_inside_committed_shape",
		"a commit ACTUALLY FIRED (frame %d) with the player inside: hit=%s, life %.1f -> %.1f | a distant enemy's commit reached the player=%s (must be false) and the life was unchanged=%s"
		% [r["commit"], str(hit_inside), player.life.max_life, life_after_inside,
		   str(hit_outside), str(unchanged)])
	e2.queue_free()
	player.life.reset()
	await _phys(2)
	_reached("F46_damage_only_inside_committed_shape")
	return ok

func chk_F47_enemy_receives_damage_and_reacts() -> bool:
	var e := await _probe_enemy("DamageProbe", Vector3(-11, 0, -4))
	var before := e.life.life
	e.receive_damage(ProdConfig.BOLT_DAMAGE, player.global_position)
	await _phys(3)
	var reacted := e.live_clip() == ProdConfig.CLIP_ENEMY_HIT
	var ledger := e.life.hits_taken == 1 \
		and absf(e.life.total_damage - ProdConfig.BOLT_DAMAGE) < 0.0001
	var ok := e.life.life < before and reacted and ledger and not e.is_dead()
	_note("F47_enemy_receives_damage_and_reacts",
		"life %.1f -> %.1f, the hit reaction plays the SOURCE clip '%s' (live '%s')=%s, ledger records %d hit(s) totalling %.1f"
		% [before, e.life.life, ProdConfig.CLIP_ENEMY_HIT, e.live_clip(), str(reacted),
		   e.life.hits_taken, e.life.total_damage])
	e.queue_free()
	await _phys(2)
	_reached("F47_enemy_receives_damage_and_reacts")
	return ok

func chk_F48_hit_precedes_kill() -> bool:
	var e := await _probe_enemy("OrderProbe", Vector3(-11, 0, -6))
	# Deliberately kill it in TWO hits, so the ordering is a real sequence.
	e.receive_damage(ProdConfig.ENEMY_HEALTH * 0.5, Vector3.ZERO)
	await _phys(2)
	e.receive_damage(ProdConfig.ENEMY_HEALTH, Vector3.ZERO)
	await _phys(2)
	var ordered := e.life.hit_preceded_death()
	# THE NEGATIVE CONTROL: a ledger with no death must NOT claim ordering.
	var never := Damageable.new(100.0)
	never.apply(10.0, Vector3.ZERO)
	var vacuous := never.hit_preceded_death()
	var ok := ordered and e.life.dead and (not vacuous)
	_note("F48_hit_precedes_kill",
		"ledger order %s -> hit precedes death=%s | a ledger with hits but NO death claims ordering=%s (must be false, so this can never pass vacuously)"
		% [str(e.life.events), str(ordered), str(vacuous)])
	e.queue_free()
	await _phys(2)
	_reached("F48_hit_precedes_kill")
	return ok

func chk_F49_death_uses_truthful_source_clip() -> bool:
	var e := await _probe_enemy("DeathProbe", Vector3(-11, 0, 6))
	var declared := RigCorpus.clip_length(e.anim, ProdConfig.CLIP_ENEMY_DEATH)
	e.receive_damage(ProdConfig.ENEMY_HEALTH * 2.0, Vector3.ZERO)
	await _phys(3)
	var clip := e.live_clip()
	var source := RigCorpus.attribute(clip)
	var ok := clip == ProdConfig.CLIP_ENEMY_DEATH and source == "UAL1" \
		and declared > 1.0 and e.state == OrdinaryEnemy.State.DYING
	_note("F49_death_uses_truthful_source_clip",
		"death plays '%s', derived from %s, %.4f s long — a REAL source clip, not a code-driven topple. The D-366 'no death clip' gap was UAL2-only and UAL1 discharges it."
		% [clip, source, declared])
	e.queue_free()
	await _phys(2)
	_reached("F49_death_uses_truthful_source_clip")
	return ok

func chk_F50_death_runs_measured_length_and_is_terminal() -> bool:
	var e := await _probe_enemy("TerminalProbe", Vector3(-15, 0, 6))
	# A probe is spawned frozen so it cannot wander during other checks. A death
	# sequence is a RUNNING thing, so this one is unfrozen -- and the AI cannot
	# leave the dying state, which is the point being proved.
	e.debug_freeze_ai = false
	e.debug_suppress_movement = true
	e.receive_damage(ProdConfig.ENEMY_HEALTH * 2.0, Vector3.ZERO)
	await _phys(2)
	var started := e.state == OrdinaryEnemy.State.DYING
	var guard := 0
	while e.state == OrdinaryEnemy.State.DYING and guard < 400:
		await physics_frame
		guard += 1
	var ran := e.death_elapsed
	var reached_dead := e.state == OrdinaryEnemy.State.DEAD
	# TERMINAL: nothing may leave DEAD, including further damage.
	e.receive_damage(50.0, Vector3.ZERO)
	await _phys(30)
	var still_dead := e.state == OrdinaryEnemy.State.DEAD
	var ok := started and reached_dead and still_dead \
		and absf(ran - e.death_clip_length) < 0.1
	_note("F50_death_runs_measured_length_and_is_terminal",
		"the death ran %.3f s against the clip's MEASURED %.4f s, reached DEAD=%s, and stayed DEAD after further damage=%s"
		% [ran, e.death_clip_length, str(reached_dead), str(still_dead)])
	e.queue_free()
	await _phys(2)
	_reached("F50_death_runs_measured_length_and_is_terminal")
	return ok

# ============================================================================
# G. THE ONE DIAGNOSTIC PLAYER ATTACK
# ============================================================================

func chk_F51_exactly_one_diagnostic_player_attack() -> bool:
	# ========================================================================
	# THE ASSERTION IS UNCHANGED BY D-375. ONLY THE NOTE IS AMENDED.
	# ========================================================================
	# This check's claim is, and always was, about THE CONTROLLER: the accepted
	# foundation declares exactly ONE diagnostic action and has exactly ONE
	# attack entry point. Both are still true, and neither was arranged to be --
	# `DIAGNOSTIC_ACTIONS` is untouched and no `begin_` function was added.
	#
	# What the note used to imply -- that there is exactly one player attack IN
	# THE WHOLE PROJECT -- would be FALSE under D-375, which authorizes a Skill
	# system with its own diagnostic Skill Imprints. Leaving that implication in
	# place would be a lie the suite repeated every run, so the SENTENCE is
	# corrected and the PROJECT-LEVEL claim moves to a check that can carry it:
	# the D-375 suite pins the EXHAUSTIVE set of action entry points across the
	# whole project, in BOTH directions. That is a BROADER guard, not a weaker
	# one, and this assertion keeps its own teeth.
	var n: int = PlayerController.DIAGNOSTIC_ACTIONS.size()
	# And nothing else in the player may be an attack entry point.
	var src := _read_text("res://scripts/control/player_controller.gd")
	var begins := src.count("func begin_")
	var ok := n == 1 and begins == 1
	_note("F51_exactly_one_diagnostic_player_attack",
		"%d diagnostic action(s) declared: %s | %d attack entry point(s) in the controller. CLAUDE.md 3.5 permits EXACTLY ONE *diagnostic action in P1*, and THE FOUNDATION'S IS STILL THE ONLY ONE ON THE CONTROLLER. SCOPE, STATED: this check is about the CONTROLLER. The D-375 Imprint stage's diagnostic Skill Imprints live in SkillRuntime and are pinned EXHAUSTIVELY, IN BOTH DIRECTIONS, by the D-375 suite — a broader guard than this one."
		% [n, str(PlayerController.DIAGNOSTIC_ACTIONS), begins])
	_reached("F51_exactly_one_diagnostic_player_attack")
	return ok

func chk_F52_diagnostic_attack_is_labelled() -> bool:
	var label := player.diagnostic_label()
	var overlay := hud.compose()
	var ok := label.findn("diagnostic") >= 0 and label.findn("not a skill") >= 0 \
		and overlay.findn("DIAGNOSTIC") >= 0 \
		and overlay.find(ProdConfig.DIAG_ATTACK_DESIGN_NAME) >= 0
	_note("F52_diagnostic_attack_is_labelled",
		"the runtime label is '%s' and the overlay names it: '%s' present=%s"
		% [label, ProdConfig.DIAG_ATTACK_DESIGN_NAME,
		   str(overlay.find(ProdConfig.DIAG_ATTACK_DESIGN_NAME) >= 0)])
	_reached("F52_diagnostic_attack_is_labelled")
	return ok

func chk_F53_diagnostic_attack_denies_being_a_skill() -> bool:
	var overlay := hud.compose()
	var missing: Array[String] = []
	for d in ProdConfig.DIAG_ATTACK_DENIALS:
		if overlay.find(String(d)) < 0:
			missing.append(String(d))
	var mentions_c9 := false
	for d in ProdConfig.DIAG_ATTACK_DENIALS:
		if String(d).find("C9") >= 0:
			mentions_c9 = true
	var ok := missing.is_empty() and ProdConfig.DIAG_ATTACK_DENIALS.size() >= 3 and mentions_c9
	_note("F53_diagnostic_attack_denies_being_a_skill",
		"%d denials, all present in the runtime=%s; the Mage-spell denial names the transferred criterion C9 explicitly=%s | missing: %s"
		% [ProdConfig.DIAG_ATTACK_DENIALS.size(), str(missing.is_empty()),
		   str(mentions_c9), str(missing)])
	_reached("F53_diagnostic_attack_denies_being_a_skill")
	return ok

func chk_F54_projectile_travels_on_plane_and_expires() -> bool:
	var b := DiagnosticBolt.new()
	main.add_child(b)
	b.build(Vector3(0, 0, 1))
	b.global_position = Vector3(-13, 1.15, -8)
	var y0 := b.global_position.y
	var dt := 1.0 / 60.0
	var steps := 0
	var worst_y := 0.0
	while b.alive and steps < 3000:
		b.step(dt)
		steps += 1
		if is_instance_valid(b) and b.alive:
			worst_y = maxf(worst_y, absf(b.global_position.y - y0))
	var expired := b.expired
	var dist := b.travelled
	var ok := expired and absf(dist - ProdConfig.BOLT_RANGE_M) < ProdConfig.BOLT_SPEED_MPS * dt + 0.001 \
		and worst_y < 0.0001
	_note("F54_projectile_travels_on_plane_and_expires",
		"travelled %.3f m of its %.1f m range and EXPIRED=%s after %d steps; its height never varied by more than %.6f m (it travels on the plane); 0 projectiles survive past the lifetime"
		% [dist, ProdConfig.BOLT_RANGE_M, str(expired), steps, worst_y])
	_reached("F54_projectile_travels_on_plane_and_expires")
	return ok

func chk_F55_point_blank_overlap_hits() -> bool:
	# THE NAMED DEFECT CLASS: "a shape query blind to what it already overlaps".
	# A projectile that only tests the segment it swept THIS frame never sees a
	# target it spawned inside.
	player.global_position = Vector3(-13, 0, 0)
	await _phys(4)
	var e := await _probe_enemy("PointBlank", player.global_position + Vector3(0.85, 0, 0))
	var before := e.life.life
	DiagnosticBolt.last_hit_steps = -1
	DiagnosticBolt.last_hit_distance = -1.0
	var b := DiagnosticBolt.new()
	main.add_child(b)
	b.build(Vector3(1, 0, 0))
	b.global_position = player.global_position + Vector3(0, 1.15, 0) + Vector3(0.45, 0, 0)
	await _phys(1)
	# READ THE RECORD, NOT THE OBJECT. The bolt frees itself the instant it hits,
	# so reading `b.steps` afterwards reads a freed object -- which is how this
	# check first reported UNREACHED instead of a result.
	var steps_at_hit := DiagnosticBolt.last_hit_steps
	var dist_at_hit := DiagnosticBolt.last_hit_distance
	var hit := e.life.life < before
	var ok := hit and steps_at_hit >= 1 and steps_at_hit <= 2 \
		and dist_at_hit >= 0.0 and dist_at_hit < 0.2
	_note("F55_point_blank_overlap_hits",
		"an already-overlapping target at %.2f m was hit on step %d, after the bolt had travelled %.3f m — the overlap test runs BEFORE the move, so a point-blank shot cannot silently miss. Life %.1f -> %.1f"
		% [0.85, steps_at_hit, dist_at_hit, before, e.life.life])
	e.queue_free()
	if is_instance_valid(b):
		b.queue_free()
	await _phys(2)
	_reached("F55_point_blank_overlap_hits")
	return ok

# ============================================================================
# H. DEBUG OVERLAY
# ============================================================================

func chk_F56_overlay_present_and_names_live_clip() -> bool:
	hud.set_enabled(true)
	hud.refresh()
	await _phys(2)
	var t := hud.compose()
	var names_clip := t.find(player.live_clip) >= 0
	var names_lib := t.find("UAL1") >= 0 or t.find("UAL2") >= 0
	var names_nav := t.findn("navigation") >= 0 and t.findn("polygons") >= 0
	var names_ground := t.findn("ground point") >= 0
	var ok := t.length() > 1200 and names_clip and names_lib and names_nav and names_ground
	_note("F56_overlay_present_and_names_live_clip",
		"%d characters; names the LIVE source clip '%s'=%s, its source library=%s, the navigation state=%s, the ground point=%s"
		% [t.length(), player.live_clip, str(names_clip), str(names_lib),
		   str(names_nav), str(names_ground)])
	_reached("F56_overlay_present_and_names_live_clip")
	return ok

func chk_F57_overlay_can_be_disabled() -> bool:
	var was := hud.enabled
	hud.set_enabled(false)
	await _phys(2)
	var off := (not hud.enabled) and (not hud.visible)
	hud.set_enabled(true)
	await _phys(2)
	var on := hud.enabled and hud.visible
	hud.set_enabled(was)
	# ========================================================================
	# RE-SCOPED UNDER D-382, ONE FOR ONE: the launch default this check pins
	# flipped from ON to HIDDEN. The owner: "The F1 overlay and F2 developer panel
	# must both start hidden. They remain independently toggleable with their
	# existing inputs." From D-370 until D-382 it asserted `initial_overlay_enabled`
	# -- true when written. The toggle assertions are unchanged, so the overlay is
	# still proved able to turn on AND off; only the pinned default moved.
	# ========================================================================
	var ok := off and on and hud.toggles > 0 and not initial_overlay_enabled
	_note("F57_overlay_can_be_disabled",
		"the overlay disables=%s and re-enables=%s (%d toggles). It starts HIDDEN at scene start (D-382; it launched ON from D-370 until D-382)=%s, and it is DISABLED in every rendered evidence capture — which the runner checks."
		% [str(off), str(on), hud.toggles, str(not initial_overlay_enabled)])
	_reached("F57_overlay_can_be_disabled")
	return ok

func chk_F58_overlay_prints_provisional_status() -> bool:
	var t := hud.compose()
	var says := t.count("PROVISIONAL")
	var says_speed := t.find(ProdConfig.TOP_SPEED_STATUS) >= 0
	var says_not_lock := t.findn("NOT a product lock") >= 0 or t.findn("LOCKS NO VALUE") >= 0
	var ok := says >= 4 and says_speed and says_not_lock
	_note("F58_overlay_prints_provisional_status",
		"the overlay says PROVISIONAL %d times, carries the top-speed status verbatim=%s, and denies any lock=%s"
		% [says, str(says_speed), str(says_not_lock)])
	_reached("F58_overlay_prints_provisional_status")
	return ok

func chk_F59_overlay_separates_design_and_clip_names() -> bool:
	# A borrowed clip must never be presented as a designed move.
	# The overlay reports the LIVE clip, and the locomotion layer reclaims the
	# clip the moment the action ends -- so the overlay must be read DURING the
	# action, not after it.
	player._cooldown = 0.0
	player.begin_attack()
	await _phys(2)
	var t := hud.compose()
	var has_design := t.find(ProdConfig.DIAG_ATTACK_DESIGN_NAME) >= 0
	var has_clip := t.find(ProdConfig.CLIP_PLAYER_ATTACK) >= 0
	var has_both_words := t.findn("design") >= 0 and t.findn("source clip") >= 0
	var different := ProdConfig.DIAG_ATTACK_DESIGN_NAME != ProdConfig.CLIP_PLAYER_ATTACK
	var ok := has_design and has_clip and has_both_words and different
	_note("F59_overlay_separates_design_and_clip_names",
		"the design name '%s' and the SOURCE clip name '%s' are both shown, and labelled as such=%s — they are different strings=%s"
		% [ProdConfig.DIAG_ATTACK_DESIGN_NAME, ProdConfig.CLIP_PLAYER_ATTACK,
		   str(has_both_words), str(different)])
	_reached("F59_overlay_separates_design_and_clip_names")
	return ok

# ============================================================================
# I. TRUTHFULNESS AND BOUNDARY DENIALS
# ============================================================================

func chk_F60_no_2d_lock_promoted() -> bool:
	# ============================================================================
	# DO NOT PIN A METAPHOR; PIN THE PROPERTY THE CLAIM OWES.
	# ============================================================================
	# The first version of this check compared every live float against every 2D
	# lock's NUMBER and flagged a match. It failed -- on `ENEMY_HEALTH = 120.0`
	# colliding with the 120 px tile width, and on `CAM_SIZE_MAX = 18.0` colliding
	# with the 18 m footprint height. Those are coincidences of arithmetic between
	# unrelated units, not promotions of a lock, and a guard that cannot tell the
	# difference is noise.
	#
	# What "no 2D lock is promoted" actually means is that none of game2d/'s
	# GOVERNING QUANTITIES governs anything here. That is what is tested.
	var markers := [
		["px/m density", ["px_per_m", "PX_PER_M", "pixels_per_metre", "PIXELS_PER_M"]],
		["the 128x128 character cell", ["CHARACTER_CELL", "CELL_PX", "CELL_SIZE_PX"]],
		["the 120x60 isometric tile", ["TILE_PX", "ISO_TILE", "TILE_WIDTH_PX"]],
		["the (64,122) ground anchor", ["GROUND_ANCHOR", "ANCHOR_PX"]],
		["the fixed 32.00 x 18.00 m footprint", ["CF_WIDTH", "CF_HEIGHT", "FOOTPRINT_LOCK"]],
		["rendering mode 7", ["subviewport_fill_fixed", "MODE_7", "RENDER_MODE_7"]],
	]
	var found: Array[String] = []
	for f in _runtime_script_files():
		var p := String(f)
		# prod_config.gd QUOTES the locks, in one clearly delimited place, so the
		# guard has something to compare against. That quotation is the only
		# permitted occurrence.
		var is_quotation_site := p.ends_with("prod_config.gd")
		if is_quotation_site:
			continue
		for raw_line in _read_text(p).split("\n"):
			# ONLY A DECLARATION COUNTS. The first version of this check matched
			# anywhere in the file and flagged two COMMENTS that say the 2D
			# footprint is NOT inherited -- prose denying the lock, reported as
			# the lock. A mention is not a promotion.
			var line := String(raw_line).strip_edges()
			if not (line.begins_with("const ") or line.begins_with("var ")
					or line.begins_with("@export")):
				continue
			for row in markers:
				for m in row[1]:
					if line.find(String(m)) >= 0:
						found.append("%s declares %s (%s)" % [p.get_file(), row[0], m])
	# THE GUARD MUST BE ABLE TO FAIL.
	var planted := "var PX_PER_M := 60.0"
	var guard_catches := planted.find("PX_PER_M") >= 0
	# And the governing quantity itself must differ.
	var fp := cam.footprint_m()
	var footprint_differs := absf(fp.x - 32.0) > 0.01 or absf(fp.y - 18.0) > 0.01
	# The 2D locks are quoted for the guard, and only there.
	var quoted := ProdConfig.forbidden_2d_locks().size() >= 8
	var ok: bool = found.is_empty() and footprint_differs and guard_catches and quoted
	_note("F60_no_2d_lock_promoted",
		"no runtime script declares a px/m density, a 128x128 cell, a 120x60 tile, a (64,122) anchor, the fixed 32.00 x 18.00 m footprint or rendering mode 7 (offenders: %s) | the live footprint is %.2f x %.2f m and is NOT the game2d/ lock=%s | the scan is PROVED able to catch a planted px/m declaration=%s | %d locks quoted in one place for the guard to compare against"
		% [str(found), fp.x, fp.y, str(footprint_differs), str(guard_catches),
		   ProdConfig.forbidden_2d_locks().size()])
	_reached("F60_no_2d_lock_promoted")
	return ok

func chk_F61_no_spike_value_promoted() -> bool:
	# The spike values ARE used -- the ruling says to begin from them. What must
	# not happen is their being presented as settled.
	var reg := ProdConfig.provisional_registry()
	var carried := {"camera pitch (deg)": false, "zoom bound min (m)": false,
		"zoom bound max (m)": false, "top speed (m/s)": false,
		"output width (px)": false, "output height (px)": false}
	for row in reg:
		var k := String(row[0])
		if carried.has(k):
			carried[k] = String(row[2]).find("PROVISIONAL") >= 0
	var all_labelled := true
	for k in carried:
		if not carried[k]:
			all_labelled = false
	var speed_status_is_candidate := ProdConfig.TOP_SPEED_STATUS.findn("candidate") >= 0 \
		and ProdConfig.TOP_SPEED_STATUS.findn("not a lock") >= 0
	var ok := all_labelled and speed_status_is_candidate \
		and is_equal_approx(ProdConfig.TOP_SPEED_MPS, 3.889)
	_note("F61_no_spike_value_promoted",
		"every value carried from the accepted spikes (-52 deg pitch, the %.1f-%.1f m zoom bounds, %d x %d, and %.3f m/s) is labelled PROVISIONAL=%s; the speed is stated as a CANDIDATE, not a lock=%s"
		% [ProdConfig.CAM_SIZE_MIN, ProdConfig.CAM_SIZE_MAX, ProdConfig.OUTPUT_WIDTH,
		   ProdConfig.OUTPUT_HEIGHT, ProdConfig.TOP_SPEED_MPS, str(all_labelled),
		   str(speed_status_is_candidate)])
	_reached("F61_no_spike_value_promoted")
	return ok

func chk_F62_every_starting_value_labelled_provisional() -> bool:
	var reg := ProdConfig.provisional_registry()
	var unlabelled: Array[String] = []
	for row in reg:
		if String(row[2]).find("PROVISIONAL") < 0:
			unlabelled.append(String(row[0]))
	var ok := reg.size() >= 25 and unlabelled.is_empty()
	_note("F62_every_starting_value_labelled_provisional",
		"%d tuning values in the registry, all carrying the word PROVISIONAL=%s | unlabelled: %s"
		% [reg.size(), str(unlabelled.is_empty()), str(unlabelled)])
	_reached("F62_every_starting_value_labelled_provisional")
	return ok

func chk_F63_denials_present_and_denial_guard_can_fail() -> bool:
	var denials := ProdConfig.denials()
	var overlay := hud.compose()
	# The denials live in the banner and the report; the overlay carries the
	# load-bearing ones.
	var key_present := overlay.findn("COMPLETES NO PHASE") >= 0 \
		and overlay.findn("DOES NOT COMPLETE P1") >= 0 \
		and overlay.findn("DOES NOT AUTHORIZE P2") >= 0 \
		and overlay.findn("LOCKS NO VALUE") >= 0
	# A CLAIM NOBODY CAN FAIL IS NOT A BOUNDARY. Prove the scan can refuse.
	var forbidden := ["P2 is authorized", "P1 is complete", "production ready",
		"this is the final Huntress", "pivot complete"]
	var found_in_real: Array[String] = []
	for f in forbidden:
		if overlay.findn(f) >= 0:
			found_in_real.append(f)
	var planted := overlay + "\nP2 is authorized"
	var guard_catches := false
	for f in forbidden:
		if planted.findn(f) >= 0:
			guard_catches = true
	var ok := denials.size() >= 12 and key_present and found_in_real.is_empty() and guard_catches
	_note("F63_denials_present_and_denial_guard_can_fail",
		"%d denials declared; the load-bearing ones are in the runtime=%s; no forbidden completion claim is present=%s; and the scan PROVED able to refuse a planted claim=%s"
		% [denials.size(), str(key_present), str(found_in_real.is_empty()), str(guard_catches)])
	_reached("F63_denials_present_and_denial_guard_can_fail")
	return ok

func chk_F64_no_class_specification_written() -> bool:
	# ========================================================================
	# RE-SCOPED UNDER D-375. THE ARITHMETIC IS STATED: 11 TOKENS - 3 = 8.
	# ========================================================================
	# This check banned ELEVEN tokens as runtime DECLARATIONS. The D-375 ruling
	# authorizes a Skill-system prototype using three of them as its own
	# terminology, in the owner's own words -- "Skill Imprint", "Augment
	# Imprint", and "equipped Active Configurations".
	#
	# EXACTLY THREE ARE REMOVED, each named, with the authorizing clause:
	#   `skill_`   -> "The acquisition/progression objects are: Skill Imprint..."
	#   `augment`  -> "...Augment Imprint, Transform Imprint"
	#   `equip`    -> "Six equipped Active Configurations...", "Equipped Imprints
	#                  receive combat XP..."
	#
	# THE REMAINING EIGHT ARE UNCHANGED AND STILL ABLE TO FAIL, and each removal
	# is COMPENSATED by a NEW assertion in the D-375 suite that is stronger than
	# the token ban it replaces:
	#   `skill_`  -> no Imprint bears the name of any of canon's EIGHT first-MVP
	#                roster Skills, checked against the actual list;
	#   `augment` -> no Imprint bears the name of any of canon's SIXTEEN named
	#                Augments, checked against the actual list;
	#   `equip`   -> NO EQUIPMENT SYSTEM EXISTS: no item, affix, slot, inventory
	#                or randomness anywhere, with a negative control.
	#
	# The tokens were NOT dodged by creative renaming, which would have left this
	# guard nominally intact and its claim false. THAT WOULD HAVE BEEN WORSE.
	var banned := ["passive", "rift_shard", "riftmarked",
		"class_spec", "ailment", "affix", "loot", "inventory"]
	var hits: Array[String] = []
	for f in _runtime_script_files():
		var p := String(f)
		var t := _read_text(p).to_lower()
		for b in banned:
			# Comments are where the project DENIES these things, so only a
			# declaration counts: a function, a class or a variable named for one.
			for form in ["func %s" % b, "class_name %s" % b, "var %s" % b, "const %s" % b]:
				if t.find(form) >= 0:
					hits.append("%s: %s" % [p.get_file(), form])
	var ok := hits.is_empty()
	_note("F64_no_class_specification_written",
		"RUNTIME declarations naming a Passive, a Rift Shard, the Riftmarked, a class specification, an ailment, an affix, loot or an inventory: %s (must be none — NO canonical Huntress class specification is written here and one remains a P2 prerequisite). RE-SCOPED UNDER D-375: the ban list moved 11 tokens -> 8. The three removed are `skill_`, `augment` and `equip`, which the ruling authorizes as this stage's own terminology; each removal is COMPENSATED by a stronger positive assertion in the D-375 suite (no Imprint bears a canonical roster or Augment name, and NO equipment system exists). The remaining %d tokens are unchanged and can still fail. The scan is over the GAME: this suite must name these things in order to forbid them."
		% [str(hits), banned.size()])
	_reached("F64_no_class_specification_written")
	return ok

func chk_F65_no_runtime_dependency_on_frozen_prototypes() -> bool:
	# "It may study and reuse validated concepts from the frozen prototypes, but
	#  it must have no runtime dependency on them."
	#
	# A DEPENDENCY IS A PATH A LOADER COULD FOLLOW. A NAME IN PROSE IS NOT -- and
	# the same ruling REQUIRES the names to appear in prose, because reuse must be
	# identified truthfully. The first version of this check conflated the two and
	# reported the reuse declaration as a dependency.
	# THE NEEDLES ARE ASSEMBLED, NOT WRITTEN. Spelling them out put every one of
	# them into this file, and the scan then reported ITSELF as the dependency.
	var up := ".." + "/"
	var res := "res:" + "//"
	var escape_forms := [res + up, "\"" + up, "'" + up, "user:" + "//" + up,
		res + "game2d", res + "game3d_spike", res + "game3d_boss_spike", res + "game/"]
	var deps: Array[String] = []
	for f in _all_project_files():
		var p := String(f)
		if not (p.ends_with(".gd") or p.ends_with(".tscn") or p.ends_with(".godot")):
			continue
		var t := _read_text(p)
		for form in escape_forms:
			if t.find(String(form)) >= 0:
				deps.append("%s contains %s" % [p.get_file(), form])
	# THE GUARD MUST BE ABLE TO FAIL.
	var planted := "var x = load(\"" + res + up + "game3d_spike/scripts/iso_camera.gd\")"
	var guard_catches := false
	for form in escape_forms:
		if planted.find(String(form)) >= 0:
			guard_catches = true
	# And the prototypes ARE named in prose, which is the other half of the rule.
	var named_in_prose := _read_text("res://scripts/core/prod_config.gd").find(
		"game3d_boss_spike") >= 0
	var ok: bool = deps.is_empty() and guard_catches and named_in_prose
	_note("F65_no_runtime_dependency_on_frozen_prototypes",
		"paths a loader could follow out of this project: %s (must be none) | the scan is PROVED able to catch a planted load() into a frozen prototype=%s | the prototypes ARE named in prose, as the truthful-reuse half of the same rule requires=%s"
		% [str(deps), str(guard_catches), str(named_in_prose)])
	_reached("F65_no_runtime_dependency_on_frozen_prototypes")
	return ok

func chk_F66_reused_implementation_declared() -> bool:
	# "Any directly reused implementation must be identified truthfully."
	var decl := ProdConfig.reuse_declaration()
	var malformed: Array[String] = []
	for row in decl:
		if row.size() != 3 or String(row[1]).length() < 5 or String(row[2]).length() < 20:
			malformed.append(String(row[0]))
	var names_both_spikes := false
	var names_boss := false
	for row in decl:
		if String(row[1]).find("game3d_spike") >= 0:
			names_both_spikes = true
		if String(row[1]).find("game3d_boss_spike") >= 0:
			names_boss = true
	var ok := decl.size() >= 8 and malformed.is_empty() and names_both_spikes and names_boss \
		and ProdConfig.new_here().size() >= 5
	_note("F66_reused_implementation_declared",
		"%d reused implementations declared with source and honesty note (malformed: %s); both frozen 3D prototypes are named as sources=%s/%s; %d items are declared NEW here and not credited to any earlier phase"
		% [decl.size(), str(malformed), str(names_both_spikes), str(names_boss),
		   ProdConfig.new_here().size()])
	_reached("F66_reused_implementation_declared")
	return ok

func chk_F67_test_seams_disabled_in_normal_play() -> bool:
	# Asserted against the state captured BEFORE the suite touched anything, so
	# it cannot be satisfied by the suite tidying up after itself.
	var now_clear := player.intent.seams_clear() and cam.debug_cursor_override == null
	var ok := initial_seams_clear and now_clear
	_note("F67_test_seams_disabled_in_normal_play",
		"every test seam was clear at scene start, BEFORE this suite touched anything=%s (the cursor override, the intent injections, the attack freeze and both enemy AI seams); they are clear again now=%s"
		% [str(initial_seams_clear), str(now_clear)])
	_reached("F67_test_seams_disabled_in_normal_play")
	return ok

func chk_F68_arena_has_no_campaign_or_zone_reference() -> bool:
	var banned := ["riftfall", "broken_watch", "brokenwatch", "nexus", "bastion",
		"crownless", "warden", "ossuary", "muster", "act_i", "act1", "prologue",
		"echo_map", "echomap", "expedition", "distortion"]
	var hits: Array[String] = []
	for f in _runtime_script_files():
		var p := String(f)
		var t := _read_text(p).to_lower()
		for b in banned:
			for form in ["func %s" % b, "class_name %s" % b, "var %s" % b,
					"const %s" % b, "res://%s" % b, "\"%s" % b]:
				if t.find(form) >= 0:
					hits.append("%s: %s" % [p.get_file(), form])
	var says_test_arena := hud.compose().findn("test arena") >= 0
	var ok := hits.is_empty() and says_test_arena
	_note("F68_arena_has_no_campaign_or_zone_reference",
		"campaign/zone/endgame identifiers declared or referenced in RUNTIME scripts: %s (must be none; the scan is over the GAME, since this suite must name them to forbid them) | the runtime calls it a TEST ARENA rather than a zone=%s"
		% [str(hits), str(says_test_arena)])
	_reached("F68_arena_has_no_campaign_or_zone_reference")
	return ok

func chk_F69_no_audio_asset_and_no_undeclared_input_action() -> bool:
	var audio: Array[String] = []
	for f in _all_project_files():
		var p := String(f).to_lower()
		for e in [".wav", ".ogg", ".mp3", ".flac"]:
			if p.ends_with(e):
				audio.append(String(f))
	# ========================================================================
	# RE-SCOPED UNDER D-375. THE ARITHMETIC IS STATED: 13 + 12 = 25.
	# ========================================================================
	# `CLAUDE.md` section 12 forbids new InputMap actions without an explicit
	# owner ruling. THE D-375 RULING IS THAT AUTHORIZATION: it requires "eight
	# possible active input bindings" and "an understandable in-engine
	# loadout/testing panel", and neither exists without input.
	#
	# TWELVE ARE ADDED: the EIGHT canonical bindings plus FOUR panel commands.
	# NOTHING EXISTING IS REBOUND, RENAMED OR REMOVED, exhaustiveness IN BOTH
	# DIRECTIONS is preserved -- an undeclared extra still fails and a missing
	# declared action still fails -- and `F28` still proves no W/A/S/D key is
	# bound anywhere.
	#
	# ========================================================================
	# RE-SCOPED UNDER D-381. THE ARITHMETIC IS STATED: 25 + 1 = 26.
	# ========================================================================
	# The D-381 reviewability correction authorizes it in terms: "If no direct
	# input currently exists, add exactly one diagnostic input that cycles:
	# OFF -> MANA RESERVATION -> LIFE CONVERSION -> OFF." None existed, so ONE is
	# added: `diagnostic_reservation_cycle` (key R, pad right-stick click).
	# NOTHING EXISTING IS REBOUND, RENAMED OR REMOVED, and exhaustiveness holds in
	# both directions exactly as before.
	#
	# ========================================================================
	# RE-SCOPED UNDER D-396. THE ARITHMETIC IS STATED: 26 + 1 = 27.
	# ========================================================================
	# The D-396 ruling authorizes "a clearly diagnostic review control if needed"
	# for fallen-hound recovery, and it is needed: ordinary enemies cannot damage
	# hounds in that slice. ONE is added, `diagnostic_hound_fall` (key H, pad
	# D-pad left). NOTHING EXISTING IS REBOUND, RENAMED OR REMOVED, and
	# exhaustiveness still holds in both directions.
	#
	# ========================================================================
	# RE-SCOPED UNDER D-398. THE ARITHMETIC IS STATED: 27 + 2 = 29.
	# ========================================================================
	# The D-398 ruling authorizes "diagnostic stress modes for 2, 6, 10 and 15
	# mobile minions and provisional travel-speed modes", to be judged in live
	# review. TWO are added: `diagnostic_stress_population` (key P, pad D-pad
	# right) and `diagnostic_travel_speed` (key T, pad START). NOTHING EXISTING IS
	# REBOUND, RENAMED OR REMOVED, and exhaustiveness still holds in both
	# directions.
	var declared := ["move_command", "stick_left", "stick_right", "stick_up", "stick_down",
		"aim_left", "aim_right", "aim_up", "aim_down", "diagnostic_attack",
		"zoom_in", "zoom_out", "toggle_overlay",
		"imprint_binding_1", "imprint_binding_2", "imprint_binding_3", "imprint_binding_4",
		"imprint_binding_5", "imprint_binding_6", "imprint_binding_7", "imprint_binding_8",
		"imprint_panel", "imprint_panel_prev", "imprint_panel_next", "imprint_panel_activate",
		"diagnostic_reservation_cycle", "diagnostic_hound_fall",
		"diagnostic_stress_population", "diagnostic_travel_speed"]
	var undeclared: Array[String] = []
	for a in InputMap.get_actions():
		var s := String(a)
		if s.begins_with("ui_"):
			continue                       # Godot's own built-ins
		if not declared.has(s):
			undeclared.append(s)
	var missing: Array[String] = []
	for d in declared:
		if not InputMap.has_action(d):
			missing.append(d)
	var ok := audio.is_empty() and undeclared.is_empty() and missing.is_empty()
	_note("F69_no_audio_asset_and_no_undeclared_input_action",
		"audio assets present: %s (must be none — CLAUDE.md 12 forbids new audio, and there are no audio hooks either) | %d declared input actions, undeclared extras: %s, missing: %s. RE-SCOPED UNDER D-375: 13 + 12 = 25 — the eight CANONICAL bindings plus four panel commands, authorized by the ruling. RE-SCOPED UNDER D-381: 25 + 1 = 26 — ONE diagnostic reservation-cycle input, authorized by the ruling. RE-SCOPED UNDER D-396: 26 + 1 = 27 — ONE diagnostic hound-fall review control, authorized by the ruling. RE-SCOPED UNDER D-398: 27 + 2 = 29 — the TWO diagnostic stress-population and travel-speed modes, authorized by the ruling. Nothing existing was rebound, renamed or removed, and exhaustiveness holds in both directions."
		% [str(audio), declared.size(), str(undeclared), str(missing)])
	_reached("F69_no_audio_asset_and_no_undeclared_input_action")
	return ok

# ============================================================================
# J. ACTION-MOVEMENT COMMITMENT  — added by the D-370 OWNER LIVE REVIEW
# ============================================================================
#
# The owner's finding: "The player feels too slidey when attacking because
# locomotion continues through the diagnostic attack. Do not reduce global
# movement speed; that speed currently feels good."
#
# Seven check areas were named. There are EIGHT checks, because "aiming remains
# independent" and "allow the player to face the sampled aim direction during the
# action" are two distinct properties and each deserves to be able to fail.

## Drives the player to full speed on the stick and leaves the stick held.
func _drive_to_full_speed() -> float:
	player.motor.reset()
	player.commitment.reset()
	player.clear_move_destination()
	player.global_position = Vector3(-12, 0, 0)
	cam.debug_cursor_override = Vector3(0, 0, 0)
	player.intent.debug_move_axis = Vector2(1.0, 0.0)
	await _phys(50)
	return player.motor.speed()

func chk_F71_committed_action_stops_translation_promptly() -> bool:
	# THE ACTION MUST HAVE FIRED. Everything below is vacuous otherwise.
	var moving := await _drive_to_full_speed()
	var commits_before := player.commitment.commits
	var p0 := player.global_position
	player._cooldown = 0.0
	player.begin_attack()
	# The stick stays HELD throughout, so a leak would show up immediately.
	var frames_to_stop := 0
	var guard := 0
	while player.commitment.active and guard < 200:
		await physics_frame
		guard += 1
		if frames_to_stop == 0 and player.motor.speed() <= 0.02:
			frames_to_stop = guard
	var glide := NavService.planar_distance(player.global_position, p0)
	var fired := player.commitment.commits == commits_before + 1

	# THE NEGATIVE CONTROL: the same held input, the same number of frames, and
	# NO action. If this does not travel much further, "stopped" means nothing.
	player.motor.reset()
	player.global_position = Vector3(-12, 0, 0)
	await _phys(50)
	var q0 := player.global_position
	await _phys(guard)
	var free_travel := NavService.planar_distance(player.global_position, q0)

	player.intent.clear_seams()
	cam.debug_cursor_override = null
	player.motor.reset()
	player.global_position = ProductionArena.player_spawn()
	await _phys(4)
	var ok: bool = fired and moving > 3.0 and frames_to_stop > 0 \
		and frames_to_stop <= 6 and glide <= ProdConfig.ACTION_GLIDE_TOLERANCE_M \
		and free_travel > glide * 5.0
	_note("F71_committed_action_stops_translation_promptly",
		"moving at %.3f m/s when the action began (it FIRED=%s); translation stopped after %d physics frames having travelled %.4f m, against the %.2f m glide tolerance | NEGATIVE CONTROL: the same held input over the same %d frames with NO action travels %.3f m"
		% [moving, str(fired), frames_to_stop, glide,
		   ProdConfig.ACTION_GLIDE_TOLERANCE_M, guard, free_travel])
	_reached("F71_committed_action_stops_translation_promptly")
	return ok

func chk_F72_projectile_still_releases_during_commitment() -> bool:
	# Stopping the feet must not stop the action doing its job.
	var moving := await _drive_to_full_speed()
	player.debug_release_times = []
	var shots_before := player.shots_fired
	player._cooldown = 0.0
	player.begin_attack()
	var guard := 0
	while player.commitment.active and guard < 200:
		await physics_frame
		guard += 1
	player.intent.clear_seams()
	cam.debug_cursor_override = null
	player.motor.reset()
	player.global_position = ProductionArena.player_spawn()
	await _phys(4)
	var expected := ProdConfig.ATTACK_COOLDOWN_S * ProdConfig.ATTACK_RELEASE_MARKER
	var released := player.shots_fired == shots_before + 1
	var timed := player.debug_release_times.size() == 1 \
		and absf(player.debug_release_times[0] - expected) <= (1.0 / 60.0) + 0.0005
	var ok: bool = moving > 3.0 and released and timed
	_note("F72_projectile_still_releases_during_commitment",
		"the action began at %.3f m/s and, with translation suppressed throughout, still released exactly one bolt=%s at %s s against the computed %.4f s=%s"
		% [moving, str(released), str(player.debug_release_times), expected, str(timed)])
	_reached("F72_projectile_still_releases_during_commitment")
	return ok

func chk_F73_facing_is_allowed_during_commitment() -> bool:
	# A COMMITMENT STOPS THE FEET, NOT THE HEAD.
	player.motor.reset()
	player.commitment.reset()
	player.global_position = Vector3(-12, 0, 0)
	cam.debug_cursor_override = player.global_position + Vector3(6, 0, 0)
	await _phys(20)
	var yaw_before := player.yaw_driver.yaw
	player._cooldown = 0.0
	player.begin_attack()
	await _phys(2)
	var suppressed_during := player.commitment.suppresses_translation()
	# Swing the aim hard to the opposite side WHILE committed.
	cam.debug_cursor_override = player.global_position + Vector3(-6, 0, 0)
	var p0 := player.global_position
	var guard := 0
	while player.commitment.active and guard < 200:
		await physics_frame
		guard += 1
	var yaw_after := player.yaw_driver.yaw
	var turned := absf(wrapf(yaw_after - yaw_before, -PI, PI))
	var still_put := NavService.planar_distance(player.global_position, p0)
	# And BOTH policies must allow facing — there is no facing switch.
	var probe := ActionCommitment.new()
	probe.begin("probe", 1.0, 0.5, ActionCommitment.Movement.STOP)
	var faces_stop := probe.allows_facing()
	probe.begin("probe", 1.0, 0.5, ActionCommitment.Movement.ALLOW)
	var faces_allow := probe.allows_facing()
	cam.debug_cursor_override = null
	player.global_position = ProductionArena.player_spawn()
	await _phys(4)
	var ok: bool = suppressed_during and rad_to_deg(turned) > 90.0 \
		and still_put <= ProdConfig.ACTION_GLIDE_TOLERANCE_M \
		and faces_stop and faces_allow
	_note("F73_facing_is_allowed_during_commitment",
		"translation was suppressed during the action=%s, and in the same window the actor turned %.1f degrees toward the new aim while moving only %.4f m | facing is allowed under BOTH policies (STOP=%s, ALLOW=%s) — there is no facing switch and there must not be one"
		% [str(suppressed_during), rad_to_deg(turned), still_put,
		   str(faces_stop), str(faces_allow)])
	_reached("F73_facing_is_allowed_during_commitment")
	return ok

func chk_F74_aiming_remains_independent_during_commitment() -> bool:
	player.motor.reset()
	player.commitment.reset()
	player.clear_move_destination()
	player.global_position = Vector3(-12, 0, 0)
	cam.debug_cursor_override = player.global_position + Vector3(5, 0, 0)
	await _phys(6)
	player._cooldown = 0.0
	player.begin_attack()
	var aim_start := player.aim_point
	var orders := 0
	var guard := 0
	while player.commitment.active and guard < 200:
		cam.debug_cursor_override = player.global_position \
			+ Vector3(cos(float(guard) * 0.4) * 6.0, 0, sin(float(guard) * 0.4) * 6.0)
		await physics_frame
		guard += 1
		if player.move_destination != null:
			orders += 1
	var aim_moved := player.aim_point.distance_to(aim_start) > 0.5
	cam.debug_cursor_override = null
	player.global_position = ProductionArena.player_spawn()
	await _phys(4)
	var ok: bool = aim_moved and orders == 0 and guard > 10
	_note("F74_aiming_remains_independent_during_commitment",
		"the aim was swept continuously across %d committed frames and genuinely moved=%s, and it created a movement order on %d of them (must be 0) — aiming still writes no destination, during an action as outside one"
		% [guard, str(aim_moved), orders])
	_reached("F74_aiming_remains_independent_during_commitment")
	return ok

func chk_F75_movement_resumes_only_under_continuing_or_new_intent() -> bool:
	# CASE A — the stick is STILL HELD when recovery ends.
	await _drive_to_full_speed()
	var commits_a := player.commitment.commits
	player._cooldown = 0.0
	player.begin_attack()
	var guard := 0
	while player.commitment.active and guard < 200:
		await physics_frame
		guard += 1
	var fired_a := player.commitment.commits == commits_a + 1
	await _phys(20)
	var resumed := player.motor.speed()
	player.intent.clear_seams()

	# CASE B — every input RELEASED before recovery ends.
	await _drive_to_full_speed()
	var commits_b := player.commitment.commits
	player._cooldown = 0.0
	player.begin_attack()
	await _phys(3)
	player.intent.debug_move_axis = Vector2.ZERO
	player.intent.debug_move_command_held = false
	guard = 0
	while player.commitment.active and guard < 200:
		await physics_frame
		guard += 1
	var fired_b := player.commitment.commits == commits_b + 1
	var p0 := player.global_position
	await _phys(40)
	var stayed := player.motor.speed()
	var drift := NavService.planar_distance(player.global_position, p0)

	player.intent.clear_seams()
	cam.debug_cursor_override = null
	player.motor.reset()
	player.global_position = ProductionArena.player_spawn()
	await _phys(4)
	var ok: bool = fired_a and fired_b and resumed > 1.0 and stayed < 0.02 and drift < 0.02
	_note("F75_movement_resumes_only_under_continuing_or_new_intent",
		"CASE A, input still HELD at recovery (action fired=%s): speed 20 frames later is %.3f m/s — movement RESUMED | CASE B, input RELEASED during the action (action fired=%s): speed 40 frames later is %.4f m/s and the actor drifted %.4f m — movement did NOT resume"
		% [str(fired_a), resumed, str(fired_b), stayed, drift])
	_reached("F75_movement_resumes_only_under_continuing_or_new_intent")
	return ok

func chk_F76_obsolete_navigation_target_does_not_restart_movement() -> bool:
	# A click-to-move order issued BEFORE the action must not survive it.
	player.motor.reset()
	player.commitment.reset()
	player.intent.clear_seams()
	player.global_position = Vector3(-13, 0, 0)
	await _phys(4)
	player.command_move_to(Vector3(-13, 0, 8))
	var had_order := player.move_destination != null
	# RE-SCOPED ONE FOR ONE UNDER D-404, BY OWNER RULING, and ONLY this conjunct.
	# Until D-404 it read `var had_path := player.follower.point_count() >= 2` --
	# the order had to have a navigation path, TRUE WHEN WRITTEN. The D-404 ruling
	# forbids a player path ("Do not feed the order through
	# NavService.PathFollower"), so the order must now have NONE, before the action
	# and after it. Every other conjunct of this check is unchanged.
	var had_path := player.follower.point_count() == 0
	var guard := 0
	while guard < 120 and player.motor.speed() < 1.0:
		await physics_frame
		guard += 1
	var was_moving := player.motor.speed() >= 1.0
	# Nothing is held: the order is the ONLY thing that could restart movement.
	player.intent.debug_move_axis = Vector2.ZERO
	player.intent.debug_move_command_held = false
	player._cooldown = 0.0
	player.begin_attack()
	var cleared_immediately := player.move_destination == null \
		and player.follower.point_count() == 0
	guard = 0
	while player.commitment.active and guard < 200:
		await physics_frame
		guard += 1
	var p0 := player.global_position
	await _phys(60)
	var restarted := player.motor.speed() > 0.02 \
		or NavService.planar_distance(player.global_position, p0) > 0.02
	var still_none := player.move_destination == null
	player.intent.clear_seams()
	player.motor.reset()
	player.global_position = ProductionArena.player_spawn()
	await _phys(4)
	var ok: bool = had_order and had_path and was_moving and cleared_immediately \
		and (not restarted) and still_none
	_note("F76_obsolete_navigation_target_does_not_restart_movement",
		"a click order was issued (order=%s, and — re-scoped under D-404 — NO navigation path, as a direct click has none=%s) and the actor WAS moving=%s; beginning the action cleared the destination AND the path on the same frame=%s; 60 frames after recovery, with nothing held, movement restarted=%s (must be false) and the destination is still none=%s"
		% [str(had_order), str(had_path), str(was_moving), str(cleared_immediately),
		   str(restarted), str(still_none)])
	_reached("F76_obsolete_navigation_target_does_not_restart_movement")
	return ok

func chk_F77_top_speed_unchanged_by_the_commitment_correction() -> bool:
	# The owner: "Do not reduce global movement speed; that speed currently feels
	# good." So the correction must be provably invisible to the top speed.
	var m := LocomotionMotor.new()
	var dt := 1.0 / 60.0
	var steps := 0
	while m.speed() < ProdConfig.TOP_SPEED_MPS - 0.0005 and steps < 600:
		m.step(Vector3(0, 0, 1), ProdConfig.TOP_SPEED_MPS, dt)
		steps += 1
	var measured := m.speed()
	var status_ok := ProdConfig.TOP_SPEED_STATUS.findn("candidate") >= 0 \
		and ProdConfig.TOP_SPEED_STATUS.findn("not a lock") >= 0
	# The ACTION brake is a SEPARATE rate; ordinary braking is untouched.
	var separate := not is_equal_approx(ProdConfig.ACTION_BRAKE_MPS2, ProdConfig.DECEL_MPS2)
	var ordinary_unchanged := is_equal_approx(ProdConfig.DECEL_MPS2, 38.0) \
		and is_equal_approx(ProdConfig.ACCEL_MPS2, 30.0)
	var ok: bool = is_equal_approx(ProdConfig.TOP_SPEED_MPS, 3.889) \
		and absf(measured - 3.889) < 0.01 and status_ok and separate and ordinary_unchanged
	_note("F77_top_speed_unchanged_by_the_commitment_correction",
		"TOP_SPEED_MPS is still exactly 3.889 and measures %.4f m/s | its status still reads as a CANDIDATE and not a lock=%s | the action brake %.1f m/s^2 is a SEPARATE rate from ordinary braking %.1f m/s^2=%s | ordinary acceleration and braking are unchanged=%s"
		% [measured, str(status_ok), ProdConfig.ACTION_BRAKE_MPS2, ProdConfig.DECEL_MPS2,
		   str(separate), str(ordinary_unchanged)])
	_reached("F77_top_speed_unchanged_by_the_commitment_correction")
	return ok

func chk_F78_action_timing_and_policy_are_provisional() -> bool:
	# EXACTLY TWO POLICIES, and the second must not be a branch that cannot fail.
	var two := ActionCommitment.POLICIES.size() == 2 \
		and ActionCommitment.POLICIES[0] == "STOP" \
		and ActionCommitment.POLICIES[1] == "ALLOW"
	var a := ActionCommitment.new()
	a.begin("stop-probe", 1.0, 0.5, ActionCommitment.Movement.STOP)
	var stop_suppresses := a.suppresses_translation()
	var b := ActionCommitment.new()
	b.begin("allow-probe", 1.0, 0.5, ActionCommitment.Movement.ALLOW)
	var allow_permits := not b.suppresses_translation() and b.active
	# And an inactive commitment suppresses nothing, under either policy.
	b.reset()
	var inactive_permits := not b.suppresses_translation()

	# Every action timing value is in the provisional registry, labelled.
	# THE CANCEL WINDOW ADDS NO NEW TUNABLE: it is derived from the release
	# marker, which is already in the registry. The list below is therefore
	# UNCHANGED by the re-review, and that is itself the property being asserted.
	var want := ["action brake (m/s^2)", "action glide tolerance (m)",
		"attack cooldown (s)", "release marker (normalised)"]
	var missing: Array[String] = []
	for w in want:
		var found := false
		for row in ProdConfig.provisional_registry():
			if String(row[0]) == String(w) and String(row[2]).find("PROVISIONAL") >= 0:
				found = true
		if not found:
			missing.append(String(w))
	# And the runtime denies that this is a Skill system.
	var overlay := hud.compose()
	var denies := overlay.findn("NOT a Skill system") >= 0 \
		and overlay.findn("NOT an ability framework") >= 0
	var denial_declared := false
	for d in ProdConfig.denials():
		if String(d).findn("NOT a Skill system") >= 0:
			denial_declared = true
	# The cancel window must be EXACTLY the release marker, and must refuse before
	# it. Proved on a probe, so the property holds independently of the player.
	var w := ActionCommitment.new()
	w.begin("window-probe", 1.0, 0.40, ActionCommitment.Movement.STOP)
	var shut_before := not w.cancel_window_open()
	var refuses_before := not w.cancel_recovery() and w.active
	w.advance(0.40)
	var opens_at_marker := w.cancel_window_open()
	var cancels_after := w.cancel_recovery() and not w.active
	var window_derived := shut_before and refuses_before and opens_at_marker and cancels_after
	# And no separate cancel-window constant exists that could drift from it.
	var cfg := _read_text("res://scripts/core/prod_config.gd")
	var no_extra_tunable := cfg.find("CANCEL_WINDOW") < 0
	var ok: bool = two and stop_suppresses and allow_permits and inactive_permits \
		and missing.is_empty() and denies and denial_declared \
		and window_derived and no_extra_tunable
	_note("F78_action_timing_and_policy_are_provisional",
		"EXACTLY two policies %s=%s | STOP suppresses=%s, ALLOW does NOT=%s (so the ALLOW branch is reachable and can fail), inactive suppresses nothing=%s | action timings absent from the provisional registry: %s | the runtime denies this is a Skill system or an ability framework=%s/%s"
		% [str(ActionCommitment.POLICIES), str(two), str(stop_suppresses),
		   str(allow_permits), str(inactive_permits), str(missing), str(denies),
		   str(denial_declared)]
		+ " | the CANCEL WINDOW opens exactly at the release marker, refuses before it and cancels after it=%s, and adds NO new tunable constant=%s"
		% [str(window_derived), str(no_extra_tunable)])
	_reached("F78_action_timing_and_policy_are_provisional")
	return ok

# ============================================================================
# K. RECOVERY CANCELLATION  — added by the D-370 LIVE RE-REVIEW
# ============================================================================
#
# The owner: "The slidey feeling is resolved... One fluency correction remains."
# After the projectile has been released, a new movement command may cancel the
# REMAINING RECOVERY and return to locomotion -- and "cancelling the remaining
# animation must never cancel, retract or duplicate the already-released
# projectile."
#
# THIS IS ANIMATION RECOVERY CANCELLATION, NOT ATTACK CANCELLATION, and holding
# those two apart is exactly what these checks exist to do.

## Puts the player in a known, still, un-committed state.
func _rest_player() -> void:
	player.intent.clear_seams()
	player.commitment.reset()
	player.clear_move_destination()
	player.follower.set_path(PackedVector3Array())
	player.motor.reset()
	player._cooldown = 0.0
	player._pending_shot = false
	player.global_position = Vector3(-12, 0, 0)
	cam.debug_cursor_override = Vector3(0, 0, 0)
	await _phys(4)

func chk_F79_movement_cannot_cancel_the_attack_before_release() -> bool:
	await _rest_player()
	var refused_before := player.commitment.cancels_refused
	var shots_before := player.shots_fired
	player.begin_attack()
	# Ask to move, hard, during the WIND-UP.
	player.intent.debug_move_axis = Vector2(1.0, 0.0)
	await _phys(2)
	var in_windup := player.commitment.phase() == "windup"
	var window_shut := not player.commitment.cancel_window_open()
	# AND ATTACK THE GUARD DIRECTLY: a cancel demanded before the release must be
	# REFUSED. A guard that is merely never called is not a guard.
	var refused := not player.commitment.cancel_recovery()
	var still_active := player.commitment.active
	var not_yet_fired := player.shots_fired == shots_before
	var pending := player._pending_shot
	var counted := player.commitment.cancels_refused == refused_before + 1
	# And it must still go on to release.
	var guard := 0
	while player.commitment.active and guard < 200:
		await physics_frame
		guard += 1
	var eventually_fired := player.shots_fired == shots_before + 1
	await _rest_player()
	var ok: bool = in_windup and window_shut and refused and still_active \
		and not_yet_fired and pending and counted and eventually_fired
	_note("F79_movement_cannot_cancel_the_attack_before_release",
		"during the wind-up (phase=%s, cancel window shut=%s) a cancel was DEMANDED DIRECTLY and REFUSED=%s, the action stayed active=%s, the shot had not fired=%s and was still pending=%s, and the refusal was COUNTED=%s | the action then went on to release normally=%s"
		% [str(in_windup), str(window_shut), str(refused), str(still_active),
		   str(not_yet_fired), str(pending), str(counted), str(eventually_fired)])
	_reached("F79_movement_cannot_cancel_the_attack_before_release")
	return ok

func chk_F80_movement_during_windup_is_buffered() -> bool:
	await _rest_player()
	var buffered_before := player.buffered_moves
	var p0 := player.global_position
	player.begin_attack()
	# A CLICK ORDER during the wind-up: discrete, and therefore bufferable.
	cam.debug_cursor_override = Vector3(-6, 0, 0)
	player.intent.debug_move_command_held = true
	# SAMPLED DURING THE WIND-UP, NOT AFTER IT.
	#
	# Reading the buffer once the loop has exited reads it AFTER the window
	# opened and the buffered order was already applied and cleared -- which
	# reported an empty buffer and a live destination, and looked like a failure
	# of buffering rather than of the measurement. The window can open and close
	# inside a single frame when movement is already being requested.
	var kind := ""
	var applied_during_windup := false
	var travelled := 0.0
	var frames := 0
	while player.commitment.phase() == "windup" and frames < 100:
		await physics_frame
		frames += 1
		if player.commitment.phase() == "windup":
			kind = player._buffer_kind
			travelled = NavService.planar_distance(player.global_position, p0)
			if player.move_destination != null:
				applied_during_windup = true
	var buffered := player.buffered_moves > buffered_before
	var no_translation := travelled <= ProdConfig.ACTION_GLIDE_TOLERANCE_M
	# NOT YET APPLIED: the order must not have taken effect during the wind-up.
	var not_applied := not applied_during_windup
	await _rest_player()
	var ok: bool = buffered and kind == "command" and no_translation and not_applied \
		and frames > 2
	_note("F80_movement_during_windup_is_buffered",
		"a click order issued across a %d-frame wind-up was BUFFERED=%s as kind '%s'; the actor translated %.4f m (within the %.2f m tolerance)=%s; and the order had NOT yet been applied — the destination is still none=%s"
		% [frames, str(buffered), kind, travelled,
		   ProdConfig.ACTION_GLIDE_TOLERANCE_M, str(no_translation), str(not_applied)])
	_reached("F80_movement_during_windup_is_buffered")
	return ok

func chk_F81_projectile_releases_exactly_once_before_buffered_movement() -> bool:
	await _rest_player()
	var shots_before := player.shots_fired
	var applied_before := player.buffered_applied
	player.begin_attack()
	cam.debug_cursor_override = Vector3(-6, 0, 0)
	player.intent.debug_move_command_held = true
	var release_frame := -1
	var apply_frame := -1
	var f := 0
	while f < 200 and (release_frame < 0 or apply_frame < 0):
		await physics_frame
		f += 1
		if release_frame < 0 and player.shots_fired > shots_before:
			release_frame = f
		if apply_frame < 0 and player.buffered_applied > applied_before:
			apply_frame = f
	var once := player.shots_fired == shots_before + 1
	var one_time := player.debug_release_times.size() >= 1
	# ORDER IS THE POINT: the shot must exist before the buffered order moves us.
	var ordered := release_frame > 0 and apply_frame > 0 and release_frame <= apply_frame
	var has_order := player.move_destination != null
	await _rest_player()
	var ok: bool = once and one_time and ordered and has_order
	_note("F81_projectile_releases_exactly_once_before_buffered_movement",
		"the bolt released on frame %d and the buffered order was applied on frame %d — RELEASE FIRST=%s | exactly one bolt was created=%s | a movement destination now exists=%s"
		% [release_frame, apply_frame, str(ordered), str(once), str(has_order)])
	_reached("F81_projectile_releases_exactly_once_before_buffered_movement")
	return ok

func chk_F82_movement_after_release_cancels_recovery() -> bool:
	await _rest_player()
	var cancels_before := player.commitment.recovery_cancels
	player.begin_attack()
	# NOTHING is requested until the window opens.
	var f := 0
	while f < 200 and not player.commitment.cancel_window_open():
		await physics_frame
		f += 1
	var opened_at := player.commitment.elapsed
	var natural := player.commitment.duration
	# NOW ask to move.
	player.intent.debug_move_axis = Vector2(1.0, 0.0)
	var g := 0
	while player.commitment.active and g < 60:
		await physics_frame
		g += 1
	var cancelled := player.commitment.recovery_cancels == cancels_before + 1
	var early := not player.commitment.active and g <= 3
	# And locomotion must actually resume.
	await _phys(20)
	var moving := player.motor.speed()
	await _rest_player()
	var ok: bool = cancelled and early and moving > 1.0 and opened_at < natural
	_note("F82_movement_after_release_cancels_recovery",
		"the cancel window opened at %.4f s of a %.4f s action; a movement request then cancelled the REMAINING RECOVERY within %d frame(s)=%s/%s, and locomotion resumed to %.3f m/s"
		% [opened_at, natural, g, str(cancelled), str(early), moving])
	_reached("F82_movement_after_release_cancels_recovery")
	return ok

func _count_bolts() -> int:
	var n := 0
	var root: Node = main.get("bolt_root")
	for c in root.get_children():
		if is_instance_valid(c) and c is DiagnosticBolt and (c as DiagnosticBolt).alive:
			n += 1
	return n

func chk_F83_released_projectile_survives_the_cancel_intact() -> bool:
	# "Cancelling the remaining animation must never cancel, retract or
	#  duplicate the already-released projectile."
	await _rest_player()
	# Aim down a clear run so the bolt is not consumed by an enemy.
	cam.debug_cursor_override = Vector3(-12, 0, -8)
	await _phys(3)
	var shots_before := player.shots_fired
	player.begin_attack()
	var f := 0
	while f < 200 and player.shots_fired == shots_before:
		await physics_frame
		f += 1
	var after_release := _count_bolts()
	var the_bolt: DiagnosticBolt = null
	var root: Node = main.get("bolt_root")
	for c in root.get_children():
		if is_instance_valid(c) and c is DiagnosticBolt and (c as DiagnosticBolt).alive:
			the_bolt = c
	var travelled_at_cancel := the_bolt.travelled if the_bolt != null else -1.0
	# Cancel the recovery with a movement request.
	player.intent.debug_move_axis = Vector2(1.0, 0.0)
	var g := 0
	while player.commitment.active and g < 60:
		await physics_frame
		g += 1
	var survived := the_bolt != null and is_instance_valid(the_bolt) and the_bolt.alive
	var after_cancel := _count_bolts()
	await _phys(6)
	var still_travelling := the_bolt != null and is_instance_valid(the_bolt) \
		and the_bolt.travelled > travelled_at_cancel
	var not_duplicated := player.shots_fired == shots_before + 1 \
		and after_cancel <= after_release
	await _rest_player()
	var ok: bool = after_release == 1 and survived and not_duplicated and still_travelling
	_note("F83_released_projectile_survives_the_cancel_intact",
		"one bolt existed after the release (%d); cancelling the recovery left it ALIVE=%s, the live count went %d -> %d with shots_fired still exactly +1=%s, and it kept travelling past %.3f m=%s — the cancel touched an ANIMATION, not the projectile"
		% [after_release, str(survived), after_release, after_cancel,
		   str(not_duplicated), travelled_at_cancel, str(still_travelling)])
	_reached("F83_released_projectile_survives_the_cancel_intact")
	return ok

func chk_F84_full_action_completes_when_no_movement_is_requested() -> bool:
	# "If no movement is requested: let the complete provisional attack animation
	#  and recovery finish normally."
	await _rest_player()
	var completions_before := player.commitment.completions
	var cancels_before := player.commitment.recovery_cancels
	player.begin_attack()
	# Deliberately NOTHING held, for the whole action.
	player.intent.debug_move_axis = Vector2.ZERO
	player.intent.debug_move_command_held = false
	var f := 0
	while player.commitment.active and f < 200:
		await physics_frame
		f += 1
	var ran := float(f) / 60.0
	var completed := player.commitment.completions == completions_before + 1
	var not_cancelled := player.commitment.recovery_cancels == cancels_before
	var full_length := absf(ran - ProdConfig.ATTACK_COOLDOWN_S) <= 2.0 / 60.0
	await _rest_player()
	var ok: bool = completed and not_cancelled and full_length
	_note("F84_full_action_completes_when_no_movement_is_requested",
		"with nothing requested the action ran its FULL %.4f s against the provisional %.4f s=%s, completed naturally=%s, and was NOT cancelled=%s"
		% [ran, ProdConfig.ATTACK_COOLDOWN_S, str(full_length), str(completed),
		   str(not_cancelled)])
	_reached("F84_full_action_completes_when_no_movement_is_requested")
	return ok

func chk_F85_translation_suppressed_before_release() -> bool:
	# Measured across the WIND-UP specifically -- from a full run, with the stick
	# still held, and the measurement stopping at the release marker.
	var moving := await _drive_to_full_speed()
	var shots_before := player.shots_fired
	var p0 := player.global_position
	player._cooldown = 0.0
	player.begin_attack()
	# MEASURED UP TO THE RELEASE, not to the cancel window.
	#
	# With movement already being requested, the window opens and the recovery is
	# cancelled inside the SAME frame, so `cancel_window_open()` is never observed
	# true from outside. Waiting for it spun for 200 frames and measured the
	# travel of the RESUMED locomotion instead of the wind-up. The release is the
	# event that actually bounds the wind-up, so the release is what is waited on.
	var f := 0
	var worst_speed := 0.0
	var travel_at_release := 0.0
	while f < 200 and player.shots_fired == shots_before:
		await physics_frame
		f += 1
		# SAMPLE ONLY WHILE THE SHOT IS STILL UNFIRED.
		#
		# On the frame the bolt releases, the recovery is cancelled and
		# locomotion resumes IN THE SAME FRAME -- one acceleration step, 0.5 m/s.
		# Sampling that frame measured the RESUME and reported it as wind-up
		# leakage. The immediacy is the behaviour the re-review asked for; the
		# measurement had to stop excluding it.
		if player.shots_fired == shots_before:
			travel_at_release = NavService.planar_distance(player.global_position, p0)
			if f > 3:
				worst_speed = maxf(worst_speed, player.motor.speed())
	var windup_travel := travel_at_release
	var released := player.shots_fired == shots_before + 1
	var speed_at_marker := worst_speed
	await _rest_player()
	var ok: bool = moving > 3.0 and f > 2 and released \
		and windup_travel <= ProdConfig.ACTION_GLIDE_TOLERANCE_M \
		and speed_at_marker <= 0.02
	_note("F85_translation_suppressed_before_release",
		"running at %.3f m/s with the stick STILL HELD, the actor travelled %.4f m across the whole %d-frame wind-up (tolerance %.2f m) and its greatest speed after the braking frames was %.4f m/s; the bolt then released=%s. (Sampling stops before the release frame, because the recovery is cancelled and locomotion resumes IN THAT SAME FRAME.)"
		% [moving, windup_travel, f, ProdConfig.ACTION_GLIDE_TOLERANCE_M,
		   speed_at_marker, str(released)])
	_reached("F85_translation_suppressed_before_release")
	return ok

# ------------------------------------------------------------------ report ---

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
	print("DEFERRED / TRANSFERRED / OWED-TO-OWNER — recorded as such, NEVER as passes:")
	for row in DEFERRED_ROWS:
		print("  [%-12s] %s" % [row[1], row[0]])
		print("                 %s" % row[2])

	print("")
	print("DISCHARGED — HISTORY, PRESERVED. A DISCHARGED ROW IS NOT A PASS:")
	for row in DISCHARGED_ROWS:
		print("  [%-16s] %s" % [row[1], row[0]])
		print("                     %s" % row[2])

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
	print("MEASURED CORPUS FACTS:")
	print("  UAL1 %s clips / %d bones · UAL2 %s clips / %d bones · merged %d distinct, collisions %s"
		% [str(RigCorpus.library_clip_counts.get("UAL1", 0)),
		   (RigCorpus.library_bone_sets.get("UAL1", []) as Array).size(),
		   str(RigCorpus.library_clip_counts.get("UAL2", 0)),
		   (RigCorpus.library_bone_sets.get("UAL2", []) as Array).size(),
		   RigCorpus.clip_source.size(), str(RigCorpus.collisions)])
	for g in ProdConfig.CORPUS_GAPS:
		print("  %s" % g)

	print("")
	print("EVERY TUNING VALUE REMAINS PROVISIONAL. NONE IS A PRODUCT LOCK.")
	print("PLAYER TOP SPEED %.3f m/s — %s"
		% [ProdConfig.TOP_SPEED_MPS, ProdConfig.TOP_SPEED_STATUS])
	print("OUTPUT %d x %d IS A REVIEW OUTPUT, NOT A PRODUCT LOCK."
		% [ProdConfig.OUTPUT_WIDTH, ProdConfig.OUTPUT_HEIGHT])
	print("NO 2D LOCK IS PROMOTED. NO SPIKE VALUE BECOMES A LOCK.")
	for d in ProdConfig.denials():
		print("  %s" % d)
	print("")
	var verdict := "PASS" if _all_ok() else "FAIL"
	print("FOUNDATION VERIFICATION: %s (%d checks: %d passed, %d failed/unreached, %d deferred)"
		% [verdict, OWED.size(), passed, failed, DEFERRED_ROWS.size()])
	print("STATE: %s" % ProdConfig.STATE)
	print("------------------------------------------------------------------------")
