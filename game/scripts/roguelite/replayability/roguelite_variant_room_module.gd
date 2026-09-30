class_name RogueliteVariantRoomModule
extends RogueliteRoomModule
## Riftwrought — Roguelite Replayability V1: the accepted module builder,
## reading one more record source (decision D-222).
##
## THIS CLASS OVERRIDES EXACTLY ONE FUNCTION, AND THAT IS THE ENTIRE DESIGN.
## `RogueliteRoomModule` funnels every single thing it builds — ground plates,
## the derived perimeter walls, the walkable subtraction that opens a seam by
## construction, pillars, the gate frame and curtain, the sockets, the grid,
## the per-solid navigation carve, the exact union-area arithmetic and every
## measurement the verification reads — through `record()`. Overriding
## `record()` therefore adds nine authored rooms while leaving all 648 lines of
## the accepted, playtested builder byte-identical and completely unedited.
##
## The alternative was a second module class, and the project has already
## recorded what that costs: "a second subtly different copy of an accepted
## thing". `RogueliteRoomModule` is protected by the core loop's own runner and
## is not touched here.
##
## THE HUB FALLS THROUGH TO THE ACCEPTED RECORD, BY IDENTITY. An id this
## library does not know is answered by `super()`, which is the accepted
## `RogueliteRoomModule.MODULES` lookup and its assertion. So the Rift Nexus is
## literally the object the accepted review shipped — "the Nexus remains the
## safe run start and return point" is then a fact rather than a copy that
## could drift — and an unknown id still fails loudly instead of quietly
## building an empty room.
##
## `beat()` is the one thing this class adds, and it is read rather than
## configured: the runtime decides which enemy is the Elite from the MODULE's
## own beat, never from a run index, so a reselected route cannot move which
## enemy is the Elite.

func record() -> Dictionary:
	if RogueliteRoomLibrary.has_variant(module_id):
		return RogueliteRoomLibrary.record_for(module_id)
	return super()


## The beat this room fills, or `&""` for the hub — which belongs to no beat
## because it is not part of the expedition.
func beat() -> StringName:
	return RogueliteRoomLibrary.beat_of(module_id)


func is_variant() -> bool:
	return RogueliteRoomLibrary.has_variant(module_id)


func is_elite_room() -> bool:
	return beat() == RogueliteRoomLibrary.ELITE_BEAT


func is_reward_room() -> bool:
	return beat() == RogueliteRoomLibrary.REWARD_BEAT


## The extent of everything this module physically OCCUPIES, in the parent's
## frame: the walkable rectangles plus the derived perimeter walls, WITHOUT the
## 2 m margin `local_bounds()` adds for the navigation bake volume. This is the
## rectangle a "modules never touch" measurement must use — measuring on
## `bake_rect()` would under-report every gap by exactly 4 m and call two
## comfortably separated modules adjacent.
func occupied_rect() -> Rect2:
	return bake_rect().grow(-2.0)


func describe_variant() -> String:
	return "%s [%s] — %s" % [
		display_name(),
		RogueliteRoomLibrary.beat_caption(beat()) if is_variant() else "hub",
		describe(),
	]
