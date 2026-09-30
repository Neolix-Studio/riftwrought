class_name CinderTrap
extends Node3D

## ONE PLACED CINDER FIELD TRAP — dormant, then armed, then sprung ONCE (D-402).
##
## ============================================================================
## IT IS NOT ATTACKABLE, IT BLOCKS NOTHING, AND IT CHANGES NO NAVIGATION.
## ============================================================================
## Canon (`CHARACTER_CLASS_PHILOSOPHY.md` section 0.5.5, `SKILLS_AND_SKILL_
## MODIFICATION.md` Cinder Field as amended by D-385): "It is not attackable,
## blocks no movement and modifies no navigation."
##
## That is STRUCTURAL here, not a promise: this node's subtree contains NO
## `CollisionObject3D` of any kind, it is NOT registered in the area's
## combat-entity registry, and it implements NO `receive_damage`. There is
## nothing for an attack to find, nothing for a body to push against, and nothing
## for the baked navigation mesh to notice. The D-402 suite asserts all four.
##
## ---------------------------------------------------------------------------
## ONE ERUPTION. EVER.
## ---------------------------------------------------------------------------
## The state machine has one edge into `SPRUNG` and none out of it, so "at most
## once" is a property of the shape rather than of a counter anyone could forget
## to check. `eruptions` is recorded so a check can see it, never so the code can
## branch on it.
##
## ---------------------------------------------------------------------------
## AN ENEMY, NEVER AN ALLY — AND NEVER THE PLAYER.
## ---------------------------------------------------------------------------
## A candidate must be a REGISTERED combat entity the GENERAL `HitEligibility`
## rule accepts. The player is not registered at all; a Kindred Hound is
## registered as an ALLY and the predicate's second conjunct refuses it. There is
## no trap-specific eligibility rule and no special case for either.
##
## ---------------------------------------------------------------------------
## SIMULTANEOUS ENTRY IS RESOLVED BY MEASURED TIME, THEN BY COMBAT-ENTITY ID.
## ---------------------------------------------------------------------------
## The owner: "Trigger resolution must be deterministic. If multiple enemies
## enter on the same physics step, use measured entry order/time and the stable
## combat-entity ID as the exact tie-break."
##
## Each candidate's position at the END of the previous step and at the END of
## this one give a SWEPT SEGMENT, and the earliest parameter at which that
## segment touches the trigger circle is computed in CLOSED FORM by the accepted
## `ArrowCollision.segment_circle_toi`. A body already inside at the start of the
## step enters at t = 0. The winner is the smallest t; an EXACT tie -- tolerance
## ZERO -- goes to the lower combat-entity ID through the accepted
## `ArrowCollision.choose`, which is order-independent by construction.
##
## NOTHING HERE READS a node's name, its instance id, an array order or a physics
## query's result order, and the D-402 suite scans this file's CODE for exactly
## those.
##
## EVERY NUMBER IT USES IS PROVISIONAL (`CinderConfig.registry()`).

## Set by `CinderRuntime` at placement. None is read from a global.
var registry: CombatEntityRegistry = null
var origin_configuration: String = ""
var use_id: String = ""
## The placement sequence within this runtime: the oldest instance has the
## lowest ordinal. Used for oldest-first replacement and, in the Ground arbiter,
## to break an exact tie between equally strong fields. It is NOT an entity ID.
var ordinal: int = 0

var arming_delay: float = CinderConfig.ARMING_DELAY_S
var trigger_radius: float = CinderConfig.TRIGGER_RADIUS_M
var eruption_radius: float = CinderConfig.ERUPTION_RADIUS_M
var dormant_duration: float = CinderConfig.DORMANT_DURATION_S
var eruption_damage: float = CinderConfig.ERUPTION_DAMAGE_AT_RANK_1

## The one edge out of DORMANT is into SPRUNG, and there is no edge out of it.
var state: String = CinderConfig.PHASE_ARMING
var elapsed: float = 0.0
var sprung_at: float = -1.0
var eruptions: int = 0
var armed_at: float = -1.0

## What the eruption did, recorded for the HUD, the suite and the report.
var trigger_id: String = ""
var trigger_tie_set: Array = []
var trigger_entry_t: float = -1.0
var enemies_hit: int = 0
var hit_ids: Array = []
var last_refusal: String = ""
var refusals: int = 0

## The owning runtime, so an eruption can ask it for a burning Ground. It is a
## plain reference handed in at placement; nothing is looked up.
var runtime = null

## Position of each candidate at the END of the previous step, for the swept
## segment. Keyed by the NODE, never by a name or an id.
var _prev: Dictionary = {}

