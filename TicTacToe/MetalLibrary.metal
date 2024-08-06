//
//  MetalLibrary.metal
//  TicTacToe
//
//  Created by Davide Castaldi on 18/05/24.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>

using namespace metal;

[[stitchable]] half4 rainbow(float2 pos, half4 color, float t) {

    if (color.a == 0.0) {
        return color;
    }
    
    
    float angle = atan2(pos.y, pos.x) + t;

    return half4(sin(angle), sin(angle + 2), sin(angle + 4), color.a);
}

[[stitchable]] half4 recolor(float2 pos, half4 color) {
    
    if (color.a == 0.0) {
        return color;
    }
    
    return half4(1, 0, 0, color.a);
}

[[stitchable]] half4 finalRainbow(float2 pos, half4 color, float2 s, float t) {
    
    if (color.a == 0.0) {
        return color;
    }
    
    // Center and normalize coordinates
    float2 uv = (pos / s) * 2 - 1;
    uv.x *= s.x / s.y; // Correct for aspect ratio
    
    // Create wave effect
    float wave = sin(uv.x + t);
    wave *= wave * 20;
    half3 waveColor = half3(0);
    
    // Center the effect
    uv.x += 0.2; // Shift to center horizontally
    uv.y += 0.2; // Shift to center vertically
    
    // Define upper and lower bounds for the y-axis wave effect
    float yBoundLower = -0.05; // Lower bound for y-axis
    float yBoundUpper = 0.05;  // Upper bound for y-axis
    
    for (float i = 0; i < 10; i++) {
        
        // Calculate width of the wave effect
        float width = abs(1 / (100 * uv.y + wave));
        
        // Compute the dynamic y displacement
        float yDisplacement = 0.05 * sin(uv.x * sin(t) + i * 0.2 + t);
        
        // Clamp y-displacement within bounds
        uv.y += clamp(yDisplacement, yBoundLower, yBoundUpper);
        
        // Calculate the rainbow color
        half3 rainbow = half3(
                              sin(i * 0.3 + t) * 0.5 + 0.5,
                              sin(i * 0.3 + 2 + sin(t * 0.3) * 2) * 0.5 + 0.5,
                              sin(i * 0.3 + 4) * 0.5 + 0.5
                              );
        
        // Accumulate the color effect
        waveColor += rainbow * width;
    }
    
    // Return the final color with alpha
    return half4(waveColor * color.a, 1.0);
}
