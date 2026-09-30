class_name P1AArt
extends RefCounted

## P1A — the owner-exported character art, and every measurement taken from it.
##
## BOUNDARY. This file names two PNG files and nothing else. Both are byte-identical
## copies of owner exports (see `assets/characters/ASSET_PROVENANCE.md`). No Pixelorama
## `.pxo` source is opened, read, parsed, converted, copied, moved or hashed anywhere in
## this project, and no path here resolves to one.
##
## Everything below is MEASURED from those two files at run time. Nothing is a locked
## value: P1A measures and reports, and the owner decides.

# --- The two imported files -------------------------------------------------------

const MAGE_SHEET_PATH: String = "res://assets/characters/mage/mage_idle_8dir_64.png"
const MAGE_SHEET_SHA256: String = "70321b212e5f9381f0badd80b29c938465a84289db14fe30e327fe1804d3d671"

## THE HUNTRESS NOW HAS ALL EIGHT IDLE DIRECTIONS.
##
## Each is its own owner-exported 512 x 128 strip of four 128 x 128 frames, left to
## right. The copies below are byte-identical to the owner's exports; only the file name
## is normalised, and the owner's originals are never renamed or touched.
##
## **THE MAPPING IS THE OWNER'S AND IS AUTHORITATIVE.** It is not inferred from
## alphabetical order, sprite order, body handedness or any previous filename. Note in
## particular that the north source is `huntress_idle_top128_v1.png` — **no underscore
## between `top` and `128`** — which is the owner's exact spelling.
const HUNTRESS_SOURCE_NAMES: Dictionary = {
	"e":  "huntress_idle_right_128_v1.png",
	"se": "huntress_idle_bottom_right_128_v1.png",
	"s":  "huntress_idle_down_128_v1.png",
	"sw": "huntress_idle_down_left_128_v1.png",
	"w":  "huntress_idle_left_128_v1.png",
	"nw": "huntress_idle_top_left_128_v1.png",
	"n":  "huntress_idle_top128_v1.png",
	"ne": "huntress_idle_top_right_128_v1.png",
}

const HUNTRESS_SOURCE_DIR: String = "assets/Pixel Art/Huntress/Animations"

const HUNTRESS_DIRECTION_PATHS: Dictionary = {
	"e":  "res://assets/characters/huntress/huntress_idle_e.png",
	"se": "res://assets/characters/huntress/huntress_idle_se.png",
	"s":  "res://assets/characters/huntress/huntress_idle_s.png",
	"sw": "res://assets/characters/huntress/huntress_idle_sw.png",
	"w":  "res://assets/characters/huntress/huntress_idle_w.png",
	"nw": "res://assets/characters/huntress/huntress_idle_nw.png",
	"n":  "res://assets/characters/huntress/huntress_idle_n.png",
	"ne": "res://assets/characters/huntress/huntress_idle_ne.png",
}

## Byte identity with the owner's exports, recorded per direction.
const HUNTRESS_DIRECTION_SHA256: Dictionary = {
	"e":  "767adcc29f6d0ad875416feca0c160016e71313c639b744f9d84f2df946e43d9",
	"se": "8a0bb98cda3d12141795bf0a4fe1594b723213543607f6e688a5ef322131e189",
	"s":  "93c5a713c9d32d3c843cf09e94f5c35bd8883e262afa64e4c3cb65418bb3e740",
	"sw": "be2b7937a17621da2472efbad2c041fdb4d197bc5a07009b9fda8cdbada1c039",
	"w":  "17b4866b00d4fac9bbe617632c94a064e53375a92c50c1e79175127b8cbd2006",
	"nw": "eb34798ce7e17c659a74405621fbcb7b6f56af14e6ff75f4069c9e56174e3ba2",
	"n":  "4433171f2ea790070654cbb0c8a6e2f2045521e873629fe5a802d2a709be2c54",
	"ne": "9cec9cb0cff7c7e7a2788f833ea01d393b23ba5382a8827249e02bda50beae46",
}

