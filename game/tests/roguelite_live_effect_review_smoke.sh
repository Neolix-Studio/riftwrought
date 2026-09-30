#!/usr/bin/env bash
# Riftwrought — Roguelite I3: Live Level-Up Effect Application Review V1 smoke checks
# (decision D-295).
#
# THIS IS NOT A GATE, AND IT RUNS NO LOCKED CHAIN.
#
# The review is one ISOLATED playable instrument: a scene that INHERITS the accepted
# Level-Up Choice Review scene (I2), a runtime that EXTENDS I2's runtime and applies the
# expedition's whole temporary build to the playable character through ONE new
# run-build application seam, and this suite. Its production reach beyond its own
# three scripts and one scene is exactly three authorized edits — H8's one-line build
# reading, the catalogue's three rank-one review values, and I2's panel note setter —
# each proved by the accepted suites that own them. It adds no asset, no InputMap
# action, writes nothing to disk, and is not the project entrypoint. What this script
# proves is what the review CAN break:
#
#   1. every new and every edited script parses;
#   2. the review's shipping files name no asset, shader, particle, sound or storage,
#      the scene is one inherited instance of I2's accepted scene, and the
#      verification reads no other suite;
#   3. an ordinary headless boot assembles the loop, then H9's layer, then I2's, then
#      this one, with zero SCRIPT ERROR, and opens no runtime, offer or panel in the
#      Nexus;
#   4. the pinned verification passes, proved in BOTH directions against a replay of
#      its own log, with every owed check reaching its last line, the measured lines
#      read out of that log, zero SCRIPT ERROR and zero engine ERROR, and no engine
#      WARNING but the accepted core loop's own two navigation-bake precision warnings
#      — and a run that hangs is killed and FAILS;
#   5. `project.godot` is untouched: 31 actions, the Prototype App entrypoint, the
#      same nine sections, no `[autoload]`, nothing naming this review;
#   6. the third-party inventory has not moved (185 + 2 = 187);
#   7. optionally (`--shots <dir>`), rendered evidence at 1920x1080 and at the
#      1280x720 minimum tested window, each run passing at the SAME pinned count,
#      because the evidence frames add no assertion;
#   8. every file this review could conceivably disturb — I2's and H9's production
#      files, suites and all twelve of their accepted evidence frames, the canonical
#      Quick Strike record, the combat and movement kernels, C1, D2, G4, H8, the
#      catalogues, the core loop, the modal contract, the project owner's composed
#      zone and loading teaser with its import record and imported cache,
#      `project.godot`, `CLAUDE.md` and `README.md` — is BYTE-IDENTICAL across the
#      run, and the project owner's own user:// files are untouched.
#
# Usage, from the repository root:
#   game/tests/roguelite_live_effect_review_smoke.sh
#   game/tests/roguelite_live_effect_review_smoke.sh --shots docs/testing/roguelite_live_effect_review_evidence

set -uo pipefail

# Assigned at the TOP of the script, never beside the function it serves: a shell
# evaluates an assignment only when execution REACHES it.
RUN_STARTED_AT="$(date +%s)"

# A SCRIPT THAT DIES HALFWAY MUST NOT REPORT SUCCESS.
reached_end=0
scratch_replay=""
on_exit() {
	local code=$?
	[[ -n "$scratch_replay" ]] && rm -f "$scratch_replay"
	if [[ "$reached_end" != "1" ]]; then
		printf '\nROGUELITE LIVE EFFECT REVIEW SMOKE CHECKS: ABORTED before the end of the script\n'
		printf '  the run stopped early (exit %s) — nothing after that point was proved\n' "$code"
		exit 1
	fi
	exit "$code"
}
trap on_exit EXIT

GODOT="${GODOT:-/Applications/Godot.app/Contents/MacOS/Godot}"
EXPECTED_VERSION="4.7.2.stable"
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

