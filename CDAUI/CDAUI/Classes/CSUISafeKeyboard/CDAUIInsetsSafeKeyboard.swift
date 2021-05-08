//
//  CDAUIInsetsSafeKeyboard.swift
//  CDAUI
//
//  Created by Alexander on 8/05/21.
//

import UIKit

@IBDesignable open class CDAUIInsetsSafeKeyboard: CSUIStyleSafeKeyboard, CDAUIInset {
    
    var inset: CDAUIInsetStyle = CDAUIInsetStyle()
    
    @IBInspectable var top: CGFloat {
        get { return self.style.inset.top }
        set { self.style.inset.top = newValue }
    }
        
    @IBInspectable var bottom: CGFloat {
        get { return self.style.inset.bottom }
        set { self.style.inset.bottom = newValue }
    }
    
    @IBInspectable var left: CGFloat {
        get { return self.style.inset.left }
        set { self.style.inset.left = newValue }
    }
    
    @IBInspectable var right: CGFloat {
        get { return self.style.inset.right }
        set { self.style.inset.right = newValue }
    }
}
