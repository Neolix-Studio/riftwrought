#!/usr/bin/env bash
# Riftwrought — Zone Composer Phase 1 smoke checks (D-210).
#
# THIS IS NOT A GATE AND IT DELIBERATELY DOES NOT RUN THE LOCKED CHAIN.
#
# The Zone Composer is an EDITOR tool. It ships no gameplay, no scene, no asset,
# no InputMap action and no runtime code, so rerunning Gates A–F, 1A, 1B and 1C
# on every edit of a dock button would be verification theatre. The chain is run
# ONCE on the final tree, by hand, with the script that owns it:
#
#     game/tests/gate_1c_riftfall_landing_smoke.sh
#
# What this script proves is exactly what Phase 1 can break:
#
#   1. every addon file parses;
#   2. the plugin ENABLES in a real editor and builds its dock, with no script
#      error — proved by the line the plugin prints, because an absence of errors
#      is also what a plugin that silently failed to construct would produce;
#   3. INSIDE that editor, a synthesized click really places a piece through the
#      real `EditorUndoRedoManager`, "Undo Last Placement" really removes it, and
#      redo really restores it. This is not decoration: `UndoRedo` and
#      `EditorUndoRedoManager` do NOT share the `add_do_method` signature, so a
#      headless test alone would have proved the wrong branch. Since D-211 it also
#      proves that every story marker is DRAWN by this tool's own gizmo, that the
#      drawing survives undo, redo and a disable/re-enable, and that the viewport
#      overlay really executes;
#   3b. a SECOND editor session opens the zone the project owner already composed
#      and proves its five markers are drawn — the honest proof that a saved zone
#      reopened later gets its symbols back, with nothing added to the file;
#   4. the headless verification passes at its pinned count, and the pin is proved
#      in BOTH directions;
#   5. `project.godot` received exactly one change — the `[editor_plugins]`
#      section — and the accepted 31-action InputMap, the entrypoint and the
#      absence of WASD are untouched;
#   6. ordinary game startup is unchanged: the Prototype App still boots headless
#      with no script error, and nothing under `scripts/`, `scenes/` or `data/`
#      names the addon, so the running game needs no editor code;
#   7. the third-party inventory is exactly the authorized 185 + 2 = 187 — the 89
#      that stood at D-204 plus the 94 files D-215 authorized plus the 2 LeLu
#      Noise Pack textures D-216 registered — every source model is byte-identical
#      across the run, and the zone the OWNER composed is too.
#
# Usage, from the repository root:
#   game/tests/zone_composer_smoke.sh

set -uo pipefail

GODOT="${GODOT:-/Applications/Godot.app/Contents/MacOS/Godot}"
EXPECTED_VERSION="4.7.2.stable"
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

ADDON_DIR="$PROJECT_DIR/addons/riftwrought_zone_composer"
VERIFICATION="res://tests/zone_composer_verification.gd"

# Pinned, and proved in both directions below.
EXPECTED_CHECKS=324
EXPECTED_EDITOR_CHECKS=79
EXPECTED_REOPEN_CHECKS=7

# The zone the project owner composed with the tool. Read-only here, and
# fingerprinted around the WHOLE run — including two editor sessions, one of which
# opens it deliberately.
PRACTICE_ZONE="$PROJECT_DIR/scenes/first_mvp/zone_composer_practice.tscn"

# project.godot holds exactly these sections. Godot rewrites and re-sorts the file
# whenever the editor closes, so their ORDER is the serializer's business; the SET
# is the project's.
EXPECTED_SECTIONS="application audio debug display editor_plugins input layer_names navigation rendering"
# MOVED BY AUTHORIZATION UNDER D-215, THEN D-216, and stated as arithmetic so it
# cannot drift.
#   89 payload files as of D-204
# + 47 D-215 approved models (.gltf)
# + 47 of their .bin sidecars
# = 183 payload files
# +  2 LeLu Noise Pack textures (D-216, the accepted Riftfall Landing Greybox V2
#      + Visual Review dressing pass)
# = 185 payload files, plus the 2 D-202 source maps = 187.
# Godot's 47 generated .gltf.import sidecars are filtered out of this count, as
# every earlier suite filters them, and a .bin gets neither a .import nor a .uid.
EXPECTED_THIRD_PARTY_PAYLOADS=185
EXPECTED_THIRD_PARTY=187
EXPECTED_INPUT_ACTIONS=31
EXPECTED_MAIN_SCENE="res://scenes/app/prototype_app.tscn"

