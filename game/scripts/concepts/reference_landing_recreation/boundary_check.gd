extends SceneTree
## Reference Landing Recreation -- Session 3 headless check (NON-CANONICAL).
##
## Builds the Roads/Boundaries layout onto a scratch (never-in-the-real-tree)
## Node3D, then runs three independent checks against the returned bookkeeping:
##
##   ID CHECK   -- every key `build()` reports having used is one of the nineteen
##                 approved Roads/Boundaries payloads, typed independently here
##                 rather than re-read from `boundary_layout.gd`'s own constants.
##
##   BAND CHECK -- the important one, and EXHAUSTIVE rather than a sample: for
##                 EVERY instance `build()` placed (not a handful), it calls
##                 `ReferenceLandingGroundLayout.is_within_band()` on that
##                 instance's own recorded (x, z) and requires it to be false --
##                 nothing this session placed may land inside Session 1's
##                 walkable width band.
##
##   COUNT CHECK -- prints Roads and Boundaries counts per payload key, plus the
##                  corner, lantern and breach-skip counts, so the numbers in the
##                  task brief's "print counts per category" are on screen.
##
## Run with:
##   godot --headless --path game --import
##   godot --headless --path game --script res://scripts/concepts/reference_landing_recreation/boundary_check.gd

const APPROVED_ROAD_KEYS: PackedStringArray = [
	"barrier_colum_half",
	"barrier_column",
	"barrier_corner",
	"barrier",
	"barrier_half",
	"plaque",
]

const APPROVED_BOUNDARY_KEYS: PackedStringArray = [
	"fence",
	"fence_pillar",
	"post",
	"post_lantern",
	"Rock_1_H_Color1",
	"Rock_2_F_Color1",
	"Rock_3_R_Color1",
	"Rock_3_K_Color1",
	"fence_broken",
	"fence_pillar_broken",
	"Rock_1_A_Color1",
	"Rock_1_Q_Color1",
	"Rock_3_A_Color1",
]


func _initialize() -> void:
	print("=== Reference Landing Recreation -- Session 3 roads & boundaries check ===")

	var scratch: Node3D = Node3D.new()
	var layout: ReferenceLandingBoundaryLayout = ReferenceLandingBoundaryLayout.new()
	var result: Dictionary = layout.build(scratch)

	var road_counts: Dictionary = result["road_counts"]
	var boundary_counts: Dictionary = result["boundary_counts"]
	var placed: Array = result["placed"]

	# --- COUNT CHECK ------------------------------------------------------------
	print("")
	print("ROADS: %d instances" % int(result["road_instances"]))
	for key: String in road_counts.keys():
		print("  - %s: %d" % [key, int(road_counts[key])])
	print("  of which barrier_corner (bend markers): %d" % int(result["corner_count"]))

	print("")
	print("BOUNDARIES: %d instances" % int(result["boundary_instances"]))
	for key: String in boundary_counts.keys():
		print("  - %s: %d" % [key, int(boundary_counts[key])])
	var lantern_positions: Array = result["lantern_positions"]
	print("  of which post_lantern (Session 5 rhythm): %d" % int(boundary_counts.get("post_lantern", 0)))
	for pos: Vector3 in lantern_positions:
		print("      lantern at %s" % pos)
	print("  boundary-fill slots skipped for a deliberate breach: %d" % int(result["breach_skips"]))

	print("")
	print("total pieces placed this session: %d" % placed.size())

	# --- ID CHECK -----------------------------------------------------------------
	print("")
	var id_ok: bool = true
	var id_failure: String = ""
	if ReferenceLandingBoundaryLayout.ROAD_PAYLOADS.size() != 6:
		id_ok = false
		id_failure = "ROAD_PAYLOADS.size() == %d, expected 6" % ReferenceLandingBoundaryLayout.ROAD_PAYLOADS.size()
	if id_ok and ReferenceLandingBoundaryLayout.BOUNDARY_PAYLOADS.size() != 13:
		id_ok = false
		id_failure = "BOUNDARY_PAYLOADS.size() == %d, expected 13" % ReferenceLandingBoundaryLayout.BOUNDARY_PAYLOADS.size()
	if id_ok:
		for key: String in road_counts.keys():
			if not APPROVED_ROAD_KEYS.has(key):
				id_ok = false
				id_failure = "unapproved road key: %s" % key
				break
	if id_ok:
		for key: String in boundary_counts.keys():
			if not APPROVED_BOUNDARY_KEYS.has(key):
				id_ok = false
				id_failure = "unapproved boundary key: %s" % key
				break

	if id_ok:
		print("ID CHECK: PASS")
	else:
		print("ID CHECK: FAIL: %s" % id_failure)

	# --- BAND CHECK (exhaustive) --------------------------------------------------
	print("")
	var overlaps: Array[String] = []
	for entry: Dictionary in placed:
		var x: float = float(entry["x"])
		var z: float = float(entry["z"])
		if ReferenceLandingGroundLayout.is_within_band(x, z):
			overlaps.append("%s at (%.2f, %.2f)" % [String(entry["key"]), x, z])

	var band_ok: bool = placed.size() > 0 and overlaps.is_empty()
	print("instances checked against the walkable band: %d" % placed.size())
	print("of those, overlapping the band: %d" % overlaps.size())
	if band_ok:
		print("BAND CHECK: PASS (checked all %d placed instances, 0 overlap the walkable band)" % placed.size())
	else:
		var examples: Array[String] = []
		for i: int in range(mini(5, overlaps.size())):
			examples.append(overlaps[i])
		if placed.size() == 0:
			print("BAND CHECK: FAIL: nothing was placed")
		else:
			print("BAND CHECK: FAIL: %d overlaps, e.g. %s" % [overlaps.size(), ", ".join(examples)])

	# --- Final verdict ------------------------------------------------------------
	print("")
	scratch.free()

	if id_ok and band_ok:
		print("ROADS & BOUNDARIES CHECK: PASS")
		quit(0)
	else:
		printerr("ROADS & BOUNDARIES CHECK: FAIL")
		quit(1)
