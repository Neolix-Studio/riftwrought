class_name SkillConfiguration
extends RefCounted

## A SKILL CONFIGURATION — exactly one Skill Imprint, up to four shared modifier
## slots, at most one Transform, and its own Effective Ranks.
##
## ============================================================================
## THE THREE CANONICAL RULES THIS OBJECT EXISTS TO ENFORCE.
## ============================================================================
##   1. EXACTLY ONE Skill Imprint.
##   2. UP TO FOUR total modifier slots, SHARED by Augment and Transform
##      Imprints. `design/SKILLS_AND_SKILL_MODIFICATION.md` section 17:
##      "A Transform Augment occupies one of the Configuration's globally
##       available Augment positions. It is not an additional fifth position."
##   3. AT MOST ONE TRANSFORM. Section 8: "A Skill Configuration may normally
##      contain no more than one Transform Augment."
##
## ---------------------------------------------------------------------------
## EFFECTIVE RANK IS PER CONFIGURATION. MASTERED RANK IS PER IMPRINT.
## ---------------------------------------------------------------------------
## The mastery record lives in the `ImprintLibrary`, keyed by Imprint id. The
## SELECTION lives here. That is the whole of the owner's requirement that
## levelling an Imprint must not brick it: mastering rank 20 only ever ADDS
## selectable ranks, and each Configuration keeps its own choice.
##
## ---------------------------------------------------------------------------
## ONE DOCUMENTED PIPELINE. SLOT POSITION ESTABLISHES NO SECRET ORDER.
## ---------------------------------------------------------------------------
## Canon, section 17: "Augment facet position does not establish a secret
## evaluation order. The complete selected set resolves through one documented
## rules pipeline."
##
## `resolve()` therefore runs the SEVEN STAGES named in its own comment, by RULE
## CATEGORY and never by slot index -- and the suite installs the same set in a
## different order and asserts the resolved block is IDENTICAL.
##
## ---------------------------------------------------------------------------
## A TRANSFORM THAT REMOVES AN ENABLING TAG DOES NOT DELETE ITS DEPENDENT.
## ---------------------------------------------------------------------------
## Canon, section 17: "Removing an enabling Augment does not silently delete a
## dependent Augment; the resulting invalid set must be reviewed and resolved
## before application."
##
## So `install()` judges a modifier against the tags present WHEN IT IS
## INSTALLED, and `validate()` judges the WHOLE SET afterwards. A Transform that
## strips `Projectile` leaves a projectile Augment in place and the Configuration
## EXPLICITLY INVALID -- which is the canonical behaviour, not a bug.
##
## EVERY NUMBER IT PRODUCES IS PROVISIONAL. NOTHING HERE IS FINAL BALANCE.

## The seven pipeline stages, named so a check can assert there are seven and
## that they are applied by category.
const PIPELINE_STAGES := [
	"1. tags and targeting (Transforms)",
	"2. geometry and count",
	"3. behaviour",
	"4. duration",
	"5. damage",
	"6. cost",
	"7. reservation resource",
]

var id: String = ""
var library: ImprintLibrary = null

var skill_id: String = ""
var modifier_ids: Array[String] = []

## Imprint id -> Effective Rank, chosen INDEPENDENTLY PER CONFIGURATION.
var _effective: Dictionary = {}

## Diagnostics the suite and the panel read.
var installs: int = 0
var installs_refused: int = 0
var removals: int = 0
var rank_selections_refused: int = 0
var last_refusal: String = ""

func _init(p_id: String, p_library: ImprintLibrary) -> void:
	id = p_id
	library = p_library

# ------------------------------------------------------------- composition ---

## Sets the ONE Skill Imprint. Refuses anything that is not a Skill Imprint, and
## refuses replacing one that is already set -- a Configuration with two Skill
## Imprints, even transiently, is not a thing this object may represent.
func set_skill(p_skill_id: String) -> Dictionary:
	if skill_id != "":
		return _refuse("a Configuration contains EXACTLY ONE Skill Imprint, and '%s' is already set"
			% skill_id)
	if not library.knows(p_skill_id):
		return _refuse("'%s' is not in the Imprint Library" % p_skill_id)
	var imp := library.get_imprint(p_skill_id)
	if imp.kind != Imprint.Kind.SKILL:
		return _refuse("'%s' is a %s, not a SKILL IMPRINT" % [p_skill_id, imp.kind_name()])
	skill_id = p_skill_id
	_effective[p_skill_id] = library.mastered(p_skill_id)
	return {"ok": true, "reason": ""}

func skill() -> Imprint:
	return library.get_imprint(skill_id) if skill_id != "" else null

