class_name GateConfig
extends RefCounted

## RIFTWROUGHT — BOSS ANIMATION FEASIBILITY GATE CONFIGURATION (D-368, 2026-09-17)
##
## ============================================================================
## EVERY NUMBER IN THIS FILE IS PROVISIONAL. NOTHING HERE IS A LOCK.
## ============================================================================
##
## This is a BOUNDED, ISOLATED FEASIBILITY GATE. It is NOT:
##   - the full production pivot
##   - proof that all bosses are feasible
##   - a bespoke boss animation pipeline
##   - final art or final animation
##   - the Crownless Warden, or any canonical boss
##   - an Act I encounter
##   - P2, or a completed phase
##
## It completes NO phase in the P0-P7 table. It writes NO canonical boss or
## class specification. It authorizes nothing.
##
## NO 2D MEASUREMENT IS INHERITED AS A LOCK. The accepted 2D prototype's owner
## locks (D-356) -- 60.0 px/m, the 128x128 cell, the 120x60 tile, the (64,122)
## anchor, the fixed 32.00 x 18.00 m camera footprint and rendering mode 7 --
## belong to `game2d/` and are NOT promoted here.
##
## NO `game3d_spike/` VALUE IS PROMOTED TO A LOCK EITHER. The camera pitch, the
## zoom bounds and 1920x1080 are CARRIED FORWARD AS THE PROVISIONAL STARTING
## POINT the owner asked for, and D-367 is explicit that PRAISE IS NOT A LOCK.

const GATE_DECISION := "D-368"
const GATE_DATE := "2026-09-17"
const GATE_STATE := "DELIVERED and OPEN pending owner live review"

# --- Output -----------------------------------------------------------------
# PROVISIONAL. Carried from the accepted spike as a COMPARISON OUTPUT, not a lock.
const OUTPUT_WIDTH := 1920
const OUTPUT_HEIGHT := 1080

# --- Camera: THE ACCEPTED PROVISIONAL FRAMING, CARRIED AS THE STARTING POINT --
# The owner's instruction: "Keep the accepted provisional camera framing as the
# starting point." These are exactly the D-366 values the owner reviewed live.
# D-367 judged the pitch and the zoom bounds right AND left them PROVISIONAL.
# THEY ARE STILL PROVISIONAL. Praise is not a lock.
const CAM_PITCH_DEG := -52.0
const CAM_YAW_DEG := 45.0
const CAM_ROLL_DEG := 0.0
const CAM_BOOM_DISTANCE := 40.0          # ortho: distance affects only clipping
const CAM_SIZE_DEFAULT := 14.0           # vertical extent, metres
const CAM_SIZE_MIN := 11.0               # zoom-in bound
const CAM_SIZE_MAX := 18.0               # zoom-out bound
const CAM_ZOOM_STEP := 0.6
const CAM_FOLLOW_LAG := 8.0

# --- Player movement --------------------------------------------------------
# ============================================================================
# 3.889 m/s IS THE NEXT PROVISIONAL STARTING CANDIDATE. IT IS NOT A LOCK.
# ============================================================================
# D-367: 5.0 m/s was judged "somewhat too fast"; NO replacement speed was
# locked; and 3.889 m/s -- the framing-matched equivalent D-366 measured -- was
# carried forward ONLY as the next PROVISIONAL STARTING CANDIDATE for later
# combat tuning. It is "not a value, not a target and not a lock".
#
# THIS GATE USES IT AS EXACTLY THAT: A STARTING POINT, STILL OPEN.
# It is NOT settled by being used here, and this gate does not tune it.
const TOP_SPEED_MPS := 3.889
const TOP_SPEED_IS_PROVISIONAL := true
const TOP_SPEED_STATUS := "NEXT PROVISIONAL STARTING CANDIDATE — STILL OPEN, NOT A LOCK"
const TOP_SPEED_PRIOR_3D_SPIKE_MPS := 5.0   # quoted; judged somewhat too fast
const CF_2D_LOCKED_WIDTH_M := 32.0          # game2d/ lock, quoted -- NOT promoted
const ACCEL_MPS2 := 34.0
const DECEL_MPS2 := 42.0
const PLAYER_TURN_RATE_DEG := 900.0
const PLAYER_BODY_RADIUS := 0.36

