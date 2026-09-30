# `game3d_boss_spike/` — Riftwrought Boss Animation Feasibility Gate

> # THIS IS A BOUNDED, ISOLATED FEASIBILITY GATE. IT COMPLETES NO PHASE.
>
> **State: ACCEPTED and CLOSED following owner live review — D-369, 2026-09-17.**
>
> *(It was DELIVERED and OPEN under D-368 earlier the same day.)*
>
> **It is NOT:** the production pivot · proof that all bosses are feasible · a bespoke boss animation
> pipeline · final art · final animation · the Crownless Warden or any canonical boss · an Act I encounter ·
> P2 · a completed phase.
>
> **It authorizes nothing.** Every further step needs its own explicit owner ruling, exactly like every phase
> before it. **Its acceptance (D-369) validated a bounded WORKFLOW for an early-game humanoid boss; it
> authorized no production and locked no value.**

> ## What the owner's live review decided — D-369
>
> **ACCEPTED and CLOSED.** ***"The prototype successfully proves a bounded workflow for a prologue or Act 1
> humanoid boss."*** The three attacks are ***"distinguishable when I pay attention"***; ***"None of the
> attacks felt confusing"***; the encounter ***"reads sufficiently as a boss prototype"***; and the owner
> would be ***"comfortable building early humanoid bosses through this workflow without personally modelling
> or animating."***
>
> **THE SCOPE BOUNDARY IS PART OF THE RULING, NOT A CAVEAT ON IT.** It proves feasibility **only for an
> early-game humanoid boss using this production pattern**. **It does NOT prove final boss quality. It does
> NOT prove non-humanoid bosses. It does NOT prove later or harder bosses**, which will need more mechanics,
> abilities, phases and potentially commissioned signature animations. **No weapon placement, boss scale,
> timing, damage, VFX, camera value or tuning value becomes a production lock.** **No production phase and
> not P2 is authorized by this acceptance.**
>
> ### THREE ACCEPTED DEBTS — carried, and NOT to be fixed here
>
> 1. **The boss's axe and shield attachments are positioned incorrectly** and do not currently make visual
>    sense.
> 2. **The player probe's bow attachment is also positioned incorrectly.**
> 3. **Attack readability is adequate for the prototype only** — production versions must communicate
>    clearly **without requiring unusually close attention**.
>
> **The owner's instruction: *"These are later attachment/presentation-polish problems, not blockers for this
> feasibility gate. Do not modify the accepted spike merely to fix these issues."*** They return to a later,
> separately authorized presentation-polish pass. **Do not repair them here.**
>
> *Note on the orientation debt, recorded because it is cheap now and expensive to rediscover: the
> attachments were oriented by a **measured sweep** of each candidate's world-space vertical extent — not by
> eyeballed angles — **and they are still wrong.** "Tallest world-space extent" is a poor proxy for "held
> correctly", and a future pass needs a better criterion than the one used here.*

> ## This project is now PRESERVED, not continued
>
> **D-369 was a documentation-and-status ruling. No script, scene, tuning constant, third-party asset,
> evidence capture or accepted measurement was modified to earn the closure**, and **every file here except
> this README is byte-identical to the state the owner reviewed.**
>
> **Consequence, declared rather than hidden: the runtime, the verification suite and the runner still print
> "DELIVERED and OPEN pending owner live review".** Changing that string means editing
> `scripts/gate_config.gd`, which would force the suite's truthfulness pins and the runner's `EXPECT` line to
> be re-pinned and the chain re-run — **precisely the "modify the artifact to earn its own closure" the owner
> forbade.** The suite in fact *asserts* that string is present, so "fixing" it would turn a green suite red
> and require loosening a truthfulness guard to make the acceptance fit.
>
> **That string is the state the artifact was ACCEPTED IN. The current state is ACCEPTED and CLOSED, and it
> is carried by the documentation, not by the frozen runtime.** **Do not "fix" it** — editing an accepted,
> closed artifact needs its own ruling, exactly as for `game/`, `game2d/` and `game3d_spike/`.

> ## Why it exists
>
> D-367 accepted the D-366 3D feasibility spike and validated the visual direction — but recorded that
> **custom boss creation and bespoke boss animation remain UNPROVED**, because that spike's enemies were
> *"stock rigs driven by a stock animation library, reused unchanged — which is exactly what a boss is not."*
> It recommended a **Boss Animation Feasibility Gate** and explicitly **did not authorize one**.
>
> **The owner authorized it on 2026-09-17.** This is that gate.

