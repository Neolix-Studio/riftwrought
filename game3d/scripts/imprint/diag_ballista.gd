class_name DiagBallista
extends Node3D

## A PLACED, AUTONOMOUS DIAGNOSTIC BALLISTA — the non-direct attack style.
##
## ============================================================================
## WHY THIS EXISTS, AND WHAT IT PROVES.
## ============================================================================
## The ruling asked for "a ballista or trap Configuration -- choose whichever
## exposes more of the architecture without inventing a second framework", and
## required it to "prove that the same Imprint/Configuration rules support a
## non-direct attack style."
##
## IT REUSES `DiagProjectile`, WHICH IS THE WHOLE CLAIM. The Split Volley
## Augment Imprint installed on the BOW Configuration is the SAME LEARNED
## IMPRINT installed here, and it makes THIS emplacement fire more bolts. One
## framework, two Skills, one mastery record, one XP award.
##
## ---------------------------------------------------------------------------
## IT IS NOT A MINION, DELIBERATELY.
## ---------------------------------------------------------------------------
## It carries `Ground` and `Duration`, not `Minion`. That separation is what
## lets the suite prove Minion Augments do NOT apply to it while projectile
## Augments DO -- tag-driven compatibility with a visible consequence.
##
## ---------------------------------------------------------------------------
## CANON'S DURATION AND GROUND RULES, IMPLEMENTED LITERALLY.
## ---------------------------------------------------------------------------
## `design/SKILLS_AND_SKILL_MODIFICATION.md` section 15 requires every Duration
## or Ground effect to declare its duration, its maximum active instances,
## whether re-use refreshes/replaces/adds, and what happens when the limit is
## exceeded -- and says "When an instance limit is exceeded, the OLDEST instance
## is normally replaced." All four are declared, and the oldest IS replaced.
##
## ---------------------------------------------------------------------------
## ITS BODY IS A PLACEHOLDER PROP AND IT SAYS SO.
## ---------------------------------------------------------------------------
## Zero new assets are imported by this stage. This is an already-declared ruins
## prop with a runtime material treatment. IT IS NOT A BALLISTA MODEL, it is a
## crate standing in for one, and nothing here is final art.
##
## EVERY NUMBER IT USES IS PROVISIONAL.

## Canon's four declarations for a Duration/Ground effect, stated as data so a
## check can read them rather than trusting this comment.
const DURATION_CONTRACT := {
	"declares_duration": true,
	"maximum_active_instances": "from the Configuration (ImprintConfig.BALLISTA_INSTANCES_MAX, or 1 under Siege Anchor)",
	"reuse_behaviour": "ADDS an instance until the limit, then REPLACES THE OLDEST",
	"on_limit_exceeded": "the oldest instance is freed immediately, and the event is counted",
}

var duration: float = ImprintConfig.BALLISTA_DURATION_AT_RANK_1
var fire_interval: float = ImprintConfig.BALLISTA_FIRE_INTERVAL
var acquire_range: float = ImprintConfig.BALLISTA_ACQUIRE_RANGE
var projectile_spec: Dictionary = {}
var origin_configuration: String = ""
var enemies_provider: Callable = Callable()

var elapsed: float = 0.0
var alive: bool = true
var shots: int = 0
var acquisitions: int = 0

var _cooldown: float = 0.0
var _visual: Node3D
var _bolt_parent: Node

## Diagnostics the suite reads. Static, because a ballista frees itself when its
## duration runs out.
static var placed_total: int = 0
static var replaced_oldest_total: int = 0
static var expired_total: int = 0
static var shots_total: int = 0

static func reset_counters() -> void:
	placed_total = 0
	replaced_oldest_total = 0
	expired_total = 0
	shots_total = 0

static func note_replacement() -> void:
	replaced_oldest_total += 1

