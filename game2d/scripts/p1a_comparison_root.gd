extends Node

## P1A — the comparison tool the owner opens.
##
## It shows the owner's own exported Mage and Huntress idle frames at an integral
## sprite scale, switches all eight facings, runs a deterministic five-second diagonal
## camera pan, and switches between the rendering approaches — it opens on the CANONICAL
## mode 7 and the rest are diagnostic comparators — the two
## candidate pixel densities, the candidate base resolutions and the five window
## resolutions the brief names.
##
## **It decides nothing.** Every number on screen is a measurement or an arithmetic
## consequence of one, and every line that could be mistaken for a decision says so.

const BASE_CANDIDATES: Array[Vector2i] = [
	Vector2i(960, 540), Vector2i(1280, 720), Vector2i(1600, 900),
	Vector2i(1920, 1080), Vector2i(2560, 1440),
]

## The window sizes the brief names. Index 0 is discovered from the owner's actual
## display at start-up and is never assumed.
const NAMED_WINDOWS: Array[Vector2i] = [
	Vector2i(0, 0),  # replaced at start-up by the discovered display size
	Vector2i(1280, 720), Vector2i(1920, 1080), Vector2i(2560, 1440), Vector2i(3840, 2160),
]

const WINDOW_LABELS: PackedStringArray = [
	"owner display (discovered)", "1280x720", "1920x1080", "2560x1440", "3840x2160",
]

## The tool opens on the CANONICAL DEFAULT PRESENTATION (D-356 ruling 1): mode 7,
## display-pinned fractional fill. The other approaches stay selectable as diagnostic
## comparators; selecting one does not change what is canonical.
var approach: int = P1ARenderMode.CANONICAL_APPROACH
var character: String = "mage"
var direction_index: int = 2  ## "s"
var density_index: int = 0
## The canonical gameplay base viewport is OWNER-LOCKED at 1920 x 1080 (D-354). The
## other candidates stay selectable so the locked choice can still be compared against
## what it replaced.
var base_index: int = 3
var window_index: int = 0
var sprite_scale: int = 1
var show_hud: bool = true
var show_markers: bool = true

## The three shared-anchor candidates. **Every one is a SINGLE constant applied to every
## frame** — P1A creates no per-direction runtime offset, and the supplemental pass
## repeats that refusal.
##   0 `rule_below_ground`      the cell's horizontal centre, the row BELOW the ground row
##   1 `provisional_on_ground`  the cell's horizontal centre, the ground row itself.
##                              For a 128 cell that is exactly the (64, 122) the owner
##                              asked to be tested.
##   2 `measured_feet`          where the drawn feet actually are, on the ground row
const ANCHOR_MODE_NAMES: PackedStringArray = [
	"rule: cell centre, row below the modal ground row",
	"LOCKED (owner): (64, 122)",
	"measured: the mean drawn feet centre, on the modal ground row",
]

## The anchor the owner locked for P1A. The tool starts here.
const LOCKED_HUNTRESS_ANCHOR: Vector2i = Vector2i(64, 122)
var anchor_mode: int = 1

var pan_frame: int = -1  ## -1 = not panning
## True when the selected density cannot be shown for the selected character at an
## integral sprite scale. Reported on screen, never silently corrected.
var density_mismatch: bool = false

var _world: P1AWorld
var _actor: P1AActor
var _camera: Camera2D
var _sub_viewport: SubViewport
var _display: TextureRect
var _hud_layer: CanvasLayer
var _hud: Label
var _direct_root: Node2D
var _measurements: Dictionary = {}
var _frames_cache: Dictionary = {}
var _windows: Array[Vector2i] = []
var _display_facts: Dictionary = {}
var _ground_mid_warned: Dictionary = {}
var _ground_row_warned: Dictionary = {}


func _ready() -> void:
	_discover_display()
	_build_tree()
	_reload_character()
	_apply_density()
	_apply_approach()
	_apply_window()


# --- discovery ----------------------------------------------------------------------

