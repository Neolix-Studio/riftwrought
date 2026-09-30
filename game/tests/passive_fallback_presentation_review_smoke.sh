#!/usr/bin/env bash
# Riftwrought — Roguelite I10: Three-Card Passive-Fallback Presentation Review smoke
# checks (decision D-312).
#
# THIS IS NOT A GATE, AND IT RUNS NO LOCKED CHAIN.
#
# I10 OWNS NO SCENE. Its verification is a SceneTree script that loads the accepted I2
# scene, `roguelite_level_up_choice_review.tscn`, exactly as it ships, prepares a valid
# later-run state through accepted public operations only — four explicit Support
# level-ups through the review's own panel — and then shows the Level 5 passive-fallback
# offer through that same panel, choice path and receipt. The playable scene still opens
# only its one Level-1 offer on its own. What this script proves:
#
#   1. the new verification and every changed production script parse;
#   2. the accepted I2 scene, and the accepted I2, I3 and H9 evidence frames, are
#      byte-identical to their accepted hashes; nothing that runs names the harness; the
#      verification names no file under tests/ but its own;
#   3. the pinned verification passes, proved in BOTH directions against a replay of its
#      own log, with every owed check reaching its last line, the measured lines read out
#      of that log, zero SCRIPT ERROR and zero engine ERROR, and no engine WARNING but the
#      accepted core loop's own two navigation-bake precision warnings — and a run that
#      hangs is killed and FAILS;
#   4. `project.godot` is untouched: 31 actions, the Prototype App entrypoint, the same
#      nine sections, no `[autoload]`, nothing naming this review;
#   5. the third-party inventory has not moved (185 + 2 = 187);
#   6. optionally (`--shots <dir>`), rendered evidence at 1920x1080 and at the 1280x720
#      minimum tested window, each run passing at the SAME pinned count, because the
#      evidence frames add no assertion;
#   7. the whole of game/ outside .godot/, .godot/ itself, every protected file outside
#      game/ and the project owner's own user:// files are byte-identical across the run.
#
# Usage, from the repository root:
#   game/tests/passive_fallback_presentation_review_smoke.sh
#   game/tests/passive_fallback_presentation_review_smoke.sh --shots docs/testing/roguelite_passive_fallback_presentation_review_evidence

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
		printf '\nROGUELITE PASSIVE-FALLBACK PRESENTATION REVIEW SMOKE CHECKS: ABORTED before the end of the script\n'
		printf '  the run stopped early (exit %s) — nothing after that point was proved\n' "$code"
		exit 1
	fi
	exit "$code"
}
trap on_exit EXIT

GODOT="${GODOT:-/Applications/Godot.app/Contents/MacOS/Godot}"
EXPECTED_VERSION="4.7.2.stable"
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ROUTE_SEED=99

# Pinned, and proved in both directions below. ONE number: the rendered evidence frames
# add no assertion, so the headless and both rendered runs must agree.
EXPECTED_CHECKS=57
EXPECTED_OWED_CHECKS=22

# Seconds a verification may take before it is killed and counted as a failure.
VERIFICATION_TIMEOUT=600

EXPECTED_INPUT_ACTIONS=31
EXPECTED_MAIN_SCENE="res://scenes/app/prototype_app.tscn"
EXPECTED_SECTIONS="application audio debug display editor_plugins input layer_names navigation rendering"

# The review extracts nothing. D-216's authorized numbers, unmoved.
EXPECTED_THIRD_PARTY_PAYLOADS=185
EXPECTED_THIRD_PARTY=187

# The only engine warnings the verification may print: the accepted core loop's own
# navigation bake rounding its agent values to the voxel grid (accepted under D-290).
KNOWN_WARNINGS=(
	"WARNING: Property agent_max_climb is floored to cell_height voxel units and loses precision."
	"WARNING: Property agent_radius is ceiled to cell_size voxel units and loses precision."
)

