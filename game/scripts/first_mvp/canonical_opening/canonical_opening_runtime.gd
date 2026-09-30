class_name CanonicalOpeningRuntime
extends BrokenWatchSlice
## First-MVP — Gate 1E: the integrated canonical opening (D-219).
##
## Riftfall Landing -> Broken Watch -> Nexus Threshold -> the Rift Nexus, as ONE
## directly runnable composition with a character who owns Level, XP, Passive
## points, Skills, equipment and progression, and who survives quitting.
##
##   /Applications/Godot.app/Contents/MacOS/Godot --path game \
##     res://scenes/first_mvp/canonical_opening/canonical_opening.tscn
##
## IT EXTENDS `BrokenWatchSlice` RATHER THAN REPLACING IT, AND THAT IS THE
## SINGLE MOST IMPORTANT DECISION IN THIS FILE.
##
## The brief: "Do not redesign ... Gate 1D item flow", "Do not turn the
## historical Prototype App into the first-MVP architecture", "Create the
## smallest clean runtime composition appropriate to the existing repository
## structure." Gate 1D is accepted, playtested, and already assembles Riftfall
## Landing's accepted foundation, Broken Watch, the proven combat kernel,
## per-use mouse targeting, the guaranteed drop, comparison, equip, Fallen and
## Restart. Re-implementing any of that would be a second subtly different
## copy of an accepted thing — the exact failure the project's own rules forbid
## ("do not add a second subtly different click-to-move implementation").
##
## Extending it means:
##
##   * `broken_watch_slice.gd` and `broken_watch_slice.tscn` are BYTE-IDENTICAL.
##     Gate 1D's own scene still runs on its own and its suite still passes at
##     its locked 129.
##   * `FirstMvpModal`, `FirstMvpCombatHud`, `FirstMvpItemComparison` and
##     `FirstMvpFallenOverlay` all type their owner as `BrokenWatchSlice`. This
##     runtime IS one, so every Gate 1E surface reuses that proven modal
##     contract — pause, neutralize, safe focus, neutral-input arming, live
##     glyphs — with no third copy of it anywhere.
##   * The combat kernel wiring, the aim providers, the movement input, the
##     camera and the navigation are inherited rather than rewritten.
##
## WHAT THIS CLASS ADDS, AND ONLY THIS:
##
##   1. TWO MORE SPACES under the same `NavigationRegion3D`, so all four bake as
##      one continuous navigation mesh. `_configure_navigation()` is overridden
##      to merge four bake rects instead of two — the ONE inherited method that
##      could not know about them.
##   2. A CHARACTER that owns progression and is saved.
##   3. THE NEXUS BEATS: the Anchor's recognition, Mara, the first conversation,
##      the milestone Passive point, the Origin Ring, and the Foundation Cache.
##   4. A SAFE REGION. Past the Nexus Threshold's safe boundary no enemy acts
##      and no damaging Skill fires.
##   5. THE FIRST FOOTING BOUNDARY, which stops the slice.
##
## ENVIRONMENT AND WORLD OWNERSHIP IS PRESERVED. The brief: "Continue to
## preserve canonical environment scenes as environment/world ownership where
## that separation already exists." All four spaces are LAYOUT classes that own
## geometry, collision, navigation carves, dressing and named sockets, and own
## no player, no camera, no HUD and no progression — exactly the separation
## Riftfall Landing established and Broken Watch followed.
##
## THE PROTOTYPE APP IS NOT TOUCHED. `run/main_scene` is still
## `res://scenes/app/prototype_app.tscn` and this scene is never reached
## through it. Start Fresh / Continue are physical-key developer entry points
## on this scene, exactly as every gate since 1A has read its own controls as
## physical keys rather than declaring an InputMap action.

const VERIFICATION_1E_SCRIPT: String = "res://tests/gate_1e_canonical_opening_verification.gd"

const STARTING_SWORD: String = "res://data/first_mvp/severed_threshold/broken_watch/starting_sword.tres"
const WATCHSTEEL_SWORD: String = "res://data/first_mvp/severed_threshold/broken_watch/watchsteel_sword.tres"
const GARRISON_GREATSWORD: String = "res://data/first_mvp/foundation/garrison_greatsword.tres"
const MARROW_BOW: String = "res://data/first_mvp/foundation/marrow_bow.tres"
const CANTOR_WAND: String = "res://data/first_mvp/foundation/cantor_wand.tres"

## The two authored opening encounters. Stable ids, so a Restart cannot make the
## same authored Graveblade pay twice.
const FIRST_ENCOUNTER_ID: StringName = &"broken_watch_first"
const SECOND_ENCOUNTER_ID: StringName = &"broken_watch_second"

const INTERACTION_RANGE: float = 3.20
const FORWARD_ROUTE_RANGE: float = 3.00

var nexus_threshold: NexusThresholdLayout
var rift_nexus: RiftNexusLayout
var anchor: RiftAnchor
var mara: MaraVeyl

var character: CharacterState
var character_save: CharacterSave
var skills: FirstMvpSkillLibrary
var conversation: FirstMvpDialogue

var dialogue_panel: NexusDialoguePanel
var origin_ring_panel: OriginRingPanel
var foundation_cache_panel: FoundationCachePanel
var opening_hud: CanonicalOpeningHud

