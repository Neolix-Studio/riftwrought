extends SceneTree
## First-MVP UI J3 — Gate 1D Pending-Fallen Cancellation on Restart V1: automated verification
## (decision D-326).
##
## THE ONE QUESTION: when Gate 1D restarts while a Fallen presentation is armed but not yet open —
## F5 inside the 0.90 s delay after a lethal Hit — is that pending presentation cancelled, so that the
## restart runs once, the character is revived once at 500 / 500, the encounter resets as accepted,
## and no Fallen overlay ever opens over the living character?
##
## THE SLICE IS THE ONLY PRODUCTION FILE J3 MOVES, and that is proved by reconstruction: the slice
## with J3's added comment and its two added lines removed is, byte for byte, the file as it stood
## before the first J3 edit.
##
## GATE 1D'S OWN `broken_watch_slice.tscn`, LOADED AS IT SHIPS AND GIVEN NO FLAG OF ITS OWN. Every
## death is dealt by the production Graveblade's own attack, and every Restart is taken through a
## production path: F5 into the slice's own input handling, or the Fallen overlay's own Enter, left
## click or F5.
##
## STAGED, AND STATED WHERE IT HAPPENS:
##   - both Graveblades are quieted, and the first is killed through `receive_damage()` so that the
##     guaranteed drop exists and its latch can be watched across every restart;
##   - before each death the player is placed at Riftfall Landing's start and the second Graveblade
##     1.2 m in front of it; each attack is begun through `begin_attack_for_verification()`, and
##     everything after that is the attack's own;
##   - after each restart has been read, the two Graveblades it re-enabled are quieted again;
##   - inside one death's delay the room's modal-contract `neutralize_for_modal()` is called directly
##     and one more DamageEvent is offered, to read J2's contract there.
##
## The two pending fields are READ from here, never written. Input is simulated — keys pushed into
## the root window, one left click through `Input.parse_input_event()` — which is not physical-device
## certification.
##
## IT PORTS D-211's OWED-SET DISCIPLINE.
##
## Run: godot --headless --path game --script res://tests/pending_fallen_restart_verification.gd

const THIS_FILE: String = "res://tests/pending_fallen_restart_verification.gd"
const SLICE_SCRIPT: String = "res://scripts/first_mvp/severed_threshold/broken_watch_slice.gd"
const SLICE_SCENE: String = "res://scenes/first_mvp/severed_threshold/broken_watch_slice.tscn"
const OPENING_SCRIPT: String = "res://scripts/first_mvp/canonical_opening/canonical_opening_runtime.gd"
const CORE_LOOP_SCRIPT: String = "res://scripts/roguelite/roguelite_core_loop_runtime.gd"
const PROTOTYPE_ROOM_SCRIPT: String = "res://scripts/prototype_zero/prototype_zero.gd"
const GRAVEBLADE_RECORD: String = "res://data/prototype_zero/graveblade.tres"
const STARTING_SWORD: String = "res://data/first_mvp/severed_threshold/broken_watch/starting_sword.tres"
const J1_VERIFICATION: String = "res://tests/first_mvp_modal_left_click_verification.gd"
const J2_VERIFICATION: String = "res://tests/fallen_modal_life_state_verification.gd"
const PROJECT_SETTINGS_FILE: String = "res://project.godot"
const ENTRYPOINT: String = "res://scenes/app/prototype_app.tscn"
const EXPECTED_ACTIONS: int = 31
const SCANNED_ROOTS: Array[String] = ["res://scripts", "res://scenes", "res://data", "res://addons"]

## The slice before the first J3 edit, whole, and J3's two changes to it, exactly as written.
const PRE_J3_SHA256: String = "e6bbb1747d95dd7b729e97c921daf0cd0978a6c9caeba64463fb1b5cc3d6e924"
const J3_PREFIX: String = "b35e04a6"
const J3_ADDED_COMMENT: String = "##\n## A restart also cancels a Fallen presentation that is armed but not yet open\n## (First-MVP UI J3, decision D-326). F5 inside the FALLEN_DELAY window used to\n## revive the player and leave the countdown and its killing event armed, so\n## the overlay then opened over a living, full-Life character. Both are cleared\n## here BEFORE the revival, so nothing of the old death is still waiting once\n## the character is alive. An overlay that is already open is not touched here;\n## it closes itself before it calls this.\n"
const J3_CANCELLATION: String = "\t_fallen_countdown = -1.0\n\t_pending_fallen_event = null\n"
const RESTART_SIGNATURE: String = "func restart_current_slice(reason: String) -> void:"

## `restart_current_slice()`'s code lines after J3: the accepted body, with the two cancellations
## between its log line and the revival. First-MVP Gameplay J10 (D-340) added one line, by the project
## owner's ruling: the movement-intent clearing, directly after the entry.
const RESTART_LINES: Array[String] = [
	"log_event(\"slice restarted\", reason)", "_fallen_countdown = -1.0", "_pending_fallen_event = null",
	"player.revive_for_testing()", "player.global_position = broken_watch.entry()",
	"player.clear_movement_intent(reason, false)", "player.face_instantly(route_forward())",
	"for enemy: PrototypeGraveblade in graveblades:", "enemy.set_ai_enabled(true)", "enemy.reset_encounter()",
	"attack_coordinator.reset()", "_soft_target = null", "marker.hide_destination()",
]
## The two functions that arm and fire the delay, code line for code line, as accepted.
const FELL_LINES: Array[String] = [
	"for enemy: PrototypeGraveblade in graveblades:", "enemy.set_ai_enabled(false)",
	"attack_coordinator.revoke_all(\"player fallen\")", "_pending_fallen_event = event", "_fallen_countdown = FALLEN_DELAY",
]
const TICK_LINES: Array[String] = [
	"if _fallen_countdown < 0.0:", "return", "_fallen_countdown -= delta", "if _fallen_countdown <= 0.0:",
	"_fallen_countdown = -1.0", "fallen_overlay.open_for(_pending_fallen_event)",
]

## The slice's declarations, counted before the first J3 edit.
const SLICE_FIELDS: int = 35
const SLICE_EXPORTS: int = 8
const SLICE_FUNCTIONS: int = 53
const SLICE_CONSTANTS: int = 12

## The two accepted verifications that pinned the slice at `e6bbb174`: each moved its one row, gained
## one comment above it and one clause in the print that names the moved files. Nothing else.
const J1_PRE_SHA256: String = "2606fd80646f93a0b11e62258a251e09294541d2e99984106ed5de4151e70ed9"
const J2_PRE_SHA256: String = "d78c5ae16e966bbca7df10740000c2e1519bd3512e926bd37221a2ba89a45356"
const J1_PREFIX: String = "2f5a32ca"
const J2_PREFIX: String = "b04b0a1e"
const SLICE_ROW_OLD: String = "\t[\"res://scripts/first_mvp/severed_threshold/broken_watch_slice.gd\", \"e6bbb174\"],\n"
const SLICE_ROW_COMMENT: String = "\t## First-MVP UI J3 (D-326) moved Gate 1D's slice one for one, from `e6bbb174`, so that a restart\n\t## cancels a Fallen that is armed but not yet open. Same count.\n"
const J1_CLAUSE: String = ", and Gate 1D's slice, which J3 moved (D-326)"
const J2_CLAUSE: String = ", but for Gate 1D's slice, which J3 moved (D-326)"

## First-MVP UI J4 (D-328) moved the slice, J1 and J2 again, one for one. Each is first put back to where
## J3 left it — the slice by removing J4's three comments and three guards, J1 and J2 by restoring the
## row and the clause J3 wrote — and is then read exactly as J3 read it. Each pair is [as J4 wrote it,
## as J3 left it].
const J4_SLICE_PREFIX: String = "c204a087"
const J4_J1_PREFIX: String = "c6fe40f1"
const J4_J2_PREFIX: String = "a3f97de5"
const J4_MOVES: Array = [
	["## The one funnel into the item comparison: the nameplate's click and the\n## controller's interact both arrive here. It refuses a character that is not\n## alive (First-MVP UI J4, decision D-328), asking `player.is_alive()` and\n## nothing else, so a press that reaches the nameplate on the lethal frame —\n## before `_update_drop_nameplate()` has run again to hide it — opens nothing.\n", ""],
	["## The controller's route to the comparison. A character that is not alive is\n## refused before the range is measured or a message is written (J4, D-328).\n", ""],
	["## While the character is not alive the nameplate is hidden and the prompt\n## cleared (J4, D-328). That takes effect from the first process update after\n## the lethal frame; a press before it is refused by `open_item_comparison()`.\n", ""],
	["\tif not player.is_alive():\n\t\treturn\n\tlog_event(\"item comparison opened\", reason)\n",
		"\tlog_event(\"item comparison opened\", reason)\n"],
	["\tif not player.is_alive():\n\t\treturn\n\tif not _active_drop.player_is_in_range(player.global_position):\n",
		"\tif not _active_drop.player_is_in_range(player.global_position):\n"],
	["\tif not player.is_alive():\n\t\t_nameplate.visible = false\n\t\thud.show_item_prompt(\"\")\n\t\treturn\n", ""],
	["\t## First-MVP UI J4 (D-328) moved it again, from `b35e04a6`, so that a character that is not alive\n\t## cannot open the item comparison. Same count.\n\t[\"res://scripts/first_mvp/severed_threshold/broken_watch_slice.gd\", \"c204a087\"],\n",
		"\t[\"res://scripts/first_mvp/severed_threshold/broken_watch_slice.gd\", \"b35e04a6\"],\n"],
	[", and Gate 1D's slice, which J3 and J4 moved (D-326, D-328)", J1_CLAUSE],
	[", but for Gate 1D's slice, which J3 and J4 moved (D-326, D-328)", J2_CLAUSE],
]

## First-MVP UI J5 (D-330) moved the slice, J1 and J2 again, one for one. Each is first put back to where
## J4 left it — the slice by removing J5's one line, J1 and J2 by removing J5's row comment and restoring
## the row and the clause J4 wrote — and is then read exactly as before. Each pair is [as J5 wrote it,
## as J4 left it].
const J5_SLICE_PREFIX: String = "f83e9436"
const J5_J1_PREFIX: String = "8c0e290c"
const J5_J2_PREFIX: String = "ca594f7d"
const J5_MOVES: Array = [
	["\tif not player.is_alive():\n\t\t_nameplate.visible = false\n\t\thud.show_item_prompt(\"\")\n\t\t_active_drop.set_soft_targeted(false)\n\t\treturn\n",
		"\tif not player.is_alive():\n\t\t_nameplate.visible = false\n\t\thud.show_item_prompt(\"\")\n\t\treturn\n"],
	["\t## First-MVP UI J5 (D-330) moved it again, from `c204a087`, so that a fallen character's ground drop\n\t## loses its controller highlight. Same count.\n\t[\"res://scripts/first_mvp/severed_threshold/broken_watch_slice.gd\", \"f83e9436\"],\n",
		"\t[\"res://scripts/first_mvp/severed_threshold/broken_watch_slice.gd\", \"c204a087\"],\n"],
	[", and Gate 1D's slice, which J3, J4 and J5 moved (D-326, D-328, D-330)", ", and Gate 1D's slice, which J3 and J4 moved (D-326, D-328)"],
	[", but for Gate 1D's slice, which J3, J4 and J5 moved (D-326, D-328, D-330)", ", but for Gate 1D's slice, which J3 and J4 moved (D-326, D-328)"],
]

## First-MVP UI J6 (D-332) moved J2 again, one for one, when the combat HUD moved: its HUD row gained a
## comment and its print a clause. It is first put back to where J5 left it and then read exactly as
## before. Each pair is [as J6 wrote it, as J5 left it].
const J6_J2_PREFIX: String = "f065a48d"
const J6_MOVES: Array = [
	["\t## First-MVP UI J6 (D-332) moved the combat HUD one for one, from `0bb284a1`, so that its Life and\n\t## Mana fills draw the fraction their labels state. Same count.\n\t[\"res://scripts/ui/first_mvp_combat_hud.gd\", \"aff939f3\"],\n",
		"\t[\"res://scripts/ui/first_mvp_combat_hud.gd\", \"0bb284a1\"],\n"],
	["\tprint(\"  %d files J2 stands beside hold the hashes they held before the first J2 edit, but for Gate 1D's slice, which J3, J4 and J5 moved (D-326, D-328, D-330), and the combat HUD, which J6 moved (D-332)\" % UNCHANGED_HASHES.size())\n",
		"\tprint(\"  %d files J2 stands beside hold the hashes they held before the first J2 edit, but for Gate 1D's slice, which J3, J4 and J5 moved (D-326, D-328, D-330)\" % UNCHANGED_HASHES.size())\n"],
]

## First-MVP UI J7 (D-334) moved J2 again, one for one, when the combat HUD moved: its HUD row gained a
## comment and a new hash. It is first put back to where J6 left it and then read exactly as before. Each
## pair is [as J7 wrote it, as J6 left it].
const J7_J2_PREFIX: String = "eb7f4153"
const J7_MOVES: Array = [
	["\t## First-MVP UI J7 (D-334) moved it again, from `aff939f3`, so that the enemy hover Life fill draws\n\t## its fraction. Same count.\n\t[\"res://scripts/ui/first_mvp_combat_hud.gd\", \"38c485cb\"],\n",
		"\t[\"res://scripts/ui/first_mvp_combat_hud.gd\", \"aff939f3\"],\n"],
]

