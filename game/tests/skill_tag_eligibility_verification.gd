extends SceneTree
## Riftwrought — Roguelite Foundation A verification: Skill Tags and Support
## Eligibility (decision D-224).
##
## ONE FOCUSED HEADLESS TEST. The foundation is pure logic — a vocabulary, a
## record, a record, and a query — so it needs no scene, no camera, no
## navigation, no rendering and no evidence frame, and it deliberately gets
## none. It runs as a `SceneTree` script exactly as `gate_a_asset_report.gd`
## does.
##
## IT PORTS D-211's OWED-SET DISCIPLINE. Every check function records reaching
## its LAST line, and the suite compares that set against what it owes in BOTH
## directions, so a check that dies half way cannot leave a green run behind it.
##
## EVERY CLAIM IS PROVED IN BOTH DIRECTIONS WHERE A DIRECTION EXISTS. "Eligible"
## is worth little without a neighbouring profile that is refused for exactly
## one stated reason; the D-223 lesson — that the most comfortable place to
## write a weak assertion is one where the test performs the action itself and
## then reads its own result back — applies to an eligibility query at least as
## sharply as it applied to an equipped weapon.
##
## THE TEST-ONLY PROFILES BELOW ARE NOT PLAYABLE CONTENT. They exist inside this
## file only, are never registered in `SkillSupportCatalogue`, ship in no scene,
## no `.tres` and no library, and are not canon: they are the neighbouring
## points a boundary needs in order to be a boundary.

const FOUNDATION_FILES: Array[String] = [
	"res://scripts/skills/skill_tags.gd",
	"res://scripts/skills/skill_tag_profile.gd",
	"res://scripts/skills/support_eligibility.gd",
	"res://scripts/skills/skill_support_catalogue.gd",
]

## THE FOUNDATION B SCRIPTS, WHICH LEGITIMATELY CONSUME THIS FOUNDATION (D-227).
## They are excluded from the inertness scan below and from nothing else: this
## suite proves that Foundation A stores nothing and that no file OUTSIDE the
## two foundations references it, and Foundation B's own suite proves the same
## two properties about these four. Adding them here changes no assertion — the
## storage loop still walks `FOUNDATION_FILES` alone — so this suite's pinned
## count does not move.
const CONSUMING_FOUNDATION_FILES: Array[String] = [
	"res://scripts/skills/support_definition.gd",
	"res://scripts/skills/acquired_supports.gd",
	"res://scripts/skills/support_selection_result.gd",
	"res://scripts/skills/support_selection.gd",
]

## THE FOUNDATION D1 FILES, WHICH LEGITIMATELY NAME ONE FOUNDATION A CLASS
## (D-239). The three-lane offer composer takes `SkillTagProfile` records as an
## argument and hands them to the accepted support selector, so naming the
## profile TYPE is the whole point of it rather than a breach of the boundary.
##
## THIS REPLACES THE BLANKET "no file outside the foundation names a Foundation A
## class" ONE FOR ONE: the same single assertion is made either way, it still
## fails for any other file AND for any other class named by these files, and the
## pinned count does not move. It is deliberately a PER-CLASS grant rather than
## the whole-file exclusion the consuming foundation above receives — D1 may name
## the profile record and nothing else, so a composer that started naming the tag
## vocabulary, the eligibility rule or the shipped catalogue is refused by the
## same row that refuses any other file.
const AUTHORIZED_READERS: Array[String] = [
	"res://scripts/offers/rift_offer_composition.gd",
	## D-248: the Foundation E2 level-up coordinator is handed the equipped Skill
	## profiles and forwards them to the accepted composition mechanism, so it
	## names the profile TYPE for the same reason the composer does. Added ONE
	## FOR ONE: the same single assertion is made either way, it still fails for
	## any other file AND for any class a listed file is not granted, and the
	## pinned count does not move.
	"res://scripts/levels/rift_level_up_coordinator.gd",
	## Foundation F2: the support-lane CONTINUATION selector is handed the
	## equipped Skill profiles and forwards them, unread, to the accepted
	## weighted selector, so it names the profile TYPE for the same reason the
	## composer and the coordinator do. Its RESULT record is deliberately absent
	## from this list, because it names no Foundation A class at all. Added ONE
	## FOR ONE: the same single assertion is made either way, it still fails for
	## any other file AND for any class a listed file is not granted, and the
	## pinned count does not move.
	"res://scripts/continuation/support_continuation.gd",
	## Foundation G4 (decision D-269): the repeated run-level coordinator is handed
	## the equipped Skill profiles and forwards them, unread, to the accepted
	## one-level coordinator when it opens the current level's offer, so it names
	## the profile TYPE for the same reason that coordinator does. Its run-level
	## record names no Foundation A class. Added ONE FOR ONE: the same single
	## assertion is made either way, it still fails for any other file AND for any
	## class a listed file is not granted, and the pinned count does not move.
	"res://scripts/levels/rift_run_level_coordinator.gd",
	## Foundation I1 (decision D-291): the H8 Experience-Mote runtime is handed the
	## equipped Skill profiles when its owner asks it to open the current level's
	## offer, and hands them, unread, straight to that coordinator. It names the
	## profile TYPE for the same reason and holds none. Added ONE FOR ONE: the same
	## single assertion is made either way, it still fails for any other file AND
	## for any class a listed file is not granted, and the pinned count does not move.
	"res://scripts/experience/rift_mote_runtime.gd",
]

const AUTHORIZED_READER_CLASSES: Array[String] = ["SkillTagProfile"]

## Roguelite I2 (decision D-293): the Playable Three-Lane Level-Up Choice Review — an
## isolated review scene launched by name, never the project entrypoint — asks the
## shipped catalogue for the equipped Skill profiles when it opens its one level-up
## offer, and asks it again for the profile a Support card names so the card can show
## that Skill's display name. It names the CATALOGUE and the profile TYPE and nothing
## else of this foundation. Granted PER FILE AND PER CLASS in its own table rather than
## by adding the catalogue to the flat class list above, which would have handed the
## catalogue to every reader listed there. The same single assertion is made either
## way, it still fails for any other file AND for any class this file is not granted,
## and the pinned count does not move.
const AUTHORIZED_REVIEW_READERS: Array = [
	["res://scripts/roguelite/level_up/roguelite_level_up_choice_review.gd",
		["SkillSupportCatalogue", "SkillTagProfile"]],
	## Roguelite I3 (decision D-295): the one run-build application seam asks the
	## shipped catalogue for the one equipped Skill's id and display name and for the
	## rank-one values a held support sets. It names the CATALOGUE and nothing else of
	## this foundation — not the profile type, the tag vocabulary or the rule. The same
	## single assertion is made either way, and the pinned count does not move.
	["res://scripts/roguelite/live_effects/rift_build_application.gd",
		["SkillSupportCatalogue"]],
]


