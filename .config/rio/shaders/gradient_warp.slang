#version 450

// Warped four-corner gradient for Rio, drawn in lighter and darker shades of
// the background. Port of ~/.config/ghostty/shaders/gradient_warp.glsl.

layout(push_constant) uniform Push
{
	vec4 SourceSize;
	vec4 OutputSize;
	uint FrameCount;
	float BG_R;
	float BG_G;
	float BG_B;
	float ALT_R;
	float ALT_G;
	float ALT_B;
} params;

// Set per theme by ~/.config/scripts/fzf_theme.sh through the .slangp preset.
// BG is the terminal background, ALT the tmux inactive-pane background.
#pragma parameter BG_R "Background red" 36.0 0.0 255.0 1.0
#pragma parameter BG_G "Background green" 39.0 0.0 255.0 1.0
#pragma parameter BG_B "Background blue" 58.0 0.0 255.0 1.0
#pragma parameter ALT_R "Inactive pane red" 30.0 0.0 255.0 1.0
#pragma parameter ALT_G "Inactive pane green" 32.0 0.0 255.0 1.0
#pragma parameter ALT_B "Inactive pane blue" 48.0 0.0 255.0 1.0

layout(std140, set = 0, binding = 0) uniform UBO
{
	mat4 MVP;
} global;

#pragma stage vertex
layout(location = 0) in vec4 Position;
layout(location = 1) in vec2 TexCoord;
layout(location = 0) out vec2 vTexCoord;

void main()
{
	gl_Position = global.MVP * Position;
	vTexCoord = TexCoord;
}

#pragma stage fragment
layout(location = 0) in vec2 vTexCoord;
layout(location = 0) out vec4 FragColor;
layout(set = 0, binding = 2) uniform sampler2D Source;

// -- CONFIGURATION --
const float SPEED = 1.0;
// Rio only exposes a frame counter, and strategy = "game" renders uncapped: time is
// frames / FRAME_RATE. Estimated by eye; raise to slow the gradient down. If rio.exe
// gets capped in the GPU driver, set this to the cap.
const float FRAME_RATE = 1200.0;
// Shade of each gradient corner, relative to the background (1.14 = 14 % lighter).
const float SHADE_TOP_LEFT     = 1.14;
const float SHADE_TOP_RIGHT    = 0.78;
const float SHADE_BOTTOM_LEFT  = 1.04;
const float SHADE_BOTTOM_RIGHT = 0.92;
const float STRENGTH = 1.0; // scales every shade offset (0 = off, 2 = double)
const float BLOBS = 1.5;    // pattern density: 2 = twice as many light/dark patches, 0.5 = bigger ones
const float DRIFT = 0.1;    // how far the pattern wanders in X/Y, in screen fractions (0 = fixed)
const float DITHER = 1.0 / 255.0;

float hash12(vec2 p) {
	vec3 p3 = fract(vec3(p.xyx) * 0.1031);
	p3 += dot(p3, p3.yzx + 33.33);
	return fract((p3.x + p3.y) * p3.z);
}

vec2 hash22(vec2 p) {
	vec3 p3 = fract(vec3(p.xyx) * vec3(0.1031, 0.1030, 0.0973));
	p3 += dot(p3, p3.yzx + 33.33);
	return fract((p3.xx + p3.yz) * p3.zy);
}

float gradientNoise(vec2 p) {
	vec2 i = floor(p);
	vec2 f = fract(p);
	vec2 u = f * f * f * (f * (f * 6.0 - 15.0) + 10.0);
	float a = dot(hash22(i) * 2.0 - 1.0, f);
	float b = dot(hash22(i + vec2(1.0, 0.0)) * 2.0 - 1.0, f - vec2(1.0, 0.0));
	float c = dot(hash22(i + vec2(0.0, 1.0)) * 2.0 - 1.0, f - vec2(0.0, 1.0));
	float d = dot(hash22(i + vec2(1.0, 1.0)) * 2.0 - 1.0, f - vec2(1.0, 1.0));
	return 0.5 + 1.2 * mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

mat2 rot(float a) {
	float s = sin(a);
	float c = cos(a);
	return mat2(c, -s, s, c);
}

void main()
{
	vec2 res = params.OutputSize.xy;
	// Rio's frame is already sRGB-encoded (Bgra8Unorm), so no linear round trip.
	vec4 term = texture(Source, vTexCoord);
	vec3 base = vec3(params.BG_R, params.BG_G, params.BG_B) / 255.0;
	vec3 altBg = vec3(params.ALT_R, params.ALT_G, params.ALT_B) / 255.0;

	float t = float(params.FrameCount) / FRAME_RATE * SPEED;
	float ratio = res.x / res.y;
	// Ghostty's y axis points up, Rio's texture coordinates point down.
	vec2 p = vec2(vTexCoord.x, 1.0 - vTexCoord.y) - 0.5;
	// Two unrelated frequencies so the path never visibly repeats.
	p -= DRIFT * vec2(sin(t * 0.23), cos(t * 0.17));

	// Noise-driven rotation; 300 deg = the original 720 deg rescaled to this noise's spread.
	float angle = gradientNoise(vec2(t * 0.1, p.x * p.y));
	p.y /= ratio;
	p *= rot(radians((angle - 0.5) * 300.0 + 180.0));
	p.y *= ratio;
	p *= BLOBS;

	p.x += sin(p.y * 5.0 + t * 2.0) / 30.0;
	p.y += sin(p.x * 7.5 + t * 2.0) / 15.0;
	// Mirror-repeat past the first tile; identity inside [-1, 1] so BLOBS = 1 looks unchanged.
	p = 1.0 - abs(mod(p + 1.0, 4.0) - 2.0);

	float across = smoothstep(-0.3, 0.2, (p * rot(radians(-5.0))).x);
	float top = mix(SHADE_TOP_LEFT, SHADE_TOP_RIGHT, across);
	float bottom = mix(SHADE_BOTTOM_LEFT, SHADE_BOTTOM_RIGHT, across);
	float shade = mix(top, bottom, 1.0 - smoothstep(-0.3, 0.5, p.y));
	shade = 1.0 + (shade - 1.0) * STRENGTH;

	float baseMask = 1.0 - smoothstep(0.004, 0.03, distance(term.rgb, base));
	float altMask  = 1.0 - smoothstep(0.004, 0.03, distance(term.rgb, altBg));
	float bgMask = max(baseMask, altMask);
	vec3 effect = (altMask > baseMask ? altBg : base) * shade;

	vec3 outColor = mix(term.rgb, clamp(effect, 0.0, 1.0), bgMask);
	outColor += (hash12(vTexCoord * res) - 0.5) * DITHER * bgMask;
	FragColor = vec4(outColor, term.a);
}
