//
//  CDAUIAttributeText.swift
//  CDAUI
//
//  Created by Alexander on 8/05/21.
//

import UIKit

extension CDAUIAttributeTextStyle {
    
    public struct TextLine {
        public var show     : Bool = false
        public var color    : UIColor? = nil
    }
}

public struct CDAUIAttributeTextStyle {
    
    public var underline    = TextLine()
    public var middleLine   = TextLine()
    public var spaceLine    : CGFloat = 0
}

protocol CDAUIAttributeText {
    
    var underline   : Bool      { get set }
    var middleLine  : Bool      { get set }
    var spaceLine   : CGFloat   { get set }
    
    var attributed: CDAUIAttributeTextStyle { get set }
    
    func updateAttributeTextAppearance()
}
