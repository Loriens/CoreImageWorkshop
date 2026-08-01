//
//  ScaleHorizontal.ci.metal
//  CoreImageWorkshop
//
//  Created by Vladislav Markov on 10/04/2026.
//

#include <CoreImage/CoreImage.h>
#include <metal_stdlib>
using namespace metal;

extern "C" {
    namespace coreimage {
        float2 scaleHorizontal(float inputScaleX, coreimage::destination dest) {
            float2 pos = dest.coord();
            float x = pos.x / inputScaleX;
            return float2(x, pos.y);
        }
    }
}
