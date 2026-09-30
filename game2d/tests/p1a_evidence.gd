extends SceneTree
## Riftwrought — P1A: rendered evidence capture.
##
## THIS ONE OPENS A WINDOW. It is the opt-in half of the runner, because a rendered run
## takes the owner's real pointer and keyboard while it is up. The comparison tool's own
## input and processing are switched OFF for the duration, so a stray click cannot move
## anything: every camera position here is a pure function of a frame index.
##
## WHAT IT PRODUCES, per (approach x window resolution):
##   - a still at pan frame 0 and at pan frame 150, to be LOOKED AT;
##   - a "crawl chart": 60 consecutive pan frames, each a thin strip of the one-pixel
##     stripe field, stacked top to bottom, so shimmer is visible as well as counted;
##   - the frame-comparison shimmer metrics, and the scale, letterbox, visible world
##     extent, actor screen fraction and camera-step behaviour the engine ACTUALLY
##     produced — not the arithmetic's prediction of them.
##
## Usage:
##   Godot --path game2d --script res://tests/p1a_evidence.gd -- --out <dir> [--density A|B]

const CRAWL_FRAMES: int = 60
const CRAWL_WIDTH: int = 192
const CRAWL_HEIGHT: int = 6
const STILL_FRAMES: Array[int] = [0, 150]

## A full frame at the owner's real backing resolution is tens of megapixels, so the
## evidence is split rather than truncated: an OVERVIEW of the whole frame, reduced by a
## whole number when it is very large, for layout, letterboxing and framing; and a
## PIXEL crop at the true device resolution, never reduced, for pixel fidelity.
const OVERVIEW_MAX_WIDTH: int = 1920
const PIXEL_CROP: Vector2i = Vector2i(640, 360)

## The character-stability probe. A box of DEVICE pixels anchored on the actor's own
## ground point, captured every frame of the pan.
##
## **This is the measurement that answers "do rows or columns pulse".** Anchoring on the
## actor means the character sits at the same place in every crop, so two crops differ
## only if the character was RASTERISED differently. Under a whole-number output scale
## with the camera snapped, every crop is byte-identical and the count below is 1. Under
## a fractional output scale the character is re-rasterised as it crosses the uneven
## grid, and the count is the number of distinct renderings the owner would see cycling
## during the pan.
const CHARACTER_PROBE: Vector2i = Vector2i(256, 288)

## The whole-device-pixel search window for the translation test, and the sentinel for
## "no shift in that window reproduces frame 0's row".
const PROBE_SHIFT_RANGE: int = 8
const PROBE_NO_MATCH: int = 9999

var _out_dir: String = ""
var _density_id: String = "B"
var _character: String = "huntress"
var _base_override: Vector2i = Vector2i.ZERO
var _tool: Node = null
var _results: Array = []
var _base_rows: Array = []
var _failures: PackedStringArray = PackedStringArray()


func _initialize() -> void:
	_main.call_deferred()


func _main() -> void:
	var args: PackedStringArray = OS.get_cmdline_user_args()
	for i: int in range(args.size() - 1):
		if args[i] == "--out":
			_out_dir = args[i + 1]
		elif args[i] == "--density":
			_density_id = args[i + 1]
		elif args[i] == "--character":
			_character = args[i + 1]
		elif args[i] == "--base":
			var parts: PackedStringArray = args[i + 1].split("x")
			if parts.size() == 2:
				_base_override = Vector2i(int(parts[0]), int(parts[1]))
	if _out_dir.is_empty():
		printerr("p1a_evidence: --out <dir> is required")
		quit(2)
		return
	DirAccess.make_dir_recursive_absolute(_out_dir)

	print("")
	print("=== Riftwrought — P1A rendered evidence capture ===")
	print("  display driver: %s" % DisplayServer.get_name())
	if DisplayServer.get_name() == "headless":
		printerr("p1a_evidence: this run is headless, so nothing can be rendered. Run without --headless.")
		quit(2)
		return

	var display: Dictionary = _display_facts()
	print("  %d screen(s) discovered:" % int(display["screen_count"]))
	for s: Dictionary in (display["screens"] as Array):
		print("    screen %d: %s px, usable %s, scale %.2f, %d dpi, %.2f Hz%s" % [
			int(s["index"]), str(s["size"]), str(s["usable_rect"]), float(s["scale"]),
			int(s["dpi"]), float(s["refresh_rate"]), "  (primary)" if bool(s["is_primary"]) else ""])

	var packed: PackedScene = load("res://scenes/p1a_comparison.tscn") as PackedScene
	_tool = packed.instantiate()
	root.add_child(_tool)
	await process_frame
	# The tool must not drive itself and must not take the owner's input.
	_tool.set_process(false)
	_tool.set_process_unhandled_input(false)
	var density_index: int = 0
	for i: int in range(P1AScale.candidates().size()):
		if String((P1AScale.candidates()[i] as Dictionary)["id"]) == _density_id:
			density_index = i
	_tool.set("density_index", density_index)
	_tool.set("character", _character)
	_tool.set("direction_index", 2)
	_tool.call("_reload_character")
	_tool.call("_apply_density")
	# EVERY captured frame is of the same idle frame. The pan advances on a frame index
	# and the idle clip advances on real time, so a capture that let the clip run would
	# be comparing animation to animation and calling it a rendering difference.
	(_tool.find_child("Actor", true, false) as Node).call("freeze_animation", true, 0)
	if _base_override.x > 0:
		_tool.call("set_base_resolution", _base_override)
	var base: Vector2i = _tool.call("current_base")
	var density: Dictionary = _tool.call("current_density")
	print("  character %s, density candidate %s (%.1f px/m, cell %d), base %dx%d, anchor mode %d" % [
		_character, String(density["id"]), float(density["px_per_m"]), int(density["cell"]),
		base.x, base.y, int(_tool.get("anchor_mode"))])

	var windows: Array[Vector2i] = _window_list(display)
	for w: Vector2i in windows:
		for approach: int in range(P1ARenderMode.APPROACH_IDS.size()):
			await _capture_combination(w, approach, base, density)

	await _compose_anchor_sheet()
	await _capture_direction_sheet()
	await _capture_base_comparison()
	await _compose_sheets(windows)

	var report: Dictionary = {
		"report": "riftwrought_p1a_rendered_evidence",
		"status": "DELIVERED AND OPEN — rendered evidence, to be LOOKED AT, not a decision",
		"godot": Engine.get_version_info().get("string", "?"),
		"display": display,
		"character": _character,
		"density_candidate": density,
		"idle_animation": "frozen on frame 0 for every capture, so that any frame-to-frame difference is a RENDERING difference",
		"anchor": {
			"mode": int(_tool.get("anchor_mode")),
			"value": [int((_tool.find_child("Actor", true, false).get("anchor") as Vector2i).x),
				int((_tool.find_child("Actor", true, false).get("anchor") as Vector2i).y)],
		},
		"base_resolution_used": [base.x, base.y],
		"pan": {"frames": P1APan.FRAME_COUNT, "duration_s": P1APan.DURATION_S,
			"speed_mps": P1APan.SPEED_MPS, "direction": [P1APan.DIRECTION.x, P1APan.DIRECTION.y]},
		"combinations": _results,
		"base_comparison": _base_rows,
	}
	var f: FileAccess = FileAccess.open(_out_dir.path_join("p1a_rendered_evidence.json"), FileAccess.WRITE)
	f.store_string(JSON.stringify(report, "  ", false) + "\n")
	f.close()
	print("")
	print("  %d combinations captured into %s" % [_results.size(), _out_dir])
	if _failures.is_empty():
		print("P1A EVIDENCE: CAPTURED (%d combinations)" % _results.size())
		quit(0)
	else:
		for x: String in _failures:
			printerr("  PROBLEM: %s" % x)
		printerr("P1A EVIDENCE: %d PROBLEM(S)" % _failures.size())
		quit(1)