# --- Diagnostic projectile --------------------------------------------------
# The ONE explicitly diagnostic, non-canonical projectile action, labelled
# diagnostic in the runtime. It is NOT a designed Skill and defines NO class
# mechanic. It exists only so the boss can be damaged and its reactions
# observed. No canonical Huntress class specification is written here.
const PROJECTILE_LABEL := "DIAGNOSTIC — non-canonical"
const ARROW_SPEED_MPS := 26.0
const ARROW_RANGE_M := 20.0
const ARROW_DAMAGE := 34.0
const ARROW_POISE_DAMAGE := 22.0
const FIRE_COOLDOWN_S := 0.42
const FIRE_RELEASE_MARKER := 0.38

# --- The boss candidate -----------------------------------------------------
# NAMING TRUTHFULNESS: this is a GATE PLACEHOLDER built from a stock Bestiary
# Puglin. It is NOT the Crownless Warden (which is Act I's boss, canonical and
# undesigned in 3D), and it is NOT the final campaign boss (undesigned).
const BOSS_DISPLAY_NAME := "PUGLIN BOSS CANDIDATE — gate placeholder"
const BOSS_NOT_NAME := "NOT the Crownless Warden · NOT the final campaign boss · NOT canonical"

const BOSS_HEALTH := 900.0
## POISE IS DELIBERATELY LARGE RELATIVE TO THE DIAGNOSTIC ARROW.
## At 100 poise it MEASURED as a stun-lock: the arrow's 22 poise per hit broke
## it roughly every 2 s, so the boss spent the fight staggering and its attacks
## almost never completed -- which is the opposite of the distinction under
## test. At 260 with 18/s regen a break costs sustained pressure, which is what
## makes "a light hit does not interrupt" a visible property rather than a
## claim. PROVISIONAL, like everything else here.
const BOSS_POISE := 260.0
const BOSS_POISE_REGEN_PER_S := 18.0
const BOSS_SPEED_MPS := 2.15
const BOSS_BODY_RADIUS := 0.95
const BOSS_TURN_RATE_DEG := 220.0        # deliberately weighty, continuous
const BOSS_AGGRO_RANGE := 26.0
const BOSS_PHASE2_AT_HEALTH_FRACTION := 0.55

## SCALE IS SUPPORT, NOT IDENTITY.
## The owner's instruction is explicit: "Do not claim that scaling an ordinary
## enemy proves a boss pipeline. Scale may support the presentation, but boss
## identity must also come from silhouette treatment using existing assets,
## behaviour, telegraphs, animation composition, VFX, sound hooks and encounter
## phases."
##
## MEASURED: the Puglin's posed bone extent under UAL1 'Idle' is 1.2079 m --
## it is SHORTER than the Imp (1.4407 m). The mesh is not inherently imposing,
## so scale cannot carry this and is declared support only.
const BOSS_VISUAL_SCALE := 2.5           # 1.2079 m * 2.5 = 3.020 m, PROVISIONAL
const PUGLIN_MEASURED_POSED_HEIGHT_M := 1.2079
const IMP_MEASURED_POSED_HEIGHT_M := 1.4407
const SCALE_IS_SUPPORT_NOT_IDENTITY := true

## The non-scale axes on which the boss must differ from the ordinary control.
## The gate asserts at least NON_SCALE_AXES_REQUIRED of these hold.
const NON_SCALE_AXES := [
	"silhouette attachments (axe + shield, from Medieval Weapons, unmodified)",
	"albedo variant (pack-supplied T_Puglin_BaseColor_2) + violet Rift emission",
	"procedural VFX crown (code-generated, NOT an imported asset)",
	"attack count and telegraph shape vocabulary (3 shape classes vs 1 plain disc)",
	"stagger policy (poise-gated interrupt vs flinch-on-every-hit)",
	"encounter phases (2 vs 1)",
	"animation composition (playback-speed-shaped windups vs single-speed clips)",
	"continuous yaw turn rate (weighty 220 deg/s vs 480 deg/s)",
]
const NON_SCALE_AXES_REQUIRED := 4

