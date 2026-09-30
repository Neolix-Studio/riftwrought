# Riftwrought — `game2d/` (the accepted 2D mechanics prototype)

**This is the separate sibling 2D Godot project accepted under D-347 ruling 1 and created under the P1A
authorization. It now holds three accepted foundations — P1A, P1B and P1C-H — and nothing else.**

> ## PRESERVED AND FROZEN — D-365 (2026-09-17)
>
> **`game2d/` is PRESERVED as the accepted 2D mechanics prototype.** **2D presentation work and owner-art
> production are FROZEN** until the owner rules otherwise.
>
> **The intended final visual target is no longer traditional/retro pixel art.** It is a **modern stylized 3D
> dark-fantasy ARPG** — fixed orthographic isometric camera with optional gentle zoom, smooth animation,
> painterly materials, readable environments, dynamic lighting, vivid supernatural effects.
>
> **Everything in this folder remains VALID prototype and reference material. Nothing here is rejected,
> deprecated or deleted** — the same rule the project applies to its accepted 3D work. The mechanics it
> proved are dimension-independent; the pixels it proved are properties of this prototype.
>
> **NO FULL 3D PIVOT IS AUTHORIZED.** *(This clause read "NO FULL 3D PIVOT AND NO 3D IMPLEMENTATION SPIKE IS
> AUTHORIZED" until **D-366, 2026-09-17**, when the owner authorized ONE bounded spike. **That wording was
> true when written.**)* Each further step needs its own separate bounded authorization.
>
> **The Huntress top speed of 5.0 m/s is PROVISIONAL**, not a permanent cross-presentation lock. **D-366
> re-evaluated it rather than inheriting it:** measured, the same 5.0 m/s reads **1.286× faster** in the
> spike's provisional framing than inside this prototype's **locked 32.00 m** footprint, and the
> framing-matched equivalent would be **3.889 m/s**. **Which value is right is an OPEN owner judgment.** The
> suite prints this every run.

> ## D-366 (2026-09-17) — this folder is UNCHANGED, and that was verified
>
> **A bounded 3D feasibility spike was delivered under `game3d_spike/`.** **Nothing in `game2d/` was
> continued, reopened, ported or superseded by it**, and **no P1A, P1B or P1C-H lock, pin, hash, ceiling or
> accepted debt moved.**
>
> **This tree was asserted byte-identical to its pre-spike state — 579 files, manifest digest
> `10ef30560e0376ff1da9dcc157101c99695e54b5179bea117052e52e39868bd2` — with this README as the single
> declared, status-only exception.**
>
> **No 2D lock was promoted into the spike.** 60.0 px/m, the 128 × 128 cell, the 120 × 60 tile, the
> (64, 122) anchor, the fixed 32.00 × 18.00 m footprint and rendering mode 7 remain **locks of THIS
> prototype**, and the spike says so in its own configuration. **`1920 × 1080` in the spike is a comparison
> output, not a product lock.**
>
> **The spike is NOT a continuation of this work and NOT a replacement for it.** It is not the final
> Huntress, not final art, not the 3D production project, not P2, not a completed pivot, and not acceptance
> of any third-party asset style.

> ## D-367 (2026-09-17) — the spike was ACCEPTED; ONE ruling changes how this folder is READ
>
> **The owner accepted and closed the 3D feasibility spike after a live review and validated the modern
> stylized fixed-isometric 3D direction.** **Nothing in this folder changed, and nothing in it is revoked:
> every P1A, P1B and P1C-H lock, pin, hash, ceiling and accepted debt stands exactly as accepted.**
>
> **The one ruling that reaches this folder is about how its facing contract is READ going forward:**
>
> > **CONTINUOUS 3D YAW is the chosen direction. The eight-direction facing restriction is NOT carried
> > forward out of this prototype.**
>
> **That does not diminish anything here.** The eight explicitly drawn directions, the no-mirroring rule and
> the shared (64, 122) anchor **remain the correct, accepted contract of THIS prototype**, and the art that
> satisfies them **remains valid prototype and reference material**. What the ruling forbids is **carrying
> the quantised facing restriction forward into a 3D context as though it were a gameplay requirement** —
> it was a consequence of sprites never being rotated, and that premise does not survive the medium.
>
> **No-mirroring is unaffected:** it is a rule about **asymmetric equipment**, not about sprites, and
> continuous yaw does not license mirroring.
>
> **2D presentation work and owner-art production remain FROZEN.**

