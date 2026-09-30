class_name P1BTerrain
extends RefCounted

## P1B — the isometric terrain-connectivity model, MEASURED from Godot 4.7.2 rather than
## assumed from theory.
##
## The owner's instruction was explicit: **do not infer that all fifteen theoretical
## four-edge combinations are required without proving it in the actual TileSet
## configuration.** Everything in this file was measured with
## `TileData.is_valid_terrain_peering_bit()` on a real 120 x 60 isometric `TileSet` with a
## real atlas tile, and with `TileMapLayer.get_neighbor_cell()` for the screen directions.
##
## **THE HEADLINE FINDING: Godot does NOT require a complete combination set.** Painting an
## L-shaped run through `set_cells_terrain_connect()` with only 2 of 16 tiles present filled
## **5 of 5 cells**, left **no** cell empty and raised **no** engine error. Godot scores the
## available tiles and picks the best match. A missing combination is therefore a **visual**
## defect, never an engine failure — which means the remaining art is a quality decision the
## owner makes, not a blocker the engine imposes.

## The ONLY peering bits Godot accepts for an isometric tile in `MATCH_SIDES`.
## Measured; identical for both `TILE_OFFSET_AXIS_HORIZONTAL` and `..._VERTICAL`.
const SIDE_TOP_RIGHT: int = TileSet.CELL_NEIGHBOR_TOP_RIGHT_SIDE        ## 14
const SIDE_BOTTOM_RIGHT: int = TileSet.CELL_NEIGHBOR_BOTTOM_RIGHT_SIDE  ## 2
const SIDE_BOTTOM_LEFT: int = TileSet.CELL_NEIGHBOR_BOTTOM_LEFT_SIDE    ## 6
const SIDE_TOP_LEFT: int = TileSet.CELL_NEIGHBOR_TOP_LEFT_SIDE          ## 10

## In this order, so a 4-bit mask reads clockwise from the upper-right edge.
const SIDES: Array[int] = [SIDE_TOP_RIGHT, SIDE_BOTTOM_RIGHT, SIDE_BOTTOM_LEFT, SIDE_TOP_LEFT]
const SIDE_NAMES: Array[String] = ["TOP_RIGHT", "BOTTOM_RIGHT", "BOTTOM_LEFT", "TOP_LEFT"]
const SIDE_SHORT: Array[String] = ["TR", "BR", "BL", "TL"]

## Where each side's neighbour actually sits, MEASURED via `get_neighbor_cell()` on a
## 120 x 60 `TILE_LAYOUT_DIAMOND_DOWN` lattice. The screen offsets are exactly half the
## tile in each axis, which is what a clean 2:1 diamond lattice must produce.
const SIDE_CELL_DELTA: Array[Vector2i] = [
	Vector2i(0, -1),  ## TOP_RIGHT
	Vector2i(1, 0),   ## BOTTOM_RIGHT
	Vector2i(0, 1),   ## BOTTOM_LEFT
	Vector2i(-1, 0),  ## TOP_LEFT
]
const SIDE_SCREEN_DELTA: Array[Vector2] = [
	Vector2(60.0, -30.0),   ## TOP_RIGHT    up-right
	Vector2(60.0, 30.0),    ## BOTTOM_RIGHT down-right
	Vector2(-60.0, 30.0),   ## BOTTOM_LEFT  down-left
	Vector2(-60.0, -30.0),  ## TOP_LEFT     up-left
]

## How many peering bits each terrain mode exposes on an isometric tile. MEASURED.
## `MATCH_CORNERS_AND_SIDES` would demand 2^8 = 256 combinations, which is why a path
## terrain uses `MATCH_SIDES`: a path connects along EDGES, not through diamond points.
const VALID_BITS_MATCH_SIDES: int = 4
const VALID_BITS_MATCH_CORNERS: int = 4
const VALID_BITS_MATCH_CORNERS_AND_SIDES: int = 8
const COMBINATIONS_MATCH_SIDES: int = 16    ## 2^4, INCLUDING the no-connection case
const COMBINATIONS_MATCH_CORNERS_AND_SIDES: int = 256

## The shape classes of the 16 masks. This is the inventory the owner asked for: it is the
## VISUAL completeness target, and **not** an engine requirement.
enum Shape { ISOLATED, STUB, STRAIGHT, ELBOW, TEE, CROSS }
const SHAPE_NAMES: Array[String] = ["isolated", "stub", "straight", "elbow", "tee", "cross"]


## The 4-bit mask of one tile, as a clockwise-from-upper-right bit string.
static func mask_label(mask: int) -> String:
	var parts: PackedStringArray = PackedStringArray()
	for i: int in range(4):
		if mask & (1 << i):
			parts.append(SIDE_SHORT[i])
	return "-".join(parts) if parts.size() > 0 else "none"


## Which shape class a mask belongs to, derived from the mask itself.
static func shape_of(mask: int) -> Shape:
	var n: int = 0
	for i: int in range(4):
		if mask & (1 << i):
			n += 1
	match n:
		0:
			return Shape.ISOLATED
		1:
			return Shape.STUB
		3:
			return Shape.TEE
		4:
			return Shape.CROSS
		_:
			# Two bits: opposite sides are a straight, adjacent sides are an elbow.
			# In clockwise order, opposite means the bits are two apart.
			var set_bits: Array[int] = []
			for i: int in range(4):
				if mask & (1 << i):
					set_bits.append(i)
			return Shape.STRAIGHT if absi(set_bits[0] - set_bits[1]) == 2 else Shape.ELBOW


## The full inventory: every mask, its label, its shape class and its peering bits.
static func inventory() -> Array[Dictionary]:
	var out: Array[Dictionary] = []
	for mask: int in range(16):
		var bits: Array[int] = []
		for i: int in range(4):
			if mask & (1 << i):
				bits.append(SIDES[i])
		out.append({
			"mask": mask,
			"label": mask_label(mask),
			"shape": shape_of(mask),
			"shape_name": SHAPE_NAMES[shape_of(mask)],
			"connections": bits.size(),
			"peering_bits": bits,
		})
	return out


## How many masks fall in each shape class. 1 + 4 + 2 + 4 + 4 + 1 = 16.
static func shape_counts() -> Dictionary:
	var counts: Dictionary = {}
	for name: String in SHAPE_NAMES:
		counts[name] = 0
	for row: Dictionary in inventory():
		counts[row["shape_name"]] = int(counts[row["shape_name"]]) + 1
	return counts
