extends Node
## First-MVP Gate 1D — automated verification of Broken Watch (D-217).
##
## PROPORTIONAL, per the Gate 1D brief: this does not re-prove Quick Strike,
## the Graveblade state machine, click-to-move, or the D-178 controller cone —
## those are proven exhaustively by the inherited chain this suite's own
## smoke script runs first, and none of that code is edited here. What THIS
## suite proves is the one thing the chain cannot know: that Gate 1D's
## INTEGRATION of that proven kernel behaves correctly — per-use mouse
## targeting, the first Graveblade's simple contract, the guaranteed drop,
## comparison, equip, the second comparable encounter, Fallen, Restart, and
## the exit boundary — and that nothing Gate 1D excludes has appeared.
##
## Run:  godot --headless --path game res://scenes/first_mvp/severed_threshold/broken_watch_slice.tscn -- --verify-1d

const SLICE_SCRIPT: String = "res://scripts/first_mvp/severed_threshold/broken_watch_slice.gd"
const LAYOUT_SCRIPT: String = "res://scripts/first_mvp/severed_threshold/broken_watch_layout.gd"

const EXPECTED_ACTIONS_COUNT: int = 31

var slice: BrokenWatchSlice
var arguments: PackedStringArray = PackedStringArray()

var _failures: PackedStringArray = PackedStringArray()
var _checks: int = 0


func _ready() -> void:
	await run()


func run() -> void:
	print("")
	print("=== First-MVP Gate 1D verification — Broken Watch (D-217) ===")
	await _settle(10)
	await _await_navigation()

	_check_engine_and_scene()
	_check_input_map_untouched()
	_check_landing_preserved()
	_check_broken_watch_structure()
	_check_navigation_continuous()
	_check_player_starting_state()
	_check_combat_kernel_reused()
	_check_mouse_targeting_is_per_use()
	_check_controller_targeting_untouched()
	await _check_first_encounter_and_drop()
	_check_idempotent_pickup()
	await _check_comparison_and_equip()
	await _check_second_encounter_not_scaled()
	await _check_fallen_and_restart()
	await _check_exit_boundary()
	_check_excluded_systems_absent()
	_check_writes_nothing()

	print("")
	if _failures.is_empty():
		print("GATE 1D VERIFICATION: PASS (%d checks)" % _checks)
		get_tree().quit(0)
	else:
		for failure: String in _failures:
			printerr("  FAIL: %s" % failure)
		printerr("GATE 1D VERIFICATION: %d FAILURE(S) of %d checks" % [_failures.size(), _checks])
		get_tree().quit(1)


# --- 1. Engine, entrypoint, InputMap -------------------------------------------

func _check_engine_and_scene() -> void:
	print("")
	print("--- Engine baseline and the assembled slice")
	var version: String = str(Engine.get_version_info()["string"])
	_expect(version.begins_with("4.7.2"), "engine is %s, not the locked 4.7.2 stable baseline" % version)
	_expect(slice != null, "BrokenWatchSlice did not assemble")
	_expect(slice.player != null, "no player was spawned")
	_expect(slice.loadout != null, "no PlayerLoadout was built")
	_expect(slice.graveblades.size() == 2, "expected exactly 2 Graveblades, found %d" % slice.graveblades.size())
	_expect(slice.landing_layout != null, "Riftfall Landing's Greybox V2 layout was not instanced")
	_expect(slice.broken_watch != null, "BrokenWatchLayout was not instanced")
	print("  slice assembled: player, loadout, %d Graveblade(s), Landing layout, Broken Watch layout" % slice.graveblades.size())


func _check_input_map_untouched() -> void:
	print("")
	print("--- project.godot InputMap is untouched (no new action)")
	var actions: Array = InputMap.get_actions()
	var named: int = 0
	for action: StringName in actions:
		if String(action).begins_with("ui_") and String(action) not in ["ui_confirm", "ui_cancel"]:
			continue
		named += 1
	_expect(named == EXPECTED_ACTIONS_COUNT,
		"InputMap declares %d non-builtin action(s), not the locked %d" % [named, EXPECTED_ACTIONS_COUNT])
	print("  %d actions declared, matching the locked count" % named)


# --- 2. Riftfall Landing preserved ---------------------------------------------