## First-MVP UI J8 (D-336) moved J2 again, one for one, when the combat HUD moved: its HUD row gained a
## comment and a new hash. It is first put back to where J7 left it and then read exactly as before. Each
## pair is [as J8 wrote it, as J7 left it].
const J8_J2_PREFIX: String = "d5407c7c"
const J8_MOVES: Array = [
	["\t## First-MVP UI J8 (D-336) moved it again, from `38c485cb`, so that the player resource column sits\n\t## wholly inside the window. Same count.\n\t[\"res://scripts/ui/first_mvp_combat_hud.gd\", \"ee485029\"],\n",
		"\t[\"res://scripts/ui/first_mvp_combat_hud.gd\", \"38c485cb\"],\n"],
]

## First-MVP Gameplay J9 (D-338) moved the slice, J1 and J2 again, one for one: the slice's connection binds
## the first Graveblade and its callback receives it, and J1's and J2's slice rows gained a comment and a new
## hash. Each is first put back to where D-337 left it and then read exactly as before. Each pair is [as J9
## wrote it, as D-337 left it].
const J9_SLICE_PREFIX: String = "942aee83"
const J9_J1_PREFIX: String = "acbd3892"
const J9_J2_PREFIX: String = "6acc1e0c"
const J9_MOVES: Array = [
	["\t# First-MVP Gameplay J9 (decision D-338): the Graveblade that emits `died` is\n\t# bound, because `DamageEvent.source` is the attacker, not the enemy that died.\n\tgraveblades[0].died.connect(_on_first_graveblade_died.bind(graveblades[0]))\n",
		"\tgraveblades[0].died.connect(_on_first_graveblade_died)\n"],
	["func _on_first_graveblade_died(event: DamageEvent, enemy: PrototypeGraveblade) -> void:\n\tif _rewarded_enemies.has(enemy.get_instance_id()):\n",
		"func _on_first_graveblade_died(event: DamageEvent) -> void:\n\tvar enemy: Node = event.source\n\tif _rewarded_enemies.has(enemy.get_instance_id()):\n"],
	["\t## First-MVP Gameplay J9 (D-338) moved it again, from `f83e9436`, so that its guaranteed drop counts\n\t## the Graveblade that died rather than the attacker. Same count.\n\t[\"res://scripts/first_mvp/severed_threshold/broken_watch_slice.gd\", \"942aee83\"],\n",
		"\t[\"res://scripts/first_mvp/severed_threshold/broken_watch_slice.gd\", \"f83e9436\"],\n"],
]

## First-MVP Gameplay J10 (D-340) moved the slice, J1 and J2 again, one for one: the slice's restart ends the
## movement command it carried, and J1's and J2's slice rows gained a comment and a new hash. Each is first put
## back to where D-339 left it and then read exactly as before. Each pair is [as J10 wrote it, as D-339 left it].
const J10_SLICE_PREFIX: String = "883ef25e"
const J10_J1_PREFIX: String = "75f26486"
const J10_J2_PREFIX: String = "935a37e9"
const J10_MOVES: Array = [
	["\tplayer.global_position = broken_watch.entry()\n\t# First-MVP Gameplay J10 (decision D-340): the revival keeps the old destination,\n\t# locomotion and attack, so the one neutralization authority ends them at the entry.\n\tplayer.clear_movement_intent(reason, false)\n",
		"\tplayer.global_position = broken_watch.entry()\n"],
	["\t## First-MVP Gameplay J10 (D-340) moved it again, from `942aee83`, so that a restart leaves the character\n\t## standing at Broken Watch's entry. Same count.\n\t[\"res://scripts/first_mvp/severed_threshold/broken_watch_slice.gd\", \"883ef25e\"],\n",
		"\t[\"res://scripts/first_mvp/severed_threshold/broken_watch_slice.gd\", \"942aee83\"],\n"],
]


## First-MVP Gameplay J11 (D-344) moved the slice, J1 and J2 again, one for one: the slice opens Riftfall
## Landing's Watch Breach far cap in its own composition, and J1's and J2's slice rows gained a comment and a
## new hash. Each is first put back to where D-343 left it and then read exactly as before. Each pair is [as J11
## wrote it, as D-343 left it]. J3 still carries its pairs INLINE under D-343 ruling 5: its three targets — the
## slice, J1 and J2 — hold no reconstruction data of their own, so nothing written here can nest.
const J11_SLICE_PREFIX: String = "d4e839fb"
const J11_J1_PREFIX: String = "d12ad271"
const J11_J2_PREFIX: String = "72e39a8a"
const J11_MOVES: Array = [
	["\t# First-MVP Gameplay J11 (decision D-344): RIFTFALL LANDING CLOSED ITS OWN FAR END,\n\t# AND THAT CLOSURE IS FALSE IN THIS COMPOSITION. The Landing's accepted Greybox V2\n\t# ends in a tall boundary mass its own source calls \"the far cap beyond the landing,\n\t# so the space closes rather than trailing into open void\" -- exactly right for a\n\t# Landing that ends there, and a solid standing inside Broken Watch's Watch Threshold\n\t# here, because the two layouts are siblings in one shared local frame. On the route's\n\t# own centreline it stopped a player-sized body outright and the navigation mesh\n\t# carried no surface at all, so the seam was passable only by a detour the design\n\t# never drew. It is removed from THIS instance, before the bake, exactly as\n\t# `CanonicalOpeningRuntime` removes Broken Watch's own far cap toward the Nexus\n\t# Threshold: `riftfall_landing_greybox_layout.gd` is untouched, and the standalone\n\t# Landing review still builds the cap, because a Landing that ends there needs it.\n\t#\n\t# THE CAP IS FOUND FROM AUTHORED STRUCTURAL DATA, NOT FROM A NODE NAME: it is the only\n\t# Riftfall Landing boundary mass whose footprint overlaps a Broken Watch walkable\n\t# rectangle -- the defect itself, written as a predicate over both layouts' own\n\t# constants. Exactly one must qualify, and exactly its three built nodes must go: the\n\t# visual, the collision shape and the navigation carve. Anything else is a real change\n\t# to one of the two layouts, and it must fail loudly rather than quietly reseal the\n\t# route or quietly take more of the Landing down with it.\n\tvar landing_caps: Array[Rect2] = []\n\tfor mass: Dictionary in RiftfallLandingGreyboxLayout.BOUNDARY_MASSES:\n\t\tvar rect: Rect2 = mass[\"rect\"]\n\t\tfor room: Rect2 in BrokenWatchLayout.WALKABLE:\n\t\t\tif rect.intersects(room):\n\t\t\t\tlanding_caps.append(rect)\n\t\t\t\tbreak\n\tvar cap_nodes_removed: int = 0\n\tfor rect: Rect2 in landing_caps:\n\t\tvar stem: String = \"Boundary_%d_%d\" % [int(rect.position.x * 10.0), int(rect.position.y * 10.0)]\n\t\tfor built: String in [\"Visuals/%s\" % stem, \"WorldCollision/%s\" % stem,\n\t\t\t\t\"NavigationObstacles/%sCarve\" % stem]:\n\t\t\tvar node: Node = landing_layout.get_node_or_null(built)\n\t\t\tif node != null:\n\t\t\t\tnode.free()\n\t\t\t\tcap_nodes_removed += 1\n\tvar cap_fault: String = \"BrokenWatchSlice: expected exactly 1 Riftfall Landing far cap overlapping Broken Watch and its 3 built nodes, found %d and %d\" % [landing_caps.size(), cap_nodes_removed]\n\tif landing_caps.size() != 1 or cap_nodes_removed != 3:\n\t\t# `assert()` is stripped in release builds; `push_error()` is not, so both are used.\n\t\tpush_error(cap_fault)\n\tassert(landing_caps.size() == 1 and cap_nodes_removed == 3, cap_fault)\n\tlog_event(\"landing cap opened\", \"%d Riftfall Landing boundary mass overlaps Broken Watch; its %d built nodes are removed in THIS composition, before the bake\" % [landing_caps.size(), cap_nodes_removed])\n\n",
		""],
	["\t## First-MVP Gameplay J10 (D-340) moved it again, from `942aee83`, so that a restart leaves the character\n\t## standing at Broken Watch's entry. Same count.\n\t## First-MVP Gameplay J11 (D-344) moved it again, from `883ef25e`, so that Riftfall Landing's Watch Breach\n\t## far cap no longer seals the composed route into Broken Watch. Same count.\n\t[\"res://scripts/first_mvp/severed_threshold/broken_watch_slice.gd\", \"d4e839fb\"],\n",
		"\t## First-MVP Gameplay J10 (D-340) moved it again, from `942aee83`, so that a restart leaves the character\n\t## standing at Broken Watch's entry. Same count.\n\t[\"res://scripts/first_mvp/severed_threshold/broken_watch_slice.gd\", \"883ef25e\"],\n"],
]

## Everything J3 stands beside, at the SHA-256 prefix each held before the first J3 edit: the player,
## the modal contract, both Fallen overlays, the comparison and the HUD, the two subclasses and
## Prototype Zero's room, the combat, movement and item kernels, the layout, marker, camera and input
## tracker, four scenes, three records, project.godot, and the accepted suites beside this one.
const UNCHANGED_HASHES: Array = [
	["res://scripts/actors/prototype_player.gd", "80e38838"],
	["res://scripts/ui/first_mvp_modal.gd", "1cfe9c73"],
	["res://scripts/ui/first_mvp_fallen_overlay.gd", "de5e1ab0"],
	["res://scripts/roguelite/roguelite_fallen_overlay.gd", "1753e7b7"],
	["res://scripts/ui/first_mvp_item_comparison.gd", "3607f9f7"],
	## First-MVP UI J6 (D-332) moved the combat HUD one for one, from `0bb284a1`, so that its Life and
	## Mana fills draw the fraction their labels state. Same count.
	## First-MVP UI J7 (D-334) moved it again, from `aff939f3`, so that the enemy hover Life fill draws
	## its fraction. Same count.
	## First-MVP UI J8 (D-336) moved it again, from `38c485cb`, so that the player resource column sits
	## wholly inside the window. Same count.
	["res://scripts/ui/first_mvp_combat_hud.gd", "ee485029"],
	["res://scripts/first_mvp/canonical_opening/canonical_opening_runtime.gd", "601e5901"],
	["res://scripts/roguelite/roguelite_core_loop_runtime.gd", "a76cec3d"],
	["res://scripts/prototype_zero/prototype_zero.gd", "21b41e49"],
	["res://scripts/actors/prototype_graveblade.gd", "0ae1374b"],
	["res://scripts/combat/quick_strike_action.gd", "e6514705"],
	["res://scripts/combat/attack_coordinator.gd", "9ee63381"],
	["res://scripts/combat/damage_event.gd", "3b3185c4"],
	["res://scripts/combat/target_acquisition.gd", "bf4c14d4"],
	["res://scripts/combat/prototype_targetable.gd", "af29e970"],
	["res://scripts/movement/prototype_locomotion.gd", "c71de58f"],
	["res://scripts/movement/prototype_ground_pointer.gd", "ee7ab5ad"],
	["res://scripts/movement/prototype_mouse_hold.gd", "089e8dd5"],
	["res://scripts/items/first_mvp_item_drop.gd", "dbd5594d"],
	["res://scripts/items/player_loadout.gd", "d79b63df"],
	## First-MVP Gameplay J10 (D-340) moved Broken Watch's layout one for one, from `79c2b3a5`, so that its entry
	## socket stands clear of Riftfall Landing's Watch Breach far cap. Same count.
	["res://scripts/first_mvp/severed_threshold/broken_watch_layout.gd", "cac924df"],
	["res://scripts/prototype_zero/destination_marker.gd", "59a3e86d"],
	["res://scripts/camera/prototype_camera_rig.gd", "80c02363"],
	["res://scripts/input/input_family_tracker.gd", "8b721355"],
	["res://scenes/first_mvp/severed_threshold/broken_watch_slice.tscn", "e9d16993"],
	["res://scenes/actors/prototype_player.tscn", "3078a215"],
	["res://scenes/actors/prototype_graveblade.tscn", "752db86c"],
	["res://scenes/first_mvp/canonical_opening/canonical_opening.tscn", "b1d9f2e4"],
	["res://data/prototype_zero/graveblade.tres", "56317f5f"],
	["res://data/first_mvp/severed_threshold/broken_watch/starting_sword.tres", "08e97d2e"],
	["res://data/first_mvp/severed_threshold/broken_watch/watchsteel_sword.tres", "e67730b2"],
	["res://project.godot", "55351038"],
	["res://tests/gate_1d_broken_watch_verification.gd", "9393f97a"],
	["res://tests/gate_1d_broken_watch_smoke.sh", "6f2878f7"],
	["res://tests/gate_1e_canonical_opening_verification.gd", "cef72cb6"],
	["res://tests/first_mvp_modal_left_click_smoke.sh", "977c05bd"],
	["res://tests/fallen_modal_life_state_smoke.sh", "9e0977fb"],
]

