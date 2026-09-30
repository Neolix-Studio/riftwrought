extends SceneTree

## RIFTWROUGHT — THE PLAYER DIRECT-CLICK MOVEMENT CORRECTION STAGE VERIFICATION  (D-404, 2026-09-28)
##
## ============================================================================
## A NINTH SUITE. THE EIGHT ACCEPTED ONES ARE RE-RUN AS REGRESSIONS.
## ============================================================================
## `tests/foundation_verification.gd` (85, ACCEPTED D-373), `imprint_` (101,
## D-376), `alignment_` (40, D-383), `huntress_` (53, D-394), `hounds_` (45,
## D-397), `cohesion_` (40, D-399), `locomotion_` (33, D-401) and `cinder_` (48,
## ACCEPTED D-403) run FIRST in `tests/direct_click_smoke.sh`. This suite owns
## only what D-404 owes.
##
## ============================================================================
## UNITS. THIRTY COUNTS EXIST IN THIS PROJECT AND NONE IS A SYNONYM.
## ============================================================================
##   D-404 OWED CRITERIA     124  docs/testing/D404_DIRECT_CLICK_MOVEMENT_OWED_CRITERIA_INVENTORY.md
##   D-404 EXECUTABLE CHECKS  32  this suite (D01-D32)
##   D-404 RUNNER CHECKS      24  tests/direct_click_smoke.sh (U01-U24)
##   D-402 185 · 48 · 24   D-400 180 · 33 · 22   D-398 201 · 40 · 22
##   D-396 202 · 45 · 21   D-392 203 · 53 · 21   D-380 162 · 40 · 21
##   D-375 149 · 101 · 26  D-370 125 · 85 · 20
## The D-404 printed rows are the DD- rows and 6 DO- rows: none is a pass.
##
## ============================================================================
## IT VERIFIES A STAGE DELIVERED OPEN. IT ACCEPTS NOTHING.
## ============================================================================
## Every BOUND it asserts is a TEST BOUND, stated in its own note -- never a
## gameplay value, and never a lock. The standing rules, verbatim: a named owed
## list compared in BOTH directions · every check records reaching its LAST line
## · a missing check function is a FAIL · every negative control is PROVED ABLE
## TO REFUSE · an assertion that something did NOT happen first asserts the
## action FIRED · source-scanning guards read CODE, never dated history comments.

const OWED := [
	# --- A. THE FIRST ACT -------------------------------------------------------
	"D01_state_names_nine_facts_exactly_with_one_definer",
	"D02_fo_rows_discharged_d403_with_history_and_findings_carried",
	"D03_every_accepted_pin_moved_together_and_refuses_stale_lines",
	# --- B. THE MOUSE ORDER ITSELF ----------------------------------------------
	"D04_a_click_destination_is_stored_exactly_without_navigation_snapping",
	"D05_no_player_path_query_is_made_for_a_mouse_order",
	"D06_every_step_points_straight_at_the_clicked_destination",
	"D07_an_unobstructed_click_travels_directly_and_arrives_normally",
	# --- C. OBSTRUCTION ---------------------------------------------------------
	"D08_a_click_behind_the_wall_moves_directly_toward_the_wall",
	"D09_it_never_routes_around_either_end_of_the_wall",
	"D10_contact_stops_the_player_at_the_correct_collision_boundary",
	"D11_perpendicular_contact_produces_no_penetration",
	"D12_angled_contact_produces_no_tangential_wall_sliding",
	"D13_the_blocked_movement_order_is_cleared",
	"D14_holding_behind_the_wall_cannot_creep_oscillate_or_route",
	"D15_a_new_click_parallel_to_or_away_from_the_wall_moves_immediately",
	"D16_a_new_click_on_the_other_side_still_does_not_bypass_the_wall",
	"D17_a_solid_body_blocks_a_click_exactly_as_world_geometry_does",
	"D18_no_tunnelling_at_ordinary_fast_and_extreme_speed",
	# --- D. OPEN SPACE IS UNCHANGED ---------------------------------------------
	"D19_open_space_motion_equals_the_accepted_arithmetic_exactly",
	"D20_arrival_is_unchanged_at_every_speed",
	# --- E. WHAT MUST NOT CHANGE ------------------------------------------------
	"D21_controller_stick_movement_is_unchanged_and_still_slides",
	"D22_aim_stays_independent_of_the_click_order",
	"D23_stop_commitment_and_the_action_brake_are_unchanged",
	"D24_buffered_movement_still_applies_at_release_as_a_direct_order",
	"D25_splinter_shot_and_cinder_field_releases_survive_recovery_cancellation",
	"D26_enemies_and_hounds_still_use_their_accepted_navigation_paths",
	"D27_minion_cohesion_is_unchanged",
	"D28_navigation_collision_placement_and_accepted_values_are_unchanged",
	"D29_the_conflicting_accepted_checks_were_replaced_one_for_one_with_history",
	# --- F. REVIEW SURFACES -----------------------------------------------------
	"D30_f1_and_f2_start_hidden_and_the_review_surface_overlaps_nothing",
	"D31_the_review_shows_destination_segment_contact_stop_reason_and_zero_path",
	# --- G. SCOPE AND TRUTHFULNESS ----------------------------------------------
	"D32_denials_rulings_units_registry_and_no_self_acceptance",
]

## ONE deliberately planted claim, so the self-acceptance scans can be proved
## able to refuse. It is never printed.
const PLANTED_CLAIM := "Direct_Click_Stage_Accepts_Itself_THIS_IS_FORBIDDEN"

const NINE := "FOUNDATION STAGE ACCEPTED and CLOSED (D-373) · IMPRINT STAGE ACCEPTED and CLOSED (D-376) · D-378 ALIGNMENT STAGE ACCEPTED and CLOSED (D-383) · HUNTRESS SPLINTER SHOT STAGE ACCEPTED and CLOSED (D-394) · KINDRED HOUNDS STAGE ACCEPTED and CLOSED (D-397) · MOBILE MINION COHESION STAGE ACCEPTED and CLOSED (D-399) · PLAYER LOCOMOTION REDIRECTION STAGE ACCEPTED and CLOSED (D-401) · CINDER FIELD STAGE ACCEPTED and CLOSED (D-403) · PLAYER DIRECT-CLICK MOVEMENT CORRECTION STAGE DELIVERED and OPEN pending owner live review (D-404)"
const ACC403 := "CINDER FIELD STAGE ACCEPTED and CLOSED (D-403)"
const OPEN9 := "PLAYER DIRECT-CLICK MOVEMENT CORRECTION STAGE DELIVERED and OPEN pending owner live review (D-404)"
const STATE_D402 := "FOUNDATION STAGE ACCEPTED and CLOSED (D-373) · IMPRINT STAGE ACCEPTED and CLOSED (D-376) · D-378 ALIGNMENT STAGE ACCEPTED and CLOSED (D-383) · HUNTRESS SPLINTER SHOT STAGE ACCEPTED and CLOSED (D-394) · KINDRED HOUNDS STAGE ACCEPTED and CLOSED (D-397) · MOBILE MINION COHESION STAGE ACCEPTED and CLOSED (D-399) · PLAYER LOCOMOTION REDIRECTION STAGE ACCEPTED and CLOSED (D-401) · CINDER FIELD STAGE DELIVERED and OPEN pending owner live review (D-402)"
const STATE_D400 := "FOUNDATION STAGE ACCEPTED and CLOSED (D-373) · IMPRINT STAGE ACCEPTED and CLOSED (D-376) · D-378 ALIGNMENT STAGE ACCEPTED and CLOSED (D-383) · HUNTRESS SPLINTER SHOT STAGE ACCEPTED and CLOSED (D-394) · KINDRED HOUNDS STAGE ACCEPTED and CLOSED (D-397) · MOBILE MINION COHESION STAGE ACCEPTED and CLOSED (D-399) · PLAYER LOCOMOTION REDIRECTION STAGE DELIVERED and OPEN pending owner live review (D-400)"

## The owner's seven D-402 questions, VERBATIM, so D02 can prove each discharged
## row still carries its ORIGINAL text.
const FO_TEXT := [
	"Does placement feel responsive and accurate while using click-to-move?",
	"Are dormant, armed and sprung states readable at normal gameplay zoom?",
	"Do the arming delay and enemy-only trigger feel intuitive?",
	"Are the initial eruption and lingering burning ground visually distinct?",
	"Does placing several traps and replacing the oldest behave predictably?",
	"Does overlapping burning ground clearly avoid multiplying damage?",
	"Does this feel like a plausible foundation for a trap-focused Huntress build?",
]
## The owner's six D-404 questions, VERBATIM.
const DO_TEXT := [
	"Does clicking behind an obstacle now stop the player where expected?",
	"Is the magnetic automatic routing gone?",
	"Does angled contact stop cleanly, or does it feel too sticky?",
	"Does manually clicking around an obstacle feel fluid?",
	"Does unobstructed click-to-move still feel unchanged?",
	"Does it remain stable at FAST and EXTREME speeds?",
]

const ACCEPTED_SUITES := ["res://tests/imprint_verification.gd", "res://tests/alignment_verification.gd",
	"res://tests/huntress_verification.gd", "res://tests/hounds_verification.gd",
	"res://tests/cohesion_verification.gd", "res://tests/locomotion_verification.gd",
	"res://tests/cinder_verification.gd"]
const ACCEPTED_RUNNERS := ["res://tests/foundation_smoke.sh", "res://tests/imprint_smoke.sh",
	"res://tests/alignment_smoke.sh", "res://tests/huntress_smoke.sh", "res://tests/hounds_smoke.sh",
	"res://tests/cohesion_smoke.sh", "res://tests/locomotion_smoke.sh", "res://tests/cinder_smoke.sh"]

## The four runtime scripts this stage declares.
const D404_SCRIPTS := ["res://scripts/click/direct_click_config.gd", "res://scripts/click/direct_click_gizmo.gd",
	"res://scripts/click/direct_click_order.gd", "res://scripts/click/direct_click_review_hud.gd"]

## The accepted registries' numeric digests, MEASURED at the start of this stage
## (they match the D-402 run of record's printed prefixes). A digest that moves
## means an accepted number moved.
const REGISTRY_DIGESTS := {
	"prod_config.gd": [62, "aeda5525727f72450ce543735d7e8d4a26fc755111f1b735679825962b50bc45"],
	"imprint_config.gd": [107, "a6f016a80f552bb234c35ce04e99e090fc2152725be91182cd740bb9677ac52f"],
	"huntress_config.gd": [27, "fd779af01464588a1b3763ff0a95491f91cc48e756c02f59ebbd911b3016e91f"],
	"hound_config.gd": [24, "3cb74d2bc2c068502d47220446a94ee7430b84dff6e17b1eb873455f12f9d1b1"],
	"cohort_config.gd": [40, "b8c0c4f0e743e18c8cd9d67344a44806f8c1ddf67b4788edef20d362331f050c"],
	"locomotion_config.gd": [2, "6d3ff42609f42ec305d8da2b7ed60344270b6dbdca034fad2a2a753ee7365a19"],
	"cinder_config.gd": [26, "ed67270b53f2c2522fce64e6e68ffe208d1da8b3c7b7a559bf6d9ddadcad7610"],
}

## ============================================================================
## TEST GEOMETRY AND TEST BOUNDS. NONE IS A GAMEPLAY VALUE; NONE IS READ BY ANY
## RUNTIME FILE; NONE IS A LOCK.
## ============================================================================
## THE LONG WALL: the arena's INTERIOR BLOCKER, three wall modules at x = -7
## spanning z = -3 ... 3. Its faces are MEASURED live by rays, never assumed.
const BLOCKER_X := -7.0
const BLOCKER_HALF_SPAN := 3.0
const WALL_FROM := Vector3(-10.5, 0.0, 0.4)
const BEHIND := Vector3(-3.5, 0.0, 0.6)
const BEHIND_OTHER := Vector3(-3.8, 0.0, -1.6)
const GLANCE_FROM := Vector3(-8.6, 0.0, -2.6)
const GLANCE_TO := Vector3(-6.0, 0.0, 2.6)
const PERP_FROM := Vector3(-10.5, 0.0, 0.0)
const PERP_TO := Vector3(-3.5, 0.0, 0.0)
## An open lane in the west chamber, MEASURED clear by a body sweep.
const LANE_A := Vector3(-11.0, 0.0, -9.0)
const LANE_B := Vector3(-11.0, 0.0, 9.0)
const UNOBSTRUCTED_FROM := Vector3(-13.0, 0.0, -5.0)
const UNOBSTRUCTED_TO := Vector3(-9.5, 0.0, -8.0)
const PARK := Vector3(-18.2, 0.0, -10.3)
const MODES := ["ORDINARY", "FAST", "EXTREME"]
const DT := 1.0 / 60.0
const TOL_ON_LINE_M := 0.01          ## deviation from the straight segment
const TOL_DIR_DEG := 0.01            ## the commanded direction's own drift
const TOL_REDIRECT_DEG := 0.001      ## velocity vs commanded direction, the accepted bound
const TOL_DRIFT_M := 0.001           ## travel after a blocked stop
const TOL_BOUNDARY_M := 0.01         ## how far from one radius the stop may be

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
var cinder: CinderRuntime
var diag: CohortDiagnostics
var hud: DebugOverlay
var panel: LoadoutPanel
var review_hud: ReviewHud
var d392_hud: HuntressReviewHud
var hounds_hud: HoundReviewHud
var cohort_hud: CohortReviewHud
var cinder_hud: CinderReviewHud
var click_hud: DirectClickReviewHud
var click_gizmo: DirectClickGizmo
var arena: ProductionArena
var enemies: Array = []
var launch := {}
var nav_map: RID

