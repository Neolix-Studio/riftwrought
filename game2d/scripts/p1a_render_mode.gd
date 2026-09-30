class_name P1ARenderMode
extends RefCounted

## P1A — the candidate rendering approaches, and the arithmetic that describes what each
## one does to a given window.
##
## **THE COMPARISON IS OVER. Mode 7 — `SUBVIEWPORT_FILL_FIXED`, display-pinned
## fractional fill — is the CANONICAL DEFAULT PRESENTATION (D-356 ruling 1.)**
##
## The owner ran the live comparison at the locked 1920 x 1080 base, tested modes 1, 3,
## 5, 6 and 7 with the five-second pan across several Huntress facings, and found no
## artefact objectionable enough to reject any mode. Mode 7 was chosen for display fill
## on non-integer output sizes, a stationary display grid, acceptable measured character
## re-rasterisation, and exact scaling at 1920 x 1080 and its integer multiples.
##
## **Modes 1 and 3 remain DIAGNOSTIC COMPARATORS** (ruling 2). A future optional
## player-facing pixel-perfect / integer mode is ALLOWED but is **not authorized for
## implementation by P1A**, and nothing here implements one.
##
## **Mode 2 — ordinary pixel-snapped canvas rendering — stays REJECTED** (D-351).

enum Approach {
	INTEGER_VIEWPORT,        ## 1. `viewport` stretch, KEEP aspect, integer scale, camera on whole base pixels
	PIXEL_SNAPPED_CANVAS,    ## 2. `canvas_items` stretch, fractional scale, camera on whole world pixels
	SUBVIEWPORT_REMAINDER,   ## 3. SubViewport at base, integer display scale, sub-pixel remainder offset
	INTEGER_VIEWPORT_EXPAND, ## 4. as 1, but EXPAND aspect: the bars become visible world
	## 5-7 are the supplemental pass's FINAL-FRAME PRESENTATION SCALE. The logical
	## pixel-art frame stays internally pixel-stable and character sprites stay at an
	## integral 1:1 scale inside it; only the FINISHED SubViewport texture is stretched,
	## with nearest sampling, at whatever fractional factor fills the window. This is a
	## presentation scale, never a character CanvasItem scale.
	SUBVIEWPORT_FILL,         ## 5. remainder applied at sub-device-pixel precision
	SUBVIEWPORT_FILL_SNAPPED, ## 6. remainder applied, quantised to whole device pixels
	SUBVIEWPORT_FILL_FIXED,   ## 7. display rect pinned; remainder NOT applied
}

const APPROACH_IDS: PackedStringArray = [
	"integer_viewport", "pixel_snapped_canvas", "subviewport_remainder", "integer_viewport_expand",
	"subviewport_fill", "subviewport_fill_snapped", "subviewport_fill_fixed",
]

const APPROACH_NAMES: PackedStringArray = [
	"1 — integer-scaled viewport rendering (keep aspect)",
	"2 — ordinary pixel-snapped canvas rendering",
	"3 — SubViewport + sub-pixel remainder",
	"4 — integer-scaled viewport rendering (expand aspect)",
	"5 — SubViewport filled to the window, remainder at sub-device-pixel precision",
	"6 — SubViewport filled to the window, remainder snapped to whole device pixels",
	"7 — SubViewport filled to the window, display rect pinned (remainder not applied)",
]

const APPROACH_SUMMARIES: PackedStringArray = [
	"The whole low-resolution frame is scaled as one image by a whole number. Shimmer-free by construction. Costs letterboxing, and camera motion is quantised to whole base pixels.",
	"The 2D canvas is drawn straight at window resolution and scaled by a fractional factor. No letterboxing. Sprite pixels land on uneven device-pixel widths, so edges can crawl while the camera moves.",
	"The world renders into a SubViewport at base resolution and is displayed at a whole-number scale, and the whole displayed frame is then offset by the camera's sub-base-pixel remainder. Pixel blocks stay uniform; the camera moves in device pixels rather than base pixels.",
	"The same whole-number scaling as 1, but the viewport EXPANDS to fill the window instead of padding it. No bars: what would have been a black bar becomes visible world. The cost is that the visible extent is no longer fixed, so a room authored to a camera footprint shows differently on differently-shaped displays. Not one of the three the brief required; measured because on this owner's actual display approach 1 spends 29% of the width and 31% of the height on bars.",
	"The finished low-resolution frame is stretched to FILL the window at a fractional factor with nearest sampling, and the camera's sub-base-pixel remainder still slides it. Sprites stay 1:1 inside the logical frame; only the finished frame is scaled. Nearly all of the window is used. The cost is that a fractional output factor makes some logical pixels one device pixel wider than others, and here that uneven grid MOVES with the remainder.",
	"As 5, but the remainder is quantised to whole device pixels before the frame is placed. The uneven grid still moves, but only in whole-device-pixel steps.",
	"As 5, but the display rect is pinned and the remainder is NOT applied. The uneven output grid is then STATIONARY in screen space; the camera moves in whole logical pixels only. This is the variant that answers 'does the pattern stay fixed or crawl', and it trades the remainder's extra camera smoothness for a stationary grid.",
]

