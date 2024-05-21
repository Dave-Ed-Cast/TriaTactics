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
    return half4(1, 0, 0, color.a);
}
