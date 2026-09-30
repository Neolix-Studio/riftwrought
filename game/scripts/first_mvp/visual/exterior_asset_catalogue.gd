class_name ExteriorAssetCatalogue
extends RefCounted
## First-MVP Gate 1B — the authoritative record of the exterior candidate
## manifest (specification §4).
##
## This file is the ONE place that says which candidate came from which archive
## and which in-archive path. The spike BUILDS from it, the overlay names what it
## built, and `game/tests/gate_1b_exterior_asset_spike_verification.gd` checks the
## extraction against it — so a file that appeared beside the manifest without
## authorization, a missing `.bin` payload, or a renamed source path fails rather
## than passing quietly.
##
## Nothing here is a visual judgement. The `role` field records what each piece
## was extracted TO TEST, not what the project has decided to use. Only the
## project owner classifies these families (§9), and this spike leaves that open.
##
## `Mounting_1` is the creator's own filename and is preserved verbatim in
## `in_archive` and `path`. `display` carries the clearer game-side alias beside
## it, exactly as specification §4.3 requires: a clearer alias "may wrap it
## without obscuring the original path".

const FAMILY_FOREST: String = "KayKit Forest Nature Pack 1.0 FREE"
const FAMILY_HALLOWEEN: String = "KayKit Halloween Bits 1.0 FREE"
const FAMILY_K0RVEEN: String = "k0rveen LowPoly Environment Pack"
## Already registered and imported at Prototype Zero Gate A. It is the
## transition reference (§5.2) and is NOT part of the Gate 1B extraction.
const FAMILY_DUNGEON: String = "KayKit Dungeon Asset Pack 1.1 FREE"

const ARCHIVE_FOREST: String = "assets/KayKit_Forest_Nature_Pack_1.0_FREE.zip"
const ARCHIVE_HALLOWEEN: String = "assets/KayKit_HalloweenBits_1.0_FREE.zip"
const ARCHIVE_K0RVEEN: String = "assets/LowPoly Environment Pack.rar"

const DIR_FOREST: String = "res://assets/third_party/kaykit/forest"
const DIR_HALLOWEEN: String = "res://assets/third_party/kaykit/halloween"
const DIR_K0RVEEN: String = "res://assets/third_party/k0rveen/lowpoly_environment"

const TEXTURE_FOREST: String = "res://assets/third_party/kaykit/forest/forest_texture.png"
const TEXTURE_HALLOWEEN: String = "res://assets/third_party/kaykit/halloween/halloweenbits_texture.png"

## Verbatim licence and provenance copies that must travel with the extraction
## (§4.4). Each maps a game-side copy to the source it must reproduce exactly.
const LICENCE_COPIES: Array[Dictionary] = [
	{
		"path": "res://assets/third_party/kaykit/licenses/KayKit_Forest_Nature_Pack_1.0_FREE_License.txt",
		"source": "KayKit_Forest_Nature_Pack_1.0_FREE/License.txt",
		"archive": ARCHIVE_FOREST,
		"licence": "CC0 1.0",
	},
	{
		"path": "res://assets/third_party/kaykit/licenses/KayKit_HalloweenBits_1.0_FREE_License.txt",
		"source": "KayKit_HalloweenBits_1.0_FREE/License.txt",
		"archive": ARCHIVE_HALLOWEEN,
		"licence": "CC0 1.0",
	},
	{
		"path": "res://assets/third_party/k0rveen/licenses/K0RVEEN_LOW_POLY_ENVIRONMENT_PACK_CC_BY_4.0_SOURCE.md",
		"source": "assets/licenses/K0RVEEN_LOW_POLY_ENVIRONMENT_PACK_CC_BY_4.0_SOURCE.md",
		"archive": ARCHIVE_K0RVEEN,
		"licence": "CC BY 4.0",
	},
]

## The exact credit CC BY 4.0 obliges Riftwrought to carry for any k0rveen mesh.
## It is asserted, verbatim, in the game-side source note and on screen.
const K0RVEEN_CREDIT: String = (
	"LowPoly Environment Pack by k0rveen, licensed under CC BY 4.0."
)


## Every file specification §4 authorizes this spike to extract, in manifest
## order. `payload` lists the files that must exist BESIDE the model for it to
## import — the glTF `.bin` and the shared texture atlas.
static func manifest() -> Array[Dictionary]:
	var records: Array[Dictionary] = []
	records.append_array(_forest())
	records.append_array(_halloween())
	records.append_array(_k0rveen())
	return records


static func _forest() -> Array[Dictionary]:
	var pieces: Array[Array] = [
		["Tree_Bare_1_C_Color1", "bare tree, broad silhouette"],
		["Tree_Bare_2_C_Color1", "bare tree, tall narrow silhouette"],
		["Rock_1_A_Color1", "small ground rock"],
		["Rock_1_Q_Color1", "large boulder"],
		["Rock_3_A_Color1", "medium ground rock"],
	]
	var records: Array[Dictionary] = []
	for piece: Array in pieces:
		var stem: String = piece[0]
		records.append({
			"key": stem,
			"display": stem,
			"family": FAMILY_FOREST,
			"archive": ARCHIVE_FOREST,
			"in_archive": "KayKit_Forest_Nature_Pack_1.0_FREE/Assets/gltf/%s.gltf" % stem,
			"path": "%s/%s.gltf" % [DIR_FOREST, stem],
			"payload": PackedStringArray([
				"%s/%s.bin" % [DIR_FOREST, stem], TEXTURE_FOREST,
			]),
			"role": piece[1],
			"textured": true,
		})
	return records


