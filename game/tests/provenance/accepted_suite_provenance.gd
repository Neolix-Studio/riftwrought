extends RefCounted
## Riftwrought — the accepted-suite provenance engine (Verification Maintenance V1, decision D-342).
##
## THE ONE PLACE THAT READS THE FLAT PROVENANCE STORE. The accepted First-MVP suites J4 to J10 once carried, as
## string constants in their own source, every pair of text they put back to rebuild the files they had moved
## — and every later cascade copied those constants, escaped once more, into the next suite, so the deepest
## literals doubled with each one. D-342 moved every such pair list out of the suites into plain-text store files
## in this directory. A suite now names each pair list only by the SHA-256 of its listing and asks this engine for
## it; a later cascade adds a small store file of its own and never copies an earlier suite's source again.
##
## FORMAT 1. A store file is UTF-8 text named `*.provenance`. Its first line is FORMAT_LINE; lines beginning "#"
## may follow, before the first record. Then come its records — every @text, then every @pairs, then every @edge,
## each group in ascending order of its header line:
##   @text <sha256>          a text, named by the SHA-256 of its content as UTF-8, made of zero or more segments:
##   =<n>                      exactly n bytes of the text's own content, then a newline
##   &<sha256>                 the content of that text record, escaped once as the body of a GDScript string
##                             literal: backslash, double quote, newline and tab written \\ \" \n \t
##   %<sha256>                 that pair list written as an accepted suite writes one inline in a constant: each
##                             pair as the two lines <tab><tab>["after", and <tab><tab><tab>"before"], with both
##                             texts escaped as above
##   @end
##   @pairs <sha256>         an ordered pair list, named by the SHA-256 of its own pair lines:
##   <after> <before>          one line per pair, each a text name: as the later decision wrote it, and as the
##                             earlier one left it
##   @end
##   @edge <decision> <kind> <path> <from> <to> <pairs>
##                           applying that pair list to the file at `path` while it hashes `from` — each pair in
##                           order, to every occurrence — yields the file hashing `to`; `decision` is the one whose
##                           change it puts back, and `kind` is "layer" (a later cascade's) or "rows" (a suite's own)
##
## References are how the history is stored flat. Every escaped copy an old suite carried was a whole pair list
## written inline in a constant, or now and then one text of one; the store keeps each text once, unescaped, and
## each such copy becomes a single `%` or `&` line, however deeply it was once nested.
##
## TRUST. The store is data and is never trusted. A text is accepted only if its content hashes to its name, a pair
## list only if its lines hash to its name; and if any record anywhere is malformed, misnamed, missing, duplicated,
## out of order or unreferenced, the whole store is refused and every id resolves to an empty list, so every
## reconstruction that needs one fails. The trust roots are outside it: each accepted suite pins the SHA-256 of
## every pair list it uses and of this engine; the later accepted runners and the maintenance runner pin those
## suites; and the maintenance runner pins this engine and every store file.

const STORE_DIRECTORY: String = "res://tests/provenance"
const STORE_EXTENSION: String = "provenance"
const FORMAT_LINE: String = "RIFTWROUGHT ACCEPTED-SUITE PROVENANCE 1"
const KINDS: Array[String] = ["layer", "rows"]
const HEX: String = "0123456789abcdef"

static var _loaded: Dictionary = {}


## The store in this directory, parsed and proved once per process.
static func store() -> Dictionary:
	if _loaded.is_empty():
		_loaded = parse(read_directory(STORE_DIRECTORY))
		if not bool(_loaded["valid"]):
			printerr("  provenance store refused: %s" % "; ".join(PackedStringArray(_loaded["refusals"])))
	return _loaded


## Resolves pair-list names: a String to its pair list, a {key: name} Dictionary to {key: pair list}, and rows
## whose last field is a name to the same rows carrying the pair list. A name the store cannot prove resolves to
## an empty list.
static func resolve(ids: Variant) -> Variant:
	var loaded: Dictionary = store()
	if ids is String:
		return _named(loaded, ids)
	if ids is Dictionary:
		var map: Dictionary = {}
		for key: Variant in ids:
			map[key] = _named(loaded, String(ids[key]))
		return map
	var rows: Array = []
	for row: Array in ids:
		var resolved: Array = row.slice(0, row.size() - 1)
		resolved.append(_named(loaded, String(row[row.size() - 1])))
		rows.append(resolved)
	return rows


