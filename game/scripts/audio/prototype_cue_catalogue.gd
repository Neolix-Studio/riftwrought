class_name PrototypeCueCatalogue
extends RefCounted
## Prototype Zero — Gate F: the ONE named audio cue catalogue
## (specification §19, decision D-189).
##
## This is the single source of truth for every prototype cue. Two very
## different things read it and they must never disagree:
##
##   `scripts/tools/build_prototype_audio.gd`   SYNTHESISES the variants named
##                                              here, writes them to
##                                              `assets/prototype/audio/cues/`,
##                                              and writes the derivation note
##                                              beside them.
##   `scripts/app/prototype_audio_director.gd`  ROUTES a cue name to a bus, a
##                                              gain, a variation policy, and a
##                                              rate limit at play time.
##
## The Gate F suite asserts both directions: every variant declared here exists
## on disk, and every file on disk is declared here.
##
## NO SOUND WAS DOWNLOADED, PURCHASED, OR IMPORTED.
##
## D-189: "No unregistered download is authorized. Claude may create and document
## original project-authored procedural audio assets as genuine shaped, layered
## prototype cues — not undifferentiated diagnostic beeps." Every cue below is
## synthesised from first principles by the generator: filtered noise layers,
## inharmonic partial clusters, granular fracture grains, swept band-passes,
## reversed onsets, and shaped envelopes. There is no sample, no recording, and
## no third-party audio file anywhere in this project. The `recipe` field on each
## family is the human-readable derivation, and the generator writes the same
## text into `assets/prototype/audio/SOURCE_AND_DERIVATION.md` so the record
## cannot drift from the code that made the sound.
##
## THE PALETTE IS THE CANON'S, NOT A SYNTHESISER'S.
## `design/AUDIO_MUSIC_COMBAT_SOUND_IDENTITY.md` asks for tactile Wroughtstone
## material — stone, bone, iron, copper, wood, leather, dust, impact — and for
## the Rift's hollow resonance, reversed onset, granular fracture, suction, pitch
## strain, and controlled silence. Those are the layer names below. It also
## forbids constant cinematic booms, generic sparkle, science-fiction lasers, and
## arcade jingles, so no cue here uses a bell, a chime, a riser, a shimmer, or a
## pitched-up flourish.
##
## THE IMPROVED HIT IS NOT ELEMENTAL (specification §18, D-189).
## `impact_bone_improved` uses the SAME grammar as `impact_bone_ordinary` — the
## same transient, the same inharmonic bone body, the same granular fracture, the
## same dust tail. It differs only in MASS: one extra low weight layer, a body
## tuned a whole tone lower with a longer decay, one more fracture grain, a
## longer dust tail, and about 1.6 dB more level. There is no ring, no shimmer,
## no bell partial, no rising tail, and no added brightness, because every one of
## those would read as a new damage type rather than as a heavier sword.

## Sample rate for every generated cue. 44.1 kHz keeps the fracture grains and
## the 6 kHz dust band honest; anything lower audibly aliases the transients.
const MIX_RATE: int = 44100

## Where the generator writes, and where the director loads from.
const CUE_DIRECTORY: String = "res://assets/prototype/audio/cues"
const DERIVATION_NOTE: String = "res://assets/prototype/audio/SOURCE_AND_DERIVATION.md"

## Audio buses, from the Gate A `prototype_bus_layout.tres`. Gate F adds no bus.
const BUS_COMBAT: String = "Combat"
const BUS_UI: String = "UI"