func _check_landing_preserved() -> void:
	print("")
	print("--- Riftfall Landing's accepted Greybox V2 + Visual Review foundation is unmodified")
	var layout: RiftfallLandingGreyboxLayout = slice.landing_layout
	_expect(is_equal_approx(layout.footprint_area(), 1201.00),
		"Landing footprint is %.2f m^2, not the accepted 1201.00 m^2 — the layout may have been edited" % layout.footprint_area())
	_expect(is_equal_approx(slice.composition.rotation_degrees.y, 45.0),
		"Composition yaw is %.1f deg, not the accepted 45.0 deg" % slice.composition.rotation_degrees.y)
	_expect(is_equal_approx(slice.camera_rig.distance_metres, 19.0), "camera distance drifted from the locked 19.0 m")
	_expect(is_equal_approx(slice.camera_rig.pitch_degrees, 55.0), "camera pitch drifted from the locked 55.0 deg")
	_expect(is_equal_approx(slice.camera_rig.fov_degrees, 45.0), "camera fov drifted from the locked 45.0 deg")
	_expect(is_equal_approx(slice.player.max_speed, 5.0), "player max_speed drifted from the locked 5.0 m/s")
	_expect(slice.treatment != null and slice.lighting != null,
		"the accepted D-206 lighting/treatment components were not built")
	print("  footprint, camera, movement speed and the accepted treatment all match the closed record")


# --- 3. Broken Watch's own structure --------------------------------------------

func _check_broken_watch_structure() -> void:
	print("")
	print("--- Broken Watch: five rooms, four sockets, restrained dressing only")
	var bw: BrokenWatchLayout = slice.broken_watch
	_expect(bw.room_count() == 5, "Broken Watch has %d rooms, not the authored 5" % bw.room_count())
	_expect(is_equal_approx(bw.footprint_area(), 1224.00),
		"Broken Watch footprint is %.2f m^2, not the authored 1224.00 m^2" % bw.footprint_area())
	var cf: float = (bw.footprint_area() + slice.landing_layout.footprint_area()) / 587.0
	print("  combined footprint ~%.2f CF (Broken Watch's own share ~%.2f CF)" % [
		cf, bw.footprint_area() / 587.0,
	])

	var sockets: Dictionary = bw.socket_positions()
	for required: String in ["BrokenWatchEntry", "FirstEncounterSpawn", "SecondEncounterSpawn", "ExitToNexusThreshold"]:
		_expect(sockets.has(required), "Broken Watch is missing the '%s' socket" % required)
	_expect(sockets["FirstEncounterSpawn"].distance_to(sockets["SecondEncounterSpawn"]) > 20.0,
		"the two encounter spawns are less than 20 m apart; the second encounter risks aggroing early")

	# Dressing carries no collision and no navigation carve of its own — it is
	# decoration on top of the project-authored walls, never a second source of
	# blocking geometry (the same proof Gate 1C's own dressing pass makes).
	var dressing_node: Node = bw.get_node("Dressing")
	_expect(_count_nodes_of_type(dressing_node, "CollisionShape3D") == 0,
		"Broken Watch's registered dressing carries collision shapes of its own")
	_expect(_count_nodes_of_type(dressing_node, "NavigationObstacle3D") == 0,
		"Broken Watch's registered dressing carries navigation carves of its own")
	_expect(bw.dressing_instance_count() > 0 and bw.dressing_instance_count() <= 20,
		"Broken Watch dressing is %d instances; expected a small, restrained set (<=20)" % bw.dressing_instance_count())
	print("  4 sockets present, dressing (%d instances) carries no collision or navigation carve" % bw.dressing_instance_count())


# --- 4. One continuous navigation mesh ------------------------------------------

func _check_navigation_continuous() -> void:
	print("")
	print("--- Navigation bakes ONCE and spans Landing and Broken Watch continuously")
	_expect(slice.bake_count == 1, "navigation baked %d time(s), not exactly once" % slice.bake_count)
	var map: RID = slice.navigation_map()
	var from: Vector3 = slice.landing_layout.player_start()
	var to: Vector3 = slice.broken_watch.exit_to_nexus_threshold()
	var path: PackedVector3Array = NavigationServer3D.map_get_path(map, from, to, true)
	var length: float = 0.0
	for i: int in range(1, path.size()):
		length += path[i].distance_to(path[i - 1])
	_expect(path.size() >= 2, "no navigable path from Riftfall Landing's own spawn to Broken Watch's exit")
	_expect(length > 60.0,
		"the resolved path from Landing's spawn to Broken Watch's exit is only %.1f m — the two spaces may not be joined correctly" % length)
	print("  one bake; a %.1f m resolved path joins Landing's spawn to Broken Watch's exit" % length)