> **P1A is ACCEPTED AND CLOSED under D-356** — by the owner, after a live rendering comparison at the locked
> base that no automated suite can perform. **A green runner is still not acceptance**, and the suite says so
> in its own output: it guards what the ruling locked, it does not grant the ruling.
>
> **LOCKED:** rendering mode **7** (display-pinned fractional fill) · base viewport and default output
> **1920 × 1080** · **60.0 px/m** · **128 × 128** character cell · ground anchor **(64, 122)** ·
> **120 × 60** isometric tile = 1 m². The visible world is **fixed at 32.00 × 18.00 m at every output size**;
> a bigger or wider monitor never earns extra world space.
>
> **P1B — the Wroughtstone 2D Proof Kit — is ACCEPTED and CLOSED under D-362**, and `game2d/` now holds
> both accepted foundations. It carries **two accepted, ceilinged debts** — terrain-edge transparency at tile
> seams (acceptance **conditional on the current rendering arrangement**) and the brighter path slate —
> measured every run and **compensated for nowhere**.
>
> **P1C-H — the Huntress-first substage authorized under D-364 — is ACCEPTED and CLOSED under D-365**, as
> the verified 2D mechanics prototype. **The ORIGINAL P1C is NOT complete:** its Mage spell criterion (C9)
> and its "both characters" scope are **DEFERRED** to the future Mage art phase and are printed every run as
> TRANSFERRED, never as passes.
>
> **P1C-H's acceptance completes neither P1C nor P1, and authorizes no P2.** No acceptance here authorizes a
> complete zone tileset, a campaign zone, Act production or a class specification.

**It is a mechanics prototype, not a game and not a vertical slice.** It displays the owner's own exported
Mage and Huntress idle frames and measures them (P1A); it builds the Wroughtstone `TileSet` and
`TileMapLayer` foundation from three owner proof tiles (P1B); and it proves movement, collision, navigation,
click-to-move, controller movement, eight-way facing with hysteresis, per-use aiming, controller soft
targeting, one **explicitly diagnostic, non-canonical** projectile, one enemy cycle and one dropped item
(P1C-H). It opens on the canonical mode 7; the others remain diagnostic comparators.

**There is no campaign zone, no Act content, no complete tileset, no designed Skill, no class specification
and no endgame system, and the runtime says so on screen.**

The acceptance record is
[`../docs/testing/P1A_ACCEPTANCE_AND_CLOSURE_REPORT.md`](../docs/testing/P1A_ACCEPTANCE_AND_CLOSURE_REPORT.md).
The delivery records that led to it are
[`../docs/testing/P1A_CHARACTER_SCALE_AND_RENDERING_REPORT.md`](../docs/testing/P1A_CHARACTER_SCALE_AND_RENDERING_REPORT.md),
[`../docs/testing/P1A_SUPPLEMENTAL_HUNTRESS_SCALE_AND_FILL_REPORT.md`](../docs/testing/P1A_SUPPLEMENTAL_HUNTRESS_SCALE_AND_FILL_REPORT.md),
[`../docs/testing/P1A_HUNTRESS_EIGHT_DIRECTION_VALIDATION_REPORT.md`](../docs/testing/P1A_HUNTRESS_EIGHT_DIRECTION_VALIDATION_REPORT.md),
[`../docs/testing/P1A_HUNTRESS_ANCHOR_AND_SCALE_CORRECTION_REPORT.md`](../docs/testing/P1A_HUNTRESS_ANCHOR_AND_SCALE_CORRECTION_REPORT.md)
and
[`../docs/testing/P1A_HUNTRESS_REGISTRATION_VALIDATION_REPORT.md`](../docs/testing/P1A_HUNTRESS_REGISTRATION_VALIDATION_REPORT.md).
The design canon lives above this folder and is not duplicated here.

## Why this is a separate project

Measured, not stylistic. Eight accepted runners under `../game/` take a whole-subtree production digest over
`scripts scenes data addons assets project.godot`, so **any** new file under those subtrees turns them red
until a bounded D-343 cascade re-pins them. Separately, `../game/project.godot` sets no
`default_texture_filter` and no `scale_mode`, and integer scaling cannot be set per node. In the owner's
words, a separate project *"prevents routine 2D iteration from creating accepted-suite reconstruction
cascades inside `game/`."*

**`../game/` is byte-identical and its every accepted suite still passes.** `tests/p1a_smoke.sh` re-proves
that on every run.

