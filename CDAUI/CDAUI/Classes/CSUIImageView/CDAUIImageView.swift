//
//  CDAUIImageView.swift
//  CDAUI
//
//  Created by Alexander on 8/05/21.
//

import Foundation

@IBDesignable open class CDAUIImageView: CDAUIShadowImageView {
    
    public lazy var style: Style = {
        return Style(view: self)
    }()
    
    public func autoContentMode() {
           
        let widthImage = self.image?.size.width ?? 0
        let heightImage = self.image?.size.height ?? 0
        let widthContent = self.frame.width
        let heightContent = self.frame.height
        
        if widthImage > heightImage {
            let rateImage = widthImage / heightImage
            let rateContent = widthContent / heightContent
            
            if rateContent >= 1 && rateImage >= 1 {
                self.contentMode = .scaleAspectFill
            }else{
                self.contentMode = .scaleAspectFit
            }
        }else{
            let rateImage = heightImage / widthImage
            let rateContent = heightContent / widthContent
            
            if rateContent >= 1 && rateImage >= 1 {
                self.contentMode = .scaleAspectFill
            }else{
                self.contentMode = .scaleAspectFit
            }
        }
    }
}

extension CDAUIImageView {
    
    public struct Style {
        
        private var view: CDAUIImageView
        
        init(view: CDAUIImageView) {
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

