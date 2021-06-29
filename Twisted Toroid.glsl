void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = (fragCoord-.5*iResolution.xy)/iResolution.y;
    float t = iTime * .1;
    
    uv *= mat2(cos(t), -sin(t), sin(t), cos(t));
    
    vec3 ro = vec3(0, 0, -1);
    vec3 lookat = mix(vec3(0), vec3(-1, 0, -1), sin(t*1.56)*.5+.5);
    float zoom = mix(.2, .7, sin(t)*.5+.5);
    
    vec3 f = normalize(lookat-ro),
        r = normalize(cross(vec3(0,1,0), f)),
        u = cross(f, r),
        c = ro + f * zoom,
        i = c + uv.x * r + uv.y * u,
        rd = normalize(i-ro);
    
    float radius = mix(.3, 1.5, sin(t*.4)*.5+.5);
    
    float dS, dO;
    vec3 p;
    
    for(int i=0; i<100; i++) {
    	p = ro + rd * dO;
        dS = -(length(vec2(length(p.xz)-1., p.y)) - radius);
        if(dS<.001) break;
        dO += dS;
    }
    
    vec3 col = vec3(0);

    if(dS<.001) {
    	float x = atan(p.x, p.z)+t*.5;			// -pi to pi
        float y = atan(length(p.xz)-1., p.y);
        
        float bands = sin(y*10.+x*30.);
        float ripples = sin((x*10.-y*30.)*3.)*.5+.5;
        float waves = sin(x*2.-y*6.+t*20.);
        
        float b1 = smoothstep(-.2, .2, bands);
        float b2 = smoothstep(-.2, .2, bands-.5);
        
        float m = b1*(1.-b2);
        m = max(m, ripples*b2*max(0., waves));
        m += max(0., waves*.3*b2);
        
        col += mix(m, 1.-m, smoothstep(-.3, .3, sin(x+t)));
    }
    
    fragColor = vec4(col,1.0);
}