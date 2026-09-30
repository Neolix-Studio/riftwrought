class_name PrototypeZeroRoom
extends Node3D
## Prototype Zero — room root (Gates B, C, D, and E).
##
## Owns the calibration room, the navigation region, the player, the camera rig,
## the destination marker, input-family tracking, the Gate C target fixtures, the
## Graveblade ROSTER and its attack coordinator, the Gate E progression director,
## the ground drop, the overlays, and the small local log.
##
## Gate E added exactly what D-184 authorizes and nothing more: the deterministic
## progression director, an enemy roster that can hold a wave instead of one
## enemy, the two modal surfaces and their pause/neutral contract, and the
## ground-drop interaction.
##
## Gate F (D-189) added the layer Gate E deliberately left out: the restrained
## §17 HUD, the §18 synchronized feedback, the §20.1 Fallen overlay, the §20.2
## trusted Restart, Pause, the §21 settings surfaces, and the wiring to the
## persistent app that owns the two versioned files. The room does NOT own those
## files: `PrototypeApp` does, and it hands the room a settings store, an audio
## director, and a display manager. Run standalone — which every Gate A-E suite
## still does — the room builds its own §21-default settings and its own audio
## director instead, so an earlier suite measures the same room the app loads.
##
## The world scale, room, camera, and movement speed here are the values the
## project owner approved and LOCKED under decision D-175: one Godot unit is one
## metre, an 18 x 14 m clear floor, 5.0 m/s maximum speed, and a camera 19 m out
## at 55 degrees with a 45-degree field of view. They are first Prototype Zero
## calibration values, not immutable first-MVP balance.

const PLAYER_SCENE: String = "res://scenes/actors/prototype_player.tscn"
const FIXTURE_SCENE: String = "res://scenes/actors/prototype_target_fixture.tscn"
const WORLD_MASK: int = 1
const TARGET_MASK: int = 4
## The cursor-to-ground-to-navigation resolution and the held-command refresh
## cadence were extracted to scripts/movement/ under D-195, so the Gate 1A
## calibration hall reuses this exact click-to-move behaviour instead of
## carrying a second, subtly different copy of it. The names below are unchanged
## and now point at the one shared definition.
const RAY_LENGTH: float = PrototypeGroundPointer.RAY_LENGTH
## Specification §9.3: a held move command refreshes at a bounded rate rather
## than every rendered frame.
const HOLD_REFRESH_SECONDS: float = PrototypeMouseHold.REFRESH_SECONDS
## How far a clicked point may sit from the navigation mesh before the marker
## reports the destination as adjusted rather than accepted.
const ADJUST_EPSILON: float = PrototypeGroundPointer.ADJUST_EPSILON

@export_group("Navigation bake, provisional metres")
@export var agent_radius: float = 0.40
@export var agent_height: float = 1.80
@export var agent_max_climb: float = 0.20
@export var agent_max_slope: float = 20.0
@export var nav_cell_size: float = 0.15

@export_group("Calibration steps")
@export var camera_distance_step: float = 1.0
@export var camera_angle_step: float = 2.5
@export var speed_step: float = 0.2

var room: CalibrationRoom
var player: PrototypePlayer
var acquisition: TargetAcquisition
var combat_overlay: Node
var encounter_overlay: Node
var combat_visuals: GateCDebugVisuals
var fixtures: Array[PrototypeTargetFixture] = []

## Gate E: the Graveblade ROSTER. Gate D held exactly one enemy and asserted the
## room had no way to make a second; D-184 authorizes deterministic waves of one,
## two, and three, so the single reference became a list. The PROGRESSION
## DIRECTOR owns what goes into it — the room only holds it, wires it, and hands
## it to the targeting query.
var graveblades: Array[PrototypeGraveblade] = []
## Monotonic, so three identical Graveblades get distinguishable names in the
## coordinator's log and the debug surface. It is not an id anything depends on.
var graveblades_spawned: int = 0

## The first LIVING Graveblade, or the most recent one when none is alive. Kept
## as a read-only accessor because Gates B, C, and D all address "the Graveblade"
## in the singular, and with one enemy present this returns exactly what it
## always did.
var graveblade: PrototypeGraveblade:
	get:
		var last: PrototypeGraveblade = null
		for enemy: PrototypeGraveblade in graveblades:
			if not is_instance_valid(enemy):
				continue
			last = enemy
			if enemy.is_alive():
				return enemy
		return last

var attack_coordinator: AttackCoordinator
## Gate E. Owns the five stages, the rewards, the waves, and the ground drop.
var director: PrototypeProgressionDirector
var starter_sword: PrototypeWeaponData
var honed_sword: PrototypeWeaponData
var item_comparison: GateEItemComparison
var passive_card: GateEPassiveCard
var lab_overlay: Node
var soft_target: PrototypeTargetable = null
## When the current soft target was chosen, for the bounded retention in §11.2.
var soft_target_since_msec: int = 0
var last_aim_reason: String = "none"
var last_aim_source: String = "none"
## Which D-178 priority group decided the last controller pick: "in reach" when a
## candidate was already inside Quick Strike's reach, "approach" otherwise.
var last_aim_group: String = "none"
var slow_motion: bool = false
var camera_rig: PrototypeCameraRig
var marker: DestinationMarker
var input_family: InputFamilyTracker
var overlay: Node
var debug_visuals: GateBDebugVisuals

# --- Gate F: what the persistent app hands down (specification §7.1) ---------
## Null when the room was loaded on its own, which is how the Gate A-E suites
## run it. Everything below tolerates that and builds a local default instead.
var app: Node = null
var settings: PrototypeSettings
var audio: PrototypeAudioDirector
var display: PrototypeDisplayManager
## Set by `configure_app()` BEFORE the room enters the tree. When present the
## room adopts it and frees its own, so the shipped flow has exactly one tracker.
var external_input_family: InputFamilyTracker = null
## A saved lab state to reconstruct, or null for a new laboratory.
var saved_state: PrototypeLabState = null

# --- Gate F surfaces ---------------------------------------------------------
var hud: PrototypeHUD
var feedback: PrototypeCombatFeedback
var pause_menu: PrototypePauseMenu
var fallen_overlay: PrototypeFallenOverlay
var settings_modal: PrototypeSettingsModal
var confirm_modal: PrototypeConfirmModal

## Gates B-E instrumentation cards. Visible by default so a standalone suite run
## and its evidence screenshots are unchanged; the app hides them and F3 brings
## them back, because §22 is explicit that the debug overlay "is not player-facing
## final UI".
var instrumentation_visible: bool = true

# --- Gate F instrumentation (specification §22) ------------------------------
## True once the director has entered its first stage. The room's `_ready` awaits
## navigation synchronisation before that, so anything driving the room from
## outside — the app, or the Gate F suite — needs one honest "it has begun" flag
## rather than a guessed frame count.
var lab_begun: bool = false
var pauses: int = 0
var resumes: int = 0
var restarts: int = 0
var falls: int = 0
var last_killing_source: String = "none"
var last_gate_f_event: String = "none"

## §20.1: the death response plays BEFORE Fallen fades in. `Death_A` is 0.80 s,
## so the overlay waits a little longer than the collapse and then takes over.
const FALLEN_DELAY: float = 0.90
var _fallen_countdown: float = -1.0
var _fallen_event: DamageEvent = null
## True while §20.1's "pause offline combat" is in force: the fall switched every
## Graveblade's DECISION states off, and any revival has to switch them back on
## or the room stays permanently docile. Tracked as a flag rather than blanket
## re-enabling on every reset, so a check that deliberately parks an enemy with
## `set_ai_enabled(false)` is not silently overridden.
var _decisions_suspended_by_fall: bool = false

## The D-178 / D-180 accepted soft-targeting values, read from the CANONICAL
## authored record rather than from the live one, so the default 70 / 100
## restores exactly what the project owner accepted rather than approximately —
## and so a second laboratory in the same process starts from the authored
## numbers rather than from whatever the first one last scaled them to (D-191).
var _locked_cone_degrees: float = 65.0
var _locked_soft_target_distance: float = 5.0

var nav_region: NavigationRegion3D
var navmesh_polygon_count: int = 0
var navmesh_area: float = 0.0
var last_bake_msec: int = 0

## Ordered Hit / kill / fall trace, so the event ORDERING Gate D has to prove is
## a recorded fact rather than a claim. Newest last; bounded so a long session
## cannot grow it without limit.
var combat_events: Array[Dictionary] = []

## Gate E: when each attacker's release actually STARTED, so specification
## §14.3's "minimum 0.25-second gap between enemy release starts" is a measured
## interval between different attackers rather than a claim.
var enemy_release_starts: Array[Dictionary] = []

var log_lines: PackedStringArray = PackedStringArray()
var accepted_commands: int = 0
var adjusted_commands: int = 0
var rejected_commands: int = 0
var ui_clicks_absorbed: int = 0

## Verification seam. `gate_b_verification.gd` uses this only when synthetic
## joypad events cannot reach the Input singleton in a given run; ordinary play
## never touches it.
var _stick_override_active: bool = false
var _stick_override: Vector2 = Vector2.ZERO

var _default_max_speed: float = 5.0
## The ONE shared click-and-hold timer (D-195). Both names below are kept as
## forwarding views so every existing call site in this file is untouched.
var _mouse_hold: PrototypeMouseHold = PrototypeMouseHold.new()
var _mouse_hold_active: bool:
	get:
		return _mouse_hold.active
	set(value):
		_mouse_hold.active = value
var _hold_timer: float:
	get:
		return _mouse_hold.timer
	set(value):
		_mouse_hold.timer = value
var _verifying: bool = false
var _cursor_override: Variant = null
## A held left mouse button that an attack suspended. It is re-armed at release,
## which is the mouse half of the specification §9.5 rule that an already held
## movement intent may resume and cancel the remaining recovery. The controller
## half lives in the player, where the stick's staleness already expresses it.
var _mouse_hold_suspended: bool = false

