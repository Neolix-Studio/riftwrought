extends Node
## First-MVP Gate 1E — automated verification of the canonical opening (D-219).
##
## PROPORTIONAL, per the brief: "Use focused verification during implementation.
## Do not repeatedly rerun the complete archaeological gate ladder." This does
## not re-prove Quick Strike, the Graveblade, click-to-move, the D-178
## controller cone, Riftfall Landing's geometry, or Broken Watch's structure —
## the inherited chain proves all of those and none of that code is edited. Nor
## does it re-prove the three Foundation Skills, which have their own focused
## suite on their own developer-only scene.
##
## What THIS suite proves is what nothing else can know: that the four spaces
## are one continuous walkable composition, that the Nexus beats happen in the
## right order and exactly once, that the Passive Web and the Foundation Cache
## behave, that the character survives quitting, that NOTHING can be duplicated
## by reloading, and that the excluded systems are absent.
##
## EVERY CHECK RECORDS REACHING ITS LAST LINE, and the owed set is compared in
## BOTH directions — D-211's structural repair, ported because this suite is
## mostly coroutines and an un-awaited one is a check that silently does not run
## while the suite still prints PASS.
##
## IT WRITES ONLY WHERE IT IS TOLD TO. The runtime is handed `--state-dir` by
## the smoke script, so every save this suite makes lands in a temporary
## directory. `CharacterSave` refuses a path resolving onto either Prototype
## Zero file, and that refusal is proved here in both directions.
##
## Run:  godot --headless --path game \
##         res://scenes/first_mvp/canonical_opening/canonical_opening.tscn \
##         -- --verify-1e --state-dir <dir>

const RUNTIME_SCRIPT: String = "res://scripts/first_mvp/canonical_opening/canonical_opening_runtime.gd"
const THRESHOLD_SCRIPT: String = "res://scripts/first_mvp/severed_threshold/nexus_threshold_layout.gd"
const NEXUS_SCRIPT: String = "res://scripts/first_mvp/nexus/rift_nexus_layout.gd"

const EXPECTED_ACTIONS_COUNT: int = 31
const CF_SQUARE_METRES: float = 588.0

var runtime: CanonicalOpeningRuntime
var arguments: PackedStringArray = PackedStringArray()

var _failures: PackedStringArray = PackedStringArray()
var _checks: int = 0
var _reached: Dictionary = {}

const OWED_CHECKS: Array[String] = [
	"engine_and_composition",
	"input_map_untouched",
	"gate_1d_preserved",
	"four_spaces_one_navigation",
	"nexus_threshold_shape",
	"rift_nexus_shell",
	"safe_region",
	"mara_after_danger",
	"recognition_happens_once",
	"conversation_first_beat_only",
	"milestone_point_once",
	"origin_ring_graph",
	"origin_ring_allocation_and_refund",
	"origin_ring_honesty",
	"foundation_cache_options",
	"foundation_cache_grants_once",
	"experience_cannot_duplicate",
	"save_round_trip",
	"save_refuses_prototype_zero",
	"first_footing_boundary",
	"excluded_systems_absent",
	"prototype_zero_unchanged",
	"surfaces_are_on_screen",
	"no_navigation_islands",
	"review_findings_stay_fixed",
]


func _ready() -> void:
	await run()


func run() -> void:
	print("")
	print("=== First-MVP Gate 1E verification — the canonical opening (D-219) ===")
	await _settle(10)
	await _await_navigation()

	_check_engine_and_composition()
	_check_input_map_untouched()
	_check_gate_1d_preserved()
	await _check_four_spaces_one_navigation()
	_check_nexus_threshold_shape()
	_check_rift_nexus_shell()
	await _check_safe_region()
	_check_mara_after_danger()
	await _check_recognition_happens_once()
	await _check_conversation_first_beat_only()
	_check_milestone_point_once()
	_check_origin_ring_graph()
	await _check_origin_ring_allocation_and_refund()
	_check_origin_ring_honesty()
	await _check_foundation_cache_options()
	await _check_foundation_cache_grants_once()
	await _check_experience_cannot_duplicate()
	await _check_save_round_trip()
	_check_save_refuses_prototype_zero()
	await _check_first_footing_boundary()
	_check_excluded_systems_absent()
	_check_prototype_zero_unchanged()
	await _check_surfaces_are_on_screen()
	await _check_no_navigation_islands()
	await _check_review_findings_stay_fixed()

	_check_every_check_ran()

	print("")
	if _failures.is_empty():
		print("GATE 1E VERIFICATION: PASS (%d checks)" % _checks)
		get_tree().quit(0)
	else:
		for failure: String in _failures:
			printerr("  FAIL: %s" % failure)
		printerr("GATE 1E VERIFICATION: %d FAILURE(S) of %d checks" % [_failures.size(), _checks])
		get_tree().quit(1)


# --- 1. Engine and composition -------------------------------------------------

func _check_engine_and_composition() -> void:
	print("")
	print("--- The integrated opening assembled")
	var version: String = str(Engine.get_version_info()["string"])
	_expect(version.begins_with("4.7.2"), "engine is %s, not the locked 4.7.2 baseline" % version)
	_expect(runtime != null, "the runtime did not assemble")
	_expect(runtime.landing_layout != null, "Riftfall Landing's accepted foundation is absent")
	_expect(runtime.broken_watch != null, "Broken Watch is absent")
	_expect(runtime.nexus_threshold != null, "the Nexus Threshold is absent")
	_expect(runtime.rift_nexus != null, "the Rift Nexus is absent")
	_expect(runtime.anchor != null, "the central Anchor is absent")
	_expect(runtime.mara != null, "Mara Veyl is absent")
	_expect(runtime.character != null, "no character was built")
	_expect(runtime.character_save != null, "no character store was built")
	_expect(runtime.skills != null and runtime.skills.is_coherent(),
		"the Skill library is incoherent")
	print("  four spaces, one Anchor, one Surveyor, one character, four Skills")
	_done("engine_and_composition")


func _check_input_map_untouched() -> void:
	print("")
	print("--- project.godot's InputMap is untouched; Gate 1E declared no action")
	var named: int = 0
	for action: StringName in InputMap.get_actions():
		if String(action).begins_with("ui_") and String(action) not in ["ui_confirm", "ui_cancel"]:
			continue
		named += 1
	_expect(named == EXPECTED_ACTIONS_COUNT,
		"InputMap declares %d non-builtin action(s), not the locked %d" % [named, EXPECTED_ACTIONS_COUNT])
	# Gate 1E's own controls are PHYSICAL KEYS. Proved by their absence from the map.
	for forbidden: String in ["origin_ring", "passive_web", "foundation_cache", "start_fresh",
		"save_game", "skill_2", "faultbreaker", "splinter_shot", "emberbolt"]:
		_expect(not InputMap.has_action(StringName(forbidden)),
			"an InputMap action '%s' exists; Gate 1E must add none" % forbidden)
	print("  %d actions, unchanged; every Gate 1E control is a physical key" % named)
	_done("input_map_untouched")


# --- 2. Gate 1D is preserved ---------------------------------------------------

func _check_gate_1d_preserved() -> void:
	print("")
	print("--- Gate 1D is reused by EXTENSION and preserved exactly")
	# The runtime IS a BrokenWatchSlice; that is what lets Gate 1D's own HUD and
	# modals bind to it with no edit.
	_expect(runtime is BrokenWatchSlice, "the runtime is not a BrokenWatchSlice")
	_expect(runtime.get_script().resource_path == RUNTIME_SCRIPT,
		"the runtime script is not Gate 1E's own")
	var base: Script = (runtime.get_script() as GDScript).get_base_script()
	_expect(base != null and base.resource_path == "res://scripts/first_mvp/severed_threshold/broken_watch_slice.gd",
		"the runtime does not extend broken_watch_slice.gd")

	# Every accepted value Gate 1D asserts is still what it was.
	_expect(is_equal_approx(runtime.landing_layout.footprint_area(), 1201.00),
		"Landing footprint is %.2f m^2, not the accepted 1201.00" % runtime.landing_layout.footprint_area())
	_expect(is_equal_approx(runtime.composition.rotation_degrees.y, 45.0), "composition yaw drifted")
	_expect(is_equal_approx(runtime.camera_rig.distance_metres, 19.0), "camera distance drifted from 19.0 m")
	_expect(is_equal_approx(runtime.camera_rig.pitch_degrees, 55.0), "camera pitch drifted from 55.0 deg")
	_expect(is_equal_approx(runtime.camera_rig.fov_degrees, 45.0), "camera fov drifted from 45.0 deg")
	_expect(is_equal_approx(runtime.player.max_speed, 5.0), "player max_speed drifted from 5.0 m/s")
	_expect(runtime.graveblades.size() == 2, "the two Broken Watch encounters are not both present")

	# THE ACCEPTED PRODUCTION LANDING STILL LEADS INTO BROKEN WATCH, and it is
	# the Greybox V2 / Visual Review track that does so — through `WayOut`,
	# NOT through the historical Gate 1C scene's `ExitToBrokenWatch`.
	_expect(runtime.landing_layout is RiftfallLandingGreyboxLayout,
		"the opening is not built on the accepted Greybox V2 layout")
	var sockets: Dictionary = runtime.landing_layout.socket_positions()
	_expect(sockets.has("WayOut"), "the accepted Landing has no WayOut socket")
	_expect(not sockets.has("ExitToBrokenWatch"),
		"the accepted Landing carries the historical Gate 1C socket name")
	var way_out: Vector3 = runtime.landing_layout.way_out()
	var watch_entry: Vector3 = runtime.broken_watch.entry()
	var gap: float = Vector2(way_out.x - watch_entry.x, way_out.z - watch_entry.z).length()
	_expect(gap < 12.0, "WayOut is %.2f m from Broken Watch's entry; they must adjoin" % gap)
	print("  Landing (Greybox V2, WayOut) -> Broken Watch entry: %.2f m apart" % gap)
	_done("gate_1d_preserved")


# --- 3. Four spaces, one navigation mesh ---------------------------------------

