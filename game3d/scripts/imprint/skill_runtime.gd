class_name SkillRuntime
extends Node

## THE SKILL RUNTIME — where a Skill Use happens, and the ONLY place it does.
##
## ============================================================================
## THIS IS NOT ON THE PLAYER CONTROLLER, AND THAT IS ARCHITECTURE, NOT A DODGE.
## ============================================================================
## The accepted `PlayerController` composes four small pieces and owns navigation
## plus THE ONE diagnostic action the foundation declares. It gains no attack
## entry point from this stage: `DIAGNOSTIC_ACTIONS` stays at one and `F51` still
## asserts it.
##
## Skill Uses live HERE because a Skill system is a different concern from a
## locomotion controller -- and because the accepted file must be preserved
## truthfully, which is D-373's own condition for continuing this project.
##
## **The new suite pins the EXHAUSTIVE set of action entry points across the
## whole project, in both directions** -- a BROADER guard than `F51`, not a
## weaker one.
##
## ---------------------------------------------------------------------------
## THE CANONICAL DIRECT-USE SEQUENCE, IN ORDER, WITH NOTHING SKIPPED.
## ---------------------------------------------------------------------------
## `design/SKILLS_AND_SKILL_MODIFICATION.md` section 15:
##   Input -> Wind-up -> Release -> Recovery
##   "The Skill cost is checked and paid when use begins. A Skill cannot begin
##    without sufficient resources."
##   "A cooldown begins on SUCCESSFUL RELEASE."
##   "One input activation is one Skill Use, even if an Augment causes several
##    repeats, projectiles, impacts, or pulses."
##   "Cooldowns belong to the base Skill and remain shared across its
##    configurations by default."
##
## All five are implemented literally, and each has its own check.
##
## ---------------------------------------------------------------------------
## IT USES THE ACCEPTED ActionCommitment, UNCHANGED.
## ---------------------------------------------------------------------------
## D-373 accepted the STOP / ALLOW architecture and the recovery-cancellation
## behaviour. THIS STAGE ADDS NO THIRD POLICY, NO NEW CANCEL WINDOW AND NO NEW
## TUNABLE, and it reuses the accepted release marker rather than inventing one.
##
## A RELEASED PROJECTILE, A PLACED BALLISTA AND A SUMMONED BEAST ALL SURVIVE A
## RECOVERY CANCELLATION, because the cancel touches an ANIMATION and the
## release has already happened by the time the window opens.
##
## EVERY NUMBER IT USES IS PROVISIONAL. NOTHING HERE IS A HUNTRESS SKILL.
## (True when written, D-375 to D-392. Since D-392 ONE canonical Skill Imprint,
## Splinter Shot, is bound and used through this same path; every diagnostic
## Imprint is still diagnostic, and every number is still PROVISIONAL.)

signal skill_used(binding_index: int, configuration_id: String)
signal combat_progress_awarded(amount: float, distinct: int)

## The eight canonical binding actions. EIGHT, and the suite asserts eight.
const BINDING_ACTIONS := [
	"imprint_binding_1", "imprint_binding_2", "imprint_binding_3", "imprint_binding_4",
	"imprint_binding_5", "imprint_binding_6", "imprint_binding_7", "imprint_binding_8",
]

## ============================================================================
## THE EXHAUSTIVE SET OF ACTION ENTRY POINTS IN THIS PROJECT.
## ============================================================================
## Pinned in BOTH directions by the new suite. The accepted foundation declares
## ONE diagnostic action; this stage declares its diagnostic Skill Imprints. The
## union is stated here so the project-level count can never drift unnoticed --
## which is a stronger claim than `F51`'s controller-local one.
static func all_action_entry_points() -> Array:
	var out: Array = []
	out.append_array(PlayerController.DIAGNOSTIC_ACTIONS)
	for id in DiagImprintContent.ALL_IMPRINTS:
		var s := String(id)
		if s.begins_with("SKILL_IMPRINT_"):
			out.append(s)
	# D-392: the ONE canonical Skill Imprint, Splinter Shot. 5 + 1 = 6. Until
	# D-392 the set held the diagnostic bolt and four diagnostic Skill Imprints --
	# true when written.
	for id in HuntressContent.ALL_IMPRINTS:
		var h := String(id)
		if h.begins_with("SKILL_IMPRINT_"):
			out.append(h)
	# D-396: Kindred Hounds, a Persistent Skill Imprint -- counted exactly as the
	# diagnostic Persistent aura has been since D-375 (every Skill Imprint is an
	# entry point of the Skill system, whether or not a binding activates it).
	# 6 + 1 = 7. It has NO binding and NO input.
	for id in HoundContent.ALL_IMPRINTS:
		var k := String(id)
		if k.begins_with("SKILL_IMPRINT_"):
			out.append(k)
	# D-402: Cinder Field, a canonical ACTIVE Skill Imprint on binding 7. 7 + 1 = 8.
	for id in CinderContent.ALL_IMPRINTS:
		var c := String(id)
		if c.begins_with("SKILL_IMPRINT_"):
			out.append(c)
	return out

var library: ImprintLibrary
var configurations: Dictionary = {}
var loadout: ImprintLoadout
var pool := ResourcePool.new()

var player: PlayerController
var entity_parent: Node
var bolt_parent: Node
var enemies_provider: Callable = Callable()

## ============================================================================
## THE D-392 HUNTRESS RUNTIME, WHEN ONE IS COMPOSED IN. NULL OTHERWISE.
## ============================================================================
## Splinter Shot is a Skill Use like every other: it is bound, costed, committed
## and released HERE. The Huntress runtime only does what a Splinter Shot use
## needs beyond that -- the facing snap at use start, the placeholder animation,
## and the arrow. With this null the D-375/D-380 runtime is exactly as it was.
var huntress = null
## ============================================================================
## THE D-402 CINDER FIELD RUNTIME, WHEN ONE IS COMPOSED IN. NULL OTHERWISE.
## ============================================================================
## Cinder Field is a Skill Use like every other: it is bound, costed, committed
## and released HERE. The Cinder runtime only does what a Cinder Field use needs
## beyond that -- validating the ground point BEFORE the use begins, and placing
## the trap at the mechanical release. With this null the runtime is exactly as
## D-394 accepted it.
var cinder = null
## Per binding: a HELD repeatable use that was refused (e.g. for Mana) is refused
## ONCE per hold, not every frame -- so the refusal is shown, never spammed.
var _held_refusal_latched: Dictionary = {}

## Live entities this runtime owns.
var ballistae: Array = []
var beasts: Array = []
var orbits: Array = []

