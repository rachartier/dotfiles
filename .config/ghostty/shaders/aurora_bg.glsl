// Calm aurora background for Ghostty: domain-warped fBm tinted from the theme,
// composited only onto default-background pixels.

// -- CONFIGURATION --
const float SPEED     = 0.04;  // time scale; one full drift takes about 60 s
const float INTENSITY = 0.09;  // how far the background is pulled toward the accents (0..1)
const float SCALE     = 1.10;  // size of the shapes; lower is bigger and softer
const float WARP      = 1.60;  // domain-warp strength; higher is more swirly
const float VIGNETTE  = 0.22;  // edge darkening
const float CORNER    = 0.04;  // extra darkening toward the bottom-left prompt area
const float DITHER    = 1.0 / 255.0; // anti-banding noise amplitude
const float FLIP_Y    = 0.0;   // set to 1.0 if the bottom-left darkening shows up top-left
// With alpha-blending linear/linear-corrected (Linux default) iChannel0 is an sRGB
// texture, so samples arrive linear while the color uniforms stay sRGB-encoded.
// Set to false for alpha-blending = native (macOS default).
const bool LINEAR_CHANNEL = true;

const int ACCENT_A = 4; // blue
const int ACCENT_B = 5; // magenta
const int ACCENT_C = 6; // cyan

const float UNFOCUSED_TIME = 17.0; // frozen time for unfocused splits
const float UNFOCUSED_MIX  = 0.45; // how much of the effect unfocused splits keep

vec3 toSrgb(vec3 c) {
    return mix(1.055 * pow(c, vec3(1.0 / 2.4)) - 0.055, c * 12.92, vec3(lessThanEqual(c, vec3(0.0031308))));
}

vec3 toLinear(vec3 c) {
    return mix(pow((c + 0.055) / 1.055, vec3(2.4)), c / 12.92, vec3(lessThanEqual(c, vec3(0.04045))));
}

// -- NOISE --
float hash12(vec2 p) {
    vec3 p3 = fract(vec3(p.xyx) * 0.1031);
    p3 += dot(p3, p3.yzx + 33.33);
    return fract((p3.x + p3.y) * p3.z);
}

float valueNoise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f * f * f * (f * (f * 6.0 - 15.0) + 10.0); // quintic: no grid creases
    float a = hash12(i);
    float b = hash12(i + vec2(1.0, 0.0));
    float c = hash12(i + vec2(0.0, 1.0));
    float d = hash12(i + vec2(1.0, 1.0));
    return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

// Rotating each octave hides the axis-aligned lattice.
const mat2 OCTAVE_ROT = mat2(0.80, 0.60, -0.60, 0.80);

float fbm(vec2 p) {
    float sum = 0.0;
    float amp = 0.5;
    for (int i = 0; i < 4; i++) {
        sum += amp * valueNoise(p);
        p = OCTAVE_ROT * p * 2.02;
        amp *= 0.5;
    }
    return sum / 0.9375;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 res = iResolution.xy;
    vec4 term = texture(iChannel0, fragCoord / res);
    // Everything below works in sRGB, matching the uniforms.
    vec3 termSrgb = LINEAR_CHANNEL ? toSrgb(term.rgb) : term.rgb;
    vec3 base = iBackgroundColor;

    // Coords: aspect-correct, centered, y up.
    vec2 uv = (fragCoord - 0.5 * res) / res.y;
    uv.y = mix(uv.y, -uv.y, FLIP_Y);
    bool focused = iFocus > 0;
    float t = (focused ? iTime : UNFOCUSED_TIME) * SPEED;

    // Field: two warp layers drifting in opposite directions.
    vec2 p = uv * SCALE;
    vec2 q = vec2(fbm(p + vec2(0.0, t)),
                  fbm(p + vec2(5.2, 1.3) - vec2(t * 0.7, 0.0)));
    vec2 r = vec2(fbm(p + WARP * q + vec2(1.7, 9.2) + 0.15 * t),
                  fbm(p + WARP * q + vec2(8.3, 2.8) - 0.12 * t));
    float f = fbm(p + WARP * r);

    // Color: nudge the theme background toward the accents.
    vec3 accentA = iPalette[ACCENT_A];
    vec3 accentB = iPalette[ACCENT_B];
    vec3 accentC = iPalette[ACCENT_C];
    vec3 effect = base;
    effect = mix(effect, accentA, INTENSITY * smoothstep(0.35, 0.85, f));
    effect = mix(effect, accentB, INTENSITY * 0.7 * smoothstep(0.45, 0.95, r.x));
    effect = mix(effect, accentC, INTENSITY * 0.6 * smoothstep(0.40, 0.90, q.y));

    // Vignette and a slightly darker bottom-left for the prompt.
    float edge = dot(uv, uv);
    effect *= 1.0 - VIGNETTE * smoothstep(0.15, 1.1, edge);
    vec2 corner = uv - vec2(-0.5 * res.x / res.y, -0.5);
    effect *= 1.0 - CORNER * (1.0 - smoothstep(0.0, 0.9, length(corner)));

    if (!focused) {
        float gray = dot(effect, vec3(0.2126, 0.7152, 0.0722));
        effect = mix(base, mix(effect, vec3(gray), 0.5), UNFOCUSED_MIX);
    }

    // Static dither so dark gradients don't band; per-frame noise would shimmer.
    effect += (hash12(fragCoord) - 0.5) * DITHER;

    // Mask: only pixels that match the default background get the effect.
    // Tight thresholds keep near-background app panels (e.g. Catppuccin mantle) out.
    float bgMask = 1.0 - smoothstep(0.004, 0.03, distance(termSrgb, base));
    // Fallback for builds without iBackgroundColor (dark themes only):
    // float luma = dot(termSrgb, vec3(0.2126, 0.7152, 0.0722));
    // float bgMask = 1.0 - smoothstep(0.03, 0.18, luma);

    // Composite: text, app cell backgrounds, selection and cursor pass through.
    vec3 outSrgb = mix(termSrgb, clamp(effect, 0.0, 1.0), bgMask);
    fragColor = vec4(LINEAR_CHANNEL ? toLinear(outSrgb) : outSrgb, term.a);
}
