class_name P1AWorld
extends Node2D

## P1A — the minimal diagnostic background.
##
## Flat colours, a metre grid, a metre ruler, two one-pixel stripe fields for the
## shimmer measurement, and one outline of the PROPOSED isometric tile. That is the
## whole vocabulary. **This is not a tileset, not environment art and not a P1B kit**,
## and nothing here may become one.

const BACKGROUND: Color = Color(0.106, 0.110, 0.137)
const GRID_MINOR: Color = Color(0.239, 0.251, 0.318)
const GRID_MAJOR: Color = Color(0.396, 0.404, 0.529)
const AXIS: Color = Color(0.541, 0.478, 0.816)
const STRIPE_A: Color = Color(1, 1, 1)
const STRIPE_B: Color = Color(0.043, 0.043, 0.063)
const RULER: Color = Color(0.945, 0.769, 0.298)
const TILE_OUTLINE: Color = Color(0.310, 0.831, 0.616)

const MAJOR_EVERY_M: int = 5

## The stripe field is one WORLD pixel per stripe. It is the shimmer probe: under a
## pixel-perfect setup every stripe is exactly `scale` device pixels wide in every frame
## of the pan, and no third colour ever appears between them. It fills the whole area
## and is drawn ONLY in `shimmer_field` mode, so it never sits on top of a still that
## exists to show layout and framing.

## When true the whole diagnostic area is filled with one-world-pixel vertical stripes.
## That is the shimmer probe at its strongest, and it is what the evidence capture uses;
## the ordinary display mode keeps the grid legible instead.
var shimmer_field: bool = false

## When true the diagnostic world draws its flat background and NOTHING else.
##
## The character-stability probe needs it. The metre grid is fine, but the ruler labels
## and the tile caption are drawn with `draw_string`, which anti-aliases: a probe that
## clipped a glyph would report hundreds of colours and blame the renderer for text.
var character_probe_mode: bool = false

var px_per_m: float = 32.0
var tile_size: Vector2 = Vector2(64, 32)
var world_extent_m: float = 400.0

var _vertical_stripes: ImageTexture
var _horizontal_stripes: ImageTexture
var _font: Font


func _ready() -> void:
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED
	z_index = -100
	_vertical_stripes = _make_stripe_texture(true)
	_horizontal_stripes = _make_stripe_texture(false)
	_font = ThemeDB.fallback_font


func configure(new_px_per_m: float, new_tile_size: Vector2) -> void:
	px_per_m = new_px_per_m
	tile_size = new_tile_size
	queue_redraw()


func set_shimmer_field(enabled: bool) -> void:
	shimmer_field = enabled
	queue_redraw()


func set_character_probe_mode(enabled: bool) -> void:
	character_probe_mode = enabled
	queue_redraw()


static func _make_stripe_texture(vertical: bool) -> ImageTexture:
	var img: Image = Image.create(2, 2, false, Image.FORMAT_RGBA8)
	for y: int in range(2):
		for x: int in range(2):
			var on: bool = (x == 0) if vertical else (y == 0)
			img.set_pixel(x, y, STRIPE_A if on else STRIPE_B)
	return ImageTexture.create_from_image(img)


func _draw() -> void:
	var half: float = world_extent_m * px_per_m * 0.5
	draw_rect(Rect2(-half, -half, half * 2.0, half * 2.0), BACKGROUND, true)

	if character_probe_mode:
		return

	if shimmer_field:
		# The whole area, one world pixel per stripe. Vertical stripes in the upper half
		# and horizontal in the lower, so one captured frame probes both axes at once.
		draw_texture_rect(_vertical_stripes, Rect2(-half, -half, half * 2.0, half), true)
		draw_texture_rect(_horizontal_stripes, Rect2(-half, 0.0, half * 2.0, half), true)
		return

	# Metre grid, drawn only across the diagnostic area.
	var span_m: int = int(world_extent_m * 0.5)
	for i: int in range(-span_m, span_m + 1):
		var p: float = float(i) * px_per_m
		var is_major: bool = i % MAJOR_EVERY_M == 0
		var col: Color = GRID_MAJOR if is_major else GRID_MINOR
		if i == 0:
			col = AXIS
		var wdt: float = 1.0 if not is_major else 1.0
		draw_line(Vector2(p, -half), Vector2(p, half), col, wdt)
		draw_line(Vector2(-half, p), Vector2(half, p), col, wdt)

	# A metre ruler along the x axis: a tick every metre, a longer tick every five.
	for i: int in range(-span_m, span_m + 1):
		var p2: float = float(i) * px_per_m
		var h: float = (px_per_m * 0.5) if i % MAJOR_EVERY_M == 0 else (px_per_m * 0.25)
		draw_line(Vector2(p2, 0.0), Vector2(p2, -h), RULER, 1.0)
	draw_line(Vector2(-half, 0.0), Vector2(half, 0.0), RULER, 1.0)

	# The PROPOSED isometric tile, drawn once at the origin so the owner can see what
	# `tile_size` means beside the character. A proposal for P1B — not a tileset.
	var hw: float = tile_size.x * 0.5
	var hh: float = tile_size.y * 0.5
	draw_polyline(PackedVector2Array([
		Vector2(0, -hh), Vector2(hw, 0), Vector2(0, hh), Vector2(-hw, 0), Vector2(0, -hh),
	]), TILE_OUTLINE, 1.0)
	if _font != null:
		draw_string(_font, Vector2(hw + 4.0, -2.0),
			"proposed tile %d x %d px = 1 m² ground" % [int(tile_size.x), int(tile_size.y)],
			HORIZONTAL_ALIGNMENT_LEFT, -1.0, 10, TILE_OUTLINE)