## The Fallen overlay's own words for the Graveblade's Hit, typed independently of the overlay.
const KILLING_SOURCE: String = "Graveblade — Melee Hit — 125 Physical Damage"
const RESTART_CAPTION: String = "Restart Broken Watch"

## Where F5 lands inside the 0.90 s delay. "late" is the last frame boundary at which the harness can
## still be sure it acts first: when the countdown left is no more than LATE_FRAMES of the longest
## process frame that same delay has taken.
const POINTS: Array[String] = ["immediate", "early", "middle", "late"]
const POINT_WORDS: Dictionary = {
	"immediate": "immediately after the lethal frame", "early": "early in the delay",
	"middle": "at the middle of the delay", "late": "late in the delay",
}
const EARLY_REMAINING: float = 0.75
const MIDDLE_REMAINING: float = 0.45
const LATE_FRAMES: float = 1.5
## At least as long as the whole delay and the overlay's fade, and then some — the J2 window.
const WINDOW_SECONDS: float = BrokenWatchSlice.FALLEN_DELAY + FirstMvpFallenOverlay.FADE_SECONDS + 0.4
const NEAR: float = 1.2
const PROBE_SAMPLE: int = 6
const PROBE_REASON: String = "j3 neutralization inside the delay"

const OWED_CHECKS: Array[String] = [
	"the_production_scope_is_exactly_the_slice",
	"restart_current_slice_is_the_accepted_body_with_two_cancellations_before_the_revival",
	"the_slice_declares_nothing_new_and_the_delay_is_unchanged",
	"the_reach_is_gate_1d_and_the_one_subclass_that_calls_it",
	"no_scene_input_map_or_presentation_changed",
	"a_real_graveblade_kill_arms_the_normal_delay",
	"the_delay_keeps_the_player_fallen_with_no_overlay",
	"f5_immediately_after_the_lethal_frame_cancels",
	"f5_early_in_the_delay_cancels",
	"f5_at_the_middle_of_the_delay_cancels",
	"f5_late_in_the_delay_cancels",
	"cancellation_comes_before_the_revival",
	"no_stale_event_second_restart_or_second_revival",
	"a_later_genuine_death_opens_fallen_once_with_its_new_event",
	"restart_by_focused_confirm_with_the_overlay_standing",
	"restart_by_a_real_left_click_with_the_overlay_standing",
	"restart_by_f5_with_the_overlay_standing",
	"restarting_a_living_character_arms_nothing",
	"the_j2_state_contract_holds_while_fallen",
	"the_guaranteed_drop_latch_is_unchanged",
]

var arguments: PackedStringArray = PackedStringArray()
var slice: BrokenWatchSlice

var _failures: PackedStringArray = PackedStringArray()
var _checks: int = 0
var _reached: Dictionary = {}
var _staged: PackedStringArray = PackedStringArray()
var _next_use_id: int = 326000

## One record per death, in order.
var _deaths: Array[Dictionary] = []
## The four deaths F5 cancelled inside the delay, by point.
var _cancelled: Dictionary = {}
## The three deaths whose overlay opened, by restart route.
var _opened: Dictionary = {}
## The one living restart.
var _living: Dictionary = {}
## Every restart's revival reading, in order, for the ordering check.
var _restarts: Array[Dictionary] = []
## What the room held as its pending event at each moment the Fallen overlay emitted `opened`.
var _opened_pending: Array = []
## How often the harness had to close an overlay that should never have opened.
var _cleanups: int = 0
## The guaranteed drop's latch after the first kill, after every restart, and after one more kill.
var _latch_start: Dictionary = {}
var _latch_end: Dictionary = {}
var _latch_after_kill: Dictionary = {}
var _second_kill: Dictionary = {}
## Where Gate 1D's restart leaves the character once its body has settled, read after the focused
## confirm restart; the click restart, readable only after the next frame's input flush, is held to it.
var _gate_1d_settled: Vector3 = Vector3.INF

var _fired: Dictionary = {}
var _watched: Array[Dictionary] = []


func _initialize() -> void:
	_main.call_deferred()


func _main() -> void:
	arguments = OS.get_cmdline_user_args()
	print("")
	print("=== First-MVP UI J3 — Gate 1D Pending-Fallen Cancellation on Restart V1 verification (D-326) ===")

	_check_the_production_scope_is_exactly_the_slice()
	_check_restart_current_slice_is_the_accepted_body_with_two_cancellations_before_the_revival()
	_check_the_slice_declares_nothing_new_and_the_delay_is_unchanged()
	_check_the_reach_is_gate_1d_and_the_one_subclass_that_calls_it()
	_check_no_scene_input_map_or_presentation_changed()

	await _play()
	if slice != null:
		_check_a_real_graveblade_kill_arms_the_normal_delay()
		_check_the_delay_keeps_the_player_fallen_with_no_overlay()
		_check_f5_immediately_after_the_lethal_frame_cancels()
		_check_f5_early_in_the_delay_cancels()
		_check_f5_at_the_middle_of_the_delay_cancels()
		_check_f5_late_in_the_delay_cancels()
		_check_cancellation_comes_before_the_revival()
		_check_no_stale_event_second_restart_or_second_revival()
		_check_a_later_genuine_death_opens_fallen_once_with_its_new_event()
		_check_restart_by_focused_confirm_with_the_overlay_standing()
		_check_restart_by_a_real_left_click_with_the_overlay_standing()
		_check_restart_by_f5_with_the_overlay_standing()
		_check_restarting_a_living_character_arms_nothing()
		_check_the_j2_state_contract_holds_while_fallen()
		_check_the_guaranteed_drop_latch_is_unchanged()

	_check_every_check_ran()

	print("")
	print("  staged: %s" % "; ".join(_staged))
	if _failures.is_empty():
		print("PENDING FALLEN RESTART VERIFICATION: PASS (%d checks)" % _checks)
		quit(0)
	else:
		for failure: String in _failures:
			printerr("  FAIL: %s" % failure)
		printerr("PENDING FALLEN RESTART VERIFICATION: %d FAILURE(S) of %d checks" % [_failures.size(), _checks])
		quit(1)


# --- 1–5. Structure: the one file, its one method, its reach ----------------------------------

func _check_the_production_scope_is_exactly_the_slice() -> void:
	print("")
	print("--- 1. Exactly one production file moved — Gate 1D's slice — and it is the pre-J3 file plus one comment and two lines")
	var source: String = _before_j4(_before_j5(_before_j9(_before_j10(_before_j11(FileAccess.get_file_as_string(SLICE_SCRIPT))))))
	var digest: String = source.sha256_text()
	var rebuilt: String = source.replace(J3_ADDED_COMMENT, "").replace(J3_CANCELLATION, "")
	_expect(FileAccess.get_sha256(SLICE_SCRIPT).begins_with(J11_SLICE_PREFIX)
			and _before_j11(FileAccess.get_file_as_string(SLICE_SCRIPT)).sha256_text().begins_with(J10_SLICE_PREFIX)
			and _before_j10(_before_j11(FileAccess.get_file_as_string(SLICE_SCRIPT))).sha256_text().begins_with(J9_SLICE_PREFIX)
			and _before_j9(_before_j10(_before_j11(FileAccess.get_file_as_string(SLICE_SCRIPT)))).sha256_text().begins_with(J5_SLICE_PREFIX)
			and _before_j5(_before_j9(_before_j10(_before_j11(FileAccess.get_file_as_string(SLICE_SCRIPT))))).sha256_text().begins_with(J4_SLICE_PREFIX) and digest.begins_with(J3_PREFIX)
			and source.count(J3_ADDED_COMMENT) == 1 and source.count(J3_CANCELLATION) == 1
			and rebuilt.sha256_text() == PRE_J3_SHA256,
		"the slice hashes %s; the comment occurs %d time(s), the cancellation %d; the reconstruction hashes %s"
			% [digest.left(8), source.count(J3_ADDED_COMMENT), source.count(J3_CANCELLATION), rebuilt.sha256_text().left(8)])
	var moved: PackedStringArray = PackedStringArray()
	for row: Array in UNCHANGED_HASHES:
		var held: String = FileAccess.get_sha256(String(row[0]))
		if not held.begins_with(String(row[1])):
			moved.append("%s %s" % [String(row[0]).get_file(), held.left(8)])
	_expect(moved.is_empty() and UNCHANGED_HASHES.size() == 37, "moved: %s" % ", ".join(moved))
	var j1: String = _before_j4(_before_j5(_before_j9(_before_j10(_before_j11(FileAccess.get_file_as_string(J1_VERIFICATION))))))
	var j2: String = _before_j4(_before_j5(_before_j6(_before_j7(_before_j8(_before_j9(_before_j10(_before_j11(FileAccess.get_file_as_string(J2_VERIFICATION)))))))))
	var j1_back: String = j1.replace(_slice_row_new(), SLICE_ROW_OLD).replace(J1_CLAUSE, "")
	var j2_back: String = j2.replace(_slice_row_new(), SLICE_ROW_OLD).replace(J2_CLAUSE, "")
	_expect(FileAccess.get_sha256(J1_VERIFICATION).begins_with(J11_J1_PREFIX)
			and _before_j11(FileAccess.get_file_as_string(J1_VERIFICATION)).sha256_text().begins_with(J10_J1_PREFIX)
			and _before_j10(_before_j11(FileAccess.get_file_as_string(J1_VERIFICATION))).sha256_text().begins_with(J9_J1_PREFIX)
			and _before_j9(_before_j10(_before_j11(FileAccess.get_file_as_string(J1_VERIFICATION)))).sha256_text().begins_with(J5_J1_PREFIX)
			and _before_j5(_before_j9(_before_j10(_before_j11(FileAccess.get_file_as_string(J1_VERIFICATION))))).sha256_text().begins_with(J4_J1_PREFIX) and j1.sha256_text().begins_with(J1_PREFIX)
			and j1.count(_slice_row_new()) == 1 and j1.count(J1_CLAUSE) == 1 and j1_back.sha256_text() == J1_PRE_SHA256
			and FileAccess.get_sha256(J2_VERIFICATION).begins_with(J11_J2_PREFIX)
			and _before_j11(FileAccess.get_file_as_string(J2_VERIFICATION)).sha256_text().begins_with(J10_J2_PREFIX)
			and _before_j10(_before_j11(FileAccess.get_file_as_string(J2_VERIFICATION))).sha256_text().begins_with(J9_J2_PREFIX)
			and _before_j9(_before_j10(_before_j11(FileAccess.get_file_as_string(J2_VERIFICATION)))).sha256_text().begins_with(J8_J2_PREFIX)
			and _before_j8(_before_j9(_before_j10(_before_j11(FileAccess.get_file_as_string(J2_VERIFICATION))))).sha256_text().begins_with(J7_J2_PREFIX)
			and _before_j7(_before_j8(_before_j9(_before_j10(_before_j11(FileAccess.get_file_as_string(J2_VERIFICATION)))))).sha256_text().begins_with(J6_J2_PREFIX)
			and _before_j6(_before_j7(_before_j8(_before_j9(_before_j10(_before_j11(FileAccess.get_file_as_string(J2_VERIFICATION))))))).sha256_text().begins_with(J5_J2_PREFIX)
			and _before_j5(_before_j6(_before_j7(_before_j8(_before_j9(_before_j10(_before_j11(FileAccess.get_file_as_string(J2_VERIFICATION)))))))).sha256_text().begins_with(J4_J2_PREFIX) and j2.sha256_text().begins_with(J2_PREFIX)
			and j2.count(_slice_row_new()) == 1
			and j2.count(J2_CLAUSE) == 1 and j2_back.sha256_text() == J2_PRE_SHA256,
		"J1 %s rebuilds to %s; J2 %s rebuilds to %s" % [FileAccess.get_sha256(J1_VERIFICATION).left(8), j1_back.sha256_text().left(8),
			FileAccess.get_sha256(J2_VERIFICATION).left(8), j2_back.sha256_text().left(8)])
	print("  the slice is at its J5 hash %s; with J5's one line removed, at its J4 hash %s; with J4's 3 comments and 3 guards removed, at its J3 hash %s; with J3's %d comment lines and its 2 cancellation lines removed it is, byte for byte, the pre-J3 file %s — once J9's two changes (D-338) are put back, and J10's clearing line (D-340) before them"
		% [J5_SLICE_PREFIX, J4_SLICE_PREFIX, J3_PREFIX, J3_ADDED_COMMENT.count("\n"), PRE_J3_SHA256.left(8)])
	print("  %d files J3 stands beside hold the hashes they held before the first J3 edit, but for the combat HUD, which J6 moved (D-332), and Broken Watch's layout, which J10 moved (D-340)" % UNCHANGED_HASHES.size())
	print("  J1's and J2's verifications moved only their slice row, with its comment and one clause in their print, under J3, again under J4 and again under J5: put back, they are byte for byte %s and %s"
		% [J1_PRE_SHA256.left(8), J2_PRE_SHA256.left(8)])
	_done("the_production_scope_is_exactly_the_slice")


