class_name PrototypeStoragePaths
extends RefCounted
## Prototype Zero — Gate F: the one place that decides whether two path strings
## name the same file on this disk (decision D-191, corrected under D-192).
##
## WHY THIS EXISTS AT ALL.
##
## D-191 gave `PrototypeSettings` and `PrototypeLabState` an injectable
## `storage_path` so the Gate F verification could write, corrupt, and delete
## real files without touching the project owner's own. The guard that decided
## whether a store was still on the production file was a **text comparison**:
##
##     func uses_production_storage() -> bool:
##         return storage_path == "user://prototype_settings.cfg"
##
## That is an alias, not an identity. Hand `--state-dir` the real Godot user
## data directory and the resulting path is
## `/Users/…/app_userdata/<project>/prototype_settings.cfg`, which is a
## different STRING and the same FILE — so the guard would have accepted the
## production directory as isolated storage and the destructive suite would have
## run against the project owner's own settings and laboratory progress. The
## same hole is open for `…/<project>/../<project>/`, for a symlink pointing at
## the production directory, and for a symlink named `prototype_settings.cfg`
## inside an otherwise innocent directory.
##
## So the comparison is made structurally instead: every path is turned into one
## canonical absolute real path — `user://` and `res://` globalized, relative
## paths resolved against the working directory, `.` and `..` removed, every
## symlinked component followed to its target, and **every component replaced by
## the spelling the filesystem itself reports for it** — and the decision is then
## a comparison of two canonical strings that name the same inode by
## construction.
##
## CASE IS PART OF THAT, AND IT WAS THE NEXT ALIAS. The first D-192 resolver did
## everything above except the last clause, and compared the result with `==`.
## On this Mac the project owner's own directory is
## `…/app_userdata/Riftwrought — Prototype Zero`, and asking the guard about
##
##     /users/ladislav/library/application support/godot/app_userdata/riftwrought — prototype zero
##
## produced `accepted`: APFS resolves both spellings to one directory and `==`
## does not. Two mechanisms now close it, and each covers the other's gap.
##
##   1. `_case_canonical()` asks the PARENT DIRECTORY for the real name of every
##      component. Listing a wrong-case parent still returns the true on-disk
##      spelling, so any spelling of an existing path collapses to one string —
##      the same way `read_link()` collapses every symlink to its target. This is
##      a fact obtained from the filesystem rather than a rule assumed about it,
##      and because the name comes from the disk it also folds away any Unicode
##      spelling difference the volume itself folds away.
##   2. `same_path()` and `is_descendant()` then compare CASE-BLIND on a
##      filesystem that folds case, for the parts a listing cannot reach: a file
##      that does not exist yet, or a directory this process cannot list.
##
## WHETHER THIS FILESYSTEM FOLDS CASE IS MEASURED, NOT ASSUMED. macOS and Windows
## are case-insensitive by default and Linux is not, but a macOS volume can be
## formatted case-sensitive and a Linux mount can fold case, so the platform is
## only the starting answer: `compares_paths_case_insensitively()` also asks the
## disk whether the user data directory really does answer to another case, and
## a `true` from either source wins. That asymmetry is deliberate — for a guard
## that REFUSES, "these two spellings might be one directory" is the careful
## answer, and over-refusing a temporary directory costs nothing.
##
## IT IS A PURE CALCULATOR. Nothing here reads a file's contents, writes, or
## creates anything: it asks the filesystem what a path resolves to and returns
## a string. That is what lets `PrototypeApp` refuse a dangerous `--state-dir`
## **before** the first read or write, and what lets the refusal itself be tested
## on a non-writing startup path.
##
## ORDINARY LAUNCHES ARE UNAFFECTED. They pass no `--state-dir`, both stores keep
## their `user://` constants, and the only thing this class does for them is
## answer `true` to `uses_production_storage()` — which is the truth.