func _initialize() -> void:
	print("========================================================================")
	print("RIFTWROUGHT — %s VERIFICATION  (%s, %s)" % [DirectClickConfig.STAGE, DirectClickConfig.DECISION, DirectClickConfig.DATE])
	print("STATE: %s" % ProdConfig.STATE)
	print("Verifying a STAGE DELIVERED OPEN: a MOUSE click order goes STRAIGHT at the clicked ground")
	print("point, unsnapped, asks navigation for nothing, and stops at the first blocker — no slide, no")
	print("reroute, no tunnelling. The stick, enemies, hounds and the cohort are unchanged.")
	print("It is NOT P2, NOT movement-speed tuning, NOT a control-scheme change and NOT a UI foundation.")
	print("It LOCKS NO NUMBER: every bound below is a TEST BOUND, stated in its own note.")
	print("OWED EXECUTABLE CHECKS: %d   DEFERRED ROWS: %d   OWED-TO-OWNER ROWS: %d"
		% [OWED.size(), DirectClickConfig.deferred_rows().size(), DirectClickConfig.owed_to_owner().size()])
	print("(The D-404 owed-criteria INVENTORY counts 124 CRITERIA. Different unit.)")
	print("(The ACCEPTED suites count 85, 101, 40, 53, 45, 40, 33 and 48 EXECUTABLE CHECKS.)")
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
	cinder = main.get("cinder")
	diag = main.get("cohort_diagnostics")
	hud = main.get("hud")
	panel = main.get("imprint_panel")
	review_hud = main.get("review_hud")
	d392_hud = main.get("huntress_hud")
	hounds_hud = main.get("hounds_hud")
	cohort_hud = main.get("cohort_hud")
	cinder_hud = main.get("cinder_hud")
	click_hud = main.get("click_hud")
	click_gizmo = main.get("click_gizmo")
	arena = main.get("arena")
	enemies = main.get("enemies")
	nav_map = NavService.map_rid_for(main)
	launch = {
		"overlay_enabled": hud.enabled, "panel_enabled": panel.enabled,
		"d381_enabled": review_hud.enabled, "d392_enabled": d392_hud.enabled,
		"hounds_hud_enabled": hounds_hud.enabled, "cohort_hud_enabled": cohort_hud.enabled,
		"cinder_hud_enabled": cinder_hud.enabled, "click_hud_enabled": click_hud.enabled,
		"gizmo_visible": click_gizmo.visible,
		"nav": NavService.measure_mesh(arena.nav_mesh()), "bake_count": arena.bake_count,
		"orders": player.click_order.orders_issued,
		"seams_clear": player.intent.seams_clear() and cam.debug_cursor_override == null
			and not player.debug_freeze_attack,
	}
	_park_enemies()
	skills.set_safe_state_override(true)
	await _phys(4)

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

func _all_ok() -> bool:
	for id in OWED:
		if not reached.has(id) or results.get(id, null) != true:
			return false
	for id in reached.keys():
		if not OWED.has(id):
			return false
	return true

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

## Distance from a point to the straight segment a-b, on the plane.
static func _off_segment(p: Vector3, a: Vector3, b: Vector3) -> float:
	var s := Vector2(a.x, a.z)
	var e := Vector2(b.x, b.z)
	var q := Vector2(p.x, p.z)
	var d := e - s
	if d.length() < 0.0001:
		return q.distance_to(s)
	var t := clampf((q - s).dot(d) / d.dot(d), 0.0, 1.0)
	return q.distance_to(s + d * t)

func _read_text(path: String) -> String:
	var f := FileAccess.open(path, FileAccess.READ)
	if f == null:
		return ""
	var s := f.get_as_text()
	f.close()
	return s

static func _code_only(text: String) -> String:
	var out := PackedStringArray()
	for line in text.split("\n"):
		if String(line).strip_edges().begins_with("#"):
			continue
		out.append(String(line))
	return "\n".join(out)

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

func _constants(path: String) -> Dictionary:
	var scr: Script = load(path)
	return scr.get_script_constant_map()

static func _numeric_digest(m: Dictionary) -> Array:
	var by_name := {}
	for k in m.keys():
		by_name[String(k)] = m[k]
	var keys: Array = by_name.keys()
	keys.sort()
	var parts: Array[String] = []
	var n := 0
	for k in keys:
		var v = by_name[k]
		if typeof(v) == TYPE_INT or typeof(v) == TYPE_FLOAT:
			parts.append("%s=%.6f" % [String(k), float(v)])
			n += 1
	return [n, "|".join(parts).sha256_text()]

func _park_enemies() -> void:
	for i in enemies.size():
		var e: OrdinaryEnemy = enemies[i]
		e.debug_freeze_ai = true
		e.life = Damageable.new(1000000.0)
		e.global_position = PARK + Vector3(0.0, 0.0, 0.9 * float(i))

## Back to rest at a known point, seams clear, no order, no commitment, and no
## remembered contact left over from an earlier check.
func _rest_at(p: Vector3) -> void:
	player.intent.clear_seams()
	cam.debug_cursor_override = null
	player.clear_move_destination()
	player.follower.set_path(PackedVector3Array())
	player.commitment.reset()
	player.motor.reset()
	player.velocity = Vector3.ZERO
	player.global_position = p
	_park_enemies()
	await _phys(4)

func _set_mode(mode_name: String) -> void:
	diag.set_speed(mode_name)
	await _phys(2)

func _top() -> float:
	return ProdConfig.TOP_SPEED_MPS * player.diagnostic_travel_speed_scale

## A click order, and a bounded wait for it to END. Returns frames waited.
func _click(to: Vector3, max_frames: int = 900) -> int:
	player.command_move_to(to)
	return await _until(func() -> bool: return not player.click_order.active, max_frames)

## The blocker's WEST face at height z, measured by a ray -- never assumed.
func _west_face_x(z: float) -> float:
	var space := player.get_world_3d().direct_space_state
	var q := PhysicsRayQueryParameters3D.create(Vector3(-11.0, 0.85, z), Vector3(BLOCKER_X, 0.85, z), 4)
	var hit := space.intersect_ray(q)
	return float(Vector3(hit["position"]).x) if not hit.is_empty() else INF

## The blocker's EAST face at height z, measured the same way.
func _east_face_x(z: float) -> float:
	var space := player.get_world_3d().direct_space_state
	var q := PhysicsRayQueryParameters3D.create(Vector3(-3.0, 0.85, z), Vector3(BLOCKER_X, 0.85, z), 4)
	var hit := space.intersect_ray(q)
	return float(Vector3(hit["position"]).x) if not hit.is_empty() else INF

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

# =============================================================================
# A. THE FIRST ACT — D-403 closure, reconciled by this stage's first act
# =============================================================================

static func _state_parts_ok(state: String) -> bool:
	var parts := state.split(" · ")
	return parts.size() == 9 \
		and parts[0] == "FOUNDATION STAGE ACCEPTED and CLOSED (D-373)" \
		and parts[1] == "IMPRINT STAGE ACCEPTED and CLOSED (D-376)" \
		and parts[2] == "D-378 ALIGNMENT STAGE ACCEPTED and CLOSED (D-383)" \
		and parts[3] == "HUNTRESS SPLINTER SHOT STAGE ACCEPTED and CLOSED (D-394)" \
		and parts[4] == "KINDRED HOUNDS STAGE ACCEPTED and CLOSED (D-397)" \
		and parts[5] == "MOBILE MINION COHESION STAGE ACCEPTED and CLOSED (D-399)" \
		and parts[6] == "PLAYER LOCOMOTION REDIRECTION STAGE ACCEPTED and CLOSED (D-401)" \
		and parts[7] == ACC403 \
		and parts[8] == OPEN9

func chk_D01_state_names_nine_facts_exactly_with_one_definer() -> bool:
	var s := ProdConfig.STATE
	var nine := _state_parts_ok(s) and s == NINE
	var re := RegEx.new()
	re.compile("(?m)^\\s*const\\s+STATE\\s*(:[^=]*)?:?=")
	var definers: Array[String] = []
	for f in _runtime_script_files():
		if re.search(_code_only(_read_text(String(f)))) != null:
			definers.append(String(f).get_file())
	var one := definers.size() == 1 and definers[0] == "prod_config.gd"
	var caught := re.search("const STATE := \"x\"") != null
	var gone := s != STATE_D402 and s != STATE_D400 \
		and s.find("CINDER FIELD STAGE DELIVERED") < 0 \
		and s.find("PLAYER LOCOMOTION REDIRECTION STAGE DELIVERED") < 0 \
		and s.find("MOBILE MINION COHESION STAGE DELIVERED") < 0 \
		and s.find("KINDRED HOUNDS STAGE DELIVERED") < 0 \
		and s.find("SPLINTER SHOT STAGE DELIVERED") < 0 \
		and s.find("ALIGNMENT STAGE DELIVERED") < 0 and s.find("IMPRINT STAGE DELIVERED") < 0
	var src := _read_text("res://scripts/core/prod_config.gd")
	var history := src.find("RECONCILED AN EIGHTH TIME UNDER D-404") >= 0 \
		and src.find("From D-402 until D-404 this read") >= 0 \
		and src.find("RECONCILED A SEVENTH TIME UNDER D-402") >= 0 \
		and src.find("Looks and feels good.") >= 0 \
		and src.find("IT WAS TRUE WHEN WRITTEN") >= 0
	var readers := _read_text("res://scripts/debug/debug_overlay.gd").find("ProdConfig.STATE") >= 0 \
		and _read_text("res://scripts/imprint/loadout_panel.gd").find("ProdConfig.STATE") >= 0
	var refuses := not _state_parts_ok(STATE_D402) and not _state_parts_ok(STATE_D400) \
		and not _state_parts_ok(s.replace(OPEN9, "PLAYER DIRECT-CLICK MOVEMENT CORRECTION STAGE ACCEPTED and CLOSED (D-404)")) \
		and not _state_parts_ok(s.replace(ACC403, "CINDER FIELD STAGE ACCEPTED and CLOSED (D-402)")) \
		and not _state_parts_ok(s + " · EXTRA STAGE (D-404)") \
		and not _state_parts_ok(" · ".join(s.split(" · ").slice(0, 8)))
	var ok := nine and one and caught and gone and history and readers and refuses
	_note("D01_state_names_nine_facts_exactly_with_one_definer",
		"STATE is EXACTLY the NINE-fact line (eight accepted stages, the eighth D-403's acceptance of Cinder Field, and the D-404 direct-click stage DELIVERED and OPEN)=%s | runtime definers: %s=%s (a planted one is seen=%s) | every superseded OPEN clause is gone as a current claim=%s | the D-402-era line's history is preserved and DATED in the one definer with the owner's own D-403 answer, and the D-402 block is still there=%s | the overlay and the panel read it=%s | the predicate refuses the D-402 and D-400 lines, a self-accepted ninth fact, the Cinder Field acceptance re-attributed to D-402, an extra fact and eight facts=%s"
		% [str(nine), str(definers), str(one), str(caught), str(gone), str(history), str(readers), str(refuses)])
	_reached("D01_state_names_nine_facts_exactly_with_one_definer")
	return ok

func chk_D02_fo_rows_discharged_d403_with_history_and_findings_carried() -> bool:
	var fo := CinderConfig.owed_to_owner()
	var fod := CinderConfig.discharged_rows()
	var fd := CinderConfig.deferred_rows()
	# 7 - 7 = 0 OWED, 0 + 7 = 7 DISCHARGED, 0 DELETED; 19 FD rows untouched.
	var rows_ok := fo.is_empty() and fod.size() == 7 and fd.size() == 19
	for i in fod.size():
		rows_ok = rows_ok and String(fod[i][0]) == "FO-%02d" % (i + 1) \
			and String(fod[i][1]) == FO_TEXT[i] \
			and String(fod[i][2]) == "DISCHARGED — D-403" \
			and String(fod[i][3]).find("ORIGINAL ROW TEXT, PRESERVED VERBATIM (OWED-TO-OWNER): '" + FO_TEXT[i] + "'") > 0
	# AT THE LEVEL GIVEN: ONE overall answer, no row-by-row judgment, no number.
	var level := CinderConfig.D403_ANSWER.find("\"Looks and feels good.\"") > 0 \
		and CinderConfig.D403_ANSWER.find("no row-by-row judgment is inferred") > 0 \
		and CinderConfig.D403_ANSWER.find("no timing, damage, radius, duration, cost, Capacity value, instance cap, animation, placeholder model, diagnostic visual or presentation detail became a lock") > 0
	var none_deleted := fd.size() + fod.size() + fo.size() == 19 + 7
	# FD-15 IS STILL DECLARED — NOT REPAIRED: the owner carried it, not fixed it.
	var fd15 := false
	for row in fd:
		if String(row[0]).begins_with("FD-15 "):
			fd15 = String(row[1]) == "DECLARED — NOT REPAIRED"
	# THE TWO D-403 FINDINGS ARE CARRIED AS PRINTED ROWS OF THIS STAGE.
	var dd := DirectClickConfig.deferred_rows()
	var carried := 0
	for row in dd:
		var t := String(row[0])
		if (t.begins_with("DD-03 ") and t.find("BRIGHTER") > 0) or (t.begins_with("DD-04 ") and t.find("bindings 7 and 8") > 0):
			carried += 1 if String(row[1]) == "CARRIED — NOT REPAIRED" else 0
	# THE SELF-DENIAL IS DATED HISTORY, and the present-tense one is gone.
	var den := CinderConfig.denials()
	var dated := false
	var old_present := false
	for d in den:
		var t2 := String(d)
		if t2.find("The D-402 stage was delivered OPEN and never accepted itself: the owner ACCEPTED and CLOSED it under D-403") == 0:
			dated = true
		if t2 == "The D-402 stage delivers OPEN pending owner live review; it does NOT accept itself.":
			old_present = true
	# AND NOTHING MOVED IN CINDER FIELD'S NUMBERS.
	var digest_same := String(_numeric_digest(_constants("res://scripts/cinder/cinder_config.gd"))[1]) \
		== String(REGISTRY_DIGESTS["cinder_config.gd"][1])
	var ok := rows_ok and level and none_deleted and fd15 and carried == 2 and dated \
		and not old_present and den.size() == 17 and digest_same
	_note("D02_fo_rows_discharged_d403_with_history_and_findings_carried",
		"FO-01..FO-07 DISCHARGED — D-403, each with its ORIGINAL TEXT VERBATIM; 0 owed; 19 FD rows=%s | the one overall answer is recorded at the level given, and carries its bound — no row-by-row judgment, no number locked=%s | 19 + 7 + 0 = 26 rows, ZERO deleted=%s | FD-15 still DECLARED — NOT REPAIRED=%s | the two D-403 findings are carried as DD-03 and DD-04, NOT REPAIRED (%d of 2) | the D-402 self-denial is dated history naming D-403=%s, the present-tense one gone=%s, 17 denials=%s | Cinder Field's numeric digest is unchanged=%s"
		% [str(rows_ok), str(level), str(none_deleted), str(fd15), carried, str(dated),
		   str(not old_present), str(den.size() == 17), str(digest_same)])
	_reached("D02_fo_rows_discharged_d403_with_history_and_findings_carried")
	return ok