## --- What D-356 locked -------------------------------------------------------------

## The canonical default presentation. The owner numbers the modes from 1; the enum
## counts from 0. Both are recorded so nothing has to translate by hand.
const CANONICAL_APPROACH: int = Approach.SUBVIEWPORT_FILL_FIXED
const CANONICAL_APPROACH_OWNER_NUMBER: int = 7

## Retained for comparison and diagnosis only. Selecting one of these in the tool is a
## diagnostic act, never a change of the canonical presentation.
const DIAGNOSTIC_COMPARATORS: Array[int] = [
	Approach.INTEGER_VIEWPORT,        ## owner mode 1
	Approach.SUBVIEWPORT_REMAINDER,   ## owner mode 3
]

## Rejected under D-351 and NOT reinstated by D-356.
const REJECTED_APPROACHES: Array[int] = [Approach.PIXEL_SNAPPED_CANVAS]  ## owner mode 2

## **ALLOWED, NOT AUTHORIZED (D-356 ruling 2).** A future optional player-facing
## pixel-perfect / integer mode may exist. P1A does not implement one, does not expose
## one as a player setting, and nothing here may be read as authorizing it.
const OPTIONAL_PLAYER_FACING_INTEGER_MODE_AUTHORIZED: bool = false

## The approaches that let the WINDOW decide how much world is visible. D-356 ruling 11
## forbids that for the canonical presentation, and the canonical mode is not among them.
const APPROACHES_THAT_EXPOSE_EXTRA_WORLD: Array[int] = [
	Approach.PIXEL_SNAPPED_CANVAS,     ## owner mode 2
	Approach.INTEGER_VIEWPORT_EXPAND,  ## owner mode 4
]


## The SubViewport gets one extra pixel in each axis so the remainder offset never
## exposes an unrendered edge.
const SUBVIEWPORT_MARGIN_PX: int = 1


static func approach_id(approach: int) -> String:
	return APPROACH_IDS[approach]


static func approach_name(approach: int) -> String:
	return APPROACH_NAMES[approach]


## The largest whole-number scale at which `base` fits inside `window`. Never below 1:
## a window smaller than the base still has to show something, and the report says so
## rather than the tool silently clipping.
static func integer_scale(window: Vector2i, base: Vector2i) -> int:
	if base.x <= 0 or base.y <= 0 or window.x <= 0 or window.y <= 0:
		return 1
	return maxi(1, mini(window.x / base.x, window.y / base.y))


## What `canvas_items` + `expand` actually does: one scale factor, taken from the
## tighter axis, with the other axis showing MORE world rather than a bar.
static func fractional_scale(window: Vector2i, base: Vector2i) -> float:
	if base.x <= 0 or base.y <= 0 or window.x <= 0 or window.y <= 0:
		return 1.0
	return minf(float(window.x) / float(base.x), float(window.y) / float(base.y))


## What `CONTENT_SCALE_ASPECT_EXPAND` actually does, MEASURED rather than assumed.
##
## The first arithmetic written here was wrong, and the rendered evidence caught it: an
## expanding viewport does NOT grow to fill the window. Godot keeps the base dimension
## on the tighter axis and grows the other one until the viewport matches the WINDOW'S
## ASPECT; the integer scale is then taken against that expanded viewport, and whatever
## the whole-number scale cannot fill is still a black bar. So `expand` does not remove
## letterboxing — it removes the ASPECT component of it, and pays for that by changing
## how much world is visible from one window shape to the next.
static func expanded_base(window: Vector2i, base: Vector2i) -> Vector2i:
	if window.x <= 0 or window.y <= 0 or base.x <= 0 or base.y <= 0:
		return base
	var window_aspect: float = float(window.x) / float(window.y)
	var base_aspect: float = float(base.x) / float(base.y)
	if window_aspect > base_aspect:
		return Vector2i(int(round(float(base.y) * window_aspect)), base.y)
	return Vector2i(base.x, int(round(float(base.x) / window_aspect)))


## The fractional factor that FILLS the window with the base frame while preserving its
## aspect. On a window of the base's own aspect this is an exact fill with no bars; on a
## differently-shaped window it leaves a bar on one axis only.
static func fill_scale(window: Vector2i, base: Vector2i) -> float:
	return fractional_scale(window, base)


## Total black bars, in device pixels, across each axis.
static func letterbox(window: Vector2i, base: Vector2i, scale: float) -> Vector2i:
	return Vector2i(
		maxi(0, window.x - int(round(float(base.x) * scale))),
		maxi(0, window.y - int(round(float(base.y) * scale))),
	)


