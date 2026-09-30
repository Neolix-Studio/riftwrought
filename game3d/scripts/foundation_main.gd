class_name FoundationMain
extends Node3D

## RIFTWROUGHT — FIRST BOUNDED 3D PRODUCTION FOUNDATION (D-370, 2026-09-17)
##
## The composition root. It builds the world, the actors and the overlay, prints
## the truthfulness banner, and -- in capture mode -- renders the evidence.
##
## ============================================================================
## IT COMPLETES NO PHASE. IT DOES NOT COMPLETE P1 OR THE ORIGINAL P1C. IT DOES
## NOT AUTHORIZE P2. IT LOCKS NO VALUE.
## ============================================================================

var arena: ProductionArena
var cam: IsoCameraRig
var player: PlayerController
var enemies: Array = []
var hud: DebugOverlay
var corpus: AnimationLibrary
var bolt_root: Node3D

## ============================================================================
## THE D-375 GLOBAL IMPRINT SYSTEM PROTOTYPE — the project's SECOND stage.
## ============================================================================
## The FOUNDATION STAGE is ACCEPTED and CLOSED (D-373). This is a separately
## authorized stage on top of it, and it PRESERVES the accepted baseline: no
## accepted tuning value is modified, the accepted commitment is reused
## unchanged, and the accepted suite still passes 85 of 85.
var skills: SkillRuntime
var imprint_panel: LoadoutPanel
## THE D-381 REVIEW HUD -- a compact DIAGNOSTIC corner surface, added because the
## developer panel could not be read while playing. NOT a UI foundation.
var review_hud: ReviewHud
var entity_root: Node3D

## ============================================================================
## THE D-392 HUNTRESS SPLINTER SHOT STAGE — the project's FOURTH stage.
## ============================================================================
## Splinter Shot, the Huntress's ordinary shot, through the accepted Imprint
## architecture; her placeholder bow animation; one arrow resolved by time of
## impact and a combat-entity ID. DELIVERED and OPEN; it accepts nothing.
var huntress: HuntressRuntime
## The D-392 review HUD. The D-381 HUD above is RETAINED but hidden at launch:
## the owner asked for "a small playable review HUD" for Splinter Shot and the
## action state.
var huntress_hud: HuntressReviewHud

## ============================================================================
## THE D-396 KINDRED HOUNDS STAGE — the project's FIFTH stage.
## ============================================================================
## Kindred Hounds, a canonical Persistent Skill Imprint, through the accepted
## Imprint architecture: a labelled review loadout, two autonomous procedural
## stand-in hounds, the accepted targeting rule, bites, low-friction recovery.
## DELIVERED and OPEN; it accepts nothing.
var hounds: HoundRuntime
## The D-396 review HUD, top-right. The D-392 HUD stays bottom-right.
var hounds_hud: HoundReviewHud

## ============================================================================
## THE D-398 MOBILE MINION COHESION STAGE — the project's SIXTH stage.
## ============================================================================
## A shared mobile-minion cohort with Kindred Hounds as its only production
## consumer (built inside `HoundRuntime`), two DIAGNOSTIC stress modes and a
## compact review HUD. DELIVERED and OPEN; it accepts nothing.
var cohort_diagnostics: CohortDiagnostics
## The D-398 review HUD, bottom-centre, beside the D-392 and D-396 HUDs.
var cohort_hud: CohortReviewHud

## ============================================================================
## THE D-402 CINDER FIELD STAGE — the project's EIGHTH stage.
## ============================================================================
## Cinder Field, a canonical ACTIVE Skill Imprint, through the accepted Imprint
## architecture: a ground-targeted Fire Spell delivered as a TRAP that lies
## dormant, arms, and erupts ONCE into a Fire Hit and a lingering, NON-STACKING
## burning Ground. DELIVERED and OPEN; it accepts nothing.
var cinder: CinderRuntime
## The D-402 review HUD, right column beneath the D-396 one.
var cinder_hud: CinderReviewHud

## ============================================================================
## THE D-404 PLAYER DIRECT-CLICK MOVEMENT CORRECTION STAGE — the NINTH stage.
## ============================================================================
## A mouse order goes straight at the clicked point and stops at the first
## blocker; the controller owns that change (`DirectClickOrder`). This root adds
## only the review surfaces the owner asked for: a compact HUD and flat world
## markers for the clicked point, the straight segment and the first contact.
## DELIVERED and OPEN; it accepts nothing.
var click_gizmo: DirectClickGizmo
var click_hud: DirectClickReviewHud

var required_clips_missing: Array[String] = []
var ready_done: bool = false

func _ready() -> void:
	_build_environment()

	corpus = RigCorpus.build_corpus()

	arena = ProductionArena.new()
	arena.name = "Arena"
	add_child(arena)
	arena.build()

	bolt_root = Node3D.new()
	bolt_root.name = "Bolts"
	add_child(bolt_root)

	cam = IsoCameraRig.new()
	cam.name = "CameraRig"
	add_child(cam)
	cam.build()

	player = PlayerController.new()
	player.name = "PlayerProbe"
	add_child(player)
	player.setup(corpus)
	player.camera = cam
	player.bolt_parent = bolt_root
	player.global_position = ProductionArena.player_spawn()
	required_clips_missing = RigCorpus.verify_required(player.anim, ProdConfig.REQUIRED_CLIPS)

	cam.target = player
	cam.snap_to_target()

	for p in [Vector3(-9, 0, -3), Vector3(-9, 0, 3), Vector3(-16, 0, -6), Vector3(7, 0, 0)]:
		var e := OrdinaryEnemy.new()
		e.name = "Enemy%d" % enemies.size()
		add_child(e)
		e.setup(corpus)
		e.global_position = p
		e.player = player
		enemies.append(e)

	hud = DebugOverlay.new()
	hud.name = "DebugOverlay"
	hud.main = self
	add_child(hud)
	hud.build()
	# D-382: THE F1 OVERLAY STARTS HIDDEN TOO. The owner: "I meant BOTH developer
	# surfaces. The F1 overlay and F2 developer panel must both start hidden."
	# It launched ON from D-370 until D-382 -- true when written -- and F1 / pad Y
	# still toggle it.
	hud.set_enabled(false)

	# --- THE D-375 IMPRINT STAGE -------------------------------------------
	entity_root = Node3D.new()
	entity_root.name = "ImprintEntities"
	add_child(entity_root)

	skills = SkillRuntime.new()
	skills.name = "SkillRuntime"
	add_child(skills)
	skills.player = player
	skills.entity_parent = entity_root
	skills.bolt_parent = bolt_root
	skills.enemies_provider = func() -> Array: return enemies
	skills.compose()
	player.skills = skills

	# --- THE D-392 HUNTRESS SPLINTER SHOT STAGE ----------------------------
	# Composed AFTER the Skill runtime, so it processes after it every frame, and
	# fed the enemies IN THEIR SPAWN ORDER, which is the explicit composition
	# order their combat-entity IDs are assigned in.
	huntress = HuntressRuntime.new()
	huntress.name = "HuntressRuntime"
	add_child(huntress)
	huntress.setup(self, player, skills, bolt_root, enemies)

	# --- THE D-396 KINDRED HOUNDS STAGE ------------------------------------
	# Composed AFTER the Huntress runtime, whose registry of the active area the
	# hounds read. It learns Kindred Hounds and applies the labelled review
	# loadout through the accepted loadout operations.
	hounds = HoundRuntime.new()
	hounds.name = "KindredHoundsRuntime"
	add_child(hounds)
	hounds.setup(self, player, skills, huntress)

	# --- THE D-398 MOBILE MINION COHESION STAGE ----------------------------
	# The cohort itself is built inside the hound runtime; this adds only the two
	# DIAGNOSTIC modes, at their launch defaults (population 2, ORDINARY).
	cohort_diagnostics = CohortDiagnostics.new()
	cohort_diagnostics.name = "CohortDiagnostics"
	add_child(cohort_diagnostics)
	cohort_diagnostics.setup(hounds, player)

	# --- THE D-402 CINDER FIELD STAGE --------------------------------------
	# Composed AFTER the hound runtime, so the D-396 review loadout is already
	# applied and Cinder Field takes the next free binding on top of it. It reads
	# the SAME area registry the Splinter Shot stage filled, and registers
	# NOTHING in it: neither a trap nor a burning Ground is a combat entity.
	cinder = CinderRuntime.new()
	cinder.name = "CinderFieldRuntime"
	add_child(cinder)
	cinder.setup(self, player, skills, huntress, entity_root)

	imprint_panel = LoadoutPanel.new()
	imprint_panel.name = "LoadoutPanel"
	imprint_panel.runtime = skills
	add_child(imprint_panel)
	imprint_panel.build()
	# D-381: THE DEVELOPER PANEL IS HIDDEN BY DEFAULT and stays one press away on
	# its existing toggle (F2 / pad BACK). It launched OPEN from D-375 until D-381
	# -- true when written -- and the owner could not play and read it at once.
	imprint_panel.set_enabled(false)

	review_hud = ReviewHud.new()
	review_hud.name = "ReviewHud"
	review_hud.runtime = skills
	review_hud.player = player
	add_child(review_hud)
	review_hud.build()
	# D-392: THE D-381 HUD IS RETAINED BUT HIDDEN AT LAUNCH. It launched visible
	# from D-381 until D-392 -- true when written, and accepted as review tooling
	# under D-383. The owner's D-392 ruling asks for "a small playable review HUD"
	# for Splinter Shot and the action state, so the Splinter Shot HUD below is the
	# one launch HUD.
	review_hud.set_enabled(false)

	huntress_hud = HuntressReviewHud.new()
	huntress_hud.name = "HuntressReviewHud"
	huntress_hud.runtime = huntress
	add_child(huntress_hud)
	huntress_hud.build()

	# D-396: the Kindred Hounds review HUD, visible at launch beside the D-392 one.
	hounds_hud = HoundReviewHud.new()
	hounds_hud.name = "HoundReviewHud"
	hounds_hud.runtime = hounds
	add_child(hounds_hud)
	hounds_hud.build()

	# D-398: the cohesion review HUD, visible at launch, bottom-centre.
	cohort_hud = CohortReviewHud.new()
	cohort_hud.name = "CohortReviewHud"
	cohort_hud.runtime = hounds
	cohort_hud.diagnostics = cohort_diagnostics
	add_child(cohort_hud)
	cohort_hud.build()

	# D-402: the Cinder Field review HUD, visible at launch, right column beneath
	# the D-396 one. F1 and F2 stay HIDDEN, as D-382 ruled.
	cinder_hud = CinderReviewHud.new()
	cinder_hud.name = "CinderReviewHud"
	cinder_hud.runtime = cinder
	add_child(cinder_hud)
	cinder_hud.build()

	# D-404: the direct-click review surfaces, visible at launch. F1 and F2 stay
	# HIDDEN, as D-382 ruled. The markers are a plain Node3D -- no collision, no
	# navigation, no registration -- and follow the HUD's visibility.
	click_gizmo = DirectClickGizmo.new()
	click_gizmo.name = "DirectClickGizmo"
	click_gizmo.player = player
	add_child(click_gizmo)
	click_gizmo.build()
	click_hud = DirectClickReviewHud.new()
	click_hud.name = "DirectClickReviewHud"
	click_hud.player = player
	click_hud.diagnostics = cohort_diagnostics
	click_hud.gizmo = click_gizmo
	add_child(click_hud)
	click_hud.build()

	_print_banner()
	ready_done = true
	_maybe_capture()

func _build_environment() -> void:
	var we := WorldEnvironment.new()
	var env := Environment.new()
	env.background_mode = Environment.BG_COLOR
	env.background_color = Color(0.043, 0.055, 0.086)
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color = Color(0.250, 0.315, 0.470)   # cold ambient
	env.ambient_light_energy = ProdConfig.AMBIENT_ENERGY
	env.tonemap_mode = Environment.TONE_MAPPER_ACES
	# ============================================================================
	# TONEMAP WHITE IS 5.0, AND IT IS THE REASON THE FLOOR RECEDES.
	# ============================================================================
	# The first evidence captures came out a bright, flat lavender: the ordinary
	# surfaces DOMINATED the frame, and the actors sat on top of them as small
	# dark shapes. That is the exact opposite of the direction the owner
	# validated -- "ordinary surfaces stay visually quiet; identity concentrates
	# in characters, monsters, Skills, VFX and UI".
	#
	# The cause was not the palette, the ambient or the torches, all of which
	# match the accepted spike almost exactly. It was Godot's DEFAULT
	# `tonemap_white` of 1.0: with ACES, everything above 1.0 clips and the whole
	# mid-range is lifted. Restoring headroom puts the mid-range back down where
	# the accepted look has it.
	#
	# PROVISIONAL, like everything else here, and carried from the accepted
	# spike's tone response rather than re-derived -- the spike had already paid
	# for this.
	env.tonemap_exposure = 1.30
	env.tonemap_white = 5.0
	env.glow_enabled = true
	env.glow_intensity = 0.55
	env.glow_bloom = 0.10
	env.glow_hdr_threshold = 1.05
	env.glow_blend_mode = Environment.GLOW_BLEND_MODE_ADDITIVE
	env.ssao_enabled = true
	env.ssao_radius = 1.3
	env.ssao_intensity = 1.5
	we.environment = env
	add_child(we)

	var sun := DirectionalLight3D.new()
	sun.name = "Moonlight"
	sun.light_color = Color(0.62, 0.72, 1.0)
	sun.light_energy = ProdConfig.SUN_ENERGY
	sun.shadow_enabled = true
	sun.rotation_degrees = Vector3(-58, 128, 0)
	add_child(sun)

	# A dim opposing fill, so silhouettes do not go solid black on their shadow
	# side. PROVISIONAL.
	var fill := DirectionalLight3D.new()
	fill.name = "Fill"
	fill.light_color = Color(0.55, 0.62, 0.86)
	fill.light_energy = 0.34
	fill.shadow_enabled = false
	fill.rotation_degrees = Vector3(-42, -52, 0)
	add_child(fill)