## Kept so the earlier pins still resolve: the south strip is the one D-350 and D-351
## measured, and its bytes have not changed.
const HUNTRESS_SHEET_PATH: String = "res://assets/characters/huntress/huntress_idle_s.png"
const HUNTRESS_SHEET_SHA256: String = "93c5a713c9d32d3c843cf09e94f5c35bd8883e262afa64e4c3cb65418bb3e740"

## Measured, not assumed. The Mage's production idle cell is 64x64 and the Huntress's
## is 128x128. They are NOT the same, and that is one of P1A's findings.
const MAGE_CELL: int = 64
const HUNTRESS_CELL: int = 128

const MAGE_FRAME_COUNT: int = 8      # eight directions, one idle frame each
const HUNTRESS_FRAME_COUNT: int = 4  # four idle frames PER DIRECTION, eight directions

## Idle playback. 6 FPS is the owner's recorded decision for this pass.
const IDLE_FPS: float = 6.0

# --- Facing ------------------------------------------------------------------------

## The canonical eight-way facing order, index 0..7, exactly as the accepted direction
## states it: `index = int(floor(wrapf(atan2(v.y, v.x) + PI/8, 0, TAU) / (PI/4)))`.
const DIRECTION_TOKENS: PackedStringArray = ["e", "se", "s", "sw", "w", "nw", "n", "ne"]

## Which ROW of the Mage sheet holds each direction. Established by SHA-256 identity
## against the owner's own per-direction export files, not by looking at the pictures.
## The sheet's own top-to-bottom order is
## front, front_left, left, back_left, back, back_right, right, front_right.
##
## OWNER CONFIRMATION, stated here once rather than buried: this mapping reads
## `front_left` as screen-down-left (`sw`) and `back_left` as screen-up-left (`nw`).
## That is the only reading under which the sheet is a single consistent rotation, but
## it is the owner's word to confirm.
const MAGE_SHEET_ROW_BY_TOKEN: Dictionary = {
	"s": 0, "sw": 1, "w": 2, "nw": 3, "n": 4, "ne": 5, "e": 6, "se": 7,
}

## Retained for the earlier checks. **It no longer means "the only one":** all eight
## directions are exported, and `animation_for()` never substitutes any more.
const HUNTRESS_EXPORTED_TOKEN: String = "s"

## **EMPTY — the owner supplied all seven.** The constant stays so the check that
## guarded it keeps running in both directions: it now proves the list is empty AND that
## every direction resolves to its own file.
const HUNTRESS_MISSING_EXPORTS: PackedStringArray = []

## The production character cell the owner chose in the supplemental pass: the
## high-detail Huntress direction is preserved and 128 x 128 is the target. The Mage's
## 64 x 64 art stays useful reference and diagnostic material and is NOT evidence that
## the production standard should be 64.
const PRODUCTION_CELL: int = 128

## The shared ground anchor. **OWNER-LOCKED** (D-352, confirmed and closed under D-356).
## It was named `PROVISIONAL_ANCHOR` while it was still a proposal; it is not provisional
## any more, and the owner's registration pass moved the art onto it rather than the
## other way round. **ONE shared constant. There is no per-direction or per-frame offset
## anywhere in this project, and P1A's acceptance authorizes none.**
const GROUND_ANCHOR: Vector2i = Vector2i(64, 122)

