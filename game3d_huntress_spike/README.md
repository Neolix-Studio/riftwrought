# `game3d_huntress_spike/` — Huntress Bow-Retargeting and Prey Feasibility Spike (D-388)

> # 🔶 DELIVERED and OPEN pending owner live review (D-388, 2026-09-19). Delivered is not accepted.
>
> **A bounded, isolated feasibility spike** — a **sixth** sibling Godot project. ***"This is not P2, not production
> implementation, not final Huntress art, not VFX intake, not tuning and not authorization to modify `game3d/` or any
> accepted project."***
>
> **It answers five questions on a live, rendered prototype, and only these:**
> 1. Can the KayKit bow animations be retargeted convincingly onto the current 65-joint Huntress?
> 2. Can the bow, hands, arrow and procedural string form a readable draw/release?
> 3. Does the accepted STOP / recovery-cancellation behaviour still feel correct with a real bow animation?
> 4. Is Prey understandable when switching between two targets?
> 5. Does a clearly labelled stand-in hound autonomously prefer the current Prey without pet micromanagement?
>
> **The runtime does not classify its own retargeting.** The delivery report does, against rendered evidence, and the
> owner's live review confirms or corrects it: `docs/testing/D388_HUNTRESS_SPIKE_DELIVERY_REPORT.md`.

> # ✅ ACCEPTED and CLOSED — D-389 (2026-09-19), as PROTOTYPE FEASIBILITY EVIDENCE
>
> ***"I accept D-388 and authorize its documentation-only closure as prototype feasibility evidence. Confirm the
> classification "viable for prototype only.""*** The banner above was true when written.
>
> - **Classification CONFIRMED: VIABLE FOR PROTOTYPE ONLY.** *"At normal gameplay zoom, the draw and release read well
>   enough"* — an **owner observation, not a lock.**
> - **FIVE ACCEPTED, NON-BLOCKING PRODUCTION-POLISH DEBTS — DO NOT FIX THEM HERE:** the static **finger** grip · the
>   rest-held **shoulders** · the **string** pop at the nock moment · the string crossing the **hood** in the recovery ·
>   **foot sliding** into and out of the stance. They are owed to a later, separately authorized production-polish pass.
> - **No playback rate, timing value, animation asset or production-quality standard is locked, and no next
>   implementation stage is authorized.** The project is **preserved, not continued.**
> - ⚠️ **ACCEPTED HISTORICAL STATE — DO NOT "FIX" IT.** The runtime, suite, runner and HUD still print *"DELIVERED and
>   OPEN pending owner live review (D-388)"*, the classification as OWED and O-01 … O-06 as OWED-TO-OWNER — **the state
>   the artifact was accepted in.** Only this README changed at acceptance. V01, V03, K04, K06 and K07 pin that state.
>
> See `docs/testing/D389_HUNTRESS_SPIKE_ACCEPTANCE_AND_CLOSURE_REPORT.md`.

## How to run it

```bash
/Applications/Godot.app/Contents/MacOS/Godot --path . --resolution 1920x1080
```

| Input | Action |
| --- | --- |
| **Left mouse, held** | **Click-to-move** — the accepted scheme. **No WASD** (`CLAUDE.md` §8) |
| **Mouse cursor** | **Aim** — continuous, independent of movement; sampled **per use** |
| **Right mouse, held** · pad **RT** | **The DIAGNOSTIC BOW SHOT** — *NOT Splinter Shot, NOT a Skill, NOT a roster entry.* Held input repeats, exactly as the accepted attack does |
| **C** · pad **X** | **Switch the visible body**: the retargeted Huntress ↔ the **native KayKit control** (a diagnostic comparator, **not** the Huntress). **Only visibility changes** — never the simulation |
| **T** · pad **B** | **Cycle the DIAGNOSTIC playback rate** ×0.50 · ×1.00 (authored) · ×1.50 · ×2.00 · ×3.00. It applies from the **next** use. **Not attack speed, not tuning** |
| **V** · pad **BACK** | Show / hide the **diagnostic close-up** — a second camera, bottom-left. **Starts hidden** |
| **F1** · pad **Y** | Show / hide the **developer overlay**. **Starts hidden** |
| Wheel · pad D-pad ↑↓ | The accepted bounded zoom |
| Pad left / right stick | Move / aim |

**What to try:** stand between the two targets; shoot **A** (round head), then **B** (square head) — Prey moves, the
ring and the word `PREY` move, and the hound follows. Walk towards **B** until **A** is more than 8 m from you — the
hound drops the Prey and takes **B** by itself, and the HUD says why. Move during the draw — nothing happens until the
arrow leaves; move right after it leaves — the recovery is cancelled and the arrow still hits. Press **C** mid-draw to
compare the bodies. Press **T** and draw again to judge readability at another rate. Press **V** to watch the hands.

## What it is made of