## Deterministic practice-post layout. Chosen so the manual tests in the Gate C
## report each have a fixture that exercises them:
##   A  3.0 m due east          — automatic approach over a short walk
##   B  45 deg off A at 3.4 m   — controller priority between two candidates
##   C  4.2 m due south         — inside the 5.0 m acquisition distance
##   D  behind the F4 barrier   — obstruction, once the barrier is switched on
const FIXTURE_LAYOUT: Array[Dictionary] = [
	{"name": "Practice Post A", "at": Vector3(3.0, 0.0, 0.0)},
	{"name": "Practice Post B", "at": Vector3(2.4, 0.0, 2.4)},
	{"name": "Practice Post C", "at": Vector3(0.0, 0.0, 4.2)},
	{"name": "Practice Post D", "at": Vector3(-5.5, 0.0, -5.5)},
]


## Called by `PrototypeApp` BEFORE the room enters the tree, so `_ready()` builds
## against the app's stores rather than making a second set and swapping later.
func configure_app(
	owner_app: Node,
	settings_store: PrototypeSettings,
	audio_director: PrototypeAudioDirector,
	display_manager: PrototypeDisplayManager,
	tracker: InputFamilyTracker,
	saved: PrototypeLabState
) -> void:
	app = owner_app
	settings = settings_store
	audio = audio_director
	display = display_manager
	external_input_family = tracker
	saved_state = saved


func _ready() -> void:
	room = $NavigationRegion3D/CalibrationRoom
	nav_region = $NavigationRegion3D
	camera_rig = $CameraRig
	marker = $DestinationMarker
	input_family = $InputFamilyTracker
	# One tracker in the shipped flow (specification §7.1: the app owns
	# input-family tracking and glyph selection). Standalone, the room keeps its
	# own and every Gate A-E measurement is untouched.
	if external_input_family != null:
		var own_tracker: InputFamilyTracker = input_family
		input_family = external_input_family
		remove_child(own_tracker)
		own_tracker.queue_free()
	# Standalone defaults. NOT loaded from disk: a suite run must not be steered
	# by whatever the project owner last chose in the settings panel.
	if settings == null:
		settings = PrototypeSettings.new()
	if audio == null:
		audio = PrototypeAudioDirector.new()
		audio.name = "AudioDirector"
		add_child(audio)
	overlay = $CanvasLayer/CalibrationOverlay

	combat_overlay = $CanvasLayer/CombatOverlay
	encounter_overlay = $CanvasLayer/EncounterOverlay
	lab_overlay = $CanvasLayer/LabOverlay
	item_comparison = $CanvasLayer/ItemComparison
	passive_card = $CanvasLayer/PassiveUpgrade
	director = $PrototypeDirector
	starter_sword = load("res://data/prototype_zero/starter_sword.tres") as PrototypeWeaponData
	honed_sword = load("res://data/prototype_zero/honed_sword.tres") as PrototypeWeaponData

	debug_visuals = GateBDebugVisuals.new()
	debug_visuals.name = "DebugVisuals"
	add_child(debug_visuals)

	combat_visuals = GateCDebugVisuals.new()
	combat_visuals.name = "CombatDebugVisuals"
	add_child(combat_visuals)

	# Gate F: the §18 feedback layer. It is presentation only — no timer, phase,
	# or mechanic waits on any of it — so removing it entirely would change no
	# measured value in Gates A-E.
	feedback = PrototypeCombatFeedback.new()
	feedback.name = "CombatFeedback"
	add_child(feedback)

	room.geometry_changed.connect(_on_room_geometry_changed)

	# MEASURED: at the Gate A light angle the 4 m walls threw shadows most of the
	# way across the clear floor and the near corners went almost black, which
	# makes locomotion impossible to judge there. A 62-degree elevation puts the
	# wall shadow at 4 / tan(62 deg) = 2.13 m, inside the one-metre wall footprint
	# plus a little. Lighting, not asset replacement, is also the expected answer
	# to the bright dungeon kit noted in the Gate A report.
	var key_light: DirectionalLight3D = $KeyLight
	key_light.rotation_degrees = Vector3(-62.0, 35.0, 0.0)

	attack_coordinator = AttackCoordinator.new()
	attack_coordinator.name = "AttackCoordinator"
	# D-186: the group handoff is written into the encounter trace, not only shown
	# in a live panel, so a recorded run says when the group owed a window and why.
	attack_coordinator.set_log_sink(Callable(self, "log_encounter"))
	add_child(attack_coordinator)

	_build_gate_f_surfaces()
	_spawn_player()
	_spawn_target_fixtures()
	_configure_navigation()
	bake_navigation()

	acquisition = TargetAcquisition.new(get_world_3d())
	player.attack.setup(
		player, acquisition,
		Callable(self, "resolve_quick_strike_aim"),
		Callable(self, "target_candidates"),
		Callable(self, "log_combat")
	)
	player.attack.use_released.connect(_on_use_released)
	player.attack.use_started.connect(_on_use_started)
	player.took_damage.connect(_on_player_damaged)
	player.fell.connect(_on_player_fell)
	feedback.bind(self)
	feedback.configure(settings, audio, hud)

	# The director is bound BEFORE the verification switch below, so a Gate B,
	# C, or D run can suspend it, and it BEGINS after that switch, so a suspended
	# director still produces the exact Gate D arrangement. Enemies are made
	# after the navigation bake, so their pursuit uses the same mesh the player
	# does, and after the player exists, because they need something to pursue.
	director.bind(self)
	director.saved_state = saved_state
	combat_visuals.bind(self)

	camera_rig.set_target(player)
	input_family.family_changed.connect(_on_family_changed)
	input_family.controller_connection_changed.connect(_on_controller_connection_changed)

	if overlay.has_method("bind_room"):
		overlay.call("bind_room", self)
	if combat_overlay.has_method("bind_room"):
		combat_overlay.call("bind_room", self)
	if encounter_overlay.has_method("bind_room"):
		encounter_overlay.call("bind_room", self)
	lab_overlay.call("bind_room", self)
	item_comparison.bind_room(self)
	passive_card.bind_room(self)
	_capture_locked_targeting()
	hud.bind_room(self)
	pause_menu.bind_room(self)
	fallen_overlay.bind_room(self)
	settings_modal.bind_room(self)
	confirm_modal.bind_room(self)
	director.passive_ready.connect(_on_passive_ready)
	director.progress.milestone_committed.connect(_on_milestone_committed)
	director.progress.experience_changed.connect(_on_experience_changed)
	director.stage_changed.connect(_on_stage_changed_for_save)
	apply_settings("all")
	# The app runs the clean HUD and keeps the four gates of instrumentation
	# behind F3; a standalone suite run keeps the cards, so its evidence
	# screenshots and its on-screen text checks are unchanged.
	if app != null:
		set_instrumentation_visible(false)

	log_event("room ready", "clear floor %.1f x %.1f m, 1 unit = 1 m (D-175)" % [
		room.clear_extent().x, room.clear_extent().y,
	])
	log_combat("quick strike ready", player.attack.data.describe())

	# The navigation map is not QUERYABLE until the server has synchronized it at
	# least once, and Gate E asks it a real question before it places its first
	# wave: `measure_spawn_plan()` checks every candidate point against the mesh.
	# One physics frame is the honest wait. Measuring against an unsynchronized
	# map would answer "not walkable" for every point in the room and quietly
	# push the first spawn onto the fallback path.
	await _await_navigation_synchronized()

	var arguments: PackedStringArray = OS.get_cmdline_user_args()
	var verification: String = ""
	if arguments.has("--verify"):
		verification = "res://scripts/tools/gate_b_verification.gd"
	elif arguments.has("--verify-c"):
		verification = "res://scripts/tools/gate_c_verification.gd"
	elif arguments.has("--verify-d"):
		verification = "res://scripts/tools/gate_d_verification.gd"
	elif arguments.has("--verify-e"):
		verification = "res://scripts/tools/gate_e_verification.gd"

	# Gate B, C, and D each measure their own gate in isolation, so the Gate E
	# progression director is SUSPENDED for those three runs and produces the
	# exact arrangement Gate D was accepted in: one Graveblade at the authored
	# marker, no rewards, no waves, no corpse removal. It is the same reasoning
	# that already removes the Graveblade entirely for Gate B and Gate C — a live
	# director spawning waves would change what they measure.
	if verification != "" and not arguments.has("--verify-e"):
		director.set_active(false)
	director.begin()
	lab_begun = true

	if verification != "":
		var node_name: String = {
			"res://scripts/tools/gate_b_verification.gd": "GateBVerification",
			"res://scripts/tools/gate_c_verification.gd": "GateCVerification",
			"res://scripts/tools/gate_d_verification.gd": "GateDVerification",
			"res://scripts/tools/gate_e_verification.gd": "GateEVerification",
		}[verification]
		_start_verification(verification, node_name, arguments)


## Gate F's own surfaces, built in code and added to the SAME CanvasLayer the
## Gate E modals use, after them, so a pause or a Fallen draws over every
## instrumentation card and over the comparison if one were somehow open.
func _build_gate_f_surfaces() -> void:
	var layer: CanvasLayer = $CanvasLayer
	hud = PrototypeHUD.new()
	hud.name = "PrototypeHUD"
	# BEFORE the Gate E modals in draw order: the HUD is world furniture and a
	# modal must cover it.
	layer.add_child(hud)
	layer.move_child(hud, 0)

	pause_menu = PrototypePauseMenu.new()
	pause_menu.name = "PauseMenu"
	layer.add_child(pause_menu)
	settings_modal = PrototypeSettingsModal.new()
	settings_modal.name = "SettingsModal"
	layer.add_child(settings_modal)
	confirm_modal = PrototypeConfirmModal.new()
	confirm_modal.name = "ConfirmModal"
	layer.add_child(confirm_modal)
	fallen_overlay = PrototypeFallenOverlay.new()
	fallen_overlay.name = "FallenOverlay"
	layer.add_child(fallen_overlay)


