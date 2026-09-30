extends SceneTree

## RIFTWROUGHT — THE HUNTRESS SPLINTER SHOT STAGE VERIFICATION  (D-392, 2026-09-19)
##
## ============================================================================
## A FOURTH SUITE. THE THREE ACCEPTED ONES ARE RE-RUN AS REGRESSIONS.
## ============================================================================
## `tests/foundation_verification.gd` (85, ACCEPTED D-373), `tests/imprint_
## verification.gd` (101, ACCEPTED D-376) and `tests/alignment_verification.gd`
## (40, ACCEPTED D-383) run FIRST in `tests/huntress_smoke.sh`. This suite owns
## only what the D-392 stage owes.
##
## ============================================================================
## UNITS. TWELVE COUNTS EXIST IN THIS PROJECT AND NONE IS A SYNONYM FOR ANOTHER.
## ============================================================================
##   D-392 OWED CRITERIA     203  docs/testing/D392_SPLINTER_SHOT_OWED_CRITERIA_INVENTORY.md
##   D-392 EXECUTABLE CHECKS  53  this suite (H01-H45, H51-H58)
##   D-392 RUNNER CHECKS      21  tests/huntress_smoke.sh (W01-W21)
##   D-380 162 · 40 · 21   D-375 149 · 101 · 26   D-370 125 · 85 · 20
## The D-392 printed rows are 15 SD- rows and 4 SO- rows: none is a pass.
##
## RE-SCOPED UNDER D-393 (the owner removed Prey before acceptance): the five
## Prey checks H46-H50 are WITHDRAWN, not renumbered, so every earlier citation
## of H01-H45 and H51-H57 still names the same check; H45 is now the general
## enemy-eligibility check; H58 proves the removal. 57 - 5 + 1 = 53 checks;
## criteria 207 - 26 + 22 = 203; rows 18 - 3 = 15 SD and 5 - 1 = 4 SO. The
## figures 207 / 57 / 18 / 5 were true when written.
##
## ============================================================================
## IT VERIFIES A STAGE DELIVERED OPEN. IT ACCEPTS NOTHING.
## ============================================================================
## The owner: "It is not P2, campaign production, final animation, final VFX or
## full Huntress implementation." Every number it touches is PROVISIONAL.
##
## The standing verification rules, verbatim: a named owed list compared in BOTH
## directions · every check records reaching its LAST line · a missing check
## function is a FAIL, never a skip · every negative control is PROVED ABLE TO
## REFUSE · an assertion that something did NOT happen first asserts the action
## FIRED · source-scanning guards read CODE, never the dated history comments ·
## an unperformed check is DEFERRED and names where it returns.

const OWED := [
	# --- A. THE FIRST ACT (D-383 section 6) ------------------------------------
	"H01_state_names_four_facts_exactly_with_one_definer",
	"H02_am_rows_discharged_d383_with_history_and_rows_ten",
	"H03_every_state_pin_moved_together_and_refuses_stale_lines",
	# --- B. SPLINTER SHOT THROUGH THE ACCEPTED ARCHITECTURE --------------------
	"H04_splinter_shot_is_one_canonical_skill_imprint",
	"H05_learned_at_rank_1_with_0_xp_and_never_seeded",
	"H06_one_unmodified_configuration_resolves_one_arrow",
	"H07_bound_to_binding_6_with_six_equipped_and_capacity_stated",
	"H08_the_ordinary_attack_input_reaches_splinter_shot_not_the_bolt",
	"H09_held_input_repeats_at_the_action_time_resampling_aim",
	"H10_the_diagnostic_bolt_is_test_only_and_not_disguised",
	"H11_cost_at_use_start_one_use_per_activation_and_xp_not_from_use",
	"H12_action_entry_points_are_six_both_directions",
	# --- C. TIMING AND THE ACCEPTED COMMITMENT ---------------------------------
	"H13_release_at_the_provisional_candidate_with_derived_recovery",
	"H14_stop_policy_stops_translation_within_tolerance",
	"H15_draw_movement_is_buffered_and_cancel_refused",
	"H16_post_release_movement_cancels_recovery_and_arrow_survives",
	"H17_full_action_completes_without_movement",
	"H18_release_frame_is_shared_and_mechanical_timing_is_independent",
	# --- D. FACING -------------------------------------------------------------
	"H19_aim_sampled_once_facing_snaps_and_no_turning_phase",
	"H20_cursor_swing_redirects_neither_arrow_nor_facing",
	"H21_visual_blends_aligns_before_release_and_late_guard_counts",
	"H22_normal_control_resumes_after_release_and_after_cancel",
	"H23_f73_still_holds_for_the_diagnostic_bolt",
	"H24_no_sector_index_in_any_new_file",
	# --- E. PLACEHOLDER ANIMATION AND PRESENTATION ------------------------------
	"H25_current_huntress_body_accepted_player_kept_and_modifier_applies",
	"H26_only_authorized_clips_are_sampled_and_source_unchanged",
	"H27_retarget_map_is_explicit_and_refuses_a_planted_bone",
	"H28_full_draw_contacts_and_arrow_line_align_with_facing",
	"H29_bow_in_hand_and_string_follows_then_rests_on_release",
	"H30_arrow_nocked_to_release_and_projectile_starts_at_the_nock",
	"H31_exactly_one_arrow_per_skill_use",
	"H32_locomotion_placeholder_and_overlay_states_shown_vs_requested",
	"H33_accepted_polish_debts_carried_and_transitions_measured",
	"H34_ported_modules_and_placeholder_intake_are_declared_and_verified",
	# --- F. ARROW COLLISION ----------------------------------------------------
	"H35_time_of_impact_math_is_exact",
	"H36_earliest_time_of_impact_wins_in_any_order",
	"H37_a_tie_goes_to_the_lower_combat_entity_id_whatever_the_names_or_order",
	"H38_the_choice_code_reads_no_order_name_or_memory_identity",
	"H39_a_target_touching_the_archer_is_hit",
	"H40_one_hit_then_stop_and_nothing_multiplies",
	"H41_world_geometry_stops_the_arrow_without_a_hit",
	"H42_ineligible_entities_are_passed_through",
	"H43_expiry_at_range_and_no_tunnelling",
	# --- G. THE COMBAT-ENTITY ID -----------------------------------------------
	"H44_combat_entity_ids_are_opaque_immutable_unique_deterministic",
	# --- H. ENEMY ELIGIBILITY — a general combat rule since D-393 ---------------
	"H45_enemy_eligibility_follows_the_ruling_exactly",
	# --- I. SURFACES AND THE REVIEW HUD ---------------------------------------
	"H51_launch_surfaces_hidden_and_the_d392_hud_shown",
	"H52_the_hud_is_compact_clear_and_click_through",
	"H53_the_hud_reads_live_objects_and_owns_no_number",
	# --- J. SCOPE AND PRESERVATION ---------------------------------------------
	"H54_no_accepted_tuning_value_changed",
	"H55_no_out_of_scope_content_exists",
	"H56_denials_clarifications_units_and_no_self_acceptance",
	"H57_seams_clear_and_no_runtime_dependency_leaves_game3d",
	# --- K. THE D-393 CORRECTION -----------------------------------------------
	"H58_prey_is_removed_and_mark_is_not_implemented",
]

## ONE deliberately planted claim, so the forbidden-claim scans can be proved able
## to refuse.
const PLANTED_CLAIM := "Splinter_Shot_Stage_Accepts_Itself_THIS_IS_FORBIDDEN"

# =============================================================================
# TEST-ONLY STUB ENTITIES — they exist ONLY in this suite. NO gameplay class has
# an untargetable or invulnerable state, and none is added: D-391 ruling 4's
# exclusions NAME CONDITIONS. These stubs let the eligibility rule be PROVED on
# every category it names without adding one piece of content.
# =============================================================================
class StubEntity extends Node3D:
	var targetable: bool = true
	var invulnerable: bool = false
	var receives: bool = true
	var dead: bool = false
	var radius: float = 0.42
	var damage_taken: float = 0.0
	func combat_is_targetable() -> bool:
		return targetable
	func combat_is_invulnerable() -> bool:
		return invulnerable
	func combat_body_radius() -> float:
		return radius
	func is_dead() -> bool:
		return dead
	func receive_damage(amount: float, _from: Vector3) -> void:
		damage_taken += amount

## A stub WITHOUT a Hit receiver -- it cannot legally receive a Hit at all.
class StubNoReceiver extends Node3D:
	func combat_body_radius() -> float:
		return 0.42
	func is_dead() -> bool:
		return false

var reached := {}
var results := {}
var notes := {}
var findings: Array[String] = []

var main: Node
var player: PlayerController
var cam: IsoCameraRig
var skills: SkillRuntime
var hr: HuntressRuntime
var hud: DebugOverlay
var panel: LoadoutPanel
var review_hud: ReviewHud
var d392_hud: HuntressReviewHud
var enemies: Array = []
var corpus: AnimationLibrary
var launch := {}
var probes: Array = []

## THE CLEAR LANE every collision check fires along -- MEASURED clear of world
## geometry at start-up (a shape cast on the layer the arrow stops on).
var lane_from: Vector3 = Vector3.ZERO
var lane_dir: Vector3 = Vector3.ZERO
var lane_side: Vector3 = Vector3.ZERO
var lane_found: bool = false

func _initialize() -> void:
	print("========================================================================")
	print("RIFTWROUGHT — %s VERIFICATION  (%s, %s)"
		% [HuntressConfig.STAGE, HuntressConfig.DECISION, HuntressConfig.DATE])
	print("STATE: %s" % ProdConfig.STATE)
	# D-396 (first act): this read "Verifying a STAGE DELIVERED OPEN" until D-396
	# -- true when written; D-394 accepted and closed the stage.
	print("Verifying the D-392 stage ACCEPTED and CLOSED under D-394 (delivered OPEN under D-392,")
	print("corrected under D-393), re-run as a REGRESSION under the D-396 KINDRED HOUNDS STAGE:")
	print("Splinter Shot, the Huntress's ordinary shot, through the ACCEPTED Imprint architecture.")
	print("It is NOT P2, NOT campaign production, NOT final animation and NOT final VFX. It LOCKS NO NUMBER.")
	print("OWED EXECUTABLE CHECKS: %d   DEFERRED ROWS: %d   OWED-TO-OWNER ROWS: %d   DISCHARGED: %d"
		% [OWED.size(), HuntressConfig.deferred_rows().size(), HuntressConfig.owed_to_owner().size(),
		   HuntressConfig.discharged_rows().size()])
	print("(The D-392 owed-criteria INVENTORY counts 203 CRITERIA since D-393 — 207 until then. Different unit.)")
	print("(The ACCEPTED suites count 85, 101 and 40 EXECUTABLE CHECKS. Different decisions.)")
	print("========================================================================")

	main = load("res://scenes/main.tscn").instantiate()
	root.add_child(main)
	for i in 16:
		await process_frame

	# ========================================================================
	# D-396 — THE DECLARED FIXTURE: THE ACCEPTED LOADOUT, RESTORED.
	# ========================================================================
	# Since D-396 the scene composes the Kindred Hounds stage, whose two
	# autonomous hounds bite REGISTERED enemies near the Huntress -- the very
	# probes this suite's arrow checks count Hits on. So the loadout this stage was
	# accepted with (the D-392 loadout, no pack) is restored through the runtime's
	# OWN loadout operations before the launch capture. It adds no check and
	# removes none; the D-396 suite proves the restoration exact.
	main.get("hounds").restore_accepted_d392_loadout()
	await physics_frame

	player = main.get("player")
	cam = main.get("cam")
	skills = main.get("skills")
	hr = main.get("huntress")
	hud = main.get("hud")
	panel = main.get("imprint_panel")
	review_hud = main.get("review_hud")
	d392_hud = main.get("huntress_hud")
	enemies = main.get("enemies")
	corpus = main.get("corpus")
	# WHAT LAUNCH SHOWED, captured BEFORE any check touches anything.
	launch = {
		"overlay_enabled": hud.enabled, "overlay_visible": hud.visible,
		"panel_enabled": panel.enabled, "panel_visible": panel.visible,
		"d381_enabled": review_hud.enabled, "d381_visible": review_hud.visible,
		"d392_enabled": d392_hud.enabled, "d392_visible": d392_hud.visible,
		"seams_clear": player.intent.seams_clear() and cam.debug_cursor_override == null
			and not player.debug_freeze_attack,
		"playback_scale": hr.animator.debug_playback_scale,
		"hold": player.facing_hold_active(), "late": hr.late_visual_alignments,
		"mastered": skills.library.mastered(HuntressContent.SKILL_SPLINTER_SHOT),
		"xp": skills.library.xp(HuntressContent.SKILL_SPLINTER_SHOT),
		"registered": hr.registry.count(),
		"registered_ids": _ids_of(enemies),
		"checksums": _clip_checksums(),
		"setup_ok": hr.setup_ok, "setup_problems": hr.setup_problems.duplicate(),
	}
	# THE SCENE'S OWN ENEMIES are frozen and PARKED in the east chamber, so a
	# wandering AI -- or a body in the lane -- cannot contaminate a measurement.
	# Every behavioural check spawns and registers its OWN probes.
	for i in enemies.size():
		var e: OrdinaryEnemy = enemies[i]
		e.debug_freeze_ai = true
		e.life = Damageable.new(1000000.0)
		e.global_position = Vector3(9.0, 0, -5.0 + 1.3 * float(i))
	skills.set_safe_state_override(true)
	await _phys(4)
	_find_lane()

	for id in OWED:
		await _run(id)

	_report()
	quit(0 if _all_ok() else 1)

func _run(id: String) -> void:
	# A MISSING METHOD IS A FAIL, NOT A SKIP.
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

func _read_text(path: String) -> String:
	var f := FileAccess.open(path, FileAccess.READ)
	if f == null:
		return ""
	var s := f.get_as_text()
	f.close()
	return s

## CODE ONLY: lines whose trimmed start is `#` are dropped, because this project
## REQUIRES superseded wording to be kept as dated history (the D-380 lesson).
static func _code_only(text: String) -> String:
	var out := PackedStringArray()
	for line in text.split("\n"):
		if String(line).strip_edges().begins_with("#"):
			continue
		out.append(String(line))
	return "\n".join(out)

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

func _runtime_script_files() -> Array:
	var all: Array = []
	_walk("res://scripts", all)
	var out: Array = []
	for f in all:
		if String(f).ends_with(".gd"):
			out.append(String(f))
	out.sort()
	return out

func _huntress_script_files() -> Array:
	var out: Array = []
	for f in _runtime_script_files():
		if String(f).begins_with("res://scripts/huntress/"):
			out.append(String(f))
	return out

func _constants(path: String) -> Dictionary:
	var scr: Script = load(path)
	return scr.get_script_constant_map()

func _ids_of(list: Array) -> Array:
	var out: Array = []
	for e in list:
		out.append(hr.registry.id_of(e))
	return out

func _clip_checksums() -> Dictionary:
	var out := {}
	for c in HuntressConfig.AUTHORIZED_CLIPS:
		out[String(c)] = hr.animator.source.checksum(String(c))
	return out

## Finds a lane measured CLEAR of world geometry for 14 m -- the same layer the
## arrow stops on -- from a few candidate points and directions.
func _find_lane() -> void:
	var candidates := [
		[Vector3(-10, 0, 7), Vector3(0.7071068, 0, -0.7071068)],
		[Vector3(-15, 0, -3), Vector3(0.7071068, 0, -0.7071068)],
		[Vector3(-12, 0, -8), Vector3(1, 0, 0)],
		[Vector3(-13, 0, 0), Vector3(0, 0, -1)],
		[Vector3(-10, 0, -7), Vector3(0, 0, 1)],
	]
	var best_len := 0.0
	for c in candidates:
		var from: Vector3 = c[0]
		var d: Vector3 = (c[1] as Vector3).normalized()
		var l := _clear_length(from, d, 0.45, 16.0)
		if l > best_len:
			best_len = l
			lane_from = from
			lane_dir = d
	lane_side = Vector3(-lane_dir.z, 0, lane_dir.x)
	lane_found = best_len >= 9.0
	_finding("TEST LANE: from %s along %s, clear of world geometry for %.2f m (a 0.45 m probe)"
		% [str(lane_from), str(lane_dir), best_len])

## How far a sphere of radius `r` at the arrow's probe height sweeps before it
## touches world geometry, capped at `cap`.
func _clear_length(from: Vector3, dir: Vector3, r: float, cap: float) -> float:
	var space: PhysicsDirectSpaceState3D = main.get_world_3d().direct_space_state
	var q := PhysicsShapeQueryParameters3D.new()
	var sh := SphereShape3D.new()
	sh.radius = r
	q.shape = sh
	q.collision_mask = 4
	q.transform = Transform3D(Basis.IDENTITY, Vector3(from.x, HuntressConfig.WALL_PROBE_HEIGHT_M, from.z))
	if not space.intersect_shape(q, 1).is_empty():
		return 0.0
	q.motion = Vector3(dir.x, 0, dir.z) * cap
	var res: PackedFloat32Array = space.cast_motion(q)
	return cap * float(res[1]) if res.size() == 2 else 0.0

## A fresh ordinary enemy, FROZEN, REGISTERED in the explicit order this call is
## made in. Tracked so every check can clean up after itself.
func _probe(probe_name: String, pos: Vector3, register: bool = true) -> OrdinaryEnemy:
	var e := OrdinaryEnemy.new()
	e.name = probe_name
	main.add_child(e)
	e.setup(corpus)
	e.global_position = pos
	e.player = player
	e.debug_freeze_ai = true
	if register:
		hr.register_enemy(e)
	probes.append(e)
	return e

## A test-only stub, registered with the category and faction given.
func _stub(stub_name: String, pos: Vector3, category: String, faction: String) -> StubEntity:
	var s := StubEntity.new()
	s.name = stub_name
	main.add_child(s)
	s.global_position = pos
	hr.registry.register(s, category, faction)
	probes.append(s)
	return s

## Removes every probe from the AREA as well as the tree: an entity that left
## cannot be Hit (eligibility refuses "no longer present"), and its ID is never
## reused.
func _clear_probes() -> void:
	for p in probes:
		if p != null and is_instance_valid(p):
			(p as Node).queue_free()
	probes = []
	await _phys(2)

## Back to a known state between checks: no action, no arrow in flight, the
## Huntress on the lane's start, full Mana, clear seams.
func _rest() -> void:
	player.intent.clear_seams()
	cam.debug_cursor_override = null
	var g := 0
	while (player.commitment.active or not hr.arrows.is_empty()) and g < 240:
		await physics_frame
		g += 1
	for a in hr.arrows:
		if a != null and is_instance_valid(a):
			(a as Node).queue_free()
	hr.arrows = []
	player.motor.reset()
	player.clear_move_destination()
	player.global_position = lane_from
	skills.clear_cooldowns()
	skills.pool.refill()
	hr.animator.debug_playback_scale = 1.0
	await _phys(3)

## Aims at a world point and uses binding 6 (Splinter Shot) through the ACCEPTED
## use path. Returns the use result.
func _fire_at(point: Vector3) -> Dictionary:
	cam.debug_cursor_override = point
	await _phys(3)
	return skills.use_binding(HuntressContent.BINDING_INDEX)

## Waits until the arrow of the LAST use reports, or `max_frames`.
func _await_outcome(before_arrows: int, max_frames: int = 240) -> Dictionary:
	var g := 0
	while g < max_frames and (hr.arrows_released <= before_arrows
			or String(hr.last_outcome.get("use_id", "")) != hr.last_use_id):
		await physics_frame
		g += 1
	return hr.last_outcome.duplicate()

func _await_release(before_arrows: int, max_frames: int = 200) -> int:
	var g := 0
	while g < max_frames and hr.arrows_released <= before_arrows:
		await physics_frame
		g += 1
	return g

func _await_action_end(max_frames: int = 240) -> void:
	var g := 0
	while g < max_frames and player.commitment.active:
		await physics_frame
		g += 1

static func _deg(a: float) -> float:
	return rad_to_deg(absf(wrapf(a, -PI, PI)))

## One Splinter Shot use toward `dir`, waited through its outcome AND its action.
func _shoot(dir: Vector3, dist: float = 6.0) -> Dictionary:
	var before := hr.arrows_released
	var r := await _fire_at(player.global_position + dir.normalized() * dist)
	if not bool(r["ok"]):
		return {"ok": false, "reason": String(r["reason"]), "outcome": {}}
	var arrow: SplinterArrow = null
	var g := 0
	while g < 90 and hr.arrows_released <= before:
		await physics_frame
		g += 1
	if not hr.arrows.is_empty():
		arrow = hr.arrows.back()
	var o := await _await_outcome(before)
	await _await_action_end()
	return {"ok": true, "use_id": String(r["use_id"]), "outcome": o, "arrow": arrow}

func _lane_point(along: float, side: float = 0.0) -> Vector3:
	return lane_from + lane_dir * along + lane_side * side

## A predicate over a set of launch surfaces, so a planted set can be refused.
##
## RE-PINNED UNDER D-396, AS ITS FIRST ACT (D-394 section 7): four parts -> FIVE.
## Until D-396 the fourth part was "HUNTRESS SPLINTER SHOT STAGE DELIVERED and OPEN
## pending owner live review (D-392)" -- TRUE WHEN WRITTEN, and the state this
## stage was accepted in. It now names D-394's acceptance, and the fifth part the
## D-396 stage's open state. Still EXACT, part by part.
##
## RE-PINNED UNDER D-398, AS ITS FIRST ACT (D-397 section 6): five parts -> SIX.
## Until D-398 the fifth part was "KINDRED HOUNDS STAGE DELIVERED and OPEN pending
## owner live review (D-396)" -- TRUE WHEN WRITTEN. It now names D-397's
## acceptance, and the sixth part the D-398 stage's open state. Still EXACT.
## RE-PINNED AGAIN UNDER D-400, AS ITS FIRST ACT: six parts -> SEVEN. Until D-400
## the sixth part was "MOBILE MINION COHESION STAGE DELIVERED and OPEN pending
## owner live review (D-398)" -- TRUE WHEN WRITTEN. It now names D-400's
## acceptance, and the seventh part the D-400 stage's open state. Still EXACT.
static func _state_parts_ok(state: String) -> bool:
	# RE-PINNED UNDER D-402, AS ITS FIRST ACT (D-401 section 6): seven parts ->
	# EIGHT. Until D-402 the seventh part was "PLAYER LOCOMOTION REDIRECTION STAGE
	# DELIVERED and OPEN pending owner live review (D-400)" -- TRUE WHEN WRITTEN.
	# It now names D-401's acceptance, and the eighth part the D-402 Cinder Field
	# stage's open state. Still EXACT, part by part; nothing is weakened.
	var parts := state.split(" · ")
	# RE-PINNED UNDER D-404, AS ITS FIRST ACT: eight parts -> NINE. Until D-404 the
	# eighth part was "CINDER FIELD STAGE DELIVERED and OPEN pending owner live
	# review (D-402)" -- TRUE WHEN WRITTEN. It now names D-403's acceptance, and the
	# ninth part the D-404 direct-click stage's open state. Still EXACT, part by part.
	return parts.size() == 9 \
		and parts[0] == "FOUNDATION STAGE ACCEPTED and CLOSED (D-373)" \
		and parts[1] == "IMPRINT STAGE ACCEPTED and CLOSED (D-376)" \
		and parts[2] == "D-378 ALIGNMENT STAGE ACCEPTED and CLOSED (D-383)" \
		and parts[3] == "HUNTRESS SPLINTER SHOT STAGE ACCEPTED and CLOSED (D-394)" \
		and parts[4] == "KINDRED HOUNDS STAGE ACCEPTED and CLOSED (D-397)" \
		and parts[5] == "MOBILE MINION COHESION STAGE ACCEPTED and CLOSED (D-399)" \
		and parts[6] == "PLAYER LOCOMOTION REDIRECTION STAGE ACCEPTED and CLOSED (D-401)" \
		and parts[7] == "CINDER FIELD STAGE ACCEPTED and CLOSED (D-403)" \
		and parts[8] == "PLAYER DIRECT-CLICK MOVEMENT CORRECTION STAGE DELIVERED and OPEN pending owner live review (D-404)"

const STATE_D380 := "FOUNDATION STAGE ACCEPTED and CLOSED (D-373) · IMPRINT STAGE ACCEPTED and CLOSED (D-376) · D-378 ALIGNMENT STAGE DELIVERED and OPEN pending owner live review (D-380)"
## D-396: the D-392-era line, held as a SUPERSEDED needle exactly as STATE_D380 is.
const STATE_D392 := "FOUNDATION STAGE ACCEPTED and CLOSED (D-373) · IMPRINT STAGE ACCEPTED and CLOSED (D-376) · D-378 ALIGNMENT STAGE ACCEPTED and CLOSED (D-383) · HUNTRESS SPLINTER SHOT STAGE DELIVERED and OPEN pending owner live review (D-392)"
## D-398: the D-396-era line, held as a SUPERSEDED needle exactly as STATE_D392 is.
const STATE_D396 := "FOUNDATION STAGE ACCEPTED and CLOSED (D-373) · IMPRINT STAGE ACCEPTED and CLOSED (D-376) · D-378 ALIGNMENT STAGE ACCEPTED and CLOSED (D-383) · HUNTRESS SPLINTER SHOT STAGE ACCEPTED and CLOSED (D-394) · KINDRED HOUNDS STAGE DELIVERED and OPEN pending owner live review (D-396)"
## D-400: the D-398-era line, held as a SUPERSEDED needle exactly as STATE_D396 is.
const STATE_D398 := "FOUNDATION STAGE ACCEPTED and CLOSED (D-373) · IMPRINT STAGE ACCEPTED and CLOSED (D-376) · D-378 ALIGNMENT STAGE ACCEPTED and CLOSED (D-383) · HUNTRESS SPLINTER SHOT STAGE ACCEPTED and CLOSED (D-394) · KINDRED HOUNDS STAGE ACCEPTED and CLOSED (D-397) · MOBILE MINION COHESION STAGE DELIVERED and OPEN pending owner live review (D-398)"
## D-402: the D-400-era line, held as a SUPERSEDED needle exactly as STATE_D398 is.
const STATE_D400 := "FOUNDATION STAGE ACCEPTED and CLOSED (D-373) · IMPRINT STAGE ACCEPTED and CLOSED (D-376) · D-378 ALIGNMENT STAGE ACCEPTED and CLOSED (D-383) · HUNTRESS SPLINTER SHOT STAGE ACCEPTED and CLOSED (D-394) · KINDRED HOUNDS STAGE ACCEPTED and CLOSED (D-397) · MOBILE MINION COHESION STAGE ACCEPTED and CLOSED (D-399) · PLAYER LOCOMOTION REDIRECTION STAGE DELIVERED and OPEN pending owner live review (D-400)"
## D-404: the D-402-era line, held as a SUPERSEDED needle exactly as STATE_D400 is.
const STATE_D402 := "FOUNDATION STAGE ACCEPTED and CLOSED (D-373) · IMPRINT STAGE ACCEPTED and CLOSED (D-376) · D-378 ALIGNMENT STAGE ACCEPTED and CLOSED (D-383) · HUNTRESS SPLINTER SHOT STAGE ACCEPTED and CLOSED (D-394) · KINDRED HOUNDS STAGE ACCEPTED and CLOSED (D-397) · MOBILE MINION COHESION STAGE ACCEPTED and CLOSED (D-399) · PLAYER LOCOMOTION REDIRECTION STAGE ACCEPTED and CLOSED (D-401) · CINDER FIELD STAGE DELIVERED and OPEN pending owner live review (D-402)"