SCENE="res://scenes/roguelite/roguelite_live_effect_review.tscn"
ACCEPTED_SCENE="res://scenes/roguelite/roguelite_level_up_choice_review.tscn"
ROUTE_SEED=99

# Pinned, and proved in both directions below. ONE number: the rendered evidence
# frames add no assertion, so the headless and both rendered runs must agree. It is
# the count of the suite's first green development run, whose 25 owed check functions
# are itemised in D-295.
# D-297 added exactly one: the held-only receipt proof in check 22 (121 -> 122).
# D-298 (Roguelite I4) gave rank two a reviewed record, so check 23's unsupported rank
# and its catalogue emptiness moved one for one from rank 2 to rank 3, and two measured
# lines below moved with them; no assertion was added or removed, and 122 did not move.
EXPECTED_CHECKS=122
EXPECTED_OWED_CHECKS=25

# Seconds a verification may take before it is killed and counted as a failure.
VERIFICATION_TIMEOUT=900

EXPECTED_INPUT_ACTIONS=31
EXPECTED_MAIN_SCENE="res://scenes/app/prototype_app.tscn"
EXPECTED_SECTIONS="application audio debug display editor_plugins input layer_names navigation rendering"

# The review extracts nothing. D-216's authorized numbers, unmoved.
EXPECTED_THIRD_PARTY_PAYLOADS=185
EXPECTED_THIRD_PARTY=187

# The only engine warnings the verification may print: the accepted core loop's own
# navigation bake rounding its agent values to the voxel grid (accepted under D-290
# as pre-existing review output).
KNOWN_WARNINGS=(
	"WARNING: Property agent_max_climb is floored to cell_height voxel units and loses precision."
	"WARNING: Property agent_radius is ceiled to cell_size voxel units and loses precision."
)

REVIEW="scripts/roguelite/live_effects/roguelite_live_effect_review.gd"
SEAM="scripts/roguelite/live_effects/rift_build_application.gd"
RESULT="scripts/roguelite/live_effects/rift_build_application_result.gd"
REVIEW_SCENE="scenes/roguelite/roguelite_live_effect_review.tscn"
THIS_VERIFICATION="tests/roguelite_live_effect_review_verification.gd"

# The three new scripts, this suite, and the three accepted production scripts this
# review was authorized to extend by one member each.
PARSED_SCRIPTS=(
	"$REVIEW"
	"$SEAM"
	"$RESULT"
	"$THIS_VERIFICATION"
	"scripts/experience/rift_mote_runtime.gd"
	"scripts/skills/skill_support_catalogue.gd"
	"scripts/roguelite/level_up/rift_level_up_offer_panel.gd"
)

SHIPPING_FILES=(
	"$REVIEW"
	"$SEAM"
	"$RESULT"
	"$REVIEW_SCENE"
)

