# Feel Core Image: A Live Image Processing Workshop

A hands-on workshop exploring Apple's Core Image framework — from basic filter chains to custom Metal kernels and face-aware beauty effects.

## What's Inside

### Playground

Step-by-step guide through Core Image fundamentals:

1. **Initial** — Creating `CIImage`, loading assets, generating solid colors
2. **Step 1** — Applying a single filter (Sepia Tone) and setting parameters
3. **Step 2** — Chaining filters, compositing with masks, blend modes
4. **Step 3** — Rendering pipeline: `CIContext`, `CIImage` to `UIImage` conversion

### App

Interactive companion app with live previews and adjustable parameters.

**Filter Browser** — 68 built-in Core Image filters across 9 categories: Blur, Color Adjustment, Color Effect, Sharpen, Stylize, Distortion, Halftone Effect, Tile Effect, Geometry Adjustment.

**Custom Kernels** — Three Metal kernel types demonstrated side-by-side:
- *Color Kernel* — Luminance threshold (per-pixel, no neighbors)
- *Warp Kernel* — Carnival mirror distortion (coordinate remapping)
- *General Kernel* — Box blur (neighborhood sampling)

**Region of Interest** — How Core Image decides which source pixels a kernel needs to produce a given output tile.

**Rendering Comparison** — Metal vs UIImage rendering with real-time FPS counters.

**Beauty Filters** — Vision-powered face landmark detection:
- *Lips Filter* — Mask-based lip color tinting with soft-light blend or hue/saturation adjustment
- *Eyes Filter* — Bump distortion centered on detected eye landmarks to enlarge or shrink eyes

## Requirements

- Xcode 26+
- iOS 26+

## Resources

- [Core Image for Swift](https://books.apple.com/us/book/core-image-for-swift/id1073029980)
- [Core Image Tutorial for iOS: Custom Filters](https://www.kodeco.com/25658084-core-image-tutorial-for-ios-custom-filters)
- [Core Image Framework](https://developer.apple.com/documentation/coreimage)
- [Vision Framework](https://developer.apple.com/documentation/vision)
- [Core Image Programming Guide](https://developer.apple.com/library/archive/documentation/GraphicsImaging/Conceptual/CoreImaging/ci_intro/ci_intro.html)
- [Metal Shading Language for Core
Image Kernels](https://developer.apple.com/metal/MetalCIKLReference6.pdf)
- [Shader Toy](https://www.shadertoy.com/)
- [The Book of Shaders](https://thebookofshaders.com/)
