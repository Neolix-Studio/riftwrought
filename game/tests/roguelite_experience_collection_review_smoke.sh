#!/usr/bin/env bash
# Riftwrought — Roguelite Experience Collection Greybox Review V1 smoke checks
# (decision D-288; corrected under D-289, which lifted the visible orb above the
# retained corpse and left the logical drop exactly where the Graveblade fell).
#
# THIS IS NOT A GATE, AND IT RUNS NO LOCKED CHAIN.
#
# The review is one ISOLATED playable instrument: a scene that INHERITS the accepted
# roguelite core-loop scene, a runtime that EXTENDS the accepted core-loop runtime
# and layers Foundation H8's run-owned Experience Mote runtime, presentation-only
# mote markers and one diagnostic panel on top of it, and this suite. It edits no
# accepted production file, adds no asset, adds no InputMap action, writes nothing
# to disk, and is not the project entrypoint. Rerunning closed gates or unrelated
# foundations to check it would be verification theatre over work it cannot have
# touched. What this script proves is what the review CAN break:
#
#   1. every new script parses;
#   2. the review's shipping files name no asset, shader, particle, sound or
#      storage, the scene is one inherited instance of the accepted scene, and the
#      verification reads no other suite;
#   3. an ordinary headless boot assembles the review with zero SCRIPT ERROR and
#      makes no runtime in the Nexus;
#   4. the pinned verification passes, proved in BOTH directions against a replay
#      of its own log, with every owed check reaching its last line, the measured
#      lines read out of that log, zero SCRIPT ERROR and zero engine ERROR, and no
#      engine WARNING but the accepted core loop's own two navigation-bake
#      precision warnings — and a run that hangs is killed and FAILS;
#   5. `project.godot` is untouched: 31 actions, the Prototype App entrypoint, the
#      same nine sections, no `[autoload]`, nothing naming this review;
#   6. the third-party inventory has not moved (185 + 2 = 187);
#   7. optionally (`--shots <dir>`), rendered evidence at 1920x1080 and at the
#      1280x720 minimum tested window, each run passing at the SAME pinned count,
#      because the evidence frames add no assertion;
#   8. every file this review could conceivably disturb — the accepted core loop,
#      replayability and build-variety reviews, every H1–H8, E1, G1 and G4
#      production file, the Graveblade and its records, the combat kernel, the
#      project owner's composed zone and loading teaser with its import record and
#      imported cache, `project.godot` and `CLAUDE.md` — is BYTE-IDENTICAL across
#      the run, and the project owner's own user:// files are untouched.
#
# Usage, from the repository root:
#   game/tests/roguelite_experience_collection_review_smoke.sh
#   game/tests/roguelite_experience_collection_review_smoke.sh --shots docs/testing/roguelite_experience_collection_review_evidence

set -uo pipefail

# Assigned at the TOP of the script, never beside the function it serves: a shell
# evaluates an assignment only when execution REACHES it, and Gate 1E's first
# staleness guard failed every read for exactly that reason.
RUN_STARTED_AT="$(date +%s)"

# A SCRIPT THAT DIES HALFWAY MUST NOT REPORT SUCCESS. `reached_end` is set by
# exactly one line, immediately before the final verdict.
reached_end=0
scratch_replay=""
on_exit() {
	local code=$?
	[[ -n "$scratch_replay" ]] && rm -f "$scratch_replay"
	if [[ "$reached_end" != "1" ]]; then
		printf '\nROGUELITE EXPERIENCE COLLECTION REVIEW SMOKE CHECKS: ABORTED before the end of the script\n'
		printf '  the run stopped early (exit %s) — nothing after that point was proved\n' "$code"
		exit 1
	fi
	exit "$code"
}
trap on_exit EXIT

GODOT="${GODOT:-/Applications/Godot.app/Contents/MacOS/Godot}"
EXPECTED_VERSION="4.7.2.stable"
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

SCENE="res://scenes/roguelite/roguelite_experience_collection_review.tscn"
ACCEPTED_SCENE="res://scenes/roguelite/roguelite_core_loop.tscn"
ROUTE_SEED=99

# Pinned, and proved in both directions below. ONE number: the rendered evidence
# frames add no assertion, so the headless and both rendered runs must agree.
#
# D-289 moved it 192 -> 213, every step an added proof of the lifted orb or of a
# ruling: +4 the ring and orb on the death position's X/Z at their two fixed
# heights; +3 the new check that neither follows the player or the camera; +1 in
# the boundary check (the four sides one float32 step outside became ONE
# assertion where one side took two, -1; the flash at the lifted orb, the flash
# being presentation only, and pickup measured to the ground rather than the orb
# replaced one assertion with three, +2); +2 the Elite and ordinary markers
# sharing one offset; +1 the collected indices matching D-288's; +6 the new check
# of a mote left behind by a room transition; +1 its marker freed by teardown; +2
# the pending mote unchanged until the Fallen teardown and the next run starting
# at zero; +1 the heights, the player and the camera read only where they should
# be. 4 + 3 + 1 + 2 + 1 + 6 + 1 + 2 + 1 = 21.
EXPECTED_CHECKS=213

