extends SceneTree
## Riftwrought — P1A: emit the machine-readable measurement report.
##
## Everything here is read from `P1AArt`, `P1AScale`, `P1ARenderMode` and `P1APan`, so
## the JSON and the verification cannot drift apart: they call the same functions.
##
## Usage:
##   Godot --headless --path game2d --script res://tools/p1a_report.gd -- --out <file.json>
## Run WITHOUT `--headless` to have the display facts read from the owner's real display
## rather than from the headless driver.

const STANCE_BANDS: Array = [[0.75, 0.95], [0.70, 1.00], [0.80, 0.92]]


func _initialize() -> void:
	_main.call_deferred()


func _main() -> void:
	var args: PackedStringArray = OS.get_cmdline_user_args()
	var out_path: String = ""
	for i: int in range(args.size() - 1):
		if args[i] == "--out":
			out_path = args[i + 1]
	var report: Dictionary = {
		"report": "riftwrought_p1a_character_scale_and_rendering",
		"status": "DELIVERED AND OPEN — not accepted",
		"godot": Engine.get_version_info().get("string", "?"),
		"headless": DisplayServer.get_name() == "headless",
		"display": _display(),
		"art": _art(),
		"density": _density(),
		"render_matrix": _matrix(),
		"pan": _pan(),
		"tile_proposal": _tiles(),
		"base_resolution_fit": _base_fit(),
		"ground_contact": _ground_contact(),
		"anchor_candidates": _anchors(),
		"base_candidates_with_the_native_huntress": _base_candidates(),
		"owner_decisions_outstanding": [
			"the production anchor: the cell centre (64, 122) or the drawn feet centre (58, 122), and whether a 128 cell is wide enough for feet-centred registration",
			"the seven missing Huntress facing exports — P1A cannot close without them",
			"the rendering approach",
			"the base resolution",
			"the single shared px/m, given the measured 1.879x density difference",
			"the tile projection and tile dimensions",
			"the anchor correction to the exported Mage art",
		],
	}
	var text: String = JSON.stringify(report, "  ", false)
	if out_path.is_empty():
		print(text)
	else:
		var f: FileAccess = FileAccess.open(out_path, FileAccess.WRITE)
		if f == null:
			printerr("could not write %s" % out_path)
			quit(1)
			return
		f.store_string(text + "\n")
		f.close()
		print("wrote %s (%d bytes)" % [out_path, text.length() + 1])
	quit(0)


func _display() -> Dictionary:
	var screens: Array = []
	for i: int in range(DisplayServer.get_screen_count()):
		screens.append({
			"index": i,
			"size": [DisplayServer.screen_get_size(i).x, DisplayServer.screen_get_size(i).y],
			"usable_rect": [DisplayServer.screen_get_usable_rect(i).position.x,
				DisplayServer.screen_get_usable_rect(i).position.y,
				DisplayServer.screen_get_usable_rect(i).size.x,
				DisplayServer.screen_get_usable_rect(i).size.y],
			"scale": DisplayServer.screen_get_scale(i),
			"dpi": DisplayServer.screen_get_dpi(i),
			"refresh_rate": DisplayServer.screen_get_refresh_rate(i),
			"is_primary": i == DisplayServer.get_primary_screen(),
		})
	return {
		"driver": DisplayServer.get_name(),
		"screen_count": DisplayServer.get_screen_count(),
		"primary_screen": DisplayServer.get_primary_screen(),
		"screens": screens,
		"window_size": [DisplayServer.window_get_size().x, DisplayServer.window_get_size().y],
	}


func _art() -> Dictionary:
	var out: Dictionary = {}
	for character: String in ["mage", "huntress"]:
		var img: Image = P1AArt.load_sheet_image(character)
		var frames: Array = []
		var measurements: Array[Dictionary] = P1AArt.measure_character(character)
		for m: Dictionary in measurements:
			var entry: Dictionary = m.duplicate()
			var bands: Array = []
			for band: Array in STANCE_BANDS:
				var s: Dictionary = P1AArt.stance_extent(img,
					P1AArt.cell_rect(character, int(m["index"])),
					int(m["head_top"]), int(m["body_h"]), float(band[0]), float(band[1]))
				bands.append({
					"band": band, "x0": s["x0"], "x1": s["x1"], "mid": s["mid"],
					"rows": [s["row_low"], s["row_high"]],
				})
			entry["stance_bands"] = bands
			entry["pin_tuple"] = [int(m["drawn_x0"]), int(m["drawn_y0"]), int(m["drawn_x1"]),
				int(m["drawn_y1"]), int(m["head_top"]), int(m["ground_row"]), int(m["body_h"]),
				int(m["stance_x0"]), int(m["stance_x1"])]
			frames.append(entry)
		out[character] = {
			"source_copy": P1AArt.sheet_path(character),
			"sha256_recorded": P1AArt.MAGE_SHEET_SHA256 if character == "mage" else P1AArt.HUNTRESS_SHEET_SHA256,
			"sha256_now": FileAccess.get_sha256(P1AArt.sheet_path(character)),
			"sheet_size": [img.get_width(), img.get_height()],
			"cell": P1AArt.cell_size(character),
			"frame_count": P1AArt.frame_count(character),
			"exported_directions": (8 if character == "mage" else 1),
			"frames": frames,
		}
	return out