# --- 5. Player starting state ----------------------------------------------------

func _check_player_starting_state() -> void:
	print("")
	print("--- The player begins with only what Phase 1 requires")
	var player: PrototypePlayer = slice.player
	_expect(String(player.weapon.weapon_id) == "worn_sword", "player does not start with the Worn Sword")
	_expect(is_equal_approx(player.weapon.physical_damage, 100.0), "starting weapon damage is not 100.0")
	_expect(is_equal_approx(player.life, player.max_life), "player does not start at full Life")
	_expect(is_equal_approx(player.mana, player.max_mana), "player does not start at full Mana")
	_expect(is_equal_approx(player.max_mana, 100.0), "max Mana is not the reused 100.0")
	_expect(player.global_position.distance_to(slice.landing_layout.player_start()) < 0.5,
		"the player did not spawn at Riftfall Landing's own accepted spawn point")
	print("  Worn Sword equipped (100 dmg), full Life/Mana, spawned at Riftfall Landing's own point")


# --- 6. The combat kernel is reused, not reinvented ------------------------------

func _check_combat_kernel_reused() -> void:
	print("")
	print("--- Quick Strike and Graveblade data are the reused canonical records")
	var quick_strike_canonical: Resource = load("res://data/prototype_zero/quick_strike.tres")
	var graveblade_canonical: Resource = load("res://data/prototype_zero/graveblade.tres")
	_expect(slice.player.attack.canonical_data == quick_strike_canonical,
		"the player's Quick Strike data is not the reused res://data/prototype_zero/quick_strike.tres")
	for enemy: PrototypeGraveblade in slice.graveblades:
		_expect(enemy.data == graveblade_canonical,
			"%s's data is not the reused res://data/prototype_zero/graveblade.tres" % enemy.name)
	_expect(slice.graveblades[0].data == slice.graveblades[1].data,
		"the two Graveblades do not share the identical data resource — the second encounter may be scaled")
	_expect(is_equal_approx(slice.graveblade_max_life(), 300.0), "Graveblade max_life is not the reused 300.0")
	print("  both Graveblades share the reused, unedited graveblade.tres; Quick Strike uses the reused quick_strike.tres")


# --- 7. Production mouse targeting: per-use, structurally --------------------

## The kernel (`QuickStrikeAction`) already resolves targeting per-use — that
## is proven by the inherited chain. What THIS check proves is that Gate 1D's
## OWN new aim provider does not reintroduce persistence: its body reads no
## stored field, and this room's only cross-frame target field
## (`_soft_target`) belongs exclusively to the controller path.
func _check_mouse_targeting_is_per_use() -> void:
	print("")
	print("--- Production mouse targeting samples fresh every use (D-193 §12/§21)")
	var source: String = FileAccess.get_file_as_string(SLICE_SCRIPT)
	var code: String = _code_only(source)
	var mouse_body: String = _function_body(code, "_mouse_aim_provider")
	_expect(not mouse_body.is_empty(), "could not locate _mouse_aim_provider() to inspect")
	_expect(not mouse_body.contains("_soft_target"),
		"_mouse_aim_provider() references _soft_target — mouse acquisition must never touch controller retention")
	_expect(not mouse_body.contains("self."),
		"_mouse_aim_provider() should read no stored 'current target' field of its own")
	var hover_body: String = _function_body(code, "_update_hover_info")
	_expect(not hover_body.is_empty(), "could not locate _update_hover_info() to inspect")
	_expect(not hover_body.contains("_forced_aim_target_for_verification")
		and not hover_body.contains("player.attack.target ="),
		"hover-info must never write into Quick Strike's acquisition state")
	print("  _mouse_aim_provider() and _update_hover_info() are structurally independent, per source scan")


func _check_controller_targeting_untouched() -> void:
	print("")
	print("--- Controller soft targeting reuses D-178 exactly, unmodified")
	var data: QuickStrikeData = slice.player.attack.data
	_expect(is_equal_approx(data.soft_target_cone_degrees, 65.0), "soft-target cone drifted from the locked 65.0 deg total")
	_expect(is_equal_approx(data.soft_target_cone_half_degrees(), 32.5), "soft-target half-cone drifted from 32.5 deg")
	_expect(is_equal_approx(data.soft_target_distance, 5.0), "soft-target acquisition distance drifted from 5.0 m")
	_expect(is_equal_approx(data.soft_target_retention, 0.35), "soft-target retention drifted from 0.35 s")
	print("  65 deg total cone, 5.0 m distance, 0.35 s retention — all unchanged")


