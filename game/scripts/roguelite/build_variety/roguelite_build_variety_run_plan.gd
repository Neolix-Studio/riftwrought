class_name RogueliteBuildVarietyRunPlan
extends RogueliteSeededRunPlan
## Riftwrought — Roguelite Build Variety V1: the seed now selects the ROOMS and
## the OFFERS, and offers are the only thing this class adds (decision D-223).
##
## THE ACCEPTED PLANS ALREADY DID EVERYTHING EXCEPT OFFER. `RogueliteRunPlan`
## carries the seed, the run identity and the pure avalanche mixer;
## `RogueliteSeededRunPlan` (D-222) replaced `ordered_modules()` and made the
## route a seeded selection. Neither is edited. This class adds exactly one
## public function, `offer_for()`, and overrides `next()` for the reason D-222
## recorded for itself.
##
## `_mix()` IS INHERITED AND REUSED RATHER THAN RE-DERIVED — third time, same
## reason. Using a second hash for offers would mean two avalanches to reason
## about and two ways for a "reproducible" claim to be subtly wrong. The offer
## stream is separated from the SELECTION stream (D-222's `SELECTION_SALT`) and
## from the IDENTITY stream by one further constant salt, so a seed whose route
## happens to look familiar cannot share an offer for that reason.
##
##
## WHAT "THE SAME SEED REPRODUCES THE OFFERS" MEANS, EXACTLY, AND THE NUANCE IS
## STATED RATHER THAN LEFT TO BE DISCOVERED
## ---------------------------------------------------------------------------
## `offer_for()` is a PURE FUNCTION OF THREE THINGS: the seed, the choice index,
## and the set of upgrades already held. The first two are the seed's. The third
## is the PLAYER'S — it is the choice they just made.
##
## So the honest claim is this, and it is the claim the verification proves:
##
##   * The FIRST offer of a run depends on the seed alone. The same seed always
##     produces the same first pair, in the same order.
##   * The SECOND offer depends on the seed AND on which upgrade was taken from
##     the first. The same seed plus the same first pick always produces the
##     same second pair.
##   * A different first pick may produce a different second pair, and MUST
##     produce a different pair whenever the taken upgrade was in it — because
##     an upgrade already held is never offered again.
##
## A design that made the second offer independent of the first pick could only
## do it by ignoring what the player holds, which is exactly the rule the brief
## forbids. The dependency is therefore the requirement working, not a weakness
## in the reproduction.
##
##
## HOW A PAIR IS DRAWN, AND WHY IT CANNOT PRODUCE A DUPLICATE
## ---------------------------------------------------------------------------
## The candidate list is `RogueliteBuildState.available()` — the authored pool
## in its stable order, minus everything held. The stream picks one, that one is
## REMOVED from the list, and the advanced stream picks the second from what is
## left. Distinctness is therefore a property of the algorithm rather than a
## test after the fact: there is no branch in which the same upgrade can be
## drawn twice, and no branch in which a held upgrade can be drawn at all.
##
## STILL ABSENT, AND DELIBERATELY: no weights, no rarity, no reroll, no shop, no
## currency, no pity timer, no scaling with depth, no upgrade levels, no
## synergies table, and no pool beyond the four authored upgrades.

## Separates the OFFER stream from D-222's selection stream and from the
## identity stream. The value is the 32-bit fractional part of sqrt(2) and
## carries no other meaning; only its distinctness matters.
const OFFER_SALT: int = 0x6A09_E667

## How many temporary-upgrade choices one expedition presents. Two, and the
## brief fixes both their positions: after the opening room and after the reward
## room. It is a constant rather than a tuning value — a third choice is a
## different instrument with its own authorization.
const CHOICES_PER_RUN: int = 2

## How many options each choice presents. Exactly two, as authorized.
const OPTIONS_PER_CHOICE: int = 2


func _init(for_seed: int = RogueliteRunPlan.BASE_SEED, index: int = 0) -> void:
	super(for_seed, index)


## The next run in this session, as a BUILD-VARIETY plan. D-222 recorded why
## this override has to exist at all: the base returns its own class, which
## would silently drop the added behaviour on the second run of a session — here
## every run after the first would have fallen back to the seeded plan and
## `offer_for()` would never have been reached again.
func next() -> RogueliteRunPlan:
	return RogueliteBuildVarietyRunPlan.new(_mix(seed_value), run_index + 1)


## The pure offer stream for choice `index`: the seed, salted once for offers,
## then advanced one avalanche step per choice. Pure and total — the same plan
## answers identically however many times it is asked, and no engine RNG, clock,
## filesystem or global state is involved.
func _offer_stream(index: int) -> int:
	var stream: int = _mix((seed_value & 0xFFFFFFFF) ^ OFFER_SALT)
	for step: int in index + 1:
		stream = _mix(stream)
	return stream


