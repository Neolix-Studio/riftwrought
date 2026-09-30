class_name PrototypeCombatFeedback
extends Node3D
## Prototype Zero — Gate F: the synchronized combat feedback layer
## (specification §18, decision D-189).
##
## Specification §18 lists nine things an ordinary successful player Hit needs,
## and this file is where eight of them are fired FROM ONE PLACE on ONE FRAME so
## they cannot drift apart:
##
##   visible release pose          already Gate C's marker-driven pose
##   short weapon trail            `_show_swing_trail()`
##   Physical contact effect       `_show_impact()` — slash plane + shock ring
##   bone/material impact sound    `impact_bone_ordinary` / `_improved`
##   brief enemy material flash    `MediumRigVisual.set_impact_flash()`
##   restrained visual recoil      a short push on the target's visual root
##   immediate enemy Life response already Gate D's life bar, on the same frame
##   optional damage number        the HUD, and only when the setting is On
##   small capped camera impulse   `PrototypeCameraRig.add_impulse()`
##
## THE POINT OF PUTTING THEM TOGETHER is that §18 also says the feedback "must
## not repeatedly pause world simulation or lose input". Nothing here touches the
## simulation: no `Engine.time_scale`, no hit-stop, no input suppression, no
## timer that any mechanic waits on. Every effect is presentation that decays on
## its own, and removing all of it would change no measured value in Gates A-E.
##
## THE IMPROVED HIT IS THE SAME GRAMMAR, LOUDER (specification §18: "The Honed
## Sword uses the same core grammar with a slightly stronger impact layer. It
## must not masquerade as a new elemental effect.") So `improved` changes four
## scalars — impact scale, flash strength, camera impulse, recoil — and swaps to
## the heavier cue family. It changes no COLOUR, adds no particle family, adds no
## ring, and adds no glow. A Physical Hit stays Physical.
##
## EVERY PRESENTATION CHANNEL IS REDUCIBLE. `screen_shake`, `bright_flashes`, and
## `vibration` each scale their channel by 1.00 / 0.40 / 0.00, and Off is exactly
## zero rather than small. With all three Off and damage numbers Off, what is
## left is the release pose, the trail, the contact effect, the Life bar, the
## enemy's recoil, and the SOUND — which is the combination §26 asks the project
## owner to judge.

## §18 "a small capped camera impulse". Severities, before the player's shake
## setting scales them. They are deliberately ordered, and the order is the
## readability: taking damage outranks landing one.
const IMPULSE_HIT_ORDINARY: float = 0.42
const IMPULSE_HIT_IMPROVED: float = 0.62
const IMPULSE_KILL: float = 0.75
const IMPULSE_PLAYER_DAMAGE: float = 1.00

## Flash strengths, before the bright-flash setting scales them.
const FLASH_HIT_ORDINARY: float = 0.55
const FLASH_HIT_IMPROVED: float = 0.75
const FLASH_PLAYER_DAMAGE: float = 0.70
## How fast a material flash falls away, in flash units per second. Fast enough
## that a 0.64-second attack cycle never leaves a body still lit.
const FLASH_DECAY: float = 6.5

## §18 "restrained visual recoil": how far a struck body's VISUAL root is pushed,
## in metres. The body itself never moves — recoiling the collider would change
## reach, navigation, and the Graveblade's own holding distance.
const RECOIL_ORDINARY: float = 0.10
const RECOIL_IMPROVED: float = 0.15
const RECOIL_RETURN: float = 7.0

## Controller rumble, before the vibration setting scales it.
const RUMBLE_HIT: float = 0.22
const RUMBLE_PLAYER_DAMAGE: float = 0.60
const RUMBLE_SECONDS: float = 0.14

## How far the player walks between footstep cues, in metres. Measured against
## the KayKit `Running_A` cycle at the D-175 5.0 m/s maximum speed.
const STRIDE_METRES: float = 1.55

