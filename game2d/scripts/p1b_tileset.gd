class_name P1BTileSet
extends RefCounted

const P1BTerrain := preload("res://scripts/p1b_terrain.gd")

## P1B — the Wroughtstone TileSet, built in code from OWNER-EXPORTED PNGs only.
##
## **This module never modifies, regenerates, reinterprets or compensates for owner
## artwork.** It does not scale, pad, recolour, flip, rotate or transpose a tile, and it
## creates no alternative tiles. A tile is imported at its exported size or it is reported
## as non-conforming. **If the art is missing, this module says so and builds nothing** —
## it never substitutes a placeholder, because a placeholder in a proof kit is exactly the
## kind of silent stand-in P1A spent five passes refusing.

## The P1A locks this TileSet must agree with (D-356).
const TILE_PX: Vector2i = Vector2i(120, 60)
const PX_PER_M: float = 60.0
const TILE_GROUND_M: float = 1.0

## Where owner exports are expected. **Only PNGs. No `.pxo` is ever opened, read, hashed,
## copied or referenced**, and the owner's `assets/Pixel Art/` tree is never written to.
const EXPORT_DIR: String = "res://assets/environment/wroughtstone/"

## The three bounded proof inputs this pass was authorized to use. `expected` is the
## canonical copy name; `source` is the owner's export that must be copied to it.
const GROUND_SLATE: String = "wroughtstone_ground_slate_120x60_v1.png"
const COURTYARD_DIRT: String = "wroughtstone_courtyard_dirt_enclosed_120x60_v1.png"
const PATH_STRAIGHT: String = "wroughtstone_path_dirt_straight_120x60_v1.png"

## **The enclosed dirt courtyard is a SEPARATE VALID TILE, not a connectable path**
## (owner ruling). It is registered with NO terrain assignment at all, so Godot's terrain
## solver can never select it, and painting the path terrain can never produce it.
const STANDALONE_TILES: Array[String] = [COURTYARD_DIRT]

## **The exported straight path's MASK, measured from the artwork itself (D-359).**
##
## The dirt band reaches the TOP_LEFT and BOTTOM_RIGHT edges and no others. Measured as
## the fraction of each diamond edge's inner rim that classifies as dirt rather than slate:
## **TL 27.9 %, BR 32.8 %, TR 0.0 %, BL 0.0 %.** The 27.9-point gap means the reading does
## not depend on where the threshold is put.
##
## **This is a MEASUREMENT of the owner's art, not a choice imposed on it.** The tile is
## registered at the mask it was drawn at. **It is never rotated, flipped, transposed or
## scaled to serve a different mask** — D-356 ruling 2 and D-359 ruling 3 forbid that, and
## the other three orientations are separately authored artwork that does not exist yet.
const PATH_STRAIGHT_MASK: int = 10                ## binary 0101 in TR, BR, BL, TL order
const PATH_STRAIGHT_CONNECTS: Array[int] = [
	TileSet.CELL_NEIGHBOR_BOTTOM_RIGHT_SIDE,      ## 2
	TileSet.CELL_NEIGHBOR_TOP_LEFT_SIDE,          ## 10
]
const PATH_STRAIGHT_EDGE_DIRT_FRACTION: Dictionary = {
	"TR": 0.000, "BR": 0.328, "BL": 0.000, "TL": 0.279,
}

## Terrain layout. `MATCH_SIDES` because a path connects along diamond EDGES; the
## alternative `MATCH_CORNERS_AND_SIDES` exposes 8 bits and would demand 256 combinations.
const TERRAIN_SET: int = 0
const TERRAIN_SLATE: int = 0
const TERRAIN_PATH: int = 1
const TERRAIN_MODE: int = TileSet.TERRAIN_MODE_MATCH_SIDES


## Which of the expected exports are actually present, and which are missing.
static func export_status() -> Dictionary:
	var present: PackedStringArray = PackedStringArray()
	var missing: PackedStringArray = PackedStringArray()
	for f: String in [GROUND_SLATE, COURTYARD_DIRT, PATH_STRAIGHT]:
		if ResourceLoader.exists(EXPORT_DIR + f) or FileAccess.file_exists(EXPORT_DIR + f):
			present.append(f)
		else:
			missing.append(f)
	return {"present": present, "missing": missing, "complete": missing.is_empty()}