| Part | What it is |
| --- | --- |
| **The accepted controller — VERBATIM** | 11 modules copied **byte-for-byte** from `game3d/` (`scripts/core`, `control`, `view`, `world`, `combat`) and made **read-only**: click-to-move, continuous aim, the STOP commitment, the wind-up buffer, release-before-recovery, post-release cancellation. **The runner compares every one with `game3d/` on every run.** `HuntressSpikeProbe extends PlayerController` and overrides **exactly three** methods (`setup`, `_play`, `_update_attack_input`); the bow enters the accepted commitment through the accepted `commit_subsystem_action` seam |
| **The retarget** (`scripts/spike/bow_retargeter.gd`) | An **explicit map** in Godot's own vocabulary — two `BoneMap`s on one `SkeletonProfileHumanoid`: **19 pairs**, **2 derived** bones (`spine_02`, `neck_01`), **44 rest-held** Huntress bones, **4 unmapped** source bones — and a **rest-relative model-space rotation transfer**, faithful to **0.0000°** before corrections |
| **Bounded corrections** | a **static finger grip** · an **aim-line yaw** · the **derived spine / neck** · **hand-contact IK** (an analytic two-bone solve per arm that anchors the string hand at the jaw and the bow hand on the arrow line at full draw, **keeping the source's hand trajectory**). Each is named, switchable and measured |
| **Mechanical timing** (`scripts/spike/bow_pose_driver.gd`) | The pose is derived from the **accepted commitment's own mechanical time**. The release fires at `elapsed ≥ duration × marker`, and the driver uses **the same expression**, so the clip entering `Ranged_Bow_Release`, the arrow leaving the hand and the projectile appearing are **the same physics frame** at every diagnostic rate |
| **Bow, string, arrow** (`bow_presentation.gd`) | Quaternius `Bow_Wooden` with its rigid string surface **left out at runtime** and a **procedural string** that follows the drawing hand; the Quaternius `Arrow`, nocked from the measured nock moment until release |
| **The projectile** (`arrow_projectile.gd`, `impact_effect.gd`) | One per released use. **Trail and impact generated in code** — **no imported VFX**. Its gameplay path is always the **Huntress's**, whichever body is visible |
| **Prey** (`prey_state.gd`) | Designated **only by a direct arrow Hit**; one at a time; cleared by death or removal; no damage bonus, no auto-aim, no lock-on. **No timeout** — canon leaves its duration OWED |
| **The stand-in hound** (`stand_in_hound.gd`) | **Procedural primitives**, labelled **`DIAGNOSTIC HOUND STAND-IN — NO HOUND ART PROVEN`**. Autonomous; **no command path**. Prefers the Prey when it is within reach **of the Huntress** (a spike choice, not a ruling) and reachable by path; otherwise the nearest target, ties by name |
| **Review surfaces** | the compact HUD (six items only), the F1 developer overlay (hidden), the V close-up (hidden) |

## Intake — exactly 19 files, byte-for-byte, read-only

See `assets/third_party/SOURCE_AND_LICENSE.md` (verified against `scripts/spike/asset_manifest.gd`): the **8 Huntress
files** (copied from `game3d/`), **2 KayKit animation GLBs**, **1 KayKit `Ranger.glb`** (a **diagnostic native-rig
comparator only**), **4 Quaternius weapon files** (`Bow_Wooden`, `Arrow` and their `.mtl`), and **4 licence files**. All
**CC0**. **No VFX archive, no BattleFX, no Ultimate Monsters.** No directory is named exactly `quaternius`: all three
accepted `game3d/` runners pin that name repository-wide.

## Verification

```bash
./tests/huntress_spike_smoke.sh                  # headless
./tests/huntress_spike_smoke.sh --with-evidence  # also renders the 13 evidence frames
```

Isolation baselines are supplied through `HUNTRESS_SPIKE_BASELINE_DIR`
(`baseline_{game,game2d,game3d,game3d_spike,game3d_boss_spike,models,design,assets}.sha256`). Without them the runner
**skips** K12 and says so.

**Units, never synonyms: 117 OWED CRITERIA** (`docs/testing/D388_HUNTRESS_SPIKE_OWED_CRITERIA_INVENTORY.md`) · **72
EXECUTABLE CHECKS** (`tests/huntress_spike_verification.gd`) · **19 RUNNER CHECKS** (`tests/huntress_spike_smoke.sh`) · **13
printed DEFERRED rows** · **6 printed OWED-TO-OWNER rows** · **51 printed FINDINGS** · **13 evidence frames**.

## What it is NOT

**Not P2. Not production. Not final Huntress art. Not VFX intake. Not tuning. Not a Skill, not Splinter Shot, not a
roster. Not a hound, ballista or trap design. Not a resolution of the OWED multi-target Prey tie-break or of any other
D-385 debt. It changes no Huntress canon, modifies no accepted project, and locks no value.** The KayKit Ranger **is not
an alternative production Huntress** and cannot be accepted silently.
