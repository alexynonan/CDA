//
//  CDAUIBorderTextField.swift
//  CDAUI
//
//  Created by Alexander on 8/05/21.
//

import UIKit

@IBDesignable open class CDAUIBorderTextField: CDAUIShapeTextField, CDAUIBorder {
    
    internal var border: CDAUIBorderStyle = CDAUIBorderStyle() {
        didSet { self.updateBorderAppearance() }
    }
    
    @IBInspectable var brokeLine: Bool {
        get { return self.border.type == .broken }
        set { self.border.type = newValue ? .broken : .single }
    }
    
    var lineWidth: Float {
        get { return self.border.line.width }
        set { self.border.line.width = newValue }
    }
     
    var lineSeparator: Float {
        get { return self.border.line.separator }
        set { self.border.line.separator = newValue }
    }
    
    @IBInspectable var borderColor: UIColor {
        get { return self.border.color }
        set { self.border.color = newValue }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get { return self.border.width }
        set { self.border.width = newValue }
    }
    
    lazy internal var borderLayer: CAShapeLayer? = {
        return self.createBorderLayer()
    }()
    
    public override var bounds: CGRect{
        didSet { self.updateBorderAppearance() }
    }
}