var _body_open: MeshInstance3D
var _body_closed: MeshInstance3D
var _pin: MeshInstance3D
var _ring_segments: Array = []
var _flash: MeshInstance3D
var _light: OmniLight3D

# =============================================================================
# BUILD — PLACEHOLDER BODIES AND RESTRAINED PROCEDURAL DIAGNOSTIC VISUALS
# =============================================================================

## The two bodies are the CC0 Quaternius `BearTrap_Open` / `BearTrap_Closed`
## ruins models, by the manifest's own constants. They are PLACEHOLDERS and
## NEITHER IS FINAL HUNTRESS ART. Everything else here is a primitive.
func build() -> void:
	_body_open = _trap_body("BearTrap_Open")
	_body_closed = _trap_body("BearTrap_Closed")
	if _body_closed != null:
		_body_closed.visible = false

	# THE ARMED PIN — a SHAPE cue, not a colour cue. It exists only while the
	# trap is ARMED, so "armed" is legible in a still frame without reading a
	# tint. Canon: readable without relying on colour alone.
	_pin = MeshInstance3D.new()
	_pin.name = "ArmedPin"
	var spike := CylinderMesh.new()
	spike.top_radius = 0.012
	spike.bottom_radius = 0.045
	spike.height = 0.46
	_pin.mesh = spike
	_pin.position = Vector3(0.0, 0.30, 0.0)
	_pin.material_override = _unshaded(CinderConfig.COL_ARMED, 3.0)
	_pin.visible = false
	add_child(_pin)

	# THE TRIGGER RING — twelve segments round the trigger radius. While ARMING
	# they light up one by one, so the arming DELAY is a filling ring rather than
	# a colour change; once ARMED the whole ring stands.
	for k in RING_SEGMENTS:
		var seg := MeshInstance3D.new()
		seg.name = "TriggerSeg%d" % k
		var box := BoxMesh.new()
		box.size = Vector3(0.16, 0.012, 0.055)
		seg.mesh = box
		var ang := TAU * float(k) / float(RING_SEGMENTS)
		seg.position = Vector3(cos(ang) * trigger_radius, CinderConfig.TRIGGER_RING_Y, sin(ang) * trigger_radius)
		seg.rotation.y = -ang
		seg.material_override = _unshaded(CinderConfig.COL_DORMANT, 1.2)
		seg.visible = false
		add_child(seg)
		_ring_segments.append(seg)

	# THE ERUPTION FLASH — one expanding ring, hidden until the trap springs.
	_flash = MeshInstance3D.new()
	_flash.name = "EruptionFlash"
	var torus := TorusMesh.new()
	torus.inner_radius = 0.24
	torus.outer_radius = 0.34
	_flash.mesh = torus
	_flash.position = Vector3(0.0, CinderConfig.ERUPTION_RING_Y, 0.0)
	_flash.material_override = _unshaded(CinderConfig.COL_ERUPTION, 5.0)
	_flash.visible = false
	add_child(_flash)

	_light = OmniLight3D.new()
	_light.name = "TrapLight"
	_light.light_color = CinderConfig.COL_ARMED
	_light.light_energy = 0.0
	_light.omni_range = 3.0
	_light.shadow_enabled = false
	_light.position = Vector3(0.0, 0.35, 0.0)
	add_child(_light)

	_refresh_visual()

## Twelve is a LAYOUT choice, not a gameplay value: enough segments to read as a
## ring at the default zoom, few enough to count at a glance.
const RING_SEGMENTS := 12

func _trap_body(model: String) -> MeshInstance3D:
	var m: Mesh = load(AssetManifest.ruins(model))
	if m == null:
		# A MISSING PLACEHOLDER IS LOUD, NEVER SILENT: without it the trap would
		# still work mechanically and would be invisible, which is the worst of
		# both. (The accepted F02 proves both models load.)
		push_error("D-402: the placeholder trap body '%s' did not load" % model)
		return null
	var mi := MeshInstance3D.new()
	mi.name = "Body_%s" % model
	mi.mesh = m
	var info := RigCorpus.prop_scale_for(m, CinderConfig.TRAP_FOOTPRINT_M)
	mi.scale = Vector3.ONE * float(info["scale"])
	add_child(mi)
	# A RUNTIME MATERIAL OVERRIDE, never an edit to the source .obj or .mtl.
	RigCorpus.tint_all(mi, [], CinderConfig.COL_DORMANT)
	return mi

static func _unshaded(c: Color, energy: float) -> StandardMaterial3D:
	var m := StandardMaterial3D.new()
	m.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	m.albedo_color = c
	m.emission_enabled = true
	m.emission = c
	m.emission_energy_multiplier = energy
	return m