func chk_D03_every_accepted_pin_moved_together_and_refuses_stale_lines() -> bool:
	var stale: Array[String] = []
	var needles: Array[String] = []
	var self_moved: Array[String] = []
	for r in ACCEPTED_RUNNERS:
		var t := _read_text(String(r))
		if t.find("STATE_EXPECT=\"STATE: %s\"" % NINE) < 0 \
				or t.find("STATE_EXPECT=\"STATE: %s\"" % STATE_D402) >= 0:
			stale.append(String(r).get_file())
		if t.find("STATE_D402_LINE=\"STATE: %s\"" % STATE_D402) < 0 or t.count("STATE_D402_LINE") < 2:
			needles.append(String(r).get_file())
		# EVERY SELF-ACCEPTANCE NEEDLE MOVED from Cinder Field to the open D-404
		# stage -- where a runner has one.
		if t.find("SELF_ACCEPT='") >= 0 and (t.find("SELF_ACCEPT='PLAYER DIRECT-CLICK MOVEMENT CORRECTION STAGE ACCEPTED|") < 0 \
				or t.find("SELF_ACCEPT='CINDER FIELD STAGE ACCEPTED|") >= 0):
			self_moved.append(String(r).get_file())
	var own := _read_text("res://tests/direct_click_smoke.sh").find("STATE_EXPECT=\"STATE: %s\"" % NINE) >= 0
	var suites_ok := true
	var suite_rows: Array[String] = []
	for p in ACCEPTED_SUITES:
		var t2 := _read_text(String(p))
		var has := t2.find(ACC403) >= 0 and t2.find(OPEN9) >= 0
		suites_ok = suites_ok and has
		suite_rows.append("%s=%s" % [String(p).get_file(), str(has)])
	# THE D-402 RUNNER'S OWN MOVES: 0 owed, 7 discharged, and the dated denial.
	var ct := _read_text("res://tests/cinder_smoke.sh")
	var d402_ok := ct.find("\nPIN_E_OWNER=0\n") >= 0 and ct.find("\nPIN_E_DISCHARGED=7\n") >= 0 \
		and ct.find("[DISCHARGED — D-403] FO-01") >= 0 \
		and ct.find("The D-402 stage was delivered OPEN and never accepted itself: the owner ACCEPTED and CLOSED it under D-403") >= 0
	# EVERY MOVED PIN IS STILL EXACT-LINE AND KEEPS ITS REFUSAL PROOF.
	var ft := _read_text("res://tests/foundation_smoke.sh")
	var it := _read_text("res://tests/imprint_smoke.sh")
	var exact := ft.find("if [ \"$STATE_LINE\" = \"$STATE_EXPECT\" ]; then") >= 0 \
		and it.find("if [ \"$LINE\" != \"$STATE_EXPECT\" ]; then") >= 0
	var refusal := ft.find("sed 's/ACCEPTED and CLOSED/DELIVERED and OPEN/'") >= 0 \
		and it.find("sed 's/ACCEPTED and CLOSED/DELIVERED and OPEN/'") >= 0
	var absence := ft.find("grep -qxF \"$STATE_D402_LINE\"") >= 0 and it.find("grep -qxF \"$STATE_D402_LINE\"") >= 0
	# NO GUARD WAS WEAKENED: every accepted count pin still stands.
	var counts := true
	for spec in [["res://tests/imprint_smoke.sh", "PIN_F_CHECKS=85"], ["res://tests/imprint_smoke.sh", "PIN_I_CHECKS=101"],
			["res://tests/alignment_smoke.sh", "PIN_A_CHECKS=40"], ["res://tests/huntress_smoke.sh", "PIN_H_CHECKS=53"],
			["res://tests/hounds_smoke.sh", "PIN_K_CHECKS=45"], ["res://tests/cohesion_smoke.sh", "PIN_C_CHECKS=40"],
			["res://tests/locomotion_smoke.sh", "PIN_M_CHECKS=33"], ["res://tests/cinder_smoke.sh", "PIN_E_CHECKS=48"]]:
		counts = counts and _read_text(String(spec[0])).find("\n" + String(spec[1]) + "\n") >= 0
	# THE AUDIT REFUSES a runner still pinning the D-402 line, one that dropped
	# the needle, and one missing the D-404 open clause.
	var refuses_stale := ft.replace("STATE_EXPECT=\"STATE: " + NINE + "\"", "STATE_EXPECT=\"STATE: " + STATE_D402 + "\"") \
		.find("STATE_EXPECT=\"STATE: %s\"" % NINE) < 0
	var refuses_no_needle := ft.replace("STATE_D402_LINE", "STATE_OLD_LINE").find("STATE_D402_LINE=\"STATE: %s\"" % STATE_D402) < 0
	var refuses_eight := ft.replace(" · " + OPEN9, "").find("STATE_EXPECT=\"STATE: %s\"" % NINE) < 0
	var ok := stale.is_empty() and needles.is_empty() and self_moved.is_empty() and own and suites_ok \
		and d402_ok and exact and refusal and absence and counts and refuses_stale and refuses_no_needle \
		and refuses_eight and ft.length() > 1000
	_note("D03_every_accepted_pin_moved_together_and_refuses_stale_lines",
		"all EIGHT accepted runners pin the NINE-fact line EXACTLY and none still pins the D-402 one (stale: %s)=%s; each holds the D-402-era line as a USED absence needle (missing: %s)=%s; every self-acceptance needle moved to the OPEN D-404 stage (unmoved: %s)=%s; and this stage's runner pins the same line=%s | every accepted suite that pins the state carries D-403's acceptance AND the D-404 open clause: %s=%s | the D-402 runner pins 0 owed / 7 discharged, FO-01 DISCHARGED — D-403, and the dated denial=%s | the pins are still EXACT-LINE=%s, keep their refusal proofs=%s and GAINED the D-402-era absence check=%s | every accepted count pin stands (85/101/40/53/45/40/33/48)=%s | the audit REFUSES a planted stale runner=%s, one missing the needle=%s and one missing the open clause=%s"
		% [str(stale), str(stale.is_empty()), str(needles), str(needles.is_empty()), str(self_moved),
		   str(self_moved.is_empty()), str(own), " · ".join(suite_rows), str(suites_ok), str(d402_ok),
		   str(exact), str(refusal), str(absence), str(counts), str(refuses_stale), str(refuses_no_needle),
		   str(refuses_eight)])
	_reached("D03_every_accepted_pin_moved_together_and_refuses_stale_lines")
	return ok

# =============================================================================
# B. THE MOUSE ORDER ITSELF — items 1 to 5 of the ruling
# =============================================================================

func chk_D04_a_click_destination_is_stored_exactly_without_navigation_snapping() -> bool:
	await _rest_at(WALL_FROM)
	var rows: Array[String] = []
	var all_ok := true
	# AN ON-MESH CLICK, AN OFF-MESH CLICK INSIDE THE WEST WALL, AND ONE FAR
	# OUTSIDE THE ARENA: each stored EXACTLY, on the plane, not dropped, not
	# redirected -- and each point's nearest navigable point is measured, so it
	# is known which of them the superseded behaviour would have snapped.
	for spec in [["on the mesh", BEHIND], ["inside the west wall", Vector3(-20.5, 0.0, 0.0)],
			["far outside the arena", Vector3(0.0, 0.0, 60.0)]]:
		var p: Vector3 = spec[1]
		var redirected0 := player.commands_redirected
		var stored := player.command_move_to(p)
		var exact: bool = stored == Vector3(p.x, 0.0, p.z) and player.move_destination == stored \
			and player.click_order.destination == stored
		var not_dropped: bool = player.move_destination != null and player.click_order.active
		var not_redirected := not player.last_command_was_redirected \
			and is_zero_approx(player.last_command_redirect_m) and player.commands_redirected == redirected0
		var snap := NavService.nearest_point(nav_map, p)
		var would_snap := _planar(snap, p)
		all_ok = all_ok and exact and not_dropped and not_redirected and is_zero_approx(stored.y)
		rows.append("%s %s: stored %s exactly=%s, y %.3f (the navigation surface sits at y %.3f there), not dropped=%s, not redirected=%s; the superseded behaviour would have snapped it %.2f m"
			% [spec[0], str(p), str(stored), str(exact), stored.y, snap.y, str(not_dropped), str(not_redirected), would_snap])
		player.clear_move_destination()
	# THE CONTROL: the two off-mesh points really are off the mesh.
	var control := _planar(NavService.nearest_point(nav_map, Vector3(-20.5, 0, 0)), Vector3(-20.5, 0, 0)) > 1.0 \
		and _planar(NavService.nearest_point(nav_map, Vector3(0, 0, 60)), Vector3(0, 0, 60)) > 1.0
	await _rest_at(WALL_FROM)
	var ok := all_ok and control
	_note("D04_a_click_destination_is_stored_exactly_without_navigation_snapping",
		"%s | the two off-mesh points really are more than 1 m off the mesh, so the check covers the case snapping used to change=%s"
		% [" · ".join(rows), str(control)])
	_reached("D04_a_click_destination_is_stored_exactly_without_navigation_snapping")
	return ok

## The code-only text of the controller and of every D-404 script.
func _click_code() -> String:
	var t := _code_only(_read_text("res://scripts/control/player_controller.gd"))
	for f in D404_SCRIPTS:
		t += "\n" + _code_only(_read_text(String(f)))
	return t

const PATH_NEEDLES := ["path_between(", "nearest_point(", "map_get_path", "map_get_closest_point",
	".repath(", ".steer(", "remaining_length(", "target_position"]

static func _path_hits(code: String) -> Array:
	var out: Array = []
	for n in PATH_NEEDLES:
		if code.find(String(n)) >= 0:
			out.append(String(n))
	return out

func chk_D05_no_player_path_query_is_made_for_a_mouse_order() -> bool:
	await _rest_at(WALL_FROM)
	var repaths0 := player.follower.repaths
	var target0 := player.agent.target_position
	# THE ORDER FIRED AND TRAVELLED -- so "nothing was asked" is about a real order.
	player.command_move_to(BEHIND)
	var max_points := 0
	var g := 0
	while g < 600 and player.click_order.active:
		await physics_frame
		g += 1
		max_points = maxi(max_points, player.follower.point_count())
	var fired := player.click_order.travelled_m > 1.0
	var no_path := max_points == 0 and player.follower.repaths == repaths0 \
		and player.agent.target_position == target0 \
		and player.click_order.path_points == 0 and player.click_order.path_queries == 0
	# NOTHING IN THE CONTROLLER OR IN A D-404 SCRIPT ASKS NAVIGATION FOR A PATH,
	# A CLOSEST POINT OR A TARGET -- scanned in CODE, and the scan can fire.
	var hits := _path_hits(_click_code())
	var caught := not _path_hits("follower.repath(map, a, b)").is_empty() \
		and _path_hits(_code_only("# follower.repath(map, a, b)")).is_empty()
	# AND NOTHING RAISES THE ORDER'S TWO ZERO COUNTERS.
	# CORRECTED AT DELIVERY (D-404): this first scanned EVERY runtime file for a
	# write to any `path_points` / `path_queries`, and so caught the cohort's OWN,
	# unrelated per-member counter (`t.path_queries += 1` in mobile_cohort.gd,
	# which counts a HOUND's path queries -- D26 relies on it). The claim is about
	# the CLICK ORDER's counters, so the scan now covers the files that can reach
	# them: the controller, the four D-404 scripts and the composition root.
	var raise := RegEx.new()
	raise.compile("path_(points|queries)\\s*(\\+=|=[^=])")
	var raisers: Array[String] = []
	var reach: Array = D404_SCRIPTS.duplicate()
	reach.append("res://scripts/control/player_controller.gd")
	reach.append("res://scripts/foundation_main.gd")
	for f in reach:
		var code := _code_only(_read_text(String(f)))
		for m in raise.search_all(code):
			var line_start := code.rfind("\n", m.get_start()) + 1
			var line := code.substr(line_start, code.find("\n", m.get_start()) - line_start).strip_edges()
			if not line.begins_with("var "):
				raisers.append("%s: %s" % [String(f).get_file(), line])
	var raise_caught := raise.search("o.path_queries += 1") != null
	await _rest_at(WALL_FROM)
	var ok := fired and no_path and hits.is_empty() and caught and raisers.is_empty() and raise_caught
	_note("D05_no_player_path_query_is_made_for_a_mouse_order",
		"a click order FIRED and travelled %.2f m=%s | throughout it the player's follower held at most %d points, its repath counter did not move (%d), the NavigationAgent3D was given no target, and the order's own path counters read 0 / 0=%s | the controller and the four D-404 scripts contain NONE of %s in CODE (hits: %s), and a planted call is caught=%s | nothing in the runtime raises the two zero counters (raisers: %s), and a planted increment is caught=%s"
		% [player.click_order.travelled_m, str(fired), max_points, player.follower.repaths, str(no_path),
		   str(PATH_NEEDLES), str(hits), str(caught), str(raisers), str(raise_caught)])
	_reached("D05_no_player_path_query_is_made_for_a_mouse_order")
	return ok

func chk_D06_every_step_points_straight_at_the_clicked_destination() -> bool:
	await _set_mode("ORDINARY")
	await _rest_at(LANE_A)
	var dest := LANE_B
	player.command_move_to(dest)
	var worst := 0.0
	var steps := 0
	var prev := player.global_position
	var g := 0
	while g < 60 and player.click_order.active:
		await physics_frame
		g += 1
		var want := dest - prev
		want.y = 0.0
		if want.length() > 0.001 and player.last_wish.length() > 0.001:
			worst = maxf(worst, GroundMotion.direction_angle_deg(player.last_wish, want))
			steps += 1
		prev = player.global_position
	# RE-DERIVED FROM WHERE SHE IS NOW, NOT FROZEN AT THE CLICK: displace her
	# sideways mid-order and the very next step points at the destination from
	# the NEW place, which is a different direction from the old one.
	var before := player.last_wish
	player.global_position = player.global_position + Vector3(1.2, 0.0, 0.0)
	var displaced := player.global_position
	await physics_frame
	var want2 := dest - displaced
	want2.y = 0.0
	# CORRECTED AT DELIVERY (D-404): this first demanded the new direction differ
	# from the old by more than 5 deg; a 1.2 m sideways step 14 m short of the
	# destination turns it by 4.8 deg, so the bound -- not the behaviour -- was
	# wrong. What the claim needs is that the step follows the NEW place and not
	# the old heading: exact to the new line, and measurably off the old one.
	var rederived := GroundMotion.direction_angle_deg(player.last_wish, want2) <= TOL_DIR_DEG \
		and GroundMotion.direction_angle_deg(player.last_wish, before) > 1.0
	await _rest_at(ProductionArena.player_spawn())
	var ok := steps >= 30 and worst <= TOL_DIR_DEG and rederived
	_note("D06_every_step_points_straight_at_the_clicked_destination",
		"over %d steps the commanded direction was never more than %.6f deg from the straight line from her ground point AT THAT STEP to the clicked point (TEST BOUND %.3f deg) | displaced 1.2 m sideways mid-order, the very next step pointed at the destination from the NEW place and NOT along the old direction=%s"
		% [steps, worst, TOL_DIR_DEG, str(rederived)])
	_reached("D06_every_step_points_straight_at_the_clicked_destination")
	return ok