failures=0

step() { printf '\n=== %s\n' "$1"; }
pass() { printf '  PASS  %s\n' "$1"; }
fail() { printf '  FAIL  %s\n' "$1"; failures=$((failures + 1)); }

# --------------------------------------------------------------------------
step "0. Godot, and a fingerprint of every third-party source asset"

version="$("$GODOT" --version 2>/dev/null | head -1 | tr -d '\r')"
if [[ "$version" == "$EXPECTED_VERSION"* ]]; then
	pass "Godot $version"
else
	fail "Godot is $version, not $EXPECTED_VERSION"
	printf '\nZONE COMPOSER SMOKE CHECKS: FAIL (wrong engine)\n'
	exit 1
fi

# An authoring tool that modified a source model would be a defect of the first
# order, so the shell measures it independently of the in-engine check.
fingerprint_sources() {
	find "$PROJECT_DIR/assets/third_party" -type f ! -name '*.import' ! -name '.DS_Store' \
		| sort | xargs shasum -a 256 2>/dev/null | shasum -a 256 | awk '{print $1}'
}
sources_before="$(fingerprint_sources)"
printf '  third-party source fingerprint before: %s\n' "${sources_before:0:16}"

practice_before=""
if [[ -f "$PRACTICE_ZONE" ]]; then
	practice_before="$(shasum -a 256 "$PRACTICE_ZONE" | awk '{print $1}')"
	pass "the owner's composed zone is present and fingerprinted (${practice_before:0:16})"
else
	fail "the owner's composed zone is missing: $PRACTICE_ZONE"
fi

# --------------------------------------------------------------------------
step "1. Every addon file parses"

for script in "$ADDON_DIR"/*.gd "$PROJECT_DIR/tests/zone_composer_verification.gd"; do
	name="$(basename "$script")"
	relative="${script#"$PROJECT_DIR"/}"
	log="/tmp/riftwrought_zc_parse_$name.log"
	"$GODOT" --headless --path "$PROJECT_DIR" --check-only --script "res://$relative" \
		> "$log" 2>&1
	if grep -qE "Parse Error|Compile Error|Failed to load script" "$log"; then
		fail "$name does not parse"
		grep -E "Parse Error|Compile Error" "$log" | head -3 | sed 's/^/        /'
	else
		pass "$name parses"
	fi
done

if [[ -f "$ADDON_DIR/plugin.cfg" ]]; then
	pass "plugin.cfg exists"
else
	fail "plugin.cfg is missing"
fi

# --------------------------------------------------------------------------
step "2. The plugin enables in a real editor and builds its dock"

editor_log="/tmp/riftwrought_zc_editor.log"
# One editor boot serves both step 2 and step 3: it enables the plugin AND runs
# the in-editor check the plugin dispatches on --verify-zone-composer.
"$GODOT" --headless --editor --path "$PROJECT_DIR" --quit-after 3000 \
	-- --verify-zone-composer > "$editor_log" 2>&1
ready="$(grep -c "Riftwrought Zone Composer: dock ready" "$editor_log" | tr -d ' ')"
if [[ "$ready" -ge 1 ]]; then
	pass "$(grep -m1 "Riftwrought Zone Composer: dock ready" "$editor_log" | sed 's/^ *//')"
else
	fail "the plugin did not report a ready dock; it may not have loaded at all"
	tail -15 "$editor_log" | sed 's/^/        /'
fi
problems="$(grep -m1 -oE "[0-9]+ problems" "$editor_log" | grep -oE '[0-9]+')"
if [[ "${problems:-1}" == "0" ]]; then
	pass "the palette reports no problems: it agrees with the accepted asset record"
