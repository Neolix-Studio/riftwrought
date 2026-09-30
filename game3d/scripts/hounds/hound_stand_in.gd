class_name HoundStandIn
extends Node3D

## A PROCEDURAL HOUND STAND-IN — NO HOUND ART IS PROVEN, AND NONE IS CLAIMED.
##
## ============================================================================
## ENGINE PRIMITIVES ONLY. IT PROVES BEHAVIOUR, NEVER ART.
## ============================================================================
## The owner: "No usable production hound asset exists. Use clearly labelled
## procedural stand-ins, informed by -- but with no runtime dependency on -- the
## closed D-388 spike. Do not use the excluded Ultimate Monsters dog or intake any
## new asset/VFX archive." So: a capsule body, a box head and snout, two ears, a
## collar, four legs and a tail, all built HERE from Godot primitives. No mesh is
## loaded, no file of the spike is read, and no archive is opened.
##
## ---------------------------------------------------------------------------
## FRIEND OR FOE WITHOUT COLOUR ALONE (canon §0.5.6).
## ---------------------------------------------------------------------------
##   1. SILHOUETTE -- a low, long QUADRUPED; every enemy here is an upright biped;
##   2. A DASHED ALLY RING on the ground -- eight separate segments, a shape the
##      enemies' solid telegraph wedge never makes;
##   3. A SMALL LABEL, H1 / H2, which the review HUD's lines name.
## Colour (a cool teal on the ring and collar) is a fourth cue, never the only one.
##
## D-398: a DIAGNOSTIC STRESS MINION wears the same stand-in and is labelled S3,
## S4 ... so the owner can tell it from the pack. A SOFT RECOVERY shrinks the body
## where it stands, and grows it again at its new slot -- a PLACEHOLDER fade, not
## final VFX, read from the hound's own fields on the render frame.
##
## ---------------------------------------------------------------------------
## PRESENTATION ONLY, ON THE RENDER FRAME.
## ---------------------------------------------------------------------------
## It READS its hound in `_process`: speed for the gait, bites for a lunge, the
## target for a dashed line, FALLEN for a collapse and a RETURNING countdown. It
## writes nothing the mechanics read. Removed, no gameplay quantity changes.

const ALLY_COLOUR := Color(0.36, 0.86, 0.92)
const FUR_COLOUR := Color(0.40, 0.35, 0.29)
const DARK_COLOUR := Color(0.14, 0.13, 0.12)
const RING_SEGMENTS := 8
const RING_RADIUS := 0.50

var hound: KindredHound = null
## Set by the runtime while this hound is RETURNING: seconds left.
var returning_in: float = -1.0

var body: Node3D
var label: Label3D
var ring: Node3D
var legs: Array[MeshInstance3D] = []
var target_line: MeshInstance3D
var _line_mesh: ImmediateMesh
var _gait: float = 0.0
var _lunge_t: float = -1.0
var _seen_bites: int = 0
var _fall_t: float = 0.0
## Diagnostics the suite reads.
var lunges: int = 0
var frames_drawn: int = 0
var primitive_count: int = 0