static func _named(loaded: Dictionary, id: String) -> Array:
	if bool(loaded["valid"]) and not (loaded["pairs"] as Dictionary).has(id):
		printerr("  provenance store holds no pair list named %s" % id)
	return pairs_of(loaded, id)


## The pair list named `id`, as [[after, before], ...], or an empty list.
static func pairs_of(loaded: Dictionary, id: String) -> Array:
	if not bool(loaded.get("valid", false)) or not (loaded["pairs"] as Dictionary).has(id):
		return []
	return (loaded["pairs"][id] as Array).duplicate(true)


## Every store file in a directory, by name, as bytes, in name order.
static func read_directory(directory: String) -> Dictionary:
	var files: Dictionary = {}
	var names: PackedStringArray = DirAccess.get_files_at(directory)
	names.sort()
	for name: String in names:
		if name.get_extension() == STORE_EXTENSION:
			files[name] = FileAccess.get_file_as_bytes(directory.path_join(name))
	return files


## Parses and proves a whole store: {file name: bytes}. Returns {"valid", "refusals", "texts", "pairs", "edges",
## "files"}: every text by name, every pair list by name, every edge as a Dictionary, and each file's own records
## in its own order, for re-serialising.
static func parse(files: Dictionary) -> Dictionary:
	var refusals: Array = []
	var segments: Dictionary = {}
	var listings: Dictionary = {}
	var edges: Array = []
	var layout: Dictionary = {}
	for name: String in files:
		var bytes: PackedByteArray = files[name]
		var record: Dictionary = {"comments": [], "texts": [], "pairs": [], "edges": []}
		layout[name] = record
		var at: int = 0
		var first: Array = _line(bytes, at)
		if first.is_empty() or String(first[0]) != FORMAT_LINE:
			refusals.append("%s does not begin with the format line" % name)
			continue
		at = int(first[1])
		var comments: Array = []
		var last_key: String = ""
		var in_records: bool = false
		while at < bytes.size():
			var header: Array = _line(bytes, at)
			if header.is_empty():
				refusals.append("%s ends inside a line" % name)
				break
			var line: String = header[0]
			at = int(header[1])
			if line.begins_with("#") and not in_records:
				comments.append(line)
				continue
			in_records = true
			var key: String = ""
			if line.begins_with("@text "):
				var id: String = line.substr(6)
				if not _is_name(id):
					refusals.append("%s: a text record is not named by a SHA-256: %s" % [name, line.left(80)])
					break
				var parts: Array = []
				var closed: bool = false
				var broken: bool = false
				while at < bytes.size():
					var segment: Array = _line(bytes, at)
					if segment.is_empty():
						break
					var head: String = segment[0]
					at = int(segment[1])
					if head == "@end":
						closed = true
						break
					if head.begins_with("="):
						var count: String = head.substr(1)
						if count.is_empty() or not count.is_valid_int() or count.begins_with("-") or count.begins_with("+") or (count.length() > 1 and count.begins_with("0")):
							refusals.append("%s: text %s has a malformed length %s" % [name, id.left(8), head.left(24)])
							broken = true
							break
						var length: int = count.to_int()
						if length <= 0 or at + length >= bytes.size() or bytes[at + length] != 10:
							refusals.append("%s: text %s is truncated or its %d-byte segment is not closed" % [name, id.left(8), length])
							broken = true
							break
						var raw: PackedByteArray = bytes.slice(at, at + length)
						var literal: String = raw.get_string_from_utf8()
						if literal.to_utf8_buffer() != raw:
							refusals.append("%s: text %s holds a segment that is not UTF-8" % [name, id.left(8)])
							broken = true
							break
						if not parts.is_empty() and String(parts[parts.size() - 1][0]) == "=":
							refusals.append("%s: text %s has two literal segments in a row" % [name, id.left(8)])
							broken = true
							break
						parts.append(["=", literal])
						at += length + 1
					elif (head.begins_with("&") or head.begins_with("%")) and _is_name(head.substr(1)):
						parts.append([head.left(1), head.substr(1)])
					else:
						refusals.append("%s: text %s has an unknown segment %s" % [name, id.left(8), head.left(24)])
						broken = true
						break
				if broken:
					break
				if not closed:
					refusals.append("%s: text %s is never closed" % [name, id.left(8)])
					break
				if segments.has(id):
					refusals.append("%s: text %s is duplicated" % [name, id.left(8)])
				segments[id] = parts
				(record["texts"] as Array).append(id)
				key = "1 " + id
			elif line.begins_with("@pairs "):
				var id: String = line.substr(7)
				if not _is_name(id):
					refusals.append("%s: a pair list is not named by a SHA-256: %s" % [name, line.left(80)])
					break
				var pairs: Array = []
				var closed: bool = false
				while at < bytes.size():
					var entry: Array = _line(bytes, at)
					if entry.is_empty():
						break
					at = int(entry[1])
					if String(entry[0]) == "@end":
						closed = true
						break
					var fields: PackedStringArray = String(entry[0]).split(" ")
					if fields.size() != 2 or not _is_name(fields[0]) or not _is_name(fields[1]):
						refusals.append("%s: pair list %s has a malformed pair %s" % [name, id.left(8), String(entry[0]).left(40)])
						break
					pairs.append([fields[0], fields[1]])
				if not closed or pairs.is_empty():
					refusals.append("%s: pair list %s is empty or never closed" % [name, id.left(8)])
					break
				if listings.has(id):
					refusals.append("%s: pair list %s is duplicated" % [name, id.left(8)])
				listings[id] = pairs
				(record["pairs"] as Array).append(id)
				key = "2 " + id
			elif line.begins_with("@edge "):
				var fields: PackedStringArray = line.substr(6).split(" ")
				if (fields.size() != 6 or not fields[0].begins_with("D-") or not KINDS.has(fields[1]) or not fields[2].begins_with("res://")
						or not _is_name(fields[3]) or not _is_name(fields[4]) or not _is_name(fields[5]) or fields[3] == fields[4]):
					refusals.append("%s: a malformed edge %s" % [name, line.left(100)])
					break
				edges.append({"decision": fields[0], "kind": fields[1], "path": fields[2], "from": fields[3], "to": fields[4], "pairs": fields[5], "file": name})
				(record["edges"] as Array).append(line)
				key = "3 " + line.substr(6)
			else:
				refusals.append("%s: an unknown line %s" % [name, line.left(60)])
				break
			if key <= last_key:
				refusals.append("%s: records out of order at %s" % [name, key.left(40)])
			last_key = key
		record["comments"] = comments
	# Past this point every record is well formed, so each remaining proof runs whatever the others find: a text
	# that fails does not hide a pair list that fails, or a record nothing names.
	var well_formed: bool = refusals.is_empty()
	var texts: Dictionary = {}
	if well_formed:
		for id: String in segments:
			_expand(id, segments, listings, texts, {}, refusals)
	var pairs: Dictionary = {}
	var referenced: Dictionary = {}
	if well_formed:
		for id: String in segments:
			for part: Array in segments[id]:
				if String(part[0]) == "&":
					referenced[String(part[1])] = true
		for id: String in listings:
			var listing: String = ""
			var resolved: Array = []
			for pair: Array in listings[id]:
				listing += "%s %s\n" % [pair[0], pair[1]]
				for side: String in pair:
					referenced[side] = true
					if not texts.has(side):
						refusals.append("pair list %s names a missing text %s" % [id.left(8), side.left(8)])
				resolved.append([texts.get(pair[0], ""), texts.get(pair[1], "")])
			if listing.sha256_text() != id:
				refusals.append("pair list %s is misnamed: its lines hash to %s" % [id.left(8), listing.sha256_text().left(8)])
			pairs[id] = resolved
		var used: Dictionary = {}
		for edge: Dictionary in edges:
			used[String(edge["pairs"])] = true
			if not listings.has(String(edge["pairs"])):
				refusals.append("an edge for %s names a missing pair list %s" % [String(edge["path"]).get_file(), String(edge["pairs"]).left(8)])
		for id: String in segments:
			if not referenced.has(id):
				refusals.append("text %s is referenced by nothing" % id.left(8))
		for id: String in listings:
			if not used.has(id):
				refusals.append("pair list %s is used by no edge" % id.left(8))
	return {"valid": refusals.is_empty(), "refusals": PackedStringArray(refusals), "texts": texts, "segments": segments,
		"pairs": pairs, "listings": listings, "edges": edges, "files": layout}


