extends SceneTree
## Reference Landing Recreation -- Session 5 headless check (NON-CANONICAL).
##
## Builds the DeadTrees/LanternFill/WallBanners/Clutter layout onto a scratch
## (never-in-the-real-tree) Node3D, then runs four independent checks against
## the returned bookkeeping:
##
##   ID CHECK    -- every key `build()` reports having used is one of the
##                  fourteen approved Session 5 payloads, typed independently
##                  here rather than re-read from `props_layout.gd`'s own
##                  constants.
##
##   MOUNT CHECK -- both wall-mount targets were found on a real Session 4
##                  wall (`_find_wall_mount_targets()` did not fail loudly),
##                  the SPAWN target's arc is smaller than the PORTAL
##                  target's, and both mounted banners sit a plausible small
##                  distance (0.05-3.0 m) inward of their own wall's centre --
##                  large enough to prove the mount actually moved off the
##                  wall's own point, small enough to prove it did not fly off
##                  into open space.
##
##   BAND CHECK  -- the important one, and EXHAUSTIVE rather than a sample:
##                  for EVERY instance `build()` placed (trees, lantern fill,
##                  both wall-mounted banners, clutter -- everything), it
##                  calls `ReferenceLandingGroundLayout.is_within_band()` on
##                  that instance's own recorded (x, z) and requires it to be
##                  false -- nothing this session placed may land inside
##                  Session 1's walkable width band.
##
##   COUNT CHECK -- prints counts per payload key, grouped by builder, so the
##                  numbers in the task brief's "print prop counts by type"
##                  are on screen.
##
## Run with:
##   godot --headless --path game --import
##   godot --headless --path game --script res://scripts/concepts/reference_landing_recreation/props_check.gd

const APPROVED_KEYS: PackedStringArray = [
	"banner_shield_red", "tree_dead_small", "shrine", "barrel_large",
	"sword_shield_broken", "sword_shield", "box_large", "torch_mounted", "box_small",
	"Tree_Bare_1_C_Color1", "Tree_Bare_2_C_Color1", "tree_dead_large",
	"lantern_standing", "debris",
]


func _print_counts(label: String, counts: Dictionary) -> void:
	var total: int = 0
	for key: String in counts.keys():
		total += int(counts[key])
	print("%s: %d instances" % [label, total])
	for key: String in counts.keys():
		print("  - %s: %d" % [key, int(counts[key])])


func _initialize() -> void:
	print("=== Reference Landing Recreation -- Session 5 props & atmosphere check ===")

	var scratch: Node3D = Node3D.new()
	var layout: ReferenceLandingPropsLayout = ReferenceLandingPropsLayout.new()
	var result: Dictionary = layout.build(scratch)

	var counts: Dictionary = result["counts"]
	var placed: Array = result["placed"]

	# --- COUNT CHECK ------------------------------------------------------------
	print("")
	_print_counts("DEAD TREES", result["tree_counts"])
	print("")
	_print_counts("LANTERN FILL", result["lantern_counts"])
	print("")
	_print_counts("WALL BANNERS", result["banner_counts"])
	print("")
	_print_counts("CLUTTER", result["clutter_counts"])
	print("")
	print("TOTAL pieces placed this session: %d" % int(result["total_instances"]))
	print("(torch_mounted declared, measured and cross-checked, deliberately unused -- see class doc comment)")

	# --- ID CHECK -----------------------------------------------------------------
	print("")
	var id_ok: bool = true
	var id_failure: String = ""
	if ReferenceLandingPropsLayout.PAYLOADS.size() != 14:
		id_ok = false
		id_failure = "PAYLOADS.size() == %d, expected 14" % ReferenceLandingPropsLayout.PAYLOADS.size()
	if id_ok:
		for key: String in counts.keys():
			if not APPROVED_KEYS.has(key):
				id_ok = false
				id_failure = "unapproved key: %s" % key
				break
	if id_ok:
		print("ID CHECK: PASS (14 declared payloads, every placed key approved)")
	else:
		print("ID CHECK: FAIL: %s" % id_failure)

	# --- MOUNT CHECK ----------------------------------------------------------------
	print("")
	var spawn_wall: Dictionary = result["banner_spawn_wall"]
	var portal_wall: Dictionary = result["banner_portal_wall"]
	var candidate_count: int = int(result["wall_candidate_count"])
	print("standing-wall instances found in Session 4's real output (wall/wall_Tsplit/wall_cracked): %d" % candidate_count)
	print("SPAWN-side mount wall: %s at arc %.3f m (x=%.2f, z=%.2f)" % [
		String(spawn_wall["key"]), float(spawn_wall["arc"]), float(spawn_wall["x"]), float(spawn_wall["z"]),
	])
	print("PORTAL-side mount wall: %s at arc %.3f m (x=%.2f, z=%.2f)" % [
		String(portal_wall["key"]), float(portal_wall["arc"]), float(portal_wall["x"]), float(portal_wall["z"]),
	])

	var mount_ok: bool = candidate_count > 0 and float(spawn_wall["arc"]) < float(portal_wall["arc"])
	var mount_failure: String = "" if mount_ok else "SPAWN-side arc must be smaller than PORTAL-side arc"

	var banners: Array = []
	for entry: Dictionary in placed:
		if String(entry["key"]) == "banner_shield_red":
			banners.append(entry)
	if banners.size() != 2:
		mount_ok = false
		mount_failure = "expected exactly 2 mounted banner_shield_red, found %d" % banners.size()
	else:
		var walls: Array[Dictionary] = [spawn_wall, portal_wall]
		for i: int in range(2):
			var banner: Dictionary = banners[i]
			var wall: Dictionary = walls[i]
			var dx: float = float(banner["x"]) - float(wall["x"])
			var dz: float = float(banner["z"]) - float(wall["z"])
			var distance: float = sqrt(dx * dx + dz * dz)
			var plausible: bool = distance >= 0.05 and distance <= 3.0
			print("banner %d sits %.3f m from its own wall's centre -- %s" % [
				i, distance, "plausible" if plausible else "IMPLAUSIBLE",
			])
			if not plausible:
				mount_ok = false
				mount_failure = "banner %d sits %.3f m from its own wall, expected 0.05-3.0 m" % [i, distance]

	if mount_ok:
		print("MOUNT CHECK: PASS")
	else:
		print("MOUNT CHECK: FAIL: %s" % mount_failure)

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

	if id_ok and mount_ok and band_ok:
		print("PROPS & ATMOSPHERE CHECK: PASS")
		quit(0)
	else:
		printerr("PROPS & ATMOSPHERE CHECK: FAIL")
		quit(1)
