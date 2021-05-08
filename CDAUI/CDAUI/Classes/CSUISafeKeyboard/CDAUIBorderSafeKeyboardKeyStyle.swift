//
//  CDAUIBorderSafeKeyboardKeyStyle.swift
//  CDAUI
//
//  Created by Alexander on 8/05/21.
//

import UIKit

@IBDesignable open class CDAUIBorderSafeKeyboardKeyStyle: CDAUIShapeSafeKeyboardKeyStyle, CDAUIBorder {
    
    var border: CDAUIBorderStyle = CDAUIBorderStyle()
    
    @IBInspectable var brokeLine: Bool {
        get { return self.style.buttonKeyboard.border.type == .broken }
        set { self.style.buttonKeyboard.border.type = newValue ? .broken : .single }
    }
    
    @IBInspectable var lineWidth: Float {
        get { return self.style.buttonKeyboard.border.line.width }
        set { self.style.buttonKeyboard.border.line.width = newValue }
    }
    
    @IBInspectable var lineSeparator: Float {
        get { return self.style.buttonKeyboard.border.line.separator }
        set { self.style.buttonKeyboard.border.line.separator = newValue }
    }
    
    @IBInspectable var borderColor: UIColor {
        get { return self.style.buttonKeyboard.border.color }
        set { self.style.buttonKeyboard.border.color = newValue }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get { return self.style.buttonKeyboard.border.width }
        set { self.style.buttonKeyboard.border.width = newValue }
    }
    
    internal var borderLayer: CAShapeLayer?
        
    func updateBorderAppearance() {
        
    }
}