# --- The ordinary control ---------------------------------------------------
# WITHOUT THIS CONTROL, "the boss feels distinct from an ordinary Puglin" could
# only be ASSERTED, never shown. It is the same mesh and the same rig.
const CONTROL_DISPLAY_NAME := "ORDINARY PUGLIN — CONTROL (same mesh, same rig)"
const CONTROL_HEALTH := 100.0
const CONTROL_SPEED_MPS := 2.6
const CONTROL_TURN_RATE_DEG := 480.0
const CONTROL_BODY_RADIUS := 0.42
const CONTROL_VISUAL_SCALE := 1.0

# --- Imp minions ------------------------------------------------------------
const IMP_HEALTH := 70.0
const IMP_SPEED_MPS := 2.9
const IMP_BODY_RADIUS := 0.40
const IMP_COUNT_PHASE1 := 2
const IMP_COUNT_SUMMONED_AT_PHASE2 := 2

# --- Telegraph / danger-area geometry --------------------------------------
# THREE DIFFERENT GEOMETRIC CLASSES, not three circles of different radius.
# The owner's constraint: "The three attacks must not be distinguished merely
# by damage numbers or differently sized circles. Their anticipation, timing,
# motion and danger area must be visibly different."
enum Shape { CONE, ANNULUS, LINE, DISC }

# A1 "Sweep"  -- CONE. Horizontal sweep, shortest windup.
const A1_SHAPE := Shape.CONE
const A1_CONE_TOTAL_DEG := 150.0         # stated TOTAL, applied as half-width
const A1_RADIUS_M := 4.6
const A1_WINDUP_S := 0.85
const A1_WINDUP_SPEED := 0.30            # clip playback rate during anticipation
const A1_RELEASE_SPEED := 1.55           # clip playback rate on release
const A1_DAMAGE := 26.0
const A1_RECOVERY_S := 0.95

# A2 "Slam"   -- ANNULUS. Vertical overhead chop, long windup, ring shockwave.
const A2_SHAPE := Shape.ANNULUS
const A2_INNER_M := 1.8
const A2_OUTER_M := 6.0
const A2_WINDUP_S := 1.70
const A2_WINDUP_SPEED := 0.32
const A2_RELEASE_SPEED := 1.80
const A2_DAMAGE := 38.0
const A2_RECOVERY_S := 1.25

# A3 "Lance"  -- LINE. Stationary channel, longest windup, commits its aim.
const A3_SHAPE := Shape.LINE
const A3_WIDTH_M := 1.5
const A3_LENGTH_M := 13.0
const A3_WINDUP_S := 2.25
const A3_TRACK_FRACTION := 0.70           # tracks the player until 70% of windup
const A3_WINDUP_SPEED := 1.0              # the channel clip runs at true rate
const A3_RELEASE_SPEED := 1.0
const A3_DAMAGE := 46.0
const A3_RECOVERY_S := 1.10

## The minimum pairwise separation the three windups must show, in seconds.
## Measured from LIVE timing, not read back from these constants.
const WINDUP_MIN_PAIRWISE_SEPARATION_S := 0.40

const ATTACK_COOLDOWN_S := 1.55
const PHASE2_WINDUP_SCALE := 0.78         # phase 2 recomposes, it does not add
const PHASE2_COOLDOWN_SCALE := 0.70
const PHASE_BREAK_INVULN_S := 1.30

# --- Palette (PROVISIONAL) --------------------------------------------------
# Carried from the accepted spike's provisional palette so the gate is judged
# in the visual context the owner already reviewed.
const COL_STONE_MAIN := Color(0.232, 0.256, 0.318)
const COL_STONE_HIGHLIGHT := Color(0.302, 0.328, 0.392)
const COL_GROUND := Color(0.150, 0.168, 0.214)
const COL_WOOD := Color(0.152, 0.116, 0.092)
const COL_METAL := Color(0.148, 0.156, 0.184)
const COL_BANNER := Color(0.305, 0.070, 0.082)
const COL_BONE := Color(0.606, 0.588, 0.522)
const COL_TORCH_WARM := Color(1.0, 0.552, 0.212)
const COL_RIFT_VIOLET := Color(0.588, 0.286, 1.0)
const COL_TELEGRAPH := Color(0.92, 0.18, 0.22)
const COL_TELEGRAPH_COMMIT := Color(1.0, 0.42, 0.20)