func chk_D07_an_unobstructed_click_travels_directly_and_arrives_normally() -> bool:
	await _set_mode("ORDINARY")
	await _rest_at(UNOBSTRUCTED_FROM)
	var arrivals0 := player.click_order.arrivals
	player.command_move_to(UNOBSTRUCTED_TO)
	var worst := 0.0
	var g := 0
	while g < 600 and player.click_order.active:
		await physics_frame
		g += 1
		worst = maxf(worst, _off_segment(player.global_position, UNOBSTRUCTED_FROM, UNOBSTRUCTED_TO))
	var arrived := player.click_order.stop_reason == DirectClickOrder.STOP_ARRIVED \
		and player.click_order.arrivals == arrivals0 + 1 and not player.click_order.has_contact \
		and _planar(player.global_position, UNOBSTRUCTED_TO) <= ProdConfig.ARRIVE_TOLERANCE_M
	# AND THE ORDER CLEARED ONCE: no second arrival over the next 30 frames.
	await _phys(30)
	var once := player.click_order.arrivals == arrivals0 + 1 and player.move_destination == null
	await _rest_at(ProductionArena.player_spawn())
	var ok := worst <= TOL_ON_LINE_M and arrived and once
	_note("D07_an_unobstructed_click_travels_directly_and_arrives_normally",
		"from %s to %s the ground point never left the straight segment by more than %.5f m (TEST BOUND %.2f m) | it ARRIVED inside the accepted %.2f m tolerance, with no contact=%s | and the order cleared ONCE=%s"
		% [str(UNOBSTRUCTED_FROM), str(UNOBSTRUCTED_TO), worst, TOL_ON_LINE_M, ProdConfig.ARRIVE_TOLERANCE_M, str(arrived), str(once)])
	_reached("D07_an_unobstructed_click_travels_directly_and_arrives_normally")
	return ok

# =============================================================================
# C. OBSTRUCTION — items 7 to 11 and 17
# =============================================================================

## One click from `from` to `to`, recording every frame's ground point.
func _trace(from: Vector3, to: Vector3, max_frames: int = 600) -> Array:
	await _rest_at(from)
	var pts: Array = [player.global_position]
	player.command_move_to(to)
	var g := 0
	while g < max_frames and player.click_order.active:
		await physics_frame
		g += 1
		pts.append(player.global_position)
	return pts

func chk_D08_a_click_behind_the_wall_moves_directly_toward_the_wall() -> bool:
	await _set_mode("ORDINARY")
	var pts := await _trace(WALL_FROM, BEHIND)
	var worst := 0.0
	var monotonic := true
	for i in range(1, pts.size()):
		worst = maxf(worst, _off_segment(Vector3(pts[i]), WALL_FROM, BEHIND))
		if Vector3(pts[i]).x < Vector3(pts[i - 1]).x - 0.0001:
			monotonic = false
	var travelled := _planar(Vector3(pts[pts.size() - 1]), WALL_FROM)
	var toward := travelled > 2.0 and monotonic
	await _rest_at(ProductionArena.player_spawn())
	var ok := worst <= TOL_ON_LINE_M and toward
	_note("D08_a_click_behind_the_wall_moves_directly_toward_the_wall",
		"a click at %s, BEHIND the long wall, from %s: over %d frames the ground point never left the straight segment by more than %.5f m (TEST BOUND %.2f m), and it closed steadily on the wall, %.2f m, never backing off=%s"
		% [str(BEHIND), str(WALL_FROM), pts.size() - 1, worst, TOL_ON_LINE_M, travelled, str(toward)])
	_reached("D08_a_click_behind_the_wall_moves_directly_toward_the_wall")
	return ok

func chk_D09_it_never_routes_around_either_end_of_the_wall() -> bool:
	await _set_mode("ORDINARY")
	var pts := await _trace(WALL_FROM, BEHIND)
	var max_abs_z := 0.0
	var max_x := -99.0
	for p in pts:
		max_abs_z = maxf(max_abs_z, absf(Vector3(p).z))
		max_x = maxf(max_x, Vector3(p).x)
	var face := _west_face_x(Vector3(pts[pts.size() - 1]).z)
	# AND HOWEVER LONG SHE IS LEFT THERE, SHE DOES NOT SET OFF ROUND IT.
	var at := player.global_position
	await _phys(120)
	var drift := _planar(player.global_position, at)
	var stayed := drift <= TOL_DRIFT_M
	# THE CONTROL: the navigation path between the same two points -- what the
	# superseded behaviour followed -- DOES leave the wall's span to get round it.
	var nav_path := NavService.path_between(nav_map, WALL_FROM, BEHIND)
	var path_z := 0.0
	for q in nav_path:
		path_z = maxf(path_z, absf(q.z))
	var control := path_z > BLOCKER_HALF_SPAN
	await _rest_at(ProductionArena.player_spawn())
	var ok := max_abs_z < BLOCKER_HALF_SPAN - ProdConfig.PLAYER_BODY_RADIUS and max_x < face and stayed and control
	_note("D09_it_never_routes_around_either_end_of_the_wall",
		"the whole order kept |z| <= %.3f m — inside the wall's span of +-%.1f m, so it never went round EITHER end — and never passed x %.3f, short of the measured west face at x %.3f | left there for 120 more frames she stayed put (%.6f m)=%s | CONTROL: the navigation path between the same points reaches |z| %.3f m, round the wall's end — what the superseded behaviour did=%s"
		% [max_abs_z, BLOCKER_HALF_SPAN, max_x, face, drift, str(stayed), path_z, str(control)])
	_reached("D09_it_never_routes_around_either_end_of_the_wall")
	return ok

func chk_D10_contact_stops_the_player_at_the_correct_collision_boundary() -> bool:
	await _set_mode("ORDINARY")
	var _pts := await _trace(WALL_FROM, BEHIND)
	var o := player.click_order
	var gp := player.global_position
	# THE CONTACT THE ENGINE REPORTED: one body radius from her ground point.
	var to_contact := _planar(gp, o.contact_point)
	var from_report := absf(to_contact - ProdConfig.PLAYER_BODY_RADIUS)
	# AN INDEPENDENT RAY, fired from her centre along the wall's normal.
	var face := _west_face_x(gp.z)
	var gap := face - gp.x
	var by_ray := gap - ProdConfig.PLAYER_BODY_RADIUS
	var normal_ok := GroundMotion.direction_angle_deg(o.contact_normal, Vector3(-1, 0, 0)) < 1.0
	await _rest_at(ProductionArena.player_spawn())
	var ok := o.has_contact and from_report <= TOL_BOUNDARY_M and by_ray >= -player.safe_margin \
		and by_ray <= TOL_BOUNDARY_M and normal_ok
	_note("D10_contact_stops_the_player_at_the_correct_collision_boundary",
		"stopped with her ground point %.4f m from the reported contact point (one body radius is %.2f m; off by %.4f, TEST BOUND %.2f) | an INDEPENDENT ray finds the wall's face %.4f m from her centre: the gap exceeds one radius by %+.4f m (a negative figure is overlap, bounded by the engine's own %.3f m collision margin) | the contact normal faces west=%s"
		% [to_contact, ProdConfig.PLAYER_BODY_RADIUS, from_report, TOL_BOUNDARY_M, gap, by_ray, player.safe_margin, str(normal_ok)])
	_reached("D10_contact_stops_the_player_at_the_correct_collision_boundary")
	return ok

func chk_D11_perpendicular_contact_produces_no_penetration() -> bool:
	var rows: Array[String] = []
	var all_ok := true
	for mode in MODES:
		await _set_mode(String(mode))
		var _pts := await _trace(PERP_FROM, PERP_TO)
		var face := _west_face_x(player.global_position.z)
		var penetration := ProdConfig.PLAYER_BODY_RADIUS - (face - player.global_position.x)
		var this_ok := player.click_order.stop_reason == DirectClickOrder.STOP_COLLIDED \
			and penetration <= player.safe_margin \
			and absf(player.global_position.z - PERP_FROM.z) <= 0.0001
		all_ok = all_ok and this_ok
		rows.append("%s: COLLIDED head-on, penetration %.5f m (the engine margin is %.3f m), sideways drift %.6f m"
			% [mode, penetration, player.safe_margin, absf(player.global_position.z - PERP_FROM.z)])
	await _set_mode("ORDINARY")
	await _rest_at(ProductionArena.player_spawn())
	_note("D11_perpendicular_contact_produces_no_penetration",
		"straight at the wall's normal, at every diagnostic speed: %s — no penetration beyond the engine's own collision margin, and no sideways drift"
		% " · ".join(rows))
	_reached("D11_perpendicular_contact_produces_no_penetration")
	return all_ok

func chk_D12_angled_contact_produces_no_tangential_wall_sliding() -> bool:
	await _set_mode("ORDINARY")
	var _pts := await _trace(GLANCE_FROM, GLANCE_TO)
	var collided := player.click_order.stop_reason == DirectClickOrder.STOP_COLLIDED
	var at := player.global_position
	var along := 0.0
	for i in 60:
		await physics_frame
		along = maxf(along, absf(player.global_position.z - at.z))
	var angle := GroundMotion.direction_angle_deg(GLANCE_TO - GLANCE_FROM, Vector3(0, 0, 1))
	# THE NEGATIVE CONTROL: the ACCEPTED move_and_slide(), on the identical
	# approach, driven by the STICK -- it SLIDES, so this check can fail.
	await _rest_at(GLANCE_FROM)
	player.intent.debug_move_axis = _stick_for(GLANCE_TO - GLANCE_FROM)
	var z0 := player.global_position.z
	await _phys(90)
	var slid := player.global_position.z - z0
	player.intent.debug_move_axis = Vector2.ZERO
	var control := slid > 3.0 and player.global_position.x < _west_face_x(player.global_position.z)
	await _rest_at(ProductionArena.player_spawn())
	var ok := collided and along <= TOL_DRIFT_M and control
	_note("D12_angled_contact_produces_no_tangential_wall_sliding",
		"a click %.1f deg off the wall's own line, from %s to %s, stopped at contact (COLLIDED=%s) and travelled %.6f m ALONG the wall in the 60 frames after (TEST BOUND %.3f m) | NEGATIVE CONTROL: the accepted move_and_slide() on the same approach, via the stick, SLID %.2f m along the wall — so the check could fail=%s"
		% [angle, str(GLANCE_FROM), str(GLANCE_TO), str(collided), along, TOL_DRIFT_M, slid, str(control)])
	_reached("D12_angled_contact_produces_no_tangential_wall_sliding")
	return ok

func chk_D13_the_blocked_movement_order_is_cleared() -> bool:
	await _set_mode("ORDINARY")
	await _rest_at(WALL_FROM)
	var collisions0 := player.click_order.collisions
	player.command_move_to(BEHIND)
	var cleared_same_frame := false
	var g := 0
	while g < 600 and player.click_order.active:
		await physics_frame
		g += 1
		if not player.click_order.active:
			cleared_same_frame = player.move_destination == null \
				and player.click_order.stop_reason == DirectClickOrder.STOP_COLLIDED \
				and player.motor.speed() <= 0.0 and player.velocity.length() <= 0.0
	var counted := player.click_order.collisions == collisions0 + 1 and player.click_order.has_contact
	# NO STALE ORDER RESTARTS IT: nothing held, 60 frames later she has not moved.
	var at := player.global_position
	await _phys(60)
	var no_restart := _planar(player.global_position, at) <= TOL_DRIFT_M and player.move_destination == null
	await _rest_at(ProductionArena.player_spawn())
	var ok := cleared_same_frame and counted and no_restart
	_note("D13_the_blocked_movement_order_is_cleared",
		"on the frame the order ended it had NO destination, stopped COLLIDED, and she was at rest (motor and body)=%s | exactly one collision was counted and the contact recorded=%s | 60 frames later, with nothing held, no stale order restarted her=%s"
		% [str(cleared_same_frame), str(counted), str(no_restart)])
	_reached("D13_the_blocked_movement_order_is_cleared")
	return ok

## Holds the button with the cursor at `to`, from `from`, for `frames` frames.
## Returns [contact position or null, max displacement after contact, lateral
## sign reversals after contact, orders issued while holding, max |z|].
func _hold(from: Vector3, to: Vector3, frames: int) -> Array:
	await _rest_at(from)
	var issued0 := player.click_order.orders_issued
	cam.debug_cursor_override = to
	player.intent.debug_move_command_held = true
	var contact_at = null
	var maxd := 0.0
	var reversals := 0
	var last_sign := 0.0
	var max_z := 0.0
	for i in frames:
		await physics_frame
		max_z = maxf(max_z, absf(player.global_position.z))
		if contact_at == null and player.click_order.stop_reason == DirectClickOrder.STOP_COLLIDED:
			contact_at = player.global_position
		elif contact_at != null:
			var d: Vector3 = player.global_position - Vector3(contact_at)
			maxd = maxf(maxd, Vector2(d.x, d.z).length())
			var sgn := signf(d.z) if absf(d.z) > 0.00001 else 0.0
			if sgn != 0.0 and last_sign != 0.0 and sgn != last_sign:
				reversals += 1
			if sgn != 0.0:
				last_sign = sgn
	var issued := player.click_order.orders_issued - issued0
	player.intent.clear_seams()
	cam.debug_cursor_override = null
	return [contact_at, maxd, reversals, issued, max_z]

func chk_D14_holding_behind_the_wall_cannot_creep_oscillate_or_route() -> bool:
	await _set_mode("ORDINARY")
	var straight := await _hold(WALL_FROM, BEHIND, 360)
	var glancing := await _hold(GLANCE_FROM, GLANCE_TO, 360)
	var rows: Array[String] = []
	var all_ok := true
	for spec in [["straight", straight], ["glancing", glancing]]:
		var r: Array = spec[1]
		var this_ok: bool = r[0] != null and float(r[1]) <= TOL_DRIFT_M and int(r[2]) == 0 \
			and int(r[3]) >= 300 and float(r[4]) < BLOCKER_HALF_SPAN - ProdConfig.PLAYER_BODY_RADIUS \
			and player.follower.point_count() == 0
		all_ok = all_ok and this_ok
		rows.append("%s: reached the wall=%s, then %.6f m of travel (creeping), %d lateral reversals (oscillation), max |z| %.3f (routing) while the HELD button re-issued %d orders"
			% [spec[0], str(r[0] != null), float(r[1]), int(r[2]), float(r[4]), int(r[3])])
	await _rest_at(ProductionArena.player_spawn())
	_note("D14_holding_behind_the_wall_cannot_creep_oscillate_or_route",
		"the button HELD for 360 frames with the cursor behind the wall — %s | TEST BOUNDS: at most %.3f m of travel after contact, ZERO reversals, never beyond the wall's span, and the hold REALLY re-issued an order at least 300 times (so 'nothing happened' is about a live request)"
		% [" · ".join(rows), TOL_DRIFT_M])
	_reached("D14_holding_behind_the_wall_cannot_creep_oscillate_or_route")
	return all_ok

func chk_D15_a_new_click_parallel_to_or_away_from_the_wall_moves_immediately() -> bool:
	await _set_mode("ORDINARY")
	var rows: Array[String] = []
	var all_ok := true
	for spec in [["parallel", Vector3(0, 0, 2.0)], ["away", Vector3(-2.5, 0, 0)]]:
		var _pts := await _trace(WALL_FROM, BEHIND)
		var blocked := player.click_order.stop_reason == DirectClickOrder.STOP_COLLIDED
		var p0 := player.global_position
		player.command_move_to(p0 + Vector3(spec[1]))
		await physics_frame
		var first := _planar(player.global_position, p0)
		var speed1 := player.motor.speed()
		await _phys(30)
		var later := _planar(player.global_position, p0)
		var this_ok := blocked and first > 0.0 and speed1 > 0.0 and later > 1.0 \
			and not player.click_order.has_contact
		all_ok = all_ok and this_ok
		rows.append("%s: from a COLLIDED stop at the wall, the FIRST frame moved her %.5f m at %.3f m/s, and 31 frames later %.3f m, no contact=%s"
			% [spec[0], first, speed1, later, str(this_ok)])
	await _rest_at(ProductionArena.player_spawn())
	_note("D15_a_new_click_parallel_to_or_away_from_the_wall_moves_immediately",
		"%s | a click that does not point INTO the wall is never held by the remembered contact" % " · ".join(rows))
	_reached("D15_a_new_click_parallel_to_or_away_from_the_wall_moves_immediately")
	return all_ok

