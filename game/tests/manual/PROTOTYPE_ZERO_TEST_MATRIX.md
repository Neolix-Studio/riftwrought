# Prototype Zero — Manual Test Matrix

**Authority:** `design/PROTOTYPE_ZERO_IMPLEMENTATION_SPECIFICATION.md` §23
**Status:** **PROTOTYPE ZERO IS COMPLETE.** Gates A–E closed by project-owner
acceptance under D-175, D-180, D-183, and D-188. Gate B calibration was approved
under D-175; its carried controller rows and every Gate C manual row passed under
D-180 after the D-178/D-179 targeting correction. Gate D's automated and manual
rows passed and the gate closed under D-183. Gate E is complete under D-188.
**Gate F is CLOSED by project-owner acceptance under D-193**, and **Gate G — the
exit review — is delivered under D-194** as
`docs/testing/PROTOTYPE_ZERO_TEST_REPORT.md`.

**D-193 closed Gate F on the owner's judgement that the current experience feels
good and is sufficient for Prototype Zero's purpose: proving that the basic
foundations work.** The owner explicitly does **not** require the remaining
controller, headphones, damage-numbers-Off, and Reduced/Off presentation variants
to block Prototype Zero, because this laboratory is not intended to represent the
final game's complete appearance, audio, balance, or feel.

**No unperformed row is marked PASS.** The fourteen rows the owner did not judge
carry `DEFERRED BY OWNER` and must return during first-MVP vertical-slice
validation. That is deliberately distinct from the mouse and controller testing
that WAS completed and accepted, at Gates B, C, D, and E, with the device named
each time.

Final tally: **166 PASS, 14 DEFERRED BY OWNER, 0 NOT APPLICABLE**, over 180 rows.
The automated half passes at **1008 headless Gate F checks** (1019 when it also
renders the evidence), rerunning the whole Gate E chain first.

Automated checks cannot certify feel. This matrix is the human half.
Run the automated half first:

```bash
game/tests/gate_f_smoke.sh
```

That script reruns the whole Gate E suite, which reruns the whole Gate D suite,
which reruns the whole Gate C suite, which reruns the whole Gate B suite, which
reruns the whole Gate A suite. To run an earlier suite alone:

```bash
game/tests/gate_e_smoke.sh
game/tests/gate_d_smoke.sh
game/tests/gate_c_smoke.sh
game/tests/gate_b_smoke.sh
game/tests/gate_a_smoke.sh
```

Step-by-step instructions for the Gate B rows and their calibration questions are
in `docs/testing/PROTOTYPE_ZERO_GATE_B_REPORT.md` §6–§10; for the Gate C rows and
their feel questions, `docs/testing/PROTOTYPE_ZERO_GATE_C_REPORT.md` §8–§11; for
the Gate D rows and their feel questions,
`docs/testing/PROTOTYPE_ZERO_GATE_D_REPORT.md` §9–§10; and for **every Gate F
row below, the complete step-by-step mouse and controller sequence is
`docs/testing/PROTOTYPE_ZERO_GATE_F_REPORT.md` §6**, with the open feel questions
in its §7 and the honest limitations in its §8.

Legend:

* `PASS` — performed and accepted, by the method named in the row.
* `DEFERRED BY OWNER` — **not required to close Prototype Zero; must return
  during the first real MVP vertical-slice validation.** Not a failure and not a
  known defect: an unperformed human judgement the project owner has explicitly
  released.
* `NOT APPLICABLE` — the row cannot apply to what was delivered. **No row in this
  matrix carries this status**; the category was considered row by row and is
  empty. See `docs/testing/PROTOTYPE_ZERO_TEST_REPORT.md` §3.
* `FAIL` — performed and rejected. No row carries this status.

---

## Gate A — Project and Asset Spike

| # | Check | Method | Result |
|---|---|---|---|
| A1 | Project opens on the locked Godot 4.7.2 stable baseline | `gate_a_smoke.sh` step 0 | PASS |
| A2 | Every registered asset imports without error | `gate_a_smoke.sh` step 1 | PASS |
| A3 | All GDScript parses under the typed baseline | `gate_a_smoke.sh` step 2 | PASS |
| A4 | Knight and Skeleton Warrior share the medium rig, 23 identically named bones | asset probe | PASS |
| A5 | Weapon socket discovered from the rig, not guessed (`handslot.r`) | asset probe | PASS |
| A6 | Socket resolves by name despite differing bone indices (13 vs 8) | rig verification | PASS |
| A7 | Both bodies rest on `y = 0` with no floor offset | asset probe | PASS |
| A8 | Character and dungeon-kit scale coherent at 1:1, no rescaling applied | asset probe + screenshots | PASS |
| A9 | All seven approved clips present and playing on both bodies | rig verification | PASS |
| A10 | Both weapons attach to `handslot.r` and follow the animated bone | rig verification + close-ups | PASS |
| A11 | No root-motion drift; `Running_A` is in place on both bodies | rig verification | PASS |
| A12 | Headless startup boots the scene and exits cleanly | `gate_a_smoke.sh` step 5 | PASS |
| A13 | Rendered run produces legible idle, run, attack, hit, death, pickup poses | `docs/testing/gate_a_evidence/` | PASS |