## Shows or hides the Gate B, C, D, and E instrumentation cards together. The
## Gate E ground NAMEPLATE is deliberately not part of this: it is the surface
## the mouse clicks to open the comparison, and hiding it would remove a
## player-facing interaction rather than a debug one.
func set_instrumentation_visible(value: bool) -> void:
	instrumentation_visible = value
	for card: Node in [overlay, combat_overlay, encounter_overlay]:
		if card is CanvasItem:
			(card as CanvasItem).visible = value
	if lab_overlay.has_method("set_card_visible"):
		lab_overlay.call("set_card_visible", value)


## Gate B measures locomotion in an empty room and Gate C measures the Quick
## Strike kernel against inert posts. A live Graveblade chasing the character
## would change both, so those two suites run without it and say so. The Gate D
## and Gate E suites each assert their own arrangement is present.
func _start_verification(script_path: String, node_name: String, arguments: PackedStringArray) -> void:
	_verifying = true
	if node_name == "GateBVerification" or node_name == "GateCVerification":
		clear_all_graveblades("%s measures its own gate in isolation" % node_name)
	var verifier: Node = (load(script_path) as GDScript).new()
	verifier.name = node_name
	add_child(verifier)
	verifier.call("run", self, arguments)


func _spawn_player() -> void:
	player = (load(PLAYER_SCENE) as PackedScene).instantiate() as PrototypePlayer
	var spawn: Marker3D = $Actors/PlayerSpawn
	player.position = spawn.position
	$Actors.add_child(player)
	_default_max_speed = player.max_speed
	player.movement_command_resolved.connect(_on_movement_command_resolved)
	player.arrived_at_destination.connect(_on_arrived)
	player.movement_intent_cleared.connect(_on_intent_cleared)


## Gate C target fixtures. Inert practice posts, on the "target" layer only:
## they neither collide with the player nor enter the navigation bake, so their
## presence cannot change a Gate B locomotion result.
func _spawn_target_fixtures() -> void:
	var scene: PackedScene = load(FIXTURE_SCENE) as PackedScene
	var parent: Node3D = $Targets
	for entry: Dictionary in FIXTURE_LAYOUT:
		var fixture: PrototypeTargetFixture = scene.instantiate() as PrototypeTargetFixture
		fixture.name = String(entry["name"]).replace(" ", "")
		fixture.fixture_name = entry["name"]
		fixture.position = entry["at"]
		parent.add_child(fixture)
		fixtures.append(fixture)
	log_combat("target fixtures", "%d inert practice posts placed; they are not Graveblades" % fixtures.size())


# --- Gate D and Gate E: the Graveblade roster --------------------------------

## The room HOLDS the roster; the progression director decides what goes into it.
## Splitting it that way is what lets the Gate B, C, and D suites keep their
## meaning: they suspend the director and the room's own mechanics — targeting,
## damage, the coordinator, the trace — are untouched by that.
func register_graveblade(enemy: PrototypeGraveblade) -> void:
	graveblades_spawned += 1
	$Actors.add_child(enemy)
	graveblades.append(enemy)
	enemy.setup(player, attack_coordinator, acquisition, Callable(self, "log_encounter"))
	enemy.took_damage.connect(_on_graveblade_damaged.bind(enemy))
	enemy.died.connect(_on_graveblade_died.bind(enemy))
	enemy.attack_committed.connect(_on_graveblade_committed)
	enemy.attack_released.connect(_on_graveblade_released.bind(enemy))
	log_encounter("graveblade spawned", "%s at (%.1f, %.1f), %.2f m from the player; %d in the room" % [
		enemy.name, enemy.position.x, enemy.position.z,
		Vector2(enemy.position.x - player.global_position.x, enemy.position.z - player.global_position.z).length(),
		graveblades.size(),
	])


func remove_graveblade(enemy: PrototypeGraveblade, reason: String) -> void:
	if enemy == null or not is_instance_valid(enemy):
		graveblades.erase(enemy)
		return
	# ADMINISTRATIVE: removing a body is not an attack ending, so D-186's group
	# window is not started by the corpse cleanup between waves.
	attack_coordinator.release(enemy, AttackCoordinator.ReleaseCause.ADMINISTRATIVE, "removed")
	graveblades.erase(enemy)
	$Actors.remove_child(enemy)
	enemy.queue_free()
	log_encounter("graveblade removed", "%s — %s" % [enemy.name, reason])


func clear_all_graveblades(reason: String) -> void:
	attack_coordinator.revoke_all("graveblades removed")
	for enemy: PrototypeGraveblade in graveblades.duplicate():
		if is_instance_valid(enemy):
			$Actors.remove_child(enemy)
			enemy.queue_free()
	graveblades.clear()
	log_encounter("graveblades cleared", reason)


## Preserved name for the Gate B and Gate C removal path.
func despawn_graveblade(reason: String) -> void:
	clear_all_graveblades(reason)


func living_graveblade_count() -> int:
	var total: int = 0
	for enemy: PrototypeGraveblade in graveblades:
		if is_instance_valid(enemy) and enemy.is_alive():
			total += 1
	return total


## The Graveblade's locked maximum Life, read from its own record so the item
## comparison's "Hits to this Graveblade" line can never be a literal. Falls back
## to the record on disk when the roster is momentarily empty — between a kill
## and the next wave, the comparison still has an enemy to compare against.
func graveblade_max_life() -> float:
	for enemy: PrototypeGraveblade in graveblades:
		if is_instance_valid(enemy) and enemy.data != null:
			return enemy.data.max_life
	return _graveblade_record().max_life


## The Graveblade's locked pursuit values, read the same way, so the Gate E
## spawn-safety measurement can state how long a spawned enemy needs to close.
func graveblade_move_speed() -> float:
	for enemy: PrototypeGraveblade in graveblades:
		if is_instance_valid(enemy) and enemy.data != null:
			return enemy.data.move_speed
	return _graveblade_record().move_speed


func graveblade_preferred_distance() -> float:
	for enemy: PrototypeGraveblade in graveblades:
		if is_instance_valid(enemy) and enemy.data != null:
			return enemy.data.preferred_attack_distance
	return _graveblade_record().preferred_attack_distance


func _graveblade_record() -> GravebladeData:
	return load("res://data/prototype_zero/graveblade.tres") as GravebladeData


## Debug only, and clearly labelled as such. Gate D owns MECHANICAL death; the
## trusted Restart flow, the Fallen overlay, pause, settings, and the test-state
## save are Gate F. Gate E made it a CURRENT-STAGE reset that RETAINS every
## completed milestone (D-184); `reset_lab_progress()` is the separate, clearly
## labelled door that deliberately clears the sequence.
func reset_encounter() -> void:
	cancel_fallen("encounter reset")
	director.reset_current_stage()
	restore_after_fall()


func reset_lab_progress() -> void:
	cancel_fallen("lab progress reset")
	director.reset_lab_progress()
	restore_after_fall()


## Closes the Fallen surface and drops the pending one. Every path that brings
## the player back — Restart, the debug stage reset, Reset Lab Progress — goes
## through here, because a Fallen overlay left standing keeps `get_tree().paused`
## true and the room would never tick again.
func cancel_fallen(reason: String) -> void:
	_fallen_countdown = -1.0
	_fallen_event = null
	if fallen_overlay != null and fallen_overlay.is_open:
		fallen_overlay.close(reason)


## Undoes §20.1's combat pause. Only enemies the FALL suspended are restored, so
## an enemy a check deliberately parked stays parked.
func restore_after_fall() -> void:
	if not _decisions_suspended_by_fall:
		return
	_decisions_suspended_by_fall = false
	for enemy: PrototypeGraveblade in graveblades:
		if is_instance_valid(enemy):
			enemy.set_ai_enabled(true)
	log_gate_f("combat resumed", "the Graveblades suspended by the fall are active again")


# --- Ordered combat trace ----------------------------------------------------

## Every Hit, kill, and fall, in the order they happened. Gate D has to prove
## ordering — Hit before kill, exactly one kill, no duplicates — and a recorded
## sequence is the only honest way to show it.
func _record(kind: String, detail: String, event: DamageEvent) -> void:
	combat_events.append({
		"kind": kind,
		"at_msec": Time.get_ticks_msec(),
		"use_id": event.use_id if event != null else 0,
		"source": event.source_name() if event != null else "",
		"target": event.target_name() if event != null else "",
		"damage": event.final_life_damage if event != null else 0.0,
		"detail": detail,
	})
	if combat_events.size() > 64:
		combat_events.remove_at(0)


func combat_event_kinds() -> PackedStringArray:
	var kinds: PackedStringArray = PackedStringArray()
	for entry: Dictionary in combat_events:
		kinds.append(String(entry["kind"]))
	return kinds


func _on_graveblade_damaged(event: DamageEvent, enemy: PrototypeGraveblade) -> void:
	_record("hit", "%s Life %.0f of %.0f" % [enemy.name, enemy.life, enemy.data.max_life], event)
	# Specification §18: every synchronized channel fires from ONE call on the
	# SAME frame the Life changed, so they cannot drift apart.
	#
	# DEFERRED, and that is the point rather than an optimisation. `took_damage`
	# is emitted from inside the Graveblade's own mechanical sequence, three
	# lines before it decides whether it died and four before it starts its death
	# clip. Building meshes and starting voices INSIDE that call stack pushed the
	# enemy's own decoration measurably later — Gate D asserts the death
	# animation begins within 1 ms of the kill event, and it caught exactly that.
	# A deferred call still flushes inside THIS frame, so the feedback is not one
	# frame late; it is simply no longer part of a mechanical sequence, which is
	# where presentation never belonged.
	var improved: bool = player.weapon == honed_sword
	var direction: Vector3 = _planar(enemy.global_position - player.global_position)
	feedback.call_deferred("show_player_hit", enemy.global_position, direction, enemy, improved)
	feedback.call_deferred(
		"request_damage_number", enemy.global_position + Vector3(0.0, 1.85, 0.0),
		event.final_life_damage, "improved" if improved else "ordinary"
	)
	hud.note_target(enemy)


