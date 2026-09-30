class_name CalibrationFixtures
extends Node3D
## First-MVP Gate 1A — every inert calibration fixture in the Scale Calibration
## Hall: enemy-spacing silhouettes, the role-space placeholders, the ranged
## reading gallery, and the telegraph and hazard footprints.
##
## EVERYTHING HERE IS MECHANICALLY INERT, and that is structural rather than
## promised: nothing under this node carries a `CollisionObject3D` of any kind,
## so no fixture can be hit, hit anything, block movement, enter the navigation
## bake, or change a locomotion result. There is no AI, no attack, no Life, no
## targeting, no damage, no ailment, and no projectile system. The Gate 1A suite
## walks this subtree and asserts the absence rather than trusting the comment.
##
## D-195's fixture rule, in full: "Graveblade, Mauler, Marrowshot, projectile,
## telegraph, and Cinder Seal representations are mechanically inert calibration
## fixtures. This authorization does not include their production AI, attacks,
## Life, Damage, targeting, ailments, VFX, or generalized systems."
##
## Specification §6.1 also requires that "every placeholder must visibly state
## that its size or action footprint is not a locked gameplay value", which is
## why each group carries a `Label3D` saying exactly that on screen.

const GRAVEBLADE_RIG: String = "res://scenes/actors/graveblade_rig.tscn"

## Marker-preset names, in the order the telegraph/hazard cycle visits them. The
## first is always the candidate size from the calibration record.
const PRESET_NAMES: Array[String] = ["candidate", "smaller", "larger"]

@export var data: ScaleCalibrationData

var geometry: ScaleCalibrationGeometry

var role_fixtures_visible: bool = true
## 0..n-1 select a marker preset; n means the telegraph and hazard court is
## hidden entirely.
var marker_state: int = 0

var _role_group: Node3D
var _gallery_group: Node3D
var _marker_group: Node3D
var _probe: Node3D
var _probe_distance: float = 0.0

var _origin_node: Node3D
var _mark_nodes: Array[Node3D] = []
var _role_records: Array[Dictionary] = []
var _mauler_arc: MeshInstance3D
var _cinder_seal: MeshInstance3D
var _marker_label: Label3D


func configure(hall_geometry: ScaleCalibrationGeometry, record: ScaleCalibrationData) -> void:
	geometry = hall_geometry
	data = record


func build() -> void:
	assert(geometry != null and data != null, "CalibrationFixtures.build() before configure()")
	for child: Node in get_children():
		child.free()
	_mark_nodes.clear()
	_role_records.clear()

	_role_group = Node3D.new()
	_role_group.name = "RoleFixtures"
	add_child(_role_group)

	_gallery_group = Node3D.new()
	_gallery_group.name = "RangedGallery"
	add_child(_gallery_group)

	_marker_group = Node3D.new()
	_marker_group.name = "TelegraphAndHazard"
	add_child(_marker_group)

	_build_reference_silhouette()
	_build_surround_group()
	_build_mauler_placeholder()
	_build_ranged_gallery()
	_build_telegraph_court()
	_apply_marker_state()


# --- §6.1 enemy spacing --------------------------------------------------------

func _build_reference_silhouette() -> void:
	var at: Vector2 = ScaleCalibrationGeometry.REFERENCE_SILHOUETTE_AT
	_add_graveblade_silhouette("ReferenceGraveblade", at, 0.0)
	_add_ground_ring(
		_role_group, "ReferenceGravebladeRing", Vector3(at.x, 0.0, at.y),
		data.graveblade_body_diameter_metres * 0.5, Color(0.86, 0.47, 0.47)
	)
	_add_label(
		_role_group, Vector3(at.x, 2.55, at.y),
		"Graveblade silhouette · %.2f m across · INERT\nno AI, attack, Life, damage, or targeting" % [
			data.graveblade_body_diameter_metres,
		], Color(0.92, 0.72, 0.66)
	)
	_role_records.append({
		"name": "Graveblade reference silhouette",
		"diameter": data.graveblade_body_diameter_metres,
		"height": data.graveblade_body_height_metres,
		"at": Vector3(at.x, 0.0, at.y),
		"provisional": false,
	})


