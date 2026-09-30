class_name BonePose
extends RefCounted

## ============================================================================
## PORTED UNDER D-392 FROM THE ACCEPTED D-388 SPIKE -- TEMPORARY PLACEHOLDER.
## ============================================================================
## Source: game3d_huntress_spike/scripts/spike/bone_pose.gd, accepted under D-389 as
## PROTOTYPE FEASIBILITY EVIDENCE ("viable for prototype only"). The owner's
## D-392 ruling: "The CC0 KayKit bow clips and the D-388 retarget/hand-contact
## approach may be ported only as explicitly temporary placeholder animation.
## Preserve provenance. Do not present them as final production animation or fix
## the five accepted polish debts." NOTHING here is final animation. The spike
## itself is NOT edited and NOT referenced at runtime: this is a copy, adapted as
## stated below, and every value it reads lives in HuntressConfig.
## ADAPTED: nothing -- behaviour unchanged.
## (The paragraphs below are the spike's own documentation, kept as provenance;
## where they say "the spike" they mean the source this was ported from.)

## A skeleton pose in LOCAL bone space: one position, rotation and scale per bone.
##
## Plain data, deliberately. Every pose the spike shows is built from these by
## sampling a clip at MECHANICAL time and blending, so a crossfade, a snapshot
## and a retarget are all arithmetic the suite can check exactly.

var pos: PackedVector3Array = PackedVector3Array()
var rot: Array[Quaternion] = []
var scl: PackedVector3Array = PackedVector3Array()
## Per bone, a bit mask of the channels a clip ACTUALLY animates (1 position,
## 2 rotation, 4 scale); an unset channel holds only the sampling rig's rest. The
## native control keeps ITS OWN rest for unset channels -- that is what "native"
## means (V27 measured the difference before this existed: 0.056 degrees).
var tracked: PackedByteArray = PackedByteArray()

static func sized(n: int) -> BonePose:
	var p := BonePose.new()
	p.pos.resize(n)
	p.scl.resize(n)
	p.rot.resize(n)
	p.tracked.resize(n)
	for i in n:
		p.rot[i] = Quaternion.IDENTITY
		p.scl[i] = Vector3.ONE
	return p

func size() -> int:
	return rot.size()

func copy() -> BonePose:
	var p := BonePose.new()
	p.pos = pos.duplicate()
	p.scl = scl.duplicate()
	p.rot = rot.duplicate()
	p.tracked = tracked.duplicate()
	return p

func local_transform(i: int) -> Transform3D:
	return Transform3D(Basis(rot[i]).scaled(scl[i]), pos[i])

## Blends `a` toward `b` by `w` in [0, 1]. When `mask` is non-empty, only the
## bones it lists blend; every other bone takes `b` outright -- which is how the
## hold -> release transition keeps the string-hand snap crisp while the legs
## ease across the measured 13.1 degree gap.
static func blend(a: BonePose, b: BonePose, w: float, mask: PackedInt32Array = PackedInt32Array()) -> BonePose:
	var n := b.size()
	var out := BonePose.sized(n)
	var ww := clampf(w, 0.0, 1.0)
	for i in n:
		var wi := ww
		if not mask.is_empty() and not mask.has(i):
			wi = 1.0
		out.pos[i] = a.pos[i].lerp(b.pos[i], wi)
		out.scl[i] = a.scl[i].lerp(b.scl[i], wi)
		out.rot[i] = a.rot[i].slerp(b.rot[i], wi).normalized()
		var ta_ := a.tracked[i] if i < a.tracked.size() else 0
		var tb_ := b.tracked[i] if i < b.tracked.size() else 0
		out.tracked[i] = ta_ | tb_
	return out

## Smoothstep, for crossfade weights.
static func ease(x: float) -> float:
	var t := clampf(x, 0.0, 1.0)
	return t * t * (3.0 - 2.0 * t)