func _discover_display() -> void:
	var screen: int = DisplayServer.window_get_current_screen()
	var size: Vector2i = DisplayServer.screen_get_size(screen)
	_display_facts = {
		"screen_count": DisplayServer.get_screen_count(),
		"current_screen": screen,
		"screen_size": [size.x, size.y],
		"screen_scale": DisplayServer.screen_get_scale(screen),
		"screen_dpi": DisplayServer.screen_get_dpi(screen),
		"screen_refresh_rate": DisplayServer.screen_get_refresh_rate(screen),
		"screen_usable_rect": str(DisplayServer.screen_get_usable_rect(screen)),
		"window_size_at_start": str(DisplayServer.window_get_size()),
		"screen_sizes": [],
	}
	var all_sizes: Array = []
	for i: int in range(DisplayServer.get_screen_count()):
		all_sizes.append({
			"index": i,
			"size": str(DisplayServer.screen_get_size(i)),
			"scale": DisplayServer.screen_get_scale(i),
			"dpi": DisplayServer.screen_get_dpi(i),
			"refresh_rate": DisplayServer.screen_get_refresh_rate(i),
		})
	_display_facts["screen_sizes"] = all_sizes
	_windows = NAMED_WINDOWS.duplicate()
	# Discovered, not assumed: the usable rect of the screen the window opened on.
	var usable: Rect2i = DisplayServer.screen_get_usable_rect(screen)
	_windows[0] = usable.size


func display_facts() -> Dictionary:
	return _display_facts


# --- tree ---------------------------------------------------------------------------

func _build_tree() -> void:
	_direct_root = Node2D.new()
	_direct_root.name = "DirectRoot"
	_direct_root.y_sort_enabled = true
	add_child(_direct_root)

	_sub_viewport = SubViewport.new()
	_sub_viewport.name = "BaseViewport"
	_sub_viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	_sub_viewport.transparent_bg = false
	_sub_viewport.canvas_item_default_texture_filter = Viewport.DEFAULT_CANVAS_ITEM_TEXTURE_FILTER_NEAREST
	_sub_viewport.snap_2d_transforms_to_pixel = true
	_sub_viewport.snap_2d_vertices_to_pixel = true
	add_child(_sub_viewport)

	var display_layer: CanvasLayer = CanvasLayer.new()
	display_layer.name = "DisplayLayer"
	display_layer.layer = 1
	add_child(display_layer)
	_display = TextureRect.new()
	_display.name = "BaseViewportDisplay"
	_display.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	_display.stretch_mode = TextureRect.STRETCH_KEEP
	_display.texture = _sub_viewport.get_texture()
	_display.visible = false
	display_layer.add_child(_display)

	_world = P1AWorld.new()
	_world.name = "DiagnosticWorld"
	_actor = P1AActor.new()
	_actor.name = "Actor"
	_camera = Camera2D.new()
	_camera.name = "Camera"
	_camera.position_smoothing_enabled = false
	_camera.ignore_rotation = true

	_direct_root.add_child(_world)
	_direct_root.add_child(_actor)
	_direct_root.add_child(_camera)

	_hud_layer = CanvasLayer.new()
	_hud_layer.name = "HUD"
	_hud_layer.layer = 10
	add_child(_hud_layer)
	_hud = Label.new()
	_hud.name = "Readout"
	_hud.position = Vector2(6, 4)
	_hud.add_theme_font_size_override("font_size", 11)
	_hud.add_theme_color_override("font_color", Color(0.94, 0.95, 1.0))
	_hud.add_theme_color_override("font_outline_color", Color(0, 0, 0))
	_hud.add_theme_constant_override("outline_size", 4)
	_hud_layer.add_child(_hud)


func _reload_character() -> void:
	if not _measurements.has(character):
		_measurements[character] = P1AArt.measure_character(character)
	if not _frames_cache.has(character):
		_frames_cache[character] = P1AArt.build_sprite_frames(character)
	var cell: int = P1AArt.cell_size(character)
	var ground_row: int = _shared_ground_row(character)
	# ONE shared anchor, whichever mode is selected. Never a per-frame value.
	var anchor: Vector2i = Vector2i(cell / 2, ground_row + 1)
	if anchor_mode == 1:
		anchor = LOCKED_HUNTRESS_ANCHOR if character == "huntress" else Vector2i(cell / 2, ground_row)
	elif anchor_mode == 2:
		anchor = Vector2i(int(round(_shared_ground_mid(character))), ground_row)
	_actor.apply(character, anchor, _frames_cache[character] as SpriteFrames)
	_actor.set_direction(P1AArt.DIRECTION_TOKENS[direction_index])
	_actor.set_sprite_scale(sprite_scale)
	_update_actor_measurement()


