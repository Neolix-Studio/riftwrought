class_name RogueliteExperienceCollectionReview
extends RogueliteCoreLoopRuntime
## Riftwrought — Roguelite Experience Collection Greybox Review V1 (decision D-288).
##
## THE ONE QUESTION THIS SCENE ASKS: does this visible loop read correctly in play?
##
##     kill a real Graveblade -> a visible Experience Mote appears where it fell
##         -> walking into pickup range collects it -> Rift XP rises
##         -> four 25-XP motes reach the 100-XP Level 1 requirement
##         -> "LEVEL-UP READY" appears, and nothing advances on its own
##
## IT STOPS IMMEDIATELY BEFORE THE THREE-CARD OFFER. Nothing here opens, shows,
## chooses or pauses for an offer. Reaching the requirement changes two lines of
## review text and nothing else.
##
##
## IT IS THE ACCEPTED CORE LOOP, WHOLE, WITH ONE LAYER ON TOP
## ---------------------------------------------------------------------------
## The scene INHERITS the accepted core-loop scene and this script EXTENDS its
## runtime. It deliberately does NOT override `_ready()`: every module, the one
## navigation bake, the player, all five Graveblades, both HUDs and every modal
## are assembled by the accepted code, unedited and uncopied. The route, its
## gates, its enemies, their Life and damage, the Expedition Blade, the camera,
## the controls, death, abandonment and the Nexus reset all stay the accepted
## loop's own.
##
## Nine inherited methods are overridden. Eight call the accepted method:
##   * `_build_run_surfaces()` adds the mote-marker root and the review panel;
##   * `_refresh_run_hud()` refreshes the review panel beside the run banner;
##   * `_begin_run()` lets the accepted loop reset and revive everything FIRST,
##     then opens this expedition's one Experience Mote runtime;
##   * `_complete_run()` and `restart_current_slice()` discard that runtime
##     FIRST, then let the accepted reset run;
##   * `_physics_process()` adds the one automatic sweep after the accepted tick;
##   * `_process()` adds the cosmetic collection flash after the accepted tick;
##   * `_handle_review_keys()` adds the one physical review key, F8.
## The ninth, `_maybe_start_verification()`, answers this review's own flag
## instead of the core loop's, so the accepted suite can never start here.
##
##
## ONE RUNTIME PER EXPEDITION, AND NONE IN THE NEXUS (D-287)
## ---------------------------------------------------------------------------
## An expedition begins when the Rift Gate is entered. The accepted loop resets
## and revives every Graveblade; only then is ONE new Foundation H8 runtime made
## from that expedition's exact, complete `plan.seed_value`, and every Graveblade
## of the fixed three-room route — the Elite included — is registered with it,
## each with the one provisional review amount below. Registration happens in the
## same call that revived them, so none of them can have died first.
##
## Only after H8 answers "" for a Graveblade is this review's own presentation
## observer connected to that Graveblade's death — so the observer always sits
## AFTER the binding H8 has just connected, and hears the death second.
##
## The expedition ends by completion, by death (at the Fallen overlay's return to
## the Nexus) or by F5. Every path discards the runtime BEFORE the accepted reset
## runs: every presentation observer is disconnected, every marker node is
## removed, and the runtime is let go — which lets go of every binding and every
## connection it held. No experience, binding, drop, marker or refusal survives.
## No Graveblade is ever freed while its runtime lives: the accepted reset revives
## each one in place, which is exactly D-287's corpse-lifetime rule.
##
##
## THE SWEEP IS H8's, AND ITS ANSWER IS THE ONLY AUTHORITY
## ---------------------------------------------------------------------------
## While an expedition is in progress, the tree is not paused, the player is
## alive and automatic pickup is on, one physics tick asks H8 to sweep at the
## player's own position — and that is the only thing this layer contributes to
## collection. Pickup range, Magnetism, eligibility, Experience Gain, the award
## and the choice of which drops were collected all belong below; nothing here
## measures a distance or adds an amount. A refused sweep or a refused mote is
## written into the review panel, never hidden and never shown as success. The
## Rift level never advances here, no offer is opened and nothing pauses.
##
##
## THE MARKERS ARE MIRRORS, AND A MARKER'S INDEX IS ITS DROP'S INDEX
## ---------------------------------------------------------------------------
## The accepted drops are private and stay private. A marker is appended only
## after the Graveblade's own binding has heard its death and H8 answers, in
## order: that Graveblade is registered, its death was heard, its emission answer
## is "", and the field now holds exactly one more drop than there are markers.
## The marker is placed where THAT Graveblade stands at its death — never where
## the lethal event's attacker or target stands. Because each accepted death
## appends exactly one drop and exactly one marker, in the same order, marker N
## mirrors drop N; the array is only ever appended to and never reordered.
##
## For every index a sweep answer reports collected, exactly that marker flashes
## and hides. Nothing guesses a marker by nearness. A marker has no collision, no
## physics, no pickup rule, no amount and no authority of any kind.
##
##
## A GROUND RING WHERE THE MOTE LIES, AND AN ORB LIFTED ABOVE IT (D-289)
## ---------------------------------------------------------------------------
## Each marker is one entry, at its drop's index, with two parts. The ring is
## centred exactly on the logical death position's X and Z and raised only
## `MOTE_RING_FLOOR_OFFSET` above it, so it never z-fights the floor: it shows
## where the mote lies mechanically. The orb floats `MOTE_ORB_REVIEW_HEIGHT`
## straight above the same logical position, so the corpse the run keeps never
## swallows it or reads as part of it. That height is one fixed review-only
## presentation value: nothing reads the player, the camera, a room, a gate or a
## direction to place either part, and neither part moves once it appears. The
## logical drop is untouched — it stays at the complete death position H7 read,
## pickup is still measured to it on the ground plane, and H5's indices are what
## they were. The collection flash swells each part about its own centre, so it
## happens at the lifted orb.
##
## A MOTE LEFT BEHIND STAYS UNTIL TEARDOWN (D-289). Walking through a Rift Gate
## past an uncollected mote leaves its drop uncollected at its index, its marker
## in the room it fell in, and its experience unawarded; the panel keeps counting
## it. Completion, death or F5 removes it with the whole runtime.
##
##
## F8 — AUTOMATIC MOTE PICKUP ON/OFF (REVIEW INSTRUMENTATION)
## ---------------------------------------------------------------------------
## A PHYSICAL key, read here exactly as the core loop reads F6. No InputMap action
## is added. Default ON. When OFF, no sweep happens at all, so real drops and
## their markers simply stay where they fell while the accepted loop carries on.
##
## WHAT IT DOES NOT DO. No offer card, offer opening or choice; no pause on a
## level-up; no Passive or Support effect; no mote movement, attraction or
## homing; no final effect or sound; no Elite-specific amount; no other enemy
## family; no corpse cleanup; no rounds; no saving; nothing written anywhere.
##
## Run it with Run Current Scene — never Run Project — or:
##   godot --path game res://scenes/roguelite/roguelite_experience_collection_review.tscn -- --seed 99