## THE ANCHOR SHEET (owner ruling): every direction against the shared (64, 122) origin,
## with the boot supports found, their centres marked, the projected stance centre drawn,
## the proposed whole-strip translation stated, and the excluded cloak/weapon pixels
## tinted so it is visible what the measurement ignored.
func _compose_anchor_sheet() -> void:
	if _character != "huntress":
		return
	var zoom: int = 4
	var cell: Vector2i = Vector2i(128 * zoom + 12, 128 * zoom + 56)
	var size: Vector2i = Vector2i(cell.x * 4 + 16, cell.y * 2 + 64)
	var vp: SubViewport = SubViewport.new()
	vp.size = size
	vp.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	root.add_child(vp)
	var bg: ColorRect = ColorRect.new()
	bg.color = Color(0.06, 0.06, 0.09)
	bg.size = Vector2(size)
	vp.add_child(bg)
	var title: Label = Label.new()
	title.position = Vector2(8, 5)
	title.add_theme_font_size_override("font_size", 15)
	title.text = "Riftwrought P1A — COMPLETE-STANCE anchor measurement AFTER the owner's registration pass (D-355), frame 0 at %dx.  RED = shared origin (64, 122).  CYAN = boot supports, with their centres.  YELLOW = projected stance centre.  Tinted = pixels EXCLUDED from the measurement (magenta = cloak/hood/foliage, orange = bow/quiver/arrows).  Every residual below is integer-grid parity and must NEVER become a runtime offset." % zoom
	vp.add_child(title)
	for i: int in range(P1AArt.DIRECTION_TOKENS.size()):
		var token: String = P1AArt.DIRECTION_TOKENS[i]
		var img: Image = P1AArt.load_direction_image("huntress", token)
		var frames: Array[Dictionary] = P1AArt.measure_direction("huntress", token)
		var m: Dictionary = frames[0]
		var annotated: Image = _annotate_anchor(img, P1AArt.cell_rect("huntress", 0), m, zoom)
		var at: Vector2 = Vector2(8 + (i % 4) * cell.x, 44 + (i / 4) * cell.y)
		var lo: int = 9999
		var hi: int = -1
		var mid_lo: float = 9999.0
		var mid_hi: float = -9999.0
		for f: Dictionary in frames:
			lo = mini(lo, int(f["stance_complete_x0"]))
			hi = maxi(hi, int(f["stance_complete_x1"]))
			mid_lo = minf(mid_lo, float(f["stance_complete_mid"]))
			mid_hi = maxf(mid_hi, float(f["stance_complete_mid"]))
		var union_mid: float = float(lo + hi) * 0.5
		var label: Label = Label.new()
		label.position = at
		label.add_theme_font_size_override("font_size", 11)
		var residual: float = 64.0 - union_mid
		var vres: int = 122 - int(m["ground_row"])
		label.text = "%s   %s\nunion stance %d..%d   projected root %.1f   contact row %d   REGISTERED %s\nresidual %+0.1f px x, %+d px y — %s      frame-to-frame %.1f px (4 frames)" % [
			token.to_upper(), String(P1AArt.HUNTRESS_SOURCE_NAMES[token]),
			lo, hi, union_mid, int(m["ground_row"]),
			"+%d,%+d applied" % [int(P1AArt.REGISTRATION_TARGETS[token].x), int(P1AArt.REGISTRATION_TARGETS[token].y)] \
				if int(P1AArt.REGISTRATION_TARGETS[token].x) >= 0 \
				else "%d,%+d applied" % [int(P1AArt.REGISTRATION_TARGETS[token].x), int(P1AArt.REGISTRATION_TARGETS[token].y)],
			residual, vres,
			"grid parity, compliant — DO NOT apply" if absf(residual) <= 0.5 and vres == 0 else "NOT COMPLIANT",
			mid_hi - mid_lo]
		vp.add_child(label)
		var tr: TextureRect = TextureRect.new()
		tr.texture = ImageTexture.create_from_image(annotated)
		tr.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		tr.position = at + Vector2(0, 50)
		vp.add_child(tr)
	await process_frame
	await RenderingServer.frame_post_draw
	var path: String = _out_dir.path_join("p1a_huntress_anchor_sheet.png")
	vp.get_texture().get_image().save_png(path)
	print("  anchor sheet: %s (%dx%d)" % [path.get_file(), size.x, size.y])
	vp.queue_free()
	await process_frame