## The production vocabulary, held here as literals ON PURPOSE.
##
## `PrototypeSettings.PATH` and `PrototypeLabState.PATH` remain the constants the
## shipped application uses, and this class deliberately does not reference those
## classes: a path calculator that imported the stores would make the stores and
## their guard mutually dependent, and the guard has to be usable before either
## store exists. The duplication is therefore intentional, and it is checked —
## the Gate F suite asserts these four constants are character-for-character the
## constants the two stores actually use, so the pair cannot drift apart in
## silence.
const PRODUCTION_ROOT: String = "user://"
const SETTINGS_FILE_NAME: String = "prototype_settings.cfg"
const LAB_FILE_NAME: String = "prototype_zero.cfg"
const PRODUCTION_SETTINGS: String = "user://prototype_settings.cfg"
const PRODUCTION_LAB: String = "user://prototype_zero.cfg"

## A symlink loop is a real thing a filesystem can hand back. The resolver walks
## at most this many hops and then returns what it has, which is safe: an
## unresolved path can only ever fail to MATCH production, and failing to match
## is refused elsewhere by the production-directory and file comparisons that
## also run on the simplified form.
const MAX_LINK_HOPS: int = 64

## Answered once per process by `compares_paths_case_insensitively()`, because
## every comparison below asks it and the answer cannot change while the process
## runs. `-1` is "not asked yet".
static var _case_folding: int = -1


# --- Canonicalization --------------------------------------------------------

## Absolute, `.`- and `..`-free, without a trailing separator. Symlinks are NOT
## followed here; `real_path()` does that. Godot paths (`user://`, `res://`) are
## globalized first, so `user://prototype_zero.cfg` and the absolute path it
## globalizes to canonicalize identically.
static func absolute(path: String) -> String:
	var text: String = path.strip_edges()
	if text.is_empty():
		return ""
	if text.begins_with("user://") or text.begins_with("res://"):
		text = ProjectSettings.globalize_path(text)
	if not text.is_absolute_path():
		var working: DirAccess = DirAccess.open(".")
		if working != null:
			text = working.get_current_dir().path_join(text)
	text = text.simplify_path()
	return _without_trailing_separator(text)


## The canonical REAL path: `absolute()`, with every symlinked component followed
## to what it actually points at, and then every component replaced by the name
## the filesystem itself reports for it.
##
## It resolves the whole path rather than only its directory, so a symlink named
## `prototype_settings.cfg` sitting inside an otherwise unrelated directory
## resolves to the file it targets and is caught by the same comparison that
## catches a symlinked directory. Components that do not exist are left as they
## are, which is what makes this usable on a path before anything creates it —
## and why `same_path()` still has to compare case-blind on a folding filesystem.
static func real_path(path: String) -> String:
	var resolved: String = absolute(path)
	if resolved.is_empty():
		return ""
	var links: DirAccess = DirAccess.open("/")
	if links == null:
		return resolved
	var hops: int = 0
	while hops < MAX_LINK_HOPS:
		var rewritten: String = _follow_first_link(links, resolved)
		if rewritten == resolved:
			break
		resolved = rewritten
		hops += 1
	return _without_trailing_separator(_case_canonical(resolved))


## Replaces every component with the spelling the filesystem reports for it.
##
## Listing a directory returns the names as they are actually stored, and on a
## case-folding volume the listing can be obtained through a wrong-case parent —
## measured on this Mac, `DirAccess.open()` on the lowercased parent still
## returns `Riftwrought — Prototype Zero`. So every spelling of an existing path
## collapses to the one true spelling, exactly the way `read_link()` collapses
## every symlink to one target.
##
## It stops at the first component that does not exist, because nothing below an
## absent directory can be listed, and keeps the rest of the request verbatim. On
## a case-sensitive filesystem it is a no-op by construction: two entries there
## may legitimately differ only by case, and the exact name IS the identity.
static func _case_canonical(path: String) -> String:
	if not compares_paths_case_insensitively():
		return path
	var parts: PackedStringArray = path.trim_prefix("/").split("/", false)
	var built: String = ""
	for index: int in parts.size():
		var actual: String = _entry_named(built if built != "" else "/", parts[index])
		if actual.is_empty():
			var remainder: PackedStringArray = PackedStringArray()
			for tail: int in range(index, parts.size()):
				remainder.append(parts[tail])
			return "%s/%s" % [built, "/".join(remainder)]
		built = "%s/%s" % [built, actual]
	return built if built != "" else path