else
	fail "the palette reports ${problems:-unknown} problems"
fi
editor_errors="$(grep -c "SCRIPT ERROR" "$editor_log" | tr -d ' ')"
if [[ "$editor_errors" == "0" ]]; then
	pass "the editor boot produced no script error"
else
	fail "$editor_errors script errors during the editor boot"
	grep -A3 "SCRIPT ERROR" "$editor_log" | head -12 | sed 's/^/        /'
fi

# A grep for SCRIPT ERROR alone cannot see a DRAWING fault: an empty line array
# handed to a gizmo, a missing material, or a draw call outside a canvas item's
# own `_draw` are all plain engine errors. Those are exactly the ways the marker
# work could go wrong, so they get their own gate.
draw_errors="$(grep -cE "Drawing is only allowed|Condition .!materials.has|empty lines is not allowed|Parameter \"material\" is null" "$editor_log" | tr -d ' ')"
if [[ "$draw_errors" == "0" ]]; then
	pass "and no gizmo or overlay drawing error"
else
	fail "$draw_errors gizmo/overlay drawing errors during the editor boot"
	grep -E "Drawing is only allowed|materials.has|empty lines|material.* is null" "$editor_log" \
		| head -6 | sed 's/^/        /'
fi

# --------------------------------------------------------------------------
step "3. Inside that editor: a click places, Undo removes, Redo restores"

read_check_count() {
	# Three steps, exactly as the closed gates learned to do it: a bare
	# `grep -oE '[0-9]+' | head -1` would read a digit out of the label.
	grep -ohE "$1: PASS \([0-9]+ checks\)" "$2" \
		| grep -ohE '[0-9]+ checks' | grep -ohE '[0-9]+' | head -1
}

editor_count="$(read_check_count "ZONE COMPOSER COMPOSE CHECK" "$editor_log")"
if [[ "$editor_count" == "$EXPECTED_EDITOR_CHECKS" ]]; then
	pass "the in-editor check passes $EXPECTED_EDITOR_CHECKS checks against the real EditorUndoRedoManager"
else
	fail "the in-editor check reports ${editor_count:-no} checks, not $EXPECTED_EDITOR_CHECKS"
	grep -E "^  FAIL|COMPOSE CHECK:" "$editor_log" | sed 's/^/        /'
fi

# The in-editor pin was the one that had no both-directions proof. It has one now.
editor_replay="$(mktemp -t riftwrought_zc_editor_replay)"
sed "s/ZONE COMPOSER COMPOSE CHECK: PASS ($EXPECTED_EDITOR_CHECKS checks)/ZONE COMPOSER COMPOSE CHECK: PASS ($((EXPECTED_EDITOR_CHECKS + 1)) checks)/" \
	"$editor_log" > "$editor_replay"
if [[ "$(read_check_count "ZONE COMPOSER COMPOSE CHECK" "$editor_replay")" != "$EXPECTED_EDITOR_CHECKS" ]]; then
	pass "and that pin refuses a log whose count moved by one"
else
	fail "the in-editor count pin accepts a wrong count and therefore proves nothing"
fi
rm -f "$editor_replay"
# The throwaway scene it opens must not survive the run.
scratch="$PROJECT_DIR/tests/zone_composer_editor_check_scene.tscn"
rm -f "$scratch.uid"
if [[ ! -f "$scratch" ]]; then
	pass "the check's throwaway scene was removed again"
else
	fail "the check left $scratch behind"
	rm -f "$scratch"
fi

# --------------------------------------------------------------------------
step "3b. A SECOND editor session: the zone the owner already composed"

# THE POINT OF A SEPARATE BOOT. Disabling and re-enabling the gizmo plugin inside
# one session is proved by the in-editor check above; what THIS proves is the
# thing the owner will actually do — close the editor, open it again tomorrow, and
# find their markers still drawn. It opens the owner's own zone READ-ONLY. The
# fingerprint taken in step 0 is compared in step 7, after this has run.
reopen_log="/tmp/riftwrought_zc_reopen.log"
"$GODOT" --headless --editor --path "$PROJECT_DIR" --quit-after 3000 \
	-- --verify-zone-composer-reopen > "$reopen_log" 2>&1
