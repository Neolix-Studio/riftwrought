class_name RogueliteLevelUpChoiceReview
extends RogueliteExperienceCollectionReview
## Riftwrought — Roguelite I2: Playable Three-Lane Level-Up Choice Review V1
## (decision D-293), extended by Roguelite I11: Repeated Playable Level-Up Offer Loop V1
## (decision D-314).
##
## THE ONE QUESTION THIS SCENE ASKS: does every visible level-up read correctly in play?
##
##     kill Graveblades -> collect real Experience Motes -> exactly the current level's
##         requirement -> a three-card panel opens on its own and holds the world
##         still -> exactly one lane is chosen -> the run is one level higher with that
##         choice recorded in the expedition's temporary build -> if the experience the
##         run kept already meets the next level's requirement, that level's own offer
##         takes the cards' place in the same panel, the world still held -> otherwise
##         the panel closes and play resumes
##
## IT PROVES THE OFFERS AND THE CHOICES, AND NOTHING A CHOICE WOULD DO. Each chosen
## Support pair or passive card is recorded in the run's own temporary build by the
## accepted mechanisms and is NOT applied to the character: the player's movement,
## attack and every other live value stay exactly as the accepted loop set them,
## and the panel says so on screen.
##
##
## IT IS THE ACCEPTED EXPERIENCE COLLECTION REVIEW (H9), WHOLE, WITH ONE LAYER ON TOP
## ---------------------------------------------------------------------------
## The scene INHERITS H9's accepted scene and this script EXTENDS H9's runtime. It
## overrides neither `_ready()` nor anything H9 or the core loop assembles: the
## route, the five Graveblades, the one Experience Mote runtime per expedition, its
## registrations, the automatic sweep, the markers, F8 and the review panel are
## H9's, unedited and uncopied.
##
## Six inherited methods are overridden, and five call the method they override:
##   * `_build_run_surfaces()` adds the level-up panel and the receipt section;
##   * `_physics_process()` asks, after the accepted tick and H9's sweep, whether
##     the current level's offer should open now;
##   * `_discard_mote_runtime()` clears this layer's per-expedition state after H9
##     lets the whole Experience Mote runtime go;
##   * `_any_modal_open()` counts the level-up panel as a modal, so the accepted
##     gate test never runs behind it;
##   * `experience_review_reading()` withholds H9's "LEVEL-UP READY" lines — see
##     below.
## The sixth, `_maybe_start_verification()`, answers this review's own flag
## instead of H9's, so H9's suite can never start in this scene.
##
##
## EACH LEVEL'S OFFER OPENS ONCE, ON ITS OWN, AND ONLY THE RUN DECIDES WHAT IT HOLDS
## ---------------------------------------------------------------------------
## After a physics tick in which the expedition is in progress, the world is not
## paused, the player is alive and no modal is open, H9's own reading is asked
## whether the run's CURRENT level has its requirement met. The first time it has,
## the Experience Mote runtime is asked — EXACTLY ONCE FOR THAT LEVEL — to open the
## current level's offer from the accepted catalogues' own records: the equipped
## Skill profiles, the support definitions and the passive-card records. The run
## (Foundation G4, behind Foundation I1) alone decides readiness, the root seed —
## its own per-level derivation (Foundation G2) for this run's seed and that level —
## the three lanes and what each holds. Reaching the requirement advances nothing:
## the level moves only when a lane is taken.
##
## ONE REQUEST PER LEVEL, AND THE GUARD IS ONE INTEGER (Roguelite I11, D-314).
## `_offer_attempted_level` holds the Rift level whose one opening request this
## expedition has made. A level only ever rises within an expedition, so "this level
## has already been asked for" is exactly "the run stands at the level last asked
## for" — no list of levels, no history, no queue of offers and no second seed
## counter: what each level consumed is the run's own ledger's to hold. Nothing caps
## the level and nothing counts how many offers an expedition may make.
##
## A REFUSED OPENING IS SHOWN, AND NEVER RETRIED. The request is recorded before it is
## made, whatever it answers, so a refusal is asked once for its level rather than
## every frame, and its exact words are written into the review panel. A successful
## choice moves the run on to a level not yet asked for, which is then eligible on its
## own; the death, Fallen return, completion and F5 that end an expedition clear the
## guard with everything else the expedition owned.
##
## BANKED LEVELS ARE CHOSEN ONE AT A TIME, IN ONE PANEL THAT NEVER LETS THE WORLD GO
## (D-314). A successful choice advances exactly one level, however much experience
## the run kept. If what it kept already meets the next level's requirement, that
## level's own offer is asked for IN THE SAME CALL and handed to the same standing
## panel, which shows its three cards in place of the ones just taken. The panel is
## never closed between the two, so the world is never let go: no physics frame, no
## sweep, no enemy step and no gameplay input can run between one offer and the next.
## The input that took the previous card was spent on it; only a fresh input chooses
## from the next offer. Nothing chooses a card on its own and nothing loops — each
## further level waits for its own explicit choice. When what the run kept no longer
## meets the next requirement, the panel closes and play resumes.
##
## THE PANEL READS THE STANDING OFFER, NEVER A LIST OF ITS OWN. Its three cards are
## the offer's own lanes in the offer's own order, each lane's label is the offer
## contract's own, and each name and effect line is resolved through the accepted
## catalogues from the identity that lane would grant. Nothing here names a Skill, a
## support, a card, a magnitude, a weight or a tag. The Support card shows which
## Skill it applies to, read from the lane's two-id identity; no rank transition is
## shown before choosing, because the offer exposes none to show.
##
## THE SUPPORT CARD FOLLOWS THE KIND OF CONTENT THE OFFER STORED (Roguelite I10,
## decision D-312). Since Foundation I7 an exhausted Support lane may carry one passive
## card instead of a support. The card reads the standing offer's own Support content
## kind and never infers it from how many ids a lane grants: a Support progression card
## reads the support's name and "Applies to <Skill>" exactly as before; a passive-fallback
## card is still labelled Support and reads the passive card's own name over "Supports
## maxed — <its effect line>". Neither shows an id, a category number, a weight or a
## ticket. After a successful fallback choice the receipt reads "Support — <card name>
## (<its effect line>)", from the same catalogue lines and the same "name (effect)" form an
## ordinary passive receipt uses (D-313), over "Passive fallback from <category>", the
## category named by the passive lane that draws from it; it shows no support progression
## and no rank. Every other card and receipt reads exactly as it did.
##
## WHILE AN OFFER STANDS, THE PREVIOUS RECEIPT IS HIDDEN (D-313). Behind the open panel the
## receipt section shows only its heading and "Level-up offer open …"; a refused choice
## leaves it so. Behind an offer that took a chosen one's place (D-314) the receipt of the
## level just taken stays hidden too, so only the choice that finally closes the panel
## brings its newly completed receipt up.
##
## A FALLBACK IS REACHED IN PLAY THE SAME WAY AS EVERY OTHER OFFER (D-314). One exists only
## once both supports are held at their maximum rank, four Support choices in. The route's
## own five Graveblades carry enough experience for the first level-up only, so reaching a
## fallback in this scene takes experience from elsewhere; once the run has it, the
## fallback offer opens, or takes a chosen offer's place, exactly as any other.
##
##
## TAKING A LANE IS THE RUN'S TRANSACTION, AND THIS LAYER ONLY REPORTS IT
## ---------------------------------------------------------------------------
## A card hands its LANE to `choose_offered_lane()`, which asks the Experience Mote
## runtime to take it and reads the run-level record that comes back. A refusal
## keeps the panel open over the same offer, keeps the world paused and shows the
## refusal's exact words. A success is read through its own one-level receipt —
## which lane, what it granted and, for Support, the progression it consumed — into
## a presentation receipt of plain strings; only then does the next banked level's
## offer take the cards' place, or, with none, the panel close and play resume.
## Nothing here holds the build, the ledger, the offer or a level beyond the one
## guard above: the accepted record is kept only as review instrumentation for the
## verification, and it carries no authority over the run.
##
##
## H9's "LEVEL-UP READY" LINES ARE WITHHELD HERE, AND THAT IS COPY RATHER THAN A RULE
## ---------------------------------------------------------------------------
## H9's panel shows "LEVEL-UP READY" and "The three-card offer is the next review;
## this scene does not open it." whenever the requirement is met. In THIS scene the
## second sentence would be false — this is the review that opens it — so the
## reading handed to H9's panel reports the level-up as not ready, and the receipt
## section below states the offer's own state instead. H9's panel file is untouched;
## only the one reading it is given in this scene changes.
##
## WHAT IT DOES NOT DO. No effect application; no reroll, skip, close, cancel, luck,
## rarity or pity; no automatic choice, no queue of offers and no level cap; no
## experience source of its own; no card art or final UI; no enemy scaling, rounds,
## Guardians or loot; no saving; nothing written anywhere; no InputMap action.
##
## Run it with Run Current Scene — never Run Project — or:
##   godot --path game res://scenes/roguelite/roguelite_level_up_choice_review.tscn -- --seed 99

