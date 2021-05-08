//
//  CDAUIRadialGradient.swift
//  CDAUI
//
//  Created by Alexander on 8/05/21.
//

import UIKit

public struct CDAUIRadialGradientStyle {
    
    public var startColor       : UIColor? = nil
    public var endColor         : UIColor? = nil
    public var center           : CGPoint = CGPoint(x: 0, y: 0)
    public var radius           : CGFloat = 1
}

protocol CDAUIRadialGradient {
    
    var startColor      : UIColor?  { get set }
    var endColor        : UIColor?  { get set }
    var gradientCenter  : CGPoint   { get set }
    var gradientRadius  : CGFloat   { get set }
    
    var gradientLayer   : CAGradientLayer? { get }
    var gradient        : CDAUIRadialGradientStyle { get set }
    
    func updateRadialGradientAppearance()
}

extension CDAUIRadialGradient where Self: UIView {
     
    func updateRadialGradientAppearance() {
        
        if let gradientLayer = self.gradientLayer {
            self.addRadialGradientLayer(gradientLayer)
            self.configureGradientLayer(gradientLayer)
        }else{
            self.gradientLayer?.removeFromSuperlayer()
        }
    }
    
    func configureGradientLayer(_ borderLayer: CAGradientLayer) {
        guard
            let startColor      = self.startColor,
            let endColor        = self.endColor,
            let gradientCenter  = self.gradientCenter.gradientPointPosition
        else { return }

        let shapeView       = self as? CDAUICorner
        let cornerRadius    = shapeView?.cornerRadius ?? 0
        let corners         = shapeView?.getMaskedCorners()
    
        let radiusX = self.gradientRadius
        let sizeRadiusX = self.frame.width * radiusX
        let radiusY = sizeRadiusX / self.frame.height
        
        let endPoint = CGPoint(x: gradientCenter.x + radiusX, y: gradientCenter.y + radiusY)
  
        self.gradientLayer?.type            = .radial
        self.gradientLayer?.frame           = self.bounds
        self.gradientLayer?.cornerRadius    = cornerRadius
        self.gradientLayer?.maskedCorners   = corners ?? CACornerMask()
        self.gradientLayer?.colors          = [startColor.cgColor, endColor.cgColor]
        self.gradientLayer?.locations       = [0.0, 1.0]
        self.gradientLayer?.startPoint      = gradientCenter
        self.gradientLayer?.endPoint        = endPoint
    }
    
    func createGradientLayer() -> CAGradientLayer {
        
        let gradientLayer = CAGradientLayer()
        self.configureGradientLayer(gradientLayer)
        return gradientLayer
    }
    
    func addRadialGradientLayer(_ gradientLayer: CAGradientLayer) {
        
        if let borderLayer = self.layer.sublayers?.filter({ $0 is CAShapeLayer }).first {
            self.layer.insertSublayer(gradientLayer, below: borderLayer)
        }else{
            self.layer.insertSublayer(gradientLayer, at: 0)
        }
    }
}