## Every authored weapon record this opening can grant, by item id. The save
## resolves a saved id back to a record through this, so `CharacterSave` never
## holds a resource path.
var weapon_records: Dictionary = {}

var safe_region_active: bool = false
var first_footing_reached: bool = false
var autosaves_written: int = 0
var last_autosave_reason: String = "none"

var _mara_nameplate: Button
var _anchor_recognition_handled: bool = false


# --- Assembly ------------------------------------------------------------------

func _ready() -> void:
	# Resolve the two new layouts BEFORE the inherited `_ready()` runs, because
	# the navigation override below needs them and the base class bakes inside
	# its own `_ready()`.
	# `broken_watch` is resolved here TOO, even though the inherited `_ready()`
	# assigns it, because the far cap must be opened before that `_ready()`
	# bakes the navigation — and at this moment the inherited field is still
	# null. It is assigned to the same node the base class will resolve.
	broken_watch = $Composition/NavigationRegion3D/BrokenWatch
	nexus_threshold = $Composition/NavigationRegion3D/NexusThreshold
	rift_nexus = $Composition/NavigationRegion3D/RiftNexus

	_build_weapon_records()
	_build_character()
	_open_broken_watch_far_cap()

	# Builds Riftfall Landing's accepted foundation, Broken Watch, the combat
	# kernel, the camera, the HUD, the item flow, Fallen and Restart — all
	# unmodified. It also bakes the navigation, through the override below.
	await super._ready()

	_build_nexus_content()
	_build_surfaces()
	_connect_experience()
	_apply_loaded_character()

	log_event("canonical opening", "Riftfall Landing -> Broken Watch -> Nexus Threshold -> Rift Nexus")
	log_event("nexus threshold", "%.2f m^2 = %.2f CF across %d room(s), %d dressing instance(s)" % [
		nexus_threshold.footprint_area(), nexus_threshold.footprint_cf(),
		nexus_threshold.room_count(), nexus_threshold.dressing_instance_count(),
	])
	log_event("rift nexus", "%.2f m^2 = %.2f CF across %d room(s), %d dressing instance(s)" % [
		rift_nexus.footprint_area(), rift_nexus.footprint_cf(),
		rift_nexus.room_count(), rift_nexus.dressing_instance_count(),
	])
	log_event("character", character.describe())
	log_event("save", character_save.describe())


## BROKEN WATCH SEALED ITS OWN FAR END, AND THAT SEAL IS NOW FALSE BY
## AUTHORIZATION. `BrokenWatchLayout`'s last boundary wall is described in its
## own source as "a low far cap beyond the exit socket, so the room reads as a
## threshold rather than trailing into void — the unbuilt Nexus Threshold
## begins past it, and this gate stops here." That was exactly right for a
## bounded slice whose route ended there. The Nexus Threshold is now built, and
## a 12 x 2 m solid across the route would make it unreachable — which is
## precisely what the navigation check caught before this existed.
##
## IT IS OPENED HERE RATHER THAN DELETED FROM GATE 1D. `broken_watch_layout.gd`
## stays byte-identical and `broken_watch_slice.tscn` still runs on its own with
## its cap intact, so Gate 1D's accepted scene is unchanged and its own suite
## still passes. The integrated opening simply removes the cap from ITS OWN
## instance, before the navigation bake, because in this composition the route
## continues.
##
## The cap is found by its HEIGHT rather than by a hard-coded node name: it is
## the only `CAP_HEIGHT` wall in the layout, while every other boundary is
## `WALL_HEIGHT`. Exactly one must be found — a name would silently match
## nothing if the layout were ever re-authored, and finding none or several is
## a real change that should fail loudly rather than quietly reseal the route.
func _open_broken_watch_far_cap() -> void:
	var opened: int = 0
	for entry: Dictionary in BrokenWatchLayout.BOUNDARY_WALLS:
		if not is_equal_approx(float(entry["height"]), BrokenWatchLayout.CAP_HEIGHT):
			continue
		var rect: Rect2 = entry["rect"]
		var stem: String = "Wall_%d_%d" % [int(rect.position.x * 10.0), int(rect.position.y * 10.0)]
		for path: String in ["Visuals/%s" % stem, "WorldCollision/%s" % stem,
			"NavigationObstacles/%sCarve" % stem]:
			var node: Node = broken_watch.get_node_or_null(path)
			if node != null:
				node.free()
		opened += 1
	assert(opened == 1,
		"CanonicalOpeningRuntime: expected exactly one Broken Watch far cap to open, found %d" % opened)
	log_event("route opened", "Broken Watch's far cap is removed in THIS composition; the route continues")


## THE ONE INHERITED METHOD THAT CANNOT KNOW ABOUT THE NEW SPACES. Gate 1D
## merges the Landing's and Broken Watch's bake rects; all four must be merged
## here or the two new spaces bake as nothing and the player walks into a void
## the navigation mesh does not cover.
##
## Everything else about the bake — cell size, agent radius/height/climb/slope,
## the 0.15 cell height the Gate 1B lesson locked, and the single
## `SOURCE_GEOMETRY_ROOT_NODE_CHILDREN` region — is inherited unchanged, which
## is why all four spaces come out as ONE continuous mesh from ONE bake rather
## than four maps stitched together at runtime.
func _configure_navigation() -> void:
	super._configure_navigation()
	var mesh: NavigationMesh = nav_region.navigation_mesh
	var rect: Rect2 = landing_layout.bake_rect() \
		.merge(broken_watch.bake_rect()) \
		.merge(nexus_threshold.bake_rect()) \
		.merge(rift_nexus.bake_rect())
	mesh.filter_baking_aabb = AABB(
		Vector3(rect.position.x, bake_floor, rect.position.y),
		Vector3(rect.size.x, bake_ceiling - bake_floor, rect.size.y)
	)


