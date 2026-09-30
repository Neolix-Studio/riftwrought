class_name ExteriorCohesionCatalogue
extends RefCounted
## First-MVP Gate 1B — the authoritative record of the D-202 Exterior Cohesion
## Comparison manifest (specification §4).
##
## This file is the ONE place that says which candidate came from which archive
## and which exact in-archive path. The comparison BUILDS from it, the overlay
## names what it built, and
## `game/tests/gate_1b_exterior_cohesion_verification.gd` checks the extraction
## against it — so a file that appeared beside the manifest without
## authorization, a missing payload, or a renamed source path fails rather than
## passing quietly.
##
## IT IS A SEPARATE MANIFEST FROM THE FIRST SPIKE'S. `ExteriorAssetCatalogue`
## records D-198's 35-file KayKit Forest / Halloween / k0rveen extraction and is
## left untouched; this records D-202's 21 models and four verbatim licences from
## four different CC0 archives, plus the two colour atlases D-204 restored. The
## two manifests are checked separately and by different suites, which is why a
## new record exists rather than a widened old one.
##
## NOTHING HERE IS A VISUAL JUDGEMENT. The `role` field records what each piece
## was extracted TO TEST, not what the project has decided to use. Specification
## §10 reserves the classification for the project owner and §11 keeps Gate 1B
## OPEN after automated success.

const FAMILY_NATURE: String = "Kenney Nature Kit 2.1"
const FAMILY_RUINS: String = "Quaternius Ultimate Modular Ruins Pack, August 2021"
const FAMILY_TOWN: String = "Kenney Fantasy Town Kit 2.0"
const FAMILY_GRAVEYARD: String = "Kenney Graveyard Kit 5.0"

## Already extracted under D-198 (Gate 1B spike) or D-171 (Gate A). These are the
## §5.1 permanent stylistic anchors and are NOT part of the D-202 extraction.
const FAMILY_KAYKIT_DUNGEON: String = "KayKit Dungeon Asset Pack 1.1 FREE"
const FAMILY_KAYKIT_FOREST: String = "KayKit Forest Nature Pack 1.0 FREE"
const FAMILY_KAYKIT_HALLOWEEN: String = "KayKit Halloween Bits 1.0 FREE"

const ARCHIVE_NATURE: String = "assets/kenney_nature-kit.zip"
const ARCHIVE_RUINS: String = (
	"assets/Ultimate Modular Ruins Pack - Aug 2021-20260901T195405Z-1-001.zip"
)
const ARCHIVE_TOWN: String = "assets/kenney_fantasy-town-kit_2.0.zip"
const ARCHIVE_GRAVEYARD: String = "assets/kenney_graveyard-kit_5.0.zip"

## The archive SHA-256 values recorded in `assets/ASSET_REGISTER.md`. Carried here
## so the source maps and the verification quote one record rather than two.
const ARCHIVE_SHA: Dictionary = {
	ARCHIVE_NATURE: "fa7974a0d342bfe63c38664ba9f8ec1a4aab8ea25f099bdc56870e33588c4d9d",
	ARCHIVE_RUINS: "91299d428c9af7a402e3fc20f9e7781190aa2ff7ffbc7bd3e44cbb60b372acf6",
	ARCHIVE_TOWN: "1a7530c09f4d2fa2cdee259876f089334f8b1f27fa86a0c4f54ef86cdd8676ef",
	ARCHIVE_GRAVEYARD: "1a93613f2e5675f3310acf49ec9ef13ae7adeb756ac3b205bfb6cc9311a81062",
}

const SOURCE_PAGE: Dictionary = {
	FAMILY_NATURE: "https://kenney.nl/assets/nature-kit",
	FAMILY_RUINS: "https://quaternius.com/packs/ultimatemodularruins.html",
	FAMILY_TOWN: "https://kenney.nl/assets/fantasy-town-kit",
	FAMILY_GRAVEYARD: "https://kenney.nl/assets/graveyard-kit",
}