## The room RECORDS the kill. The director decides whether it is worth anything,
## and refuses to pay twice — the two are separate on purpose, so the ordered
## trace Gate D proves stays a fact about the fight rather than about progression.
func _on_graveblade_died(event: DamageEvent, enemy: PrototypeGraveblade) -> void:
	_record("kill", "%s defeated" % enemy.name, event)
	feedback.call_deferred(
		"show_kill", enemy.global_position,
		_planar(enemy.global_position - player.global_position)
	)
	log_encounter("kill event", "use %d killed %s; %d still alive" % [
		event.use_id, enemy.name, living_graveblade_count(),
	])


func _on_player_damaged(event: DamageEvent) -> void:
	_record("player hit", "player Life %.0f of %.0f" % [player.life, player.max_life], event)
	var attacker: Node3D = event.source as Node3D
	feedback.call_deferred(
		"show_player_damaged", player.global_position,
		attacker.global_position if attacker != null else player.global_position,
		player
	)
	feedback.call_deferred(
		"request_damage_number", player.global_position + Vector3(0.0, 2.05, 0.0),
		event.final_life_damage, "player"
	)
	log_encounter("player damaged", "%s; Life %.0f of %.0f" % [
		event.describe(), player.life, player.max_life,
	])


## Specification §20.1: player death revokes enemy attack permission at once.
func _on_player_fell(event: DamageEvent) -> void:
	_record("player fallen", "killed by %s" % event.source_name(), event)
	falls += 1
	attack_coordinator.revoke_all("player fallen")
	last_killing_source = PrototypeFallenOverlay.describe_killing_source(event)
	log_encounter("FALLEN", last_killing_source)

	# Specification §20.1, and all of it on THIS frame rather than when the
	# overlay appears. Movement, navigation, the attack, its buffer, its held
	# repeat, the target, and damage eligibility are already off inside
	# `PrototypePlayer._fall()`. What is left is the rest of the room:
	#
	#   * enemy attack permission, revoked above;
	#   * every Graveblade's DECISION states, so nothing chases, closes, or asks
	#     for permission while the collapse plays. An attack already in flight
	#     still runs its own timeline and resolves as a miss, because a dead
	#     player is not an engageable target;
	#   * held mouse and stick intent in the room itself;
	#   * any rumble, trail, flash, or camera impulse still running.
	_mouse_hold_active = false
	_mouse_hold_suspended = false
	_decisions_suspended_by_fall = true
	for enemy: PrototypeGraveblade in graveblades:
		if is_instance_valid(enemy):
			enemy.set_ai_enabled(false)
	feedback.stop_all()
	feedback.show_fallen()
	marker.hide_destination()

	# §20.1: "play the death response" and only THEN "fade in Fallen". The
	# overlay is delayed by a little more than the 0.80 s `Death_A` clip, so the
	# collapse is seen rather than covered.
	_fallen_event = event
	_fallen_countdown = FALLEN_DELAY
	log_gate_f("fallen", "%s; Fallen fades in after the %.2f s death response" % [
		last_killing_source, FALLEN_DELAY,
	])


func _on_graveblade_committed(direction: Vector3) -> void:
	combat_visuals.show_enemy_commitment(direction)


func _on_graveblade_released(outcome: Dictionary, enemy: PrototypeGraveblade) -> void:
	if enemy == null or not is_instance_valid(enemy):
		return
	feedback.show_graveblade_release(enemy.global_position, enemy.release_direction)
	# Recorded per attacker, so the §14.3 gap between DIFFERENT attackers'
	# release starts is measurable rather than assumed once a wave has three.
	#
	# D-186 added the simulation stamp beside the wall-clock one. The cadence this
	# records is a property of the simulation, and only the simulation stamp stops
	# counting when a modal pauses the world — so a paused fight cannot appear in
	# the trace as a slower one.
	enemy_release_starts.append({
		"enemy": enemy.name,
		"at_msec": Time.get_ticks_msec(),
		"at_sim": attack_coordinator.simulation_time(),
	})
	if enemy_release_starts.size() > 32:
		enemy_release_starts.remove_at(0)
	combat_visuals.show_enemy_release(
		enemy.global_position, enemy.release_direction,
		enemy.data.attack_reach, enemy.data.attack_arc_degrees,
		String(outcome["outcome"]) == "hit"
	)


## Adds a fixture the scene did not author. Used only by the Gate C verification
## for the geometric cases a fixed layout cannot express, such as a target with a
## wall between it and the player.
func add_probe_fixture(fixture_name: String, at: Vector3) -> PrototypeTargetFixture:
	var fixture: PrototypeTargetFixture = (load(FIXTURE_SCENE) as PackedScene).instantiate() as PrototypeTargetFixture
	fixture.name = "Probe_%s" % fixture_name.replace(" ", "")
	fixture.fixture_name = fixture_name
	fixture.position = at
	$Targets.add_child(fixture)
	fixtures.append(fixture)
	return fixture


func remove_probe_fixture(fixture: PrototypeTargetFixture) -> void:
	fixtures.erase(fixture)
	if soft_target == fixture:
		soft_target = null
		soft_target_since_msec = 0
	$Targets.remove_child(fixture)
	fixture.queue_free()


func reset_target_fixtures() -> void:
	for fixture: PrototypeTargetFixture in fixtures:
		fixture.reset()
	soft_target = null
	log_combat("fixtures reset", "%d posts restored, hit counts cleared, drift off" % fixtures.size())


# --- Navigation --------------------------------------------------------------

func _configure_navigation() -> void:
	var mesh: NavigationMesh = NavigationMesh.new()
	# Bake from the room's own collision boxes, not from the decorative kit
	# meshes, so the walkable surface can never disagree with what the character
	# actually collides against.
	mesh.geometry_parsed_geometry_type = NavigationMesh.PARSED_GEOMETRY_STATIC_COLLIDERS
	mesh.geometry_collision_mask = WORLD_MASK
	mesh.geometry_source_geometry_mode = NavigationMesh.SOURCE_GEOMETRY_ROOT_NODE_CHILDREN
	mesh.cell_size = nav_cell_size
	mesh.cell_height = nav_cell_size
	mesh.agent_radius = agent_radius
	mesh.agent_height = agent_height
	mesh.agent_max_climb = agent_max_climb
	mesh.agent_max_slope = agent_max_slope
	# The walls are 4 m boxes standing ON the floor collider, so their flat tops
	# are legitimate walkable surfaces as far as the baker is concerned. Bounding
	# the bake to the walking layer keeps the wall bodies obstructing while their
	# tops never become navigable ledges beyond the clear floor.
	var full: Vector2 = room.floor_extent()
	mesh.filter_baking_aabb = AABB(
		Vector3(-full.x * 0.5 - 2.0, -1.0, -full.y * 0.5 - 2.0),
		Vector3(full.x + 4.0, 1.0 + agent_height + 0.4, full.y + 4.0)
	)
	nav_region.navigation_mesh = mesh


func bake_navigation() -> void:
	var started: int = Time.get_ticks_msec()
	nav_region.bake_navigation_mesh(false)
	# A freshly baked map is not queryable until the navigation server has
	# synchronized it, and Gate E asks it a question on the very first frame:
	# `measure_spawn_plan()` checks every candidate spawn point against the mesh
	# before a wave is placed. Forcing the update here means that question is
	# answered by the mesh rather than by a failed query returning the origin.
	if NavigationServer3D.map_get_iteration_id(navigation_map()) > 0:
		NavigationServer3D.map_force_update(navigation_map())
	last_bake_msec = Time.get_ticks_msec() - started
	_measure_navmesh()
	if debug_visuals != null:
		debug_visuals.show_navigation_mesh(nav_region.navigation_mesh)
	log_event("navigation baked", "%d polygons, %.1f m^2 walkable, %d ms" % [
		navmesh_polygon_count, navmesh_area, last_bake_msec,
	])


func _measure_navmesh() -> void:
	var mesh: NavigationMesh = nav_region.navigation_mesh
	navmesh_polygon_count = mesh.get_polygon_count()
	var vertices: PackedVector3Array = mesh.get_vertices()
	var area: float = 0.0
	for i: int in navmesh_polygon_count:
		var indices: PackedInt32Array = mesh.get_polygon(i)
		for t: int in range(1, indices.size() - 1):
			var a: Vector3 = vertices[indices[0]]
			var b: Vector3 = vertices[indices[t]]
			var c: Vector3 = vertices[indices[t + 1]]
			area += absf((b.x - a.x) * (c.z - a.z) - (c.x - a.x) * (b.z - a.z)) * 0.5
	navmesh_area = area


func navigation_map() -> RID:
	return get_world_3d().navigation_map


## The navigation map is not QUERYABLE until the server has synchronized it at
## least once, and Gate E asks it a real question before it places its first
## wave: `measure_spawn_plan()` checks every candidate spawn point against the
## mesh. Waiting for the iteration id to advance is the honest wait — measuring
## against an unsynchronized map answers "not walkable" for every point in the
## room and would quietly push the first spawn onto the fallback path.
##
## Bounded, so a map that never synchronizes fails visibly rather than hanging.
func _await_navigation_synchronized() -> void:
	# The readiness test is a real query with a known answer rather than a
	# counter or an iteration id: a point well inside the clear floor must come
	# back as itself. An unsynchronized map answers the origin for everything,
	# which is exactly the failure this exists to catch.
	var probe: Vector3 = Vector3(3.0, 0.0, 2.0)
	for frame: int in 30:
		# The iteration guard is only there to keep the server from printing its
		# own "queried before first synchronization" error on the first frames.
		if NavigationServer3D.map_get_iteration_id(navigation_map()) == 0:
			await get_tree().physics_frame
			continue
		var answer: Vector3 = NavigationServer3D.map_get_closest_point(navigation_map(), probe)
		if Vector2(answer.x - probe.x, answer.z - probe.z).length() < 0.25:
			log_event("navigation ready", "map answers queries after %d physics frame%s" % [
				frame, "" if frame == 1 else "s",
			])
			return
		await get_tree().physics_frame
	push_warning("PrototypeZeroRoom: the navigation map did not become queryable within 30 physics frames")


