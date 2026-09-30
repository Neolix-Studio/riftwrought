class_name CinderRuntime
extends Node

## THE CINDER FIELD STAGE'S RUNTIME (D-402) — what a Cinder Field use needs
## beyond the accepted Skill Use path, and nothing else.
##
## ============================================================================
## WHERE EACH RULING IS IMPLEMENTED
## ============================================================================
##   the Skill Use itself -- binding, cost, commitment, release, cooldown ... the
##       ACCEPTED `SkillRuntime.use_binding()` / `_release()`, unchanged in shape;
##   valid ground placement, and the REFUSAL of an invalid one .... `validate_placement()`,
##       called by the accepted use path BEFORE any Mana is spent;
##   the trap, its arming, its single eruption and its harmless expiry ... `CinderTrap`;
##   deterministic simultaneous entry .............. `CinderTrap._pick_triggerer()`,
##       through the ACCEPTED `ArrowCollision` closed form and tie-break;
##   the instance cap and oldest-instance replacement .......... `place_trap()`;
##   the NON-STACKING burning Ground .......... `_apply_ground_tick()` — ONE arbiter;
##   cleanup on deactivation or unequip ....................... `_sync_equipped()`;
##   the review loadout, Capacity NOT increased ............... `setup()`.
##
## ---------------------------------------------------------------------------
## THE TRAPS AND FIELDS EXIST IF AND ONLY IF THE CONFIGURATION IS ACTIVE.
## ---------------------------------------------------------------------------
## The ruling: "Removing, unequipping or deactivating Cinder Field must cleanly
## remove its owned outstanding traps and ground effects without affecting
## unrelated Skills." So nothing here decides for itself: every physics step it
## asks the ACCEPTED loadout whether the Configuration is among
## `active_configuration_ids()` -- which `revalidate()` alone decides -- and
## removes what it owns when it is not, recording why. It touches NOTHING it does
## not own.
##
## EVERY NUMBER IT USES IS PROVISIONAL (`CinderConfig.registry()`).

var main: Node = null
var player: PlayerController = null
var skills: SkillRuntime = null
var registry: CombatEntityRegistry = null
var field_parent: Node3D = null
var setup_ok: bool = false
var setup_problems: Array[String] = []

## The DORMANT traps this runtime owns, OLDEST FIRST. A sprung trap leaves this
## list the moment it erupts: it no longer occupies an instance slot, and that
## reading is DECLARED in `CinderConfig.duration_contract()`.
var traps: Array = []
## Every trap node still in the scene, dormant or lingering-sprung. Kept apart
## from `traps` so "how many instances" and "how many nodes" can never be
## confused for one another.
var live_nodes: Array = []
## The burning Ground fields this runtime owns.
var grounds: Array = []

## Diagnostics the suite and the HUD read. LOGS, not control state.
var placements: int = 0
var placement_refusals: int = 0
var eruptions: int = 0
var replacements: int = 0
var expiries: int = 0
var ground_ticks: int = 0
var ground_contributions: int = 0
var hit_damage_total: float = 0.0
var ground_damage_total: float = 0.0
var hit_events: int = 0
var last_refusal: String = ""
var last_event: String = ""
var last_hit_event: String = ""
var last_ground_event: String = ""
## The same two events in a form short enough for the review HUD's column. They
## are composed from the SAME live values, beside the full records, and own no
## number of their own.
var last_hit_brief: String = ""
var last_ground_brief: String = ""
var last_refusal_brief: String = ""
var removals: int = 0
var last_removal_reason: String = ""
## What the review loadout measured, before and after.
var review_measure: Dictionary = {}
var plan_applied: String = ""

## Placement sequence, so the OLDEST instance is identifiable without reading a
## node name, an instance id or an array order's meaning.
var _ordinal: int = 0
## The shared burning-Ground cadence. ONE accumulator for every field: that is
## what makes "exactly one contribution per enemy per tick" arithmetic.
var _tick_accum: float = 0.0
## Integrity, sampled every step: anything owned while the Skill is not active.
var frames_sampled: int = 0
var frames_inconsistent: int = 0

# =============================================================================
# SET-UP
# =============================================================================