## Wroughtstone-adjacent, and anchored to the palette the whole prototype already
## uses. Physical impact is bone-white into copper: it is not an element.
const IMPACT_CORE: Color = Color(1.00, 0.94, 0.82)
const IMPACT_EDGE: Color = Color(0.92, 0.66, 0.34)
const TRAIL_COLOUR: Color = Color(0.88, 0.90, 0.94)
const DUST_COLOUR: Color = Color(0.72, 0.68, 0.58)

const EFFECT_SECONDS: float = 0.26
const TRAIL_SECONDS: float = 0.14

var room: Node
var settings: PrototypeSettings
var audio: PrototypeAudioDirector
var hud: Node

# --- Instrumentation (specification §22) -------------------------------------
var hits_shown: int = 0
var improved_hits_shown: int = 0
var kills_shown: int = 0
var player_damage_shown: int = 0
var trails_shown: int = 0
var footsteps: int = 0
var numbers_shown: int = 0
var numbers_suppressed: int = 0
var rumbles: int = 0
var last_event: String = "none"
## The largest camera impulse this session actually asked for, after scaling.
var largest_impulse_requested: float = 0.0

var _trail: MeshInstance3D
var _trail_left: float = 0.0
var _effects: Array[Dictionary] = []
var _flashes: Array[Dictionary] = []
var _recoils: Array[Dictionary] = []
var _walked: float = 0.0
var _previous_player_position: Vector3 = Vector3.ZERO
## Per-Graveblade last observed state, so the anticipation and commit cues can be
## fired by OBSERVING the enemy rather than by editing it. D-184 requires the
## Graveblade to be reused unchanged and Gate D asserts that by member name; this
## keeps Gate F on the same side of that line.
var _enemy_states: Dictionary = {}
var _rumble_left: float = 0.0


func _ready() -> void:
	_trail = MeshInstance3D.new()
	_trail.name = "SwingTrail"
	_trail.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	add_child(_trail)


func bind(owner_room: Node) -> void:
	room = owner_room
	_previous_player_position = (owner_room.get("player") as Node3D).global_position


func configure(store: PrototypeSettings, director: PrototypeAudioDirector, hud_node: Node) -> void:
	settings = store
	audio = director
	hud = hud_node


# --- Settings-scaled channels ------------------------------------------------

func shake_scale() -> float:
	return settings.shake_scale() if settings != null else 1.0


func flash_scale() -> float:
	return settings.flash_scale() if settings != null else 1.0


func vibration_scale() -> float:
	return settings.vibration_scale() if settings != null else 1.0


func damage_numbers_on() -> bool:
	return settings.damage_numbers if settings != null else true


func cue(family: String) -> void:
	if audio != null:
		audio.play(family)


# --- The player's Hit --------------------------------------------------------

## Everything §18 requires for one ordinary successful Hit, fired together.
## `improved` is the Honed Sword: the SAME grammar, four scalars larger, and the
## heavier cue family. No new colour and no new effect.
func show_player_hit(at: Vector3, direction: Vector3, target: Node, improved: bool) -> void:
	hits_shown += 1
	if improved:
		improved_hits_shown += 1
	last_event = "player hit (%s)" % ("improved" if improved else "ordinary")

	var contact: Vector3 = at + Vector3(0.0, 1.05, 0.0)
	_show_impact(contact, direction, 1.30 if improved else 1.00)
	_flash_body(target, (FLASH_HIT_IMPROVED if improved else FLASH_HIT_ORDINARY) * flash_scale())
	_recoil_body(target, direction, RECOIL_IMPROVED if improved else RECOIL_ORDINARY)
	_impulse(IMPULSE_HIT_IMPROVED if improved else IMPULSE_HIT_ORDINARY, direction)
	_rumble(RUMBLE_HIT * (1.25 if improved else 1.0))
	cue("impact_bone_improved" if improved else "impact_bone_ordinary")


## The swing itself, whether or not it connected. §18: "short weapon trail or
## release flash". It is drawn on every release, so a miss is still a swing.
func show_player_release(origin: Vector3, facing: Vector3, reach: float, arc_degrees: float) -> void:
	trails_shown += 1
	_show_swing_trail(origin, facing, reach, arc_degrees)
	cue("quick_strike_release")


