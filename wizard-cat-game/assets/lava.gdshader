
shader_type canvas_item;

uniform vec4 glow_color : source_color = vec4(1.0, 0.0, 0.0, 1.0);
uniform float glow_strength = 2.0;

void fragment() {
    vec4 tex = texture(TEXTURE, UV);
    COLOR = tex * glow_color;
    COLOR.rgb *= glow_strength;
}