## The ground row shared by the character's frames — the MODAL one, so a minority of
## frames that end a pixel high cannot move it. Disagreement is reported once.
func _shared_ground_row(for_character: String) -> int:
	var counts: Dictionary = {}
	for m: Dictionary in (_measurements[for_character] as Array[Dictionary]):
		if not bool(m.get("empty", true)):
			var r: int = int(m["ground_row"])
			counts[r] = int(counts.get(r, 0)) + 1
	if counts.is_empty():
		return P1AArt.cell_size(for_character) - 1
	var best: int = -1
	var best_n: int = -1
	for r: Variant in counts.keys():
		if int(counts[r]) > best_n:
			best_n = int(counts[r]); best = int(r)
	if counts.size() > 1 and not _ground_row_warned.has(for_character):
		_ground_row_warned[for_character] = true
		push_warning("P1A: the ground row differs between frames of '%s' — %s" % [for_character, str(counts)])
	return best


## Where the drawn feet sit, shared across the character's frames. Disagreement is
## reported, never averaged into silence.
func _shared_ground_mid(for_character: String) -> float:
	var mids: Array[float] = []
	for m: Dictionary in (_measurements[for_character] as Array[Dictionary]):
		if not bool(m.get("empty", true)):
			mids.append(float(m["ground_mid"]))
	if mids.is_empty():
		return float(P1AArt.cell_size(for_character)) * 0.5
	# The MEAN over every frame, so this stays ONE shared constant rather than becoming a
	# per-direction offset, which P1A refuses to create. Disagreement is reported once:
	# it is a real finding for both characters.
	var total: float = 0.0
	var disagree: bool = false
	for v: float in mids:
		total += v
		if not is_equal_approx(v, mids[0]):
			disagree = true
	if disagree and not _ground_mid_warned.has(for_character):
		_ground_mid_warned[for_character] = true
		push_warning("P1A: the drawn feet centre differs between frames of '%s' — %s"
			% [for_character, str(mids)])
	return total / float(mids.size())


## The measurement of the frame currently on screen, found by DIRECTION rather than by
## position in a list, so a reordering cannot silently mislabel it.
func _update_actor_measurement() -> void:
	var token: String = P1AArt.DIRECTION_TOKENS[direction_index]
	for m: Dictionary in (_measurements[character] as Array[Dictionary]):
		if String(m.get("direction", "")) == token and int(m.get("index", -1)) == 0:
			if not bool(m.get("empty", true)):
				_actor.measured_stance_mid = float(m["ground_mid"])
				_actor.measured_body_px = int(m["body_h"])
			return


# --- configuration ------------------------------------------------------------------

func current_density() -> Dictionary:
	return P1AScale.candidates()[density_index]


func current_base() -> Vector2i:
	return BASE_CANDIDATES[base_index]


func _apply_density() -> void:
	var d: Dictionary = current_density()
	var px_per_m: float = float(d["px_per_m"])
	var tile: Dictionary = P1AScale.tile_proposal(px_per_m)
	_world.configure(px_per_m, Vector2(float(tile["tile_w"]), float(tile["tile_h"])))
	# The candidate density says what cell the PRODUCTION art is meant to be drawn at.
	# The Mage's exported cell is 64 and the Huntress's is 128, so displaying both at a
	# single density needs an integral scale on one of them. A1 permits an integral
	# scale and forbids a non-integral one; P1A uses that, reports it, and does NOT
	# treat it as a resolution of the density difference.
	var cell: int = P1AArt.cell_size(character)
	var target_cell: int = int(d["cell"])
	if target_cell >= cell:
		sprite_scale = maxi(1, target_cell / cell)
		density_mismatch = (target_cell % cell) != 0
	else:
		# Showing this character at this density would need a scale below 1, which A1
		# forbids. P1A refuses to fake it: the actor is drawn at 1:1 and the readout
		# says the frame on screen is TOO LARGE for the selected density.
		sprite_scale = 1
		density_mismatch = true
	_actor.set_sprite_scale(sprite_scale)
	queue_redraw_hud()