const LEVEL_UP_VERIFICATION_SCRIPT: String = "res://tests/roguelite_level_up_choice_review_verification.gd"
const OFFER_PANEL_SCRIPT: String = "res://scripts/roguelite/level_up/rift_level_up_offer_panel.gd"

## What `_offer_attempted_level` holds before an expedition has asked for any offer. A Rift
## level is at least 1, so no level can be mistaken for it (Roguelite I11, D-314).
const NO_LEVEL_ASKED: int = 0

const RECEIPT_TITLE: String = "Temporary build — this expedition"
const RECEIPT_NOTE: String = "Recorded in the temporary build; not applied to the character in this review."
const OFFER_STANDING_TEXT: String = "Level-up offer open — choose one of the three cards."

## A passive-fallback Support card's detail, over the card's own effect line, and the
## receipt's secondary line after one is chosen, over its category (Roguelite I10, D-312).
const SUPPORTS_MAXED_DETAIL: String = "Supports maxed — %s"
const FALLBACK_RECEIPT_LINE: String = "Passive fallback from %s"

## The three-card panel, made in code at assembly.
var level_up_panel: RiftLevelUpOfferPanel

## Review instrumentation, read by the receipt section and the verification.
var offer_open_calls: int = 0
var offer_open_refusals: int = 0
var last_offer_refusal: String = ""
var choice_attempts: int = 0
var choice_refusals: int = 0
var choices_taken: int = 0
## The last run-level record a choice answered, exactly as it came back — review
## instrumentation only, cleared with the expedition. It is a value: holding it
## moves nothing and can move nothing in the run.
var last_choice_record: RiftRunLevelUpResult = null
## The experience the run held the moment the successful choice returned.
var last_retained_experience: float = 0.0

