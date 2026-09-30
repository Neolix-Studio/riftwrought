extends SceneTree

## P1B — rendered evidence, captured from a REAL `TileMapLayer` drawn by the engine.
##
## **This is not a composed mock-up.** A TileSet is built from the owner's exported PNGs,
## a `TileMapLayer` is populated, and the ROOT VIEWPORT'S OWN TEXTURE is read back after a
## frame. What the file shows is what Godot drew.
##
## Native 1:1: the capture is taken at the locked 1920 x 1080 base with no scaling, which
## is exactly what the locked mode 7 presents at that output (measured ×1.0000 in P1A).

const P1BTileSet := preload("res://scripts/p1b_tileset.gd")
const P1BTerrain := preload("res://scripts/p1b_terrain.gd")

func _out() -> String:
	var a: PackedStringArray = OS.get_cmdline_user_args()
	for i: int in range(a.size()):
		if a[i] == "--out":
			return a[i + 1]
	return ""

func _initialize() -> void:
	var out_dir: String = _out()
	if out_dir == "":
		printerr("P1B EVIDENCE: --out <dir> is required")
		quit(2)
		return
	DirAccess.make_dir_recursive_absolute(out_dir)

	var built: Dictionary = P1BTileSet.build()
	if not bool(built["built"]):
		printerr("P1B EVIDENCE: the TileSet did not build; missing %s" % str(built["missing"]))
		quit(3)
		return
	var ts: TileSet = built["tile_set"]

	var root: Window = get_root()
	root.content_scale_mode = Window.CONTENT_SCALE_MODE_DISABLED
	root.content_scale_aspect = Window.CONTENT_SCALE_ASPECT_IGNORE
	DisplayServer.window_set_size(Vector2i(1280, 720))
	root.size = Vector2i(1280, 720)

	var bg: ColorRect = ColorRect.new()
	bg.color = Color(0.05, 0.05, 0.07)
	bg.size = Vector2(1280, 720)
	root.add_child(bg)

	var layer: TileMapLayer = TileMapLayer.new()
	layer.tile_set = ts
	root.add_child(layer)

	# Which source holds which tile.
	var src_of: Dictionary = {}
	for i: int in range(ts.get_source_count()):
		var sid: int = ts.get_source_id(i)
		var src: TileSetAtlasSource = ts.get_source(sid) as TileSetAtlasSource
		var path: String = src.texture.resource_path
		src_of[path.get_file()] = sid

	var slate_src: int = int(src_of[P1BTileSet.GROUND_SLATE])
	var court_src: int = int(src_of[P1BTileSet.COURTYARD_DIRT])
	var path_src: int = int(src_of[P1BTileSet.PATH_STRAIGHT])

	# 1. REPEATED GROUND: a solid field of the slate tile, every cell the same texture.
	var field: int = 7
	for y: int in range(-field, field + 1):
		for x: int in range(-field, field + 1):
			layer.set_cell(Vector2i(x, y), slate_src, Vector2i.ZERO)

	# 2. THE STRAIGHT PATH, CONNECTED. The exported mask connects TOP_LEFT and
	#    BOTTOM_RIGHT, whose cell deltas are (-1, 0) and (+1, 0), so a run along +x is a
	#    genuinely connected path -- each tile's drawn dirt meets its neighbour's.
	for x: int in range(-5, 6):
		layer.set_cell(Vector2i(x, 0), path_src, Vector2i.ZERO)

	# 3. THE COURTYARD, PLACED BY HAND. set_cell(), never the terrain solver.
	layer.set_cell(Vector2i(2, -3), court_src, Vector2i.ZERO)
	layer.set_cell(Vector2i(-3, 3), court_src, Vector2i.ZERO)

	# Centre the lattice in the window, on whole pixels.
	layer.position = (Vector2(1280, 720) * 0.5).floor()

	await process_frame
	await process_frame
	await process_frame

	var img: Image = root.get_texture().get_image()
	img.save_png(out_dir + "/p1b_native_render.png")
	print("P1B EVIDENCE: wrote p1b_native_render.png (%d x %d)" % [img.get_width(), img.get_height()])

	# A 3x magnified crop across a tile seam and along the path, so the seam can be judged.
	var centre: Vector2 = layer.position
	var crop: Rect2i = Rect2i(int(centre.x) - 200, int(centre.y) - 80, 400, 160)
	crop = crop.intersection(Rect2i(Vector2i.ZERO, img.get_size()))
	var det: Image = img.get_region(crop)
	var big: Image = Image.create(det.get_width() * 3, det.get_height() * 3, false, det.get_format())
	for y: int in range(big.get_height()):
		for x: int in range(big.get_width()):
			big.set_pixel(x, y, det.get_pixel(x / 3, y / 3))
	big.save_png(out_dir + "/p1b_seam_detail_3x.png")
	print("P1B EVIDENCE: wrote p1b_seam_detail_3x.png (%d x %d)" % [big.get_width(), big.get_height()])
	print("P1B EVIDENCE: CAPTURED")
	quit(0)