## The boss's weapon values, lifted deliberately ABOVE the arena stone mean of
## 0.269 so the silhouette separates instead of sinking into the walls. The
## first pass reused the environment metal colour (mean 0.163) and the axe
## rendered as a near-black pole in the evidence.
const COL_BLADE := Color(0.560, 0.588, 0.650)
const COL_HAFT := Color(0.232, 0.168, 0.124)
const COL_SHIELD_FACE := Color(0.395, 0.408, 0.470)
const COL_SHIELD_RIM := Color(0.520, 0.470, 0.330)

## MEASURED albedo separation, stated numerically so "the boss reads against the
## environment" is a number and not an opinion.
## Environment stone base mean       = 0.269
## Pack variant 1 (olive, control)   = 0.301   -> separation from stone 0.032
## Pack variant 2 (rust, boss)       = 0.281   -> separation from stone 0.012
## ...but hue separation is what carries it, so BOTH are reported and the
## PERCEPTUAL verdict is OWED TO THE OWNER.
const BOSS_ALBEDO_MOD := Color(0.780, 0.395, 0.330)     # modulates pack variant 2
const CONTROL_ALBEDO_MOD := Color(0.640, 0.640, 0.300)  # modulates the embedded variant 1
const IMP_ALBEDO_MOD := Color(0.620, 0.560, 0.720)

const BOSS_EMISSION_ENERGY_P1 := 2.4
const BOSS_EMISSION_ENERGY_P2 := 5.2
const CONTROL_EMISSION_ENERGY := 1.1
const TORCH_LIGHT_ENERGY := 14.0
const TORCH_LIGHT_RANGE := 13.0
const AMBIENT_ENERGY := 0.70
const SUN_ENERGY := 0.80

# --- CLIP MAPPING -----------------------------------------------------------
# ============================================================================
# TRUTHFULNESS: every string below is an ACTUAL imported clip name. Nothing is
# renamed to suggest it is something it is not, and every clip's SOURCE LIBRARY
# is DERIVED AT RUNTIME from the libraries actually loaded -- never from this
# table. See RigCompat.attribute().
# ============================================================================
# Godot's glTF importer STRIPS the "_Loop" suffix and marks such clips looping
# instead, so these are the IMPORTED names, verified against
# AnimationLibrary.get_animation_list().

# Boss -- composed from stock clips. The DESIGN NAME is never presented as a
# clip name; the overlay shows both, separately.
const CLIP_BOSS_IDLE := "Idle_Shield"              # UAL2, phase 1 (shielded)
const CLIP_BOSS_IDLE_P2 := "Idle_FoldArms"         # UAL2, phase 2 (shield gone)
const CLIP_BOSS_MOVE := "Walk_Carry"               # UAL2 -- a CARRY walk, named truthfully
const CLIP_BOSS_A1 := "Sword_Regular_B"            # UAL2 -- horizontal sweep
const CLIP_BOSS_A2 := "TreeChopping"               # UAL2 -- vertical overhead chop
const CLIP_BOSS_A3_ENTER := "Spell_Simple_Enter"   # UAL1 -- cast start
const CLIP_BOSS_A3_CHANNEL := "Spell_Simple_Idle"  # UAL1 -- cast channel (loops)
const CLIP_BOSS_A3_RELEASE := "Spell_Simple_Shoot" # UAL1 -- cast release
const CLIP_BOSS_PHASE_BREAK := "Idle_Shield_Break" # UAL2 -- a REAL shield-break clip
const CLIP_BOSS_STAGGER := "Hit_Knockback"         # UAL2 -- poise-break stagger
const CLIP_BOSS_DEATH := "Death01"                 # UAL1 -- A REAL DEATH CLIP