## Whether `path` is granted `name` in `AUTHORIZED_REVIEW_READERS`: per file and per class.
func _review_reader_may_name(path: String, name: String) -> bool:
	for row: Array in AUTHORIZED_REVIEW_READERS:
		if String(row[0]) == path:
			return (row[1] as Array).has(name)
	return false

## The three class-agnostic files. None of them may name a Skill or a support.
const CLASS_AGNOSTIC_FILES: Array[String] = [
	"res://scripts/skills/skill_tags.gd",
	"res://scripts/skills/skill_tag_profile.gd",
	"res://scripts/skills/support_eligibility.gd",
]

## Scanned for RAW, comments included. D-215's lesson: an illustrative name in a
## comment breaches the rule just as surely as a real one, because the rule
## exists so a reader can trust the file holds no Skill-specific knowledge.
const FORBIDDEN_TOKENS: Array[String] = [
	"quick_strike", "Quick Strike", "QuickStrike",
	"reaching_edge", "Reaching Edge", "sweeping_edge", "Sweeping Edge",
	"RogueliteUpgrade", "Expedition Blade", "Quickened Edge",
]

## The four global class names the foundation introduces. No script that RUNS
## may reference any of them yet.
const FOUNDATION_CLASSES: Array[String] = [
	"SkillTags", "SkillTagProfile", "SupportEligibility", "SkillSupportCatalogue",
]

const SHIPPED_SKILL_RECORDS: Array[String] = [
	"res://data/first_mvp/skills/faultbreaker.tres",
	"res://data/first_mvp/skills/splinter_shot.tres",
	"res://data/first_mvp/skills/emberbolt.tres",
]

const CANONICAL_QUICK_STRIKE: String = "res://data/prototype_zero/quick_strike.tres"

const PURITY_CALLS: int = 100

const OWED_CHECKS: Array[String] = [
	"the_vocabulary_is_one_record",
	"the_profile_extends_the_recorded_tags",
	"eligible_for_reaching_edge",
	"eligible_for_sweeping_edge",
	"required_any_is_covered_by_a_generic_rule",
	"a_spell_projectile_skill_is_refused",
	"an_excluded_tag_overrides_required_tags",
	"unknown_tags_fail_safely",
	"order_and_duplicates_change_nothing",
	"the_query_is_pure_and_names_no_skill",
	"the_records_are_coherent_and_the_guards_are_reachable",
	"nothing_existing_changed",
]

var _failures: PackedStringArray = PackedStringArray()
var _checks: int = 0
var _reached: Dictionary = {}


func _initialize() -> void:
	print("")
	print("=== Roguelite Foundation A — Skill Tags and Support Eligibility (D-224) ===")

	_check_the_vocabulary_is_one_record()
	_check_the_profile_extends_the_recorded_tags()
	_check_eligible_for_reaching_edge()
	_check_eligible_for_sweeping_edge()
	_check_required_any_is_covered_by_a_generic_rule()
	_check_a_spell_projectile_skill_is_refused()
	_check_an_excluded_tag_overrides_required_tags()
	_check_unknown_tags_fail_safely()
	_check_order_and_duplicates_change_nothing()
	_check_the_query_is_pure_and_names_no_skill()
	_check_the_records_are_coherent_and_the_guards_are_reachable()
	_check_nothing_existing_changed()

	_check_every_check_ran()

	print("")
	if _failures.is_empty():
		print("SKILL TAG ELIGIBILITY VERIFICATION: PASS (%d checks)" % _checks)
		quit(0)
	else:
		for failure: String in _failures:
			printerr("  FAIL: %s" % failure)
		printerr("SKILL TAG ELIGIBILITY VERIFICATION: %d FAILURE(S) of %d checks" % [
			_failures.size(), _checks,
		])
		quit(1)


# --- 1. One vocabulary, not two ----------------------------------------------

func _check_the_vocabulary_is_one_record() -> void:
	print("")
	print("--- 1. The tag vocabulary is ONE record, and it recognises every tag the project persists")

	var all: Array[StringName] = SkillTags.ALL
	var deduplicated: Array[StringName] = SkillTags.normalize(all)
	_expect(all.size() == deduplicated.size(),
		"SkillTags.ALL holds a duplicate: %d entries, %d distinct" % [all.size(), deduplicated.size()])
	_expect(all.size() == 20, "SkillTags.ALL holds %d tags, not the 20 declared" % all.size())

	## Every StringName constant the vocabulary declares must be IN it. This is
	## what catches "a constant was added and ALL was not updated", which would
	## silently make a real tag unrecognised and therefore deny forever.
	var vocabulary: GDScript = load("res://scripts/skills/skill_tags.gd") as GDScript
	var missing: PackedStringArray = PackedStringArray()
	var declared: int = 0
	for key: Variant in vocabulary.get_script_constant_map():
		var value: Variant = vocabulary.get_script_constant_map()[key]
		if typeof(value) != TYPE_STRING_NAME:
			continue
		declared += 1
		if not SkillTags.is_known(value as StringName):
			missing.append("%s = %s" % [key, value])
	_expect(declared == 20, "the vocabulary declares %d StringName constants, not 20" % declared)
	_expect(missing.is_empty(),
		"constant(s) declared but absent from SkillTags.ALL: %s" % ", ".join(missing))

	## The eight ids the project had already persisted are ALIASED, not retyped.
	var record_script: GDScript = load("res://scripts/skills/first_mvp_skill_data.gd") as GDScript
	var aliased: int = 0
	var unaliased: PackedStringArray = PackedStringArray()
	for key: Variant in record_script.get_script_constant_map():
		var name: String = String(key)
		if not name.begins_with("TAG_"):
			continue
		aliased += 1
		if not SkillTags.is_known(record_script.get_script_constant_map()[key] as StringName):
			unaliased.append(name)
	_expect(aliased == 9, "FirstMvpSkillData declares %d TAG_ constants, not 9" % aliased)
	## D-225 moved Strike's id into the record class that already owned every
	## other canonical tag id, so the vocabulary aliases it rather than declaring
	## a second statement of it.
	_expect(record_script.get_script_constant_map().has("TAG_STRIKE"),
		"the canonical tag owner does not declare TAG_STRIKE")
	_expect(unaliased.is_empty(),
		"tag id(s) the first-MVP record owns but the vocabulary does not know: %s"
			% ", ".join(unaliased))

	## THE REAL DATA BOUNDARY: every tag on every Skill record the project ships
	## must be recognised. An unrecognised tag on a real Skill would satisfy no
	## requirement and silently deny every support.
	var unrecognised: PackedStringArray = PackedStringArray()
	var scanned: int = 0
	for path: String in SHIPPED_SKILL_RECORDS:
		var record: FirstMvpSkillData = load(path) as FirstMvpSkillData
		if record == null:
			_expect(false, "the shipped Skill record %s failed to load" % path)
			continue
		scanned += 1
		for tag: StringName in SkillTags.unknown(record.tags):
			unrecognised.append("%s carries %s" % [record.skill_id, tag])
	var view: FirstMvpSkillData = FirstMvpSkillLibrary.quick_strike_record()
	scanned += 1
	for tag: StringName in SkillTags.unknown(view.tags):
		unrecognised.append("%s carries %s" % [view.skill_id, tag])
	_expect(scanned == 4, "%d Skill records were scanned, not 4" % scanned)
	_expect(unrecognised.is_empty(),
		"shipped Skill record(s) carry unrecognised tag(s): %s" % ", ".join(unrecognised))

	## `Strike` is declared as a proposal, not as canon, and says so.
	## EVERY RECOGNISED TAG IS CANONICAL. D-225 canonized the one entry this list
	## ever held; a non-empty list now turns the suite red until a new tag is
	## either written into the damage model or removed, which is what makes a tag
	## a mechanical contract rather than a convenience.
	_expect(SkillTags.PENDING_CANONICAL_REGISTRATION.is_empty(),
		"tag(s) recognised but not written into the governing tag contract: %s"
			% SkillTags.line(SkillTags.PENDING_CANONICAL_REGISTRATION))
	_expect(SkillTags.is_known(SkillTags.STRIKE), "Strike is not in the vocabulary it belongs to")

	## And a fabricated tag really is unrecognised, so the guard is not vacuous.
	_expect(not SkillTags.is_known(&"NotATag"), "a fabricated tag was reported as recognised")

	print("  %d tags recognised, all canonical; %d Skill records scanned; %d pending registration"
		% [all.size(), scanned, SkillTags.PENDING_CANONICAL_REGISTRATION.size()])
	_done("the_vocabulary_is_one_record")


