float N2(vec2 p) {
    return fract(sin(p.x * 100.0 + p.y + 6575.0) * 5647.0);
}
void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = (fragCoord.xy  - 0.5 * iResolution.xy) / iResolution.y;
    uv = fragCoord / iResolution.xy;
    
    vec2 lv = fract(uv * 10.0);
    vec2 id = floor(uv * 10.0);

    lv = lv * lv*(3.0 - 2.0 * lv);

    float bl = N2(id);
    float br = N2(id + vec2(1.0, 0));
    float b = mix(bl, br, lv.x);

    float tl = N2(id + vec2(0.0, 1.0));
    float tr = N2(id + vec2(1.0, 1.0));
    float t = mix(tl, tr, lv.x);

    float c = mix(b, t, lv.y);
    vec3 col = vec3(c);
    fragColor = vec4(col, 1.0);
}