## Diagnostics the suite and the panel read.
var skill_uses: int = 0
var uses_refused: int = 0
var last_refusal: String = ""
var releases: int = 0
var edits_refused: int = 0
var edits_allowed: int = 0
var second_transform_attempts: int = 0
var second_transform_refusals: int = 0
var last_trial_result: String = ""

## The DIAGNOSTIC safe-state override (conflict X-08). It is ON by default
## because this panel exists to be used in a live arena that acquires the player
## within seconds -- and it is LOUDLY LABELLED, COUNTED, and asserted by the
## suite to be a declared seam rather than a silent bypass. With it OFF the
## canonical refusal is proved to fire.
var diagnostic_safe_state_override: bool = true

## Shared cooldowns, keyed by SKILL IMPRINT ID -- never by Configuration.
## That key IS the canonical shared-cooldown rule: two Configurations of one
## Skill cannot each carry their own timer, because there is only one entry.
var _cooldowns: Dictionary = {}
var _dead_seen: Dictionary = {}

## ============================================================================
## TARGETING IS PER-USE. SAMPLED WHEN THE USE BEGINS, USED ONCE, THEN CLEARED.
## ============================================================================
## Canon is exact (`design/COMBAT_IDENTITY_AND_MOMENT_TO_MOMENT.md` section 12,
## locked by D-193): "A skill samples the cursor WHEN THAT SKILL USE BEGINS",
## "Held and repeated skills re-evaluate the cursor for EVERY use", and mouse
## combat has "no persistent mechanical selection".
##
## THE FIRST VERSION OF THIS RUNTIME READ `player.aim_dir` AT THE RELEASE, which
## is a DIFFERENT MOMENT: the aim keeps updating through the wind-up, so swinging
## the cursor mid-action would have dragged the projectile, the ground target and
## the summon circle with it. That is persistent targeting wearing a per-use
## coat, and canon forbids it.
##
## THE RENDERED EVIDENCE IS WHAT EXPOSED IT. No check in this suite looked at
## the moment of sampling, and the accepted `PlayerController` had already solved
## the same problem with `_shot_aim_dir`; this is the same fix, and I101 now
## measures it.
var _use_aim_dir: Vector3 = Vector3.ZERO
var _use_aim_point: Vector3 = Vector3.ZERO

# =============================================================================
# THE DAMAGE LEDGER — static, because projectiles free themselves on impact
# =============================================================================
#
# The comparison the ruling asks for -- "ordinary bow damage versus autonomous
# beast-primary damage" -- needs damage ATTRIBUTED BY SOURCE. A projectile that
# queue_free()s itself the instant it lands cannot report afterwards, so it
# reports at the moment of impact into a static ledger.

static var _ledger: Dictionary = {}
static var _ledger_by_configuration: Dictionary = {}

static func record_damage(source: String, amount: float, configuration_id: String = "") -> void:
	_ledger[source] = float(_ledger.get(source, 0.0)) + amount
	if configuration_id != "":
		_ledger_by_configuration[configuration_id] = \
			float(_ledger_by_configuration.get(configuration_id, 0.0)) + amount

static func ledger() -> Dictionary:
	return _ledger.duplicate()

static func ledger_by_configuration() -> Dictionary:
	return _ledger_by_configuration.duplicate()

static func ledger_total() -> float:
	var t := 0.0
	for k in _ledger:
		t += float(_ledger[k])
	return t

static func ledger_share(source: String) -> float:
	var t := ledger_total()
	return 0.0 if t <= 0.0 else float(_ledger.get(source, 0.0)) / t

static func reset_ledger() -> void:
	_ledger = {}
	_ledger_by_configuration = {}

# =============================================================================
# SET-UP
# =============================================================================

func compose() -> void:
	library = DiagImprintContent.build_library()
	configurations = DiagImprintContent.build_configurations(library)
	var problems: Array = configurations.get("__problems", [])
	configurations.erase("__problems")
	if not problems.is_empty():
		# A BUILD STEP THAT SILENTLY FAILED WOULD PRODUCE A CONFIGURATION THE
		# PANEL DESCRIBES AND THE RUNTIME DOES NOT HAVE. Refuse to be quiet.
		push_error("IMPRINT STAGE: Configuration build refused a step: %s" % str(problems))
	loadout = ImprintLoadout.new(library, configurations)
	# D-382: the live pool governs the player's live Health ledger, linked BEFORE
	# the first revalidation so the very first reservation already applies.
	if player != null:
		pool.health = player.life
	var plan := DiagImprintContent.default_binding_plan()
	for i in plan.size():
		var r := loadout.bind(i, String(plan[i]))
		if not r["ok"]:
			push_error("IMPRINT STAGE: binding %d refused: %s" % [i + 1, r["reason"]])
	for pid in DiagImprintContent.default_persistent_plan():
		var rp := loadout.add_persistent(String(pid))
		if not rp["ok"]:
			push_error("IMPRINT STAGE: Persistent slot refused: %s" % rp["reason"])
	pool.refill()
	loadout.revalidate(pool)
	pool.refill()

# =============================================================================
# THE USE PATH
# =============================================================================

func _physics_process(delta: float) -> void:
	step(delta)

## Separated so the suite can drive exact steps.
func step(delta: float) -> void:
	for k in _cooldowns.keys():
		_cooldowns[k] = maxf(0.0, float(_cooldowns[k]) - delta)
	pool.regenerate(delta)
	_award_for_defeated_enemies()
	_step_orbits(delta)
	_prune()
	_sync_aura_to_beasts()
	for i in BINDING_ACTIONS.size():
		if InputMap.has_action(BINDING_ACTIONS[i]) \
				and Input.is_action_just_pressed(BINDING_ACTIONS[i]):
			_held_refusal_latched.erase(i)
			use_binding(i)
		elif InputMap.has_action(BINDING_ACTIONS[i]) \
				and Input.is_action_pressed(BINDING_ACTIONS[i]):
			_held_repeat(i)
		else:
			_held_refusal_latched.erase(i)
	# D-381: the ONE diagnostic reservation input. Not a Skill Use.
	if InputMap.has_action(RESERVATION_CYCLE_ACTION) \
			and Input.is_action_just_pressed(RESERVATION_CYCLE_ACTION):
		cycle_reservation_state()

## The aim this use sampled. ZERO between uses, and the suite asserts that.
func sampled_aim_dir() -> Vector3:
	return _use_aim_dir

func sampled_aim_point() -> Vector3:
	return _use_aim_point