# Ordinary control + minions -- deliberately simpler, for contrast.
const CLIP_CONTROL_IDLE := "Idle"                  # UAL1
const CLIP_CONTROL_MOVE := "Walk"                  # UAL1
const CLIP_CONTROL_ATTACK := "Punch_Cross"         # UAL1
const CLIP_CONTROL_HIT := "Hit_Chest"              # UAL1 -- flinches on EVERY hit
const CLIP_CONTROL_DEATH := "Death01"              # UAL1
const CLIP_IMP_IDLE := "Zombie_Idle"               # UAL2
const CLIP_IMP_MOVE := "Zombie_Walk_Fwd"           # UAL2
const CLIP_IMP_ATTACK := "Zombie_Scratch"          # UAL2
const CLIP_IMP_HIT := "Hit_Chest"                  # UAL1
const CLIP_IMP_DEATH := "Death01"                  # UAL1

# Player placeholder.
const CLIP_PLAYER_IDLE := "Idle_Shield"            # UAL2
const CLIP_PLAYER_MOVE := "Walk_Carry"             # UAL2 -- a CARRY walk
const CLIP_PLAYER_ATTACK := "OverhandThrow"        # UAL2 -- a THROW, NOT a bow draw

## Every clip the gate asks for, so the guard verifies them all up front and a
## missing one can never be a silent no-op.
const REQUIRED_CLIPS := [
	CLIP_BOSS_IDLE, CLIP_BOSS_IDLE_P2, CLIP_BOSS_MOVE,
	CLIP_BOSS_A1, CLIP_BOSS_A2,
	CLIP_BOSS_A3_ENTER, CLIP_BOSS_A3_CHANNEL, CLIP_BOSS_A3_RELEASE,
	CLIP_BOSS_PHASE_BREAK, CLIP_BOSS_STAGGER, CLIP_BOSS_DEATH,
	CLIP_CONTROL_IDLE, CLIP_CONTROL_MOVE, CLIP_CONTROL_ATTACK,
	CLIP_CONTROL_HIT, CLIP_CONTROL_DEATH,
	CLIP_IMP_IDLE, CLIP_IMP_MOVE, CLIP_IMP_ATTACK,
	CLIP_PLAYER_IDLE, CLIP_PLAYER_MOVE, CLIP_PLAYER_ATTACK,
]

# --- Animation blending / composition --------------------------------------
const BLEND_DEFAULT_S := 0.16
const BLEND_ATTACK_S := 0.10
const BLEND_STAGGER_S := 0.06

# --- Procedural layers (the owner's named toolkit) -------------------------
const TRACK_MAX_YAW_DEG := 38.0          # procedural upper-body tracking limit
const TRACK_RATE := 6.0
const RECOIL_IMPULSE_DEG := 7.5          # procedural recoil on a light hit
const RECOIL_DECAY := 7.0
const RECOIL_SHOVE_M := 0.075
const LEAN_MAX_DEG := 9.0                # procedural leaning into movement
const LEAN_RATE := 5.0

# --- Sound hooks ------------------------------------------------------------
# ============================================================================
# THESE ARE HOOKS, NOT SOUNDS. NO AUDIO ASSET IS ADDED BY THIS GATE.
# CLAUDE.md 12 forbids new audio. A hook is a NAMED EMISSION POINT that a
# future, separately authorized audio pass would bind to. The gate asserts the
# project contains ZERO audio files, and it never claims audio works.
# ============================================================================
const SOUND_HOOKS := [
	"boss_telegraph_sweep", "boss_commit_sweep",
	"boss_telegraph_slam", "boss_commit_slam",
	"boss_telegraph_lance", "boss_commit_lance",
	"boss_phase_break", "boss_stagger",
	"boss_death_start", "boss_death_end",
	"minion_summon", "player_shoot",
]
const AUDIO_ASSETS_ADDED := 0

# --- Truthfulness denials, asserted on screen and in the log ---------------
const DENIALS := [
	"THIS GATE IS NOT THE PRODUCTION PIVOT",
	"NOT proof that all bosses are feasible",
	"NOT a bespoke boss animation pipeline",
	"NOT final art and NOT final animation",
	"NOT the Crownless Warden and NOT any canonical boss",
	"NOT an Act I encounter",
	"NOT P2 and NOT a completed phase",
	"EVERY NUMBER HERE REMAINS PROVISIONAL",
	"NOT A PRODUCT LOCK",
]

