//
//  CDAUIInputTextRestrictTextField.swift
//  CDAUI
//
//  Created by Alexander on 8/05/21.
//

import UIKit

@IBDesignable open class CDAUIInputTextRestrictTextField: UITextField, CDAUIInputTextRestrict {
        
    internal var restrictions: CDAUIInputTextRestrictStyle = CDAUIInputTextRestrictStyle()
    
    @IBInspectable internal var maxLength: Int {
        get { return self.restrictions.maxLength }
        set { self.restrictions.maxLength = newValue }
    }
    
    @IBInspectable internal var allowEmail: Bool = false {
        didSet { self.updateRestrictAppearance() }
    }
    
    @IBInspectable internal var allowNumbers: Bool = false {
        didSet { self.updateRestrictAppearance() }
    }
    
    @IBInspectable internal var allowDecimal: Bool = false {
        didSet { self.updateRestrictAppearance() }
    }
    
    @IBInspectable internal var allowAlphabetic: Bool = false {
        didSet { self.updateRestrictAppearance() }
    }
    
    @IBInspectable internal var allowAccent: Bool = false {
        didSet { self.updateRestrictAppearance() }
    }
    
    internal func updateRestrictAppearance() {
        self.restrictions.allow = self.getTextPermissions()
    }
    
    public override func awakeFromNib() {
        
        super.awakeFromNib()
        self.addTarget(self, action: #selector(self.changeTextWhenUseIsTyping(_:)), for: .editingChanged)
        self.addTarget(self, action: #selector(self.changeTextToMaxLength(_:)), for: .editingChanged)
    }
    
    @objc private func changeTextToMaxLength(_ sender: UITextField) {
        self.text = self.applyMaxLengthToText(self.text)
    }
    
    @objc private func changeTextWhenUseIsTyping(_ sender: UITextField){
        
//        if self.restrictions.allow != .all {
            sender.text = self.text?.replacingOccurrences( of: self.getTextAllowed(), with: "", options: .regularExpression)
//        }
    }
}