func chk_D16_a_new_click_on_the_other_side_still_does_not_bypass_the_wall() -> bool:
	await _set_mode("ORDINARY")
	var _pts := await _trace(WALL_FROM, BEHIND)
	var first_stop := player.click_order.stop_reason == DirectClickOrder.STOP_COLLIDED
	var p0 := player.global_position
	player.command_move_to(BEHIND_OTHER)
	var max_x := -99.0
	var max_z := 0.0
	var g := 0
	while g < 600 and player.click_order.active:
		await physics_frame
		g += 1
		max_x = maxf(max_x, player.global_position.x)
		max_z = maxf(max_z, absf(player.global_position.z))
	await _phys(30)
	var face := _west_face_x(player.global_position.z)
	var ok := first_stop and player.click_order.stop_reason == DirectClickOrder.STOP_COLLIDED \
		and max_x < face and max_z < BLOCKER_HALF_SPAN and player.follower.point_count() == 0
	await _rest_at(ProductionArena.player_spawn())
	_note("D16_a_new_click_on_the_other_side_still_does_not_bypass_the_wall",
		"stopped at the wall, a SECOND click at another point behind it, %s, did not bypass it: it ended %s, never past x %.3f (the face is at %.3f), never beyond |z| %.3f, and still no path=%s"
		% [str(BEHIND_OTHER), player.click_order.stop_reason, max_x, face, max_z, str(ok)])
	_reached("D16_a_new_click_on_the_other_side_still_does_not_bypass_the_wall")
	return ok

func chk_D17_a_solid_body_blocks_a_click_exactly_as_world_geometry_does() -> bool:
	await _set_mode("ORDINARY")
	await _rest_at(LANE_A)
	# ONE FROZEN ENEMY, a SOLID body on layer 2, set in the middle of the open lane.
	var e: OrdinaryEnemy = enemies[0]
	e.debug_freeze_ai = true
	var blocker_at := LANE_A + Vector3(0, 0, 6.0)
	e.global_position = blocker_at
	await _phys(3)
	player.command_move_to(LANE_B)
	await _until(func() -> bool: return not player.click_order.active, 600)
	var o := player.click_order
	var by_enemy := o.stop_reason == DirectClickOrder.STOP_COLLIDED and o.contact_collider == String(e.name)
	var gap := _planar(player.global_position, e.global_position)
	var at := player.global_position
	await _phys(60)
	var no_slide := _planar(player.global_position, at) <= TOL_DRIFT_M
	var short := player.global_position.z < blocker_at.z
	_park_enemies()
	await _rest_at(ProductionArena.player_spawn())
	var ok := by_enemy and short and no_slide and gap < ProdConfig.PLAYER_BODY_RADIUS * 2.0 + 0.2
	_note("D17_a_solid_body_blocks_a_click_exactly_as_world_geometry_does",
		"a frozen enemy set across the open lane stopped the order: COLLIDED against '%s'=%s, short of it=%s, centres %.3f m apart, and no slide round it in 60 frames=%s"
		% [o.contact_collider, str(by_enemy), str(short), gap, str(no_slide)])
	_reached("D17_a_solid_body_blocks_a_click_exactly_as_world_geometry_does")
	return ok

func chk_D18_no_tunnelling_at_ordinary_fast_and_extreme_speed() -> bool:
	var rows: Array[String] = []
	var all_ok := true
	for mode in MODES:
		await _set_mode(String(mode))
		var pts := await _trace(Vector3(-12.5, 0, 0.3), BEHIND)
		var face := _west_face_x(0.4)
		var max_x := -99.0
		for p in pts:
			max_x = maxf(max_x, Vector3(p).x)
		var step_m := _top() * DT
		var this_ok := player.click_order.stop_reason == DirectClickOrder.STOP_COLLIDED and max_x < face
		all_ok = all_ok and this_ok
		rows.append("%s (%.3f m per step at full speed): never past x %.4f — the face is at %.4f=%s"
			% [mode, step_m, max_x, face, str(this_ok)])
	# THE NEGATIVE CONTROL: ONE step far longer than any diagnostic speed makes,
	# swept by the SAME function from just in front of the wall. A TELEPORT of that
	# step would end BEYOND the wall's far face; the sweep stops at the near one.
	await _set_mode("ORDINARY")
	await _rest_at(Vector3(-8.2, 0, 0.4))
	var west := _west_face_x(0.4)
	var east := _east_face_x(0.4)
	var motion := Vector3(3.0, 0, 0)
	var teleport_end := player.global_position.x + motion.x
	var r := DirectClickOrder.sweep(player, motion)
	player.global_position.y = 0.0
	var ended_x := player.global_position.x
	var control := teleport_end - ProdConfig.PLAYER_BODY_RADIUS > east and bool(r["blocked"]) \
		and ended_x < west
	await _rest_at(ProductionArena.player_spawn())
	var ok := all_ok and control
	_note("D18_no_tunnelling_at_ordinary_fast_and_extreme_speed",
		"%s | NEGATIVE CONTROL: from x %.2f, a single 3.0 m step — longer than any speed here makes in a frame — would TELEPORT her to x %.2f, past the wall's far face at %.3f; the sweep stopped her at the near face instead (blocked=%s, ended x %.3f, face %.3f)=%s"
		% [" · ".join(rows), -8.2, teleport_end, east, str(r["blocked"]), ended_x, west, str(control)])
	_reached("D18_no_tunnelling_at_ordinary_fast_and_extreme_speed")
	return ok

# =============================================================================
# D. OPEN SPACE IS UNCHANGED — item 6, and items 15 and 16
# =============================================================================

func chk_D19_open_space_motion_equals_the_accepted_arithmetic_exactly() -> bool:
	await _set_mode("ORDINARY")
	await _rest_at(LANE_A)
	player.command_move_to(LANE_B)
	var worst_v := 0.0
	var worst_p := 0.0
	var steps := 0
	for i in 40:
		var v0 := player.motor.velocity
		var p0 := player.global_position
		await physics_frame
		if not player.click_order.active:
			break
		var w := player.last_wish
		var top := _top()
		var cap := minf(top, GroundMotion.arrival_speed_ceiling(_planar(p0, LANE_B), top))
		var expect := GroundMotion.step_velocity(v0, w, top, DT, cap)
		worst_v = maxf(worst_v, (player.motor.velocity - expect).length())
		var moved := player.global_position - p0
		moved.y = 0.0
		worst_p = maxf(worst_p, (moved - player.motor.velocity * DT).length())
		steps += 1
	var gradual := steps >= 30
	# A NEW CLICK IN OPEN SPACE REDIRECTS IN THE SAME FRAME, SPEED PRESERVED.
	var moving := player.motor.speed()
	var before := player.motor.velocity.normalized()
	player.command_move_to(LANE_A)
	await physics_frame
	var after := player.motor.velocity
	var turned := GroundMotion.direction_angle_deg(before, after)
	var off := GroundMotion.direction_angle_deg(after, player.last_wish)
	var kept := absf(after.length() - moving) <= 0.02 * _top()
	await _rest_at(ProductionArena.player_spawn())
	var ok := gradual and worst_v <= 1.0e-5 and worst_p <= 1.0e-4 and moving > 0.95 * ProdConfig.TOP_SPEED_MPS \
		and turned > 170.0 and off <= TOL_REDIRECT_DEG and kept
	_note("D19_open_space_motion_equals_the_accepted_arithmetic_exactly",
		"over %d open-space steps of a click order, the motor's velocity differed from the ACCEPTED GroundMotion.step_velocity() on the same inputs by at most %.9f m/s (TEST BOUND 0.00001), and the body moved by exactly velocity x delta, to within %.9f m (TEST BOUND 0.0001) — so no collision response intervened in open space | a new click at %.3f m/s turned the velocity %.2f deg in ONE frame, %.6f deg off the commanded direction, speed kept=%s — the accepted same-frame redirection, unchanged"
		% [steps, worst_v, worst_p, moving, turned, off, str(kept)])
	_reached("D19_open_space_motion_equals_the_accepted_arithmetic_exactly")
	return ok

func chk_D20_arrival_is_unchanged_at_every_speed() -> bool:
	var rows: Array[String] = []
	var all_ok := true
	var never_binds := true
	for mode in MODES:
		await _set_mode(String(mode))
		await _rest_at(LANE_A)
		var dest := LANE_A + Vector3(0, 0, 12.0)
		var arrivals0 := player.click_order.arrivals
		player.command_move_to(dest)
		var g := 0
		while g < 900 and not (player.move_destination == null and player.motor.speed() <= 0.0):
			if String(mode) == "ORDINARY" and player.move_destination != null:
				var top := _top()
				if GroundMotion.arrival_speed_ceiling(_planar(player.global_position, dest), top) < top \
						and _planar(player.global_position, dest) > ProdConfig.ARRIVE_TOLERANCE_M:
					never_binds = false
			await physics_frame
			g += 1
		await _phys(20)
		var overshoot := player.global_position.z - dest.z
		var once := player.click_order.arrivals == arrivals0 + 1
		var this_ok := overshoot <= 0.05 and once and player.motor.speed() <= 0.0 \
			and _planar(player.global_position, dest) <= ProdConfig.ARRIVE_TOLERANCE_M
		all_ok = all_ok and this_ok
		rows.append("%s: at rest %+.4f m past the click, cleared once=%s" % [mode, overshoot, str(once)])
	await _set_mode("ORDINARY")
	await _rest_at(ProductionArena.player_spawn())
	var ok := all_ok and never_binds
	_note("D20_arrival_is_unchanged_at_every_speed",
		"%s | TEST BOUND: no more than 0.05 m past the destination, inside the accepted %.2f m tolerance | at ORDINARY the accepted arrival ceiling — now reading the straight distance — never bound above the tolerance=%s"
		% [" · ".join(rows), ProdConfig.ARRIVE_TOLERANCE_M, str(never_binds)])
	_reached("D20_arrival_is_unchanged_at_every_speed")
	return ok

# =============================================================================
# E. WHAT MUST NOT CHANGE — items 12 to 16, and the navigation scope
# =============================================================================

func chk_D21_controller_stick_movement_is_unchanged_and_still_slides() -> bool:
	await _set_mode("ORDINARY")
	# THE STICK STILL SLIDES ALONG THE WALL, exactly as accepted (L20).
	await _rest_at(GLANCE_FROM)
	player.intent.debug_move_axis = _stick_for(GLANCE_TO - GLANCE_FROM)
	var z0 := player.global_position.z
	await _phys(90)
	var slid := player.global_position.z - z0
	var not_through := player.global_position.x < _west_face_x(player.global_position.z)
	var no_click := player.click_order.orders_issued >= 0 and player.move_destination == null
	player.intent.debug_move_axis = Vector2.ZERO
	# A STICK INPUT STILL CANCELS A CLICK ORDER.
	await _rest_at(LANE_A)
	player.command_move_to(LANE_B)
	await _phys(5)
	player.intent.debug_move_axis = Vector2(1.0, 0.0)
	await _phys(2)
	var cancelled := player.click_order.stop_reason == DirectClickOrder.STOP_CANCELLED and player.move_destination == null \
		and player.motor.speed() > 0.0
	player.intent.debug_move_axis = Vector2.ZERO
	# AND IN CODE: the stick branch is the accepted one, and the stick resolves
	# collision with the accepted `move_and_slide()` -- still called exactly once.
	var ctrl := _code_only(_read_text("res://scripts/control/player_controller.gd"))
	var wish := _function_body(ctrl, "_wish_direction")
	var stick_same := wish.find("clear_move_destination()            # a stick input cancels a click order") >= 0 \
		and wish.find("return (right * intent.move_axis.x + fwd * -intent.move_axis.y).limit_length(1.0)") >= 0
	var slide_once := ctrl.count("move_and_slide()") == 1 and _function_body(ctrl, "step").find("else:\n\t\tmove_and_slide()") >= 0
	await _rest_at(ProductionArena.player_spawn())
	var ok := slid > 3.0 and not_through and no_click and cancelled and stick_same and slide_once
	_note("D21_controller_stick_movement_is_unchanged_and_still_slides",
		"the STICK driven into the wall at the glancing angle SLID %.2f m along it and did not pass through=%s — the accepted behaviour, untouched | a stick input still CANCELS a click order=%s | the stick branch of _wish_direction is the accepted code=%s, and move_and_slide() is still called exactly once, on every step that is not a click step=%s"
		% [slid, str(not_through), str(cancelled), str(stick_same), str(slide_once)])
	_reached("D21_controller_stick_movement_is_unchanged_and_still_slides")
	return ok

func chk_D22_aim_stays_independent_of_the_click_order() -> bool:
	await _set_mode("ORDINARY")
	await _rest_at(LANE_A)
	player.command_move_to(LANE_B)
	await _phys(10)
	var dest_before = player.move_destination
	var aim0 := player.aim_dir
	# AIM HARD RIGHT WITH THE AIM STICK, while the order runs north.
	player.intent.debug_aim_axis = Vector2(1.0, 0.0)
	await _phys(40)
	var dest_same: bool = player.move_destination != null and player.move_destination == dest_before
	var aim_moved := GroundMotion.direction_angle_deg(aim0, player.aim_dir) > 30.0
	var vel_dir := player.motor.velocity
	var aim_yaw := YawDriver.yaw_to(player.aim_dir)
	var yaw_err := rad_to_deg(absf(wrapf(player.visual.rotation.y - aim_yaw, -PI, PI)))
	var facing_follows_aim := yaw_err < 2.0 and GroundMotion.direction_angle_deg(vel_dir, player.aim_dir) > 30.0
	player.intent.debug_aim_axis = null
	# AND MOVING DOES NOT MOVE THE AIM: with no aim input, the order's own travel
	# never writes the aim.
	var ctrl := _code_only(_read_text("res://scripts/control/player_controller.gd"))
	var no_aim_write := _function_body(ctrl, "_direct_click_step").find("aim_") < 0 \
		and _function_body(ctrl, "command_move_to").find("aim_") < 0
	await _rest_at(ProductionArena.player_spawn())
	var ok := dest_same and aim_moved and facing_follows_aim and no_aim_write
	_note("D22_aim_stays_independent_of_the_click_order",
		"aiming 90 deg off the click order's travel left the destination unchanged=%s while the aim really moved=%s | the visual still faces the AIM (%.2f deg off it), not the feet — D-401's accepted independent movement-and-aim behaviour=%s | no D-404 code path writes the aim=%s"
		% [str(dest_same), str(aim_moved), yaw_err, str(facing_follows_aim), str(no_aim_write)])
	_reached("D22_aim_stays_independent_of_the_click_order")
	return ok