func _check_four_spaces_one_navigation() -> void:
	print("")
	print("--- All four spaces bake as ONE continuous navigation mesh, from ONE bake")
	_expect(runtime.bake_count == 1, "the navigation was baked %d times, not once" % runtime.bake_count)
	_expect(runtime.navmesh_polygon_count > 0, "the navigation mesh is empty")

	# THE WHOLE ROUTE IS ONE MAP: a path is resolved from the Landing's own
	# player start all the way to the Rift Nexus's forward route, and it must
	# arrive. This is the single most important structural claim in the gate.
	var map: RID = runtime.navigation_map()
	var start: Vector3 = runtime.landing_layout.player_start()
	var stops: Array[Dictionary] = [
		{"name": "Broken Watch entry", "point": runtime.broken_watch.entry()},
		{"name": "Broken Watch exit", "point": runtime.broken_watch.exit_to_nexus_threshold()},
		{"name": "Nexus Threshold entry", "point": runtime.nexus_threshold.entry()},
		{"name": "Mara's terrace", "point": runtime.nexus_threshold.recognition_point()},
		{"name": "the Nexus gate", "point": runtime.nexus_threshold.nexus_gate()},
		{"name": "the central Anchor", "point": runtime.rift_nexus.anchor_point()},
		{"name": "Mara's station", "point": runtime.rift_nexus.mara_station()},
		{"name": "the Foundation Cache", "point": runtime.rift_nexus.foundation_cache()},
		{"name": "the forward route", "point": runtime.rift_nexus.forward_route()},
	]
	# TOLERANCE, AND WHY IT IS 2.0 m RATHER THAN TIGHTER. A socket is an authored
	# POINT and the navigation mesh is eroded by the 0.40 m agent radius from
	# every wall, so a socket deliberately placed in a doorway sits up to about
	# 1.5 m from the nearest walkable cell without anything being wrong — Broken
	# Watch's own accepted entry socket measures exactly that in Gate 1D's
	# layout. The claim worth asserting is that the player can WALK there, which
	# is the path test below, not that the socket is itself on a walkable cell.
	var socket_tolerance: float = 2.0
	for stop: Dictionary in stops:
		var target: Vector3 = stop["point"]
		var nearest: Vector3 = NavigationServer3D.map_get_closest_point(map, target)
		var offset: float = Vector2(nearest.x - target.x, nearest.z - target.z).length()
		_expect(offset < socket_tolerance,
			"%s is %.2f m from the navigation mesh; it is not reachable ground" % [stop["name"], offset])
		var path: PackedVector3Array = NavigationServer3D.map_get_path(map, start, target, true)
		_expect(path.size() >= 2, "no navigation path from the Landing start to %s" % stop["name"])
		if path.size() >= 2:
			var arrival: Vector3 = path[path.size() - 1]
			var missed: float = Vector2(arrival.x - nearest.x, arrival.z - nearest.z).length()
			_expect(missed < 1.0,
				"the path toward %s stopped %.2f m short of walkable ground; the mesh is not continuous" % [
					stop["name"], missed,
				])
	await _settle(1)
	print("  %d polygons, %.1f m^2, one bake; every socket in all four spaces is reachable from the Landing start" % [
		runtime.navmesh_polygon_count, runtime.navmesh_area,
	])
	_done("four_spaces_one_navigation")


# --- 4. The Nexus Threshold's shape --------------------------------------------

func _check_nexus_threshold_shape() -> void:
	print("")
	print("--- The Nexus Threshold: 2-3 CF, five sockets, no encounter")
	var layout: NexusThresholdLayout = runtime.nexus_threshold
	var cf: float = layout.footprint_cf()
	_expect(cf >= 2.0 and cf <= 3.0,
		"the Nexus Threshold measures %.2f CF against the canonical 2-3 CF target" % cf)
	_expect(layout.room_count() == 6, "expected 6 authored rooms, found %d" % layout.room_count())
	for socket: String in ["NexusThresholdEntry", "SafeBoundary", "MaraStation", "RecognitionPoint", "NexusGate"]:
		_expect(layout.socket_positions().has(socket), "the Nexus Threshold has no %s socket" % socket)
	# NO ENCOUNTER SOCKET AT ALL. Combat: none after entry.
	for forbidden: String in ["EncounterSpawn", "FirstEncounterSpawn", "SecondEncounterSpawn"]:
		_expect(not layout.socket_positions().has(forbidden),
			"the Nexus Threshold carries an encounter socket (%s); it is a safe space" % forbidden)

	# It ADJOINS Broken Watch's exit.
	var watch_exit: Vector3 = runtime.broken_watch.exit_to_nexus_threshold()
	var entry: Vector3 = layout.entry()
	var gap: float = Vector2(watch_exit.x - entry.x, watch_exit.z - entry.z).length()
	_expect(gap < 12.0, "Broken Watch's exit is %.2f m from the Nexus Threshold's entry" % gap)

	# THE APPROACH IS ALIGNED ON THE ANCHOR'S AXIS, which is the sightline the
	# accepted camera can actually deliver.
	#
	# MEASURED IN LOCAL CONSTANTS, not through a world direction. Both layouts
	# sit at identity under the same rotated `NavigationRegion3D`, so their local
	# frames coincide and the route runs along local -Z by construction; the
	# lateral offset is therefore a straight difference of two local x values.
	# Deriving it from `route_forward()` instead would measure against the
	# Landing centreline's FIRST segment, which points somewhere else entirely.
	var lateral: float = absf(NexusThresholdLayout.NEXUS_GATE.x - RiftNexusLayout.ANCHOR.x)
	_expect(lateral < 0.75,
		"the Nexus gate is %.2f m off the Anchor's axis; the approach must frame it" % lateral)
	# And they really are in one frame, so that arithmetic means what it says.
	_expect(layout.transform.is_equal_approx(Transform3D.IDENTITY),
		"the Nexus Threshold carries its own transform; the local comparison above would be wrong")
	_expect(runtime.rift_nexus.transform.is_equal_approx(Transform3D.IDENTITY),
		"the Rift Nexus carries its own transform; the local comparison above would be wrong")
	# The gate and the Anchor are far enough apart that the Anchor cannot be seen
	# from the gate at the accepted camera — the honest consequence of the D-175
	# framing, stated here rather than left to be rediscovered.
	var gate_to_anchor: float = layout.nexus_gate().distance_to(runtime.rift_nexus.anchor_point())
	_expect(gate_to_anchor > 13.532,
		"the Anchor is %.2f m from the gate; the report's camera finding assumes it is further" % gate_to_anchor)
	print("  %.2f m^2 = %.2f CF, %d rooms, %d dressing pieces, %.2f m from Broken Watch, %.2f m off the Anchor axis" % [
		layout.footprint_area(), cf, layout.room_count(), layout.dressing_instance_count(), gap, lateral,
	])
	_done("nexus_threshold_shape")


# --- 5. The Rift Nexus shell ---------------------------------------------------

func _check_rift_nexus_shell() -> void:
	print("")
	print("--- The Rift Nexus: a minimal shell with the Anchor, Mara, the Cache and one closed route")
	var layout: RiftNexusLayout = runtime.rift_nexus
	# Larger than everything before it, and honestly short of the 5-8 CF the
	# blueprint eventually wants.
	_expect(layout.footprint_cf() > runtime.nexus_threshold.footprint_cf(),
		"the Rift Nexus (%.2f CF) is not larger than the Nexus Threshold (%.2f CF)" % [
			layout.footprint_cf(), runtime.nexus_threshold.footprint_cf(),
		])
	_expect(layout.footprint_cf() < 5.0,
		"the shell measures %.2f CF; it is deliberately smaller than the 5-8 CF final hub" % layout.footprint_cf())
	for socket: String in ["NexusArrival", "CentralAnchor", "MaraStation", "FoundationCache",
		"EquipmentStation", "ForwardRoute"]:
		_expect(layout.socket_positions().has(socket), "the Rift Nexus has no %s socket" % socket)

	# THE BRIEF PREFERS ABSENCE OVER DISABLED FUTURE BUTTONS. No station for a
	# system that does not exist.
	for forbidden: String in ["Forge", "RunAssembly", "Pursuits", "Distortions", "EchoHunt",
		"Vault", "Reliquary", "Archive"]:
		_expect(not layout.socket_positions().has(forbidden),
			"the Nexus has a %s socket; the brief prefers absence to a fake station" % forbidden)

	# THE CLOSED FORWARD ROUTE IS A REAL SOLID, not a picture of one.
	var closed: Node = layout.get_node_or_null("Visuals/ClosedForwardRoute")
	_expect(closed != null, "the closed forward route has no geometry")
	var collision: Node = layout.get_node_or_null("WorldCollision/ClosedForwardRoute")
	_expect(collision != null, "the closed forward route has no collision; it could be walked through")
	var carve: Node = layout.get_node_or_null("NavigationObstacles/ClosedForwardRouteCarve")
	_expect(carve != null, "the closed forward route does not carve the navigation mesh")

	# Nothing stands on the Anchor's dais.
	var anchor_point: Vector3 = layout.anchor_point()
	var intruders: int = 0
	for dressing: Node in layout.get_node("Dressing").get_children():
		var piece: Node3D = dressing as Node3D
		if piece == null:
			continue
		if Vector2(piece.global_position.x - anchor_point.x,
			piece.global_position.z - anchor_point.z).length() < RiftNexusLayout.DAIS_RADIUS:
			intruders += 1
	_expect(intruders == 0, "%d dressing piece(s) stand inside the Anchor's dais" % intruders)
	print("  %.2f m^2 = %.2f CF, %d rooms, %d dressing pieces, dais clear, forward route genuinely solid" % [
		layout.footprint_area(), layout.footprint_cf(), layout.room_count(),
		layout.dressing_instance_count(),
	])
	_done("rift_nexus_shell")


# --- 6. The safe region ---------------------------------------------------------

