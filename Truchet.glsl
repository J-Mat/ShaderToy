float Hash21(vec2 p) {
    p = fract(p * vec2(234.34, 324.45));
    p += dot(p, p + 34.5);
    return fract(p.x * p.y);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = (fragCoord.xy  - 0.5 * iResolution.xy) / iResolution.y;
    vec3 col = vec3(0.0);
    uv *= 10.0;
    vec2 gv = fract(uv) - 0.5;
    vec2 id = floor(uv);
    float width = 0.1;
    float n = Hash21(id);
    if  (n < 0.5)
    {
        gv.x *= -1.0;
    }
    float d = abs(abs(gv.x + gv.y) - 0.5);
    vec2 cUv = gv - sign(gv.x + gv.y + 0.001) * 0.5;
    d = length(cUv) - 0.5;
    float mask = smoothstep(0.01, -0.01, abs(d) - width);
    float angle = atan(cUv.x, cUv.y); // -pi to pi;
    float checker = mod(id.x + id.y, 2.0) * 2.0 - 1.0;
    float flow = sin(iTime + checker * angle * 10.0);

    col += flow  * mask; 
    
    if (gv.x > 0.48 ||  gv.y > 0.48) col = vec3(1.0, 0.0, 0.0);
    
    fragColor = vec4(col, 1.0);
}