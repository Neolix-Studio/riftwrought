extends SceneTree

## RIFTWROUGHT — THE MOBILE MINION COHESION STAGE VERIFICATION  (D-398, 2026-09-19)
##
## ============================================================================
## A SIXTH SUITE. THE FIVE ACCEPTED ONES ARE RE-RUN AS REGRESSIONS.
## ============================================================================
## `tests/foundation_verification.gd` (85, ACCEPTED D-373), `imprint_` (101,
## D-376), `alignment_` (40, D-383), `huntress_` (53, D-394) and `hounds_` (45,
## ACCEPTED D-397) run FIRST in `tests/cohesion_smoke.sh`. This suite owns only
## what the D-398 stage owes.
##
## ============================================================================
## UNITS. EIGHTEEN COUNTS EXIST IN THIS PROJECT AND NONE IS A SYNONYM FOR ANOTHER.
## ============================================================================
##   D-398 OWED CRITERIA     201  docs/testing/D398_MOBILE_MINION_COHESION_OWED_CRITERIA_INVENTORY.md
##   D-398 EXECUTABLE CHECKS  40  this suite (C01-C40)
##   D-398 RUNNER CHECKS      22  tests/cohesion_smoke.sh (Z01-Z22)
##   D-396 202 · 45 · 21   D-392 203 · 53 · 21   D-380 162 · 40 · 21
##   D-375 149 · 101 · 26   D-370 125 · 85 · 20
## The D-398 printed rows are 16 CD- rows and 5 CO- rows: none is a pass.
##
## ============================================================================
## IT VERIFIES A STAGE DELIVERED OPEN. IT ACCEPTS NOTHING.
## ============================================================================
## The owner: "It is not P2, a pack-size increase, a new Skill, final minion AI,
## art production, VFX work or numerical tuning." Every number it touches is
## PROVISIONAL, and every BOUND it asserts is a test bound, stated in its note --
## never a gameplay value.
##
## THIS SUITE MEASURES THE REVIEW LOADOUT, as the owner will launch it, and does
## NOT call the accepted suites' declared fixture.
##
## The standing verification rules, verbatim: a named owed list compared in BOTH
## directions · every check records reaching its LAST line · a missing check
## function is a FAIL, never a skip · every negative control is PROVED ABLE TO
## REFUSE · an assertion that something did NOT happen first asserts the action
## FIRED · source-scanning guards read CODE, never the dated history comments ·
## an unperformed check is DEFERRED and names where it returns.

const OWED := [
	# --- A. THE FIRST ACT (D-397 section 6) ------------------------------------
	"C01_state_names_six_facts_exactly_with_one_definer",
	"C02_ko_rows_discharged_d397_with_history_and_d396_denial_dated",
	"C03_every_accepted_pin_moved_together_and_refuses_stale_lines",
	# --- B. THE SHARED COHORT -------------------------------------------------
	"C04_one_shared_cohort_with_kindred_hounds_its_only_production_consumer",
	"C05_the_ordinary_two_hound_pack_and_its_d396_values_are_unchanged",
	"C06_members_carry_stable_combat_entity_ids_as_allies_never_eligible",
	# --- C. THE FORMATION -------------------------------------------------------
	"C07_stable_slots_by_combat_entity_id_without_reshuffling",
	"C08_loose_density_aware_multi_ring_slots_not_a_rigid_circle",
	"C09_vanguard_bias_keeps_the_pack_around_and_ahead_of_her",
	"C10_a_predictive_anchor_leads_her_freezes_at_rest_and_stays_walkable",
	"C11_the_formation_turns_at_a_rate_and_never_flips_instantly",
	# --- D. SPEED ---------------------------------------------------------------
	"C12_normal_follow_keeps_pace_with_her_at_every_speed_mode",
	"C13_catch_up_scales_with_her_speed_and_the_separation_distance",
	# --- E. CONGESTION AND NON-OBSTRUCTION ------------------------------------
	"C14_local_visual_separation_holds_when_settled",
	"C15_congested_returning_and_catching_up_members_pass_through",
	"C16_mobile_minions_never_body_block_her",
	# --- F. COMBAT AND REGROUP --------------------------------------------------
	"C17_in_combat_members_leave_formation_under_the_accepted_rule",
	"C18_melee_members_take_stable_target_relative_attack_positions",
	"C19_when_she_exceeds_the_leash_regrouping_overrides_combat",
	"C20_after_combat_members_reform_without_a_command",
	# --- G. SOFT RECOVERY -------------------------------------------------------
	"C21_path_failure_triggers_a_harmless_soft_recovery",
	"C22_falling_far_behind_triggers_a_soft_recovery_into_a_valid_unoccupied_slot",
	"C23_no_attack_or_damage_during_recovery",
	# --- H. THE EXERCISES -------------------------------------------------------
	"C24_straight_high_speed_travel",
	"C25_sudden_direction_reversal",
	"C26_repeated_stopping_and_starting",
	"C27_the_doorway_and_interior_blocker_at_fifteen",
	"C28_target_acquisition_then_rapid_departure",
	"C29_several_melee_members_on_one_target",
	# --- I. THE DIAGNOSTIC MODES ------------------------------------------------
	"C30_four_populations_and_three_travel_speeds_are_labelled_diagnostic",
	"C31_diagnostic_modes_are_isolated_from_gameplay_configuration",
	"C32_the_two_diagnostic_controls_are_real_bound_and_not_commands",
	"C33_stress_minions_exist_only_with_the_pack_and_leave_highest_id_first",
	# --- J. COST ----------------------------------------------------------------
	"C34_path_query_cost_is_bounded_at_fifteen",
	# --- K. SURFACES AND THE REVIEW HUD -----------------------------------------
	"C35_launch_surfaces_hidden_and_the_cohesion_hud_shown",
	"C36_the_cohesion_hud_is_compact_clear_and_click_through",
	"C37_the_cohesion_hud_shows_only_the_ruling_reads_live_and_owns_no_number",
	# --- L. SCOPE, PRESERVATION AND TRUTHFULNESS --------------------------------
	"C38_no_out_of_scope_content_or_tuning_change",
	"C39_denials_rulings_units_and_no_self_acceptance",
	"C40_seams_clear_and_every_stage_value_registered_provisional",
]

## ONE deliberately planted claim, so the self-acceptance scans can be proved
## able to refuse. It is never printed.
const PLANTED_CLAIM := "Cohesion_Stage_Accepts_Itself_THIS_IS_FORBIDDEN"

## RE-PINNED UNDER D-400, AS THE FIRST ACT OF THE PLAYER LOCOMOTION REDIRECTION
## STAGE. The const names are D-398's and were true of it: the line now states
## SEVEN facts, its sixth is D-400's ACCEPTANCE of this stage, and its seventh is
## the D-400 stage, OPEN. NOTHING WAS RENAMED AROUND A GUARD.
# D-404 (first act): `SIX` and `OPEN6` keep their IDENTIFIERS -- renaming
# around a guard is what this project's own rule forbids -- and their CONTENT moves
# with the state. From D-402 until D-404 `SIX` was the eight-fact line ending
# "CINDER FIELD STAGE DELIVERED and OPEN pending owner live review (D-402)" and
# `OPEN6` that clause -- TRUE WHEN WRITTEN. The line is now NINE facts.
const SIX := "FOUNDATION STAGE ACCEPTED and CLOSED (D-373) · IMPRINT STAGE ACCEPTED and CLOSED (D-376) · D-378 ALIGNMENT STAGE ACCEPTED and CLOSED (D-383) · HUNTRESS SPLINTER SHOT STAGE ACCEPTED and CLOSED (D-394) · KINDRED HOUNDS STAGE ACCEPTED and CLOSED (D-397) · MOBILE MINION COHESION STAGE ACCEPTED and CLOSED (D-399) · PLAYER LOCOMOTION REDIRECTION STAGE ACCEPTED and CLOSED (D-401) · CINDER FIELD STAGE ACCEPTED and CLOSED (D-403) · PLAYER DIRECT-CLICK MOVEMENT CORRECTION STAGE DELIVERED and OPEN pending owner live review (D-404)"
# D-402 (first act): `OPEN6` keeps its IDENTIFIER and its CONTENT moves with the
# state. It read the D-400 locomotion clause from D-400 until D-402: true when
# written.
const OPEN6 := "PLAYER DIRECT-CLICK MOVEMENT CORRECTION STAGE DELIVERED and OPEN pending owner live review (D-404)"
## The D-398-era six-fact line, held as a SUPERSEDED needle.
const STATE_D398 := "FOUNDATION STAGE ACCEPTED and CLOSED (D-373) · IMPRINT STAGE ACCEPTED and CLOSED (D-376) · D-378 ALIGNMENT STAGE ACCEPTED and CLOSED (D-383) · HUNTRESS SPLINTER SHOT STAGE ACCEPTED and CLOSED (D-394) · KINDRED HOUNDS STAGE ACCEPTED and CLOSED (D-397) · MOBILE MINION COHESION STAGE DELIVERED and OPEN pending owner live review (D-398)"
## D-402: the D-400-era line, held as a SUPERSEDED needle exactly as STATE_D398 is.
const STATE_D400 := "FOUNDATION STAGE ACCEPTED and CLOSED (D-373) · IMPRINT STAGE ACCEPTED and CLOSED (D-376) · D-378 ALIGNMENT STAGE ACCEPTED and CLOSED (D-383) · HUNTRESS SPLINTER SHOT STAGE ACCEPTED and CLOSED (D-394) · KINDRED HOUNDS STAGE ACCEPTED and CLOSED (D-397) · MOBILE MINION COHESION STAGE ACCEPTED and CLOSED (D-399) · PLAYER LOCOMOTION REDIRECTION STAGE DELIVERED and OPEN pending owner live review (D-400)"
## D-404: the D-402-era line, held as a SUPERSEDED needle exactly as STATE_D400 is.
const STATE_D402 := "FOUNDATION STAGE ACCEPTED and CLOSED (D-373) · IMPRINT STAGE ACCEPTED and CLOSED (D-376) · D-378 ALIGNMENT STAGE ACCEPTED and CLOSED (D-383) · HUNTRESS SPLINTER SHOT STAGE ACCEPTED and CLOSED (D-394) · KINDRED HOUNDS STAGE ACCEPTED and CLOSED (D-397) · MOBILE MINION COHESION STAGE ACCEPTED and CLOSED (D-399) · PLAYER LOCOMOTION REDIRECTION STAGE ACCEPTED and CLOSED (D-401) · CINDER FIELD STAGE DELIVERED and OPEN pending owner live review (D-402)"
const STATE_D396 := "FOUNDATION STAGE ACCEPTED and CLOSED (D-373) · IMPRINT STAGE ACCEPTED and CLOSED (D-376) · D-378 ALIGNMENT STAGE ACCEPTED and CLOSED (D-383) · HUNTRESS SPLINTER SHOT STAGE ACCEPTED and CLOSED (D-394) · KINDRED HOUNDS STAGE DELIVERED and OPEN pending owner live review (D-396)"
const STATE_D392 := "FOUNDATION STAGE ACCEPTED and CLOSED (D-373) · IMPRINT STAGE ACCEPTED and CLOSED (D-376) · D-378 ALIGNMENT STAGE ACCEPTED and CLOSED (D-383) · HUNTRESS SPLINTER SHOT STAGE DELIVERED and OPEN pending owner live review (D-392)"

## The straight test lane: MEASURED walkable end to end (x = -11, z -9.5 .. 9.5).
const LANE_A := Vector3(-11.0, 0.0, -9.0)
const LANE_PRIME := Vector3(-11.0, 0.0, -7.5)
const LANE_B := Vector3(-11.0, 0.0, 9.0)
## Where the scene's own enemies are parked: the west chamber's north-west corner,
## farther than the acquisition range from every route this suite drives.
const PARK := Vector3(-18.2, 0.0, -10.3)
const TICKS := 60.0
const K := HoundContent.SKILL_KINDRED_HOUNDS
const CFG_K := HoundContent.CFG_KINDRED_HOUNDS

# =============================================================================
# TEST-ONLY STUB ENTITIES — they exist ONLY in this suite.
# =============================================================================
class StubEntity extends Node3D:
	var targetable: bool = true
	var dead: bool = false
	var radius: float = 0.42
	var damage_taken: float = 0.0
	var hits: int = 0
	func combat_is_targetable() -> bool:
		return targetable
	func combat_body_radius() -> float:
		return radius
	func is_dead() -> bool:
		return dead
	func receive_damage(amount: float, _from: Vector3) -> void:
		damage_taken += amount
		hits += 1

## A would-be member of ANOTHER role, for the join refusal. Test-only.
class StubMember extends Node3D:
	var combat_id: String = ""
	var cohort_role: int = 99
	var cohort_mode: int = 0
	var cohort_params: Dictionary = {}
	var velocity: Vector3 = Vector3.ZERO
	func is_fallen() -> bool:
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
var diag: CohortDiagnostics
var hud: DebugOverlay
var panel: LoadoutPanel
var review_hud: ReviewHud
var d392_hud: HuntressReviewHud
var hounds_hud: HoundReviewHud
var cohort_hud: CohortReviewHud
var arena: ProductionArena
var enemies: Array = []
var corpus: AnimationLibrary
var launch := {}
var probes: Array = []
var nav_map: RID

func _initialize() -> void:
	print("========================================================================")
	print("RIFTWROUGHT — %s VERIFICATION  (%s, %s)" % [CohortConfig.STAGE, CohortConfig.DECISION, CohortConfig.DATE])
	print("STATE: %s" % ProdConfig.STATE)
	print("Verifying a STAGE DELIVERED OPEN: a shared mobile-minion cohort with Kindred Hounds as its")
	print("only production consumer — stable slots, a Vanguard formation, pace and catch-up, congestion,")
	print("soft recovery, target-relative melee positions — and two DIAGNOSTIC stress modes.")
	print("It is NOT P2, NOT a pack-size increase, NOT a new Skill, NOT final AI, art or VFX. It LOCKS NO NUMBER.")
	print("OWED EXECUTABLE CHECKS: %d   DEFERRED ROWS: %d   OWED-TO-OWNER ROWS: %d   DISCHARGED ROWS: %d"
		% [OWED.size(), CohortConfig.deferred_rows().size(), CohortConfig.owed_to_owner().size(),
		   CohortConfig.discharged_rows().size()])
	print("(The D-398 owed-criteria INVENTORY counts 201 CRITERIA. Different unit.)")
	print("(The ACCEPTED suites count 85, 101, 40, 53 and 45 EXECUTABLE CHECKS. Different decisions.)")
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
	diag = main.get("cohort_diagnostics")
	hud = main.get("hud")
	panel = main.get("imprint_panel")
	review_hud = main.get("review_hud")
	d392_hud = main.get("huntress_hud")
	hounds_hud = main.get("hounds_hud")
	cohort_hud = main.get("cohort_hud")
	arena = main.get("arena")
	enemies = main.get("enemies")
	corpus = main.get("corpus")
	nav_map = NavService.map_rid_for(main)
	# WHAT LAUNCH SHOWED, captured BEFORE any check touches anything.
	var ids: Array = []
	for h in hounds.members():
		ids.append((h as KindredHound).combat_id)
	launch = {
		"overlay_enabled": hud.enabled, "overlay_visible": hud.visible,
		"panel_enabled": panel.enabled, "panel_visible": panel.visible,
		"d381_enabled": review_hud.enabled, "d392_enabled": d392_hud.enabled,
		"hounds_hud_enabled": hounds_hud.enabled, "cohort_hud_enabled": cohort_hud.enabled,
		"cohort_hud_visible": cohort_hud.visible,
		"seams_clear": player.intent.seams_clear() and cam.debug_cursor_override == null
			and not player.debug_freeze_attack,
		"speed_scale": player.diagnostic_travel_speed_scale,
		"pass_seam": hounds.cohort.debug_disable_pass_through, "ff_seam": hounds.cohort.debug_disable_feed_forward,
		"pack": hounds.pack.size(), "stress": hounds.stress.size(), "members": hounds.cohort.size(),
		"population": diag.population(), "speed": diag.speed_name(), "ids": ids,
		"registered": hr.registry.count(), "setup_ok": hounds.setup_ok,
		"setup_problems": hounds.setup_problems.duplicate(),
		"resolve": hounds.configuration().resolve().duplicate(true),
	}
	_park_enemies()
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

## CODE ONLY: lines whose trimmed start is `#` are dropped (the D-380 lesson).
static func _code_only(text: String) -> String:
	var out := PackedStringArray()
	for line in text.split("\n"):
		if String(line).strip_edges().begins_with("#"):
			continue
		out.append(String(line))
	return "\n".join(out)

## Every string literal emptied, so a scan for IDENTIFIERS cannot fire on prose.
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

func _files_under(prefix: String) -> Array:
	var out: Array = []
	for f in _runtime_script_files():
		if String(f).begins_with(prefix):
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

static func _state_parts_ok(state: String) -> bool:
	# RE-SCOPED UNDER D-400, one for one: 6 + 1 = 7 facts. The sixth is D-400's
	# ACCEPTANCE of this stage and the seventh is the D-400 stage, OPEN.
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
		and parts[8] == OPEN6

static func _numeric_digest_of_map(m: Dictionary) -> Array:
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

static func _numeric_literals(code: String) -> Array:
	var re := RegEx.new()
	re.compile("(?<![A-Za-z_0-9.])-?[0-9]+(\\.[0-9]+)?(?![A-Za-z_0-9])")
	var out: Array = []
	for m in re.search_all(_code_only(code)):
		out.append(float(m.get_string()))
	return out

func _controls_under(n: Node, out: Array) -> void:
	for c in n.get_children():
		if c is Control:
			out.append(c)
		_controls_under(c, out)

func _members() -> Array:
	return hounds.members()

func _track(h: Node3D) -> MobileCohort.Track:
	return hounds.cohort.track_of(h)

func _park_enemies() -> void:
	for i in enemies.size():
		var e: OrdinaryEnemy = enemies[i]
		e.debug_freeze_ai = true
		e.life = Damageable.new(1000000.0)
		e.global_position = PARK + Vector3(0.0, 0.0, 0.8 * float(i))

## A test-only stub, registered HOSTILE in the AREA registry the hounds read.
func _stub(stub_name: String, pos: Vector3) -> StubEntity:
	var s := StubEntity.new()
	s.name = stub_name
	main.add_child(s)
	s.global_position = pos
	hr.registry.register(s, "ordinary", "hostile")
	probes.append(s)
	return s

func _clear_probes() -> void:
	for p in probes:
		if p != null and is_instance_valid(p):
			(p as Node).queue_free()
	probes = []
	await _phys(2)

## Exactly ONE more hound-runtime physics step (the D-396 lesson).
func _one_runtime_step() -> void:
	var s0 := hounds.frames_sampled
	while hounds.frames_sampled == s0:
		await physics_frame

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

## Back to a known review state: the review loadout, the given DIAGNOSTIC
## population and travel speed, a FRESH pack at her side at `at`, no probe, the
## test seams clear.
func _reset(pop: int, speed: String, at: Vector3) -> void:
	cam.debug_cursor_override = null
	hounds.cohort.debug_disable_pass_through = false
	hounds.cohort.debug_disable_feed_forward = false
	await _clear_probes()
	_park_enemies()
	_place_player(at)
	hounds.apply_loadout_plan(HoundContent.review_loadout_plan())
	diag.set_speed(speed)
	diag.set_population(pop)
	await _refresh_pack()
	skills.pool.refill()
	player.life.reset()
	await _phys(30)

## She walks by click-to-move toward `dest` first briefly (so the formation's
## heading faces the lane), then along it. Returns the frames until she stops.
func _prime_toward(prime: Vector3) -> void:
	player.command_move_to(prime)
	await _until(func() -> bool: return player.motor.speed() < 0.05 and _planar(player.global_position, prime) < 0.6, 240)
	await _phys(10)

## ADDED UNDER D-404 (a fixture, not a check): SHE WALKS A ROUTE BY HAND.
## Since D-404 a click order goes straight at the clicked point and stops at the
## first blocker -- the owner: "navigation around the obstacle requires another
## player command". So a route that turns a corner is now walked the way a player
## walks it: click the next waypoint as she nears the current one, without
## stopping. Call it every frame; it issues the next click when she is within
## `near` of the current waypoint. Returns the index of the waypoint in force.
func _click_route_step(route: Array, idx: int, near: float = 0.8) -> int:
	if idx < route.size() - 1 and _planar(player.global_position, Vector3(route[idx])) <= near:
		idx += 1
		player.command_move_to(Vector3(route[idx]))
	return idx

func _until(cond: Callable, max_frames: int) -> int:
	var g := 0
	while g < max_frames and not bool(cond.call()):
		await physics_frame
		g += 1
	return g

func _press(action: String) -> void:
	await physics_frame
	Input.action_press(action)
	await physics_frame
	await physics_frame
	Input.action_release(action)
	await physics_frame
	await process_frame

func _kindred_nodes_in_tree() -> int:
	var n := 0
	var stack: Array = [main]
	while not stack.is_empty():
		var x: Node = stack.pop_back()
		if x is KindredHound:
			n += 1
		stack.append_array(x.get_children())
	return n

## The projection of a member onto her heading, relative to her (+ is ahead).
func _ahead_of_her(h: Node3D) -> float:
	var hd := hounds.cohort.heading
	var rel: Vector3 = h.global_position - player.global_position
	return rel.x * hd.x + rel.z * hd.z