# =============================================================================
# THE STEP
# =============================================================================

func _physics_process(delta: float) -> void:
	step(delta)

## Separated so the suite can drive exact steps.
func step(delta: float) -> void:
	elapsed += delta
	match state:
		CinderConfig.PHASE_ARMING:
			_remember_positions()
			if elapsed >= arming_delay:
				state = CinderConfig.PHASE_ARMED
				armed_at = elapsed
		CinderConfig.PHASE_ARMED:
			# EXPIRY IS JUDGED FIRST. A trap whose dormant Duration has run out
			# is no longer a trap, and it ends HARMLESSLY -- no Hit, no Ground,
			# nothing in the damage ledger.
			if elapsed >= dormant_duration:
				_expire()
				return
			var pick := _pick_triggerer()
			_remember_positions()
			if not pick.is_empty():
				_erupt(pick)
		CinderConfig.PHASE_SPRUNG:
			if elapsed - sprung_at >= CinderConfig.SPRUNG_LINGER_S:
				if runtime != null:
					runtime.note_trap_gone(self)
				queue_free()
				return
	_refresh_visual()

## TRUE only while the trap can still be sprung. A trap cannot trigger before it
## is armed, and this is the whole of that rule.
func is_armed() -> bool:
	return state == CinderConfig.PHASE_ARMED

func is_dormant() -> bool:
	return state == CinderConfig.PHASE_ARMING or state == CinderConfig.PHASE_ARMED

func remaining_dormant() -> float:
	return maxf(0.0, dormant_duration - elapsed)

func arming_progress() -> float:
	return clampf(elapsed / maxf(0.0001, arming_delay), 0.0, 1.0)

# =============================================================================
# THE TRIGGER
# =============================================================================

## Every REGISTERED combat entity, with its record. The player is not registered
## and therefore never appears here; an ally does appear and is refused by the
## general eligibility rule, which is the point -- the refusal is OBSERVABLE.
func _candidates() -> Array:
	return registry.records() if registry != null else []

func _remember_positions() -> void:
	for rec in _candidates():
		var n = rec.get("node", null)
		# `is_inside_tree()` IS PART OF THE GUARD, NOT DECORATION. A registered
		# entity can be valid and OUT of the tree -- removed, or queued for
		# deletion -- and `global_position` on such a node is an ENGINE ERROR
		# returning an identity transform. Found at delivery by the runner's
		# engine-error guard, which refuses a run that prints one (D-402).
		if n != null and is_instance_valid(n) and n is Node3D and (n as Node3D).is_inside_tree():
			_prev[n] = (n as Node3D).global_position

## The eligible enemy that entered the trigger circle EARLIEST within this step,
## or {} when none did. Returns {"id", "t", "tie_set"}.
func _pick_triggerer() -> Dictionary:
	var centre := ArrowCollision.planar(global_position)
	var candidates: Array = []
	for rec in _candidates():
		var n = rec.get("node", null)
		# OUT-OF-TREE IS NOT A CANDIDATE: see `_remember_positions()` (D-402).
		if n == null or not is_instance_valid(n) or not (n is Node3D) or not (n as Node3D).is_inside_tree():
			continue
		var elig := HitEligibility.evaluate(rec)
		if not bool(elig["eligible"]):
			continue
		var now := (n as Node3D).global_position
		var was: Vector3 = _prev.get(n, now)
		var t := ArrowCollision.segment_circle_toi(
			ArrowCollision.planar(was), ArrowCollision.planar(now), centre, trigger_radius)
		if t < 0.0:
			continue
		# `distance_m` is the key the ACCEPTED chooser reads. Here it carries the
		# ENTRY TIME within the step, which is the quantity the ruling names.
		candidates.append({"id": String(rec["id"]), "distance_m": t})
	if candidates.is_empty():
		return {}
	# TOLERANCE ZERO: "exact ties", in the owner's own word. The accepted chooser
	# anchors its tie set on the minimum, so it cannot depend on the order it met
	# the candidates in.
	var best := ArrowCollision.choose(candidates, registry, 0.0)
	if best.is_empty():
		return {}
	return {"id": String(best["id"]), "t": float(best["distance_m"]),
		"tie_set": ArrowCollision.tie_set(candidates, 0.0)}

# =============================================================================
# THE ERUPTION — a DELAYED COMPONENT of the original Skill Use
# =============================================================================

