shader_type canvas_item;
uniform vec4 outline_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float width : hint_range(0.0, 10.0, 1.0) = 1.0;

//Blinking modulates the base color.
//Set blink_time_scale to 0 if you don't want blinking.
uniform vec4 blink_color : source_color = vec4(1.0);
uniform float blink_time_scale : hint_range(0.0, 10.0, 0.1) = 0.0;

// New: Grayscale uniform. 0.0 = normal color, 1.0 = fully grayscale.
uniform float grayscale : hint_range(0.0, 1.0) = 0.0;


void fragment() {    
	vec2 pixel_size = TEXTURE_PIXEL_SIZE;
    float max_alpha = 0.0;

    // Loop to check a grid of pixels around the current one
    for (float x = -width; x <= width; x += 1.0) {
        for (float y = -width; y <= width; y += 1.0) {
            // Find the highest alpha value in the neighborhood
            max_alpha = max(max_alpha, texture(TEXTURE, UV + pixel_size * vec2(x, y)).a);
        }
    }
	
    bool outline = max_alpha > 0.0 && texture(TEXTURE, UV).a == 0.0;
    
    COLOR = texture(TEXTURE, UV); // Start with the original texture color
    COLOR = mix(COLOR, COLOR * blink_color, 0.5 - 0.5 * cos(TIME * blink_time_scale));

    // Apply grayscale effect
    float luminance = dot(COLOR.rgb, vec3(0.299, 0.587, 0.114));
    vec3 gray = vec3(luminance);
    COLOR.rgb = mix(COLOR.rgb, gray, grayscale);

    COLOR = mix(COLOR, outline_color, float(outline)); // Use mix for the final color


}