reopen_count="$(read_check_count "ZONE COMPOSER REOPEN CHECK" "$reopen_log")"
if [[ "$reopen_count" == "$EXPECTED_REOPEN_CHECKS" ]]; then
	pass "a fresh editor session draws every marker in the owner's composed zone ($EXPECTED_REOPEN_CHECKS checks)"
	grep -E "^  PASS  (holding|and every one)" "$reopen_log" | sed 's/^  PASS  /        /'
else
	fail "the reopen check reports ${reopen_count:-no} checks, not $EXPECTED_REOPEN_CHECKS"
	grep -E "^  FAIL|REOPEN CHECK:" "$reopen_log" | sed 's/^/        /'
fi
reopen_errors="$(grep -c "SCRIPT ERROR" "$reopen_log" | tr -d ' ')"
reopen_draw="$(grep -cE "Drawing is only allowed|Condition .!materials.has|empty lines is not allowed" "$reopen_log" | tr -d ' ')"
if [[ "$reopen_errors" == "0" && "$reopen_draw" == "0" ]]; then
	pass "with no script error and no drawing error"
else
	fail "$reopen_errors script errors and $reopen_draw drawing errors in the reopen session"
	grep -A3 "SCRIPT ERROR" "$reopen_log" | head -12 | sed 's/^/        /'
fi

# --------------------------------------------------------------------------
step "4. The headless verification, and its count pinned in both directions"

verify_log="/tmp/riftwrought_zc_verify.log"
"$GODOT" --headless --path "$PROJECT_DIR" --script "$VERIFICATION" > "$verify_log" 2>&1
verify_status=$?
if [[ "$verify_status" == "0" ]]; then
	pass "the verification exits 0"
else
	fail "the verification exits $verify_status"
fi
grep -E "^  FAIL" "$verify_log" | sed 's/^/      /'

# Three steps, exactly as the closed gates learned to do it: a bare
# `grep -oE '[0-9]+' | head -1` on "ZONE COMPOSER VERIFICATION" would read a digit
# out of the label, not the count.
count="$(grep -ohE "ZONE COMPOSER VERIFICATION: PASS \([0-9]+ checks\)" "$verify_log" \
	| grep -ohE '[0-9]+ checks' | grep -ohE '[0-9]+' | head -1)"
if [[ "$count" == "$EXPECTED_CHECKS" ]]; then
	pass "the verification passes $EXPECTED_CHECKS checks"
else
	fail "the verification reports ${count:-no} checks, not $EXPECTED_CHECKS"
fi

# A pin that accepts anything protects nothing, so the same test is replayed
# against a log with the count altered by one and must refuse it.
replay="$(mktemp -t riftwrought_zc_replay)"
trap 'rm -f "$replay"' EXIT
sed "s/ZONE COMPOSER VERIFICATION: PASS ($EXPECTED_CHECKS checks)/ZONE COMPOSER VERIFICATION: PASS ($((EXPECTED_CHECKS + 1)) checks)/" \
	"$verify_log" > "$replay"
replay_count="$(grep -ohE "ZONE COMPOSER VERIFICATION: PASS \([0-9]+ checks\)" "$replay" \
	| grep -ohE '[0-9]+ checks' | grep -ohE '[0-9]+' | head -1)"
if [[ "$replay_count" != "$EXPECTED_CHECKS" ]]; then
	pass "and the pin refuses a log whose count moved by one (read $replay_count)"
else
	fail "the count pin accepts a wrong count and therefore proves nothing"
fi

verify_errors="$(grep -c "SCRIPT ERROR" "$verify_log" | tr -d ' ')"
if [[ "$verify_errors" == "0" ]]; then
	pass "the verification run produced no script error"
else
	fail "$verify_errors script errors during the verification"
fi

# --------------------------------------------------------------------------
step "5. project.godot received exactly one change"