---

## 1. The one question, in five parts

The gate exists to answer the owner's five questions and nothing else:

1. **Can this stock rig and existing animation corpus produce a boss that feels distinct from an ordinary
   Puglin?**
2. **Are all attacks readable at the accepted fixed-isometric framing?**
3. **Can the workflow be maintained without Ladislav modelling or animating?**
4. **Which parts still require commissioned signature animation?**
5. **What does this prove for humanoid bosses, and what does it explicitly NOT prove for non-humanoid
   bosses?**

**The gate measures and presents. It does not grade itself.** The felt judgments are the owner's, and they
are printed as **DEFERRED** rows on every run — never as passes.

## 2. Run it

```bash
# headless verification only (the default — rendered runs are opt-in)
./tests/boss_gate_smoke.sh

# verification plus the six native 1920x1080 evidence captures
./tests/boss_gate_smoke.sh --with-evidence

# play it
/Applications/Godot.app/Contents/MacOS/Godot --path . --resolution 1920x1080
```

Set `BOSS_GATE_BASELINE_DIR` to a directory holding `baseline_game.sha256`, `baseline_game2d.sha256`,
`baseline_game3d_spike.sha256` and `baseline_quaternius.sha256` to have the runner assert isolation as well.

**Controls.** `WASD` / left stick move · mouse aims (independent of movement) · `LMB` / right trigger fires
the one diagnostic arrow · mouse wheel zooms within its bounds · `F2` toggles the debug overlay · `R`
restarts the encounter.

## 3. What the boss actually is

**A stock Quaternius Bestiary Puglin** — unmodified mesh, unmodified 55-joint rig, **zero animations of its
own** — driven entirely by **stock clips from the CC0 Universal Animation Library 1 and 2**, recomposed by
timing, playback speed, blending, procedural layers, VFX, lighting and sound hooks.

**NOT ONE KEYFRAME IN THIS PROJECT IS AUTHORED.** No custom modelling, no hand-authored keyframes, no
AI-generated production art, no paid assets. The verification suite asserts all four.

### 3.1 Boss identity does NOT come from scale

**The owner's instruction was explicit, and the measurement backs it up: the Puglin's posed height is
1.2079 m, which is SHORTER than the Imp's 1.4407 m.** There was never an imposing mesh to lean on.

**Seven non-scale axes were measured to hold** (four were required):

| Axis | Boss | Ordinary Puglin control |
| --- | --- | --- |
| Silhouette attachments | **2** — `Axe_Double@hand_r`, `Shield_Heater@lowerarm_l` | **0** |
| Telegraph shape vocabulary | **3 classes** — CONE / ANNULUS / LINE | **1** — a plain DISC |
| Attacks | **3** | **1** |
| Stagger policy | **poise-gated**; a light hit is felt but does **not** interrupt | flinches on **every** hit |
| Encounter phases | **2** | **1** |
| Anticipation | **playback-speed-shaped** (×0.30–×0.32 windup → ×1.55–×1.80 release) | single rate |
| Continuous yaw turn rate | **220 °/s**, weighty | 480 °/s |
| Albedo | pack variant **2** (rust) + violet Rift emission + procedural shard crown | the mesh's own variant **1** (olive) |

**Scale ×2.50 is applied as SUPPORT and is declared as such in code and on screen.**

### 3.2 The three attacks

**The owner's constraint:** *"The three attacks must not be distinguished merely by damage numbers or
differently sized circles. Their anticipation, timing, motion and danger area must be visibly different."*

| | A1 "Sweep" | A2 "Slam" | A3 "Lance" |
| --- | --- | --- | --- |
| **Danger area** | **CONE**, 150° × 4.6 m | **ANNULUS**, 1.8 → 6.0 m — **with a safe hole at the centre** | **LINE**, 1.5 × 13.0 m |
| **Source clip** | `Sword_Regular_B` (UAL2) | `TreeChopping` (UAL2) | `Spell_Simple_Enter` → `Spell_Simple_Idle` → `Spell_Simple_Shoot` (UAL1) |
| **Motion** | horizontal sweep | vertical overhead | stationary channel |
| **Windup, MEASURED LIVE** | **0.8500 s** | **1.7167 s** | **2.2667 s** |
| **Yaw** | tracks to the commit | tracks to the commit | **commits at 70 % of the windup** |

