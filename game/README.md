# Riftwrought — Godot Project (`game/`)

This project contains the completed Prototype Zero laboratory, the separately
bounded, completed first-MVP Gate 1A Scale Calibration Hall, Gate 1B's two closed
exterior review instruments, **the first CANONICAL first-MVP environment:
Riftfall Landing** (D-208/D-209, its Greybox V2 + Visual Review foundation
ACCEPTED under D-216), the first canonical GAMEPLAY — **Gate 1D, Broken Watch
Combat & Loot Slice**, CLOSED by project-owner acceptance under D-218 — and,
since D-219, **the first canonical CHARACTER: Gate 1E, the integrated canonical
opening**, delivered and open for the project owner's playtest.

The completed Prototype Zero brief is
`../design/PROTOTYPE_ZERO_IMPLEMENTATION_SPECIFICATION.md`. The completed Gate 1A
brief is
`../design/FIRST_MVP_GATE_1A_SCALE_CALIBRATION_HALL_SPECIFICATION.md`.
The delivered Gate 1C brief is
`../design/FIRST_MVP_GATE_1C_RIFTFALL_LANDING_IMPLEMENTATION_SPECIFICATION.md`,
and its delivery record is
`../docs/testing/FIRST_MVP_GATE_1C_RIFTFALL_LANDING_REPORT.md`.
The delivered Gate 1D brief is
`../design/FIRST_MVP_GATE_1D_BROKEN_WATCH_COMBAT_AND_LOOT_SLICE_SPECIFICATION.md`,
and its delivery record is
`../docs/testing/FIRST_MVP_GATE_1D_BROKEN_WATCH_REPORT.md`.
The delivered Gate 1E brief is
`../design/FIRST_MVP_GATE_1E_NEXUS_THRESHOLD_AND_THE_NEXUS_ANSWERS_SPECIFICATION.md`,
and its delivery record is
`../docs/testing/FIRST_MVP_GATE_1E_NEXUS_THRESHOLD_REPORT.md`.
The design canon lives above this folder and is not duplicated here.

## Current state

**Gate 1C is DELIVERED and OPEN.** Riftfall Landing — the safe exterior opening of
The Severed Threshold, and the first canonical first-MVP environment — is built at
`scenes/first_mvp/severed_threshold/riftfall_landing.tscn`, with a separate
developer review wrapper beside it at `riftfall_landing_review.tscn`. Only the
project owner can close it, after playing it with mouse and controller.
**D-216 separately accepted the Greybox V2 + Visual Review pass (rebuilt route,
Visual Review dressing and lighting) as the development-ready placeholder
foundation** — the flat ground, greybox-like structural massing, and
rectangular Rift-effect presentation that remain are recorded as deferred
future polish, not blockers.

**It is the first thing under `game/` that is meant to survive.** Everything
before it — the Prototype Zero laboratory, the Gate 1A hall, both Gate 1B scenes —
is a temporary instrument retained for regression. Riftfall Landing is canonical
content: it owns environment, navigation, five spatial sockets and one authored
visual event, and it deliberately owns no player, camera, marker or interface, so
a real character can later stand in it without inheriting a locomotion-only test
body.

**Gate 1D — Broken Watch Combat & Loot Slice — is DELIVERED under D-217 and
CLOSED under D-218 by project-owner acceptance.** It is the first canonical
GAMEPLAY: a fixed authored combat space
reached beyond Riftfall Landing's own accepted foundation, built at
`scenes/first_mvp/severed_threshold/broken_watch_slice.tscn`
(`BrokenWatchSlice`, the composition/wiring root) plus
`scripts/first_mvp/severed_threshold/broken_watch_layout.gd`
(`BrokenWatchLayout`, five plain rooms, ~1,224 m² / ~2.09 CF). It reuses the
proven Prototype Zero combat kernel — `PrototypePlayer`, `PrototypeGraveblade`
(x2, sharing the unedited `graveblade.tres`), `QuickStrikeAction`,
`AttackCoordinator`, `TargetAcquisition` — completely unmodified, wired by
composition exactly as `prototype_zero.gd` already does. Production per-use
mouse targeting (D-193) replaces Prototype Zero's laboratory instrumentation;
controller D-178 soft targeting is reused unmodified. `PlayerLoadout`
(`scripts/items/player_loadout.gd`) and `FirstMvpItemDrop`
(`scripts/items/first_mvp_item_drop.gd`) are the truthful pickup/compare/equip
flow Gate E's fake no-inventory shortcut never had; `FirstMvpModal`,
`FirstMvpItemComparison`, `FirstMvpFallenOverlay`, `FirstMvpCombatHud`
(`scripts/ui/`) are fresh, Gate-1D-owned reuses of Gate E/F's proven UI
patterns. Only the project owner can close it, after playing it with mouse and
controller. **It does not build the Nexus Threshold, the Rift Nexus, Mara, the
Passive Web, Rift Shards, Rift Echo, Augments, the Forge, or the wider Severed
Threshold route** — those remain unauthorized and unstarted. Crossing
`ExitToNexusThreshold` loads nothing, saves nothing and opens nothing; it is
logged as a developer measurement, exactly as Riftfall Landing's own exit
socket is.

**The Riftwrought Zone Composer (Phase 1, D-210) is CLOSED under D-212**, after
the owner used it, built a zone with it, and accepted it — *"All works fine."* It
was corrected under D-211 after their first playtest. It is an EDITOR tool at
`addons/riftwrought_zone_composer/` — a dock for composing a zone by clicking the
ground, written for someone with good visual judgement and little Godot
level-design experience. It ships no gameplay, no scene, no asset, no InputMap
action and no runtime code: zones it makes are ordinary Godot scenes that open and
run with the plugin disabled. `project.godot` gained exactly one editor-only
`[editor_plugins]` section and nothing else — **D-211 did not edit it at all**.
Riftfall Landing is untouched, and so is the zone the owner composed with the tool
at `scenes/first_mvp/zone_composer_practice.tscn`, which is fingerprinted around
every verification run.

**The owner's playtest found placement, rotation, snapping and saving all working,
and one defect: the three story markers were invisible.** D-211 gives Player Start,
Way Out and Look At This — and the developer test spawn — a persistent
**editor-only** symbol with a facing arrow, distinct by shape as well as colour:
a green flag, a gold doorway, a violet eye, and a small grey dashed ring. They are
drawn by an `EditorNode3DGizmoPlugin`, so the geometry is never packed into a
`.tscn`, never instanced at run time and never present in an exported build — **a
zone's saved format did not change at all**, and the markers the owner had already
placed light up with no edit to their file. Rotation-aware wall endpoint snapping
is recorded as **Phase 2 feedback** and no snapping behaviour was changed at any
point — the accepted workaround is Off / 0.25 m. See
`addons/riftwrought_zone_composer/README.md` for the five-minute walkthrough,
`docs/testing/ZONE_COMPOSER_PHASE_1_REPORT.md` §18 for the correction record and
§19 for the acceptance. **Closing Phase 1 authorizes nothing else: Phase 2 is not
begun.**

**THE PALETTE WAS WIDENED UNDER D-215, AND THAT IS THE ONLY THING THAT CHANGED.**
The project owner approved all 47 models the D-214 catalogue shortlisted, **for
availability only — not for use in Riftfall Landing or any other zone**. The
palette is now **66 models plus 3 marker points = 69 pieces** (Ground 11, Roads 9,
Architecture 16, Boundaries 13, Props 16, Story Markers 4), each drawer pinned at
an exact count.

**The ids were rebuilt first, because a KayKit filename is not unique across
packs**: `pillar` exists in both the Dungeon and Halloween packs and the two models
genuinely differ, and D-214's own tally reported 48 models instead of 47 for
exactly that reason. Every piece now answers to `<pack>:<model>` —
`dungeon:wall_half`, `graveyard:debris` — **derived from the path the accepted
record already carries, never typed**, which is how the 19 Gate 1C payloads gained
ids without editing the Gate 1C record. **No id can reach a saved scene**: a placed
node has always been named from the piece's plain-language display name, so zones
built before D-215 open unchanged and the owner's practice zone is byte-identical.

**The palette now reads TWO accepted records**, because there are two questions:
the Gate 1C payload allowlist answers *what does Riftfall Landing use*, and
`scripts/environment/approved_environment_palette.gd` answers *what has the owner
approved an author to reach for*. The addon still owns neither and is still proved
against their union in both directions. **94 files were extracted** — 47 `.gltf`
and their 47 `.bin` sidecars, all byte-identical to their archives — with **no
texture, no licence and no source note added**, because all three were already
here. **The inventory moved 91 → 185 and Gate 1B 654 → 678**; the Zone Composer
runner moved **293 → 324** headless checks, with in-editor 79 and reopen 7
unchanged. **Sixteen pieces were reviewed at a 2 m snap and arrive at 1 m**,
because no accepted snap step was added — that is recorded as owner feedback, not
solved. See `docs/testing/ZONE_COMPOSER_PHASE_1_REPORT.md` §20.

**PROTOTYPE ZERO IS COMPLETE.** Gates A–F are closed by project-owner acceptance
and Gate G — the exit review — is delivered as
`../docs/testing/PROTOTYPE_ZERO_TEST_REPORT.md` under D-194. **First-MVP Gate 1A
was authorized under D-195, delivered under D-196, and CLOSED by the project
owner's mouse-and-controller acceptance under D-197.** It is a separate temporary
developer scene at `scenes/first_mvp/calibration/scale_calibration_hall.tscn`.
**First-MVP Gate 1B — the isolated Exterior Asset Compatibility Spike authorized
by D-198 — was delivered under D-199 and is CLOSED under D-206**, at
`scenes/first_mvp/visual/exterior_asset_compatibility_spike.tscn`. The canonical
Severed Threshold route and every contained gameplay system remain unstarted and
unauthorized. **The Gate 1A verification-integrity repair D-200 authorized is
DELIVERED under D-201: Gate 1A is 284 checks, measured 278 + 6, with zero script
errors and no gameplay, visual, asset, scene, `.tres`, InputMap, entrypoint, or
accepted-value change.**

