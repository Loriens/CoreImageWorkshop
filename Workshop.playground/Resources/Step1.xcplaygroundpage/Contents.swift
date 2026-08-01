import UIKit
import CoreImage

let image = UIImage(named: "sample")!
let ciImage = CIImage(image: image)!

// MARK: - STEP 1: First Filter

let filter = CIFilter(name: "CISepiaTone")!
filter.setValue(ciImage, forKey: kCIInputImageKey)
filter.setValue(0.8, forKey: kCIInputIntensityKey)

filter.outputImage!

let ciImageColor = CIImage(color: CIColor(red: 0.3, green: 0.7, blue: 0.5)).cropped(to: CGRect(x: 0, y: 0, width: ciImage.extent.width / 2.0, height: ciImage.extent.height / 2.0))