# The number of check FUNCTIONS the suite owes, separate from the number of
# assertions. Pinned as a variable rather than written into the grep. D-289 added
# two: the orb fixed against player and camera, and the mote left behind.
EXPECTED_OWED_CHECKS=22

# Seconds a verification may take before it is killed and counted as a failure.
VERIFICATION_TIMEOUT=600

EXPECTED_INPUT_ACTIONS=31
EXPECTED_MAIN_SCENE="res://scenes/app/prototype_app.tscn"
EXPECTED_SECTIONS="application audio debug display editor_plugins input layer_names navigation rendering"

# The review extracts nothing. D-216's authorized numbers, unmoved.
EXPECTED_THIRD_PARTY_PAYLOADS=185
EXPECTED_THIRD_PARTY=187

# The only engine warnings the verification may print: the accepted core loop's
# own navigation bake rounding its agent values to the voxel grid. They come from
# `bake_navigation()` inside the accepted assembly, which this review inherits
# unedited, and they name no file of this review.
KNOWN_WARNINGS=(
	"WARNING: Property agent_max_climb is floored to cell_height voxel units and loses precision."
	"WARNING: Property agent_radius is ceiled to cell_size voxel units and loses precision."
)

REVIEW="scripts/roguelite/experience/roguelite_experience_collection_review.gd"
REVIEW_HUD="scripts/roguelite/experience/roguelite_experience_review_hud.gd"
REVIEW_SCENE="scenes/roguelite/roguelite_experience_collection_review.tscn"
THIS_VERIFICATION="tests/roguelite_experience_collection_review_verification.gd"

NEW_SCRIPTS=(
	"$REVIEW"
	"$REVIEW_HUD"
	"$THIS_VERIFICATION"
)

SHIPPING_FILES=(
	"$REVIEW"
	"$REVIEW_HUD"
	"$REVIEW_SCENE"
)

# DELIBERATELY SHORT, AND NOT A WHOLE-PROJECT CATALOGUE: the files this review
# inherits, composes or stands beside, and the project owner's own work.
PRESERVED_FILES=(
	"project.godot"
	"scenes/first_mvp/zone_composer_practice.tscn"
	"assets/prototype/ui/loading/riftwrought-loading-teaser-v1.png"
	"assets/prototype/ui/loading/riftwrought-loading-teaser-v1.png.import"
	".godot/imported/riftwrought-loading-teaser-v1.png-b052aa6f935e93824cd8ff133a3ff6f4.ctex"
	".godot/imported/riftwrought-loading-teaser-v1.png-b052aa6f935e93824cd8ff133a3ff6f4.md5"
	"../CLAUDE.md"
	"scenes/roguelite/roguelite_core_loop.tscn"
	"scripts/roguelite/roguelite_core_loop_runtime.gd"
	"scripts/roguelite/roguelite_room_module.gd"
	"scripts/roguelite/roguelite_run_plan.gd"
	"scripts/roguelite/roguelite_run_state.gd"
	"scripts/roguelite/roguelite_run_hud.gd"
	"scripts/roguelite/roguelite_fallen_overlay.gd"
	"scripts/roguelite/roguelite_run_summary_panel.gd"
	"scenes/roguelite/roguelite_replayability_review.tscn"
	"scripts/roguelite/replayability/roguelite_replayability_runtime.gd"
	"scenes/roguelite/roguelite_build_variety_review.tscn"
	"scripts/roguelite/build_variety/roguelite_build_variety_runtime.gd"
	"scripts/first_mvp/severed_threshold/broken_watch_slice.gd"
	"scripts/ui/first_mvp_combat_hud.gd"
	"scripts/ui/first_mvp_modal.gd"
	"scripts/ui/first_mvp_item_comparison.gd"
	"scripts/ui/first_mvp_fallen_overlay.gd"
	"scripts/camera/prototype_camera_rig.gd"
	"scripts/actors/prototype_player.gd"
	"scenes/actors/prototype_player.tscn"
	"scripts/actors/prototype_graveblade.gd"
	"scenes/actors/prototype_graveblade.tscn"
	"scenes/actors/graveblade_rig.tscn"
	"scripts/actors/graveblade_target_area.gd"
	"scripts/combat/graveblade_data.gd"
	"scripts/combat/damage_event.gd"
	"scripts/combat/attack_coordinator.gd"
	"data/prototype_zero/graveblade.tres"
	"data/roguelite/graveblade_elite.tres"
	"scripts/experience/rift_mote_runtime.gd"
	"scripts/experience/rift_graveblade_mote_binding.gd"
	"scripts/experience/rift_enemy_mote_emission.gd"
	"scripts/experience/rift_experience_mote.gd"
	"scripts/experience/rift_experience_track.gd"
	"scripts/experience/rift_experience_reading.gd"
	"scripts/pickups/rift_mote_field.gd"
	"scripts/pickups/rift_mote_sweep_result.gd"
	"scripts/pickups/rift_mote_drop.gd"
	"scripts/pickups/rift_mote_collection_attempt.gd"
	"scripts/pickups/rift_mote_collection_result.gd"
	"scripts/pickups/rift_mote_pickup_query.gd"
	"scripts/pickups/rift_mote_pickup_reading.gd"
	"scripts/levels/rift_run_level_coordinator.gd"
	"scripts/levels/rift_run_level_up_result.gd"
	"scripts/level_requirements/rift_level_requirement_curve.gd"
	"scripts/level_requirements/rift_level_requirement_reading.gd"
)