func _density() -> Dictionary:
	var mage: Dictionary = P1AScale.measured_px_per_m(P1AArt.measure_character("mage"))
	var huntress: Dictionary = P1AScale.measured_px_per_m(P1AArt.measure_character("huntress"))
	var cands: Array = []
	for c: Dictionary in P1AScale.candidates():
		var px: float = float(c["px_per_m"])
		var measured: float = float((mage if String(c["derived_from"]) == "mage" else huntress)["px_per_m_mean"])
		cands.append({
			"id": c["id"], "name": c["name"], "cell": c["cell"], "px_per_m": px,
			"derived_from": c["derived_from"],
			"measured_px_per_m": measured,
			"deviation_percent": (px - measured) / measured * 100.0,
			"cell_width_m": float(int(c["cell"])) / px,
			"illustrative_3d_values_in_px": P1AScale.illustrative_pixels(px),
		})
	return {
		"body_height_reference_m": P1AArt.BODY_HEIGHT_M,
		"mage": mage, "huntress": huntress,
		"ratio_huntress_over_mage": float(huntress["px_per_m_mean"]) / float(mage["px_per_m_mean"]),
		"candidates": cands,
		"note": "Not averaged. The two characters are drawn at materially different densities and the choice is the owner's.",
	}


func _matrix() -> Array:
	var rows: Array = []
	var windows: Array[Vector2i] = [
		Vector2i(1280, 720), Vector2i(1920, 1080), Vector2i(2560, 1440), Vector2i(3840, 2160),
	]
	for i: int in range(DisplayServer.get_screen_count()):
		var s: Vector2i = DisplayServer.screen_get_size(i)
		if s.x > 0 and s.y > 0 and not windows.has(s):
			windows.append(s)
	var bases: Array[Vector2i] = [
		Vector2i(960, 540), Vector2i(1280, 720), Vector2i(1600, 900),
		Vector2i(1920, 1080), Vector2i(2560, 1440),
	]
	for c: Dictionary in P1AScale.candidates():
		var px: float = float(c["px_per_m"])
		var body: float = float(P1AScale.measured_px_per_m(
			P1AArt.measure_character(String(c["derived_from"])))["body_h_mean"])
		for base: Vector2i in bases:
			for w: Vector2i in windows:
				for approach: int in range(P1ARenderMode.APPROACH_IDS.size()):
					var d: Dictionary = P1ARenderMode.describe(approach, w, base, px, body, 1)
					d["density_candidate"] = c["id"]
					d["drawn_body_px"] = body
					rows.append(d)
	return rows


func _pan() -> Dictionary:
	var samples: Array = []
	for frame: int in [0, 1, 60, 150, 299, 300]:
		var row: Dictionary = {"frame": frame, "elapsed_s": P1APan.elapsed_s(frame)}
		var t: Vector2 = P1APan.target(frame, 32.0, Vector2.ZERO)
		row["target_px_at_32_px_per_m"] = [t.x, t.y]
		for approach: int in range(P1ARenderMode.APPROACH_IDS.size()):
			var s: Dictionary = P1APan.snapped(approach, frame, 32.0, Vector2.ZERO)
			row[P1ARenderMode.APPROACH_IDS[approach]] = {
				"camera": [(s["camera"] as Vector2).x, (s["camera"] as Vector2).y],
				"remainder": [(s["remainder"] as Vector2).x, (s["remainder"] as Vector2).y],
			}
		samples.append(row)
	return {
		"duration_s": P1APan.DURATION_S, "frames": P1APan.FRAME_COUNT,
		"step_s": P1APan.STEP_S, "speed_mps": P1APan.SPEED_MPS,
		"direction": [P1APan.DIRECTION.x, P1APan.DIRECTION.y],
		"speed_note": "5.0 m/s is the ACCEPTED 3D maximum movement speed, used illustratively. P1A canonizes no 2D value.",
		"samples": samples,
	}


## Which candidate base resolutions scale onto which target panels by a WHOLE number,
## and what each one costs in bars. This is the arithmetic behind A8, and it is the
## reason A8 is a finding rather than an input: a base resolution is not chosen by
## taste, it is chosen against the panels it has to land on.
func _base_fit() -> Array:
	var targets: Array[Vector2i] = [
		Vector2i(1280, 720), Vector2i(1920, 1080), Vector2i(2560, 1440),
		Vector2i(3440, 1440), Vector2i(3840, 2160), Vector2i(5120, 2880),
	]
	for i: int in range(DisplayServer.get_screen_count()):
		var sz: Vector2i = DisplayServer.screen_get_size(i)
		if sz.x > 0 and not targets.has(sz):
			targets.append(sz)
	var bases: Array[Vector2i] = [
		Vector2i(640, 360), Vector2i(854, 480), Vector2i(960, 540), Vector2i(1280, 720),
		Vector2i(1600, 900), Vector2i(1920, 1080), Vector2i(2560, 1440),
	]
	var out: Array = []
	for base: Vector2i in bases:
		var exact: Array = []
		var rows: Array = []
		for t: Vector2i in targets:
			var s: int = P1ARenderMode.integer_scale(t, base)
			var bars: Vector2i = Vector2i(t.x - base.x * s, t.y - base.y * s)
			var is_exact: bool = bars == Vector2i.ZERO
			if is_exact:
				exact.append("%dx%d" % [t.x, t.y])
			rows.append({
				"target": [t.x, t.y], "integer_scale": s,
				"bars": [bars.x, bars.y], "exact": is_exact,
				"wasted_area_fraction": 1.0 - float(base.x * s * base.y * s) / float(maxi(1, t.x * t.y)),
			})
		out.append({
			"base": [base.x, base.y],
			"aspect": float(base.x) / float(base.y),
			"exact_on": exact,
			"exact_count": exact.size(),
			"targets": rows,
		})
	return out