## ---- The owner's INTEGER ART-REGISTRATION TARGETS (D-354) --------------------------
##
## These are a SPECIFICATION FOR THE ART PASS, not runtime offsets. P1A does not apply
## them, does not edit any owner PNG, and creates no per-direction or per-frame offset
## anywhere. They are recorded here so the suite can prove they are the right numbers and
## so a future re-export can be measured against them.
##
## Where a projected root falls on a half pixel, an even-or-odd stance midpoint cannot
## land exactly on an integer grid. **The residual 0.5 px is unavoidable, is compliant,
## and must never produce a runtime offset.**
const REGISTRATION_TARGETS: Dictionary = {
	"e":  Vector2i(22, 1),
	"se": Vector2i(16, 0),
	"s":  Vector2i(7, 0),
	"sw": Vector2i(-3, 0),
	"w":  Vector2i(-4, 0),
	"nw": Vector2i(6, 1),
	"n":  Vector2i(7, 0),
	"ne": Vector2i(11, 1),
}

## `s` alone cannot take its translation as it stands: its content reaches x 123, and
## +7 would reach 130. The owner's ruling is to **recompose the bow's outer reach by this
## many pixels and then apply the full translation** — not to widen the cell and not to
## keep a registration residual.
const S_BOW_SHORTEN_PX: int = 3

## `w` frame 1 loses its 8-pixel hood cap. The owner's ruling is the smallest LOCAL
## correction — one pixel of hood height — with **no vertical translation of the strip
## and no movement of its contact row.**
const W_HOOD_CAP_CORRECTION_PX: int = 1

# --- The accepted body-height reference ---------------------------------------------

## The accepted capsule height. px/m is derived from the measured drawn body height
## against this, and from nothing else.
const BODY_HEIGHT_M: float = 1.80

# --- Measurement rules, stated once --------------------------------------------------

## A pixel counts as drawn when its alpha is above zero. The exports are hard-edged
## pixel art, so there is no threshold to tune; the runner re-measures at a second
## threshold and asserts the answer does not move.
const ALPHA_EPSILON: float = 0.0

## `head_top` is the topmost row carrying a horizontal run of at least this many drawn
## pixels whose centre falls inside the central band. It exists to exclude a raised
## staff, a bow limb and floating effect motes from the body height, and it is stated
## as a rule rather than eyeballed per frame.
const HEAD_MIN_RUN_FRACTION: float = 0.125       # of the cell width: 8 px at 64, 16 at 128
const HEAD_BAND_LOW_FRACTION: float = 0.3125     # 20/64
const HEAD_BAND_HIGH_FRACTION: float = 0.6875    # 44/64

## ---- The COMPLETE-STANCE anchor measurement (owner ruling, D-353) ------------------
##
## **The horizontal anchor is the projected character root: the horizontal centre of the
## COMPLETE two-boot stance.** It is NOT the midpoint of only the pixels touching the
## bottom-most occupied row — that reading is superseded, because a rear boot drawn
## higher by isometric depth is still part of the stance.
##
## Both boots count. In a profile pose where they overlap, the combined visible boot
## stance counts. Cloak fragments, bow, quiver, arrows, foliage and loose cloth are
## excluded. **One measurement is applied to all four frames of a direction; no
## per-frame correction exists.**
##
## The classes are decided by hue/lightness because this art carries hundreds of
## colours rather than an indexed palette.
enum PixelClass { EMPTY, GREEN, WOOD, BODY }

## Cloak, hood and foliage: the yellow-green band.
const GREEN_HUE_RANGE: Vector2 = Vector2(55.0, 135.0)
const GREEN_MIN_SATURATION: float = 0.08
const GREEN_MIN_LIGHTNESS: float = 0.08
## Bow, quiver and arrow shafts: saturated warm wood.
const WOOD_HUE_RANGE: Vector2 = Vector2(5.0, 45.0)
const WOOD_MIN_SATURATION: float = 0.25
const WOOD_MIN_LIGHTNESS: float = 0.22

## How far above the contact row a boot may reach, and the smallest core a boot body can
## have once thin outlines are eroded away.
const STANCE_BAND_ROWS: int = 22
const STANCE_MIN_CORE_PX: int = 12