## One text's content, proved against its name; every text it references first.
static func _expand(id: String, segments: Dictionary, listings: Dictionary, texts: Dictionary, visiting: Dictionary, refusals: Array) -> String:
	if texts.has(id):
		return texts[id]
	if visiting.has(id):
		refusals.append("text %s references itself" % id.left(8))
		return ""
	if not segments.has(id):
		refusals.append("a reference names a missing text %s" % id.left(8))
		return ""
	visiting[id] = true
	var parts: PackedStringArray = PackedStringArray()
	for part: Array in segments[id]:
		var kind: String = part[0]
		if kind == "=":
			parts.append(String(part[1]))
		elif kind == "&":
			parts.append(escape(_expand(String(part[1]), segments, listings, texts, visiting, refusals)))
		elif listings.has(String(part[1])):
			for pair: Array in listings[String(part[1])]:
				parts.append("\t\t[\"%s\",\n\t\t\t\"%s\"],\n" % [escape(_expand(String(pair[0]), segments, listings, texts, visiting, refusals)),
					escape(_expand(String(pair[1]), segments, listings, texts, visiting, refusals))])
		else:
			refusals.append("text %s renders a missing pair list %s" % [id.left(8), String(part[1]).left(8)])
	visiting.erase(id)
	var text: String = "".join(parts)
	if text.sha256_text() != id:
		refusals.append("text %s is misnamed: its content hashes to %s" % [id.left(8), text.sha256_text().left(8)])
	texts[id] = text
	return text


