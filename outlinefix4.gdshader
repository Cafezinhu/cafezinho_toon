shader_type spatial;
render_mode unshaded;

uniform vec4 color: source_color;
uniform float d = 1.0;
uniform sampler2D abc: hint_depth_texture;

void vertex() {
	// Called for every vertex the material is visible on.
}

float calculate_distance(float depth, vec2 uv, mat4 proj_matrix){
	#if CURRENT_RENDERER == RENDERER_COMPATIBILITY
	vec3 ndc = vec3(uv, depth) * 2.0 - 1.0;
	#else
	vec3 ndc = vec3(uv * 2.0 - 1.0, depth);
	#endif
	vec4 view = proj_matrix * vec4(ndc, 1.0);
  	view.xyz /= view.w;
  	float linear_depth = -view.z;
	return linear_depth;
}

void fragment() {
	float self_distance_to_camera = calculate_distance(FRAGCOORD.z, SCREEN_UV, INV_PROJECTION_MATRIX);
	float depth_texture_linear = calculate_distance(texture(abc, SCREEN_UV).r, SCREEN_UV, INV_PROJECTION_MATRIX);
	if(self_distance_to_camera > depth_texture_linear - d){
		ALPHA = 0.0;
	}
	ALBEDO = color.rgb;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