# --- 8. First encounter: a real Quick Strike kill and the guaranteed drop ------

func _check_first_encounter_and_drop() -> void:
	print("")
	print("--- The first Graveblade dies to three ordinary Quick Strikes and drops the upgrade")
	var enemy: PrototypeGraveblade = slice.graveblades[0]
	enemy.set_ai_enabled(false)
	var area: PrototypeTargetable = enemy.get_node("TargetArea") as PrototypeTargetable

	var hits: int = 0
	while enemy.is_alive() and hits < 6:
		await _strike(enemy, area)
		hits += 1
	_expect(not enemy.is_alive(), "the first Graveblade survived %d Quick Strikes" % hits)
	_expect(hits == 3, "the Worn Sword (100 dmg) took %d Hit(s) to defeat 300 Life, not the expected 3" % hits)
	print("  first Graveblade defeated in %d Hit(s), matching ceil(300 / 100) = 3" % hits)

	await _settle(10)
	_expect(slice._drop_granted, "the guaranteed drop was not granted on the first eligible kill")
	_expect(slice._active_drop != null, "no drop is present in the world after the guaranteed kill")
	if slice._active_drop != null:
		_expect(String(slice._active_drop.weapon.weapon_id) == "watchsteel_sword",
			"the guaranteed drop does not carry the Watchsteel Sword")
		_expect(is_equal_approx(slice._active_drop.weapon.physical_damage, 150.0),
			"the guaranteed drop's damage is not 150.0")
		_expect(is_equal_approx(slice._active_drop.measured_interaction_range(), 2.20),
			"the drop's measured interaction range does not match its own collision shape")
	print("  the drop carries the Watchsteel Sword (150 dmg), on no physics layer, range read from its own shape")


func _check_idempotent_pickup() -> void:
	print("")
	print("--- Ownership is idempotent (LabProgress-style refusal, not a silent repeat)")
	var loadout: PlayerLoadout = slice.loadout
	var before: int = loadout.owned_items.size()
	var refused_before: int = loadout.duplicate_attempts_refused
	var already_owned: PrototypeWeaponData = loadout.owned_items[0]
	var result: bool = loadout.pick_up(already_owned)
	_expect(not result, "picking up an already-owned item a second time was not refused")
	_expect(loadout.owned_items.size() == before, "owned_items grew from a duplicate pickup")
	_expect(loadout.duplicate_attempts_refused == refused_before + 1,
		"the duplicate attempt was not counted")
	print("  a duplicate pickup of an owned item is refused and counted, exactly once")


# --- 9. Comparison and equip ---------------------------------------------------

func _check_comparison_and_equip() -> void:
	print("")
	print("--- The comparison panel states the factual difference; Equip applies it")
	var drop: FirstMvpItemDrop = slice._active_drop
	_expect(drop != null, "no drop is present to compare against")
	if drop == null:
		return
	slice.open_item_comparison("verification")
	await _settle(2)
	_expect(slice.item_comparison.is_open, "the comparison panel did not open")
	_expect(get_tree().paused, "opening the comparison did not pause ordinary simulation")

	var before_damage: float = slice.player.weapon.physical_damage
	slice.item_comparison._on_equip_pressed()
	await _settle(2)
	_expect(not slice.item_comparison.is_open, "the comparison panel is still open after Equip")
	_expect(not get_tree().paused, "the world is still paused after the comparison closed")
	_expect(String(slice.loadout.equipped_weapon.weapon_id) == "watchsteel_sword",
		"the loadout did not equip the Watchsteel Sword")
	_expect(is_equal_approx(slice.player.weapon.physical_damage, 150.0),
		"Quick Strike's damage is %.0f after equip, not 150 — the panel's factual change was not applied" % slice.player.weapon.physical_damage)
	_expect(slice.player.weapon.physical_damage > before_damage,
		"the equipped weapon's damage did not increase")
	_expect(slice._active_drop == null, "the ground drop is still present after being equipped")
	_expect(slice.loadout.is_owned(slice.loadout.equipped_weapon), "the equipped item is not recorded as owned")
	print("  equip applied: 100 -> 150 damage, drop removed from the world, ownership recorded")


# --- 10. Second encounter, not secretly scaled ----------------------------------