# ----------------------------------------------------------------- banner ----

func _print_banner() -> void:
	print("========================================================================")
	print("RIFTWROUGHT — FIRST BOUNDED 3D PRODUCTION FOUNDATION  (%s, %s)"
		% [ProdConfig.DECISION, ProdConfig.DATE])
	print("STATE: %s" % ProdConfig.STATE)
	print("========================================================================")
	for d in ProdConfig.denials():
		print("  %s" % d)
	print("")
	print("EVERY TUNING VALUE IN THIS PROJECT REMAINS PROVISIONAL:")
	for row in ProdConfig.provisional_registry():
		print("  %-32s %-12s %s" % [row[0], str(row[1]), row[2]])
	print("")
	print("WHAT THE THIRD-PARTY CORPUS CANNOT SUPPLY (measured against all 85 clips):")
	for g in ProdConfig.CORPUS_GAPS:
		print("  %s" % g)
	print("")
	print("IMPLEMENTATION REUSED FROM THE FROZEN PROTOTYPES, DECLARED:")
	for r in ProdConfig.reuse_declaration():
		print("  %-46s <- %s" % [r[0], r[1]])
		print("      %s" % r[2])
	print("")
	print("NEW HERE — not owed by, and not discharging, any earlier phase:")
	for n in ProdConfig.new_here():
		print("  %s" % n)
	print("")
	_print_imprint_banner()
	if not required_clips_missing.is_empty():
		push_error("FOUNDATION: required clips missing: %s" % str(required_clips_missing))
	print("========================================================================")

## ============================================================================
## THE D-375 STAGE'S OWN BANNER. A SECOND REGISTRY, NOT A REPLACEMENT.
## ============================================================================
## `ProdConfig` remains the registry for the ACCEPTED baseline and NOT ONE OF ITS
## VALUES IS MODIFIED. This prints the values THIS stage introduces, its denials,
## and the canonical conflicts it MEASURED -- because a conflict recorded only in
## a document drifts away from the code that carries it.
func _print_imprint_banner() -> void:
	print("========================================================================")
	print("RIFTWROUGHT — %s  (%s, %s)"
		% [ImprintConfig.STAGE, ImprintConfig.DECISION, ImprintConfig.DATE])
	print("The FOUNDATION STAGE is ACCEPTED and CLOSED (D-373). THIS STAGE IS SEPARATE,")
	print("and it preserves that accepted baseline: no accepted value is modified.")
	print("========================================================================")
	for d in ImprintConfig.denials():
		print("  %s" % d)
	print("")
	print("CANONICAL VALUES — NOT this stage's to choose, each with its citation:")
	for row in ImprintConfig.canonical_registry():
		print("  %-38s %-6s %s" % [row[0], str(row[1]), row[2]])
	print("")
	print("MEASURED CANONICAL CONFLICTS — reported, and NOT silently resolved:")
	for c in ImprintConfig.declared_conflicts():
		print("  %s  %s" % [c[0], c[1]])
		print("      %s" % c[2])
	print("")
	print("EVERY VALUE THIS STAGE INTRODUCES IS PROVISIONAL:")
	for row in ImprintConfig.provisional_registry():
		print("  %-40s %-10s %s" % [row[0], str(row[1]), row[2]])
	print("")
	print("DECLARED TAG EXTENSION — canon uses it as a category but never lists it as a tag:")
	for row in ImprintConfig.DECLARED_TAG_EXTENSIONS:
		print("  %-12s %s" % [row[0], row[1]])
	print("")
	print("REUSED FROM THE ACCEPTED BASELINE, DECLARED TRUTHFULLY:")
	for r in ImprintConfig.reuse_declaration():
		print("  %-58s <- %s" % [r[0], r[1]])
		print("      %s" % r[2])
	print("")
	print("NEW IN THIS STAGE — not owed by, and not discharging, any earlier phase:")
	for n in ImprintConfig.new_here():
		print("  %s" % n)
	print("")
	if skills != null:
		var lo := skills.loadout
		# D-380: this line printed "(PROVISIONAL CANDIDATE cap 6)" and "of a
		# PROVISIONAL CANDIDATE 4" from D-375 until D-380. Both caps are gone.
		print("LOADOUT AT START-UP: %d CANONICAL active bindings, %d holding a Configuration "
			% [lo.binding_count(), lo.equipped_active_count()]
			+ "(UP TO %d, ONE PER BINDING — a CURRENT WORKING BASELINE, no separate cap), "
			% lo.binding_count()
			+ "%d Persistent (NO arbitrary slot cap)." % lo.active_persistent_ids().size())
		print("  EIGHT BINDINGS ARE PRESERVED AND ARE NOT REWRITTEN INTO SIX.")
		for line in lo.last_report:
			print("  %s" % line)
	print("========================================================================")
	_print_alignment_banner()

## ============================================================================
## THE D-380 D-378 ALIGNMENT STAGE'S OWN BANNER.
## ============================================================================
## The map of every D-378 ruling to exactly one of four dispositions, the rules
## that changed, what is declared a working baseline, and the stage's denials.
## THE MAP LINES ARE MACHINE-READ: the D-380 runner compares them row for row
## with docs/testing/D380_ALIGNMENT_OWED_CRITERIA_INVENTORY.md section 3.
func _print_alignment_banner() -> void:
	print("RIFTWROUGHT — %s  (%s, %s)"
		% [ImprintConfig.ALIGNMENT_STAGE, ImprintConfig.ALIGNMENT_DECISION,
		   ImprintConfig.ALIGNMENT_DATE])
	print("The Imprint architecture is canon since D-376. This stage ALIGNS its runtime with")
	print("the owner's D-378 rulings. It is NOT Huntress implementation and NOT tuning.")
	print("========================================================================")
	for d in ImprintConfig.alignment_denials():
		print("  %s" % d)
	print("")
	print("%s (%s; amended by %s) — inside the D-380 stage, which stays DELIVERED and OPEN:"
		% [ImprintConfig.REVIEW_CORRECTION, ImprintConfig.REVIEW_CORRECTION_DECISION,
		   ImprintConfig.HEALTH_RESERVATION_DECISION])
	for d in ImprintConfig.reviewability_denials():
		print("  %s" % d)
	print("")
	print("THE D-378 MAP — every ruling, in exactly one of four dispositions:")
	for row in ImprintConfig.d378_alignment():
		print("  [D378-MAP] %s = %s :: %s" % [row[0], row[1], row[2]])
		print("      %s" % row[3])
	print("")
	print("WHAT CHANGED IN THE RUNTIME — before -> after:")
	for c in ImprintConfig.alignment_changes():
		print("  %-20s %s" % [c[0], c[1]])
		print("  %-20s -> %s" % ["", c[2]])
	print("")
	print("CURRENT WORKING BASELINES — kept apart from canon AND from tunable numbers:")
	for row in ImprintConfig.working_baseline_registry():
		print("  %-32s %s" % [row[0], row[1]])
		print("      %s" % row[2])
	print("========================================================================")
	_print_huntress_banner()

## ============================================================================
## THE D-392 HUNTRESS SPLINTER SHOT STAGE'S OWN BANNER.
## ============================================================================
func _print_huntress_banner() -> void:
	print("RIFTWROUGHT — %s  (%s, %s)"
		% [HuntressConfig.STAGE, HuntressConfig.DECISION, HuntressConfig.DATE])
	print("Splinter Shot, the Huntress's ordinary shot, through the ACCEPTED Imprint")
	print("architecture. DELIVERED and OPEN pending owner live review. It accepts nothing.")
	print("========================================================================")
	for d in HuntressConfig.denials():
		print("  %s" % d)
	print("")
	print("CANON THIS STAGE IMPLEMENTS — each cited:")
	for r in HuntressConfig.canonical_rulings():
		print("  %-22s %s — %s" % [r[0], r[1], r[2]])
	print("")
	print("THE THREE D-392 CLARIFICATIONS — RECORDED:")
	for r in HuntressConfig.clarifications():
		print("  %s %s" % [r[0], r[1]])
		print("      %s" % r[2])
	print("")
	print("EVERY VALUE THIS STAGE INTRODUCES IS PROVISIONAL:")
	for row in HuntressConfig.registry():
		print("  %-46s %-12s %s" % [row[0], str(row[1]), row[2]])
	print("")
	print("PORTED OR REUSED, DECLARED TRUTHFULLY:")
	for r in HuntressConfig.reuse_declaration():
		print("  %-58s <- %s" % [r[0], r[1]])
		print("      %s" % r[2])
	print("")
	print("NEW IN THIS STAGE — not owed by, and not discharging, any earlier phase:")
	for n in HuntressConfig.new_here():
		print("  %s" % n)
	print("")
	print("%s" % HuntressConfig.ANIMATION_LABEL)
	print("%s" % HuntressConfig.PRESENTATION_LABEL)
	if huntress != null:
		print("SPLINTER SHOT: binding %d · learned at rank %d / %.0f XP · %d combat entities registered in the area · built=%s"
			% [HuntressContent.BINDING_INDEX + 1,
			   int(skills.library.acquisition_record(HuntressContent.SKILL_SPLINTER_SHOT).get("rank", -1)),
			   float(skills.library.acquisition_record(HuntressContent.SKILL_SPLINTER_SHOT).get("xp", -1.0)),
			   huntress.registry.count(), str(huntress.setup_ok)])
	print("========================================================================")
	_print_hounds_banner()

## ============================================================================
## THE D-396 KINDRED HOUNDS STAGE'S OWN BANNER.
## ============================================================================
## It prints NO row and NO state line: rows belong to the D-396 suite's report,
## and the one state line is printed once, above.
func _print_hounds_banner() -> void:
	print("RIFTWROUGHT — %s  (%s, %s)" % [HoundConfig.STAGE, HoundConfig.DECISION, HoundConfig.DATE])
	print("Kindred Hounds, a canonical Persistent Skill Imprint, through the ACCEPTED Imprint")
	print("architecture. DELIVERED and OPEN pending owner live review. It accepts nothing.")
	print("========================================================================")
	for d in HoundConfig.denials():
		print("  %s" % d)
	print("")
	print("CANON THIS STAGE IMPLEMENTS — each cited:")
	for r in HoundConfig.canonical_rulings():
		print("  %-14s %s — %s" % [r[0], r[1], r[2]])
	print("")
	print("EVERY VALUE THIS STAGE INTRODUCES IS PROVISIONAL:")
	for row in HoundConfig.registry():
		print("  %-46s %-8s %s" % [row[0], str(row[1]), row[2]])
	print("")
	print("REUSED OR INFORMING, DECLARED TRUTHFULLY:")
	for r in HoundConfig.reuse_declaration():
		print("  %s <- %s" % [r[0], r[1]])
		print("      %s" % r[2])
	print("")
	print("NEW IN THIS STAGE — not owed by, and not discharging, any earlier phase:")
	for n in HoundConfig.new_here():
		print("  %s" % n)
	print("")
	print("%s" % HoundConfig.STAND_IN_LABEL)
	if hounds != null:
		var m: Dictionary = hounds.review_measure
		print("%s" % HoundConfig.REVIEW_LOADOUT_LABEL)
		if not m.is_empty():
			print("  MEASURED BEFORE: %d / %d Capacity, bindings %s, Persistent %s"
				% [int(m["before"]["used"]), int(m["before"]["total"]), str(m["before"]["bindings"]),
				   str(m["before"]["persistent"])])
			print("  REVIEW LOADOUT:  %d / %d Capacity, bindings %s, Persistent %s — Capacity NOT increased"
				% [int(m["after"]["used"]), int(m["after"]["total"]), str(m["after"]["bindings"]),
				   str(m["after"]["persistent"])])
		print("KINDRED HOUNDS: learned at rank %d / %.0f XP · %d hounds · Persistent %s · built=%s"
			% [int(skills.library.acquisition_record(HoundContent.SKILL_KINDRED_HOUNDS).get("rank", -1)),
			   float(skills.library.acquisition_record(HoundContent.SKILL_KINDRED_HOUNDS).get("xp", -1.0)),
			   hounds.pack.size(), String(hounds.persistent_state()["state"]), str(hounds.setup_ok)])
	print("========================================================================")
	_print_cohort_banner()