Gate A stop condition — *"stop if the medium-rig import or attachment is not
understood"* — is satisfied. Findings recorded in
`game/assets/third_party/kaykit/SOURCE_AND_LICENSE.md` §3.

---

## Gate B — Calibration Room and Locomotion

Automated rows are settled by `gate_b_smoke.sh`. The project owner passed the
mouse calibration under D-175 and the carried controller rows under D-180.

| # | Check | Method | Result |
|---|---|---|---|
| B1 | Click-to-move reaches intended terrain near, far, and along every wall | manual, mouse | PASS (D-175/D-180) |
| B2 | Destination marker, braked arrival, and unreachable-point handling read correctly | manual, mouse | PASS (D-175/D-180) |
| B3 | Held click steers smoothly; rapid redirection always obeys the newest click | manual, mouse | PASS (D-175/D-180) |
| B4 | Clicking the overlay never leaks a ground command | manual, mouse | PASS (D-175/D-180) |
| B5 | Controller direct movement and deadzone feel responsive at low and high magnitude | manual, controller | PASS (D-180) |
| B6 | Stick directions are camera-relative and facing keeps up with rapid reversals | manual, controller | PASS (D-180) |
| B7 | A held stick loses to a newer click, and a substantial stick turn wins it back | manual, controller | PASS (D-180) |
| B8 | A resting controller neither moves the character nor flickers the glyph family | manual, controller | PASS (D-180) |
| B9 | Input-family tracking switches glyphs live without changing mechanical state | manual, both | PASS (D-180) |
| B10 | Focus loss and controller disconnect stop movement and require neutral input to resume | manual, both | PASS (D-180) |
| B11 | Navigation mesh covers the room with no dead pockets | `gate_b_smoke.sh` step 3 — 221/221 interior points | PASS |
| B12 | Walls hold against direct movement | `gate_b_smoke.sh` step 3 — stops at 0.400 m, the capsule radius | PASS |
| B13 | Click navigation routes around the optional barrier | `gate_b_smoke.sh` step 3 — 1.54× detour | PASS |
| B14 | No WASD binding exists anywhere in the project | `gate_b_smoke.sh` step 3 | PASS |
| B15 | Gate A asset and rig spike still passes unchanged | `gate_b_smoke.sh` step 1 | PASS |
| B16 | World scale, camera framing, and movement speed judged by eye | manual — Gate B report §10 | PASS (D-175) |
| B17 | The approved calibration is the shipped default, and the reset key restores it | `gate_b_smoke.sh` step 3 — 22 assertions | PASS |

## Gate C — Quick Strike Kernel

Automated rows are settled by `gate_c_smoke.sh` — 209 checks headless, 220 when
it also renders the evidence. The project owner passed all manual rows under
D-180. Step-by-step instructions are in the Gate C report §9 (mouse) and §10
(controller); the D-178 targeting correction is recorded in its §15.

