// Warped four-corner gradient for Ghostty, drawn in lighter and darker shades
// of the background (same palette and compositing as aurora_glow.glsl).

// -- CONFIGURATION --
const float SPEED = 1.0;
// Shade of each gradient corner, relative to the background (1.14 = 14 % lighter).
const float SHADE_TOP_LEFT     = 1.14; // aurora_glow RIBBON
const float SHADE_TOP_RIGHT    = 0.78; // aurora_glow DARK
const float SHADE_BOTTOM_LEFT  = 1.04; // aurora_glow LIGHT
const float SHADE_BOTTOM_RIGHT = 0.92;
const float STRENGTH = 1.0; // scales every shade offset (0 = off, 2 = double)
const float BLOBS = 1.5;    // pattern density: 2 = twice as many light/dark patches, 0.5 = bigger ones
const float DRIFT = 0.1;    // how far the pattern wanders in X/Y, in screen fractions (0 = fixed)
const float DITHER = 1.0 / 255.0;
// Set to false for alpha-blending = native (macOS default).
const bool LINEAR_CHANNEL = true;
// tmux inactive panes (window-style bg=$COLOR_mantle). Update when switching themes.
const vec3 ALT_BG = vec3(30.0, 32.0, 48.0) / 255.0; // #1e2030

const float UNFOCUSED_TIME = 17.0;
const float UNFOCUSED_MIX  = 0.45;

vec3 toSrgb(vec3 c) {
    return mix(1.055 * pow(c, vec3(1.0 / 2.4)) - 0.055, c * 12.92, vec3(lessThanEqual(c, vec3(0.0031308))));
}

vec3 toLinear(vec3 c) {
    return mix(pow((c + 0.055) / 1.055, vec3(2.4)), c / 12.92, vec3(lessThanEqual(c, vec3(0.04045))));
}

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

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 res = iResolution.xy;
    vec4 term = texture(iChannel0, fragCoord / res);
    vec3 termSrgb = LINEAR_CHANNEL ? toSrgb(term.rgb) : term.rgb;
    vec3 base = iBackgroundColor;

    bool focused = iFocus > 0;
    float t = (focused ? iTime : UNFOCUSED_TIME) * SPEED;
    float ratio = res.x / res.y;
    vec2 p = fragCoord / res - 0.5;
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
    float shade = mix(top, bottom, smoothstep(0.5, -0.3, p.y));
    shade = 1.0 + (shade - 1.0) * STRENGTH;
    if (!focused) shade = mix(1.0, shade, UNFOCUSED_MIX);

    float baseMask = 1.0 - smoothstep(0.004, 0.03, distance(termSrgb, base));
    float altMask  = 1.0 - smoothstep(0.004, 0.03, distance(termSrgb, ALT_BG));
    float bgMask = max(baseMask, altMask);
    vec3 effect = (altMask > baseMask ? ALT_BG : base) * shade;

    vec3 outSrgb = mix(termSrgb, clamp(effect, 0.0, 1.0), bgMask);
    vec3 outColor = LINEAR_CHANNEL ? toLinear(outSrgb) : outSrgb;
    outColor += (hash12(fragCoord) - 0.5) * DITHER * bgMask;
    fragColor = vec4(outColor, term.a);
}
