@tool
extends RefCounted
## Riftwrought — the project's record of environment models APPROVED FOR
## AUTHORING AVAILABILITY. D-215.
##
## THIS IS A RECORD, NOT A LAYOUT AND NOT A ZONE. It says which models the
## project owner has approved for an author to reach for. It says nothing about
## where any of them is used, and using one is a separate decision made zone by
## zone. Nothing in the running game reads this file.
##
## WHY IT EXISTS AS A SECOND RECORD, RATHER THAN AS AN EDIT TO THE FIRST.
## Until D-215 the Zone Composer palette read exactly one accepted record —
## `scripts/first_mvp/severed_threshold/riftfall_landing_layout.gd`'s `PAYLOADS`,
## the D-208 §6.3 allowlist Gate 1C delivered. That record answers a different
## question: "which models does Riftfall Landing use." The 47 models below are
## approved for AVAILABILITY and are used by no zone at all, so writing them into
## Riftfall Landing's own record would have said something untrue about Riftfall
## Landing — and D-215 forbids touching that scene in any case.
##
## So there are now two records answering two questions, and the palette reads
## BOTH. The palette still owns neither, still invents nothing, and is still
## proved against the union in both directions.
##
## THE RECORD OWNS THE FACTS; THE PALETTE OWNS ONLY HOW TO BROWSE THEM. Path,
## family, ground contact, intended role and the reviewed collision and
## navigation intent live here. The palette drawer, the plain-language name and
## the one-sentence guidance live in the addon, exactly as they did for the 19.
##
## PROVENANCE. Every model below was inspected under the D-214 catalogue review,
## shortlisted there, and approved by the project owner on 2026-09-03. All three
## source packs are CC0 1.0 and were already registered; the extraction manifest
## is `game/assets/third_party/kaykit/SOURCE_AND_LICENSE.md` §2.5c, and each file
## is proved byte-identical to its in-archive original on every Gate 1B run.
##
## THE FOUR FAMILY STRINGS ARE THE ACCEPTED ONES, RETYPED NOWHERE ELSE'S
## MEANING. They are spelled exactly as the Gate 1C record spells them, because
## the palette counts distinct families across both records and a second spelling
## of "KayKit Dungeon Asset Pack 1.1 FREE" would read as a fifth family.
const FAMILY_DUNGEON: String = "KayKit Dungeon Asset Pack 1.1 FREE"
const FAMILY_FOREST: String = "KayKit Forest Nature Pack 1.0 FREE"
const FAMILY_HALLOWEEN: String = "KayKit Halloween Bits 1.0 FREE"

## The three ground-contact rules the project already uses, and no fourth one.
##
## The D-214 catalogue used a review-only fourth value, `mount`, for the four
## pieces KayKit authored to hang on a wall. It is deliberately NOT introduced
## here. Phase 1 places on the ground plane and has no wall to hang anything on,
## so a fourth rule would have been a rule with no behaviour behind it. Those
## four are recorded as `base` — measured base offsets +0.531 m (banner_shield_red),
## -0.793 m (sword_shield_broken), -0.815 m (sword_shield) and -0.381 m
## (torch_mounted) — which puts each one wholly above the ground where it is
## clicked, so the author can see it and then raise it onto masonry. Their role
## sentences say so.

## "blocks" and "carves" are the REVIEWED INTENT for a piece, and they are
## advice, not behaviour. Phase 1 of the Zone Composer authors no collision shape
## and no navigation carve at all, for any piece; validating that a placed zone
## honours these is Phase 3 and is not begun. The values are here so the author
## can see what a piece is meant to be before they place forty of them.
##
##   "yes"    — a readable solid: it should stop the player and be excluded from
##              navigation when a zone's collision pass is authored.
##   "no"     — dressing: small enough or low enough to walk over, and it should
##              own neither.
##   "author" — genuinely a judgement, and the D-214 review declined to make it.