func _build_weapon_records() -> void:
	weapon_records.clear()
	for path: String in [WATCHSTEEL_SWORD, GARRISON_GREATSWORD, MARROW_BOW, CANTOR_WAND]:
		var record: PrototypeWeaponData = load(path) as PrototypeWeaponData
		var typed: FirstMvpWeaponRecord = record as FirstMvpWeaponRecord
		var id: StringName = typed.item_id if typed != null else record.weapon_id
		weapon_records[id] = record


func _build_character() -> void:
	skills = FirstMvpSkillLibrary.new()
	assert(skills.is_coherent(), "CanonicalOpeningRuntime: %s" % ", ".join(skills.problems))
	conversation = FirstMvpDialogue.new()
	assert(conversation.problem().is_empty(), "CanonicalOpeningRuntime: %s" % conversation.problem())

	character = CharacterState.new()
	character.adopt_starting_weapon(load(STARTING_SWORD) as PrototypeWeaponData)

	character_save = CharacterSave.new()
	var directory: String = _requested_state_directory()
	if not directory.is_empty():
		var accepted: bool = character_save.set_storage_path(directory.path_join(CharacterSave.FILE_NAME))
		assert(accepted, "CanonicalOpeningRuntime: %s" % character_save.last_save_status)

	if _start_fresh_requested():
		character_save.delete_saved_character()
		log_event("start fresh", "the first-MVP character was cleared; nothing else was touched")
	elif character_save.load_into(character, skills, weapon_records):
		log_event("continue", character_save.last_load_status)
	else:
		log_event("new character", character_save.last_load_status)


## `--state-dir <dir>`, the same contract `PrototypeApp` already honours, so the
## verification can be handed isolated storage. Ordinary launches pass nothing
## and use the production character file.
func _requested_state_directory() -> String:
	var arguments: PackedStringArray = OS.get_cmdline_user_args()
	for index: int in arguments.size():
		if arguments[index] == "--state-dir" and index + 1 < arguments.size():
			return arguments[index + 1]
	return ""


func _start_fresh_requested() -> bool:
	return OS.get_cmdline_user_args().has("--start-fresh")


func _build_nexus_content() -> void:
	anchor = RiftAnchor.new()
	anchor.name = "CentralAnchor"
	anchor.configure(_log_combat_event)
	$Actors.add_child(anchor)
	anchor.global_position = rift_nexus.anchor_point()
	anchor.recognized.connect(_on_anchor_recognized)

	mara = MaraVeyl.new()
	mara.name = "MaraVeyl"
	mara.configure(_log_combat_event)
	$Actors.add_child(mara)
	# She stands in the Nexus, at her own station, facing the way the player
	# will arrive. The Threshold's `MaraStation` socket is kept as the authored
	# alternative for a later staging decision and is deliberately unused: the
	# canon puts her in the Nexus, and the Nexus is where she can be met more
	# than once.
	mara.global_position = rift_nexus.mara_station()
	mara.face_towards(rift_nexus.anchor_point())


func _build_surfaces() -> void:
	opening_hud = CanonicalOpeningHud.new()
	opening_hud.name = "OpeningHud"
	$CanvasLayer.add_child(opening_hud)
	opening_hud.bind_runtime(self)

	dialogue_panel = NexusDialoguePanel.new()
	dialogue_panel.name = "DialoguePanel"
	$CanvasLayer.add_child(dialogue_panel)
	dialogue_panel.bind_room(self)

	origin_ring_panel = OriginRingPanel.new()
	origin_ring_panel.name = "OriginRingPanel"
	$CanvasLayer.add_child(origin_ring_panel)
	origin_ring_panel.bind_room(self)

	foundation_cache_panel = FoundationCachePanel.new()
	foundation_cache_panel.name = "FoundationCachePanel"
	$CanvasLayer.add_child(foundation_cache_panel)
	foundation_cache_panel.bind_room(self)

	_mara_nameplate = Button.new()
	_mara_nameplate.name = "MaraNameplate"
	_mara_nameplate.focus_mode = Control.FOCUS_NONE
	_mara_nameplate.visible = false
	_mara_nameplate.pressed.connect(func() -> void: open_dialogue("nameplate clicked"))
	$CanvasLayer.add_child(_mara_nameplate)


