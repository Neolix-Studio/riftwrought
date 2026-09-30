class_name HoundRuntime
extends Node

## THE KINDRED HOUNDS STAGE'S RUNTIME (D-396) — the pack's existence, its
## low-friction recovery, the review loadout, and nothing else.
##
## ============================================================================
## WHERE EACH RULING IS IMPLEMENTED
## ============================================================================
##   C-01 a canonical Persistent Skill Imprint, rank 1 / 0 XP ... `setup()`, through
##        `HoundContent.learn_into()` and the accepted library, loadout and pool;
##   C-02 the labelled review loadout, Capacity not increased .. `apply_loadout_plan()`;
##   C-03 the percentage reservation ............. the ACCEPTED pipeline and
##        `ImprintLoadout.revalidate()` -- nothing here computes a reservation;
##   C-04 two hounds .............................. `_summon_pack()`;
##   C-08, C-09 targeting and abandonment ........ each `KindredHound`, through the
##        pure `HoundTargeting`;
##   C-12 the low-friction fallen-hound recovery .. `_step_recovery()`;
##   C-13 the pack follows its Persistent Configuration .. `_sync_pack()`, every step;
##   C-14 the review snapshot ..................... `review_snapshot()`.
##
## ---------------------------------------------------------------------------
## THE PACK EXISTS IF AND ONLY IF ITS PERSISTENT CONFIGURATION IS ACTIVE.
## ---------------------------------------------------------------------------
## "Deactivating, unequipping or losing the reservation must remove the pack
## truthfully; restoring a valid Persistent Configuration must restore it
## according to the accepted rules." So the pack never decides for itself: every
## physics step it asks the ACCEPTED loadout whether the Configuration is among
## `active_persistent_ids()` -- which `revalidate()` alone decides -- and removes
## or restores the whole pack to match, recording why.
##
## EVERY NUMBER IT USES IS PROVISIONAL (`HoundConfig.registry()`).
##
## ============================================================================
## D-398: THE PACK MOVES THROUGH THE SHARED MOBILE-MINION COHORT.
## ============================================================================
## This runtime builds ONE `MobileCohort` -- the shared system of which Kindred
## Hounds are the ONLY production consumer -- and every hound joins it at summon,
## REGISTERED in the area's combat-entity registry as an ALLY (the ruling's
## "stable combat-entity IDs determine slot assignment"). A summoned, resummoned
## or returning hound appears at its formation slot round HER.
##
## It also keeps the D-398 DIAGNOSTIC STRESS population: up to 13 more hound
## actors, labelled DIAGNOSTIC, existing only while the pack exists, removed
## highest combat-entity ID first. THEY ARE NOT THE PACK: `pack` stays the
## Configuration's `pack_size`, and no Configuration, reservation, Capacity or
## damage value moves (`CohortDiagnostics` is their one writer).

var main: Node = null
var player: Node3D = null
var skills: SkillRuntime = null
var registry: CombatEntityRegistry = null
var pack_parent: Node3D = null
var setup_ok: bool = false
var setup_problems: Array[String] = []

## The live pack, by pack index. EMPTY while the Persistent is not active.
var pack: Array = []
## Pack index -> seconds until that fallen hound returns.
var recovery: Dictionary = {}

## D-398: THE SHARED COHORT, and the DIAGNOSTIC STRESS minions beside the pack.
var cohort: MobileCohort = null
var stress: Array = []
var stress_wanted: int = 0
var stress_recovery: Dictionary = {}
var stress_summons: int = 0
var stress_removals: int = 0

## Diagnostics the suite and the HUD read. LOGS, not control state.
var summons: int = 0
var removals: int = 0
var returns: int = 0
var falls_seen: int = 0
var diagnostic_falls: int = 0
var last_pack_event: String = ""
var last_removal_reason: String = ""
var plan_applied: String = ""
var plans_applied: int = 0
## Integrity, sampled every step: a pack while inactive, or none while active.
var frames_sampled: int = 0
var frames_inconsistent: int = 0
## What the review loadout measured when it was applied.
var review_measure: Dictionary = {}

