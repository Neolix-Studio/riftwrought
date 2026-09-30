class_name GroundShadow
extends MeshInstance3D

## A soft contact shadow that sits AT THE ACTOR'S GROUND POINT.
##
## ============================================================================
## THIS IS CANONICAL, NOT DECORATION.
## ============================================================================
## `CLAUDE.md` section 5, in the clause list that is explicitly medium-independent:
## "Y-sorting, collision, navigation, targeting, reach, drop placement and
##  distance all read it. Nothing reads the sprite's position.
##  THE SHADOW STAYS AT THE GROUND POINT."
##
## So this node is a child of the ACTOR, never of the visual. Displace the
## visual and the shadow does not move -- which is the rule, made visible.
##
## ---------------------------------------------------------------------------
## WHY IT EXISTS AT ALL, recorded because only a rendered frame showed it
## ---------------------------------------------------------------------------
## The first evidence captures had no contact cue of any kind, and in a FIXED
## ISOMETRIC view that is not a small thing: "standing here" and "standing
## further away" project to the same place on screen. Barrels and crates read as
## FLOATING. They were not -- every prop's mesh was MEASURED afterwards and every
## one sits within 13 mm of the floor plane. The geometry was right and the
## picture was wrong, which is exactly why this project's rules say to render the
## evidence and look at it.
##
## Every value here is PROVISIONAL.

const RADIUS_SCALE := 2.4          ## PROVISIONAL: shadow width per body radius
const ALPHA := 0.75                ## PROVISIONAL
## MEASURED, not guessed: clear of the floor's VISUAL surface at +0.033 m.
const HEIGHT := ProdConfig.DECAL_SHADOW_Y

static func attach_to(actor: Node3D, body_radius: float) -> GroundShadow:
	var s := GroundShadow.new()
	s.name = "GroundShadow"
	var q := QuadMesh.new()
	q.size = Vector2(body_radius * RADIUS_SCALE, body_radius * RADIUS_SCALE)
	s.mesh = q
	var m := StandardMaterial3D.new()
	m.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	m.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	m.albedo_color = Color(1, 1, 1, ALPHA)
	# A RADIAL FALLOFF, not a flat fill.
	#
	# The first attempt was a flat colour on a quad in BLEND_MODE_MUL. It
	# rendered as a HARD BLACK SQUARE under every actor -- unmistakably worse
	# than having no shadow at all, and visible only in the rendered frame: no
	# check in the suite is, or should be, about whether a blob looks like a
	# blob. A gradient texture makes it round and makes it fade.
	m.albedo_texture = _radial_texture()
	m.billboard_mode = BaseMaterial3D.BILLBOARD_DISABLED
	m.cull_mode = BaseMaterial3D.CULL_DISABLED
	s.material_override = m
	s.rotation_degrees = Vector3(-90, 0, 0)
	s.position = Vector3(0, HEIGHT, 0)
	# CHILD OF THE ACTOR, NOT OF THE VISUAL. That is the whole point.
	actor.add_child(s)
	return s

static func _radial_texture() -> GradientTexture2D:
	var g := Gradient.new()
	g.set_offset(0, 0.0)
	g.set_color(0, Color(0.05, 0.055, 0.085, 1.0))
	g.set_offset(1, 1.0)
	g.set_color(1, Color(0.05, 0.055, 0.085, 0.0))
	g.add_point(0.55, Color(0.05, 0.055, 0.085, 0.72))
	var t := GradientTexture2D.new()
	t.gradient = g
	t.fill = GradientTexture2D.FILL_RADIAL
	t.fill_from = Vector2(0.5, 0.5)
	t.fill_to = Vector2(1.0, 0.5)
	t.width = 96
	t.height = 96
	return t