func cooldown_remaining(skill_imprint_id: String) -> float:
	return float(_cooldowns.get(skill_imprint_id, 0.0))

## ============================================================================
## HOLD TO REPEAT — D-392, for REPEATABLE Configurations only (Splinter Shot).
## ============================================================================
## Canon: "holding an eligible skill input to repeat its use" (combat section 2);
## "holding a repeatable skill continues using it and updates aim between uses"
## (section 12); "Holding a repeatable Skill begins another use when targeting,
## resources, and restrictions permit" (Skills section 15). A held input begins
## the next use on the first frame NO action is committed -- held repeat at
## exactly the action time -- and every use samples the aim anew. The diagnostic
## Configurations are NOT repeatable and keep their accepted press-only use.
func _held_repeat(index: int) -> void:
	if index < 0 or index >= loadout.bindings.size() or player == null:
		return
	var cfg_id: String = loadout.bindings[index]
	if cfg_id == "":
		return
	var cfg := loadout.configuration(cfg_id) as SkillConfiguration
	if cfg == null or not HuntressContent.is_repeatable(cfg.skill_id):
		return
	if player.commitment.active or cooldown_remaining(cfg.skill_id) > 0.0:
		return
	if _held_refusal_latched.has(index):
		return
	var r := use_binding(index)
	if not r["ok"]:
		_held_refusal_latched[index] = true

## ============================================================================
## ONE INPUT ACTIVATION IS ONE SKILL USE. IT IS COUNTED HERE, EXACTLY ONCE.
## ============================================================================
## Several projectiles, forks, ballista bolts or beasts do NOT make several uses,
## which is why `skill_uses` is incremented here and nowhere else.
func use_binding(index: int) -> Dictionary:
	if index < 0 or index >= loadout.bindings.size():
		return _refuse_use("binding %d does not exist" % (index + 1))
	var cfg_id: String = loadout.bindings[index]
	if cfg_id == "":
		# AN EMPTY BINDING DOES NOTHING, AND IT SAYS SO.
		return _refuse_use("binding %d is EMPTY. Eight bindings exist; %d of them hold a Configuration"
			% [index + 1, loadout.equipped_active_count()])
	if loadout.deactivated.has(cfg_id):
		return _refuse_use("binding %d holds '%s', which is DEACTIVATED: %s"
			% [index + 1, cfg_id, loadout.deactivated[cfg_id]])
	var cfg := loadout.configuration(cfg_id) as SkillConfiguration
	var v := cfg.validate()
	if not v["valid"]:
		return _refuse_use("'%s' is INVALID and cannot be used: %s" % [cfg_id, str(v["problems"])])
	# SHARED COOLDOWN, KEYED ON THE SKILL IMPRINT.
	var cd := cooldown_remaining(cfg.skill_id)
	if cd > 0.0:
		return _refuse_use("'%s' shares the cooldown of Skill Imprint '%s', which has %.3f s remaining"
			% [cfg_id, cfg.skill_id, cd])
	if player == null:
		return _refuse_use("no player is composed in")
	if player.commitment.active:
		return _refuse_use("an action is already committed (%s, %s)"
			% [player.commitment.label, player.commitment.phase()])
	var res := cfg.resolve()
	# ========================================================================
	# D-402: A GROUND-TARGETED SKILL VALIDATES ITS TARGET BEFORE IT BEGINS.
	# ========================================================================
	# Canon section 15 checks and pays the cost when the use begins; a use that
	# cannot legally be delivered never begins at all, so NO Mana is spent, NO
	# commitment starts and NO cooldown runs. The refusal states WHY, and the
	# Cinder runtime records it so the review HUD can show it.
	if String(res["delivery"]) == "cinder_trap" and cinder != null:
		var place: Dictionary = cinder.validate_placement(player.aim_point)
		if not bool(place["ok"]):
			cinder.note_refusal(String(place["reason"]), String(place.get("brief", "")))
			return _refuse_use("'%s' cannot be placed there: %s" % [cfg_id, String(place["reason"])])
	# COST IS CHECKED AND PAID WHEN THE USE BEGINS.
	var cost := float(res["mana_cost"])
	if not pool.spend_mana(cost):
		return _refuse_use("'%s' costs %.1f Mana and only %.1f of %.1f usable is available"
			% [cfg_id, cost, pool.mana_current, pool.mana_usable()])
	# ENTER THE ACCEPTED COMMITMENT. STOP policy, and the ACCEPTED release marker.
	# SAMPLE THE AIM HERE, WHEN THE USE BEGINS. Nothing downstream reads the live
	# aim again, and the suite asserts the fields are ZERO between uses.
	_use_aim_dir = player.aim_dir
	_use_aim_point = player.aim_point
	# D-392: Splinter Shot, the ONE canonical Skill, is labelled as what it is and
	# hands the commitment its DERIVED marker (release / action). Every diagnostic
	# Configuration keeps "(DIAGNOSTIC IMPRINT)" and the ACCEPTED 0.36 -- `resolve()`
	# supplies exactly that -- so nothing D-375/D-380 accepted moves.
	var splinter := String(res["delivery"]) == "splinter_arrow"
	# D-402: Cinder Field is labelled as what it is, exactly as Splinter Shot is.
	var cinder_use := String(res["delivery"]) == "cinder_trap"
	var action_label := HuntressConfig.SPLINTER_ACTION_LABEL if splinter \
		else (CinderConfig.ACTION_LABEL if cinder_use else "%s (DIAGNOSTIC IMPRINT)" % cfg_id)
	# The Skill Use ID -- canon's stable combat identifier for a use.
	var use_id := "SU-%d" % (skill_uses + 1)
	var started: bool = player.commit_subsystem_action(
		action_label,
		float(res["action_duration"]),
		float(res.get("release_marker", ProdConfig.ATTACK_RELEASE_MARKER)),
		func() -> void: _release(cfg_id, res, use_id))
	if not started:
		_use_aim_dir = Vector3.ZERO
		_use_aim_point = Vector3.ZERO
		return _refuse_use("the commitment refused to begin")
	skill_uses += 1
	if splinter and huntress != null:
		huntress.on_use_began(use_id, cfg_id, res, _use_aim_dir)
	skill_used.emit(index, cfg_id)
	return {"ok": true, "reason": "", "configuration": cfg_id, "cost": cost, "use_id": use_id}

func _refuse_use(reason: String) -> Dictionary:
	uses_refused += 1
	last_refusal = reason
	return {"ok": false, "reason": reason}