## THE ONE FUNCTION THIS CLASS ADDS. Returns exactly `OPTIONS_PER_CHOICE`
## distinct upgrade kinds, none of them in `held`, deterministically.
##
## `held` is passed in rather than read from anywhere, which is what keeps this
## a pure function: the same arguments always produce the same pair, so the
## checks can call it a hundred times, or construct two independent plans and
## compare them, without a runtime existing at all.
func offer_for(index: int, held: Array[int]) -> Array[int]:
	var available: Array[int] = []
	for kind: int in RogueliteUpgrade.POOL:
		if not held.has(kind):
			available.append(kind)
	var offered: Array[int] = []
	var stream: int = _offer_stream(index)
	for slot: int in OPTIONS_PER_CHOICE:
		if available.is_empty():
			break
		var at: int = stream % available.size()
		offered.append(available[at])
		available.remove_at(at)
		stream = _mix(stream)
	return offered


## Returns "" when the plan is coherent, or the first problem found. It checks
## everything the seeded base checks — the library, the hub, one room per beat,
## every room belonging to the beat it filled — and then the two things only an
## OFFERING plan can get wrong, on a full walk of every reachable held-set:
## that every choice can actually be filled, and that no offer ever repeats or
## re-offers something held.
##
## "The pool is big enough" is checked here rather than assumed, because the two
## rules together are what make it a real constraint: two choices of two
## distinct options, none ever repeated, needs at least
## CHOICES_PER_RUN + OPTIONS_PER_CHOICE - 1 = 3 upgrades, and the pool has four.
func problem() -> String:
	var inherited: String = super()
	if not inherited.is_empty():
		return inherited
	if RogueliteUpgrade.POOL.size() < CHOICES_PER_RUN + OPTIONS_PER_CHOICE - 1:
		return "the pool of %d cannot fill %d choice(s) of %d without repeating" % [
			RogueliteUpgrade.POOL.size(), CHOICES_PER_RUN, OPTIONS_PER_CHOICE,
		]
	## Walks every held-set a real run can reach: the empty set at choice 0, and
	## then one set per upgrade that could have been taken from it. That is the
	## whole reachable space for two choices, so this is exhaustive rather than
	## a sample.
	var reachable: Array[Array] = [[] as Array[int]]
	for index: int in CHOICES_PER_RUN:
		var next_sets: Array[Array] = []
		for held: Array in reachable:
			var typed_held: Array[int] = []
			for kind: int in held:
				typed_held.append(kind)
			var offered: Array[int] = offer_for(index, typed_held)
			if offered.size() != OPTIONS_PER_CHOICE:
				return "choice %d offered %d option(s) instead of %d" % [
					index + 1, offered.size(), OPTIONS_PER_CHOICE,
				]
			if offered[0] == offered[1]:
				return "choice %d offered %s twice" % [
					index + 1, RogueliteUpgrade.name_of(offered[0]),
				]
			for kind: int in offered:
				if typed_held.has(kind):
					return "choice %d offered %s, which is already held" % [
						index + 1, RogueliteUpgrade.name_of(kind),
					]
				if not RogueliteUpgrade.POOL.has(kind):
					return "choice %d offered %d, which is not in the pool" % [index + 1, kind]
				var taken: Array[int] = typed_held.duplicate()
				taken.append(kind)
				next_sets.append(taken)
		reachable = next_sets
	return ""


## The first offer, as plain-language names, for the documented-seed table and
## for the launch banner. A run's SECOND offer cannot be named here, because it
## is not known until the player has chosen.
func opening_offer_names() -> PackedStringArray:
	var names: PackedStringArray = PackedStringArray()
	for kind: int in offer_for(0, [] as Array[int]):
		names.append(RogueliteUpgrade.name_of(kind))
	return names


func opening_offer_line() -> String:
	return " or ".join(opening_offer_names())


func selection_mode() -> String:
	return ("seeded rooms and seeded offers — one of %d authored rooms per beat, %d routes; "
		+ "%d choice(s) of %d from a pool of %d, never repeating; "
		+ "the beat order (opening → reward → elite) is fixed and is never shuffled") % [
		RogueliteRoomLibrary.variants_for(RogueliteRoomLibrary.BEAT_ORDER[0]).size(),
		RogueliteRoomLibrary.total_routes(),
		CHOICES_PER_RUN, OPTIONS_PER_CHOICE, RogueliteUpgrade.POOL.size(),
	]


func describe() -> String:
	return "%s — seed 0x%08X, %d room(s): %s; first offer: %s" % [
		run_id(), seed_value & 0xFFFFFFFF, room_count(), route_line(), opening_offer_line(),
	]