## The Rift level whose one opening request this expedition has made, or
## `NO_LEVEL_ASKED` (Roguelite I11, D-314). One integer, never a list — see the header.
## Cleared only when H9 lets the expedition's runtime go.
var _offer_attempted_level: int = NO_LEVEL_ASKED

## The presentation receipt of the successful choice: plain strings only.
var _receipt: Dictionary = {}

var _receipt_rule: Panel
var _receipt_title: Label
var _receipt_status: Label
var _receipt_choice: Label
var _receipt_progression: Label
var _receipt_level: Label
var _receipt_note: Label


# --- Assembly: H9's surfaces, then this review's two ------------------------

func _build_run_surfaces() -> void:
	super()
	level_up_panel = (load(OFFER_PANEL_SCRIPT) as GDScript).new() as RiftLevelUpOfferPanel
	level_up_panel.name = "LevelUpOfferPanel"
	## Appended LAST, after every accepted modal: a CanvasLayer draws its children
	## in order, so the panel and its dim draw over everything else on screen.
	$CanvasLayer.add_child(level_up_panel)
	level_up_panel.bind_room(self)
	## The receipt section states the standing offer whenever the panel opens, whoever
	## opened it (Roguelite I10, D-312): the rendered fallback review shows a later offer
	## it opens itself. In play each opening refreshes it again at once, and an offer that
	## takes a chosen one's place is refreshed by the choice that brought it (D-314).
	level_up_panel.opened.connect(_refresh_receipt)
	_build_receipt_section()
	log_event("level-up review", "three-lane level-up choice layer assembled on the accepted experience review")