## ============================================================================
## THE INSTALL GATE. Every refusal states WHY, specifically.
## ============================================================================
## Canon, section 10: "An incompatible Augment explains why it cannot be
## installed" and "An invalid configuration cannot be equipped."
##
## The order of the tests is deliberate, so each negative control can be aimed
## at exactly one rule: the SLOT limit and the TRANSFORM limit are tested
## separately, and a test that wants the slot refusal must use four Augments
## rather than three Augments and a Transform.
func install(modifier_id: String) -> Dictionary:
	if skill_id == "":
		return _refuse("a modifier cannot be installed before the Configuration has its Skill Imprint")
	if not library.knows(modifier_id):
		return _refuse("'%s' is not in the Imprint Library" % modifier_id)
	var imp := library.get_imprint(modifier_id)
	if not imp.is_modifier():
		return _refuse("'%s' is a %s, not a modifier" % [modifier_id, imp.kind_name()])
	if modifier_ids.has(modifier_id):
		return _refuse("'%s' is already installed in this Configuration; a learned Imprint is reusable ACROSS Configurations, not duplicable WITHIN one"
			% modifier_id)
	# RULE 2 — the four shared slots.
	if modifier_ids.size() >= ImprintConfig.CANON_MODIFIER_SLOTS_MAX:
		return _refuse("the Configuration already holds %d of %d modifier slots; a FIFTH modifier is refused (canonical: four slots, shared by Augment and Transform Imprints)"
			% [modifier_ids.size(), ImprintConfig.CANON_MODIFIER_SLOTS_MAX])
	# RULE 3 — at most one Transform, and it is NOT a fifth position.
	if imp.is_transform() and transform_count() >= ImprintConfig.CANON_TRANSFORMS_MAX_PER_CONFIGURATION:
		return _refuse("the Configuration already holds %d Transform Imprint(s); a SECOND TRANSFORM is refused (canonical maximum: %d per Configuration)"
			% [transform_count(), ImprintConfig.CANON_TRANSFORMS_MAX_PER_CONFIGURATION])
	# TAG COMPATIBILITY, against the tags resolved RIGHT NOW.
	var missing := _missing_tags(imp, resolved_tags())
	if not missing.is_empty():
		return _refuse("'%s' requires %s; this Configuration resolves to %s, so %s %s missing"
			% [modifier_id, str(imp.requires_tags), str(resolved_tags()), str(missing),
			   "is" if missing.size() == 1 else "are"])
	# CLASS COMPATIBILITY, for the reservation family canon gives no tag for.
	if not imp.requires_classes.is_empty():
		var sk := skill()
		if not imp.requires_classes.has(sk.skill_class):
			var want: Array[String] = []
			for c in imp.requires_classes:
				want.append(Imprint.CLASS_NAMES[c])
			return _refuse("'%s' requires a %s Configuration; '%s' is %s"
				% [modifier_id, str(want), skill_id, sk.class_name_text()])
	modifier_ids.append(modifier_id)
	_effective[modifier_id] = library.mastered(modifier_id)
	installs += 1
	return {"ok": true, "reason": ""}

func remove(modifier_id: String) -> Dictionary:
	if not modifier_ids.has(modifier_id):
		return _refuse("'%s' is not installed in this Configuration" % modifier_id)
	modifier_ids.erase(modifier_id)
	_effective.erase(modifier_id)
	removals += 1
	return {"ok": true, "reason": ""}

func _refuse(reason: String) -> Dictionary:
	installs_refused += 1
	last_refusal = reason
	return {"ok": false, "reason": reason}

func modifier_count() -> int:
	return modifier_ids.size()

func slots_free() -> int:
	return ImprintConfig.CANON_MODIFIER_SLOTS_MAX - modifier_ids.size()

func transform_count() -> int:
	var n := 0
	for mid in modifier_ids:
		if (library.get_imprint(mid) as Imprint).is_transform():
			n += 1
	return n

func modifiers() -> Array:
	var out: Array = []
	for mid in modifier_ids:
		out.append(library.get_imprint(mid))
	return out

func imprint_ids() -> Array:
	var out: Array = []
	if skill_id != "":
		out.append(skill_id)
	out.append_array(modifier_ids)
	return out

static func _missing_tags(imp: Imprint, have: Array) -> Array:
	var missing: Array = []
	for t in imp.requires_tags:
		if not have.has(t):
			missing.append(t)
	return missing

# -------------------------------------------------------------- rank choice --

## Selects this Configuration's Effective Rank for one Imprint.
##
## ============================================================================
## EFFECTIVE RANK MAY NOT EXCEED MASTERED RANK. THE REFUSAL IS COUNTED.
## ============================================================================
## Silently clamping would make the rule unobservable, and an unobservable rule
## is not a rule. This REFUSES and says by how much.
func set_effective_rank(imprint_id: String, rank: int) -> Dictionary:
	if not imprint_ids().has(imprint_id):
		rank_selections_refused += 1
		return {"ok": false, "reason": "'%s' is not part of this Configuration" % imprint_id}
	var cap := library.mastered(imprint_id)
	if rank < ImprintConfig.RANK_MIN:
		rank_selections_refused += 1
		return {"ok": false, "reason": "Effective Rank %d is below the minimum of %d"
			% [rank, ImprintConfig.RANK_MIN]}
	if rank > cap:
		rank_selections_refused += 1
		return {"ok": false, "reason": "Effective Rank %d EXCEEDS the Mastered Rank of %d for '%s' (by %d)"
			% [rank, cap, imprint_id, rank - cap]}
	_effective[imprint_id] = rank
	return {"ok": true, "reason": ""}

func effective_rank(imprint_id: String) -> int:
	# Clamped on READ as well, so a mastery that was set up after a selection can
	# never leave a stale over-cap value readable anywhere.
	var chosen := int(_effective.get(imprint_id, ImprintConfig.RANK_MIN))
	return clampi(chosen, ImprintConfig.RANK_MIN, maxi(ImprintConfig.RANK_MIN,
		library.mastered(imprint_id)))

func skill_rank() -> int:
	return effective_rank(skill_id) if skill_id != "" else ImprintConfig.RANK_MIN

# ------------------------------------------------------- tags and targeting --