const REVIEW_VERIFICATION_SCRIPT: String = "res://tests/roguelite_experience_collection_review_verification.gd"
const EXPERIENCE_HUD_SCRIPT: String = "res://scripts/roguelite/experience/roguelite_experience_review_hud.gd"

## THE ONE EXPERIENCE AMOUNT, AND IT IS A PROVISIONAL GREYBOX REVIEW VALUE — NOT
## FINAL BALANCE. Every Graveblade in the fixed route, the Elite included, is
## registered with exactly this amount, so four collected motes land exactly on
## the Level 1 requirement. It is deliberately NOT read from the Graveblade's own
## record, whose experience field belongs to Prototype Zero and stays untouched.
const GREYBOX_REVIEW_BASE_EXPERIENCE: float = 25.0

## The cosmetic collection flash — a PROVISIONAL REVIEW VALUE (D-289 ruling 5),
## not final effect timing. The drop is collected and its experience awarded the
## instant the sweep answer says so; this only decides how long the marker takes
## to fade.
const COLLECTION_FLASH_SECONDS: float = 0.32
const FLASH_GROWTH: float = 0.5

## THE ORB'S REVIEW HEIGHT (D-289 ruling 1): how far the orb's centre floats
## straight above the logical death position. A review-only presentation value —
## it lifts the icon clear of the retained corpse and changes nothing a sweep
## measures.
const MOTE_ORB_REVIEW_HEIGHT: float = 0.70

