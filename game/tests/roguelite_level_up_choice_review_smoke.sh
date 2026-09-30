#!/usr/bin/env bash
# Riftwrought — Roguelite I2: Playable Three-Lane Level-Up Choice Review V1 smoke
# checks (decision D-293).
#
# THIS IS NOT A GATE, AND IT RUNS NO LOCKED CHAIN.
#
# The review is one ISOLATED playable instrument: a scene that INHERITS the accepted
# Experience Collection Review scene (H9), a runtime that EXTENDS H9's runtime and
# adds exactly one three-card level-up panel on the accepted `FirstMvpModal` contract
# and one receipt section in H9's review panel, and this suite. It edits no accepted
# production file, adds no asset, adds no InputMap action, writes nothing to disk,
# and is not the project entrypoint. What this script proves is what the review CAN
# break:
#
#   1. every new script parses;
#   2. the review's shipping files name no asset, shader, particle, sound or storage,
#      the scene is one inherited instance of H9's accepted scene, and the
#      verification reads no other suite;
#   3. an ordinary headless boot assembles the review with zero SCRIPT ERROR and opens
#      no runtime, offer or panel in the Nexus;
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
#   8. every file this review could conceivably disturb — H9's production files, its
#      suite and its six accepted evidence frames, H8, G4, E2, D1, D2, D3, G1, G2, E1,
#      H1–H7, both catalogues and the three record types, the accepted core loop, the
#      Graveblade and its records, the combat kernel, the modal contract, the project
#      owner's composed zone and loading teaser with its import record and imported
#      cache, `project.godot`, `CLAUDE.md` and `README.md` — is BYTE-IDENTICAL across
#      the run, and the project owner's own user:// files are untouched.
#
# Usage, from the repository root:
#   game/tests/roguelite_level_up_choice_review_smoke.sh
#   game/tests/roguelite_level_up_choice_review_smoke.sh --shots docs/testing/roguelite_level_up_choice_review_evidence

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
		printf '\nROGUELITE LEVEL-UP CHOICE REVIEW SMOKE CHECKS: ABORTED before the end of the script\n'
		printf '  the run stopped early (exit %s) — nothing after that point was proved\n' "$code"
		exit 1
	fi
	exit "$code"
}
trap on_exit EXIT

GODOT="${GODOT:-/Applications/Godot.app/Contents/MacOS/Godot}"
EXPECTED_VERSION="4.7.2.stable"
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

SCENE="res://scenes/roguelite/roguelite_level_up_choice_review.tscn"
ACCEPTED_SCENE="res://scenes/roguelite/roguelite_experience_collection_review.tscn"
ROUTE_SEED=99

# Pinned, and proved in both directions below. ONE number: the rendered evidence
# frames add no assertion, so the headless and both rendered runs must agree. It is
# the count of the delivered suite's first green run, whose 23 owed check functions
# are itemised in D-293.
EXPECTED_CHECKS=174
EXPECTED_OWED_CHECKS=23

# Seconds a verification may take before it is killed and counted as a failure.
VERIFICATION_TIMEOUT=600

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

REVIEW="scripts/roguelite/level_up/roguelite_level_up_choice_review.gd"
PANEL="scripts/roguelite/level_up/rift_level_up_offer_panel.gd"
REVIEW_SCENE="scenes/roguelite/roguelite_level_up_choice_review.tscn"
THIS_VERIFICATION="tests/roguelite_level_up_choice_review_verification.gd"

NEW_SCRIPTS=(
	"$REVIEW"
	"$PANEL"
	"$THIS_VERIFICATION"
)

SHIPPING_FILES=(
	"$REVIEW"
	"$PANEL"
	"$REVIEW_SCENE"
)