func show_player_commitment() -> void:
	cue("quick_strike_commit")


## §18: a kill needs "immediate threat removal, distinct bone collapse/death
## response, XP response at once, the first guaranteed drop at once, no delay for
## the decorative death animation". The first, third, and fourth are Gate D and
## Gate E and already happen on the lethal frame; this is the collapse.
func show_kill(at: Vector3, direction: Vector3) -> void:
	kills_shown += 1
	last_event = "kill"
	_show_dust(at + Vector3(0.0, 0.55, 0.0), 1.0)
	_impulse(IMPULSE_KILL, direction)
	cue("graveblade_death")


func show_player_damaged(at: Vector3, from: Vector3, target: Node) -> void:
	player_damage_shown += 1
	last_event = "player damaged"
	var direction: Vector3 = Vector3(at.x - from.x, 0.0, at.z - from.z)
	if direction.length() < 0.0001:
		direction = Vector3.FORWARD
	_show_impact(at + Vector3(0.0, 1.05, 0.0), direction.normalized(), 1.15)
	_flash_body(target, FLASH_PLAYER_DAMAGE * flash_scale(), Color(1.0, 0.55, 0.48))
	_impulse(IMPULSE_PLAYER_DAMAGE, direction.normalized())
	_rumble(RUMBLE_PLAYER_DAMAGE)
	cue("player_damage")


func show_fallen() -> void:
	last_event = "fallen"
	cue("fallen")


func show_graveblade_release(at: Vector3, direction: Vector3) -> void:
	_show_swing_trail(at, direction, 1.65, 90.0, 0.55)
	cue("graveblade_release")


# --- Damage numbers ----------------------------------------------------------

## §17: "optional damage numbers, default On but immediately switchable Off".
##
## When they are Off the number is not drawn AND NOTHING ELSE CHANGES: the Hit,
## the DamageEvent, the Life change, the flash, the impact, the recoil, the
## camera impulse, and the sound all still happen. The suppression is counted, so
## "Off suppressed the number and only the number" is a measured fact.
func request_damage_number(at: Vector3, amount: float, kind: String) -> bool:
	if not damage_numbers_on():
		numbers_suppressed += 1
		return false
	if hud == null or not hud.has_method("show_damage_number"):
		numbers_suppressed += 1
		return false
	hud.call("show_damage_number", at, amount, kind)
	numbers_shown += 1
	return true


# --- Per-frame ---------------------------------------------------------------

func _process(delta: float) -> void:
	_tick_effects(delta)
	_tick_flashes(delta)
	_tick_recoils(delta)
	_tick_trail(delta)
	_tick_rumble(delta)
	if room == null:
		return
	_tick_footsteps(delta)
	_watch_graveblades()


func _tick_footsteps(_delta: float) -> void:
	var player: Node3D = room.get("player") as Node3D
	if player == null:
		return
	var now: Vector3 = player.global_position
	_walked += Vector2(now.x - _previous_player_position.x, now.z - _previous_player_position.z).length()
	_previous_player_position = now
	if _walked < STRIDE_METRES:
		return
	_walked = 0.0
	# Standing still must not tick: the accumulator only grows when the body
	# actually moves, and the audio director's own rate limit is the second guard.
	if player.has_method("planar_speed") and float(player.call("planar_speed")) < 0.3:
		return
	footsteps += 1
	cue("footstep")


## Fires the Graveblade's anticipation and release feedback by WATCHING its
## state rather than by adding a signal to it. D-184 requires the Graveblade to
## be "reused unchanged" and Gate D asserts that by member name; observing costs
## at most one frame of latency and costs the enemy nothing.
func _watch_graveblades() -> void:
	var roster: Array = room.get("graveblades") as Array
	if roster == null:
		return
	for enemy: Node in roster:
		if not is_instance_valid(enemy):
			continue
		var key: int = enemy.get_instance_id()
		var state: int = int(enemy.get("state"))
		var previous: int = int(_enemy_states.get(key, -1))
		if state != previous:
			_enemy_states[key] = state
			if state == PrototypeGraveblade.State.ATTACK_WINDUP:
				cue("graveblade_anticipation")


