//
//  CDAUIButton.swift
//  CDAUI
//
//  Created by Alexander on 8/05/21.
//

import UIKit

@IBDesignable open class CDAUIButton: CDAUIGradientButton {
    
    public lazy var style: Style = {
        return Style(button: self)
    }()
}


extension CDAUIButton {
    
    public struct Style {
        
        private var button: CDAUIButton
        
        init(button: CDAUIButton) {
            self.button = button
        }
        
        public var attributeText: CDAUIAttributeTextStyle {
            get { return self.button.attributed }
            set { self.button.attributed = newValue }
        }
        
        public var corner: CDAUICornerStyle {
            get { return self.button.corner }
            set { self.button.corner = newValue }
        }
        
        public var shadow: CDAUIShadowStyle {
            get { return self.button.shadow }
            set { self.button.shadow = newValue }
        }
        
        public var border: CDAUIBorderStyle {
            get { return self.button.border }
            set { self.button.border = newValue }
        }
        
        public var gradient: CDAUILinearGradientStyle {
            get { return self.button.gradient }
            set { self.button.gradient = newValue }
        }
    }
}
