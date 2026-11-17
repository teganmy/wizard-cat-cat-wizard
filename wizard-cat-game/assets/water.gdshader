shader_type canvas_item;

uniform float wave_speed = 0.6;
uniform float wave_scale = 0.15;
uniform float strength = 0.12;

varying vec2 pos;

void vertex() {
	pos = VERTEX;
}

void fragment() {
	COLOR = texture(TEXTURE, UV);
	COLOR.rgb += sin((pos.x - pos.y) * wave_scale * 0.7 - TIME * wave_speed * 0.6) * strength * 0.5;
}