## Every cue family Prototype Zero has.
##
##   bus             which existing bus it plays on
##   gain_db         its resting level relative to the normalised peak
##   variants        how many distinct authored takes exist
##   seconds         the authored length of one take
##   pitch_jitter    +/- fraction of playback rate applied per play, so an
##                   identical sample cannot machine-gun (specification §19)
##   gain_jitter_db  +/- level applied per play, for the same reason
##   min_interval    the shortest gap between two plays of this family; a
##                   request inside it is dropped rather than layered
##   recipe          the derivation, written to the source note by the generator
const FAMILIES: Dictionary = {
	# --- Locomotion ----------------------------------------------------------
	"footstep": {
		"bus": BUS_COMBAT, "gain_db": -17.0, "variants": 4, "seconds": 0.17,
		"pitch_jitter": 0.10, "gain_jitter_db": 2.0, "min_interval": 0.14,
		"recipe": "Boot on dressed stone. Layer 1: low thud — white noise low-passed to 170-230 Hz with a 22-30 ms exponential decay. Layer 2: dust and grit — the same noise high-passed above 2.1-3.4 kHz at -16 dB with a 55-75 ms decay. Layer 3: leather creak — a 780-1080 Hz band-pass at Q 4 at -22 dB. Variation is per-take filter and decay jitter, not a pitch-shifted copy of one take.",
	},

	# --- Quick Strike --------------------------------------------------------
	"quick_strike_commit": {
		"bus": BUS_COMBAT, "gain_db": -15.0, "variants": 2, "seconds": 0.19,
		"pitch_jitter": 0.05, "gain_jitter_db": 1.0, "min_interval": 0.06,
		"recipe": "The moment the swing is decided. Reversed onset: a decaying band-passed noise cluster centred at 300-420 Hz is synthesised and then REVERSED, so it swells into the commitment instead of decaying away from it. A single iron tick (2.3 kHz and 3.0 kHz partials, 18 ms) lands on the last frame as the wrist sets.",
	},
	"quick_strike_release": {
		"bus": BUS_COMBAT, "gain_db": -11.0, "variants": 3, "seconds": 0.26,
		"pitch_jitter": 0.07, "gain_jitter_db": 1.5, "min_interval": 0.05,
		"recipe": "Blade through air. A state-variable band-pass at Q 2.4 sweeps a white-noise bed from 1.65 kHz down to 430 Hz across the swing — the doppler of the tip passing the ear — under a 6 ms attack and a 190 ms decay. A thin metallic edge (inharmonic partials at 2.41 kHz and 3.13 kHz, 38 ms) sits at -19 dB so the swing reads as steel rather than as wind.",
	},

	# --- Sword on bone -------------------------------------------------------
	"impact_bone_ordinary": {
		"bus": BUS_COMBAT, "gain_db": -5.5, "variants": 3, "seconds": 0.30,
		"pitch_jitter": 0.05, "gain_jitter_db": 1.2, "min_interval": 0.03,
		"recipe": "100 Physical into a Graveblade. Four layers. (1) Transient: a 3 ms noise burst high-passed above 1.5 kHz. (2) Bone body: an INHARMONIC partial cluster at 318 / 511 / 779 Hz with a 90 ms decay and a 4% downward pitch droop — bone is dry and inharmonic, so no partial is a whole multiple of another. (3) Granular fracture: three short band-passed grains at 6, 13 and 22 ms, centred 2.6-3.0 kHz. (4) Dust and stone: a 90 Hz thump at 70 ms plus a low-passed dust tail out to 180 ms.",
	},
	"impact_bone_improved": {
		"bus": BUS_COMBAT, "gain_db": -3.9, "variants": 3, "seconds": 0.33,
		"pitch_jitter": 0.05, "gain_jitter_db": 1.2, "min_interval": 0.03,
		"recipe": "150 Physical, the SAME grammar with more mass. Identical transient, bone body, fracture and dust layers, then: the body tuned a whole tone lower (283 / 455 / 694 Hz) with a 30% longer decay, one EXTRA fracture grain, a 60 Hz weight layer at 140 ms that the ordinary Hit does not have, a dust tail 40% longer, and about 1.6 dB more level. Deliberately NOT elemental: no bell, ring, shimmer, rising tail, or added brightness, because §18 requires the improved Hit to read as a heavier sword rather than as a new damage type.",
	},

	# --- The Graveblade ------------------------------------------------------
	"graveblade_anticipation": {
		"bus": BUS_COMBAT, "gain_db": -12.0, "variants": 2, "seconds": 0.46,
		"pitch_jitter": 0.04, "gain_jitter_db": 1.0, "min_interval": 0.20,
		"recipe": "The telegraph the player has to read. Reversed onset again, but longer and hollower: a resonant 210-240 Hz band-pass at Q 8 over noise, synthesised decaying and then reversed so it swells for the whole anticipation. Under it a pitch-strain sine slides 68 Hz to 96 Hz. It stops ABRUPTLY on the last sample, which is the commitment — the silence after it is part of the cue.",
	},
	"graveblade_release": {
		"bus": BUS_COMBAT, "gain_db": -9.5, "variants": 2, "seconds": 0.29,
		"pitch_jitter": 0.05, "gain_jitter_db": 1.5, "min_interval": 0.05,
		"recipe": "The enemy's swing, deliberately heavier and lower than the player's so the two are never confused: the same swept band-pass, but from 940 Hz down to 260 Hz at Q 2.0, with a slower 10 ms attack. A bone-handle rattle — four granular grains centred 1.1-1.9 kHz — replaces the player's metallic edge.",
	},
	"graveblade_death": {
		"bus": BUS_COMBAT, "gain_db": -7.0, "variants": 2, "seconds": 0.85,
		"pitch_jitter": 0.04, "gain_jitter_db": 1.0, "min_interval": 0.05,
		"recipe": "Bone collapse. Eleven granular fracture grains spread over 520 ms with falling amplitude and band-pass centres scattered 1.2-3.5 kHz, so it clatters rather than clicks; a low 78 Hz stone settle at 260 ms; and a low-passed dust tail that outlives both. The last 180 ms is deliberately near silence.",
	},
	"player_damage": {
		"bus": BUS_COMBAT, "gain_db": -6.0, "variants": 3, "seconds": 0.34,
		"pitch_jitter": 0.05, "gain_jitter_db": 1.2, "min_interval": 0.05,
		"recipe": "125 Physical into the player. Blunt, close, and dull rather than sharp: a low-passed noise thud, a damped 138 Hz partial with a fast 9% downward pitch droop (the strain of taking it), a leather-and-mail rustle band-passed at 1.9 kHz at -18 dB, and no fracture grains at all — the player is not bone.",
	},

	# --- Reward and interaction ----------------------------------------------
	"sword_drop": {
		"bus": BUS_COMBAT, "gain_db": -9.0, "variants": 2, "seconds": 0.52,
		"pitch_jitter": 0.04, "gain_jitter_db": 1.0, "min_interval": 0.20,
		"recipe": "Iron landing on stone. A bright 2 ms transient, a metallic partial cluster at 1180 / 1790 / 2630 Hz with a 260 ms decay (metal IS closer to harmonic than bone, which is what tells them apart), a 96 Hz stone thump, and a small settling tick at 210 ms as the blade rocks flat.",
	},
	"reward_experience": {
		"bus": BUS_UI, "gain_db": -14.0, "variants": 1, "seconds": 0.36,
		"pitch_jitter": 0.0, "gain_jitter_db": 0.0, "min_interval": 0.10,
		"recipe": "Restrained copper, not a jingle. Two partials a fifth apart at 656 and 984 Hz with a soft 18 ms attack and a 190 ms decay, plus a faint struck-copper body at 328 Hz. No arpeggio, no rising sparkle, no gambling presentation.",
	},
	"comparison_open": {
		"bus": BUS_UI, "gain_db": -16.0, "variants": 1, "seconds": 0.23,
		"pitch_jitter": 0.0, "gain_jitter_db": 0.0, "min_interval": 0.08,
		"recipe": "A stone slab sliding open. Low-passed noise with a 40 ms swell and a 150 ms decay, plus a quiet 300 Hz body. It is a surface, not a chime.",
	},
	"equip": {
		"bus": BUS_UI, "gain_db": -11.0, "variants": 1, "seconds": 0.42,
		"pitch_jitter": 0.0, "gain_jitter_db": 0.0, "min_interval": 0.10,
		"recipe": "Leather and iron. A strap creak (a 700 Hz band-pass at Q 5 over noise with a slow 70 ms swell), a firm iron click at 90 ms (1.6 kHz and 2.4 kHz partials, 30 ms), and a low 110 Hz settle as the weight is taken.",
	},
	"passive_confirm": {
		"bus": BUS_UI, "gain_db": -11.0, "variants": 1, "seconds": 0.72,
		"pitch_jitter": 0.0, "gain_jitter_db": 0.0, "min_interval": 0.20,
		"recipe": "The one Rift-flavoured cue in Prototype Zero, and it is still restrained. A short SUCTION first — a band-pass sweeping 900 Hz down to 180 Hz over 140 ms — then a reversed-onset swell into a low copper triad at 196 / 294 / 392 Hz with a 320 ms decay. No riser, no whoosh-up, no impact.",
	},

	# --- Menu and state ------------------------------------------------------
	"menu_move": {
		"bus": BUS_UI, "gain_db": -24.0, "variants": 2, "seconds": 0.075,
		"pitch_jitter": 0.06, "gain_jitter_db": 1.0, "min_interval": 0.04,
		"recipe": "A very quiet stone tick for focus movement: a 4 ms noise transient band-passed at 1.3 kHz with a 45 ms decay. Deliberately near the threshold of notice.",
	},
	"menu_confirm": {
		"bus": BUS_UI, "gain_db": -17.0, "variants": 2, "seconds": 0.13,
		"pitch_jitter": 0.04, "gain_jitter_db": 1.0, "min_interval": 0.05,
		"recipe": "A small iron tick: partials at 1.42 kHz and 2.13 kHz with a 45 ms decay over a 3 ms transient. Restrained, as §19 asks — it confirms, it does not celebrate.",
	},
	"menu_open": {
		"bus": BUS_UI, "gain_db": -18.0, "variants": 1, "seconds": 0.20,
		"pitch_jitter": 0.0, "gain_jitter_db": 0.0, "min_interval": 0.06,
		"recipe": "The same stone-slab family as the comparison, shorter and quieter, so opening a menu and opening the comparison are recognisably the same surface.",
	},
	"menu_close": {
		"bus": BUS_UI, "gain_db": -19.0, "variants": 1, "seconds": 0.17,
		"pitch_jitter": 0.0, "gain_jitter_db": 0.0, "min_interval": 0.06,
		"recipe": "The stone slab closing: the open cue's envelope reversed, so the swell becomes a settle.",
	},
	"invalid_action": {
		"bus": BUS_UI, "gain_db": -17.0, "variants": 1, "seconds": 0.19,
		"pitch_jitter": 0.0, "gain_jitter_db": 0.0, "min_interval": 0.25,
		"recipe": "A dull dead thud, deliberately NOT an error buzzer: low-passed noise with a 120 ms decay and a heavily damped 152 Hz partial. Nothing tonal, nothing rising, nothing that sounds like a machine complaining.",
	},
	"fallen": {
		"bus": BUS_UI, "gain_db": -8.0, "variants": 1, "seconds": 1.60,
		"pitch_jitter": 0.0, "gain_jitter_db": 0.0, "min_interval": 1.00,
		"recipe": "The one long cue. Suction: a band-pass sweeps 820 Hz down to 90 Hz over 520 ms while its noise bed thins. Under it a hollow 55 Hz drone with a 900 ms decay and a single distant fracture grain at 340 ms. Then CONTROLLED SILENCE — the tail is fully down by 1.25 s and the remaining 350 ms is authored quiet, because the canon names silence as part of the Rift palette.",
	},
}