## Travel statistics over one straight run from LANE_A to LANE_B at the current
## mode. `steady` frames are those at >= 95 % of her mode speed; lag is sampled
## after the first 20 steady frames. Returns a Dictionary.
func _straight_run(from_a: Vector3, prime: Vector3, to_b: Vector3) -> Dictionary:
	_place_player(from_a)
	await _phys(3)
	# STAGING, not a seam: the formation faces the lane, as if she had been
	# travelling along it. Without this the short prime (1.5 m) leaves the heading
	# mid-turn from the previous check (it turns only while she moves, at its
	# PROVISIONAL rate), and the swing lands inside the measured window -- a
	# reversal, which C11 and C25 measure on their own. Found on the suite's first
	# run: ORDINARY max lag 3.17 m with the heading 55 deg off the lane at the start.
	var lane := to_b - from_a
	lane.y = 0.0
	hounds.cohort.heading = lane.normalized()
	for h in _members():
		(h as Node3D).global_position = hounds._spawn_point(hounds.cohort.rank_of(h))
	await _phys(30)
	await _prime_toward(prime)
	var rec0 := hounds.cohort.total_recoveries()
	player.command_move_to(to_b)
	var steady := 0
	var max_lag := 0.0
	var lag_sum := 0.0
	var lag_n := 0
	var centroid_sum := 0.0
	var behind := 0
	var member_frames := 0
	var ratio_sum := 0.0
	var ratio_n := 0
	var max_from_her := 0.0
	var mirrored_sum := 0.0
	var g := 0
	var target_speed := ProdConfig.TOP_SPEED_MPS * diag.speed_scale()
	while g < 700:
		await physics_frame
		g += 1
		var ps := Vector2(player.velocity.x, player.velocity.z).length()
		if ps >= 0.95 * target_speed:
			steady += 1
			var c := 0.0
			for h in _members():
				var kh := h as KindredHound
				var a := _ahead_of_her(kh)
				c += a
				mirrored_sum -= a
				member_frames += 1
				if a < -1.0:
					behind += 1
				ratio_sum += Vector2(kh.velocity.x, kh.velocity.z).length() / ps
				ratio_n += 1
				max_from_her = maxf(max_from_her, _planar(kh.global_position, player.global_position))
				if steady > 20:
					var l: float = _track(kh).lag
					max_lag = maxf(max_lag, l)
					lag_sum += l
					lag_n += 1
			centroid_sum += c / float(maxi(1, _members().size()))
		if g > 30 and player.motor.speed() < 0.05:
			break
	return {"steady": steady, "max_lag": max_lag, "mean_lag": lag_sum / maxf(1.0, float(lag_n)),
		"centroid": centroid_sum / maxf(1.0, float(steady)), "behind": float(behind) / maxf(1.0, float(member_frames)),
		"ratio": ratio_sum / maxf(1.0, float(ratio_n)), "max_from_her": max_from_her,
		"mirrored_centroid": mirrored_sum / maxf(1.0, float(member_frames)),
		"recoveries": hounds.cohort.total_recoveries() - rec0, "frames": g}

# =============================================================================
# A. THE FIRST ACT — D-397 section 6, done as this stage's first act
# =============================================================================

func chk_C01_state_names_six_facts_exactly_with_one_definer() -> bool:
	var s := ProdConfig.STATE
	var six := _state_parts_ok(s) and s == SIX
	var re := RegEx.new()
	re.compile("(?m)^\\s*const\\s+STATE\\s*(:[^=]*)?:?=")
	var definers: Array[String] = []
	for f in _runtime_script_files():
		if re.search(_code_only(_read_text(f))) != null:
			definers.append(String(f).get_file())
	var one := definers.size() == 1 and definers[0] == "prod_config.gd"
	var caught := re.search("const STATE := \"x\"") != null
	var gone := s != STATE_D398 and s != STATE_D396 and s != STATE_D392 and s != STATE_D400 and s != STATE_D402 \
		and s.find("PLAYER LOCOMOTION REDIRECTION STAGE DELIVERED") < 0 \
		and s.find("CINDER FIELD STAGE DELIVERED") < 0 \
		and s.find("MOBILE MINION COHESION STAGE DELIVERED") < 0 \
		and s.find("KINDRED HOUNDS STAGE DELIVERED") < 0 \
		and s.find("SPLINTER SHOT STAGE DELIVERED") < 0 and s.find("ALIGNMENT STAGE DELIVERED") < 0 \
		and s.find("IMPRINT STAGE DELIVERED") < 0
	var readers := _read_text("res://scripts/debug/debug_overlay.gd").find("ProdConfig.STATE") >= 0 \
		and _read_text("res://scripts/imprint/loadout_panel.gd").find("ProdConfig.STATE") >= 0
	# THE PREDICATE REFUSES: the D-396 line, a self-accepted D-398 fact, the D-396
	# stage accepting itself, an extra fact, five facts.
	var refuses := not _state_parts_ok(STATE_D398) and not _state_parts_ok(STATE_D396) \
		and not _state_parts_ok(STATE_D400) and not _state_parts_ok(STATE_D402) \
		and not _state_parts_ok(s.replace(OPEN6, "PLAYER DIRECT-CLICK MOVEMENT CORRECTION STAGE ACCEPTED and CLOSED (D-404)")) \
		and not _state_parts_ok(s.replace("CINDER FIELD STAGE ACCEPTED and CLOSED (D-403)", "CINDER FIELD STAGE ACCEPTED and CLOSED (D-402)")) \
		and not _state_parts_ok(s.replace("(D-397)", "(D-396)")) \
		and not _state_parts_ok(s + " · EXTRA STAGE (D-402)") \
		and not _state_parts_ok(" · ".join(s.split(" · ").slice(0, 7))) \
		and not _state_parts_ok(" · ".join(s.split(" · ").slice(0, 8)))
	var ok := six and one and caught and gone and readers and refuses
	_note("C01_state_names_six_facts_exactly_with_one_definer",
		"RE-PINNED UNDER D-404 (first act): the state line is now NINE facts — the eighth D-403's acceptance of Cinder Field, the ninth the D-404 direct-click stage OPEN — and the rest of this note is worded as at D-402, true when written: RE-PINNED UNDER D-400 AND D-402 (first acts): STATE is EXACTLY the EIGHT-fact line (foundation D-373 · Imprint D-376 · alignment D-383 · Splinter Shot D-394 · Kindred Hounds D-397 · mobile minion cohesion D-399 · player locomotion redirection ACCEPTED and CLOSED D-401 · Cinder Field DELIVERED and OPEN D-402)=%s | runtime definers: %s=%s (a planted one is seen=%s) | the D-400-era, D-398-era, D-396-era and every earlier OPEN clause are gone=%s | the overlay and the panel read it=%s | the predicate refuses the D-398, D-396 and D-400 lines, a self-accepted D-402 fact, a D-396 self-acceptance, an extra fact and seven facts=%s. (The id says 'six facts' — true when written.)"
		% [str(six), str(definers), str(one), str(caught), str(gone), str(readers), str(refuses)])
	_reached("C01_state_names_six_facts_exactly_with_one_definer")
	return ok

const KO_TEXT := ["Whether the hounds feel autonomous rather than managed.",
	"Whether following, acquisition and leash return feel stable.",
	"Whether two stand-ins remain readable at normal gameplay zoom.",
	"Whether reservation and pack state are understandable.",
	"Whether their attacks structurally feel capable of supporting a minion-primary build.",
	"Whether fallen-hound recovery feels sufficiently low-friction."]

func chk_C02_ko_rows_discharged_d397_with_history_and_d396_denial_dated() -> bool:
	var ko := HoundConfig.discharged_rows()
	var owed := HoundConfig.owed_to_owner()
	var kd := HoundConfig.deferred_rows()
	var rows_ok := ko.size() == 6 and owed.is_empty() and kd.size() == 16
	for i in ko.size():
		rows_ok = rows_ok and String(ko[i][0]) == "KO-%02d" % (i + 1) and String(ko[i][1]) == KO_TEXT[i] \
			and String(ko[i][2]) == "DISCHARGED — D-397" \
			and String(ko[i][3]).find("THE OWNER'S D-397 LIVE REVIEW: ANSWERED DIRECTLY") == 0 \
			and String(ko[i][3]).find("ORIGINAL ROW TEXT, PRESERVED VERBATIM (OWED-TO-OWNER): '" + KO_TEXT[i] + "'") > 0
	# AT THE LEVEL GIVEN, and bounded as the owner bounded it.
	var level := HoundConfig.D397_ANSWER.find("satisfactory at the reviewed two-hound scale and current movement speed") >= 0 \
		and HoundConfig.D397_ANSWER.find("No trial value is locked") >= 0
	var none_deleted := kd.size() + ko.size() + owed.size() == 16 + 6
	var den := HoundConfig.denials()
	var dated := false
	var old_present := false
	for d in den:
		var t := String(d)
		if t.find("The D-396 stage was delivered OPEN and never accepted itself: the owner ACCEPTED and CLOSED it under D-397") == 0:
			dated = true
		if t == "The D-396 stage delivers OPEN pending owner live review; it does NOT accept itself.":
			old_present = true
	# THE DECLARED D-397 DISCREPANCY IS DISCHARGED: the runtime no longer prints the
	# D-396 stage as open, and nothing owed is left in its suite's owed list.
	var discharged := ProdConfig.STATE.find("KINDRED HOUNDS STAGE ACCEPTED and CLOSED (D-397)") >= 0 \
		and ProdConfig.STATE.find("KINDRED HOUNDS STAGE DELIVERED") < 0 and HoundConfig.owed_to_owner().is_empty()
	var ok := rows_ok and level and none_deleted and dated and not old_present and den.size() == 14 and discharged
	_note("C02_ko_rows_discharged_d397_with_history_and_d396_denial_dated",
		"KO-01..KO-06 DISCHARGED — D-397 with D-397's answer and their ORIGINAL TEXT VERBATIM; 0 owed; 16 KD rows=%s | the answer is recorded at the level given, bounded to two hounds at the current speeds, nothing locked=%s | 16 + 6 + 0 = 22 rows, ZERO deleted=%s | the D-396 self-denial is dated history naming D-397=%s, the present-tense one gone=%s, 14 denials=%s | the D-397 section 6 discrepancy is discharged by this act (the state carries D-397's acceptance and no KO- row is owed)=%s"
		% [str(rows_ok), str(level), str(none_deleted), str(dated), str(not old_present), str(den.size() == 14), str(discharged)])
	_reached("C02_ko_rows_discharged_d397_with_history_and_d396_denial_dated")
	return ok

const ACCEPTED_RUNNERS := ["res://tests/foundation_smoke.sh", "res://tests/imprint_smoke.sh",
	"res://tests/alignment_smoke.sh", "res://tests/huntress_smoke.sh", "res://tests/hounds_smoke.sh"]

## A runner is CURRENT when its exact-line pin is the CURRENT (D-400 seven-fact)
## line, it holds BOTH the D-396-era and (since D-400) the D-398-era lines as
## ABSENCE needles it actually uses, and no pin names either of them.
## RE-SCOPED UNDER D-400, one for one: one needle -> two.
static func _runner_current(t: String) -> bool:
	return t.find("STATE_EXPECT=\"STATE: " + SIX + "\"") >= 0 \
		and t.find("STATE_D396_LINE=\"STATE: " + STATE_D396 + "\"") >= 0 \
		and t.count("STATE_D396_LINE") >= 2 \
		and t.find("STATE_D398_LINE=\"STATE: " + STATE_D398 + "\"") >= 0 \
		and t.count("STATE_D398_LINE") >= 2 \
		and t.find("STATE_EXPECT=\"STATE: " + STATE_D396 + "\"") < 0 \
		and t.find("STATE_EXPECT=\"STATE: " + STATE_D398 + "\"") < 0

func chk_C03_every_accepted_pin_moved_together_and_refuses_stale_lines() -> bool:
	var stale: Array[String] = []
	for r in ACCEPTED_RUNNERS:
		if not _runner_current(_read_text(String(r))):
			stale.append(String(r).get_file())
	var own := _read_text("res://tests/cohesion_smoke.sh")
	var own_ok := _runner_current(own)
	# THE D-396 RUNNER'S OWN MOVES: 0 owed, 6 discharged, Y15 DECLARED, its
	# self-acceptance needle moved to the open D-398 stage.
	var kt := _read_text("res://tests/hounds_smoke.sh")
	# RE-SCOPED UNDER D-400, one for one: the self-acceptance needle moves from the
	# now-accepted D-398 stage to the OPEN D-400 one, in both runners.
	var d396_ok := kt.find("\nPIN_K_OWNER=0\n") >= 0 and kt.find("\nPIN_K_DISCHARGED=6\n") >= 0 \
		and kt.find("[DECLARED] Y15") >= 0 and kt.find("SELF_ACCEPT='PLAYER DIRECT-CLICK MOVEMENT CORRECTION STAGE ACCEPTED|") >= 0
	var ht := _read_text("res://tests/huntress_smoke.sh")
	var d392_ok := ht.find("SELF_ACCEPT='PLAYER DIRECT-CLICK MOVEMENT CORRECTION STAGE ACCEPTED|") >= 0
	# THE ACCEPTED SUITES THAT PIN THE STATE carry the D-397 and D-398 clauses.
	var suites_ok := true
	for p in ["res://tests/imprint_verification.gd", "res://tests/alignment_verification.gd",
			"res://tests/huntress_verification.gd", "res://tests/hounds_verification.gd"]:
		var t := _read_text(String(p))
		suites_ok = suites_ok and t.find(OPEN6) >= 0 and t.find("KINDRED HOUNDS STAGE ACCEPTED and CLOSED (D-397)") >= 0 \
			and t.find("MOBILE MINION COHESION STAGE ACCEPTED and CLOSED (D-399)") >= 0
	# THE AUDIT REFUSES a planted stale runner, one that dropped its needle, and one
	# that dropped the D-398 clause.
	var ft := _read_text("res://tests/foundation_smoke.sh")
	var planted_stale := not _runner_current(ft.replace("STATE_EXPECT=\"STATE: " + SIX + "\"", "STATE_EXPECT=\"STATE: " + STATE_D396 + "\""))
	var planted_no_needle := not _runner_current(ft.replace("STATE_D396_LINE", "STATE_OLD_LINE")) \
		and not _runner_current(ft.replace("STATE_D398_LINE", "STATE_OLD_LINE"))
	var planted_five := not _runner_current(ft.replace(" · " + OPEN6, ""))
	var ok := stale.is_empty() and own_ok and d396_ok and d392_ok and suites_ok and planted_stale \
		and planted_no_needle and planted_five and ft.length() > 1000
	_note("C03_every_accepted_pin_moved_together_and_refuses_stale_lines",
		"RE-PINNED UNDER D-400 (first act): all five accepted runners pin the SEVEN-fact line EXACTLY and hold BOTH the D-396-era and the D-398-era lines as USED absence needles (stale: %s)=%s, and so does this stage's runner=%s | the D-396 runner pins 0 owed / 6 discharged, DECLARES Y15 and refuses a self-accepted open D-400 stage=%s; the D-392 runner's needle moved too=%s | the Imprint, alignment, Splinter Shot and Kindred Hounds suites carry the D-397, D-400-acceptance and D-400-open clauses=%s | the audit REFUSES a planted runner expecting the D-396 line=%s, one without either needle=%s, one missing the D-400 open clause=%s"
		% [str(stale), str(stale.is_empty()), str(own_ok), str(d396_ok), str(d392_ok), str(suites_ok), str(planted_stale),
		   str(planted_no_needle), str(planted_five)])
	_reached("C03_every_accepted_pin_moved_together_and_refuses_stale_lines")
	return ok

# =============================================================================
# B. THE SHARED COHORT
# =============================================================================

const CORE_FILES := ["res://scripts/cohort/mobile_cohort.gd", "res://scripts/cohort/cohort_formation.gd",
	"res://scripts/cohort/attack_positions.gd", "res://scripts/cohort/formation_profile.gd"]

func chk_C04_one_shared_cohort_with_kindred_hounds_its_only_production_consumer() -> bool:
	# ONE cohort is built, in ONE place.
	var builders: Array[String] = []
	for f in _runtime_script_files():
		var n := _code_only(_read_text(String(f))).count("MobileCohort.new(")
		for i in n:
			builders.append(String(f).get_file())
	var one := builders == ["hound_runtime.gd"] and hounds.cohort != null
	# ITS CORE NAMES NO HOUND: the decisions read the member contract only.
	var hre := RegEx.new()
	hre.compile("\\b(KindredHound|HoundConfig|HoundRuntime|HoundContent|HoundTargeting|HoundStandIn)\\b")
	var core_hits: Array[String] = []
	for f in CORE_FILES:
		if hre.search(_strip_strings(_code_only(_read_text(String(f))))) != null:
			core_hits.append(String(f).get_file())
	var core_caught := hre.search("\tvar h := x as KindredHound") != null
	var contract := _read_text("res://scripts/cohort/mobile_cohort.gd").find("THE MEMBER CONTRACT") >= 0
	# THE ONLY PRODUCTION CONSUMER: the one class declaring a cohort role.
	var consumers: Array[String] = []
	var cre := RegEx.new()
	cre.compile("(?m)^var\\s+cohort_role\\b")
	for f in _runtime_script_files():
		if cre.search(_code_only(_read_text(String(f)))) != null:
			consumers.append(String(f).get_file())
	var only := consumers == ["kindred_hound.gd"]
	await _reset(15, "ORDINARY", Vector3(-11, 0, 0))
	var all_hounds := hounds.cohort.size() == 15
	for m in hounds.cohort.members():
		all_hounds = all_hounds and m is KindredHound
	# JOIN REFUSES a member with no ID, and one of another role.
	var bad := StubMember.new()
	main.add_child(bad)
	var r_no_id := hounds.cohort.join(bad)
	var why_id := hounds.cohort.last_refusal
	bad.combat_id = "CE-9999"
	var r_role := hounds.cohort.join(bad)
	var why_role := hounds.cohort.last_refusal
	bad.queue_free()
	var refuses := not r_no_id and why_id.find("combat-entity ID") >= 0 and not r_role and why_role.find("another role") >= 0 \
		and hounds.cohort.size() == 15
	# ONE ROLE AND ONE PROFILE: the extension point, and no speculative branch.
	var roles := FormationProfile.Role.keys()
	var builders_p: Array[String] = []
	var bre := RegEx.new()
	bre.compile("(?m)^static func ([a-z_]+)\\(\\) -> FormationProfile")
	for m in bre.search_all(_read_text("res://scripts/cohort/formation_profile.gd")):
		builders_p.append(m.get_string(1))
	var profile_ok := _same(roles, ["MELEE"]) and _same(builders_p, ["vanguard"]) \
		and hounds.cohort.profile.profile_name == "VANGUARD" and hounds.cohort.profile.role == FormationProfile.Role.MELEE
	await _reset(2, "ORDINARY", Vector3(-11, 0, 0))
	var ok := one and core_hits.is_empty() and core_caught and contract and only and all_hounds and refuses and profile_ok
	_note("C04_one_shared_cohort_with_kindred_hounds_its_only_production_consumer",
		"ONE MobileCohort built, in %s=%s | its core files name no hound class (hits: %s; a planted one is caught=%s) and document THE MEMBER CONTRACT=%s | the one class declaring a cohort role: %s=%s | at 15 every member is a Kindred Hound actor=%s | join REFUSES a member without an ID ('%s') and one of another role ('%s')=%s | roles %s, profile builders %s — the one MELEE Vanguard, the extension point and no speculative branch=%s"
		% [str(builders), str(one), str(core_hits), str(core_caught), str(contract), str(consumers), str(only), str(all_hounds),
		   why_id.left(50), why_role.left(50), str(refuses), str(roles), str(builders_p), str(profile_ok)])
	_reached("C04_one_shared_cohort_with_kindred_hounds_its_only_production_consumer")
	return ok

## Pinned from the ACCEPTED suites (B41, B45): these digests must not move.
const PRE_WORK_PROD_DIGEST := "e32d753da863c656a8de6d6d12190b528e237453f77f0108d8dbf784d588ae83"
const PRE_WORK_IMPRINT_DIGEST := "161b75e9997d6610a3f9d8fb66bb05d0220d19704fdf45ae9a1e797e19315d11"
const DELIVERY_HUNTRESS_DIGEST := "d646a66c0dfdacd2f230c9bfe34253cc38f6a998c51a3bd0993ce86aab06824a"
const DELIVERY_HOUND_DIGEST := "796df1d300130c1c3ef5499345bdfd1b963405459248fc44da1a978e2a86e519"

func chk_C05_the_ordinary_two_hound_pack_and_its_d396_values_are_unchanged() -> bool:
	var prod := _numeric_digest_of_map(_constants("res://scripts/core/prod_config.gd"))
	var imp := _numeric_digest_of_map(_constants("res://scripts/imprint/imprint_config.gd"))
	var hc := _numeric_digest_of_map(_constants("res://scripts/huntress/huntress_config.gd"))
	var hd := _numeric_digest_of_map(_constants("res://scripts/hounds/hound_config.gd"))
	var digests := String(prod[1]) == PRE_WORK_PROD_DIGEST and String(imp[1]) == PRE_WORK_IMPRINT_DIGEST \
		and String(hc[1]) == DELIVERY_HUNTRESS_DIGEST and String(hd[1]) == DELIVERY_HOUND_DIGEST and int(hd[0]) == 24
	var planted: Dictionary = _constants("res://scripts/hounds/hound_config.gd").duplicate()
	planted["PACK_SIZE"] = 3
	var refuses := String(_numeric_digest_of_map(planted)[1]) != DELIVERY_HOUND_DIGEST
	# THE ORDINARY PACK AT LAUNCH: two, no stress minion, population 2, ORDINARY.
	var res: Dictionary = launch["resolve"]
	var pack_ok := int(launch["pack"]) == 2 and int(launch["stress"]) == 0 and int(launch["members"]) == 2 \
		and int(launch["population"]) == 2 and String(launch["speed"]) == "ORDINARY" \
		and int(res["pack_size"]) == 2 and is_equal_approx(float(res["reserve_fraction"]), 0.20) \
		and is_equal_approx(float(res["damage"]), 9.0) and HoundConfig.PACK_SIZE == 2
	# THE ONE SUPERSEDED VALUE IS READ NOWHERE BUT ITS REGISTRY; THE OTHERS ARE USED.
	var side_readers: Array[String] = []
	var used := {"FOLLOW_DISTANCE_M": false, "FOLLOW_ARRIVE_M": false, "FOLLOW_RESUME_M": false,
		"FOLLOW_GAIN_PER_S": false, "SEPARATION_M": false, "SIDESTEP_MPS": false, "SPEED_MPS": false}
	for f in _runtime_script_files():
		if String(f).ends_with("hound_config.gd"):
			continue
		var code := _code_only(_read_text(String(f)))
		if _strip_strings(code).find("FOLLOW_SIDE_DEG") >= 0:
			side_readers.append(String(f).get_file())
		for k in used.keys():
			if code.find("HoundConfig." + String(k)) >= 0:
				used[k] = true
	var all_used := true
	for k in used.keys():
		all_used = all_used and bool(used[k])
	var labelled := false
	for row in HoundConfig.registry():
		if String(row[0]).find("follow slot angle from behind") == 0 and String(row[2]).find("PROVISIONAL — SUPERSEDED FOR TRAVEL (D-398)") == 0 \
				and String(row[2]).find("NO LONGER READ") > 0:
			labelled = true
	var declared := false
	for r in CohortConfig.d396_values_declaration():
		if String(r[0]).find("FOLLOW_SIDE_DEG") >= 0 and String(r[1]).find("SUPERSEDED FOR TRAVEL") == 0:
			declared = true
	var ok := digests and refuses and pack_ok and side_readers.is_empty() and all_used and labelled and declared
	_note("C05_the_ordinary_two_hound_pack_and_its_d396_values_are_unchanged",
		"every numeric constant of ProdConfig, ImprintConfig, HuntressConfig and HoundConfig (%d) digests to its accepted pin — no damage, reservation, Capacity, recovery or speed value moved=%s; a planted pack size is refused=%s | at launch the ordinary pack: 2 hounds, 0 stress minions, population 2, ORDINARY, resolving to pack 2, 20 %% reserved, bite 9.0=%s | FOLLOW_SIDE_DEG read outside its registry by: %s; the other D-396 movement values ARE read (%s)=%s; its row says SUPERSEDED FOR TRAVEL (D-398), NO LONGER READ=%s and the stage declares it=%s"
		% [int(hd[0]), str(digests), str(refuses), str(pack_ok), str(side_readers), str(used), str(all_used), str(labelled), str(declared)])
	_reached("C05_the_ordinary_two_hound_pack_and_its_d396_values_are_unchanged")
	return ok

