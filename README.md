# Riftwrought

An offline-first, buildcraft-led action RPG in **Godot 4** — the player owns the game,
the save file, the economy and the progression: no online economy, no seasons, no FOMO.

Long-term solo project. The case study is at
**<https://neolix.studio/projects/riftwrought/>**.

## What is in this repository

Code only. The design corpus (canonical design documents, the decision log, project
memory) is kept private, and third-party art is not redistributed here — so the
projects below **will not run as-is** without those assets.

| folder | what it is |
| --- | --- |
| `game3d/` | the canonical 3D production project: Imprint economy, Huntress skills, minion cohesion, locomotion |
| `game3d_spike/` | bounded feasibility spike: 3D scale, density and asset-style comparison |
| `game3d_huntress_spike/` | feasibility spike: bow retargeting, aiming and prey/target selection |
| `game3d_boss_spike/` | feasibility spike: boss animation and phase transitions |
| `game2d/` | the accepted 2D isometric prototype (frozen; superseded as the visual target) |
| `game/` | the earlier 3D prototype and roguelite vertical slice |

Each folder has its own README describing what that stage delivered and which
decisions accepted it.

## How this project is built

Work moves in bounded stages: specification → delivery → owner review → acceptance,
with every ruling recorded in a decision log (400+ entries). Anything risky is proved
first in a disposable feasibility spike, with captured evidence, before it is built in
the production project. The `tests/` folders hold the verification scripts that each
stage was reviewed against.

Design, systems, formulas, balancing and the process are mine; implementation is
written with AI assistance.

## Assets

The prototypes use free CC0 packs by [KayKit](https://kaylousberg.com) and
[Quaternius](https://quaternius.com), which are not included in this repository.
