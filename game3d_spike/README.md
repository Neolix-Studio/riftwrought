# `game3d_spike/` — Riftwrought 3D Feasibility Spike

> # THIS IS A BOUNDED, ISOLATED FEASIBILITY SPIKE. IT COMPLETES NO PHASE.
>
> **State: ACCEPTED and CLOSED following owner live review — D-367, 2026-09-17.**
>
> **It is NOT:** the final Huntress · final art · the 3D production project · P2 · a completed pivot.
>
> **It authorizes nothing.** No production pivot, no art pass, no asset pipeline, no phase. Every further
> step needs its own explicit owner ruling, exactly like every phase before it.

> ## What the owner's live review decided — D-367
>
> **VALIDATED:** *"This visual direction is Riftwrought."* Modern stylized fixed-isometric 3D is the
> **validated** intended visual direction. The **asset family is suitable as a production FOUNDATION**;
> ordinary environmental surfaces **recede sufficiently**; the **−52° pitch** and the **bounded zoom range**
> were judged right; **crowd readability holds at 24 enemies**; and the workflow is **maintainable without
> the owner personally modelling routine environments, characters and ordinary enemies**.
>
> **DECIDED — facing: CONTINUOUS 3D YAW.** The pixel-art prototype's eight-direction facing restriction is
> **not** carried forward. This decides a design direction and **authorizes no implementation**.
>
> **JUDGED — speed: 5.0 m/s is somewhat too fast.** **No replacement speed is locked.** **3.889 m/s is
> carried forward ONLY as the next PROVISIONAL starting candidate for later combat tuning.**
>
> **UNPROVED — custom boss creation and bespoke boss animation.** The enemies here are **stock rigs driven
> by a stock library, which is exactly what a boss is not.** A **Boss Animation Feasibility Gate** is
> **RECOMMENDED and NOT AUTHORIZED**, and **this spike must never be cited as evidence that bosses are
> feasible.**
>
> **THE ACCEPTANCE DOES NOT:** declare the placeholder Huntress, the enemies or the Quaternius assets final ·
> complete original P1C, P1 or P2 · authorize full production · authorize the boss gate · discharge the
> three animation gaps · **or convert any camera, zoom, speed, lighting or combat number into a permanent
> product lock.** **Praise is not a lock** — the pitch and zoom bounds were praised and remain provisional.

> ## This project is now PRESERVED, not continued
>
> **D-367 was a documentation-and-status ruling. No gameplay, tuning, scene, third-party asset or accepted
> measurement was modified to earn the closure**, and **every file here except this README is byte-identical
> to the state the owner reviewed.**
>
> **Consequence, declared rather than hidden: the runtime and the verification suite still print "DELIVERED
> and OPEN pending owner live review".** That is the state the artifact was **accepted in**. **The current
> state is ACCEPTED and CLOSED, and it is carried by the documentation, not by the frozen runtime.** Do not
> "fix" the runtime string to match — editing an accepted, closed artifact needs its own ruling, exactly as
> it does for `game/` and `game2d/`.

---

## 1. What it is for

A bounded test of **six** things, and nothing else:

1. **Godot import and rig compatibility;**
2. **character / outfit / animation assembly;**
3. **fixed-isometric 3D camera and scale;**
4. **lighting / material treatment;**
5. **combat readability and approximate crowd density;**
6. **whether this workflow is maintainable without owner-authored modelling.**

It was authorized by the project owner on **2026-09-17** as Stage B of D-366, alongside the bounded canonical
reconciliation of the visual target (Stage A).

## 2. Run it

```bash
# headless verification only (the default — rendered runs are opt-in)
./tests/spike_smoke.sh

# verification plus the five native 1920x1080 evidence captures
./tests/spike_smoke.sh --with-evidence

# play it
/Applications/Godot.app/Contents/MacOS/Godot --path . --resolution 1920x1080
```

Set `SPIKE_BASELINE_DIR` to a directory holding `baseline_game.sha256`, `baseline_game2d.sha256` and
`baseline_quaternius.sha256` to have the runner assert isolation as well.

**Controls.** `WASD` / left stick move · mouse aims (independent of movement) · `LMB` / right trigger fires
the diagnostic arrow · mouse wheel zooms within its bounds · `F2` toggles the 24-enemy debug density mode.

## 3. Everything here is PROVISIONAL

**No number in this project is a lock, and none may be cited as one.** `scripts/spike_config.gd` says so at
the top of the file, and the runtime says so on screen.

**No 2D measurement is inherited as a lock.** The accepted 2D prototype's owner locks (D-356) — 60.0 px/m,
the 128 × 128 cell, the 120 × 60 tile, the (64, 122) anchor, the fixed 32.00 × 18.00 m camera footprint and
rendering mode 7 — **belong to `game2d/` and are not promoted here.**

**1920 × 1080 is a comparison output for owner review, not a product lock.**