# DELIBERATELY SHORT, AND NOT A WHOLE-PROJECT CATALOGUE: the files this review
# inherits, composes, asks or stands beside, and the project owner's own work.
PRESERVED_FILES=(
	"project.godot"
	"scenes/first_mvp/zone_composer_practice.tscn"
	"assets/prototype/ui/loading/riftwrought-loading-teaser-v1.png"
	"assets/prototype/ui/loading/riftwrought-loading-teaser-v1.png.import"
	".godot/imported/riftwrought-loading-teaser-v1.png-b052aa6f935e93824cd8ff133a3ff6f4.ctex"
	".godot/imported/riftwrought-loading-teaser-v1.png-b052aa6f935e93824cd8ff133a3ff6f4.md5"
	"../CLAUDE.md"
	"../README.md"
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
	"scripts/actors/prototype_graveblade.gd"
	"scenes/actors/prototype_graveblade.tscn"
	"scripts/combat/quick_strike_action.gd"
	"scripts/combat/quick_strike_data.gd"
	"data/prototype_zero/quick_strike.tres"
	"data/prototype_zero/graveblade.tres"
	"data/roguelite/graveblade_elite.tres"
	"data/roguelite/worn_blade.tres"
	"scripts/experience/rift_mote_runtime.gd"
	"scripts/experience/rift_graveblade_mote_binding.gd"
	"scripts/experience/rift_enemy_mote_emission.gd"
	"scripts/experience/rift_experience_mote.gd"
	"scripts/experience/rift_experience_track.gd"
	"scripts/experience/rift_experience_reading.gd"
	"scripts/pickups/rift_mote_field.gd"
	"scripts/pickups/rift_mote_sweep_result.gd"
	"scripts/pickups/rift_mote_drop.gd"
	"scripts/levels/rift_run_level_coordinator.gd"
	"scripts/levels/rift_run_level_up_result.gd"
	"scripts/levels/rift_level_up_coordinator.gd"
	"scripts/levels/rift_level_up_result.gd"
	"scripts/level_requirements/rift_level_requirement_curve.gd"
	"scripts/level_seeds/rift_level_offer_seed_derivation.gd"
	"scripts/offers/rift_offer.gd"
	"scripts/offers/rift_offer_composition.gd"
	"scripts/choices/rift_offer_choice.gd"
	"scripts/choices/rift_offer_choice_result.gd"
	"scripts/runs/rift_run_build.gd"
	"scripts/skills/skill_support_catalogue.gd"
	"scripts/skills/skill_tag_profile.gd"
	"scripts/skills/support_definition.gd"
	"scripts/stats/passive_card_catalogue.gd"
	"scripts/stats/passive_card_definition.gd"
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

printf 'Riftwrought — Roguelite I2: Playable Three-Lane Level-Up Choice Review V1 smoke checks (D-293)\n'
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
step "2. The review names no asset or storage, inherits H9's accepted scene, and reads no other suite"

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
	fail "the scene is not one inherited instance of H9's accepted scene"
fi

others="$(grep -oE 'res://tests/[A-Za-z0-9_./-]+' "$PROJECT_DIR/$THIS_VERIFICATION" | sort -u \
	| grep -vxF "res://$THIS_VERIFICATION" | tr '\n' ' ')"
if [[ -z "${others// /}" ]] && grep -qF "res://$THIS_VERIFICATION" "$PROJECT_DIR/$REVIEW"; then
	pass "the verification names no file under tests/ but its own, and the review starts it only on its own flag"
else
	fail "the verification names another test file: ${others:-none}"
fi

# The Zone Composer's own guards reach any new file under scripts/ or scenes/.
if grep -qE 'ZoneComposer|addons/riftwrought_zone_composer' "$PROJECT_DIR/$REVIEW" "$PROJECT_DIR/$PANEL" "$scene_file"; then
	fail "a review file names the Zone Composer, which turns its closed suite red"
else
	pass "no review file names the Zone Composer"
fi

# --------------------------------------------------------------------------
step "3. An ordinary headless boot assembles the review and opens nothing in the Nexus"

boot_log="/tmp/riftwrought_level_up_choice_review_boot.log"
"$GODOT" --headless --path "$PROJECT_DIR" "$SCENE" --quit-after 240 > "$boot_log" 2>&1
boot_status=$?
printf '  boot exit status: %s\n' "$boot_status"
assert_log_is_fresh "$boot_log"
assert_no_script_error "an ordinary headless boot" "$boot_log"
if [[ "$boot_status" == "0" ]] && grep -q "isolated review assembled" "$boot_log" \
		&& grep -q "greybox review layer assembled on the accepted loop" "$boot_log" \
		&& grep -q "three-lane level-up choice layer assembled on the accepted experience review" "$boot_log"; then
	pass "the accepted loop assembled, then H9's layer, then this review's, and the boot exited 0"
else
	fail "the review did not report assembling on H9's accepted review (exit $boot_status)"
fi
if grep -qE "experience runtime .*opened|level-up offer .*opened" "$boot_log"; then
	fail "a runtime or an offer was opened in the Nexus"
else
	pass "no Experience Mote runtime and no level-up offer was opened in the Nexus"
fi

# --------------------------------------------------------------------------
step "4. The pinned verification passes, proved in BOTH directions"

verify_log="/tmp/riftwrought_level_up_choice_review_verify.log"
run_verification "$verify_log" --headless --path "$PROJECT_DIR" "$SCENE" -- --seed "$ROUTE_SEED" --verify-level-up
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

count="$(read_check_count "ROGUELITE LEVEL-UP CHOICE REVIEW VERIFICATION" "$verify_log")"
if [[ "$count" == "$EXPECTED_CHECKS" ]]; then
	pass "verification passes at the pinned $EXPECTED_CHECKS checks"
else
	fail "verification reports ${count:-no} checks, not $EXPECTED_CHECKS"
fi

# A guard that accepts everything protects nothing: the pin must refuse a log whose
# count moved by one, and the negative direction must READ the moved number.
replay="$(mktemp -t riftwrought_level_up_choice_review_replay)"
scratch_replay="$replay"
sed "s/ROGUELITE LEVEL-UP CHOICE REVIEW VERIFICATION: PASS ($EXPECTED_CHECKS checks)/ROGUELITE LEVEL-UP CHOICE REVIEW VERIFICATION: PASS ($((EXPECTED_CHECKS + 1)) checks)/" \
	"$verify_log" > "$replay"
replay_count="$(read_check_count "ROGUELITE LEVEL-UP CHOICE REVIEW VERIFICATION" "$replay")"
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
# than restated here. `--` before the pattern is D-244's lesson kept. Lines that
# follow a number which varies with the window or the frame timing — a rectangle, a
# click position, how far a pursuing Graveblade had walked, the sweep count — are
# pinned only from after it.
while IFS= read -r line; do
	if grep -qF -- "$line" "$verify_log"; then
		pass "measured: ${line}"
	else
		fail "the verification log does not report: ${line}"
	fi
done <<'MEASURED'
inherited instance of roguelite_experience_collection_review.tscn; the runtime extends roguelite_experience_collection_review.gd and the panel first_mvp_modal.gd; 6 overrides (_any_modal_open, _build_run_surfaces, _discard_mote_runtime, _maybe_start_verification, _physics_process, experience_review_reading), 5 calling the method they override
the runtime names PassiveCardCatalogue, PassiveCardDefinition, RiftLevelUpOfferPanel, RiftLevelUpResult, RiftOffer, RiftRunLevelUpResult, RogueliteExperienceCollectionReview, RogueliteExperienceReviewHud, RogueliteLevelUpChoiceReview, SkillSupportCatalogue, SkillTagProfile, SupportDefinition; the panel names BrokenWatchSlice, FirstMvpModal, RiftLevelUpOfferPanel, RogueliteLevelUpChoiceReview
the panel is drawn over 6 of 6 surfaces — the combat HUD, the run banner, H9's panel and the 3 accepted modals — and is followed only by GroundNameplate
31 actions; the entrypoint is prototype_app.tscn; project.godot declares no [autoload] and names nothing of this review
no runtime, 0 opening(s) asked, panel closed, not paused, 0 receipt lines shown; the panel reads 'Next run seed 00000063'
experience 25.0 -> 50.0 -> 75.0 through real motes; at each step 0 opening(s) asked, no panel, not paused, level 1, no offer
the collecting sweep took [3]: experience 100.0 = G1's Level 1 requirement; 1 opening asked; the panel opened on its own; paused; level 1; frozen requirement 100.0; root seed 99 (G2: 99)
H9's 'LEVEL-UP READY' lines withheld; the receipt reads 'Level-up offer open — choose one of the three cards.'
lanes [0, 1, 2] = D1's [0, 1, 2]; Support: Sweeping Edge — Applies to Quick Strike; Combat and Defence: Celerity — +10% Skill Speed; Utility: Fleetness — +10% Movement Speed
3 of 3 identities equal the directly driven G4 run's; 0 lines show a rank before choosing; the note reads: Choices are recorded in this expedition's temporary build. Applying their effects to the playable character is not part of this review.
Support: sweeping_edge -> Sweeping Edge, applied to quick_strike -> Quick Strike; card_celerity -> Celerity / +10% Skill Speed; card_fleetness -> Fleetness / +10% Movement Speed
0 of 25 concrete ids, names or effect words in the runtime, the panel or the scene; the opening and each catalogue set named exactly once
3 buttons bound as panel._on_card_pressed[0], panel._on_card_pressed[1], panel._on_card_pressed[2]; a press hands _lanes[slot] to choose_offered_lane(), which hands that lane to choose_level_up_lane()
30 physics and 10 idle frames: 0 sweeps, the player, the escort (alive, AI on, state
focus on Choose1; the pointer reached cards 2 and 3 in turn; 0 choices, focus still on card 1, the offer standing
8 inputs: the panel still open over the same offer, paused, 0 choices, 0 closes; pickup, grid, camera 19.0 m, expedition, attack and movement all unchanged
15 of 15 visible text controls on screen, smallest 12 px; 3 cards, 0 overlapping, each at least 320 px wide; the backdrop covers the viewport and nothing visible draws above the panel
lane 7: 'lane 7 is not one of the offer's lanes (Support 2996865621, Combat and Defence 1818840148, Utility 1107088162)'; shown word for word; the same offer (root 99 0:[quick_strike, sweeping_edge] 1:[card_celerity] 2:[card_fleetness]) still open, paused, level 1, 100.0
A Support by Enter: granted [quick_strike, sweeping_edge] from root seed 99 — a new compatible pair, rank 0 -> 1; level 1 -> 2 with 0.0 retained; the same record as G4's; taken again: 'no offer is open; one must be opened before a lane may be taken'; receipt 'Support — Quick Strike → Sweeping Edge'
Temporary build — this expedition | Support — Quick Strike → Sweeping Edge | a new compatible pair, rank 0 -> 1 | Rift level 1 → 2 · 0 XP carried over | Recorded in the temporary build; not applied to the character in this review.; smallest 12 px; inside the review panel, clear of 15 other surfaces and the centre; not paused, neutral, 'XP 25 / 125'
the player placed 0.00 m from the escort's pending mote; 40 frames: 0 sweeps, still 1 uncollected, experience 100.0, its marker shown
B Combat and Defence by (A): granted [card_celerity] from root seed 99 — no support progression; level 1 -> 2 with 0.0 retained; the same record as G4's; taken again: 'no offer is open; one must be opened before a lane may be taken'; receipt 'Combat and Defence — Celerity (+10% Skill Speed)'
the first sweep after the choice collected [4] and paid 25.0 into Level 2
C Utility by left click: granted [card_fleetness] from root seed 99 — no support progression; level 1 -> 2 with 0.0 retained; the same record as G4's; taken again: 'no offer is open; one must be opened before a lane may be taken'; receipt 'Utility — Fleetness (+10% Movement Speed)'
reached card 3's own button; walking to the escort's mote then paid 25.0 into Level 2
D Support from 125: granted [quick_strike, sweeping_edge] from root seed 99 — a new compatible pair, rank 0 -> 1; level 1 -> 2 with 25.0 retained; the same record as G4's; taken again: 'no offer is open; one must be opened before a lane may be taken'; receipt 'Support — Quick Strike → Sweeping Edge'
E Combat and Defence from 125: granted [card_celerity] from root seed 99 — no support progression; level 1 -> 2 with 25.0 retained; the same record as G4's; taken again: 'no offer is open; one must be opened before a lane may be taken'; receipt 'Combat and Defence — Celerity (+10% Skill Speed)'
F Utility from 125: granted [card_fleetness] from root seed 99 — no support progression; level 1 -> 2 with 25.0 retained; the same record as G4's; taken again: 'no offer is open; one must be opened before a lane may be taken'; receipt 'Utility — Fleetness (+10% Movement Speed)'
3 of 3 lanes chosen from 125 left Level 2 with 25 retained, 'Rift level 1 → 2 · 25 XP carried over', and opened nothing more
1 opening asked and refused with 'level 1 already has an offer open; only a lane of that offer may be taken'; shown as 'Last refusal: level-up offer did not open — level 1 already has an offer open; only a lane of that offer may be taken'; 70 frames later still 1, no panel, not paused
max speed 5.0 m/s, action time 0.80 s (effective 0.80 s), reach 1.65 m, arc 100 deg, cone 65 deg, +0% attack speed — identical after all 6 choices
measured top walking speed before any choice and after Support, Combat and Defence and Utility: 5.000, 5.000, 5.000, 5.000 m/s
7 of 7 expeditions (A, B, C, D, E, F, G) ended by F5 with no attempt, record or receipt left, the panel closed and the world running
0 of 27 restated tokens in the runtime; the panel reaches the runtime once and pauses nothing itself; 0 storage and 0 asset tokens in the runtime, the panel and the scene
7 expeditions walked (6 given seed 99 again by staging), 34 Graveblade deaths driven,
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
if grep -qiE "level_up_choice|RogueliteLevelUp|RiftLevelUpOfferPanel" "$project_godot"; then
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
		shots_log="/tmp/riftwrought_level_up_choice_review_shots_$resolution.log"
		run_verification "$shots_log" --path "$PROJECT_DIR" --resolution "$resolution" "$SCENE" \
			-- --seed "$ROUTE_SEED" --verify-level-up --shots "$target"
		shots_status=$?
		printf '  %s verification exit status: %s\n' "$resolution" "$shots_status"
		assert_log_is_fresh "$shots_log"
		assert_no_script_error "the $resolution rendered run" "$shots_log"
		assert_engine_output "the $resolution rendered run" "$shots_log"
		rendered_count="$(read_check_count "ROGUELITE LEVEL-UP CHOICE REVIEW VERIFICATION" "$shots_log")"
		if [[ "$shots_status" == "0" && "$rendered_count" == "$EXPECTED_CHECKS" ]]; then
			pass "the $resolution rendered run exits 0 at the same pinned $EXPECTED_CHECKS checks"
		else
			fail "the $resolution rendered run exits $shots_status at ${rendered_count:-no} checks, not $EXPECTED_CHECKS"
			grep -E "^  FAIL" "$shots_log" | head -10 | sed 's/^/        /'
		fi
		if grep -qF "15 of 15 visible text controls on screen, smallest 12 px; 3 cards, 0 overlapping" "$shots_log" \
				&& grep -qF "inside the review panel, clear of 15 other surfaces and the centre" "$shots_log"; then
			pass "at $resolution the panel's 15 controls and the receipt are on screen, apart and unobstructed"
		else
			fail "at $resolution the panel's or the receipt's on-screen measurement is missing or different"
		fi
		shots=0
		for stem in 01_three_card_offer 02_support_receipt 03_passive_receipt; do
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
	printf 'ROGUELITE LEVEL-UP CHOICE REVIEW SMOKE CHECKS: PASS\n'
	printf '  %s checks; %s of %s owed; %s protected files byte-identical\n' \
		"$EXPECTED_CHECKS" "$EXPECTED_OWED_CHECKS" "$EXPECTED_OWED_CHECKS" "${#PRESERVED_FILES[@]}"
	printf '  Roguelite I2 — Playable Three-Lane Level-Up Choice Review V1 is DELIVERED under\n'
	printf '  D-293 and ACCEPTED and CLOSED at the playable greybox three-lane\n'
	printf '  level-up-choice review level under D-294.\n'
	reached_end=1
	exit 0
else
	printf 'ROGUELITE LEVEL-UP CHOICE REVIEW SMOKE CHECKS: %d FAILURE(S)\n' "$failures"
	reached_end=1
	exit 1
fi
