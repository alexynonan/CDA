//
//  CDAUIBorder.swift
//  CDAUI
//
//  Created by Alexander on 8/05/21.
//

import UIKit

extension CDAUIBorderStyle {
    
    public enum TypeLine: Int {
        case single = 0
        case broken = 1
    }
}

extension CDAUIBorderStyle {
 
    public struct BorderLine {
        public var width    : Float = 10
        public var separator: Float = 5
    }
}

public struct CDAUIBorderStyle {
    
    public var type     : TypeLine = .single
    public var width    : CGFloat = 0
    public var color    : UIColor = .black
    public var line     = BorderLine()
}

protocol CDAUIBorder {
    
    var brokeLine       : Bool      { get set }
    var lineWidth       : Float     { get set }
    var lineSeparator   : Float     { get set }
    var borderColor     : UIColor   { get set }
    var borderWidth     : CGFloat   { get set }
    
    var borderLayer     : CAShapeLayer? { get }
    var border          : CDAUIBorderStyle { get set }
    
    func updateBorderAppearance()
}

extension CDAUIBorder where Self: UIView {

    func updateBorderAppearance() {
        
        self.layer.borderColor = self.brokeLine ? nil : self.borderColor.cgColor
        self.layer.borderWidth = self.brokeLine ? 0 : self.borderWidth
        
        if self.brokeLine, let borderLayer = self.borderLayer {
            self.addBorderLayer(borderLayer)
            self.configureBorderLayer(borderLayer)
        }else{
            self.borderLayer?.removeFromSuperlayer()
        }
    }
    
    func configureBorderLayer(_ borderLayer: CAShapeLayer) {
        
        let shapeView       = self as? CDAUICorner
        let cornerRadius    = shapeView?.cornerRadius ?? 0
        let corners         = shapeView?.getRectCorners() ?? .allCorners
        let cornerRadii     = CGSize(width: cornerRadius, height: cornerRadius)
        let bounds          = self.getBoundsShape()
        
        borderLayer.frame           = bounds
        borderLayer.bounds          = bounds
        borderLayer.strokeColor     = self.borderColor.cgColor
        borderLayer.lineWidth       = self.borderWidth
        borderLayer.lineDashPattern = [NSNumber(value: self.lineWidth), NSNumber(value: self.lineSeparator)]
        borderLayer.fillColor       = nil
        borderLayer.path            = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: cornerRadii).cgPath
    }
    
    func getBoundsShape() -> CGRect {
        
        let width   = self.frame.width - self.borderWidth
        let height  = self.frame.height - self.borderWidth
        let posx    = self.borderWidth / 2
        let posy    = self.borderWidth / 2

        return CGRect(x: posx, y: posy, width: width, height: height)
    }
    
    func createBorderLayer() -> CAShapeLayer {
        
        let shapeLayer = CAShapeLayer()
        self.configureBorderLayer(shapeLayer)
        return shapeLayer
    }
    
    func addBorderLayer(_ borderLayer: CAShapeLayer) {
        
        if let gradienteLayer = self.layer.sublayers?.filter({ $0 is CAGradientLayer }).first {
            self.layer.insertSublayer(borderLayer, above: gradienteLayer)
        }else{
            self.layer.insertSublayer(borderLayer, at: 0)
        }
    }
}
