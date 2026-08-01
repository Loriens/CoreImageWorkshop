import UIKit
import CoreImage
import PlaygroundSupport

let image = UIImage(named: "sample")!
let ciImage = CIImage(image: image)!

// MARK: - STEP 4

let bloomFilter = CIFilter(name: "CIBloom")!
bloomFilter.setValue(20, forKey: kCIInputRadiusKey)
bloomFilter.setValue(1.25, forKey: kCIInputIntensityKey)
bloomFilter.setValue(ciImage, forKey: kCIInputImageKey)
var filteredImage = bloomFilter.outputImage!

let noirFilter = CIFilter(name: "CIPhotoEffectNoir")!
noirFilter.setValue(filteredImage, forKey: kCIInputImageKey)
filteredImage = noirFilter.outputImage!
let filteredUIImage = UIImage(ciImage: filteredImage)

let cgImage = CIContext().createCGImage(filteredImage, from: ciImage.extent)!
let filteredUICroppedImage = UIImage(cgImage: cgImage)

let imageView = UIImageView(image: filteredUICroppedImage)
imageView.contentMode = .scaleAspectFit
imageView.frame = CGRect(
    x: 0,
    y: 0,
    width: filteredUICroppedImage.size.width / 5.0,
    height: filteredUICroppedImage.size.height / 5.0
)
PlaygroundPage.current.liveView = imageView