## ============================================================================
## THE RELEASE. THE COOLDOWN BEGINS HERE, ON SUCCESSFUL RELEASE. CANON'S RULE.
## ============================================================================
func _release(cfg_id: String, res: Dictionary, use_id: String = "") -> void:
	releases += 1
	var cfg := loadout.configuration(cfg_id) as SkillConfiguration
	_cooldowns[cfg.skill_id] = float(res["cooldown"])
	# THE AIM SAMPLED AT USE START, not the live aim. If it is somehow empty the
	# live aim is used as a fallback, exactly as the accepted bolt does.
	var use_dir := _use_aim_dir
	if use_dir.length() < 0.001:
		use_dir = player.aim_dir
	var use_point := _use_aim_point
	match String(res["delivery"]):
		"projectile":
			_fire_volley(cfg_id, res, use_dir)
		"rain":
			_fire_rain(cfg_id, res, use_point)
		"orbit":
			_open_orbit(cfg_id, res)
		"ballista":
			_place_ballista(cfg_id, res, use_point)
		"beasts":
			_summon_beasts(cfg_id, res)
		# D-392: Splinter Shot's ONE arrow, by the Huntress runtime -- on the
		# SAMPLED aim, never the live one.
		"splinter_arrow":
			if huntress != null:
				huntress.release_arrow(cfg_id, res, use_dir, use_id)
		# D-402: Cinder Field's ONE trap, at the SAMPLED ground point -- never the
		# live aim. Nothing exists before this moment.
		"cinder_trap":
			if cinder != null:
				cinder.place_trap(cfg_id, res, use_point, use_id)
	# PER-USE: NOTHING SURVIVES THE USE.
	_use_aim_dir = Vector3.ZERO
	_use_aim_point = Vector3.ZERO

func _projectile_spec(res: Dictionary) -> Dictionary:
	return {
		"projectiles": int(res["projectiles"]),
		"spread_deg": float(res["spread_deg"]),
		"damage": float(res["damage"]),
		"speed": ImprintConfig.STORM_PROJECTILE_SPEED,
		"fork_children": int(res["fork_children"]),
		"fork_generations": int(res["fork_generations"]),
		"fork_fraction": float(res["fork_fraction"]),
	}

func _fire_volley(cfg_id: String, res: Dictionary, dir: Vector3) -> void:
	if bolt_parent == null:
		return
	var count: int = maxi(1, int(res["projectiles"]))
	var spread: float = float(res["spread_deg"])
	for k in count:
		var offset := 0.0
		if count > 1:
			offset = lerpf(-spread, spread, float(k) / float(count - 1))
		var b := DiagProjectile.new()
		b.damage = float(res["damage"])
		b.tint = ImprintConfig.COL_STORM
		b.fork_children = int(res["fork_children"])
		b.fork_generations = int(res["fork_generations"])
		b.fork_fraction = float(res["fork_fraction"])
		b.source_label = "player_direct"
		b.origin_configuration = cfg_id
		bolt_parent.add_child(b)
		b.build(dir.rotated(Vector3.UP, deg_to_rad(offset)))
		b.global_position = player.global_position + Vector3(0, 1.15, 0) + dir * 0.45

## Splinter Rain: the same projectiles, arriving at the aimed ground point
## instead of travelling from the character. The TARGETING ARCHETYPE changed, and
## the delivery follows it.
func _fire_rain(cfg_id: String, res: Dictionary, ground_point: Vector3) -> void:
	if bolt_parent == null:
		return
	var ground := ground_point
	var volleys: int = maxi(1, int(res["rain_volleys"]))
	var count: int = maxi(1, int(res["projectiles"]))
	for v in volleys:
		for k in count:
			var b := DiagProjectile.new()
			b.damage = float(res["damage"]) / float(volleys)
			b.tint = ImprintConfig.COL_STORM
			b.max_range = 3.2
			b.source_label = "player_direct"
			b.origin_configuration = cfg_id
			bolt_parent.add_child(b)
			var ang := TAU * (float(k) + float(v) * 0.5) / float(maxi(1, count))
			var from := ground + Vector3(cos(ang), 0, sin(ang)) * (1.4 + 0.5 * float(v))
			b.build((ground - from).normalized())
			b.global_position = from + Vector3(0, 1.0, 0)

## Tempest Orbit: a self-centred pulsing storm. Kept as a small record stepped by
## this runtime rather than as a new node type, because the ruling asked for the
## minimum coherent content and a fourth entity class would not be it.
func _open_orbit(cfg_id: String, res: Dictionary) -> void:
	orbits.append({
		"configuration": cfg_id,
		"remaining": float(res["orbit_duration"]),
		"interval": float(res["orbit_pulse_interval"]),
		"cooldown": 0.0,
		"radius": float(res["orbit_radius"]),
		"damage": float(res["damage"]) * 0.42,
		"pulses": 0,
	})

func _step_orbits(delta: float) -> void:
	var keep: Array = []
	for o in orbits:
		o["remaining"] = float(o["remaining"]) - delta
		o["cooldown"] = maxf(0.0, float(o["cooldown"]) - delta)
		if float(o["cooldown"]) <= 0.0 and player != null:
			o["cooldown"] = float(o["interval"])
			o["pulses"] = int(o["pulses"]) + 1
			for e in _enemies():
				if e == null or not is_instance_valid(e):
					continue
				if e.has_method("is_dead") and e.is_dead():
					continue
				if NavService.planar_distance(player.global_position,
						(e as Node3D).global_position) <= float(o["radius"]):
					e.receive_damage(float(o["damage"]), player.global_position)
					SkillRuntime.record_damage("player_direct", float(o["damage"]),
						String(o["configuration"]))
		if float(o["remaining"]) > 0.0:
			keep.append(o)
	orbits = keep

## THE INSTANCE LIMIT, AND THE OLDEST REPLACED. Canon's own rule.
func _place_ballista(cfg_id: String, res: Dictionary, ground_point: Vector3) -> void:
	if entity_parent == null:
		return
	var limit: int = maxi(1, int(res["instances_max"]))
	_prune()
	while ballistae.size() >= limit:
		var oldest = ballistae.pop_front()
		if oldest != null and is_instance_valid(oldest):
			DiagBallista.note_replacement()
			oldest.queue_free()
	var b := DiagBallista.new()
	b.duration = float(res["duration"])
	b.fire_interval = float(res["fire_interval"])
	b.projectile_spec = _projectile_spec(res)
	b.origin_configuration = cfg_id
	b.enemies_provider = func() -> Array: return _enemies()
	entity_parent.add_child(b)
	b.build(bolt_parent)
	var dest := ground_point
	if NavService.planar_distance(dest, player.global_position) > ImprintConfig.BALLISTA_PLACE_RANGE:
		var d := (dest - player.global_position)
		d.y = 0.0
		dest = player.global_position + d.normalized() * ImprintConfig.BALLISTA_PLACE_RANGE
	# A GROUND-TARGETED SKILL VALIDATES ITS DESTINATION, exactly as the canonical
	# click-to-move does: the nearest navigable point, never a silent drop.
	# The map comes from the PLAYER, which is a Node3D. This runtime is a plain
	# Node and has no World3D of its own to ask.
	b.global_position = NavService.nearest_point(NavService.map_rid_for(player), dest)
	b.global_position.y = 0.0
	ballistae.append(b)

