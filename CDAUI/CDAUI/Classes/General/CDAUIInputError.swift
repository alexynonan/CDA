//
//  CSUIInputError.swift
//  CDAUI
//
//  Created by Alexander on 8/05/21.
//

import UIKit

public struct CDAUIInputErrorStyle {

    public var text         = ""
    public var color        = UIColor.red
    public var font         = UIFont.systemFont(ofSize: 11)
    public var size         = CGSize.zero
    public var topSeparator : CGFloat = 5
    public var spaceLine    : CGFloat = 0
}

protocol CDAUIInputError {
    
    var bottomErrorConstraint               : NSLayoutConstraint?   { get set }
    var topLabelErrorConstraint             : NSLayoutConstraint?   { get set }
    var initialBottonErrorConstraintConstant: CGFloat               { get set }
    var lblErrorMessage                     : CDAUILabel             { get set }
    
    var errorMessage                        : CDAUIInputErrorStyle   { get set }
    
    func showErrorMessageWithText(_ errorMessage: String)
    func hideErrorMessage()
    func addConstraintsToLabelError()
}

extension CDAUIInputError where Self: UIResponder {
    
    func createLblErrorMessage() -> CDAUILabel {
        
        let lbl             = CDAUILabel()
        lbl.alpha           = 0
        lbl.numberOfLines   = 0
        lbl.lineBreakMode   = .byWordWrapping
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }
    
//    func getMainSuperViewToView(_ view: UIView) -> UIView {
//        
//        guard let parent = view.superview else { return view }
//        return self.getMainSuperViewToView(parent)
//    }
 
    internal func updateErrorAppearance() {
        
        self.lblErrorMessage.text       = self.errorMessage.text
        self.lblErrorMessage.font       = self.errorMessage.font
        self.lblErrorMessage.textColor  = self.errorMessage.color
        self.lblErrorMessage.attributed.spaceLine = self.errorMessage.spaceLine
    }
}
