class_name CinderGround
extends Node3D

## ONE LINGERING BURNING GROUND — the eruption's second component (D-402).
##
## ============================================================================
## IT DOES NOT APPLY ITS OWN DAMAGE, AND THAT IS THE NON-STACKING RULE.
## ============================================================================
## Canon (`SKILLS_AND_SKILL_MODIFICATION.md`, Duration and Ground Skills):
## "Identical overlapping Damage over Time Ground effects do not stack by
## default; the strongest applicable instance deals damage."
##
## A field that damaged the enemies inside itself could only obey that rule by
## asking every other field what it had already done -- which is a subtraction
## that drifts. So the ARBITER IS ONE PLACE: `CinderRuntime._apply_ground_tick()`
## walks the enemies, finds the STRONGEST field containing each, and applies
## EXACTLY ONE contribution. This object owns its geometry, its Duration and its
## own record of what was attributed to it, and nothing else.
##
## ---------------------------------------------------------------------------
## IT IS NOT ATTACKABLE AND IT BLOCKS NOTHING.
## ---------------------------------------------------------------------------
## Like the trap, its subtree contains NO `CollisionObject3D`, it is not
## registered as a combat entity, and it implements no `receive_damage`.
##
## ---------------------------------------------------------------------------
## ITS TAGS ARE CANON'S, AND THEY ARE NOT THE ERUPTION'S.
## ---------------------------------------------------------------------------
## `Spell, Ground, Damage over Time, Fire, Duration` -- carrying `Damage over
## Time` and NOT `Hit`, where the eruption carries `Hit` and NOT `Damage over
## Time`. A modifier applies only to components carrying an eligible tag
## (`ATTRIBUTES_AND_DAMAGE_MODEL.md`), which is why the two are separate objects
## with separate ledger sources rather than one effect with two numbers.
##
## EVERY NUMBER IT USES IS PROVISIONAL (`CinderConfig.registry()`).

## Set by `CinderRuntime` when the eruption creates it.
var radius: float = CinderConfig.GROUND_RADIUS_M
var duration: float = CinderConfig.GROUND_DURATION_S
var dps: float = CinderConfig.GROUND_DPS_AT_RANK_1
var origin_configuration: String = ""
## The Skill Use that placed the trap this field came from. It is carried so the
## delayed component is traceable to its use, never to start a new one.
var use_id: String = ""
## The placement sequence of the trap that erupted: the tie-break when two
## equally strong fields contain the same enemy. The OLDER field wins.
var ordinal: int = 0

var elapsed: float = 0.0
var alive: bool = true
## What the ARBITER attributed to this field. Written by the runtime, read here.
var damage_dealt: float = 0.0
var contributions: int = 0

var _disc: MeshInstance3D
var _rim: Array = []
var _light: OmniLight3D

## Sixteen rim ticks: a LAYOUT choice, not a gameplay value. They are hidden one
## by one as the Duration runs out, so "how much longer" is a SHAPE rather than a
## fading tint -- readable without colour alone.
const RIM_TICKS := 16

func build() -> void:
	_disc = MeshInstance3D.new()
	_disc.name = "BurningGroundDisc"
	var cyl := CylinderMesh.new()
	cyl.top_radius = radius
	cyl.bottom_radius = radius
	cyl.height = 0.010
	cyl.radial_segments = 40
	_disc.mesh = cyl
	_disc.position = Vector3(0.0, CinderConfig.GROUND_DECAL_Y, 0.0)
	var m := StandardMaterial3D.new()
	m.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	m.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	m.albedo_color = Color(CinderConfig.COL_GROUND.r, CinderConfig.COL_GROUND.g,
		CinderConfig.COL_GROUND.b, 0.34)
	m.emission_enabled = true
	m.emission = CinderConfig.COL_GROUND
	m.emission_energy_multiplier = 1.5
	_disc.material_override = m
	add_child(_disc)

	for k in RIM_TICKS:
		var tick := MeshInstance3D.new()
		tick.name = "RimTick%d" % k
		var box := BoxMesh.new()
		box.size = Vector3(0.20, 0.014, 0.07)
		tick.mesh = box
		var ang := TAU * float(k) / float(RIM_TICKS)
		tick.position = Vector3(cos(ang) * radius, CinderConfig.GROUND_RIM_Y, sin(ang) * radius)
		tick.rotation.y = -ang
		var tm := StandardMaterial3D.new()
		tm.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		tm.albedo_color = CinderConfig.COL_ERUPTION
		tm.emission_enabled = true
		tm.emission = CinderConfig.COL_ERUPTION
		tm.emission_energy_multiplier = 3.0
		tick.material_override = tm
		add_child(tick)
		_rim.append(tick)

	_light = OmniLight3D.new()
	_light.name = "GroundLight"
	_light.light_color = CinderConfig.COL_GROUND
	_light.light_energy = 1.6
	_light.omni_range = radius + 1.6
	_light.shadow_enabled = false
	_light.position = Vector3(0.0, 0.45, 0.0)
	add_child(_light)

func _physics_process(delta: float) -> void:
	step(delta)

## Separated so the suite can drive exact steps. It NEVER damages anything: the
## arbiter does that, once per enemy per tick.
func step(delta: float) -> void:
	if not alive:
		return
	elapsed += delta
	if elapsed >= duration:
		alive = false
		queue_free()
		return
	_refresh_visual()

## TRUE when a planar point lies inside this field. Height is presentation and
## never a gameplay coordinate, so the test is planar.
func contains_point(p: Vector3) -> bool:
	return NavService.planar_distance(global_position, p) <= radius

func remaining() -> float:
	return maxf(0.0, duration - elapsed)

func _refresh_visual() -> void:
	var left := clampf(remaining() / maxf(0.0001, duration), 0.0, 1.0)
	var lit := int(ceil(left * float(RIM_TICKS)))
	for k in _rim.size():
		(_rim[k] as MeshInstance3D).visible = k < lit
	if _light != null:
		_light.light_energy = 0.7 + 1.1 * left

func snapshot() -> Dictionary:
	return {
		"ordinal": ordinal,
		"use_id": use_id,
		"dps": dps,
		"radius": radius,
		"remaining": remaining(),
		"damage": damage_dealt,
		"contributions": contributions,
		"position": global_position,
	}