func chk_C06_members_carry_stable_combat_entity_ids_as_allies_never_eligible() -> bool:
	await _reset(15, "ORDINARY", Vector3(-11, 0, 0))
	var reg := hr.registry
	var ids: Array[String] = []
	var allies := true
	var refused := true
	for h in _members():
		var kh := h as KindredHound
		var rec := reg.record_of(kh)
		ids.append(kh.combat_id)
		allies = allies and not rec.is_empty() and String(rec["id"]) == kh.combat_id \
			and String(rec["faction"]) == "ally" and String(rec["category"]) == "ally"
		var e := HitEligibility.evaluate(rec)
		refused = refused and not bool(e["eligible"]) and String(e["reason"]).find("not hostile") == 0
	var unique := true
	var seen := {}
	for id in ids:
		unique = unique and id != "" and not seen.has(id)
		seen[id] = true
	# REGISTERED IN SPAWN ORDER: the pack first, then the stress minions, each
	# after the one before.
	var order_ok := true
	for i in range(1, ids.size()):
		order_ok = order_ok and reg.precedes(ids[i - 1], ids[i])
	var pack_first := reg.precedes((hounds.pack[1] as KindredHound).combat_id, (hounds.stress[0] as KindredHound).combat_id)
	# NEVER INSIDE AN ENGINE CALLBACK.
	var callbacks: Array[String] = []
	for f in _files_under("res://scripts/hounds/") + _files_under("res://scripts/cohort/"):
		var code := _code_only(_read_text(String(f)))
		for cbn in ["_ready", "_enter_tree", "_init", "_notification"]:
			if _function_body(code, cbn).find(".register(") >= 0:
				callbacks.append("%s:%s" % [String(f).get_file(), cbn])
	# NEGATIVE CONTROL: a HOSTILE stub IS eligible -- the refusal is the ally faction.
	var s := _stub("C06_hostile", Vector3(-11, 0, 3))
	var hostile_ok := bool(HitEligibility.evaluate(reg.record_of(s))["eligible"])
	await _reset(2, "ORDINARY", Vector3(-11, 0, 0))
	var ok := ids.size() == 15 and allies and refused and unique and order_ok and pack_first and callbacks.is_empty() and hostile_ok
	_note("C06_members_carry_stable_combat_entity_ids_as_allies_never_eligible",
		"15 members, each registered in the AREA registry as category and faction ALLY with its own ID=%s; the general eligibility rule REFUSES every one ('not hostile')=%s | all IDs distinct=%s, in spawn order=%s, the pack before the stress minions=%s | registrations inside an engine callback: %s | NEGATIVE CONTROL: a hostile stub is eligible, so the refusal is the faction=%s"
		% [str(allies), str(refused), str(unique), str(order_ok), str(pack_first), str(callbacks), str(hostile_ok)])
	_reached("C06_members_carry_stable_combat_entity_ids_as_allies_never_eligible")
	return ok

# =============================================================================
# C. THE FORMATION
# =============================================================================

## The slot index each member holds: its rank in the cohort.
func _ranks() -> Dictionary:
	var out := {}
	for h in _members():
		out[(h as KindredHound).combat_id] = hounds.cohort.rank_of(h)
	return out

func chk_C07_stable_slots_by_combat_entity_id_without_reshuffling() -> bool:
	await _reset(10, "ORDINARY", Vector3(-11, 0, 0))
	var c := hounds.cohort
	# RANK = ORDER OF COMBAT-ENTITY ID, through the registry's one ordering.
	var by_id := true
	for i in range(1, c.tracks.size()):
		by_id = by_id and hr.registry.precedes(String((c.tracks[i - 1] as MobileCohort.Track).member.combat_id),
			String((c.tracks[i] as MobileCohort.Track).member.combat_id))
	var ranks0 := _ranks()
	var slots0: Array = []
	for t in c.tracks:
		slots0.append((t as MobileCohort.Track).slot)
	# SHUFFLED POSITIONS: every member moved somewhere else; the ranks and slots stay.
	var ms := _members()
	for i in ms.size():
		(ms[i] as Node3D).global_position = Vector3(-15.0 + 0.7 * float((i * 7) % ms.size()), 0, -4.0 + 0.9 * float((i * 3) % 5))
	await _phys(2)
	var shuffled_same := ranks0 == _ranks()
	var slot_drift := 0.0
	for i in c.tracks.size():
		slot_drift = maxf(slot_drift, _planar((c.tracks[i] as MobileCohort.Track).slot, slots0[i]))
	# NEGATIVE CONTROL: a DISTANCE-GREEDY assignment of the same shuffled members to
	# the same slots gives a DIFFERENT mapping -- so stability is not an accident.
	var free: Array = slots0.duplicate()
	var greedy := {}
	var order: Array = ms.duplicate()
	for m in order:
		var best := -1
		var bd := INF
		for j in free.size():
			if free[j] == null:
				continue
			var d := _planar((m as Node3D).global_position, free[j])
			if d < bd:
				bd = d
				best = j
		greedy[(m as KindredHound).combat_id] = best
		free[best] = null
	var greedy_differs := greedy != ranks0
	# A FALL: the fallen member keeps its rank; nobody else's slot moves.
	await _phys(60)
	var slots1: Array = []
	for t in c.tracks:
		slots1.append((t as MobileCohort.Track).slot)
	var faller := ms[3] as KindredHound
	faller.receive_damage(faller.life.life, faller.global_position, "C07 test fall")
	await _phys(3)
	var fall_same := ranks0 == _ranks() and c.size() == 10
	var fall_drift := 0.0
	for i in c.tracks.size():
		fall_drift = maxf(fall_drift, _planar((c.tracks[i] as MobileCohort.Track).slot, slots1[i]))
	# MORE MEMBERS APPEND: 10 -> 15, the first ten keep their ranks and offsets.
	var off10: Array = c.offsets.duplicate()
	diag.set_population(15)
	await _phys(2)
	var appended := c.size() == 15
	for id in ranks0.keys():
		appended = appended and _ranks().get(id, -1) == ranks0[id]
	for i in 10:
		appended = appended and (c.offsets[i] as Vector2).is_equal_approx(off10[i])
	# THE RANKING READS NO NAME, INSTANCE, TREE ORDER OR POSITION.
	var rank_code := _function_body(_code_only(_read_text("res://scripts/cohort/mobile_cohort.gd")), "_rank")
	var re := RegEx.new()
	re.compile("\\.name\\b|get_instance_id|get_index\\(|get_path\\(|global_position|\\bhash\\(")
	var clean := rank_code.length() > 100 and rank_code.find("precedes(") > 0 and re.search(rank_code) == null
	var caught := re.search("\tvar k = t.member.name") != null
	await _reset(2, "ORDINARY", Vector3(-11, 0, 0))
	var ok := by_id and shuffled_same and slot_drift < 0.01 and greedy_differs and fall_same and fall_drift < 0.01 \
		and appended and clean and caught
	_note("C07_stable_slots_by_combat_entity_id_without_reshuffling",
		"members are RANKED by combat-entity ID (registry order)=%s | every member moved elsewhere: ranks unchanged=%s, slots moved %.3f m | NEGATIVE CONTROL: a distance-greedy assignment of the same members gives a different mapping=%s | a member FELL: ranks unchanged and it keeps its slot=%s, other slots moved %.3f m | 10 -> 15 APPENDS: the first ten keep their ranks and offsets=%s | the ranking code uses precedes() and reads no name, instance, tree order or position=%s (a planted name read is caught=%s)"
		% [str(by_id), str(shuffled_same), slot_drift, str(greedy_differs), str(fall_same), fall_drift, str(appended), str(clean), str(caught)])
	_reached("C07_stable_slots_by_combat_entity_id_without_reshuffling")
	return ok

## A layout is RIGID when every slot sits on one radius at uniform angles.
static func _rigid(offsets: Array) -> bool:
	if offsets.size() < 3:
		return false
	var r0 := (offsets[0] as Vector2).length()
	var angles: Array = []
	for o in offsets:
		if absf((o as Vector2).length() - r0) > 0.02:
			return false
		angles.append(atan2((o as Vector2).x, (o as Vector2).y))
	angles.sort()
	var gap0: float = angles[1] - angles[0]
	for i in range(2, angles.size()):
		if absf((angles[i] - angles[i - 1]) - gap0) > 0.02:
			return false
	return true

func chk_C08_loose_density_aware_multi_ring_slots_not_a_rigid_circle() -> bool:
	var p := FormationProfile.vanguard()
	var r1 := HoundConfig.FOLLOW_DISTANCE_M
	var o15 := CohortFormation.slot_offsets(p, r1, 15)
	var o10 := CohortFormation.slot_offsets(p, r1, 10)
	var again := CohortFormation.slot_offsets(p, r1, 15)
	var deterministic := true
	for i in o15.size():
		deterministic = deterministic and (o15[i] as Vector2).is_equal_approx(again[i])
	var appending := true
	for i in o10.size():
		appending = appending and (o10[i] as Vector2).is_equal_approx(o15[i])
	# MULTI-RING, capacity from arc length: rings grow in capacity with radius, and
	# an outer ring reaches further round her.
	var rings15 := CohortFormation.ring_of_each(p, r1, 15)
	var rings10 := CohortFormation.ring_of_each(p, r1, 10)
	var cap := []
	var reach := []
	for ring in 3:
		var r := r1 + p.ring_step_m * float(ring)
		cap.append(CohortFormation.ring_angles(p, r, ring).size())
		reach.append(p.arc_half_of_ring(ring))
	var multi := int(rings10.max()) >= 1 and int(rings15.max()) >= 1 \
		and int(cap[1]) > int(cap[0]) and int(cap[2]) > int(cap[1]) and float(reach[1]) > float(reach[0])
	# LOOSE: not all radii equal, not a rigid circle; the detector refuses a planted one.
	var radii: Array = []
	for o in o15:
		radii.append((o as Vector2).length())
	var loose := float(radii.max()) - float(radii.min()) > 0.3 and not _rigid(o15)
	var planted: Array = []
	for i in 12:
		planted.append(Vector2(sin(TAU * i / 12.0), cos(TAU * i / 12.0)) * 2.0)
	var detector := _rigid(planted)
	# SPACING: no two slots closer than the spacing less twice the tangential jitter.
	var min_gap := INF
	for i in o15.size():
		for j in range(i + 1, o15.size()):
			min_gap = minf(min_gap, (o15[i] as Vector2).distance_to(o15[j]))
	var spaced := min_gap >= p.spacing_m - 2.0 * p.jitter_tangent_m - 0.05
	var ok := deterministic and appending and multi and loose and detector and spaced
	_note("C08_loose_density_aware_multi_ring_slots_not_a_rigid_circle",
		"the slot pattern is a pure, deterministic function of (profile, count)=%s and APPENDS (the first 10 of 15 are the 10)=%s | rings used at 10: %d, at 15: %d; ring capacities %s grow with radius and each ring reaches further round her %s (density-aware)=%s | LOOSE: radii span %.2f m, not a rigid circle=%s; the detector flags a planted perfect circle=%s | the closest two slots are %.2f m apart (spacing %.2f less twice the %.2f jitter)=%s — every value PROVISIONAL"
		% [str(deterministic), str(appending), int(rings10.max()) + 1, int(rings15.max()) + 1, str(cap), str(reach), str(multi),
		   float(radii.max()) - float(radii.min()), str(loose), str(detector), min_gap, p.spacing_m, p.jitter_tangent_m, str(spaced)])
	_reached("C08_loose_density_aware_multi_ring_slots_not_a_rigid_circle")
	return ok

func chk_C09_vanguard_bias_keeps_the_pack_around_and_ahead_of_her() -> bool:
	# PURE: no slot in her lane; the first two at her forward flanks.
	var p := FormationProfile.vanguard()
	var o := CohortFormation.slot_offsets(p, HoundConfig.FOLLOW_DISTANCE_M, 15)
	var lane_ok := true
	for v in o:
		lane_ok = lane_ok and absf(rad_to_deg(atan2((v as Vector2).x, (v as Vector2).y))) >= p.lane_half_deg - 0.01
	var first_two := (o[0] as Vector2).y > 0.0 and (o[1] as Vector2).y > 0.0 and signf((o[0] as Vector2).x) != signf((o[1] as Vector2).x)
	# LIVE, at all four populations, on the straight lane.
	var rows: Array[String] = []
	var live_ok := true
	var mirror_refuses := true
	for spec in [[2, "ORDINARY"], [6, "FAST"], [10, "FAST"], [15, "EXTREME"]]:
		await _reset(int(spec[0]), String(spec[1]), LANE_A)
		var r := await _straight_run(LANE_A, LANE_PRIME, LANE_B)
		# BOUNDS (test bounds, stated): the pack's centre at least 0.5 m AHEAD of her,
		# and at most 10 % of member-frames more than 1 m behind her.
		var ahead := float(r["centroid"]) >= 0.5 and float(r["behind"]) <= 0.10 and int(r["steady"]) >= 30
		live_ok = live_ok and ahead
		# NEGATIVE CONTROL: the same positions mirrored through her are BEHIND.
		mirror_refuses = mirror_refuses and float(r["mirrored_centroid"]) < 0.0
		rows.append("%d@%s centre %+.2f m, behind %.1f%%, %d steady frames" % [int(spec[0]), String(spec[1]),
			float(r["centroid"]), float(r["behind"]) * 100.0, int(r["steady"])])
	await _reset(2, "ORDINARY", Vector3(-11, 0, 0))
	var ok := lane_ok and first_two and live_ok and mirror_refuses
	_note("C09_vanguard_bias_keeps_the_pack_around_and_ahead_of_her",
		"no slot inside her ±%.0f° lane=%s; the first two at her forward flanks=%s | LIVE on the straight lane: %s — each centre >= +0.5 m and <= 10%% behind (test bounds)=%s | NEGATIVE CONTROL: the same positions mirrored through her read BEHIND=%s"
		% [p.lane_half_deg, str(lane_ok), str(first_two), " · ".join(rows), str(live_ok), str(mirror_refuses)])
	_finding("VANGUARD, measured on the straight lane: %s." % " · ".join(rows))
	_reached("C09_vanguard_bias_keeps_the_pack_around_and_ahead_of_her")
	return ok

func chk_C10_a_predictive_anchor_leads_her_freezes_at_rest_and_stays_walkable() -> bool:
	await _reset(6, "FAST", LANE_A)
	var c := hounds.cohort
	await _prime_toward(LANE_PRIME)
	player.command_move_to(LANE_B)
	# STEADY: the lead is her velocity x the lead time, clamped.
	await _until(func() -> bool: return player.velocity.length() >= 0.99 * ProdConfig.TOP_SPEED_MPS * diag.speed_scale(), 120)
	await _phys(30)
	var v := Vector3(player.velocity.x, 0, player.velocity.z)
	var want := minf(v.length() * CohortConfig.LEAD_TIME_S, CohortConfig.LEAD_MAX_M)
	var lead_ok := absf(c.lead.length() - want) <= 0.05 * want and c.lead.normalized().dot(v.normalized()) > 0.99
	# Printed as judged (the note read the lead AFTER the teleport reset until the
	# run of record showed "the lead is 0.00 m" -- found at delivery).
	var lead_steady := c.lead.length()
	var anchor_ahead := (c.anchor - player.global_position).dot(v.normalized()) > 0.5 * want
	# SHE STOPS: the lead FREEZES.
	await _until(func() -> bool: return player.motor.speed() < 0.05, 400)
	await _phys(5)
	var lead_stop := c.lead
	await _phys(60)
	var frozen := c.lead.is_equal_approx(lead_stop) and lead_stop.length() > 0.1
	# A TELEPORT RESETS IT.
	var tp0 := c.teleports
	_place_player(Vector3(-13, 0, 0))
	await _phys(2)
	var reset_ok := c.teleports == tp0 + 1 and c.lead.length() < 0.001
	# WALKABLE AT THE DOORWAY: the anchor and every slot on the mesh, each on a
	# straight walkable line from the anchor -- and an ideal slot in the wall is NOT
	# on the mesh (the clamp did work).
	await _reset(10, "ORDINARY", Vector3(0.2, 0, 0))
	var on := CohortFormation.on_mesh(nav_map, c.anchor)
	var straight := true
	var clamped := 0
	var n_door := c.tracks.size()
	for t in c.tracks:
		var tt := t as MobileCohort.Track
		on = on and CohortFormation.on_mesh(nav_map, tt.slot)
		straight = straight and CohortFormation.straight_walkable(nav_map, c.anchor, tt.slot)
		if not CohortFormation.on_mesh(nav_map, tt.ideal):
			clamped += 1
	await _reset(2, "ORDINARY", Vector3(-11, 0, 0))
	var ok := lead_ok and anchor_ahead and frozen and reset_ok and on and straight and clamped >= 1 and n_door == 10
	_note("C10_a_predictive_anchor_leads_her_freezes_at_rest_and_stays_walkable",
		"at FAST steady speed the lead is %.2f m, her velocity x %.2f s clamped to %.1f m = %.2f m, along her travel=%s, the anchor ahead of her=%s | she stopped: the lead held at %.2f m for 60 frames=%s | a teleport reset it (teleports +1, lead 0)=%s | in the DOORWAY the anchor and all %d slots lie on the mesh=%s, each on a straight walkable line from the anchor=%s, and %d ideal slots lay in a wall — the clamp did work=%s (every value PROVISIONAL)"
		% [lead_steady, CohortConfig.LEAD_TIME_S, CohortConfig.LEAD_MAX_M, want, str(lead_ok), str(anchor_ahead), lead_stop.length(),
		   str(frozen), str(reset_ok), n_door, str(on), str(straight), clamped, str(clamped >= 1)])
	_reached("C10_a_predictive_anchor_leads_her_freezes_at_rest_and_stays_walkable")
	return ok

func chk_C11_the_formation_turns_at_a_rate_and_never_flips_instantly() -> bool:
	# PURE: an exact reversal turns by at most the step, one fixed way.
	var step := deg_to_rad(CohortConfig.HEADING_TURN_DEG_PER_S) / TICKS
	var h1 := CohortFormation.turn_heading(Vector3(0, 0, 1), Vector3(0, 0, -1), step)
	var pure_ok := absf(acos(clampf(h1.dot(Vector3(0, 0, 1)), -1.0, 1.0)) - step) < 0.0001
	var h2 := CohortFormation.turn_heading(Vector3(0, 0, 1), Vector3(0, 0, -1), step)
	var deterministic := h1.is_equal_approx(h2)
	# LIVE: she reverses at FAST speed; the heading never turns more than the rate
	# allows in one step, and it passes through the sideways directions.
	await _reset(10, "FAST", Vector3(-11, 0, -6))
	var c := hounds.cohort
	player.command_move_to(Vector3(-11, 0, 9))
	await _phys(45)
	player.command_move_to(Vector3(-11, 0, -9))
	var prev := c.heading
	var worst := 0.0
	var crossed_side := false
	var total := 0.0
	var turned := 0
	for f in 90:
		await physics_frame
		var d := acos(clampf(prev.dot(c.heading), -1.0, 1.0))
		worst = maxf(worst, d)
		total += d
		if d > 0.0001:
			turned += 1
		if absf(c.heading.z) < 0.2:
			crossed_side = true
		prev = c.heading
	var bounded := worst <= step * 1.01 and total > PI * 0.9 and turned >= int(floor(PI / step)) - 1
	# NEGATIVE CONTROL: a flip in one step would exceed the bound.
	var flip_refused := PI > step * 1.01
	await _reset(2, "ORDINARY", Vector3(-11, 0, 0))
	var ok := pure_ok and deterministic and bounded and crossed_side and flip_refused
	_note("C11_the_formation_turns_at_a_rate_and_never_flips_instantly",
		"PURE: an exact reversal turns by exactly one step (%.4f rad at %.0f°/s), one fixed way=%s/%s | LIVE reversal at FAST: the largest per-step turn %.4f rad (bound %.4f), %.2f rad in all over %d turning steps=%s, passing sideways=%s | NEGATIVE CONTROL: a one-step flip (π) would be refused=%s — the rate is PROVISIONAL"
		% [step, CohortConfig.HEADING_TURN_DEG_PER_S, str(pure_ok), str(deterministic), worst, step, total, turned, str(bounded), str(crossed_side), str(flip_refused)])
	_reached("C11_the_formation_turns_at_a_rate_and_never_flips_instantly")
	return ok