## The filesystem's own spelling of one entry, or "" when the parent cannot be
## listed or holds nothing that matches. An exact hit wins outright, so a
## case-sensitive volume that happens to be reached here is never rewritten.
static func _entry_named(parent: String, wanted: String) -> String:
	var listing: DirAccess = DirAccess.open(parent)
	if listing == null:
		return ""
	listing.include_hidden = true
	listing.include_navigational = false
	var entries: PackedStringArray = listing.get_directories()
	entries.append_array(listing.get_files())
	for entry: String in entries:
		if entry == wanted:
			return entry
	for entry: String in entries:
		if _same_text(entry, wanted):
			return entry
	return ""


## One hop. Walks the components from the root and rewrites at the FIRST link it
## finds, because following that link can change every component after it.
static func _follow_first_link(links: DirAccess, path: String) -> String:
	var prefix: String = ""
	for part: String in path.trim_prefix("/").split("/", false):
		prefix = "%s/%s" % [prefix, part]
		if not links.is_link(prefix):
			continue
		var target: String = links.read_link(prefix)
		if target.is_empty():
			continue
		if not target.is_absolute_path():
			target = prefix.get_base_dir().path_join(target)
		return (target + path.substr(prefix.length())).simplify_path()
	return path


static func _without_trailing_separator(path: String) -> String:
	var text: String = path
	while text.length() > 1 and text.ends_with("/"):
		text = text.substr(0, text.length() - 1)
	return text


# --- Does this filesystem fold case? -----------------------------------------

## True when two spellings that differ only in case name one file here.
##
## The platform is the starting answer — macOS (APFS/HFS+) and Windows (NTFS) are
## case-insensitive and case-preserving by default, Linux and the BSDs are not —
## but it is only a default: a macOS volume can be formatted case-sensitive and a
## Linux mount can fold case. So the DISK is asked as well, read-only: does the
## Godot user data directory, which certainly exists and is certainly ours,
## also answer to its own name in another case?
##
## A `true` from either source wins, and that asymmetry is deliberate. This
## answer feeds a guard whose job is to REFUSE, so "these two spellings might be
## one directory" is the careful side to be wrong on; the cost of being wrong
## that way is refusing a temporary directory that differs from the production
## one only in case, which no caller has any reason to ask for.
static func compares_paths_case_insensitively() -> bool:
	if _case_folding == -1:
		_case_folding = 1 if _measure_case_folding() else 0
	return _case_folding == 1


static func _measure_case_folding() -> bool:
	var platform: String = OS.get_name()
	if platform == "macOS" or platform == "Windows":
		return true
	var root: String = absolute(PRODUCTION_ROOT)
	if root.is_empty() or not DirAccess.dir_exists_absolute(root):
		return false
	var leaf: String = root.get_file()
	var recased: String = leaf.to_upper() if leaf != leaf.to_upper() else leaf.to_lower()
	if recased == leaf:
		return false  ## nothing in the name has a case to differ in
	return DirAccess.dir_exists_absolute(root.get_base_dir().path_join(recased))