| # | Check | Method | Result |
|---|---|---|---|
| C1 | Target acquisition and approach behave predictably | manual, mouse | PASS (D-180) |
| C2 | Directional empty swing and attack-in-place | manual, mouse | PASS (D-180) |
| C3 | Wind-up, release, recovery, buffer, repeat, movement cancellation | manual, both | PASS (D-180) |
| C4 | Exactly one release query per Skill Use ID | `gate_c_smoke.sh` step 3 — release queries always equal released uses | PASS |
| C5 | Mana cost applies once per released attempt, and never to a cancelled one | `gate_c_smoke.sh` step 3 | PASS |
| C6 | The locked timing is exact: 0.26 / 0.06 / 0.48 = 0.80 s, marker at 0.325 | `gate_c_smoke.sh` step 3 | PASS |
| C7 | The visible contact pose is on the facing axis when the release query runs | `gate_c_smoke.sh` step 3 — measured from the live skeleton, 0.00° at three releases | PASS |
| C8 | Attack speed compresses every phase together with no lock after the visual | `gate_c_smoke.sh` step 3 — 0.80 s and 0.64 s | PASS |
| C9 | Release arc is exactly 100°: hit at 0/45/49°, miss at 55/90° | `gate_c_smoke.sh` step 3 | PASS |
| C10 | Reach is exactly 1.65 m: hit at 1.20/1.60 m, miss at 1.75/3.00 m | `gate_c_smoke.sh` step 3 | PASS |
| C11 | An obstructed target is refused; the same geometry unobstructed connects | `gate_c_smoke.sh` step 3 | PASS |
| C12 | One release resolves onto at most one target, preferring the explicit one | `gate_c_smoke.sh` step 3 | PASS |
| C13 | Approach re-evaluates range and clears when the target becomes invalid | `gate_c_smoke.sh` step 3 | PASS |
| C14 | Soft targeting respects the 5 m distance, the cone, and the facing fallback | `gate_c_smoke.sh` step 3 | PASS |
| C15 | Aim assistance never snaps to a target behind the intended direction | `gate_c_smoke.sh` step 3 | PASS |
| C14a | The cone is 65° total: 32° off the intent is eligible, 33° is rejected (D-178) | `gate_c_smoke.sh` step 3 | PASS |
| C14b | An eligible post inside the 1.65 m reach outranks a better-aimed distant one: 19.7° at 1.49 m beats 1.3° at 4.50 m (D-178) | `gate_c_smoke.sh` step 3 | PASS |
| C14c | The distant aligned post still wins when the near one is outside the cone, invalid, or obstructed | `gate_c_smoke.sh` step 3 | PASS |
| C14d | With nothing inside reach, angle-first with the 12° tie band and distance-secondary is unchanged | `gate_c_smoke.sh` step 3 | PASS |
| C14e | The 0.35 s retention window cannot keep an out-of-reach target once a valid in-reach one appears (D-178) | `gate_c_smoke.sh` step 3 | PASS |
| C14f | With nothing eligible the swing is directional and in place: no approach, 0.000 m travelled, clean miss | `gate_c_smoke.sh` step 3 | PASS |
| C14g | Mouse targeting is unaffected by D-178: no cone, no acquisition distance, no in-reach priority | `gate_c_smoke.sh` step 3 | PASS |
| C14h | Release validation is unaffected by D-178: reach, 100° arc, obstruction, explicit preference, one target, validity | `gate_c_smoke.sh` step 3 | PASS |
| C16 | A held movement control aims the attack, then resumes at release and cuts recovery | `gate_c_smoke.sh` step 3 — stick and mouse | PASS |
| C17 | Movement before the marker cancels with no hit and no Mana; after it, the hit stands | `gate_c_smoke.sh` step 3 | PASS |
| C18 | Held repeat runs at exactly the action time | `gate_c_smoke.sh` step 3 — 0.800 s, and 0.640 s average at 25% | PASS |
| C19 | The 0.12 s buffer stores a late press and drops an early one | `gate_c_smoke.sh` step 3 | PASS |
| C20 | Insufficient Mana prevents the action from beginning at all | `gate_c_smoke.sh` step 3 | PASS |
| C21 | Gate B locomotion is unchanged by the target fixtures | `gate_c_smoke.sh` step 1 — navigation still 2 polygons, 218.7 m² | PASS |
| C22 | Gate A asset and rig spike still passes unchanged | `gate_c_smoke.sh` step 1 | PASS |
| C23 | The scaled swing reads well and the contact agrees with the impact by eye | manual — F8 slow motion | PASS (D-180) |
| C24 | Approach stopping distance reads as a credible fighting distance | manual, both | PASS (D-180) |
| C25 | Soft-target choices are sensible between two candidates, including the D-178 in-reach priority and the narrower 65° cone | manual, controller | PASS (D-180) |
| C26 | Carried from D-175: controller deadzone and substantial-turn threshold feel right | manual, controller | PASS (D-180) |

## Gate D — One Graveblade

Automated rows are settled by `gate_d_smoke.sh` — 230 checks headless, 244 when
it also renders the evidence. The project owner passed the mouse and controller
review and accepted all twelve feel questions under D-183.