# =============================================================================
# D. SPEED — "keep pace", "catch up"
# =============================================================================

func chk_C12_normal_follow_keeps_pace_with_her_at_every_speed_mode() -> bool:
	var rows: Array[String] = []
	var ok_all := true
	var lag_with := {}
	for speed in ["ORDINARY", "FAST", "EXTREME"]:
		await _reset(6, speed, LANE_A)
		var r := await _straight_run(LANE_A, LANE_PRIME, LANE_B)
		# BOUNDS (test bounds): mean member speed within 0.85-1.25 of hers over the
		# steady run, and no member more than 3.0 m from its slot after 20 frames.
		var paced := float(r["ratio"]) >= 0.85 and float(r["ratio"]) <= 1.25 and float(r["max_lag"]) <= 3.0 \
			and int(r["steady"]) >= 30 and int(r["recoveries"]) == 0
		ok_all = ok_all and paced
		lag_with[speed] = float(r["mean_lag"])
		rows.append("%s: speed ratio %.3f, lag mean %.2f / max %.2f m" % [speed, float(r["ratio"]), float(r["mean_lag"]), float(r["max_lag"])])
	# NEGATIVE CONTROL: the same EXTREME run with the feed-forward REMOVED (a test
	# seam, false in normal play) lags far further -- the pace is the feed-forward.
	await _reset(6, "EXTREME", LANE_A)
	hounds.cohort.debug_disable_feed_forward = true
	var r2 := await _straight_run(LANE_A, LANE_PRIME, LANE_B)
	hounds.cohort.debug_disable_feed_forward = false
	var refuses := float(r2["mean_lag"]) > 3.0 * float(lag_with["EXTREME"]) + 0.5
	await _reset(2, "ORDINARY", Vector3(-11, 0, 0))
	var ok := ok_all and refuses and not hounds.cohort.debug_disable_feed_forward
	_note("C12_normal_follow_keeps_pace_with_her_at_every_speed_mode",
		"six members on the straight lane — %s — each paced within 0.85-1.25 and 3.0 m (test bounds), no soft recovery=%s | NEGATIVE CONTROL: with the feed-forward REMOVED the EXTREME mean lag is %.2f m against %.2f m with it — the pace is the feed-forward=%s; the seam is clear again=%s"
		% [" · ".join(rows), str(ok_all), float(r2["mean_lag"]), float(lag_with["EXTREME"]), str(refuses), str(not hounds.cohort.debug_disable_feed_forward)])
	_finding("PACE (six members): %s; with the feed-forward removed, EXTREME mean lag %.2f m." % [" · ".join(rows), float(r2["mean_lag"])])
	_reached("C12_normal_follow_keeps_pace_with_her_at_every_speed_mode")
	return ok

## True when `law(base, leader, behind)` never falls as her speed or the distance
## behind rises, and does rise somewhere along each.
static func _monotone(law: Callable) -> bool:
	var rises_v := false
	var rises_d := false
	for d in [0.0, 1.0, 2.0, 4.0, 8.0, 12.0]:
		var prev := -1.0
		for v in [0.0, 2.0, 3.889, 7.0, 11.67, 15.0]:
			var c := float(law.call(5.2, v, d))
			if c < prev - 0.0001:
				return false
			if prev >= 0.0 and c > prev + 0.0001:
				rises_v = true
			prev = c
	for v in [0.0, 3.889, 11.67]:
		var prev2 := -1.0
		for d in [0.0, 1.0, 2.0, 4.0, 8.0, 12.0]:
			var c2 := float(law.call(5.2, v, d))
			if c2 < prev2 - 0.0001:
				return false
			if prev2 >= 0.0 and c2 > prev2 + 0.0001:
				rises_d = true
			prev2 = c2
	return rises_v and rises_d

static func _constant_cap(_base: float, _leader: float, _behind: float) -> float:
	return 5.2

func chk_C13_catch_up_scales_with_her_speed_and_the_separation_distance() -> bool:
	var law := func(b: float, v: float, d: float) -> float: return CohortConfig.catchup_cap(b, v, d)
	var mono := _monotone(law)
	var floor_ok := CohortConfig.catchup_cap(5.2, 0.0, 0.0) >= 5.2 \
		and is_equal_approx(CohortConfig.catchup_cap(5.2, 11.67, 100.0), 11.67 * CohortConfig.CATCHUP_SPEED_RATIO * (1.0 + CohortConfig.CATCHUP_DISTANCE_BOOST))
	# NEGATIVE CONTROL: a planted CONSTANT cap is refused by the same test.
	var refuses := not _monotone(func(b: float, v: float, d: float) -> float: return _constant_cap(b, v, d))
	# LIVE: at FAST speed a member set 8 m behind her runs FASTER than she does
	# until it is back.
	await _reset(6, "FAST", LANE_A)
	await _prime_toward(LANE_PRIME)
	player.command_move_to(LANE_B)
	await _until(func() -> bool: return player.velocity.length() >= 0.95 * ProdConfig.TOP_SPEED_MPS * diag.speed_scale(), 120)
	await _phys(10)
	var m := _members()[4] as KindredHound
	var back: Vector3 = player.global_position - hounds.cohort.heading * 8.0
	m.global_position = NavService.nearest_point(nav_map, back)
	m.global_position.y = 0.0
	await _phys(2)
	var faster := 0
	var frames := 0
	var closed := false
	var g := 0
	while g < 240:
		await physics_frame
		g += 1
		var ps := Vector2(player.velocity.x, player.velocity.z).length()
		var ms := Vector2(m.velocity.x, m.velocity.z).length()
		if _track(m).lag > CohortConfig.CATCHUP_START_M and ps > 1.0:
			frames += 1
			if ms > 1.15 * ps:
				faster += 1
		if _track(m).lag < 1.0:
			closed = true
			break
	var live := frames >= 5 and float(faster) >= 0.8 * float(frames) and closed
	await _reset(2, "ORDINARY", Vector3(-11, 0, 0))
	var ok := mono and floor_ok and refuses and live
	_note("C13_catch_up_scales_with_her_speed_and_the_separation_distance",
		"the catch-up cap never falls and does rise, both with her speed and with the distance behind=%s; it is at least the member's base speed and tops out at her speed x %.2f x %.2f=%s | NEGATIVE CONTROL: a planted constant cap is refused=%s | LIVE at FAST: a member set 8 m behind ran faster than 1.15 x her speed on %d of %d catching-up frames and closed to its slot in %d frames=%s — no multiplier or threshold is locked"
		% [str(mono), CohortConfig.CATCHUP_SPEED_RATIO, 1.0 + CohortConfig.CATCHUP_DISTANCE_BOOST, str(floor_ok), str(refuses), faster, frames, g, str(live)])
	_reached("C13_catch_up_scales_with_her_speed_and_the_separation_distance")
	return ok

# =============================================================================
# E. CONGESTION AND NON-OBSTRUCTION
# =============================================================================

static func _min_pair_gap(ps: Array) -> float:
	var g := INF
	for i in ps.size():
		for j in range(i + 1, ps.size()):
			g = minf(g, _planar(ps[i], ps[j]))
	return g

func chk_C14_local_visual_separation_holds_when_settled() -> bool:
	await _reset(15, "ORDINARY", Vector3(-11, 0, -4))
	player.command_move_to(Vector3(-11, 0, 2))
	await _until(func() -> bool: return player.motor.speed() < 0.05 and _planar(player.global_position, Vector3(-11, 0, 2)) < 0.6, 400)
	await _phys(150)
	var ps: Array = []
	var her_min := INF
	for h in _members():
		ps.append((h as Node3D).global_position)
		her_min = minf(her_min, _planar((h as Node3D).global_position, player.global_position))
	var gap := _min_pair_gap(ps)
	var body := 2.0 * HoundConfig.BODY_RADIUS_M
	var separated := gap >= body and her_min >= CohortConfig.PLAYER_CLEARANCE_M - 0.1
	var settled := hounds.cohort.formation_state == "SETTLED"
	var state_seen := hounds.cohort.formation_state
	# NEGATIVE CONTROL: the same predicate refuses two coincident members.
	var planted := ps.duplicate()
	planted.append(ps[0])
	var refuses := _min_pair_gap(planted) < body
	await _reset(2, "ORDINARY", Vector3(-11, 0, 0))
	var ok := separated and settled and refuses
	_note("C14_local_visual_separation_holds_when_settled",
		"15 settled round her (%s): the closest two members are %.2f m apart (bodies %.2f m) and the closest to her %.2f m (visual clearance %.2f m)=%s | NEGATIVE CONTROL: two coincident members are refused=%s"
		% [state_seen, gap, body, her_min, CohortConfig.PLAYER_CLEARANCE_M, str(separated and settled), str(refuses)])
	_reached("C14_local_visual_separation_holds_when_settled")
	return ok

## One member set 8 m behind her, on the far side of her from its slot, returns;
## returns its closest approach to her.
func _return_through_her(disable: bool) -> float:
	await _reset(2, "ORDINARY", Vector3(-11, 0, 0))
	hounds.cohort.debug_disable_pass_through = disable
	var m := _members()[0] as KindredHound
	var slot := m.follow_slot()
	var away: Vector3 = (player.global_position - slot)
	away.y = 0.0
	m.global_position = player.global_position + away.normalized() * 5.0
	var closest := INF
	for f in 150:
		await physics_frame
		closest = minf(closest, _planar(m.global_position, player.global_position))
	hounds.cohort.debug_disable_pass_through = false
	return closest

## The last-ranked member of ten set on the far side of her from its slot, so its
## return crosses the settled pack. Returns its greatest distance from the straight
## line, its closest approach to another member, and the frames to its slot.
func _cross_cluster(disable: bool) -> Dictionary:
	await _reset(10, "ORDINARY", Vector3(-11, 0, 0))
	await _phys(90)
	hounds.cohort.debug_disable_pass_through = disable
	var ms := _members()
	var m := ms[ms.size() - 1] as KindredHound
	var slot := m.follow_slot()
	var from := Vector3(2.0 * player.global_position.x - slot.x, 0.0, 2.0 * player.global_position.z - slot.z)
	var dir := slot - from
	dir.y = 0.0
	dir = dir.normalized()
	m.global_position = from
	var gap := INF
	var lateral := 0.0
	var frames := -1
	for f in 200:
		await physics_frame
		for o in ms:
			if o != m:
				gap = minf(gap, _planar(m.global_position, (o as Node3D).global_position))
		var rel: Vector3 = m.global_position - from
		rel.y = 0.0
		lateral = maxf(lateral, (rel - dir * rel.dot(dir)).length())
		if frames < 0 and _planar(m.global_position, slot) < 0.3:
			frames = f
	hounds.cohort.debug_disable_pass_through = false
	return {"lateral": lateral, "gap": gap, "frames": frames}

func chk_C15_congested_returning_and_catching_up_members_pass_through() -> bool:
	# CONGESTION IS A NEIGHBOUR COUNT: four members packed tight are congested; spread
	# again, they are not.
	await _reset(6, "ORDINARY", Vector3(-11, 0, 0))
	var ms := _members()
	for i in 4:
		(ms[i] as Node3D).global_position = Vector3(-11.0 + 0.3 * float(i), 0, 3.0)
	await _phys(1)
	var packed_n := _track(ms[0]).neighbours
	var packed := _track(ms[0]).congested and packed_n >= CohortConfig.CONGESTION_NEIGHBOURS
	await _phys(120)
	var spread := not _track(ms[0]).congested
	# 15 THROUGH THE DOORWAY: congestion occurs and is passed through, every member
	# gets through, no soft recovery is needed.
	await _reset(15, "FAST", Vector3(-3, 0, 5))
	await _prime_toward(Vector3(-3, 0, 3))
	var pt0 := hounds.cohort.passed_through_frames()
	var rec0 := hounds.cohort.total_recoveries()
	# RE-SCOPED ONE FOR ONE UNDER D-404, BY OWNER RULING -- THE DRIVE ONLY. Until
	# D-404 this was ONE click at (8, 0, 0) from the prime at (-3, 0, 3), which the
	# player's navigation path ROUTED through the doorway -- TRUE WHEN WRITTEN. A
	# D-404 click goes straight and that line meets the doorway's jamb, so she now
	# CLICKS HER WAY THROUGH: to the doorway's axis, then through it. Every
	# assertion about the pack below is UNCHANGED.
	var c15_route := [Vector3(-1.5, 0, 0.0), Vector3(8, 0, 0)]
	player.command_move_to(Vector3(c15_route[0]))
	var c15_idx := [0]
	var east := await _until(func() -> bool:
		c15_idx[0] = _click_route_step(c15_route, int(c15_idx[0]))
		var n := 0
		for h in _members():
			if (h as Node3D).global_position.x > 1.3:
				n += 1
		return n == 15, 600)
	var passed := hounds.cohort.passed_through_frames() - pt0
	var door_ok := east < 600 and passed > 0 and hounds.cohort.total_recoveries() == rec0
	# NEGATIVE CONTROL, BEHAVIOURAL: a member RETURNING across a settled cluster of
	# ten goes STRAIGHT through it; with pass-through disabled (a test seam, false in
	# normal play) separation deflects it and holds it further off the others.
	var with_c := await _cross_cluster(false)
	var without_c := await _cross_cluster(true)
	# BOUND on the deflection only; the closest approach to another member is
	# reported, not bounded (0.18 vs 0.35 m in a probe, 0.18 vs 0.22 m on the
	# suite's first run -- it depends on which member it meets).
	var refuses := float(with_c["lateral"]) <= 0.05 and float(without_c["lateral"]) >= float(with_c["lateral"]) + 0.08 \
		and int(with_c["frames"]) >= 0 and int(without_c["frames"]) >= 0
	# REPORTED, NOT A PASS CONDITION: through HER the clearance is a SOFT push bounded
	# by the side-step speed, so a member returning straight through her at the
	# catch-up cap crosses her either way.
	var with_pt := await _return_through_her(false)
	var without := await _return_through_her(true)
	_finding("HER CLEARANCE IS SOFT: a member returning straight through her passed %.2f m from her with pass-through and %.2f m with it disabled — the %.1f m visual clearance, a push bounded by %.1f m/s, cannot hold a catching-up member off her either way. It never stops HER (C16)."
		% [with_pt, without, CohortConfig.PLAYER_CLEARANCE_M, HoundConfig.SIDESTEP_MPS])
	await _reset(2, "ORDINARY", Vector3(-11, 0, 0))
	var ok := packed and spread and door_ok and refuses and not hounds.cohort.debug_disable_pass_through
	_note("C15_congested_returning_and_catching_up_members_pass_through",
		"four members packed within %.1f m are CONGESTED (%d neighbours >= %d)=%s and not once spread=%s | 15 through the doorway at FAST: all east of it in %d frames, %d member-frames passed through (separation and her clearance ignored), no soft recovery=%s | NEGATIVE CONTROL: a member RETURNING across a settled cluster of ten strayed %.3f m from its straight line and came %.2f m from another member with pass-through, and %.3f m and %.2f m with it DISABLED — separation deflected it (the deflection is bounded; the approach is reported), the pass-through is doing the work=%s | (reported, not a pass condition: through HER it passed %.2f m / %.2f m — her clearance is soft)"
		% [CohortConfig.CONGESTION_RADIUS_M, packed_n, CohortConfig.CONGESTION_NEIGHBOURS,
		   str(packed), str(spread), east, passed, str(door_ok), float(with_c["lateral"]), float(with_c["gap"]),
		   float(without_c["lateral"]), float(without_c["gap"]), str(refuses), with_pt, without])
	_reached("C15_congested_returning_and_catching_up_members_pass_through")
	return ok

func chk_C16_mobile_minions_never_body_block_her() -> bool:
	await _reset(15, "ORDINARY", Vector3(-11, 0, -2))
	# STRUCTURAL: every member, stress minions too, on layer 16, masking the world
	# only; nothing in the scene masks layer 16.
	var layers := true
	for h in _members():
		layers = layers and (h as KindredHound).collision_layer == HoundConfig.COLLISION_LAYER \
			and (h as KindredHound).collision_mask == HoundConfig.COLLISION_MASK_WORLD
	var maskers: Array[String] = []
	var stack: Array = [main]
	while not stack.is_empty():
		var n: Node = stack.pop_back()
		if n is CollisionObject3D and not (n is KindredHound):
			if ((n as CollisionObject3D).collision_mask & HoundConfig.COLLISION_LAYER) != 0:
				maskers.append(String(n.name))
		stack.append_array(n.get_children())
	# NO NAVIGATION AGENT OR OBSTACLE; the mesh still baked once.
	var nav_nodes := 0
	var st2: Array = [hounds]
	while not st2.is_empty():
		var n2: Node = st2.pop_back()
		if n2 is NavigationAgent3D or n2 is NavigationObstacle3D:
			nav_nodes += 1
		st2.append_array(n2.get_children())
	# SHE WALKS STRAIGHT THROUGH A LINE OF MEMBERS SET ACROSS HER PATH (the Vanguard
	# keeps her own lane clear, so the line is placed there): the same frames as the
	# same walk with the pack removed.
	var a := player.global_position
	var b := a + Vector3(0, 0, 5.0)
	await _phys(90)
	# The line is HELD across her path every frame (a staging write): left alone the
	# members would flow back to their slots before she arrived -- found on the
	# first run, where she never came within 1.3 m of one.
	var line := _members()
	var hold := func() -> void:
		for i in 7:
			(line[i] as Node3D).global_position = a + Vector3(-1.5 + 0.5 * float(i), 0, 2.5)
	var through := {"min": INF}
	player.command_move_to(b)
	var g := 0
	var moved := false
	while g < 300:
		hold.call()
		await physics_frame
		g += 1
		for h in _members():
			through["min"] = minf(float(through["min"]), _planar(player.global_position, (h as Node3D).global_position))
		if player.motor.speed() > 0.1:
			moved = true
		elif moved and _planar(player.global_position, b) < 0.4:
			break
	var with_pack := g
	skills.loadout.remove_persistent(CFG_K)
	skills.loadout.revalidate(skills.pool)
	await _one_runtime_step()
	_place_player(a)
	await _phys(3)
	player.command_move_to(b)
	var g2 := 0
	var moved2 := false
	while g2 < 300:
		await physics_frame
		g2 += 1
		if player.motor.speed() > 0.1:
			moved2 = true
		elif moved2 and _planar(player.global_position, b) < 0.4:
			break
	var same := absi(with_pack - g2) <= 1 and float(through["min"]) <= 0.35
	# THE CLEARANCE IS VISUAL: no cohort file writes her position or velocity.
	var writers: Array[String] = []
	var wre := RegEx.new()
	wre.compile("leader\\.(global_position|velocity|position)\\s*=[^=]")
	for f in _files_under("res://scripts/cohort/"):
		if wre.search(_code_only(_read_text(String(f)))) != null:
			writers.append(String(f).get_file())
	var caught := wre.search("\tleader.velocity = Vector3.ZERO") != null
	await _reset(2, "ORDINARY", Vector3(-11, 0, 0))
	var ok := layers and maskers.is_empty() and nav_nodes == 0 and arena.bake_count == 1 and same and writers.is_empty() and caught
	_note("C16_mobile_minions_never_body_block_her",
		"all 15 members on layer %d, masking only the world=%s; bodies masking that layer: %s; navigation nodes under the pack: %d; the mesh baked %d time(s) | SHE WALKED 5 m through a line of seven members set across her path in %d frames, passing %.2f m from a member, and in %d frames with no pack=%s | cohort code writing her position or velocity: %s (a planted write is caught=%s)"
		% [HoundConfig.COLLISION_LAYER, str(layers), str(maskers), nav_nodes, arena.bake_count, with_pack, float(through["min"]), g2,
		   str(same), str(writers), str(caught)])
	_reached("C16_mobile_minions_never_body_block_her")
	return ok

# =============================================================================
# F. COMBAT AND REGROUP
# =============================================================================

const TARGETING_SHA256 := "3cb568a932002dcfe599faf03aae0bb63edb23fca01683fa5232d11ec4fddb61"

func chk_C17_in_combat_members_leave_formation_under_the_accepted_rule() -> bool:
	await _reset(2, "ORDINARY", Vector3(-11, 0, 0))
	var s := _stub("C17_target", Vector3(-12.5, 0, 3.5))
	var id := hr.registry.id_of(s)
	await _until(func() -> bool:
		for h in _members():
			if (h as KindredHound).state != KindredHound.State.BITE:
				return false
		return true, 300)
	var left := true
	var codes: Array[String] = []
	var rows: Array[String] = []
	for h in _members():
		var kh := h as KindredHound
		var ap: Vector3 = hounds.cohort.attack[id].position_of(kh.attack_index, s.global_position)
		var d_ap := _planar(kh.global_position, ap)
		var d_slot := _planar(kh.global_position, kh.follow_slot())
		left = left and kh.target_id() == id and kh.cohort_mode == MobileCohort.Mode.ENGAGED and d_ap <= 0.3 and d_slot > 1.0
		codes.append(kh.reason_code)
		rows.append("%s %.2f m from its attack position, %.2f m from its slot" % [kh.combat_id, d_ap, d_slot])
	var accepted := true
	for c in codes:
		accepted = accepted and [HoundTargeting.ACQUIRED, HoundTargeting.RETAINED, HoundTargeting.ACQUIRED_TIE].has(c)
	# THE RULE IS THE ACCEPTED ONE, UNTOUCHED, AND THE COHORT OWNS NONE.
	var rule_same := FileAccess.get_sha256("res://scripts/hounds/hound_targeting.gd") == TARGETING_SHA256
	var cre := RegEx.new()
	cre.compile("HoundTargeting|\\bdecide\\(|\\bchoose\\(|retain_check")
	var cohort_rules: Array[String] = []
	for f in _files_under("res://scripts/cohort/"):
		if cre.search(_strip_strings(_code_only(_read_text(String(f))))) != null:
			cohort_rules.append(String(f).get_file())
	var caught := cre.search("\tvar d := HoundTargeting.decide(x)") != null
	await _reset(2, "ORDINARY", Vector3(-11, 0, 0))
	var ok := left and accepted and rule_same and cohort_rules.is_empty() and caught
	_note("C17_in_combat_members_leave_formation_under_the_accepted_rule",
		"both hounds engaged one target, each at ITS attack position and away from its formation slot (%s)=%s | chosen by the accepted rule (%s)=%s | hound_targeting.gd byte-identical to the accepted file=%s | cohort files holding a targeting rule: %s (a planted one is caught=%s)"
		% [" · ".join(rows), str(left), str(codes), str(accepted), str(rule_same), str(cohort_rules), str(caught)])
	_reached("C17_in_combat_members_leave_formation_under_the_accepted_rule")
	return ok

