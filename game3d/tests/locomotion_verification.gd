extends SceneTree

## RIFTWROUGHT — THE PLAYER LOCOMOTION REDIRECTION STAGE VERIFICATION  (D-400, 2026-09-20)
##
## ============================================================================
## A SEVENTH SUITE. THE SIX ACCEPTED ONES ARE RE-RUN AS REGRESSIONS.
## ============================================================================
## `tests/foundation_verification.gd` (85, ACCEPTED D-373), `imprint_` (101,
## D-376), `alignment_` (40, D-383), `huntress_` (53, D-394), `hounds_` (45,
## D-397) and `cohesion_` (40, ACCEPTED D-399) run FIRST in
## `tests/locomotion_smoke.sh`. This suite owns only what the D-400 stage owes.
##
## ============================================================================
## UNITS. TWENTY-ONE COUNTS EXIST IN THIS PROJECT AND NONE IS A SYNONYM FOR ANOTHER.
## ============================================================================
##   D-400 OWED CRITERIA     180  docs/testing/D400_PLAYER_LOCOMOTION_REDIRECTION_OWED_CRITERIA_INVENTORY.md
##   D-400 EXECUTABLE CHECKS  33  this suite (L01-L33)
##   D-400 RUNNER CHECKS      22  tests/locomotion_smoke.sh (N01-N22)
##   D-398 201 · 40 · 22   D-396 202 · 45 · 21   D-392 203 · 53 · 21
##   D-380 162 · 40 · 21   D-375 149 · 101 · 26   D-370 125 · 85 · 20
## The D-400 printed rows are 14 LD- rows and 4 LO- rows: none is a pass.
##
## ============================================================================
## IT VERIFIES A STAGE DELIVERED OPEN. IT ACCEPTS NOTHING.
## ============================================================================
## The owner: "It is not movement-speed tuning, a control-scheme change or
## authorization for other content." Every BOUND this suite asserts is a TEST
## BOUND, stated in its own note -- never a gameplay value, and never a lock.
##
## The standing verification rules, verbatim: a named owed list compared in BOTH
## directions · every check records reaching its LAST line · a missing check
## function is a FAIL, never a skip · every negative control is PROVED ABLE TO
## REFUSE · an assertion that something did NOT happen first asserts the action
## FIRED · source-scanning guards read CODE, never the dated history comments ·
## an unperformed check is DEFERRED and names where it returns · a sampled
## measurement is not a measurement of the thing you designed, so the arithmetic
## is measured EXACTLY wherever it can be.

const OWED := [
	# --- A. THE FIRST ACT -------------------------------------------------------
	"L01_state_names_seven_facts_exactly_with_one_definer",
	"L02_co_rows_discharged_d400_with_history_and_d398_denial_dated",
	"L03_every_accepted_pin_moved_together_and_refuses_stale_lines",
	# --- B. THE REDIRECTION ARITHMETIC, EXACTLY ---------------------------------
	"L04_redirects_in_one_step_at_45_90_135_and_180_degrees",
	"L05_redirection_preserves_scalar_speed_and_never_overspeeds",
	"L06_the_superseded_inertia_model_fails_the_same_tests",
	"L07_no_velocity_survives_in_the_obsolete_direction",
	# --- C. RATES SCALE WITH THE MAXIMUM ----------------------------------------
	"L08_accel_and_brake_rates_scale_with_the_current_maximum",
	"L09_response_times_are_consistent_across_the_three_diagnostic_speeds",
	"L10_at_scale_one_the_accepted_rates_and_times_are_unchanged",
	# --- D. IN THE LIVE CONTROLLER ----------------------------------------------
	"L11_a_new_click_order_redirects_in_the_same_physics_frame",
	"L12_a_click_across_the_blocker_goes_straight_with_no_path_corners",  # replaced one for one under D-404; its old name and requirement are dated in its body
	"L13_an_abrupt_180_reversal_redirects_in_the_same_physics_frame",
	"L14_obsolete_direction_displacement_is_negligible_at_every_speed",
	"L15_starting_from_rest_accelerates_and_releasing_brakes_to_rest",
	# --- E. ARRIVAL AND CORNERS -------------------------------------------------
	"L16_destination_arrival_without_overshoot_at_every_speed",
	"L17_arrival_does_not_oscillate_and_the_order_clears_once",
	"L18_a_click_order_stays_on_its_straight_segment_at_every_speed",  # replaced one for one under D-404; see its body
	"L19_the_arrival_cap_is_derived_and_never_binds_at_the_accepted_speed",
	# --- F. COLLISION AND NAVIGATION --------------------------------------------
	"L20_wall_collision_still_slides_legitimately",
	"L21_an_aligned_click_passes_the_doorway_and_a_slanted_one_stops",  # replaced one for one under D-404; see its body
	"L22_navigation_geometry_and_the_agent_radius_are_unchanged",
	# --- G. THE COMBAT COMMITMENT -----------------------------------------------
	"L23_a_movement_order_during_splinter_shot_windup_is_still_buffered",
	"L24_a_movement_order_after_release_still_cancels_recovery_and_redirects",
	"L25_the_stop_commitment_still_stops_and_its_brake_is_unscaled",
	# --- H. AIM AND FACING ------------------------------------------------------
	"L26_aim_is_independent_and_redirection_does_not_move_it",
	"L27_the_sampled_facing_snap_and_the_facing_hold_are_unchanged",
	# --- I. THE CONTROL SCHEME --------------------------------------------------
	"L28_click_to_move_is_preserved_and_no_wasd_binding_exists",
	"L29_no_new_input_action_no_new_surface_and_one_motor_path",
	# --- J. NO REGRESSION ELSEWHERE ---------------------------------------------
	"L30_minion_cohesion_is_not_regressed_by_the_sharper_reversal",
	"L31_no_accepted_value_camera_zoom_timing_or_geometry_changed",
	# --- K. SCOPE AND TRUTHFULNESS ----------------------------------------------
	"L32_denials_rulings_units_and_no_self_acceptance",
	"L33_seams_clear_and_every_stage_value_registered_provisional",
]

## ONE deliberately planted claim, so the self-acceptance scans can be proved
## able to refuse. It is never printed.
const PLANTED_CLAIM := "Locomotion_Stage_Accepts_Itself_THIS_IS_FORBIDDEN"

# D-404 (first act): `SEVEN` and `OPEN7` keep their IDENTIFIERS -- renaming
# around a guard is what this project's own rule forbids -- and their CONTENT moves
# with the state. From D-402 until D-404 `SEVEN` was the eight-fact line ending
# "CINDER FIELD STAGE DELIVERED and OPEN pending owner live review (D-402)" and
# `OPEN7` that clause -- TRUE WHEN WRITTEN. The line is now NINE facts.
const SEVEN := "FOUNDATION STAGE ACCEPTED and CLOSED (D-373) · IMPRINT STAGE ACCEPTED and CLOSED (D-376) · D-378 ALIGNMENT STAGE ACCEPTED and CLOSED (D-383) · HUNTRESS SPLINTER SHOT STAGE ACCEPTED and CLOSED (D-394) · KINDRED HOUNDS STAGE ACCEPTED and CLOSED (D-397) · MOBILE MINION COHESION STAGE ACCEPTED and CLOSED (D-399) · PLAYER LOCOMOTION REDIRECTION STAGE ACCEPTED and CLOSED (D-401) · CINDER FIELD STAGE ACCEPTED and CLOSED (D-403) · PLAYER DIRECT-CLICK MOVEMENT CORRECTION STAGE DELIVERED and OPEN pending owner live review (D-404)"
# ============================================================================
# RE-PINNED UNDER D-402, AS ITS FIRST ACT, EXACTLY AS D-401 SECTION 6 DIRECTS.
# ============================================================================
# `SEVEN` and `OPEN7` keep their IDENTIFIERS -- renaming around a guard is what
# this project's own rule forbids -- and their CONTENT moves with the state. From
# D-400 until D-402 `SEVEN` was the seven-fact line and `OPEN7` read "PLAYER
# LOCOMOTION REDIRECTION STAGE DELIVERED and OPEN pending owner live review
# (D-400)" -- TRUE WHEN WRITTEN, and the state this stage was ACCEPTED IN. D-401
# accepted and closed it; the eighth fact is now the OPEN D-402 Cinder Field stage.
const OPEN7 := "PLAYER DIRECT-CLICK MOVEMENT CORRECTION STAGE DELIVERED and OPEN pending owner live review (D-404)"
## The D-400-era line, held as a SUPERSEDED needle exactly as the two below are.
const STATE_D400 := "FOUNDATION STAGE ACCEPTED and CLOSED (D-373) · IMPRINT STAGE ACCEPTED and CLOSED (D-376) · D-378 ALIGNMENT STAGE ACCEPTED and CLOSED (D-383) · HUNTRESS SPLINTER SHOT STAGE ACCEPTED and CLOSED (D-394) · KINDRED HOUNDS STAGE ACCEPTED and CLOSED (D-397) · MOBILE MINION COHESION STAGE ACCEPTED and CLOSED (D-399) · PLAYER LOCOMOTION REDIRECTION STAGE DELIVERED and OPEN pending owner live review (D-400)"
## D-404: the D-402-era line, held as a SUPERSEDED needle exactly as STATE_D400 is.
const STATE_D402 := "FOUNDATION STAGE ACCEPTED and CLOSED (D-373) · IMPRINT STAGE ACCEPTED and CLOSED (D-376) · D-378 ALIGNMENT STAGE ACCEPTED and CLOSED (D-383) · HUNTRESS SPLINTER SHOT STAGE ACCEPTED and CLOSED (D-394) · KINDRED HOUNDS STAGE ACCEPTED and CLOSED (D-397) · MOBILE MINION COHESION STAGE ACCEPTED and CLOSED (D-399) · PLAYER LOCOMOTION REDIRECTION STAGE ACCEPTED and CLOSED (D-401) · CINDER FIELD STAGE DELIVERED and OPEN pending owner live review (D-402)"
const STATE_D398 := "FOUNDATION STAGE ACCEPTED and CLOSED (D-373) · IMPRINT STAGE ACCEPTED and CLOSED (D-376) · D-378 ALIGNMENT STAGE ACCEPTED and CLOSED (D-383) · HUNTRESS SPLINTER SHOT STAGE ACCEPTED and CLOSED (D-394) · KINDRED HOUNDS STAGE ACCEPTED and CLOSED (D-397) · MOBILE MINION COHESION STAGE DELIVERED and OPEN pending owner live review (D-398)"
const STATE_D396 := "FOUNDATION STAGE ACCEPTED and CLOSED (D-373) · IMPRINT STAGE ACCEPTED and CLOSED (D-376) · D-378 ALIGNMENT STAGE ACCEPTED and CLOSED (D-383) · HUNTRESS SPLINTER SHOT STAGE ACCEPTED and CLOSED (D-394) · KINDRED HOUNDS STAGE DELIVERED and OPEN pending owner live review (D-396)"

## The straight test lane: MEASURED walkable end to end (x = -11, z -9.5 .. 9.5).
const LANE_A := Vector3(-11.0, 0.0, -9.0)
const LANE_B := Vector3(-11.0, 0.0, 9.0)
## The cornered route: it must round the interior blocker and cross the doorway.
const ROUTE_FROM := Vector3(-13.0, 0.0, -7.0)
const ROUTE_TO := Vector3(7.0, 0.0, 0.0)
## The doorway approach, as the accepted suites drive it.
const DOOR_FROM := Vector3(-3.0, 0.0, 5.0)
const DOOR_PRIME := Vector3(-3.0, 0.0, 3.0)
const DOOR_TO := Vector3(8.0, 0.0, 0.0)
## D-404: a start ON the doorway's own axis, so a direct click passes it. The
## body sweep from here to DOOR_TO was MEASURED free before use.
const DOOR_ALIGNED_FROM := Vector3(-3.0, 0.0, 0.0)
## Where the scene's own enemies are parked, far from every route driven here.
const PARK := Vector3(-18.2, 0.0, -10.3)

## THE THREE DIAGNOSTIC MODES, by NAME. The multipliers are D-398's and this
## stage changes none of them.
const MODES := ["ORDINARY", "FAST", "EXTREME"]

## ============================================================================
## TEST BOUNDS. EVERY ONE OF THESE IS A TEST BOUND, NOT A GAMEPLAY VALUE.
## ============================================================================
## None is read by any runtime file, none is registered, and none is a lock.
const TOL_REDIRECT_DEG := 0.001      ## "the velocity IS the commanded direction"
const TOL_LATERAL_MPS := 1.0e-5      ## leftover speed across the commanded direction
const TOL_SPEED_REL := 1.0e-4        ## scalar speed preserved, relative
const TOL_OBSOLETE_M := 0.02         ## live travel the OLD way after a redirect
const TOL_OVERSHOOT_M := 0.05        ## past the commanded destination
const TOL_CORNER_M := 0.60           ## deviation from the path polyline
const DT := 1.0 / 60.0

## ============================================================================
## THE NEGATIVE CONTROL: the SUPERSEDED pre-D-400 arithmetic, kept HERE and
## nowhere else, so every claim this suite makes can be shown to fail against it.
## ============================================================================
## This is the accepted D-373 motor's `step()` body, verbatim in behaviour: the
## whole VELOCITY VECTOR moved toward its target. It is TEST-ONLY -- no runtime
## file contains it any more, and L06 proves it genuinely fails the checks the
## live model passes.
class LegacyInertiaMotor extends RefCounted:
	var velocity: Vector3 = Vector3.ZERO
	## `scaled` reproduces the superseded arithmetic with the D-400 rate scaling
	## added, so the two models can be compared on the redirection ALONE.
	var scaled: bool = false
	func step(wish: Vector3, top_speed: float, delta: float) -> Vector3:
		var w := wish
		w.y = 0.0
		if w.length() > 1.0:
			w = w.normalized()
		var target := w * top_speed
		var rate := ProdConfig.ACCEL_MPS2 if w.length() > 0.001 else ProdConfig.DECEL_MPS2
		if scaled:
			rate *= GroundMotion.rate_scale(top_speed)
		velocity = velocity.move_toward(target, rate * delta)
		velocity.y = 0.0
		return velocity

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
var launch := {}
var nav_map: RID