| # | Check | Method | Result |
|---|---|---|---|
| D1 | Chase and readable attack telegraph | manual, both | PASS (D-183) |
| D2 | The Graveblade attack can genuinely miss | manual, both | PASS (D-183) |
| D3 | Starter sword kills an untouched 300-Life Graveblade in exactly three Hits | manual + F3 | PASS (D-183) |
| D4 | Hit and kill event timing is complete and ordered | F3 trace | PASS (D-183) |
| D5 | Every locked Graveblade value is the locked value | `gate_d_smoke.sh` step 3 — 300 Life, 125 damage, 3.4 m/s, 10.0 m, 1.40 m, 1.65 m, 90°, 0.55 / 0.08 / 0.62, ≥0.35 s, 1.25 s action, marker 0.44 | PASS |
| D6 | All eight states occur in order, at their locked durations | `gate_d_smoke.sh` step 3 — 0.550 / 0.083 / 0.617 s | PASS |
| D7 | Awareness: engages inside 10.0 m, ignores outside it | `gate_d_smoke.sh` step 3 — IDLE at 10.60 m, CHASE at 8.78 m | PASS |
| D8 | The chase holds at the preferred distance instead of walking in | `gate_d_smoke.sh` step 3 — closed to 1.53 m and stopped | PASS |
| D9 | Permission is asked before every commitment, refused while held, returned after | `gate_d_smoke.sh` step 3 | PASS |
| D10 | The direction tracks during early anticipation, then LOCKS 0.22 s before contact | `gate_d_smoke.sh` step 3 — followed 35.0°, then moved 0.000° | PASS |
| D11 | Reach is exactly 1.65 m: hit at 1.20/1.60 m, miss at 1.70/3.00 m | `gate_d_smoke.sh` step 3 | PASS |
| D12 | The arc is exactly 90° around the COMMITTED direction: hit at 0/44°, miss at 46/90/180° | `gate_d_smoke.sh` step 3 | PASS |
| D13 | An obstructed release is refused; the same origin and distance unobstructed connects | `gate_d_smoke.sh` step 3 — control pair across the 1.00 m wall | PASS |
| D14 | Moving after the commit creates a real miss, out of reach and out of arc | `gate_d_smoke.sh` step 3 — 2.40 m, and 80° while still in reach | PASS |
| D15 | Exactly one release query and at most one DamageEvent per enemy attack use | `gate_d_smoke.sh` step 3 | PASS |
| D16 | The release fires with the attack clip on its 0.44 marker, every time | `gate_d_smoke.sh` step 3 | PASS |
| D17 | Player Life is exactly 500 → 375 → 250 → 125 → 0 | `gate_d_smoke.sh` step 3 | PASS |
| D18 | Graveblade Life is exactly 300 → 200 → 100 → 0; survives two, dies on the third | `gate_d_smoke.sh` step 3 | PASS |
| D19 | An ordinary Hit never interrupts the attack, its use id, its clock, or its commitment | `gate_d_smoke.sh` step 3 | PASS |
| D20 | Death disables targeting, blocking, navigation, damage, threat, and permission at once | `gate_d_smoke.sh` step 3 | PASS |
| D21 | The decorative death animation never delays the kill event | `gate_d_smoke.sh` step 3 — +0 ms | PASS |
| D22 | No duplicate damage and no duplicate kill: dead target, repeated use id, real swing at a corpse | `gate_d_smoke.sh` step 3 | PASS |
| D23 | Hit precedes kill, and the kill carries the lethal Hit's own Skill Use id | `gate_d_smoke.sh` step 3 — `hit → hit → hit → kill` | PASS |
| D24 | Pursuit routes around the barrier without changing Gate B's navigation result | `gate_d_smoke.sh` step 3 — 2.36× detour, still 2 polygons and 218.7 m² | PASS |
| D25 | An inert practice post still takes no damage from the same release that kills a Graveblade | `gate_d_smoke.sh` step 3 | PASS |
| D26 | No XP is awarded, no loot appears, and exactly one enemy exists | `gate_d_smoke.sh` step 3 — asserted by name | PASS |
| D27 | Both candidate clips were measured and the chosen one preserves every pose | `gate_d_smoke.sh` step 2 — worst pose error 0.00000 m | PASS |
| D28 | Gate C's kernel, targeting, Mana, timing, and controller behaviour are unchanged | `gate_d_smoke.sh` step 1 — 209 Gate C checks | PASS |
| D29 | Gate B locomotion and Gate A assets are unchanged | `gate_d_smoke.sh` step 1 — 106 Gate B checks, whole Gate A suite | PASS |
| D30 | The Chop rejection is accepted, or a different answer is chosen | manual — Gate D report §3 and §10 question 1 | PASS (D-183: Slice accepted) |
| D31 | The enemy silhouette and cadence read as distinct from the player's | manual, both | PASS (D-183) |
| D32 | The 0.55 s telegraph reads as deliberate rather than floaty | manual, both | PASS (D-183) |
| D33 | The one-Graveblade fight is worth judging as a fight | manual, mouse and controller | PASS (D-183) |

## Gate E — Improvement Loop