## Applies a loaded character to the world: where they stand, what they carry,
## what the Anchor already did, and whether the guaranteed drop is spent.
func _apply_loaded_character() -> void:
	player.equip_weapon(character.equipment.equipped_weapon)
	player.set_increased_attack_speed(character.passives.effects.increased_attack_and_cast_speed)

	# THE GUARANTEED DROP CANNOT BE EARNED TWICE. Gate 1D's `_drop_granted`
	# latch is scene-local and dies with the scene; the character's own
	# `watchsteel_granted` is saved. Setting the inherited latch from the saved
	# one is what makes a reload unable to produce a second Watchsteel — and it
	# reuses Gate 1D's own refusal path rather than adding a second one.
	if character.watchsteel_granted:
		_drop_granted = true
		# IF IT WAS GRANTED BUT IS NOT OWNED, THIS IS A SAVE FROM BEFORE THE
		# OWNERSHIP FIX ABOVE, so the sword exists nowhere: not in the world (the
		# latch stops it being re-placed) and not in the character's items. It is
		# restored to OWNED rather than re-dropped, because the encounter it
		# belongs to has already been cleared and re-dropping it would put a
		# reward on the ground beside a corpse that is no longer there.
		var watchsteel: PrototypeWeaponData = load(WATCHSTEEL_SWORD) as PrototypeWeaponData
		if character.equipment.find_owned(&"watchsteel_sword") == null:
			character.equipment.pick_up(watchsteel)
			log_event("save repair", "the guaranteed Watchsteel Sword was granted but unowned; restored to your items")

	# Enemies belong to Broken Watch, and Broken Watch may already be behind
	# this character.
	if character.broken_watch_complete:
		for enemy: PrototypeGraveblade in graveblades:
			enemy.set_ai_enabled(false)
			enemy.visible = false
		slice_complete = true

	if character.nexus_recognition_complete:
		anchor.set_already_awake()
		_anchor_recognition_handled = true

	player.global_position = _spawn_for_milestone()
	player.face_instantly(route_forward())
	_refresh_safe_region(player.global_position)


## Where a character standing at `milestone` belongs. Continuing puts them back
## where their progress actually is rather than at the very beginning.
func _spawn_for_milestone() -> Vector3:
	match character.milestone:
		CharacterState.Milestone.BROKEN_WATCH:
			return broken_watch.entry()
		CharacterState.Milestone.BROKEN_WATCH_COMPLETE:
			return nexus_threshold.entry()
		CharacterState.Milestone.NEXUS_THRESHOLD:
			return nexus_threshold.entry()
		CharacterState.Milestone.NEXUS_RECOGNITION, \
		CharacterState.Milestone.MARA_FIRST_CONVERSATION, \
		CharacterState.Milestone.FOUNDATION_CHOSEN, \
		CharacterState.Milestone.READY_FOR_FIRST_FOOTING:
			return rift_nexus.arrival()
		_:
			return landing_layout.player_start()


func _maybe_start_verification() -> void:
	var arguments: PackedStringArray = OS.get_cmdline_user_args()
	if not arguments.has("--verify-1e"):
		return
	var script: GDScript = load(VERIFICATION_1E_SCRIPT) as GDScript
	var runner: Node = Node.new()
	runner.name = "CanonicalOpeningVerification"
	runner.set_script(script)
	runner.set("runtime", self)
	runner.set("arguments", arguments)
	add_child(runner)


# --- Experience ----------------------------------------------------------------

## Gate 1D's own kill signals are per-enemy; this connects to BOTH Graveblades
## and pays each authored encounter exactly once, by id.
func _connect_experience() -> void:
	for index: int in graveblades.size():
		var enemy: PrototypeGraveblade = graveblades[index]
		var id: StringName = FIRST_ENCOUNTER_ID if index == 0 else SECOND_ENCOUNTER_ID
		enemy.died.connect(func(_event: DamageEvent) -> void: _on_encounter_cleared(id))


func _on_encounter_cleared(encounter_id: StringName) -> void:
	if character.award_encounter_experience(encounter_id, ExperienceTable.GRAVEBLADE_EXPERIENCE):
		log_event("experience", "%d XP for %s — %s" % [
			ExperienceTable.GRAVEBLADE_EXPERIENCE, encounter_id,
			ExperienceTable.describe(character.total_experience),
		])
		opening_hud.flash("+%d XP" % ExperienceTable.GRAVEBLADE_EXPERIENCE)
	else:
		log_event("experience refused", character.last_refusal)
	if encounter_id == FIRST_ENCOUNTER_ID and _active_drop != null:
		# THE CHARACTER TAKES OWNERSHIP THE MOMENT THE DROP IS GUARANTEED, NOT
		# WHEN IT IS EQUIPPED, AND THAT ORDERING IS THE WHOLE POINT.
		#
		# Granting only the latch was a real and permanent loss: the autosave on
		# the next line writes `watchsteel_granted = true` immediately, and on the
		# next launch `_apply_loaded_character()` sets Gate 1D's `_drop_granted`
		# from it, so the drop is never placed again. A player who killed the
		# first Graveblade and quit before pressing Equip — or simply walked on,
		# which the comparison panel invites with "Close leaves it on the ground"
		# — lost the gate's headline weapon improvement for the life of that
		# character.
		#
		# Ownership and the latch now move together. The sword is OWNED but still
		# not EQUIPPED, so Gate 1D's separate deliberate equip step is untouched,
		# and `PlayerLoadout.pick_up()` refuses a duplicate by object identity so
		# this can never mint a second one.
		var watchsteel: PrototypeWeaponData = load(WATCHSTEEL_SWORD) as PrototypeWeaponData
		if character.grant_watchsteel(watchsteel):
			character.equipment.pick_up(watchsteel)
	autosave("encounter cleared: %s" % encounter_id)


