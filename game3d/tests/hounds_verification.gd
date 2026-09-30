extends SceneTree

## RIFTWROUGHT — THE KINDRED HOUNDS STAGE VERIFICATION  (D-396, 2026-09-19)
##
## ============================================================================
## A FIFTH SUITE. THE FOUR ACCEPTED ONES ARE RE-RUN AS REGRESSIONS.
## ============================================================================
## `tests/foundation_verification.gd` (85, ACCEPTED D-373), `tests/imprint_
## verification.gd` (101, ACCEPTED D-376), `tests/alignment_verification.gd`
## (40, ACCEPTED D-383) and `tests/huntress_verification.gd` (53, ACCEPTED D-394)
## run FIRST in `tests/hounds_smoke.sh`. This suite owns only what the D-396
## stage owes.
##
## ============================================================================
## UNITS. FIFTEEN COUNTS EXIST IN THIS PROJECT AND NONE IS A SYNONYM FOR ANOTHER.
## ============================================================================
##   D-396 OWED CRITERIA     202  docs/testing/D396_KINDRED_HOUNDS_OWED_CRITERIA_INVENTORY.md
##   D-396 EXECUTABLE CHECKS  45  this suite (B01-B45)
##   D-396 RUNNER CHECKS      21  tests/hounds_smoke.sh (Y01-Y21)
##   D-392 203 · 53 · 21   D-380 162 · 40 · 21   D-375 149 · 101 · 26   D-370 125 · 85 · 20
## The D-396 printed rows are 16 KD- rows and 6 KO- rows: none is a pass.
##
## ============================================================================
## IT VERIFIES A STAGE DELIVERED OPEN. IT ACCEPTS NOTHING.
## (D-398 note: true when written. The owner ACCEPTED and CLOSED the stage under
## D-397; since D-398 this suite runs as a REGRESSION, and its hounds move
## through the shared mobile-minion cohort.)
## ============================================================================
## The owner: "It is not P2, full Beastmaster implementation, final art, VFX
## production or tuning." Every number it touches is PROVISIONAL.
##
## THIS SUITE MEASURES THE REVIEW LOADOUT. It does NOT call the accepted suites'
## declared fixture at start-up: the scene is measured exactly as the owner will
## launch it, and B09 proves the fixture restores the accepted loadout exactly.
##
## The standing verification rules, verbatim: a named owed list compared in BOTH
## directions · every check records reaching its LAST line · a missing check
## function is a FAIL, never a skip · every negative control is PROVED ABLE TO
## REFUSE · an assertion that something did NOT happen first asserts the action
## FIRED · source-scanning guards read CODE, never the dated history comments ·
## an unperformed check is DEFERRED and names where it returns.

const OWED := [
	# --- A. THE FIRST ACT (D-394 section 7) ------------------------------------
	"B01_state_names_five_facts_exactly_with_one_definer",
	"B02_so_rows_discharged_d394_with_history_and_d392_denials_dated",
	"B03_every_accepted_pin_moved_together_and_refuses_stale_lines",
	# --- B. KINDRED HOUNDS THROUGH THE ACCEPTED ARCHITECTURE -------------------
	"B04_kindred_hounds_is_one_canonical_persistent_skill_imprint",
	"B05_learned_at_rank_1_with_0_xp_never_seeded_xp_only_from_awards",
	"B06_one_unmodified_configuration_no_activation_and_seven_entry_points",
	# --- C. THE REVIEW LOADOUT ---------------------------------------------------
	"B07_review_loadout_measured_labelled_and_capacity_not_increased",
	"B08_the_reservation_cycle_drives_the_persistent_under_review",
	"B09_the_accepted_loadout_is_restorable_exactly_and_only_suites_restore_it",
	# --- D. RESERVATION ----------------------------------------------------------
	"B10_mana_reservation_is_twenty_percent_of_maximum_and_regen_unreserved",
	"B11_life_conversion_is_proportional_one_resource_and_clamps_health",
	"B12_reducing_or_removing_a_reservation_heals_nothing",
	# --- E. THE PACK -------------------------------------------------------------
	"B13_exactly_two_hounds_at_her_side_and_no_modifier_changes_the_pack",
	"B14_hounds_follow_autonomously_keep_up_and_return_from_afar",
	"B15_following_settles_without_jitter_and_hounds_stay_separated",
	"B16_hounds_obstruct_neither_her_enemies_navigation_nor_projectiles",
	"B17_no_command_path_reaches_a_hound",
	# --- F. TARGETING ------------------------------------------------------------
	"B18_acquisition_membership_is_measured_from_the_huntress",
	"B19_two_provisional_ranges_and_retention_inside_the_leash",
	"B20_nearest_is_measured_from_each_hound_and_two_hounds_split",
	"B21_a_current_valid_target_is_retained_over_a_nearer_newcomer",
	"B22_an_unreachable_enemy_is_refused_and_a_retained_one_abandoned",
	"B23_an_exact_tie_goes_to_the_lower_combat_entity_id",
	"B24_the_choice_reads_no_order_name_identity_prey_or_mark",
	"B25_a_target_crossing_the_leash_is_abandoned_on_that_step",
	"B26_no_boundary_oscillation_and_no_constant_switching",
	"B27_ineligible_entities_are_never_chosen",
	# --- G. BITES ----------------------------------------------------------------
	"B28_bites_land_in_reach_at_the_interval_through_the_hit_receiver",
	"B29_the_pack_kills_without_input_and_the_award_is_once",
	# --- H. ORDINARY ENEMIES -----------------------------------------------------
	"B30_ordinary_enemies_never_select_or_damage_a_hound",
	# --- I. FALLEN-HOUND RECOVERY ----------------------------------------------
	"B31_a_fallen_hound_returns_after_the_delay_at_full_life",
	"B32_recovery_is_low_friction_and_the_pack_keeps_working",
	"B33_the_one_diagnostic_fall_control_is_real_labelled_and_not_a_command",
	# --- J. DEACTIVATION AND RESTORATION ----------------------------------------
	"B34_unequipping_removes_the_pack_and_reequipping_restores_it",
	"B35_losing_the_reservation_removes_the_pack_and_support_restores_it",
	"B36_a_removal_during_recovery_leaves_nothing_pending",
	# --- K. PRESENTATION ---------------------------------------------------------
	"B37_procedural_stand_ins_read_friend_or_foe_without_colour",
	# --- L. SURFACES AND THE REVIEW HUD -----------------------------------------
	"B38_launch_surfaces_hidden_and_both_review_huds_shown",
	"B39_the_hound_hud_is_compact_clear_and_click_through",
	"B40_the_hound_hud_shows_only_the_ruling_reads_live_and_owns_no_number",
	# --- M. SCOPE, PRESERVATION AND TRUTHFULNESS --------------------------------
	"B41_no_accepted_tuning_value_or_module_changed",
	"B42_no_out_of_scope_content_exists",
	"B43_denials_rulings_units_and_no_self_acceptance",
	"B44_seams_clear_and_no_runtime_dependency_leaves_game3d",
	"B45_every_stage_value_is_registered_provisional",
]

## ONE deliberately planted claim, so the self-acceptance scans can be proved
## able to refuse. It is never printed.
const PLANTED_CLAIM := "Kindred_Hounds_Stage_Accepts_Itself_THIS_IS_FORBIDDEN"

## RE-PINNED UNDER D-398, AS ITS FIRST ACT (D-397 section 6). From D-396 until
## D-398 `FIVE` was the five-fact line ending "KINDRED HOUNDS STAGE DELIVERED and
## OPEN pending owner live review (D-396)" and `OPEN5` that clause -- TRUE WHEN
## WRITTEN, and the state this stage was accepted in. D-397 accepted the stage, so
## the names are kept and the line is now SIX facts: `FIVE` holds the current
## line, `OPEN5` the one OPEN clause -- the D-398 stage's -- and `STATE_D396` the
## D-396-era line as a SUPERSEDED needle, exactly as `STATE_D392` is.
## RE-PINNED UNDER D-400 (first act). The const names are D-396's and D-398's and
## were true of them: the line now states SEVEN facts, its sixth is D-400's
## ACCEPTANCE of the cohesion stage and its seventh is the D-400 stage, OPEN.
# D-404 (first act): `FIVE` and `OPEN5` keep their IDENTIFIERS -- renaming
# around a guard is what this project's own rule forbids -- and their CONTENT moves
# with the state. From D-402 until D-404 `FIVE` was the eight-fact line ending
# "CINDER FIELD STAGE DELIVERED and OPEN pending owner live review (D-402)" and
# `OPEN5` that clause -- TRUE WHEN WRITTEN. The line is now NINE facts.
const FIVE := "FOUNDATION STAGE ACCEPTED and CLOSED (D-373) · IMPRINT STAGE ACCEPTED and CLOSED (D-376) · D-378 ALIGNMENT STAGE ACCEPTED and CLOSED (D-383) · HUNTRESS SPLINTER SHOT STAGE ACCEPTED and CLOSED (D-394) · KINDRED HOUNDS STAGE ACCEPTED and CLOSED (D-397) · MOBILE MINION COHESION STAGE ACCEPTED and CLOSED (D-399) · PLAYER LOCOMOTION REDIRECTION STAGE ACCEPTED and CLOSED (D-401) · CINDER FIELD STAGE ACCEPTED and CLOSED (D-403) · PLAYER DIRECT-CLICK MOVEMENT CORRECTION STAGE DELIVERED and OPEN pending owner live review (D-404)"
# D-402 (first act): `OPEN5` keeps its IDENTIFIER -- renaming around a guard is
# what this project's own rule forbids -- and its CONTENT moves with the state.
# It read the D-400 locomotion clause from D-400 until D-402: true when written.
const OPEN5 := "PLAYER DIRECT-CLICK MOVEMENT CORRECTION STAGE DELIVERED and OPEN pending owner live review (D-404)"
## The D-398-era six-fact line, held as a SUPERSEDED needle.
const STATE_D398 := "FOUNDATION STAGE ACCEPTED and CLOSED (D-373) · IMPRINT STAGE ACCEPTED and CLOSED (D-376) · D-378 ALIGNMENT STAGE ACCEPTED and CLOSED (D-383) · HUNTRESS SPLINTER SHOT STAGE ACCEPTED and CLOSED (D-394) · KINDRED HOUNDS STAGE ACCEPTED and CLOSED (D-397) · MOBILE MINION COHESION STAGE DELIVERED and OPEN pending owner live review (D-398)"
## D-402: the D-400-era line, held as a SUPERSEDED needle exactly as STATE_D398 is.
const STATE_D400 := "FOUNDATION STAGE ACCEPTED and CLOSED (D-373) · IMPRINT STAGE ACCEPTED and CLOSED (D-376) · D-378 ALIGNMENT STAGE ACCEPTED and CLOSED (D-383) · HUNTRESS SPLINTER SHOT STAGE ACCEPTED and CLOSED (D-394) · KINDRED HOUNDS STAGE ACCEPTED and CLOSED (D-397) · MOBILE MINION COHESION STAGE ACCEPTED and CLOSED (D-399) · PLAYER LOCOMOTION REDIRECTION STAGE DELIVERED and OPEN pending owner live review (D-400)"
## D-404: the D-402-era line, held as a SUPERSEDED needle exactly as STATE_D400 is.
const STATE_D402 := "FOUNDATION STAGE ACCEPTED and CLOSED (D-373) · IMPRINT STAGE ACCEPTED and CLOSED (D-376) · D-378 ALIGNMENT STAGE ACCEPTED and CLOSED (D-383) · HUNTRESS SPLINTER SHOT STAGE ACCEPTED and CLOSED (D-394) · KINDRED HOUNDS STAGE ACCEPTED and CLOSED (D-397) · MOBILE MINION COHESION STAGE ACCEPTED and CLOSED (D-399) · PLAYER LOCOMOTION REDIRECTION STAGE ACCEPTED and CLOSED (D-401) · CINDER FIELD STAGE DELIVERED and OPEN pending owner live review (D-402)"
const STATE_D392 := "FOUNDATION STAGE ACCEPTED and CLOSED (D-373) · IMPRINT STAGE ACCEPTED and CLOSED (D-376) · D-378 ALIGNMENT STAGE ACCEPTED and CLOSED (D-383) · HUNTRESS SPLINTER SHOT STAGE DELIVERED and OPEN pending owner live review (D-392)"
const STATE_D396 := "FOUNDATION STAGE ACCEPTED and CLOSED (D-373) · IMPRINT STAGE ACCEPTED and CLOSED (D-376) · D-378 ALIGNMENT STAGE ACCEPTED and CLOSED (D-383) · HUNTRESS SPLINTER SHOT STAGE ACCEPTED and CLOSED (D-394) · KINDRED HOUNDS STAGE DELIVERED and OPEN pending owner live review (D-396)"

## The review spot: the west chamber, west of the interior blocker, where the
## Huntress spawns. Open floor for six metres each side.
const T_BASE := Vector3(-13.0, 0.0, 0.0)
const K := HoundContent.SKILL_KINDRED_HOUNDS
const CFG_K := HoundContent.CFG_KINDRED_HOUNDS
const TICKS := 60.0

# =============================================================================
# TEST-ONLY STUB ENTITIES — they exist ONLY in this suite. They let the general
# enemy-eligibility rule and the targeting rule be PROVED on exact positions
# without adding one piece of content.
# =============================================================================
class StubEntity extends Node3D:
	var targetable: bool = true
	var invulnerable: bool = false
	var dead: bool = false
	var radius: float = 0.42
	var damage_taken: float = 0.0
	var hits: int = 0
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
		hits += 1

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
var hounds: HoundRuntime
var hud: DebugOverlay
var panel: LoadoutPanel
var review_hud: ReviewHud
var d392_hud: HuntressReviewHud
var hounds_hud: HoundReviewHud
var arena: ProductionArena
var enemies: Array = []
var corpus: AnimationLibrary
var launch := {}
var probes: Array = []
var nav_map: RID

func _initialize() -> void:
	print("========================================================================")
	print("RIFTWROUGHT — %s VERIFICATION  (%s, %s)" % [HoundConfig.STAGE, HoundConfig.DECISION, HoundConfig.DATE])
	print("STATE: %s" % ProdConfig.STATE)
	# D-398 (first act): this read "Verifying a STAGE DELIVERED OPEN" until D-398
	# -- true when written; D-397 accepted and closed the stage.
	print("Verifying the D-396 stage ACCEPTED and CLOSED under D-397 (delivered OPEN under D-396),")
	print("re-run as a REGRESSION under the D-398 MOBILE MINION COHESION STAGE: Kindred Hounds,")
	print("a canonical PERSISTENT Skill Imprint, through the ACCEPTED Imprint architecture —")
	print("two autonomous procedural stand-in hounds, moving through the shared D-398 cohort.")
	print("It is NOT P2, NOT full Beastmaster implementation, NOT final art and NOT VFX. It LOCKS NO NUMBER.")
	print("OWED EXECUTABLE CHECKS: %d   DEFERRED ROWS: %d   OWED-TO-OWNER ROWS: %d   DISCHARGED: %d"
		% [OWED.size(), HoundConfig.deferred_rows().size(), HoundConfig.owed_to_owner().size(),
		   HoundConfig.discharged_rows().size()])
	print("(The D-396 owed-criteria INVENTORY counts 202 CRITERIA. Different unit.)")
	print("(The ACCEPTED suites count 85, 101, 40 and 53 EXECUTABLE CHECKS. Different decisions.)")
	print("========================================================================")

	main = load("res://scenes/main.tscn").instantiate()
	root.add_child(main)
	for i in 16:
		await process_frame

	player = main.get("player")
	cam = main.get("cam")
	skills = main.get("skills")
	hr = main.get("huntress")
	hounds = main.get("hounds")
	hud = main.get("hud")
	panel = main.get("imprint_panel")
	review_hud = main.get("review_hud")
	d392_hud = main.get("huntress_hud")
	hounds_hud = main.get("hounds_hud")
	arena = main.get("arena")
	enemies = main.get("enemies")
	corpus = main.get("corpus")
	nav_map = NavService.map_rid_for(main)
	# WHAT LAUNCH SHOWED, captured BEFORE any check touches anything.
	var lo := skills.loadout
	var hs: Array = []
	for h in hounds.pack:
		hs.append({"pos": (h as Node3D).global_position, "life": (h as KindredHound).life.life})
	launch = {
		"overlay_enabled": hud.enabled, "overlay_visible": hud.visible,
		"panel_enabled": panel.enabled, "panel_visible": panel.visible,
		"d381_enabled": review_hud.enabled, "d381_visible": review_hud.visible,
		"d392_enabled": d392_hud.enabled, "d392_visible": d392_hud.visible,
		"hounds_hud_enabled": hounds_hud.enabled, "hounds_hud_visible": hounds_hud.visible,
		"seams_clear": player.intent.seams_clear() and cam.debug_cursor_override == null
			and not player.debug_freeze_attack,
		"pack": hounds.pack.size(), "hounds": hs, "player_pos": player.global_position,
		"state": String(hounds.persistent_state()["state"]),
		"bindings": lo.bindings.duplicate(), "persistent": lo.persistent.duplicate(),
		"used": lo.capacity_used(), "total": lo.capacity_total(), "demanded": lo.capacity_demanded(),
		"deactivated": lo.deactivated.duplicate(),
		"mana_reserved": skills.pool.mana_reserved, "life_reserved": skills.pool.life_reserved,
		"cycle": skills.reservation_cycle_configuration, "cycle_state": skills.reservation_state(),
		"mastered": skills.library.mastered(K), "xp": skills.library.xp(K),
		"acq": skills.library.acquisition_record(K),
		"setup_ok": hounds.setup_ok, "setup_problems": hounds.setup_problems.duplicate(),
		"measure": hounds.review_measure.duplicate(true), "plan": hounds.plan_applied,
		"summons": hounds.summons, "bake_count": arena.bake_count,
		"nav": NavService.measure_mesh(arena.nav_mesh()),
		"seeds": skills.library.diagnostic_seeds,
	}
	# THE SCENE'S OWN ENEMIES are frozen and PARKED in the east chamber, far
	# outside every range, so a wandering AI cannot contaminate a measurement.
	for i in enemies.size():
		var e: OrdinaryEnemy = enemies[i]
		e.debug_freeze_ai = true
		e.life = Damageable.new(1000000.0)
		e.global_position = Vector3(9.0, 0, -5.0 + 1.3 * float(i))
	skills.set_safe_state_override(true)
	await _phys(4)

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

## Every string literal emptied, so a scan for IDENTIFIERS cannot fire on prose
## (the runtime's own denials name what it does NOT use).
static func _strip_strings(code: String) -> String:
	var re := RegEx.new()
	re.compile("\"(?:[^\"\\\\]|\\\\.)*\"")
	return re.sub(code, "\"\"", true)

static func _function_body(code: String, fname: String) -> String:
	var start := code.find("func " + fname + "(")
	if start < 0:
		return ""
	var end := code.find("\nfunc ", start + 5)
	var end2 := code.find("\nstatic func ", start + 5)
	if end < 0 or (end2 >= 0 and end2 < end):
		end = end2
	return code.substr(start, (end - start) if end > 0 else -1)

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

func _hound_script_files() -> Array:
	var out: Array = []
	for f in _runtime_script_files():
		if String(f).begins_with("res://scripts/hounds/"):
			out.append(String(f))
	return out

func _constants(path: String) -> Dictionary:
	var scr: Script = load(path)
	return scr.get_script_constant_map()

static func _same(a: Array, b: Array) -> bool:
	if a.size() != b.size():
		return false
	for i in a.size():
		if str(a[i]) != str(b[i]):
			return false
	return true

static func _planar(a: Vector3, b: Vector3) -> float:
	return Vector2(a.x - b.x, a.z - b.z).length()

## A predicate over a state line, so a planted line can be refused. EXACT, part
## by part. RE-PINNED UNDER D-398 (first act): five parts -> SIX, the fifth D-397's
## acceptance of this suite's own stage.
# RE-SCOPED UNDER D-400, one for one: 6 + 1 = 7 facts.
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
		and parts[8] == OPEN5

func _h(i: int) -> KindredHound:
	if i < hounds.pack.size() and hounds.pack[i] != null and is_instance_valid(hounds.pack[i]):
		return hounds.pack[i] as KindredHound
	return null

## A test-only stub, registered in the AREA registry the hounds read.
func _stub(stub_name: String, pos: Vector3, category: String = "ordinary", faction: String = "hostile") -> StubEntity:
	var s := StubEntity.new()
	s.name = stub_name
	main.add_child(s)
	s.global_position = pos
	hr.registry.register(s, category, faction)
	probes.append(s)
	return s

## A stub in the tree but registered only in a PRIVATE registry, so the live
## hounds never see it -- for the pure-rule checks.
func _private_stub(reg: CombatEntityRegistry, stub_name: String, pos: Vector3) -> StubEntity:
	var s := StubEntity.new()
	s.name = stub_name
	main.add_child(s)
	s.global_position = pos
	reg.register(s, "ordinary", "hostile")
	probes.append(s)
	return s

## A fresh ordinary enemy, REGISTERED in the area, frozen unless told otherwise.
func _probe(probe_name: String, pos: Vector3, life: float = 1000000.0, frozen: bool = true) -> OrdinaryEnemy:
	var e := OrdinaryEnemy.new()
	e.name = probe_name
	main.add_child(e)
	e.setup(corpus)
	e.global_position = pos
	e.player = player
	e.debug_freeze_ai = frozen
	e.life = Damageable.new(life)
	hr.register_enemy(e)
	probes.append(e)
	return e

## Removes every probe from the tree. An entity that left cannot be chosen
## (eligibility refuses "no longer present"), and its ID is never reused.
func _clear_probes() -> void:
	for p in probes:
		if p != null and is_instance_valid(p):
			(p as Node).queue_free()
	probes = []
	await _phys(2)

## Waits until the hound runtime has run EXACTLY ONE more physics step. The
## `physics_frame` signal fires BEFORE the nodes process that frame, so one await
## from an idle-frame context is not yet a step; the runtime's own step counter
## is, and it is exact.
func _one_runtime_step() -> void:
	var s0 := hounds.frames_sampled
	while hounds.frames_sampled == s0:
		await physics_frame

## Every hound at her side NOW: the Persistent unequipped and re-equipped through
## the ACCEPTED loadout operations, so the pack is removed and resummoned by the
## same rule every removal follows.
func _refresh_pack() -> void:
	var lo := skills.loadout
	lo.remove_persistent(CFG_K)
	lo.revalidate(skills.pool)
	await _one_runtime_step()
	lo.add_persistent(CFG_K)
	lo.revalidate(skills.pool)
	await _one_runtime_step()

func _stop_player() -> void:
	player.intent.clear_seams()
	player.motor.reset()
	player.clear_move_destination()
	player.velocity = Vector3.ZERO

func _place_player(p: Vector3) -> void:
	_stop_player()
	player.global_position = p

## Back to the REVIEW state: the review plan, MANA RESERVATION, a fresh pack at
## her side on the review spot, full Mana and Health, no probe.
func _reset_review() -> void:
	cam.debug_cursor_override = null
	var g := 0
	while player.commitment.active and g < 240:
		await physics_frame
		g += 1
	await _clear_probes()
	_place_player(T_BASE)
	var c := hounds.configuration()
	if c != null and c.has_modifier(DiagImprintContent.AUG_TITHE):
		c.remove(DiagImprintContent.AUG_TITHE)
	hounds.apply_loadout_plan(HoundContent.review_loadout_plan())
	await _refresh_pack()
	skills.clear_cooldowns()
	skills.pool.refill()
	# The ONE raise path of live Health (D-382): a test fixture, never gameplay.
	player.life.reset()
	await _phys(3)

func _cycle_to(state: String) -> void:
	var g := 0
	while skills.reservation_state() != state and g < 4:
		skills.cycle_reservation_state()
		g += 1

func _press(action: String) -> void:
	await physics_frame
	Input.action_press(action)
	await physics_frame
	await physics_frame
	Input.action_release(action)
	await physics_frame
	await process_frame

## Waits until `cond` holds or `max_frames` physics frames pass. Returns frames.
func _until(cond: Callable, max_frames: int) -> int:
	var g := 0
	while g < max_frames and not bool(cond.call()):
		await physics_frame
		g += 1
	return g

func _reach_all(_r: Dictionary) -> bool:
	return true

func _kindred_nodes_in_tree() -> int:
	var n := 0
	var stack: Array = [main]
	while not stack.is_empty():
		var x: Node = stack.pop_back()
		if x is KindredHound:
			n += 1
		stack.append_array(x.get_children())
	return n

# =============================================================================
# A. THE FIRST ACT — D-394 section 7, done as this stage's first act
# =============================================================================

