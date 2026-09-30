extends SceneTree

## P1B — renders the terrain-connectivity mask inventory the owner asked for, as a listed
## table and as a visual sheet of 16 diamonds with their connections drawn.
##
## **The diagrams are EVIDENCE, not game art.** They are flat vector-drawn diamonds with
## connection stubs, produced to specify what art is needed. Nothing here is a tile, a
## placeholder, or anything that could be mistaken for production work.

const P1BTerrain := preload("res://scripts/p1b_terrain.gd")

const W: int = 120
const H: int = 60
const CELL_W: int = 300
const CELL_H: int = 230
const COLS: int = 4

func _out_path() -> String:
	for i: int in range(OS.get_cmdline_user_args().size()):
		if OS.get_cmdline_user_args()[i] == "--out":
			return OS.get_cmdline_user_args()[i + 1]
	return ""

func _diamond(mask: int) -> Image:
	var img: Image = Image.create(CELL_W, CELL_H, false, Image.FORMAT_RGBA8)
	img.fill(Color(0.09, 0.09, 0.11, 1.0))
	var cx: float = CELL_W * 0.5
	var cy: float = CELL_H * 0.56
	var hw: float = W * 1.0        # half-width of the drawn diamond (tile is 120 wide)
	var hh: float = H * 1.0        # half-height (tile is 60 tall) -> drawn at 2x for clarity
	# The four diamond points, in screen space.
	var right: Vector2 = Vector2(cx + hw, cy)
	var bottom: Vector2 = Vector2(cx, cy + hh)
	var left: Vector2 = Vector2(cx - hw, cy)
	var top: Vector2 = Vector2(cx, cy - hh)
	# Fill the diamond with slate, then draw each connected edge's stub in path colour.
	for y: int in range(CELL_H):
		for x: int in range(CELL_W):
			var dx: float = absf(x - cx) / hw
			var dy: float = absf(y - cy) / hh
			if dx + dy <= 1.0:
				img.set_pixel(x, y, Color(0.32, 0.34, 0.37, 1.0))
	# Edge midpoints, in the TR, BR, BL, TL order the mask uses.
	var mids: Array[Vector2] = [
		(top + right) * 0.5,      # TOP_RIGHT edge
		(right + bottom) * 0.5,   # BOTTOM_RIGHT edge
		(bottom + left) * 0.5,    # BOTTOM_LEFT edge
		(left + top) * 0.5,       # TOP_LEFT edge
	]
	var centre: Vector2 = Vector2(cx, cy)
	for i: int in range(4):
		if not (mask & (1 << i)):
			continue
		# A thick dirt stub from the diamond centre out through that edge midpoint.
		var steps: int = 260
		for s: int in range(steps + 1):
			var t: float = float(s) / float(steps)
			var p: Vector2 = centre.lerp(mids[i], t)
			for oy: int in range(-7, 8):
				for ox: int in range(-7, 8):
					var px: int = int(p.x) + ox
					var py: int = int(p.y) + oy
					if px < 0 or py < 0 or px >= CELL_W or py >= CELL_H:
						continue
					if ox * ox + oy * oy > 49:
						continue
					var ddx: float = absf(px - cx) / hw
					var ddy: float = absf(py - cy) / hh
					if ddx + ddy <= 1.02:
						img.set_pixel(px, py, Color(0.62, 0.44, 0.27, 1.0))
	# Outline the diamond so the shape reads.
	for s: int in range(1400):
		var t: float = float(s) / 1400.0 * 4.0
		var seg: int = int(t)
		var f: float = t - float(seg)
		var pts: Array[Vector2] = [top, right, bottom, left, top]
		var p: Vector2 = pts[seg].lerp(pts[seg + 1], f)
		for oy: int in range(-1, 2):
			for ox: int in range(-1, 2):
				var px: int = int(p.x) + ox
				var py: int = int(p.y) + oy
				if px >= 0 and py >= 0 and px < CELL_W and py < CELL_H:
					img.set_pixel(px, py, Color(0.85, 0.87, 0.9, 1.0))
	return img

func _init() -> void:
	var inv: Array[Dictionary] = P1BTerrain.inventory()
	print("P1B — TERRAIN-CONNECTIVITY MASK INVENTORY (measured, not inferred)")
	print("")
	print("Isometric 120 x 60, TERRAIN_MODE_MATCH_SIDES, %d valid peering bits -> %d masks."
		% [P1BTerrain.VALID_BITS_MATCH_SIDES, P1BTerrain.COMBINATIONS_MATCH_SIDES])
	print("")
	print("  %-5s %-6s %-18s %-10s %-4s %s" % ["mask", "bin", "connects", "shape", "n", "peering bits"])
	for row: Dictionary in inv:
		var m: int = int(row["mask"])
		var bin: String = ""
		for i: int in range(4):
			bin = ("1" if m & (1 << (3 - i)) else "0") + bin
		bin = ""
		for i: int in range(3, -1, -1):
			bin += ("1" if m & (1 << i) else "0")
		var bits: PackedStringArray = PackedStringArray()
		for b: int in (row["peering_bits"] as Array):
			bits.append(str(b))
		print("  %-5d %-6s %-18s %-10s %-4d %s" % [
			m, bin, row["label"], row["shape_name"], int(row["connections"]),
			", ".join(bits) if bits.size() > 0 else "-"])
	print("")
	var counts: Dictionary = P1BTerrain.shape_counts()
	var parts: PackedStringArray = PackedStringArray()
	for k: String in P1BTerrain.SHAPE_NAMES:
		parts.append("%s %d" % [k, int(counts[k])])
	print("  shape classes: %s   (total %d)" % [", ".join(parts), inv.size()])

	var out: String = _out_path()
	if out == "":
		print("")
		print("  (no --out given; the visual sheet was not written)")
		quit(0)
		return
	# Compose the sheet.
	var rows: int = int(ceil(float(inv.size()) / float(COLS)))
	var sheet: Image = Image.create(COLS * CELL_W, rows * CELL_H, false, Image.FORMAT_RGBA8)
	sheet.fill(Color(0.06, 0.06, 0.08, 1.0))
	for i: int in range(inv.size()):
		var cell: Image = _diamond(int(inv[i]["mask"]))
		var ox: int = (i % COLS) * CELL_W
		var oy: int = int(i / COLS) * CELL_H
		sheet.blit_rect(cell, Rect2i(Vector2i.ZERO, Vector2i(CELL_W, CELL_H)), Vector2i(ox, oy))
	sheet.save_png(out)
	print("")
	print("  wrote %s (%d x %d)" % [out, sheet.get_width(), sheet.get_height()])
	quit(0)
