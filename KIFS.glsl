void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = (fragCoord.xy  - 0.5 * iResolution.xy) / iResolution.y;
    uv *= 3.0;    
    vec3 col = vec3(0);
    uv.x = abs(uv.x);
    float d = length(uv - vec2(clamp(uv.x, -1.0, 1.0), 0.0));
    col += smoothstep(0.03, 0.0, d);
    col.rg += uv; 
    fragColor = vec4(col, 1.0);
}