## Names other code already emits, mapped onto an authored family. Gate E built
## its cue POINTS before any audio existed and named them after the surface that
## fired them (`comparison_open`, `passive_open`); Gate F adds pause, settings,
## and confirmation surfaces. Rather than authoring a near-identical cue per
## surface — which is exactly the "one expensive asset per piece of content"
## production mistake the asset rules forbid — every menu surface shares the one
## stone-slab family, and this table is where that reuse is written down.
const ALIASES: Dictionary = {
	"passive_open": "menu_open",
	"pause_open": "menu_open",
	"settings_open": "menu_open",
	"confirm_open": "menu_open",
	"fallen_open": "fallen",
}


## The authored family a cue name resolves to. An unknown name comes back
## unchanged so the director can warn about it rather than silently play nothing.
static func resolve(cue_name: String) -> String:
	if FAMILIES.has(cue_name):
		return cue_name
	return String(ALIASES.get(cue_name, cue_name))


## Every cue family name, sorted, so listings are stable.
static func family_names() -> PackedStringArray:
	var names: PackedStringArray = PackedStringArray()
	for key: String in FAMILIES:
		names.append(key)
	names.sort()
	return names


## The resource path of one variant. Variants are one-based in their file name so
## a listing reads `impact_bone_ordinary_1.res` rather than `_0`.
static func variant_path(family: String, index: int) -> String:
	return "%s/%s_%d.res" % [CUE_DIRECTORY, family, index + 1]


static func variant_count(family: String) -> int:
	if not FAMILIES.has(family):
		return 0
	return int((FAMILIES[family] as Dictionary)["variants"])


## Every variant path in the catalogue, sorted.
static func all_variant_paths() -> PackedStringArray:
	var paths: PackedStringArray = PackedStringArray()
	for family: String in family_names():
		for index: int in variant_count(family):
			paths.append(variant_path(family, index))
	return paths


static func total_variants() -> int:
	var total: int = 0
	for family: String in FAMILIES:
		total += variant_count(family)
	return total


static func field(family: String, key: String, fallback: Variant) -> Variant:
	if not FAMILIES.has(family):
		return fallback
	var entry: Dictionary = FAMILIES[family] as Dictionary
	return entry.get(key, fallback)