## A text escaped once as the body of a GDScript string literal.
static func escape(text: String) -> String:
	return text.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n").replace("\t", "\\t")


## Applies each [after, before] pair in order to every occurrence; `unique` is false if any `after` did not occur
## exactly once when its turn came — the same rule every accepted suite's `_put_back()` uses.
static func apply(text: String, pairs: Array) -> Dictionary:
	var unique: bool = true
	for pair: Array in pairs:
		if text.count(String(pair[0])) != 1:
			unique = false
		text = text.replace(String(pair[0]), String(pair[1]))
	return {"text": text, "unique": unique}


## The file at `path`, rebuilt from its `text` to the state hashing `target` through the store's edges, taking
## at each step the first edge in store order that leaves the current state. Returns {"found", "text", "chain"}.
static func rebuild(loaded: Dictionary, path: String, text: String, target: String) -> Dictionary:
	var chain: Array = []
	var seen: Dictionary = {}
	while text.sha256_text() != target:
		var here: String = text.sha256_text()
		if seen.has(here):
			return {"found": false, "text": text, "chain": chain}
		seen[here] = true
		var step: Dictionary = {}
		for edge: Dictionary in loaded["edges"]:
			if String(edge["path"]) == path and String(edge["from"]) == here and _reaches(loaded, path, String(edge["to"]), target, {}):
				step = edge
				break
		if step.is_empty():
			return {"found": false, "text": text, "chain": chain}
		text = String(apply(text, loaded["pairs"][String(step["pairs"])])["text"])
		chain.append(step)
		if text.sha256_text() != String(step["to"]):
			return {"found": false, "text": text, "chain": chain}
	return {"found": true, "text": text, "chain": chain}