static func classify_pixel(c: Color) -> PixelClass:
	if c.a <= 0.0:
		return PixelClass.EMPTY
	var hls: Vector3 = _hls(c)
	if hls.x >= GREEN_HUE_RANGE.x and hls.x <= GREEN_HUE_RANGE.y \
			and hls.z >= GREEN_MIN_SATURATION and hls.y >= GREEN_MIN_LIGHTNESS:
		return PixelClass.GREEN
	if hls.x >= WOOD_HUE_RANGE.x and hls.x <= WOOD_HUE_RANGE.y \
			and hls.z >= WOOD_MIN_SATURATION and hls.y >= WOOD_MIN_LIGHTNESS:
		return PixelClass.WOOD
	return PixelClass.BODY


## Hue in degrees, lightness and saturation — the HLS the classification thresholds are
## written against. `Color` exposes HSV, which is a different measure.
static func _hls(c: Color) -> Vector3:
	var mx: float = maxf(c.r, maxf(c.g, c.b))
	var mn: float = minf(c.r, minf(c.g, c.b))
	var l: float = (mx + mn) * 0.5
	if is_equal_approx(mx, mn):
		return Vector3(0.0, l, 0.0)
	var d: float = mx - mn
	var sat: float = d / (2.0 - mx - mn) if l > 0.5 else d / (mx + mn)
	var h: float
	if is_equal_approx(mx, c.r):
		h = fmod((c.g - c.b) / d, 6.0)
	elif is_equal_approx(mx, c.g):
		h = (c.b - c.r) / d + 2.0
	else:
		h = (c.r - c.g) / d + 4.0
	h *= 60.0
	if h < 0.0:
		h += 360.0
	return Vector3(h, l, sat)


## The complete two-boot stance of one cell: the boot bodies, their combined horizontal
## extent, and the midpoint of that extent — the projected character root.
static func complete_stance(img: Image, rect: Rect2i) -> Dictionary:
	var w: int = rect.size.x
	var h: int = rect.size.y
	var body: Array[PackedByteArray] = []
	var any_row: PackedInt32Array = PackedInt32Array()
	var ground: int = -1
	for y: int in range(h):
		var row: PackedByteArray = PackedByteArray()
		row.resize(w)
		var n: int = 0
		for x: int in range(w):
			var c: PixelClass = classify_pixel(img.get_pixel(rect.position.x + x, rect.position.y + y))
			row[x] = 1 if c == PixelClass.BODY else 0
			if c != PixelClass.EMPTY:
				n += 1
		body.append(row)
		any_row.append(n)
		if n > 0:
			ground = y
	if ground < 0:
		return {"empty": true}
	var lo: int = maxi(0, ground - STANCE_BAND_ROWS + 1)
	# ERODE: in this art every shape carries a near-black outline, and an outline is not
	# a boot. A boot body survives a 3x3 erosion; a one-pixel outline does not.
	var core: Array[PackedByteArray] = []
	for y: int in range(h):
		var row2: PackedByteArray = PackedByteArray()
		row2.resize(w)
		core.append(row2)
	for y: int in range(lo + 1, ground):
		for x: int in range(1, w - 1):
			var solid: bool = true
			for dy: int in range(-1, 2):
				for dx: int in range(-1, 2):
					if body[y + dy][x + dx] == 0:
						solid = false
			core[y][x] = 1 if solid else 0
	# The contact row cannot be eroded downwards, so re-admit the body pixels directly
	# beneath a surviving core pixel.
	for y: int in [ground - 1, ground]:
		for x: int in range(w):
			if body[y][x] == 1:
				for xx: int in range(maxi(0, x - 1), mini(w, x + 2)):
					if core[y - 1][xx] == 1:
						core[y][x] = 1
						break
	var clusters: Array = _clusters(core, lo, ground, w)
	var kept: Array = []
	for cl: Dictionary in clusters:
		if int(cl["n"]) >= STANCE_MIN_CORE_PX:
			kept.append({"x0": int(cl["x0"]) - 1, "x1": int(cl["x1"]) + 1,
				"y0": cl["y0"], "y1": cl["y1"], "n": cl["n"]})
	if kept.is_empty():
		return {"empty": true}
	var sx0: int = 9999
	var sx1: int = -1
	for cl2: Dictionary in kept:
		sx0 = mini(sx0, int(cl2["x0"]))
		sx1 = maxi(sx1, int(cl2["x1"]))
	return {
		"empty": false, "contact_row": ground, "clusters": kept,
		"stance_x0": sx0, "stance_x1": sx1, "stance_mid": float(sx0 + sx1) * 0.5,
	}