func _summon_beasts(cfg_id: String, res: Dictionary) -> void:
	if entity_parent == null:
		return
	_prune()
	var want: int = maxi(1, int(res["beast_count"]))
	for b in beasts:
		if b != null and is_instance_valid(b):
			b.dismiss()
	beasts = []
	var corpus: AnimationLibrary = null
	var root := entity_parent
	if root != null and root.get_parent() != null:
		corpus = root.get_parent().get("corpus")
	for k in want:
		var beast := DiagBeast.new()
		beast.name = "DiagBeast%d" % k
		beast.player = player
		beast.damage = float(res["damage"])
		beast.origin_configuration = cfg_id
		beast.enemies_provider = func() -> Array: return _enemies()
		entity_parent.add_child(beast)
		beast.setup(corpus)
		var ang := TAU * float(k) / float(want)
		beast.global_position = player.global_position \
			+ Vector3(cos(ang), 0, sin(ang)) * 1.5
		beasts.append(beast)
	_sync_aura_to_beasts()

## The aura's support for the beasts, applied live so the panel's claim is a
## number rather than a promise.
func _sync_aura_to_beasts() -> void:
	var bonus := 0.0
	for pid in loadout.active_persistent_ids():
		var cfg := loadout.configuration(String(pid)) as SkillConfiguration
		var r := cfg.resolve()
		bonus += float(r["beast_damage_bonus"])
	for b in beasts:
		if b != null and is_instance_valid(b):
			b.aura_bonus = bonus

func aura_beast_bonus() -> float:
	var bonus := 0.0
	for pid in loadout.active_persistent_ids():
		var cfg := loadout.configuration(String(pid)) as SkillConfiguration
		bonus += float(cfg.resolve()["beast_damage_bonus"])
	return bonus

func _prune() -> void:
	var kb: Array = []
	for b in ballistae:
		if b != null and is_instance_valid(b) and b.alive:
			kb.append(b)
	ballistae = kb
	var kk: Array = []
	for b in beasts:
		if b != null and is_instance_valid(b):
			kk.append(b)
	beasts = kk

func _enemies() -> Array:
	return enemies_provider.call() if enemies_provider.is_valid() else []

# =============================================================================
# AWARDED COMBAT PROGRESS
# =============================================================================

## ============================================================================
## THE ONLY XP SOURCE. THERE IS NO PATH FROM A BUTTON PRESS TO HERE.
## ============================================================================
## The owner: "Equipped Imprints receive combat XP from awarded combat progress,
## not from button-use frequency." An enemy defeated is an award. A Skill use is
## not, and the suite proves it by making many uses and asserting zero XP.
func award_combat_progress(amount: float) -> Dictionary:
	var ids := loadout.equipped_imprint_ids_with_duplicates()
	var report := library.award_combat_progress(amount, ids)
	combat_progress_awarded.emit(amount, int(report["distinct"]))
	return report

func _award_for_defeated_enemies() -> void:
	for e in _enemies():
		if e == null or not is_instance_valid(e):
			continue
		if not (e.has_method("is_dead") and e.is_dead()):
			continue
		var key := str(e.get_instance_id())
		if _dead_seen.has(key):
			continue
		_dead_seen[key] = true
		award_combat_progress(ImprintConfig.COMBAT_PROGRESS_PER_ENEMY_DEFEATED)

# =============================================================================
# SAFE STATE AND EDITS
# =============================================================================

## ============================================================================
## CANON FORBIDS CONFIGURATION EDITS DURING ACTIVE COMBAT. CONFLICT X-08.
## ============================================================================
## MEASURED: this project has no combat-state model, so "active combat" is
## approximated as -- an action is committed, OR an enemy has acquired the player
## and is alive. The approximation is DECLARED, and the refusal is PROVED.
func in_safe_state() -> bool:
	if diagnostic_safe_state_override:
		return true
	return canonical_safe_state()

## The canonical verdict, WITHOUT the diagnostic override -- so the panel can
## show the truth even while the override is letting an edit through.
func canonical_safe_state() -> bool:
	if player != null and player.commitment.active:
		return false
	for e in _enemies():
		if e == null or not is_instance_valid(e):
			continue
		if e.has_method("is_dead") and e.is_dead():
			continue
		if e.get("acquired") == true:
			return false
	return true

func safe_state_reason() -> String:
	if canonical_safe_state():
		return "SAFE STATE — configuration edits are permitted"
	if player != null and player.commitment.active:
		return "ACTIVE COMBAT — an action is committed (%s)" % player.commitment.phase()
	return "ACTIVE COMBAT — an enemy has acquired the player"

## Every panel edit goes through here, so the canonical rule has exactly one
## enforcement point and the refusal has exactly one counter.
func request_edit(description: String) -> Dictionary:
	if not in_safe_state():
		edits_refused += 1
		return {"ok": false, "reason": "%s: '%s' is REFUSED (canon: installing or removing a modifier is unavailable during active combat)"
			% [safe_state_reason(), description]}
	edits_allowed += 1
	return {"ok": true, "reason": ""}

# =============================================================================
# PANEL ACTIONS
# =============================================================================

func set_gear_bonus(active: bool) -> Dictionary:
	var g := request_edit("toggle the simulated gear Capacity bonus")
	if not g["ok"]:
		return g
	loadout.gear_bonus_active = active
	var r := loadout.revalidate(pool)
	return {"ok": true, "reason": "", "report": r["report"]}