# DELIBERATELY SHORT, AND NOT A WHOLE-PROJECT CATALOGUE: the files this review
# inherits, composes, asks, applies to or stands beside, and the project owner's work.
PRESERVED_FILES=(
	"project.godot"
	"scenes/first_mvp/zone_composer_practice.tscn"
	"assets/prototype/ui/loading/riftwrought-loading-teaser-v1.png"
	"assets/prototype/ui/loading/riftwrought-loading-teaser-v1.png.import"
	".godot/imported/riftwrought-loading-teaser-v1.png-b052aa6f935e93824cd8ff133a3ff6f4.ctex"
	".godot/imported/riftwrought-loading-teaser-v1.png-b052aa6f935e93824cd8ff133a3ff6f4.md5"
	"../CLAUDE.md"
	"../README.md"
	"scripts/roguelite/level_up/roguelite_level_up_choice_review.gd"
	"scripts/roguelite/level_up/rift_level_up_offer_panel.gd"
	"scenes/roguelite/roguelite_level_up_choice_review.tscn"
	"tests/roguelite_level_up_choice_review_verification.gd"
	"tests/roguelite_level_up_choice_review_smoke.sh"
	"../docs/testing/roguelite_level_up_choice_review_evidence/01_three_card_offer.png"
	"../docs/testing/roguelite_level_up_choice_review_evidence/02_support_receipt.png"
	"../docs/testing/roguelite_level_up_choice_review_evidence/03_passive_receipt.png"
	"../docs/testing/roguelite_level_up_choice_review_evidence/1280x720/01_three_card_offer.png"
	"../docs/testing/roguelite_level_up_choice_review_evidence/1280x720/02_support_receipt.png"
	"../docs/testing/roguelite_level_up_choice_review_evidence/1280x720/03_passive_receipt.png"
	"scripts/roguelite/experience/roguelite_experience_collection_review.gd"
	"scripts/roguelite/experience/roguelite_experience_review_hud.gd"
	"scenes/roguelite/roguelite_experience_collection_review.tscn"
	"tests/roguelite_experience_collection_review_verification.gd"
	"tests/roguelite_experience_collection_review_smoke.sh"
	"../docs/testing/roguelite_experience_collection_review_evidence/01_uncollected_mote_pickup_off.png"
	"../docs/testing/roguelite_experience_collection_review_evidence/02_level_up_ready.png"
	"../docs/testing/roguelite_experience_collection_review_evidence/03_fresh_second_run.png"
	"../docs/testing/roguelite_experience_collection_review_evidence/1280x720/01_uncollected_mote_pickup_off.png"
	"../docs/testing/roguelite_experience_collection_review_evidence/1280x720/02_level_up_ready.png"
	"../docs/testing/roguelite_experience_collection_review_evidence/1280x720/03_fresh_second_run.png"
	"scenes/roguelite/roguelite_core_loop.tscn"
	"scripts/roguelite/roguelite_core_loop_runtime.gd"
	"scripts/roguelite/roguelite_run_plan.gd"
	"scripts/roguelite/roguelite_run_state.gd"
	"scripts/roguelite/roguelite_run_hud.gd"
	"scripts/roguelite/roguelite_fallen_overlay.gd"
	"scripts/roguelite/roguelite_run_summary_panel.gd"
	"scripts/first_mvp/severed_threshold/broken_watch_slice.gd"
	"scripts/ui/first_mvp_modal.gd"
	"scripts/ui/first_mvp_combat_hud.gd"
	"scripts/ui/first_mvp_fallen_overlay.gd"
	"scripts/actors/prototype_player.gd"
	"scenes/actors/prototype_player.tscn"
	"scripts/actors/prototype_graveblade.gd"
	"scenes/actors/prototype_graveblade.tscn"
	"scripts/movement/prototype_locomotion.gd"
	"scripts/combat/quick_strike_action.gd"
	"scripts/combat/quick_strike_data.gd"
	"scripts/combat/target_acquisition.gd"
	"data/prototype_zero/quick_strike.tres"
	"data/prototype_zero/graveblade.tres"
	"data/roguelite/graveblade_elite.tres"
	"data/roguelite/worn_blade.tres"
	"scripts/stats/player_stats.gd"
	"scripts/stats/player_stat_totals.gd"
	"scripts/stats/player_stat_value.gd"
	"scripts/stats/player_stat_definition.gd"
	"scripts/stats/passive_card_catalogue.gd"
	"scripts/stats/passive_card_definition.gd"
	"scripts/runs/rift_run_build.gd"
	"scripts/skills/acquired_supports.gd"
	"scripts/skills/skill_support_catalogue.gd"
	"scripts/skills/skill_tag_profile.gd"
	"scripts/skills/skill_tags.gd"
	"scripts/skills/support_definition.gd"
	"scripts/experience/rift_mote_runtime.gd"
	"scripts/experience/rift_experience_track.gd"
	"scripts/pickups/rift_mote_field.gd"
	"scripts/pickups/rift_mote_pickup_query.gd"
	"scripts/levels/rift_run_level_coordinator.gd"
	"scripts/levels/rift_run_level_up_result.gd"
	"scripts/levels/rift_level_up_coordinator.gd"
	"scripts/levels/rift_level_up_result.gd"
	"scripts/offers/rift_offer.gd"
	"scripts/roguelite/build_variety/roguelite_upgrade.gd"
	"scripts/roguelite/build_variety/roguelite_build_variety_runtime.gd"
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

# D-201's lesson: a run that reports PASS while a script error scrolled past is not a pass.
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

# Engine ERROR lines are refused outright, and every WARNING line must be one of the
# accepted bake's two known lines — printed, so the report can state them.
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
	fi
}