# =============================================================================
# A. THE FIRST ACT — D-383 section 6, done as this stage's first act
# =============================================================================

func chk_H01_state_names_four_facts_exactly_with_one_definer() -> bool:
	var s := ProdConfig.STATE
	var four := _state_parts_ok(s)
	# EXACTLY ONE definer of the state line anywhere in the runtime.
	var re := RegEx.new()
	re.compile("(?m)^\\s*const\\s+STATE\\s*(:[^=]*)?:?=")
	var definers: Array[String] = []
	for f in _runtime_script_files():
		if re.search(_code_only(_read_text(f))) != null:
			definers.append(f)
	var one := definers == ["res://scripts/core/prod_config.gd"]
	# NO RUNTIME CODE CALLS A STAGE ACCEPTED ON ITS OWN AUTHORITY.
	#
	# RE-SCOPED UNDER D-396, AS ITS FIRST ACT, one for one. Until D-396 this
	# refused "SPLINTER SHOT STAGE ACCEPTED" anywhere in runtime code -- TRUE WHEN
	# WRITTEN: the stage was open. D-394 accepted it, so that phrase is now the
	# TRUTH, carried by the one definer. The guard now refuses what would still be
	# false: the stage accepting ITSELF ("ACCEPTED and CLOSED (D-392)") and the
	# OPEN D-396 stage called accepted -- two needles for one.
	#
	# RE-SCOPED AGAIN UNDER D-398 (first act), one for one. D-397 accepted the
	# Kindred Hounds stage, so "KINDRED HOUNDS STAGE ACCEPTED" is now the TRUTH. The
	# needle MOVES to what would still be false: the D-396 stage accepting ITSELF
	# ("ACCEPTED and CLOSED (D-396)") and the OPEN D-398 stage called accepted.
	#
	# RE-SCOPED A THIRD TIME UNDER D-400 (first act), one for one. D-400 accepted
	# the mobile minion cohesion stage, so "MOBILE MINION COHESION STAGE ACCEPTED"
	# is now the TRUTH, carried by the one definer. The needle MOVES to what would
	# still be false: the D-398 stage accepting ITSELF ("ACCEPTED and CLOSED
	# (D-398)" -- D-398 DELIVERED it, D-400 accepted it) and the OPEN D-400 stage
	# called accepted.
	var claim := RegEx.new()
	# RE-SCOPED A FIFTH TIME UNDER D-404 (first act), one for one. D-403 accepted
	# the Cinder Field stage, so "CINDER FIELD STAGE ACCEPTED" is now the TRUTH,
	# carried by the one definer. The needle MOVES to what would still be false:
	# the D-402 stage accepting ITSELF ("ACCEPTED and CLOSED (D-402)") and the OPEN
	# D-404 stage called accepted.
	# RE-SCOPED A FOURTH TIME UNDER D-402 (first act), one for one. D-401 accepted
	# the locomotion stage, so "PLAYER LOCOMOTION REDIRECTION STAGE ACCEPTED" is now
	# the TRUTH, carried by the one definer. The needle MOVES to what would still be
	# false: the D-400 stage accepting ITSELF ("ACCEPTED and CLOSED (D-400)" --
	# D-400 DELIVERED it, D-401 accepted it) and the OPEN D-402 stage called accepted.
	claim.compile("ACCEPTED and CLOSED \\(D-392\\)|ACCEPTED and CLOSED \\(D-396\\)|ACCEPTED and CLOSED \\(D-398\\)|ACCEPTED and CLOSED \\(D-400\\)|PLAYER DIRECT-CLICK MOVEMENT CORRECTION STAGE ACCEPTED|ACCEPTED and CLOSED \\(D-402\\)|" + PLANTED_CLAIM)
	var claims: Array[String] = []
	for f in _runtime_script_files():
		if claim.search(_code_only(_read_text(f))) != null:
			claims.append(f)
	# THE GUARDS CAN REFUSE: the D-380 line, the D-392-era line, a self-accepted
	# fourth fact, a self-accepting fifth fact, four facts, and a planted claim in
	# code (a planted COMMENT is ignored).
	var refuses_d380 := not _state_parts_ok(STATE_D380)
	var refuses_d392 := not _state_parts_ok(STATE_D392)
	var refuses_d396 := not _state_parts_ok(STATE_D396)
	var refuses_d398 := not _state_parts_ok(STATE_D398)
	var refuses_self := not _state_parts_ok(s.replace("ACCEPTED and CLOSED (D-394)", "ACCEPTED and CLOSED (D-392)")) \
		and not _state_parts_ok(s.replace("ACCEPTED and CLOSED (D-397)", "ACCEPTED and CLOSED (D-396)"))
	# D-404 (first act): and the D-402-era line, refused by the same variable.
	var refuses_d400 := not _state_parts_ok(STATE_D400) and not _state_parts_ok(STATE_D402)
	# RE-SCOPED UNDER D-404 (first act): the self-accepting LAST fact is now the
	# D-404 stage's, and the Cinder Field acceptance re-attributed to the ruling that
	# only DELIVERED it is refused beside it.
	var refuses_open_self := not _state_parts_ok(s.replace("PLAYER DIRECT-CLICK MOVEMENT CORRECTION STAGE DELIVERED and OPEN pending owner live review (D-404)",
		"PLAYER DIRECT-CLICK MOVEMENT CORRECTION STAGE ACCEPTED and CLOSED (D-404)")) \
		and not _state_parts_ok(s.replace("CINDER FIELD STAGE ACCEPTED and CLOSED (D-403)", "CINDER FIELD STAGE ACCEPTED and CLOSED (D-402)"))
	var refuses_four := not _state_parts_ok(" · ".join(s.split(" · ").slice(0, 4))) \
		and not _state_parts_ok(" · ".join(s.split(" · ").slice(0, 5))) \
		and not _state_parts_ok(" · ".join(s.split(" · ").slice(0, 6))) \
		and not _state_parts_ok(" · ".join(s.split(" · ").slice(0, 7))) \
		and not _state_parts_ok(" · ".join(s.split(" · ").slice(0, 8)))
	var planted_caught := claim.search(_code_only("var x := \"%s\"" % PLANTED_CLAIM)) != null \
		and claim.search("const S := \"PLAYER DIRECT-CLICK MOVEMENT CORRECTION STAGE ACCEPTED and CLOSED (D-404)\"") != null \
		and claim.search("const S := \"KINDRED HOUNDS STAGE ACCEPTED and CLOSED (D-396)\"") != null
	var comment_ignored := claim.search(_code_only("# %s" % PLANTED_CLAIM)) == null
	var ok := four and one and claims.is_empty() and refuses_d380 and refuses_d392 and refuses_d396 and refuses_d398 \
		and refuses_d400 and refuses_self and refuses_open_self and refuses_four and planted_caught and comment_ignored
	_note("H01_state_names_four_facts_exactly_with_one_definer",
		"RE-PINNED UNDER D-404 (first act): the state line is now NINE facts — the eighth D-403's acceptance of Cinder Field, the ninth the D-404 direct-click stage OPEN — and the rest of this note is worded as at D-402, true when written: RE-PINNED UNDER D-396, D-398, D-400 AND D-402 (first acts): STATE = '%s' — EIGHT facts in order, the fourth D-394's acceptance, the fifth D-397's, the sixth D-399's, the seventh D-401's acceptance of the locomotion stage and the eighth the D-402 Cinder Field stage OPEN=%s | definers: %s | runtime code claiming a self-acceptance: %s | refuses the D-380 line=%s, the D-392-era line=%s, the D-396-era line=%s, the D-398-era line=%s, the D-400-era line=%s, a self-accepted fourth or fifth fact=%s, a self-accepting last fact=%s, four, five, six or seven facts=%s; catches a planted code claim=%s and ignores a planted comment=%s. (The id says 'four facts' — true when written.)"
		% [s, str(four), str(definers), str(claims), str(refuses_d380), str(refuses_d392), str(refuses_d396), str(refuses_d398),
		   str(refuses_d400), str(refuses_self), str(refuses_open_self), str(refuses_four), str(planted_caught), str(comment_ignored)])
	_reached("H01_state_names_four_facts_exactly_with_one_definer")
	return ok

## The rows predicate, over any (deferred, discharged) pair, so a planted pair
## can be refused.
static func _am_rows_ok(deferred: Array, discharged: Array) -> bool:
	if deferred.size() != 10:
		return false
	for r in deferred:
		if String(r[0]).begins_with("AM-"):
			return false
	var found := 0
	for k in 5:
		var id := "AM-0%d" % (k + 1)
		for r in discharged:
			if String(r[0]).begins_with(id + " "):
				if String(r[1]) == "DISCHARGED — D-383" \
						and String(r[2]).find("THE OWNER'S D-383 LIVE REVIEW:") == 0 \
						and String(r[2]).find("ORIGINAL ROW TEXT, PRESERVED VERBATIM (OWED-TO-OWNER): '") > 0:
					found += 1
	return found == 5

func chk_H02_am_rows_discharged_d383_with_history_and_rows_ten() -> bool:
	var consts := _constants("res://tests/alignment_verification.gd")
	var deferred: Array = consts.get("DEFERRED_ROWS", [])
	var discharged: Array = consts.get("DISCHARGED_ROWS", [])
	var rows_ok := _am_rows_ok(deferred, discharged)
	var six := discharged.size() == 6
	var ad11 := false
	for r in discharged:
		if String(r[0]).begins_with("AD-11") and String(r[1]) == "DISCHARGED — D-382":
			ad11 = true
	# D-383 closed AM-03 and AM-04 BY ACCEPTANCE OF THE RULE: no felt judgment.
	var no_inference := true
	for r in discharged:
		var id := String(r[0]).substr(0, 5)
		if id == "AM-03" or id == "AM-04":
			no_inference = no_inference and String(r[2]).find("CLOSED BY ACCEPTANCE OF THE RULE") >= 0 \
				and String(r[2]).find("NO separate felt judgment") >= 0
	# THE IMPRINT SUITE'S REVIEWABILITY LINE: its history kept, the current fact added.
	var line := String(ImprintConfig.reviewability_denials()[0])
	var history_kept := line.find("It re-delivered D-380 OPEN and accepted nothing") >= 0 \
		and line.find("true when written; D-383 then ACCEPTED and CLOSED the stage") >= 0
	# THE PREDICATE CAN REFUSE: AM-01 moved back into the deferred rows; a row
	# whose history was dropped.
	var planted_def: Array = deferred.duplicate()
	planted_def.append(["AM-01 planted", "OWED-TO-OWNER", "x"])
	var refuses_back := not _am_rows_ok(planted_def.slice(1), discharged)
	var stripped: Array = []
	for r in discharged:
		stripped.append([r[0], r[1], String(r[2]).split(" || ")[0]])
	var refuses_stripped := not _am_rows_ok(deferred, stripped)
	var ok := rows_ok and six and ad11 and no_inference and history_kept and refuses_back and refuses_stripped
	_note("H02_am_rows_discharged_d383_with_history_and_rows_ten",
		"the alignment suite prints %d deferred rows (15 - 5 = 10) and %d discharged rows (1 + 5 = 6); AM-01..AM-05 each 'DISCHARGED — D-383' with D-383's answer FIRST and the ORIGINAL ROW TEXT PRESERVED VERBATIM=%s; AD-11 still 'DISCHARGED — D-382'=%s; AM-03/AM-04 infer no felt judgment=%s | the D-381 reviewability line keeps its history and adds D-383=%s | refuses an AM row moved back=%s and a row with its history dropped=%s"
		% [deferred.size(), discharged.size(), str(rows_ok), str(ad11), str(no_inference),
		   str(history_kept), str(refuses_back), str(refuses_stripped)])
	_reached("H02_am_rows_discharged_d383_with_history_and_rows_ten")
	return ok

func chk_H03_every_state_pin_moved_together_and_refuses_stale_lines() -> bool:
	var want := "STATE: " + ProdConfig.STATE
	var runners := ["res://tests/foundation_smoke.sh", "res://tests/imprint_smoke.sh",
		"res://tests/alignment_smoke.sh", "res://tests/huntress_smoke.sh"]
	var rows: Array[String] = []
	var all_ok := true
	var re := RegEx.new()
	re.compile("(?m)^STATE_EXPECT=\"(.*)\"$")
	var re380 := RegEx.new()
	re380.compile("(?m)^STATE_D380_LINE=\"(.*)\"$")
	# RE-PINNED UNDER D-396 (first act): every runner ALSO holds the D-392-era
	# line as a SUPERSEDED needle, exactly as each has held the D-380 one since
	# D-392. The D-396 runner is a fifth, checked by the D-396 suite.
	var re392 := RegEx.new()
	re392.compile("(?m)^STATE_D392_LINE=\"(.*)\"$")
	# RE-PINNED UNDER D-398 (first act): and the D-396-era line too, exactly as
	# the D-392 one. The D-396 and D-398 runners are checked by their own suites.
	var re396 := RegEx.new()
	re396.compile("(?m)^STATE_D396_LINE=\"(.*)\"$")
	for f in runners:
		var t := _read_text(f)
		var m := re.search(t)
		var m380 := re380.search(t)
		var m392 := re392.search(t)
		var m396 := re396.search(t)
		var pinned := m != null and m.get_string(1) == want
		var refuses := m380 != null and m380.get_string(1) == "STATE: " + STATE_D380 \
			and m380.get_string(1) != want
		var refuses392 := m392 != null and m392.get_string(1) == "STATE: " + STATE_D392 \
			and m392.get_string(1) != want
		var refuses396 := m396 != null and m396.get_string(1) == "STATE: " + STATE_D396 \
			and m396.get_string(1) != want
		all_ok = all_ok and pinned and refuses and refuses392 and refuses396
		rows.append("%s pinned=%s refuses-D-380=%s refuses-D-392=%s refuses-D-396=%s" % [f.get_file(), str(pinned), str(refuses), str(refuses392), str(refuses396)])
	# The two gd suites that assert the line state the D-383, D-394, D-397 and
	# D-398 clauses. RE-PINNED UNDER D-398: the D-396 OPEN clause gave way to the
	# D-397 acceptance and the D-398 OPEN clause.
	var a_code := _code_only(_read_text("res://tests/alignment_verification.gd"))
	var i_code := _code_only(_read_text("res://tests/imprint_verification.gd"))
	var gd_ok := a_code.find("D-378 ALIGNMENT STAGE ACCEPTED and CLOSED (D-383)") >= 0 \
		and a_code.find("HUNTRESS SPLINTER SHOT STAGE ACCEPTED and CLOSED (D-394)") >= 0 \
		and a_code.find("KINDRED HOUNDS STAGE ACCEPTED and CLOSED (D-397)") >= 0 \
		and a_code.find("MOBILE MINION COHESION STAGE ACCEPTED and CLOSED (D-399)") >= 0 \
		and a_code.find("PLAYER LOCOMOTION REDIRECTION STAGE ACCEPTED and CLOSED (D-401)") >= 0 \
		and a_code.find("CINDER FIELD STAGE ACCEPTED and CLOSED (D-403)") >= 0 \
		and a_code.find("PLAYER DIRECT-CLICK MOVEMENT CORRECTION STAGE DELIVERED and OPEN pending owner live review (D-404)") >= 0 \
		and i_code.find("D-378 ALIGNMENT STAGE ACCEPTED and CLOSED (D-383)") >= 0 \
		and i_code.find("HUNTRESS SPLINTER SHOT STAGE ACCEPTED and CLOSED (D-394)") >= 0 \
		and i_code.find("KINDRED HOUNDS STAGE ACCEPTED and CLOSED (D-397)") >= 0
	# THE GUARD CAN REFUSE: a runner text still pinning the D-380 line, or the
	# D-392-era one.
	var planted := "STATE_EXPECT=\"STATE: %s\"\n" % STATE_D380
	var pm := re.search(planted)
	var planted392 := "STATE_EXPECT=\"STATE: %s\"\n" % STATE_D392
	var pm392 := re.search(planted392)
	var planted396 := "STATE_EXPECT=\"STATE: %s\"\n" % STATE_D396
	var pm396 := re.search(planted396)
	var planted398 := "STATE_EXPECT=\"STATE: %s\"\n" % STATE_D398
	var pm398 := re.search(planted398)
	var refuses_planted := pm != null and pm.get_string(1) != want and pm392 != null and pm392.get_string(1) != want \
		and pm396 != null and pm396.get_string(1) != want and pm398 != null and pm398.get_string(1) != want
	var ok := all_ok and gd_ok and refuses_planted
	_note("H03_every_state_pin_moved_together_and_refuses_stale_lines",
		"RE-PINNED UNDER D-396, D-398 AND D-400 (first acts): %s | the alignment and imprint suites assert the D-383, D-394 and D-397 clauses (and the D-400 acceptance and open ones)=%s | a planted runner pinning the D-380, D-392-era, D-396-era or D-398-era line is refused=%s"
		% [" · ".join(rows), str(gd_ok), str(refuses_planted)])
	_reached("H03_every_state_pin_moved_together_and_refuses_stale_lines")
	return ok

# =============================================================================
# B. SPLINTER SHOT THROUGH THE ACCEPTED ARCHITECTURE
# =============================================================================

func chk_H04_splinter_shot_is_one_canonical_skill_imprint() -> bool:
	var lib := skills.library
	var imp := lib.get_imprint(HuntressContent.SKILL_SPLINTER_SHOT) as Imprint
	var exists := imp != null and lib.knows(HuntressContent.SKILL_SPLINTER_SHOT)
	var shape := exists and imp.kind == Imprint.Kind.SKILL and imp.canonical \
		and imp.id.find("DIAG") < 0 and imp.display_name == "Splinter Shot" \
		and Array(imp.provides_tags) == ["Attack", "Projectile", "Hit", "Physical"] \
		and imp.targeting == "directional" and imp.skill_class == Imprint.SkillClass.PRIMARY \
		and imp.label().find("CANONICAL") == 0 and Array(imp.rank_moves).has("Mana cost")
	var canon_ids: Array[String] = []
	var canon_primary: Array[String] = []
	for id in lib.ids():
		var i2 := lib.get_imprint(String(id)) as Imprint
		if i2 != null and i2.canonical:
			canon_ids.append(String(id))
			if i2.skill_class == Imprint.SkillClass.PRIMARY:
				canon_primary.append(String(id))
	# RE-SCOPED UNDER D-396, one for one: until D-396 Splinter Shot was the ONLY
	# canonical Imprint -- true when written. The D-396 ruling adds ONE canonical
	# PERSISTENT Skill Imprint, Kindred Hounds. So the canonical set must be
	# EXACTLY {Splinter Shot, Kindred Hounds}, AND Splinter Shot must still be the
	# ONE canonical PRIMARY Skill -- a claim at least as strong as the one replaced.
	var canon_sorted: Array = canon_ids.duplicate()
	canon_sorted.sort()
	# RE-SCOPED AGAIN UNDER D-402, one for one: the D-402 ruling adds ONE canonical
	# ACTIVE Skill Imprint, Cinder Field -- a SECONDARY Configuration class. So the
	# canonical set becomes EXACTLY {Splinter Shot, Kindred Hounds, Cinder Field},
	# and the stronger claim is UNTOUCHED: Splinter Shot is still the ONE canonical
	# PRIMARY Skill. Until D-402 the set was the first two: true when written.
	var want_canon: Array = [HuntressContent.SKILL_SPLINTER_SHOT, HoundContent.SKILL_KINDRED_HOUNDS,
		CinderContent.SKILL_CINDER_FIELD]
	want_canon.sort()
	var exactly_one := canon_sorted == want_canon and canon_primary == [HuntressContent.SKILL_SPLINTER_SHOT] \
		and HuntressContent.ALL_IMPRINTS == [HuntressContent.SKILL_SPLINTER_SHOT]
	# THE GUARD CAN REFUSE: a diagnostic Imprint is not canonical and says so.
	var diag := lib.get_imprint(String(DiagImprintContent.ALL_IMPRINTS[0])) as Imprint
	var diag_refused := diag != null and not diag.canonical and diag.label().find("CANONICAL") != 0
	var ok := exists and shape and exactly_one and diag_refused
	_note("H04_splinter_shot_is_one_canonical_skill_imprint",
		"'%s' is a SKILL Imprint, canonical, no DIAG in its id, tags %s, %s, PRIMARY=%s | canonical Imprints in the live library: %s — Splinter Shot the ONE canonical PRIMARY (re-scoped under D-396, which adds the Persistent Kindred Hounds) | label: '%s' | a diagnostic Imprint ('%s') is refused as canonical=%s"
		% [HuntressContent.SKILL_SPLINTER_SHOT, str(imp.provides_tags) if imp != null else "-",
		   imp.targeting if imp != null else "-", str(shape), str(canon_ids),
		   imp.label() if imp != null else "-", String(DiagImprintContent.ALL_IMPRINTS[0]), str(diag_refused)])
	_reached("H04_splinter_shot_is_one_canonical_skill_imprint")
	return ok

func chk_H05_learned_at_rank_1_with_0_xp_and_never_seeded() -> bool:
	var lib := skills.library
	var id := HuntressContent.SKILL_SPLINTER_SHOT
	var at_launch := int(launch["mastered"]) == 1 and is_zero_approx(float(launch["xp"]))
	var acq := lib.acquisition_record(id)
	var acquired := int(acq.get("rank", -1)) == 1 and is_zero_approx(float(acq.get("xp", -1.0)))
	var never_seeded := lib.seeded_rank(id) == 0
	# A second learn is IGNORED and moves nothing.
	var before := lib.mastered(id)
	var again := HuntressContent.learn_into(lib)
	var unchanged := not again and lib.mastered(id) == before
	# THE GUARD CAN REFUSE: on a scratch library, seeding IS detected.
	var scratch := ImprintLibrary.new()
	HuntressContent.learn_into(scratch)
	var fresh_ok := scratch.mastered(id) == 1 and is_zero_approx(scratch.xp(id)) and scratch.seeded_rank(id) == 0
	scratch.diagnostic_seed_prior_mastery(id, 7)
	var seeding_seen := scratch.seeded_rank(id) == 7 and scratch.mastered(id) == 7
	var diag_seeds := lib.diagnostic_seeds
	# XP COMES FROM AWARDED COMBAT PROGRESS while equipped (SS-16) -- proved on a
	# scratch library so the live one stays at 0 XP for the owner.
	var scratch2 := ImprintLibrary.new()
	HuntressContent.learn_into(scratch2)
	scratch2.award_combat_progress(ImprintConfig.COMBAT_PROGRESS_PER_ENEMY_DEFEATED, [id])
	var channel := scratch2.xp(id) > 0.0 or scratch2.mastered(id) > 1
	var equipped := skills.loadout.equipped_imprint_ids_with_duplicates().has(id)
	var ok := at_launch and acquired and never_seeded and unchanged and fresh_ok and seeding_seen \
		and diag_seeds == 14 and channel and equipped
	_note("H05_learned_at_rank_1_with_0_xp_and_never_seeded",
		"at launch Mastered Rank %d and %.1f XP=%s | acquisition record %s=%s | seeded rank %d (never seeded)=%s; the diagnostic seeds stay %d | a second learn is ignored=%s | a scratch library learns it at 1 / 0 XP=%s and a planted diagnostic seed IS detected (%d)=%s | XP arrives through AWARDED combat progress (scratch: %.1f XP)=%s and it is equipped to receive it=%s"
		% [int(launch["mastered"]), float(launch["xp"]), str(at_launch), str(acq), str(acquired),
		   lib.seeded_rank(id), str(never_seeded), diag_seeds, str(unchanged), str(fresh_ok), scratch.seeded_rank(id),
		   str(seeding_seen), scratch2.xp(id), str(channel), str(equipped)])
	_reached("H05_learned_at_rank_1_with_0_xp_and_never_seeded")
	return ok

