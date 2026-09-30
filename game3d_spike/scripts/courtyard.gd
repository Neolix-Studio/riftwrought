class_name Courtyard
extends Node3D

## ONE SMALL RUINED COURTYARD, assembled from the Ultimate Modular Ruins Pack
## on the pack's own 2.0 m module grid (MEASURED: Floor_Standard's AABB is
## 1.990 x 1.977 m, Wall_Broken 1.990 m wide and 1.947 m tall).
##
## STOCK LOW-POLY GEOMETRY IS NOT PRESENTED AS FINAL PRODUCTION ART.
## Every colour below is a RUNTIME MATERIAL OVERRIDE. No source mesh is edited.
##
## The treatment follows the D-366 target: ordinary surfaces stay visually
## quiet (dark blue-gray, low contrast, high roughness), warm torch light is
## localized, and the violet Rift accent is restrained and belongs to actors
## and effects rather than to the architecture.

const MOD := 2.0                        # the pack's module size, MEASURED
const HALF := 5                         # modules from centre -> 20 x 20 m floor
const R := "res://assets/third_party/quaternius/ultimate_modular_ruins/%s.obj"

var torch_lights: Array[OmniLight3D] = []
var rift_lights: Array[OmniLight3D] = []
var static_pieces: int = 0

var _rng := RandomNumberGenerator.new()

# PROVISIONAL stone/ruin treatment rules, applied to every ruins module.
static func stone_rules() -> Array:
	return [
		{"match": "Highlights", "color": SpikeConfig.COL_STONE_HIGHLIGHT, "rough": 0.90, "spec": 0.12},
		{"match": "Main", "color": SpikeConfig.COL_STONE_MAIN, "rough": 0.93, "spec": 0.10},
		{"match": "DarkMetal", "color": SpikeConfig.COL_METAL, "rough": 0.62, "metal": 0.55},
		{"match": "Fire", "color": SpikeConfig.COL_TORCH_WARM, "rough": 0.40,
		 "emission": SpikeConfig.COL_TORCH_WARM, "energy": 7.0},
		{"match": "Leaf", "color": SpikeConfig.COL_FOLIAGE, "rough": 0.94},
		{"match": "Bark", "color": Color(0.086, 0.072, 0.066), "rough": 0.95},
		{"match": "Wood", "color": SpikeConfig.COL_WOOD, "rough": 0.90},
		{"match": "Red", "color": SpikeConfig.COL_BANNER, "rough": 0.88},
		{"match": "Gold", "color": Color(0.42, 0.30, 0.11), "rough": 0.45, "metal": 0.70},
		{"match": "Steel", "color": SpikeConfig.COL_METAL, "rough": 0.55, "metal": 0.60},
		{"match": "Bone", "color": Color(0.30, 0.30, 0.28), "rough": 0.88},
		{"match": "White", "color": Color(0.26, 0.26, 0.25), "rough": 0.88},
		{"match": "Grass", "color": SpikeConfig.COL_FOLIAGE, "rough": 0.94},
	]

func piece(model: String, pos: Vector3, yaw_deg: float = 0.0,
		scale_v: float = 1.0) -> MeshInstance3D:
	var m: Mesh = load(R % model)
	if m == null:
		push_error("SPIKE: ruins model missing: %s" % model)
		return null
	var mi := MeshInstance3D.new()
	mi.name = model
	mi.mesh = m
	mi.position = pos
	mi.rotation_degrees = Vector3(0, yaw_deg, 0)
	mi.scale = Vector3.ONE * scale_v
	add_child(mi)
	RigAssembly.tint_all(mi, stone_rules(), SpikeConfig.COL_STONE_MAIN)
	static_pieces += 1
	return mi

func torch(pos: Vector3, yaw_deg: float = 0.0) -> void:
	piece("Torch", pos, yaw_deg)
	var l := OmniLight3D.new()
	l.light_color = SpikeConfig.COL_TORCH_WARM
	l.light_energy = SpikeConfig.TORCH_LIGHT_ENERGY
	l.omni_range = SpikeConfig.TORCH_LIGHT_RANGE
	l.omni_attenuation = 1.6
	l.shadow_enabled = false
	l.position = pos + Vector3(0, 0.95, 0)
	add_child(l)
	torch_lights.append(l)

func rift_vent(pos: Vector3) -> void:
	## A restrained violet Rift accent. Small, few, and never competing with
	## the actors it is meant to sit behind.
	var l := OmniLight3D.new()
	l.light_color = SpikeConfig.COL_RIFT_VIOLET
	l.light_energy = SpikeConfig.RIFT_LIGHT_ENERGY
	l.omni_range = SpikeConfig.RIFT_LIGHT_RANGE
	l.omni_attenuation = 2.0
	l.shadow_enabled = false
	l.position = pos + Vector3(0, 0.35, 0)
	add_child(l)
	rift_lights.append(l)

	var glow := MeshInstance3D.new()
	var q := QuadMesh.new()
	q.size = Vector2(1.9, 1.9)
	glow.mesh = q
	glow.rotation_degrees = Vector3(-90, 0, 0)
	glow.position = pos + Vector3(0, 0.02, 0)
	var gm := StandardMaterial3D.new()
	gm.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	gm.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	gm.albedo_color = Color(SpikeConfig.COL_RIFT_VIOLET.r, SpikeConfig.COL_RIFT_VIOLET.g,
		SpikeConfig.COL_RIFT_VIOLET.b, 0.30)
	gm.emission_enabled = true
	gm.emission = SpikeConfig.COL_RIFT_VIOLET
	gm.emission_energy_multiplier = 2.0
	glow.material_override = gm
	add_child(glow)