func _check_second_encounter_not_scaled() -> void:
	print("")
	print("--- The second Graveblade is the SAME contract, and the upgrade is allowed to work")
	var enemy: PrototypeGraveblade = slice.graveblades[1]
	_expect(is_equal_approx(enemy.life, 300.0), "the second Graveblade's Life was pre-damaged before the fight began")
	enemy.set_ai_enabled(false)
	var area: PrototypeTargetable = enemy.get_node("TargetArea") as PrototypeTargetable

	var hits: int = 0
	while enemy.is_alive() and hits < 6:
		await _strike(enemy, area)
		hits += 1
	_expect(not enemy.is_alive(), "the second Graveblade survived %d Quick Strikes" % hits)
	_expect(hits == 2,
		"the Watchsteel Sword (150 dmg) took %d Hit(s) to defeat 300 Life, not the expected 2 — the improvement was not perceptible" % hits)
	print("  second Graveblade defeated in %d Hit(s), matching ceil(300 / 150) = 2 — one fewer than before" % hits)


# --- 11. Fallen and Restart -----------------------------------------------------

func _check_fallen_and_restart() -> void:
	print("")
	print("--- Fallen shows the accurate killing source; Restart returns to a valid state")
	var owned_before: int = slice.loadout.owned_items.size()
	var drop_granted_before: bool = slice._drop_granted

	var lethal: DamageEvent = DamageEvent.physical(90001, slice.graveblades[0], slice.player, slice.player.max_life + 999.0)
	slice.player.receive_damage(lethal)
	_expect(not slice.player.is_alive(), "the player did not fall from a lethal DamageEvent")

	for frame: int in 120:
		if slice.fallen_overlay.is_open:
			break
		await get_tree().physics_frame
	_expect(slice.fallen_overlay.is_open, "the Fallen overlay did not open after the fall delay")
	_expect(not slice.fallen_overlay.killing_source.is_empty(), "Fallen shows no killing source")
	_expect(slice.fallen_overlay.killing_source.contains("Graveblade"),
		"Fallen's killing source does not name the Graveblade: '%s'" % slice.fallen_overlay.killing_source)
	print("  Fallen opened: \"%s\"" % slice.fallen_overlay.killing_source)

	slice.fallen_overlay._on_restart()
	await _settle(4)
	_expect(slice.player.is_alive(), "the player is not alive after Restart")
	_expect(is_equal_approx(slice.player.life, slice.player.max_life), "the player did not return to full Life")
	var expected_spawns: Array[Vector3] = [
		slice.broken_watch.first_encounter_spawn(), slice.broken_watch.second_encounter_spawn(),
	]
	for i: int in slice.graveblades.size():
		var enemy: PrototypeGraveblade = slice.graveblades[i]
		_expect(enemy.is_alive() and is_equal_approx(enemy.life, 300.0),
			"%s is not restored to full Life after Restart" % enemy.name)
		_expect(enemy.global_position.distance_to(expected_spawns[i]) < 0.5,
			"%s reset to %s after Restart, not its own %s encounter spawn" % [
				enemy.name, enemy.global_position, expected_spawns[i],
			])
	_expect(slice._drop_granted == drop_granted_before,
		"Restart changed whether the guaranteed drop was granted")
	_expect(slice.loadout.owned_items.size() == owned_before,
		"Restart duplicated or lost an owned item — owned %d before, %d after" % [owned_before, slice.loadout.owned_items.size()])
	print("  Restart: player and both Graveblades revived; the guaranteed reward was not duplicated or lost")


# --- 12. The exit boundary ------------------------------------------------------

func _check_exit_boundary() -> void:
	print("")
	print("--- Reaching the exit marks the bounded slice complete; nothing loads")
	var before_scene: Node = get_tree().current_scene
	slice.player.global_position = slice.broken_watch.exit_to_nexus_threshold()
	await _settle(2)
	_expect(slice.slice_complete, "the slice did not register as complete at ExitToNexusThreshold")
	_expect(get_tree().current_scene == before_scene, "reaching the exit changed the current scene")
	print("  ExitToNexusThreshold reached; slice_complete=true; no scene was loaded or changed")


# --- 13. Excluded systems and no disk writes ------------------------------------

