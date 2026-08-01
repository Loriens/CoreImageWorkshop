import UIKit
import CoreImage

let image = UIImage(named: "sample")!
let ciImage = CIImage(image: image)!
let ciImageColor = CIImage(color: .red)
    .cropped(to: CGRect(x: 0, y: 0, width: 100, height: 100))

let filter = CIFilter(name: "CISepiaTone")!
filter.setValue(ciImage, forKey: kCIInputImageKey)
filter.setValue(0.8, forKey: kCIInputIntensityKey)
var filteredImage = filter.outputImage!
