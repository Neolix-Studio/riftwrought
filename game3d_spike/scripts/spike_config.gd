class_name SpikeConfig
extends RefCounted

## RIFTWROUGHT — 3D FEASIBILITY SPIKE CONFIGURATION (D-366, 2026-09-17)
##
## ============================================================================
## EVERY NUMBER IN THIS FILE IS PROVISIONAL.
## ============================================================================
##
## This is a BOUNDED, ISOLATED FEASIBILITY SPIKE. It is NOT:
##   - the final Huntress
##   - final art
##   - the 3D production project
##   - P2, or a completed pivot
##   - proof that the complete game is feasible
##   - acceptance of the Quaternius visual style
##
## It completes NO phase. It writes NO canonical Huntress class specification.
## Nothing here is a lock, and nothing here may be cited as one.
##
## NO 2D MEASUREMENT IS INHERITED AS A LOCK. The accepted 2D prototype's owner
## locks (D-356) -- 60.0 px/m, the 128x128 cell, the 120x60 tile, the (64,122)
## anchor, the fixed 32.00 x 18.00 m camera footprint and rendering mode 7 --
## belong to `game2d/` and are NOT promoted here.

const SPIKE_DECISION := "D-366"
const SPIKE_DATE := "2026-09-17"
const SPIKE_STATE := "DELIVERED and OPEN pending owner live review"

# --- Output -----------------------------------------------------------------
# PROVISIONAL. 1920x1080 is a COMPARISON OUTPUT for owner review, not a lock.
const OUTPUT_WIDTH := 1920
const OUTPUT_HEIGHT := 1080

# --- Camera -----------------------------------------------------------------
# PROVISIONAL. Fixed orthographic isometric. Rotation is LOCKED and never varies.
const CAM_PITCH_DEG := -52.0
const CAM_YAW_DEG := 45.0
const CAM_ROLL_DEG := 0.0
const CAM_BOOM_DISTANCE := 40.0          # ortho: distance affects only clipping
# Orthographic `size` = the VERTICAL extent of the view, in metres.
const CAM_SIZE_DEFAULT := 14.0
const CAM_SIZE_MIN := 11.0               # zoom-in bound  (gentle, bounded)
const CAM_SIZE_MAX := 18.0               # zoom-out bound (gentle, bounded)
const CAM_ZOOM_STEP := 0.6
const CAM_FOLLOW_LAG := 8.0              # PROVISIONAL smoothing

# --- Movement ---------------------------------------------------------------
# ============================================================================
# 5.0 m/s IS RE-EVALUATED HERE, NOT INHERITED.  (D-365 ruling; D-366 spike)
# ============================================================================
# The accepted 2D prototype used a top speed of 5.0 m/s inside a camera
# footprint LOCKED at 32.00 x 18.00 m (D-356). That footprint is a 2D lock and
# is NOT carried into 3D.
#
# This spike's PROVISIONAL framing is CAM_SIZE_DEFAULT = 14.0 m vertical, which
# at 16:9 is 14.0 * 16/9 = 24.889 m horizontal.
#
# MEASURED CONSEQUENCE:
#   - 2D  : 5.0 m/s crosses 32.000 m of visible width in 6.400 s
#   - 3D  : 5.0 m/s crosses 24.889 m of visible width in 4.978 s
#   => the SAME metres-per-second reads 1.286x FASTER in this spike's framing.
#
# To match the 2D PERCEIVED crossing time exactly, this framing would need
#   5.0 * (24.889 / 32.000) = 3.889 m/s.
#
# THE SPIKE DELIBERATELY RUNS AT 5.0 m/s so the owner can feel the difference
# against a number they already know, WITH the framing-matched alternative
# printed on screen beside it. WHICH VALUE IS RIGHT IS AN OWNER JUDGMENT AND IS
# EXPLICITLY STILL OPEN. Neither number is a lock.
const TOP_SPEED_MPS := 5.0
const TOP_SPEED_IS_PROVISIONAL := true
const TOP_SPEED_2D_PROTOTYPE_MPS := 5.0
const CF_2D_LOCKED_WIDTH_M := 32.0       # game2d/ lock, quoted -- NOT promoted
const FRAMING_MATCHED_SPEED_MPS := 3.889 # the equivalent, for comparison only
const ACCEL_MPS2 := 38.0                 # PROVISIONAL
const DECEL_MPS2 := 46.0                 # PROVISIONAL
const TURN_RATE_DEG := 900.0             # PROVISIONAL visual turn rate