main_scene="$(sed -n 's/^run\/main_scene="\(.*\)"[[:space:]]*$/\1/p' "$PROJECT_DIR/project.godot" | head -1)"
if [[ "$main_scene" == "$EXPECTED_MAIN_SCENE" ]]; then
	pass "the entrypoint is still $EXPECTED_MAIN_SCENE"
else
	fail "the entrypoint is $main_scene"
fi

declared_actions="$(awk '/^\[input\]/{f=1;next} /^\[/{f=0} f && /^[a-zA-Z_]+=\{/{c++} END{print c+0}' \
	"$PROJECT_DIR/project.godot")"
if [[ "$declared_actions" == "$EXPECTED_INPUT_ACTIONS" ]]; then
	pass "the accepted $EXPECTED_INPUT_ACTIONS-action InputMap is unchanged"
else
	fail "project.godot declares $declared_actions actions, not $EXPECTED_INPUT_ACTIONS"
fi

wasd="$(grep -cE '^(move_up|move_down|move_left|move_right)=' "$PROJECT_DIR/project.godot" | tr -d ' ')"
if [[ "$wasd" == "0" ]]; then
	pass "still no WASD binding"
else
	fail "$wasd WASD-style actions exist"
fi

# The addon may be named in exactly ONE line of project.godot, and that line must
# be the enabled entry inside the editor-only section — not a setting, not an
# autoload, not a path anywhere else.
addon_lines="$(grep -c 'addons/riftwrought_zone_composer' "$PROJECT_DIR/project.godot" | tr -d ' ')"
enabled_line="$(grep -c '^enabled=PackedStringArray("res://addons/riftwrought_zone_composer/plugin.cfg")$' \
	"$PROJECT_DIR/project.godot" | tr -d ' ')"
if [[ "$addon_lines" == "1" && "$enabled_line" == "1" ]]; then
	pass "the addon is named on exactly one line, and it is the editor-only enabled entry"
else
	fail "the addon is named on $addon_lines lines in project.godot (enabled entries: $enabled_line)"
fi

# THIS TEST USED TO CHECK THE POSITION OF [editor_plugins] AND IT MEASURED THE
# SERIALIZER, NOT THE PROJECT. Godot rewrites project.godot every time the editor
# closes and re-emits the sections in its own alphabetical order, so the section
# that was appended at delivery is now the fifth of nine — and the check failed on
# the owner simply having used the tool. The SET is what this work must not
# change; the order is Godot's business. The replacement is strictly stronger: the
# old test would have accepted a brand new section inserted ABOVE [editor_plugins].
actual_sections="$(grep -oE '^\[[a-z_]+\]' "$PROJECT_DIR/project.godot" | tr -d '[]' | sort | tr '\n' ' ' | sed 's/ $//')"
if [[ "$actual_sections" == "$EXPECTED_SECTIONS" ]]; then
	pass "project.godot holds exactly the nine expected sections, in whatever order Godot last wrote them"
else
	fail "project.godot sections are: $actual_sections"
	printf '        expected: %s\n' "$EXPECTED_SECTIONS"
fi
editor_plugin_keys="$(awk '/^\[editor_plugins\]/{f=1;next} /^\[/{f=0} f && /^[a-zA-Z_]+=/{c++} END{print c+0}' \
	"$PROJECT_DIR/project.godot")"
if [[ "$editor_plugin_keys" == "1" ]]; then
	pass "and [editor_plugins] declares exactly one key, the enabled entry"
else
	fail "[editor_plugins] declares $editor_plugin_keys keys, not 1"
fi
autoloads="$(grep -c '^\[autoload\]' "$PROJECT_DIR/project.godot" | tr -d ' ')"
if [[ "$autoloads" == "0" ]]; then
	pass "the tool declares no autoload, so it cannot reach the running game"
else
	fail "an [autoload] section exists"
fi

# --------------------------------------------------------------------------
step "6. Ordinary game startup is unchanged, and needs no editor code"