func setup(p_main: Node, p_player: PlayerController, p_skills: SkillRuntime,
		huntress_runtime, p_parent: Node3D) -> bool:
	main = p_main
	player = p_player
	skills = p_skills
	field_parent = p_parent
	# THE ACTIVE AREA'S ONE REGISTRY -- the one the Splinter Shot stage fills in
	# composition order. This stage reads it; it never registers or reorders it,
	# and NEITHER a trap NOR a burning Ground is ever registered in it.
	if huntress_runtime != null:
		registry = huntress_runtime.registry
	if registry == null:
		setup_problems.append("no combat-entity registry for the active area")

	# CINDER FIELD, THROUGH THE ACCEPTED ARCHITECTURE: learned at rank 1 / 0 XP,
	# one unmodified Configuration.
	if not CinderContent.learn_into(skills.library):
		setup_problems.append("Cinder Field was not learned (already known?)")
	var built := CinderContent.build_configuration(skills.library)
	if not bool(built["ok"]):
		setup_problems.append("the Cinder Field Configuration refused: %s" % String(built["reason"]))
	skills.configurations[CinderContent.CFG_CINDER_FIELD] = built["configuration"]

	# THE REVIEW LOADOUT, MEASURED BEFORE AND AFTER. Capacity is NOT increased.
	var before := _measure()
	var b := skills.loadout.bind(CinderContent.BINDING_INDEX, CinderContent.CFG_CINDER_FIELD)
	if not bool(b["ok"]):
		setup_problems.append("binding %d refused Cinder Field: %s"
			% [CinderContent.BINDING_INDEX + 1, String(b["reason"])])
	skills.loadout.revalidate(skills.pool)
	skills.pool.refill()
	plan_applied = CinderConfig.REVIEW_LOADOUT_LABEL
	review_measure = {"before": before, "after": _measure()}
	skills.cinder = self
	setup_ok = setup_problems.is_empty()
	if not setup_ok:
		push_error("D-402: the Cinder Field stage did not build: %s" % str(setup_problems))
	return setup_ok

func _measure() -> Dictionary:
	var lo := skills.loadout
	return {"bindings": lo.bindings.duplicate(), "persistent": lo.persistent.duplicate(),
		"used": lo.capacity_used(), "total": lo.capacity_total(), "demanded": lo.capacity_demanded(),
		"deactivated": lo.deactivated.duplicate(), "mana_reserved": skills.pool.mana_reserved,
		"life_reserved": skills.pool.life_reserved}

func configuration() -> SkillConfiguration:
	return skills.loadout.configuration(CinderContent.CFG_CINDER_FIELD) as SkillConfiguration

## TRUE only when the accepted loadout holds the Configuration as an ACTIVE
## binding -- equipped, valid, within Capacity. `revalidate()` alone decides it.
func is_active() -> bool:
	return skills != null \
		and skills.loadout.active_configuration_ids().has(CinderContent.CFG_CINDER_FIELD)

## The binding state in words: ACTIVE, UNEQUIPPED, or DEACTIVATED with the
## accepted revalidation's OWN reason.
func binding_state() -> Dictionary:
	var lo := skills.loadout
	if not lo.bound_configuration_ids().has(CinderContent.CFG_CINDER_FIELD):
		return {"state": "UNEQUIPPED", "reason": "no binding holds it — no trap can be placed"}
	if lo.deactivated.has(CinderContent.CFG_CINDER_FIELD):
		return {"state": "DEACTIVATED", "reason": String(lo.deactivated[CinderContent.CFG_CINDER_FIELD])}
	return {"state": "ACTIVE", "reason": "bound to binding %d and within Capacity"
		% (CinderContent.BINDING_INDEX + 1)}

# =============================================================================
# PLACEMENT VALIDITY — asked BEFORE the use begins
# =============================================================================