# --- Diagnostic projectile --------------------------------------------------
# CLAUDE.md 3.5: P1 may use exactly ONE explicitly diagnostic, non-canonical
# projectile action, WHICH MUST BE LABELLED DIAGNOSTIC IN THE RUNTIME.
# This is that action. It is NOT a designed Skill and defines NO class mechanic.
const PROJECTILE_LABEL := "DIAGNOSTIC — non-canonical"
const ARROW_SPEED_MPS := 26.0            # PROVISIONAL
const ARROW_RANGE_M := 18.0              # PROVISIONAL
const ARROW_DAMAGE := 34.0               # PROVISIONAL
const FIRE_COOLDOWN_S := 0.42            # PROVISIONAL
const FIRE_RELEASE_MARKER := 0.38        # PROVISIONAL: normalised clip time at
                                         # which the arrow leaves the bow.
                                         # MECHANICAL TIMING IS AUTHORITATIVE
                                         # OVER ANIMATION TIMING.

# --- Enemies ----------------------------------------------------------------
const ENEMY_HEALTH := 100.0              # PROVISIONAL
const ENEMY_SPEED_MPS := 2.6             # PROVISIONAL
const ENEMY_COUNT_NORMAL := 6            # the ruling: "approximately six"
const ENEMY_COUNT_DENSITY := 24          # the ruling: "24 passive enemies"
const ENEMY_BODY_RADIUS := 0.42          # PROVISIONAL
const PLAYER_BODY_RADIUS := 0.36         # PROVISIONAL

# --- Weapon scale -----------------------------------------------------------
# MEASURED, not guessed: the Medieval Weapons pack is authored at roughly 4x the
# metric scale of the character packs. Bow_Wooden's AABB is 5.437 units tall;
# Arrow's is 2.734 units long. A 1.196 m bow and a 0.601 m arrow at the
# Ranger's measured 1.798 m height need a uniform factor of 0.22.
const WEAPON_SCALE := 0.22
const BOW_SOURCE_HEIGHT_U := 5.4366
const ARROW_SOURCE_LENGTH_U := 2.7338

# --- Palette (PROVISIONAL) --------------------------------------------------
# "Dark blue-gray environmental base ... warm localized torch lighting ...
#  restrained violet Rift accent ... environment values and contrast must
#  recede behind the player, enemies, telegraphs and effects."
const COL_STONE_MAIN := Color(0.232, 0.256, 0.318)      # dark blue-gray
const COL_STONE_HIGHLIGHT := Color(0.302, 0.328, 0.392)
const COL_STONE_WARMGREY := Color(0.206, 0.214, 0.240)
const COL_GROUND := Color(0.150, 0.168, 0.214)
const COL_WOOD := Color(0.152, 0.116, 0.092)
const COL_METAL := Color(0.148, 0.156, 0.184)
const COL_FOLIAGE := Color(0.106, 0.148, 0.124)
const COL_BANNER := Color(0.305, 0.070, 0.082)
const COL_TORCH_WARM := Color(1.0, 0.552, 0.212)
const COL_RIFT_VIOLET := Color(0.588, 0.286, 1.0)
const COL_TELEGRAPH := Color(0.92, 0.18, 0.22)
const COL_LOOT_WARM := Color(1.0, 0.76, 0.30)