func _apply_approach() -> void:
	var win: Window = get_window()
	var base: Vector2i = current_base()
	match approach:
		P1ARenderMode.Approach.INTEGER_VIEWPORT:
			_reparent_world(_direct_root)
			win.content_scale_mode = Window.CONTENT_SCALE_MODE_VIEWPORT
			win.content_scale_aspect = Window.CONTENT_SCALE_ASPECT_KEEP
			win.content_scale_stretch = Window.CONTENT_SCALE_STRETCH_INTEGER
			win.content_scale_size = base
			_display.visible = false
		P1ARenderMode.Approach.INTEGER_VIEWPORT_EXPAND:
			_reparent_world(_direct_root)
			win.content_scale_mode = Window.CONTENT_SCALE_MODE_VIEWPORT
			win.content_scale_aspect = Window.CONTENT_SCALE_ASPECT_EXPAND
			win.content_scale_stretch = Window.CONTENT_SCALE_STRETCH_INTEGER
			win.content_scale_size = base
			_display.visible = false
		P1ARenderMode.Approach.PIXEL_SNAPPED_CANVAS:
			_reparent_world(_direct_root)
			win.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
			win.content_scale_aspect = Window.CONTENT_SCALE_ASPECT_EXPAND
			win.content_scale_stretch = Window.CONTENT_SCALE_STRETCH_FRACTIONAL
			win.content_scale_size = base
			_display.visible = false
		_:
			# 3, 5, 6 and 7 all render the world into the SubViewport at the base
			# resolution and present the finished texture. They differ only in how that
			# finished texture is scaled and placed.
			win.content_scale_mode = Window.CONTENT_SCALE_MODE_DISABLED
			win.content_scale_aspect = Window.CONTENT_SCALE_ASPECT_IGNORE
			win.content_scale_stretch = Window.CONTENT_SCALE_STRETCH_FRACTIONAL
			win.content_scale_size = Vector2i.ZERO
			_sub_viewport.size = base + Vector2i(
				P1ARenderMode.SUBVIEWPORT_MARGIN_PX, P1ARenderMode.SUBVIEWPORT_MARGIN_PX)
			_reparent_world(_sub_viewport)
			_display.visible = true
	# Approach 5 places the finished frame at a FRACTIONAL device offset on purpose, so
	# the root must not snap it away. Everything else snaps, and the SubViewport's own
	# world always snaps regardless.
	var want_snap: bool = approach != P1ARenderMode.Approach.SUBVIEWPORT_FILL
	get_viewport().snap_2d_transforms_to_pixel = want_snap
	get_viewport().snap_2d_vertices_to_pixel = want_snap
	_place_camera()
	queue_redraw_hud()


func _reparent_world(new_parent: Node) -> void:
	for n: Node in [_world, _actor, _camera]:
		if n.get_parent() == new_parent:
			continue
		if n.get_parent() != null:
			n.get_parent().remove_child(n)
		new_parent.add_child(n)


func _apply_window() -> void:
	var want: Vector2i = _windows[window_index]
	if want.x > 0 and want.y > 0:
		DisplayServer.window_set_size(want)
	_apply_approach()


# --- camera -------------------------------------------------------------------------

func _place_camera() -> void:
	var px_per_m: float = float(current_density()["px_per_m"])
	var frame: int = maxi(0, pan_frame)
	var snap: Dictionary = P1APan.snapped(approach, frame, px_per_m, Vector2.ZERO)
	_camera.position = snap["camera"]
	_camera.make_current()
	if _uses_display():
		var win: Vector2i = DisplayServer.window_get_size()
		var base: Vector2i = current_base()
		var rem: Vector2 = snap["remainder"]
		var s: float
		if approach == P1ARenderMode.Approach.SUBVIEWPORT_REMAINDER:
			s = float(P1ARenderMode.integer_scale(win, base))
		else:
			# The FINAL-FRAME presentation scale. It is fractional on purpose and it is
			# not a character CanvasItem scale: every sprite inside the SubViewport is
			# still drawn at an integral 1:1 scale.
			s = P1ARenderMode.fill_scale(win, base)
		_display.scale = Vector2(s, s)
		var shown: Vector2 = Vector2(base) * s
		var centre: Vector2 = (Vector2(win) - shown) * 0.5
		match approach:
			P1ARenderMode.Approach.SUBVIEWPORT_FILL:
				# Sub-device-pixel precision: the finished frame slides by a fraction of
				# a device pixel, so the uneven output grid moves with it.
				_display.position = centre - rem * s
			P1ARenderMode.Approach.SUBVIEWPORT_FILL_FIXED:
				# Pinned. The uneven output grid is stationary in screen space and the
				# camera moves in whole logical pixels only.
				_display.position = centre.floor()
			_:
				# 3 and 6: whole device pixels.
				_display.position = (centre - rem * s).floor()