func build() -> void:
	_rng.seed = 20260917          # deterministic layout; no unseeded randomness

	# --- floor -------------------------------------------------------------
	for gx in range(-HALF, HALF + 1):
		for gz in range(-HALF, HALF + 1):
			var variant := "Floor_Standard"
			var r := _rng.randf()
			if r < 0.20:
				variant = "Floor_Squares"
			elif r < 0.30:
				variant = "Floor_SquareLarge"
			piece(variant, Vector3(gx * MOD, 0, gz * MOD),
				90.0 * float(_rng.randi_range(0, 3)))

	# --- perimeter walls, deliberately broken and gapped -------------------
	var wall_kinds := ["Wall_Broken", "Wall_Half", "Wall_Overgrown",
		"Wall_ArchRound_Broken", "Wall_ArchRound_Overgrown_Broken"]
	var edge := float(HALF) * MOD + MOD * 0.5
	for g in range(-HALF, HALF + 1):
		var p := float(g) * MOD
		# north / south
		if absf(p) > 1.5:
			piece(wall_kinds[_rng.randi_range(0, wall_kinds.size() - 1)],
				Vector3(p, 0, -edge), 0.0)
			piece(wall_kinds[_rng.randi_range(0, wall_kinds.size() - 1)],
				Vector3(p, 0, edge), 180.0)
		# east / west
		if absf(p) > 3.5:
			piece(wall_kinds[_rng.randi_range(0, wall_kinds.size() - 1)],
				Vector3(-edge, 0, p), 90.0)
			piece(wall_kinds[_rng.randi_range(0, wall_kinds.size() - 1)],
				Vector3(edge, 0, p), 270.0)

	# --- corner columns and arches ----------------------------------------
	for sx in [-1.0, 1.0]:
		for sz in [-1.0, 1.0]:
			piece("Column_Round", Vector3(sx * edge, 0, sz * edge))
			piece("Column_Round_Short", Vector3(sx * (edge - MOD), 0, sz * edge))
	piece("Arch_Gothic", Vector3(0, 0, -edge), 0.0)
	piece("Arch_Round_RoundColumn", Vector3(0, 0, edge), 180.0)
	piece("Stairs", Vector3(-edge + 0.4, 0, 0), 90.0)
	piece("Stairs", Vector3(edge - 0.4, 0, 0), 270.0)

	# --- banners (the reference's red wall hangings) -----------------------
	piece("Flag_Wall", Vector3(-edge + 0.18, 0, -MOD * 2.0), 90.0)
	piece("Flag_Wall2", Vector3(edge - 0.18, 0, MOD * 2.0), 270.0)
	piece("Flag_Wall", Vector3(-MOD * 3.0, 0, -edge + 0.18), 0.0)

	# --- focal statue ------------------------------------------------------
	piece("Statue_Stag", Vector3(-edge + MOD * 0.9, 0, -edge + MOD * 0.9), 45.0)

	# --- torches: warm and localized, ringing the courtyard ----------------
	# Each is a small pool of warm light against the cold base, which is the
	# separation the D-366 target asks for. PROVISIONAL count and placement.
	torch(Vector3(-edge + 0.35, 0.55, -MOD * 2.0), 90.0)
	torch(Vector3(-edge + 0.35, 0.55, MOD * 2.5), 90.0)
	torch(Vector3(edge - 0.35, 0.55, MOD * 2.0), 270.0)
	torch(Vector3(edge - 0.35, 0.55, -MOD * 2.5), 270.0)
	torch(Vector3(-MOD * 2.0, 0.55, -edge + 0.35), 0.0)
	torch(Vector3(MOD * 2.5, 0.55, -edge + 0.35), 0.0)
	torch(Vector3(MOD * 3.0, 0.55, edge - 0.35), 180.0)
	torch(Vector3(-MOD * 2.5, 0.55, edge - 0.35), 180.0)

	# --- restrained violet Rift accents ------------------------------------
	rift_vent(Vector3(MOD * 2.6, 0, -MOD * 2.6))
	rift_vent(Vector3(-MOD * 3.2, 0, MOD * 3.0))

	# --- scattered props ---------------------------------------------------
	var props := ["Barrel", "Crate", "Pot1_Broken", "Pot2_Broken", "Skull",
		"Bush_Round", "Bush_1x1", "Bricks", "Rail_Straight", "Grass"]
	for i in range(26):
		var prop_name: String = props[_rng.randi_range(0, props.size() - 1)]
		var px := _rng.randf_range(-edge + 1.0, edge - 1.0)
		var pz := _rng.randf_range(-edge + 1.0, edge - 1.0)
		if Vector2(px, pz).length() < 3.2:
			continue                      # keep the combat space clear
		piece(prop_name, Vector3(px, 0, pz), _rng.randf_range(0, 360))
	piece("DeadTree_1", Vector3(edge - MOD * 1.2, 0, -edge + MOD * 1.1), 20.0)

	# --- collision: a simple perimeter box, NOT authored per-mesh ----------
	# Stated plainly because it is a spike-level simplification.
	var inner := float(HALF) * MOD + MOD * 0.35
	for spec in [[Vector3(0, 1, -inner), Vector3(inner * 2.2, 2.4, 0.5)],
				 [Vector3(0, 1, inner), Vector3(inner * 2.2, 2.4, 0.5)],
				 [Vector3(-inner, 1, 0), Vector3(0.5, 2.4, inner * 2.2)],
				 [Vector3(inner, 1, 0), Vector3(0.5, 2.4, inner * 2.2)]]:
		var sb := StaticBody3D.new()
		sb.collision_layer = 4
		var cs := CollisionShape3D.new()
		var bx := BoxShape3D.new()
		bx.size = spec[1]
		cs.shape = bx
		sb.position = spec[0]
		sb.add_child(cs)
		add_child(sb)

func arena_extent() -> float:
	return float(HALF) * MOD