## Whether the store's edges lead from `state` to `target` for `path`.
static func _reaches(loaded: Dictionary, path: String, state: String, target: String, seen: Dictionary) -> bool:
	if state == target:
		return true
	if seen.has(state):
		return false
	seen[state] = true
	for edge: Dictionary in loaded["edges"]:
		if String(edge["path"]) == path and String(edge["from"]) == state and _reaches(loaded, path, String(edge["to"]), target, seen):
			return true
	return false


## One store file in its canonical form, from its records: comment lines, text names, pair-list names and edge
## lines, each group already in order. Parsing a file and serialising its records must give back its bytes.
static func serialize(loaded: Dictionary, record: Dictionary) -> String:
	var out: PackedStringArray = PackedStringArray([FORMAT_LINE + "\n"])
	for comment: String in record["comments"]:
		out.append(comment + "\n")
	for id: String in record["texts"]:
		out.append("@text %s\n" % id)
		for part: Array in loaded["segments"][id]:
			if String(part[0]) == "=":
				out.append("=%d\n%s\n" % [String(part[1]).to_utf8_buffer().size(), String(part[1])])
			else:
				out.append("%s%s\n" % [String(part[0]), String(part[1])])
		out.append("@end\n")
	for id: String in record["pairs"]:
		out.append("@pairs %s\n" % id)
		for pair: Array in loaded["listings"][id]:
			out.append("%s %s\n" % [pair[0], pair[1]])
		out.append("@end\n")
	for line: String in record["edges"]:
		out.append(line + "\n")
	return "".join(out)


## A new store file for a later decision, built from plain pair lists and edges, with no reference at all: every
## new text is one literal segment, and a text or pair list the store already holds (`known`, the parsed store)
## is named rather than written again. `pair_lists` is [[[after, before], ...], ...]; each edge is [decision, kind,
## path, from, to, index into pair_lists]. Returns {"text": the file's content, "names": each pair list's name}.
static func compose(known: Dictionary, comments: PackedStringArray, pair_lists: Array, edges: Array) -> Dictionary:
	var texts: Dictionary = {}
	var listings: Dictionary = {}
	var names: PackedStringArray = PackedStringArray()
	for pairs: Array in pair_lists:
		var listing: String = ""
		for pair: Array in pairs:
			for side: String in pair:
				if not (known.get("texts", {}) as Dictionary).has(side.sha256_text()):
					texts[side.sha256_text()] = side
			listing += "%s %s\n" % [String(pair[0]).sha256_text(), String(pair[1]).sha256_text()]
		if not (known.get("listings", {}) as Dictionary).has(listing.sha256_text()):
			listings[listing.sha256_text()] = listing
		names.append(listing.sha256_text())
	var text_names: Array = texts.keys()
	text_names.sort()
	var listing_names: Array = listings.keys()
	listing_names.sort()
	var edge_lines: PackedStringArray = PackedStringArray()
	for edge: Array in edges:
		edge_lines.append("@edge %s %s %s %s %s %s" % [edge[0], edge[1], edge[2], edge[3], edge[4], names[int(edge[5])]])
	edge_lines.sort()
	var out: PackedStringArray = PackedStringArray([FORMAT_LINE + "\n"])
	for comment: String in comments:
		out.append(comment + "\n")
	for id: String in text_names:
		var content: String = texts[id]
		out.append("@text %s\n" % id)
		if not content.is_empty():
			out.append("=%d\n%s\n" % [content.to_utf8_buffer().size(), content])
		out.append("@end\n")
	for id: String in listing_names:
		out.append("@pairs %s\n%s@end\n" % [id, listings[id]])
	for line: String in edge_lines:
		out.append(line + "\n")
	return {"text": "".join(out), "names": names}


static func _line(bytes: PackedByteArray, at: int) -> Array:
	var end: int = bytes.find(10, at)
	if end < 0:
		return []
	return [bytes.slice(at, end).get_string_from_utf8(), end + 1]


static func _is_name(text: String) -> bool:
	if text.length() != 64:
		return false
	for character: String in text:
		if not HEX.contains(character):
			return false
	return true