boot_log="/tmp/riftwrought_zc_boot.log"
"$GODOT" --headless --path "$PROJECT_DIR" "$EXPECTED_MAIN_SCENE" --quit-after 90 > "$boot_log" 2>&1
boot_errors="$(grep -c "SCRIPT ERROR" "$boot_log" | tr -d ' ')"
if [[ "$boot_errors" == "0" ]]; then
	pass "the Prototype App still boots headless with no script error"
else
	fail "$boot_errors script errors booting the Prototype App"
	grep -A3 "SCRIPT ERROR" "$boot_log" | head -12 | sed 's/^/        /'
fi

leaks="$(grep -rl 'addons/riftwrought_zone_composer\|ZoneComposer' \
	"$PROJECT_DIR/scripts" "$PROJECT_DIR/scenes" "$PROJECT_DIR/data" 2>/dev/null | wc -l | tr -d ' ')"
if [[ "$leaks" == "0" ]]; then
	pass "no script, scene or data file names the addon: the game needs no editor code"
else
	fail "$leaks shipping files name the addon"
	grep -rl 'addons/riftwrought_zone_composer\|ZoneComposer' \
		"$PROJECT_DIR/scripts" "$PROJECT_DIR/scenes" "$PROJECT_DIR/data" 2>/dev/null \
		| sed "s|^$PROJECT_DIR/|        |"
fi

# And the addon reaches into the project in exactly one place: the accepted
# asset record it reads. Scanned RAW, so a path inside a comment is caught too.
# EVERY res:// path the addon names, minus its own files. The narrower pattern
# scanned only scripts/, scenes/ and data/ and therefore printed "exactly one"
# while plugin.gd also names the in-editor check under tests/.
project_paths="$(grep -rohE 'res://[a-zA-Z0-9_/.]+\.[a-z]+' "$ADDON_DIR" 2>/dev/null \
	| grep -v '^res://addons/riftwrought_zone_composer/' | sort -u)"
project_path_count="$(printf '%s\n' "$project_paths" | grep -c . | tr -d ' ')"
printf '  project files the addon names:\n'
printf '%s\n' "$project_paths" | sed 's/^/        /'
expected_paths="res://scripts/environment/approved_environment_palette.gd
res://scripts/first_mvp/severed_threshold/riftfall_landing_layout.gd
res://tests/zone_composer_editor_check.gd"
if [[ "$project_paths" == "$expected_paths" ]]; then
	pass "exactly three BY PATH — the two accepted asset records it reads, and the in-editor check it dispatches"
else
	fail "the addon names $project_path_count project files"
fi

# AND BY CLASS NAME, WHICH THE PATH GREP CANNOT SEE. The palette measures every
# piece through `ExteriorAssetProbe`, a global class under scripts/. "Exactly one
# project file" was true of the string literals and never of the substance. The
# headless verification proves the full set from the engine's own class list; this
# line states it where a reader of the runner will see it.
addon_classes="$(grep -rohE '\bExteriorAssetProbe\b' "$ADDON_DIR" 2>/dev/null | sort -u | tr '\n' ' ' | sed 's/ $//')"
if [[ "$addon_classes" == "ExteriorAssetProbe" ]]; then
	pass "and exactly one project CLASS — ExteriorAssetProbe, which measures the pieces"
else
	fail "the addon's project class dependencies are: ${addon_classes:-none}"
fi

writes="$(grep -rlE 'ResourceSaver\.save|FileAccess\.open\(|\.store_string\(|\.store_line\(|DirAccess\.remove' \
	"$ADDON_DIR" 2>/dev/null | wc -l | tr -d ' ')"
if [[ "$writes" == "0" ]]; then
	pass "the addon writes no file of its own; saving is the owner's ordinary Ctrl+S"
else
	fail "$writes addon files write to disk"
fi

# --------------------------------------------------------------------------
step "7. No asset was added, moved or modified"

third_party_payloads="$(find "$PROJECT_DIR/assets/third_party" -type f \
	! -name '*.import' ! -name '.DS_Store' ! -name '*.md' | wc -l | tr -d ' ')"
