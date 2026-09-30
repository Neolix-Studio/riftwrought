class_name HuntressSpikeProbe
extends PlayerController

## THE SPIKE'S PLAYER PROBE — the VERBATIM accepted controller, plus a bow.
##
## ============================================================================
## THE ACCEPTED BEHAVIOUR IS THE ACCEPTED CODE.
## ============================================================================
## `PlayerController` here is `game3d/scripts/control/player_controller.gd`,
## copied byte-for-byte (I-12). This subclass overrides EXACTLY THREE methods --
## `setup`, `_play` and `_update_attack_input` -- and the suite asserts that set
## (C-09). Everything the owner accepted runs untouched:
##   * `step()` -- aim, action, movement and continuous facing, in that order;
##   * `_update_action()` -- the release at the mechanical marker, EXACTLY ONCE;
##     the wind-up buffer; post-release RECOVERY cancellation;
##   * `commit_subsystem_action()` -- the D-375 seam, accepted under D-376, "the
##     one seam a subsystem needs in order to use the ACCEPTED commitment rather
##     than inventing a second one".
##
## ============================================================================
## THE DIAGNOSTIC BOW SHOT IS NOT A SKILL.
## ============================================================================
## It is NOT Splinter Shot, NOT a Huntress Skill and NOT a roster entry. It is the
## smallest thing that can put a real bow animation through the accepted STOP /
## recovery-cancellation policy. The verbatim controller's own DIAGNOSTIC PROBE
## BOLT is never fired here (C-10): `begin_attack()` is unreachable, because
## `_update_attack_input()` is the one entry point and it is overridden.

## Set by the composition root BEFORE `setup()`.
var clip_source: KayKitClipSource
var driver: BowPoseDriver
var ranger: Node3D
var pres_huntress: BowPresentation
var pres_ranger: BowPresentation
var arrow_parent: Node3D
var on_arrow_hit: Callable = Callable()

## The locomotion design name the verbatim controller asked `_play` for.
var loco_request: String = "idle"

## Diagnostic playback rate, captured PER USE at the moment the use begins.
var rate_index: int = SpikeConfig.DEFAULT_RATE_INDEX

## Diagnostics the suite and the HUD read. LOGS, not control state.
var bow_uses: int = 0
var arrows_released: int = 0
var release_frames: Array[int] = []
var release_log: Array = []
var last_use_released: bool = false
var projectiles: Array = []

func setup(corpus: AnimationLibrary) -> void:
	# THE ACCEPTED SETUP RUNS FIRST, unchanged: collision, the navigation agent,
	# the Huntress body from AssetManifest.OUTFIT_RANGER, the read light and the
	# ground-point shadow. `corpus` is null, so RigCorpus.attach_player returns
	# null and no AnimationPlayer is added -- the driver poses her instead.
	super.setup(corpus)
	visual.name = "HuntressVisual"
	# THE NATIVE KAYKIT CONTROL, under the SAME visual root, so it shares the
	# accepted continuous yaw. It is hidden until the comparison switch is used.
	ranger = (load(AssetManifest.KAYKIT_RANGER) as PackedScene).instantiate()
	ranger.name = "NativeKayKitControl_DIAGNOSTIC_COMPARATOR"
	visual.add_child(ranger)
	ranger.visible = false

	driver = BowPoseDriver.new()
	driver.name = "BowPoseDriver"
	add_child(driver)
	if not driver.build(self, clip_source, visual, ranger):
		push_error("SPIKE: the pose driver could not be built")
		return
	pres_huntress = BowPresentation.new()
	pres_huntress.name = "BowPresentation_Huntress"
	add_child(pres_huntress)
	pres_huntress.build("huntress", RigCorpus.mesh_height(visual.get_node("Armature"))
		* SpikeConfig.BOW_LENGTH_PER_HEIGHT)
	pres_ranger = BowPresentation.new()
	pres_ranger.name = "BowPresentation_NativeControl"
	add_child(pres_ranger)
	pres_ranger.build("ranger", RigCorpus.mesh_height(ranger) * SpikeConfig.BOW_LENGTH_PER_HEIGHT)
	driver.solve_presentations(pres_huntress, pres_ranger)
	driver.set_show_ranger(false)

