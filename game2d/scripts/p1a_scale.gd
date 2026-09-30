class_name P1AScale
extends RefCounted

## P1A — deriving px/m, the camera footprint and the P1B tile proposal from the
## measured art. Everything here is arithmetic over `P1AArt`'s measurements.
##
## NOTHING HERE IS LOCKED. px/m, the base resolution, the rendering approach, the tile
## projection and the tile dimensions are P1A *findings*, offered to the owner. The two
## density candidates exist because the Mage and the Huntress were measured at
## MATERIALLY DIFFERENT densities and P1A refuses to average them silently.

## ---- OWNER-LOCKED under D-354 -----------------------------------------------------
##
## **The canonical gameplay base viewport, and the default output/window resolution.**
## This supersedes the earlier 1600 x 900 suggestion.
##
## The wider framing is deliberate. At the locked 60.0 px/m it shows 32.00 x 18.00 m,
## and that battlefield is intentional for ARPG / roguelite pack density, area-effect
## interactions, projectile visibility, kiting and simultaneous kill feedback. The
## Huntress still reads at roughly a tenth of the content height.
##
## **It authorizes no enemy count.** Density stays governed by encounter budgets,
## telegraph readability and performance limits.
const CANONICAL_BASE_VIEWPORT: Vector2i = Vector2i(1920, 1080)
const DEFAULT_OUTPUT_RESOLUTION: Vector2i = Vector2i(1920, 1080)

## **THE RENDERING MODE IS DECIDED.** The owner ran the live comparison at the locked
## 1920 x 1080 base, tested modes 1, 3, 5, 6 and 7 with the five-second pan across
## several Huntress facings, found no objectionable artefact in any of them, and locked
## **mode 7 — display-pinned fractional fill** as the canonical default presentation
## (D-356).
##
## The owner's stated rationale, each clause MEASURED in `p1a_verification.gd` rather
## than recorded on trust:
##  - best display fill on non-integer output sizes;
##  - the display grid stays stationary;
##  - the measured character re-rasterisation was not objectionable in live review;
##  - at 1920 x 1080 and integer multiples such as 3840 x 2160 it produces EXACT scaling.
const RENDERING_MODE_DECIDED: bool = true

## Mode 7 in the owner's 1-based numbering. Stored as the `P1ARenderMode.Approach` value
## so nothing has to translate between the two numberings by hand.
const LOCKED_RENDERING_MODE: int = 6           ## Approach.SUBVIEWPORT_FILL_FIXED
const LOCKED_RENDERING_MODE_OWNER_NUMBER: int = 7

## The locked production constants, in one place, so no surface has to restate them.
## Every one of these is an OWNER LOCK, not a measurement this file is free to revise.
const LOCKED_PX_PER_M: float = 60.0                          ## D-352, confirmed D-356
const LOCKED_CHARACTER_CELL_PX: int = 128                    ## D-351, confirmed D-356
const LOCKED_GROUND_ANCHOR: Vector2i = Vector2i(64, 122)     ## D-352, confirmed D-356
const LOCKED_TILE_PX: Vector2i = Vector2i(120, 60)           ## D-356: 1 x 1 world metre
const LOCKED_TILE_GROUND_METRES: float = 1.0
## The canonical camera footprint that follows from the locked base and density. P1B
## room authoring reads THIS, not a ported 3D CF figure.
const LOCKED_CAMERA_FOOTPRINT_M: Vector2 = Vector2(32.0, 18.0)

## **The world scaling policy for non-integer output sizes (D-356 ruling 11).**
## Mode 7 presents a FIXED base rectangle and letterboxes whatever the window's aspect
## cannot cover. It never stretches gameplay framing and never exposes additional world
## space because a monitor is larger or a different shape. Modes 2 and 4 do expose more
## world; that is precisely why neither is the canonical mode.
const WORLD_EXTENT_IS_FIXED_ACROSS_OUTPUT_SIZES: bool = true