# --- Item flow, extending Gate 1D's rather than replacing it -------------------

## Gate 1D equips directly onto the player. This additionally records ownership
## on the CHARACTER, so what is carried survives quitting.
func on_weapon_equipped(drop: FirstMvpItemDrop) -> void:
	var record: PrototypeWeaponData = loadout.equipped_weapon
	character.equipment.pick_up(record)
	character.equipment.equip(record)
	super.on_weapon_equipped(drop)
	if record.weapon_id == &"watchsteel_sword":
		character.note_watchsteel_equipped()
	autosave("equipped %s" % record.display_name)


# --- The safe region -----------------------------------------------------------

## Past the Nexus Threshold's safe boundary nothing hostile acts. The brief:
## "Nexus Threshold ... Combat after entry: none" and "The Rift Nexus is a safe
## area. Do not make Mara stand next to the player while the player repeatedly
## fireballs her."
##
## Measured against the boundary socket rather than against a room rectangle, so
## the rule has one number and the checks can read it.
func _refresh_safe_region(position: Vector3) -> void:
	# MEASURED IN THE LAYOUT'S OWN LOCAL FRAME, and that is not a detail.
	# `route_forward()` is the Landing centreline's FIRST segment in world
	# space; the composition carries a 45 deg yaw and the route winds, so that
	# vector is not the direction the route runs at the far end of it — a dot
	# product against it answers the wrong question by tens of metres. Every
	# layout's own local -Z is the route direction by construction, so the test
	# is one number against one constant and no rotation can move it.
	var local: Vector3 = nexus_threshold.to_local(position)
	var inside: bool = local.z <= NexusThresholdLayout.SAFE_BOUNDARY.y
	if inside == safe_region_active:
		return
	safe_region_active = inside
	if safe_region_active:
		for enemy: PrototypeGraveblade in graveblades:
			enemy.set_ai_enabled(false)
		attack_coordinator.revoke_all("the character crossed into the safe region")
		log_event("safe region", "entered; no enemy acts and no damaging Skill fires beyond here")
		character.reach(CharacterState.Milestone.NEXUS_THRESHOLD)
		autosave("entered the Nexus Threshold")
	else:
		# THE INVERSE OF THE DISABLE ABOVE. Without it, walking back out of the
		# Nexus Threshold left every Graveblade permanently inert, so a player who
		# stepped over the boundary and returned found Broken Watch harmless.
		# Encounters the character has genuinely finished stay finished.
		if not character.broken_watch_complete:
			for enemy: PrototypeGraveblade in graveblades:
				if enemy.is_alive():
					enemy.set_ai_enabled(true)
		log_event("safe region", "left")


func damaging_skills_allowed() -> bool:
	return not safe_region_active


# --- The Nexus beats -----------------------------------------------------------

func _on_anchor_recognized() -> void:
	if _anchor_recognition_handled:
		return
	_anchor_recognition_handled = true
	if not character.complete_nexus_recognition():
		log_event("recognition refused", character.last_refusal)
		return
	# THE WORLD EVENT HAPPENS FIRST AND THE REWARD FOLLOWS IT. No dialogue has
	# run at this point and none is opened here: the brief is explicit that
	# recognition comes before explanation.
	if character.claim_nexus_recognition_point():
		log_event("milestone", "the Nexus recognized the Mark — 1 guaranteed Passive point")
		opening_hud.flash("The Nexus answered. +1 Passive point")
	autosave("the Nexus recognized the Mark")


func open_dialogue(reason: String) -> void:
	if _any_modal_open():
		return
	if mara == null or dialogue_panel == null:
		return
	_hide_world_nameplates()
	log_event("conversation opened", reason)
	dialogue_panel.open_conversation(conversation)


func on_dialogue_finished() -> void:
	if character.complete_mara_first_conversation():
		log_event("milestone", "Mara's first conversation was read")
		autosave("Mara's first conversation")
	# Re-reading grants nothing; the latch above already refused.


func open_origin_ring(reason: String) -> void:
	if _any_modal_open():
		return
	_hide_world_nameplates()
	log_event("origin ring opened", reason)
	origin_ring_panel.open()


func open_foundation_cache(reason: String) -> void:
	if _any_modal_open():
		return
	if character.foundation_package_granted:
		opening_hud.flash("You have already chosen a direction to explore first")
		return
	_hide_world_nameplates()
	log_event("foundation cache opened", reason)
	foundation_cache_panel.open()


## THERE IS NO MODAL STACK IN THE INHERITED CONTRACT, and Gate 1D hand-wrote its
## two-modal test at three call sites. Gate 1E has five surfaces, so the test is
## written ONCE here and every opener asks it — otherwise two modals could open
## together and whichever closed first would unpause the world behind the other.
## Hides both floating nameplates immediately. `_process` is PAUSABLE, so once a
## modal has paused the tree neither nameplate updates again and whatever state
## it was left in persists on top of the modal — a 128x28 button sitting over a
## dialogue panel. The openers call this before pausing.
func _hide_world_nameplates() -> void:
	if _mara_nameplate != null:
		_mara_nameplate.visible = false
	var ground: Button = $CanvasLayer.get_node_or_null("GroundNameplate") as Button
	if ground != null:
		ground.visible = false