## Specification §6.1: "Additional Graveblade-sized positions must demonstrate
## whether several enemies can surround the player without visually filling the
## room." Six bodies on a contact-distance ring around a marked player stand.
func _build_surround_group() -> void:
	var centre: Vector2 = ScaleCalibrationGeometry.SURROUND_CENTRE
	var radius: float = data.surround_ring_radius_metres
	var count: int = maxi(data.surround_ring_count, 1)
	for i: int in count:
		var angle: float = TAU * float(i) / float(count)
		var at: Vector2 = centre + Vector2(sin(angle), cos(angle)) * radius
		# Facing the stand, on the measured +Z rig convention.
		_add_graveblade_silhouette("SurroundGraveblade_%d" % i, at, angle + PI)
		_add_ground_ring(
			_role_group, "SurroundRing_%d" % i, Vector3(at.x, 0.0, at.y),
			data.graveblade_body_diameter_metres * 0.5, Color(0.86, 0.47, 0.47)
		)
	_add_ground_ring(
		_role_group, "PlayerStandRing", Vector3(centre.x, 0.0, centre.y),
		data.player_unit_metres * 0.5, Color(0.85, 0.62, 0.36)
	)
	_add_label(
		_role_group, Vector3(centre.x, 3.45, centre.y),
		"%d Graveblade silhouettes · %.2f m surround ring · INERT\nring radius is a TEST INPUT, not a locked gameplay value" % [
			count, radius,
		], Color(0.92, 0.72, 0.66)
	)
	_role_records.append({
		"name": "surround group",
		"diameter": data.graveblade_body_diameter_metres,
		"height": data.graveblade_body_height_metres,
		"at": Vector3(centre.x, 0.0, centre.y),
		"count": count,
		"ring_radius": radius,
		"provisional": true,
	})


func _add_graveblade_silhouette(node_name: String, at: Vector2, yaw: float) -> void:
	var rig: Node3D = (load(GRAVEBLADE_RIG) as PackedScene).instantiate() as Node3D
	rig.name = node_name
	rig.position = Vector3(at.x, 0.0, at.y)
	rig.rotation = Vector3(0.0, yaw, 0.0)
	_role_group.add_child(rig)


## Specification §6.1: "A simple debug volume may stand in for a larger Mauler
## body until that enemy's registered visual choice exists." Marrowshot is the
## same kind of placeholder and stands at the gallery's firing origin.
func _build_mauler_placeholder() -> void:
	var mauler_at: Vector2 = ScaleCalibrationGeometry.MAULER_ARC_AT
	_add_debug_volume(
		"MaulerRoleVolume", mauler_at,
		data.mauler_body_diameter_metres, data.mauler_body_height_metres,
		Color(0.55, 0.42, 0.30)
	)
	_add_label(
		_role_group, Vector3(mauler_at.x, data.mauler_body_height_metres + 0.95, mauler_at.y),
		"Mauler role-space · %.2f x %.2f m · PROVISIONAL\nno visual, AI, attack, or Life; size is\nNOT a locked gameplay value" % [
			data.mauler_body_diameter_metres, data.mauler_body_height_metres,
		], Color(0.90, 0.78, 0.60)
	)
	_role_records.append({
		"name": "Mauler role-space placeholder",
		"diameter": data.mauler_body_diameter_metres,
		"height": data.mauler_body_height_metres,
		"at": Vector3(mauler_at.x, 0.0, mauler_at.y),
		"provisional": true,
	})

	var marrowshot_at: Vector2 = Vector2(
		ScaleCalibrationGeometry.RANGED_ORIGIN_X, ScaleCalibrationGeometry.RANGED_AXIS_Z
	)
	_add_debug_volume(
		"MarrowshotRoleVolume", marrowshot_at,
		data.marrowshot_body_diameter_metres, data.marrowshot_body_height_metres,
		Color(0.42, 0.50, 0.60)
	)
	_add_label(
		_role_group,
		Vector3(marrowshot_at.x, data.marrowshot_body_height_metres + 0.95, marrowshot_at.y),
		"Marrowshot role-space · PROVISIONAL\nno AI, attack, projectile, or Life; size is\nNOT a locked gameplay value",
		Color(0.78, 0.85, 0.92)
	)
	_role_records.append({
		"name": "Marrowshot role-space placeholder",
		"diameter": data.marrowshot_body_diameter_metres,
		"height": data.marrowshot_body_height_metres,
		"at": Vector3(marrowshot_at.x, 0.0, marrowshot_at.y),
		"provisional": true,
	})


