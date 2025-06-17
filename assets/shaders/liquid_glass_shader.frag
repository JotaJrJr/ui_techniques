#pragma version 460
#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform float uTime;
uniform float uIntensity;
uniform float uDistortion;

out vec4 fragColor;

void main() {
    vec2 uv = FlutterFragCoord().xy / uSize;
    
    // Create distortion pattern
    vec2 ripple1 = vec2(sin(uv.y * 20.0 + uTime), cos(uv.x * 15.0 - uTime));
    vec2 ripple2 = vec2(cos(uv.y * 12.0 - uTime * 1.5), sin(uv.x * 18.0 + uTime));
    vec2 distortion = (ripple1 + ripple2) * uDistortion * 0.01;
    
    // Light reflection effect
    vec2 center = vec2(0.5);
    float reflection = pow(1.0 - distance(uv, center), 4.0) * uIntensity;
    
    // Base glass color with reflection
    fragColor = vec4(0.7, 0.8, 0.9, 0.4) + vec4(reflection * 0.5);
}