## ============================================================================
## THE D-398 MOBILE MINION COHESION STAGE'S OWN BANNER.
## ============================================================================
## Like the D-396 banner it prints NO row and NO state line.
func _print_cohort_banner() -> void:
	print("RIFTWROUGHT — %s  (%s, %s)" % [CohortConfig.STAGE, CohortConfig.DECISION, CohortConfig.DATE])
	print("A shared mobile-minion cohort with Kindred Hounds as its only production consumer.")
	print("DELIVERED and OPEN pending owner live review. It accepts nothing.")
	print("========================================================================")
	for d in CohortConfig.denials():
		print("  %s" % d)
	print("")
	print("THE OWNER'S TWELVE ITEMS — each with its disposition:")
	for r in CohortConfig.canonical_rulings():
		print("  %-14s %s — %s" % [r[0], r[1], r[2]])
	print("")
	print("%s" % CohortConfig.REGROUP_READING)
	print("")
	print("EVERY VALUE THIS STAGE INTRODUCES IS PROVISIONAL:")
	for row in CohortConfig.registry():
		print("  %-46s %-8s %s" % [row[0], str(row[1]), row[2]])
	print("")
	print("THE ACCEPTED D-396 VALUES — used, or superseded, declared:")
	for r in CohortConfig.d396_values_declaration():
		print("  %s — %s" % [r[0], r[1]])
	print("")
	print("REUSED, DECLARED TRUTHFULLY:")
	for r in CohortConfig.reuse_declaration():
		print("  %s <- %s" % [r[0], r[1]])
		print("      %s" % r[2])
	print("")
	print("NEW IN THIS STAGE — not owed by, and not discharging, any earlier phase:")
	for n in CohortConfig.new_here():
		print("  %s" % n)
	if hounds != null and hounds.cohort != null:
		print("COHORT: %s profile · %d members ranked by combat-entity ID · DIAGNOSTIC population %d, speed %s"
			% [hounds.cohort.profile.profile_name, hounds.cohort.size(),
			   cohort_diagnostics.population() if cohort_diagnostics != null else -1,
			   cohort_diagnostics.speed_name() if cohort_diagnostics != null else "-"])
	print("========================================================================")
	_print_locomotion_banner()
	_print_cinder_banner()
	_print_direct_click_banner()

## ============================================================================
## THE D-400 PLAYER LOCOMOTION REDIRECTION STAGE'S OWN BANNER.
## ============================================================================
## Like the D-396 and D-398 banners it prints NO row and NO state line, so
## nothing of this stage leaks into an accepted suite's log.
func _print_locomotion_banner() -> void:
	print("RIFTWROUGHT — %s  (%s, %s)"
		% [LocomotionConfig.STAGE, LocomotionConfig.DECISION, LocomotionConfig.DATE])
	print("Ground movement with scalar speed and NO directional inertia: the horizontal velocity is")
	print("redirected onto a new navigation, path or stick direction in the SAME physics frame, the")
	print("scalar speed preserved and clamped to the current allowed maximum.")
	print("DELIVERED and OPEN pending owner live review. It accepts nothing.")
	print("========================================================================")
	for d in LocomotionConfig.denials():
		print("  %s" % d)
	print("")
	print("THE OWNER'S ELEVEN ITEMS — each with its disposition:")
	for r in LocomotionConfig.canonical_rulings():
		print("  %-14s %s — %s" % [r[0], r[1], r[2]])
	print("")
	print("THIS STAGE INTRODUCES TWO NUMBERS AND DERIVES EVERYTHING ELSE. BOTH ARE PROVISIONAL:")
	for row in LocomotionConfig.registry():
		print("  %-32s %-10s %s" % [row[0], str(row[1]), row[2]])
	print("")
	print("THE RATES, AT EACH DIAGNOSTIC MAXIMUM — derived, never locked:")
	for m in CohortConfig.speed_modes():
		var t: float = ProdConfig.TOP_SPEED_MPS * float(m[1])
		print("  %-9s max %7.4f m/s · scale %5.3f · acceleration %7.3f · ordinary braking %7.3f m/s^2"
			% [String(m[0]), t, GroundMotion.rate_scale(t), GroundMotion.accel_rate(t), GroundMotion.brake_rate(t)])
	print("  The ACTION brake stays the ACCEPTED %.1f m/s^2 and is NOT scaled (LD-02)."
		% ProdConfig.ACTION_BRAKE_MPS2)
	print("")
	print("REUSED, DECLARED TRUTHFULLY:")
	for r in LocomotionConfig.reuse_declaration():
		print("  %s <- %s" % [r[0], r[1]])
		print("      %s" % r[2])
	print("")
	print("NEW IN THIS STAGE — not owed by, and not discharging, any earlier phase:")
	for n in LocomotionConfig.new_here():
		print("  %s" % n)
	print("========================================================================")

## ============================================================================
## THE D-402 BANNER. It prints NO deferred row, NO owed row and NO STATE line.
## ============================================================================
## The accepted suites instantiate the scene, so anything this prints lands in
## THEIR logs too. A row printed here would leak a D-402 claim into an accepted
## run, and the state line is printed by the suites themselves -- exactly the
## rule every earlier stage's banner follows.
func _print_cinder_banner() -> void:
	print("RIFTWROUGHT — %s  (%s, %s)"
		% [CinderConfig.STAGE, CinderConfig.DECISION, CinderConfig.DATE])
	print("ONE canonical ACTIVE Skill Imprint: Cinder Field, a ground-targeted Fire SPELL delivered")
	print("as a TRAP. It lies dormant, arms, and erupts ONCE into an initial Fire HIT and a lingering,")
	print("NON-STACKING burning GROUND. The eruption is a DELAYED COMPONENT of the original Skill Use.")
	print("DELIVERED and OPEN pending owner live review. It accepts nothing.")
	print("========================================================================")
	for d in CinderConfig.denials():
		print("  %s" % d)
	print("")
	print("THE CANONICAL RULES IT IMPLEMENTS — each cited:")
	for r in CinderConfig.canonical_rulings():
		print("  %-30s %s" % [r[0], r[1]])
		print("      -> %s" % r[2])
	print("")
	print("CANON'S DECLARATIONS FOR A DURATION / GROUND EFFECT:")
	var contract := CinderConfig.duration_contract()
	for k in contract.keys():
		print("  %-26s %s" % [String(k), String(contract[k])])
	print("")
	print("COMPONENT TAGS — verbatim, in canon's order:")
	print("  base      %s" % str(CinderConfig.BASE_TAGS))
	print("  eruption  %s" % str(CinderConfig.ERUPTION_TAGS))
	print("  ground    %s" % str(CinderConfig.GROUND_TAGS))
	print("")
	print("EVERY VALUE THIS STAGE INTRODUCES IS A PROVISIONAL REVIEW CANDIDATE:")
	for row in CinderConfig.registry():
		print("  %-46s %-10s %s" % [row[0], str(row[1]), row[2]])
	print("")
	print("  %s" % CinderConfig.TRAP_PLACEHOLDER_LABEL)
	print("  %s" % CinderConfig.VFX_PLACEHOLDER_LABEL)
	print("")
	print("REUSED, DECLARED TRUTHFULLY:")
	for r in CinderConfig.reuse_declaration():
		print("  %s <- %s" % [r[0], r[1]])
		print("      %s" % r[2])
	print("")
	print("NEW IN THIS STAGE — not owed by, and not discharging, any earlier phase:")
	for n in CinderConfig.new_here():
		print("  %s" % n)
	print("========================================================================")


## ============================================================================
## THE D-404 BANNER. It prints NO deferred row, NO owed row and NO STATE line.
## ============================================================================
## The accepted suites instantiate the scene, so anything printed here lands in
## THEIR logs too -- exactly the rule every earlier stage's banner follows.
func _print_direct_click_banner() -> void:
	print("RIFTWROUGHT — %s  (%s, %s)"
		% [DirectClickConfig.STAGE, DirectClickConfig.DECISION, DirectClickConfig.DATE])
	print("A MOUSE order goes STRAIGHT at the clicked ground point, unsnapped, and asks navigation for")
	print("nothing. The first blocker ends it: no slide, no reroute, no tunnelling. The stick, enemies,")
	print("hounds and the cohort are unchanged. Going round an obstacle takes another click.")
	print("DELIVERED and OPEN pending owner live review. It accepts nothing.")
	print("========================================================================")
	for d in DirectClickConfig.denials():
		print("  %s" % d)
	print("")
	print("THE OWNER'S SEVENTEEN ITEMS — each with its disposition:")
	for r in DirectClickConfig.canonical_rulings():
		print("  %-14s %s — %s" % [r[0], r[1], r[2]])
	print("")
	print("ACCEPTED D-400 CLAUSES THIS STAGE SUPERSEDES — FOR CLICK ORDERS ONLY, declared:")
	for r in DirectClickConfig.supersedes():
		print("  %-14s %s -> %s" % [r[0], r[1], r[2]])
	print("")
	print("THIS STAGE INTRODUCES THREE NUMBERS AND ONE STRUCTURAL BOUND. EVERY ONE IS PROVISIONAL:")
	for row in DirectClickConfig.registry():
		print("  %-30s %-8s %s" % [row[0], str(row[1]), row[2]])
	print("")
	print("REUSED, DECLARED TRUTHFULLY:")
	for r in DirectClickConfig.reuse_declaration():
		print("  %s <- %s" % [r[0], r[1]])
		print("      %s" % r[2])
	print("")
	print("NEW IN THIS STAGE — not owed by, and not discharging, any earlier phase:")
	for n in DirectClickConfig.new_here():
		print("  %s" % n)
	print("========================================================================")


# ---------------------------------------------------------------- capture ----

func _cli(prefix: String, fallback: String) -> String:
	for a in OS.get_cmdline_user_args():
		if a.begins_with(prefix):
			return a.substr(prefix.length())
	return fallback

func _maybe_capture() -> void:
	var mode := _cli("--capture=", "")
	if mode == "":
		return
	var out := _cli("--out=", "res://evidence/capture.png")
	var wait := int(_cli("--wait=", "90"))
	_run_capture(mode, out, wait)

