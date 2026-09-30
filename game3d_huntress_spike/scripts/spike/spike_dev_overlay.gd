class_name SpikeDevOverlay
extends CanvasLayer

## THE F1 DEVELOPER OVERLAY — STARTS HIDDEN (R-01).
##
## A developer surface, NOT a UI foundation: timings, the release marker, counts
## and the retarget map's headline figures, for whoever is inspecting the spike.
## The owner's standing preference since D-382: developer surfaces start hidden
## and stay one key away.

var probe: HuntressSpikeProbe
var prey: PreyState
var hound: StandInHound
var _label: Label

func build() -> void:
	layer = 21
	_label = Label.new()
	_label.name = "DevOverlayText"
	_label.position = Vector2(16, 14)
	_label.add_theme_font_size_override("font_size", 13)
	_label.add_theme_color_override("font_color", Color(0.85, 0.92, 0.85))
	_label.add_theme_color_override("font_outline_color", Color(0, 0, 0))
	_label.add_theme_constant_override("outline_size", 4)
	add_child(_label)
	visible = false

func set_enabled(v: bool) -> void:
	visible = v

func toggle() -> void:
	visible = not visible

func _process(_delta: float) -> void:
	if not visible or probe == null:
		return
	var d := probe.driver
	var c := probe.commitment
	var rt := d.retarget
	var t := PackedStringArray()
	t.append("DEVELOPER OVERLAY (F1) — diagnostic, not a UI foundation")
	t.append("commitment: %s  policy=%s  elapsed=%.3f / %.3f s  marker=%.4f  phase=%s" % [
		"ACTIVE" if c.active else "idle", c.policy_name(), c.elapsed, c.duration, c.release_marker, c.phase()])
	t.append("timeline (authored): T_full=%.4f  T_rel=%.4f  T_total=%.4f  (measured)" % [d.t_full, d.t_rel, d.t_total])
	t.append("clip: %s @ %.3f s  tau=%.3f  align_w=%.2f  alpha_h=%.1f°  alpha_r=%.1f°" % [
		d.current_clip, d.current_clip_time, d.tau, d.align_w, rad_to_deg(d.alpha_h), rad_to_deg(d.alpha_r)])
	t.append("uses=%d  arrows released=%d  projectiles spawned=%d  hits=%d  recovery cancels=%d  refused=%d  buffered=%d" % [
		probe.bow_uses, probe.arrows_released, ArrowProjectile.spawned, ArrowProjectile.hits,
		probe.recovery_cancels, c.cancels_refused, probe.buffered_moves])
	t.append("speed=%.3f m/s  probe bolt shots_fired=%d (must stay 0)" % [probe.motor.speed(), probe.shots_fired])
	t.append("retarget: %d pairs · %d derived · %d rest-held · %d source unmapped · leg ratio %.3f" % [
		rt.pairs.size(), rt.derived.size(), rt.rest_held.size(), rt.unmapped_source.size(), rt.leg_ratio])
	t.append("nock moment: huntress %.3f s  control %.3f s" % [d.nock_tau_h, d.nock_tau_r])
	if prey != null:
		t.append("prey: %s  designations=%d switches=%d refused(non-direct)=%d clears(death/removal)=%d/%d" % [
			prey.current_name(), prey.designations, prey.switches, prey.refused_non_direct,
			prey.clears_death, prey.clears_removal])
	if hound != null:
		t.append("hound: target=%s (%s)  bites=%d  speed=%.2f" % [hound.target_name(), hound.target_reason, hound.bites, hound.speed])
	_label.text = "\n".join(t)