## **The Mage reconstruction obligation (D-356 ruling 7).** The current 64 x 64 exports
## are measured LEGACY / REFERENCE inputs and are NOT conforming production assets. P1A
## does not edit them. Any future 128 x 128 reconstruction must satisfy all four of
## these, and this constant is what a later phase checks itself against.
const MAGE_RECONSTRUCTION_REQUIREMENTS: Dictionary = {
	"px_per_m": 60.0,
	"cell_px": 128,
	"anchor": Vector2i(64, 122),
	"authored_directions": 8,
	"mirroring_allowed": false,
}
const MAGE_CURRENT_EXPORTS_CONFORM: bool = false

## The accepted spatial unit. Reported in pixels for each candidate; not implemented.
const P_METRES: float = 0.80

## A square ground tile of this many metres per side is what the proposed isometric
## tile represents. One metre is the smallest choice that keeps the tile a whole
## number of pixels at both candidate densities.
const TILE_GROUND_METRES: float = 1.0

## Illustrative only, for the report's comparison table. These are ACCEPTED 3D values.
## P1A recomputes them in pixels so the owner can see what the candidate densities
## mean in practice. **P1A implements no combat and canonizes no 2D distance.**
const ILLUSTRATIVE_3D_VALUES: Dictionary = {
	"P (spatial unit)": 0.80,
	"player capsule width": 0.80,
	"path arrival tolerance": 0.20,
	"Quick Strike release reach": 1.65,
	"Graveblade preferred attack distance": 1.40,
	"controller soft-target acquisition distance": 5.0,
	"Graveblade awareness radius": 10.0,
}

## The accepted 3D camera footprint, for comparison only. It describes a perspective
## 3D rig and does NOT port; it is here because room and zone sizes in the blueprint
## are expressed in camera footprints, so the owner needs to see the 2D footprint
## beside it. Do not port a CF figure without recomputing it.
const ACCEPTED_3D_CAMERA_FOOTPRINT_M: Vector2 = Vector2(27.982, 20.980)


## The density a character's art actually implies, measured against the accepted
## 1.80 m body height. Exact arithmetic over the measured body heights.
static func measured_px_per_m(measurements: Array[Dictionary]) -> Dictionary:
	var heights: PackedInt32Array = PackedInt32Array()
	for m: Dictionary in measurements:
		if not bool(m.get("empty", true)):
			heights.append(int(m["body_h"]))
	if heights.is_empty():
		return {"count": 0}
	var lo: int = heights[0]
	var hi: int = heights[0]
	var total: int = 0
	for v: int in heights:
		lo = mini(lo, v)
		hi = maxi(hi, v)
		total += v
	var mean: float = float(total) / float(heights.size())
	return {
		"count": heights.size(),
		"body_h_min": lo, "body_h_max": hi, "body_h_mean": mean,
		"px_per_m_min": float(lo) / P1AArt.BODY_HEIGHT_M,
		"px_per_m_max": float(hi) / P1AArt.BODY_HEIGHT_M,
		"px_per_m_mean": mean / P1AArt.BODY_HEIGHT_M,
	}


## The density candidates.
##
## **The supplemental pass changed this list on the owner's direction.** Candidate A —
## the Mage's 32 px/m at a 64 px cell — is **REJECTED FOR PRODUCTION** and kept only as
## diagnostic history: the high-detail Huntress direction is preserved and the
## production character cell targets 128 x 128. The Mage's existing 64 x 64 art remains
## useful reference and diagnostic material and is **not** evidence that the production
## standard should be 64.
##
## Two production candidates are offered, both at a 128 px cell. They differ by 6.7%
## and the difference is entirely about what the DRAWN Huntress then stands for against
## the accepted 1.80 m reference. **Neither is locked.**
##
## `B` is the owner's stated target of approximately 64 px/m. `C` is the exact-art
## derived value: the Huntress's resting frames measure **exactly 108 px**, which at
## 60.0 px/m is **exactly 1.800 m**.
static func candidates() -> Array[Dictionary]:
	return [
		{
			"id": "B",
			"name": "Huntress density, owner target",
			"cell": P1AArt.PRODUCTION_CELL,
			"px_per_m": 64.0,
			"derived_from": "huntress",
			"status": "candidate",
			"note": "the owner's stated ~64 px/m. Tile 128 x 64; the 128 cell is exactly 2.000 m. The drawn Huntress then stands 1.688-1.734 m rather than 1.80 m.",
		},
		{
			"id": "C",
			"name": "Huntress density, exact-art derived",
			"cell": P1AArt.PRODUCTION_CELL,
			"px_per_m": 60.0,
			"derived_from": "huntress",
			"status": "candidate",
			"note": "derived from the art: the resting frames are 108 px, which at 60.0 px/m is exactly 1.800 m. Tile 120 x 60; the 128 cell is 2.133 m.",
		},
		{
			"id": "A",
			"name": "Mage density — REJECTED FOR PRODUCTION, retained as diagnostic",
			"cell": P1AArt.MAGE_CELL,
			"px_per_m": 32.0,
			"derived_from": "mage",
			"status": "rejected_for_production_retained_as_diagnostic",
			"note": "rejected by the owner in the supplemental pass. Kept so the earlier measurements stay reproducible and so the 64 px Mage art can still be displayed and diagnosed.",
		},
	]


