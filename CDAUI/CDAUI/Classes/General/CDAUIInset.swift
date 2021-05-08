//
//  CDAUITextInset.swift
//  CDAUI
//
//  Created by Alexander on 8/05/21.
//

import UIKit

public struct CDAUIInsetStyle {
 
    public var top      : CGFloat = 0
    public var bottom   : CGFloat = 0
    public var left     : CGFloat = 0
    public var right    : CGFloat = 0
    
    public static var safeAreaInsets: UIEdgeInsets? {
        return UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.safeAreaInsets
    }
    
    init(top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) {
        
        self.top    = top
        self.left   = left
        self.right  = right
        self.bottom = bottom
    }
}

protocol CDAUIInset {
    
    var top     : CGFloat { get set }
    var bottom  : CGFloat { get set }
    var left    : CGFloat { get set }
    var right   : CGFloat { get set }
    
    var inset   : CDAUIInsetStyle { get set }
}

extension CDAUIInset where Self: UITextField {
    
    var internalInsets: UIEdgeInsets {
        
        let paddingLeft = self.leftView?.frame.width ?? self.left
        let paddingRight = self.rightView?.frame.width ?? self.right
        
        return UIEdgeInsets(top: self.top,
                            left: paddingLeft,
                            bottom: self.bottom,
                            right: paddingRight)
    }
}
