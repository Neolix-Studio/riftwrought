class_name RogueliteSeededRunPlan
extends RogueliteRunPlan
## Riftwrought — Roguelite Replayability V1: the seed now SELECTS the rooms,
## and it is the only thing this class changes (decision D-222).
##
## THE ACCEPTED PLAN ALREADY DID EVERYTHING EXCEPT SELECT. `RogueliteRunPlan`
## already carries an integer seed, already derives a short human-readable run
## id through a pure function, already shows that id on screen, already
## reproduces it exactly from the same seed, already reads neither the clock
## nor an unseeded generator, and already names `ordered_modules()` as "THE ONE
## FUNCTION A FUTURE SHUFFLE SYSTEM REPLACES". This class is that replacement,
## and it is exactly one function wide, as promised.
##
## WHAT THE SEED DOES, PRECISELY: for each beat in the FIXED order
## opening -> reward -> elite, it advances one pure 32-bit avalanche step and
## indexes that beat's authored variant list. Three beats, three authored rooms
## each, 27 reproducible routes. Nothing is generated, nothing is connected,
## nothing is validated at run time and nothing is random.
##
## THE ORDER IS NOT SHUFFLED, AND THE TWO CLAIMS ARE KEPT APART ON PURPOSE.
## `is_shuffled()` answers the question the accepted plan asked — *does
## `ordered_modules()` consult the seed?* — and the honest answer is now YES.
## `is_reordered()` answers the question a reader might assume that means, and
## the answer is NO: the beat spine is opening -> reward -> elite in every run
## for every seed, and `selection_mode()` says exactly that on screen. A run
## that claimed to shuffle its beats while quietly keeping them in order would
## be the same trap the accepted plan refused, pointed the other way.
##
## `_mix()` IS INHERITED AND REUSED RATHER THAN RE-DERIVED. The accepted plan's
## avalanche already produces the run identifiers the owner reads back; using a
## second, different mixer for selection would mean two hashes to reason about
## and two ways for a "reproducible" claim to be subtly wrong. The selection
## stream is separated from the identity stream by one constant salt instead.
##
## STILL ABSENT, AND DELIBERATELY: no Run Graph, no Dungeon Recipe, no room
## pool beyond the nine authored rooms, no connector solving, no branch, no
## optional room, no depth, no difficulty curve, no procedural terrain, no
## endless mode, and no persistence. Those are first-MVP systems with their own
## authorization.

## Separates the selection stream from the identity stream, so two runs whose
## ids happen to look alike cannot share a route for that reason. The value is
## the standard 32-bit golden-ratio constant and carries no other meaning.
const SELECTION_SALT: int = 0x9E37_79B9


func _init(for_seed: int = RogueliteRunPlan.BASE_SEED, index: int = 0) -> void:
	super(for_seed, index)


## The next run in this session, as a SEEDED plan. The accepted base returns a
## `RogueliteRunPlan`, which would silently drop the selection behaviour on the
## second run of a session — every run after the first would have used the
## authored order and the review would have proved nothing.
func next() -> RogueliteRunPlan:
	return RogueliteSeededRunPlan.new(_mix(seed_value), run_index + 1)


## The pure selection stream for beat `index`: the seed, salted once, then
## advanced one avalanche step per beat. Pure and total — the same plan answers
## identically however many times it is asked, and no engine RNG, clock,
## filesystem or global state is involved.
func _beat_stream(index: int) -> int:
	var stream: int = _mix((seed_value & 0xFFFFFFFF) ^ SELECTION_SALT)
	for step: int in index + 1:
		stream = _mix(stream)
	return stream


## THE ONE FUNCTION THE ACCEPTED PLAN NAMED, NOW REPLACED. One authored room
## per beat, in the fixed beat order, chosen by the seed.
func ordered_modules() -> Array[StringName]:
	var order: Array[StringName] = []
	for index: int in RogueliteRoomLibrary.BEAT_ORDER.size():
		var beat: StringName = RogueliteRoomLibrary.BEAT_ORDER[index]
		var variants: Array[StringName] = RogueliteRoomLibrary.variants_for(beat)
		if variants.is_empty():
			continue
		order.append(variants[_beat_stream(index) % variants.size()])
	return order


## The beats this plan fills, in order. Always the authored spine.
func ordered_beats() -> Array[StringName]:
	var beats: Array[StringName] = []
	for beat: StringName in RogueliteRoomLibrary.BEAT_ORDER:
		beats.append(beat)
	return beats


## Does `ordered_modules()` consult the seed? Yes, now.
func is_shuffled() -> bool:
	return true


## Does the seed change the ORDER of the beats? No, and it never will in V1.
func is_reordered() -> bool:
	return false


func selection_mode() -> String:
	return ("seeded room selection — one of %d authored rooms per beat, %d routes; "
		+ "the beat order (opening → reward → elite) is fixed and is never shuffled") % [
		RogueliteRoomLibrary.variants_for(RogueliteRoomLibrary.BEAT_ORDER[0]).size(),
		RogueliteRoomLibrary.total_routes(),
	]


func room_count() -> int:
	return RogueliteRoomLibrary.BEAT_ORDER.size()


## The route as plain-language room names, e.g. "Pillar Court → Spine Vault →
## Ring Hall". The HUD and the run summary both read this, so the route the
## player is told about is derived from the same function the runtime obeys.
func route_names() -> PackedStringArray:
	var names: PackedStringArray = PackedStringArray()
	for id: StringName in ordered_modules():
		names.append(RogueliteRoomLibrary.display_name_of(id))
	return names


func route_line() -> String:
	return " → ".join(route_names())


## Returns "" when the plan is coherent, or the first problem found. It checks
## what the accepted base checked — the hub still exists and is still a hub —
## and then the two things only a seeded plan can get wrong: that it filled
## every beat, and that every room it chose belongs to the beat it was chosen
## for. "Category-preserving" is therefore an assertion the plan makes about
## itself on every construction, not only a claim the report makes.
func problem() -> String:
	var library: String = RogueliteRoomLibrary.problem()
	if not library.is_empty():
		return library
	if not RogueliteRoomModule.MODULES.has(RogueliteRunPlan.HUB_MODULE):
		return "the hub module %s is not in the accepted module records" % RogueliteRunPlan.HUB_MODULE
	if String(RogueliteRoomModule.MODULES[RogueliteRunPlan.HUB_MODULE]["kind"]) != "hub":
		return "%s is not a hub module" % RogueliteRunPlan.HUB_MODULE
	var selected: Array[StringName] = ordered_modules()
	if selected.size() != RogueliteRoomLibrary.BEAT_ORDER.size():
		return "the plan selected %d room(s) for %d beat(s)" % [
			selected.size(), RogueliteRoomLibrary.BEAT_ORDER.size(),
		]
	for index: int in selected.size():
		var id: StringName = selected[index]
		var wanted: StringName = RogueliteRoomLibrary.BEAT_ORDER[index]
		if not RogueliteRoomLibrary.has_variant(id):
			return "unknown room %s in the selected route" % id
		if RogueliteRoomLibrary.beat_of(id) != wanted:
			return "%s is a %s room and cannot fill the %s beat" % [
				id, RogueliteRoomLibrary.beat_of(id), wanted,
			]
	return ""


func describe() -> String:
	return "%s — seed 0x%08X, %d room(s): %s" % [
		run_id(), seed_value & 0xFFFFFFFF, room_count(), route_line(),
	]