func _check_safe_region() -> void:
	print("")
	print("--- Past the safe boundary nothing hostile acts and no damaging Skill fires")
	runtime.player.global_position = runtime.broken_watch.first_encounter_spawn()
	await _settle(4)
	_expect(not runtime.safe_region_active, "Broken Watch reported itself safe")
	_expect(runtime.damaging_skills_allowed(), "damaging Skills are refused inside Broken Watch")

	runtime.player.global_position = runtime.nexus_threshold.recognition_point()
	await _settle(4)
	_expect(runtime.safe_region_active, "the Nexus Threshold did not report itself safe")
	_expect(not runtime.damaging_skills_allowed(), "damaging Skills are allowed in a safe place")
	var acting: int = 0
	for enemy: PrototypeGraveblade in runtime.graveblades:
		if enemy.ai_enabled:
			acting += 1
	_expect(acting == 0, "%d Graveblade(s) still act inside the safe region" % acting)

	# DELIBERATELY NOT THE ANCHOR. Standing on it would fire the recognition beat
	# here, and the check that recognition happens once, in order, and only on
	# approach runs after this one. Mara's station is inside the Nexus and far
	# from the Anchor's own radius.
	runtime.player.global_position = runtime.rift_nexus.mara_station()
	await _settle(4)
	_expect(runtime.safe_region_active, "the Rift Nexus did not report itself safe")
	_expect(runtime.rift_nexus.mara_station().distance_to(runtime.rift_nexus.anchor_point())
			> RiftAnchor.STIR_RADIUS,
		"Mara's station is inside the Anchor's stir radius; this check would fire the beat early")
	print("  Broken Watch hostile; Nexus Threshold and Rift Nexus safe, %d enemy acting" % acting)
	_done("safe_region")


# --- 7. Mara appears only after danger -----------------------------------------

func _check_mara_after_danger() -> void:
	print("")
	print("--- Mara stands past the danger, in the Nexus, unarmed")
	var mara: MaraVeyl = runtime.mara
	# She is inside the safe region, measured along the route rather than by
	# which rectangle she happens to be in.
	var boundary: Vector3 = runtime.nexus_threshold.safe_boundary()
	var along: float = (mara.global_position - boundary).dot(runtime.route_forward())
	_expect(along > 0.0, "Mara stands %.2f m on the hostile side of the safe boundary" % -along)
	# And she is nowhere near either encounter.
	for spawn: Vector3 in [runtime.broken_watch.first_encounter_spawn(),
		runtime.broken_watch.second_encounter_spawn()]:
		_expect(mara.global_position.distance_to(spawn) > 40.0,
			"Mara stands %.1f m from a Graveblade encounter" % mara.global_position.distance_to(spawn))

	var presentation: Dictionary = mara.presentation()
	_expect(int(presentation["meshes"]) > 0, "Mara has no visible body")
	_expect(int(presentation["overlaid"]) == int(presentation["meshes"]),
		"%d of %d of Mara's meshes carry the surveyor overlay" % [
			presentation["overlaid"], presentation["meshes"],
		])
	_expect(bool(presentation["has_weapon_node"]), "Mara's rig has no weapon node to hide")
	_expect(not bool(presentation["weapon_visible"]), "Mara is holding a weapon")
	# THE OVERLAY IS PER-INSTANCE: the player must not have been recoloured.
	var player_rig: MediumRigVisual = runtime.player.get_node_or_null("VisualRoot/KnightRig") as MediumRigVisual
	_expect(player_rig != null, "the player's own rig is missing")
	if player_rig != null:
		var tinted: int = 0
		for child: Node in _all_meshes(player_rig):
			if (child as MeshInstance3D).material_overlay != null:
				tinted += 1
		_expect(tinted == 0, "%d of the player's meshes were recoloured by Mara's overlay" % tinted)
	print("  %.1f m past the safe boundary, %d mesh(es) overlaid, unarmed, player untinted" % [
		along, presentation["overlaid"],
	])
	_done("mara_after_danger")


func _all_meshes(node: Node) -> Array[MeshInstance3D]:
	var found: Array[MeshInstance3D] = []
	for child: Node in node.get_children():
		var mesh: MeshInstance3D = child as MeshInstance3D
		if mesh != null:
			found.append(mesh)
		found.append_array(_all_meshes(child))
	return found


# --- 8. Recognition happens once, and before explanation -----------------------

func _check_recognition_happens_once() -> void:
	print("")
	print("--- The Nexus recognizes the Mark exactly once, and before any dialogue")
	# RECOGNITION MUST NOT HAVE HAPPENED YET: nothing so far has walked the
	# character up to the Anchor, and the dialogue has never been opened.
	_expect(runtime.conversation.times_opened == 0,
		"the conversation opened before the world event; recognition comes first")

	runtime.player.global_position = runtime.rift_nexus.arrival()
	await _settle(4)
	_expect(runtime.anchor.state == RiftAnchor.State.DORMANT
			or runtime.anchor.state == RiftAnchor.State.STIRRING,
		"the Anchor recognized the Mark from the Nexus arrival, %.1f m away" % runtime.anchor.closest_seen)

	# Approach: it stirs first, then recognizes.
	var anchor_point: Vector3 = runtime.rift_nexus.anchor_point()
	runtime.player.global_position = anchor_point + runtime.route_forward() * -7.0
	await _settle(4)
	_expect(runtime.anchor.state == RiftAnchor.State.STIRRING,
		"the Anchor is %s at 7 m; it should be stirring" % runtime.anchor.state_name())
	_expect(not runtime.character.nexus_recognition_complete,
		"recognition fired while the Anchor was only stirring")

	runtime.player.global_position = anchor_point
	await _settle(4)
	_expect(runtime.anchor.recognition_fired, "the Anchor did not recognize the Mark on contact")
	_expect(runtime.character.nexus_recognition_complete, "the character did not record the recognition")
	_expect(runtime.character.has_reached(CharacterState.Milestone.NEXUS_RECOGNITION),
		"the recognition milestone was not reached")
	# Still no dialogue: the world event came first.
	_expect(runtime.conversation.times_opened == 0,
		"the conversation opened by itself; the brief says dialogue explains AFTERWARDS")

	# The bounded pulse settles and does not repeat.
	await _settle(int(ceil(RiftAnchor.PULSE_SECONDS * 60.0)) + 10)
	_expect(runtime.anchor.state == RiftAnchor.State.AWAKE,
		"the Anchor is %s after its bounded pulse" % runtime.anchor.state_name())

	# WALKING AWAY AND BACK CANNOT REPLAY IT.
	var refusals_before: int = runtime.character.duplicate_attempts_refused
	runtime.player.global_position = runtime.rift_nexus.arrival()
	await _settle(6)
	runtime.player.global_position = anchor_point
	await _settle(6)
	_expect(runtime.anchor.state == RiftAnchor.State.AWAKE, "the Anchor left its settled state")
	_expect(runtime.character.duplicate_attempts_refused == refusals_before,
		"re-approaching the Anchor produced a second recognition attempt")
	print("  dormant -> stirring at 7 m -> recognized on contact -> awake; re-approach changed nothing")
	_done("recognition_happens_once")


# --- 9. The conversation says only the first beat -------------------------------

func _check_conversation_first_beat_only() -> void:
	print("")
	print("--- The first conversation establishes exactly the four canonical facts")
	var conversation: FirstMvpDialogue = runtime.conversation
	_expect(conversation.problem().is_empty(), "the conversation is incoherent: %s" % conversation.problem())
	_expect(conversation.lines.size() == FirstMvpDialogue.OWED_FACTS.size(),
		"%d line(s) for %d facts" % [conversation.lines.size(), FirstMvpDialogue.OWED_FACTS.size()])
	var present: Array[StringName] = conversation.facts_present()
	for owed: StringName in FirstMvpDialogue.OWED_FACTS:
		_expect(owed in present, "the conversation does not establish %s" % owed)
	var forbidden: PackedStringArray = conversation.forbidden_subjects_present()
	_expect(forbidden.is_empty(), "the first conversation raises %s" % ", ".join(forbidden))

	# It opens, reads through, is skippable, and grants the milestone once.
	runtime.player.global_position = runtime.rift_nexus.mara_station()
	await _settle(4)
	runtime.open_dialogue("verification")
	await _settle(3)
	_expect(runtime.dialogue_panel.is_open, "the conversation did not open")
	_expect(conversation.times_opened == 1, "the conversation opened %d time(s)" % conversation.times_opened)
	var opened_text: String = runtime.dialogue_panel._line.text
	_expect(not opened_text.strip_edges().is_empty(), "the conversation showed no line")
	runtime.dialogue_panel._on_skip()
	await _settle(2)
	_expect(conversation.times_skipped == 1, "Skip did not register")
	_expect(conversation.is_last_line(), "Skip did not reach the last line")
	runtime.dialogue_panel._on_continue()
	await _settle(3)
	_expect(not runtime.dialogue_panel.is_open, "the conversation did not close on the last line")
	_expect(runtime.character.mara_first_conversation_complete, "the conversation was not recorded")

	# REPLAY IS SAFE. Reading it again grants nothing.
	var points_before: int = runtime.character.earned_passive_points()
	runtime.open_dialogue("verification replay")
	await _settle(3)
	runtime.dialogue_panel._on_skip()
	runtime.dialogue_panel._on_continue()
	await _settle(3)
	_expect(runtime.character.earned_passive_points() == points_before,
		"re-reading the conversation granted a Passive point")
	_expect(conversation.times_opened == 2, "the replay did not register as a second opening")
	print("  4 lines, 4 facts, 0 forbidden subjects; skippable, closable, and replay grants nothing")
	_done("conversation_first_beat_only")


# --- 10. The milestone Passive point, exactly once -----------------------------

func _check_milestone_point_once() -> void:
	print("")
	print("--- The first guaranteed milestone Passive point is granted exactly once")
	var character: CharacterState = runtime.character
	_expect(character.milestone_passive_point_claimed, "the milestone point was never claimed")
	_expect(character.milestone_points == 1,
		"%d milestone point(s); Gate 1E grants exactly the first of four" % character.milestone_points)
	# Claiming again is refused and COUNTED rather than silently ignored.
	var refusals_before: int = character.duplicate_attempts_refused
	var granted: bool = character.claim_nexus_recognition_point()
	_expect(not granted, "the milestone point was granted a second time")
	_expect(character.duplicate_attempts_refused == refusals_before + 1,
		"the duplicate claim was not counted as a refusal")
	_expect(character.milestone_points == 1, "the duplicate claim changed the point total")
	# It did NOT require Level 2.
	_expect(character.level == ExperienceTable.STARTING_LEVEL,
		"the character reached Level %d; the milestone point must not require it" % character.level)
	print("  1 milestone point at Level %d; a second claim is refused and counted" % character.level)
	_done("milestone_point_once")


