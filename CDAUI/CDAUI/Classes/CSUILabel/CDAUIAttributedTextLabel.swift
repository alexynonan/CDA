//
//  CDAUIAttributeTextLabel.swift
//  CDAUI
//
//  Created by Alexander on 8/05/21.
//

import UIKit

@IBDesignable open class CDAUIAttributedTextLabel: UILabel, CDAUIAttributeText {
    
    internal var attributed: CDAUIAttributeTextStyle = CDAUIAttributeTextStyle() {
        didSet { self.updateAttributeTextAppearance() }
    }
    
    @IBInspectable internal var underline: Bool {
        get { return self.attributed.underline.show }
        set { self.attributed.underline.show = newValue }
    }
    
    @IBInspectable internal var middleLine: Bool {
        get { return self.attributed.middleLine.show }
        set { self.attributed.middleLine.show = newValue }
    }
    
    @IBInspectable internal var spaceLine: CGFloat {
        get { return self.attributed.spaceLine }
        set { self.attributed.spaceLine = newValue }
    }
    
    internal func updateAttributeTextAppearance() {
        
        guard let oldAttributes = self.attributedText else { return }
        
        let newAttributes = NSMutableAttributedString(attributedString: oldAttributes)
        newAttributes.addUnderline(self.underline, color: self.attributed.underline.color)
        newAttributes.addMiddleline(self.middleLine, color: self.attributed.middleLine.color)
        
        newAttributes.lineSpacing(self.spaceLine)
    
        self.attributedText = newAttributes
    }
}