source_maps=0
for note in "$PROJECT_DIR/assets/third_party/kenney/SOURCE_AND_LICENSE.md" \
	"$PROJECT_DIR/assets/third_party/quaternius/SOURCE_AND_LICENSE.md"; do
	[[ -f "$note" ]] && source_maps=$((source_maps + 1))
done
third_party_count=$((third_party_payloads + source_maps))
printf '   %s payload files + %s source maps = %s\n' \
	"$third_party_payloads" "$source_maps" "$third_party_count"
if [[ "$third_party_payloads" == "$EXPECTED_THIRD_PARTY_PAYLOADS" \
	&& "$third_party_count" == "$EXPECTED_THIRD_PARTY" ]]; then
	pass "the third-party inventory is exactly the authorized $EXPECTED_THIRD_PARTY (89 + 94 D-215 files + 2 LeLu + 2 maps)"
else
	fail "the third-party inventory moved to $third_party_count"
fi

sources_after="$(fingerprint_sources)"
if [[ "$sources_before" == "$sources_after" && -n "$sources_after" ]]; then
	pass "every third-party source asset is byte-identical after the whole run"
else
	fail "a third-party source asset changed during this run"
fi

# THIS TEST USED TO MATCH ON FILENAMES AND IT FAILED ON THE TOOL'S OWN OUTPUT.
# The owner's composed zone is called `zone_composer_practice.tscn` and lives under
# `scenes/`, exactly where a composed zone belongs, so `-iname '*zone_composer*'`
# reported it as a stray. It also never proved what it claimed: a stray addon file
# under a DIFFERENT name would have passed. What must be true is that no addon CODE
# lives outside `addons/` — scenes composed with the tool are its purpose.
strays="$(find "$PROJECT_DIR/scripts" "$PROJECT_DIR/scenes" "$PROJECT_DIR/data" \
	\( -name '*.gd' -o -name '*.cfg' \) -iname '*zone_composer*' 2>/dev/null | wc -l | tr -d ' ')"
if [[ "$strays" == "0" ]]; then
	pass "no Zone Composer code lives under scripts/, scenes/ or data/"
else
	fail "$strays Zone Composer code files exist outside addons/"
	find "$PROJECT_DIR/scripts" "$PROJECT_DIR/scenes" "$PROJECT_DIR/data" \
		\( -name '*.gd' -o -name '*.cfg' \) -iname '*zone_composer*' 2>/dev/null \
		| sed "s|^$PROJECT_DIR/|        |"
fi
composed="$(find "$PROJECT_DIR/scenes" -name '*.tscn' -exec grep -lE 'name="(Ground|Markers)" type="Node3D"' {} + 2>/dev/null | wc -l | tr -d ' ')"
printf '  composed zones present under scenes/: %s\n' "$composed"

# The owner's own work, byte for byte, across two editor sessions — one of which
# deliberately opened it.
if [[ -n "$practice_before" ]]; then
	practice_after="$(shasum -a 256 "$PRACTICE_ZONE" | awk '{print $1}')"
	if [[ "$practice_before" == "$practice_after" ]]; then
		pass "the zone the owner composed is byte-identical after the whole run"
	else
		fail "the owner's composed zone CHANGED during this run"
	fi
fi

# --------------------------------------------------------------------------
printf '\n'
if [[ "$failures" == "0" ]]; then
	cat <<'SUMMARY'
ZONE COMPOSER SMOKE CHECKS: PASS

The Zone Composer's Phase 1 foundation works, and its story markers are drawn.
Phase 1 is CLOSED: the project owner used the tool, built a zone with it, and
accepted it under D-212. No automated check could have answered that question —
only they could, and they have. Phase 2 has not begun.

The locked chain is deliberately NOT run here. Run it once on the final tree:
    game/tests/gate_1c_riftfall_landing_smoke.sh
SUMMARY
	exit 0
else
	printf 'ZONE COMPOSER SMOKE CHECKS: FAIL (%d checks failed)\n' "$failures"
	exit 1
fi