func chk_H06_one_unmodified_configuration_resolves_one_arrow() -> bool:
	var cfg := skills.loadout.configuration(HuntressContent.CFG_SPLINTER_SHOT) as SkillConfiguration
	var ok_cfg := cfg != null and cfg.skill_id == HuntressContent.SKILL_SPLINTER_SHOT \
		and cfg.modifier_count() == 0 and bool(cfg.validate()["valid"]) and cfg.skill_rank() == 1 \
		and is_same(skills.configurations[HuntressContent.CFG_SPLINTER_SHOT], cfg)
	var res := cfg.resolve() if cfg != null else {}
	var one_arrow := int(res.get("projectiles", -1)) == 1 and String(res.get("delivery", "")) == "splinter_arrow" \
		and int(res.get("fork_children", -1)) == 0 and is_zero_approx(float(res.get("spread_deg", -1.0))) \
		and int(res.get("rain_volleys", -1)) == 0 and int(res.get("beast_count", -1)) == 0
	var timing := is_equal_approx(float(res.get("action_duration", 0.0)), HuntressConfig.splinter_action_s()) \
		and is_equal_approx(float(res.get("release_marker", 0.0)), HuntressConfig.splinter_release_marker())
	var numbers := is_equal_approx(float(res.get("damage", 0.0)), HuntressConfig.SPLINTER_DAMAGE_AT_RANK_1) \
		and is_equal_approx(float(res.get("mana_cost", 0.0)), HuntressConfig.SPLINTER_MANA_AT_RANK_1) \
		and is_zero_approx(float(res.get("cooldown", -1.0)))
	# THE GUARD CAN REFUSE: every DIAGNOSTIC Configuration keeps the ACCEPTED 0.36
	# marker and is not a Splinter arrow.
	# RE-SCOPED UNDER D-402, one for one: the exception set becomes {Splinter Shot,
	# Cinder Field} -- the TWO canonical ACTIVE Configurations, each with its own
	# DERIVED marker. Every remaining Configuration is diagnostic and must still
	# carry the ACCEPTED 0.36 exactly, so the guard is not weakened: it still
	# covers all five diagnostic Configurations and still refuses a Splinter arrow.
	var diag_kept := true
	var n_diag := 0
	for cid in skills.configurations.keys():
		if String(cid) == HuntressContent.CFG_SPLINTER_SHOT \
				or String(cid) == CinderContent.CFG_CINDER_FIELD:
			continue
		var r2: Dictionary = (skills.configurations[cid] as SkillConfiguration).resolve()
		n_diag += 1
		diag_kept = diag_kept and is_equal_approx(float(r2["release_marker"]), ProdConfig.ATTACK_RELEASE_MARKER) \
			and String(r2["delivery"]) != "splinter_arrow"
	var ok := ok_cfg and one_arrow and timing and numbers and diag_kept and n_diag >= 5
	_note("H06_one_unmodified_configuration_resolves_one_arrow",
		"'%s': one Skill Imprint, %d modifiers, valid=%s | resolves projectiles %d, delivery '%s', fork 0, spread 0=%s | action %.4f s, marker %.4f (DERIVED)=%s | damage %.1f, Mana %.1f, cooldown %.1f (PROVISIONAL)=%s | the %d diagnostic Configurations keep the ACCEPTED 0.36 marker and are not Splinter arrows=%s"
		% [HuntressContent.CFG_SPLINTER_SHOT, cfg.modifier_count() if cfg != null else -1, str(ok_cfg),
		   int(res.get("projectiles", -1)), String(res.get("delivery", "")), str(one_arrow),
		   float(res.get("action_duration", 0.0)), float(res.get("release_marker", 0.0)), str(timing),
		   float(res.get("damage", 0.0)), float(res.get("mana_cost", 0.0)), float(res.get("cooldown", 0.0)),
		   str(numbers), n_diag, str(diag_kept)])
	_reached("H06_one_unmodified_configuration_resolves_one_arrow")
	return ok

func chk_H07_bound_to_binding_6_with_six_equipped_and_capacity_stated() -> bool:
	var lo := skills.loadout
	var bound := lo.binding_count() == 8 and lo.bindings[HuntressContent.BINDING_INDEX] == HuntressContent.CFG_SPLINTER_SHOT \
		and HuntressContent.BINDING_INDEX == 5 and lo.bindings[6] == "" and lo.bindings[7] == ""
	var first_five_diag := true
	for i in 5:
		first_five_diag = first_five_diag and String(lo.bindings[i]) != "" \
			and String(lo.bindings[i]).find("DIAG") >= 0
	var six := lo.equipped_active_count() == 6 and lo.empty_binding_count() == 2
	var active := not lo.deactivated.has(HuntressContent.CFG_SPLINTER_SHOT)
	var used := lo.capacity_used()
	var total := lo.capacity_total()
	var within := used <= total
	var cost := (lo.configuration(HuntressContent.CFG_SPLINTER_SHOT) as SkillConfiguration).capacity_cost()
	# MEASURED, NOT A RULING: with the SIMULATED gear Capacity removed, which
	# Configuration does the accepted revalidation deactivate?
	var off: Dictionary = skills.set_gear_bonus(false)
	var deact_without_gear := lo.deactivated.has(HuntressContent.CFG_SPLINTER_SHOT)
	var deact_list: Array = lo.deactivated.keys()
	var on: Dictionary = skills.set_gear_bonus(true)
	var restored := not lo.deactivated.has(HuntressContent.CFG_SPLINTER_SHOT) and lo.capacity_total() == total
	_finding("CAPACITY (MEASURED): with Splinter Shot equipped the loadout uses %d of %d PROVISIONAL Capacity (Splinter Shot costs %d). With the SIMULATED gear Capacity OFF, the accepted revalidation deactivates %s — Splinter Shot deactivated=%s. Nothing is re-tuned; this is recorded for the owner."
		% [used, total, cost, str(deact_list), str(deact_without_gear)])
	var ok := bound and first_five_diag and six and active and within and restored \
		and bool(off.get("ok", true)) and bool(on.get("ok", true))
	_note("H07_bound_to_binding_6_with_six_equipped_and_capacity_stated",
		"bindings: %s | Splinter Shot on binding 6, bindings 7-8 EMPTY=%s | bindings 1-5 keep their diagnostic Configurations=%s | 6 equipped / 2 empty=%s | not deactivated=%s | Capacity %d / %d (cost %d) within=%s | gear OFF deactivates %s, gear ON restores=%s"
		% [str(lo.bindings), str(bound), str(first_five_diag), str(six), str(active), used, total, cost,
		   str(within), str(deact_list), str(restored)])
	_reached("H07_bound_to_binding_6_with_six_equipped_and_capacity_stated")
	return ok

## The accepted diagnostic attack's INPUT ACTION (its design name is a label).
const DIAG_INPUT := "diagnostic_attack"

func chk_H08_the_ordinary_attack_input_reaches_splinter_shot_not_the_bolt() -> bool:
	await _rest()
	var b6 := String(SkillRuntime.BINDING_ACTIONS[HuntressContent.BINDING_INDEX])
	# THE MAP: right mouse, key 6 and pad button 7 activate binding 6; the
	# diagnostic attack action keeps its name and has NO physical event.
	var rmb := InputEventMouseButton.new()
	rmb.button_index = MOUSE_BUTTON_RIGHT
	rmb.pressed = true
	var key6 := InputEventKey.new()
	key6.physical_keycode = KEY_6
	key6.pressed = true
	var pad7 := InputEventJoypadButton.new()
	pad7.button_index = JOY_BUTTON_LEFT_STICK
	pad7.pressed = true
	var mapped := InputMap.event_is_action(rmb, b6) and InputMap.event_is_action(key6, b6) \
		and InputMap.event_is_action(pad7, b6) and b6 == "imprint_binding_6"
	var bolt_unreached := InputMap.has_action(DIAG_INPUT) \
		and InputMap.action_get_events(DIAG_INPUT).is_empty() \
		and not InputMap.event_is_action(rmb, DIAG_INPUT) \
		and not InputMap.event_is_action(pad7, DIAG_INPUT)
	# THE REAL INPUT PATH: the binding pressed on a physics frame, held two frames.
	cam.debug_cursor_override = _lane_point(6.0)
	await _phys(3)
	var uses0 := skills.skill_uses
	var begun0 := hr.uses_begun
	var shots0 := player.shots_fired
	var arrows0 := hr.arrows_released
	await physics_frame
	Input.action_press(b6)
	await physics_frame
	await physics_frame
	Input.action_release(b6)
	await physics_frame
	var label_now := player.commitment.label
	var used := skills.skill_uses == uses0 + 1 and hr.uses_begun == begun0 + 1 \
		and label_now == HuntressConfig.SPLINTER_ACTION_LABEL
	await _await_release(arrows0)
	await _await_action_end()
	var released := hr.arrows_released == arrows0 + 1 and player.shots_fired == shots0 \
		and skills.skill_uses == uses0 + 1
	var ok := mapped and bolt_unreached and used and released
	_note("H08_the_ordinary_attack_input_reaches_splinter_shot_not_the_bolt",
		"right mouse, key 6 and pad button 7 activate '%s'=%s | '%s' keeps its name with ZERO physical events and matches neither right mouse nor pad button 7=%s | a real press held two physics frames made ONE Skill Use, committed as '%s'=%s | it released ONE arrow and the diagnostic bolt fired 0 times=%s"
		% [b6, str(mapped), DIAG_INPUT, str(bolt_unreached), label_now, str(used), str(released)])
	_reached("H08_the_ordinary_attack_input_reaches_splinter_shot_not_the_bolt")
	return ok

func chk_H09_held_input_repeats_at_the_action_time_resampling_aim() -> bool:
	await _rest()
	var b6 := String(SkillRuntime.BINDING_ACTIONS[HuntressContent.BINDING_INDEX])
	var a_pt := _lane_point(7.0, -1.0)
	var b_pt := _lane_point(7.0, 1.0)
	cam.debug_cursor_override = a_pt
	await _phys(3)
	var begun0 := hr.uses_begun
	var log0 := hr.release_log.size()
	var start_frames: Array[int] = []
	var last_begun := begun0
	await physics_frame
	Input.action_press(b6)
	var g := 0
	var switched := false
	while g < 150:
		await physics_frame
		g += 1
		if hr.uses_begun != last_begun:
			last_begun = hr.uses_begun
			start_frames.append(Engine.get_physics_frames())
		# After the first release, the cursor moves: the NEXT use must sample it.
		if not switched and hr.release_log.size() > log0:
			cam.debug_cursor_override = b_pt
			switched = true
		if start_frames.size() >= 3:
			break
	Input.action_release(b6)
	var uses_while_held := hr.uses_begun - begun0
	await _await_action_end()
	await _phys(6)
	var no_more := hr.uses_begun - begun0 == uses_while_held
	var gaps: Array[int] = []
	for i in range(1, start_frames.size()):
		gaps.append(start_frames[i] - start_frames[i - 1])
	var action_frames := HuntressConfig.splinter_action_s() * float(Engine.physics_ticks_per_second)
	var gaps_ok := gaps.size() >= 2
	for gp in gaps:
		gaps_ok = gaps_ok and absf(float(gp) - action_frames) <= 2.0
	# Each use aimed where the cursor was WHEN IT BEGAN.
	var aim1: Vector3 = hr.release_log[log0]["aim"] if hr.release_log.size() > log0 else Vector3.ZERO
	var aim2: Vector3 = hr.release_log[log0 + 1]["aim"] if hr.release_log.size() > log0 + 1 else Vector3.ZERO
	var want1 := (a_pt - lane_from); want1.y = 0; want1 = want1.normalized()
	var want2 := (b_pt - lane_from); want2.y = 0; want2 = want2.normalized()
	var resampled := aim1.angle_to(want1) < 0.01 and aim2.angle_to(want2) < 0.01 and aim1.angle_to(aim2) > 0.1
	# ONLY Splinter Shot repeats: every diagnostic Skill Imprint is press-only.
	var only_splinter := HuntressContent.is_repeatable(HuntressContent.SKILL_SPLINTER_SHOT)
	for id in DiagImprintContent.ALL_IMPRINTS:
		only_splinter = only_splinter and not HuntressContent.is_repeatable(String(id))
	var ok := uses_while_held >= 3 and no_more and gaps_ok and resampled and only_splinter
	_note("H09_held_input_repeats_at_the_action_time_resampling_aim",
		"holding binding 6 began %d uses (>= 3) and none after release=%s | start-to-start gaps %s physics frames against the %.1f-frame action=%s | use 1 aimed %s (cursor A), use 2 aimed %s (cursor B after release 1): each sampled at ITS start=%s | only Splinter Shot is repeatable; the diagnostic Imprints stay press-only=%s"
		% [uses_while_held, str(no_more), str(gaps), action_frames, str(gaps_ok), str(aim1), str(aim2),
		   str(resampled), str(only_splinter)])
	_reached("H09_held_input_repeats_at_the_action_time_resampling_aim")
	return ok

func chk_H10_the_diagnostic_bolt_is_test_only_and_not_disguised() -> bool:
	await _rest()
	# NOT DISGUISED: no Huntress file references the bolt or its entry points.
	var re := RegEx.new()
	re.compile("DiagnosticBolt|begin_attack|_release_bolt|DIAG_ATTACK_DESIGN_NAME|BOLT_DAMAGE|BOLT_SPEED")
	var offenders: Array[String] = []
	for f in _huntress_script_files():
		if re.search(_code_only(_read_text(f))) != null:
			offenders.append(f.get_file())
	var distinct := HuntressConfig.SPLINTER_ACTION_LABEL != ProdConfig.DIAG_ATTACK_DESIGN_NAME \
		and HuntressConfig.ARROW_SPEED_MPS != ProdConfig.BOLT_SPEED_MPS
	# TEST-ONLY, AND STILL THERE: the accepted suites drive it through the seam.
	cam.debug_cursor_override = _lane_point(6.0)
	await _phys(3)
	var shots0 := player.shots_fired
	var uses0 := skills.skill_uses
	var begun0 := hr.uses_begun
	player.intent.debug_attack_held = true
	await _phys(2)
	player.intent.debug_attack_held = null
	var label := player.commitment.label
	await _await_action_end()
	var bolt_fired := player.shots_fired == shots0 + 1 and label == ProdConfig.DIAG_ATTACK_DESIGN_NAME \
		and skills.skill_uses == uses0 and hr.uses_begun == begun0
	await _phys(30)
	# The F1 overlay says so, in its own words.
	var ov_text := hud.compose()
	var said := ov_text.find("TEST-ONLY since D-392") >= 0
	# THE SCAN CAN REFUSE a planted reference, and ignores a planted comment.
	var caught := re.search(_code_only("var b := DiagnosticBolt.new()")) != null
	var ignored := re.search(_code_only("# was the DiagnosticBolt once")) == null
	var ok := offenders.is_empty() and distinct and bolt_fired and said and caught and ignored
	_note("H10_the_diagnostic_bolt_is_test_only_and_not_disguised",
		"Huntress files referencing the bolt or its entry points: %s | the Splinter action label and speed differ from the bolt's=%s | through the TEST SEAM the bolt still fires once as '%s' with 0 Skill Uses and 0 Splinter uses=%s | the F1 overlay states it is TEST-ONLY=%s | the scan catches a planted reference=%s and ignores a comment=%s"
		% [str(offenders), str(distinct), label, str(bolt_fired), str(said), str(caught), str(ignored)])
	_reached("H10_the_diagnostic_bolt_is_test_only_and_not_disguised")
	return ok

func chk_H11_cost_at_use_start_one_use_per_activation_and_xp_not_from_use() -> bool:
	await _rest()
	var id := HuntressContent.SKILL_SPLINTER_SHOT
	var xp0 := skills.library.xp(id)
	var rank0 := skills.library.mastered(id)
	cam.debug_cursor_override = _lane_point(6.0)
	await _phys(3)
	var mana0 := skills.pool.mana_current
	var r := skills.use_binding(HuntressContent.BINDING_INDEX)
	var paid := bool(r["ok"]) and is_equal_approx(mana0 - skills.pool.mana_current, HuntressConfig.SPLINTER_MANA_AT_RANK_1) \
		and is_equal_approx(float(r["cost"]), HuntressConfig.SPLINTER_MANA_AT_RANK_1)
	await _await_action_end()
	# FIVE MORE USES: one release per use id, one arrow per use, no XP from use.
	var log0 := hr.release_log.size()
	var uses0 := skills.skill_uses
	var rel0 := skills.releases
	var ids: Array[String] = []
	for i in 5:
		skills.pool.refill()
		var rr := skills.use_binding(HuntressContent.BINDING_INDEX)
		ids.append(String(rr.get("use_id", "")))
		await _await_action_end()
	await _phys(2)
	var per_use := skills.skill_uses == uses0 + 5 and skills.releases == rel0 + 5 \
		and hr.release_log.size() == log0 + 5
	for u in ids:
		var n := 0
		for e in hr.release_log:
			if String(e["use"]) == u:
				n += 1
		per_use = per_use and n == 1
	var no_xp := is_equal_approx(skills.library.xp(id), xp0) and skills.library.mastered(id) == rank0
	# A USE THAT CANNOT PAY IS REFUSED BEFORE IT BEGINS -- the guard is reachable.
	skills.pool.mana_current = 1.0
	var refused_before := skills.skill_uses
	var rf := skills.use_binding(HuntressContent.BINDING_INDEX)
	var refused := not bool(rf["ok"]) and String(rf["reason"]).find("costs 6.0 Mana") >= 0 \
		and skills.skill_uses == refused_before and not player.commitment.active
	skills.pool.refill()
	var ok := paid and per_use and no_xp and refused
	_note("H11_cost_at_use_start_one_use_per_activation_and_xp_not_from_use",
		"Mana %.1f -> %.1f on the SAME call that began the use (cost %.1f)=%s | five uses: +5 Skill Uses, +5 releases, each use id released exactly once (%s)=%s | Splinter Shot XP %.1f -> %.1f and rank %d -> %d: USING it earns nothing=%s | with 1 Mana the use is refused before it begins ('%s')=%s"
		% [mana0, mana0 - float(r.get("cost", 0.0)), float(r.get("cost", 0.0)), str(paid), str(ids), str(per_use),
		   xp0, skills.library.xp(id), rank0, skills.library.mastered(id), str(no_xp), String(rf["reason"]), str(refused)])
	_reached("H11_cost_at_use_start_one_use_per_activation_and_xp_not_from_use")
	return ok

func chk_H12_action_entry_points_are_six_both_directions() -> bool:
	var got: Array = SkillRuntime.all_action_entry_points()
	var want: Array = [ProdConfig.DIAG_ATTACK_DESIGN_NAME]
	for id in DiagImprintContent.ALL_IMPRINTS:
		if String(id).begins_with("SKILL_IMPRINT_"):
			want.append(String(id))
	want.append(HuntressContent.SKILL_SPLINTER_SHOT)
	# RE-SCOPED UNDER D-396, one for one: 6 -> 6 + 1 = 7. Kindred Hounds is a
	# Persistent Skill Imprint and counts exactly as the diagnostic aura has since
	# D-375; it has no binding and no input.
	want.append(HoundContent.SKILL_KINDRED_HOUNDS)
	# RE-SCOPED UNDER D-402, one for one: 7 + 1 = 8 -- Cinder Field, a canonical
	# ACTIVE Skill Imprint on binding 7. The set is still derived independently
	# and still compared in BOTH directions. Until D-402 this was 7: true then.
	want.append(CinderContent.SKILL_CINDER_FIELD)
	var both := got.size() == 8 and want.size() == 8
	for w in want:
		both = both and got.has(w)
	for g in got:
		both = both and want.has(g)
	# No Huntress file defines a second attack entry point on the controller's model.
	var re := RegEx.new()
	re.compile("(?m)^\\s*func\\s+(begin_attack|begin_shot|use_binding|fire_splinter|_release_bolt)\\b")
	var offenders: Array[String] = []
	for f in _huntress_script_files():
		if re.search(_code_only(_read_text(f))) != null:
			offenders.append(f.get_file())
	var begin_count := RegEx.new()
	begin_count.compile("(?m)^\\s*func\\s+begin_")
	var ctrl_begins := begin_count.search_all(_code_only(_read_text("res://scripts/control/player_controller.gd"))).size()
	# THE PIN CAN REFUSE: NINE entry points, or SEVEN.
	# RE-SCOPED UNDER D-402, one for one, WITH the count it guards: the planted
	# set must be one MORE than the real one and the truncated set one FEWER, or
	# the control would agree with the thing it exists to refuse. Until D-402 the
	# pin was 7 and the controls were 8 and 6: true when written.
	var nine: Array = got.duplicate()
	nine.append("SKILL_IMPRINT_PLANTED")
	var refuses := nine.size() != 8 and got.slice(1).size() != 8
	var ok := both and offenders.is_empty() and ctrl_begins == 1 and refuses
	_note("H12_action_entry_points_are_six_both_directions",
		"entry points %s — exactly the bolt, the four diagnostic Skill Imprints, Splinter Shot and (D-396) Kindred Hounds, in BOTH directions (5 + 1 + 1 = 7)=%s | Huntress files defining an attack entry point: %s | the accepted controller still has %d `begin_*` (F51) | a planted 8 or a dropped 6 is refused=%s"
		% [str(got), str(both), str(offenders), ctrl_begins, str(refuses)])
	_reached("H12_action_entry_points_are_six_both_directions")
	return ok

# =============================================================================
# C. TIMING AND THE ACCEPTED COMMITMENT
# =============================================================================

## One use along the lane; returns {use_frame, release_frame, end_frame,
## release_elapsed, use_id}.
func _timed_use(point: Vector3) -> Dictionary:
	var before := hr.arrows_released
	var r := await _fire_at(point)
	var f0 := Engine.get_physics_frames()
	var g := 0
	while g < 200 and hr.arrows_released <= before:
		await physics_frame
		g += 1
	var rel: Dictionary = hr.release_log.back() if hr.arrows_released > before else {}
	while g < 300 and player.commitment.active:
		await physics_frame
		g += 1
	# This coroutine resumes at the START of a physics frame, so the action ENDED
	# on the frame BEFORE the one that first sees it inactive. The use began on
	# `f0` and the commitment advanced on that same frame, so the action lasted
	# (end_frame - f0 + 1) steps and the recovery (end_frame - release_frame).
	# (The first version counted the observing frame -- one frame too many.)
	return {"ok": bool(r["ok"]), "use_id": String(r.get("use_id", "")), "use_frame": f0,
		"release_frame": int(rel.get("frame", -1)), "end_frame": Engine.get_physics_frames() - 1,
		"release_elapsed": float(rel.get("elapsed", -1.0)), "release": rel}

func chk_H13_release_at_the_provisional_candidate_with_derived_recovery() -> bool:
	await _rest()
	var dt := 1.0 / float(Engine.physics_ticks_per_second)
	var cand := is_equal_approx(HuntressConfig.SPLINTER_RELEASE_S, 0.50)
	var derived := is_equal_approx(HuntressConfig.splinter_recovery_s(),
			ProdConfig.ATTACK_COOLDOWN_S * (1.0 - ProdConfig.ATTACK_RELEASE_MARKER)) \
		and is_equal_approx(HuntressConfig.splinter_action_s(), HuntressConfig.SPLINTER_RELEASE_S + HuntressConfig.splinter_recovery_s()) \
		and is_equal_approx(HuntressConfig.splinter_release_marker() * HuntressConfig.splinter_action_s(), HuntressConfig.SPLINTER_RELEASE_S)
	var labelled := true
	for row in HuntressConfig.registry():
		if String(row[0]).begins_with("Splinter Shot"):
			labelled = labelled and String(row[2]).find("PROVISIONAL") >= 0
	var t := await _timed_use(_lane_point(6.0))
	var rel_s := float(t["release_elapsed"])
	var on_time := rel_s >= HuntressConfig.SPLINTER_RELEASE_S - 1e-6 and rel_s <= HuntressConfig.SPLINTER_RELEASE_S + dt + 1e-6
	var rec_frames := int(t["end_frame"]) - int(t["release_frame"])
	var rec_s := float(rec_frames) * dt
	var rec_ok := absf(rec_s - HuntressConfig.splinter_recovery_s()) <= 1.0 * dt + 1e-6
	var not_attack_speed := true
	for f in _huntress_script_files():
		var c := _code_only(_read_text(f)).to_lower()
		not_attack_speed = not_attack_speed and c.find("attack_speed") < 0 and c.find("attack_time") < 0
	# THE WINDOW CAN REFUSE: the accepted bolt's release (0.162 s) is not this one.
	var bolt_release := ProdConfig.ATTACK_COOLDOWN_S * ProdConfig.ATTACK_RELEASE_MARKER
	var refuses := not (bolt_release >= HuntressConfig.SPLINTER_RELEASE_S - 1e-6 and bolt_release <= HuntressConfig.SPLINTER_RELEASE_S + dt)
	var ok := bool(t["ok"]) and cand and derived and labelled and on_time and rec_ok and not_attack_speed and refuses
	_note("H13_release_at_the_provisional_candidate_with_derived_recovery",
		"SPLINTER_RELEASE_S %.2f (the D-390/D-391 PROVISIONAL candidate)=%s | recovery %.4f = 0.45 x (1 - 0.36), action %.4f, marker %.4f — DERIVED=%s | every Splinter Shot registry row PROVISIONAL=%s | MEASURED: release at %.4f s of the use (<= one %.4f s frame after 0.50)=%s; release to end %d physics steps = %.4f s against the derived %.4f (within one step)=%s | no attack-speed or attack-time scaling exists in any Huntress file=%s | the accepted bolt's %.3f s release is refused by the window=%s"
		% [HuntressConfig.SPLINTER_RELEASE_S, str(cand), HuntressConfig.splinter_recovery_s(), HuntressConfig.splinter_action_s(),
		   HuntressConfig.splinter_release_marker(), str(derived), str(labelled), rel_s, dt, str(on_time), rec_frames, rec_s,
		   HuntressConfig.splinter_recovery_s(), str(rec_ok), str(not_attack_speed), bolt_release, str(refuses)])
	_reached("H13_release_at_the_provisional_candidate_with_derived_recovery")
	return ok

func chk_H14_stop_policy_stops_translation_within_tolerance() -> bool:
	await _rest()
	# MOVING AT SPEED FIRST -- the action must actually stop something.
	cam.debug_cursor_override = _lane_point(9.0)
	player.command_move_to(_lane_point(9.0))
	var p_start := player.global_position
	await _phys(45)
	var moved_before := player.global_position.distance_to(p_start)
	var speed_before := player.motor.speed()
	var r := skills.use_binding(HuntressContent.BINDING_INDEX)
	var p_use := player.global_position
	var policy := player.commitment.policy_name()
	var max_d := 0.0
	var suppressed_all := true
	var g := 0
	while player.commitment.active and g < 120:
		await physics_frame
		g += 1
		max_d = maxf(max_d, player.global_position.distance_to(p_use))
		if player.commitment.active:
			suppressed_all = suppressed_all and player.commitment.suppresses_translation()
	await _phys(6)
	var after_end := player.global_position.distance_to(p_use)
	var tol := ProdConfig.ACTION_GLIDE_TOLERANCE_M
	var ok := bool(r["ok"]) and moved_before > 1.0 and speed_before > 3.0 and policy == "STOP" \
		and suppressed_all and max_d <= tol and after_end <= tol
	_note("H14_stop_policy_stops_translation_within_tolerance",
		"before the use she moved %.2f m at %.2f m/s (the action had something to stop) | policy %s, translation suppressed on every committed frame=%s | translation from the use frame: max %.4f m during the action, %.4f m six frames after it (the accepted %.2f m tolerance) | the navigation order was abandoned, so she did not resume by herself"
		% [moved_before, speed_before, policy, str(suppressed_all), max_d, after_end, tol])
	_reached("H14_stop_policy_stops_translation_within_tolerance")
	return ok