## Where the actor's GROUND POINT lands, in device pixels, right now.
##
## Read from the engine rather than re-derived: `get_global_transform_with_canvas()`
## gives the actor's position inside whichever viewport is drawing it, and the screen
## transform (or the display rect, for the SubViewport approaches) carries it the rest
## of the way. The evidence capture crops around this, so a character-stability probe
## cannot drift away from where the character actually is.
func actor_device_position() -> Vector2:
	var local: Vector2 = _actor.get_global_transform_with_canvas().origin
	if _uses_display():
		return _display.position + local * _display.scale
	return get_viewport().get_screen_transform() * local


## The base resolution can be set directly, for the base-resolution comparison.
func set_base_resolution(size: Vector2i) -> void:
	for i: int in range(BASE_CANDIDATES.size()):
		if BASE_CANDIDATES[i] == size:
			base_index = i
			_apply_approach()
			return
	push_warning("P1A: %s is not one of the candidate base resolutions" % str(size))


func _uses_display() -> bool:
	return approach == P1ARenderMode.Approach.SUBVIEWPORT_REMAINDER \
		or approach == P1ARenderMode.Approach.SUBVIEWPORT_FILL \
		or approach == P1ARenderMode.Approach.SUBVIEWPORT_FILL_SNAPPED \
		or approach == P1ARenderMode.Approach.SUBVIEWPORT_FILL_FIXED


func _process(_delta: float) -> void:
	if pan_frame >= 0:
		pan_frame += 1
		if pan_frame >= P1APan.FRAME_COUNT:
			pan_frame = -1
		_place_camera()
	if show_hud:
		_hud.text = _readout()


# --- input --------------------------------------------------------------------------

func _unhandled_input(event: InputEvent) -> void:
	var key := event as InputEventKey
	if key != null and key.pressed and not key.echo:
		match key.physical_keycode:
			KEY_1: approach = P1ARenderMode.Approach.INTEGER_VIEWPORT; _apply_approach()
			KEY_2: approach = P1ARenderMode.Approach.PIXEL_SNAPPED_CANVAS; _apply_approach()
			KEY_3: approach = P1ARenderMode.Approach.SUBVIEWPORT_REMAINDER; _apply_approach()
			KEY_4: approach = P1ARenderMode.Approach.INTEGER_VIEWPORT_EXPAND; _apply_approach()
			KEY_5: approach = P1ARenderMode.Approach.SUBVIEWPORT_FILL; _apply_approach()
			KEY_6: approach = P1ARenderMode.Approach.SUBVIEWPORT_FILL_SNAPPED; _apply_approach()
			KEY_7: approach = P1ARenderMode.Approach.SUBVIEWPORT_FILL_FIXED; _apply_approach()
			KEY_A: anchor_mode = (anchor_mode + 1) % ANCHOR_MODE_NAMES.size(); _reload_character()
			KEY_TAB, KEY_C: _cycle_character()
			KEY_LEFT, KEY_Q: _cycle_direction(-1)
			KEY_RIGHT, KEY_E: _cycle_direction(1)
			KEY_D: density_index = (density_index + 1) % P1AScale.candidates().size(); _apply_density(); _apply_approach()
			KEY_B: base_index = (base_index + 1) % BASE_CANDIDATES.size(); _apply_approach()
			KEY_R: window_index = (window_index + 1) % _windows.size(); _apply_window()
			# SPACE TOGGLES the pan: it starts one from frame 0, and stops one in progress.
			KEY_SPACE: pan_frame = -1 if pan_frame >= 0 else 0; _place_camera()
			KEY_M: show_markers = not show_markers; _actor.show_markers = show_markers
			KEY_H: show_hud = not show_hud; _hud.visible = show_hud
			KEY_ESCAPE: get_tree().quit()
	var pad := event as InputEventJoypadButton
	if pad != null and pad.pressed:
		match pad.button_index:
			JOY_BUTTON_DPAD_LEFT: _cycle_direction(-1)
			JOY_BUTTON_DPAD_RIGHT: _cycle_direction(1)
			JOY_BUTTON_DPAD_UP: _cycle_character()
			JOY_BUTTON_DPAD_DOWN: approach = (approach + 1) % P1ARenderMode.APPROACH_IDS.size(); _apply_approach()
			JOY_BUTTON_A: pan_frame = -1 if pan_frame >= 0 else 0; _place_camera()
			JOY_BUTTON_B: base_index = (base_index + 1) % BASE_CANDIDATES.size(); _apply_approach()