## How far the ground ring sits above the logical death position: only enough to
## keep it from z-fighting the floor.
const MOTE_RING_FLOOR_OFFSET: float = 0.025

## A small orb over a thin ground ring — narrower than the player's shoulders and
## well under their height, so it reads from the accepted camera without ever
## becoming the largest thing near the player.
const MOTE_ORB_RADIUS: float = 0.17
const MOTE_RING_INNER_RADIUS: float = 0.30
const MOTE_RING_OUTER_RADIUS: float = 0.40
const MOTE_ORB_COLOUR: Color = Color(0.72, 0.50, 1.00)
const MOTE_RING_COLOUR: Color = Color(0.40, 0.86, 1.00, 0.85)
const MOTE_FLASH_COLOUR: Color = Color(0.96, 0.91, 1.00)

## The top of the canonical player-visible run-seed domain (D-266 ruling 2).
const CANONICAL_SEED_CEILING: int = 0xFFFFFFFF


## One presentation-only mirror of one accepted drop: where that drop was made,
## and whether a sweep answer has reported it collected. Never an amount, a
## range, a collision shape or any other gameplay fact.
class MoteMarker:
	var node: Node3D
	var orb: MeshInstance3D
	var ring: MeshInstance3D
	var drop_position: Vector3 = Vector3.ZERO
	var enemy_name: String = ""
	var collected: bool = false
	var flash_left: float = 0.0


## This expedition's Experience Mote runtime (Foundation H8), or null — always
## null in the Nexus. Exactly one exists while an expedition is in progress.
var mote_runtime: RiftMoteRuntime = null

## F8. Review instrumentation, not a player control.
var automatic_pickup: bool = true

var experience_hud: RogueliteExperienceReviewHud
var mote_marker_root: Node3D

## Review instrumentation, read by the panel's log lines and the verification.
var runtimes_created: int = 0
var runtimes_discarded: int = 0
var sweeps_made: int = 0
var whole_sweep_refusals: int = 0
var item_refusals_seen: int = 0
var markers_created: int = 0
var markers_collected: int = 0
var registration_refusals: int = 0
var mirror_refusals: int = 0
var stale_callbacks_refused: int = 0
var last_sweep_position: Vector3 = Vector3.ZERO
var last_sweep_result: RiftMoteSweepResult = null
## The last automatic sweep whose answer collected anything, and where it was
## made. Every tick sweeps, so the sweep after a collection already reports the
## drop as skipped; these keep the one that actually collected.
var collecting_sweeps: int = 0
var last_collection_position: Vector3 = Vector3.ZERO
var last_collection_result: RiftMoteSweepResult = null
var last_refusal: String = ""

var _markers: Array[MoteMarker] = []

## The Graveblades this expedition observes and the exact callables connected to
## their deaths, index for index, so each can be disconnected by the very value
## that was connected. Untyped on purpose: a typed read of a freed entry raises.
var _observed_enemies: Array = []
var _observers: Array[Callable] = []

## Increases once per expedition and is bound into every observer, so a death
## heard for an expedition that has already ended is refused by value.
var _expedition_serial: int = 0


