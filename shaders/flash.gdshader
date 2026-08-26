shader_type canvas_item;

// Mixes the sprite toward white by `flash` (0 = normal, 1 = full white), keeping alpha.
uniform float flash : hint_range(0.0, 1.0) = 0.0;

void fragment() {
	vec4 tex = texture(TEXTURE, UV);
	COLOR = vec4(mix(tex.rgb, vec3(1.0), flash), tex.a);
}
