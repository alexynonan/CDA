//
//  CDAUILinearGradientView.swift
//  CDAUI
//
//  Created by Alexander on 8/05/21.
//

import UIKit

@IBDesignable open class CDAUILinearGradientView: CDAUIShadowView, CDAUILinearGradient {
        
    public lazy var style: Style = {
        return Style(view: self)
    }()
    
    internal var gradient: CDAUILinearGradientStyle = CDAUILinearGradientStyle() {
        didSet { self.updateLinearGradientAppearance() }
    }
    
    @IBInspectable internal var startColor: UIColor? {
        get { return self.gradient.startColor }
        set { self.gradient.startColor = newValue }
    }
    
    @IBInspectable internal var endColor: UIColor? {
        get { return self.gradient.endColor }
        set { self.gradient.endColor = newValue }
    }
        
    @IBInspectable internal var startGradient: CGPoint {
        get { return self.gradient.initialPosition }
        set { self.gradient.initialPosition = newValue.unitValue }
    }

    @IBInspectable internal var endGradient: CGPoint {
        get { return self.gradient.endPosition }
        set { self.gradient.endPosition = newValue.unitValue }
    }
    
    lazy internal var gradientLayer: CAGradientLayer? = {
        return self.createGradientLayer()
    }()
    
    open override var bounds: CGRect {
        didSet { self.updateLinearGradientAppearance() }
    }
    
    open override func setNeedsLayout() {
        super.setNeedsLayout()
        self.updateLinearGradientAppearance()
    }
}

extension CDAUILinearGradientView {
    
    public struct Style {
        
        private var view: CDAUILinearGradientView
        
        init(view: CDAUILinearGradientView) {
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
        
        public var gradient: CDAUILinearGradientStyle {
            get { return self.view.gradient }
            set { self.view.gradient = newValue }
        }
    }
}