**Minimum pairwise windup separation: 0.5500 s.** Three different geometric classes, three different source
clips, three different motions — and the distinctness assertion **never reads damage at all**.

### 3.3 The phase transition

At 55 % health the boss plays **`Idle_Shield_Break` (UAL2)** — a clip whose *real meaning* is exactly what is
shown. **The shield leaves the arm and is reparented into the arena, lying on the ground.** It is **dropped,
not hidden**, because hiding it would be the cheaper trick and the rendered evidence would expose it.

The change is **permanent**: silhouette attachments go 2 → 1, emission 2.4 → 5.2, windups × 0.78, cooldowns
× 0.70, and two Imps are summoned. The boss is **invulnerable during the transition and provably not after**.

### 3.4 The death sequence

**`Death01` (UAL1), 2.4000 s, played to completion** — the truthful source animation, measured against the
`Animation`'s own reported length rather than a constant.

> **This DISCHARGES the D-366 `D02` gap.** That gap was a **UAL2-only** limitation: UAL2 has no death clip,
> **UAL1 does**, and it is the **only** death clip in the combined 85-clip corpus. The gate plays it rather
> than substituting a code-driven topple.

## 4. What this gate does NOT prove — stated, not hidden

| | |
| --- | --- |
| **Non-humanoid bosses** | **EXPLICITLY NOT PROVED AND NOT PROVABLE FROM THIS CORPUS.** Measured: the Ultimate Monsters **Dragon** rig is **13 joints** with **1 exact / 2 case-insensitive** name matches against the UAL 65, and **12 bones the corpus cannot drive**; **PinkBlob** is **4 joints** with **1** match. Each non-humanoid ships its **own 8–9 clips** and **there is no shared library for them.** **NOTHING HERE MAY BE CITED FOR THEM.** |
| **Bespoke boss animation** | **TRANSFERRED, not discharged.** The gate proves **COMPOSITION of stock clips**. Eight specific needs cannot be met by the corpus at all — see `scripts/gate_config.gd` `COMMISSION_REQUIRED` |
| **Whether it READS** | **OWED TO THE OWNER.** The gate measures projected pixel extents and renders the evidence; the perceptual verdict is not its to make |
| **Audio** | **SOUND HOOKS ONLY.** 12 named hooks, **9 fired in the verified run, ZERO audio assets.** `CLAUDE.md` §12 forbids new audio, and the gate never claims audio works |
| **Controller hardware** | The input path is mapped and asserted; no gamepad can be attached in this environment |

### 4.1 An honest visual limitation, recorded rather than smoothed

**The axe and shield are only faintly legible at the accepted 14 m framing.** They read clearly in the
close overhead-chop capture and weakly in the wide comparison capture. **Scale, colour variant and the
violet shard crown carry the boss's identity at this framing far more than the weapon silhouette does.**
That is a finding for the owner's review, not a defect the gate hid.

**Also measured:** at maximum player range the Lance's 13 m corridor and its caster **do not sit comfortably
in one frame** at this zoom. Each telegraph individually fits the viewport (measured), but that combination
does not.

## 5. Everything here is PROVISIONAL

**No number in this project is a lock, and none may be cited as one.** `scripts/gate_config.gd` says so at
the top of the file, and the runtime says so on screen.

- **No 2D lock is promoted.** The accepted 2D prototype's owner locks (D-356) belong to `game2d/`.
- **No `game3d_spike/` value is promoted either.** The **−52° pitch**, the **11.0–18.0 m zoom bounds** and
  **1920 × 1080** are carried forward as the provisional starting point the owner asked for.
  **D-367: PRAISE IS NOT A LOCK.**
- **3.889 m/s is used as D-367's NEXT PROVISIONAL STARTING CANDIDATE and nothing more** — *"not a value, not
  a target and not a lock."* **This gate does not tune it and does not settle it.**

## 6. Layout