# --- 11. The Origin Ring graph -------------------------------------------------

func _check_origin_ring_graph() -> void:
	print("")
	print("--- The Riftmarked Origin Ring: 1 free Origin + 9 canonical nodes in 3 arcs")
	var graph: PassiveGraph = runtime.character.passives.graph
	_expect(graph.is_coherent(), "the graph reported %s" % ", ".join(graph.problems))
	_expect(graph.nodes.size() == 10, "%d node(s); expected 1 Origin + 9" % graph.nodes.size())
	_expect(graph.allocatable_count() == 9, "%d allocatable node(s); expected 9" % graph.allocatable_count())
	_expect(graph.origin() != null and graph.origin().is_free(), "the class Origin is not free")

	# THE NINE CANONICAL NODES, BY NAME AND BY EFFECT, quoted from
	# design/PASSIVE_PROGRESSION.md §15 character for character.
	var canonical: Dictionary = {
		&"first_fracture": "10% increased Attack and Cast Speed while holding no Rift Shards",
		&"rift_rhythm": "15% increased Rift Shard Generation Rate",
		&"fractured_cadence": "Every third qualifying direct Skill Use ignores the remaining generation interval; the use still generates at most one Shard",
		&"orbiting_guard": "3% increased Armor and Evasion per held Rift Shard",
		&"quiet_reservoir": "4% increased Mana Regeneration per held Rift Shard",
		&"shardbound_aegis": "+1 maximum Rift Shard; 5% less Damage Taken while at maximum Shards",
		&"hastened_echo": "15% reduced Rift Echo delay",
		&"refined_reflection": "15% increased Rift Echo Effectiveness",
		&"resonant_shape": "20% more Rift Echo Effectiveness; the Shaped Skill costs 10% more when it consumes Shards",
	}
	for node_id: StringName in canonical.keys():
		var record: PassiveNodeData = graph.node(node_id)
		_expect(record != null, "the canonical node %s is missing" % node_id)
		if record != null:
			_expect(record.effect_text == String(canonical[node_id]),
				"%s's effect text does not match §15 exactly" % node_id)

	for arc: PassiveNodeData.Arc in [PassiveNodeData.Arc.GENERATE, PassiveNodeData.Arc.HOLD,
		PassiveNodeData.Arc.SHAPE]:
		var nodes: Array[PassiveNodeData] = graph.arc_nodes(arc)
		_expect(nodes.size() == 3, "an arc holds %d node(s); §15 gives each two Smalls and one Notable" % nodes.size())
		var notables: int = 0
		for record: PassiveNodeData in nodes:
			if record.kind == PassiveNodeData.Kind.NOTABLE:
				notables += 1
		_expect(notables == 1, "an arc holds %d Notable(s); §15 gives each exactly one" % notables)

	# NOT THE FULL WEB. None of the 57 later canonical nodes exists yet.
	for forbidden: StringName in [&"iron_root", &"might_travel", &"finesse_travel", &"will_travel"]:
		_expect(not graph.has(forbidden), "%s exists; the full 66-node Web is outside Gate 1E" % forbidden)
	print("  10 nodes, 3 arcs of 3, 3 Notables, 9 effect strings matching §15 exactly")
	_done("origin_ring_graph")


# --- 12. Allocation, preview, and free refund ----------------------------------

func _check_origin_ring_allocation_and_refund() -> void:
	print("")
	print("--- Allocation, preview and free respecialization, on mouse and controller")
	var allocation: PassiveAllocation = runtime.character.passives
	_expect(allocation.available() == 1, "%d point(s) available; expected exactly 1" % allocation.available())

	# WITH ONE POINT, THE LEGAL SET IS THE THREE ARC OPENINGS.
	var legal: Array[StringName] = allocation.legal_next()
	_expect(legal.size() == 3, "%d legal first allocation(s); expected the three arc openings" % legal.size())
	for expected: StringName in [&"first_fracture", &"orbiting_guard", &"hastened_echo"]:
		_expect(expected in legal, "%s is not offered as a legal first allocation" % expected)
	_expect(not (&"rift_rhythm" in legal), "a second-tier node is legal before its first")

	runtime.open_origin_ring("verification")
	await _settle(3)
	_expect(runtime.origin_ring_panel.is_open, "the Origin Ring did not open")
	var panel: OriginRingPanel = runtime.origin_ring_panel
	_expect(panel.row_ids().size() == 9, "%d rows drawn; expected 9" % panel.row_ids().size())

	# PREVIEW CHANGES NOTHING. Asked a hundred times, and the state is identical.
	var spent_before: int = allocation.spent()
	for _repeat: int in 100:
		var _ignored: Dictionary = allocation.preview(&"first_fracture")
	_expect(allocation.spent() == spent_before, "preview changed the allocation")

	# MOUSE: select and allocate.
	panel.select_for_verification(&"first_fracture")
	await _settle(2)
	_expect(panel.preview_text().contains("First Fracture"), "the preview does not name the selected node")
	_expect(panel.preview_text().contains("Costs 1 point"), "the preview does not state the cost")
	_expect(not panel._allocate.disabled, "Allocate is disabled for a legal node")
	panel._on_allocate()
	await _settle(2)
	_expect(allocation.is_allocated(&"first_fracture"), "First Fracture was not allocated")
	_expect(allocation.available() == 0, "the point was not spent")
	_expect(panel.row_state_text(&"first_fracture").contains("ALLOCATED"),
		"the row does not say it is allocated in words")

	# THE LIVE EFFECT REACHED THE RUNNING GAME through the one accepted field.
	var expected_speed: float = PassiveEffects.FIRST_FRACTURE_INCREASE
	_expect(is_equal_approx(runtime.player.increased_attack_speed(), expected_speed),
		"the player's increased attack speed is %.3f, not %.3f" % [
			runtime.player.increased_attack_speed(), expected_speed,
		])
	var base_time: float = runtime.player.attack.canonical_data.action_time
	var effective: float = runtime.player.attack.effective_action_time()
	_expect(effective < base_time,
		"Quick Strike's action time did not change: %.4f s against a %.4f s base" % [effective, base_time])

	# FREE REFUND IN A SAFE STATE, and POINTS ARE CONSERVED.
	_expect(panel.safe_state_text().contains("free in first-MVP safe states"),
		"the panel does not say respecialization is free")
	_expect(not panel._refund.disabled, "Refund is disabled for an allocated node")
	panel._on_refund()
	await _settle(2)
	_expect(not allocation.is_allocated(&"first_fracture"), "the refund did not remove the node")
	_expect(allocation.available() == 1, "the point was not returned")
	_expect(allocation.earned_points == 1, "refunding changed the EARNED point total")
	_expect(is_equal_approx(runtime.player.increased_attack_speed(), 0.0),
		"the live effect survived the refund")

	# REALLOCATE ELSEWHERE, which is what "change it" means.
	panel.select_for_verification(&"hastened_echo")
	panel._on_allocate()
	await _settle(2)
	_expect(allocation.is_allocated(&"hastened_echo"), "the point could not be moved to another arc")
	_expect(allocation.available() == 0, "the reallocation did not spend the point")

	# A REFUND THAT WOULD STRAND SOMETHING IS REFUSED, with a reason naming it.
	allocation.set_earned_points(2)
	panel.select_for_verification(&"refined_reflection")
	panel._on_allocate()
	await _settle(2)
	_expect(allocation.is_allocated(&"refined_reflection"), "the second node was not allocated")
	var strand: Dictionary = allocation.refund_preview(&"hastened_echo")
	_expect(not bool(strand["legal"]), "refunding a node that strands another was allowed")
	_expect(String(strand["reason"]).contains("Refined Reflection"),
		"the refusal does not name what would be disconnected")

	# THE ORIGIN CAN NEVER BE REFUNDED.
	var origin_refund: Dictionary = allocation.refund_preview(PassiveGraph.ORIGIN_ID)
	_expect(not bool(origin_refund["legal"]), "the free Origin could be refunded")

	# CONTROLLER: every row is focusable and the focus graph has no dead end.
	var dead_ends: int = 0
	for node_id: StringName in panel.row_ids():
		var button: Button = panel._rows[node_id]
		_expect(button.focus_mode == Control.FOCUS_ALL, "%s is not focusable" % node_id)
		if button.focus_neighbor_bottom.is_empty():
			dead_ends += 1
	_expect(dead_ends == 0, "%d row(s) have no downward focus neighbour" % dead_ends)
	_expect(not panel._close.focus_neighbor_top.is_empty(), "the action row cannot be left upward")

	# Restore: back to one unspent point, so the save round trip below starts clean.
	allocation.refund_all()
	allocation.set_earned_points(runtime.character.earned_passive_points())
	runtime._apply_passive_effects()
	panel.close("verification finished")
	await _settle(2)
	print("  3 legal openings, preview pure over 100 calls, allocate/refund/reallocate, stranding refused, 0 focus dead ends")
	_done("origin_ring_allocation_and_refund")


# --- 13. The honesty condition -------------------------------------------------

