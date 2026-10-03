//
//  CustomKernels.ci.metal
//  CoreImageWorkshop
//
//  Created by Vladislav Markov on 02/04/2026.
//

#include <CoreImage/CoreImage.h>
using namespace metal;


extern "C" {
    namespace coreimage {
        float4 lumaThreshold(coreimage::sample_t pixel,
                             float threshold) {
            float luma = dot(pixel.rgb, float3(0.2126, 0.7152, 0.0722));
            float mask = step(threshold, luma);
            return float4(mask, mask, mask, 1.0);
        }

        float2 carnivalMirror(float xAmplitude,
                              float yAmplitude,
                              float xWavelength,
                              float yWavelength,
                              coreimage::destination dest) {
            float2 pos = dest.coord();
            float x = pos.x + sin(pos.x / xWavelength) * xAmplitude;
            float y = pos.y + sin(pos.y / yWavelength) * yAmplitude;
            return float2(x, y);
        }
    }
}