## ============================================================================
## A GROUND-TARGETED SKILL VALIDATES ITS TARGET, AND REFUSES AN INVALID ONE.
## ============================================================================
## The accepted ballista CLAMPS a far destination and then silently snaps it to
## the nearest navigable point, which can put an emplacement metres from where
## the player aimed. The ruling here asks for "valid ground placement and refusal
## of invalid placement", so this does both halves and distinguishes them:
##
##   * a point beyond the range is CLAMPED ALONG THE AIM to the range -- that is
##     a legal use, and canon's own "clamped to range" behaviour;
##   * the clamped point is then compared with the nearest NAVIGABLE point, and
##     if walkable ground is farther away than the declared tolerance the use is
##     REFUSED with a reason. Nothing is placed, nothing is paid, nothing begins.
##
## Returns {"ok", "point", "reason", "clamped", "off_mesh_m"}.
func validate_placement(requested: Vector3) -> Dictionary:
	if player == null:
		return {"ok": false, "point": requested, "reason": "no player is composed in",
			"clamped": false, "off_mesh_m": -1.0}
	var dest := requested
	dest.y = 0.0
	var clamped := false
	var reach := NavService.planar_distance(dest, player.global_position)
	if reach > CinderConfig.PLACE_RANGE_M:
		var d := dest - player.global_position
		d.y = 0.0
		dest = player.global_position + d.normalized() * CinderConfig.PLACE_RANGE_M
		dest.y = 0.0
		clamped = true
	var map := NavService.map_rid_for(player)
	var nearest := NavService.nearest_point(map, dest)
	var off := NavService.planar_distance(nearest, dest)
	if off > CinderConfig.PLACE_TOLERANCE_M:
		return {"ok": false, "point": dest, "clamped": clamped, "off_mesh_m": off,
			"reason": ("that ground point is not walkable — the nearest navigable ground is %.3f m away, "
				+ "against a tolerance of %.3f m") % [off, CinderConfig.PLACE_TOLERANCE_M],
			"brief": "not walkable — nearest ground %.2f m away (tolerance %.2f m)"
				% [off, CinderConfig.PLACE_TOLERANCE_M]}
	nearest.y = 0.0
	return {"ok": true, "point": nearest, "clamped": clamped, "off_mesh_m": off,
		"reason": "walkable ground %.3f m from the requested point%s"
			% [off, " (clamped to the %.1f m range)" % CinderConfig.PLACE_RANGE_M if clamped else ""]}

## Called by the accepted use path when a placement is refused, so the refusal is
## visible on the review HUD rather than only in a return value.
## `brief` is the SAME refusal in a form short enough for the review HUD's
## column; when none is supplied the HUD falls back to the full reason and cuts
## it, which is what the first rendered frames showed happening (D-402).
func note_refusal(reason: String, brief: String = "") -> void:
	placement_refusals += 1
	last_refusal = reason
	last_refusal_brief = brief if brief != "" else reason
	last_event = "PLACEMENT REFUSED — %s" % reason

# =============================================================================
# THE RELEASE — one trap, at the mechanical marker
# =============================================================================

## Called by `SkillRuntime._release()` AT THE MECHANICAL RELEASE MARKER, exactly
## once per use, with the ground point SAMPLED when the use began.
func place_trap(cfg_id: String, res: Dictionary, ground_point: Vector3, use_id: String) -> Dictionary:
	if field_parent == null:
		return {"ok": false, "reason": "no parent"}
	var v := validate_placement(ground_point)
	if not bool(v["ok"]):
		# It was validated at use start, so reaching here means the world moved
		# under the use. Refuse LOUDLY rather than place a trap in a wall.
		note_refusal(String(v["reason"]), String(v.get("brief", "")))
		return {"ok": false, "reason": String(v["reason"])}

	# THE INSTANCE LIMIT, AND THE OLDEST REPLACED — canon's own rule. The oldest
	# DORMANT instance goes HARMLESSLY: no eruption, no burning Ground.
	var limit: int = maxi(1, int(res.get("instances_max", CinderConfig.INSTANCES_MAX)))
	_prune()
	while traps.size() >= limit:
		var oldest = traps.pop_front()
		if oldest != null and is_instance_valid(oldest):
			_free_trap(oldest)
			replacements += 1
			last_event = "OLDEST INSTANCE REPLACED — the cap is %d dormant traps" % limit

	_ordinal += 1
	var t := CinderTrap.new()
	t.name = "CinderTrap_%d" % _ordinal
	t.runtime = self
	t.registry = registry
	t.origin_configuration = cfg_id
	t.use_id = use_id
	t.ordinal = _ordinal
	t.arming_delay = CinderConfig.ARMING_DELAY_S
	t.trigger_radius = CinderConfig.TRIGGER_RADIUS_M
	t.eruption_radius = CinderConfig.ERUPTION_RADIUS_M
	t.dormant_duration = CinderConfig.DORMANT_DURATION_S
	t.eruption_damage = float(res.get("damage", CinderConfig.ERUPTION_DAMAGE_AT_RANK_1))
	field_parent.add_child(t)
	t.build()
	t.global_position = v["point"]
	traps.append(t)
	live_nodes.append(t)
	placements += 1
	last_event = "PLACED — %s at %.2f, %.2f (%s)" % [use_id, t.global_position.x, t.global_position.z,
		String(v["reason"])]
	return {"ok": true, "reason": "", "trap": t}