## MEASURED limitations of the combined corpus. Printed every run and on screen.
## UAL1 and UAL2 each carry 43 clips on an IDENTICAL 65-joint rig; 'A_TPose' is
## common to both, so the combined usable corpus is 85 distinct clips.
const CORPUS_FACTS := [
	"UAL1 = 43 clips, UAL2 = 43 clips, identical 65-joint rig, 1 shared name ('A_TPose').",
	"  -> COMBINED DISTINCT CORPUS = 85 clips. Every boss clip below is stock and UNMODIFIED.",
	"Puglin.glb carries 55 joints, a STRICT SUBSET of the 65 (10 absent, 0 extra).",
	"  -> MEASURED, not assumed. UAL1 and UAL2 clips drive it with NO retargeting.",
	"Puglin.glb and Imp.glb contain ZERO animations of their own.",
	"UAL1 CONTAINS A REAL DEATH CLIP: 'Death01', 2.4000 s. The D-366 'no death clip'",
	"  gap was a UAL2-ONLY limitation and IS DISCHARGED HERE by the truthful source clip.",
	"NO clip in either library is a boss-specific, silhouette-defining signature move.",
	"  -> Every boss attack here is a GENERIC HUMAN clip RECOMPOSED by timing, speed,",
	"     blending and procedural layers. THAT IS THE WHOLE POINT OF THE GATE, and it",
	"     is the reason this proves composition and NOT bespoke boss animation.",
]

## The animation work that a stock corpus CANNOT supply. Enumerated, each tied
## to a measured absence, because "some polish remains" is not an answer.
const COMMISSION_REQUIRED := [
	["signature_entrance",
	 "No entrance/reveal clip exists in either library (0 of 85 match "
	 + "entrance/emerge/roar/reveal/intro). The gate opens with the boss simply "
	 + "present. A boss entrance is a signature beat and must be commissioned."],
	["silhouette_defining_signature_attack",
	 "MEASURED: all 85 clips target the 65-joint HUMAN rig, and 0 of 85 express "
	 + "a creature-specific attack -- there is no clip in either library that "
	 + "was authored for a non-human body. The three attacks here therefore "
	 + "read as a humanoid using a weapon, not as this creature's own move set. "
	 + "A signature attack must be commissioned."],
	["creature_specific_locomotion",
	 "The only carried-weight walk is 'Walk_Carry' (a CARRY walk) and the only "
	 + "monster gait is 'Zombie_Walk_Fwd'. A heavy, wide-stance boss gait at "
	 + "3.02 m does not exist and must be commissioned."],
	["weight_correct_death",
	 "MEASURED: 'Death01' is the ONLY death clip in the combined corpus (1 of "
	 + "85), and it is authored for the UAL mannequin, whose measured height is "
	 + "~1.83 m. 0 of 85 clips are authored for a 3.02 m body, so played on this "
	 + "boss it is still a HUMAN fall. A weight-correct boss death must be "
	 + "commissioned; the gate uses the truthful clip rather than faking one."],
	["phase_transformation_beyond_a_shield_break",
	 "'Idle_Shield_Break' is a real and well-matched clip for THIS phase idea. "
	 + "Any other transformation -- growth, sundering, armour shedding, a second "
	 + "form -- has no clip and must be commissioned."],
	["multi_part_and_arena_scale_attacks",
	 "Nothing in the corpus supports a grab, a pin, a throw, an arena-wide "
	 + "mechanic or a two-actor interaction. All must be commissioned."],
	["head_face_and_gaze_performance",
	 "The 55-joint Puglin rig has ONE head bone and no facial bones. Expression "
	 + "and true gaze are impossible from this rig regardless of the clip."],
	["non_humanoid_anything",
	 "MEASURED: the Ultimate Monsters Dragon rig is 13 joints (Root, Torso, "
	 + "Neck, Head, Wing1-4.L/R, Body1) with 1 exact / 2 case-insensitive name "
	 + "matches against the 65-joint UAL rig; PinkBlob is 4 joints with 1 match. "
	 + "There is NO shared library for them -- each ships its own 8-9 clips. "
	 + "EVERY non-humanoid boss animation must be commissioned."],
]
