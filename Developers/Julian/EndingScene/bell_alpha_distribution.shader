shader_type canvas_item;

uniform float bell_width = 4.0;

float bell(float x) {
	return exp(-pow(bell_width * (x - 0.5), 2));
}

void fragment() {
	vec4 SCREEN_COLOR = texture(SCREEN_TEXTURE, SCREEN_UV);
	
	COLOR = vec4(COLOR.rgb, sin(SCREEN_UV.y));
	//COLOR = vec4(vec3(1), 0);
}