## The eruption's second component, created HERE so the non-stacking rule has
## exactly one owner. Called by the trap at the moment it springs.
func on_eruption(trap: CinderTrap) -> void:
	eruptions += 1
	hit_events += trap.enemies_hit
	hit_damage_total += trap.eruption_damage * float(trap.enemies_hit)
	last_hit_event = "ERUPTION %s — Fire HIT %.1f x %d enemy(ies) %s; sprung by %s (entry t=%.4f, tie set %s)" \
		% [trap.use_id, trap.eruption_damage, trap.enemies_hit, str(trap.hit_ids), trap.trigger_id,
		   trap.trigger_entry_t, str(trap.trigger_tie_set)]
	# THE SAME EVENT, SHORT ENOUGH TO READ ON SCREEN. The full record above is
	# what the run log and the suite read; this is what the review HUD shows, so
	# no line of it is cut off at 1920 x 1080 (found by LOOKING, D-402).
	last_hit_brief = "%s: Fire HIT %.1f x %d, sprung by %s" \
		% [trap.use_id, trap.eruption_damage, trap.enemies_hit, trap.trigger_id]
	last_event = last_hit_event
	# A SPRUNG TRAP NO LONGER OCCUPIES AN INSTANCE SLOT. It leaves the instance
	# list at once; its node lingers only to be looked at.
	traps.erase(trap)
	var cfg := configuration()
	var rank := cfg.skill_rank() if cfg != null else ImprintConfig.RANK_MIN
	var g := CinderGround.new()
	g.name = "CinderGround_%d" % trap.ordinal
	g.radius = CinderConfig.GROUND_RADIUS_M
	g.duration = CinderConfig.GROUND_DURATION_S
	g.dps = CinderConfig.ground_dps_at(rank)
	g.origin_configuration = trap.origin_configuration
	g.use_id = trap.use_id
	g.ordinal = trap.ordinal
	field_parent.add_child(g)
	g.build()
	g.global_position = trap.global_position
	grounds.append(g)

func note_expired(trap: CinderTrap) -> void:
	expiries += 1
	last_event = "EXPIRED HARMLESSLY — trap %d waited out its %.1f s dormant Duration; no Hit, no burning Ground" \
		% [trap.ordinal, trap.dormant_duration]

## A trap node has left the scene. It is removed from BOTH lists, whichever it
## was still in, so no freed node is ever counted as an instance.
func note_trap_gone(trap: CinderTrap) -> void:
	traps.erase(trap)
	live_nodes.erase(trap)

# =============================================================================
# THE STEP
# =============================================================================

func _physics_process(delta: float) -> void:
	step(delta)

## Separated so the suite can drive exact steps. The traps and fields step
## themselves through their own `_physics_process`; this owns the lifecycle, the
## shared Ground cadence and the integrity sample.
func step(delta: float) -> void:
	_sync_equipped()
	_prune()
	_step_grounds(delta)
	frames_sampled += 1
	if not is_active() and (not traps.is_empty() or not grounds.is_empty() or not live_nodes.is_empty()):
		frames_inconsistent += 1

## ============================================================================
## CLEANUP ON DEACTIVATION OR UNEQUIP — AND NOTHING ELSE IS TOUCHED.
## ============================================================================
## It removes exactly what THIS runtime created: the traps in its own lists and
## the fields in its own list. It never walks the scene tree, never frees a node
## it did not make, and never touches another Skill's entities -- the hounds,
## their cohort, Splinter Shot's arrows and the diagnostic entities are all
## outside its reach by construction.
func _sync_equipped() -> void:
	if skills == null:
		return
	if is_active():
		return
	if traps.is_empty() and grounds.is_empty() and live_nodes.is_empty():
		return
	var st := binding_state()
	clear_owned("%s — %s" % [String(st["state"]), String(st["reason"])])

func clear_owned(reason: String) -> void:
	# ============================================================
	# ITERATE A COPY. `_free_trap()` ERASES FROM THESE VERY ARRAYS.
	# ============================================================
	# The first version walked `live_nodes` directly while `_free_trap()` erased
	# from it, so every second entry was SKIPPED and a trap survived a removal
	# that claimed to have cleared everything. The D-402 suite's E38 found it by
	# walking the live scene tree and counting what was actually left.
	for t in live_nodes.duplicate():
		if t != null and is_instance_valid(t):
			_free_trap(t)
	for g in grounds.duplicate():
		if g != null and is_instance_valid(g):
			g.alive = false
			if g.get_parent() != null:
				g.get_parent().remove_child(g)
			g.queue_free()
	traps = []
	live_nodes = []
	grounds = []
	_tick_accum = 0.0
	removals += 1
	last_removal_reason = reason
	last_event = "REMOVED — %s" % reason