## One annotated cell: excluded classes tinted, boot supports boxed and centred, the
## projected stance centre and the shared origin drawn.
func _annotate_anchor(img: Image, rect: Rect2i, m: Dictionary, zoom: int) -> Image:
	var out: Image = Image.create(rect.size.x * zoom, rect.size.y * zoom, false, Image.FORMAT_RGBA8)
	out.fill(Color(0.16, 0.16, 0.20))
	for y: int in range(rect.size.y):
		for x: int in range(rect.size.x):
			var c: Color = img.get_pixel(rect.position.x + x, rect.position.y + y)
			if c.a <= 0.0:
				continue
			match P1AArt.classify_pixel(c):
				P1AArt.PixelClass.GREEN:
					c = c.lerp(Color(1.0, 0.25, 0.85), 0.42)   # excluded: cloak, hood, foliage
				P1AArt.PixelClass.WOOD:
					c = c.lerp(Color(1.0, 0.62, 0.15), 0.42)   # excluded: bow, quiver, arrows
				_:
					pass
			for dy: int in range(zoom):
				for dx: int in range(zoom):
					out.set_pixel(x * zoom + dx, y * zoom + dy, c)
	var cyan: Color = Color(0.35, 0.95, 1.0)
	for cl: Dictionary in (m.get("boot_clusters", []) as Array):
		var x0: int = int(cl["x0"]) * zoom
		var x1: int = (int(cl["x1"]) + 1) * zoom - 1
		var y0: int = int(cl["y0"]) * zoom
		var y1: int = (int(cl["y1"]) + 1) * zoom - 1
		_rect_outline(out, x0, y0, x1, y1, cyan)
		# each support's own centre
		var cx: int = int(round((float(int(cl["x0"]) + int(cl["x1"]) + 1) * 0.5) * float(zoom)))
		_vline(out, cx, y0, y1, cyan)
	var stance_mid: float = float(m["stance_complete_mid"])
	if stance_mid >= 0.0:
		_vline(out, int(round((stance_mid + 0.5) * float(zoom))), 0, out.get_height() - 1,
			Color(1.0, 0.95, 0.2))
	_vline(out, int((64.0 + 0.5) * float(zoom)), 0, out.get_height() - 1, Color(1.0, 0.25, 0.25))
	_hline(out, int((122.0 + 0.5) * float(zoom)), 0, out.get_width() - 1, Color(1.0, 0.25, 0.25))
	return out


func _vline(img: Image, x: int, y0: int, y1: int, c: Color) -> void:
	if x < 0 or x >= img.get_width():
		return
	for y: int in range(maxi(0, y0), mini(img.get_height(), y1 + 1)):
		img.set_pixel(x, y, c)


func _hline(img: Image, y: int, x0: int, x1: int, c: Color) -> void:
	if y < 0 or y >= img.get_height():
		return
	for x: int in range(maxi(0, x0), mini(img.get_width(), x1 + 1)):
		img.set_pixel(x, y, c)


func _rect_outline(img: Image, x0: int, y0: int, x1: int, y1: int, c: Color) -> void:
	_hline(img, y0, x0, x1, c)
	_hline(img, y1, x0, x1, c)
	_vline(img, x0, y0, y1, c)
	_vline(img, x1, y0, y1, c)


## All eight canonical directions, live in the tool, at true device pixels, each labelled
## with its owner source file and its measured deviation from the locked anchor.
##
## This is the sheet that shows whether the character SLIDES when she turns: every cell
## is cropped on the SAME anchor, so a character that shares one ground point stands
## still across the eight and one that does not visibly steps sideways.
func _capture_direction_sheet() -> void:
	if _character != "huntress":
		return
	var win: Vector2i = DisplayServer.screen_get_usable_rect(
		DisplayServer.window_get_current_screen()).size
	DisplayServer.window_set_size(win)
	_tool.set("approach", P1ARenderMode.Approach.SUBVIEWPORT_REMAINDER)
	_tool.call("set_base_resolution", Vector2i(1920, 1080))
	_tool.call("_apply_approach")
	for _i: int in range(4):
		await process_frame
	var actual: Vector2i = DisplayServer.window_get_size()
	var hud: CanvasLayer = _tool.find_child("HUD", true, false) as CanvasLayer
	var world: Node = _tool.find_child("DiagnosticWorld", true, false)
	hud.visible = false
	var crop: Vector2i = Vector2i(300, 340)
	var zoom: int = 2
	var cell: Vector2i = Vector2i(crop.x * zoom + 12, crop.y * zoom + 42)
	var size: Vector2i = Vector2i(cell.x * 4 + 16, cell.y * 2 + 60)
	var vp: SubViewport = SubViewport.new()
	vp.size = size
	vp.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	root.add_child(vp)
	var bg: ColorRect = ColorRect.new()
	bg.color = Color(0.07, 0.07, 0.10)
	bg.size = Vector2(size)
	vp.add_child(bg)
	var title: Label = Label.new()
	title.position = Vector2(8, 6)
	title.add_theme_font_size_override("font_size", 15)
	title.text = "Riftwrought P1A — the eight owner-exported Huntress idle directions, %dx, every cell cropped on the SAME anchor (64, 122).  DELIVERED AND OPEN." % zoom
	vp.add_child(title)
	_tool.set("pan_frame", 0)
	for i: int in range(P1AArt.DIRECTION_TOKENS.size()):
		var token: String = P1AArt.DIRECTION_TOKENS[i]
		_tool.set("direction_index", i)
		_tool.call("_cycle_direction", 0)
		_tool.call("_place_camera")
		await process_frame
		var img: Image = _to_device(await _grab(), actual)
		var at: Vector2 = _tool.call("actor_device_position")
		var ox: int = clampi(int(floor(at.x)) - crop.x / 2, 0, maxi(0, img.get_width() - crop.x))
		var oy: int = clampi(int(floor(at.y)) - crop.y * 4 / 5, 0, maxi(0, img.get_height() - crop.y))
		var cc: Image = _rgba(img.get_region(Rect2i(ox, oy, mini(crop.x, img.get_width() - ox),
			mini(crop.y, img.get_height() - oy))))
		cc.resize(cc.get_width() * zoom, cc.get_height() * zoom, Image.INTERPOLATE_NEAREST)
		var m: Array[Dictionary] = P1AArt.measure_direction("huntress", token)
		var at_pos: Vector2 = Vector2(8 + (i % 4) * cell.x, 40 + (i / 4) * cell.y)
		var label: Label = Label.new()
		label.position = at_pos
		label.add_theme_font_size_override("font_size", 11)
		label.text = "%s   %s\ncontact row %d  feet mid %.1f  dx %+.1f px (%+.3f m)  dy %+d" % [
			token.to_upper(), String(P1AArt.HUNTRESS_SOURCE_NAMES[token]),
			int(m[0]["ground_row"]), float(m[0]["ground_mid"]),
			float(m[0]["ground_mid"]) - 64.0, (float(m[0]["ground_mid"]) - 64.0) / 60.0,
			int(m[0]["ground_row"]) - 122]
		vp.add_child(label)
		var tr: TextureRect = TextureRect.new()
		tr.texture = ImageTexture.create_from_image(cc)
		tr.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		tr.position = at_pos + Vector2(0, 36)
		vp.add_child(tr)
	await process_frame
	await RenderingServer.frame_post_draw
	var path: String = _out_dir.path_join("p1a_huntress_eight_directions.png")
	vp.get_texture().get_image().save_png(path)
	print("  direction sheet: %s (%dx%d)" % [path.get_file(), size.x, size.y])
	vp.queue_free()
	hud.visible = true
	_tool.set("direction_index", 2)
	_tool.call("_cycle_direction", 0)
	await process_frame


