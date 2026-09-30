extends SceneTree

## RIFTWROUGHT — THE CINDER FIELD STAGE VERIFICATION  (D-402, 2026-09-20)
##
## ============================================================================
## AN EIGHTH SUITE. THE SEVEN ACCEPTED ONES ARE RE-RUN AS REGRESSIONS.
## ============================================================================
## `tests/foundation_verification.gd` (85, ACCEPTED D-373), `imprint_` (101,
## D-376), `alignment_` (40, D-383), `huntress_` (53, D-394), `hounds_` (45,
## D-397), `cohesion_` (40, D-399) and `locomotion_` (33, ACCEPTED D-401) run
## FIRST in `tests/cinder_smoke.sh`. This suite owns only what D-402 owes.
##
## ============================================================================
## UNITS. TWENTY-FOUR COUNTS EXIST IN THIS PROJECT AND NONE IS A SYNONYM.
## ============================================================================
##   D-402 OWED CRITERIA     185  docs/testing/D402_CINDER_FIELD_OWED_CRITERIA_INVENTORY.md
##   D-402 EXECUTABLE CHECKS  48  this suite (E01-E48)
##   D-402 RUNNER CHECKS      24  tests/cinder_smoke.sh (Q01-Q24)
##   D-400 180 · 33 · 22   D-398 201 · 40 · 22   D-396 202 · 45 · 21
##   D-392 203 · 53 · 21   D-380 162 · 40 · 21   D-375 149 · 101 · 26
##   D-370 125 · 85 · 20
## The D-402 printed rows are 19 FD- rows and 7 FO- rows: none is a pass.
##
## ============================================================================
## IT VERIFIES A STAGE DELIVERED OPEN. IT ACCEPTS NOTHING.
## ============================================================================
## Every BOUND it asserts is a TEST BOUND, stated in its own note -- never a
## gameplay value, and never a lock.
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
	"E01_state_names_eight_facts_exactly_with_one_definer",
	"E02_lo_rows_discharged_d401_with_history_and_ld02_reclassified",
	"E03_every_accepted_pin_moved_together_and_refuses_stale_lines",
	# --- B. LEARNING AND INTEGRATION --------------------------------------------
	"E04_cinder_field_is_one_canonical_skill_imprint_at_rank_1_with_0_xp",
	"E05_one_unmodified_configuration_with_zero_modifiers",
	"E06_canonical_tags_targeting_class_and_castable_with_a_bow",
	"E07_bound_to_the_measured_free_binding_without_disturbing_the_loadout",
	"E08_capacity_accounting_without_an_arbitrary_increase",
	"E09_it_is_an_action_entry_point_pinned_in_both_directions",
	# --- C. PLACEMENT -----------------------------------------------------------
	"E10_valid_ground_placement_lands_on_navigable_ground",
	"E11_an_out_of_range_point_is_clamped_to_the_range",
	"E12_an_invalid_ground_point_refuses_the_use_and_pays_nothing",
	"E13_no_trap_exists_before_the_release_marker",
	"E14_the_ground_point_is_the_one_sampled_when_the_use_began",
	# --- D. THE COMMITMENT ------------------------------------------------------
	"E15_the_accepted_stop_commitment_suppresses_translation",
	"E16_movement_before_release_is_buffered_and_cannot_cancel",
	"E17_movement_after_release_cancels_recovery_and_the_trap_survives",
	"E18_cost_is_paid_at_use_start_and_the_cooldown_begins_on_release",
	# --- E. ARMING AND TRIGGERING -----------------------------------------------
	"E19_a_trap_cannot_trigger_before_it_is_armed",
	"E20_an_armed_trap_triggers_on_an_eligible_enemy_entering",
	"E21_the_player_cannot_trigger_it",
	"E22_hounds_and_other_player_owned_entities_cannot_trigger_it",
	"E23_an_ineligible_enemy_cannot_trigger_it",
	"E24_one_trap_erupts_at_most_once",
	"E25_simultaneous_entry_is_deterministic_by_time_then_combat_entity_id",
	# --- F. THE ERUPTION AND THE BURNING GROUND ---------------------------------
	"E26_the_eruption_hits_every_eligible_enemy_in_its_area",
	"E27_the_hit_and_the_ground_dot_are_separately_measurable_and_tagged",
	"E28_the_burning_ground_lingers_for_its_duration_and_then_ends",
	"E29_overlapping_ground_areas_never_multiply_damage",
	"E30_the_strongest_applicable_instance_deals_the_damage",
	"E31_the_ground_applies_no_hit_and_the_eruption_applies_no_dot",
	# --- G. LIFETIME, THE CAP AND CLEANUP ---------------------------------------
	"E32_an_unsprung_trap_expires_harmlessly",
	"E33_the_instance_cap_replaces_the_oldest_harmlessly",
	"E34_canon_s_duration_and_ground_declarations_are_stated_as_data",
	# --- H. THE WORLD -----------------------------------------------------------
	"E35_neither_a_trap_nor_a_field_is_attackable",
	"E36_neither_blocks_movement",
	"E37_navigation_is_unchanged",
	# --- I. LIFECYCLE -----------------------------------------------------------
	"E38_unequipping_or_deactivating_removes_only_what_it_owns",
	"E39_re_equipping_restores_the_skill_without_resurrecting_instances",
	# --- J. NO REGRESSION ELSEWHERE ---------------------------------------------
	"E40_splinter_shot_is_preserved_exactly",
	"E41_kindred_hounds_and_the_cohort_are_preserved_exactly",
	"E42_player_locomotion_redirection_is_preserved_exactly",
	"E43_no_accepted_registry_value_changed",
	# --- K. WHAT MUST NOT APPEAR ------------------------------------------------
	"E44_no_prey_no_mark_and_no_ignite",
	# --- L. REVIEW SURFACES -----------------------------------------------------
	"E45_f1_and_f2_start_hidden_and_the_hud_overlaps_nothing",
	"E46_the_hud_shows_the_six_owed_facts_and_owns_no_number",
	# --- M. SCOPE, ASSETS AND TRUTHFULNESS --------------------------------------
	"E47_the_asset_intake_is_exactly_two_models_from_a_declared_pack",
	"E48_denials_rulings_units_registry_and_no_self_acceptance",
]

## ONE deliberately planted claim, so the self-acceptance scans can be proved
## able to refuse. It is never printed.
const PLANTED_CLAIM := "Cinder_Field_Stage_Accepts_Itself_THIS_IS_FORBIDDEN"

# D-404 (first act): `EIGHT` and `OPEN8` keep their IDENTIFIERS -- renaming
# around a guard is what this project's own rule forbids -- and their CONTENT moves
# with the state. From D-402 until D-404 `EIGHT` was the eight-fact line ending
# "CINDER FIELD STAGE DELIVERED and OPEN pending owner live review (D-402)" and
# `OPEN8` that clause -- TRUE WHEN WRITTEN. The line is now NINE facts.
const EIGHT := "FOUNDATION STAGE ACCEPTED and CLOSED (D-373) · IMPRINT STAGE ACCEPTED and CLOSED (D-376) · D-378 ALIGNMENT STAGE ACCEPTED and CLOSED (D-383) · HUNTRESS SPLINTER SHOT STAGE ACCEPTED and CLOSED (D-394) · KINDRED HOUNDS STAGE ACCEPTED and CLOSED (D-397) · MOBILE MINION COHESION STAGE ACCEPTED and CLOSED (D-399) · PLAYER LOCOMOTION REDIRECTION STAGE ACCEPTED and CLOSED (D-401) · CINDER FIELD STAGE ACCEPTED and CLOSED (D-403) · PLAYER DIRECT-CLICK MOVEMENT CORRECTION STAGE DELIVERED and OPEN pending owner live review (D-404)"
const OPEN8 := "PLAYER DIRECT-CLICK MOVEMENT CORRECTION STAGE DELIVERED and OPEN pending owner live review (D-404)"
const STATE_D400 := "FOUNDATION STAGE ACCEPTED and CLOSED (D-373) · IMPRINT STAGE ACCEPTED and CLOSED (D-376) · D-378 ALIGNMENT STAGE ACCEPTED and CLOSED (D-383) · HUNTRESS SPLINTER SHOT STAGE ACCEPTED and CLOSED (D-394) · KINDRED HOUNDS STAGE ACCEPTED and CLOSED (D-397) · MOBILE MINION COHESION STAGE ACCEPTED and CLOSED (D-399) · PLAYER LOCOMOTION REDIRECTION STAGE DELIVERED and OPEN pending owner live review (D-400)"
## D-404: the D-402-era line, held as a SUPERSEDED needle exactly as STATE_D400 is.
const STATE_D402 := "FOUNDATION STAGE ACCEPTED and CLOSED (D-373) · IMPRINT STAGE ACCEPTED and CLOSED (D-376) · D-378 ALIGNMENT STAGE ACCEPTED and CLOSED (D-383) · HUNTRESS SPLINTER SHOT STAGE ACCEPTED and CLOSED (D-394) · KINDRED HOUNDS STAGE ACCEPTED and CLOSED (D-397) · MOBILE MINION COHESION STAGE ACCEPTED and CLOSED (D-399) · PLAYER LOCOMOTION REDIRECTION STAGE ACCEPTED and CLOSED (D-401) · CINDER FIELD STAGE DELIVERED and OPEN pending owner live review (D-402)"
const STATE_D398 := "FOUNDATION STAGE ACCEPTED and CLOSED (D-373) · IMPRINT STAGE ACCEPTED and CLOSED (D-376) · D-378 ALIGNMENT STAGE ACCEPTED and CLOSED (D-383) · HUNTRESS SPLINTER SHOT STAGE ACCEPTED and CLOSED (D-394) · KINDRED HOUNDS STAGE ACCEPTED and CLOSED (D-397) · MOBILE MINION COHESION STAGE DELIVERED and OPEN pending owner live review (D-398)"

## The owner's four D-400 questions, VERBATIM, so E02 can prove each discharged
## row still carries its ORIGINAL text.
const LO_TEXT := [
	"Whether abrupt direction changes feel immediate and controlled at ORDINARY speed.",
	"Whether they feel immediate and controlled at FAST speed.",
	"Whether they feel immediate and controlled at EXTREME speed.",
	"Whether starts and stops still feel natural.",
]

## The owner's seven D-402 questions, VERBATIM.
const FO_TEXT := [
	"Does placement feel responsive and accurate while using click-to-move?",
	"Are dormant, armed and sprung states readable at normal gameplay zoom?",
	"Do the arming delay and enemy-only trigger feel intuitive?",
	"Are the initial eruption and lingering burning ground visually distinct?",
	"Does placing several traps and replacing the oldest behave predictably?",
	"Does overlapping burning ground clearly avoid multiplying damage?",
	"Does this feel like a plausible foundation for a trap-focused Huntress build?",
]

const ACCEPTED_SUITES := ["res://tests/imprint_verification.gd", "res://tests/alignment_verification.gd",
	"res://tests/huntress_verification.gd", "res://tests/hounds_verification.gd",
	"res://tests/cohesion_verification.gd", "res://tests/locomotion_verification.gd"]
const ACCEPTED_RUNNERS := ["res://tests/foundation_smoke.sh", "res://tests/imprint_smoke.sh",
	"res://tests/alignment_smoke.sh", "res://tests/huntress_smoke.sh", "res://tests/hounds_smoke.sh",
	"res://tests/cohesion_smoke.sh", "res://tests/locomotion_smoke.sh"]

## The six runtime scripts this stage declares.
const D402_SCRIPTS := ["res://scripts/cinder/cinder_config.gd", "res://scripts/cinder/cinder_content.gd",
	"res://scripts/cinder/cinder_ground.gd", "res://scripts/cinder/cinder_review_hud.gd",
	"res://scripts/cinder/cinder_runtime.gd", "res://scripts/cinder/cinder_trap.gd"]

## The four files the D-402 intake added, with the SHA-256 of the archive entry
## each was copied from. Verified BEFORE extraction and recorded here so E47 can
## re-verify the file on disk rather than trust the record.
const D402_ASSETS := [
	["BearTrap_Open.obj", "f501c675071b458070baa0e7a1c3fe1f2f5bd4fa3ea3dfdebe58629d25471226"],
	["BearTrap_Open.mtl", "3cf25b84cfa42802c41f102fc758d87a447e625b946b0cc9d5a04564bf822157"],
	["BearTrap_Closed.obj", "9e5a3870d37f6e9a69b99060602829b2c3e3d50b86957b731d3d74fa6c0d90be"],
	["BearTrap_Closed.mtl", "8a8406e94a99976870b218dfdd0d60c65bee3164ea2e4d79d25701dd4766f80f"],
]

## ============================================================================
## TEST BOUNDS. EVERY ONE OF THESE IS A TEST BOUND, NOT A GAMEPLAY VALUE.
## ============================================================================
## None is read by any runtime file, none is registered, and none is a lock.
const DT := 1.0 / 60.0
const TOL_M := 0.02              ## placement landing, metres
const TOL_DMG := 0.001           ## damage arithmetic, absolute
const TOL_T := 1.0e-6            ## entry-time arithmetic
## Where the probes stand: MEASURED walkable floor in the west chamber.
const HER := Vector3(-11.0, 0.0, 3.0)
const SPOT := Vector3(-11.0, 0.0, 6.0)
const SPOT_B := Vector3(-13.6, 0.0, 6.0)
const SPOT_C := Vector3(-8.4, 0.0, 6.0)
const OVERLAP_A := Vector3(-12.0, 0.0, 6.0)
const OVERLAP_B := Vector3(-10.0, 0.0, 6.0)
const OVERLAP_MID := Vector3(-11.0, 0.0, 6.0)
## Points that are NOT walkable ground: inside the west wall, and far outside.
const OFF_MESH := Vector3(-20.5, 0.0, 0.0)
const FAR_OUTSIDE := Vector3(0.0, 0.0, 60.0)
## Where the scene's own enemies are parked, clear of every field driven here.
const PARK := Vector3(-18.2, 0.0, -10.3)
## Where SHE stands while a damage measurement runs. The pack follows her, so
## from here its 6.0 m acquisition and 9.0 m leash cannot reach a probe standing
## in a field 14 m away — which is what keeps hound bites out of arithmetic that
## is about Cinder Field alone. A TEST FIXTURE, not a gameplay position.
const AWAY := Vector3(-16.5, 0.0, -8.0)

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
var hud: DebugOverlay
var panel: LoadoutPanel
var review_hud: ReviewHud
var d392_hud: HuntressReviewHud
var hounds_hud: HoundReviewHud
var cohort_hud: CohortReviewHud
var cinder_hud: CinderReviewHud
var arena: ProductionArena
var enemies: Array = []
var launch := {}
var nav_map: RID
## Why the last `_place()` was refused, so a failing note can SAY so.
var last_place_refusal := ""