Automated rows are settled by `gate_e_smoke.sh` — 710 checks headless, 725 when
it also renders the evidence. The project owner judged the manual rows on
2026-09-01, and **every Gate E row now passes under D-188.** Step-by-step
instructions for the first pass are in the Gate E report §15, the completed
cadence retest is §15a, the correction itself is §7a, and all fourteen feel
questions in §16 now carry their answers.

| # | Check | Method | Result |
|---|---|---|---|
| E1 | Guaranteed ground sword drops on the first kill | `gate_e_smoke.sh` step 2 — exactly one drop, at the kill position, 0.000 m off the navigation mesh | PASS |
| E2 | The first eligible kill grants exactly 10 XP and no replacement enemy spawns | `gate_e_smoke.sh` step 2 — XP trace 0 → 10, 0 living Graveblades 1.9 s later | PASS |
| E3 | The drop uses only registered assets, with a stronger but related indicator | `gate_e_smoke.sh` step 2 — the Gate A `sword_1handed.gltf`; a 0.86 m ring against the existing 0.60 m, 1.43× | PASS |
| E4 | The comparison shows exactly the five listed things, all computed | `gate_e_smoke.sh` step 2 — five rows, two buttons, no rarity/affix/score language | PASS |
| E5 | Close leaves the sword; reopening cannot duplicate | `gate_e_smoke.sh` step 2 — closed and reopened 3×: one drop, 10 XP, not equipped | PASS |
| E6 | Equip replaces the prototype weapon directly, once | `gate_e_smoke.sh` step 2 — 100 → 150, no inventory, 8 presses equip once | PASS |
| E7 | Upgraded sword kills the equivalent Graveblade in exactly two Hits | `gate_e_smoke.sh` step 2 — Life 300 → 150 → 0 | PASS |
| E8 | The second kill reaches exactly 20 / 20 and reads Complete | `gate_e_smoke.sh` step 2 — XP trace 10 → 20 | PASS |
| E9 | The passive card shows exactly the four listed lines | `gate_e_smoke.sh` step 2 — no points, paths, attributes, refunds, or Build Lens | PASS |
| E10 | Action time changes 0.80 s → 0.64 s with every phase compressed together | `gate_e_smoke.sh` step 2 — 0.2600/0.0600/0.4800 → 0.2080/0.0480/0.3840, all 0.8000× | PASS |
| E11 | The release stays animation-aligned at the faster speed | `gate_e_smoke.sh` step 2 — clip position 0.3250 at both releases | PASS |
| E12 | The held repeat runs at the new action time | `gate_e_smoke.sh` step 2 — average 0.6389 s against 0.6400 s | PASS |
| E13 | Deterministic 1 → 2 → 3 waves repeat | `gate_e_smoke.sh` step 2 — 1 → 2 → 3 → 1 → 2 → 3 → 1 across seven waves | PASS |
| E14 | Each wave starts about 1.25 s after the previous threat is gone | `gate_e_smoke.sh` step 2 — mean 1.2737 s, worst deviation 0.034 s in the evidence run | PASS |
| E15 | Spawn positions are measurably safe and do not surround the player | `gate_e_smoke.sh` step 2 — nearest 7.25 m, 1.78 m apart, 39° spread, on the navmesh | PASS |
| E16 | Several Graveblades share the existing AttackCoordinator | `gate_e_smoke.sh` step 2 — all three refusal branches, and at most one holder in a live fight | PASS |
| E16a | D-186: no wind-up is granted during the 0.35 s group handoff, and one is granted the moment it expires | `gate_e_smoke.sh` step 2 — a different attacker refused 22 consecutive frames, granted at 0.3667 s | PASS |
| E16b | D-186: the window starts on a completed action and on death while holding, and never on withdrawal, removal, reset, revocation, or a non-holder | `gate_e_smoke.sh` step 2 — decided from the `ReleaseCause` value, not from the reason string | PASS |
| E16c | D-186: a modal pause cannot spend the window | `gate_e_smoke.sh` step 2 — 40 paused frames leave 0.3500 s → 0.3500 s owed; the full window is still owed on resume | PASS |
| E16d | D-186: different attackers' release starts are ≈1.60 s in a live three-Graveblade fight | `gate_e_smoke.sh` step 2 — five gaps, all 1.6167 s, against 1.243–1.275 s before | PASS |
| E16e | D-186: the one-Graveblade cadence is unchanged | `gate_e_smoke.sh` step 2 — same fight with the window at 0.35 s and at 0.00 s: identical gaps, 0.0000 s difference, and 0 handoff refusals | PASS |
| E16f | D-186: the remaining window is visible in F3 on both panels and in the structured log | `gate_e_smoke.sh` step 2 — the on-screen text is read, running and idle | PASS |
| E17 | Rewards are idempotent under duplicate signals, corpses, repeated input, reopened UI, and F11 | `gate_e_smoke.sh` step 2 — five abuse paths, all refused | PASS |
| E18 | The modal surfaces pause, neutralize, focus, glyph, and require neutral input | `gate_e_smoke.sh` step 2 — 0.000 m moved while paused, held input refused | PASS |
| E19 | Reset Lab Progress deliberately clears the sequence | `gate_e_smoke.sh` step 2 | PASS |
| E20 | Nothing is written to disk and no audio was added | `gate_e_smoke.sh` step 2 — code scanned with comments stripped; 0 audio players | PASS |
| E21 | Every accepted Gate C and Gate D value is preserved | `gate_e_smoke.sh` steps 1–2 — 230 Gate D checks, 209 Gate C checks | PASS |
| E21a | The instrumentation cards state only true things, and the retired phrases cannot return | `gate_e_smoke.sh` step 2 — source scan with comments stripped, plus the live on-screen text | PASS |
| E22 | The reward is noticed and the drop reads from across the room | manual, both | PASS (D-186) |
| E23 | The comparison is believed and the 3 → 2 line lands | manual, both | PASS (D-186) |
| E24 | Two Hits instead of three feels like becoming stronger | manual, both | PASS (D-186) |
| E25 | The 0.80 → 0.64 s change is perceptible without the debug panel | manual, both | PASS (D-186) |
| E26 | Controller interaction range, focus order, and glyphs read correctly | manual, controller | PASS (D-186) |
| E27 | The 1 → 2 → 3 wave rhythm is a rhythm you can work inside | manual, both | PASS (D-186) — the 1 → 2 → 3 shape and the 1.25 s beat; the pressure inside a wave is E28 |
| E28 | Three Graveblades on one permission slot read as coordinated | manual, both — Gate E report §15a | PASS (D-188) — corrected cadence feels good |
| E29 | Ten repeated kills after both upgrades still want an eleventh | manual, both | PASS (D-186) — roughly thirty minutes of play |
| E30 | The corrected 0.35 s group handoff makes a three-Graveblade wave fair for an intentionally weak character, and one Graveblade still feels unchanged | manual, mouse and controller — Gate E report §15a | PASS (D-188) — accepted as the Prototype Zero baseline; broader balancing waits for more abilities and the fuller Life/damage model |

