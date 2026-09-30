class_name AssetManifest
extends RefCounted

## THE SPIKE'S THIRD-PARTY MANIFEST — THE SINGLE RUNTIME SOURCE OF TRUTH (D-388).
##
## ============================================================================
## NOT A COPY OF game3d/'s AssetManifest. IT SHARES THE NAME FOR ONE REASON.
## ============================================================================
## The verbatim accepted `player_controller.gd` loads `AssetManifest.OUTFIT_RANGER`
## by name. In this spike that constant TRUTHFULLY points at the spike's own,
## byte-identical copy of the same `Female_Ranger.gltf` -- the current 65-joint
## Huntress. Everything else here is this spike's own intake.
##
## THE INTAKE IS EXACTLY 19 FILES -- 15 asset files and 4 licence files -- listed
## below with the SHA-256 each must have. The verification suite checks every
## one of them, checks the human-readable SOURCE_AND_LICENSE.md against this
## file, and checks that NO other third-party file exists.
##
## NO DIRECTORY HERE IS NAMED EXACTLY `quaternius` (or `kaykit`). All three
## accepted game3d/ runners pin, repository-wide, the set of directories named
## `quaternius` to four trees; a fifth would turn three accepted runners red.
##
## NO SOURCE FILE IS MODIFIED. Files are copied byte-for-byte and set read-only.

const ROOT := "res://assets/third_party/"

const DIR_OUTFITS := "quaternius_modular_character_outfits_fantasy/"
const DIR_KAYKIT_ANIM := "kaykit_character_animations/"
const DIR_KAYKIT_ADV := "kaykit_adventurers/"
const DIR_WEAPONS := "quaternius_medieval_weapons/"

# --- Paths. NOTHING ELSE IN THE SPIKE MAY HARD-CODE A THIRD-PARTY PATH. -------
## The current 65-joint Huntress -- the retarget TARGET. Named as the accepted
## controller names it.
const OUTFIT_RANGER := ROOT + DIR_OUTFITS + "Female_Ranger.gltf"
## Six of the seven authorized clips, and the 23-joint SOURCE skeleton.
const KAYKIT_COMBAT_RANGED := ROOT + DIR_KAYKIT_ANIM + "Rig_Medium_CombatRanged.glb"
## `Running_HoldingBow`.
const KAYKIT_MOVEMENT_ADVANCED := ROOT + DIR_KAYKIT_ANIM + "Rig_Medium_MovementAdvanced.glb"
## ⚠ THE DIAGNOSTIC NATIVE-RIG COMPARATOR. NOT the Huntress.
const KAYKIT_RANGER := ROOT + DIR_KAYKIT_ADV + "Ranger.glb"
const BOW_WOODEN := ROOT + DIR_WEAPONS + "Bow_Wooden.obj"
const ARROW := ROOT + DIR_WEAPONS + "Arrow.obj"