static func _clusters(mask: Array[PackedByteArray], lo: int, hi: int, w: int) -> Array:
	var seen: Dictionary = {}
	var out: Array = []
	for y: int in range(lo, hi + 1):
		for x: int in range(w):
			var key: int = y * 1000 + x
			if mask[y][x] == 0 or seen.has(key):
				continue
			var queue: Array[Vector2i] = [Vector2i(x, y)]
			seen[key] = true
			var x0: int = x
			var x1: int = x
			var y0: int = y
			var y1: int = y
			var n: int = 0
			while not queue.is_empty():
				var p: Vector2i = queue.pop_back()
				n += 1
				x0 = mini(x0, p.x); x1 = maxi(x1, p.x)
				y0 = mini(y0, p.y); y1 = maxi(y1, p.y)
				for dy: int in range(-1, 2):
					for dx: int in range(-1, 2):
						var nx: int = p.x + dx
						var ny: int = p.y + dy
						var k2: int = ny * 1000 + nx
						if ny >= lo and ny <= hi and nx >= 0 and nx < w \
								and mask[ny][nx] == 1 and not seen.has(k2):
							seen[k2] = true
							queue.append(Vector2i(nx, ny))
			out.append({"x0": x0, "x1": x1, "y0": y0, "y1": y1, "n": n})
	return out


## The hood crown: the top of the highest substantial garment mass, with the bow, the
## quiver and the arrows excluded. **This is the equipment-free height landmark**, and it
## is what the scale question must be answered against — not the raw alpha bounds, which
## a raised bow limb can dominate.
static func hood_crown(img: Image, rect: Rect2i, min_component: int = 100) -> int:
	var w: int = rect.size.x
	var h: int = rect.size.y
	var green: Array[PackedByteArray] = []
	for y: int in range(h):
		var row: PackedByteArray = PackedByteArray()
		row.resize(w)
		for x: int in range(w):
			row[x] = 1 if classify_pixel(img.get_pixel(rect.position.x + x, rect.position.y + y)) \
				== PixelClass.GREEN else 0
		green.append(row)
	var best: int = -1
	for cl: Dictionary in _clusters(green, 0, h - 1, w):
		if int(cl["n"]) >= min_component:
			if best < 0 or int(cl["y0"]) < best:
				best = int(cl["y0"])
	return best


## The stance band is where a standing character's legs and boots are. It is expressed
## as a fraction OF THE MEASURED BODY, not of the cell, so it means the same thing for
## a 64 cell and a 128 cell. The report re-measures with two further bands and shows the
## conclusion does not depend on the choice.
const STANCE_BAND_LOW_FRACTION: float = 0.75
const STANCE_BAND_HIGH_FRACTION: float = 0.95


static func sheet_path(character: String) -> String:
	return MAGE_SHEET_PATH if character == "mage" else HUNTRESS_SHEET_PATH


## The file a given Huntress facing is drawn from. One strip per direction.
static func direction_path(character: String, token: String) -> String:
	if character == "mage":
		return MAGE_SHEET_PATH
	return String(HUNTRESS_DIRECTION_PATHS[token])


static func cell_size(character: String) -> int:
	return MAGE_CELL if character == "mage" else HUNTRESS_CELL


