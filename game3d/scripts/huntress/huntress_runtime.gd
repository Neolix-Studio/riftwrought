class_name HuntressRuntime
extends Node

## THE HUNTRESS SPLINTER SHOT STAGE'S RUNTIME (D-392) — what a Splinter Shot use
## needs beyond the accepted Skill Use path, and nothing else.
##
## ============================================================================
## WHERE EACH RULING IS IMPLEMENTED
## ============================================================================
##   the Skill Use itself -- binding, cost, commitment, release, cooldown ... the
##       ACCEPTED `SkillRuntime.use_binding()` / `_release()`, unchanged in shape;
##   D-391 r2, the facing SNAP at use start ......... `on_use_began()`, through the
##       controller's facing-hold seam; the visual blends at the ACCEPTED rate;
##   "must visibly align before release" .......... `release_arrow()`'s guard;
##   "normal control resumes after release" ......... `release_arrow()`;
##   D-390 r4 / D-391 r5, one arrow, time of impact .. `SplinterArrow`;
##   D-391 r4, enemy eligibility (a general rule) .... `HitEligibility`;
##   D-392 CL-3, the combat-entity ID ................ `CombatEntityRegistry`, filled
##       HERE, in the composition root's explicit spawn order.
##
## EVERY NUMBER IT USES IS PROVISIONAL (`HuntressConfig.registry()`).

var main: Node = null
var player: PlayerController = null
var skills: SkillRuntime = null
var arrow_parent: Node3D = null
var registry: CombatEntityRegistry = null
var animator: HuntressBowAnimator = null
var setup_ok: bool = false
var setup_problems: Array[String] = []

## Live state, for the HUD and the suite. LOGS, not control state.
var uses_begun: int = 0
var arrows_released: int = 0
var last_use_id: String = ""
var last_use_cfg: String = ""
var sampled_yaw_at_start: float = 0.0
var visual_yaw_at_start: float = 0.0
var last_alignment_deg: float = 0.0
var late_visual_alignments: int = 0
var hold_orphans: int = 0
var fallback_spawns: int = 0
var last_outcome: Dictionary = {}
var release_log: Array = []
var arrows: Array = []

## Builds the stage. Returns false -- with every problem recorded -- if anything
## failed; a build step that silently failed would describe a Skill the runtime
## does not have.
func setup(p_main: Node, p_player: PlayerController, p_skills: SkillRuntime,
		p_arrow_parent: Node3D, enemies: Array) -> bool:
	main = p_main
	player = p_player
	skills = p_skills
	arrow_parent = p_arrow_parent
	# THE ACTIVE AREA'S REGISTRY, filled in the EXPLICIT COMPOSITION ORDER -- the
	# composition root's own spawn loop -- never inside an engine callback.
	registry = CombatEntityRegistry.new("production_test_arena")
	for e in enemies:
		if register_enemy(e) == "":
			setup_problems.append("an enemy was refused by the registry: %s" % registry.last_refusal)
	# THE PLACEHOLDER ANIMATION LAYER, on the current 65-joint Huntress.
	animator = HuntressBowAnimator.new()
	animator.name = "HuntressBowAnimator_PLACEHOLDER"
	player.add_child(animator)
	if not animator.setup(player):
		setup_problems.append("the placeholder animation layer did not build")
	# SPLINTER SHOT, THROUGH THE ACCEPTED ARCHITECTURE: learned at rank 1 / 0 XP,
	# one unmodified Configuration, bound to binding 6, revalidated.
	if not HuntressContent.learn_into(skills.library):
		setup_problems.append("Splinter Shot was not learned (already known?)")
	var built := HuntressContent.build_configuration(skills.library)
	if not bool(built["ok"]):
		setup_problems.append("Splinter Shot's Configuration refused: %s" % String(built["reason"]))
	skills.configurations[HuntressContent.CFG_SPLINTER_SHOT] = built["configuration"]
	var b := skills.loadout.bind(HuntressContent.BINDING_INDEX, HuntressContent.CFG_SPLINTER_SHOT)
	if not bool(b["ok"]):
		setup_problems.append("binding %d refused Splinter Shot: %s"
			% [HuntressContent.BINDING_INDEX + 1, String(b["reason"])])
	skills.loadout.revalidate(skills.pool)
	skills.huntress = self
	setup_ok = setup_problems.is_empty()
	if not setup_ok:
		push_error("D-392: the Huntress stage did not build: %s" % str(setup_problems))
	return setup_ok

## Registers ONE ordinary enemy in this area's registry. Called in composition
## order by `setup()`, and by a verification suite for its own probes.
func register_enemy(e: Node) -> String:
	return registry.register(e, "ordinary", "hostile")

# =============================================================================
# THE USE
# =============================================================================

## Called by `SkillRuntime.use_binding()` on the frame a Splinter Shot use BEGINS,
## with the aim it SAMPLED. THE MECHANICAL FACING SNAPS TO IT NOW -- the attack
## does not wait for a turning phase: the commitment has already begun.
func on_use_began(use_id: String, cfg_id: String, _res: Dictionary, aim_dir: Vector3) -> void:
	uses_begun += 1
	last_use_id = use_id
	last_use_cfg = cfg_id
	sampled_yaw_at_start = YawDriver.yaw_to(aim_dir)
	visual_yaw_at_start = player.visual.rotation.y if player.visual != null else 0.0
	player.hold_facing(sampled_yaw_at_start)
	if animator != null:
		animator.begin_action(use_id)

