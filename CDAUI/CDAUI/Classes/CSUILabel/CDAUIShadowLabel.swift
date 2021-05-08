//
//  CDAUIShadowLabel.swift
//  CDAUI
//
//  Created by Alexander on 8/05/21.
//

import UIKit

@IBDesignable open class CDAUIShadowLabel: CDAUIInsetLabel, CDAUIShadow {
    
    internal var shadow: CDAUIShadowStyle = CDAUIShadowStyle() {
        didSet { self.updateShadowAppearance() }
    }
    
    @IBInspectable internal var shadow_color: UIColor {
        get { return self.shadow.color }
        set { self.shadow.color = newValue }
    }
    
    @IBInspectable internal var shadow_offset: CGSize {
        get { return self.shadow.offset }
        set { self.shadow.offset = newValue }
    }
    
    @IBInspectable internal var shadow_radius: CGFloat {
        get { return self.shadow.radius }
        set { self.shadow.radius = newValue }
    }
    
    @IBInspectable internal var shadow_opacity: Float {
        get { return self.shadow.opacity }
        set { self.shadow.opacity = newValue }
    }
}
