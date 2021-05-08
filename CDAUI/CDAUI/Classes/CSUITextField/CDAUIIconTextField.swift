//
//  CDAUIIconTextField.swift
//  CDAUI
//
//  Created by Alexander on 8/05/21.
//

import UIKit

public struct CDAUIIconTextFieldStyle {
    
    public var tintColor: UIColor = .systemBlue
    public var icon     : UIImage?
    public var isActive   : Bool = false
}

public struct CDAUIIconsTextFieldStyle {
    
    public var left = CDAUIIconTextFieldStyle()
    public var right = CDAUIIconTextFieldStyle()
}

@IBDesignable open class CDAUIIconTextField: CDAUIShadowTextField {
    
    internal var icons: CDAUIIconsTextFieldStyle = CDAUIIconsTextFieldStyle() {
        didSet { self.updateIconAppearance() }
    }
    
    @IBInspectable private var icon_left: UIImage? {
        get { return self.icons.left.icon }
        set { self.icons.left.icon = newValue }
    }
    
    @IBInspectable private var icon_right: UIImage? {
        get { return self.icons.right.icon }
        set { self.icons.right.icon = newValue }
    }
    
    @IBInspectable private var color_left: UIColor {
        get { return self.icons.left.tintColor }
        set { self.icons.left.tintColor = newValue }
    }
    
    @IBInspectable private var color_right: UIColor {
        get { return self.icons.right.tintColor }
        set { self.icons.right.tintColor = newValue }
    }
    
    private func updateIconAppearance() {
        
        self.leftView = self.createButtonWithImage(self.icons.left.icon, withColor: self.icons.left.tintColor, isActive: self.icons.left.isActive)
        self.leftViewMode = self.leftView != nil ? .always : .never
    
        self.rightView = self.createButtonWithImage(self.icons.right.icon, withColor: self.icons.right.tintColor, isActive: self.icons.right.isActive)
        self.rightViewMode = self.rightView != nil ? .always : .never
    }
    
    private func createButtonWithImage(_ image: UIImage?, withColor color: UIColor, isActive: Bool) -> UIView? {
        
        guard let image = image else { return nil }
        
        let contentView = UIView(frame:CGRect(x: 0, y: 0, width: 44, height: self.frame.height))
        let btn = UIButton(type: .system)
        btn.setImage(image, for: .normal)
        btn.frame = contentView.bounds
        btn.isUserInteractionEnabled = isActive
        btn.tintColor = color
        btn.addTarget(self, action: #selector(self.clickBtnIcon(_:)), for: .touchUpInside)
        
        contentView.addSubview(btn)
        return contentView
    }
    
    @objc private func clickBtnIcon(_ sender: UIButton) {
        
        if sender.superview == self.leftView, let txt = self as? CDAUITextField {
            txt.textFieldDelegate?.textField?(txt, tapInLeftIconButton: sender)
            
        }else if sender.superview == self.rightView, let txt = self as? CDAUITextField {
            txt.textFieldDelegate?.textField?(txt, tapInRightIconButton: sender)
        }
    }
}
