//
//  CDAUIShadow.swift
//  CDAUI
//
//  Created by Alexander on 8/05/21.
//

import UIKit

public struct CDAUIShadowStyle {
    
    public var color    : UIColor = .clear
    public var offset   : CGSize = .zero
    public var radius   : CGFloat = 5
    public var opacity  : Float = 0.5
}

protocol CDAUIShadow {
    
    var shadow_color     : UIColor   { get set }
    var shadow_offset    : CGSize    { get set }
    var shadow_radius    : CGFloat   { get set }
    var shadow_opacity   : Float     { get set }

    var shadow          : CDAUIShadowStyle { get set }
    
    func updateShadowAppearance()
}

extension CDAUIShadow where Self: UIView {
     
    func updateShadowAppearance() {
    
        self.layer.shadowColor      = shadow_color.cgColor
        self.layer.shadowOffset     = shadow_offset
        self.layer.shadowRadius     = shadow_radius
        self.layer.shadowOpacity    = shadow_opacity
        self.layer.masksToBounds    = false
    }
}