# --- 2. The profile extends the record it came from --------------------------

func _check_the_profile_extends_the_recorded_tags() -> void:
	print("")
	print("--- 2. The Skill profile EXTENDS the record's own tags and loses none of them")

	var record: FirstMvpSkillData = FirstMvpSkillLibrary.quick_strike_record()
	var profile: SkillTagProfile = SkillSupportCatalogue.quick_strike_profile()
	_expect(profile != null, "no Skill profile was built")
	_expect(profile.skill_id == record.skill_id,
		"the profile's id is %s, not the record's %s" % [profile.skill_id, record.skill_id])
	_expect(profile.display_name == record.display_name,
		"the profile's display name is %s, not the record's %s"
			% [profile.display_name, record.display_name])
	_expect(profile.problem().is_empty(), "the profile reports: %s" % profile.problem())

	## Nothing the record states is lost.
	var lost: PackedStringArray = PackedStringArray()
	for tag: StringName in record.tags:
		if not profile.carries(tag):
			lost.append(String(tag))
	_expect(lost.is_empty(), "the profile dropped recorded tag(s): %s" % ", ".join(lost))

	## The five the brief names are present, each asserted by name.
	_expect(profile.satisfies(SkillTags.ATTACK), "the profile does not carry Attack")
	_expect(profile.satisfies(SkillTags.MELEE), "the profile does not carry Melee")
	_expect(profile.satisfies(SkillTags.STRIKE), "the profile does not carry Strike")
	_expect(profile.satisfies(SkillTags.PHYSICAL), "the profile does not carry Physical")
	## D-225: a candidate-search arc is not an area of effect, and this Skill
	## resolves at most one target, so `Area` must NOT be here.
	_expect(not profile.carries(SkillTags.AREA),
		"the profile still carries Area, which the tag contract forbids for a "
			+ "Skill that resolves at most one target")
	## And the delivery tag the record already carried, which the brief's list
	## omits and which it would be a regression in truth to drop.
	_expect(profile.satisfies(SkillTags.HIT), "the profile dropped the recorded Hit tag")

	## The additions are genuinely ADDITIONS — neither is already in the record,
	## so neither is a retyped copy of something the record owns.
	var already_present: PackedStringArray = PackedStringArray()
	for tag: StringName in SkillSupportCatalogue.QUICK_STRIKE_ADDITIONAL_TAGS:
		if record.tags.has(tag):
			already_present.append(String(tag))
	_expect(already_present.is_empty(),
		"declared addition(s) the record already carries: %s" % ", ".join(already_present))

	## And nothing else crept in: the profile is exactly the union.
	var expected: Array[StringName] = SkillTags.union(
		record.tags, SkillSupportCatalogue.QUICK_STRIKE_ADDITIONAL_TAGS
	)
	_expect(SkillTags.same_set(profile.tags, expected),
		"the profile is [%s], not the union [%s]" % [profile.tag_line(), SkillTags.line(expected)])
	_expect(profile.tags.size() == 5,
		"the profile carries %d tags, not the 4 recorded plus 1 added" % profile.tags.size())

	print("  %s: recorded [%s] + declared [%s] = [%s]" % [
		profile.skill_id, SkillTags.line(record.tags),
		SkillTags.line(SkillSupportCatalogue.QUICK_STRIKE_ADDITIONAL_TAGS), profile.tag_line(),
	])
	_done("the_profile_extends_the_recorded_tags")


# --- 3. Eligible for Reaching Edge -------------------------------------------

func _check_eligible_for_reaching_edge() -> void:
	print("")
	print("--- 3. The Skill is ELIGIBLE for Reaching Edge, and the rule is not vacuous")

	var profile: SkillTagProfile = SkillSupportCatalogue.quick_strike_profile()
	var rule: SupportEligibility = SkillSupportCatalogue.reaching_edge()
	_expect(rule != null, "the Reaching Edge rule was not built")
	_expect(rule.problem().is_empty(), "the Reaching Edge rule reports: %s" % rule.problem())
	_expect(rule.allows(profile), "the Skill is refused: %s" % rule.refusal(profile))
	_expect(rule.refusal(profile).is_empty(),
		"the verdict and the explanation disagree: %s" % rule.refusal(profile))
	## The same answer through the pure static form, which is what a caller with
	## no profile object would use.
	_expect(SupportEligibility.accepts(profile.tags, rule),
		"the pure query disagrees with the profile-facing form")

	## BOTH DIRECTIONS. The record's own four tags — the profile WITHOUT the
	## declared Strike addition — are refused, so the addition is load-bearing
	## rather than decorative, and the rule really does test something.
	var recorded_only: SkillTagProfile = SkillTagProfile.of(
		&"test_only_recorded_tags_only", "Test Only — recorded tags only",
		FirstMvpSkillLibrary.quick_strike_record().tags
	)
	_expect(not rule.allows(recorded_only),
		"a profile with no Strike tag was accepted by a rule that requires Strike")
	_expect(rule.refusal(recorded_only).contains("Strike"),
		"the refusal does not name the missing Strike tag: %s" % rule.refusal(recorded_only))

	## And a melee AREA Skill — Faultbreaker's own shipped tags — is refused,
	## because a radius is not a reach. That is the rule distinguishing itself
	## from Sweeping Edge rather than the two being the same rule twice.
	var area_skill: FirstMvpSkillData = load(SHIPPED_SKILL_RECORDS[0]) as FirstMvpSkillData
	var area_profile: SkillTagProfile = SkillTagProfile.of(
		area_skill.skill_id, area_skill.display_name, area_skill.tags
	)
	_expect(not rule.allows(area_profile),
		"the melee Area Skill %s was accepted by a Strike-only rule" % area_skill.skill_id)

	print("  %s: %s -> ELIGIBLE; recorded-tags-only -> %s; %s -> %s" % [
		rule.label(), profile.skill_id, rule.refusal(recorded_only),
		area_skill.skill_id, rule.refusal(area_profile),
	])
	_done("eligible_for_reaching_edge")