## The one text comparison every path question below is built out of. On a
## folding filesystem it is case-blind, and deliberately generous about HOW: a
## match under Godot's Unicode-aware lowercasing, uppercasing, or `nocasecmp_to`
## is a match. None of the three is full Unicode case folding, and the union of
## three case-blind tests can only ever find MORE collisions than one of them —
## which, for a guard that refuses, is the safe direction to err in.
static func _same_text(first: String, second: String) -> bool:
	if first == second:
		return true
	if not compares_paths_case_insensitively():
		return false
	return (
		first.to_lower() == second.to_lower()
		or first.to_upper() == second.to_upper()
		or first.nocasecmp_to(second) == 0
	)


# --- The two questions everything else is built from -------------------------

## True when two paths name the same file or directory on this disk, however
## differently they spell it. Both sides are canonicalized first.
##
## THIS IS THE ONLY EQUALITY. `same_file()`, `is_production_directory()`,
## `is_production_file()`, `is_inside_production_directory()`, and both stores'
## `uses_production_storage()` all reach the filesystem through here, so a
## spelling that fools one of them cannot fool another.
static func same_path(first: String, second: String) -> bool:
	var left: String = real_path(first)
	var right: String = real_path(second)
	if left.is_empty() or right.is_empty():
		return false
	return _same_text(left, right)


## True when `candidate` sits anywhere INSIDE `ancestor`. A directory is not a
## descendant of itself, which is what keeps "is it the production directory?"
## and "is it inside the production directory?" two separate answers.
static func is_descendant(candidate: String, ancestor: String) -> bool:
	var child: String = real_path(candidate)
	var parent: String = real_path(ancestor)
	if child.is_empty() or parent.is_empty():
		return false
	if _same_text(child, parent):
		return false
	var prefix: String = "%s/" % parent
	if child.length() <= prefix.length():
		return false
	return _same_text(child.substr(0, prefix.length()), prefix)


# --- The production locations ------------------------------------------------

## The project owner's own Godot user data directory, canonical and real.
static func production_directory() -> String:
	return real_path(PRODUCTION_ROOT)


static func production_settings_file() -> String:
	return real_path(PRODUCTION_SETTINGS)


static func production_lab_file() -> String:
	return real_path(PRODUCTION_LAB)


# --- The questions the guards actually ask -----------------------------------

## True when the two path strings name the same file on this disk, however
## differently they spell it. A synonym for `same_path()`, kept because "are
## these the same FILE?" is the question the two stores actually ask.
static func same_file(first: String, second: String) -> bool:
	return same_path(first, second)


## True when this directory IS the project owner's own user data directory —
## spelled as `user://`, as its absolute path, through `.` or `..`, through a
## symlink, or in another case on a filesystem that folds case.
static func is_production_directory(path: String) -> bool:
	return same_path(path, PRODUCTION_ROOT)


## True when this directory sits anywhere INSIDE the user data directory.
##
## No file under there is one of the two versioned files, so this is defence
## rather than necessity — but a verification harness has no business writing,
## corrupting, and deleting files inside the directory that holds the project
## owner's saves, and "no part of it is available as isolated storage" is a
## simpler rule to keep than "only these two names are dangerous".
static func is_inside_production_directory(path: String) -> bool:
	return is_descendant(path, PRODUCTION_ROOT)


## True when this path is one of the two production files.
static func is_production_file(path: String) -> bool:
	return same_path(path, PRODUCTION_SETTINGS) or same_path(path, PRODUCTION_LAB)


## The two files a `--state-dir` would actually end up using, canonical and real,
## so a caller can compare the FILES rather than trusting the directory.
static func files_in(directory: String) -> PackedStringArray:
	var root: String = real_path(directory)
	if root.is_empty():
		return PackedStringArray()
	return PackedStringArray([
		real_path(root.path_join(SETTINGS_FILE_NAME)),
		real_path(root.path_join(LAB_FILE_NAME)),
	])


## A one-line explanation for a log or a refusal message: what was asked for, and
## what it turned out to be.
static func describe(path: String) -> String:
	var resolved: String = real_path(path)
	if resolved == path:
		return path
	return "%s  (resolves to %s)" % [path, resolved]
