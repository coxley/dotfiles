
void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    // Sample the existing terminal image
    vec3 base = texture(iChannel0, fragCoord / iResolution.xy).rgb;

    float cell_width = 16.0;
    float line_x = 92.0 * cell_width;

    // Distance in pixels from our guide line
    float dist = abs(fragCoord.x - line_x);

    // Thickness in pixels
    float thickness = 1.0;

    // Smooth alpha around the line
    float line_alpha = smoothstep(thickness, 0.0, dist);

    // Line color
    vec3 line_color = vec3(0.5); // mid gray

    vec3 color = mix(base, line_color, line_alpha);
    fragColor = vec4(color, 1.0);
}