func _slice_row_new() -> String:
	return SLICE_ROW_COMMENT + "\t[\"res://scripts/first_mvp/severed_threshold/broken_watch_slice.gd\", \"%s\"],\n" % J3_PREFIX


## Puts the slice, J1 and J2 back to where J3 left them (First-MVP UI J4, D-328).
func _before_j4(text: String) -> String:
	for pair: Array in J4_MOVES:
		text = text.replace(String(pair[0]), String(pair[1]))
	return text


## Puts the slice, J1 and J2 back to where J4 left them (First-MVP UI J5, D-330).
func _before_j5(text: String) -> String:
	for pair: Array in J5_MOVES:
		text = text.replace(String(pair[0]), String(pair[1]))
	return text


## Puts J2 back to where J5 left it (First-MVP UI J6, D-332).
func _before_j6(text: String) -> String:
	for pair: Array in J6_MOVES:
		text = text.replace(String(pair[0]), String(pair[1]))
	return text


## Puts J2 back to where J6 left it (First-MVP UI J7, D-334).
func _before_j7(text: String) -> String:
	for pair: Array in J7_MOVES:
		text = text.replace(String(pair[0]), String(pair[1]))
	return text


## Puts J2 back to where J7 left it (First-MVP UI J8, D-336).
func _before_j8(text: String) -> String:
	for pair: Array in J8_MOVES:
		text = text.replace(String(pair[0]), String(pair[1]))
	return text


## Puts the slice, J1 and J2 back to where D-337 left them (First-MVP Gameplay J9, D-338).
func _before_j9(text: String) -> String:
	for pair: Array in J9_MOVES:
		text = text.replace(String(pair[0]), String(pair[1]))
	return text


## Puts the slice, J1 and J2 back to where D-339 left them (First-MVP Gameplay J10, D-340).
func _before_j10(text: String) -> String:
	for pair: Array in J10_MOVES:
		text = text.replace(String(pair[0]), String(pair[1]))
	return text


## Puts a file First-MVP Gameplay J11 (decision D-344) moved back to where D-343 left it.
func _before_j11(text: String) -> String:
	for pair: Array in J11_MOVES:
		text = text.replace(String(pair[0]), String(pair[1]))
	return text


func _check_restart_current_slice_is_the_accepted_body_with_two_cancellations_before_the_revival() -> void:
	print("")
	print("--- 2. restart_current_slice() is the accepted body with the two cancellations between its log line and the revival; the arming and firing of the delay are untouched")
	var source: String = FileAccess.get_file_as_string(SLICE_SCRIPT)
	var lines: PackedStringArray = _code_lines(_function_body(source, "restart_current_slice"))
	var accepted: PackedStringArray = PackedStringArray(RESTART_LINES)
	accepted.remove_at(accepted.find("_pending_fallen_event = null"))
	accepted.remove_at(accepted.find("_fallen_countdown = -1.0"))
	var rebuilt: PackedStringArray = lines.duplicate()
	for cancellation: String in ["_fallen_countdown = -1.0", "_pending_fallen_event = null"]:
		if rebuilt.has(cancellation):
			rebuilt.remove_at(rebuilt.find(cancellation))
	var revival: int = lines.find("player.revive_for_testing()")
	_expect(lines == PackedStringArray(RESTART_LINES) and rebuilt == accepted and revival == 3
			and lines[1] == "_fallen_countdown = -1.0" and lines[2] == "_pending_fallen_event = null"
			and lines.count("return") == 0 and not "\n".join(lines).contains("if ")
			and source.count(RESTART_SIGNATURE) == 1 and source.count("func restart_current_slice(") == 1
			and source.contains(J3_ADDED_COMMENT + RESTART_SIGNATURE)
			and _code_lines(_function_body(source, "_on_player_fell")) == PackedStringArray(FELL_LINES)
			and _code_lines(_function_body(source, "_tick_fallen_delay")) == PackedStringArray(TICK_LINES),
		"restart_current_slice reads %s" % str(lines))
	print("  %d code lines: the log line, then `_fallen_countdown = -1.0` and `_pending_fallen_event = null`, then the accepted revival, entry, J10's movement-intent clearing (D-340), facing, Graveblade reset, permission reset, soft target and marker — no return, no condition, the signature (reason: String) unchanged"
		% lines.size())
	print("  _on_player_fell() is its 5 accepted lines and _tick_fallen_delay() its 6; J3's comment sits directly above the method it describes")
	_done("restart_current_slice_is_the_accepted_body_with_two_cancellations_before_the_revival")


func _check_the_slice_declares_nothing_new_and_the_delay_is_unchanged() -> void:
	print("")
	print("--- 3. No slice field, export, function, constant, signal or accessor was added; the delay, its sentinel and the two fields are declared as before")
	var source: String = FileAccess.get_file_as_string(SLICE_SCRIPT)
	var fields: int = RegEx.create_from_string("(?m)^var ").search_all(source).size()
	var exports: int = RegEx.create_from_string("(?m)^@export var ").search_all(source).size()
	var constants: int = RegEx.create_from_string("(?m)^const ").search_all(source).size()
	var signals: int = RegEx.create_from_string("(?m)^signal ").search_all(source).size()
	var enums: int = RegEx.create_from_string("(?m)^enum ").search_all(source).size()
	var functions: PackedStringArray = _declared_functions(source)
	var code: String = _bare(source)
	var countdown_writers: PackedStringArray = PackedStringArray()
	var pending_writers: PackedStringArray = PackedStringArray()
	for name: String in functions:
		var body: String = _function_body(code, name)
		if body.contains("_fallen_countdown = "):
			countdown_writers.append(name)
		if body.contains("_pending_fallen_event = "):
			pending_writers.append(name)
	_expect(fields == SLICE_FIELDS and exports == SLICE_EXPORTS and functions.size() == SLICE_FUNCTIONS
			and constants == SLICE_CONSTANTS and signals == 0 and enums == 0
			and source.count("const FALLEN_DELAY: float = 0.90\n") == 1
			and source.count("var _fallen_countdown: float = -1.0\n") == 1
			and source.count("var _pending_fallen_event: DamageEvent = null\n") == 1
			and countdown_writers == PackedStringArray(["_on_player_fell", "_tick_fallen_delay", "restart_current_slice"])
			and pending_writers == PackedStringArray(["_on_player_fell", "restart_current_slice"]),
		"%d fields, %d exports, %d functions, %d constants, %d signals, %d enums; countdown written in %s, pending in %s"
			% [fields, exports, functions.size(), constants, signals, enums, str(countdown_writers), str(pending_writers)])
	print("  %d fields, %d exports, %d functions, %d constants, no signal and no enum — the counts before J3; FALLEN_DELAY is still 0.90 and the countdown's inactive sentinel still -1.0"
		% [fields, exports, functions.size(), constants])
	print("  the countdown is written in [%s] and the pending event in [%s]" % [", ".join(countdown_writers), ", ".join(pending_writers)])
	_done("the_slice_declares_nothing_new_and_the_delay_is_unchanged")


func _check_the_reach_is_gate_1d_and_the_one_subclass_that_calls_it() -> void:
	print("")
	print("--- 4. What the two lines reach (structural): Gate 1D, and Gate 1E's runtime because it calls the method first; the roguelite overrides it and is untouched")
	var extenders: PackedStringArray = PackedStringArray()
	var declarers: PackedStringArray = PackedStringArray()
	var users: PackedStringArray = PackedStringArray()
	var scanned: int = 0
	for root_path: String in SCANNED_ROOTS:
		for path: String in _files_under(root_path, [".gd"]):
			scanned += 1
			var code: String = _bare(FileAccess.get_file_as_string(path))
			if code.contains("extends BrokenWatchSlice"):
				extenders.append(path.get_file())
			if code.contains("func restart_current_slice("):
				declarers.append(path.get_file())
			if path != SLICE_SCRIPT and (code.contains("_pending_fallen_event") or code.contains("_fallen_countdown")):
				users.append(path.get_file())
	extenders.sort()
	declarers.sort()
	users.sort()
	var opening: PackedStringArray = _code_lines(_function_body(_bare(FileAccess.get_file_as_string(OPENING_SCRIPT)), "restart_current_slice"))
	var loop_body: String = _function_body(_bare(FileAccess.get_file_as_string(CORE_LOOP_SCRIPT)), "restart_current_slice")
	var prototype: String = _bare(FileAccess.get_file_as_string(PROTOTYPE_ROOM_SCRIPT))
	_expect(scanned > 100 and extenders == PackedStringArray(["canonical_opening_runtime.gd", "roguelite_core_loop_runtime.gd"])
			and declarers == PackedStringArray(["broken_watch_slice.gd", "canonical_opening_runtime.gd",
				"roguelite_core_loop_runtime.gd", "roguelite_experience_collection_review.gd"])
			and not opening.is_empty() and opening[0] == "super.restart_current_slice(reason)"
			and not loop_body.contains("super") and loop_body.contains("_fallen_countdown = -1.0")
			and loop_body.contains("_pending_fallen_event = null")
			and users == PackedStringArray(["prototype_zero.gd", "roguelite_core_loop_runtime.gd"])
			and not prototype.contains("extends BrokenWatchSlice") and not prototype.contains("_pending_fallen_event"),
		"extenders %s; declarers %s; users %s; Gate 1E's first line %s" % [str(extenders), str(declarers), str(users), str(opening.slice(0, 1))])
	print("  of %d running scripts, 2 extend BrokenWatchSlice: canonical_opening_runtime.gd, whose restart_current_slice() calls super first, so Gate 1E inherits the cancellation; and roguelite_core_loop_runtime.gd, which overrides it without super and already clears both facts"
		% scanned)
	print("  the two field names appear in no other running script but prototype_zero.gd, which declares its own separate _fallen_countdown and does not extend the slice")
	_done("the_reach_is_gate_1d_and_the_one_subclass_that_calls_it")


func _check_no_scene_input_map_or_presentation_changed() -> void:
	print("")
	print("--- 5. The InputMap, the entrypoint and project.godot are untouched; the scene, both Fallen overlays and the HUD hold their pre-J3 hashes (check 1)")
	var actions: int = 0
	for action: StringName in InputMap.get_actions():
		if String(action).begins_with("ui_") and not String(action) in ["ui_confirm", "ui_cancel"]:
			continue
		actions += 1
	var settings: String = FileAccess.get_file_as_string(PROJECT_SETTINGS_FILE)
	_expect(actions == EXPECTED_ACTIONS and String(ProjectSettings.get_setting("application/run/main_scene", "")) == ENTRYPOINT
			and not settings.contains("[autoload]") and not settings.contains("pending_fallen"),
		"%d actions, or project.godot moved" % actions)
	print("  %d actions; the entrypoint is %s; project.godot declares no [autoload] and names nothing of J3" % [actions, ENTRYPOINT.get_file()])
	_done("no_scene_input_map_or_presentation_changed")


# --- The play, in Gate 1D's own slice ---------------------------------------------------------

func _play() -> void:
	slice = await _load(SLICE_SCENE) as BrokenWatchSlice
	if slice == null:
		return
	await _await_navigation()
	for enemy: PrototypeGraveblade in slice.graveblades:
		enemy.set_ai_enabled(false)
	slice.fallen_overlay.opened.connect(_on_overlay_opened)
	_note("Gate 1D's two Graveblades quieted; the first placed and killed through receive_damage() so the guaranteed drop exists")
	var first: PrototypeGraveblade = slice.graveblades[0]
	first.place_at(slice.landing_layout.player_start() + _forward() * 6.0)
	_kill(first)
	await _settle(3)
	_latch_start = _latch_reading()

	for point: String in POINTS:
		var record: Dictionary = await _strike_player("F5 %s" % POINT_WORDS[point], 0)
		await _cancel_in_delay(record, point)
		_cancelled[point] = record

	var by_confirm: Dictionary = await _strike_player("a genuine death, then Enter on the focused button", 0)
	await _wait_for_overlay(by_confirm, true)
	await _stand_behind_the_overlay(by_confirm)
	await _restart_with_the_overlay_open(by_confirm, "confirm")
	_opened["confirm"] = by_confirm

	var by_click: Dictionary = await _strike_player("a genuine death, then a real left click", 0)
	await _wait_for_overlay(by_click, false)
	await _stand_behind_the_overlay(by_click)
	await _restart_with_the_overlay_open(by_click, "click")
	_opened["click"] = by_click

	var by_f5: Dictionary = await _strike_player("a genuine death, then F5 with the overlay standing", 0)
	await _wait_for_overlay(by_f5, false)
	await _stand_behind_the_overlay(by_f5)
	await _restart_with_the_overlay_open(by_f5, "f5")
	_opened["f5"] = by_f5

	await _restart_a_living_character()

	_latch_end = _latch_reading()
	var refused: int = _log_count("reward refused")
	var granted: int = _log_count("guaranteed drop")
	_kill(first)
	await _settle(3)
	_latch_after_kill = _latch_reading()
	_second_kill = {"refused": _log_count("reward refused") - refused, "granted": _log_count("guaranteed drop") - granted}
	_note("the first Graveblade killed once more through receive_damage(), after every restart, to read the latch")