func _check_origin_ring_honesty() -> void:
	print("")
	print("--- Inert nodes SAY they are inert; nothing secretly activates Rift Shards")
	var graph: PassiveGraph = runtime.character.passives.graph
	var live: int = 0
	var inert: int = 0
	for node_id: StringName in graph.node_ids():
		var record: PassiveNodeData = graph.node(node_id)
		if record.is_free():
			continue
		if PassiveEffects.is_live(record):
			live += 1
			_expect(PassiveEffects.active_reason(record).contains("Active now"),
				"%s is live but does not say so" % node_id)
		else:
			inert += 1
			var reason: String = PassiveEffects.inactive_reason(record)
			_expect(reason.contains("No effect yet"), "%s does not say it has no effect yet" % node_id)
			_expect(reason.contains("plan ahead"), "%s does not invite the player to plan ahead" % node_id)
	_expect(live == 1, "%d live node(s); only First Fracture's condition is satisfiable today" % live)
	_expect(inert == 8, "%d inert node(s); eight depend on Rift Shards or Rift Echo" % inert)
	# A NODE CLASSIFIED LIVE WITH NO IMPLEMENTATION WOULD SHOW AN "ACTIVE NOW"
	# EFFECT THAT DOES NOTHING, and `PassiveEffects` deliberately records that
	# rather than asserting it, because `assert()` is stripped in release builds.
	# The recorded array is what makes the property checkable at all.
	_expect(runtime.character.passives.effects.unimplemented_live_nodes.is_empty(),
		"%s is classified live but has no implementation" % ", ".join(
			runtime.character.passives.effects.unimplemented_live_nodes))

	# RIFT SHARDS ARE NOT SECRETLY ACTIVE. Nothing anywhere carries one.
	for forbidden: String in ["rift_shards", "shards", "shard_count", "rift_echo", "echo"]:
		_expect(not (forbidden in runtime), "the runtime has a '%s' member; Rift Shards are not authorized" % forbidden)
		_expect(not (forbidden in runtime.character), "the character has a '%s' member" % forbidden)
		_expect(not (forbidden in runtime.player), "the player has a '%s' member" % forbidden)
	print("  1 live of 9, 8 saying plainly why not, and no Shard anywhere in the runtime")
	_done("origin_ring_honesty")


# --- 14. The Foundation Cache's three options ----------------------------------

func _check_foundation_cache_options() -> void:
	print("")
	print("--- The Foundation Cache offers exactly the three canonical packages")
	var packages: Array[Dictionary] = runtime.foundation_packages()
	_expect(packages.size() == 3, "%d package(s); the canon gives exactly three" % packages.size())
	var expected: Array[Array] = [
		[FirstMvpSkillLibrary.FAULTBREAKER_ID, "Garrison Greatsword"],
		[FirstMvpSkillLibrary.SPLINTER_SHOT_ID, "Marrow Bow"],
		[FirstMvpSkillLibrary.EMBERBOLT_ID, "Cantor Wand"],
	]
	for index: int in mini(packages.size(), expected.size()):
		var skill: FirstMvpSkillData = packages[index]["skill"]
		var weapon: FirstMvpWeaponRecord = packages[index]["weapon"]
		_expect(skill.skill_id == expected[index][0],
			"package %d offers %s, not %s" % [index, skill.skill_id, expected[index][0]])
		_expect(weapon.display_name == String(expected[index][1]),
			"package %d offers %s, not %s" % [index, weapon.display_name, expected[index][1]])
		_expect(weapon.problem().is_empty(), "%s is incoherent: %s" % [weapon.display_name, weapon.problem()])

	runtime.open_foundation_cache("verification")
	await _settle(3)
	var panel: FoundationCachePanel = runtime.foundation_cache_panel
	_expect(panel.is_open, "the Foundation Cache did not open")
	_expect(panel.card_count() == 3, "%d card(s) drawn" % panel.card_count())

	# THE FOUR REQUIRED STATEMENTS ARE ON SCREEN BEFORE CONFIRMATION.
	var promise: String = panel.promise_text().to_lower()
	_expect(promise.contains("explore first"), "the panel does not say this is the direction explored first")
	_expect(promise.contains("not a class choice"), "the panel does not say this is not a class choice")
	_expect(promise.contains("not a permanent lock"), "the panel does not say this is not a permanent lock")
	_expect(promise.contains("deterministic"),
		"the panel does not promise deterministic later access to the other two")
	_expect(promise.contains("survey milestone"), "the panel does not say when the others arrive")
	_expect(promise.contains("quick strike"), "the panel does not say Quick Strike stays learned")

	# Each card states its Skill, its weapon and its numbers.
	for index: int in 3:
		var text: String = panel.card_text(index)
		var skill: FirstMvpSkillData = packages[index]["skill"]
		var weapon: FirstMvpWeaponRecord = packages[index]["weapon"]
		_expect(text.contains(skill.display_name), "card %d does not name its Skill" % index)
		_expect(text.contains(weapon.display_name), "card %d does not name its weapon" % index)
		_expect(text.contains(weapon.base_type), "card %d does not name its Base Type" % index)

	# The Spell card states that its damage is Skill-defined.
	panel.select_for_verification(2)
	await _settle(2)
	_expect(panel.detail_text().contains("defined by the Skill rather than by the weapon"),
		"the Spell package does not explain that its damage ignores the weapon")
	panel.close("verification")
	await _settle(2)
	print("  3 packages, 6 required statements on screen, 3 cards naming Skill, weapon and Base Type")
	_done("foundation_cache_options")


# --- 15. The Cache grants exactly once -----------------------------------------

func _check_foundation_cache_grants_once() -> void:
	print("")
	print("--- The chosen package is granted exactly once per character")
	var character: CharacterState = runtime.character
	_expect(not character.foundation_package_granted, "a package was already granted")
	var owned_before: int = character.equipment.owned_items.size()
	var skills_before: int = character.learned_skills.size()

	var granted: bool = runtime.choose_foundation_package(CharacterState.FoundationPackage.PROJECTILE)
	await _settle(3)
	_expect(granted, "the package was not granted")
	_expect(character.foundation_package == CharacterState.FoundationPackage.PROJECTILE,
		"the wrong package was recorded")
	_expect(character.knows_skill(FirstMvpSkillLibrary.SPLINTER_SHOT_ID), "the Skill was not learned")
	_expect(character.learned_skills.size() == skills_before + 1,
		"%d Skill(s) learned; exactly one was chosen" % (character.learned_skills.size() - skills_before))
	_expect(character.equipment.owned_items.size() == owned_before + 1,
		"%d item(s) granted; exactly one weapon was offered" % (character.equipment.owned_items.size() - owned_before))
	_expect(character.equipment.find_owned(&"marrow_bow") != null, "the Marrow Bow is not owned")

	# THE WEAPON IS OWNED, NOT EQUIPPED. Equipping is a separate step.
	_expect(character.equipment.equipped_weapon.weapon_id != &"marrow_bow",
		"the Foundation weapon equipped itself; equipping is a separate deliberate step")

	# The binding was filled, and the eight-slot model is intact.
	_expect(character.bindings.is_bound(FirstMvpSkillLibrary.SPLINTER_SHOT_ID),
		"the chosen Skill was not bound")
	_expect(character.bindings.slots.size() == FirstMvpActiveBindings.SLOT_COUNT,
		"the binding model is not %d slots" % FirstMvpActiveBindings.SLOT_COUNT)
	_expect(character.bindings.bound_count() == 2,
		"%d binding(s) filled; Quick Strike plus the chosen Skill is two" % character.bindings.bound_count())

	# A SECOND CHOICE IS REFUSED AND COUNTED.
	var refusals_before: int = character.duplicate_attempts_refused
	var again: bool = runtime.choose_foundation_package(CharacterState.FoundationPackage.SPELL)
	await _settle(2)
	_expect(not again, "a second package was granted")
	_expect(character.duplicate_attempts_refused == refusals_before + 1,
		"the duplicate choice was not counted as a refusal")
	_expect(character.equipment.owned_items.size() == owned_before + 1, "a second weapon was granted")
	_expect(not character.knows_skill(FirstMvpSkillLibrary.EMBERBOLT_ID), "a second Skill was learned")

	# EQUIPPING THE FOUNDATION WEAPON DISPLACES WITHOUT DESTROYING.
	var displaced: PrototypeWeaponData = character.equipment.equipped_weapon
	var bow: PrototypeWeaponData = character.equipment.find_owned(&"marrow_bow")
	_expect(runtime.equip_owned(bow), "the Marrow Bow could not be equipped")
	await _settle(2)
	_expect(character.equipment.equipped_weapon == bow, "the Marrow Bow is not equipped")
	_expect(character.equipment.is_owned(displaced), "the displaced weapon was destroyed")
	_expect(runtime.player.weapon == bow, "the player is not holding the equipped weapon")
	print("  1 Skill, 1 weapon, owned not equipped, second choice refused, displaced weapon kept")
	_done("foundation_cache_grants_once")


# --- 16. Experience cannot duplicate -------------------------------------------

func _check_experience_cannot_duplicate() -> void:
	print("")
	print("--- An authored encounter pays its experience exactly once")
	var character: CharacterState = runtime.character
	var before: int = character.total_experience
	_expect(character.award_encounter_experience(&"verification_encounter", 10),
		"a fresh encounter did not pay")
	_expect(character.total_experience == before + 10, "the experience was not added")
	var refusals_before: int = character.duplicate_attempts_refused
	_expect(not character.award_encounter_experience(&"verification_encounter", 10),
		"the same encounter paid twice")
	_expect(character.duplicate_attempts_refused == refusals_before + 1,
		"the duplicate award was not counted")
	_expect(character.total_experience == before + 10, "the duplicate award changed the total")

	# LEVELS ARE DERIVED FROM XP, so a Level cannot be minted by any other path.
	var level_before: int = character.level
	var points_before: int = character.level_points
	character.award_encounter_experience(&"verification_level_up",
		ExperienceTable.total_required_for(2) - character.total_experience)
	_expect(character.level == 2, "the character is Level %d after reaching the requirement" % character.level)
	_expect(character.level_points == points_before + ExperienceTable.POINTS_PER_LEVEL,
		"reaching Level 2 did not grant its ordinary Passive point")
	_expect(character.level > level_before, "the level did not rise")

	# THE TWO AUTHORED OPENING KILLS DELIBERATELY DO NOT REACH LEVEL 2 — the
	# curve was not tuned to force a second point, per the brief.
	_expect(2 * ExperienceTable.GRAVEBLADE_EXPERIENCE < ExperienceTable.total_required_for(2),
		"the two authored opening encounters reach Level 2; the brief forbids forcing that")
	await _settle(1)
	print("  one payment per encounter, Level derived from XP, %d + %d XP short of Level 2's %d" % [
		ExperienceTable.GRAVEBLADE_EXPERIENCE, ExperienceTable.GRAVEBLADE_EXPERIENCE,
		ExperienceTable.total_required_for(2),
	])
	_done("experience_cannot_duplicate")


# --- 17. Save round trip -------------------------------------------------------

