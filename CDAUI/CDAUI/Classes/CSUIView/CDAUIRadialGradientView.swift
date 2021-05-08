//
//  CDAUIRadialGradientView.swift
//  CDAUI
//
//  Created by Alexander on 8/05/21.
//

import UIKit

@IBDesignable open class CDAUIRadialGradientView: CDAUIShadowView, CDAUIRadialGradient {

    public lazy var style: Style = {
        return Style(view: self)
    }()
    
    internal var gradient: CDAUIRadialGradientStyle = CDAUIRadialGradientStyle() {
        didSet { self.updateRadialGradientAppearance() }
    }
    
    @IBInspectable internal var startColor: UIColor? {
        get { return self.gradient.startColor }
        set { self.gradient.startColor = newValue }
    }
    
    @IBInspectable internal var endColor: UIColor? {
        get { return self.gradient.endColor }
        set { self.gradient.endColor = newValue }
    }
        
    @IBInspectable internal var gradientCenter: CGPoint {
        get { return self.gradient.center }
        set { self.gradient.center = newValue.unitValue }
    }

    @IBInspectable internal var gradientRadius: CGFloat {
        get { return self.gradient.radius }
        set { self.gradient.radius = newValue }
    }
    
    lazy internal var gradientLayer: CAGradientLayer? = {
        return self.createGradientLayer()
    }()
    
    public override var bounds: CGRect{
        didSet { self.updateRadialGradientAppearance() }
    }
    
    open override func setNeedsLayout() {
        super.setNeedsLayout()
        self.updateRadialGradientAppearance()
    }
}

extension CDAUIRadialGradientView {
    
    public struct Style {
        
        private var view: CDAUIRadialGradientView
        
        init(view: CDAUIRadialGradientView) {
            self.view = view
        }
        
        public var corner: CDAUICornerStyle {
            get { return self.view.corner }
            set { self.view.corner = newValue }
        }
        
        public var shadow: CDAUIShadowStyle {
            get { return self.view.shadow }
            set { self.view.shadow = newValue }
        }
        
        public var border: CDAUIBorderStyle {
            get { return self.view.border }
            set { self.view.border = newValue }
        }
        
        public var gradient: CDAUIRadialGradientStyle {
            get { return self.view.gradient }
            set { self.view.gradient = newValue }
        }
    }
}