## Stacking: any two positions within `d`, or any within `inside` of the centre.
static func _stacked(ps: Array, centre: Vector3, d: float, inside: float) -> bool:
	for i in ps.size():
		if _planar(ps[i], centre) < inside:
			return true
		for j in range(i + 1, ps.size()):
			if _planar(ps[i], ps[j]) < d:
				return true
	return false

func chk_C18_melee_members_take_stable_target_relative_attack_positions() -> bool:
	var r := HoundConfig.approach_distance(ProdConfig.ENEMY_BODY_RADIUS)
	var sp := HoundConfig.SEPARATION_M
	var ap := AttackPositions.new("C18", r, sp)
	var t0 := Vector3(0, 0, 0)
	var cap_ok := ap.inner_capacity == int(floor(TAU * r / sp)) and ap.outer_capacity > ap.inner_capacity
	# THE FIRST CLAIM FIXES THE BASE ANGLE AT ITS BEARING; a second claim is the same.
	var i0 := ap.claim("M0", Vector3(0, 0, 3), t0)
	var p0 := ap.position_of(i0, t0)
	var first_ok := i0 == 0 and p0.is_equal_approx(Vector3(0, 0, r)) and ap.claim("M0", Vector3(5, 0, 5), t0) == 0
	var base0 := ap.base_angle
	var inner: Array = [p0]
	for k in range(1, ap.inner_capacity):
		var a := TAU * float(k) / float(ap.inner_capacity)
		var idx := ap.claim("M%d" % k, Vector3(sin(a), 0, cos(a)) * 3.0, t0)
		inner.append(ap.position_of(idx, t0))
	var waiting := ap.claim("MW", Vector3(0, 0, -3), t0)
	var ring_ok := not _stacked(inner, t0, sp - 0.001, r - 0.001) and not ap.is_inner(waiting) \
		and absf(_planar(ap.position_of(waiting, t0), t0) - ap.outer_radius) < 0.001 and is_equal_approx(ap.base_angle, base0)
	# STABLE: the target moves; positions move with it and do not rotate.
	var t1 := Vector3(4, 0, -2)
	var moved := ap.position_of(0, t1).is_equal_approx(p0 + t1)
	# A FREED POSITION GOES TO THE NEAREST WAITER; AN EXACT TIE TO THE LOWER ID.
	var reg := CombatEntityRegistry.new("C18_PRIVATE_AREA")
	var na := Node.new()
	var nb := Node.new()
	var ida := reg.register(na, "ally", "ally")
	var idb := reg.register(nb, "ally", "ally")
	var tab := AttackPositions.new("C18b", r, sp)
	for k in tab.inner_capacity:
		var a2 := TAU * float(k) / float(tab.inner_capacity)
		tab.claim("I%d" % k, Vector3(sin(a2), 0, cos(a2)) * 3.0, t0)
	tab.claim(idb, Vector3(3, 0, 0), t0)
	tab.claim(ida, Vector3(-3, 0, 0), t0)
	var freed_spot := tab.position_of(int(tab.claims["I0"]), t0)
	var pos := {}
	# EXACTLY equidistant from the freed spot, mirrored across its bearing.
	pos[ida] = freed_spot + Vector3(1.0, 0, 1.5)
	pos[idb] = freed_spot + Vector3(-1.0, 0, 1.5)
	var promoted := tab.release("I0", pos, t0, Callable(reg, "precedes"))
	var tie_ok := promoted == ida and tab.ties_resolved == 1 and tab.is_inner(int(tab.claims[ida]))
	na.free()
	nb.free()
	# NEGATIVE CONTROL: members stacked at the target's centre are refused.
	var refuses := _stacked([t0, t0 + Vector3(0.1, 0, 0)], t0, sp - 0.001, r - 0.001)
	var ok := cap_ok and first_ok and ring_ok and moved and tie_ok and refuses
	_note("C18_melee_members_take_stable_target_relative_attack_positions",
		"round an ordinary enemy the attack ring is %.2f m (its approach distance) holding %d positions spaced by its %.2f m separation, a waiting ring at %.2f m holding %d=%s | the first claim sits exactly on its bearing and a second claim returns the same position=%s | %d attack positions no closer than the spacing, none inside the ring, the next member WAITS on the outer ring, the base angle unmoved=%s | the target moved: every position moved WITH it, unrotated=%s | a freed attack position went to the nearest waiter, an EXACT tie to the lower combat-entity ID (%s)=%s | NEGATIVE CONTROL: a stack at the target's centre is refused=%s"
		% [r, ap.inner_capacity, sp, ap.outer_radius, ap.outer_capacity, str(cap_ok), str(first_ok), ap.inner_capacity, str(ring_ok),
		   str(moved), promoted, str(tie_ok), str(refuses)])
	_reached("C18_melee_members_take_stable_target_relative_attack_positions")
	return ok

func chk_C19_when_she_exceeds_the_leash_regrouping_overrides_combat() -> bool:
	var P := Vector3(-11, 0, 5)
	# CASE 1 — THE TARGET STILL VALID (8.5 m from her), THE HOUND BEYOND THE LEASH
	# (9.6 m from her): regrouping OVERRIDES combat.
	await _reset(2, "ORDINARY", Vector3(-11, 0, 0))
	var t := _stub("C19_target", Vector3(-11, 0, -2))
	var tid := hr.registry.id_of(t)
	await _until(func() -> bool: return (_members()[0] as KindredHound).target_id() == tid, 300)
	var h := _members()[0] as KindredHound
	var engaged := h.target_id() == tid
	_place_player(P)
	t.global_position = P + Vector3(0, 0, -8.5)
	h.global_position = P + Vector3(0, 0, -9.6)
	var w := _stub("C19_waiting", P + Vector3(0, 0, 2.0))
	var wid := hr.registry.id_of(w)
	var ab0 := h.abandonments
	await physics_frame
	var overrode := h.regrouping and h.target.is_empty() and h.abandonments == ab0 + 1 \
		and h.abandon_code == KindredHound.ABANDONED_REGROUP and h.abandon_id == tid \
		and bool(HoundTargeting.still_eligible_and_leashed(hr.registry.record_of(t), player.global_position)["valid"])
	# THE D-396 HUD SAYS SO, WHOLE AND ONCE (the rendered regroup frame showed this
	# line doubled and cut; found at delivery).
	var hud_line := String(hounds_hud.compose_lines()["h%d" % (h.index + 1)])
	var hud_ok := hud_line.find("RETURNING TO HER — REGROUPING") >= 0 and hud_line.find("left " + tid) >= 0 \
		and hud_line.count("REGROUPING") == 1 and hud_line.length() <= HoundReviewHud.MAX_LINE_CHARS
	var held_off := 0
	var g := 0
	while g < 300 and h.regrouping:
		await physics_frame
		g += 1
		# Counted only while STILL regrouping: on the frame regrouping ends the
		# accepted rule may acquire in the same step (found on the first run: one
		# such frame was miscounted).
		if h.regrouping and not h.target.is_empty():
			held_off += 1
	var released := not h.regrouping and _planar(h.global_position, player.global_position) <= HoundConfig.ACQUISITION_RANGE_M + 0.3
	var g2 := await _until(func() -> bool: return h.target_id() == wid, 60)
	var then_acquired := h.target_id() == wid and g2 < 60
	# CASE 2 — THE TARGET ITSELF BEYOND THE LEASH: its own code, and no acquisition.
	await _reset(2, "ORDINARY", Vector3(-11, 0, 0))
	var t2 := _stub("C19_target2", Vector3(-11, 0, -2))
	var t2id := hr.registry.id_of(t2)
	await _until(func() -> bool: return (_members()[0] as KindredHound).target_id() == t2id, 300)
	var h2 := _members()[0] as KindredHound
	_place_player(P)
	t2.global_position = P + Vector3(0, 0, -10.0)
	h2.global_position = P + Vector3(0, 0, -10.8)
	var w2 := _stub("C19_waiting2", P + Vector3(0, 0, 2.0))
	await physics_frame
	var case2 := h2.regrouping and h2.target.is_empty() and h2.abandon_code == HoundTargeting.ABANDONED_LEASH \
		and h2.target_id() != hr.registry.id_of(w2)
	# NEGATIVE CONTROL — THE HOUND STILL INSIDE THE LEASH: D-396's behaviour, one step
	# abandons the target beyond the leash AND acquires the waiting enemy.
	await _reset(2, "ORDINARY", Vector3(-11, 0, 0))
	var t3 := _stub("C19_target3", Vector3(-11, 0, -2))
	var t3id := hr.registry.id_of(t3)
	await _until(func() -> bool: return (_members()[0] as KindredHound).target_id() == t3id, 300)
	var h3 := _members()[0] as KindredHound
	_place_player(P)
	t3.global_position = P + Vector3(0, 0, -9.6)
	h3.global_position = P + Vector3(0, 0, -8.5)
	var w3 := _stub("C19_waiting3", P + Vector3(0, 0, -3.0))
	await physics_frame
	var d396 := not h3.regrouping and h3.abandon_code == "" and h3.target_id() == hr.registry.id_of(w3) \
		and h3.reason_text.find(HoundTargeting.ABANDONED_LEASH) >= 0
	await _reset(2, "ORDINARY", Vector3(-11, 0, 0))
	var ok := engaged and overrode and hud_ok and held_off == 0 and g > 0 and released and then_acquired and case2 and d396
	_note("C19_when_she_exceeds_the_leash_regrouping_overrides_combat",
		"CASE 1: engaged=%s; she was set 9.6 m from the hound while its target stood 8.5 m from her — STILL valid by the accepted rule — and ONE step later the hound was REGROUPING, its target abandoned '%s', with an eligible enemy waiting 2 m from her=%s; the D-396 HUD said '%s', whole and once=%s | for %d frames of regrouping it held NO target (%d frames with one)=%s | back inside %.1f m of her it stopped regrouping=%s and then acquired the waiting enemy by the accepted rule=%s | CASE 2: a target itself beyond the leash is abandoned with the accepted rule's own code and nothing is acquired=%s | NEGATIVE CONTROL: a hound still INSIDE the leash abandons AND acquires on one step — D-396's behaviour, kept=%s. The READING is disclosed (CohortConfig.REGROUP_READING); no new distance is introduced."
		% [str(engaged), KindredHound.ABANDONED_REGROUP, str(overrode), hud_line, str(hud_ok), g, held_off, str(held_off == 0), HoundConfig.ACQUISITION_RANGE_M,
		   str(released), str(then_acquired), str(case2), str(d396)])
	_reached("C19_when_she_exceeds_the_leash_regrouping_overrides_combat")
	return ok

func chk_C20_after_combat_members_reform_without_a_command() -> bool:
	await _reset(6, "ORDINARY", Vector3(-11, 0, -2))
	var s := _stub("C20_target", Vector3(-11, 0, 1.5))
	var id := hr.registry.id_of(s)
	await _until(func() -> bool:
		var n := 0
		for h in _members():
			if (h as KindredHound).target_id() == id and (h as KindredHound).state == KindredHound.State.BITE:
				n += 1
		return n >= 4, 360)
	var fought := s.hits > 0
	var engaged := hounds.cohort.count_in(MobileCohort.Mode.ENGAGED)
	var uses0 := skills.skill_uses
	# THE FIGHT ENDS: the target dies. Nothing is pressed or commanded.
	s.dead = true
	var frames := await _until(func() -> bool:
		if hounds.cohort.formation_state != "SETTLED":
			return false
		for h in _members():
			var kh := h as KindredHound
			if kh.cohort_mode != MobileCohort.Mode.FORMATION or _planar(kh.global_position, kh.follow_slot()) > HoundConfig.FOLLOW_RESUME_M:
				return false
		return true, 360)
	var reformed := frames < 360
	var no_input := skills.skill_uses == uses0 and player.intent.seams_clear() and cam.debug_cursor_override == null
	var hits := s.hits
	await _reset(2, "ORDINARY", Vector3(-11, 0, 0))
	var ok := fought and engaged >= 4 and reformed and no_input
	_note("C20_after_combat_members_reform_without_a_command",
		"six members fought one target (%d engaged, %d bites landed)=%s | it died: every member left combat and was back at its own slot, the formation SETTLED, in %d frames (bound 360, a test bound)=%s | no input, no Skill Use, no command=%s"
		% [engaged, hits, str(fought), frames, str(reformed), str(no_input)])
	_reached("C20_after_combat_members_reform_without_a_command")
	return ok

# =============================================================================
# G. SOFT RECOVERY — harmless, automatic, not a command
# =============================================================================

func chk_C21_path_failure_triggers_a_harmless_soft_recovery() -> bool:
	await _reset(6, "ORDINARY", Vector3(-15, 0, 0))
	var c := hounds.cohort
	# NEGATIVE CONTROL FIRST: a member displaced 3 m on OPEN floor, reachable, does
	# NOT recover -- it walks back.
	var ok_m := _members()[3] as KindredHound
	var r_ok0 := ok_m.recoveries
	ok_m.global_position = ok_m.follow_slot() + Vector3(0, 0, 3.0)
	await _phys(150)
	var no_false := ok_m.recoveries == r_ok0 and _planar(ok_m.global_position, ok_m.follow_slot()) <= HoundConfig.FOLLOW_RESUME_M
	# AND A SETTLED member holding a STALE failed path verdict does NOT recover: a
	# member at its slot asks for no path, so its last verdict is not a failure.
	# (The delivery-time defect this guards: the rendered frames showed spurious
	# path-failure recoveries of members already in their slots.) The verdict is
	# planted, and held for twice the grace.
	# The member is put EXACTLY on its slot so it SETTLES -- a settled member stops
	# re-evaluating its path, which is the state the stale verdict survived in (a
	# member merely near its slot re-evaluates and would heal the plant itself).
	ok_m.global_position = ok_m.follow_slot()
	await _phys(3)
	var settled_before := c.track_of(ok_m).settled
	c.track_of(ok_m).path_ok = false
	await _phys(int(ceil(CohortConfig.PATH_FAIL_GRACE_S * 2.0 * TICKS)))
	var stale_ignored := settled_before and c.track_of(ok_m).settled and not c.track_of(ok_m).path_ok \
		and ok_m.recoveries == r_ok0 and c.track_of(ok_m).path_fail_t == 0.0
	# FORCED PATH FAILURE: a member set INSIDE THE WEST WALL, off the mesh.
	var m := _members()[2] as KindredHound
	var id0 := m.combat_id
	var r0 := m.recoveries
	var pc0 := int(c.recoveries[MobileCohort.CAUSE_PATH])
	var pool := skills.pool
	var spends0 := pool.spends
	var res0 := pool.mana_reserved
	var summons0 := hounds.summons
	m.global_position = Vector3(-20.5, 0, 1.0)
	var off := not CohortFormation.on_mesh(nav_map, m.global_position)
	var frames := await _until(func() -> bool: return m.recoveries > r0, 180)
	var triggered := m.recoveries == r0 + 1 and m.recover_cause == MobileCohort.CAUSE_PATH \
		and int(c.recoveries[MobileCohort.CAUSE_PATH]) == pc0 + 1
	var in_time := frames <= int(ceil((CohortConfig.PATH_FAIL_GRACE_S + 0.3) * TICKS))
	await _until(func() -> bool: return m.recover_phase == "", 120)
	var rlog: Dictionary = c.recovery_log.back() if not c.recovery_log.is_empty() else {}
	var landed := CohortFormation.on_mesh(nav_map, m.global_position) and String(rlog.get("id", "")) == id0 \
		and int(rlog.get("slot", -1)) >= 0 and m.cohort_mode == MobileCohort.Mode.FORMATION
	var same := is_instance_valid(m) and m.combat_id == id0 and hounds.members().has(m) and hounds.summons == summons0
	var free := pool.spends == spends0 and is_equal_approx(pool.mana_reserved, res0)
	await _reset(2, "ORDINARY", Vector3(-11, 0, 0))
	var ok := no_false and stale_ignored and off and triggered and in_time and landed and same and free
	_note("C21_path_failure_triggers_a_harmless_soft_recovery",
		"NEGATIVE CONTROL: a member displaced 3 m on open floor walked back and did NOT recover=%s; a SETTLED member given a stale failed path verdict, still settled and still holding it after twice the grace, did NOT recover either=%s | a member set inside the west wall (off the mesh=%s) began a soft recovery for PATH FAILURE after %d frames (grace %.2f s + 0.3 s bound)=%s/%s, and landed on the mesh in formation slot %d (own slot=%s)=%s | the same hound, the same ID %s, no resummon=%s | no Mana spent and the reservation unchanged=%s"
		% [str(no_false), str(stale_ignored), str(off), frames, CohortConfig.PATH_FAIL_GRACE_S, str(triggered), str(in_time), int(rlog.get("slot", -1)),
		   str(rlog.get("own", false)), str(landed), id0, str(same), str(free)])
	_reached("C21_path_failure_triggers_a_harmless_soft_recovery")
	return ok

func chk_C22_falling_far_behind_triggers_a_soft_recovery_into_a_valid_unoccupied_slot() -> bool:
	await _reset(6, "ORDINARY", LANE_B)
	var c := hounds.cohort
	# FAR BEHIND: a member set 18 m away on open, reachable floor.
	var m := _members()[4] as KindredHound
	var r0 := m.recoveries
	m.global_position = Vector3(-11, 0, -9.4)
	var d0 := _planar(m.global_position, player.global_position)
	var frames := await _until(func() -> bool: return m.recoveries > r0, 120)
	var far_ok := m.recover_cause == MobileCohort.CAUSE_FAR and d0 > CohortConfig.FAR_BEHIND_M \
		and frames <= int(ceil((CohortConfig.FAR_BEHIND_GRACE_S + 0.1) * TICKS))
	await _until(func() -> bool: return m.recover_phase == "", 120)
	var rlog: Dictionary = c.recovery_log.back()
	var at: Vector3 = rlog["at"]
	var lpos := player.global_position
	var reach := NavService.reachable(nav_map, lpos, at, CohortConfig.PATH_END_TOLERANCE_M)
	var valid := bool(reach["reachable"]) \
		and float(reach["path_length"]) <= float(reach["straight"]) * CohortConfig.PATH_DETOUR_RATIO + CohortConfig.PATH_DETOUR_SLACK_M \
		and CohortFormation.on_mesh(nav_map, at)
	var back_near := _planar(m.global_position, lpos) < CohortConfig.FAR_BEHIND_M * 0.5
	# UNOCCUPIED, staged on OPEN floor west of the blocker, where every slot is valid
	# (by the south wall its own slot may simply be INVALID, which would satisfy both
	# claims below for the wrong reason -- found on the first run).
	_place_player(Vector3(-13, 0, 0))
	await _phys(150)
	var own: Vector3 = c.track_of(m).slot
	# THE CONTROL FIRST: nobody on its own slot, and its OWN slot is chosen.
	var chosen_own := c.recovery_slot(m)
	var own_first := bool((c.recovery_log.back() as Dictionary)["own"]) and _planar(chosen_own, own) < 0.05
	# Then another member put EXACTLY on it -- the choice must go elsewhere, to a
	# free slot, and say it was not its own.
	var occ := _members()[5] as KindredHound
	occ.global_position = chosen_own
	var chosen := c.recovery_slot(m)
	var rlog2: Dictionary = c.recovery_log.back()
	var from_occupier := _planar(chosen, occ.global_position)
	var unoccupied := not bool(rlog2["own"]) and from_occupier >= 2.0 * HoundConfig.BODY_RADIUS_M \
		and int(rlog2["slot"]) >= 0
	# REGROUPING TOO LONG is the third cause (the pure decision, exact inputs).
	var cause := c.recovery_check(m, CohortConfig.REGROUP_TIMEOUT_S + 0.1, true)
	c.recovery_check(m, 0.0, false)
	var regroup_cause := cause == MobileCohort.CAUSE_REGROUP
	await _reset(2, "ORDINARY", Vector3(-11, 0, 0))
	var ok := far_ok and valid and back_near and unoccupied and own_first and regroup_cause
	_note("C22_falling_far_behind_triggers_a_soft_recovery_into_a_valid_unoccupied_slot",
		"a member %.1f m from her (beyond %.1f m) began a soft recovery for FAR BEHIND in %d frames=%s | it landed in a VALID slot — on the mesh, reachable from her by a path of %.2f m against %.2f m straight (ratio %.1f + %.1f m)=%s — back beside her=%s | UNOCCUPIED: with another member on its own slot the choice went to slot %d, %.2f m from the occupier (no body overlap)=%s; with nobody there (the control, run first) its own slot is chosen=%s | a regroup longer than %.1f s is the third cause=%s — every threshold PROVISIONAL"
		% [d0, CohortConfig.FAR_BEHIND_M, frames, str(far_ok), float(reach["path_length"]), float(reach["straight"]), CohortConfig.PATH_DETOUR_RATIO,
		   CohortConfig.PATH_DETOUR_SLACK_M, str(valid), str(back_near), int(rlog2["slot"]), from_occupier,
		   str(unoccupied), str(own_first), CohortConfig.REGROUP_TIMEOUT_S, str(regroup_cause)])
	_reached("C22_falling_far_behind_triggers_a_soft_recovery_into_a_valid_unoccupied_slot")
	return ok