## The base-resolution comparison the supplemental pass asked for: the native Huntress
## at 1280x720, 1600x900 and 1920x1080, on the owner's own display, under the integer
## approach and under the fractional fill. The numbers are arithmetic; the frames are
## what the owner has to look at, because readability and framing are not divisibility.
func _capture_base_comparison() -> void:
	var bases: Array[Vector2i] = [Vector2i(1280, 720), Vector2i(1600, 900), Vector2i(1920, 1080)]
	var current: int = DisplayServer.window_get_current_screen()
	var window: Vector2i = DisplayServer.screen_get_usable_rect(current).size
	DisplayServer.window_set_size(window)
	var density: Dictionary = _tool.call("current_density")
	var px_per_m: float = float(density["px_per_m"])
	var body: float = float(P1AScale.measured_px_per_m(P1AArt.measure_character(_character))["body_h_mean"])
	var hud_layer: CanvasLayer = _tool.find_child("HUD", true, false) as CanvasLayer
	print("")
	print("  BASE-RESOLUTION COMPARISON at the owner's own window %dx%d, density %s (%.1f px/m)" % [
		window.x, window.y, String(density["id"]), px_per_m])
	for b: Vector2i in bases:
		for approach: int in [P1ARenderMode.Approach.SUBVIEWPORT_REMAINDER, P1ARenderMode.Approach.SUBVIEWPORT_FILL]:
			_tool.set("approach", approach)
			_tool.call("set_base_resolution", b)
			_tool.call("_apply_approach")
			for _i: int in range(4):
				await process_frame
			var actual: Vector2i = DisplayServer.window_get_size()
			var d: Dictionary = P1ARenderMode.describe(approach, actual, b, px_per_m, body, 1)
			var tag: String = "base_%dx%d__%s" % [b.x, b.y, P1ARenderMode.APPROACH_IDS[approach]]
			hud_layer.visible = false
			_tool.set("pan_frame", 0)
			_tool.call("_place_camera")
			await process_frame
			var device: Image = _to_device(await _grab(), actual)
			var overview: Image = _rgba(device)
			var reduction: int = maxi(1, int(ceil(float(overview.get_width()) / float(OVERVIEW_MAX_WIDTH))))
			if reduction > 1:
				overview.resize(overview.get_width() / reduction, overview.get_height() / reduction,
					Image.INTERPOLATE_NEAREST)
			overview.save_png(_out_dir.path_join("%s__overview_div%d.png" % [tag, reduction]))
			_centre_crop(device, PIXEL_CROP).save_png(_out_dir.path_join("%s__pixels.png" % tag))
			hud_layer.visible = true
			_tool.call("queue_redraw_hud")
			await process_frame
			var ro: Image = _rgba(_to_device(await _grab(), actual))
			var rr: int = maxi(1, int(ceil(float(ro.get_width()) / float(OVERVIEW_MAX_WIDTH))))
			if rr > 1:
				ro.resize(ro.get_width() / rr, ro.get_height() / rr, Image.INTERPOLATE_NEAREST)
			ro.save_png(_out_dir.path_join("%s__readout_div%d.png" % [tag, rr]))
			hud_layer.visible = false
			var vis: Array = d["visible_world_m"]
			_base_rows.append({
				"base": [b.x, b.y], "approach": P1ARenderMode.APPROACH_IDS[approach],
				"window": [actual.x, actual.y], "scale": d["scale"],
				"letterbox_total_px": d["letterbox_total_px"], "fill_fraction": d["fill_fraction"],
				"visible_world_m": vis,
				"actor_fraction_of_content_height": d["actor_fraction_of_screen_height"],
				"actor_fraction_of_window_height": body * float(d["scale"]) / maxf(1.0, float(actual.y)),
				"drawn_body_px": body,
				"tag": tag,
			})
			print("    base %-10s %-24s x%-8.4f bars %-12s fills %5.1f%%  visible %6.2f x %6.2f m  actor %5.2f%% of content, %5.2f%% of window" % [
				"%dx%d" % [b.x, b.y], P1ARenderMode.APPROACH_IDS[approach], float(d["scale"]),
				str(d["letterbox_total_px"]), float(d["fill_fraction"]) * 100.0,
				float(vis[0]), float(vis[1]),
				float(d["actor_fraction_of_screen_height"]) * 100.0,
				body * float(d["scale"]) / maxf(1.0, float(actual.y)) * 100.0])
	hud_layer.visible = true


## The base-resolution sheet: three candidate bases down, integer output against
## fractional fill across, each cell a 3x NEAREST magnification of the same region of
## the Huntress so the BLOCK STRUCTURE is visible. Under an integer output every logical
## pixel is a perfect square block; under a fractional one some blocks are a device pixel
## wider than others. Both are legible; which is acceptable is the owner's call.
func _compose_base_sheet() -> void:
	if _base_rows.is_empty():
		return
	var zoom: int = 3
	var src: Vector2i = Vector2i(200, 150)
	var cell: Vector2i = Vector2i(src.x * zoom + 16, src.y * zoom + 40)
	var size: Vector2i = Vector2i(cell.x * 2 + 16, cell.y * 3 + 64)
	var vp: SubViewport = SubViewport.new()
	vp.size = size
	vp.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	root.add_child(vp)
	var bg: ColorRect = ColorRect.new()
	bg.color = Color(0.07, 0.07, 0.10)
	bg.size = Vector2(size)
	vp.add_child(bg)
	var title: Label = Label.new()
	title.position = Vector2(8, 6)
	title.add_theme_font_size_override("font_size", 15)
	title.text = "Riftwrought P1A supplemental — the native 128x128 Huntress, %dx NEAREST magnification, on the owner's own %dx%d window.  DELIVERED AND OPEN." % [
		zoom, int((_base_rows[0]["window"] as Array)[0]), int((_base_rows[0]["window"] as Array)[1])]
	vp.add_child(title)
	for r: int in range(_base_rows.size()):
		var row: Dictionary = _base_rows[r]
		var col: int = 0 if String(row["approach"]) == "subviewport_remainder" else 1
		var line: int = r / 2
		var at: Vector2 = Vector2(8 + col * cell.x, 40 + line * cell.y)
		var label: Label = Label.new()
		label.position = at
		label.add_theme_font_size_override("font_size", 11)
		label.text = "base %dx%d   %s   x%.4f   bars %s   fills %.1f%%\n%.2f x %.2f m visible   Huntress %.2f%% of content height, %.2f%% of the window" % [
			int((row["base"] as Array)[0]), int((row["base"] as Array)[1]), String(row["approach"]),
			float(row["scale"]), str(row["letterbox_total_px"]), float(row["fill_fraction"]) * 100.0,
			float((row["visible_world_m"] as Array)[0]), float((row["visible_world_m"] as Array)[1]),
			float(row["actor_fraction_of_content_height"]) * 100.0,
			float(row["actor_fraction_of_window_height"]) * 100.0]
		vp.add_child(label)
		var img: Image = Image.load_from_file(_out_dir.path_join("%s__pixels.png" % String(row["tag"])))
		if img == null:
			continue
		var cx: int = maxi(0, img.get_width() / 2 - src.x / 2)
		var cy: int = maxi(0, img.get_height() / 2 - src.y)
		var crop: Image = _rgba(img.get_region(Rect2i(cx, cy,
			mini(src.x, img.get_width() - cx), mini(src.y, img.get_height() - cy))))
		crop.resize(crop.get_width() * zoom, crop.get_height() * zoom, Image.INTERPOLATE_NEAREST)
		var tr: TextureRect = TextureRect.new()
		tr.texture = ImageTexture.create_from_image(crop)
		tr.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		tr.position = at + Vector2(0, 34)
		vp.add_child(tr)
	await process_frame
	await RenderingServer.frame_post_draw
	var path: String = _out_dir.path_join("p1a_comparison_sheet_base.png")
	vp.get_texture().get_image().save_png(path)
	print("  comparison sheet: %s (%dx%d)" % [path.get_file(), size.x, size.y])
	vp.queue_free()
	await process_frame


