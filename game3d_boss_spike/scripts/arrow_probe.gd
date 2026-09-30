class_name ArrowProbe
extends Node3D

## The projectile of the ONE explicitly diagnostic, non-canonical action.
##
## CLAUDE.md 3.5 permits exactly one such action and requires it to be LABELLED
## DIAGNOSTIC IN THE RUNTIME. It is NOT a designed Skill, it defines NO class
## mechanic, and it writes no part of the canonical Huntress specification that
## remains a P2 prerequisite.
##
## It exists here for one reason: the boss has to be damaged for its hit
## reaction, its poise gate, its phase transition and its death sequence to be
## observable at all.

signal despawned(reason: String, at: Vector3)

const LABEL := GateConfig.PROJECTILE_LABEL

var direction: Vector3 = Vector3.FORWARD
var travelled: float = 0.0
var alive: bool = true

var _targets: Array = []

func setup(dir: Vector3, targets: Array) -> void:
	direction = dir.normalized()
	_targets = targets
	name = "ArrowProbe_DIAGNOSTIC"

	var mesh: Mesh = load(RigCompat.ARROW)
	var mi := MeshInstance3D.new()
	mi.name = "Arrow"
	mi.mesh = mesh
	var fit := RigCompat.prop_scale_for(mesh, 0.62)
	mi.scale = Vector3.ONE * float(fit["scale"])
	mi.rotation_degrees = Vector3(90, 0, 0)
	add_child(mi)
	RigCompat.tint_all(mi, [
		{"match": "Metal", "color": GateConfig.COL_METAL, "rough": 0.4, "metal": 0.7},
		{"match": "Wood", "color": GateConfig.COL_WOOD, "rough": 0.9},
	], GateConfig.COL_WOOD)

	# A small violet tracer so the shot reads at the isometric framing. VFX,
	# code-generated, not an imported asset.
	var tracer := MeshInstance3D.new()
	var bm := BoxMesh.new()
	bm.size = Vector3(0.05, 0.05, 0.55)
	tracer.mesh = bm
	var mat := StandardMaterial3D.new()
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mat.albedo_color = Color(GateConfig.COL_RIFT_VIOLET, 0.55)
	mat.emission_enabled = true
	mat.emission = GateConfig.COL_RIFT_VIOLET
	mat.emission_energy_multiplier = 5.0
	tracer.material_override = mat
	tracer.position = Vector3(0, 0, 0.3)
	add_child(tracer)

func _physics_process(delta: float) -> void:
	if not alive:
		return
	var step := GateConfig.ARROW_SPEED_MPS * delta
	global_position += direction * step
	travelled += step
	look_at(global_position + direction, Vector3.UP)

	for t in _targets:
		if t == null or not is_instance_valid(t):
			continue
		if not t.has_method("take_hit"):
			continue
		# Do not "hit" something already dead -- a phantom hit would corrupt the
		# hit-precedes-death ordering the suite checks.
		if t.has_method("state_name"):
			var sn: String = t.call("state_name")
			if sn == "DEAD" or sn == "DYING":
				continue
		var node3d := t as Node3D
		if node3d == null:
			continue
		var d: Vector3 = node3d.global_position - global_position
		d.y = 0.0
		var radius: float = 0.6
		if t is BossPuglin:
			radius = GateConfig.BOSS_BODY_RADIUS + 0.35
		elif t is OrdinaryEnemy:
			radius = GateConfig.CONTROL_BODY_RADIUS + 0.3
		if d.length() <= radius:
			t.call("take_hit", GateConfig.ARROW_DAMAGE,
				GateConfig.ARROW_POISE_DAMAGE, global_position)
			_despawn("hit")
			return

	if travelled >= GateConfig.ARROW_RANGE_M:
		_despawn("range")

func _despawn(reason: String) -> void:
	if not alive:
		return
	alive = false
	despawned.emit(reason, global_position)
	queue_free()
