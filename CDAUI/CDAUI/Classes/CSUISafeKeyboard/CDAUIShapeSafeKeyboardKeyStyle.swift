//
//  CDAUIShapeSafeKeyboardKeyStyle.swift
//  CDAUI
//
//  Created by Alexander on 8/05/21.
//

import UIKit

@IBDesignable open class CDAUIShapeSafeKeyboardKeyStyle: CDAUIInsetsSafeKeyboard, CDAUICorner {
    
    var corner: CDAUICornerStyle = CDAUICornerStyle()
    
    @IBInspectable var cornerRadius: CGFloat {
        get { return self.style.buttonKeyboard.corner.radius }
        set { self.style.buttonKeyboard.corner.radius = newValue }
    }
    
    @IBInspectable var rightTop: Bool {
        get { return self.style.buttonKeyboard.corner.top.right }
        set { self.style.buttonKeyboard.corner.top.right = newValue }
    }
    
    @IBInspectable var leftTop: Bool {
        get { return self.style.buttonKeyboard.corner.top.left }
        set { self.style.buttonKeyboard.corner.top.left = newValue }
    }
    
    @IBInspectable var rightDown: Bool {
        get { return self.style.buttonKeyboard.corner.down.right }
        set { self.style.buttonKeyboard.corner.down.right = newValue }
    }
    
    @IBInspectable var leftDown: Bool {
        get { return self.style.buttonKeyboard.corner.down.left }
        set { self.style.buttonKeyboard.corner.down.left = newValue }
    }
    
    func updateCornerAppearance() {
        
    }
}