## ============================================================================
## IT IS NOT A TRIGGERED SKILL, AND THE DIFFERENCE IS STRUCTURAL.
## ============================================================================
## Canon (D-385): "the eruption is a delayed component of the original Skill Use,
## not a Triggered Skill."
##
## So it carries the ORIGINAL `use_id`, it increments NO Skill Use count, it pays
## NO cost, it starts NO cooldown and it goes through NO binding. The only thing
## it does is resolve the components the use already paid for.
func _erupt(pick: Dictionary) -> void:
	state = CinderConfig.PHASE_SPRUNG
	sprung_at = elapsed
	eruptions += 1
	trigger_id = String(pick["id"])
	trigger_entry_t = float(pick["t"])
	trigger_tie_set = (pick["tie_set"] as Array).duplicate()

	# 1. THE INITIAL FIRE HIT — every eligible enemy in the AREA, not just the
	#    one that sprang it. "The eruption may Hit every eligible enemy in its
	#    area; it is not a single-target projectile."
	hit_ids = []
	for rec in _candidates():
		var n = rec.get("node", null)
		# OUT-OF-TREE IS NOT IN THE AREA: see `_remember_positions()` (D-402).
		if n == null or not is_instance_valid(n) or not (n is Node3D) or not (n as Node3D).is_inside_tree():
			continue
		if not bool(HitEligibility.evaluate(rec)["eligible"]):
			continue
		if NavService.planar_distance(global_position, (n as Node3D).global_position) > eruption_radius:
			continue
		n.receive_damage(eruption_damage, global_position)
		SkillRuntime.record_damage(CinderConfig.LEDGER_SOURCE_HIT, eruption_damage, origin_configuration)
		enemies_hit += 1
		hit_ids.append(String(rec["id"]))
	# 2. THE LINGERING, NON-STACKING BURNING GROUND. The runtime owns it, because
	#    the non-stacking rule is arbitrated in ONE place and a field that
	#    arbitrated for itself could not obey it.
	if runtime != null:
		runtime.on_eruption(self)

func _expire() -> void:
	state = CinderConfig.PHASE_EXPIRED
	if runtime != null:
		runtime.note_expired(self)
		runtime.note_trap_gone(self)
	queue_free()

# =============================================================================
# PRESENTATION — restrained, procedural, and never colour alone
# =============================================================================

func _refresh_visual() -> void:
	match state:
		CinderConfig.PHASE_ARMING:
			var lit := int(floor(arming_progress() * float(RING_SEGMENTS)))
			for k in _ring_segments.size():
				(_ring_segments[k] as MeshInstance3D).visible = k < lit
			if _pin != null:
				_pin.visible = false
			if _light != null:
				_light.light_energy = 0.35 * arming_progress()
		CinderConfig.PHASE_ARMED:
			for seg in _ring_segments:
				(seg as MeshInstance3D).visible = true
				(seg as MeshInstance3D).material_override = _unshaded(CinderConfig.COL_ARMED, 2.4)
			if _pin != null:
				_pin.visible = true
			if _body_open != null:
				RigCorpus.tint_all(_body_open, [], CinderConfig.COL_ARMED)
			if _light != null:
				# A slow pulse, so an armed trap reads as live in motion as well
				# as in a still frame. Presentation only; nothing branches on it.
				_light.light_energy = 1.1 + 0.45 * sin(elapsed * 4.0)
		CinderConfig.PHASE_SPRUNG:
			var f := clampf((elapsed - sprung_at) / CinderConfig.ERUPTION_FLASH_S, 0.0, 1.0)
			if _body_open != null:
				_body_open.visible = false
			if _body_closed != null:
				_body_closed.visible = true
				RigCorpus.tint_all(_body_closed, [], CinderConfig.COL_ERUPTION)
			if _pin != null:
				_pin.visible = false
			for seg in _ring_segments:
				(seg as MeshInstance3D).visible = false
			if _flash != null:
				_flash.visible = f < 1.0
				var r: float = lerpf(0.30, eruption_radius, f)
				var torus := _flash.mesh as TorusMesh
				torus.inner_radius = maxf(0.05, r - 0.16)
				torus.outer_radius = r
			if _light != null:
				_light.light_energy = 6.0 * (1.0 - f)
		_:
			pass

## Everything the HUD and the suite read about this trap, in one call.
func snapshot() -> Dictionary:
	return {
		"state": state,
		"ordinal": ordinal,
		"use_id": use_id,
		"elapsed": elapsed,
		"arming": arming_progress(),
		"remaining": remaining_dormant(),
		"eruptions": eruptions,
		"trigger": trigger_id,
		"entry_t": trigger_entry_t,
		"tie_set": trigger_tie_set.duplicate(),
		"hits": enemies_hit,
		"hit_ids": hit_ids.duplicate(),
		"position": global_position,
	}