## The comparison sheets: one grid of crawl charts and one grid of true-device-pixel
## crops, four approaches across by five window resolutions down, each cell labelled.
## They are built in a SubViewport out of the files just written, so the sheet and the
## evidence cannot disagree, and they are meant to be LOOKED AT — the counted metrics
## are not a substitute for that.
func _compose_sheets(windows: Array[Vector2i]) -> void:
	await _compose_base_sheet()
	for kind: String in ["crawl", "pixels"]:
		var cell: Vector2i = Vector2i(204, 410) if kind == "crawl" else Vector2i(652, 230)
		var cols: int = P1ARenderMode.APPROACH_IDS.size()
		var rows: int = windows.size()
		var size: Vector2i = Vector2i(maxi(cell.x * cols + 16, 1100), cell.y * rows + 64)
		var vp: SubViewport = SubViewport.new()
		vp.size = size
		vp.transparent_bg = false
		vp.render_target_update_mode = SubViewport.UPDATE_ALWAYS
		root.add_child(vp)
		var bg: ColorRect = ColorRect.new()
		bg.color = Color(0.09, 0.09, 0.12)
		bg.size = Vector2(size)
		vp.add_child(bg)
		var title: Label = Label.new()
		title.position = Vector2(8, 6)
		title.add_theme_font_size_override("font_size", 15)
		title.text = "Riftwrought P1A — %s — DELIVERED AND OPEN, not accepted.  base %s, density %s, %.1f px/m" % [
			("one-pixel stripe field, 60 consecutive pan frames stacked downward: uneven stripe widths ARE the crawl"
				if kind == "crawl" else "true device pixels at pan frame 0 and frame 150, never resampled"),
			str(_tool.call("current_base")), String((_tool.call("current_density") as Dictionary)["id"]),
			float((_tool.call("current_density") as Dictionary)["px_per_m"])]
		vp.add_child(title)
		for r: int in range(rows):
			for c: int in range(cols):
				var tag: String = "%s__%dx%d" % [P1ARenderMode.APPROACH_IDS[c], windows[r].x, windows[r].y]
				var at: Vector2 = Vector2(8 + c * cell.x, 48 + r * cell.y)
				var label: Label = Label.new()
				label.position = at
				label.add_theme_font_size_override("font_size", 11)
				var found: Dictionary = {}
				for row2: Dictionary in _results:
					if String(row2["approach"]) == P1ARenderMode.APPROACH_IDS[c] \
							and (row2["window_requested"] as Array)[0] == windows[r].x \
							and (row2["window_requested"] as Array)[1] == windows[r].y:
						found = row2
				var verdict: String = String((found.get("shimmer", {}) as Dictionary).get("shimmer_verdict", "?"))
				label.text = "%s  %dx%d\n x%.4f  bars %s  %s" % [
					P1ARenderMode.APPROACH_IDS[c], windows[r].x, windows[r].y,
					float((found.get("predicted", {}) as Dictionary).get("scale", 0.0)),
					str((found.get("predicted", {}) as Dictionary).get("letterbox_total_px", [0, 0])), verdict]
				vp.add_child(label)
				var files: Array = ["%s__crawl.png" % tag] if kind == "crawl" \
					else ["%s__frame000_pixels.png" % tag, "%s__frame150_pixels.png" % tag]
				var x_at: float = 0.0
				for fn: String in files:
					var img: Image = Image.load_from_file(_out_dir.path_join(fn))
					if img == null:
						continue
					if kind == "pixels":
						img.resize(img.get_width() / 2, img.get_height() / 2, Image.INTERPOLATE_NEAREST)
					var tr: TextureRect = TextureRect.new()
					tr.texture = ImageTexture.create_from_image(img)
					tr.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
					tr.position = at + Vector2(x_at, 34)
					vp.add_child(tr)
					x_at += float(img.get_width()) + 4.0
		await process_frame
		await RenderingServer.frame_post_draw
		var sheet: Image = vp.get_texture().get_image()
		var path: String = _out_dir.path_join("p1a_comparison_sheet_%s.png" % kind)
		sheet.save_png(path)
		print("  comparison sheet: %s (%dx%d)" % [path.get_file(), size.x, size.y])
		vp.queue_free()
		await process_frame


func _display_facts() -> Dictionary:
	var screens: Array = []
	for i: int in range(DisplayServer.get_screen_count()):
		screens.append({
			"index": i,
			"size": [DisplayServer.screen_get_size(i).x, DisplayServer.screen_get_size(i).y],
			"usable_rect": [DisplayServer.screen_get_usable_rect(i).size.x,
				DisplayServer.screen_get_usable_rect(i).size.y],
			"scale": DisplayServer.screen_get_scale(i),
			"dpi": DisplayServer.screen_get_dpi(i),
			"refresh_rate": DisplayServer.screen_get_refresh_rate(i),
			"is_primary": i == DisplayServer.get_primary_screen(),
		})
	return {
		"driver": DisplayServer.get_name(),
		"screen_count": DisplayServer.get_screen_count(),
		"primary_screen": DisplayServer.get_primary_screen(),
		"screens": screens,
	}