func _add_debug_volume(
	node_name: String, at: Vector2, diameter: float, height: float, colour: Color
) -> void:
	var volume: MeshInstance3D = MeshInstance3D.new()
	volume.name = node_name
	var mesh: CylinderMesh = CylinderMesh.new()
	mesh.top_radius = diameter * 0.5
	mesh.bottom_radius = diameter * 0.5
	mesh.height = height
	mesh.radial_segments = 12
	volume.mesh = mesh
	var material: StandardMaterial3D = StandardMaterial3D.new()
	material.albedo_color = Color(colour.r, colour.g, colour.b, 0.60)
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	material.roughness = 1.0
	material.specular_mode = BaseMaterial3D.SPECULAR_DISABLED
	volume.material_override = material
	volume.position = Vector3(at.x, height * 0.5, at.y)
	volume.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	_role_group.add_child(volume)
	_add_ground_ring(
		_role_group, "%sRing" % node_name, Vector3(at.x, 0.0, at.y), diameter * 0.5, colour
	)


# --- §6.2 ranged reading gallery ------------------------------------------------

func _build_ranged_gallery() -> void:
	var axis_z: float = ScaleCalibrationGeometry.RANGED_AXIS_Z
	var origin_x: float = ScaleCalibrationGeometry.RANGED_ORIGIN_X

	_origin_node = Node3D.new()
	_origin_node.name = "FiringOrigin"
	_origin_node.position = Vector3(origin_x, 0.0, axis_z)
	_gallery_group.add_child(_origin_node)
	_add_ground_ring(
		_gallery_group, "FiringOriginRing", _origin_node.position, 0.55, Color(0.85, 0.62, 0.36)
	)
	# Offset from the origin rather than over it: the Marrowshot role-space volume
	# stands exactly there and carries its own label, and the first evidence run
	# had the two printed through each other.
	_add_label(
		_gallery_group, Vector3(origin_x + 4.0, 3.55, axis_z - 2.8),
		"Ranged reading gallery · firing origin\ninert probe: no collision, damage, or targeting",
		Color(0.88, 0.84, 0.72)
	)

	var furthest: float = 0.0
	for distance: float in data.ranged_mark_metres:
		furthest = maxf(furthest, distance)

	var axis: MeshInstance3D = MeshInstance3D.new()
	axis.name = "RangedAxis"
	var axis_mesh: BoxMesh = BoxMesh.new()
	axis_mesh.size = Vector3(furthest, 0.03, 0.10)
	axis.mesh = axis_mesh
	axis.material_override = _flat_material(Color(0.85, 0.62, 0.36), 0.30)
	axis.position = Vector3(origin_x + furthest * 0.5, 0.015, axis_z)
	axis.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	_gallery_group.add_child(axis)

	for distance: float in data.ranged_mark_metres:
		var mark: Node3D = Node3D.new()
		mark.name = "RangedMark_%d" % int(round(distance))
		mark.position = Vector3(origin_x + distance, 0.0, axis_z)
		_gallery_group.add_child(mark)
		_mark_nodes.append(mark)

		var bar: MeshInstance3D = MeshInstance3D.new()
		bar.name = "Bar"
		var bar_mesh: BoxMesh = BoxMesh.new()
		bar_mesh.size = Vector3(0.16, 0.05, 2.40)
		bar.mesh = bar_mesh
		bar.material_override = _flat_material(Color(0.85, 0.62, 0.36), 0.90)
		bar.position = Vector3(0.0, 0.025, 0.0)
		bar.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
		mark.add_child(bar)

		var post: MeshInstance3D = MeshInstance3D.new()
		post.name = "Post"
		var post_mesh: BoxMesh = BoxMesh.new()
		post_mesh.size = Vector3(0.16, 1.60, 0.16)
		post.mesh = post_mesh
		post.material_override = _flat_material(Color(0.85, 0.62, 0.36), 0.90)
		post.position = Vector3(0.0, 0.80, 1.20)
		post.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
		mark.add_child(post)

		var label: Label3D = _add_label(
			mark, Vector3(0.0, 2.05, 1.20), "%.0f m" % distance, Color(0.95, 0.80, 0.55)
		)
		label.font_size = 46

	_probe = MeshInstance3D.new()
	_probe.name = "InertReadingProbe"
	var probe_mesh: SphereMesh = SphereMesh.new()
	probe_mesh.radius = 0.16
	probe_mesh.height = 0.32
	(_probe as MeshInstance3D).mesh = probe_mesh
	(_probe as MeshInstance3D).material_override = _flat_material(Color(0.95, 0.84, 0.60), 0.95)
	(_probe as MeshInstance3D).cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	_probe.position = Vector3(origin_x, data.probe_height_metres, axis_z)
	_gallery_group.add_child(_probe)