## The reviewed snap step, in METRES, for each piece.
##
## AND ONE OF THEM CANNOT BE OFFERED TODAY, WHICH IS STATED RATHER THAN ROUNDED
## AWAY. The Zone Composer offers Off / 0.25 m / 0.5 m / 1 m / 4 m — the accepted
## Phase 1 set, which D-215 does not change. Sixteen pieces below were reviewed at
## 2 m, the half-module of the 4 : 2 : 1 KayKit ladder. The tool applies 1 m for
## those, which is correct rather than approximate: every position on a 2 m grid
## is also a position on the 1 m grid, so nothing becomes unbuildable — the author
## simply gets one intermediate stop they did not ask for. Whether to add a 2 m
## step is recorded as owner feedback beside rotation-aware endpoint snapping.
const PAYLOADS: Array[Dictionary] = [
	# --- Ground — 10 pieces --------------------------------------------
	{"key": "floor_foundation_corner", "family": FAMILY_DUNGEON, "contact": "base",
		"path": "res://assets/third_party/kaykit/dungeon/floor_foundation_corner.gltf",
		"reviewed_snap": 2.0, "blocks": "yes", "carves": "yes",
		"role": "The outside corner of that revetment; with the front piece plus rotation it closes any rectangular plinth footprint."},
	{"key": "floor_foundation_front", "family": FAMILY_DUNGEON, "contact": "base",
		"path": "res://assets/third_party/kaykit/dungeon/floor_foundation_front.gltf",
		"reviewed_snap": 2.0, "blocks": "yes", "carves": "yes",
		"role": "A 2 m tileable face of finished masonry below floor level, turning a raised terrace or the Watch's base into built revetment rather than authored earth."},
	{"key": "floor_tile_large_rocks", "family": FAMILY_DUNGEON, "contact": "surface",
		"path": "res://assets/third_party/kaykit/dungeon/floor_tile_large_rocks.gltf",
		"reviewed_snap": 4.0, "blocks": "no", "carves": "no",
		"role": "One 4 m placement lays a field of fallen stone into the ground layer beneath a collapse, instead of hand-scattering dozens of rock props into a 94.2%-clear footprint."},
	{"key": "floor_dirt_small", "family": FAMILY_HALLOWEEN, "contact": "surface",
		"path": "res://assets/third_party/kaykit/halloween/floor_dirt_small.gltf",
		"reviewed_snap": 2.0, "blocks": "no", "carves": "no",
		"role": "The exact half-module of the dirt already in the scene; frays the dirt shoulder at 2 m instead of in 4 m jumps that betray the grid."},
	{"key": "floor_dirt_large_rocky", "family": FAMILY_DUNGEON, "contact": "surface",
		"path": "res://assets/third_party/kaykit/dungeon/floor_dirt_large_rocky.gltf",
		"reviewed_snap": 4.0, "blocks": "no", "carves": "no",
		"role": "The 4 m surface for stretches where the road has lost its paving entirely and is reverting to open ground."},
	{"key": "floor_tile_small_weeds_A", "family": FAMILY_DUNGEON, "contact": "surface",
		"path": "res://assets/third_party/kaykit/dungeon/floor_tile_small_weeds_A.gltf",
		"reviewed_snap": 2.0, "blocks": "no", "carves": "no",
		"role": "Sparse punctuation where joints have opened; states long abandonment without a single scattered plant instance."},
	{"key": "floor_tile_small", "family": FAMILY_DUNGEON, "contact": "surface",
		"path": "res://assets/third_party/kaykit/dungeon/floor_tile_small.gltf",
		"reviewed_snap": 2.0, "blocks": "no", "carves": "no",
		"role": "The intact 2 m paving unit; lay it as the road's sound surface so the broken and weed-grown tiles read as exceptions rather than as the whole story."},
	{"key": "floor_tile_small_broken_A", "family": FAMILY_DUNGEON, "contact": "surface",
		"path": "res://assets/third_party/kaykit/dungeon/floor_tile_small_broken_A.gltf",
		"reviewed_snap": 2.0, "blocks": "no", "carves": "no",
		"role": "Fractures the procession road progressively along its length, and frays the ragged edge where paving fails into dirt or into the Rift scar."},
	{"key": "floor_tile_small_broken_B", "family": FAMILY_DUNGEON, "contact": "surface",
		"path": "res://assets/third_party/kaykit/dungeon/floor_tile_small_broken_B.gltf",
		"reviewed_snap": 2.0, "blocks": "no", "carves": "no",
		"role": "The second fracture pattern; alternate with A across a destroyed stretch so many adjacent damaged tiles read as damage rather than as a stamped texture."},
	{"key": "floor_tile_small_corner", "family": FAMILY_DUNGEON, "contact": "surface",
		"path": "res://assets/third_party/kaykit/dungeon/floor_tile_small_corner.gltf",
		"reviewed_snap": 2.0, "blocks": "no", "carves": "no",
		"role": "The only paved piece that cuts a corner; bends a paved run or trims the outside edge of a road that has lost its shoulder."},
	# --- Roads — 6 pieces ----------------------------------------------
	{"key": "barrier_colum_half", "family": FAMILY_DUNGEON, "contact": "base",
		"path": "res://assets/third_party/kaykit/dungeon/barrier_colum_half.gltf",
		"reviewed_snap": 1.0, "blocks": "yes", "carves": "yes",
		"role": "The 2.350 m fitting piece that lets a low boundary land off the 4 m grid across a 53.4 m route."},
	{"key": "barrier_column", "family": FAMILY_DUNGEON, "contact": "base",
		"path": "res://assets/third_party/kaykit/dungeon/barrier_column.gltf",
		"reviewed_snap": 4.0, "blocks": "yes", "carves": "yes",
		"role": "The 1.400 m kerb with an integral post, giving the intact approach a beat every module; also bounds a space at waist height without occluding the visible band the way a 4 m wall does."},
	{"key": "barrier_corner", "family": FAMILY_DUNGEON, "contact": "base",
		"path": "res://assets/third_party/kaykit/dungeon/barrier_corner.gltf",
		"reviewed_snap": 0.25, "blocks": "yes", "carves": "yes",
		"role": "Turns a low boundary line through the road's bend — the only piece in all 362 candidates that can do it."},
	{"key": "barrier", "family": FAMILY_DUNGEON, "contact": "base",
		"path": "res://assets/third_party/kaykit/dungeon/barrier.gltf",
		"reviewed_snap": 4.0, "blocks": "yes", "carves": "yes",
		"role": "A plain 4 m road edge at 1.100 m; because it is a discrete module, simply omitting units along the length IS the degradation — unbroken at the arrival, gapped, then gone."},
	{"key": "barrier_half", "family": FAMILY_DUNGEON, "contact": "base",
		"path": "res://assets/third_party/kaykit/dungeon/barrier_half.gltf",
		"reviewed_snap": 2.0, "blocks": "yes", "carves": "yes",
		"role": "The 2 m half-module of Low Stone Kerb. Use it to fit a kerb run to a road length that is not a whole number of 4 m modules, and to fray a kerb out at its end."},
	{"key": "plaque", "family": FAMILY_HALLOWEEN, "contact": "surface",
		"path": "res://assets/third_party/kaykit/halloween/plaque.gltf",
		"reviewed_snap": 2.0, "blocks": "no", "carves": "no",
		"role": "A 2 x 2 m inscribed slab that STANDS ON the road at 0.400 m — knee height, not a flush inlay. Set one where the procession road wants a full stop."},
	# --- Architecture — 14 pieces --------------------------------------
	{"key": "pillar", "family": FAMILY_DUNGEON, "contact": "base",
		"path": "res://assets/third_party/kaykit/dungeon/pillar.gltf",
		"reviewed_snap": 4.0, "blocks": "yes", "carves": "yes",
		"role": "The intact 4 m upright the game lacks; ranked along the procession road with stumps beyond it, the degradation gradient is stated in one silhouette."},
	{"key": "stairs_modular_center", "family": FAMILY_DUNGEON, "contact": "base",
		"path": "res://assets/third_party/kaykit/dungeon/stairs_modular_center.gltf",
		"reviewed_snap": 2.0, "blocks": "author", "carves": "no",
		"role": "The only stair that mates the accepted module ladder — 4.000 m rise, 4.000 m run, 2.000 m wide so it tiles to any width at 106 verts."},
	{"key": "wall_Tsplit", "family": FAMILY_DUNGEON, "contact": "base",
		"path": "res://assets/third_party/kaykit/dungeon/wall_Tsplit.gltf",
		"reviewed_snap": 4.0, "blocks": "yes", "carves": "yes",
		"role": "Where an internal cross-wall meets the curtain wall — what makes a stretch of exterior masonry read as the edge of a building rather than as a fence."},
	{"key": "wall_arched", "family": FAMILY_DUNGEON, "contact": "base",
		"path": "res://assets/third_party/kaykit/dungeon/wall_arched.gltf",
		"reviewed_snap": 4.0, "blocks": "yes", "carves": "author",
		"role": "The one aperture worth buying: a clear arched passage with no door leaf, so it reads identically from either side at any rotation and its profile matches the extracted arch landmark."},
	{"key": "wall_broken", "family": FAMILY_DUNGEON, "contact": "base",
		"path": "res://assets/third_party/kaykit/dungeon/wall_broken.gltf",
		"reviewed_snap": 4.0, "blocks": "yes", "carves": "yes",
		"role": "The two cheeks framing the 8 m Watch breach, and the piece that ends a curtain run as a ruin instead of as an absence."},
	{"key": "wall_cracked", "family": FAMILY_DUNGEON, "contact": "base",
		"path": "res://assets/third_party/kaykit/dungeon/wall_cracked.gltf",
		"reviewed_snap": 4.0, "blocks": "yes", "carves": "yes",
		"role": "The middle term of the damage gradient; spreads failure through a wall run so the breach is approached rather than arrived at."},
	{"key": "wall_endcap", "family": FAMILY_DUNGEON, "contact": "base",
		"path": "res://assets/third_party/kaykit/dungeon/wall_endcap.gltf",
		"reviewed_snap": 0.25, "blocks": "yes", "carves": "yes",
		"role": "Terminates a wall run as built stone; also finishes the vertical edge where a curtain wall is cut through."},
	{"key": "wall_half", "family": FAMILY_DUNGEON, "contact": "base",
		"path": "res://assets/third_party/kaykit/dungeon/wall_half.gltf",
		"reviewed_snap": 2.0, "blocks": "yes", "carves": "yes",
		"role": "The 2 m module: offsets a run by half a module so joints do not align with the floor grid, and lets the breach edges sit off the 4 m grid so an 8 m gap does not look measured out."},
	{"key": "wall_half_endcap_sloped", "family": FAMILY_DUNGEON, "contact": "base",
		"path": "res://assets/third_party/kaykit/dungeon/wall_half_endcap_sloped.gltf",
		"reviewed_snap": 2.0, "blocks": "yes", "carves": "yes",
		"role": "The last surviving 2 m of wall before the gap: an off-module length that carries damage in its own silhouette."},
	{"key": "wall_open_scaffold", "family": FAMILY_DUNGEON, "contact": "base",
		"path": "res://assets/third_party/kaykit/dungeon/wall_open_scaffold.gltf",
		"reviewed_snap": 4.0, "blocks": "author", "carves": "author",
		"role": "Interrupted repair — timber staging an author can stand inside the gap, stating that the garrison began mending the breach and never finished."},
	{"key": "wall_sloped", "family": FAMILY_DUNGEON, "contact": "base",
		"path": "res://assets/third_party/kaykit/dungeon/wall_sloped.gltf",
		"reviewed_snap": 4.0, "blocks": "yes", "carves": "yes",
		"role": "The only piece that lets a wall run change height continuously, instead of dropping from 4.000 m to nothing at a module seam."},
	{"key": "rubble_half", "family": FAMILY_DUNGEON, "contact": "base",
		"path": "res://assets/third_party/kaykit/dungeon/rubble_half.gltf",
		"reviewed_snap": 4.0, "blocks": "yes", "carves": "yes",
		"role": "The 4 m collapse mass that substitutes for one module of wall or road; it is what makes a broken wall credible by putting what fell out of it on the ground."},
	{"key": "rubble_large", "family": FAMILY_DUNGEON, "contact": "base",
		"path": "res://assets/third_party/kaykit/dungeon/rubble_large.gltf",
		"reviewed_snap": 4.0, "blocks": "yes", "carves": "yes",
		"role": "8.129 m of collapse — one instance can represent the whole fallen span, or partially choke the 10–14 m corridor without closing it."},
	{"key": "column", "family": FAMILY_DUNGEON, "contact": "base",
		"path": "res://assets/third_party/kaykit/dungeon/column.gltf",
		"reviewed_snap": 1.0, "blocks": "yes", "carves": "author",
		"role": "The sheared-off remnant that turns a colonnade into a BROKEN colonnade; also serves as a road bollard or a plinth under a shrine or a light."},
	# --- Boundaries — 8 pieces -----------------------------------------
	{"key": "Rock_3_R_Color1", "family": FAMILY_FOREST, "contact": "plant",
		"path": "res://assets/third_party/kaykit/forest/Rock_3_R_Color1.gltf",
		"reviewed_snap": 0.0, "blocks": "yes", "carves": "yes",
		"role": "The only wide impassable natural mass available; terminates a boundary run or breaks its regularity with something plainly not built."},
	{"key": "post", "family": FAMILY_HALLOWEEN, "contact": "base",
		"path": "res://assets/third_party/kaykit/halloween/post.gltf",
		"reviewed_snap": 2.0, "blocks": "yes", "carves": "author",
		"role": "The unlit member of the 3.30 m post family; alternate it with the lantern post so the lit chain visibly FAILS as the route darkens toward the breach."},
	{"key": "post_lantern", "family": FAMILY_HALLOWEEN, "contact": "base",
		"path": "res://assets/third_party/kaykit/halloween/post_lantern.gltf",
		"reviewed_snap": 2.0, "blocks": "yes", "carves": "author",
		"role": "The lit 3.30 m post; a run of these is one of only four devices this camera permits to carry forward bearing, and it is the only lantern that reads as a chain."},
	{"key": "Rock_2_F_Color1", "family": FAMILY_FOREST, "contact": "base",
		"path": "res://assets/third_party/kaykit/forest/Rock_2_F_Color1.gltf",
		"reviewed_snap": 4.0, "blocks": "yes", "carves": "yes",
		"role": "A 4.143 m natural mass that substitutes for exactly one 4 m fence or barrier bay, letting a boundary alternate built and geological without leaving the module grid."},
	{"key": "Rock_3_K_Color1", "family": FAMILY_FOREST, "contact": "plant",
		"path": "res://assets/third_party/kaykit/forest/Rock_3_K_Color1.gltf",
		"reviewed_snap": 0.0, "blocks": "author", "carves": "author",
		"role": "Bedrock coming up through the fractured scar ground, and the base of the authored terrain boundary where an embedded mass ties built slope to open ground."},
	{"key": "fence", "family": FAMILY_HALLOWEEN, "contact": "base",
		"path": "res://assets/third_party/kaykit/halloween/fence.gltf",
		"reviewed_snap": 4.0, "blocks": "yes", "carves": "author",
		"role": "The intact counterpart of the fence already in the game; a boundary continuous behind the player and failing ahead is the cheapest bearing signal this camera permits."},
	{"key": "fence_pillar", "family": FAMILY_HALLOWEEN, "contact": "base",
		"path": "res://assets/third_party/kaykit/halloween/fence_pillar.gltf",
		"reviewed_snap": 2.0, "blocks": "author", "carves": "no",
		"role": "The intact 2.200 m stone post that lets a fence line rise back to full height where it is meant to read as maintained."},
	{"key": "Rock_1_H_Color1", "family": FAMILY_FOREST, "contact": "base",
		"path": "res://assets/third_party/kaykit/forest/Rock_1_H_Color1.gltf",
		"reviewed_snap": 1.0, "blocks": "yes", "carves": "yes",
		"role": "The missing middle rung of the rock ladder at 1.868 m; pinches or shoulders the corridor without blocking sight down the road."},
	# --- Props — 9 pieces ----------------------------------------------
	{"key": "banner_shield_red", "family": FAMILY_DUNGEON, "contact": "base",
		"path": "res://assets/third_party/kaykit/dungeon/banner_shield_red.gltf",
		"reviewed_snap": 0.25, "blocks": "no", "carves": "no",
		"role": "The only object type that names WHOSE garrison this was rather than merely that soldiers passed through; hangs on masonry the scene already has. Authored to hang on masonry: it is laid on the ground here, then raised onto a wall in the Inspector."},
	{"key": "tree_dead_small", "family": FAMILY_HALLOWEEN, "contact": "plant",
		"path": "res://assets/third_party/kaykit/halloween/tree_dead_small.gltf",
		"reviewed_snap": 0.0, "blocks": "yes", "carves": "author",
		"role": "The low outer members of a dead-tree cluster, giving the grove a falling profile; also sparse growth along the converging boundary where anything taller pushes the terrain edge off the top of the frame."},
	{"key": "shrine", "family": FAMILY_HALLOWEEN, "contact": "base",
		"path": "res://assets/third_party/kaykit/halloween/shrine.gltf",
		"reviewed_snap": 1.0, "blocks": "yes", "carves": "author",
		"role": "A 2.400 m undecorated stone marker: the funerary overtone the fiction asks for without a single grave, and a punctuation point in the road between lantern posts."},
	{"key": "barrel_large", "family": FAMILY_DUNGEON, "contact": "base",
		"path": "res://assets/third_party/kaykit/dungeon/barrel_large.gltf",
		"reviewed_snap": 0.25, "blocks": "yes", "carves": "yes",
		"role": "The lone supply item left standing in the open road; a cylinder silhouette the cubic crates cannot give, and the anchor of an abandoned stores position."},
	{"key": "sword_shield_broken", "family": FAMILY_DUNGEON, "contact": "base",
		"path": "res://assets/third_party/kaykit/dungeon/sword_shield_broken.gltf",
		"reviewed_snap": 0.25, "blocks": "no", "carves": "no",
		"role": "Mounted broken arms — the clearest single statement that this was a military post and that it fell; planted in the ground it instead marks where a defender died. Authored to hang on masonry: it is laid on the ground here, then raised onto a wall in the Inspector."},
	{"key": "sword_shield", "family": FAMILY_DUNGEON, "contact": "base",
		"path": "res://assets/third_party/kaykit/dungeon/sword_shield.gltf",
		"reviewed_snap": 0.25, "blocks": "no", "carves": "no",
		"role": "A mounted sword and shield still whole. Hang one near the arrival end so the broken trophies further up the route read as damage rather than as how the garrison always looked. Authored to hang on masonry: it is laid on the ground here, then raised onto a wall in the Inspector."},
	{"key": "box_large", "family": FAMILY_DUNGEON, "contact": "base",
		"path": "res://assets/third_party/kaykit/dungeon/box_large.gltf",
		"reviewed_snap": 0.25, "blocks": "yes", "carves": "yes",
		"role": "A plain 1.5 m crate — an ingredient rather than a scene, so a supply pile can be composed at any arrangement and rotation, or a single crate can pinch a corridor edge."},
	{"key": "torch_mounted", "family": FAMILY_DUNGEON, "contact": "base",
		"path": "res://assets/third_party/kaykit/dungeon/torch_mounted.gltf",
		"reviewed_snap": 0.25, "blocks": "no", "carves": "no",
		"role": "The only wall-mounted light bracket; unlit brackets along the darkening approach are the cheapest statement that this place was tended and no longer is. Authored to hang on masonry: it is laid on the ground here, then raised onto a wall in the Inspector."},
	{"key": "box_small", "family": FAMILY_DUNGEON, "contact": "base",
		"path": "res://assets/third_party/kaykit/dungeon/box_small.gltf",
		"reviewed_snap": 0.25, "blocks": "author", "carves": "no",
		"role": "The second size step; tops and fills a crate pile at irregular heights, or scatters singly along a broken supply line."},
]