## ============================================================================
## OVERRIDE 1 of 3 -- `_play`.
## ============================================================================
## The verbatim controller asks for UAL clip names ("Idle", "Walk", "Jog_Fwd")
## with design names "idle" / "walk" / "run". The spike imports no UAL clip, so
## the DESIGN name is recorded and the driver plays the bow-carrying equivalent.
## No clip is looked up here, and none can be silently missing.
func _play(clip: String, design_name: String, _speed: float = 1.0) -> void:
	loco_request = design_name
	live_clip = clip
	live_design_name = design_name

## ============================================================================
## OVERRIDE 2 of 3 -- `_update_attack_input`.
## ============================================================================
## The accepted input rule, applied to the bow: held input starts a use as soon
## as no action is committed. The use enters the ACCEPTED commitment through
## `commit_subsystem_action` with the policy STOP -- the only policy it can use.
func _update_attack_input() -> void:
	if intent.attack_held and not debug_freeze_attack and not commitment.active:
		begin_bow_shot()

func current_rate() -> float:
	return float(SpikeConfig.DIAGNOSTIC_RATES[rate_index])

func cycle_rate() -> float:
	rate_index = (rate_index + 1) % SpikeConfig.DIAGNOSTIC_RATES.size()
	return current_rate()

## Begins ONE diagnostic bow use. TARGETING IS PER-USE: the aim is sampled HERE,
## bound into the release, and used by this use alone.
func begin_bow_shot() -> bool:
	var rate := current_rate()
	var aim := aim_dir
	aim.y = 0.0
	if aim.length() < 0.001:
		aim = Vector3.FORWARD
	aim = aim.normalized()
	var use := bow_uses + 1
	var ok := commit_subsystem_action(SpikeConfig.BOW_ACTION_LABEL,
		driver.duration_at(rate), driver.marker(), _release_arrow.bind(aim, use))
	if not ok:
		return false
	bow_uses = use
	last_use_released = false
	driver.begin_action(use, rate)
	return true

## Called by the ACCEPTED `_update_action()` at the mechanical marker, once.
func _release_arrow(aim: Vector3, use: int) -> void:
	arrows_released += 1
	last_use_released = true
	var frame := Engine.get_physics_frames()
	release_frames.append(frame)
	# THE PROJECTILE TAKES OVER FROM THE NOCKED ARROW, on this very frame.
	#
	# ITS GAMEPLAY PATH IS THE HUNTRESS'S, WHICHEVER BODY IS VISIBLE. The planar
	# origin and the length its hit test uses come from the Huntress's nocked
	# arrow ALWAYS, so the comparison switch cannot move a hit by a centimetre or
	# a frame (R-03). Only presentation follows the visible body: the height the
	# mesh is drawn at and the mesh's own length.
	var sim := pres_huntress.nocked_arrow()
	var shown := driver.visible_presentation().nocked_arrow()
	var sim_xf: Transform3D = sim["xform"]
	var shown_xf: Transform3D = shown["xform"]
	var origin := Vector3(sim_xf.origin.x, shown_xf.origin.y, sim_xf.origin.z)
	var p := ArrowProjectile.new()
	p.name = "Arrow_use%d" % use
	if arrow_parent != null:
		arrow_parent.add_child(p)
	else:
		get_parent().add_child(p)
	p.launch(origin, aim, float(shown["scale"]), use, on_arrow_hit, float(sim["length"]))
	projectiles.append(p)
	release_log.append({"use": use, "frame": frame, "elapsed": commitment.elapsed,
		"duration": commitment.duration, "marker": commitment.release_marker,
		"rate": driver.use_rate, "spawn": origin, "aim": aim,
		"nock_world": sim_xf.origin, "shown_nock_world": shown_xf.origin,
		"facing_yaw": visual.rotation.y})

func set_comparison(show_native_control: bool) -> void:
	driver.set_show_ranger(show_native_control)

func showing_native_control() -> bool:
	return driver.show_ranger