func _process(delta: float) -> void:
	if _probe == null or data == null:
		return
	var furthest: float = 0.0
	for distance: float in data.ranged_mark_metres:
		furthest = maxf(furthest, distance)
	_probe_distance += data.probe_speed_metres_per_second * delta
	if _probe_distance > furthest:
		_probe_distance = 0.0
	_probe.position = Vector3(
		ScaleCalibrationGeometry.RANGED_ORIGIN_X + _probe_distance,
		data.probe_height_metres,
		ScaleCalibrationGeometry.RANGED_AXIS_Z
	)


# --- §6.3 telegraph and hazard court ---------------------------------------------

func _build_telegraph_court() -> void:
	var arc_at: Vector2 = ScaleCalibrationGeometry.MAULER_ARC_AT
	var seal_at: Vector2 = ScaleCalibrationGeometry.CINDER_SEAL_AT

	_mauler_arc = MeshInstance3D.new()
	_mauler_arc.name = "MaulerCommitmentFootprint"
	_mauler_arc.position = Vector3(arc_at.x, 0.035, arc_at.y)
	_marker_group.add_child(_mauler_arc)

	_cinder_seal = MeshInstance3D.new()
	_cinder_seal.name = "CinderSealFootprint"
	_cinder_seal.position = Vector3(seal_at.x, 0.035, seal_at.y)
	_marker_group.add_child(_cinder_seal)

	# Placed at the court's south-west corner rather than over its middle: the
	# first evidence run had this label, the Mauler's, and the Seal's overlapping
	# into one unreadable block across the frame.
	_marker_label = _add_label(
		_marker_group, Vector3((arc_at.x + seal_at.x) * 0.5, 1.90, arc_at.y - 4.80),
		"", Color(0.95, 0.78, 0.62)
	)
	# Smaller than the other fixture labels on purpose: it is a four-line
	# information block sitting between two footprints, and at the shared size it
	# printed straight across the middle of the occlusion frame.
	_marker_label.font_size = 26


## Rebuilds both footprints at the current preset scale. Floor-only: neither
## marker deals damage, applies an ailment, blocks navigation, or implements any
## enemy behaviour.
func _apply_marker_state() -> void:
	var hidden: bool = marker_state >= PRESET_NAMES.size()
	_marker_group.visible = not hidden
	if hidden:
		return
	var scale_factor: float = data.marker_preset_scales[
		mini(marker_state, data.marker_preset_scales.size() - 1)
	]
	var arc_radius: float = data.mauler_arc_radius_metres * scale_factor
	var seal_radius: float = data.cinder_seal_radius_metres * scale_factor

	var facing: float = ScaleCalibrationGeometry.MAULER_ARC_FACING_DEGREES
	_mauler_arc.mesh = _sector_mesh(
		arc_radius,
		facing - data.mauler_arc_degrees * 0.5,
		facing + data.mauler_arc_degrees * 0.5,
		Color(0.92, 0.55, 0.28)
	)
	_cinder_seal.mesh = _sector_mesh(seal_radius, 0.0, 360.0, Color(0.85, 0.36, 0.30))

	var escapes: Array[Dictionary] = escape_records()
	var escape_text: String = ""
	for escape: Dictionary in escapes:
		escape_text += "  %s %.2f m" % [escape["name"], float(escape["clear_metres"])]
	_marker_label.text = (
		"Telegraph and hazard court · %s preset (x%.2f)\n"
		+ "Mauler commitment %.2f m radius, %.0f deg  ·  Cinder Seal %.2f m radius\n"
		+ "TEST INPUTS, not decisions — no damage, ailment, or navigation block\n"
		+ "clear run from the Seal rim:%s"
	) % [
		PRESET_NAMES[marker_state], scale_factor,
		arc_radius, data.mauler_arc_degrees, seal_radius, escape_text,
	]