SHOT_DIR=""
if [[ "${1:-}" == "--shots" && -n "${2:-}" ]]; then
	mkdir -p "$2"
	SHOT_DIR="$(cd "$2" && pwd)"
fi

failures=0
step() { printf '\n=== %s\n' "$1"; }
pass() { printf '  PASS  %s\n' "$1"; }
fail() { printf '  FAIL  %s\n' "$1"; failures=$((failures + 1)); }

fingerprint() {
	if [[ -f "$1" ]]; then
		shasum -a 256 "$1" | awk '{print $1}'
	else
		echo "MISSING"
	fi
}

state_fingerprint() {
	if [[ -f "$1" ]]; then
		printf '%s bytes, sha256 %s, mtime %s' \
			"$(wc -c < "$1" | tr -d ' ')" \
			"$(shasum -a 256 "$1" | cut -d' ' -f1)" \
			"$(stat -f %m "$1")"
	else
		printf 'absent'
	fi
}

# D-201's lesson, kept alive in every runner since: a run that reports PASS while
# a script error scrolled past is not a pass.
assert_no_script_error() {
	local what="$1" logfile="$2" found
	found="$(grep -cE "SCRIPT ERROR|String formatting error|Parse Error" "$logfile" 2>/dev/null | tr -d ' ')"
	if [[ "$found" == "0" ]]; then
		pass "$what produced no SCRIPT ERROR"
	else
		fail "$what produced $found script error line(s)"
		grep -A3 -E "SCRIPT ERROR|String formatting error|Parse Error" "$logfile" | head -20 | sed 's/^/        /'
	fi
}

# Real scenes run here, so engine ERROR lines are refused outright, and every
# WARNING line must be one of the accepted bake's two known lines — printed, so
# the report can state them rather than hide them.
assert_engine_output() {
	local what="$1" logfile="$2" errors warnings unknown=0 line known
	errors="$(grep -cE "^ERROR:" "$logfile" 2>/dev/null | tr -d ' ')"
	if [[ "$errors" == "0" ]]; then
		pass "$what produced no engine ERROR line"
	else
		fail "$what produced $errors engine ERROR line(s)"
		grep -A2 -E "^ERROR:" "$logfile" | head -20 | sed 's/^/        /'
	fi
	warnings="$(grep -cE "^WARNING:" "$logfile" 2>/dev/null | tr -d ' ')"
	while IFS= read -r line; do
		known=0
		for expected in "${KNOWN_WARNINGS[@]}"; do
			[[ "$line" == "$expected" ]] && known=1
		done
		if [[ "$known" == "0" ]]; then
			fail "$what printed an unexpected warning: $line"
			unknown=$((unknown + 1))
		fi
	done < <(grep -E "^WARNING:" "$logfile" 2>/dev/null)
	if [[ "$unknown" == "0" ]]; then
		pass "$what printed $warnings engine WARNING line(s), each one of the accepted core loop's two navigation-bake precision warnings"
		grep -E "^WARNING:" "$logfile" | sed 's/^/        reported: /'
	fi
}

# `/tmp` is never cleared between runs, so a file from an earlier — possibly
# interrupted — invocation must never answer for this one.
assert_log_is_fresh() {
	local logfile="$1" written
	if [[ ! -f "$logfile" ]]; then
		fail "$logfile was never written"
		return
	fi
	written="$(stat -f %m "$logfile" 2>/dev/null || echo 0)"
	if [[ "$written" -ge "$RUN_STARTED_AT" ]]; then
		pass "$(basename "$logfile") was written by THIS run"
	else
		fail "$(basename "$logfile") is older than this run — a stale log answered for it"
	fi
}

# The three-step read the project settled on. A single `grep -ohE '[0-9]+'` would
# read a digit out of a label and refuse every run.
read_check_count() {
	grep -ohE "$1: PASS \([0-9]+ checks\)" "$2" \
		| grep -ohE '[0-9]+ checks' | grep -ohE '[0-9]+' | head -1
}

