# `game3d/` — Riftwrought's Canonical 3D Production Project

> # THE CANONICAL PRODUCTION PROJECT — AND IT COMPLETES NO PHASE.
>
> **Stage 1 — the bounded FOUNDATION STAGE — is ACCEPTED and CLOSED (D-373, 2026-09-17).**
> *(Delivered under D-370; corrected under D-371 — action-movement commitment — and D-372 — recovery
> cancellation. Each was DELIVERED and OPEN in turn.)*
>
> **Stage 2 — the GLOBAL IMPRINT SYSTEM PROTOTYPE — is ACCEPTED and CLOSED (D-376, 2026-09-18).**
> *(Delivered and OPEN pending owner live review under D-375, 2026-09-17 — true when written.)*
>
> **Stage 3 — the D-378 ALIGNMENT STAGE — is ACCEPTED and CLOSED (D-383, 2026-09-18).**
> *(Delivered and OPEN pending owner live review under D-380, corrected under D-381 and D-382, each re-delivered
> OPEN — true when written.)*
>
> **Stage 4 — the HUNTRESS SPLINTER SHOT STAGE — is ACCEPTED and CLOSED (D-394, 2026-09-19).**
> *(Delivered and OPEN pending owner live review under D-392; Prey removed and RE-DELIVERED OPEN under D-393 — true when
> written.)*
>
> **Stage 5 — the KINDRED HOUNDS STAGE — is ACCEPTED and CLOSED (D-397, 2026-09-19).**
> *(Delivered and OPEN pending owner live review under D-396 — the sentence below was true when written.)*
> **Stage 5 — the KINDRED HOUNDS STAGE — is DELIVERED and OPEN pending owner live review (D-396, 2026-09-19).** It does
> not accept itself.
>
> **Stage 6 — the MOBILE MINION COHESION STAGE — is ACCEPTED and CLOSED (D-399, 2026-09-20).**
> *(Delivered and OPEN pending owner live review under D-398, 2026-09-19 — the sentence below was true when written.)*
> **Stage 6 — the MOBILE MINION COHESION STAGE — is DELIVERED and OPEN pending owner live review (D-398, 2026-09-19).**
> It does not accept itself.
>
> **Stage 7 — the PLAYER LOCOMOTION REDIRECTION STAGE — is ACCEPTED and CLOSED (D-401, 2026-09-20).**
> *(Delivered and OPEN pending owner live review under D-400, 2026-09-20 — the sentence below was true when written.)*
> **Stage 7 — the PLAYER LOCOMOTION REDIRECTION STAGE — is DELIVERED and OPEN pending owner live review
> (D-400, 2026-09-20).** It does not accept itself.
>
> **Stage 8 — the CINDER FIELD STAGE — is ACCEPTED and CLOSED (D-403, 2026-09-28).**
>
> **Stage 9 — the PLAYER DIRECT-CLICK MOVEMENT CORRECTION STAGE — is DELIVERED and OPEN pending owner live review
> (D-404, 2026-09-28).** It does not accept itself.
> *(Delivered and OPEN pending owner live review under D-402, 2026-09-20 — the sentence below was true when written.)*
> **Stage 8 — the CINDER FIELD STAGE — is DELIVERED and OPEN pending owner live review (D-402, 2026-09-20).**
> It does not accept itself.