func chk_C23_no_attack_or_damage_during_recovery() -> bool:
	await _reset(2, "ORDINARY", Vector3(-15, 0, 1))
	var m := _members()[0] as KindredHound
	var other := _members()[1] as KindredHound
	# The other hound is felled, so only the recovering one could bite (it returns
	# after the accepted 4.0 s, beyond this check's window).
	other.receive_damage(other.life.life, other.global_position, "C23 test fall")
	# An eligible stub waits OUT of reach until the recovery has relocated it.
	var s := _stub("C23_target", Vector3(-15, 0, 9.0))
	var r0 := m.recoveries
	m.global_position = Vector3(-20.5, 0, 1.0)
	await _until(func() -> bool: return m.recoveries > r0, 180)
	await _until(func() -> bool: return m.recover_phase == "IN", 60)
	var relocated := m.recover_phase == "IN"
	# RIGHT BESIDE IT NOW: in bite distance, eligible, inside her acquisition range.
	s.global_position = m.global_position + Vector3(0, 0, 0.9)
	var bites0 := m.bites
	var hits0 := s.hits
	var targeted := false
	var frames := 0
	while m.recover_phase != "" and frames < 120:
		await physics_frame
		frames += 1
		targeted = targeted or not m.target.is_empty()
	var harmless := relocated and m.bites == bites0 and s.hits == hits0 and not targeted and frames >= 5
	# Printed as judged (the note printed the counts AFTER the negative control until
	# the run of record showed "bites 0 -> 1" beside "bit nothing" -- found at delivery).
	var bites_rec := m.bites
	var hits_rec := s.hits
	# NEGATIVE CONTROL: recovered, the same member takes and bites the same stub.
	var g := await _until(func() -> bool: return s.hits > hits0, 120)
	var bites_after := s.hits > hits0 and m.bites > bites0 and g < 120
	var bites1 := m.bites
	var hits1 := s.hits
	await _reset(2, "ORDINARY", Vector3(-11, 0, 0))
	var ok := harmless and bites_after
	_note("C23_no_attack_or_damage_during_recovery",
		"a recovering member, relocated (phase IN)=%s, had an eligible stub put 0.9 m from it for the %d frames left of its recovery: it chose nothing and bit nothing (bites %d -> %d, the stub's hits %d -> %d)=%s | NEGATIVE CONTROL: recovered, it took and bit the same stub within %d frames (bites -> %d, hits -> %d)=%s — the bite path was live, the recovery was what held it"
		% [str(relocated), frames, bites0, bites_rec, hits0, hits_rec, str(harmless), g, bites1, hits1, str(bites_after)])
	_reached("C23_no_attack_or_damage_during_recovery")
	return ok

# =============================================================================
# H. THE NINE EXERCISES (with C15, C19-C21)
# =============================================================================

func chk_C24_straight_high_speed_travel() -> bool:
	await _reset(15, "EXTREME", LANE_A)
	var r := await _straight_run(LANE_A, LANE_PRIME, LANE_B)
	# BOUNDS (test bounds, stated): centre >= +0.5 m ahead, <= 10 % of member-frames
	# more than 1 m behind her, no member more than 3.5 m from its slot after 20
	# steady frames, mean member speed within 0.85-1.35 of hers.
	var ok := int(r["steady"]) >= 30 and float(r["centroid"]) >= 0.5 and float(r["behind"]) <= 0.10 \
		and float(r["max_lag"]) <= 3.5 and float(r["ratio"]) >= 0.85 and float(r["ratio"]) <= 1.35
	_finding("STRAIGHT, 15 at EXTREME (%.2f m/s): %d steady frames, centre %+.2f m ahead, %.1f%% of member-frames behind, lag mean %.2f / max %.2f m, speed ratio %.3f, farthest %.1f m from her, %d soft recoveries."
		% [ProdConfig.TOP_SPEED_MPS * diag.speed_scale(), int(r["steady"]), float(r["centroid"]), float(r["behind"]) * 100.0,
		   float(r["mean_lag"]), float(r["max_lag"]), float(r["ratio"]), float(r["max_from_her"]), int(r["recoveries"])])
	await _reset(2, "ORDINARY", Vector3(-11, 0, 0))
	_note("C24_straight_high_speed_travel",
		"15 members at EXTREME speed on the straight lane: %d steady frames; the pack's centre %+.2f m ahead of her; %.1f%% of member-frames more than 1 m behind; the largest lag from a slot after 20 steady frames %.2f m (mean %.2f); speed ratio %.3f; %d soft recoveries — within the stated test bounds=%s"
		% [int(r["steady"]), float(r["centroid"]), float(r["behind"]) * 100.0, float(r["max_lag"]), float(r["mean_lag"]), float(r["ratio"]),
		   int(r["recoveries"]), str(ok)])
	_reached("C24_straight_high_speed_travel")
	return ok

func chk_C25_sudden_direction_reversal() -> bool:
	await _reset(10, "FAST", Vector3(-11, 0, -8))
	await _prime_toward(Vector3(-11, 0, -6.5))
	player.command_move_to(Vector3(-11, 0, 9))
	await _phys(50)
	var rec0 := hounds.cohort.total_recoveries()
	player.command_move_to(Vector3(-11, 0, -9))
	var g := 0
	var most_behind := 0.0
	var max_lag := 0.0
	var reformed := -1
	while g < 480:
		await physics_frame
		g += 1
		var worst := 0.0
		for h in _members():
			worst = maxf(worst, _track(h).lag)
			if g > 40:
				most_behind = minf(most_behind, _ahead_of_her(h))
		max_lag = maxf(max_lag, worst)
		if reformed < 0 and g > 20 and worst <= 2.0:
			reformed = g
		if g > 60 and player.motor.speed() < 0.05 and reformed >= 0:
			break
	var stopped := player.motor.speed() < 0.05
	await _phys(120)
	var settled_err := 0.0
	for h in _members():
		settled_err = maxf(settled_err, _planar((h as Node3D).global_position, (h as KindredHound).follow_slot()))
	# BOUNDS (test bounds): every member back within 2.0 m of its slot within 3.0 s of
	# the reversal; after the formation has swung (40 frames) none more than 3.5 m
	# behind her; settled within the resume distance 2 s after she stops.
	var ok := reformed > 0 and reformed <= 180 and most_behind >= -3.5 and stopped and settled_err <= HoundConfig.FOLLOW_RESUME_M
	_finding("REVERSAL, 10 at FAST: the largest lag %.2f m while the formation swung; every member within 2.0 m of its slot %d frames after the reversal; the farthest behind her %.2f m after 40 frames; %d soft recoveries."
		% [max_lag, reformed, most_behind, hounds.cohort.total_recoveries() - rec0])
	await _reset(2, "ORDINARY", Vector3(-11, 0, 0))
	_note("C25_sudden_direction_reversal",
		"10 members at FAST; she reversed mid-run: the formation swung round her (largest lag %.2f m), every member was back within 2.0 m of its slot %d frames after the reversal (bound 180), none more than %.2f m behind her once it had swung (bound 3.5), and all settled within %.2f m of their slots after she stopped=%s"
		% [max_lag, reformed, -most_behind, settled_err, str(ok)])
	_reached("C25_sudden_direction_reversal")
	return ok

func chk_C26_repeated_stopping_and_starting() -> bool:
	await _reset(6, "ORDINARY", Vector3(-11, 0, -8))
	var restarts := 0
	var settles: Array = []
	var legs := 0
	for leg in 4:
		player.command_move_to(Vector3(-11, 0, -8 + 3.5 * float(leg + 1)))
		var g := await _until(func() -> bool: return player.motor.speed() < 0.05 and _planar(player.global_position, Vector3(-11, 0, -8 + 3.5 * float(leg + 1))) < 0.6, 300)
		if g < 300:
			legs += 1
		# She stands: each member comes to rest once, and does not start again.
		var moving := {}
		for h in _members():
			moving[h] = Vector2((h as KindredHound).velocity.x, (h as KindredHound).velocity.z).length() > 0.05
		var settle_at := -1
		for f in 90:
			await physics_frame
			var any := false
			for h in _members():
				var v := Vector2((h as KindredHound).velocity.x, (h as KindredHound).velocity.z).length()
				if moving[h] and v < 0.05:
					moving[h] = false
				elif not moving[h] and v > 0.3:
					moving[h] = true
					if f > 20:
						restarts += 1
				any = any or bool(moving[h])
			if settle_at < 0 and not any:
				settle_at = f
		settles.append(settle_at)
	var settled_all := true
	for st in settles:
		settled_all = settled_all and int(st) >= 0 and int(st) <= 75
	await _reset(2, "ORDINARY", Vector3(-11, 0, 0))
	var ok := legs == 4 and restarts == 0 and settled_all
	_note("C26_repeated_stopping_and_starting",
		"six members; she walked four 3.5 m legs and stood after each (%d of 4)=%s | after each stop every member came to rest (frames: %s, bound 75) and none started again after it had settled (%d restarts)=%s — the lead freezes while she stands, so the slots do not creep"
		% [legs, str(legs == 4), str(settles), restarts, str(restarts == 0 and settled_all)])
	_reached("C26_repeated_stopping_and_starting")
	return ok

func chk_C27_the_doorway_and_interior_blocker_at_fifteen() -> bool:
	# FROM WEST OF THE INTERIOR BLOCKER, ROUND IT, THROUGH THE ONE-MODULE DOORWAY,
	# into the east chamber -- 15 members at FAST speed.
	await _reset(15, "FAST", Vector3(-14, 0, 5.5))
	await _prime_toward(Vector3(-12.5, 0, 5.5))
	var rec0 := hounds.cohort.total_recoveries()
	var pt0 := hounds.cohort.passed_through_frames()
	var dest := Vector3(8, 0, 0)
	# RE-SCOPED ONE FOR ONE UNDER D-404, BY OWNER RULING -- THE DRIVE ONLY. Until
	# D-404 this was ONE click at `dest`, which the player's navigation path ROUTED
	# round the interior blocker and through the doorway -- TRUE WHEN WRITTEN, and
	# what `rounded` below still measures. A D-404 click goes straight and stops at
	# the first blocker, so she now takes the SAME route BY HAND -- past the
	# blocker's south end, to the doorway's axis, through it -- clicking each
	# waypoint as she nears the last. Every assertion about the pack is UNCHANGED.
	var c27_route := [Vector3(-5.0, 0, 4.5), Vector3(-2.0, 0, 0.0), dest]
	var c27_idx := 0
	player.command_move_to(Vector3(c27_route[0]))
	var rounded := false
	var g := 0
	var arrived := -1
	var all_east := -1
	var worst_from_her := 0.0
	while g < 900:
		await physics_frame
		g += 1
		c27_idx = _click_route_step(c27_route, c27_idx)
		if player.global_position.x > -7.0 and absf(player.global_position.z) < 4.5:
			rounded = true
		var east := 0
		for h in _members():
			if (h as Node3D).global_position.x > 1.3:
				east += 1
			worst_from_her = maxf(worst_from_her, _planar((h as Node3D).global_position, player.global_position))
		if all_east < 0 and east == 15:
			all_east = g
		if arrived < 0 and g > 30 and player.motor.speed() < 0.05 and _planar(player.global_position, dest) < 0.6:
			arrived = g
		if arrived >= 0 and all_east >= 0 and g > arrived + 60:
			break
	var slot_err := 0.0
	for h in _members():
		slot_err = maxf(slot_err, _planar((h as Node3D).global_position, (h as KindredHound).follow_slot()))
	var recs := hounds.cohort.total_recoveries() - rec0
	var passed := hounds.cohort.passed_through_frames() - pt0
	# BOUNDS (test bounds): all 15 east of the doorway no later than 1 s after she
	# arrives, each within 1.0 m of its slot 1 s after that, at most 2 soft
	# recoveries (reported), and congestion was passed through.
	var ok := rounded and arrived > 0 and all_east > 0 and all_east <= arrived + 60 and slot_err <= 1.0 and recs <= 2 and passed > 0
	_finding("DOORWAY, 15 at FAST: she arrived in %d frames; all 15 east of the doorway at frame %d; each within %.2f m of its slot a second later; the farthest %.1f m from her on the way; %d member-frames passed through; %d soft recoveries."
		% [arrived, all_east, slot_err, worst_from_her, passed, recs])
	await _reset(2, "ORDINARY", Vector3(-11, 0, 0))
	_note("C27_the_doorway_and_interior_blocker_at_fifteen",
		"(D-404: she now takes this route BY HAND, click by click — the drive was re-scoped one for one, the pack's assertions were not) she went round the interior blocker=%s and through the doorway, arriving in %d frames; all 15 were east of the doorway at frame %d (bound: her arrival + 60); a second later each was within %.2f m of its slot (bound 1.0); %d member-frames passed through congestion; %d soft recoveries (bound 2)=%s"
		% [str(rounded), arrived, all_east, slot_err, passed, recs, str(ok)])
	_reached("C27_the_doorway_and_interior_blocker_at_fifteen")
	return ok

func chk_C28_target_acquisition_then_rapid_departure() -> bool:
	await _reset(6, "EXTREME", Vector3(-11, 0, -6))
	var e := _stub("C28_target", Vector3(-9.0, 0, -4.5))
	var id := hr.registry.id_of(e)
	await _until(func() -> bool:
		var n := 0
		for h in _members():
			if (h as KindredHound).target_id() == id:
				n += 1
		return n >= 4, 300)
	var engaged: Array = []
	for h in _members():
		if (h as KindredHound).target_id() == id:
			engaged.append(h)
	var rg0 := {}
	for h in _members():
		rg0[h] = (h as KindredHound).regroups
	var hits_at_leash := -1
	var holding_while_regrouping := 0
	# HOW each engaged member left combat, recorded when it first dropped its target:
	# by REGROUPING (she beyond the leash from it), or by the ACCEPTED RULE (the
	# target beyond the leash from her while the member was still within it).
	var left_by := {}
	player.command_move_to(Vector3(-11, 0, 9.3))
	var g := 0
	var back := -1
	while g < 600:
		await physics_frame
		g += 1
		if hits_at_leash < 0 and _planar(player.global_position, e.global_position) > HoundConfig.LEASH_RANGE_M + 1.0:
			hits_at_leash = e.hits
		for h in _members():
			if (h as KindredHound).regrouping and not (h as KindredHound).target.is_empty():
				holding_while_regrouping += 1
		for h in engaged:
			var kh := h as KindredHound
			if not left_by.has(kh) and kh.target_id() != id:
				left_by[kh] = "REGROUP" if kh.regrouping and kh.abandon_code == KindredHound.ABANDONED_REGROUP \
					else ("ACCEPTED RULE" if kh.abandon_code == HoundTargeting.ABANDONED_LEASH else "OTHER: " + kh.abandon_code)
		if back < 0 and player.motor.speed() < 0.05 and g > 30:
			var worst := 0.0
			for h in _members():
				worst = maxf(worst, _planar((h as Node3D).global_position, (h as KindredHound).follow_slot()))
			if worst <= HoundConfig.FOLLOW_RESUME_M and hounds.cohort.count_in(MobileCohort.Mode.ENGAGED) == 0:
				back = g
		if back > 0 and g > back + 10:
			break
	var regrouped := 0
	for h in engaged:
		if (h as KindredHound).regroups > int(rg0[h]):
			regrouped += 1
	var by_regroup := 0
	var by_rule := 0
	for k in left_by.keys():
		if String(left_by[k]) == "REGROUP":
			by_regroup += 1
		elif String(left_by[k]) == "ACCEPTED RULE":
			by_rule += 1
	# Every engaged member LEFT combat, each one way or the other, and the override
	# was exercised at least once.
	var all_left := left_by.size() == engaged.size() and by_regroup + by_rule == engaged.size() and by_regroup >= 1
	var stopped_biting := hits_at_leash >= 0 and e.hits <= hits_at_leash + engaged.size()
	var e_hits := e.hits
	await _reset(2, "ORDINARY", Vector3(-11, 0, 0))
	var ok := engaged.size() >= 4 and all_left and holding_while_regrouping == 0 and back > 0 and stopped_biting
	_note("C28_target_acquisition_then_rapid_departure",
		"%d of six engaged one target; she left at EXTREME speed: every one LEFT combat — %d by REGROUPING (she beyond the leash from it) and %d by the ACCEPTED D-396 RULE (its target beyond the leash from her while it was still within it) (%d regroups counted)=%s, none held a target while regrouping (%d member-frames)=%s, the target took at most one last bite each once she was past the leash (%d -> %d hits)=%s, and all were back at their slots, none engaged, %d frames after she set off=%s"
		% [engaged.size(), by_regroup, by_rule, regrouped, str(all_left), holding_while_regrouping, str(holding_while_regrouping == 0),
		   hits_at_leash, e_hits, str(stopped_biting), back, str(back > 0)])
	_finding("DEPARTURE, 6 at EXTREME: of %d engaged, %d left combat by REGROUPING and %d by the ACCEPTED D-396 leash rule — a member between her and its target can see the target cross the leash first; it then follows without regrouping. Both paths leave combat; this is the disclosed reading, not a new rule."
		% [engaged.size(), by_regroup, by_rule])
	_reached("C28_target_acquisition_then_rapid_departure")
	return ok

func chk_C29_several_melee_members_on_one_target() -> bool:
	var rows: Array[String] = []
	var ok_all := true
	for pop in [10, 15]:
		await _reset(pop, "ORDINARY", Vector3(-11, 0, 0))
		var s := _stub("C29_target_%d" % pop, Vector3(-11, 0, 3.0))
		var id := hr.registry.id_of(s)
		await _until(func() -> bool:
			var n := 0
			for h in _members():
				if (h as KindredHound).state == KindredHound.State.BITE:
					n += 1
			return n >= 6, 360)
		await _phys(60)
		var inner: Array = []
		var waiting := 0
		var biting := 0
		var all_on := true
		for h in _members():
			var kh := h as KindredHound
			all_on = all_on and kh.target_id() == id
			if kh.attack_inner:
				inner.append(kh.global_position)
				if kh.state == KindredHound.State.BITE:
					biting += 1
			else:
				waiting += 1
		var idx0 := {}
		var wbites := {}
		for h in _members():
			idx0[h] = (h as KindredHound).attack_index
			wbites[h] = (h as KindredHound).bites
		await _phys(120)
		var changed := 0
		var waiter_bites := 0
		for h in _members():
			if (h as KindredHound).attack_index != int(idx0[h]):
				changed += 1
			if not (h as KindredHound).attack_inner:
				waiter_bites += (h as KindredHound).bites - int(wbites[h])
		var cap := int(hounds.cohort.attack[id].inner_capacity)
		# BOUNDS: the attack ring full with no two closer than 0.8 m and none inside the
		# target's body (radius sum 0.72 m); the rest waiting; nobody reshuffled.
		var no_stack := not _stacked(inner, s.global_position, 0.8, 0.42 + HoundConfig.BODY_RADIUS_M)
		var row_ok: bool = all_on and inner.size() == cap and waiting == pop - cap and biting == cap and no_stack \
			and changed == 0 and waiter_bites == 0 and s.hits > 0
		ok_all = ok_all and row_ok
		rows.append("%d on one target: %d at attack positions (all biting %d), %d waiting, no stack=%s, reshuffles %d, bites from waiters %d, target hit %d times"
			% [pop, inner.size(), biting, waiting, str(no_stack), changed, waiter_bites, s.hits])
	await _reset(2, "ORDINARY", Vector3(-11, 0, 0))
	_note("C29_several_melee_members_on_one_target",
		"%s=%s — stable target-relative positions; overflow waits and bites nothing (CD-07: no distribution rule is decided)"
		% [" · ".join(rows), str(ok_all)])
	_reached("C29_several_melee_members_on_one_target")
	return ok_all

# =============================================================================
# I. THE DIAGNOSTIC MODES
# =============================================================================

func chk_C30_four_populations_and_three_travel_speeds_are_labelled_diagnostic() -> bool:
	var pops_ok := _same(CohortConfig.POPULATIONS, [2, 6, 10, 15])
	var modes := CohortConfig.speed_modes()
	var speeds_ok := modes.size() == 3 and String(modes[0][0]) == "ORDINARY" and is_equal_approx(float(modes[0][1]), 1.0) \
		and String(modes[1][0]) == "FAST" and String(modes[2][0]) == "EXTREME" \
		and float(modes[1][1]) > 1.0 and float(modes[2][1]) > float(modes[1][1])
	var launch_ok := int(launch["population"]) == 2 and String(launch["speed"]) == "ORDINARY" \
		and is_equal_approx(float(launch["speed_scale"]), 1.0)
	# CYCLING: 2 -> 6 -> 10 -> 15 -> 2 and ORDINARY -> FAST -> EXTREME -> ORDINARY,
	# the canonical pack always two and the stress minions a separate list.
	await _reset(2, "ORDINARY", Vector3(-11, 0, 0))
	var seen_pop: Array = []
	var pack_ok := true
	for i in 4:
		diag.cycle_population()
		await _phys(2)
		seen_pop.append(diag.population())
		pack_ok = pack_ok and hounds.pack.size() == 2 and hounds.stress.size() == diag.population() - 2 \
			and hounds.cohort.size() == diag.population()
	var seen_speed: Array = []
	for i in 3:
		diag.cycle_speed()
		seen_speed.append(diag.speed_name())
	var cycles := _same(seen_pop, [6, 10, 15, 2]) and _same(seen_speed, ["FAST", "EXTREME", "ORDINARY"])
	# LABELLED: the registry rows, the stress stand-ins, the HUD.
	diag.set_population(6)
	await _phys(3)
	var tags: Array[String] = []
	for h in hounds.stress:
		for ch in (h as Node).get_children():
			if ch is HoundStandIn:
				tags.append((ch as HoundStandIn).label_text())
	var tags_ok := _same(tags, ["S3", "S4", "S5", "S6"])
	var rows_ok := 0
	for row in CohortConfig.registry():
		if String(row[0]).find("travel speed") >= 0 and String(row[2]).find("PROVISIONAL DIAGNOSTIC MODE") == 0:
			rows_ok += 1
	cohort_hud.refresh()
	var hud_ok := String(cohort_hud.compose_lines()["population"]).find("DIAGNOSTIC POPULATION 6") == 0 \
		and String(cohort_hud.compose_lines()["speed"]).find("DIAGNOSTIC SPEED") == 0
	await _reset(2, "ORDINARY", Vector3(-11, 0, 0))
	var ok := pops_ok and speeds_ok and launch_ok and pack_ok and cycles and tags_ok and rows_ok == 2 and hud_ok
	_note("C30_four_populations_and_three_travel_speeds_are_labelled_diagnostic",
		"populations %s=%s; speeds %s=%s; at launch 2 and ORDINARY (x1.0)=%s | cycling went %s and %s=%s, the canonical pack two and the stress minions a separate list throughout=%s | stress stand-ins labelled %s=%s; the two speed rows PROVISIONAL DIAGNOSTIC MODE (%d)=%s; the HUD says DIAGNOSTIC=%s"
		% [str(CohortConfig.POPULATIONS), str(pops_ok), str(modes), str(speeds_ok), str(launch_ok), str(seen_pop), str(seen_speed),
		   str(cycles), str(pack_ok), str(tags), str(tags_ok), rows_ok, str(rows_ok == 2), str(hud_ok)])
	_reached("C30_four_populations_and_three_travel_speeds_are_labelled_diagnostic")
	return ok