func _on_overlay_opened() -> void:
	_opened_pending.append(slice._pending_fallen_event)


## STAGED start, real Hits: the player is placed at Riftfall Landing's start facing the route and the
## second Graveblade 1.2 m in front of it; each attack is begun through the Graveblade's own
## verification seam and everything after that is the attack's own. `hits` 0 means until the player
## falls. Listens to every Life, Hit, fall and neutralization the player reports until the record is
## closed, and reads the room's two pending facts at each Life change.
func _strike_player(label: String, hits: int) -> Dictionary:
	var player: PrototypePlayer = slice.player
	var killer: PrototypeGraveblade = slice.graveblades[1]
	var forward: Vector3 = _forward()
	var start: Vector3 = slice.landing_layout.player_start()
	await _until_neutral()
	for enemy: PrototypeGraveblade in slice.graveblades:
		enemy.set_ai_enabled(false)
	_stand_facing(start, forward)
	killer.place_at(start + forward * NEAR)
	killer.face_instantly(-forward)
	await _settle(2)
	var counts: Dictionary = {"life_changed": 0, "took_damage": 0, "fell": 0}
	var emissions: Array[Dictionary] = []
	var cleared: Array[Dictionary] = []
	var record: Dictionary = {
		"label": label, "counts": counts, "emissions": emissions, "cleared": cleared, "trail": [], "began": 0,
		"life_before": player.life, "max_before": player.max_life, "killer": killer,
		"record_damage": float((load(GRAVEBLADE_RECORD) as Resource).get("physical_damage")),
		"restarts_at_start": _log_count("slice restarted"),
	}
	var on_life: Callable = func(current: float, maximum: float) -> void:
		counts["life_changed"] = int(counts["life_changed"]) + 1
		emissions.append({"life": current, "max": maximum, "state": player.action_state_name(), "awaiting": player.awaiting_neutral,
			"reason": player.neutral_reason, "countdown": slice._fallen_countdown, "pending_null": slice._pending_fallen_event == null})
	var on_damage: Callable = func(_event: DamageEvent) -> void: counts["took_damage"] = int(counts["took_damage"]) + 1
	var on_fell: Callable = func(_event: DamageEvent) -> void: counts["fell"] = int(counts["fell"]) + 1
	var on_cleared: Callable = func(reason: String) -> void:
		cleared.append({"reason": reason, "state": player.action_state_name(), "life": player.life})
	player.life_changed.connect(on_life)
	player.took_damage.connect(on_damage)
	player.fell.connect(on_fell)
	player.movement_intent_cleared.connect(on_cleared)
	record["listeners"] = [on_life, on_damage, on_fell, on_cleared]

	for guard: int in 8:
		if not player.is_alive() or (hits > 0 and int(record["began"]) >= hits):
			break
		var taken: int = player.damage_taken_events
		var began: bool = false
		for attempt: int in 120:
			began = killer.begin_attack_for_verification()
			if began:
				break
			await physics_frame
		if not began:
			break
		record["began"] = int(record["began"]) + 1
		for frame: int in 180:
			await physics_frame
			if player.damage_taken_events > taken:
				break
		(record["trail"] as Array).append(player.life)

	var event: DamageEvent = player.last_damage_taken
	record["event"] = event
	record["dead"] = not player.is_alive()
	record["lethal"] = {
		"state": player.action_state_name(), "alive": player.is_alive(), "life": player.life,
		"overlay": slice.fallen_overlay.is_open or slice.item_comparison.is_open, "paused": paused,
		"holder_free": slice.attack_coordinator.holder() == null, "acting": _ai_count(),
		"countdown": slice._fallen_countdown, "pending_is_event": event != null and slice._pending_fallen_event == event,
		"from_killer": event != null and event.source == killer,
	}
	if bool(record["dead"]):
		_deaths.append(record)
	return record


## Every frame of the delay the harness samples, and the property it must hold there.
func _delay_frame_ok(record: Dictionary, remaining: float) -> bool:
	var player: PrototypePlayer = slice.player
	return (player.action_state == PrototypePlayer.ActionState.FALLEN and not player.is_alive() and player.life == 0.0
		and not paused and not slice.fallen_overlay.is_open and not slice.item_comparison.is_open
		and remaining > 0.0 and remaining <= BrokenWatchSlice.FALLEN_DELAY
		and slice._pending_fallen_event == record["event"] and _log_count("slice restarted") == int(record["restarts_at_start"])
		and slice.attack_coordinator.holder() == null and _ai_count() == 0)


func _push_now(point: String, remaining: float, longest: float) -> bool:
	match point:
		"immediate":
			return true
		"early":
			return remaining <= EARLY_REMAINING
		"middle":
			return remaining <= MIDDLE_REMAINING
		"late":
			return longest > 0.0 and remaining <= LATE_FRAMES * longest
	return true


## Samples the delay frame by frame until `point`, then presses F5 into the slice's own input
## handling, reads the restart in the same call, and watches the 1.75 s after it.
func _cancel_in_delay(record: Dictionary, point: String) -> void:
	var overlay: FirstMvpFallenOverlay = slice.fallen_overlay
	var faults: PackedStringArray = PackedStringArray()
	var samples: int = 0
	var longest: float = 0.0
	var missed: bool = false
	var remaining: float = slice._fallen_countdown
	var opens: int = overlay.opens
	var last_usec: int = Time.get_ticks_usec()
	for frame: int in 600:
		if overlay.is_open or overlay.opens != opens:
			missed = true
			break
		remaining = slice._fallen_countdown
		if not _delay_frame_ok(record, remaining):
			faults.append("sample %d" % samples)
		samples += 1
		if _push_now(point, remaining, longest):
			break
		await process_frame
		var now: int = Time.get_ticks_usec()
		longest = maxf(longest, float(now - last_usec) / 1000000.0)
		last_usec = now
	record["delay"] = {"samples": samples, "faults": faults, "missed": missed, "remaining": remaining, "longest": longest}

	var restarts: int = _log_count("slice restarted")
	var closes: int = overlay.closes
	var mark: int = (record["emissions"] as Array).size()
	_push_key(KEY_F5, true)
	var reading: Dictionary = _restart_reading(record, "quick restart", restarts, mark)
	reading["overlay_untouched"] = not overlay.is_open and overlay.opens == opens and overlay.closes == closes
	_push_key(KEY_F5, false)
	_quiet_after_restart()
	record["restart"] = reading
	await _window(record)
	_disconnect(record)


## What a restart left, read in the call that made it.
func _restart_reading(record: Dictionary, reason: String, restarts_before: int, mark: int) -> Dictionary:
	var player: PrototypePlayer = slice.player
	var spawns: Array[Vector3] = [slice.broken_watch.first_encounter_spawn(), slice.broken_watch.second_encounter_spawn()]
	var enemies_ok: bool = true
	for index: int in slice.graveblades.size():
		var enemy: PrototypeGraveblade = slice.graveblades[index]
		enemies_ok = (enemies_ok and enemy.is_alive() and enemy.life == enemy.data.max_life and enemy.ai_enabled
			and _planar_gap(enemy.global_position, spawns[index]) < 0.6)
	var revivals: Array = (record["emissions"] as Array).slice(mark)
	var reading: Dictionary = {
		"restarted_once": _log_count("slice restarted") == restarts_before + 1 and _last_log("slice restarted").ends_with(reason),
		"countdown": slice._fallen_countdown, "pending_null": slice._pending_fallen_event == null,
		"alive": player.is_alive() and player.action_state == PrototypePlayer.ActionState.IDLE,
		"full": player.life == player.max_life and player.max_life == float(record["max_before"]) and player.mana == player.max_mana,
		"revivals": revivals, "entry_gap": _planar_gap(player.global_position, slice.broken_watch.entry()),
		"enemies": enemies_ok, "permission": slice.attack_coordinator.holder() == null, "running": not paused,
		"instrumentation": player.damage_taken_events == 0 and player.last_damage_taken == null and player.fallen_at_msec == 0,
		"soft_target": slice._soft_target == null, "loadout": slice.loadout != null and player.weapon == slice.loadout.equipped_weapon,
	}
	_restarts.append({"label": record["label"], "revivals": revivals})
	return reading


func _quiet_after_restart() -> void:
	for enemy: PrototypeGraveblade in slice.graveblades:
		enemy.set_ai_enabled(false)


## The 1.75 s after a restart, every process frame: no overlay opens or stands, the tree never pauses,
## the character stays alive, the countdown stays inactive with no pending event, and no second
## restart, revival or fall happens. An overlay that opened anyway is closed so the run can go on.
func _window(record: Dictionary) -> void:
	var player: PrototypePlayer = slice.player
	var overlay: FirstMvpFallenOverlay = slice.fallen_overlay
	var counts: Dictionary = record["counts"]
	var emissions: Array = record["emissions"]
	var opens: int = overlay.opens
	var restarts: int = _log_count("slice restarted")
	var mark: int = emissions.size()
	var fell: int = int(counts["fell"])
	var faults: PackedStringArray = PackedStringArray()
	var frames: int = 0
	var started: int = Time.get_ticks_msec()
	while Time.get_ticks_msec() - started < int(WINDOW_SECONDS * 1000.0):
		await process_frame
		frames += 1
		if (overlay.is_open or overlay.opens != opens or paused or not player.is_alive()
				or slice._fallen_countdown != -1.0 or slice._pending_fallen_event != null
				or _log_count("slice restarted") != restarts or emissions.size() != mark or int(counts["fell"]) != fell):
			if faults.size() < 4:
				faults.append("frame %d: overlay open %s (opened %d more), paused %s, alive %s, countdown %.3f, pending %s"
					% [frames, str(overlay.is_open), overlay.opens - opens, str(paused), str(player.is_alive()),
						slice._fallen_countdown, "none" if slice._pending_fallen_event == null else "held"])
	var seconds: float = float(Time.get_ticks_msec() - started) / 1000.0
	var cleaned: bool = false
	if overlay.is_open:
		overlay.close("verification cleanup")
		_cleanups += 1
		cleaned = true
		await _settle(2)
	record["window"] = {"frames": frames, "faults": faults, "seconds": seconds, "cleaned": cleaned, "opens_after": overlay.opens - opens}


## Samples the whole delay until the overlay opens by itself. With `probes`, the room's own modal
## neutralization and one more DamageEvent are applied a few frames in (STAGED).
func _wait_for_overlay(record: Dictionary, probes: bool) -> void:
	var player: PrototypePlayer = slice.player
	var overlay: FirstMvpFallenOverlay = slice.fallen_overlay
	var event: DamageEvent = record["event"]
	var opens: int = overlay.opens
	var opened_mark: int = _opened_pending.size()
	var faults: PackedStringArray = PackedStringArray()
	var samples: int = 0
	var probe: Dictionary = {}
	for frame: int in 600:
		if overlay.is_open:
			break
		if not _delay_frame_ok(record, slice._fallen_countdown):
			faults.append("sample %d" % samples)
		if probes and samples == PROBE_SAMPLE and probe.is_empty():
			probe = _probe_inside_the_delay(record)
		samples += 1
		await process_frame
	record["delay"] = {"samples": samples, "faults": faults, "missed": false, "remaining": -1.0, "longest": 0.0}
	record["probe"] = probe
	var at_open: Array = _opened_pending.slice(opened_mark)
	var focus: Control = overlay.default_focus()
	record["opened"] = {
		"once": overlay.is_open and overlay.opens == opens + 1 and at_open.size() == 1,
		"with_event": at_open.size() == 1 and at_open[0] == event,
		"state": player.action_state_name(), "alive": player.is_alive(), "life": player.life, "paused": paused,
		"countdown": slice._fallen_countdown, "pending_is_event": slice._pending_fallen_event == event,
		"source": overlay.killing_source, "focused": focus != null and root.gui_get_focus_owner() == focus and focus.name == RESTART_CAPTION,
	}


## STAGED, inside one delay: the room's own modal-contract neutralization, then one more of the
## killer's events through the player's own intake.
func _probe_inside_the_delay(record: Dictionary) -> Dictionary:
	var player: PrototypePlayer = slice.player
	var counts: Dictionary = record["counts"]
	var event: DamageEvent = record["event"]
	var events: int = player.damage_taken_events
	var fell: int = int(counts["fell"])
	var took: int = int(counts["took_damage"])
	var remaining: float = slice._fallen_countdown
	slice.neutralize_for_modal(PROBE_REASON)
	var neutral: Dictionary = {
		"state": player.action_state_name(), "alive": player.is_alive(), "life": player.life,
		"countdown_kept": slice._fallen_countdown == remaining and remaining > 0.0, "pending_kept": slice._pending_fallen_event == event,
		"latched": player.awaiting_neutral and player.neutral_reason == PROBE_REASON,
	}
	player.receive_damage(DamageEvent.physical(_use(), record["killer"], player, float(record["record_damage"])))
	var refused: bool = (player.damage_taken_events == events and int(counts["fell"]) == fell and int(counts["took_damage"]) == took
		and player.life == 0.0 and player.last_damage_taken == event and player.action_state == PrototypePlayer.ActionState.FALLEN)
	_note("inside the first genuine death's delay, the room's neutralize_for_modal() called directly and one more DamageEvent offered")
	return {"neutral": neutral, "refused": refused, "remaining": remaining}