## Gate F — Feedback, Death, Settings, and Test State

Automated rows are settled by `gate_f_smoke.sh` (**1008 headless checks**, 1019
rendered). **Gate F is CLOSED by project-owner acceptance under D-193.** D-191's
audit correction added F38 and F39, and D-192's added F40 and F41.

The owner played the current experience and reported that it feels good and is
sufficient for Prototype Zero's purpose. That acceptance is recorded at **gate
level**; the owner's message does not report per-row outcomes, so **no row below
is marked PASS by inference.** All thirteen of F25–F37 carry `DEFERRED BY OWNER`.
If the owner did judge specific rows in that session, saying so will move them to
PASS with the date — none of them failed.

Step-by-step instructions for every deferred row remain in
`docs/testing/PROTOTYPE_ZERO_GATE_F_REPORT.md` §6, which numbers them in the
order they should be played, so first-MVP validation can pick them up unchanged.

| # | Check | Method | Result |
|---|---|---|---|
| F1 | The §17 HUD shows Life, Mana, XP, the Quick Strike slot and its live glyph, the weapon line, the target readout, and the interaction prompt — and nothing §17 excludes | `gate_f_smoke.sh` step 3 — read from the live on-screen text | PASS |
| F2 | Nothing in the HUD absorbs the pointer, so click-to-move is untouched | `gate_f_smoke.sh` step 3 — 0 mouse-absorbing controls | PASS |
| F3 | The instrumentation cards are hidden by default and F3 reveals them | `gate_f_smoke.sh` step 3 | PASS |
| F4 | Damage numbers Off suppress the NUMBER and nothing else | `gate_f_smoke.sh` step 3 — same 100 damage, same Hit feedback, same impact sound, same camera impulse, 0 numbers | PASS |
| F5 | Shake, flashes, and vibration scale 1.00 / 0.40 / 0.00, and Off is exactly zero | `gate_f_smoke.sh` step 3 — camera offset 0.0000 m with shake Off | PASS |
| F6 | The improved Hit is measurably heavier and measurably NOT brighter | `gate_f_smoke.sh` step 3 — low-band 0.433 → 0.558, zero-crossings 900 → 752 /s, 0.300 → 0.330 s, −5.5 → −3.9 dB | PASS |
| F7 | Every §19 cue family exists, is project-authored, and no sound file was imported | `gate_f_smoke.sh` steps 2–3 — 38 variants, 20 families, 0 imported samples, byte-identical rebuild | PASS |
| F8 | Cues vary, never repeat back to back, and rate-limit | `gate_f_smoke.sh` step 3 — all four footstep takes over 11 plays, 0 immediate repeats, a second impact inside 0.03 s dropped | PASS |
| F9 | Master volume applies immediately, and 0 mutes outright | `gate_f_smoke.sh` step 3 — +0.00 / −6.02 / −12.04 dB, muted at 0 | PASS |
| F10 | Music is absent: no cue loops and none is longer than the 1.60 s Fallen | `gate_f_smoke.sh` step 3 | PASS |
| F11 | Pause genuinely stops the world, including the coordinator clocks and the wave countdown | `gate_f_smoke.sh` step 3 — 40 paused frames move nothing; **this found a real bug**, Gate F report §4.4 | PASS |
| F12 | Pause exposes Resume, Restart Current Fight, Settings, Reset Lab Progress, and Quit to Title, with Resume focused | `gate_f_smoke.sh` step 3 | PASS |
| F13 | A control held across any boundary cannot act, and resume re-arms the latch | `gate_f_smoke.sh` step 3 — held confirm refused, held movement keeps the latch armed | PASS |
| F14 | The lab file is written only at milestones, and holds only the six allowlisted values | `gate_f_smoke.sh` step 3 — 0 saves in 30 ordinary frames, 0 on a repeat kill, exactly six keys, no forbidden word in the bytes | PASS |
| F15 | Continue reconstructs every one of the five milestones without duplicating XP, the sword, or the passive | `gate_f_smoke.sh` step 3 — all five, 0 duplicate attempts; **this found a real bug**, Gate F report §4.7 | PASS |
| F16 | An invalid lab file is refused truthfully and offers Reset Lab Progress | `gate_f_smoke.sh` step 3 — four different faults, each named | PASS |
| F17 | Reset Lab Progress removes the lab file and does not touch the settings file | `gate_f_smoke.sh` step 3 | PASS |
| F18 | Fallen neutralizes everything on the LETHAL frame, waits for the death response, and shows the exact killing source | `gate_f_smoke.sh` step 3 — `Graveblade — Melee Hit — 125 Physical Damage`, built from the event | PASS |
| F19 | Fallen focuses a neutral non-destructive element first and rejects actions held through death | `gate_f_smoke.sh` step 3 — Review Death focused | PASS |
| F20 | Restart restores full Life and Mana and the CURRENT wave at full Life, retains every milestone, and duplicates no reward | `gate_f_smoke.sh` step 3 | PASS |
| F21 | A display change is protected by a timed Keep / Revert whose default answer is Revert | `gate_f_smoke.sh` step 3 — timeout reverts, explicit revert reverts, Keep persists | PASS |
| F22 | A display change that was never answered cannot survive a restart | `gate_f_smoke.sh` step 3 — the on-disk marker restores the last known-good values and says so | PASS |
| F23 | Start New Lab / Continue Lab / Settings / Quit exist, and Continue says why when it is unavailable | `gate_f_smoke.sh` step 3 | PASS |
| F24 | Every accepted Gate A–E value survives, and nothing outside Gate F was built | `gate_f_smoke.sh` steps 1 and 3 — 713 / 230 / 209 / 106 checks, plus the Gate F scope audit | PASS |
| F38 | **D-191:** the verification writes only to an isolated temporary directory, refuses to run without one, and leaves the project owner's own settings and lab files byte-for-byte unchanged or still absent | `gate_f_smoke.sh` steps 0, 3, 4b, and 6 — fingerprinted from inside the engine and from the shell, with the production directory cross-checked against the path the engine prints | PASS |
| F39 | **D-191:** §21 aim assistance recomputes from the canonical record instead of compounding, and never writes to `quick_strike.tres` | `gate_f_smoke.sh` step 3 — 0 / 70 / 100 give 39.0 / 65.0 / 78.0° and 3.0 / 5.0 / 6.0 m across three in-room cycles, three room replacements, a Continue, and a Restart, at 0.0000° of drift; the 70 rows asserted with `==` | PASS |
| F40 | **D-192:** the storage guard decides by identity rather than by spelling — the production directory named absolutely, with a trailing or doubled separator, through `.`, through `..`, in another **case** on a case-folding volume, in another case combined with `.`/`..`, or through a symlink is refused, and so are a directory inside it and a symlinked file inside an otherwise isolated directory | `gate_f_smoke.sh` step 2b on the NON-WRITING `--check-state-dir` path — twelve refusals, the real files fingerprinted around every one, and step 3 not run at all if one fails; plus the in-engine `--- Every spelling of the production directory is one directory` block in step 3, the assertion that the case rule matches what the filesystem actually does, and the positive controls (the run's own directory is accepted, its lower-cased spelling is still not production, and an ordinary launch still uses the two `user://` files) | PASS |
| F41 | **D-192:** Gate E's wave gap and Gate D's kill-event timing measure on the simulation clock rather than the wall clock, with no assertion, tolerance, or authored value changed | `gate_f_smoke.sh` step 1 — six of seven wave gaps now read exactly 1.2500 s, and the kill event is asserted by "the death animation had not started when it fired" plus same-simulation-step, observed from inside the mechanical call stack. Gate D still 230, Gate E still 713 | PASS |
| F25 | **Hits stay legible with damage numbers Off** | manual, both — report §6 rows 5, 9 | **DEFERRED BY OWNER** |
| F26 | **Feedback stays legible with shake, flashes, and vibration Reduced or Off** | manual, both — report §6 row 13 | **DEFERRED BY OWNER** |
| F27 | **150 reads as a heavier sword rather than as a different damage type** | manual, both — report §6 row 9 | **DEFERRED BY OWNER** |
| F28 | **The Graveblade's anticipation cue is a telegraph you can act on** | manual, both — report §6 row 6 | **DEFERRED BY OWNER** |
| F29 | **The authored audio is good enough to review combat feel at all** | manual, both, on speakers and headphones — report §8.1 | **DEFERRED BY OWNER** |
| F30 | Fallen is conclusive and Restart is immediate and trusted | manual, both — report §6 rows 17–18 | **DEFERRED BY OWNER** |
| F31 | Inputs are neutral through death, Restart, pause, focus loss, and controller disconnect | manual, both — report §6 rows 19, 29, 30 | **DEFERRED BY OWNER** |
| F32 | Pause and resume do not reset or advance state | manual, both — report §6 row 12 | **DEFERRED BY OWNER** |
| F33 | Display-mode change offers a timed Keep / Revert and cannot trap you | manual — report §6 rows 15–16 | **DEFERRED BY OWNER** |
| F34 | A corrupted test file resets truthfully rather than stranding the test | manual — report §6 row 23 | **DEFERRED BY OWNER** |
| F35 | Continue reconstructs milestones without duplicating XP or the sword | manual — report §6 rows 20–22 | **DEFERRED BY OWNER** |
| F36 | The complete path is playable with a controller and no mouse at all | manual, controller — report §6 rows 25–28 | **DEFERRED BY OWNER** |
| F37 | Ten repeated kills with everything Off still want an eleventh | manual, both — report §6 pass 3 | **DEFERRED BY OWNER** |

## Gate G — Exit Review

Delivered under D-194 as `docs/testing/PROTOTYPE_ZERO_TEST_REPORT.md`. Gate G adds
no gameplay, tuning, asset, or code; the one line of `game/` it touched is the
Gate F scope assertion that the exit report does not exist, which D-193 makes
false by authorization and which was replaced one for one with the first-MVP
boundary. **Gate F's count is unchanged at 1008.**

`G2` is split, because one status would be false either way: the combat and
progression path was completed on both devices at Gates C, D, and E, while the
Gate F session layer — title, settings, pause, Fallen, Restart, save/Continue —
was not played on a controller.

| # | Check | Method | Result |
|---|---|---|---|
| G1 | Ten repeated equivalent kills still create desire for another kill | manual — see report §6 | PASS (D-186, carried from E29) — roughly thirty minutes of play in the default presentation; the everything-Off variant is F37 |
| G2a | Complete path with **mouse** | manual, mouse | PASS (D-175, D-180, D-183, D-186, D-193) |
| G2b | Complete path with **controller**, through the Gate F session layer | manual, controller | **DEFERRED BY OWNER** — controller combat, targeting, movement, interaction, and the improvement loop passed at Gates C, D, and E; only the Gate F menus and recovery flow are unplayed (F36) |
| G3 | No critical behaviour depends on final art | review — report §8 | PASS — the Chop rejection changed the clip rather than the locked 1.65 m reach; both release markers are measured from the rig; every mechanical value lives in five `.tres` records; effects Off produce exactly 0.0000 m of camera offset while the same damage lands |
| G4 | No excluded first-MVP system was built | scope check — report §9 | PASS — three independent passes: the suite's by-member-name assertions, an independent comment-stripped source scan whose ten matches are all truthful statements of absence, and the two weapon records asserted the wrong shape by field name |
