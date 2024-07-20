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
    
    float2 uv = (pos / s.x) * 2 - 1;
    float wave = sin(uv.x + t);
    wave *= wave * 50;
    half3 waveColor = half3(0);
    
    for (float i = 0; i < 10; i++) {
        
        float width = abs(1 / (1000 * uv.y + wave));
        //this newline just fudges everything up and makes everything look WOW. Honestly the maths is almost beyond me, too many things to keep track of, just play with numbers but one thing is sure.
        //so basically we have the main waves, and now we have another wave that is taking the x position, multiplying it for a sin wave depending on the time, and other factors. So now we have a more alive rainbow!
        float y = sin(uv.x * sin(t) + i * 0.2 + t);
        uv.y += 0.05 * y;
        
        half3 rainbow = half3(
                              sin(i * 0.3 + t) * 0.5 + 0.5,
                              sin(i * 0.3 + 2 + sin(t * 0.3) * 2) * 0.5 + 0.5,
                              sin(i * 0.3 + 4) * 0.5 + 0.5
                              );
        
        waveColor += rainbow * width;
    }
    
    return half4(waveColor, 1);
}
