float sin_shape(in vec2 uv, in float offset_y) {
  // Wave calculation
  float y = sin((uv.x + iTime * -0.06 + offset_y) * 5.5);
  float x = uv.x * 8.;
  float a = 1.;

  for(int i = 0; i < 5; i++) {
    x *= 0.53562;
    x += 6.56248;
    y += sin(x) * a;
    a *= 0.5;
  }

  return step(0.0, y * 0.08 - uv.y + offset_y);
}

vec2 rotate(vec2 coord, float alpha) {
  float cosA = cos(alpha);
  float sinA = sin(alpha);
  return vec2(coord.x * cosA - coord.y * sinA,
             coord.x * sinA + coord.y * cosA);
}

float get_wave_luminance(in vec2 uv) {
  // Combine multiple wave layers
  return
    sin_shape(uv, 0.3) * 0.2 +
    sin_shape(uv, 0.7) * 0.2 +
    sin_shape(uv, 1.1) * 0.2;
}

// Gaussian blur function for the wave effect
vec3 applyGaussianBlurToWave(vec2 uv, float intensity) {
  // Gaussian kernel weights
  float weights[9] = float[](
    0.077847, 0.123317, 0.077847,
    0.123317, 0.195346, 0.123317,
    0.077847, 0.123317, 0.077847
  );

  vec2 texelSize = 1.0 / iResolution.xy;
  vec3 blurredColor = vec3(0.0);

  // Apply Gaussian blur
  for(int x = -1; x <= 1; x++) {
    for(int y = -1; y <= 1; y++) {
      vec2 offset = vec2(x, y) * texelSize * intensity;
      float lum = get_wave_luminance(uv + offset);
      vec3 waveColor = mix(
        vec3(0.0941, 0.0980, 0.1490), // Crust
        vec3(0.2118, 0.2275, 0.3098), // Surface0
        smoothstep(0.0, 1.0, lum)
      );
      float weight = weights[(x + 1) + (y + 1) * 3];
      blurredColor += waveColor * weight;
    }
  }

  return blurredColor;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
  // Rotate coordinates for wave pattern
  vec2 coord = rotate(fragCoord + vec2(0.0, -300.0), 0.5);
  vec2 uv = coord * 2.0 / iResolution.xy;

  // Sample terminal display buffer
  vec3 terminalColor = texture(iChannel0, fragCoord/iResolution.xy).rgb;

  // Apply Gaussian blur to the wave effect
  float blurIntensity = 8.0; // Adjust blur strength
  vec3 blurredWaveColor = applyGaussianBlurToWave(uv, blurIntensity);

  // Display blurred waveColor if terminalColor is black, otherwise display terminalColor
  float isBlack = step(length(terminalColor), 0.40); // Threshold for "black"
  vec3 finalColor = mix(terminalColor, blurredWaveColor, isBlack);

  fragColor = vec4(finalColor, 1.0);
}