func _any_modal_open() -> bool:
	if item_comparison.is_open or fallen_overlay.is_open:
		return true
	if dialogue_panel != null and dialogue_panel.is_open:
		return true
	if origin_ring_panel != null and origin_ring_panel.is_open:
		return true
	if foundation_cache_panel != null and foundation_cache_panel.is_open:
		return true
	return false


func any_modal_open() -> bool:
	return _any_modal_open()


# --- The Foundation Cache ------------------------------------------------------

## The three canonical packages, built from the Skill library and the authored
## weapon records rather than written down twice.
func foundation_packages() -> Array[Dictionary]:
	return [
		_package(CharacterState.FoundationPackage.HEAVY_MELEE,
			FirstMvpSkillLibrary.FAULTBREAKER_ID, GARRISON_GREATSWORD),
		_package(CharacterState.FoundationPackage.PROJECTILE,
			FirstMvpSkillLibrary.SPLINTER_SHOT_ID, MARROW_BOW),
		_package(CharacterState.FoundationPackage.SPELL,
			FirstMvpSkillLibrary.EMBERBOLT_ID, CANTOR_WAND),
	]


func _package(
	kind: CharacterState.FoundationPackage, skill_id: StringName, weapon_path: String
) -> Dictionary:
	return {
		"package": kind,
		"skill": skills.record(skill_id),
		"weapon": load(weapon_path) as FirstMvpWeaponRecord,
	}


## Grants exactly one package, once per character. The weapon is OWNED, not
## equipped: equipping is a separate deliberate step, exactly as Gate 1D drew
## that line for the Watchsteel Sword.
func choose_foundation_package(package: CharacterState.FoundationPackage) -> bool:
	for entry: Dictionary in foundation_packages():
		if entry["package"] != package:
			continue
		var skill: FirstMvpSkillData = entry["skill"]
		var weapon: FirstMvpWeaponRecord = entry["weapon"]
		if not character.choose_foundation_package(package, skill.skill_id, weapon):
			log_event("foundation cache refused", character.last_refusal)
			return false
		character.bindings.bind(FirstMvpActiveBindings.FOUNDATION_SLOT, skill.skill_id)
		log_event("foundation cache", "%s and %s — the direction explored first, not a class" % [
			skill.display_name, weapon.display_name,
		])
		opening_hud.flash("Learned %s · %s added to your items" % [skill.display_name, weapon.display_name])
		autosave("Foundation Cache: %s" % skill.display_name)
		return true
	return false


## Equips an owned record from the equipment station or the cache. Displaced
## equipment is never destroyed — it stays owned, which is a property of
## `PlayerLoadout.equip()` rather than a rule this function has to remember.
func equip_owned(record: PrototypeWeaponData) -> bool:
	var displaced: PrototypeWeaponData = character.equipment.displaced_by_equipping(record)
	if not character.equipment.equip(record):
		log_event("equip refused", character.equipment.last_refusal)
		return false
	player.equip_weapon(record)
	loadout.pick_up(record)
	loadout.equip(record)
	log_event("equipped", "%s%s" % [
		record.display_name,
		"; %s stays in your items" % displaced.display_name if displaced != null else "",
	])
	autosave("equipped %s" % record.display_name)
	return true


# --- Passives ------------------------------------------------------------------

func allocate_passive(node_id: StringName) -> bool:
	if not character.passives.allocate(node_id):
		log_event("allocation refused", character.passives.last_refusal)
		return false
	_apply_passive_effects()
	log_event("passive allocated", "%s — %s" % [
		character.passives.graph.node(node_id).display_name, character.passives.effects.describe(),
	])
	autosave("allocated %s" % node_id)
	return true


func refund_passive(node_id: StringName) -> bool:
	if not character.passives.refund(node_id):
		log_event("refund refused", character.passives.last_refusal)
		return false
	_apply_passive_effects()
	log_event("passive refunded", "%s — %s" % [
		character.passives.graph.node(node_id).display_name, character.passives.effects.describe(),
	])
	autosave("refunded %s" % node_id)
	return true


## THE ONE PLACE A PASSIVE BECOMES A NUMBER IN THE RUNNING GAME. It writes
## `QuickStrikeAction.increased_attack_speed` through the player's own single
## entry point — the same field Gate E's Quickened Form used and the same one
## every phase, the animation rate and the cancel windows already derive from.
## Nothing new was added to the kernel to make First Fracture work.
func _apply_passive_effects() -> void:
	player.set_increased_attack_speed(character.passives.effects.increased_attack_and_cast_speed)


# --- Save ----------------------------------------------------------------------

## Autosaves after a safe irreversible milestone. Deferred to the end of the
## frame for the D-190 reason: a save taken synchronously inside a reward door
## records a state the door has not finished opening, and the record's own
## validator then correctly refuses to load it.
func autosave(reason: String) -> void:
	last_autosave_reason = reason
	call_deferred("_write_autosave", reason)


func _write_autosave(reason: String) -> void:
	if character_save.save(character):
		autosaves_written += 1
		log_event("autosave", "%s — %s" % [reason, character_save.last_save_status])
	else:
		log_event("autosave refused", character_save.last_save_status)