**The Exterior Cohesion Comparison D-202 authorized is DELIVERED under D-203**, at
`scenes/first_mvp/visual/exterior_cohesion_comparison.tscn`, and is **CLOSED under
D-206**. It is a temporary Gate 1B instrument and does not authorize Riftfall
Landing implementation. Unlike the first spike it is **ONE composed route slice** — open arrival,
broken approach, threshold silhouette — with bounded candidate families switched
inside it: **F4** terrain (existing flat baseline ↔ Kenney Nature topology),
**F5** architecture (KayKit baseline → Quaternius Modular Ruins → Kenney Fantasy
Town), **F7** a three-piece Kenney Graveyard dressing layer. Its manifest is
exactly 21 CC0 models, four verbatim archive licences, two colour atlases, and two
source maps, taking game-side third-party files from **62 to 91** while every
unlisted candidate stays outside the game.
`tests/gate_1b_exterior_cohesion_smoke.sh` passes at **613 checks** over the
unchanged inherited ladder — **Gate 1B 654, Gate 1A 284, Gate F
1008, Gate E 713, Gate D 230, Gate C 209, Gate B 106, Gate A pass**. See
`../docs/testing/FIRST_MVP_GATE_1B_EXTERIOR_COHESION_COMPARISON_REPORT.md`.

**D-204's narrow correction is DELIVERED under D-205.** The Fantasy Town and
Graveyard `Models/GLB format/Textures/colormap.png` dependencies are extracted to
their family `Textures/` directories — **11,143 and 10,965 bytes**, both
byte-identical to their in-archive originals in the engine and in the shell, both
512 × 512 RGBA — taking the third-party inventory **89 → 91** and the cohesion
verification **597 → 613** by the arithmetic in
`../docs/testing/FIRST_MVP_GATE_1B_EXTERIOR_COHESION_COMPARISON_REPORT.md` §15.5.
**Measured: 9 missing-atlas import errors before, 0 after**, and all nine models
resolve their own kit's atlas — six Fantasy Town, three Graveyard, asserted
separately. No scene, transform, route, navigation, lighting, treatment value,
treatment rule, toggle, input, or gameplay changed, and no family was classified
by that correction — the classification came later, under D-206, with both 2025
Kenney kits judged on colour as well as form.

**BOTH Gate 1B review instruments are CLOSED under D-206 (2026-09-02).** The project
owner played the cohesion comparison and classified every candidate family. The
accepted first-MVP exterior combination, in this project's own controls, is **F4
topology off** (the existing flat, project-authored baseline), **F5 architecture on
KayKit baseline**, **F7 Kenney Graveyard dressing on** and used sparingly as damage,
debris, and historical dressing rather than as a cemetery theme, **F1 candidate**
lighting, and **F2 candidate** materials at **saturation × 0.42, value × 0.62, cool
tint (0.88, 0.90, 0.97)** — those three numbers now the accepted first-MVP direction
rather than a proposal. **Rejected on style, not on a defect:** Kenney Nature
topology, Quaternius Modular Ruins for foreground architecture, Kenney Fantasy Town
for a palette judged too bright with its colour restored, and k0rveen from the
first-MVP visual vocabulary entirely. **Retained:** KayKit Forest Nature, the
selected KayKit Halloween pieces, and the registered KayKit Dungeon family, with
Kenney Graveyard the only supplemental family adopted anywhere. **No terrain family
was adopted, and that is an answer** — Riftfall Landing's ground and topology are
project-authored geometry dressed with the retained families.

