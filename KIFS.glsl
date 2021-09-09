vec2 N(float angle) 
{
  return vec2(sin(angle), cos(angle));
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = (fragCoord.xy  - 0.5 * iResolution.xy) / iResolution.y;
    vec2 mouse = iMouse.xy / iResolution.xy;
    uv *= 1.25;

    float pi = 3.145926;   
    
    vec3 col = vec3(0);
    uv.x = abs(uv.x);
    uv.y += tan(5.0 / 6.0 * pi) * 0.5;

    vec2 n = N(5.0 / 6.0 * pi);
    float d = dot(uv - vec2(0.5, 0.0), n);
    uv -= n * max(0.0, d) * 2.0;
    

    float angle =  (2.0 / 3.0) * pi;  //mouse.x * 3.14159;//../ 2.0; 

    n =  N(2.0 / 3.0 * pi);
    float scale = 1.0;
    uv.x += 0.5;
    for (int i = 0; i < 5 ; ++i)
    {
        uv *= 3.0;    
        scale *= 3.0;
        uv.x -= 1.5;

        uv.x = abs(uv.x);
        uv.x -= 0.5;
        uv -= n * min(0.0, dot(uv, n)) * 2.0;
    }
    

    d = length(uv - vec2(clamp(uv.x, -1.0, 1.0), 0.0));
    col += smoothstep(1.0 / iResolution.y, 0.00, d / scale);

    //col.rg += uv; 
    
    fragColor = vec4(col, 1.0);
}