| Path | What it is |
| --- | --- |
| `project.godot` | 1920 × 1080 comparison output; keyboard + controller input map |
| `scenes/main.tscn` | One node carrying `gate_main.gd`; everything else is built in code |
| `scripts/gate_config.gd` | **Every provisional value, labelled provisional**, plus the clip map and the commission list |
| `scripts/rig_compat.gd` | **Measured** rig compatibility, the merged corpus, derived clip attribution, the non-silent clip guard |
| `scripts/anim_director.gd` | **The composition layer** — timing, blending, playback speed, procedural tracking / recoil / leaning |
| `scripts/boss_puglin.gd` | The boss: three attacks, two phases, poise-gated stagger, truthful death, continuous yaw |
| `scripts/ordinary_enemy.gd` | **The ordinary Puglin CONTROL** and the Imp minions |
| `scripts/telegraph.gd` | Three danger-area geometry classes, each its **own single source of truth** for drawing *and* resolution |
| `scripts/player_probe.gd` | A placeholder body — **not the Huntress** — and the one diagnostic projectile |
| `scripts/arena.gd` | A fixed arena on the ruins pack's **measured** module grid |
| `scripts/iso_camera.gd` | The carried provisional framing; rotation re-asserted **every frame** |
| `scripts/gate_hud.gd` | **The debug overlay** — the exact live source clip, its library, and the design name kept separate |
| `tests/boss_gate_verification.gd` | **67 EXECUTABLE CHECKS + 7 deferred rows**, owed-vs-reached compared both ways. *(The pre-implementation inventory owes **98 CRITERIA**, a different unit: 72 are discharged by this suite — one check consolidates the seven truthfulness denials — 24 by the runner, provenance record and direct inspection, and 2 were OWED-TO-OWNER and discharged at the D-369 live review. **72 + 24 + 2 = 98.** The 67th check is a test-seam guard the inventory never listed. Full map in the inventory's ADDENDUM.)* |
| `tests/boss_gate_smoke.sh` | The runner: error guard, both-direction count pins, truthfulness scans, isolation, evidence |
| `evidence/*.png` | Six native 1920 × 1080 captures **from the actual Godot render** |
| `assets/third_party/quaternius/` | The imported subset, its six licences and its provenance record |

## 7. Third-party assets

**Riftwrought claims no ownership of any of it.** Six Quaternius packs: **five CC0**, and **Bestiary under
QAL v1.0**, which permits commercial use and modification but **forbids redistributing the assets themselves
as assets**. **The Bestiary pack supplies this gate's headline creature**, so that restriction is more
load-bearing here than in the D-366 spike, and it is recorded in full in
`assets/third_party/quaternius/SOURCE_AND_LICENSE.md`.

**Ultimate Monsters is EXCLUDED from visual acceptance and is NOT imported.** The non-humanoid measurement
in §4 was taken by text-parsing two of its glTF files in a throwaway scratchpad probe **outside the
repository** — a measurement, not an import. The runner asserts the absence.

## 8. Isolation

- **`game/`, `game2d/` AND `game3d_spike/` are all byte-identical** to their pre-gate state. Asserted by the
  runner, not assumed. **No exception is declared for any of them.**
- **`game3d_spike/` gets no courtesy cross-reference note.** It is an **accepted, closed artifact** (D-367
  §5.1) and is **preserved, not continued**. The easiest mistake in this whole gate would have been a
  friendly one-line edit to its README, so the runner fails on any change to it.
- **The eleven source archives under `assets/Quaternius Assets/` are unmodified.**
- **No `.pxo` was opened, read, hashed, copied, converted, moved, modified, listed or enumerated.**
- **Zero audio assets.** **Zero art or animation files outside `assets/third_party/`.**
- **Nothing was committed or pushed.**
- **No workflow, subagent, review agent, mutation probe or adversarial campaign was used.**

## 9. Read before changing anything here

`CLAUDE.md` §1.2, §12 and §12.1 · `docs/DECISION_LOG.md` **D-366, D-367, D-368 and D-369** ·
`docs/testing/D368_BOSS_GATE_OWED_CHECK_INVENTORY.md` (including its **ADDENDUM**) ·
`docs/testing/D368_BOSS_ANIMATION_FEASIBILITY_GATE_REPORT.md` ·
`docs/testing/D369_BOSS_GATE_ACCEPTANCE_AND_CLOSURE_REPORT.md`.

**`game2d/` remains the accepted 2D mechanics prototype, and `game3d_spike/` remains the accepted, closed 3D
feasibility spike. Neither is superseded by this.**