## What is locked here, and what is not

> *Historical note: until D-356 this section read "Nothing here is locked", because P1A's job was to measure
> and offer rather than decide. **The owner decided on 2026-09-16.** The text below replaces it; the earlier
> wording is preserved in the Decision Log, not here.*

**LOCKED by the owner under D-356** — rendering mode **7**, base viewport and default output
**1920 × 1080**, **60.0 px/m**, the **128 × 128** character cell, the ground anchor **(64, 122)**, the
**120 × 60** isometric tile and the **fixed 32.00 × 18.00 m** camera footprint. `project.godot`'s `[display]`
section now encodes product decisions, not comparison defaults. **Do not re-open, re-derive or "improve" any
of them without a new ruling.**

**NOT locked:** the optional player-facing pixel-perfect / integer presentation mode (allowed, unauthorized,
unimplemented); **the Huntress top speed of 5.0 m/s, which D-365 kept PROVISIONAL**; and the simplified
lower-complexity environment treatment recorded under D-361, which is a future art-direction note only.

**Integer-only scaling was never made a product requirement** (D-347 sub-ruling C). Mode 7 is a *fractional*
fill, which is precisely the freedom that sub-ruling preserved — it was obeyed, not overturned.

## Run it

Open the comparison tool:

```bash
/Applications/Godot.app/Contents/MacOS/Godot --path game2d
```

| Key | What it does |
| --- | --- |
| `1` … `7` | rendering approach — `1` integer viewport (keep) · `2` pixel-snapped canvas **(rejected by the owner; kept as a comparator)** · `3` **SubViewport + sub-pixel remainder (provisionally preferred)** · `4` integer viewport (expand) · `5` SubViewport filled to the window, remainder at sub-device-pixel precision · `6` the same, remainder snapped to whole device pixels · `7` the same, display rect pinned |
| `TAB` or `C` | switch character — Mage ↔ Huntress |
| `←` `→` (or `Q` `E`) | previous / next of the eight facings |
| `D` | cycle the density candidate — **B** (64.0 px/m, 128 cell) · **C** (60.0 px/m, 128 cell) · **A** (32.0 px/m, 64 cell — *rejected for production, retained as diagnostic*) |
| `A` | cycle the shared ground anchor — the cell centre below the ground row · **the provisional `(64, 122)`** · the measured drawn-feet centre. **Every one is a single constant applied to every frame** |
| `B` | cycle the candidate base resolution |
| `R` | cycle the window resolution, starting from the one discovered on the owner's own display |
| `SPACE` | run the deterministic five-second diagonal pan |
| `M` | ground-point, shadow and stance markers on/off |
| `H` | readout on/off |
| `ESC` | quit |

A controller works for the same commands through the d-pad, `A` and `B`. **No `InputMap` action is declared
anywhere in this project**, in either project — every key is read as a physical keycode.

## Verify it

**`p1c_smoke.sh` is the top of the chain: it runs the P1A and P1B suites inside itself.**

```bash
bash game2d/tests/p1c_smoke.sh
```

The two earlier runners can still be run alone:

```bash
bash game2d/tests/p1b_smoke.sh
```

```bash
bash game2d/tests/p1a_smoke.sh
```

**A plain invocation is headless only**: no window, no rendered frame, no image written. Rendered evidence is
opt-in, because a rendered run takes the owner's real pointer and keyboard while it is up:

```bash
bash game2d/tests/p1a_smoke.sh --shots docs/testing/p1a_scale_and_rendering_evidence --report docs/testing/p1a_scale_and_rendering_evidence/p1a_measurements.json
```

The supplemental Huntress capture chooses its own character, density and base:

```bash
/Applications/Godot.app/Contents/MacOS/Godot --path game2d --script res://tests/p1a_evidence.gd -- --out docs/testing/p1a_supplemental_huntress_evidence --density B --character huntress --base 1920x1080
```

## What is in here