func chk_D23_stop_commitment_and_the_action_brake_are_unchanged() -> bool:
	await _set_mode("ORDINARY")
	await _rest_at(LANE_A)
	player.command_move_to(LANE_B)
	await _until(func() -> bool: return player.motor.speed() >= 0.98 * _top() \
		and _planar(player.global_position, LANE_A) > 3.0, 600)
	var v := player.motor.speed()
	var p0 := player.global_position
	player._cooldown = 0.0
	player.begin_attack()
	var cleared_same_frame: bool = player.move_destination == null \
		and player.click_order.stop_reason == DirectClickOrder.STOP_CANCELLED \
		and player.commitment.suppresses_translation()
	await _until(func() -> bool: return player.motor.speed() <= 0.0, 120)
	var d := _planar(player.global_position, p0)
	var expect := v * v / (2.0 * ProdConfig.ACTION_BRAKE_MPS2)
	var brake_ok := absf(d - expect) <= v * DT + 0.005
	await _until(func() -> bool: return not player.commitment.active, 120)
	var at := player.global_position
	await _phys(30)
	var no_restart := _planar(player.global_position, at) <= TOL_DRIFT_M
	var accepted := is_equal_approx(ProdConfig.ACTION_BRAKE_MPS2, 120.0) \
		and _read_text("res://scripts/control/locomotion_motor.gd").sha256_text() \
			== "e5b45fccfdc90d413f15a4ddc14fefbcdb19ce78d467f9a8dca1ae1e4210f22b" \
		and FileAccess.get_sha256("res://scripts/control/action_commitment.gd") \
			== "5936706e90594d716db5b2d523cb1e610a7eb0b4045f5584243791bc1f538010"
	await _rest_at(ProductionArena.player_spawn())
	var ok := cleared_same_frame and brake_ok and no_restart and accepted
	_note("D23_stop_commitment_and_the_action_brake_are_unchanged",
		"an action begun at %.3f m/s mid-order CANCELLED the click order and suppressed translation on the SAME frame=%s | she stopped in %.4f m, against v^2 / (2 x %.1f) = %.4f m at the accepted, unscaled, gradual ACTION brake=%s | nothing restarted her after recovery=%s | ACTION_BRAKE_MPS2 is 120.0 and locomotion_motor.gd and action_commitment.gd are byte-identical to their pre-D-404 hashes=%s"
		% [v, str(cleared_same_frame), d, ProdConfig.ACTION_BRAKE_MPS2, expect, str(brake_ok), str(no_restart), str(accepted)])
	_reached("D23_stop_commitment_and_the_action_brake_are_unchanged")
	return ok

func chk_D24_buffered_movement_still_applies_at_release_as_a_direct_order() -> bool:
	await _set_mode("ORDINARY")
	await _rest_at(LANE_A)
	var point := LANE_A + Vector3(0.6, 0, 5.0)
	var buffered0 := player.buffered_moves
	var applied0 := player.buffered_applied
	player._cooldown = 0.0
	player.begin_attack()
	await physics_frame
	# CLICK DURING THE WIND-UP: held, with the cursor at `point`.
	cam.debug_cursor_override = point
	player.intent.debug_move_command_held = true
	var p0 := player.global_position
	var windup_moved := 0.0
	var shots0 := player.shots_fired
	# CORRECTED AT DELIVERY (D-404): the loop first measured the frame ON WHICH the
	# release happened -- and on that frame the ACCEPTED recovery cancellation
	# already lets a held click move her one step (0.0083 m), which F82 accepts.
	# The wind-up is every frame BEFORE the release, so the measurement stops
	# the moment the bolt is released.
	while player.commitment.active and not player.commitment.cancel_window_open():
		await physics_frame
		if player.shots_fired > shots0:
			break
		windup_moved = maxf(windup_moved, _planar(player.global_position, p0))
	var buffered := player.buffered_moves > buffered0
	await _until(func() -> bool: return not player.commitment.active, 60)
	var applied := player.buffered_applied > applied0
	var dest_exact: bool = player.move_destination != null and player.move_destination == Vector3(point.x, 0.0, point.z)
	player.intent.clear_seams()
	cam.debug_cursor_override = null
	await _phys(20)
	var moving_to := _planar(player.global_position, point) < _planar(p0, point)
	var no_path := player.follower.point_count() == 0 and player.click_order.path_points == 0
	await _rest_at(ProductionArena.player_spawn())
	var ok := windup_moved <= 0.001 and buffered and applied and dest_exact and moving_to and no_path
	_note("D24_buffered_movement_still_applies_at_release_as_a_direct_order",
		"a click during the WIND-UP moved her %.5f m (none) and was BUFFERED=%s | at the release the buffer was APPLIED=%s as a DIRECT order to exactly the clicked point, unsnapped=%s, and she set off toward it=%s with no path=%s"
		% [windup_moved, str(buffered), str(applied), str(dest_exact), str(moving_to), str(no_path)])
	_reached("D24_buffered_movement_still_applies_at_release_as_a_direct_order")
	return ok

func chk_D25_splinter_shot_and_cinder_field_releases_survive_recovery_cancellation() -> bool:
	await _set_mode("ORDINARY")
	# --- SPLINTER SHOT: aim down the open lane, release, then CLICK to move. ---
	await _rest_at(LANE_A)
	skills.clear_cooldowns()
	skills.pool.refill()
	cam.debug_cursor_override = LANE_A + Vector3(0, 0, 8.0)
	await _phys(2)
	var released0 := hr.arrows_released
	var cancels0 := player.commitment.recovery_cancels
	var r := skills.use_binding(HuntressContent.BINDING_INDEX)
	await _until(func() -> bool: return hr.arrows_released > released0, 120)
	var arrow: SplinterArrow = hr.arrows.back() if not hr.arrows.is_empty() else null
	var released := arrow != null and player.commitment.active and player.commitment.cancel_window_open()
	var t0 := arrow.travelled if arrow != null else -1.0
	cam.debug_cursor_override = LANE_A + Vector3(2.0, 0, 0.0)
	player.intent.debug_move_command_held = true
	await _until(func() -> bool: return not player.commitment.active, 30)
	var cancelled := player.commitment.recovery_cancels == cancels0 + 1
	await _phys(4)
	var arrow_ok := arrow != null and is_instance_valid(arrow) and arrow.alive and arrow.travelled > t0 \
		and hr.arrows_released == released0 + 1
	player.intent.clear_seams()
	cam.debug_cursor_override = null
	# --- CINDER FIELD: place, release, then CLICK to move. -------------------
	await _rest_at(Vector3(-11.0, 0.0, 3.0))
	cinder.dismiss_all()
	skills.clear_cooldowns()
	skills.pool.refill()
	cam.debug_cursor_override = Vector3(-11.0, 0.0, 6.0)
	await _phys(2)
	var placements0 := cinder.placements
	var cancels1 := player.commitment.recovery_cancels
	skills.use_binding(CinderContent.BINDING_INDEX)
	await _until(func() -> bool: return cinder.placements > placements0, 240)
	var trap: CinderTrap = cinder.live_nodes.back() if not cinder.live_nodes.is_empty() else null
	var placed := trap != null and player.commitment.active and player.commitment.cancel_window_open()
	var where := trap.global_position if trap != null else Vector3.ZERO
	cam.debug_cursor_override = Vector3(-13.0, 0.0, 3.0)
	player.intent.debug_move_command_held = true
	await _until(func() -> bool: return not player.commitment.active, 30)
	var cancelled2 := player.commitment.recovery_cancels == cancels1 + 1
	await _phys(4)
	var trap_ok := trap != null and is_instance_valid(trap) and cinder.placements == placements0 + 1 \
		and _planar(trap.global_position, where) <= 0.0001
	player.intent.clear_seams()
	cam.debug_cursor_override = null
	cinder.dismiss_all()
	await _rest_at(ProductionArena.player_spawn())
	var ok := bool(r["ok"]) and released and cancelled and arrow_ok and placed and cancelled2 and trap_ok
	_note("D25_splinter_shot_and_cinder_field_releases_survive_recovery_cancellation",
		"SPLINTER SHOT: released with the cancel window OPEN=%s; a CLICK cancelled the remaining recovery=%s; the released arrow SURVIVED and kept flying=%s | CINDER FIELD: the trap was placed with the window OPEN=%s; a CLICK cancelled the recovery=%s; the trap SURVIVED, unmoved and not duplicated=%s. CANCELLING AN ANIMATION IS NOT CANCELLING A RELEASE."
		% [str(released), str(cancelled), str(arrow_ok), str(placed), str(cancelled2), str(trap_ok)])
	_reached("D25_splinter_shot_and_cinder_field_releases_survive_recovery_cancellation")
	return ok

func chk_D26_enemies_and_hounds_still_use_their_accepted_navigation_paths() -> bool:
	await _set_mode("ORDINARY")
	# --- AN ENEMY, released, chases her ACROSS the blocker: it must route. ---
	await _rest_at(Vector3(-4.2, 0.0, 0.3))
	var e: OrdinaryEnemy = enemies[0]
	e.global_position = Vector3(-10.0, 0.0, 0.3)
	var repaths0 := e.follower.repaths
	e.debug_freeze_ai = false
	var max_points := 0
	var max_z := 0.0
	for i in 240:
		await physics_frame
		max_points = maxi(max_points, e.follower.point_count())
		max_z = maxf(max_z, absf(e.global_position.z))
	var enemy_routes := e.follower.repaths > repaths0 and max_points >= 3 and max_z > BLOCKER_HALF_SPAN
	_park_enemies()
	# --- THE HOUNDS reach her across the blocker by their accepted paths. ----
	# CORRECTED AT DELIVERY (D-404): this first had her cross by hand with the
	# pack at her heels -- and the cohort, by its ACCEPTED rule, queries a path
	# only when the STRAIGHT line to a slot is not walkable. Following her closely
	# it never was, so 0 queries proved nothing either way. The pack is now stood
	# on the FAR side of the wall from her, where only a path can reach her.
	await _rest_at(Vector3(-4.2, 0.0, 0.3))
	await _phys(30)
	var queries0 := 0
	for t in hounds.cohort.tracks:
		queries0 += int((t as MobileCohort.Track).path_queries)
	var k := 0
	for h in hounds.pack:
		if is_instance_valid(h):
			(h as Node3D).global_position = Vector3(-9.6, 0.0, 0.3 - 0.8 * float(k))
			k += 1
	var hound_points := 0
	for i in 180:
		await physics_frame
		for t2 in hounds.cohort.tracks:
			hound_points = maxi(hound_points, (t2 as MobileCohort.Track).follower.point_count())
	var queries1 := 0
	for t3 in hounds.cohort.tracks:
		queries1 += int((t3 as MobileCohort.Track).path_queries)
	var hounds_path := queries1 > queries0 and hound_points >= 2
	# AND THEIR CODE IS BYTE-IDENTICAL.
	var same := FileAccess.get_sha256("res://scripts/combat/ordinary_enemy.gd") == "bc77f3aaeb79b1948b4f031c099111ef961df8a9b6284464ac6cb18be535619e" \
		and FileAccess.get_sha256("res://scripts/world/nav_service.gd") == "6eba15fe4ca331069f4211b85210536b70b130adeec8d989fa15dc6aeef5fa6d" \
		and FileAccess.get_sha256("res://scripts/cohort/mobile_cohort.gd") == "6069da3c318646bf83fc26c982d353386a18e5ca981f966773c797883289decd" \
		and FileAccess.get_sha256("res://scripts/cohort/cohort_formation.gd") == "40501a0203cb92577faf1f91751080e34a55a66a3c6e1ad5f03875d0aa2182e2" \
		and FileAccess.get_sha256("res://scripts/hounds/kindred_hound.gd") == "078efcc3f73913b87304873bcb7696c3c51475f70dffd03c3835ffe2ef75334e" \
		and FileAccess.get_sha256("res://scripts/hounds/hound_targeting.gd") == "3cb568a932002dcfe599faf03aae0bb63edb23fca01683fa5232d11ec4fddb61" \
		and FileAccess.get_sha256("res://scripts/hounds/hound_runtime.gd") == "aeb47c67d51437bd4373603838e0ca8ef16993f9945532632d32a7b3454ea77d"
	await _rest_at(ProductionArena.player_spawn())
	var ok := enemy_routes and hounds_path and same
	_note("D26_enemies_and_hounds_still_use_their_accepted_navigation_paths",
		"an ENEMY chasing her across the blocker repathed (%d -> %d), held paths of up to %d points and routed round the wall's end to |z| %.2f=%s | the HOUNDS, stood on the FAR side of the wall from her so only a path could reach her, made %d new path queries and held paths of up to %d points=%s | the enemy, navigation, cohort and hound code is byte-identical to its pre-D-404 hashes=%s"
		% [repaths0, e.follower.repaths, max_points, max_z, str(enemy_routes), queries1 - queries0, hound_points, str(hounds_path), str(same)])
	_reached("D26_enemies_and_hounds_still_use_their_accepted_navigation_paths")
	return ok

func chk_D27_minion_cohesion_is_unchanged() -> bool:
	var rows: Array[String] = []
	var same := true
	for f in ["cohort_config.gd", "hound_config.gd"]:
		var path := "res://scripts/cohort/cohort_config.gd" if f == "cohort_config.gd" else "res://scripts/hounds/hound_config.gd"
		var d := _numeric_digest(_constants(path))
		var want: Array = REGISTRY_DIGESTS[f]
		var eq := int(d[0]) == int(want[0]) and String(d[1]) == String(want[1])
		same = same and eq
		rows.append("%s %d constants, digest %s=%s" % [f, int(d[0]), String(d[1]).left(16), str(eq)])
	# THE PACK STILL FOLLOWS HER after a direct click order.
	await _set_mode("ORDINARY")
	await _rest_at(LANE_A)
	await _phys(60)
	await _click(LANE_A + Vector3(0, 0, 8.0))
	await _phys(150)
	var within := 0
	for h in hounds.pack:
		if is_instance_valid(h) and _planar((h as Node3D).global_position, player.global_position) <= HoundConfig.LEASH_RANGE_M:
			within += 1
	var follows := within == HoundConfig.PACK_SIZE
	await _rest_at(ProductionArena.player_spawn())
	var ok := same and follows
	_note("D27_minion_cohesion_is_unchanged",
		"%s — every cohort and hound value unchanged | after she walked 8 m by a direct click order, %d of %d hounds were within the accepted %.1f m leash of her=%s"
		% [" · ".join(rows), within, HoundConfig.PACK_SIZE, HoundConfig.LEASH_RANGE_M, str(follows)])
	_reached("D27_minion_cohesion_is_unchanged")
	return ok

