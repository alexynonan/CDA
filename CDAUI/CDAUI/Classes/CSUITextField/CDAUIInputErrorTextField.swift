//
//  CDAUIInputErrorTextField.swift
//  CDAUI
//
//  Created by Alexander on 8/05/21.
//

import UIKit

@IBDesignable open class CDAUIInputErrorTextField: CDAUIIconTextField, CDAUIInputError {
    
    @IBOutlet public weak var bottomErrorConstraint: NSLayoutConstraint?
    
    internal var topLabelErrorConstraint: NSLayoutConstraint?
    internal var initialBottonErrorConstraintConstant: CGFloat = 0
    
    internal var errorMessage = CDAUIInputErrorStyle() {
        didSet { self.updateErrorAppearance() }
    }
    
    public lazy var lblErrorMessage: CDAUILabel = {
        return self.createLblErrorMessage()
    }()
        
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        self.addTarget(self, action: #selector(self.hideErrorMessage), for: .editingChanged)
        self.addTarget(self, action: #selector(self.hideErrorMessage), for: .editingDidBegin)
        self.addConstraintsToLabelError()
    }
            
    public func showErrorMessageWithText(_ errorMessage: String) {
        
        self.borderSate.state = .error
        self.errorMessage.text = errorMessage
        self.errorMessage.size = self.lblErrorMessage.attributedText?.getSizeToWidth(self.lblErrorMessage.frame.width) ?? .zero
        self.lblErrorMessage.alpha  = 1
        
        UIView.animate(withDuration: 0.3) {
            self.topLabelErrorConstraint?.constant = self.errorMessage.topSeparator
            self.bottomErrorConstraint?.constant = self.initialBottonErrorConstraintConstant + self.errorMessage.size.height + (self.topLabelErrorConstraint?.constant ?? 0)
            self.getMainSuperView(self.lblErrorMessage).layoutIfNeeded()
        }
    }
    
    @objc public func hideErrorMessage() {
        
        self.borderSate.state = self.isFirstResponder ? .editing : (self.text?.trim.count == 0 ? .normal : .endEditing)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.topLabelErrorConstraint?.constant  = -self.errorMessage.size.height
            self.lblErrorMessage.alpha              = 0
            self.bottomErrorConstraint?.constant    = self.initialBottonErrorConstraintConstant
            self.getMainSuperView(self.lblErrorMessage).layoutIfNeeded()
        })
    }
    
    internal func addConstraintsToLabelError() {
        
        if let bottomConstraint = self.bottomErrorConstraint, self.initialBottonErrorConstraintConstant == 0 {
            
            self.initialBottonErrorConstraintConstant = bottomConstraint.constant
            self.superview?.insertSubview(self.lblErrorMessage, belowSubview: self)
            
            self.topLabelErrorConstraint = self.lblErrorMessage.topAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
            self.topLabelErrorConstraint?.isActive = true
            self.lblErrorMessage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
            self.lblErrorMessage.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
            self.lblErrorMessage.superview?.layoutIfNeeded()
        }
    }
}