## The clear distance from the Cinder Seal's rim to the nearest solid geometry in
## each cardinal direction, measured against the built world. Specification §6.3
## requires "at least two visibly distinct ways out"; this is how that claim is
## checked rather than asserted.
func escape_records() -> Array[Dictionary]:
	var records: Array[Dictionary] = []
	if geometry == null:
		return records
	var seal_at: Vector2 = ScaleCalibrationGeometry.CINDER_SEAL_AT
	var radius: float = current_seal_radius()
	var span_z: Vector2 = geometry.free_span_z(seal_at.x, seal_at.y)
	var span_x: Vector2 = geometry.free_span_x(seal_at.y, seal_at.x)
	records.append({"name": "north", "clear_metres": (seal_at.y - radius) - span_z.x})
	records.append({"name": "south", "clear_metres": span_z.y - (seal_at.y + radius)})
	records.append({"name": "west", "clear_metres": (seal_at.x - radius) - span_x.x})
	records.append({"name": "east", "clear_metres": span_x.y - (seal_at.x + radius)})
	return records


func current_marker_scale() -> float:
	if marker_state >= PRESET_NAMES.size():
		return data.marker_preset_scales[0]
	return data.marker_preset_scales[mini(marker_state, data.marker_preset_scales.size() - 1)]


func current_arc_radius() -> float:
	return data.mauler_arc_radius_metres * current_marker_scale()


func current_seal_radius() -> float:
	return data.cinder_seal_radius_metres * current_marker_scale()


func marker_state_name() -> String:
	if marker_state >= PRESET_NAMES.size():
		return "hidden"
	return PRESET_NAMES[marker_state]


# --- Runtime toggles --------------------------------------------------------------

func set_role_fixtures_visible(value: bool) -> void:
	role_fixtures_visible = value
	_role_group.visible = value


## F4 walks the court through its presets and then hides it, so the owner can
## compare a smaller and a larger footprint against the candidate without
## editing anything and without a dense debug-control scheme.
func cycle_markers() -> String:
	marker_state = (marker_state + 1) % (PRESET_NAMES.size() + 1)
	_apply_marker_state()
	return marker_state_name()


func reset_to_baseline() -> void:
	marker_state = 0
	_apply_marker_state()
	set_role_fixtures_visible(true)


# --- Measurement -------------------------------------------------------------------

## The §6.2 marks, each measured as the actual distance between the firing-origin
## node and the mark node rather than repeated from the record that placed them.
func ranged_records() -> Array[Dictionary]:
	var records: Array[Dictionary] = []
	for index: int in _mark_nodes.size():
		var target: float = data.ranged_mark_metres[index]
		records.append({
			"target_metres": target,
			"measured_metres": _origin_node.global_position.distance_to(
				_mark_nodes[index].global_position
			),
			"at": _mark_nodes[index].global_position,
		})
	return records


func role_records() -> Array[Dictionary]:
	return _role_records


func firing_origin() -> Vector3:
	return _origin_node.global_position if _origin_node != null else Vector3.ZERO


# --- Small builders ------------------------------------------------------------------