const CREATOR: Dictionary = {
	FAMILY_NATURE: "Kenney / www.kenney.nl",
	FAMILY_RUINS: "Quaternius",
	FAMILY_TOWN: "Kenney / www.kenney.nl",
	FAMILY_GRAVEYARD: "Kenney / www.kenney.nl",
}

const DIR_NATURE: String = "res://assets/third_party/kenney/nature"
const DIR_TOWN: String = "res://assets/third_party/kenney/fantasy_town"
const DIR_GRAVEYARD: String = "res://assets/third_party/kenney/graveyard"
const DIR_RUINS: String = "res://assets/third_party/quaternius/modular_ruins"
const DIR_KENNEY_LICENCES: String = "res://assets/third_party/kenney/licenses"
const DIR_RUINS_LICENCES: String = "res://assets/third_party/quaternius/licenses"

const SOURCE_MAP_KENNEY: String = "res://assets/third_party/kenney/SOURCE_AND_LICENSE.md"
const SOURCE_MAP_QUATERNIUS: String = "res://assets/third_party/quaternius/SOURCE_AND_LICENSE.md"

## All four archives carry their own CC0 1.0 licence, so none of them obliges
## attribution the way the k0rveen CC BY 4.0 pack the first spike extracted does.
## The project credits the creators anyway, which is the register's stated
## preference rather than a legal requirement.
const LICENCE_CC0: String = "CC0 1.0"

const CREDIT_KENNEY: String = "Environment kits by Kenney (www.kenney.nl), CC0 1.0."
const CREDIT_QUATERNIUS: String = "Ultimate Modular Ruins Pack by Quaternius, CC0 1.0."

## Verbatim licence copies that must travel with the extraction (§4.5). Each maps
## a game-side copy to the exact in-archive file it must reproduce byte for byte.
## Three of the four source files are named `License.txt`, which is why §4.5 asks
## for collision-free game-side filenames.
const LICENCE_COPIES: Array[Dictionary] = [
	{
		"path": "res://assets/third_party/kenney/licenses/Kenney_Nature_Kit_2.1_License.txt",
		"source": "License.txt",
		"archive": ARCHIVE_NATURE,
		"family": FAMILY_NATURE,
		"licence": LICENCE_CC0,
	},
	{
		"path": "res://assets/third_party/kenney/licenses/Kenney_Fantasy_Town_Kit_2.0_License.txt",
		"source": "License.txt",
		"archive": ARCHIVE_TOWN,
		"family": FAMILY_TOWN,
		"licence": LICENCE_CC0,
	},
	{
		"path": "res://assets/third_party/kenney/licenses/Kenney_Graveyard_Kit_5.0_License.txt",
		"source": "License.txt",
		"archive": ARCHIVE_GRAVEYARD,
		"family": FAMILY_GRAVEYARD,
		"licence": LICENCE_CC0,
	},
	{
		"path": (
			"res://assets/third_party/quaternius/licenses/"
			+ "Quaternius_Ultimate_Modular_Ruins_Pack_Aug_2021_License.txt"
		),
		"source": "Ultimate Modular Ruins Pack - Aug 2021/License.txt",
		"archive": ARCHIVE_RUINS,
		"family": FAMILY_RUINS,
		"licence": LICENCE_CC0,
	},
]