func _run_capture(mode: String, out: String, wait: int) -> void:
	# THE OVERLAY IS DISABLED FOR EVERY CAPTURE. The ruling asks for an overlay
	# "that can be disabled for visual review"; an evidence frame with a debug
	# panel over it is not a visual review of the game.
	hud.set_enabled(false)
	# THE D-375 LOADOUT PANEL IS DISABLED TOO -- except in the one capture whose
	# SUBJECT is the panel. RENDER THE EVIDENCE AND LOOK AT IT: a live-review
	# surface nobody has looked at is not a live-review surface, and three of the
	# four defects D-370 found by looking were invisible to every check.
	if imprint_panel != null:
		imprint_panel.set_enabled(mode == "panel")
		# D-380: the two D-378 alignment captures are ALSO about the panel -- the
		# aligned overview and the new D-378 ALIGNMENT page. The line above is
		# kept exactly as accepted; these modes are added beside it.
		if mode == "d378_overview" or mode == "d378_alignment":
			imprint_panel.set_enabled(true)
			imprint_panel.page = LoadoutPanel.PAGES.find(
				"D-378 ALIGNMENT" if mode == "d378_alignment" else "OVERVIEW")
			imprint_panel.refresh()
	# D-381: THE REVIEW HUD is shown ONLY in the three captures whose subject it
	# is, so every earlier evidence frame renders exactly as it was accepted. The
	# F1 overlay stays DISABLED in these too, as in every evidence capture -- the
	# accepted foundation suite states exactly that (F57). The launch composition,
	# overlay on and HUD beside it, is MEASURED by the D-380 suite (A30) instead.
	var d381 := mode.begins_with("d381_hud_")
	if review_hud != null:
		review_hud.set_enabled(d381)
	# D-392: the Splinter Shot HUD is shown ONLY in this stage's own captures, so
	# every earlier evidence frame's composition stays as it was accepted.
	var d392 := mode.begins_with("d392_")
	if huntress_hud != null:
		huntress_hud.set_enabled(d392)
	# D-396: the Kindred Hounds HUD is shown ONLY in this stage's own captures --
	# and every EARLIER capture restores the ACCEPTED D-392 loadout first, so no
	# hound walks into an accepted frame and each still renders as it was accepted.
	var d396 := mode.begins_with("d396_")
	# D-398: its own captures show the cohesion HUD beside the D-392 and D-396 ones
	# -- the launch composition -- and every EARLIER capture still restores the
	# ACCEPTED D-392 loadout first, exactly as before.
	var d398 := mode.begins_with("d398_")
	# D-400: its own captures keep the ACCEPTED D-398 launch composition exactly --
	# this stage adds NO surface -- and every EARLIER capture still restores the
	# ACCEPTED D-392 loadout first, so each still renders as it was accepted.
	var d400 := mode.begins_with("d400_")
	# D-402: its own captures show the LAUNCH composition -- the D-392, D-396,
	# D-398 and D-402 HUDs together, F1 and F2 hidden -- and every EARLIER capture
	# still restores the ACCEPTED D-392 loadout first, which UNBINDS Cinder Field
	# by the same rule every removal follows. So no trap, no burning ground and no
	# new HUD walks into an accepted frame, and each still renders as accepted.
	var d402 := mode.begins_with("d402_")
	# D-404: its own captures show the LAUNCH composition -- every review HUD,
	# the direct-click HUD and its world markers, F1 and F2 hidden -- and every
	# EARLIER capture hides the new HUD and markers, and still restores the
	# ACCEPTED D-392 loadout first, so each still renders as it was accepted.
	var d404 := mode.begins_with("d404_")
	if hounds_hud != null:
		hounds_hud.set_enabled(d396 or d398 or d400 or d402 or d404)
	if (d396 or d398 or d400 or d402 or d404) and huntress_hud != null:
		huntress_hud.set_enabled(true)
	if cohort_hud != null:
		cohort_hud.set_enabled(d398 or d400 or d402 or d404)
	if cinder_hud != null:
		cinder_hud.set_enabled(d402 or d404)
	if click_hud != null:
		click_hud.set_enabled(d404)
	if not d396 and not d398 and not d400 and not d402 and not d404 and hounds != null:
		hounds.restore_accepted_d392_loadout()

	match mode:
		"arena":
			player.global_position = Vector3(-10, 0, 0)
		"combat":
			player.global_position = Vector3(-10, 0, -1)
			enemies[0].global_position = Vector3(-8.2, 0, -2.2)
			enemies[1].global_position = Vector3(-8.6, 0, 1.4)
			enemies[2].global_position = Vector3(-11.5, 0, -3.0)
		"telegraph":
			player.global_position = Vector3(-10, 0, 0)
			enemies[0].global_position = Vector3(-8.6, 0, 0.0)
			enemies[1].debug_freeze_ai = true
			enemies[2].debug_freeze_ai = true
		"doorway":
			player.global_position = Vector3(-1.5, 0, 0)
			enemies[3].global_position = Vector3(4.5, 0, 0)
		"commit":
			# THE COMMITTED ACTION, captured deterministically.
			#
			# A still frame cannot show the ABSENCE of a glide, so what this
			# capture shows is the other half of the policy: the actor stopped,
			# mid-action, FACING its sampled aim while an enemy stands off to one
			# side. The absence of the glide is measured, not photographed —
			# check F71 reports the distance.
			player.global_position = Vector3(-10, 0, 0)
			enemies[0].global_position = Vector3(-6.4, 0, -2.4)
			enemies[0].debug_freeze_ai = true
			enemies[1].debug_freeze_ai = true
			enemies[2].debug_freeze_ai = true
		"death":
			player.global_position = Vector3(-10, 0, 0)
			enemies[0].global_position = Vector3(-8.0, 0, -1.0)
			enemies[1].debug_freeze_ai = true
			enemies[2].debug_freeze_ai = true
		"panel", "imprint_volley", "imprint_ballista", "imprint_beasts", "d378_overview", "d378_alignment", \
				"d381_hud_mana", "d381_hud_life", "d381_hud_off":
			# THE D-375 CAPTURES. The enemies are frozen where they stand so the
			# frame shows the BUILD rather than whatever the AI happened to do.
			player.global_position = Vector3(-10, 0, 0)
			enemies[0].global_position = Vector3(-5.6, 0, -1.2)
			enemies[1].global_position = Vector3(-6.2, 0, 1.8)
			enemies[2].global_position = Vector3(-12.6, 0, -3.4)
			for e in enemies:
				e.debug_freeze_ai = true
		"d392_launch", "d392_draw_gameplay", "d392_draw_closeup", "d392_release_gameplay", \
				"d392_release_closeup", "d392_overlap":
			_d392_stage(mode)
		"d396_launch", "d396_following", "d396_acquisition", "d396_retention", "d396_leash_return", \
				"d396_bite", "d396_fallen", "d396_recovered":
			_d396_stage(mode)
		"d398_launch", "d398_pop2_travel", "d398_pop6_travel", "d398_pop10_travel", "d398_pop15_travel", \
				"d398_pop15_doorway", "d398_pop15_regroup", "d398_pop15_attack":
			_d398_stage(mode)
		"d400_launch", "d400_reversal_ordinary", "d400_reversal_extreme", "d400_corner_extreme", \
				"d400_arrival_extreme", "d400_doorway_fast":
			_d400_stage(mode)
		"d402_launch", "d402_placement", "d402_armed", "d402_eruption", "d402_burning_ground", \
				"d402_multi_hit", "d402_overlap", "d402_replacement", "d402_expiry":
			_d402_stage(mode)
		"d404_unobstructed", "d404_behind_wall", "d404_stopped_at_wall", "d404_glancing", \
				"d404_manual_around", "d404_extreme":
			_d404_stage(mode)
		_:
			player.global_position = Vector3(-10, 0, 0)

	cam.snap_to_target()
	await _frames(wait)

	if d392:
		var ok := await _d392_capture(mode)
		if not ok:
			push_error("CAPTURE %s: the live state did NOT reach what the frame's name claims — refusing to save" % mode)
			get_tree().quit(1)
			return

	if d396:
		var ok396 := await _d396_capture(mode)
		if not ok396:
			push_error("CAPTURE %s: the live state did NOT reach what the frame's name claims — refusing to save" % mode)
			get_tree().quit(1)
			return

	if d398:
		var ok398 := await _d398_capture(mode)
		if not ok398:
			push_error("CAPTURE %s: the live state did NOT reach what the frame's name claims — refusing to save" % mode)
			get_tree().quit(1)
			return

	if d400:
		var ok399 := await _d400_capture(mode)
		if not ok399:
			push_error("CAPTURE %s: the live state did NOT reach what the frame's name claims — refusing to save" % mode)
			get_tree().quit(1)
			return

	if d402:
		var ok402 := await _d402_capture(mode)
		if not ok402:
			push_error("CAPTURE %s: the live state did NOT reach what the frame's name claims — refusing to save" % mode)
			get_tree().quit(1)
			return

	if d404:
		var ok404 := await _d404_capture(mode)
		if not ok404:
			push_error("CAPTURE %s: the live state did NOT reach what the frame's name claims — refusing to save" % mode)
			get_tree().quit(1)
			return

	if mode == "commit":
		# Drive the actor at full speed, then commit — and hold the frame at the
		# release marker, where the feet are already stopped.
		cam.debug_cursor_override = enemies[0].global_position
		player.intent.debug_move_axis = Vector2(1.0, 0.0)
		await _frames(40)
		player._cooldown = 0.0
		player.begin_attack()
		var g := 0
		while g < 200 and player.commitment.phase() != "recovery":
			await get_tree().physics_frame
			g += 1
		player.debug_freeze_attack = true
		await _frames(2)

	if mode == "telegraph":
		# WAIT FOR THE STATE, DO NOT HOPE FOR IT. A fixed frame count landed
		# wherever the cycle happened to be, and the first "telegraph" capture
		# contained no telegraph at all -- a picture that proved nothing, which
		# only looking at it revealed.
		var guard := 0
		while guard < 600 and not (enemies[0].state == OrdinaryEnemy.State.WINDUP
				and enemies[0].telegraph.progress >= 0.75):
			await get_tree().physics_frame
			guard += 1
		enemies[0].debug_freeze_ai = true
		await _frames(2)

	if mode == "death":
		enemies[0].receive_damage(ProdConfig.ENEMY_HEALTH + 1.0, player.global_position)
		await _frames(26)

	if mode == "imprint_volley" or mode == "imprint_ballista" or mode == "imprint_beasts":
		# Drive ONE Skill Use of the build being photographed, deterministically,
		# and hold the frame while its effect is on screen.
		var binding := 0
		match mode:
			"imprint_ballista": binding = 1
			"imprint_beasts": binding = 2
		# ====================================================================
		# HOLD THE FRAME WHERE THE EFFECT IS, NOT WHERE THE ACTION ENDS.
		# ====================================================================
		# The first version waited for the whole action and then ten more frames.
		# By then the volley had travelled fourteen metres and resolved, and the
		# capture showed an empty arena -- A PICTURE THAT PROVED NOTHING, which
		# is the same mistake D-370's first telegraph capture made. So each
		# capture now waits for the RELEASE and then holds for as long as its
		# own effect needs to be visible.
		# THE BALLISTA IS AIMED AT CLEAR FLOOR, DELIBERATELY, AND NOT AT A TARGET.
		# Placed exactly ON the enemy, the emplacement HID IT. Placed on the line
		# between them, it clipped into the interior blocker wall. Both frames
		# showed one thing standing inside another, which is not a picture of an
		# autonomous emplacement engaging a target. So it is placed on open floor
		# on the player's own side of the wall, with a DIFFERENT enemy inside its
		# acquisition range.
		var aim_at: Vector3 = (enemies[0] as Node3D).global_position
		if mode == "imprint_ballista":
			aim_at = Vector3(-11.4, 0.0, -2.4)
		cam.debug_cursor_override = aim_at
		await _phys_frames(6)
		skills.pool.refill()
		skills.clear_cooldowns()
		var releases_before := skills.releases
		var used := skills.use_binding(binding)
		if not used["ok"]:
			push_error("CAPTURE: binding %d refused: %s" % [binding + 1, used["reason"]])
		var guard := 0
		while guard < 240 and skills.releases == releases_before:
			await get_tree().physics_frame
			guard += 1
		# EIGHT FRAMES for the volley: at 26 m/s that is 3.5 m of flight, so the
		# three projectiles have FANNED APART and are still SHORT of the target
		# they would otherwise have resolved against. The additional-projectile
		# behaviour is the thing being photographed, so the frame has to be held
		# where it is visible.
		var hold := 8
		if mode == "imprint_ballista":
			hold = 64
		elif mode == "imprint_beasts":
			hold = 150
		await _phys_frames(hold)
		cam.debug_cursor_override = null

	if d381:
		# THE THREE RESERVATION STATES, each reached through the SAME live cycle
		# the new input drives -- never by writing a display value. The launch
		# state is MANA RESERVATION; one Skill Use first spends some Mana, so the
		# bar shows current, the empty usable remainder and the hatched reserve.
		var targets := {"d381_hud_mana": "MANA RESERVATION", "d381_hud_life": "LIFE CONVERSION",
			"d381_hud_off": "OFF"}
		var guard := 0
		while guard < 3 and skills.reservation_state() != String(targets[mode]):
			skills.cycle_reservation_state()
			guard += 1
		skills.pool.refill()
		skills.clear_cooldowns()
		cam.debug_cursor_override = (enemies[0] as Node3D).global_position
		await _phys_frames(4)
		var used := skills.use_binding(0)
		if not used["ok"]:
			push_error("CAPTURE: binding 1 refused: %s" % used["reason"])
		await _phys_frames(30)
		cam.debug_cursor_override = null
		review_hud.refresh()
		await _frames(2)

	await RenderingServer.frame_post_draw
	var img := get_viewport().get_texture().get_image()
	img.save_png(out)
	print("CAPTURE: %s -> %s (%dx%d, overlay disabled)"
		% [mode, out, img.get_width(), img.get_height()])
	get_tree().quit(0)

func _frames(n: int) -> void:
	for i in n:
		await get_tree().process_frame

func _phys_frames(n: int) -> void:
	for i in n:
		await get_tree().physics_frame

# ------------------------------------------------------- D-392 captures ----

## Screen-right on the ground plane, from the LOCKED camera -- so a draw is seen
## in profile from the string-hand side rather than guessed at.
func _screen_right() -> Vector3:
	var b := cam.locked_basis()
	var r := b.x
	r.y = 0.0
	return r.normalized()

func _screen_up() -> Vector3:
	var b := cam.locked_basis()
	var f := -b.z
	f.y = 0.0
	return f.normalized()

## Places the scene for one D-392 capture. Every enemy is FROZEN where it stands,
## so the frame shows the Skill and not whatever the AI happened to do.
func _d392_stage(mode: String) -> void:
	# THE WEST CHAMBER'S SOUTH HALF, AIMING SCREEN-RIGHT: a lane MEASURED clear of
	# world geometry (a shape cast against the blockers) -- the first probe
	# placed the target behind the interior blocker, and the arrow correctly
	# stopped at the wall. `_d392_lane_clear()` re-checks it before any shot.
	player.global_position = Vector3(-10, 0, 7)
	for e in enemies:
		e.debug_freeze_ai = true
	var right := _screen_right()
	var up := _screen_up()
	var base := player.global_position
	# Park every enemy out of shot first, then place the ones the frame needs.
	for i in enemies.size():
		(enemies[i] as Node3D).global_position = Vector3(-18.0 + 1.6 * float(i), 0, -7.5)
	match mode:
		"d392_launch":
			(enemies[0] as Node3D).global_position = base + right * 5.5 + up * 1.5
			(enemies[1] as Node3D).global_position = base + right * 4.5 - up * 2.0
		"d392_draw_gameplay", "d392_draw_closeup", "d392_release_gameplay", "d392_release_closeup":
			(enemies[0] as Node3D).global_position = base + right * 6.0
		"d392_overlap":
			# TWO BODIES OVERLAPPING ON THE AIM LINE: the nearer one's time of impact
			# is earlier; the one behind must be untouched.
			(enemies[0] as Node3D).global_position = base + right * 4.6
			(enemies[1] as Node3D).global_position = base + right * 5.15 + up * 0.25