run_verification() {
	local logfile="$1"
	shift
	perl -e 'alarm shift; exec @ARGV' "$VERIFICATION_TIMEOUT" "$GODOT" "$@" > "$logfile" 2>&1
}

printf 'Riftwrought — Roguelite Experience Collection Greybox Review V1 smoke checks (D-288)\n'
printf 'project: %s\n' "$PROJECT_DIR"

# --------------------------------------------------------------------------
step "0. Engine, and a fingerprint of everything this review must not disturb"

installed="$("$GODOT" --version 2>/dev/null | tail -1)"
printf '  installed: %s\n' "$installed"
if [[ "$installed" == "$EXPECTED_VERSION"* ]]; then
	pass "matches the locked $EXPECTED_VERSION baseline"
else
	fail "expected $EXPECTED_VERSION, found $installed"
fi

declare -a BEFORE_HASHES
missing_preserved=0
for i in "${!PRESERVED_FILES[@]}"; do
	BEFORE_HASHES[$i]="$(fingerprint "$PROJECT_DIR/${PRESERVED_FILES[$i]}")"
	if [[ "${BEFORE_HASHES[$i]}" == "MISSING" ]]; then
		fail "protected file ${PRESERVED_FILES[$i]} does not exist"
		missing_preserved=$((missing_preserved + 1))
	fi
done
if [[ "$missing_preserved" == "0" ]]; then
	pass "${#PRESERVED_FILES[@]} protected file(s) fingerprinted"
fi

project_name="$(sed -n 's/^config\/name="\(.*\)"[[:space:]]*$/\1/p' "$PROJECT_DIR/project.godot" | head -1)"
production_dir="$HOME/Library/Application Support/Godot/app_userdata/$project_name"
settings_before="$(state_fingerprint "$production_dir/prototype_settings.cfg")"
lab_before="$(state_fingerprint "$production_dir/prototype_zero.cfg")"
character_before="$(state_fingerprint "$production_dir/riftwrought_character.cfg")"
pass "the project owner's own three user:// files fingerprinted"

# --------------------------------------------------------------------------
step "1. Every new script parses"

for relative in "${NEW_SCRIPTS[@]}"; do
	if [[ ! -f "$PROJECT_DIR/$relative" ]]; then
		fail "$relative is missing"
		continue
	fi
	out="$("$GODOT" --headless --path "$PROJECT_DIR" --check-only --script "res://$relative" 2>&1 \
		| grep -v '^Godot Engine')"
	if [[ -z "$out" ]]; then
		pass "$relative parses"
	else
		fail "$relative does not parse"
		printf '%s\n' "$out" | head -10 | sed 's/^/        /'
	fi
done

# --------------------------------------------------------------------------
step "2. The review names no asset or storage, inherits the accepted scene, and reads no other suite"

# The ASSET scan is RAW, comments included (D-215): an illustrative asset path in a
# comment breaches the rule as surely as a real one. The STORAGE scan is
# COMMENT-STRIPPED, so a file may say in prose that it writes nothing.
asset_fragments='res://assets/|\.gltf|\.glb|\.png|\.import|kaykit|kenney|k0rveen|quaternius|lelu|GPUParticles|CPUParticles|ShaderMaterial|\.gdshader|AudioStream|Texture2D'
hits=0
for relative in "${SHIPPING_FILES[@]}"; do
	if grep -qE "$asset_fragments" "$PROJECT_DIR/$relative"; then
		fail "$relative names an asset, shader, particle or sound fragment"
		grep -inE "$asset_fragments" "$PROJECT_DIR/$relative" | head -3 | sed 's/^/        /'
		hits=$((hits + 1))
	fi
done
if [[ "$hits" == "0" ]]; then
	pass "raw scan of ${#SHIPPING_FILES[@]} shipping file(s), comments included: no asset, shader, particle or sound"
fi

storage_fragments='user://|ConfigFile|ResourceSaver|FileAccess|DirAccess|store_string|save_png|PrototypeSettings|PrototypeLabState|CharacterSave'
storage_hits=0
for relative in "${SHIPPING_FILES[@]}"; do
	if sed -e 's/^[[:space:]]*#.*$//' -e 's/^[[:space:]]*;.*$//' "$PROJECT_DIR/$relative" \
			| grep -qE "$storage_fragments"; then
		fail "$relative names a storage path, store or writer in CODE"
		storage_hits=$((storage_hits + 1))
	fi
done
if [[ "$storage_hits" == "0" ]]; then
	pass "comment-stripped scan: no shipping file names a storage path, store or writer"
fi