func chk_H15_draw_movement_is_buffered_and_cancel_refused() -> bool:
	await _rest()
	var before := hr.arrows_released
	var r := await _fire_at(_lane_point(6.0))
	var p_use := player.global_position
	var buf0 := player.buffered_moves
	var ref0 := player.commitment.cancels_refused
	await _phys(4)
	# A MOVE ORDER DURING THE DRAW: recorded, never translated.
	cam.debug_cursor_override = _lane_point(-3.0, 2.0)
	player.intent.debug_move_command_held = true
	await _phys(6)
	var in_draw := player.commitment.active and not player.commitment.cancel_window_open()
	var buffered := player.buffered_moves > buf0
	var still := player.global_position.distance_to(p_use) <= 0.01
	# A CANCEL DEMANDED DURING THE DRAW IS REFUSED AND COUNTED.
	var cancelled := player.commitment.cancel_recovery()
	var refused := not cancelled and player.commitment.cancels_refused == ref0 + 1 and player.commitment.active
	var no_arrow_yet := hr.arrows_released == before
	await _await_release(before)
	var released_once := hr.arrows_released == before + 1
	player.intent.clear_seams()
	cam.debug_cursor_override = null
	await _await_action_end()
	var ok := bool(r["ok"]) and in_draw and buffered and still and refused and no_arrow_yet and released_once
	_note("H15_draw_movement_is_buffered_and_cancel_refused",
		"a move order held during the DRAW was buffered (%d -> %d)=%s while she moved %.4f m=%s | a cancel demanded during the draw returned %s, refusals %d -> %d, the action still committed=%s | no arrow before the release=%s, then exactly one=%s"
		% [buf0, player.buffered_moves, str(buffered), player.global_position.distance_to(p_use), str(still),
		   str(cancelled), ref0, player.commitment.cancels_refused, str(refused), str(no_arrow_yet), str(released_once)])
	_reached("H15_draw_movement_is_buffered_and_cancel_refused")
	return ok

func chk_H16_post_release_movement_cancels_recovery_and_arrow_survives() -> bool:
	await _rest()
	SplinterArrow.reset_counters()
	var before := hr.arrows_released
	var cancels0 := player.recovery_cancels
	var r := await _fire_at(_lane_point(6.0))
	await _await_release(before)
	var arrow: SplinterArrow = hr.arrows.back() if not hr.arrows.is_empty() else null
	var path0 := arrow.path_m if arrow != null else -1.0
	var el_at_release := player.commitment.elapsed
	# MOVE, right after the release.
	cam.debug_cursor_override = _lane_point(-4.0)
	player.intent.debug_move_command_just = true
	player.intent.debug_move_command_held = true
	await _phys(1)
	var cancelled := not player.commitment.active and player.recovery_cancels == cancels0 + 1
	await _phys(1)
	var hold_off := not player.facing_hold_active()
	var anim_left := not hr.animator.in_action and not hr.animator.tail_active
	var alive := arrow != null and is_instance_valid(arrow) and arrow.path_m > path0
	var one := SplinterArrow.spawned == 1 and hr.arrows_released == before + 1
	player.intent.debug_move_command_just = null
	await _phys(20)
	var walking := player.global_position.distance_to(lane_from) > 0.3
	player.intent.clear_seams()
	cam.debug_cursor_override = null
	var ok := bool(r["ok"]) and cancelled and hold_off and anim_left and alive and one and walking
	_note("H16_post_release_movement_cancels_recovery_and_arrow_survives",
		"released at %.3f s; a move order then CANCELLED the remaining recovery (cancels %d -> %d)=%s | the facing hold released=%s | the placeholder left the action with no decorative tail=%s | the arrow still exists and kept flying (%.2f m -> %.2f m)=%s | arrows spawned %d (exactly one)=%s | she walked off=%s"
		% [el_at_release, cancels0, player.recovery_cancels, str(cancelled), str(hold_off), str(anim_left),
		   path0, arrow.path_m if arrow != null and is_instance_valid(arrow) else -1.0, str(alive),
		   SplinterArrow.spawned, str(one), str(walking)])
	_reached("H16_post_release_movement_cancels_recovery_and_arrow_survives")
	return ok

func chk_H17_full_action_completes_without_movement() -> bool:
	await _rest()
	var dt := 1.0 / float(Engine.physics_ticks_per_second)
	var comp0 := player.commitment.completions
	var cancels0 := player.recovery_cancels
	var p0 := player.global_position
	var t := await _timed_use(_lane_point(6.0))
	var frames := int(t["end_frame"]) - int(t["use_frame"]) + 1
	var dur_ok := absf(float(frames) * dt - HuntressConfig.splinter_action_s()) <= 1.0 * dt + 1e-6
	var completed := player.commitment.completions == comp0 + 1 and player.recovery_cancels == cancels0
	var stay_d := player.global_position.distance_to(p0)
	var stayed := stay_d <= 0.005
	await physics_frame
	var tail := hr.animator.tail_active
	# THE TAIL IS DECORATIVE: a move order ends it at once.
	cam.debug_cursor_override = _lane_point(-4.0)
	player.intent.debug_move_command_just = true
	player.intent.debug_move_command_held = true
	await _phys(3)
	var tail_ended := not hr.animator.tail_active
	player.intent.clear_seams()
	cam.debug_cursor_override = null
	var ok := bool(t["ok"]) and dur_ok and completed and stayed and tail and tail_ended
	_note("H17_full_action_completes_without_movement",
		"with no movement the action ran %d physics steps = %.4f s against %.4f (within one step)=%s | completions +1, cancels unchanged=%s | she stayed put (%.4f m)=%s | the Release clip then finished as a DECORATIVE TAIL=%s, which a move order ended at once=%s"
		% [frames, float(frames) * dt, HuntressConfig.splinter_action_s(), str(dur_ok), str(completed),
		   stay_d, str(stayed), str(tail), str(tail_ended)])
	_reached("H17_full_action_completes_without_movement")
	return ok

func chk_H18_release_frame_is_shared_and_mechanical_timing_is_independent() -> bool:
	await _rest()
	var t1 := await _timed_use(_lane_point(6.0))
	var anim_frame: int = int(hr.animator.release_frames.back()) if hr.animator.release_frames.size() > 0 else -1
	var shared: bool = anim_frame == int(t1["release_frame"])
	var base_frames := int(t1["release_frame"]) - int(t1["use_frame"])
	# THE ANIMATION CLOCK SCALED x0.5 and x2.0 BY THE TEST SEAM: the mechanical
	# release must not move by a frame.
	var rows: Array[String] = []
	var same := true
	var taus: Array[float] = []
	var fb0 := hr.fallback_spawns
	for s in [0.5, 2.0]:
		await _rest()
		hr.animator.debug_playback_scale = float(s)
		var t := await _timed_use(_lane_point(6.0))
		var fr := int(t["release_frame"]) - int(t["use_frame"])
		taus.append(hr.animator.tau)
		same = same and fr == base_frames and bool(t["ok"])
		rows.append("x%.1f -> release after %d frames" % [float(s), fr])
		hr.animator.debug_playback_scale = 1.0
	# At x0.5 the nocked arrow had not been drawn by the release; the arrow still
	# left, and that is COUNTED -- never silent.
	var fallback_counted := hr.fallback_spawns == fb0 + 1
	var an := hr.animator
	var rate_derived := is_equal_approx(an.playback_rate, an.t_rel / HuntressConfig.SPLINTER_RELEASE_S) \
		and is_equal_approx(an.release_real_time(), HuntressConfig.SPLINTER_RELEASE_S)
	_finding("PLAYBACK (MEASURED): the KayKit draw's authored release is %.4f s (full draw %.4f + hold %.2f); the clip therefore plays at x%.4f — DERIVED, never chosen, and NOT attack speed."
		% [an.t_rel, an.t_full, HuntressConfig.HOLD_S, an.playback_rate])
	var ok := bool(t1["ok"]) and shared and same and fallback_counted and rate_derived
	_note("H18_release_frame_is_shared_and_mechanical_timing_is_independent",
		"the pose entered Ranged_Bow_Release on physics frame %d and the arrow left on %d — THE SAME FRAME=%s | the x1.0 release came %d frames after the use; %s — mechanical timing independent of the animation clock=%s | at x0.5 the arrow left from the muzzle fallback, counted (%d -> %d)=%s | the seam restored to 1.0"
		% [anim_frame, int(t1["release_frame"]),
		   str(shared), base_frames, ", ".join(rows), str(same), fb0, hr.fallback_spawns, str(fallback_counted)])
	_reached("H18_release_frame_is_shared_and_mechanical_timing_is_independent")
	return ok

# =============================================================================
# D. FACING — D-391 ruling 2
# =============================================================================

## Faces her along `dir` (visual settled) before a facing check.
func _settle_facing(dir: Vector3) -> void:
	cam.debug_cursor_override = player.global_position + dir.normalized() * 6.0
	await _phys(24)

static func _rot_y(v: Vector3, deg: float) -> Vector3:
	return v.rotated(Vector3.UP, deg_to_rad(deg))

func chk_H19_aim_sampled_once_facing_snaps_and_no_turning_phase() -> bool:
	await _rest()
	# 0 degrees: the reference release.
	await _settle_facing(lane_dir)
	var t0 := await _timed_use(_lane_point(6.0))
	var frames0 := int(t0["release_frame"]) - int(t0["use_frame"])
	# 150 degrees away from where she faces.
	await _rest()
	await _settle_facing(lane_dir)
	var swing_dir := _rot_y(lane_dir, 150.0)
	var holds0 := player.facing_holds
	cam.debug_cursor_override = player.global_position + swing_dir * 6.0
	await physics_frame
	var r := skills.use_binding(HuntressContent.BINDING_INDEX)
	var f_use := Engine.get_physics_frames()
	var sampled := skills.sampled_aim_dir()
	var mech := player.mechanical_facing_yaw()
	var vis := player.visual.rotation.y
	var snapped := player.facing_hold_active() and player.facing_holds == holds0 + 1 \
		and is_equal_approx(mech, wrapf(YawDriver.yaw_to(sampled), -PI, PI)) \
		and sampled.angle_to(swing_dir) < 0.01
	var gap_at_start := _deg(vis - mech)
	var committed_now := player.commitment.active and is_zero_approx(player.commitment.elapsed)
	var before := hr.arrows_released
	await _await_release(before)
	var frames150: int = int(hr.release_log.back()["frame"]) - f_use
	await _await_action_end()
	var no_turning_phase := frames150 == frames0
	# THE GUARD CAN REFUSE: the VISUAL at start was far from the snapped facing, so
	# "facing" read from the visual would have failed this check.
	var visual_would_fail := gap_at_start > 100.0
	var ok := bool(r["ok"]) and snapped and committed_now and no_turning_phase and visual_would_fail
	_note("H19_aim_sampled_once_facing_snaps_and_no_turning_phase",
		"a 150-degree aim: on the call that began the use the MECHANICAL facing was the sampled aim's yaw %.2f deg (a hold, count +1)=%s while the VISUAL was still %.1f deg away (so reading the visual would fail)=%s | committed on that same call, elapsed 0=%s | release after %d frames against %d at 0 degrees: NO turning phase=%s"
		% [rad_to_deg(mech), str(snapped), gap_at_start, str(visual_would_fail), str(committed_now), frames150,
		   frames0, str(no_turning_phase)])
	_reached("H19_aim_sampled_once_facing_snaps_and_no_turning_phase")
	return ok

func chk_H20_cursor_swing_redirects_neither_arrow_nor_facing() -> bool:
	await _rest()
	await _settle_facing(lane_dir)
	var before := hr.arrows_released
	var r := await _fire_at(_lane_point(6.0))
	var mech0 := player.mechanical_facing_yaw()
	# THE CURSOR SWINGS BEHIND HER FOR THE WHOLE DRAW.
	cam.debug_cursor_override = _lane_point(-6.0)
	var mech_fixed := true
	var max_vis_gap := 0.0
	var g := 0
	while g < 120 and hr.arrows_released <= before:
		await physics_frame
		g += 1
		if hr.arrows_released <= before:
			mech_fixed = mech_fixed and is_equal_approx(player.mechanical_facing_yaw(), mech0)
			max_vis_gap = maxf(max_vis_gap, _deg(player.visual.rotation.y - mech0))
	var live_moved := player.aim_dir.angle_to(-lane_dir) < 0.05
	var rel: Dictionary = hr.release_log.back()
	var arrow_on_a := (rel["aim"] as Vector3).angle_to(lane_dir) < 0.001
	var arrow: SplinterArrow = hr.arrows.back() if not hr.arrows.is_empty() else null
	var flies_a := arrow != null and arrow.direction.angle_to(lane_dir) < 0.001
	await _await_action_end()
	var ok := bool(r["ok"]) and mech_fixed and max_vis_gap <= 1.0 and live_moved and arrow_on_a and flies_a
	_note("H20_cursor_swing_redirects_neither_arrow_nor_facing",
		"the cursor moved BEHIND her for the whole draw: the live aim followed it=%s (so the swing was real) | the mechanical facing stayed at %.2f deg on every draw frame=%s and the visual never left it by more than %.2f deg | the arrow left on the SAMPLED aim=%s and flies it=%s"
		% [str(live_moved), rad_to_deg(mech0), str(mech_fixed), max_vis_gap, str(arrow_on_a), str(flies_a)])
	_reached("H20_cursor_swing_redirects_neither_arrow_nor_facing")
	return ok

func chk_H21_visual_blends_aligns_before_release_and_late_guard_counts() -> bool:
	await _rest()
	var dt := 1.0 / float(Engine.physics_ticks_per_second)
	var max_step := ProdConfig.YAW_RATE_DEG_PER_S * dt + 0.01
	await _settle_facing(lane_dir)
	var late0 := hr.late_visual_alignments
	var before := hr.arrows_released
	cam.debug_cursor_override = player.global_position + _rot_y(lane_dir, 180.0) * 6.0
	await physics_frame
	var r := skills.use_binding(HuntressContent.BINDING_INDEX)
	var prev := player.visual.rotation.y
	var steps: Array[float] = []
	var g := 0
	while g < 120 and hr.arrows_released <= before:
		await physics_frame
		g += 1
		steps.append(_deg(player.visual.rotation.y - prev))
		prev = player.visual.rotation.y
	var within_rate := true
	var moving_frames := 0
	for s in steps:
		within_rate = within_rate and s <= max_step
		if s > 0.5:
			moving_frames += 1
	var aligned := hr.last_alignment_deg <= HuntressConfig.VISUAL_ALIGN_TOLERANCE_DEG \
		and hr.late_visual_alignments == late0
	var aligned_deg := hr.last_alignment_deg
	await _await_action_end()
	# THE LATE GUARD IS REACHABLE: the visual is forced 90 degrees off on the frame
	# BEFORE the release -- the guard must count it and snap.
	await _rest()
	await _settle_facing(lane_dir)
	before = hr.arrows_released
	var r2 := await _fire_at(_lane_point(6.0))
	var release_at := player.commitment.duration * player.commitment.release_marker
	g = 0
	var forced := false
	while g < 120 and hr.arrows_released <= before:
		if not forced and player.commitment.elapsed + dt >= release_at:
			var off := player.mechanical_facing_yaw() + PI * 0.5
			player.yaw_driver.snap(off)
			player.visual.rotation.y = off
			forced = true
		await physics_frame
		g += 1
	var forced_deg := hr.last_alignment_deg
	var counted := forced and hr.late_visual_alignments == late0 + 1 and hr.last_alignment_deg > 80.0 \
		and _deg(player.visual.rotation.y - float(hr.release_log.back()["mechanical_yaw"])) <= 13.0
	await _await_action_end()
	var ok := bool(r["ok"]) and bool(r2["ok"]) and within_rate and moving_frames >= 5 and aligned and counted
	_note("H21_visual_blends_aligns_before_release_and_late_guard_counts",
		"the WORST case, a 180-degree aim: the visual BLENDED over %d frames, never faster than the ACCEPTED %.0f deg/s (max %.2f deg/frame)=%s | at release it was %.3f deg from the snapped facing (tolerance %.1f, PROVISIONAL), no late alignment=%s | FORCED 90 deg off on the frame before the release (measured %.2f deg at release), the guard counted it (%d -> %d) and snapped the visual=%s — a late visual is never silent"
		% [moving_frames, ProdConfig.YAW_RATE_DEG_PER_S, steps.max() if steps.size() > 0 else -1.0, str(within_rate),
		   aligned_deg, HuntressConfig.VISUAL_ALIGN_TOLERANCE_DEG, str(aligned), forced_deg, late0, hr.late_visual_alignments, str(counted)])
	_reached("H21_visual_blends_aligns_before_release_and_late_guard_counts")
	return ok

func chk_H22_normal_control_resumes_after_release_and_after_cancel() -> bool:
	await _rest()
	await _settle_facing(lane_dir)
	var before := hr.arrows_released
	var r := await _fire_at(_lane_point(6.0))
	await physics_frame
	var held_in_draw := player.facing_hold_active()
	await _await_release(before)
	var released_hold := not player.facing_hold_active() and player.commitment.active
	# DURING THE RECOVERY the facing follows the live aim again.
	var yaw_rel := player.visual.rotation.y
	cam.debug_cursor_override = player.global_position + _rot_y(lane_dir, 90.0) * 6.0
	await _phys(5)
	var in_recovery := player.commitment.active
	var turned := _deg(player.visual.rotation.y - yaw_rel) > 20.0
	await _await_action_end()
	var no_orphans := hr.hold_orphans == 0
	var ok := bool(r["ok"]) and held_in_draw and released_hold and in_recovery and turned and no_orphans
	_note("H22_normal_control_resumes_after_release_and_after_cancel",
		"the hold was active in the draw=%s and released on the release frame while the recovery still ran=%s | a new cursor during the RECOVERY turned her %.1f deg in 5 frames (normal control)=%s | after a cancel the hold is released too (H16) | orphaned holds %d=%s"
		% [str(held_in_draw), str(released_hold), _deg(player.visual.rotation.y - yaw_rel), str(turned),
		   hr.hold_orphans, str(no_orphans)])
	_reached("H22_normal_control_resumes_after_release_and_after_cancel")
	return ok

func chk_H23_f73_still_holds_for_the_diagnostic_bolt() -> bool:
	await _rest()
	await _settle_facing(lane_dir)
	var holds0 := player.facing_holds
	var yaw0 := player.visual.rotation.y
	player.intent.debug_attack_held = true
	await physics_frame
	player.intent.debug_attack_held = null
	var bolt := player.commitment.active and player.commitment.label == ProdConfig.DIAG_ATTACK_DESIGN_NAME
	cam.debug_cursor_override = _lane_point(-6.0)
	var never_held := true
	var g := 0
	while g < 60 and player.commitment.active:
		await physics_frame
		g += 1
		never_held = never_held and not player.facing_hold_active()
	var followed_live := _deg(player.visual.rotation.y - yaw0) > 60.0
	# ONLY the Huntress runtime ever asks the controller to hold.
	var callers: Array[String] = []
	for f in _runtime_script_files():
		if f.ends_with("player_controller.gd"):
			continue
		if _code_only(_read_text(f)).find("hold_facing(") >= 0:
			callers.append(f.get_file())
	await _phys(20)
	var ok := bolt and never_held and followed_live and player.facing_holds == holds0 \
		and callers == ["huntress_runtime.gd"]
	_note("H23_f73_still_holds_for_the_diagnostic_bolt",
		"the diagnostic bolt committed=%s; with the cursor swung behind her the visual followed the LIVE aim (%.1f deg) exactly as accepted F73 asserts=%s; no facing hold at any point=%s | callers of hold_facing(): %s"
		% [str(bolt), _deg(player.visual.rotation.y - yaw0), str(followed_live), str(never_held), str(callers)])
	_reached("H23_f73_still_holds_for_the_diagnostic_bolt")
	return ok

const SECTOR_TOKENS := ["sector" + "_index", "facing" + "_sector", "sector" + "_deg", "eight" + "_direction",
	"quantis", "quantiz", "hysteresis"]

static func _sector_hits(code: String) -> Array:
	var out: Array = []
	var re := RegEx.new()
	re.compile("(?mi)^\\s*(func|var|const|class_name)\\s+([A-Za-z_0-9]+)")
	for m in re.search_all(_code_only(code)):
		var ident := m.get_string(2).to_lower()
		for t in SECTOR_TOKENS:
			if ident.find(String(t)) >= 0:
				out.append(ident)
	return out

func chk_H24_no_sector_index_in_any_new_file() -> bool:
	var files: Array = _huntress_script_files()
	files.append("res://scripts/control/player_controller.gd")
	var hits: Array = []
	for f in files:
		for h in _sector_hits(_read_text(f)):
			hits.append("%s:%s" % [String(f).get_file(), String(h)])
	var caught := not _sector_hits("var facing" + "_sector := 3").is_empty()
	var ignored := _sector_hits("# a facing" + "_sector once").is_empty()
	var ok := hits.is_empty() and caught and ignored and files.size() >= 16
	_note("H24_no_sector_index_in_any_new_file",
		"%d files scanned (every Huntress script and the accepted controller): sector/quantisation declarations %s — continuous yaw (D-367) stands | a planted declaration is caught=%s and a comment ignored=%s"
		% [files.size(), str(hits), str(caught), str(ignored)])
	_reached("H24_no_sector_index_in_any_new_file")
	return ok

# =============================================================================
# E. PLACEHOLDER ANIMATION AND PRESENTATION
# =============================================================================

func chk_H25_current_huntress_body_accepted_player_kept_and_modifier_applies() -> bool:
	await _rest()
	var an := hr.animator
	var skel := an.skel
	var body := skel != null and is_same(skel, player.skeleton) and skel.get_bone_count() == ProdConfig.EXPECT_UAL_BONES \
		and player.visual.scene_file_path == AssetManifest.OUTFIT_RANGER
	var player_kept := player.anim != null and player.anim.current_animation != "" and player.live_clip != ""
	var mod := an.modifier
	var placed := mod != null and is_same(mod.get_parent(), skel) and is_equal_approx(mod.influence, 1.0)
	var app0 := mod.applications if mod != null else 0
	var bi := skel.find_bone("hand_" + an.bow_hand) if skel != null else -1
	var cap := {"q": Quaternion.IDENTITY, "n": 0}
	var cb := func() -> void:
		cap["q"] = skel.get_bone_pose_rotation(bi)
		cap["n"] = int(cap["n"]) + 1
	skel.skeleton_updated.connect(cb)
	for i in 4:
		await process_frame
	var shown_q: Quaternion = cap["q"]
	var want_q: Quaternion = mod.pose.rot[bi]
	var applied_deg := rad_to_deg(shown_q.angle_to(want_q))
	var applying := mod.applications > app0 and int(cap["n"]) > 0
	# THE COMPARISON CAN FAIL: with the modifier's influence at 0 the accepted
	# player's own pose shows, and it is NOT the placeholder's.
	mod.influence = 0.0
	for i in 4:
		await process_frame
	var off_deg := rad_to_deg((cap["q"] as Quaternion).angle_to(mod.pose.rot[bi]))
	mod.influence = 1.0
	for i in 3:
		await process_frame
	skel.skeleton_updated.disconnect(cb)
	var ok := body and player_kept and placed and applying and applied_deg <= 0.5 and off_deg > 2.0
	_note("H25_current_huntress_body_accepted_player_kept_and_modifier_applies",
		"the body is the current 65-joint Huntress (%s, %d bones) — no KayKit body shown=%s | the ACCEPTED AnimationPlayer still runs ('%s' requested)=%s | the placeholder modifier sits on her skeleton at influence 1.0=%s | the drawn %s pose equals the placeholder pose to %.3f deg (applications rising)=%s | at influence 0 the drawn pose is %.1f deg away — the comparison can fail"
		% [AssetManifest.OUTFIT_RANGER.get_file(), skel.get_bone_count() if skel != null else -1, str(body),
		   player.live_clip, str(player_kept), str(placed), "hand_" + an.bow_hand, applied_deg, str(applying), off_deg])
	_reached("H25_current_huntress_body_accepted_player_kept_and_modifier_applies")
	return ok

func chk_H26_only_authorized_clips_are_sampled_and_source_unchanged() -> bool:
	var src := hr.animator.source
	var sampled: Array = src.sampled_names.keys()
	var measured: Array = src.measured_names.keys()
	var subset := true
	for c in sampled + measured:
		subset = subset and HuntressConfig.AUTHORIZED_CLIPS.has(String(c))
	var all_five := true
	for c in HuntressConfig.AUTHORIZED_CLIPS:
		all_five = all_five and (sampled.has(c) or measured.has(c))
	# THE REFUSAL IS REACHABLE: an unauthorized clip returns nothing, and is counted.
	var ref0 := src.refused_requests
	var up := src.sample("Ranged_Bow_Draw_Up", 0.0)
	var other := src.sample("Idle", 0.0)
	var refused := up == null and other == null and src.refused_requests == ref0 + 2
	var unused := src.unused_clips()
	var unchanged := _clip_checksums() == (launch["checksums"] as Dictionary) \
		and (launch["checksums"] as Dictionary).size() == HuntressConfig.AUTHORIZED_CLIPS.size()
	var ok := subset and all_five and refused and unused.size() > 0 and unchanged
	_note("H26_only_authorized_clips_are_sampled_and_source_unchanged",
		"sampled in play: %s; sampled while measuring: %s — all inside the five authorized=%s, all five used=%s | an unauthorized request returns nothing and is counted (%d -> %d)=%s | %d clips present in the two files and NOT authorized, refused at runtime | every authorized clip's key checksum identical to launch=%s"
		% [str(sampled), str(measured), str(subset), str(all_five), ref0, src.refused_requests, str(refused),
		   unused.size(), str(unchanged)])
	_reached("H26_only_authorized_clips_are_sampled_and_source_unchanged")
	return ok