static func packs() -> Array:
	return [
		{
			"key": "modular_character_outfits_fantasy",
			"name": "Modular Character Outfits – Fantasy [Standard]",
			"creator": "Quaternius",
			"archive": "assets/Quaternius Assets/Modular Character Outfits - Fantasy[Standard].zip",
			"archive_sha256": "c3468b18871cc8c8f05ab14df7712baf22cb9f389cbd870babf130e595187f70",
			"licence": "CC0 1.0 Universal",
			"licence_file": "licenses/LICENSE_quaternius_modular_character_outfits_fantasy_CC0.txt",
			"licence_sha256": "2202cc2f608c4210790b112e5f121bc2e7f8dced7b5b1c7f4be6203461bdebbb",
			"copied_from": "game3d/assets/third_party/quaternius/ (byte-identical to the archive)",
			"purpose": "The current 65-joint Huntress body and outfit -- the retarget TARGET. Not final art.",
			"files": [
				[DIR_OUTFITS + "Female_Ranger.gltf", "9b98b2ae6af3b4a1ec22bf8928b939e0751f08b25b636de82bfa7364fb34d3e1"],
				[DIR_OUTFITS + "Female_Ranger.bin", "d015964ba0a26eee9c9d2ea6f07aa660bba88aa536cf8bb6b67944b9e97c46df"],
				[DIR_OUTFITS + "T_Ranger_BaseColor.png", "846ef2170b04ee584ad83bb8a1e86dab57a9a43b1193204505912c274d949925"],
				[DIR_OUTFITS + "T_Ranger_Normal.png", "dd64da2af3180f0c8f0b721cfc5f0d2720c351b97da8285c6cf49e7717c84147"],
				[DIR_OUTFITS + "T_Ranger_ORM.png", "aca03d2fba12508ef07d5968ca22267fb207ea26ae898b6b2def8a296bd44f1c"],
				[DIR_OUTFITS + "T_Regular_Female_Dark_BaseColor.png", "3b6ab973f9f3d6f8961226a0dbd99cf6d1b72df3795a8a5c1620a55754c161c2"],
				[DIR_OUTFITS + "T_Regular_Female_Normal.png", "e1051d3d56df9cf061bc14c769c37253aecd595f8275f9d4c0d6e0e953c00e18"],
				[DIR_OUTFITS + "T_Regular_Female_Roughness.png", "da541fbd4b3bffe754fada5c29f8a0d8f836bf20ce7df8273607af4729a3a5ae"],
			],
		},
		{
			"key": "kaykit_character_animations",
			"name": "KayKit Character Animations 1.1",
			"creator": "Kay Lousberg (KayKit)",
			"archive": "assets/KayKit_Character_Animations_1.1.zip",
			"archive_sha256": "65882f31f905ad2e953819648a59287cdeab8f623908d5ef701971d3758be20f",
			"licence": "CC0 1.0",
			"licence_file": "licenses/LICENSE_kaykit_character_animations_CC0.txt",
			"licence_sha256": "373b159044d1a886ed15f57ca5a7673ba14e2623c460283452705f2056912ed9",
			"copied_from": "the archive",
			"purpose": "The seven authorized bow clips and the 23-joint SOURCE skeleton's rest data. "
				+ "26 other clips and an embedded 6-part mannequin are present and NOT used.",
			"files": [
				[DIR_KAYKIT_ANIM + "Rig_Medium_CombatRanged.glb", "7fef1fc0e7b0feafd34b8e12d23f514c8c1f9d068047a691b854b56f1774dff5"],
				[DIR_KAYKIT_ANIM + "Rig_Medium_MovementAdvanced.glb", "8b2317cf81e3f24149e4b791c27e1932bebd46cd378ed962e7d27d642fad8c56"],
			],
		},
		{
			"key": "kaykit_adventurers",
			"name": "KayKit Adventurers Character Pack 2.0 — Free",
			"creator": "Kay Lousberg (KayKit)",
			"archive": "assets/KayKit_Adventurers_2.0_FREE.zip",
			"archive_sha256": "abe48f4763fba0896bab486ee9e6d08ca6b5b3884b9601f235c8847ae94dc479",
			"licence": "CC0 1.0",
			"licence_file": "licenses/LICENSE_kaykit_adventurers_CC0.txt",
			"licence_sha256": "d4adc31660d1db22eb60eba648e01db41577548f6fa1a3576cb4a6283dae0a58",
			"copied_from": "the archive",
			"purpose": "A DIAGNOSTIC NATIVE-RIG COMPARATOR ONLY. NOT an alternative production Huntress. "
				+ "Its one texture is EMBEDDED; the loose copy in the archive is not needed and not copied.",
			"files": [
				[DIR_KAYKIT_ADV + "Ranger.glb", "3a0b0166b9d61d58dcaaa739c3cc0538be46e00d2928dd5cb513d9a41770d2e9"],
			],
		},
		{
			"key": "medieval_weapons",
			"name": "Medieval Weapons Pack",
			"creator": "Quaternius",
			"archive": "assets/Quaternius Assets/Medieval Weapons Pack by @Quaternius-20260917T104936Z-1-001.zip",
			"archive_sha256": "66db9bcb92a2f1cdf8a3b53b882b91e4fb6a6a982d54936ca09a05346f37b395",
			"licence": "CC0 1.0 Universal",
			"licence_file": "licenses/LICENSE_quaternius_medieval_weapons_CC0.txt",
			"licence_sha256": "d32abf5eb61a5d20c582525c2ee9d8d42d86401d6b3ea0a2d5283fcaecaa35b9",
			"copied_from": "the archive",
			"purpose": "The bow, the nocked arrow and the projectile body. The bow's rigid string "
				+ "surface is left out at runtime; the source is unchanged.",
			"files": [
				[DIR_WEAPONS + "Bow_Wooden.obj", "788c9e72bdd839a86704113de4809a96cfedf09441bb3f98f383a7abfe751e6d"],
				[DIR_WEAPONS + "Bow_Wooden.mtl", "545318d522d6ab3f0f4942cd5fc25001fcc9c1a722cef2d04555009721847a54"],
				[DIR_WEAPONS + "Arrow.obj", "6960c207e3a8e6f2f09cbfd31b7fe990119cd260ef692729c498738a86698bf1"],
				[DIR_WEAPONS + "Arrow.mtl", "cee901eef3fabe40154cc3a13ed3d64181aac886767fb1132382667332c6891f"],
			],
		},
	]

## Every declared asset file, [relative path, sha256].
static func asset_files() -> Array:
	var out: Array = []
	for p in packs():
		for f in p["files"]:
			out.append(f)
	return out

## Every declared licence file, [relative path, sha256].
static func licence_files() -> Array:
	var out: Array = []
	for p in packs():
		out.append([String(p["licence_file"]), String(p["licence_sha256"])])
	return out

static func intake_count() -> int:
	return asset_files().size() + licence_files().size()

static func provenance_document() -> String:
	return ROOT + "SOURCE_AND_LICENSE.md"

## GENERATED GODOT STATE -- produced by the import, never intake.
static func generated_suffixes() -> Array:
	return [".import", ".uid"]

## Textures Godot's glTF importer extracts from a GLB's embedded image.
static func generated_texture_prefixes() -> Array:
	return ["Ranger_ranger_texture"]

## Authored by this spike inside the third-party tree (not intake).
static func authored_files() -> Array:
	return ["SOURCE_AND_LICENSE.md"]

## Excluded by ruling. The suite scans for every one of these and refuses them.
static func forbidden_name_fragments() -> Array:
	return ["BattleFX", "DarkMagicFX", "ElementalMagicFX", "PortalVFX", "VividMotion",
		"shield-vfx", "tornado", "UltimateMonsters", "Ultimate Monsters", "Puglin", "Imp.glb",
		"UAL1", "UAL2", "Floor_Standard", "Mannequin"]