THIS_VERIFICATION="tests/passive_fallback_presentation_review_verification.gd"
THIS_RUNNER="tests/passive_fallback_presentation_review_smoke.sh"

# The new verification, and every production script Roguelite I10 changed.
PARSED_SCRIPTS=(
	"$THIS_VERIFICATION"
	"scripts/levels/rift_level_up_coordinator.gd"
	"scripts/levels/rift_run_level_coordinator.gd"
	"scripts/experience/rift_mote_runtime.gd"
	"scripts/roguelite/level_up/roguelite_level_up_choice_review.gd"
)

# The accepted scene this review drives, and every accepted evidence frame it must not
# regenerate, each by the SHA-256 prefix its acceptance recorded (D-293, D-295, D-290).
ACCEPTED_PREFIXES=(
	"scenes/roguelite/roguelite_level_up_choice_review.tscn|7038bce6"
	"../docs/testing/roguelite_level_up_choice_review_evidence/01_three_card_offer.png|5567fa79"
	"../docs/testing/roguelite_level_up_choice_review_evidence/02_support_receipt.png|d4ad49f6"
	"../docs/testing/roguelite_level_up_choice_review_evidence/03_passive_receipt.png|6168883e"
	"../docs/testing/roguelite_level_up_choice_review_evidence/1280x720/01_three_card_offer.png|32bce080"
	"../docs/testing/roguelite_level_up_choice_review_evidence/1280x720/02_support_receipt.png|912bbc23"
	"../docs/testing/roguelite_level_up_choice_review_evidence/1280x720/03_passive_receipt.png|5bcedc2b"
	"../docs/testing/roguelite_live_effect_review_evidence/01_sweeping_edge_live.png|73ccb8ec"
	"../docs/testing/roguelite_live_effect_review_evidence/02_celerity_live.png|c23cf8ed"
	"../docs/testing/roguelite_live_effect_review_evidence/03_fleetness_live.png|f844767c"
	"../docs/testing/roguelite_live_effect_review_evidence/1280x720/01_sweeping_edge_live.png|5b112d8c"
	"../docs/testing/roguelite_live_effect_review_evidence/1280x720/02_celerity_live.png|82d4bbe8"
	"../docs/testing/roguelite_live_effect_review_evidence/1280x720/03_fleetness_live.png|5207c56c"
	"../docs/testing/roguelite_experience_collection_review_evidence/01_uncollected_mote_pickup_off.png|39b83295"
	"../docs/testing/roguelite_experience_collection_review_evidence/02_level_up_ready.png|6281a25a"
	"../docs/testing/roguelite_experience_collection_review_evidence/03_fresh_second_run.png|cc6c6f7f"
	"../docs/testing/roguelite_experience_collection_review_evidence/1280x720/01_uncollected_mote_pickup_off.png|63909c92"
	"../docs/testing/roguelite_experience_collection_review_evidence/1280x720/02_level_up_ready.png|77ff0426"
	"../docs/testing/roguelite_experience_collection_review_evidence/1280x720/03_fresh_second_run.png|7134269a"
)

# Protected outside game/, where the whole-tree fingerprint below does not reach.
PRESERVED_FILES=(
	"../CLAUDE.md"
	"../README.md"
)
for row in "${ACCEPTED_PREFIXES[@]}"; do
	PRESERVED_FILES+=("${row%%|*}")
done

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

