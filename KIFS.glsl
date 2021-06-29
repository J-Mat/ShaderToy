void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = (fragCoord.xy  - 0.5 * iResolution.xy) / iResolution.y;
    vec2 mouse = iMouse.xy / iResolution.xy;
    uv *= 3.0;    
    vec3 col = vec3(0);

    float pi = 3.145926;   
    
     float angle =  pi * mouse.x;//mouse.x * 3.14159;//../ 2.0; 
    vec2 n = vec2(sin(angle), cos(angle));
    //uv.x = abs(uv.x);
    //uv.x -= 0.5;
     
  //dot(uv, n)
    uv -= n  *  min(dot(uv, n), 0.0) * 2.0;
    col.rg += uv;
    

    float d = length(uv - vec2(clamp(uv.x, -1.0, 1.0), 0.0));
    col += smoothstep(0.03, 0.00, d);

    //col.rg += uv; 
    
    fragColor = vec4(col, 1.0);
}