func chk_D28_navigation_collision_placement_and_accepted_values_are_unchanged() -> bool:
	# THE NAVIGATION MESH: the same mesh, baked ONCE.
	var nav_now := NavService.measure_mesh(arena.nav_mesh())
	var nav0: Dictionary = launch["nav"]
	var nav_same := int(nav_now["polygons"]) == int(nav0["polygons"]) \
		and absf(float(nav_now["area"]) - float(nav0["area"])) < 0.001 and arena.bake_count == 1
	# THE COLLISION CONFIGURATION: body, cylinder, layer and mask as accepted.
	var shape: CylinderShape3D = null
	for c in player.get_children():
		if c is CollisionShape3D and (c as CollisionShape3D).shape is CylinderShape3D:
			shape = (c as CollisionShape3D).shape
	var collision := player.collision_layer == 1 and player.collision_mask == (4 | 2) \
		and shape != null and is_equal_approx(shape.radius, ProdConfig.PLAYER_BODY_RADIUS) \
		and is_equal_approx(shape.height, 1.7) and is_equal_approx(ProdConfig.PLAYER_BODY_RADIUS, 0.40)
	# THE NAVIGATION AGENT IS RETAINED, AND FOR A MEASURED REASON: the accepted F70
	# reads its radius. It routes nothing.
	var fsrc := _read_text("res://tests/foundation_verification.gd")
	var agent_ok := player.agent != null and is_equal_approx(player.agent.radius, ProdConfig.NAV_AGENT_RADIUS) \
		and fsrc.find("player.agent.radius") >= 0 and _path_hits(_click_code()).is_empty()
	# CINDER FIELD'S PLACEMENT RULES: its code is byte-identical.
	var cinder_same := FileAccess.get_sha256("res://scripts/cinder/cinder_runtime.gd") == "626384d148b533ab244a883bfca677cbe5aa5c744ee63d2e3e2166ebf1b45809" \
		and FileAccess.get_sha256("res://scripts/cinder/cinder_trap.gd") == "6b4c669c77421670a6b39a5dcb1d824f3afce5ef60e8aef0276b8f9240e32e03"
	# EVERY ACCEPTED REGISTRY, BY DIGEST.
	var digests_same := true
	var rows: Array[String] = []
	for f in ["prod_config.gd", "imprint_config.gd", "huntress_config.gd", "locomotion_config.gd"]:
		var path: String = {"prod_config.gd": "res://scripts/core/prod_config.gd", "imprint_config.gd": "res://scripts/imprint/imprint_config.gd",
			"huntress_config.gd": "res://scripts/huntress/huntress_config.gd", "locomotion_config.gd": "res://scripts/locomotion/locomotion_config.gd"}[f]
		var d := _numeric_digest(_constants(String(path)))
		var want: Array = REGISTRY_DIGESTS[f]
		var eq := int(d[0]) == int(want[0]) and String(d[1]) == String(want[1])
		digests_same = digests_same and eq
		rows.append("%s=%s" % [f, str(eq)])
	var named := is_equal_approx(ProdConfig.TOP_SPEED_MPS, 3.889) and is_equal_approx(ProdConfig.ACCEL_MPS2, 30.0) \
		and is_equal_approx(ProdConfig.DECEL_MPS2, 38.0) and is_equal_approx(ProdConfig.ARRIVE_TOLERANCE_M, 0.35)
	var modes := true
	var want_m := [1.0, 1.8, 3.0]
	var i := 0
	for m in CohortConfig.speed_modes():
		modes = modes and is_equal_approx(float(m[1]), want_m[i])
		i += 1
	var planted := _constants("res://scripts/core/prod_config.gd").duplicate()
	planted["TOP_SPEED_MPS"] = 4.0
	var refuses := String(_numeric_digest(planted)[1]) != String(REGISTRY_DIGESTS["prod_config.gd"][1])
	var ok := nav_same and collision and agent_ok and cinder_same and digests_same and named and modes and refuses
	_note("D28_navigation_collision_placement_and_accepted_values_are_unchanged",
		"the navigation mesh is the one launch measured (%d polygons, %.2f m^2) and was baked ONCE=%s | layer 1, mask world + enemies, a %.2f m x %.1f m cylinder — unchanged=%s | the NavigationAgent3D is RETAINED because the accepted F70 reads its radius, and nothing in the click path gives it a target=%s | Cinder Field's placement code is byte-identical=%s | accepted registries by digest: %s=%s | the top speed 3.889, the rates 30 / 38 and the 0.35 m tolerance are unchanged=%s, and the diagnostic multipliers are 1.0 / 1.8 / 3.0=%s | the digest REFUSES a single changed number=%s"
		% [int(nav_now["polygons"]), float(nav_now["area"]), str(nav_same), shape.radius if shape != null else -1.0,
		   shape.height if shape != null else -1.0, str(collision), str(agent_ok), str(cinder_same), " · ".join(rows),
		   str(digests_same), str(named), str(modes), str(refuses)])
	_reached("D28_navigation_collision_placement_and_accepted_values_are_unchanged")
	return ok

## The body of one accepted check, read from its suite's CODE.
func _accepted_body(path: String, fname: String) -> String:
	return _function_body(_read_text(path), fname)

static func _owed_names(src: String, prefix: String) -> Array:
	var i := src.find("const OWED := [")
	var j := src.find("\n]\n", i)
	var out: Array = []
	# ENTRY LINES ONLY: an OWED list's COMMENT lines may quote a historical name
	# (the Imprint suite's does), and counting those would inflate the count --
	# which the first delivery run of this check did (D-404), reading 103 for 101.
	var re := RegEx.new()
	re.compile("(?m)^\\t\"(" + prefix + "[0-9]+_[a-z0-9_]+)\"")
	for m in re.search_all(src.substr(i, j - i)):
		out.append(m.get_string(1))
	return out

func chk_D29_the_conflicting_accepted_checks_were_replaced_one_for_one_with_history() -> bool:
	var fpath := "res://tests/foundation_verification.gd"
	var ipath := "res://tests/imprint_verification.gd"
	var lpath := "res://tests/locomotion_verification.gd"
	var fsrc := _read_text(fpath)
	var isrc := _read_text(ipath)
	var lsrc := _read_text(lpath)
	var f_owed := _owed_names(fsrc, "F")
	var i_owed := _owed_names(isrc, "I")
	var l_owed := _owed_names(lsrc, "L")
	# THE COUNTS DID NOT MOVE: replacement is one for one.
	var counts := f_owed.size() == 85 and i_owed.size() == 101 and l_owed.size() == 33
	# THE SIX: the NEW name owed, the OLD name owed NO LONGER, and the body carries
	# the dated history -- the old name and the old requirement -- in place.
	var six := [
		[fsrc, f_owed, "F27_offmesh_click_is_reported_not_dropped", "F27_offmesh_click_is_stored_unsnapped_not_dropped", "required a redirect onto the mesh"],
		[isrc, i_owed, "I80_click_to_move_still_resolves_the_nearest_navigable_point", "I80_click_to_move_stores_the_clicked_point_unsnapped", "required a redirect onto the mesh"],
		[lsrc, l_owed, "L12_a_sharp_path_corner_redirects_in_the_same_physics_frame", "L12_a_click_across_the_blocker_goes_straight_with_no_path_corners", "THE PLAYER'S NAVIGATION PATH round the interior blocker"],
		[lsrc, l_owed, "L18_path_corner_deviation_is_bounded_and_does_not_grow_with_speed", "L18_a_click_order_stays_on_its_straight_segment_at_every_speed", "track THE PLAYER'S OWN PATH POLYLINE"],
		[lsrc, l_owed, "L21_the_narrow_doorway_is_still_navigated_at_every_speed", "L21_an_aligned_click_passes_the_doorway_and_a_slanted_one_stops", "be ROUTED through the doorway"],
	]
	var rows: Array[String] = []
	var six_ok := true
	for s6 in six:
		var src: String = s6[0]
		var owed: Array = s6[1]
		var body := _function_body(src, "chk_" + String(s6[3]))
		var ok1 := owed.has(String(s6[3])) and not owed.has(String(s6[2])) \
			and body.find("REPLACED ONE FOR ONE UNDER D-404") >= 0 and body.find(String(s6[2])) >= 0 \
			and body.find(String(s6[4])) >= 0 and body.find("TRUE WHEN WRITTEN") >= 0 \
			and src.find("func chk_" + String(s6[2]) + "(") < 0
		six_ok = six_ok and ok1
		rows.append("%s=%s" % [String(s6[3]).left(3), str(ok1)])
	# F76 KEEPS ITS NAME: only its path conjunct was replaced, with the old text dated.
	var f76 := _function_body(fsrc, "chk_F76_obsolete_navigation_target_does_not_restart_movement")
	var f76_ok := f_owed.has("F76_obsolete_navigation_target_does_not_restart_movement") \
		and f76.find("RE-SCOPED ONE FOR ONE UNDER D-404") >= 0 \
		and f76.find("var had_path := player.follower.point_count() >= 2") >= 0 \
		and _code_only(f76).find("var had_path := player.follower.point_count() == 0") >= 0
	six_ok = six_ok and f76_ok
	rows.append("F76=%s" % str(f76_ok))
	# THE FOUNDATION SUITE WAS EDITED ONLY INSIDE F27 AND F76: every D-404 mention
	# lies inside one of those two bodies.
	var at27 := fsrc.find("func chk_F27_")
	var end27 := fsrc.find("\nfunc ", at27 + 1)
	var at76 := fsrc.find("func chk_F76_")
	var end76 := fsrc.find("\nfunc ", at76 + 1)
	var outside := 0
	var k := fsrc.find("D-404")
	while k >= 0:
		if not ((k > at27 and k < end27) or (k > at76 and k < end76)):
			outside += 1
		k = fsrc.find("D-404", k + 1)
	# UNRELATED CHECKS UNTOUCHED: F26 (declared, DD-19), F24, L20 (the stick
	# slide) and L22 carry no D-404 edit.
	var untouched := _function_body(fsrc, "chk_F26_click_to_move_resolves_nearest_navigable").find("D-404") < 0 \
		and _function_body(fsrc, "chk_F24_aim_does_not_change_move_destination").find("D-404") < 0 \
		and _function_body(lsrc, "chk_L20_wall_collision_still_slides_legitimately").find("D-404") < 0 \
		and _function_body(lsrc, "chk_L22_navigation_geometry_and_the_agent_radius_are_unchanged").find("D-404") < 0 \
		and l_owed.has("L20_wall_collision_still_slides_legitimately") and f_owed.has("F26_click_to_move_resolves_nearest_navigable")
	# THE AUDIT REFUSES a planted suite where the old name is still owed.
	var planted := fsrc.replace("\"F27_offmesh_click_is_stored_unsnapped_not_dropped\"", "\"F27_offmesh_click_is_reported_not_dropped\"")
	var refuses := not _owed_names(planted, "F").has("F27_offmesh_click_is_stored_unsnapped_not_dropped")
	var ok := counts and six_ok and outside == 0 and untouched and refuses
	_note("D29_the_conflicting_accepted_checks_were_replaced_one_for_one_with_history",
		"accepted counts unmoved (85 / 101 / 33)=%s | F27, I80, L12, L18 and L21 each now owe their NEW name, no longer the old, and carry the old name AND the old requirement as dated history in place; F76 keeps its name and only its path conjunct was replaced, the old text dated: %s | every D-404 mention in the accepted foundation suite lies inside F27 or F76 (%d outside) | F26, F24, L20 and L22 carry no D-404 edit=%s | the audit refuses a planted suite still owing the old name=%s"
		% [str(counts), " · ".join(rows), outside, str(untouched), str(refuses)])
	_reached("D29_the_conflicting_accepted_checks_were_replaced_one_for_one_with_history")
	return ok

# =============================================================================
# F. REVIEW SURFACES
# =============================================================================

func _subtree(n: Node, out: Array) -> void:
	out.append(n)
	for c in n.get_children():
		_subtree(c, out)

func chk_D30_f1_and_f2_start_hidden_and_the_review_surface_overlaps_nothing() -> bool:
	var hidden := bool(launch["overlay_enabled"]) == false and bool(launch["panel_enabled"]) == false \
		and bool(launch["d381_enabled"]) == false
	var shown := bool(launch["d392_enabled"]) and bool(launch["hounds_hud_enabled"]) \
		and bool(launch["cohort_hud_enabled"]) and bool(launch["cinder_hud_enabled"]) \
		and bool(launch["click_hud_enabled"]) and bool(launch["gizmo_visible"])
	var nodes: Array = []
	_subtree(click_hud, nodes)
	var eaters: Array[String] = []
	var n_controls := 0
	for c in nodes:
		if c is Control:
			n_controls += 1
			if (c as Control).mouse_filter != Control.MOUSE_FILTER_IGNORE:
				eaters.append(String((c as Node).name))
	# MEASURED AT 1920 x 1080: a headless root is a 64 x 64 dummy (the D-382 lesson).
	var old_size := root.size
	root.size = Vector2i(1920, 1080)
	await process_frame
	hud.set_enabled(true)
	for h in [click_hud, d392_hud, hounds_hud, cohort_hud, cinder_hud]:
		h.refresh()
	await process_frame
	await process_frame
	var mine := click_hud.body_rect()
	var others := {"F1 overlay": (hud.get_node("OverlayPanel") as Control).get_global_rect(),
		"D-392": d392_hud.body_rect(), "D-396": hounds_hud.body_rect(),
		"D-398": cohort_hud.body_rect(), "D-402": cinder_hud.body_rect()}
	hud.set_enabled(false)
	var overlaps: Array[String] = []
	for k in others.keys():
		var r: Rect2 = others[k]
		if r.size.x > 0.0 and mine.size.x > 0.0 and mine.intersects(r):
			overlaps.append(String(k))
	var vp := root.get_viewport().get_visible_rect()
	var centre := Rect2(vp.size * 0.5 - Vector2(180, 130), Vector2(360, 260))
	var covers_centre := mine.intersects(centre)
	var share := (mine.size.x * mine.size.y) / maxf(1.0, vp.size.x * vp.size.y)
	root.size = old_size
	await process_frame
	var ok := hidden and shown and eaters.is_empty() and n_controls >= 8 and overlaps.is_empty() \
		and not covers_centre and share <= 0.10 and mine.size.x > 0.0
	_note("D30_f1_and_f2_start_hidden_and_the_review_surface_overlaps_nothing",
		"AT LAUNCH F1, F2 and the D-381 HUD are HIDDEN=%s; the four accepted review HUDs, the D-404 HUD and its world markers are shown=%s | all %d Controls are MOUSE_FILTER_IGNORE (eaters: %s) — it never eats a click | at 1920 x 1080 its rectangle %s overlaps NONE of the F1 overlay and the D-392, D-396, D-398 and D-402 HUDs (overlaps: %s), leaves the screen centre clear=%s and covers %.2f%% of the frame"
		% [str(hidden), str(shown), n_controls, str(eaters), str(mine), str(overlaps), str(not covers_centre), share * 100.0])
	_reached("D30_f1_and_f2_start_hidden_and_the_review_surface_overlaps_nothing")
	return ok