## The five the brief names. Index 0 is DISCOVERED from the screen the window is on.
func _window_list(display: Dictionary) -> Array[Vector2i]:
	var out: Array[Vector2i] = []
	var current: int = DisplayServer.window_get_current_screen()
	var usable: Vector2i = DisplayServer.screen_get_usable_rect(current).size
	if usable.x > 0 and usable.y > 0:
		out.append(usable)
	for w: Vector2i in [Vector2i(1280, 720), Vector2i(1920, 1080), Vector2i(2560, 1440), Vector2i(3840, 2160)]:
		if not out.has(w):
			out.append(w)
	return out


func _capture_combination(want_window: Vector2i, approach: int, base: Vector2i, density: Dictionary) -> void:
	DisplayServer.window_set_size(want_window)
	_tool.set("approach", approach)
	_tool.call("_apply_approach")
	for _i: int in range(6):
		await process_frame
	var actual: Vector2i = DisplayServer.window_get_size()
	var px_per_m: float = float(density["px_per_m"])
	var tag: String = "%s__%dx%d" % [P1ARenderMode.APPROACH_IDS[approach], want_window.x, want_window.y]
	print("")
	print("  %s   requested %dx%d, actual %dx%d, root viewport %s" % [
		tag, want_window.x, want_window.y, actual.x, actual.y, str(root.size)])

	# Restore the readout when the combination is done.
	# --- stills, grid mode, to be looked at ---
	var world: Node = _tool.find_child("DiagnosticWorld", true, false)
	world.call("set_shimmer_field", false)
	var hud_layer: CanvasLayer = _tool.find_child("HUD", true, false) as CanvasLayer
	hud_layer.visible = false
	var still_paths: Array = []
	var root_size_seen: Vector2i = Vector2i.ZERO
	var capture_size_seen: Vector2i = Vector2i.ZERO
	var overview_reduction: int = 1
	for frame: int in STILL_FRAMES:
		_tool.set("pan_frame", frame)
		_tool.call("_place_camera")
		await process_frame
		var img: Image = await _grab()
		root_size_seen = root.size
		capture_size_seen = img.get_size()
		var device: Image = _to_device(img, actual)
		if frame == STILL_FRAMES[0]:
			var overview: Image = _rgba(device)
			overview_reduction = maxi(1, int(ceil(float(overview.get_width()) / float(OVERVIEW_MAX_WIDTH))))
			if overview_reduction > 1:
				overview.resize(overview.get_width() / overview_reduction,
					overview.get_height() / overview_reduction, Image.INTERPOLATE_NEAREST)
			var opath: String = _out_dir.path_join("%s__frame%03d_overview_div%d.png" % [tag, frame, overview_reduction])
			overview.save_png(opath)
			still_paths.append(opath.get_file())
		var pixel: Image = _centre_crop(device, PIXEL_CROP)
		var ppath: String = _out_dir.path_join("%s__frame%03d_pixels.png" % [tag, frame])
		pixel.save_png(ppath)
		still_paths.append(ppath.get_file())

	# One frame WITH the readout, so the owner can see what the tool says about itself.
	hud_layer.visible = true
	_tool.set("pan_frame", 0)
	_tool.call("_place_camera")
	_tool.call("queue_redraw_hud")
	await process_frame
	var with_readout: Image = _to_device(await _grab(), actual)
	var reduction_r: int = maxi(1, int(ceil(float(with_readout.get_width()) / float(OVERVIEW_MAX_WIDTH))))
	var readout_img: Image = _rgba(with_readout)
	if reduction_r > 1:
		readout_img.resize(readout_img.get_width() / reduction_r,
			readout_img.get_height() / reduction_r, Image.INTERPOLATE_NEAREST)
	var rpath: String = _out_dir.path_join("%s__readout_div%d.png" % [tag, reduction_r])
	readout_img.save_png(rpath)
	still_paths.append(rpath.get_file())
	hud_layer.visible = false

	# --- the crawl chart, stripe mode, 60 consecutive pan frames ---
	#
	# The readout and the actor are hidden for this pass. Both are anti-aliased — the
	# Label draws outlined glyphs — and a probe that clipped either of them would report
	# dozens of colours and blame the renderer for text. The probe must see the stripe
	# field and nothing else.
	var hud: CanvasLayer = _tool.find_child("HUD", true, false) as CanvasLayer
	var actor: Node2D = _tool.find_child("Actor", true, false) as Node2D
	var hud_was: bool = hud.visible
	var actor_was: bool = actor.visible
	hud.visible = false
	actor.visible = false
	world.call("set_shimmer_field", true)
	var strip: Image = Image.create(CRAWL_WIDTH, CRAWL_FRAMES * CRAWL_HEIGHT, false, Image.FORMAT_RGBA8)
	var run_patterns: Array = []
	var colours: Dictionary = {}
	for i: int in range(CRAWL_FRAMES):
		_tool.set("pan_frame", i)
		_tool.call("_place_camera")
		await process_frame
		var img2: Image = await _grab()
		var device2: Image = _to_device(img2, actual)
		var cx: int = maxi(0, device2.get_width() / 2 - CRAWL_WIDTH / 2)
		var cy: int = maxi(0, device2.get_height() / 4)
		var crop: Image = device2.get_region(Rect2i(cx, cy,
			mini(CRAWL_WIDTH, device2.get_width() - cx), mini(CRAWL_HEIGHT, device2.get_height() - cy)))
		crop = _rgba(crop)
		strip.blit_rect(crop, Rect2i(Vector2i.ZERO, crop.get_size()), Vector2i(0, i * CRAWL_HEIGHT))
		for x: int in range(crop.get_width()):
			colours[crop.get_pixel(x, 0).to_html(false)] = true
		run_patterns.append(_run_lengths(crop, 0))
	var strip_path: String = _out_dir.path_join("%s__crawl.png" % tag)
	strip.save_png(strip_path)
	world.call("set_shimmer_field", false)

	# --- the character-stability probe ---
	#
	# THE QUESTION: as the Huntress crosses the output grid, does she merely TRANSLATE,
	# or is she re-rasterised — rows and columns changing width — from frame to frame?
	#
	# The test is exact, not statistical. One device-pixel row through her chest is
	# captured every frame; a frame passes if its row is, byte for byte, frame 0's row
	# shifted by SOME whole number of device pixels within the search window. A pipeline
	# that only translates passes every frame. A pipeline that re-rasterises fails, and
	# the count of failures is how many frames of the pan look different from the first.
	#
	# The diagnostic world draws only its flat background for this pass, because the
	# ruler labels and the tile caption are anti-aliased text.
	actor.visible = true
	world.call("set_character_probe_mode", true)
	var probe_rows: Array = []
	var probe_positions: Array = []
	var char_strip: Image = Image.create(CHARACTER_PROBE.x, 4 * CHARACTER_PROBE.y, false, Image.FORMAT_RGBA8)
	var char_colours: Dictionary = {}
	var char_missing: int = 0
	var strip_slot: int = 0
	for i: int in range(CRAWL_FRAMES):
		_tool.set("pan_frame", i)
		_tool.call("_place_camera")
		await process_frame
		var img3: Image = await _grab()
		var device3: Image = _to_device(img3, actual)
		var at: Vector2 = _tool.call("actor_device_position")
		if device3.get_width() < CHARACTER_PROBE.x or device3.get_height() < CHARACTER_PROBE.y:
			char_missing += 1
			continue
		var ox: int = clampi(int(floor(at.x)) - CHARACTER_PROBE.x / 2, 0,
			maxi(0, device3.get_width() - CHARACTER_PROBE.x))
		var oy: int = clampi(int(floor(at.y)) - CHARACTER_PROBE.y * 3 / 4, 0,
			maxi(0, device3.get_height() - CHARACTER_PROBE.y))
		var cc: Image = _rgba(device3.get_region(Rect2i(ox, oy, CHARACTER_PROBE.x, CHARACTER_PROBE.y)))
		probe_rows.append(cc.get_region(Rect2i(0, CHARACTER_PROBE.y / 2, CHARACTER_PROBE.x, 1)).get_data())
		probe_positions.append(at.x - floor(at.x))
		for y: int in range(0, cc.get_height(), 4):
			for x: int in range(cc.get_width()):
				char_colours[cc.get_pixel(x, y).to_html(false)] = true
		if i % 20 == 0 and strip_slot < 4:
			char_strip.blit_rect(cc, Rect2i(Vector2i.ZERO, cc.get_size()), Vector2i(0, strip_slot * CHARACTER_PROBE.y))
			strip_slot += 1
	var char_path: String = _out_dir.path_join("%s__character.png" % tag)
	char_strip.save_png(char_path)
	world.call("set_character_probe_mode", false)
	hud.visible = hud_was
	actor.visible = actor_was

	var translations: int = 0
	var shifts: Dictionary = {}
	if not probe_rows.is_empty():
		for i: int in range(probe_rows.size()):
			var shift: int = _translation_of(probe_rows[0], probe_rows[i])
			if shift != PROBE_NO_MATCH:
				translations += 1
				shifts[shift] = int(shifts.get(shift, 0)) + 1
	var pure_translation: bool = translations == probe_rows.size() and not probe_rows.is_empty()

	# --- frame-comparison shimmer metrics ---
	# THE SHIMMER VERDICT is the set of INTERIOR run lengths: the widths of the stripes
	# that lie wholly inside the probe, over all 60 frames. A pixel-perfect render draws
	# every one-world-pixel stripe exactly `scale` device pixels wide in every frame, so
	# that set holds exactly ONE value. More than one value IS the crawl.
	#
	# The first and last run of each row are clipped by the probe's own edges and are
	# dropped, because a truncated stripe is not a narrow one.
	var runs_seen: Dictionary = {}
	var interior_seen: Dictionary = {}
	var changes: int = 0
	for i: int in range(run_patterns.size()):
		var pattern: Array = run_patterns[i]
		for j: int in range(pattern.size()):
			runs_seen[int(pattern[j])] = int(runs_seen.get(int(pattern[j]), 0)) + 1
			if j > 0 and j < pattern.size() - 1:
				interior_seen[int(pattern[j])] = int(interior_seen.get(int(pattern[j]), 0)) + 1
		if i > 0 and str(run_patterns[i]) != str(run_patterns[i - 1]):
			changes += 1
	var run_values: Array = runs_seen.keys()
	run_values.sort()
	var interior: Array = interior_seen.keys()
	interior.sort()

	var body: float = float(P1AScale.measured_px_per_m(
		P1AArt.measure_character(String(density["derived_from"])))["body_h_mean"])
	var predicted: Dictionary = P1ARenderMode.describe(approach, actual, base, px_per_m, body, 1)
	var measured_scale: float = float(capture_size_seen.x) / float(base.x) \
		if approach == P1ARenderMode.Approach.PIXEL_SNAPPED_CANVAS else float(predicted["scale"])

	# The arithmetic must agree with the engine. This guard is here because it already
	# earned its place: the first `expand` model predicted a viewport the engine never
	# produced, and only comparing the two revealed it.
	var predicted_visible: Vector2i = Vector2i((predicted["visible_base_px"] as Array)[0],
		(predicted["visible_base_px"] as Array)[1])
	var engine_visible: Vector2i = capture_size_seen
	if bool(predicted["final_frame_presentation_scale"]) \
			or approach == P1ARenderMode.Approach.SUBVIEWPORT_REMAINDER:
		engine_visible = (_tool.find_child("BaseViewport", true, false) as SubViewport).size
	elif approach == P1ARenderMode.Approach.PIXEL_SNAPPED_CANVAS:
		engine_visible = Vector2i(int(round(float(actual.x) / maxf(0.0001, float(predicted["scale"])))),
			int(round(float(actual.y) / maxf(0.0001, float(predicted["scale"])))))
	var visible_agrees: bool = absi(predicted_visible.x - engine_visible.x) <= 1 \
		and absi(predicted_visible.y - engine_visible.y) <= 1
	if not visible_agrees:
		_failures.append("%s: arithmetic predicts a visible viewport of %s, the engine produced %s"
			% [tag, str(predicted_visible), str(engine_visible)])
	print("    visible viewport: arithmetic %s, engine %s -> %s" % [
		str(predicted_visible), str(engine_visible), "agree" if visible_agrees else "DISAGREE"])

	var row: Dictionary = {
		"approach": P1ARenderMode.APPROACH_IDS[approach],
		"approach_name": P1ARenderMode.approach_name(approach),
		"window_requested": [want_window.x, want_window.y],
		"window_actual": [actual.x, actual.y],
		"window_was_clamped": actual != want_window,
		"base": [base.x, base.y],
		"root_viewport_size": [root_size_seen.x, root_size_seen.y],
		"overview_reduced_by": overview_reduction,
		"captured_image_size": [capture_size_seen.x, capture_size_seen.y],
		"capture_was_upscaled_to_device": capture_size_seen != actual,
		"predicted": predicted,
		"engine_visible_viewport": [engine_visible.x, engine_visible.y],
		"arithmetic_agrees_with_engine": visible_agrees,
		"measured_scale_from_capture": measured_scale,
		"shimmer": {
			"frames_compared": CRAWL_FRAMES,
			"distinct_colours_in_probe": colours.size(),
			"stripe_run_lengths_seen_including_clipped_ends": run_values,
			"stripe_run_lengths_interior": interior,
			"uniform_stripe_width": interior.size() == 1,
			"shimmer_verdict": ("uniform — no crawl" if interior.size() == 1 else "UNEVEN — stripes crawl"),
			"probe_row_run_pattern_differed_from_previous_frame": changes,
			"probe_row_note": "counts frames whose probe-row RUN-LENGTH pattern differs from the previous frame's. A uniformly translated field keeps the same pattern, so a high count means the widths themselves are moving. Reported, not used as the verdict.",
		},
		"character_stability": {
			"frames_probed": probe_rows.size(),
			"probe_device_px": [CHARACTER_PROBE.x, CHARACTER_PROBE.y],
			"frames_that_are_a_pure_translation_of_frame_0": translations,
			"pure_translation": pure_translation,
			"distinct_whole_pixel_shifts_seen": shifts.keys(),
			"distinct_colours_in_probe": char_colours.size(),
			"frames_the_probe_could_not_cover": char_missing,
			"verdict": ("pure translation — the character never re-rasterises" if pure_translation
				else "%d of %d frames are NOT a whole-pixel translation of frame 0 — rows and columns pulse"
					% [probe_rows.size() - translations, probe_rows.size()]),
		},
		"evidence": {"stills": still_paths, "crawl": strip_path.get_file(), "character": char_path.get_file()},
	}
	(_tool.find_child("HUD", true, false) as CanvasLayer).visible = true
	_results.append(row)
	print("    root viewport %s, captured %s, upscaled to device: %s" % [
		str(root_size_seen), str(capture_size_seen), str(capture_size_seen != actual)])
	print("    scale %.4f  letterbox %s  visible %.2f x %.2f m  actor %.2f%% of height" % [
		float(predicted["scale"]), str(predicted["letterbox_total_px"]),
		float((predicted["visible_world_m"] as Array)[0]), float((predicted["visible_world_m"] as Array)[1]),
		float(predicted["actor_fraction_of_screen_height"]) * 100.0])
	print("    character probe: %d of %d frames are a pure whole-pixel translation of frame 0 -> %s   (%d colours)" % [
		translations, probe_rows.size(),
		"STABLE" if pure_translation else "RE-RASTERISES, rows and columns pulse", char_colours.size()])
	print("    shimmer probe: %d colour(s); interior stripe widths %s -> %s; probe row differed in %d of %d frames" % [
		colours.size(), str(interior),
		("uniform, no crawl" if interior.size() == 1 else "UNEVEN, stripes crawl"), changes, CRAWL_FRAMES])
	if colours.size() > 2:
		_failures.append("%s: the one-pixel stripe probe produced %d colours; nearest filtering yields exactly 2"
			% [tag, colours.size()])