scene_file="$PROJECT_DIR/$REVIEW_SCENE"
statements="$(grep -vE '^[[:space:]]*(;|$)' "$scene_file")"
if [[ "$(grep -c '^\[node ' <<< "$statements")" == "1" \
		&& "$(grep -c '^\[ext_resource ' <<< "$statements")" == "2" \
		&& "$(grep -c '^\[sub_resource ' <<< "$statements")" == "0" \
		&& "$(grep -c '^script = ExtResource(' <<< "$statements")" == "1" ]] \
		&& grep -qF "path=\"$ACCEPTED_SCENE\"" <<< "$statements" \
		&& grep -qE '^\[node name="[A-Za-z]+" instance=ExtResource\(' <<< "$statements"; then
	pass "the scene is one inherited instance of $ACCEPTED_SCENE with its script replaced, and no node of its own"
else
	fail "the scene is not one inherited instance of the accepted scene"
fi

others="$(grep -oE 'res://tests/[A-Za-z0-9_./-]+' "$PROJECT_DIR/$THIS_VERIFICATION" | sort -u \
	| grep -vxF "res://$THIS_VERIFICATION" | tr '\n' ' ')"
if [[ -z "${others// /}" ]] && grep -qF "res://$THIS_VERIFICATION" "$PROJECT_DIR/$REVIEW"; then
	pass "the verification names no file under tests/ but its own, and the review starts it only on its own flag"
else
	fail "the verification names another test file: ${others:-none}"
fi

# The Zone Composer's own guards reach any new file under scripts/ or scenes/.
if grep -qE 'ZoneComposer|addons/riftwrought_zone_composer' "$PROJECT_DIR/$REVIEW" "$PROJECT_DIR/$REVIEW_HUD" "$scene_file"; then
	fail "a review file names the Zone Composer, which turns its closed suite red"
else
	pass "no review file names the Zone Composer"
fi

# --------------------------------------------------------------------------
step "3. An ordinary headless boot assembles the review and makes no runtime in the Nexus"

boot_log="/tmp/riftwrought_experience_review_boot.log"
"$GODOT" --headless --path "$PROJECT_DIR" "$SCENE" --quit-after 240 > "$boot_log" 2>&1
boot_status=$?
printf '  boot exit status: %s\n' "$boot_status"
assert_log_is_fresh "$boot_log"
assert_no_script_error "an ordinary headless boot" "$boot_log"
if [[ "$boot_status" == "0" ]] && grep -q "greybox review layer assembled on the accepted loop" "$boot_log" \
		&& grep -q "isolated review assembled" "$boot_log"; then
	pass "the accepted loop assembled, then the review layer, and the boot exited 0"
else
	fail "the review did not report assembling on the accepted loop (exit $boot_status)"
fi
if grep -q "experience runtime .*opened" "$boot_log"; then
	fail "an Experience Mote runtime was opened in the Nexus"
else
	pass "no Experience Mote runtime was opened in the Nexus"
fi

# --------------------------------------------------------------------------
step "4. The pinned verification passes, proved in BOTH directions"

verify_log="/tmp/riftwrought_experience_review_verify.log"
run_verification "$verify_log" --headless --path "$PROJECT_DIR" "$SCENE" -- --seed "$ROUTE_SEED" --verify-experience
verify_status=$?
printf '  verification exit status: %s\n' "$verify_status"
assert_log_is_fresh "$verify_log"
assert_no_script_error "the headless verification" "$verify_log"
assert_engine_output "the headless verification" "$verify_log"

if [[ "$verify_status" == "0" ]]; then
	pass "the verification exited 0"
elif [[ "$verify_status" == "142" ]]; then
	fail "the verification did not finish within $VERIFICATION_TIMEOUT s and was killed"
else
	fail "the verification exited $verify_status"
	grep -E "^  FAIL" "$verify_log" | head -20 | sed 's/^/        /'
fi

count="$(read_check_count "ROGUELITE EXPERIENCE COLLECTION REVIEW VERIFICATION" "$verify_log")"
if [[ "$count" == "$EXPECTED_CHECKS" ]]; then
	pass "verification passes at the pinned $EXPECTED_CHECKS checks"
else
	fail "verification reports ${count:-no} checks, not $EXPECTED_CHECKS"
fi

# A guard that accepts everything protects nothing: the pin must refuse a log
# whose count moved by one, and the negative direction must READ the moved number,
# because a bare `!=` is satisfied by the empty string.
replay="$(mktemp -t riftwrought_experience_review_replay)"
scratch_replay="$replay"
sed "s/ROGUELITE EXPERIENCE COLLECTION REVIEW VERIFICATION: PASS ($EXPECTED_CHECKS checks)/ROGUELITE EXPERIENCE COLLECTION REVIEW VERIFICATION: PASS ($((EXPECTED_CHECKS + 1)) checks)/" \
	"$verify_log" > "$replay"
