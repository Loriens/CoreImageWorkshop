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
    }
}
