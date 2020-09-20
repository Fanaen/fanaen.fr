precision mediump float;

uniform vec2 iResolution;
uniform float iTime;
uniform float iScroll;

uniform float leftMargin;

#define SCROLLBAR_HALFWIDTH 10.
#define SCROLLBAR_HEIGHT 10.
#define SCROLLBAR_RIGHT_MARGIN 100.
#define SCROLLBAR_MAX 1.

struct ScrollBar
{
    float whiteBandWidth;
    float whiteBandCenter;
    float distanceFromWhiteBandCenter;

    float value;
    float normalised;
};

// We display a white band at the same place there is the content on the website
// While we're at it, we use this space as a scrollbar
ScrollBar prepareScrollBar(in vec2 fragCoord, in float vw)
{
    // Place the scroll bar
    float whiteBandWidth = SCROLLBAR_HALFWIDTH * vw;
    float whiteBandCenter = iResolution.x - whiteBandWidth - SCROLLBAR_RIGHT_MARGIN;

    // Compute what the scroll value is
    float scroll = iScroll;
    float normalised = iScroll;

    // Are we on a pixel in the scrollbar or outside
    float distanceFromWhiteBandCenter = abs(fragCoord.x - whiteBandCenter);

    // Return the required data to
    return ScrollBar(
        whiteBandWidth,
        whiteBandCenter,
        distanceFromWhiteBandCenter,
        scroll,
        normalised
    );
}

// It is separated from prepareScrollBar to keep the return in main()
vec4 displayScrollBar(ScrollBar scroll, in vec2 fragCoord)
{
    // Scroll bar
    float isScrollBar = step(0., max(
    abs(fragCoord.y - scroll.value) - SCROLLBAR_HEIGHT,       // Clamp on height
    scroll.distanceFromWhiteBandCenter - 0.9 * scroll.whiteBandWidth)); // Clamp on width

    return vec4(vec3(0.9 * isScrollBar + 0.1 * (1. - isScrollBar)), 1.);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    float vh = iResolution.y / 100.;
    float vw = iResolution.x / 100.;

    // White band on the right + Scrollbar
    ScrollBar scroll = prepareScrollBar(fragCoord, vw);

    // Circle
    vec2 center = vec2(1, 0) * iResolution.xy;
    center.x = scroll.whiteBandCenter - scroll.whiteBandWidth;
    vec3 circleStrokeColor = vec3(0.1);
    float circleRadius = 70. * vh;
    float strokeWidth = 1. * vh;

    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = fragCoord/iResolution.xy;

    // Time varying pixel color
    vec3 col = 0.5 + 0.5 * cos(scroll.normalised+uv.xyx+vec3(0,2,4));

    //
    vec3 altCol1 = vec3(0.1);

    vec2 diff = fragCoord - center;
    float d = length(diff);

    // Hexa
    float isHexa = clamp(scroll.normalised * 3., 0., 1.);
    float hexaRotation = cos(iTime) + 1.;
    float hexaOffset = abs(cos(atan(diff.y, diff.x) * 3. + 2.* iTime)) * 64.;
    float hexaOutside = isHexa * -hexaOffset;
    float hexaInside = isHexa * hexaOffset;

    // Gear
    float isGear = 0.;
    float gearOutside = isGear * (-smoothstep(-0.1, 0.5, cos(atan(diff.y, diff.x) * 20. + (2.* iTime))) * 4. * vh);

    // Addition of all shapes
    float finalDistance = max(d - circleRadius - strokeWidth - hexaOutside - gearOutside, 0.)
    + max(circleRadius - d - strokeWidth - hexaInside, 0.);

    float isCircle = clamp(finalDistance, 0., 1.);

    // Output to screen
    fragColor = vec4((vec3(col) * (1.- isCircle)) + (circleStrokeColor * (isCircle)),1.0);
}

void main() {
    vec4 color = vec4(0.0,0.0,0.0,1.0);
    mainImage(color, gl_FragCoord.xy);
    color.w = 1.0;
    gl_FragColor = color;
}