# --- 4. Eligible for Sweeping Edge -------------------------------------------

func _check_eligible_for_sweeping_edge() -> void:
	print("")
	print("--- 4. The Skill is ELIGIBLE for Sweeping Edge, on Melee + Strike alone")

	var profile: SkillTagProfile = SkillSupportCatalogue.quick_strike_profile()
	var rule: SupportEligibility = SkillSupportCatalogue.sweeping_edge()
	_expect(rule != null, "the Sweeping Edge rule was not built")
	_expect(rule.problem().is_empty(), "the Sweeping Edge rule reports: %s" % rule.problem())
	_expect(rule.allows(profile), "the Skill is refused: %s" % rule.refusal(profile))
	_expect(SupportEligibility.accepts(profile.tags, rule),
		"the pure query disagrees with the profile-facing form")

	## IT MUST NOT DEPEND ON A BASELINE `Area` TAG (D-225). Asserted structurally
	## rather than by outcome: an outcome test would still pass if the rule asked
	## for Area in a branch that happened not to be taken.
	_expect(rule.required_any.is_empty(),
		"Sweeping Edge still states a required-any list: [%s]" % SkillTags.line(rule.required_any))
	var names_area: bool = rule.required_all.has(SkillTags.AREA) \
		or rule.required_any.has(SkillTags.AREA) or rule.excluded.has(SkillTags.AREA)
	_expect(not names_area, "the Sweeping Edge rule still names Area: %s" % rule.rule_line())
	_expect(SkillTags.same_set(rule.required_all,
			[SkillTags.MELEE, SkillTags.STRIKE] as Array[StringName]),
		"Sweeping Edge requires [%s], not Melee + Strike" % SkillTags.line(rule.required_all))

	## BOTH DIRECTIONS. A melee AREA Skill with no Strike tag — Faultbreaker's own
	## shipped tags — is now REFUSED, which is the direct consequence of the
	## ruling and the thing that would silently not have changed if the rule had
	## kept its Area branch.
	var area_skill: FirstMvpSkillData = load(SHIPPED_SKILL_RECORDS[0]) as FirstMvpSkillData
	var area_profile: SkillTagProfile = SkillTagProfile.of(
		area_skill.skill_id, area_skill.display_name, area_skill.tags
	)
	_expect(area_profile.satisfies(SkillTags.AREA) and not area_profile.satisfies(SkillTags.STRIKE),
		"the melee Area profile is not the Area-without-Strike case this check needs")
	_expect(not rule.allows(area_profile),
		"the melee Area Skill %s is still accepted through an Area branch" % area_skill.skill_id)
	_expect(rule.refusal(area_profile).contains("Strike"),
		"the refusal does not name the missing Strike tag: %s" % rule.refusal(area_profile))

	## And Melee alone is refused, so the Strike half is load-bearing.
	var bare_melee: Array[StringName] = [
		SkillTags.ATTACK, SkillTags.MELEE, SkillTags.HIT, SkillTags.PHYSICAL,
	]
	var bare: SkillTagProfile = SkillTagProfile.of(
		&"test_only_bare_melee", "Test Only — bare melee", bare_melee
	)
	_expect(not rule.allows(bare), "a Melee profile carrying no Strike tag was accepted")

	print("  %s: %s -> ELIGIBLE (Melee + Strike); %s -> %s; bare melee -> %s" % [
		rule.label(), profile.skill_id, area_skill.skill_id, rule.refusal(area_profile),
		rule.refusal(bare),
	])
	_done("eligible_for_sweeping_edge")


# --- 4a. required-any, covered by a TEST-ONLY generic rule --------------------

func _check_required_any_is_covered_by_a_generic_rule() -> void:
	print("")
	print("--- 4a. required-ANY is covered by a TEST-ONLY generic rule, not by a shipped one")

	## NEITHER SHIPPED SUPPORT USES required-any, AND NEITHER SHOULD BE BENT INTO
	## USING IT. A rule written to exercise a mechanism is a rule written for the
	## test rather than for the game — the D-223 lesson about assertions that
	## arrange their own answer, applied to a data record. So the mechanism is
	## proved on a rule that exists only inside this file.
	for shipped: SupportEligibility in SkillSupportCatalogue.supports():
		_expect(shipped.required_any.is_empty(),
			"%s uses required-any; the mechanism must not be proved on a shipped rule"
				% shipped.support_id)

	var generic: SupportEligibility = SupportEligibility.of(
		&"test_only_generic_any", "Test Only — generic required-any",
		[SkillTags.MELEE] as Array[StringName],
		[SkillTags.STRIKE, SkillTags.AREA] as Array[StringName],
		[] as Array[StringName]
	)
	_expect(generic.problem().is_empty(), "the generic rule reports: %s" % generic.problem())

	## BRANCH ONE: satisfied through Strike, with Area absent.
	var strike_profile: SkillTagProfile = SkillSupportCatalogue.quick_strike_profile()
	_expect(not strike_profile.carries(SkillTags.AREA),
		"the Strike branch profile carries Area, so the branch is not isolated")
	_expect(generic.allows(strike_profile),
		"the Strike branch is refused: %s" % generic.refusal(strike_profile))

	## BRANCH TWO: satisfied through Area, with Strike absent.
	var area_skill: FirstMvpSkillData = load(SHIPPED_SKILL_RECORDS[0]) as FirstMvpSkillData
	var area_profile: SkillTagProfile = SkillTagProfile.of(
		area_skill.skill_id, area_skill.display_name, area_skill.tags
	)
	_expect(not area_profile.carries(SkillTags.STRIKE),
		"the Area branch profile carries Strike, so the branch is not isolated")
	_expect(generic.allows(area_profile),
		"the Area branch is refused: %s" % generic.refusal(area_profile))

	## NEITHER BRANCH: refused, and the refusal names the whole set.
	var bare_melee: Array[StringName] = [
		SkillTags.ATTACK, SkillTags.MELEE, SkillTags.HIT, SkillTags.PHYSICAL,
	]
	var bare: SkillTagProfile = SkillTagProfile.of(
		&"test_only_bare_melee", "Test Only — bare melee", bare_melee
	)
	_expect(not generic.allows(bare), "a profile satisfying neither branch was accepted")
	_expect(generic.refusal(bare).contains("Strike") and generic.refusal(bare).contains("Area"),
		"the refusal does not name the required-any set: %s" % generic.refusal(bare))

	## AN EMPTY required-any IS NO CONSTRAINT, not an impossible one. Same rule,
	## same profile, the disjunction removed.
	var without_any: SupportEligibility = SupportEligibility.of(
		&"test_only_no_any", "Test Only — no required-any",
		generic.required_all, [] as Array[StringName], [] as Array[StringName]
	)
	_expect(without_any.allows(bare),
		"an empty required-any behaved as a constraint: %s" % without_any.refusal(bare))

	## AND AN UNRECOGNISED TAG IN required-any DENIES, exactly as it does in
	## required-all — the disjunction is not a hole in the fail-closed rule.
	var unknown_any: SupportEligibility = SupportEligibility.of(
		&"test_only_unknown_any", "Test Only — unrecognised required-any",
		[SkillTags.MELEE] as Array[StringName], [&"NotATag"] as Array[StringName],
		[] as Array[StringName]
	)
	_expect(not unknown_any.allows(strike_profile),
		"a required-any list holding only an unrecognised tag accepted a Skill")

	print("  generic required-any rule: Strike branch -> ELIGIBLE; Area branch -> ELIGIBLE; "
		+ "neither -> refused; empty -> no constraint; unrecognised -> denies")
	_done("required_any_is_covered_by_a_generic_rule")