func _on_room_geometry_changed() -> void:
	bake_navigation()


# --- Input -------------------------------------------------------------------

func _input(event: InputEvent) -> void:
	# When the app owns the tracker it feeds it from its own `_input`, and every
	# event reaches BOTH. Observing twice would halve the mouse-motion threshold
	# the tracker uses to decide a deliberate pointer move, so the room steps
	# aside rather than double-counting.
	if external_input_family == null:
		input_family.observe(event)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"move_point"):
		# A fresh press is always a new intent (specification §9.5).
		if _pointer_over_ui():
			ui_clicks_absorbed += 1
			log_event("movement command rejected", "pointer over interface, no world command issued")
			return
		_mouse_hold.press()
		_issue_move_command()
		return
	if event.is_action_released(&"move_point"):
		_mouse_hold_active = false
		_mouse_hold_suspended = false
		return
	if event.is_action_pressed(&"quick_strike"):
		if _pointer_over_ui():
			ui_clicks_absorbed += 1
			log_combat("quick strike rejected", "pointer over interface, no attack issued")
			return
		press_quick_strike()
		return
	if event.is_action_released(&"quick_strike"):
		player.attack.release_input()
		return
	# Gate E: the controller's clear interaction with the ground drop
	# (specification §9.1 `interact`, §16.1). The mouse uses the nameplate button
	# instead, which is a real UI control and therefore already absorbed before
	# it can leak a ground command into the world.
	if event.is_action_pressed(&"interact"):
		_try_interact_with_drop()
		return
	# Gate F. `pause` is Escape and the controller menu button (specification
	# §9.1). An open modal consumes `ui_cancel` in `_input` before this ever
	# runs, so Escape closes the surface it is looking at rather than stacking a
	# pause behind it.
	if event.is_action_pressed(&"pause"):
		if not any_modal_is_open() and player.is_alive():
			open_pause("pause pressed")
		return
	# §9.1 and §17: F2 switches damage numbers, immediately, without a menu.
	if event.is_action_pressed(&"toggle_damage_numbers"):
		toggle_damage_numbers()
		return
	_handle_calibration_input(event)


## One entry point for a Quick Strike press, so the verification exercises the
## same path a real button does.
func press_quick_strike() -> void:
	if player.awaiting_neutral:
		log_combat("quick strike rejected", "awaiting neutral input after an interruption")
		return
	# Specification §9.5: the attack is now the newest intent, so an older HELD
	# movement control is suspended rather than left free to cancel the wind-up
	# on the next frame.
	player.suspend_held_movement_for_attack()
	if _mouse_hold_active or Input.is_action_pressed(&"move_point"):
		_mouse_hold_suspended = true
	_mouse_hold_active = false
	player.attack.press()


# --- Gate E: the ground drop, the two modal surfaces, and their contract -----

## The controller path. Specification §7.5 gives the drop an interaction range;
## the cursor may click its nameplate from anywhere, because a cursor already IS
## a reach.
func _try_interact_with_drop() -> void:
	var drop: PrototypeSwordDrop = director.drop()
	if drop == null:
		return
	if any_modal_is_open():
		return
	if not drop.player_is_in_range(player.global_position):
		log_progression("interact refused", "%.2f m from %s; its interaction range is %.2f m" % [
			drop.planar_distance_to(player.global_position), drop.display_name(),
			drop.measured_interaction_range(),
		])
		director.note_cue("invalid_action")
		return
	open_item_comparison("interact pressed at %.2f m" % drop.planar_distance_to(player.global_position))


## One entry point, so the mouse click on the nameplate and the controller's
## interact button take exactly the same path.
func open_item_comparison(reason: String) -> void:
	var drop: PrototypeSwordDrop = director.drop()
	if drop == null or any_modal_is_open():
		return
	log_progression("comparison opened", "%s — %s against %s" % [
		reason, drop.display_name(), player.weapon.display_name,
	])
	item_comparison.open_for(drop)


func _on_passive_ready() -> void:
	log_progression("passive prompt", "%d / %d XP reached; %s is ready" % [
		director.progress.experience, director.data.experience_maximum, director.data.passive_name,
	])
	passive_card.open()


## Every surface that holds the paused world. Gate F's four join Gate E's two,
## and the room asks this one question rather than four.
func any_modal_is_open() -> bool:
	return (
		item_comparison.is_open or passive_card.is_open
		or pause_menu.is_open or fallen_overlay.is_open
		or settings_modal.is_open or confirm_modal.is_open
	)


## Called by a modal when it opens. It neutralizes held movement AND combat
## intent through the same path focus loss and controller disconnect already use,
## so there is one rule rather than a second one written for menus
## (specification §9.2, §16.1).
func neutralize_for_modal(reason: String) -> void:
	_mouse_hold_active = false
	_mouse_hold_suspended = false
	player.clear_movement_intent(reason, true)
	marker.hide_destination()
	# Gate F: a rumble, a trail, a material flash, or a camera impulse must not
	# survive the boundary either. §9.2 says held intent is cleared at the
	# boundary; a controller still buzzing on a paused screen is the same bug
	# wearing a different coat.
	if feedback != null:
		feedback.stop_all()
	pauses += 1
	log_progression("simulation paused", "%s; held movement and combat intent cleared" % reason)


## Called by a modal when it closes. The neutral latch set on open is left
## STANDING: the room's existing `_update_neutral_latch()` releases it only once
## every physical control reads neutral, which is exactly the specification §16.1
## requirement that closing "requires neutral input before movement resumes".
func restore_after_modal(reason: String) -> void:
	_mouse_hold_active = false
	_mouse_hold_suspended = false
	player.clear_movement_intent(reason, true)
	if feedback != null:
		feedback.stop_all()
	resumes += 1
	log_progression("simulation resumed", "%s; awaiting neutral input before play continues" % reason)


func _handle_calibration_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"toggle_debug_overlay"):
		# Gate F: F3 now reveals the four gates of instrumentation as well as
		# their detail panels, because §22's overlay "is not player-facing final
		# UI" and the §17 HUD is what the player sees by default.
		set_instrumentation_visible(not instrumentation_visible)
		if overlay.has_method("toggle_debug"):
			overlay.call("toggle_debug")
		if combat_overlay.has_method("toggle_detail"):
			combat_overlay.call("toggle_detail")
		if encounter_overlay.has_method("toggle_detail"):
			encounter_overlay.call("toggle_detail")
		lab_overlay.call("toggle_detail")
		set_debug_visuals(not debug_visuals.visible)
	elif event.is_action_pressed(&"toggle_barrier"):
		room.set_barrier_enabled(not room.barrier_enabled)
		log_event("barrier toggled", "enabled=%s, navigation rebaked" % str(room.barrier_enabled))
	elif event.is_action_pressed(&"toggle_calibration_grid"):
		room.set_grid_visible(not room.grid_visible)
		log_event("calibration grid", "visible=%s" % str(room.grid_visible))
	elif event.is_action_pressed(&"calibrate_camera_closer"):
		camera_rig.adjust_distance(-camera_distance_step)
		_log_camera()
	elif event.is_action_pressed(&"calibrate_camera_farther"):
		camera_rig.adjust_distance(camera_distance_step)
		_log_camera()
	elif event.is_action_pressed(&"calibrate_pitch_down"):
		camera_rig.adjust_pitch(-camera_angle_step)
		_log_camera()
	elif event.is_action_pressed(&"calibrate_pitch_up"):
		camera_rig.adjust_pitch(camera_angle_step)
		_log_camera()
	elif event.is_action_pressed(&"calibrate_fov_down"):
		camera_rig.adjust_fov(-camera_angle_step)
		_log_camera()
	elif event.is_action_pressed(&"calibrate_fov_up"):
		camera_rig.adjust_fov(camera_angle_step)
		_log_camera()
	elif event.is_action_pressed(&"calibrate_speed_down"):
		_adjust_speed(-speed_step)
	elif event.is_action_pressed(&"calibrate_speed_up"):
		_adjust_speed(speed_step)
	elif event.is_action_pressed(&"reset_target_fixtures"):
		reset_target_fixtures()
	elif event.is_action_pressed(&"toggle_slow_motion"):
		set_slow_motion(not slow_motion)
	elif event.is_action_pressed(&"toggle_fixture_drift"):
		_toggle_fixture_drift()
	elif event.is_action_pressed(&"toggle_fixture_present"):
		_toggle_fixture_present()
	elif event.is_action_pressed(&"reset_encounter"):
		reset_encounter()
	elif event.is_action_pressed(&"reset_lab_progress"):
		reset_lab_progress()
	elif event.is_action_pressed(&"calibrate_reset"):
		camera_rig.reset_calibration()
		player.max_speed = _default_max_speed
		log_event("calibration reset", "camera and movement speed back to the D-175 approved defaults")


## Specification §22 permits "slow motion for release-marker inspection". This is
## the control that lets the visible contact pose be checked against the release
## query by eye rather than only in the log.
func set_slow_motion(enabled: bool) -> void:
	slow_motion = enabled
	Engine.time_scale = 0.25 if enabled else 1.0
	log_combat("slow motion", "%s (time scale %.2f) for release-marker inspection" % [
		"on" if enabled else "off", Engine.time_scale,
	])