## The visible base-pixel rectangle each approach presents.
##
## Approach 1 shows exactly the base rectangle and pads with bars. Approach 2 keeps the
## scale but EXPANDS the shorter axis, so it shows MORE world than the base rectangle
## on a window whose aspect differs. Approach 3 shows the base rectangle plus its
## one-pixel margin.
static func visible_base_pixels(approach: int, window: Vector2i, base: Vector2i) -> Vector2:
	match approach:
		Approach.INTEGER_VIEWPORT:
			return Vector2(base)
		Approach.PIXEL_SNAPPED_CANVAS:
			var s: float = fractional_scale(window, base)
			if s <= 0.0:
				return Vector2(base)
			return Vector2(float(window.x) / s, float(window.y) / s)
		Approach.INTEGER_VIEWPORT_EXPAND:
			return Vector2(expanded_base(window, base))
		Approach.SUBVIEWPORT_FILL, Approach.SUBVIEWPORT_FILL_SNAPPED, Approach.SUBVIEWPORT_FILL_FIXED:
			return Vector2(base + Vector2i(SUBVIEWPORT_MARGIN_PX, SUBVIEWPORT_MARGIN_PX))
		_:
			return Vector2(base + Vector2i(SUBVIEWPORT_MARGIN_PX, SUBVIEWPORT_MARGIN_PX))


## How much of the window the presented frame actually covers.
static func _fill_fraction(window: Vector2i, visible_px: Vector2, scale: float, bars: Vector2i) -> float:
	if window.x <= 0 or window.y <= 0:
		return 0.0
	var shown_x: float = minf(float(window.x), float(window.x - bars.x))
	var shown_y: float = minf(float(window.y), float(window.y - bars.y))
	return maxf(0.0, shown_x * shown_y) / float(window.x * window.y)


## The finest visible camera step, in device pixels.
##
## Approaches 1 and 4 move the camera a whole base pixel at a time, which is `scale`
## device pixels. Approach 3 slides the displayed frame by the remainder, so its finest
## step is one device pixel. Approaches 5 and 6 do the same on a filled frame. Approach
## 7 pins the frame, so its step is a whole logical pixel again.
static func _camera_step_device_px(approach: int, scale: float) -> float:
	match approach:
		Approach.SUBVIEWPORT_REMAINDER, Approach.SUBVIEWPORT_FILL, Approach.SUBVIEWPORT_FILL_SNAPPED:
			return 1.0
		_:
			return scale


## Everything P1A reports for one (approach, window, base, density) combination.
## Pure arithmetic — the runner checks it headlessly, and the rendered evidence checks
## that the engine agrees.
static func describe(approach: int, window: Vector2i, base: Vector2i,
		px_per_m: float, body_px: float, sprite_scale: int) -> Dictionary:
	var scale: float
	var integer_only: bool
	match approach:
		Approach.INTEGER_VIEWPORT:
			scale = float(integer_scale(window, base))
			integer_only = true
		Approach.PIXEL_SNAPPED_CANVAS:
			scale = fractional_scale(window, base)
			integer_only = false
		Approach.INTEGER_VIEWPORT_EXPAND:
			scale = float(integer_scale(window, expanded_base(window, base)))
			integer_only = true
		Approach.SUBVIEWPORT_FILL, Approach.SUBVIEWPORT_FILL_SNAPPED, Approach.SUBVIEWPORT_FILL_FIXED:
			scale = fill_scale(window, base)
			integer_only = false
		_:
			scale = float(integer_scale(window, base))
			integer_only = true
	var visible_px: Vector2 = visible_base_pixels(approach, window, base)
	var bars: Vector2i = letterbox(window, Vector2i(visible_px.round()), scale)
	if approach == Approach.PIXEL_SNAPPED_CANVAS:
		bars = Vector2i.ZERO  # `canvas_items` + `expand` draws straight into the window.
	return {
		"approach": approach,
		"approach_id": approach_id(approach),
		"approach_name": approach_name(approach),
		"window": [window.x, window.y],
		"base": [base.x, base.y],
		"scale": scale,
		"scale_is_integer": is_equal_approx(scale, roundf(scale)),
		"integer_only_by_construction": integer_only,
		"letterbox_total_px": [bars.x, bars.y],
		"fill_fraction": _fill_fraction(window, visible_px, scale, bars),
		"letterbox_fraction": float(bars.x * window.y + bars.y * window.x) / float(maxi(1, window.x * window.y)),
		"visible_base_px": [visible_px.x, visible_px.y],
		"visible_world_m": [visible_px.x / px_per_m, visible_px.y / px_per_m],
		"actor_fraction_of_screen_height": body_px * float(sprite_scale) / maxf(1.0, visible_px.y),
		# What one step of the camera is worth. Approaches 1 and 3 snap the camera to
		# whole base pixels; 3 then slides the whole displayed frame by the remainder,
		# so its finest visible step is one DEVICE pixel rather than one base pixel.
		"camera_step_device_px": _camera_step_device_px(approach, scale),
		"output_grid_moves_with_the_camera": approach == Approach.SUBVIEWPORT_FILL
			or approach == Approach.SUBVIEWPORT_FILL_SNAPPED,
		"final_frame_presentation_scale": approach == Approach.SUBVIEWPORT_FILL
			or approach == Approach.SUBVIEWPORT_FILL_SNAPPED
			or approach == Approach.SUBVIEWPORT_FILL_FIXED,
		"camera_step_world_px": (1.0 if approach != Approach.PIXEL_SNAPPED_CANVAS else 1.0),
		"camera_step_m": 1.0 / px_per_m,
	}