## Called by `SkillRuntime._release()` AT THE MECHANICAL RELEASE MARKER, exactly
## once per use, with the aim sampled when the use began.
func release_arrow(cfg_id: String, res: Dictionary, use_dir: Vector3, use_id: String) -> void:
	# 1. "HUNTRESS MUST VISIBLY ALIGN BEFORE RELEASE." The visual has been blending
	#    toward the held facing at the accepted rate since the use began; if it is
	#    somehow not there by now it is SNAPPED, and that is COUNTED -- a late
	#    visual must never be silent. At the candidate timing it never happens.
	var mech := player.mechanical_facing_yaw()
	var vis := player.visual.rotation.y
	last_alignment_deg = absf(rad_to_deg(wrapf(vis - mech, -PI, PI)))
	if last_alignment_deg > HuntressConfig.VISUAL_ALIGN_TOLERANCE_DEG:
		late_visual_alignments += 1
		player.yaw_driver.snap(mech)
		player.visual.rotation.y = mech
	# 2. "NORMAL CONTROL RESUMES AFTER RELEASE."
	player.release_facing_hold()
	# 3. THE ONE ARROW, taking over from the NOCKED arrow on this frame.
	var nock := animator.nocked_arrow() if animator != null else {}
	var tail: Vector3
	var length := 0.63
	var scale := 0.23
	if animator != null and animator.pres.arrow_visible:
		tail = (nock["xform"] as Transform3D).origin
		length = float(nock["length"])
		scale = float(nock["scale"])
	else:
		# The nocked arrow was not drawn (a test seam that slowed the animation
		# clock). The arrow still leaves, from a muzzle point, and it is COUNTED.
		fallback_spawns += 1
		tail = player.global_position + Vector3(0, 1.3, 0) + use_dir.normalized() * 0.35
	var a := SplinterArrow.new()
	a.name = "SplinterArrow_%s" % use_id
	arrow_parent.add_child(a)
	a.launch(tail, use_dir, length, scale, player.ground_point(), use_id,
		float(res["damage"]), registry, _on_arrow_report.bind(use_id), cfg_id)
	arrows.append(a)
	arrows_released += 1
	release_log.append({"use": use_id, "frame": Engine.get_physics_frames(),
		"elapsed": player.commitment.elapsed, "duration": player.commitment.duration,
		"marker": player.commitment.release_marker, "aim": use_dir, "tail": tail,
		"alignment_deg": last_alignment_deg, "mechanical_yaw": mech})

## The arrow reports ONCE when it ends. The report is RECORDED for the review
## HUD and the suite, and nothing else: no target is designated, preferred or
## commanded by a Hit.
func _on_arrow_report(outcome: String, rec: Dictionary, info: Dictionary, use_id: String) -> void:
	last_outcome = {"outcome": outcome, "use_id": use_id, "id": String(rec.get("id", "")),
		"category": String(rec.get("category", "")), "distance_m": float(info.get("distance_m", 0.0)),
		"tie_set": info.get("tie_set", []), "frame": Engine.get_physics_frames()}

func _physics_process(_delta: float) -> void:
	# A facing hold outliving its Splinter Shot use would be a stuck body. It
	# cannot happen in play (the release always comes first); if a test resets
	# the commitment mid-use, the hold is released here and COUNTED.
	if player != null and player.facing_hold_active():
		var c := player.commitment
		if not (c.active and c.label == HuntressConfig.SPLINTER_ACTION_LABEL):
			player.release_facing_hold()
			hold_orphans += 1
	var keep: Array = []
	for a in arrows:
		if a != null and is_instance_valid(a):
			keep.append(a)
	arrows = keep

# =============================================================================
# THE REVIEW MODEL — everything the HUD shows, read NOW from live objects.
# =============================================================================
func review_snapshot() -> Dictionary:
	var c := player.commitment
	var splinter := c.active and c.label == HuntressConfig.SPLINTER_ACTION_LABEL
	var cfg := skills.loadout.configuration(HuntressContent.CFG_SPLINTER_SHOT) as SkillConfiguration
	var res := cfg.resolve() if cfg != null else {}
	return {
		"committed": c.active, "splinter": splinter, "label": c.label,
		"phase": c.phase() if c.active else "none",
		"elapsed": c.elapsed, "duration": c.duration, "marker": c.release_marker,
		"release_at": c.duration * c.release_marker if splinter else HuntressConfig.SPLINTER_RELEASE_S,
		"recovery": HuntressConfig.splinter_recovery_s(),
		"playback_rate": animator.playback_rate if animator != null else 0.0,
		"anim_phase": animator.phase if animator != null else "",
		"shown_clip": animator.shown_clip if animator != null else "",
		"hold": player.facing_hold_active(),
		"mechanical_yaw": player.mechanical_facing_yaw(),
		"visual_yaw": player.visual.rotation.y,
		"last_alignment_deg": last_alignment_deg,
		"late_visual_alignments": late_visual_alignments,
		"uses": uses_begun, "arrows": arrows_released, "last_use_id": last_use_id,
		"last_outcome": last_outcome.duplicate(),
		"mana_current": skills.pool.mana_current, "mana_usable": skills.pool.mana_usable(),
		"cost": float(res.get("mana_cost", 0.0)),
		"last_refusal": skills.last_refusal,
		"binding": HuntressContent.BINDING_INDEX + 1,
		"deactivated": skills.loadout.deactivated.has(HuntressContent.CFG_SPLINTER_SHOT),
	}
