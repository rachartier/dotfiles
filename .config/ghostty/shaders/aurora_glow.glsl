// Soft aurora for Ghostty in the background's own color: drifting light and
// shadow blobs, two aurora ribbons and a glow under the cursor, all as lighter
// or darker shades of the background, composited only onto background pixels.

// -- CONFIGURATION --
const float SPEED       = 0.12;  // time scale; the mesh takes about 2 min to loop
// Brightness offsets are relative to the background (0.08 = 8 % lighter).
const float LIGHT       = 0.04;  // lift of the light blobs
const float DARK        = 0.22;  // depth of the shadow blobs
const float RIBBON      = 0.07;  // lift of the aurora ribbons
const float RAYS        = 0.55;  // vertical ray texture inside the ribbons (0 = smooth bands)
const float CURSOR_GLOW = 0.04;  // lift around the cursor (0 = off)
const float WARP        = 0.60;  // organic wobble of the blob edges
const float BREATHE     = 0.25;  // slow global pulse of the effect (0 = steady)
const float VIGNETTE    = 0.0;  // edge darkening
const float CORNER      = 0.0;  // extra darkening toward the bottom-left prompt area
const float DITHER      = 1.0 / 255.0; // anti-banding noise amplitude
const float FLIP_Y      = 0.0;   // set to 1.0 if the ribbons sit at the bottom instead of the top
// With alpha-blending linear/linear-corrected (Linux default) iChannel0 is an sRGB
// texture, so samples arrive linear while the color uniforms stay sRGB-encoded.
// Set to false for alpha-blending = native (macOS default).
const bool LINEAR_CHANNEL = true;
// Second background that also gets the effect, in its own darker shade: tmux
// inactive panes (window-style bg=$COLOR_mantle). Update when switching themes.
const vec3 ALT_BG = vec3(30.0, 32.0, 48.0) / 255.0; // #1e2030

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
    for (int i = 0; i < 3; i++) {
        sum += amp * valueNoise(p);
        p = OCTAVE_ROT * p * 2.02;
        amp *= 0.5;
    }
    return sum / 0.875;
}

// Gaussian blob: soft falloff with no visible edge.
float blob(vec2 p, vec2 center, float radius) {
    vec2 d = p - center;
    return exp(-dot(d, d) / (radius * radius));
}

// Aurora curtain: thin bright base that fades slowly upward, like real aurora.
float ribbon(vec2 p, float height, float phase, float t) {
    float y = height
            + 0.10 * sin(p.x * 1.4 + t * 1.3 + phase)
            + 0.05 * sin(p.x * 3.1 - t * 0.9 + phase * 2.0);
    float d = p.y - y;
    float body = d > 0.0 ? exp(-d * 5.0) : exp(-d * d * 220.0);
    float rays = valueNoise(vec2(p.x * 5.0 + phase * 7.0, t * 0.6));
    rays = mix(1.0, 0.35 + 0.9 * rays, RAYS);
    // Fade the ribbon ends so it never touches the window sides at full strength.
    float span = 1.0 - smoothstep(0.35, 1.0, abs(p.x + 0.25 * sin(t * 0.5 + phase)));
    return body * rays * span;
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

    // Field: three blobs on slow Lissajous orbits over a lightly warped plane.
    vec2 w = uv + WARP * (vec2(fbm(uv * 1.3 + vec2(0.0, t)),
                               fbm(uv * 1.3 + vec2(4.7, -t))) - 0.5);
    float aspect = res.x / res.y;
    float bA = blob(w, vec2(0.45 * aspect * sin(t * 0.61),       0.30 * cos(t * 0.47)),       0.70);
    float bB = blob(w, vec2(0.45 * aspect * sin(t * 0.43 + 2.1), 0.32 * cos(t * 0.59 + 1.3)), 0.60);
    float bC = blob(w, vec2(0.40 * aspect * cos(t * 0.37 + 4.0), 0.28 * sin(t * 0.53 + 0.7)), 0.55);

    vec2 rp = vec2(uv.x / aspect * 1.6, uv.y);
    float rA = ribbon(rp, 0.18, 0.0, t);
    float rB = ribbon(rp, 0.05, 2.7, t * 0.8);

    // Shade: one brightness factor; scaling the background keeps its hue.
    float pulse = 1.0 + BREATHE * sin(t * 2.3);
    float shade = 1.0;
    shade += LIGHT * pulse * (bA + 0.7 * bB);
    shade -= DARK * pulse * bC;
    shade += RIBBON * pulse * (rA + 0.8 * rB);

    if (CURSOR_GLOW > 0.0) {
        vec2 cursorCenter = iCurrentCursor.xy + vec2(0.5, -0.5) * iCurrentCursor.zw;
        float cd = length(fragCoord - cursorCenter) / res.y;
        shade += CURSOR_GLOW * exp(-cd * cd * 40.0);
    }

    // Vignette and a slightly darker bottom-left for the prompt.
    shade *= 1.0 - VIGNETTE * smoothstep(0.15, 1.1, dot(uv, uv));
    vec2 corner = uv - vec2(-0.5 * aspect, -0.5);
    shade *= 1.0 - CORNER * (1.0 - smoothstep(0.0, 0.9, length(corner)));

    if (!focused) shade = mix(1.0, shade, UNFOCUSED_MIX);

    // Mask: only pixels that match one of the two backgrounds get the effect.
    // Tight thresholds keep other near-background app panels out.
    float baseMask = 1.0 - smoothstep(0.004, 0.03, distance(termSrgb, base));
    float altMask  = 1.0 - smoothstep(0.004, 0.03, distance(termSrgb, ALT_BG));
    float bgMask = max(baseMask, altMask);
    vec3 effect = (altMask > baseMask ? ALT_BG : base) * shade;

    // Static dither so dark gradients don't band; per-frame noise would shimmer.
    effect += (hash12(fragCoord) - 0.5) * DITHER;

    // Composite: text, app cell backgrounds, selection and cursor pass through.
    vec3 outSrgb = mix(termSrgb, clamp(effect, 0.0, 1.0), bgMask);
    fragColor = vec4(LINEAR_CHANNEL ? toLinear(outSrgb) : outSrgb, term.a);
}