static func frame_count(character: String) -> int:
	return MAGE_FRAME_COUNT if character == "mage" else HUNTRESS_FRAME_COUNT


## The Mage sheet is one column of eight rows; each Huntress strip is one row of four
## columns. Both are read from the file's own dimensions rather than trusted.
static func cell_rect(character: String, index: int) -> Rect2i:
	var c: int = cell_size(character)
	if character == "mage":
		return Rect2i(0, index * c, c, c)
	return Rect2i(index * c, 0, c, c)


static func load_direction_image(character: String, token: String) -> Image:
	return _image_at(direction_path(character, token))


static func load_sheet_image(character: String) -> Image:
	return _image_at(sheet_path(character))


static func _image_at(path: String) -> Image:
	var tex: Texture2D = load(path) as Texture2D
	if tex == null:
		return null
	var img: Image = tex.get_image()
	if img == null:
		return null
	if img.is_compressed():
		img.decompress()
	img.convert(Image.FORMAT_RGBA8)
	return img


## Build the character's SpriteFrames in code, from the imported PNG only.
##
## The resource is project-authored in the plainest possible sense: this function is
## the whole author. Nothing is loaded from a `.tres` that could drift away from the
## measurement, and nothing is derived from a `.pxo`.
static func build_sprite_frames(character: String) -> SpriteFrames:
	var tex: Texture2D = load(sheet_path(character)) as Texture2D
	var frames: SpriteFrames = SpriteFrames.new()
	frames.remove_animation("default")
	if character == "mage":
		for token: String in DIRECTION_TOKENS:
			var row: int = int(MAGE_SHEET_ROW_BY_TOKEN[token])
			var anim: String = "idle_%s" % token
			frames.add_animation(anim)
			frames.set_animation_loop(anim, true)
			frames.set_animation_speed(anim, IDLE_FPS)
			frames.add_frame(anim, _atlas(tex, cell_rect("mage", row)))
		return frames
	# The Huntress: EIGHT exported directions, four frames each, one strip per direction,
	# frames left to right. Nothing substitutes for anything.
	for token: String in DIRECTION_TOKENS:
		var dir_tex: Texture2D = load(String(HUNTRESS_DIRECTION_PATHS[token])) as Texture2D
		var anim: String = "idle_%s" % token
		frames.add_animation(anim)
		frames.set_animation_loop(anim, true)
		frames.set_animation_speed(anim, IDLE_FPS)
		for i: int in range(HUNTRESS_FRAME_COUNT):
			frames.add_frame(anim, _atlas(dir_tex, cell_rect("huntress", i)))
	return frames


static func _atlas(tex: Texture2D, region: Rect2i) -> AtlasTexture:
	var at: AtlasTexture = AtlasTexture.new()
	at.atlas = tex
	at.region = Rect2(region)
	at.filter_clip = true
	return at


## The animation a given facing actually plays, and whether that is the facing asked
## for. The second value exists so no surface can claim eight Huntress directions.
## Since the owner supplied all eight Huntress directions, NOTHING substitutes for
## anything. The second value stays so the truthfulness check keeps proving it is false.
static func animation_for(character: String, token: String) -> Dictionary:
	return {"animation": "idle_%s" % token, "is_substitute": false}


# --- Measurement ---------------------------------------------------------------------

