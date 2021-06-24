float N2(vec2 p) {
    return fract(sin(p.x * 100.0 + p.y + 6575.0) * 5647.0);
}
void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = (fragCoord.xy  - 0.5 * iResolution.xy) / iResolution.y;
    vec3 col = vec3(0.0);
    uv *= 5.0;
    vec2 gv = fract(uv) - 0.5;
    
    float mask = smoothstep(0.01, -0.01, abs(gv.x + gv.y) - 0.01);
    mask = abs(gv.x + gv.y) - 4.0;
    col += mask;
    
    if (gv.x > 0.48 || gv.y > 0.48) {
        col = vec3(1.0, 0.0, 0.0);
    }
    
    fragColor = vec4(col, 1.0);
}