static func _halloween() -> Array[Dictionary]:
	var pieces: Array[Array] = [
		["floor_dirt", "dirt ground module, surface comparison"],
		["path_A", "stone path tile, surface comparison"],
		["path_C", "stone path tile, surface comparison"],
		["arch", "ruined stone gateway"],
		["fence_broken", "broken iron fence run"],
		["fence_pillar_broken", "broken fence pillar"],
		["tree_dead_large", "dead tree silhouette"],
		["lantern_standing", "standing lantern, warm light anchor"],
	]
	var records: Array[Dictionary] = []
	for piece: Array in pieces:
		var stem: String = piece[0]
		records.append({
			"key": stem,
			"display": stem,
			"family": FAMILY_HALLOWEEN,
			"archive": ARCHIVE_HALLOWEEN,
			"in_archive": "KayKit_HalloweenBits_1.0_FREE/Assets/gltf/%s.gltf" % stem,
			"path": "%s/%s.gltf" % [DIR_HALLOWEEN, stem],
			"payload": PackedStringArray([
				"%s/%s.bin" % [DIR_HALLOWEEN, stem], TEXTURE_HALLOWEEN,
			]),
			"role": piece[1],
			"textured": true,
		})
	return records


## The generic archive supplies FBX only — no licence, readme, texture, source
## URL, or creator identity — which is exactly why §4.3 makes the durable
## provenance record mandatory. These five carry no texture at all; their
## materials are flat colours and are meant to be replaced.
static func _k0rveen() -> Array[Dictionary]:
	var pieces: Array[Array] = [
		["Terrain_1", "Terrain 1", "terrain slab candidate, background"],
		["Terrain_2", "Terrain 2", "terrain slab candidate, background"],
		["Mounting_1", "Mountain 1 (source filename Mounting_1)", "distant mountain silhouette"],
		["Rock_1", "Rock 1", "wide flat rock"],
		["Tree_1", "Tree 1", "full-canopy tree"],
	]
	var records: Array[Dictionary] = []
	for piece: Array in pieces:
		var stem: String = piece[0]
		records.append({
			"key": "k0rveen_%s" % stem,
			"display": piece[1],
			"family": FAMILY_K0RVEEN,
			"archive": ARCHIVE_K0RVEEN,
			"in_archive": "%s.fbx" % stem,
			"path": "%s/%s.fbx" % [DIR_K0RVEEN, stem],
			"payload": PackedStringArray(),
			"role": piece[2],
			"textured": false,
		})
	return records


## The already-registered Gate A dungeon pieces used as the §5.2 transition
## reference. They are NOT extracted by Gate 1B and are listed separately so no
## check can mistake them for part of this manifest.
static func dungeon_reference() -> Array[Dictionary]:
	var pieces: Array[Array] = [
		["wall", "dungeon wall, transition reference"],
		["wall_pillar", "dungeon wall pillar, transition reference"],
		["floor_tile_large", "dungeon floor module, transition reference"],
	]
	var records: Array[Dictionary] = []
	for piece: Array in pieces:
		records.append({
			"key": "dungeon_%s" % piece[0],
			"display": piece[0],
			"family": FAMILY_DUNGEON,
			"archive": "assets/KayKit_Dungeon_Pack_1.1_FREE.zip",
			"in_archive": "KayKit_Dungeon_Pack_1.1_FREE/Assets/gltf/%s.gltf" % piece[0],
			"path": "res://assets/third_party/kaykit/dungeon/%s.gltf" % piece[0],
			"payload": PackedStringArray(),
			"role": piece[1],
			"textured": true,
		})
	return records


static func families() -> PackedStringArray:
	return PackedStringArray([FAMILY_FOREST, FAMILY_HALLOWEEN, FAMILY_K0RVEEN])


static func record_for(key: String) -> Dictionary:
	for record: Dictionary in manifest():
		if String(record["key"]) == key:
			return record
	for record: Dictionary in dungeon_reference():
		if String(record["key"]) == key:
			return record
	return {}


## Every game-side path the manifest owns, models and payloads together. The
## verification uses it to prove that the extracted set is exactly this set — no
## missing payload, and no file that was not authorized.
static func expected_files() -> PackedStringArray:
	var paths: PackedStringArray = PackedStringArray()
	for record: Dictionary in manifest():
		if not paths.has(String(record["path"])):
			paths.append(String(record["path"]))
		for payload: String in (record["payload"] as PackedStringArray):
			if not paths.has(payload):
				paths.append(payload)
	for copy: Dictionary in LICENCE_COPIES:
		paths.append(String(copy["path"]))
	return paths
