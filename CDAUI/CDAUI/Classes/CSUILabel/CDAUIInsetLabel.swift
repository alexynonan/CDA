//
//  CDAUITextInsetLabel.swift
//  CDAUI
//
//  Created by Alexander on 8/05/21.
//

import UIKit

@IBDesignable open class CDAUIInsetLabel: CDAUIAttributedTextLabel, CDAUIInset {
    
    internal var inset: CDAUIInsetStyle = CDAUIInsetStyle()
    
    @IBInspectable internal var top: CGFloat {
        get { return self.inset.top }
        set { self.inset.top = newValue }
    }
    
    @IBInspectable internal var bottom: CGFloat {
        get { return self.inset.bottom }
        set { self.inset.bottom = newValue }
    }
    
    @IBInspectable internal var left: CGFloat {
        get { return self.inset.left }
        set { self.inset.left = newValue }
    }
    
    @IBInspectable internal var right: CGFloat {
        get { return self.inset.right }
        set { self.inset.right = newValue }
    }
        
    open override func drawText(in rect: CGRect) {

        let insets = UIEdgeInsets(top: self.top, left: self.left, bottom: self.bottom, right: self.right)
        super.drawText(in: rect.inset(by: insets))
    }

    public override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        
        let insets = UIEdgeInsets(top: self.top, left: self.left, bottom: self.bottom, right: self.right)
        let tr = bounds.inset(by: insets)
        let ctr = super.textRect(forBounds: tr, limitedToNumberOfLines: numberOfLines)
        return ctr
    }
    
    public override var intrinsicContentSize: CGSize {
        get{
            var contentSize = super.intrinsicContentSize
            contentSize.width += (self.left + self.right)
            contentSize.height += self.top + self.bottom
            return contentSize
        }
    }
}