func setup(p_main: Node, p_player: Node3D, p_skills: SkillRuntime, huntress_runtime) -> bool:
	main = p_main
	player = p_player
	skills = p_skills
	# THE ACTIVE AREA'S ONE REGISTRY -- the one the Splinter Shot stage fills in
	# composition order. The hounds read it; they never register or reorder it.
	if huntress_runtime != null:
		registry = huntress_runtime.registry
	if registry == null:
		setup_problems.append("no combat-entity registry for the active area")
	pack_parent = Node3D.new()
	pack_parent.name = "KindredHoundsPack"
	add_child(pack_parent)
	# D-398: THE SHARED COHORT. Its first ring is the accepted D-396 follow
	# distance, so the ordinary pack stays at her side.
	cohort = MobileCohort.new(player, registry, FormationProfile.vanguard(), HoundConfig.FOLLOW_DISTANCE_M,
		NavService.map_rid_for(player))
	# KINDRED HOUNDS, THROUGH THE ACCEPTED ARCHITECTURE: learned at rank 1 / 0 XP,
	# one unmodified Configuration.
	if not HoundContent.learn_into(skills.library):
		setup_problems.append("Kindred Hounds were not learned (already known?)")
	var built := HoundContent.build_configuration(skills.library)
	if not bool(built["ok"]):
		setup_problems.append("the Kindred Hounds Configuration refused: %s" % String(built["reason"]))
	skills.configurations[HoundContent.CFG_KINDRED_HOUNDS] = built["configuration"]
	# THE REVIEW LOADOUT, measured before and after.
	var before := _measure()
	var r := apply_loadout_plan(HoundContent.review_loadout_plan())
	if not bool(r["ok"]):
		setup_problems.append("the review loadout refused: %s" % str(r["problems"]))
	review_measure = {"before": before, "after": _measure()}
	setup_ok = setup_problems.is_empty()
	if not setup_ok:
		push_error("D-396: the Kindred Hounds stage did not build: %s" % str(setup_problems))
	return setup_ok

func _measure() -> Dictionary:
	var lo := skills.loadout
	return {"bindings": lo.bindings.duplicate(), "persistent": lo.persistent.duplicate(),
		"used": lo.capacity_used(), "total": lo.capacity_total(), "demanded": lo.capacity_demanded(),
		"deactivated": lo.deactivated.duplicate(), "mana_reserved": skills.pool.mana_reserved,
		"life_reserved": skills.pool.life_reserved, "cycle": skills.reservation_cycle_configuration}

## ============================================================================
## APPLY A LOADOUT PLAN — through the accepted loadout operations only.
## ============================================================================
## Binds each of the eight bindings, sets the Persistent Loadout, names the
## Configuration the D-381 reservation cycle drives, revalidates, refills. Used
## at composition for the REVIEW loadout, and by the accepted suites (through
## `restore_accepted_d392_loadout()`) for the loadout they accepted. The pack
## follows on this very call -- no stale hound survives a plan.
func apply_loadout_plan(plan: Dictionary) -> Dictionary:
	var lo := skills.loadout
	var problems: Array[String] = []
	var b: Array = plan["bindings"]
	for i in lo.binding_count():
		var want := String(b[i]) if i < b.size() else ""
		var rb := lo.bind(i, want)
		if not bool(rb["ok"]):
			problems.append("binding %d: %s" % [i + 1, String(rb["reason"])])
	for pid in lo.persistent.duplicate():
		if not (plan["persistent"] as Array).has(pid):
			lo.remove_persistent(String(pid))
	for pid in plan["persistent"]:
		if not lo.persistent.has(pid):
			var rp := lo.add_persistent(String(pid))
			if not bool(rp["ok"]):
				problems.append("persistent %s: %s" % [String(pid), String(rp["reason"])])
	skills.reservation_cycle_configuration = String(plan["cycle"])
	lo.revalidate(skills.pool)
	skills.pool.refill()
	plan_applied = String(plan["label"])
	plans_applied += 1
	_sync_pack()
	return {"ok": problems.is_empty(), "problems": problems}

## ============================================================================
## THE ACCEPTED SUITES' DECLARED FIXTURE. NEVER CALLED IN NORMAL PLAY.
## ============================================================================
## The four accepted suites measure what D-373, D-376, D-383 and D-394 accepted --
## the D-392 loadout, with no pack in the scene -- so each calls this once after
## start-up, before its launch capture. It restores exactly that loadout: the
## hounds UNEQUIPPED (the pack removed by the same rule every removal follows),
## the diagnostic aura back as the one Persistent, the low-rank twin back on
## binding 4, the cycle back on the aura, and no Life Conversion left installed
## on either Persistent. The D-396 suite proves the result equals the pre-work
## loadout exactly, and that no runtime code calls it.
func restore_accepted_d392_loadout() -> Dictionary:
	for cid in [DiagImprintContent.CFG_AURA, HoundContent.CFG_KINDRED_HOUNDS]:
		var c := skills.loadout.configuration(String(cid)) as SkillConfiguration
		if c != null and c.has_modifier(DiagImprintContent.AUG_TITHE):
			c.remove(DiagImprintContent.AUG_TITHE)
	return apply_loadout_plan(HoundContent.accepted_d392_loadout_plan())