## Installs or removes the reservation-resource modifier on the Persistent
## Configuration, which is how Mana reservation and Life reservation are compared.
##
## THE NAME IS KEPT FROM D-375 so the accepted suite's calls stay unchanged. What
## it installs is, since D-380, the PROPORTIONAL Mana->Life conversion (D-378
## OD-06), displayed as "Life Conversion"; the flat Life tithe no longer exists.
func set_life_tithe(installed: bool) -> Dictionary:
	var g := request_edit("change the Persistent reservation resource")
	if not g["ok"]:
		return g
	var cfg := loadout.configuration(DiagImprintContent.CFG_AURA) as SkillConfiguration
	if cfg == null:
		return {"ok": false, "reason": "the Persistent Configuration is missing"}
	var r: Dictionary
	if installed:
		r = cfg.install(DiagImprintContent.AUG_TITHE)
	else:
		r = cfg.remove(DiagImprintContent.AUG_TITHE)
	if not r["ok"]:
		return r
	var v := loadout.revalidate(pool)
	return {"ok": true, "reason": "", "report": v["report"]}

## Cycles this Configuration's Effective Rank for its Skill Imprint through low,
## middle and maximum -- the three uses the ruling says must be possible without
## bricking anything.
func cycle_effective_rank(cfg_id: String) -> Dictionary:
	var g := request_edit("change an Effective Rank")
	if not g["ok"]:
		return g
	var cfg := loadout.configuration(cfg_id) as SkillConfiguration
	if cfg == null:
		return {"ok": false, "reason": "no Configuration '%s'" % cfg_id}
	var cap := library.mastered(cfg.skill_id)
	var now := cfg.effective_rank(cfg.skill_id)
	var next := ImprintConfig.RANK_MIN
	if now <= ImprintConfig.RANK_MIN:
		next = clampi(int(round(float(cap) / 2.0)), ImprintConfig.RANK_MIN, cap)
	elif now < cap:
		next = cap
	var r := cfg.set_effective_rank(cfg.skill_id, next)
	loadout.revalidate(pool)
	return r

## ============================================================================
## THE LIVE SECOND-TRANSFORM TRIAL. It must be REFUSED, and it is COUNTED.
## ============================================================================
## The Configuration it attacks already holds ONE Transform and has slots to
## spare, so the refusal can only be the one-Transform rule -- never the slot
## rule wearing its coat.
func attempt_second_transform() -> Dictionary:
	var g := request_edit("attempt a SECOND Transform Imprint")
	if not g["ok"]:
		return g
	var cfg := loadout.configuration(DiagImprintContent.CFG_TEMPEST) as SkillConfiguration
	if cfg == null:
		return {"ok": false, "reason": "the Transform Configuration is missing"}
	second_transform_attempts += 1
	var r := cfg.install(DiagImprintContent.XF_RAIN)
	if not r["ok"]:
		second_transform_refusals += 1
		last_trial_result = String(r["reason"])
	else:
		# It should be impossible; if it ever happens, the state is repaired and
		# the event is loud rather than silent.
		cfg.remove(DiagImprintContent.XF_RAIN)
		last_trial_result = "A SECOND TRANSFORM WAS ACCEPTED. THIS IS A DEFECT."
		push_error("IMPRINT STAGE: a second Transform was accepted; the canonical limit failed.")
	loadout.revalidate(pool)
	return r

func set_safe_state_override(on: bool) -> void:
	diagnostic_safe_state_override = on

# =============================================================================
# THE DIAGNOSTIC RESERVATION CYCLE (D-381) — one input, three states
# =============================================================================

## ============================================================================
## OFF -> MANA RESERVATION -> LIFE CONVERSION -> OFF. EXACTLY ONE NEW INPUT.
## ============================================================================
## Added by the D-381 reviewability correction: *"If no direct input currently
## exists, add exactly one diagnostic input that cycles OFF -> MANA RESERVATION
## -> LIFE CONVERSION -> OFF."* Until D-381 the only way to change the
## reservation was focus-and-activate on the developer panel, which the owner
## could not use while playing.
##
## IT ADDS NO RULE AND NO VALUE. Each state is reached with operations that
## already existed and were already verified: the Persistent Configuration is
## added to or removed from the Persistent Loadout, and the Mana->Life
## conversion modifier is installed or removed. Every step passes the SAME
## safe-state gate as every other edit (`request_edit`), and the reservation is
## then decided by the SAME `revalidate()`.
const RESERVATION_CYCLE_ACTION := "diagnostic_reservation_cycle"
const RESERVATION_STATES := ["OFF", "MANA RESERVATION", "LIFE CONVERSION"]

## ============================================================================
## THE PERSISTENT CONFIGURATION THE CYCLE DRIVES — ADDED UNDER D-396.
## ============================================================================
## From D-381 until D-396 the cycle always drove the diagnostic Pack Ward aura
## (`DiagImprintContent.CFG_AURA`) -- true when written. D-383 accepted the
## Life-reservation RULES and listed "the diagnostic R-cycle control" as NOT
## accepted. The D-396 review loadout replaces the aura with Kindred Hounds, and
## the one existing diagnostic input drives the Persistent under review. NO input
## and NO rule is added: this names WHICH Configuration the same operations touch.
## The default is the aura, and the accepted suites' fixture sets it back to it.
var reservation_cycle_configuration: String = DiagImprintContent.CFG_AURA

var reservation_cycles: int = 0
var last_reservation_result: String = ""

## The state, read from the LIVE loadout -- never stored separately, so it cannot
## disagree with what is actually reserved.
func reservation_state() -> String:
	var cfg := loadout.configuration(reservation_cycle_configuration) as SkillConfiguration
	if cfg == null or not loadout.persistent.has(reservation_cycle_configuration):
		return "OFF"
	return "LIFE CONVERSION" if cfg.has_modifier(DiagImprintContent.AUG_TITHE) else "MANA RESERVATION"

func cycle_reservation_state() -> Dictionary:
	var g := request_edit("cycle the Persistent reservation state")
	if not g["ok"]:
		last_reservation_result = String(g["reason"])
		return g
	var cfg := loadout.configuration(reservation_cycle_configuration) as SkillConfiguration
	if cfg == null:
		last_reservation_result = "the Persistent Configuration is missing"
		return {"ok": false, "reason": last_reservation_result}
	var before := reservation_state()
	match before:
		"OFF":
			if cfg.has_modifier(DiagImprintContent.AUG_TITHE):
				cfg.remove(DiagImprintContent.AUG_TITHE)
			loadout.add_persistent(reservation_cycle_configuration)
		"MANA RESERVATION":
			cfg.install(DiagImprintContent.AUG_TITHE)
		"LIFE CONVERSION":
			cfg.remove(DiagImprintContent.AUG_TITHE)
			loadout.remove_persistent(reservation_cycle_configuration)
	loadout.revalidate(pool)
	reservation_cycles += 1
	last_reservation_result = "%s -> %s" % [before, reservation_state()]
	return {"ok": true, "reason": "", "from": before, "to": reservation_state()}