func chk_B01_state_names_five_facts_exactly_with_one_definer() -> bool:
	var s := ProdConfig.STATE
	var five := _state_parts_ok(s) and s == FIVE
	# EXACTLY ONE definer of the state line anywhere in the runtime.
	var re := RegEx.new()
	re.compile("(?m)^\\s*const\\s+STATE\\s*(:[^=]*)?:?=")
	var definers: Array[String] = []
	for f in _runtime_script_files():
		if re.search(_code_only(_read_text(f))) != null:
			definers.append(String(f).get_file())
	var one := definers.size() == 1 and definers[0] == "prod_config.gd"
	var caught := re.search("const STATE := \"x\"") != null
	# The superseded lines are gone.
	var gone := s != STATE_D392 and s != STATE_D396 and s != STATE_D398 and s != STATE_D400 and s != STATE_D402 \
		and s.find("SPLINTER SHOT STAGE DELIVERED") < 0 \
		and s.find("ALIGNMENT STAGE DELIVERED") < 0 and s.find("IMPRINT STAGE DELIVERED") < 0 \
		and s.find("KINDRED HOUNDS STAGE DELIVERED") < 0 \
		and s.find("MOBILE MINION COHESION STAGE DELIVERED") < 0 \
		and s.find("PLAYER LOCOMOTION REDIRECTION STAGE DELIVERED") < 0 \
		and s.find("CINDER FIELD STAGE DELIVERED") < 0
	# Every surface READS the one definer.
	var readers := _read_text("res://scripts/debug/debug_overlay.gd").find("ProdConfig.STATE") >= 0 \
		and _read_text("res://scripts/imprint/loadout_panel.gd").find("ProdConfig.STATE") >= 0
	# THE PREDICATE REFUSES: the D-392 line, a self-accepted fifth fact, an extra
	# fact, and a line missing the D-394 acceptance.
	var refuses := not _state_parts_ok(STATE_D392) and not _state_parts_ok(STATE_D396) \
		and not _state_parts_ok(STATE_D398) and not _state_parts_ok(STATE_D400) and not _state_parts_ok(STATE_D402) \
		and not _state_parts_ok(s.replace(OPEN5, "PLAYER DIRECT-CLICK MOVEMENT CORRECTION STAGE ACCEPTED and CLOSED (D-404)")) \
		and not _state_parts_ok(s.replace("CINDER FIELD STAGE ACCEPTED and CLOSED (D-403)", "CINDER FIELD STAGE ACCEPTED and CLOSED (D-402)")) \
		and not _state_parts_ok(s.replace("ACCEPTED and CLOSED (D-397)", "ACCEPTED and CLOSED (D-396)")) \
		and not _state_parts_ok(s + " · EXTRA STAGE (D-402)") \
		and not _state_parts_ok(s.replace("HUNTRESS SPLINTER SHOT STAGE ACCEPTED and CLOSED (D-394)", "HUNTRESS SPLINTER SHOT STAGE DELIVERED and OPEN pending owner live review (D-392)"))
	var ok := five and one and caught and gone and readers and refuses
	_note("B01_state_names_five_facts_exactly_with_one_definer",
		"RE-PINNED UNDER D-404 (first act): the state line is now NINE facts — the eighth D-403's acceptance of Cinder Field, the ninth the D-404 direct-click stage OPEN — and the rest of this note is worded as at D-402, true when written: RE-PINNED UNDER D-398, D-400 AND D-402 (first acts): STATE is EXACTLY the EIGHT-fact line (foundation D-373 · Imprint D-376 · alignment D-383 · Splinter Shot D-394 · Kindred Hounds D-397 · mobile minion cohesion D-399 · player locomotion redirection ACCEPTED and CLOSED D-401 · Cinder Field DELIVERED and OPEN D-402)=%s | runtime definers of `const STATE`: %s=%s (a planted definer is seen=%s) | the D-400-era, D-398-era, D-396-era, D-392-era, D-380-era and D-375-era clauses are gone=%s | the overlay and the panel read it=%s | the predicate refuses the D-392, D-396, D-398 and D-400 lines, a self-accepted D-402 fact, a self-accepted D-396 fact, an extra fact and a line without D-394=%s (the id says 'five facts' — true when written)"
		% [str(five), str(definers), str(one), str(caught), str(gone), str(readers), str(refuses)])
	_reached("B01_state_names_five_facts_exactly_with_one_definer")
	return ok

const SO_IDS := ["SO-01", "SO-02", "SO-03", "SO-05"]
const SO_TEXT := ["Splinter Shot's responsiveness at the provisional release timing.",
	"Whether the facing snap and visual blend feel natural.",
	"Whether draw and release read at normal gameplay zoom.",
	"Whether projectile collision behaves predictably when targets overlap."]

func chk_B02_so_rows_discharged_d394_with_history_and_d392_denials_dated() -> bool:
	var so := HuntressConfig.discharged_rows()
	var owed := HuntressConfig.owed_to_owner()
	var sd := HuntressConfig.deferred_rows()
	var rows_ok := so.size() == 4 and owed.is_empty() and sd.size() == 15
	for i in so.size():
		rows_ok = rows_ok and String(so[i][0]) == SO_IDS[i] and String(so[i][1]) == SO_TEXT[i] \
			and String(so[i][2]) == "DISCHARGED — D-394" \
			and String(so[i][3]).find("THE OWNER'S D-394 LIVE REVIEW: ANSWERED DIRECTLY") == 0 \
			and String(so[i][3]).find("ORIGINAL ROW TEXT, PRESERVED VERBATIM (OWED-TO-OWNER): '" + SO_TEXT[i] + "'") > 0
	# At the level the owner gave it: "satisfactory", nothing inferred beyond it.
	var level := HuntressConfig.D394_ANSWER.find("satisfactory") >= 0
	# ZERO rows deleted: 15 deferred + 4 discharged + 0 owed = the 15 + 4 of D-393.
	var none_deleted := sd.size() + so.size() + owed.size() == 15 + 4
	# THE TWO D-392 DENIALS ARE DATED HISTORY, NOT PRESENT-TENSE CLAIMS.
	var den := HuntressConfig.denials()
	var only_dated := false
	var self_dated := false
	var old_present := false
	for d in den:
		var t := String(d)
		if t.find("it implemented ONLY Splinter Shot") >= 0 and t.find("(true of the D-392 stage; D-396, a later stage, adds Kindred Hounds and nothing else of the roster)") >= 0:
			only_dated = true
		if t.find("The D-392 stage was delivered OPEN and never accepted itself: the owner ACCEPTED and CLOSED it under D-394") == 0:
			self_dated = true
		if t == "The D-392 stage delivers OPEN pending owner live review; it does NOT accept itself.":
			old_present = true
	var den_count := den.size() == 15
	var ok := rows_ok and level and none_deleted and only_dated and self_dated and not old_present and den_count
	_note("B02_so_rows_discharged_d394_with_history_and_d392_denials_dated",
		"SO-01, SO-02, SO-03, SO-05 DISCHARGED — D-394 with D-394's answer and their ORIGINAL TEXT VERBATIM; 0 owed; 15 SD rows=%s | the answer is recorded at the level given ('satisfactory')=%s | 15 + 4 + 0 = 19 rows, ZERO deleted=%s | 'ONLY Splinter Shot' is stated OF THE D-392 STAGE, naming D-396=%s | the self-denial is dated history naming D-394=%s | the present-tense 'delivers OPEN' denial is gone=%s | 15 denials, unchanged in number=%s"
		% [str(rows_ok), str(level), str(none_deleted), str(only_dated), str(self_dated), str(not old_present), str(den_count)])
	_reached("B02_so_rows_discharged_d394_with_history_and_d392_denials_dated")
	return ok

## RE-SCOPED UNDER D-398 (first act), one for one: the D-396 runner is now an
## ACCEPTED runner too (D-397), and its pins moved with the rest -- 4 + 1 = 5.
const ACCEPTED_RUNNERS := ["res://tests/foundation_smoke.sh", "res://tests/imprint_smoke.sh",
	"res://tests/alignment_smoke.sh", "res://tests/huntress_smoke.sh", "res://tests/hounds_smoke.sh"]
const ACCEPTED_SUITES := ["res://tests/foundation_verification.gd", "res://tests/imprint_verification.gd",
	"res://tests/alignment_verification.gd", "res://tests/huntress_verification.gd"]

## A runner is CURRENT when its exact-line pin is the current line, it holds the
## D-392-era line as an ABSENCE needle it actually uses, and no pin names the
## D-392 line as expected. RE-PINNED UNDER D-398 (first act): the current line is
## SIX facts, and the D-396-era line is a used absence needle too.
static func _runner_current(t: String) -> bool:
	return t.find("STATE_EXPECT=\"STATE: " + FIVE + "\"") >= 0 \
		and t.find("STATE_D392_LINE=\"STATE: " + STATE_D392 + "\"") >= 0 \
		and t.count("STATE_D392_LINE") >= 2 \
		and t.find("STATE_D396_LINE=\"STATE: " + STATE_D396 + "\"") >= 0 \
		and t.count("STATE_D396_LINE") >= 2 \
		and t.find("STATE_D398_LINE=\"STATE: " + STATE_D398 + "\"") >= 0 \
		and t.count("STATE_D398_LINE") >= 2 \
		and t.find("STATE_EXPECT=\"STATE: " + STATE_D392 + "\"") < 0 \
		and t.find("STATE_EXPECT=\"STATE: " + STATE_D396 + "\"") < 0

func chk_B03_every_accepted_pin_moved_together_and_refuses_stale_lines() -> bool:
	var stale: Array[String] = []
	for r in ACCEPTED_RUNNERS:
		if not _runner_current(_read_text(String(r))):
			stale.append(String(r).get_file())
	var runners_ok := stale.is_empty()
	# THE D-392 RUNNER'S OWN MOVES: 0 owed, 4 discharged, W17 DECLARED, and its
	# self-acceptance scan refuses the open stage called accepted -- RE-PINNED
	# UNDER D-398: the open stage is now D-398's, so the needle is its name.
	var ht := _read_text("res://tests/huntress_smoke.sh")
	var d392_ok := ht.find("\nPIN_H_OWNER=0\n") >= 0 and ht.find("\nPIN_H_DISCHARGED=4\n") >= 0 \
		and ht.find("[DECLARED] W17") >= 0 and ht.find("DECLARED_CLAIMS=$((DECLARED_CLAIMS + 1))") >= 0 \
		and ht.find("SELF_ACCEPT='PLAYER DIRECT-CLICK MOVEMENT CORRECTION STAGE ACCEPTED|") >= 0
	# THE ACCEPTED SUITES THAT PIN THE STATE carry the D-394 and D-397 clauses and
	# (D-398) the open D-398 clause.
	var suites_ok := true
	for p in ["res://tests/imprint_verification.gd", "res://tests/alignment_verification.gd", "res://tests/huntress_verification.gd"]:
		var t := _read_text(String(p))
		suites_ok = suites_ok and t.find(OPEN5) >= 0 and t.find("HUNTRESS SPLINTER SHOT STAGE ACCEPTED and CLOSED (D-394)") >= 0 \
			and t.find("KINDRED HOUNDS STAGE ACCEPTED and CLOSED (D-397)") >= 0 \
			and t.find("MOBILE MINION COHESION STAGE ACCEPTED and CLOSED (D-399)") >= 0
	# THE AUDIT REFUSES a planted stale runner (the D-392 line as the expectation),
	# one that dropped its absence needle, and one that dropped the D-396 clause.
	var ft := _read_text("res://tests/foundation_smoke.sh")
	var planted_stale := not _runner_current(ft.replace("STATE_EXPECT=\"STATE: " + FIVE + "\"", "STATE_EXPECT=\"STATE: " + STATE_D392 + "\""))
	var planted_no_needle := not _runner_current(ft.replace("STATE_D392_LINE", "STATE_OLD_LINE")) \
		and not _runner_current(ft.replace("STATE_D396_LINE", "STATE_OLD_LINE")) \
		and not _runner_current(ft.replace("STATE_D398_LINE", "STATE_OLD_LINE"))
	var planted_four := not _runner_current(ft.replace(" · " + OPEN5, ""))
	var ok := runners_ok and d392_ok and suites_ok and planted_stale and planted_no_needle and planted_four and ft.length() > 1000
	_note("B03_every_accepted_pin_moved_together_and_refuses_stale_lines",
		"RE-PINNED UNDER D-398 AND D-400 (first acts): all five accepted runners pin the SEVEN-fact line EXACTLY and hold the D-392-era, D-396-era AND D-398-era lines as USED absence needles (stale: %s)=%s | the D-392 runner pins 0 owed / 4 discharged, DECLARES W17 and refuses a self-accepted open D-400 stage=%s | the Imprint, alignment and Splinter Shot suites carry the D-394, D-397, D-400-acceptance and D-400-open clauses=%s | the audit REFUSES a planted runner expecting the D-392 line=%s, one without either absence needle=%s, and one missing the open clause=%s"
		% [str(stale), str(runners_ok), str(d392_ok), str(suites_ok), str(planted_stale), str(planted_no_needle), str(planted_four)])
	_reached("B03_every_accepted_pin_moved_together_and_refuses_stale_lines")
	return ok

# =============================================================================
# B. KINDRED HOUNDS THROUGH THE ACCEPTED ARCHITECTURE
# =============================================================================

func chk_B04_kindred_hounds_is_one_canonical_persistent_skill_imprint() -> bool:
	var imp := skills.library.get_imprint(K) as Imprint
	var shape := imp != null and imp.id == K and K.find("DIAG") < 0 and imp.display_name == "Kindred Hounds" \
		and imp.kind == Imprint.Kind.SKILL and imp.skill_class == Imprint.SkillClass.PERSISTENT \
		and imp.canonical and imp.reserves and imp.targeting == "self-centered"
	var tags_ok := imp != null and _same(imp.provides_tags, ["Minion", "Beast", "Melee", "Hit", "Physical"])
	var rank_ok := imp != null and imp.rank_moves.has("reservation") and imp.rank_moves.has("bite damage")
	var lbl := imp.label() if imp != null else ""
	var label_ok := lbl.find("CANONICAL — ") == 0 and lbl.find("'Kindred Hounds'") > 0 and lbl.find("WORKING name") > 0 \
		and lbl.find("D-385 roster, D-394 targeting rule, D-396 stage") > 0 and lbl.find("every number PROVISIONAL") > 0 \
		and lbl.find("DIAGNOSTIC") < 0
	var sp := skills.library.get_imprint(HuntressContent.SKILL_SPLINTER_SHOT) as Imprint
	var splinter_unchanged := sp != null and sp.label().find("D-385 roster, D-391 ordinary shot") > 0
	# EXACTLY ONE canonical Imprint was added: the canonical set is Splinter Shot
	# and Kindred Hounds, and nothing else.
	var canon: Array[String] = []
	for id in skills.library.ids():
		if (skills.library.get_imprint(String(id)) as Imprint).canonical:
			canon.append(String(id))
	canon.sort()
	# RE-SCOPED UNDER D-402, one for one: the canonical set becomes EXACTLY
	# {Splinter Shot, Kindred Hounds, Cinder Field}. It is still an EXACT set
	# equality, order-independent. Until D-402 it was the first two: true then.
	var want_canon: Array = [K, HuntressContent.SKILL_SPLINTER_SHOT, CinderContent.SKILL_CINDER_FIELD]
	want_canon.sort()
	var canon_ok := _same(canon, want_canon)
	# `Beast` IS CANON'S OWN WORD, quoted with its citation; the one declared
	# extension is still Duration alone.
	var vocab := ImprintConfig.canonical_tags()
	var every_tag_canonical := true
	for t in HoundContent.CANON_TAGS:
		every_tag_canonical = every_tag_canonical and vocab.has(String(t))
	var d385 := _same(ImprintConfig.CANON_TAGS_D385_ADDITIONS, ["Trap", "Emplacement", "Beast"]) \
		and ImprintConfig.CANON_TAGS_D385_CITATION.find("D-385") >= 0
	var ext_ok := ImprintConfig.DECLARED_TAG_EXTENSIONS.size() == 1 and String(ImprintConfig.DECLARED_TAG_EXTENSIONS[0][0]) == "Duration"
	# THE VOCABULARY GUARD CAN FAIL: a tag canon does not hold is not in it.
	var guard := not vocab.has("Hound") and not vocab.has("Pet")
	var ok := shape and tags_ok and rank_ok and label_ok and splinter_unchanged and canon_ok \
		and every_tag_canonical and d385 and ext_ok and guard
	_note("B04_kindred_hounds_is_one_canonical_persistent_skill_imprint",
		"'%s': a SKILL Imprint of the PERSISTENT class, canonical, reserving, self-centred, no DIAG in its id=%s | tags exactly canon's Minion, Beast, Melee, Hit, Physical=%s | rank moves bite damage AND reservation=%s | label '%s'=%s | Splinter Shot's label unchanged=%s | the canonical set is exactly {Splinter Shot, Kindred Hounds}: %s=%s | every tag is in the runtime's quoted canon=%s, Beast/Trap/Emplacement quoted WITH the D-385 citation=%s, the one declared extension still Duration=%s, and the vocabulary refuses a non-canonical word=%s"
		% [K, str(shape), str(tags_ok), str(rank_ok), lbl, str(label_ok), str(splinter_unchanged), str(canon), str(canon_ok),
		   str(every_tag_canonical), str(d385), str(ext_ok), str(guard)])
	_reached("B04_kindred_hounds_is_one_canonical_persistent_skill_imprint")
	return ok

func chk_B05_learned_at_rank_1_with_0_xp_never_seeded_xp_only_from_awards() -> bool:
	await _reset_review()
	var lib := skills.library
	# AT LAUNCH, captured before any check: rank 1 / 0 XP, and the acquisition
	# record says so.
	var acq: Dictionary = launch["acq"]
	var at_launch := int(launch["mastered"]) == 1 and is_zero_approx(float(launch["xp"])) \
		and int(acq.get("rank", -1)) == 1 and is_zero_approx(float(acq.get("xp", -1.0)))
	# NEVER SEEDED: the diagnostic seeds are the accepted fourteen, none of them
	# this Imprint.
	var unseeded := lib.seeded_rank(K) == 0 and int(launch["seeds"]) == 14 and lib.diagnostic_seeds == 14
	# A SECOND LEARN IS IGNORED, and changes nothing.
	var dup0 := lib.duplicate_learns_ignored
	var again := HoundContent.learn_into(lib)
	var dup_ok := not again and lib.duplicate_learns_ignored == dup0 + 1 and lib.mastered(K) == int(launch["mastered"])
	# A FRESH LIBRARY: rank 1, 0 XP, only rank 1 selectable.
	var fresh := ImprintLibrary.new()
	var learned := HoundContent.learn_into(fresh)
	var fresh_ok := learned and fresh.mastered(K) == 1 and is_zero_approx(fresh.xp(K)) \
		and _same(fresh.selectable_ranks(K), [1]) and fresh.count() == 1
	# XP ONLY FROM AWARDED COMBAT PROGRESS: bites land, nothing dies, and no XP
	# and no award arrives. The action FIRES first.
	var awards0 := lib.awards
	var units0 := lib.total_progress_units(K)
	var e := _probe("B05_target", T_BASE + Vector3(0, 0, 3.0))
	var bites0 := _pack_bites()
	await _until(func() -> bool: return _pack_bites() >= bites0 + 3, 600)
	var bit := _pack_bites() >= bites0 + 3 and not e.is_dead()
	var no_xp := lib.awards == awards0 and is_equal_approx(lib.total_progress_units(K), units0)
	# THE AWARD PATH IS THE ONLY SOURCE: one explicit award grants it.
	var r := skills.award_combat_progress(ImprintConfig.COMBAT_PROGRESS_PER_ENEMY_DEFEATED)
	var granted := lib.awards == awards0 + 1 and lib.total_progress_units(K) > units0 and int(r["distinct"]) >= 1
	await _clear_probes()
	var ok := at_launch and unseeded and dup_ok and fresh_ok and bit and no_xp and granted
	_note("B05_learned_at_rank_1_with_0_xp_never_seeded_xp_only_from_awards",
		"AT LAUNCH Kindred Hounds were Mastered Rank %d with %.0f XP and the acquisition record says rank %d / %.0f XP=%s | never diagnostic-seeded (seeded rank %d; the 14 accepted seeds unchanged)=%s | a second learn() is ignored and counted=%s | learned into an EMPTY library: rank 1, 0 XP, only rank 1 selectable=%s | %d bites landed with no kill=%s and brought NO award and NO XP=%s | one awarded combat progress DOES reach it (the accepted award path)=%s"
		% [int(launch["mastered"]), float(launch["xp"]), int(acq.get("rank", -1)), float(acq.get("xp", -1.0)), str(at_launch),
		   lib.seeded_rank(K), str(unseeded), str(dup_ok), str(fresh_ok), _pack_bites() - bites0, str(bit), str(no_xp), str(granted)])
	_reached("B05_learned_at_rank_1_with_0_xp_never_seeded_xp_only_from_awards")
	return ok

func _pack_bites() -> int:
	var n := 0
	for h in hounds.pack:
		if h != null and is_instance_valid(h):
			n += (h as KindredHound).bites
	return n

func chk_B06_one_unmodified_configuration_no_activation_and_seven_entry_points() -> bool:
	await _reset_review()
	var cfg := hounds.configuration()
	var one := cfg != null and cfg.skill_id == K and cfg.modifier_count() == 0 and cfg.is_valid() \
		and cfg.skill_rank() == 1 and _same(cfg.imprint_ids(), [K])
	var cost_ok := cfg != null and cfg.capacity_cost() == ImprintConfig.CAPACITY_BASE_PERSISTENT
	# NO COMBAT ACTIVATION: no binding holds it, in either plan; no input action of
	# its own; the Skill Use path has no delivery for it.
	var unbound := not skills.loadout.bindings.has(CFG_K) \
		and not (HoundContent.review_loadout_plan()["bindings"] as Array).has(CFG_K) \
		and not (HoundContent.accepted_d392_loadout_plan()["bindings"] as Array).has(CFG_K)
	var own_actions: Array[String] = []
	for a in InputMap.get_actions():
		var s := String(a)
		if s.begins_with("ui_"):
			continue
		if s.findn("kindred") >= 0 or s.findn("hound") >= 0:
			own_actions.append(s)
	var inputs_ok := own_actions.size() == 1 and own_actions[0] == HoundConfig.FALL_ACTION
	var rt := _code_only(_read_text("res://scripts/imprint/skill_runtime.gd"))
	var no_delivery := _function_body(rt, "_release").findn("kindred") < 0 and _function_body(rt, "use_binding").findn("kindred") < 0
	var resolved := cfg.resolve() if cfg != null else {}
	var sustains := String(resolved.get("delivery", "")) == "kindred_hounds" and is_zero_approx(float(resolved.get("mana_cost", 0.0)))
	# SEVEN ENTRY POINTS, BOTH DIRECTIONS: the declared set against a set derived
	# independently from the library's Skill Imprints.
	var declared := SkillRuntime.all_action_entry_points()
	var live: Array[String] = []
	live.append_array(PlayerController.DIAGNOSTIC_ACTIONS)
	for id in skills.library.ids():
		if (skills.library.get_imprint(String(id)) as Imprint).kind == Imprint.Kind.SKILL:
			live.append(String(id))
	var undeclared: Array[String] = []
	for a in live:
		if not declared.has(a):
			undeclared.append(a)
	var missing: Array[String] = []
	for a in declared:
		if not live.has(String(a)):
			missing.append(String(a))
	# RE-SCOPED UNDER D-402, one for one: 7 + 1 = 8 action entry points (Cinder
	# Field, a canonical ACTIVE Skill Imprint). Still pinned in BOTH directions.
	var entry_ok := declared.size() == 8 and declared.has(K) and undeclared.is_empty() and missing.is_empty()
	var ok := one and cost_ok and unbound and inputs_ok and no_delivery and sustains and entry_ok
	_note("B06_one_unmodified_configuration_no_activation_and_seven_entry_points",
		"%s: exactly the Kindred Hounds Skill Imprint, ZERO modifiers, valid, Effective Rank 1=%s | Capacity cost %d = the accepted Persistent base (NOT locked)=%s | no binding holds it in the live loadout or either plan=%s | the input actions naming a hound: %s — only the diagnostic fall control=%s | the Skill Use path has no Kindred delivery=%s; it resolves to a SUSTAINED delivery with no Mana cost=%s | %d action entry points, Kindred Hounds among them, both directions (undeclared %s, absent %s)=%s"
		% [CFG_K, str(one), cfg.capacity_cost() if cfg != null else -1, str(cost_ok), str(unbound), str(own_actions), str(inputs_ok),
		   str(no_delivery), str(sustains), declared.size(), str(undeclared), str(missing), str(entry_ok)])
	_reached("B06_one_unmodified_configuration_no_activation_and_seven_entry_points")
	return ok

# =============================================================================
# C. THE REVIEW LOADOUT — measured first, Capacity not increased
# =============================================================================