func _check_save_round_trip() -> void:
	print("")
	print("--- Save and load reproduce the exact character")
	var store: CharacterSave = runtime.character_save
	_expect(not store.uses_production_storage(),
		"the verification is writing to the production character file")

	var character: CharacterState = runtime.character
	# Put a distinctive, fully populated state on the record.
	character.passives.set_earned_points(character.earned_passive_points())
	character.passives.refund_all()
	character.passives.allocate(&"orbiting_guard")
	runtime._apply_passive_effects()
	var expected: Dictionary = _snapshot(character)

	_expect(store.save(character), "the save failed: %s" % store.last_save_status)
	_expect(store.exists(), "no file exists after a successful save")
	# ATOMIC: no stray temporary file survives.
	_expect(not FileAccess.file_exists(store.storage_path + CharacterSave.TEMP_SUFFIX),
		"a temporary write file survived the rename")

	var reloaded: CharacterState = CharacterState.new()
	reloaded.adopt_starting_weapon(load(CanonicalOpeningRuntime.STARTING_SWORD) as PrototypeWeaponData)
	_expect(store.load_into(reloaded, runtime.skills, runtime.weapon_records),
		"the save could not be loaded: %s" % store.last_load_status)
	_expect(store.last_corrections.is_empty(),
		"the load corrected %s; a round trip must need none" % ", ".join(store.last_corrections))

	var actual: Dictionary = _snapshot(reloaded)
	for key: String in expected.keys():
		_expect(str(actual.get(key, "<missing>")) == str(expected[key]),
			"%s came back as %s, not %s" % [key, actual.get(key, "<missing>"), expected[key]])

	# A CORRUPTED FILE IS REFUSED, not half-applied.
	var corrupt: FileAccess = FileAccess.open(store.storage_path, FileAccess.WRITE)
	corrupt.store_string("this is not a config file\n[unclosed section\nkey = = =\n")
	corrupt.store_8(0)
	corrupt.store_8(1)
	corrupt.close()
	var wrecked: CharacterState = CharacterState.new()
	wrecked.adopt_starting_weapon(load(CanonicalOpeningRuntime.STARTING_SWORD) as PrototypeWeaponData)
	var loaded_corrupt: bool = store.load_into(wrecked, runtime.skills, runtime.weapon_records)
	_expect(not loaded_corrupt, "a corrupted file loaded successfully")
	_expect(wrecked.level == ExperienceTable.STARTING_LEVEL, "a corrupted file left a partial character")
	_expect(not wrecked.foundation_package_granted, "a corrupted file granted a package")

	# A CLAIMED MILESTONE POINT WITH NO RECOGNITION BEHIND IT IS REFUSED.
	var forged: ConfigFile = ConfigFile.new()
	forged.set_value("meta", "schema_version", CharacterSave.SCHEMA_VERSION)
	forged.set_value("progress", "milestone_passive_point_claimed", true)
	forged.set_value("progress", "nexus_recognition_complete", false)
	forged.set_value("passives", "milestone_points", 4)
	forged.set_value("character", "level", 9)
	forged.set_value("character", "total_experience", 0)
	forged.save(store.storage_path)
	var cheated: CharacterState = CharacterState.new()
	cheated.adopt_starting_weapon(load(CanonicalOpeningRuntime.STARTING_SWORD) as PrototypeWeaponData)
	store.load_into(cheated, runtime.skills, runtime.weapon_records)
	_expect(cheated.milestone_points == 0,
		"a forged file granted %d milestone point(s)" % cheated.milestone_points)
	_expect(cheated.level == ExperienceTable.STARTING_LEVEL,
		"a forged Level survived; the curve must decide")
	_expect(cheated.level_points == 0, "a forged Level granted its point")
	_expect(not store.last_corrections.is_empty(), "the forged file was accepted without correction")

	# Put the good save back, so the smoke script's own reload check sees it.
	store.save(character)
	await _settle(1)
	print("  %d field(s) round-tripped exactly; corruption refused; forged points and Levels refused" % expected.size())
	_done("save_round_trip")


func _snapshot(character: CharacterState) -> Dictionary:
	return {
		"level": character.level,
		"experience": character.total_experience,
		"milestone": int(character.milestone),
		"milestone_points": character.milestone_points,
		"level_points": character.level_points,
		"allocated": Array(character.passives.allocated_ids_without_origin()).map(
			func(id: StringName) -> String: return String(id)),
		"learned": Array(character.learned_skills).map(func(id: StringName) -> String: return String(id)),
		"bindings": Array(character.bindings.to_string_array()),
		"owned": Array(character.equipment.owned_ids()).map(func(id: StringName) -> String: return String(id)),
		"equipped": String(character.equipment.equipped_weapon.weapon_id),
		"watchsteel_granted": character.watchsteel_granted,
		"broken_watch_complete": character.broken_watch_complete,
		"nexus_recognition": character.nexus_recognition_complete,
		"mara_conversation": character.mara_first_conversation_complete,
		"point_claimed": character.milestone_passive_point_claimed,
		"package": int(character.foundation_package),
		"package_granted": character.foundation_package_granted,
		"encounters": Array(character.awarded_encounters.keys()).map(
			func(id: StringName) -> String: return String(id)),
	}


# --- 18. The store cannot reach Prototype Zero ---------------------------------

func _check_save_refuses_prototype_zero() -> void:
	print("")
	print("--- The character store REFUSES both Prototype Zero files, however they are spelled")
	var store: CharacterSave = CharacterSave.new()
	# Every alias the D-192 calculator exists to collapse.
	var aliases: Array[String] = [
		PrototypeSettings.PATH,
		PrototypeLabState.PATH,
		ProjectSettings.globalize_path(PrototypeSettings.PATH),
		ProjectSettings.globalize_path(PrototypeLabState.PATH),
		ProjectSettings.globalize_path("user://").path_join(".").path_join(PrototypeSettings.FILE_NAME),
		ProjectSettings.globalize_path("user://").path_join("nowhere").path_join("..").path_join(PrototypeLabState.FILE_NAME),
		ProjectSettings.globalize_path(PrototypeSettings.PATH).to_lower(),
		ProjectSettings.globalize_path(PrototypeLabState.PATH).to_upper(),
	]
	for alias: String in aliases:
		var accepted: bool = store.set_storage_path(alias)
		_expect(not accepted, "the store accepted %s, which resolves onto a Prototype Zero file" % alias)
	# A POSITIVE CONTROL: a guard that refuses everything protects nothing.
	var isolated: String = runtime.character_save.storage_path
	_expect(store.set_storage_path(isolated), "the store refused its own isolated path")
	_expect(not store.would_touch_prototype_zero(), "the isolated path reports as a production file")
	# And the real character file is accepted, because that is its own file.
	_expect(store.set_storage_path(CharacterSave.PATH), "the store refused the character file itself")
	_expect(CharacterSave.PATH != PrototypeSettings.PATH and CharacterSave.PATH != PrototypeLabState.PATH,
		"the character file is one of the Prototype Zero files")
	print("  %d alias(es) refused; the isolated path and the character file both accepted" % aliases.size())
	_done("save_refuses_prototype_zero")


# --- 19. The First Footing boundary --------------------------------------------

func _check_first_footing_boundary() -> void:
	print("")
	print("--- Reaching the forward route stops the slice, and nothing beyond it exists")
	_expect(not runtime.first_footing_reached, "the boundary was already reached")
	runtime.player.global_position = runtime.rift_nexus.forward_route()
	await _settle(6)
	_expect(runtime.first_footing_reached, "reaching the forward route did not stop the slice")
	_expect(runtime.opening_hud.boundary_is_shown(), "no boundary message was shown")
	_expect(runtime.character.has_reached(CharacterState.Milestone.READY_FOR_FIRST_FOOTING),
		"the final milestone was not reached")

	# NOTHING LOADS, OPENS OR IS GENERATED.
	_expect(get_tree().current_scene == runtime or get_tree().current_scene == null,
		"reaching the boundary loaded another scene")
	_expect(not runtime.any_modal_open(), "reaching the boundary opened a modal")

	# FIRST FOOTING IS NOT IMPLEMENTED.
	for forbidden: String in ["res://scripts/first_mvp/first_footing.gd",
		"res://scenes/first_mvp/first_footing.tscn",
		"res://scripts/first_mvp/severed_threshold/first_footing.gd",
		"res://scripts/first_mvp/run_graph.gd",
		"res://scripts/first_mvp/module_library.gd"]:
		_expect(not ResourceLoader.exists(forbidden), "%s exists; First Footing is not authorized" % forbidden)
	for forbidden: String in ["marrowshot", "rift_step", "survey_excursion", "first_footing_room",
		"formation", "run_graph", "module_library", "intensity", "distortion", "pursuit"]:
		_expect(not (forbidden in runtime), "the runtime has a '%s' member; that is the next milestone" % forbidden)
	print("  the slice stops, nothing loads, and no First Footing file or member exists")
	_done("first_footing_boundary")


# --- 20. Excluded systems ------------------------------------------------------