replay_count="$(read_check_count "ROGUELITE EXPERIENCE COLLECTION REVIEW VERIFICATION" "$replay")"
if [[ -z "$count" ]]; then
	fail "the verification printed no count line, so the count pin proves nothing this run"
elif [[ "$replay_count" == "$((EXPECTED_CHECKS + 1))" ]]; then
	pass "and that pin reads a log whose count moved by one as $replay_count, refusing it"
else
	fail "the count pin read '${replay_count:-nothing}' from a moved log and therefore proves nothing"
fi

if grep -qE "^  $EXPECTED_OWED_CHECKS of $EXPECTED_OWED_CHECKS owed checks completed" "$verify_log"; then
	pass "all $EXPECTED_OWED_CHECKS owed checks reached their last line"
else
	fail "the owed-set report is missing or short"
	grep -E "owed checks" "$verify_log" | sed 's/^/        /'
fi

# The measurements this review exists to make, read out of the run's own log
# rather than restated here. `--` before the pattern is D-244's lesson kept. Two
# lines are pinned only from after a number that varies: the review panel's
# rectangle depends on the window, and the class count grows with the project.
while IFS= read -r line; do
	if grep -qF -- "$line" "$verify_log"; then
		pass "measured: ${line}"
	else
		fail "the verification log does not report: ${line}"
	fi
done <<'MEASURED'
inherited instance of roguelite_core_loop.tscn; 4 modules, route teaching_hall, cache_room, elite_hall, Graveblades per room [1, 2, 2], 1 bake, camera 19 m / 55 deg / 45 deg, speed 5.0 m/s
9 overrides (_begin_run, _build_run_surfaces, _complete_run, _handle_review_keys, _maybe_start_verification, _physics_process, _process, _refresh_run_hud, restart_current_slice), 8 calling the accepted method; 0 of 22 assembly methods re-implemented
31 actions; none names the review; F8 is bound only to toggle_slow_motion, which nothing here answers; pickup ON -> OFF -> ON by the physical key; time scale 1.0
runtime null, 0 created, 0 markers, 0 observers; every died reads R; the panel reads 'Next run seed 00000063' and 'No expedition in progress'
expedition seed 99 = runtime seed 99, shown 'Run seed 00000063'; 5 of 5 route Graveblades registered once, alive and unheard; every died reads RBR; 'XP 0 / 100'
both records still carry 10 and the 5 actors 10, 10, 10, 10, 10; every registration uses the review's own 25.0 — a provisional greybox review value
Life 300 -> 200 -> 100; drops 0, markers 0, death heard false, experience 0.0
1 drop, 1 marker at (28.00, -48.00) where it fell; 81.9 m from the event's attacker, 59.1 m from its target; experience 0.0; 2 meshes, 0 collision; room cleared by the accepted counter
over the death position (28.000, 0.000, -48.000): the ring at (28.000, 0.025, -48.000) and the orb's centre at (28.000, 0.700, -48.000) — its own X/Z, 0.025 m and 0.70 m straight above
0 sweeps while standing on the mote; experience 0.0; the marker is still shown; 'Automatic pickup OFF — F8 toggles'
5 player positions and a camera moved 19.0 m -> 25.0 m and back: the orb stayed at (28.000, 0.700, -48.000) and the ring at (28.000, 0.025, -48.000)
4 m away: attempted 1, out of range 1; 2.5000019 m (one float32 step outside): out of range, experience 0.0; exactly 2.5 m: collected [0], experience 25.0; the marker flashed and hid; 'XP 25 / 100'
4 of 4 sides one float32 step outside refused; the flash began at the lifted orb (28.000, 0.700, -48.000) with the drop already collected and 25.0 already paid; the collecting sweep stood 2.5000 m from the drop on the ground
a later sweep skipped 1 and attempted 0; experience stayed 25.0; the marker stayed hidden
killed Room2Enemy1 then Room2Enemy0: markers 1 and 2 at their own falls; a sweep at 2 collected [2] (skipped 1, out of range 1) and left marker 1 shown; then [1]; experience 75.0
experience [25.0, 50.0, 75.0, 100.0] after four motes; G1's Level 1 requirement 100; level 1; offer false; paused false; 'XP 100 / 100' + 'LEVEL-UP READY'
5 markers — 4 ordinary Graveblades and the 600-Life Elite — each draw the orb (0.00, 0.700, 0.00) and the ring (0.00, 0.025, 0.00) from their own death position
10 of 10 lines visible, smallest 12 px; 15 other surface rectangles measured, 0 overlapping; beneath 3 of 3 modals
5 route Graveblades -> maximum review experience 125.0; level 1; offer false; 'XP 125 / 100'; LEVEL-UP READY still shown
the five collecting sweeps answered [[0], [2], [1], [3], [4]] — the indices D-288 measured before the orb was lifted
runtime null and freed; 0 markers, 0 marker nodes, 0 observers; every died reads R; 5 of 5 Graveblades revived by the accepted reset; 'No expedition in progress'
seed 1376869141 shown 'Run seed 52115B15'; the first runtime is freed; 5 fresh bindings; every died reads RBR; the revived Teaching Hall Graveblade's death made 1 drop and 1 marker; 0 stale callbacks
'Last refusal: no marker hidden — the sweep collected drop 5 and only 1 marker(s) mirror the field'; then an answer collecting drop 5 of 1 marker: 1 mirror refusal, 0 markers hidden, experience 0.0
through the Teaching Hall's gate into the Cache Room, 44.5 m away: drop 0 still attempted, out of range and uncollected at its index; experience 0.0; its marker still shown where it fell; 'Motes 1 total · 1 uncollected · 0 collected'
runtime null and freed; 0 markers, 0 marker nodes, 0 observers; every died reads R; last refusal cleared; 'No expedition in progress'
0 sweeps while fallen on the mote; the mote stayed uncollected; Fallen's return discarded the runtime (freed), every marker and observer; every died reads R
1 runtime made from the expedition's seed; 1 sweep, 1 registration, 1 requirement asked, 1 index read; 0 of 36 restated tokens; no literal 100; only marker nodes freed
the review names DamageEvent, PrototypeGraveblade, RiftLevelRequirementCurve, RiftLevelRequirementReading, RiftMoteRuntime, RiftMoteSweepResult, RogueliteCoreLoopRuntime, RogueliteExperienceCollectionReview, RogueliteExperienceReviewHud; its panel names RogueliteExperienceCollectionReview, RogueliteExperienceReviewHud
0 storage and 0 asset tokens in the review's two scripts and its scene
7 Graveblade deaths were driven and
MEASURED