## THE RECEIPT IS PART OF THE REVIEW PANEL H9 ALREADY SHOWS, appended beneath its
## last line. H9's panel grows upward from a fixed bottom edge, so these lines never
## push it off the screen; H9's own file and its own lines are untouched.
func _build_receipt_section() -> void:
	var box: VBoxContainer = experience_hud.panel.get_child(0) as VBoxContainer
	_receipt_rule = Panel.new()
	_receipt_rule.custom_minimum_size = Vector2(0.0, 1.0)
	var style: StyleBoxFlat = StyleBoxFlat.new()
	style.bg_color = RogueliteExperienceReviewHud.IRON
	_receipt_rule.add_theme_stylebox_override("panel", style)
	_receipt_rule.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_receipt_title = _receipt_line(RECEIPT_TITLE, 13, RogueliteExperienceReviewHud.COPPER)
	_receipt_status = _receipt_line("", 12, RogueliteExperienceReviewHud.TEXT)
	_receipt_choice = _receipt_line("", 13, RogueliteExperienceReviewHud.TEXT)
	_receipt_progression = _receipt_line("", 12, RogueliteExperienceReviewHud.MOTE_VIOLET)
	_receipt_level = _receipt_line("", 12, RogueliteExperienceReviewHud.TEXT)
	_receipt_note = _receipt_line(RECEIPT_NOTE, 12, RogueliteExperienceReviewHud.TEXT_DIM)
	for control: Control in [_receipt_rule, _receipt_title, _receipt_status, _receipt_choice,
			_receipt_progression, _receipt_level, _receipt_note]:
		box.add_child(control)
	_refresh_receipt()


# --- Each level's one offer ------------------------------------------------------

func _physics_process(delta: float) -> void:
	super(delta)
	_open_offer_when_ready()


## Asks for the current level's offer after a tick in which the world ran, the first
## time the run stands at that level with its requirement met, and opens the panel
## over it. Every condition is a question about the world this layer runs in.
func _open_offer_when_ready() -> void:
	if get_tree().paused or _any_modal_open() or not _current_level_is_owed_an_offer():
		return
	if _ask_for_current_offer():
		_present_standing_offer()
	_refresh_receipt()


## Whether the run's CURRENT level is owed its one opening request: an expedition is
## in progress with a living player, this level has not been asked for yet, and H9's
## own reading of the accepted curve says its requirement is met. Readiness here is
## only the question of whether to ask; the run re-decides it when it is asked.
func _current_level_is_owed_an_offer() -> bool:
	if mote_runtime == null or loop_state != LoopState.IN_RUN or not player.is_alive():
		return false
	if mote_runtime.level() == _offer_attempted_level:
		return false
	var reading: Dictionary = super.experience_review_reading()
	return bool(reading.get("level_up_ready", false))


## The one place an offer is asked for: the Experience Mote runtime is asked to open the
## current level's offer from the accepted catalogues' own records — and the request is
## recorded against that level FIRST, so whatever it answers it is never asked again for
## the same level. True when the offer opened; a refusal is written into the review panel.
func _ask_for_current_offer() -> bool:
	_offer_attempted_level = mote_runtime.level()
	offer_open_calls += 1
	var answer: String = mote_runtime.open_level_up_offer(
		SkillSupportCatalogue.skill_profiles(),
		SkillSupportCatalogue.support_definitions(),
		PassiveCardCatalogue.records()
	)
	if answer.is_empty():
		return true
	offer_open_refusals += 1
	last_offer_refusal = answer
	_note_refusal("level-up offer did not open", answer)
	_refresh_run_hud()
	return false


## Shows the offer that now stands: the panel opens over it or — while the panel still
## stands over the offer a choice has just taken (D-314) — shows its three cards in that
## offer's place. True when it is on screen.
func _present_standing_offer() -> bool:
	var chained: bool = level_up_panel.is_open
	var cards: Array[Dictionary] = standing_offer_cards()
	log_event("level-up offer", "%s at Rift level %d with %s experience: %d card(s)" % [
		"chained" if chained else "opened", mote_runtime.level(), str(mote_runtime.experience()), cards.size(),
	])
	if level_up_panel.open_for_offer(cards):
		return true
	_note_refusal("level-up panel did not open", "the standing offer holds %d lane(s), and the panel shows exactly %d" % [
		cards.size(), RiftLevelUpOfferPanel.CARD_SLOTS,
	])
	return false