func chk_B07_review_loadout_measured_labelled_and_capacity_not_increased() -> bool:
	await _reset_review()
	var D := DiagImprintContent
	var sp := HuntressContent.CFG_SPLINTER_SHOT
	var m: Dictionary = launch["measure"]
	var before: Dictionary = m.get("before", {})
	var after: Dictionary = m.get("after", {})
	# MEASURED BEFORE ANY CHANGE: the accepted loadout at 35 / 35, 117.0 reserved.
	var measured := int(before.get("used", -1)) == 35 and int(before.get("total", -1)) == 35 \
		and is_equal_approx(float(before.get("mana_reserved", -1.0)), 117.0) \
		and _same(before.get("persistent", []), [D.CFG_AURA]) and String((before.get("bindings", []) as Array)[3]) == D.CFG_LOW \
		and String((before.get("bindings", []) as Array)[5]) == sp
	# THE PLAN: labelled; the aura REPLACED 1 for 1; the low-rank twin UNBOUND.
	var plan := HoundContent.review_loadout_plan()
	var labelled := String(plan["label"]) == HoundConfig.REVIEW_LOADOUT_LABEL \
		and HoundConfig.REVIEW_LOADOUT_LABEL.find("a DIAGNOSTIC review loadout, not a production loadout") > 0 \
		and String(launch["plan"]) == HoundConfig.REVIEW_LOADOUT_LABEL
	var shape := _same(plan["bindings"], [D.CFG_VOLLEY, D.CFG_BALLISTA, D.CFG_BEASTS, "", D.CFG_TEMPEST, sp, "", ""]) \
		and _same(plan["persistent"], [CFG_K]) and String(plan["cycle"]) == CFG_K
	# CAPACITY IS NOT INCREASED: 30 + 5 = 35, before and after.
	var budget := ImprintConfig.CAPACITY_FROM_PROGRESSION == 30 and ImprintConfig.CAPACITY_GEAR_BONUS_DIAGNOSTIC == 5 \
		and skills.loadout.capacity_total() == 35 and int(after.get("total", -1)) == 35
	# NOTHING DELETED: the aura and the twin are still learned Configurations.
	var kept := skills.configurations.has(D.CFG_AURA) and skills.configurations.has(D.CFG_LOW) \
		and skills.library.knows(D.SKILL_AURA) and skills.library.knows(D.SKILL_STORM)
	# IT FITS IN BOTH STATES, Splinter Shot active in both.
	var lo := skills.loadout
	var mana_state := skills.reservation_state() == "MANA RESERVATION" and lo.capacity_used() == 32 \
		and lo.deactivated.is_empty() and lo.active_configuration_ids().has(sp)
	var used_mana := lo.capacity_used()
	_cycle_to("LIFE CONVERSION")
	var life_state := skills.reservation_state() == "LIFE CONVERSION" and lo.capacity_used() == 33 \
		and lo.deactivated.is_empty() and lo.active_configuration_ids().has(sp)
	var used_life := lo.capacity_used()
	_cycle_to("OFF")
	_cycle_to("MANA RESERVATION")
	# THE PRE-EXISTING FINDING, MEASURED IN THE ACCEPTED LOADOUT: LIFE CONVERSION
	# there demands 36 against 35 and deactivates Splinter Shot. Disclosed, NOT
	# repaired in the accepted artifact.
	hounds.restore_accepted_d392_loadout()
	_cycle_to("LIFE CONVERSION")
	var demanded := lo.capacity_demanded()
	var reason := String(lo.deactivated.get(sp, ""))
	var finding := demanded == 36 and reason.find("OVER CAPACITY") == 0
	_cycle_to("OFF")
	var recovered := not lo.deactivated.has(sp)
	_finding("PRE-EXISTING (accepted D-392 loadout, NOT repaired): R -> LIFE CONVERSION demands %d against 35 and deactivates Splinter Shot ('%s'); the D-396 review loadout uses %d / 35 on Mana and %d / 35 in LIFE CONVERSION."
		% [demanded, reason.left(60), used_mana, used_life])
	await _reset_review()
	var ok := measured and labelled and shape and budget and kept and mana_state and life_state and finding and recovered
	_note("B07_review_loadout_measured_labelled_and_capacity_not_increased",
		"MEASURED BEFORE ANY CHANGE: the accepted loadout used %d / %d with %.1f Mana reserved, the aura as its Persistent and the twin on binding 4=%s | the plan is labelled a DIAGNOSTIC review loadout and was the one applied=%s | Kindred Hounds REPLACE the aura, the twin is UNBOUND, the cycle drives Kindred Hounds=%s | the budget stays 30 + 5 = 35=%s | nothing deleted=%s | it fits: %d / 35 on Mana=%s and %d / 35 in LIFE CONVERSION=%s, Splinter Shot active in both | the pre-existing accepted-loadout overflow measured: %d / 35 deactivating Splinter Shot=%s, recovered at OFF=%s"
		% [int(before.get("used", -1)), int(before.get("total", -1)), float(before.get("mana_reserved", -1.0)), str(measured),
		   str(labelled), str(shape), str(budget), str(kept), used_mana, str(mana_state), used_life, str(life_state),
		   demanded, str(finding), str(recovered)])
	_reached("B07_review_loadout_measured_labelled_and_capacity_not_increased")
	return ok

func chk_B08_the_reservation_cycle_drives_the_persistent_under_review() -> bool:
	await _reset_review()
	var D := DiagImprintContent
	var at_launch := String(launch["cycle"]) == CFG_K and String(launch["cycle_state"]) == "MANA RESERVATION" \
		and String(launch["state"]) == "ACTIVE" and int(launch["pack"]) == HoundConfig.PACK_SIZE
	var seq: Array[String] = [skills.reservation_state()]
	# THROUGH THE REAL INPUT PATH, once: MANA -> LIFE.
	await _press(SkillRuntime.RESERVATION_CYCLE_ACTION)
	seq.append(skills.reservation_state())
	var life_on_k := hounds.configuration().has_modifier(D.AUG_TITHE) and skills.loadout.persistent.has(CFG_K)
	skills.cycle_reservation_state()
	seq.append(skills.reservation_state())
	await _one_runtime_step()
	var off_ok := not skills.loadout.persistent.has(CFG_K) and hounds.pack.is_empty()
	skills.cycle_reservation_state()
	seq.append(skills.reservation_state())
	await _one_runtime_step()
	var back_ok := skills.loadout.persistent.has(CFG_K) and hounds.pack.size() == HoundConfig.PACK_SIZE
	var order_ok := _same(seq, ["MANA RESERVATION", "LIFE CONVERSION", "OFF", "MANA RESERVATION"])
	# THE AURA WAS NEVER TOUCHED by the cycle.
	var aura := skills.loadout.configuration(D.CFG_AURA) as SkillConfiguration
	var aura_untouched := aura != null and not aura.has_modifier(D.AUG_TITHE) and not skills.loadout.persistent.has(D.CFG_AURA)
	# THE FIELD DECIDES WHICH CONFIGURATION IS READ: pointed at the aura, the same
	# state reads OFF while Kindred Hounds stay equipped (a negative control).
	skills.reservation_cycle_configuration = D.CFG_AURA
	var reads_field := skills.reservation_state() == "OFF" and skills.loadout.persistent.has(CFG_K)
	skills.reservation_cycle_configuration = CFG_K
	var restored := skills.reservation_state() == "MANA RESERVATION"
	await _reset_review()
	var ok := at_launch and life_on_k and off_ok and back_ok and order_ok and aura_untouched and reads_field and restored
	_note("B08_the_reservation_cycle_drives_the_persistent_under_review",
		"at launch the D-381 cycle drove Kindred Hounds, in MANA RESERVATION, pack ACTIVE with 2=%s | the cycle ran %s — the first step through the REAL input (key R)=%s | LIFE installs the conversion on Kindred Hounds=%s; OFF unequips it and removes the pack=%s; MANA restores both hounds=%s | the diagnostic aura was never touched=%s | the named field decides which Configuration the cycle reads (pointed at the aura it reads OFF)=%s, and restored=%s. NO input and NO rule was added."
		% [str(at_launch), str(seq), str(order_ok), str(life_on_k), str(off_ok), str(back_ok), str(aura_untouched), str(reads_field), str(restored)])
	_reached("B08_the_reservation_cycle_drives_the_persistent_under_review")
	return ok

func chk_B09_the_accepted_loadout_is_restorable_exactly_and_only_suites_restore_it() -> bool:
	await _reset_review()
	var D := DiagImprintContent
	var before: Dictionary = (launch["measure"] as Dictionary).get("before", {})
	var r := hounds.restore_accepted_d392_loadout()
	await physics_frame
	var lo := skills.loadout
	var exact := bool(r["ok"]) and _same(lo.bindings, before.get("bindings", [])) \
		and _same(lo.persistent, [D.CFG_AURA]) and skills.reservation_cycle_configuration == D.CFG_AURA \
		and lo.capacity_used() == 35 and lo.capacity_total() == 35 and lo.deactivated.is_empty() \
		and is_equal_approx(skills.pool.mana_reserved, 117.0) and is_zero_approx(skills.pool.life_reserved) \
		and is_equal_approx(skills.pool.mana_reserved, float(before.get("mana_reserved", -1.0)))
	var no_pack := hounds.pack.is_empty() and _kindred_nodes_in_tree() == 0 and not hounds.is_sustained()
	await _phys(2)
	var stays := hounds.pack.is_empty() and _kindred_nodes_in_tree() == 0
	# WHO CALLS THE FIXTURE: the four accepted suites (in their start-up) and
	# this suite; in the runtime ONLY the capture path, never normal play.
	#
	# RE-SCOPED ONE FOR ONE UNDER D-402 (2026-09-20): 5 + 1 = 6 suite callers.
	# The D-402 Cinder Field suite calls the declared fixture TWICE, and both are
	# measurements OF the accepted loadout, not of its own: `E08` restores it to
	# measure the PRE-EXISTING 36 / 35 LIFE CONVERSION overflow it still carries
	# (`FD-08`, disclosed and not repaired), and `E39` restores it to prove that
	# binding 7 is EMPTY there, so the accepted loadout removes Cinder Field.
	# NOTHING ELSE IN THIS CHECK MOVED: the `_initialize` clause still walks only
	# `ACCEPTED_SUITES`, so it still demands exactly one start-up call from each of
	# the five accepted suites and demands nothing of the sixth; the runtime clause
	# still admits `foundation_main.gd` alone, and only inside `_run_capture`.
	var callers: Array[String] = []
	var all_tests: Array = []
	_walk("res://tests", all_tests)
	for f in all_tests:
		if String(f).ends_with(".gd") and _code_only(_read_text(String(f))).find("restore_accepted_d392_loadout(") >= 0:
			callers.append(String(f).get_file())
	callers.sort()
	var expect := ["alignment_verification.gd", "cinder_verification.gd", "foundation_verification.gd",
		"hounds_verification.gd", "huntress_verification.gd", "imprint_verification.gd"]
	var suite_callers_ok := _same(callers, expect)
	var in_init := true
	for p in ACCEPTED_SUITES:
		var body := _function_body(_code_only(_read_text(String(p))), "_initialize")
		in_init = in_init and body.count("restore_accepted_d392_loadout()") == 1
	var runtime_callers: Array[String] = []
	for f in _runtime_script_files():
		var code := _code_only(_read_text(String(f)))
		if code.find("restore_accepted_d392_loadout(") >= 0 and not String(f).ends_with("hound_runtime.gd"):
			runtime_callers.append(String(f).get_file())
	var fm := _code_only(_read_text("res://scripts/foundation_main.gd"))
	var capture_only := _same(runtime_callers, ["foundation_main.gd"]) \
		and fm.count("restore_accepted_d392_loadout(") == _function_body(fm, "_run_capture").count("restore_accepted_d392_loadout(")
	await _reset_review()
	var back := hounds.pack.size() == HoundConfig.PACK_SIZE and skills.reservation_cycle_configuration == CFG_K
	var ok := exact and no_pack and stays and suite_callers_ok and in_init and capture_only and back
	_note("B09_the_accepted_loadout_is_restorable_exactly_and_only_suites_restore_it",
		"the declared fixture restores EXACTLY the pre-work loadout measured at composition — the bindings, the aura as the one Persistent, the cycle on the aura, 35 / 35, 117.0 Mana reserved, nothing deactivated=%s | and NO hound: none in the pack or the tree=%s, and none returns=%s | callers in tests/: %s=%s, each accepted suite calling it once in its start-up=%s | runtime callers: %s, only inside the capture path=%s | the review loadout re-applies=%s. It adds no check and removes none."
		% [str(exact), str(no_pack), str(stays), str(callers), str(suite_callers_ok), str(in_init), str(runtime_callers), str(capture_only), str(back)])
	_reached("B09_the_accepted_loadout_is_restorable_exactly_and_only_suites_restore_it")
	return ok

# =============================================================================
# D. RESERVATION — the accepted percentage architecture, unchanged
# =============================================================================

func chk_B10_mana_reservation_is_twenty_percent_of_maximum_and_regen_unreserved() -> bool:
	await _reset_review()
	var pool := skills.pool
	var res := hounds.configuration().resolve()
	var fraction_ok := String(res["reserve_resource"]) == "mana" \
		and is_equal_approx(float(res["reserve_fraction"]), HoundConfig.reserve_fraction_at(1)) \
		and is_equal_approx(float(res["reserve_fraction"]), 0.20) \
		and is_equal_approx(float(res["reserve_amount"]), ImprintConfig.MANA_MAX * 0.20)
	var amounts := is_equal_approx(pool.mana_reserved, 100.0) and is_equal_approx(pool.mana_usable(), 400.0) \
		and is_zero_approx(pool.life_reserved) and not pool.reserves_both()
	# REGENERATION FROM UNRESERVED MAXIMUM: 4.4 % x 400 = 17.6 /s; with nothing
	# reserved 4.4 % x 500 = 22.0 /s.
	var regen_on := pool.regen_per_second()
	_cycle_to("OFF")
	var regen_off := pool.regen_per_second()
	var regen_ok := is_equal_approx(regen_on, 17.6) and is_equal_approx(regen_off, 22.0)
	# ENTERING THE RESERVATION CLAMPS CURRENT MANA TO USABLE -- a ceiling change,
	# not a spend.
	pool.refill()
	var full := pool.mana_current
	var spends0 := pool.spends
	var spent0 := pool.total_spent
	_cycle_to("MANA RESERVATION")
	var clamped := is_equal_approx(full, 500.0) and is_equal_approx(pool.mana_current, 400.0) \
		and pool.spends == spends0 and is_equal_approx(pool.total_spent, spent0)
	# AND THE LIVE RUNTIME REGENERATES AT THAT RATE, over 30 physics frames.
	pool.mana_current = 50.0
	var m0 := pool.mana_current
	await _phys(30)
	var gained := pool.mana_current - m0
	var live_rate := gained / (30.0 / TICKS)
	var live_ok := absf(live_rate - 17.6) < 0.05
	await _reset_review()
	var ok := fraction_ok and amounts and regen_ok and clamped and live_ok
	_note("B10_mana_reservation_is_twenty_percent_of_maximum_and_regen_unreserved",
		"Kindred Hounds resolve to a MANA reservation of %.1f%% of maximum after modifiers (the PROVISIONAL candidate, canon's own 20 %% example)=%s | 100.0 reserved, 400.0 usable, no Life, never both=%s | regeneration %.2f /s reserving and %.2f /s with nothing reserved — 4.4%% of UNRESERVED maximum=%s | entering the reservation clamped %.0f -> %.0f current Mana with ZERO spends=%s | the live runtime regenerated %.3f over 30 frames = %.2f /s=%s"
		% [float(res["reserve_fraction"]) * 100.0, str(fraction_ok), str(amounts), regen_on, regen_off, str(regen_ok),
		   full, pool.mana_current, str(clamped), gained, live_rate, str(live_ok)])
	_reached("B10_mana_reservation_is_twenty_percent_of_maximum_and_regen_unreserved")
	return ok

func chk_B11_life_conversion_is_proportional_one_resource_and_clamps_health() -> bool:
	await _reset_review()
	var pool := skills.pool
	var life := player.life
	var full_health := life.life
	var hits0 := life.hits_taken
	var dmg0 := life.total_damage
	_cycle_to("LIFE CONVERSION")
	# SAME TRANSITION: no frame has passed.
	var health_now := life.life
	var res := hounds.configuration().resolve()
	var tithe_rank := hounds.configuration().effective_rank(DiagImprintContent.AUG_TITHE)
	var ratio := SkillConfiguration.conversion_ratio_at(tithe_rank)
	var expect_frac := 0.20 * ratio
	var proportional := String(res["reserve_resource"]) == "life" \
		and is_equal_approx(float(res["reserve_fraction_mana_basis"]), 0.20) \
		and is_equal_approx(float(res["conversion_ratio"]), ratio) \
		and is_equal_approx(float(res["reserve_fraction"]), expect_frac) \
		and is_equal_approx(pool.life_reserved, ImprintConfig.LIFE_MAX * expect_frac)
	var mana_res := pool.mana_reserved
	var life_res := pool.life_reserved
	var one_resource := is_zero_approx(mana_res) and life_res > 0.0 and not pool.reserves_both()
	var clamp_ok := is_equal_approx(full_health, ImprintConfig.LIFE_MAX) \
		and is_equal_approx(health_now, pool.life_usable()) and health_now < full_health
	var not_damage := life.hits_taken == hits0 and is_equal_approx(life.total_damage, dmg0)
	# THE PACK IS KEPT: the same Persistent, a different resource.
	await physics_frame
	var pack_kept := hounds.pack.size() == HoundConfig.PACK_SIZE and hounds.is_sustained()
	await _reset_review()
	var ok := proportional and one_resource and clamp_ok and not_damage and pack_kept
	_note("B11_life_conversion_is_proportional_one_resource_and_clamps_health",
		"LIFE CONVERSION: 20.0%% of maximum Mana x the accepted PROVISIONAL ratio %.4f (conversion Imprint rank %d) = %.2f%% of maximum Life = %.2f reserved=%s | EXACTLY one resource: Mana reserved %.1f, Life %.2f=%s | live Health %.2f -> %.2f = usable Health IN THE SAME TRANSITION=%s, and it was NOT damage (no hit, no damage total)=%s | the pack stays=%s"
		% [ratio, tithe_rank, expect_frac * 100.0, life_res, str(proportional),
		   mana_res, life_res, str(one_resource), full_health, health_now,
		   str(clamp_ok), str(not_damage), str(pack_kept)])
	_reached("B11_life_conversion_is_proportional_one_resource_and_clamps_health")
	return ok

func chk_B12_reducing_or_removing_a_reservation_heals_nothing() -> bool:
	await _reset_review()
	var pool := skills.pool
	var life := player.life
	# MANA: lowered current Mana is NOT raised when the Mana reservation is removed.
	pool.mana_current = 50.0
	_cycle_to("LIFE CONVERSION")
	var mana_after := pool.mana_current
	var mana_ok := is_equal_approx(mana_after, 50.0) and is_zero_approx(pool.mana_reserved)
	# LIFE: Health clamped by the Life reservation stays clamped when it is removed.
	var clamped := life.life
	_cycle_to("OFF")
	var after_off := life.life
	await _phys(20)
	var later := life.life
	var life_ok := clamped < ImprintConfig.LIFE_MAX and is_equal_approx(after_off, clamped) and is_equal_approx(later, clamped) \
		and is_zero_approx(pool.life_reserved) and is_equal_approx(pool.life_usable(), ImprintConfig.LIFE_MAX)
	# THE GUARD CAN FAIL: Health really is below its now-raised ceiling, so a
	# healing rule WOULD have had room to act.
	var room := pool.life_usable() - later > 50.0
	await _reset_review()
	var ok := mana_ok and life_ok and room
	_note("B12_reducing_or_removing_a_reservation_heals_nothing",
		"removing the Mana reservation left current Mana at %.1f (not refilled)=%s | removing the Life reservation left Health at %.2f, then %.2f, then %.2f after 20 frames, under a ceiling now %.0f=%s | the ceiling left %.1f of room a heal would have used — none did=%s. The accepted D-382 rule, unchanged."
		% [mana_after, str(mana_ok), clamped, after_off, later, pool.life_usable(), str(life_ok), ImprintConfig.LIFE_MAX - later, str(room)])
	_reached("B12_reducing_or_removing_a_reservation_heals_nothing")
	return ok

# =============================================================================
# E. THE PACK — two autonomous hounds that obstruct nobody
# =============================================================================

func chk_B13_exactly_two_hounds_at_her_side_and_no_modifier_changes_the_pack() -> bool:
	# AT LAUNCH, captured before any check.
	var launch_side := int(launch["pack"]) == 2
	var worst_launch := 0.0
	for hd in launch["hounds"]:
		worst_launch = maxf(worst_launch, _planar((hd as Dictionary)["pos"], launch["player_pos"]))
	launch_side = launch_side and worst_launch <= HoundConfig.FOLLOW_DISTANCE_M + 0.6
	await _reset_review()
	var res := hounds.configuration().resolve()
	var size_ok := hounds.pack.size() == 2 and HoundConfig.PACK_SIZE == 2 and int(res["pack_size"]) == HoundConfig.PACK_SIZE
	var worst := 0.0
	var off_mesh := 0.0
	for h in hounds.pack:
		var p := (h as Node3D).global_position
		worst = maxf(worst, _planar(p, player.global_position))
		off_mesh = maxf(off_mesh, _planar(NavService.nearest_point(nav_map, p), p))
	var side_ok := worst <= HoundConfig.FOLLOW_DISTANCE_M + 0.35 and off_mesh <= 0.25
	# NO MODIFIER CHANGES THE PACK: the diagnostic Pack Instinct (which moves the
	# diagnostic beasts' count) installed on Kindred Hounds, and a fresh summon.
	var cfg := hounds.configuration()
	var ir := cfg.install(DiagImprintContent.AUG_PACK)
	var with_mod := int(cfg.resolve()["pack_size"])
	skills.loadout.revalidate(skills.pool)
	await _refresh_pack()
	var live_with_mod := hounds.pack.size()
	if bool(ir["ok"]):
		cfg.remove(DiagImprintContent.AUG_PACK)
	var mod_ok := with_mod == 2 and live_with_mod == 2
	# `pack_size` is written in exactly two places: the base 0 and the Kindred
	# Hounds branch -- from the registry.
	var sc := _code_only(_read_text("res://scripts/imprint/skill_configuration.gd"))
	var writes := sc.count("\"pack_size\"") == 2 and sc.find("out[\"pack_size\"] = HoundConfig.PACK_SIZE") >= 0
	var no_add := true
	for id in skills.library.ids():
		var dn := (skills.library.get_imprint(String(id)) as Imprint).display_name
		no_add = no_add and dn.findn("Additional Minion") < 0
	await _reset_review()
	var ok := launch_side and size_ok and side_ok and mod_ok and writes and no_add
	_note("B13_exactly_two_hounds_at_her_side_and_no_modifier_changes_the_pack",
		"at launch %d hounds, the farthest %.2f m from her=%s | now %d hounds = the PROVISIONAL registry candidate = the resolved pack size=%s | at her side (farthest %.2f m, slot %.1f m) on navigable ground (worst %.3f m off the mesh)=%s | with the diagnostic Pack Instinct installed (install %s) the pack resolves to %d and summons %d=%s | pack_size is written only by the base and the Kindred branch=%s | no Additional Minion exists=%s"
		% [int(launch["pack"]), worst_launch, str(launch_side), hounds.pack.size(), str(size_ok), worst, HoundConfig.FOLLOW_DISTANCE_M,
		   off_mesh, str(side_ok), "accepted" if bool(ir["ok"]) else "refused: " + String(ir["reason"]).left(60),
		   with_mod, live_with_mod, str(mod_ok), str(writes), str(no_add)])
	_reached("B13_exactly_two_hounds_at_her_side_and_no_modifier_changes_the_pack")
	return ok

func chk_B14_hounds_follow_autonomously_keep_up_and_return_from_afar() -> bool:
	await _reset_review()
	var start := Vector3(-13.0, 0, -3.0)
	var dest := Vector3(-13.0, 0, 5.0)
	_place_player(start)
	await _refresh_pack()
	await _phys(30)
	var summons0 := hounds.summons
	var thinks0 := _h(0).thinks + _h(1).thinks
	var h1 := _h(0)
	var h2 := _h(1)
	# SHE WALKS -- the canonical click-to-move order to HER. Nothing is said to a
	# hound, by input or by this test, until the return-from-afar step below.
	player.command_move_to(dest)
	var max_d := 0.0
	var moved_frames := 0
	var g := 0
	while g < 360:
		await physics_frame
		g += 1
		for h in [h1, h2]:
			max_d = maxf(max_d, _planar((h as Node3D).global_position, player.global_position))
		if player.motor.speed() > 0.1:
			moved_frames += 1
		elif moved_frames > 20 and _planar(player.global_position, dest) < 0.4:
			break
	var walked_m := _planar(player.global_position, start)
	var walked := walked_m > 7.0
	var keep_up := max_d <= 4.0
	# SETTLED: each at its own slot, the two slots distinct.
	await _phys(90)
	var s1 := h1.follow_slot()
	var s2 := h2.follow_slot()
	var d1 := _planar(h1.global_position, s1)
	var d2 := _planar(h2.global_position, s2)
	var settled := d1 <= HoundConfig.FOLLOW_RESUME_M and d2 <= HoundConfig.FOLLOW_RESUME_M and _planar(s1, s2) >= 1.0
	var seams := player.intent.seams_clear() and cam.debug_cursor_override == null
	var autonomous := h1.thinks + h2.thinks > thinks0 and hounds.summons == summons0 \
		and is_same(h1, _h(0)) and is_same(h2, _h(1))
	# RETURN FROM AFAR: H1 set down 11 m away comes back to its slot by itself.
	h1.global_position = Vector3(-17.0, 0, -6.0)
	var far0 := _planar(h1.global_position, player.global_position)
	var back_frames := await _until(func() -> bool: return _planar(h1.global_position, h1.follow_slot()) <= HoundConfig.FOLLOW_RESUME_M, 360)
	var returned := back_frames < 360 and far0 > 10.0
	await _reset_review()
	var ok := walked and keep_up and settled and seams and autonomous and returned
	_note("B14_hounds_follow_autonomously_keep_up_and_return_from_afar",
		"she walked %.1f m by click-to-move=%s; the farthest either hound fell behind was %.2f m (bound 4.0 = the 1.7 m slot + her 3.889 m/s over the 3.0/s follow gain + 1 m)=%s | settled: H1 %.2f m and H2 %.2f m from their own slots, the slots %.2f m apart=%s | no input seam set=%s; they kept thinking, were never resummoned and are the same two hounds=%s | set down %.1f m away, H1 was back at its slot in %d frames=%s"
		% [walked_m, str(walked), max_d, str(keep_up), d1, d2, _planar(s1, s2), str(settled),
		   str(seams), str(autonomous), far0, back_frames, str(returned)])
	_reached("B14_hounds_follow_autonomously_keep_up_and_return_from_afar")
	return ok