func chk_D31_the_review_shows_destination_segment_contact_stop_reason_and_zero_path() -> bool:
	await _set_mode("ORDINARY")
	# A COLLIDED ORDER.
	var _pts := await _trace(WALL_FROM, BEHIND)
	click_hud.refresh()
	var o := player.click_order
	var t1 := click_hud.last_text
	var shows := t1.find("CLICK (%.2f, %.2f)" % [BEHIND.x, BEHIND.z]) >= 0 \
		and t1.find("straight %.2f m" % _planar(o.origin, o.destination)) >= 0 \
		and t1.find("COLLIDED at first contact") >= 0 \
		and t1.find("CONTACT (%.2f, %.2f)" % [o.contact_point.x, o.contact_point.z]) >= 0 \
		and t1.find("PLAYER PATH 0 points · 0 queries") >= 0
	var drawn := bool(click_gizmo.last_drawn.get("destination", false)) and bool(click_gizmo.last_drawn.get("segment", false)) \
		and bool(click_gizmo.last_drawn.get("contact", false))
	# AN ARRIVED ORDER: the reason changes with the live state, and so does every
	# number -- the HUD owns none of them.
	await _rest_at(UNOBSTRUCTED_FROM)
	await _click(UNOBSTRUCTED_TO)
	click_hud.refresh()
	var t2 := click_hud.last_text
	var arrived := t2.find("ARRIVED") >= 0 and t2.find("CLICK (%.2f, %.2f)" % [UNOBSTRUCTED_TO.x, UNOBSTRUCTED_TO.z]) >= 0 \
		and t2.find("CONTACT none") >= 0 and not bool(click_gizmo.last_drawn.get("contact", true))
	# NO LINE IS CUT OFF, and the guard can refuse.
	var cut: Array[String] = []
	for k in click_hud.lines.keys():
		var tx := String((click_hud.lines[k] as Label).text)
		if tx.find("…") >= 0 or tx.length() > DirectClickReviewHud.MAX_LINE_CHARS:
			cut.append(String(k))
	var refuses_cut := DirectClickReviewHud._fit("x".repeat(DirectClickReviewHud.MAX_LINE_CHARS + 1)).find("…") >= 0
	# IT OWNS NO NUMBER: the composing code carries no numeric literal but 0.
	var body := _strip_strings(_code_only(_function_body(_read_text("res://scripts/click/direct_click_review_hud.gd"), "compose_lines")))
	var lit := RegEx.new()
	lit.compile("(?<![A-Za-z_0-9.])[0-9]+(\\.[0-9]+)?(?![A-Za-z_0-9])")
	var numbers: Array[String] = []
	for m in lit.search_all(body):
		if m.get_string() != "0" and m.get_string() != "1":
			numbers.append(m.get_string())
	var lit_caught := lit.search("var x := 4.5") != null
	# THE MARKERS ARE NOT COLLIDERS, NOT NAVIGATION AND NOT REGISTERED.
	var gnodes: Array = []
	_subtree(click_gizmo, gnodes)
	var inert := true
	for n in gnodes:
		if n is CollisionObject3D or n is NavigationAgent3D or n is NavigationObstacle3D or n is NavigationRegion3D:
			inert = false
	await _rest_at(ProductionArena.player_spawn())
	var ok := shows and drawn and arrived and cut.is_empty() and refuses_cut and numbers.is_empty() and lit_caught and inert
	_note("D31_the_review_shows_destination_segment_contact_stop_reason_and_zero_path",
		"after a click behind the wall the HUD shows the ACTUAL clicked point, the straight segment's length, COLLIDED at first contact, the contact's own coordinates and PLAYER PATH 0 points · 0 queries=%s, and the world markers drew the destination, the segment and the contact=%s | after an unobstructed click it shows ARRIVED, the new point and no contact, and the contact marker is gone=%s | lines cut off: %s (a line one character over the cap IS cut=%s) | numeric literals in the composing code besides 0 and 1: %s — it owns no number (a planted one is seen=%s) | the markers are no collider, navigation node or registered entity=%s"
		% [str(shows), str(drawn), str(arrived), str(cut), str(refuses_cut), str(numbers), str(lit_caught), str(inert)])
	_reached("D31_the_review_shows_destination_segment_contact_stop_reason_and_zero_path")
	return ok

# =============================================================================
# G. SCOPE AND TRUTHFULNESS
# =============================================================================

func chk_D32_denials_rulings_units_registry_and_no_self_acceptance() -> bool:
	# 1. THE DENIALS, each naming D-404, the last denying self-acceptance.
	var den := DirectClickConfig.denials()
	var den_ok := den.size() == 16 \
		and String(den[15]) == "The D-404 stage delivers OPEN pending owner live review; it does NOT accept itself."
	for d in den:
		den_ok = den_ok and String(d).find("D-404") >= 0
	# 2. THE SEVENTEEN ITEMS, in order, each with EXACTLY ONE disposition.
	var rulings := DirectClickConfig.canonical_rulings()
	var cited := rulings.size() == 17
	for i in rulings.size():
		var k := String(rulings[i][2])
		var one := 0
		for kind in ["IMPLEMENTED", "PRESERVED"]:
			if k.find(String(kind)) == 0:
				one += 1
		cited = cited and one == 1 and String(rulings[i][0]) == "D-404 item %d" % (i + 1)
	# 3. THE SUPERSESSION IS DECLARED, AND THE D-400 RECORD IS LEFT AS WRITTEN.
	var sup := DirectClickConfig.supersedes()
	var d400 := LocomotionConfig.canonical_rulings()
	var sup_ok := sup.size() == 3 and String(sup[0][0]) == "D-400 item 4" and String(sup[1][0]) == "D-400 item 7" \
		and String(sup[2][0]) == "D-400 item 10" and d400.size() == 11 \
		and String(d400[3][1]).find("sharp path corners") >= 0 and String(d400[6][1]).find("legitimate sliding along walls") >= 0
	# 4. THE PRINTED ROWS: DD- rows in order, each naming where it returns; the
	#    owner's six questions VERBATIM; none a pass.
	var dd := DirectClickConfig.deferred_rows()
	# 21 rows were written before the work; DD-22, the canon disagreement, was
	# added during it (21 + 1 = 22) and is disclosed in the inventory's addendum.
	var dd_ok := dd.size() == 22
	for i in dd.size():
		dd_ok = dd_ok and String(dd[i][0]).begins_with("DD-%02d " % (i + 1)) \
			and String(dd[i][2]).find("RETURNS TO") >= 0 and String(dd[i][1]) != "PASS"
	var do_rows := DirectClickConfig.owed_to_owner()
	var do_ok := do_rows.size() == 6
	for i in do_rows.size():
		do_ok = do_ok and String(do_rows[i][0]) == "DO-%02d" % (i + 1) and String(do_rows[i][1]) == DO_TEXT[i]
	# 5. NO SELF-ACCEPTANCE anywhere a viewer or a log could read it.
	var self_re := RegEx.new()
	self_re.compile("PLAYER DIRECT-CLICK MOVEMENT CORRECTION STAGE ACCEPTED|D-404 (is|stage is) ACCEPTED|ACCEPTED and CLOSED \\(D-404\\)|ACCEPTED and CLOSED \\(D-402\\)|" + PLANTED_CLAIM)
	var claims: Array[String] = []
	for f in _runtime_script_files():
		if self_re.search(_code_only(_read_text(String(f)))) != null:
			claims.append(String(f).get_file())
	click_hud.refresh()
	hud.set_enabled(true)
	hud.refresh()
	var surfaces := click_hud.last_text + "\n" + hud.compose() + "\n" + ProdConfig.STATE
	hud.set_enabled(false)
	var surface_clean := self_re.search(surfaces) == null
	var caught := self_re.search("print(\"%s\")" % PLANTED_CLAIM) != null \
		and self_re.search("PLAYER DIRECT-CLICK MOVEMENT CORRECTION STAGE ACCEPTED and CLOSED (D-404)") != null
	# 6. THE BANNER PRINTS NO ROW AND NO STATE LINE into the accepted suites' logs.
	var banner := _function_body(_code_only(_read_text("res://scripts/foundation_main.gd")), "_print_direct_click_banner")
	var banner_ok := banner.length() > 200 and banner.find("STATE") < 0 \
		and banner.find("deferred_rows") < 0 and banner.find("owed_to_owner") < 0
	# 7. EVERY NUMERIC CONSTANT OF DirectClickConfig IS REGISTERED, BOTH WAYS.
	var reg := DirectClickConfig.registry()
	var all_prov := reg.size() == 4
	for row in reg:
		all_prov = all_prov and String(row[2]).find("PROVISIONAL") == 0
	var consts := _constants("res://scripts/click/direct_click_config.gd")
	var numeric: Array = []
	for k2 in consts.keys():
		var v = consts[k2]
		if typeof(v) == TYPE_INT or typeof(v) == TYPE_FLOAT:
			numeric.append(float(v))
	var reg_values: Array = []
	for row2 in reg:
		reg_values.append(float(row2[1]))
	numeric.sort()
	reg_values.sort()
	var both := numeric.size() == reg_values.size()
	if both:
		for i in numeric.size():
			both = both and is_equal_approx(float(numeric[i]), float(reg_values[i]))
	var planted := numeric.duplicate()
	planted.append(7.25)
	var refuses := planted.size() != reg_values.size()
	# 8. NO RUNTIME LOAD LEAVES game3d/, and nothing names a spike.
	var load_re := RegEx.new()
	load_re.compile("(?:load|preload|ResourceLoader\\.load|FileAccess\\.open|DirAccess\\.open)\\s*\\(\\s*\"([^\"]*)\"")
	var outward: Array[String] = []
	var spike := RegEx.new()
	spike.compile("game3d_spike|game3d_boss_spike|game3d_huntress_spike|game2d")
	var spike_hits: Array[String] = []
	for f2 in D404_SCRIPTS:
		var code := _code_only(_read_text(String(f2)))
		for m in load_re.search_all(code):
			if not m.get_string(1).begins_with("res://") or m.get_string(1).find("..") >= 0:
				outward.append("%s:%s" % [String(f2).get_file(), m.get_string(1)])
		if spike.search(code) != null:
			spike_hits.append(String(f2).get_file())
	# 9. UNITS AT EVERY SURFACE. Built without a relative parent segment: the
	#    accepted F65 and I99 refuse one in any file of this project.
	var inv_path := ProjectSettings.globalize_path("res://").trim_suffix("/").get_base_dir() \
		.path_join("docs/testing/D404_DIRECT_CLICK_MOVEMENT_OWED_CRITERIA_INVENTORY.md")
	var inv := _read_text(inv_path)
	var units := inv != "" and inv.find("**124**") >= 0 and inv.find("**32**") >= 0 \
		and inv.find("**24**") >= 0 and OWED.size() == 32
	# 10. THE SEAMS ARE CLEAR, at launch and now.
	var seams := bool(launch["seams_clear"]) and player.intent.seams_clear() \
		and cam.debug_cursor_override == null and not player.debug_freeze_attack
	var ok := den_ok and cited and sup_ok and dd_ok and do_ok and claims.is_empty() and surface_clean \
		and caught and banner_ok and all_prov and both and refuses and outward.is_empty() \
		and spike_hits.is_empty() and units and seams
	_note("D32_denials_rulings_units_registry_and_no_self_acceptance",
		"%d denials, each naming D-404, the last saying it does NOT accept itself=%s | the owner's SEVENTEEN items cited in order, each with EXACTLY ONE disposition=%s | the three superseded D-400 clauses are DECLARED, and D-400's own record is left as written=%s | DD-01..DD-22 in order, each naming where it returns, none a pass=%s | DO-01..DO-06, the owner's six questions VERBATIM=%s | runtime code claiming the OPEN D-404 stage accepted: %s; the HUD, overlay and state line claim none=%s; planted claims caught=%s | the D-404 banner prints no row and no STATE line=%s | %d registry values, every one PROVISIONAL=%s; the registry and DirectClickConfig's numeric constants match BOTH ways=%s, and an unregistered planted constant is refused=%s | loads leaving game3d/: %s; files naming a spike or game2d/: %s | the inventory states 124 OWED CRITERIA, 32 EXECUTABLE CHECKS and 24 RUNNER CHECKS, and this suite owes %d=%s | the test seams were clear at launch and are clear now=%s. NOTHING HERE IS A LOCK."
		% [den.size(), str(den_ok), str(cited), str(sup_ok), str(dd_ok), str(do_ok), str(claims),
		   str(surface_clean), str(caught), str(banner_ok), reg.size(), str(all_prov), str(both), str(refuses),
		   str(outward), str(spike_hits), OWED.size(), str(units), str(seams)])
	_reached("D32_denials_rulings_units_registry_and_no_self_acceptance")
	return ok

# =============================================================================
# REPORT
# =============================================================================

func _report() -> void:
	player.intent.clear_seams()
	cam.debug_cursor_override = null
	print("")
	print("------------------------------------------------------------------------")
	print("RESULTS — %s (%s)" % [DirectClickConfig.STAGE, DirectClickConfig.DECISION])
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
	print("THE OWNER'S SEVENTEEN ITEMS, each with its disposition:")
	for r in DirectClickConfig.canonical_rulings():
		print("  [%-11s] %s — %s" % [String(r[2]).split(" —")[0], r[0], r[1]])
	print("")
	print("DEFERRED — recorded as such, NEVER as passes:")
	for row in DirectClickConfig.deferred_rows():
		print("  [%-28s] %s" % [row[1], row[0]])
		print("                   %s" % row[2])
	print("")
	print("OWED TO THE OWNER'S LIVE REVIEW — NOT passes and NOT failures:")
	for row in DirectClickConfig.owed_to_owner():
		print("  [OWED-TO-OWNER] %s %s" % [row[0], row[1]])
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
	print("DENIALS (%d):" % DirectClickConfig.denials().size())
	for d in DirectClickConfig.denials():
		print("  %s" % d)
	print("")
	print("UNITS: %d EXECUTABLE CHECKS here · 124 OWED CRITERIA in the D-404 inventory ·" % OWED.size())
	print("       24 RUNNER CHECKS in tests/direct_click_smoke.sh · and the ACCEPTED suites' 85, 101,")
	print("       40, 53, 45, 40, 33 and 48 EXECUTABLE CHECKS are DIFFERENT decisions' numbers.")
	print("       Different unit. None is a synonym for another.")
	print("")
	var verdict := "PASS" if _all_ok() else "FAIL"
	print("DIRECT CLICK VERIFICATION: %s (%d checks: %d passed, %d failed/unreached, %d deferred, %d owed to the owner)"
		% [verdict, OWED.size(), passed, failed, DirectClickConfig.deferred_rows().size(),
		   DirectClickConfig.owed_to_owner().size()])
	print("STATE: %s" % ProdConfig.STATE)