## One presentation card per lane of the STANDING offer, in the offer's own order,
## each resolved from the identity that lane would grant and, for the Support lane,
## from the kind of content the offer stored. A pure reading: it opens, takes and
## moves nothing, and it decides no kind of its own.
##
## PUBLIC SINCE ROGUELITE I10 (D-312). This review asks for it once for every offer it
## shows. The rendered passive-fallback review also asks for it, to show a standing offer
## it opened itself — as a reading, never as a way to open or take anything.
func standing_offer_cards() -> Array[Dictionary]:
	var cards: Array[Dictionary] = []
	if mote_runtime == null:
		return cards
	var support_content: int = mote_runtime.offer_support_content_kind()
	for lane: int in mote_runtime.offer_lanes():
		cards.append(_card_for(lane, mote_runtime.offer_identity_for(lane), support_content))
	return cards


## Plain strings for one lane. Every name and effect line is the accepted catalogue's
## own. A Support progression lane's identity is its Skill id then its support id; a
## passive-fallback Support lane's, and each passive lane's, is one card id.
##
## THE SUPPORT LANE IS READ BY THE KIND OF CONTENT IT CARRIES (Roguelite I10, D-312) —
## the offer's stored kind, or a receipt's — and never by how many ids it grants.
func _card_for(lane: int, identity: PackedStringArray, support_content: int) -> Dictionary:
	var card: Dictionary = {"lane": lane, "lane_label": RiftOffer.lane_label(lane), "title": "", "detail": ""}
	if identity.is_empty():
		card["title"] = "nothing offered"
		return card
	if lane == RiftOffer.Lane.SUPPORT:
		if support_content == RiftOffer.SupportContentKind.SUPPORT_PROGRESSION:
			card["title"] = _support_name(_nth(identity, 1))
			card["detail"] = "Applies to %s" % _skill_name(_nth(identity, 0))
		elif support_content == RiftOffer.SupportContentKind.PASSIVE_FALLBACK:
			var fallback: PackedStringArray = _passive_lines(identity[0])
			card["title"] = fallback[0]
			card["detail"] = SUPPORTS_MAXED_DETAIL % fallback[1]
		else:
			card["title"] = "Support content not stated"
		return card
	var lines: PackedStringArray = _passive_lines(identity[0])
	card["title"] = lines[0]
	card["detail"] = lines[1]
	return card


## A passive card's own name and effect line, from the accepted catalogue.
func _passive_lines(card_id: String) -> PackedStringArray:
	var record: PassiveCardDefinition = PassiveCardCatalogue.record(StringName(card_id))
	if record == null:
		return PackedStringArray([card_id, "not in the catalogue"])
	return PackedStringArray([record.display_name, record.effect_line()])


## The id at `index`, or "" — a bounds guard only. Which kind a lane carries is never
## read from here.
static func _nth(identity: PackedStringArray, index: int) -> String:
	return identity[index] if index < identity.size() else ""


## A passive card's receipt form: its name, and its effect in brackets. The one place
## that form is written, for an ordinary passive receipt and a fallback's alike (D-313).
static func _with_effect(name: String, effect: String) -> String:
	return "%s (%s)" % [name, effect]


## A passive category's name, as the passive lane that draws from it is named — the
## one place the lane vocabulary meets the stat vocabulary.
static func _category_label(category: int) -> String:
	for passive_lane: int in [RiftOffer.Lane.COMBAT_DEFENCE, RiftOffer.Lane.UTILITY]:
		if RiftOffer.category_for_lane(passive_lane) == category:
			return RiftOffer.lane_label(passive_lane)
	return "an unrecognised category"


func _skill_name(skill_id: String) -> String:
	var profile: SkillTagProfile = SkillSupportCatalogue.skill_profile(StringName(skill_id))
	return profile.display_name if profile != null else skill_id