const TORCH_LIGHT_ENERGY := 14.0          # PROVISIONAL
const TORCH_LIGHT_RANGE := 13.0           # PROVISIONAL
const RIFT_LIGHT_ENERGY := 2.6           # PROVISIONAL
const RIFT_LIGHT_RANGE := 6.0            # PROVISIONAL
const AMBIENT_ENERGY := 0.70             # PROVISIONAL
const SUN_ENERGY := 0.80                 # PROVISIONAL -- moonlight, not sun

# --- UAL2 clip mapping ------------------------------------------------------
# ============================================================================
# TRUTHFULNESS: these are the ACTUAL UAL2 clip names. Nothing is renamed to
# suggest it is something it is not. See ANIM_LIMITATIONS below.
# ============================================================================
# NOTE: Godot's glTF importer STRIPS the "_Loop" suffix from UAL2's clip names
# and marks those clips looping instead. The names below are the IMPORTED names,
# verified against AnimationLibrary.get_animation_list() rather than against the
# names inside the .glb. Getting this wrong produced a silent no-op -- exactly
# the "silent animation fallback" defect class this project already names -- so
# every lookup now goes through a guard that CANNOT fail quietly.
const CLIP_PLAYER_IDLE := "Idle_Shield"
const CLIP_PLAYER_MOVE := "Walk_Carry"
const CLIP_PLAYER_ATTACK := "OverhandThrow"
const CLIP_ENEMY_IDLE := "Zombie_Idle"
const CLIP_ENEMY_CHASE := "Zombie_Walk_Fwd"
const CLIP_ENEMY_HIT := "Hit_Knockback"
const CLIP_ENEMY_ATTACK := "Zombie_Scratch"
const CLIP_ENEMY_DEATH := ""             # DOES NOT EXIST -- see below

## Every clip this spike asks for, so the guard can verify them all up front.
const REQUIRED_CLIPS := [
	CLIP_PLAYER_IDLE, CLIP_PLAYER_MOVE, CLIP_PLAYER_ATTACK,
	CLIP_ENEMY_IDLE, CLIP_ENEMY_CHASE, CLIP_ENEMY_HIT, CLIP_ENEMY_ATTACK,
]

## MEASURED LIMITATIONS OF Universal Animation Library 2 [Standard / FREE].
## All 43 clips were enumerated; the RM variant carries the identical set.
## These strings are printed at runtime AND in the report. Nothing is hidden.
const ANIM_LIMITATIONS := [
	"UAL2 Standard contains NO bow / archery / aim / draw / shoot clip. 0 of 43 match.",
	"  -> The player attack uses 'OverhandThrow', which is a THROW, not a bow draw.",
	"  -> IT IS LABELLED AS A PLACEHOLDER, NOT PRESENTED AS A BOW ANIMATION.",
	"UAL2 Standard contains NO death clip. 0 of 43 match death/die/dead/fall.",
	"  -> Enemy death is a CODE-DRIVEN topple-and-sink, explicitly not an animation.",
	"UAL2 Standard contains NO neutral walk or run. The only non-zombie walk is",
	"  'Walk_Carry_Loop', a CARRY walk. It is used and named truthfully.",
]

## The 10 skeleton bones the Imp lacks relative to the UAL2 rig. MEASURED.
## The Imp's 55 joints are a strict SUBSET of UAL2's 65 -- zero extra bones --
## so UAL2 clips drive it, with these tracks having no target.
const IMP_MISSING_BONES := [
	"pinky_01_l", "pinky_02_l", "pinky_03_l", "pinky_04_leaf_l",
	"pinky_01_r", "pinky_02_r", "pinky_03_r", "pinky_04_leaf_r",
	"ball_leaf_l", "ball_leaf_r",
]

# --- Bone names (MEASURED from the shared 65-joint rig) ---------------------
# A right-handed archer holds the bow in the LEFT hand and draws with the right.
const BONE_BOW_HAND := "hand_l"
const BONE_DRAW_HAND := "hand_r"