# =============================================================================
# COMPATIBILITY TRIALS — computed live, on SCRATCH Configurations
# =============================================================================

## ============================================================================
## THEY NEVER TOUCH THE LIVE LOADOUT.
## ============================================================================
## Each trial builds a fresh Configuration from the same library, so the panel
## can show a legal result beside an illegal one without the act of showing it
## changing the build under review.
func compatibility_trials() -> Array:
	var out: Array = []
	var C := DiagImprintContent

	# 1. INCOMPATIBLE TAGS.
	var t1 := SkillConfiguration.new("TRIAL_incompatible_tag", library)
	t1.set_skill(C.SKILL_STORM)
	var r1 := t1.install(C.AUG_WARD)
	out.append(["INCOMPATIBLE TAG — Extended Ward on the bow Skill",
		"REFUSED" if not r1["ok"] else "ACCEPTED (DEFECT)", String(r1["reason"])])

	# 2. THE FIFTH MODIFIER. Four AUGMENTS, so the refusal is the SLOT rule.
	var t2 := SkillConfiguration.new("TRIAL_fifth_modifier", library)
	t2.set_skill(C.SKILL_STORM)
	t2.install(C.AUG_SPLIT)
	t2.install(C.AUG_FORK)
	t2.install(C.AUG_TEMPERED)
	t2.install(C.AUG_SUREFOOT)
	var r2 := t2.install(C.XF_RAIN)
	out.append(["FIFTH MODIFIER — a 5th on a full 4-Augment Configuration",
		"REFUSED" if not r2["ok"] else "ACCEPTED (DEFECT)", String(r2["reason"])])

	# 3. THE SECOND TRANSFORM, with slots to spare.
	var t3 := SkillConfiguration.new("TRIAL_second_transform", library)
	t3.set_skill(C.SKILL_STORM)
	t3.install(C.XF_RAIN)
	var r3 := t3.install(C.XF_ORBIT)
	out.append(["SECOND TRANSFORM — with %d slot(s) still free" % t3.slots_free(),
		"REFUSED" if not r3["ok"] else "ACCEPTED (DEFECT)", String(r3["reason"])])

	# 4. EFFECTIVE RANK ABOVE MASTERY.
	var t4 := SkillConfiguration.new("TRIAL_rank_above_mastery", library)
	t4.set_skill(C.SKILL_BALLISTA)
	var r4 := t4.set_effective_rank(C.SKILL_BALLISTA, ImprintConfig.RANK_MAX)
	out.append(["EFFECTIVE RANK ABOVE MASTERY — rank %d against a Mastered %d"
		% [ImprintConfig.RANK_MAX, library.mastered(C.SKILL_BALLISTA)],
		"REFUSED" if not r4["ok"] else "ACCEPTED (DEFECT)", String(r4["reason"])])

	# 5. A CLASS REQUIREMENT — the reservation modifier on a non-Persistent Skill.
	var t5 := SkillConfiguration.new("TRIAL_wrong_class", library)
	t5.set_skill(C.SKILL_STORM)
	var r5 := t5.install(C.AUG_TITHE)
	out.append(["WRONG CONFIGURATION CLASS — Life Conversion on the bow Skill",
		"REFUSED" if not r5["ok"] else "ACCEPTED (DEFECT)", String(r5["reason"])])

	# 6. THE CANONICAL "ENABLING TAG REMOVED" CASE.
	#    The install SUCCEEDS and the SET becomes INVALID. The dependent Augment
	#    is NOT deleted, which is exactly what canon requires.
	var t6 := SkillConfiguration.new("TRIAL_enabling_tag_removed", library)
	t6.set_skill(C.SKILL_STORM)
	t6.install(C.AUG_SPLIT)
	var r6 := t6.install(C.XF_ORBIT)
	var v6 := t6.validate()
	out.append(["ENABLING TAG REMOVED — Tempest Orbit over Split Volley",
		("INSTALL ACCEPTED, SET NOW INVALID" if (r6["ok"] and not v6["valid"])
			else "UNEXPECTED"),
		"install: %s | the dependent Imprint is STILL INSTALLED (%d modifiers) and the set must be resolved: %s"
			% [("accepted" if r6["ok"] else String(r6["reason"])), t6.modifier_count(),
			   str(v6["problems"])]])

	# 7. A LEGAL SECOND TRANSFORM ON A DIFFERENT CONFIGURATION — the contrast.
	var t7 := SkillConfiguration.new("TRIAL_legal_transform", library)
	t7.set_skill(C.SKILL_BALLISTA)
	var r7 := t7.install(C.XF_ANCHOR)
	out.append(["LEGAL FIRST TRANSFORM — Siege Anchor on the ballista Skill",
		"ACCEPTED" if r7["ok"] else "REFUSED (DEFECT)",
		"one Transform is legal; a second is not. %s" % String(r7["reason"])])

	return out

# =============================================================================
# THE D-378 ALIGNMENT TRIALS (D-380) — computed live, on SCRATCH loadouts
# =============================================================================