| Path | What it is |
| --- | --- |
| `scripts/p1a_art.gd` | the two imported PNGs, the facing order, the SpriteFrames builder, and every measurement taken from the art |
| `scripts/p1a_scale.gd` | px/m derivation, the two density candidates, the camera footprint and the tile proposal |
| `scripts/p1a_render_mode.gd` | the seven compared rendering configurations and the arithmetic that describes each; **mode 7 is the locked one** |
| `scripts/p1a_pan.gd` | the deterministic five-second diagonal pan — a pure function of a frame index |
| `scripts/p1a_world.gd` | the diagnostic background: flat colour, metre grid, ruler, the one-pixel stripe shimmer probe, and one outline of the proposed tile |
| `scripts/p1a_actor.gd` | one displayed character whose node position is its GROUND POINT |
| `scripts/p1a_comparison_root.gd` | the comparison tool the owner opens |
| `scenes/p1a_comparison.tscn` | its scene |
| `scripts/p1b_terrain.gd` | Godot's **measured** terrain-connectivity facts — the four valid `MATCH_SIDES` peering bits, their cell and screen deltas, and the 16-mask inventory |
| `scripts/p1b_tileset.gd` | the Wroughtstone `TileSet`: the three owner proof tiles, the courtyard as a deliberately standalone tile, and the straight path's measured mask |
| `scripts/p1c_facing.gd` | the eight-way facing sector index and its stated 7° hysteresis margin |
| `scripts/p1c_movement.gd` | continuous acceleration and braking, the radial deadzone, and the **PROVISIONAL** 5.0 m/s top speed |
| `scripts/p1c_targeting.gd` | per-use aiming and controller soft targeting — **no lock-on, no retention, zero instance state by design** |
| `scripts/p1c_combat.gd` | the one **explicitly diagnostic, non-canonical** projectile, the enemy cycle and the dropped item |
| `scripts/p1c_room.gd` | the proof room built from the accepted P1B tiles, its navigation region, and the on-screen readout |
| `tests/p1a_verification.gd` | the headless automated verification — 30 checks, owed-set discipline, and explicit TRANSFERRED-DEBT rows that are never counted as passes |
| `tests/p1b_verification.gd` | 15 checks, the five-layout seam-coverage measurement with its accepted ceilings, and the two accepted debts |
| `tests/p1c_verification.gd` | 15 checks, plus the **two TRANSFERRED rows** (the Mage spell C9 and the "both characters" scope) that are never counted as passes |
| `tests/p1a_evidence.gd` | the opt-in rendered evidence capture, the character-stability probe, the base-resolution comparison and the comparison sheets. **It freezes the idle clip**, so that any frame-to-frame difference is a rendering difference and not the animation |
| `tests/p1b_evidence.gd` | the P1B rendered tiling and seam evidence |
| `tests/p1a_smoke.sh` · `tests/p1b_smoke.sh` · `tests/p1c_smoke.sh` | the three focused runners; `p1c` runs the other two inside it |
| `tools/p1a_report.gd` | the machine-readable measurement report |
| `tools/p1b_mask_inventory.gd` | the measured terrain-mask inventory dump |
| `assets/characters/` | byte-identical copies of the owner's character exports, with `ASSET_PROVENANCE.md` recording source and SHA-256 |
| `assets/environment/wroughtstone/` | byte-identical copies of the three accepted owner proof tiles, with their own provenance README |

`.godot/` is Godot's generated cache. It is git-ignored and **is never evidence**.

## The owner-art boundary

**Only owner-exported PNG files enter this project.** No Pixelorama `.pxo` source is opened, read, parsed,
converted, copied, moved or hashed, and no path here resolves to one. The verification proves it by
enumerating every file under `res://` against an allow-list that has no such extension on it, and the runner
re-proves that the two copies are byte-identical to the owner's own exports, which are unmodified.

**The SpriteFrames resources are built in code** by `P1AArt.build_sprite_frames()` from the imported PNGs, so
there is no `.tres` that can drift away from the measurement.

**Seven Huntress facings have no production export** — `idle_sw`, `idle_w`, `idle_nw`, `idle_n`, `idle_ne`,
`idle_e`, `idle_se`. The only eight-direction Huntress file is a **reference** image and, under D-349 ruling 5,
a generated image is never a production asset, so it is not imported and nothing is inferred from it.

## What the three accepted foundations do not authorize

**The deferred Mage-dependent remainder of the original P1C; P2; a canonical Huntress class specification;
any designed Skill; a Mage reconstruction or re-export; further 2D presentation work or owner-art production
(FROZEN under D-365); a full 3D pivot or any 3D implementation spike (D-365); the simplified environment art
direction recorded under D-361; a complete zone tileset; any campaign zone; any Act; any endgame system; and
any edit to `../game/`.** Each needs its own explicit owner ruling.

**A diagnostic action is not a designed Skill, accepted art is not a class specification, and an accepted
phase is never authorization for the next one.**