func _d392_shoot_at(target: Node3D) -> Dictionary:
	if not _d392_lane_clear(player.global_position, target.global_position):
		return {"ok": false, "reason": "the lane to the target is NOT clear of world geometry"}
	cam.debug_cursor_override = target.global_position
	await _phys_frames(4)
	skills.pool.refill()
	skills.clear_cooldowns()
	return skills.use_binding(HuntressContent.BINDING_INDEX)

## True when a 0.35 m sphere at the arrow's probe height sweeps from `a` to `b`
## without touching world geometry -- the same layer the arrow stops on.
func _d392_lane_clear(a: Vector3, b: Vector3) -> bool:
	var space := get_world_3d().direct_space_state
	var q := PhysicsShapeQueryParameters3D.new()
	var sh := SphereShape3D.new()
	sh.radius = 0.35
	q.shape = sh
	q.collision_mask = 4
	q.transform = Transform3D(Basis.IDENTITY, Vector3(a.x, HuntressConfig.WALL_PROBE_HEIGHT_M, a.z))
	if not space.intersect_shape(q, 1).is_empty():
		return false
	q.motion = Vector3(b.x - a.x, 0.0, b.z - a.z)
	var r := space.cast_motion(q)
	return r.size() == 2 and float(r[1]) >= 1.0

## Drives the frame's state and WAITS FOR IT. Returns false -- and the frame is
## NOT saved -- if the live state never matches the frame's name.
func _d392_capture(mode: String) -> bool:
	var closeup := mode.ends_with("_closeup")
	var ok := true
	match mode:
		"d392_launch":
			await _frames(4)
			ok = not hud.enabled and not imprint_panel.enabled and huntress_hud.enabled \
				and not review_hud.enabled
		"d392_draw_gameplay", "d392_draw_closeup":
			var r := await _d392_shoot_at(enemies[0])
			var g := 0
			while g < 240 and not (huntress.animator.phase == "HOLD" and huntress.animator.pres.drawn):
				await get_tree().physics_frame
				g += 1
			ok = bool(r.get("ok", false)) and huntress.animator.phase == "HOLD" \
				and huntress.animator.pres.arrow_visible
		"d392_release_gameplay", "d392_release_closeup":
			var r2 := await _d392_shoot_at(enemies[0])
			var g2 := 0
			while g2 < 240 and huntress.arrows_released < 1:
				await get_tree().physics_frame
				g2 += 1
			ok = bool(r2.get("ok", false)) and huntress.arrows_released == 1 \
				and huntress.animator.released and not huntress.animator.pres.drawn
		"d392_overlap":
			var r5 := await _d392_shoot_at(enemies[1])
			var g6 := 0
			while g6 < 300 and String(huntress.last_outcome.get("outcome", "")) == "":
				await get_tree().physics_frame
				g6 += 1
			ok = bool(r5.get("ok", false)) and String(huntress.last_outcome.get("outcome", "")) == "hit" \
				and String(huntress.last_outcome.get("id", "")) == huntress.registry.id_of(enemies[0])
			await _phys_frames(3)
		_:
			# An unknown D-392 capture is REFUSED: a frame must never be saved under a
			# name no state was driven to (the Prey frames were removed under D-393).
			ok = false
	cam.debug_cursor_override = null
	if closeup:
		# A CAPTURE-ONLY CAMERA, the SAME locked isometric orientation the owner
		# plays with, zoomed onto her -- a close-up of what the owner sees, never a
		# second gameplay view. It exists only in this capture process.
		var cc := Camera3D.new()
		cc.name = "D392_CaptureCloseup"
		cc.projection = Camera3D.PROJECTION_ORTHOGONAL
		cc.size = 3.2
		add_child(cc)
		var centre := player.global_position + Vector3(0, 1.05, 0)
		cc.global_transform = Transform3D(cam.locked_basis(),
			centre + cam.locked_basis().z * ProdConfig.CAM_BOOM_DISTANCE)
		cc.current = true
	get_tree().paused = true
	await _frames(3)
	print("CAPTURE %s: live state matches the frame's name=%s | last arrow %s · arrows %d · phase %s"
		% [mode, str(ok), str(huntress.last_outcome), huntress.arrows_released, huntress.animator.phase])
	return ok
# ------------------------------------------------------- D-396 captures ----

## The Huntress's review spot for the D-396 captures: the west chamber's south
## half, clear of the interior blocker, at NORMAL GAMEPLAY ZOOM (the default
## camera, never a close-up).
const D396_BASE := Vector3(-12.0, 0.0, 5.0)

## Places the scene for one D-396 capture. Every enemy is FROZEN where it stands,
## so the frame shows the pack and not whatever the AI happened to do, and parked
## out of range first -- then the frame's own enemies are placed.
func _d396_stage(mode: String) -> void:
	player.global_position = D396_BASE
	for i in enemies.size():
		var e: OrdinaryEnemy = enemies[i]
		e.debug_freeze_ai = true
		e.global_position = Vector3(8.0, 0, -6.0 + 3.0 * float(i))
	match mode:
		"d396_launch":
			# THE LAUNCH COMPOSITION: the enemies where they spawn, as the owner
			# first sees them. Only the Huntress's spot is the launch spot too.
			player.global_position = ProductionArena.player_spawn()
			for i in enemies.size():
				(enemies[i] as Node3D).global_position = [Vector3(-9, 0, -3), Vector3(-9, 0, 3),
					Vector3(-16, 0, -6), Vector3(7, 0, 0)][i]
		"d396_acquisition":
			# TWO ENEMIES, one on each hound's side: each hound's NEAREST is its own.
			(enemies[0] as Node3D).global_position = D396_BASE + Vector3(-3.5, 0, -1.0)
			(enemies[1] as Node3D).global_position = D396_BASE + Vector3(3.5, 0, -1.0)
		"d396_retention", "d396_leash_return", "d396_bite", "d396_fallen", "d396_recovered":
			(enemies[0] as Node3D).global_position = D396_BASE + Vector3(-3.5, 0, -2.5)
	# The pack starts at her side for every frame, whatever the staging moved.
	if hounds != null:
		for h in hounds.pack:
			if h != null and is_instance_valid(h):
				(h as KindredHound).global_position = hounds._spawn_point((h as KindredHound).index)

## Drives the frame's state and WAITS FOR IT. Returns false -- and the frame is
## NOT saved -- if the live state never matches the frame's name.
func _d396_capture(mode: String) -> bool:
	var ok := true
	var h1: KindredHound = hounds.pack[0] if hounds.pack.size() > 0 else null
	var h2: KindredHound = hounds.pack[1] if hounds.pack.size() > 1 else null
	var e0: Node3D = enemies[0]
	var id0 := huntress.registry.id_of(e0)
	match mode:
		"d396_launch":
			await _frames(4)
			ok = not hud.enabled and not imprint_panel.enabled and not review_hud.enabled \
				and huntress_hud.enabled and hounds_hud.enabled and hounds.pack.size() == HoundConfig.PACK_SIZE \
				and String(hounds.persistent_state()["state"]) == "ACTIVE"
		"d396_following":
			# SHE WALKS; THE PACK FOLLOWS. A click-to-move order -- the canonical
			# mouse scheme -- and the frame held while she is still moving.
			player.command_move_to(D396_BASE + Vector3(7.5, 0, 0.0))
			await _phys_frames(80)
			ok = h1 != null and h2 != null and h1.target.is_empty() and h2.target.is_empty() \
				and player.motor.speed() > 3.0 \
				and NavService.planar_distance(h1.global_position, player.global_position) < 4.0 \
				and NavService.planar_distance(h2.global_position, player.global_position) < 4.0
		"d396_acquisition":
			var g := 0
			while g < 240 and not (h1 != null and h2 != null and h1.target_id() != "" and h2.target_id() != ""
					and h1.state == KindredHound.State.BITE and h2.state == KindredHound.State.BITE):
				await get_tree().physics_frame
				g += 1
			ok = h1 != null and h2 != null and h1.target_id() != "" and h2.target_id() != "" \
				and h1.target_id() != h2.target_id()
		"d396_retention":
			# Both engage the one enemy in range; then a SECOND enemy is placed right
			# beside H1 -- nearer to it than its target -- and H1 KEEPS its target.
			var g2 := 0
			while g2 < 240 and not (h1 != null and h1.target_id() == id0 and h1.state == KindredHound.State.BITE):
				await get_tree().physics_frame
				g2 += 1
			var e1: Node3D = enemies[1]
			var side := (h1.global_position - e0.global_position)
			side.y = 0.0
			# 0.75 m: NEARER than its target (a hound bites from ~1.0 m of an enemy's
			# centre) and just clear of the hound's body -- so the frame shows a
			# nearer newcomer truly ignored. (1.3 m was not nearer; the capture
			# refused to save, as it must.)
			e1.global_position = h1.global_position + side.normalized().rotated(Vector3.UP, PI * 0.5) * 0.75
			await _phys_frames(20)
			ok = h1.target_id() == id0 and h1.reason_code == HoundTargeting.RETAINED \
				and NavService.planar_distance(h1.global_position, e1.global_position) \
					< NavService.planar_distance(h1.global_position, e0.global_position)
		"d396_leash_return":
			var g3 := 0
			while g3 < 240 and not (h1 != null and h1.target_id() == id0):
				await get_tree().physics_frame
				g3 += 1
			# SHE WALKS AWAY -- a click-to-move order -- until her target lies beyond
			# the leash; the frame is taken as the pack comes back to her.
			player.command_move_to(Vector3(-6.0, 0, 6.0))
			var g4 := 0
			while g4 < 300 and NavService.planar_distance(player.global_position, e0.global_position) <= HoundConfig.LEASH_RANGE_M + 0.6:
				await get_tree().physics_frame
				g4 += 1
			await _phys_frames(8)
			ok = h1.target.is_empty() and h1.abandon_code == HoundTargeting.ABANDONED_LEASH \
				and h1.abandon_id == id0 and h1.state == KindredHound.State.FOLLOW
		"d396_bite":
			var g5 := 0
			var bites0 := h1.bites if h1 != null else 0
			while g5 < 300 and not (h1 != null and h1.bites > bites0):
				await get_tree().physics_frame
				g5 += 1
			await _frames(3)
			ok = h1 != null and h1.bites > bites0 and h1.state == KindredHound.State.BITE
		"d396_fallen", "d396_recovered":
			await _phys_frames(30)
			var fell := hounds.diagnostic_fell_one()
			await _phys_frames(40)
			if mode == "d396_fallen":
				ok = bool(fell["ok"]) and hounds.living_count() == HoundConfig.PACK_SIZE - 1 \
					and hounds.returning_count() == 1
			else:
				var g6 := 0
				while g6 < 400 and hounds.returns < 1:
					await get_tree().physics_frame
					g6 += 1
				await _phys_frames(20)
				ok = bool(fell["ok"]) and hounds.returns >= 1 and hounds.living_count() == HoundConfig.PACK_SIZE \
					and hounds.returning_count() == 0
		_:
			# An unknown D-396 capture is REFUSED: a frame is never saved under a name
			# no state was driven to.
			ok = false
	hounds_hud.refresh()
	huntress_hud.refresh()
	get_tree().paused = true
	await _frames(3)
	print("CAPTURE %s: live state matches the frame's name=%s | pack %d living, %d returning · H1 %s %s · H2 %s %s"
		% [mode, str(ok), hounds.living_count(), hounds.returning_count(),
		   h1.state_name() if h1 != null else "-", h1.target_id() if h1 != null else "-",
		   h2.state_name() if h2 != null else "-", h2.target_id() if h2 != null else "-"])
	return ok

# =============================================================================
# D-398 — THE MOBILE MINION COHESION CAPTURES (frames 32-39)
# =============================================================================
# Each frame is STAGED on open floor, taken at the DEFAULT camera, and GATED on
# the live state its name claims -- a frame that did not reach it is not saved.
# The enemies are parked and frozen in the north-west corner unless a fight is
# the subject; in a fight the one enemy is made DURABLE (capture staging, not
# tuning: no accepted value moves) so the frame shows the fight, not a kill.
# The population and speed are set through the DIAGNOSTIC controls' own object.