## MEASURED, AND THE SHARPEST TRACEABILITY FINDING OF THIS WORK — NOW RESOLVED
## UNDER D-204. Specification §4 says "Prefer the self-contained GLB files in the
## Kenney archives", and for the 2020 Nature Kit that is true — its GLBs embed
## everything and carry no image at all. It is NOT true of the two 2025 kits:
## every Fantasy Town and Graveyard GLB declares an EXTERNAL image URI,
## `Textures/colormap.png`, which sits beside the models inside the archive.
##
## D-202 did not authorize either atlas, so at D-203 delivery all nine of those
## models imported with NO albedo texture and their colour could not be judged.
## D-203 reported that rather than widening its own manifest, and named the exact
## two files. **D-204 authorizes exactly those two dependencies and nothing else**,
## moving the inventory 89 -> 91 by the arithmetic 62 + 21 + 4 + 2 + 2 = 91.
##
## They are still DECLARED external URIs — `declares_external_atlas` stays true,
## because that is a fact about the glTF and not about the manifest — but they now
## RESOLVE. Each record carries the game-side destination as well as the archive
## source, so the same byte-identity proof that covers the models and the licences
## covers these too, and `_check_import_state` proves the resolution at the point
## of use rather than trusting that a file exists somewhere.
const DECLARED_EXTERNAL_URI: String = "Textures/colormap.png"
const ATLAS_DEPENDENCIES: Array[Dictionary] = [
	{
		"family": FAMILY_TOWN,
		"archive": ARCHIVE_TOWN,
		"in_archive": "Models/GLB format/Textures/colormap.png",
		"path": "res://assets/third_party/kenney/fantasy_town/Textures/colormap.png",
		"bytes": 11143,
		"sha256": "4aac939dc33195e35caf8c382ee3cb170054da763577f22d3c22692ec6afccdf",
	},
	{
		"family": FAMILY_GRAVEYARD,
		"archive": ARCHIVE_GRAVEYARD,
		"in_archive": "Models/GLB format/Textures/colormap.png",
		"path": "res://assets/third_party/kenney/graveyard/Textures/colormap.png",
		"bytes": 10965,
		"sha256": "a94b4dc4f77a4b8aec96bde94f63912a1ce12aa98eec2c1e9a37c89e20a5f091",
	},
]


## The atlas the models of `family` must resolve, or "" for a family that carries
## no texture by design. Used to prove that each kit resolves ITS OWN atlas rather
## than merely resolving something.
static func atlas_for_family(family: String) -> String:
	for entry: Dictionary in ATLAS_DEPENDENCIES:
		if String(entry["family"]) == family:
			return String(entry["path"])
	return ""


## Every file specification §4 authorizes this comparison to extract, in manifest
## order: 21 models across four families.
static func manifest() -> Array[Dictionary]:
	var records: Array[Dictionary] = []
	records.append_array(_nature())
	records.append_array(_ruins())
	records.append_array(_town())
	records.append_array(_graveyard())
	return records


## §4.1 — route edge, raised boundary, ground/path comparison, one rock-scale
## reference. No tree, crop, flower, water, bridge, tent, or decorative prop.
static func _nature() -> Array[Dictionary]:
	var pieces: Array[Array] = [
		["cliff_stone", "plain cliff face panel, raised boundary"],
		["cliff_corner_stone", "cliff corner post, raised boundary"],
		["cliff_top_stone", "cliff face panel with top lip, raised boundary"],
		["ground_pathStraight", "ground path module, surface comparison"],
		["ground_pathBend", "ground path bend, surface comparison"],
		["rock_largeC", "rock-scale reference"],
	]
	return _records(pieces, FAMILY_NATURE, ARCHIVE_NATURE, DIR_NATURE, "glb",
		"Models/GLTF format/%s.glb", false)


## §4.2 — broken wall, threshold, column, stair, and masonry fragments for the
## Broken Watch architectural language. No character, tree, bush, treasure, trap,
## statue, skull, furniture, or complete floor kit.
static func _ruins() -> Array[Dictionary]:
	var pieces: Array[Array] = [
		["Wall_Broken", "broken wall module, approach"],
		["Wall_ArchRound_Broken", "broken arched wall, threshold mass"],
		["Arch_Gothic", "gothic arch, threshold silhouette"],
		["Column_Round_Short", "short round column, approach"],
		["Stairs", "stair mass, approach"],
		["Bricks", "loose masonry fragments"],
	]
	return _records(pieces, FAMILY_RUINS, ARCHIVE_RUINS, DIR_RUINS, "fbx",
		"Ultimate Modular Ruins Pack - Aug 2021/FBX/%s.fbx", false)