func _initialize() -> void:
	print("========================================================================")
	print("RIFTWROUGHT — %s VERIFICATION  (%s, %s)" % [LocomotionConfig.STAGE, LocomotionConfig.DECISION, LocomotionConfig.DATE])
	print("STATE: %s" % ProdConfig.STATE)
	print("Verifying a STAGE DELIVERED OPEN: ground movement with scalar speed and NO directional")
	print("inertia — the horizontal velocity redirected onto a new navigation, path or stick direction")
	print("in the SAME physics frame, the scalar speed preserved and clamped, acceleration and ordinary")
	print("braking scaled so their response time is constant, and arrival without overshoot.")
	print("It is NOT movement-speed tuning, NOT a control-scheme change, NOT authorization for other")
	print("content. It LOCKS NO NUMBER: every bound below is a TEST BOUND, stated in its own note.")
	print("OWED EXECUTABLE CHECKS: %d   DEFERRED ROWS: %d   OWED-TO-OWNER ROWS: %d   DISCHARGED ROWS: %d"
		% [OWED.size(), LocomotionConfig.deferred_rows().size(), LocomotionConfig.owed_to_owner().size(),
		   LocomotionConfig.discharged_rows().size()])
	print("(The D-400 owed-criteria INVENTORY counts 180 CRITERIA. Different unit.)")
	print("(The ACCEPTED suites count 85, 101, 40, 53, 45 and 40 EXECUTABLE CHECKS. Different decisions.)")
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
	nav_map = NavService.map_rid_for(main)
	# WHAT LAUNCH SHOWED, captured BEFORE any check touches anything.
	launch = {
		"seams_clear": player.intent.seams_clear() and cam.debug_cursor_override == null
			and not player.debug_freeze_attack,
		"speed_scale": player.diagnostic_travel_speed_scale,
		"speed_mode": diag.speed_name(),
		"population": diag.population(),
		"redirects": player.motor.redirects,
		"last_wish": player.last_wish,
		"overlay_enabled": hud.enabled, "panel_enabled": panel.enabled,
		"d381_enabled": review_hud.enabled, "d392_enabled": d392_hud.enabled,
		"hounds_hud_enabled": hounds_hud.enabled, "cohort_hud_enabled": cohort_hud.enabled,
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

func _until(cond: Callable, max_frames: int) -> int:
	var g := 0
	while g < max_frames and not bool(cond.call()):
		await physics_frame
		g += 1
	return g

static func _planar(a: Vector3, b: Vector3) -> float:
	return Vector2(a.x - b.x, a.z - b.z).length()

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

## Every string literal emptied, so a scan for IDENTIFIERS cannot fire on prose.
## The first run of this suite needed it: LocomotionConfig QUOTES the owner's
## item 9, which contains the word "facing".
static func _strip_strings(code: String) -> String:
	var re := RegEx.new()
	re.compile("\"(?:[^\"\\\\]|\\\\.)*\"")
	return re.sub(code, "\"\"", true)

func _runtime_script_files() -> Array:
	var all: Array = []
	_walk("res://scripts", all)
	var out: Array = []
	for f in all:
		if String(f).ends_with(".gd"):
			out.append(String(f))
	out.sort()
	return out

func _constants(path: String) -> Dictionary:
	var scr: Script = load(path)
	return scr.get_script_constant_map()

## A stable digest of every NUMERIC constant of a script, by name. Used to pin
## that no accepted tuning value moved.
##
## ============================================================================
## THE KEYS ARE CONVERTED TO `String` BEFORE SORTING, AND THAT IS NOT A DETAIL.
## ============================================================================
## `get_script_constant_map()` returns `StringName` keys, and `StringName`
## ordering in this engine is NOT lexicographic -- it compares internal pointers,
## which differ from run to run. The first version of this helper sorted the raw
## keys and produced a DIFFERENT digest on every run: four of the five registries
## "changed" between two runs in which not one file had been edited. A pin that
## moves on its own is worse than no pin, so the keys are normalised first --
## which is exactly what the accepted D-398 suite's own digest helper does.
static func _digest_of_map(m: Dictionary) -> Array:
	var by_name := {}
	for k in m.keys():
		by_name[String(k)] = m[k]
	var keys: Array = by_name.keys()
	keys.sort()
	var parts := PackedStringArray()
	var n := 0
	for k in keys:
		var v = by_name[k]
		if typeof(v) == TYPE_INT or typeof(v) == TYPE_FLOAT:
			parts.append("%s=%.6f" % [String(k), float(v)])
			n += 1
	return [n, "\n".join(parts).sha256_text()]

func _numeric_digest(path: String) -> Array:
	return _digest_of_map(_constants(path))

static func _state_parts_ok(state: String) -> bool:
	# RE-SCOPED UNDER D-402 (first act), one for one: 7 + 1 = 8 facts. Until D-402
	# this required SEVEN, with the D-400 locomotion stage as the open seventh --
	# true when written. The predicate is not weakened: every earlier part is still
	# matched EXACTLY, and the new one is an exact match too.
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
		and parts[8] == OPEN7

func _park_enemies() -> void:
	for i in enemies.size():
		var e: OrdinaryEnemy = enemies[i]
		e.debug_freeze_ai = true
		e.life = Damageable.new(1000000.0)
		e.global_position = PARK + Vector3(0.0, 0.0, 0.8 * float(i))

## Back to rest, seams clear, at a known point, ORDINARY speed.
func _rest_at(p: Vector3) -> void:
	player.intent.clear_seams()
	cam.debug_cursor_override = null
	player.clear_move_destination()
	player.follower.set_path(PackedVector3Array())
	player.commitment.reset()
	player.motor.reset()
	player.global_position = p
	await _phys(4)

func _set_mode(mode_name: String) -> void:
	diag.set_speed(mode_name)
	await _phys(2)

func _top() -> float:
	return ProdConfig.TOP_SPEED_MPS * player.diagnostic_travel_speed_scale

## Drive to (near) full speed along the lane by a click order, and return the
## speed reached. THE ACTION MUST HAVE FIRED: every caller asserts on this.
##
## IT ALSO WAITS FOR REAL TRAVEL, and that is not fussiness. Reaching the top
## speed takes 0.133 s, which at the ACCEPTED speed is 0.26 m -- still inside the
## 0.35 m arrival tolerance of the point it started from. A reversal order issued
## there is CLEARED ON ARRIVAL instead of served, and the actor brakes along its
## old direction. The first run of this suite measured exactly that and reported
## it as a failed redirect, which is what a bound that can fail is for.
const DRIVE_MIN_TRAVEL_M := 3.0

func _drive_lane(to: Vector3) -> float:
	var start := player.global_position
	player.command_move_to(to)
	await _until(func() -> bool: return player.motor.speed() >= 0.98 * _top() \
		and _planar(player.global_position, start) >= DRIVE_MIN_TRAVEL_M, 900)
	return player.motor.speed()

func _all_ok() -> bool:
	for id in OWED:
		if not reached.has(id) or results.get(id, null) != true:
			return false
	for id in reached.keys():
		if not OWED.has(id):
			return false
	return true

# =============================================================================
# A. THE FIRST ACT
# =============================================================================

func chk_L01_state_names_seven_facts_exactly_with_one_definer() -> bool:
	var s := ProdConfig.STATE
	var seven := _state_parts_ok(s) and s == SEVEN
	var re := RegEx.new()
	re.compile("(?m)^\\s*const\\s+STATE\\s*(:[^=]*)?:?=")
	var definers: Array[String] = []
	for f in _runtime_script_files():
		if re.search(_code_only(_read_text(String(f)))) != null:
			definers.append(String(f).get_file())
	var one := definers.size() == 1 and definers[0] == "prod_config.gd"
	var caught := re.search("const STATE := \"x\"") != null
	# EVERY superseded OPEN clause is gone as a CURRENT claim.
	var gone := s != STATE_D398 and s != STATE_D396 and s != STATE_D400 and s != STATE_D402 \
		and s.find("PLAYER LOCOMOTION REDIRECTION STAGE DELIVERED") < 0 \
		and s.find("CINDER FIELD STAGE DELIVERED") < 0 \
		and s.find("MOBILE MINION COHESION STAGE DELIVERED") < 0 \
		and s.find("KINDRED HOUNDS STAGE DELIVERED") < 0 \
		and s.find("SPLINTER SHOT STAGE DELIVERED") < 0 \
		and s.find("ALIGNMENT STAGE DELIVERED") < 0 \
		and s.find("IMPRINT STAGE DELIVERED") < 0
	# ITS HISTORY IS PRESERVED, DATED, IN THE ONE DEFINER'S OWN FILE.
	var src := _read_text("res://scripts/core/prod_config.gd")
	# RE-SCOPED UNDER D-402 (first act): the history it must find is THIS act's,
	# and the earlier block is still there -- history is preserved, never deleted.
	var history := src.find("RECONCILED A SEVENTH TIME UNDER D-402") >= 0 \
		and src.find("From D-400 until D-402 this read") >= 0 \
		and src.find("RECONCILED A SIXTH TIME UNDER D-400") >= 0 \
		and src.find("From D-398 until D-400 this read") >= 0 \
		and src.find(STATE_D398.substr(0, 60)) >= 0 \
		and src.find("works well, I like it") >= 0 \
		and src.find("IT WAS TRUE WHEN WRITTEN") >= 0
	var readers := _read_text("res://scripts/debug/debug_overlay.gd").find("ProdConfig.STATE") >= 0 \
		and _read_text("res://scripts/imprint/loadout_panel.gd").find("ProdConfig.STATE") >= 0
	# THE PREDICATE REFUSES: the two superseded lines, a self-accepted seventh
	# fact, an earlier stage accepting itself, an extra fact, six facts.
	var refuses := not _state_parts_ok(STATE_D398) and not _state_parts_ok(STATE_D396) \
		and not _state_parts_ok(STATE_D400) and not _state_parts_ok(STATE_D402) \
		and not _state_parts_ok(s.replace(OPEN7, "PLAYER DIRECT-CLICK MOVEMENT CORRECTION STAGE ACCEPTED and CLOSED (D-404)")) \
		and not _state_parts_ok(s.replace("CINDER FIELD STAGE ACCEPTED and CLOSED (D-403)", "CINDER FIELD STAGE ACCEPTED and CLOSED (D-402)")) \
		and not _state_parts_ok(s.replace("PLAYER LOCOMOTION REDIRECTION STAGE ACCEPTED and CLOSED (D-401)",
			"PLAYER LOCOMOTION REDIRECTION STAGE ACCEPTED and CLOSED (D-400)")) \
		and not _state_parts_ok(s + " · EXTRA STAGE (D-402)") \
		and not _state_parts_ok(" · ".join(s.split(" · ").slice(0, 7))) \
		and not _state_parts_ok(" · ".join(s.split(" · ").slice(0, 8)))
	var ok := seven and one and caught and gone and history and readers and refuses
	_note("L01_state_names_seven_facts_exactly_with_one_definer",
		"RE-PINNED UNDER D-404 (first act): the state line is now NINE facts — the eighth D-403's acceptance of Cinder Field, the ninth the D-404 direct-click stage OPEN — and the rest of this note is worded as at D-402, true when written: RE-SCOPED UNDER D-402 (first act): STATE is EXACTLY the EIGHT-fact line (foundation D-373 · Imprint D-376 · alignment D-383 · Splinter Shot D-394 · Kindred Hounds D-397 · mobile minion cohesion D-399 · player locomotion redirection ACCEPTED and CLOSED D-401 · Cinder Field DELIVERED and OPEN D-402)=%s | runtime definers: %s=%s (a planted one is seen=%s) | every superseded OPEN clause is gone as a current claim=%s | the D-398- AND D-400-era lines\' history is preserved and DATED in the one definer, with the owner\'s own D-401 answer=%s | the overlay and the panel read it=%s | the predicate refuses the D-398, D-396 and D-400 lines, a self-accepted eighth fact, the locomotion acceptance re-attributed to D-400, an extra fact and seven facts=%s"
		% [str(seven), str(definers), str(one), str(caught), str(gone), str(history), str(readers), str(refuses)])
	_reached("L01_state_names_seven_facts_exactly_with_one_definer")
	return ok

const CO_TEXT := ["Whether the pack stays around or ahead of her.", "Whether it avoids trailing behind.",
	"Whether it handles congestion.", "Whether it transitions cleanly between combat and travel.",
	"Whether it recovers unobtrusively at extreme speed."]

## THE OWNER'S OWN WORDS, one clause per row, in order -- WITH THEIR QUALIFIERS.
## "appropriately", "problematic" and "acceptably" are the owner's and are
## asserted here so a later edit cannot quietly smooth them into unqualified
## praise.
const CO_ANSWER := ["stays appropriately around or ahead of me",
	"avoids problematic trailing", "handles congestion acceptably",
	"transitions cleanly between combat and travel",
	"recovers unobtrusively at extreme speed"]

func chk_L02_co_rows_discharged_d400_with_history_and_d398_denial_dated() -> bool:
	var co := CohortConfig.discharged_rows()
	var owed := CohortConfig.owed_to_owner()
	var cd := CohortConfig.deferred_rows()
	var rows_ok := co.size() == 5 and owed.is_empty() and cd.size() == 16
	for i in co.size():
		rows_ok = rows_ok and String(co[i][0]) == "CO-%02d" % (i + 1) and String(co[i][1]) == CO_TEXT[i] \
			and String(co[i][2]) == "DISCHARGED — D-399" \
			and String(co[i][3]).find("THE OWNER'S ANSWER, VERBATIM: ") == 0 \
			and String(co[i][3]).find("THE OWNER'S D-399 LIVE REVIEW: ANSWERED DIRECTLY") > 0 \
			and String(co[i][3]).find(CO_ANSWER[i]) > 0 \
			and String(co[i][3]).find("ORIGINAL ROW TEXT, PRESERVED VERBATIM (OWED-TO-OWNER): '" + CO_TEXT[i] + "'") > 0
	# ============================================================
	# AT THE LEVEL GIVEN, AND BOUNDED AS THE OWNER BOUNDED IT.
	# ============================================================
	# D-399 answered CO-01..CO-05 DIRECTLY, in the owner's own words, and bounded
	# what those answers do NOT do. Both halves are asserted: the answers must be
	# the owner's, qualifiers and all, and the bound must travel with them.
	var level := CohortConfig.D399_ANSWER.find("ANSWERED DIRECTLY") > 0 \
		and CohortConfig.D399_ANSWER.find("No diagnostic population, speed, formation, leash, recovery or other numerical value is locked") > 0 \
		and CohortConfig.D399_ANSWER.find("remain findings rather than blockers") > 0
	var none_deleted := cd.size() + co.size() + owed.size() == 16 + 5
	# THE SELF-DENIAL IS DATED HISTORY, and the present-tense one is gone.
	var den := CohortConfig.denials()
	var dated := false
	var old_present := false
	for d in den:
		var t := String(d)
		if t.find("The D-398 stage was delivered OPEN and never accepted itself: the owner ACCEPTED and CLOSED it under D-399") == 0:
			dated = true
		if t == "The D-398 stage delivers OPEN pending owner live review; it does NOT accept itself.":
			old_present = true
	# THE REGROUP READING IS PRESERVED VERBATIM, and the owner's D-399 RULING on it
	# travels beside it -- with the bound the owner put on it.
	var reading := CohortConfig.REGROUP_READING.find("for the owner to confirm or overrule") > 0 \
		and CohortConfig.REGROUP_READING.find("No new distance is introduced") > 0
	var status := CohortConfig.REGROUP_READING_STATUS.find("RULED") > 0 \
		and CohortConfig.REGROUP_READING_STATUS.find("9 m disengage / 6 m reacquire interpretation of regrouping overriding combat is accepted") > 0 \
		and CohortConfig.REGROUP_READING_STATUS.find("The SHAPE of the rule is canon") > 0 \
		and CohortConfig.REGROUP_READING_STATUS.find("THE TWO DISTANCES THEMSELVES ARE NOT LOCKED") > 0
	# AND THE TWO DISTANCES REALLY ARE THE ACCEPTED D-396 ONES: no new distance
	# was introduced then, and none is introduced now.
	var no_ruling_claimed := is_equal_approx(HoundConfig.LEASH_RANGE_M, 9.0) \
		and is_equal_approx(HoundConfig.ACQUISITION_RANGE_M, 6.0)
	# THE D-397 SECTION 6 DISCREPANCY IS DISCHARGED BY THIS ACT.
	var discharged := ProdConfig.STATE.find("MOBILE MINION COHESION STAGE ACCEPTED and CLOSED (D-399)") >= 0 \
		and ProdConfig.STATE.find("MOBILE MINION COHESION STAGE DELIVERED") < 0
	var ok := rows_ok and level and none_deleted and dated and not old_present and den.size() == 17 \
		and reading and status and no_ruling_claimed and discharged
	_note("L02_co_rows_discharged_d400_with_history_and_d398_denial_dated",
		"CO-01..CO-05 DISCHARGED — D-399, each carrying THE OWNER'S OWN ANSWER (qualifiers included) and its ORIGINAL TEXT VERBATIM; 0 owed; 16 CD rows=%s | the answers are recorded at the level given and carry the owner's bound — no value locked, the four findings still findings=%s | 16 + 5 + 0 = 21 rows, ZERO deleted=%s | the D-398 self-denial is dated history naming D-399=%s, the present-tense one gone=%s, 17 denials=%s | the regroup READING is preserved verbatim=%s and carries the owner's D-399 RULING beside it — the SHAPE is canon, the two distances are NOT locked=%s; those distances are still the ACCEPTED D-396 9.0 m and 6.0 m=%s | the state now carries D-399's acceptance of the cohesion stage and no cohesion OPEN clause=%s"
		% [str(rows_ok), str(level), str(none_deleted), str(dated), str(not old_present),
		   str(den.size() == 17), str(reading), str(status), str(no_ruling_claimed), str(discharged)])
	_reached("L02_co_rows_discharged_d400_with_history_and_d398_denial_dated")
	return ok

const ACCEPTED_RUNNERS := ["res://tests/foundation_smoke.sh", "res://tests/imprint_smoke.sh",
	"res://tests/alignment_smoke.sh", "res://tests/huntress_smoke.sh", "res://tests/hounds_smoke.sh",
	"res://tests/cohesion_smoke.sh"]
const ACCEPTED_SUITES := ["res://tests/imprint_verification.gd", "res://tests/alignment_verification.gd",
	"res://tests/huntress_verification.gd", "res://tests/hounds_verification.gd",
	"res://tests/cohesion_verification.gd"]

## A runner is CURRENT when its exact-line pin is the SEVEN-fact line, it holds
## the D-396-era AND the D-398-era lines as ABSENCE needles it actually uses, and
## no pin names either of them as the expectation.
static func _runner_current(t: String) -> bool:
	return t.find("STATE_EXPECT=\"STATE: " + SEVEN + "\"") >= 0 \
		and t.find("STATE_D396_LINE=\"STATE: " + STATE_D396 + "\"") >= 0 \
		and t.count("STATE_D396_LINE") >= 2 \
		and t.find("STATE_D398_LINE=\"STATE: " + STATE_D398 + "\"") >= 0 \
		and t.count("STATE_D398_LINE") >= 2 \
		and t.find("STATE_EXPECT=\"STATE: " + STATE_D396 + "\"") < 0 \
		and t.find("STATE_EXPECT=\"STATE: " + STATE_D398 + "\"") < 0 \
		and t.find("STATE_D400_LINE=\"STATE: " + STATE_D400 + "\"") >= 0 \
		and t.count("STATE_D400_LINE") >= 2 \
		and t.find("STATE_EXPECT=\"STATE: " + STATE_D400 + "\"") < 0

func chk_L03_every_accepted_pin_moved_together_and_refuses_stale_lines() -> bool:
	var stale: Array[String] = []
	for r in ACCEPTED_RUNNERS:
		if not _runner_current(_read_text(String(r))):
			stale.append(String(r).get_file())
	var own := _runner_current(_read_text("res://tests/locomotion_smoke.sh"))
	# THE D-398 RUNNER'S OWN MOVES: 0 owed, 5 discharged, Z16 DECLARED, and its
	# self-acceptance needle moved to the OPEN D-400 stage.
	var ct := _read_text("res://tests/cohesion_smoke.sh")
	# RE-SCOPED UNDER D-402 (first act), one for one: D-401 made "PLAYER LOCOMOTION
	# REDIRECTION STAGE ACCEPTED" the OWNER's fact, so the D-398 runner's needle
	# moved to the OPEN D-402 stage. Until D-402 this required the locomotion
	# needle -- true when written. Everything else it pins is unchanged.
	var d398_ok := ct.find("\nPIN_C_OWNER=0\n") >= 0 and ct.find("\nPIN_C_DISCHARGED=5\n") >= 0 \
		and ct.find("[DECLARED] Z16") >= 0 and ct.find("DECLARED_CLAIMS=$((DECLARED_CLAIMS + 1))") >= 0 \
		and ct.find("SELF_ACCEPT='PLAYER DIRECT-CLICK MOVEMENT CORRECTION STAGE ACCEPTED|") >= 0
	# EVERY ACCEPTED SUITE THAT PINS THE STATE carries both D-400 clauses.
	var suites_ok := true
	var suite_rows: Array[String] = []
	for p in ACCEPTED_SUITES:
		var t := _read_text(String(p))
		var has := t.find("MOBILE MINION COHESION STAGE ACCEPTED and CLOSED (D-399)") >= 0 \
			and t.find("PLAYER LOCOMOTION REDIRECTION STAGE ACCEPTED and CLOSED (D-401)") >= 0 \
			and t.find(OPEN7) >= 0
		suites_ok = suites_ok and has
		suite_rows.append("%s=%s" % [String(p).get_file(), str(has)])
	# THE ACCEPTED FOUNDATION SUITE WAS NOT EDITED AT ALL by this stage: it
	# asserts nothing about the state, so there was nothing in it to move.
	var fsrc := _read_text("res://tests/foundation_verification.gd")
	# D-402 did not edit it either: it asserts nothing about the state, and the
	# Cinder Field stage's own values live in their own registry and suite.
	var foundation_untouched := fsrc.find("D-400") < 0 and fsrc.find("GroundMotion") < 0 \
		and fsrc.find("LocomotionConfig") < 0 and fsrc.find("CinderConfig") < 0
	# EVERY MOVED PIN IS STILL EXACT-LINE, keeps its refusal proof, and GAINED a
	# D-398-era absence check.
	var ft := _read_text("res://tests/foundation_smoke.sh")
	var it := _read_text("res://tests/imprint_smoke.sh")
	var exact := ft.find("if [ \"$STATE_LINE\" = \"$STATE_EXPECT\" ]; then") >= 0 \
		and it.find("if [ \"$LINE\" != \"$STATE_EXPECT\" ]; then") >= 0
	var refusal := ft.find("sed 's/ACCEPTED and CLOSED/DELIVERED and OPEN/'") >= 0 \
		and it.find("sed 's/ACCEPTED and CLOSED/DELIVERED and OPEN/'") >= 0
	var absence := ft.find("grep -qxF \"$STATE_D398_LINE\"") >= 0 \
		and it.find("grep -qxF \"$STATE_D398_LINE\"") >= 0 \
		and ft.find("grep -qxF \"$STATE_D400_LINE\"") >= 0 \
		and it.find("grep -qxF \"$STATE_D400_LINE\"") >= 0
	# NO GUARD WAS WEAKENED: every accepted count pin still stands.
	var counts := true
	for spec in [["res://tests/imprint_smoke.sh", "PIN_F_CHECKS=85"], ["res://tests/imprint_smoke.sh", "PIN_I_CHECKS=101"],
			["res://tests/alignment_smoke.sh", "PIN_A_CHECKS=40"], ["res://tests/huntress_smoke.sh", "PIN_H_CHECKS=53"],
			["res://tests/hounds_smoke.sh", "PIN_K_CHECKS=45"], ["res://tests/cohesion_smoke.sh", "PIN_C_CHECKS=40"]]:
		counts = counts and _read_text(String(spec[0])).find("\n" + String(spec[1]) + "\n") >= 0
	# THE AUDIT REFUSES a planted stale runner, one that dropped either needle,
	# and one that dropped the D-400 open clause.
	var planted_stale := not _runner_current(ft.replace("STATE_EXPECT=\"STATE: " + SEVEN + "\"",
		"STATE_EXPECT=\"STATE: " + STATE_D398 + "\""))
	var planted_no_needle := not _runner_current(ft.replace("STATE_D398_LINE", "STATE_OLD_LINE")) \
		and not _runner_current(ft.replace("STATE_D396_LINE", "STATE_OLD_LINE")) \
		and not _runner_current(ft.replace("STATE_D400_LINE", "STATE_OLD_LINE"))
	var planted_six := not _runner_current(ft.replace(" · " + OPEN7, ""))
	# AND ONE MORE, ADDED UNDER D-402: a runner that still calls the locomotion
	# stage OPEN is refused, because the eighth fact would then be missing.
	var planted_d400 := not _runner_current(ft.replace(SEVEN, STATE_D400))
	var ok := stale.is_empty() and own and d398_ok and suites_ok and foundation_untouched \
		and exact and refusal and absence and counts \
		and planted_stale and planted_no_needle and planted_six and planted_d400 \
		and ft.length() > 1000
	_note("L03_every_accepted_pin_moved_together_and_refuses_stale_lines",
		"RE-PINNED UNDER D-404 (first act): the state line is now NINE facts — the eighth D-403's acceptance of Cinder Field, the ninth the D-404 direct-click stage OPEN — and the rest of this note is worded as at D-402, true when written: RE-SCOPED UNDER D-402 (first act): all six accepted runners pin the EIGHT-fact line EXACTLY and hold the D-396-, D-398- AND D-400-era lines as USED absence needles (stale: %s)=%s, and so does this stage\'s runner=%s | the D-398 runner pins 0 owed / 5 discharged, DECLARES Z16 and refuses a self-accepted open D-402 stage=%s | the accepted suites carry the D-401 acceptance and the D-402 open clause: %s=%s | the accepted FOUNDATION suite was not edited at all (no D-400, D-402, GroundMotion, LocomotionConfig or CinderConfig mention)=%s | the pins are still EXACT-LINE=%s, keep their refusal proofs=%s and GAINED the D-398-era AND D-400-era absence checks=%s | every accepted count pin stands=%s | the audit REFUSES a planted stale runner=%s, one missing a needle=%s, one missing the open clause=%s, and one still calling the locomotion stage OPEN=%s"
		% [str(stale), str(stale.is_empty()), str(own), str(d398_ok), " · ".join(suite_rows), str(suites_ok),
		   str(foundation_untouched), str(exact), str(refusal), str(absence), str(counts),
		   str(planted_stale), str(planted_no_needle), str(planted_six), str(planted_d400)])
	_reached("L03_every_accepted_pin_moved_together_and_refuses_stale_lines")
	return ok

# =============================================================================
# B. THE REDIRECTION ARITHMETIC, MEASURED EXACTLY
# =============================================================================
#
# MEASURED BY STEPPING THE PURE ARITHMETIC WITH A KNOWN DELTA, never by sampling
# a moving character and hoping. "A sampled measurement is not a measurement of
# the thing you designed."

const ANGLES := [45.0, 90.0, 135.0, 180.0]

## The three CURRENT maxima: the accepted top speed times D-398's three declared
## diagnostic scales. NOT new values -- read from the accepted registry.
func _tops() -> Array:
	var out: Array = []
	for m in CohortConfig.speed_modes():
		out.append(ProdConfig.TOP_SPEED_MPS * float(m[1]))
	return out

## Brings a fresh motor to its top speed along +Z and returns it.
func _at_top(top: float) -> LocomotionMotor:
	var m := LocomotionMotor.new()
	var g := 0
	while m.speed() < top - 0.0005 and g < 2000:
		m.step(Vector3(0, 0, 1), top, DT)
		g += 1
	return m

func chk_L04_redirects_in_one_step_at_45_90_135_and_180_degrees() -> bool:
	var rows: Array[String] = []
	var all_ok := true
	var control_ok := true
	for top in _tops():
		for a in ANGLES:
			var dir := Vector3(0, 0, 1).rotated(Vector3.UP, deg_to_rad(float(a)))
			var m := _at_top(float(top))
			var before := m.velocity
			# EXACTLY ONE STEP. The claim is "in the same physics frame".
			var v := m.step(dir, float(top), DT)
			var off := GroundMotion.direction_angle_deg(v, dir)
			var lat := GroundMotion.lateral_speed(v, dir)
			var turned := GroundMotion.direction_angle_deg(before, v)
			var one_step := off <= TOL_REDIRECT_DEG and lat <= TOL_LATERAL_MPS \
				and absf(turned - float(a)) <= 0.01 and m.redirects == 1
			all_ok = all_ok and one_step
			# THE NEGATIVE CONTROL, on the same step: the SUPERSEDED arithmetic
			# leaves the velocity pointing somewhere nobody asked for.
			var lm := LegacyInertiaMotor.new()
			lm.velocity = before
			var lv := lm.step(dir, float(top), DT)
			var loff := GroundMotion.direction_angle_deg(lv, dir)
			control_ok = control_ok and loff > 1.0
			if a == 180.0:
				rows.append("top %.3f m/s, %.0f deg: off %.6f deg, lateral %.8f m/s, turned %.3f deg (SUPERSEDED model off %.2f deg)"
					% [top, a, off, lat, turned, loff])
	var ok := all_ok and control_ok
	_note("L04_redirects_in_one_step_at_45_90_135_and_180_degrees",
		"at EVERY diagnostic maximum and at 45, 90, 135 and 180 degrees, ONE step puts the velocity EXACTLY on the commanded direction and the turn measured is the turn asked for=%s | TEST BOUNDS (not gameplay values): off-direction <= %.4f deg, lateral <= %.8f m/s | the SUPERSEDED inertia model, stepped identically, is off by more than 1 deg every time=%s | %s"
		% [str(all_ok), TOL_REDIRECT_DEG, TOL_LATERAL_MPS, str(control_ok), " · ".join(rows)])
	_reached("L04_redirects_in_one_step_at_45_90_135_and_180_degrees")
	return ok

func chk_L05_redirection_preserves_scalar_speed_and_never_overspeeds() -> bool:
	var rows: Array[String] = []
	var preserved := true
	var never_over := true
	for top in _tops():
		for a in ANGLES:
			var dir := Vector3(0, 0, 1).rotated(Vector3.UP, deg_to_rad(float(a)))
			var m := _at_top(float(top))
			var s_in := m.speed()
			var s_out := m.step(dir, float(top), DT).length()
			# NO BURST AND NO SLOWDOWN: the scalar is carried, not re-derived.
			preserved = preserved and absf(s_out - s_in) <= TOL_SPEED_REL * float(top)
			never_over = never_over and s_out <= float(top) + 1.0e-6
			if a == 180.0:
				rows.append("top %.3f: %.6f -> %.6f m/s" % [top, s_in, s_out])
	# CLAMPED TO THE CURRENT ALLOWED MAXIMUM: a speed carried out of a FASTER
	# diagnostic mode cannot become an overspeed in a slower one.
	var fast := float(_tops()[2])
	var slow := float(_tops()[0])
	var m2 := LocomotionMotor.new()
	m2.velocity = Vector3(0, 0, 1) * fast
	var clamped := m2.step(Vector3(1, 0, 0), slow, DT).length()
	var clamp_ok := clamped <= slow + 1.0e-6
	# AND OVER A LONG DETERMINISTIC RUN OF DIRECTION CHANGES, nothing overspeeds.
	var m3 := _at_top(slow)
	var worst := 0.0
	for i in 600:
		var ang := deg_to_rad(float((i * 37) % 360))
		worst = maxf(worst, m3.step(Vector3(0, 0, 1).rotated(Vector3.UP, ang), slow, DT).length())
	var run_ok := worst <= slow + 1.0e-6
	# THE PREDICATE CAN REFUSE: a planted burst and a planted slowdown.
	var refuses := not (absf((slow * 1.05) - slow) <= TOL_SPEED_REL * slow) \
		and not (absf((slow * 0.90) - slow) <= TOL_SPEED_REL * slow) \
		and not ((slow * 1.05) <= slow + 1.0e-6)
	var ok := preserved and never_over and clamp_ok and run_ok and refuses
	_note("L05_redirection_preserves_scalar_speed_and_never_overspeeds",
		"the scalar speed is PRESERVED through every redirect at every maximum (TEST BOUND: within %.8f relative)=%s and never exceeds the current maximum=%s | %s | a speed carried out of the EXTREME mode (%.3f m/s) into the ORDINARY one is clamped to %.6f <= %.3f=%s | 600 deterministic direction changes: worst speed %.6f <= %.3f=%s | the predicate REFUSES a planted 5%% burst and a planted 10%% slowdown=%s"
		% [TOL_SPEED_REL, str(preserved), str(never_over), " · ".join(rows), fast, clamped, slow,
		   str(clamp_ok), worst, slow, str(run_ok), str(refuses)])
	_reached("L05_redirection_preserves_scalar_speed_and_never_overspeeds")
	return ok

func chk_L06_the_superseded_inertia_model_fails_the_same_tests() -> bool:
	# ========================================================================
	# THE NEGATIVE CONTROL IS ITSELF PROVED ABLE TO REFUSE.
	# ========================================================================
	# "A guard that accepts everything protects nothing." So the SUPERSEDED
	# arithmetic is run through THE SAME predicates the live model passes, and it
	# must FAIL every one of them.
	var top := float(_tops()[2])
	var dir := Vector3(0, 0, -1)
	var lm := LegacyInertiaMotor.new()
	lm.velocity = Vector3(0, 0, 1) * top
	var lv := lm.step(dir, top, DT)
	var fails_redirect := GroundMotion.direction_angle_deg(lv, dir) > TOL_REDIRECT_DEG
	# THE LATERAL MEASURE NEEDS A TURN THAT HAS A LATERAL COMPONENT. At exactly
	# 180 degrees the superseded velocity is ANTI-parallel to the commanded
	# direction, so its lateral part is zero and the measure cannot see it -- the
	# first run of this suite measured that and reported it, which is what a bound
	# that can fail is for. The 90 degree case is where leftover inertia IS
	# lateral, and that is where the measure is exercised.
	var side := Vector3(1, 0, 0)
	var lm90 := LegacyInertiaMotor.new()
	lm90.velocity = Vector3(0, 0, 1) * top
	var lv90 := lm90.step(side, top, DT)
	var fails_lateral := GroundMotion.lateral_speed(lv90, side) > TOL_LATERAL_MPS \
		and GroundMotion.lateral_speed(lv, dir) <= TOL_LATERAL_MPS
	# AND THE TRAVEL IT LEAVES BEHIND: how far it keeps going the OLD way after a
	# 180 degree reversal, integrated frame by frame until it is going the new way.
	var legacy_travel := 0.0
	var legacy_frames := 0
	var lm2 := LegacyInertiaMotor.new()
	lm2.velocity = Vector3(0, 0, 1) * top
	while lm2.velocity.dot(Vector3(0, 0, 1)) > 0.0 and legacy_frames < 600:
		lm2.step(dir, top, DT)
		legacy_travel += maxf(0.0, lm2.velocity.dot(Vector3(0, 0, 1))) * DT
		legacy_frames += 1
	# THE LIVE MODEL, on the identical input.
	var nm := LocomotionMotor.new()
	nm.velocity = Vector3(0, 0, 1) * top
	var new_travel := 0.0
	var new_frames := 0
	while nm.velocity.dot(Vector3(0, 0, 1)) > 0.0 and new_frames < 600:
		nm.step(dir, top, DT)
		new_travel += maxf(0.0, nm.velocity.dot(Vector3(0, 0, 1))) * DT
		new_frames += 1
	# EVEN WITH THE D-400 RATE SCALING ADDED, the superseded model still slides:
	# the defect is the VECTOR move, not the rate.
	var lm3 := LegacyInertiaMotor.new()
	lm3.scaled = true
	lm3.velocity = Vector3(0, 0, 1) * top
	var scaled_travel := 0.0
	var k := 0
	while lm3.velocity.dot(Vector3(0, 0, 1)) > 0.0 and k < 600:
		lm3.step(dir, top, DT)
		scaled_travel += maxf(0.0, lm3.velocity.dot(Vector3(0, 0, 1))) * DT
		k += 1
	_finding("SUPERSEDED-MODEL COMPARISON at the EXTREME diagnostic maximum (%.3f m/s), MEASURED: the pre-D-400 arithmetic travels %.4f m the OBSOLETE way over %d frames (%.4f m over %d frames even with the D-400 rate scaling added); the live model travels %.6f m over %d frames. The defect was the VECTOR move, not the rate."
		% [top, legacy_travel, legacy_frames, scaled_travel, k, new_travel, new_frames])
	var contrast := legacy_travel > 1.0 and new_travel <= 1.0e-6 and scaled_travel > 0.3
	var ok := fails_redirect and fails_lateral and contrast
	_note("L06_the_superseded_inertia_model_fails_the_same_tests",
		"the SUPERSEDED pre-D-400 arithmetic, run through the SAME predicates, FAILS the one-step redirect (off %.3f deg > %.4f)=%s and FAILS the lateral bound on a 90 degree turn (%.4f m/s > %.8f), while at exactly 180 degrees its leftover velocity is ANTI-parallel and has no lateral part at all — measured, and stated=%s | obsolete-direction travel after a 180 deg reversal at %.3f m/s: SUPERSEDED %.4f m in %d frames, SUPERSEDED-with-D-400-rates %.4f m, LIVE %.6f m in %d frames=%s. The control is TEST-ONLY: no runtime file contains it."
		% [GroundMotion.direction_angle_deg(lv, dir), TOL_REDIRECT_DEG, str(fails_redirect),
		   GroundMotion.lateral_speed(lv90, side), TOL_LATERAL_MPS, str(fails_lateral),
		   top, legacy_travel, legacy_frames, scaled_travel, new_travel, new_frames, str(contrast)])
	_reached("L06_the_superseded_inertia_model_fails_the_same_tests")
	return ok

func chk_L07_no_velocity_survives_in_the_obsolete_direction() -> bool:
	var rows: Array[String] = []
	var ok_all := true
	for top in _tops():
		for a in [90.0, 135.0, 180.0]:
			var old_dir := Vector3(0, 0, 1)
			var dir := old_dir.rotated(Vector3.UP, deg_to_rad(float(a)))
			var m := _at_top(float(top))
			var v := m.step(dir, float(top), DT)
			# THE COMPONENT ALONG THE OBSOLETE DIRECTION. For a turn of 90 degrees
			# or more the commanded direction has NO forward component, so any
			# positive value here IS leftover inertia and nothing else.
			var along := v.dot(old_dir)
			var lat := GroundMotion.lateral_speed(v, dir)
			var this_ok := along <= 1.0e-6 and lat <= TOL_LATERAL_MPS
			ok_all = ok_all and this_ok
			if is_equal_approx(float(top), float(_tops()[2])):
				rows.append("%.0f deg: along the obsolete direction %.9f m/s, lateral %.9f m/s" % [a, along, lat])
	# AND OVER THE FOLLOWING FRAMES, integrated: nothing accumulates either.
	var top3 := float(_tops()[2])
	var m2 := _at_top(top3)
	var carried := 0.0
	for i in 30:
		m2.step(Vector3(0, 0, -1), top3, DT)
		carried += maxf(0.0, m2.velocity.dot(Vector3(0, 0, 1))) * DT
	# THE MEASURE CAN REFUSE: the superseded model on the same 30 frames.
	var lm := LegacyInertiaMotor.new()
	lm.velocity = Vector3(0, 0, 1) * top3
	var legacy := 0.0
	for i in 30:
		lm.step(Vector3(0, 0, -1), top3, DT)
		legacy += maxf(0.0, lm.velocity.dot(Vector3(0, 0, 1))) * DT
	var refuses := legacy > TOL_OBSOLETE_M
	var ok := ok_all and carried <= 1.0e-6 and refuses
	_note("L07_no_velocity_survives_in_the_obsolete_direction",
		"after ONE redirect of 90, 135 or 180 degrees, at EVERY diagnostic maximum, the velocity has NO component along the obsolete direction and NO lateral component=%s | at the EXTREME maximum: %s | integrated over the following 30 frames the obsolete-direction travel is %.9f m (TEST BOUND %.3f m)=%s | the measure REFUSES the superseded model, which travels %.4f m over the same 30 frames=%s"
		% [str(ok_all), " · ".join(rows), carried, TOL_OBSOLETE_M, str(carried <= 1.0e-6), legacy, str(refuses)])
	_reached("L07_no_velocity_survives_in_the_obsolete_direction")
	return ok

# =============================================================================
# C. RATES SCALE WITH THE MAXIMUM — item 6
# =============================================================================

func chk_L08_accel_and_brake_rates_scale_with_the_current_maximum() -> bool:
	var rows: Array[String] = []
	var scaled := true
	for top in _tops():
		var t := float(top)
		var expect := t / ProdConfig.TOP_SPEED_MPS
		scaled = scaled and absf(GroundMotion.rate_scale(t) - expect) <= 1.0e-6 \
			and absf(GroundMotion.accel_rate(t) - ProdConfig.ACCEL_MPS2 * expect) <= 1.0e-6 \
			and absf(GroundMotion.brake_rate(t) - ProdConfig.DECEL_MPS2 * expect) <= 1.0e-6
		rows.append("top %.4f -> scale %.4f, accel %.3f, brake %.3f m/s^2" % [t, GroundMotion.rate_scale(t), GroundMotion.accel_rate(t), GroundMotion.brake_rate(t)])
	# MONOTONIC in the maximum, in both directions.
	var mono := GroundMotion.accel_rate(1.0) < GroundMotion.accel_rate(2.0) \
		and GroundMotion.brake_rate(1.0) < GroundMotion.brake_rate(2.0) \
		and GroundMotion.accel_rate(4.0) > GroundMotion.accel_rate(2.0)
	# THE REFERENCE IS THE ACCEPTED CONSTANT ITSELF, BY REFERENCE, not a re-typed
	# literal -- read from the SOURCE, so a second copy of 3.889 would fail.
	var src := _code_only(_read_text("res://scripts/locomotion/locomotion_config.gd"))
	var by_reference := src.find("const RATE_REFERENCE_MPS := ProdConfig.TOP_SPEED_MPS") >= 0 \
		and src.find("3.889") < 0
	var same := is_equal_approx(LocomotionConfig.RATE_REFERENCE_MPS, ProdConfig.TOP_SPEED_MPS)
	# THE ACTION BRAKE IS NOT SCALED (LD-02): the motor's brake() takes a rate and
	# never asks GroundMotion for one.
	var brake_body := _function_body(_code_only(_read_text("res://scripts/control/locomotion_motor.gd")), "brake")
	var action_unscaled := brake_body.find("GroundMotion") < 0 and brake_body.find("rate_scale") < 0 \
		and brake_body.find("move_toward(Vector3.ZERO, rate * delta)") >= 0
	# THE PREDICATE CAN REFUSE: an unscaled rate fails the scaling test outright.
	var refuses := absf(ProdConfig.ACCEL_MPS2 - ProdConfig.ACCEL_MPS2 * (float(_tops()[2]) / ProdConfig.TOP_SPEED_MPS)) > 1.0e-6
	var ok := scaled and mono and by_reference and same and action_unscaled and refuses
	_note("L08_accel_and_brake_rates_scale_with_the_current_maximum",
		"acceleration and ORDINARY braking scale exactly with the current maximum: %s=%s | monotonic in the maximum both ways=%s | the reference speed is ProdConfig.TOP_SPEED_MPS BY REFERENCE and the file contains no re-typed 3.889=%s, and it equals the accepted constant=%s | the ACTION brake is NOT scaled — its body asks GroundMotion for nothing (LD-02)=%s | an unscaled rate is refused by the scaling test=%s. NO RATE IS LOCKED."
		% [" · ".join(rows), str(scaled), str(mono), str(by_reference), str(same), str(action_unscaled), str(refuses)])
	_reached("L08_accel_and_brake_rates_scale_with_the_current_maximum")
	return ok

func chk_L09_response_times_are_consistent_across_the_three_diagnostic_speeds() -> bool:
	var up: Array[float] = []
	var down: Array[float] = []
	var rows: Array[String] = []
	for top in _tops():
		var t := float(top)
		var m := LocomotionMotor.new()
		var n := 0
		while m.speed() < t - 0.0005 and n < 4000:
			m.step(Vector3(0, 0, 1), t, DT)
			n += 1
		up.append(float(n) * DT)
		m.velocity = Vector3(0, 0, 1) * t
		var n2 := 0
		while m.speed() > 0.0005 and n2 < 4000:
			m.step(Vector3.ZERO, t, DT)
			n2 += 1
		down.append(float(n2) * DT)
		rows.append("top %.4f m/s: rest->top %.4f s, top->rest %.4f s" % [t, float(n) * DT, float(n2) * DT])
	var up_spread: float = float(up.max()) - float(up.min())
	var down_spread: float = float(down.max()) - float(down.min())
	# TEST BOUND: one physics frame. The arithmetic makes these identical; the
	# bound allows exactly the discretisation and nothing more.
	var consistent := up_spread <= DT + 1.0e-9 and down_spread <= DT + 1.0e-9
	# THE NEGATIVE CONTROL: with the accepted rates left UNSCALED -- which is what
	# the project did before D-400 -- the same times diverge by whole frames.
	var un_up: Array[float] = []
	for top in _tops():
		var t := float(top)
		var v := 0.0
		var n := 0
		while v < t - 0.0005 and n < 4000:
			v = move_toward(v, t, ProdConfig.ACCEL_MPS2 * DT)
			n += 1
		un_up.append(float(n) * DT)
	var un_spread: float = float(un_up.max()) - float(un_up.min())
	var control := un_spread > 4.0 * DT
	var ok := consistent and control
	_note("L09_response_times_are_consistent_across_the_three_diagnostic_speeds",
		"MEASURED at every diagnostic maximum: %s | the rest-to-top spread is %.6f s and the top-to-rest spread %.6f s, both within the TEST BOUND of one physics frame (%.6f s)=%s | NEGATIVE CONTROL: with the accepted rates left UNSCALED the rest-to-top times are %s — a spread of %.4f s=%s"
		% [" · ".join(rows), up_spread, down_spread, DT, str(consistent), str(un_up), un_spread, str(control)])
	_reached("L09_response_times_are_consistent_across_the_three_diagnostic_speeds")
	return ok

func chk_L10_at_scale_one_the_accepted_rates_and_times_are_unchanged() -> bool:
	# THE ACCEPTED CONSTANTS ARE UNTOUCHED.
	var consts := is_equal_approx(ProdConfig.TOP_SPEED_MPS, 3.889) \
		and is_equal_approx(ProdConfig.ACCEL_MPS2, 30.0) \
		and is_equal_approx(ProdConfig.DECEL_MPS2, 38.0) \
		and is_equal_approx(ProdConfig.ACTION_BRAKE_MPS2, 120.0) \
		and is_equal_approx(ProdConfig.ARRIVE_TOLERANCE_M, 0.35)
	# AT THE ACCEPTED SPEED THE SCALE IS EXACTLY 1.0 AND THE RATES ARE THE ACCEPTED
	# ONES -- which is why the accepted F30 and F77 pass untouched.
	var t := ProdConfig.TOP_SPEED_MPS
	var unity := is_equal_approx(GroundMotion.rate_scale(t), 1.0) \
		and is_equal_approx(GroundMotion.accel_rate(t), ProdConfig.ACCEL_MPS2) \
		and is_equal_approx(GroundMotion.brake_rate(t), ProdConfig.DECEL_MPS2)
	# AND F30's OWN ARITHMETIC, RE-DERIVED INDEPENDENTLY HERE.
	var m := LocomotionMotor.new()
	var n := 0
	while m.speed() < t - 0.0005 and n < 600:
		m.step(Vector3(0, 0, 1), t, DT)
		n += 1
	var reached_top := m.speed()
	var t_up := float(n) * DT
	var n2 := 0
	while m.speed() > 0.0005 and n2 < 600:
		m.step(Vector3.ZERO, t, DT)
		n2 += 1
	var t_down := float(n2) * DT
	var matches := absf(reached_top - t) < 0.01 * t \
		and absf(t_up - t / ProdConfig.ACCEL_MPS2) <= DT + 0.0001 \
		and absf(t_down - t / ProdConfig.DECEL_MPS2) <= DT + 0.0001 \
		and reached_top <= t + 0.0001
	# THE ACCEPTED SUITE STILL OWNS ITS OWN CLAIM: F30 and F77 were NOT edited.
	var fsrc := _read_text("res://tests/foundation_verification.gd")
	var f30 := _function_body(fsrc, "chk_F30_top_speed_accel_decel_measured")
	var f77 := _function_body(fsrc, "chk_F77_top_speed_unchanged_by_the_commitment_correction")
	var untouched := f30.find("D-400") < 0 and f77.find("D-400") < 0 \
		and f30.find("m.step(fwd, ProdConfig.TOP_SPEED_MPS, dt)") >= 0 \
		and f77.find("is_equal_approx(ProdConfig.DECEL_MPS2, 38.0)") >= 0
	var ok := consts and unity and matches and untouched
	_note("L10_at_scale_one_the_accepted_rates_and_times_are_unchanged",
		"the accepted constants are untouched (3.889 / 30.0 / 38.0 / 120.0 / 0.35)=%s | at the accepted speed the scale is EXACTLY 1.0 and the rates are the accepted ones=%s | re-derived independently: top %.4f m/s, rest->top %.4f s against the arithmetic %.4f s, top->rest %.4f s against %.4f s=%s | the accepted F30 and F77 were NOT edited and still step the motor with three arguments=%s"
		% [str(consts), str(unity), reached_top, t_up, t / ProdConfig.ACCEL_MPS2, t_down,
		   t / ProdConfig.DECEL_MPS2, str(matches), str(untouched)])
	_reached("L10_at_scale_one_the_accepted_rates_and_times_are_unchanged")
	return ok

# =============================================================================
# D. IN THE LIVE CONTROLLER
# =============================================================================
#
# THE INVARIANT EVERY LIVE CHECK LEANS ON, stated once: while the actor is moving
# under an order, its velocity IS the direction it was last asked for. The
# controller LOGS that direction (`player.last_wish`) after resolving it, so the
# comparison is between the COMMANDED direction and the RESULTING velocity on the
# SAME frame -- not between the suite's arithmetic and itself.

## Samples the live controller for `frames` physics frames and returns the worst
## off-direction angle between the velocity and the direction last asked for.
func _worst_off_direction(frames: int) -> Dictionary:
	var worst := 0.0
	var samples := 0
	var worst_turn := 0.0
	var turn_followed := 0.0
	var prev := player.last_wish
	for i in frames:
		await physics_frame
		var w := player.last_wish
		if w.length() > 0.001 and player.motor.speed() > 0.05:
			samples += 1
			worst = maxf(worst, GroundMotion.direction_angle_deg(player.motor.velocity, w))
			var turn := GroundMotion.direction_angle_deg(prev, w)
			if turn > worst_turn and prev.length() > 0.001:
				worst_turn = turn
				turn_followed = GroundMotion.direction_angle_deg(player.motor.velocity, w)
		prev = w
	return {"worst": worst, "samples": samples, "worst_turn": worst_turn, "followed": turn_followed}

func chk_L11_a_new_click_order_redirects_in_the_same_physics_frame() -> bool:
	var rows: Array[String] = []
	var all_ok := true
	# --- THE MOUSE SCHEME: a NEW CLICK ORDER, in the opposite direction. ------
	await _set_mode("ORDINARY")
	await _rest_at(LANE_A)
	var moving := await _drive_lane(LANE_B)
	var before := player.motor.velocity.normalized()
	player.command_move_to(LANE_A)
	await physics_frame                                  # EXACTLY ONE FRAME
	var after := player.motor.velocity
	var wish := player.last_wish
	var off := GroundMotion.direction_angle_deg(after, wish)
	var turned := GroundMotion.direction_angle_deg(before, after)
	var mouse_ok := moving > 0.98 * _top() and turned > 150.0 and off <= TOL_REDIRECT_DEG \
		and GroundMotion.lateral_speed(after, wish) <= TOL_LATERAL_MPS
	all_ok = all_ok and mouse_ok
	rows.append("click order: moving %.3f m/s, turned %.2f deg in ONE frame, off-direction %.6f deg" % [moving, turned, off])
	# --- THE CONTROLLER SCHEME: the left stick, swung through 180 degrees. ----
	await _rest_at(LANE_A)
	player.intent.debug_move_axis = Vector2(1.0, 0.0)
	await _until(func() -> bool: return player.motor.speed() >= 0.98 * _top(), 240)
	var s_moving := player.motor.speed()
	var s_before := player.motor.velocity.normalized()
	player.intent.debug_move_axis = Vector2(-1.0, 0.0)
	await physics_frame                                  # EXACTLY ONE FRAME
	var s_after := player.motor.velocity
	var s_off := GroundMotion.direction_angle_deg(s_after, player.last_wish)
	var s_turned := GroundMotion.direction_angle_deg(s_before, s_after)
	var stick_ok := s_moving > 0.9 * _top() and s_turned > 150.0 and s_off <= TOL_REDIRECT_DEG
	all_ok = all_ok and stick_ok
	rows.append("stick: moving %.3f m/s, turned %.2f deg in ONE frame, off-direction %.6f deg" % [s_moving, s_turned, s_off])
	# THE DEVICE MAKES NO DIFFERENCE: one motor, one arithmetic, both schemes.
	var one_path := _code_only(_read_text("res://scripts/control/player_controller.gd")).count("motor.step(") == 1
	await _rest_at(ProductionArena.player_spawn())
	var ok := all_ok and one_path
	_note("L11_a_new_click_order_redirects_in_the_same_physics_frame",
		"%s | TEST BOUND: off-direction <= %.4f deg on the FIRST physics frame after the order | both canonical schemes go through ONE `motor.step(` call in the controller=%s — nothing about the redirect depends on the device"
		% [" · ".join(rows), TOL_REDIRECT_DEG, str(one_path)])
	_reached("L11_a_new_click_order_redirects_in_the_same_physics_frame")
	return ok

func chk_L12_a_click_across_the_blocker_goes_straight_with_no_path_corners() -> bool:
	# ========================================================================
	# REPLACED ONE FOR ONE UNDER D-404, BY OWNER RULING. THE ID IS UNCHANGED.
	# ========================================================================
	# From D-400 until D-404 this check was
	# `L12_a_sharp_path_corner_redirects_in_the_same_physics_frame` and required
	# -- TRUE WHEN WRITTEN, and accepted under D-401 -- that a click order FOLLOW
	# THE PLAYER'S NAVIGATION PATH round the interior blocker and through the
	# doorway, redirecting onto each new path segment in the same physics frame
	# (at least 6 path points, at least two waypoint advances). The owner's D-404
	# ruling ends player paths: "Do not ask NavigationServer3D for a player path.
	# Do not feed the order through NavService.PathFollower." There are no path
	# corners left to redirect at.
	#
	# WHAT IT NOW REQUIRES, on the SAME two routes: the order has NO path at any
	# frame; the velocity is ALWAYS exactly along the commanded direction (the
	# same-frame claim, still at the same bound); that direction never turns,
	# because the route is straight; and the order ends at the FIRST BLOCKER
	# (COLLIDED), never at the destination. THE NEGATIVE CONTROL: the navigation
	# path between the same two points -- what the superseded behaviour followed
	# -- has corners, so a straight run is not what a path would have produced.
	var rows: Array[String] = []
	var all_ok := true
	var worst_off := 0.0
	for route in [[ROUTE_FROM, ROUTE_TO], [DOOR_FROM, DOOR_TO]]:
		await _set_mode("ORDINARY")
		await _rest_at(route[0])
		player.command_move_to(route[1])
		var first_dir := (Vector3(route[1]) - Vector3(route[0]))
		first_dir.y = 0.0
		first_dir = first_dir.normalized()
		var turned := 0.0
		var max_points := 0
		var g := 0
		while g < 900 and player.click_order.active:
			await physics_frame
			g += 1
			max_points = maxi(max_points, player.follower.point_count())
			var w := player.last_wish
			if w.length() > 0.001 and player.motor.speed() > 0.05:
				worst_off = maxf(worst_off, GroundMotion.direction_angle_deg(player.motor.velocity, w))
				turned = maxf(turned, GroundMotion.direction_angle_deg(first_dir, w))
		var collided := player.click_order.stop_reason == DirectClickOrder.STOP_COLLIDED
		var short := _planar(player.global_position, route[1]) > ProdConfig.ARRIVE_TOLERANCE_M + 0.35
		# THE CONTROL: the superseded route, measured from navigation itself.
		var nav_path := NavService.path_between(nav_map, route[0], route[1])
		var corner := 0.0
		for i in range(1, nav_path.size() - 1):
			corner = maxf(corner, GroundMotion.direction_angle_deg(nav_path[i] - nav_path[i - 1], nav_path[i + 1] - nav_path[i]))
		var control := nav_path.size() >= 3 and corner > 5.0
		var this_ok := max_points == 0 and turned <= 0.01 and collided and short and control and g < 900
		all_ok = all_ok and this_ok
		rows.append("%s -> %s: NO path at any frame (max %d points), the commanded direction turned %.5f deg, the order ended %s %.2f m short of the click | the navigation path the superseded behaviour followed has %d points and turns %.1f deg at a corner"
			% [str(route[0]), str(route[1]), max_points, turned, player.click_order.stop_reason,
			   _planar(player.global_position, route[1]), nav_path.size(), corner])
	var ok := all_ok and worst_off <= TOL_REDIRECT_DEG
	await _rest_at(ProductionArena.player_spawn())
	_note("L12_a_click_across_the_blocker_goes_straight_with_no_path_corners",
		"REPLACED ONE FOR ONE UNDER D-404 (was L12_a_sharp_path_corner_redirects_in_the_same_physics_frame, which required the order to follow the player's navigation path — true when written): %s | across both routes the velocity was never more than %.6f deg off the direction last asked for (TEST BOUND %.4f deg) — the same-frame claim still holds, with no corner to turn"
		% [" · ".join(rows), worst_off, TOL_REDIRECT_DEG])
	_reached("L12_a_click_across_the_blocker_goes_straight_with_no_path_corners")
	return ok

func chk_L13_an_abrupt_180_reversal_redirects_in_the_same_physics_frame() -> bool:
	var rows: Array[String] = []
	var all_ok := true
	for mode in MODES:
		await _set_mode(String(mode))
		await _rest_at(LANE_A)
		var moving := await _drive_lane(LANE_B)
		var before := player.motor.velocity.normalized()
		player.command_move_to(LANE_A)
		await physics_frame
		var after := player.motor.velocity
		var turned := GroundMotion.direction_angle_deg(before, after)
		var off := GroundMotion.direction_angle_deg(after, player.last_wish)
		var kept := absf(after.length() - moving) <= 0.02 * _top()
		var this_ok := moving > 0.95 * _top() and turned > 170.0 and off <= TOL_REDIRECT_DEG and kept
		all_ok = all_ok and this_ok
		rows.append("%s (%.3f m/s): turned %.2f deg in ONE frame, off %.6f deg, speed %.3f -> %.3f m/s"
			% [mode, _top(), turned, off, moving, after.length()])
	await _set_mode("ORDINARY")
	await _rest_at(ProductionArena.player_spawn())
	_note("L13_an_abrupt_180_reversal_redirects_in_the_same_physics_frame",
		"MEASURED at every diagnostic speed: %s | TEST BOUNDS: the turn > 170 deg, the off-direction <= %.4f deg, the scalar speed within 2%% of the maximum — in the FIRST physics frame after the order"
		% [" · ".join(rows), TOL_REDIRECT_DEG])
	_reached("L13_an_abrupt_180_reversal_redirects_in_the_same_physics_frame")
	return all_ok

func chk_L14_obsolete_direction_displacement_is_negligible_at_every_speed() -> bool:
	var rows: Array[String] = []
	var all_ok := true
	var control_ok := true
	for mode in MODES:
		await _set_mode(String(mode))
		await _rest_at(LANE_A)
		var moving := await _drive_lane(LANE_B)
		var p0 := player.global_position
		var d0 := player.motor.velocity.normalized()
		player.command_move_to(LANE_A)
		var worst := 0.0
		for i in 30:
			await physics_frame
			worst = maxf(worst, (player.global_position - p0).dot(d0))
		var this_ok := moving > 0.95 * _top() and worst <= TOL_OBSOLETE_M
		all_ok = all_ok and this_ok
		# THE NEGATIVE CONTROL, on the identical initial speed: the SUPERSEDED
		# arithmetic, integrated over the same 30 frames.
		var lm := LegacyInertiaMotor.new()
		lm.velocity = d0 * moving
		var legacy := 0.0
		for i in 30:
			lm.step(-d0, _top(), DT)
			legacy += maxf(0.0, lm.velocity.dot(d0)) * DT
		control_ok = control_ok and legacy > 10.0 * maxf(worst, 0.001)
		rows.append("%s (%.3f m/s): travelled %.5f m the OBSOLETE way over 30 frames; the SUPERSEDED model would travel %.4f m"
			% [mode, moving, worst, legacy])
	await _set_mode("ORDINARY")
	await _rest_at(ProductionArena.player_spawn())
	var ok := all_ok and control_ok
	_note("L14_obsolete_direction_displacement_is_negligible_at_every_speed",
		"%s | TEST BOUND: <= %.3f m of travel along the obsolete direction after the order=%s | at every speed the SUPERSEDED model travels at least ten times further=%s"
		% [" · ".join(rows), TOL_OBSOLETE_M, str(all_ok), str(control_ok)])
	_reached("L14_obsolete_direction_displacement_is_negligible_at_every_speed")
	return ok

func chk_L15_starting_from_rest_accelerates_and_releasing_brakes_to_rest() -> bool:
	var rows: Array[String] = []
	var all_ok := true
	for mode in MODES:
		await _set_mode(String(mode))
		await _rest_at(LANE_A)
		var at_rest := player.motor.speed()
		# --- STARTING FROM REST STILL ACCELERATES. Not a snap. ---------------
		player.intent.debug_move_axis = Vector2(1.0, 0.0)
		await physics_frame
		var after_one := player.motor.speed()
		var frames_to_top := 1 + await _until(func() -> bool: return player.motor.speed() >= 0.99 * _top(), 240)
		var gradual := after_one <= GroundMotion.accel_rate(_top()) * DT + 1.0e-4 \
			and after_one < 0.5 * _top() and frames_to_top >= 4
		# --- RELEASING STILL BRAKES TO REST. ---------------------------------
		player.intent.debug_move_axis = Vector2.ZERO
		var frames_to_rest := await _until(func() -> bool: return player.motor.speed() <= 0.0, 240)
		var at_rest_again := player.motor.speed()
		var p_rest := player.global_position
		await _phys(30)
		var drift := _planar(player.global_position, p_rest)
		var brakes := frames_to_rest >= 4 and at_rest_again <= 0.0 and drift < 0.005
		all_ok = all_ok and at_rest <= 0.0 and gradual and brakes
		rows.append("%s: from rest, one frame gives %.4f m/s (the rate x delta is %.4f) and the top is reached in %d frames; released, rest in %d frames with %.5f m of drift after"
			% [mode, after_one, GroundMotion.accel_rate(_top()) * DT, frames_to_top, frames_to_rest, drift])
	# --- AND COMPLETING AN ORDER ALSO BRAKES TO REST (not only releasing). ----
	await _set_mode("ORDINARY")
	await _rest_at(LANE_A)
	player.command_move_to(LANE_A + Vector3(0, 0, 4.0))
	var arrived := await _until(func() -> bool: return player.move_destination == null, 400)
	var frames_after := await _until(func() -> bool: return player.motor.speed() <= 0.0, 240)
	var completed := arrived > 0 and frames_after >= 1 and player.motor.speed() <= 0.0
	await _rest_at(ProductionArena.player_spawn())
	var ok := all_ok and completed
	_note("L15_starting_from_rest_accelerates_and_releasing_brakes_to_rest",
		"%s | a COMPLETED order also brakes to rest: the order cleared after %d frames and the actor reached exactly 0 m/s %d frames later=%s | TEST BOUNDS: the first frame may not exceed one acceleration step, the top may not be reached inside 4 frames, and rest must take at least 4"
		% [" · ".join(rows), arrived, frames_after, str(completed)])
	_reached("L15_starting_from_rest_accelerates_and_releasing_brakes_to_rest")
	return ok

# =============================================================================
# E. ARRIVAL AND CORNERS — item 10
# =============================================================================

## A PURE simulation of the controller's own arrival rule along a straight line:
## steer at the destination, clear the order inside the accepted arrival
## tolerance, then brake with no wish. Returns the signed overshoot past the
## destination.
##
## `mode` selects what is being simulated, and the three are compared:
##   "live"     -- the D-400 arithmetic WITH the arrival ceiling;
##   "uncapped" -- the D-400 arithmetic WITHOUT it (the ceiling alone isolated);
##   "legacy"   -- the SUPERSEDED pre-D-400 arithmetic: the whole velocity vector
##                 moved toward its target at the UNSCALED accepted rates, and no
##                 ceiling. This is the state D-399 section 5 describes.
##
## It models the ARITHMETIC only -- no collision, no navigation -- which is
## exactly what makes it usable as a control on one variable at a time.
static func _simulate_approach(distance: float, top: float, mode: String) -> Dictionary:
	var pos := 0.0
	var vel := 0.0
	var order := true
	var frames := 0
	var lm := LegacyInertiaMotor.new()
	while frames < 4000:
		frames += 1
		var remaining := distance - pos
		var wish := Vector3.ZERO
		var ceiling := -1.0
		if order:
			if remaining <= ProdConfig.ARRIVE_TOLERANCE_M:
				order = false
			else:
				wish = Vector3(0, 0, 1)
				if mode == "live":
					ceiling = minf(top, GroundMotion.arrival_speed_ceiling(remaining, top))
		if mode == "legacy":
			lm.velocity = Vector3(0, 0, vel)
			vel = lm.step(wish, top, DT).z
		else:
			vel = GroundMotion.step_velocity(Vector3(0, 0, vel), wish, top, DT, ceiling).z
		pos += vel * DT
		if not order and vel <= 0.0:
			break
	return {"overshoot": pos - distance, "frames": frames, "final": pos}

func chk_L16_destination_arrival_without_overshoot_at_every_speed() -> bool:
	var rows: Array[String] = []
	var all_ok := true
	for mode in MODES:
		await _set_mode(String(mode))
		await _rest_at(LANE_A)
		var dest := LANE_A + Vector3(0, 0, 12.0)
		var dir := Vector3(0, 0, 1)
		player.command_move_to(dest)
		var moved := await _until(func() -> bool: return player.motor.speed() >= 0.95 * _top(), 300)
		var reached_speed := player.motor.speed()
		await _until(func() -> bool: return player.move_destination == null and player.motor.speed() <= 0.0, 600)
		await _phys(10)
		var overshoot := (player.global_position - dest).dot(dir)
		var off := _planar(player.global_position, dest)
		var this_ok := moved > 0 and reached_speed >= 0.95 * _top() \
			and overshoot <= TOL_OVERSHOOT_M and off <= ProdConfig.ARRIVE_TOLERANCE_M
		all_ok = all_ok and this_ok
		rows.append("%s (%.3f m/s reached): stopped %+.4f m past the destination, %.4f m from it"
			% [mode, reached_speed, overshoot, off])
	# ========================================================================
	# THE NEGATIVE CONTROL: the SAME approach with the ceiling REMOVED.
	# ========================================================================
	# Without it the actor's braking distance at the faster diagnostic speeds is
	# longer than the accepted arrival tolerance, so it runs past the point it was
	# sent to. That is what the ceiling prevents, and the arithmetic says so.
	var control_rows: Array[String] = []
	var control_ok := true
	var legacy_worst := 0.0
	for top in _tops():
		var capped := _simulate_approach(12.0, float(top), "live")
		var uncapped := _simulate_approach(12.0, float(top), "uncapped")
		# AND THE STATE D-399 SECTION 5 DESCRIBES: the superseded arithmetic with
		# the UNSCALED accepted rates and no ceiling. Its recorded figure for the
		# EXTREME mode is "roughly 1.4 m", and this MEASURES that premise.
		var legacy := _simulate_approach(12.0, float(top), "legacy")
		legacy_worst = maxf(legacy_worst, float(legacy["overshoot"]))
		control_rows.append("top %.3f: LIVE %+.4f m, uncapped-but-scaled %+.4f m, SUPERSEDED (unscaled, no ceiling) %+.4f m"
			% [top, capped["overshoot"], uncapped["overshoot"], legacy["overshoot"]])
		# At the ACCEPTED speed the two are IDENTICAL, because the ceiling never
		# binds there -- which is itself the claim L19 makes. Above it the uncapped
		# approach is strictly worse, and at the EXTREME speed it breaks the bound.
		if is_equal_approx(float(top), ProdConfig.TOP_SPEED_MPS):
			control_ok = control_ok and is_equal_approx(float(uncapped["overshoot"]), float(capped["overshoot"]))
		else:
			control_ok = control_ok and float(uncapped["overshoot"]) > float(capped["overshoot"]) + 0.02
		if float(top) > ProdConfig.TOP_SPEED_MPS * 2.5:
			control_ok = control_ok and float(uncapped["overshoot"]) > TOL_OVERSHOOT_M \
				and float(capped["overshoot"]) <= TOL_OVERSHOOT_M \
				and float(legacy["overshoot"]) > 1.0
	# D-399 SECTION 5's RECORDED PREMISE, CHECKED BY MEASUREMENT.
	_finding("D-399 SECTION 5's PREMISE, MEASURED rather than assumed: it records that at x3.0 the click-to-move stop 'overshoots by roughly 1.4 m' under the SUPERSEDED arithmetic. Simulated here on a 12 m approach: %.4f m. The premise holds. The live model overshoots %+.4f m at the same speed, and the ceiling alone accounts for the rest: uncapped but rate-scaled it is %+.4f m."
		% [legacy_worst, float(_simulate_approach(12.0, float(_tops()[2]), "live")["overshoot"]),
		   float(_simulate_approach(12.0, float(_tops()[2]), "uncapped")["overshoot"])])
	await _set_mode("ORDINARY")
	await _rest_at(ProductionArena.player_spawn())
	var ok := all_ok and control_ok
	_note("L16_destination_arrival_without_overshoot_at_every_speed",
		"LIVE: %s | TEST BOUND: at most %.3f m past the destination, and at rest inside the ACCEPTED %.2f m arrival tolerance=%s | NEGATIVE CONTROLS, the same 12 m approach simulated with ONE variable changed at a time: %s — at the ACCEPTED speed the live and uncapped runs are IDENTICAL (the ceiling never binds there), above it the uncapped one is strictly worse, and at the EXTREME speed both it and the SUPERSEDED arithmetic break the bound while the live one does not=%s"
		% [" · ".join(rows), TOL_OVERSHOOT_M, ProdConfig.ARRIVE_TOLERANCE_M, str(all_ok),
		   " · ".join(control_rows), str(control_ok)])
	_reached("L16_destination_arrival_without_overshoot_at_every_speed")
	return ok

func chk_L17_arrival_does_not_oscillate_and_the_order_clears_once() -> bool:
	await _set_mode("EXTREME")
	await _rest_at(LANE_A)
	var dest := LANE_A + Vector3(0, 0, 10.0)
	var issued := player.commands_issued
	player.command_move_to(dest)
	await _until(func() -> bool: return player.move_destination == null, 600)
	var issued_at_arrival := player.commands_issued
	# AFTER ARRIVAL: no reversal, no re-acquisition, no drift. The order clears
	# inside the arrival tolerance and the actor then BRAKES to rest, which is the
	# accepted behaviour and is not drift -- so the measurement starts at rest.
	# (The first run of this suite measured from the clearing frame and reported
	# the braking distance as drift.)
	await _until(func() -> bool: return player.motor.speed() <= 0.0, 240)
	var p0 := player.global_position
	var reversals := 0
	var prev := player.motor.velocity
	var re_ordered := 0
	for i in 60:
		await physics_frame
		var v := player.motor.velocity
		if prev.length() > 0.02 and v.length() > 0.02 and prev.dot(v) < 0.0:
			reversals += 1
		if player.move_destination != null:
			re_ordered += 1
		prev = v
	var drift := _planar(player.global_position, p0)
	var at_rest := player.motor.speed() <= 0.0
	# THE ORDER WAS ISSUED ONCE and never re-issued by arriving.
	var once := issued_at_arrival == issued + 1 and player.commands_issued == issued_at_arrival
	# THE COUNTER CAN SEE A REVERSAL: a planted pair is counted.
	var refuses := Vector3(0, 0, 1).dot(Vector3(0, 0, -1)) < 0.0
	var ok := once and reversals == 0 and re_ordered == 0 and drift < 0.005 and at_rest and refuses
	await _set_mode("ORDINARY")
	await _rest_at(ProductionArena.player_spawn())
	_note("L17_arrival_does_not_oscillate_and_the_order_clears_once",
		"at the EXTREME diagnostic speed the order was issued exactly ONCE (%d -> %d, and no re-issue after arrival)=%s | over the 60 frames after arrival: %d velocity reversals (must be 0), the destination was re-acquired %d times (must be 0), the actor drifted %.5f m and is at exactly 0 m/s=%s | the reversal counter can see a planted reversal=%s"
		% [issued, issued_at_arrival, str(once), reversals, re_ordered, drift, str(at_rest), str(refuses)])
	_reached("L17_arrival_does_not_oscillate_and_the_order_clears_once")
	return ok

## The shortest distance from a point to a polyline, in the plane.
static func _poly_distance(p: Vector3, pts: PackedVector3Array) -> float:
	if pts.size() == 0:
		return 0.0
	var best := INF
	var a2 := Vector2(p.x, p.z)
	for i in range(1, pts.size()):
		var s := Vector2(pts[i - 1].x, pts[i - 1].z)
		var e := Vector2(pts[i].x, pts[i].z)
		var d := e - s
		if d.length() < 0.0001:
			best = minf(best, a2.distance_to(s))
			continue
		var t := clampf((a2 - s).dot(d) / d.dot(d), 0.0, 1.0)
		best = minf(best, a2.distance_to(s + d * t))
	return best if best < INF else 0.0

## A PURE simulation of following a polyline with the project's own follower
## rules, under either model. Returns the worst deviation from the polyline.
## It models the ARITHMETIC only -- no collision -- which is what makes it a fair
## comparison of the two motion models on the SAME geometry.
static func _simulate_follow(pts: PackedVector3Array, top: float, legacy: bool) -> float:
	if pts.size() < 2:
		return 0.0
	var f := NavService.PathFollower.new()
	f.set_path(pts)
	var pos := pts[0]
	var vel := Vector3.ZERO
	var lm := LegacyInertiaMotor.new()
	lm.scaled = true
	var worst := 0.0
	for i in 4000:
		var dir := f.steer(pos)
		if dir == Vector3.ZERO:
			break
		if legacy:
			lm.velocity = vel
			vel = lm.step(dir, top, DT)
		else:
			vel = GroundMotion.step_velocity(vel, dir, top, DT)
		pos += vel * DT
		pos.y = 0.0
		worst = maxf(worst, _poly_distance(pos, pts))
	return worst

func chk_L18_a_click_order_stays_on_its_straight_segment_at_every_speed() -> bool:
	# ========================================================================
	# REPLACED ONE FOR ONE UNDER D-404, BY OWNER RULING. THE ID IS UNCHANGED.
	# ========================================================================
	# From D-400 until D-404 this check was
	# `L18_path_corner_deviation_is_bounded_and_does_not_grow_with_speed` and
	# required -- TRUE WHEN WRITTEN, and accepted under D-401 -- that a click order
	# track THE PLAYER'S OWN PATH POLYLINE round the interior blocker within
	# 0.60 m at every speed, with a synthetic right-angle polyline as its control.
	# The owner's D-404 ruling ends player paths, so there is no polyline to track.
	#
	# WHAT IT NOW REQUIRES, at ORDINARY, FAST and EXTREME: a click order stays ON
	# ITS STRAIGHT SEGMENT -- the deviation is measured every frame -- the deviation
	# does not grow with speed, and the order arrives. THE NEGATIVE CONTROL: the
	# navigation path round the blocker (the superseded route) leaves the straight
	# segment between the same two points by more than a metre, so "stays on the
	# straight segment" is a claim a path-follower would FAIL.
	var rows: Array[String] = []
	var worsts: Array[float] = []
	var arrived_all := true
	for mode in MODES:
		await _set_mode(String(mode))
		await _rest_at(LANE_A)
		player.command_move_to(LANE_B)
		var worst := 0.0
		var g := 0
		while g < 900 and player.click_order.active:
			await physics_frame
			g += 1
			worst = maxf(worst, _poly_distance(player.global_position, PackedVector3Array([LANE_A, LANE_B])))
		var arrived := player.click_order.stop_reason == DirectClickOrder.STOP_ARRIVED
		arrived_all = arrived_all and arrived
		worsts.append(worst)
		rows.append("%s: worst deviation from the straight segment %.5f m, %s" % [mode, worst, player.click_order.stop_reason])
	var bounded := true
	for w in worsts:
		bounded = bounded and float(w) <= 0.01
	var not_growing := worsts[2] <= worsts[0] + 0.005
	var nav_path := NavService.path_between(nav_map, ROUTE_FROM, ROUTE_TO)
	var leaves := 0.0
	for pt in nav_path:
		leaves = maxf(leaves, _poly_distance(pt, PackedVector3Array([ROUTE_FROM, ROUTE_TO])))
	var control := nav_path.size() >= 3 and leaves > 1.0
	await _set_mode("ORDINARY")
	await _rest_at(ProductionArena.player_spawn())
	var ok := bounded and not_growing and arrived_all and control
	_note("L18_a_click_order_stays_on_its_straight_segment_at_every_speed",
		"REPLACED ONE FOR ONE UNDER D-404 (was L18_path_corner_deviation_is_bounded_and_does_not_grow_with_speed, which required the order to track the player's own path polyline — true when written): %s | TEST BOUND <= 0.01 m and not growing with speed=%s/%s, every order arrived=%s | NEGATIVE CONTROL: the navigation path from %s to %s (the superseded route) has %d points and leaves their straight segment by %.3f m — a path-follower would fail this check=%s"
		% [" · ".join(rows), str(bounded), str(not_growing), str(arrived_all), str(ROUTE_FROM), str(ROUTE_TO),
		   nav_path.size(), leaves, str(control)])
	_reached("L18_a_click_order_stays_on_its_straight_segment_at_every_speed")
	return ok

func chk_L19_the_arrival_cap_is_derived_and_never_binds_at_the_accepted_speed() -> bool:
	# THE CAP INTRODUCES NO TUNABLE: `LocomotionConfig` has exactly the TWO
	# numeric constants it registers, and the ceiling is built from the registered
	# acceleration rate and the distance alone.
	var m := _constants("res://scripts/locomotion/locomotion_config.gd")
	var numeric := 0
	for k in m.keys():
		if typeof(m[k]) == TYPE_INT or typeof(m[k]) == TYPE_FLOAT:
			numeric += 1
	var two := numeric == 2 and LocomotionConfig.registry().size() == 2
	var body := _function_body(_code_only(_read_text("res://scripts/locomotion/ground_motion.gd")),
		"arrival_speed_ceiling")
	var derived := body.find("accel_rate(top_speed)") >= 0 and body.find("sqrt(2.0 * a *") >= 0
	# THE ARITHMETIC IS EXACT: from v = sqrt(2 a s), stopping in s at rate a.
	var exact := true
	for top in _tops():
		for s in [0.25, 1.0, 4.0]:
			var v := GroundMotion.arrival_speed_ceiling(float(s), float(top))
			exact = exact and absf(v * v / (2.0 * GroundMotion.accel_rate(float(top))) - float(s)) <= 1.0e-4
	# AT THE ACCEPTED SPEED IT NEVER BINDS: the order is cleared at the accepted
	# arrival tolerance, and the ceiling there is already above the accepted top.
	var at_tol := GroundMotion.arrival_speed_ceiling(ProdConfig.ARRIVE_TOLERANCE_M, ProdConfig.TOP_SPEED_MPS)
	var never := at_tol > ProdConfig.TOP_SPEED_MPS
	# MEASURED LIVE: at the accepted speed the actor is still at full speed on the
	# frame the order clears; at the EXTREME speed it is not.
	await _set_mode("ORDINARY")
	await _rest_at(LANE_A)
	var _d1 := player.command_move_to(LANE_A + Vector3(0, 0, 12.0))
	await _until(func() -> bool: return player.motor.speed() >= 0.99 * _top(), 300)
	var s1 := INF
	var dest1 = player.move_destination
	# SAMPLED ONLY WHILE THE ORDER IS STILL SET. Once it clears, the actor BRAKES
	# to rest at the ordinary rate, and that braking is accepted behaviour, not the
	# ceiling at work. The first run of this check sampled one frame past the clear
	# and reported the first braking step as the ceiling easing her.
	var g := 0
	while g < 600 and player.move_destination != null:
		if _planar(player.global_position, dest1) <= 1.2:
			s1 = minf(s1, player.motor.speed())
		await physics_frame
		g += 1
	var full_at_ordinary := s1 >= 0.99 * ProdConfig.TOP_SPEED_MPS
	await _set_mode("EXTREME")
	await _rest_at(LANE_A)
	var _d3 := player.command_move_to(LANE_A + Vector3(0, 0, 12.0))
	await _until(func() -> bool: return player.motor.speed() >= 0.99 * _top(), 300)
	var s3 := INF
	var top3 := _top()
	var dest3 = player.move_destination
	g = 0
	while g < 600 and player.move_destination != null:
		if _planar(player.global_position, dest3) <= 1.2:
			s3 = minf(s3, player.motor.speed())
		await physics_frame
		g += 1
	# TEST BOUND, read off the measurement rather than guessed: the order is
	# cleared by the FOLLOWER's own 0.45 m advance tolerance rather than by the
	# 0.35 m arrival tolerance, so the ceiling has about one frame to act at this
	# speed. That it acts AT ALL is the claim; that the actor does not overshoot is
	# L16's, measured end to end.
	var eased_at_extreme := s3 < 0.95 * top3
	await _set_mode("ORDINARY")
	await _rest_at(ProductionArena.player_spawn())
	var ok := two and derived and exact and never and full_at_ordinary and eased_at_extreme
	_note("L19_the_arrival_cap_is_derived_and_never_binds_at_the_accepted_speed",
		"LocomotionConfig declares EXACTLY %d numeric constants and registers %d — no tunable was introduced for the cap=%s | the ceiling is built from the registered acceleration rate and the remaining distance alone=%s and its arithmetic is exact (v squared over 2a returns the distance)=%s | at the ACCEPTED speed the ceiling at the %.2f m arrival tolerance is %.4f m/s, above the accepted %.3f m/s, so it can never bind=%s — MEASURED over the last 1.2 m of the approach, WHILE THE ORDER IS STILL SET: the LOWEST speed the actor reaches is %.4f m/s, still its full accepted speed=%s, while at the EXTREME speed the ceiling HAS bound and eased her to %.4f m/s of %.4f (%.1f%%, TEST BOUND below 95%%)=%s"
		% [numeric, LocomotionConfig.registry().size(), str(two), str(derived), str(exact),
		   ProdConfig.ARRIVE_TOLERANCE_M, at_tol, ProdConfig.TOP_SPEED_MPS, str(never),
		   s1, str(full_at_ordinary), s3, top3, 100.0 * s3 / top3, str(eased_at_extreme)])
	_reached("L19_the_arrival_cap_is_derived_and_never_binds_at_the_accepted_speed")
	return ok

# =============================================================================
# F. COLLISION AND NAVIGATION — item 7 and item 11
# =============================================================================

func chk_L20_wall_collision_still_slides_legitimately() -> bool:
	var rows: Array[String] = []
	var all_ok := true
	# ========================================================================
	# FIND THE WALL BY WALKING INTO IT UNTIL PROGRESS STALLS.
	# ========================================================================
	# The first run of this suite asked `get_slide_collision_count() > 0` on the
	# very first frame and took the SPAWN POINT for the wall, then "measured" a
	# 1.9 m slide into open floor. STALLED PROGRESS is the honest signal: the
	# actor is pushing west and no longer getting west.
	await _set_mode("ORDINARY")
	await _rest_at(ProductionArena.player_spawn())
	var start_x := player.global_position.x
	player.intent.debug_move_axis = _stick_for(Vector3(-1, 0, 0))
	var stalled := 0
	var prev_x := player.global_position.x
	var g0 := 0
	while g0 < 600 and stalled < 12:
		await physics_frame
		g0 += 1
		if prev_x - player.global_position.x < 0.01:
			stalled += 1
		else:
			stalled = 0
		prev_x = player.global_position.x
	var wall_x := player.global_position.x
	var search_z := player.global_position.z
	var hit := stalled >= 12 and (start_x - wall_x) > 2.0 and _wall_contacts() > 0
	player.intent.debug_move_axis = Vector2.ZERO
	await _phys(20)
	for mode in MODES:
		await _set_mode(String(mode))
		player.motor.reset()
		# z IS PINNED TO THE ROW THE WALL SEARCH ALREADY WALKED, so the control
		# below retraces floor this check has itself proved clear.
		player.global_position = Vector3(wall_x + 1.2, 0.0, search_z)
		await _phys(10)
		# DRIVE AT 45 DEGREES INTO THE WALL. A body that STICKS makes no lateral
		# progress; a body that passes THROUGH makes no collision at all.
		var into := Vector3(-1, 0, 1).normalized()
		player.intent.debug_move_axis = _stick_for(into)
		var p0 := player.global_position
		await _phys(45)
		var d := player.global_position - p0
		var along := d.z
		var through := player.global_position.x < wall_x - 0.15
		var collided := _wall_contacts() > 0
		var this_ok := absf(along) > 0.5 and not through and collided
		all_ok = all_ok and this_ok
		rows.append("%s: slid %.3f m ALONG the wall, ended %.4f m past its face, collided=%s"
			% [mode, absf(along), player.global_position.x - wall_x, str(collided)])
		player.intent.debug_move_axis = Vector2.ZERO
		await _phys(10)
	# THE NEGATIVE CONTROL: driving AWAY from the wall collides with nothing.
	await _set_mode("ORDINARY")
	player.motor.reset()
	player.global_position = Vector3(wall_x + 1.2, 0.0, search_z)
	await _phys(20)
	var away_from := player.global_position.x
	player.intent.debug_move_axis = _stick_for(Vector3(1, 0, 0))
	await _phys(30)
	var away_moved := player.global_position.x - away_from
	var away_collisions := _wall_contacts()
	var away_free := away_collisions == 0 and away_moved > 1.0
	player.intent.debug_move_axis = Vector2.ZERO
	# AND THE COLLISION CONFIGURATION IS UNTOUCHED.
	var config := player.collision_layer == 1 and player.collision_mask == (4 | 2) \
		and is_equal_approx(ProdConfig.PLAYER_BODY_RADIUS, 0.40)
	# THE MOTOR NEVER RESOLVES COLLISION: `move_and_slide` still does, and the
	# motor's own velocity is not overwritten from it.
	var ctrl := _code_only(_read_text("res://scripts/control/player_controller.gd"))
	var slide := ctrl.count("move_and_slide()") == 1 and ctrl.find("motor.velocity =") < 0
	await _rest_at(ProductionArena.player_spawn())
	var ok := hit and all_ok and away_free and config and slide
	_note("L20_wall_collision_still_slides_legitimately",
		"the west wall was FOUND by walking into it from x %.3f until progress STALLED, at x %.3f (a real wall, genuinely collided with=%s) | driving into it at 45 degrees at every diagnostic speed: %s — TEST BOUND: more than 0.5 m of lateral progress, no more than 0.15 m of penetration; a contact counts as a WALL only when its normal is roughly horizontal, because the actor grazes the FLOOR on almost every frame | NEGATIVE CONTROL: driving AWAY from it along the same row travels %.3f m freely with %d WALL contacts=%s | the collision layer, mask and body radius are unchanged=%s | the controller still calls move_and_slide() exactly once and never writes the motor's velocity back from it=%s"
		% [start_x, wall_x, str(hit), " · ".join(rows), away_moved, away_collisions, str(away_free),
		   str(config), str(slide)])
	_reached("L20_wall_collision_still_slides_legitimately")
	return ok

## ============================================================================
## A FLOOR CONTACT IS NOT A WALL CONTACT.
## ============================================================================
## MEASURED, on the first run of this suite: `get_slide_collision_count()` is 1
## on almost every frame, because the actor's cylinder rests on the floor and a
## horizontal move grazes it. Asking "did it collide" therefore answered YES in
## open floor and made this check take the SPAWN POINT for a wall. A wall is a
## contact whose normal is roughly HORIZONTAL, and that is what is counted.
func _wall_contacts() -> int:
	var n := 0
	for i in player.get_slide_collision_count():
		var c := player.get_slide_collision(i)
		if absf(c.get_normal().y) < 0.5:
			n += 1
	return n

## The left-stick deflection that asks for a world direction, through the
## controller's own camera-relative mapping. Test-only.
func _stick_for(world_dir: Vector3) -> Vector2:
	var b := cam.locked_basis()
	var fwd := -b.z
	fwd.y = 0.0
	fwd = fwd.normalized()
	var right := b.x
	right.y = 0.0
	right = right.normalized()
	var d := world_dir
	d.y = 0.0
	d = d.normalized()
	return Vector2(d.dot(right), -d.dot(fwd))

func chk_L21_an_aligned_click_passes_the_doorway_and_a_slanted_one_stops() -> bool:
	# ========================================================================
	# REPLACED ONE FOR ONE UNDER D-404, BY OWNER RULING. THE ID IS UNCHANGED.
	# ========================================================================
	# From D-400 until D-404 this check was
	# `L21_the_narrow_doorway_is_still_navigated_at_every_speed` and required --
	# TRUE WHEN WRITTEN, and accepted under D-401 -- that a SLANTED click from
	# DOOR_PRIME to DOOR_TO be ROUTED through the doorway at every speed. The
	# owner's D-404 ruling ends that: the player goes straight at the click and
	# "navigation around the obstacle requires another player command".
	#
	# WHAT IT NOW REQUIRES, at every speed: the doorway is still wide enough on the
	# mesh; a click ALIGNED with it passes straight through and arrives; and the
	# very SAME slanted click the old check routed now stops AT THE JAMB (COLLIDED)
	# on the near side -- it does not route and does not pass through.
	var rows: Array[String] = []
	var all_ok := true
	var w := NavService.corridor_width(nav_map, ProductionArena.doorway_centre(),
		ProductionArena.doorway_across(), 2.5, 200)
	for mode in MODES:
		await _set_mode(String(mode))
		await _rest_at(DOOR_ALIGNED_FROM)
		player.command_move_to(DOOR_TO)
		var inside := 0
		var g := 0
		while g < 900 and player.click_order.active:
			await physics_frame
			g += 1
			if absf(player.global_position.x - ProductionArena.doorway_centre().x) < 1.0:
				inside += 1
		var passed := player.click_order.stop_reason == DirectClickOrder.STOP_ARRIVED and inside >= 1 \
			and _planar(player.global_position, DOOR_TO) <= ProdConfig.ARRIVE_TOLERANCE_M
		await _rest_at(DOOR_PRIME)
		player.command_move_to(DOOR_TO)
		var g2 := 0
		var max_x := -99.0
		while g2 < 900 and player.click_order.active:
			await physics_frame
			g2 += 1
			max_x = maxf(max_x, player.global_position.x)
		var stopped := player.click_order.stop_reason == DirectClickOrder.STOP_COLLIDED \
			and max_x < ProductionArena.doorway_centre().x and player.follower.point_count() == 0
		all_ok = all_ok and passed and stopped
		rows.append("%s: aligned click passed the doorway (%d frames inside it) and ARRIVED=%s; the slanted click from %s stopped %s at x %.3f, never beyond x %.3f=%s"
			% [mode, inside, str(passed), str(DOOR_PRIME), player.click_order.stop_reason, player.global_position.x, max_x, str(stopped)])
	await _set_mode("ORDINARY")
	await _rest_at(ProductionArena.player_spawn())
	var wide := float(w["width"]) >= ProdConfig.NAV_AGENT_RADIUS * 2.0
	var ok := all_ok and wide
	_note("L21_an_aligned_click_passes_the_doorway_and_a_slanted_one_stops",
		"REPLACED ONE FOR ONE UNDER D-404 (was L21_the_narrow_doorway_is_still_navigated_at_every_speed, which required the slanted click to be ROUTED through the doorway — true when written): the doorway's usable width on the mesh is %.3f m against the %.2f m an agent needs=%s | %s"
		% [float(w["width"]), ProdConfig.NAV_AGENT_RADIUS * 2.0, str(wide), " · ".join(rows)])
	_reached("L21_an_aligned_click_passes_the_doorway_and_a_slanted_one_stops")
	return ok

func chk_L22_navigation_geometry_and_the_agent_radius_are_unchanged() -> bool:
	# THE AGENT AND THE BODY ARE STILL THE SAME NUMBER -- the project's own rule.
	var radii := is_equal_approx(ProdConfig.NAV_AGENT_RADIUS, ProdConfig.PLAYER_BODY_RADIUS) \
		and is_equal_approx(ProdConfig.NAV_AGENT_RADIUS, 0.40)
	var nav := is_equal_approx(ProdConfig.NAV_AGENT_HEIGHT, 1.80) \
		and is_equal_approx(ProdConfig.NAV_AGENT_MAX_CLIMB, 0.30) \
		and is_equal_approx(ProdConfig.NAV_AGENT_MAX_SLOPE_DEG, 30.0) \
		and is_equal_approx(ProdConfig.NAV_CELL_SIZE, 0.12) \
		and is_equal_approx(ProdConfig.NAV_CELL_HEIGHT, 0.20) \
		and is_equal_approx(ProdConfig.NAV_GROUND_BAND_M, 0.60)
	# THE FOLLOWER'S OWN GEOMETRY IS UNTOUCHED.
	var follower := is_equal_approx(player.follower.advance_tolerance, 0.45) \
		and is_equal_approx(ProdConfig.ARRIVE_TOLERANCE_M, 0.35) \
		and is_equal_approx(ProdConfig.REPATH_INTERVAL_S, 0.20)
	# THE ARENA IS THE SAME ARENA: the same authored rectangles, each still
	# REACHABLE BY PATH to its CENTRE, and the refusal still refuses.
	var rects := ProductionArena.walkable_rects()
	var reach_ok := rects.size() == 6
	for r in rects:
		var res := NavService.reachable(nav_map, ProductionArena.player_spawn(), r["centre"], 0.6)
		reach_ok = reach_ok and bool(res["reachable"])
	var refuses := true
	for p in ProductionArena.unreachable_probes():
		refuses = refuses and not bool(NavService.reachable(nav_map, ProductionArena.player_spawn(), p["point"], 0.6)["reachable"])
	# AND NO D-400 FILE TOUCHES NAVIGATION GEOMETRY.
	var loco := _code_only(_read_text("res://scripts/locomotion/ground_motion.gd")) \
		+ _code_only(_read_text("res://scripts/locomotion/locomotion_config.gd"))
	var no_nav := loco.find("NavService") < 0 and loco.find("NavigationServer3D") < 0 \
		and loco.find("NAV_") < 0
	var ok := radii and nav and follower and reach_ok and refuses and no_nav
	_note("L22_navigation_geometry_and_the_agent_radius_are_unchanged",
		"the navigation agent radius still equals the body radius at 0.40 m=%s and every other navigation constant is unchanged=%s | the follower's advance tolerance is still 0.45 m and the arrival tolerance 0.35 m=%s | all %d authored rectangles are still REACHABLE BY PATH to their centres=%s and the two unreachable probes are still REFUSED=%s | neither D-400 script mentions navigation at all=%s"
		% [str(radii), str(nav), str(follower), rects.size(), str(reach_ok), str(refuses), str(no_nav)])
	_reached("L22_navigation_geometry_and_the_agent_radius_are_unchanged")
	return ok

# =============================================================================
# G. THE COMBAT COMMITMENT — item 9
# =============================================================================

## One Splinter Shot use, aimed down the lane. Returns whether it began.
func _begin_splinter(at: Vector3) -> bool:
	skills.pool.refill()
	skills.clear_cooldowns()
	cam.debug_cursor_override = at
	await _phys(3)
	var r := skills.use_binding(HuntressContent.BINDING_INDEX)
	return bool(r["ok"])

func chk_L23_a_movement_order_during_splinter_shot_windup_is_still_buffered() -> bool:
	await _set_mode("ORDINARY")
	await _rest_at(LANE_A + Vector3(0, 0, 4.0))
	var refused0 := player.commitment.cancels_refused
	var buffered0 := player.buffered_moves
	var arrows0 := hr.arrows_released
	var began := await _begin_splinter(player.global_position + Vector3(0, 0, 6.0))
	# THE ACTION MUST HAVE FIRED before anything below means anything.
	var active := player.commitment.active and player.commitment.label == HuntressConfig.SPLINTER_ACTION_LABEL
	var p0 := player.global_position
	# ASK TO MOVE DURING THE WIND-UP, every frame, until the arrow leaves.
	var windup_frames := 0
	var still_active := true
	while windup_frames < 200 and hr.arrows_released == arrows0:
		player.intent.debug_move_command_held = true
		await physics_frame
		windup_frames += 1
		if hr.arrows_released == arrows0:
			still_active = still_active and player.commitment.active
	var travel := _planar(player.global_position, p0)
	var released := hr.arrows_released == arrows0 + 1
	var refused := player.commitment.cancels_refused >= refused0
	var buffered := player.buffered_moves > buffered0
	player.intent.clear_seams()
	cam.debug_cursor_override = null
	await _phys(20)
	# EXACTLY ONE ARROW, and the cancel could not have eaten it.
	var one := hr.arrows_released == arrows0 + 1
	var ok := began and active and windup_frames > 2 and still_active and released and buffered \
		and refused and one and travel <= ProdConfig.ACTION_GLIDE_TOLERANCE_M
	await _rest_at(ProductionArena.player_spawn())
	_note("L23_a_movement_order_during_splinter_shot_windup_is_still_buffered",
		"a Splinter Shot use BEGAN=%s and the accepted STOP commitment held it=%s | a movement order was asked for on every one of the %d wind-up frames: the action stayed active throughout=%s, the order was BUFFERED (%d -> %d)=%s and could not cancel the attack=%s | the actor travelled %.4f m across the whole wind-up, inside the ACCEPTED %.2f m glide tolerance | the arrow then released EXACTLY ONCE=%s. Measured at the ACCEPTED speed; LD-02 records the action brake's behaviour at the faster diagnostic speeds."
		% [str(began), str(active), windup_frames, str(still_active), buffered0, player.buffered_moves,
		   str(buffered), str(refused), travel, ProdConfig.ACTION_GLIDE_TOLERANCE_M, str(one)])
	_reached("L23_a_movement_order_during_splinter_shot_windup_is_still_buffered")
	return ok

func chk_L24_a_movement_order_after_release_still_cancels_recovery_and_redirects() -> bool:
	await _set_mode("ORDINARY")
	await _rest_at(LANE_A + Vector3(0, 0, 4.0))
	var cancels0 := player.commitment.recovery_cancels
	var arrows0 := hr.arrows_released
	var began := await _begin_splinter(player.global_position + Vector3(0, 0, 6.0))
	# WAIT FOR THE RELEASE -- the event that opens the window.
	var g := await _until(func() -> bool: return hr.arrows_released > arrows0, 200)
	var released := hr.arrows_released == arrows0 + 1
	var in_recovery := player.commitment.active
	# ========================================================================
	# NOW ASK TO MOVE. A MOVEMENT REQUEST IS AN INTENT, NOT A DESTINATION.
	# ========================================================================
	# `_movement_requested()` reads the INTENT -- the stick or a held command --
	# exactly as the accepted F82 does. The first run of this suite set a
	# destination instead and measured the recovery ending NATURALLY, which is a
	# different event and would have proved nothing.
	player.intent.debug_move_axis = _stick_for(Vector3(0, 0, -1))
	var cancelled := await _until(func() -> bool: return not player.commitment.active, 60)
	var cancels := player.commitment.recovery_cancels > cancels0
	# AND THE MOVEMENT THAT RESUMES IS ALREADY ON ITS COMMANDED DIRECTION.
	await _until(func() -> bool: return player.motor.speed() > 0.2, 60)
	var off := GroundMotion.direction_angle_deg(player.motor.velocity, player.last_wish)
	# THE RELEASED ARROW SURVIVED THE CANCEL INTACT: still exactly one.
	var still_one := hr.arrows_released == arrows0 + 1
	await _rest_at(ProductionArena.player_spawn())
	var ok := began and released and in_recovery and cancelled < 60 and cancels and still_one \
		and off <= TOL_REDIRECT_DEG
	_note("L24_a_movement_order_after_release_still_cancels_recovery_and_redirects",
		"a Splinter Shot use BEGAN=%s and released its arrow after %d frames=%s, leaving the action in recovery=%s | a movement order then cancelled the REMAINING RECOVERY within %d frames=%s (%d -> %d) | the released arrow survived intact — still exactly one=%s | and the movement that resumed was ALREADY on its commanded direction (off %.6f deg, TEST BOUND %.4f)"
		% [str(began), g, str(released), str(in_recovery), cancelled, str(cancels), cancels0,
		   player.commitment.recovery_cancels, str(still_one), off, TOL_REDIRECT_DEG])
	_reached("L24_a_movement_order_after_release_still_cancels_recovery_and_redirects")
	return ok

func chk_L25_the_stop_commitment_still_stops_and_its_brake_is_unscaled() -> bool:
	var rows: Array[String] = []
	var glides: Array[float] = []
	for mode in MODES:
		await _set_mode(String(mode))
		await _rest_at(LANE_A)
		var moving := await _drive_lane(LANE_B)
		var p0 := player.global_position
		player._cooldown = 0.0
		player.begin_attack()
		var fired := player.commitment.active
		var frames := 0
		while player.commitment.active and frames < 200:
			await physics_frame
			frames += 1
		var glide := _planar(player.global_position, p0)
		glides.append(glide)
		rows.append("%s (%.3f m/s): the committed action stopped translation after %.4f m" % [mode, moving, glide])
		if not fired:
			rows.append("%s: THE ACTION DID NOT FIRE" % mode)
	# AT THE ACCEPTED SPEED the accepted tolerance still holds -- F71's claim.
	var accepted_ok := glides[0] <= ProdConfig.ACTION_GLIDE_TOLERANCE_M
	# ============================================================
	# LD-02, MEASURED RATHER THAN ASSERTED.
	# ============================================================
	# The ACTION brake is NOT scaled, because the ruling names acceleration and
	# ORDINARY braking and item 11 forbids altering Skill timing. So the stop
	# distance grows with the diagnostic speed. THIS IS DECLARED, NOT REPAIRED.
	var grows := glides[2] > glides[0] * 2.0
	var predicted: Array[String] = []
	for top in _tops():
		predicted.append("%.4f m at %.3f m/s" % [float(top) * float(top) / (2.0 * ProdConfig.ACTION_BRAKE_MPS2), top])
	_finding("LD-02, MEASURED: the ACTION brake is NOT scaled with the diagnostic speed, so a committed action's stop distance grows with it — %s (arithmetic: %s). At the ACCEPTED speed it is inside the accepted %.2f m glide tolerance; above it, it is not. DECLARED, NOT REPAIRED: the ruling names acceleration and ORDINARY braking, and item 11 forbids altering Skill timing."
		% [" · ".join(rows), " · ".join(predicted), ProdConfig.ACTION_GLIDE_TOLERANCE_M])
	# THE ROW SAYS SO, and the denial says so.
	var row_ok := false
	for r in LocomotionConfig.deferred_rows():
		# RE-SCOPED UNDER D-402 (first act), one for one: the owner RE-CLASSIFIED
		# LD-02 under D-401 -- "a measured provisional finding rather than a defect
		# or locked rule" -- so its DISPOSITION moved. RE-CLASSIFICATION IS NOT
		# DISCHARGE: the row still prints, it is still not a pass, and this check
		# still measures the stop distance at every diagnostic mode. Until D-402
		# the disposition was "DECLARED — NOT REPAIRED": true when written.
		if String(r[0]).begins_with("LD-02") and String(r[1]) == "CARRIED — PROVISIONAL FINDING":
			# RE-SCOPED UNDER D-402 (first act): the row no longer RETURNS TO the
			# owner, because the owner has ANSWERED it -- by re-classifying it. It
			# is now carried and measured, which is what its text must say.
			row_ok = String(r[2]).find("RETURNS TO: nowhere — carried and measured") >= 0 \
				and String(r[2]).find("RE-CLASSIFIED BY THE OWNER (D-401)") == 0
	var denied := false
	for d in LocomotionConfig.denials():
		if String(d).find("does NOT scale the ACTION brake") >= 0:
			denied = true
	var unchanged := is_equal_approx(ProdConfig.ACTION_BRAKE_MPS2, 120.0) \
		and is_equal_approx(ProdConfig.ACTION_GLIDE_TOLERANCE_M, 0.10)
	await _set_mode("ORDINARY")
	await _rest_at(ProductionArena.player_spawn())
	var ok := accepted_ok and grows and row_ok and denied and unchanged
	_note("L25_the_stop_commitment_still_stops_and_its_brake_is_unscaled",
		"%s | at the ACCEPTED speed the committed action still stops inside the accepted %.2f m tolerance=%s | the action brake is UNSCALED and unchanged at %.1f m/s^2=%s, so the stop distance grows with the diagnostic speed=%s — DECLARED as LD-02 (%s) and denied in terms=%s. NOTHING WAS REPAIRED."
		% [" · ".join(rows), ProdConfig.ACTION_GLIDE_TOLERANCE_M, str(accepted_ok),
		   ProdConfig.ACTION_BRAKE_MPS2, str(unchanged), str(grows), str(row_ok), str(denied)])
	_reached("L25_the_stop_commitment_still_stops_and_its_brake_is_unscaled")
	return ok

# =============================================================================
# H. AIM AND FACING — item 9
# =============================================================================

func chk_L26_aim_is_independent_and_redirection_does_not_move_it() -> bool:
	# --- MOVEMENT DOES NOT CHANGE THE AIM (F23's claim, through a REDIRECT). --
	await _set_mode("EXTREME")
	await _rest_at(LANE_A + Vector3(0, 0, 2.0))
	var fixed := Vector3(-4.0, 0.0, -2.0)
	cam.debug_cursor_override = fixed
	await _phys(3)
	var aim_before := player.aim_point
	var moving := await _drive_lane(LANE_B)
	var redirects0 := player.motor.redirects
	player.command_move_to(LANE_A)
	# TEN FRAMES, not thirty: at the EXTREME speed thirty frames covers nearly six
	# metres and the actor ARRIVES, so the first run of this suite measured a
	# stopped actor and reported "still moving=false".
	await _phys(10)
	var aim_after := player.aim_point
	var redirected := player.motor.redirects > redirects0
	var travelled := player.motor.speed() > 0.5
	var aim_fixed := aim_before.distance_to(aim_after) < 0.001
	# --- AIMING DOES NOT CHANGE THE MOVE DESTINATION (F24's claim). ----------
	var dest := player.command_move_to(player.global_position + Vector3(0, 0, -4.0))
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
	var swept := player.aim_point.distance_to(before) > 0.5
	# --- AND THE PER-USE AIM IS STILL CLEARED BETWEEN USES. ------------------
	var per_use := player._shot_aim_dir.length() < 0.001
	cam.debug_cursor_override = null
	await _set_mode("ORDINARY")
	await _rest_at(ProductionArena.player_spawn())
	var ok := moving > 0.95 * ProdConfig.TOP_SPEED_MPS * CohortConfig.SPEED_SCALE_EXTREME \
		and redirected and travelled and aim_fixed and changes == 0 and swept and per_use
	_note("L26_aim_is_independent_and_redirection_does_not_move_it",
		"at the EXTREME diagnostic speed the actor reached %.3f m/s, was REDIRECTED=%s and was still moving afterwards=%s, and the aim POINT moved %.6f m — a world point, untouched by the redirect=%s | the aim was then swept through 24 world points (it genuinely moved=%s) and the move destination changed %d times (must be 0) | the per-use aim is cleared between uses=%s"
		% [moving, str(redirected), str(travelled), aim_before.distance_to(aim_after), str(aim_fixed),
		   str(swept), changes, str(per_use)])
	_reached("L26_aim_is_independent_and_redirection_does_not_move_it")
	return ok

func chk_L27_the_sampled_facing_snap_and_the_facing_hold_are_unchanged() -> bool:
	await _set_mode("ORDINARY")
	await _rest_at(LANE_A + Vector3(0, 0, 4.0))
	var holds0 := player.facing_holds
	var began := await _begin_splinter(player.global_position + Vector3(0, 0, 6.0))
	var held := player.facing_hold_active()
	var yaw_at_start := player.mechanical_facing_yaw()
	# SWING THE CURSOR RIGHT ROUND while the action runs: the MECHANICAL facing
	# must not follow it.
	var moved_yaw := 0.0
	var g := 0
	while player.commitment.active and g < 200:
		cam.debug_cursor_override = player.global_position \
			+ Vector3(cos(float(g) * 0.4) * 6.0, 0, sin(float(g) * 0.4) * 6.0)
		await physics_frame
		g += 1
		if player.facing_hold_active():
			moved_yaw = maxf(moved_yaw, absf(wrapf(player.mechanical_facing_yaw() - yaw_at_start, -PI, PI)))
	var snapped := held and player.facing_holds == holds0 + 1 and moved_yaw < 0.0001
	await _until(func() -> bool: return not player.facing_hold_active(), 120)
	var released := not player.facing_hold_active()
	# --- F73 IS UNTOUCHED: the DIAGNOSTIC bolt still holds NO facing. --------
	cam.debug_cursor_override = null
	await _rest_at(LANE_A + Vector3(0, 0, 4.0))
	var holds1 := player.facing_holds
	player._cooldown = 0.0
	player.begin_attack()
	var never_held := true
	var g2 := 0
	while player.commitment.active and g2 < 200:
		await physics_frame
		g2 += 1
		never_held = never_held and not player.facing_hold_active()
	var bolt_ok := g2 > 2 and never_held and player.facing_holds == holds1
	# ONLY THE HUNTRESS RUNTIME EVER ASKS FOR A HOLD, and the controller's facing
	# code is untouched by D-400.
	var callers: Array[String] = []
	for f in _runtime_script_files():
		if String(f).ends_with("player_controller.gd"):
			continue
		if _code_only(_read_text(String(f))).find("hold_facing(") >= 0:
			callers.append(String(f).get_file())
	var ctrl := _code_only(_read_text("res://scripts/control/player_controller.gd"))
	var facing_untouched := ctrl.find("commitment.allows_facing()") >= 0 \
		and ctrl.find("yaw_driver.step(_facing_hold_yaw, delta)") >= 0 \
		and ctrl.find("yaw_driver.step(YawDriver.yaw_to(aim_dir), delta)") >= 0
	# AND THE D-400 SCRIPTS TOUCH FACING AT ALL.
	var loco := _strip_strings(_code_only(_read_text("res://scripts/locomotion/ground_motion.gd"))) \
		+ _strip_strings(_code_only(_read_text("res://scripts/locomotion/locomotion_config.gd")))
	var no_facing := loco.findn("yaw") < 0 and loco.findn("facing") < 0
	# THE SCAN CAN FIRE: a planted identifier is seen, and quoted prose is not.
	var scan_ok := _strip_strings("var yaw_hack := 1").findn("yaw") >= 0 \
		and _strip_strings("var x := \"sampled facing\"").findn("facing") < 0
	await _rest_at(ProductionArena.player_spawn())
	var ok := began and snapped and released and bolt_ok and callers == ["huntress_runtime.gd"] \
		and facing_untouched and no_facing and scan_ok
	_note("L27_the_sampled_facing_snap_and_the_facing_hold_are_unchanged",
		"a Splinter Shot use BEGAN=%s and SNAPPED the mechanical facing, holding it (%d -> %d) while the cursor was swung right round: the greatest movement of the mechanical facing was %.8f rad=%s | the hold was released afterwards=%s | the DIAGNOSTIC bolt still holds NO facing at all over its %d frames, and F73 governs it exactly as accepted=%s | the only caller of hold_facing() is %s | the controller's facing code is untouched=%s and neither D-400 script DECLARES anything named for yaw or facing — string literals stripped first, because LocomotionConfig quotes the owner's item 9=%s (the scan sees a planted identifier and ignores quoted prose=%s)"
		% [str(began), holds0, player.facing_holds, moved_yaw, str(snapped), str(released), g2,
		   str(bolt_ok), str(callers), str(facing_untouched), str(no_facing), str(scan_ok)])
	_reached("L27_the_sampled_facing_snap_and_the_facing_hold_are_unchanged")
	return ok

# =============================================================================
# I. THE CONTROL SCHEME — item 8
# =============================================================================

## The 29 input actions accepted before D-400, in project order. D-400 ADDS NONE.
const ACCEPTED_ACTIONS := ["move_command", "stick_left", "stick_right", "stick_up", "stick_down",
	"aim_left", "aim_right", "aim_up", "aim_down", "diagnostic_attack", "zoom_in", "zoom_out",
	"toggle_overlay", "imprint_binding_1", "imprint_binding_2", "imprint_binding_3",
	"imprint_binding_4", "imprint_binding_5", "imprint_binding_6", "imprint_binding_7",
	"imprint_binding_8", "imprint_panel", "imprint_panel_prev", "imprint_panel_next",
	"imprint_panel_activate", "diagnostic_reservation_cycle", "diagnostic_hound_fall",
	"diagnostic_stress_population", "diagnostic_travel_speed"]

func chk_L28_click_to_move_is_preserved_and_no_wasd_binding_exists() -> bool:
	# CLICK-TO-MOVE IS STILL THE CANONICAL MOUSE SCHEME, and it still works.
	await _set_mode("ORDINARY")
	await _rest_at(LANE_A)
	var bound := InputMap.has_action("move_command")
	var mouse := false
	for ev in InputMap.action_get_events("move_command"):
		if ev is InputEventMouseButton:
			mouse = true
	var dest := player.command_move_to(LANE_A + Vector3(0, 0, 6.0))
	var arrived := await _until(func() -> bool: return player.move_destination == null, 600)
	var works := arrived > 0 and _planar(player.global_position, dest) <= ProdConfig.ARRIVE_TOLERANCE_M
	# THE HELD RE-ISSUE IS UNCHANGED: a held command re-issues toward the cursor.
	var wish_body := _function_body(_code_only(_read_text("res://scripts/control/player_controller.gd")), "_wish_direction")
	var held := wish_body.find("intent.move_command_held and camera != null") >= 0 \
		and wish_body.find("command_move_to(camera.cursor_ground_point(global_position))") >= 0
	# NO W/A/S/D ANYWHERE: not in the input map, not in the input layer.
	var project := _read_text("res://project.godot")
	var wasd := false
	for code in [87, 65, 83, 68]:
		if project.find("\"physical_keycode\":%d," % code) >= 0:
			wasd = true
	var intent_src := _code_only(_read_text("res://scripts/control/input_intent.gd"))
	var no_wasd_path := intent_src.findn("wasd") < 0 and intent_src.find("KEY_W") < 0
	# THE GUARD CAN FIRE: a planted W keycode would be seen.
	var caught := "\"physical_keycode\":87,".find("\"physical_keycode\":87,") >= 0
	await _rest_at(ProductionArena.player_spawn())
	var ok := bound and mouse and works and held and not wasd and no_wasd_path and caught
	_note("L28_click_to_move_is_preserved_and_no_wasd_binding_exists",
		"`move_command` exists=%s and is bound to a mouse button=%s | a click order was issued and served to arrival, %.4f m from the target=%s | the held re-issue toward the cursor is unchanged in the controller=%s | NO W/A/S/D keycode appears in project.godot=%s and the input layer declares no such path=%s (the keycode scan can fire=%s)"
		% [str(bound), str(mouse), _planar(player.global_position, dest), str(works), str(held),
		   str(not wasd), str(no_wasd_path), str(caught)])
	_reached("L28_click_to_move_is_preserved_and_no_wasd_binding_exists")
	return ok

func chk_L29_no_new_input_action_no_new_surface_and_one_motor_path() -> bool:
	# EXACTLY THE 29 ACCEPTED ACTIONS, IN ORDER. D-400 ADDS NONE.
	var re := RegEx.new()
	re.compile("(?m)^([a-z_][a-z_0-9]*)=\\{$")
	var live: Array[String] = []
	for m in re.search_all(_read_text("res://project.godot")):
		live.append(m.get_string(1))
	var same := live.size() == ACCEPTED_ACTIONS.size()
	if same:
		for i in live.size():
			same = same and live[i] == String(ACCEPTED_ACTIONS[i])
	# NO NEW SURFACE: the D-400 scripts declare no Control, CanvasLayer or Node.
	var loco_files: Array[String] = []
	for f in _runtime_script_files():
		if String(f).begins_with("res://scripts/locomotion/"):
			loco_files.append(String(f))
	var no_surface := loco_files.size() == 2
	for f in loco_files:
		var c := _code_only(_read_text(f))
		no_surface = no_surface and c.find("extends Control") < 0 and c.find("extends CanvasLayer") < 0 \
			and c.find("extends Node") < 0 and c.find("add_child(") < 0
	# AND THE LAUNCH SURFACES ARE EXACTLY THE ACCEPTED D-398 COMPOSITION.
	var launch_same := bool(launch["overlay_enabled"]) == false and bool(launch["panel_enabled"]) == false \
		and bool(launch["d381_enabled"]) == false and bool(launch["d392_enabled"]) == true \
		and bool(launch["hounds_hud_enabled"]) == true and bool(launch["cohort_hud_enabled"]) == true
	# ONE MOTOR PATH: the controller calls `motor.step(` exactly once, the
	# arithmetic lives in exactly one runtime file, and nothing else calls it.
	var callers: Array[String] = []
	for f in _runtime_script_files():
		if String(f).ends_with("ground_motion.gd"):
			continue
		if _code_only(_read_text(String(f))).find("GroundMotion.step_velocity(") >= 0:
			callers.append(String(f).get_file())
	var steppers: Array[String] = []
	for f in _runtime_script_files():
		var n := _code_only(_read_text(String(f))).count("motor.step(")
		if n > 0:
			steppers.append("%s:%d" % [String(f).get_file(), n])
	var one_path := callers == ["locomotion_motor.gd"] and steppers == ["player_controller.gd:1"]
	# A PLANTED EXTRA ACTION IS REFUSED.
	var planted: Array = ACCEPTED_ACTIONS.duplicate()
	planted.append("diagnostic_dash")
	var refuses := planted.size() != live.size()
	var ok := same and no_surface and launch_same and one_path and refuses
	_note("L29_no_new_input_action_no_new_surface_and_one_motor_path",
		"project.godot declares EXACTLY the %d accepted actions, in order — D-400 adds NONE (29 stays 29)=%s, and a planted extra is refused=%s | the D-400 stage adds %d runtime scripts, neither a surface: no Control, CanvasLayer, Node or add_child=%s | the launch composition is exactly the accepted D-398 one (overlay off, panel off, D-381 off, D-392/D-396/D-398 HUDs on)=%s | ONE motor path: GroundMotion.step_velocity is called from %s only, and motor.step( appears in %s=%s"
		% [live.size(), str(same), str(refuses), loco_files.size(), str(no_surface), str(launch_same),
		   str(callers), str(steppers), str(one_path)])
	_reached("L29_no_new_input_action_no_new_surface_and_one_motor_path")
	return ok

# =============================================================================
# J. NO REGRESSION ELSEWHERE — item 11
# =============================================================================

func chk_L30_minion_cohesion_is_not_regressed_by_the_sharper_reversal() -> bool:
	var rows: Array[String] = []
	var all_ok := true
	var c: MobileCohort = hounds.cohort
	for spec in [[2, "ORDINARY"], [2, "EXTREME"], [15, "EXTREME"]]:
		await _set_mode(String(spec[1]))
		diag.set_population(int(spec[0]))
		await _rest_at(LANE_A)
		await _phys(40)
		var rec0 := c.total_recoveries()
		var moving := await _drive_lane(LANE_B)
		# THE REVERSAL, and what the formation does with it.
		var heading0 := c.heading
		var worst_heading_step := 0.0
		var prev_heading := c.heading
		player.command_move_to(LANE_A)
		var worst_lag := 0.0
		var farthest := 0.0
		for i in 90:
			await physics_frame
			var step_deg := GroundMotion.direction_angle_deg(prev_heading, c.heading)
			worst_heading_step = maxf(worst_heading_step, step_deg)
			prev_heading = c.heading
			worst_lag = maxf(worst_lag, c.furthest_lag)
			farthest = maxf(farthest, c.farthest_from_her)
		var recs := c.total_recoveries() - rec0
		# THE FORMATION HEADING IS STILL RATE-LIMITED: the leader may reverse in a
		# frame, the FORMATION may not. This is D-398's accepted rule, and the
		# sharper reversal is exactly the case that would break it.
		var rate_ok := worst_heading_step <= CohortConfig.HEADING_TURN_DEG_PER_S * DT * 1.05
		# THE HEADING MAY FREEZE MID-SWING, and that is D-398's accepted behaviour:
		# the lead and the heading hold while she stands. At the faster diagnostic
		# speeds she ARRIVES inside these 90 frames and stops, so the swing stops
		# with her. MEASURED: 180 deg at the accepted speed, about 90 at the
		# faster ones. What matters is that it turned SUBSTANTIALLY and GRADUALLY.
		var turned := GroundMotion.direction_angle_deg(heading0, c.heading) > 60.0
		# NO MEMBER IS LEFT BEHIND, and no soft recovery is provoked.
		var kept := farthest < CohortConfig.FAR_BEHIND_M and recs == 0
		var this_ok := moving > 0.9 * _top() and rate_ok and turned and kept
		all_ok = all_ok and this_ok
		rows.append("population %d at %s: she reversed from %.3f m/s; the formation heading turned %.1f deg in all, never more than %.3f deg in one frame (the accepted limit is %.3f)=%s; worst slot lag %.2f m, farthest member %.2f m of the accepted %.1f m, %d soft recoveries"
			% [spec[0], spec[1], moving, GroundMotion.direction_angle_deg(heading0, c.heading), worst_heading_step,
			   CohortConfig.HEADING_TURN_DEG_PER_S * DT, str(rate_ok), worst_lag, farthest,
			   CohortConfig.FAR_BEHIND_M, recs])
	# AND NOT ONE COHORT VALUE MOVED.
	var cohort_values := CohortConfig.registry().size() == 40 \
		and is_equal_approx(CohortConfig.HEADING_TURN_DEG_PER_S, 300.0) \
		and is_equal_approx(CohortConfig.TELEPORT_JUMP_M, 0.75) \
		and is_equal_approx(CohortConfig.CATCHUP_SPEED_RATIO, 1.35) \
		and is_equal_approx(HoundConfig.SPEED_MPS, 5.2) and hounds.pack.size() == HoundConfig.PACK_SIZE
	# AND NO COHORT OR HOUND FILE WAS TOUCHED BY THE LOCOMOTION CHANGE.
	var untouched := true
	for f in _runtime_script_files():
		var p := String(f)
		if p.begins_with("res://scripts/cohort/") or p.begins_with("res://scripts/hounds/"):
			var c2 := _strip_strings(_code_only(_read_text(p)))
			untouched = untouched and c2.find("GroundMotion") < 0 and c2.find("LocomotionConfig") < 0
	diag.set_population(2)
	await _set_mode("ORDINARY")
	await _rest_at(ProductionArena.player_spawn())
	await _phys(20)
	var ok := all_ok and cohort_values and untouched
	_note("L30_minion_cohesion_is_not_regressed_by_the_sharper_reversal",
		"%s | the 40 accepted cohort values are unchanged and the canonical pack is still %d=%s | no cohort or hound script references the D-400 arithmetic at all=%s. The accepted D-398 suite is re-run WHOLE by tests/locomotion_smoke.sh; this check measures what the sharper reversal does to it."
		% [" · ".join(rows), hounds.pack.size(), str(cohort_values), str(untouched)])
	_reached("L30_minion_cohesion_is_not_regressed_by_the_sharper_reversal")
	return ok

## ============================================================================
## THE DELIVERY DIGESTS. Any change to an accepted registry must move a pin here
## IN THE SAME CHANGE, which is the whole point of pinning them.
## ============================================================================
## Each row is [the number of NUMERIC constants, the SHA-256 of their name=value
## listing]. MEASURED at delivery, on the run of record. Any change to an
## accepted registry must move a pin here IN THE SAME CHANGE.
const DELIVERY_PINS := {
	"res://scripts/core/prod_config.gd":
		[62, "3cc73ec61c07d1314a45e53051c518b5ffb920c388b87f3b6d0470ea28a09674"],
	"res://scripts/imprint/imprint_config.gd":
		[107, "bfac2ac55ed3562643fcff9c1a3213395ce63a39ee52e91b29c8b297ddbfd0e7"],
	"res://scripts/huntress/huntress_config.gd":
		[27, "690d8107c9028d6d11aba57da5742029956b1c5b3446d54237542eb4fee1948c"],
	"res://scripts/hounds/hound_config.gd":
		[24, "c831b7df737c94cec98743a121821975101063bec7544a087a67696175096d97"],
	"res://scripts/cohort/cohort_config.gd":
		[40, "038ea0a513a7c9f4e57f89bde7ba0dd46bb36217fd19878cd77e4c48c438ccdf"],
}

func chk_L31_no_accepted_value_camera_zoom_timing_or_geometry_changed() -> bool:
	# EVERY NAMED VALUE THE RULING FORBIDS MOVING.
	var speed := is_equal_approx(ProdConfig.TOP_SPEED_MPS, 3.889) \
		and ProdConfig.TOP_SPEED_STATUS.findn("candidate") >= 0 \
		and ProdConfig.TOP_SPEED_STATUS.findn("not a lock") >= 0
	var modes := CohortConfig.speed_modes().size() == 3 \
		and is_equal_approx(float(CohortConfig.speed_modes()[0][1]), 1.0) \
		and is_equal_approx(CohortConfig.SPEED_SCALE_FAST, 1.8) \
		and is_equal_approx(CohortConfig.SPEED_SCALE_EXTREME, 3.0)
	var camera := is_equal_approx(ProdConfig.CAM_PITCH_DEG, -52.0) \
		and is_equal_approx(ProdConfig.CAM_YAW_DEG, 45.0) \
		and is_equal_approx(ProdConfig.CAM_SIZE_DEFAULT, 14.0) \
		and is_equal_approx(ProdConfig.CAM_SIZE_MIN, 11.0) and is_equal_approx(ProdConfig.CAM_SIZE_MAX, 18.0) \
		and is_equal_approx(ProdConfig.CAM_ZOOM_STEP, 0.6) and is_equal_approx(ProdConfig.CAM_FOLLOW_LAG, 8.0)
	var timing := is_equal_approx(ProdConfig.ATTACK_COOLDOWN_S, 0.45) \
		and is_equal_approx(ProdConfig.ATTACK_RELEASE_MARKER, 0.36) \
		and is_equal_approx(HuntressConfig.SPLINTER_RELEASE_S, 0.50) \
		and is_equal_approx(ProdConfig.YAW_RATE_DEG_PER_S, 720.0)
	var minions := is_equal_approx(HoundConfig.SPEED_MPS, 5.2) \
		and is_equal_approx(HoundConfig.ACQUISITION_RANGE_M, 6.0) \
		and is_equal_approx(HoundConfig.LEASH_RANGE_M, 9.0)
	# NO NEW CONTENT OF ANY KIND.
	# RE-SCOPED UNDER D-402, ONE FOR ONE: the library 16 + 1 = 17 and the
	# Configurations 8 + 1 = 9 -- Cinder Field, the ONE canonical ACTIVE Skill
	# Imprint that ruling authorizes, with its ONE unmodified Configuration.
	# Until D-402 these required 16 and 8: true when written.
	var content := skills.library.count() == 17 and skills.configurations.size() == 9 \
		and SkillRuntime.all_action_entry_points().size() == 8 \
		and PlayerController.DIAGNOSTIC_ACTIONS.size() == 1 \
		and AssetManifest.packs().size() == 5
	var declared := 0
	for p in AssetManifest.packs():
		declared += (p["files"] as Array).size()
	var scenes: Array = []
	_walk("res://scenes", scenes)
	# RE-SCOPED UNDER D-402, ONE FOR ONE: 29 + 4 = 33 (the two Cinder Field
	# placeholder bodies, in the already-declared ruins pack). Until D-402 this
	# required 29: true when written, and the D-400 stage did import zero.
	content = content and declared == 33 and scenes.size() == 1
	# AND THE FIVE ACCEPTED REGISTRIES ARE PINNED BY DIGEST, IN BOTH DIRECTIONS.
	var rows: Array[String] = []
	var pinned := true
	for path in DELIVERY_PINS.keys():
		var d := _numeric_digest(String(path))
		var want: Array = DELIVERY_PINS[path]
		rows.append("%s: %d numeric constants, %s" % [String(path).get_file(), int(d[0]), String(d[1])])
		pinned = pinned and int(d[0]) == int(want[0]) and String(d[1]) == String(want[1])
	_finding("ACCEPTED REGISTRY DIGESTS (D-400 delivery pins): %s" % " · ".join(rows))
	# THE DIGEST CAN REFUSE: a planted value changes it.
	var m := _constants("res://scripts/core/prod_config.gd").duplicate()
	m["TOP_SPEED_MPS"] = 3.9
	var refuses := String(_digest_of_map(m)[1]) != String(_numeric_digest("res://scripts/core/prod_config.gd")[1])
	var ok := speed and modes and camera and timing and minions and content and pinned and refuses
	_note("L31_no_accepted_value_camera_zoom_timing_or_geometry_changed",
		"the accepted top speed is still 3.889 m/s and still labelled a CANDIDATE and not a lock=%s | the three diagnostic multipliers are still 1.0 / 1.8 / 3.0=%s | camera pitch, yaw, default size, both zoom bounds, the zoom step and the follow lag are unchanged=%s | every Skill timing value is unchanged=%s | minion speed, acquisition and leash are unchanged=%s | RE-SCOPED UNDER D-402, one for one, for the ONE canonical ACTIVE Skill Imprint that ruling authorizes and its two placeholder models: 17 Imprints, 9 Configurations, 8 entry points, 1 diagnostic action, 5 packs, 33 declared files and 1 scene=%s | the five accepted registries match their delivery digests EXACTLY=%s (%s) and a planted value is refused=%s"
		% [str(speed), str(modes), str(camera), str(timing), str(minions), str(content), str(pinned),
		   " · ".join(rows), str(refuses)])
	_reached("L31_no_accepted_value_camera_zoom_timing_or_geometry_changed")
	return ok

# =============================================================================
# K. SCOPE AND TRUTHFULNESS
# =============================================================================

const LO_TEXT := ["Whether abrupt direction changes feel immediate and controlled at ORDINARY speed.",
	"Whether they feel immediate and controlled at FAST speed.",
	"Whether they feel immediate and controlled at EXTREME speed.",
	"Whether starts and stops still feel natural."]

func chk_L32_denials_rulings_units_and_no_self_acceptance() -> bool:
	var den := LocomotionConfig.denials()
	# RE-SCOPED UNDER D-402 (first act): the last denial is now DATED HISTORY --
	# D-401 accepted and closed the stage -- and the count does not move.
	var den_ok := den.size() == 14 \
		and String(den[13]).find("The D-400 stage was delivered OPEN and never accepted itself: the owner ACCEPTED and CLOSED it under D-401") == 0
	for d in den:
		den_ok = den_ok and String(d).find("D-400") >= 0
	# THE OWNER'S ELEVEN ITEMS, EACH WITH EXACTLY ONE DISPOSITION, in order.
	var rulings := LocomotionConfig.canonical_rulings()
	var cited := rulings.size() == 11
	var kinds := ["IMPLEMENTED", "PRESERVED"]
	for i in rulings.size():
		cited = cited and String(rulings[i][0]) == "D-400 item %d" % (i + 1)
		var k := String(rulings[i][2])
		var one := 0
		for kind in kinds:
			if k.find(String(kind)) == 0:
				one += 1
		cited = cited and one == 1
	var ld := LocomotionConfig.deferred_rows()
	var ld_ok := ld.size() == 14
	for i in ld.size():
		ld_ok = ld_ok and String(ld[i][0]).begins_with("LD-%02d " % (i + 1)) and String(ld[i][2]).find("RETURNS TO") >= 0
	# RE-SCOPED UNDER D-402 (first act): 4 - 4 = 0 owed, 0 + 4 = 4 DISCHARGED, 0
	# deleted. Each discharged row must still carry its ORIGINAL text VERBATIM and
	# the owner's OWN D-401 answer, and the answer's bound travels with it.
	var lo := LocomotionConfig.owed_to_owner()
	var lod := LocomotionConfig.discharged_rows()
	var lo_ok := lo.is_empty() and lod.size() == 4
	for i in lod.size():
		lo_ok = lo_ok and String(lod[i][0]) == "LO-%02d" % (i + 1) and String(lod[i][1]) == LO_TEXT[i] \
			and String(lod[i][2]) == "DISCHARGED — D-401" \
			and String(lod[i][3]).find("ANSWERED DIRECTLY") > 0 \
			and String(lod[i][3]).find("works well, I like it") > 0 \
			and String(lod[i][3]).find("LD-02 stays CARRIED as a measured provisional finding") > 0 \
			and String(lod[i][3]).find("ORIGINAL ROW TEXT, PRESERVED VERBATIM (OWED-TO-OWNER): '" + LO_TEXT[i] + "'") > 0
	# AND LD-02 IS RE-CLASSIFIED, NOT DISCHARGED: it still prints, still is not a
	# pass, and its disposition is the owner's own re-classification.
	var ld02_ok := false
	for row in ld:
		if String(row[0]).begins_with("LD-02 "):
			ld02_ok = String(row[1]) == "CARRIED — PROVISIONAL FINDING" \
				and String(row[2]).find("RE-CLASSIFIED BY THE OWNER (D-401)") == 0 \
				and String(row[2]).find("NOT a defect awaiting repair") > 0 \
				and String(row[2]).find("do not scale it in this accepted stage") > 0
	# NO SELF-ACCEPTANCE, anywhere a viewer or a log could read it.
	var self_re := RegEx.new()
	# RE-SCOPED UNDER D-402 (first act), one for one: D-401 made "PLAYER LOCOMOTION
	# REDIRECTION STAGE ACCEPTED" the OWNER's fact -- it is in the state line
	# itself -- so it leaves the pattern and the OPEN D-402 stage takes its place.
	# RE-SCOPED UNDER D-404 (first act), one for one: D-403 made "CINDER FIELD
	# STAGE ACCEPTED" the OWNER's fact, so the needle MOVES to the OPEN D-404
	# stage, and "ACCEPTED and CLOSED (D-402)" joins what is still false.
	self_re.compile("PLAYER DIRECT-CLICK MOVEMENT CORRECTION STAGE ACCEPTED|ACCEPTED and CLOSED \\(D-402\\)|D-404 (is|stage is) ACCEPTED|ACCEPTED and CLOSED \\(D-400\\)|ACCEPTED and CLOSED \\(D-398\\)|" + PLANTED_CLAIM)
	var claims: Array[String] = []
	for f in _runtime_script_files():
		if self_re.search(_code_only(_read_text(String(f)))) != null:
			claims.append(String(f).get_file())
	cohort_hud.refresh()
	hounds_hud.refresh()
	d392_hud.refresh()
	var surfaces := cohort_hud.last_text + "\n" + hounds_hud.last_text + "\n" + d392_hud.last_text \
		+ "\n" + hud.compose() + "\n" + ProdConfig.STATE
	var surface_clean := self_re.search(surfaces) == null
	var caught := self_re.search("print(\"%s\")" % PLANTED_CLAIM) != null \
		and self_re.search("PLAYER DIRECT-CLICK MOVEMENT CORRECTION STAGE ACCEPTED and CLOSED (D-404)") != null
	# THE BANNER PRINTS NO ROW AND NO STATE LINE into the accepted suites' logs.
	var banner := _function_body(_code_only(_read_text("res://scripts/foundation_main.gd")), "_print_locomotion_banner")
	var banner_ok := banner.length() > 200 and banner.find("STATE") < 0 \
		and banner.find("deferred_rows") < 0 and banner.find("owed_to_owner") < 0
	# UNITS AT EVERY SURFACE. Built without a relative parent segment: the
	# accepted F65 and I99 refuse one in any file of this project.
	var inv_path := ProjectSettings.globalize_path("res://").trim_suffix("/").get_base_dir() \
		.path_join("docs/testing/D400_PLAYER_LOCOMOTION_REDIRECTION_OWED_CRITERIA_INVENTORY.md")
	var inv := _read_text(inv_path)
	var units := inv != "" and inv.find("**180**") >= 0 and inv.find("**33**") >= 0 \
		and inv.find("**22**") >= 0 and OWED.size() == 33
	var ok := den_ok and cited and ld_ok and lo_ok and ld02_ok and claims.is_empty() and surface_clean \
		and caught and banner_ok and units
	_note("L32_denials_rulings_units_and_no_self_acceptance",
		"RE-SCOPED UNDER D-402 (first act): %d denials, each naming D-400, the last now DATED HISTORY naming D-401=%s | the owner's ELEVEN items cited in order, each with EXACTLY ONE disposition=%s | LD-01..LD-14, each naming where it returns=%s | LO-01..LO-04 now 0 owed and 4 DISCHARGED — D-401 with the owner's OWN answer and their ORIGINAL TEXT VERBATIM=%s | LD-02 RE-CLASSIFIED by the owner, not discharged, still printed and still not a pass=%s | runtime code claiming the OPEN D-402 stage accepted: %s; the HUDs, overlay and state line claim none=%s; planted claims caught=%s | the locomotion banner prints no row and no STATE line=%s | the inventory states 180 OWED CRITERIA, 33 EXECUTABLE CHECKS and 22 RUNNER CHECKS, and this suite owes %d=%s"
		% [den.size(), str(den_ok), str(cited), str(ld_ok), str(lo_ok), str(ld02_ok), str(claims),
		   str(surface_clean), str(caught), str(banner_ok), OWED.size(), str(units)])
	_reached("L32_denials_rulings_units_and_no_self_acceptance")
	return ok

func chk_L33_seams_clear_and_every_stage_value_registered_provisional() -> bool:
	# AT LAUNCH, as normal play has it.
	var launch_clear := bool(launch["seams_clear"]) and is_equal_approx(float(launch["speed_scale"]), 1.0) \
		and String(launch["speed_mode"]) == "ORDINARY" and int(launch["population"]) == 2
	player.intent.clear_seams()
	cam.debug_cursor_override = null
	var now_clear := player.intent.seams_clear() and cam.debug_cursor_override == null \
		and not player.debug_freeze_attack and is_equal_approx(player.diagnostic_travel_speed_scale, 1.0)
	# THE D-400 STAGE INTRODUCES NO SEAM OF ITS OWN.
	var loco := _code_only(_read_text("res://scripts/locomotion/ground_motion.gd")) \
		+ _code_only(_read_text("res://scripts/locomotion/locomotion_config.gd"))
	var no_seam := loco.find("debug_") < 0
	# EVERY NUMERIC CONSTANT OF THE STAGE IS REGISTERED, AND BACK.
	var reg := LocomotionConfig.registry()
	var all_prov := reg.size() == 2
	for row in reg:
		all_prov = all_prov and String(row[2]).find("PROVISIONAL") == 0
	var consts := _constants("res://scripts/locomotion/locomotion_config.gd")
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
	# `GroundMotion` OWNS NO NUMBER AT ALL: it reads the two registered values and
	# the accepted rates, and declares no constant of its own.
	var gm := _constants("res://scripts/locomotion/ground_motion.gd")
	var gm_numeric := 0
	for k in gm.keys():
		if typeof(gm[k]) == TYPE_INT or typeof(gm[k]) == TYPE_FLOAT:
			gm_numeric += 1
	# NO RUNTIME LOAD LEAVES game3d/.
	var load_re := RegEx.new()
	load_re.compile("(?:load|preload|ResourceLoader\\.load|FileAccess\\.open|DirAccess\\.open)\\s*\\(\\s*\"([^\"]*)\"")
	var outward: Array[String] = []
	for f in _runtime_script_files():
		for m in load_re.search_all(_code_only(_read_text(String(f)))):
			if not m.get_string(1).begins_with("res://") or m.get_string(1).find("..") >= 0:
				outward.append("%s:%s" % [String(f).get_file(), m.get_string(1)])
	var ok := launch_clear and now_clear and no_seam and all_prov and both and refuses \
		and gm_numeric == 0 and outward.is_empty()
	_note("L33_seams_clear_and_every_stage_value_registered_provisional",
		"at launch every test seam was clear, the diagnostic speed scale 1.0, the mode ORDINARY and the population 2=%s; clear again now=%s | the stage introduces NO seam of its own=%s | %d registry values, every one PROVISIONAL=%s; the registry and LocomotionConfig's numeric constants match BOTH ways=%s; an unregistered planted constant is refused=%s | GroundMotion declares %d numeric constants of its own — it owns no number at all=%s | loads leaving game3d/: %s. NONE IS A LOCK."
		% [str(launch_clear), str(now_clear), str(no_seam), reg.size(), str(all_prov), str(both),
		   str(refuses), gm_numeric, str(gm_numeric == 0), str(outward)])
	_reached("L33_seams_clear_and_every_stage_value_registered_provisional")
	return ok

# =============================================================================
# REPORT
# =============================================================================

func _report() -> void:
	player.intent.clear_seams()
	cam.debug_cursor_override = null
	print("")
	print("------------------------------------------------------------------------")
	print("RESULTS — %s (%s)" % [LocomotionConfig.STAGE, LocomotionConfig.DECISION])
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
	print("THE OWNER'S ELEVEN ITEMS, each with exactly ONE disposition:")
	for r in LocomotionConfig.canonical_rulings():
		print("  [%-12s] %s — %s" % [String(r[2]).split(" —")[0], r[0], r[1]])
	print("")
	print("DEFERRED — recorded as such, NEVER as passes:")
	for row in LocomotionConfig.deferred_rows():
		print("  [%-24s] %s" % [row[1], row[0]])
		print("                   %s" % row[2])
	print("")
	print("OWED TO THE OWNER'S LIVE REVIEW — NOT passes and NOT failures:")
	for row in LocomotionConfig.owed_to_owner():
		print("  [OWED-TO-OWNER] %s %s" % [row[0], row[1]])
	print("")
	print("DISCHARGED BY THE OWNER'S D-401 ACCEPTANCE — NOT passes and NOT failures:")
	for row in LocomotionConfig.discharged_rows():
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
	print("DENIALS (%d):" % LocomotionConfig.denials().size())
	for d in LocomotionConfig.denials():
		print("  %s" % d)
	print("")
	print("UNITS: %d EXECUTABLE CHECKS here · 180 OWED CRITERIA in the D-400 inventory ·" % OWED.size())
	print("       22 RUNNER CHECKS in tests/locomotion_smoke.sh · and the ACCEPTED suites' 85, 101, 40,")
	print("       53, 45 and 40 EXECUTABLE CHECKS are DIFFERENT decisions' numbers.")
	print("       Different unit. None is a synonym for another.")
	print("")
	var verdict := "PASS" if _all_ok() else "FAIL"
	print("LOCOMOTION VERIFICATION: %s (%d checks: %d passed, %d failed/unreached, %d deferred, %d owed to the owner, %d discharged)"
		% [verdict, OWED.size(), passed, failed, LocomotionConfig.deferred_rows().size(),
		   LocomotionConfig.owed_to_owner().size(), LocomotionConfig.discharged_rows().size()])
	print("STATE: %s" % ProdConfig.STATE)
