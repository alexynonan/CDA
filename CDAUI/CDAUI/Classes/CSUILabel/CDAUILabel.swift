//
//  CDAUILabel.swift
//  CDAUI
//
//  Created by Alexander on 8/05/21.
//

import Foundation

@IBDesignable open class CDAUILabel: CDAUIShadowLabel {
    
    public lazy var style: Style = {
        return Style(label: self)
    }()
}

extension CDAUILabel {
    
    public struct Style {
        
        private var label: CDAUILabel
        
        init(label: CDAUILabel) {
            self.label = label
        }
        
        public var attributeText: CDAUIAttributeTextStyle {
            get { return self.label.attributed }
            set { self.label.attributed = newValue }
        }
        
        public var shadow: CDAUIShadowStyle {
            get { return self.label.shadow }
            set { self.label.shadow = newValue }
        }
        
        public var inset: CDAUIInsetStyle {
            get { return self.label.inset }
            set { self.label.inset = newValue }
        }
    }
}