## Debug only. Exercises the §11.1 rule that an approach re-evaluates range
## against the target's CURRENT position. It is a scripted sway on a prop; the
## fixture still has no AI, no attack, and no Life.
func _toggle_fixture_drift() -> void:
	var wanted: bool = true
	for fixture: PrototypeTargetFixture in fixtures:
		if fixture.drift_enabled:
			wanted = false
			break
	for fixture: PrototypeTargetFixture in fixtures:
		fixture.drift_enabled = wanted
	log_combat("fixture drift", "%s — debug sway only, not enemy movement" % ("on" if wanted else "off"))


## Debug only. Switching a post off makes it an invalid target, which is how the
## "target became invalid" rule is exercised without giving a fixture death.
##
## Debug only, and posts only: F10 has never been able to remove the Graveblade,
## which has real Life and real death instead.
func _toggle_fixture_present() -> void:
	var chosen: PrototypeTargetFixture = soft_target as PrototypeTargetFixture
	if chosen == null:
		chosen = _nearest_fixture(true)
	if chosen == null:
		chosen = _nearest_fixture(false)
	if chosen == null:
		return
	chosen.set_active(not chosen.active)
	if soft_target == chosen and not chosen.active:
		soft_target = null
	log_combat("fixture presence", "%s is now %s" % [
		chosen.fixture_name, "present" if chosen.active else "absent (an invalid target)",
	])


func _nearest_fixture(only_active: bool) -> PrototypeTargetFixture:
	var best: PrototypeTargetFixture = null
	var best_distance: float = INF
	for fixture: PrototypeTargetFixture in fixtures:
		if only_active and not fixture.is_valid_target():
			continue
		var distance: float = fixture.global_position.distance_to(player.global_position)
		if distance < best_distance:
			best_distance = distance
			best = fixture
	return best


func _adjust_speed(delta_speed: float) -> void:
	player.max_speed = clampf(player.max_speed + delta_speed, 1.0, 12.0)
	log_event("calibration", "maximum speed %.1f m/s" % player.max_speed)


func _log_camera() -> void:
	log_event("calibration", "camera distance %.1f m, pitch %.1f deg, fov %.1f deg" % [
		camera_rig.distance_metres, camera_rig.pitch_degrees, camera_rig.fov_degrees,
	])


## True when the pointer is over an interface element that should absorb it.
## Specification §9.3: "Clicking UI never leaks a ground command into the world."
func _pointer_over_ui() -> bool:
	return get_viewport().gui_get_hovered_control() != null


func _process(delta: float) -> void:
	if player == null:
		return
	player.set_ground_basis(camera_rig.ground_forward(), camera_rig.ground_right())

	if _mouse_hold.should_reissue(delta, Input.is_action_pressed(&"move_point")):
		if _pointer_over_ui():
			ui_clicks_absorbed += 1
		else:
			_issue_move_command()

	_tick_fallen_delay(delta)
	_update_neutral_latch()
	_refresh_idle_soft_target()

	if debug_visuals.visible:
		debug_visuals.show_path(player.current_path())
	combat_visuals.refresh()


## §20.1: the death response plays first, then Fallen fades in. The countdown
## runs in `_process`, which is not running while a modal holds the world — and
## nothing can hold it here, because a fallen player has no surface open yet.
func _tick_fallen_delay(delta: float) -> void:
	if _fallen_countdown < 0.0:
		return
	# A Restart or a reset during the death response cancels the surface that was
	# about to appear. Without this, reviving inside the 0.90 s window produces a
	# Fallen overlay over a living character.
	if player.is_alive():
		_fallen_countdown = -1.0
		_fallen_event = null
		return
	_fallen_countdown -= delta
	if _fallen_countdown > 0.0:
		return
	_fallen_countdown = -1.0
	if fallen_overlay.is_open:
		return
	fallen_overlay.open_for(_fallen_event)
	log_gate_f("fallen overlay", "%s; neutral focus is Review Death" % last_killing_source)


# --- Gate F: pause, settings, restart, and the app boundary ------------------

func open_pause(reason: String) -> void:
	if any_modal_is_open() or not player.is_alive():
		return
	note_menu_cue("menu_open")
	pause_menu.open()
	log_gate_f("paused", reason)


func open_settings(reason: String) -> void:
	if settings_modal.is_open:
		return
	settings_modal.open()
	log_gate_f("settings opened", reason)


## §21 General: Reset Lab Progress behind a deliberate confirmation. The
## confirmation names what it destroys AND what it does not, because the two
## files existing separately is the whole point.
func confirm_reset_lab_progress(reason: String) -> void:
	confirm_modal.ask(
		"Reset Lab Progress?",
		"This clears the laboratory sequence and begins the complete path again: %s.\n\n"
		% director.progress.describe()
		+ "The saved lab file is removed. Your settings live in a separate file and are NOT affected.",
		"Reset Lab Progress",
		Callable(self, "_perform_reset_lab_progress")
	)
	log_gate_f("reset confirmation", reason)


func _perform_reset_lab_progress() -> void:
	reset_lab_progress()
	if app != null:
		app.call("reset_lab_progress_in_play")
	log_gate_f("lab progress reset", "the sequence was cleared; settings were not touched")


## §20.2: "Restart reloads the current combat stage." Full Life and Mana, the
## current wave rebuilt at full Life at valid spawns, saved milestones retained,
## no reward duplicated, and the same neutral-input protection every other
## boundary uses.
func restart_current_fight(reason: String) -> void:
	restarts += 1
	feedback.stop_all()
	hud.clear_damage_numbers()
	_mouse_hold_active = false
	_mouse_hold_suspended = false
	_fallen_countdown = -1.0
	_fallen_event = null
	cancel_fallen("restarted")
	marker.hide_destination()
	director.restart_current_fight()
	restore_after_fall()
	# The latch the reset armed is left STANDING: `_update_neutral_latch()`
	# releases it only once every physical control reads neutral, which is
	# §20.2's "return through neutral-input protection" and the reason a button
	# held through death cannot act on the rebuilt fight.
	note_menu_cue("menu_confirm")
	log_gate_f("restart", "%s — %s; milestones retained (%s)" % [
		reason, director.progress.stage_name(), director.progress.describe(),
	])


func quit_to_title(reason: String) -> void:
	feedback.stop_all()
	if app == null:
		log_gate_f("quit to title refused", "the room is running standalone; there is no title")
		return
	app.call("quit_to_title", reason)


func apply_display_change(
	mode: PrototypeSettings.WindowMode, resolution_index: int
) -> void:
	if display == null:
		return
	display.request_change(mode, resolution_index)


## §17: damage numbers are "default On but immediately switchable Off". F2 and
## the settings panel reach the SAME store, so the two can never disagree.
func toggle_damage_numbers() -> void:
	settings.set_damage_numbers(not settings.damage_numbers)
	if app == null:
		apply_settings("damage_numbers")
	log_gate_f("damage numbers", "On" if settings.damage_numbers else "Off")


## Pushes a changed setting into the live room. Called by the app on every change
## and once at startup.
func apply_settings(key: String) -> void:
	if settings == null:
		return
	if key == "all" or key == "controller_deadzone":
		player.stick_deadzone = settings.controller_deadzone
		input_family.stick_threshold = settings.controller_deadzone
	if key == "all" or key == "aim_assistance":
		_apply_aim_assistance()
	if key == "all" or key == "master_volume":
		audio.apply_master_volume(settings.master_volume)
	last_gate_f_event = "settings applied: %s" % key


## §21 Controls, "aim assistance, default 70 / 100", applied to the ONE piece of
## assistance Prototype Zero has: the controller soft-target cone and its
## acquisition distance. The mouse is untouched — the cursor picks exactly what
## it is over, with no cone at all.
##
## At the default 70 the scale is exactly 1.000, so the D-178 values D-180
## accepted come back bit for bit: 65.0 degrees total and 5.0 m. The Gate F suite
## asserts that rather than trusting the arithmetic.
## D-191: it recomputes from the CANONICAL record every time and writes to the
## action's PRIVATE runtime copy, so repeated changes cannot compound and the
## authored `quick_strike.tres` is never written to. Before the correction the
## scaling wrote through to the cached canonical record and the next laboratory
## scaled the already-scaled numbers again — measured at assistance 100 as
## 78.0 deg / 6.00 m, then 93.6 deg / 7.20 m.
func _apply_aim_assistance() -> void:
	var runtime: QuickStrikeData = player.attack.data
	var canonical: QuickStrikeData = _canonical_quick_strike()
	if runtime == null or canonical == null:
		return
	# A room that somehow reached here without a private copy would be about to
	# write to the authored record. Refuse loudly rather than quietly corrupt it.
	assert(runtime != canonical,
		"PrototypeZeroRoom: aim assistance would write to the canonical quick_strike record")
	if runtime == canonical:
		return
	var scale: float = settings.aim_assist_scale()
	runtime.soft_target_cone_degrees = canonical.soft_target_cone_degrees * scale
	runtime.soft_target_distance = canonical.soft_target_distance * scale


## The authored record behind the action's private runtime copy. Falls back to
## the runtime record only when an action was built without ever entering the
## tree, which ordinary play never produces.
func _canonical_quick_strike() -> QuickStrikeData:
	if player == null or player.attack == null:
		return null
	if player.attack.canonical_data != null:
		return player.attack.canonical_data
	return player.attack.data


func _capture_locked_targeting() -> void:
	var canonical: QuickStrikeData = _canonical_quick_strike()
	if canonical == null:
		return
	_locked_cone_degrees = canonical.soft_target_cone_degrees
	_locked_soft_target_distance = canonical.soft_target_distance


func note_menu_cue(family: String) -> void:
	if audio != null:
		audio.play(family)


