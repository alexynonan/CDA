//
//  CDAUIView.swift
//  CDAUI
//
//  Created by Alexander on 8/05/21.
//

import UIKit

@IBDesignable open class CDAUIView: CDAUIShadowView {
    
    public lazy var style: Style = {
        return Style(view: self)
    }()
}

extension CDAUIView {
    
    public struct Style {
        
        private var view: CDAUIView
        
        init(view: CDAUIView) {
            self.view = view
        }
        
        public var corner: CDAUICornerStyle {
            get { return self.view.corner }
            set { self.view.corner = newValue }
        }
        
        public var shadow: CDAUIShadowStyle {
            get { return self.view.shadow }
            set { self.view.shadow = newValue }
        }
        
        public var border: CDAUIBorderStyle {
            get { return self.view.border }
            set { self.view.border = newValue }
        }
    }
}