# --------------------------------------------------------------------------
step "5. project.godot is untouched"

project_godot="$PROJECT_DIR/project.godot"
actions="$(sed -n '/^\[input\]/,/^\[layer_names\]/p' "$project_godot" | grep -cE '^[a-zA-Z_0-9]+=')"
if [[ "$actions" == "$EXPECTED_INPUT_ACTIONS" ]]; then
	pass "the InputMap still declares exactly $EXPECTED_INPUT_ACTIONS actions"
else
	fail "the InputMap declares $actions actions, not $EXPECTED_INPUT_ACTIONS"
fi
main_scene="$(grep -oE 'run/main_scene="[^"]+"' "$project_godot" | head -1 | sed -E 's/run\/main_scene="([^"]+)"/\1/')"
if [[ "$main_scene" == "$EXPECTED_MAIN_SCENE" ]]; then
	pass "the entrypoint is still $EXPECTED_MAIN_SCENE"
else
	fail "the entrypoint is '$main_scene', not $EXPECTED_MAIN_SCENE"
fi
sections="$(grep -oE '^\[[a-z_]+\]$' "$project_godot" | tr -d '[]' | sort | tr '\n' ' ' | sed 's/ $//')"
if [[ "$sections" == "$EXPECTED_SECTIONS" ]]; then
	pass "the same nine sections, no new one"
else
	fail "project.godot's sections are '$sections'"
fi
if grep -q '^\[autoload\]' "$project_godot"; then
	fail "an [autoload] section was added"
else
	pass "there is still no [autoload]"
fi
if grep -qiE "experience_collection|RogueliteExperience" "$project_godot"; then
	fail "project.godot names this review — it must own no project setting"
else
	pass "project.godot names nothing about this review"
fi

# --------------------------------------------------------------------------
step "6. The third-party inventory has not moved — the review extracts nothing"

payloads="$(find "$PROJECT_DIR/assets/third_party" -type f \
	! -name '*.import' ! -name '.DS_Store' ! -name '*.md' 2>/dev/null | wc -l | tr -d ' ')"
maps=0
for note in "$PROJECT_DIR/assets/third_party/kenney/SOURCE_AND_LICENSE.md" \
		"$PROJECT_DIR/assets/third_party/quaternius/SOURCE_AND_LICENSE.md"; do
	[[ -f "$note" ]] && maps=$((maps + 1))
done
total=$((payloads + maps))
printf '  arithmetic: %d payload(s) + %d source map(s) = %d\n' "$payloads" "$maps" "$total"
if [[ "$payloads" == "$EXPECTED_THIRD_PARTY_PAYLOADS" && "$total" == "$EXPECTED_THIRD_PARTY" ]]; then
	pass "still $EXPECTED_THIRD_PARTY_PAYLOADS + $maps = $EXPECTED_THIRD_PARTY, unchanged"
else
	fail "the third-party inventory is $payloads + $maps = $total, not $EXPECTED_THIRD_PARTY_PAYLOADS + 2 = $EXPECTED_THIRD_PARTY"
fi