func _add_ground_ring(
	parent: Node3D, node_name: String, at: Vector3, radius: float, colour: Color
) -> void:
	var ring: MeshInstance3D = MeshInstance3D.new()
	ring.name = node_name
	var torus: TorusMesh = TorusMesh.new()
	torus.inner_radius = maxf(radius - 0.06, 0.02)
	torus.outer_radius = radius
	torus.rings = 20
	ring.mesh = torus
	ring.material_override = _flat_material(colour, 0.85)
	ring.position = Vector3(at.x, 0.03, at.z)
	ring.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	parent.add_child(ring)


func _add_label(parent: Node3D, at: Vector3, text: String, colour: Color) -> Label3D:
	var label: Label3D = Label3D.new()
	label.text = text
	label.position = at
	label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	label.double_sided = true
	# MEASURED, from the first rendered evidence run: at pixel_size 0.010 and a
	# 44 px font these labels rendered about 0.44 m tall in world space, which is
	# more than half the character's own width and made three of them overlap into
	# an unreadable wall of text across the middle of the frame. 0.009 x 34 is
	# about 0.31 m — legible at the 19 m camera without competing with the space
	# the owner is here to judge. Depth testing is ON for the same reason: a label
	# behind a wall should be behind the wall.
	label.no_depth_test = false
	label.fixed_size = false
	label.pixel_size = 0.009
	label.font_size = 34
	label.outline_size = 8
	label.modulate = colour
	label.outline_modulate = Color(0.05, 0.06, 0.08, 0.90)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.render_priority = 4
	label.outline_render_priority = 3
	parent.add_child(label)
	return label


## A flat filled sector on the floor, with a brighter rim, built from an
## ImmediateMesh. Floor-only geometry: no collision shape is created anywhere.
func _sector_mesh(radius: float, from_degrees: float, to_degrees: float, colour: Color) -> Mesh:
	var mesh: ImmediateMesh = ImmediateMesh.new()
	var fill: StandardMaterial3D = _flat_material(colour, 0.28)
	var rim: StandardMaterial3D = _flat_material(colour, 0.95)
	var steps: int = maxi(int((to_degrees - from_degrees) / 4.0), 6)

	mesh.surface_begin(Mesh.PRIMITIVE_TRIANGLES, fill)
	for step: int in steps:
		var a: float = deg_to_rad(lerpf(from_degrees, to_degrees, float(step) / float(steps)))
		var b: float = deg_to_rad(lerpf(from_degrees, to_degrees, float(step + 1) / float(steps)))
		mesh.surface_add_vertex(Vector3.ZERO)
		mesh.surface_add_vertex(Vector3(cos(a) * radius, 0.0, sin(a) * radius))
		mesh.surface_add_vertex(Vector3(cos(b) * radius, 0.0, sin(b) * radius))
	mesh.surface_end()

	mesh.surface_begin(Mesh.PRIMITIVE_TRIANGLES, rim)
	var inner: float = maxf(radius - 0.14, 0.02)
	for step: int in steps:
		var a: float = deg_to_rad(lerpf(from_degrees, to_degrees, float(step) / float(steps)))
		var b: float = deg_to_rad(lerpf(from_degrees, to_degrees, float(step + 1) / float(steps)))
		var outer_a: Vector3 = Vector3(cos(a) * radius, 0.01, sin(a) * radius)
		var outer_b: Vector3 = Vector3(cos(b) * radius, 0.01, sin(b) * radius)
		var inner_a: Vector3 = Vector3(cos(a) * inner, 0.01, sin(a) * inner)
		var inner_b: Vector3 = Vector3(cos(b) * inner, 0.01, sin(b) * inner)
		mesh.surface_add_vertex(inner_a)
		mesh.surface_add_vertex(outer_a)
		mesh.surface_add_vertex(outer_b)
		mesh.surface_add_vertex(inner_a)
		mesh.surface_add_vertex(outer_b)
		mesh.surface_add_vertex(inner_b)
	mesh.surface_end()
	return mesh


func _flat_material(colour: Color, alpha: float) -> StandardMaterial3D:
	var material: StandardMaterial3D = StandardMaterial3D.new()
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	material.cull_mode = BaseMaterial3D.CULL_DISABLED
	material.albedo_color = Color(colour.r, colour.g, colour.b, alpha)
	return material