## Behind the standing overlay: 30 paused physics frames and 10 idle frames, every one read, then one
## more DamageEvent through the production intake.
func _stand_behind_the_overlay(record: Dictionary) -> void:
	var player: PrototypePlayer = slice.player
	var overlay: FirstMvpFallenOverlay = slice.fallen_overlay
	var counts: Dictionary = record["counts"]
	var event: DamageEvent = record["event"]
	var opens: int = overlay.opens
	var restarts: int = _log_count("slice restarted")
	var faults: PackedStringArray = PackedStringArray()
	for frame: int in 30:
		await physics_frame
		if not _standing_frame_ok(event, opens, restarts):
			faults.append("physics frame %d" % frame)
	for frame: int in 10:
		await process_frame
		if not _standing_frame_ok(event, opens, restarts):
			faults.append("idle frame %d" % frame)
	var events: int = player.damage_taken_events
	var fell: int = int(counts["fell"])
	player.receive_damage(DamageEvent.physical(_use(), record["killer"], player, float(record["record_damage"])))
	var refused: bool = (player.damage_taken_events == events and int(counts["fell"]) == fell and player.life == 0.0
		and player.last_damage_taken == event)
	record["standing"] = {"faults": faults, "refused": refused, "opens": overlay.opens - opens}


func _standing_frame_ok(event: DamageEvent, opens: int, restarts: int) -> bool:
	var player: PrototypePlayer = slice.player
	return (slice.fallen_overlay.is_open and slice.fallen_overlay.opens == opens and paused
		and player.action_state == PrototypePlayer.ActionState.FALLEN and not player.is_alive() and player.life == 0.0
		and slice._fallen_countdown == -1.0 and slice._pending_fallen_event == event and _log_count("slice restarted") == restarts)


## Gate 1D's Restart with the overlay standing, by `method`: Enter on the focused button, one real left
## click through `Input.parse_input_event()`, or F5 — each the overlay's own path, exactly as J2
## drives it. Then the 1.75 s after.
func _restart_with_the_overlay_open(record: Dictionary, method: String) -> void:
	var player: PrototypePlayer = slice.player
	var overlay: FirstMvpFallenOverlay = slice.fallen_overlay
	var button: Button = _named(overlay, RESTART_CAPTION)
	var closes: int = overlay.closes
	var opens: int = overlay.opens
	var restarts: int = _log_count("slice restarted")
	var mark: int = (record["emissions"] as Array).size()
	var click: Dictionary = {}
	match method:
		"confirm":
			_push_key(KEY_ENTER, true)
		"f5":
			_push_key(KEY_F5, true)
		"click":
			click = await _parse_click(overlay, button)
	var reading: Dictionary = _restart_reading(record, "Fallen", restarts, mark)
	reading["method"] = method
	reading["click"] = click
	reading["closed_once"] = not overlay.is_open and overlay.closes == closes + 1 and overlay.opens == opens
	reading["at_entry"] = (_planar_gap(player.global_position, _gate_1d_settled) < 0.05 if method == "click"
		else float(reading["entry_gap"]) < 0.05)
	if method != "click":
		_push_key(KEY_ENTER if method == "confirm" else KEY_F5, false)
	_quiet_after_restart()
	reading["through"] = true
	if method == "click":
		reading["through"] = await _after_close(player.global_position, player.attack.uses_started)
	record["restart"] = reading
	await _window(record)
	reading["settled_gap"] = _planar_gap(player.global_position, slice.broken_watch.entry())
	if method == "confirm":
		_gate_1d_settled = player.global_position
	_disconnect(record)


## One real Hit on a living character, then F5 into the slice's own input handling.
func _restart_a_living_character() -> void:
	var player: PrototypePlayer = slice.player
	var overlay: FirstMvpFallenOverlay = slice.fallen_overlay
	var record: Dictionary = await _strike_player("a living character after one Hit", 1)
	var before: Dictionary = {
		"alive": player.is_alive(), "life": player.life, "countdown": slice._fallen_countdown,
		"pending_null": slice._pending_fallen_event == null, "overlay": overlay.is_open, "hits": (record["trail"] as Array).size(),
	}
	var opens: int = overlay.opens
	var closes: int = overlay.closes
	var restarts: int = _log_count("slice restarted")
	var mark: int = (record["emissions"] as Array).size()
	_push_key(KEY_F5, true)
	var reading: Dictionary = _restart_reading(record, "quick restart", restarts, mark)
	reading["before"] = before
	reading["overlay_untouched"] = not overlay.is_open and overlay.opens == opens and overlay.closes == closes
	_push_key(KEY_F5, false)
	_quiet_after_restart()
	record["restart"] = reading
	await _window(record)
	_disconnect(record)
	_living = record


func _latch_reading() -> Dictionary:
	var drops: Array[Node] = []
	for node: Node in slice.get_node("Actors").get_children():
		if node is FirstMvpItemDrop:
			drops.append(node)
	var active: FirstMvpItemDrop = slice._active_drop
	return {
		"granted": slice._drop_granted, "drops": drops.size(),
		"drop": drops[0].get_instance_id() if drops.size() == 1 else 0,
		"active": active.get_instance_id() if active != null else 0, "name": active.display_name() if active != null else "",
		"weapon": slice.player.weapon.resource_path, "equipped": slice.loadout.equipped_weapon.resource_path,
		"owned": slice.loadout.owned_items.size(), "granted_lines": _log_count("guaranteed drop"),
	}


# --- 6–20. What the play measured -------------------------------------------------------------

func _check_a_real_graveblade_kill_arms_the_normal_delay() -> void:
	print("")
	print("--- 6. Every death: the production Graveblade's own attacks take Life to 0, and on the lethal frame the normal delay is armed with the killing Hit pending")
	var faults: PackedStringArray = PackedStringArray()
	for record: Dictionary in _deaths:
		var lethal: Dictionary = record["lethal"]
		var counts: Dictionary = record["counts"]
		if not (lethal["state"] == "FALLEN" and not bool(lethal["alive"]) and float(lethal["life"]) == 0.0 and not bool(lethal["overlay"])
				and not bool(lethal["paused"]) and bool(lethal["holder_free"]) and int(lethal["acting"]) == 0
				and float(lethal["countdown"]) > 0.0 and float(lethal["countdown"]) <= BrokenWatchSlice.FALLEN_DELAY
				and bool(lethal["pending_is_event"]) and bool(lethal["from_killer"]) and _trail_ok(record)
				and int(counts["fell"]) == 1 and int(counts["took_damage"]) == (record["trail"] as Array).size()
				and int(counts["took_damage"]) == int(record["began"])):
			faults.append("%s: %s" % [record["label"], str(lethal)])
	_expect(_deaths.size() == 7 and faults.is_empty(), "%d deaths; %s" % [_deaths.size(), "; ".join(faults)])
	print("  %d deaths, each to %d of the Graveblade's own attacks: Life %s; on each lethal frame FALLEN, not alive, no overlay, not paused, no permission held, 0 Graveblades acting, the countdown armed at no more than %.2f s and the pending event the killing Hit itself; one took_damage per Hit and one fell"
		% [_deaths.size(), int(_deaths[0]["began"]) if not _deaths.is_empty() else 0, _trail_text(_deaths[0]) if not _deaths.is_empty() else "",
			BrokenWatchSlice.FALLEN_DELAY])
	_done("a_real_graveblade_kill_arms_the_normal_delay")


func _check_the_delay_keeps_the_player_fallen_with_no_overlay() -> void:
	print("")
	print("--- 7. Every sampled frame of every delay, until F5 or until the overlay opened by itself: FALLEN at 0, no overlay, no restart, the countdown running and the killing Hit still pending")
	var faults: PackedStringArray = PackedStringArray()
	var samples: PackedStringArray = PackedStringArray()
	for record: Dictionary in _deaths:
		var delay: Dictionary = record.get("delay", {})
		if delay.is_empty() or bool(delay["missed"]) or int(delay["samples"]) < 1 or not (delay["faults"] as PackedStringArray).is_empty():
			faults.append("%s: %s" % [record["label"], str(delay)])
		samples.append(str(int(delay.get("samples", 0))))
	_expect(_deaths.size() == 7 and faults.is_empty(), "; ".join(faults))
	print("  on every sampled frame of all %d delays: FALLEN at 0 / 500, not paused, no overlay, no restart yet, no permission held, the countdown running and the pending event unchanged"
		% _deaths.size())
	print("  timing: %s frame(s) sampled per delay, in order" % ", ".join(samples))
	_done("the_delay_keeps_the_player_fallen_with_no_overlay")


func _cancel_ok(record: Dictionary) -> bool:
	if not record.has("restart") or not record.has("window") or not record.has("delay"):
		return false
	var restart: Dictionary = record["restart"]
	var window: Dictionary = record["window"]
	var delay: Dictionary = record["delay"]
	var revivals: Array = restart["revivals"]
	return (not bool(delay["missed"]) and (delay["faults"] as PackedStringArray).is_empty() and float(delay["remaining"]) > 0.0
		and bool(restart["restarted_once"]) and float(restart["countdown"]) == -1.0 and bool(restart["pending_null"])
		and bool(restart["alive"]) and bool(restart["full"]) and revivals.size() == 1 and _is_revival(revivals[0] as Dictionary, 500.0)
		and float(restart["entry_gap"]) < 0.05 and bool(restart["enemies"]) and bool(restart["permission"]) and bool(restart["running"])
		and bool(restart["instrumentation"]) and bool(restart["soft_target"]) and bool(restart["loadout"]) and bool(restart["overlay_untouched"])
		and _window_ok(window))


func _window_ok(window: Dictionary) -> bool:
	return ((window["faults"] as PackedStringArray).is_empty() and float(window["seconds"]) >= WINDOW_SECONDS and int(window["frames"]) > 0
		and not bool(window["cleaned"]) and int(window["opens_after"]) == 0)


func _remaining(point: String) -> float:
	var record: Dictionary = _cancelled.get(point, {})
	if not record.has("delay"):
		return -1.0
	return float(record["delay"]["remaining"])


func _cancel_text(point: String) -> String:
	return "F5 %s: one restart_current_slice() (quick restart), one revival (life_changed [500 / 500 IDLE]); the countdown -1.0 and no pending event; Broken Watch's entry, both Graveblades at full Life at their spawns and active, no permission held, instrumentation reset; no Fallen overlay, no second restart and no second revival in the %.2f s after" % [
		POINT_WORDS[point], WINDOW_SECONDS]


func _timing_text(point: String) -> String:
	var record: Dictionary = _cancelled.get(point, {})
	if not record.has("delay"):
		return "timing: not reached"
	var delay: Dictionary = record["delay"]
	var remaining: float = float(delay["remaining"])
	return "timing: F5 with %.4f s of %.2f left (%.1f%% through the delay) after %d sampled frame(s); the longest frame of that delay %.4f s; %d frame(s) and %.2f s watched after" % [
		remaining, BrokenWatchSlice.FALLEN_DELAY, 100.0 * (1.0 - remaining / BrokenWatchSlice.FALLEN_DELAY), int(delay["samples"]),
		float(delay["longest"]), int(record["window"]["frames"]) if record.has("window") else 0,
		float(record["window"]["seconds"]) if record.has("window") else 0.0]


func _check_f5_immediately_after_the_lethal_frame_cancels() -> void:
	print("")
	print("--- 8. F5 on the lethal Hit's own heels, before a single frame of the delay has been sampled past it")
	var record: Dictionary = _cancelled.get("immediate", {})
	_expect(_cancel_ok(record) and int(record["delay"]["samples"]) == 1 and _remaining("immediate") > _remaining("early"),
		"immediate: %s" % str(record.get("restart", {})))
	print("  %s" % _cancel_text("immediate"))
	print("  %s" % _timing_text("immediate"))
	_done("f5_immediately_after_the_lethal_frame_cancels")


func _check_f5_early_in_the_delay_cancels() -> void:
	print("")
	print("--- 9. F5 early in the delay, at the first frame with no more than %.2f s left" % EARLY_REMAINING)
	var record: Dictionary = _cancelled.get("early", {})
	_expect(_cancel_ok(record) and _remaining("early") <= EARLY_REMAINING and _remaining("early") > MIDDLE_REMAINING,
		"early: %s" % str(record.get("restart", {})))
	print("  %s" % _cancel_text("early"))
	print("  %s" % _timing_text("early"))
	_done("f5_early_in_the_delay_cancels")