# --------------------------------------------------------------------------
step "7. Rendered evidence"

if [[ -n "$SHOT_DIR" ]]; then
	for resolution in 1920x1080 1280x720; do
		target="$SHOT_DIR"
		[[ "$resolution" == "1280x720" ]] && target="$SHOT_DIR/1280x720"
		mkdir -p "$target"
		shots_log="/tmp/riftwrought_experience_review_shots_$resolution.log"
		run_verification "$shots_log" --path "$PROJECT_DIR" --resolution "$resolution" "$SCENE" \
			-- --seed "$ROUTE_SEED" --verify-experience --shots "$target"
		shots_status=$?
		printf '  %s verification exit status: %s\n' "$resolution" "$shots_status"
		assert_log_is_fresh "$shots_log"
		assert_no_script_error "the $resolution rendered run" "$shots_log"
		assert_engine_output "the $resolution rendered run" "$shots_log"
		rendered_count="$(read_check_count "ROGUELITE EXPERIENCE COLLECTION REVIEW VERIFICATION" "$shots_log")"
		if [[ "$shots_status" == "0" && "$rendered_count" == "$EXPECTED_CHECKS" ]]; then
			pass "the $resolution rendered run exits 0 at the same pinned $EXPECTED_CHECKS checks"
		else
			fail "the $resolution rendered run exits $shots_status at ${rendered_count:-no} checks, not $EXPECTED_CHECKS"
			grep -E "^  FAIL" "$shots_log" | head -10 | sed 's/^/        /'
		fi
		if grep -qF "10 of 10 lines visible, smallest 12 px; 15 other surface rectangles measured, 0 overlapping; beneath 3 of 3 modals" "$shots_log"; then
			pass "at $resolution the review panel is fully visible, overlaps nothing and sits beneath every modal"
		else
			fail "at $resolution the review panel's on-screen measurement is missing or different"
		fi
		shots=0
		for stem in 01_uncollected_mote_pickup_off 02_level_up_ready 03_fresh_second_run; do
			frame="$target/$stem.png"
			if [[ -f "$frame" && "$(stat -f %m "$frame")" -ge "$RUN_STARTED_AT" && "$(wc -c < "$frame" | tr -d ' ')" -gt 20000 ]]; then
				shots=$((shots + 1))
			else
				fail "$stem.png was not freshly captured at $resolution"
			fi
		done
		if [[ "$shots" == "3" ]]; then
			pass "all 3 evidence frames freshly captured into $target"
		fi
	done
else
	printf '  skipped (pass --shots <dir> to render evidence)\n'
fi

# --------------------------------------------------------------------------
step "8. Every protected file is byte-identical, and the owner's files are untouched"

changed=0
for i in "${!PRESERVED_FILES[@]}"; do
	after="$(fingerprint "$PROJECT_DIR/${PRESERVED_FILES[$i]}")"
	if [[ "$after" != "${BEFORE_HASHES[$i]}" ]]; then
		fail "${PRESERVED_FILES[$i]} CHANGED during this run"
		changed=$((changed + 1))
	fi
done
if [[ "$changed" == "0" && "$missing_preserved" == "0" ]]; then
	pass "all ${#PRESERVED_FILES[@]} protected files are byte-identical"
fi

settings_after="$(state_fingerprint "$production_dir/prototype_settings.cfg")"
lab_after="$(state_fingerprint "$production_dir/prototype_zero.cfg")"
character_after="$(state_fingerprint "$production_dir/riftwrought_character.cfg")"
if [[ "$settings_after" == "$settings_before" && "$lab_after" == "$lab_before" \
		&& "$character_after" == "$character_before" ]]; then
	pass "the project owner's own prototype_settings.cfg, prototype_zero.cfg and riftwrought_character.cfg are unchanged"
else
	fail "a file in the project owner's own user:// directory changed during this run"
fi

# --------------------------------------------------------------------------
printf '\n'
if [[ "$failures" == "0" ]]; then
	printf 'ROGUELITE EXPERIENCE COLLECTION REVIEW SMOKE CHECKS: PASS\n'
	printf '  %s checks; %s of %s owed; %s protected files byte-identical\n' \
		"$EXPECTED_CHECKS" "$EXPECTED_OWED_CHECKS" "$EXPECTED_OWED_CHECKS" "${#PRESERVED_FILES[@]}"
	printf '  Roguelite Experience Collection Greybox Review V1 is DELIVERED under D-288,\n'
	printf '  CORRECTED under D-289, and ACCEPTED and CLOSED at the playable\n'
	printf '  Experience-Mote collection greybox level under D-290.\n'
	reached_end=1
	exit 0
else
	printf 'ROGUELITE EXPERIENCE COLLECTION REVIEW SMOKE CHECKS: %d FAILURE(S)\n' "$failures"
	reached_end=1
	exit 1
fi