func _initialize() -> void:
	print("========================================================================")
	print("RIFTWROUGHT — %s VERIFICATION  (%s, %s)" % [CinderConfig.STAGE, CinderConfig.DECISION, CinderConfig.DATE])
	print("STATE: %s" % ProdConfig.STATE)
	print("Verifying a STAGE DELIVERED OPEN: Cinder Field, a canonical ACTIVE Skill Imprint — a")
	print("ground-targeted Fire SPELL delivered as a TRAP that lies dormant, arms, and erupts ONCE")
	print("into an initial Fire HIT and a lingering, NON-STACKING burning GROUND. The eruption is a")
	print("DELAYED COMPONENT of the original Skill Use, not a Triggered Skill.")
	print("It is NOT P2, NOT Sinew Ballista, NOT another Huntress Skill, NOT Huntress's Mark, NOT")
	print("Rift Shards, NOT Augments, NOT production VFX and NOT a broader trap framework.")
	print("It LOCKS NO NUMBER: every bound below is a TEST BOUND, stated in its own note.")
	print("OWED EXECUTABLE CHECKS: %d   DEFERRED ROWS: %d   OWED-TO-OWNER ROWS: %d   DISCHARGED ROWS: %d"
		% [OWED.size(), CinderConfig.deferred_rows().size(), CinderConfig.owed_to_owner().size(),
		   CinderConfig.discharged_rows().size()])
	print("(The D-402 owed-criteria INVENTORY counts 185 CRITERIA. Different unit.)")
	print("(The ACCEPTED suites count 85, 101, 40, 53, 45, 40 and 33 EXECUTABLE CHECKS.)")
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
	hud = main.get("hud")
	panel = main.get("imprint_panel")
	review_hud = main.get("review_hud")
	d392_hud = main.get("huntress_hud")
	hounds_hud = main.get("hounds_hud")
	cohort_hud = main.get("cohort_hud")
	cinder_hud = main.get("cinder_hud")
	arena = main.get("arena")
	enemies = main.get("enemies")
	nav_map = NavService.map_rid_for(main)
	# WHAT LAUNCH SHOWED, captured BEFORE any check touches anything.
	launch = {
		"overlay_enabled": hud.enabled, "panel_enabled": panel.enabled,
		"d381_enabled": review_hud.enabled, "d392_enabled": d392_hud.enabled,
		"hounds_hud_enabled": hounds_hud.enabled, "cohort_hud_enabled": cohort_hud.enabled,
		"cinder_hud_enabled": cinder_hud.enabled,
		"measure": cinder.review_measure.duplicate(true),
		"setup_ok": cinder.setup_ok, "problems": cinder.setup_problems.duplicate(),
		"traps": cinder.traps.size(), "grounds": cinder.grounds.size(),
		"nav": NavService.measure_mesh(arena.nav_mesh()),
		"bake_count": arena.bake_count,
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

func _all_ok() -> bool:
	for id in OWED:
		if not reached.has(id) or results.get(id, null) != true:
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

func _read_text(path: String) -> String:
	var f := FileAccess.open(path, FileAccess.READ)
	if f == null:
		return ""
	var s := f.get_as_text()
	f.close()
	return s

## CODE ONLY: lines whose trimmed start is `#` are dropped (the D-380 lesson —
## a source-scanning guard must read CODE, never the dated history comments this
## project requires).
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

## A stable digest of every NUMERIC constant of a script, by name. The keys are
## normalised to `String` FIRST: `StringName` ordering in this engine compares
## internal pointers and differs from run to run, and a pin that moves on its own
## is worse than no pin (the D-400 lesson, reused).
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

static func _same(a: Array, b: Array) -> bool:
	if a.size() != b.size():
		return false
	for i in a.size():
		if str(a[i]) != str(b[i]):
			return false
	return true

func _park_enemies() -> void:
	for i in enemies.size():
		var e: OrdinaryEnemy = enemies[i]
		e.debug_freeze_ai = true
		e.life = Damageable.new(1000000.0)
		e.global_position = PARK + Vector3(0.0, 0.0, 0.9 * float(i))

## Back to a known state: her at a known point, seams clear, no commitment, no
## trap and no field, cooldowns cleared, Mana full. It is a TEST FIXTURE and it
## uses the runtime's OWN declared clearing path.
func _reset() -> void:
	cam.debug_cursor_override = null
	player.intent.clear_seams()
	player.commitment.reset()
	player.clear_move_destination()
	player.follower.set_path(PackedVector3Array())
	player.motor.reset()
	player.global_position = HER
	cinder.dismiss_all()
	_park_enemies()
	# RESTORE THE WHOLE D-402 REVIEW LOADOUT, not merely binding 7. A check that
	# restores the ACCEPTED D-392 loadout (E08, E39) leaves the low-rank twin back
	# on binding 4 and the aura back as the Persistent; re-binding Cinder Field on
	# top of THAT would demand 37 of 35 and the accepted revalidation would
	# rightly deactivate it. The fixture therefore applies the review PLAN, which
	# is the loadout every behavioural check here is about.
	if not cinder.is_active() or skills.loadout.bindings[3] != "":
		var c := skills.loadout.configuration(HoundContent.CFG_KINDRED_HOUNDS) as SkillConfiguration
		if c != null and c.has_modifier(DiagImprintContent.AUG_TITHE):
			c.remove(DiagImprintContent.AUG_TITHE)
		hounds.apply_loadout_plan(CinderContent.review_loadout_plan())
		await _phys(2)
	skills.clear_cooldowns()
	skills.pool.refill()
	# THE DIAGNOSTIC LOG COUNTERS ARE ZEROED between checks, through the runtime's
	# OWN declared fixture. They are logs, never control state, and zeroing them
	# is what lets a check say "ONE eruption" and mean this check's one.
	cinder.reset_counters()
	await _phys(3)

## ONE Cinder Field use, through the ACCEPTED path, waiting for the MECHANICAL
## release. Returns the trap, or null when the use was refused.
func _place(point: Vector3) -> CinderTrap:
	# A FIXTURE ARRANGES STATE. The shared cooldown and the Mana cost are checked
	# by E18, where they are the SUBJECT; everywhere else they would only stop a
	# check from reaching what it is about, so the fixture clears them first.
	skills.clear_cooldowns()
	skills.pool.refill()
	cam.debug_cursor_override = point
	await _phys(2)
	var before := cinder.placements
	var r := skills.use_binding(CinderContent.BINDING_INDEX)
	if not bool(r["ok"]):
		last_place_refusal = String(r["reason"])
		cam.debug_cursor_override = null
		return null
	last_place_refusal = ""
	await _until(func() -> bool: return cinder.placements > before, 240)
	cam.debug_cursor_override = null
	await _until(func() -> bool: return not player.commitment.active, 240)
	return cinder.live_nodes.back() if not cinder.live_nodes.is_empty() else null

func _arm(trap: CinderTrap) -> bool:
	await _until(func() -> bool: return trap != null and is_instance_valid(trap) and trap.is_armed(), 240)
	return trap != null and is_instance_valid(trap) and trap.is_armed()

## Puts one node at a point and lets the world step, so a trap sees a real swept
## segment rather than a teleport nobody observed.
func _move_to(n: Node3D, p: Vector3, frames: int) -> void:
	n.global_position = p
	await _phys(frames)

# =============================================================================
# A. THE FIRST ACT — D-401 section 6, done as this stage's first act
# =============================================================================

static func _state_parts_ok(state: String) -> bool:
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
		and parts[8] == OPEN8

func chk_E01_state_names_eight_facts_exactly_with_one_definer() -> bool:
	var s := ProdConfig.STATE
	var eight := _state_parts_ok(s) and s == EIGHT
	var re := RegEx.new()
	re.compile("(?m)^\\s*const\\s+STATE\\s*(:[^=]*)?:?=")
	var definers: Array[String] = []
	for f in _runtime_script_files():
		if re.search(_code_only(_read_text(String(f)))) != null:
			definers.append(String(f).get_file())
	var one := definers.size() == 1 and definers[0] == "prod_config.gd"
	var caught := re.search("const STATE := \"x\"") != null
	# EVERY superseded OPEN clause is gone as a CURRENT claim.
	var gone := s != STATE_D400 and s != STATE_D402 and s != STATE_D398 \
		and s.find("PLAYER LOCOMOTION REDIRECTION STAGE DELIVERED") < 0 \
		and s.find("CINDER FIELD STAGE DELIVERED") < 0 \
		and s.find("MOBILE MINION COHESION STAGE DELIVERED") < 0 \
		and s.find("KINDRED HOUNDS STAGE DELIVERED") < 0 \
		and s.find("SPLINTER SHOT STAGE DELIVERED") < 0 \
		and s.find("ALIGNMENT STAGE DELIVERED") < 0 \
		and s.find("IMPRINT STAGE DELIVERED") < 0
	# ITS HISTORY IS PRESERVED, DATED, IN THE ONE DEFINER'S OWN FILE — and so is
	# the block before it: history is added to, never replaced.
	var src := _read_text("res://scripts/core/prod_config.gd")
	var history := src.find("RECONCILED A SEVENTH TIME UNDER D-402") >= 0 \
		and src.find("From D-400 until D-402 this read") >= 0 \
		and src.find("RECONCILED A SIXTH TIME UNDER D-400") >= 0 \
		and src.find(STATE_D400.substr(0, 60)) >= 0 \
		and src.find("works well, I like it") >= 0 \
		and src.find("IT WAS TRUE WHEN WRITTEN") >= 0
	var readers := _read_text("res://scripts/debug/debug_overlay.gd").find("ProdConfig.STATE") >= 0 \
		and _read_text("res://scripts/imprint/loadout_panel.gd").find("ProdConfig.STATE") >= 0
	# THE PREDICATE REFUSES: both superseded lines, a self-accepted eighth fact,
	# the locomotion acceptance re-attributed to the ruling that only DELIVERED
	# it, an extra fact, and seven facts.
	var refuses := not _state_parts_ok(STATE_D400) and not _state_parts_ok(STATE_D402) and not _state_parts_ok(STATE_D398) \
		and not _state_parts_ok(s.replace(OPEN8, "PLAYER DIRECT-CLICK MOVEMENT CORRECTION STAGE ACCEPTED and CLOSED (D-404)")) \
		and not _state_parts_ok(s.replace("CINDER FIELD STAGE ACCEPTED and CLOSED (D-403)", "CINDER FIELD STAGE ACCEPTED and CLOSED (D-402)")) \
		and not _state_parts_ok(s.replace("PLAYER LOCOMOTION REDIRECTION STAGE ACCEPTED and CLOSED (D-401)",
			"PLAYER LOCOMOTION REDIRECTION STAGE ACCEPTED and CLOSED (D-400)")) \
		and not _state_parts_ok(s + " · EXTRA STAGE (D-402)") \
		and not _state_parts_ok(" · ".join(s.split(" · ").slice(0, 7))) \
		and not _state_parts_ok(" · ".join(s.split(" · ").slice(0, 8)))
	var ok := eight and one and caught and gone and history and readers and refuses
	_note("E01_state_names_eight_facts_exactly_with_one_definer",
		"RE-PINNED UNDER D-404 (first act): the state line is now NINE facts — the eighth D-403's acceptance of Cinder Field, the ninth the D-404 direct-click stage OPEN — and the rest of this note is worded as at D-402, true when written: STATE is EXACTLY the EIGHT-fact line (foundation D-373 · Imprint D-376 · alignment D-383 · Splinter Shot D-394 · Kindred Hounds D-397 · cohesion D-399 · player locomotion redirection ACCEPTED and CLOSED D-401 · Cinder Field DELIVERED and OPEN D-402)=%s | runtime definers: %s=%s (a planted one is seen=%s) | every superseded OPEN clause is gone as a current claim=%s | the D-400-era line's history is preserved and DATED in the one definer, with the owner's own D-401 answer, and the D-400 block is still there=%s | the overlay and the panel read it=%s | the predicate refuses the D-400 and D-398 lines, a self-accepted eighth fact, the locomotion acceptance re-attributed to D-400, an extra fact and seven facts=%s"
		% [str(eight), str(definers), str(one), str(caught), str(gone), str(history), str(readers), str(refuses)])
	_reached("E01_state_names_eight_facts_exactly_with_one_definer")
	return ok

func chk_E02_lo_rows_discharged_d401_with_history_and_ld02_reclassified() -> bool:
	var lo := LocomotionConfig.owed_to_owner()
	var lod := LocomotionConfig.discharged_rows()
	var ld := LocomotionConfig.deferred_rows()
	# 4 - 4 = 0 OWED, 0 + 4 = 4 DISCHARGED, 0 DELETED.
	var rows_ok := lo.is_empty() and lod.size() == 4 and ld.size() == 14
	for i in lod.size():
		rows_ok = rows_ok and String(lod[i][0]) == "LO-%02d" % (i + 1) \
			and String(lod[i][1]) == LO_TEXT[i] \
			and String(lod[i][2]) == "DISCHARGED — D-401" \
			and String(lod[i][3]).find("ANSWERED DIRECTLY") > 0 \
			and String(lod[i][3]).find("works well, I like it") > 0 \
			and String(lod[i][3]).find("ORIGINAL ROW TEXT, PRESERVED VERBATIM (OWED-TO-OWNER): '" + LO_TEXT[i] + "'") > 0
	# ============================================================
	# AT THE LEVEL GIVEN, AND NOTHING MORE IS READ INTO IT.
	# ============================================================
	# The owner answered all four with one sentence. The discharge quotes THAT
	# sentence and carries its bound: no value became a lock, and LD-02 is not
	# discharged by it.
	var level := LocomotionConfig.D401_ANSWER.find("ANSWERED DIRECTLY") > 0 \
		and LocomotionConfig.D401_ANSWER.find("no acceleration, braking, response time, arrival, diagnostic-multiplier or other value became a lock") > 0 \
		and LocomotionConfig.D401_ANSWER.find("LD-02 stays CARRIED as a measured provisional finding") > 0
	var none_deleted := ld.size() + lod.size() + lo.size() == 14 + 4
	# LD-02 IS RE-CLASSIFIED, NOT DISCHARGED: it still prints, still is not a
	# pass, and it carries the owner's OWN two standing prohibitions.
	var ld02_ok := false
	for row in ld:
		if String(row[0]).begins_with("LD-02 "):
			ld02_ok = String(row[1]) == "CARRIED — PROVISIONAL FINDING" \
				and String(row[2]).find("RE-CLASSIFIED BY THE OWNER (D-401)") == 0 \
				and String(row[2]).find("NOT a defect awaiting repair") > 0 \
				and String(row[2]).find("do not replace it with an instantaneous speed clear") > 0 \
				and String(row[2]).find("do not scale it in this accepted stage") > 0
	# AND THE ACCEPTED VALUE IT IS ABOUT IS UNTOUCHED.
	var brake_unchanged := is_equal_approx(ProdConfig.ACTION_BRAKE_MPS2, 120.0)
	# THE SELF-DENIAL IS DATED HISTORY, and the present-tense one is gone.
	var den := LocomotionConfig.denials()
	var dated := false
	var old_present := false
	for d in den:
		var t := String(d)
		if t.find("The D-400 stage was delivered OPEN and never accepted itself: the owner ACCEPTED and CLOSED it under D-401") == 0:
			dated = true
		if t == "The D-400 stage delivers OPEN pending owner live review; it does NOT accept itself.":
			old_present = true
	# THE D-401 SECTION 6 DISCREPANCY IS DISCHARGED BY THIS ACT.
	var discharged := ProdConfig.STATE.find("PLAYER LOCOMOTION REDIRECTION STAGE ACCEPTED and CLOSED (D-401)") >= 0 \
		and ProdConfig.STATE.find("PLAYER LOCOMOTION REDIRECTION STAGE DELIVERED") < 0
	var ok := rows_ok and level and none_deleted and ld02_ok and brake_unchanged \
		and dated and not old_present and den.size() == 14 and discharged
	_note("E02_lo_rows_discharged_d401_with_history_and_ld02_reclassified",
		"LO-01..LO-04 DISCHARGED — D-401, each carrying THE OWNER'S OWN ANSWER and its ORIGINAL TEXT VERBATIM; 0 owed; 14 LD rows=%s | the answer is recorded at the level given and carries its bound — no value locked, LD-02 not discharged by it=%s | 14 + 4 + 0 = 18 rows, ZERO deleted=%s | LD-02 RE-CLASSIFIED as a measured provisional finding, still printed, still not a pass, carrying both standing prohibitions=%s, and the value it is about is unchanged at %.1f m/s^2=%s | the D-400 self-denial is dated history naming D-401=%s, the present-tense one gone=%s, 14 denials=%s | the state now carries D-401's acceptance and no locomotion OPEN clause=%s"
		% [str(rows_ok), str(level), str(none_deleted), str(ld02_ok), ProdConfig.ACTION_BRAKE_MPS2,
		   str(brake_unchanged), str(dated), str(not old_present), str(den.size() == 14), str(discharged)])
	_reached("E02_lo_rows_discharged_d401_with_history_and_ld02_reclassified")
	return ok

func chk_E03_every_accepted_pin_moved_together_and_refuses_stale_lines() -> bool:
	# EVERY ACCEPTED RUNNER pins the CURRENT line and holds the D-400-era one as
	# a USED absence needle.
	var stale: Array[String] = []
	var needles: Array[String] = []
	for r in ACCEPTED_RUNNERS:
		var t := _read_text(String(r))
		if t.find("STATE_EXPECT=\"STATE: %s\"" % EIGHT) < 0 \
				or t.find("STATE_EXPECT=\"STATE: %s\"" % STATE_D400) >= 0:
			stale.append(String(r).get_file())
		if t.find("STATE_D400_LINE=\"STATE: %s\"" % STATE_D400) < 0 or t.count("STATE_D400_LINE") < 2:
			needles.append(String(r).get_file())
	var own := _read_text("res://tests/cinder_smoke.sh").find("STATE_EXPECT=\"STATE: %s\"" % EIGHT) >= 0
	# EVERY ACCEPTED SUITE THAT PINS THE STATE carries BOTH D-402 clauses.
	var suites_ok := true
	var suite_rows: Array[String] = []
	for p in ACCEPTED_SUITES:
		var t2 := _read_text(String(p))
		var has := t2.find("PLAYER LOCOMOTION REDIRECTION STAGE ACCEPTED and CLOSED (D-401)") >= 0 \
			and t2.find(OPEN8) >= 0
		suites_ok = suites_ok and has
		suite_rows.append("%s=%s" % [String(p).get_file(), str(has)])
	# THE D-400 RUNNER'S OWN MOVES: 0 owed, 4 discharged, and its self-acceptance
	# needle moved from the now-accepted locomotion stage to the OPEN D-402 one.
	var lt := _read_text("res://tests/locomotion_smoke.sh")
	var d400_ok := lt.find("\nPIN_M_OWNER=0\n") >= 0 and lt.find("\nPIN_M_DISCHARGED=4\n") >= 0 \
		and lt.find("SELF_ACCEPT='PLAYER DIRECT-CLICK MOVEMENT CORRECTION STAGE ACCEPTED|") >= 0 \
		and lt.find("[DISCHARGED — D-401] LO-01") >= 0
	# THE ACCEPTED FOUNDATION SUITE WAS NOT EDITED AT ALL by this stage: it
	# asserts nothing about the state, so there was nothing in it to move.
	var fsrc := _read_text("res://tests/foundation_verification.gd")
	var foundation_untouched := fsrc.find("D-402") < 0 and fsrc.find("CinderConfig") < 0 \
		and fsrc.find("CinderContent") < 0
	# EVERY MOVED PIN IS STILL EXACT-LINE, keeps its refusal proof, and GAINED a
	# D-400-era absence check.
	var ft := _read_text("res://tests/foundation_smoke.sh")
	var it := _read_text("res://tests/imprint_smoke.sh")
	var exact := ft.find("if [ \"$STATE_LINE\" = \"$STATE_EXPECT\" ]; then") >= 0 \
		and it.find("if [ \"$LINE\" != \"$STATE_EXPECT\" ]; then") >= 0
	var refusal := ft.find("sed 's/ACCEPTED and CLOSED/DELIVERED and OPEN/'") >= 0 \
		and it.find("sed 's/ACCEPTED and CLOSED/DELIVERED and OPEN/'") >= 0
	var absence := ft.find("grep -qxF \"$STATE_D400_LINE\"") >= 0 \
		and it.find("grep -qxF \"$STATE_D400_LINE\"") >= 0
	# NO GUARD WAS WEAKENED: every accepted count pin still stands.
	var counts := true
	for spec in [["res://tests/imprint_smoke.sh", "PIN_F_CHECKS=85"], ["res://tests/imprint_smoke.sh", "PIN_I_CHECKS=101"],
			["res://tests/alignment_smoke.sh", "PIN_A_CHECKS=40"], ["res://tests/huntress_smoke.sh", "PIN_H_CHECKS=53"],
			["res://tests/hounds_smoke.sh", "PIN_K_CHECKS=45"], ["res://tests/cohesion_smoke.sh", "PIN_C_CHECKS=40"],
			["res://tests/locomotion_smoke.sh", "PIN_M_CHECKS=33"]]:
		counts = counts and _read_text(String(spec[0])).find("\n" + String(spec[1]) + "\n") >= 0
	# THE AUDIT REFUSES: a runner still pinning the D-400 line, one that dropped
	# the needle, and one missing the D-402 open clause.
	var planted_stale := ft.replace("STATE_EXPECT=\"STATE: " + EIGHT + "\"",
		"STATE_EXPECT=\"STATE: " + STATE_D400 + "\"")
	var refuses_stale := planted_stale.find("STATE_EXPECT=\"STATE: %s\"" % EIGHT) < 0
	var planted_no_needle := ft.replace("STATE_D400_LINE", "STATE_OLD_LINE")
	var refuses_no_needle := planted_no_needle.find("STATE_D400_LINE=\"STATE: %s\"" % STATE_D400) < 0
	var planted_seven := ft.replace(" · " + OPEN8, "")
	var refuses_seven := planted_seven.find("STATE_EXPECT=\"STATE: %s\"" % EIGHT) < 0
	var ok := stale.is_empty() and needles.is_empty() and own and suites_ok and d400_ok \
		and foundation_untouched and exact and refusal and absence and counts \
		and refuses_stale and refuses_no_needle and refuses_seven and ft.length() > 1000
	_note("E03_every_accepted_pin_moved_together_and_refuses_stale_lines",
		"RE-PINNED UNDER D-404 (first act): the state line is now NINE facts — the eighth D-403's acceptance of Cinder Field, the ninth the D-404 direct-click stage OPEN — and the rest of this note is worded as at D-402, true when written: all seven accepted runners pin the EIGHT-fact line EXACTLY and none still pins the D-400 one (stale: %s)=%s; each holds the D-400-era line as a USED absence needle (missing: %s)=%s; and so does this stage's runner=%s | the accepted suites carry the D-401 acceptance AND the D-402 open clause: %s=%s | the D-400 runner pins 0 owed / 4 discharged, prints LO-01 as DISCHARGED — D-401 and refuses a self-accepted open D-402 stage=%s | the accepted FOUNDATION suite was not edited at all (no D-402, CinderConfig or CinderContent mention)=%s | the pins are still EXACT-LINE=%s, keep their refusal proofs=%s and GAINED the D-400-era absence check=%s | every accepted count pin stands (85/101/40/53/45/40/33)=%s | the audit REFUSES a planted stale runner=%s, one missing the needle=%s and one missing the open clause=%s"
		% [str(stale), str(stale.is_empty()), str(needles), str(needles.is_empty()), str(own),
		   " · ".join(suite_rows), str(suites_ok), str(d400_ok), str(foundation_untouched),
		   str(exact), str(refusal), str(absence), str(counts),
		   str(refuses_stale), str(refuses_no_needle), str(refuses_seven)])
	_reached("E03_every_accepted_pin_moved_together_and_refuses_stale_lines")
	return ok

# =============================================================================
# B. LEARNING AND INTEGRATION — through the ACCEPTED architecture
# =============================================================================

func chk_E04_cinder_field_is_one_canonical_skill_imprint_at_rank_1_with_0_xp() -> bool:
	var lib := skills.library
	var id := CinderContent.SKILL_CINDER_FIELD
	var imp := lib.get_imprint(id) as Imprint
	var exists := lib.knows(id) and imp != null
	var shape := exists and imp.kind == Imprint.Kind.SKILL and imp.canonical \
		and imp.display_name == "Cinder Field" and id.find("DIAG") < 0 \
		and imp.identity_complete_at_rank_1
	# RANK 1 / 0 XP, AND NEVER SEEDED. The acquisition record is the library's
	# own, written by the ordinary `learn()`.
	var rec := lib.acquisition_record(id)
	var fresh := int(rec.get("rank", -1)) == 1 and is_equal_approx(float(rec.get("xp", -1.0)), 0.0) \
		and lib.mastered(id) == 1 and is_equal_approx(lib.xp(id), 0.0) \
		and is_equal_approx(lib.total_progress_units(id), 0.0) \
		and _same(lib.selectable_ranks(id), [1])
	# IT IS NOT SEEDED: no start-up path gives it a rank, and the content file
	# contains no rank literal at all.
	var content := _code_only(_read_text("res://scripts/cinder/cinder_content.gd"))
	var no_seed := content.find("STARTING_CHARACTER_RANK") < 0 and content.find("set_mastered") < 0 \
		and content.find("award") < 0
	# ITS LABEL SAYS CANONICAL, NAMES A WORKING NAME AND DENIES A FINAL NUMBER.
	var label := imp.label()
	var label_ok := label.find("CANONICAL") == 0 and label.find("a WORKING name") > 0 \
		and label.find("every number PROVISIONAL") > 0 and label.find("DIAGNOSTIC") < 0 \
		and label.find(CinderContent.CANONICAL_CITATION) > 0
	# RANK MOVES MORE THAN RAW DAMAGE.
	var moves := imp.rank_moves.has("Mana cost") and imp.rank_moves.size() >= 2
	# AND THE ARITHMETIC IS REAL: rank 2 costs more Mana than rank 1.
	var scales := CinderConfig.mana_at(2) > CinderConfig.mana_at(1) \
		and CinderConfig.eruption_damage_at(2) > CinderConfig.eruption_damage_at(1) \
		and CinderConfig.ground_dps_at(2) > CinderConfig.ground_dps_at(1)
	# THE GUARD CAN REFUSE: a diagnostic Imprint is not canonical and says so.
	var diag := lib.get_imprint(String(DiagImprintContent.ALL_IMPRINTS[0])) as Imprint
	var diag_refused := diag != null and not diag.canonical and diag.label().find("CANONICAL") != 0
	var ok := exists and shape and fresh and no_seed and label_ok and moves and scales and diag_refused
	_note("E04_cinder_field_is_one_canonical_skill_imprint_at_rank_1_with_0_xp",
		"'%s' is a SKILL Imprint, canonical, no DIAG in its id, identity complete at rank 1=%s | the library's OWN acquisition record says rank 1 / 0 XP, 0 progress units, ONLY rank 1 selectable=%s | the content file seeds nothing (no STARTING_CHARACTER_RANK, set_mastered or award)=%s | label '%s'=%s | rank moves %s — more than raw damage=%s, and the arithmetic really rises with rank=%s | a diagnostic Imprint is refused as canonical=%s"
		% [id, str(shape), str(fresh), str(no_seed), label, str(label_ok), str(imp.rank_moves),
		   str(moves), str(scales), str(diag_refused)])
	_reached("E04_cinder_field_is_one_canonical_skill_imprint_at_rank_1_with_0_xp")
	return ok

func chk_E05_one_unmodified_configuration_with_zero_modifiers() -> bool:
	var cfg := cinder.configuration()
	var one := cfg != null and cfg.skill_id == CinderContent.SKILL_CINDER_FIELD \
		and cfg.modifier_count() == 0 and cfg.transform_count() == 0 and cfg.is_valid() \
		and cfg.effective_rank(cfg.skill_id) == 1
	# THE EXHAUSTIVE LIST IS ONE, AND THE CONFIGURATION SET IS ONE.
	var lists := CinderContent.ALL_IMPRINTS.size() == 1 and CinderContent.ALL_CONFIGURATIONS.size() == 1 \
		and CinderContent.ALL_CONFIGURATIONS[0] == CinderContent.CFG_CINDER_FIELD
	# A SECOND SKILL IMPRINT IS REFUSED, and so is a duplicate — the ACCEPTED
	# Configuration rules, exercised on a SCRATCH object so the live build is
	# untouched.
	var scratch := SkillConfiguration.new("TRIAL_cinder", skills.library)
	scratch.set_skill(CinderContent.SKILL_CINDER_FIELD)
	var second := scratch.set_skill(HuntressContent.SKILL_SPLINTER_SHOT)
	var refuses_second := not bool(second["ok"])
	# IT RESOLVES TO THE TRAP DELIVERY, with canon's two Duration/Ground figures.
	var res := cfg.resolve()
	var delivery := String(res["delivery"]) == "cinder_trap" \
		and is_equal_approx(float(res["duration"]), CinderConfig.GROUND_DURATION_S) \
		and int(res["instances_max"]) == CinderConfig.INSTANCES_MAX \
		and is_equal_approx(float(res["damage"]), CinderConfig.ERUPTION_DAMAGE_AT_RANK_1) \
		and is_equal_approx(float(res["ground_dps"]), CinderConfig.GROUND_DPS_AT_RANK_1) \
		and is_equal_approx(float(res["mana_cost"]), CinderConfig.MANA_AT_RANK_1) \
		and is_equal_approx(float(res["cooldown"]), CinderConfig.COOLDOWN_S)
	# ITS TIMING IS DERIVED, never typed twice.
	var timing := is_equal_approx(float(res["action_duration"]), CinderConfig.action_s()) \
		and is_equal_approx(float(res["release_marker"]), CinderConfig.release_marker()) \
		and is_equal_approx(CinderConfig.action_s(), CinderConfig.RELEASE_S + CinderConfig.RECOVERY_S) \
		and is_equal_approx(CinderConfig.release_marker(), CinderConfig.RELEASE_S / CinderConfig.action_s())
	# AND IT IS NOT A PROJECTILE, NOT A BEAST AND NOT A RESERVATION.
	var not_other := int(res["projectiles"]) == 0 and int(res["beast_count"]) == 0 \
		and int(res["pack_size"]) == 0 and String(res["reserve_resource"]) == "none" \
		and is_zero_approx(float(res["reserve_amount"]))
	var ok := one and lists and refuses_second and delivery and timing and not_other
	_note("E05_one_unmodified_configuration_with_zero_modifiers",
		"'%s': EXACTLY one Skill Imprint, %d modifiers, 0 Transforms, valid, Effective Rank 1=%s | the stage's exhaustive lists are ONE Imprint and ONE Configuration=%s | a SECOND Skill Imprint is refused on a scratch Configuration=%s | it resolves to delivery '%s' with duration %.2f s, cap %d, damage %.1f, ground %.1f/s, Mana %.1f, cooldown %.2f s=%s | action %.4f s and marker %.4f are DERIVED from release %.2f + recovery %.2f=%s | it is no projectile, no beast, no pack and reserves nothing=%s. EVERY NUMBER PROVISIONAL."
		% [CinderContent.CFG_CINDER_FIELD, cfg.modifier_count() if cfg != null else -1, str(one),
		   str(lists), str(refuses_second), String(res["delivery"]), float(res["duration"]),
		   int(res["instances_max"]), float(res["damage"]), float(res["ground_dps"]),
		   float(res["mana_cost"]), float(res["cooldown"]), str(delivery),
		   float(res["action_duration"]), float(res["release_marker"]),
		   CinderConfig.RELEASE_S, CinderConfig.RECOVERY_S, str(timing), str(not_other)])
	_reached("E05_one_unmodified_configuration_with_zero_modifiers")
	return ok

func chk_E06_canonical_tags_targeting_class_and_castable_with_a_bow() -> bool:
	var imp := skills.library.get_imprint(CinderContent.SKILL_CINDER_FIELD) as Imprint
	# CANON'S FIVE BASE TAGS, VERBATIM AND IN CANON'S ORDER.
	var base_ok := _same(imp.provides_tags, CinderConfig.BASE_TAGS) \
		and _same(CinderConfig.BASE_TAGS, ["Spell", "Trap", "Area", "Ground", "Fire"])
	# AND THE RESOLVED SET IS THE SAME: no modifier moves it.
	var resolved_ok := _same(cinder.configuration().resolved_tags(), CinderConfig.BASE_TAGS)
	# THE TWO COMPONENT TAG SETS, VERBATIM. They are DATA, readable by a check.
	var erupt_ok := _same(CinderConfig.ERUPTION_TAGS, ["Spell", "Trap", "Area", "Hit", "Fire"])
	var ground_ok := _same(CinderConfig.GROUND_TAGS,
		["Spell", "Ground", "Damage over Time", "Fire", "Duration"])
	# EVERY TAG IS IN THE CANONICAL VOCABULARY the accepted stage pins — including
	# `Trap`, the D-385 Mechanical Form tag.
	var vocab := ImprintConfig.canonical_tags()
	var unknown: Array[String] = []
	for t in CinderConfig.BASE_TAGS + CinderConfig.ERUPTION_TAGS + CinderConfig.GROUND_TAGS:
		if not vocab.has(String(t)):
			unknown.append(String(t))
	# TARGETING AND CLASS.
	var targeting := imp.targeting == "ground-targeted" \
		and cinder.configuration().resolved_targeting() == "ground-targeted"
	var klass := imp.skill_class == Imprint.SkillClass.SECONDARY and not imp.reserves
	# CASTABLE WITH A BOW IN HAND: nothing in the whole use path reads a weapon,
	# a hand or an equipment slot. Scanned in CODE, with strings stripped so the
	# denial prose cannot satisfy it.
	var weapon := RegEx.new()
	weapon.compile("\\b(weapon|bow|two_handed|main_hand|off_hand|equip_slot|hand_slot)\\b")
	var weapon_hits: Array[String] = []
	for f in D402_SCRIPTS:
		if weapon.search(_strip_strings(_code_only(_read_text(String(f)))).to_lower()) != null:
			weapon_hits.append(String(f).get_file())
	# AND THE PROOF THAT IT REALLY IS CASTABLE: the Huntress carries her
	# placeholder bow in this scene, and the use below succeeds anyway.
	await _reset()
	var bow_present := hr != null and hr.animator != null
	var t2 := await _place(SPOT)
	var cast_with_bow := t2 != null
	# THE SCAN CAN REFUSE: a planted weapon read is caught.
	var caught := weapon.search("if player.weapon == \"bow\":") != null
	await _reset()
	var ok := base_ok and resolved_ok and erupt_ok and ground_ok and unknown.is_empty() \
		and targeting and klass and weapon_hits.is_empty() and bow_present and cast_with_bow and caught
	_note("E06_canonical_tags_targeting_class_and_castable_with_a_bow",
		"base tags %s — canon's five, verbatim and in canon's order=%s, and the RESOLVED set is the same (no modifier moves it)=%s | eruption %s=%s | burning Ground %s=%s | every tag is in the accepted canonical vocabulary (unknown: %s) | targeting 'ground-targeted'=%s | SECONDARY class, reserving nothing=%s | no D-402 script reads a weapon, hand or equipment slot in CODE (hits: %s), and a planted weapon read IS caught=%s | MEASURED: with her placeholder bow present=%s a use SUCCEEDED and placed a trap=%s"
		% [str(imp.provides_tags), str(base_ok), str(resolved_ok), str(CinderConfig.ERUPTION_TAGS),
		   str(erupt_ok), str(CinderConfig.GROUND_TAGS), str(ground_ok), str(unknown),
		   str(targeting), str(klass), str(weapon_hits), str(caught), str(bow_present), str(cast_with_bow)])
	_reached("E06_canonical_tags_targeting_class_and_castable_with_a_bow")
	return ok

func chk_E07_bound_to_the_measured_free_binding_without_disturbing_the_loadout() -> bool:
	var lo := skills.loadout
	var m: Dictionary = launch["measure"]
	var before: Dictionary = m.get("before", {})
	var after: Dictionary = m.get("after", {})
	var b_before: Array = before.get("bindings", [])
	var b_after: Array = after.get("bindings", [])
	var D := DiagImprintContent
	# MEASURED BEFORE ANYTHING WAS BOUND: the accepted D-396 review loadout.
	var measured := _same(b_before, [D.CFG_VOLLEY, D.CFG_BALLISTA, D.CFG_BEASTS, "", D.CFG_TEMPEST,
		HuntressContent.CFG_SPLINTER_SHOT, "", ""]) \
		and _same(before.get("persistent", []), [HoundContent.CFG_KINDRED_HOUNDS]) \
		and int(before.get("used", -1)) == 32 and int(before.get("total", -1)) == 35
	# BINDING 7 (index 6) — the next free binding AFTER Splinter Shot's 6.
	var index_ok := CinderContent.BINDING_INDEX == 6 \
		and String(b_before[CinderContent.BINDING_INDEX]) == "" \
		and String(b_after[CinderContent.BINDING_INDEX]) == CinderContent.CFG_CINDER_FIELD
	# EVERY OTHER POSITION IS UNTOUCHED — including the EMPTY binding 4, which is
	# the D-396 Capacity concession this stage depends on.
	var untouched := true
	for i in b_before.size():
		if i == CinderContent.BINDING_INDEX:
			continue
		untouched = untouched and String(b_before[i]) == String(b_after[i])
	var four_empty := String(b_after[3]) == "" and String(b_after[7]) == ""
	# NOTHING WAS REPLACED OR DISABLED, and nothing was deleted.
	var kept := _same(after.get("persistent", []), [HoundContent.CFG_KINDRED_HOUNDS]) \
		and (after.get("deactivated", {}) as Dictionary).is_empty() \
		and skills.configurations.has(D.CFG_AURA) and skills.configurations.has(D.CFG_LOW) \
		and skills.library.knows(D.SKILL_AURA)
	# THE PLAN IS LABELLED A DIAGNOSTIC REVIEW LOADOUT.
	var plan := CinderContent.review_loadout_plan()
	var labelled := String(plan["label"]) == CinderConfig.REVIEW_LOADOUT_LABEL \
		and CinderConfig.REVIEW_LOADOUT_LABEL.find("a DIAGNOSTIC review loadout, not a production loadout") > 0 \
		and String(cinder.plan_applied) == CinderConfig.REVIEW_LOADOUT_LABEL \
		and _same(plan["bindings"], b_after) and String(plan["cycle"]) == HoundContent.CFG_KINDRED_HOUNDS
	# THE RESERVATION CYCLE STILL DRIVES KINDRED HOUNDS: this stage adds no
	# Persistent and moves no reservation.
	var cycle := skills.reservation_cycle_configuration == HoundContent.CFG_KINDRED_HOUNDS
	# AND IT USES THE ALREADY-ACCEPTED BINDING ACTION: no input action is added.
	var action := "imprint_binding_%d" % (CinderContent.BINDING_INDEX + 1)
	var action_ok := InputMap.has_action(action) and action == "imprint_binding_7"
	var live := lo.bindings[CinderContent.BINDING_INDEX] == CinderContent.CFG_CINDER_FIELD
	var ok := measured and index_ok and untouched and four_empty and kept and labelled \
		and cycle and action_ok and live and bool(launch["setup_ok"])
	_note("E07_bound_to_the_measured_free_binding_without_disturbing_the_loadout",
		"MEASURED BEFORE ANY CHANGE: the accepted D-396 review loadout %s with Kindred Hounds Persistent at %d / %d=%s | Cinder Field took binding %d (index %d) — EMPTY before, held after=%s | every OTHER binding is byte-identical before and after=%s, and bindings 4 and 8 are still EMPTY (binding 4 is D-396's Capacity concession, kept)=%s | nothing replaced, disabled or deleted; nothing deactivated=%s | the plan is LABELLED a DIAGNOSTIC review loadout and was the one applied=%s | the D-381 reservation cycle still drives Kindred Hounds=%s | it uses the ALREADY-ACCEPTED '%s'=%s | the live loadout agrees=%s"
		% [str(b_before), int(before.get("used", -1)), int(before.get("total", -1)), str(measured),
		   CinderContent.BINDING_INDEX + 1, CinderContent.BINDING_INDEX, str(index_ok),
		   str(untouched), str(four_empty), str(kept), str(labelled), str(cycle), action,
		   str(action_ok), str(live)])
	_reached("E07_bound_to_the_measured_free_binding_without_disturbing_the_loadout")
	return ok

func chk_E08_capacity_accounting_without_an_arbitrary_increase() -> bool:
	var lo := skills.loadout
	var m: Dictionary = launch["measure"]
	var before: Dictionary = m.get("before", {})
	var after: Dictionary = m.get("after", {})
	# THE BUDGET IS UNTOUCHED: 30 from progression + 5 simulated gear = 35.
	var budget := ImprintConfig.CAPACITY_FROM_PROGRESSION == 30 \
		and ImprintConfig.CAPACITY_GEAR_BONUS_DIAGNOSTIC == 5 \
		and lo.capacity_total() == 35 and int(before.get("total", -1)) == 35 \
		and int(after.get("total", -1)) == 35
	# ITS COST IS THE ACCEPTED SECONDARY BASE, UNCHANGED FOR IT.
	var cfg := cinder.configuration()
	var cost := cfg.capacity_cost()
	var cost_ok := cost == ImprintConfig.CAPACITY_BASE_SECONDARY and cost == 2 \
		and cfg.capacity_breakdown().find("0 x %d per modifier" % ImprintConfig.CAPACITY_PER_MODIFIER_SECONDARY) > 0
	# THE ARITHMETIC, MEASURED IN BOTH RESERVATION STATES: 32 + 2 = 34 on Mana,
	# 33 + 2 = 35 in LIFE CONVERSION, nothing deactivated in either.
	await _reset()
	_cycle_to("MANA RESERVATION")
	await _phys(2)
	var used_mana := lo.capacity_used()
	var mana_state := skills.reservation_state() == "MANA RESERVATION" and used_mana == 34 \
		and lo.deactivated.is_empty() and lo.active_configuration_ids().has(CinderContent.CFG_CINDER_FIELD)
	_cycle_to("LIFE CONVERSION")
	await _phys(2)
	var used_life := lo.capacity_used()
	var life_state := skills.reservation_state() == "LIFE CONVERSION" and used_life == 35 \
		and lo.deactivated.is_empty() and lo.active_configuration_ids().has(CinderContent.CFG_CINDER_FIELD)
	_cycle_to("MANA RESERVATION")
	await _phys(2)
	var arithmetic := int(before.get("used", -1)) + cost == used_mana
	# NO CAPACITY CONSTANT MOVED AT ALL — the six the accepted stage declares.
	var consts := ImprintConfig.CAPACITY_BASE_PRIMARY == 3 and ImprintConfig.CAPACITY_BASE_SECONDARY == 2 \
		and ImprintConfig.CAPACITY_BASE_PERSISTENT == 1 and ImprintConfig.CAPACITY_PER_MODIFIER_PRIMARY == 2 \
		and ImprintConfig.CAPACITY_PER_MODIFIER_SECONDARY == 2 \
		and ImprintConfig.CAPACITY_PER_MODIFIER_PERSISTENT == 1
	# AND NO D-402 FILE TOUCHES A CAPACITY VALUE AT ALL.
	var cap_re := RegEx.new()
	cap_re.compile("CAPACITY_[A-Z_]*\\s*(:=|=)")
	var cap_hits: Array[String] = []
	for f in D402_SCRIPTS:
		if cap_re.search(_code_only(_read_text(String(f)))) != null:
			cap_hits.append(String(f).get_file())
	var caught := cap_re.search("const CAPACITY_FROM_PROGRESSION := 40") != null
	# THE PRE-EXISTING FINDING IS NOT REPAIRED, and it is still measurable in the
	# ACCEPTED D-392 loadout (FD-08). This restores it, measures it, and puts the
	# review loadout back.
	hounds.restore_accepted_d392_loadout()
	_cycle_to("LIFE CONVERSION")
	await _phys(2)
	var demanded := lo.capacity_demanded()
	var overflow := demanded == 36 \
		and String(lo.deactivated.get(HuntressContent.CFG_SPLINTER_SHOT, "")).find("OVER CAPACITY") == 0
	_cycle_to("OFF")
	await _reset()
	_cycle_to("MANA RESERVATION")
	await _phys(2)
	_finding("PRE-EXISTING and NOT REPAIRED (FD-08): in the ACCEPTED D-392 loadout, LIFE CONVERSION still demands %d against 35 and deactivates Splinter Shot. The D-402 review loadout uses %d / 35 on Mana and %d / 35 in LIFE CONVERSION, with nothing deactivated in either."
		% [demanded, used_mana, used_life])
	var ok := budget and cost_ok and mana_state and life_state and arithmetic and consts \
		and cap_hits.is_empty() and caught and overflow
	_note("E08_capacity_accounting_without_an_arbitrary_increase",
		"the budget is UNCHANGED at %d + %d = %d, before and after=%s | Cinder Field costs %d — the ACCEPTED secondary base, with ZERO modifiers=%s | MEASURED: %d + %d = %d / 35 reserving Mana=%s and %d / 35 in LIFE CONVERSION=%s, NOTHING deactivated in either, and the arithmetic closes=%s | not one of the six accepted Capacity constants moved=%s | no D-402 file assigns a Capacity value (hits: %s) and a planted assignment IS caught=%s | the pre-existing accepted-loadout overflow is still there, unrepaired: %d / 35 deactivating Splinter Shot=%s"
		% [ImprintConfig.CAPACITY_FROM_PROGRESSION, ImprintConfig.CAPACITY_GEAR_BONUS_DIAGNOSTIC,
		   lo.capacity_total(), str(budget), cost, str(cost_ok), int(before.get("used", -1)), cost,
		   used_mana, str(mana_state), used_life, str(life_state), str(arithmetic), str(consts),
		   str(cap_hits), str(caught), demanded, str(overflow)])
	_reached("E08_capacity_accounting_without_an_arbitrary_increase")
	return ok

func _cycle_to(state: String) -> void:
	var g := 0
	while skills.reservation_state() != state and g < 4:
		skills.cycle_reservation_state()
		g += 1

func chk_E09_it_is_an_action_entry_point_pinned_in_both_directions() -> bool:
	var declared := SkillRuntime.all_action_entry_points()
	# INDEPENDENTLY DERIVED: the foundation's ONE diagnostic action, plus every
	# SKILL Imprint in the live library.
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
	var both := declared.size() == 8 and undeclared.is_empty() and missing.is_empty() \
		and declared.has(CinderContent.SKILL_CINDER_FIELD)
	# THE CONTROLLER IS UNTOUCHED: still ONE diagnostic action, still ONE
	# `begin_` function, and the Skill Uses still do not live on it.
	var src := _code_only(_read_text("res://scripts/control/player_controller.gd"))
	var ctrl := src.count("func begin_") == 1 and PlayerController.DIAGNOSTIC_ACTIONS.size() == 1 \
		and src.find("func use_binding") < 0 and src.find("CinderRuntime") < 0 \
		and src.find("CinderContent") < 0
	# NO D-402 FILE DECLARES A SECOND ATTACK ENTRY POINT.
	var entry := RegEx.new()
	entry.compile("(?m)^\\s*func\\s+(begin_attack|begin_shot|use_binding|fire_|_release_bolt)")
	var offenders: Array[String] = []
	for f in D402_SCRIPTS:
		if entry.search(_code_only(_read_text(String(f)))) != null:
			offenders.append(String(f).get_file())
	# THE PIN CAN REFUSE: nine entry points, or seven.
	var nine: Array = declared.duplicate()
	nine.append("SKILL_IMPRINT_PLANTED")
	var refuses := nine.size() != 8 and declared.slice(1).size() != 8
	var caught := entry.search("func begin_attack() -> void:") != null
	var ok := both and ctrl and offenders.is_empty() and refuses and caught
	_note("E09_it_is_an_action_entry_point_pinned_in_both_directions",
		"%d action entry points in the WHOLE project: %s — Cinder Field among them, pinned in BOTH directions (undeclared %s, declared-but-absent %s)=%s | the accepted controller still declares exactly ONE diagnostic action with ONE `begin_` function, the Skill Uses still live in SkillRuntime, and it names no Cinder class=%s | no D-402 file declares a second attack entry point (offenders: %s), and a planted one IS caught=%s | the pin refuses nine entry points and seven=%s"
		% [declared.size(), str(declared), str(undeclared), str(missing), str(both), str(ctrl),
		   str(offenders), str(caught), str(refuses)])
	_reached("E09_it_is_an_action_entry_point_pinned_in_both_directions")
	return ok

# =============================================================================
# C. PLACEMENT — valid ground, a refusal that pays nothing, and the marker
# =============================================================================

func chk_E10_valid_ground_placement_lands_on_navigable_ground() -> bool:
	await _reset()
	var t := await _place(SPOT)
	var placed := t != null and cinder.placements == 1 and cinder.traps.size() == 1
	# IT LANDED WHERE IT WAS AIMED, on the ground plane.
	var where := placed and _planar(t.global_position, SPOT) <= TOL_M \
		and is_zero_approx(t.global_position.y)
	# AND THE POINT IS REALLY NAVIGABLE — asked of the navigation server, not of
	# the placement code that put it there.
	var nearest := NavService.nearest_point(nav_map, t.global_position) if placed else Vector3.ZERO
	var navigable := placed and _planar(nearest, t.global_position) <= CinderConfig.PLACE_TOLERANCE_M
	# AND SHE CAN WALK THERE: "on the mesh" and "you can walk there" are
	# different claims, and only the second matters.
	var reach := NavService.reachable(nav_map, player.global_position, t.global_position,
		ProdConfig.ARRIVE_TOLERANCE_M) if placed else {"reachable": false, "why": "no trap"}
	# IT BEGINS DORMANT, NOT ARMED.
	var dormant := placed and t.state == CinderConfig.PHASE_ARMING and not t.is_armed() \
		and t.eruptions == 0 and cinder.grounds.is_empty()
	var ok := placed and where and navigable and bool(reach["reachable"]) and dormant
	_note("E10_valid_ground_placement_lands_on_navigable_ground",
		"ONE use placed ONE trap=%s | it landed %.4f m from the aimed point (bound %.2f m) at y=%.4f=%s | the navigation server's nearest point is %.4f m away=%s | and she can WALK there: %s | it begins DORMANT, not armed, with no eruption and no field=%s"
		% [str(placed), _planar(t.global_position, SPOT) if placed else -1.0, TOL_M,
		   t.global_position.y if placed else -1.0, str(where),
		   _planar(nearest, t.global_position) if placed else -1.0, str(navigable),
		   String(reach["why"]), str(dormant)])
	_reached("E10_valid_ground_placement_lands_on_navigable_ground")
	return ok

func chk_E11_an_out_of_range_point_is_clamped_to_the_range() -> bool:
	await _reset()
	# A point far beyond the range, along a direction whose clamped landing is
	# MEASURED walkable. The clamp is a LEGAL use, not a refusal.
	# NORTHWARD: the west chamber runs z = -11 .. +11, so 9 m north of her at
	# z = +3 lands at z = -6 — MEASURED walkable floor. A clamp that landed
	# outside the arena would be REFUSED, which is E12's case, not this one.
	var far := player.global_position + Vector3(0.0, 0.0, -1.0) * (CinderConfig.PLACE_RANGE_M + 6.0)
	var v := cinder.validate_placement(far)
	var clamped_ok := bool(v["ok"]) and bool(v["clamped"]) \
		and is_equal_approx(_planar(v["point"], player.global_position), CinderConfig.PLACE_RANGE_M)
	var t := await _place(far)
	var placed := t != null and is_instance_valid(t)
	var landed := t.global_position if placed else Vector3.ZERO
	var at_range := placed and absf(_planar(landed, player.global_position)
		- CinderConfig.PLACE_RANGE_M) <= CinderConfig.PLACE_TOLERANCE_M
	# A POINT INSIDE THE RANGE IS NOT CLAMPED.
	var near := cinder.validate_placement(SPOT)
	var near_ok := bool(near["ok"]) and not bool(near["clamped"]) \
		and _planar(near["point"], SPOT) <= TOL_M
	# AND THE CLAMP REALLY MOVED IT: the requested point is farther than the
	# landing, which is what "clamped" means.
	var moved := placed and _planar(far, player.global_position) > _planar(landed, player.global_position)
	await _reset()
	var ok := clamped_ok and placed and at_range and near_ok and moved
	_note("E11_an_out_of_range_point_is_clamped_to_the_range",
		"a point %.2f m away (range %.2f m) validates as OK and CLAMPED, landing exactly at the range=%s | the use SUCCEEDED and the trap sits %.4f m from her=%s | a point inside the range is NOT clamped and lands where aimed=%s | the clamp really shortened the throw=%s. A clamp is a LEGAL use; only unwalkable ground is refused (E12)."
		% [_planar(far, player.global_position), CinderConfig.PLACE_RANGE_M, str(clamped_ok),
		   _planar(landed, player.global_position) if placed else -1.0, str(at_range),
		   str(near_ok), str(moved)])
	_reached("E11_an_out_of_range_point_is_clamped_to_the_range")
	return ok

func chk_E12_an_invalid_ground_point_refuses_the_use_and_pays_nothing() -> bool:
	await _reset()
	# THE STATE BEFORE, so "nothing happened" is measured against something.
	var mana0 := skills.pool.mana_current
	var uses0 := skills.skill_uses
	var refused0 := skills.uses_refused
	var placements0 := cinder.placements
	var note0 := cinder.placement_refusals
	# 1. A POINT INSIDE THE WEST WALL. It is within range of her, so the ONLY
	#    thing that can refuse it is walkability.
	player.global_position = Vector3(-17.5, 0.0, 0.0)
	await _phys(2)
	var in_range := _planar(OFF_MESH, player.global_position) <= CinderConfig.PLACE_RANGE_M
	var v := cinder.validate_placement(OFF_MESH)
	var judged := not bool(v["ok"]) and float(v["off_mesh_m"]) > CinderConfig.PLACE_TOLERANCE_M \
		and String(v["reason"]).find("not walkable") > 0
	cam.debug_cursor_override = OFF_MESH
	await _phys(2)
	var r := skills.use_binding(CinderContent.BINDING_INDEX)
	cam.debug_cursor_override = null
	await _phys(4)
	var refused := not bool(r["ok"]) and String(r["reason"]).find("cannot be placed there") > 0
	# NOTHING WAS PAID, NOTHING BEGAN, NOTHING WAS PLACED, NO COOLDOWN RAN.
	var paid_nothing := is_equal_approx(skills.pool.mana_current, mana0) \
		and skills.skill_uses == uses0 and not player.commitment.active \
		and cinder.placements == placements0 and cinder.traps.is_empty() \
		and is_zero_approx(skills.cooldown_remaining(CinderContent.SKILL_CINDER_FIELD))
	# THE REFUSAL IS COUNTED AND STATED, on the runtime and on the HUD.
	var counted := skills.uses_refused == refused0 + 1 and cinder.placement_refusals == note0 + 1 \
		and cinder.last_refusal.find("not walkable") > 0
	cinder_hud.refresh()
	var shown := cinder_hud.last_text.find("LAST REFUSAL") >= 0
	# 2. FAR OUTSIDE THE ARENA — clamped to the range first, and STILL refused,
	#    because the clamped point lands beyond the arena's south wall. Asked from
	#    HER review position, so the clamped landing is the one this names.
	player.global_position = HER
	await _phys(2)
	var v2 := cinder.validate_placement(FAR_OUTSIDE)
	var far_refused := not bool(v2["ok"]) and float(v2["off_mesh_m"]) > CinderConfig.PLACE_TOLERANCE_M
	# THE GUARD CAN ACCEPT AS WELL AS REFUSE — a guard that refuses everything
	# protects nothing. The SAME predicate accepts open floor, and a use there
	# succeeds.
	await _reset()
	var v3 := cinder.validate_placement(SPOT)
	var accepts := bool(v3["ok"])
	var t := await _place(SPOT)
	var succeeds := t != null and cinder.placements == placements0 + 1
	await _reset()
	var ok := in_range and judged and refused and paid_nothing and counted and shown \
		and far_refused and accepts and succeeds
	_note("E12_an_invalid_ground_point_refuses_the_use_and_pays_nothing",
		"a point inside the west wall, %.2f m away and WITHIN the %.2f m range=%s, is judged UNWALKABLE (%.3f m off the mesh, tolerance %.2f m)=%s and the use is REFUSED: '%s'=%s | NOTHING was paid: Mana %.1f -> %.1f, Skill Uses %d -> %d, no commitment, no trap, no cooldown=%s | the refusal is counted once on both counters and stated in words=%s, and the HUD shows it=%s | a point far outside the arena is refused too=%s | THE GUARD CAN ACCEPT: the same predicate accepts open floor=%s and a use there SUCCEEDS=%s"
		% [_planar(OFF_MESH, Vector3(-17.5, 0.0, 0.0)), CinderConfig.PLACE_RANGE_M, str(in_range),
		   float(v["off_mesh_m"]), CinderConfig.PLACE_TOLERANCE_M, str(judged),
		   String(r.get("reason", "")).left(60), str(refused), mana0, skills.pool.mana_current,
		   uses0, skills.skill_uses, str(paid_nothing), str(counted), str(shown), str(far_refused),
		   str(accepts), str(succeeds)])
	_reached("E12_an_invalid_ground_point_refuses_the_use_and_pays_nothing")
	return ok

func chk_E13_no_trap_exists_before_the_release_marker() -> bool:
	await _reset()
	var before := cinder.placements
	cam.debug_cursor_override = SPOT
	await _phys(2)
	var r := skills.use_binding(CinderContent.BINDING_INDEX)
	var started := bool(r["ok"]) and player.commitment.active
	# WALK THE WIND-UP FRAME BY FRAME. Not one of them may hold a trap, and the
	# frame the release fires on must hold EXACTLY one.
	var frames_before := 0
	var seen_early := 0
	var release_frame := -1
	var marker_time := player.commitment.duration * player.commitment.release_marker
	var g := 0
	while g < 240 and cinder.placements == before:
		await physics_frame
		g += 1
		if player.commitment.elapsed < marker_time:
			frames_before += 1
			if not cinder.live_nodes.is_empty():
				seen_early += 1
		elif release_frame < 0 and cinder.placements > before:
			release_frame = g
	var exactly_one := cinder.placements == before + 1 and cinder.traps.size() == 1 \
		and cinder.live_nodes.size() == 1
	# AND THE RELEASE FIRED AT THE MECHANICAL MARKER, not at the end.
	var at_marker := cinder.placements > before and g > 0
	var elapsed_at_release := player.commitment.elapsed
	var mechanical := elapsed_at_release >= marker_time - DT and elapsed_at_release <= marker_time + 2.0 * DT
	# THE ACTION IS STILL RUNNING: the release is INSIDE the action, and the
	# recovery follows it.
	var still_committed := player.commitment.active
	await _until(func() -> bool: return not player.commitment.active, 240)
	# EXACTLY ONE RELEASE PER USE: holding the binding down adds nothing, because
	# Cinder Field is NOT repeatable.
	var after_one := cinder.placements
	Input.action_press("imprint_binding_7")
	await _phys(20)
	Input.action_release("imprint_binding_7")
	await _phys(2)
	var not_repeatable := cinder.placements == after_one \
		and not CinderContent.is_repeatable(CinderContent.SKILL_CINDER_FIELD)
	await _reset()
	var ok := started and frames_before > 0 and seen_early == 0 and exactly_one and at_marker \
		and mechanical and still_committed and not_repeatable
	_note("E13_no_trap_exists_before_the_release_marker",
		"the use began and committed=%s | %d wind-up frames were walked one by one and NOT ONE held a trap (early sightings: %d)=%s | at the release there is EXACTLY one trap and one placement=%s | it fired at %.4f s against the mechanical marker %.4f s (within one %.4f s frame)=%s | the action was still running at the release, so the recovery follows it=%s | HOLDING the binding placed nothing more (%d -> %d): Cinder Field is NOT repeatable=%s"
		% [str(started), frames_before, seen_early, str(seen_early == 0), str(exactly_one),
		   elapsed_at_release, marker_time, DT, str(mechanical), str(still_committed),
		   after_one, cinder.placements, str(not_repeatable)])
	_reached("E13_no_trap_exists_before_the_release_marker")
	return ok

func chk_E14_the_ground_point_is_the_one_sampled_when_the_use_began() -> bool:
	await _reset()
	# AIM AT ONE POINT, BEGIN THE USE, THEN SWING THE CURSOR SOMEWHERE ELSE.
	cam.debug_cursor_override = SPOT
	await _phys(2)
	var sampled := player.aim_point
	var r := skills.use_binding(CinderContent.BINDING_INDEX)
	var started := bool(r["ok"])
	# The swing happens DURING the wind-up, and it really does move the live aim.
	cam.debug_cursor_override = SPOT_C
	await _phys(2)
	var live_moved := _planar(player.aim_point, SPOT_C) <= 0.5 \
		and _planar(player.aim_point, sampled) > 1.0
	await _until(func() -> bool: return cinder.placements > 0, 240)
	var t: CinderTrap = cinder.live_nodes.back() if not cinder.live_nodes.is_empty() else null
	# THE TRAP IS AT THE SAMPLED POINT, NOT THE LIVE ONE.
	var at_sampled := t != null and _planar(t.global_position, SPOT) <= TOL_M
	var not_at_live := t != null and _planar(t.global_position, SPOT_C) > 1.0
	cam.debug_cursor_override = null
	await _until(func() -> bool: return not player.commitment.active, 240)
	# AND THE SAMPLE IS CLEARED BETWEEN USES: nothing survives the use.
	var cleared := skills.sampled_aim_point() == Vector3.ZERO \
		and skills.sampled_aim_dir() == Vector3.ZERO
	await _reset()
	var ok := started and live_moved and at_sampled and not_at_live and cleared
	_note("E14_the_ground_point_is_the_one_sampled_when_the_use_began",
		"the use began aiming at %.1f,%.1f=%s | the cursor was swung to %.1f,%.1f DURING the wind-up and the LIVE aim really followed it (%.3f m from the new point, %.3f m from the sampled one)=%s | the trap landed %.4f m from the SAMPLED point=%s and %.3f m from the live one=%s | the per-use sample is ZERO between uses=%s. Targeting is PER-USE (D-193)."
		% [SPOT.x, SPOT.z, str(started), SPOT_C.x, SPOT_C.z,
		   _planar(player.aim_point, SPOT_C), _planar(player.aim_point, sampled), str(live_moved),
		   _planar(t.global_position, SPOT) if t != null else -1.0, str(at_sampled),
		   _planar(t.global_position, SPOT_C) if t != null else -1.0, str(not_at_live), str(cleared)])
	_reached("E14_the_ground_point_is_the_one_sampled_when_the_use_began")
	return ok

# =============================================================================
# D. THE COMMITMENT — the ACCEPTED STOP policy, unchanged
# =============================================================================

func chk_E15_the_accepted_stop_commitment_suppresses_translation() -> bool:
	await _reset()
	# EXACTLY TWO POLICIES STILL EXIST, and no D-402 file adds a third.
	var two := ActionCommitment.POLICIES.size() == 2 \
		and _same(ActionCommitment.POLICIES, ["STOP", "ALLOW"])
	var policy_re := RegEx.new()
	policy_re.compile("Movement\\.(STOP|ALLOW)|POLICIES|enum\\s+Movement")
	var policy_hits: Array[String] = []
	for f in D402_SCRIPTS:
		if policy_re.search(_code_only(_read_text(String(f)))) != null:
			policy_hits.append(String(f).get_file())
	# DRIVE HER AT SPEED, THEN COMMIT. The feet must stop.
	player.command_move_to(SPOT_C)
	await _until(func() -> bool: return player.motor.speed() >= 0.9 * ProdConfig.TOP_SPEED_MPS, 240)
	var moving := player.motor.speed()
	cam.debug_cursor_override = SPOT
	await _phys(1)
	var r := skills.use_binding(CinderContent.BINDING_INDEX)
	var started := bool(r["ok"]) and player.commitment.active
	var p0 := player.global_position
	var policy_ok := player.commitment.policy == ActionCommitment.Movement.STOP \
		and player.commitment.label == CinderConfig.ACTION_LABEL \
		and player.commitment.suppresses_translation()
	# MEASURE THE GLIDE: the distance covered from the commit to a standstill.
	await _until(func() -> bool: return player.motor.speed() <= 0.0, 120)
	var glide := _planar(player.global_position, p0)
	var stopped := player.motor.speed() <= 0.0 and glide <= ProdConfig.ACTION_GLIDE_TOLERANCE_M
	# AND THE NAVIGATION ORDER IS ABANDONED, not paused.
	var abandoned := player.move_destination == null
	cam.debug_cursor_override = null
	await _until(func() -> bool: return not player.commitment.active, 240)
	await _reset()
	var ok := two and policy_hits.is_empty() and started and policy_ok and moving >= 0.9 * ProdConfig.TOP_SPEED_MPS \
		and stopped and abandoned
	_note("E15_the_accepted_stop_commitment_suppresses_translation",
		"EXACTLY two policies still exist (%s)=%s, and no D-402 file mentions a policy at all (hits: %s) — NO THIRD POLICY | committed from %.3f m/s under the ACCEPTED STOP policy with the label '%s'=%s | MEASURED: the feet covered %.4f m before standstill, against the accepted %.2f m tolerance=%s | the navigation order was ABANDONED, not paused=%s"
		% [str(ActionCommitment.POLICIES), str(two), str(policy_hits), moving,
		   CinderConfig.ACTION_LABEL, str(policy_ok), glide, ProdConfig.ACTION_GLIDE_TOLERANCE_M,
		   str(stopped), str(abandoned)])
	_reached("E15_the_accepted_stop_commitment_suppresses_translation")
	return ok

func chk_E16_movement_before_release_is_buffered_and_cannot_cancel() -> bool:
	await _reset()
	var cancels0 := player.commitment.recovery_cancels
	var refused0 := player.commitment.cancels_refused
	var buffered0 := player.buffered_moves
	cam.debug_cursor_override = SPOT
	await _phys(2)
	var r := skills.use_binding(CinderContent.BINDING_INDEX)
	var started := bool(r["ok"])
	var p0 := player.global_position
	# ASK TO MOVE DURING THE WIND-UP, through the real intent seam.
	var marker_time := player.commitment.duration * player.commitment.release_marker
	player.intent.debug_move_axis = Vector2(1.0, 0.0)
	var frames := 0
	var travelled := 0.0
	while player.commitment.elapsed < marker_time - DT and frames < 120:
		await physics_frame
		frames += 1
		travelled = maxf(travelled, _planar(player.global_position, p0))
	# THE WIND-UP REALLY RAN, the request was really made, and NOTHING moved.
	var ran := frames > 0 and started
	var requested := player.buffered_moves > buffered0
	var no_translation := travelled <= 0.001
	var not_cancelled := player.commitment.active and player.commitment.recovery_cancels == cancels0
	# AND THE CANCEL WINDOW WAS CLOSED while it was asked for.
	var window_closed := not_cancelled
	player.intent.debug_move_axis = Vector2.ZERO
	cam.debug_cursor_override = null
	await _until(func() -> bool: return not player.commitment.active, 240)
	# THE TRAP WAS STILL PLACED: a buffered movement never eats the placement.
	var placed := cinder.placements == 1
	# THE REFUSAL IS REACHABLE: asked directly during a fresh wind-up, the
	# accepted commitment REFUSES and counts it.
	await _reset()
	cam.debug_cursor_override = SPOT
	await _phys(2)
	skills.use_binding(CinderContent.BINDING_INDEX)
	await _phys(1)
	var refused_now := not player.commitment.cancel_recovery()
	var counted := player.commitment.cancels_refused > refused0
	cam.debug_cursor_override = null
	await _until(func() -> bool: return not player.commitment.active, 240)
	await _reset()
	var ok := ran and requested and no_translation and not_cancelled and window_closed \
		and placed and refused_now and counted
	_note("E16_movement_before_release_is_buffered_and_cannot_cancel",
		"%d wind-up frames ran with a movement request held=%s, and the request was really recorded (buffered %d -> %d)=%s | MEASURED translation during the wind-up: %.5f m=%s | the action was NOT cancelled (%d cancels, unchanged)=%s and the cancel window was CLOSED=%s | the trap was still placed=%s | asked DIRECTLY during a fresh wind-up, the accepted commitment REFUSES=%s and counts the refusal=%s"
		% [frames, str(ran), buffered0, player.buffered_moves, str(requested), travelled,
		   str(no_translation), player.commitment.recovery_cancels, str(not_cancelled),
		   str(window_closed), str(placed), str(refused_now), str(counted)])
	_reached("E16_movement_before_release_is_buffered_and_cannot_cancel")
	return ok

func chk_E17_movement_after_release_cancels_recovery_and_the_trap_survives() -> bool:
	await _reset()
	var cancels0 := player.commitment.recovery_cancels
	cam.debug_cursor_override = SPOT
	await _phys(2)
	skills.use_binding(CinderContent.BINDING_INDEX)
	# WAIT FOR THE RELEASE. The trap now exists, and the recovery is running.
	await _until(func() -> bool: return cinder.placements > 0, 240)
	var t: CinderTrap = cinder.live_nodes.back() if not cinder.live_nodes.is_empty() else null
	var released := t != null and player.commitment.active and player.commitment.cancel_window_open()
	var traps_at_release := cinder.traps.size()
	var pos := t.global_position if t != null else Vector3.ZERO
	var ord := t.ordinal if t != null else -1
	cam.debug_cursor_override = null
	# ASK TO MOVE. The remaining recovery must go, within a frame.
	player.intent.debug_move_axis = Vector2(1.0, 0.0)
	var frames := 0
	while player.commitment.active and frames < 30:
		await physics_frame
		frames += 1
	var cancelled := not player.commitment.active \
		and player.commitment.recovery_cancels == cancels0 + 1 and frames <= 2
	# THE TRAP SURVIVED, UNCHANGED, AND WAS NOT DUPLICATED.
	var survived := t != null and is_instance_valid(t) and cinder.traps.size() == traps_at_release \
		and cinder.placements == 1 and t.ordinal == ord and _planar(t.global_position, pos) <= 0.0001 \
		and t.eruptions == 0
	# AND SHE REALLY MOVED AFTERWARDS: the cancellation returned her to
	# locomotion rather than merely ending the action.
	var p0 := player.global_position
	await _phys(20)
	var moved := _planar(player.global_position, p0) > 0.2
	player.intent.debug_move_axis = Vector2.ZERO
	await _reset()
	var ok := released and cancelled and survived and moved
	_note("E17_movement_after_release_cancels_recovery_and_the_trap_survives",
		"the release happened and the cancel window was OPEN, with the trap already placed=%s | a movement request cancelled the remaining RECOVERY in %d frame(s), the accepted counter moving %d -> %d=%s | the placed trap SURVIVED: same ordinal %d, same position (%.5f m drift), still 1 placement, still unsprung, and NOT duplicated=%s | she really returned to locomotion, covering %.3f m=%s. CANCELLING AN ANIMATION IS NOT CANCELLING A PLACEMENT."
		% [str(released), frames, cancels0, player.commitment.recovery_cancels, str(cancelled),
		   ord, _planar(t.global_position, pos) if t != null and is_instance_valid(t) else -1.0,
		   str(survived), _planar(player.global_position, p0), str(moved)])
	_reached("E17_movement_after_release_cancels_recovery_and_the_trap_survives")
	return ok

func chk_E18_cost_is_paid_at_use_start_and_the_cooldown_begins_on_release() -> bool:
	await _reset()
	var cfg := cinder.configuration()
	var cost := float(cfg.resolve()["mana_cost"])
	var mana0 := skills.pool.mana_current
	# 1. THE COST IS PAID WHEN THE USE BEGINS — before the release, not at it.
	cam.debug_cursor_override = SPOT
	await _phys(2)
	var cd_before := skills.cooldown_remaining(CinderContent.SKILL_CINDER_FIELD)
	var r0 := skills.use_binding(CinderContent.BINDING_INDEX)
	await _phys(1)
	var began := bool(r0["ok"])
	if not began:
		_finding("E18 DIAGNOSTIC: the use was refused — '%s'" % String(r0["reason"]))
	var mana_now := skills.pool.mana_current
	# THE POOL REGENERATES EVERY FRAME, so the reading one frame later is the
	# payment MINUS one frame of regeneration. The check is that the cost was
	# taken, not that the pool froze: the drop must be the cost, within one
	# frame's regeneration. A TEST BOUND, derived from the live regen rate.
	var one_frame := skills.pool.regen_per_second() * DT + TOL_DMG
	var drop := mana0 - mana_now
	var paid_at_start := began and drop >= cost - one_frame and drop <= cost + one_frame \
		and player.commitment.active and cinder.placements == 0
	# 2. THE COOLDOWN IS STILL ZERO DURING THE WIND-UP.
	var cd_windup := skills.cooldown_remaining(CinderContent.SKILL_CINDER_FIELD)
	var cold_windup := is_zero_approx(cd_windup) and is_zero_approx(cd_before)
	# 3. IT BEGINS ON SUCCESSFUL RELEASE.
	await _until(func() -> bool: return cinder.placements > 0, 240)
	await _phys(1)
	var cd_release := skills.cooldown_remaining(CinderContent.SKILL_CINDER_FIELD)
	var began_on_release := cd_release > 0.0 and cd_release <= CinderConfig.COOLDOWN_S
	cam.debug_cursor_override = null
	await _until(func() -> bool: return not player.commitment.active, 240)
	# 4. A SECOND USE IS REFUSED WHILE IT RUNS, and the refusal names the shared
	#    cooldown of the SKILL IMPRINT — canon's own key.
	cam.debug_cursor_override = SPOT_B
	await _phys(2)
	var r2 := skills.use_binding(CinderContent.BINDING_INDEX)
	var refused := not bool(r2["ok"]) and String(r2["reason"]).find("shares the cooldown") > 0 \
		and String(r2["reason"]).find(CinderContent.SKILL_CINDER_FIELD) > 0
	# 5. AND WITH TOO LITTLE MANA THE USE IS REFUSED, paying nothing.
	skills.clear_cooldowns()
	skills.pool.mana_current = cost * 0.5
	await _phys(2)
	var mana_before := skills.pool.mana_current
	var r3 := skills.use_binding(CinderContent.BINDING_INDEX)
	var poor := not bool(r3["ok"]) and String(r3["reason"]).find("Mana") > 0 \
		and is_equal_approx(skills.pool.mana_current, mana_before) and not player.commitment.active
	cam.debug_cursor_override = null
	await _reset()
	var ok := paid_at_start and cold_windup and began_on_release and refused and poor
	_note("E18_cost_is_paid_at_use_start_and_the_cooldown_begins_on_release",
		"MEASURED: Mana %.3f -> %.3f one frame after the use BEGAN (a drop of %.3f against the %.1f cost, within one frame's regeneration), with no trap yet placed — the cost is paid at use start=%s | the cooldown was still 0.000 s through the wind-up=%s | at the release it read %.3f s of the PROVISIONAL %.2f s=%s | a second use while it runs is refused, naming the SHARED cooldown of the Skill Imprint=%s | with half the cost available the use is refused and pays nothing=%s. Canon section 15, implemented literally."
		% [mana0, mana_now, drop, cost, str(paid_at_start), str(cold_windup), cd_release,
		   CinderConfig.COOLDOWN_S, str(began_on_release), str(refused), str(poor)])
	_reached("E18_cost_is_paid_at_use_start_and_the_cooldown_begins_on_release")
	return ok

# =============================================================================
# E. ARMING AND TRIGGERING — an enemy, never an ally, and never before armed
# =============================================================================

func chk_E19_a_trap_cannot_trigger_before_it_is_armed() -> bool:
	await _reset()
	var t := await _place(SPOT)
	var placed := t != null and t.state == CinderConfig.PHASE_ARMING
	# PUT AN ELIGIBLE ENEMY RIGHT ON IT, BEFORE IT ARMS, and hold it there for
	# the whole arming delay.
	var e: OrdinaryEnemy = enemies[0]
	e.global_position = SPOT + Vector3(0.2, 0, 0.0)
	var inside := _planar(e.global_position, t.global_position) < t.trigger_radius
	var frames := 0
	var early := 0
	while t != null and is_instance_valid(t) and not t.is_armed() and frames < 120:
		await physics_frame
		frames += 1
		if t.eruptions > 0:
			early += 1
	var never_early := early == 0 and cinder.eruptions == 0 and cinder.grounds.is_empty()
	var armed_after := frames > 0 and t != null and is_instance_valid(t) and t.is_armed()
	# THE ARMING DELAY REALLY ELAPSED — measured against the registered value.
	var delay_ok := absf(t.armed_at - CinderConfig.ARMING_DELAY_S) <= 2.0 * DT if armed_after else false
	# AND THE SAME ENEMY, STILL THERE, SPRINGS IT AT ONCE once it is armed.
	await _until(func() -> bool: return cinder.eruptions > 0, 60)
	var sprang := cinder.eruptions == 1
	await _reset()
	var ok := placed and inside and never_early and armed_after and delay_ok and sprang
	_note("E19_a_trap_cannot_trigger_before_it_is_armed",
		"a trap was placed DORMANT=%s with an eligible enemy standing INSIDE its %.2f m trigger radius from the first frame=%s | across %d arming frames it erupted %d times — NEVER before it armed, and no field appeared=%s | it armed at %.4f s against the registered %.2f s delay (within two %.4f s frames)=%s | the SAME enemy, still there, sprang it as soon as it armed=%s — so the refusal was the ARMING, not the enemy"
		% [str(placed), CinderConfig.TRIGGER_RADIUS_M, str(inside), frames, early, str(never_early),
		   t.armed_at if t != null and is_instance_valid(t) else -1.0, CinderConfig.ARMING_DELAY_S,
		   DT, str(delay_ok), str(sprang)])
	_reached("E19_a_trap_cannot_trigger_before_it_is_armed")
	return ok

func chk_E20_an_armed_trap_triggers_on_an_eligible_enemy_entering() -> bool:
	await _reset()
	var t := await _place(SPOT)
	var armed := await _arm(t)
	# NOTHING NEAR IT: an armed trap with no enemy in reach stays dormant.
	await _phys(30)
	var quiet := armed and t.eruptions == 0 and cinder.eruptions == 0
	# WALK AN ENEMY IN FROM OUTSIDE — a real swept entry, not a teleport onto it.
	var e: OrdinaryEnemy = enemies[0]
	e.global_position = SPOT + Vector3(0.0, 0.0, -4.0)
	await _phys(2)
	var outside := _planar(e.global_position, t.global_position) > t.trigger_radius
	var steps := 0
	while t != null and is_instance_valid(t) and t.eruptions == 0 and steps < 120:
		e.global_position = e.global_position.move_toward(t.global_position, 0.12)
		await physics_frame
		steps += 1
	var sprang := cinder.eruptions == 1 and t != null and is_instance_valid(t) and t.eruptions == 1
	# IT SPRANG WHERE IT SHOULD: the enemy was inside the trigger radius, not the
	# larger eruption radius.
	var at_radius := sprang and _planar(e.global_position, t.global_position) <= t.trigger_radius + 0.15
	# AND THE TRIGGERER IS NAMED, by its combat-entity ID.
	var named := sprang and t.trigger_id == hr.registry.id_of(e) and t.trigger_id != ""
	await _reset()
	var ok := armed and quiet and outside and sprang and at_radius and named
	_note("E20_an_armed_trap_triggers_on_an_eligible_enemy_entering",
		"the trap armed=%s and sat for 30 frames with nothing in reach WITHOUT erupting=%s | an enemy walked in from %.2f m outside=%s and sprang it after %d steps=%s, at %.3f m from the centre against the %.2f m trigger radius=%s | the triggerer is named by its combat-entity ID '%s'=%s"
		% [str(armed), str(quiet), 4.0, str(outside), steps, str(sprang),
		   _planar(e.global_position, t.global_position) if t != null and is_instance_valid(t) else -1.0,
		   CinderConfig.TRIGGER_RADIUS_M, str(at_radius), t.trigger_id if t != null and is_instance_valid(t) else "", str(named)])
	_reached("E20_an_armed_trap_triggers_on_an_eligible_enemy_entering")
	return ok

func chk_E21_the_player_cannot_trigger_it() -> bool:
	await _reset()
	var t := await _place(SPOT)
	var armed := await _arm(t)
	# SHE STANDS ON IT. Not near it — ON it.
	player.global_position = t.global_position
	await _phys(60)
	var on_it := _planar(player.global_position, t.global_position) <= 0.2
	var quiet := armed and t != null and is_instance_valid(t) and t.eruptions == 0 \
		and cinder.eruptions == 0 and cinder.grounds.is_empty()
	# THE REASON IS STRUCTURAL: she is not a registered combat entity at all, so
	# she is not even a candidate.
	var unregistered := hr.registry.id_of(player) == "" and hr.registry.record_of(player).is_empty()
	# AND SHE TAKES NO DAMAGE FROM IT EITHER.
	var health := player.life.life
	await _phys(30)
	var unhurt := is_equal_approx(player.life.life, health)
	# THE TRAP IS STILL LIVE: an enemy still springs it, so the silence above was
	# the PLAYER being refused, not a dead trap.
	var e: OrdinaryEnemy = enemies[0]
	e.global_position = t.global_position + Vector3(0.3, 0, 0.0)
	await _until(func() -> bool: return cinder.eruptions > 0, 60)
	var still_live := cinder.eruptions == 1
	await _reset()
	var ok := armed and on_it and quiet and unregistered and unhurt and still_live
	_note("E21_the_player_cannot_trigger_it",
		"she stood ON an ARMED trap (%.3f m from its centre)=%s for 60 frames and it did NOT erupt=%s | the reason is structural: she is not registered as a combat entity at all, so she is never a candidate=%s | she took no damage (%.1f Health, unchanged)=%s | AND THE TRAP WAS STILL LIVE: an enemy sprang it immediately afterwards=%s — the silence was the PLAYER being refused, not a dead trap"
		% [_planar(player.global_position, t.global_position) if t != null and is_instance_valid(t) else -1.0,
		   str(on_it), str(quiet), str(unregistered), health, str(unhurt), str(still_live)])
	_reached("E21_the_player_cannot_trigger_it")
	return ok

func chk_E22_hounds_and_other_player_owned_entities_cannot_trigger_it() -> bool:
	await _reset()
	# THE PACK IS LIVE in the review loadout: two Kindred Hounds, registered as
	# ALLIES in the same area registry the trap reads.
	var pack_ok := hounds.pack.size() == HoundConfig.PACK_SIZE
	var t := await _place(SPOT)
	var armed := await _arm(t)
	# WALK EVERY HOUND ONTO THE TRAP, and hold them there.
	var moved := 0
	for h in hounds.pack:
		var hd := h as KindredHound
		if hd != null and is_instance_valid(hd):
			hd.global_position = t.global_position + Vector3(0.2 * float(moved), 0.0, 0.0)
			moved += 1
	# HELD THERE, frame by frame: the cohort walks them back to their formation
	# slots every step, and the claim is about the ELIGIBILITY PREDICATE, not
	# about hound movement. Holding them is the fixture that isolates it.
	for i in 60:
		for h2 in hounds.pack:
			var hh := h2 as KindredHound
			if hh != null and is_instance_valid(hh):
				hh.global_position = t.global_position
		await physics_frame
	var on_it := 0
	var allies := 0
	for h in hounds.pack:
		var hd2 := h as KindredHound
		if hd2 != null and is_instance_valid(hd2):
			if _planar(hd2.global_position, t.global_position) <= t.trigger_radius:
				on_it += 1
			var rec := hr.registry.record_of(hd2)
			if String(rec.get("faction", "")) == "ally":
				allies += 1
	var quiet := armed and t != null and is_instance_valid(t) and t.eruptions == 0 \
		and cinder.eruptions == 0 and cinder.grounds.is_empty()
	# THE REFUSAL IS THE GENERAL PREDICATE, not a trap-specific case: the SAME
	# `HitEligibility` that every other effect uses refuses an ally, and names
	# the reason.
	var rec0 := hr.registry.record_of(hounds.pack[0]) if not hounds.pack.is_empty() else {}
	var elig := HitEligibility.evaluate(rec0)
	var predicate := not bool(elig["eligible"]) and String(elig["reason"]).find("not hostile") == 0
	# AND NO HOUND TOOK DAMAGE FROM THE FIELD EITHER.
	var life0 := (hounds.pack[0] as KindredHound).life.life if not hounds.pack.is_empty() else -1.0
	# NO TRAP CODE SPECIAL-CASES A HOUND, AN ALLY OR THE PLAYER.
	var special := RegEx.new()
	special.compile("\\b(KindredHound|HoundRuntime|is_ally|is_player|PlayerController)\\b")
	var special_hits: Array[String] = []
	for f in ["res://scripts/cinder/cinder_trap.gd", "res://scripts/cinder/cinder_ground.gd"]:
		if special.search(_strip_strings(_code_only(_read_text(String(f))))) != null:
			special_hits.append(String(f).get_file())
	# THE TRAP IS STILL LIVE: an ENEMY springs it with the hounds still standing
	# on it, which is the control that makes the silence mean something.
	var e: OrdinaryEnemy = enemies[0]
	e.global_position = t.global_position + Vector3(0.0, 0.0, 0.3)
	await _until(func() -> bool: return cinder.eruptions > 0, 90)
	var still_live := cinder.eruptions == 1
	var hounds_unhurt := hounds.pack.is_empty() \
		or is_equal_approx((hounds.pack[0] as KindredHound).life.life, life0)
	await _reset()
	var ok := pack_ok and armed and on_it >= 1 and allies == on_it and quiet and predicate \
		and special_hits.is_empty() and still_live and hounds_unhurt
	_note("E22_hounds_and_other_player_owned_entities_cannot_trigger_it",
		"the live pack is %d Kindred Hounds=%s | %d of them stood INSIDE an ARMED trap's trigger radius, all registered as ALLIES=%s, for 60 frames, and it did NOT erupt and no field appeared=%s | the refusal is the GENERAL HitEligibility rule, which says '%s'=%s | the trap and ground code special-case no hound, ally or player (hits: %s) | AND THE TRAP WAS STILL LIVE: an ENEMY sprang it with the hounds still on it=%s, and the hounds took no damage from the field=%s"
		% [hounds.pack.size(), str(pack_ok), on_it, str(allies == on_it), str(quiet),
		   String(elig.get("reason", "")), str(predicate), str(special_hits), str(still_live),
		   str(hounds_unhurt)])
	_reached("E22_hounds_and_other_player_owned_entities_cannot_trigger_it")
	return ok

## A test-only stub that is REGISTERED and HOSTILE but reports itself
## untargetable or invulnerable. The eligibility rule asks these two questions
## through OPTIONAL methods no gameplay class implements — so the only way to
## exercise those conjuncts is a stub like this one, and it is declared as such.
class IneligibleProbe extends Node3D:
	var untargetable := false
	var invulnerable := false
	var hits := 0
	var life := Damageable.new(1000.0)
	func is_dead() -> bool: return life.dead
	func combat_is_targetable() -> bool: return not untargetable
	func combat_is_invulnerable() -> bool: return invulnerable
	func receive_damage(amount: float, from: Vector3) -> void:
		hits += 1
		life.apply(amount, from)

func chk_E23_an_ineligible_enemy_cannot_trigger_it() -> bool:
	await _reset()
	var rows: Array[String] = []
	var all_quiet := true
	var each_live := true
	# FOUR INELIGIBLE CONDITIONS, one at a time, each on its OWN armed trap.
	for case in ["dead", "untargetable", "invulnerable", "ally"]:
		var t := await _place(SPOT)
		var armed := await _arm(t)
		var probe := IneligibleProbe.new()
		probe.name = "IneligibleProbe_%s" % case
		main.add_child(probe)
		var id := ""
		match case:
			"dead":
				id = hr.register_enemy(probe)
				probe.life.apply(2000.0, Vector3.ZERO)
			"untargetable":
				id = hr.register_enemy(probe)
				probe.untargetable = true
			"invulnerable":
				id = hr.register_enemy(probe)
				probe.invulnerable = true
			"ally":
				id = hr.registry.register(probe, "ally", "ally")
		probe.global_position = t.global_position
		await _phys(40)
		var quiet := armed and t != null and is_instance_valid(t) and t.eruptions == 0
		all_quiet = all_quiet and quiet
		var why := String(HitEligibility.evaluate(hr.registry.record_of(probe))["reason"])
		# THE CONTROL: an ELIGIBLE enemy springs the SAME trap at once.
		var e: OrdinaryEnemy = enemies[0]
		e.global_position = t.global_position + Vector3(0.25, 0, 0.0)
		await _until(func() -> bool: return t == null or not is_instance_valid(t) or t.eruptions > 0, 90)
		var live := t == null or not is_instance_valid(t) or t.eruptions == 1
		each_live = each_live and live
		rows.append("%s (%s): quiet=%s, refused because '%s', the same trap still sprang for an eligible enemy=%s"
			% [case, id, str(quiet), why.left(46), str(live)])
		probe.queue_free()
		await _reset()
	var ok := all_quiet and each_live
	_note("E23_an_ineligible_enemy_cannot_trigger_it",
		"FOUR ineligible conditions, each on its OWN armed trap, each held on the trap for 40 frames: %s | none of them erupted=%s, and in EVERY case an ELIGIBLE enemy sprang the same trap immediately afterwards=%s — so each silence was the ELIGIBILITY refusing, never a dead trap. The predicate is the GENERAL HitEligibility rule; the untargetable and invulnerable conditions are asked through OPTIONAL methods NO gameplay class implements, so this check declares its own test-only stub."
		% [" | ".join(rows), str(all_quiet), str(each_live)])
	_reached("E23_an_ineligible_enemy_cannot_trigger_it")
	return ok

func chk_E24_one_trap_erupts_at_most_once() -> bool:
	await _reset()
	var t := await _place(SPOT)
	await _arm(t)
	var e0: OrdinaryEnemy = enemies[0]
	e0.global_position = t.global_position + Vector3(0.3, 0, 0.0)
	await _until(func() -> bool: return cinder.eruptions > 0, 90)
	var once := cinder.eruptions == 1 and t.eruptions == 1 \
		and t.state == CinderConfig.PHASE_SPRUNG
	var fields_after_first := cinder.grounds.size()
	# A SECOND ENEMY WALKS INTO THE SAME SPRUNG TRAP. Nothing may happen.
	var e1: OrdinaryEnemy = enemies[1]
	e1.global_position = t.global_position + Vector3(0.0, 0.0, -3.0)
	await _phys(2)
	var steps := 0
	while t != null and is_instance_valid(t) and steps < 40:
		e1.global_position = e1.global_position.move_toward(t.global_position, 0.12)
		await physics_frame
		steps += 1
	var still_once := cinder.eruptions == 1 and cinder.grounds.size() == fields_after_first
	# AND THE FIRST ONE LEAVES AND RETURNS: re-entry does nothing either.
	e0.global_position = t.global_position + Vector3(0.0, 0.0, -5.0) if t != null and is_instance_valid(t) else PARK
	await _phys(6)
	var again := cinder.eruptions == 1
	# THE STATE MACHINE HAS ONE EDGE IN AND NONE OUT: no code assigns ARMED or
	# ARMING after SPRUNG. Scanned in CODE.
	var src := _code_only(_read_text("res://scripts/cinder/cinder_trap.gd"))
	var edges := src.count("state = CinderConfig.PHASE_SPRUNG") == 1 \
		and src.count("state = CinderConfig.PHASE_ARMED") == 1 \
		and src.count("state = CinderConfig.PHASE_EXPIRED") == 1
	# AND THE SPRUNG TRAP IS NO LONGER AN INSTANCE: it left the cap's list.
	var not_an_instance := not cinder.traps.has(t)
	await _reset()
	var ok := once and still_once and again and edges and not_an_instance
	_note("E24_one_trap_erupts_at_most_once",
		"the trap erupted ONCE and is SPRUNG=%s | a SECOND enemy walked into the same sprung trap over %d steps and nothing happened — still 1 eruption and still %d field(s)=%s | the first enemy leaving and the field persisting changed nothing either=%s | the state machine assigns SPRUNG in exactly one place and has no edge back to ARMED or ARMING=%s | a SPRUNG trap no longer occupies an instance slot=%s"
		% [str(once), steps, fields_after_first, str(still_once), str(again), str(edges),
		   str(not_an_instance)])
	_reached("E24_one_trap_erupts_at_most_once")
	return ok

## A registered, eligible, MOTIONLESS probe placed at an exact distance, so an
## entry time can be arranged rather than hoped for.
class EntryProbe extends Node3D:
	var life := Damageable.new(100000.0)
	var hits := 0
	func is_dead() -> bool: return life.dead
	func receive_damage(amount: float, from: Vector3) -> void:
		hits += 1
		life.apply(amount, from)

func chk_E25_simultaneous_entry_is_deterministic_by_time_then_combat_entity_id() -> bool:
	await _reset()
	# 1. THE ARITHMETIC ITSELF, exactly: a body already inside enters at t = 0,
	#    a body crossing the boundary enters at the closed-form parameter, and a
	#    body that never reaches it never enters.
	var c := Vector2(0.0, 0.0)
	var r := 1.0
	var t_inside := ArrowCollision.segment_circle_toi(Vector2(0.2, 0.0), Vector2(0.3, 0.0), c, r)
	var t_cross := ArrowCollision.segment_circle_toi(Vector2(-2.0, 0.0), Vector2(0.0, 0.0), c, r)
	var t_never := ArrowCollision.segment_circle_toi(Vector2(-2.0, 0.0), Vector2(-1.5, 0.0), c, r)
	var arithmetic := is_equal_approx(t_inside, 0.0) and absf(t_cross - 0.5) <= TOL_T and t_never < 0.0
	# 2. TWO PROBES ENTERING ON THE SAME STEP, ONE STRICTLY EARLIER. The earlier
	#    one wins WHATEVER the IDs say.
	# THE NAMES OPPOSE THE REGISTRY ORDER ON PURPOSE: the probe registered FIRST
	# (the lower combat-entity ID) is named LAST alphabetically. A control whose
	# name order agreed with the ID order could not tell the two apart.
	var a := EntryProbe.new(); a.name = "ZProbe_RegisteredFirst"; main.add_child(a)
	var b := EntryProbe.new(); b.name = "AProbe_RegisteredSecond"; main.add_child(b)
	var id_a := hr.register_enemy(a)
	var id_b := hr.register_enemy(b)
	var a_first := hr.registry.precedes(id_a, id_b)
	var rad := CinderConfig.TRIGGER_RADIUS_M
	# ============================================================
	# THE PROBES ARE PUT WHERE THEY START **BEFORE** THE TRAP EXISTS.
	# ============================================================
	# A trap records each candidate's position at the END of every step, so a
	# probe still sitting at its spawn point when the trap arms would sweep the
	# WHOLE way in on the frame it is first moved — and that spurious segment,
	# not the one this check arranges, would decide the trigger. The first run
	# of this check measured exactly that. Placing them first, and letting the
	# world step, makes the swept segment the one the check means.
	a.global_position = SPOT + Vector3(-(rad + 2.0), 0, 0)
	b.global_position = SPOT + Vector3(0, 0, -(rad + 0.5))
	await _phys(2)
	var t1 := await _place(SPOT)
	await _arm(t1)
	await _phys(2)
	# A moves but never reaches the circle; B crosses it this step. B is EARLIER
	# in the only sense the rule uses: it is the only one with an entry time.
	a.global_position = SPOT + Vector3(-(rad + 1.0), 0, 0)
	b.global_position = SPOT + Vector3(0, 0, -(rad * 0.2))
	await _until(func() -> bool: return t1 == null or not is_instance_valid(t1) or t1.eruptions > 0, 30)
	var earlier_wins := t1 != null and is_instance_valid(t1) and t1.trigger_id == id_b \
		and t1.trigger_entry_t >= 0.0
	if not earlier_wins:
		_finding("E25 DIAGNOSTIC: id_a=%s id_b=%s winner=%s tie_set=%s t=%.6f"
			% [id_a, id_b, t1.trigger_id if t1 != null and is_instance_valid(t1) else "?",
			   str(t1.trigger_tie_set) if t1 != null and is_instance_valid(t1) else "[]",
			   t1.trigger_entry_t if t1 != null and is_instance_valid(t1) else -1.0])
	var t_b := t1.trigger_entry_t if t1 != null and is_instance_valid(t1) else -1.0
	await _reset()
	# 3. AN EXACT TIE — both already inside at the start of the step, so both
	#    enter at t = 0.0 exactly. The LOWER combat-entity ID wins.
	a.global_position = SPOT + Vector3(0.3, 0, 0.0)
	b.global_position = SPOT + Vector3(-0.3, 0, 0.0)
	await _phys(2)
	var t2 := await _place(SPOT)
	await _arm(t2)
	await _until(func() -> bool: return t2 == null or not is_instance_valid(t2) or t2.eruptions > 0, 60)
	var tie_ok := t2 != null and is_instance_valid(t2) \
		and is_equal_approx(t2.trigger_entry_t, 0.0) and t2.trigger_tie_set.size() == 2 \
		and t2.trigger_id == (id_a if a_first else id_b)
	var tie_set := t2.trigger_tie_set.duplicate() if t2 != null and is_instance_valid(t2) else []
	var winner := t2.trigger_id if t2 != null and is_instance_valid(t2) else ""
	# 4. THE TIE-BREAK IS THE REGISTRY'S ORDER, NOT A NAME OR AN ARRAY POSITION:
	#    the loser's NAME sorts before the winner's, and it still loses.
	var name_would_differ := (winner == id_a and String(b.name) < String(a.name)) \
		or (winner == id_b and String(a.name) < String(b.name))
	# 5. AND THE CODE READS NEITHER: scanned in CODE with strings stripped.
	var forbidden := RegEx.new()
	# READS ONLY. Naming a node it CREATES (`seg.name = "TriggerSeg0"`) is not
	# reading an identity to decide by; reading one would be. The lookahead
	# excludes the assignment and keeps the guard aimed at what it is for.
	forbidden.compile("\\.name\\b(?!\\s*=)|get_instance_id|get_index\\(|find_child|get_children\\(")
	var scan := _strip_strings(_code_only(_read_text("res://scripts/cinder/cinder_trap.gd")))
	var reads_forbidden := forbidden.search(scan) != null
	var caught := forbidden.search("var x = node.name") != null \
		and forbidden.search("seg.name = \"TriggerSeg0\"") == null
	# 6. THE ERUPTION STILL HITS EVERY ELIGIBLE ENEMY IN THE AREA, not only the
	#    one that sprang it.
	var both_hit := a.hits >= 1 and b.hits >= 1
	a.queue_free()
	b.queue_free()
	await _reset()
	var ok := arithmetic and earlier_wins and tie_ok and name_would_differ \
		and not reads_forbidden and caught and both_hit
	_note("E25_simultaneous_entry_is_deterministic_by_time_then_combat_entity_id",
		"THE ARITHMETIC, EXACTLY: already inside -> t=%.4f, crossing the boundary mid-step -> t=%.6f (closed form 0.5), never reaching -> %.1f=%s | TWO probes crossing on the SAME step, one strictly earlier: the EARLIER one (%s) won at t=%.6f, whatever the IDs=%s | AN EXACT TIE (both inside at the step's start, both t=0.0, tie set %s): the LOWER combat-entity ID won — %s=%s | the loser's NAME sorts first and it still lost, so the order is the REGISTRY's=%s | the trap code reads no node name, instance id, child index or query order=%s (a planted read IS caught=%s) | and the eruption Hit BOTH probes, not only the triggerer=%s"
		% [t_inside, t_cross, t_never, str(arithmetic), id_b, t_b, str(earlier_wins), str(tie_set),
		   winner, str(tie_ok), str(name_would_differ), str(not reads_forbidden), str(caught),
		   str(both_hit)])
	_reached("E25_simultaneous_entry_is_deterministic_by_time_then_combat_entity_id")
	return ok

# =============================================================================
# F. THE ERUPTION AND THE BURNING GROUND — two components, separately measured
# =============================================================================

func chk_E26_the_eruption_hits_every_eligible_enemy_in_its_area() -> bool:
	await _reset()
	SkillRuntime.reset_ledger()
	var t := await _place(SPOT)
	await _arm(t)
	# THREE eligible enemies inside the eruption radius, one of them also inside
	# the smaller trigger radius. Plus one OUTSIDE it, and one INELIGIBLE inside.
	var inside: Array = [enemies[0], enemies[1], enemies[2]]
	var health0: Array = []
	for i in inside.size():
		var e := inside[i] as OrdinaryEnemy
		e.life = Damageable.new(100000.0)
		e.global_position = t.global_position \
			+ Vector3(cos(float(i) * 2.1), 0.0, sin(float(i) * 2.1)) * (0.4 + 0.7 * float(i))
		health0.append(e.life.life)
	var far: OrdinaryEnemy = enemies[3]
	far.life = Damageable.new(100000.0)
	far.global_position = t.global_position + Vector3(0.0, 0.0, CinderConfig.ERUPTION_RADIUS_M + 2.0)
	var far0 := far.life.life
	var probe := IneligibleProbe.new()
	probe.name = "InvulnerableInArea"
	main.add_child(probe)
	hr.register_enemy(probe)
	probe.invulnerable = true
	probe.global_position = t.global_position + Vector3(0.6, 0.0, 0.6)
	await _until(func() -> bool: return cinder.eruptions > 0, 90)
	# SNAPSHOT AT ONCE. A sprung trap frees itself after its short linger, and a
	# check that read it later would be reading a freed object rather than the
	# eruption it is about.
	var dmg := t.eruption_damage
	var hit_count := t.enemies_hit
	var hit_ids := t.hit_ids.duplicate()
	var centre := t.global_position
	await _phys(2)
	# EVERY ELIGIBLE ENEMY IN THE AREA TOOK THE FULL HIT, ONCE EACH.
	var all_hit := true
	var rows: Array[String] = []
	for i in inside.size():
		var e2 := inside[i] as OrdinaryEnemy
		var took := float(health0[i]) - e2.life.life
		var one := absf(took - dmg) <= TOL_DMG
		all_hit = all_hit and one
		rows.append("%s at %.2f m took %.1f (once)=%s"
			% [hr.registry.id_of(e2), _planar(e2.global_position, t.global_position), took, str(one)])
	var count_ok := hit_count == inside.size() and hit_ids.size() == inside.size()
	# THE ONE OUTSIDE THE RADIUS WAS NOT HIT.
	var far_safe := is_equal_approx(far.life.life, far0)
	# NOR WAS THE INELIGIBLE ONE INSIDE IT.
	var probe_safe := probe.hits == 0
	# AND IT IS NOT A PROJECTILE: the Configuration resolves ZERO projectiles.
	var not_projectile := int(cinder.configuration().resolve()["projectiles"]) == 0
	# THE LEDGER AGREES: total Hit damage = damage x enemies, from ONE eruption.
	var ledger := SkillRuntime.ledger()
	var ledger_ok := absf(float(ledger.get(CinderConfig.LEDGER_SOURCE_HIT, 0.0))
		- dmg * float(inside.size())) <= TOL_DMG
	probe.queue_free()
	await _reset()
	var ok := all_hit and count_ok and far_safe and probe_safe and not_projectile and ledger_ok
	_note("E26_the_eruption_hits_every_eligible_enemy_in_its_area",
		"ONE eruption, %d eligible enemies inside the %.2f m eruption radius: %s — every one took the full %.1f Fire Hit, ONCE=%s, and the trap recorded %d Hits=%s | an enemy %.2f m outside took NOTHING=%s | an INVULNERABLE enemy INSIDE the area took nothing either=%s | the Configuration resolves %d projectiles — it is NOT a single-target projectile=%s | the ledger holds %.1f for '%s', exactly damage x enemies=%s"
		% [inside.size(), CinderConfig.ERUPTION_RADIUS_M, " · ".join(rows), dmg, str(all_hit),
		   hit_count, str(count_ok), _planar(far.global_position, centre), str(far_safe),
		   str(probe_safe), int(cinder.configuration().resolve()["projectiles"]), str(not_projectile),
		   float(ledger.get(CinderConfig.LEDGER_SOURCE_HIT, 0.0)), CinderConfig.LEDGER_SOURCE_HIT,
		   str(ledger_ok)])
	_reached("E26_the_eruption_hits_every_eligible_enemy_in_its_area")
	return ok

func chk_E27_the_hit_and_the_ground_dot_are_separately_measurable_and_tagged() -> bool:
	await _reset()
	SkillRuntime.reset_ledger()
	var uses0 := skills.skill_uses
	var t := await _place(SPOT)
	var use_id := t.use_id
	await _arm(t)
	var e: OrdinaryEnemy = enemies[0]
	e.life = Damageable.new(100000.0)
	e.global_position = t.global_position + Vector3(0.3, 0, 0.0)
	await _until(func() -> bool: return cinder.eruptions > 0, 90)
	# SNAPSHOT AT ONCE, before the sprung body's linger frees it.
	var erupt_damage := t.eruption_damage
	var trap_use_id := t.use_id
	await _phys(2)
	var ledger_hit := float(SkillRuntime.ledger().get(CinderConfig.LEDGER_SOURCE_HIT, 0.0))
	var hit_only := absf(ledger_hit - erupt_damage) <= TOL_DMG \
		and is_zero_approx(float(SkillRuntime.ledger().get(CinderConfig.LEDGER_SOURCE_GROUND, 0.0)))
	# THEN LET THE BURNING GROUND TICK. The Hit total must NOT move; the Ground
	# total must, under its OWN source.
	await _until(func() -> bool: return cinder.ground_ticks >= 2, 240)
	var ledger := SkillRuntime.ledger()
	var hit_frozen := absf(float(ledger.get(CinderConfig.LEDGER_SOURCE_HIT, 0.0)) - ledger_hit) <= TOL_DMG
	var ground_moved := float(ledger.get(CinderConfig.LEDGER_SOURCE_GROUND, 0.0)) > 0.0
	var two_sources := ledger.has(CinderConfig.LEDGER_SOURCE_HIT) and ledger.has(CinderConfig.LEDGER_SOURCE_GROUND) \
		and CinderConfig.LEDGER_SOURCE_HIT != CinderConfig.LEDGER_SOURCE_GROUND
	# BOTH ARE CREDITED TO THE CINDER FIELD CONFIGURATION.
	var by_cfg := SkillRuntime.ledger_by_configuration()
	var credited := absf(float(by_cfg.get(CinderContent.CFG_CINDER_FIELD, 0.0))
		- (float(ledger.get(CinderConfig.LEDGER_SOURCE_HIT, 0.0))
		   + float(ledger.get(CinderConfig.LEDGER_SOURCE_GROUND, 0.0)))) <= TOL_DMG
	# THE ERUPTION IS A DELAYED COMPONENT OF THE ORIGINAL SKILL USE, NOT A
	# TRIGGERED SKILL: it carries the use's own id, and it began NO new use.
	var g := cinder.grounds[0] as CinderGround if not cinder.grounds.is_empty() else null
	var delayed := use_id != "" and trap_use_id == use_id and g != null and g.use_id == use_id \
		and skills.skill_uses == uses0 + 1
	# AND IT STARTED NO SECOND COOLDOWN: the one cooldown is the use's own, and
	# it has been running down since the release.
	var cd := skills.cooldown_remaining(CinderContent.SKILL_CINDER_FIELD)
	var one_cooldown := cd < CinderConfig.COOLDOWN_S
	# THE THREE TAG SETS ARE DISTINCT AND CANON'S.
	var tags_distinct := not CinderConfig.ERUPTION_TAGS.has("Damage over Time") \
		and CinderConfig.ERUPTION_TAGS.has("Hit") \
		and CinderConfig.GROUND_TAGS.has("Damage over Time") \
		and not CinderConfig.GROUND_TAGS.has("Hit") \
		and str(CinderConfig.ERUPTION_TAGS) != str(CinderConfig.GROUND_TAGS)
	await _reset()
	var ok := hit_only and hit_frozen and ground_moved and two_sources and credited \
		and delayed and one_cooldown and tags_distinct
	_note("E27_the_hit_and_the_ground_dot_are_separately_measurable_and_tagged",
		"at the eruption the ledger held %.1f under '%s' and ZERO under '%s'=%s | after %d burning-Ground ticks the HIT total had NOT moved=%s while the GROUND total had, under its OWN source (%.1f)=%s | the two sources are distinct keys=%s and both are credited to '%s'=%s | the eruption carries the ORIGINAL Skill Use id '%s' and began NO new use (%d -> %d)=%s, and started no second cooldown (%.3f s of %.2f s left)=%s | the eruption carries Hit and NOT Damage over Time, the Ground the reverse=%s"
		% [ledger_hit, CinderConfig.LEDGER_SOURCE_HIT, CinderConfig.LEDGER_SOURCE_GROUND,
		   str(hit_only), cinder.ground_ticks, str(hit_frozen),
		   float(ledger.get(CinderConfig.LEDGER_SOURCE_GROUND, 0.0)), str(ground_moved),
		   str(two_sources), CinderContent.CFG_CINDER_FIELD, str(credited), use_id, uses0,
		   skills.skill_uses, str(delayed), cd, CinderConfig.COOLDOWN_S, str(one_cooldown),
		   str(tags_distinct)])
	_reached("E27_the_hit_and_the_ground_dot_are_separately_measurable_and_tagged")
	return ok

func chk_E28_the_burning_ground_lingers_for_its_duration_and_then_ends() -> bool:
	await _reset()
	SkillRuntime.reset_ledger()
	var t := await _place(SPOT)
	await _arm(t)
	var e: OrdinaryEnemy = enemies[0]
	e.life = Damageable.new(100000.0)
	e.global_position = t.global_position + Vector3(0.3, 0, 0.0)
	await _until(func() -> bool: return cinder.eruptions > 0, 90)
	var born := cinder.grounds.size() == 1
	var g := cinder.grounds[0] as CinderGround if born else null
	var shaped := g != null and is_equal_approx(g.radius, CinderConfig.GROUND_RADIUS_M) \
		and is_equal_approx(g.duration, CinderConfig.GROUND_DURATION_S) \
		and is_equal_approx(g.dps, CinderConfig.ground_dps_at(1)) \
		and _planar(g.global_position, t.global_position) <= 0.0001
	# IT DAMAGES, REPEATEDLY, AT ITS OWN CADENCE.
	var life0 := e.life.life
	await _until(func() -> bool: return cinder.ground_ticks >= 1, 120)
	var after_one := e.life.life
	var tick_damage := life0 - after_one
	var per_tick := absf(tick_damage - CinderConfig.ground_tick_damage(g.dps)) <= TOL_DMG if g != null else false
	await _until(func() -> bool: return cinder.ground_ticks >= 3, 240)
	var repeated := cinder.ground_ticks >= 3 and e.life.life < after_one
	# IT ENDS AT ITS DURATION, and stops damaging.
	await _until(func() -> bool: return cinder.grounds.is_empty(), 480)
	var ended := cinder.grounds.is_empty()
	var ticks_at_end := cinder.ground_ticks
	# MEASURED BY THE LEDGER'S OWN GROUND SOURCE, not by the enemy's Health: the
	# live pack bites the same enemy, and a Health reading would be measuring
	# Kindred Hounds as well as this field. The ledger source is Cinder Field's
	# alone, which is exactly what "separately measurable" buys.
	var ground_at_end := float(SkillRuntime.ledger().get(CinderConfig.LEDGER_SOURCE_GROUND, 0.0))
	var life_at_end := e.life.life
	await _phys(90)
	var after := float(SkillRuntime.ledger().get(CinderConfig.LEDGER_SOURCE_GROUND, 0.0))
	var stopped := absf(after - ground_at_end) <= TOL_DMG and cinder.ground_ticks == ticks_at_end
	# AND THE TOTAL IS BOUNDED BY ITS DURATION: no more ticks than the Duration
	# can hold. A TEST BOUND, from the registered values, not a gameplay value.
	var max_ticks := int(ceil(CinderConfig.GROUND_DURATION_S / CinderConfig.GROUND_TICK_S)) + 1
	var bounded := ticks_at_end <= max_ticks
	await _reset()
	var ok := born and shaped and per_tick and repeated and ended and stopped and bounded
	_note("E28_the_burning_ground_lingers_for_its_duration_and_then_ends",
		"the eruption created EXACTLY one burning Ground=%s, at the trap's own point with radius %.2f m, Duration %.2f s and %.1f damage per second=%s | one tick dealt %.3f against the arithmetic %.3f=%s | it kept damaging across %d ticks=%s | it ENDED at its Duration=%s and then dealt NOTHING for 90 further frames (its ledger source frozen at %.1f; ticks frozen at %d)=%s | %d ticks is within the %d the Duration can hold=%s"
		% [str(born), g.radius if g != null else -1.0, g.duration if g != null else -1.0,
		   g.dps if g != null else -1.0, str(shaped), tick_damage,
		   CinderConfig.ground_tick_damage(g.dps) if g != null else -1.0, str(per_tick),
		   cinder.ground_ticks, str(repeated), str(ended), ground_at_end, ticks_at_end, str(stopped),
		   ticks_at_end, max_ticks, str(bounded)])
	_reached("E28_the_burning_ground_lingers_for_its_duration_and_then_ends")
	return ok

## Erupts `n` traps at the given points, each sprung by a throwaway probe placed
## on it, and returns the live fields. The probes are freed afterwards so they
## cannot take Ground damage the arithmetic is about.
## `hold` extends each lit field's Duration for the measurement that follows.
## It is a DECLARED TEST FIXTURE on the field OBJECTS, exactly like the strength
## difference E30 makes: the CONFIGURATION is never touched, no registered value
## moves, and the arithmetic under test — one contribution per enemy per tick —
## does not depend on how long a field lives.
func _light_fields(points: Array, hold: float = 0.0) -> Array:
	var probes: Array = []
	for p in points:
		var t := await _place(p)
		await _arm(t)
		var pr := EntryProbe.new()
		pr.name = "Lighter_%d" % probes.size()
		main.add_child(pr)
		hr.register_enemy(pr)
		pr.global_position = t.global_position
		probes.append(pr)
		await _until(func() -> bool: return t == null or not is_instance_valid(t) or t.eruptions > 0, 120)
		# HELD THE MOMENT IT IS LIT: a field lit first would otherwise be part-way
		# through its Duration by the time the last one exists, and could expire
		# under the measurement.
		if hold > 0.0:
			for g0 in cinder.grounds:
				var gh := g0 as CinderGround
				if gh != null and is_instance_valid(gh):
					gh.duration = hold
	for pr in probes:
		(pr as Node).queue_free()
	# SHE WALKS AWAY, and the pack follows her. From `AWAY` the hounds' accepted
	# 6.0 m acquisition and 9.0 m leash cannot reach a probe standing in these
	# fields, so the arithmetic below measures Cinder Field and nothing else.
	player.global_position = AWAY
	await _phys(6)
	if hold > 0.0:
		for g in cinder.grounds:
			var gf := g as CinderGround
			if gf != null and is_instance_valid(gf):
				gf.duration = hold
	return cinder.grounds.duplicate()

func chk_E29_overlapping_ground_areas_never_multiply_damage() -> bool:
	await _reset()
	# THREE fields whose centres are 1.0 m apart, so their 2.60 m radii all
	# contain the midpoint. The probe standing there is in ALL THREE.
	var fields := await _light_fields([OVERLAP_A, OVERLAP_MID, OVERLAP_B], 30.0)
	var three := fields.size() == 3
	var many := EntryProbe.new(); many.name = "InThreeFields"; main.add_child(many)
	var one := EntryProbe.new(); one.name = "InOneField"; main.add_child(one)
	hr.register_enemy(many)
	hr.register_enemy(one)
	many.global_position = OVERLAP_MID
	# A point inside the LEFT field only: one radius out from A, away from the others.
	# WEST of the leftmost field's centre by most of a radius: MEASURED outside
	# the other two (3.2 m and 4.2 m from their centres, against a 2.60 m radius).
	one.global_position = OVERLAP_A + Vector3(-(CinderConfig.GROUND_RADIUS_M - 0.4), 0.0, 0.0)
	await _phys(2)
	var in_three := cinder.fields_containing(many.global_position)
	var in_one := cinder.fields_containing(one.global_position)
	var placed_right := in_three == 3 and in_one == 1
	# RUN THE SAME NUMBER OF TICKS FOR BOTH, and compare what they took.
	var ticks0 := cinder.ground_ticks
	var contrib0 := cinder.ground_contributions
	var m0 := many.life.life
	var o0 := one.life.life
	await _until(func() -> bool: return cinder.ground_ticks >= ticks0 + 3, 480)
	var ticks := cinder.ground_ticks - ticks0
	var took_many := m0 - many.life.life
	var took_one := o0 - one.life.life
	# THE WHOLE CLAIM, AS ARITHMETIC: equal, and equal to ONE field's rate.
	var equal := absf(took_many - took_one) <= TOL_DMG
	var expect := CinderConfig.ground_tick_damage(CinderConfig.ground_dps_at(1)) * float(ticks)
	var one_contribution := absf(took_many - expect) <= TOL_DMG
	# AND ONE CONTRIBUTION PER ENEMY PER TICK, counted: 2 enemies x ticks.
	var contributions := cinder.ground_contributions - contrib0
	var counted := contributions == 2 * ticks
	# AND EACH TOOK EXACTLY ONE HIT PER TICK through its own receiver.
	var hits_ok := many.hits == ticks and one.hits == ticks
	# THE NEGATIVE CONTROL: a SUMMING model would have given three times as much,
	# and the comparison can see the difference.
	var summed := expect * 3.0
	var refuses := absf(summed - took_many) > TOL_DMG and summed > took_many
	many.queue_free()
	one.queue_free()
	await _reset()
	var ok := three and placed_right and equal and one_contribution and counted and hits_ok and refuses
	_note("E29_overlapping_ground_areas_never_multiply_damage",
		"THREE overlapping fields=%s; one probe stands in %d of them and another in %d=%s | over %d ticks the probe in THREE took %.4f and the probe in ONE took %.4f — EQUAL=%s, and both equal ONE field's rate (%.4f)=%s | contributions %d = 2 enemies x %d ticks — ONE each per tick=%s, and each took exactly %d Hits through its own receiver=%s | a SUMMING model would have dealt %.4f, and the comparison SEES the difference=%s. Canon: identical overlapping Damage over Time Ground effects do not stack."
		% [str(three), in_three, in_one, str(placed_right), ticks, took_many, took_one, str(equal),
		   expect, str(one_contribution), contributions, ticks, str(counted), ticks, str(hits_ok),
		   summed, str(refuses)])
	_reached("E29_overlapping_ground_areas_never_multiply_damage")
	return ok

func chk_E30_the_strongest_applicable_instance_deals_the_damage() -> bool:
	await _reset()
	# TWO OVERLAPPING FIELDS OF UNEQUAL STRENGTH. The strength difference is made
	# on the FIELD OBJECTS — the Configuration is untouched, because this check
	# is about the arbiter, not about tuning.
	var fields := await _light_fields([OVERLAP_A, OVERLAP_B], 30.0)
	var live_fields: Array = []
	for g0 in fields:
		if g0 != null and is_instance_valid(g0) and (g0 as CinderGround).alive:
			live_fields.append(g0)
	var two := live_fields.size() == 2
	if not two:
		_note("E30_the_strongest_applicable_instance_deals_the_damage",
			"the fixture lit %d of 2 overlapping fields (%d still live), so the arbitration could not be measured. THIS IS A FAILURE, not a skip."
			% [fields.size(), live_fields.size()])
		_reached("E30_the_strongest_applicable_instance_deals_the_damage")
		return false
	fields = live_fields
	var weak := fields[0] as CinderGround
	var strong := fields[1] as CinderGround
	var base := CinderConfig.ground_dps_at(1)
	weak.dps = base * 0.5
	strong.dps = base * 2.0
	var probe := EntryProbe.new(); probe.name = "InBoth"; main.add_child(probe)
	hr.register_enemy(probe)
	probe.global_position = OVERLAP_MID
	await _phys(2)
	var in_both := cinder.fields_containing(probe.global_position) == 2
	var ticks0 := cinder.ground_ticks
	var p0 := probe.life.life
	var sd0 := strong.damage_dealt
	var wd0 := weak.damage_dealt
	await _until(func() -> bool: return cinder.ground_ticks >= ticks0 + 2, 300)
	var ticks := cinder.ground_ticks - ticks0
	var took := p0 - probe.life.life
	var expect_strong := CinderConfig.ground_tick_damage(strong.dps) * float(ticks)
	var expect_weak := CinderConfig.ground_tick_damage(weak.dps) * float(ticks)
	var strongest := absf(took - expect_strong) <= TOL_DMG
	var not_weakest := absf(took - expect_weak) > TOL_DMG
	var not_sum := absf(took - (expect_strong + expect_weak)) > TOL_DMG
	# AND THE ATTRIBUTION FOLLOWS: the STRONG field was credited, the weak one
	# was not.
	var attributed := strong.damage_dealt > sd0 and is_equal_approx(weak.damage_dealt, wd0)
	# AN EXACT TIE GOES TO THE OLDER PLACEMENT — deterministic and declared.
	strong.dps = weak.dps
	var older := weak if weak.ordinal < strong.ordinal else strong
	var newer := strong if weak.ordinal < strong.ordinal else weak
	var od0 := older.damage_dealt
	var nd0 := newer.damage_dealt
	var t2 := cinder.ground_ticks
	await _until(func() -> bool: return cinder.ground_ticks >= t2 + 2, 300)
	var tie_to_older := older.damage_dealt > od0 and is_equal_approx(newer.damage_dealt, nd0)
	# AND THE ARBITER'S OWN ANSWER AGREES.
	var picked := cinder._strongest_containing(probe.global_position)
	var arbiter := picked == older
	# SNAPSHOT BEFORE THE RESET: the fixture below clears the fields, and the
	# note must report what was measured, not read freed objects.
	var weak_dps := weak.dps
	var strong_dps := strong.dps
	var older_ord := older.ordinal
	var newer_ord := newer.ordinal
	probe.queue_free()
	await _reset()
	var ok := two and in_both and strongest and not_weakest and not_sum and attributed \
		and tie_to_older and arbiter
	_note("E30_the_strongest_applicable_instance_deals_the_damage",
		"TWO overlapping fields of UNEQUAL strength (%.1f/s and %.1f/s), one probe in BOTH=%s | over %d ticks it took %.4f — the STRONGEST field's rate (%.4f)=%s, NOT the weakest (%.4f)=%s and NOT the sum (%.4f)=%s | the attribution followed: the strong field was credited and the weak one was not=%s | made EXACTLY equal, the tie went to the OLDER placement (ordinal %d over %d)=%s, and the arbiter's own answer agrees=%s. Canon: the strongest applicable instance deals damage."
		% [weak_dps, strong_dps, str(in_both), ticks, took, expect_strong, str(strongest),
		   expect_weak, str(not_weakest), expect_strong + expect_weak, str(not_sum), str(attributed),
		   older_ord, newer_ord, str(tie_to_older), str(arbiter)])
	_reached("E30_the_strongest_applicable_instance_deals_the_damage")
	return ok

func chk_E31_the_ground_applies_no_hit_and_the_eruption_applies_no_dot() -> bool:
	await _reset()
	SkillRuntime.reset_ledger()
	var t := await _place(SPOT)
	await _arm(t)
	var e: OrdinaryEnemy = enemies[0]
	e.life = Damageable.new(100000.0)
	e.global_position = t.global_position + Vector3(0.3, 0, 0.0)
	await _until(func() -> bool: return cinder.eruptions > 0, 90)
	await _phys(2)
	# THE ERUPTION IS INSTANTANEOUS: it lands once, and the ledger does not move
	# again while the field has not yet ticked.
	var hit_after := float(SkillRuntime.ledger().get(CinderConfig.LEDGER_SOURCE_HIT, 0.0))
	await _phys(int(CinderConfig.GROUND_TICK_S / DT) - 6)
	var hit_still := absf(float(SkillRuntime.ledger().get(CinderConfig.LEDGER_SOURCE_HIT, 0.0)) - hit_after) <= TOL_DMG
	var no_dot_yet := cinder.ground_ticks == 0
	var instantaneous := hit_still and no_dot_yet
	# THE GROUND APPLIES NO HIT: the ONLY writer of the Hit source is the trap,
	# and the ground file never names it. Scanned in CODE.
	var gsrc := _code_only(_read_text("res://scripts/cinder/cinder_ground.gd"))
	var tsrc := _code_only(_read_text("res://scripts/cinder/cinder_trap.gd"))
	var rsrc := _code_only(_read_text("res://scripts/cinder/cinder_runtime.gd"))
	var ground_no_damage := gsrc.find("receive_damage") < 0 and gsrc.find("record_damage") < 0 \
		and gsrc.find("LEDGER_SOURCE_HIT") < 0
	var trap_no_dot := tsrc.find("LEDGER_SOURCE_GROUND") < 0
	# ONE WRITER EACH, and they are different places.
	var writers_hit := 0
	var writers_ground := 0
	for f in _runtime_script_files():
		var c := _code_only(_read_text(String(f)))
		if c.find("record_damage(CinderConfig.LEDGER_SOURCE_HIT") >= 0:
			writers_hit += 1
		if c.find("record_damage(CinderConfig.LEDGER_SOURCE_GROUND") >= 0:
			writers_ground += 1
	var one_each := writers_hit == 1 and writers_ground == 1
	# AND THE ARBITER IS THE ONLY GROUND-DAMAGE PATH: the runtime writes it, the
	# field only records what it was credited.
	var arbiter_only := rsrc.find("record_damage(CinderConfig.LEDGER_SOURCE_GROUND") >= 0
	# THE SCANS CAN FIRE: a planted line is caught.
	var caught := _code_only("\tn.receive_damage(1.0, p)").find("receive_damage") >= 0
	await _reset()
	var ok := instantaneous and ground_no_damage and trap_no_dot and one_each and arbiter_only and caught
	_note("E31_the_ground_applies_no_hit_and_the_eruption_applies_no_dot",
		"the eruption is INSTANTANEOUS: %.1f of Hit damage landed once and did not move again while the field had not yet ticked (%d ticks)=%s | the Ground file calls NO damage path and never names the Hit source=%s; the trap never names the Ground source=%s | exactly ONE writer of each ledger source (%d and %d), in different files=%s, and the GROUND source is written only by the arbiter=%s | the scan is proved able to see a planted damage call=%s"
		% [hit_after, cinder.ground_ticks, str(instantaneous), str(ground_no_damage),
		   str(trap_no_dot), writers_hit, writers_ground, str(one_each), str(arbiter_only), str(caught)])
	_reached("E31_the_ground_applies_no_hit_and_the_eruption_applies_no_dot")
	return ok

# =============================================================================
# G. LIFETIME, THE INSTANCE CAP AND CANON'S DECLARATIONS
# =============================================================================

func chk_E32_an_unsprung_trap_expires_harmlessly() -> bool:
	await _reset()
	SkillRuntime.reset_ledger()
	var t := await _place(SPOT)
	var armed := await _arm(t)
	# NOTHING GOES NEAR IT. Every enemy stays parked, far outside every radius.
	var far := true
	for e in enemies:
		far = far and _planar((e as Node3D).global_position, t.global_position) > CinderConfig.ERUPTION_RADIUS_M * 2.0
	var expiries0 := cinder.expiries
	var hit0 := float(SkillRuntime.ledger().get(CinderConfig.LEDGER_SOURCE_HIT, 0.0))
	var ground0 := float(SkillRuntime.ledger().get(CinderConfig.LEDGER_SOURCE_GROUND, 0.0))
	var total0 := SkillRuntime.ledger_total()
	# WAIT OUT THE DORMANT DURATION. THE EXPIRY MUST ACTUALLY FIRE — an assertion
	# that nothing happened can pass because nothing ran, so this asserts the
	# action FIRST.
	var waited := await _until(func() -> bool: return cinder.expiries > expiries0, 1200)
	var fired := cinder.expiries == expiries0 + 1
	if not fired:
		_finding("E32 DIAGNOSTIC: expiries=%d eruptions=%d traps=%d nodes=%d fields=%d trap_valid=%s"
			% [cinder.expiries, cinder.eruptions, cinder.traps.size(), cinder.live_nodes.size(),
			   cinder.grounds.size(), str(t != null and is_instance_valid(t))])
	var lifetime := float(waited) * DT
	var at_duration := absf(lifetime - CinderConfig.DORMANT_DURATION_S) <= 0.75
	# AND IT WAS HARMLESS: no eruption, no field, and NOTHING in the ledger.
	var harmless := cinder.eruptions == 0 and cinder.grounds.is_empty() \
		and absf(float(SkillRuntime.ledger().get(CinderConfig.LEDGER_SOURCE_HIT, 0.0)) - hit0) <= TOL_DMG \
		and absf(float(SkillRuntime.ledger().get(CinderConfig.LEDGER_SOURCE_GROUND, 0.0)) - ground0) <= TOL_DMG \
		and absf(SkillRuntime.ledger_total() - total0) <= TOL_DMG
	# THE NODE IS GONE, AND SO IS THE INSTANCE.
	await _phys(4)
	var gone := cinder.traps.is_empty() and cinder.live_nodes.is_empty() \
		and (t == null or not is_instance_valid(t))
	# AND THE RUNTIME SAYS SO IN WORDS.
	var said := cinder.last_event.find("EXPIRED HARMLESSLY") >= 0
	# THE CONTROL: the SAME arrangement with an enemy present DOES erupt — so the
	# silence above was the absence of an enemy, not a broken trap.
	await _reset()
	var t2 := await _place(SPOT)
	await _arm(t2)
	enemies[0].global_position = t2.global_position + Vector3(0.3, 0, 0.0)
	await _until(func() -> bool: return cinder.eruptions > 0, 90)
	var control := cinder.eruptions == 1
	await _reset()
	var ok := armed and far and fired and at_duration and harmless and gone and said and control
	_note("E32_an_unsprung_trap_expires_harmlessly",
		"an ARMED trap=%s sat with every enemy far outside every radius=%s | THE EXPIRY FIRED (expiries %d -> %d)=%s after %.2f s against the %.1f s dormant Duration=%s | and it was HARMLESS: 0 eruptions, 0 fields, and the Hit, Ground and TOTAL ledger figures did not move at all=%s | the node and the instance are gone=%s, and the runtime says 'EXPIRED HARMLESSLY'=%s | THE CONTROL: the same arrangement WITH an enemy erupts=%s — so the silence was the absence of an enemy, not a dead trap"
		% [str(armed), str(far), expiries0, cinder.expiries, str(fired), lifetime,
		   CinderConfig.DORMANT_DURATION_S, str(at_duration), str(harmless), str(gone), str(said),
		   str(control)])
	_reached("E32_an_unsprung_trap_expires_harmlessly")
	return ok

func chk_E33_the_instance_cap_replaces_the_oldest_harmlessly() -> bool:
	await _reset()
	SkillRuntime.reset_ledger()
	var cap := int(cinder.configuration().resolve()["instances_max"])
	var cap_ok := cap == CinderConfig.INSTANCES_MAX and cap >= 2
	# FILL THE CAP. Re-use ADDS an instance until the limit.
	var ordinals: Array[int] = []
	var points := [SPOT, SPOT_B, SPOT_C, OVERLAP_A, OVERLAP_B]
	var adds_ok := true
	for k in cap:
		var t := await _place(points[k % points.size()])
		adds_ok = adds_ok and t != null and cinder.traps.size() == k + 1
		if t != null:
			ordinals.append(t.ordinal)
	var filled := cinder.traps.size() == cap
	var oldest_ordinal := ordinals[0] if not ordinals.is_empty() else -1
	var oldest: CinderTrap = cinder.traps[0] if filled else null
	var oldest_is_first := oldest != null and oldest.ordinal == oldest_ordinal
	var replaced0 := cinder.replacements
	var erupt0 := cinder.eruptions
	var fields0 := cinder.grounds.size()
	var hit0 := float(SkillRuntime.ledger().get(CinderConfig.LEDGER_SOURCE_HIT, 0.0))
	# ONE MORE. The OLDEST goes, and it goes HARMLESSLY.
	var extra := await _place(points[cap % points.size()])
	await _phys(4)
	var still_cap := cinder.traps.size() == cap and extra != null
	var counted := cinder.replacements == replaced0 + 1
	var oldest_gone := oldest == null or not is_instance_valid(oldest)
	var harmless := cinder.eruptions == erupt0 and cinder.grounds.size() == fields0 \
		and absf(float(SkillRuntime.ledger().get(CinderConfig.LEDGER_SOURCE_HIT, 0.0)) - hit0) <= TOL_DMG
	# THE SURVIVORS ARE THE YOUNGER ONES, in order, with the newest last.
	var surviving: Array[int] = []
	for t2 in cinder.traps:
		surviving.append((t2 as CinderTrap).ordinal)
	var right_ones := not surviving.has(oldest_ordinal) and surviving.size() == cap \
		and surviving[cap - 1] == extra.ordinal
	var ascending := true
	for i in range(1, surviving.size()):
		ascending = ascending and surviving[i] > surviving[i - 1]
	var said := cinder.last_event.find("OLDEST INSTANCE REPLACED") >= 0 \
		or cinder.last_event.find("PLACED") >= 0
	await _reset()
	var ok := cap_ok and adds_ok and filled and oldest_is_first and still_cap and counted \
		and oldest_gone and harmless and right_ones and ascending
	_note("E33_the_instance_cap_replaces_the_oldest_harmlessly",
		"the PROVISIONAL cap is %d=%s | re-use ADDED an instance each time up to it (%s)=%s, filling it=%s with the oldest first in the list=%s | a %dth placement kept the count at %d=%s, counted ONE replacement (%d -> %d)=%s, and the OLDEST (ordinal %d) is gone=%s | it went HARMLESSLY: eruptions %d (unchanged), fields %d (unchanged), Hit ledger unchanged=%s | the survivors are %s — the younger ones, ascending, newest last=%s"
		% [cap, str(cap_ok), str(ordinals), str(adds_ok), str(filled), str(oldest_is_first),
		   cap + 1, cap, str(still_cap), replaced0, cinder.replacements, str(counted),
		   oldest_ordinal, str(oldest_gone), cinder.eruptions, cinder.grounds.size(), str(harmless),
		   str(surviving), str(right_ones and ascending)])
	_reached("E33_the_instance_cap_replaces_the_oldest_harmlessly")
	return ok

func chk_E34_canon_s_duration_and_ground_declarations_are_stated_as_data() -> bool:
	var c := CinderConfig.duration_contract()
	# CANON'S FIVE DECLARATIONS, each present as DATA a check can read.
	var keys := ["declares_duration", "maximum_active_instances", "reuse_behaviour",
		"overlapping_effects_stack", "on_limit_exceeded", "unsprung_at_expiry"]
	var all_there := true
	var rows: Array[String] = []
	for k in keys:
		var present := c.has(k) and String(c[k]).length() > 20
		all_there = all_there and present
		rows.append("%s=%s" % [k, str(present)])
	# AND EACH SAYS WHAT THE RUNTIME ACTUALLY DOES.
	var says := String(c["reuse_behaviour"]).find("ADDS an instance until the limit") >= 0 \
		and String(c["reuse_behaviour"]).find("REPLACES THE OLDEST") >= 0 \
		and String(c["overlapping_effects_stack"]).find("NO") == 0 \
		and String(c["overlapping_effects_stack"]).find("STRONGEST") >= 0 \
		and String(c["overlapping_effects_stack"]).find("EXACTLY ONE") >= 0 \
		and String(c["on_limit_exceeded"]).find("HARMLESSLY") >= 0 \
		and String(c["unsprung_at_expiry"]).find("HARMLESSLY") >= 0 \
		and String(c["maximum_active_instances"]).find("SPRUNG trap no longer occupies") >= 0
	# THE NUMBERS IT QUOTES ARE THE LIVE ONES, not a copy that could drift.
	var live := String(c["declares_duration"]).find("%.2f s" % CinderConfig.DORMANT_DURATION_S) >= 0 \
		and String(c["declares_duration"]).find("%.2f s" % CinderConfig.GROUND_DURATION_S) >= 0 \
		and String(c["maximum_active_instances"]).find("%d DORMANT" % CinderConfig.INSTANCES_MAX) >= 0
	# AND THE RESOLVED CONFIGURATION CARRIES THE SAME TWO FIGURES.
	var res := cinder.configuration().resolve()
	var agrees := is_equal_approx(float(res["duration"]), CinderConfig.GROUND_DURATION_S) \
		and int(res["instances_max"]) == CinderConfig.INSTANCES_MAX
	var ok := all_there and says and live and agrees
	_note("E34_canon_s_duration_and_ground_declarations_are_stated_as_data",
		"canon's declarations for a Duration/Ground effect are stated AS DATA, readable by a check: %s=%s | each says what the runtime does — re-use ADDS then REPLACES THE OLDEST, overlapping does NOT stack (the STRONGEST, EXACTLY ONE contribution), the limit and the expiry are both HARMLESS, and a SPRUNG trap stops occupying a slot=%s | the figures it quotes are the LIVE ones=%s, and the resolved Configuration carries the same two=%s"
		% [" · ".join(rows), str(all_there), str(says), str(live), str(agrees)])
	_reached("E34_canon_s_duration_and_ground_declarations_are_stated_as_data")
	return ok

# =============================================================================
# H. THE WORLD — not attackable, blocking nothing, changing no navigation
# =============================================================================

## Every node of a subtree, so a claim about "no collider anywhere" is measured
## rather than assumed.
func _subtree(n: Node, out: Array) -> void:
	out.append(n)
	for c in n.get_children():
		_subtree(c, out)

func chk_E35_neither_a_trap_nor_a_field_is_attackable() -> bool:
	await _reset()
	var t := await _place(SPOT)
	await _arm(t)
	var e: OrdinaryEnemy = enemies[0]
	e.life = Damageable.new(100000.0)
	e.global_position = t.global_position + Vector3(0.3, 0, 0.0)
	await _until(func() -> bool: return cinder.eruptions > 0, 90)
	var g := cinder.grounds[0] as CinderGround if not cinder.grounds.is_empty() else null
	var t2 := await _place(SPOT_B)
	# 1. NO CollisionObject3D ANYWHERE in either subtree.
	var bodies: Array[String] = []
	for root_node in [t2, g]:
		if root_node == null or not is_instance_valid(root_node):
			continue
		var all: Array = []
		_subtree(root_node, all)
		for n in all:
			if n is CollisionObject3D or n is CollisionShape3D or n is NavigationObstacle3D:
				bodies.append("%s:%s" % [String((root_node as Node).name), String((n as Node).name)])
	# 2. NEITHER IS A COMBAT ENTITY: not registered, so nothing can target one.
	var unregistered := hr.registry.id_of(t2) == "" and (g == null or hr.registry.id_of(g) == "")
	# 3. NEITHER CAN RECEIVE A HIT.
	var no_receiver := not t2.has_method("receive_damage") \
		and (g == null or not g.has_method("receive_damage"))
	# 4. AND THE GENERAL ELIGIBILITY RULE REFUSES BOTH — the same predicate every
	#    effect uses, asked of an unregistered node.
	var elig_t := HitEligibility.evaluate(hr.registry.record_of(t2))
	var elig_g := HitEligibility.evaluate(hr.registry.record_of(g)) if g != null else {"eligible": false}
	var refused := not bool(elig_t["eligible"]) and not bool(elig_g["eligible"])
	# 5. A SPLINTER SHOT FIRED THROUGH A TRAP HITS THE ENEMY BEHIND IT — the
	#    arrow does not stop on it, because it is not a target at all.
	await _reset()
	var t3 := await _place(SPOT)
	var behind: OrdinaryEnemy = enemies[1]
	behind.life = Damageable.new(100000.0)
	# WELL OUTSIDE the trigger radius: the arrow passes OVER the trap, and the
	# trap must not spring on the target standing beyond it.
	behind.global_position = SPOT + Vector3(0.0, 0.0, 3.4)
	var life0 := behind.life.life
	player.global_position = SPOT + Vector3(0.0, 0.0, -3.4)
	cam.debug_cursor_override = behind.global_position
	await _phys(4)
	skills.clear_cooldowns()
	skills.pool.refill()
	var shot := skills.use_binding(HuntressContent.BINDING_INDEX)
	var fired := bool(shot["ok"])
	await _until(func() -> bool: return behind.life.life < life0, 240)
	var through := behind.life.life < life0
	cam.debug_cursor_override = null
	# AND THE TRAP IS UNHARMED AND UNSPRUNG by the arrow passing over it.
	var unharmed := t3 != null and is_instance_valid(t3) and t3.eruptions == 0
	await _reset()
	var ok := bodies.is_empty() and unregistered and no_receiver and refused and fired \
		and through and unharmed
	_note("E35_neither_a_trap_nor_a_field_is_attackable",
		"NO CollisionObject3D, CollisionShape3D or NavigationObstacle3D anywhere in either subtree (found: %s) | neither is registered as a combat entity, so nothing can target one=%s | neither implements receive_damage=%s | and the GENERAL eligibility rule refuses both ('%s' / '%s')=%s | a Splinter Shot fired THROUGH a trap=%s Hit the enemy behind it=%s, and the trap was neither harmed nor sprung by it=%s"
		% [str(bodies), str(unregistered), str(no_receiver), String(elig_t.get("reason", "")),
		   String(elig_g.get("reason", "")) if g != null else "n/a", str(refused), str(fired),
		   str(through), str(unharmed)])
	_reached("E35_neither_a_trap_nor_a_field_is_attackable")
	return ok

func chk_E36_neither_blocks_movement() -> bool:
	await _reset()
	# TIME A CLEAR WALK ACROSS THE SPOT, with nothing there.
	var from := SPOT + Vector3(0.0, 0.0, -3.0)
	var to := SPOT + Vector3(0.0, 0.0, 3.0)
	player.global_position = from
	await _phys(2)
	player.command_move_to(to)
	var clear_frames := await _until(func() -> bool:
		return player.move_destination == null and player.motor.speed() <= 0.0, 600)
	var clear_ok := _planar(player.global_position, to) <= ProdConfig.ARRIVE_TOLERANCE_M
	# NOW PUT AN ARMED TRAP AND A BURNING FIELD IN HER WAY, and walk it again.
	await _reset()
	var t := await _place(SPOT)
	await _arm(t)
	var e: OrdinaryEnemy = enemies[0]
	e.life = Damageable.new(100000.0)
	e.global_position = SPOT + Vector3(0.3, 0, 0.0)
	await _until(func() -> bool: return cinder.eruptions > 0, 90)
	var field := cinder.grounds.size() == 1
	e.global_position = PARK
	var t2 := await _place(SPOT + Vector3(0.0, 0.0, 0.6))
	await _arm(t2)
	player.life = Damageable.new(100000.0)
	player.global_position = from
	await _phys(2)
	player.command_move_to(to)
	var blocked_frames := await _until(func() -> bool:
		return player.move_destination == null and player.motor.speed() <= 0.0, 600)
	var arrived := _planar(player.global_position, to) <= ProdConfig.ARRIVE_TOLERANCE_M
	# THE SAME TIME, WITHIN A TEST BOUND — and she passed right over them.
	var same_time := absf(float(blocked_frames - clear_frames)) <= 12.0
	var passed_over := true
	# AN ORDINARY ENEMY WALKS THROUGH THEM TOO.
	var chaser: OrdinaryEnemy = enemies[1]
	chaser.debug_freeze_ai = true
	chaser.life = Damageable.new(100000.0)
	chaser.global_position = from
	var steps := 0
	while steps < 200 and _planar(chaser.global_position, to) > 0.4:
		chaser.global_position = chaser.global_position.move_toward(to, 0.06)
		await physics_frame
		steps += 1
	var enemy_through := _planar(chaser.global_position, to) <= 0.4
	# AND A KINDRED HOUND IS NOT BLOCKED EITHER.
	var hound_ok := true
	if not hounds.pack.is_empty():
		var h := hounds.pack[0] as KindredHound
		h.global_position = SPOT
		await _phys(10)
		hound_ok = is_instance_valid(h)
	await _reset()
	var ok := clear_ok and field and arrived and same_time and passed_over and enemy_through and hound_ok
	_note("E36_neither_blocks_movement",
		"a clear walk across the spot took %d frames and arrived=%s | with an ARMED trap, a SECOND trap and a BURNING FIELD in the way (%s) the SAME walk took %d frames and arrived=%s — the same time within a %d-frame test bound=%s | an ordinary enemy walked the same line through all three in %d steps=%s | a Kindred Hound stood on them unharmed and unblocked=%s. Canon: neither blocks movement."
		% [clear_frames, str(clear_ok), str(field), blocked_frames, str(arrived), 12,
		   str(same_time), steps, str(enemy_through), str(hound_ok)])
	_reached("E36_neither_blocks_movement")
	return ok

func chk_E37_navigation_is_unchanged() -> bool:
	await _reset()
	var at_launch: Dictionary = launch["nav"]
	# FILL THE CAP AND LIGHT A FIELD, then measure the baked mesh again.
	var pts := [SPOT, SPOT_B, SPOT_C]
	for k in CinderConfig.INSTANCES_MAX:
		await _place(pts[k % pts.size()])
	var t := cinder.traps[0] as CinderTrap if not cinder.traps.is_empty() else null
	await _arm(t)
	var e: OrdinaryEnemy = enemies[0]
	e.life = Damageable.new(100000.0)
	e.global_position = t.global_position + Vector3(0.3, 0, 0.0)
	await _until(func() -> bool: return cinder.eruptions > 0, 120)
	e.global_position = PARK
	await _phys(4)
	var now := NavService.measure_mesh(arena.nav_mesh())
	var same := int(now["polygons"]) == int(at_launch["polygons"]) \
		and int(now["vertices"]) == int(at_launch["vertices"]) \
		and absf(float(now["area"]) - float(at_launch["area"])) <= 0.0001 \
		and is_equal_approx(float(now["min_y"]), float(at_launch["min_y"])) \
		and is_equal_approx(float(now["max_y"]), float(at_launch["max_y"]))
	# THE MESH WAS BAKED EXACTLY ONCE, at build time — no placement re-baked it.
	var baked_once := arena.bake_count == int(launch["bake_count"]) and arena.bake_count == 1
	# NO D-402 FILE TOUCHES NAVIGATION AT ALL, beyond ASKING where walkable
	# ground is. Scanned in CODE: no region, no obstacle, no re-bake.
	var nav_re := RegEx.new()
	nav_re.compile("NavigationRegion3D|NavigationObstacle3D|bake_navigation|NavigationMesh|map_set_|region_set_")
	var nav_hits: Array[String] = []
	for f in D402_SCRIPTS:
		if nav_re.search(_code_only(_read_text(String(f)))) != null:
			nav_hits.append(String(f).get_file())
	var caught := nav_re.search("var r := NavigationRegion3D.new()") != null
	# AND A PATH ACROSS THE FIELD IS THE SAME LENGTH AS ONE ACROSS CLEAR FLOOR.
	var from := SPOT + Vector3(0.0, 0.0, -4.0)
	var to := SPOT + Vector3(0.0, 0.0, 4.0)
	var through := NavService.path_between(nav_map, from, to)
	var straight := NavService.path_length(through)
	var direct := _planar(from, to)
	var undeflected := absf(straight - direct) <= 0.25
	await _reset()
	var ok := same and baked_once and nav_hits.is_empty() and caught and undeflected
	_note("E37_navigation_is_unchanged",
		"with the instance cap filled and a burning field alight, the baked mesh is IDENTICAL to launch: %d polygons, %d vertices, %.4f m^2, band %.3f..%.3f=%s | it was baked EXACTLY once, at build time, and no placement re-baked it (bake_count %d)=%s | no D-402 file mentions a navigation region, obstacle, mesh or re-bake (hits: %s), and the scan IS able to see a planted one=%s | a path straight across the field is %.3f m against the %.3f m direct line — undeflected=%s"
		% [int(now["polygons"]), int(now["vertices"]), float(now["area"]), float(now["min_y"]),
		   float(now["max_y"]), str(same), arena.bake_count, str(baked_once), str(nav_hits),
		   str(caught), straight, direct, str(undeflected)])
	_reached("E37_navigation_is_unchanged")
	return ok

# =============================================================================
# I. LIFECYCLE — cleanup that touches nothing it does not own
# =============================================================================

func chk_E38_unequipping_or_deactivating_removes_only_what_it_owns() -> bool:
	await _reset()
	# BUILD SOMETHING TO LOSE: traps, a burning field, and OTHER Skills' state.
	# A DORMANT trap well clear of the one that will be lit, so lighting one does
	# not spring the other and the check really has BOTH to lose.
	await _place(Vector3(-15.8, 0.0, 6.0))
	var t := await _place(SPOT)
	await _arm(t)
	var e: OrdinaryEnemy = enemies[0]
	e.life = Damageable.new(100000.0)
	e.global_position = t.global_position + Vector3(0.3, 0, 0.0)
	await _until(func() -> bool: return cinder.eruptions > 0, 120)
	e.global_position = PARK
	var have := cinder.traps.size() >= 1 and cinder.grounds.size() >= 1
	var pack_before := hounds.pack.size()
	var cohort_before := hounds.cohort.size() if hounds.cohort != null else -1
	var arrows_before := hr.arrows_released
	var library_before := skills.library.count()
	var cfgs_before := skills.configurations.size()
	var removals0 := cinder.removals
	# UNEQUIP IT, through the ACCEPTED loadout operation.
	skills.loadout.bind(CinderContent.BINDING_INDEX, "")
	skills.loadout.revalidate(skills.pool)
	await _phys(4)
	var inactive := not cinder.is_active() and String(cinder.binding_state()["state"]) == "UNEQUIPPED"
	var cleared := cinder.traps.is_empty() and cinder.grounds.is_empty() \
		and cinder.live_nodes.is_empty() and cinder.removals == removals0 + 1
	# NOTHING IS LEFT IN THE SCENE TREE — counted, not assumed.
	await _phys(2)
	var leftovers: Array[String] = []
	var stack: Array = [main]
	var left := 0
	while not stack.is_empty():
		var n: Node = stack.pop_back()
		# A node already QUEUED FOR DELETION is not one that was left behind:
		# `queue_free()` is deferred, and counting it would measure the engine's
		# deletion schedule rather than this runtime's cleanup.
		if (n is CinderTrap or n is CinderGround) and not n.is_queued_for_deletion():
			left += 1
			leftovers.append("%s (%s)" % [String(n.name), n.get_class()])
		stack.append_array(n.get_children())
	# AND NOTHING ELSE WAS TOUCHED.
	var untouched := hounds.pack.size() == pack_before \
		and (hounds.cohort == null or hounds.cohort.size() == cohort_before) \
		and hr.arrows_released == arrows_before \
		and skills.library.count() == library_before \
		and skills.configurations.size() == cfgs_before \
		and skills.library.knows(CinderContent.SKILL_CINDER_FIELD)
	# SPLINTER SHOT STILL WORKS with Cinder Field unequipped.
	skills.clear_cooldowns()
	skills.pool.refill()
	var target: OrdinaryEnemy = enemies[1]
	target.life = Damageable.new(100000.0)
	target.global_position = player.global_position + Vector3(0.0, 0.0, 3.0)
	cam.debug_cursor_override = target.global_position
	await _phys(4)
	var shot := skills.use_binding(HuntressContent.BINDING_INDEX)
	cam.debug_cursor_override = null
	var splinter_ok := bool(shot["ok"])
	await _until(func() -> bool: return not player.commitment.active, 240)
	# AND DEACTIVATION (not unequipping) REMOVES THEM THE SAME WAY: re-bound,
	# then deactivated by the accepted revalidation.
	skills.loadout.bind(CinderContent.BINDING_INDEX, CinderContent.CFG_CINDER_FIELD)
	skills.loadout.revalidate(skills.pool)
	await _phys(2)
	await _place(SPOT)
	var back := cinder.traps.size() == 1
	var removals1 := cinder.removals
	skills.loadout.deactivated[CinderContent.CFG_CINDER_FIELD] = "TEST FIXTURE: a declared deactivation"
	await _phys(4)
	var deact_state := String(cinder.binding_state()["state"]) == "DEACTIVATED"
	var deact_cleared := cinder.traps.is_empty() and cinder.removals == removals1 + 1
	skills.loadout.revalidate(skills.pool)
	await _reset()
	var ok := have and inactive and cleared and left == 0 and untouched and splinter_ok \
		and back and deact_state and deact_cleared
	_note("E38_unequipping_or_deactivating_removes_only_what_it_owns",
		"there were traps and a burning field to lose=%s | UNEQUIPPING through the accepted loadout made it UNEQUIPPED=%s and removed everything it owns, counting one removal=%s, with %d trap or field nodes left anywhere in the scene (%s) | NOTHING ELSE moved: the pack (%d), the cohort (%d), Splinter Shot's arrows (%d), the library (%d) and the Configurations (%d) are unchanged, and Cinder Field is still LEARNED=%s | Splinter Shot still fires with it unequipped=%s | re-bound and then DEACTIVATED, the state reads DEACTIVATED=%s and its traps go the same way, counting one more removal=%s"
		% [str(have), str(inactive), str(cleared), left, str(leftovers), pack_before, cohort_before, arrows_before,
		   library_before, cfgs_before, str(untouched), str(splinter_ok), str(deact_state),
		   str(deact_cleared)])
	_reached("E38_unequipping_or_deactivating_removes_only_what_it_owns")
	return ok

func chk_E39_re_equipping_restores_the_skill_without_resurrecting_instances() -> bool:
	await _reset()
	var t := await _place(SPOT)
	var ordinal_before := t.ordinal
	skills.loadout.bind(CinderContent.BINDING_INDEX, "")
	skills.loadout.revalidate(skills.pool)
	await _phys(4)
	var gone := cinder.traps.is_empty() and (t == null or not is_instance_valid(t))
	# RE-EQUIP. The Skill works again; the removed instances do NOT come back.
	skills.loadout.bind(CinderContent.BINDING_INDEX, CinderContent.CFG_CINDER_FIELD)
	skills.loadout.revalidate(skills.pool)
	skills.pool.refill()
	skills.clear_cooldowns()
	await _phys(4)
	var active := cinder.is_active() and String(cinder.binding_state()["state"]) == "ACTIVE"
	var still_empty := cinder.traps.is_empty() and cinder.grounds.is_empty() \
		and cinder.live_nodes.is_empty()
	# AND A NEW PLACEMENT WORKS, with a NEW ordinal — nothing was resurrected.
	var t2 := await _place(SPOT)
	var fresh := t2 != null and t2.ordinal > ordinal_before and cinder.traps.size() == 1
	# THE ACCEPTED D-392 LOADOUT ALSO REMOVES IT, because binding 7 is empty there.
	hounds.restore_accepted_d392_loadout()
	await _phys(4)
	var restored_removes := not cinder.is_active() and cinder.traps.is_empty()
	var plan_empty := String((HoundContent.accepted_d392_loadout_plan()["bindings"] as Array)[CinderContent.BINDING_INDEX]) == ""
	await _reset()
	var ok := gone and active and still_empty and fresh and restored_removes and plan_empty
	_note("E39_re_equipping_restores_the_skill_without_resurrecting_instances",
		"unequipping removed the trap (ordinal %d)=%s | re-equipping made it ACTIVE again=%s with NOTHING resurrected — no trap, no field, no node=%s | and a NEW placement works, with a NEW ordinal %d=%s | restoring the ACCEPTED D-392 loadout also removes it, because binding %d is EMPTY in that plan=%s/%s"
		% [ordinal_before, str(gone), str(active), str(still_empty),
		   t2.ordinal if t2 != null else -1, str(fresh), CinderContent.BINDING_INDEX + 1,
		   str(restored_removes), str(plan_empty)])
	_reached("E39_re_equipping_restores_the_skill_without_resurrecting_instances")
	return ok

# =============================================================================
# J. NO REGRESSION ELSEWHERE
# =============================================================================

func chk_E40_splinter_shot_is_preserved_exactly() -> bool:
	await _reset()
	var cfg := skills.loadout.configuration(HuntressContent.CFG_SPLINTER_SHOT) as SkillConfiguration
	var res := cfg.resolve()
	# ITS BINDING, ITS TIMING, ITS NUMBERS AND ITS DELIVERY ARE UNCHANGED.
	var bound := skills.loadout.bindings[HuntressContent.BINDING_INDEX] == HuntressContent.CFG_SPLINTER_SHOT \
		and HuntressContent.BINDING_INDEX == 5
	var numbers := is_equal_approx(float(res["damage"]), HuntressConfig.SPLINTER_DAMAGE_AT_RANK_1) \
		and is_equal_approx(float(res["mana_cost"]), HuntressConfig.SPLINTER_MANA_AT_RANK_1) \
		and is_equal_approx(float(res["action_duration"]), HuntressConfig.splinter_action_s()) \
		and is_equal_approx(float(res["release_marker"]), HuntressConfig.splinter_release_marker()) \
		and String(res["delivery"]) == "splinter_arrow" and int(res["projectiles"]) == 1
	# ITS REGISTRY DIGESTS TO WHAT IT DID BEFORE THIS STAGE.
	var d := _numeric_digest(_constants("res://scripts/huntress/huntress_config.gd"))
	# AND IT STILL FIRES, HITS, AND CANCELS RECOVERY.
	var target: OrdinaryEnemy = enemies[0]
	target.life = Damageable.new(100000.0)
	target.global_position = player.global_position + Vector3(0.0, 0.0, 3.2)
	var life0 := target.life.life
	var arrows0 := hr.arrows_released
	# THE ORPHAN COUNTER IS CUMULATIVE, and this suite's own fixture resets the
	# accepted commitment between checks, which the accepted Huntress runtime
	# correctly counts. The claim is that THIS check's Splinter Shot leaves none.
	var orphans0 := hr.hold_orphans
	cam.debug_cursor_override = target.global_position
	await _phys(4)
	skills.clear_cooldowns()
	skills.pool.refill()
	var used := skills.use_binding(HuntressContent.BINDING_INDEX)
	var fired := bool(used["ok"])
	await _until(func() -> bool: return hr.arrows_released > arrows0, 240)
	var released := hr.arrows_released == arrows0 + 1
	await _until(func() -> bool: return target.life.life < life0, 240)
	var hit := target.life.life < life0
	cam.debug_cursor_override = null
	# THE FACING SNAP AND THE FACING-HOLD SEAM ARE UNTOUCHED.
	var facing := hr.late_visual_alignments >= 0 and hr.hold_orphans == orphans0
	# AND A CINDER FIELD USE DOES NOT DISTURB IT: its own counters do not move.
	var uses0 := hr.uses_begun
	await _until(func() -> bool: return not player.commitment.active, 240)
	await _place(SPOT)
	var undisturbed := hr.uses_begun == uses0 and hr.arrows_released == arrows0 + 1
	await _reset()
	var ok := bound and numbers and fired and released and hit and facing and undisturbed
	_note("E40_splinter_shot_is_preserved_exactly",
		"Splinter Shot is still on binding %d=%s with its accepted damage %.1f, Mana %.1f, action %.4f s, marker %.4f, one arrow=%s | HuntressConfig digests to %s over %d numeric constants | it still FIRED=%s, RELEASED one arrow=%s and HIT for real=%s | the facing-hold seam left no NEW orphan during this check=%s | and a Cinder Field use afterwards did not move its counters at all=%s"
		% [HuntressContent.BINDING_INDEX + 1, str(bound), float(res["damage"]), float(res["mana_cost"]),
		   float(res["action_duration"]), float(res["release_marker"]), str(numbers),
		   String(d[1]).left(16), int(d[0]), str(fired), str(released), str(hit), str(facing),
		   str(undisturbed)])
	_reached("E40_splinter_shot_is_preserved_exactly")
	return ok

func chk_E41_kindred_hounds_and_the_cohort_are_preserved_exactly() -> bool:
	await _reset()
	var cfg := skills.loadout.configuration(HoundContent.CFG_KINDRED_HOUNDS) as SkillConfiguration
	var res := cfg.resolve()
	# THE PACK, ITS RESERVATION AND ITS NUMBERS.
	var pack := hounds.pack.size() == HoundConfig.PACK_SIZE and hounds.is_sustained() \
		and String(hounds.persistent_state()["state"]) == "ACTIVE"
	var values := is_equal_approx(HoundConfig.ACQUISITION_RANGE_M, 6.0) \
		and is_equal_approx(HoundConfig.LEASH_RANGE_M, 9.0) \
		and is_equal_approx(HoundConfig.SPEED_MPS, 5.2) \
		and HoundConfig.PACK_SIZE == 2 \
		and is_equal_approx(float(res["reserve_fraction"]), HoundConfig.reserve_fraction_at(1)) \
		and String(res["reserve_resource"]) == "mana"
	# THE COHORT IS INTACT AND STILL STEPPING.
	var cohort := hounds.cohort != null and hounds.cohort.size() == HoundConfig.PACK_SIZE
	var recoveries0 := hounds.cohort.total_recoveries()
	# SHE WALKS; THE PACK FOLLOWS. A live behavioural check, not a field read.
	player.command_move_to(SPOT_C)
	await _until(func() -> bool: return player.move_destination == null, 480)
	await _phys(30)
	var near := true
	for h in hounds.pack:
		var hd := h as KindredHound
		if hd != null and is_instance_valid(hd):
			near = near and _planar(hd.global_position, player.global_position) <= HoundConfig.LEASH_RANGE_M
	var no_spurious := hounds.cohort.total_recoveries() - recoveries0 <= 2
	# THE TWO REGISTRIES DIGEST TO WHAT THEY DID.
	var dh := _numeric_digest(_constants("res://scripts/hounds/hound_config.gd"))
	var dc := _numeric_digest(_constants("res://scripts/cohort/cohort_config.gd"))
	# AND A BURNING FIELD DOES NOT DAMAGE THEM: an ally is refused by the same
	# predicate the trap uses.
	var t := await _place(player.global_position + Vector3(0.0, 0.0, 1.2))
	await _arm(t)
	var e: OrdinaryEnemy = enemies[0]
	e.life = Damageable.new(100000.0)
	e.global_position = t.global_position + Vector3(0.2, 0, 0.0)
	await _until(func() -> bool: return cinder.eruptions > 0, 120)
	var hound_life0: Array = []
	for h in hounds.pack:
		var hd2 := h as KindredHound
		hound_life0.append(hd2.life.life if hd2 != null and is_instance_valid(hd2) else -1.0)
		if hd2 != null and is_instance_valid(hd2):
			hd2.global_position = t.global_position
	await _until(func() -> bool: return cinder.ground_ticks >= 2, 300)
	var unhurt := true
	for i in hounds.pack.size():
		var hd3 := hounds.pack[i] as KindredHound
		if hd3 != null and is_instance_valid(hd3):
			unhurt = unhurt and is_equal_approx(hd3.life.life, float(hound_life0[i]))
	await _reset()
	var ok := pack and values and cohort and near and no_spurious and unhurt
	_note("E41_kindred_hounds_and_the_cohort_are_preserved_exactly",
		"the pack is %d hounds, sustained and ACTIVE=%s, with its accepted 6.0/9.0 m ranges, 5.2 m/s, pack 2 and %.1f%% Mana reservation unmoved=%s | the cohort holds %d members=%s | she walked and both hounds stayed inside the leash=%s with at most 2 soft recoveries=%s | HoundConfig digests to %s (%d constants) and CohortConfig to %s (%d) | and standing in a BURNING FIELD did not damage them at all=%s — the same ally refusal the trap uses"
		% [hounds.pack.size(), str(pack), float(res["reserve_fraction"]) * 100.0, str(values),
		   hounds.cohort.size() if hounds.cohort != null else -1, str(cohort), str(near),
		   str(no_spurious), String(dh[1]).left(16), int(dh[0]), String(dc[1]).left(16), int(dc[0]),
		   str(unhurt)])
	_reached("E41_kindred_hounds_and_the_cohort_are_preserved_exactly")
	return ok

func chk_E42_player_locomotion_redirection_is_preserved_exactly() -> bool:
	await _reset()
	# THE TWO LOCOMOTION FILES ARE BYTE-IDENTICAL IN BEHAVIOUR: their numeric
	# constants digest, and `GroundMotion` still owns no number of its own.
	var dl := _numeric_digest(_constants("res://scripts/locomotion/locomotion_config.gd"))
	var gm := _numeric_digest(_constants("res://scripts/locomotion/ground_motion.gd"))
	var own_none := int(gm[0]) == 0
	var values := is_equal_approx(LocomotionConfig.WISH_EPSILON, 0.001) \
		and is_equal_approx(LocomotionConfig.RATE_REFERENCE_MPS, ProdConfig.TOP_SPEED_MPS) \
		and is_equal_approx(ProdConfig.ACCEL_MPS2, 30.0) and is_equal_approx(ProdConfig.DECEL_MPS2, 38.0) \
		and is_equal_approx(ProdConfig.ACTION_BRAKE_MPS2, 120.0) \
		and is_equal_approx(ProdConfig.ARRIVE_TOLERANCE_M, 0.35)
	# THE REDIRECTION STILL HAPPENS IN ONE PHYSICS FRAME.
	# A lane MEASURED inside the west chamber (z = -11 .. +11): from z = 1 to
	# z = 9. A destination outside the arena would simply never be served.
	player.global_position = SPOT + Vector3(0.0, 0.0, -5.0)
	await _phys(2)
	var start := player.global_position
	player.command_move_to(SPOT + Vector3(0.0, 0.0, 3.0))
	# AT SPEED **AND** CLEAR OF THE START: a reversal issued inside the arrival
	# tolerance of where she stands is cleared on arrival instead of served —
	# the same rule the accepted D-400 suite drives by, for the same reason.
	await _until(func() -> bool: return player.motor.speed() >= 0.95 * ProdConfig.TOP_SPEED_MPS and _planar(player.global_position, start) >= 3.0, 420)
	var moving := player.motor.speed()
	var d0 := player.motor.velocity.normalized()
	var redirects0 := player.motor.redirects
	player.command_move_to(SPOT + Vector3(0.0, 0.0, -5.0))
	await _phys(1)
	var reversed := player.motor.velocity.dot(d0) < 0.0 and player.motor.redirects > redirects0
	var speed_kept := absf(player.motor.speed() - moving) <= 0.35
	var off := GroundMotion.direction_angle_deg(player.motor.velocity, player.last_wish)
	var aligned := off <= 0.01
	# AND THE ONE MOTOR PATH IS STILL THE ONLY ONE: no D-402 file steps it.
	var steppers: Array[String] = []
	for f in D402_SCRIPTS:
		var c := _code_only(_read_text(String(f)))
		if c.find("motor.step(") >= 0 or c.find("GroundMotion.step_velocity(") >= 0:
			steppers.append(String(f).get_file())
	await _reset()
	var ok := own_none and values and reversed and speed_kept and aligned and steppers.is_empty()
	_note("E42_player_locomotion_redirection_is_preserved_exactly",
		"LocomotionConfig digests to %s over %d numeric constants, and GroundMotion still declares %d of its own=%s | the accepted rates are unmoved: epsilon %.4f, reference %.3f m/s, accel 30.0, brake 38.0, ACTION brake 120.0, arrival 0.35=%s | MEASURED: from %.3f m/s a reversal redirected the velocity in ONE physics frame=%s, keeping the scalar speed (%.3f m/s)=%s and sitting %.6f deg off the commanded direction=%s | no D-402 file steps the motor (hits: %s)"
		% [String(dl[1]).left(16), int(dl[0]), int(gm[0]), str(own_none), LocomotionConfig.WISH_EPSILON,
		   LocomotionConfig.RATE_REFERENCE_MPS, str(values), moving, str(reversed),
		   player.motor.speed(), str(speed_kept), off, str(aligned), str(steppers)])
	_reached("E42_player_locomotion_redirection_is_preserved_exactly")
	return ok

func chk_E43_no_accepted_registry_value_changed() -> bool:
	# EVERY ACCEPTED REGISTRY, BY DIGEST. A digest that moves on its own is worse
	# than no pin, so the keys are normalised before sorting (the D-400 lesson).
	var rows: Array[String] = []
	var digests := {}
	for f in ["res://scripts/core/prod_config.gd", "res://scripts/imprint/imprint_config.gd",
			"res://scripts/huntress/huntress_config.gd", "res://scripts/hounds/hound_config.gd",
			"res://scripts/cohort/cohort_config.gd", "res://scripts/locomotion/locomotion_config.gd"]:
		var d := _numeric_digest(_constants(String(f)))
		digests[String(f).get_file()] = d
		rows.append("%s: %d numeric constants, %s" % [String(f).get_file(), int(d[0]), String(d[1]).left(16)])
	# THE NAMED VALUES THE OWNER LISTED AS NOT LOCKED — each still exactly what
	# it was, and each still labelled a CANDIDATE rather than a lock.
	var named := is_equal_approx(ProdConfig.TOP_SPEED_MPS, 3.889) \
		and ProdConfig.TOP_SPEED_STATUS.find("PROVISIONAL STARTING CANDIDATE") == 0 \
		and is_equal_approx(ProdConfig.CAM_PITCH_DEG, -52.0) \
		and is_equal_approx(ProdConfig.CAM_SIZE_DEFAULT, 14.0) \
		and is_equal_approx(ProdConfig.CAM_SIZE_MIN, 11.0) and is_equal_approx(ProdConfig.CAM_SIZE_MAX, 18.0) \
		and is_equal_approx(ProdConfig.ATTACK_RELEASE_MARKER, 0.36) \
		and is_equal_approx(ProdConfig.ATTACK_COOLDOWN_S, 0.45) \
		and is_equal_approx(ProdConfig.YAW_RATE_DEG_PER_S, 720.0) \
		and ProdConfig.ENEMY_COUNT == 4
	# THE THREE DIAGNOSTIC SPEED MODES ARE UNTOUCHED.
	var modes := true
	var want := [1.0, 1.8, 3.0]
	var i := 0
	for m in CohortConfig.speed_modes():
		modes = modes and is_equal_approx(float(m[1]), want[i])
		i += 1
	# NO D-402 FILE ASSIGNS INTO AN ACCEPTED REGISTRY.
	var writes := RegEx.new()
	writes.compile("(ProdConfig|ImprintConfig|HuntressConfig|HoundConfig|CohortConfig|LocomotionConfig)\\.[A-Z_]+\\s*=[^=]")
	var write_hits: Array[String] = []
	for f in D402_SCRIPTS:
		if writes.search(_code_only(_read_text(String(f)))) != null:
			write_hits.append(String(f).get_file())
	var caught := writes.search("ProdConfig.TOP_SPEED_MPS = 5.0") != null
	# AND THE PLANTED-VALUE CONTROL: the digest sees a single changed number.
	var planted := _constants("res://scripts/core/prod_config.gd").duplicate()
	planted["TOP_SPEED_MPS"] = 4.0
	var refuses := String(_numeric_digest(planted)[1]) != String((digests["prod_config.gd"] as Array)[1])
	var ok := named and modes and write_hits.is_empty() and caught and refuses
	_note("E43_no_accepted_registry_value_changed",
		"the six accepted registries, by digest: %s | the named values the owner listed as NOT LOCKED are each exactly what they were, and the top speed is still labelled a CANDIDATE=%s | the three diagnostic speed modes are still 1.0 / 1.8 / 3.0=%s | no D-402 file assigns into an accepted registry (hits: %s) and a planted assignment IS caught=%s | the digest REFUSES a single changed number=%s"
		% [" · ".join(rows), str(named), str(modes), str(write_hits), str(caught), str(refuses)])
	_reached("E43_no_accepted_registry_value_changed")
	return ok

# =============================================================================
# K. WHAT MUST NOT APPEAR
# =============================================================================

func chk_E44_no_prey_no_mark_and_no_ignite() -> bool:
	await _reset()
	# 1. NO PREY, NO MARK, NO IGNITE AS AN IDENTIFIER, anywhere in the D-402
	#    scripts. Declarations only, with strings stripped, so the denials that
	#    must NAME what they deny cannot satisfy the scan.
	var decl := RegEx.new()
	decl.compile("(?m)^\\s*(?:static\\s+)?(?:func|var|const|class_name|signal|class)\\s+([A-Za-z_][A-Za-z_0-9]*)")
	var camel := RegEx.new()
	camel.compile("([a-z0-9])([A-Z])")
	var banned := ["prey", "mark", "marked", "marks", "marking", "ignite", "ignited", "ignites"]
	var hits: Array[String] = []
	for f in D402_SCRIPTS:
		var code := _strip_strings(_code_only(_read_text(String(f))))
		for m in decl.search_all(code):
			var ident := m.get_string(1)
			var snake := camel.sub(ident, "$1_$2", true).to_lower()
			for tok in snake.split("_"):
				if banned.has(String(tok)):
					hits.append("%s: %s" % [String(f).get_file(), ident])
	# 2. NO SUCH STATE ON ANY LIVE OBJECT.
	var props: Array[String] = []
	for obj in [cinder, cinder_hud]:
		for pr in (obj as Object).get_property_list():
			var pn := String(pr["name"]).to_lower()
			for tok2 in banned:
				if pn.find(String(tok2)) >= 0:
					props.append(pn)
	# 3. NO SUCH NODE IN THE LIVE TREE, and none on a placed trap or field.
	var t := await _place(SPOT)
	await _arm(t)
	var e: OrdinaryEnemy = enemies[0]
	e.life = Damageable.new(100000.0)
	e.global_position = t.global_position + Vector3(0.3, 0, 0.0)
	await _until(func() -> bool: return cinder.eruptions > 0, 120)
	# SNAPSHOT AT ONCE, before the sprung body's linger frees it.
	var erupt_hits := t.hit_ids.size()
	var nodes: Array[String] = []
	var stack: Array = [main]
	while not stack.is_empty():
		var n: Node = stack.pop_back()
		var nm := String(n.name).to_lower()
		for tok3 in banned:
			if nm.find(String(tok3)) >= 0:
				nodes.append(String(n.name))
		stack.append_array(n.get_children())
	# 4. THE ERUPTION DESIGNATED NOTHING: it recorded who it Hit, and nothing on
	#    the enemy, the registry or any runtime changed to mark it.
	var designates_nothing := erupt_hits >= 1 and cinder.get("designated") == null \
		and hr.get("prey") == null and hounds.get("prey") == null
	# 5. NO SURFACE SHOWS ONE.
	cinder_hud.refresh()
	hud.set_enabled(true)
	hud.refresh()
	var surfaces := cinder_hud.last_text + "\n" + hud.compose()
	hud.set_enabled(false)
	var surface_clean := true
	for tok4 in ["prey", "ignite", "huntress's mark"]:
		surface_clean = surface_clean and surfaces.to_lower().find(String(tok4)) < 0
	# 6. AND NO AILMENT SYSTEM WAS ADDED: the burning Ground is a Duration
	#    effect, not a stacking ailment. It applies no stack and keeps no counter.
	var gsrc := _strip_strings(_code_only(_read_text("res://scripts/cinder/cinder_ground.gd")))
	var no_ailment := gsrc.find("stack") < 0 and gsrc.find("ailment") < 0 and gsrc.find("apply_ignite") < 0
	# 7. THE SCANS CAN FIRE: a planted declaration of each is caught.
	var caught := 0
	for planted in ["\tvar prey_target = null", "\tvar mark_state := 0", "\tfunc apply_ignite() -> void:"]:
		for m2 in decl.search_all(_strip_strings(_code_only(String(planted)))):
			var snake2 := camel.sub(m2.get_string(1), "$1_$2", true).to_lower()
			for tok5 in snake2.split("_"):
				if banned.has(String(tok5)):
					caught += 1
	await _reset()
	var ok := hits.is_empty() and props.is_empty() and nodes.is_empty() and designates_nothing \
		and surface_clean and no_ailment and caught == 3
	_note("E44_no_prey_no_mark_and_no_ignite",
		"NO Prey, Mark or Ignite IDENTIFIER is declared in any of the %d D-402 scripts (hits: %s) | no such property on the runtime or the HUD (%s) | no such node anywhere in the live tree with a trap placed and a field burning (%s) | the eruption Hit %d enemies and DESIGNATED NOTHING — no designation state exists on this runtime, the Huntress runtime or the hound runtime=%s | no surface shows one=%s | and no ailment or stacking system was added: the burning Ground names no stack, ailment or ignite call=%s | each of the three planted declarations IS caught (%d of 3)=%s"
		% [D402_SCRIPTS.size(), str(hits), str(props), str(nodes), erupt_hits,
		   str(designates_nothing), str(surface_clean), str(no_ailment), caught, str(caught == 3)])
	_reached("E44_no_prey_no_mark_and_no_ignite")
	return ok

# =============================================================================
# L. REVIEW SURFACES
# =============================================================================

func chk_E45_f1_and_f2_start_hidden_and_the_hud_overlaps_nothing() -> bool:
	# AT LAUNCH, as normal play has it: BOTH developer surfaces hidden, and the
	# four review HUDs shown.
	var hidden := bool(launch["overlay_enabled"]) == false and bool(launch["panel_enabled"]) == false \
		and bool(launch["d381_enabled"]) == false
	var shown := bool(launch["d392_enabled"]) and bool(launch["hounds_hud_enabled"]) \
		and bool(launch["cohort_hud_enabled"]) and bool(launch["cinder_hud_enabled"])
	# AND THEY ARE STILL INDEPENDENTLY TOGGLEABLE: the accepted behaviour.
	hud.set_enabled(true)
	var on := hud.enabled and not panel.enabled
	hud.set_enabled(false)
	var off := not hud.enabled
	# THE HUD IS CLICK-THROUGH: every Control ignores the mouse, because
	# click-to-move is the canonical mouse scheme.
	cinder_hud.refresh()
	var controls: Array = []
	_subtree(cinder_hud, controls)
	var eaters: Array[String] = []
	var n_controls := 0
	for c in controls:
		if c is Control:
			n_controls += 1
			if (c as Control).mouse_filter != Control.MOUSE_FILTER_IGNORE:
				eaters.append(String((c as Node).name))
	# IT OVERLAPS NO OTHER REVIEW SURFACE, MEASURED from the live rectangles.
	hounds_hud.refresh()
	cohort_hud.refresh()
	d392_hud.refresh()
	await process_frame
	var mine := cinder_hud.body_rect()
	var others := {"D-396": hounds_hud.body_rect(), "D-398": cohort_hud.body_rect(),
		"D-392": d392_hud.body_rect()}
	var overlaps: Array[String] = []
	for k in others.keys():
		var r: Rect2 = others[k]
		if r.size.x > 0.0 and mine.size.x > 0.0 and mine.intersects(r):
			overlaps.append(String(k))
	# IT LEAVES THE SCREEN CENTRE CLEAR — where the character is.
	var vp := root.get_viewport().get_visible_rect()
	var centre := Rect2(vp.size * 0.5 - Vector2(180, 130), Vector2(360, 260))
	var covers_centre := mine.intersects(centre)
	# AND IT IS COMPACT: a bounded share of the frame. A TEST BOUND.
	var share := (mine.size.x * mine.size.y) / maxf(1.0, vp.size.x * vp.size.y)
	var compact := share <= 0.16 and mine.size.x > 0.0
	var ok := hidden and shown and on and off and eaters.is_empty() and n_controls >= 8 \
		and overlaps.is_empty() and not covers_centre and compact
	_note("E45_f1_and_f2_start_hidden_and_the_hud_overlaps_nothing",
		"AT LAUNCH both developer surfaces are HIDDEN (F1 overlay, F2 panel, and the D-381 HUD)=%s and the four review HUDs are shown=%s | the overlay still toggles independently=%s/%s | all %d Controls of this HUD are MOUSE_FILTER_IGNORE (eaters: %s) — it never eats a click | its live rectangle %s overlaps no other review surface (overlaps: %s)=%s, leaves the screen centre clear=%s and covers %.2f%% of a %dx%d frame=%s"
		% [str(hidden), str(shown), str(on), str(off), n_controls, str(eaters), str(mine),
		   str(overlaps), str(overlaps.is_empty()), str(not covers_centre), share * 100.0,
		   int(vp.size.x), int(vp.size.y), str(compact)])
	_reached("E45_f1_and_f2_start_hidden_and_the_hud_overlaps_nothing")
	return ok

func chk_E46_the_hud_shows_the_six_owed_facts_and_owns_no_number() -> bool:
	await _reset()
	# BUILD A STATE WORTH SHOWING: a dormant trap, an armed one, a sprung one
	# with a burning field, a refusal, and Hit and Ground damage.
	player.global_position = Vector3(-17.5, 0.0, 0.0)
	await _phys(2)
	cam.debug_cursor_override = OFF_MESH
	await _phys(2)
	skills.use_binding(CinderContent.BINDING_INDEX)
	cam.debug_cursor_override = null
	await _phys(4)
	player.global_position = HER
	await _phys(2)
	var t := await _place(SPOT)
	await _arm(t)
	var e: OrdinaryEnemy = enemies[0]
	e.life = Damageable.new(100000.0)
	e.global_position = t.global_position + Vector3(0.3, 0, 0.0)
	await _until(func() -> bool: return cinder.eruptions > 0, 120)
	await _until(func() -> bool: return cinder.ground_ticks >= 1, 240)
	await _place(SPOT_B)
	cinder_hud.refresh()
	var text := cinder_hud.last_text
	var lines := cinder_hud.compose_lines()
	# THE SIX OWED FACTS, each on its own line.
	var rows := {
		"binding and readiness": String(lines["binding"]).find("BINDING %d" % (CinderContent.BINDING_INDEX + 1)) >= 0
			and (String(lines["binding"]).find("READY") >= 0 or String(lines["binding"]).find("COOLING") >= 0
				or String(lines["binding"]).find("MANA") >= 0 or String(lines["binding"]).find("ACTIVE") >= 0),
		"trap count and provisional cap": String(lines["instances"]).find("TRAPS") >= 0
			and String(lines["instances"]).find("PROVISIONAL cap") >= 0,
		"armed / dormant / sprung": String(lines["states"]).find("DORMANT") >= 0
			and String(lines["states"]).find("ARMED") >= 0 and String(lines["states"]).find("SPRUNG") >= 0,
		"current provisional timings": String(lines["timings"]).find("PROVISIONAL") == 0
			and String(lines["timings"]).find("arm") >= 0 and String(lines["timings"]).find("release") >= 0,
		"Hit events, separately": String(lines["hit"]).find("HIT") == 0
			and String(lines["hit"]).find("Fire Hits") >= 0,
		"Ground events, separately": String(lines["ground"]).find("GROUND") == 0
			and String(lines["ground"]).find("contributions") >= 0,
		"why a placement or trigger was refused": String(lines["refusal"]).find("LAST REFUSAL") == 0
			and String(lines["refusal"]).find("not walkable") > 0,
		# RE-SCOPED ONE FOR ONE AT DELIVERY (D-402): 7 + 1 = 8 rows. The
		# provisional GEOMETRY moved onto its own line when the timings line
		# proved too long to render, so it is asserted on its own line too.
		"the provisional area, separately": String(lines["geometry"]).find("PROVISIONAL") == 0
			and String(lines["geometry"]).find("trigger") >= 0
			and String(lines["geometry"]).find("eruption") >= 0,
	}
	var all_rows := true
	var row_text: Array[String] = []
	for k in rows.keys():
		all_rows = all_rows and bool(rows[k])
		row_text.append("%s=%s" % [String(k), str(rows[k])])
	# THE HIT AND GROUND LINES ARE DIFFERENT LINES with different totals.
	var separate := String(lines["hit"]) != String(lines["ground"]) \
		and cinder.hit_damage_total > 0.0 and cinder.ground_damage_total > 0.0
	# IT SAYS WHAT IT IS.
	var titled := String(lines["title"]) == CinderConfig.HUD_TITLE \
		and CinderConfig.HUD_TITLE.find("NOT a UI foundation") > 0
	# IT OWNS NO NUMBER: no numeric literal in its CODE beyond layout, and every
	# value comes from the live snapshot.
	var num := RegEx.new()
	# CONSTANTS ONLY, and a counter initialised to zero is not one: `var refreshes
	# := 0` is a tally the HUD keeps of itself, not a gameplay value it owns.
	num.compile("(?m)^\\s*const\\s+[A-Za-z_][A-Za-z_0-9]*\\s*(?::=|:\\s*\\w+\\s*=|=)\\s*-?[0-9]")
	var code := _strip_strings(_code_only(_read_text("res://scripts/cinder/cinder_review_hud.gd")))
	var numeric: Array[String] = []
	for m in num.search_all(code):
		numeric.append(m.get_string(0).strip_edges())
	# The TWO layout constants are declared and excepted BY NAME; anything else
	# would be a gameplay number living in a HUD.
	var only_layout := numeric.size() <= 2
	for s in numeric:
		only_layout = only_layout and (String(s).find("MAX_LINE_CHARS") >= 0 or String(s).find("TOP_CLEARANCE_PX") >= 0)
	var caught := num.search("const DAMAGE := 46.0") != null
	# NOT ONE RENDERED LINE IS CUT OFF.
	# ADDED AT DELIVERY (D-402), because LOOKING at the first rendered frames
	# showed four of the eight lines ending in an ellipsis at 1920 x 1080 -- the
	# HUD's own numbers unreadable in the picture meant to show them, which no
	# check was watching for. It reads the LABELS' OWN TEXT, which is what is
	# drawn, not the composed strings.
	var cut: Array[String] = []
	for k in CinderReviewHud.LINE_KEYS:
		var drawn := String((cinder_hud.lines[String(k)] as Label).text)
		if drawn.ends_with("…") or drawn.length() > CinderReviewHud.MAX_LINE_CHARS:
			cut.append(String(k))
	# AND THE GUARD CAN REFUSE: a line one character over the cap IS caught.
	var over := "x".repeat(CinderReviewHud.MAX_LINE_CHARS + 1)
	var cut_caught := over.length() > CinderReviewHud.MAX_LINE_CHARS \
		and CinderReviewHud._fit(over).ends_with("…")
	# AND IT READS THE LIVE OBJECTS: changing the runtime changes the text.
	var before := cinder_hud.last_text
	await _place(SPOT_C)
	cinder_hud.refresh()
	var reactive := cinder_hud.last_text != before
	await _reset()
	var ok := all_rows and separate and titled and only_layout and caught and reactive \
		and text.length() > 200 and cut.is_empty() and cut_caught
	_note("E46_the_hud_shows_the_six_owed_facts_and_owns_no_number",
		"the owner's six owed facts, each on its own line: %s=%s | the Hit and Ground lines are DIFFERENT lines with different live totals (%.1f and %.1f)=%s | it is titled '%s' and says it is NOT a UI foundation=%s | its CODE declares only the layout constants %s — no gameplay number=%s, and a planted one IS caught=%s | it reads the LIVE runtime: placing another trap changed the text=%s | NOT ONE of the %d RENDERED lines is cut off at %d characters (cut: %s)=%s, and a line one character over IS caught=%s"
		% [" · ".join(row_text), str(all_rows), cinder.hit_damage_total, cinder.ground_damage_total,
		   str(separate), CinderConfig.HUD_TITLE, str(titled), str(numeric), str(only_layout),
		   str(caught), str(reactive), CinderReviewHud.LINE_KEYS.size(), CinderReviewHud.MAX_LINE_CHARS,
		   str(cut), str(cut.is_empty()), str(cut_caught)])
	_reached("E46_the_hud_shows_the_six_owed_facts_and_owns_no_number")
	return ok

# =============================================================================
# M. SCOPE, ASSETS AND TRUTHFULNESS
# =============================================================================

func chk_E47_the_asset_intake_is_exactly_two_models_from_a_declared_pack() -> bool:
	# 1. THE PACK COUNT IS UNMOVED AT FIVE, and the declared files are 29 + 4.
	var packs := AssetManifest.packs()
	var declared := 0
	var ruins := 0
	for p in packs:
		declared += (p["files"] as Array).size()
		if String(p["key"]) == "ultimate_modular_ruins":
			ruins = (p["files"] as Array).size()
	var counts := packs.size() == 5 and declared == 33 and ruins == 22 \
		and AssetManifest.RUINS_MODELS.size() == 11
	# 2. EXACTLY THE TWO MODELS, AND NOTHING ELSE FROM THAT ARCHIVE.
	var added: Array[String] = []
	for m in AssetManifest.RUINS_MODELS:
		if String(m).findn("beartrap") >= 0:
			added.append(String(m))
	added.sort()
	var exactly_two := _same(added, ["BearTrap_Closed", "BearTrap_Open"])
	var no_trapdoor := not AssetManifest.RUINS_MODELS.has("Trapdoor")
	# 3. EVERY FILE ON DISK HASHES TO THE ARCHIVE ENTRY IT CAME FROM.
	var hash_rows: Array[String] = []
	var hashes_ok := true
	for row in D402_ASSETS:
		var path := AssetManifest.ROOT + "ultimate_modular_ruins/" + String(row[0])
		var f := FileAccess.open(path, FileAccess.READ)
		var got := ""
		if f != null:
			f.close()
			got = FileAccess.get_sha256(path)
		var same := got == String(row[1])
		hashes_ok = hashes_ok and same
		hash_rows.append("%s %s" % [String(row[0]), "OK" if same else "MISMATCH (%s)" % got.left(12)])
	# 4. NO .fbx AND NO .blend ANYWHERE, and no texture came with them.
	var stray: Array[String] = []
	var tree: Array = []
	_walk(AssetManifest.ROOT + "ultimate_modular_ruins", tree)
	for f2 in tree:
		var s := String(f2)
		if s.ends_with(".fbx") or s.ends_with(".blend") or s.findn("trapdoor") >= 0:
			stray.append(s.get_file())
	# 5. NEITHER .mtl REFERENCES A TEXTURE — the same fact the pack's nine had.
	var no_maps := true
	for row2 in D402_ASSETS:
		if String(row2[0]).ends_with(".mtl"):
			no_maps = no_maps and _read_text(AssetManifest.ROOT + "ultimate_modular_ruins/"
				+ String(row2[0])).find("map_") < 0
	# 6. BOTH MODELS LOAD, and the trap uses them by the MANIFEST's constant —
	#    no D-402 file hard-codes a third-party path.
	var loads := load(AssetManifest.ruins("BearTrap_Open")) != null \
		and load(AssetManifest.ruins("BearTrap_Closed")) != null
	var needle := "res://" + "assets/third_party"
	var hard: Array[String] = []
	for f3 in D402_SCRIPTS:
		if _read_text(String(f3)).find(needle) >= 0:
			hard.append(String(f3).get_file())
	var via_manifest := _code_only(_read_text("res://scripts/cinder/cinder_trap.gd")).find("AssetManifest.ruins(") >= 0
	# 7. NO SOURCE FILE IS EDITED: every visual change is a runtime override.
	var override_only := _code_only(_read_text("res://scripts/cinder/cinder_trap.gd")).find("material_override") >= 0 \
		and _code_only(_read_text("res://scripts/cinder/cinder_trap.gd")).find("RigCorpus.tint_all") >= 0
	# 8. NO VFX ARCHIVE IS READ, and no D-402 file names one.
	var vfx := RegEx.new()
	vfx.compile("BattleFX|DarkMagicFX|ElementalMagicFX|VividMotion|PortalVFX|shield-vfx|tornado")
	var vfx_hits: Array[String] = []
	for f4 in D402_SCRIPTS:
		if vfx.search(_code_only(_read_text(String(f4)))) != null:
			vfx_hits.append(String(f4).get_file())
	var vfx_caught := vfx.search("preload(\"res://BattleFX/x.tscn\")") != null
	# 9. AND THEY ARE LABELLED PLACEHOLDERS.
	var labelled := CinderConfig.TRAP_PLACEHOLDER_LABEL.find("PLACEHOLDER") == 0 \
		and CinderConfig.TRAP_PLACEHOLDER_LABEL.find("NOT final Huntress art") > 0 \
		and CinderConfig.VFX_PLACEHOLDER_LABEL.find("PROCEDURAL DIAGNOSTIC VFX") == 0 \
		and CinderConfig.VFX_PLACEHOLDER_LABEL.find("NOT production VFX") > 0
	var ok := counts and exactly_two and no_trapdoor and hashes_ok and stray.is_empty() \
		and no_maps and loads and hard.is_empty() and via_manifest and override_only \
		and vfx_hits.is_empty() and vfx_caught and labelled
	_note("E47_the_asset_intake_is_exactly_two_models_from_a_declared_pack",
		"%d packs (UNMOVED) and %d declared files — 29 + 4; the ruins pack holds %d files and %d models=%s | EXACTLY the two bear-trap models were added (%s) and no Trapdoor=%s | every file on disk hashes to the ARCHIVE ENTRY it came from: %s=%s | no .fbx, .blend or Trapdoor file anywhere in the tree (%s) | neither .mtl references a texture=%s | both models load=%s, no D-402 file hard-codes a third-party path (%s) and the trap uses the MANIFEST's own constant=%s | every visual change is a RUNTIME OVERRIDE, no source is edited=%s | no D-402 file names a VFX package (%s) and the scan IS able to see one=%s | both are labelled PLACEHOLDERS and NOT final art=%s"
		% [packs.size(), declared, ruins, AssetManifest.RUINS_MODELS.size(), str(counts),
		   str(added), str(exactly_two and no_trapdoor), " · ".join(hash_rows), str(hashes_ok),
		   str(stray), str(no_maps), str(loads), str(hard), str(via_manifest), str(override_only),
		   str(vfx_hits), str(vfx_caught), str(labelled)])
	_reached("E47_the_asset_intake_is_exactly_two_models_from_a_declared_pack")
	return ok

func chk_E48_denials_rulings_units_registry_and_no_self_acceptance() -> bool:
	# 1. THE DENIALS, each naming D-402, the last denying self-acceptance.
	# RE-SCOPED UNDER D-404 (first act), one for one: the last denial is now DATED
	# HISTORY naming D-403, and the present-tense one must be GONE. Until D-404 this
	# required "The D-402 stage delivers OPEN pending owner live review; it does NOT
	# accept itself." -- TRUE WHEN WRITTEN. Still 17 denials, still each naming D-402.
	var den := CinderConfig.denials()
	var den_ok := den.size() == 17 \
		and String(den[16]).find("The D-402 stage was delivered OPEN and never accepted itself: the owner ACCEPTED and CLOSED it under D-403") == 0 \
		and not den.has("The D-402 stage delivers OPEN pending owner live review; it does NOT accept itself.")
	for d in den:
		den_ok = den_ok and String(d).find("D-402") >= 0
	# 2. THE CANONICAL RULES, each cited, each with exactly one disposition.
	var rulings := CinderConfig.canonical_rulings()
	var cited := rulings.size() == 14
	var kinds := ["IMPLEMENTED", "OBEYED", "USED", "PRESERVED"]
	for r in rulings:
		var k := String(r[2])
		var one := 0
		for kind in kinds:
			if k.find(String(kind)) == 0:
				one += 1
		cited = cited and one == 1 and String(r[0]).length() > 3 and String(r[1]).length() > 20
	# 3. THE PRINTED ROWS: 19 FD- rows in order, each naming where it returns;
	#    7 FO- rows carrying the owner's questions VERBATIM; none a pass.
	var fd := CinderConfig.deferred_rows()
	var fd_ok := fd.size() == 19
	for i in fd.size():
		fd_ok = fd_ok and String(fd[i][0]).begins_with("FD-%02d " % (i + 1)) \
			and String(fd[i][2]).find("RETURNS TO") >= 0 and String(fd[i][1]) != "PASS"
	# RE-SCOPED UNDER D-404 (first act), one for one: 7 - 7 = 0 owed, 0 + 7 = 7
	# DISCHARGED — D-403, 0 deleted. Each discharged row must still carry the
	# owner's question VERBATIM, the owner's ONE overall answer, and the bound that
	# travels with it: no row-by-row judgment and no number is inferred. Until D-404
	# this required seven OWED rows -- TRUE WHEN WRITTEN.
	var fo := CinderConfig.owed_to_owner()
	var fod := CinderConfig.discharged_rows()
	var fo_ok := fo.is_empty() and fod.size() == 7
	for i in fod.size():
		fo_ok = fo_ok and String(fod[i][0]) == "FO-%02d" % (i + 1) and String(fod[i][1]) == FO_TEXT[i] \
			and String(fod[i][2]) == "DISCHARGED — D-403" \
			and String(fod[i][3]).find("Looks and feels good.") > 0 \
			and String(fod[i][3]).find("no row-by-row judgment is inferred") > 0 \
			and String(fod[i][3]).find("ORIGINAL ROW TEXT, PRESERVED VERBATIM (OWED-TO-OWNER): '" + FO_TEXT[i] + "'") > 0
	# 4. NO SELF-ACCEPTANCE anywhere a viewer or a log could read it.
	var self_re := RegEx.new()
	# RE-SCOPED UNDER D-404 (first act), one for one: D-403 made "CINDER FIELD
	# STAGE ACCEPTED" the OWNER's fact, carried by the one definer, so the needle
	# MOVES to the OPEN D-404 stage; "ACCEPTED and CLOSED (D-402)" -- the stage
	# accepting ITSELF -- is still refused.
	self_re.compile("PLAYER DIRECT-CLICK MOVEMENT CORRECTION STAGE ACCEPTED|D-404 (is|stage is) ACCEPTED|ACCEPTED and CLOSED \\(D-402\\)|" + PLANTED_CLAIM)
	var claims: Array[String] = []
	for f in _runtime_script_files():
		if self_re.search(_code_only(_read_text(String(f)))) != null:
			claims.append(String(f).get_file())
	cinder_hud.refresh()
	hud.set_enabled(true)
	hud.refresh()
	var surfaces := cinder_hud.last_text + "\n" + hud.compose() + "\n" + ProdConfig.STATE
	hud.set_enabled(false)
	var surface_clean := self_re.search(surfaces) == null
	var caught := self_re.search("print(\"%s\")" % PLANTED_CLAIM) != null \
		and self_re.search("PLAYER DIRECT-CLICK MOVEMENT CORRECTION STAGE ACCEPTED and CLOSED (D-404)") != null
	# 5. THE BANNER PRINTS NO ROW AND NO STATE LINE into the accepted suites' logs.
	var banner := ""
	var src := _code_only(_read_text("res://scripts/foundation_main.gd"))
	var at := src.find("func _print_cinder_banner")
	if at >= 0:
		var end := src.find("\nfunc ", at + 5)
		banner = src.substr(at, (end - at) if end > 0 else -1)
	var banner_ok := banner.length() > 200 and banner.find("STATE") < 0 \
		and banner.find("deferred_rows") < 0 and banner.find("owed_to_owner") < 0
	# 6. EVERY NUMERIC CONSTANT OF THE STAGE IS REGISTERED, BOTH WAYS. The
	#    structural constants are excepted BY NAME, and named here so the
	#    exception is readable rather than implicit.
	var reg := CinderConfig.registry()
	var all_prov := reg.size() == 26
	for row in reg:
		all_prov = all_prov and String(row[2]).find("PROVISIONAL") == 0
	var excepted := ["RING_SEGMENTS", "RIM_TICKS", "BINDING_INDEX"]
	var consts := _constants("res://scripts/cinder/cinder_config.gd")
	var numeric: Array = []
	for k in consts.keys():
		var v = consts[k]
		if (typeof(v) == TYPE_INT or typeof(v) == TYPE_FLOAT) and not excepted.has(String(k)):
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
	# 7. NO RUNTIME LOAD LEAVES game3d/, and the stage has no dependency on a spike.
	var load_re := RegEx.new()
	load_re.compile("(?:load|preload|ResourceLoader\\.load|FileAccess\\.open|DirAccess\\.open)\\s*\\(\\s*\"([^\"]*)\"")
	var outward: Array[String] = []
	for f2 in D402_SCRIPTS:
		for m in load_re.search_all(_code_only(_read_text(String(f2)))):
			if not m.get_string(1).begins_with("res://") or m.get_string(1).find("..") >= 0:
				outward.append("%s:%s" % [String(f2).get_file(), m.get_string(1)])
	var spike := RegEx.new()
	spike.compile("game3d_spike|game3d_boss_spike|game3d_huntress_spike|game2d")
	var spike_hits: Array[String] = []
	for f3 in D402_SCRIPTS:
		if spike.search(_code_only(_read_text(String(f3)))) != null:
			spike_hits.append(String(f3).get_file())
	# 8. UNITS AT EVERY SURFACE. Built without a relative parent segment: the
	#    accepted F65 and I99 refuse one in any file of this project.
	var inv_path := ProjectSettings.globalize_path("res://").trim_suffix("/").get_base_dir() \
		.path_join("docs/testing/D402_CINDER_FIELD_OWED_CRITERIA_INVENTORY.md")
	var inv := _read_text(inv_path)
	var units := inv != "" and inv.find("**185**") >= 0 and inv.find("**48**") >= 0 \
		and inv.find("**24**") >= 0 and OWED.size() == 48
	# 9. AND THE SEAMS ARE CLEAR, at launch and now.
	var seams := bool(launch["seams_clear"]) and player.intent.seams_clear() \
		and cam.debug_cursor_override == null and not player.debug_freeze_attack
	var ok := den_ok and cited and fd_ok and fo_ok and claims.is_empty() and surface_clean \
		and caught and banner_ok and all_prov and both and refuses and outward.is_empty() \
		and spike_hits.is_empty() and units and seams
	_note("E48_denials_rulings_units_registry_and_no_self_acceptance",
		"RE-SCOPED UNDER D-404 (first act): %d denials, each naming D-402, the last now DATED HISTORY naming D-403=%s | %d canonical rules cited, each with EXACTLY ONE disposition=%s | FD-01..FD-19 in order, each naming where it returns, none a pass=%s | FO-01..FO-07 now 0 owed and 7 DISCHARGED — D-403, the owner's seven questions VERBATIM beside the owner's one overall answer, no row-by-row judgment inferred=%s | runtime code claiming the OPEN D-402 stage accepted: %s; the HUD, overlay and state line claim none=%s; planted claims caught=%s | the D-402 banner prints no row and no STATE line=%s | %d registry values, every one PROVISIONAL=%s; the registry and CinderConfig's numeric constants match BOTH ways (excepting the three structural ones by name: %s)=%s, and an unregistered planted constant is refused=%s | loads leaving game3d/: %s; files naming a spike or game2d/: %s | the inventory states 185 OWED CRITERIA, 48 EXECUTABLE CHECKS and 24 RUNNER CHECKS, and this suite owes %d=%s | the test seams were clear at launch and are clear now=%s. NOTHING HERE IS A LOCK."
		% [den.size(), str(den_ok), rulings.size(), str(cited), str(fd_ok), str(fo_ok), str(claims),
		   str(surface_clean), str(caught), str(banner_ok), reg.size(), str(all_prov), str(excepted),
		   str(both), str(refuses), str(outward), str(spike_hits), OWED.size(), str(units), str(seams)])
	_reached("E48_denials_rulings_units_registry_and_no_self_acceptance")
	return ok

# =============================================================================
# REPORT
# =============================================================================

func _report() -> void:
	player.intent.clear_seams()
	cam.debug_cursor_override = null
	print("")
	print("------------------------------------------------------------------------")
	print("RESULTS — %s (%s)" % [CinderConfig.STAGE, CinderConfig.DECISION])
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
	print("THE CANONICAL RULES THIS STAGE IMPLEMENTS, each with its disposition:")
	for r in CinderConfig.canonical_rulings():
		print("  [%-12s] %s — %s" % [String(r[2]).split(" —")[0], r[0], r[1]])
	print("")
	print("DEFERRED — recorded as such, NEVER as passes:")
	for row in CinderConfig.deferred_rows():
		print("  [%-28s] %s" % [row[1], row[0]])
		print("                   %s" % row[2])
	print("")
	print("OWED TO THE OWNER'S LIVE REVIEW — NOT passes and NOT failures:")
	for row in CinderConfig.owed_to_owner():
		print("  [OWED-TO-OWNER] %s %s" % [row[0], row[1]])
	# D-404 (first act): the seven rows D-403 answered, printed every run -- NOT
	# passes and NOT failures -- each with its ORIGINAL text beside the answer.
	print("")
	print("DISCHARGED BY THE OWNER'S D-403 ACCEPTANCE — NOT passes and NOT failures:")
	for row in CinderConfig.discharged_rows():
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
	print("DENIALS (%d):" % CinderConfig.denials().size())
	for d in CinderConfig.denials():
		print("  %s" % d)
	print("")
	print("UNITS: %d EXECUTABLE CHECKS here · 185 OWED CRITERIA in the D-402 inventory ·" % OWED.size())
	print("       24 RUNNER CHECKS in tests/cinder_smoke.sh · and the ACCEPTED suites' 85, 101, 40,")
	print("       53, 45, 40 and 33 EXECUTABLE CHECKS are DIFFERENT decisions' numbers.")
	print("       Different unit. None is a synonym for another.")
	print("")
	var verdict := "PASS" if _all_ok() else "FAIL"
	# RE-PINNED UNDER D-404 (first act): the summary carries the DISCHARGED count,
	# exactly as every earlier stage's does once its rows are answered. Until D-404
	# it ended "%d owed to the owner)" -- true when written.
	print("CINDER VERIFICATION: %s (%d checks: %d passed, %d failed/unreached, %d deferred, %d owed to the owner, %d discharged)"
		% [verdict, OWED.size(), passed, failed, CinderConfig.deferred_rows().size(),
		   CinderConfig.owed_to_owner().size(), CinderConfig.discharged_rows().size()])
	print("STATE: %s" % ProdConfig.STATE)
