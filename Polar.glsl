void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = (fragCoord.xy  - 0.5 * iResolution.xy) / iResolution.y;
    
    vec3 col = vec3(0);

    uv.x *= 0.7;
    uv.y -= sqrt(abs(uv.x)) * 0.5;
    float d = length(uv);

    float c = smoothstep(0.3, 0.28, d);

    col = vec3(c);
    
    fragColor = vec4(col, 1.0);
}