func _check_f5_at_the_middle_of_the_delay_cancels() -> void:
	print("")
	print("--- 10. F5 at the middle of the delay, at the first frame with no more than %.2f s left" % MIDDLE_REMAINING)
	var record: Dictionary = _cancelled.get("middle", {})
	_expect(_cancel_ok(record) and _remaining("middle") <= MIDDLE_REMAINING and _remaining("middle") > _remaining("late"),
		"middle: %s" % str(record.get("restart", {})))
	print("  %s" % _cancel_text("middle"))
	print("  %s" % _timing_text("middle"))
	_done("f5_at_the_middle_of_the_delay_cancels")


func _check_f5_late_in_the_delay_cancels() -> void:
	print("")
	print("--- 11. F5 late in the delay, at the last frame boundary the harness can be sure precedes the overlay: no more than %.1f of that delay's longest frame left" % LATE_FRAMES)
	var record: Dictionary = _cancelled.get("late", {})
	var longest: float = float(record["delay"]["longest"]) if record.has("delay") else 0.0
	_expect(_cancel_ok(record) and longest > 0.0 and _remaining("late") <= LATE_FRAMES * longest and _remaining("late") > 0.0,
		"late: %s" % str(record.get("restart", {})))
	print("  %s" % _cancel_text("late"))
	print("  pushed at the first frame boundary with no more than %.1f of that delay's longest frame left; the exact time left is on the timing line below"
		% LATE_FRAMES)
	print("  %s" % _timing_text("late"))
	_done("f5_late_in_the_delay_cancels")


func _check_cancellation_comes_before_the_revival() -> void:
	print("")
	print("--- 12. At the revival of every restart — read inside revive_for_testing()'s own life_changed — the countdown is already -1.0 and the pending event already gone")
	var faults: PackedStringArray = PackedStringArray()
	for entry: Dictionary in _restarts:
		var revivals: Array = entry["revivals"]
		if revivals.size() != 1 or float((revivals[0] as Dictionary)["countdown"]) != -1.0 or not bool((revivals[0] as Dictionary)["pending_null"]):
			faults.append("%s: %s" % [entry["label"], str(revivals)])
	_expect(_restarts.size() == 8 and faults.is_empty(), "%d restarts; %s" % [_restarts.size(), "; ".join(faults)])
	print("  at the revival of all %d restarts — the 4 inside the delay, the 3 behind the overlay and the living one — the countdown already read -1.0 and the pending event already null"
		% _restarts.size())
	_done("cancellation_comes_before_the_revival")


func _check_no_stale_event_second_restart_or_second_revival() -> void:
	print("")
	print("--- 13. After each of the four cancellations, for at least %.2f s: no Fallen overlay, no pause, no second restart, revival or fall" % WINDOW_SECONDS)
	var faults: PackedStringArray = PackedStringArray()
	var windows: PackedStringArray = PackedStringArray()
	for point: String in POINTS:
		var record: Dictionary = _cancelled.get(point, {})
		if not record.has("window") or not _window_ok(record["window"]) or int(record["counts"]["fell"]) != 1:
			faults.append("%s: %s" % [point, str(record.get("window", {}))])
		if record.has("window"):
			windows.append("%.2f s" % float(record["window"]["seconds"]))
	_expect(_cancelled.size() == 4 and faults.is_empty() and _cleanups == 0 and slice.fallen_overlay.opens == 3
			and _opened_pending.size() == 3,
		"%s; cleanups %d; the overlay opened %d time(s) in all" % ["; ".join(faults), _cleanups, slice.fallen_overlay.opens])
	print("  4 of 4 cancellations: no Fallen overlay opened, the tree never paused, the character stayed alive, the countdown stayed -1.0 with no pending event, and restart_current_slice(), the revival and the fall each happened once; the harness's cleanup path ran %d times"
		% _cleanups)
	print("  over the whole run the Fallen overlay opened exactly 3 times — once for each genuine death after the cancellations")
	print("  timing: watched %s after each F5" % ", ".join(windows))
	_done("no_stale_event_second_restart_or_second_revival")


func _check_a_later_genuine_death_opens_fallen_once_with_its_new_event() -> void:
	print("")
	print("--- 14. After the four cancellations, a genuine death arms the delay again and opens Fallen exactly once, with its own new killing Hit")
	var cancelled_events: Array = []
	for point: String in POINTS:
		cancelled_events.append((_cancelled.get(point, {}) as Dictionary).get("event", null))
	var faults: PackedStringArray = PackedStringArray()
	for method: String in ["confirm", "click", "f5"]:
		var record: Dictionary = _opened.get(method, {})
		var opened: Dictionary = record.get("opened", {})
		var standing: Dictionary = record.get("standing", {})
		var fresh: bool = record.get("event", null) != null and not cancelled_events.has(record["event"])
		if not (bool(opened.get("once", false)) and bool(opened.get("with_event", false)) and fresh
				and opened["state"] == "FALLEN" and not bool(opened["alive"]) and float(opened["life"]) == 0.0 and bool(opened["paused"])
				and float(opened["countdown"]) == -1.0 and bool(opened["pending_is_event"]) and opened["source"] == KILLING_SOURCE
				and bool(opened["focused"]) and int(standing.get("opens", -1)) == 0 and (standing.get("faults", ["missing"]) as Array).is_empty()):
			faults.append("%s: opened %s, fresh %s, standing %s" % [method, str(opened), str(fresh), str(standing)])
	_expect(_opened.size() == 3 and faults.is_empty() and cancelled_events.size() == 4 and not cancelled_events.has(null), "; ".join(faults))
	print("  after 4 cancellations a genuine death armed the delay again and opened Fallen exactly once, the room's pending event at that moment the new killing Hit — none of the 4 cancelled deaths' events — and \"%s\" on the overlay, its restart button focused"
		% KILLING_SOURCE)
	print("  so did the next two genuine deaths; 30 paused physics and 10 idle frames behind each overlay: still opened once, FALLEN at 0 / 500, the countdown -1.0 and the new Hit pending until the restart")
	_done("a_later_genuine_death_opens_fallen_once_with_its_new_event")


func _open_restart_ok(record: Dictionary) -> bool:
	if not record.has("restart") or not record.has("window"):
		return false
	var restart: Dictionary = record["restart"]
	var revivals: Array = restart["revivals"]
	return (bool(restart["closed_once"]) and bool(restart["restarted_once"]) and bool(restart["alive"]) and bool(restart["full"])
		and revivals.size() == 1 and _is_revival(revivals[0] as Dictionary, 500.0) and bool(restart["at_entry"])
		and bool(restart["enemies"]) and bool(restart["permission"]) and bool(restart["running"]) and bool(restart["instrumentation"])
		and bool(restart["loadout"]) and float(restart["countdown"]) == -1.0 and bool(restart["pending_null"])
		and _window_ok(record["window"]) and bool(record["standing"]["refused"]))


func _open_restart_text() -> String:
	return "the overlay closed once, one restart_current_slice() (Fallen), one revival (life_changed [500 / 500 IDLE]); the countdown -1.0 and no pending event; Broken Watch's entry, both Graveblades at full Life at their spawns and active, no permission held, instrumentation reset; no Fallen overlay in the %.2f s after" % WINDOW_SECONDS


func _check_restart_by_focused_confirm_with_the_overlay_standing() -> void:
	print("")
	print("--- 15. With the overlay standing, Enter on the focused \"Restart Broken Watch\" restarts once, as accepted")
	var record: Dictionary = _opened.get("confirm", {})
	_expect(_open_restart_ok(record), "confirm: %s" % str(record.get("restart", {})))
	print("  %s" % _open_restart_text())
	_done("restart_by_focused_confirm_with_the_overlay_standing")


func _check_restart_by_a_real_left_click_with_the_overlay_standing() -> void:
	print("")
	print("--- 16. With the overlay standing, one real left click on \"Restart Broken Watch\" (J1's route) restarts once; nothing of the click reaches the world")
	var record: Dictionary = _opened.get("click", {})
	var click: Dictionary = (record.get("restart", {}) as Dictionary).get("click", {})
	_expect(_open_restart_ok(record) and bool(click.get("under", false)) and _one_press(click) and bool(record["restart"]["through"]),
		"click: %s" % str(record.get("restart", {})))
	print("  one left press and release through Input.parse_input_event(): one pressed, on that button; %s" % _open_restart_text())
	print("  over the 20 physics frames after it: no destination, no attack, no movement, no modal, and the left button no longer held")
	_done("restart_by_a_real_left_click_with_the_overlay_standing")


func _check_restart_by_f5_with_the_overlay_standing() -> void:
	print("")
	print("--- 17. With the overlay standing, F5 takes the overlay's own quick_restart path, once")
	var record: Dictionary = _opened.get("f5", {})
	_expect(_open_restart_ok(record), "f5: %s" % str(record.get("restart", {})))
	print("  %s" % _open_restart_text())
	_done("restart_by_f5_with_the_overlay_standing")


func _check_restarting_a_living_character_arms_nothing() -> void:
	print("")
	print("--- 18. A living character, hurt but standing, restarted with F5: nothing is armed before, nothing opens after")
	var restart: Dictionary = _living.get("restart", {})
	var before: Dictionary = restart.get("before", {})
	var revivals: Array = restart.get("revivals", [])
	_expect(not bool(_living.get("dead", true)) and bool(before.get("alive", false)) and float(before.get("life", -1.0)) == 375.0
			and int(before.get("hits", 0)) == 1 and float(before.get("countdown", 0.0)) == -1.0 and not bool(before.get("overlay", true))
			and bool(restart.get("restarted_once", false)) and float(restart.get("countdown", 0.0)) == -1.0 and bool(restart.get("pending_null", false))
			and bool(restart.get("alive", false)) and bool(restart.get("full", false)) and revivals.size() == 1
			and _is_revival(revivals[0] as Dictionary, 500.0) and float(restart.get("entry_gap", 9.0)) < 0.05
			and bool(restart.get("enemies", false)) and bool(restart.get("overlay_untouched", false))
			and int(_living["counts"]["fell"]) == 0 and _living.has("window") and _window_ok(_living["window"]),
		"living: before %s; restart %s" % [str(before), str(restart)])
	print("  a living character at 375 / 500 after one of the Graveblade's own Hits, the countdown -1.0: F5 ran one restart_current_slice() (quick restart) and one revival to 500 / 500; the countdown stayed -1.0 with no pending event, nothing fell, and no Fallen overlay opened in the %.2f s after"
		% WINDOW_SECONDS)
	_done("restarting_a_living_character_arms_nothing")


func _check_the_j2_state_contract_holds_while_fallen() -> void:
	print("")
	print("--- 19. J2's contract, unchanged: nothing that neutralizes turns a fallen character IDLE before its restart, and no further damage is accepted while it lies fallen")
	var confirm: Dictionary = _opened.get("confirm", {})
	var probe: Dictionary = confirm.get("probe", {})
	var neutral: Dictionary = probe.get("neutral", {})
	var faults: PackedStringArray = PackedStringArray()
	for record: Dictionary in _deaths:
		## First-MVP Gameplay J10 (D-340), by the project owner's ruling: the restart itself now clears through
		## `clear_movement_intent()`, so each death's last clearing is the restart's own. This contract covers the
		## clearings before it; the restart's own must be exactly that one, with its reason, IDLE at full Life.
		var entries: Array = (record["cleared"] as Array).duplicate()
		var restart_reason: String = "Fallen" if record.has("opened") else "quick restart"
		var own: Dictionary = entries.pop_back() if not entries.is_empty() else {}
		if not (String(own.get("reason", "")) == restart_reason and String(own.get("state", "")) == "IDLE"
				and float(own.get("life", -1.0)) == float(record["max_before"])):
			faults.append("%s: the restart's own clearing was %s" % [record["label"], str(own)])
		var reasons: PackedStringArray = PackedStringArray()
		for entry: Dictionary in entries:
			reasons.append(String(entry["reason"]))
			if entry["state"] != "FALLEN" or float(entry["life"]) != 0.0:
				faults.append("%s: %s saw %s" % [record["label"], entry["reason"], entry["state"]])
		var owed: PackedStringArray = PackedStringArray(["fallen"])
		if record == confirm:
			owed = PackedStringArray(["fallen", PROBE_REASON, "fallen opened"])
		elif record.has("opened"):
			owed = PackedStringArray(["fallen", "fallen opened"])
		if reasons != owed:
			faults.append("%s: cleared %s" % [record["label"], str(reasons)])
	var refused: int = 0
	for method: String in ["confirm", "click", "f5"]:
		if bool(((_opened.get(method, {}) as Dictionary).get("standing", {}) as Dictionary).get("refused", false)):
			refused += 1
	_expect(neutral.get("state", "") == "FALLEN" and not bool(neutral.get("alive", true)) and float(neutral.get("life", -1.0)) == 0.0
			and bool(neutral.get("countdown_kept", false)) and bool(neutral.get("pending_kept", false)) and bool(neutral.get("latched", false))
			and bool(probe.get("refused", false)) and refused == 3 and faults.is_empty() and bool(confirm.get("opened", {}).get("once", false)),
		"probe %s; refused %d of 3; %s" % [str(probe), refused, "; ".join(faults)])
	print("  inside the delay the room's own neutralize_for_modal() left the character FALLEN at 0 / 500 with the countdown still running and the Hit still pending, and a further 125-damage event was refused; the overlay then opened by itself")
	print("  every movement_intent_cleared before a restart saw FALLEN at 0: [fallen] for each cancelled death, [fallen, %s, fallen opened] and [fallen, fallen opened] for the others; behind each of the 3 overlays one more event was refused; each restart then cleared once more itself, with its own reason, IDLE at full Life (J10, D-340)"
		% PROBE_REASON)
	_done("the_j2_state_contract_holds_while_fallen")