# =============================================================================
# THE STEP
# =============================================================================

func _physics_process(delta: float) -> void:
	step(delta)

func step(delta: float) -> void:
	_sync_pack()
	if cohort != null:
		cohort.ensure_updated(delta)
	_step_recovery(delta)
	if InputMap.has_action(HoundConfig.FALL_ACTION) and Input.is_action_just_pressed(HoundConfig.FALL_ACTION):
		diagnostic_fell_one()
	frames_sampled += 1
	var has_pack := not pack.is_empty()
	if is_sustained() != has_pack:
		frames_inconsistent += 1

## TRUE only when the accepted loadout holds the Configuration as an ACTIVE
## Persistent -- equipped, valid, supported. `revalidate()` alone decides that.
func is_sustained() -> bool:
	return skills != null and skills.loadout.active_persistent_ids().has(HoundContent.CFG_KINDRED_HOUNDS)

func configuration() -> SkillConfiguration:
	return skills.loadout.configuration(HoundContent.CFG_KINDRED_HOUNDS) as SkillConfiguration

## The Persistent state in words: ACTIVE, UNEQUIPPED, or DEACTIVATED with the
## accepted revalidation's own reason.
func persistent_state() -> Dictionary:
	var lo := skills.loadout
	if not lo.persistent.has(HoundContent.CFG_KINDRED_HOUNDS):
		return {"state": "UNEQUIPPED", "reason": "not in the Persistent Loadout — no reservation, no pack"}
	if lo.deactivated.has(HoundContent.CFG_KINDRED_HOUNDS):
		return {"state": "DEACTIVATED", "reason": String(lo.deactivated[HoundContent.CFG_KINDRED_HOUNDS])}
	return {"state": "ACTIVE", "reason": "sustained by its reservation"}

func _sync_pack() -> void:
	if skills == null:
		return
	var want := is_sustained()
	if want and pack.is_empty():
		_summon_pack()
	elif not want and not pack.is_empty():
		var ps := persistent_state()
		_remove_pack("%s — %s" % [String(ps["state"]), String(ps["reason"])])
	# D-398: the DIAGNOSTIC STRESS minions exist only beside a living pack.
	if not pack.is_empty():
		_sync_stress()
	# The bite value follows the Configuration's Effective Rank, through resolve().
	if not pack.is_empty():
		var dmg := float(configuration().resolve().get("damage", HoundConfig.BITE_DAMAGE_AT_RANK_1))
		for h in pack:
			if h != null and is_instance_valid(h):
				(h as KindredHound).bite_damage = dmg

## THE WHOLE PACK, at her side, full Life, following. No cost: the reservation
## that sustains it was already applied by the accepted revalidation.
func _summon_pack() -> void:
	var cfg := configuration()
	var res := cfg.resolve()
	var size := int(res.get("pack_size", HoundConfig.PACK_SIZE))
	recovery = {}
	for k in size:
		var h := KindredHound.new()
		h.name = "KindredHound_H%d" % (k + 1)
		pack_parent.add_child(h)
		h.setup(k, player, registry, float(res.get("damage", HoundConfig.BITE_DAMAGE_AT_RANK_1)),
			HoundContent.CFG_KINDRED_HOUNDS)
		_join_cohort(h)
		var look := HoundStandIn.new()
		h.add_child(look)
		look.build(h)
		h.global_position = _spawn_point(cohort.rank_of(h) if cohort != null else k)
		pack.append(h)
	summons += 1
	last_pack_event = "SUMMONED — %d hounds at her side (the Persistent Configuration is active)" % size

## Where the member of rank `k` appears: its formation slot round HER (the
## anchor's lead is not applied), on walkable ground -- at her side.
## (Until D-398 this was 1.7 m behind her at +/-55 degrees by pack index -- true
## when written; `FOLLOW_SIDE_DEG` is no longer read.) A map the navigation server
## has not synchronised yet FAILS a query with an engine error (measured at
## D-396), so the cohort returns the raw slot until it has.
func _spawn_point(k: int) -> Vector3:
	var p := cohort.spawn_point_for_rank(k) if cohort != null else player.global_position
	p.y = 0.0
	return p

