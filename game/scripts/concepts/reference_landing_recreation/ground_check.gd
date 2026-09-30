extends SceneTree
## Reference Landing Recreation -- Session 2 headless check (NON-CANONICAL).
##
## Builds the ground layout onto a scratch (never-in-the-real-tree) Node3D,
## then runs two independent checks against the returned bookkeeping:
##
##   ID CHECK  -- every key `build()` reports having used is one of the twelve
##                approved payloads, typed independently here rather than
##                re-read from `ground_layout.gd`'s own constant, and the
##                approved set itself is exactly twelve entries.
##
##   GAP CHECK -- the important one. It does NOT trust `build()`'s own
##                `filled_cells` bookkeeping by construction; it walks a large,
##                generously-sized fixed (ix, iz) range on its own, calls
##                `ReferenceLandingGroundLayout.is_within_band()` itself for
##                every cell, and only THEN checks that every cell it
##                independently judged walkable is present in what `build()`
##                actually filled. Cells are 2 m, so by construction no
##                coverage gap this check would catch can exceed one module.
##
## Run with:
##   godot --headless --path game --import
##   godot --headless --path game --script res://scripts/concepts/reference_landing_recreation/ground_check.gd

## Typed independently of `ReferenceLandingGroundLayout.GROUND_PAYLOADS` on
## purpose -- the ID CHECK must not become "the file agrees with itself".
const APPROVED_KEYS: PackedStringArray = [
	"floor_tile_large",
	"floor_dirt",
	"floor_foundation_corner",
	"floor_foundation_front",
	"floor_tile_large_rocks",
	"floor_dirt_small",
	"floor_dirt_large_rocky",
	"floor_tile_small_weeds_A",
	"floor_tile_small",
	"floor_tile_small_broken_A",
	"floor_tile_small_broken_B",
	"floor_tile_small_corner",
]

## Generous fixed scan range for the GAP CHECK, covering the whole corridor
## (SPAWN at the origin, PORTAL at x = 48, z = -128) with wide margin on every
## side. Cells outside the true band are cheap to test and simply skipped.
const SCAN_IX_MIN: int = -20
const SCAN_IX_MAX: int = 40
const SCAN_IZ_MIN: int = -80
const SCAN_IZ_MAX: int = 10

const GRID_STEP: float = ReferenceLandingGroundLayout.GRID_STEP


func _initialize() -> void:
	print("=== Reference Landing Recreation -- Session 2 ground check ===")

	var scratch: Node3D = Node3D.new()
	var layout: ReferenceLandingGroundLayout = ReferenceLandingGroundLayout.new()
	var result: Dictionary = layout.build(scratch)

	var instances: int = int(result["instances"])
	var coverage_instances: int = int(result["coverage_instances"])
	var accent_instances: int = int(result["accent_instances"])
	var used_keys: Array = result["used_keys"]
	var filled_cells: Array = result["filled_cells"]

	print("")
	print("total ground pieces instanced: %d" % instances)
	print("  coverage instances: %d" % coverage_instances)
	print("  accent instances:   %d" % accent_instances)
	print("unique payload keys used: %d" % used_keys.size())
	for key in used_keys:
		print("  - %s" % String(key))

	# --- ID CHECK -------------------------------------------------------------
	print("")
	var id_ok: bool = true
	var id_failure: String = ""
	if ReferenceLandingGroundLayout.GROUND_PAYLOADS.size() != 12:
		id_ok = false
		id_failure = (
			"GROUND_PAYLOADS.size() == %d, expected 12"
			% ReferenceLandingGroundLayout.GROUND_PAYLOADS.size()
		)
	if id_ok:
		for key in used_keys:
			if not APPROVED_KEYS.has(String(key)):
				id_ok = false
				id_failure = String(key)
				break

	if id_ok:
		print("ID CHECK: PASS")
	else:
		print("ID CHECK: FAIL: %s" % id_failure)

	# --- GAP CHECK --------------------------------------------------------------
	print("")
	var checked: int = 0
	var walkable_count: int = 0
	var uncovered: Array[String] = []
	for iz: int in range(SCAN_IZ_MIN, SCAN_IZ_MAX + 1):
		for ix: int in range(SCAN_IX_MIN, SCAN_IX_MAX + 1):
			checked += 1
			var cx: float = (float(ix) + 0.5) * GRID_STEP
			var cz: float = (float(iz) + 0.5) * GRID_STEP
			if not ReferenceLandingGroundLayout.is_within_band(cx, cz):
				continue
			walkable_count += 1
			var key: String = ReferenceLandingGroundLayout.cell_key(ix, iz)
			if not filled_cells.has(key):
				uncovered.append(key)

	var gap_ok: bool = walkable_count > 0 and uncovered.is_empty()

	print("cells checked: %d" % checked)
	print("independently walkable cells: %d" % walkable_count)
	print("of those, not covered by build(): %d" % uncovered.size())

	if gap_ok:
		print(
			(
				"GAP CHECK: PASS (checked %d walkable cells, 0 uncovered; grid cells "
				+ "are 2 m, so by construction no coverage gap can exceed one ~2 m module)"
			) % walkable_count
		)
	else:
		var examples: Array[String] = []
		for i: int in range(mini(5, uncovered.size())):
			examples.append(uncovered[i])
		if walkable_count == 0:
			print("GAP CHECK: FAIL: 0 independently walkable cells -- the band is empty")
		else:
			print(
				"GAP CHECK: FAIL: %d uncovered cells, e.g. %s"
				% [uncovered.size(), ", ".join(examples)]
			)

	# --- Final verdict ------------------------------------------------------
	print("")
	scratch.free()

	if instances > 0 and id_ok and gap_ok:
		print("GROUND CHECK: PASS")
		quit(0)
	else:
		printerr("GROUND CHECK: FAIL")
		quit(1)
