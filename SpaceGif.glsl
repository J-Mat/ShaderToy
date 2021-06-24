void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = (fragCoord.xy  - 0.5 * iResolution.xy) / iResolution.y;
    
    vec3 col = vec3(0);
    uv *= 10.0;
    vec2 gv = fract(uv) - 0.5;    
    vec2 id = floor(uv);

    float d = length(gv);
    float m = 0.0;
    float t = iTime; 

    for (float y = -1.0; y <= 1.0; ++y) {
        for (float x = -1.0; x <= 1.0; ++x) {
            vec2 offs = vec2(x, y);
            
            float d = length(gv - offs);
            float dist = length(id + offs) * 0.3;
            float r = mix(0.3, 1.5, sin(t + dist) * 0.5 + 0.5);
            m += smoothstep(r, r * 0.9, d);
        }
    }

    col += mod(m, 2.0);
    
    fragColor = vec4(col, 1.0);
}