extends SceneTree
## Reference Landing Recreation -- Session 4 headless check (NON-CANONICAL).
##
## Builds the Walls/PillarRank/Gate/Periphery layout onto a scratch (never-in-
## the-real-tree) Node3D, then runs four independent checks against the
## returned bookkeeping:
##
##   ID CHECK    -- every key `build()` reports having used is one of the
##                  nineteen approved Session 4 payloads, typed independently
##                  here rather than re-read from `architecture_layout.gd`'s
##                  own constants.
##
##   GATE CHECK  -- the arch's documented 3.000 m clear opening against the
##                  measured band width at PORTAL (expected: narrower, so the
##                  arch is correctly a landmark rather than the opening), and
##                  that both `wall_pillar` gate piers sit at or beyond the
##                  band's own half-width -- i.e. the PORTAL opening is left
##                  exactly as wide as Session 1 defined it, not narrowed by
##                  anything this session placed.
##
##   BAND CHECK  -- the important one, and EXHAUSTIVE rather than a sample:
##                  for EVERY instance `build()` placed (walls, pillar rank,
##                  gate, periphery -- everything), it calls
##                  `ReferenceLandingGroundLayout.is_within_band()` on that
##                  instance's own recorded (x, z) and requires it to be
##                  false -- nothing architecture-tier this session placed may
##                  land inside Session 1's walkable width band.
##
##   COUNT CHECK -- prints counts per payload key, grouped by builder, plus
##                  the breach-skip and dressing counts, so the numbers in the
##                  task brief's "print counts per piece type" are on screen.
##
## Run with:
##   godot --headless --path game --import
##   godot --headless --path game --script res://scripts/concepts/reference_landing_recreation/architecture_check.gd

const APPROVED_KEYS: PackedStringArray = [
	"pillar", "stairs_modular_center", "wall_Tsplit", "wall_arched", "wall_broken",
	"wall_cracked", "wall_endcap", "wall_half", "wall_half_endcap_sloped",
	"wall_open_scaffold", "wall_sloped", "rubble_half", "rubble_large", "column",
	"wall", "wall_pillar", "arch", "stone-wall-damaged", "stone-wall-column",
]


func _print_counts(label: String, counts: Dictionary) -> void:
	var total: int = 0
	for key: String in counts.keys():
		total += int(counts[key])
	print("%s: %d instances" % [label, total])
	for key: String in counts.keys():
		print("  - %s: %d" % [key, int(counts[key])])


func _initialize() -> void:
	print("=== Reference Landing Recreation -- Session 4 architecture & background check ===")

	var scratch: Node3D = Node3D.new()
	var layout: ReferenceLandingArchitectureLayout = ReferenceLandingArchitectureLayout.new()
	var result: Dictionary = layout.build(scratch)

	var counts: Dictionary = result["counts"]
	var placed: Array = result["placed"]

	# --- COUNT CHECK ----------------------------------------------------------
	print("")
	_print_counts("WALLS", result["wall_counts"])
	print("  wall-run slots skipped for a shared Session 3 breach: %d" % int(result["breach_skips"]))
	print("  Kenney damage-dressing accents added beside broken wall instances: %d" % int(result["dressing_count"]))
	print("")
	_print_counts("PILLAR RANK", result["pillar_counts"])
	print("")
	_print_counts("GATE", result["gate_counts"])
	print("")
	_print_counts("PERIPHERY", result["periphery_counts"])
	print("")
	print("TOTAL pieces placed this session: %d" % int(result["total_instances"]))

	# --- ID CHECK ---------------------------------------------------------------
	print("")
	var id_ok: bool = true
	var id_failure: String = ""
	if ReferenceLandingArchitectureLayout.PAYLOADS.size() != 19:
		id_ok = false
		id_failure = "PAYLOADS.size() == %d, expected 19" % ReferenceLandingArchitectureLayout.PAYLOADS.size()
	if id_ok:
		for key: String in counts.keys():
			if not APPROVED_KEYS.has(key):
				id_ok = false
				id_failure = "unapproved key: %s" % key
				break
	if id_ok:
		print("ID CHECK: PASS (19 declared payloads, every placed key approved)")
	else:
		print("ID CHECK: FAIL: %s" % id_failure)

	# --- GATE CHECK ---------------------------------------------------------------
	print("")
	var gate_arc: float = float(result["gate_arc"])
	var half_width: float = float(result["gate_half_width"])
	var opening_width: float = float(result["gate_opening_width"])
	var arch_clear: float = float(result["arch_clear_opening"])
	var arch_fits: bool = bool(result["arch_fits_as_opening"])
	print("PORTAL arc length: %.3f m" % gate_arc)
	print("band width Session 1 defines there: %.3f m (half-width %.3f m each side)" % [opening_width, half_width])
	print("arch.gltf documented clear opening: %.3f m" % arch_clear)
	if arch_fits:
		print("arch clear opening >= band width: arch COULD have been the literal opening (unexpected for this route)")
	else:
		print("arch clear opening < band width: arch correctly placed as a landmark, not the opening (matches Riftfall Landing's own D-209 precedent)")

	var pier_left: Vector3 = result["pier_left"]
	var pier_right: Vector3 = result["pier_right"]
	var left_info: Dictionary = ReferenceLandingGroundLayout.closest_on_centerline(pier_left.x, pier_left.z)
	var right_info: Dictionary = ReferenceLandingGroundLayout.closest_on_centerline(pier_right.x, pier_right.z)
	var left_clear: bool = float(left_info["distance"]) >= half_width
	var right_clear: bool = float(right_info["distance"]) >= half_width
	print("left wall_pillar pier: %.3f m from centreline (band half-width %.3f m) -- %s" % [
		float(left_info["distance"]), half_width, "clear" if left_clear else "INTRUDES",
	])
	print("right wall_pillar pier: %.3f m from centreline (band half-width %.3f m) -- %s" % [
		float(right_info["distance"]), half_width, "clear" if right_clear else "INTRUDES",
	])

	var gate_ok: bool = (not arch_fits) and left_clear and right_clear
	if gate_ok:
		print("GATE CHECK: PASS (PORTAL opening left at the full %.3f m Session 1 defines; arch correctly a landmark)" % opening_width)
	else:
		print("GATE CHECK: FAIL")

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

	# --- Final verdict --------------------------------------------------------------
	print("")
	scratch.free()

	if id_ok and gate_ok and band_ok:
		print("ARCHITECTURE & BACKGROUND CHECK: PASS")
		quit(0)
	else:
		printerr("ARCHITECTURE & BACKGROUND CHECK: FAIL")
		quit(1)
