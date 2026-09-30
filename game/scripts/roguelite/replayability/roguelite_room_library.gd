class_name RogueliteRoomLibrary
extends RefCounted
## Riftwrought — Roguelite Replayability V1: the small AUTHORED room library
## the seed selects from (decision D-222).
##
## THIS FILE IS DATA, AND THAT IS THE WHOLE POINT. It holds no generator, no
## connector solver, no validation pass, no branching, no terrain synthesis and
## no room graph. It is a list of authored greybox rooms grouped into three
## BEATS — opening combat, reward combat, elite combat — and the entire
## "replayability" claim of this review is that a seed picks ONE room from each
## beat list. Adding a room is adding a record here; there is still exactly one
## module script and exactly one runtime.
##
## THE BEAT ORDER IS FIXED AND IS NOT SHUFFLED. `BEAT_ORDER` is
## opening -> reward -> elite, always, in every run, for every seed. What the
## seed changes is WHICH room fills each beat. That distinction is enforced by
## `RogueliteSeededRunPlan` (`is_shuffled()` true, `is_reordered()` false) and
## is stated on screen, because the project has already recorded what happens
## when a schedule is allowed to wear a generator's clothing.
##
## EVERY RECORD IS THE EXACT SHAPE `RogueliteRoomModule.MODULES` USES, plus one
## new key — `beat`. That is deliberate: `RogueliteVariantRoomModule` overrides
## `record()` and nothing else, so all 648 lines of the accepted module
## builder — derived perimeter walls, the walkable-subtraction that opens a
## seam BY CONSTRUCTION, the per-solid navigation carve that answers Gate 1A's
## open-topped well, the exact union-area arithmetic, the sockets, the grid —
## run completely unmodified over these records.
##
## THE HUB IS NOT IN THIS LIBRARY, AND THAT IS REUSE RATHER THAN AN OMISSION.
## The Rift Nexus stays the accepted `RogueliteRoomModule.MODULES[&"nexus_hub"]`
## record, by identity, unedited — "the Nexus remains the safe run start and
## return point" is then a fact about the same object the accepted review
## shipped, not a copy of it that could drift.
##
## GAMEPLAY DIFFERENCE COMES FROM GEOMETRY AND GROUPING ONLY. Cover, approach
## angle, room shape and where the two enemies stand. No new enemy family, no
## boss, no modifier, no hazard, no new asset, no VFX, no scaling: every
## Graveblade in every one of these rooms is the accepted
## `data/prototype_zero/graveblade.tres`, and the one Elite is the accepted
## `data/roguelite/graveblade_elite.tres` the core loop already ships.
##
## `Rect2` is an XZ footprint in the module's OWN LOCAL FRAME: `position.x` /
## `size.x` is local X and `position.y` / `size.y` is local Z, exactly as
## `RogueliteRoomModule`, `BrokenWatchLayout` and
## `RiftfallLandingGreyboxLayout` all read. Every room runs from local z = 0
## (entry end) toward negative z (exit end), so no composition yaw can move a
## measurement.

const BEAT_OPENING: StringName = &"opening"
const BEAT_REWARD: StringName = &"reward"
const BEAT_ELITE: StringName = &"elite"

## The fixed, category-preserving spine of every run. Never shuffled.
const BEAT_ORDER: Array[StringName] = [&"opening", &"reward", &"elite"]

## Plain-language beat captions, for the HUD route panel and the run summary.
const BEAT_CAPTIONS: Dictionary = {
	&"opening": "Opening",
	&"reward": "Reward",
	&"elite": "Elite",
}

## Which beat's room carries the guaranteed reward, and which carries the
## Elite. Held as beat names rather than as indices so they stay true if the
## beat list is ever extended.
const REWARD_BEAT: StringName = &"reward"
const ELITE_BEAT: StringName = &"elite"