## §4.3 — the deliberately simpler alternative structural language. No roof,
## building, stall, fountain, hedge, banner, windmill, watermill, cart, road, or
## living tree.
static func _town() -> Array[Dictionary]:
	var pieces: Array[Array] = [
		["wall-broken", "broken wall panel, approach and silhouette"],
		["wall-arch", "arch detail, threshold"],
		["wall-half", "half-height wall panel, approach"],
		["wall-corner", "wall corner block, threshold mass"],
		["pillar-stone", "stone pillar, approach and threshold"],
		["stairs-stone", "stone stair, approach"],
	]
	return _records(pieces, FAMILY_TOWN, ARCHIVE_TOWN, DIR_TOWN, "glb",
		"Models/GLB format/%s.glb", true)


## §4.4 — one optional restrained damage/dressing layer. No grave, gravestone,
## coffin, crypt, pumpkin, character, skull, cross, urn, altar, candle, or
## complete fence family.
static func _graveyard() -> Array[Dictionary]:
	var pieces: Array[Array] = [
		["stone-wall-damaged", "damaged low stone wall, dressing"],
		["stone-wall-column", "low stone wall column, dressing"],
		["debris", "ground debris, dressing"],
	]
	return _records(pieces, FAMILY_GRAVEYARD, ARCHIVE_GRAVEYARD, DIR_GRAVEYARD, "glb",
		"Models/GLB format/%s.glb", true)


static func _records(
	pieces: Array[Array], family: String, archive: String, directory: String,
	extension: String, in_archive_pattern: String, declares_external_atlas: bool
) -> Array[Dictionary]:
	var records: Array[Dictionary] = []
	for piece: Array in pieces:
		var stem: String = piece[0]
		records.append({
			"key": stem,
			"display": stem,
			"family": family,
			"archive": archive,
			"in_archive": in_archive_pattern % stem,
			"path": "%s/%s.%s" % [directory, stem, extension],
			# Every authorized model is a single self-contained file: the Kenney
			# GLBs embed their buffers and the Quaternius FBX files are complete.
			# The nine Kenney 2025 models additionally DECLARE an external image,
			# recorded as its own `ATLAS_DEPENDENCIES` entry rather than as a
			# payload of the model — ONE atlas serves a whole family, so counting
			# it per model would count the same file six and three times over.
			"payload": PackedStringArray(),
			"role": piece[1],
			"declares_external_atlas": declares_external_atlas,
		})
	return records


## The already-extracted KayKit pieces the composition keeps visible in EVERY
## mode as the §5.1 permanent stylistic anchor. They are NOT part of the D-202
## extraction and are listed separately so no check can mistake them for it.
static func kaykit_reference() -> Array[Dictionary]:
	var pieces: Array[Array] = [
		["wall", FAMILY_KAYKIT_DUNGEON, "res://assets/third_party/kaykit/dungeon/wall.gltf"],
		["wall_pillar", FAMILY_KAYKIT_DUNGEON,
			"res://assets/third_party/kaykit/dungeon/wall_pillar.gltf"],
		["floor_tile_large", FAMILY_KAYKIT_DUNGEON,
			"res://assets/third_party/kaykit/dungeon/floor_tile_large.gltf"],
		["Tree_Bare_1_C_Color1", FAMILY_KAYKIT_FOREST,
			"res://assets/third_party/kaykit/forest/Tree_Bare_1_C_Color1.gltf"],
		["Tree_Bare_2_C_Color1", FAMILY_KAYKIT_FOREST,
			"res://assets/third_party/kaykit/forest/Tree_Bare_2_C_Color1.gltf"],
		["Rock_1_A_Color1", FAMILY_KAYKIT_FOREST,
			"res://assets/third_party/kaykit/forest/Rock_1_A_Color1.gltf"],
		["Rock_1_Q_Color1", FAMILY_KAYKIT_FOREST,
			"res://assets/third_party/kaykit/forest/Rock_1_Q_Color1.gltf"],
		["Rock_3_A_Color1", FAMILY_KAYKIT_FOREST,
			"res://assets/third_party/kaykit/forest/Rock_3_A_Color1.gltf"],
		["floor_dirt", FAMILY_KAYKIT_HALLOWEEN,
			"res://assets/third_party/kaykit/halloween/floor_dirt.gltf"],
		["path_A", FAMILY_KAYKIT_HALLOWEEN,
			"res://assets/third_party/kaykit/halloween/path_A.gltf"],
		["path_C", FAMILY_KAYKIT_HALLOWEEN,
			"res://assets/third_party/kaykit/halloween/path_C.gltf"],
		["arch", FAMILY_KAYKIT_HALLOWEEN,
			"res://assets/third_party/kaykit/halloween/arch.gltf"],
		["fence_broken", FAMILY_KAYKIT_HALLOWEEN,
			"res://assets/third_party/kaykit/halloween/fence_broken.gltf"],
		["fence_pillar_broken", FAMILY_KAYKIT_HALLOWEEN,
			"res://assets/third_party/kaykit/halloween/fence_pillar_broken.gltf"],
		["tree_dead_large", FAMILY_KAYKIT_HALLOWEEN,
			"res://assets/third_party/kaykit/halloween/tree_dead_large.gltf"],
		["lantern_standing", FAMILY_KAYKIT_HALLOWEEN,
			"res://assets/third_party/kaykit/halloween/lantern_standing.gltf"],
	]
	var records: Array[Dictionary] = []
	for piece: Array in pieces:
		records.append({
			"key": "ref_%s" % piece[0],
			"display": piece[0],
			"family": piece[1],
			"archive": "already extracted under D-171 (Gate A) or D-198 (Gate 1B spike)",
			"in_archive": "",
			"path": piece[2],
			"payload": PackedStringArray(),
			"role": "permanent §5.1 stylistic anchor",
			"declares_external_atlas": false,
		})
	return records