func chk_B15_following_settles_without_jitter_and_hounds_stay_separated() -> bool:
	await _reset_review()
	var start := Vector3(-13.0, 0, -3.0)
	var dest := Vector3(-13.0, 0, 4.0)
	_place_player(start)
	await _refresh_pack()
	await _phys(30)
	var hs := [_h(0), _h(1)]
	# WHILE SHE WALKS: a following hound does not stop and start.
	player.command_move_to(dest)
	var walk_stops := [0, 0]
	var walk_restarts := [0, 0]
	var prev := [0.0, 0.0]
	var moving := [false, false]
	var g := 0
	var arrived := false
	while g < 300 and not arrived:
		await physics_frame
		g += 1
		for i in 2:
			var v := Vector2((hs[i] as KindredHound).velocity.x, (hs[i] as KindredHound).velocity.z).length()
			if moving[i] and v < 0.05:
				walk_stops[i] += 1
				moving[i] = false
			elif not moving[i] and v > 0.3:
				if g > 5:
					walk_restarts[i] += 1
				moving[i] = true
			prev[i] = v
		arrived = g > 20 and player.motor.speed() < 0.05 and _planar(player.global_position, dest) < 0.4
	# AFTER SHE STOPS: each hound comes to rest once, and does not start again.
	var rest_restarts := [0, 0]
	for i in 2:
		moving[i] = Vector2((hs[i] as KindredHound).velocity.x, (hs[i] as KindredHound).velocity.z).length() > 0.05
	for f in 150:
		await physics_frame
		for i in 2:
			var v := Vector2((hs[i] as KindredHound).velocity.x, (hs[i] as KindredHound).velocity.z).length()
			if moving[i] and v < 0.05:
				moving[i] = false
			elif not moving[i] and v > 0.3:
				rest_restarts[i] += 1
				moving[i] = true
	var at_rest: bool = not bool(moving[0]) and not bool(moving[1])
	var smooth: bool = int(walk_stops[0]) + int(walk_stops[1]) <= 2 and int(walk_restarts[0]) + int(walk_restarts[1]) <= 2 \
		and int(rest_restarts[0]) == 0 and int(rest_restarts[1]) == 0 and at_rest
	# SEPARATION IN A FIGHT: both hounds on ONE target, 300 frames.
	_place_player(T_BASE)
	await _refresh_pack()
	var s := _stub("B15_one_target", T_BASE + Vector3(0, 0, 3.0))
	var run := 0
	var max_run := 0
	var min_gap := INF
	var both_on_it := 0
	for f in 300:
		await physics_frame
		var a := _h(0)
		var b := _h(1)
		var gap := _planar(a.global_position, b.global_position)
		min_gap = minf(min_gap, gap)
		if gap < HoundConfig.SEPARATION_M:
			run += 1
			max_run = maxi(max_run, run)
		else:
			run = 0
		if a.target_id() == hr.registry.id_of(s) and b.target_id() == hr.registry.id_of(s):
			both_on_it += 1
	var final_gap := _planar(_h(0).global_position, _h(1).global_position)
	# The fight really crowded them: both on the one target, and it was bitten.
	var bitten := s.hits
	var fought := both_on_it > 150 and bitten > 0
	var separated := max_run <= 60 and final_gap >= HoundConfig.SEPARATION_M * 0.95
	await _reset_review()
	var ok := smooth and fought and separated
	_note("B15_following_settles_without_jitter_and_hounds_stay_separated",
		"while she walked: stops %s and restarts %s per hound (at most one each way in all)=%s at rest; after she stopped: restarts %s over 150 frames, both at rest=%s | ONE target for both hounds on %d of 300 frames, bitten %d times=%s | the longest stretch inside the %.2f m separation distance was %d frames (bound 60 = 1.0 s), the closest %.2f m, finally %.2f m apart=%s"
		% [str(walk_stops), str(walk_restarts), str(smooth), str(rest_restarts), str(at_rest), both_on_it, bitten,
		   str(fought), HoundConfig.SEPARATION_M, max_run, min_gap, final_gap, str(separated)])
	_reached("B15_following_settles_without_jitter_and_hounds_stay_separated")
	return ok

## Resolves a `collision_mask = <expr>` right-hand side to an integer, or -1 when
## it names something this reader does not know (which then FAILS the check).
static func _mask_value(expr: String) -> int:
	var e := expr.split("#")[0].strip_edges()
	var known := {"HoundConfig.COLLISION_MASK_WORLD": HoundConfig.COLLISION_MASK_WORLD}
	var total := 0
	for part in e.split("|"):
		var t := String(part).strip_edges()
		if t.is_valid_int():
			total |= int(t)
		elif known.has(t):
			total |= int(known[t])
		else:
			return -1
	return total

static func _mask_offenders(file: String, code: String) -> Array:
	var re := RegEx.new()
	re.compile("(?m)^\\s*(?:[A-Za-z_][A-Za-z_0-9]*\\.)?collision_mask\\s*=\\s*(.+)$")
	var out: Array = []
	for m in re.search_all(code):
		var v := _mask_value(m.get_string(1))
		if v < 0 or (v & HoundConfig.COLLISION_LAYER) != 0:
			out.append("%s: %s" % [file.get_file(), m.get_string(0).strip_edges()])
	return out

func _fell(h: KindredHound) -> void:
	if h != null and not h.is_fallen():
		h.receive_damage(h.life.life, h.global_position, "B-suite test fall")

func chk_B16_hounds_obstruct_neither_her_enemies_navigation_nor_projectiles() -> bool:
	await _reset_review()
	# 1. STRUCTURAL: the hounds' own layer, which NOTHING masks.
	var layers_ok := true
	for h in hounds.pack:
		layers_ok = layers_ok and (h as KindredHound).collision_layer == HoundConfig.COLLISION_LAYER \
			and (h as KindredHound).collision_mask == HoundConfig.COLLISION_MASK_WORLD
	var maskers: Array[String] = []
	var stack: Array = [main]
	var bodies := 0
	while not stack.is_empty():
		var n: Node = stack.pop_back()
		if n is CollisionObject3D and not (n is KindredHound):
			bodies += 1
			if ((n as CollisionObject3D).collision_mask & HoundConfig.COLLISION_LAYER) != 0:
				maskers.append(String(n.name))
		stack.append_array(n.get_children())
	var code_maskers: Array = []
	for f in _runtime_script_files():
		code_maskers.append_array(_mask_offenders(String(f), _code_only(_read_text(String(f)))))
	var scan_caught := not _mask_offenders("x.gd", "\tq.collision_mask = 2 | 16").is_empty() \
		and not _mask_offenders("x.gd", "\tq.collision_mask = SOME_UNKNOWN").is_empty() \
		and _mask_offenders("x.gd", "\tq.collision_mask = 4 | 2").is_empty()
	# 2. SHE WALKS STRAIGHT THROUGH A HOUND'S SPOT. A fallen hound holds still, on
	# its own layer, so it can be parked on her path; the walk is timed against
	# the same walk with the path clear.
	var a := Vector3(-15.5, 0, -2.0)
	var b := Vector3(-10.5, 0, -2.0)
	var h1 := _h(0)
	_fell(h1)
	h1.global_position = Vector3(-16.0, 0, 5.0)
	_place_player(a)
	await _phys(2)
	var clear_frames := await _walk_to(b, null)
	_place_player(a)
	_fell(h1)
	h1.global_position = (a + b) * 0.5
	await _phys(2)
	var through := {"min": INF}
	var through_frames := await _walk_to(b, h1, through)
	var she_passes := clear_frames > 0 and absi(through_frames - clear_frames) <= 1 and float(through["min"]) <= 0.10
	# 3. AN ENEMY WALKS STRAIGHT THROUGH A HOUND'S SPOT.
	await _reset_review()
	_place_player(Vector3(-13.0, 0, 1.0))
	var q := _probe("B16_walker", Vector3(-13.0, 0, -5.0), 1000000.0, false)
	var h2 := _h(1)
	_fell(h2)
	h2.global_position = Vector3(-13.0, 0, -2.2)
	var enemy_min := INF
	var g := 0
	while g < 300 and _planar(q.global_position, player.global_position) > ProdConfig.ENEMY_ATTACK_RANGE_M + 0.05:
		await physics_frame
		g += 1
		if h2.is_fallen():
			enemy_min = minf(enemy_min, _planar(q.global_position, h2.global_position))
	var enemy_passes := _planar(q.global_position, player.global_position) <= ProdConfig.ENEMY_ATTACK_RANGE_M + 0.05 and enemy_min <= 0.15
	await _clear_probes()
	# 4. NAVIGATION: baked once, unchanged, and no hound carries an agent or obstacle.
	var nav_now := NavService.measure_mesh(arena.nav_mesh())
	var nav0: Dictionary = launch["nav"]
	var nav_ok := arena.bake_count == 1 and int(launch["bake_count"]) == 1 \
		and int(nav_now["polygons"]) == int(nav0["polygons"]) and is_equal_approx(float(nav_now["area"]), float(nav0["area"]))
	var nav_nodes: Array[String] = []
	var st2: Array = [hounds]
	while not st2.is_empty():
		var n2: Node = st2.pop_back()
		if n2 is NavigationAgent3D or n2 is NavigationObstacle3D or n2 is NavigationRegion3D:
			nav_nodes.append(String(n2.name))
		st2.append_array(n2.get_children())
	# 5. PROJECTILES: no hound is registered, so no arrow can Hit one; and a Splinter
	# Shot fired THROUGH a hound's body reaches the enemy behind it.
	#
	# RE-SCOPED UNDER D-398, one for one. Until D-398 this required "hounds
	# registered as combat entities: 0" -- TRUE WHEN WRITTEN (D-396 left them
	# unregistered). The D-398 ruling makes stable combat-entity IDs decide the
	# cohort's slots, so each hound IS registered -- as an ALLY. The property the
	# count stood for is asserted directly and is AT LEAST AS STRONG: every hound is
	# registered as category and faction "ally", and the GENERAL eligibility rule
	# refuses every one ("not hostile") -- so no arrow can Hit one. The arrow fired
	# through a hound's body below is unchanged.
	await _reset_review()
	var registered := 0
	var refused_allies := 0
	for h in hounds.pack:
		var rec := hr.registry.record_of(h as Node)
		if not rec.is_empty():
			registered += 1
			if String(rec["faction"]) == "ally" and String(rec["category"]) == "ally" \
					and not bool(HitEligibility.evaluate(rec)["eligible"]) \
					and String(HitEligibility.evaluate(rec)["reason"]).find("not hostile") == 0:
				refused_allies += 1
	var h3 := _h(0)
	_place_player(Vector3(-16.0, 0, 2.0))
	_fell(h3)
	h3.global_position = Vector3(-14.0, 0, 2.0)
	var p := _probe("B16_behind", Vector3(-11.5, 0, 2.0))
	var falls0 := h3.falls
	var hits0 := h3.life.hits_taken
	var before := hr.arrows_released
	cam.debug_cursor_override = Vector3(-11.5, 0, 2.0)
	await _phys(3)
	var use := skills.use_binding(HuntressContent.BINDING_INDEX)
	var gg := 0
	while gg < 240 and (hr.arrows_released <= before or String(hr.last_outcome.get("use_id", "")) != hr.last_use_id):
		await physics_frame
		gg += 1
	var outcome := hr.last_outcome.duplicate()
	cam.debug_cursor_override = null
	var arrow_ok := bool(use["ok"]) and String(outcome.get("outcome", "")) == "hit" \
		and String(outcome.get("id", "")) == hr.registry.id_of(p) and h3.falls == falls0 and h3.life.hits_taken == hits0 \
		and registered == hounds.pack.size() and refused_allies == registered and registered == 2
	await _reset_review()
	var ok := layers_ok and maskers.is_empty() and bodies > 10 and code_maskers.is_empty() and scan_caught \
		and she_passes and enemy_passes and nav_ok and nav_nodes.is_empty() and arrow_ok
	_note("B16_hounds_obstruct_neither_her_enemies_navigation_nor_projectiles",
		"every hound on layer %d masking only the world (%d)=%s | of %d other bodies in the scene, those masking the hounds' layer: %s; mask assignments in runtime code that could: %s (the scan catches a planted '2 | 16' and an unknown name, and passes '4 | 2'=%s) | SHE WALKED 5 m in %d frames with the path clear and %d frames THROUGH a parked hound, passing %.3f m from its centre=%s | an ordinary enemy walked through a parked hound's spot, passing %.3f m from it, and reached its attack range of her=%s | navigation baked %d time(s), %d polygons / %.1f m^2 as at launch; navigation nodes under the pack: %s=%s | hounds registered as combat entities: %d, of which ALLIES the eligibility rule refuses: %d (D-398: registered for stable IDs; 0 until D-398); a Splinter Shot fired THROUGH a hound's body hit %s behind it, the hound untouched=%s"
		% [HoundConfig.COLLISION_LAYER, HoundConfig.COLLISION_MASK_WORLD, str(layers_ok), bodies, str(maskers), str(code_maskers), str(scan_caught),
		   clear_frames, through_frames, float(through["min"]), str(she_passes), enemy_min, str(enemy_passes),
		   arena.bake_count, int(nav_now["polygons"]), float(nav_now["area"]), str(nav_nodes), str(nav_ok),
		   registered, refused_allies, String(outcome.get("id", "")), str(arrow_ok)])
	_reached("B16_hounds_obstruct_neither_her_enemies_navigation_nor_projectiles")
	return ok

## She walks to `dest` by click-to-move; returns the frames until she stops
## there. When `watch` is given, records her closest planar approach to it.
func _walk_to(dest: Vector3, watch: Node3D, rec: Dictionary = {}) -> int:
	player.command_move_to(dest)
	var g := 0
	var moved := false
	while g < 300:
		await physics_frame
		g += 1
		if watch != null:
			rec["min"] = minf(float(rec.get("min", INF)), _planar(player.global_position, watch.global_position))
		if player.motor.speed() > 0.1:
			moved = true
		elif moved and _planar(player.global_position, dest) < 0.4:
			return g
	return -1

const PUBLIC_HOUND_METHODS := ["setup", "state_name", "is_fallen", "target_id", "ground_point", "step", "think",
	"follow_slot", "receive_damage", "revive_at"]

static func _public_methods(scr: Script) -> Array:
	var out: Array = []
	for m in scr.get_script_method_list():
		var n := String(m["name"])
		if not n.begins_with("_") and not out.has(n):
			out.append(n)
	out.sort()
	return out

## Assignments to `target` that SET it (anything but `{}`) outside `think()`.
static func _target_setters(code: String) -> Array:
	var out: Array = []
	var think := _function_body(code, "think")
	var re := RegEx.new()
	re.compile("(?m)^\\s*target\\s*=\\s*(.+)$")
	for m in re.search_all(code):
		var rhs := m.get_string(1).strip_edges()
		if rhs == "{}":
			continue
		if think.find(m.get_string(0).strip_edges()) < 0:
			out.append(m.get_string(0).strip_edges())
	return out

func chk_B17_no_command_path_reaches_a_hound() -> bool:
	# 1. NO INPUT ADDRESSES A HOUND except the diagnostic fall control.
	var addressed: Array[String] = []
	for a in InputMap.get_actions():
		var s := String(a).to_lower()
		if s.begins_with("ui_"):
			continue
		for w in ["hound", "kindred", "beast", "pet", "minion", "recall"]:
			if s.find(w) >= 0:
				addressed.append(String(a))
				break
	var inputs_ok := addressed.size() == 1 and addressed[0] == HoundConfig.FALL_ACTION
	var input_reads: Array[String] = []
	var ire := RegEx.new()
	ire.compile("\\bInput\\.")
	for f in _hound_script_files():
		for line in _code_only(_read_text(String(f))).split("\n"):
			if ire.search(String(line)) != null:
				input_reads.append("%s: %s" % [String(f).get_file(), String(line).strip_edges()])
	var reads_ok := input_reads.size() == 1 and input_reads[0].find("HoundConfig.FALL_ACTION") > 0
	# 2. NO PUBLIC COMMAND METHOD: the hound's public surface is exactly this list.
	var pub := _public_methods(load("res://scripts/hounds/kindred_hound.gd"))
	var want := PUBLIC_HOUND_METHODS.duplicate()
	want.sort()
	var surface_ok := _same(pub, want)
	var planted_pub := pub.duplicate()
	planted_pub.append("command_attack")
	planted_pub.sort()
	var surface_refuses := not _same(planted_pub, want)
	# 3. `target` IS CHOSEN ONLY IN think(); falling and returning only clear it.
	var kc := _code_only(_read_text("res://scripts/hounds/kindred_hound.gd"))
	var setters := _target_setters(kc)
	var chosen_in_think := _function_body(kc, "think").find("target = rec") >= 0
	var setter_caught := not _target_setters(kc + "\nfunc go_bite(r):\n\ttarget = picked_by_order\n").is_empty()
	# 4. NO PUBLIC FUNCTION TAKES A TARGET, DESTINATION OR ORDER. (Private steering
	# helpers -- `_steer_to(goal, ...)` -- are the hound's own, called only by it.)
	var sig := RegEx.new()
	sig.compile("(?m)^\\s*(?:static\\s+)?func\\s+([A-Za-z_0-9]+)\\(([^)]*)\\)")
	var bad_params: Array[String] = []
	for f in _hound_script_files():
		for m in sig.search_all(_code_only(_read_text(String(f)))):
			if m.get_string(1).begins_with("_"):
				continue
			for param in m.get_string(2).split(","):
				var pname := String(param).split(":")[0].split("=")[0].strip_edges().to_lower()
				if ["target", "new_target", "attack_target", "destination", "dest", "order", "command", "goal"].has(pname):
					bad_params.append("%s %s(%s)" % [String(f).get_file(), m.get_string(1), m.get_string(2).left(50)])
	var ok := inputs_ok and reads_ok and surface_ok and surface_refuses and setters.is_empty() and chosen_in_think \
		and setter_caught and bad_params.is_empty()
	_note("B17_no_command_path_reaches_a_hound",
		"input actions naming a hound, beast, pet, minion or recall: %s — only the diagnostic fall control=%s | input reads in the hound scripts: %s=%s | the hound's public methods are exactly %s=%s (a planted 'command_attack' is refused=%s) | assignments SETTING `target` outside think(): %s; think() is where it is chosen=%s; a planted setter is caught=%s | PUBLIC hound function parameters NAMED target, destination, order, command or goal: %s"
		% [str(addressed), str(inputs_ok), str(input_reads), str(reads_ok), str(pub), str(surface_ok), str(surface_refuses),
		   str(setters), str(chosen_in_think), str(setter_caught), str(bad_params)])
	_reached("B17_no_command_path_reaches_a_hound")
	return ok

# =============================================================================
# F. TARGETING — the accepted rule (D-394 ruling 3), and nothing else
# =============================================================================

func chk_B18_acquisition_membership_is_measured_from_the_huntress() -> bool:
	await _reset_review()
	# PURE: a geometry where "inside 6 m of HER" and "inside 6 m of the HOUND"
	# disagree. E1 is 1.5 m from the hound but 6.5 m from her; E2 is 4 m from her
	# and 9 m from the hound.
	var reg := CombatEntityRegistry.new("B18_PRIVATE_AREA")
	var her := T_BASE
	var hound_pos := T_BASE + Vector3(0, 0, -5.0)
	var e1 := _private_stub(reg, "B18_near_hound", T_BASE + Vector3(0, 0, -6.5))
	var e2 := _private_stub(reg, "B18_near_her", T_BASE + Vector3(0, 0, 4.0))
	var reach := Callable(self, "_reach_all")
	var d := HoundTargeting.decide({}, reg.records(), hound_pos, her, reg, reach)
	var chose := String((d["record"] as Dictionary).get("id", "")) == reg.id_of(e2)
	var c := HoundTargeting.choose(reg.records(), hound_pos, her, reg, reach)
	var refusal_says := str(c["refusals"]).find("outside the %.1f m acquisition range" % HoundConfig.ACQUISITION_RANGE_M) >= 0
	# THE NEGATIVE CONTROL: the same choice with membership measured from the
	# HOUND picks E1 -- so the two readings really disagree here.
	var planted := HoundTargeting.choose(reg.records(), hound_pos, hound_pos, reg, reach)
	var differs := String((planted["record"] as Dictionary).get("id", "")) == reg.id_of(e1)
	await _clear_probes()
	# LIVE: the same geometry in the area the hounds read, one think().
	_place_player(T_BASE)
	await _phys(2)
	var h1 := _h(0)
	h1.global_position = hound_pos
	var l1 := _stub("B18_live_near_hound", T_BASE + Vector3(0, 0, -6.5))
	var l2 := _stub("B18_live_near_her", T_BASE + Vector3(0, 0, 4.0))
	h1.think()
	var live := h1.target_id() == hr.registry.id_of(l2) and h1.target_id() != hr.registry.id_of(l1)
	await _reset_review()
	var ok := chose and refusal_says and differs and live
	_note("B18_acquisition_membership_is_measured_from_the_huntress",
		"an enemy 1.5 m from the hound but 6.5 m from HER is not a candidate; one 4 m from her and 9 m from the hound is chosen=%s, and the refusal names the %.1f m acquisition range=%s | NEGATIVE CONTROL: measured from the hound instead, the choice would have been the other enemy=%s | the live hound, one think() in the same geometry, chose the enemy near HER=%s"
		% [str(chose), HoundConfig.ACQUISITION_RANGE_M, str(refusal_says), str(differs), str(live)])
	_reached("B18_acquisition_membership_is_measured_from_the_huntress")
	return ok

func chk_B19_two_provisional_ranges_and_retention_inside_the_leash() -> bool:
	var ranges := HoundConfig.ACQUISITION_RANGE_M < HoundConfig.LEASH_RANGE_M \
		and is_equal_approx(HoundConfig.ACQUISITION_RANGE_M, 6.0) and is_equal_approx(HoundConfig.LEASH_RANGE_M, 9.0)
	var provisional := 0
	for row in HoundConfig.registry():
		var n := String(row[0])
		if (n.find("acquisition range") >= 0 or n.find("leash range") >= 0) and String(row[2]).find("PROVISIONAL") == 0:
			provisional += 1
	var reg := CombatEntityRegistry.new("B19_PRIVATE_AREA")
	var her := T_BASE
	var reach := Callable(self, "_reach_all")
	# 7.5 m from her: BETWEEN the ranges.
	var mid := _private_stub(reg, "B19_between", her + Vector3(0, 0, 7.5))
	var rec_mid := reg.record_of(mid)
	var kept := HoundTargeting.decide(rec_mid, reg.records(), her + Vector3(0, 0, 6.5), her, reg, reach)
	var kept_ok := String(kept["code"]) == HoundTargeting.RETAINED
	var fresh := HoundTargeting.decide({}, reg.records(), her + Vector3(0, 0, 6.5), her, reg, reach)
	var not_taken := String(fresh["code"]) == HoundTargeting.NONE
	# THE LEASH IS "WITHIN": 9.0 m is kept, a hair past it is not.
	mid.global_position = her + Vector3(0, 0, 9.0)
	var at_leash := bool(HoundTargeting.still_eligible_and_leashed(rec_mid, her)["valid"])
	mid.global_position = her + Vector3(0, 0, 9.05)
	var past := HoundTargeting.decide(rec_mid, reg.records(), her + Vector3(0, 0, 8.0), her, reg, reach)
	var past_ok := String(past["abandon_code"]) == HoundTargeting.ABANDONED_LEASH and String(past["code"]) == HoundTargeting.NONE
	await _clear_probes()
	var ok := ranges and provisional == 2 and kept_ok and not_taken and at_leash and past_ok
	_note("B19_two_provisional_ranges_and_retention_inside_the_leash",
		"acquisition %.1f m < leash %.1f m, both centred on her=%s, both registered PROVISIONAL (%d of 2) | a current target 7.5 m from her — outside acquisition, inside the leash — is RETAINED=%s, while the same enemy is NOT taken fresh=%s | 9.00 m is still within the leash=%s; 9.05 m is abandoned BEYOND THE LEASH=%s"
		% [HoundConfig.ACQUISITION_RANGE_M, HoundConfig.LEASH_RANGE_M, str(ranges), provisional, str(kept_ok), str(not_taken), str(at_leash), str(past_ok)])
	_reached("B19_two_provisional_ranges_and_retention_inside_the_leash")
	return ok