# --- Assembly: the accepted surfaces, then this review's two ----------------

func _build_run_surfaces() -> void:
	super()
	mote_marker_root = Node3D.new()
	mote_marker_root.name = "ExperienceMoteMarkers"
	add_child(mote_marker_root)

	experience_hud = (load(EXPERIENCE_HUD_SCRIPT) as GDScript).new() as RogueliteExperienceReviewHud
	experience_hud.name = "ExperienceReviewHud"
	$CanvasLayer.add_child(experience_hud)
	## Directly after the run banner and BEFORE every modal: a CanvasLayer draws
	## its children in order, so the panel sits beneath each modal's backdrop.
	$CanvasLayer.move_child(experience_hud, run_hud.get_index() + 1)
	experience_hud.bind_review(self)
	log_event("experience review", "greybox review layer assembled on the accepted loop; no runtime exists in the Nexus")


func _refresh_run_hud() -> void:
	super()
	if experience_hud != null:
		experience_hud.refresh()


# --- The expedition lifecycle -------------------------------------------------

func _begin_run(reason: String) -> void:
	_discard_mote_runtime("a new expedition begins")
	super(reason)
	_open_mote_runtime()


func _complete_run() -> void:
	_discard_mote_runtime("expedition complete")
	super()


func restart_current_slice(reason: String) -> void:
	_discard_mote_runtime(reason)
	super(reason)


## One new runtime from this expedition's exact seed, then every Graveblade of
## the fixed route registered with the one review amount, each observed only
## after its registration was accepted.
func _open_mote_runtime() -> void:
	mote_runtime = RiftMoteRuntime.new(run_state.plan.seed_value)
	runtimes_created += 1
	_expedition_serial += 1
	var participants: int = 0
	for group: Array in room_enemies:
		for enemy: PrototypeGraveblade in group:
			participants += 1
			var refusal: String = mote_runtime.register_graveblade(enemy, GREYBOX_REVIEW_BASE_EXPERIENCE)
			if not refusal.is_empty():
				registration_refusals += 1
				_note_refusal("registration refused", "%s — %s" % [enemy.name, refusal])
				continue
			var observer: Callable = _on_registered_enemy_died.bind(enemy, _expedition_serial)
			enemy.died.connect(observer)
			_observed_enemies.append(enemy)
			_observers.append(observer)
	log_event("experience runtime", "opened for run seed %s; %d of %d Graveblade(s) registered at %.1f each — a provisional greybox review value" % [
		seed_presentation(mote_runtime.run_seed()), mote_runtime.binding_count(), participants,
		GREYBOX_REVIEW_BASE_EXPERIENCE,
	])
	_refresh_run_hud()


## Lets the whole expedition's Experience Mote state go: observers first, then
## the runtime (and with it every binding and connection), then every marker.
func _discard_mote_runtime(reason: String) -> void:
	if mote_runtime == null and _markers.is_empty() and _observers.is_empty():
		return
	for index: int in _observers.size():
		var entry: Variant = _observed_enemies[index]
		if not is_instance_valid(entry):
			continue
		var enemy: PrototypeGraveblade = entry as PrototypeGraveblade
		if enemy.died.is_connected(_observers[index]):
			enemy.died.disconnect(_observers[index])
	_observers.clear()
	_observed_enemies.clear()
	if mote_runtime != null:
		runtimes_discarded += 1
	mote_runtime = null
	var removed: int = _markers.size()
	for marker: MoteMarker in _markers:
		mote_marker_root.remove_child(marker.node)
		marker.node.queue_free()
	_markers.clear()
	last_sweep_result = null
	last_collection_result = null
	last_refusal = ""
	log_event("experience runtime", "discarded (%s): %d marker(s) removed; no experience, binding, drop or marker is kept" % [
		reason, removed,
	])
	_refresh_run_hud()


# --- Hearing a death, second -------------------------------------------------