## --- THE AUTHORED ROOMS ----------------------------------------------------
##
## Three per beat. Nine rooms, 27 possible routes, one authored library.
const VARIANTS: Dictionary = {
	# --- Opening beat: ONE Graveblade, and the room decides how you meet it ---
	&"opening_long_hall": {
		"display_name": "Long Hall",
		"subtitle": "One Graveblade, straight ahead. Learn Quick Strike.",
		"kind": "combat",
		"beat": &"opening",
		"walkable": [Rect2(Vector2(-10.0, -28.0), Vector2(20.0, 28.0))],
		"entry": Vector2(0.0, -3.5),
		"exit": Vector2(0.0, -26.4),
		"spawns": [Vector2(0.0, -17.0)],
		"pillars": [],
		"exit_caption": "continue",
	},
	&"opening_pillar_court": {
		"display_name": "Pillar Court",
		"subtitle": "One Graveblade behind cover, off the centre line.",
		"kind": "combat",
		"beat": &"opening",
		"walkable": [Rect2(Vector2(-11.0, -26.0), Vector2(22.0, 26.0))],
		"entry": Vector2(0.0, -3.5),
		"exit": Vector2(0.0, -24.2),
		"spawns": [Vector2(5.5, -15.0)],
		## Four masses in a diamond. The enemy is not visible from the entry on
		## a straight line, so the approach is broken up rather than walked.
		"pillars": [
			{"at": Vector2(-5.0, -9.0), "size": Vector2(2.2, 2.2)},
			{"at": Vector2(5.0, -9.0), "size": Vector2(2.2, 2.2)},
			{"at": Vector2(-5.0, -19.0), "size": Vector2(2.2, 2.2)},
			{"at": Vector2(5.0, -19.0), "size": Vector2(2.2, 2.2)},
		],
		"exit_caption": "continue",
	},
	&"opening_dogleg": {
		"display_name": "Dogleg",
		"subtitle": "One Graveblade around the corner. You meet it close.",
		"kind": "combat",
		"beat": &"opening",
		## Two rectangles sharing the z = -14 seam over x -4..4. The perimeter
		## opens there BY CONSTRUCTION — no author has to remember to split a
		## wall around it, which is the Gate 1E sealed-alcove lesson applied.
		"walkable": [
			Rect2(Vector2(-4.0, -14.0), Vector2(8.0, 14.0)),
			Rect2(Vector2(-4.0, -26.0), Vector2(22.0, 12.0)),
		],
		"entry": Vector2(0.0, -3.5),
		"exit": Vector2(14.0, -24.2),
		"spawns": [Vector2(9.0, -20.0)],
		"pillars": [{"at": Vector2(2.0, -20.0), "size": Vector2(2.0, 2.0)}],
		"exit_caption": "continue",
	},

	# --- Reward beat: TWO Graveblades, then the one temporary-reward choice ---
	&"reward_alcove": {
		"display_name": "Cache Vault",
		"subtitle": "Two Graveblades. The cache is behind them.",
		"kind": "combat",
		"beat": &"reward",
		"walkable": [
			Rect2(Vector2(-12.0, -22.0), Vector2(24.0, 22.0)),
			Rect2(Vector2(-4.0, -28.0), Vector2(8.0, 6.0)),
		],
		"entry": Vector2(0.0, -3.5),
		"exit": Vector2(0.0, -26.6),
		"spawns": [Vector2(-5.5, -12.5), Vector2(5.5, -15.0)],
		"pillars": [
			{"at": Vector2(-9.0, -17.5), "size": Vector2(1.5, 1.5)},
			{"at": Vector2(9.0, -8.5), "size": Vector2(1.5, 1.5)},
		],
		"exit_caption": "continue",
	},
	&"reward_spine": {
		"display_name": "Spine Vault",
		"subtitle": "Two Graveblades, split by a staggered spine.",
		"kind": "combat",
		"beat": &"reward",
		"walkable": [
			Rect2(Vector2(-13.0, -24.0), Vector2(26.0, 24.0)),
			Rect2(Vector2(-5.0, -31.0), Vector2(10.0, 7.0)),
		],
		"entry": Vector2(0.0, -3.5),
		"exit": Vector2(0.0, -29.4),
		## One each side of the spine, so they are met separately rather than
		## together — the same two enemies, a different fight.
		"spawns": [Vector2(-7.5, -16.0), Vector2(7.5, -11.0)],
		"pillars": [
			## A STAGGERED spine rather than a central one, and the reason is a
			## measured defect rather than a style choice: a single 2 x 12 m
			## mass on the centre line covered the room rectangle's OWN CENTRE,
			## and the reachability check — which walks to the centre of every
			## authored rectangle — correctly reported it as unreachable. Two
			## offset masses give the same "the two enemies arrive separately"
			## reading, add a weave to the walk, and leave the centre walkable.
			## The standing authoring rule this produced: NO PILLAR MAY COVER
			## THE CENTRE OF ITS OWN WALKABLE RECTANGLE.
			{"at": Vector2(-3.0, -16.0), "size": Vector2(2.0, 10.0)},
			{"at": Vector2(3.0, -8.0), "size": Vector2(2.0, 10.0)},
			{"at": Vector2(-9.5, -5.5), "size": Vector2(1.6, 1.6)},
			{"at": Vector2(9.5, -5.5), "size": Vector2(1.6, 1.6)},
		],
		"exit_caption": "continue",
	},
	&"reward_crossing": {
		"display_name": "Crossing Cache",
		"subtitle": "Two Graveblades converge from the side arms.",
		"kind": "combat",
		"beat": &"reward",
		## A cross: a long central lane with a west and an east arm meeting it.
		"walkable": [
			Rect2(Vector2(-5.0, -30.0), Vector2(10.0, 30.0)),
			Rect2(Vector2(-16.0, -20.0), Vector2(11.0, 10.0)),
			Rect2(Vector2(5.0, -20.0), Vector2(11.0, 10.0)),
		],
		"entry": Vector2(0.0, -3.5),
		"exit": Vector2(0.0, -28.4),
		"spawns": [Vector2(-10.5, -15.0), Vector2(10.5, -15.0)],
		"pillars": [],
		"exit_caption": "continue",
	},

	# --- Elite beat: the heavier Graveblade and one escort ---------------------
	&"elite_broad_hall": {
		"display_name": "Broad Hall",
		"subtitle": "A heavier Graveblade, and one escort.",
		"kind": "combat",
		"beat": &"elite",
		"walkable": [Rect2(Vector2(-13.0, -30.0), Vector2(26.0, 30.0))],
		"entry": Vector2(0.0, -3.5),
		"exit": Vector2(0.0, -28.4),
		## Index 0 of an elite-beat room is the Elite; the runtime reads it that
		## way, from the module's BEAT rather than from a run index, so a
		## reselected route cannot move which enemy is the Elite.
		"spawns": [Vector2(0.0, -18.0), Vector2(-7.0, -12.5)],
		"pillars": [
			{"at": Vector2(-8.0, -21.0), "size": Vector2(1.5, 1.5)},
			{"at": Vector2(8.0, -21.0), "size": Vector2(1.5, 1.5)},
		],
		"exit_caption": "return to the Nexus",
	},
	&"elite_split": {
		"display_name": "Split Hall",
		"subtitle": "The escort meets you first. Two masses break the line to the heavier one.",
		"kind": "combat",
		"beat": &"elite",
		"walkable": [Rect2(Vector2(-14.0, -32.0), Vector2(28.0, 32.0))],
		"entry": Vector2(0.0, -3.5),
		"exit": Vector2(0.0, -30.4),
		"spawns": [Vector2(0.0, -26.0), Vector2(7.0, -8.0)],
		## TWO masses with a 4 m slot between them, rather than one central
		## block — the same measured reason `reward_spine` is staggered: a
		## single 10 x 10 m mass on the centre line covered the room
		## rectangle's own centre and baked it unreachable. Two masses give
		## three routes through (a 4 m centre slot and a 4 m lane each side),
		## which is a better kiting room than one block anyway, and leave the
		## centre walkable.
		"pillars": [
			{"at": Vector2(-6.0, -16.0), "size": Vector2(8.0, 11.0)},
			{"at": Vector2(6.0, -16.0), "size": Vector2(8.0, 11.0)},
		],
		"exit_caption": "return to the Nexus",
	},
	&"elite_pinch": {
		"display_name": "Pinch Hall",
		"subtitle": "The escort holds a 7 m throat. The heavier one is past it.",
		"kind": "combat",
		"beat": &"elite",
		"walkable": [
			Rect2(Vector2(-12.0, -16.0), Vector2(24.0, 16.0)),
			Rect2(Vector2(-3.5, -22.0), Vector2(7.0, 6.0)),
			Rect2(Vector2(-11.0, -34.0), Vector2(22.0, 12.0)),
		],
		"entry": Vector2(0.0, -3.5),
		"exit": Vector2(0.0, -32.4),
		"spawns": [Vector2(0.0, -28.0), Vector2(0.0, -19.0)],
		"pillars": [
			{"at": Vector2(-6.0, -27.0), "size": Vector2(1.6, 1.6)},
			{"at": Vector2(6.0, -27.0), "size": Vector2(1.6, 1.6)},
		],
		"exit_caption": "return to the Nexus",
	},
}