# --- Effects -----------------------------------------------------------------

## §18 "Physical contact effect at the target". The Physical vocabulary in
## `design/ASSET_VISUAL_PRODUCTION_RULES.md` §12 is "impact shockwaves, dust,
## slashes, debris, metallic sparks" — so a slash plane along the swing and one
## expanding shock shell, in bone-white and copper. No element, no colour that
## could be read as one.
func _show_impact(at: Vector3, direction: Vector3, scale: float) -> void:
	var brightness: float = clampf(0.35 + 0.65 * flash_scale(), 0.35, 1.0)

	var slash: MeshInstance3D = _spawn_effect(at, EFFECT_SECONDS, 0.55 * scale, 2.6 * scale)
	var slash_mesh: QuadMesh = QuadMesh.new()
	slash_mesh.size = Vector2(1.0, 0.16)
	slash.mesh = slash_mesh
	slash.material_override = _additive(IMPACT_CORE, brightness)
	slash.rotation.y = atan2(direction.x, direction.z) + PI * 0.5
	slash.rotation.z = deg_to_rad(-18.0)

	var shell: MeshInstance3D = _spawn_effect(at, EFFECT_SECONDS * 0.8, 0.18 * scale, 1.5 * scale)
	var shell_mesh: SphereMesh = SphereMesh.new()
	shell_mesh.radius = 0.5
	shell_mesh.height = 1.0
	shell_mesh.radial_segments = 12
	shell_mesh.rings = 6
	shell.mesh = shell_mesh
	shell.material_override = _additive(IMPACT_EDGE, brightness * 0.75)


func _show_dust(at: Vector3, scale: float) -> void:
	var dust: MeshInstance3D = _spawn_effect(at, EFFECT_SECONDS * 2.2, 0.5 * scale, 2.2 * scale)
	var mesh: SphereMesh = SphereMesh.new()
	mesh.radius = 0.5
	mesh.height = 0.7
	mesh.radial_segments = 12
	mesh.rings = 5
	dust.mesh = mesh
	dust.material_override = _additive(DUST_COLOUR, 0.30 + 0.30 * flash_scale())


## §18 "short weapon trail". A thin arc ribbon along the swing, at hand height,
## gone in 0.14 s. It is drawn on EVERY release, so a genuine miss still shows
## the swing that missed.
func _show_swing_trail(
	origin: Vector3, facing: Vector3, radius: float, arc_degrees: float, opacity: float = 1.0
) -> void:
	var mesh: ImmediateMesh = ImmediateMesh.new()
	var material: StandardMaterial3D = _additive(
		TRAIL_COLOUR, (0.30 + 0.50 * flash_scale()) * opacity
	)
	material.vertex_color_use_as_albedo = true
	mesh.surface_begin(Mesh.PRIMITIVE_TRIANGLE_STRIP, material)
	var centre: float = atan2(facing.x, facing.z)
	var half: float = deg_to_rad(arc_degrees * 0.5)
	var steps: int = 16
	for i: int in steps + 1:
		var progress: float = float(i) / float(steps)
		var angle: float = centre - half + 2.0 * half * progress
		# The ribbon thins toward the trailing edge, which is what makes it read
		# as a moving blade rather than as a static fan.
		var fade: float = pow(progress, 0.7)
		mesh.surface_set_color(Color(TRAIL_COLOUR.r, TRAIL_COLOUR.g, TRAIL_COLOUR.b, fade))
		mesh.surface_add_vertex(Vector3(
			origin.x + sin(angle) * radius * 0.60, origin.y + 1.02,
			origin.z + cos(angle) * radius * 0.60
		))
		mesh.surface_add_vertex(Vector3(
			origin.x + sin(angle) * radius, origin.y + 1.16,
			origin.z + cos(angle) * radius
		))
	mesh.surface_end()
	_trail.mesh = mesh
	_trail_left = TRAIL_SECONDS