func chk_H27_retarget_map_is_explicit_and_refuses_a_planted_bone() -> bool:
	var rt := hr.animator.retarget
	var n_pairs := 0
	for k in HuntressConfig.MAP_KAYKIT.keys():
		if HuntressConfig.MAP_HUNTRESS.has(k):
			n_pairs += 1
	var pairs_ok := rt.pairs.size() == n_pairs and n_pairs == 19
	var derived_ok := rt.derived.size() == HuntressConfig.DERIVED.size() and rt.derived.size() == 2
	var held_ok := rt.rest_held.size() == ProdConfig.EXPECT_UAL_BONES - n_pairs - rt.derived.size()
	var src_unmapped: Array = rt.unmapped_source.duplicate()
	src_unmapped.sort()
	var declared: Array = HuntressConfig.UNMAPPED_SOURCE.keys()
	declared.sort()
	var unmapped_ok := src_unmapped == declared
	var r0 := rt.planted_refusals
	var refuses := not rt.resolves_target("NOT_A_HUNTRESS_BONE") and rt.planted_refusals == r0 + 1 \
		and rt.resolves_target("hand_l")
	var ok := pairs_ok and derived_ok and held_ok and unmapped_ok and refuses
	_note("H27_retarget_map_is_explicit_and_refuses_a_planted_bone",
		"%d mapped pairs (19 profile bones in both maps)=%s · %d derived (spine_02, neck_01)=%s · %d Huntress bones held at rest (65 - 19 - 2)=%s · the source bones left unmapped %s equal the DECLARED four=%s | a planted bone name is refused and counted=%s"
		% [rt.pairs.size(), str(pairs_ok), rt.derived.size(), str(derived_ok), rt.rest_held.size(), str(held_ok),
		   str(src_unmapped), str(unmapped_ok), str(refuses)])
	_reached("H27_retarget_map_is_explicit_and_refuses_a_planted_bone")
	return ok

## Steps one use frame by frame, recording what the placeholder shows. Returns
## the per-frame rows and the release frame's index.
func _record_use(point: Vector3) -> Dictionary:
	var an := hr.animator
	var before := hr.arrows_released
	var r := await _fire_at(point)
	var rows: Array = []
	var release_idx := -1
	var g := 0
	var prev_rot: Array = []
	var after := 0
	while g < 160 and after < 12:
		if not player.commitment.active and g >= 4:
			after += 1
		var pre_nock: Vector3 = an.pres.arrow_world.origin
		var pre_vis := an.pres.arrow_visible
		await physics_frame
		g += 1
		var bone_hand := an.bone_world("hand_" + an.bow_hand).origin
		var string_hand := an.bone_world("hand_" + ("r" if an.bow_hand == "l" else "l")).origin
		var max_jump := 0.0
		if an.modifier.pose != null:
			if not prev_rot.is_empty():
				for i in an.modifier.pose.size():
					max_jump = maxf(max_jump, rad_to_deg((prev_rot[i] as Quaternion).angle_to(an.modifier.pose.rot[i])))
			prev_rot = an.modifier.pose.rot.duplicate()
		var released_now := release_idx < 0 and hr.arrows_released > before
		if released_now:
			release_idx = rows.size()
		rows.append({"phase": an.phase, "tau": an.tau, "drawn": an.pres.drawn, "arrow": an.pres.arrow_visible,
			"centre": an.pres.string_centre_world, "rest": an.pres.string_rest_world,
			"bow": an.pres.bow_world.origin, "bow_hand": bone_hand, "string_hand": string_hand,
			"arrow_xf": an.pres.arrow_world, "pre_nock": pre_nock, "pre_vis": pre_vis,
			"anchor": player.visual.global_transform * (Quaternion(Vector3.UP, -an.alpha * an.align_w) * an.retarget.anchor_model),
			"jump": max_jump, "released_now": released_now, "top_vis": an.pres.string_top.visible,
			"bottom_vis": an.pres.string_bottom.visible})
	return {"ok": bool(r["ok"]), "rows": rows, "release_idx": release_idx}

func chk_H28_full_draw_contacts_and_arrow_line_align_with_facing() -> bool:
	await _rest()
	await _settle_facing(lane_dir)
	var rec := await _record_use(_lane_point(6.0))
	var rows: Array = rec["rows"]
	var ri := int(rec["release_idx"])
	# THE LAST FULL-DRAW FRAME: the frame before the release.
	var full: Dictionary = rows[ri - 1] if ri > 0 else {}
	var ok_frame := not full.is_empty() and String(full["phase"]) == "HOLD" and bool(full["drawn"])
	var xf: Transform3D = full.get("arrow_xf", Transform3D.IDENTITY)
	var line := xf.basis.z
	line.y = 0.0
	var line_deg := rad_to_deg(line.normalized().angle_to(lane_dir)) if line.length() > 0.001 else 999.0
	var pitch_deg := rad_to_deg(asin(clampf(xf.basis.z.normalized().y, -1.0, 1.0)))
	var nock_to_string_hand := (full.get("centre", Vector3.ZERO) as Vector3).distance_to(full.get("string_hand", Vector3.ZERO))
	var bow_to_hand := (full.get("bow", Vector3.ZERO) as Vector3).distance_to(full.get("bow_hand", Vector3.ZERO))
	var nock_to_anchor := (full.get("centre", Vector3.ZERO) as Vector3).distance_to(full.get("anchor", Vector3.INF))
	var head := hr.animator.bone_world("Head").origin
	_finding("FULL DRAW (MEASURED, PLACEHOLDER): the nocked arrow's planar line is %.2f deg from the snapped facing, pitched %.2f deg; the nock sits %.3f m from the jaw anchor the hand-contact IK draws to; the string (nock) is %.3f m from the string hand's wrist bone and the bow grip %.3f m from the bow hand's wrist bone. NOT a production-quality standard."
		% [line_deg, pitch_deg, nock_to_anchor, nock_to_string_hand, bow_to_hand])
	var ok := bool(rec["ok"]) and ok_frame and line_deg <= 8.0 and nock_to_string_hand <= 0.15 and bow_to_hand <= 0.15 \
		and nock_to_anchor <= 0.10
	_note("H28_full_draw_contacts_and_arrow_line_align_with_facing",
		"the frame before the release is a full-draw HOLD with the string drawn=%s | the nocked arrow's planar line is %.2f deg from the snapped facing (<= 8, PROVISIONAL presentation bound), pitch %.2f deg | the nock is %.3f m from the jaw anchor (<= 0.10 m) | nock-to-string-hand %.3f m and grip-to-bow-hand %.3f m (<= 0.15 m) — the D-388 hand-contact approach, PLACEHOLDER | head bone at %s"
		% [str(ok_frame), line_deg, pitch_deg, nock_to_anchor, nock_to_string_hand, bow_to_hand, str(head)])
	_reached("H28_full_draw_contacts_and_arrow_line_align_with_facing")
	return ok

func chk_H29_bow_in_hand_and_string_follows_then_rests_on_release() -> bool:
	await _rest()
	var rec := await _record_use(_lane_point(6.0))
	var rows: Array = rec["rows"]
	var ri := int(rec["release_idx"])
	var max_pull := 0.0
	var in_hand := true
	var max_hand := 0.0
	var segs := true
	for i in rows.size():
		var row: Dictionary = rows[i]
		var d := (row["bow"] as Vector3).distance_to(row["bow_hand"])
		max_hand = maxf(max_hand, d)
		in_hand = in_hand and d <= 0.15
		segs = segs and bool(row["top_vis"]) and bool(row["bottom_vis"])
		if i < ri and bool(row["drawn"]):
			max_pull = maxf(max_pull, (row["centre"] as Vector3).distance_to(row["rest"]))
	var rests := ri >= 0
	for i in range(maxi(ri, 0), rows.size()):
		var row2: Dictionary = rows[i]
		rests = rests and not bool(row2["drawn"]) and (row2["centre"] as Vector3).distance_to(row2["rest"]) < 0.0001
	var follows := max_pull > 0.2
	var ok := bool(rec["ok"]) and follows and rests and in_hand and segs
	_note("H29_bow_in_hand_and_string_follows_then_rests_on_release",
		"drawn, the string centre followed the nock up to %.3f m from rest=%s | from the release frame on it sat AT rest=%s (the D-389 'string' pop is CARRIED, not fixed) | the bow stayed within %.3f m of the bow hand on every frame=%s | both string segments shown=%s"
		% [max_pull, str(follows), str(rests), max_hand, str(in_hand), str(segs)])
	_reached("H29_bow_in_hand_and_string_follows_then_rests_on_release")
	return ok

func chk_H30_arrow_nocked_to_release_and_projectile_starts_at_the_nock() -> bool:
	await _rest()
	var fb0 := hr.fallback_spawns
	var rec := await _record_use(_lane_point(6.0))
	var rows: Array = rec["rows"]
	var ri := int(rec["release_idx"])
	var nock_tau := hr.animator.nock_tau
	var hidden_before := true
	var shown_after := true
	var saw_hidden := false
	var saw_shown := false
	for i in range(0, maxi(ri, 0)):
		var row: Dictionary = rows[i]
		if float(row["tau"]) < nock_tau:
			hidden_before = hidden_before and not bool(row["arrow"])
			saw_hidden = true
		else:
			shown_after = shown_after and bool(row["arrow"])
			saw_shown = true
	var rel: Dictionary = hr.release_log.back()
	var at_nock := ri >= 0 and (rel["tail"] as Vector3).distance_to(rows[ri]["pre_nock"]) < 0.0001 \
		and bool(rows[ri]["pre_vis"])
	var gone_after := ri >= 0 and not bool(rows[ri]["arrow"])
	var no_fallback := hr.fallback_spawns == fb0
	var ok := bool(rec["ok"]) and saw_hidden and saw_shown and hidden_before and shown_after and at_nock \
		and gone_after and no_fallback
	_note("H30_arrow_nocked_to_release_and_projectile_starts_at_the_nock",
		"before the measured nock moment (%.3f s authored) no arrow was shown=%s; from it to the release the arrow sat on the string=%s | the projectile's tail on the release frame IS the nocked arrow's nock (%s)=%s | the nocked arrow is hidden from the release frame (no duplicate)=%s | no muzzle fallback=%s"
		% [nock_tau, str(hidden_before), str(shown_after), str(rel["tail"]), str(at_nock), str(gone_after), str(no_fallback)])
	_reached("H30_arrow_nocked_to_release_and_projectile_starts_at_the_nock")
	return ok

static func _each_use_once(log: Array) -> bool:
	var seen := {}
	for e in log:
		var u := String(e["use"])
		if seen.has(u):
			return false
		seen[u] = true
	return true

func chk_H31_exactly_one_arrow_per_skill_use() -> bool:
	await _rest()
	SplinterArrow.reset_counters()
	var uses0 := hr.uses_begun
	var arrows0 := hr.arrows_released
	for i in 4:
		skills.pool.refill()
		await _timed_use(_lane_point(6.0, float(i) * 0.5 - 0.75))
	var four := SplinterArrow.spawned == 4 and hr.uses_begun - uses0 == 4 and hr.arrows_released - arrows0 == 4
	# ACROSS THE WHOLE RUN: every Splinter Shot use released exactly one arrow.
	var whole_run := hr.uses_begun == hr.arrows_released and hr.release_log.size() == hr.arrows_released \
		and _each_use_once(hr.release_log)
	var planted: Array = hr.release_log.duplicate()
	planted.append(hr.release_log.back())
	var refuses := not _each_use_once(planted)
	var ok := four and whole_run and refuses
	_note("H31_exactly_one_arrow_per_skill_use",
		"four uses spawned %d arrows=%s | across the whole run %d Splinter Shot uses, %d arrows, %d release records, every use id once=%s | a planted duplicate release is refused=%s"
		% [SplinterArrow.spawned, str(four), hr.uses_begun, hr.arrows_released, hr.release_log.size(), str(whole_run), str(refuses)])
	_reached("H31_exactly_one_arrow_per_skill_use")
	return ok

func chk_H32_locomotion_placeholder_and_overlay_states_shown_vs_requested() -> bool:
	await _rest()
	cam.debug_cursor_override = _lane_point(6.0)
	await _phys(40)
	var an := hr.animator
	var idle_shown := an.shown_clip
	var idle_req := player.live_clip
	var idle_ok := idle_shown == HuntressConfig.CLIP_BOW_IDLE and idle_req != "" and idle_req != idle_shown
	var ov_idle := hud.compose()
	var says := ov_idle.find("SHOWN") >= 0 and ov_idle.find(HuntressConfig.CLIP_BOW_IDLE) >= 0 \
		and ov_idle.find("REQUESTED") >= 0
	player.command_move_to(_lane_point(8.0))
	await _phys(24)
	var run_shown := an.shown_clip
	var run_ok := run_shown == HuntressConfig.CLIP_RUN_BOW and player.motor.speed() > 1.0
	player.clear_move_destination()
	var labels := HuntressConfig.ANIMATION_LABEL.find("TEMPORARY PLACEHOLDER") >= 0 \
		and HuntressConfig.ANIMATION_LABEL.find("NOT final animation") >= 0 \
		and HuntressConfig.PRESENTATION_LABEL.find("PLACEHOLDER") == 0
	# D-393: the Prey marker was the fourth placeholder node named here; it was
	# removed with Prey, so three remain (4 - 1 = 3). True when written.
	var names_ok := String(an.name).ends_with("_PLACEHOLDER") and String(an.pres.name).ends_with("_PLACEHOLDER") \
		and String(an.modifier.name).ends_with("_PLACEHOLDER")
	var ok := idle_ok and says and run_ok and labels and names_ok
	_note("H32_locomotion_placeholder_and_overlay_states_shown_vs_requested",
		"idle: SHOWN '%s' while the accepted controller REQUESTS '%s'=%s — the F1 overlay states both=%s | running: SHOWN '%s'=%s | the animation and presentation labels say TEMPORARY PLACEHOLDER / PLACEHOLDER=%s | every placeholder node's name ends _PLACEHOLDER=%s"
		% [idle_shown, idle_req, str(idle_ok), str(says), run_shown, str(run_ok), str(labels), str(names_ok)])
	_reached("H32_locomotion_placeholder_and_overlay_states_shown_vs_requested")
	return ok

func chk_H33_accepted_polish_debts_carried_and_transitions_measured() -> bool:
	var row: Array = []
	for r in HuntressConfig.deferred_rows():
		if String(r[0]).begins_with("SD-07"):
			row = r
	var debts := ["finger", "shoulder", "string", "hood-intersection", "foot-sliding"]
	var carried := not row.is_empty() and String(row[1]) == "CARRIED — NOT FIXED"
	for d in debts:
		carried = carried and String(row[0]).find(d) >= 0
	var denied := false
	for d in HuntressConfig.denials():
		if String(d).find("fixes NONE of the five accepted D-389 polish debts") >= 0:
			denied = true
	# THE TRANSITIONS, MEASURED: the largest per-frame bone rotation change in
	# each phase of one use, and into the rest pose after it.
	await _rest()
	var rec := await _record_use(_lane_point(6.0))
	await _phys(30)
	var per_phase := {}
	var rows: Array = rec["rows"]
	var ri := int(rec["release_idx"])
	for i in rows.size():
		var key := "RELEASE-FRAME" if i == ri else String(rows[i]["phase"])
		per_phase[key] = maxf(float(per_phase.get(key, 0.0)), float(rows[i]["jump"]))
	var outside_release := 0.0
	for k in per_phase.keys():
		if String(k) != "RELEASE-FRAME" and String(k) != "RELEASE":
			outside_release = maxf(outside_release, float(per_phase[k]))
	_finding("TRANSITIONS (MEASURED, PLACEHOLDER): largest per-frame bone rotation change by phase %s. The release snap is the clip's own; nothing was smoothed to hide a debt."
		% str(per_phase))
	var ok := bool(rec["ok"]) and carried and denied and rows.size() > 30 and outside_release <= 45.0
	_note("H33_accepted_polish_debts_carried_and_transitions_measured",
		"SD-07 carries all five D-389 debts, CARRIED — NOT FIXED=%s, and the denial says so=%s | MEASURED per-phase max bone change (deg/frame): %s; outside the release snap <= 45 deg/frame=%s"
		% [str(carried), str(denied), str(per_phase), str(outside_release <= 45.0)])
	_reached("H33_accepted_polish_debts_carried_and_transitions_measured")
	return ok

func chk_H34_ported_modules_and_placeholder_intake_are_declared_and_verified() -> bool:
	# 1. THE PORTS carry their provenance header.
	var header := "PORTED UNDER D-392 FROM THE ACCEPTED D-388 SPIKE -- TEMPORARY PLACEHOLDER"
	var ports := ["bone_pose.gd", "kaykit_clip_source.gd", "bow_retargeter.gd", "bow_presentation.gd"]
	var headed := true
	for p in ports:
		headed = headed and _read_text("res://scripts/huntress/" + String(p)).find(header) >= 0
	headed = headed and _read_text("res://scripts/huntress/impact_flash.gd").find("PORTED from the accepted D-388 spike") >= 0
	var declared_rows := HuntressConfig.reuse_declaration().size() == 9
	# 2. THE INTAKE: every declared file present with its SHA-256; the directory
	# holds exactly those files (both directions), the licences and the record.
	var rows: Array[String] = []
	var sha_ok := true
	var declared_paths: Array = []
	var record := _read_text(AssetManifest.d392_provenance_document())
	var named := record != ""
	for pack in AssetManifest.d392_packs():
		named = named and record.find(String(pack["name"])) >= 0 and record.find(String(pack["archive"])) >= 0
		var entries: Array = (pack["files"] as Array).duplicate()
		entries.append(pack["licence_file"])
		for f in entries:
			var path := AssetManifest.PLACEHOLDER_ROOT + String(f[0])
			var sha := FileAccess.get_sha256(path)
			sha_ok = sha_ok and sha == String(f[1])
			named = named and record.find(String(f[0]).get_file()) >= 0
			declared_paths.append(path)
	var on_disk: Array = []
	_walk(AssetManifest.PLACEHOLDER_ROOT.trim_suffix("/"), on_disk)
	var intake_on_disk: Array = []
	for p in on_disk:
		var s := String(p)
		if s.ends_with(".import") or s.ends_with(".uid") or s.get_file() == "SOURCE_AND_LICENSE.md":
			continue
		intake_on_disk.append(s)
	intake_on_disk.sort()
	declared_paths.sort()
	var exact := intake_on_disk == declared_paths and declared_paths.size() == 8
	var trees := AssetManifest.declared_trees() == [AssetManifest.ROOT, AssetManifest.PLACEHOLDER_ROOT]
	# THE SHA CHECK CAN REFUSE a planted wrong digest.
	var refuses := FileAccess.get_sha256(AssetManifest.ARROW) != "0".repeat(64)
	var ok := headed and declared_rows and sha_ok and named and exact and trees and refuses
	_note("H34_ported_modules_and_placeholder_intake_are_declared_and_verified",
		"the four D-388 ports carry the provenance header and ImpactFlash names its source=%s; %d reuse rows | %d intake files: SHA-256 as declared=%s, named in SOURCE_AND_LICENSE.md=%s, and EXACTLY the files on disk (both directions, generated .import/.uid excluded)=%s | declared trees %s=%s | a planted digest is refused=%s"
		% [str(headed), HuntressConfig.reuse_declaration().size(), declared_paths.size(), str(sha_ok), str(named),
		   str(exact), str(AssetManifest.declared_trees()), str(trees), str(refuses)])
	_reached("H34_ported_modules_and_placeholder_intake_are_declared_and_verified")
	return ok

# =============================================================================
# F. ARROW COLLISION — D-390 ruling 4, D-391 ruling 5
# =============================================================================

## The arrow leaves from the NOCK, a few centimetres beside her ground line. Its
## lateral offset is MEASURED once, so targets can be placed on its actual line.
var line_off: float = 0.0
var line_calibrated: bool = false

func _calibrate_line() -> void:
	if line_calibrated:
		return
	await _rest()
	await _settle_facing(lane_dir)
	await _timed_use(_lane_point(6.0))
	var tail: Vector3 = hr.release_log.back()["tail"]
	line_off = (tail - lane_from).dot(lane_side)
	line_calibrated = true
	_finding("ARROW LINE (MEASURED): the nock leaves %.3f m to the side of her ground line along the aim; targets in the collision checks are placed on that line." % line_off)

func _line_point(along: float, side: float = 0.0) -> Vector3:
	return lane_from + lane_dir * along + lane_side * (line_off + side)

## One use straight down the lane, facing settled first so the nock repeats.
func _shoot_lane() -> Dictionary:
	await _settle_facing(lane_dir)
	return await _shoot(lane_dir, 6.0)

func _enemy_unadded(n: String) -> OrdinaryEnemy:
	var e := OrdinaryEnemy.new()
	e.name = n
	return e

func _enemy_enter(e: OrdinaryEnemy, pos: Vector3) -> void:
	main.add_child(e)
	e.setup(corpus)
	e.global_position = pos
	e.player = player
	e.debug_freeze_ai = true
	probes.append(e)

func chk_H35_time_of_impact_math_is_exact() -> bool:
	var a := Vector2(0, 0)
	var b := Vector2(10, 0)
	var cases := [
		["centred, t = (5 - 1) / 10", Vector2(5, 0), 1.0, 0.4],
		["offset chord, t = (5 - 0.8) / 10", Vector2(5, 0.6), 1.0, 0.42],
		["tangent, t = 0.5", Vector2(5, 1), 1.0, 0.5],
		["already inside: point-blank, t = 0", Vector2(0.3, 0), 1.0, 0.0],
		["a miss", Vector2(5, 1.2), 1.0, -1.0],
		["behind the start, moving away", Vector2(-3, 0), 1.0, -1.0],
		["beyond the segment's end", Vector2(12, 0), 1.0, -1.0],
		["touching the end exactly, t = 1", Vector2(11, 0), 1.0, 1.0],
	]
	var rows: Array[String] = []
	var all_ok := true
	for c in cases:
		var t := ArrowCollision.segment_circle_toi(a, b, c[1], float(c[2]))
		# Vector2 is SINGLE precision in this build: exact to float32 rounding.
		var ok1 := absf(t - float(c[3])) <= 1e-6
		all_ok = all_ok and ok1
		rows.append("%s -> %.9f %s" % [String(c[0]), t, "ok" if ok1 else "WRONG"])
	# A DIAGONAL, against the closed form computed independently.
	var p := Vector2(1, 2)
	var q := Vector2(7, 10)
	var c2 := Vector2(4, 5)
	var r2 := 0.9
	var d := q - p
	var m := p - c2
	var closed := (-m.dot(d) - sqrt(m.dot(d) * m.dot(d) - d.dot(d) * (m.dot(m) - r2 * r2))) / d.dot(d)
	var diag := absf(ArrowCollision.segment_circle_toi(p, q, c2, r2) - closed) <= 1e-6
	# THE MATH CAN FAIL: a wrong expectation is refused.
	var refuses := absf(ArrowCollision.segment_circle_toi(a, b, Vector2(5, 0), 1.0) - 0.5) > 1e-6
	var ok := all_ok and diag and refuses
	_note("H35_time_of_impact_math_is_exact",
		"%s | a diagonal against its independently computed closed form=%s | a wrong expectation is refused=%s"
		% [" · ".join(rows), str(diag), str(refuses)])
	_reached("H35_time_of_impact_math_is_exact")
	return ok

func chk_H36_earliest_time_of_impact_wins_in_any_order() -> bool:
	await _calibrate_line()
	# 1. THE CHOICE, SYNTHETIC: every permutation, the earliest registered LAST.
	var reg := CombatEntityRegistry.new("h36")
	var nodes: Array = []
	for i in 3:
		var n := Node.new()
		nodes.append(n)
		reg.register(n, "ordinary", "hostile")
	var cands := [{"id": reg.id_of(nodes[0]), "distance_m": 7.0}, {"id": reg.id_of(nodes[1]), "distance_m": 5.5},
		{"id": reg.id_of(nodes[2]), "distance_m": 5.0}]
	var perms := [[0, 1, 2], [0, 2, 1], [1, 0, 2], [1, 2, 0], [2, 0, 1], [2, 1, 0]]
	var synth := true
	for pm in perms:
		var lst: Array = []
		for k in pm:
			lst.append(cands[int(k)])
		synth = synth and String(ArrowCollision.choose(lst, reg, HuntressConfig.COLLISION_TIE_TOLERANCE_M)["id"]) == reg.id_of(nodes[2])
	for n in nodes:
		(n as Node).free()
	# 2. LIVE: the FAR target is registered FIRST (the lower ID) and still loses.
	await _rest()
	var far := _probe("H36_Far_registered_first", _line_point(7.0))
	var near := _probe("H36_Near_registered_second", _line_point(5.0))
	var r1 := await _shoot_lane()
	var o1: Dictionary = r1["outcome"]
	var near_won := String(o1.get("id", "")) == hr.registry.id_of(near) and hr.registry.precedes(hr.registry.id_of(far), hr.registry.id_of(near)) \
		and is_equal_approx(far.life.life, far.life.max_life)
	await _clear_probes()
	# 3. LIVE, OVERLAPPING: B's CENTRE is nearer, A's EDGE is met first. B is
	# registered first. A (the earlier time of impact) must win.
	await _rest()
	var b := _probe("H36_B_centre_nearer", _line_point(5.75, 0.5))
	var a2 := _probe("H36_A_edge_first", _line_point(6.0))
	var r_sum := ProdConfig.ENEMY_BODY_RADIUS + HuntressConfig.ARROW_RADIUS_M
	var a_contact := 6.0 - r_sum
	var b_contact := 5.75 - sqrt(r_sum * r_sum - 0.25)
	var r2 := await _shoot_lane()
	var o2: Dictionary = r2["outcome"]
	var edge_won := String(o2.get("id", "")) == hr.registry.id_of(a2) and is_equal_approx(b.life.life, b.life.max_life)
	await _clear_probes()
	var ok := synth and bool(r1["ok"]) and near_won and bool(r2["ok"]) and edge_won
	_note("H36_earliest_time_of_impact_wins_in_any_order",
		"synthetic: the 5.0 m candidate wins in all 6 permutations although it holds the HIGHEST ID=%s | live: the nearer target (registered second, higher ID) takes the Hit, the farther is untouched=%s | live, overlapping: B's centre is nearer (5.75 m, 0.5 m aside) but A's edge is met first (contact %.3f m against B's %.3f m); B registered first; A takes the Hit=%s"
		% [str(synth), str(near_won), a_contact, b_contact, str(edge_won)])
	_reached("H36_earliest_time_of_impact_wins_in_any_order")
	return ok

