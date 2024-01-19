//
//  UIImage+JhExtension.swift
//  Swift-DXKT
//
//  Created by 宗森 on 2021/12/28.
//

import UIKit


extension UIImage {
        
    /// 纯色图颜色重绘（更改图片颜色）
    /// - Parameter color: 目标颜色
    /// - Returns: 重绘颜色后的Image
    public func Jh_imageWithTintColor(_ tintColor : UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0)
        tintColor.setFill()
        let bounds = CGRect.init(x: 0, y: 0, width: self.size.width, height: self.size.height)
        UIRectFill(bounds)
        self.draw(in: bounds, blendMode: CGBlendMode.destinationIn, alpha: 1.0)
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return tintedImage!
    }
    
    /// 创建指定颜色的图像
    static func Jh_imageWithColor(_ color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
}
extension UIImageView {
    /// UIImageView图像变灰
    func convertToGrayScale() {
        guard let originalImage = self.image else { return }
        let filter = CIFilter(name: "CIPhotoEffectMono")
        
        filter?.setValue(CIImage(image: originalImage), forKey: kCIInputImageKey)
        
        guard let outputImage = filter?.outputImage,
            let cgImage = CIContext(options: nil).createCGImage(outputImage, from: outputImage.extent) else { return }
        
        self.image = UIImage(cgImage: cgImage)
    }
}
