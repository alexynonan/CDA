//
//  CDAUIBorderStateTextField.swift
//  CDAUI
//
//  Created by Alexander on 8/05/21.
//

import UIKit

@IBDesignable open class CDAUIBorderStateTextField: CDAUIBorderTextField, CDAUIInputBorderSate {
        
    internal var borderSate: CDAUIInputBorderStateStyle = CDAUIInputBorderStateStyle(){
        didSet { self.updateBorderStateAppearance() }
    }
    
    @IBInspectable var editing_state: UIColor? {
        get { return self.borderSate.color.editing }
        set { self.borderSate.color.editing = newValue }
    }
    
    @IBInspectable var endEditing_state: UIColor? {
        get { return self.borderSate.color.endEditing }
        set { self.borderSate.color.endEditing = newValue }
    }
    
    @IBInspectable var error_state: UIColor? {
        get { return self.borderSate.color.error }
        set { self.borderSate.color.error = newValue }
    }
    
    open override var text: String?{
        didSet{ self.borderSate.state = self.getBorderStateToText(self.text ?? "") }
    }
    
    open override func awakeFromNib() {
        
        super.awakeFromNib()
        
        self.borderSate.color.normal = self.border.color
        self.borderSate.state = self.getBorderStateToText(self.text ?? "")
        self.addTarget(self, action: #selector(self.textFieldBorderStateEditingDidBegin(_:)), for: .editingDidBegin)
        self.addTarget(self, action: #selector(self.textFieldBorderStateEditingDidEnd(_:)), for: .editingDidEnd)
    }
    
    func updateBorderStateAppearance() {
        self.border.color = self.getBorderColorToSate()
        (self as? CDAUIPlaceHolder)?.updateColorPlaceHolderWhenChangeStatus(self.border.color)
    }
    
    @objc private func textFieldBorderStateEditingDidBegin(_ sender: UITextField) {
        self.borderSate.state = .editing
        self.updateBorderStateAppearance()
    }
    
    @objc private func textFieldBorderStateEditingDidEnd(_ sender: UITextField) {
        
        if self.borderSate.state != .error {
            self.borderSate.state = self.text?.trim.count == 0 ? .normal : .endEditing
        }
        
        self.updateBorderStateAppearance()
    }
}
