float N2(vec2 p) {
    return fract(sin(p.x * 100.0 + p.y + 6575.0) * 5647.0);
}

float DistLine(vec2 p, vec2 a, vec2 b) {
     vec2 pa = p - a;
     vec2 ba = b - a;
     float t = clamp(dot(pa, ba) / dot(ba, ba), 0.0, 1.0);
     return length(pa - ba * t);
}

float N21(vec2 p) {
    p = fract(p * vec2(234.34, 567.23));
    p += dot(p, p + 23.56);
    return fract(p.x * p.y);
}

vec2 N22(vec2 p) { 
    float n = N21(p + 0.3);
    return vec2(n, N21(p + n));
}

vec2 GetPos(vec2 id, vec2 offs)  {
    vec2 n = N22(id + offs) * iTime;
    return offs + sin(n) * 0.4; 
}

float Line(vec2 p, vec2 a, vec2 b){
    float d = DistLine(p, a, b);
    float m = smoothstep(0.01, 0.005, d);
    float d2  = length(a - b); 
    m *= smoothstep(1.2, 0.8, d2) + smoothstep(0.05, 0.03, d2);
    return m; 
}

float Layer(vec2 uv) {
    float m = 0.0;
    vec2 gv = fract(uv) - 0.5;
    vec2 id = floor(uv);
    

    float t = iTime * 10.0;

    vec2 p[9];
    int i = 0;
    for (float y = -1.0; y <= 1.0; ++y) {
        for (float x = -1.0; x <= 1.0; ++x) {
            p[i++] = GetPos(id, vec2(x, y));
        }
    }
    
    for (int i = 0;i < 9; ++i) {
        m += Line(gv, p[4], p[i]); 
        
        vec2 j = (p[i] - gv) * 20.0;
        float sparkle = 1.0 / dot(j, j);
        m += sparkle * (sin(t + p[i].x * 10.0) * 0.5 + 0.5);
    }
    m += Line(gv, p[1], p[3]);
    m += Line(gv, p[1], p[5]);
    m += Line(gv, p[7], p[3]);
    m += Line(gv, p[7], p[5]);
    return m;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = (fragCoord.xy  - 0.5 * iResolution.xy) / iResolution.y;
    vec2 mouse = (iMouse.xy / iResolution.xy) - 0.5;
    float gradient = uv.y ;
    vec3 col = vec3(0.0);
    float m = 0.0; 
    float t = iTime * 0.1;



    float s = sin(t);
    float c = cos(t);
    mat2 rot = mat2(c, -s, s, c);
    uv *= rot;
    mouse *= rot;
    for(float i = 0.0; i <= 1.0; i += 1.0 /  4.0) {
        float z = fract(i + t);
        float size = mix(10.0, 0.5 , z);
        float fade = smoothstep(0.0, 0.5,z) * smoothstep(1.0, 0.8, z);
        m += Layer(uv * size + i * 20.0 + mouse) * fade;
    }
      
    vec3 base = sin(t * vec3(0.345, 0.634, 0.567)) * 0.4 + 0.6;
    col =vec3(m) * base;
    col += gradient * base; 
    
    /*
    if (gv.x > 0.48 || gv.y > 0.48) {
        col = vec3(1.0, 0.0, 0.0);
    }
    */
    
    fragColor = vec4(col, 1.0);
}