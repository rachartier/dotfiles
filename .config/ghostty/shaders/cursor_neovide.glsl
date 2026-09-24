// Port of Neovide's cursor animation (src/renderer/cursor_renderer/mod.rs):
// each corner of the cursor quad follows its own critically damped spring,
// corners facing the travel direction settle faster than the trailing ones.

// -- CONFIGURATION (Neovide defaults) --
const float ANIMATION_LENGTH = 0.150;      // neovide_cursor_animation_length
const float SHORT_ANIMATION_LENGTH = 0.0;  // neovide_cursor_short_animation_length (default 0.04); 0 = no animation while typing
const float TRAIL_SIZE = 1.0;              // neovide_cursor_trail_size

// Corners in Neovide's STANDARD_CORNERS order: TL, TR, BR, BL.
// Ghostty cursor rects are (left, top, width, height) with y pointing up.
vec2 corner(vec4 r, int i) {
    float right = (i == 1 || i == 2) ? 1.0 : 0.0;
    float bottom = (i >= 2) ? 1.0 : 0.0;
    return r.xy + vec2(right * r.z, -bottom * r.w);
}

// Remaining fraction of the jump for a spring released at rest, omega = 4 / length.
float spring(float t, float len) {
    if (len < 1e-4) return 0.0;
    float wt = 4.0 / len * t;
    return (1.0 + wt) * exp(-wt);
}

// Inigo Quilez's polygon SDF, fixed to 4 vertices.
float sdQuad(vec2 p, vec2 v[4]) {
    float d = dot(p - v[0], p - v[0]);
    float s = 1.0;
    for (int i = 0, j = 3; i < 4; j = i, i++) {
        vec2 e = v[j] - v[i];
        vec2 w = p - v[i];
        vec2 b = w - e * clamp(dot(w, e) / max(dot(e, e), 1e-6), 0.0, 1.0);
        d = min(d, dot(b, b));
        bvec3 c = bvec3(p.y >= v[i].y, p.y < v[j].y, e.x * w.y > e.y * w.x);
        if (all(c) || all(not(c))) s = -s;
    }
    return s * sqrt(d);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    fragColor = texture(iChannel0, fragCoord / iResolution.xy);

    vec4 cur = iCurrentCursor;
    vec2 center = cur.xy + vec2(0.5, -0.5) * cur.zw;

    // Ghostty has no cell-size uniform; a bar cursor is thinner than its cell.
    // ponytail: assumes cell width >= 0.55 * height for bar cursors, only affects the short-jump check.
    vec2 cell = vec2(max(cur.z, 0.55 * cur.w), cur.w);

    vec2 dest[4];
    vec2 from[4];
    float align[4];
    float lo = 1e9;
    float hi = -1e9;
    for (int i = 0; i < 4; i++) {
        dest[i] = corner(cur, i);
        from[i] = corner(iPreviousCursor, i);
        vec2 travel = dest[i] - from[i];
        // Neovide gets NaN for a corner that did not move, which ends up fully leading.
        align[i] = length(travel) > 0.0 ? dot(normalize(travel), normalize(dest[i] - center)) : 2.0;
        if (align[i] <= 1.0) {
            lo = min(lo, align[i]);
            hi = max(hi, align[i]);
        }
    }

    float t = iTime - iTimeCursorChange;
    float leading = ANIMATION_LENGTH * clamp(1.0 - TRAIL_SIZE, 0.0, 1.0);
    vec2 quad[4];
    for (int i = 0; i < 4; i++) {
        vec2 jump = (dest[i] - from[i]) / cell;
        float len;
        // Neovide only counts same-row moves; one-row vertical moves are short here too.
        if (abs(jump.x) <= 2.001 && abs(jump.y) <= 1.001) {
            len = min(ANIMATION_LENGTH, SHORT_ANIMATION_LENGTH);
        } else {
            float a = (align[i] <= 1.0 && hi > lo) ? clamp((align[i] - lo) / (hi - lo), 0.0, 1.0) : 1.0;
            len = mix(ANIMATION_LENGTH, leading, a);
        }
        quad[i] = dest[i] + (from[i] - dest[i]) * spring(t, len);
    }

    // Ghostty already draws the real cursor (with its glyph) at the destination.
    vec2 inCursor = step(cur.xy - vec2(0.0, cur.w), fragCoord) * step(fragCoord, cur.xy + vec2(cur.z, 0.0));
    if (inCursor.x * inCursor.y > 0.0) return;

    float coverage = clamp(0.5 - sdQuad(fragCoord, quad), 0.0, 1.0);
    fragColor.rgb = mix(fragColor.rgb, iCurrentCursorColor.rgb, coverage * iCurrentCursorColor.a);
}
