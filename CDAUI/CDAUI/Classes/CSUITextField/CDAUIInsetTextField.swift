//
//  CDAUIInsetTextField.swift
//  CDAUI
//
//  Created by Alexander on 8/05/21.
//

import UIKit

@IBDesignable open class CDAUIInsetTextField: CDAUIInputTextRestrictTextField, CDAUIInset {
    
    internal var inset: CDAUIInsetStyle = CDAUIInsetStyle(top: 0, left: 15, bottom: 0, right: 15)
    
    internal var top: CGFloat {
        get { return self.inset.top }
        set { self.inset.top = newValue }
    }
    
    internal var bottom: CGFloat {
        get { return self.inset.bottom }
        set { self.inset.bottom = newValue }
    }
    
    internal var left: CGFloat {
        get { return self.inset.left }
        set { self.inset.left = newValue }
    }
    
    internal var right: CGFloat {
        get { return self.inset.right }
        set { self.inset.right = newValue }
    }
    
    open override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: self.internalInsets)
    }
    
    open override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: self.internalInsets)
    }
        
    open override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: self.internalInsets)
    }

}

