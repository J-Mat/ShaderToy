float TaperBox(vec2 p, float wb, float wt, float yb, float yt, float blur)
{
	float m = smoothstep(-blur, blur, p.y - yb);
	m *= smoothstep(blur, -blur, p.y - yt);
	p.x = abs(p.x);
	float w = mix(wb, wt, (p.y - yb) / (yt - yb));
	m *= smoothstep(blur, -blur, p.x - w);
	return m;
}

vec4 Tree(vec2 uv, vec3 col, float blur)
{
	float m = TaperBox(uv, 0.03, 0.03, -0.5, 0.25, blur); // trunk
	m += TaperBox(uv, 0.2, 0.1, 0.25, 0.5, blur);
	m += TaperBox(uv, 0.15, 0.05, 0.5, 0.75, blur);
	m += TaperBox(uv, 0.1, 0.0, 0.75, 1.0, blur);

	float shadow = TaperBox(uv - vec2(0.2, 0.0), 0.1, 0.5, 0.15, 0.25, blur);
	shadow += TaperBox(uv + vec2(0.25, 0.0), 0.1, 0.5, 0.45, 0.5, blur);
	shadow += TaperBox(uv - vec2(0.25, 0.0), 0.1, 0.5, 0.7, 0.75, blur);
	col -= shadow * 0.8;
	return vec4(col, m);
}

float GetHeight(float x)
{
	return sin(x * 0.45) + sin(x)  * 0.3;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 uv = (fragCoord- .5 * iResolution.xy) / iResolution.xy;

	uv.x += iTime * 0.1;
	uv *= 5.0;

	vec4 col = vec4(0.0);
	float blur = 0.005;
	float id = floor(uv.x);
	float n = fract(sin(id * 345.34) * 3455.9) * 2.0 - 1.0; 
	float x = n * 0.3;  
	float y = GetHeight(uv.x);
	
	col += smoothstep(blur, -blur, uv.y + y); // ground
	
	y = GetHeight(id + 0.5 + x);

	uv.x = fract(uv.x) - 0.5;
	vec4 tree = Tree((uv - vec2(x, -y)) * vec2(1.0, 1.0 + n * 0.2),  vec3(1.0), blur);
	
	col = mix(col, tree, tree.a);

	float thickness = 1.0 / iResolution.y;
	if (abs(uv.x) < thickness) col.g = 1.0;
	if (abs(uv.y) < thickness) col.r = 1.0;
	fragColor = col;
}