static func has_variant(id: StringName) -> bool:
	return VARIANTS.has(id)


static func record_for(id: StringName) -> Dictionary:
	return VARIANTS[id]


static func beat_of(id: StringName) -> StringName:
	if not VARIANTS.has(id):
		return &""
	return VARIANTS[id]["beat"]


## Every authored room for one beat, in a stable authored order. The seed
## indexes into THIS array, so the mapping from seed to room is reproducible
## for as long as the array is not reordered.
static func variants_for(beat: StringName) -> Array[StringName]:
	var found: Array[StringName] = []
	for id: StringName in VARIANTS:
		if StringName(VARIANTS[id]["beat"]) == beat:
			found.append(id)
	return found


static func display_name_of(id: StringName) -> String:
	if not VARIANTS.has(id):
		return String(id)
	return String(VARIANTS[id]["display_name"])


static func beat_caption(beat: StringName) -> String:
	return String(BEAT_CAPTIONS.get(beat, String(beat)))


static func total_routes() -> int:
	var routes: int = 1
	for beat: StringName in BEAT_ORDER:
		routes *= variants_for(beat).size()
	return routes


## Returns "" when the library is coherent, or the first problem found — the
## same `problem()` contract every record in this project carries, so a bad
## edit fails loudly rather than quietly producing a run with a missing beat.
static func problem() -> String:
	if BEAT_ORDER.size() < 3:
		return "a run must contain the three authored beats"
	for beat: StringName in BEAT_ORDER:
		var variants: Array[StringName] = variants_for(beat)
		if variants.size() < 2:
			return "beat %s has %d variant(s); the review requires at least two" % [beat, variants.size()]
	for id: StringName in VARIANTS:
		var record: Dictionary = VARIANTS[id]
		for key: String in [
			"display_name", "subtitle", "kind", "beat", "walkable",
			"entry", "exit", "spawns", "pillars", "exit_caption",
		]:
			if not record.has(key):
				return "%s is missing the %s key" % [id, key]
		if String(record["kind"]) != "combat":
			return "%s is not a combat room; every expedition room must be one" % id
		if not BEAT_ORDER.has(StringName(record["beat"])):
			return "%s names an unknown beat %s" % [id, record["beat"]]
		if (record["walkable"] as Array).is_empty():
			return "%s has no walkable rectangle" % id
		if (record["spawns"] as Array).is_empty():
			return "%s has no encounter socket; every expedition room is a combat room" % id
		if record["entry"] == record["exit"]:
			return "%s has no distinct entry and exit point" % id
		## The reward beat's own guaranteed drop is laid a stated distance back
		## from the gate along the walked line; a beat with no rooms would make
		## that unreachable rather than merely wrong.
		if RogueliteRoomModule.MODULES.has(id):
			return "%s collides with an accepted core-loop module id" % id
	return ""


static func describe() -> String:
	var parts: PackedStringArray = PackedStringArray()
	for beat: StringName in BEAT_ORDER:
		parts.append("%s %d" % [beat_caption(beat), variants_for(beat).size()])
	return "%d authored room(s) across %d beat(s) (%s) — %d possible route(s)" % [
		VARIANTS.size(), BEAT_ORDER.size(), ", ".join(parts), total_routes(),
	]