func _support_name(support_id: String) -> String:
	var definition: SupportDefinition = SkillSupportCatalogue.support_definition(StringName(support_id))
	return definition.display_name() if definition != null else support_id


# --- Taking a lane -----------------------------------------------------------------

## The one path a card takes: the lane goes to the run, and the run's own record
## decides what happens to the panel. A refusal keeps the same offer open and the
## world paused and shows the exact reason; a success becomes a presentation
## receipt, and only then does the next banked level's offer take the cards' place —
## or, with none owed, the panel close.
func choose_offered_lane(lane: int) -> void:
	if mote_runtime == null or level_up_panel == null or not level_up_panel.is_open:
		log_event("level-up choice ignored", "no level-up panel is open")
		return
	choice_attempts += 1
	var record: RiftRunLevelUpResult = mote_runtime.choose_level_up_lane(lane)
	last_choice_record = record
	if not record.succeeded():
		choice_refusals += 1
		log_event("level-up choice refused", record.failure_reason())
		level_up_panel.show_refusal(record.failure_reason())
		_refresh_run_hud()
		return
	choices_taken += 1
	last_retained_experience = mote_runtime.experience()
	_receipt = _receipt_from(record)
	log_event("level-up choice", "%s; Rift level %d -> %d with %s experience retained" % [
		String(_receipt["choice"]), record.source_level, mote_runtime.level(), str(last_retained_experience),
	])
	## THE NEXT BANKED LEVEL'S OFFER TAKES THIS ONE'S PLACE (D-314), asked in this same
	## call while the panel still holds the world, so nothing can run between the two.
	## Only when no next offer now stands does the panel close and play resume.
	var chained: bool = false
	if _current_level_is_owed_an_offer() and _ask_for_current_offer():
		chained = _present_standing_offer()
	if not chained:
		level_up_panel.close("chose %s" % String(_receipt["lane_label"]))
	_refresh_receipt()
	## H9's panel reads the run's level and experience; the choice just moved both.
	_refresh_run_hud()


## Plain strings read out of the accepted receipt the record carries. Nothing is
## decided here: the lane, the granted identity, the consumed progression and — since
## Roguelite I10 (D-312) — the consumed Support content kind and a fallback's category
## are the receipt's own, and every name is the catalogue's. A passive fallback reads
## as its card's name and effect over the category it came from, with no progression and
## no rank.
func _receipt_from(record: RiftRunLevelUpResult) -> Dictionary:
	var receipt: RiftLevelUpResult = record.level_up()
	var granted: PackedStringArray = receipt.granted_identity()
	var card: Dictionary = _card_for(receipt.lane, granted, receipt.support_content_kind)
	var shown: String = String(card["title"])
	var secondary: String = receipt.support_progression_line() if receipt.carries_support_progression() else ""
	if receipt.carries_support_fallback():
		## The passive card's own name and effect line, read through the same catalogue lines
		## the card and an ordinary passive receipt read — never the card's "Supports maxed"
		## detail, and no magnitude or wording of its own (D-313).
		var fallback: PackedStringArray = _passive_lines(_nth(granted, 0))
		shown = _with_effect(fallback[0], fallback[1])
		secondary = FALLBACK_RECEIPT_LINE % _category_label(receipt.support_fallback_category)
	elif receipt.lane == RiftOffer.Lane.SUPPORT \
			and receipt.support_content_kind == RiftOffer.SupportContentKind.SUPPORT_PROGRESSION:
		shown = "%s → %s" % [_skill_name(_nth(granted, 0)), _support_name(_nth(granted, 1))]
	elif not String(card["detail"]).is_empty():
		shown = _with_effect(String(card["title"]), String(card["detail"]))
	return {
		"lane_label": String(card["lane_label"]),
		"choice": "%s — %s" % [card["lane_label"], shown],
		"progression": secondary,
		"level": "Rift level %d → %d · %s XP carried over" % [
			record.source_level, mote_runtime.level(), _amount(last_retained_experience),
		],
	}