func chk_B20_nearest_is_measured_from_each_hound_and_two_hounds_split() -> bool:
	await _reset_review()
	# PURE NEGATIVE CONTROL: the enemy nearest HER is not the one nearest the hound.
	var reg := CombatEntityRegistry.new("B20_PRIVATE_AREA")
	var her := T_BASE
	var hound_pos := T_BASE + Vector3(0, 0, -4.0)
	var near_her := _private_stub(reg, "B20_near_her", T_BASE + Vector3(0, 0, 1.5))
	var near_hound := _private_stub(reg, "B20_near_hound", T_BASE + Vector3(1.0, 0, -4.5))
	var reach := Callable(self, "_reach_all")
	var d := HoundTargeting.decide({}, reg.records(), hound_pos, her, reg, reach)
	var from_hound := String((d["record"] as Dictionary).get("id", "")) == reg.id_of(near_hound) \
		and String(d["code"]) == HoundTargeting.ACQUIRED and String(d["text"]).find("nearest to this hound") >= 0
	var planted := HoundTargeting.choose(reg.records(), her, her, reg, reach)
	var differs := String((planted["record"] as Dictionary).get("id", "")) == reg.id_of(near_her)
	await _clear_probes()
	# LIVE: one enemy on each hound's side; each takes ITS OWN nearest.
	_place_player(T_BASE)
	await _phys(2)
	var h1 := _h(0)
	var h2 := _h(1)
	h1.global_position = T_BASE + Vector3(-2.0, 0, 0)
	h2.global_position = T_BASE + Vector3(2.0, 0, 0)
	var ea := _stub("B20_west", T_BASE + Vector3(-3.5, 0, 1.0))
	var eb := _stub("B20_east", T_BASE + Vector3(3.5, 0, 1.0))
	h1.think()
	h2.think()
	var split := h1.target_id() == hr.registry.id_of(ea) and h2.target_id() == hr.registry.id_of(eb) \
		and h1.reason_code == HoundTargeting.ACQUIRED and h2.reason_code == HoundTargeting.ACQUIRED
	var reason := h1.reason_text
	await _until(func() -> bool: return h1.state == KindredHound.State.BITE and h2.state == KindredHound.State.BITE, 240)
	var holding := h1.target_id() == hr.registry.id_of(ea) and h2.target_id() == hr.registry.id_of(eb) \
		and h1.state == KindredHound.State.BITE and h2.state == KindredHound.State.BITE
	await _reset_review()
	var ok := from_hound and differs and split and holding and reason.find("nearest to this hound") >= 0
	_note("B20_nearest_is_measured_from_each_hound_and_two_hounds_split",
		"the enemy nearest the HOUND is chosen, with the reason 'nearest to this hound'=%s | NEGATIVE CONTROL: measured from her, the other enemy would win=%s | live, one enemy each side: H1 took the west one and H2 the east one, each ACQUIRED=%s ('%s') | both then BITING their own=%s"
		% [str(from_hound), str(differs), str(split), reason.left(90), str(holding)])
	_reached("B20_nearest_is_measured_from_each_hound_and_two_hounds_split")
	return ok

func chk_B21_a_current_valid_target_is_retained_over_a_nearer_newcomer() -> bool:
	await _reset_review()
	var e0 := _stub("B21_first", T_BASE + Vector3(0, 0, 3.0))
	var id0 := hr.registry.id_of(e0)
	await _until(func() -> bool:
		var a := _h(0)
		return a != null and a.target_id() == id0 and a.state == KindredHound.State.BITE, 300)
	var h := _h(0)
	var engaged := h.target_id() == id0 and h.state == KindredHound.State.BITE
	# A NEWCOMER, placed NEARER to the hound than its target.
	var away := h.global_position - e0.global_position
	away.y = 0.0
	var e1 := _stub("B21_newcomer", h.global_position + away.normalized() * 0.5)
	var nearer := _planar(h.global_position, e1.global_position) < _planar(h.global_position, e0.global_position)
	var changes0 := h.target_changes
	await _phys(30)
	var kept := h.target_id() == id0 and h.reason_code == HoundTargeting.RETAINED and h.target_changes == changes0 \
		and h.thinks > 0
	# NEGATIVE CONTROL: with no current target the rule WOULD take the newcomer.
	var fresh := HoundTargeting.decide({}, hr.registry.records(), h.global_position, player.global_position,
		hr.registry, Callable(self, "_reach_all"))
	var would_switch := String((fresh["record"] as Dictionary).get("id", "")) == hr.registry.id_of(e1)
	await _reset_review()
	var ok := engaged and nearer and kept and would_switch
	_note("B21_a_current_valid_target_is_retained_over_a_nearer_newcomer",
		"H1 engaged and biting its target=%s | a newcomer placed NEARER to it=%s | 30 frames (over five re-evaluations) later it still holds its target, reason RETAINED, no target change=%s | NEGATIVE CONTROL: without a current target the rule takes the newcomer=%s"
		% [str(engaged), str(nearer), str(kept), str(would_switch)])
	_reached("B21_a_current_valid_target_is_retained_over_a_nearer_newcomer")
	return ok

func chk_B22_an_unreachable_enemy_is_refused_and_a_retained_one_abandoned() -> bool:
	await _reset_review()
	var her := Vector3(-16.0, 0, 0.0)
	_place_player(her)
	await _refresh_pack()
	var h1 := _h(0)
	# U stands INSIDE THE WEST WALL (the arena's own declared unreachable probe);
	# R stands on open floor. Both are inside 6 m of her; U is NEARER the hound.
	var u := _stub("B22_in_the_wall", Vector3(-20.5, 0, 0.0))
	var r := _stub("B22_open_floor", Vector3(-13.5, 0, 3.0))
	h1.global_position = Vector3(-17.8, 0, 0.0)
	var tol := HoundConfig.bite_distance(0.42)
	var ru := NavService.reachable(nav_map, h1.global_position, u.global_position, tol)
	var rr := NavService.reachable(nav_map, h1.global_position, r.global_position, tol)
	var geometry := not bool(ru["reachable"]) and bool(rr["reachable"]) \
		and _planar(h1.global_position, u.global_position) < _planar(h1.global_position, r.global_position) \
		and _planar(her, u.global_position) <= HoundConfig.ACQUISITION_RANGE_M
	h1.think()
	var refused := h1.target_id() == hr.registry.id_of(r)
	# NEGATIVE CONTROL: without the path test, U -- the nearest -- would be chosen.
	var blind := HoundTargeting.decide({}, hr.registry.records(), h1.global_position, her, hr.registry, Callable(self, "_reach_all"))
	var would_take_u := String((blind["record"] as Dictionary).get("id", "")) == hr.registry.id_of(u)
	# A RETAINED TARGET THAT BECOMES UNREACHABLE IS ABANDONED.
	await _until(func() -> bool: return h1.target_id() == hr.registry.id_of(r) and h1.state == KindredHound.State.BITE, 300)
	var biting := h1.target_id() == hr.registry.id_of(r)
	var ab0 := h1.abandonments
	r.global_position = Vector3(-20.5, 0, 2.0)
	var frames := await _until(func() -> bool: return h1.abandonments > ab0, 40)
	var abandoned := h1.abandonments == ab0 + 1 and h1.abandon_code == HoundTargeting.ABANDONED_UNREACHABLE \
		and h1.abandon_id == hr.registry.id_of(r) and h1.target_id() != hr.registry.id_of(r) \
		and frames <= int(ceil(HoundConfig.THINK_INTERVAL_S * TICKS)) + 1 \
		and _planar(her, r.global_position) <= HoundConfig.LEASH_RANGE_M
	await _reset_review()
	var ok := geometry and refused and would_take_u and biting and abandoned
	_note("B22_an_unreachable_enemy_is_refused_and_a_retained_one_abandoned",
		"measured by path: the enemy in the wall is UNREACHABLE (%s) and nearer the hound, the open-floor one reachable, both inside 6 m of her=%s | the hound chose the reachable one=%s | NEGATIVE CONTROL: without the path test it would have taken the one in the wall=%s | biting its target=%s, which was then moved into the wall — still inside the leash — and was ABANDONED as UNREACHABLE after %d frames (the re-evaluation cadence is %.2f s)=%s"
		% [String(ru["why"]), str(geometry), str(refused), str(would_take_u), str(biting), frames, HoundConfig.THINK_INTERVAL_S, str(abandoned)])
	_reached("B22_an_unreachable_enemy_is_refused_and_a_retained_one_abandoned")
	return ok

func chk_B23_an_exact_tie_goes_to_the_lower_combat_entity_id() -> bool:
	await _reset_review()
	var reach := Callable(self, "_reach_all")
	var p := Vector3(-13.0, 0, 0.0)
	var reg := CombatEntityRegistry.new("B23_PRIVATE_AREA")
	var s_first := _private_stub(reg, "B23_first", p + Vector3(2.0, 0, 0))
	var s_second := _private_stub(reg, "B23_second", p + Vector3(-2.0, 0, 0))
	var id_first := reg.id_of(s_first)
	var exact := _planar(p, s_first.global_position) == _planar(p, s_second.global_position)
	var d := HoundTargeting.decide({}, reg.records(), p, p, reg, reach)
	var tie_ok := String((d["record"] as Dictionary).get("id", "")) == id_first and String(d["code"]) == HoundTargeting.ACQUIRED_TIE \
		and (d["tie_ids"] as Array).size() == 2
	# REVERSED RECORD ORDER, and SWAPPED NAMES: the same winner.
	var rev := reg.records()
	rev.reverse()
	var d_rev := HoundTargeting.decide({}, rev, p, p, reg, reach)
	s_first.name = "zz_B23"
	s_second.name = "aa_B23"
	var d_names := HoundTargeting.decide({}, rev, p, p, reg, reach)
	var order_free := String((d_rev["record"] as Dictionary).get("id", "")) == id_first \
		and String((d_names["record"] as Dictionary).get("id", "")) == id_first
	# THE ID DECIDES: registered the other way round, the other entity wins.
	var reg2 := CombatEntityRegistry.new("B23_PRIVATE_AREA_2")
	reg2.register(s_second, "ordinary", "hostile")
	reg2.register(s_first, "ordinary", "hostile")
	var d2 := HoundTargeting.decide({}, reg2.records(), p, p, reg2, reach)
	var id_decides := String((d2["record"] as Dictionary).get("id", "")) == reg2.id_of(s_second)
	# EXACT, NO TOLERANCE: a hair nearer wins outright, whatever its ID.
	s_first.global_position = p + Vector3(2.001, 0, 0)
	var d_hair := HoundTargeting.decide({}, reg.records(), p, p, reg, reach)
	var no_tolerance := String((d_hair["record"] as Dictionary).get("id", "")) == reg.id_of(s_second) \
		and String(d_hair["code"]) == HoundTargeting.ACQUIRED
	await _clear_probes()
	# LIVE: the hound at an exact point, two enemies exactly 2 m either side.
	_place_player(Vector3(-13.0, 0, 3.0))
	await _phys(2)
	var h1 := _h(0)
	var ties0 := h1.ties_resolved
	var l_first := _stub("B23_live_first", Vector3(-11.0, 0, 0.0))
	var l_second := _stub("B23_live_second", Vector3(-15.0, 0, 0.0))
	h1.global_position = Vector3(-13.0, 0, 0.0)
	h1.think()
	var live := h1.target_id() == hr.registry.id_of(l_first) and h1.reason_code == HoundTargeting.ACQUIRED_TIE \
		and h1.ties_resolved == ties0 + 1 and hr.registry.precedes(hr.registry.id_of(l_first), hr.registry.id_of(l_second))
	await _reset_review()
	var ok := exact and tie_ok and order_free and id_decides and no_tolerance and live
	_note("B23_an_exact_tie_goes_to_the_lower_combat_entity_id",
		"two enemies at EXACTLY equal planar distance=%s: the lower combat-entity ID %s wins, code ACQUIRED (TIE)=%s | the same winner with the records reversed and the names swapped=%s | registered the other way round, the OTHER entity wins — the ID decides, not position, order or name=%s | EXACT: 1 mm nearer wins outright despite the higher ID=%s | live, one think() on an exact tie: the lower ID, counted as a resolved tie=%s"
		% [str(exact), id_first, str(tie_ok), str(order_free), str(id_decides), str(no_tolerance), str(live)])
	_reached("B23_an_exact_tie_goes_to_the_lower_combat_entity_id")
	return ok

const IDENTITY_TOKENS := "\\.name\\b|get_instance_id|get_index\\(|get_path\\(|get_children\\(|\\bhash\\(|get_rid\\(|instance_from_id|str\\(node|\"%s\" % node|\\.front\\(\\)|\\.back\\(\\)|\\[0\\]"

## Declared identifiers that name a MARK mechanic: a whole token `mark`,
## `marked`, `marks` or `marking` (CamelCase split first).
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

func chk_B24_the_choice_reads_no_order_name_identity_prey_or_mark() -> bool:
	var tc := _code_only(_read_text("res://scripts/hounds/hound_targeting.gd"))
	var kc := _code_only(_read_text("res://scripts/hounds/kindred_hound.gd"))
	var bodies := {
		"choose": _function_body(tc, "choose"), "decide": _function_body(tc, "decide"),
		"retain_check": _function_body(tc, "retain_check"),
		"still_eligible_and_leashed": _function_body(tc, "still_eligible_and_leashed"),
		"think": _function_body(kc, "think"), "_reachable": _function_body(kc, "_reachable"),
	}
	var re := RegEx.new()
	re.compile(IDENTITY_TOKENS)
	var hits: Array[String] = []
	var present := true
	for k in bodies.keys():
		var b := String(bodies[k])
		present = present and b.length() > 60
		var m := re.search(b)
		if m != null:
			hits.append("%s: %s" % [String(k), m.get_string()])
	var caught := re.search("\tvar n = rec.node.name") != null and re.search("\tbest = records[0]") != null
	var ignored := re.search(_code_only("\t# node.name was never read")) == null
	# NO PREY, ANYWHERE in a hound file -- comments included.
	var prey: Array[String] = []
	var marks: Array = []
	var mark_reads: Array[String] = []
	var huntress_reads: Array[String] = []
	var mr := RegEx.new()
	mr.compile("(?i)\\.mark(ed|s|ing)?\\b|\\bmarked_|\\bmark_|is_marked")
	for f in _hound_script_files():
		var full := _read_text(String(f))
		if full.to_lower().find("prey") >= 0:
			prey.append(String(f).get_file())
		for m2 in _mark_identifiers(full):
			marks.append("%s:%s" % [String(f).get_file(), String(m2)])
		if mr.search(_code_only(full)) != null:
			mark_reads.append(String(f).get_file())
	var hre := RegEx.new()
	hre.compile("HuntressRuntime|HuntressConfig|HuntressContent|\\bhuntress\\.|huntress_runtime")
	for f in ["res://scripts/hounds/hound_targeting.gd", "res://scripts/hounds/kindred_hound.gd"]:
		if hre.search(_code_only(_read_text(f))) != null:
			huntress_reads.append(f.get_file())
	var mark_caught := not _mark_identifiers("var marked_enemies := []").is_empty() and mr.search("\tif e.is_marked():") != null
	# THE RULE'S SIGNATURE HAS NO ROOM FOR A DESIGNATION: six parameters.
	var sig := RegEx.new()
	sig.compile("static func decide\\(([^)]*)\\)")
	var sm := sig.search(tc)
	var params := sm.get_string(1).split(",").size() if sm != null else -1
	var ok := present and hits.is_empty() and caught and ignored and prey.is_empty() and marks.is_empty() \
		and mark_reads.is_empty() and huntress_reads.is_empty() and mark_caught and params == 6
	_note("B24_the_choice_reads_no_order_name_identity_prey_or_mark",
		"the choice code (choose, decide, retain_check, the leash test, think, the path test) reads no node name, instance id, path, child index, hash, RID, first/last element or index 0: %s (a planted name read and a planted records[0] are caught=%s, a comment ignored=%s) | hound files mentioning Prey anywhere, comments included: %s | Mark identifiers %s and Mark reads %s (planted ones caught=%s) | the rule and the actor read nothing of the Huntress runtime: %s | the rule takes exactly %d parameters — current, records, two positions, the registry, the path test"
		% [str(hits), str(caught), str(ignored), str(prey), str(marks), str(mark_reads), str(mark_caught), str(huntress_reads), params])
	_reached("B24_the_choice_reads_no_order_name_identity_prey_or_mark")
	return ok

## The hound currently biting `id`, H1 first; null if none.
func _hound_on(id: String) -> KindredHound:
	for i in hounds.pack.size():
		var h := _h(i)
		if h != null and h.target_id() == id and h.state == KindredHound.State.BITE:
			return h
	return null

func chk_B25_a_target_crossing_the_leash_is_abandoned_on_that_step() -> bool:
	await _reset_review()
	var e := _stub("B25_target", Vector3(-15.5, 0, -3.0))
	var id := hr.registry.id_of(e)
	await _until(func() -> bool: return _hound_on(id) != null, 300)
	var h := _hound_on(id)
	var engaged := h != null
	if h == null:
		h = _h(0)
	var key := "h%d" % (h.index + 1)
	# SHE IS SET DOWN 10 m FROM IT: beyond the 9 m leash.
	var ab0 := h.abandonments
	_place_player(Vector3(-9.5, 0, 5.0))
	var beyond := _planar(player.global_position, e.global_position) > HoundConfig.LEASH_RANGE_M
	await physics_frame
	var same_step := h.abandonments == ab0 + 1 and h.abandon_code == HoundTargeting.ABANDONED_LEASH \
		and h.abandon_id == id and h.target.is_empty()
	# NOTHING ELSE INSIDE 6 m OF HER: it RETURNS to her, and says so.
	await physics_frame
	var says := String(hounds_hud.compose_lines()[key]).find("RETURNING TO HER") >= 0
	var d_far := _planar(h.global_position, player.global_position)
	var back := await _until(func() -> bool: return h.abandon_code == "" and _planar(h.global_position, player.global_position) <= HoundConfig.FOLLOW_DISTANCE_M + 0.6, 300)
	var returned := back < 300 and h.state == KindredHound.State.FOLLOW and d_far > 3.0
	# SECOND CASE: an eligible enemy waits inside 6 m of her NEW spot, so the same
	# step abandons the old target AND acquires it.
	_place_player(T_BASE)
	await _until(func() -> bool: return _hound_on(id) != null, 300)
	var h2 := _hound_on(id)
	var e2 := _stub("B25_waiting", Vector3(-10.5, 0, 6.5))
	var out_of_range_now := _planar(T_BASE, e2.global_position) > HoundConfig.ACQUISITION_RANGE_M
	var both_steps := false
	var reason := ""
	if h2 != null:
		var ab1 := h2.abandonments
		_place_player(Vector3(-9.5, 0, 5.0))
		await physics_frame
		reason = h2.reason_text
		both_steps = h2.abandonments == ab1 + 1 and h2.target_id() == hr.registry.id_of(e2) \
			and reason.find(HoundTargeting.ABANDONED_LEASH) >= 0 and reason.find("ACQUIRED") >= 0
	await _reset_review()
	var ok := engaged and beyond and same_step and says and returned and out_of_range_now and both_steps
	_note("B25_a_target_crossing_the_leash_is_abandoned_on_that_step",
		"%s biting its target=%s; she was set down %.1f m from it, beyond the %.1f m leash=%s | ONE physics step later the target was ABANDONED — BEYOND THE LEASH=%s | the HUD said 'RETURNING TO HER'=%s | from %.1f m away it came back to her and cleared the reason in %d frames=%s | with an eligible enemy waiting inside 6 m of her new spot (and outside it before), ONE step abandoned the old target AND acquired the new one=%s ('%s')"
		% [key.to_upper(), str(engaged), _planar(Vector3(-9.5, 0, 5.0), Vector3(-15.5, 0, -3.0)), HoundConfig.LEASH_RANGE_M, str(beyond),
		   str(same_step), str(says), d_far, back, str(returned), str(both_steps and out_of_range_now), reason.left(110)])
	_reached("B25_a_target_crossing_the_leash_is_abandoned_on_that_step")
	return ok

func chk_B26_no_boundary_oscillation_and_no_constant_switching() -> bool:
	await _reset_review()
	var her := T_BASE
	var reach := Callable(self, "_reach_all")
	# 1. THE ACQUISITION BOUNDARY: a target hovering across 6.0 m is KEPT.
	var e := _stub("B26_hover", her + Vector3(0, 0, 5.8))
	var id := hr.registry.id_of(e)
	await _until(func() -> bool: return _hound_on(id) != null, 300)
	var h := _hound_on(id)
	var hovered := false
	var held_acq := false
	var would_drop := false
	if h != null:
		var ch0 := h.target_changes
		for k in 20:
			e.global_position = her + Vector3(0, 0, 6.3 if k % 2 == 0 else 5.8)
			await _phys(6)
		hovered = true
		held_acq = h.target_id() == id and h.target_changes == ch0
		# NEGATIVE CONTROL: at 6.3 m a STATELESS choice would not take it.
		e.global_position = her + Vector3(0, 0, 6.3)
		var c := HoundTargeting.choose(hr.registry.records(), h.global_position, her, hr.registry, reach)
		would_drop = String((c["record"] as Dictionary).get("id", "")) != id
	# 2. THE LEASH BOUNDARY: abandoned beyond 9 m, it is NOT re-taken while it
	# hovers across 9 m -- only a return inside 6 m could bring it back.
	e.global_position = her + Vector3(0, 0, 9.3)
	await _phys(3)
	var dropped := true
	var acq0 := 0
	for i in hounds.pack.size():
		dropped = dropped and _h(i).target_id() != id
		acq0 += _h(i).acquisitions
	for k in 20:
		e.global_position = her + Vector3(0, 0, 8.8 if k % 2 == 0 else 9.3)
		await _phys(6)
	var acq1 := 0
	var retaken := false
	for i in hounds.pack.size():
		acq1 += _h(i).acquisitions
		retaken = retaken or _h(i).target_id() == id
	var held_leash := dropped and not retaken and acq1 == acq0
	e.global_position = her + Vector3(0, 0, 8.8)
	var band_matters := bool(HoundTargeting.still_eligible_and_leashed(hr.registry.record_of(e), her)["valid"])
	await _clear_probes()
	# 3. NO CONSTANT SWITCHING: a tight cluster of four, jittered for five seconds.
	await _reset_review()
	var offs := [Vector3(-0.5, 0, 3.0), Vector3(0.5, 0, 3.0), Vector3(-0.5, 0, 3.8), Vector3(0.5, 0, 3.8)]
	var cluster: Array = []
	for i in 4:
		cluster.append(_stub("B26_cluster_%d" % i, her + offs[i]))
	await _until(func() -> bool: return _h(0).state == KindredHound.State.BITE and _h(1).state == KindredHound.State.BITE, 300)
	var c0 := _h(0).target_changes + _h(1).target_changes
	var a0 := _h(0).abandonments + _h(1).abandonments
	var nearest_changes := 0
	var last_nearest := ["", ""]
	for f in 300:
		if f % 10 == 0:
			for i in 4:
				(cluster[i] as Node3D).global_position = her + offs[i] \
					+ Vector3(0.3 * sin(0.7 * float(f) + float(i)), 0, 0.3 * cos(0.9 * float(f) + 2.0 * float(i)))
			# EVERY OTHER TICK, a stub that is NOT H1's target is brought 0.55 m
			# from H1 -- nearer than its target -- and then goes back: the
			# stateless 'nearest' changes each time; retention must not.
			if (f / 10) % 2 == 1:
				var h1n := _h(0)
				for st in cluster:
					if hr.registry.id_of(st) != h1n.target_id():
						var side := Vector3(-(h1n.global_position - her).z, 0, (h1n.global_position - her).x).normalized()
						(st as Node3D).global_position = h1n.global_position + side * 0.55
						break
		await physics_frame
		for j in 2:
			var best := ""
			var bd := INF
			for s in cluster:
				var dd := _planar(_h(j).global_position, (s as Node3D).global_position)
				if dd < bd:
					bd = dd
					best = hr.registry.id_of(s)
			if last_nearest[j] != "" and best != last_nearest[j]:
				nearest_changes += 1
			last_nearest[j] = best
	var switches := _h(0).target_changes + _h(1).target_changes - c0
	var events := _h(0).abandonments + _h(1).abandonments - a0
	var steady := switches <= events and switches == 0 and nearest_changes > 3
	await _reset_review()
	var ok := hovered and held_acq and would_drop and held_leash and band_matters and steady
	_note("B26_no_boundary_oscillation_and_no_constant_switching",
		"a target hovering between 5.8 and 6.3 m of her for 120 frames was KEPT with no target change=%s — NEGATIVE CONTROL: a stateless choice at 6.3 m would drop it=%s | abandoned at 9.3 m, then hovering between 8.8 and 9.3 m for 120 frames, it was NOT re-taken=%s — while inside 8.8 m a CURRENT target would still be retained, so the 3 m band is what decides=%s | a tight cluster of four, jittered for 300 frames: the stateless 'nearest' changed %d times, the hounds switched target %d times against %d real events=%s"
		% [str(held_acq), str(would_drop), str(held_leash), str(band_matters), nearest_changes, switches, events, str(steady)])
	_reached("B26_no_boundary_oscillation_and_no_constant_switching")
	return ok