# --- 5. A Spell/Projectile Skill is refused by a Melee/Strike requirement -----

func _check_a_spell_projectile_skill_is_refused() -> void:
	print("")
	print("--- 5. A test-only Spell/Projectile profile is refused by a Melee/Strike requirement")

	var spell_tags: Array[StringName] = [
		SkillTags.SPELL, SkillTags.PROJECTILE, SkillTags.HIT, SkillTags.FIRE,
	]
	var spell: SkillTagProfile = SkillTagProfile.of(
		&"test_only_spell_projectile", "Test Only — Spell Projectile", spell_tags
	)
	_expect(spell.problem().is_empty(), "the test-only profile reports: %s" % spell.problem())
	_expect(not spell.satisfies(SkillTags.MELEE), "the test-only Spell profile carries Melee")
	_expect(not spell.satisfies(SkillTags.STRIKE), "the test-only Spell profile carries Strike")

	var reaching: SupportEligibility = SkillSupportCatalogue.reaching_edge()
	var sweeping: SupportEligibility = SkillSupportCatalogue.sweeping_edge()
	_expect(not reaching.allows(spell), "Reaching Edge accepted a Spell Projectile Skill")
	_expect(not sweeping.allows(spell), "Sweeping Edge accepted a Spell Projectile Skill")

	## THE REFUSAL IS ATTRIBUTED, NOT ASSUMED. Both shipped rules also EXCLUDE
	## Projectile, and exclusion is evaluated first, so the reason they give
	## names the exclusion. To prove the REQUIREMENT alone refuses this profile,
	## the same requirement is evaluated with no exclusion list at all.
	_expect(reaching.refusal(spell).contains("Projectile"),
		"the shipped refusal does not name the Projectile exclusion: %s" % reaching.refusal(spell))

	var requirement_only: SupportEligibility = SupportEligibility.of(
		&"test_only_melee_strike_requirement", "Test Only — Melee/Strike requirement",
		reaching.required_all, reaching.required_any, [] as Array[StringName]
	)
	_expect(requirement_only.excluded.is_empty(),
		"the requirement-only variant still carries an exclusion list")
	_expect(not requirement_only.allows(spell),
		"a Melee/Strike requirement with no exclusions accepted a Spell Projectile Skill")
	_expect(requirement_only.refusal(spell).contains("Melee"),
		"the requirement-only refusal does not name Melee: %s" % requirement_only.refusal(spell))

	## And the same requirement, with no exclusions, still ACCEPTS the Skill it
	## is meant for — so it refuses the Spell for its content, not because a
	## requirement-only rule refuses everything.
	_expect(requirement_only.allows(SkillSupportCatalogue.quick_strike_profile()),
		"the requirement-only variant refuses the Skill it was derived from")

	print("  %s -> %s (shipped) / %s (requirement only)" % [
		spell.skill_id, reaching.refusal(spell), requirement_only.refusal(spell),
	])
	_done("a_spell_projectile_skill_is_refused")


# --- 6. An excluded tag overrides otherwise matching required tags -----------

func _check_an_excluded_tag_overrides_required_tags() -> void:
	print("")
	print("--- 6. An excluded tag OVERRIDES otherwise matching required tags")

	## A profile deliberately built to satisfy every requirement of both shipped
	## rules AND to carry the tag both of them exclude.
	var conflicted_tags: Array[StringName] = [
		SkillTags.ATTACK, SkillTags.MELEE, SkillTags.STRIKE, SkillTags.PHYSICAL,
		SkillTags.HIT, SkillTags.PROJECTILE,
	]
	var conflicted: SkillTagProfile = SkillTagProfile.of(
		&"test_only_matching_but_excluded", "Test Only — matching but excluded", conflicted_tags
	)

	for rule: SupportEligibility in SkillSupportCatalogue.supports():
		## The requirements really are satisfied — asserted directly, so the
		## refusal below cannot be a missing requirement wearing an exclusion's
		## clothes.
		_expect(SkillTags.satisfies_all(conflicted.tags, rule.required_all),
			"%s: the conflicted profile does not satisfy required_all, so the test proves nothing"
				% rule.support_id)
		_expect(rule.required_any.is_empty()
				or SkillTags.satisfies_any(conflicted.tags, rule.required_any),
			"%s: the conflicted profile does not satisfy required_any" % rule.support_id)

		## And it is refused anyway, for the exclusion, by name.
		_expect(not rule.allows(conflicted),
			"%s accepted a profile carrying an excluded tag" % rule.support_id)
		_expect(rule.refusal(conflicted).contains("excluded")
				and rule.refusal(conflicted).contains(String(SkillTags.PROJECTILE)),
			"%s: the refusal does not name the exclusion: %s"
				% [rule.support_id, rule.refusal(conflicted)])

		## BOTH DIRECTIONS: remove the one excluded tag and the same profile is
		## accepted, so the exclusion alone is the cause.
		var cleared: SkillTagProfile = SkillTagProfile.of(
			&"test_only_matching", "Test Only — matching",
			SkillTags.difference(conflicted.tags, [SkillTags.PROJECTILE] as Array[StringName])
		)
		_expect(cleared.satisfies(SkillTags.MELEE) and cleared.satisfies(SkillTags.STRIKE),
			"%s: clearing the excluded tag also removed a required one" % rule.support_id)
		_expect(rule.allows(cleared),
			"%s refuses the same profile with the excluded tag removed: %s"
				% [rule.support_id, rule.refusal(cleared)])

	print("  [%s] -> refused by both; the same set without Projectile -> accepted by both"
		% conflicted.tag_line())
	_done("an_excluded_tag_overrides_required_tags")