## Connected only after the Graveblade's registration was accepted, so its
## binding has already heard this same death. The event is read for nothing.
func _on_registered_enemy_died(_event: DamageEvent, enemy: PrototypeGraveblade, serial: int) -> void:
	if mote_runtime == null or serial != _expedition_serial:
		stale_callbacks_refused += 1
		_note_refusal("stale death ignored", "%s died for an expedition that has already ended; no marker" % enemy.name)
		return
	if not mote_runtime.is_registered(enemy) or not mote_runtime.has_observed_death(enemy):
		mirror_refusals += 1
		_note_refusal("no marker", "%s's death was not heard by its binding first" % enemy.name)
		return
	var answer: String = mote_runtime.emission_answer(enemy)
	if not answer.is_empty():
		_note_refusal("emission refused", "%s — %s" % [enemy.name, answer])
		return
	if mote_runtime.drop_count() != _markers.size() + 1:
		mirror_refusals += 1
		_note_refusal("no marker", "the field holds %d drop(s) against %d marker(s), so a new marker could not mirror its drop" % [
			mote_runtime.drop_count(), _markers.size(),
		])
		return
	_append_marker(enemy.global_position, enemy.name)


func _append_marker(at: Vector3, enemy_name: String) -> void:
	var marker: MoteMarker = MoteMarker.new()
	marker.drop_position = at
	marker.enemy_name = enemy_name
	marker.node = Node3D.new()
	marker.node.name = "Mote%02d" % _markers.size()
	## The entry stands on the complete logical death position; its two parts are
	## fixed straight above it (D-289).
	marker.node.position = at
	marker.orb = _mote_mesh("Orb", _orb_mesh(), Vector3(0.0, MOTE_ORB_REVIEW_HEIGHT, 0.0), MOTE_ORB_COLOUR)
	marker.ring = _mote_mesh("Ring", _ring_mesh(), Vector3(0.0, MOTE_RING_FLOOR_OFFSET, 0.0), MOTE_RING_COLOUR)
	marker.node.add_child(marker.orb)
	marker.node.add_child(marker.ring)
	mote_marker_root.add_child(marker.node)
	_markers.append(marker)
	markers_created += 1
	log_event("experience mote", "drop %d appeared where %s fell, at (%.2f, %.2f)" % [
		_markers.size() - 1, enemy_name, at.x, at.z,
	])
	_refresh_run_hud()


# --- The automatic sweep, and presenting its answer ---------------------------

func _physics_process(delta: float) -> void:
	super(delta)
	_sweep_automatically()


func _sweep_automatically() -> void:
	if mote_runtime == null or not automatic_pickup:
		return
	## A fallen player sweeps nothing (D-289 ruling 2): experience collected during
	## the Fallen delay would be deleted by the reset a moment later.
	if loop_state != LoopState.IN_RUN or get_tree().paused or not player.is_alive():
		return
	var at: Vector3 = player.global_position
	var answer: RiftMoteSweepResult = mote_runtime.sweep_at(at)
	sweeps_made += 1
	last_sweep_position = at
	if answer.ok and answer.collected_count() > 0:
		collecting_sweeps += 1
		last_collection_position = at
		last_collection_result = answer
	_present_sweep(answer)


## Shows one sweep answer exactly as it came back. `ok` is asked first; a refusal
## is written into the review panel; every collected index hides exactly its own
## marker and no other.
func _present_sweep(answer: RiftMoteSweepResult) -> void:
	last_sweep_result = answer
	if not answer.ok:
		whole_sweep_refusals += 1
		_note_refusal("sweep refused", answer.failure_reason)
		_refresh_run_hud()
		return
	if answer.item_refusal_count > 0:
		item_refusals_seen += answer.item_refusal_count
		_note_refusal("mote refused", answer.first_item_refusal_reason)
	var collected: PackedInt32Array = answer.collected_indices()
	for index: int in collected:
		_mark_collected(index)
	if not collected.is_empty() and mote_runtime != null:
		log_event("experience collected", "drop(s) %s; Rift XP %s at level %d" % [
			str(collected), str(mote_runtime.experience()), mote_runtime.level(),
		])
	if not collected.is_empty() or answer.item_refusal_count > 0:
		_refresh_run_hud()