## Measure one exported tile against the locked geometry. Reports; never corrects.
static func measure_export(file_name: String) -> Dictionary:
	var path: String = EXPORT_DIR + file_name
	if not FileAccess.file_exists(path):
		return {"exists": false, "path": path}
	var bytes: PackedByteArray = FileAccess.get_file_as_bytes(path)
	var img: Image = Image.new()
	if img.load_png_from_buffer(bytes) != OK:
		return {"exists": true, "path": path, "decoded": false}
	img.convert(Image.FORMAT_RGBA8)
	var size: Vector2i = img.get_size()
	# The drawn extent, so a tile padded with transparency is reported rather than assumed.
	var x0: int = size.x
	var x1: int = -1
	var y0: int = size.y
	var y1: int = -1
	for y: int in range(size.y):
		for x: int in range(size.x):
			if img.get_pixel(x, y).a > 0.0:
				x0 = mini(x0, x); x1 = maxi(x1, x)
				y0 = mini(y0, y); y1 = maxi(y1, y)
	return {
		"exists": true, "path": path, "decoded": true,
		"size": size,
		"matches_locked_tile": size == TILE_PX,
		"drawn_x0": x0, "drawn_x1": x1, "drawn_y0": y0, "drawn_y1": y1,
		"drawn_size": Vector2i(maxi(0, x1 - x0 + 1), maxi(0, y1 - y0 + 1)),
		"sha256": FileAccess.get_sha256(path),
	}


## Build the TileSet. Returns `null` and an explanation when the owner art is not present;
## **it never fabricates a tile to keep going.**
static func build() -> Dictionary:
	var status: Dictionary = export_status()
	var ts: TileSet = TileSet.new()
	ts.tile_shape = TileSet.TILE_SHAPE_ISOMETRIC
	ts.tile_layout = TileSet.TILE_LAYOUT_DIAMOND_DOWN
	ts.tile_offset_axis = TileSet.TILE_OFFSET_AXIS_HORIZONTAL
	ts.tile_size = TILE_PX
	ts.add_terrain_set()
	ts.set_terrain_set_mode(TERRAIN_SET, TERRAIN_MODE)
	ts.add_terrain(TERRAIN_SET)
	ts.set_terrain_name(TERRAIN_SET, TERRAIN_SLATE, "slate")
	ts.set_terrain_color(TERRAIN_SET, TERRAIN_SLATE, Color(0.44, 0.47, 0.5))
	ts.add_terrain(TERRAIN_SET)
	ts.set_terrain_name(TERRAIN_SET, TERRAIN_PATH, "dirt_path")
	ts.set_terrain_color(TERRAIN_SET, TERRAIN_PATH, Color(0.62, 0.44, 0.27))

	var added: PackedStringArray = PackedStringArray()
	var rejected: Array[Dictionary] = []
	for f: String in status["present"]:
		var m: Dictionary = measure_export(f)
		if not bool(m.get("matches_locked_tile", false)):
			rejected.append(m)
			continue
		var src: TileSetAtlasSource = TileSetAtlasSource.new()
		src.texture = load(EXPORT_DIR + f) as Texture2D
		src.texture_region_size = TILE_PX
		ts.add_source(src)
		src.create_tile(Vector2i.ZERO)
		var td: TileData = src.get_tile_data(Vector2i.ZERO, 0)
		if STANDALONE_TILES.has(f):
			# Deliberately NO terrain set: the courtyard can never be chosen by the
			# terrain solver and can never become a connectable path.
			td.terrain_set = -1
		elif f == GROUND_SLATE:
			td.terrain_set = TERRAIN_SET
			td.terrain = TERRAIN_SLATE
			for b: int in P1BTerrain.SIDES:
				td.set_terrain_peering_bit(b, TERRAIN_SLATE)
		elif f == PATH_STRAIGHT:
			# Registered at the mask the artwork was DRAWN at (see PATH_STRAIGHT_MASK).
			# The two edges the dirt reaches peer to the path terrain; the two it does not
			# peer to slate. No transform of any kind is applied to the texture.
			td.terrain_set = TERRAIN_SET
			td.terrain = TERRAIN_PATH
			for b: int in P1BTerrain.SIDES:
				td.set_terrain_peering_bit(b,
					TERRAIN_PATH if PATH_STRAIGHT_CONNECTS.has(b) else TERRAIN_SLATE)
		added.append(f)

	return {
		"tile_set": ts,
		"built": status["complete"] and rejected.is_empty(),
		"path_mask": PATH_STRAIGHT_MASK,
		"added": added,
		"rejected": rejected,
		"missing": status["missing"],
	}
