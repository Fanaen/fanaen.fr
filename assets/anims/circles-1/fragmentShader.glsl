precision mediump float;

uniform vec2 iResolution;
uniform float iTime;

uniform float leftMargin;

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // Circle
    vec2 center = vec2(1, 0) * iResolution.xy;
    center.x = iResolution.x - leftMargin;
    float vh = iResolution.y / 100.;
    vec3 circleStrokeColor = vec3(0.1);
    float circleRadius = 70. * vh;
    float strokeWidth = 3. * vh;

    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = fragCoord/iResolution.xy;

    // Time varying pixel color
    vec3 col = 0.5 + 0.5*cos(iTime+uv.xyx+vec3(0,2,4));

    //
    vec3 altCol1 = vec3(0.1);

    vec2 diff = fragCoord - center;
    float d = length(diff);

    // Hexa
    float eccentricity = asin(diff.x/d) * 2.;
    //float eccentricity2 = (cos(iTime) + 1.) * -abs(cos(atan(diff.y, diff.x) * 3. + 2.* iTime)) * 4.;//atan(diff.x/diff.y);
    //float eccentricity3 = (cos(iTime) + 1.) * abs(cos(atan(diff.y, diff.x) * 3. + 2.*iTime)) * 4.;//atan(diff.x/diff.y);

    // Gear
    float eccentricity2 = /*-(cos(iTime / 2.) + 1.) * */ -smoothstep(-0.1, 0.5, cos(atan(diff.y, diff.x) * 20. + (2.* iTime))) * 4. * vh;//atan(diff.x/diff.y);
    float eccentricity3 = 0. *  (cos(iTime / 2.) + 1.) * abs(cos(atan(diff.y, diff.x) * 3. + (0.33*iTime))) * 4.;//atan(diff.x/diff.y);


    float d2 = max(d - circleRadius - strokeWidth - eccentricity2 , 0.) + max(circleRadius - d - strokeWidth - eccentricity3, 0.);
    float isCircle = clamp(d2, 0., 1.);

    // Output to screen
    fragColor = vec4((vec3(cos(iTime)*0.1+0.9, 0., 0.) * (1.- isCircle)) + (circleStrokeColor * (isCircle)),1.0);
}

void main() {
    vec4 color = vec4(0.0,0.0,0.0,1.0);
    mainImage(color, gl_FragCoord.xy);
    color.w = 1.0;
    gl_FragColor = color;
}