const D398_LANE_A := Vector3(-11.0, 0.0, -9.0)
const D398_LANE_B := Vector3(-11.0, 0.0, 9.0)
const D398_DOOR_FROM := Vector3(-3.0, 0.0, 5.0)
const D398_DOOR_PRIME := Vector3(-3.0, 0.0, 3.0)
const D398_DOOR_TO := Vector3(8.0, 0.0, 0.0)
const D398_FIGHT_HER := Vector3(-11.0, 0.0, -6.0)
const D398_FIGHT_ENEMY := Vector3(-9.0, 0.0, -4.5)
const D398_RING_HER := Vector3(-11.0, 0.0, -2.0)
const D398_RING_ENEMY := Vector3(-11.0, 0.0, 1.5)

static func _d398_plan(mode: String) -> Array:
	match mode:
		"d398_pop2_travel":
			return [2, "ORDINARY"]
		"d398_pop6_travel":
			return [6, "FAST"]
		"d398_pop10_travel":
			return [10, "FAST"]
		"d398_pop15_travel", "d398_pop15_regroup":
			return [15, "EXTREME"]
		"d398_pop15_doorway":
			return [15, "FAST"]
		"d398_pop15_attack":
			return [15, "ORDINARY"]
	return [2, "ORDINARY"]

func _d398_stage(mode: String) -> void:
	for i in enemies.size():
		var e: OrdinaryEnemy = enemies[i]
		e.debug_freeze_ai = true
		e.global_position = Vector3(-18.2, 0, -10.3 + 0.9 * float(i))
	var plan := _d398_plan(mode)
	var lane := Vector3.ZERO
	match mode:
		"d398_launch":
			# THE LAUNCH COMPOSITION, as the owner first sees it.
			player.global_position = ProductionArena.player_spawn()
			for i in enemies.size():
				(enemies[i] as Node3D).global_position = [Vector3(-9, 0, -3), Vector3(-9, 0, 3),
					Vector3(-16, 0, -6), Vector3(7, 0, 0)][i]
		"d398_pop2_travel", "d398_pop6_travel", "d398_pop10_travel", "d398_pop15_travel":
			player.global_position = D398_LANE_A
			lane = D398_LANE_B - D398_LANE_A
		"d398_pop15_doorway":
			player.global_position = D398_DOOR_FROM
			lane = D398_DOOR_PRIME - D398_DOOR_FROM
		"d398_pop15_regroup":
			player.global_position = D398_FIGHT_HER
			(enemies[0] as Node3D).global_position = D398_FIGHT_ENEMY
			(enemies[0] as OrdinaryEnemy).life = Damageable.new(1000000.0)
		"d398_pop15_attack":
			player.global_position = D398_RING_HER
			(enemies[0] as Node3D).global_position = D398_RING_ENEMY
			(enemies[0] as OrdinaryEnemy).life = Damageable.new(1000000.0)
	cohort_diagnostics.set_speed(String(plan[1]))
	cohort_diagnostics.set_population(int(plan[0]))
	if hounds != null and hounds.cohort != null and lane != Vector3.ZERO:
		# STAGING: the formation faces the way she is about to go, as if she had
		# been travelling that way (the D-398 suite stages its lanes the same way).
		lane.y = 0.0
		hounds.cohort.heading = lane.normalized()

## The mean projection of the members onto her heading (+ is ahead of her).
func _d398_centre_ahead() -> float:
	var c := hounds.cohort
	var sum := 0.0
	var ms := hounds.members()
	for h in ms:
		var rel: Vector3 = (h as Node3D).global_position - player.global_position
		sum += rel.x * c.heading.x + rel.z * c.heading.z
	return sum / float(maxi(1, ms.size()))

func _d398_capture(mode: String) -> bool:
	var ok := true
	var c: MobileCohort = hounds.cohort if hounds != null else null
	var plan := _d398_plan(mode)
	var pop := int(plan[0])
	var speed := ProdConfig.TOP_SPEED_MPS * cohort_diagnostics.speed_scale()
	var detail := ""
	var set_ok := c != null and cohort_diagnostics.population() == pop and cohort_diagnostics.speed_name() == String(plan[1]) \
		and hounds.pack.size() == HoundConfig.PACK_SIZE and hounds.members().size() == pop
	match mode:
		"d398_launch":
			await _frames(4)
			ok = set_ok and not hud.enabled and not imprint_panel.enabled and not review_hud.enabled \
				and huntress_hud.enabled and hounds_hud.enabled and cohort_hud.enabled and hounds.stress.is_empty()
		"d398_pop2_travel", "d398_pop6_travel", "d398_pop10_travel", "d398_pop15_travel":
			# SHE WALKS THE LANE by click-to-move; the frame is held mid-lane, at speed.
			player.command_move_to(D398_LANE_B)
			var g := 0
			while g < 400 and not (player.motor.speed() >= 0.95 * speed and player.global_position.z >= 0.0):
				await get_tree().physics_frame
				g += 1
			var ahead := _d398_centre_ahead()
			ok = set_ok and player.motor.speed() >= 0.95 * speed and ahead >= 0.5
			detail = "moving %.2f m/s, the pack's centre %+.2f m ahead, furthest lag %.2f m" % [player.motor.speed(), ahead, c.furthest_lag]
		"d398_pop15_doorway":
			player.command_move_to(D398_DOOR_PRIME)
			var gp := 0
			while gp < 240 and not (player.motor.speed() < 0.05 and NavService.planar_distance(player.global_position, D398_DOOR_PRIME) < 0.6):
				await get_tree().physics_frame
				gp += 1
			await _phys_frames(10)
			var pt0 := c.passed_through_frames()
			player.command_move_to(D398_DOOR_TO)
			# THE FRAME: she is AT the doorway and the pack is streaming through it --
			# the Vanguard leads her, so most of it is through before she is.
			var g2 := 0
			var west := 0
			var east := 0
			while g2 < 400:
				await get_tree().physics_frame
				g2 += 1
				west = 0
				east = 0
				for h in hounds.members():
					if (h as Node3D).global_position.x > 1.3:
						east += 1
					else:
						west += 1
				if player.global_position.x >= -1.0 and west >= 3 and east >= 3:
					break
			ok = set_ok and player.global_position.x >= -1.0 and west >= 3 and east >= 3 and c.passed_through_frames() > pt0
			detail = "her x %.1f, %d members through and %d still west of the doorway, %d member-frames passed through" \
				% [player.global_position.x, east, west, c.passed_through_frames() - pt0]
		"d398_pop15_regroup":
			var e0: Node3D = enemies[0]
			var id0 := huntress.registry.id_of(e0)
			var g3 := 0
			var engaged := 0
			while g3 < 300 and engaged < 4:
				await get_tree().physics_frame
				g3 += 1
				engaged = 0
				for h in hounds.members():
					if (h as KindredHound).target_id() == id0:
						engaged += 1
			# SHE RUNS at EXTREME speed; the frame is held once a MAJORITY of the pack
			# is regrouping -- streaming after her, not merely starting to.
			player.command_move_to(Vector3(-11.0, 0.0, 9.3))
			var g4 := 0
			while g4 < 240 and not (c.count_in(MobileCohort.Mode.REGROUP) > pop / 2 and player.motor.speed() >= 0.9 * speed):
				await get_tree().physics_frame
				g4 += 1
			var holding := 0
			for h in hounds.members():
				if (h as KindredHound).regrouping and not (h as KindredHound).target.is_empty():
					holding += 1
			ok = set_ok and engaged >= 4 and c.count_in(MobileCohort.Mode.REGROUP) > pop / 2 \
				and player.motor.speed() >= 0.9 * speed and holding == 0
			detail = "%d had engaged; %d regrouping, none holding a target (%d), she at %.2f m/s" \
				% [engaged, c.count_in(MobileCohort.Mode.REGROUP), holding, player.motor.speed()]
		"d398_pop15_attack":
			var e1: Node3D = enemies[0]
			var id1 := huntress.registry.id_of(e1)
			var g5 := 0
			var inner := 0
			var waiting := 0
			var cap := 0
			while g5 < 400:
				await get_tree().physics_frame
				g5 += 1
				inner = 0
				waiting = 0
				for h in hounds.members():
					var kh := h as KindredHound
					if kh.target_id() != id1:
						continue
					if kh.attack_inner and kh.state == KindredHound.State.BITE:
						inner += 1
					elif not kh.attack_inner:
						waiting += 1
				cap = int(c.attack[id1].inner_capacity) if c.attack.has(id1) else -1
				if cap > 0 and inner == cap and waiting == pop - cap:
					break
			ok = set_ok and cap > 0 and inner == cap and waiting == pop - cap
			detail = "%d biting at attack positions (capacity %d), %d waiting" % [inner, cap, waiting]
		_:
			# An unknown D-398 capture is REFUSED: a frame is never saved under a name
			# no state was driven to.
			ok = false
	cohort_hud.refresh()
	hounds_hud.refresh()
	huntress_hud.refresh()
	get_tree().paused = true
	await _frames(3)
	print("CAPTURE %s: live state matches the frame's name=%s | DIAGNOSTIC population %d, speed %s · %s"
		% [mode, str(ok), cohort_diagnostics.population(), cohort_diagnostics.speed_name(), detail])
	return ok

# ============================================================================
# THE D-400 PLAYER LOCOMOTION REDIRECTION CAPTURES (40-45).
# ============================================================================
# EVERY ONE USES THE CANONICAL TWO-HOUND PACK. This stage changes no population
# and none of its frames is a pack-size or cohesion claim.
#
# A STILL FRAME CANNOT SHOW THE ABSENCE OF A SLIDE, exactly as D-370's `commit`
# capture could not show the absence of a glide. What these frames show is the
# actor and its pack AT the moment of the reversal or the corner, at the speed
# the frame's name claims; the slide's absence is MEASURED, and each capture
# prints its own measurement and REFUSES TO SAVE if the state is not the one the
# name claims.

const D400_LANE_A := Vector3(-11.0, 0.0, -9.0)
const D400_LANE_B := Vector3(-11.0, 0.0, 9.0)
const D400_ROUTE_FROM := Vector3(-13.0, 0.0, -7.0)
const D400_ROUTE_TO := Vector3(7.0, 0.0, 0.0)
const D400_DOOR_FROM := Vector3(-3.0, 0.0, 5.0)
const D400_DOOR_TO := Vector3(8.0, 0.0, 0.0)

static func _d400_speed(mode: String) -> String:
	match mode:
		"d400_reversal_extreme", "d400_corner_extreme", "d400_arrival_extreme":
			return "EXTREME"
		"d400_doorway_fast":
			return "FAST"
	return "ORDINARY"

func _d400_stage(mode: String) -> void:
	for i in enemies.size():
		var e: OrdinaryEnemy = enemies[i]
		e.debug_freeze_ai = true
		e.global_position = Vector3(-18.2, 0, -10.3 + 0.9 * float(i))
	cohort_diagnostics.set_population(2)
	cohort_diagnostics.set_speed(_d400_speed(mode))
	match mode:
		"d400_launch":
			player.global_position = ProductionArena.player_spawn()
			for i in enemies.size():
				(enemies[i] as Node3D).global_position = [Vector3(-9, 0, -3), Vector3(-9, 0, 3),
					Vector3(-16, 0, -6), Vector3(7, 0, 0)][i]
		"d400_reversal_ordinary", "d400_reversal_extreme", "d400_arrival_extreme":
			player.global_position = D400_LANE_A
			if hounds != null and hounds.cohort != null:
				hounds.cohort.heading = (D400_LANE_B - D400_LANE_A).normalized()
		"d400_corner_extreme":
			player.global_position = D400_ROUTE_FROM
		"d400_doorway_fast":
			player.global_position = D400_DOOR_FROM

func _d400_top() -> float:
	return ProdConfig.TOP_SPEED_MPS * cohort_diagnostics.speed_scale()

## Drives the actor to (near) its current maximum along the lane AND at least
## three metres from where it started -- the same rule the D-400 suite uses, and
## for the same measured reason: a reversal issued inside the arrival tolerance
## of the starting point is cleared on arrival instead of served.
func _d400_drive(to: Vector3) -> float:
	var start := player.global_position
	player.command_move_to(to)
	var g := 0
	while g < 900 and not (player.motor.speed() >= 0.98 * _d400_top()
			and NavService.planar_distance(player.global_position, start) >= 3.0):
		await get_tree().physics_frame
		g += 1
	return player.motor.speed()

