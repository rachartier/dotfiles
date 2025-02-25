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

    float frequency = 5.;
    float amplitude = 300.;
    float speed = iTime * 0.02;
    tuv.x += sin(tuv.y*frequency+speed)/amplitude;
    tuv.y += sin(tuv.x*frequency*1.5+speed)/(amplitude*.5);

    // Couleurs Catppuccin Macchiato
    vec3 base = vec3(0.141, 0.153, 0.227);    // #24273A
    vec3 mantle = vec3(0.118, 0.125, 0.188);  // #1E2030
    // in between
    vec3 inBetween = mix(base, mantle, 0.25);
    vec3 inBetween2 = mix(base, mantle, 0.75);

    vec3 layer1 = mix(base, inBetween2, S(-.3, .2, (tuv*Rot(radians(-5.))).x));
    vec3 layer2 = mix(inBetween, mantle, S(-.3, .8, (tuv*Rot(radians(-5.))).x));

    vec3 finalLayer = mix(layer1, layer2, S(.5, -.3, tuv.y));


    vec3 finalComp = finalLayer;

    vec4 terminalColor = texture(iChannel0, uv);
    float mask = 1.0 - step(0.5, dot(terminalColor.rgb, vec3(0.955)));
    vec3 blendedColor = mix(terminalColor.rgb, finalComp, mask);

    fragColor = vec4(blendedColor, terminalColor.a);
}