func _cycle_character() -> void:
	character = "huntress" if character == "mage" else "mage"
	_reload_character()
	_apply_density()


func _cycle_direction(step: int) -> void:
	direction_index = wrapi(direction_index + step, 0, P1AArt.DIRECTION_TOKENS.size())
	_actor.set_direction(P1AArt.DIRECTION_TOKENS[direction_index])
	_update_actor_measurement()


## Name the window by what it MEASURES, never by which entry was last selected: the
## evidence capture sets the window itself, and a label taken from the selection index
## would then describe a window that is not on screen.
func _window_label(win: Vector2i) -> String:
	for i: int in range(_windows.size()):
		if _windows[i] == win:
			return WINDOW_LABELS[i]
	if DisplayServer.get_screen_count() > 0:
		var usable: Vector2i = DisplayServer.screen_get_usable_rect(
			DisplayServer.window_get_current_screen()).size
		if win == usable:
			return WINDOW_LABELS[0]
	return "set directly — not one of the named sizes"


func queue_redraw_hud() -> void:
	if _hud != null and show_hud:
		_hud.text = _readout()


# --- readout ------------------------------------------------------------------------

func _readout() -> String:
	var win: Vector2i = DisplayServer.window_get_size()
	var base: Vector2i = current_base()
	var d: Dictionary = current_density()
	var px_per_m: float = float(d["px_per_m"])
	var body: int = _actor.measured_body_px
	var desc: Dictionary = P1ARenderMode.describe(
		approach, win, base, px_per_m, float(body), sprite_scale)
	var tile: Dictionary = P1AScale.tile_proposal(px_per_m)
	var vis: Array = desc["visible_world_m"]
	var lines: PackedStringArray = PackedStringArray()
	lines.append("RIFTWROUGHT — P1A  character scale & rendering   [ACCEPTED AND CLOSED — D-356. P1B is NOT begun and needs its own ruling]")
	lines.append("")
	lines.append("approach  %s   %s" % [
		P1ARenderMode.approach_name(approach),
		"<< CANONICAL DEFAULT PRESENTATION (D-356)" if approach == P1ARenderMode.CANONICAL_APPROACH
		else ("<< REJECTED (D-351) — shown for comparison only" if P1ARenderMode.REJECTED_APPROACHES.has(approach)
			else "<< diagnostic comparator only — NOT the canonical presentation")])
	lines.append("          %s" % P1ARenderMode.APPROACH_SUMMARIES[approach])
	lines.append("window    %d x %d  (%s)      base %d x %d      scale %.4f  %s      bars %d x %d px      fills %.1f%% of the window" % [
		win.x, win.y, _window_label(win), base.x, base.y,
		float(desc["scale"]), ("integer" if bool(desc["scale_is_integer"]) else "FRACTIONAL"),
		int((desc["letterbox_total_px"] as Array)[0]), int((desc["letterbox_total_px"] as Array)[1]),
		float(desc["fill_fraction"]) * 100.0])
	if bool(desc["final_frame_presentation_scale"]):
		lines.append("          FINAL-FRAME PRESENTATION SCALE. Sprites stay 1:1 inside the logical frame; only the")
		lines.append("          finished frame is stretched, with nearest sampling. The uneven output grid %s." % [
			"MOVES with the camera remainder" if bool(desc["output_grid_moves_with_the_camera"]) else "is STATIONARY in screen space"])
	lines.append("density   candidate %s (%s): %.1f px/m, production cell %d px   —  sprite drawn at integral scale x%d" % [
		String(d["id"]), String(d["name"]), px_per_m, int(d["cell"]), sprite_scale])
	lines.append("visible   %.2f x %.2f m   (accepted 3D camera footprint, for comparison only: %.3f x %.3f m)" % [
		float(vis[0]), float(vis[1]),
		P1AScale.ACCEPTED_3D_CAMERA_FOOTPRINT_M.x, P1AScale.ACCEPTED_3D_CAMERA_FOOTPRINT_M.y])
	lines.append("actor     %s / %s   drawn body %d px at scale x%d = %.4f m against the accepted %.2f m   %.2f%% of content height   %.2f%% of the window   cell %d px" % [
		character, P1AArt.DIRECTION_TOKENS[direction_index], body, sprite_scale,
		P1AScale.effective_body_metres(float(body), sprite_scale, px_per_m), P1AArt.BODY_HEIGHT_M,
		float(desc["actor_fraction_of_screen_height"]) * 100.0,
		float(body * sprite_scale) * float(desc["scale"]) / maxf(1.0, float(win.y)) * 100.0,
		P1AArt.cell_size(character)])
	lines.append("anchor    ONE shared constant (%d, %d) — %s   |   the drawn feet centre on the ground row is %.1f   |   offset %+.1f px = %+.3f m" % [
		_actor.anchor.x, _actor.anchor.y, ANCHOR_MODE_NAMES[anchor_mode],
		_shared_ground_mid(character),
		_shared_ground_mid(character) - float(_actor.anchor.x),
		(_shared_ground_mid(character) - float(_actor.anchor.x)) / px_per_m])
	lines.append("LOCKED    base viewport %d x %d · output %d x %d · %.1f px/m · anchor (%d, %d) · cell %d px · tile %d x %d px = 1 m squared" % [
		P1AScale.CANONICAL_BASE_VIEWPORT.x, P1AScale.CANONICAL_BASE_VIEWPORT.y,
		P1AScale.DEFAULT_OUTPUT_RESOLUTION.x, P1AScale.DEFAULT_OUTPUT_RESOLUTION.y,
		P1AScale.LOCKED_PX_PER_M, P1AScale.LOCKED_GROUND_ANCHOR.x, P1AScale.LOCKED_GROUND_ANCHOR.y,
		P1AScale.LOCKED_CHARACTER_CELL_PX, P1AScale.LOCKED_TILE_PX.x, P1AScale.LOCKED_TILE_PX.y])
	lines.append("          RENDERING MODE LOCKED: mode %d, %s. The world extent is FIXED at %.2f x %.2f m and never" % [
		P1ARenderMode.CANONICAL_APPROACH_OWNER_NUMBER,
		P1ARenderMode.approach_id(P1ARenderMode.CANONICAL_APPROACH),
		P1AScale.LOCKED_CAMERA_FOOTPRINT_M.x, P1AScale.LOCKED_CAMERA_FOOTPRINT_M.y])
	lines.append("          grows with the monitor: no silent stretching and no extra world space from a bigger screen.")
	lines.append("tile      LOCKED for P1B: %d x %d px, %s  — locked dimensions, and still not a tileset" % [
		int(tile["tile_w"]), int(tile["tile_h"]), String(tile["projection"])])
	lines.append("pan       %s   (5.000 s diagonal, %d frames, deterministic)" % [
		("frame %d / %d" % [pan_frame, P1APan.FRAME_COUNT]) if pan_frame >= 0 else "idle — press SPACE",
		P1APan.FRAME_COUNT])
	lines.append("")
	if density_mismatch:
		lines.append(">>> DENSITY MISMATCH: '%s' is exported at a %d px cell and candidate %s asks for %d px." % [
			character, P1AArt.cell_size(character), String(d["id"]), int(d["cell"])])
		lines.append("    A1 forbids a non-integral sprite scale, so the frame on screen is NOT at the selected")
		lines.append("    density. This is the measured finding P1A hands back, not a bug in the tool.")
	lines.append("NOT IMPLEMENTED, and not claimed: movement, collision, navigation, targeting, combat, animation states")
	lines.append("beyond idle, any tileset, and any environment art. P1A displays and measures. Acceptance of P1A")
	lines.append("authorizes NONE of them, and no optional player-facing pixel-perfect mode is implemented or exposed.")
	if character == "huntress":
		lines.append("HUNTRESS: ALL EIGHT idle directions are exported and imported — 8 strips, 4 frames each,")
		lines.append("          32 frames at %.1f FPS. Nothing on screen is a stand-in for anything." % P1AArt.IDLE_FPS)
	else:
		lines.append("MAGE: 64x64 reference and diagnostic art, one idle frame per direction. It is NOT the")
		lines.append("      production standard and awaits a 128x128 reconstruction.")
	lines.append("")
	lines.append("1 integer viewport   2 pixel-snapped canvas (rejected)   3 SubViewport+remainder (preferred)   4 integer viewport expand")
	lines.append("5 SubViewport FILL   6 fill, remainder snapped   7 fill, display pinned      |   SPACE starts AND stops the 5 s diagonal pan")
	lines.append("LEFT/RIGHT (or Q/E) cycle the eight facings   TAB character   D density   B base   R window   A anchor   M markers   H hud   ESC quit")
	return "\n".join(lines)
