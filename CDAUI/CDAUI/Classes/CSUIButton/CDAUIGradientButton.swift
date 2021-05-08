//
//  CDAUIGradientButton.swift
//  CDAUI
//
//  Created by Alexander on 8/05/21.
//

import UIKit

@IBDesignable open class CDAUIGradientButton: CDAUIShadowButton, CDAUILinearGradient {
        
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
        
    @IBInspectable internal var startGradient: CGPoint{
        get { return self.gradient.initialPosition }
        set { self.gradient.initialPosition = newValue.unitValue }
    }

    @IBInspectable internal var endGradient: CGPoint{
        get { return self.gradient.endPosition }
        set { self.gradient.endPosition = newValue.unitValue }
    }
    
    lazy internal var gradientLayer: CAGradientLayer? = {
        return self.createGradientLayer()
    }()
    
    public override var bounds: CGRect{
        didSet { self.updateLinearGradientAppearance() }
    }
    
    open override func setNeedsLayout() {
        super.setNeedsLayout()
        self.updateLinearGradientAppearance()
    }
}
