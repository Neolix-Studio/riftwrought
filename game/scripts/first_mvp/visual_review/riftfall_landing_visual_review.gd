class_name RiftfallLandingVisualReview
extends RiftfallLandingGreyboxReview
## Riftfall Landing — ISOLATED VISUAL REVIEW. NOT CANONICAL.
##
## The project owner accepted `RiftfallLandingGreyboxLayout` (Greybox V2) as
## the layout foundation. This scene turns that accepted blockout into one
## cohesive dark-fantasy location — a candidate art pass — WITHOUT touching its
## route, dimensions, clearances, camera, collision, or navigation in any way.
## It answers a purely visual question; V2's own spatial judgement already
## happened and is not reopened here.
##
## IT DOES NOT TOUCH THE CANONICAL GATE 1C SCENE, `riftfall_landing.tscn`,
## WHICH REMAINS THE SHIPPED CONTENT UNTIL AND UNLESS THE PROJECT OWNER
## ACCEPTS THIS CANDIDATE. This scene shares no file with
## `scenes/first_mvp/severed_threshold/`. It does not touch the Zone Composer
## or the owner's own composed practice zone either.
##
## HOW IT REUSES V2 UNCHANGED. This class `extends RiftfallLandingGreyboxReview`
## and calls `super._ready()`, which builds `RiftfallLandingGreyboxLayout`
## exactly as the accepted review does — same `CENTRELINE`, same `Rect2`
## constants, same `CollisionShape3D` and `NavigationObstacle3D` set, same one
## navigation bake, same accepted 19 m / 55 deg / 45 deg camera and 5.0 m/s
## locomotion kernel. Only ONE thing is added on top, after that unchanged
## build completes: `RiftfallLandingVisualReviewDressing`, which recolours the
## already-built ground/boundary/architecture surfaces and adds new,
## non-colliding decoration. See that script's own header for exactly what it
## does and does not touch.
##
## WHAT IS NEW HERE: a `WorldEnvironment` / `ExteriorLighting` / `KeyLight` set
## reusing the shared `ExteriorReviewLighting` and `ExteriorReviewTreatment`
## components UNCHANGED (the same classes the closed Gate 1B scenes and the
## canonical Gate 1C scene use), put into the accepted D-206 candidate exterior
## state exactly as the canonical scene does: saturation x 0.42, value x 0.62,
## cool tint (0.88, 0.90, 0.97), candidate lighting with its restrained warm
## lantern pools and subtle distance fog.
##
## Controls are exactly V2's: left click or hold to move; left stick to move
## directly. F6 grid (and, here, the diagnostic centreline/markers together
## with it) · [ ] camera distance · \\ reset. No InputMap action is added.

const VISUAL_VERIFICATION_SCRIPT: String = "res://tests/riftfall_landing_visual_review_verification.gd"

var lighting: ExteriorReviewLighting
var treatment: ExteriorReviewTreatment
var dressing: RiftfallLandingVisualReviewDressing


func _ready() -> void:
	lighting = $ExteriorLighting
	treatment = ExteriorReviewTreatment.new()
	lighting.configure($WorldEnvironment, $KeyLight)

	# Builds V2's layout, collision, one navigation bake, the player, and the
	# accepted camera exactly as the plain greybox review does. Deliberately
	# does NOT start verification yet — see the override below — so the
	# dressing pass below runs before anything is asserted against it.
	await super._ready()

	dressing = $Composition/Dressing
	dressing.build(layout, treatment, lighting)

	# The accepted D-206 exterior presentation, selected once, exactly as the
	# canonical scene selects it — no neutral state, no toggle.
	lighting.set_mode(ExteriorReviewLighting.Mode.CANDIDATE)
	treatment.set_candidate(true)

	log_event("visual review", "isolated dark-fantasy dressing pass over accepted Greybox V2; NOT canonical")
	log_event("presentation", "accepted exterior: saturation x %.2f, value x %.2f, tint (%.2f, %.2f, %.2f)" % [
		ExteriorReviewTreatment.SATURATION, ExteriorReviewTreatment.VALUE,
		ExteriorReviewTreatment.TINT.r, ExteriorReviewTreatment.TINT.g, ExteriorReviewTreatment.TINT.b,
	])
	log_event("palette", "%d instance(s) across %d distinct registered model type(s): %s" % [
		dressing.instance_count(), dressing.distinct_type_count(),
		", ".join(Array(dressing.used_keys())),
	])
	log_event("treated surfaces", "%d surface(s) registered; %d drifted source(s)" % [
		treatment.surface_count(), treatment.drifted_sources().size(),
	])

	_maybe_start_visual_verification()


## Overrides the base class's own hook so its `_ready()` does not attach the
## GREYBOX verification (which asserts a flat-diagnostic scene this one is not)
## and, critically, does not attach anything before the dressing pass above has
## run. See `_maybe_start_visual_verification()`.
func _maybe_start_verification() -> void:
	pass


func _maybe_start_visual_verification() -> void:
	var arguments: PackedStringArray = OS.get_cmdline_user_args()
	if not arguments.has("--verify-visual-review"):
		return
	var script: GDScript = load(VISUAL_VERIFICATION_SCRIPT) as GDScript
	var runner: Node = Node.new()
	runner.name = "RiftfallLandingVisualReviewVerification"
	runner.set_script(script)
	runner.set("review", self)
	runner.set("arguments", arguments)
	add_child(runner)


## F6 also restores the diagnostic language (markers, centreline) it always
## did in V2, so anyone checking this candidate against the accepted layout
## can still see it exactly.
func set_grid_visible(value: bool) -> void:
	super.set_grid_visible(value)
	if layout == null:
		return
	var markers: Node = layout.get_node_or_null("Markers")
	if markers != null:
		markers.visible = value
	var centreline: Node = layout.get_node_or_null("Visuals/CentrelineGuide")
	if centreline != null:
		centreline.visible = value
