import UIKit
import CoreImage

let image = UIImage(named: "sample")!
let ciImage = CIImage(image: image)!

// MARK: - STEP 3: Chaining Filters

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