## Stage 1 of the pipeline, exposed on its own because the install gate needs it
## before the rest of the pipeline exists.
func resolved_tags() -> Array:
	var sk := skill()
	if sk == null:
		return []
	var tags: Array = []
	tags.append_array(sk.provides_tags)
	# Transforms first: they are what CHANGE the contract the others test against.
	for mid in modifier_ids:
		var imp := library.get_imprint(mid) as Imprint
		if not imp.is_transform():
			continue
		for t in imp.removes_tags:
			tags.erase(t)
		for t in imp.adds_tags:
			if not tags.has(t):
				tags.append(t)
	for mid in modifier_ids:
		var imp2 := library.get_imprint(mid) as Imprint
		if imp2.is_transform():
			continue
		for t in imp2.removes_tags:
			tags.erase(t)
		for t in imp2.adds_tags:
			if not tags.has(t):
				tags.append(t)
	return tags

func resolved_targeting() -> String:
	var sk := skill()
	if sk == null:
		return ""
	var t := sk.targeting
	for mid in modifier_ids:
		var imp := library.get_imprint(mid) as Imprint
		if imp.sets_targeting != "":
			t = imp.sets_targeting
	return t

func targeting_changed() -> bool:
	var sk := skill()
	return sk != null and resolved_targeting() != sk.targeting

# ---------------------------------------------------------------- validation --

## The WHOLE-SET judgment. `install()` guards one modifier at a time; this
## judges what the set became.
func validate() -> Dictionary:
	var problems: Array[String] = []
	if skill_id == "":
		problems.append("NO SKILL IMPRINT: a Configuration contains exactly one, and this has none")
	if modifier_ids.size() > ImprintConfig.CANON_MODIFIER_SLOTS_MAX:
		problems.append("TOO MANY MODIFIERS: %d installed, canonical maximum %d"
			% [modifier_ids.size(), ImprintConfig.CANON_MODIFIER_SLOTS_MAX])
	if transform_count() > ImprintConfig.CANON_TRANSFORMS_MAX_PER_CONFIGURATION:
		problems.append("TOO MANY TRANSFORMS: %d installed, canonical maximum %d"
			% [transform_count(), ImprintConfig.CANON_TRANSFORMS_MAX_PER_CONFIGURATION])
	if skill_id != "":
		var tags := resolved_tags()
		for mid in modifier_ids:
			var imp := library.get_imprint(mid) as Imprint
			# ============================================================
			# A MODIFIER IS JUDGED AGAINST THE TAGS IT OPERATED ON.
			# ============================================================
			# A Transform that REQUIRES `Projectile` and then REMOVES it is not
			# incompatible with itself -- it consumed a projectile Skill, which
			# is the point of it. Judging it against its own output would make
			# every tag-removing Transform self-invalidating, which is not what
			# canon describes.
			#
			# EVERY OTHER MODIFIER STILL SEES THE RESOLVED TAGS. A projectile
			# Augment sitting beside that Transform therefore DOES become
			# invalid -- and is NOT deleted -- which is exactly the canonical
			# "removing an enabling Augment does not silently delete a dependent
			# Augment" case.
			var view := tags.duplicate()
			for t in imp.removes_tags:
				if not view.has(t):
					view.append(t)
			var missing := _missing_tags(imp, view)
			if not missing.is_empty():
				# THIS IS THE CANONICAL "enabling tag removed" CASE, and the
				# message names the Imprint that removed it so the player can
				# resolve the set rather than guess.
				problems.append("INCOMPATIBLE: '%s' requires %s but the resolved set no longer provides %s%s"
					% [imp.display_name, str(imp.requires_tags), str(missing),
					   _blame_for(missing)])
			if not imp.requires_classes.is_empty() \
					and not imp.requires_classes.has((skill() as Imprint).skill_class):
				problems.append("INCOMPATIBLE: '%s' requires a different Configuration class than '%s'"
					% [imp.display_name, skill_id])
			if imp.affects.is_empty():
				problems.append("SILENT MODIFIER: '%s' declares no affected component, and no modifier may silently do nothing"
					% imp.display_name)
			# ============================================================
			# PURELY BENEFICIAL AUGMENTS ARE LEGAL. (D-378 OD-12; D-380)
			# ============================================================
			# From D-375 until D-380 a modifier with no stated tradeoff was
			# refused here as "FREE POWER" -- true when written, reading
			# canon section 9's "Augments are not free power" literally. D-378
			# OD-12 CLARIFIED that sentence: "Purely beneficial Augments are
			# allowed; not every Augment requires an explicit positive-and-
			# negative tradeoff -- the modifier slot and global Capacity are
			# already opportunity costs." The refusal is therefore REMOVED.
			# THE SILENT-MODIFIER REFUSAL ABOVE IS KEPT: a modifier that
			# affects NOTHING still cannot be installed as if it did something.
	for iid in imprint_ids():
		var chosen := int(_effective.get(iid, ImprintConfig.RANK_MIN))
		if chosen > library.mastered(iid):
			problems.append("RANK: Effective Rank %d exceeds the Mastered Rank %d for '%s'"
				% [chosen, library.mastered(iid), iid])
	return {"valid": problems.is_empty(), "problems": problems}

## Names which installed Imprint removed a tag another one needed. Without this
## the invalid set would be reported without saying who caused it, which is the
## "silently delete a dependent Augment" failure wearing a message.
func _blame_for(missing: Array) -> String:
	var blame: Array[String] = []
	for mid in modifier_ids:
		var imp := library.get_imprint(mid) as Imprint
		for t in missing:
			if imp.removes_tags.has(t):
				blame.append("'%s' removed %s" % [imp.display_name, t])
	if blame.is_empty():
		return ""
	return " — %s. THE DEPENDENT IMPRINT IS NOT DELETED: resolve the set." % ", ".join(blame)

func is_valid() -> bool:
	return bool(validate()["valid"])

# ------------------------------------------------------------------ capacity --