func _free_trap(t) -> void:
	traps.erase(t)
	live_nodes.erase(t)
	if (t as Node).get_parent() != null:
		(t as Node).get_parent().remove_child(t)
	(t as Node).queue_free()

func _prune() -> void:
	var kt: Array = []
	for t in traps:
		if t != null and is_instance_valid(t) and (t as CinderTrap).is_dormant():
			kt.append(t)
	traps = kt
	var kn: Array = []
	for t in live_nodes:
		if t != null and is_instance_valid(t):
			kn.append(t)
	live_nodes = kn
	var kg: Array = []
	for g in grounds:
		if g != null and is_instance_valid(g) and (g as CinderGround).alive:
			kg.append(g)
	grounds = kg

# =============================================================================
# THE ONE ARBITER — CANON'S NON-STACKING GROUND RULE, AS ARITHMETIC
# =============================================================================

## ============================================================================
## ONE CADENCE, ONE CONTRIBUTION PER ENEMY, HOWEVER MANY FIELDS OVERLAP.
## ============================================================================
## The owner: "Overlapping Cinder Field ground areas must never multiply their
## damage on the same enemy. An enemy standing in one or several areas receives
## one Cinder Field ground-damage contribution."
##
## Canon says which one: "the STRONGEST applicable instance deals damage". An
## exact tie between equally strong fields goes to the OLDER one, by placement
## ordinal -- deterministic, and declared in `CinderConfig.duration_contract()`.
##
## The walk is over the REGISTRY's records, so the choice cannot depend on the
## order fields happen to sit in an array: each enemy independently selects its
## own strongest field.
func _step_grounds(delta: float) -> void:
	if grounds.is_empty():
		_tick_accum = 0.0
		return
	_tick_accum += delta
	while _tick_accum >= CinderConfig.GROUND_TICK_S:
		_tick_accum -= CinderConfig.GROUND_TICK_S
		_apply_ground_tick()

func _apply_ground_tick() -> void:
	if registry == null:
		return
	ground_ticks += 1
	var applied := 0
	var total := 0.0
	for rec in registry.records():
		var n = rec.get("node", null)
		# OUT-OF-TREE IS NOT STANDING IN A FIELD: a registered entity can be valid
		# and out of the tree, and reading `global_position` then is an engine
		# error (D-402, found by the runner's engine-error guard).
		if n == null or not is_instance_valid(n) or not (n is Node3D) or not (n as Node3D).is_inside_tree():
			continue
		if not bool(HitEligibility.evaluate(rec)["eligible"]):
			continue
		var best: CinderGround = _strongest_containing((n as Node3D).global_position)
		if best == null:
			continue
		var dmg := CinderConfig.ground_tick_damage(best.dps)
		n.receive_damage(dmg, best.global_position)
		SkillRuntime.record_damage(CinderConfig.LEDGER_SOURCE_GROUND, dmg, best.origin_configuration)
		best.damage_dealt += dmg
		best.contributions += 1
		ground_contributions += 1
		ground_damage_total += dmg
		applied += 1
		total += dmg
	if applied > 0:
		last_ground_event = "BURNING GROUND tick %d — %.1f Fire damage over time to %d enemy(ies), ONE contribution each from %d overlapping field(s)" \
			% [ground_ticks, total, applied, grounds.size()]
		# THE SAME TICK, SHORT ENOUGH TO READ ON SCREEN (see `last_hit_brief`).
		last_ground_brief = "tick %d: %.1f to %d enemy(ies), ONE each from %d field(s)" \
			% [ground_ticks, total, applied, grounds.size()]
		last_event = last_ground_event

## The STRONGEST field containing a point, with an exact tie going to the OLDER
## placement. Returns null when no field contains it.
func _strongest_containing(p: Vector3) -> CinderGround:
	var best: CinderGround = null
	for g in grounds:
		var f := g as CinderGround
		if f == null or not is_instance_valid(f) or not f.alive:
			continue
		if not f.contains_point(p):
			continue
		if best == null or f.dps > best.dps or (is_equal_approx(f.dps, best.dps) and f.ordinal < best.ordinal):
			best = f
	return best

## How many fields contain a point — the quantity the non-stacking claim is
## about. Read by the HUD and the suite; nothing branches on it.
func fields_containing(p: Vector3) -> int:
	var n := 0
	for g in grounds:
		var f := g as CinderGround
		if f != null and is_instance_valid(f) and f.alive and f.contains_point(p):
			n += 1
	return n