func chk_B27_ineligible_entities_are_never_chosen() -> bool:
	await _reset_review()
	var her := T_BASE
	var dead := _stub("B27_dead", her + Vector3(-1.5, 0, 2.0))
	dead.dead = true
	var ally := _stub("B27_ally", her + Vector3(1.5, 0, 2.0), "ally", "ally")
	var unt := _stub("B27_untargetable", her + Vector3(0, 0, 2.5))
	unt.targetable = false
	var inv := _stub("B27_invulnerable", her + Vector3(-1.0, 0, 3.5))
	inv.invulnerable = true
	var nor := StubNoReceiver.new()
	nor.name = "B27_no_receiver"
	main.add_child(nor)
	nor.global_position = her + Vector3(1.0, 0, 3.5)
	hr.registry.register(nor, "ordinary", "hostile")
	probes.append(nor)
	var dying := _probe("B27_dying", her + Vector3(0, 0, 4.5), 10.0)
	dying.receive_damage(100.0, her)
	await _phys(30)
	var none := _h(0).target.is_empty() and _h(1).target.is_empty() \
		and dead.hits + ally.hits + unt.hits + inv.hits == 0 and dying.is_dead()
	var c := HoundTargeting.choose(hr.registry.records(), _h(0).global_position, her, hr.registry, Callable(self, "_reach_all"))
	var why := str(c["refusals"])
	var reasons := why.find("not alive") >= 0 and why.find("not hostile") >= 0 and why.find("untargetable") >= 0 \
		and why.find("invulnerable") >= 0 and why.find("no Hit receiver") >= 0
	# THE REFUSAL WAS THE PROPERTY: made targetable, it is taken at once.
	unt.targetable = true
	var took := await _until(func() -> bool: return _h(0).target_id() == hr.registry.id_of(unt) or _h(1).target_id() == hr.registry.id_of(unt), 30)
	var flipped := took < 30
	await _clear_probes()
	# NO RARITY PREFERENCE: an Elite, a boss and an ordinary enemy are chosen by
	# distance alone.
	var reg := CombatEntityRegistry.new("B27_PRIVATE_AREA")
	var hp := her
	var boss := StubEntity.new()
	main.add_child(boss)
	boss.global_position = hp + Vector3(0, 0, 3.0)
	reg.register(boss, "boss", "hostile")
	var ordinary := StubEntity.new()
	main.add_child(ordinary)
	ordinary.global_position = hp + Vector3(0, 0, 2.0)
	reg.register(ordinary, "ordinary", "hostile")
	var elite := StubEntity.new()
	main.add_child(elite)
	elite.global_position = hp + Vector3(0, 0, 4.0)
	reg.register(elite, "elite", "hostile")
	probes.append_array([boss, ordinary, elite])
	var r1 := HoundTargeting.decide({}, reg.records(), hp, hp, reg, Callable(self, "_reach_all"))
	ordinary.global_position = hp + Vector3(0, 0, 5.0)
	var r2 := HoundTargeting.decide({}, reg.records(), hp, hp, reg, Callable(self, "_reach_all"))
	var by_distance := String((r1["record"] as Dictionary).get("id", "")) == reg.id_of(ordinary) \
		and String((r2["record"] as Dictionary).get("id", "")) == reg.id_of(boss)
	await _reset_review()
	var ok := none and reasons and flipped and by_distance
	_note("B27_ineligible_entities_are_never_chosen",
		"the dead, an ally, the untargetable, the invulnerable, one with no Hit receiver and a real enemy from its first DYING frame, all close to the pack: for 30 frames no hound took any, and none was bitten=%s | each refused with its reason (%s)=%s | made targetable, the same stub was taken within %d frames — the property was the refusal=%s | NO RARITY PREFERENCE: an ordinary enemy nearer than a boss is chosen, and moved behind it the boss is chosen=%s"
		% [str(none), why.left(160), str(reasons), took, str(flipped), str(by_distance)])
	_reached("B27_ineligible_entities_are_never_chosen")
	return ok

# =============================================================================
# G. BITES — through the enemy's own Hit receiver, every number PROVISIONAL
# =============================================================================

func chk_B28_bites_land_in_reach_at_the_interval_through_the_hit_receiver() -> bool:
	await _reset_review()
	var p := _probe("B28_target", T_BASE + Vector3(0, 0, 3.0))
	var reach := HoundConfig.bite_distance(ProdConfig.ENEMY_BODY_RADIUS)
	var led0 := float(SkillRuntime.ledger().get(HoundConfig.LEDGER_SOURCE, 0.0))
	var dmg0 := p.life.total_damage
	var hits0 := p.life.hits_taken
	var b0 := [_h(0).bites, _h(1).bites]
	var last := b0.duplicate()
	var frames := [[], []]
	var worst := 0.0
	var engaged_far := 0
	for f in 420:
		await physics_frame
		for j in 2:
			var h := _h(j)
			var d := _planar(h.global_position, p.global_position)
			if h.bites > int(last[j]):
				(frames[j] as Array).append(Engine.get_physics_frames())
				worst = maxf(worst, d)
				last[j] = h.bites
			elif h.state == KindredHound.State.ENGAGE and d > reach:
				engaged_far += 1
	var total := int(last[0]) - int(b0[0]) + int(last[1]) - int(b0[1])
	var expect_gap := int(round(HoundConfig.BITE_INTERVAL_S * TICKS))
	var gaps: Array = []
	for j in 2:
		var fr: Array = frames[j]
		for i in range(1, fr.size()):
			gaps.append(int(fr[i]) - int(fr[i - 1]))
	var gaps_ok := gaps.size() >= 6
	for g in gaps:
		gaps_ok = gaps_ok and int(g) >= expect_gap and int(g) <= expect_gap + 1
	var in_reach := total > 0 and worst <= reach + 0.05 and engaged_far > 0
	var dmg := p.life.total_damage - dmg0
	var value := HoundConfig.bite_damage_at(hounds.configuration().skill_rank())
	var hits := p.life.hits_taken - hits0
	var through := is_equal_approx(dmg, value * float(total)) and hits == total
	var led := float(SkillRuntime.ledger().get(HoundConfig.LEDGER_SOURCE, 0.0)) - led0
	var ledger_ok := is_equal_approx(led, dmg) and HoundConfig.LEDGER_SOURCE == "kindred_hound"
	var plain := is_equal_approx(_h(0).bite_damage, value) and is_equal_approx(_h(1).bite_damage, value) \
		and is_equal_approx(value, HoundConfig.BITE_DAMAGE_AT_RANK_1)
	await _reset_review()
	var ok := in_reach and gaps_ok and through and ledger_ok and plain
	_note("B28_bites_land_in_reach_at_the_interval_through_the_hit_receiver",
		"%d bites in 420 frames, the farthest landing %.3f m from the enemy's centre against a bite distance of %.3f m, and none while a hound was still closing (%d frames engaged out of reach)=%s | the gaps between one hound's bites: %s frames, every one %d-%d (the PROVISIONAL %.2f s)=%s | the enemy's own Hit receiver took %.1f damage in %d hits = %d x %.1f=%s | the damage ledger credits '%s' with the same %.1f=%s | each bite is the registry value at rank, nothing added=%s"
		% [total, worst, reach, engaged_far, str(in_reach), str(gaps), expect_gap, expect_gap + 1, HoundConfig.BITE_INTERVAL_S, str(gaps_ok),
		   dmg, hits, total, value, str(through), HoundConfig.LEDGER_SOURCE, led, str(ledger_ok), str(plain)])
	_reached("B28_bites_land_in_reach_at_the_interval_through_the_hit_receiver")
	return ok

func chk_B29_the_pack_kills_without_input_and_the_award_is_once() -> bool:
	await _reset_review()
	var lib := skills.library
	# ONE OF THE SCENE'S OWN ENEMIES -- the ones the accepted award path watches.
	var e: OrdinaryEnemy = enemies[3]
	e.life = Damageable.new(20.0)
	e.global_position = T_BASE + Vector3(0, 0, 3.0)
	var awards0 := lib.awards
	var units0 := lib.total_progress_units(K)
	var uses0 := skills.skill_uses
	var bites0 := _pack_bites()
	var t := await _until(func() -> bool: return e.is_dead(), 900)
	await _phys(5)
	var killed := e.is_dead() and t < 900
	var bites := _pack_bites() - bites0
	var awarded_once := lib.awards == awards0 + 1 and lib.total_progress_units(K) > units0
	var units1 := lib.total_progress_units(K)
	await _phys(60)
	var no_repeat := lib.awards == awards0 + 1 and is_equal_approx(lib.total_progress_units(K), units1)
	var by_bites := e.life.hits_taken == bites and bites >= 2
	var no_input := skills.skill_uses == uses0 and player.intent.seams_clear() and cam.debug_cursor_override == null
	e.global_position = Vector3(9.0, 0, -5.0 + 1.3 * 3.0)
	await _reset_review()
	var ok := killed and awarded_once and no_repeat and by_bites and no_input
	_note("B29_the_pack_kills_without_input_and_the_award_is_once",
		"the pack killed an enemy in %d frames=%s, with %d bites and ONLY bites (its Hit receiver counted %d)=%s | ZERO Skill Uses and no input seam — nothing but the hounds acted=%s | the accepted award path fired ONCE for the kill and Kindred Hounds gained progress (%.0f -> %.0f units)=%s, and never again in 60 frames=%s — combat XP per kill, never per bite. The minion-primary STRUCTURE; not balance."
		% [t, str(killed), bites, e.life.hits_taken, str(by_bites), str(no_input), units0, units1, str(awarded_once), str(no_repeat)])
	_reached("B29_the_pack_kills_without_input_and_the_award_is_once")
	return ok

const ENEMY_SCRIPT_SHA256 := "bc77f3aaeb79b1948b4f031c099111ef961df8a9b6284464ac6cb18be535619e"

func chk_B30_ordinary_enemies_never_select_or_damage_a_hound() -> bool:
	await _reset_review()
	var q := _probe("B30_attacker", T_BASE + Vector3(0, 0, 3.2), 1000000.0, false)
	var h1 := _h(0)
	var h2 := _h(1)
	var st := {"commits": 0, "inside": 0}
	var pl := player
	# AT EVERY COMMIT, a hound is put INSIDE the swipe, between the enemy and her.
	q.committed.connect(func() -> void:
		st["commits"] = int(st["commits"]) + 1
		var mid: Vector3 = q.global_position + (pl.global_position - q.global_position) * 0.5
		mid.y = 0.0
		h1.global_position = mid
		if q.telegraph.contains(mid):
			st["inside"] = int(st["inside"]) + 1)
	var her_hits0 := player.life.hits_taken
	var hh0 := [h1.life.hits_taken, h2.life.hits_taken]
	var only_her := true
	for f in 420:
		await physics_frame
		only_her = only_her and q.player == player
	var fired := int(st["commits"]) >= 1 and int(st["inside"]) >= 1 and player.life.hits_taken > her_hits0
	var untouched := h1.life.hits_taken == int(hh0[0]) and h2.life.hits_taken == int(hh0[1]) \
		and is_equal_approx(h1.life.life, HoundConfig.LIFE) and is_equal_approx(h2.life.life, HoundConfig.LIFE) \
		and h1.falls == 0 and h2.falls == 0
	var refs: Array[String] = []
	for pr in q.get_property_list():
		var v = q.get(String(pr["name"]))
		if v is KindredHound:
			refs.append(String(pr["name"]))
	var sha := FileAccess.get_sha256("res://scripts/combat/ordinary_enemy.gd") == ENEMY_SCRIPT_SHA256
	await _reset_review()
	var ok := only_her and fired and untouched and refs.is_empty() and sha
	_note("B30_ordinary_enemies_never_select_or_damage_a_hound",
		"an unfrozen enemy fought for 420 frames and its one target was HER throughout=%s | it committed %d swipe(s), %d with a hound placed INSIDE the swipe, and hit HER=%s | both hounds took ZERO hits and stayed at full Life=%s | the enemy holds no reference to a hound: %s | ordinary_enemy.gd is byte-identical to the pre-work baseline — no aggro, attack or hazard added=%s"
		% [str(only_her), int(st["commits"]), int(st["inside"]), str(fired), str(untouched), str(refs), str(sha)])
	_reached("B30_ordinary_enemies_never_select_or_damage_a_hound")
	return ok

# =============================================================================
# I. FALLEN-HOUND RECOVERY — canon's low-friction model
# =============================================================================

func chk_B31_a_fallen_hound_returns_after_the_delay_at_full_life() -> bool:
	await _reset_review()
	var h1 := _h(0)
	var s := _stub("B31_nearby", T_BASE + Vector3(0, 0, 2.5))
	await _until(func() -> bool: return h1.state == KindredHound.State.BITE, 300)
	var life_ok := is_equal_approx(h1.life.max_life, HoundConfig.LIFE) and is_equal_approx(h1.life.life, HoundConfig.LIFE)
	var returns0 := hounds.returns
	var bites_down := h1.bites
	# IT FALLS: through its own damage path.
	h1.receive_damage(HoundConfig.LIFE, h1.global_position, "B31 test fall")
	var fell := h1.is_fallen() and h1.target.is_empty() and h1.falls == 1
	await physics_frame
	var frames := 1
	var returning := hounds.returning_count() == 1 and hounds.living_count() == 1
	var inert := true
	while hounds.returns == returns0 and frames < 400:
		inert = inert and (not h1.is_fallen() or (h1.target.is_empty() and h1.bites == bites_down))
		await physics_frame
		frames += 1
	var expected := int(round(HoundConfig.RECOVERY_DELAY_S * TICKS))
	var on_time := absi(frames - expected) <= 1
	var back := not h1.is_fallen() and is_equal_approx(h1.life.life, HoundConfig.LIFE) \
		and _planar(h1.global_position, player.global_position) <= HoundConfig.FOLLOW_DISTANCE_M + 0.5 \
		and hounds.living_count() == 2 and hounds.returning_count() == 0 and is_same(h1, _h(0))
	var d_back := _planar(h1.global_position, player.global_position)
	# BOTH DOWN -> BOTH RETURN.
	var r1 := hounds.returns
	_fell(_h(0))
	_fell(_h(1))
	await physics_frame
	var both_down := hounds.living_count() == 0 and hounds.returning_count() == 2
	var t2 := await _until(func() -> bool: return hounds.returns >= r1 + 2, 400)
	var both_back := t2 < 400 and hounds.living_count() == 2 and hounds.returning_count() == 0
	await _reset_review()
	var ok := life_ok and fell and returning and inert and on_time and back and both_down and both_back
	_note("B31_a_fallen_hound_returns_after_the_delay_at_full_life",
		"hounds have %.0f Life (PROVISIONAL)=%s | H1 fell through its own damage path, target dropped=%s; the pack showed 1 living / 1 returning=%s; while down it neither targeted nor bit=%s | it returned after %d physics frames against %d (the PROVISIONAL %.1f s, +/- 1)=%s, at full Life, %.2f m from her, the same hound=%s | both down (0 living, 2 returning)=%s -> both back=%s"
		% [HoundConfig.LIFE, str(life_ok), str(fell), str(returning), str(inert), frames, expected, HoundConfig.RECOVERY_DELAY_S, str(on_time),
		   d_back, str(back), str(both_down), str(both_back)])
	_reached("B31_a_fallen_hound_returns_after_the_delay_at_full_life")
	return ok

func chk_B32_recovery_is_low_friction_and_the_pack_keeps_working() -> bool:
	await _reset_review()
	var s := _stub("B32_nearby", T_BASE + Vector3(0, 0, 2.5))
	var id := hr.registry.id_of(s)
	await _until(func() -> bool: return _h(1).target_id() == id and _h(1).state == KindredHound.State.BITE, 300)
	var h1 := _h(0)
	var h2 := _h(1)
	var pool := skills.pool
	var spends0 := pool.spends
	var mana_res0 := pool.mana_reserved
	var life_res0 := pool.life_reserved
	var reval0 := skills.loadout.revalidations
	var summons0 := hounds.summons
	var uses0 := skills.skill_uses
	var returns0 := hounds.returns
	var h2b0 := h2.bites
	_fell(h1)
	var sustained := true
	var seams := true
	var g := 0
	while hounds.returns == returns0 and g < 400:
		await physics_frame
		g += 1
		sustained = sustained and hounds.is_sustained() and hounds.pack.size() == 2
		seams = seams and player.intent.seams_clear()
	var returned := hounds.returns == returns0 + 1
	var friction_free := pool.spends == spends0 and is_equal_approx(pool.mana_reserved, mana_res0) \
		and is_equal_approx(pool.life_reserved, life_res0) and skills.loadout.revalidations == reval0 \
		and hounds.summons == summons0 and skills.skill_uses == uses0 and is_same(h1, _h(0))
	var h2_bites := h2.bites - h2b0
	var kept_working := h2_bites >= 3 and h2.target_id() == id
	await _reset_review()
	var ok := returned and friction_free and sustained and seams and kept_working
	_note("B32_recovery_is_low_friction_and_the_pack_keeps_working",
		"H1 fell and came back by itself=%s | in between: ZERO Mana spends, the reservation unchanged, ZERO revalidations, ZERO resummons, ZERO Skill Uses, the SAME hound returned=%s | no input seam was set=%s | the Persistent stayed sustained and the pack stayed two=%s | H2 kept biting through it (%d bites)=%s"
		% [str(returned), str(friction_free), str(seams), str(sustained), h2_bites, str(kept_working)])
	_reached("B32_recovery_is_low_friction_and_the_pack_keeps_working")
	return ok

func _project_actions() -> Array:
	var names: Array = []
	var in_input := false
	for line in _read_text("res://project.godot").split("\n"):
		var l := String(line)
		if l.begins_with("["):
			in_input = l == "[input]"
			continue
		if in_input and l.find("={") > 0:
			names.append(l.substr(0, l.find("={")))
	return names

func chk_B33_the_one_diagnostic_fall_control_is_real_labelled_and_not_a_command() -> bool:
	var names := _project_actions()
	# RE-SCOPED UNDER D-398, one for one: 27 + 2 = 29 -- the D-398 ruling's two
	# diagnostic stress-population and travel-speed modes, both named; the fall
	# control is still declared exactly once.
	var one_added := names.size() == 29 and names.has(HoundConfig.FALL_ACTION) and names.count(HoundConfig.FALL_ACTION) == 1 \
		and names.has("diagnostic_stress_population") and names.has("diagnostic_travel_speed")
	var keys := 0
	var pads := 0
	var other: Array[String] = []
	for ev in InputMap.action_get_events(HoundConfig.FALL_ACTION):
		if ev is InputEventKey and (ev as InputEventKey).physical_keycode == KEY_H:
			keys += 1
		elif ev is InputEventJoypadButton and (ev as InputEventJoypadButton).button_index == JOY_BUTTON_DPAD_LEFT:
			pads += 1
		else:
			other.append(str(ev))
	var bound := keys == 1 and pads == 1 and other.is_empty()
	var clashes: Array[String] = []
	for a in InputMap.get_actions():
		var s := String(a)
		if s == HoundConfig.FALL_ACTION or s.begins_with("ui_"):
			continue
		for ev in InputMap.action_get_events(a):
			if (ev is InputEventKey and (ev as InputEventKey).physical_keycode == KEY_H) \
					or (ev is InputEventJoypadButton and (ev as InputEventJoypadButton).button_index == JOY_BUTTON_DPAD_LEFT):
				clashes.append(s)
	await _reset_review()
	# THROUGH THE REAL INPUT PATH: a press on a physics frame.
	var f0 := hounds.diagnostic_falls
	var h1 := _h(0)
	var hits0 := h1.life.hits_taken
	await _press(HoundConfig.FALL_ACTION)
	var real := hounds.diagnostic_falls == f0 + 1 and h1.is_fallen() and not _h(1).is_fallen() \
		and h1.last_damage_source == HoundConfig.FALL_SOURCE and h1.life.hits_taken == hits0 + 1 and h1.falls == 1
	# The LOWEST-NUMBERED LIVING hound: the next press fells H2.
	await _press(HoundConfig.FALL_ACTION)
	var second := hounds.diagnostic_falls == f0 + 2 and _h(1).is_fallen()
	var labelled := HoundConfig.FALL_SOURCE.find("DIAGNOSTIC REVIEW CONTROL") == 0 and HoundConfig.FALL_SOURCE.find("not a command") > 0 \
		and String(hounds_hud.compose_lines()["controls"]).find("DIAGNOSTIC review control") >= 0
	var body := _function_body(_code_only(_read_text("res://scripts/hounds/hound_runtime.gd")), "diagnostic_fell_one")
	var not_command := body.find("receive_damage(") >= 0 and body.find("target") < 0 and body.find("think") < 0 \
		and body.find("command") < 0 and body.find("velocity") < 0 and body.find("global_position =") < 0
	await _reset_review()
	var ok := one_added and bound and clashes.is_empty() and real and second and labelled and not_command
	_note("B33_the_one_diagnostic_fall_control_is_real_labelled_and_not_a_command",
		"project.godot declares %d input actions, '%s' exactly once (26 + 1; + 2 under D-398)=%s | bound to key H and pad D-pad left, nothing else=%s; other actions on those inputs: %s | a REAL press felled H1 through its own damage path (source '%s')=%s; the next press felled H2, the lowest-numbered living hound=%s | labelled DIAGNOSTIC, 'not a command', in the registry and on the HUD=%s | its code only deals damage — no target, choice, command, velocity or position=%s"
		% [names.size(), HoundConfig.FALL_ACTION, str(one_added), str(bound), str(clashes), HoundConfig.FALL_SOURCE.left(40), str(real),
		   str(second), str(labelled), str(not_command)])
	_reached("B33_the_one_diagnostic_fall_control_is_real_labelled_and_not_a_command")
	return ok

# =============================================================================
# J. DEACTIVATION AND RESTORATION — the pack follows its Persistent
# =============================================================================

func chk_B34_unequipping_removes_the_pack_and_reequipping_restores_it() -> bool:
	await _reset_review()
	var lo := skills.loadout
	var inc0 := hounds.frames_inconsistent
	var smp0 := hounds.frames_sampled
	var a := [_h(0), _h(1)]
	# LIFE CONVERSION KEEPS THE PACK: the same Persistent, another resource.
	_cycle_to("LIFE CONVERSION")
	await physics_frame
	var life_keeps := hounds.pack.size() == 2 and is_same(_h(0), a[0]) and is_same(_h(1), a[1])
	# UNEQUIPPED BY THE CYCLE (LIFE -> OFF): gone on the next physics step.
	_cycle_to("OFF")
	await _one_runtime_step()
	var removed := hounds.pack.is_empty() and _kindred_nodes_in_tree() == 0 \
		and hounds.last_removal_reason.find("UNEQUIPPED") == 0 and String(hounds.persistent_state()["state"]) == "UNEQUIPPED"
	var none_while_off := true
	for f in 30:
		await physics_frame
		none_while_off = none_while_off and hounds.pack.is_empty() and _kindred_nodes_in_tree() == 0
	# RE-EQUIPPED: the whole pack, fresh, at her side.
	_cycle_to("MANA RESERVATION")
	await _one_runtime_step()
	var restored := hounds.pack.size() == 2 and hounds.living_count() == 2 and not is_same(_h(0), a[0])
	for h in hounds.pack:
		restored = restored and is_equal_approx((h as KindredHound).life.life, HoundConfig.LIFE) \
			and _planar((h as Node3D).global_position, player.global_position) <= HoundConfig.FOLLOW_DISTANCE_M + 0.35
	# THE OTHER UNEQUIP PATH: remove_persistent, through the accepted loadout.
	lo.remove_persistent(CFG_K)
	lo.revalidate(skills.pool)
	await _one_runtime_step()
	var removed2 := hounds.pack.is_empty() and hounds.last_removal_reason.find("UNEQUIPPED") == 0
	lo.add_persistent(CFG_K)
	lo.revalidate(skills.pool)
	await _one_runtime_step()
	var restored2 := hounds.pack.size() == 2
	# SAMPLED EVERY PHYSICS STEP BY THE RUNTIME: never a pack while inactive, never
	# none while active.
	var consistent := hounds.frames_inconsistent == inc0 and hounds.frames_sampled >= smp0 + 34
	await _reset_review()
	var ok := life_keeps and removed and none_while_off and restored and removed2 and restored2 and consistent
	_note("B34_unequipping_removes_the_pack_and_reequipping_restores_it",
		"LIFE CONVERSION kept the same two hounds=%s | the cycle to OFF UNEQUIPPED it and the pack was out of the tree on the next step, reason recorded=%s, and stayed gone for 30 frames=%s | the cycle back to MANA restored BOTH hounds, fresh, at full Life, at her side=%s | remove_persistent removed it too=%s and add_persistent restored it=%s | the runtime's own per-step sample: %d inconsistent frames of %d=%s"
		% [str(life_keeps), str(removed), str(none_while_off), str(restored), str(removed2), str(restored2),
		   hounds.frames_inconsistent - inc0, hounds.frames_sampled - smp0, str(consistent)])
	_reached("B34_unequipping_removes_the_pack_and_reequipping_restores_it")
	return ok

