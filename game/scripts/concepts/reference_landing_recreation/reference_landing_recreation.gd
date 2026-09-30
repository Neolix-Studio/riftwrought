class_name ReferenceLandingRecreation
extends Node3D
## Reference Landing Recreation -- Session 8 integration (NON-CANONICAL).
##
## This is NOT the canonical Riftfall Landing
## (`game/scenes/first_mvp/severed_threshold/riftfall_landing.tscn`, D-209, open
## pending the project owner's own playtest) and does not modify it, does not
## touch `game/scenes/first_mvp/zone_composer_practice.tscn`, and does not touch
## anything under `game/addons/`. It closes no gate and is not linked from
## `README.md`'s required reading -- see
## `docs/concepts/reference_landing_recreation/00_overview.md`.
##
## Combines Sessions 2-7's independent layout builders onto this scene, whose
## root already carries Session 1's three plain `Marker3D` anchors (Spawn,
## Midpoint, Portal). Follows the same "environment scene owns no player, no
## camera" separation `riftfall_landing.gd` uses: this file adds no camera, no
## player, no overlay, and makes no filesystem call. The evidence/measurement
## wrapper lives beside it at `reference_landing_recreation_review.tscn` /
## `integration_review.gd`, exactly as `riftfall_landing_review.tscn` wraps the
## canonical scene.
##
## ONE DELIBERATE INTEGRATION CHOICE: Session 6's `RiftGlowDisc` (a flat
## unshaded cylinder mesh, built by `lighting_layout.gd`) is queue_free()'d
## right after Lighting builds. Session 7's own doc comment says this
## integration is "free to drop the Session 6 disc entirely" now that the real
## crack shader (`ReferenceLandingVfxLayout`'s `RiftCrackQuad`) sits a few
## centimetres above it and is the visually dominant read; keeping both risked a
## muddled double-glow at the rift patch for no benefit. `RiftLight` (the actual
## light source next to it) is left untouched -- only the disc mesh goes.
## `lighting_layout.gd` itself is NOT edited, matching every session's own rule
## of calling a prior session's public API rather than editing its file.
##
## See
## `docs/concepts/reference_landing_recreation/08_integration_and_playtest_report.md`
## for the delivered measurements, evidence screenshots, and an honest list of
## where this draft still diverges from the reference image.

func _ready() -> void:
	ReferenceLandingGroundLayout.new().build(self)
	ReferenceLandingBoundaryLayout.new().build(self)
	ReferenceLandingArchitectureLayout.new().build(self)
	ReferenceLandingPropsLayout.new().build(self)
	ReferenceLandingLightingLayout.new().build(self)
	ReferenceLandingVfxLayout.new().build(self)

	var disc: Node = find_child("RiftGlowDisc", true, false)
	if disc != null:
		disc.queue_free()
