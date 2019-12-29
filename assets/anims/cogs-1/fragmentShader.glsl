precision mediump float;

uniform vec2 iResolution;
uniform float iTime;
uniform float iScroll;

uniform float leftMargin;

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    float vh = iResolution.y / 100.;

    // -- THE COG --
    vec2 center = vec2(1, 0) * iResolution.xy;
    center.x = iResolution.x - leftMargin;
    vec3 circleStrokeColor = vec3(0.1);
    float circleRadius = 70. * vh;
    float strokeWidth = 3. * vh;

    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = fragCoord/iResolution.xy;

    // Color depends on location on screen and scroll value
    vec3 col = 0.5 + 0.5*cos(iScroll+uv.xyx+vec3(0,2,4));

    // Cog pattern
    vec2 diff = fragCoord - center;
    float d = length(diff);
    float cog = -smoothstep(-0.1, 0.5, cos(atan(diff.y, diff.x) * 20. + (2.* iTime))) * 4. * vh;

    float d2 = max(d - circleRadius - strokeWidth - cog , 0.) + max(circleRadius - d - strokeWidth, 0.);
    float isCircle = clamp(d2, 0., 1.);

    // Output to screen
    fragColor = vec4((col * (1.- isCircle)) + (circleStrokeColor * (isCircle)), 1.0);
}

void main() {
    vec4 color = vec4(0.0,0.0,0.0,1.0);
    mainImage(color, gl_FragCoord.xy);
    color.w = 1.0;
    gl_FragColor = color;
}