shader_type spatial;
render_mode ambient_light_disabled;
uniform vec4 shadow_color: source_color = vec4(0.2);
uniform float light_division: hint_range(0.0, 1.0) = 0.5;
uniform float division_size: hint_range(0.0, 1.0) = 0.5;
uniform float transition_smoothness: hint_range(0.0, 1.0) = 1.0;
uniform vec4 transition_color: source_color = vec4(1.0);
uniform vec4 rim_color: source_color = vec4(0.0);
uniform float rim_strenght = 0.5;
uniform sampler2D albedo_texture;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	ALBEDO = texture(albedo_texture, UV).rgb;
	float rim_dot_product = 1.0 - dot(VIEW, NORMAL);
	float rim_intensity = pow(smoothstep(0.0, 2.0, rim_dot_product) * 2.0, 1);
	ALBEDO += rim_intensity * rim_strenght * rim_color.rgb;
	// Called for every pixel the material is visible on.
}

void light() {
	DIFFUSE_LIGHT += clamp(dot(NORMAL, LIGHT), 0.0, 1.0) * ATTENUATION * LIGHT_COLOR / PI;
	float r = DIFFUSE_LIGHT.r;
	float g = DIFFUSE_LIGHT.g;
	float b = DIFFUSE_LIGHT.b;
	float division_min = division_size * light_division;
	if(r > light_division){
		DIFFUSE_LIGHT = vec3(1.0);
		r = 1.0;
		g = 1.0;
		b = 1.0;
	}else if(r < division_min){
		DIFFUSE_LIGHT = shadow_color.rgb;
		r = shadow_color.r;
		g = shadow_color.g;
		b = shadow_color.b;
	}else{
		r = mix(transition_color.r, 1.0, (r - division_min) / (light_division - division_min));
		g = mix(transition_color.g, 1.0, (g - division_min) / (light_division - division_min));
		b = mix(transition_color.b, 1.0, (b - division_min) / (light_division - division_min));
		DIFFUSE_LIGHT = vec3(r,g,b);
	}
}
