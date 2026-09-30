shader_type spatial;
render_mode unshaded, blend_mix, cull_disabled, depth_draw_opaque, shadows_disabled;

// Riftwrought -- Reference Landing Recreation (NON-CANONICAL) -- Session 7.
//
// Procedural glowing rift-crack ground effect for a flat quad centred on
// SPAWN. No true fracture geometry -- animated cellular ("Worley") noise cell
// boundaries read as a network of thin, pulsing fractures at this project's
// locked 19 m / 55-degree camera, exactly as the session brief allows.
//
// `time` is an explicit uniform, driven every frame from GDScript's own
// accumulated `simulation_seconds` clock (see `vfx_layout.gd`) rather than
// Godot's built-in TIME -- this project's established preference, seen in
// `riftfall_loop_event.gd`, for a clock the calling code owns and can
// therefore replay deterministically in a headless check.
//
// UV space is used directly (not world position), so the quad's own size in
// `vfx_layout.gd` controls the effect's footprint with no coordinate handoff
// between script and shader to keep in sync.

uniform vec3 rift_colour : source_color = vec3(0.482, 0.286, 0.702);
uniform float time = 0.0;
uniform float cell_scale : hint_range(1.0, 20.0) = 5.0;
uniform float crack_width : hint_range(0.001, 0.3) = 0.06;
uniform float pulse_speed : hint_range(0.0, 8.0) = 1.4;
uniform float pulse_strength : hint_range(0.0, 1.0) = 0.4;
uniform float drift_speed : hint_range(0.0, 1.0) = 0.05;
uniform float emission_energy : hint_range(0.0, 10.0) = 3.2;
uniform float base_alpha : hint_range(0.0, 1.0) = 0.5;
uniform float radius_fade_start : hint_range(0.0, 1.0) = 0.55;
uniform float radius_fade_end : hint_range(0.0, 1.0) = 1.0;

vec2 rift_hash(vec2 p) {
	p = vec2(dot(p, vec2(127.1, 311.7)), dot(p, vec2(269.5, 183.3)));
	return fract(sin(p) * 43758.5453123);
}

// Cellular ("Worley") noise: returns (F1, F2), the distances from `uv` to the
// nearest and second-nearest of one jittered feature point per grid cell
// across a 3x3 neighbourhood. `F2 - F1` is small only near a cell boundary,
// which is what reads as a crack network once thresholded below.
vec2 rift_worley(vec2 uv) {
	vec2 cell = floor(uv);
	vec2 local = fract(uv);
	float f1 = 8.0;
	float f2 = 8.0;
	for (int y = -1; y <= 1; y++) {
		for (int x = -1; x <= 1; x++) {
			vec2 neighbour = vec2(float(x), float(y));
			vec2 point = rift_hash(cell + neighbour);
			float dist = length(neighbour + point - local);
			if (dist < f1) {
				f2 = f1;
				f1 = dist;
			} else if (dist < f2) {
				f2 = dist;
			}
		}
	}
	return vec2(f1, f2);
}

void fragment() {
	vec2 centred = (UV - vec2(0.5)) * 2.0;
	float radius = length(centred);

	vec2 drift = vec2(time * drift_speed, time * drift_speed * 0.6);
	vec2 sample_uv = centred * cell_scale + drift;
	vec2 cells = rift_worley(sample_uv);
	float border = cells.y - cells.x;

	float pulse = 0.5 + 0.5 * sin(time * pulse_speed);
	float width = crack_width * (1.0 - pulse_strength + pulse_strength * pulse * 2.0);
	float crack = 1.0 - smoothstep(0.0, max(width, 0.001), border);

	float fade = 1.0 - smoothstep(radius_fade_start, radius_fade_end, radius);
	float glow = crack * fade;

	ALBEDO = rift_colour * 0.35;
	EMISSION = rift_colour * emission_energy * glow * (0.65 + 0.35 * pulse);
	ALPHA = clamp(glow * base_alpha + glow * glow * 0.5, 0.0, 1.0) * fade;
}
