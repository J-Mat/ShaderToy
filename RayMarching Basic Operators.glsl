// "ShaderToy Tutorial - Ray Marching Primitives" 
// by Martijn Steinrucken aka BigWings/CountFrolic - 2018
// License Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.
//
// This shader is part of a tutorial on YouTube
// https://youtu.be/Ff0jJyyiVyw

#define MAX_STEPS 100
#define MAX_DIST 100.
#define SURF_DIST .001

mat2 Rot(float a) {
    float s = sin(a);
    float c = cos(a);
    return mat2(c, -s, s, c);
}


float sdCapsule(vec3 p, vec3 a, vec3 b, float r) {
	vec3 ab = b-a;
    vec3 ap = p-a;
    
    float t = dot(ab, ap) / dot(ab, ab);
    t = clamp(t, 0., 1.);
    
    vec3 c = a + t*ab;
    
    return length(p-c)-r;
}

float sdCylinder(vec3 p, vec3 a, vec3 b, float r) {
	vec3 ab = b-a;
    vec3 ap = p-a;
    
    float t = dot(ab, ap) / dot(ab, ab);
    //t = clamp(t, 0., 1.);
    
    vec3 c = a + t*ab;
    
    float x = length(p-c)-r;
    float y = (abs(t-.5)-.5)*length(ab);
    float e = length(max(vec2(x, y), 0.));
    float i = min(max(x, y), 0.);
    
    return e+i;
}

float sdTorus(vec3 p, vec2 r) {
	float x = length(p.xz)-r.x;
    return length(vec2(x, p.y))-r.y;
}

float dBox(vec3 p, vec3 s) {
	return length(max(abs(p)-s, 0.));
}


float GetDist(vec3 p) {
    float pd = p.y;

    vec3 bp = p;
    bp -= vec3(0.0, 1.0, 0.0);
    //bp.xz *= Rot(iTime);

    float bd = dBox(bp, vec3(1.0, 1.0, 1.0));
    
    float sdA = length(p - vec3(0.0, 1.0, 0.0)) - 1.0;
    float sdB = length(p - vec3(1.0, 1.0, 0.0)) - 1.0;
    float sd = mix(sdA, bd,  sin(iTime) * 0.5 + 0.5);
    
    float d = min(pd, sd);
    
    return d;
}

float RayMarch(vec3 ro, vec3 rd) {
	float dO=0.;
    
    for(int i=0; i < MAX_STEPS; i++) {
    	vec3 p = ro + rd*dO;
        float dS = GetDist(p);
        dO += dS;
        if(dO>MAX_DIST || dS<SURF_DIST) break;
    }
    
    return dO;
}

vec3 GetNormal(vec3 p) {
	float d = GetDist(p);
    vec2 e = vec2(.001, 0);
    
    vec3 n = d - vec3(
        GetDist(p-e.xyy),
        GetDist(p-e.yxy),
        GetDist(p-e.yyx));
    
    return normalize(n);
}

float GetLight(vec3 p) {
    vec3 lightPos = vec3(0, 5, 6);
    lightPos.xz += vec2(sin(iTime), cos(iTime))*2.;
    vec3 l = normalize(lightPos-p);
    vec3 n = GetNormal(p);
    
    float dif = clamp(dot(n, l), 0., 1.);
    float d = RayMarch(p+n*SURF_DIST*2., l);
    if(d<length(lightPos-p)) dif *= .1;
    
    return dif;
}

vec3 R(vec2 uv, vec3 p, vec3 lookAt, float zoom) {
    vec3 forward = normalize(lookAt - p);
    vec3 right = normalize(cross(vec3(0.0, 1.0, 0.0), forward));
    vec3 up = cross(forward, right);
    vec3 c = p + forward * zoom;
    vec3 i = c + uv.x * right + uv.y * up;
    vec3 d = normalize(i - p);
    return d;
}


void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = (fragCoord-.5*iResolution.xy)/iResolution.y;
    vec2 m = iMouse.xy/iResolution.xy;

    vec3 col = vec3(0);
    
    vec3 ro = vec3(0.0, 4.0, -5);
    ro.yz *= Rot(-m.y); 
    ro.xz *= Rot(-m.x * 6.0);
    vec3 rd = R(uv, ro, vec3(0.0, 0.0, 0.0), 0.7);
    

    float d = RayMarch(ro, rd);

    if (d < MAX_DIST) {
        vec3 p = ro + rd * d;
        float dif = GetLight(p);
        col = vec3(dif);
    } 
    
    col = pow(col, vec3(.4545));	// gamma correction
    
    fragColor = vec4(col,1.0);
}