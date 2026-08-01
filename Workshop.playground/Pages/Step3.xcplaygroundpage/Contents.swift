import UIKit
import CoreImage
import PlaygroundSupport

let image = UIImage(named: "sample")!
let ciImage = CIImage(image: image)!

let bloomFilter = CIFilter(name: "CIBloom")!
bloomFilter.setValue(8, forKey: kCIInputRadiusKey)
bloomFilter.setValue(1.25, forKey: kCIInputIntensityKey)
bloomFilter.setValue(ciImage, forKey: kCIInputImageKey)
var filteredImage = bloomFilter.outputImage!

let noirFilter = CIFilter(name: "CIPhotoEffectNoir")!
noirFilter.setValue(filteredImage, forKey: kCIInputImageKey)
filteredImage = noirFilter.outputImage!

let checkboardFilter = CIFilter(name: "CICheckerboardGenerator")!
checkboardFilter.setValue(CIVector(x: 0, y: 0), forKey: kCIInputCenterKey)
checkboardFilter.setValue(CIColor.white, forKey: kCIInputColor0Key)
checkboardFilter.setValue(CIColor.black, forKey: kCIInputColor1Key)

let checkboardImage = checkboardFilter.outputImage!
    .cropped(to: filteredImage.extent)

let negativeImage = filteredImage
    .applyingFilter("CIColorInvert")

let compositeFilter = CIFilter(name: "CIBlendWithMask")!
compositeFilter.setValue(filteredImage,forKey: kCIInputImageKey)
compositeFilter.setValue(negativeImage,forKey: kCIInputBackgroundImageKey)
compositeFilter.setValue(checkboardImage,forKey: kCIInputMaskImageKey)

filteredImage = compositeFilter.outputImage!

let ciContext = CIContext(options: [
    .useSoftwareRenderer: false,
    .cacheIntermediates: false,
    .highQualityDownsample: true
])
let cgImage = ciContext.createCGImage(filteredImage, from: ciImage.extent)!
let uiImage = UIImage(cgImage: cgImage)

let imageView = UIImageView(image: uiImage)
imageView.contentMode = .scaleAspectFit
imageView.frame = CGRect(
    x: 0,
    y: 0,
    width: uiImage.size.width,
    height: uiImage.size.height
)
PlaygroundPage.current.liveView = imageView
