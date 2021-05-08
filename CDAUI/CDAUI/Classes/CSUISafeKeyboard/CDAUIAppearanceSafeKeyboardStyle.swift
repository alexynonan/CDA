//
//  CDAUIAppearanceSafeKeyboardStyle.swift
//  CDAUI
//
//  Created by Alexander on 8/05/21.
//

import UIKit

@IBDesignable open class CDAUIAppearanceSafeKeyboardStyle: CDAUIShadowSafeKeyboardKeyStyle {
    
    @IBInspectable var button_background: UIColor {
        get { return self.style.buttonKeyboard.backgroundColor }
        set { self.style.buttonKeyboard.backgroundColor = newValue }
    }
    
    @IBInspectable var button_text: UIColor {
        get { return self.style.buttonKeyboard.textColor }
        set { self.style.buttonKeyboard.textColor = newValue }
    }
    
    @IBInspectable var font_size: CGFloat {
        get { return self.style.buttonKeyboard.fontSize }
        set { self.style.buttonKeyboard.fontSize = newValue }
    }
    
    @IBInspectable var font_type: Int {
        get { return self.style.buttonKeyboard.fontType.rawValue }
        set { self.style.buttonKeyboard.fontType = SCUISafeKeyboardStyle.Button.Font(rawValue: newValue) ?? .regular}
    }

    @IBInspectable var verticalSpacing: CGFloat {
        get { return self.style.verticalSpacing }
        set { self.style.verticalSpacing = newValue }
    }
    
    @IBInspectable var horizonalSpacing: CGFloat {
        get { return self.style.horizontaSpacing }
        set { self.style.horizontaSpacing = newValue }
    }    
}