func _spawn_effect(
	at: Vector3, seconds: float, from_scale: float, to_scale: float
) -> MeshInstance3D:
	var instance: MeshInstance3D = MeshInstance3D.new()
	instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	# `global_position` is only meaningful once the node is in the tree, so the
	# placement happens after `add_child` rather than before it.
	add_child(instance)
	instance.global_position = at
	instance.scale = Vector3.ONE * from_scale
	_effects.append({
		"node": instance, "left": seconds, "total": seconds,
		"from": from_scale, "to": to_scale,
	})
	return instance


func _additive(colour: Color, alpha: float) -> StandardMaterial3D:
	var material: StandardMaterial3D = StandardMaterial3D.new()
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	material.blend_mode = BaseMaterial3D.BLEND_MODE_ADD
	material.cull_mode = BaseMaterial3D.CULL_DISABLED
	material.albedo_color = Color(colour.r, colour.g, colour.b, clampf(alpha, 0.0, 1.0))
	return material


func _tick_effects(delta: float) -> void:
	if _effects.is_empty():
		return
	var alive: Array[Dictionary] = []
	for entry: Dictionary in _effects:
		# CASTING a freed object is itself an error in GDScript, so validity is
		# checked on the raw Variant BEFORE the cast. The room frees these nodes
		# on teardown and on Restart, and a burst still in flight when it does
		# would otherwise raise on the very next frame.
		if not is_instance_valid(entry["node"]):
			continue
		var node: MeshInstance3D = entry["node"] as MeshInstance3D
		entry["left"] = float(entry["left"]) - delta
		var progress: float = 1.0 - clampf(float(entry["left"]) / float(entry["total"]), 0.0, 1.0)
		if float(entry["left"]) <= 0.0:
			node.queue_free()
			continue
		node.scale = Vector3.ONE * lerpf(float(entry["from"]), float(entry["to"]), progress)
		var material: StandardMaterial3D = node.material_override as StandardMaterial3D
		if material != null:
			var colour: Color = material.albedo_color
			material.albedo_color = Color(colour.r, colour.g, colour.b, colour.a * (1.0 - delta * 5.5))
		alive.append(entry)
	_effects = alive


func _tick_trail(delta: float) -> void:
	if _trail_left <= 0.0:
		return
	_trail_left -= delta
	if _trail_left <= 0.0:
		_trail.mesh = null


# --- Material flash and recoil ----------------------------------------------

func _flash_body(target: Node, amount: float, tint: Color = Color(1.0, 0.90, 0.70)) -> void:
	if amount <= 0.0:
		return
	var rig: MediumRigVisual = _rig_of(target)
	if rig == null:
		return
	rig.set_impact_flash(amount, tint)
	_flashes.append({"rig": rig, "amount": amount, "tint": tint})


func _tick_flashes(delta: float) -> void:
	if _flashes.is_empty():
		return
	var alive: Array[Dictionary] = []
	for entry: Dictionary in _flashes:
		if not is_instance_valid(entry["rig"]):
			continue
		var rig: MediumRigVisual = entry["rig"] as MediumRigVisual
		var amount: float = maxf(float(entry["amount"]) - FLASH_DECAY * delta, 0.0)
		entry["amount"] = amount
		rig.set_impact_flash(amount, entry["tint"] as Color)
		if amount > 0.0:
			alive.append(entry)
	_flashes = alive


## §18 "restrained visual recoil". The VISUAL root only. Moving the body would
## change reach, navigation, and the Graveblade's holding distance, which is a
## mechanical change wearing a presentation costume.
func _recoil_body(target: Node, direction: Vector3, distance: float) -> void:
	var visual: Node3D = _visual_root_of(target)
	if visual == null or distance <= 0.0:
		return
	var planar: Vector3 = Vector3(direction.x, 0.0, direction.z)
	if planar.length() < 0.0001:
		return
	var local: Vector3 = visual.get_parent_node_3d().to_local(
		visual.get_parent_node_3d().global_position + planar.normalized() * distance
	)
	visual.position += Vector3(local.x, 0.0, local.z)
	_recoils.append({"node": visual})


