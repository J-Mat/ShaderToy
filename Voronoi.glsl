vec2 N22(vec2 p) {
    vec3 a = fract(p.xyx * vec3(123.43, 653.23, 205.57));
    a += dot(a, a * 45.0);
    return fract(vec2(a.x * a.y, a.y * a.z));
}
void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = (2.0 * fragCoord.xy  - iResolution.xy) / iResolution.y;

    float t = iTime;
    float m = 0.0;
    float minDist = 100.0;
    vec3 col = vec3(0.0);
    if (false){
        for (float i = 0.3; i < 50.0; i++) 
        {
            vec2 n = N22(vec2(i));
            vec2 p = sin(n * t);
            float d = length(uv - p);
            m += smoothstep(0.02, 0.01, d);  
            minDist = min(d, minDist);
        }
    } else {
        uv *= 20.0;
        vec2 gv = fract(uv) - 0.5;
        vec2 id = floor(uv);

        for (float y = -1.0; y <= 1.0; ++y){
            for (float x = -1.0; x <= 1.0; ++x) {
                vec2 offset = vec2(x, y);
                vec2  n = N22(id + offset);
                vec2  p = offset + sin(n * t) * 0.5;
                float d = length(gv - p);
                minDist = min(d, minDist);
            }
        }
    }
    col = vec3(minDist);
    fragColor = vec4(col, 1.0);
}