func chk_B35_losing_the_reservation_removes_the_pack_and_support_restores_it() -> bool:
	await _reset_review()
	var lo := skills.loadout
	var D := DiagImprintContent
	# TEST-ONLY SCRATCH PERSISTENTS reuse the learned aura Imprint (reuse without
	# duplicated progression is the accepted architecture) until the Persistent
	# Loadout can no longer support Kindred Hounds' reservation. Bindings are
	# emptied so Capacity is not what decides; Kindred Hounds go in LAST, so the
	# accepted revalidation deactivates them first.
	for i in lo.binding_count():
		lo.bind(i, "")
	lo.remove_persistent(CFG_K)
	var frac_k := HoundConfig.reserve_fraction_at(1)
	var scratch: Array[String] = []
	var sum := 0.0
	var k := 0
	while sum + frac_k < 1.0 and k < 10:
		var sid := "B35_SCRATCH_AURA_%d" % k
		var c := SkillConfiguration.new(sid, skills.library)
		c.set_skill(D.SKILL_AURA)
		var f := float(c.resolve()["reserve_fraction"])
		if sum + f >= 1.0:
			break
		skills.configurations[sid] = c
		lo.add_persistent(sid)
		scratch.append(sid)
		sum += f
		k += 1
	lo.add_persistent(CFG_K)
	lo.revalidate(skills.pool)
	await _one_runtime_step()
	var reason := String(lo.deactivated.get(CFG_K, ""))
	var lost := sum < 1.0 and sum + frac_k >= 1.0 and reason.find("RESERVATION UNSUPPORTABLE") == 0 \
		and hounds.pack.is_empty() and _kindred_nodes_in_tree() == 0 \
		and String(hounds.persistent_state()["state"]) == "DEACTIVATED" \
		and hounds.last_removal_reason.find("DEACTIVATED") == 0 and hounds.last_removal_reason.find("RESERVATION UNSUPPORTABLE") > 0
	var hud_says := String(hounds_hud.compose_lines()["persistent"]).find("DEACTIVATED") >= 0 \
		and String(hounds_hud.compose_lines()["pack"]).find("PACK none") == 0
	# SUPPORTED AGAIN: one scratch Persistent removed.
	lo.remove_persistent(scratch.back())
	lo.revalidate(skills.pool)
	await _one_runtime_step()
	var back := hounds.pack.size() == 2 and hounds.is_sustained() and not lo.deactivated.has(CFG_K)
	for sid in scratch:
		lo.remove_persistent(sid)
		skills.configurations.erase(sid)
	await _reset_review()
	# RE-SCOPED UNDER D-402, one for one: 8 + 1 = 9 Configurations.
	var clean := skills.configurations.size() == 9 and hounds.pack.size() == 2
	var ok := lost and hud_says and back and clean and scratch.size() >= 1
	_note("B35_losing_the_reservation_removes_the_pack_and_support_restores_it",
		"%d test-only scratch Persistents reserving %.1f%% of maximum Mana, plus Kindred Hounds' %.1f%%, exceed the pool: the ACCEPTED revalidation deactivated Kindred Hounds ('%s') and the pack left the tree, its reason recorded=%s | the HUD said DEACTIVATED and PACK none=%s | one scratch Persistent removed: supported again, both hounds back=%s | the scratch Configurations removed; 8 remain=%s"
		% [scratch.size(), sum * 100.0, frac_k * 100.0, reason.left(70), str(lost), str(hud_says), str(back), str(clean)])
	_reached("B35_losing_the_reservation_removes_the_pack_and_support_restores_it")
	return ok

func chk_B36_a_removal_during_recovery_leaves_nothing_pending() -> bool:
	await _reset_review()
	var lo := skills.loadout
	_fell(_h(0))
	await _one_runtime_step()
	var pending := hounds.recovery.size() == 1 and hounds.returning_count() == 1
	lo.remove_persistent(CFG_K)
	lo.revalidate(skills.pool)
	await _one_runtime_step()
	var cleared := hounds.pack.is_empty() and hounds.recovery.is_empty() and hounds.returning_count() == 0
	var r0 := hounds.returns
	await _phys(int(round(HoundConfig.RECOVERY_DELAY_S * TICKS)) + 10)
	var no_ghost := hounds.returns == r0 and hounds.pack.is_empty() and _kindred_nodes_in_tree() == 0
	lo.add_persistent(CFG_K)
	lo.revalidate(skills.pool)
	await _one_runtime_step()
	var whole := hounds.pack.size() == 2 and hounds.living_count() == 2 and hounds.returning_count() == 0 \
		and hounds.recovery.is_empty()
	for h in hounds.pack:
		whole = whole and not (h as KindredHound).is_fallen() and is_equal_approx((h as KindredHound).life.life, HoundConfig.LIFE)
	await _reset_review()
	var ok := pending and cleared and no_ghost and whole
	_note("B36_a_removal_during_recovery_leaves_nothing_pending",
		"a fallen hound was returning=%s | the Persistent was unequipped mid-recovery: pack AND timers cleared=%s | past the full delay nothing returned into the empty pack=%s | re-equipped: two living hounds at full Life, nothing pending=%s"
		% [str(pending), str(cleared), str(no_ghost), str(whole)])
	_reached("B36_a_removal_during_recovery_leaves_nothing_pending")
	return ok

# =============================================================================
# K. PRESENTATION — procedural stand-ins, presentation only
# =============================================================================

## The AABB of every mesh under `node`, in `frame`'s local space.
static func _local_aabb(node: Node, frame: Node3D) -> AABB:
	var out := AABB()
	var first := true
	var stack: Array = [node]
	var inv := frame.global_transform.affine_inverse()
	while not stack.is_empty():
		var n: Node = stack.pop_back()
		if n is MeshInstance3D and (n as MeshInstance3D).mesh != null and (n as MeshInstance3D).is_visible_in_tree():
			var a: AABB = inv * (n as MeshInstance3D).global_transform * (n as MeshInstance3D).get_aabb()
			out = a if first else out.merge(a)
			first = false
		stack.append_array(n.get_children())
	return out

func chk_B37_procedural_stand_ins_read_friend_or_foe_without_colour() -> bool:
	await _reset_review()
	var looks: Array = []
	for h in hounds.pack:
		for c in (h as Node).get_children():
			if c is HoundStandIn:
				looks.append(c)
	var one_each := looks.size() == 2
	var parts_ok := one_each
	var primitive_only := true
	var ring_ok := true
	var labels: Array[String] = []
	for look in looks:
		var sl := look as HoundStandIn
		var names: Array[String] = []
		for m in sl.body.get_children():
			names.append(String(m.name).rstrip("0123456789"))
		for want in ["Torso", "Head", "Snout", "EarL", "EarR", "Collar", "Tail"]:
			parts_ok = parts_ok and names.has(want)
		# Duplicate child names are made unique by the engine, so the four legs are
		# counted from the stand-in's own list, each a mesh under the body.
		var legs := 0
		for leg in sl.legs:
			if leg != null and leg.get_parent() == sl.body and leg.mesh is CylinderMesh:
				legs += 1
		parts_ok = parts_ok and legs == 4 and sl.name == "HoundStandIn_PLACEHOLDER"
		var stack: Array = [sl]
		while not stack.is_empty():
			var x: Node = stack.pop_back()
			if x is MeshInstance3D and x != sl.target_line:
				var mesh := (x as MeshInstance3D).mesh
				primitive_only = primitive_only and mesh is PrimitiveMesh and mesh.resource_path == ""
			stack.append_array(x.get_children())
		ring_ok = ring_ok and sl.ring.get_child_count() == HoundStandIn.RING_SEGMENTS and HoundStandIn.RING_SEGMENTS == 8
		labels.append(sl.label_text())
	var labels_ok := labels.size() == 2 and labels.has("H1") and labels.has("H2")
	var stand_in_label := HoundConfig.STAND_IN_LABEL.find("STAND-IN") == 0 and HoundConfig.STAND_IN_LABEL.find("NOT final art") > 0
	# FRIEND OR FOE WITHOUT COLOUR: the silhouette. The hound is LOW and LONG; the
	# ordinary enemy is UPRIGHT; only the hound wears a dashed ring.
	var hb := _local_aabb((looks[0] as HoundStandIn).body, looks[0] as Node3D) if one_each else AABB()
	var hound_len := maxf(hb.size.x, hb.size.z)
	var hound_ht := hb.size.y
	var e0: OrdinaryEnemy = enemies[0]
	var eb := _local_aabb(e0.visual, e0)
	var quadruped := hound_len > 1.2 * hound_ht and hound_ht < 1.0
	var upright := eb.size.y > 1.5 and eb.size.y > 1.5 * hound_ht
	var enemy_ringless := e0.find_child("AllyRing", true, false) == null
	# PRESENTATION ONLY, ON THE RENDER FRAME.
	var kc := _code_only(_read_text("res://scripts/hounds/kindred_hound.gd"))
	var sc := _code_only(_read_text("res://scripts/hounds/hound_stand_in.gd"))
	var mech_clean := kc.find("StandIn") < 0 and kc.find("Mesh") < 0 and kc.find("material") < 0 and kc.find("Label3D") < 0 \
		and sc.find("func _process(") >= 0 and sc.find("func _physics_process(") < 0 \
		and sc.find("load(") < 0 and sc.find("preload(") < 0
	var rc := _code_only(_read_text("res://scripts/hounds/hound_runtime.gd"))
	var look_uses: Array[String] = []
	var lre := RegEx.new()
	lre.compile("\\blook\\.[a-z_]+")
	for m in lre.search_all(rc):
		if not look_uses.has(m.get_string()):
			look_uses.append(m.get_string())
	look_uses.sort()
	var write_only := _same(look_uses, ["look.build", "look.returning_in"])
	# REMOVE A STAND-IN: the hound goes on choosing and biting.
	var s := _stub("B37_target", T_BASE + Vector3(0, 0, 2.5))
	var id := hr.registry.id_of(s)
	await _until(func() -> bool: return _h(0).target_id() == id and _h(0).state == KindredHound.State.BITE, 300)
	var h1 := _h(0)
	var t0 := h1.thinks
	var b0 := h1.bites
	for c in h1.get_children():
		if c is HoundStandIn:
			c.queue_free()
	await _phys(90)
	var mechanics_unmoved := h1.thinks > t0 and h1.bites > b0 and h1.target_id() == id
	await _reset_review()
	var ok := one_each and parts_ok and primitive_only and ring_ok and labels_ok and stand_in_label and quadruped and upright \
		and enemy_ringless and mech_clean and write_only and mechanics_unmoved
	_note("B37_procedural_stand_ins_read_friend_or_foe_without_colour",
		"one stand-in per hound, named PLACEHOLDER, built of a torso, head, snout, two ears, a collar, four legs and a tail=%s | every mesh an ENGINE PRIMITIVE, none loaded from a file=%s | an eight-dash ally ring=%s and the labels %s=%s | labelled '%s'=%s | WITHOUT COLOUR: the hound is %.2f m long and %.2f m tall (a low quadruped)=%s; the ordinary enemy stands %.2f m tall (upright)=%s; only the hound wears the dashed ring=%s | the mechanics never touch a mesh, material or label, and the stand-in runs on the render frame and loads nothing=%s | the runtime only builds it and writes its countdown: %s=%s | with a stand-in REMOVED, its hound kept choosing and biting=%s"
		% [str(parts_ok), str(primitive_only), str(ring_ok), str(labels), str(labels_ok), HoundConfig.STAND_IN_LABEL.left(40), str(stand_in_label),
		   hound_len, hound_ht, str(quadruped), eb.size.y, str(upright), str(enemy_ringless), str(mech_clean), str(look_uses), str(write_only), str(mechanics_unmoved)])
	_reached("B37_procedural_stand_ins_read_friend_or_foe_without_colour")
	return ok

# =============================================================================
# L. SURFACES AND THE REVIEW HUD
# =============================================================================

func chk_B38_launch_surfaces_hidden_and_both_review_huds_shown() -> bool:
	var at_launch := not bool(launch["overlay_enabled"]) and not bool(launch["overlay_visible"]) \
		and not bool(launch["panel_enabled"]) and not bool(launch["panel_visible"]) \
		and not bool(launch["d381_enabled"]) and not bool(launch["d381_visible"]) \
		and bool(launch["d392_enabled"]) and bool(launch["d392_visible"]) \
		and bool(launch["hounds_hud_enabled"]) and bool(launch["hounds_hud_visible"])
	# THE F1 / F2 TOGGLES ARE UNCHANGED, through the real input path.
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
	var still := hounds_hud.enabled and hounds_hud.visible and d392_hud.enabled and not review_hud.enabled
	var ok := at_launch and ov_on and ov_back and p_on and p_back and still
	_note("B38_launch_surfaces_hidden_and_both_review_huds_shown",
		"AT LAUNCH, captured before any check: the F1 overlay and the F2 panel hidden, the D-381 HUD hidden, the Splinter Shot HUD AND the Kindred Hounds HUD shown=%s | F1 toggles the overlay=%s and F2 the panel=%s, unchanged | afterwards both review HUDs still shown and the D-381 HUD still hidden=%s"
		% [str(at_launch), str(ov_on and ov_back), str(p_on and p_back), str(still)])
	_reached("B38_launch_surfaces_hidden_and_both_review_huds_shown")
	return ok

func _controls_under(n: Node, out: Array) -> void:
	for c in n.get_children():
		if c is Control:
			out.append(c)
		_controls_under(c, out)

func chk_B39_the_hound_hud_is_compact_clear_and_click_through() -> bool:
	await _reset_review()
	var saved_root_size := root.size
	root.size = Vector2i(1920, 1080)
	var ov_was := hud.enabled
	hud.set_enabled(true)
	hud.refresh()
	d392_hud.refresh()
	hounds_hud.refresh()
	for i in 4:
		await process_frame
	var view: Rect2 = hounds_hud.body.get_viewport_rect()
	var is_view := view.size == Vector2(1920, 1080) and view.position == Vector2.ZERO
	var r := hounds_hud.body_rect()
	var share := (r.size.x * r.size.y) / maxf(1.0, view.size.x * view.size.y)
	var centre := Rect2(view.size * 0.25, view.size * 0.5)
	var clear_centre := not r.intersects(centre)
	var player_px: Vector2 = cam.cam.unproject_position(player.global_position)
	var clear_player := not r.has_point(player_px)
	var ov_rect := (hud.get_node("OverlayPanel") as Control).get_global_rect()
	var clear_overlay := not r.intersects(ov_rect)
	var d392_rect := d392_hud.body_rect()
	var clear_d392 := not r.intersects(d392_rect)
	var inside := view.encloses(r) and r.size.x > 100.0 and r.size.y > 60.0
	var top_right := r.position.x > view.size.x * 0.5 and r.end.y < view.size.y * 0.5
	var ctrls: Array = []
	_controls_under(hounds_hud, ctrls)
	var eats: Array[String] = []
	var small: Array[String] = []
	for c in ctrls:
		if (c as Control).mouse_filter != Control.MOUSE_FILTER_IGNORE:
			eats.append(String((c as Control).name))
		if c is Label and (c as Label).get_theme_font_size("font_size") < 14:
			small.append(String((c as Label).name))
	var beneath := hounds_hud.layer < hud.layer and hounds_hud.layer < panel.layer
	var guard := Rect2(view.size * 0.4, Vector2(100, 100)).intersects(centre)
	hud.set_enabled(ov_was)
	root.size = saved_root_size
	for i in 2:
		await process_frame
	var ok := is_view and hounds_hud.visible and inside and top_right and share <= 0.12 and clear_centre and clear_player \
		and clear_overlay and clear_d392 and eats.is_empty() and small.is_empty() and ctrls.size() >= 8 and beneath and guard \
		and root.size == saved_root_size
	_finding("KINDRED HOUNDS HUD (MEASURED in the 1920 x 1080 review view): %s, %.1f%% of the screen, beside the Splinter Shot HUD at %s. Review tooling, NOT a UI foundation; size and place PROVISIONAL."
		% [str(r), share * 100.0, str(d392_rect)])
	_note("B39_the_hound_hud_is_compact_clear_and_click_through",
		"MEASURED IN THE 1920 x 1080 REVIEW VIEW=%s: the HUD at %s (inside=%s, top-right=%s) covers %.1f%% (<= 12%%) | clear of the central play area=%s, the player at %s=%s, the F1 overlay when shown (at %s)=%s and the Splinter Shot HUD (at %s)=%s | %d Controls, every one MOUSE_FILTER_IGNORE (offenders %s); no label under 14 px (offenders %s) | layer %d beneath the overlay's %d and the panel's %d=%s | the centre test refuses a planted central rectangle=%s | the headless root restored"
		% [str(is_view), str(r), str(inside), str(top_right), share * 100.0, str(clear_centre), str(player_px), str(clear_player),
		   str(ov_rect), str(clear_overlay), str(d392_rect), str(clear_d392), ctrls.size(), str(eats), str(small), hounds_hud.layer, hud.layer, panel.layer, str(beneath), str(guard)])
	_reached("B39_the_hound_hud_is_compact_clear_and_click_through")
	return ok

static func _numeric_literals(code: String) -> Array:
	var re := RegEx.new()
	re.compile("(?<![A-Za-z_0-9.])-?[0-9]+(\\.[0-9]+)?(?![A-Za-z_0-9])")
	var out: Array = []
	for m in re.search_all(_code_only(code)):
		out.append(float(m.get_string()))
	return out

func chk_B40_the_hound_hud_shows_only_the_ruling_reads_live_and_owns_no_number() -> bool:
	await _reset_review()
	# 1. IDENTITY, NOT COPIES.
	var same := is_same(hounds_hud.runtime, hounds) and is_same(hounds.skills, skills) and is_same(hounds.player, player)
	# 2. ONLY WHAT THE RULING NAMES: seven lines.
	var keys_ok := _same(HoundReviewHud.LINE_KEYS, ["title", "persistent", "reservation", "pack", "h1", "h2", "controls"])
	var t0 := hounds_hud.compose_lines()
	var content := String(t0["title"]).find("review tooling, NOT a UI foundation") > 0 \
		and String(t0["persistent"]).find("ACTIVE") >= 0 and String(t0["persistent"]).find("rank 1") >= 0 \
		and String(t0["reservation"]).find("RESERVES 20.0% of max Mana = 100") == 0 \
		and String(t0["pack"]) == "PACK 2 living · 0 returning" \
		and String(t0["controls"]).find("R") >= 0 and String(t0["controls"]).find("H") >= 0 \
		and String(t0["controls"]).find("DIAGNOSTIC review control") >= 0
	# 3. GAMEPLAY MOVES IT: a planted reservation, a fall, a target.
	var saved := skills.pool.mana_reserved
	skills.pool.mana_reserved = 123.0
	var planted_seen := String(hounds_hud.compose_lines()["reservation"]).find("usable Mana 377") > 0
	skills.pool.mana_reserved = saved
	skills.loadout.revalidate(skills.pool)
	var s := _stub("B40_target", T_BASE + Vector3(0, 0, 2.5))
	var id := hr.registry.id_of(s)
	await _until(func() -> bool: return _h(1).target_id() == id, 300)
	_fell(_h(0))
	await physics_frame
	var t1 := hounds_hud.compose_lines()
	var live := String(t1["pack"]) == "PACK 1 living · 1 returning" \
		and String(t1["h1"]).find("H1 FALLEN — returns by itself") == 0 \
		and String(t1["h2"]).find("H2 ") == 0 and String(t1["h2"]).find(id) > 0
	var snap := hounds.review_snapshot()
	var fields := int(snap["living"]) == hounds.living_count() and int(snap["returning"]) == hounds.returning_count() \
		and is_equal_approx(float(snap["mana_reserved"]), skills.pool.mana_reserved) and String(snap["state"]) == "ACTIVE"
	# 4. CONCISE: every drawn line within the layout limit.
	hounds_hud.refresh()
	var concise := true
	for line in hounds_hud.last_text.split("\n"):
		concise = concise and String(line).length() <= HoundReviewHud.MAX_LINE_CHARS
	# 5. IT OWNS NO NUMBER.
	var src := _code_only(_read_text("res://scripts/hounds/hound_review_hud.gd"))
	var text_code := _function_body(src, "compose_lines") + "\n" + _function_body(src, "_reason_line") + "\n" + _function_body(src, "_keys_of")
	var values: Array = [ImprintConfig.MANA_MAX, ImprintConfig.LIFE_MAX, ImprintConfig.MANA_REGEN_FRACTION_OF_UNRESERVED_PER_S]
	for row in HoundConfig.registry():
		values.append(float(row[1]))
	var literal_hits: Array = []
	for v in _numeric_literals(text_code):
		for gv in values:
			if is_equal_approx(float(v), float(gv)):
				literal_hits.append(v)
	var caught := false
	for v in _numeric_literals(text_code + "\n\tvar r := 6.0\n"):
		if is_equal_approx(float(v), HoundConfig.ACQUISITION_RANGE_M):
			caught = true
	var ignored := true
	for v in _numeric_literals(text_code + "\n\t# the range was 6.0 once\n"):
		if is_equal_approx(float(v), HoundConfig.ACQUISITION_RANGE_M):
			ignored = false
	await _reset_review()
	var ok := same and keys_ok and content and planted_seen and live and fields and concise \
		and literal_hits.is_empty() and caught and ignored and text_code.length() > 600
	_note("B40_the_hound_hud_shows_only_the_ruling_reads_live_and_owns_no_number",
		"the HUD reads the scene's own runtime, skills and player (identity)=%s | exactly seven lines — title, Persistent state, reservation, pack, H1, H2, controls=%s | it says 'review tooling, NOT a UI foundation', ACTIVE at rank 1, 20.0%% of max Mana = 100, 2 living, and names both review controls=%s | a planted reservation shows at once=%s; a fall and a target show as 'PACK 1 living · 1 returning', 'H1 FALLEN — returns by itself' and H2's target id=%s; every snapshot field equals its live source=%s | every drawn line <= %d characters=%s | the text-composing code holds no gameplay value as a literal (found %s) — a planted literal is caught=%s, a comment ignored=%s"
		% [str(same), str(keys_ok), str(content), str(planted_seen), str(live), str(fields), HoundReviewHud.MAX_LINE_CHARS, str(concise),
		   str(literal_hits), str(caught), str(ignored)])
	_reached("B40_the_hound_hud_shows_only_the_ruling_reads_live_and_owns_no_number")
	return ok

# =============================================================================
# M. SCOPE, PRESERVATION AND TRUTHFULNESS
# =============================================================================

## Pinned from the PRE-WORK state (the accepted D-392 suite's H54 pins, which the
## pre-flight run passed before any D-396 change): every numeric constant.
const PRE_WORK_PROD_DIGEST := "e32d753da863c656a8de6d6d12190b528e237453f77f0108d8dbf784d588ae83"
const PRE_WORK_PROD_COUNT := 70
const PRE_WORK_IMPRINT_DIGEST := "161b75e9997d6610a3f9d8fb66bb05d0220d19704fdf45ae9a1e797e19315d11"
const PRE_WORK_IMPRINT_COUNT := 112
## MEASURED AT D-396 DELIVERY, not from a pre-work copy (none survived the first
## act): D-396 changed only strings and row functions in huntress_config.gd, and
## the accepted D-392 suite still asserts its values one by one.
const DELIVERY_HUNTRESS_DIGEST := "d646a66c0dfdacd2f230c9bfe34253cc38f6a998c51a3bd0993ce86aab06824a"
const DELIVERY_HUNTRESS_COUNT := 30
## THIS STAGE'S OWN REGISTRY, pinned at delivery: 22 PROVISIONAL + 2 structural.
const DELIVERY_HOUND_DIGEST := "796df1d300130c1c3ef5499345bdfd1b963405459248fc44da1a978e2a86e519"
const DELIVERY_HOUND_COUNT := 24

## The accepted modules the hounds run through, byte-identical to the pre-work
## baseline of 2026-09-19 16:54:16.
const ACCEPTED_MODULE_SHA256 := {
	"res://scripts/combat/ordinary_enemy.gd": "bc77f3aaeb79b1948b4f031c099111ef961df8a9b6284464ac6cb18be535619e",
	"res://scripts/combat/damageable.gd": "3fc7ec7a5304d6d348a0e9dc8b70eceadcbc467532d1ff787f96967dda848988",
	"res://scripts/world/nav_service.gd": "6eba15fe4ca331069f4211b85210536b70b130adeec8d989fa15dc6aeef5fa6d",
	"res://scripts/world/production_arena.gd": "f425636f2becf89c4ad438209f736166744ef22e3ac3f145b6067a22f642e152",
	"res://scripts/huntress/hit_eligibility.gd": "46d1433e914233491b9dbee739888ece0b30014f50e8cc96e1b84437ab30bb5e",
	"res://scripts/huntress/combat_entity_registry.gd": "ef9d75f80eaac80effd9654caa970d0c9234e4a8add5d281e26a7444f47bd6b0",
	"res://scripts/imprint/imprint_loadout.gd": "253e6a4246017a54b504d2cee0ed3973344386acca30e926a7ef2f3c79d41bf9",
	"res://scripts/imprint/resource_pool.gd": "a54590e30eae58a15a5f1dcb5b7903ff13c8f5858dfc01ef11939eca0b54ba7a",
	"res://scripts/imprint/imprint_library.gd": "0910b67f86579da6ae28ab1fb1c3db765caaaf3deb359d86b4a342be02bb2768",
}

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