func build(bolt_parent: Node) -> void:
	_bolt_parent = bolt_parent
	placed_total += 1
	var m: Mesh = load(AssetManifest.ruins("Crate"))
	if m != null:
		_visual = MeshInstance3D.new()
		(_visual as MeshInstance3D).mesh = m
		var scale_info := RigCorpus.prop_scale_for(m, 1.10)
		_visual.scale = Vector3.ONE * float(scale_info["scale"])
		add_child(_visual)
		RigCorpus.tint_all(_visual, [], ImprintConfig.COL_BALLISTA)
	# A marker so the emplacement reads as a device rather than as scenery. It is
	# a PRIMITIVE on purpose: a real ballista mesh would imply art this stage has
	# not made and is not authorized to make.
	var spar := MeshInstance3D.new()
	var cyl := CylinderMesh.new()
	cyl.top_radius = 0.045
	cyl.bottom_radius = 0.045
	cyl.height = 1.30
	spar.mesh = cyl
	var sm := StandardMaterial3D.new()
	sm.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	sm.albedo_color = ImprintConfig.COL_BALLISTA
	sm.emission_enabled = true
	sm.emission = ImprintConfig.COL_BALLISTA
	sm.emission_energy_multiplier = 2.6
	spar.material_override = sm
	spar.position = Vector3(0, 1.05, 0)
	spar.rotation_degrees = Vector3(0, 0, 62)
	add_child(spar)

	var l := OmniLight3D.new()
	l.light_color = ImprintConfig.COL_BALLISTA
	l.light_energy = 1.5
	l.omni_range = 3.4
	l.shadow_enabled = false
	l.position = Vector3(0, 1.1, 0)
	add_child(l)

	# THE SHADOW STAYS AT THE GROUND POINT. A fixed isometric view with no
	# contact cue cannot tell "standing here" from "standing further away", which
	# is the lesson a rendered frame taught D-370.
	GroundShadow.attach_to(self, 0.52)

func _physics_process(delta: float) -> void:
	step(delta)

## Separated so the suite can drive exact steps.
func step(delta: float) -> void:
	if not alive:
		return
	elapsed += delta
	if elapsed >= duration:
		alive = false
		expired_total += 1
		queue_free()
		return
	_cooldown = maxf(0.0, _cooldown - delta)
	if _cooldown > 0.0:
		return
	var target := _acquire()
	if target == null:
		return
	acquisitions += 1
	_fire_at(target)
	_cooldown = fire_interval

## ============================================================================
## AUTONOMOUS ACQUISITION, WITH NO PLAYER INPUT OF ANY KIND.
## ============================================================================
## There is deliberately no aim, no cursor and no command path into this
## function. It is the non-direct half of "a non-direct attack style".
func _acquire() -> Node3D:
	if not enemies_provider.is_valid():
		return null
	var best: Node3D = null
	var best_d := INF
	for e in enemies_provider.call():
		if e == null or not is_instance_valid(e):
			continue
		if e.has_method("is_dead") and e.is_dead():
			continue
		var d := NavService.planar_distance(global_position, (e as Node3D).global_position)
		if d <= acquire_range and d < best_d:
			best_d = d
			best = e
	return best

func _fire_at(target: Node3D) -> void:
	if _bolt_parent == null:
		return
	var dir := target.global_position - global_position
	dir.y = 0.0
	if dir.length() < 0.001:
		return
	dir = dir.normalized()
	var count := int(projectile_spec.get("projectiles", 1))
	var spread: float = float(projectile_spec.get("spread_deg", 0.0))
	for k in count:
		var offset := 0.0
		if count > 1:
			offset = lerpf(-spread, spread, float(k) / float(count - 1))
		var b := DiagProjectile.new()
		b.damage = float(projectile_spec.get("damage", 1.0))
		b.speed = float(projectile_spec.get("speed", ImprintConfig.STORM_PROJECTILE_SPEED))
		b.max_range = acquire_range + 1.5
		b.tint = ImprintConfig.COL_BALLISTA
		b.fork_children = int(projectile_spec.get("fork_children", 0))
		b.fork_generations = int(projectile_spec.get("fork_generations", 0))
		b.fork_fraction = float(projectile_spec.get("fork_fraction", 0.0))
		# THE LEDGER SOURCE IS THE BALLISTA, NOT THE PLAYER. That separation is
		# what makes "ordinary bow damage versus autonomous damage" measurable.
		b.source_label = "ballista"
		b.origin_configuration = origin_configuration
		_bolt_parent.add_child(b)
		b.build(dir.rotated(Vector3.UP, deg_to_rad(offset)))
		b.global_position = global_position + Vector3(0, 1.05, 0) + dir * 0.5
		shots += 1
		shots_total += 1

func remaining() -> float:
	return maxf(0.0, duration - elapsed)
