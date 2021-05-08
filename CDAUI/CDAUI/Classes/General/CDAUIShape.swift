//
//  CDAUIShape.swift
//  CDAUI
//
//  Created by Alexander on 8/05/21.
//

import UIKit

extension CDAUICornerStyle {
    
    public struct Side {
        public var left = false
        public var right = false
    }
}

public struct CDAUICornerStyle {
    
    public var radius   : CGFloat = 10
    public var top      = Side()
    public var down     = Side()
}

protocol CDAUICorner {

    var cornerRadius    : CGFloat   { get set }
    var rightTop        : Bool      { get set }
    var leftTop         : Bool      { get set }
    var rightDown       : Bool      { get set }
    var leftDown        : Bool      { get set }
    
    var corner          : CDAUICornerStyle { get set }
        
    func updateCornerAppearance()
    func getMaskedCorners() -> CACornerMask
    func getRectCorners() -> UIRectCorner
}

extension CDAUICorner where Self: UIView {
    
    func updateCornerAppearance() {
        
        let maskedCorners           = self.getMaskedCorners()
        self.layer.cornerRadius     = self.corner.radius
        self.layer.maskedCorners    = maskedCorners

        (self as? CDAUIBorder)?.updateBorderAppearance()
        (self as? CDAUILinearGradient)?.updateLinearGradientAppearance()
        (self as? CDAUIRadialGradient)?.updateRadialGradientAppearance()
    }

    func getMaskedCorners() -> CACornerMask {
        
        var arrayCornerMask = [CACornerMask]()
        
        if self.corner.top.left     { arrayCornerMask.append(.layerMinXMinYCorner) }
        if self.corner.top.right    { arrayCornerMask.append(.layerMaxXMinYCorner) }
        if self.corner.down.left    { arrayCornerMask.append(.layerMinXMaxYCorner) }
        if self.corner.down.right   { arrayCornerMask.append(.layerMaxXMaxYCorner) }
        
        return arrayCornerMask.count != 0 ? CACornerMask(arrayCornerMask) : [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    
    func getRectCorners() -> UIRectCorner {

        var arrayCornerMask = [UIRectCorner]()

        if self.corner.top.left     { arrayCornerMask.append(.topLeft) }
        if self.corner.top.right    { arrayCornerMask.append(.topRight) }
        if self.corner.down.left    { arrayCornerMask.append(.bottomLeft) }
        if self.corner.down.right   { arrayCornerMask.append(.bottomRight) }

        return arrayCornerMask.count != 0 ? UIRectCorner(arrayCornerMask) : .allCorners
    }
}