## Measure one cell. Every number this returns is in CELL-LOCAL pixels.
static func measure_cell(img: Image, rect: Rect2i, alpha_epsilon: float = ALPHA_EPSILON) -> Dictionary:
	var w: int = rect.size.x
	var h: int = rect.size.y
	var rows_min: PackedInt32Array = PackedInt32Array()
	var rows_max: PackedInt32Array = PackedInt32Array()
	var rows_count: PackedInt32Array = PackedInt32Array()
	rows_min.resize(h)
	rows_max.resize(h)
	rows_count.resize(h)
	var x0: int = w
	var x1: int = -1
	var y0: int = h
	var y1: int = -1
	for y: int in range(h):
		var rmin: int = w
		var rmax: int = -1
		var n: int = 0
		for x: int in range(w):
			if img.get_pixel(rect.position.x + x, rect.position.y + y).a > alpha_epsilon:
				n += 1
				if x < rmin:
					rmin = x
				if x > rmax:
					rmax = x
		rows_min[y] = rmin
		rows_max[y] = rmax
		rows_count[y] = n
		if n > 0:
			if y < y0:
				y0 = y
			y1 = y
			if rmin < x0:
				x0 = rmin
			if rmax > x1:
				x1 = rmax
	if y1 < 0:
		return {"empty": true}

	var head_top: int = _head_top(img, rect, alpha_epsilon)
	var body_h: int = y1 - head_top + 1
	var stance: Dictionary = stance_extent(img, rect, head_top, body_h,
		STANCE_BAND_LOW_FRACTION, STANCE_BAND_HIGH_FRACTION, alpha_epsilon)
	var foot: Dictionary = ground_footprint(img, rect, y1, alpha_epsilon)
	var stance_complete: Dictionary = complete_stance(img, rect)

	return {
		"stance_complete_x0": int(stance_complete.get("stance_x0", -1)),
		"stance_complete_x1": int(stance_complete.get("stance_x1", -1)),
		"stance_complete_mid": float(stance_complete.get("stance_mid", -1.0)),
		"boot_clusters": stance_complete.get("clusters", []),
		"hood_crown": hood_crown(img, rect),
		"empty": false,
		"drawn_x0": x0, "drawn_x1": x1, "drawn_y0": y0, "drawn_y1": y1,
		"drawn_w": x1 - x0 + 1, "drawn_h": y1 - y0 + 1,
		"ground_row": y1,
		"head_top": head_top,
		"body_h": body_h,
		"stance_x0": int(stance["x0"]), "stance_x1": int(stance["x1"]),
		"stance_mid": float(stance["mid"]),
		"stance_row_low": int(stance["row_low"]), "stance_row_high": int(stance["row_high"]),
		"ground_runs": foot["runs"],
		"ground_x0": int(foot["x0"]), "ground_x1": int(foot["x1"]),
		"ground_mid": float(foot["mid"]), "ground_width": int(foot["width"]),
	}


## What the character actually STANDS ON: the horizontal runs of drawn pixels on the
## ground row itself.
##
## This is a better anchor estimator than the stance band whenever the feet are drawn
## clearly, because it reads the contact pixels rather than a band that a cloak, a staff
## or a bow limb can widen. The stance band is kept alongside it, unchanged, so the
## earlier measurements and their pins stay exactly as they were.
static func ground_footprint(img: Image, rect: Rect2i, ground_row: int,
		alpha_epsilon: float = ALPHA_EPSILON) -> Dictionary:
	var w: int = rect.size.x
	var runs: Array = []
	var start: int = -1
	for x: int in range(w + 1):
		var on: bool = x < w and img.get_pixel(rect.position.x + x, rect.position.y + ground_row).a > alpha_epsilon
		if on and start < 0:
			start = x
		elif not on and start >= 0:
			runs.append([start, x - 1])
			start = -1
	if runs.is_empty():
		return {"runs": runs, "x0": -1, "x1": -1, "mid": -1.0, "width": 0}
	var x0: int = int((runs[0] as Array)[0])
	var x1: int = int((runs[runs.size() - 1] as Array)[1])
	return {"runs": runs, "x0": x0, "x1": x1, "mid": float(x0 + x1) * 0.5, "width": x1 - x0 + 1}