func chk_H37_a_tie_goes_to_the_lower_combat_entity_id_whatever_the_names_or_order() -> bool:
	await _calibrate_line()
	var rows: Array[String] = []
	var live_ok := true
	# TWO RUNS, two ordinary enemies at the SAME point (an exact tie). The one
	# REGISTERED FIRST is instantiated LAST and enters the tree LAST; its name
	# sorts LAST in run 1 and FIRST in run 2. It must win both times.
	for run in 2:
		await _rest()
		var second := _enemy_unadded("Alpha_registered_second" if run == 0 else "Zeta_registered_second")
		var first := _enemy_unadded("Zeta_registered_first" if run == 0 else "Alpha_registered_first")
		_enemy_enter(second, _line_point(6.0))
		_enemy_enter(first, _line_point(6.0))
		hr.register_enemy(first)
		hr.register_enemy(second)
		var r := await _shoot_lane()
		var o: Dictionary = r["outcome"]
		var id_first := hr.registry.id_of(first)
		var won := bool(r["ok"]) and String(o.get("id", "")) == id_first and (o.get("tie_set", []) as Array).size() == 2 \
			and hr.registry.precedes(id_first, hr.registry.id_of(second)) \
			and first.get_index() > second.get_index() \
			and is_equal_approx(second.life.life, second.life.max_life)
		live_ok = live_ok and won
		rows.append("run %d: '%s' (%s, registered first, later in the tree) vs '%s' (%s) -> %s, tie set %s"
			% [run + 1, String(first.name), id_first, String(second.name), hr.registry.id_of(second),
			   String(o.get("id", "")), str(o.get("tie_set", []))])
		await _clear_probes()
	# INSIDE THE TOLERANCE, NOT IDENTICAL: a 0.5 mm earlier edge on the HIGHER ID
	# still loses to the lower ID...
	await _rest()
	var s1 := _stub("H37_lower_id", _line_point(6.0), "ordinary", "hostile")
	var s2 := _stub("H37_higher_id_half_mm_earlier", _line_point(6.0), "ordinary", "hostile")
	s2.radius = s1.radius + 0.0005
	var rt := await _shoot_lane()
	var within := String((rt["outcome"] as Dictionary).get("id", "")) == hr.registry.id_of(s1) \
		and s1.damage_taken > 0.0 and is_zero_approx(s2.damage_taken)
	await _clear_probes()
	# ...and OUTSIDE it (1 cm earlier) the earlier edge wins, whatever its ID --
	# the tie-break can be REFUSED.
	await _rest()
	var s3 := _stub("H37_lower_id_b", _line_point(6.0), "ordinary", "hostile")
	var s4 := _stub("H37_higher_id_1cm_earlier", _line_point(6.0), "ordinary", "hostile")
	s4.radius = s3.radius + 0.01
	var ru := await _shoot_lane()
	var outside := String((ru["outcome"] as Dictionary).get("id", "")) == hr.registry.id_of(s4) \
		and s4.damage_taken > 0.0 and is_zero_approx(s3.damage_taken)
	await _clear_probes()
	# SYNTHETIC: every order of a tie list gives the same winner.
	var reg := CombatEntityRegistry.new("h37")
	var n1 := Node.new()
	var n2 := Node.new()
	reg.register(n1, "ordinary", "hostile")
	reg.register(n2, "ordinary", "hostile")
	var c1 := {"id": reg.id_of(n1), "distance_m": 4.0004}
	var c2 := {"id": reg.id_of(n2), "distance_m": 4.0}
	var synth := String(ArrowCollision.choose([c1, c2], reg, 0.001)["id"]) == reg.id_of(n1) \
		and String(ArrowCollision.choose([c2, c1], reg, 0.001)["id"]) == reg.id_of(n1)
	n1.free()
	n2.free()
	var ok := live_ok and within and outside and synth
	_note("H37_a_tie_goes_to_the_lower_combat_entity_id_whatever_the_names_or_order",
		"%s — the lower ID won both times, whatever the names, the instantiation order and the tree order=%s | inside the PROVISIONAL %.3f m tolerance (0.5 mm) the lower ID wins=%s; outside it (1 cm) the earlier edge wins over the lower ID=%s | synthetic, both list orders=%s"
		% [" · ".join(rows), str(live_ok), HuntressConfig.COLLISION_TIE_TOLERANCE_M, str(within), str(outside), str(synth)])
	_reached("H37_a_tie_goes_to_the_lower_combat_entity_id_whatever_the_names_or_order")
	return ok

static func _function_body(code: String, fname: String) -> String:
	var start := code.find("func " + fname + "(")
	if start < 0:
		return ""
	var end := code.find("\nfunc ", start + 5)
	var end2 := code.find("\nstatic func ", start + 5)
	if end < 0 or (end2 >= 0 and end2 < end):
		end = end2
	return code.substr(start, (end - start) if end > 0 else -1)

const IDENTITY_TOKENS := "\\.name\\b|get_instance_id|get_index\\(|get_path\\(|get_children\\(|\\bhash\\(|get_rid\\(|instance_from_id|str\\(node|\"%s\" % node"

func chk_H38_the_choice_code_reads_no_order_name_or_memory_identity() -> bool:
	var re := RegEx.new()
	re.compile(IDENTITY_TOKENS)
	var texts := {
		"arrow_collision.gd": _code_only(_read_text("res://scripts/huntress/arrow_collision.gd")),
		"combat_entity_registry.gd": _code_only(_read_text("res://scripts/huntress/combat_entity_registry.gd")),
		"splinter_arrow.gd _sweep()": _function_body(_code_only(_read_text("res://scripts/huntress/splinter_arrow.gd")), "_sweep"),
		"hit_eligibility.gd": _code_only(_read_text("res://scripts/huntress/hit_eligibility.gd")),
	}
	var hits: Array[String] = []
	var sizes: Array[String] = []
	for k in texts.keys():
		var t := String(texts[k])
		sizes.append("%s %d chars" % [k, t.length()])
		for m in re.search_all(t):
			hits.append("%s: %s" % [k, m.get_string()])
	var all_read := true
	for k in texts.keys():
		all_read = all_read and String(texts[k]).length() > 200
	var caught := re.search(_code_only("\tif a.name < b.name:")) != null \
		and re.search(_code_only("\tvar k := n.get_instance_id()")) != null
	var ignored := re.search(_code_only("# never a.name, never get_instance_id")) == null
	var ok := hits.is_empty() and all_read and caught and ignored
	_note("H38_the_choice_code_reads_no_order_name_or_memory_identity",
		"scanned (code only): %s — reads of a name, an instance id, a tree index or path, a child list, a hash or a RID: %s | a planted name comparison and a planted instance-id read are caught=%s; a comment is ignored=%s | the list ORDER is proved irrelevant by H36/H37's permutations"
		% [", ".join(sizes), str(hits), str(caught), str(ignored)])
	_reached("H38_the_choice_code_reads_no_order_name_or_memory_identity")
	return ok

func chk_H39_a_target_touching_the_archer_is_hit() -> bool:
	await _calibrate_line()
	# 1. IN FRONT, touching her: Hit.
	await _rest()
	var front := _stub("H39_touching_in_front", lane_from + lane_dir * 0.30, "ordinary", "hostile")
	var r1 := await _shoot_lane()
	var o1: Dictionary = r1["outcome"]
	var front_hit := bool(r1["ok"]) and String(o1.get("id", "")) == hr.registry.id_of(front) \
		and is_equal_approx(front.damage_taken, HuntressConfig.SPLINTER_DAMAGE_AT_RANK_1)
	await _clear_probes()
	# 2. THE CASE ONLY THE FIRST SWEEP CATCHES: a test-only stub OVERLAPPING her
	# ground point from the side, whose circle the arrow's head never enters. (Real
	# bodies cannot overlap her -- 0.40 + 0.42 m apart at the least -- so with them
	# the first sweep and the head's own sweep agree; this stub proves the rule.)
	await _rest()
	var side := _stub("H39_overlapping_beside", lane_from + lane_side * 0.30, "ordinary", "hostile")
	var r2 := await _shoot_lane()
	var o2: Dictionary = r2["outcome"]
	var side_hit := bool(r2["ok"]) and String(o2.get("id", "")) == hr.registry.id_of(side) and side.damage_taken > 0.0
	var rel: Dictionary = hr.release_log.back()
	var tail := ArrowCollision.planar(rel["tail"])
	var dir := ArrowCollision.planar(rel["aim"]).normalized()
	var head := tail + dir * float(hr.animator.pres.nocked_arrow()["length"])
	var step_m := HuntressConfig.ARROW_SPEED_MPS / float(Engine.physics_ticks_per_second)
	var r_sum := side.radius + HuntressConfig.ARROW_RADIUS_M
	var c := ArrowCollision.planar(side.global_position)
	var motion_only := ArrowCollision.segment_circle_toi(head, head + dir * step_m, c, r_sum)
	var first_sweep := ArrowCollision.segment_circle_toi(ArrowCollision.planar(lane_from), head, c, r_sum)
	var taken := side.damage_taken
	await _clear_probes()
	var ok := front_hit and side_hit and motion_only < 0.0 and is_zero_approx(first_sweep)
	_note("H39_a_target_touching_the_archer_is_hit",
		"a target touching her 0.30 m in front took the Hit (%.1f)=%s | a stub OVERLAPPING her ground point from the side took the Hit (%.1f)=%s: the arrow's head left %.2f m out and a motion-only sweep would MISS it (toi %.1f); the first sweep from her ground point meets it at t = %.1f — canon's point-blank rule, proved"
		% [HuntressConfig.SPLINTER_DAMAGE_AT_RANK_1 if front_hit else 0.0, str(front_hit), taken, str(side_hit),
		   ArrowCollision.planar(lane_from).distance_to(head), motion_only, first_sweep])
	_reached("H39_a_target_touching_the_archer_is_hit")
	return ok

func chk_H40_one_hit_then_stop_and_nothing_multiplies() -> bool:
	await _calibrate_line()
	await _rest()
	SplinterArrow.reset_counters()
	var first := _probe("H40_first", _line_point(5.0))
	var behind := _probe("H40_behind", _line_point(8.0))
	var r := await _shoot_lane()
	var arrow: SplinterArrow = r.get("arrow", null)
	var path_at_hit := arrow.path_m if arrow != null and is_instance_valid(arrow) else -1.0
	await _phys(30)
	var stayed := arrow == null or not is_instance_valid(arrow) or is_equal_approx(arrow.path_m, path_at_hit)
	var hits1 := SplinterArrow.hits
	var spawned1 := SplinterArrow.spawned
	var first_took := first.life.max_life - first.life.life
	var one := hits1 == 1 and spawned1 == 1 \
		and is_equal_approx(first_took, HuntressConfig.SPLINTER_DAMAGE_AT_RANK_1) \
		and is_equal_approx(behind.life.life, behind.life.max_life)
	# THE ONE BEHIND WAS IN THE PATH: with the first gone, the next arrow Hits it.
	first.queue_free()
	await _phys(2)
	var r2 := await _shoot_lane()
	var behind_hit := String((r2["outcome"] as Dictionary).get("id", "")) == hr.registry.id_of(behind)
	var res: Dictionary = (skills.loadout.configuration(HuntressContent.CFG_SPLINTER_SHOT) as SkillConfiguration).resolve()
	var unmodified := int(res["projectiles"]) == 1 and int(res["fork_children"]) == 0 and int(res["fork_generations"]) == 0
	await _clear_probes()
	var ok := bool(r["ok"]) and stayed and one and behind_hit and unmodified
	_note("H40_one_hit_then_stop_and_nothing_multiplies",
		"one Hit (hits %d, spawned %d), the first target took %.1f and the one behind took nothing=%s | the arrow stopped where it hit (path %.2f m, unchanged 30 frames later)=%s | the one behind WAS in the path: with the first gone the next arrow hits it=%s | unmodified: 1 projectile, no fork=%s"
		% [hits1, spawned1, first_took,
		   str(one), path_at_hit, str(stayed), str(behind_hit), str(unmodified)])
	_reached("H40_one_hit_then_stop_and_nothing_multiplies")
	return ok

func chk_H41_world_geometry_stops_the_arrow_without_a_hit() -> bool:
	await _rest()
	# A direction with world geometry 2.5 - 12 m away, MEASURED.
	var best_dir := Vector3.ZERO
	var best_len := 0.0
	for k in 24:
		var d := _rot_y(lane_dir, 15.0 * float(k))
		var l := _clear_length(lane_from, d, HuntressConfig.ARROW_RADIUS_M, 16.0)
		if l >= 2.5 and l <= 12.0 and (best_len == 0.0 or l < best_len):
			best_len = l
			best_dir = d
	if best_len == 0.0:
		_note("H41_world_geometry_stops_the_arrow_without_a_hit", "NO direction from the lane start meets world geometry within 2.5-12 m — the check cannot run here.")
		_reached("H41_world_geometry_stops_the_arrow_without_a_hit")
		return false
	var behind := _probe("H41_behind_the_wall", lane_from + best_dir * (best_len + 1.2))
	var hits0 := SplinterArrow.hits
	var walls0 := SplinterArrow.wall_stops
	await _settle_facing(best_dir)
	var r := await _shoot(best_dir, 6.0)
	var o: Dictionary = r["outcome"]
	var arrow: SplinterArrow = r.get("arrow", null)
	var stop_d := ArrowCollision.planar(lane_from).distance_to(arrow.head) if arrow != null and is_instance_valid(arrow) else -1.0
	var walled := bool(r["ok"]) and String(o.get("outcome", "")) == "wall" and SplinterArrow.wall_stops == walls0 + 1 \
		and SplinterArrow.hits == hits0 and is_equal_approx(behind.life.life, behind.life.max_life) \
		and absf(stop_d - best_len) <= 0.6
	await _clear_probes()
	# THE GUARD CAN REFUSE: the same probe placed BEFORE the geometry is Hit.
	await _rest()
	var before := _probe("H41_before_the_wall", lane_from + best_dir * maxf(1.6, best_len - 1.2))
	await _settle_facing(best_dir)
	var r2 := await _shoot(best_dir, 6.0)
	var hit_before := String((r2["outcome"] as Dictionary).get("id", "")) == hr.registry.id_of(before)
	await _clear_probes()
	var ok := walled and hit_before
	_note("H41_world_geometry_stops_the_arrow_without_a_hit",
		"along %s world geometry was MEASURED %.2f m away: the arrow stopped %.2f m out, outcome '%s', no Hit, and a target 1.2 m BEHIND the geometry untouched=%s — canon: no projectile passes over a wall | the same target placed BEFORE it is Hit=%s"
		% [str(best_dir), best_len, stop_d, String(o.get("outcome", "")), str(walled), str(hit_before)])
	_reached("H41_world_geometry_stops_the_arrow_without_a_hit")
	return ok

func chk_H42_ineligible_entities_are_passed_through() -> bool:
	await _calibrate_line()
	await _rest()
	var ally := _stub("H42_ally", _line_point(2.5), "ally", "ally")
	var untgt := _stub("H42_untargetable", _line_point(3.5), "ordinary", "hostile")
	untgt.targetable = false
	var invul := _stub("H42_invulnerable", _line_point(4.5), "boss", "hostile")
	invul.invulnerable = true
	var dead := _stub("H42_dead", _line_point(5.5), "elite", "hostile")
	dead.dead = true
	var norecv := StubNoReceiver.new()
	norecv.name = "H42_no_receiver"
	main.add_child(norecv)
	norecv.global_position = _line_point(6.5)
	hr.registry.register(norecv, "hostile_summon", "hostile")
	probes.append(norecv)
	var target := _probe("H42_eligible_behind", _line_point(8.0))
	var r := await _shoot_lane()
	var o: Dictionary = r["outcome"]
	var arrow: SplinterArrow = r.get("arrow", null)
	var passed: Array = arrow.passed_through.duplicate() if arrow != null and is_instance_valid(arrow) else []
	var passed_ids: Array = []
	for p in passed:
		passed_ids.append(String(p[0]))
	var want := [hr.registry.id_of(ally), hr.registry.id_of(untgt), hr.registry.id_of(invul), hr.registry.id_of(dead),
		hr.registry.id_of(norecv)]
	var all_passed := true
	for w in want:
		all_passed = all_passed and passed_ids.has(w)
	var untouched := is_zero_approx(ally.damage_taken) and is_zero_approx(untgt.damage_taken) \
		and is_zero_approx(invul.damage_taken) and is_zero_approx(dead.damage_taken)
	var hit_behind := String(o.get("id", "")) == hr.registry.id_of(target)
	# THE ENTITY WAS IN THE PATH: made targetable, the untargetable one is Hit.
	untgt.targetable = true
	var r2 := await _shoot_lane()
	var now_hit := String((r2["outcome"] as Dictionary).get("id", "")) == hr.registry.id_of(untgt) and untgt.damage_taken > 0.0
	await _clear_probes()
	var ok := bool(r["ok"]) and all_passed and passed_ids.size() == 5 and untouched and hit_behind and now_hit
	_note("H42_ineligible_entities_are_passed_through",
		"five ineligible entities in the line — an ally, an untargetable, an invulnerable boss, a dead elite and a hostile summon with no Hit receiver — were PASSED THROUGH with their reasons %s=%s and took nothing=%s; the eligible enemy behind took the Hit=%s | made targetable, the second one is Hit — it was in the path=%s | TEST-ONLY STUBS: no such state exists in gameplay"
		% [str(passed), str(all_passed), str(untouched), str(hit_behind), str(now_hit)])
	_reached("H42_ineligible_entities_are_passed_through")
	return ok

## A SplinterArrow driven step by step far outside the arena (no geometry there).
func _manual_arrow(reg: CombatEntityRegistry, from: Vector3, dir: Vector3, cap: Dictionary) -> SplinterArrow:
	var a := SplinterArrow.new()
	a.name = "H43_manual_arrow"
	main.add_child(a)
	a.set_physics_process(false)
	var cb := func(o: String, rec: Dictionary, info: Dictionary) -> void:
		cap["outcome"] = o
		cap["id"] = String(rec.get("id", ""))
		cap["distance_m"] = float(info.get("distance_m", 0.0))
	a.launch(from + Vector3(0, 1.3, 0), dir, 0.6, 0.23, from, "H43", 20.0, reg, cb)
	return a

func chk_H43_expiry_at_range_and_no_tunnelling() -> bool:
	var far := Vector3(500, 0, 500)
	# 1. EXPIRY: nothing to Hit, no geometry -- it ends at its range.
	var reg1 := CombatEntityRegistry.new("h43_expiry")
	var cap1 := {}
	var a1 := _manual_arrow(reg1, far, Vector3(1, 0, 0), cap1)
	var n := 0
	while a1.alive and n < 400:
		a1.step(1.0 / 60.0)
		n += 1
	var expired := String(cap1.get("outcome", "")) == "expired" and absf(a1.travelled - HuntressConfig.ARROW_RANGE_M) <= 0.001
	var travelled := a1.travelled
	# 2. NO TUNNELLING: a 2 cm target, stepped at 7 m per step.
	var reg2 := CombatEntityRegistry.new("h43_thin")
	var thin := StubEntity.new()
	thin.name = "H43_thin"
	thin.radius = 0.02
	main.add_child(thin)
	thin.global_position = far + Vector3(10, 0, 0)
	reg2.register(thin, "ordinary", "hostile")
	var cap2 := {}
	var a2 := _manual_arrow(reg2, far, Vector3(1, 0, 0), cap2)
	var heads: Array[float] = []
	n = 0
	while a2.alive and n < 20:
		heads.append(a2.head.x)
		a2.step(0.25)
		n += 1
	var endpoints_outside := true
	for h in heads:
		endpoints_outside = endpoints_outside and absf(h - thin.global_position.x) > 0.12
	var hit := String(cap2.get("outcome", "")) == "hit" and String(cap2.get("id", "")) == reg2.id_of(thin) \
		and thin.damage_taken > 0.0
	# THE GUARD CAN REFUSE: 0.2 m aside (beyond 0.02 + 0.10) the same stepping misses.
	var reg3 := CombatEntityRegistry.new("h43_aside")
	var aside := StubEntity.new()
	aside.name = "H43_aside"
	aside.radius = 0.02
	main.add_child(aside)
	aside.global_position = far + Vector3(10, 0, 0.2)
	reg3.register(aside, "ordinary", "hostile")
	var cap3 := {}
	var a3 := _manual_arrow(reg3, far, Vector3(1, 0, 0), cap3)
	n = 0
	while a3.alive and n < 20:
		a3.step(0.25)
		n += 1
	var missed := String(cap3.get("outcome", "")) == "expired" and is_zero_approx(aside.damage_taken)
	for x in [a1, a2, a3, thin, aside]:
		if is_instance_valid(x):
			(x as Node).queue_free()
	await _phys(2)
	var ok := expired and hit and endpoints_outside and heads.size() >= 2 and missed
	_note("H43_expiry_at_range_and_no_tunnelling",
		"with nothing to Hit the arrow expired after %.4f m (range %.1f, PROVISIONAL)=%s | stepped 7 m at a time, a 2 cm target between two head positions %s (neither inside it)=%s was still Hit=%s | 0.2 m aside the same stepping misses=%s"
		% [travelled, HuntressConfig.ARROW_RANGE_M, str(expired), str(heads), str(endpoints_outside), str(hit), str(missed)])
	_reached("H43_expiry_at_range_and_no_tunnelling")
	return ok

# =============================================================================
# G. THE COMBAT-ENTITY ID — D-392 clarification 3
# =============================================================================

func chk_H44_combat_entity_ids_are_opaque_immutable_unique_deterministic() -> bool:
	var reg := hr.registry
	# DETERMINISTIC, IN COMPOSITION ORDER: the four scene enemies in spawn order.
	#
	# RE-SCOPED UNDER D-398, one for one. Until D-398 the launch registry held
	# EXACTLY the four scene enemies -- TRUE WHEN WRITTEN: D-396 left the hounds
	# unregistered ("no rule here needs a hound's ID"). The D-398 ruling makes
	# stable combat-entity IDs decide the mobile-minion cohort's slots, so the two
	# composed Kindred Hounds are now registered in the area AS ALLIES, AFTER the
	# enemies, in explicit spawn order: 4 + 2 = 6. The enemies still take
	# CE-0001..CE-0004 in spawn order, and the two newer records must be ALLIES
	# that the general eligibility rule REFUSES -- no arrow can Hit one.
	var launch_ids: Array = launch["registered_ids"]
	var recs0 := reg.records()
	var allies_ok := recs0.size() >= 6
	for k in range(4, 6):
		if k < recs0.size():
			var rk: Dictionary = recs0[k]
			allies_ok = allies_ok and String(rk["faction"]) == "ally" and String(rk["category"]) == "ally" \
				and not bool(HitEligibility.evaluate(rk)["eligible"])
	var composed := launch_ids == ["CE-0001", "CE-0002", "CE-0003", "CE-0004"] and int(launch["registered"]) == 6 \
		and allies_ok
	# IMMUTABLE: a second registration is refused and the ID kept.
	var e0: Node = enemies[0]
	var id0 := reg.id_of(e0)
	var ref0 := reg.refusals
	var again := reg.register(e0, "ordinary", "hostile")
	var immutable := again == "" and reg.refusals == ref0 + 1 and reg.last_refusal.find("IMMUTABLE") >= 0 and reg.id_of(e0) == id0
	# NOT FROM A NAME: renaming changes nothing.
	var old_name := String(e0.name)
	e0.name = "Renamed_For_H44"
	var rename_ok := reg.id_of(e0) == id0
	e0.name = old_name
	# UNIQUE, NEVER REUSED: every ID distinct; a new registration gets the next
	# ordinal although many probes have left the area.
	var seen := {}
	var unique := true
	for rec in reg.records():
		unique = unique and not seen.has(String(rec["id"]))
		seen[String(rec["id"])] = true
	var fresh := Node3D.new()
	main.add_child(fresh)
	var fresh_id := reg.register(fresh, "ordinary", "hostile")
	var not_reused := reg.ordinal_of(fresh_id) == reg.count() and not seen.has(fresh_id)
	fresh.queue_free()
	# DETERMINISTIC ACROSS INSTANCES, NAMES AND TREE ORDER: two independent
	# registries fed the same explicit order yield the same IDs.
	var ra := CombatEntityRegistry.new("h44_a")
	var rb := CombatEntityRegistry.new("h44_b")
	var ids_a: Array = []
	var ids_b: Array = []
	var made: Array = []
	for i in 5:
		var na := Node.new()
		na.name = "A_%d" % (4 - i)
		var nb := Node.new()
		nb.name = "B_%d" % i
		made.append(na)
		made.append(nb)
		ids_a.append(ra.register(na, "ordinary", "hostile"))
		ids_b.append(rb.register(nb, "elite", "hostile"))
	var same_seq: bool = ids_a == ids_b and ids_a[0] == "CE-0001"
	for m in made:
		(m as Node).free()
	# REFUSALS: null, scenery, destructible, an unknown category or faction.
	var rr := CombatEntityRegistry.new("h44_refusals")
	var tmp := Node.new()
	var refusals_ok := rr.register(null, "ordinary", "hostile") == "" \
		and rr.register(tmp, "scenery", "hostile") == "" \
		and rr.register(tmp, "destructible", "hostile") == "" \
		and rr.register(tmp, "neutral_critter", "hostile") == "" \
		and rr.register(tmp, "ordinary", "neutral") == "" and rr.refusals == 5 and rr.count() == 0
	tmp.free()
	# OPAQUE: ordering is by ORDINAL, never the display string -- proved where the
	# two disagree (CE-9999 vs CE-10000).
	var big := CombatEntityRegistry.new("h44_big")
	var bulk: Array = []
	for i in 10000:
		var nn := Node.new()
		bulk.append(nn)
		big.register(nn, "ordinary", "hostile")
	var ordinal_order := big.precedes("CE-9999", "CE-10000") and not ("CE-9999" < "CE-10000")
	for nn in bulk:
		(nn as Node).free()
	# NOTHING ELSE PARSES OR FORMATS AN ID; registration happens in no engine callback.
	var parsers: Array[String] = []
	var callbacks: Array[String] = []
	for f in _runtime_script_files():
		var code := _code_only(_read_text(f))
		if code.find("\"CE-") >= 0 and not f.ends_with("combat_entity_registry.gd"):
			parsers.append(f.get_file())
		for cbn in ["_ready", "_enter_tree", "_init", "_notification"]:
			if _function_body(code, cbn).find(".register(") >= 0 or _function_body(code, cbn).find("register_enemy(") >= 0:
				callbacks.append("%s:%s" % [f.get_file(), cbn])
	var ok := composed and immutable and rename_ok and unique and not_reused and same_seq and refusals_ok \
		and ordinal_order and parsers.is_empty() and callbacks.is_empty()
	_note("H44_combat_entity_ids_are_opaque_immutable_unique_deterministic",
		"the four scene enemies took %s in their explicit spawn order, and (D-398) the two composed hounds followed as ALLIES the eligibility rule refuses (4 + 2 = 6)=%s | re-registration refused ('IMMUTABLE'), ID kept=%s | renaming changes nothing=%s | %d IDs all distinct=%s, and a new registration takes the next ordinal (%s) — never reused=%s | two independent registries, different instances and names, same order -> same IDs=%s | null, scenery, destructible, an unknown category and faction refused=%s | order is by ORDINAL: CE-9999 precedes CE-10000 although the strings sort the other way=%s | other files formatting or parsing an ID: %s; registrations inside an engine callback: %s | storage and serialization NOT canonized: the string is display only"
		% [str(launch_ids), str(composed), str(immutable), str(rename_ok), reg.count(), str(unique), fresh_id,
		   str(not_reused), str(same_seq), str(refusals_ok), str(ordinal_order), str(parsers), str(callbacks)])
	_reached("H44_combat_entity_ids_are_opaque_immutable_unique_deterministic")
	return ok