## THE INHERITED OPENERS ONLY KNOW GATE 1D'S TWO MODALS. `BrokenWatchSlice`
## guards `open_item_comparison()` with `item_comparison.is_open or
## fallen_overlay.is_open`, which cannot see the dialogue, the Origin Ring or
## the Foundation Cache. Overriding the single funnel both the nameplate click
## and the controller interact pass through makes the whole-runtime rule apply
## to Gate 1D's flow too, rather than relying on pause happening to block it.
func open_item_comparison(reason: String) -> void:
	if _any_modal_open():
		return
	_hide_world_nameplates()
	super.open_item_comparison(reason)


# --- Frame ---------------------------------------------------------------------

func _process(delta: float) -> void:
	super._process(delta)
	_refresh_safe_region(player.global_position)
	if anchor != null and not safe_region_active_blocks_anchor():
		anchor.observe(player.global_position)
	_update_mara_nameplate()
	_check_forward_route(player.global_position)


## The Anchor only listens once the character is actually in the Nexus, so a
## stray coordinate during assembly cannot fire the beat early.
func safe_region_active_blocks_anchor() -> bool:
	return not character.has_reached(CharacterState.Milestone.NEXUS_THRESHOLD)


func _update_mara_nameplate() -> void:
	if mara == null or _mara_nameplate == null:
		return
	var camera: Camera3D = camera_rig.camera
	var anchor_point: Vector3 = mara.label_anchor()
	if camera.is_position_behind(anchor_point) or _any_modal_open():
		_mara_nameplate.visible = false
		return
	var screen: Vector2 = camera.unproject_position(anchor_point)
	_mara_nameplate.text = MaraVeyl.DISPLAY_NAME
	_mara_nameplate.position = screen - Vector2(64, 30)
	_mara_nameplate.size = Vector2(128, 28)
	_mara_nameplate.visible = mara.planar_distance_to(player.global_position) < 22.0


## Reaching the closed forward route ENDS the review slice with a restrained
## message. The brief: "Crossing/activating it should stop the current review
## slice with a restrained completion message or boundary." Nothing loads,
## nothing opens, and First Footing is not implemented.
func _check_forward_route(position: Vector3) -> void:
	if first_footing_reached:
		return
	if position.distance_to(rift_nexus.forward_route()) > FORWARD_ROUTE_RANGE:
		return
	first_footing_reached = true
	character.reach(CharacterState.Milestone.READY_FOR_FIRST_FOOTING)
	autosave("reached the First Footing boundary")
	opening_hud.show_boundary(
		"The route into the Crownless Bastion is not open yet.",
		"First Footing is the next milestone. This is where the canonical opening stops."
	)
	log_event("first footing boundary", "reached; nothing loads, opens, or is generated")


# --- Input ---------------------------------------------------------------------

func _unhandled_input(event: InputEvent) -> void:
	# Gate 1E's own interactions are answered FIRST, and only what they do not
	# claim falls through to Gate 1D's proven movement and combat input.
	if event.is_action_pressed(&"interact") and _try_nexus_interaction():
		return
	if event.is_action_pressed(&"quick_strike") and safe_region_active:
		log_event("skill refused", "this is a safe place; no damaging Skill fires here")
		opening_hud.flash("Not here. This place is stable.")
		return
	if _handle_opening_keys(event):
		return
	super._unhandled_input(event)


## The `interact` action is Gate 1D's own pickup control, reused. It offers
## whichever Nexus station the character is standing at, nearest first, and
## returns false when none is in reach so the inherited handler still runs.
func _try_nexus_interaction() -> bool:
	if _any_modal_open():
		return false
	var here: Vector3 = player.global_position
	if mara != null and mara.player_is_in_range(here):
		open_dialogue("interact near Mara")
		return true
	if here.distance_to(rift_nexus.foundation_cache()) <= INTERACTION_RANGE:
		open_foundation_cache("interact at the Foundation Cache")
		return true
	if here.distance_to(rift_nexus.equipment_station()) <= INTERACTION_RANGE:
		# THE EQUIPMENT STATION EQUIPS. It used to open the Passive Web, which
		# left `equip_owned()` with no caller in the running game at all — the
		# Foundation Cache weapon could be granted and then never held, while the
		# Cache's own text promised it "stays equipped until you change it".
		open_equipment("interact at the equipment station")
		return true
	if here.distance_to(rift_nexus.anchor_point()) <= RiftAnchor.RECOGNITION_RADIUS:
		open_origin_ring("interact at the Anchor")
		return true
	return false


## Equips the next owned weapon the character is not already holding. This is a
## deliberately minimal station rather than a Field Pack: the brief excludes the
## inventory interface, and with at most three owned records a cycle is a
## truthful way to reach every one of them without inventing a screen.
##
## Displaced equipment is never destroyed — that is a property of
## `PlayerLoadout.equip()` rather than a rule this function remembers.
func open_equipment(reason: String) -> void:
	if _any_modal_open():
		return
	var owned: Array[PrototypeWeaponData] = character.equipment.owned_items
	if owned.size() <= 1:
		opening_hud.flash("You are carrying nothing else to equip")
		return
	var current: int = owned.find(character.equipment.equipped_weapon)
	var next: PrototypeWeaponData = owned[(maxi(current, 0) + 1) % owned.size()]
	log_event("equipment station", reason)
	if equip_owned(next):
		opening_hud.flash("Equipped %s — %s" % [
			next.display_name, character.equipment.describe_slots(),
		])


