#define S(a,b,t) smoothstep(a,b,t)

mat2 Rot(float a)
{
    float s = sin(a);
    float c = cos(a);
    return mat2(c, -s, s, c);
}

vec2 hash( vec2 p )
{
    p = vec2( dot(p,vec2(2127.1,81.17)), dot(p,vec2(1269.5,283.37)) );
    return fract(sin(p)*43758.5453);
}

float noise( in vec2 p )
{
    vec2 i = floor( p );
    vec2 f = fract( p );

    vec2 u = f*f*(3.0-2.0*f);

    float n = mix( mix( dot( -1.0+2.0*hash( i + vec2(0.0,0.0) ), f - vec2(0.0,0.0) ),
                       dot( -1.0+2.0*hash( i + vec2(1.0,0.0) ), f - vec2(1.0,0.0) ), u.x),
                  mix( dot( -1.0+2.0*hash( i + vec2(0.0,1.0) ), f - vec2(0.0,1.0) ),
                      dot( -1.0+2.0*hash( i + vec2(1.0,1.0) ), f - vec2(1.0,1.0) ), u.x), u.y);
    return 0.5 + 0.5*n;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = fragCoord/iResolution.xy;
    float ratio = iResolution.x / iResolution.y;

    vec2 tuv = uv;
    tuv -= .5;

    float degree = noise(vec2(iTime*.05, tuv.x*tuv.y));
    tuv.y *= 1./ratio;
    tuv *= Rot(radians((degree-.5)*720.+180.));

    float frequency = 50.;
    float amplitude = 300.;
    float speed = iTime * 0.02;
    tuv.x += sin(tuv.y*frequency+speed)/amplitude;
    tuv.y += sin(tuv.x*frequency*1.5+speed)/(amplitude*.5);

    // Couleurs Catppuccin Macchiato
    vec3 base = vec3(0.141, 0.153, 0.227);    // #24273A
    vec3 mantle = vec3(0.118, 0.125, 0.188);  // #1E2030
    vec3 crust = vec3(0.094, 0.102, 0.149);
    // in between
    vec3 inBetween = mix(base, crust, 0.66);

    float x = (tuv*Rot(radians(-5.))).x;
    vec3 layer1 = mix(base, inBetween, S(-.3, .2, x));
    vec3 layer2 = mix(mantle, inBetween, S(-.3, .4, x));
    vec3 layer3 = mix(base, mantle, S(-.3, .8, x));

    vec3 finalLayer = mix(layer1, layer2, S(.5, -.3, tuv.y));
    vec3 finalLayer2 = mix(finalLayer, layer3, S(.5, -.3, tuv.y));

    vec3 finalComp = finalLayer2;

    vec4 terminalColor = texture(iChannel0, uv);

    // Define the mask (e.g., based on the luminance of the terminal color)
    float mask = length(terminalColor.rgb - base) < 0.001 ? 1.0 : 0.0;

    // Blend the finalComp color with the terminalColor based on the mask
    vec3 blendedColor = mix(terminalColor.rgb, finalComp, mask);

    fragColor = vec4(blendedColor, terminalColor.a);
}
