shader_type canvas_item;

// Uniforms
uniform sampler2D screen_texture : hint_screen_texture;
uniform float grain_amount : hint_range(0.0, 1.0) = 0.05; // Adjust the amount of grain
uniform float grain_size : hint_range(0.1, 10.0) = 1.0; // Adjust the size of the grain

vec3 rgb_to_hsv(vec3 color_rgb) {
    vec4 k = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(color_rgb.bg, k.wz), vec4(color_rgb.gb, k.xy), step(color_rgb.b, color_rgb.g));
    vec4 q = mix(vec4(p.xyw, color_rgb.r), vec4(color_rgb.r, p.yzx), step(p.x, color_rgb.r));

    float d = q.x - min(q.w, q.y);
    float e = 1e-10;

    return vec3(
        abs(q.z + (q.w - q.y) / (6.0 * d + e)),
        d / (q.x + e),
        q.x
    );
}

void fragment() {
    // Sample the original screen texture
    vec4 original_color = texture(screen_texture, SCREEN_UV);

    // Generate random noise
    float noise = (fract(sin(dot(UV, vec2(12.9898, 78.233))) * 43758.5453) - 0.5) * 2.0;

	vec3 hsv = rgb_to_hsv(original_color.rgb);
	float grain_weight = (hsv.z * 0.5) + 0.5;
	
    // Add noise to the original color
    original_color.rgb += noise * grain_amount  * grain_size * grain_weight;

	//COLOR = original_color;
    // Clamp the final color to make sure it stays in the valid range
    COLOR = clamp(original_color, 0.0, 1.0);
}