func _check_the_guaranteed_drop_latch_is_unchanged() -> void:
	print("")
	print("--- 20. The guaranteed drop's latch is exactly as accepted: granted once, untouched by every restart, and a later kill grants nothing")
	var same: bool = _latch_start == _latch_end and _latch_end == _latch_after_kill
	_expect(same and bool(_latch_start.get("granted", false)) and int(_latch_start.get("drops", 0)) == 1
			and int(_latch_start["drop"]) == int(_latch_start["active"]) and int(_latch_start["granted_lines"]) == 1
			and String(_latch_start["weapon"]) == STARTING_SWORD and String(_latch_start["equipped"]) == STARTING_SWORD
			and int(_second_kill.get("refused", 0)) == 1 and int(_second_kill.get("granted", -1)) == 0,
		"start %s; after the restarts %s; after one more kill %s; %s" % [str(_latch_start), str(_latch_end), str(_latch_after_kill), str(_second_kill)])
	print("  the guaranteed drop was granted once, before the first death; after 8 restarts the latch is still set, the same %s still lies on the ground as the only drop, the Starting Sword is still equipped, and one more kill of the first Graveblade was refused ('reward refused') with no second drop"
		% String(_latch_start.get("name", "")))
	_done("the_guaranteed_drop_latch_is_unchanged")


func _check_every_check_ran() -> void:
	var missing: PackedStringArray = PackedStringArray()
	for name: String in OWED_CHECKS:
		if not _reached.has(name):
			missing.append(name)
	var extra: PackedStringArray = PackedStringArray()
	for name: Variant in _reached.keys():
		if not OWED_CHECKS.has(String(name)):
			extra.append(String(name))
	_expect(missing.is_empty() and extra.is_empty(),
		"owed checks that never reached their last line: %s; unexpected: %s" % [", ".join(missing), ", ".join(extra)])
	var completed: PackedStringArray = PackedStringArray()
	for name: String in OWED_CHECKS:
		if _reached.has(name):
			completed.append(name)
	print("")
	print("  %d of %d owed checks completed" % [OWED_CHECKS.size() - missing.size(), OWED_CHECKS.size()])
	print("  completed: %s" % ", ".join(completed))


# --- Readings ---------------------------------------------------------------------------------

func _ai_count() -> int:
	var acting: int = 0
	for enemy: PrototypeGraveblade in slice.graveblades:
		if is_instance_valid(enemy) and enemy.ai_enabled:
			acting += 1
	return acting


func _trail_ok(record: Dictionary) -> bool:
	var trail: Array = record["trail"]
	var life: float = float(record["life_before"])
	var damage: float = float(record["record_damage"])
	if trail.is_empty():
		return false
	for value: Variant in trail:
		life = maxf(life - damage, 0.0)
		if float(value) != life:
			return false
	return life == 0.0


func _trail_text(record: Dictionary) -> String:
	var parts: PackedStringArray = PackedStringArray([_n(float(record["life_before"]))])
	for value: Variant in record["trail"]:
		parts.append(_n(float(value)))
	return " -> ".join(parts)


func _is_revival(said: Dictionary, maximum: float) -> bool:
	return (float(said["life"]) == maximum and float(said["max"]) == maximum and said["state"] == "IDLE"
		and bool(said["awaiting"]) and said["reason"] == "encounter reset")


func _disconnect(record: Dictionary) -> void:
	var player: PrototypePlayer = slice.player
	var listeners: Array = record.get("listeners", [])
	var signals: Array[Signal] = [player.life_changed, player.took_damage, player.fell, player.movement_intent_cleared]
	for index: int in listeners.size():
		var callable: Callable = listeners[index]
		if signals[index].is_connected(callable):
			signals[index].disconnect(callable)


## After a click that closed the overlay: the world runs again and nothing of that click reaches it —
## no destination, no attack, no movement, no modal, and the button no longer held.
func _after_close(at: Vector3, uses: int) -> bool:
	await _settle(20)
	await _await_process_frames(5)
	var player: PrototypePlayer = slice.player
	return (not paused and not player.has_destination and player.attack.uses_started == uses
		and player.global_position.distance_to(at) < 0.05 and not slice.fallen_overlay.is_open and not slice.item_comparison.is_open
		and not Input.is_action_pressed(&"move_point"))


# --- The world --------------------------------------------------------------------------------

## Changes to the accepted scene exactly as it ships and waits until it stands.
func _load(path: String) -> Node:
	var changed: Error = change_scene_to_packed(load(path) as PackedScene)
	for frame: int in 60:
		await process_frame
		if current_scene != null and current_scene.scene_file_path == path:
			break
	if changed != OK or current_scene == null or current_scene.scene_file_path != path:
		_failures.append("%s did not load" % path.get_file())
		return null
	return current_scene


func _await_navigation() -> void:
	for frame: int in 900:
		if NavigationServer3D.map_get_iteration_id(slice.navigation_map()) > 0:
			break
		await physics_frame
	await _settle(10)


func _forward() -> Vector3:
	var facing: Vector3 = slice.route_forward()
	facing.y = 0.0
	return facing.normalized()


func _stand_facing(at: Vector3, facing: Vector3) -> void:
	slice.player.global_position = Vector3(at.x, 0.0, at.z)
	slice.player.velocity = Vector3.ZERO
	slice.player.clear_movement_intent("verification", false)
	slice.camera_rig.focus = slice.player.global_position
	slice.player.face_instantly(facing)


func _until_neutral() -> void:
	for frame: int in 60:
		if not slice.player.awaiting_neutral:
			return
		await physics_frame


func _kill(enemy: PrototypeGraveblade) -> void:
	enemy.receive_damage(DamageEvent.physical(_use(), slice.player, enemy, enemy.life + 1000.0))
	_expect_quiet(not enemy.is_alive(), "%s did not die from a lethal hit" % enemy.name)


func _note(text: String) -> void:
	if not _staged.has(text):
		_staged.append(text)


func _log_count(token: String) -> int:
	var count: int = 0
	for line: String in slice.log_lines:
		if line.contains(token):
			count += 1
	return count


func _last_log(token: String) -> String:
	for index: int in range(slice.log_lines.size() - 1, -1, -1):
		if slice.log_lines[index].contains(token):
			return slice.log_lines[index]
	return ""


func _named(panel: Control, node_name: String) -> Button:
	for node: Node in panel.find_children(node_name, "Button", true, false):
		return node as Button
	_failures.append("no button named %s in %s" % [node_name, panel.name])
	return null


func _planar_gap(a: Vector3, b: Vector3) -> float:
	return Vector2(a.x - b.x, a.z - b.z).length()


func _n(value: float) -> String:
	if is_equal_approx(value, roundf(value)):
		return "%d" % roundi(value)
	return "%.2f" % value


func _use() -> int:
	_next_use_id += 1
	return _next_use_id


# --- The pointer and the keyboard -------------------------------------------------------------

## Window coordinates for a point in the viewport's own space: the stretch transform, applied the way
## the operating system's pointer arrives through it.
func _window_point(local: Vector2) -> Vector2:
	return root.get_final_transform() * local


func _motion_event(local: Vector2) -> InputEventMouseMotion:
	var motion: InputEventMouseMotion = InputEventMouseMotion.new()
	var at: Vector2 = _window_point(local)
	motion.position = at
	motion.global_position = at
	return motion


func _button_event(local: Vector2, index: MouseButton, pressed: bool) -> InputEventMouseButton:
	var click: InputEventMouseButton = InputEventMouseButton.new()
	var at: Vector2 = _window_point(local)
	click.button_index = index
	click.pressed = pressed
	click.position = at
	click.global_position = at
	return click


## One real left click on `button` through `Input.parse_input_event()`, the path the operating
## system's own events take; it is delivered at the next frame's input flush.
func _parse_click(panel: Control, button: Button) -> Dictionary:
	if button == null:
		return {}
	_watch(panel)
	var local: Vector2 = button.get_global_rect().get_center()
	Input.parse_input_event(_motion_event(local))
	Input.parse_input_event(_button_event(local, MOUSE_BUTTON_LEFT, true))
	Input.parse_input_event(_button_event(local, MOUSE_BUTTON_LEFT, false))
	await _await_process_frames(2)
	var own: int = int(_fired.get(button.get_instance_id(), 0))
	var result: Dictionary = {"under": own == 1, "fired": own, "others": _total_fired() - own}
	_unwatch()
	return result


## Counts `pressed` on every button in `panel`. The production connections stay exactly as they are;
## this only listens beside them.
func _watch(panel: Control) -> void:
	_unwatch()
	_fired.clear()
	for node: Node in panel.find_children("*", "Button", true, false):
		var button: Button = node as Button
		var id: int = button.get_instance_id()
		_fired[id] = 0
		var counter: Callable = func() -> void: _fired[id] = int(_fired[id]) + 1
		button.pressed.connect(counter)
		_watched.append({"button": button, "callable": counter})


func _unwatch() -> void:
	for entry: Dictionary in _watched:
		var button: Button = entry["button"]
		var counter: Callable = entry["callable"]
		if is_instance_valid(button) and button.pressed.is_connected(counter):
			button.pressed.disconnect(counter)
	_watched.clear()


func _total_fired() -> int:
	var total: int = 0
	for id: Variant in _fired.keys():
		total += int(_fired[id])
	return total


func _one_press(result: Dictionary) -> bool:
	return int(result.get("fired", 0)) == 1 and int(result.get("others", -1)) == 0


func _push_key(keycode: Key, pressed: bool) -> void:
	var event: InputEventKey = InputEventKey.new()
	event.keycode = keycode
	event.physical_keycode = keycode
	event.pressed = pressed
	root.push_input(event)


func _settle(frames: int) -> void:
	for frame: int in frames:
		await physics_frame


func _await_process_frames(frames: int) -> void:
	for frame: int in frames:
		await process_frame


# --- Source readings --------------------------------------------------------------------------

func _files_under(root_path: String, extensions: Array[String]) -> PackedStringArray:
	var out: PackedStringArray = PackedStringArray()
	var dir: DirAccess = DirAccess.open(root_path)
	if dir == null:
		return out
	dir.list_dir_begin()
	var entry: String = dir.get_next()
	for guard: int in 100000:
		if entry.is_empty():
			break
		if entry != "." and entry != "..":
			var full: String = root_path.path_join(entry)
			if dir.current_is_dir():
				out.append_array(_files_under(full, extensions))
			else:
				for extension: String in extensions:
					if entry.ends_with(extension):
						out.append(full)
		entry = dir.get_next()
	dir.list_dir_end()
	return out


func _declared_functions(source: String) -> PackedStringArray:
	var names: PackedStringArray = PackedStringArray()
	var pattern: RegEx = RegEx.create_from_string("(?m)^(?:static )?func ([A-Za-z0-9_]+)\\(")
	for found: RegExMatch in pattern.search_all(source):
		names.append(found.get_string(1))
	return names


## The indented body of top-level function `name`, up to the next unindented line.
func _function_body(source: String, name: String) -> String:
	var body: PackedStringArray = PackedStringArray()
	var inside: bool = false
	for line: String in source.split("\n"):
		if line.begins_with("func %s(" % name) or line.begins_with("static func %s(" % name):
			inside = true
			continue
		if inside:
			if (not line.is_empty() and not line.begins_with("\t") and not line.begins_with(" ")
					and not line.begins_with(")")):
				break
			body.append(line)
	return "\n".join(body)


## Code with every comment line removed and every string literal emptied.
func _bare(source: String) -> String:
	var kept: PackedStringArray = PackedStringArray()
	for line: String in source.split("\n"):
		if line.strip_edges().begins_with("#"):
			continue
		kept.append(line)
	var strings: RegEx = RegEx.create_from_string("\"([^\"\\\\]|\\\\.)*\"")
	return strings.sub("\n".join(kept), "\"\"", true)


## The non-empty code lines of `body`, each stripped of its indentation.
func _code_lines(body: String) -> PackedStringArray:
	var lines: PackedStringArray = PackedStringArray()
	for line: String in body.split("\n"):
		var stripped: String = line.strip_edges()
		if stripped.is_empty() or stripped.begins_with("#"):
			continue
		lines.append(stripped)
	return lines


func _expect(condition: bool, failure_message: String) -> void:
	_checks += 1
	if not condition:
		_failures.append(failure_message)


## Records a failure without adding to the pinned count, inside helpers whose length is incidental.
func _expect_quiet(condition: bool, failure_message: String) -> void:
	if not condition:
		_failures.append(failure_message)


func _done(check_name: String) -> void:
	_reached[check_name] = true