# `/tmp` is never cleared between runs, so a file from an earlier invocation must
# never answer for this one.
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

# The three-step read the project settled on.
read_check_count() {
	grep -ohE "$1: PASS \([0-9]+ checks\)" "$2" \
		| grep -ohE '[0-9]+ checks' | grep -ohE '[0-9]+' | head -1
}

run_verification() {
	local logfile="$1"
	shift
	perl -e 'alarm shift; exec @ARGV' "$VERIFICATION_TIMEOUT" "$GODOT" "$@" > "$logfile" 2>&1
}

printf 'Riftwrought — Roguelite I3: Live Level-Up Effect Application Review V1 smoke checks (D-295)\n'
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
step "1. Every new and every edited script parses"

for relative in "${PARSED_SCRIPTS[@]}"; do
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
step "2. The review names no asset or storage, inherits I2's accepted scene, and reads no other suite"

# The ASSET scan is RAW, comments included (D-215). The STORAGE scan is
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

# The seam writes nothing canonical: no `.tres` path and no resource saver, raw.
if grep -qE '\.tres|ResourceSaver' "$PROJECT_DIR/$SEAM" "$PROJECT_DIR/$RESULT"; then
	fail "the seam or its result names a .tres path or a resource saver"
else
	pass "the seam and its result name no .tres path and no resource saver, comments included"
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
	fail "the scene is not one inherited instance of I2's accepted scene"
fi

others="$(grep -oE 'res://tests/[A-Za-z0-9_./-]+' "$PROJECT_DIR/$THIS_VERIFICATION" | sort -u \
	| grep -vxF "res://$THIS_VERIFICATION" | tr '\n' ' ')"
if [[ -z "${others// /}" ]] && grep -qF "res://$THIS_VERIFICATION" "$PROJECT_DIR/$REVIEW"; then
	pass "the verification names no file under tests/ but its own, and the review starts it only on its own flag"
else
	fail "the verification names another test file: ${others:-none}"
fi

# The Zone Composer's own guards reach any new file under scripts/ or scenes/.
if grep -qE 'ZoneComposer|addons/riftwrought_zone_composer' "$PROJECT_DIR/$REVIEW" "$PROJECT_DIR/$SEAM" \
		"$PROJECT_DIR/$RESULT" "$scene_file"; then
	fail "a review file names the Zone Composer, which turns its closed suite red"
else
	pass "no review file names the Zone Composer"
fi

# --------------------------------------------------------------------------
step "3. An ordinary headless boot assembles the review and opens nothing in the Nexus"

boot_log="/tmp/riftwrought_live_effect_review_boot.log"
"$GODOT" --headless --path "$PROJECT_DIR" "$SCENE" --quit-after 240 > "$boot_log" 2>&1
boot_status=$?
printf '  boot exit status: %s\n' "$boot_status"
assert_log_is_fresh "$boot_log"
assert_no_script_error "an ordinary headless boot" "$boot_log"
if [[ "$boot_status" == "0" ]] && grep -q "isolated review assembled" "$boot_log" \
		&& grep -q "greybox review layer assembled on the accepted loop" "$boot_log" \
		&& grep -q "three-lane level-up choice layer assembled on the accepted experience review" "$boot_log" \
		&& grep -q "live level-up effect layer assembled on the accepted choice review" "$boot_log"; then
	pass "the accepted loop assembled, then H9's layer, then I2's, then this review's, and the boot exited 0"
