//
//  CDAUIShapeTabBar.swift
//  CDAUI
//
//  Created by Alexander on 8/05/21.
//

import UIKit

@IBDesignable open class CDAUIShapeTabBar: UITabBar, CDAUICorner {
    
    public var corner: CDAUICornerStyle = CDAUICornerStyle() {
        didSet { self.updateCornerAppearance() }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get { return self.corner.radius }
        set { self.corner.radius = newValue }
    }
    
    @IBInspectable var rightTop: Bool {
        get { return self.corner.top.right }
        set { self.corner.top.right = newValue }
    }
    
    @IBInspectable var leftTop: Bool {
        get { return self.corner.top.left }
        set { self.corner.top.left = newValue }
    }

    @IBInspectable var rightDown: Bool {
        get { return self.corner.down.right }
        set { self.corner.down.right = newValue }
    }
    
    @IBInspectable var leftDown: Bool {
        get { return self.corner.down.left }
        set { self.corner.down.left = newValue }
    }
}