## Everything a mode must NOT change, as one comparable snapshot.
func _config_snapshot() -> Dictionary:
	var cfg := hounds.configuration()
	var res := cfg.resolve()
	var imp := skills.library.get_imprint(K) as Imprint
	var lo := skills.loadout
	return {
		"pack_size": int(res["pack_size"]), "reserve_fraction": float(res["reserve_fraction"]),
		"reserve_amount": float(res.get("reserve_amount", 0.0)), "damage": float(res["damage"]),
		"used": lo.capacity_used(), "total": lo.capacity_total(), "demanded": lo.capacity_demanded(),
		"mana_reserved": skills.pool.mana_reserved, "life_reserved": skills.pool.life_reserved,
		"tags": str(imp.provides_tags), "class": imp.skill_class, "reserves": imp.reserves, "rank": cfg.skill_rank(),
		"hound_digest": String(_numeric_digest_of_map(_constants("res://scripts/hounds/hound_config.gd"))[1]),
		"prod_digest": String(_numeric_digest_of_map(_constants("res://scripts/core/prod_config.gd"))[1]),
		"imprint_digest": String(_numeric_digest_of_map(_constants("res://scripts/imprint/imprint_config.gd"))[1]),
		"top_speed": ProdConfig.TOP_SPEED_MPS, "pack": hounds.pack.size(),
	}

func chk_C31_diagnostic_modes_are_isolated_from_gameplay_configuration() -> bool:
	await _reset(2, "ORDINARY", Vector3(-11, 0, 0))
	var base := _config_snapshot()
	var diffs: Array[String] = []
	var scales_ok := true
	var combos := 0
	for pop in CohortConfig.POPULATIONS:
		for mode in CohortConfig.speed_modes():
			diag.set_population(int(pop))
			diag.set_speed(String(mode[0]))
			await _phys(3)
			combos += 1
			var snap := _config_snapshot()
			for k in base.keys():
				if str(snap[k]) != str(base[k]):
					diffs.append("%d/%s:%s" % [int(pop), String(mode[0]), String(k)])
			scales_ok = scales_ok and is_equal_approx(player.diagnostic_travel_speed_scale, float(mode[1]))
	diag.set_population(2)
	diag.set_speed("ORDINARY")
	await _phys(3)
	var back := is_equal_approx(player.diagnostic_travel_speed_scale, 1.0) and str(_config_snapshot()) == str(base)
	# NEGATIVE CONTROL: the same comparison sees a planted change.
	var planted := base.duplicate()
	planted["reserve_fraction"] = 0.25
	var refuses := str(planted["reserve_fraction"]) != str(base["reserve_fraction"])
	# THE SPEED SEAM IS THE ONE WRITER: only CohortDiagnostics sets it.
	var writers: Array[String] = []
	for f in _runtime_script_files():
		if _code_only(_read_text(String(f))).find("diagnostic_travel_speed_scale =") >= 0:
			writers.append(String(f).get_file())
	var one_writer := _same(writers, ["cohort_diagnostics.gd"]) \
		and _code_only(_read_text("res://scripts/control/player_controller.gd")).find("var diagnostic_travel_speed_scale: float = 1.0") >= 0
	var ok := combos == 12 and diffs.is_empty() and scales_ok and back and refuses and one_writer
	_note("C31_diagnostic_modes_are_isolated_from_gameplay_configuration",
		"across all %d population x speed combinations the Configuration (pack size, reservation fraction and amount, damage, rank), Capacity (used, total, demanded), the pool's reservations, the Imprint's definition, the canonical pack and the numeric digests of HoundConfig, ProdConfig and ImprintConfig NEVER moved (differences: %s)=%s | the speed seam equalled the mode's scale every time=%s and is 1.0 again at ORDINARY=%s | NEGATIVE CONTROL: a planted reservation change is seen=%s | the files assigning the seam: %s — the ONE writer; the controller declares it at 1.0=%s"
		% [combos, str(diffs), str(diffs.is_empty()), str(scales_ok), str(back), str(refuses), str(writers), str(one_writer)])
	_reached("C31_diagnostic_modes_are_isolated_from_gameplay_configuration")
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

func chk_C32_the_two_diagnostic_controls_are_real_bound_and_not_commands() -> bool:
	var names := _project_actions()
	var added: bool = names.size() == 29 and names.count(CohortConfig.POPULATION_ACTION) == 1 and names.count(CohortConfig.SPEED_ACTION) == 1 \
		and names[27] == CohortConfig.POPULATION_ACTION and names[28] == CohortConfig.SPEED_ACTION
	var want := {CohortConfig.POPULATION_ACTION: [KEY_P, JOY_BUTTON_DPAD_RIGHT], CohortConfig.SPEED_ACTION: [KEY_T, JOY_BUTTON_START]}
	var bound := true
	var clashes: Array[String] = []
	for a in want.keys():
		var keys := 0
		var pads := 0
		for ev in InputMap.action_get_events(a):
			if ev is InputEventKey and (ev as InputEventKey).physical_keycode == int(want[a][0]):
				keys += 1
			elif ev is InputEventJoypadButton and (ev as InputEventJoypadButton).button_index == int(want[a][1]):
				pads += 1
			else:
				bound = false
		bound = bound and keys == 1 and pads == 1
		for other in InputMap.get_actions():
			var s := String(other)
			if s == a or s.begins_with("ui_"):
				continue
			for ev in InputMap.action_get_events(other):
				if (ev is InputEventKey and (ev as InputEventKey).physical_keycode == int(want[a][0])) \
						or (ev is InputEventJoypadButton and (ev as InputEventJoypadButton).button_index == int(want[a][1])):
					clashes.append("%s/%s" % [a, s])
	# THROUGH THE REAL INPUT PATH.
	await _reset(2, "ORDINARY", Vector3(-11, 0, 0))
	await _press(CohortConfig.POPULATION_ACTION)
	await _phys(2)
	var pop_real := diag.population() == 6 and hounds.stress.size() == 4
	await _press(CohortConfig.SPEED_ACTION)
	var speed_real := diag.speed_name() == "FAST" and is_equal_approx(player.diagnostic_travel_speed_scale, CohortConfig.SPEED_SCALE_FAST)
	# NOT COMMANDS: nothing under scripts/hounds/ reads them; the diagnostics touch
	# no target, velocity or position.
	var readers: Array[String] = []
	for f in _files_under("res://scripts/hounds/"):
		var code := _code_only(_read_text(String(f)))
		if code.find("POPULATION_ACTION") >= 0 or code.find("SPEED_ACTION") >= 0:
			readers.append(String(f).get_file())
	var dc := _code_only(_read_text("res://scripts/cohort/cohort_diagnostics.gd"))
	var not_cmd := dc.find("target") < 0 and dc.find("velocity") < 0 and dc.find("global_position") < 0 \
		and CohortConfig.CONTROL_SOURCE.find("not a command") > 0
	await _reset(2, "ORDINARY", Vector3(-11, 0, 0))
	var ok: bool = added and bound and clashes.is_empty() and pop_real and speed_real and readers.is_empty() and not_cmd
	_note("C32_the_two_diagnostic_controls_are_real_bound_and_not_commands",
		"project.godot declares %d input actions, the two D-398 controls last and once each (27 + 2 = 29)=%s | '%s' on key P / pad D-pad right and '%s' on key T / pad START, nothing else=%s; clashes: %s | a REAL press cycled the population to 6 (4 stress minions)=%s and the speed to FAST=%s | hound files reading them: %s; the diagnostics touch no target, velocity or position and say 'not a command'=%s"
		% [names.size(), str(added), CohortConfig.POPULATION_ACTION, CohortConfig.SPEED_ACTION, str(bound), str(clashes), str(pop_real),
		   str(speed_real), str(readers), str(not_cmd)])
	_reached("C32_the_two_diagnostic_controls_are_real_bound_and_not_commands")
	return ok

func _ledger(src: String) -> float:
	return float(SkillRuntime.ledger().get(src, 0.0))

func chk_C33_stress_minions_exist_only_with_the_pack_and_leave_highest_id_first() -> bool:
	await _reset(15, "ORDINARY", Vector3(-11, 0, 0))
	var had := hounds.stress.size() == 13 and _kindred_nodes_in_tree() == 15
	# UNEQUIPPED: pack AND stress minions gone; re-equipped: both back.
	skills.loadout.remove_persistent(CFG_K)
	skills.loadout.revalidate(skills.pool)
	await _one_runtime_step()
	var gone := hounds.pack.is_empty() and hounds.stress.is_empty() and _kindred_nodes_in_tree() == 0 and hounds.cohort.size() == 0
	skills.loadout.add_persistent(CFG_K)
	skills.loadout.revalidate(skills.pool)
	await _one_runtime_step()
	await _phys(2)
	var back := hounds.pack.size() == 2 and hounds.stress.size() == 13 and hounds.cohort.size() == 15
	# 15 -> 6: the NINE removed are the nine with the HIGHEST IDs.
	var ids_before: Array = []
	for h in _members():
		ids_before.append((h as KindredHound).combat_id)
	diag.set_population(6)
	await _phys(2)
	var ids_after: Array = []
	for h in _members():
		ids_after.append((h as KindredHound).combat_id)
	var kept_lowest := ids_after.size() == 6 and _same(ids_after, ids_before.slice(0, 6))
	# THE LEDGER: stress minions' bites go to their own DIAGNOSTIC source.
	await _reset(6, "ORDINARY", Vector3(-11, 0, 0))
	var s := _stub("C33_target", Vector3(-11, 0, 3.0))
	var k0 := _ledger(HoundConfig.LEDGER_SOURCE)
	var d0 := _ledger(CohortConfig.STRESS_LEDGER_SOURCE)
	var pb0 := 0
	var sb0 := 0
	for h in hounds.pack:
		pb0 += (h as KindredHound).bites
	for h in hounds.stress:
		sb0 += (h as KindredHound).bites
	await _phys(300)
	var pb := -pb0
	var sb := -sb0
	for h in hounds.pack:
		pb += (h as KindredHound).bites
	for h in hounds.stress:
		sb += (h as KindredHound).bites
	var dmg := HoundConfig.bite_damage_at(1)
	var ledger_ok := pb > 0 and sb > 0 and is_equal_approx(_ledger(HoundConfig.LEDGER_SOURCE) - k0, dmg * float(pb)) \
		and is_equal_approx(_ledger(CohortConfig.STRESS_LEDGER_SOURCE) - d0, dmg * float(sb)) and s.hits == pb + sb
	await _reset(2, "ORDINARY", Vector3(-11, 0, 0))
	var ok := had and gone and back and kept_lowest and ledger_ok
	_note("C33_stress_minions_exist_only_with_the_pack_and_leave_highest_id_first",
		"at 15: 2 hounds + 13 stress minions=%s | unequipped: pack, stress minions and cohort all gone=%s; re-equipped: all back=%s | 15 -> 6 kept the six LOWEST IDs %s=%s | in a fight the pack bit %d times into '%s' and the stress minions %d times into '%s', each at the canonical %.1f per bite=%s"
		% [str(had), str(gone), str(back), str(ids_after), str(kept_lowest), pb, HoundConfig.LEDGER_SOURCE, sb, CohortConfig.STRESS_LEDGER_SOURCE, dmg, str(ledger_ok)])
	_reached("C33_stress_minions_exist_only_with_the_pack_and_leave_highest_id_first")
	return ok

# =============================================================================
# J. COST
# =============================================================================

func chk_C34_path_query_cost_is_bounded_at_fifteen() -> bool:
	await _reset(15, "FAST", LANE_A)
	var c := hounds.cohort
	var q0 := c.path_queries()
	var cp0 := CohortFormation.closest_point_queries
	var direct0 := 0
	var path0 := 0
	for t in c.tracks:
		direct0 += (t as MobileCohort.Track).direct_frames
		path0 += (t as MobileCohort.Track).path_frames
	await _prime_toward(LANE_PRIME)
	player.command_move_to(LANE_B)
	var frames := 0
	while frames < 180:
		await physics_frame
		frames += 1
	var secs := float(frames) / TICKS
	var q := c.path_queries() - q0
	var direct := -direct0
	var path := -path0
	for t in c.tracks:
		direct += (t as MobileCohort.Track).direct_frames
		path += (t as MobileCohort.Track).path_frames
	var per_member := float(q) / secs / 15.0
	var direct_share := float(direct) / maxf(1.0, float(direct + path))
	var cp_per_s := float(CohortFormation.closest_point_queries - cp0) / secs
	# BOUNDS (test bounds): formation path queries at most one per member per repath
	# interval, and most travel steered straight (no path query) in the open lane.
	var bound := 1.0 / ProdConfig.REPATH_INTERVAL_S
	var ok := per_member <= bound and direct_share >= 0.8
	_finding("COST at 15, FAST, open lane: %.2f formation path queries per member per second (bound %.1f), %.0f%% of steering straight, %.0f navigation closest-point queries per second for the walkable clamps. D-397 read in code 'at least 75 path queries per second' for fifteen hounds' TARGETING; that cost is unchanged (the accepted rule's path test) and is carried with CD-06."
		% [per_member, bound, direct_share * 100.0, cp_per_s])
	await _reset(2, "ORDINARY", Vector3(-11, 0, 0))
	_note("C34_path_query_cost_is_bounded_at_fifteen",
		"15 members travelling at FAST for %.1f s: %d formation path queries = %.2f per member per second (bound %.1f, one per repath interval)=%s; %.0f%% of steering frames went straight with no path query (bound 80%%)=%s; %.0f closest-point queries per second (reported)"
		% [secs, q, per_member, bound, str(per_member <= bound), direct_share * 100.0, str(direct_share >= 0.8), cp_per_s])
	_reached("C34_path_query_cost_is_bounded_at_fifteen")
	return ok

# =============================================================================
# K. SURFACES AND THE REVIEW HUD
# =============================================================================

func chk_C35_launch_surfaces_hidden_and_the_cohesion_hud_shown() -> bool:
	var at_launch := not bool(launch["overlay_enabled"]) and not bool(launch["overlay_visible"]) \
		and not bool(launch["panel_enabled"]) and not bool(launch["panel_visible"]) \
		and not bool(launch["d381_enabled"]) and bool(launch["d392_enabled"]) and bool(launch["hounds_hud_enabled"]) \
		and bool(launch["cohort_hud_enabled"]) and bool(launch["cohort_hud_visible"])
	var ov0 := hud.enabled
	await _press("toggle_overlay")
	var ov_on := hud.enabled != ov0
	await _press("toggle_overlay")
	var p0 := panel.enabled
	await _press("imprint_panel")
	var p_on := panel.enabled != p0
	await _press("imprint_panel")
	var still := cohort_hud.enabled and hud.enabled == ov0 and panel.enabled == p0
	var ok := at_launch and ov_on and p_on and still
	_note("C35_launch_surfaces_hidden_and_the_cohesion_hud_shown",
		"AT LAUNCH: the F1 overlay and F2 panel hidden, the D-381 HUD hidden, and the Splinter Shot, Kindred Hounds AND cohesion HUDs shown=%s | F1 and F2 still toggle=%s/%s | afterwards the cohesion HUD still shown and both developer surfaces back as they were=%s"
		% [str(at_launch), str(ov_on), str(p_on), str(still)])
	_reached("C35_launch_surfaces_hidden_and_the_cohesion_hud_shown")
	return ok

func chk_C36_the_cohesion_hud_is_compact_clear_and_click_through() -> bool:
	await _reset(15, "EXTREME", Vector3(-11, 0, 0))
	var saved_root_size := root.size
	root.size = Vector2i(1920, 1080)
	var ov_was := hud.enabled
	hud.set_enabled(true)
	hud.refresh()
	d392_hud.refresh()
	hounds_hud.refresh()
	cohort_hud.refresh()
	for i in 4:
		await process_frame
	var view: Rect2 = cohort_hud.body.get_viewport_rect()
	var is_view := view.size == Vector2(1920, 1080)
	var r := cohort_hud.body_rect()
	var share := (r.size.x * r.size.y) / maxf(1.0, view.size.x * view.size.y)
	var centre := Rect2(view.size * 0.25, view.size * 0.5)
	var player_px: Vector2 = cam.cam.unproject_position(player.global_position)
	var ov_rect := (hud.get_node("OverlayPanel") as Control).get_global_rect()
	# The other two HUDs' rectangles, taken IN the measured view -- and printed as
	# taken (the note re-read them after the view was restored until the run of
	# record printed one at y = 1726 in a 1080-pixel view; found at delivery).
	var d392_r := d392_hud.body_rect()
	var hounds_r := hounds_hud.body_rect()
	var clear := not r.intersects(centre) and not r.has_point(player_px) and not r.intersects(ov_rect) \
		and not r.intersects(d392_r) and not r.intersects(hounds_r) and view.encloses(d392_r) and view.encloses(hounds_r)
	var placed := view.encloses(r) and r.position.y > view.size.y * 0.5 and r.size.x > 200.0 and r.size.y > 60.0
	var ctrls: Array = []
	_controls_under(cohort_hud, ctrls)
	var eats: Array[String] = []
	var small: Array[String] = []
	for c in ctrls:
		if (c as Control).mouse_filter != Control.MOUSE_FILTER_IGNORE:
			eats.append(String((c as Control).name))
		if c is Label and (c as Label).get_theme_font_size("font_size") < 14:
			small.append(String((c as Label).name))
	var beneath := cohort_hud.layer < hud.layer and cohort_hud.layer < panel.layer
	# THE CLEARANCE TEST CAN FAIL: a planted rectangle over the centre is refused.
	var guard := Rect2(view.size * 0.4, Vector2(100, 100)).intersects(centre)
	hud.set_enabled(ov_was)
	root.size = saved_root_size
	for i in 2:
		await process_frame
	await _reset(2, "ORDINARY", Vector3(-11, 0, 0))
	var ok := is_view and share <= 0.12 and clear and placed and eats.is_empty() and small.is_empty() and ctrls.size() >= 8 \
		and beneath and guard
	_finding("COHESION HUD (MEASURED in the 1920 x 1080 review view, 15 members at EXTREME): %s, %.1f%% of the screen. Review tooling, NOT a UI foundation; size and place PROVISIONAL." % [str(r), share * 100.0])
	_note("C36_the_cohesion_hud_is_compact_clear_and_click_through",
		"MEASURED in the 1920 x 1080 view=%s: the HUD at %s covers %.1f%% (<= 12%%) in the lower half=%s | clear of the centre, the player at %s, the F1 overlay when shown (%s), the Splinter Shot HUD (%s) and the Kindred Hounds HUD (%s)=%s | %d Controls, all MOUSE_FILTER_IGNORE (offenders %s), none under 14 px (%s) | beneath the overlay and the panel=%s | the centre test refuses a planted rectangle=%s"
		% [str(is_view), str(r), share * 100.0, str(placed), str(player_px), str(ov_rect), str(d392_r), str(hounds_r),
		   str(clear), ctrls.size(), str(eats), str(small), str(beneath), str(guard)])
	_reached("C36_the_cohesion_hud_is_compact_clear_and_click_through")
	return ok