func log_gate_f(event: String, detail: String) -> void:
	last_gate_f_event = "%s — %s" % [event, detail]
	_log("gate-f", event, detail)


# --- Gate F: save points (specification §20.3) -------------------------------

## §20.3: "Save only on milestone transitions and deliberate clean exit." This is
## the milestone half; the app owns the clean-exit half.
func _on_milestone_committed(name: String) -> void:
	if app == null or director.reconstructing:
		return
	# DEFERRED, because `milestone_committed` is emitted from INSIDE the reward
	# door, before the director has entered the stage that reward opens. A save
	# taken there would record `STARTER_FIGHT` with 10 XP — a combination the
	# laboratory cannot reach, which the loader would then correctly refuse. The
	# deferred call runs at the end of the same frame, by which time the stage
	# transition has happened, so the file records a state Continue can rebuild.
	app.call_deferred("save_lab_state", "milestone: %s" % name)


func _on_experience_changed(current: int, maximum: int) -> void:
	if current > 0 and hud != null:
		note_menu_cue("reward_experience")
	last_gate_f_event = "XP %d / %d" % [current, maximum]


## Entering the repeat loop is the fifth milestone in practice — it is the state
## Continue has to be able to rebuild — and it commits no reward, so it needs its
## own save point.
func _on_stage_changed_for_save(_from: LabProgress.Stage, to: LabProgress.Stage) -> void:
	if to != LabProgress.Stage.REPEAT_LOOP or app == null or director.reconstructing:
		return
	app.call_deferred("save_lab_state", "stage: REPEAT_LOOP")


## Specification §11.2 asks for "a quiet indicator" identifying the current soft
## target. On a controller that has to be visible BEFORE the button is pressed,
## so the choice is refreshed while idle too — without touching action state.
func _refresh_idle_soft_target() -> void:
	if player.attack.busy() or any_modal_is_open():
		return
	if input_family.family != InputFamilyTracker.Family.CONTROLLER:
		if soft_target != null:
			_set_soft_target(null)
		return
	var chosen: Dictionary = _controller_aim()
	last_aim_reason = String(chosen["reason"])
	last_aim_source = String(chosen["source"])
	last_aim_group = String(chosen.get("group", "none"))
	_set_soft_target(chosen["target"] as PrototypeTargetable)


func set_debug_visuals(enabled: bool) -> void:
	set_navigation_visuals(enabled)
	combat_visuals.visible = enabled


## The navigation overlay is a translucent sheet over the whole floor, so the
## combat arcs are far easier to read with it off. They toggle together for F3
## and separately for evidence capture.
func set_navigation_visuals(enabled: bool) -> void:
	debug_visuals.visible = enabled
	if enabled:
		debug_visuals.show_navigation_mesh(nav_region.navigation_mesh)
		debug_visuals.show_path(player.current_path())


## Opens or closes both instrumentation panels, as F3 does.
func set_debug_panels(enabled: bool) -> void:
	if overlay.has_method("set_debug_visible"):
		overlay.call("set_debug_visible", enabled)
	if combat_overlay.has_method("set_detail_visible"):
		combat_overlay.call("set_detail_visible", enabled)
	if encounter_overlay.has_method("set_detail_visible"):
		encounter_overlay.call("set_detail_visible", enabled)
	lab_overlay.call("set_detail_visible", enabled)


func _physics_process(_delta: float) -> void:
	if player == null:
		return
	player.set_stick_raw(read_stick_raw())


## Raw left-stick reading before any deadzone is applied. The deadzone lives in
## the player so one tunable value drives movement, and in the family tracker so
## one drift threshold drives glyphs; nothing else reads the sticks.
func read_stick_raw() -> Vector2:
	if _stick_override_active:
		return _stick_override
	return PrototypeLocomotion.read_stick_actions()


func set_stick_override(raw: Variant) -> void:
	if raw == null:
		_stick_override_active = false
		_stick_override = Vector2.ZERO
		return
	_stick_override_active = true
	_stick_override = raw


func _update_neutral_latch() -> void:
	if not player.awaiting_neutral:
		return
	# A fallen player stays latched. Gate D owns mechanical death; the neutral
	# handshake that releases it belongs to Gate F's Restart, and clearing it here
	# would claim a resume that does not exist yet.
	if not player.is_alive():
		return
	if Input.is_action_pressed(&"move_point"):
		return
	if read_stick_raw().length() > player.stick_deadzone:
		return
	player.release_neutral_latch()
	log_event("input neutral", "held movement controls returned to neutral; input accepted again")


# --- Quick Strike aim (specification §11) ------------------------------------

## The one place that answers "what is this attack aimed at?". It is called when
## an attempt begins and again for every held repeat, so aim is refreshed between
## uses rather than frozen at the first press (specification §11.1).
##
## Mouse and controller deliberately answer it differently:
##   mouse      — an exact cursor pick, or a directional swing toward the ground
##                point under the cursor. No cone, no assistance.
##   controller — the §11.2 soft-target cone led by the stick direction, falling
##                back to current facing when the stick is neutral. The cone is
##                65 deg TOTAL and a candidate already inside reach outranks any
##                approach candidate (D-178).
func resolve_quick_strike_aim() -> Dictionary:
	player.attack.set_attack_in_place(Input.is_action_pressed(&"attack_in_place"))
	var answer: Dictionary = (
		_controller_aim() if input_family.family == InputFamilyTracker.Family.CONTROLLER
		else _mouse_aim()
	)
	last_aim_reason = String(answer.get("reason", "none"))
	last_aim_source = String(answer.get("source", "none"))
	last_aim_group = String(answer.get("group", "none"))
	_set_soft_target(answer.get("target", null) as PrototypeTargetable)
	return answer


func _mouse_aim() -> Dictionary:
	var camera: Camera3D = camera_rig.camera
	var screen: Vector2 = _cursor_override if _cursor_override != null else get_viewport().get_mouse_position()
	var from: Vector3 = camera.project_ray_origin(screen)
	var direction: Vector3 = camera.project_ray_normal(screen)

	var picked: PrototypeTargetable = acquisition.fixture_under_ray(from, direction)
	if picked != null:
		return {
			"target": picked,
			"direction": _planar(picked.global_position - player.global_position),
			"reason": "cursor over %s at %.2f m" % [
				picked.target_display_name(),
				_planar(picked.global_position - player.global_position).length(),
			],
			"source": "mouse pick",
			# The mouse has no cone, no acquisition distance, and no D-178
			# priority group: the cursor picks exactly what it is over.
			"group": "cursor",
		}

	# Specification §11.1: "Right-clicking ground or empty space swings from the
	# current position toward the cursor; it does not unexpectedly walk."
	var ground: Dictionary = ground_point_under_cursor(screen)
	var aim: Vector3 = player.facing_direction()
	if bool(ground.get("valid", false)):
		var to_cursor: Vector3 = _planar(ground["point"] - player.global_position)
		if to_cursor.length() > 0.05:
			aim = to_cursor
	return {
		"target": null,
		"direction": aim,
		"reason": "no enemy under the cursor; directional swing",
		"source": "mouse direction",
		"group": "cursor",
	}


func _controller_aim() -> Dictionary:
	var raw: Vector2 = read_stick_raw()
	var intended: Vector3 = player.facing_direction()
	var source: String = "facing fallback (stick neutral)"
	if raw.length() > player.stick_deadzone:
		var planar: Vector3 = camera_rig.ground_right() * raw.x + camera_rig.ground_forward() * -raw.y
		if planar.length() > 0.0001:
			intended = planar.normalized()
			source = "stick direction"

	# Retention is bounded in TIME, not held forever: past the window the choice
	# is made freshly, so a target that has stopped being the sensible one cannot
	# keep its place indefinitely just by having been chosen first.
	var previous: PrototypeTargetable = null
	if soft_target != null and soft_target_retention_remaining() > 0.0:
		previous = soft_target
	var chosen: Dictionary = acquisition.soft_target(
		player.global_position, intended, target_candidates(), player.attack.data, previous
	)
	return {
		"target": chosen["target"],
		"direction": intended,
		"reason": String(chosen["reason"]),
		"source": source,
		"group": String(chosen.get("group", "none")),
		"considered": chosen["considered"],
	}


## Everything Quick Strike may currently acquire, approach, or resolve onto: the
## inert practice posts and — since Gate D — the Graveblade, through the small
## shared `PrototypeTargetable` protocol. A dead Graveblade drops out here, which
## is one of the several places its death removes it as a threat.
func target_candidates() -> Array[PrototypeTargetable]:
	var living: Array[PrototypeTargetable] = []
	for fixture: PrototypeTargetFixture in fixtures:
		if fixture.is_valid_target():
			living.append(fixture)
	for enemy: PrototypeGraveblade in graveblades:
		if not is_instance_valid(enemy):
			continue
		var area: PrototypeTargetable = enemy.get_node("TargetArea") as PrototypeTargetable
		if area != null and area.is_valid_target():
			living.append(area)
	return living


## Seconds of retention still owed to the current soft target.
func soft_target_retention_remaining() -> float:
	if soft_target == null:
		return 0.0
	var elapsed: float = float(Time.get_ticks_msec() - soft_target_since_msec) / 1000.0
	return maxf(player.attack.data.soft_target_retention - elapsed, 0.0)


func _set_soft_target(next: PrototypeTargetable) -> void:
	if next == soft_target:
		return
	if soft_target != null:
		soft_target.set_soft_targeted(false)
	var previous_name: String = soft_target.target_display_name() if soft_target != null else "none"
	soft_target = next
	soft_target_since_msec = Time.get_ticks_msec()
	if soft_target != null:
		soft_target.set_soft_targeted(true)
	log_combat("target %s" % ("acquired" if next != null else "cleared"), "%s -> %s (%s)" % [
		previous_name, soft_target.target_display_name() if soft_target != null else "none", last_aim_reason,
	])