## ============================================================================
## WHAT THE ALIGNED RULES DO, SHOWN WHERE THE OWNER CAN SEE THEM.
## ============================================================================
## The live build holds FIVE Active Configurations, because the diagnostic
## content has five and composing more would be content this stage is not
## authorized to add. So "up to eight" and "no Persistent slot cap" are shown on
## SCRATCH loadouts built from the SAME learned Imprints -- exactly the way the
## compatibility trials show refusals -- and NEVER touch the build under review.
##
## Returns rows of [title, verdict, detail].
func alignment_trials() -> Array:
	var out: Array = []
	var C := DiagImprintContent

	# --- OD-09: EIGHT, LIGHTLY MODIFIED — one per binding, and they fit. ------
	var light := {
		"T8_bow": [C.SKILL_STORM, []],
		"T8_bow_split": [C.SKILL_STORM, [C.AUG_SPLIT]],
		"T8_bow_fork": [C.SKILL_STORM, [C.AUG_FORK]],
		"T8_bow_tempered": [C.SKILL_STORM, [C.AUG_TEMPERED]],
		"T8_ballista": [C.SKILL_BALLISTA, []],
		"T8_ballista_ward": [C.SKILL_BALLISTA, [C.AUG_WARD]],
		"T8_beasts": [C.SKILL_BEASTS, []],
		"T8_beasts_pack": [C.SKILL_BEASTS, [C.AUG_PACK]],
	}
	var r8 := _scratch_eight(light)
	out.append(["EIGHT ACTIVE CONFIGURATIONS, lightly modified — one per binding (OD-09)",
		"%d OF 8 BOUND, %s" % [int(r8["bound"]), "ALL ACTIVE" if int(r8["deactivated"]) == 0
			else "%d DEACTIVATED" % int(r8["deactivated"])],
		"no six cap refused anything; Capacity used %d of %d; a NINTH binding does not exist (%s)"
			% [int(r8["used"]), int(r8["total"]), String(r8["ninth"])]])

	# --- OD-09: EIGHT, HEAVILY MODIFIED — Capacity limits depth, not a count. --
	var heavy := {
		"T8H_bow_full": [C.SKILL_STORM, [C.AUG_SPLIT, C.AUG_FORK, C.AUG_TEMPERED, C.AUG_SUREFOOT]],
		"T8H_bow_three": [C.SKILL_STORM, [C.AUG_SPLIT, C.AUG_FORK, C.AUG_TEMPERED]],
		"T8H_orbit": [C.SKILL_STORM, [C.AUG_TEMPERED, C.XF_ORBIT]],
		"T8H_rain": [C.SKILL_STORM, [C.XF_RAIN, C.AUG_SPLIT]],
		"T8H_ballista": [C.SKILL_BALLISTA, [C.AUG_WARD, C.AUG_SPLIT]],
		"T8H_anchor": [C.SKILL_BALLISTA, [C.XF_ANCHOR]],
		"T8H_beasts": [C.SKILL_BEASTS, [C.AUG_PACK, C.AUG_TEMPERED]],
		"T8H_beasts_pack": [C.SKILL_BEASTS, [C.AUG_PACK]],
	}
	var h8 := _scratch_eight(heavy)
	out.append(["EIGHT ACTIVE CONFIGURATIONS, heavily modified — Capacity limits DEPTH (OD-09)",
		"%d OF 8 BOUND, %d DEACTIVATED BY CAPACITY" % [int(h8["bound"]), int(h8["deactivated"])],
		"the loadout demanded %d against a budget of %d and was brought back to %d — the limit is the global budget, not a slot count"
			% [int(h8["demanded"]), int(h8["total"]), int(h8["used"])]])

	# --- OD-07.2 / D-376 X-02: SIX PERSISTENTS — no slot cap; reservation is. --
	var lo := ImprintLoadout.new(library, {})
	var accepted := 0
	for i in 6:
		var pc := SkillConfiguration.new("T_persistent_%d" % i, library)
		pc.set_skill(C.SKILL_AURA)
		pc.set_effective_rank(C.SKILL_AURA, ImprintConfig.RANK_MIN)
		lo.configurations["T_persistent_%d" % i] = pc
		if lo.add_persistent("T_persistent_%d" % i)["ok"]:
			accepted += 1
	var rv := lo.revalidate(ResourcePool.new())
	var why := ""
	for k in (rv["deactivated"] as Dictionary):
		why = String((rv["deactivated"] as Dictionary)[k])
	out.append(["SIX PERSISTENT CONFIGURATIONS — no slot cap; the RESERVATION limit is natural (OD-07.2)",
		"%d OF 6 ACCEPTED, %d DEACTIVATED BY RESERVATION" % [accepted,
			(rv["deactivated"] as Dictionary).size()],
		"six rank-1 auras would reserve %.0f%% of maximum Mana; %s"
			% [600.0 * ImprintConfig.AURA_RESERVE_FRACTION_AT_RANK_1,
			   why if why != "" else "all supported"]])
	return out

## Builds a scratch eight-binding loadout from the LIVE library, binds one
## Configuration per binding, tries a ninth, and revalidates against the live
## gear setting. Nothing here touches the build under review.
func _scratch_eight(spec: Dictionary) -> Dictionary:
	var cfgs: Dictionary = {}
	for cid in spec:
		var c := SkillConfiguration.new(String(cid), library)
		c.set_skill(String(spec[cid][0]))
		for m in spec[cid][1]:
			c.install(String(m))
		cfgs[cid] = c
	var lo := ImprintLoadout.new(library, cfgs)
	lo.gear_bonus_active = loadout.gear_bonus_active
	var bound := 0
	var i := 0
	for cid in spec:
		if lo.bind(i, String(cid))["ok"]:
			bound += 1
		i += 1
	var ninth := lo.bind(ImprintConfig.CANON_ACTIVE_BINDINGS, String(spec.keys()[0]))
	var demanded := lo.capacity_demanded()
	var r := lo.revalidate(ResourcePool.new())
	return {
		"bound": bound,
		"ninth": "refused" if not ninth["ok"] else "ACCEPTED (DEFECT)",
		"demanded": demanded,
		"used": int(r["capacity_used"]),
		"total": int(r["capacity_total"]),
		"deactivated": (r["deactivated"] as Dictionary).size(),
	}

## ============================================================================
## REGENERATION IN BOTH RESERVATION STATES, COMPUTED WITHOUT TOUCHING THE BUILD.
## ============================================================================
## What the aura would leave for regeneration reserving MANA, and what it leaves
## once converted to LIFE -- the comparison OD-05 makes intentional.
func regeneration_comparison() -> Dictionary:
	var cfg := loadout.configuration(DiagImprintContent.CFG_AURA) as SkillConfiguration
	var mana_fraction := 0.0
	if cfg != null:
		mana_fraction = float(cfg.resolve().get("reserve_fraction_mana_basis", 0.0))
	var on_mana := ResourcePool.regen_rate_of(ImprintConfig.MANA_MAX * (1.0 - mana_fraction),
		ImprintConfig.MANA_REGEN_FRACTION_OF_UNRESERVED_PER_S)
	var on_life := ResourcePool.regen_rate_of(ImprintConfig.MANA_MAX,
		ImprintConfig.MANA_REGEN_FRACTION_OF_UNRESERVED_PER_S)
	return {"mana_fraction": mana_fraction, "aura_on_mana": on_mana, "aura_on_life": on_life,
		"now": pool.regen_per_second(), "unreserved": pool.unreserved_maximum()}

# =============================================================================
# TEST SUPPORT
# =============================================================================

## Clears every entity this runtime owns. TEST SETUP AND SCENE TEARDOWN ONLY.
func dismiss_all() -> void:
	for b in ballistae:
		if b != null and is_instance_valid(b):
			b.queue_free()
	ballistae = []
	for b in beasts:
		if b != null and is_instance_valid(b):
			b.dismiss()
	beasts = []
	orbits = []

func clear_cooldowns() -> void:
	_cooldowns = {}

func forget_defeated() -> void:
	_dead_seen = {}