## D-398: registered in the AREA's combat-entity registry as an ALLY -- in explicit
## spawn order, never in an engine callback -- and joined to the shared cohort.
## The general eligibility rule refuses an ally, so no arrow, bite or hound can
## target one.
func _join_cohort(h: KindredHound) -> void:
	if registry != null:
		h.combat_id = registry.register(h, "ally", "ally")
	h.cohort = cohort
	if cohort != null and not cohort.join(h):
		setup_problems.append("a hound could not join the cohort: %s" % cohort.last_refusal)

## TRUTHFUL REMOVAL: out of the tree NOW, freed, timers cleared, reason recorded.
## D-398: the DIAGNOSTIC STRESS minions go with it, and every member leaves the
## cohort.
func _remove_pack(reason: String) -> void:
	for h in pack + stress:
		if h != null and is_instance_valid(h):
			if cohort != null:
				cohort.leave(h)
			if (h as Node).get_parent() != null:
				(h as Node).get_parent().remove_child(h)
			(h as Node).queue_free()
	pack = []
	recovery = {}
	stress = []
	stress_recovery = {}
	removals += 1
	last_removal_reason = reason
	last_pack_event = "REMOVED — %s" % reason

# =============================================================================
# THE LOW-FRICTION RECOVERY
# =============================================================================

## A fallen hound returns after the PROVISIONAL delay, by itself: no input, no
## Mana, no reservation change, no resummon. It returns at its follow slot beside
## her, at full Life, and chooses afresh. (D-398: a DIAGNOSTIC STRESS minion
## returns the same way, on its own timers.)
func _step_recovery(delta: float) -> void:
	_step_stress_recovery(delta)
	for i in pack.size():
		var h := pack[i] as KindredHound
		if h == null or not is_instance_valid(h):
			continue
		if h.is_fallen() and not recovery.has(i):
			recovery[i] = HoundConfig.RECOVERY_DELAY_S
			falls_seen += 1
			last_pack_event = "H%d FELL — returning in %.1f s" % [i + 1, HoundConfig.RECOVERY_DELAY_S]
	for i in recovery.keys():
		var left := float(recovery[i]) - delta
		var h2 := pack[int(i)] as KindredHound
		if left <= 0.0:
			recovery.erase(i)
			if h2 != null and is_instance_valid(h2):
				h2.revive_at(_return_point(h2))
				returns += 1
				last_pack_event = "H%d RETURNED at her side" % (int(i) + 1)
		else:
			recovery[i] = left
		if h2 != null and is_instance_valid(h2):
			var look := _stand_in_of(h2)
			if look != null:
				look.returning_in = float(recovery.get(i, -1.0))

## D-398: its formation slot round HER -- the same place a summon appears.
func _return_point(h: KindredHound) -> Vector3:
	var r := cohort.rank_of(h) if cohort != null else h.index
	return _spawn_point(r)

func _step_stress_recovery(delta: float) -> void:
	for h in stress:
		var s := h as KindredHound
		if s != null and is_instance_valid(s) and s.is_fallen() and not stress_recovery.has(s.index):
			stress_recovery[s.index] = HoundConfig.RECOVERY_DELAY_S
	for k in stress_recovery.keys():
		var left := float(stress_recovery[k]) - delta
		var who: KindredHound = null
		for h in stress:
			if h != null and is_instance_valid(h) and (h as KindredHound).index == int(k):
				who = h
		if left <= 0.0:
			stress_recovery.erase(k)
			if who != null:
				who.revive_at(_return_point(who))
		else:
			stress_recovery[k] = left

# =============================================================================
# D-398: THE DIAGNOSTIC STRESS POPULATION — never the pack
# =============================================================================

## Sets the DIAGNOSTIC population: the pack plus stress minions. The canonical pack
## is untouched -- `pack` stays the Configuration's `pack_size`.
func set_diagnostic_population(total: int) -> void:
	stress_wanted = maxi(0, total - HoundConfig.PACK_SIZE)
	_sync_pack()

func population() -> int:
	return pack.size() + stress.size()

## Every cohort member: the pack, then the stress minions.
func members() -> Array:
	return pack + stress

