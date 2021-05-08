//
//  CDAUILinearGradient.swift
//  CDAUI
//
//  Created by Alexander on 8/05/21.
//

import UIKit

public struct CDAUILinearGradientStyle {
    
    public var startColor       : UIColor? = nil
    public var endColor         : UIColor? = nil
    public var initialPosition  : CGPoint = CGPoint(x: 0, y: -1)
    public var endPosition      : CGPoint = CGPoint(x: 0, y: 1)
}

protocol CDAUILinearGradient {
    
    var startColor      : UIColor?  { get set }
    var endColor        : UIColor?  { get set }
    var startGradient   : CGPoint   { get set }
    var endGradient     : CGPoint   { get set }
    
    var gradientLayer   : CAGradientLayer? { get }
    var gradient        : CDAUILinearGradientStyle { get set }
    
    func updateLinearGradientAppearance()
}

extension CDAUILinearGradient where Self: UIView {
     
    func updateLinearGradientAppearance() {
    
        if let gradientLayer = self.gradientLayer {
            self.addLinearGradientLayer(gradientLayer)
            self.configureGradientLayer(gradientLayer)
        }else{
            self.gradientLayer?.removeFromSuperlayer()
        }
    }
    
    func configureGradientLayer(_ borderLayer: CAGradientLayer) {
        
        guard
            let startColor      = self.startColor,
            let endColor        = self.endColor,
            let initialPosition = self.startGradient.gradientPointPosition,
            let endPosition     = self.endGradient.gradientPointPosition
        else { return }

        let shapeView       = self as? CDAUICorner
        let cornerRadius    = shapeView?.cornerRadius ?? 0
        let corners         = shapeView?.getMaskedCorners()
    
        self.gradientLayer?.type            = .axial
        self.gradientLayer?.frame           = self.bounds
        self.gradientLayer?.cornerRadius    = cornerRadius
        self.gradientLayer?.maskedCorners   = corners ?? CACornerMask()
        self.gradientLayer?.startPoint      = initialPosition
        self.gradientLayer?.endPoint        = endPosition
        self.gradientLayer?.colors          = [startColor.cgColor, endColor.cgColor]
        self.gradientLayer?.locations       = [0.0, 1.0]
    }
    
    func createGradientLayer() -> CAGradientLayer {
        
        let gradientLayer = CAGradientLayer()
        self.configureGradientLayer(gradientLayer)
        return gradientLayer
    }
    
    func addLinearGradientLayer(_ gradientLayer: CAGradientLayer) {
        
        if let borderLayer = self.layer.sublayers?.filter({ $0 is CAShapeLayer }).first {
            self.layer.insertSublayer(gradientLayer, below: borderLayer)
        }else{
            self.layer.insertSublayer(gradientLayer, at: 0)
        }
    }
}
