class_name TargetDummy
extends StaticBody3D

## A STATIONARY DIAGNOSTIC TARGET — one of exactly two.
##
## ============================================================================
## CLEARLY DISTINGUISHABLE, AND NOT BY COLOUR ALONE.
## ============================================================================
## Target A has a ROUND head and a round base plate; target B a SQUARE head and a
## square base plate. Each carries a floating text label ("TARGET A" / "TARGET
## B"). Colour differs too, but it is the third cue, never the only one.
##
## It is NOT an enemy, has no AI and never attacks. Its health, respawn and
## size are DIAGNOSTIC. Its Prey marker -- a ground ring with inward chevrons
## and the word PREY -- is switched ONLY by `PreyState`.
##
## Body layers: 2 (a target -- the arrow's overlap mask, and solid to the
## player) and 4 (world -- so the one navigation bake treats it as an obstacle
## and paths route around it, as they would around any real body).

signal died_target(t: TargetDummy)

var label_text: String = ""
var shape_kind: String = "round"             ## "round" | "square"
var tint: Color = Color.WHITE
var life := Damageable.new(SpikeConfig.TARGET_HEALTH)
var alive: bool = true
var deaths: int = 0
var respawns: int = 0
## Ledger of damage by source kind: "direct_use" (the archer) vs "minion".
var damage_by_source: Dictionary = {"direct_use": 0.0, "minion": 0.0}
var hits_by_source: Dictionary = {"direct_use": 0, "minion": 0}
var last_hit_amount: float = 0.0

var prey_marker: Node3D
var _visual: Node3D
var _shape: CollisionShape3D
var _label: Label3D
var _flash_t: float = 0.0
var _topple_t: float = -1.0
var _respawn_t: float = -1.0
var _mats: Array[StandardMaterial3D] = []

func build(p_label: String, p_shape: String, p_tint: Color) -> void:
	label_text = p_label
	shape_kind = p_shape
	tint = p_tint
	name = p_label.replace(" ", "_")
	collision_layer = 2 | 4
	collision_mask = 0
	_shape = CollisionShape3D.new()
	var cyl := CylinderShape3D.new()
	cyl.radius = SpikeConfig.TARGET_RADIUS_M
	cyl.height = 2.0
	_shape.shape = cyl
	_shape.position = Vector3(0, 1.0, 0)
	add_child(_shape)

	_visual = Node3D.new()
	_visual.name = "DummyVisual"
	add_child(_visual)
	var wood := _mat(Color(0.30, 0.22, 0.15), 0.9)
	var body_col := _mat(tint.darkened(0.35), 0.8)
	var head_col := _mat(tint, 0.6)
	# Base plate -- round or square: a shape cue at the ground.
	var base := MeshInstance3D.new()
	if shape_kind == "round":
		var c := CylinderMesh.new()
		c.top_radius = 0.42; c.bottom_radius = 0.46; c.height = 0.10
		base.mesh = c
	else:
		var b := BoxMesh.new()
		b.size = Vector3(0.84, 0.10, 0.84)
		base.mesh = b
	base.material_override = wood
	base.position = Vector3(0, 0.05, 0)
	_visual.add_child(base)
	var post := MeshInstance3D.new()
	var pc := CylinderMesh.new()
	pc.top_radius = 0.07; pc.bottom_radius = 0.09; pc.height = 1.0
	post.mesh = pc
	post.material_override = wood
	post.position = Vector3(0, 0.6, 0)
	_visual.add_child(post)
	var torso := MeshInstance3D.new()
	var tc := CapsuleMesh.new()
	tc.radius = 0.24; tc.height = 0.78
	torso.mesh = tc
	torso.material_override = body_col
	torso.position = Vector3(0, 1.28, 0)
	_visual.add_child(torso)
	var head := MeshInstance3D.new()
	if shape_kind == "round":
		var s := SphereMesh.new()
		s.radius = 0.20; s.height = 0.40
		head.mesh = s
	else:
		var hb := BoxMesh.new()
		hb.size = Vector3(0.36, 0.36, 0.36)
		head.mesh = hb
	head.material_override = head_col
	head.position = Vector3(0, 1.90, 0)
	_visual.add_child(head)
	_label = Label3D.new()
	_label.name = "TargetLabel"
	_label.text = label_text
	_label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	_label.no_depth_test = true
	_label.layers = SpikeConfig.LABEL_RENDER_LAYER
	_label.font_size = 44
	_label.outline_size = 12
	_label.pixel_size = 0.006
	_label.modulate = Color(0.95, 0.95, 0.95)
	_label.position = Vector3(0, 2.45, 0)
	add_child(_label)
	_build_prey_marker()
	GroundShadow.attach_to(self, SpikeConfig.TARGET_RADIUS_M)