func _tick_recoils(delta: float) -> void:
	if _recoils.is_empty():
		return
	var alive: Array[Dictionary] = []
	for entry: Dictionary in _recoils:
		if not is_instance_valid(entry["node"]):
			continue
		var node: Node3D = entry["node"] as Node3D
		var planar: Vector3 = Vector3(node.position.x, 0.0, node.position.z)
		if planar.length() < 0.002:
			node.position.x = 0.0
			node.position.z = 0.0
			continue
		var weight: float = clampf(RECOIL_RETURN * delta, 0.0, 1.0)
		node.position.x = lerpf(node.position.x, 0.0, weight)
		node.position.z = lerpf(node.position.z, 0.0, weight)
		alive.append(entry)
	_recoils = alive


func _rig_of(target: Node) -> MediumRigVisual:
	if target == null:
		return null
	for child: Node in target.get_children():
		var rig: MediumRigVisual = child as MediumRigVisual
		if rig != null:
			return rig
		var found: MediumRigVisual = _rig_of(child)
		if found != null:
			return found
	return null


func _visual_root_of(target: Node) -> Node3D:
	if target == null:
		return null
	return target.get_node_or_null(^"VisualRoot") as Node3D


# --- Camera and rumble -------------------------------------------------------

func _impulse(severity: float, direction: Vector3) -> void:
	var scaled: float = severity * shake_scale()
	largest_impulse_requested = maxf(largest_impulse_requested, scaled)
	if scaled <= 0.0:
		return
	var rig: PrototypeCameraRig = room.get("camera_rig") as PrototypeCameraRig
	if rig != null:
		rig.add_impulse(scaled, direction)


## §21: "vibration Standard / Reduced / Off where supported". Godot's joypad
## vibration is a no-op on a device that has none, so "where supported" is
## honoured by the platform rather than guessed at here.
func _rumble(strength: float) -> void:
	var scaled: float = strength * vibration_scale()
	if scaled <= 0.0:
		return
	var device: int = -1
	if room != null:
		var tracker: InputFamilyTracker = room.get("input_family") as InputFamilyTracker
		if tracker != null:
			device = tracker.controller_device
	if device < 0:
		return
	Input.start_joy_vibration(device, scaled * 0.6, scaled, RUMBLE_SECONDS)
	rumbles += 1
	_rumble_left = RUMBLE_SECONDS


func _tick_rumble(delta: float) -> void:
	if _rumble_left <= 0.0:
		return
	_rumble_left = maxf(_rumble_left - delta, 0.0)


## Called by every neutralising path — pause, modal, focus loss, controller
## disconnect, Fallen, and Restart — so a rumble cannot survive the boundary.
func stop_all() -> void:
	_rumble_left = 0.0
	for device: int in Input.get_connected_joypads():
		Input.stop_joy_vibration(device)
	_trail.mesh = null
	_trail_left = 0.0
	for entry: Dictionary in _flashes:
		if is_instance_valid(entry["rig"]):
			(entry["rig"] as MediumRigVisual).set_impact_flash(0.0)
	_flashes.clear()
	for entry: Dictionary in _recoils:
		if is_instance_valid(entry["node"]):
			var node: Node3D = entry["node"] as Node3D
			node.position.x = 0.0
			node.position.z = 0.0
	_recoils.clear()
	var rig_node: PrototypeCameraRig = room.get("camera_rig") as PrototypeCameraRig if room != null else null
	if rig_node != null:
		rig_node.clear_impulse()


func active_effects() -> int:
	return _effects.size()


func describe() -> String:
	return "%d hits (%d improved), %d kills, %d player hits, %d trails, %d steps | numbers %d shown / %d suppressed | shake %.2f flash %.2f vibration %.2f" % [
		hits_shown, improved_hits_shown, kills_shown, player_damage_shown, trails_shown, footsteps,
		numbers_shown, numbers_suppressed, shake_scale(), flash_scale(), vibration_scale(),
	]