func _d400_capture(mode: String) -> bool:
	var ok := true
	var detail := ""
	var expect_speed := _d400_speed(mode)
	var set_ok := cohort_diagnostics.speed_name() == expect_speed \
		and cohort_diagnostics.population() == 2 and hounds.pack.size() == HoundConfig.PACK_SIZE \
		and hounds.stress.is_empty()
	match mode:
		"d400_launch":
			await _frames(4)
			ok = set_ok and not hud.enabled and not imprint_panel.enabled and not review_hud.enabled \
				and huntress_hud.enabled and hounds_hud.enabled and cohort_hud.enabled \
				and is_equal_approx(player.diagnostic_travel_speed_scale, 1.0)
			detail = "the accepted launch composition, ORDINARY speed, the canonical two-hound pack"
		"d400_reversal_ordinary", "d400_reversal_extreme":
			var moving := await _d400_drive(D400_LANE_B)
			var p0 := player.global_position
			var d0 := player.motor.velocity.normalized()
			var redirects0 := player.motor.redirects
			player.command_move_to(D400_LANE_A)
			# HOLD THE FRAME TWO FRAMES AFTER THE REDIRECT, where the actor is
			# already travelling the new way at speed.
			await _phys_frames(2)
			var obsolete := (player.global_position - p0).dot(d0)
			var off := GroundMotion.direction_angle_deg(player.motor.velocity, player.last_wish)
			ok = set_ok and moving >= 0.95 * _d400_top() and player.motor.redirects > redirects0 \
				and player.motor.velocity.dot(d0) < 0.0 and obsolete <= 0.05
			detail = "reversed from %.3f m/s; two frames later she is travelling the NEW way at %.3f m/s, %.5f m of travel the OBSOLETE way, velocity %.6f deg off the commanded direction" \
				% [moving, player.motor.speed(), obsolete, off]
		"d400_corner_extreme":
			var moving2 := await _d400_drive(D400_ROUTE_TO)
			# HOLD THE FRAME AT THE SHARPEST WAYPOINT ADVANCE of the route.
			var idx := player.follower.index
			var prev := player.last_wish
			var best := 0.0
			var g := 0
			while g < 900 and player.move_destination != null and best < 8.0:
				await get_tree().physics_frame
				g += 1
				if player.follower.index != idx:
					idx = player.follower.index
					best = maxf(best, GroundMotion.direction_angle_deg(prev, player.last_wish))
				prev = player.last_wish
			var off2 := GroundMotion.direction_angle_deg(player.motor.velocity, player.last_wish)
			ok = set_ok and moving2 >= 0.95 * _d400_top() and best >= 8.0 and off2 <= 0.01
			detail = "at %.3f m/s, held at a waypoint advance that turned the commanded direction by %.2f deg; the velocity is %.6f deg off it" \
				% [player.motor.speed(), best, off2]
		"d400_arrival_extreme":
			var dest := D400_LANE_A + Vector3(0, 0, 12.0)
			await _d400_drive(D400_LANE_B)
			var d := player.command_move_to(dest)
			var g2 := 0
			while g2 < 900 and not (player.move_destination == null and player.motor.speed() <= 0.0):
				await get_tree().physics_frame
				g2 += 1
			await _phys_frames(6)
			var overshoot := (player.global_position - d).dot(Vector3(0, 0, 1))
			ok = set_ok and player.motor.speed() <= 0.0 and overshoot <= 0.05 \
				and NavService.planar_distance(player.global_position, d) <= ProdConfig.ARRIVE_TOLERANCE_M
			detail = "at rest %.4f m from the commanded point, %+.4f m past it" \
				% [NavService.planar_distance(player.global_position, d), overshoot]
		"d400_doorway_fast":
			player.command_move_to(D400_DOOR_TO)
			var g3 := 0
			while g3 < 900 and absf(player.global_position.x - ProductionArena.doorway_centre().x) > 0.6:
				await get_tree().physics_frame
				g3 += 1
			ok = set_ok and absf(player.global_position.x - ProductionArena.doorway_centre().x) <= 0.6 \
				and player.motor.speed() > 0.5
			detail = "inside the doorway at %.3f m/s, x %.3f" % [player.motor.speed(), player.global_position.x]
		_:
			# An unknown D-400 capture is REFUSED: a frame is never saved under a
			# name no state was driven to.
			ok = false
	cohort_hud.refresh()
	hounds_hud.refresh()
	huntress_hud.refresh()
	get_tree().paused = true
	await _frames(3)
	print("CAPTURE %s: live state matches the frame's name=%s | DIAGNOSTIC speed %s (x%.2f), population %d · %s"
		% [mode, str(ok), cohort_diagnostics.speed_name(), cohort_diagnostics.speed_scale(),
		   cohort_diagnostics.population(), detail])
	return ok

# ------------------------------------------------------- D-402 captures ----

## The Cinder Field review ground: open floor in the west chamber's south half,
## MEASURED walkable (the arena's `west_south` authored rectangle is at
## (-10, 0, 7), and `west_of_blocker` at (-13, 0, 0)). Every trap in these
## captures is placed within the Skill's own range of where she stands.
const D402_HER := Vector3(-11.0, 0.0, 3.0)
const D402_SPOT_A := Vector3(-11.0, 0.0, 6.0)
const D402_SPOT_B := Vector3(-13.4, 0.0, 6.0)
const D402_SPOT_C := Vector3(-8.6, 0.0, 6.0)
## Two fields whose centres are 2.0 m apart OVERLAP, because each has a 2.60 m
## radius. The midpoint is inside BOTH, which is where the overlap probe stands.
const D402_OVERLAP_A := Vector3(-12.0, 0.0, 6.0)
const D402_OVERLAP_B := Vector3(-10.0, 0.0, 6.0)
const D402_OVERLAP_MID := Vector3(-11.0, 0.0, 6.0)
## Where the scene's own enemies are parked, far from every field driven here.
const D402_PARK := Vector3(-18.2, 0.0, -10.3)

## Places the scene for one D-402 capture. Every enemy is FROZEN where it stands,
## so the frame shows the Skill and not whatever the AI happened to do.
func _d402_stage(mode: String) -> void:
	for i in enemies.size():
		var e: OrdinaryEnemy = enemies[i]
		e.debug_freeze_ai = true
		e.global_position = D402_PARK + Vector3(0, 0, 0.9 * float(i))
	cohort_diagnostics.set_population(2)
	cohort_diagnostics.set_speed("ORDINARY")
	if mode == "d402_launch":
		player.global_position = ProductionArena.player_spawn()
		for i in enemies.size():
			(enemies[i] as Node3D).global_position = [Vector3(-9, 0, -3), Vector3(-9, 0, 3),
				Vector3(-16, 0, -6), Vector3(7, 0, 0)][i]
	else:
		player.global_position = D402_HER

## ONE Cinder Field use, driven deterministically through the ACCEPTED path:
## the cursor seam supplies the ground point, `use_binding()` begins the use,
## and the frame waits for the MECHANICAL release. Returns the placed trap, or
## null if the use was refused (which is reported, never swallowed).
func _d402_place_at(point: Vector3) -> CinderTrap:
	skills.pool.refill()
	skills.clear_cooldowns()
	cam.debug_cursor_override = point
	await _phys_frames(4)
	var before := cinder.placements
	var used := skills.use_binding(CinderContent.BINDING_INDEX)
	if not bool(used["ok"]):
		push_error("CAPTURE: binding %d refused Cinder Field: %s"
			% [CinderContent.BINDING_INDEX + 1, String(used["reason"])])
		cam.debug_cursor_override = null
		return null
	var g := 0
	while g < 240 and cinder.placements == before:
		await get_tree().physics_frame
		g += 1
	cam.debug_cursor_override = null
	# Let the commitment finish, so a later placement is not refused for it.
	var h := 0
	while h < 240 and player.commitment.active:
		await get_tree().physics_frame
		h += 1
	return cinder.live_nodes.back() if not cinder.live_nodes.is_empty() else null

## Waits until a trap is ARMED, or gives up. Returns true when it armed.
func _d402_wait_armed(trap: CinderTrap) -> bool:
	var g := 0
	while g < 240 and trap != null and is_instance_valid(trap) and not trap.is_armed():
		await get_tree().physics_frame
		g += 1
	return trap != null and is_instance_valid(trap) and trap.is_armed()

## Puts an enemy where a trap will see it, and waits for the eruption.
## `away_from`, when given, is a point the springing enemies are kept on the far
## side of. It exists for the overlap frame: two traps 2.0 m apart both have a
## 1.60 m trigger radius, so an enemy walked into the near side of one is inside
## the OTHER's ring as well and springs both. Added at delivery, after the frame
## refused itself (D-402). `Vector3.ZERO` means no preference, which is what
## every other capture passes and what they did before.
func _d402_spring(trap: CinderTrap, who: Array, away_from: Vector3 = Vector3.ZERO) -> bool:
	var bias := Vector3.ZERO
	if away_from != Vector3.ZERO:
		bias = (trap.global_position - away_from)
		bias.y = 0.0
		bias = bias.normalized()
	for e in who:
		(e as Node3D).global_position = trap.global_position \
			+ (Vector3(0.4, 0, 0.0) if bias == Vector3.ZERO else bias * 0.55)
	var placed := 0
	for e in who:
		# Fan them out INSIDE the eruption radius, so one springs it and every
		# eligible enemy in the area is Hit.
		if bias != Vector3.ZERO:
			(e as Node3D).global_position = trap.global_position + bias * (0.55 + 0.25 * float(placed))
		else:
			(e as Node3D).global_position = trap.global_position \
				+ Vector3(0.55 * cos(float(placed) * 2.1), 0.0, 0.55 * sin(float(placed) * 2.1))
		placed += 1
	var g := 0
	while g < 240 and trap != null and is_instance_valid(trap) and trap.eruptions == 0:
		await get_tree().physics_frame
		g += 1
	return trap != null and is_instance_valid(trap) and trap.eruptions == 1