else
	fail "the review did not report assembling on I2's accepted review (exit $boot_status)"
fi
if grep -qE "experience runtime .*opened|level-up offer .*opened|live effects +applied" "$boot_log"; then
	fail "a runtime, an offer or an application was opened in the Nexus"
else
	pass "no Experience Mote runtime, no level-up offer and no application in the Nexus"
fi

# --------------------------------------------------------------------------
step "4. The pinned verification passes, proved in BOTH directions"

verify_log="/tmp/riftwrought_live_effect_review_verify.log"
run_verification "$verify_log" --headless --path "$PROJECT_DIR" "$SCENE" -- --seed "$ROUTE_SEED" --verify-live-effects
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

count="$(read_check_count "ROGUELITE LIVE EFFECT REVIEW VERIFICATION" "$verify_log")"
if [[ "$count" == "$EXPECTED_CHECKS" ]]; then
	pass "verification passes at the pinned $EXPECTED_CHECKS checks"
else
	fail "verification reports ${count:-no} checks, not $EXPECTED_CHECKS"
fi

# A guard that accepts everything protects nothing: the pin must refuse a log whose
# count moved by one, and the negative direction must READ the moved number.
replay="$(mktemp -t riftwrought_live_effect_review_replay)"
scratch_replay="$replay"
sed "s/ROGUELITE LIVE EFFECT REVIEW VERIFICATION: PASS ($EXPECTED_CHECKS checks)/ROGUELITE LIVE EFFECT REVIEW VERIFICATION: PASS ($((EXPECTED_CHECKS + 1)) checks)/" \
	"$verify_log" > "$replay"
replay_count="$(read_check_count "ROGUELITE LIVE EFFECT REVIEW VERIFICATION" "$replay")"
if [[ -z "$count" ]]; then
	fail "the verification printed no count line, so the count pin proves nothing this run"
elif [[ "$replay_count" == "$((EXPECTED_CHECKS + 1))" && "$replay_count" != "$EXPECTED_CHECKS" ]]; then
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

# The measurements this review exists to make, read out of the run's own log rather
# than restated here. `--` before the pattern is D-244's lesson kept. Lines that follow
# a number which varies with the window or the frame timing are pinned only up to it.
while IFS= read -r line; do
	if grep -qF -- "$line" "$verify_log"; then
		pass "measured: ${line}"
	else
		fail "the verification log does not report: ${line}"
	fi