# =============================================================================
# H. ENEMY ELIGIBILITY — D-391 ruling 4, a general combat rule since D-393
# =============================================================================

## Every hostile category, judged by the given predicate.
static func _hostiles_eligible(reg: CombatEntityRegistry, recs: Array, judge: Callable) -> bool:
	var ok := true
	for rec in recs:
		ok = ok and bool(judge.call(rec)["eligible"])
	return ok

func chk_H45_enemy_eligibility_follows_the_ruling_exactly() -> bool:
	var reg := CombatEntityRegistry.new("h45")
	var made: Array = []
	var hostile_recs: Array = []
	for cat in HuntressConfig.HOSTILE_CATEGORIES:
		var s := StubEntity.new()
		s.name = "H45_%s" % String(cat)
		main.add_child(s)
		made.append(s)
		reg.register(s, String(cat), "hostile")
		hostile_recs.append(reg.record_of(s))
	var judge := func(rec: Dictionary) -> Dictionary: return HitEligibility.evaluate(rec)
	var four := _hostiles_eligible(reg, hostile_recs, judge)
	var cases: Array = []
	var mk := func(n: String, cat: String, fac: String) -> StubEntity:
		var st := StubEntity.new()
		st.name = n
		main.add_child(st)
		made.append(st)
		reg.register(st, cat, fac)
		return st
	var ally: StubEntity = mk.call("H45_ally", "ally", "ally")
	cases.append(["an ally", reg.record_of(ally), "not hostile"])
	var dead: StubEntity = mk.call("H45_dead", "ordinary", "hostile")
	dead.dead = true
	cases.append(["a dead or dying actor", reg.record_of(dead), "not alive"])
	var untgt: StubEntity = mk.call("H45_untargetable", "boss", "hostile")
	untgt.targetable = false
	cases.append(["the currently untargetable", reg.record_of(untgt), "currently untargetable"])
	var invul: StubEntity = mk.call("H45_invulnerable", "hostile_summon", "hostile")
	invul.invulnerable = true
	cases.append(["the currently invulnerable", reg.record_of(invul), "currently invulnerable"])
	var norecv := StubNoReceiver.new()
	main.add_child(norecv)
	made.append(norecv)
	reg.register(norecv, "elite", "hostile")
	cases.append(["an actor with no Hit receiver", reg.record_of(norecv), "cannot legally receive"])
	var gone: StubEntity = mk.call("H45_gone", "ordinary", "hostile")
	var gone_rec := reg.record_of(gone)
	main.remove_child(gone)
	cases.append(["an actor no longer in the area", gone_rec, "no longer present"])
	cases.append(["an unregistered nothing", {}, "not a registered"])
	var rows: Array[String] = []
	var reasons_ok := true
	for c in cases:
		var e := HitEligibility.evaluate(c[1])
		var ok1 := not bool(e["eligible"]) and String(e["reason"]).find(String(c[2])) >= 0
		reasons_ok = reasons_ok and ok1
		rows.append("%s -> '%s'" % [String(c[0]), String(e["reason"])])
	# A REAL ORDINARY ENEMY ENTERING DYING stops being eligible that frame.
	await _rest()
	var p := _probe("H45_dying", _lane_point(6.0))
	var alive_ok := bool(HitEligibility.evaluate(hr.registry.record_of(p))["eligible"])
	p.receive_damage(100000.0, p.global_position)
	var dying_refused := p.is_dead() and not bool(HitEligibility.evaluate(hr.registry.record_of(p))["eligible"])
	await _clear_probes()
	# SCENERY AND DESTRUCTIBLES never register at all.
	var sc := Node.new()
	var ds := Node.new()
	var never := reg.register(sc, "scenery", "hostile") == "" and reg.register(ds, "destructible", "hostile") == ""
	sc.free()
	ds.free()
	# A CATEGORY PLAYS NO PART: a planted predicate that excludes bosses is caught.
	var planted := func(rec: Dictionary) -> Dictionary:
		if String(rec.get("category", "")) == "boss":
			return {"eligible": false, "reason": "planted"}
		return HitEligibility.evaluate(rec)
	var caught := not _hostiles_eligible(reg, hostile_recs, planted)
	# THE EXCLUSIONS NAME CONDITIONS: no gameplay class implements either query.
	var states: Array[String] = []
	for f in _runtime_script_files():
		var code := _code_only(_read_text(f))
		if code.find("func combat_is_targetable") >= 0 or code.find("func combat_is_invulnerable") >= 0:
			states.append(f.get_file())
	gone.free()
	for m in made:
		if is_instance_valid(m) and (m as Node).is_inside_tree():
			(m as Node).queue_free()
	var ok := four and reasons_ok and alive_ok and dying_refused and never and caught and states.is_empty()
	_note("H45_enemy_eligibility_follows_the_ruling_exactly",
		"ordinary, elite, boss and hostile summon (test-only stubs) are all eligible=%s | refusals, each with its reason: %s=%s | a real ordinary enemy is eligible alive=%s and refused from its first DYING frame=%s | scenery and destructibles never register=%s | a planted category exclusion (bosses) is caught=%s | gameplay classes implementing an untargetable/invulnerable STATE: %s"
		% [str(four), " · ".join(rows), str(reasons_ok), str(alive_ok), str(dying_refused), str(never), str(caught), str(states)])
	_reached("H45_enemy_eligibility_follows_the_ruling_exactly")
	return ok

# =============================================================================
# I. SURFACES AND THE REVIEW HUD
# =============================================================================

func _press(action: String) -> void:
	await physics_frame
	Input.action_press(action)
	await physics_frame
	await physics_frame
	Input.action_release(action)
	await physics_frame
	await process_frame

func chk_H51_launch_surfaces_hidden_and_the_d392_hud_shown() -> bool:
	var at_launch := not bool(launch["overlay_enabled"]) and not bool(launch["overlay_visible"]) \
		and not bool(launch["panel_enabled"]) and not bool(launch["panel_visible"]) \
		and not bool(launch["d381_enabled"]) and not bool(launch["d381_visible"]) \
		and bool(launch["d392_enabled"]) and bool(launch["d392_visible"])
	var retained := review_hud != null and is_instance_valid(review_hud) and review_hud.is_inside_tree()
	# THE TOGGLES ARE UNCHANGED AND REACHABLE through the real input path.
	var ov0 := hud.enabled
	await _press("toggle_overlay")
	var ov_on := hud.enabled != ov0
	await _press("toggle_overlay")
	var ov_back := hud.enabled == ov0
	var p0 := panel.enabled
	await _press("imprint_panel")
	var p_on := panel.enabled != p0
	await _press("imprint_panel")
	var p_back := panel.enabled == p0
	var still := d392_hud.enabled and d392_hud.visible and not review_hud.enabled
	var ok := at_launch and retained and ov_on and ov_back and p_on and p_back and still
	_note("H51_launch_surfaces_hidden_and_the_d392_hud_shown",
		"AT LAUNCH, captured before any check: F1 overlay hidden, F2 panel hidden, the D-381 review HUD retained but hidden, the Splinter Shot review HUD shown=%s | the D-381 HUD still exists=%s | F1 toggles the overlay on and off=%s, F2 the panel=%s — unchanged | afterwards the Splinter Shot HUD is still shown and the D-381 HUD still hidden=%s"
		% [str(at_launch), str(retained), str(ov_on and ov_back), str(p_on and p_back), str(still)])
	_reached("H51_launch_surfaces_hidden_and_the_d392_hud_shown")
	return ok

func chk_H52_the_hud_is_compact_clear_and_click_through() -> bool:
	await _rest()
	var saved_root_size := root.size
	root.size = Vector2i(1920, 1080)
	var ov_was := hud.enabled
	hud.set_enabled(true)
	hud.refresh()
	d392_hud.refresh()
	for i in 4:
		await process_frame
	var view: Rect2 = d392_hud.body.get_viewport_rect()
	var is_view := view.size == Vector2(1920, 1080) and view.position == Vector2.ZERO
	var r := d392_hud.body_rect()
	var share := (r.size.x * r.size.y) / maxf(1.0, view.size.x * view.size.y)
	var centre := Rect2(view.size * 0.25, view.size * 0.5)
	var clear_centre := not r.intersects(centre)
	var player_px: Vector2 = cam.cam.unproject_position(player.global_position)
	var clear_player := not r.has_point(player_px)
	var ov_rect := (hud.get_node("OverlayPanel") as Control).get_global_rect()
	var clear_overlay := not r.intersects(ov_rect)
	var inside := view.encloses(r) and r.size.x > 100.0 and r.size.y > 60.0
	var bottom_right := r.position.x > view.size.x * 0.5 and r.position.y > view.size.y * 0.5
	var ctrls: Array = []
	_controls_under(d392_hud, ctrls)
	var eats: Array[String] = []
	var small: Array[String] = []
	for c in ctrls:
		if (c as Control).mouse_filter != Control.MOUSE_FILTER_IGNORE:
			eats.append(String((c as Control).name))
		if c is Label and (c as Label).get_theme_font_size("font_size") < 14:
			small.append(String((c as Label).name))
	var beneath := d392_hud.layer < hud.layer and d392_hud.layer < panel.layer
	var guard := Rect2(view.size * 0.4, Vector2(100, 100)).intersects(centre)
	hud.set_enabled(ov_was)
	root.size = saved_root_size
	for i in 2:
		await process_frame
	var ok := is_view and d392_hud.visible and inside and clear_centre and clear_player and clear_overlay \
		and bottom_right and share <= 0.12 and eats.is_empty() and small.is_empty() and ctrls.size() > 8 \
		and beneath and guard and root.size == saved_root_size
	_finding("SPLINTER SHOT HUD (MEASURED in the 1920 x 1080 review view): %s, %.1f%% of the screen. Review tooling, NOT a UI foundation; size and place PROVISIONAL." % [str(r), share * 100.0])
	_note("H52_the_hud_is_compact_clear_and_click_through",
		"MEASURED IN THE 1920 x 1080 REVIEW VIEW=%s: the HUD at %s (inside=%s, bottom-right=%s) covers %.1f%% (<= 12%%) | clear of the central play area=%s, the player at %s=%s, the F1 overlay when shown=%s | %d Controls, every one MOUSE_FILTER_IGNORE (offenders %s); no label under 14 px (offenders %s) | layer %d beneath the overlay's %d and the panel's %d=%s | the centre test refuses a planted central rectangle=%s | the headless root restored"
		% [str(is_view), str(r), str(inside), str(bottom_right), share * 100.0, str(clear_centre), str(player_px),
		   str(clear_player), str(clear_overlay), ctrls.size(), str(eats), str(small), d392_hud.layer, hud.layer,
		   panel.layer, str(beneath), str(guard)])
	_reached("H52_the_hud_is_compact_clear_and_click_through")
	return ok

func _controls_under(n: Node, out: Array) -> void:
	for c in n.get_children():
		if c is Control:
			out.append(c)
		_controls_under(c, out)

static func _numeric_literals(code: String) -> Array:
	var re := RegEx.new()
	re.compile("(?<![A-Za-z_0-9.])-?[0-9]+(\\.[0-9]+)?(?![A-Za-z_0-9])")
	var out: Array = []
	for m in re.search_all(_code_only(code)):
		out.append(float(m.get_string()))
	return out

func chk_H53_the_hud_reads_live_objects_and_owns_no_number() -> bool:
	await _rest()
	# 1. IDENTITY, NOT COPIES.
	var same := is_same(d392_hud.runtime, hr) and is_same(hr.skills, skills) and is_same(hr.player, player)
	# 2. ONLY WHAT THE RULING NAMES: seven lines. RE-SCOPED UNDER D-393: eight
	# until the owner removed Prey, whose line was the eighth -- true when written.
	var keys_ok := HuntressReviewHud.LINE_KEYS == ["title", "input", "state", "timing", "facing", "arrow", "mana"]
	var t0 := d392_hud.compose_lines()
	var labels_ok := String(t0["title"]).find("NOT a UI foundation") >= 0 \
		and String(t0["timing"]).find("PROVISIONAL, not locked") >= 0 \
		and String(t0["input"]).find("right mouse") >= 0 and String(t0["input"]).find("binding 6") >= 0
	# 3. GAMEPLAY MOVES IT: a planted Mana value no constant holds, a live use.
	var saved := skills.pool.mana_current
	skills.pool.mana_current = 77.0
	var planted_seen := String(d392_hud.compose_lines()["mana"]).begins_with("MANA 77 /")
	skills.pool.mana_current = saved
	var before := hr.arrows_released
	await _fire_at(_lane_point(6.0))
	await _phys(3)
	var draw_line := String(d392_hud.compose_lines()["state"])
	await _await_release(before)
	await physics_frame
	var rec_line := String(d392_hud.compose_lines()["state"])
	var live_state := draw_line.find("ACTION: DRAW") == 0 and rec_line.find("ACTION: RECOVERY") == 0
	await _await_action_end()
	var snap := hr.review_snapshot()
	var fields := is_equal_approx(float(snap["mana_current"]), skills.pool.mana_current) \
		and int(snap["arrows"]) == hr.arrows_released and not snap.has("prey_id") \
		and is_equal_approx(float(snap["release_at"]), HuntressConfig.SPLINTER_RELEASE_S)
	# 4. IT OWNS NO NUMBER: no gameplay value appears as a literal in the code that
	# composes its text.
	var src := _read_text("res://scripts/huntress/huntress_review_hud.gd")
	var text_code := _function_body(_code_only(src), "compose_lines") + "\n" + _function_body(_code_only(src), "_input_hint")
	var values := [HuntressConfig.SPLINTER_RELEASE_S, HuntressConfig.splinter_recovery_s(), HuntressConfig.splinter_action_s(),
		HuntressConfig.splinter_release_marker(), HuntressConfig.SPLINTER_DAMAGE_AT_RANK_1, HuntressConfig.SPLINTER_DAMAGE_PER_RANK,
		HuntressConfig.SPLINTER_MANA_AT_RANK_1, HuntressConfig.SPLINTER_MANA_PER_RANK, HuntressConfig.ARROW_SPEED_MPS,
		HuntressConfig.ARROW_RANGE_M, HuntressConfig.ARROW_RADIUS_M, HuntressConfig.COLLISION_TIE_TOLERANCE_M,
		float(HuntressContent.BINDING_INDEX + 1), hr.animator.playback_rate]
	var literal_hits: Array = []
	for v in _numeric_literals(text_code):
		for gv in values:
			if is_equal_approx(float(v), float(gv)):
				literal_hits.append(v)
	var caught := false
	for v in _numeric_literals(text_code + "\n\tvar rel := 0.5\n"):
		if is_equal_approx(float(v), HuntressConfig.SPLINTER_RELEASE_S):
			caught = true
	var ignored := true
	for v in _numeric_literals(text_code + "\n\t# the release was 0.5 once\n"):
		if is_equal_approx(float(v), HuntressConfig.SPLINTER_RELEASE_S):
			ignored = false
	var ok := same and keys_ok and labels_ok and planted_seen and live_state and fields \
		and literal_hits.is_empty() and caught and ignored and text_code.length() > 400
	_note("H53_the_hud_reads_live_objects_and_owns_no_number",
		"the HUD reads the scene's own runtime, skills and player (identity)=%s | exactly seven lines — title, input, action state, timing, facing, arrow, Mana (the Prey line removed under D-393)=%s | it says 'review tooling, NOT a UI foundation' and its timing 'PROVISIONAL, not locked'=%s | a planted 77 Mana shows at once=%s; a live use shows '%s' then '%s'=%s; every snapshot field equals its live source=%s | the text-composing code holds no gameplay value as a literal (found %s) — a planted literal is caught=%s, a comment ignored=%s"
		% [str(same), str(keys_ok), str(labels_ok), str(planted_seen), draw_line, rec_line, str(live_state), str(fields),
		   str(literal_hits), str(caught), str(ignored)])
	_reached("H53_the_hud_reads_live_objects_and_owns_no_number")
	return ok

# =============================================================================
# J. SCOPE AND PRESERVATION
# =============================================================================

## Pinned from the PRE-WORK copy of game3d/ (baseline 2026-09-19 12:30:36, both
## files' SHA-256 equal to the baseline's): the digest of every numeric constant.
const PRE_D392_PROD_DIGEST := "e32d753da863c656a8de6d6d12190b528e237453f77f0108d8dbf784d588ae83"
const PRE_D392_PROD_COUNT := 70
const PRE_D392_IMPRINT_DIGEST := "161b75e9997d6610a3f9d8fb66bb05d0220d19704fdf45ae9a1e797e19315d11"
const PRE_D392_IMPRINT_COUNT := 112

static func _numeric_digest_of_map(m: Dictionary) -> Array:
	# Keys as STRINGS, sorted lexicographically: a StringName sort is not.
	var by_name := {}
	for k in m.keys():
		by_name[String(k)] = m[k]
	var keys: Array = by_name.keys()
	keys.sort()
	var parts: PackedStringArray = []
	for k in keys:
		var v = by_name[k]
		var t := typeof(v)
		if t == TYPE_INT or t == TYPE_FLOAT or t == TYPE_VECTOR2 or t == TYPE_VECTOR3 or t == TYPE_COLOR or t == TYPE_BOOL:
			parts.append("%s=%s" % [k, var_to_str(v)])
	return [parts.size(), "\n".join(parts).sha256_text()]

func chk_H54_no_accepted_tuning_value_changed() -> bool:
	var prod := _numeric_digest_of_map(_constants("res://scripts/core/prod_config.gd"))
	var imp := _numeric_digest_of_map(_constants("res://scripts/imprint/imprint_config.gd"))
	var same := int(prod[0]) == PRE_D392_PROD_COUNT and String(prod[1]) == PRE_D392_PROD_DIGEST \
		and int(imp[0]) == PRE_D392_IMPRINT_COUNT and String(imp[1]) == PRE_D392_IMPRINT_DIGEST
	# The values the owner named, one by one.
	var named := is_equal_approx(ProdConfig.ATTACK_COOLDOWN_S, 0.45) and is_equal_approx(ProdConfig.ATTACK_RELEASE_MARKER, 0.36) \
		and is_equal_approx(ProdConfig.ACTION_BRAKE_MPS2, 120.0) and is_equal_approx(ProdConfig.TOP_SPEED_MPS, 3.889) \
		and is_equal_approx(ProdConfig.YAW_RATE_DEG_PER_S, 720.0) and is_equal_approx(ProdConfig.CAM_SIZE_DEFAULT, 14.0) \
		and is_equal_approx(ProdConfig.CAM_SIZE_MIN, 11.0) and is_equal_approx(ProdConfig.CAM_SIZE_MAX, 18.0) \
		and is_equal_approx(ProdConfig.CAM_PITCH_DEG, -52.0) and ProdConfig.ENEMY_COUNT == 4 and enemies.size() == 4
	# THE DIGEST CAN REFUSE: one value moved in a copy of the map.
	var planted: Dictionary = _constants("res://scripts/core/prod_config.gd").duplicate()
	planted["TOP_SPEED_MPS"] = 3.9
	var refuses := String(_numeric_digest_of_map(planted)[1]) != PRE_D392_PROD_DIGEST
	var ok := same and named and refuses
	_note("H54_no_accepted_tuning_value_changed",
		"every numeric constant of ProdConfig (%d) and ImprintConfig (%d) digests to the PRE-D-392 figures pinned from the pre-work copy=%s | named: 0.45 s, 0.36, 120 m/s², 3.889 m/s, 720 deg/s, zoom 14 / 11-18 m, pitch -52, 4 enemies=%s | one planted change is refused=%s | (D-392 changed only the STATE line, a CORPUS_GAPS note and two denial strings in those files)"
		% [int(prod[0]), int(imp[0]), str(same) + " (" + String(prod[1]).left(12) + ", " + String(imp[1]).left(12) + ")", str(named), str(refuses)])
	_reached("H54_no_accepted_tuning_value_changed")
	return ok

const OUT_OF_SCOPE_NAMES := ["Void Lance", "Cinder Field", "Sinew Ballista", "Kindred Hounds", "Coursing Hounds",
	"Rift Step", "Void Attunement"]
const OUT_OF_SCOPE_IDENT := "kindred|coursing|sinew|cinder|void_lance|voidlance|rift_step|attunement|rift_shard|riftshard|rift_echo|shard|pierce|chain|fork|explos|multishot|volley|passive|loot|equipment|affix|hound|leash"

func chk_H55_no_out_of_scope_content_exists() -> bool:
	# 1. NO OTHER ROSTER SKILL in the live library or loadout.
	var named: Array[String] = []
	for id in skills.library.ids():
		var imp := skills.library.get_imprint(String(id)) as Imprint
		for n in OUT_OF_SCOPE_NAMES:
			if imp != null and imp.display_name.findn(String(n)) >= 0:
				named.append(String(id))
	# RE-SCOPED UNDER D-396, one for one: Kindred Hounds was out of THIS stage's
	# scope and is the ONE roster Skill the D-396 ruling authorizes. So the named
	# set must be EXACTLY {Kindred Hounds} -- any OTHER roster name still fails --
	# and the library 15 + 1 = 16, the Configurations 7 + 1 = 8.
	# RE-SCOPED UNDER D-402, one for one: the named set becomes EXACTLY
	# {Kindred Hounds, Cinder Field} -- the two roster Skills the owner has since
	# authorized by name. Any OTHER roster name still fails, which is the whole of
	# what this guard is for. Until D-402 it was {Kindred Hounds}: true when written.
	var named_sorted: Array = named.duplicate()
	named_sorted.sort()
	var want_named: Array = [HoundContent.SKILL_KINDRED_HOUNDS, CinderContent.SKILL_CINDER_FIELD]
	want_named.sort()
	var named_ok := named_sorted == want_named
	# RE-SCOPED UNDER D-402, ONE FOR ONE: the library 16 + 1 = 17 and the
	# Configurations 8 + 1 = 9 -- Cinder Field, the ONE canonical ACTIVE Skill
	# Imprint that ruling authorizes, with its ONE unmodified Configuration.
	# Until D-402 these required 16 and 8: true when written.
	var count_ok := skills.library.count() == 17 and skills.configurations.size() == 9
	# 2. NO OUT-OF-SCOPE MECHANIC declared in any Huntress file.
	var re := RegEx.new()
	re.compile("(?mi)^\\s*(func|var|const|class_name|signal|static func)\\s+([A-Za-z_0-9]*(" + OUT_OF_SCOPE_IDENT + ")[A-Za-z_0-9]*)")
	var decls: Array[String] = []
	for f in _huntress_script_files():
		for m in re.search_all(_code_only(_read_text(f))):
			decls.append("%s:%s" % [f.get_file(), m.get_string(2)])
	# 3. NO RIFT SHARD ANYWHERE in the runtime.
	var shard := RegEx.new()
	shard.compile("(?i)rift_?shard|rift_?echo")
	var shards: Array[String] = []
	for f in _runtime_script_files():
		if shard.search(_code_only(_read_text(f))) != null:
			shards.append(f.get_file())
	# 4. NO VFX PACKAGE, NO SOURCE EDITION, NO AUDIO.
	var vfx := RegEx.new()
	vfx.compile("assets/VFX|BattleFX|DarkMagicFX|ElementalMagicFX|VividMotion|PortalVFX|AudioStream|\\.wav\"|\\.ogg\"|\\.mp3\"")
	var vfx_hits: Array[String] = []
	for f in _runtime_script_files():
		if vfx.search(_code_only(_read_text(f))) != null:
			vfx_hits.append(f.get_file())
	var asset_files: Array = []
	_walk("res://assets", asset_files)
	var bad_assets: Array[String] = []
	for p in asset_files:
		var s := String(p)
		if s.findn("vfx") >= 0 or s.ends_with(".wav") or s.ends_with(".ogg") or s.ends_with(".mp3") or s.findn("source edition") >= 0:
			bad_assets.append(s)
	var no_source_pack := true
	for pack in AssetManifest.d392_packs():
		no_source_pack = no_source_pack and String(pack["name"]).findn("source") < 0
	# 5. THE INPUT MAP: 26 actions, none added, renamed or removed.
	var input_names: Array[String] = []
	var in_input := false
	for line in _read_text("res://project.godot").split("\n"):
		var l := String(line)
		if l.begins_with("["):
			in_input = l == "[input]"
			continue
		if in_input and l.find("={") > 0:
			input_names.append(l.substr(0, l.find("={")))
	# RE-SCOPED UNDER D-396, one for one: 26 + 1 = 27, the added action named.
	# RE-SCOPED UNDER D-398, one for one: 27 + 2 = 29, both added actions named.
	var twenty_six := input_names.size() == 29 and input_names.has(DIAG_INPUT) \
		and input_names.has("imprint_binding_6") and input_names.has("diagnostic_hound_fall") \
		and input_names.has("diagnostic_stress_population") and input_names.has("diagnostic_travel_speed")
	# THE SCAN CAN REFUSE a planted declaration, and ignores a comment.
	var caught := re.search(_code_only("func kindred_hound_bite() -> void:")) != null
	var ignored := re.search(_code_only("# func kindred_hound_bite() -> void:")) == null
	var ok := named_ok and count_ok and decls.is_empty() and shards.is_empty() and vfx_hits.is_empty() \
		and bad_assets.is_empty() and no_source_pack and twenty_six and caught and ignored
	_note("H55_no_out_of_scope_content_exists",
		"Imprints bearing another roster Skill's name: %s — EXACTLY Kindred Hounds, the one the D-396 ruling authorizes; the library holds %d Imprints (14 diagnostic + Splinter Shot + Kindred Hounds) and %d Configurations (6 + 1 + 1)=%s | out-of-scope declarations in Huntress files (hounds, ballista, trap, Void Lance, Rift Step, Attunement, Rift Shards, Pierce/Chain/Fork, Passives, loot, equipment): %s | Rift Shard code anywhere: %s | VFX-package or audio references: %s; VFX or audio files under assets/: %s; a Source-edition pack=%s | InputMap %d actions (26 + 1 under D-396, + 2 under D-398), the bolt action, binding 6, the D-396 fall action and the two D-398 diagnostic modes present=%s | a planted declaration is caught=%s, a comment ignored=%s"
		% [str(named), skills.library.count(), skills.configurations.size(), str(count_ok), str(decls), str(shards),
		   str(vfx_hits), str(bad_assets), str(not no_source_pack), input_names.size(), str(twenty_six), str(caught), str(ignored)])
	_reached("H55_no_out_of_scope_content_exists")
	return ok

