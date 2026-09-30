class_name CloseupInset
extends CanvasLayer

## THE DIAGNOSTIC CLOSE-UP — a separate camera, NOT the gameplay camera (R-07).
##
## At the accepted gameplay framing the Huntress is roughly a hundred pixels
## tall, which is exactly the size readability must be judged at -- and too small
## to inspect a hand, a nock or a string for defects. This inset renders the same
## world through a SECOND camera, from the bow side, so both can be seen at once.
## It STARTS HIDDEN (V toggles it) and never replaces or moves the accepted
## isometric camera.

const SIZE := Vector2i(560, 560)

var target: Node3D                      ## the probe's visual root
var cam: Camera3D
var _vp: SubViewport
var _frame: PanelContainer
## From the string-hand side, in front: the face, the anchor, the string and
## the arrow line are all visible from here.
var yaw_offset_deg: float = -58.0
var distance_m: float = 2.6
var height_m: float = 1.25
var look_height_m: float = 1.15

func build(world: World3D) -> void:
	layer = 19
	_frame = PanelContainer.new()
	_frame.name = "CloseupFrame"
	_frame.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(0.02, 0.03, 0.05, 0.9)
	sb.border_color = Color(0.45, 0.50, 0.62, 0.9)
	sb.set_border_width_all(1)
	sb.set_content_margin_all(4)
	_frame.add_theme_stylebox_override("panel", sb)
	add_child(_frame)
	var vb := VBoxContainer.new()
	vb.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_frame.add_child(vb)
	var title := Label.new()
	title.text = "DIAGNOSTIC CLOSE-UP — a second camera, NOT the gameplay camera"
	title.add_theme_font_size_override("font_size", 13)
	title.add_theme_color_override("font_color", Color(0.78, 0.82, 0.92))
	vb.add_child(title)
	var svc := SubViewportContainer.new()
	svc.custom_minimum_size = Vector2(SIZE)
	svc.stretch = true
	svc.mouse_filter = Control.MOUSE_FILTER_IGNORE
	vb.add_child(svc)
	_vp = SubViewport.new()
	_vp.size = SIZE
	_vp.world_3d = world
	_vp.msaa_3d = Viewport.MSAA_4X
	_vp.render_target_update_mode = SubViewport.UPDATE_WHEN_VISIBLE
	svc.add_child(_vp)
	cam = Camera3D.new()
	cam.name = "CloseupCamera"
	cam.fov = 34.0
	cam.near = 0.05
	cam.far = 60.0
	cam.cull_mask = 1
	_vp.add_child(cam)
	visible = false

func _process(_delta: float) -> void:
	_frame.position = Vector2(18, _frame.get_viewport_rect().size.y - _frame.get_combined_minimum_size().y - 18)
	if target == null or cam == null:
		return
	var f := target.global_transform.basis.z
	f.y = 0.0
	f = f.normalized() if f.length() > 0.001 else Vector3.FORWARD
	var dir := f.rotated(Vector3.UP, deg_to_rad(yaw_offset_deg))
	var focus := target.global_position + Vector3(0, look_height_m, 0)
	cam.global_position = target.global_position + dir * distance_m + Vector3(0, height_m, 0)
	cam.look_at(focus, Vector3.UP)

func set_enabled(v: bool) -> void:
	visible = v

func toggle() -> void:
	visible = not visible