## The whole-pixel shift that turns `reference` into `row`, or `PROBE_NO_MATCH`.
##
## Both are one device-pixel row of RGBA bytes. A shift is accepted only on an EXACT
## byte match over the overlapping core, so "translated" here means translated, not
## approximately translated.
func _translation_of(reference: PackedByteArray, row: PackedByteArray) -> int:
	if reference.size() != row.size() or reference.is_empty():
		return PROBE_NO_MATCH
	var px: int = reference.size() / 4
	for shift: int in range(-PROBE_SHIFT_RANGE, PROBE_SHIFT_RANGE + 1):
		var lo: int = maxi(0, shift) + PROBE_SHIFT_RANGE
		var hi: int = px + mini(0, shift) - PROBE_SHIFT_RANGE
		if hi - lo < px / 2:
			continue
		if row.slice(lo * 4, hi * 4) == reference.slice((lo - shift) * 4, (hi - shift) * 4):
			return shift
	return PROBE_NO_MATCH


## A copy in RGBA8, so a viewport that hands back another format cannot break a blit.
func _rgba(img: Image) -> Image:
	var copy: Image = Image.create_from_data(img.get_width(), img.get_height(),
		false, img.get_format(), img.get_data())
	if copy.get_format() != Image.FORMAT_RGBA8:
		copy.convert(Image.FORMAT_RGBA8)
	return copy


