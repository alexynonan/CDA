//
//  CSUIShapeView.swift
//  CDAUI
//
//  Created by Alexander on 8/05/21.
//

import UIKit
import CDAUtilities

@IBDesignable open class CDAUICornerView: UIView, CDAUICorner {
    
    internal var corner: CDAUICornerStyle = CDAUICornerStyle() {
        didSet { self.updateCornerAppearance() }
    }
    
    @IBInspectable internal var cornerRadius: CGFloat {
        get { return self.corner.radius }
        set { self.corner.radius = newValue }
    }
    
    @IBInspectable internal var rightTop: Bool {
        get { return self.corner.top.right }
        set { self.corner.top.right = newValue }
    }
    
    @IBInspectable internal var leftTop: Bool {
        get { return self.corner.top.left }
        set { self.corner.top.left = newValue }
    }

    @IBInspectable internal var rightDown: Bool {
        get { return self.corner.down.right }
        set { self.corner.down.right = newValue }
    }
    
    @IBInspectable internal var leftDown: Bool {
        get { return self.corner.down.left }
        set { self.corner.down.left = newValue }
    }
}