## Capacity cost: a base by Skill class, plus a per-modifier cost by Skill class.
##
## The ruling: "A primary Skill may consume more Capacity than a movement,
## utility or secondary Skill." Both halves scale with the class, so a primary
## Skill's modifiers are dearer as well as its base.
##
## NO TRANSFORM SURCHARGE (D-378 OD-10, "not adopted"): a Transform occupies ONE
## of the four shared slots and costs exactly what an Augment in that slot costs.
## "A Transform changes identity and is not necessarily strictly stronger." Rank-
## scaled Capacity at milestones is a D-378 TEST CANDIDATE and is NOT implemented:
## the cost does not read any Effective Rank.
func capacity_cost() -> int:
	var sk := skill()
	if sk == null:
		return 0
	var base := ImprintConfig.CAPACITY_BASE_SECONDARY
	var per := ImprintConfig.CAPACITY_PER_MODIFIER_SECONDARY
	match sk.skill_class:
		Imprint.SkillClass.PRIMARY:
			base = ImprintConfig.CAPACITY_BASE_PRIMARY
			per = ImprintConfig.CAPACITY_PER_MODIFIER_PRIMARY
		Imprint.SkillClass.PERSISTENT, Imprint.SkillClass.UTILITY:
			base = ImprintConfig.CAPACITY_BASE_PERSISTENT
			per = ImprintConfig.CAPACITY_PER_MODIFIER_PERSISTENT
	return base + per * modifier_ids.size()

func capacity_breakdown() -> String:
	var sk := skill()
	if sk == null:
		return "no Skill Imprint"
	return "%d base (%s Skill) + %d x %d per modifier = %d" % [_base_only(),
		sk.class_name_text(), modifier_ids.size(), _per_modifier(), capacity_cost()]

func _base_only() -> int:
	var sk := skill()
	if sk == null:
		return 0
	match sk.skill_class:
		Imprint.SkillClass.PRIMARY:
			return ImprintConfig.CAPACITY_BASE_PRIMARY
		Imprint.SkillClass.PERSISTENT, Imprint.SkillClass.UTILITY:
			return ImprintConfig.CAPACITY_BASE_PERSISTENT
	return ImprintConfig.CAPACITY_BASE_SECONDARY

func _per_modifier() -> int:
	var sk := skill()
	if sk == null:
		return 0
	match sk.skill_class:
		Imprint.SkillClass.PRIMARY:
			return ImprintConfig.CAPACITY_PER_MODIFIER_PRIMARY
		Imprint.SkillClass.PERSISTENT, Imprint.SkillClass.UTILITY:
			return ImprintConfig.CAPACITY_PER_MODIFIER_PERSISTENT
	return ImprintConfig.CAPACITY_PER_MODIFIER_SECONDARY

## `has_modifier` and `effective_rank` are plain methods rather than lambdas so
## the pipeline below reads as ordinary code and the suite can call either
## directly.
func has_modifier(mid: String) -> bool:
	return modifier_ids.has(mid)

## The PROVISIONAL Mana->Life conversion ratio at a conversion Imprint's
## Effective Rank (D-380). Multiplicative per rank, never below zero. The ~2x
## figure D-378 OD-06 says "may be tested" is a TEST CANDIDATE and is NOT this.
static func conversion_ratio_at(rank: int) -> float:
	return maxf(0.0, ImprintConfig.LIFE_CONVERSION_RATIO_AT_RANK_1
		* (1.0 + ImprintConfig.LIFE_CONVERSION_RATIO_PER_RANK * float(rank - 1)))

# ------------------------------------------------------------------- resolve --