> ## 🔶 STAGE 9 — THE PLAYER DIRECT-CLICK MOVEMENT CORRECTION STAGE — IS DELIVERED and OPEN (D-404, 2026-09-28)
>
> ***"When I click across an obstacle, the current system feels magnetic because it routes the player around it. I want
> the player to move directly toward the clicked point and run into the obstacle. The player should have to issue
> additional movement clicks to navigate around it."*** **Delivered is not accepted.**
>
> - **FIRST ACT — the D-403 reconciliation, done.** `ProdConfig.STATE` names **NINE** facts: eight accepted stages and
>   this one OPEN. `FO-01`–`FO-07` print **DISCHARGED — D-403**, each with its original text verbatim beside the owner's
>   one overall answer, ***"Looks and feels good."***. No row-by-row judgment and no number is inferred. The D-402
>   self-denial is **dated history**. Every pin moved **in the same change**, each still EXACT-LINE, and each gained a
>   **D-402-era absence needle**. Verified in isolation, all eight suites green, before any movement code changed.
> - **WHAT CHANGED — a MOUSE order only.** It stores the **clicked ground point exactly**, never snapped. It asks
>   navigation for **nothing**: no path, no closest point and no follower. Every step points **straight** at the click.
>   A click step is **one continuous sweep** (`DirectClickOrder.sweep()`), and the **first blocker ends it**. It never
>   slides, reroutes or tunnels, and the order is cleared. A remembered contact stops a **held** cursor from creeping
>   along a wall; a click parallel to or away from the wall moves **at once**. `scripts/click/` holds 4 scripts.
> - **UNCHANGED:** the controller stick, which still slides along walls with `move_and_slide()`. Also unchanged:
>   - enemies, Kindred Hounds and the cohort, which still use their paths;
>   - `NavService` and the navigation mesh;
>   - collision shapes, layers, masks and the radius;
>   - Cinder Field's placement;
>   - the accepted motor and its rates, arrival, and same-frame redirection in open space;
>   - the STOP commitment and the unscaled ACTION brake;
>   - independent aim.
>   The player's `NavigationAgent3D` (read by `F70`) and her `PathFollower` field (cleared by accepted fixtures) are
>   **retained, inert**.
> - ⚠️ **SIX ACCEPTED CHECKS CONFLICTED WITH THE RULING AND WERE REPLACED ONE FOR ONE**, each keeping its ID number and
>   its old requirement as dated history:
>   - D-400's `L12`, `L18` and `L21`;
>   - D-370's `F27` and `F76` (`F76` only in its path conjunct);
>   - D-375's `I80`.
>   **`C15`/`C27`'s drives** now walk their routes **by hand**, with their pack assertions unchanged, and **`A26`** is
>   re-scoped `68 + 4 = 72`. `L20` (the stick slide) and `F26` are **not** replaced. **No accepted count moved.**
> - ⚠️ **CANON DISAGREES, DECLARED (`DD-22`):** `design/UI_AND_USER_EXPERIENCE.md` §115 (*"Clicking through an open
>   doorway may path…"*) and the 2D proposal's *"resolves to the nearest navigable point"* describe the superseded
>   behaviour. The owner's ruling outranks them; they are **not amended**, and a bounded canonical reconciliation is
>   **RECOMMENDED, NOT AUTHORIZED**.
> - **A compact review HUD, top-centre**, and flat world markers show the clicked point, the straight segment, the first
>   contact, **ARRIVED / COLLIDED**, and **PLAYER PATH 0 points · 0 queries**. F1 and F2 stay hidden. **Three values
>   and one structural bound, all PROVISIONAL, none locked.** **29 input actions stay 29; no asset.**
> - **Units: 124 OWED CRITERIA · 32 EXECUTABLE CHECKS · 24 RUNNER CHECKS · 22 `DD-` · 6 `DO-` owed to the owner.** The
>   runner needs `FOUNDATION_BASELINE_DIR` and **`D404_BASELINE_GAME3D`**. Read
>   `docs/testing/D404_DIRECT_CLICK_MOVEMENT_OWED_CRITERIA_INVENTORY.md` and
>   `docs/testing/D404_DIRECT_CLICK_MOVEMENT_DELIVERY_REPORT.md`.

> ## ✅ STAGE 8 IS ACCEPTED and CLOSED — D-403 (2026-09-28). ITS ARCHITECTURE AND REVIEWED BEHAVIOUR ARE ACCEPTED; NO NUMBER IS LOCKED.
>
> ***"Looks and feels good."*** Accepted as **Cinder Field's architecture and reviewed behaviour**. ***"It does not lock
> any timing, damage, radius, duration, cost, Capacity value, instance cap, animation, placeholder model, diagnostic
> visual or presentation detail."*** `FO-01`–`FO-07` are closed by that **overall** answer. No row-by-row judgment is
> inferred.
>
> - ⚠️ **TWO CARRIED FINDINGS, NOT REPAIRED:** overlapping fields **do not stack mechanically**, but the diagnostic
>   visuals **become brighter** and can misleadingly imply additional damage; and **bindings 7 and 8 still have no
>   controller activation** (`FD-15`).
> - **Documentation-only closure: this README is the only `game3d/` file D-403 changed.** The runtime kept printing the
>   D-402 OPEN state until **D-404's first act** reconciled it, which the same ruling authorized. Read
>   `docs/testing/D403_CINDER_FIELD_ACCEPTANCE_AND_CLOSURE_REPORT.md`.

> ## 🔶 STAGE 8 — THE CINDER FIELD STAGE — IS DELIVERED and OPEN (D-402, 2026-09-20)
>
> ***"This prompt authorizes only the Cinder Field stage described below. It does not authorize Sinew Ballista,
> another Huntress Skill, Huntress's Mark, Rift Shards, Augments, production VFX work, tuning locks or a broader
> trap framework."*** **Delivered is not accepted.**
>
> - **FIRST ACT — the reconciliation D-401 §6 recommended, done.** `ProdConfig.STATE` now names **EIGHT** facts:
>   seven accepted stages and this one OPEN. `LO-01`–`LO-04` print **DISCHARGED — D-401** with their original text
>   preserved verbatim and the owner's own answer — ***"works well, I like it."*** — beside them; `4 − 4 = 0` owed,
>   `0 + 4 = 4` discharged, **0 deleted**. The D-400 self-denial is **dated history**. ⚠️ **`LD-02` is
>   RE-CLASSIFIED, NOT DISCHARGED** — it now prints `CARRIED — PROVISIONAL FINDING`, carrying the owner's two
>   standing prohibitions, and `ACTION_BRAKE_MPS2` is **unchanged at 120.0 m/s²**. Every pin moved **in the same
>   change**, each still EXACT-LINE, each gaining a **D-400-era absence check**.
> - **WHAT EXISTS NOW:** `scripts/cinder/` (6 scripts) — **Cinder Field**, ONE canonical **ACTIVE** Skill Imprint,
>   learned at **rank 1 / 0 XP** with **zero Augments**, on **binding 7** (key 7 — an **already accepted** input
>   action, so the project's **29 actions stay 29**). A ground-targeted **Fire Spell delivered as a TRAP**: placed
>   dormant, **armed** after a provisional delay, **erupting ONCE** into an initial **Fire Hit** and a lingering,
>   **NON-STACKING burning Ground**. The eruption is a **DELAYED COMPONENT of the original Skill Use**, not a
>   Triggered Skill. **26 values, every one PROVISIONAL, none locked.**
> - **Capacity was MEASURED first and NOT increased:** the accepted D-396 review loadout sat at **32 / 35**;
>   Cinder Field costs the **accepted secondary base of 2**, so **32 + 2 = 34 / 35** reserving Mana and
>   **33 + 2 = 35 / 35** in LIFE CONVERSION, with **nothing deactivated in either**. **Nothing was replaced,
>   disabled or deleted** — binding 4 stays empty, because that emptiness *is* D-396's Capacity concession.
> - **ASSET INTAKE, VERIFIED BEFORE EXTRACTION:** exactly **`BearTrap_Open` and `BearTrap_Closed`** (two `.obj`,
>   two `.mtl`) from the **already-declared CC0** Quaternius Ultimate Modular Ruins archive. Each file hashes to
>   its archive entry, the **source archive is byte-identical afterwards**, and the archive's bundled licence is
>   byte-identical to the CC0 file already in the tree. **9 + 2 = 11 models, 29 + 4 = 33 declared files, still 5
>   packs.** **They are PLACEHOLDERS and NEITHER is final Huntress art.** **No VFX archive was opened**; the
>   eruption and the burning ground are **restrained procedural diagnostics**.
> - **Found during the work and corrected, with the correction recorded:** `CinderRuntime.clear_owned()` walked the
>   very arrays `_free_trap()` erases from, so **every second entry was skipped** and a trap survived a removal
>   that claimed to have cleared everything. `E38` found it by walking the live scene tree and counting what was
>   actually left.
> - **Units: 185 OWED CRITERIA · 48 EXECUTABLE CHECKS · 24 RUNNER CHECKS · 19 `FD-` · 7 `FO-` owed to the owner.**
>   Accepted counts unmoved (85 · 101 · 40 · 53 · 45 · 40 · 33). The runner needs `FOUNDATION_BASELINE_DIR` and
>   **`D402_BASELINE_GAME3D`** (a pre-D-402 listing of `game3d/`).

> ## ✅ STAGE 7 IS ACCEPTED and CLOSED — D-401. THE IMPLEMENTATION IS ACCEPTED; NO NUMBER IS LOCKED.
>
> ***"I accept D-400 and authorize its documentation-only closure."*** `LO-01`–`LO-04` are answered directly, **in
> documentation**: abrupt direction changes ***"feel immediate and controlled at ORDINARY, FAST and EXTREME speed"***,
> and ***"starts and stops feel natural."***
>
> - ✅ **A SECOND REVIEW THE OWNER VOLUNTEERED — entering Splinter Shot while moving at high speed.** ***"The current
>   ACTION-brake behaviour feels acceptable."*** **Two standing prohibitions come with it:** ***"do not replace it with
>   an instantaneous speed clear and do not scale it in this accepted stage."***
> - ✅ **`LD-02` IS RE-CLASSIFIED, NOT DISCHARGED:** ***"Preserve LD-02 as a measured provisional finding rather than a
>   defect or locked rule."*** It stays a **finding** — measured (0.0315 / 0.1500 / 0.4722 m at ×1 / ×1.8 / ×3), carried,
>   and **not** a defect awaiting repair, **not** a rule anyone may cite. ⚠️ **The runtime still prints it as
>   `DECLARED — NOT REPAIRED`** — accepted historical state, reconciled by the next authorized stage, **not here**.
> - ✅ **THE ACCEPTED INDEPENDENT MOVEMENT-AND-AIM BEHAVIOUR IS RULED ACCEPTABLE.** ***"The visual model continuing to
>   follow aim independently from movement is acceptable. Do not change the accepted independent movement-and-aim
>   behaviour."*** This answers the second of the three rendered-frame observations D-400 reported — the actor briefly
>   travelling backwards relative to her facing after a reversal — **and makes `F73`'s behaviour a thing not to
>   "improve".**
> - ⚠️ ***"No acceleration, braking, speed, arrival, diagnostic multiplier or other numerical value is locked."*** Both
>   registry values stay PROVISIONAL, as do the accepted 30.0 / 38.0 / 120.0 / 3.889 / 0.35 they are quoted against and
>   the ×1.0 / ×1.8 / ×3.0 diagnostic modes.
> - ⚠️ **NOT addressed by this ruling, and therefore still carried:** the camera at extreme speed (`LD-03`, carrying
>   D-398's `CD-12`) and the doorway bunching D-399 already recorded as a finding. **No answer is inferred for either.**
> - ⚠️ **DECLARED DISCREPANCY — ACCEPTED HISTORICAL STATE. DO NOT "FIX" IT AS A TIDY-UP.** **This README is the only
>   file in `game3d/` the closure changed.** The runtime, all seven suites and all seven runners still print *"… PLAYER
>   LOCOMOTION REDIRECTION STAGE DELIVERED and OPEN pending owner live review (D-400)"*, the *"delivers OPEN"*
>   self-denial, `LO-01`–`LO-04` as OWED-TO-OWNER and `LD-02` as `DECLARED — NOT REPAIRED` — the state the artifact was
>   accepted in. Reconciling it (report §6 lists what moves together) is **recommended for the next authorized stage's
>   first act, NOT authorized.**
> - **Every carried debt survives:** `LD-01`, `LD-03`–`LD-14`, `CD-01`–`CD-16`, `KD-11`, the 36 / 35 LIFE CONVERSION
>   overflow, D-371's crowd risk, and the D-389 and D-369 debts. **Units unchanged: 180 · 33 · 22.** **AN EIGHTH stage
>   needs its own ruling.**

> ## 🔶 STAGE 7 — THE PLAYER LOCOMOTION REDIRECTION STAGE — DELIVERED and OPEN (D-400)
>
> ***"Its purpose is to remove unwanted directional sliding at high movement speed while preserving accepted
> click-to-move, navigation, combat commitment and independent aiming. It is not movement-speed tuning, a control-scheme
> change or authorization for other content."*** **Delivered is not accepted, and no number is locked.**
>
> **It is the stage D-399 §5 recommended and did not authorize** — the owner's live-review finding, verbatim: *"at high
> movement speed, abrupt direction changes preserve unwanted old-direction velocity and feel slidey."*
>
> - **ITS FIRST ACT was the reconciliation D-399 §6 recommended**, followed row for row. `ProdConfig.STATE` now states
>   **seven** facts — six accepted stages and this one OPEN. `CO-01`–`CO-05` print **DISCHARGED — D-399**, each carrying
>   **the owner's own answer verbatim** (*"stays **appropriately** around or ahead of me"*, *"avoids **problematic**
>   trailing"*, *"handles congestion **acceptably**"* …) together with D-399's bound and its original text; the
>   *"delivers OPEN"* self-denial is dated history; the regroup reading keeps its wording and now carries D-399's
>   **RULING** beside it — the **shape** canon, the two distances **not locked**. Every pin D-399 §6 listed moved
>   **together**, each still an exact line, each runner gaining the D-398-era line as an absence needle. ⚠️ **The D-399
>   "declared discrepancy" above is therefore history** — true when written. The D-398 runner's `Z16`, a delivery-time
>   claim, prints **[DECLARED]**; this stage's `N16` carries the guard.
> - **What exists now: `scripts/locomotion/` — TWO scripts.** Ground movement carries a **scalar speed on a commanded
>   direction, with no directional inertia at all**. A change of commanded direction — a new click order, a sharp path
>   corner, an abrupt 180° reversal, a stick swing — moves the whole scalar onto the new direction **in the same physics
>   step**, clamped to the current allowed maximum, with **no burst and no slowdown**. Acceleration and ordinary braking
>   are quoted at the accepted top speed and **scaled with the current maximum**, so their **response time is identical**
>   at ×1, ×1.8 and ×3. An **arrival speed ceiling** derived from the registered acceleration rate and the live remaining
>   path prevents overshoot at every diagnostic speed — and **never binds at the accepted speed at all**.
> - **THE STAGE INTRODUCES TWO NUMBERS AND DERIVES EVERYTHING ELSE**, both PROVISIONAL: a wish-direction epsilon carried
>   unchanged from the accepted motor, and a rate reference that is `ProdConfig.TOP_SPEED_MPS` **by reference, never a
>   re-typed literal**. `GroundMotion` declares **no constant of its own**. **NOTHING IS LOCKED.**
> - **Nothing else moved.** `ProdConfig.TOP_SPEED_MPS` is still 3.889 and still a CANDIDATE; the diagnostic ×1.0 / ×1.8 /
>   ×3.0 are D-398's; camera, zoom, Skill timing, minion movement and navigation geometry are unchanged, pinned by
>   **digest** in both directions. **NO input action was added — 29 stays 29** — and **no surface**: the accepted D-398
>   cohesion HUD already prints the live speed mode. `tests/foundation_verification.gd` was **not edited at all**.
> - ⚠️ **ONE THING IS DECLARED AND NOT REPAIRED (`LD-02`):** the **ACTION brake is NOT scaled**. The ruling names
>   *"acceleration and ordinary braking"*, and item 11 forbids altering Skill timing — so a committed action's stop
>   distance still grows with the diagnostic speed. **MEASURED at every mode and reported; the owner's to rule on.**
> - **Units: 180 OWED CRITERIA · 33 EXECUTABLE CHECKS · 22 RUNNER CHECKS · 14 `LD-` · 4 `LO-` owed to the owner.**
>   Accepted counts unmoved (85 · 101 · 40 · 53 · 45 · 40; 20 · 26 · 21 · 21 · 21 · 22). The runner needs
>   `FOUNDATION_BASELINE_DIR` and **`D400_BASELINE_GAME3D`** (a pre-D-400 listing of `game3d/`). Read
>   `docs/testing/D400_PLAYER_LOCOMOTION_REDIRECTION_OWED_CRITERIA_INVENTORY.md` and
>   `docs/testing/D400_PLAYER_LOCOMOTION_REDIRECTION_DELIVERY_REPORT.md`.

> ## ✅ STAGE 6 IS ACCEPTED and CLOSED — D-399. THE IMPLEMENTATION IS ACCEPTED; NO NUMBER IS LOCKED.
>
> ***"I accept D-398 and authorize its documentation-only closure."*** The five live-review questions are answered
> directly, **in documentation**: the pack ***"stays appropriately around or ahead of me"***, ***"avoids problematic
> trailing"***, ***"handles congestion acceptably"***, ***"transitions cleanly between combat and travel"***, and
> ***"recovers unobtrusively at extreme speed."*** The owner's qualifiers are preserved as given.
>
> - ✅ **ONE READING IS NOW A RULING:** ***"The 9 m disengage / 6 m reacquire interpretation of regrouping overriding
>   combat is accepted."*** The **shape** of the rule is canon — disengage at the leash, reacquire at the acquisition
>   range, the band between them giving the hysteresis. **The two distances themselves stay PROVISIONAL.**
> - ⚠️ ***"No diagnostic population, speed, formation, leash, recovery or other numerical value is locked."*** All 40
>   registry values stay PROVISIONAL; **two hounds is still not a pack-size decision**, and 6, 10 and 15 decide nothing.
> - ⚠️ ***"Doorway bunching, target obscuration, wall-lopsided formations and HUD overlap remain findings rather than
>   blockers."*** They are **not accepted as final and not authorized to be fixed here.**
> - ⚠️ **A NEW CARRIED DEFECT — PLAYER LOCOMOTION, RECOMMENDED FOR ITS OWN BOUNDED STAGE, NOT AUTHORIZED:** ***"at high
>   movement speed, abrupt direction changes preserve unwanted old-direction velocity and feel slidey."*** It lives in the
>   **accepted D-373 foundation**, not in the cohort; the D-398 diagnostic speeds merely made it visible. **Read in code
>   and arithmetic, not measured, not changed:** `LocomotionMotor.step()` moves the velocity *vector* toward its target at
>   a fixed **30.0 m/s²**, so a reversal takes 0.26 s at her 3.889 m/s and **0.78 s at ×3.0**, carrying **2.27 m** in the
>   old direction. **It is NOT the slide D-372 resolved** — that was a committed action, braked separately at 120 m/s²,
>   and that path is untouched. Read
>   `docs/testing/D399_MOBILE_MINION_COHESION_ACCEPTANCE_AND_CLOSURE_REPORT.md` §4.
> - ⚠️ **DECLARED DISCREPANCY — ACCEPTED HISTORICAL STATE. DO NOT "FIX" IT AS A TIDY-UP.** **This README is the only file in
>   `game3d/` the closure changed.** The runtime, suites and runners still print *"… MOBILE MINION COHESION STAGE
>   DELIVERED and OPEN pending owner live review (D-398)"*, the *"delivers OPEN"* self-denial and `CO-01`–`CO-05` as
>   OWED-TO-OWNER — the state the artifact was accepted in. Reconciling it (report §6 lists what moves together) is
>   **recommended for the next authorized stage's first act, NOT authorized.**
> - **Every carried debt survives:** `CD-01`–`CD-16`, `KD-11`, the 36 / 35 LIFE CONVERSION overflow, D-371's crowd risk,
>   the D-389 and D-369 debts — and §4's defect is **added**. **Units unchanged: 201 · 40 · 22.** **A SEVENTH stage needs
>   its own ruling.**

> ## 🔶 STAGE 6 — THE MOBILE MINION COHESION STAGE — DELIVERED and OPEN (D-398) *(true when written — ACCEPTED and CLOSED under D-399, above)*
>
> ***"This stage establishes reusable movement, formation, catch-up and congestion behaviour for mobile persistent minions.
> It is not P2, a pack-size increase, a new Skill, final minion AI, art production, VFX work or numerical tuning."***
> **Delivered is not accepted, and no number is locked.**
>
> - **ITS FIRST ACT was the reconciliation D-397 §6 recommended:** `ProdConfig.STATE` states **six** facts — five accepted
>   stages and this one OPEN. The D-396 suite's `KO-01`–`KO-06` print **DISCHARGED — D-397** with their original text,
>   its self-denial is dated history, and every pin D-397 §6 listed moved **together** — each still an exact line, each
>   runner holding the D-396-era line as an absence needle. **The D-397 "declared discrepancy" below is therefore
>   history** — true when written. The D-396 runner's `Y15`, a delivery-time claim, prints **[DECLARED]**; this stage's
>   `Z16` carries the guard.
> - **A shared mobile-minion cohort** (`scripts/cohort/`, 7 scripts) with **Kindred Hounds as its only production
>   consumer**: stable formation slots by combat-entity ID round a **predictive anchor** a little ahead of her, in a
>   **loose, density-aware, multi-ring VANGUARD** formation biased to her travel direction and flanks; pace-keeping by
>   feed-forward and a **catch-up cap that rises with her speed and with the distance behind**; local visual separation
>   and a visual clearance from her that **never** stops her, with **pass-through** when congested, returning or
>   catching up; a **harmless soft recovery** (fade, relocate into a valid unoccupied slot, fade in — no choice, no bite,
>   no damage) on path failure or when far behind; **stable target-relative attack positions** with a waiting ring;
>   **regrouping that overrides combat when she exceeds the accepted 9.0 m leash**; reforming after combat without a
>   command. **The D-396 targeting rule is untouched (byte-identical); the pack is still TWO; no D-396 value moved.**
> - ⚠️ **ONE READING, DISCLOSED FOR THE OWNER TO CONFIRM OR OVERRULE:** "regrouping overrides combat" is read as — when she
>   is farther than the accepted leash (9.0 m) from a member, it abandons its target and acquires nothing until it is back
>   within the accepted acquisition range (6.0 m) of her. **No new distance is introduced.**
> - **Diagnostic stress modes — never the canonical pack:** populations **2 / 6 / 10 / 15** (the two hounds plus labelled
>   **stress minions S3 …**) and travel speeds **ORDINARY ×1.0 / FAST ×1.8 / EXTREME ×3.0** of her accepted 3.889 m/s.
>   **Exactly two new input actions** (27 + 2 = 29): **P** / pad D-pad right cycles the population, **T** / pad START the
>   speed. **Review controls, not commands.** A compact, click-through **cohesion review HUD** at bottom-centre —
>   review tooling, NOT a UI foundation. Developer panels stay hidden at launch.
> - **Every value is PROVISIONAL** (40 registry rows in `CohortConfig`). **Nothing implemented beyond the ruling:** no
>   Additional Minion, no Ranged or Support behaviour (the profile type is the extension point), no other Skill, no Prey,
>   no Mark, no commands, stances, feeding or pets, no tuning, no final art, animation, audio or VFX.
> - **Three runtime defects were found at delivery by LOOKING at the rendered frames** — invisible to every headless check
>   — and corrected in place, each recorded in its own dated comment: a settled member acting on a **stale path verdict**
>   (spurious soft recoveries); a member **summoned before the navigation map synchronised** spawning at an unvalidated
>   point; and **two review-HUD lines cut off**. One more was found by a check's own control: an **occupancy radius**
>   that read a neighbour's slot as occupied.
> - **Units: 201 OWED CRITERIA · 40 EXECUTABLE CHECKS · 22 RUNNER CHECKS · 16 `CD-` · 5 `CO-` owed to the owner.**
>   Accepted counts are unmoved (85 · 101 · 40 · 53 · 45; 20 · 26 · 21 · 21 · 21). Read
>   `docs/testing/D398_MOBILE_MINION_COHESION_OWED_CRITERIA_INVENTORY.md` and
>   `docs/testing/D398_MOBILE_MINION_COHESION_DELIVERY_REPORT.md`.

> ## ✅ STAGE 5 IS ACCEPTED and CLOSED — D-397. THE IMPLEMENTATION IS ACCEPTED; NO TRIAL VALUE IS LOCKED.
>
> ***"I accept D-396 and authorize its documentation-only closure."*** `KO-01`–`KO-06` are ***"satisfactory at the reviewed
> two-hound scale and current movement speed."*** ***"No trial value is locked."*** Every D-396 registry value stays
> PROVISIONAL, and the pack of two is still not a pack-size decision.
>
> - ⚠️ **A NEW CARRIED RISK — PACK COHESION:** ***"This review does not prove behaviour at late-game movement speed or with
>   10–15 minions."*** It is **recommended for a separate stage and NOT AUTHORIZED**. What the code shows about it (read,
>   not measured) is in `docs/testing/D397_KINDRED_HOUNDS_ACCEPTANCE_AND_CLOSURE_REPORT.md` §4:
>   - two follow slots only;
>   - a 5.2 m/s following cap;
>   - one path query per hound per re-evaluation at least;
>   - no distribution rule.
> - ⚠️ **DECLARED DISCREPANCY — ACCEPTED HISTORICAL STATE. DO NOT "FIX" IT AS A TIDY-UP.** *(True when written; **D-398's
>   first act reconciled it** exactly as recommended — see stage 6 above.)* **This README is the only file in
>   `game3d/` the closure changed.** The runtime, suites and runners still print *"… KINDRED HOUNDS STAGE DELIVERED and OPEN
>   pending owner live review (D-396)"*, the *"delivers OPEN"* self-denial and `KO-01`–`KO-06` as OWED-TO-OWNER — the state
>   the artifact was accepted in. Reconciling it (report §6 lists what moves together) is **recommended for the next
>   authorized stage's first act, NOT authorized.**
> - **All carried debts survive:** `KD-01`–`KD-16`, the pre-existing 36 / 35 LIFE CONVERSION overflow in the accepted D-392
>   loadout, D-371's crowd-avoidance risk, the D-389 and D-369 debts. **Units unchanged: 202 · 45 · 21.** **No next stage
>   is authorized.**

> ## 🔶 STAGE 5 — THE KINDRED HOUNDS STAGE — DELIVERED and OPEN (D-396) *(true when written — ACCEPTED and CLOSED under D-397, above)*
>
> ***"This is explicit owner authorization for one bounded Kindred Hounds implementation stage inside `game3d/`. It is not
> P2, full Beastmaster implementation, final art, VFX production or tuning."*** **Delivered is not accepted.**
>
> - **ITS FIRST ACT was the reconciliation D-394 §7 recommended:** `ProdConfig.STATE` states **five** facts — the four
>   accepted stages and this one OPEN. The D-392 suite's `SO-01`, `02`, `03` and `05` print **DISCHARGED — D-394** with
>   their original text; `R08`, `S14`, `S16`, `S17`, `T09`, `T11`–`T13`, `T20`, `W05`, `W10`, `W11`, `W13`–`W15`, `I01`,
>   `A01`, `A03`, `A35`, `H01`, `H03` and `H56` moved **together**. **The D-394 "declared discrepancy" below is history.**
>   The D-392 runner's `W17` — a delivery-time claim — prints **[DECLARED]**; this stage's `Y15` carries the guard.
> - **Kindred Hounds** (`scripts/hounds/`), a canonical **Persistent** Skill Imprint, learned at rank 1 / 0 XP, with **no
>   activation**. It runs in the labelled **D-396 review loadout**: the diagnostic aura is replaced, the low-rank twin
>   unbound, and Capacity is **not** increased — 32 / 35 on Mana, 33 / 35 in LIFE CONVERSION. **Every number is a
>   PROVISIONAL review candidate, none a lock:**
>   - 20 % of maximum Mana reserved at rank 1;
>   - **two** hounds;
>   - acquisition **6.0 m**, leash **9.0 m** (from the Huntress);
>   - speed 5.2 m/s;
>   - bite 9.0 every 0.75 s;
>   - 80 Life, recovery **4.0 s**.
> - **Targeting is the accepted rule:** retain a valid target, otherwise the nearest reachable eligible enemy **to the
>   hound** inside her acquisition range, exact ties by combat-entity ID. **No Prey. No Mark.** On abandoning a target a
>   hound returns to her or acquires another. Hounds obstruct nobody (layer 16, masked by nothing), and ordinary enemies
>   never select them.
> - **Procedural stand-ins** (not final art). **A top-right review HUD** — review tooling, NOT a UI foundation.
>   **Exactly one new input action:** `diagnostic_hound_fall` (**H** / pad D-pad left) fells a hound for review. It is
>   **not a command**.
> - **The accepted suites run on the accepted D-392 loadout**, restored by a **declared fixture** at their start-up.
> - ⚠️ **A pre-existing finding, disclosed and NOT repaired:** in the accepted D-392 loadout, LIFE CONVERSION demands 36 /
>   35 Capacity and deactivates Splinter Shot. The review loadout is sized so that it does not occur.
> - **Units: 202 OWED CRITERIA · 45 EXECUTABLE CHECKS · 21 RUNNER CHECKS · 16 `KD-` · 6 `KO-`.** Accepted counts are
>   unmoved. Read `docs/testing/D396_KINDRED_HOUNDS_OWED_CRITERIA_INVENTORY.md` and
>   `docs/testing/D396_KINDRED_HOUNDS_DELIVERY_REPORT.md`.

> ## ✅ STAGE 4 IS ACCEPTED and CLOSED — D-394. THE IMPLEMENTATION IS ACCEPTED; ITS NUMBERS, ANIMATION AND PRESENTATION ARE NOT.
>
> ***"I accept the corrected D-392 stage and authorize its documentation-only closure."*** The owner's live review:
> ***"SO-01, SO-02, SO-03 and SO-05 are satisfactory … the correction did not change those behaviours"*** — confirmed by
> comparing the D-392 and D-393 runs of record. ***"Preserve every timing, distance, Capacity value, animation and
> presentation detail as provisional."*** The ≈ 0.50 s release, the 0.288 s recovery, the ×1.93 playback, the arrow's
> speed, range and radius, the tolerances, Splinter Shot's Capacity cost, damage and Mana cost, the KayKit placeholder
> clips and every placeholder visual **stay PROVISIONAL**. **The five D-389 debts stay CARRIED; the 15 `SD-` rows are
> unchanged; units 203 · 53 · 21.**
>
> ⚠️ **DECLARED DISCREPANCY — ACCEPTED HISTORICAL STATE. DO NOT "FIX" IT AS A TIDY-UP.** **This README is the only file in
> `game3d/` that changed.** The runtime, suites and runners still print *"… HUNTRESS SPLINTER SHOT STAGE DELIVERED and OPEN
> pending owner live review (D-392)"*, the *"delivers OPEN"* denial and `SO-01`/`02`/`03`/`05` as OWED-TO-OWNER — the
> state the artifact was accepted in. Reconciling it moves `ProdConfig.STATE` and `R08`, `S14`, `S16`, `S17`, `T11`,
> `T20`, `W13`, `W15`, `I01`, `A01`, `A03`, `A35`, `H01`, `H03`, `H56`, `W05`, `W10`, `W11`, `W14` **together** —
> **RECOMMENDED and NOT AUTHORIZED**, for the next authorized stage as its first act. **No next stage is authorized.** Read
> `docs/testing/D394_SPLINTER_SHOT_ACCEPTANCE_AND_CLOSURE_REPORT.md`.

> ## ⚠️ D-393 — PREY REMOVED BEFORE ACCEPTANCE. STAGE 4 RE-DELIVERED OPEN. *(true when written — ACCEPTED and CLOSED under D-394, above)*
>
> ***"Prey is no longer the Huntress's signature mechanic."*** Removed from this project, **not deactivated**:
> `scripts/huntress/huntress_prey.gd`, `prey_marker.gd`, `prey_eligibility.gd` (and `.uid`), the Prey state on
> `HuntressRuntime`, the review HUD's Prey line, the Prey captures and **frames 21–22**, rows `SD-01`–`SD-03` and `SO-04`,
> and checks `H46`–`H50`. **Kept:** `scripts/huntress/hit_eligibility.gd` — **the same predicate, now a general
> enemy-eligibility rule** — and the combat-entity ID. **Splinter Shot, the facing snap, STOP and recovery cancellation,
> the placeholder animation, one physical arrow and time-of-impact collision are unchanged.** **Huntress's Mark is a
> future concept and is NOT implemented** — the runtime says so. **An unknown `d392_` capture now refuses to save.**
> `ProdConfig.STATE` is unchanged. **Units now: 203 OWED CRITERIA · 53 EXECUTABLE CHECKS · 21 RUNNER CHECKS · 15 `SD-` ·
> 4 `SO-`**; the accepted `A26` was re-scoped one for one. Read `docs/testing/D393_PREY_REMOVAL_CORRECTION_REPORT.md`.
> *(Every Prey statement in the D-392 block below was true when written.)*

> ## 🔶 STAGE 4 — THE HUNTRESS SPLINTER SHOT STAGE — DELIVERED and OPEN (D-392) *(true when written — ACCEPTED and CLOSED under D-394, above)*
>
> ***"This is explicit owner authorization for one bounded first Huntress implementation stage inside `game3d/`. It is
> not P2, campaign production, final animation, final VFX or full Huntress implementation."*** **Delivered is not
> accepted.**
>
> - **ITS FIRST ACT was the reconciliation D-383 §6 recommended:** `ProdConfig.STATE` now states **four** facts —
>   *"FOUNDATION STAGE ACCEPTED and CLOSED (D-373) · IMPRINT STAGE ACCEPTED and CLOSED (D-376) · D-378 ALIGNMENT STAGE
>   ACCEPTED and CLOSED (D-383) · HUNTRESS SPLINTER SHOT STAGE DELIVERED and OPEN pending owner live review (D-392)"* —
>   `AM-01`–`AM-05` print **DISCHARGED — D-383** with their original text **preserved verbatim** (15 → 10 printed
>   rows), and every state pin moved **together** (`R08`, `S14`, `S16`, `S17`, `T09`, `T11`–`T13`, `T20`, `A01`, `A03`,
>   `A35`, `I01`). **The declared discrepancy D-383 accepted is therefore GONE.**
> - **SPLINTER SHOT, the Huntress's ordinary shot, is a CANONICAL Skill Imprint** learned into the live Imprint Library
>   at **rank 1 / 0 XP**, in one **unmodified** Configuration on **binding 6** — **right mouse**, key **6** or pad button
>   7 — used through the ACCEPTED `SkillRuntime.use_binding()`, **repeating while held**. **The diagnostic bolt is
>   TEST-ONLY**: its action keeps its name with no physical input.
> - **Timing:** release at the **≈ 0.50 s PROVISIONAL review candidate**; recovery **0.288 s**, derived from the
>   accepted bolt; the accepted **STOP** commitment and **post-release recovery cancellation**, unchanged. **Facing:**
>   the mechanical facing **snaps** to the sampled aim when the use begins; the visual **blends** at the accepted
>   720°/s and is **aligned before release** (a guard counts any late visual — zero in play).
> - **ONE physical arrow per use**, from the nocked arrow, on the release frame; **swept, by exact time of impact**; a tie
>   within the provisional 0.001 m goes to the **lower combat-entity ID** (`CE-0001` …, per area, in composition order —
>   never a name, a tree order or a memory address); **world geometry stops it without a Hit**. **Prey** follows the
>   ruled eligibility and is shown by a **notched ring, a chevron and the word PREY with the ID**, not by colour.
>   **The multi-target Prey designation rule STAYS OWED.**
> - **TEMPORARY PLACEHOLDER animation and presentation:** the CC0 **KayKit** bow clips retargeted onto the current
>   65-joint Huntress with the D-388 approach, a placeholder bow, procedural string and arrow. **The five accepted D-389
>   polish debts are CARRIED, not fixed.** Intake: `assets/third_party/huntress_placeholder/`.
> - **Developer surfaces hidden at launch; one small review HUD** (bottom-right) for Splinter Shot, the action state and
>   the Prey. **The D-381 HUD is retained, hidden.**
> - **Units:** **207 OWED CRITERIA · 57 EXECUTABLE CHECKS · 21 RUNNER CHECKS** (`tests/huntress_smoke.sh`), with 18
>   `SD-` rows and 5 `SO-` rows owed to the owner. The accepted suites run as regressions: **85 · 101 · 40.**
>   **Every number is PROVISIONAL and nothing is locked.** Read
>   `docs/testing/D392_SPLINTER_SHOT_OWED_CRITERIA_INVENTORY.md` and `docs/testing/D392_SPLINTER_SHOT_DELIVERY_REPORT.md`.

> ### ⚠️ The D-383 discrepancy block below was true when written, and D-392's first act reconciled it.

> ## ✅ STAGE 3 IS ACCEPTED and CLOSED — D-383. THE RULES ARE ACCEPTED; THE NUMBERS ARE NOT.
>
> ***"The compact HUD makes the system comfortably reviewable while playing. The reservation states are
> understandable, the Mana pressure feels appropriate for this prototype, and exchanging Mana reservation for Life
> reservation makes conceptual sense. The Health clamp and no-automatic-heal behaviour also read correctly."***
>
> - **ACCEPTED:** the D-378 semantic alignment this project demonstrates — up to eight equipped Active
>   Configurations, one per binding · no arbitrary Persistent slot cap · regeneration from unreserved maximum Mana ·
>   percentage-only reservation · proportional Mana→Life conversion reserving exactly one resource · new Imprints at
>   Mastered Rank 1 / 0 XP · purely beneficial Augments · no universal Transform Capacity surcharge. Also **both
>   developer surfaces hidden by default and independently toggleable**, **the review HUD as useful REVIEW TOOLING**,
>   and **the Life-reservation rule**, now canon in `design/ATTRIBUTES_AND_DAMAGE_MODEL.md` §8 and
>   `design/SKILLS_AND_SKILL_MODIFICATION.md` §0.7.
> - **NOT ACCEPTED, NOT LOCKED:** 4.4 % regeneration · the 1.444 ratio · 203.3 Health or any resource total · any
>   Capacity value or cost · any XP threshold, curve, catch-up value, rank cap or levelling duration · the five
>   diagnostic Configurations as a content target · **the R-cycle control** · **the HUD as a production UI
>   foundation** · **the current absence of healing as a design rule** · diagnostic content, Skill names, presentation.
> - ⚠️ **A DECLARED DISCREPANCY — ACCEPTED HISTORICAL STATE. DO NOT "FIX" IT AS A TIDY-UP.** The runtime, all three
>   suites and all three runners still print *"D-378 ALIGNMENT STAGE DELIVERED and OPEN pending owner live review
>   (D-380)"*. The D-381 denial still says *"It re-delivers D-380 OPEN"*, and the D-380 suite still prints `AM-01`–`AM-05`
>   as OWED-TO-OWNER. **That is the state the artifact was ACCEPTED IN, preserved by the owner's instruction**; the
>   current state is carried by the documentation. Reconciling it moves `T11`, `T13`, `T20`, `S14`, `S16`, `S17`, `R08`,
>   the foundation runner's truthfulness list, `A01`, `A03`, `A35`, the Imprint suite's state check and `T09`
>   **together** — **RECOMMENDED and NOT AUTHORIZED**, for the next authorized stage as its first act.
> - **NOTHING IN THIS PROJECT WAS CHANGED TO EARN THIS** except this README. **Units unchanged: 162 · 40 · 21.** It
>   authorizes **no Huntress implementation, VFX intake, new content, P2 or next stage.** Read
>   `docs/testing/D383_ALIGNMENT_ACCEPTANCE_AND_CLOSURE_REPORT.md`.

> ## 🔶 STAGE 3 — THE D-378 ALIGNMENT STAGE — DELIVERED and OPEN (D-380) *(true when written — ACCEPTED and CLOSED under D-383, above)*
>
> ***"This is a semantic alignment stage, not Huntress implementation, not progression tuning, and not
> authorization for P2 or another Machinations model."*** **Delivered is not accepted.**
>
> **ITS FIRST ACT was the reconciliation D-376 §7 recommended:** `ProdConfig.STATE` now states **three**
> facts — *"FOUNDATION STAGE ACCEPTED and CLOSED (D-373) · IMPRINT STAGE ACCEPTED and CLOSED (D-376) · D-378
> ALIGNMENT STAGE DELIVERED and OPEN pending owner live review (D-380)"* — the Imprint suite's eight `MO-`
> rows moved to a printed **DISCHARGED** block with their original text **preserved verbatim** (24 → 16
> deferred rows), and **`S14`, `S16`, `S17` and `R08` were re-pinned in the same change**, each state pin
> still **exact-line**. **`tests/foundation_verification.gd` was not edited at all.**
>
> **WHAT THE RUNTIME NOW DOES — each rule the owner's, each number PROVISIONAL:**
> - **Up to EIGHT equipped Active Configurations, one per binding** (OD-09) — the six cap is **removed**;
>   empty bindings stay valid; **global Capacity limits how deeply the loadout is modified**.
> - **No arbitrary Persistent slot cap** — the four-slot candidate D-376 **withdrew** was still enforced;
>   it is **removed**, and reservation, compatibility and Capacity are the only limits.
> - **Mana regeneration = a PROVISIONAL rate × UNRESERVED maximum Mana** (OD-05), never current Mana. The
>   rate is **derived** (22 / 500 = 4.4 %/s), so with nothing reserved it regenerates **exactly** as before.
> - **Mana→Life conversion is PROPORTIONAL and the flat Life tithe is GONE** (OD-06). Life reserved = the
>   Mana fraction the effect would reserve × a **PROVISIONAL** ratio (**1.444** at rank 1, derived from the
>   prototype's own 0.26 / 0.18). **The ≈ 2× candidate is NOT adopted.** The modifier is displayed as
>   **"Life Conversion"**; its id is kept.
> - **Purely beneficial Augments are LEGAL** (OD-12); a **silent** modifier is still refused.
> - **A newly learned Imprint starts at Mastered Rank 1 / 0 XP** (OD-01): `learn()` takes **no** rank, and
>   the start-up ranks are **declared DIAGNOSTIC SEEDING**, counted and printed.
>
> **NOTHING IS LOCKED AND NO D-378 TEST CANDIDATE IS ADOPTED** — not the ≈ 25 % unequipped progression,
> the ≈ 3 % floor, the ≈ 2× ratio, milestone Capacity or the 24 / 30–36 bands. **Every D-378 ruling is
> mapped to exactly one of IMPLEMENTED · ALREADY SATISFIED · DEFERRED — CANDIDATE ONLY · OUT OF SCOPE**,
> printed on every run and on the panel's new **D-378 ALIGNMENT** page (**F2**, page 6).
>
> **Units: 121 OWED CRITERIA · 28 EXECUTABLE CHECKS · 21 RUNNER CHECKS** *(at D-380's delivery — true when
> written; **146 · 35 · 21** since D-381, below)*. Read
> `docs/testing/D380_ALIGNMENT_OWED_CRITERIA_INVENTORY.md` and `docs/testing/D380_ALIGNMENT_DELIVERY_REPORT.md`
> before touching it.

> ## 🔶 D-382 — BOTH DEVELOPER SURFACES START HIDDEN; A LIFE RESERVATION NOW GOVERNS LIVE HEALTH
>
> **The owner's clarification of D-381 and ruling on `AD-11`. Stage 3 is RE-DELIVERED OPEN; nothing is accepted.**
> *(True when written — accepted and closed under D-383, above.)*
>
> - **The F1 overlay now starts HIDDEN too** (it launched on from D-370 until D-382). **F1 / pad Y** and **F2 / pad
>   BACK** still toggle the overlay and the panel, **independently**. **The review HUD starts visible.**
> - **Entering or raising a Life reservation clamps live Health to usable Health in the same call**: 300 → 203.3 when
>   LIFE CONVERSION is entered at full Health. **Removing or reducing it does NOT heal.** Every raise of live Health
>   (the one existing path is `reset()`; **there is no healing mechanic**) is capped by usable Health. **A Mana
>   reservation never changes Health.** Implemented as a ceiling on `Damageable`, pushed by the live `ResourcePool`
>   inside `set_reservation()`.
> - ⚠️ **In play:** with no healing in the prototype, Health lowered by LIFE CONVERSION **stays lowered** after R cycles
>   on to OFF, e.g. 203 current against 300 usable. **Restart to restore it.**
> - **No tuning value changed**: not the conversion ratio, not any reservation fraction, not any Mana or Life value.
> - **Units now: 162 OWED CRITERIA · 40 EXECUTABLE CHECKS · 21 RUNNER CHECKS · 15 printed rows** (`AD-11` DISCHARGED).
>   Read `docs/testing/D382_HEALTH_RESERVATION_AND_REVIEW_SURFACES_REPORT.md`.

> ## 🔶 D-381 — A BOUNDED REVIEWABILITY CORRECTION; STAGE 3 RE-DELIVERED OPEN *(true when written — accepted and closed under D-383)*
>
> **Why, disclosed:** *"The large developer panel prevents me from playing and understanding the resource
> behaviour simultaneously."* **The D-380 debug presentation was not human-reviewable during play.**
>
> - **The developer panel (F2) is now HIDDEN at launch**, and F2 / pad BACK still open it. **The F1 overlay still
>   launches ON**, which is accepted foundation behaviour; F1 hides it. *(True until D-382, above.)*
> - **A compact DIAGNOSTIC review HUD**, bottom-right (`scripts/imprint/review_hud.gd`), shows Health and Mana as
>   current · usable · max · reserved. The reserved zone is **HATCHED, bounded by a TICK and LABELLED RESERVED**,
>   so it never relies on colour alone. It also shows regen/s, the reservation state, the Imprint learning rule and
>   *"5 equipped / 8 supported"*. **It owns no number, and it is NOT a UI foundation.**
> - **Key `R` / pad right-stick click cycles the reservation:** OFF → MANA RESERVATION → LIFE CONVERSION → OFF.
>   It is the **only** input added, and it passes the same safe-state gate as every other edit.
> - ⚠️ **A limit it exposed, not fixed (`AD-11`):** with LIFE CONVERSION on, **live Health is not reduced** by the
>   reservation. The HUD shows it (e.g. 300 live vs 203 usable) and warns. *(True until D-382, above, which fixed it.)*
>
> **Units at D-381: 146 OWED CRITERIA (121 + 25) · 35 EXECUTABLE CHECKS (28 + 7) · 21 RUNNER CHECKS · 16 rows.** Read
> `docs/testing/D381_REVIEWABILITY_CORRECTION_REPORT.md`. **`ProdConfig.STATE` is unchanged: still DELIVERED and
> OPEN (D-380).** *(True when written — see the D-383 block above.)*

> ## ✅ STAGE 2 IS ACCEPTED and CLOSED — D-376. THE ARCHITECTURE IS CANON; THE NUMBERS ARE NOT.
>
> ***"The prototype feels good in live play. Accept the architecture and demonstrated behaviours, not its
> provisional numerical tuning, placeholder presentation or diagnostic content."***
>
> **FOUR CATEGORIES, AND A READER MUST NEVER COLLAPSE TWO OF THEM.** **ACCEPTED ARCHITECTURE** is canon and
> may be built against · a **CURRENT WORKING BASELINE** is the present shape and **is amendable by later live
> build testing** · a **PROVISIONAL NUMERICAL VALUE** licenses **nothing** · **DIAGNOSTIC-ONLY** content is
> **never a production rule.**
>
> **ACCEPTED — and now canon at `design/SKILLS_AND_SKILL_MODIFICATION.md` §0, the ONE canonical document the
> acceptance amended:** the **Imprint** terminology and the permanent **Imprint Library** · **one Skill
> Imprint and up to four total modifier slots, SHARED by Augments and Transforms, at most one Transform** ·
> **reuse across Configurations WITHOUT duplicating progression** · the **MASTERED / selectable EFFECTIVE
> RANK** split, with **identity complete at rank 1** · **Imprint XP from applicable combat XP, awarded ONCE
> per qualifying event** · **eight active input bindings**, with bindings and equipped Configurations
> **distinct** and **empty bindings valid** · **Persistent Skills limited NATURALLY and by NO arbitrary slot
> ceiling** · a **GLOBAL Configuration Capacity budget**, with **most Capacity from deterministic
> progression** · **reservation applied after modifiers**, with a **Mana→Life conversion reserving EXACTLY
> one resource** · **autonomous beasts as the BEASTMASTER FOUNDATION** · and the **Transform standard**:
> materially change behaviour, **not merely add damage.**
>
> **CURRENT WORKING BASELINE, NOT A LOCK: SIX equipped Active Configurations.** *"Eight and six are not
> immutable balance locks."* *(Amended by D-378 OD-09 to **up to eight, one per binding**; the runtime was
> aligned under **D-380**. Still a working baseline, not a lock.)*
>
> ⚖️ **THE THREE CONFLICTS THAT NEEDED A RULING ARE RESOLVED.** **X-02: D-079's refusal of an arbitrary
> Persistent-slot cap STANDS, and the FOUR-SLOT CANDIDATE IS WITHDRAWN** — this project's four-slot
> presentation is **diagnostic evidence only.** **X-03: combat-XP progression is NOT use-based**, so canon's
> refusal of use-based progression stands unchanged and the two concepts are **not** contradictory.
> **X-04: GENERIC RANDOMLY ROLLED GEAR CAPACITY IS NOT ACCEPTED** as a required foundation for builds, and
> ordinary equipment changes **must not unexpectedly destroy a normal functioning build.** Rare,
> build-defining Capacity items **remain possible and are NOT authorized.**
>
> ⚠️ **DIAGNOSTIC-ONLY, AND NO PART OF THE PRODUCT:** the four-Persistent-slot presentation · the **simulated
> gear toggle** · the **dense loadout panel**, a developer evaluation surface and **NOT a production UI
> foundation** · the **diagnostic safe-state override**, prototype tooling and **NOT accepted player-facing
> behaviour** · every placeholder — projectiles, the crate/ballista marker, the beasts, the VFX · and **every
> Skill name in this project.**
>
> ⚠️ **STILL PROVISIONAL:** the **rank cap 20** · the XP and catch-up curves · the six-Active balance ·
> **every Capacity total and cost, the 30 / 35 figures INCLUDED** · the gear Capacity amount · reservation
> percentages · Mana / Life totals · cooldowns, damage, durations and summon counts · the panel layout.
> **NONE of them may be cited as settled.**
>
> **It finalizes NO Huntress Skill name, roster, balance, animation, VFX or command-beast design; completes
> neither P1 nor the original P1C; authorizes no P2; and authorizes NO progression, Capacity or reservation
> tuning.** **It discharged the eight `MO-` owner-review rows and NOT ONE other carried debt.**
>
> **The eight owner-review answers are recorded in
> `docs/testing/D376_IMPRINT_ACCEPTANCE_AND_CLOSURE_REPORT.md` §5.**

> ## ✅ THE D-376 DECLARED DISCREPANCY IS RECONCILED — D-380, as its first act
>
> *The block below was true from D-376 until D-380, and is kept as history. **D-380 carried out the
> recommended remedy exactly:** `ProdConfig.STATE` updated, the eight `MO-` rows moved to DISCHARGED with
> their text preserved, and `S14`, `S16`, `S17` and `R08` re-pinned **in the same change**. No guard was
> weakened.*
>
> ## ⚠️ A DECLARED DISCREPANCY — and it must NOT be "fixed" as a tidy-up *(historical, D-376 → D-380)*
>
> **The runtime, both suites and both runners still print *"IMPRINT STAGE DELIVERED and OPEN pending owner
> live review (D-375)"*, and the imprint suite still prints its eight `MO-` rows as OWED-TO-OWNER.**
>
> **Nothing inside this project was changed to earn the acceptance, because the owner forbade it** — *"Change
> nothing in the runtime, tests, constants, diagnostic Skills, assets or evidence captures to earn
> acceptance. Do not rewrite the delivered artifact to appear as though it accepted itself… do not weaken or
> repin guards merely to manufacture closure."*
>
> **And it is mechanical, not cosmetic.** Changing that string means editing `scripts/core/prod_config.gd`,
> which forces **FOUR pins to move so the acceptance fits:** the imprint runner's **exact-line `S16`**, its
> **`S17`** refusal proof, its **`S14`** truthfulness pin, and the foundation runner's **`R08`**.
>
> **THOSE STRINGS ARE THE STATE THE ARTIFACT WAS ACCEPTED IN. The current state is carried by the
> documentation, not by the artifact.**
>
> **RECOMMENDED — AND NOT AUTHORIZED —** for the next authorized stage, as its first act: update
> `ProdConfig.STATE` and **re-pin `S14`, `S16`, `S17` and `R08` in the same change**, so the artifact and its
> guards move together. **This is the identical situation D-373 §6.1 declared for stage 1, and the identical
> remedy — which D-375 then carried out exactly as recommended.**

> ## STAGE 2 AS DELIVERED (D-375) — historical, and accurate from D-375 until D-376
>
> **A testable Skill-system foundation. IT FINALIZES NOTHING.** The ruling's own words: *"not the final
> Huntress roster, not final balance, not P2, and not authorization to build Rift Shards yet"*, and it
> **finalizes no roster, slot count, rank cap, Capacity value, XP curve, reservation value or balance.** All
> eighteen denials print on every run.
>
> **What it contains:** **Skill / Augment / Transform Imprints** in a permanent **Imprint Library** ·
> **Skill Configurations** with **exactly one Skill Imprint, four SHARED modifier slots and at most one
> Transform** · tag-driven compatibility with an explicit reason for every refusal · a **provisional 1–20
> Mastered / Effective rank model** · a global **Configuration Capacity** budget · a separate **Persistent
> Loadout** reserving **exactly one** resource · and **three diagnostic builds** — a bow volley, an
> autonomous ballista and an autonomous beast pack.
>
> **EIGHT active bindings are PRESERVED AS EIGHT.** Six equipped Active Configurations and four Persistent
> Configurations are **PROVISIONAL CANDIDATES UNDER REVIEW**, printed as such. **The four-Persistent
> candidate CONFLICTS WITH D-079 and says so on every run — that conflict needs an owner ruling.**
>
> *(**D-376 GAVE THAT RULING: D-079 STANDS and the four-Persistent candidate is WITHDRAWN as a canonical
> cap.** Eight bindings are ACCEPTED; six Active is a **working baseline**. The runtime still prints the
> candidate and the conflict, because nothing was changed to earn the acceptance — see the declared
> discrepancy above.)*
>
> **Units: 149 OWED CRITERIA · 101 EXECUTABLE CHECKS · 26 RUNNER CHECKS**, plus the accepted stage's
> **125 / 85 / 20**. **Five counts, none a synonym for another.** *(**The D-376 acceptance moved NOT ONE of
> the five.**)*
>
> **NOT ONE ACCEPTED D-373 VALUE WAS MODIFIED** — 24 of them are asserted one by one against the figures the
> acceptance recorded. Read `docs/testing/D376_IMPRINT_ACCEPTANCE_AND_CLOSURE_REPORT.md`,
> `docs/testing/D375_IMPRINT_OWED_CRITERIA_INVENTORY.md` and
> `docs/testing/D375_IMPRINT_DELIVERY_REPORT.md` before touching it.

> ## WHAT THE FINAL LIVE REVIEW ACCEPTED — and what it explicitly did not
>
> ***"The slidey feeling is gone… Returning to movement feels immediate and fluid. The overall
> movement-and-attack rhythm now feels like Torchlight to me, and I love it."***
>
> **The owner's own qualifier: *"Treat the Torchlight comparison as a description of responsiveness and feel,
> not authorization to copy its content or mechanics."*** It is a statement about **rhythm** — nothing more.
>
> **ACCEPTED:** the **STOP / ALLOW action-movement architecture** and the **recovery-cancellation
> behaviour**. **That is all.**
>
> **NOT LOCKED — the owner's own list:** the **0.1667 s** release point · the **0.4500 s** action duration ·
> the **120 m/s²** action brake · **3.889 m/s** movement speed · the camera, the zoom bounds and the zoom
> default. **The preference for the furthest zoom remains an OBSERVATION, not a lock**, and the default is
> still **14.0 m**.

> ## "CLOSED" MEANS THE STAGE, NOT THE PROJECT
>
> ***"Acceptance closes this bounded foundation stage; it does not freeze the canonical `game3d/` project
> forever. Future modifications require their own authorized stage and must preserve this accepted baseline
> truthfully."***
>
> **This is the clause most likely to be misread, in either direction.** `game3d_spike/` and
> `game3d_boss_spike/` are **preserved and NOT continued**. **`game3d/` IS continued** — it is the production
> project. **A freeze reading strands it; an open-door reading lets the accepted baseline drift away
> unrecorded. Both are wrong.** Every modification needs **its own authorized stage.**

> ## ✅ THE DECLARED DISCREPANCY IS RECONCILED — D-375
>
> *Historical, and true from D-373 until D-375: the runtime, the suite and the runner all still printed
> **"DELIVERED and OPEN pending owner live review"**, and the suite's `M-04` row still printed as
> OWED-TO-OWNER. **Nothing inside this project had been changed to earn its acceptance, because the owner
> forbade that**, and D-373 §6.1 therefore DECLARED the discrepancy and RECOMMENDED — explicitly NOT
> authorizing — its repair by the next authorized stage, as that stage's first act.*
>
> **THE D-375 RULING AUTHORIZED IT, AND IT IS DONE, EXACTLY AS RECOMMENDED — TOGETHER WITH THE PINS.**
>
> - **`ProdConfig.STATE` now states BOTH facts** and neither is false: *"FOUNDATION STAGE ACCEPTED and
>   CLOSED (D-373) · IMPRINT STAGE DELIVERED and OPEN pending owner live review (D-375)"*.
> - **`M-04` MOVED** out of the deferred rows into a printed **`DISCHARGED_ROWS`** block that **preserves its
>   original text verbatim** and names the decision that discharged it. **A discharged row is not a pass.**
> - **The runner's pins moved IN THE SAME CHANGE:** `PIN_DEFERRED` **12 → 11**, and `R08`'s STATE pin became
>   an **EXACT-LINE** match — **stricter than the substring it replaced**, proved able to refuse an altered
>   line, and paired with an assertion that the **old, now-false line is GONE**.
>
> **NO GUARD WAS WEAKENED TO MAKE ANY OF THIS PASS.** The accepted suite's **85 executable checks did not
> move**, and nothing in it was removed, renamed or renumbered.
>
> > **`game3d_spike/` and `game3d_boss_spike/` STILL PRINT their own "DELIVERED and OPEN" strings, and those
> > must NOT be "fixed".** D-367 §5.1 and D-369 forbid editing them at all. **That instruction applies to
> > THEM — which is exactly why this reconciliation touched only `game3d/`'s own state line.**

> ## The owed owner-review row is DISCHARGED
>
> **`M-04` — does the action commitment, with recovery cancellation, feel fluent? — is DISCHARGED** by the
> final live review. **`M-01`, `M-02` and `M-03` remain OBSERVATIONS, not locks.**
>
> Designated under the owner's **formal 3D production pivot** ruling of 2026-09-17. It is the **first
> bounded 3D production foundation**, and it is **the project's canonical production root** going forward.
>
> **It is NOT:** P2 · a completed phase · a completion of P1 or the original P1C · campaign, prologue or
> Act I content · final art · the final Huntress · a canonical Huntress class specification · a production
> boss · a loot, economy or progression system · a UI foundation · final tuning.
>
> **It LOCKS NO VALUE.** Every camera, zoom, speed, damage, timing, scale and VFX number in it is
> **PROVISIONAL**, printed as such in the runtime and in the verification output. **Acceptance did not change
> that for a single value.**
>
> **ALL carried risks and debts survive intact** — crowd avoidance, dense body interaction, attachment
> orientation, the final Huntress model and bow animation, QAL source-control handling, D-369's
> attack-readability debt, and every P1A / P1B / P1C obligation. **The acceptance discharged NONE of them.**

---

## How to run it

```bash
/Applications/Godot.app/Contents/MacOS/Godot --path . --resolution 1920x1080
```

**Controls** — there is deliberately **no WASD binding** (`CLAUDE.md` §8: *"Click-to-move is the canonical
mouse control scheme. There is no WASD binding in the MVP."* Both 3D spikes bound WASD; they were spikes).

| Input | Action |
| --- | --- |
| **Left mouse, held** | **Click-to-move** — the canonical mouse scheme. **Since D-404: DIRECT.** She goes straight at the clicked ground point and **stops at the first blocker**; going round an obstacle takes another click. *(Until D-404 this row read "Resolves to the nearest navigable point, and says so when it redirects" and the order followed a navigation path round obstacles — true when written.)* |
| **Right mouse** / controller **button 7** | **Since D-392: SPLINTER SHOT** — binding 6, beside key `6` — the Huntress's ordinary shot; **hold to repeat**. It commits (STOP), releases one arrow at the ≈ 0.50 s PROVISIONAL candidate, and **a movement command after the release cancels the remaining recovery** — the arrow is untouched. *(Until D-392 this row read as follows — true when written; the bolt is now **TEST-ONLY**, driven by the accepted suites through their seam, with no physical input:)* The **foundation's one** diagnostic probe bolt. **It COMMITS:** translation stops until the bolt releases, facing never does. **After the release, a movement command cancels the remaining recovery** — the bolt is untouched. *(⚠️ **Corrected under D-375:** this table said **"controller RT"**. `project.godot` binds `button_index: 7`, which in Godot 4 is **`JOY_BUTTON_LEFT_STICK`** — a stick click. Triggers are **axes 4 and 5**, not buttons. **The BINDING was deliberately NOT changed**: rebinding an accepted input is a UX decision this stage does not need, and it is carried as `DF-14`.)* |
| **Keys `1` … `8`** | **THE EIGHT ACTIVE BINDINGS (D-375).** `1` bow volley · `2` ward ballista · `3` beast pack · `4` the **same** bow Skill at Effective Rank 1 · `5` the **same** bow Skill with its Transform · **`6` SPLINTER SHOT since D-392** (the canonical Skill; right mouse and pad button 7 activate it too) · **`7`, `8` are deliberately EMPTY and say so.** *(Until D-392 `6` was empty as well — true when written.)* *(Since **D-380** all eight **may** hold a Configuration — one per binding, no six cap (D-378 OD-09) — but the diagnostic content has five; the eight-binding case is shown on scratch loadouts on the panel's D-378 ALIGNMENT page.)* **Controller mapping of the eight is DEFERRED (`DF-01`)** — canon's shifted-bank design needs a UI/input foundation |
| **F2** / controller **BACK** | **The loadout and testing panel (D-375).** A **DEVELOPER** surface, and **NOT a UI foundation**. **Hidden at launch since D-381** (it launched open until then) |
| **R** / controller **right-stick click** | **D-381's one diagnostic input:** cycles the Persistent reservation OFF → MANA RESERVATION → LIFE CONVERSION → OFF, shown on the bottom-right **review HUD** (diagnostic, not a UI foundation). **Since D-396 it drives the Persistent under review — KINDRED HOUNDS** (OFF removes the pack; MANA restores it; LIFE converts its reservation), shown on the top-right Kindred Hounds HUD. *(It drove the diagnostic aura until D-396 — true when written. The F2 panel's reservation row still addresses the aura, `KD-16`.)* |
| **H** / controller **D-pad left** | **Since D-396 — a DIAGNOSTIC review control, NOT a command:** fells the lowest-numbered living hound through its own damage path, standing in for an enemy area attack, so the low-friction return (**4.0 s**, PROVISIONAL) can be seen |
| **P** / controller **D-pad right** | **Since D-398 — a DIAGNOSTIC review control, NOT a command:** cycles the stress population 2 → 6 → 10 → 15 → 2 — the two Kindred Hounds plus labelled **stress minions** (S3 …). The canonical pack stays **two**; no Configuration, reservation, Capacity or damage moves |
| **T** / controller **START** | **Since D-398 — a DIAGNOSTIC review control, NOT a command:** cycles her travel speed ORDINARY ×1.0 → FAST ×1.8 → EXTREME ×3.0 → ORDINARY, to review the pack at late-game speeds. Her accepted 3.889 m/s is unchanged |
| **↑ / ↓** / controller **LB / RB** | Move the panel's **explicit focus**. No typed text and no drag precision anywhere |
| **Enter** / controller **A** | Activate the focused row |
| Mouse cursor | Aim. Sampled **per use**, independently of movement |
| Controller **left stick** | Move · **right stick** aims |
| Mouse wheel / controller **D-pad ↑↓** | Bounded zoom |
| **F1** / controller **Y** | Toggle the debug overlay. **Hidden at launch since D-382** (it launched on until then) |

**Verification, headless — since D-404.** **The D-404 runner runs ALL NINE suites**: the accepted D-373, D-376, D-383,
D-394, D-397, D-399, D-401 and D-403 suites as **regressions**, then the direct-click stage (**32** executable checks). It
checks the state line, the printed rows, **every accepted runner's own forbidden-claim and self-acceptance patterns over
all nine logs**, the isolation of every protected tree, **the D-404 change set** (`D404_BASELINE_GAME3D`, a pre-D-404
listing of `game3d/`), the asset guards, the input map, the untouched code by SHA-256, the units, the disclosure of every
re-scoped accepted check and the rendered evidence (**24 runner checks**). Without its baselines it reports
**INCOMPLETE, not PASS**. `--with-evidence` renders frames `55`–`60` first, each under a 120 s ceiling:

```bash
./tests/direct_click_smoke.sh
```

**Verification, headless — since D-398.** **The D-398 runner runs ALL SIX suites** — the accepted D-373, D-376, D-383,
D-394 and D-397 suites as **regressions**, then the mobile minion cohesion stage (**40** executable checks) — and checks
the state line, the printed rows, the isolation of every protected tree, **the D-398 change set**
(`D398_BASELINE_GAME3D`, a pre-D-398 listing of `game3d/`), the asset guards, the input map, the units, the declared
fixture and the rendered evidence (**22 runner checks**). Without its baselines it reports **INCOMPLETE, not PASS**;
`--with-evidence` renders frames `32`–`39` first, each under a 120 s ceiling:

```bash
./tests/cohesion_smoke.sh
```

*(The paragraph below is the D-396 runner's, true when written; since D-398 its `Y15` prints **[DECLARED]**.)*

**Verification, headless — since D-396.** **The D-396 runner runs ALL FIVE suites** — the accepted D-373, D-376, D-383
and D-394 suites as **regressions**, then the Kindred Hounds stage (**45** executable checks) — and checks the state line,
the printed rows, the isolation of every protected tree, **the D-396 change set** (`D396_BASELINE_GAME3D`, a pre-D-396
listing of `game3d/`), the asset guards, the input map, the declared fixture and the rendered evidence (**21 runner
checks**). Without its baselines it reports **INCOMPLETE, not PASS**:

```bash
./tests/hounds_smoke.sh
```

*(The paragraph below is the D-392 runner's, true when written; since D-396 its `W17` prints **[DECLARED]**.)*

**Verification, headless — since D-392.** **The D-392 runner runs ALL FOUR suites** — the accepted D-373, D-376 and
D-383 suites as **regressions**, then the Splinter Shot stage (**53** executable checks since D-393; 57 until then) — and checks the state line, the
printed rows, the isolation of every protected tree, the declared change set, the placeholder intake against its
archives, the input map and the rendered evidence (**21 runner checks**). `FOUNDATION_BASELINE_DIR` supplies the
pre-work listings W16 and W17 need; **without it they print SKIP and the runner reports INCOMPLETE, not PASS**:

```bash
./tests/huntress_smoke.sh
```

*(The paragraph below is the D-380 runner's, true when written. Run against a pre-D-392 `game3d/` listing, its `T17`
would now report the D-392 files — a delivery-time claim, declared in the D-392 inventory §4.3.)*

**The D-380 runner runs ALL THREE suites** — the accepted D-373 and D-376
suites as **regressions**, then the D-378 alignment stage — and checks that every authored file outside its
declared change set is byte-identical:

```bash
./tests/alignment_smoke.sh
```

The D-375 runner still runs **both** earlier suites on its own:

```bash
./tests/imprint_smoke.sh
```

The accepted baseline's own runner still runs on its own, with its own 20 runner checks:

```bash
./tests/foundation_smoke.sh
```

**With rendered evidence** (opt-in — a plain invocation is headless-only, and each capture now has a hard
120 s ceiling because a parse error once made a windowed capture hang forever):

```bash
./tests/imprint_smoke.sh --with-evidence
```

**Isolation baselines** are supplied through `FOUNDATION_BASELINE_DIR`, holding
`baseline_{game,game2d,game3d_spike,game3d_boss_spike,quaternius}.sha256` — and, for the D-380 runner's
`T17`, `baseline_game3d.sha256` over `game3d/`'s own authored files (the engine cache excluded). Without them
a runner **skips and says so** rather than passing an unproved claim. The D-380 runner's `--with-evidence`
renders **only the D-381 correction's three captures** (`13`–`15`) and never re-renders `01`–`12` *(it rendered
`11`, `12` at D-380's delivery — true when written)*; `T21` checks all five of the stage's captures.

---

## What it contains

| Requirement from the ruling | Where |
| --- | --- |
| **Fixed orthographic isometric camera** | `scripts/view/iso_camera_rig.gd` — rotation locked and **re-verified every frame** |
| **Continuous 3D character yaw** | `scripts/control/yaw_driver.gd` — **no sector index exists, and none may be added** (D-367) |
| **Independent movement and aiming** | `scripts/control/player_controller.gd` — asserted in **both** directions |
| **Camera following and bounded zoom** | `iso_camera_rig.gd` — both bounds reached, neither passable |
| **A clean movement/controller architecture** | `control/` — four small pieces: intent · motor · yaw · controller |
| **One small production test arena** | `scripts/world/production_arena.gd` — two chambers, one doorway, one interior blocker |
| **One ordinary-enemy diagnostic loop** | `scripts/combat/ordinary_enemy.gd` — navigation · acquisition · telegraphing · attacking · receiving damage · death |
| **One clearly labelled diagnostic attack** | `scripts/combat/diagnostic_bolt.gd` — **exactly one**, and it denies being a Skill in the runtime |
| **Stable collision, navigation, ground point** | `scripts/world/nav_service.gd` + per-prop colliders + a baked `NavigationMesh` |
| **A third-party ingestion and provenance system** | `scripts/assets/asset_manifest.gd` — the single runtime source of truth, with `assets/third_party/quaternius/SOURCE_AND_LICENSE.md` **verified against it** |
| **Automated smoke and verification runners** | `tests/` — **85 executable checks** + **20 runner checks**, with falsifiable negative controls |
| **An action-movement commitment policy** *(D-370 live review)* | `scripts/control/action_commitment.gd` — **exactly two policies, STOP and ALLOW**. **Not a Skill system** |
| **Recovery cancellation** *(D-370 live re-review)* | Same file — a cancel window **derived from the existing release marker**, which **refuses before the release** and adds **no new tunable** |
| **A useful debug overlay that can be disabled** | `scripts/debug/debug_overlay.gd` — **F1**, and disabled in every evidence capture |

### Architecture

```
scripts/
  core/prod_config.gd          every provisional value, in one registry, printed at runtime
  assets/asset_manifest.gd     the SINGLE runtime source of truth for third-party paths
  assets/rig_corpus.gd         measured rig compatibility, merged clip corpus, guarded playback
  control/input_intent.gd      devices -> intent          (knows no movement)
  control/locomotion_motor.gd  wish direction -> velocity  (knows no devices)
  control/yaw_driver.gd        target angle -> facing      (knows neither)
  control/action_commitment.gd an action's movement policy: STOP or ALLOW, and nothing else
  control/player_controller.gd composes the three, owns navigation and the one diagnostic action
  view/iso_camera_rig.gd       fixed orthographic isometric, rotation locked every frame
  view/ground_shadow.gd        the shadow that stays at the GROUND POINT
  world/nav_service.gd         the one place that talks to NavigationServer3D, plus a PathFollower
  world/production_arena.gd    the test arena: geometry, per-prop collision, the baked navmesh
  combat/{damageable,telegraph,diagnostic_bolt,ordinary_enemy}.gd
  debug/debug_overlay.gd       a DEVELOPER surface, and NOT a UI foundation
  foundation_main.gd           the composition root

  imprint/                     STAGE 2 — THE GLOBAL IMPRINT SYSTEM PROTOTYPE (D-375)
    imprint_config.gd          the stage's OWN provisional registry, the canonical values with
                               their citations, the seven MEASURED conflicts, eighteen denials
    imprint.gd                 one Imprint: three types, tags, declared tag changes, the
                               components it affects, its tradeoff, the rank property it moves
    imprint_library.gd         permanent per-character learning. ONE mastery record per Imprint id,
                               which is the structural reason reuse cannot multiply XP
    resource_pool.gd           Life and Mana with reservation. Two separate fields, so "both
                               reserved" is unrepresentable rather than merely unlikely
    skill_configuration.gd     one Skill Imprint · four SHARED slots · at most one Transform ·
                               tag-driven compatibility · ONE documented seven-stage pipeline
    imprint_loadout.gd         EIGHT canonical bindings, a separate Persistent Loadout, the global
                               Capacity budget, and the ONE place that decides legality
    diag_imprint_content.gd    the 14 diagnostic Imprints and 6 Configurations, plus canon's eight
                               roster Skills and sixteen Augments quoted so denials can be CHECKED
    diag_projectile.gd         the reusable projectile the bow Skill AND the ballista both consume
    diag_ballista.gd           the placed autonomous emplacement; canon's Duration contract
    diag_beast.gd              the autonomous minion. NO command path of any kind
    skill_runtime.gd           where a Skill Use happens, and the only place it does
    loadout_panel.gd           the live-review panel. A DEVELOPER surface, NOT a UI foundation

  STAGE 3 (D-380) ADDED NO FILE UNDER scripts/. It changed rules inside the files above:
    imprint_config.gd          the two slot candidates and the flat regen / tithe constants REMOVED;
                               three DERIVED provisional values; working-baseline registry; the
                               D-378 map (27 parts, four dispositions) and the stage's denials
    imprint_library.gd         learn(imprint) — no rank; acquisition record; declared seeding
    resource_pool.gd           regeneration = rate x UNRESERVED maximum Mana
    skill_configuration.gd     proportional Mana->Life conversion; the free-power refusal removed
    imprint_loadout.gd         no six cap, no Persistent cap
    loadout_panel.gd           the aligned text, and a sixth page: D-378 ALIGNMENT

  D-381 (the reviewability correction) ADDED ONE FILE:
    review_hud.gd              the compact DIAGNOSTIC review HUD. Reads the live pool and Damageable;
                               owns no number; NOT a UI foundation
  and changed: foundation_main.gd (panel hidden at launch, HUD composed), skill_runtime.gd (the
  one reservation cycle), imprint_config.gd (its denials), loadout_panel.gd (row 2 reads OFF)
tests/
  foundation_verification.gd  85  — the accepted D-373 suite, NOT EDITED by D-380; F69 re-scoped by D-381 (25 + 1)
  imprint_verification.gd     101 — the accepted D-376 suite; first-act and one-for-one re-scopes
  alignment_verification.gd   35  — the D-380 suite (28 at delivery + 7 under D-381)
```

**The first three control pieces are plain objects, not nodes**, so the suite can step them with an exact
delta. That is why top speed, acceleration, braking and turn rate are **measured** here rather than sampled
off a moving character and hoped about.

---

## Its relationship to the frozen prototypes

**It may study them. It has NO RUNTIME DEPENDENCY on them, and the suite proves it** — no path in this project
resolves outside `game3d/`, and the guard is proved able to catch a planted one.

**Ten reused implementations are declared truthfully** in `ProdConfig.reuse_declaration()` and printed on every
run. **Seven things are declared NEW here** and are explicitly **not** credited against any earlier phase —
chief among them a **real baked navigation mesh**, which neither 3D spike had at all.

**The cross-reference runs ONE WAY ONLY, outward.** `game/`, `game2d/`, `game3d_spike/` and
`game3d_boss_spike/` are **byte-identical** after this work, asserted by the runner rather than assumed, and
**no exception is declared for any of them.** Their *"DELIVERED and OPEN"* strings must **not** be "fixed".

---

## What is deliberately absent

| Absent | Why |
| --- | --- |
| **Any boss** | The ruling forbids importing the boss encounter here. **Nothing in this project may be cited for any boss**, humanoid or otherwise |
| **Ultimate Monsters** | **Excluded by the ruling.** Not imported, not extracted, not read |
| **Any weapon on the player** | *(Since **D-392**: a **PLACEHOLDER** bow, procedural string and arrow, animated by the retargeted CC0 KayKit bow clips — see the Stage 4 block. The row below was true when written.)* The corpus has **no bow clip (0 of 85)**, and D-369 recorded that the frozen spike's bow attachment is positioned incorrectly. That debt is **neither reproduced nor discharged** here — **absence is not a repair** |
| **WASD** | `CLAUDE.md` §8 |
| **Audio** | Zero assets and zero hooks. `CLAUDE.md` §12 forbids new audio |
| **Loot, economy, acquisition, trading, save** | Explicitly out of scope for **both** rulings. Every Imprint is **pre-learned**; there is no route by which one is obtained |
| **An equipment system** | **D-375 forbids it explicitly.** The Capacity gear contribution is **ONE boolean and ONE integer** — no item, affix, slot, inventory or **any** randomness |
| **A UI foundation** | P1A's transferred UI debt is **UNCHANGED**. The D-375 loadout panel is a **DEVELOPER** surface and says so |
| **Rift Shards** | **Outside the D-375 stage by the ruling's own words.** No Generate, Hold, Shape or Rift Echo exists, and a guard proves it |
| **Charges, triggers, retaliations, channels, a movement Skill** | Designed canon, **none implemented**. Each is a printed DEFERRED row that names where it returns |
| **A Huntress class specification** | **A P2 prerequisite**, and this foundation is forbidden to write it *(D-385 wrote it in `design/`; **D-392 implements ONE Skill of it — Splinter Shot — and nothing else of her**: no hounds, ballista, trap, Void Lance, Rift Step, Void Attunement or Rift Shards)* |

---

## Three things only a rendered frame revealed

**This project's rule is to render the evidence and look at it. Four of the twelve defects found while
building this foundation were invisible to every automated check, and three of them were visual:**

1. **The floor washed out and the actors sank into it** — the exact opposite of the validated direction's
   *"ordinary surfaces stay visually quiet"*. The cause was **Godot's default `tonemap_white` of 1.0**, which
   lifts the whole mid-range under ACES. The accepted spike had already solved it; its tone response is
   reused.
2. **Everything looked like it was floating.** Nothing was: every prop was measured afterwards and sits
   within 13 mm of the floor plane. **A fixed isometric view with no contact cue cannot distinguish
   "standing here" from "standing further away"** — which is exactly why `CLAUDE.md` §5 says the shadow
   stays at the ground point.
3. **The telegraph rendered as a red hatch instead of a solid wedge.** The floor's **visual** top measures
   **+0.033 m**, not the collision plane at 0, so the decals were **inside the floor slab**. Now a measured
   constant, and asserted.

*(The fourth was mechanical and the suite did catch it: enemies stalled dead when another actor stood on
their path, because a baked navmesh knows about architecture and nothing about actors.)*

---

## Read before touching this project

- `docs/testing/D404_DIRECT_CLICK_MOVEMENT_OWED_CRITERIA_INVENTORY.md` — **stage 9's 124 owed criteria**, written before
  any runtime file of the stage changed; its §11 is the delivery addendum
- `docs/testing/D404_DIRECT_CLICK_MOVEMENT_DELIVERY_REPORT.md` — what stage 9 changed, measured, re-scoped, found and
  did not do, including the **six replaced accepted checks** and the **declared canon disagreement (`DD-22`)**
- `docs/testing/D403_CINDER_FIELD_ACCEPTANCE_AND_CLOSURE_REPORT.md` — **stage 8's ACCEPTANCE and CLOSURE** and its two
  carried findings

- `docs/testing/D398_MOBILE_MINION_COHESION_OWED_CRITERIA_INVENTORY.md` — **stage 6's 201 owed criteria**, written before
  any runtime file of the stage changed; its §10 is the delivery addendum
- `docs/testing/D398_MOBILE_MINION_COHESION_DELIVERY_REPORT.md` — what stage 6 built, measured, found and did not do
- `docs/testing/D399_MOBILE_MINION_COHESION_ACCEPTANCE_AND_CLOSURE_REPORT.md` — **stage 6's ACCEPTANCE and CLOSURE**: what
  was accepted, what is NOT locked, the **new carried player-locomotion defect**, and the declared runtime discrepancy
- `design/CHARACTER_CLASS_PHILOSOPHY.md` §0.5.19 and `design/SKILLS_AND_SKILL_MODIFICATION.md` §16 — the D-398 notes
- `docs/testing/D396_KINDRED_HOUNDS_OWED_CRITERIA_INVENTORY.md` — **stage 5's 202 owed criteria**, written before any
  runtime file of the stage changed; its §10 is the delivery addendum
- `docs/testing/D396_KINDRED_HOUNDS_DELIVERY_REPORT.md` — what stage 5 built, measured, found and did not do
- `design/CHARACTER_CLASS_PHILOSOPHY.md` §0.5.19 — the owner's D-396 return-after-abandonment instruction, and what stays
  undecided
- `docs/testing/D380_ALIGNMENT_OWED_CRITERIA_INVENTORY.md` — **stage 3's 121 owed criteria and the map of
  every D-378 ruling**, written before any file of the stage changed
- `docs/testing/D380_ALIGNMENT_DELIVERY_REPORT.md` — what stage 3 changed, measured and did not do
- `docs/testing/D381_REVIEWABILITY_CORRECTION_REPORT.md` and `docs/testing/D382_HEALTH_RESERVATION_AND_REVIEW_SURFACES_REPORT.md`
  — stage 3's two corrections: the review HUD, and the Life-reservation rule
- `docs/testing/D383_ALIGNMENT_ACCEPTANCE_AND_CLOSURE_REPORT.md` — **stage 3's ACCEPTANCE and CLOSURE**: what was
  accepted, what was NOT accepted or locked, and the declared runtime discrepancy that must not be "fixed"
- `docs/testing/D376_IMPRINT_ACCEPTANCE_AND_CLOSURE_REPORT.md` — **the acceptance record, and the first thing
  to read about stage 2.** It separates **accepted architecture** from **working baselines**, **provisional
  numbers** and **diagnostic-only content**, records the three resolved conflicts, and carries the declared
  discrepancy above
- `design/SKILLS_AND_SKILL_MODIFICATION.md` **§0** — **where the accepted Skill architecture is now canon**
- `docs/testing/D375_IMPRINT_OWED_CRITERIA_INVENTORY.md` — **149 owed criteria**, the obligation map, and
  **the seven measured canonical conflicts**. Written before any Imprint file existed
- `docs/testing/D375_IMPRINT_DELIVERY_REPORT.md` — what stage 2 built, measured, conflicted with and owes
- `docs/testing/D370_OWED_CRITERIA_INVENTORY.md` — **125 owed criteria**, written before implementation
- `docs/testing/D370_P1_OBLIGATION_MAP.md` — every remaining P1 / P1C obligation, with its disposition
- `docs/testing/D370_FOUNDATION_DELIVERY_REPORT.md` — what was built, measured, reused and risked
- `assets/third_party/quaternius/SOURCE_AND_LICENSE.md` — **the QAL v1.0 obligation matters here**

> ### The licence obligation is now load-bearing
>
> The Bestiary pack is **QAL v1.0**: commercial use and modification are permitted, but **redistributing the
> assets themselves as assets is forbidden**. `game3d/` is the **canonical production project**, not a
> throwaway — **anyone setting up version control for it must decide how `assets/third_party/` is handled
> before the first push.** Nothing here is committed or pushed under D-370.

> ### Units — carried on every surface, because this project has been blocked once by a count
>
> **STAGE 1 (D-370, ACCEPTED): 125 OWED CRITERIA · 85 EXECUTABLE CHECKS · 20 RUNNER CHECKS.**
> *(110 / 70 / 20 at first delivery; +8 at the D-370 live review; +7 at the live re-review.)*
>
> **STAGE 2 (D-375 delivered · D-376 ACCEPTED): 149 OWED CRITERIA · 101 EXECUTABLE CHECKS · 26 RUNNER
> CHECKS.** **The acceptance moved none of them.**
> *(148 / 100 / 26 in the pre-implementation inventory; **+1 criterion and +1 check** when the rendered
> evidence exposed a canonical per-use-targeting defect no check was looking for. **148 + 1 = 149** and
> **100 + 1 = 101**; the runner did not move, and nothing was removed, renamed or renumbered.)*
>
> **FIVE DIFFERENT UNITS ACROSS TWO DECISIONS. NONE IS A SYNONYM FOR ANOTHER, and the D-370 numbers do NOT
> add to the D-375 ones.** **Exactly one accepted number moved:** the baseline's **deferred-row count,
> 12 → 11**, because D-373 **DISCHARGED `M-04`**.
>
> **STAGE 6 (D-398 delivered · D-399 ACCEPTED): 201 OWED CRITERIA · 40 EXECUTABLE CHECKS · 22 RUNNER CHECKS.** No accepted
> executable-check or runner-check count moved; the D-396 suite's printed rows moved as the owner's D-397 answers
> required (6 owed → 0 owed, 0 discharged → 6).
>
> **STAGE 3 (D-380, DELIVERED and OPEN; ACCEPTED and CLOSED under D-383): 121 OWED CRITERIA · 28 EXECUTABLE CHECKS · 21 RUNNER CHECKS** at
> delivery; **146 · 35 · 21 since the D-381 correction** (121 + 25 · 28 + 7 · 21 + 0).
> **NINE UNITS ACROSS THREE DECISIONS NOW.** **One more accepted number moved, for the reason the owner
> authorized:** the Imprint suite's **deferred-row count, 24 → 16**, because D-376 **DISCHARGED the eight
> `MO-` rows**. **Its 101 executable checks did not move** (101 − 0 + 0 = 101); `I56` and `I57` kept their
> numbers and had their suffixes corrected so no PASS line asserts a withdrawn candidate.