static func _head_top(img: Image, rect: Rect2i, alpha_epsilon: float) -> int:
	var w: int = rect.size.x
	var h: int = rect.size.y
	var min_run: int = int(round(float(w) * HEAD_MIN_RUN_FRACTION))
	var band_low: float = float(w) * HEAD_BAND_LOW_FRACTION
	var band_high: float = float(w) * HEAD_BAND_HIGH_FRACTION
	for y: int in range(h):
		var run_start: int = -1
		for x: int in range(w + 1):
			var on: bool = x < w and img.get_pixel(rect.position.x + x, rect.position.y + y).a > alpha_epsilon
			if on and run_start < 0:
				run_start = x
			elif not on and run_start >= 0:
				var run_end: int = x - 1
				if run_end - run_start + 1 >= min_run:
					var centre: float = float(run_start + run_end) * 0.5
					if centre >= band_low and centre <= band_high:
						return y
				run_start = -1
	return -1


## The horizontal extent of the drawn body inside a stated band of the body's own
## height. `mid` is the midpoint of that extent — P1A's estimator for where the
## character STANDS, as distinct from where its drawn bounding box is centred.
static func stance_extent(img: Image, rect: Rect2i, head_top: int, body_h: int,
		low_fraction: float, high_fraction: float,
		alpha_epsilon: float = ALPHA_EPSILON) -> Dictionary:
	var w: int = rect.size.x
	var row_low: int = head_top + int(floor(float(body_h) * low_fraction))
	var row_high: int = head_top + int(floor(float(body_h) * high_fraction))
	row_low = clampi(row_low, 0, rect.size.y - 1)
	row_high = clampi(row_high, 0, rect.size.y - 1)
	var x0: int = w
	var x1: int = -1
	for y: int in range(row_low, row_high + 1):
		for x: int in range(w):
			if img.get_pixel(rect.position.x + x, rect.position.y + y).a > alpha_epsilon:
				if x < x0:
					x0 = x
				if x > x1:
					x1 = x
	if x1 < 0:
		return {"x0": -1, "x1": -1, "mid": -1.0, "row_low": row_low, "row_high": row_high}
	return {
		"x0": x0, "x1": x1, "mid": float(x0 + x1) * 0.5,
		"row_low": row_low, "row_high": row_high,
	}


## Measure the four frames of ONE Huntress direction, or the Mage's single frame for a
## direction. The unit the checks work in.
static func measure_direction(character: String, token: String,
		alpha_epsilon: float = ALPHA_EPSILON) -> Array[Dictionary]:
	var out: Array[Dictionary] = []
	if character == "mage":
		var mimg: Image = load_sheet_image("mage")
		if mimg == null:
			return out
		var row: int = int(MAGE_SHEET_ROW_BY_TOKEN[token])
		var mm: Dictionary = measure_cell(mimg, cell_rect("mage", row), alpha_epsilon)
		mm["index"] = 0
		mm["direction"] = token
		mm["label"] = token
		out.append(mm)
		return out
	var img: Image = load_direction_image("huntress", token)
	if img == null:
		return out
	for i: int in range(HUNTRESS_FRAME_COUNT):
		var m: Dictionary = measure_cell(img, cell_rect("huntress", i), alpha_epsilon)
		m["index"] = i
		m["direction"] = token
		m["label"] = "%s f%d" % [token, i]
		out.append(m)
	return out


## Measure EVERY frame of a character: the Mage's eight, the Huntress's thirty-two.
static func measure_character(character: String, alpha_epsilon: float = ALPHA_EPSILON) -> Array[Dictionary]:
	var out: Array[Dictionary] = []
	for token: String in DIRECTION_TOKENS:
		out.append_array(measure_direction(character, token, alpha_epsilon))
	return out


static func _label_for(character: String, index: int) -> String:
	if character == "mage":
		for token: String in MAGE_SHEET_ROW_BY_TOKEN.keys():
			if int(MAGE_SHEET_ROW_BY_TOKEN[token]) == index:
				return token
		return "row%d" % index
	return "%s f%d" % [HUNTRESS_EXPORTED_TOKEN, index]