func _mark_collected(index: int) -> void:
	if index < 0 or index >= _markers.size():
		mirror_refusals += 1
		_note_refusal("no marker hidden", "the sweep collected drop %d and only %d marker(s) mirror the field" % [
			index, _markers.size(),
		])
		return
	var marker: MoteMarker = _markers[index]
	if marker.collected:
		mirror_refusals += 1
		_note_refusal("no marker hidden", "drop %d is already shown collected" % index)
		return
	marker.collected = true
	marker.flash_left = COLLECTION_FLASH_SECONDS
	_tint(marker, MOTE_FLASH_COLOUR, 1.0)
	markers_collected += 1


func _process(delta: float) -> void:
	super(delta)
	_tick_collection_flashes(delta)


## The cosmetic fade of a marker that is ALREADY collected: it brightens, swells
## a little, fades, and is hidden. Each part swells about its OWN centre — the
## orb where it floats, the ring where it lies — so the flash happens at the
## lifted orb, and nothing moves or travels.
func _tick_collection_flashes(delta: float) -> void:
	for marker: MoteMarker in _markers:
		if marker.flash_left <= 0.0:
			continue
		marker.flash_left = maxf(marker.flash_left - delta, 0.0)
		var progress: float = 1.0 - marker.flash_left / COLLECTION_FLASH_SECONDS
		var swell: Vector3 = Vector3.ONE * (1.0 + FLASH_GROWTH * progress)
		marker.orb.scale = swell
		marker.ring.scale = swell
		_tint(marker, MOTE_FLASH_COLOUR, 1.0 - progress)
		if marker.flash_left <= 0.0:
			marker.node.visible = false


# --- F8 -------------------------------------------------------------------------

func _handle_review_keys(event: InputEvent) -> void:
	super(event)
	var key: InputEventKey = event as InputEventKey
	if key == null or not key.pressed or key.echo or key.physical_keycode != KEY_F8:
		return
	set_automatic_pickup(not automatic_pickup)


func set_automatic_pickup(value: bool) -> void:
	automatic_pickup = value
	log_event("review pickup", "automatic Experience Mote pickup %s" % ("ON" if value else "OFF"))
	_refresh_run_hud()


# --- Readings for the review panel ----------------------------------------------

## Plain scalars only. The panel formats them and names no foundation class.
func experience_review_reading() -> Dictionary:
	var reading: Dictionary = {
		"active": mote_runtime != null,
		"seed_label": "Run seed" if mote_runtime != null else "Next run seed",
		"seed": seed_presentation(run_state.plan.seed_value if mote_runtime != null else plan.seed_value),
		"automatic_pickup": automatic_pickup,
		"last_refusal": last_refusal,
	}
	if mote_runtime == null:
		return reading
	var level: int = mote_runtime.level()
	var experience: float = mote_runtime.experience()
	var requirement: RiftLevelRequirementReading = RiftLevelRequirementCurve.requirement_for(level)
	reading["level"] = level
	reading["experience"] = experience
	reading["requirement_ok"] = requirement.ok
	reading["requirement"] = requirement.requirement
	reading["requirement_refusal"] = requirement.failure_reason
	reading["level_up_ready"] = requirement.ok and experience >= requirement.experience_requirement()
	reading["offer_active"] = mote_runtime.is_offer_active()
	reading["registered"] = mote_runtime.binding_count()
	reading["drops"] = mote_runtime.drop_count()
	reading["uncollected"] = mote_runtime.uncollected_count()
	reading["collected"] = mote_runtime.collected_count()
	return reading