# --- 7. Unknown tags fail safely ---------------------------------------------

func _check_unknown_tags_fail_safely() -> void:
	print("")
	print("--- 7. Unrecognised tags fail SAFELY, in every direction")

	var unknown_tag: StringName = &"NotATag"
	var profile: SkillTagProfile = SkillSupportCatalogue.quick_strike_profile()

	## (a) A rule that REQUIRES an unrecognised tag can never be satisfied.
	var requires_unknown: SupportEligibility = SupportEligibility.of(
		&"test_only_requires_unknown", "Test Only — requires an unrecognised tag",
		[unknown_tag] as Array[StringName], [] as Array[StringName], [] as Array[StringName]
	)
	_expect(not requires_unknown.allows(profile),
		"a rule requiring an unrecognised tag accepted a Skill")
	_expect(requires_unknown.refusal(profile).contains("not a recognised tag"),
		"the refusal does not say the tag is unrecognised: %s" % requires_unknown.refusal(profile))

	## ...NOT EVEN when the Skill literally carries the same unrecognised
	## spelling. An unrecognised tag has no defined mechanical contract, so no
	## eligibility decision may rest on one.
	var carries_unknown: SkillTagProfile = SkillTagProfile.of(
		&"test_only_carries_unknown", "Test Only — carries an unrecognised tag",
		SkillTags.union(profile.tags, [unknown_tag] as Array[StringName])
	)
	_expect(carries_unknown.carries(unknown_tag),
		"the test profile does not literally carry the unrecognised tag")
	_expect(not carries_unknown.satisfies(unknown_tag),
		"an unrecognised tag SATISFIED a requirement")
	_expect(not requires_unknown.allows(carries_unknown),
		"a rule was satisfied by a tag neither side recognises")

	## (b) An unrecognised tag on the SKILL is INERT: it neither creates nor
	## destroys an otherwise correct answer.
	for rule: SupportEligibility in SkillSupportCatalogue.supports():
		_expect(rule.allows(carries_unknown) == rule.allows(profile),
			"%s changed its answer because the Skill carried an unrecognised tag" % rule.support_id)
	_expect(not carries_unknown.problem().is_empty(),
		"a profile carrying an unrecognised tag reported no problem")
	_expect(carries_unknown.problem().contains(String(unknown_tag)),
		"the problem does not name the unrecognised tag: %s" % carries_unknown.problem())

	## (c) A MISSPELLING is an unrecognised tag, not a near miss. Case matters.
	_expect(not SkillTags.is_known(&"melee"), "a lower-case spelling was recognised as Melee")
	var misspelled: SupportEligibility = SupportEligibility.of(
		&"test_only_misspelled", "Test Only — misspelled requirement",
		[&"melee"] as Array[StringName], [] as Array[StringName], [] as Array[StringName]
	)
	_expect(not misspelled.allows(profile),
		"a misspelled requirement was satisfied by the correctly spelled tag")

	## (d) An unrecognised EXCLUDED tag is honoured literally, because denying
	## is the safe direction for an exclusion.
	var excludes_unknown: SupportEligibility = SupportEligibility.of(
		&"test_only_excludes_unknown", "Test Only — excludes an unrecognised tag",
		[SkillTags.MELEE] as Array[StringName], [] as Array[StringName],
		[unknown_tag] as Array[StringName]
	)
	_expect(not excludes_unknown.allows(carries_unknown),
		"an unrecognised excluded tag was ignored")
	_expect(excludes_unknown.allows(profile),
		"the same rule refused a Skill that does not carry the excluded tag")
	_expect(not excludes_unknown.problem().is_empty(),
		"a rule excluding an unrecognised tag reported no problem")

	## (e) A rule that states NOTHING denies rather than accepting everything.
	var states_nothing: SupportEligibility = SupportEligibility.of(
		&"test_only_states_nothing", "Test Only — states nothing",
		[] as Array[StringName], [] as Array[StringName], [] as Array[StringName]
	)
	_expect(not states_nothing.allows(profile), "a rule stating no requirement accepted a Skill")
	_expect(states_nothing.refusal(profile).contains("no eligibility rule"),
		"the refusal does not say the rule is empty: %s" % states_nothing.refusal(profile))
	_expect(not SupportEligibility.accepts(profile.tags, null),
		"a null rule was accepted")

	print("  unrecognised required -> denies; unrecognised on the Skill -> inert; "
		+ "unrecognised excluded -> denies; empty rule -> denies")
	_done("unknown_tags_fail_safely")


# --- 8. Tag order and duplicates change nothing ------------------------------

func _check_order_and_duplicates_change_nothing() -> void:
	print("")
	print("--- 8. Tag ORDER and DUPLICATE tags change no answer")

	var profile: SkillTagProfile = SkillSupportCatalogue.quick_strike_profile()
	var base: Array[StringName] = profile.tags

	var reversed_tags: Array[StringName] = []
	for index: int in range(base.size() - 1, -1, -1):
		reversed_tags.append(base[index])

	var rotated: Array[StringName] = []
	for index: int in base.size():
		rotated.append(base[(index + 3) % base.size()])

	var tripled: Array[StringName] = []
	for tag: StringName in base:
		tripled.append(tag)
		tripled.append(tag)
		tripled.append(tag)

	var reversed_and_tripled: Array[StringName] = []
	for tag: StringName in reversed_tags:
		reversed_and_tripled.append(tag)
		reversed_and_tripled.append(tag)

	var orderings: Array[Array] = [base, reversed_tags, rotated, tripled, reversed_and_tripled]
	_expect(tripled.size() == base.size() * 3,
		"the duplicated list holds %d tags, not %d" % [tripled.size(), base.size() * 3])

	var normalized: Array[StringName] = SkillTags.normalize(base)
	for ordering: Array in orderings:
		var as_tags: Array[StringName] = []
		as_tags.assign(ordering)
		_expect(SkillTags.normalize(as_tags) == normalized,
			"an ordering normalized differently: [%s]" % SkillTags.line(as_tags))
		_expect(SkillTags.same_set(as_tags, base), "an ordering is not the same set as the original")
		for rule: SupportEligibility in SkillSupportCatalogue.supports():
			_expect(SupportEligibility.accepts(as_tags, rule) == rule.allows(profile),
				"%s changed its answer for a reordered or duplicated tag list" % rule.support_id)

	## The RULE's own lists are order-independent too, which matters just as
	## much: a support record is authored by hand.
	for rule: SupportEligibility in SkillSupportCatalogue.supports():
		var flipped: SupportEligibility = SupportEligibility.of(
			rule.support_id, rule.display_name,
			_reversed(rule.required_all), _reversed(rule.required_any), _reversed(rule.excluded)
		)
		_expect(flipped.allows(profile) == rule.allows(profile),
			"%s changed its answer when its own rule lists were reversed" % rule.support_id)

	print("  %d orderings of %d tags (up to %d entries with duplicates) -> one identical answer"
		% [orderings.size(), base.size(), tripled.size()])
	_done("order_and_duplicates_change_nothing")