func build(p_hound: KindredHound) -> void:
	hound = p_hound
	name = "HoundStandIn_PLACEHOLDER"
	body = Node3D.new()
	body.name = "HoundPrimitives"
	add_child(body)
	var fur := _mat(FUR_COLOUR, 0.95)
	var dark := _mat(DARK_COLOUR, 0.9)
	var ally := _mat(ALLY_COLOUR, 0.6)
	ally.emission_enabled = true
	ally.emission = ALLY_COLOUR
	ally.emission_energy_multiplier = 0.6
	# Body along +Z (the hound's forward), head at the front.
	_prim(body, _capsule(0.17, 0.80), fur, Vector3(0, 0.50, 0), Vector3(90, 0, 0), "Torso")
	_prim(body, _box(Vector3(0.22, 0.22, 0.26)), fur, Vector3(0, 0.68, 0.44), Vector3.ZERO, "Head")
	_prim(body, _box(Vector3(0.12, 0.10, 0.17)), dark, Vector3(0, 0.63, 0.63), Vector3.ZERO, "Snout")
	_prim(body, _box(Vector3(0.05, 0.12, 0.05)), dark, Vector3(-0.07, 0.84, 0.40), Vector3(0, 0, 12), "EarL")
	_prim(body, _box(Vector3(0.05, 0.12, 0.05)), dark, Vector3(0.07, 0.84, 0.40), Vector3(0, 0, -12), "EarR")
	_prim(body, _torus(0.12, 0.155), ally, Vector3(0, 0.62, 0.30), Vector3(90, 0, 0), "Collar")
	for e in [[-0.10, 0.20], [-0.10, -0.26], [0.10, 0.20], [0.10, -0.26]]:
		var leg := _prim(body, _cylinder(0.045, 0.035, 0.42), dark,
			Vector3(float(e[0]), 0.21, float(e[1])), Vector3.ZERO, "Leg")
		legs.append(leg)
	_prim(body, _cylinder(0.02, 0.04, 0.34), fur, Vector3(0, 0.62, -0.50), Vector3(-55, 0, 0), "Tail")
	# THE DASHED ALLY RING.
	ring = Node3D.new()
	ring.name = "AllyRing"
	add_child(ring)
	var ring_mat := _mat(ALLY_COLOUR, 0.5)
	ring_mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	for k in RING_SEGMENTS:
		var ang := TAU * float(k) / float(RING_SEGMENTS)
		_prim(ring, _box(Vector3(0.17, 0.02, 0.045)), ring_mat,
			Vector3(sin(ang) * RING_RADIUS, ProdConfig.DECAL_SHADOW_Y, cos(ang) * RING_RADIUS),
			Vector3(0, rad_to_deg(ang) + 90.0, 0), "RingDash")
	# THE LABEL.
	label = Label3D.new()
	label.name = "HoundLabel"
	label.text = _tag()
	label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	label.no_depth_test = true
	label.font_size = 30
	label.outline_size = 10
	label.pixel_size = 0.006
	label.modulate = Color(0.80, 0.96, 1.0)
	label.position = Vector3(0, 1.05, 0)
	add_child(label)
	GroundShadow.attach_to(self, HoundConfig.BODY_RADIUS_M)
	# THE DASHED TARGET LINE, drawn in world space.
	_line_mesh = ImmediateMesh.new()
	target_line = MeshInstance3D.new()
	target_line.name = "HoundTargetLine"
	target_line.top_level = true
	target_line.mesh = _line_mesh
	var lm := _mat(ALLY_COLOUR, 0.5)
	lm.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	target_line.material_override = lm
	add_child(target_line)

func label_text() -> String:
	return label.text if label != null else ""

## H1, H2 for the pack; S3, S4 ... for a DIAGNOSTIC STRESS MINION (D-398).
func _tag() -> String:
	return ("S%d" if hound.diagnostic_stress else "H%d") % (hound.index + 1)