## A crop of the true device pixels around the centre of the frame, never resampled.
func _centre_crop(img: Image, size: Vector2i) -> Image:
	var w: int = mini(size.x, img.get_width())
	var h: int = mini(size.y, img.get_height())
	var x: int = maxi(0, (img.get_width() - w) / 2)
	var y: int = maxi(0, (img.get_height() - h) / 2)
	return _rgba(img.get_region(Rect2i(x, y, w, h)))


func _grab() -> Image:
	await RenderingServer.frame_post_draw
	return root.get_texture().get_image()


## Model what the compositor puts on the glass.
##
## With `viewport` stretch the root viewport renders at the BASE resolution and the
## window blit is an exact nearest upscale by a whole number, centred, with black bars
## around it. Reproducing that here is arithmetic, not approximation: a nearest upscale
## by an integer is precisely what the blit does, so the probe below measures DEVICE
## pixels rather than base pixels. Without this the integer approach would be measured
## on an image nobody ever sees, and it would look perfect for the wrong reason.
func _to_device(img: Image, window: Vector2i) -> Image:
	if img.get_size() == window:
		return img
	if img.get_width() <= 0 or img.get_height() <= 0:
		return img
	var factor: int = maxi(1, mini(window.x / img.get_width(), window.y / img.get_height()))
	var scaled: Image = _rgba(img)
	if factor > 1:
		scaled.resize(img.get_width() * factor, img.get_height() * factor, Image.INTERPOLATE_NEAREST)
	var out: Image = Image.create(window.x, window.y, false, Image.FORMAT_RGBA8)
	out.fill(Color.BLACK)
	var at: Vector2i = ((window - scaled.get_size()) / 2).max(Vector2i.ZERO)
	var src: Rect2i = Rect2i(Vector2i.ZERO, scaled.get_size().min(window))
	out.blit_rect(scaled, src, at)
	return out


## The run lengths of constant colour along one row.
func _run_lengths(img: Image, y: int) -> Array:
	var out: Array = []
	if img.get_height() <= y:
		return out
	var run: int = 1
	for x: int in range(1, img.get_width()):
		if img.get_pixel(x, y) == img.get_pixel(x - 1, y):
			run += 1
		else:
			out.append(run)
			run = 1
	out.append(run)
	return out