## The production candidates only — what a shipping decision may choose between.
static func production_candidates() -> Array[Dictionary]:
	var out: Array[Dictionary] = []
	for c: Dictionary in candidates():
		if String(c["status"]) == "candidate":
			out.append(c)
	return out


## What each individual frame implies, rather than only the mean. The owner asked for
## this explicitly, and it is where the exact 108 px -> 1.800 m result becomes visible.
static func per_frame_px_per_m(measurements: Array[Dictionary]) -> Array[Dictionary]:
	var out: Array[Dictionary] = []
	for m: Dictionary in measurements:
		if bool(m.get("empty", true)):
			continue
		var body: int = int(m["body_h"])
		out.append({
			"label": m.get("label", ""),
			"body_px": body,
			"px_per_m_at_1_80": float(body) / P1AArt.BODY_HEIGHT_M,
			"metres_at_60": float(body) / 60.0,
			"metres_at_64": float(body) / 64.0,
		})
	return out


## What a candidate density implies for the isometric tile.
##
## The simulation is an ordinary Cartesian plane, so a "2:1 isometric tile" is a
## SCREEN-SPACE diamond laid over that plane, not a simulation lattice. A diamond of
## width `w` and height `h` covers `w * h / 2` square world pixels, and diamonds
## tessellate exactly. Requiring each tile to stand for a `TILE_GROUND_METRES` square
## of ground, at `h = w / 2`:
##
##     w * h / 2 = (S * px_per_m)^2  and  h = w / 2   =>   w = 2 * S * px_per_m
static func tile_proposal(px_per_m: float) -> Dictionary:
	var w: float = 2.0 * TILE_GROUND_METRES * px_per_m
	var h: float = w * 0.5
	return {
		"projection": "2:1 isometric diamond (Godot TileSet tile_shape = ISOMETRIC)",
		"tile_w": w, "tile_h": h,
		"ground_metres_per_tile": TILE_GROUND_METRES,
		"ground_area_px2": w * h * 0.5,
		"whole_pixels": is_equal_approx(w, roundf(w)) and is_equal_approx(h, roundf(h)),
	}


## The visible world, in metres, for a base resolution at a candidate density.
static func camera_footprint_m(base: Vector2i, px_per_m: float) -> Vector2:
	return Vector2(float(base.x) / px_per_m, float(base.y) / px_per_m)


## What the drawn body actually stands for, in metres, when it is displayed at an
## integral sprite scale under a chosen density. The reason this exists: doubling the
## Mage does NOT make him agree with the Huntress, and the tool has to say so.
static func effective_body_metres(body_px: float, sprite_scale: int, px_per_m: float) -> float:
	return body_px * float(sprite_scale) / px_per_m


## The drawn character's share of screen height. Independent of the window size:
## a base-resolution fraction is what the eye reads, whatever the window scales to.
static func actor_screen_fraction(body_px: float, base_height: int, sprite_scale: int) -> float:
	return body_px * float(sprite_scale) / float(base_height)


## Recompute the accepted 3D distances in pixels at a candidate density.
## ILLUSTRATIVE ONLY — see `ILLUSTRATIVE_3D_VALUES`.
static func illustrative_pixels(px_per_m: float) -> Dictionary:
	var out: Dictionary = {}
	for k: String in ILLUSTRATIVE_3D_VALUES.keys():
		out[k] = float(ILLUSTRATIVE_3D_VALUES[k]) * px_per_m
	return out