func _mat(c: Color, rough: float) -> StandardMaterial3D:
	var m := StandardMaterial3D.new()
	m.albedo_color = c
	m.roughness = rough
	_mats.append(m)
	return m

## THE PREY MARKER: a ground ring, three inward chevrons, and the word PREY.
## Shape and text carry the meaning; colour only reinforces it (P-11).
func _build_prey_marker() -> void:
	prey_marker = Node3D.new()
	prey_marker.name = "PreyMarker"
	add_child(prey_marker)
	var m := StandardMaterial3D.new()
	m.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	m.albedo_color = Color(1.0, 0.62, 0.16)
	m.emission_enabled = true
	m.emission = Color(1.0, 0.55, 0.12)
	var ring := MeshInstance3D.new()
	ring.name = "PreyRing"
	var tor := TorusMesh.new()
	tor.inner_radius = 0.66
	tor.outer_radius = 0.74
	tor.rings = 40
	tor.ring_segments = 4
	ring.mesh = tor
	ring.material_override = m
	ring.scale = Vector3(1.0, 0.25, 1.0)
	ring.position = Vector3(0, 0.08, 0)
	prey_marker.add_child(ring)
	for k in 3:
		var chev := MeshInstance3D.new()
		chev.name = "PreyChevron%d" % k
		var pm := PrismMesh.new()
		pm.size = Vector3(0.26, 0.26, 0.04)
		chev.mesh = pm
		chev.material_override = m
		var ang := TAU * float(k) / 3.0
		# Lie flat, pointing INWARD at the target.
		chev.basis = Basis(Vector3.UP, ang + PI) * Basis(Vector3.RIGHT, -PI * 0.5)
		chev.position = Vector3(sin(ang) * 0.98, 0.09, cos(ang) * 0.98)
		prey_marker.add_child(chev)
	var word := Label3D.new()
	word.name = "PreyWord"
	word.text = "PREY"
	word.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	word.no_depth_test = true
	word.layers = SpikeConfig.LABEL_RENDER_LAYER
	word.font_size = 56
	word.outline_size = 14
	word.pixel_size = 0.006
	word.modulate = Color(1.0, 0.72, 0.30)
	word.position = Vector3(0, 2.85, 0)
	prey_marker.add_child(word)
	prey_marker.visible = false

func set_prey(v: bool) -> void:
	prey_marker.visible = v

func is_marked() -> bool:
	return prey_marker.visible

## Every hit, from the archer or the hound, lands here with its SOURCE KIND.
## The dummy never designates Prey itself: `PreyState` decides, and only for a
## direct use.
func receive_damage(amount: float, from: Vector3, source_kind: String = "direct_use") -> void:
	if not alive:
		return
	var before := life.life
	life.apply(amount, from)
	last_hit_amount = before - life.life
	damage_by_source[source_kind] = float(damage_by_source.get(source_kind, 0.0)) + last_hit_amount
	hits_by_source[source_kind] = int(hits_by_source.get(source_kind, 0)) + 1
	_flash_t = 0.12
	if life.dead:
		_die()

func _die() -> void:
	alive = false
	deaths += 1
	_shape.disabled = true
	_topple_t = 0.0
	_respawn_t = SpikeConfig.TARGET_RESPAWN_S
	died_target.emit(self)

func respawn() -> void:
	life.reset()
	alive = true
	respawns += 1
	_shape.disabled = false
	_visual.rotation = Vector3.ZERO
	_visual.visible = true
	_label.visible = true
	_topple_t = -1.0
	_respawn_t = -1.0

func _process(delta: float) -> void:
	if _flash_t > 0.0:
		_flash_t -= delta
	var glow := clampf(_flash_t / 0.12, 0.0, 1.0)
	for m in _mats:
		m.emission_enabled = glow > 0.0
		m.emission = Color(1, 1, 1) * glow * 0.6
	if _topple_t >= 0.0:
		_topple_t += delta
		_visual.rotation.x = -clampf(_topple_t / 0.4, 0.0, 1.0) * PI * 0.5
		if _topple_t > 1.0:
			_visual.visible = false
			_label.visible = false

func _physics_process(delta: float) -> void:
	if _respawn_t > 0.0:
		_respawn_t -= delta
		if _respawn_t <= 0.0:
			respawn()