func chk_B41_no_accepted_tuning_value_or_module_changed() -> bool:
	var prod := _numeric_digest_of_map(_constants("res://scripts/core/prod_config.gd"))
	var imp := _numeric_digest_of_map(_constants("res://scripts/imprint/imprint_config.gd"))
	var hc := _numeric_digest_of_map(_constants("res://scripts/huntress/huntress_config.gd"))
	var pre := int(prod[0]) == PRE_WORK_PROD_COUNT and String(prod[1]) == PRE_WORK_PROD_DIGEST \
		and int(imp[0]) == PRE_WORK_IMPRINT_COUNT and String(imp[1]) == PRE_WORK_IMPRINT_DIGEST
	var hunt := int(hc[0]) == DELIVERY_HUNTRESS_COUNT and String(hc[1]) == DELIVERY_HUNTRESS_DIGEST
	var named := is_equal_approx(ProdConfig.TOP_SPEED_MPS, 3.889) and is_equal_approx(ProdConfig.CAM_SIZE_DEFAULT, 14.0) \
		and is_equal_approx(ProdConfig.YAW_RATE_DEG_PER_S, 720.0) and ProdConfig.ENEMY_COUNT == 4 and enemies.size() == 4 \
		and ImprintConfig.CAPACITY_FROM_PROGRESSION == 30 and ImprintConfig.CAPACITY_GEAR_BONUS_DIAGNOSTIC == 5 \
		and ImprintConfig.CAPACITY_BASE_PERSISTENT == 1 and is_equal_approx(ImprintConfig.MANA_MAX, 500.0) \
		and is_equal_approx(ImprintConfig.LIFE_MAX, 300.0) and is_equal_approx(ImprintConfig.MANA_REGEN_FRACTION_OF_UNRESERVED_PER_S, 0.044)
	var planted: Dictionary = _constants("res://scripts/imprint/imprint_config.gd").duplicate()
	planted["CAPACITY_FROM_PROGRESSION"] = 31
	var refuses := String(_numeric_digest_of_map(planted)[1]) != PRE_WORK_IMPRINT_DIGEST
	var moved: Array[String] = []
	for p in ACCEPTED_MODULE_SHA256.keys():
		if FileAccess.get_sha256(String(p)) != String(ACCEPTED_MODULE_SHA256[p]):
			moved.append(String(p).get_file())
	var ok := pre and hunt and named and refuses and moved.is_empty()
	_note("B41_no_accepted_tuning_value_or_module_changed",
		"every numeric constant of ProdConfig (%d) and ImprintConfig (%d) digests to the PRE-WORK figures=%s | HuntressConfig's %d digest to the figure measured at delivery (D-396 changed only strings there)=%s | named: 3.889 m/s, zoom 14 m, 720 deg/s, 4 enemies, Capacity 30 + 5 with a Persistent base of 1, 500 Mana, 300 Life, 4.4%% regeneration=%s | one planted Capacity change is refused=%s | the accepted modules the hounds run through, byte-identical to the pre-work baseline — changed: %s"
		% [int(prod[0]), int(imp[0]), str(pre), int(hc[0]), str(hunt), str(named), str(refuses), str(moved)])
	_reached("B41_no_accepted_tuning_value_or_module_changed")
	return ok

## RE-SCOPED UNDER D-402, ONE FOR ONE: 8 - 1 = 7 excluded names. "Cinder Field"
## LEAVES this list because the OWNER HAS SINCE AUTHORIZED IT -- D-402 implements
## it as ONE canonical ACTIVE Skill Imprint. It was correctly out of scope for
## D-396 and that sentence stays true of the D-396 stage. EVERY OTHER exclusion
## stands, and each can still fail: Coursing Hounds, Sinew Ballista, Void Lance,
## Rift Step, Void Attunement, Additional Minion and Huntress's Mark are still
## unimplemented and still refused here.
const OUT_OF_SCOPE_NAMES := ["Coursing Hounds", "Sinew Ballista", "Void Lance", "Rift Step",
	"Void Attunement", "Additional Minion", "Huntress's Mark"]
const FORBIDDEN_TOKENS := ["coursing", "sinew", "ballista", "cinder", "lance", "attunement", "additional", "aura",
	"command", "commands", "feed", "feeding", "pet", "pets", "shard", "shards", "passive", "passives", "loot", "gear",
	"equipment", "affix", "prey", "mark", "marked", "marks", "marking", "rarity", "elite", "boss", "echo", "recall",
	"focus", "order", "orders", "rift", "trap", "emplacement", "care"]
const HOUND_CLASSES := ["HoundConfig", "HoundContent", "HoundReviewHud", "HoundRuntime", "HoundStandIn",
	"HoundTargeting", "KindredHound"]

static func _forbidden_decls(file: String, code: String) -> Array:
	var re := RegEx.new()
	re.compile("(?m)^\\s*(?:static\\s+)?(?:func|var|const|class_name|signal|class|enum)\\s+([A-Za-z_][A-Za-z_0-9]*)")
	var camel := RegEx.new()
	camel.compile("([a-z0-9])([A-Z])")
	var out: Array = []
	for m in re.search_all(code):
		var ident := m.get_string(1)
		for tok in camel.sub(ident, "$1_$2", true).to_lower().split("_"):
			if FORBIDDEN_TOKENS.has(String(tok)):
				out.append("%s:%s" % [file.get_file(), ident])
				break
	return out

func chk_B42_no_out_of_scope_content_exists() -> bool:
	var named: Array[String] = []
	for id in skills.library.ids():
		var dn := (skills.library.get_imprint(String(id)) as Imprint).display_name
		for n in OUT_OF_SCOPE_NAMES:
			if dn.findn(String(n)) >= 0:
				named.append(String(id))
	# RE-SCOPED UNDER D-402, ONE FOR ONE: the library 16 + 1 = 17 and the
	# Configurations 8 + 1 = 9 -- Cinder Field, the ONE canonical ACTIVE Skill
	# Imprint that ruling authorizes, with its ONE unmodified Configuration.
	# Until D-402 these required 16 and 8: true when written.
	var counts := skills.library.count() == 17 and skills.configurations.size() == 9
	var decls: Array = []
	var classes: Array[String] = []
	var cre := RegEx.new()
	cre.compile("(?m)^class_name\\s+([A-Za-z_0-9]+)")
	for f in _hound_script_files():
		var code := _code_only(_read_text(String(f)))
		decls.append_array(_forbidden_decls(String(f), code))
		var cm := cre.search(code)
		if cm != null:
			classes.append(cm.get_string(1))
	classes.sort()
	var classes_ok := _same(classes, HOUND_CLASSES) and _hound_script_files().size() == 7
	var caught := not _forbidden_decls("x.gd", "func command_pack_attack() -> void:").is_empty() \
		and not _forbidden_decls("x.gd", "var marked_by_huntress := false").is_empty() \
		and _forbidden_decls("x.gd", _code_only("# func command_pack_attack() -> void:")).is_empty()
	var shard := RegEx.new()
	shard.compile("(?i)rift_?shard|rift_?echo")
	var shards: Array[String] = []
	var marks: Array = []
	for f in _runtime_script_files():
		var code2 := _code_only(_read_text(String(f)))
		if shard.search(code2) != null:
			shards.append(String(f).get_file())
		for m in _mark_identifiers(_read_text(String(f))):
			marks.append("%s:%s" % [String(f).get_file(), String(m)])
	# CODE, NOT PROSE: the runtime's own denials SAY "NO Ultimate Monsters model",
	# so identifiers are scanned with every string literal emptied, and asset
	# PATHS are scanned inside the strings, where a path would have to be.
	var vfx := RegEx.new()
	vfx.compile("(?i)ultimate_?monsters|BattleFX|DarkMagicFX|ElementalMagicFX|VividMotion|PortalVFX|AudioStream|\\bload\\(|preload\\(")
	var paths := RegEx.new()
	paths.compile("(?i)\"res://assets|assets/VFX|\\.(glb|gltf|fbx|obj|wav|ogg|mp3)\"")
	var vfx_hits: Array[String] = []
	for f in _hound_script_files():
		var code3 := _code_only(_read_text(String(f)))
		if vfx.search(_strip_strings(code3)) != null or paths.search(code3) != null:
			vfx_hits.append(String(f).get_file())
	var vfx_caught := vfx.search(_strip_strings("\tvar m = preload(\"x\")")) != null \
		and paths.search("\tvar p := \"res://assets/VFX/x.glb\"") != null \
		and vfx.search(_strip_strings("\t\"NO Ultimate Monsters model\",")) == null
	var tc := _code_only(_read_text("res://scripts/hounds/hound_targeting.gd")).to_lower()
	var no_rarity := tc.find("category") < 0 and tc.find("elite") < 0 and tc.find("boss") < 0 and tc.find("rarity") < 0
	var mark_denied := false
	for d in HoundConfig.denials():
		if String(d).find("Huntress's Mark remains a FUTURE concept and is NOT implemented") >= 0:
			mark_denied = true
	var enemies_ok := ProdConfig.ENEMY_COUNT == 4 and enemies.size() == 4
	var ok := named.is_empty() and counts and decls.is_empty() and classes_ok and caught and shards.is_empty() \
		and marks.is_empty() and vfx_hits.is_empty() and vfx_caught and no_rarity and mark_denied and enemies_ok
	_note("B42_no_out_of_scope_content_exists",
		"Imprints bearing an excluded name (Coursing Hounds, Sinew Ballista, Cinder Field, Void Lance, Rift Step, Void Attunement, Additional Minion, Huntress's Mark): %s; 16 Imprints and 8 Configurations=%s | hound-file declarations naming an excluded mechanic (aura, command, feeding, pet, shard, passive, loot, gear, affix, Prey, Mark, rarity, elite, boss, recall, focus, order, trap, emplacement...): %s | the hound classes are exactly %s=%s | the scan catches planted declarations and ignores a comment=%s | Rift Shard code anywhere: %s; Mark identifiers anywhere: %s | hound files loading anything, or naming an asset path, archive, VFX package, the Ultimate Monsters pack or audio IN CODE: %s (a planted load, a planted asset path are caught and a denial string is not=%s) | the targeting rule reads no category, rarity, Elite or boss=%s | the runtime says Huntress's Mark remains FUTURE, NOT implemented=%s | 4 enemies, no enemy content added=%s"
		% [str(named), str(counts), str(decls), str(classes), str(classes_ok), str(caught), str(shards), str(marks), str(vfx_hits), str(vfx_caught),
		   str(no_rarity), str(mark_denied), str(enemies_ok)])
	_reached("B42_no_out_of_scope_content_exists")
	return ok

const KO_TEXT := ["Whether the hounds feel autonomous rather than managed.",
	"Whether following, acquisition and leash return feel stable.",
	"Whether two stand-ins remain readable at normal gameplay zoom.",
	"Whether reservation and pack state are understandable.",
	"Whether their attacks structurally feel capable of supporting a minion-primary build.",
	"Whether fallen-hound recovery feels sufficiently low-friction."]

func chk_B43_denials_rulings_units_and_no_self_acceptance() -> bool:
	var den := HoundConfig.denials()
	# RE-PINNED UNDER D-398, AS ITS FIRST ACT (D-397 section 6). Until D-398 the
	# last denial was "The D-396 stage delivers OPEN pending owner live review; it
	# does NOT accept itself." -- TRUE WHEN WRITTEN. D-397 accepted the stage; the
	# denial is now dated history naming D-397, and the present-tense one is gone.
	var den_ok := den.size() == 14 and String(den[13]).find("The D-396 stage was delivered OPEN and never accepted itself: the owner ACCEPTED and CLOSED it under D-397") == 0 \
		and not den.has("The D-396 stage delivers OPEN pending owner live review; it does NOT accept itself.")
	for d in den:
		den_ok = den_ok and (String(d).find("D-396") >= 0 or String(d).find("review HUD") >= 0)
	var cites := ""
	for r in HoundConfig.canonical_rulings():
		cites += String(r[0]) + " | "
	var cited := HoundConfig.canonical_rulings().size() == 7
	for c in ["D-385 HD-06", "SKILLS §15", "D-391 r3", "D-391 r4", "D-392 CL-3", "D-394 r3", "D-396 item 9"]:
		cited = cited and cites.find(String(c)) >= 0
	var kd := HoundConfig.deferred_rows()
	var kd_ok := kd.size() == 16
	for i in kd.size():
		kd_ok = kd_ok and String(kd[i][0]).begins_with("KD-%02d " % (i + 1)) and String(kd[i][2]).find("RETURNS TO") >= 0
	# RE-PINNED UNDER D-398 (first act): KO-01..KO-06 were ANSWERED by D-397 and
	# MOVED, text verbatim, to discharged_rows(). 6 - 6 = 0 owed; 0 + 6 = 6
	# discharged; 0 deleted. Each carries D-397's answer at the level given.
	var ko := HoundConfig.discharged_rows()
	var ko_ok := ko.size() == 6 and HoundConfig.owed_to_owner().is_empty() \
		and HoundConfig.D397_ANSWER.find("satisfactory at the reviewed two-hound scale and current movement speed") >= 0
	for i in ko.size():
		ko_ok = ko_ok and String(ko[i][0]) == "KO-%02d" % (i + 1) and String(ko[i][1]) == KO_TEXT[i] \
			and String(ko[i][2]) == "DISCHARGED — D-397" \
			and String(ko[i][3]).find("THE OWNER'S D-397 LIVE REVIEW: ANSWERED DIRECTLY") == 0 \
			and String(ko[i][3]).find("ORIGINAL ROW TEXT, PRESERVED VERBATIM (OWED-TO-OWNER): '" + KO_TEXT[i] + "'") > 0
	# NO SELF-ACCEPTANCE, anywhere a viewer or a log could read it.
	# RE-SCOPED UNDER D-398 (first act), one for one: D-397 made "KINDRED HOUNDS
	# STAGE ACCEPTED" the owner's fact, carried by the one definer. The needle MOVES
	# to what would still be false: the D-396 stage accepting ITSELF ("ACCEPTED and
	# CLOSED (D-396)", "D-396 is ACCEPTED") and the OPEN D-398 stage called accepted.
	var self_re := RegEx.new()
	# RE-SCOPED AGAIN UNDER D-400, one for one: D-400 made "MOBILE MINION COHESION
	# STAGE ACCEPTED" the owner's fact, so the needle moves to the OPEN D-400 stage.
	# RE-SCOPED AGAIN UNDER D-402, one for one: D-401 made "PLAYER LOCOMOTION
	# REDIRECTION STAGE ACCEPTED" the owner's fact, so the needle moves to the OPEN
	# D-402 stage, and "ACCEPTED and CLOSED (D-400)" joins what is still false.
	# RE-SCOPED UNDER D-404 (first act), one for one: D-403 made "CINDER FIELD
	# STAGE ACCEPTED" the OWNER's fact, so the needle MOVES to the OPEN D-404
	# stage, and "ACCEPTED and CLOSED (D-402)" joins what is still false.
	self_re.compile("PLAYER DIRECT-CLICK MOVEMENT CORRECTION STAGE ACCEPTED|ACCEPTED and CLOSED \\(D-402\\)|ACCEPTED and CLOSED \\(D-396\\)|D-396 (is|stage is) ACCEPTED|ACCEPTED and CLOSED \\(D-398\\)|ACCEPTED and CLOSED \\(D-400\\)|" + PLANTED_CLAIM)
	var claims: Array[String] = []
	for f in _runtime_script_files():
		if self_re.search(_code_only(_read_text(String(f)))) != null:
			claims.append(String(f).get_file())
	hounds_hud.refresh()
	var surfaces := hounds_hud.last_text + "\n" + d392_hud.last_text + "\n" + hud.compose() + "\n" + ProdConfig.STATE
	var surface_clean := self_re.search(surfaces) == null
	var caught := self_re.search("print(\"%s\")" % PLANTED_CLAIM) != null and self_re.search("KINDRED HOUNDS STAGE ACCEPTED and CLOSED (D-396)") != null \
		and self_re.search("PLAYER DIRECT-CLICK MOVEMENT CORRECTION STAGE ACCEPTED and CLOSED (D-404)") != null
	# THE BANNER PRINTS NO ROW AND NO STATE LINE into the accepted suites' logs.
	var banner := _function_body(_code_only(_read_text("res://scripts/foundation_main.gd")), "_print_hounds_banner")
	var banner_ok := banner.length() > 200 and banner.find("STATE") < 0 and banner.find("OWED-TO-OWNER") < 0 \
		and banner.find("deferred_rows") < 0 and banner.find("owed_to_owner") < 0
	# UNITS AT EVERY SURFACE. Built without a relative parent segment: accepted
	# F65 and I99 refuse one in any file of this project.
	var inv_path := ProjectSettings.globalize_path("res://").trim_suffix("/").get_base_dir() \
		.path_join("docs/testing/D396_KINDRED_HOUNDS_OWED_CRITERIA_INVENTORY.md")
	var inv := _read_text(inv_path)
	var units := inv != "" and inv.find("= **202**") >= 0 and inv.find("`B01`…`B45` = **45**") >= 0 \
		and inv.find("`Y01`…`Y21` = **21**") >= 0 and OWED.size() == 45
	var ok := den_ok and cited and kd_ok and ko_ok and claims.is_empty() and surface_clean and caught and banner_ok and units
	_note("B43_denials_rulings_units_and_no_self_acceptance",
		"%d denials, each naming D-396 or the review HUD, the last now DATED history naming D-397 (re-pinned under D-398)=%s | the implemented rulings are cited: %s=%s | KD-01..KD-16 in order, each naming where it returns=%s | KO-01..KO-06, the owner's six questions verbatim, DISCHARGED — D-397 with D-397's answer, 0 owed (re-pinned under D-398)=%s | runtime code claiming a SELF-acceptance (the D-396 stage by itself, the D-398-dated one, or the open D-400 stage): %s; the HUDs, overlay and state line claim none=%s; planted claims are caught=%s | the composition banner prints no row and no STATE line=%s | the inventory states 202 OWED CRITERIA, 45 EXECUTABLE CHECKS and 21 RUNNER CHECKS, and this suite owes %d=%s"
		% [den.size(), str(den_ok), cites.left(120), str(cited), str(kd_ok), str(ko_ok), str(claims), str(surface_clean), str(caught),
		   str(banner_ok), OWED.size(), str(units)])
	_reached("B43_denials_rulings_units_and_no_self_acceptance")
	return ok

func chk_B44_seams_clear_and_no_runtime_dependency_leaves_game3d() -> bool:
	await _reset_review()
	var launch_clear := bool(launch["seams_clear"]) and bool(launch["setup_ok"]) and (launch["setup_problems"] as Array).is_empty()
	# NO HOUND FILE SETS A TEST SEAM.
	var seam_re := RegEx.new()
	seam_re.compile("debug_[a-z_]+\\s*=[^=]")
	var setters: Array[String] = []
	for f in _hound_script_files():
		for line in _code_only(_read_text(String(f))).split("\n"):
			if seam_re.search(String(line)) != null:
				setters.append("%s: %s" % [String(f).get_file(), String(line).strip_edges()])
	# NO RUNTIME LOAD LEAVES game3d/.
	var load_re := RegEx.new()
	load_re.compile("(?:load|preload|ResourceLoader\\.load|FileAccess\\.open|DirAccess\\.open)\\s*\\(\\s*\"([^\"]*)\"")
	var outward: Array[String] = []
	for f in _runtime_script_files():
		var code := _code_only(_read_text(String(f)))
		for m in load_re.search_all(code):
			if not m.get_string(1).begins_with("res://") or m.get_string(1).find("..") >= 0:
				outward.append("%s:%s" % [String(f).get_file(), m.get_string(1)])
		if code.find("res://" + "..") >= 0:
			outward.append("%s: a res:// path climbing out" % String(f).get_file())
	# THE CLOSED D-388 SPIKE IS NAMED ONLY AS DATA -- the reuse declaration's row.
	var spike_refs: Array[String] = []
	for f in _runtime_script_files():
		for line in _code_only(_read_text(String(f))).split("\n"):
			var l := String(line).strip_edges()
			if l.find("game3d_huntress_spike") >= 0:
				# DATA ROWS -- the reuse declarations of D-392 and D-396 -- name it as
				# provenance; code that loads, instances or references it would not
				# be a string row.
				var data_row := l.begins_with("[\"") or l.begins_with("\"")
				if not data_row:
					spike_refs.append("%s: %s" % [String(f).get_file(), l.left(60)])
	var informing := false
	for r in HoundConfig.reuse_declaration():
		if String(r[1]).find("game3d_huntress_spike") == 0 and String(r[2]).find("INFORMED BY, RE-IMPLEMENTED HERE") == 0:
			informing = true
	var planted_path := "res://" + "." + "./game3d_huntress_spike/scripts/spike/stand_in_hound.gd"
	var pm := load_re.search("\tvar s = load(\"%s\")" % planted_path)
	var caught := pm != null and pm.get_string(1).find("..") >= 0
	var now_clear := player.intent.seams_clear() and cam.debug_cursor_override == null and not player.debug_freeze_attack
	var ok := launch_clear and setters.is_empty() and outward.is_empty() and spike_refs.is_empty() and informing and caught and now_clear
	_note("B44_seams_clear_and_no_runtime_dependency_leaves_game3d",
		"at launch every test seam was clear and the stage built with no problem=%s | hound-file assignments of a test seam: %s | loads leaving game3d/: %s | code naming the closed D-388 spike outside a reuse declaration's data rows: %s; the D-396 row declares it as INFORMING, RE-IMPLEMENTED=%s; a planted outward load is caught=%s | seams clear again=%s"
		% [str(launch_clear), str(setters), str(outward), str(spike_refs), str(informing), str(caught), str(now_clear)])
	_reached("B44_seams_clear_and_no_runtime_dependency_leaves_game3d")
	return ok

const STRUCTURAL_CONSTANTS := ["COLLISION_LAYER", "COLLISION_MASK_WORLD"]

func chk_B45_every_stage_value_is_registered_provisional() -> bool:
	var reg := HoundConfig.registry()
	var all_prov := reg.size() == 22
	for row in reg:
		all_prov = all_prov and String(row[2]).find("PROVISIONAL") == 0
	# BOTH DIRECTIONS: every numeric constant but the two structural ones is in
	# the registry, and every registry value is such a constant.
	var consts := _constants("res://scripts/hounds/hound_config.gd")
	var numeric: Array = []
	for k in consts.keys():
		var v = consts[k]
		if (typeof(v) == TYPE_INT or typeof(v) == TYPE_FLOAT) and not STRUCTURAL_CONSTANTS.has(String(k)):
			numeric.append(float(v))
	var reg_values: Array = []
	for row in reg:
		reg_values.append(float(row[1]))
	numeric.sort()
	reg_values.sort()
	var both := numeric.size() == reg_values.size()
	if both:
		for i in numeric.size():
			both = both and is_equal_approx(float(numeric[i]), float(reg_values[i]))
	var planted := numeric.duplicate()
	planted.append(12.5)
	var refuses := planted.size() != reg_values.size()
	# THE NAMED CANDIDATES, each a REVIEW CANDIDATE and NOT a lock.
	var want := {"reservation at rank 1": 0.20, "pack size": 2.0, "acquisition range": 6.0, "leash range": 9.0,
		"hound speed": 5.2, "bite damage at rank 1": 9.0, "bite interval": 0.75, "hound Life": 80.0,
		"recovery delay": 4.0}
	var named_ok := true
	for key in want.keys():
		var found := false
		for row in reg:
			if String(row[0]).find(String(key)) >= 0 and is_equal_approx(float(row[1]), float(want[key])):
				found = true
		named_ok = named_ok and found
	var digest := _numeric_digest_of_map(consts)
	var pinned := int(digest[0]) == DELIVERY_HOUND_COUNT and String(digest[1]) == DELIVERY_HOUND_DIGEST
	var ok := all_prov and both and refuses and named_ok and pinned
	_note("B45_every_stage_value_is_registered_provisional",
		"%d registry values, every one PROVISIONAL=%s | the registry and HoundConfig's numeric constants (the collision layer and mask excepted as structural) match both ways=%s; an unregistered planted constant is refused=%s | the reservation, pack size, both ranges, speed, bite damage and interval, Life and recovery delay are each registered at their disclosed candidate=%s | the registry's numeric digest equals the delivery pin (%d constants) — any change must move this pin in the same change=%s. NONE IS A LOCK."
		% [reg.size(), str(all_prov), str(both), str(refuses), str(named_ok), int(digest[0]), str(pinned)])
	_reached("B45_every_stage_value_is_registered_provisional")
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
	print("RESULTS — %s (%s)" % [HoundConfig.STAGE, HoundConfig.DECISION])
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
	for row in HoundConfig.deferred_rows():
		print("  [%-24s] %s" % [row[1], row[0]])
		print("                   %s" % row[2])
	print("")
	print("OWED TO THE OWNER'S LIVE REVIEW — NOT passes and NOT failures:")
	for row in HoundConfig.owed_to_owner():
		print("  [OWED-TO-OWNER] %s %s" % [row[0], row[1]])
	# D-398 (first act): the six rows the owner answered under D-397, printed every
	# run with their ORIGINAL TEXT -- NOT passes. None was deleted.
	print("")
	print("DISCHARGED — answered by the owner, recorded as such, NOT passes:")
	for row in HoundConfig.discharged_rows():
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
	print("DENIALS (%d):" % HoundConfig.denials().size())
	for d in HoundConfig.denials():
		print("  %s" % d)
	print("")
	print("UNITS: %d EXECUTABLE CHECKS here · 202 OWED CRITERIA in the D-396 inventory ·" % OWED.size())
	print("       21 RUNNER CHECKS in tests/hounds_smoke.sh · and the ACCEPTED suites' 85, 101, 40")
	print("       and 53 EXECUTABLE CHECKS are DIFFERENT decisions' numbers.")
	print("       Different unit. None is a synonym for another.")
	print("")
	var verdict := "PASS" if _all_ok() else "FAIL"
	# D-398 (first act): the summary gains the discharged count, in the D-392
	# suite's format.
	print("HOUNDS VERIFICATION: %s (%d checks: %d passed, %d failed/unreached, %d deferred, %d owed to the owner, %d discharged)"
		% [verdict, OWED.size(), passed, failed, HoundConfig.deferred_rows().size(), HoundConfig.owed_to_owner().size(),
		   HoundConfig.discharged_rows().size()])
	print("STATE: %s" % ProdConfig.STATE)