## ============================================================================
## THE ONE DOCUMENTED RULES PIPELINE. SEVEN STAGES, BY CATEGORY.
## ============================================================================
## Stage order is fixed and is a property of the RULE, never of the slot the
## Imprint happens to occupy. The suite installs the same set in a different
## order and asserts this block comes out identical.
func resolve() -> Dictionary:
	var sk := skill()
	if sk == null:
		return {"delivery": "none", "notes": ["no Skill Imprint"]}
	var r := skill_rank()
	var out := {
		"skill_id": skill_id,
		"skill_name": sk.display_name,
		"skill_class": sk.class_name_text(),
		"rank": r,
		"tags": resolved_tags(),
		"targeting": resolved_targeting(),
		"targeting_base": sk.targeting,
		"damage": 0.0,
		"mana_cost": 0.0,
		"cooldown": 0.0,
		"action_duration": 0.0,
		"projectiles": 0,
		"spread_deg": 0.0,
		"fork_children": 0,
		"fork_generations": 0,
		"fork_fraction": 0.0,
		"duration": 0.0,
		"instances_max": 0,
		"fire_interval": 0.0,
		"beast_count": 0,
		"beast_damage_bonus": 0.0,
		"reserve_resource": "none",
		"reserve_fraction": 0.0,
		"reserve_amount": 0.0,
		"orbit_duration": 0.0,
		"orbit_pulse_interval": 0.0,
		"orbit_radius": 0.0,
		"rain_volleys": 0,
		# D-396: how many Kindred Hounds the Configuration sustains. 0 for every
		# other Skill; no modifier in this project changes it (Additional Minion
		# is out of scope, and the diagnostic Pack Instinct moves `beast_count`).
		"pack_size": 0,
		# D-402: the burning Ground's damage per second. 0.0 for every other
		# Skill; no modifier in this project changes it (Expanded Area and
		# Increased Duration are out of scope).
		"ground_dps": 0.0,
		# D-392: the release marker a Skill Use hands the ACCEPTED commitment.
		# Every diagnostic Configuration keeps the accepted 0.36 exactly as
		# `SkillRuntime.use_binding()` passed it from D-375 until D-392; only
		# Splinter Shot's DERIVED marker differs (below).
		"release_marker": ProdConfig.ATTACK_RELEASE_MARKER,
		"delivery": "none",
		"notes": [],
	}
	var notes: Array[String] = []

	# --- BASE, from the Skill Imprint at its Effective Rank ------------------
	match skill_id:
		DiagImprintContent.SKILL_STORM:
			out["damage"] = ImprintConfig.STORM_DAMAGE_AT_RANK_1 \
				+ ImprintConfig.STORM_DAMAGE_PER_RANK * float(r - 1)
			out["mana_cost"] = ImprintConfig.STORM_MANA_AT_RANK_1 \
				+ ImprintConfig.STORM_MANA_PER_RANK * float(r - 1)
			out["cooldown"] = maxf(0.10, ImprintConfig.STORM_COOLDOWN_AT_RANK_1
				+ ImprintConfig.STORM_COOLDOWN_PER_RANK * float(r - 1))
			out["action_duration"] = ImprintConfig.STORM_ACTION_DURATION
			out["projectiles"] = 1
			out["delivery"] = "projectile"
		DiagImprintContent.SKILL_BALLISTA:
			out["damage"] = ImprintConfig.BALLISTA_DAMAGE_AT_RANK_1 \
				+ ImprintConfig.BALLISTA_DAMAGE_PER_RANK * float(r - 1)
			out["mana_cost"] = ImprintConfig.BALLISTA_MANA_AT_RANK_1 \
				+ ImprintConfig.BALLISTA_MANA_PER_RANK * float(r - 1)
			out["cooldown"] = ImprintConfig.BALLISTA_COOLDOWN
			out["action_duration"] = ImprintConfig.BALLISTA_ACTION_DURATION
			out["duration"] = ImprintConfig.BALLISTA_DURATION_AT_RANK_1 \
				+ ImprintConfig.BALLISTA_DURATION_PER_RANK * float(r - 1)
			out["instances_max"] = ImprintConfig.BALLISTA_INSTANCES_MAX
			out["fire_interval"] = ImprintConfig.BALLISTA_FIRE_INTERVAL
			out["projectiles"] = 1
			out["delivery"] = "ballista"
		DiagImprintContent.SKILL_BEASTS:
			out["damage"] = ImprintConfig.BEAST_DAMAGE_AT_RANK_1 \
				+ ImprintConfig.BEAST_DAMAGE_PER_RANK * float(r - 1)
			out["mana_cost"] = ImprintConfig.BEAST_MANA_AT_RANK_1 \
				+ ImprintConfig.BEAST_MANA_PER_RANK * float(r - 1)
			out["cooldown"] = ImprintConfig.BEAST_COOLDOWN
			out["action_duration"] = ImprintConfig.BEAST_ACTION_DURATION
			out["beast_count"] = ImprintConfig.BEAST_COUNT_AT_RANK_1 \
				+ int(floor(float(r - 1) / float(ImprintConfig.BEAST_COUNT_RANK_STEP)))
			out["delivery"] = "beasts"
		# ================================================================
		# D-392 — SPLINTER SHOT, THE ONE CANONICAL SKILL IMPRINT.
		# ================================================================
		# UNMODIFIED in this slice: one arrow, no fork, no spread. Its timing
		# is the D-390/D-391 PROVISIONAL candidate and a DERIVED recovery; its
		# numbers are PROVISIONAL (`HuntressConfig.registry()`).
		HuntressContent.SKILL_SPLINTER_SHOT:
			out["damage"] = HuntressConfig.SPLINTER_DAMAGE_AT_RANK_1 \
				+ HuntressConfig.SPLINTER_DAMAGE_PER_RANK * float(r - 1)
			out["mana_cost"] = HuntressConfig.SPLINTER_MANA_AT_RANK_1 \
				+ HuntressConfig.SPLINTER_MANA_PER_RANK * float(r - 1)
			out["cooldown"] = HuntressConfig.SPLINTER_COOLDOWN_S
			out["action_duration"] = HuntressConfig.splinter_action_s()
			out["release_marker"] = HuntressConfig.splinter_release_marker()
			out["projectiles"] = 1
			out["delivery"] = "splinter_arrow"
		# ================================================================
		# D-396 — KINDRED HOUNDS, THE ONE CANONICAL PERSISTENT SKILL IMPRINT.
		# ================================================================
		# A PERCENTAGE of maximum Mana (the PROVISIONAL review candidate), which
		# stage 7 below turns into an amount -- or, with the Mana->Life
		# conversion installed, into a PROPORTIONAL Life reservation -- exactly
		# as it does for the accepted aura. The bite and the pack size are the
		# stage's PROVISIONAL values (`HoundConfig.registry()`). No activation:
		# the delivery names what the Configuration sustains, not a Skill Use.
		HoundContent.SKILL_KINDRED_HOUNDS:
			out["reserve_resource"] = "mana"
			out["reserve_fraction"] = HoundConfig.reserve_fraction_at(r)
			out["damage"] = HoundConfig.bite_damage_at(r)
			out["pack_size"] = HoundConfig.PACK_SIZE
			out["delivery"] = "kindred_hounds"
		# ================================================================
		# D-402 — CINDER FIELD, THE ONE CANONICAL TRAP SKILL IMPRINT.
		# ================================================================
		# A ground-targeted Fire SPELL delivered as a TRAP (D-385). UNMODIFIED in
		# this slice. `duration` is the BURNING GROUND's Duration and
		# `instances_max` the DORMANT trap cap -- canon's own two declarations for
		# a Duration/Ground effect. Its timing is DERIVED and its numbers are
		# PROVISIONAL (`CinderConfig.registry()`).
		CinderContent.SKILL_CINDER_FIELD:
			out["damage"] = CinderConfig.eruption_damage_at(r)
			out["ground_dps"] = CinderConfig.ground_dps_at(r)
			out["mana_cost"] = CinderConfig.mana_at(r)
			out["cooldown"] = CinderConfig.COOLDOWN_S
			out["action_duration"] = CinderConfig.action_s()
			out["release_marker"] = CinderConfig.release_marker()
			out["duration"] = CinderConfig.GROUND_DURATION_S
			out["instances_max"] = CinderConfig.INSTANCES_MAX
			out["delivery"] = "cinder_trap"
		DiagImprintContent.SKILL_AURA:
			out["reserve_resource"] = "mana"
			out["reserve_fraction"] = ImprintConfig.AURA_RESERVE_FRACTION_AT_RANK_1 \
				+ ImprintConfig.AURA_RESERVE_FRACTION_PER_RANK * float(r - 1)
			out["beast_damage_bonus"] = ImprintConfig.AURA_BEAST_DAMAGE_BONUS_AT_RANK_1 \
				+ ImprintConfig.AURA_BEAST_DAMAGE_BONUS_PER_RANK * float(r - 1)
			out["delivery"] = "aura"

	# --- STAGE 2. GEOMETRY AND COUNT ----------------------------------------
	if has_modifier(DiagImprintContent.AUG_SPLIT) and out["projectiles"] > 0:
		var sr: int = effective_rank(DiagImprintContent.AUG_SPLIT)
		# IDENTITY IS COMPLETE AT RANK 1: at least one extra projectile always.
		var extra := ImprintConfig.SPLIT_VOLLEY_EXTRA_AT_RANK_1 \
			+ int(floor(float(sr - 1) / float(ImprintConfig.SPLIT_VOLLEY_RANK_STEP)))
		out["projectiles"] = int(out["projectiles"]) + extra
		out["spread_deg"] = ImprintConfig.SPLIT_VOLLEY_SPREAD_DEG
		notes.append("Split Volley (rank %d): +%d projectile(s), %.1f deg spread"
			% [sr, extra, ImprintConfig.SPLIT_VOLLEY_SPREAD_DEG])
	if has_modifier(DiagImprintContent.AUG_PACK) and out["beast_count"] > 0:
		var pr: int = effective_rank(DiagImprintContent.AUG_PACK)
		out["beast_count"] = int(out["beast_count"]) + ImprintConfig.PACK_INSTINCT_EXTRA_BEASTS
		notes.append("Pack Instinct (rank %d): +%d beast" % [pr, ImprintConfig.PACK_INSTINCT_EXTRA_BEASTS])
	if has_modifier(DiagImprintContent.XF_RAIN):
		var rr: int = effective_rank(DiagImprintContent.XF_RAIN)
		out["rain_volleys"] = ImprintConfig.RAIN_VOLLEYS_AT_RANK_1 \
			+ int(floor(float(rr - 1) / float(ImprintConfig.RAIN_VOLLEY_RANK_STEP)))
		out["delivery"] = "rain"
		notes.append("Splinter Rain (rank %d): %d ground volley(s); TARGETING BECOMES %s"
			% [rr, out["rain_volleys"], out["targeting"]])

	# --- STAGE 3. BEHAVIOUR --------------------------------------------------
	if has_modifier(DiagImprintContent.AUG_FORK):
		var fr: int = effective_rank(DiagImprintContent.AUG_FORK)
		out["fork_children"] = ImprintConfig.FORK_CHILDREN
		out["fork_generations"] = ImprintConfig.FORK_MAX_GENERATIONS
		out["fork_fraction"] = ImprintConfig.FORK_DAMAGE_FRACTION_AT_RANK_1 \
			+ ImprintConfig.FORK_DAMAGE_FRACTION_PER_RANK * float(fr - 1)
		notes.append("Forking (rank %d): %d children on first impact, %d generation(s) MAXIMUM, %.0f%% damage"
			% [fr, out["fork_children"], out["fork_generations"], out["fork_fraction"] * 100.0])
	if has_modifier(DiagImprintContent.XF_ORBIT):
		var orr: int = effective_rank(DiagImprintContent.XF_ORBIT)
		out["orbit_duration"] = ImprintConfig.ORBIT_DURATION_AT_RANK_1 \
			+ ImprintConfig.ORBIT_DURATION_PER_RANK * float(orr - 1)
		out["orbit_pulse_interval"] = maxf(0.08, ImprintConfig.ORBIT_PULSE_INTERVAL_AT_RANK_1
			+ ImprintConfig.ORBIT_PULSE_INTERVAL_PER_RANK * float(orr - 1))
		out["orbit_radius"] = ImprintConfig.ORBIT_RADIUS
		out["delivery"] = "orbit"
		notes.append("Tempest Orbit (rank %d): a %.2f s self-centred orbit pulsing every %.3f s; "
			% [orr, out["orbit_duration"], out["orbit_pulse_interval"]]
			+ "TARGETING BECOMES %s and the Projectile tag is REMOVED" % out["targeting"])
	if has_modifier(DiagImprintContent.XF_ANCHOR):
		out["instances_max"] = 1
		notes.append("Siege Anchor: ONE persistent anchor instead of %d temporary instances"
			% ImprintConfig.BALLISTA_INSTANCES_MAX)

	# --- STAGE 4. DURATION ---------------------------------------------------
	if has_modifier(DiagImprintContent.AUG_WARD) and out["duration"] > 0.0:
		var wr: int = effective_rank(DiagImprintContent.AUG_WARD)
		var mult := ImprintConfig.EXTENDED_WARD_DURATION_MULT_AT_RANK_1 \
			+ ImprintConfig.EXTENDED_WARD_DURATION_MULT_PER_RANK * float(wr - 1)
		out["duration"] = float(out["duration"]) * mult
		notes.append("Extended Ward (rank %d): duration x%.3f" % [wr, mult])
	if has_modifier(DiagImprintContent.XF_ANCHOR) and out["duration"] > 0.0:
		out["duration"] = float(out["duration"]) * ImprintConfig.ANCHOR_DURATION_MULT
		notes.append("Siege Anchor: duration x%.2f" % ImprintConfig.ANCHOR_DURATION_MULT)

	# --- STAGE 5. DAMAGE -----------------------------------------------------
	if has_modifier(DiagImprintContent.AUG_TEMPERED):
		var tr: int = effective_rank(DiagImprintContent.AUG_TEMPERED)
		var more := ImprintConfig.TEMPERED_MORE_DAMAGE_AT_RANK_1 \
			+ ImprintConfig.TEMPERED_MORE_DAMAGE_PER_RANK * float(tr - 1)
		out["damage"] = float(out["damage"]) * (1.0 + more)
		out["action_duration"] = float(out["action_duration"]) \
			+ ImprintConfig.TEMPERED_ACTION_DURATION_ADD
		notes.append("Tempered Draw (rank %d): %.1f%% MORE damage, and +%.3f s of action duration"
			% [tr, more * 100.0, ImprintConfig.TEMPERED_ACTION_DURATION_ADD])
	if has_modifier(DiagImprintContent.AUG_SUREFOOT):
		var ur: int = effective_rank(DiagImprintContent.AUG_SUREFOOT)
		var less: float = maxf(0.0, ImprintConfig.SUREFOOT_LESS_DAMAGE_AT_RANK_1
			+ ImprintConfig.SUREFOOT_LESS_DAMAGE_PER_RANK * float(ur - 1))
		out["damage"] = float(out["damage"]) * (1.0 - less)
		var sf_mult: float = maxf(0.30, ImprintConfig.SUREFOOT_ACTION_DURATION_MULT
			+ ImprintConfig.SUREFOOT_ACTION_DURATION_MULT_PER_RANK * float(ur - 1))
		out["action_duration"] = float(out["action_duration"]) * sf_mult
		notes.append("Surefoot Release (rank %d): %.1f%% LESS damage, action duration x%.3f"
			% [ur, less * 100.0, sf_mult])
	if has_modifier(DiagImprintContent.AUG_PACK) and out["beast_count"] > 0:
		var pr2: int = effective_rank(DiagImprintContent.AUG_PACK)
		var lessb: float = maxf(0.0, ImprintConfig.PACK_INSTINCT_LESS_DAMAGE_AT_RANK_1
			+ ImprintConfig.PACK_INSTINCT_LESS_DAMAGE_PER_RANK * float(pr2 - 1))
		out["damage"] = float(out["damage"]) * (1.0 - lessb)
		notes.append("Pack Instinct (rank %d): each beast deals %.1f%% LESS damage"
			% [pr2, lessb * 100.0])

	# --- STAGE 6. COST -------------------------------------------------------
	if has_modifier(DiagImprintContent.AUG_SPLIT):
		var sr2: int = effective_rank(DiagImprintContent.AUG_SPLIT)
		out["mana_cost"] = float(out["mana_cost"]) \
			+ ImprintConfig.SPLIT_VOLLEY_MANA_SURCHARGE_AT_RANK_1 \
			+ ImprintConfig.SPLIT_VOLLEY_MANA_SURCHARGE_PER_RANK * float(sr2 - 1)
	if has_modifier(DiagImprintContent.AUG_FORK):
		out["mana_cost"] = float(out["mana_cost"]) + ImprintConfig.FORK_MANA_SURCHARGE \
			+ ImprintConfig.FORK_MANA_SURCHARGE_PER_RANK \
			* float(effective_rank(DiagImprintContent.AUG_FORK) - 1)
	if has_modifier(DiagImprintContent.AUG_TEMPERED):
		var tr2: int = effective_rank(DiagImprintContent.AUG_TEMPERED)
		out["mana_cost"] = float(out["mana_cost"]) \
			+ ImprintConfig.TEMPERED_MANA_SURCHARGE_AT_RANK_1 \
			+ ImprintConfig.TEMPERED_MANA_SURCHARGE_PER_RANK * float(tr2 - 1)
	if has_modifier(DiagImprintContent.AUG_SUREFOOT):
		out["mana_cost"] = float(out["mana_cost"]) + ImprintConfig.SUREFOOT_MANA_SURCHARGE
	if has_modifier(DiagImprintContent.AUG_WARD):
		out["mana_cost"] = float(out["mana_cost"]) + ImprintConfig.EXTENDED_WARD_MANA_SURCHARGE \
			+ ImprintConfig.EXTENDED_WARD_MANA_PER_RANK \
			* float(effective_rank(DiagImprintContent.AUG_WARD) - 1)
	if has_modifier(DiagImprintContent.AUG_PACK):
		out["mana_cost"] = float(out["mana_cost"]) + ImprintConfig.PACK_INSTINCT_MANA_SURCHARGE \
			+ ImprintConfig.PACK_INSTINCT_MANA_PER_RANK \
			* float(effective_rank(DiagImprintContent.AUG_PACK) - 1)
	if has_modifier(DiagImprintContent.XF_ORBIT):
		out["mana_cost"] = float(out["mana_cost"]) + ImprintConfig.ORBIT_MANA_SURCHARGE
	if has_modifier(DiagImprintContent.XF_RAIN):
		out["mana_cost"] = float(out["mana_cost"]) + ImprintConfig.RAIN_MANA_SURCHARGE \
			+ ImprintConfig.RAIN_MANA_PER_RANK \
			* float(effective_rank(DiagImprintContent.XF_RAIN) - 1)
	if has_modifier(DiagImprintContent.XF_ANCHOR):
		out["mana_cost"] = float(out["mana_cost"]) + ImprintConfig.ANCHOR_MANA_SURCHARGE \
			+ ImprintConfig.ANCHOR_MANA_PER_RANK \
			* float(effective_rank(DiagImprintContent.XF_ANCHOR) - 1)

	# --- STAGE 7. RESERVATION RESOURCE --------------------------------------
	# ========================================================================
	# EXACTLY ONE RESOURCE. THE OTHER IS SET TO ZERO, NOT LEFT ALONE.
	# ========================================================================
	# The owner: "It must reserve one resource, not accidentally both." Writing
	# the resource as a single field, and deriving the amount from it, is what
	# makes "both" unrepresentable rather than merely unlikely.
	#
	# ========================================================================
	# EVERY RESERVATION IS A PERCENTAGE, AND CONVERSION IS PROPORTIONAL (OD-06).
	# ========================================================================
	# `reserve_fraction` is ALWAYS a fraction of the reserved resource's MAXIMUM,
	# and `reserve_amount` is ALWAYS exactly that fraction of that maximum --
	# there is no flat-amount path in this pipeline.
	#
	# From D-375 until D-380 the conversion modifier replaced the Mana fraction
	# with a FLAT Life fraction (26 % - 0.4 %/rank, floored at 2 %), whatever
	# the effect it converted -- the flat Life tithe D-378 OD-06 removes. NOW
	# the Life fraction is the Mana fraction the effect WOULD have reserved,
	# AFTER its own rank and modifiers, times a PROVISIONAL ratio: a bigger
	# effect costs proportionally more Life, and the D-375 floor is gone with
	# the rest of the flat rule (a floor is a D-378 CANDIDATE, OD-07, and is
	# not adopted).
	out["reserve_fraction_mana_basis"] = 0.0
	out["conversion_ratio"] = 0.0
	if out["reserve_resource"] != "none":
		var mana_fraction: float = float(out["reserve_fraction"])
		out["reserve_fraction_mana_basis"] = mana_fraction
		if has_modifier(DiagImprintContent.AUG_TITHE):
			var lr: int = effective_rank(DiagImprintContent.AUG_TITHE)
			var ratio := SkillConfiguration.conversion_ratio_at(lr)
			out["conversion_ratio"] = ratio
			out["reserve_resource"] = "life"
			out["reserve_fraction"] = mana_fraction * ratio
			out["reserve_amount"] = ImprintConfig.LIFE_MAX * float(out["reserve_fraction"])
			notes.append(("Life Conversion (rank %d): the reservation resource becomes LIFE, "
				+ "PROPORTIONALLY — %.1f%% of maximum Mana x ratio %.4f = %.1f%% of maximum Life. "
				+ "MANA RESERVATION IS EXACTLY ZERO")
				% [lr, mana_fraction * 100.0, ratio, float(out["reserve_fraction"]) * 100.0])
		else:
			out["reserve_amount"] = ImprintConfig.MANA_MAX * mana_fraction

	out["notes"] = notes
	return out