func _process(delta: float) -> void:
	if hound == null or not is_instance_valid(hound):
		return
	frames_drawn += 1
	# FALLEN: collapse and fade, then only the ring and a RETURNING countdown.
	if hound.is_fallen():
		_fall_t += delta
		var k := clampf(_fall_t / 0.35, 0.0, 1.0)
		body.rotation.z = lerpf(0.0, PI * 0.5, k)
		body.position.y = lerpf(0.0, -0.12, k)
		body.visible = _fall_t < 0.9
		label.text = "%s RETURNING %.1f s" % [_tag(), maxf(0.0, returning_in)] \
			if returning_in >= 0.0 else "%s FALLEN" % _tag()
		ring.scale = Vector3.ONE * 0.7
		_line_mesh.clear_surfaces()
		return
	_fall_t = 0.0
	body.visible = true
	body.rotation.z = 0.0
	ring.scale = Vector3.ONE
	label.text = _tag()
	# D-398: THE SOFT RECOVERY -- shrink where it stood, grow where it lands.
	var fade := 1.0
	if hound.recover_phase == "OUT":
		fade = lerpf(1.0, 0.15, clampf(hound.recover_t / CohortConfig.RECOVERY_OUT_S, 0.0, 1.0))
	elif hound.recover_phase == "IN":
		fade = lerpf(0.15, 1.0, clampf(hound.recover_t / CohortConfig.RECOVERY_IN_S, 0.0, 1.0))
	body.scale = Vector3.ONE * fade
	ring.scale = Vector3.ONE * lerpf(0.5, 1.0, fade)
	if hound.recover_phase != "":
		label.text = "%s REJOINING" % _tag()
	# FACE WHERE IT IS GOING, OR ITS TARGET.
	var face := hound.velocity
	face.y = 0.0
	if face.length() < 0.05 and not hound.target.is_empty():
		face = HoundTargeting.position_of(hound.target) - hound.global_position
		face.y = 0.0
	if face.length() > 0.05:
		rotation.y = lerp_angle(rotation.y, atan2(face.x, face.z), clampf(delta * 12.0, 0.0, 1.0))
	# GAIT AND LUNGE.
	var speed := Vector2(hound.velocity.x, hound.velocity.z).length()
	_gait += delta * (6.0 + speed * 2.5)
	var amp := clampf(speed / HoundConfig.SPEED_MPS, 0.0, 1.0) * 0.55
	for i in legs.size():
		var ph := _gait + (PI if i == 1 or i == 2 else 0.0)
		legs[i].rotation.x = sin(ph) * amp
	if hound.bites != _seen_bites:
		_seen_bites = hound.bites
		_lunge_t = 0.0
		lunges += 1
	var lunge := 0.0
	if _lunge_t >= 0.0:
		_lunge_t += delta
		lunge = sin(clampf(_lunge_t / 0.18, 0.0, 1.0) * PI) * 0.18
		if _lunge_t > 0.18:
			_lunge_t = -1.0
	body.position = Vector3(0, absf(sin(_gait)) * 0.03 * amp, lunge)
	body.rotation.x = -lunge * 0.8
	_draw_target_line()

func _draw_target_line() -> void:
	_line_mesh.clear_surfaces()
	if hound.target.is_empty():
		return
	var tp := HoundTargeting.position_of(hound.target)
	if tp == Vector3.INF:
		return
	var a := hound.global_position + Vector3(0, ProdConfig.DECAL_TELEGRAPH_RING_Y + 0.02, 0)
	var b := Vector3(tp.x, a.y, tp.z)
	_line_mesh.surface_begin(Mesh.PRIMITIVE_LINES)
	var n := 12
	for k in n:
		if k % 2 == 1:
			continue
		_line_mesh.surface_add_vertex(a.lerp(b, float(k) / n))
		_line_mesh.surface_add_vertex(a.lerp(b, float(k + 1) / n))
	_line_mesh.surface_end()

# ------------------------------------------------------------- primitives ----

func _mat(c: Color, rough: float) -> StandardMaterial3D:
	var m := StandardMaterial3D.new()
	m.albedo_color = c
	m.roughness = rough
	return m

func _prim(parent: Node3D, mesh: Mesh, mat: Material, pos: Vector3, rot_deg: Vector3, nm: String) -> MeshInstance3D:
	var mi := MeshInstance3D.new()
	mi.name = nm
	mi.mesh = mesh
	mi.material_override = mat
	mi.position = pos
	mi.rotation_degrees = rot_deg
	parent.add_child(mi)
	primitive_count += 1
	return mi

func _capsule(r: float, h: float) -> CapsuleMesh:
	var c := CapsuleMesh.new()
	c.radius = r
	c.height = h
	return c

func _box(s: Vector3) -> BoxMesh:
	var b := BoxMesh.new()
	b.size = s
	return b

func _cylinder(top: float, bottom: float, h: float) -> CylinderMesh:
	var c := CylinderMesh.new()
	c.top_radius = top
	c.bottom_radius = bottom
	c.height = h
	return c

func _torus(inner: float, outer: float) -> TorusMesh:
	var t := TorusMesh.new()
	t.inner_radius = inner
	t.outer_radius = outer
	return t
