float HexDist(vec2 p)
{
    p = abs(p);    
    
    float c = dot(p, normalize(vec2(1.0, 1.73)));
    c = max(c, p.x);
    
    return c;
}

vec4 HexCoords(vec2 uv) 
{
  vec2 r = vec2(1.0, 1.73);
    vec2 h = r * 0.5;
    vec2 a = mod(uv, r) - h;
    vec2 b = mod(uv - h, r) - h;
    vec2 gv;
    if (length(a) < length(b))
        gv = a;
    else
        gv = b;
    vec2 id = uv - gv;
    float   x = atan(gv.x, gv.y);
    float y = 0.5 - HexDist(gv);
    return vec4(x, y, id.x, id.y);
}
void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = (fragCoord.xy  - 0.5 * iResolution.xy) / iResolution.y;
    
    vec3 col = vec3(0);

    uv *= 5.0;
    
    vec4 hc = HexCoords(uv);
    float c = smoothstep(0.05, 0.1, hc.y * sin(hc.z * hc.w + iTime));

    col += c;
    
    fragColor = vec4(col, 1.0);

}