## The panel rows for this Configuration, composed as plain text so a check can
## read exactly what a viewer reads.
func explain() -> Array:
	var sk := skill()
	var v := validate()
	var res := resolve()
	var lines: Array[String] = []
	if sk == null:
		return ["(empty)"]
	lines.append("%s  [%s]  %s" % [id, sk.class_name_text(), "VALID" if v["valid"] else "INVALID"])
	lines.append("  Skill Imprint     %s  (Mastered %d · Effective %d of %d)"
		% [sk.display_name, library.mastered(skill_id), skill_rank(), library.mastered(skill_id)])
	lines.append("  slots             %d of %d used · %d Transform of %d allowed"
		% [modifier_count(), ImprintConfig.CANON_MODIFIER_SLOTS_MAX, transform_count(),
		   ImprintConfig.CANON_TRANSFORMS_MAX_PER_CONFIGURATION])
	for mid in modifier_ids:
		var imp := library.get_imprint(mid) as Imprint
		# OD-12: a modifier with no explicit tradeoff is LEGAL, and says so.
		var cost_text := imp.tradeoff if imp.tradeoff != "" \
			else "no explicit tradeoff — purely beneficial; the slot and Capacity are its cost (OD-12)"
		lines.append("    %-18s %s  (Mastered %d · Effective %d)  affects %s · %s"
			% [imp.kind_name().replace(" IMPRINT", ""), imp.display_name,
			   library.mastered(mid), effective_rank(mid), str(imp.affects), cost_text])
	lines.append("  tags              %s%s" % [str(res["tags"]),
		"   (targeting %s, base %s)" % [res["targeting"], res["targeting_base"]]])
	lines.append("  Capacity          %s" % capacity_breakdown())
	for n in res["notes"]:
		lines.append("    - %s" % n)
	for p in v["problems"]:
		lines.append("    !! %s" % p)
	return lines