## Developer entry points, read as PHYSICAL KEYS. No InputMap action is added:
## Gate E and Gate F each emit one assertion per key event when walking
## `InputMap.get_actions()`, so one new action would silently move two closed
## counts. Gate 1A set this precedent and every gate since has followed it.
##
##   F1  the Origin Ring          F2  the Foundation Cache
##   F9  Start Fresh Opening      F8  save now
##
## START FRESH IS ON F9, NOT F5. `quick_restart` is a REAL bound InputMap action
## on F5 and Gate 1D's `_unhandled_input` acts on it; claiming that key here
## swallowed the inherited Restart and silently deleted the character save
## instead — the most destructive possible outcome for the least expected press.
func _handle_opening_keys(event: InputEvent) -> bool:
	var key: InputEventKey = event as InputEventKey
	if key == null or not key.pressed or key.echo:
		return false
	match key.physical_keycode:
		KEY_F1:
			open_origin_ring("F1")
			return true
		KEY_F2:
			open_foundation_cache("F2")
			return true
		KEY_F9:
			_restart_fresh()
			return true
		KEY_F8:
			autosave("manual save")
			return true
	return false


## Start Fresh Opening. It deletes the saved file AND resets the live character,
## because deleting only the file left the old character in memory and the very
## next autosave wrote it straight back — a Start Fresh that started nothing.
func _restart_fresh() -> void:
	character_save.delete_saved_character()
	character.start_fresh()
	_drop_granted = false
	slice_complete = false
	first_footing_reached = false
	_anchor_recognition_handled = false
	player.equip_weapon(character.equipment.equipped_weapon)
	_apply_passive_effects()
	for enemy: PrototypeGraveblade in graveblades:
		enemy.set_ai_enabled(true)
		enemy.visible = true
		enemy.reset_encounter()
	player.revive_for_testing()
	player.global_position = landing_layout.player_start()
	player.face_instantly(route_forward())
	_refresh_safe_region(player.global_position)
	log_event("start fresh", "the saved file and the live character were both cleared")
	opening_hud.flash("Start Fresh — a new character, back at Riftfall Landing")


# --- Fallen and Restart --------------------------------------------------------

## Gate 1D's Restart returns the bounded slice to a valid state. Gate 1E adds
## the one rule the brief names: "Fallen/Restart does not rewind safe
## irreversible Nexus progression." That is true by construction — progression
## lives on the saved `CharacterState` and this function does not touch it —
## and it is made visible here by refusing to re-enable enemies in a Broken
## Watch the character has already finished.
func restart_current_slice(reason: String) -> void:
	super.restart_current_slice(reason)
	if character.broken_watch_complete or safe_region_active:
		for enemy: PrototypeGraveblade in graveblades:
			enemy.set_ai_enabled(false)
		log_event("restart", "safe progression is untouched; the cleared encounters stay cleared")
	player.equip_weapon(character.equipment.equipped_weapon)
	_apply_passive_effects()


# --- Boundaries ----------------------------------------------------------------

## Extends Gate 1D's own exit check. Reaching Broken Watch's exit now records a
## real milestone on the character instead of only printing a line.
func _check_exit(position: Vector3) -> void:
	var was_complete: bool = slice_complete
	super._check_exit(position)
	if slice_complete and not was_complete:
		if character.complete_broken_watch():
			log_event("milestone", "Broken Watch complete")
			autosave("Broken Watch complete")


func set_grid_visible(value: bool) -> void:
	super.set_grid_visible(value)
	if nexus_threshold != null:
		nexus_threshold.set_grid_visible(value)
	if rift_nexus != null:
		rift_nexus.set_grid_visible(value)


# --- Measurement ---------------------------------------------------------------

func opening_measurements() -> Dictionary:
	var base: Dictionary = measurements()
	base["nexus_threshold_footprint"] = nexus_threshold.footprint_area()
	base["nexus_threshold_cf"] = nexus_threshold.footprint_cf()
	base["nexus_threshold_rooms"] = nexus_threshold.room_count()
	base["rift_nexus_footprint"] = rift_nexus.footprint_area()
	base["rift_nexus_cf"] = rift_nexus.footprint_cf()
	base["rift_nexus_rooms"] = rift_nexus.room_count()
	base["character_level"] = character.level
	base["character_experience"] = character.total_experience
	base["passive_points_earned"] = character.earned_passive_points()
	base["passive_points_available"] = character.available_passive_points()
	base["milestone"] = CharacterState.milestone_name(character.milestone)
	base["safe_region_active"] = safe_region_active
	base["first_footing_reached"] = first_footing_reached
	base["autosaves_written"] = autosaves_written
	base["anchor"] = anchor.measurements() if anchor != null else {}
	return base


## The inherited logger prefixes every line "[broken-watch]", which is honest
## for Gate 1D's own scene and misleading in a composition that is three spaces
## wider than Broken Watch. The prefix — and only the prefix — is replaced.
func log_event(kind: String, detail: String) -> void:
	var line: String = "[opening] %-26s %s" % [kind, detail]
	log_lines.append(line)
	print(line)