**Three things about that closure matter to anyone working in `game/`.** **(1)
Rejection is NOT removal.** No file was deleted, both scenes stay directly runnable
as delivered regression instruments, and D-206 moved nothing: the inventory was
still **91** and every count unchanged — **cohesion 613, Gate 1B 654, Gate 1A 284,
Gate F 1008, Gate E 713, Gate D 230, Gate C 209, Gate B 106, Gate A pass**. (The
inventory is **187** and Gate 1B **678** today; the inventory moved under D-215,
which extracted 94 further KayKit files, and again under D-216, which registered
2 LeLu Noise Pack textures for the accepted Riftfall Landing Greybox V2 + Visual
Review dressing pass. Gate 1B's own count has moved under nothing since D-215.)
Removing a rejected
family would still move that inventory and both Gate 1B counts and needs its own
authorization. **(2) The k0rveen CC BY 4.0 obligation is unchanged.** The five
meshes are still here, the spike still draws them behind **F4**, and the credit is
still asserted in the source note, in `exterior_asset_catalogue.gd`, in
`assets/ASSET_REGISTER.md`, and on screen. The obligation ends when the meshes
leave, not when the family is rejected. **(3) The accepted treatment numbers were
NOT migrated into production code.** They still live only inside
`ExteriorReviewTreatment`; carrying them into whatever Riftfall Landing becomes is a
later implementation authorization, not part of this closure. D-206 changed
documentation only and nothing under `game/` outside this file.

**The single-sided treatment behaviour is ACCEPTED at the approved camera and no
second shader variant is to be created now**, which closes the judgement D-205
opened. The Fantasy Town rejection removes six of the nine affected models from
first-MVP consideration; of the three accepted Graveyard pieces, `debris` (240
triangles) and `stone-wall-damaged` (144) are closed solids with **0 boundary
edges** for which `cull_back` is a visual no-op, so only `stone-wall-column` — 8
boundary edges at **y = 0.750**, its cap, against its own 0.850 m height — can show
anything at all.

**Riftfall Landing paper design completed under D-207 and is IMPLEMENTED under
D-208** — see `## Current state` above and
`../docs/testing/FIRST_MVP_GATE_1C_RIFTFALL_LANDING_REPORT.md`. **The wider
Severed Threshold route, Broken Watch, the Nexus Threshold, combat, Mara, story,
rewards, progression, save integration, and procedural generation remain
unauthorized and unstarted.** Nothing here may be used to start any of them.

**One consequence of that correction the owner knew before judging, and accepted
under D-206.** All
nine of those pieces are double-sided in their imported materials, and the
candidate treatment routes a **textured** surface through a runtime shader that
renders `cull_back`. They are therefore **double-sided under F2 source materials
and single-sided under F2 candidate treatment**. The treatment rule was not
changed — D-204 forbids it — the imported materials are proved untouched, and the
condition is drawn on the comparison's own overlay. **D-206 accepts this behaviour
for the first MVP at the approved camera and forbids a second shader variant for
now.**

**The route is project-authored and the candidates are dressed into it.** Every
walkable surface, boundary, blocked footprint, and navigation carve belongs to
authored geometry that is identical in all twelve mode combinations; a family
supplies meshes only. Measured across all twelve: an identical collision skeleton,
**499.1850 m²** walkable, **124 polygons**, a **43.0000 m** resolved path, a
**6.000 m** threshold gap, and **exactly one navigation bake in the whole
session** — because no review toggle touches a collision shape. That is §7's "no
candidate may change navigation merely because a visual mode was selected" made
structural rather than promised.

**Three measured D-202 findings worth carrying.** **(1) The module ladder is 4 : 2/4 : 1.**
KayKit Dungeon and Halloween are a 4.000 m module; Quaternius `Wall_ArchRound_Broken`
measures 3.993 × 3.985 m — the same module to within 7 mm — and `Wall_Broken` is
exactly half of it; all three Kenney kits are **1.000 m**, and Kenney Nature's own
`tree_default` is 1.708 m against the Knight's 1.80 m. Nothing is rescaled to hide
that: where a 1 m kit fills a 4 m role it TILES, which is why the same eight
stations take 13 meshes in KayKit, 12 in Quaternius, and **71** in Kenney Fantasy
Town. **(2) The two 2025 Kenney kits are NOT self-contained.** Every Fantasy Town
and Graveyard GLB declares an external `Textures/colormap.png` that the D-202
manifest did not include, so all **nine** imported with no albedo texture. The
manifest was not widened at the time — the condition was asserted at exactly nine
models, stated on screen, and recorded with both atlases' paths and hashes in
`assets/third_party/kenney/SOURCE_AND_LICENSE.md`, with the exact remedy named.
**D-204 authorized that remedy and D-205 delivered it, so their colour WAS judged —
and D-206's Fantasy Town rejection names its authored palette as one of its two
reasons.** The lesson survives the fix: **a missing dependency is cached as
an outcome, not as a pending question** — Godot recorded no dependency edge for
those nine models, so dropping the atlases in and re-running `--import` would have
imported the textures and left every model exactly as untextured as before.
**(3) All six Kenney Nature models import fully METALLIC** (metallic 1.0), which
under Forward+ leaves a rough metal with no diffuse response — dark under source
materials and correct under the candidate treatment, which measures 0 of 6
metallic. That is "is a material override necessary" answered by measurement.

**Gate 1B — Exterior Asset Compatibility Spike: delivered under D-199, CLOSED under D-206.**
A temporary developer review scene, directly runnable, separate from both the
Prototype App and the Gate 1A hall. **It is NOT Riftfall Landing.** It answers one
question — can the registered KayKit Forest Nature and Halloween Bits candidates
form a coherent dark exterior around the real Knight and Dungeon Pack, and can
k0rveen fill terrain and background gaps without becoming a competing foreground
style — in this project's own camera, scale, light, and material pipeline. It
holds a neutral source lineup of all thirteen KayKit candidates, a hybrid exterior
court around the Knight with a registered Dungeon wall run as the transition
reference, and the five k0rveen supplemental candidates — which D-206 rejected,
without removing them.
`tests/gate_1b_exterior_asset_spike_smoke.sh` passes at **678 Gate 1B checks** — 654
through D-214, plus the 24 the D-215 palette expansion added one per new
Forest/Halloween file — and
runs the whole locked chain first — **Gate 1A 284, Gate F 1008, Gate E 713, Gate
D 230, Gate C 209, Gate B 106, all unchanged** (Gate 1A was 278 at D-199 delivery;
the D-201 repair below moved it, and nothing else did). **35 files were extracted, exactly
the authorized manifest, and every payload is proved byte-identical to its
in-archive original on every run.** The spike writes nothing to disk, adds no
audio, declares no InputMap action, and changes no accepted value. See
`../docs/testing/FIRST_MVP_GATE_1B_EXTERIOR_ASSET_COMPATIBILITY_SPIKE_REPORT.md`.

**The one non-CC0 family in this project, and D-206's rejection does not end its
obligation.** k0rveen's LowPoly Environment Pack is
**CC BY 4.0**, and its archive contains no licence, readme, creator name, or source
URL at all. `assets/third_party/k0rveen/SOURCE_AND_LICENSE.md` is its game-side
record, the durable provenance note travels beside the meshes, and the required
credit — *"LowPoly Environment Pack by k0rveen, licensed under CC BY 4.0."* — is a
constant in the code and is drawn on screen wherever a k0rveen mesh can be seen.
If any of these meshes ships, the attribution ships with it.

**Gate 1A — Scale Calibration Hall: delivered under D-196 and CLOSED under D-197 (2026-09-01).**
A temporary developer-only scene, directly runnable, that does not replace the
Prototype App. Its clear usable floor **measures 50.00 × 30.00 m — 62.5 P ×
37.5 P, 1500 m², 2.56 CF**; its four gates measure **3.200 / 4.800 / 8.000 /
11.200 m**; its two lanes **11.200 m and 17.600 m**; its ranged marks **5.0000 /
10.0000 / 15.0000 m**. Every one is read off the built collision boxes and nodes,
not repeated from the target. `tests/gate_1a_scale_hall_smoke.sh` passes **284
checks** — 278 at D-196 delivery plus the six the D-201 repair unskipped — and
runs the whole locked Prototype Zero chain first — **Gate F 1008,
Gate E 713, Gate D 230, Gate C 209, Gate B 106, all unchanged**. **No Prototype
Zero absence assertion was moved and no locked count changed**; the two hall-only
developer toggles are read as physical keys precisely so that declaring input
actions could not move three of those counts. Three components were **extracted**
so the project has one click-to-move and one controller-locomotion implementation
rather than two: `scripts/movement/prototype_locomotion.gd`,
`prototype_ground_pointer.gd`, and `prototype_mouse_hold.gd`. **No asset was
downloaded or added**, and the hall is silent and writes nothing to disk. See
`../docs/testing/FIRST_MVP_GATE_1A_SCALE_CALIBRATION_HALL_REPORT.md`.

**Gate 1A verification-integrity repair — authorized D-200, delivered D-201.**
The Gate 1B spike found that `scripts/first_mvp/calibration/gate_1a_verification.gd`'s
`_check_prototype_zero_is_untouched()` re-read two properties that do not exist —
`release_reach` for `reach`, and `preferred_distance` for
`preferred_attack_distance`. `Resource.get()` answers `null`, `float(null)`
throws, and **a throw inside a check function aborts the whole function**, so its
first assertion ran, its other six silently did not, and the suite still printed
`PASS (278 checks)`. The two names are corrected and the property is now asserted
to **exist before any numeric conversion**, emitting one assertion per row in
either branch — so the count moved by the six skipped rows and by nothing else:
**278 + 6 = 284**, measured. `tests/gate_1a_scale_hall_smoke.sh` now also **fails
on any `SCRIPT ERROR` in any of its three verification runs, regardless of the
PASS line**, because a suite that greps only for the word PASS is blind to exactly
this — the rule `tests/gate_1b_exterior_asset_spike_smoke.sh` introduced for itself
under D-199, and now stricter than it, since that one checks only its headless run.
**No accepted value was ever unprotected**: those seven are redundant re-reads and
the authoritative assertions live in Gates C, D, and E. Nothing else changed — no
gameplay, tuning, movement, camera, navigation, visual, material, asset, scene,
`.tres`, InputMap entry, or entrypoint, and no evidence frame was regenerated. The
only Gate 1B file touched is `tests/gate_1b_exterior_asset_spike_smoke.sh` — the
constant `EXPECTED_GATE_1A` 278 → 284 and an explanatory comment beside it;
**Gate 1B was still 654 at that point, and it is CLOSED under D-206.** (It is 678 since D-215; see below.)

**Two things about that repair you will trip over if nobody tells you.** First,
`tests/gate_1b_exterior_asset_spike_verification.gd` used to explain its own
existence guard with *"none of the seven has ever run"* — inaccurate when written
(one ran) and later out of date as well. D-200's boundary forbade altering the
exterior spike apart from its chained Gate 1A count, so the repair left it alone;
**D-202 authorized retiring it and D-203 did, replacing it with the measured
D-200/D-201 history, without changing executable code or the 654 count.** Second,
**do not
"align" the two guards.** They deliberately differ: Gate 1B emits an existence
assertion *and* a value assertion per row, so copying its shape into
`gate_1a_verification.gd` would silently take Gate 1A from 284 to 291. The
residuals this repair chose not to close are listed in
`../docs/testing/FIRST_MVP_GATE_1A_SCALE_CALIBRATION_HALL_REPORT.md` §16.4a. See
that report's §16 for the whole record.

**Gate F closed under D-193.** The project owner played the current experience and
reported that it feels good and is **sufficient for Prototype Zero's purpose:
proving that the basic foundations work**. They explicitly do **not** require the
remaining controller, headphones, damage-numbers-Off, and Reduced/Off
presentation variants to block Prototype Zero, because this laboratory is not
intended to represent the final game's complete appearance, audio, balance, or
feel. Those rows are **not** marked PASS — they carry `DEFERRED BY OWNER` and must
return during first-MVP vertical-slice validation. That is deliberately distinct
from the mouse and controller testing that WAS completed and accepted at Gates B,
C, D, and E with the device named each time. Final manual tally: **166 PASS, 14
DEFERRED BY OWNER, 0 NOT APPLICABLE** over 180 rows.

**Gate G changed exactly one line of this project:** the Gate F scope assertion
that `../docs/testing/PROTOTYPE_ZERO_TEST_REPORT.md` does not exist, which D-193
makes false by authorization and which was replaced one for one with the
first-MVP boundary — that `../docs/testing/FIRST_MVP_VERTICAL_SLICE_REPORT.md`
does not exist. No gameplay, tuning, targeting code, asset, or accepted value
moved, no `.tres` changed, and **Gate F is still 1008 checks**.

**One design finding left this laboratory, and it does not change it.** D-193
records the production rule that **mouse targeting is per-use, not persistent**:
hover is information rather than selection, a Skill samples the cursor when that
use begins, held and repeated Skills re-evaluate it every use, a contact-melee
target belongs only to the use that acquired it, and there is no target cycling,
sticky namelock, permanent marker, or globally selected enemy. It is canonical in
`../design/COMBAT_IDENTITY_AND_MOMENT_TO_MOMENT.md` §12 and §21. **Prototype
Zero's targeting is untouched** and stays as accepted under D-178, D-179, and
D-180; its visible and internal target instrumentation remains valid for the
laboratory and the regression suite.

---

**Gate A — Project and Asset Spike: complete and verified (2026-08-31).**
**Gate B — Calibration Room and Locomotion: complete; calibration approved and
locked under D-175 (2026-08-31).**
**Gate C — Quick Strike Kernel: complete (2026-08-31), including the D-178
controller-targeting correction under D-179 and owner acceptance under D-180.**
**Gate D — One Graveblade: complete under D-183 (2026-08-31)** after automated
verification under D-182 and the project owner's mouse-and-controller approval.
**Gate F — Feedback, Death, Settings, and Test State: implemented under D-189
(2026-09-01), corrected under D-191 and D-192 the same day, and CLOSED under D-193.** The project entrypoint is now
`scenes/app/prototype_app.tscn`: Start New Lab, Continue Lab, Settings, and Quit,
over two separate versioned files. It adds the restrained §17 HUD, the §18
synchronized Hit / kill / player-damage feedback, project-authored audio for
every §19 cue family, damage numbers On/Off, reducible shake / flashes /
vibration, §20.1 Fallen with the exact killing source, §20.2 trusted Restart,
Pause with a genuinely stopped world, the §21 settings with safe display
Keep/Revert, and truthful invalid-file recovery. It was **closed by project-owner
acceptance under D-193** — see `../docs/testing/PROTOTYPE_ZERO_GATE_F_REPORT.md`
for the implementation record and
`../docs/testing/PROTOTYPE_ZERO_TEST_REPORT.md` for the exit review.

**D-191 corrected two defects the Gate F checks did not find**, before any
playtest. The verification harness deleted and rewrote
`user://prototype_settings.cfg` and `user://prototype_zero.cfg` — the project
owner's own files — so a successful run replaced their settings and erased their
laboratory progress. `PrototypeSettings` and `PrototypeLabState` now carry an
injectable `storage_path` whose default is still the production `user://`
constant; `PrototypeApp` accepts `--state-dir <dir>`, validates it before
touching disk, and **quits rather than falling back**; `tests/gate_f_smoke.sh`
creates a unique `mktemp -d` directory per run, traps its removal, passes it to
the headless run, the app boot, and the rendered run, and gives Godot an explicit
`--log-file` inside it. Ordinary launches are unaffected and still use the two
`user://` files. And §21 aim assistance scaled the cached canonical
`quick_strike.tres` **in place**, so a second laboratory in the same process
compounded it — 78.0° / 6.00 m, then 93.6° / 7.20 m, then 112.3° / 8.64 m at
assistance 100. Every `QuickStrikeAction` now takes a **private runtime copy** on
entering the tree and the scaling recomputes from the canonical record, which is
never written to; measured after, **0.0000° of drift** across three in-room
cycles, three consecutive room replacements, a Continue, and a Restart, with
D-178's 65.0° total, ±32.50°, and 5.0 m restored bit for bit at the default 70.
See `../docs/testing/PROTOTYPE_ZERO_GATE_F_REPORT.md` §10a.

**D-192 then corrected the D-191 guard itself, and the two harness-timing
weaknesses D-191 had reported and left.** The question D-191's protection rests
on — *is this store pointed at the project owner's own file?* — was answered by
comparing path TEXT against the literal `user://…` constant, so the same two
files named by their absolute paths, through `..`, or through a symlink answered
**false** and the destructive suite would have run against them. A new
`scripts/app/prototype_storage_paths.gd` resolves every path to one canonical
real path — globalized, `.` and `..` removed, every symlinked component followed,
and every component replaced by the spelling the filesystem itself reports — and
`same_path()` / `is_descendant()` are the only comparisons in it, with both
stores, `set_storage_path()`, and `PrototypeApp` each one line that calls them.
**Case is part of that**: a second D-192 pass followed the guard's own probe
answering `accepted` for
`…/app_userdata/riftwrought — prototype zero`, which is the project owner's own
directory on this case-folding volume. Whether the volume folds case is measured
rather than assumed, and case-sensitive behaviour is preserved where it belongs.
`--check-state-dir` is a non-writing startup path that resolves the request,
prints the decision, and quits, so `tests/gate_f_smoke.sh` step 2b can prove the
refusal against the production directory and eleven aliases of it without a byte
being read or written, fingerprint the real files around every one of those
checks, and **exit without running the destructive step at all** if one fails. Ordinary launches are byte-for-byte unaffected. Separately, Gate E's wave
gap and Gate D's kill-event timing now measure on the simulation clock instead of
the wall clock — test-only and value-free, with **Gate D still 230 and Gate E
still 713**. See `../docs/testing/PROTOTYPE_ZERO_GATE_F_REPORT.md` §10b.

**Gate E — Improvement Loop: complete under D-188.** The owner's 2026-09-01 playtest accepted the
loop but found group attack cadence too demanding for an opening character. The
`AttackCoordinator` now owes a **0.35-second group handoff** after any permission
holder finishes an attack action or dies holding the slot, so different attackers'
release starts moved from a measured 1.243–1.275 s to a measured **1.6167 s**
while the one-Graveblade cadence moved by **0.0000 s**. The corrected pressure
then passed its mouse-and-controller retest under D-188. All fourteen Gate E feel
questions and every manual row pass. Gate F is implemented under D-189/D-190,
corrected under D-191 and D-192, and closed under D-193; Gate G is delivered under
D-194.

D-175's approved calibration is now the shipped default and is asserted by the
Gate B suite: 5.0 m/s maximum speed and a 19 m / 55° / 45° camera.

Gate E is closed under D-188 and Gate F under D-193. Gate G is delivered under
D-194. **Do not start first-MVP production** — it remains unauthorized until the
project owner separately approves the next dependency gate.

D-178 is implemented: the controller acquisition cone is **65° total (±32.5°)**,
and an eligible target already inside Quick Strike's 1.65 m release reach
outranks any target that would need an approach, with angle primary and distance
secondary inside whichever group is active. The project owner passed the mouse
and controller review under D-180. Read
`../docs/testing/PROTOTYPE_ZERO_GATE_C_REPORT.md` §9–§11 and §15–§16 for the
acceptance record.

Gate A delivered the project, the registered KayKit import with full source and
licence traceability, coherent Knight / Graveblade scale, the seven approved
medium-rig clips on both bodies, both `handslot.r` weapon attachments, and the
headless import and startup checks.

Gate B delivered the calibration room, the fixed ARPG camera, player and world
collision, the baked navigation mesh, click-to-move with destination marker and
unreachable-point resolution, direct analog controller movement with a deadzone,
and input-family tracking.

Gate C delivered the Quick Strike kernel: mouse target acquisition and automatic
approach, directional empty swings, attack-in-place, controller soft targeting
under the D-178 cone and in-reach priority, the six action states, held-input
arbitration, buffering, repeating, pre-release and post-release cancellation, a
stable Skill Use ID, exactly one animation-aligned release query per use, and
Mana. Its inert practice posts are NOT Graveblades, and they stayed inert.

Gate D delivered one real Graveblade: 10 m awareness, navigation-mesh pursuit
that holds at 1.40 m, an `AttackCoordinator` permission request before every
commitment — one slot, a 0.25 s release-gap floor, and, under D-186, a 0.35 s
group handoff after any attack action ends or its holder dies — a 0.55 s
anticipation that tracks the player and then visibly LOCKS
its release direction 0.22 s before contact, release validation against reach,
the 90° arc, obstruction, and that committed direction, the minimal Physical
`DamageEvent`, deterministic Life in both directions, mechanical death, and
complete Hit-before-kill ordering.

Gate E delivered the contained improvement loop: the five stages
`STARTER_FIGHT → UPGRADE_ON_GROUND → UPGRADED_FIGHT → PASSIVE_READY →
REPEAT_LOOP`; exactly 10 XP and one guaranteed Prototype Honed Sword on the first
eligible kill; a ground drop built from the registered Gate A player sword with a
0.86 m copper ring against the existing 0.60 m soft-target ring and a readable
clickable nameplate; a comparison stating five computed facts and nothing else;
Equip replacing the deterministic prototype weapon directly at 100 → 150
Physical, turning a three-Hit Graveblade into a two-Hit one; the second 10 XP
reaching exactly 20 / 20; one contained Quickened Form card that applies 25%
increased attack speed through the kernel's existing mechanism so every phase
compresses to 0.80 → 0.64 s; and deterministic 1 → 2 → 3 waves about 1.25 s after
each previous threat is gone. Every reward is idempotent, and the whole
lab-progress record still lives **in memory only**: Gate F put the disk on the
APP's side of the line rather than inside `LabProgress`, which is why D-184's
in-memory guarantee is still asserted, by field name and by a comment-stripped
source scan.

Gate F delivered the layer Gate E deliberately left out. The persistent
`PrototypeApp` owns Start New Lab / Continue Lab / Settings / Quit, the two
versioned files, the audio director, the display manager, and the one
input-family tracker; the room adopts that tracker and frees its own. The room
gained the §17 HUD, the §18 feedback layer, Pause, Settings, the deliberate
confirmation, Fallen, and the trusted Restart. Every cue in
`assets/prototype/audio/cues/` is synthesised by
`scripts/tools/build_prototype_audio.gd` — **no sound was downloaded, purchased,
or imported, and no `.wav`, `.ogg`, or `.mp3` exists anywhere under
`assets/prototype/audio`**.

**The D-181 animation preference did not survive measurement.**
`Melee_1H_Attack_Chop` brings the Skeleton Blade down about 0.40 m to the side of
the character's own forward axis and never reaches a player-sized body at any
distance, so the Graveblade uses `Melee_1H_Attack_Slice_Horizontal` — the other
clip specification §6.3 names — with the locked contract untouched. That costs
the distinct enemy silhouette D-181 wanted and is the first open question in
`../docs/testing/PROTOTYPE_ZERO_GATE_D_REPORT.md` §10.

The main scene is now `scenes/app/prototype_app.tscn`. The Gate A
spike is preserved as a regression fixture at
`scenes/prototype_zero/gate_a_asset_spike.tscn` and is still runnable on its
own, and so is the room at `scenes/prototype_zero/prototype_zero.tscn`, which is
how every Gate A-E suite loads it.

Read `../docs/testing/PROTOTYPE_ZERO_GATE_B_REPORT.md`,
`../docs/testing/PROTOTYPE_ZERO_GATE_C_REPORT.md`,
`../docs/testing/PROTOTYPE_ZERO_GATE_D_REPORT.md`, and
`../docs/testing/PROTOTYPE_ZERO_GATE_E_REPORT.md` before touching anything here.
Between them they hold the measured world scale, the approved calibration, how
both attack release markers were measured, why the preferred Graveblade clip was
rejected, the measured safe spawn geometry, the two scope checks Gate E moved
forward by authorization, the D-186 group cadence correction in the Gate E report
§7a, and the completed D-188 human retest of the improvement loop in its §15a.
Read `../docs/testing/PROTOTYPE_ZERO_TEST_REPORT.md` too: it is the Gate G exit
review, and it is the shortest accurate statement of what this laboratory proved,
what it deliberately did not prove, and which fourteen human judgements are
deferred to first-MVP validation.

**Gate 1E — Nexus Threshold & The Nexus Answers — is DELIVERED under D-219 and
OPEN.** It is the first canonical CHARACTER, and the point at which this project
stops being a combat slice. `scenes/first_mvp/canonical_opening/canonical_opening.tscn`
(`CanonicalOpeningRuntime`) carries the player through **Riftfall Landing →
Broken Watch → Nexus Threshold → the Rift Nexus** as ONE composition with ONE
continuous navigation bake, and the character owns a Level, experience, a Passive
point, Skills, equipment and progression that **survive quitting**.

**`CanonicalOpeningRuntime` EXTENDS `BrokenWatchSlice`**, which is the single
most important fact about it. `broken_watch_slice.gd` and `broken_watch_slice.tscn`
are byte-identical, Gate 1D's scene still runs alone at its locked 129, and
`FirstMvpModal`, `FirstMvpCombatHud`, `FirstMvpItemComparison` and
`FirstMvpFallenOverlay` — all typed to `BrokenWatchSlice` — bind to it with no
edit, so there is no third copy of that modal contract anywhere. Exactly five
things are added: two spaces, a saved character, the Nexus beats, a safe region,
and the First Footing boundary.

New this gate:

- `scripts/first_mvp/severed_threshold/nexus_threshold_layout.gd`
  (`NexusThresholdLayout`, 6 rooms, **1262.00 m² = 2.15 CF**, no combat)
- `scripts/first_mvp/nexus/rift_nexus_layout.gd`
  (`RiftNexusLayout`, 5 rooms, **1962.00 m² = 3.34 CF**, a minimal shell)
- `scripts/first_mvp/nexus/rift_anchor.gd` — the recognition beat, project-authored
  primitive geometry and emission only
- `scripts/first_mvp/nexus/mara_veyl.gd` — the Knight rig, unarmed, per-instance
  overlay; a recorded placeholder
- `scripts/first_mvp/nexus/first_mvp_dialogue.gd` — four lines, four facts
- `scripts/passives/` — `PassiveNodeData`, `PassiveGraph`, `PassiveEffects`,
  `PassiveAllocation`: the Riftmarked Origin Ring as data
- `scripts/character/` — `ExperienceTable`, `CharacterState`, `CharacterSave`
- `scripts/skills/` — `FirstMvpSkillData`, `FirstMvpSkillAction`,
  `FirstMvpSkillProjectile`, `FirstMvpActiveBindings`, `FirstMvpSkillLibrary`
- `scripts/items/first_mvp_weapon_record.gd`, `first_mvp_equipment.gd`
- `scripts/combat/first_mvp_damage_event.gd`
- `scripts/ui/canonical_opening_hud.gd`, `nexus_dialogue_panel.gd`,
  `origin_ring_panel.gd`, `foundation_cache_panel.gd`
- `data/first_mvp/skills/` and `data/first_mvp/foundation/` — three Skill records
  and three ordinary weapon records
- `scenes/first_mvp/canonical_opening/foundation_skill_practice.tscn` — a
  DEVELOPER-ONLY practice range; nothing in the game loads it

**Two things about it are worth carrying.** `BrokenWatchLayout`'s far cap sealed
the route the moment the Nexus Threshold existed, and every socket still resolved
onto the navigation mesh while no PATH could reach past the junction — **"a socket
is on the mesh" and "you can walk there" are different claims**; the cap is opened
from the runtime, so Gate 1D's file is untouched. And `route_forward()` is the
Landing centreline's FIRST segment in world space, which is not the direction the
route runs at the far end of it — **measure in the layout's own local frame**.

## Baseline

Locked by decision D-167 and specification §4:

| | |
|---|---|
| Engine | Godot **4.7.2 stable** |
| Renderer | Forward+ |
| Language | typed GDScript |
| Physics | 60 Hz |
| UI reference | 1920 × 1080, minimum tested window 1280 × 720 |
| Add-ons | none |
| Network / account / telemetry | none |

If the installed editor version ever differs from 4.7.2 stable, the smoke script
fails on purpose. Report the mismatch before upgrading the project.

## Running it

**The Zone Composer is not run — it is opened.** Open the project in Godot 4.7.2
and the dock appears on the right, titled **Riftwrought Zone Composer**. It is
already enabled; Project ▸ Project Settings ▸ Plugins turns it off. The
five-minute walkthrough is `addons/riftwrought_zone_composer/README.md`.

Open the project in Godot, or from the repository root:

```bash
/Applications/Godot.app/Contents/MacOS/Godot --path game
```

Left click or hold to move; left stick to move directly. Right mouse or the west
face button is Quick Strike; hold to repeat; Shift attacks in place without
approaching. One Graveblade is in the room at start, 7.5 m from the player
spawn — inside its 10 m awareness, so it engages immediately. Three Quick Strikes
kill it; four of its Hits defeat you.

Killing it drops the Prototype Honed Sword. **Click its nameplate**, or press
**Enter / the south face button** from within 2.20 m of it, to open the
comparison; **Equip** replaces your weapon and the next Graveblade dies in two
Hits. At 20 / 20 XP a Quickened Form card appears; confirming it takes Quick
Strike from 0.80 s to 0.64 s. After that the room runs deterministic waves of
one, two, and three, repeating.

On a controller, **F3** additionally draws the 65°-total soft-target cone at its
5 m acquisition distance and the 1.65 m in-reach priority ring.

The on-screen instrumentation cards use **evergreen** copy: they name what the
laboratory is rather than what it currently lacks, because a card authored in an
earlier gate that says "no enemy exists yet" is read during the very playtest it
is lying to. Twenty-three Gate E assertions stop the retired phrases returning.

**Gate F changed what F3 means.** The four gates of instrumentation cards are now
HIDDEN by default and F3 reveals them together with their detail panels and the
3D gizmos, because §22 is explicit that the debug overlay is not player-facing.
The §17 HUD is what you see instead. A standalone room run — which is how every
Gate A-E suite loads it — still starts with the cards visible, so those suites
and their evidence screenshots are unchanged.

**Escape** pauses; **F5** restarts the current fight from Fallen or Pause; **F2**
switches damage numbers.

**F3** debug panels and gizmos — including the Graveblade's reach and 90° attack
arc drawn around its committed direction, and the Gate E lab panel with its
**force-wave-size 1 / 2 / 3 selector** — **F4** barrier, **F6** 1 m grid,
**F7** reset the practice posts, **F8** slow motion for release-marker
inspection, **F9** post drift, **F10** remove or restore the current post,
**F11** reset the current stage (a clearly labelled DEBUG reset that RETAINS
completed milestones, not Gate F's Restart), **F12** **Reset Lab Progress**
(deliberately clears the in-session sequence), `[ ]` camera distance, `, .`
pitch, `; '` field of view, `- =` movement speed, `\` reset to the D-175
approved values. There is no WASD movement, by design.

The preserved Gate A spike, where **Space** or **Enter** advances to the next
animation clip:

```bash
/Applications/Godot.app/Contents/MacOS/Godot --path game res://scenes/prototype_zero/gate_a_asset_spike.tscn
```

The first-MVP **Gate 1B Exterior Asset Compatibility Spike** — a temporary
developer review scene, closed under D-206 and retained as a regression
instrument, with no combat, no route, no progression, and no save (in the editor,
open the scene and use **Run Current Scene**, not Run Project):

```bash
/Applications/Godot.app/Contents/MacOS/Godot --path game res://scenes/first_mvp/visual/exterior_asset_compatibility_spike.tscn
```

Left click or hold to move; left stick to move directly. **F1** neutral review
lighting ↔ candidate exterior treatment, **F2** imported source materials ↔
candidate material treatment, **F3** overlay, **F4** k0rveen shown ↔ hidden
(navigation rebakes to match), **F6** 1 m grid, `[ ]` camera distance, `\` reset
every review mode and the player position. There is no WASD and no attack input;
right-click and the combat inputs are refused by name and counted. Every toggle is
read as a PHYSICAL KEY — no InputMap action was added. Nothing is written to disk.

**Riftfall Landing** — the CANONICAL safe exterior opening of The Severed
Threshold, delivered under D-208 and open for the project owner's playtest. Run
the developer review wrapper, which instances the canonical scene and adds the
temporary body, camera, marker and diagnostics (in the editor, open the scene and
use **Run Current Scene**, not Run Project):

```bash
/Applications/Godot.app/Contents/MacOS/Godot --path game res://scenes/first_mvp/severed_threshold/riftfall_landing_review.tscn
```

Left click or hold to move; left stick to move directly. **The default view is
clean** — one small line names the build and nothing else. **F3** diagnostics
overlay, **F6** 1 m grid, **F7** navigation and collision-role view, `[ ]` camera
distance, `\` reset the body, camera, marker, loop state, counters and every review
mode. There is no WASD and no attack input; right-click and the combat inputs are
refused by name and counted. Every control is read as a PHYSICAL KEY — no InputMap
action was added. Nothing is written to disk.

The canonical scene alone —
`res://scenes/first_mvp/severed_threshold/riftfall_landing.tscn` — also loads and
runs, and shows the environment with **no player, no camera and no interface**,
which is exactly what it is for.

Walk from the Rift scar down the broken road, past the repeating stone, and
through the 8.000 m Watch breach. The stone rolls 1.732 m down a shallow grade,
strikes, holds, and returns to its starting place in a tenth of a second; a full
cycle is 2.05 s, so an ordinary first traversal contains several. It has no
collision, carves no navigation, and does not care where you are standing.

**One thing worth knowing before you judge the space.** At the accepted 19 m /
55° / 45° camera the horizon is never in shot: the visible ground runs from 7.45 m
behind the body to **13.53 m ahead of it**, and beyond that everything at or above
ground level is off the top of the frame however tall it is. A distant landmark
therefore cannot carry the forward bearing at this camera — the road, the
converging boundary, the lantern chain and the darkening architecture do. The
Watch massing is built where it can be reached rather than where it could be
admired; it first enters the frame 47.0 m along a 53.4 m route.

The first-MVP **Gate 1B Exterior Cohesion Comparison** — ONE composed route slice
with swappable candidate families, closed under D-206 and retained as a regression
instrument, with no combat, no canonical route, no progression, and no save (in the editor, open the scene and use **Run Current Scene**, not Run
Project):

```bash
/Applications/Godot.app/Contents/MacOS/Godot --path game res://scenes/first_mvp/visual/exterior_cohesion_comparison.tscn
```

Left click or hold to move; left stick to move directly. **F4** Kenney Nature
topology off ↔ on, **F5** cycle architecture (KayKit baseline → Quaternius Modular
Ruins → Kenney Fantasy Town), **F7** Kenney Graveyard dressing off ↔ on, **F1**
neutral review lighting ↔ candidate treatment, **F2** imported source materials ↔
candidate material treatment, **F3** overlay, **F6** 1 m grid, `[ ]` camera
distance, `\` reset every mode, the camera, and the player. There is no WASD and
no attack input; right-click and the combat inputs are refused by name and
counted. Every toggle is read as a PHYSICAL KEY — no InputMap action was added.
Nothing is written to disk.

The first-MVP **Gate 1A Scale Calibration Hall** — a temporary developer scene
with no combat, no progression, and no save (in the editor, open the scene and use
**Run Current Scene**, not Run Project):

```bash
/Applications/Godot.app/Contents/MacOS/Godot --path game res://scenes/first_mvp/calibration/scale_calibration_hall.tscn
```

Left click or hold to move; left stick to move directly. **F3** overlay, **F6**
1 m grid, **F1** inert role fixtures, **F4** the telegraph and hazard court
(candidate → smaller → larger → hidden), `[ ]` camera distance, `, .` pitch,
`; '` field of view, `- =` movement speed, `\` reset **all** runtime calibration
to the Gate 1A baseline. There is no WASD and no attack input; right-click and the
combat inputs are refused by name and counted. Nothing is written to disk.

**Gate 1D — Broken Watch Combat & Loot Slice** — the first canonical
combat-and-equipment playtest, directly runnable (**Run Current Scene** in the
editor, or):

```bash
/Applications/Godot.app/Contents/MacOS/Godot --path game res://scenes/first_mvp/severed_threshold/broken_watch_slice.tscn
```

Left click or hold to move; left stick to move directly. Right-click (or the
controller's `quick_strike` action) fires Quick Strike; `Shift`/`attack_in_place`
swings without approaching. Mouse hover shows an enemy's name and Life on the
HUD — information only, never a mechanical selection; Quick Strike samples the
cursor fresh each use. The ground drop's nameplate is a real clickable button
for mouse, from any distance; the controller's `interact` action opens it only
from inside its own measured range. `F6` grid, `[ ]` camera distance, `\`
reset. `quick_restart` (F5) restarts the whole slice at any time. There is no
WASD. Nothing is written to disk.

**Gate 1E — the integrated canonical opening** — the first playtest with a
character who persists (**Run Current Scene** in the editor, or):

```bash
/Applications/Godot.app/Contents/MacOS/Godot --path game res://scenes/first_mvp/canonical_opening/canonical_opening.tscn
```

Add `-- --start-fresh` to begin a new character, or `-- --state-dir <dir>` to
point it at isolated storage. Gate 1D's controls all still apply, plus four
PHYSICAL KEYS — **F1** Origin Ring, **F2** Foundation Cache, **F5** Start Fresh,
**F8** save now — and `interact` (E / (A)) opens whichever Nexus station you are
standing at. No InputMap action was added. **This one DOES write**, to
`user://riftwrought_character.cfg` and to nothing else.

**The developer-only Foundation Skill practice range** — not canonical content,
loaded by nothing in the game:

```bash
/Applications/Godot.app/Contents/MacOS/Godot --path game res://scenes/first_mvp/canonical_opening/foundation_skill_practice.tscn
```

`1`/`2`/`3` select Faultbreaker / Splinter Shot / Emberbolt; `4`/`5`/`6` equip the
Garrison Greatsword / Marrow Bow / Cantor Wand; **E** uses the selected Skill;
right mouse still fires Quick Strike; `R` restores. Nothing is written to disk.

## Checks

**Start here.** The current gate's runner, which runs everything else first:

```bash
game/tests/gate_1e_canonical_opening_smoke.sh
```

**557 Gate 1E checks** plus **102 Foundation Skill checks**, both pinned in BOTH
directions against a mutated replay of the run's own log, and both porting
D-211's owed-set discipline: every check function records reaching its last line
and the suite compares that set to what it owes in both directions (25 of 25,
10 of 10). It runs the complete locked chain ONCE
(`gate_1d_broken_watch_smoke.sh`, which runs everything below) and then adds only
what the chain cannot know — that the four spaces are one continuous WALKABLE
composition, that the Nexus beats fire once and in order, that the Origin Ring
and the Foundation Cache obey their rules, that nothing duplicates through a
reload, that the character store cannot reach either Prototype Zero file however
its path is spelled, and that every excluded system is absent.

The previous gate's runner, still valid on its own:

```bash
game/tests/gate_1d_broken_watch_smoke.sh
```

**129 Gate 1D checks**, proportional to what Gate 1D can actually break (its
own brief explicitly asks not to rerun the whole historical suite's hundreds
of assertions in exhaustive detail). It runs the complete locked chain ONCE
(`gate_1c_riftfall_landing_smoke.sh`, which runs everything below), then
proves — among other things — that Riftfall Landing's accepted foundation is
untouched, that the whole slice bakes as ONE continuous navigation mesh, that
the reused combat kernel's data is the exact canonical `.tres` records, that
production mouse targeting is structurally per-use (source-scanned) while
controller D-178 targeting is unmodified, that the first Graveblade takes
exactly 3 Quick Strikes and the second exactly 2 once the guaranteed
Watchsteel Sword is equipped, that ownership is idempotent, that Fallen and
Restart never duplicate the reward, and that every excluded system and the
InputMap's locked 31 actions are untouched. It pins its own count in both
directions against a replay of its own log, exactly as every prior gate's
runner pins its own. It writes nothing and fingerprints the project owner's
two production files before and after the whole run.

Gate 1C's own runner, which Gate 1D's runner calls first:

```bash
game/tests/gate_1c_riftfall_landing_smoke.sh
```

**200 Gate 1C checks** headless — 203 in the rendered evidence run, which adds
exactly three: the two posed stone frames §12 requires and the overview frame's
camera-calibration restore. It runs the complete locked chain first
(`gate_1b_exterior_cohesion_smoke.sh` at **613**, which runs the Gate 1B spike at
**678**, which runs Gate 1A at **284**, which runs Gate F at **1008**, Gate E
**713**, Gate D **230**, Gate C **209**, Gate B **106**, and Gate A), so any
regression stops everything before a Gate 1C result is trusted. **Gate 1B is 678
rather than the 654 it was through D-214 because of D-215 and nothing else**: that
verifier emits one assertion per file in `kaykit/forest` and `kaykit/halloween`,
and D-215 authorized 4 Forest + 8 Halloween models = 24 files there. 654 + 24 =
678. It pins its own count in BOTH directions against a replay of its own log,
derives the third-party inventory (**187**, moved from 91 by D-215's 94 files and
D-216's 2 LeLu textures) from the filesystem, hashes all six accepted `.tres` records,
counts the InputMap's **31** actions in `project.godot`, and fingerprints the
project owner's two production files before and after the whole run.

Add the eight §12 evidence images, checked for existence, exact dimensions read
from each PNG's own header, and being real frames rather than empty files:

```bash
game/tests/gate_1c_riftfall_landing_smoke.sh --shots docs/testing/gate_1c_riftfall_landing_evidence
```

**The Zone Composer has its own runner and it deliberately does NOT run the
chain**, because an editor dock cannot break a gate it ships no code into:

```bash
game/tests/zone_composer_smoke.sh
```

It parses every addon file, enables the plugin in a real headless editor, runs
**79 in-editor checks** against the real `EditorUndoRedoManager` and the real gizmo
system (a synthesized click really places a piece; Undo really removes it; Redo
really restores it; every story marker is really drawn, survives undo, redo and a
disable/re-enable), opens a **second** editor session on the owner's already-composed
zone for **7** more, runs **324 headless checks** with both counts pinned in both
directions, proves `project.godot` holds exactly its nine sections with one
editor-only key, boots the Prototype App to show ordinary startup is unchanged, and
fingerprints every third-party source asset **and the owner's composed zone** before
and after. Run the chain separately when the tree is final.

Run the Gate 1C verification alone, against the live scene:

```bash
/Applications/Godot.app/Contents/MacOS/Godot --headless --path game res://scenes/first_mvp/severed_threshold/riftfall_landing_review.tscn -- --verify-1c
```

---

Everything Prototype Zero is allowed to automate, in one script — **1008 checks**
headless, 1019 when it also renders the evidence. It reruns the whole Gate E suite
first (713 checks), which reruns the whole Gate D suite (230 checks), which
reruns the whole Gate C suite (209 checks), which reruns the whole Gate B suite
(106 checks), which reruns the whole Gate A suite, so an asset, rig, locomotion,
combat-kernel, encounter, or progression regression is caught before any Gate F
result is trusted. It also rebuilds the authored audio and proves the rebuild is
byte-identical, creates its own `mktemp -d` state directory so it never touches
the project owner's saved settings or laboratory progress, proves the storage
guard refuses the production directory and eleven aliases of it on a non-writing
startup path before it runs anything destructive, and fingerprints those two
production files before and after — and around every refusal check — to prove it:

```bash
game/tests/gate_f_smoke.sh
```

Add rendered evidence screenshots:

```bash
game/tests/gate_f_smoke.sh --shots docs/testing/gate_f_evidence
```

The Gate E suite on its own, which is the whole chain below Gate F:

```bash
game/tests/gate_e_smoke.sh
```

The first-MVP Gate 1A suite, which runs the WHOLE Gate F chain above first and
stops on any regression — **284 Gate 1A checks** over Gate F's 1008:

```bash
game/tests/gate_1a_scale_hall_smoke.sh
```

```bash
game/tests/gate_1a_scale_hall_smoke.sh --shots docs/testing/gate_1a_scale_hall_evidence
```

The first-MVP Gate 1B spike suite, which runs the WHOLE Gate 1A chain above first —
**654 Gate 1B checks** over Gate 1A's 284, and which now PINS its own 654 and
proves that pin in both directions against a replay of its own log:

```bash
game/tests/gate_1b_exterior_asset_spike_smoke.sh
```

```bash
game/tests/gate_1b_exterior_asset_spike_smoke.sh --shots docs/testing/gate_1b_exterior_asset_spike_evidence
```

The first-MVP Gate 1B **cohesion** suite, which runs the whole chain above first —
**613 cohesion checks** over the Gate 1B spike's 654:

```bash
game/tests/gate_1b_exterior_cohesion_smoke.sh
```

```bash
game/tests/gate_1b_exterior_cohesion_smoke.sh --shots docs/testing/gate_1b_exterior_cohesion_evidence
```

Earlier suites on their own. Gate B and Gate C run **without** any Graveblade — a
live enemy chasing the character would change what they measure — and Gate B,
Gate C, and Gate D all run with the Gate E progression director **suspended**,
which reproduces exactly the arrangement Gate D was accepted in: one Graveblade
at the authored spawn marker, no rewards, no waves. The room logs both:

```bash
game/tests/gate_d_smoke.sh
game/tests/gate_c_smoke.sh
game/tests/gate_b_smoke.sh
game/tests/gate_a_smoke.sh
```

Every earlier suite loads `scenes/prototype_zero/prototype_zero.tscn` DIRECTLY,
because Gate F made `scenes/app/prototype_app.tscn` the project main scene. A
standalone room builds its own §21-default settings and its own audio director,
so a suite run is never steered by whatever was last chosen in the settings
panel.

Individual pieces:

```bash
/Applications/Godot.app/Contents/MacOS/Godot --headless --path game --import
```

```bash
/Applications/Godot.app/Contents/MacOS/Godot --headless --path game --script res://scripts/tools/gate_a_asset_report.gd
```

```bash
/Applications/Godot.app/Contents/MacOS/Godot --headless --path game res://scenes/prototype_zero/gate_a_asset_spike.tscn -- --verify
```

```bash
/Applications/Godot.app/Contents/MacOS/Godot --headless --path game -- --verify
```

```bash
/Applications/Godot.app/Contents/MacOS/Godot --headless --path game -- --verify-c
```

```bash
/Applications/Godot.app/Contents/MacOS/Godot --headless --path game -- --verify-d
```

```bash
/Applications/Godot.app/Contents/MacOS/Godot --headless --path game res://scenes/prototype_zero/prototype_zero.tscn -- --verify-e
```

```bash
/Applications/Godot.app/Contents/MacOS/Godot --headless --path game -- --verify-f --state-dir /tmp/riftwrought_state
```

```bash
/Applications/Godot.app/Contents/MacOS/Godot --headless --path game res://scenes/first_mvp/calibration/scale_calibration_hall.tscn -- --verify-1a
```

```bash
/Applications/Godot.app/Contents/MacOS/Godot --headless --path game res://scenes/first_mvp/visual/exterior_asset_compatibility_spike.tscn -- --verify-1b
```

```bash
/Applications/Godot.app/Contents/MacOS/Godot --headless --path game res://scenes/first_mvp/visual/exterior_cohesion_comparison.tscn -- --verify-1b-cohesion
```

`--verify-f` **requires** `--state-dir`, and the directory must already exist and
be writable. Without it the app refuses to start and the verification refuses to
run, because it writes, corrupts, and deletes real settings and lab files and
must never do that to the two `user://` files an ordinary launch uses (D-191).
It also refuses the project owner's own user data directory under **any**
spelling — absolute, `..`, `.`, a doubled separator, another case on a volume
that folds case, or a symlink — and anything inside it (D-192).

To ask the storage guard about one directory by hand, without starting the game
or touching a single file:

```bash
/Applications/Godot.app/Contents/MacOS/Godot --headless --path game -- --check-state-dir --state-dir /tmp/riftwrought_state
```

Regenerate the project-authored audio (add `-- --peaks` for the measured table,
or `-- --wav <dir>` to export plain RIFF audition copies OUTSIDE the project):

```bash
/Applications/Godot.app/Contents/MacOS/Godot --headless --path game --script res://scripts/tools/build_prototype_audio.gd
```

Regenerate the shared animation library after changing the approved clip list:

```bash
/Applications/Godot.app/Contents/MacOS/Godot --headless --path game --script res://scripts/tools/build_rig_medium_library.gd
```

Remeasure the Quick Strike contact moment and rebuild the retimed local clip
(add `-- --table` for the full per-sample measurement table):

```bash
/Applications/Godot.app/Contents/MacOS/Godot --headless --path game --script res://scripts/tools/build_quick_strike_animation.gd
```

Remeasure both D-181 Graveblade attack candidates, apply the acceptance criteria,
and rebuild the chosen retimed clip:

```bash
/Applications/Godot.app/Contents/MacOS/Godot --headless --path game --script res://scripts/tools/build_graveblade_animation.gd
```

No test framework is installed, by design (specification §25). Automated checks
cannot certify feel; `tests/manual/PROTOTYPE_ZERO_TEST_MATRIX.md` is the human
half.

## Layout

```
game/
├── assets/
│   ├── third_party/kaykit/        registered CC0 KayKit files + SOURCE_AND_LICENSE.md
│   ├── third_party/k0rveen/       CC BY 4.0 meshes, family REJECTED by D-206 but
│   │                              retained; credit still obligatory
│   │                              + SOURCE_AND_LICENSE.md
│   ├── third_party/kenney/        CC0 Nature (rejected) / Fantasy Town (rejected) /
│   │                              Graveyard (ACCEPTED as sparse dressing, D-206)
│   │                              + SOURCE_AND_LICENSE.md (D-202, atlases D-204)
│   ├── third_party/quaternius/    CC0 Modular Ruins, rejected for foreground
│   │                              architecture by D-206 but retained
│   │                              + SOURCE_AND_LICENSE.md (D-202)
│   └── prototype/
│       ├── animation/             quick_strike_prototype_animation.res,
│       │                          graveblade_prototype_animation.res (generated)
│       ├── audio/                 prototype_bus_layout.tres,
│       │                          SOURCE_AND_DERIVATION.md (generated),
│       │                          cues/*.res — 38 generated variants across 20
│       │                          families, all project-authored (generated)
│       └── {ui,vfx}/              project-owned prototype content
├── data/
│   ├── prototype_zero/            quick_strike.tres, graveblade.tres,
│   │                              starter_sword.tres, honed_sword.tres,
│   │                              progression.tres
│   └── first_mvp/calibration/     scale_calibration.tres (the Gate 1A candidate
│                                  values; nothing here is decided)
├── scenes/
│   ├── app/                       prototype_app.tscn (MAIN SCENE)
│   ├── actors/                    knight_rig.tscn, graveblade_rig.tscn,
│   │                              prototype_player.tscn,
│   │                              prototype_graveblade.tscn,
│   │                              prototype_target_fixture.tscn
│   ├── items/                     prototype_sword_drop.tscn
│   ├── prototype_zero/            prototype_zero.tscn (the lab, loaded by the app),
│   │                              calibration_room.tscn,
│   │                              gate_a_asset_spike.tscn (preserved fixture)
│   ├── first_mvp/calibration/     scale_calibration_hall.tscn (RUNNABLE ON ITS OWN),
│   │                              calibration_hall_player.tscn,
│   │                              scale_calibration_overlay.tscn
│   ├── first_mvp/visual/          exterior_asset_compatibility_spike.tscn
│   │                              (RUNNABLE ON ITS OWN — Gate 1B spike),
│   │                              exterior_spike_overlay.tscn,
│   │                              exterior_cohesion_comparison.tscn
│   │                              (RUNNABLE ON ITS OWN — Gate 1B cohesion),
│   │                              exterior_cohesion_overlay.tscn
│   ├── first_mvp/severed_threshold/
│   │                              riftfall_landing.tscn (CANONICAL — environment,
│   │                               navigation, sockets and the visual loop; no
│   │                               player, camera, marker or interface),
│   │                              riftfall_landing_review.tscn
│   │                              (RUNNABLE ON ITS OWN — the Gate 1C developer
│   │                               review wrapper around the canonical scene)
│   └── ui/                        gate_b_calibration_overlay.tscn,
│                                  gate_c_combat_overlay.tscn,
│                                  gate_d_encounter_overlay.tscn,
│                                  gate_e_lab_overlay.tscn,
│                                  gate_e_item_comparison.tscn,
│                                  gate_e_passive_card.tscn
├── scripts/
│   ├── movement/                  prototype_locomotion.gd,
│   │                              prototype_ground_pointer.gd,
│   │                              prototype_mouse_hold.gd
│   │                              (the ONE shared locomotion, cursor-to-navigation,
│   │                               and click-and-hold implementation, used by BOTH
│   │                               the Prototype Zero room and the Gate 1A hall)
│   ├── first_mvp/visual/          exterior_asset_compatibility_spike.gd,
│   │                              exterior_asset_catalogue.gd,
│   │                              exterior_asset_probe.gd,
│   │                              exterior_spike_layout.gd,
│   │                              exterior_review_lighting.gd,
│   │                              exterior_review_treatment.gd,
│   │                              exterior_spike_overlay.gd,
│   │                              exterior_cohesion_comparison.gd,
│   │                              exterior_cohesion_catalogue.gd,
│   │                              exterior_cohesion_route.gd,
│   │                              exterior_cohesion_overlay.gd
│   │                              (the cohesion files REUSE the spike's
│   │                               lighting, treatment, and probe unchanged)
│   ├── first_mvp/severed_threshold/
│   │                              riftfall_landing.gd,
│   │                              riftfall_landing_layout.gd,
│   │                              riftfall_loop_event.gd,
│   │                              riftfall_landing_review.gd,
│   │                              riftfall_landing_overlay.gd
│   │                              (Gate 1C REUSES the same lighting, treatment,
│   │                               probe, locomotion, pointer, camera, marker and
│   │                               input-family components unchanged)
│   ├── first_mvp/calibration/     scale_calibration_hall.gd,
│   │                              scale_calibration_geometry.gd,
│   │                              calibration_fixtures.gd,
│   │                              calibration_hall_player.gd,
│   │                              scale_calibration_overlay.gd,
│   │                              scale_calibration_data.gd,
│   │                              gate_1a_verification.gd
│   ├── app/                       prototype_app.gd, prototype_settings.gd,
│   │                              prototype_lab_state.gd,
│   │                              prototype_storage_paths.gd,
│   │                              prototype_audio_director.gd,
│   │                              prototype_display_manager.gd
│   ├── audio/                     prototype_cue_catalogue.gd
│   ├── actors/                    medium_rig_visual.gd, prototype_player.gd,
│   │                              prototype_graveblade.gd,
│   │                              graveblade_target_area.gd,
│   │                              prototype_target_fixture.gd
│   ├── camera/                    prototype_camera_rig.gd
│   ├── combat/                    quick_strike_data.gd, quick_strike_action.gd,
│   │                              target_acquisition.gd, prototype_targetable.gd,
│   │                              damage_event.gd, graveblade_data.gd,
│   │                              attack_coordinator.gd,
│   │                              prototype_weapon_data.gd
│   ├── input/                     input_family_tracker.gd
│   ├── items/                     prototype_sword_drop.gd
│   ├── prototype_zero/            prototype_zero.gd, calibration_room.gd,
│   │                              destination_marker.gd,
│   │                              gate_b_debug_visuals.gd,
│   │                              gate_c_debug_visuals.gd,
│   │                              gate_a_asset_spike.gd, combat_feedback.gd,
│   │                              lab_progression_data.gd, lab_progress.gd,
│   │                              progression_director.gd
│   ├── ui/                        gate_b_calibration_overlay.gd,
│   │                              gate_c_combat_overlay.gd,
│   │                              gate_d_encounter_overlay.gd,
│   │                              gate_e_modal.gd, gate_e_item_comparison.gd,
│   │                              gate_e_passive_card.gd,
│   │                              gate_e_lab_overlay.gd,
│   │                              prototype_hud.gd, prototype_title_screen.gd,
│   │                              prototype_pause_menu.gd,
│   │                              prototype_fallen_overlay.gd,
│   │                              prototype_settings_modal.gd,
│   │                              prototype_settings_panel.gd,
│   │                              prototype_confirm_modal.gd,
│   │                              prototype_display_prompt.gd
│   └── tools/                     headless probes, generators, verification
└── tests/
    ├── gate_a_smoke.sh
    ├── gate_b_smoke.sh
    ├── gate_c_smoke.sh
    ├── gate_d_smoke.sh
    ├── gate_e_smoke.sh
    ├── gate_f_smoke.sh
    ├── gate_1a_scale_hall_smoke.sh
    ├── gate_1b_exterior_asset_spike_smoke.sh
    ├── gate_1b_exterior_asset_spike_verification.gd
    ├── gate_1b_exterior_cohesion_smoke.sh
    ├── gate_1b_exterior_cohesion_verification.gd
    └── manual/PROTOTYPE_ZERO_TEST_MATRIX.md
```

`.godot/` is generated and excluded from source control.

## World scale

**One Godot unit is one metre**, locked for Prototype Zero by D-175. The approved
calibration is an 18 × 14 m clear floor, player collision diameter P of 0.80 m,
5.0 m/s maximum speed, and a 19 m / 55° pitch / 45° FOV camera. That camera's
ground footprint CF is 28.0 × 21.0 m, which makes this room 0.43 CF. No asset is
rescaled; every import still uses `root_scale = 1.0`.

These are shipped defaults, asserted by the Gate B suite, and they are locked
first Prototype Zero calibration values rather than immutable global first-MVP
balance. The evidence and approval record are in
`../docs/testing/PROTOTYPE_ZERO_GATE_B_REPORT.md` §3 and §13; the recomputed CF
and the persistence record are in
`../docs/testing/PROTOTYPE_ZERO_GATE_C_REPORT.md` §2.

## Naming

Everything in here is prototype content. The Knight body is a temporary test
adventurer: it is **not** the Riftmarked and it selects no class. `Graveblade`
is the player-facing prototype name for the KayKit Skeleton Warrior; `Skeleton
Warrior` remains an acceptable debug identifier. Gate C's **practice posts** are
still inert target fixtures and are **not** Graveblades — they have no Life, no
damage, no death, no XP, and no loot, and the Gate C suite still asserts that by
name.

## What must not appear here

Prototype Zero excludes classes, the Skill Library, Configurations, Augments,
the Passive Web, attributes, ailments, non-Physical damage, the full damage
pipeline, affixes, rarities, inventory, equipment slots, crafting, procedural
generation, Runs, Pursuits, Intensities, Distortions, Elites, bosses, Anchors,
profiles, saves beyond the small lab test state, WASD, story, and music.

Gate E added exactly what D-184 authorizes — XP, the two deterministic prototype
weapon records, the one guaranteed ground drop, the comparison and equip, the one
contained Quickened Form passive, deterministic waves, and the modal contract —
plus exactly what D-186 authorizes, the coordinator's 0.35-second group handoff,
and nothing else. Gate F then added exactly what D-189 authorizes — the persistent app, the two
versioned files, the §17 HUD, the §18 feedback layer, the §19 authored cues,
Fallen, Restart, Pause, and the §21 settings — and nothing else. Gate E's suite
moved **twelve** assertions forward by authorization and Gate D's moved **five**,
each replaced one for one with the next boundary; both suites hold their counts
and the arithmetic is stated in
`../docs/testing/PROTOTYPE_ZERO_GATE_F_REPORT.md` §9. Gate G then moved **one** of
Gate F's the same way — the assertion that the exit report does not exist,
replaced by the first-MVP boundary — and Gate F's count is unchanged at 1008.

The two weapon records are **not** the beginning of the item system, and the
class is deliberately the wrong shape to become one: no Base Type, Item Level,
requirement, rarity, Implicit, affix, Tier, conflict group, Wrought Modifier,
Unique mechanic, procedural roll, Crafting Strain, inventory position, or
equipment slot — each asserted absent by field name.

Future-ready cleanliness is welcome. Future content is not.

**Gate 1A, Gate 1B and Gate 1C are the three authorized exceptions, and all
three are fenced.**

**Gate 1C is the only one of them that is CANONICAL**, and the only one meant to
survive. Everything it added lives under `scenes/first_mvp/severed_threshold/`,
`scripts/first_mvp/severed_threshold/`, `tests/gate_1c_*`, and
`../docs/testing/gate_1c_riftfall_landing_evidence/`. It added no asset, no audio,
no InputMap action, no `.tres`, no app integration and no storage of any kind. It
carries no attack, Quick Strike, target acquisition, enemy, damage, Life, Mana,
loot, XP, Passive, inventory, equipment, story, Mara, Nexus, Broken Watch,
checkpoint, portal, transition, procedural generation, HUD, save or settings —
each asserted absent **by member name** on the canonical scene, the review wrapper
AND the body — and it writes nothing to disk. Like both Gate 1B scenes it REUSES
the Gate 1A player scene unchanged rather than cloning a fourth locomotion
wrapper, and the same consequence is recorded honestly: that scene's class is
still named `CalibrationHallPlayer`, because D-208 does not authorize editing a
closed gate's files, not even its comments. **That name is review scaffolding and
must not become canonical character architecture** — which is exactly why the
canonical Riftfall Landing scene contains no player at all.
Gate 1B lives entirely under `scenes/first_mvp/visual/`,
`scripts/first_mvp/visual/`, `tests/gate_1b_*`, and the three new third-party
candidate folders. It carries no attack, target acquisition, enemy, damage, Life,
Mana, loot, XP, Passive, inventory, story, Mara, Nexus, route, procedural
generation, HUD, save, or settings — each asserted absent **by member name** — and
it writes nothing to disk. It REUSES the Gate 1A player scene unchanged rather
than cloning a third locomotion wrapper, so a consequence is recorded honestly:
that scene's class is still named `CalibrationHallPlayer` and its documentation
still names the Scale Calibration Hall, because D-198 does not authorize editing a
closed gate's files, not even its comments.

**Gate 1A itself:** Everything it added
lives under `scenes/first_mvp/`, `scripts/first_mvp/`, and `data/first_mvp/`, plus
the three shared movement components under `scripts/movement/` that were EXTRACTED
out of Prototype Zero rather than written beside it. The hall itself carries no
attack, Quick Strike, target acquisition, enemy AI, damage, Life, Mana, loot, XP,
Passive, inventory, story, Mara, Nexus, Riftmarked presentation, procedural
generation, HUD, save, or settings — each asserted absent **by member name** — and
every calibration fixture in it holds **zero collision objects**, so nothing there
can be hit, block movement, or change a locomotion result. It writes nothing to
disk at all.

**The two Prototype Zero files Gate 1A edited were edited only to delegate.**
`scripts/actors/prototype_player.gd` and `scripts/prototype_zero/prototype_zero.gd`
keep every public name they had, several as forwarding properties, and **no
timing, tuning, targeting, damage, camera, or movement value moved**. The proof is
that the whole Gate F → A chain reproduces 1008 / 713 / 230 / 209 / 106 unchanged,
and `tests/gate_1a_scale_hall_smoke.sh` runs it first for exactly that reason.
