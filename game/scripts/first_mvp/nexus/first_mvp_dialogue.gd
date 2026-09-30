class_name FirstMvpDialogue
extends RefCounted
## First-MVP — Gate 1E: the first conversation, and only the first (D-219).
##
## THE FOUR FACTS, AND NOTHING ELSE.
## `design/FIRST_MVP_CAMPAIGN_AND_PROGRESSION_JOURNEY.md` §7, "First
## Conversation Purpose", says the first conversation establishes ONLY:
##
##   1. Mara expected the route to be empty or fatal
##   2. the character returned as one continuing person
##   3. the Nexus recognizes the Mark
##   4. an unresolved command in the Crownless Bastion is preventing stable
##      passage
##
## and that "The complete Unseaming history remains in later dialogue and
## Chronicle entries."
##
## So the conversation below is FOUR LINES, one per fact, and the verification
## asserts both directions: every fact is present, and none of the forbidden
## subjects is. It scans the actual line text for the Unseaming, Rift Shards,
## Rift Echo, Echo Hunts, the Warden's history, procedural generation,
## crafting, Augments, the Forge, and the meanings of Fracture / Anchor /
## Wrought. A first conversation that explains cosmology is the single easiest
## way to spoil an opening, and it is cheap to prove it does not.
##
## THE WORDING IS THE BRIEF'S OWN PROVISIONAL COPY, used verbatim. The brief
## supplies it and says: "Treat this wording as implementation-quality
## provisional first-MVP dialogue, not immutable final prose." It is recorded
## here as provisional and the Gate 1E report asks the owner for a prose pass.
##
## SKIPPABLE AND REPLAY-SAFE, both required by the brief. `advance()` moves one
## line; `skip_to_end()` jumps to the last. Replaying grants nothing, because
## the reward lives on `CharacterState`'s latch and not on reaching the end of
## this array — reading it a second time is simply reading it again.
##
## NO PLAYER DIALOGUE BRANCHES. The brief: "Do not add unnecessary player
## dialogue branches." There is one speaker and one direction.
##
## NOT A DIALOGUE SYSTEM. No node graph, no condition, no variable
## substitution, no localization table, no portrait, no voice line id. It is an
## ordered list of lines with a speaker, which is exactly what one conversation
## needs and exactly what a later system would replace rather than extend.

## The canonical first conversation. Provisional first-MVP prose.
const FIRST_CONVERSATION: Array[Dictionary] = [
	{
		"speaker": "Mara Veyl",
		"line": "That route was dead. I was waiting for nothing — or a body.",
		"fact": "mara_expected_empty_or_fatal",
	},
	{
		"speaker": "Mara Veyl",
		"line": "But you came back whole. The same person who went in.",
		"fact": "returned_as_one_continuing_person",
	},
	{
		"speaker": "Mara Veyl",
		"line": "The Nexus is reacting to that mark on you. I don't know why yet.",
		"fact": "nexus_recognizes_the_mark",
	},
	{
		"speaker": "Mara Veyl",
		"line": "Something in the Crownless Bastion is still holding an old command. Until it breaks, the route won't stabilize.",
		"fact": "unresolved_command_blocks_passage",
	},
]

## The four facts this conversation owes, by id. Asserted present.
const OWED_FACTS: Array[StringName] = [
	&"mara_expected_empty_or_fatal",
	&"returned_as_one_continuing_person",
	&"nexus_recognizes_the_mark",
	&"unresolved_command_blocks_passage",
]

## Subjects the FIRST conversation must not raise. Asserted absent from the
## line text, case-insensitively. Each is named in the brief's "Do not explain"
## list or in §7's own deferral.
const FORBIDDEN_SUBJECTS: Array[String] = [
	"unseaming", "rift shard", "rift echo", "echo hunt", "crownless warden",
	"procedural", "crafting", "augment", "forge", "wrought", "fracture",
	"anchor network", "passive web", "distortion", "intensity", "pursuit",
]

var lines: Array[Dictionary] = []
var index: int = 0
var completed: bool = false
var times_opened: int = 0
var times_skipped: int = 0


func _init(conversation: Array[Dictionary] = []) -> void:
	lines = conversation if not conversation.is_empty() else FIRST_CONVERSATION.duplicate(true)


func begin() -> void:
	index = 0
	times_opened += 1


func current() -> Dictionary:
	if lines.is_empty():
		return {}
	return lines[clampi(index, 0, lines.size() - 1)]


func current_speaker() -> String:
	return String(current().get("speaker", ""))


func current_line() -> String:
	return String(current().get("line", ""))


func is_last_line() -> bool:
	return index >= lines.size() - 1


func progress_line() -> String:
	return "%d of %d" % [index + 1, lines.size()]


## Advances one line. Returns false when there was no next line, which is how
## the panel knows the conversation is finished rather than by counting itself.
func advance() -> bool:
	if is_last_line():
		completed = true
		return false
	index += 1
	if is_last_line():
		completed = true
	return true


## Jumps to the last line. The conversation still counts as read: skipping is a
## legitimate way to have heard it, and re-reading it later is free.
func skip_to_end() -> void:
	if lines.is_empty():
		return
	times_skipped += 1
	index = lines.size() - 1
	completed = true


func facts_present() -> Array[StringName]:
	var found: Array[StringName] = []
	for entry: Dictionary in lines:
		found.append(StringName(entry.get("fact", "")))
	return found


## Every subject in FORBIDDEN_SUBJECTS that actually appears in the line text.
## Must be empty; the verification asserts exactly that.
func forbidden_subjects_present() -> PackedStringArray:
	var found: PackedStringArray = PackedStringArray()
	var all_text: String = ""
	for entry: Dictionary in lines:
		all_text += " " + String(entry.get("line", ""))
	var lowered: String = all_text.to_lower()
	for subject: String in FORBIDDEN_SUBJECTS:
		if lowered.contains(subject):
			found.append(subject)
	return found


## Returns "" when the conversation is coherent.
func problem() -> String:
	if lines.is_empty():
		return "the conversation has no lines"
	var present: Array[StringName] = facts_present()
	for owed: StringName in OWED_FACTS:
		if not (owed in present):
			return "the first conversation does not establish %s" % owed
	var forbidden: PackedStringArray = forbidden_subjects_present()
	if not forbidden.is_empty():
		return "the first conversation raises %s" % ", ".join(forbidden)
	return ""


func describe() -> String:
	return "%d line(s), %d fact(s); opened %d time(s), skipped %d" % [
		lines.size(), OWED_FACTS.size(), times_opened, times_skipped,
	]
