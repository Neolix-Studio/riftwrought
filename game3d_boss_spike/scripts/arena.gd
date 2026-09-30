class_name Arena
extends Node3D

## A FIXED BOSS ARENA for the D-368 gate, assembled from stock Ultimate Modular
## Ruins modules on the pack's OWN module grid, which is MEASURED from
## Floor_Standard's AABB rather than assumed.
##
## It is a TEST SPACE, not a zone. It is not the Hall of the Empty Crown, not
## the Crownless Bastion, not an Act I room, and it authorizes no campaign
## content. Its only jobs are: keep the fight inside the accepted provisional
## camera framing, give the telegraphs a readable surface, and provide the warm
## torch lighting the visual direction calls for.
##
## ALL COLOUR IS A RUNTIME MATERIAL OVERRIDE. NO SOURCE MESH IS EDITED.

signal imps_summoned(count: int)

const R := RigCompat.RUINS

var module_m: float = 2.0                # MEASURED at build time
var floor_tiles: int = 0
var wall_pieces: int = 0
var torch_lights: int = 0
var props: int = 0
var imps: Array = []

var _corpus: AnimationLibrary
var _player: Node3D
var _half_extent_m: float = 11.0

func build(corpus: AnimationLibrary, player: Node3D) -> void:
	_corpus = corpus
	_player = player

	# --- MEASURE the pack's own module size -------------------------------
	var floor_mesh: Mesh = load(R % "Floor_Standard")
	if floor_mesh != null:
		var a := floor_mesh.get_aabb()
		module_m = maxf(a.size.x, a.size.z)
	var step := module_m

	# --- lighting ---------------------------------------------------------
	var env := WorldEnvironment.new()
	var e := Environment.new()
	e.background_mode = Environment.BG_COLOR
	e.background_color = Color(0.043, 0.055, 0.086)
	e.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	e.ambient_light_color = Color(0.36, 0.42, 0.58)
	e.ambient_light_energy = GateConfig.AMBIENT_ENERGY
	e.fog_enabled = true
	e.fog_light_color = Color(0.10, 0.12, 0.18)
	e.fog_density = 0.010
	e.tonemap_mode = Environment.TONE_MAPPER_ACES
	e.glow_enabled = true
	e.glow_intensity = 0.55
	e.glow_bloom = 0.10
	env.environment = e
	add_child(env)

	var moon := DirectionalLight3D.new()
	moon.name = "Moonlight"
	moon.light_color = Color(0.62, 0.72, 1.0)
	moon.light_energy = GateConfig.SUN_ENERGY
	moon.rotation_degrees = Vector3(-58, 36, 0)
	moon.shadow_enabled = true
	add_child(moon)

	# --- floor ------------------------------------------------------------
	var tiles := 12                      # 12 x 12 modules
	_half_extent_m = (float(tiles) * step) * 0.5
	var floor_root := Node3D.new()
	floor_root.name = "Floor"
	add_child(floor_root)
	for ix in tiles:
		for iz in tiles:
			var mi := MeshInstance3D.new()
			mi.mesh = floor_mesh
			mi.position = Vector3(
				(float(ix) - float(tiles) * 0.5 + 0.5) * step, 0.0,
				(float(iz) - float(tiles) * 0.5 + 0.5) * step)
			floor_root.add_child(mi)
			floor_tiles += 1
	RigCompat.tint_all(floor_root, [], GateConfig.COL_GROUND)

	# --- perimeter walls --------------------------------------------------
	var wall_mesh: Mesh = load(R % "Wall")
	var broken_mesh: Mesh = load(R % "Wall_Broken")
	var walls := Node3D.new()
	walls.name = "Walls"
	add_child(walls)
	for i in tiles:
		var off: float = (float(i) - float(tiles) * 0.5 + 0.5) * step
		var edge: float = _half_extent_m
		for spec in [
			[Vector3(off, 0, -edge), 0.0],
			[Vector3(off, 0, edge), 180.0],
			[Vector3(-edge, 0, off), 90.0],
			[Vector3(edge, 0, off), 270.0],
		]:
			var mi := MeshInstance3D.new()
			# A few broken sections so the perimeter is not a uniform box.
			mi.mesh = broken_mesh if (i % 5) == 2 else wall_mesh
			mi.position = spec[0]
			mi.rotation_degrees = Vector3(0, float(spec[1]), 0)
			walls.add_child(mi)
			wall_pieces += 1

			var body := StaticBody3D.new()
			var cs := CollisionShape3D.new()
			var box := BoxShape3D.new()
			box.size = Vector3(step, 3.0, 0.4)
			cs.shape = box
			body.add_child(cs)
			body.position = spec[0] + Vector3(0, 1.5, 0)
			body.rotation_degrees = Vector3(0, float(spec[1]), 0)
			body.collision_layer = 4
			add_child(body)
	RigCompat.tint_all(walls, [], GateConfig.COL_STONE_MAIN)

	# --- columns, statue, banners, skulls ---------------------------------
	var deco := Node3D.new()
	deco.name = "Deco"
	add_child(deco)
	var col_mesh: Mesh = load(R % "Column_Round")
	var inner: float = _half_extent_m - step * 1.5
	for spec2 in [Vector3(-inner, 0, -inner), Vector3(inner, 0, -inner),
			Vector3(-inner, 0, inner), Vector3(inner, 0, inner)]:
		var c := MeshInstance3D.new()
		c.mesh = col_mesh
		c.position = spec2
		deco.add_child(c)
		props += 1
		var cb := StaticBody3D.new()
		var ccs := CollisionShape3D.new()
		var cyl := CylinderShape3D.new()
		cyl.radius = 0.55
		cyl.height = 4.0
		ccs.shape = cyl
		cb.add_child(ccs)
		cb.position = spec2 + Vector3(0, 2.0, 0)
		cb.collision_layer = 4
		add_child(cb)

	var arch := MeshInstance3D.new()
	arch.mesh = load(R % "Arch_Gothic")
	arch.position = Vector3(0, 0, -_half_extent_m + step * 0.5)
	deco.add_child(arch)
	props += 1

	var statue := MeshInstance3D.new()
	statue.mesh = load(R % "Statue_Stag")
	statue.position = Vector3(0, 0, -_half_extent_m + step * 2.0)
	statue.scale = Vector3.ONE * 1.25
	deco.add_child(statue)
	props += 1

	for sx in [-3.2, 2.6, -1.4, 4.1]:
		var sk := MeshInstance3D.new()
		sk.mesh = load(R % "Skull")
		sk.position = Vector3(float(sx), 0.05, float(sx) * 0.6 + 2.0)
		sk.rotation_degrees = Vector3(0, float(sx) * 40.0, 0)
		deco.add_child(sk)
		props += 1

	RigCompat.tint_all(deco, [
		{"match": "Wood", "color": GateConfig.COL_WOOD, "rough": 0.93},
		{"match": "Metal", "color": GateConfig.COL_METAL, "rough": 0.5, "metal": 0.6},
	], GateConfig.COL_STONE_HIGHLIGHT)

	# Bone props keep a distinct value so the ossuary read does not vanish into
	# the stone. Applied after the bulk tint, deliberately.
	for child in deco.get_children():
		var mi2 := child as MeshInstance3D
		if mi2 != null and mi2.mesh == load(R % "Skull"):
			RigCompat.tint_all(mi2, [], GateConfig.COL_BONE)

	var banners := Node3D.new()
	banners.name = "Banners"
	add_child(banners)
	for bz in [-1.0, 1.0]:
		var b := MeshInstance3D.new()
		b.mesh = load(R % "Flag_Wall")
		b.position = Vector3(-_half_extent_m + 0.3, 0, float(bz) * step * 2.0)
		b.rotation_degrees = Vector3(0, 90, 0)
		banners.add_child(b)
		props += 1
	RigCompat.tint_all(banners, [], GateConfig.COL_BANNER)

	# --- WARM LOCALIZED TORCH LIGHTING ------------------------------------
	var torch_mesh: Mesh = load(R % "Torch")
	var torches := Node3D.new()
	torches.name = "Torches"
	add_child(torches)
	var tpos := [
		Vector3(-inner, 0, 0), Vector3(inner, 0, 0),
		Vector3(0, 0, -inner), Vector3(0, 0, inner),
	]
	for p in tpos:
		var t := MeshInstance3D.new()
		t.mesh = torch_mesh
		t.position = p
		torches.add_child(t)
		props += 1
		var l := OmniLight3D.new()
		l.light_color = GateConfig.COL_TORCH_WARM
		l.light_energy = GateConfig.TORCH_LIGHT_ENERGY
		l.omni_range = GateConfig.TORCH_LIGHT_RANGE
		l.omni_attenuation = 1.6
		l.shadow_enabled = false
		l.position = p + Vector3(0, 2.1, 0)
		add_child(l)
		torch_lights += 1
	RigCompat.tint_all(torches, [
		{"match": "Wood", "color": GateConfig.COL_WOOD, "rough": 0.93},
	], GateConfig.COL_METAL)

func half_extent_m() -> float:
	return _half_extent_m

## Phase 2 summons minions. Imps are the ORDINARY supporting enemy, which is
## what the owner's instruction permits them to be.
func summon_imps(count: int) -> void:
	for i in count:
		var imp := OrdinaryEnemy.new()
		imp.name = "ImpSummoned_%d" % (imps.size() + 1)
		add_child(imp)
		imp.setup(_corpus, OrdinaryEnemy.Kind.IMP_MINION)
		imp.player = _player
		var a: float = TAU * (float(i) / float(maxi(1, count))) + 0.7
		imp.global_position = Vector3(sin(a) * 5.2, 0.0, cos(a) * 5.2)
		imps.append(imp)
	imps_summoned.emit(count)

func spawn_initial_imps(count: int) -> void:
	summon_imps(count)