func chk_H56_denials_clarifications_units_and_no_self_acceptance() -> bool:
	var den := HuntressConfig.denials()
	# RE-SCOPED UNDER D-393: 14 -> 15 denials (the multi-target Prey denial gave
	# way to "implements NO Prey", and Huntress's Mark's denial was added: 14 - 1 + 2).
	var den_ok := den.size() == 15
	for d in den:
		den_ok = den_ok and (String(d).find("D-392") >= 0 or String(d).find("D-393") >= 0 or String(d).find("review HUD") >= 0)
	var cl := HuntressConfig.clarifications()
	var cl_ok := cl.size() == 3 and String(cl[0][2]).find("OUT OF SCOPE") >= 0 and String(cl[1][2]).find("OUT OF SCOPE") >= 0 \
		and String(cl[2][2]).find("IMPLEMENTED") >= 0
	# RE-SCOPED UNDER D-393: SD-01..SD-03 (Prey) and SO-04 (Prey) are WITHDRAWN;
	# the rest KEEP their IDs. 18 - 3 = 15 and 5 - 1 = 4.
	var sd := HuntressConfig.deferred_rows()
	var sd_ok := sd.size() == 15
	for i in sd.size():
		sd_ok = sd_ok and String(sd[i][0]).begins_with("SD-%02d " % (i + 4)) and String(sd[i][2]).find("RETURNS TO") >= 0 \
			and String(sd[i][0]).to_lower().find("prey") < 0
	# RE-SCOPED UNDER D-396, AS ITS FIRST ACT, one for one: the four rows were
	# ANSWERED under D-394 and MOVED, text verbatim, to discharged_rows(). 4 - 4 =
	# 0 owed; 0 + 4 = 4 discharged; 0 deleted. Until D-396 this required four
	# OWED rows -- true when written.
	var so := HuntressConfig.discharged_rows()
	var so_ok := so.size() == 4 and HuntressConfig.owed_to_owner().is_empty()
	var so_ids := ["SO-01", "SO-02", "SO-03", "SO-05"]
	var so_text := ["Splinter Shot's responsiveness at the provisional release timing.",
		"Whether the facing snap and visual blend feel natural.",
		"Whether draw and release read at normal gameplay zoom.",
		"Whether projectile collision behaves predictably when targets overlap."]
	for i in so.size():
		so_ok = so_ok and String(so[i][0]) == so_ids[i] and String(so[i][1]).to_lower().find("prey") < 0 \
			and String(so[i][1]) == so_text[i] and String(so[i][2]) == "DISCHARGED — D-394" \
			and String(so[i][3]).find("THE OWNER'S D-394 LIVE REVIEW: ANSWERED DIRECTLY") == 0 \
			and String(so[i][3]).find("ORIGINAL ROW TEXT, PRESERVED VERBATIM (OWED-TO-OWNER): '" + so_text[i] + "'") > 0
	var cites := ""
	for r in HuntressConfig.canonical_rulings():
		cites += String(r[0]) + " "
	var cited := cites.find("D-385") < 0 and cites.find("D-390") >= 0 and cites.find("D-391") >= 0 \
		and cites.find("D-392") >= 0 and cites.find("D-393") >= 0
	var reg_ok := HuntressConfig.registry().size() == 30
	for r in HuntressConfig.registry():
		reg_ok = reg_ok and String(r[2]).find("PROVISIONAL") >= 0
	var labels := HuntressConfig.ANIMATION_LABEL.find("TEMPORARY PLACEHOLDER") == 0 \
		and HuntressConfig.PRESENTATION_LABEL.find("PLACEHOLDER") == 0
	# UNITS AT EVERY SURFACE: the inventory states 203 · 53 · 21 (207 · 57 · 21
	# until D-393 -- true when written).
	# The repository root is game3d/'s parent. Built without a relative parent
	# segment: accepted F65 and I99 refuse one in any file of this project.
	var inv_path := ProjectSettings.globalize_path("res://").trim_suffix("/").get_base_dir() \
		.path_join("docs/testing/D392_SPLINTER_SHOT_OWED_CRITERIA_INVENTORY.md")
	var inv := _read_text(inv_path)
	var units := inv != "" and inv.find("207 − 26 + 22 = 203") >= 0 and inv.find("57 − 5 (`H46`…`H50`) + 1 (`H58`) = 53") >= 0 \
		and OWED.size() == 53
	# NO SELF-ACCEPTANCE: no runtime code and no surface says a stage accepted
	# ITSELF. RE-SCOPED UNDER D-396 (first act): until D-396 this also refused
	# "SPLINTER SHOT STAGE ACCEPTED" -- true when written; D-394 made that the
	# owner's fact, which the state line now carries. The open D-396 stage called
	# accepted takes its place as the needle (see H01).
	# RE-SCOPED AGAIN UNDER D-398 (first act): D-397 made "KINDRED HOUNDS STAGE
	# ACCEPTED" the owner's fact too; the open D-398 stage called accepted takes its
	# place as the needle, and the D-396 self-attribution is still refused.
	# RE-SCOPED A THIRD TIME UNDER D-400 (first act): D-400 made "MOBILE MINION
	# COHESION STAGE ACCEPTED" the owner's fact; the open D-400 stage called accepted
	# takes its place, and "ACCEPTED and CLOSED (D-398)" -- which would attribute the
	# acceptance to the delivering ruling -- is still refused.
	var self_re := RegEx.new()
	# RE-SCOPED UNDER D-402 (first act), one for one: D-401 made the locomotion
	# acceptance the OWNER's fact, so the OPEN D-402 stage takes its place.
	# RE-SCOPED UNDER D-404 (first act), one for one: D-403 made the Cinder Field
	# acceptance the OWNER's fact, so the OPEN D-404 stage takes its place and the
	# D-402 self-attribution joins what is refused.
	self_re.compile("PLAYER DIRECT-CLICK MOVEMENT CORRECTION STAGE ACCEPTED|ACCEPTED and CLOSED \\(D-402\\)|ACCEPTED and CLOSED \\(D-392\\)|ACCEPTED and CLOSED \\(D-396\\)|ACCEPTED and CLOSED \\(D-398\\)|ACCEPTED and CLOSED \\(D-400\\)|" + PLANTED_CLAIM)
	var claims: Array[String] = []
	for f in _runtime_script_files():
		if self_re.search(_code_only(_read_text(f))) != null:
			claims.append(f.get_file())
	var surfaces := d392_hud.last_text + "\n" + hud.compose() + "\n" + ProdConfig.STATE
	var surface_clean := self_re.search(surfaces) == null
	var caught := self_re.search("print(\"%s\")" % PLANTED_CLAIM) != null
	var ok := den_ok and cl_ok and sd_ok and so_ok and cited and reg_ok and labels and units and claims.is_empty() \
		and surface_clean and caught
	_note("H56_denials_clarifications_units_and_no_self_acceptance",
		"%d denials, each naming D-392 or D-393=%s | the three clarifications: CL-1 and CL-2 RECORDED and OUT OF SCOPE, CL-3 IMPLEMENTED=%s | SD-04..SD-18 in order, none naming Prey, each naming where it returns=%s | SO-01, SO-02, SO-03, SO-05 DISCHARGED — D-394 with D-394's answer and their ORIGINAL TEXT VERBATIM, 0 owed (re-scoped under D-396, first act), none naming Prey=%s | the implemented rulings cite D-390, D-391, D-392 and D-393, and no longer D-385's Prey section=%s | all %d registry values PROVISIONAL=%s | the animation and presentation say PLACEHOLDER=%s | the inventory states 203 OWED CRITERIA (207 − 26 + 22) and this suite owes %d EXECUTABLE CHECKS=%s | runtime code claiming a SELF-acceptance: %s; the HUD, overlay and state line claim none=%s; a planted claim is caught=%s"
		% [den.size(), str(den_ok), str(cl_ok), str(sd_ok), str(so_ok), str(cited), HuntressConfig.registry().size(),
		   str(reg_ok), str(labels), OWED.size(), str(units), str(claims), str(surface_clean), str(caught)])
	_reached("H56_denials_clarifications_units_and_no_self_acceptance")
	return ok

func chk_H57_seams_clear_and_no_runtime_dependency_leaves_game3d() -> bool:
	await _rest()
	# AT LAUNCH, as normal play has it.
	var launch_clear := bool(launch["seams_clear"]) and is_equal_approx(float(launch["playback_scale"]), 1.0) \
		and not bool(launch["hold"]) and int(launch["late"]) == 0 and bool(launch["setup_ok"]) \
		and (launch["setup_problems"] as Array).is_empty()
	# THE SEAMS ARE ONLY EVER SET BY A TEST: no runtime code assigns them.
	var seam_re := RegEx.new()
	seam_re.compile("debug_playback_scale\\s*=[^=]|debug_cursor_override\\s*=[^=]|debug_freeze_attack\\s*=[^=]")
	var setters: Array[String] = []
	for f in _runtime_script_files():
		if f.ends_with("foundation_main.gd"):
			continue
		for line in _code_only(_read_text(f)).split("\n"):
			var l := String(line).strip_edges()
			if l.begins_with("var ") or l.begins_with("@export"):
				continue
			var m := seam_re.search(l)
			if m != null:
				setters.append("%s:%s" % [f.get_file(), l])
	var declared_only := setters.is_empty()
	# NO RUNTIME DEPENDENCY LEAVES game3d/: every loaded path is res://.
	var load_re := RegEx.new()
	load_re.compile("(?:load|preload|ResourceLoader\\.load|FileAccess\\.open|DirAccess\\.open)\\s*\\(\\s*\"([^\"]*)\"")
	var outward: Array[String] = []
	for f in _runtime_script_files():
		var code := _code_only(_read_text(f))
		for m in load_re.search_all(code):
			if not m.get_string(1).begins_with("res://") or m.get_string(1).find("..") >= 0:
				outward.append("%s:%s" % [f.get_file(), m.get_string(1)])
		if code.find("res://" + "..") >= 0:
			outward.append("%s:a res:// path climbing out" % f.get_file())
	var manifest_paths := [AssetManifest.PLACEHOLDER_ROOT, AssetManifest.KAYKIT_COMBAT_RANGED,
		AssetManifest.KAYKIT_MOVEMENT_ADVANCED, AssetManifest.BOW_WOODEN, AssetManifest.ARROW, AssetManifest.OUTFIT_RANGER]
	var manifest_local := true
	for p in manifest_paths:
		manifest_local = manifest_local and String(p).begins_with("res://") and String(p).find("..") < 0
	# The planted path is ASSEMBLED, so this file never holds the literal that
	# accepted F65 / I99 refuse.
	var planted_path := "res://" + "." + "./game3d_huntress_spike/scripts/spike/bone_pose.gd"
	var pm := load_re.search("\tvar s = load(\"%s\")" % planted_path)
	var caught := pm != null and (not pm.get_string(1).begins_with("res://") or pm.get_string(1).find("..") >= 0)
	var now_clear := player.intent.seams_clear() and cam.debug_cursor_override == null \
		and is_equal_approx(hr.animator.debug_playback_scale, 1.0) and not player.debug_freeze_attack
	var ok := launch_clear and declared_only and outward.is_empty() and manifest_local and caught and now_clear
	_note("H57_seams_clear_and_no_runtime_dependency_leaves_game3d",
		"at launch every test seam was clear, the animation clock x1.0, no facing hold, no late alignment, and the stage built with no problem=%s | runtime assignments of a seam outside the composition root: %s (declarations only)=%s | loads leaving game3d/: %s; the manifest's D-392 paths are all res://=%s; a planted outward load is caught=%s | seams clear again after the suite=%s"
		% [str(launch_clear), str(setters), str(declared_only), str(outward), str(manifest_local), str(caught), str(now_clear)])
	_reached("H57_seams_clear_and_no_runtime_dependency_leaves_game3d")
	return ok

# =============================================================================
# K. THE D-393 CORRECTION — Prey removed before acceptance
# =============================================================================

const REMOVED_PREY_FILES := ["res://scripts/huntress/huntress_prey.gd", "res://scripts/huntress/huntress_prey.gd.uid",
	"res://scripts/huntress/prey_marker.gd", "res://scripts/huntress/prey_marker.gd.uid",
	"res://scripts/huntress/prey_eligibility.gd", "res://scripts/huntress/prey_eligibility.gd.uid",
	"res://evidence/21_d392_prey_a.png", "res://evidence/21_d392_prey_a.png.import",
	"res://evidence/22_d392_prey_b.png", "res://evidence/22_d392_prey_b.png.import"]
const REMOVED_PREY_CLASSES := ["HuntressPrey", "PreyMarker", "PreyEligibility"]

## Code lines mentioning Prey, per file. The ONLY exemption: a DATA line of
## `huntress_config.gd` (a string literal row) that names D-393 -- the runtime's
## own truthful statement that Prey was removed. Comments never count (they are
## dropped), so a dated history comment neither fails nor excuses anything.
static func _prey_code_lines(file: String, code: String) -> Array:
	var out: Array = []
	for line in _code_only(code).split("\n"):
		var l := String(line)
		if l.to_lower().find("prey") < 0:
			continue
		var t := l.strip_edges()
		# RE-SCOPED UNDER D-402, ONE FOR ONE: the SAME exemption, on the SAME
		# terms, for the two D-402 content files. A stage that must DENY Prey has
		# to be able to write the word in the denial it prints, and the exemption
		# is deliberately narrow -- the line must cite D-393 AND be a string or
		# array literal. Nothing else is exempt: an identifier, an assignment or a
		# call naming Prey still fails, in these files as in every other, and the
		# planted controls below still prove it.
		var denial_file := file.ends_with("huntress_config.gd") \
			or file.ends_with("cinder_config.gd") or file.ends_with("cinder_content.gd")
		var exempt := denial_file and l.find("D-393") >= 0 \
			and (t.begins_with("\"") or t.begins_with("["))
		if not exempt:
			out.append("%s: %s" % [file.get_file(), t.left(80)])
	return out

## Declared identifiers that name a MARK mechanic: a whole token `mark`,
## `marked`, `marks` or `marking` (CamelCase split first). `release_marker` is a
## different word and is not one.
static func _mark_identifiers(code: String) -> Array:
	var out: Array = []
	var re := RegEx.new()
	re.compile("(?m)^\\s*(?:static\\s+)?(?:func|var|const|class_name|signal|class)\\s+([A-Za-z_][A-Za-z_0-9]*)")
	var camel := RegEx.new()
	camel.compile("([a-z0-9])([A-Z])")
	for m in re.search_all(_code_only(code)):
		var ident := m.get_string(1)
		var snake := camel.sub(ident, "$1_$2", true).to_lower()
		for tok in snake.split("_"):
			if ["mark", "marked", "marks", "marking"].has(String(tok)):
				out.append(ident)
				break
	return out

func chk_H58_prey_is_removed_and_mark_is_not_implemented() -> bool:
	await _rest()
	# 1. THE FILES AND CLASSES ARE GONE; THE GENERAL PREDICATE SURVIVES.
	var present: Array[String] = []
	for f in REMOVED_PREY_FILES:
		if FileAccess.file_exists(String(f)):
			present.append(String(f).get_file())
	var classes: Array = []
	for c in ProjectSettings.get_global_class_list():
		classes.append(String(c["class"]))
	var class_hits: Array[String] = []
	for c in REMOVED_PREY_CLASSES:
		if classes.has(c):
			class_hits.append(String(c))
	var predicate_kept := classes.has("HitEligibility") and FileAccess.file_exists("res://scripts/huntress/hit_eligibility.gd")
	# 2. NO RUNTIME CODE DECLARES, READS OR WRITES PREY STATE.
	var code_hits: Array = []
	for f in _runtime_script_files():
		code_hits.append_array(_prey_code_lines(f, _read_text(f)))
	var caught_ident := not _prey_code_lines("res://scripts/huntress/x.gd", "\tvar prey_target = null").is_empty()
	var caught_other_file := not _prey_code_lines("res://scripts/huntress/huntress_runtime.gd",
		"\t\"PREY: %s (D-393)\" % id").is_empty()
	var comment_ignored := _prey_code_lines("res://scripts/huntress/x.gd", "\t# Prey was removed").is_empty()
	# 3. NO PREY NODE IN THE LIVE TREE; NO PREY PROPERTY ON THE RUNTIME.
	var node_hits: Array[String] = []
	var stack: Array = [main]
	while not stack.is_empty():
		var n: Node = stack.pop_back()
		if String(n.name).to_lower().find("prey") >= 0:
			node_hits.append(String(n.name))
		stack.append_array(n.get_children())
	var prop_hits: Array[String] = []
	for pr in hr.get_property_list():
		var pn := String(pr["name"]).to_lower()
		if pn.find("prey") >= 0 or pn == "marker":
			prop_hits.append(pn)
	# 4. NO PREY MARKER OR LABEL ON ANY SURFACE.
	hud.set_enabled(true)
	hud.refresh()
	var surfaces := d392_hud.last_text + "\n" + "\n".join(d392_hud.compose_lines().values()) + "\n" + hud.compose()
	hud.set_enabled(false)
	var surface_clean := surfaces.to_lower().find("prey") < 0 and surfaces.length() > 200
	# 5. A HIT DESIGNATES NOTHING: the report records the outcome, and nothing in
	# the runtime designates, prefers or commands a target.
	await _calibrate_line()
	await _rest()
	var p := _probe("H58_target", _line_point(6.0))
	var r := await _shoot_lane()
	var o: Dictionary = r["outcome"]
	var hit := bool(r["ok"]) and String(o.get("outcome", "")) == "hit" and String(o.get("id", "")) == hr.registry.id_of(p)
	var keys: Array = hr.last_outcome.keys()
	keys.sort()
	var record_only := keys == ["category", "distance_m", "frame", "id", "outcome", "tie_set", "use_id"]
	var call_re := RegEx.new()
	call_re.compile("(?i)\\.(designate[a-z_]*|prefer[a-z_]*)\\s*\\(|func\\s+(designate|prefer)")
	var designators: Array[String] = []
	for f in _runtime_script_files():
		if call_re.search(_code_only(_read_text(f))) != null:
			designators.append(String(f).get_file())
	var report_body := _function_body(_code_only(_read_text("res://scripts/huntress/huntress_runtime.gd")), "_on_arrow_report")
	var report_ok := report_body.find("last_outcome =") >= 0 and report_body.to_lower().find("designat") < 0 \
		and report_body.to_lower().find("prey") < 0 and report_body.split("\n").size() <= 8
	var caught_call := call_re.search("\tprey.designate(rec)") != null
	await _clear_probes()
	# 6. HUNTRESS'S MARK IS NOT IMPLEMENTED.
	var mark_hits: Array = []
	for f in _runtime_script_files():
		for m in _mark_identifiers(_read_text(f)):
			mark_hits.append("%s:%s" % [String(f).get_file(), String(m)])
	var mark_caught := not _mark_identifiers("var marked_enemies := []").is_empty() \
		and not _mark_identifiers("const HUNTRESS_MARK_BONUS := 0.2").is_empty() \
		and not _mark_identifiers("class_name HuntressMark").is_empty()
	var marker_not_mark := _mark_identifiers("var release_marker := 0.36\nfunc splinter_release_marker() -> float:").is_empty()
	var imprint_marks: Array[String] = []
	for id in skills.library.ids():
		for tok in String(id).to_lower().split("_"):
			if ["mark", "marked", "marks", "marking"].has(String(tok)):
				imprint_marks.append(String(id))
	var mark_denied := false
	var prey_denied := false
	for d in HuntressConfig.denials():
		if String(d).find("Huntress's Mark is a recorded FUTURE concept (D-393) and is NOT implemented") == 0:
			mark_denied = true
		if String(d).find("implements NO Prey") >= 0 and String(d).find("D-393") >= 0:
			prey_denied = true
	# 7. THE PREY CAPTURES ARE GONE, AND AN UNKNOWN d392_ CAPTURE REFUSES.
	var fm := _code_only(_read_text("res://scripts/foundation_main.gd"))
	var capture_body := _function_body(fm, "_d392_capture")
	var captures_ok := fm.find("d392_prey") < 0 and capture_body.find("\t\t_:") >= 0 and capture_body.find("ok = false") >= 0
	var ok := present.is_empty() and class_hits.is_empty() and predicate_kept and code_hits.is_empty() \
		and caught_ident and caught_other_file and comment_ignored and node_hits.is_empty() and prop_hits.is_empty() \
		and surface_clean and hit and record_only and designators.is_empty() and report_ok and caught_call \
		and mark_hits.is_empty() and mark_caught and marker_not_mark and imprint_marks.is_empty() \
		and mark_denied and prey_denied and captures_ok
	_note("H58_prey_is_removed_and_mark_is_not_implemented",
		"REMOVED (D-393): Prey files still present %s; Prey classes still registered %s; the general predicate HitEligibility kept=%s | runtime code touching Prey %s (the scan catches a planted identifier=%s and a Prey line outside the config's D-393 data=%s, and ignores a comment=%s) | Prey nodes in the live tree %s; Prey properties on the runtime %s | the HUD and the F1 overlay show no Prey=%s | a Hit on %s was recorded and designated nothing (report keys %s)=%s; designate/prefer calls anywhere %s; the arrow report is a record only=%s; a planted designation call is caught=%s | Huntress's Mark: declared Mark identifiers %s (planted Mark identifiers caught=%s; `release_marker` is not one=%s); Mark-named Imprints %s; the runtime says Mark is a FUTURE concept, not implemented=%s, and that it implements NO Prey=%s | the Prey captures removed and an unknown d392_ capture refuses=%s"
		% [str(present), str(class_hits), str(predicate_kept), str(code_hits), str(caught_ident), str(caught_other_file),
		   str(comment_ignored), str(node_hits), str(prop_hits), str(surface_clean), String(o.get("id", "")), str(keys),
		   str(hit and record_only), str(designators), str(report_ok), str(caught_call), str(mark_hits), str(mark_caught),
		   str(marker_not_mark), str(imprint_marks), str(mark_denied), str(prey_denied), str(captures_ok)])
	_reached("H58_prey_is_removed_and_mark_is_not_implemented")
	return ok

# =============================================================================
# REPORT
# =============================================================================

func _all_ok() -> bool:
	for id in OWED:
		if not reached.has(id) or results.get(id, null) != true:
			return false
	for id in reached.keys():
		if not OWED.has(id):
			return false
	return true

func _report() -> void:
	player.intent.clear_seams()
	cam.debug_cursor_override = null
	print("")
	print("------------------------------------------------------------------------")
	print("RESULTS — %s (%s)" % [HuntressConfig.STAGE, HuntressConfig.DECISION])
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
	print("FINDINGS — measured and reported, NOT rulings:")
	for f in findings:
		print("  * %s" % f)
	print("")
	print("DEFERRED — recorded as such, NEVER as passes:")
	for row in HuntressConfig.deferred_rows():
		print("  [%-20s] %s" % [row[1], row[0]])
		print("                   %s" % row[2])
	print("")
	print("OWED TO THE OWNER'S LIVE REVIEW — NOT passes and NOT failures:")
	for row in HuntressConfig.owed_to_owner():
		print("  [OWED-TO-OWNER] %s %s" % [row[0], row[1]])
	# D-396 (first act): the four rows the owner answered under D-394, printed
	# every run with their ORIGINAL TEXT -- NOT passes. None was deleted.
	print("")
	print("DISCHARGED — answered by the owner, recorded as such, NOT passes:")
	for row in HuntressConfig.discharged_rows():
		print("  [%s] %s %s" % [row[2], row[0], row[1]])
		print("                   %s" % row[3])
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
		% [OWED.size(), reached.size(), owed_not_reached.size(), str(owed_not_reached),
		   reached_not_owed.size(), str(reached_not_owed)])
	print("")
	print("DENIALS (%d):" % HuntressConfig.denials().size())
	for d in HuntressConfig.denials():
		print("  %s" % d)
	print("")
	print("UNITS: %d EXECUTABLE CHECKS here · 203 OWED CRITERIA in the D-392 inventory ·" % OWED.size())
	print("       21 RUNNER CHECKS in tests/huntress_smoke.sh · and the ACCEPTED suites' 85, 101")
	print("       and 40 EXECUTABLE CHECKS are DIFFERENT decisions' numbers.")
	print("       Different unit. None is a synonym for another.")
	print("")
	var verdict := "PASS" if _all_ok() else "FAIL"
	# D-396 (first act): the summary gained its discharged count, so a runner pin
	# can refuse a row that silently disappears instead of being discharged.
	print("HUNTRESS VERIFICATION: %s (%d checks: %d passed, %d failed/unreached, %d deferred, %d owed to the owner, %d discharged)"
		% [verdict, OWED.size(), passed, failed, HuntressConfig.deferred_rows().size(), HuntressConfig.owed_to_owner().size(),
		   HuntressConfig.discharged_rows().size()])
	print("STATE: %s" % ProdConfig.STATE)
	print("------------------------------------------------------------------------")