# --- 9. The query is pure, and names no Skill --------------------------------

func _check_the_query_is_pure_and_names_no_skill() -> void:
	print("")
	print("--- 9. The query is PURE and the class-agnostic files name no Skill and no support")

	var profile: SkillTagProfile = SkillSupportCatalogue.quick_strike_profile()
	var rule: SupportEligibility = SkillSupportCatalogue.reaching_edge()
	var tags_before: Array[StringName] = profile.tags.duplicate()
	var required_before: Array[StringName] = rule.required_all.duplicate()
	var excluded_before: Array[StringName] = rule.excluded.duplicate()

	var first: bool = SupportEligibility.accepts(profile.tags, rule)
	var reason: String = SupportEligibility.evaluate(profile.tags, rule)
	var drifted: int = 0
	for call: int in PURITY_CALLS:
		if SupportEligibility.accepts(profile.tags, rule) != first:
			drifted += 1
		if SupportEligibility.evaluate(profile.tags, rule) != reason:
			drifted += 1
	_expect(drifted == 0, "%d of %d repeated calls disagreed with the first" % [drifted, PURITY_CALLS])
	_expect(profile.tags == tags_before, "the query mutated the Skill's tag list")
	_expect(rule.required_all == required_before, "the query mutated the rule's required_all")
	_expect(rule.excluded == excluded_before, "the query mutated the rule's excluded list")

	## THE QUERY CANNOT KNOW A SKILL BY NAME. Scanned RAW, comments included.
	for path: String in CLASS_AGNOSTIC_FILES:
		var source: String = FileAccess.get_file_as_string(path)
		_expect(not source.is_empty(), "%s could not be read" % path)
		var found: PackedStringArray = PackedStringArray()
		for token: String in FORBIDDEN_TOKENS:
			if source.contains(token):
				found.append(token)
		_expect(found.is_empty(),
			"%s names %s — a class-agnostic file must name no Skill and no support"
				% [path.get_file(), ", ".join(found)])

	## And the foundation stores nothing, anywhere.
	for path: String in FOUNDATION_FILES:
		var source: String = FileAccess.get_file_as_string(path)
		_expect(not (source.contains("user://") or source.contains("ConfigFile")
				or source.contains("ResourceSaver") or source.contains("FileAccess.open")),
			"%s names a storage path or writer" % path.get_file())

	print("  %d repeated calls agree; both arguments unmutated; %d class-agnostic files name no Skill"
		% [PURITY_CALLS, CLASS_AGNOSTIC_FILES.size()])
	_done("the_query_is_pure_and_names_no_skill")


# --- 10. The records are coherent and every guard is reachable ---------------

func _check_the_records_are_coherent_and_the_guards_are_reachable() -> void:
	print("")
	print("--- 10. Every shipped record is coherent, and every guard is REACHABLE")

	var problems: PackedStringArray = SkillSupportCatalogue.problems()
	for problem: String in problems:
		print("      reported problem: %s" % problem)
	_expect(problems.is_empty(), "the catalogue reports %d problem(s)" % problems.size())

	var supports: Array[SupportEligibility] = SkillSupportCatalogue.supports()
	_expect(supports.size() == 2, "the catalogue holds %d supports, not 2" % supports.size())
	_expect(supports[0].support_id == SkillSupportCatalogue.REACHING_EDGE_ID
			and supports[1].support_id == SkillSupportCatalogue.SWEEPING_EDGE_ID,
		"the catalogue's support ids are not the two expected")
	_expect(SkillSupportCatalogue.skill_profiles().size() == 1,
		"the catalogue holds %d Skill profiles, not 1"
			% SkillSupportCatalogue.skill_profiles().size())
	_expect(SkillSupportCatalogue.support(&"not_a_support") == null,
		"an unknown support id returned a rule")
	_expect(SkillSupportCatalogue.skill_profile(&"not_a_skill") == null,
		"an unknown Skill id returned a profile")

	var eligible: Array[SupportEligibility] = SkillSupportCatalogue.eligible_supports_for(
		SkillSupportCatalogue.quick_strike_profile()
	)
	_expect(eligible.size() == 2, "%d of 2 supports accept the Skill" % eligible.size())

	## A GUARD NOTHING CAN REACH IS NOT A GUARD. Each is driven once.
	var empty_id: SupportEligibility = SupportEligibility.of(
		&"", "Nameless", [SkillTags.MELEE] as Array[StringName],
		[] as Array[StringName], [] as Array[StringName]
	)
	_expect(empty_id.problem().contains("support_id"), "an empty support_id was accepted")

	var nameless: SupportEligibility = SupportEligibility.of(
		&"test_only", "", [SkillTags.MELEE] as Array[StringName],
		[] as Array[StringName], [] as Array[StringName]
	)
	_expect(nameless.problem().contains("display_name"), "an empty display_name was accepted")

	var silent: SupportEligibility = SupportEligibility.of(
		&"test_only", "Test Only", [] as Array[StringName],
		[] as Array[StringName], [] as Array[StringName]
	)
	_expect(silent.problem().contains("at least one"), "a rule stating nothing was accepted")

	var dead: SupportEligibility = SupportEligibility.of(
		&"test_only", "Test Only", [&"NotATag"] as Array[StringName],
		[] as Array[StringName], [] as Array[StringName]
	)
	_expect(dead.problem().contains("nothing can ever satisfy"),
		"a rule requiring an unrecognised tag reported no problem")

	var contradictory: SupportEligibility = SupportEligibility.of(
		&"test_only", "Test Only", [SkillTags.MELEE] as Array[StringName],
		[] as Array[StringName], [SkillTags.MELEE] as Array[StringName]
	)
	_expect(contradictory.problem().contains("both required and excluded"),
		"a rule that requires and excludes the same tag reported no problem")
	_expect(not contradictory.allows(SkillSupportCatalogue.quick_strike_profile()),
		"a contradictory rule accepted a Skill")

	var no_tags: SkillTagProfile = SkillTagProfile.of(&"test_only", "Test Only", [])
	_expect(no_tags.problem().contains("at least one tag"), "a profile with no tags was accepted")
	var no_id: SkillTagProfile = SkillTagProfile.of(
		&"", "Test Only", [SkillTags.MELEE] as Array[StringName]
	)
	_expect(no_id.problem().contains("skill_id"), "a profile with no id was accepted")

	print("  2 supports, 1 Skill profile, 0 problems; 8 guards each driven once")
	_done("the_records_are_coherent_and_the_guards_are_reachable")


# --- 11. Nothing that already existed changed --------------------------------

