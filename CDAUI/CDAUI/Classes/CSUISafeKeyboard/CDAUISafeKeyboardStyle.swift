//
//  CDAUIStyleSafeKeyboard.swift
//  CDAUI
//
//  Created by Alexander on 8/05/21.
//

import UIKit

public struct SCUISafeKeyboardStyle {
    
    public var buttonKeyboard   = Button()
    public var verticalSpacing  : CGFloat = 7
    public var horizontaSpacing : CGFloat = 6
    
    public var inset = CDAUIInsetStyle(top: 6,
                                      left: 5.5,
                                      bottom: CDAUIInsetStyle.safeAreaInsets?.bottom == 0 ? 3 : 44,
                                      right: 5.5)
}

extension SCUISafeKeyboardStyle {
    
    public struct Button {
        public var corner           = CDAUICornerStyle(radius: 5)
        public var border           = CDAUIBorderStyle()
        public var shadow           = CDAUIShadowStyle()
        public var backgroundColor  = UIColor.white
        public var textColor        = UIColor.black
        public var fontSize         : CGFloat = 24
        public var fontType         = Font.regular
    }
}

extension SCUISafeKeyboardStyle.Button {
    
    public enum Font: Int {
        case ultraLight = 0
        case thin
        case light
        case regular
        case medium
        case semibold
        case bold
        case heavy
        case black
    }
}

extension SCUISafeKeyboardStyle.Button.Font {
    
    public func systemFontToSize(_ fontSize: CGFloat) -> UIFont {
        switch self {
            case .ultraLight:
                return UIFont.systemFont(ofSize: fontSize, weight: UIFont.Weight.ultraLight)
            case .thin:
                return UIFont.systemFont(ofSize: fontSize, weight: UIFont.Weight.thin)
            case .light:
                return UIFont.systemFont(ofSize: fontSize, weight: UIFont.Weight.light)
            case .regular:
                return UIFont.systemFont(ofSize: fontSize, weight: UIFont.Weight.regular)
            case .medium:
                return UIFont.systemFont(ofSize: fontSize, weight: UIFont.Weight.medium)
            case .semibold:
                return UIFont.systemFont(ofSize: fontSize, weight: UIFont.Weight.semibold)
            case .bold:
                return UIFont.systemFont(ofSize: fontSize, weight: UIFont.Weight.bold)
            case .heavy:
                return UIFont.systemFont(ofSize: fontSize, weight: UIFont.Weight.heavy)
            case .black:
                return UIFont.systemFont(ofSize: fontSize, weight: UIFont.Weight.black)
        }
    }
}

@IBDesignable open class CSUIStyleSafeKeyboard: UIInputView {
    
    public var style = SCUISafeKeyboardStyle()
    
}