**The 5.0 m/s top speed is re-evaluated, not inherited.** The spike runs at 5.0 m/s so the owner can feel it
against a number they know, and prints the measured consequence beside it: this framing is 24.889 m wide
against the 2D prototype's locked 32.00 m, so the same metres-per-second reads **1.286× faster**, and the
framing-matched equivalent would be **3.889 m/s**.

> **ANSWERED at the D-367 live review: 5.0 m/s is somewhat too fast.** **No replacement speed is locked**,
> and **the runtime here deliberately still runs at 5.0 m/s** because D-367 changed no tuning value.
> **3.889 m/s is carried forward ONLY as the next PROVISIONAL starting candidate for later combat tuning** —
> a starting point for a future tuning pass, **not a value, not a target and not a lock.**

## 4. What the third-party packs could NOT supply — stated, not hidden

These were **measured** against all 43 clips of Universal Animation Library 2 (Standard/FREE), and they are
printed on every run and on screen:

| Gap | What the spike does instead |
| --- | --- |
| **No bow / archery / aim / draw / shoot clip** (0 of 43) | The attack plays `OverhandThrow`, which is **a THROW, not a bow draw**, and is **labelled a placeholder in code and on screen**. It is **not** presented as a bow animation |
| **No death clip** (0 of 43) | Enemy death is a **code-driven topple-and-sink**, explicitly not an animation |
| **No neutral walk or run** | `Walk_Carry` (a **carry** walk) is used and named truthfully |
| **The free base character is one full-body mesh** | The outfit pack says to use *"only the head"*; in the free tier the head is not separable, and editing source meshes is forbidden here. **The full base body is therefore never instantiated**, which achieves the instruction's purpose — no hidden body, no clipping |

Each is recorded as **DEFERRED** by the verification suite, with the place it must return to. **None is
recorded as a pass.**

## 5. Layout

| Path | What it is |
| --- | --- |
| `project.godot` | 1920 × 1080 comparison output; keyboard + controller input map |
| `scenes/main.tscn` | One node carrying `spike_main.gd`; everything else is built in code |
| `scripts/spike_config.gd` | **Every provisional value, labelled provisional** |
| `scripts/rig_assembly.gd` | Outfit + UAL2 assembly, the non-silent clip guard, material treatment |
| `scripts/huntress_spike.gd` | The **placeholder** Huntress — ground-point actor, aim, the one diagnostic projectile |
| `scripts/enemy_spike.gd` | The Imp — idle / chase / windup / hit / death |
| `scripts/courtyard.gd` | The ruined courtyard, assembled on the pack's own 2.0 m module grid |
| `scripts/iso_camera.gd` | Fixed orthographic isometric camera; rotation re-asserted **every frame** |
| `scripts/telegraph_ring.gd` | The ground danger marker |
| `scripts/spike_hud.gd` | The on-screen provisional / truthfulness labelling |
| `tests/spike_verification.gd` | **25 owed checks + 5 deferred rows**, owed-vs-reached compared both ways |
| `tests/spike_smoke.sh` | The runner: error guard, both-direction count pins, isolation, evidence |
| `evidence/*.png` | Five native 1920 × 1080 captures **from the actual Godot render** |
| `assets/third_party/quaternius/` | The imported subset, its licences and its provenance record |

## 6. Third-party assets

**Riftwrought claims no ownership of any of it.** Six Quaternius packs: **five CC0**, and **Bestiary under
QAL v1.0**, which permits commercial use and modification but **forbids redistributing the assets themselves
as assets**. Full per-pack records — pack name, source URL, acquisition date, original archive, imported
files and licence — are in `assets/third_party/quaternius/SOURCE_AND_LICENSE.md`.

**Stock low-poly geometry is not presented as final production art.** All colour treatment is a **runtime
material override**; **no source mesh was edited**.

## 7. Isolation

- **`game/` is byte-identical** to its pre-spike state and **`game2d/` is byte-identical** (1,490 and 579
  files respectively). Asserted by the runner, not assumed.
- **The nine source archives under `assets/Quaternius Assets/` are unmodified.**
- **No `.pxo` was opened, read, hashed, copied, converted, moved, modified, listed or enumerated.**
- **Nothing was imported into `game/` or `game2d/`.** *(Note: `game/assets/third_party/quaternius/` already
  existed with 14 files of the same Ultimate Modular Ruins pack — it is pre-existing accepted content, is in
  the pre-spike baseline, and was not touched. The runner pins that set.)*
- **Nothing was committed or pushed.**
- **No workflow, subagent, review agent, mutation probe or adversarial campaign was used.**

## 8. Read before changing anything here

`CLAUDE.md` §1.2 and §12.1 · `docs/DECISION_LOG.md` **D-365 and D-366** ·
`docs/testing/D366_STAGE_B_OWED_CHECK_INVENTORY.md` · `docs/testing/D366_3D_FEASIBILITY_SPIKE_REPORT.md`.

**`game2d/` remains the accepted 2D mechanics prototype and is preserved, not superseded by this.**