func _check_excluded_systems_absent() -> void:
	print("")
	print("--- Every system Gate 1E excludes is absent")
	# By member name, on the live objects.
	for forbidden: String in ["shaping_board", "augment", "augments", "configuration", "keystone",
		"forge", "crafting", "bindstone", "resonance", "vault", "reliquary", "archive",
		"run_assembly", "echo_hunt", "mastery", "procedural", "seed", "affix", "prefix",
		"suffix", "rarity", "wrought", "tier", "field_pack", "salvage", "profile"]:
		_expect(not (forbidden in runtime), "the runtime has a '%s' member" % forbidden)
		_expect(not (forbidden in runtime.character), "the character has a '%s' member" % forbidden)

	# By source scan, comments stripped, over Gate 1E's own largest files.
	for path: String in [RUNTIME_SCRIPT, THRESHOLD_SCRIPT, NEXUS_SCRIPT]:
		var code: String = _code_only(FileAccess.get_file_as_string(path))
		for forbidden: String in ["RiftShard", "RiftEcho", "ShapingBoard", "Augment", "Forge",
			"Reliquary", "Distortion", "EchoHunt", "RunAssembly", "Keystone", "Marrowshot",
			"RiftStep", "Ignite", "Bleed", "Unravel"]:
			_expect(not code.contains(forbidden),
				"%s names %s in code" % [path.get_file(), forbidden])

	# No new asset was extracted, and no new asset path is named by Gate 1E's
	# own environment code. Both layouts read every path from an accepted record.
	for path: String in [THRESHOLD_SCRIPT, NEXUS_SCRIPT]:
		var raw: String = FileAccess.get_file_as_string(path)
		_expect(not raw.contains("res://assets/"),
			"%s names an asset path directly; every path must come from an accepted record" % path.get_file())

	# The character store is the ONLY Gate 1E file that may name persistent
	# storage, and it lives outside every scanned first-MVP tree.
	for path: String in [RUNTIME_SCRIPT, THRESHOLD_SCRIPT, NEXUS_SCRIPT,
		"res://scripts/first_mvp/nexus/rift_anchor.gd",
		"res://scripts/first_mvp/nexus/mara_veyl.gd",
		"res://scripts/first_mvp/nexus/first_mvp_dialogue.gd",
		"res://scripts/first_mvp/canonical_opening/foundation_skill_practice.gd"]:
		var code: String = _code_only(FileAccess.get_file_as_string(path))
		for leak: String in ["ConfigFile", "ResourceSaver", "user://"]:
			_expect(not code.contains(leak),
				"%s names %s; only CharacterSave may touch storage, and it is outside scripts/first_mvp/" % [
					path.get_file(), leak,
				])
	print("  no excluded member, no excluded term in code, no direct asset path, no storage leak")
	_done("excluded_systems_absent")


# --- 21. Prototype Zero is untouched -------------------------------------------

func _check_prototype_zero_unchanged() -> void:
	print("")
	print("--- Prototype Zero's own records and entrypoint are unchanged")
	_expect(String(ProjectSettings.get_setting("application/run/main_scene")) == "res://scenes/app/prototype_app.tscn",
		"the project entrypoint was changed; the first MVP must not take it over")

	# The canonical Quick Strike record is byte-for-byte what it was.
	var quick_strike: QuickStrikeData = load(FirstMvpSkillLibrary.QUICK_STRIKE_RECORD)
	_expect(is_equal_approx(quick_strike.action_time, 0.80), "quick_strike.tres action time moved")
	_expect(is_equal_approx(quick_strike.release_marker_normalized, 0.325), "the release marker moved")
	_expect(is_equal_approx(quick_strike.reach, 1.65), "the Quick Strike reach moved")
	_expect(is_equal_approx(quick_strike.soft_target_cone_degrees, 65.0), "the D-178 soft-target cone moved")
	_expect(is_equal_approx(quick_strike.mana_cost, 5.0), "the Quick Strike Mana cost moved")
	_expect(quick_strike.maximum_targets == 1, "Quick Strike's one-target rule moved")

	# The Graveblade record, and both Gate 1D weapons.
	var graveblade: GravebladeData = load("res://data/prototype_zero/graveblade.tres")
	_expect(is_equal_approx(graveblade.max_life, 300.0), "the Graveblade's 300 Life moved")
	var worn: PrototypeWeaponData = load(CanonicalOpeningRuntime.STARTING_SWORD)
	var watchsteel: PrototypeWeaponData = load(CanonicalOpeningRuntime.WATCHSTEEL_SWORD)
	_expect(is_equal_approx(worn.physical_damage, 100.0), "the Worn Sword's 100 damage moved")
	_expect(is_equal_approx(watchsteel.physical_damage, 150.0), "the Watchsteel Sword's 150 damage moved")
	_expect(worn.hits_to_defeat(graveblade.max_life) == 3, "the three-Hit relationship moved")
	_expect(watchsteel.hits_to_defeat(graveblade.max_life) == 2, "the two-Hit relationship moved")

	# `DamageEvent` itself was not edited; Gate 1E extended it in a new file.
	var event: DamageEvent = DamageEvent.physical(1, null, null, 10.0)
	_expect(is_equal_approx(event.final_life_damage, event.raw_physical_damage),
		"DamageEvent's final = raw rule moved")
	_expect(not ("damage_type" in event), "DamageEvent gained a damage_type; Gate 1E must extend, not edit")
	var typed: FirstMvpDamageEvent = FirstMvpDamageEvent.of_type(1, null, null, 10.0, "Fire")
	_expect("damage_type" in typed, "FirstMvpDamageEvent has no damage_type")
	_expect(typed is DamageEvent, "FirstMvpDamageEvent is not a DamageEvent; the actors would refuse it")

	# `LabProgress` gained nothing, and no first-MVP reference was wired into it.
	var progress: LabProgress = LabProgress.new(load("res://data/prototype_zero/progression.tres"))
	for forbidden: String in ["save", "load", "write", "serialize", "schema_version", "migrate",
		"character", "character_save", "passives", "nexus", "milestone_points"]:
		_expect(not (forbidden in progress), "LabProgress gained a '%s' member" % forbidden)
	print("  entrypoint, Quick Strike, the Graveblade, both swords, DamageEvent and LabProgress all unchanged")
	_done("prototype_zero_unchanged")


# --- 22. Every new surface is actually VISIBLE ---------------------------------

## THE GATE F DEFECT CLASS, AND THE ONLY CHECK THAT CATCHES IT.
##
## Gate F shipped a HUD and four modals that nobody could see while every
## text-content check passed, because `set_anchors_preset(PRESET_FULL_RECT)` on a
## Control built in CODE sets the anchors and leaves the offsets at zero — a
## full-rect anchor over a zero-size rect — and `PRESET_CENTER` anchors the
## top-left corner to the middle and grows down and right unless the grow
## directions say otherwise. Its own report states the lesson plainly: reading
## the right words out of a Control tree proves the words EXIST, not that anyone
## can see them.
##
## Every Gate 1E assertion above this one reads TEXT. This is the only one that
## asks whether it is on screen, and it is ported from
## `gate_f_verification.gd::_check_surface_is_on_screen()` deliberately rather
## than reinvented.
func _check_surfaces_are_on_screen() -> void:
	print("")
	print("--- Every Gate 1E surface covers the viewport and draws its text inside it")
	# Each modal must be OPEN to be measured; a hidden Control has no useful rect.
	runtime.open_origin_ring("on-screen check")
	await _settle(3)
	_measure_surface(runtime.origin_ring_panel, "Origin Ring")
	runtime.origin_ring_panel.close("on-screen check")
	await _settle(2)

	runtime.open_dialogue("on-screen check")
	await _settle(3)
	_measure_surface(runtime.dialogue_panel, "first conversation")
	runtime.dialogue_panel.close("on-screen check")
	await _settle(2)

	# The Foundation Cache was already granted by an earlier check, so it refuses
	# to open through the runtime. Opened directly, because what is being measured
	# is the LAYOUT rather than the grant rule (which §15 already proves).
	runtime.foundation_cache_panel.open()
	await _settle(3)
	_measure_surface(runtime.foundation_cache_panel, "Foundation Cache")
	runtime.foundation_cache_panel.close("on-screen check")
	await _settle(2)

	# The HUD is always visible and is not a modal.
	_measure_surface(runtime.opening_hud, "character HUD")
	_expect(not runtime.any_modal_open(), "a modal was left open by the on-screen check")
	_done("surfaces_are_on_screen")


func _measure_surface(root: Control, what: String) -> void:
	var view: Rect2 = get_viewport().get_visible_rect()
	var rect: Rect2 = root.get_global_rect()
	var offscreen: PackedStringArray = PackedStringArray()
	var total: int = _collect_offscreen_text(root, view, offscreen)
	print("  %-20s root %.0f x %.0f in a %.0f x %.0f window; %d text control(s), %d off screen" % [
		what, rect.size.x, rect.size.y, view.size.x, view.size.y, total, offscreen.size(),
	])
	_expect(rect.size.x >= view.size.x - 1.0 and rect.size.y >= view.size.y - 1.0,
		"%s root is %.0f x %.0f, not the %.0f x %.0f viewport" % [
			what, rect.size.x, rect.size.y, view.size.x, view.size.y,
		])
	_expect(total > 0, "%s shows no text at all" % what)
	_expect(offscreen.is_empty(), "%s draws text off screen or at zero size: %s" % [
		what, ", ".join(offscreen),
	])


func _collect_offscreen_text(node: Node, view: Rect2, into: PackedStringArray) -> int:
	var total: int = 0
	for child: Node in node.get_children():
		var control: Control = child as Control
		if control != null and control.is_visible_in_tree():
			var text: String = ""
			var label: Label = control as Label
			if label != null:
				text = label.text
			var button: Button = control as Button
			if button != null and text.is_empty():
				text = button.text
			if not text.strip_edges().is_empty():
				total += 1
				var rect: Rect2 = control.get_global_rect()
				if rect.size.x <= 0.0 or rect.size.y <= 0.0 or not view.intersects(rect):
					into.append("%s at (%.0f, %.0f) %.0f x %.0f" % [
						control.name, rect.position.x, rect.position.y, rect.size.x, rect.size.y,
					])
		total += _collect_offscreen_text(child, view, into)
	return total


# --- 23. NO WALKABLE ROOM IS AN UNREACHABLE ISLAND -----------------------------

