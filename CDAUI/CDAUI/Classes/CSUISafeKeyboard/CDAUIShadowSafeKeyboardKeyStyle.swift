//
//  CDAUIShadowSafeKeyboardKeyStyle.swift
//  CDAUI
//
//  Created by Alexander on 8/05/21.
//

import UIKit

@IBDesignable open class CDAUIShadowSafeKeyboardKeyStyle: CDAUIBorderSafeKeyboardKeyStyle, CDAUIShadow {
    
    var shadow: CDAUIShadowStyle = CDAUIShadowStyle()
    
    @IBInspectable var shadow_color: UIColor {
        get { return self.style.buttonKeyboard.shadow.color }
        set { self.style.buttonKeyboard.shadow.color = newValue }
    }
    
    @IBInspectable var shadow_offset: CGSize {
        get { return self.style.buttonKeyboard.shadow.offset }
        set { self.style.buttonKeyboard.shadow.offset = newValue }
    }
    
    @IBInspectable var shadow_radius: CGFloat {
        get { return self.style.buttonKeyboard.shadow.radius }
        set { self.style.buttonKeyboard.shadow.radius = newValue }
    }
    
    @IBInspectable var shadow_opacity: Float {
        get { return self.style.buttonKeyboard.shadow.opacity }
        set { self.style.buttonKeyboard.shadow.opacity = newValue }
    }
    
    func updateShadowAppearance() {
        
    }
}