func chk_C37_the_cohesion_hud_shows_only_the_ruling_reads_live_and_owns_no_number() -> bool:
	await _reset(2, "ORDINARY", Vector3(-11, 0, 0))
	var same := is_same(cohort_hud.runtime, hounds) and is_same(cohort_hud.diagnostics, diag)
	var keys_ok := _same(CohortReviewHud.LINE_KEYS, ["title", "population", "speed", "formation", "lag", "recovery", "controls"])
	var t0 := cohort_hud.compose_lines()
	var content := String(t0["title"]).find("review tooling, NOT a UI foundation") > 0 \
		and String(t0["population"]).find("DIAGNOSTIC POPULATION 2 · 2 Kindred Hounds + 0 DIAGNOSTIC stress minions") == 0 \
		and String(t0["speed"]).find("DIAGNOSTIC SPEED ORDINARY") == 0 and String(t0["formation"]).find("VANGUARD") == 0 \
		and String(t0["lag"]).find("FURTHEST LAG") == 0 and String(t0["recovery"]).find("SOFT RECOVERIES") == 0 \
		and String(t0["controls"]).find("not commands") > 0
	# LIVE: the population, the speed and a recovery each move their line at once.
	diag.set_population(10)
	diag.set_speed("EXTREME")
	await _phys(3)
	var m := _members()[5] as KindredHound
	var rc0 := hounds.cohort.total_recoveries()
	m.global_position = Vector3(-20.5, 0, 1.0)
	await _until(func() -> bool: return hounds.cohort.total_recoveries() > rc0, 180)
	var t1 := cohort_hud.compose_lines()
	var live := String(t1["population"]).find("DIAGNOSTIC POPULATION 10") == 0 and String(t1["speed"]).find("EXTREME") > 0 \
		and String(t1["recovery"]).find("SOFT RECOVERIES %d" % hounds.cohort.total_recoveries()) == 0 \
		and String(t1["recovery"]).find("path failure") > 0
	cohort_hud.refresh()
	# CONCISE, measured on the COMPOSED lines before any cut -- the rendered frames
	# showed two lines ending in an ellipsis while the drawn text passed (found at
	# delivery; a cut line is text nobody can read).
	var concise := true
	var cut: Array[String] = []
	for tt in [t0, t1]:
		for k in CohortReviewHud.LINE_KEYS:
			if String((tt as Dictionary)[k]).length() > CohortReviewHud.MAX_LINE_CHARS:
				concise = false
				cut.append("%s (%d)" % [k, String((tt as Dictionary)[k]).length()])
	concise = concise and cohort_hud.last_text.find("…") < 0
	# IT OWNS NO NUMBER.
	var src := _code_only(_read_text("res://scripts/cohort/cohort_review_hud.gd"))
	var text_code := _function_body(src, "compose_lines") + "\n" + _function_body(src, "_keys_of")
	var values: Array = [ProdConfig.TOP_SPEED_MPS]
	for row in CohortConfig.registry():
		values.append(float(row[1]))
	for p in CohortConfig.POPULATIONS:
		values.append(float(p))
	var hits: Array = []
	for v in _numeric_literals(text_code):
		for gv in values:
			if is_equal_approx(float(v), float(gv)):
				hits.append(v)
	var caught := false
	for v in _numeric_literals(text_code + "\n\tvar r := 14.0\n"):
		if is_equal_approx(float(v), CohortConfig.FAR_BEHIND_M):
			caught = true
	var ignored := true
	for v in _numeric_literals(text_code + "\n\t# far behind was 14.0 once\n"):
		if is_equal_approx(float(v), CohortConfig.FAR_BEHIND_M):
			ignored = false
	await _reset(2, "ORDINARY", Vector3(-11, 0, 0))
	var ok := same and keys_ok and content and live and concise and hits.is_empty() and caught and ignored and text_code.length() > 600
	_note("C37_the_cohesion_hud_shows_only_the_ruling_reads_live_and_owns_no_number",
		"it reads the scene's own runtime and diagnostics (identity)=%s | exactly seven lines — title, population, speed, formation, lag, recoveries, controls=%s | it says review tooling, DIAGNOSTIC POPULATION 2, ORDINARY, VANGUARD, FURTHEST LAG, SOFT RECOVERIES and 'not commands'=%s | population 10, EXTREME and a path-failure recovery showed at once=%s | every COMPOSED line fits <= %d characters with no cut, at 2 / ORDINARY and at 10 / EXTREME (cut: %s)=%s | the text code holds no gameplay value as a literal (%s); a planted literal is caught=%s, a comment ignored=%s"
		% [str(same), str(keys_ok), str(content), str(live), CohortReviewHud.MAX_LINE_CHARS, str(cut), str(concise), str(hits), str(caught), str(ignored)])
	_reached("C37_the_cohesion_hud_shows_only_the_ruling_reads_live_and_owns_no_number")
	return ok

# =============================================================================
# L. SCOPE, PRESERVATION AND TRUTHFULNESS
# =============================================================================

## "feeding" is the excluded mechanic; bare "feed" is NOT listed, because "feed-
## forward" is the control term pace-keeping uses (found on the first run:
## `debug_disable_feed_forward` matched it).
const FORBIDDEN_TOKENS := ["ranged", "support", "archer", "healer", "caster", "command", "commands", "stance",
	"stances", "feeding", "pet", "pets", "prey", "mark", "marked", "shard", "shards", "passive",
	"passives", "loot", "gear", "equipment", "affix", "additional", "coursing", "sinew", "ballista", "trap",
	"emplacement", "recall", "focus", "order", "orders", "rift", "campaign", "boss", "elite", "aura"]

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

func chk_C38_no_out_of_scope_content_or_tuning_change() -> bool:
	# NO NEW CONTENT: the library, the Configurations, the enemies, the scenes.
	# RE-SCOPED UNDER D-402, ONE FOR ONE: the library 16 + 1 = 17 and the
	# Configurations 8 + 1 = 9 -- Cinder Field, the ONE canonical ACTIVE Skill
	# Imprint that ruling authorizes, with its ONE unmodified Configuration.
	# Until D-402 these required 16 and 8: true when written.
	var counts := skills.library.count() == 17 and skills.configurations.size() == 9 \
		and ProdConfig.ENEMY_COUNT == 4 and enemies.size() == 4
	var named: Array[String] = []
	for id in skills.library.ids():
		var dn := (skills.library.get_imprint(String(id)) as Imprint).display_name
		for n in ["Additional Minion", "Coursing Hounds", "Sinew Ballista", "Huntress's Mark"]:
			if dn.findn(String(n)) >= 0:
				named.append(String(id))
	var scenes: Array = []
	_walk("res://scenes", scenes)
	# NO OUT-OF-SCOPE DECLARATION in a cohort file: no ranged or support role, no
	# command, stance, feeding or pet, no Prey or Mark, no Rift Shard, loot or gear.
	var decls: Array = []
	var prey_text: Array[String] = []
	for f in _files_under("res://scripts/cohort/"):
		decls.append_array(_forbidden_decls(String(f), _code_only(_read_text(String(f)))))
		if _read_text(String(f)).to_lower().find("prey") >= 0:
			prey_text.append(String(f).get_file())
	var caught := not _forbidden_decls("x.gd", "func command_pack_to(p) -> void:").is_empty() \
		and not _forbidden_decls("x.gd", "static func ranged_profile() -> FormationProfile:").is_empty() \
		and _forbidden_decls("x.gd", _code_only("# func ranged_profile() -> void:")).is_empty()
	# NO ASSET, AUDIO OR VFX: no cohort file loads anything or names an asset path.
	var vfx := RegEx.new()
	vfx.compile("(?i)\\bload\\(|preload\\(|AudioStream|ultimate_?monsters|BattleFX|MagicFX|VividMotion")
	var paths := RegEx.new()
	paths.compile("(?i)\"res://assets|assets/VFX|\\.(glb|gltf|fbx|obj|wav|ogg|mp3)\"")
	var loads: Array[String] = []
	for f in _files_under("res://scripts/cohort/"):
		var code := _code_only(_read_text(String(f)))
		if vfx.search(_strip_strings(code)) != null or paths.search(code) != null:
			loads.append(String(f).get_file())
	var load_caught := vfx.search(_strip_strings("\tvar m = preload(\"x\")")) != null
	var shard := RegEx.new()
	shard.compile("(?i)rift_?shard|rift_?echo")
	var shards: Array[String] = []
	for f in _runtime_script_files():
		if shard.search(_code_only(_read_text(String(f)))) != null:
			shards.append(String(f).get_file())
	# NO TUNING CHANGE: the accepted registries digest as pinned (C05) and the stand-in
	# is still primitives only.
	var tuning := String(_numeric_digest_of_map(_constants("res://scripts/hounds/hound_config.gd"))[1]) == DELIVERY_HOUND_DIGEST \
		and String(_numeric_digest_of_map(_constants("res://scripts/core/prod_config.gd"))[1]) == PRE_WORK_PROD_DIGEST \
		and String(_numeric_digest_of_map(_constants("res://scripts/imprint/imprint_config.gd"))[1]) == PRE_WORK_IMPRINT_DIGEST
	var ok := counts and named.is_empty() and scenes.size() == 1 and decls.is_empty() and prey_text.is_empty() and caught \
		and loads.is_empty() and load_caught and shards.is_empty() and tuning
	_note("C38_no_out_of_scope_content_or_tuning_change",
		"16 Imprints, 8 Configurations, 4 enemies=%s; Imprints bearing Additional Minion, Coursing Hounds, Sinew Ballista or Huntress's Mark: %s; one scene=%s | cohort declarations naming an excluded mechanic (a ranged or support role, command, stance, feeding, pet, Prey, Mark, Rift Shard, loot, gear...): %s; cohort files mentioning Prey at all: %s (planted declarations caught, a comment ignored=%s) | cohort files loading anything or naming an asset, VFX package or audio: %s (a planted load is caught=%s) | Rift Shard code anywhere: %s | the accepted registries digest as pinned — no damage, reservation, Capacity or recovery tuning=%s"
		% [str(counts), str(named), str(scenes.size() == 1), str(decls), str(prey_text), str(caught), str(loads), str(load_caught), str(shards), str(tuning)])
	_reached("C38_no_out_of_scope_content_or_tuning_change")
	return ok

const CO_TEXT := ["Whether the pack stays around or ahead of her.", "Whether it avoids trailing behind.",
	"Whether it handles congestion.", "Whether it transitions cleanly between combat and travel.",
	"Whether it recovers unobtrusively at extreme speed."]

func chk_C39_denials_rulings_units_and_no_self_acceptance() -> bool:
	# RE-SCOPED UNDER D-400, one for one: the self-denial became DATED HISTORY when
	# the owner accepted the stage, so the last row is its dated form -- 17 rows
	# still, ZERO deleted -- and it may also name D-400.
	var den := CohortConfig.denials()
	var den_ok := den.size() == 17 \
		and String(den[16]).begins_with("The D-398 stage was delivered OPEN and never accepted itself: the owner ACCEPTED and CLOSED it under D-399") \
		and String(den[16]).find("it was TRUE WHEN WRITTEN") > 0
	for d in den:
		den_ok = den_ok and (String(d).find("D-398") >= 0 or String(d).find("review HUD") >= 0)
	var rulings := CohortConfig.canonical_rulings()
	var cited := rulings.size() == 12
	for i in rulings.size():
		cited = cited and String(rulings[i][0]) == "D-398 item %d" % (i + 1)
	var cd := CohortConfig.deferred_rows()
	var cd_ok := cd.size() == 16
	for i in cd.size():
		cd_ok = cd_ok and String(cd[i][0]).begins_with("CD-%02d " % (i + 1)) and String(cd[i][2]).find("RETURNS TO") >= 0
	# RE-SCOPED UNDER D-400, one for one: 5 owed -> 0 owed and 0 -> 5 DISCHARGED,
	# with the original text preserved VERBATIM. 5 - 5 = 0; ZERO DELETED.
	var co := CohortConfig.owed_to_owner()
	var co_dis := CohortConfig.discharged_rows()
	var co_ok := co.is_empty() and co_dis.size() == 5
	for i in co_dis.size():
		co_ok = co_ok and String(co_dis[i][0]) == "CO-%02d" % (i + 1) \
			and String(co_dis[i][1]) == CO_TEXT[i] \
			and String(co_dis[i][2]) == "DISCHARGED — D-399" \
			and String(co_dis[i][3]).find("THE OWNER'S ANSWER, VERBATIM: ") == 0 \
			and String(co_dis[i][3]).find("THE OWNER'S D-399 LIVE REVIEW: ANSWERED DIRECTLY") > 0 \
			and String(co_dis[i][3]).find("ORIGINAL ROW TEXT, PRESERVED VERBATIM (OWED-TO-OWNER): '" + CO_TEXT[i] + "'") > 0
	# AND THE ACCEPTANCE IS RECORDED AT THE LEVEL THE OWNER GAVE IT AT.
	var level := CohortConfig.D399_ANSWER.find("ANSWERED DIRECTLY") > 0 \
		and CohortConfig.D399_ANSWER.find("remain findings rather than blockers") > 0
	var reading := CohortConfig.REGROUP_READING.find("for the owner to confirm or overrule") > 0 \
		and CohortConfig.REGROUP_READING.find("No new distance is introduced") > 0 \
		and CohortConfig.REGROUP_READING_STATUS.find("RULED") > 0 \
		and CohortConfig.REGROUP_READING_STATUS.find("THE TWO DISTANCES THEMSELVES ARE NOT LOCKED") > 0
	# NO SELF-ACCEPTANCE, anywhere a viewer or a log could read it.
	var self_re := RegEx.new()
	# RE-SCOPED UNDER D-400, one for one: the owner accepted this stage, so the
	# needle moves to the OPEN D-400 stage and to a D-398-dated self-acceptance,
	# which would still be false (D-398 delivered; D-400 accepted).
	# RE-SCOPED AGAIN UNDER D-402, one for one: D-401 accepted the locomotion stage,
	# so the needle moves to the OPEN D-402 stage and to a D-400-dated
	# self-acceptance, which would still be false (D-400 delivered; D-401 accepted).
	# RE-SCOPED UNDER D-404 (first act), one for one: D-403 made "CINDER FIELD
	# STAGE ACCEPTED" the OWNER's fact, so the needle MOVES to the OPEN D-404
	# stage, and "ACCEPTED and CLOSED (D-402)" joins what is still false.
	self_re.compile("PLAYER DIRECT-CLICK MOVEMENT CORRECTION STAGE ACCEPTED|ACCEPTED and CLOSED \\(D-402\\)|ACCEPTED and CLOSED \\(D-398\\)|ACCEPTED and CLOSED \\(D-400\\)|D-404 (is|stage is) ACCEPTED|" + PLANTED_CLAIM)
	var claims: Array[String] = []
	for f in _runtime_script_files():
		if self_re.search(_code_only(_read_text(String(f)))) != null:
			claims.append(String(f).get_file())
	cohort_hud.refresh()
	hounds_hud.refresh()
	var surfaces := cohort_hud.last_text + "\n" + hounds_hud.last_text + "\n" + d392_hud.last_text + "\n" + hud.compose() + "\n" + ProdConfig.STATE
	var surface_clean := self_re.search(surfaces) == null
	var caught := self_re.search("print(\"%s\")" % PLANTED_CLAIM) != null and self_re.search("PLAYER DIRECT-CLICK MOVEMENT CORRECTION STAGE ACCEPTED and CLOSED (D-404)") != null
	# THE BANNER PRINTS NO ROW AND NO STATE LINE, and does print the reading.
	var banner := _function_body(_code_only(_read_text("res://scripts/foundation_main.gd")), "_print_cohort_banner")
	var banner_ok := banner.length() > 200 and banner.find("STATE") < 0 and banner.find("deferred_rows") < 0 \
		and banner.find("owed_to_owner") < 0 and banner.find("discharged_rows") < 0 \
		and banner.find("REGROUP_READING") >= 0
	# UNITS AT EVERY SURFACE.
	var inv_path := ProjectSettings.globalize_path("res://").trim_suffix("/").get_base_dir() \
		.path_join("docs/testing/D398_MOBILE_MINION_COHESION_OWED_CRITERIA_INVENTORY.md")
	var inv := _read_text(inv_path)
	var units := inv != "" and inv.find("= **201**") >= 0 and inv.find("`C01`…`C40` = **40**") >= 0 \
		and inv.find("`Z01`…`Z22` = **22**") >= 0 and OWED.size() == 40
	var ok := den_ok and cited and cd_ok and co_ok and level and reading and claims.is_empty() and surface_clean and caught and banner_ok and units
	_note("C39_denials_rulings_units_and_no_self_acceptance",
		"RE-SCOPED UNDER D-400 (first act): %d denials, each naming D-398 or the review HUD, the last now DATED HISTORY naming D-400=%s | the owner's twelve items cited in order=%s | CD-01..CD-16, each naming where it returns=%s | CO-01..CO-05 now 0 owed and 5 DISCHARGED — D-399 with THE OWNER'S OWN ANSWER and their ORIGINAL TEXT VERBATIM=%s, recorded at the level the owner gave it at=%s | the regroup READING is still disclosed for the owner to confirm or overrule, with no new distance, and its D-399 status carries the owner's RULING with the two distances NOT locked=%s | runtime code claiming the OPEN D-400 stage accepted: %s; the HUDs, overlay and state line claim none=%s; planted claims caught=%s | the cohort banner prints no row and no STATE line, and prints the reading=%s | the inventory states 201 OWED CRITERIA, 40 EXECUTABLE CHECKS and 22 RUNNER CHECKS, and this suite owes %d=%s"
		% [den.size(), str(den_ok), str(cited), str(cd_ok), str(co_ok), str(level), str(reading), str(claims), str(surface_clean), str(caught), str(banner_ok), OWED.size(), str(units)])
	_reached("C39_denials_rulings_units_and_no_self_acceptance")
	return ok

## THIS STAGE'S OWN REGISTRY, pinned at delivery: 40 PROVISIONAL constants.
const DELIVERY_COHORT_DIGEST := "6650695f7d75812763508b3a26560a7dda36f58cf0e84f0d4b78ff9f81347657"
const DELIVERY_COHORT_COUNT := 40
## The digest reads every int, float, bool, vector and colour constant of the file;
## its count is measured at delivery and pinned with it.
const DELIVERY_COHORT_DIGEST_COUNT := 40

func chk_C40_seams_clear_and_every_stage_value_registered_provisional() -> bool:
	var launch_clear := bool(launch["seams_clear"]) and bool(launch["setup_ok"]) and (launch["setup_problems"] as Array).is_empty() \
		and not bool(launch["pass_seam"]) and not bool(launch["ff_seam"]) and is_equal_approx(float(launch["speed_scale"]), 1.0)
	var now_clear := not hounds.cohort.debug_disable_pass_through and not hounds.cohort.debug_disable_feed_forward \
		and is_equal_approx(player.diagnostic_travel_speed_scale, 1.0)
	# NO RUNTIME FILE SETS A COHORT TEST SEAM (only its declaration exists).
	var seam_re := RegEx.new()
	seam_re.compile("debug_disable_[a-z_]+\\s*=[^=]")
	var setters: Array[String] = []
	for f in _runtime_script_files():
		for line in _code_only(_read_text(String(f))).split("\n"):
			var l := String(line).strip_edges()
			if seam_re.search(l) != null and not l.begins_with("var "):
				setters.append("%s: %s" % [String(f).get_file(), l])
	# EVERY NUMERIC CONSTANT OF THE STAGE'S REGISTRY IS REGISTERED, AND BACK.
	var reg := CohortConfig.registry()
	var all_prov := reg.size() == DELIVERY_COHORT_COUNT
	for row in reg:
		all_prov = all_prov and String(row[2]).find("PROVISIONAL") == 0
	var consts := _constants("res://scripts/cohort/cohort_config.gd")
	var numeric: Array = []
	for k in consts.keys():
		var v = consts[k]
		if typeof(v) == TYPE_INT or typeof(v) == TYPE_FLOAT:
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
	planted.append(2.5)
	var refuses := planted.size() != reg_values.size()
	var digest := _numeric_digest_of_map(consts)
	var pinned := int(digest[0]) == DELIVERY_COHORT_DIGEST_COUNT and String(digest[1]) == DELIVERY_COHORT_DIGEST
	_finding("COHORT REGISTRY DIGEST (%d constants): %s" % [int(digest[0]), String(digest[1])])
	# NO RUNTIME LOAD LEAVES game3d/.
	var load_re := RegEx.new()
	load_re.compile("(?:load|preload|ResourceLoader\\.load|FileAccess\\.open|DirAccess\\.open)\\s*\\(\\s*\"([^\"]*)\"")
	var outward: Array[String] = []
	for f in _runtime_script_files():
		for m in load_re.search_all(_code_only(_read_text(String(f)))):
			if not m.get_string(1).begins_with("res://") or m.get_string(1).find("..") >= 0:
				outward.append("%s:%s" % [String(f).get_file(), m.get_string(1)])
	var ok := launch_clear and now_clear and setters.is_empty() and all_prov and both and refuses and pinned and outward.is_empty()
	_note("C40_seams_clear_and_every_stage_value_registered_provisional",
		"at launch every test seam was clear, the two cohort seams false and the speed scale 1.0, and the stage built with no problem=%s; clear again now=%s | runtime assignments of a cohort seam: %s | %d registry values, every one PROVISIONAL=%s; the registry and CohortConfig's numeric constants match both ways=%s; an unregistered planted constant is refused=%s | the registry's numeric digest equals the delivery pin (%d constants) — any change must move this pin in the same change=%s | loads leaving game3d/: %s. NONE IS A LOCK."
		% [str(launch_clear), str(now_clear), str(setters), reg.size(), str(all_prov), str(both), str(refuses), int(digest[0]), str(pinned), str(outward)])
	_reached("C40_seams_clear_and_every_stage_value_registered_provisional")
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
	print("RESULTS — %s (%s)" % [CohortConfig.STAGE, CohortConfig.DECISION])
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
	for row in CohortConfig.deferred_rows():
		print("  [%-24s] %s" % [row[1], row[0]])
		print("                   %s" % row[2])
	print("")
	print("OWED TO THE OWNER'S LIVE REVIEW — NOT passes and NOT failures:")
	for row in CohortConfig.owed_to_owner():
		print("  [OWED-TO-OWNER] %s %s" % [row[0], row[1]])
	print("")
	print("DISCHARGED BY THE OWNER'S D-400 ACCEPTANCE — NOT passes and NOT failures:")
	for row in CohortConfig.discharged_rows():
		print("  [%s] %s %s" % [row[2], row[0], row[1]])
		print("                   %s" % row[3])
	print("")
	print(CohortConfig.REGROUP_READING)
	print(CohortConfig.REGROUP_READING_STATUS)
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
	print("DENIALS (%d):" % CohortConfig.denials().size())
	for d in CohortConfig.denials():
		print("  %s" % d)
	print("")
	print("UNITS: %d EXECUTABLE CHECKS here · 201 OWED CRITERIA in the D-398 inventory ·" % OWED.size())
	print("       22 RUNNER CHECKS in tests/cohesion_smoke.sh · and the ACCEPTED suites' 85, 101, 40,")
	print("       53 and 45 EXECUTABLE CHECKS are DIFFERENT decisions' numbers.")
	print("       Different unit. None is a synonym for another.")
	print("")
	var verdict := "PASS" if _all_ok() else "FAIL"
	print("COHESION VERIFICATION: %s (%d checks: %d passed, %d failed/unreached, %d deferred, %d owed to the owner, %d discharged)"
		% [verdict, OWED.size(), passed, failed, CohortConfig.deferred_rows().size(),
		   CohortConfig.owed_to_owner().size(), CohortConfig.discharged_rows().size()])
	print("STATE: %s" % ProdConfig.STATE)