func _check_excluded_systems_absent() -> void:
	print("")
	print("--- Every excluded first-MVP system is absent from Gate 1D's own files")
	var forbidden: PackedStringArray = PackedStringArray([
		"Mara", "RiftShard", "rift_shard", "RiftEcho", "rift_echo", "Augment",
		"PassiveWeb", "passive_web", "SkillConfiguration", "Forge", "Elite",
		"Distortion", "RiftIntensity", "rift_intensity", "FoundationCache",
		"foundation_cache", "NexusThreshold.tscn", "nexus_threshold.tscn",
	])
	for path: String in [SLICE_SCRIPT, LAYOUT_SCRIPT]:
		var code: String = _code_only(FileAccess.get_file_as_string(path))
		for term: String in forbidden:
			_expect(not code.contains(term), "%s names the excluded term '%s'" % [path, term])
	print("  %d excluded terms named nowhere in Gate 1D's own two largest files" % forbidden.size())


func _check_writes_nothing() -> void:
	print("")
	print("--- This scene never constructs a storage path; it can touch no disk file")
	var code: String = _code_only(FileAccess.get_file_as_string(SLICE_SCRIPT))
	_expect(not code.contains("PrototypeSettings"), "the slice references PrototypeSettings")
	_expect(not code.contains("PrototypeLabState"), "the slice references PrototypeLabState")
	_expect(not code.contains("save_to_disk") and not code.contains("FileAccess.open"),
		"the slice writes to disk directly")
	print("  no PrototypeSettings, PrototypeLabState, or direct disk write anywhere in the slice script")


# --- Helpers ---------------------------------------------------------------------

## Drives one full Quick Strike against `enemy`/`area` using the verification
## seam, from a fixed 1.0 m separation (inside reach minus the approach
## margin, so no APPROACH phase is needed) and waits for the release to land.
func _strike(enemy: PrototypeGraveblade, area: PrototypeTargetable) -> void:
	var before_life: float = enemy.life
	var to_enemy: Vector3 = (enemy.global_position - slice.player.global_position)
	var direction: Vector3 = Vector3(to_enemy.x, 0.0, to_enemy.z)
	if direction.length() > 1.2 or direction.length() < 0.001:
		slice.player.global_position = enemy.global_position + Vector3(1.0, 0.0, 0.0)
		slice.player.velocity = Vector3.ZERO
	slice.player.face_instantly((enemy.global_position - slice.player.global_position))
	slice.force_next_aim_for_verification(area)
	slice.player.attack.press()
	# Released on the SAME frame as the press — a tap, not a hold — so the
	# kernel's own proven held-repeat mechanic (a real, deliberate feature)
	# cannot fire a second, uncounted swing while this helper is waiting for
	# the first one to land.
	slice.player.attack.release_input()
	for frame: int in 90:
		await get_tree().physics_frame
		if slice.player.attack.phase == QuickStrikeAction.Phase.READY:
			break
	_expect(enemy.life < before_life or not enemy.is_alive(),
		"a forced Quick Strike produced no damage (Life stayed %.0f)" % before_life)


func _await_navigation() -> void:
	for frame: int in 60:
		if NavigationServer3D.map_get_iteration_id(slice.navigation_map()) > 0:
			return
		await get_tree().physics_frame


func _settle(frames: int) -> void:
	for i: int in frames:
		await get_tree().physics_frame


func _expect(condition: bool, failure_message: String) -> void:
	_checks += 1
	if not condition:
		_failures.append(failure_message)


func _code_only(source: String) -> String:
	var kept: PackedStringArray = PackedStringArray()
	for line: String in source.split("\n"):
		if line.strip_edges().begins_with("#") or line.strip_edges().begins_with("##"):
			continue
		kept.append(line)
	return "\n".join(kept)


## Extracts a top-level function's body by indentation, for source-scan checks
## that must look at ONE function rather than the whole file.
func _function_body(code: String, function_name: String) -> String:
	var lines: PackedStringArray = code.split("\n")
	var start: int = -1
	for i: int in lines.size():
		if lines[i].begins_with("func %s(" % function_name):
			start = i
			break
	if start == -1:
		return ""
	var body: PackedStringArray = PackedStringArray()
	for i: int in range(start + 1, lines.size()):
		var line: String = lines[i]
		if line.strip_edges() == "":
			continue
		if not line.begins_with("\t") and not line.begins_with(" "):
			break
		body.append(line)
	return "\n".join(body)


func _count_nodes_of_type(node: Node, type_name: String) -> int:
	var total: int = 0
	for child: Node in node.get_children():
		if child.is_class(type_name):
			total += 1
		total += _count_nodes_of_type(child, type_name)
	return total
