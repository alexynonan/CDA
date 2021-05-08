//
//  CDAUIPlaceHolderTextField.swift
//  CDAUI
//
//  Created by Alexander on 8/05/21.
//

import UIKit

@IBDesignable open class CDAUIPlaceHolderTextField: CDAUIBorderStateTextField, CDAUIPlaceHolder {
    
    internal var placeholderStyle: CDAUIPlaceHolderStyle = CDAUIPlaceHolderStyle(){
        didSet { self.updatePlaceholderAppearance() }
    }
    
    @IBInspectable internal var isFloating: Bool {
        get { return self.placeholderStyle.isFloating }
        set { self.placeholderStyle.isFloating = newValue}
    }
    
    @IBInspectable internal var place_color: UIColor {
        get { return self.placeholderStyle.text.color }
        set { self.placeholderStyle.text.color = newValue}
    }
    
    lazy internal var lblPlaceholder: UILabel = {

        let lbl = UILabel()
        lbl.attributedText = self.attributedPlaceholder
        lbl.backgroundColor = .white
        lbl.sizeToFit()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    open override var placeholder: String?{
        didSet{
            if self.placeholderStyle.isFloating {
                self.lblPlaceholder.text = self.placeholder
            }
        }
    }
        
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if self.text?.count != 0 && !self.isFirstResponder && self.placeholderStyle.isFloating {
            self.addConstraintsToPlaceHolder()
            self.animatePlaceholderToUp()
        }
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        
        if self.isFloating {
            self.addTarget(self, action: #selector(self.textFieldPlaceholderEditingDidBegin(_:)), for: .editingDidBegin)
            self.addTarget(self, action: #selector(self.textFieldPlaceholderEditingDidEnd(_:)), for: .editingDidEnd)
        }
    }
    
    open override func layoutSubviews() {
        
        super.layoutSubviews()
        if self.isFloating {
            self.updatePlaceholderAppearance()
            if self.text?.count == 0 && self.isFirstResponder { self.internalLblPlaceholder?.isHidden = true }
        }
    }
    
    @objc private func textFieldPlaceholderEditingDidBegin(_ sender: UITextField) {
        
        if self.borderSate.state == .editing && self.text?.count == 0 {
            self.addConstraintsToPlaceHolder()
            self.animatePlaceholderToUp()
        }
    }

    @objc private func textFieldPlaceholderEditingDidEnd(_ sender: UITextField) {
        
        if self.borderSate.state == .normal {
            self.animatePlaceholderToDown()
        }
    }
}