func _check_nothing_existing_changed() -> void:
	print("")
	print("--- 11. Nothing that already existed changed, and the foundation is INERT")

	## The display names agree with the review that offers the two supports —
	## pinned in both directions rather than imported, so the foundation does not
	## depend on a temporary review instrument.
	_expect(SkillSupportCatalogue.REACHING_EDGE_NAME
			== RogueliteUpgrade.name_of(RogueliteUpgrade.Kind.REACHING_EDGE),
		"the Reaching Edge display name disagrees with the review's own name")
	_expect(SkillSupportCatalogue.SWEEPING_EDGE_NAME
			== RogueliteUpgrade.name_of(RogueliteUpgrade.Kind.SWEEPING_EDGE),
		"the Sweeping Edge display name disagrees with the review's own name")

	## Build Variety V1's own values, unmoved.
	_expect(RogueliteUpgrade.POOL.size() == 4,
		"the upgrade pool holds %d entries, not 4" % RogueliteUpgrade.POOL.size())
	_expect(is_equal_approx(RogueliteUpgrade.REACHING_EDGE_REACH, 2.65),
		"REACHING_EDGE_REACH moved to %.4f" % RogueliteUpgrade.REACHING_EDGE_REACH)
	_expect(is_equal_approx(RogueliteUpgrade.SWEEPING_EDGE_ARC_DEGREES, 180.0),
		"SWEEPING_EDGE_ARC_DEGREES moved to %.4f" % RogueliteUpgrade.SWEEPING_EDGE_ARC_DEGREES)
	_expect(is_equal_approx(RogueliteUpgrade.SWEEPING_EDGE_SOFT_CONE_DEGREES, 110.0),
		"SWEEPING_EDGE_SOFT_CONE_DEGREES moved to %.4f"
			% RogueliteUpgrade.SWEEPING_EDGE_SOFT_CONE_DEGREES)

	## The canonical combat record, untouched.
	var canonical: QuickStrikeData = load(CANONICAL_QUICK_STRIKE) as QuickStrikeData
	_expect(canonical != null, "the canonical Quick Strike record failed to load")
	_expect(is_equal_approx(canonical.reach, 1.65), "reach moved to %.4f" % canonical.reach)
	_expect(is_equal_approx(canonical.release_arc_degrees, 100.0),
		"release_arc_degrees moved to %.4f" % canonical.release_arc_degrees)
	_expect(is_equal_approx(canonical.soft_target_cone_degrees, 65.0),
		"soft_target_cone_degrees moved to %.4f" % canonical.soft_target_cone_degrees)
	_expect(is_equal_approx(canonical.action_time, 0.80),
		"action_time moved to %.4f" % canonical.action_time)
	_expect(canonical.maximum_targets == 1,
		"maximum_targets moved to %d" % canonical.maximum_targets)
	_expect(canonical.problem().is_empty(),
		"the canonical record reports: %s" % canonical.problem())

	## THE FOUNDATION IS INERT BY MEASUREMENT. No script outside the two
	## foundation slices references any of its four classes, so nothing in Build
	## Variety V1 — or anywhere else in the running game — can behave differently
	## because these files exist. Foundation B's four scripts DO consume it and
	## are excluded here by name; that they are themselves unreached by the
	## running game is proved by their own suite, not claimed by this one.
	var referenced: PackedStringArray = PackedStringArray()
	var scanned: int = 0
	for root: String in ["res://scripts", "res://scenes", "res://data", "res://addons"]:
		for path: String in _files_under(root, [".gd", ".tscn", ".tres"]):
			if FOUNDATION_FILES.has(path) or CONSUMING_FOUNDATION_FILES.has(path):
				continue
			scanned += 1
			var source: String = FileAccess.get_file_as_string(path)
			var authorized: bool = AUTHORIZED_READERS.has(path)
			for name: String in FOUNDATION_CLASSES:
				if not source.contains(name):
					continue
				if authorized and AUTHORIZED_READER_CLASSES.has(name):
					continue
				if _review_reader_may_name(path, name):
					continue
				referenced.append("%s names %s" % [path.get_file(), name])
	_expect(referenced.is_empty(),
		"the foundation is referenced by code outside it: %s" % ", ".join(referenced))

	## The entrypoint and the InputMap, untouched.
	_expect(String(ProjectSettings.get_setting("application/run/main_scene", ""))
			== "res://scenes/app/prototype_app.tscn",
		"the project entrypoint is %s"
			% ProjectSettings.get_setting("application/run/main_scene", ""))
	## Counted exactly as every existing suite counts it — `ui_confirm` and
	## `ui_cancel` are project-declared overrides of built-in actions and are part
	## of the accepted 31, while every other `ui_` action is Godot's own. A second,
	## subtly different way of counting the same set would be a way for two suites
	## to disagree about an unchanged file.
	var actions: int = 0
	for action: StringName in InputMap.get_actions():
		if String(action).begins_with("ui_") and not String(action) in ["ui_confirm", "ui_cancel"]:
			continue
		actions += 1
	_expect(actions == 31, "the InputMap holds %d project actions, not 31" % actions)

	print("  %d project files scanned, 0 outside the foundation reference it; entrypoint and 31 actions unchanged"
		% scanned)
	_done("nothing_existing_changed")


# --- Plumbing ----------------------------------------------------------------

func _check_every_check_ran() -> void:
	print("")
	print("--- Every check this suite owes actually reached its last line")
	var missing: PackedStringArray = PackedStringArray()
	for owed: String in OWED_CHECKS:
		if not _reached.has(owed):
			missing.append(owed)
	var extra: PackedStringArray = PackedStringArray()
	for ran: Variant in _reached:
		if not OWED_CHECKS.has(String(ran)):
			extra.append(String(ran))
	_expect(missing.is_empty(), "check(s) never completed: %s" % ", ".join(missing))
	_expect(extra.is_empty(), "check(s) ran that the suite does not owe: %s" % ", ".join(extra))
	print("  %d of %d owed checks completed" % [_reached.size(), OWED_CHECKS.size()])


func _expect(condition: bool, failure_message: String) -> void:
	_checks += 1
	if not condition:
		_failures.append(failure_message)


func _done(check_name: String) -> void:
	_reached[check_name] = true


static func _reversed(source: Array[StringName]) -> Array[StringName]:
	var out: Array[StringName] = []
	for index: int in range(source.size() - 1, -1, -1):
		out.append(source[index])
	return out


func _files_under(root: String, extensions: Array[String]) -> PackedStringArray:
	var out: PackedStringArray = PackedStringArray()
	var dir: DirAccess = DirAccess.open(root)
	if dir == null:
		return out
	dir.list_dir_begin()
	var entry: String = dir.get_next()
	while not entry.is_empty():
		if entry != "." and entry != "..":
			var full: String = root.path_join(entry)
			if dir.current_is_dir():
				out.append_array(_files_under(full, extensions))
			else:
				for extension: String in extensions:
					if entry.ends_with(extension):
						out.append(full)
						break
		entry = dir.get_next()
	dir.list_dir_end()
	return out