done <<'MEASURED'
inherited instance of roguelite_level_up_choice_review.tscn; the runtime extends roguelite_level_up_choice_review.gd; 5 overrides (_build_run_surfaces, _discard_mote_runtime, _maybe_start_verification, _refresh_receipt, choose_offered_lane), 4 calling the method they override
the seam and its result are RefCounted values with no signal; the live line sits between I2's level line and its note in H9's panel
the runtime names RiftBuildApplication, RiftBuildApplicationResult, RiftRunBuild, RogueliteExperienceReviewHud, RogueliteLevelUpChoiceReview, RogueliteLiveEffectReview
the seam names PlayerStatTotals, PlayerStatValue, PlayerStats, PrototypePlayer, QuickStrikeAction, QuickStrikeData, RiftBuildApplication, RiftBuildApplicationResult, RiftRunBuild, SkillSupportCatalogue
the result names PlayerStatTotals, PlayerStatValue, PlayerStats, PrototypePlayer, QuickStrikeData, RiftBuildApplication, RiftBuildApplicationResult
31 actions; the entrypoint is prototype_app.tscn; project.godot declares no [autoload] and names nothing of this review
canonical 0.80 s, reach 1.65 m, arc 100°, cone 65°, 1 target(s), marker 0.325; the live record is a private copy of it
a fresh I2 panel reads its accepted note; the panel adds exactly set_note_text, called only by roguelite_live_effect_review.gd; this scene states: Covered effects are applied immediately for this expedition. Final values and presentation are not locked.
movement 5.0 m/s, Skill Speed +0% (action time 0.8000 s), reach 1.65 m, arc 100°, cone 65°, 1 target(s)
70° at 1.2 m: miss — 70 deg is outside the 100 deg release arc; the direct query answers miss
45° at 3.0 m: the cone refused it (45.0 deg outside the 32.5 deg half-cone (65 deg total)); the real press swung untargeted: 'no eligible target in the 65 deg cone'
the offer holds [quick_strike, sweeping_edge | card_celerity | card_fleetness]; 15 of 15 visible panel controls on screen, smallest 12 px; the note reads: Covered effects are applied immediately for this expedition. Final values and presentation are not locked.
A Support by Enter: granted [quick_strike, sweeping_edge] from root seed 99; the same record as G4's; applied on physics frame
the input's own; receipt 'Support — Quick Strike → Sweeping Edge' / 'Live now — arc 100° → 180° · cone 65° → 110° · one target'
movement 5.0 m/s, Skill Speed +0% (action time 0.8000 s), reach 1.65 m, arc 180°, cone 110°, 1 target(s)
applied from the run's build: quick_strike; skill speed +0% -> 0.800000000 s; movement +0% -> 5.000 m/s; global damage +0% -> 100.000 from 100.000; maximum life +0% -> 500.000 from 500.000; life 500.000/500.000 -> 500.000/500.000; reach 1.65 m, arc 180 deg, cone 110 deg, 1 target(s); supports [quick_strike -> sweeping_edge rank 1]; run path []; deferred []; committed
H8 holds _run, _field, _bindings; run_build() is 'return _run.run_build()'; two readings are two objects reading 'quick_strike -> sweeping_edge; no passive cards acquired; no modifiers', equal to the directly driven G4 run's
a card added to one copy left the run's next copy and the character unchanged
70° at 1.2 m: the live record's query hit, the canonical record's miss; the real swing hit it once — Life 300 -> 200
45° at 3.0 m: the live cone chose it (approach), the canonical cone refused it; the real press began its approach: 'approach: 45 deg off intent, 3.00 m away'
maximum targets 1; Quick Strike's tags Attack, Hit, Melee, Strike, Physical — no Area
Temporary build — this expedition | Support — Quick Strike → Sweeping Edge | a new compatible pair, rank 0 -> 1 | Rift level 1 → 2 · 0 XP carried over | Applied to the character now; every value returns to its baseline when this expedition ends. | Live now — arc 100° → 180° · cone 65° → 110° · one target; smallest 12 px; inside the review panel, clear of
while Fallen: arc 180°, cone 110° still standing; after the return to the Nexus: movement 5.0 m/s, Skill Speed +0% (action time 0.8000 s), reach 1.65 m, arc 100°, cone 65°, 1 target(s)
B Combat and Defence by (A): granted [card_celerity] from root seed 99; the same record as G4's; applied on physics frame
the input's own; receipt 'Combat and Defence — Celerity (+10% Skill Speed)' / 'Live now — action time 0.80 s → 0.727 s'
C1: 0.80 s at +10% = 0.727272727 s; the kernel's effective action time 0.727272727 s — the same number
one real press: released at tick 15 and finished at tick 44 (0.7333 s) against the baseline's 16 and 49 (0.8167 s); 1 query and 1 release each; the pose at release 0.3250
8 ticks in, the rig stood at 0.18333 (baseline 0.16667); a held press released every 0.7250 s over 4 repeats (baseline 0.8000 s), 5 queries for 5 releases
applied twice more from the run's own build: identical to the choice, 0 speed-change signals; +10% is still 0.727272727 s, never compounded
the canonical record still reads 0.80 s, reach 1.65 m, arc 100°, cone 65°, 1 target(s), marker 0.325
movement 5.0 m/s, Skill Speed +10% (action time 0.7273 s), reach 1.65 m, arc 100°, cone 65°, 1 target(s) -> movement 5.0 m/s, Skill Speed +0% (action time 0.8000 s), reach 1.65 m, arc 100°, cone 65°, 1 target(s)
C Utility by left click: granted [card_fleetness] from root seed 99; the same record as G4's; applied on physics frame
the input's own; receipt 'Utility — Fleetness (+10% Movement Speed)' / 'Live now — movement speed 5.0 m/s → 5.5 m/s'
C1: 5.0 m/s at +10% = 5.500000 m/s; the live speed 5.500000 m/s — the same number; acceleration, braking and arrival unchanged
a real 8.0 m walk: top 5.500 m/s and 5.500 m/s over a 12-tick plateau, against 5.000 and 5.000 m/s before the choice
behind the run summary: movement 5.0 m/s, Skill Speed +0% (action time 0.8000 s), reach 1.65 m, arc 100°, cone 65°, 1 target(s); the summary closed onto the Nexus at every baseline
staged in the Nexus: movement 5.5 m/s, Skill Speed +10% (action time 0.7273 s), reach 2.65 m, arc 100°, cone 65°, 1 target(s); the Rift Gate began expedition D at: movement 5.0 m/s, Skill Speed +0% (action time 0.8000 s), reach 1.65 m, arc 100°, cone 65°, 1 target(s)
movement 5.0 m/s, Skill Speed +0% (action time 0.8000 s), reach 2.65 m, arc 100°, cone 65°, 1 target(s)
a real controller approach to a Graveblade 4.0 m ahead stopped 1.542 m from it before (reach 1.65 m less the 0.10 m margin) and 2.542 m after (2.65 m less 0.10 m); both releases hit
2.3 m ahead: the live record's query hit, the canonical record's miss — '2.30 m is beyond the 1.65 m reach'
2 legal targets at +70° 1.2 m and -70° 1.4 m: 1 release, 1 damage event, the nearer 300 -> 200, the other untouched at 300
Celerity x2 + Fleetness + Quick Strike -> Sweeping Edge: +20% -> 0.666666667 s (C1 0.666666667 s; the newest card alone would be 0.727272727 s), 5.5 m/s, arc 180°, cone 110°
a derivation of another build answered reach 2.65 m and wrote nothing; the review's application reads mote_runtime.run_build() once and no receipt, record or lane
Experience Gain +10% — applied by the run's own mote path | Pickup Radius +25% — applied by the run's own mote path; every covered value at its baseline
the seam calls value_of() four times (Global Damage, Skill Speed, Maximum Life, Movement Speed) and names the two mote-path stats once each, in a list; it names no experience track, pickup query, award or sweep
damage 100 → 110 | Maximum Life 500 → 575 · Life preserved at 100% | Experience Gain +10% — applied by the run's own mote path; weapon damage 100 raw and 110 outgoing — C1's answer — maximum Life 500 -> 575 and Life 500 -> 575, its fraction kept
the receipt for a held-only build: 'Held, not live on the character: / Experience Gain +10% — applied by the run's own mote path'; beside the written values: 'Live now — damage 100 → 110 / Maximum Life 500 → 575 · Life preserved at 100% / Held, not live on the character: / Experience Gain +10% — applied by the run's own mote path'
an unsupported rank: 'sweeping_edge on quick_strike is held at rank 3, and the catalogue holds reviewed values only for ranks 1 and 2; nothing was applied'
a pair on an unequipped Skill: 'the build holds 1 Skill/support pair(s), and only 0 belong to quick_strike, the one Skill the player equips; nothing was applied'
a live record that is the canonical record: 'Quick Strike's live record is its canonical record rather than a private runtime copy; writing it would write the canonical record, so nothing was applied'
8 of 8 refused with nothing committed; every live value and the canonical record unchanged; 0 speed-change signals; the catalogue answers nothing for ranks 0 and 3
movement 5.0 m/s, Skill Speed +10% (action time 0.7273 s), reach 1.65 m, arc 180°, cone 110°, 1 target(s) -> movement 5.0 m/s, Skill Speed +0% (action time 0.8000 s), reach 1.65 m, arc 100°, cone 65°, 1 target(s), with the review holding no application and the run's build empty
4 expeditions ended (A by death, B by F5, C by completion, D by F5), each at every baseline
the seam writes only candidate.resource_path, candidate.reach, candidate.release_arc_degrees, candidate.soft_target_cone_degrees, live.reach, live.release_arc_degrees, live.soft_target_cone_degrees, player.max_speed, result.committed, and set_increased_attack_speed() once, all outside derive(); 0 of 42 forbidden tokens
the review runtime: 0 of 28 restated tokens; the seam called twice, the build read once, one empty build made; 0 of 25 concrete tokens in it or its scene; 0 storage and 0 asset tokens in the four shipping files
4 expeditions walked (3 given seed 99 again by staging), 15 Graveblade deaths driven, 11 real Quick Strike presses measured, 10 builds staged through the seam, 3 applications and 8 restorations made by the review
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
if grep -qiE "live_effect|RogueliteLiveEffect|RiftBuildApplication" "$project_godot"; then
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
		shots_log="/tmp/riftwrought_live_effect_review_shots_$resolution.log"
		run_verification "$shots_log" --path "$PROJECT_DIR" --resolution "$resolution" "$SCENE" \
			-- --seed "$ROUTE_SEED" --verify-live-effects --shots "$target"
		shots_status=$?
		printf '  %s verification exit status: %s\n' "$resolution" "$shots_status"
		assert_log_is_fresh "$shots_log"
		assert_no_script_error "the $resolution rendered run" "$shots_log"
		assert_engine_output "the $resolution rendered run" "$shots_log"
		rendered_count="$(read_check_count "ROGUELITE LIVE EFFECT REVIEW VERIFICATION" "$shots_log")"
		if [[ "$shots_status" == "0" && "$rendered_count" == "$EXPECTED_CHECKS" ]]; then
			pass "the $resolution rendered run exits 0 at the same pinned $EXPECTED_CHECKS checks"
		else
			fail "the $resolution rendered run exits $shots_status at ${rendered_count:-no} checks, not $EXPECTED_CHECKS"
			grep -E "^  FAIL" "$shots_log" | head -10 | sed 's/^/        /'
		fi
		if grep -qF "visible panel controls on screen, smallest 12 px; the note reads: Covered effects are applied immediately" "$shots_log" \
				&& grep -qF "inside the review panel, clear of" "$shots_log"; then
			pass "at $resolution the panel's controls and the live receipt are on screen, apart and unobstructed"
		else
			fail "at $resolution the panel's or the receipt's on-screen measurement is missing or different"
		fi
		shots=0
		for stem in 01_sweeping_edge_live 02_celerity_live 03_fleetness_live; do
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
	printf 'ROGUELITE LIVE EFFECT REVIEW SMOKE CHECKS: PASS\n'
	printf '  %s checks; %s of %s owed; %s protected files byte-identical\n' \
		"$EXPECTED_CHECKS" "$EXPECTED_OWED_CHECKS" "$EXPECTED_OWED_CHECKS" "${#PRESERVED_FILES[@]}"
	printf '  Roguelite I3 — Live Level-Up Effect Application Review V1 is DELIVERED under\n'
	printf '  D-295 and ACCEPTED and CLOSED at the first-live temporary-build\n'
	printf '  effect-application review level under D-297.\n'
	reached_end=1
	exit 0
else
	printf 'ROGUELITE LIVE EFFECT REVIEW SMOKE CHECKS: %d FAILURE(S)\n' "$failures"
	reached_end=1
	exit 1
fi