# =============================================================================
# THE REVIEW MODEL — everything the HUD shows, read NOW from live objects
# =============================================================================

func dormant_count() -> int:
	var n := 0
	for t in traps:
		if t != null and is_instance_valid(t) and (t as CinderTrap).is_dormant():
			n += 1
	return n

func armed_count() -> int:
	var n := 0
	for t in traps:
		if t != null and is_instance_valid(t) and (t as CinderTrap).is_armed():
			n += 1
	return n

func sprung_count() -> int:
	var n := 0
	for t in live_nodes:
		if t != null and is_instance_valid(t) and (t as CinderTrap).state == CinderConfig.PHASE_SPRUNG:
			n += 1
	return n

func review_snapshot() -> Dictionary:
	var cfg := configuration()
	var res := cfg.resolve() if cfg != null else {}
	var bs := binding_state()
	var rank := cfg.skill_rank() if cfg != null else 0
	var traps_out: Array = []
	for t in live_nodes:
		var tr := t as CinderTrap
		if tr != null and is_instance_valid(tr):
			traps_out.append(tr.snapshot())
	var grounds_out: Array = []
	for g in grounds:
		var gd := g as CinderGround
		if gd != null and is_instance_valid(gd):
			grounds_out.append(gd.snapshot())
	return {
		"state": String(bs["state"]), "reason": String(bs["reason"]),
		"binding": CinderContent.BINDING_INDEX + 1,
		"rank": rank,
		"mastered": skills.library.mastered(CinderContent.SKILL_CINDER_FIELD),
		"xp": skills.library.xp(CinderContent.SKILL_CINDER_FIELD),
		"cooldown": skills.cooldown_remaining(CinderContent.SKILL_CINDER_FIELD),
		"cost": float(res.get("mana_cost", 0.0)),
		"mana_current": skills.pool.mana_current, "mana_usable": skills.pool.mana_usable(),
		"dormant": dormant_count(), "armed": armed_count(), "sprung": sprung_count(),
		"cap": int(res.get("instances_max", CinderConfig.INSTANCES_MAX)),
		"fields": grounds.size(),
		"traps": traps_out, "grounds": grounds_out,
		"placements": placements, "refusals": placement_refusals,
		"eruptions": eruptions, "replacements": replacements, "expiries": expiries,
		"hit_events": hit_events, "hit_damage": hit_damage_total,
		"ground_ticks": ground_ticks, "ground_contributions": ground_contributions,
		"ground_damage": ground_damage_total,
		"last_hit": last_hit_event, "last_ground": last_ground_event,
		"last_hit_brief": last_hit_brief, "last_ground_brief": last_ground_brief,
		"last_refusal": last_refusal, "last_refusal_brief": last_refusal_brief,
		"last_event": last_event,
		"committed": player != null and player.commitment.active
			and player.commitment.label == CinderConfig.ACTION_LABEL,
		"phase": player.commitment.phase() if player != null and player.commitment.active else "none",
	}

# =============================================================================
# TEST SUPPORT
# =============================================================================

## Clears everything this runtime owns. TEST SETUP AND SCENE TEARDOWN ONLY; it is
## the same path `clear_owned()` uses in play, with a declared reason.
func dismiss_all() -> void:
	clear_owned("TEST FIXTURE — not a gameplay path")

## ============================================================================
## ZEROES THE DIAGNOSTIC LOG COUNTERS. TEST SETUP ONLY, AND DECLARED AS SUCH.
## ============================================================================
## Every counter it touches is a LOG, not control state: nothing in this runtime
## branches on one, and the D-402 suite asserts that by reading them only in
## notes and assertions. Zeroing them between checks is what lets a check say
## "ONE eruption" and mean it, instead of carrying the previous check's total.
## It is the same declared fixture the accepted `DiagBallista.reset_counters()`
## is, and GAMEPLAY NEVER CALLS IT.
func reset_counters() -> void:
	placements = 0
	placement_refusals = 0
	eruptions = 0
	replacements = 0
	expiries = 0
	ground_ticks = 0
	ground_contributions = 0
	hit_damage_total = 0.0
	ground_damage_total = 0.0
	hit_events = 0
	removals = 0
	frames_sampled = 0
	frames_inconsistent = 0
	last_refusal = ""
	last_event = ""
	last_hit_event = ""
	last_ground_event = ""
	last_hit_brief = ""
	last_ground_brief = ""
	last_refusal_brief = ""
	last_removal_reason = ""