## What each character actually stands on, and what the provisional anchor measures
## against it. Reported, never locked.
func _ground_contact() -> Dictionary:
	var out: Dictionary = {}
	for character: String in ["mage", "huntress"]:
		var rows: Array = []
		for m: Dictionary in P1AArt.measure_character(character):
			if bool(m.get("empty", true)):
				continue
			rows.append({
				"label": m["label"], "ground_row": m["ground_row"], "runs": m["ground_runs"],
				"x0": m["ground_x0"], "x1": m["ground_x1"], "mid": m["ground_mid"],
				"footprint_px": m["ground_width"],
				"footprint_m_at_64": float(int(m["ground_width"])) / 64.0,
				"footprint_m_at_60": float(int(m["ground_width"])) / 60.0,
			})
		out[character] = rows
	return out


func _anchors() -> Array:
	var huntress: Array[Dictionary] = P1AArt.measure_character("huntress")
	if huntress.is_empty():
		return []
	var ground_row: int = int(huntress[0]["ground_row"])
	var feet: float = float(huntress[0]["ground_mid"])
	var cell: int = P1AArt.HUNTRESS_CELL
	return [
		{"id": "rule_below_ground", "anchor": [cell / 2, ground_row + 1],
			"offset_from_drawn_feet_px": feet - float(cell / 2),
			"note": "the original P1A rule: the cell's horizontal centre, the row below the ground row"},
		{"id": "provisional_on_ground", "anchor": [cell / 2, ground_row],
			"offset_from_drawn_feet_px": feet - float(cell / 2),
			"note": "the (64, 122) the supplemental pass was asked to TEST. Not locked."},
		{"id": "measured_feet", "anchor": [int(round(feet)), ground_row],
			"offset_from_drawn_feet_px": 0.0,
			"note": "where the drawn boots actually are. Content spans x %d..%d, so registering the feet on the cell centre would push it to %d — outside a %d cell."
				% [int(huntress[0]["drawn_x0"]), int(huntress[0]["drawn_x1"]),
					int(huntress[0]["drawn_x1"]) + int(float(cell / 2) - feet), cell]},
	]


## The three base candidates the supplemental pass names, measured against the NATIVE
## Huntress at each production density. Actor fractions depend only on the base height;
## the visible world depends only on px/m.
func _base_candidates() -> Array:
	var body: float = float(P1AScale.measured_px_per_m(P1AArt.measure_character("huntress"))["body_h_mean"])
	var out: Array = []
	for base: Vector2i in [Vector2i(1280, 720), Vector2i(1600, 900), Vector2i(1920, 1080)]:
		for c: Dictionary in P1AScale.production_candidates():
			var px: float = float(c["px_per_m"])
			var extent: Vector2 = P1AScale.camera_footprint_m(base, px)
			var tile: Dictionary = P1AScale.tile_proposal(px)
			out.append({
				"base": [base.x, base.y], "density_candidate": c["id"], "px_per_m": px,
				"visible_world_m": [extent.x, extent.y],
				"visible_tiles": extent.x * extent.y / P1AScale.TILE_GROUND_METRES
					/ P1AScale.TILE_GROUND_METRES,
				"tile_px": [tile["tile_w"], tile["tile_h"]],
				"huntress_fraction_of_content_height": body / float(base.y),
				"huntress_metres": body / px,
				"vs_accepted_3d_camera_footprint": [
					extent.x / P1AScale.ACCEPTED_3D_CAMERA_FOOTPRINT_M.x - 1.0,
					extent.y / P1AScale.ACCEPTED_3D_CAMERA_FOOTPRINT_M.y - 1.0],
			})
	return out


func _tiles() -> Array:
	var out: Array = []
	for c: Dictionary in P1AScale.candidates():
		var t: Dictionary = P1AScale.tile_proposal(float(c["px_per_m"]))
		t["status_of_density"] = c["status"]
		t["density_candidate"] = c["id"]
		t["px_per_m"] = c["px_per_m"]
		t["character_cell_px"] = c["cell"]
		t["character_cell_m"] = float(int(c["cell"])) / float(c["px_per_m"])
		t["status"] = "PROPOSAL for P1B, pending P1A acceptance. No TileSet exists."
		out.append(t)
	return out