## THE CHECK THAT WOULD HAVE CAUGHT THE WALLED-OFF ALCOVE, AND THE REASON IT IS
## NOT SOCKET-BASED.
##
## Every reachability assertion above walks to a SOCKET, and sockets are placed
## where things happen — an entry, a station, a gate. The Nexus Threshold's
## `WEST_ALCOVE` holds no socket, so 70 m^2 of authored ground sat completely
## sealed behind a boundary wall that spanned its only opening, baked as an
## unreachable navigation island, and every socket check passed. The east alcove,
## built correctly, is what made the asymmetry visible once it was measured.
##
## So this walks to the CENTRE OF EVERY AUTHORED ROOM in both new layouts, which
## is a property of the geometry rather than of where anyone thought to put a
## marker.
func _check_no_navigation_islands() -> void:
	print("")
	print("--- Every authored room in both new spaces is reachable, not just every socket")
	var map: RID = runtime.navigation_map()
	var start: Vector3 = runtime.landing_layout.player_start()
	var unreachable: PackedStringArray = PackedStringArray()
	var rooms: int = 0

	for entry: Dictionary in [
		{"layout": runtime.nexus_threshold, "rects": NexusThresholdLayout.WALKABLE, "name": "Nexus Threshold"},
		{"layout": runtime.rift_nexus, "rects": RiftNexusLayout.WALKABLE, "name": "Rift Nexus"},
	]:
		var layout: Node3D = entry["layout"]
		for rect: Rect2 in (entry["rects"] as Array[Rect2]):
			rooms += 1
			var centre: Vector3 = layout.global_transform * Vector3(
				rect.position.x + rect.size.x * 0.5, 0.0, rect.position.y + rect.size.y * 0.5
			)
			var nearest: Vector3 = NavigationServer3D.map_get_closest_point(map, centre)
			var offset: float = Vector2(nearest.x - centre.x, nearest.z - centre.z).length()
			if offset > 2.0:
				unreachable.append("%s room at (%.0f, %.0f) has no walkable ground under its centre" % [
					entry["name"], rect.position.x, rect.position.y,
				])
				continue
			var path: PackedVector3Array = NavigationServer3D.map_get_path(map, start, centre, true)
			var missed: float = 999.0
			if path.size() >= 2:
				var arrival: Vector3 = path[path.size() - 1]
				missed = Vector2(arrival.x - nearest.x, arrival.z - nearest.z).length()
			if missed > 1.0:
				unreachable.append("%s room at (%.0f, %.0f) is an ISLAND — %.2f m short" % [
					entry["name"], rect.position.x, rect.position.y, missed,
				])
	_expect(unreachable.is_empty(), "unreachable authored ground: %s" % ", ".join(unreachable))
	_expect(rooms == NexusThresholdLayout.WALKABLE.size() + RiftNexusLayout.WALKABLE.size(),
		"walked %d room(s); the two layouts declare %d" % [
			rooms, NexusThresholdLayout.WALKABLE.size() + RiftNexusLayout.WALKABLE.size(),
		])
	await _settle(1)
	print("  all %d authored room centres reachable by path from the Landing start" % rooms)
	_done("no_navigation_islands")


# --- 24. The adversarial review's findings stay fixed --------------------------

## Each of these is a REGRESSION TEST FOR A DEFECT THAT WAS REAL. They are
## grouped rather than scattered so the reason they exist stays legible: an
## independent review found nineteen defects in code whose two suites already
## passed, and these are the ones a check can hold down.
func _check_review_findings_stay_fixed() -> void:
	print("")
	print("--- The review's confirmed defects stay fixed")

	# THE GUARANTEED WATCHSTEEL IS OWNED THE MOMENT IT IS GRANTED, not when it is
	# equipped. Granting only the latch lost the sword permanently on any reload
	# that happened before the player pressed Equip.
	var probe: CharacterState = CharacterState.new()
	probe.adopt_starting_weapon(load(CanonicalOpeningRuntime.STARTING_SWORD) as PrototypeWeaponData)
	var watchsteel: PrototypeWeaponData = load(CanonicalOpeningRuntime.WATCHSTEEL_SWORD) as PrototypeWeaponData
	_expect(probe.grant_watchsteel(watchsteel), "a fresh character could not be granted the Watchsteel")
	probe.equipment.pick_up(watchsteel)
	_expect(probe.equipment.find_owned(&"watchsteel_sword") != null,
		"the Watchsteel is not owned after being granted")
	_expect(probe.equipment.equipped_weapon.weapon_id != &"watchsteel_sword",
		"granting equipped it; equipping must stay a separate deliberate step")
	# And the save carries ownership, so a reload cannot lose it.
	var store: CharacterSave = runtime.character_save
	var before: String = store.storage_path
	_expect(store.save(probe), "the probe character could not be saved")
	var reloaded: CharacterState = CharacterState.new()
	reloaded.adopt_starting_weapon(load(CanonicalOpeningRuntime.STARTING_SWORD) as PrototypeWeaponData)
	store.load_into(reloaded, runtime.skills, runtime.weapon_records)
	_expect(reloaded.watchsteel_granted, "the granted latch did not survive the save")
	_expect(reloaded.equipment.find_owned(&"watchsteel_sword") != null,
		"the Watchsteel was granted but not owned after a reload; it would be lost forever")
	_expect(store.storage_path == before, "the probe save moved the storage path")

	# THE EQUIPMENT STATION EQUIPS. `equip_owned()` had no caller in the running
	# game at all, so a granted Foundation weapon could never be held.
	_expect(runtime.has_method("open_equipment"),
		"there is no equipment station interaction; equip_owned() would have no caller")
	var owned_before: int = runtime.character.equipment.owned_items.size()
	var equipped_before: PrototypeWeaponData = runtime.character.equipment.equipped_weapon
	runtime.open_equipment("verification")
	await _settle(2)
	if owned_before > 1:
		_expect(runtime.character.equipment.equipped_weapon != equipped_before,
			"the equipment station did not change what is equipped")
		_expect(runtime.character.equipment.is_owned(equipped_before),
			"the displaced weapon was destroyed")
		_expect(runtime.player.weapon == runtime.character.equipment.equipped_weapon,
			"the player is not holding what the character has equipped")
	_expect(runtime.character.equipment.owned_items.size() == owned_before,
		"equipping changed how many items are owned")

	# START FRESH IS NOT ON A BOUND ACTION'S KEY. `quick_restart` is F5; claiming
	# it swallowed the inherited Restart and deleted the save instead.
	var runtime_source: String = _code_only(FileAccess.get_file_as_string(RUNTIME_SCRIPT))
	_expect(not runtime_source.contains("KEY_F5"),
		"the runtime claims F5, which is the bound quick_restart action's key")
	_expect(runtime_source.contains("KEY_F9"), "Start Fresh has no physical key")

	# HOVER PREVIEWS; IT MUST NOT COMMIT. With one field, moving the mouse toward
	# the button re-selected whatever it crossed — permanently, in the Cache.
	runtime.open_foundation_cache("verification hover")
	await _settle(3)
	if runtime.foundation_cache_panel.is_open:
		runtime.foundation_cache_panel.select_for_verification(0)
		var committed: int = runtime.foundation_cache_panel.selected_index
		runtime.foundation_cache_panel.hover_for_verification(2)
		await _settle(1)
		_expect(runtime.foundation_cache_panel.selected_index == committed,
			"hovering a Foundation Cache card changed what Choose would take")
		runtime.foundation_cache_panel.close("verification")
		await _settle(2)
	runtime.open_origin_ring("verification hover")
	await _settle(3)
	var ring: OriginRingPanel = runtime.origin_ring_panel
	ring.select_for_verification(&"first_fracture")
	var ring_committed: StringName = ring.selected
	ring.hover_for_verification(&"resonant_shape")
	await _settle(1)
	_expect(ring.selected == ring_committed,
		"hovering an Origin Ring row changed what Allocate would act on")
	ring.close("verification")
	await _settle(2)

	# THE AREA HIT TRACES LINE OF SIGHT FROM CHEST HEIGHT, not from the feet,
	# which sit exactly on the ground plane every plate's top face occupies.
	var skill_source: String = _code_only(FileAccess.get_file_as_string(
		"res://scripts/skills/first_mvp_skill_action.gd"))
	_expect(skill_source.contains("is_obstructed(\n\t\t\torigin + Vector3.UP * 1.10")
			or skill_source.contains("origin + Vector3.UP * 1.10"),
		"the Area Hit's obstruction ray does not start at chest height")

	# THE PROJECTILE RESOLVES WHAT IT ALREADY OVERLAPS. `cast_motion` reports a
	# clear path for a shape that is already touching something.
	var projectile_source: String = _code_only(FileAccess.get_file_as_string(
		"res://scripts/skills/first_mvp_skill_projectile.gd"))
	_expect(projectile_source.contains("var at_start:"),
		"the projectile does not test what it already overlaps before sweeping")

	# LEAVING THE SAFE REGION RE-ENABLES WHAT ENTERING IT DISABLED.
	_expect(runtime_source.contains("if not character.broken_watch_complete:"),
		"leaving the safe region does not restore the Graveblades it disabled")
	print("  ownership on grant, an equip station, F9 not F5, hover-is-preview, chest-height LOS,")
	print("  start-overlap resolution, and a symmetric safe region")
	_done("review_findings_stay_fixed")


# --- The owed-set comparison ---------------------------------------------------

func _check_every_check_ran() -> void:
	print("")
	print("--- Every check function reached its last line")
	var missing: PackedStringArray = PackedStringArray()
	for owed: String in OWED_CHECKS:
		if not _reached.has(owed):
			missing.append(owed)
	var extra: PackedStringArray = PackedStringArray()
	for reached: String in _reached.keys():
		if not (reached in OWED_CHECKS):
			extra.append(reached)
	_expect(missing.is_empty(), "these checks never reached their last line: %s" % ", ".join(missing))
	_expect(extra.is_empty(), "these checks ran but are not in OWED_CHECKS: %s" % ", ".join(extra))
	print("  %d of %d owed check function(s) completed" % [_reached.size(), OWED_CHECKS.size()])


func _done(name: String) -> void:
	_reached[name] = true


# --- Harness -------------------------------------------------------------------

func _expect(condition: bool, failure_message: String) -> void:
	_checks += 1
	if not condition:
		_failures.append(failure_message)


func _settle(frames: int) -> void:
	for _frame: int in frames:
		await get_tree().physics_frame


func _await_navigation() -> void:
	for _frame: int in 60:
		if NavigationServer3D.map_get_iteration_id(runtime.navigation_map()) > 0:
			return
		await get_tree().physics_frame


## Strips comment lines so a claim ABOUT a forbidden term cannot be mistaken for
## a use of it — the Gate 1C lesson, where a scope scan fired on the very
## sentence explaining the scope.
func _code_only(source: String) -> String:
	var kept: PackedStringArray = PackedStringArray()
	for line: String in source.split("\n"):
		var trimmed: String = line.strip_edges()
		if trimmed.begins_with("#"):
			continue
		kept.append(line)
	return "\n".join(kept)