## What the receipt section says, from this layer's own state.
##
## WHILE AN OFFER STANDS THE PREVIOUS CHOICE'S RECEIPT IS HIDDEN (Roguelite I10, D-313):
## behind the open panel only the heading and the standing line show. The receipt is kept,
## not cleared, and comes back only when a successful choice has replaced it and closed
## the panel. Every other state reads exactly as it did.
func _refresh_receipt() -> void:
	if _receipt_title == null:
		return
	var standing: bool = level_up_panel != null and level_up_panel.is_open
	var chosen: bool = not _receipt.is_empty() and not standing
	var refused: bool = not last_offer_refusal.is_empty()
	var any: bool = not _receipt.is_empty() or standing or refused
	_receipt_rule.visible = any
	_receipt_title.visible = any
	_receipt_status.visible = standing or (refused and _receipt.is_empty())
	_receipt_status.text = OFFER_STANDING_TEXT if standing \
		else "The level-up offer did not open: %s" % last_offer_refusal
	_receipt_status.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_receipt_choice.visible = chosen
	_receipt_choice.text = String(_receipt.get("choice", ""))
	_receipt_progression.visible = chosen and not String(_receipt.get("progression", "")).is_empty()
	_receipt_progression.text = String(_receipt.get("progression", ""))
	_receipt_level.visible = chosen
	_receipt_level.text = String(_receipt.get("level", ""))
	_receipt_note.visible = chosen


# --- Inherited overrides -------------------------------------------------------------

## H9 lets the whole expedition's Experience Mote state go; this layer's one-integer
## guard, its record and its receipt go with it, so the next expedition begins again at
## its first level with nothing asked for.
func _discard_mote_runtime(reason: String) -> void:
	super(reason)
	_offer_attempted_level = NO_LEVEL_ASKED
	last_offer_refusal = ""
	last_choice_record = null
	last_retained_experience = 0.0
	_receipt = {}
	_refresh_receipt()


func _any_modal_open() -> bool:
	return super() or (level_up_panel != null and level_up_panel.is_open)


## H9's panel reading, with its level-up lines withheld (see the header): in this
## scene the three-card panel IS the level-up, and H9's note says this scene does
## not open one.
func experience_review_reading() -> Dictionary:
	var reading: Dictionary = super()
	reading["level_up_ready"] = false
	return reading


# --- Readings for the verification and the evidence frames ----------------------------

## Whether this expedition has already asked for the offer of the run's CURRENT level —
## false in the Nexus, below that level's requirement, and again once a choice has moved
## the run on to a level not yet asked for (Roguelite I11, D-314).
func offer_attempted() -> bool:
	return mote_runtime != null and _offer_attempted_level == mote_runtime.level()


## The Rift level whose one opening request this expedition last made, or
## `NO_LEVEL_ASKED` (Roguelite I11, D-314).
func offer_attempted_level() -> int:
	return _offer_attempted_level


func receipt_text(key: String) -> String:
	return String(_receipt.get(key, ""))


## Every receipt line, in order, for the on-screen measurement.
func receipt_controls() -> Array[Control]:
	return [_receipt_title, _receipt_status, _receipt_choice, _receipt_progression, _receipt_level, _receipt_note]


# --- Builders ----------------------------------------------------------------------------

func _receipt_line(text: String, size: int, colour: Color) -> Label:
	var label: Label = Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", size)
	label.add_theme_color_override("font_color", colour)
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return label


## A whole amount as a whole number, anything else to one decimal place.
static func _amount(value: float) -> String:
	if value == floorf(value):
		return "%d" % int(value)
	return "%.1f" % value


# --- This review's own verification ------------------------------------------------

## Replaces H9's flag, so H9's accepted suite can never start in this scene and
## this review's suite has its own.
func _maybe_start_verification() -> void:
	var arguments: PackedStringArray = OS.get_cmdline_user_args()
	if not arguments.has("--verify-level-up"):
		return
	var script: GDScript = load(LEVEL_UP_VERIFICATION_SCRIPT) as GDScript
	var runner: Node = Node.new()
	runner.name = "RogueliteLevelUpChoiceReviewVerification"
	runner.set_script(script)
	runner.set("review", self)
	runner.set("arguments", arguments)
	add_child(runner)