## Verification seam, matching `set_stick_override`. Ordinary play always uses
## the live pointer.
func set_cursor_override(screen: Variant) -> void:
	_cursor_override = screen


## Gate F: the §18 commitment cue, at the moment the wind-up begins.
func _on_use_started(_id: int) -> void:
	feedback.show_player_commitment()


func _on_use_released(id: int, outcome: Dictionary) -> void:
	# §18 "short weapon trail or release flash", drawn on EVERY release so a
	# genuine miss still shows the swing that missed.
	feedback.show_player_release(
		player.global_position, player.facing_direction(),
		player.attack.data.reach, player.attack.data.release_arc_degrees
	)
	# Specification §9.5: after release the suspended movement intent resumes,
	# which is what lets a still-held button end the recovery immediately.
	if _mouse_hold_suspended:
		_mouse_hold_suspended = false
		if Input.is_action_pressed(&"move_point"):
			_mouse_hold_active = true
			_hold_timer = 0.0
			log_combat("held movement resumed", "the left button was still down; recovery may now be cancelled")
	combat_visuals.show_release(
		player.global_position, player.facing_direction(),
		player.attack.data.reach, player.attack.data.release_arc_degrees,
		String(outcome["outcome"]) == "hit"
	)
	if String(outcome["outcome"]) == "miss":
		return
	var struck: PrototypeTargetable = outcome["target"] as PrototypeTargetable
	var event: DamageEvent = outcome.get("event", null) as DamageEvent
	if event == null:
		log_combat("release resolved", "use %d struck %s — an inert practice post, so no DamageEvent" % [
			id, struck.target_display_name(),
		])
		return
	log_combat("release resolved", "use %d struck %s — %s" % [id, struck.target_display_name(), event.describe()])


func _planar(vector: Vector3) -> Vector3:
	return Vector3(vector.x, 0.0, vector.z)


# --- Movement commands -------------------------------------------------------

func _issue_move_command() -> void:
	var cursor: Dictionary = ground_point_under_cursor(_cursor_override)
	if not bool(cursor.get("valid", false)):
		rejected_commands += 1
		log_event("movement command rejected", "no ground under the cursor")
		return
	var requested: Vector3 = cursor["point"]
	var resolution: Dictionary = resolve_to_navigation(requested)
	player.command_move_to(resolution["point"], requested, bool(resolution["adjusted"]))


## Where the cursor meets the world. Falls back to the y = 0 ground plane when
## the ray misses every collider, so a click on empty floor beyond the room edge
## still produces a point that the navigation resolution can correct.
## `at_screen` exists so the verification run can aim the same ray the mouse
## aims; ordinary play always uses the live pointer position.
func ground_point_under_cursor(at_screen: Variant = null) -> Dictionary:
	var screen: Vector2 = at_screen if at_screen != null else get_viewport().get_mouse_position()
	return PrototypeGroundPointer.ground_point(
		camera_rig.camera, get_world_3d(), screen, WORLD_MASK
	)


## Specification §9.3: "An unreachable point resolves to the nearest valid
## navigation point and never causes permanent running into a wall."
func resolve_to_navigation(requested: Vector3) -> Dictionary:
	return PrototypeGroundPointer.resolve_to_navigation(navigation_map(), requested)


func _on_movement_command_resolved(status: String, requested: Vector3, resolved: Vector3) -> void:
	if status.begins_with("rejected"):
		rejected_commands += 1
		log_event("movement command rejected", status)
		return
	if status == "adjusted":
		adjusted_commands += 1
		log_event("movement command adjusted", "clicked (%.2f, %.2f) is not walkable; nearest navigable point (%.2f, %.2f)" % [
			requested.x, requested.z, resolved.x, resolved.z,
		])
	else:
		accepted_commands += 1
		log_event("movement command accepted", "destination (%.2f, %.2f)" % [resolved.x, resolved.z])
	marker.show_destination(resolved, requested, status == "adjusted")


func _on_arrived(point: Vector3) -> void:
	marker.hide_destination()
	log_event("arrived", "at (%.2f, %.2f)" % [point.x, point.z])


func _on_intent_cleared(reason: String) -> void:
	if reason != "suspended by Quick Strike":
		_mouse_hold_suspended = false
	marker.hide_destination()
	log_event("movement intent cleared", reason)


func _on_family_changed(family: InputFamilyTracker.Family, reason: String) -> void:
	log_event("input family", "%s (%s)" % [input_family.family_label(), reason])
	if family == InputFamilyTracker.Family.CONTROLLER:
		# Only the glyph family changes here. Mechanical state is untouched, per
		# specification §9.2.
		pass


func _on_controller_connection_changed(device: int, connected: bool) -> void:
	log_event("controller", "device %d %s" % [device, "connected" if connected else "disconnected"])
	if connected:
		return
	player.clear_movement_intent("controller disconnected")
	_mouse_hold_active = false
	_mouse_hold_suspended = false
	if feedback != null:
		feedback.stop_all()
	# Gate F. The canonical settings rules pause ordinary offline simulation on
	# controller loss, and D-189 lists controller disconnect among the boundaries
	# stale input must not cross. Pausing is how both are true at once — and the
	# tracker has already fallen back to the family the player can still use, so
	# the paused menu is operable with the mouse.
	if _verifying or not is_node_ready():
		return
	if not any_modal_is_open() and player.is_alive():
		open_pause("controller disconnected")


# --- Interruptions -----------------------------------------------------------

func _notification(what: int) -> void:
	if what == NOTIFICATION_APPLICATION_FOCUS_OUT or what == NOTIFICATION_WM_WINDOW_FOCUS_OUT:
		if player == null or _verifying or not is_node_ready():
			return
		player.clear_movement_intent("window focus lost")
		_mouse_hold_active = false
		_mouse_hold_suspended = false
		if feedback != null:
			feedback.stop_all()
		# Gate F. The canonical session rules pause ordinary offline simulation
		# on default focus loss, and D-189 requires focus loss to be one of the
		# boundaries stale input cannot cross. Pausing is how both are true at
		# once: the world stops, and resuming goes through the same neutral latch
		# every other boundary uses.
		if not any_modal_is_open() and player.is_alive():
			open_pause("window focus lost")


# --- Local log ---------------------------------------------------------------

func log_event(event: String, detail: String) -> void:
	_log("gate-b", event, detail)


## Gate C events share the same ring buffer but keep their own console prefix, so
## a combat trace can be read apart from a locomotion trace.
func log_combat(event: String, detail: String) -> void:
	_log("gate-c", event, detail)


## Gate D events share the same ring buffer and keep their own console prefix,
## so an encounter trace can be read apart from a combat-kernel or locomotion one.
func log_encounter(event: String, detail: String) -> void:
	_log("gate-d", event, detail)


## Gate E events share the same ring buffer and keep their own console prefix, so
## a progression trace can be read apart from an encounter, combat-kernel, or
## locomotion one.
func log_progression(event: String, detail: String) -> void:
	_log("gate-e", event, detail)


func _log(channel: String, event: String, detail: String) -> void:
	print("[%s] %-28s %s" % [channel, event, detail])
	log_lines.append("%s — %s" % [event, detail])
	if log_lines.size() > 8:
		log_lines.remove_at(0)


# --- Room queries, forwarded so callers need one handle ----------------------

func clear_extent() -> Vector2:
	return room.clear_extent()


func clear_half_extent() -> Vector2:
	return room.clear_half_extent()


func contains_point_in_clear_floor(point: Vector3, margin: float = 0.0) -> bool:
	return room.contains_point(point, margin)


func agent_radius_used() -> float:
	return agent_radius


# --- Measured calibration ----------------------------------------------------

## Everything Gate B measured rather than assumed, for the overlay, the report,
## and the verification run.
func calibration_summary() -> Dictionary:
	# CF is recorded at the project's fixed 1920 x 1080 UI reference aspect, so
	# the number means the same thing in a headless run, a 1280 x 720 window, and
	# macOS fullscreen. The live window aspect is reported separately.
	var reference_aspect: float = (
		float(ProjectSettings.get_setting("display/window/size/viewport_width", 1920))
		/ float(ProjectSettings.get_setting("display/window/size/viewport_height", 1080))
	)
	var viewport_size: Vector2 = get_viewport().get_visible_rect().size
	var live_aspect: float = viewport_size.x / maxf(viewport_size.y, 1.0)
	var footprint: Dictionary = camera_rig.ground_footprint(reference_aspect)
	var clear: Vector2 = room.clear_extent()
	var cf_area: float = float(footprint["focus_width"]) * float(footprint["depth"])
	return {
		"world_unit": "1 unit = 1 metre (locked for Prototype Zero by D-175)",
		"player_collision_diameter_P": 0.80,
		"player_collision_height": 1.80,
		"clear_floor": clear,
		"full_floor": room.floor_extent(),
		"max_speed": player.max_speed,
		"acceleration": player.acceleration,
		"braking": player.braking,
		"stick_deadzone": player.stick_deadzone,
		"camera_yaw": camera_rig.yaw_degrees,
		"camera_pitch": camera_rig.pitch_degrees,
		"camera_fov": camera_rig.fov_degrees,
		"camera_distance": camera_rig.distance_metres,
		"camera_height": footprint["camera_height"],
		"cf_focus_width": footprint["focus_width"],
		"cf_near_width": footprint["near_width"],
		"cf_far_width": footprint["far_width"],
		"cf_depth": footprint["depth"],
		"cf_area": cf_area,
		"room_in_cf": (clear.x * clear.y) / maxf(cf_area, 0.001),
		"ground_visible_past_focus": footprint["ground_behind_focus"],
		"aspect": reference_aspect,
		"live_aspect": live_aspect,
		"navmesh_polygons": navmesh_polygon_count,
		"navmesh_area": navmesh_area,
		"crossing_time_long_axis": clear.x / maxf(player.max_speed, 0.01),
	}