static func candidate_families() -> PackedStringArray:
	return PackedStringArray([FAMILY_NATURE, FAMILY_RUINS, FAMILY_TOWN, FAMILY_GRAVEYARD])


static func record_for(key: String) -> Dictionary:
	for record: Dictionary in manifest():
		if String(record["key"]) == key:
			return record
	for record: Dictionary in kaykit_reference():
		if String(record["key"]) == key:
			return record
	return {}


## Every game-side path this manifest owns: the 21 models, the four verbatim
## licence copies, and the two D-204 colour atlases. The verification uses it to
## prove the extracted set is exactly this set — no missing model, and no file
## that was not authorized.
##
## The two atlases sit in a `Textures/` SUBDIRECTORY, which is why the scan that
## consults this list walks the candidate directories recursively. A scan that
## stopped at the top level would not have seen these two files at all, and would
## therefore not have seen an unauthorized file put beside them either.
static func expected_files() -> PackedStringArray:
	var paths: PackedStringArray = PackedStringArray()
	for record: Dictionary in manifest():
		paths.append(String(record["path"]))
	for copy: Dictionary in LICENCE_COPIES:
		paths.append(String(copy["path"]))
	for atlas: Dictionary in ATLAS_DEPENDENCIES:
		paths.append(String(atlas["path"]))
	return paths


## §4.5's arithmetic as D-204 restates it, derived rather than typed:
## 21 + 4 + 2 + 2 = 29 new files, and 62 + 29 = 91. The 62 is the inventory the
## first Gate 1B spike left behind under the filter every earlier suite uses
## (payload files, excluding Godot's `.import` sidecars, `.DS_Store`, and `.md`
## notes); the two project-authored source maps are counted with it because §4.5
## counts them in its own addition; and the two colour atlases are the D-204
## correction, counted as payloads exactly like the models and licences are.
static func inventory_arithmetic() -> Dictionary:
	return {
		"existing": 62,
		"models": manifest().size(),
		"licences": LICENCE_COPIES.size(),
		"atlases": ATLAS_DEPENDENCIES.size(),
		"source_maps": 2,
		"added": manifest().size() + LICENCE_COPIES.size() + ATLAS_DEPENDENCIES.size() + 2,
		"total": (
			62 + manifest().size() + LICENCE_COPIES.size()
			+ ATLAS_DEPENDENCIES.size() + 2
		),
	}