## Adds stress minions up to the wanted number, or removes the one with the
## HIGHEST combat-entity ID until it is met -- so the remaining members keep their
## ranks and their slots.
func _sync_stress() -> void:
	while stress.size() < stress_wanted:
		_summon_stress()
	while stress.size() > stress_wanted:
		var last: KindredHound = stress[0]
		for h in stress:
			if registry.precedes(last.combat_id, (h as KindredHound).combat_id):
				last = h
		stress.erase(last)
		stress_recovery.erase(last.index)
		if cohort != null:
			cohort.leave(last)
		if last.get_parent() != null:
			last.get_parent().remove_child(last)
		last.queue_free()
		stress_removals += 1

func _summon_stress() -> void:
	var k := HoundConfig.PACK_SIZE + stress.size()
	var res := configuration().resolve()
	var h := KindredHound.new()
	h.name = "DiagnosticStressMinion_S%d" % (k + 1)
	pack_parent.add_child(h)
	h.setup(k, player, registry, float(res.get("damage", HoundConfig.BITE_DAMAGE_AT_RANK_1)),
		HoundContent.CFG_KINDRED_HOUNDS)
	h.diagnostic_stress = true
	h.ledger_source = CohortConfig.STRESS_LEDGER_SOURCE
	_join_cohort(h)
	var look := HoundStandIn.new()
	h.add_child(look)
	look.build(h)
	h.global_position = _spawn_point(cohort.rank_of(h) if cohort != null else k)
	stress.append(h)
	stress_summons += 1

func _stand_in_of(h: KindredHound) -> HoundStandIn:
	for c in h.get_children():
		if c is HoundStandIn:
			return c
	return null

## ============================================================================
## THE DIAGNOSTIC REVIEW CONTROL — key H / pad D-pad left. NOT A COMMAND.
## ============================================================================
## Ordinary enemies cannot damage hounds in this slice, so the owner could never
## SEE a hound fall. This fells the LOWEST-NUMBERED living hound by dealing its
## remaining Life through the hound's OWN damage path -- where an enemy area
## attack would arrive. It orders nothing, selects no target, and nothing in the
## mechanics reads it.
func diagnostic_fell_one() -> Dictionary:
	for h in pack:
		var hound := h as KindredHound
		if hound != null and is_instance_valid(hound) and not hound.is_fallen():
			hound.receive_damage(hound.life.life, player.global_position, HoundConfig.FALL_SOURCE)
			diagnostic_falls += 1
			return {"ok": true, "index": hound.index}
	return {"ok": false, "index": -1}

# =============================================================================
# THE REVIEW MODEL — everything the HUD shows, read NOW from live objects.
# =============================================================================

func living_count() -> int:
	var n := 0
	for h in pack:
		if h != null and is_instance_valid(h) and not (h as KindredHound).is_fallen():
			n += 1
	return n

func returning_count() -> int:
	return recovery.size()

func review_snapshot() -> Dictionary:
	var cfg := configuration()
	var res := cfg.resolve() if cfg != null else {}
	var ps := persistent_state()
	var pool := skills.pool
	var hounds: Array = []
	for h in pack:
		var hd := h as KindredHound
		if hd == null or not is_instance_valid(hd):
			continue
		hounds.append({"index": hd.index, "state": hd.state_name(), "target": hd.target_id(),
			"code": hd.reason_code, "text": hd.reason_text,
			"returning_in": float(recovery.get(hd.index, -1.0))})
	return {
		"state": String(ps["state"]), "reason": String(ps["reason"]),
		"rank": cfg.skill_rank() if cfg != null else 0,
		"mastered": skills.library.mastered(HoundContent.SKILL_KINDRED_HOUNDS),
		"xp": skills.library.xp(HoundContent.SKILL_KINDRED_HOUNDS),
		"resource": String(res.get("reserve_resource", "none")),
		"fraction": float(res.get("reserve_fraction", 0.0)),
		"amount": float(res.get("reserve_amount", 0.0)),
		"mana_basis": float(res.get("reserve_fraction_mana_basis", 0.0)),
		"ratio": float(res.get("conversion_ratio", 0.0)),
		"mana_reserved": pool.mana_reserved, "mana_usable": pool.mana_usable(), "mana_max": pool.mana_max,
		"life_reserved": pool.life_reserved, "life_usable": pool.life_usable(), "life_max": pool.life_max,
		"regen": pool.regen_per_second(),
		"living": living_count(), "returning": returning_count(), "pack_size": pack.size(),
		"hounds": hounds, "last_event": last_pack_event,
		"cycle_state": skills.reservation_state(),
	}
