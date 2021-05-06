//
//  CDAImage.swift
//  CDAUtilities
//
//  Created by Alexander on 5/05/21.
//

import Foundation
import UIKit

extension UIImage {
    
    public func imageRotatedByDegrees(degrees: CGFloat) -> UIImage {
        
        let rotatedViewBox: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        let t: CGAffineTransform = CGAffineTransform(rotationAngle: degrees * CGFloat(Double.pi / 180))
        rotatedViewBox.transform = t
        let rotatedSize: CGSize = rotatedViewBox.frame.size
        
        UIGraphicsBeginImageContext(rotatedSize)
        let bitmap: CGContext = UIGraphicsGetCurrentContext()!
        bitmap.translateBy(x: rotatedSize.width / 2, y: rotatedSize.height / 2)
        bitmap.rotate(by: (degrees * CGFloat(Double.pi / 180)))
        
        bitmap.scaleBy(x: 1.0, y: -1.0)
        bitmap.draw(self.cgImage!, in: CGRect(x: -self.size.width / 2, y: -self.size.height / 2, width: self.size.width, height: self.size.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    public func tintWithColor(_ color: UIColor) -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        
        guard let context = UIGraphicsGetCurrentContext(), let newCgImage = self.cgImage else { return nil }
        
        context.scaleBy(x: 1, y: -1)
        context.translateBy(x: 0, y: -self.size.height)
        context.setBlendMode(.multiply)
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        context.clip(to: rect, mask: newCgImage)
        
        color.setFill()
        context.fill(rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    public func resized(toWidth width: CGFloat) -> UIImage? {
        
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    public func resized(toHeight height: CGFloat) -> UIImage? {
        
        let canvasSize = CGSize(width: CGFloat(ceil(height/size.height * size.width)), height: height)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

extension UIImageView {
    
    public func addStyle(circle : Bool? = nil,radius : CGFloat? = nil,border : CGFloat? = nil,color : CGColor? = nil,_ alpha : CGFloat? = nil){
        
        self.layer.cornerRadius = circle ?? false ? (self.frame.size.width / 2) : radius ?? 0
        self.layer.borderWidth = border ?? 0
        self.layer.borderColor = color ?? UIColor.clear.cgColor
        self.alpha = alpha ?? 1
        self.layer.masksToBounds = true
    }
}