func _d402_capture(mode: String) -> bool:
	var ok := true
	var detail := ""
	var composed := not hud.enabled and not imprint_panel.enabled and not review_hud.enabled \
		and huntress_hud.enabled and hounds_hud.enabled and cohort_hud.enabled and cinder_hud.enabled
	match mode:
		"d402_launch":
			# WAIT FOR THE PACK TO SETTLE, DO NOT PHOTOGRAPH IT MID-RECOVERY.
			# The first rendered launch frame showed "H1 FALLEN — returns by
			# itself in 2.7 s": this staging sets the diagnostic population and
			# teleports the enemies, and a hound caught by that goes through the
			# ACCEPTED D-396 recovery. Nothing was wrong with the runtime -- the
			# PICTURE was wrong, because a frame captioned "the launch
			# composition" showed a state launch does not have. Found by LOOKING
			# at it (D-402). The wait is BOUNDED and the capture REFUSES to save
			# if the pack never settles.
			var settle := 0
			while settle < 600 and hounds.living_count() < HoundConfig.PACK_SIZE:
				await get_tree().physics_frame
				settle += 1
			await _frames(4)
			ok = composed and cinder.is_active() and cinder.traps.is_empty() \
				and cinder.grounds.is_empty() \
				and hounds.living_count() == HoundConfig.PACK_SIZE
			detail = "the launch composition with F1 and F2 HIDDEN and four review HUDs shown; Cinder Field ACTIVE on binding %d, no trap and no field yet" \
				% (CinderContent.BINDING_INDEX + 1)
		"d402_placement":
			var t := await _d402_place_at(D402_SPOT_A)
			# HOLD THE FRAME PART-WAY THROUGH THE ARMING DELAY, where the ring is
			# visibly FILLING: a still frame of an armed trap would not show that
			# a dormant one is a different thing.
			await _phys_frames(8)
			ok = composed and t != null and t.state == CinderConfig.PHASE_ARMING \
				and cinder.placements == 1 and cinder.traps.size() == 1
			detail = "one DORMANT trap placed at %.2f, %.2f, arming %.0f%% through its %.2f s delay" \
				% [t.global_position.x if t != null else 0.0, t.global_position.z if t != null else 0.0,
				   (t.arming_progress() * 100.0) if t != null else -1.0, CinderConfig.ARMING_DELAY_S]
		"d402_armed":
			var t2 := await _d402_place_at(D402_SPOT_A)
			var armed := await _d402_wait_armed(t2)
			await _phys_frames(6)
			ok = composed and armed and cinder.armed_count() == 1
			detail = "the trap is ARMED — a complete trigger ring and a standing pin, %.1f s of its dormant Duration left" \
				% (t2.remaining_dormant() if t2 != null else -1.0)
		"d402_eruption":
			var t3 := await _d402_place_at(D402_SPOT_A)
			var armed3 := await _d402_wait_armed(t3)
			var sprang := await _d402_spring(t3, [enemies[0]])
			# HOLD THE FRAME WHILE THE FLASH IS STILL EXPANDING.
			await _phys_frames(6)
			ok = composed and armed3 and sprang and cinder.eruptions == 1 \
				and t3.state == CinderConfig.PHASE_SPRUNG
			detail = "ONE eruption: closed jaws, an expanding ring, %d enemy Hit for %.1f Fire damage; sprung by %s at entry t=%.4f" \
				% [t3.enemies_hit if t3 != null else -1, t3.eruption_damage if t3 != null else 0.0,
				   t3.trigger_id if t3 != null else "?", t3.trigger_entry_t if t3 != null else -1.0]
		"d402_burning_ground":
			var t4 := await _d402_place_at(D402_SPOT_A)
			await _d402_wait_armed(t4)
			var sprang4 := await _d402_spring(t4, [enemies[0]])
			# HOLD THE FRAME AFTER THE FLASH HAS GONE, where ONLY the lingering
			# burning ground is on screen -- which is the thing being photographed.
			var g := 0
			while g < 240 and cinder.ground_ticks < 1:
				await get_tree().physics_frame
				g += 1
			ok = composed and sprang4 and cinder.grounds.size() == 1 and cinder.ground_ticks >= 1
			detail = "the eruption has passed; ONE burning Ground lingers with %.1f s left, having dealt %.1f Fire damage over time in %d tick(s)" \
				% [(cinder.grounds[0] as CinderGround).remaining() if not cinder.grounds.is_empty() else -1.0,
				   cinder.ground_damage_total, cinder.ground_ticks]
		"d402_multi_hit":
			var t5 := await _d402_place_at(D402_SPOT_A)
			await _d402_wait_armed(t5)
			var sprang5 := await _d402_spring(t5, [enemies[0], enemies[1], enemies[2]])
			await _phys_frames(6)
			ok = composed and sprang5 and t5 != null and t5.enemies_hit >= 2
			detail = "ONE eruption Hit %d eligible enemies in its area: %s — it is not a single-target projectile" \
				% [t5.enemies_hit if t5 != null else -1, str(t5.hit_ids) if t5 != null else "[]"]
		"d402_overlap":
			# TWO fields whose centres are 2.0 m apart, and TWO enemies standing
			# in BOTH. The HUD's own arithmetic is the evidence: the contribution
			# count equals the number of enemies, NOT the number of fields.
			#
			# ORDER CORRECTED AT DELIVERY (D-402): the first version placed,
			# armed and sprang trap A, and only then began trap B -- about one
			# and a half seconds later -- so field A was already part-way through
			# its 4.0 s Duration before field B existed, and the frame REFUSED
			# ITSELF rather than save a picture of one field captioned as two.
			# Both traps are now placed and armed FIRST and sprung back to back,
			# so the two fields are lit within a few frames of each other and
			# NEITHER Duration is extended to make the picture work.
			#
			# AND THE TWO ENEMIES PHOTOGRAPHED ARE NOT THE TWO THAT SPRANG THEM:
			# a springing enemy has taken up to two 46.0 eruption Hits, and an
			# enemy that dies mid-measurement stops being eligible and takes the
			# contribution count with it. The pair moved into the overlap are at
			# full Health, and the two that sprang the traps are parked away so
			# they contribute nothing.
			var a := await _d402_place_at(D402_OVERLAP_A)
			var b := await _d402_place_at(D402_OVERLAP_B)
			await _d402_wait_armed(a)
			await _d402_wait_armed(b)
			await _d402_spring(a, [enemies[0]], D402_OVERLAP_B)
			await _d402_spring(b, [enemies[1]], D402_OVERLAP_A)
			(enemies[0] as Node3D).global_position = D402_PARK
			(enemies[1] as Node3D).global_position = D402_PARK + Vector3(0, 0, 0.9)
			(enemies[2] as Node3D).global_position = D402_OVERLAP_MID
			(enemies[3] as Node3D).global_position = D402_OVERLAP_MID + Vector3(0.5, 0, 0.0)
			var ticks0 := cinder.ground_ticks
			var contrib0 := cinder.ground_contributions
			var g2 := 0
			while g2 < 300 and cinder.ground_ticks < ticks0 + 2:
				await get_tree().physics_frame
				g2 += 1
			var ticks := cinder.ground_ticks - ticks0
			var contrib := cinder.ground_contributions - contrib0
			var inside := cinder.fields_containing(D402_OVERLAP_MID)
			ok = composed and inside >= 2 and ticks >= 2 and contrib == 2 * ticks
			detail = "%d overlapping fields contain the probe point; over %d tick(s) they made %d contribution(s) for 2 enemies — ONE each, never multiplied" \
				% [inside, ticks, contrib]
		"d402_replacement":
			var cap := CinderConfig.INSTANCES_MAX
			for k in cap:
				await _d402_place_at([D402_SPOT_A, D402_SPOT_B, D402_SPOT_C][k % 3])
			var before := cinder.replacements
			await _d402_place_at(D402_OVERLAP_A)
			await _phys_frames(4)
			ok = composed and cinder.replacements == before + 1 and cinder.traps.size() == cap \
				and cinder.eruptions == 0
			detail = "the cap is %d dormant traps; a %dth placement replaced the OLDEST HARMLESSLY (replacements %d, eruptions %d)" \
				% [cap, cap + 1, cinder.replacements, cinder.eruptions]
		"d402_expiry":
			var t6 := await _d402_place_at(D402_SPOT_A)
			await _d402_wait_armed(t6)
			var before_hit := cinder.hit_damage_total
			var before_ground := cinder.ground_damage_total
			var g3 := 0
			while g3 < 1200 and cinder.expiries == 0:
				await get_tree().physics_frame
				g3 += 1
			await _phys_frames(4)
			ok = composed and cinder.expiries == 1 and cinder.eruptions == 0 \
				and cinder.grounds.is_empty() and cinder.traps.is_empty() \
				and is_equal_approx(cinder.hit_damage_total, before_hit) \
				and is_equal_approx(cinder.ground_damage_total, before_ground)
			detail = "an UNSPRUNG trap waited out its %.1f s dormant Duration and ended HARMLESSLY: %d eruption(s), %d burning field(s), and the Hit and Ground totals did not move" \
				% [CinderConfig.DORMANT_DURATION_S, cinder.eruptions, cinder.grounds.size()]
		_:
			# An unknown D-402 capture is REFUSED: a frame is never saved under a
			# name no state was driven to.
			ok = false
	cinder_hud.refresh()
	cohort_hud.refresh()
	hounds_hud.refresh()
	huntress_hud.refresh()
	get_tree().paused = true
	await _frames(3)
	print("CAPTURE %s: live state matches the frame's name=%s | %s" % [mode, str(ok), detail])
	return ok

# ------------------------------------------------------- D-404 captures ----

## The direct-click review ground: the west chamber's INTERIOR BLOCKER, three
## wall modules at x = -7 spanning z = -3 ... 3 -- "a long wall" six metres wide,
## and the arena's own comment says a path across it "MUST route around it".
## Every point below was MEASURED clear by a body-shape sweep before use.
const D404_UNOBSTRUCTED_FROM := Vector3(-13.0, 0.0, -5.0)
const D404_UNOBSTRUCTED_TO := Vector3(-9.5, 0.0, -8.0)
const D404_WALL_FROM := Vector3(-10.5, 0.0, 0.4)
const D404_BEHIND_WALL := Vector3(-3.5, 0.0, 0.6)
const D404_GLANCE_FROM := Vector3(-8.6, 0.0, -2.6)
const D404_GLANCE_TO := Vector3(-6.0, 0.0, 2.6)
const D404_AROUND_A := Vector3(-8.4, 0.0, 4.2)
const D404_AROUND_B := Vector3(-4.0, 0.0, 4.0)
const D404_EXTREME_FROM := Vector3(-12.5, 0.0, 0.3)
const D404_PARK := Vector3(-18.2, 0.0, -10.3)
## The blocker's centre line. Its WEST FACE is measured live by a ray.
const D404_BLOCKER_X := -7.0

func _d404_stage(mode: String) -> void:
	for i in enemies.size():
		var e: OrdinaryEnemy = enemies[i]
		e.debug_freeze_ai = true
		e.global_position = D404_PARK + Vector3(0, 0, 0.9 * float(i))
	cohort_diagnostics.set_population(2)
	cohort_diagnostics.set_speed("EXTREME" if mode == "d404_extreme" else "ORDINARY")
	match mode:
		"d404_unobstructed":
			player.global_position = D404_UNOBSTRUCTED_FROM
		"d404_glancing":
			player.global_position = D404_GLANCE_FROM
		"d404_extreme":
			player.global_position = D404_EXTREME_FROM
		_:
			player.global_position = D404_WALL_FROM

## The blocker's west face at the height of her body, measured by a ray -- so a
## frame claiming "stopped at the wall" is checked against the wall, not a number.
func _d404_west_face_x(z: float) -> float:
	var space := player.get_world_3d().direct_space_state
	var q := PhysicsRayQueryParameters3D.create(Vector3(-11.0, 0.85, z), Vector3(D404_BLOCKER_X, 0.85, z), 4)
	var hit := space.intersect_ray(q)
	return float(Vector3(hit["position"]).x) if not hit.is_empty() else INF

## ONE click order, the way the mouse issues one, and a bounded wait for it to end.
func _d404_click(to: Vector3, max_frames: int = 900) -> void:
	player.command_move_to(to)
	var g := 0
	while g < max_frames and player.click_order.active:
		await get_tree().physics_frame
		g += 1

func _d404_capture(mode: String) -> bool:
	var ok := true
	var detail := ""
	var o := player.click_order
	var composed := not hud.enabled and not imprint_panel.enabled and not review_hud.enabled \
		and huntress_hud.enabled and hounds_hud.enabled and cohort_hud.enabled and cinder_hud.enabled \
		and click_hud.enabled and click_gizmo.visible
	# Let the pack settle first, so no frame shows a recovery nobody asked for.
	var settle := 0
	while settle < 600 and hounds.living_count() < HoundConfig.PACK_SIZE:
		await get_tree().physics_frame
		settle += 1
	await _phys_frames(4)
	match mode:
		"d404_unobstructed":
			player.command_move_to(D404_UNOBSTRUCTED_TO)
			# HOLD THE FRAME PART-WAY ALONG, where the segment and the marker show.
			var g := 0
			while g < 600 and o.active and o.travelled_m < 1.6:
				await get_tree().physics_frame
				g += 1
			ok = composed and o.active and o.path_points == 0 and player.follower.point_count() == 0 \
				and not o.has_contact
			detail = "travelling STRAIGHT at the clicked point, %.2f m along, no contact, %d path points" \
				% [o.travelled_m, o.path_points]
		"d404_behind_wall":
			player.command_move_to(D404_BEHIND_WALL)
			# HOLD THE FRAME BEFORE CONTACT: the segment runs into the wall.
			var g2 := 0
			while g2 < 600 and o.active and player.global_position.x < -8.6:
				await get_tree().physics_frame
				g2 += 1
			ok = composed and o.active and not o.has_contact and o.path_points == 0 \
				and player.global_position.x < _d404_west_face_x(player.global_position.z)
			detail = "a destination BEHIND the long wall: travelling straight at it, x %.2f, no path" \
				% player.global_position.x
		"d404_stopped_at_wall", "d404_extreme":
			await _d404_click(D404_BEHIND_WALL)
			await _phys_frames(20)
			var face := _d404_west_face_x(player.global_position.z)
			var gap := face - player.global_position.x
			ok = composed and o.stop_reason == DirectClickOrder.STOP_COLLIDED and o.has_contact \
				and gap >= ProdConfig.PLAYER_BODY_RADIUS - 0.002 and gap <= ProdConfig.PLAYER_BODY_RADIUS + 0.02 \
				and absf(player.global_position.z - D404_WALL_FROM.z) < 0.5 + absf(D404_EXTREME_FROM.z - D404_WALL_FROM.z) \
				and player.motor.speed() <= 0.0
			if mode == "d404_extreme":
				ok = ok and cohort_diagnostics.speed_name() == "EXTREME"
			detail = "%s: STOPPED at the wall — COLLIDED, body %.3f m from the face (radius %.2f), %.2f m short of the click, speed %.3f" \
				% [cohort_diagnostics.speed_name(), gap, ProdConfig.PLAYER_BODY_RADIUS,
				   NavService.planar_distance(player.global_position, D404_BEHIND_WALL), player.motor.speed()]
		"d404_glancing":
			await _d404_click(D404_GLANCE_TO)
			var at := player.global_position
			await _phys_frames(30)
			var drift := NavService.planar_distance(player.global_position, at)
			ok = composed and o.stop_reason == DirectClickOrder.STOP_COLLIDED and drift <= 0.002
			detail = "a GLANCING impact: stopped at contact, %.4f m of travel in the 30 frames after it — no wall slide" % drift
		"d404_manual_around":
			await _d404_click(D404_BEHIND_WALL)
			var stopped := o.stop_reason == DirectClickOrder.STOP_COLLIDED
			await _d404_click(D404_AROUND_A)
			var reached_a := o.stop_reason == DirectClickOrder.STOP_ARRIVED
			player.command_move_to(D404_AROUND_B)
			var g3 := 0
			while g3 < 600 and o.active and player.global_position.x < D404_BLOCKER_X + 0.3:
				await get_tree().physics_frame
				g3 += 1
			ok = composed and stopped and reached_a and o.active and not o.has_contact \
				and player.global_position.x > D404_BLOCKER_X
			detail = "stopped at the wall, then CLICKED ROUND IT BY HAND: a second click to its end, a third past it — now at x %.2f, beyond the wall, no contact" \
				% player.global_position.x
		_:
			# An unknown D-404 capture is REFUSED.
			ok = false
	click_hud.refresh()
	cinder_hud.refresh()
	cohort_hud.refresh()
	hounds_hud.refresh()
	huntress_hud.refresh()
	get_tree().paused = true
	await _frames(3)
	print("CAPTURE %s: live state matches the frame's name=%s | %s" % [mode, str(ok), detail])
	return ok