# Every file under game/ outside .godot/, and .godot/ on its own, each as one digest.
tree_fingerprint() {
	(cd "$PROJECT_DIR" && find . -path ./.godot -prune -o -type f -print0 | LC_ALL=C sort -z \
		| xargs -0 shasum -a 256) | shasum -a 256 | cut -d' ' -f1
}
cache_fingerprint() {
	(cd "$PROJECT_DIR" && find .godot -type f -print0 | LC_ALL=C sort -z | xargs -0 shasum -a 256) \
		| shasum -a 256 | cut -d' ' -f1
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
# accepted bake's two known lines.
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

# `/tmp` is never cleared between runs, so a file from an earlier invocation must never
# answer for this one.
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

printf 'Riftwrought — Roguelite I10: Three-Card Passive-Fallback Presentation Review smoke checks (D-312)\n'
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

tree_before="$(tree_fingerprint)"
cache_before="$(cache_fingerprint)"
tree_files="$(cd "$PROJECT_DIR" && find . -path ./.godot -prune -o -type f -print | wc -l | tr -d ' ')"
cache_files="$(cd "$PROJECT_DIR" && find .godot -type f | wc -l | tr -d ' ')"
pass "game/ fingerprinted whole: $tree_files file(s) outside .godot/, and $cache_files under .godot/"

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
	pass "${#PRESERVED_FILES[@]} protected file(s) outside game/ fingerprinted"
fi

project_name="$(sed -n 's/^config\/name="\(.*\)"[[:space:]]*$/\1/p' "$PROJECT_DIR/project.godot" | head -1)"
production_dir="$HOME/Library/Application Support/Godot/app_userdata/$project_name"
settings_before="$(state_fingerprint "$production_dir/prototype_settings.cfg")"
lab_before="$(state_fingerprint "$production_dir/prototype_zero.cfg")"
character_before="$(state_fingerprint "$production_dir/riftwrought_character.cfg")"
pass "the project owner's own three user:// files fingerprinted"

# --------------------------------------------------------------------------
step "1. The new verification and every changed production script parse"

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
step "2. The accepted scene and evidence frames are the accepted ones; nothing that runs names the harness"

mismatched=0
for row in "${ACCEPTED_PREFIXES[@]}"; do
	relative="${row%%|*}"
	prefix="${row##*|}"
	digest="$(fingerprint "$PROJECT_DIR/$relative")"
	if [[ "$digest" != "$prefix"* ]]; then
		fail "$relative hashes ${digest:0:8}, not its accepted $prefix"
		mismatched=$((mismatched + 1))
	fi
done
if [[ "$mismatched" == "0" ]]; then
	pass "the I2 scene and all 18 accepted I2, I3 and H9 evidence frames match their accepted SHA-256 prefixes"
fi

if grep -rlE 'passive_fallback_presentation_review' "$PROJECT_DIR/scripts" "$PROJECT_DIR/scenes" \
		"$PROJECT_DIR/data" "$PROJECT_DIR/addons" "$PROJECT_DIR/project.godot" 2>/dev/null | grep -q .; then
	fail "a running file or project.godot names the I10 harness"
else
	pass "no file under scripts/, scenes/, data/ or addons/, and nothing in project.godot, names the I10 harness"
fi

others="$(grep -oE 'res://tests/[A-Za-z0-9_./-]+' "$PROJECT_DIR/$THIS_VERIFICATION" | sort -u \
	| grep -vxF "res://$THIS_VERIFICATION" | tr '\n' ' ')"
if [[ -z "${others// /}" ]] && grep -q '^extends SceneTree$' "$PROJECT_DIR/$THIS_VERIFICATION"; then
	pass "the verification is a SceneTree script and names no file under tests/ but its own"
else
	fail "the verification names another test file: ${others:-none}, or is not a SceneTree script"
fi

if grep -qE 'user://|ConfigFile|ResourceSaver|DirAccess|store_string' "$PROJECT_DIR/$THIS_VERIFICATION"; then
	fail "the verification names a storage path or writer"
else
	pass "the verification names no storage path or writer (its only file write is an evidence frame under --shots)"
fi

# --------------------------------------------------------------------------
step "3. The pinned verification passes, proved in BOTH directions"

verify_log="/tmp/riftwrought_passive_fallback_presentation_review_verify.log"
run_verification "$verify_log" --headless --path "$PROJECT_DIR" --script "res://$THIS_VERIFICATION" -- --seed "$ROUTE_SEED"
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

count="$(read_check_count "ROGUELITE PASSIVE-FALLBACK PRESENTATION REVIEW VERIFICATION" "$verify_log")"
if [[ "$count" == "$EXPECTED_CHECKS" ]]; then
	pass "verification passes at the pinned $EXPECTED_CHECKS checks"
else
	fail "verification reports ${count:-no} checks, not $EXPECTED_CHECKS"
fi

# A guard that accepts everything protects nothing: the pin must refuse a log whose count
# moved by one, and the negative direction must READ the moved number.
replay="$(mktemp -t riftwrought_passive_fallback_presentation_review_replay)"
scratch_replay="$replay"
sed "s/ROGUELITE PASSIVE-FALLBACK PRESENTATION REVIEW VERIFICATION: PASS ($EXPECTED_CHECKS checks)/ROGUELITE PASSIVE-FALLBACK PRESENTATION REVIEW VERIFICATION: PASS ($((EXPECTED_CHECKS + 1)) checks)/" \
	"$verify_log" > "$replay"
replay_count="$(read_check_count "ROGUELITE PASSIVE-FALLBACK PRESENTATION REVIEW VERIFICATION" "$replay")"
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
for moved in "$((EXPECTED_OWED_CHECKS - 1)) of $EXPECTED_OWED_CHECKS" "$EXPECTED_OWED_CHECKS of $((EXPECTED_OWED_CHECKS + 1))"; do
	if grep -qE "^  $moved owed checks completed" "$verify_log"; then
		fail "the owed-set line reads '$moved'"
	fi
done

# The measurements this review exists to make, read out of the run's own log rather than
# restated here. `--` before the pattern is D-244's lesson kept. Lines carrying a rectangle
# that varies with the window are not pinned.
while IFS= read -r line; do
	if grep -qF -- "$line" "$verify_log"; then
		pass "measured: ${line}"
	else
		fail "the verification log does not report: ${line}"
	fi
done <<'MEASURED'
the accepted scene roguelite_level_up_choice_review.tscn runs roguelite_level_up_choice_review.gd; no accepted suite started; since I11 (D-314) the review asks each level's offer once, from one opening call, and asks standing_offer_cards() only where an offer is shown
31 actions; the entrypoint is prototype_app.tscn; project.godot declares no [autoload]; 0 of 16 injection patterns in this harness's code
E2 reads the standing offer's stored support_content_kind and, for a PASSIVE_FALLBACK only, its fallback's selected_category; G4 and H8 each hand both on in one line; each follows its layer's offer_identity_for(); fields _track, _build, _ledger, _offer, _requirement, _completed / _run_seed, _current / _run, _field, _bindings
the review asks offer_support_content_kind() once, in standing_offer_cards(); the card and the receipt branch on the stored kind and read no identity's size; its receipt section refreshes whenever the panel opens; the review declares the same 18 fields
Support: Sweeping Edge — Applies to Quick Strike; Combat and Defence: Celerity — +10% Skill Speed; Utility: Fleetness — +10% Movement Speed
Temporary build — this expedition | Support — Quick Strike → Sweeping Edge | a new compatible pair, rank 0 -> 1 | Rift level 1 → 2 · 0 XP carried over | Recorded in the temporary build; not applied to the character in this review.
Levels 1–4 awarded exactly 100, 125, 150 and 175 through fixture motes; the review opened Level 1 on its own and Levels 2–4 were opened explicitly through H8 and shown in its panel; Support taken with Enter at each
root seeds 99, 1000102, 2000105, 3000108 — each G2's own for its level, each consumed once (taking Support again answered 'no offer is open; one must be opened before a lane may be taken'), each record identical to the G4 twin's and to the E2 chain's
receipts: Support — Quick Strike → Sweeping Edge / Support — Quick Strike → Reaching Edge / Support — Quick Strike → Reaching Edge / Support — Quick Strike → Sweeping Edge
A: reaching_edge 2 / 2, sweeping_edge 2 / 2, twin 2 / 2, 0 card(s), pairs [quick_strike -> reaching_edge, quick_strike -> sweeping_edge]
H8 root 4000111 lanes [0, 1, 2] [card_power] [card_vitality] [card_fleetness] kind 1 category 0 | G4 root 4000111 lanes [0, 1, 2] [card_power] [card_vitality] [card_fleetness] kind 1 category 0 | E2 root 4000111 lanes [0, 1, 2] [card_power] [card_vitality] [card_fleetness] kind 1 category 0
the fallback card_power's canonical category is 0, and all three layers answer it
lanes [0, 1, 2] = D1's [0, 1, 2]; Support: Power — Supports maxed — +10% Global Damage; Combat and Defence: Vitality — +15% Maximum Life; Utility: Fleetness — +10% Movement Speed
captions Choose Power, Choose Vitality, Choose Fleetness; the Support card is card_power, which neither ordinary lane carries (card_vitality, card_fleetness); focus on card 1; the note, the standing receipt line and H9's withheld lines unchanged
behind the modal H9's panel reads 'Rift level 5' / 'XP 200 / 200' and the receipt section only 'Temporary build — this expedition' | 'Level-up offer open — choose one of the three cards.'; Level 4's receipt is held but hidden
15 visible panel lines scanned for 30 forbidden fragments — every catalogue id, the root seed, the three lane seeds, both fallback tickets, the weight and the internal terms: 0 found
15 of 15 visible text controls on screen, smallest 12 px; 3 cards, 0 overlapping, each at least 320 px wide; the panel centred within 1 px; the fallback detail line inside its own card
lane 7: 'lane 7 is not one of the offer's lanes (Support 1651867394, Combat and Defence 2792332133, Utility 1386478149)'; lane -1: 'lane -1 is not one of the offer's lanes (Support 1651867394, Combat and Defence 2792332133, Utility 1386478149)'; each shown word for word; the same offer (root 4000111 lanes [0, 1, 2] [card_power] [card_vitality] [card_fleetness] kind 1 category 0) still open, paused, level 5, 200.0, nothing acquired, the previous receipt still hidden
lane readings rewritten to [2, 1, 2, 7], identity readings to [card_insight, invented_card] and a copied build given card_insight — all three layers still read root 4000111 lanes [0, 1, 2] [card_power] [card_vitality] [card_fleetness] kind 1 category 0; the kind and the category are ints
A by Enter: granted [card_power] from root seed 4000111 — PASSIVE_FALLBACK, category 0, no support progression; level 5 -> 6 with 0.0 retained; the same record as G4's and the E2 chain's; taken again: 'no offer is open; one must be opened before a lane may be taken'; receipt 'Support — Power (+10% Global Damage)' / 'Passive fallback from Combat and Defence' / 'Rift level 5 → 6 · 0 XP carried over'; card_power 0 -> 1, passive cards 0 -> 1, pairs [quick_strike -> reaching_edge, quick_strike -> sweeping_edge] -> [quick_strike -> reaching_edge, quick_strike -> sweeping_edge], ranks 2 / 2 -> 2 / 2, total 4 -> 4
Temporary build — this expedition | Support — Power (+10% Global Damage) | Passive fallback from Combat and Defence | Rift level 5 → 6 · 0 XP carried over | Recorded in the temporary build; not applied to the character in this review.; smallest 12 px; inside the review panel, clear of the centre; not paused; 'Rift level 6' / 'XP 0 / 225'
225.0 awarded at Level 6 (G1's requirement): the review asked its own Level 6 opening on its next tick — root 5000114, G2's own — and nothing more; Enter took its first card to Level 7
B by (A): granted [card_power] from root seed 4000111 — PASSIVE_FALLBACK, category 0, no support progression; level 5 -> 6 with 0.0 retained; the same record as G4's and the E2 chain's; taken again: 'no offer is open; one must be opened before a lane may be taken'; receipt 'Support — Power (+10% Global Damage)' / 'Passive fallback from Combat and Defence' / 'Rift level 5 → 6 · 0 XP carried over'; card_power 0 -> 1
C by left click: granted [card_power] from root seed 4000111 — PASSIVE_FALLBACK, category 0, no support progression; level 5 -> 6 with 0.0 retained; the same record as G4's and the E2 chain's; taken again: 'no offer is open; one must be opened before a lane may be taken'; receipt 'Support — Power (+10% Global Damage)' / 'Passive fallback from Combat and Defence' / 'Rift level 5 → 6 · 0 XP carried over'; card_power 0 -> 1
D by Right + Enter: granted [card_vitality] from root seed 4000111 — no Support content, no category, no support progression; level 5 -> 6 with 0.0 retained; the same record as G4's and the E2 chain's; receipt 'Combat and Defence — Vitality (+15% Maximum Life)' / 'Rift level 5 → 6 · 0 XP carried over'; card_vitality 0 -> 1, card_power not acquired, pairs and ranks unchanged
E by left click: granted [card_fleetness] from root seed 4000111 — no Support content, no category, no support progression; level 5 -> 6 with 0.0 retained; the same record as G4's and the E2 chain's; receipt 'Utility — Fleetness (+10% Movement Speed)' / 'Rift level 5 → 6 · 0 XP carried over'; card_fleetness 0 -> 1, card_power not acquired, pairs and ranks unchanged
a fresh E2, G4 and H8 each answer kind -1 and category -1; 31 no-offer readings of all three layers — before each of the 5 offers and after the Level 5 choice, in 5 expeditions, and after the Level 6 choice — all -1 / -1 with no offer standing
20 progression offers (Levels 1–4 in 5 expeditions): all three layers read SUPPORT_PROGRESSION (0) and category -1, with the same root seed, lanes and identities
27 readings with an offer standing — Levels 1–5 in 5 expeditions and after both refused lanes — each showing only 'Temporary build — this expedition' | 'Level-up offer open — choose one of the three cards.', with H9's level and XP
5 Level 5 choices (3 fallbacks, 2 ordinary passive lanes): the receipt hidden up to the press, and the new receipt shown by the same input that closed the panel
max speed 5.0 m/s, action time 0.80 s (effective 0.80 s), reach 1.65 m, arc 100 deg, cone 65 deg, +0% attack speed — identical after all 25 choices
5 of 5 expeditions (A, B, C, D, E) ended by F5 with no runtime, attempt, record or receipt left, the panel closed and the world running
5 expeditions (4 given seed 99 again by staging), 26 fixture Graveblades registered and killed, 26 level-ups taken through the review's panel, 6 offer opening(s) asked by the review itself across this suite
MEASURED

# --------------------------------------------------------------------------
step "4. project.godot is untouched"

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

# --------------------------------------------------------------------------
step "5. The third-party inventory has not moved — the review extracts nothing"

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
step "6. Rendered evidence"

if [[ -n "$SHOT_DIR" ]]; then
	for resolution in 1920x1080 1280x720; do
		target="$SHOT_DIR"
		[[ "$resolution" == "1280x720" ]] && target="$SHOT_DIR/1280x720"
		mkdir -p "$target"
		shots_log="/tmp/riftwrought_passive_fallback_presentation_review_shots_$resolution.log"
		run_verification "$shots_log" --path "$PROJECT_DIR" --resolution "$resolution" \
			--script "res://$THIS_VERIFICATION" -- --seed "$ROUTE_SEED" --shots "$target"
		shots_status=$?
		printf '  %s verification exit status: %s\n' "$resolution" "$shots_status"
		assert_log_is_fresh "$shots_log"
		assert_no_script_error "the $resolution rendered run" "$shots_log"
		assert_engine_output "the $resolution rendered run" "$shots_log"
		rendered_count="$(read_check_count "ROGUELITE PASSIVE-FALLBACK PRESENTATION REVIEW VERIFICATION" "$shots_log")"
		if [[ "$shots_status" == "0" && "$rendered_count" == "$EXPECTED_CHECKS" ]]; then
			pass "the $resolution rendered run exits 0 at the same pinned $EXPECTED_CHECKS checks"
		else
			fail "the $resolution rendered run exits $shots_status at ${rendered_count:-no} checks, not $EXPECTED_CHECKS"
			grep -E "^  FAIL" "$shots_log" | head -10 | sed 's/^/        /'
		fi
		if grep -qF "15 of 15 visible text controls on screen, smallest 12 px; 3 cards, 0 overlapping, each at least 320 px wide; the panel centred within 1 px; the fallback detail line inside its own card" "$shots_log" \
				&& grep -qF "inside the review panel, clear of the centre; not paused; 'Rift level 6' / 'XP 0 / 225'" "$shots_log"; then
			pass "at $resolution the fallback panel's 15 controls and the receipt are on screen, apart, centred and unobstructed"
		else
			fail "at $resolution the panel's or the receipt's on-screen measurement is missing or different"
		fi
		shots=0
		for stem in 01_passive_fallback_offer 02_passive_fallback_receipt; do
			frame="$target/$stem.png"
			if [[ -f "$frame" && "$(stat -f %m "$frame")" -ge "$RUN_STARTED_AT" && "$(wc -c < "$frame" | tr -d ' ')" -gt 20000 ]]; then
				shots=$((shots + 1))
			else
				fail "$stem.png was not freshly captured at $resolution"
			fi
		done
		if [[ "$shots" == "2" ]]; then
			pass "both evidence frames freshly captured into $target"
		fi
	done
else
	printf '  skipped (pass --shots <dir> to render evidence)\n'
fi

# --------------------------------------------------------------------------
step "7. Nothing under game/ moved, every protected file is byte-identical, and the owner's files are untouched"

tree_after="$(tree_fingerprint)"
cache_after="$(cache_fingerprint)"
if [[ "$tree_after" == "$tree_before" ]]; then
	pass "game/ outside .godot/ is byte-identical across the run: $tree_files file(s), the run wrote nothing there"
else
	fail "a file under game/ outside .godot/ changed during this run"
fi
if [[ "$cache_after" == "$cache_before" ]]; then
	pass ".godot/ is byte-identical across the run: $cache_files file(s)"
else
	fail ".godot/ changed during this run"
fi

changed=0
for i in "${!PRESERVED_FILES[@]}"; do
	after="$(fingerprint "$PROJECT_DIR/${PRESERVED_FILES[$i]}")"
	if [[ "$after" != "${BEFORE_HASHES[$i]}" ]]; then
		fail "${PRESERVED_FILES[$i]} CHANGED during this run"
		changed=$((changed + 1))
	fi
done
if [[ "$changed" == "0" && "$missing_preserved" == "0" ]]; then
	pass "all ${#PRESERVED_FILES[@]} protected files outside game/ are byte-identical"
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
	printf 'ROGUELITE PASSIVE-FALLBACK PRESENTATION REVIEW SMOKE CHECKS: PASS\n'
	printf '  %s checks; %s of %s owed; game/ and %s protected files byte-identical\n' \
		"$EXPECTED_CHECKS" "$EXPECTED_OWED_CHECKS" "$EXPECTED_OWED_CHECKS" "${#PRESERVED_FILES[@]}"
	printf '  Roguelite I10 — Three-Card Passive-Fallback Presentation Review — is DELIVERED\n'
	printf '  under D-312, CORRECTED under D-313, and ACCEPTED and CLOSED at the rendered\n'
	printf '  greybox three-card passive-fallback presentation review level under D-313.\n'
	reached_end=1
	exit 0
else
	printf 'ROGUELITE PASSIVE-FALLBACK PRESENTATION REVIEW SMOKE CHECKS: %d FAILURE(S)\n' "$failures"
	reached_end=1
	exit 1
fi