## D-266 ruling 2: a seed inside the canonical domain is shown as zero-padded
## eight-digit hexadecimal. Any other seed is shown whole, in decimal, and says so,
## because masking it would show a different run's seed.
static func seed_presentation(value: int) -> String:
	if value >= 0 and value <= CANONICAL_SEED_CEILING:
		return "%08X" % value
	return "%d — outside the canonical 00000000–FFFFFFFF domain" % value


# --- Readings for the verification and the evidence frames -------------------------

func marker_count() -> int:
	return _markers.size()


func marker_drop_position(index: int) -> Vector3:
	return _markers[index].drop_position


func marker_is_collected(index: int) -> bool:
	return _markers[index].collected


func marker_is_shown(index: int) -> bool:
	return _markers[index].node.visible


func marker_is_flashing(index: int) -> bool:
	return _markers[index].flash_left > 0.0


func marker_node(index: int) -> Node3D:
	return _markers[index].node


## Where marker `index`'s orb and ring are drawn, in the world — presentation
## readings of the review's own record, never of a drop.
func marker_orb_position(index: int) -> Vector3:
	return _markers[index].orb.global_position


func marker_ring_position(index: int) -> Vector3:
	return _markers[index].ring.global_position


func marker_orb_local_position(index: int) -> Vector3:
	return _markers[index].orb.position


func marker_ring_local_position(index: int) -> Vector3:
	return _markers[index].ring.position


func marker_orb_scale(index: int) -> float:
	return _markers[index].orb.scale.x


func marker_orb_colour(index: int) -> Color:
	return (_markers[index].orb.material_override as StandardMaterial3D).albedo_color


func observer_count() -> int:
	return _observers.size()


# --- Diagnostics and greybox builders ---------------------------------------------

func _note_refusal(kind: String, detail: String) -> void:
	var text: String = "%s — %s" % [kind, detail]
	if text != last_refusal:
		log_event("experience refusal", text)
	last_refusal = text


func _orb_mesh() -> SphereMesh:
	var mesh: SphereMesh = SphereMesh.new()
	mesh.radius = MOTE_ORB_RADIUS
	mesh.height = MOTE_ORB_RADIUS * 2.0
	mesh.radial_segments = 16
	mesh.rings = 8
	return mesh


func _ring_mesh() -> TorusMesh:
	var mesh: TorusMesh = TorusMesh.new()
	mesh.inner_radius = MOTE_RING_INNER_RADIUS
	mesh.outer_radius = MOTE_RING_OUTER_RADIUS
	mesh.rings = 32
	mesh.ring_segments = 6
	return mesh


func _mote_mesh(node_name: String, mesh: Mesh, at: Vector3, colour: Color) -> MeshInstance3D:
	var instance: MeshInstance3D = MeshInstance3D.new()
	instance.name = node_name
	instance.mesh = mesh
	instance.position = at
	instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	var material: StandardMaterial3D = StandardMaterial3D.new()
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	material.albedo_color = colour
	instance.material_override = material
	return instance


func _tint(marker: MoteMarker, colour: Color, alpha: float) -> void:
	for instance: MeshInstance3D in [marker.orb, marker.ring]:
		(instance.material_override as StandardMaterial3D).albedo_color = Color(colour.r, colour.g, colour.b, alpha)


# --- This review's own verification ------------------------------------------------

## Replaces the core loop's flag, so its accepted suite can never start in this
## scene and this review's suite has its own.
func _maybe_start_verification() -> void:
	var arguments: PackedStringArray = OS.get_cmdline_user_args()
	if not arguments.has("--verify-experience"):
		return
	var script: GDScript = load(REVIEW_VERIFICATION_SCRIPT) as GDScript
	var runner: Node = Node.new()
	runner.name = "RogueliteExperienceCollectionReviewVerification"
	runner.set_script(script)
	runner.set("review", self)
	runner.set("arguments", arguments)
	add_child(runner)
