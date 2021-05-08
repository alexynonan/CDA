//
//  CDAAttributedString.swift
//  CDAUtilities
//
//  Created by Alexander on 5/05/21.
//

import Foundation
import UIKit

extension NSAttributedString {
    
    public func getSizeToWidth(_ width: CGFloat) -> CGSize {
        
        let size = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        return self.boundingRect(with: size, options: [.usesLineFragmentOrigin], context: nil).size
    }
    
    public func getSizeToHeight(_ height: CGFloat) -> CGSize {
        
        let size = CGSize(width: CGFloat.greatestFiniteMagnitude, height: height)
        return self.boundingRect(with: size, options: [.usesLineFragmentOrigin], context: nil).size
    }
    
    public class func createWith(text: String, font: UIFont = UIFont.systemFont(ofSize: UIFont.systemFontSize), color: UIColor = .black) -> NSMutableAttributedString {
        
        let style = NSMutableParagraphStyle()
        style.alignment = .left
        
        let dicAttributes = [NSAttributedString.Key.font : font,
                             NSAttributedString.Key.foregroundColor : color,
                             NSAttributedString.Key.paragraphStyle: style]
        
        
        let attribute = NSMutableAttributedString(string: text, attributes: dicAttributes)
        return attribute
    }
}


extension NSMutableAttributedString {
    
    public func addAttribute(_ key: NSAttributedString.Key, value: Any) {
        
        let range = NSRange(location: 0, length: self.string.count)
        self.addAttribute(key, value: value, range: range)
    }
    
    public func removeAttribute(_ key: NSAttributedString.Key) {
        
        let range = NSRange(location: 0, length: self.string.count)
        self.removeAttribute(key, range: range)
    }
}

//MARK: - Add Attributes

extension NSMutableAttributedString {
    
    @discardableResult public func addMiddleline(_ add: Bool, color: UIColor? = nil) -> NSMutableAttributedString {
    
        let keyStyle = NSAttributedString.Key.strikethroughStyle
        let value = NSUnderlineStyle.single.rawValue
        add ? self.addAttribute(keyStyle, value: value) : self.removeAttribute(keyStyle)
        
        guard let color = color else { return self }
        let keyColor = NSAttributedString.Key.strikethroughColor
        add ? self.addAttribute(keyColor, value: color) : self.removeAttribute(keyColor)
        return self
    }
    
    @discardableResult public func addUnderline(_ add: Bool, color: UIColor? = nil) -> NSMutableAttributedString {
        
        let key = NSAttributedString.Key.underlineStyle
        let value = NSUnderlineStyle.single.rawValue
        add ? self.addAttribute(key, value: value) : self.removeAttribute(key)
        
        guard let color = color else { return self }
        let keyColor = NSAttributedString.Key.underlineColor
        add ? self.addAttribute(keyColor, value: color) : self.removeAttribute(keyColor)
        return self
    }
    
    @discardableResult public func lineSpacing(_ lineSpacing: CGFloat) -> NSMutableAttributedString {
        
        if self.length == 0 { return self }
        var range = NSRange(location: 0, length: self.length)
        
        let paragraphStyle = self.attribute(NSAttributedString.Key.paragraphStyle, at: 0, effectiveRange: &range) as? NSMutableParagraphStyle ?? NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        
        let key = NSAttributedString.Key.paragraphStyle
        self.addAttribute(key, value: paragraphStyle)
        return self
    }
    
    @discardableResult public func paragraphSpacing(_ paragraphSpacing: CGFloat) -> NSMutableAttributedString {
        
        if self.length == 0 { return self }
        var range = NSRange(location: 0, length: self.length)
        
        let paragraphStyle = self.attribute(NSAttributedString.Key.paragraphStyle, at: 0, effectiveRange: &range) as? NSMutableParagraphStyle ?? NSMutableParagraphStyle()
        paragraphStyle.paragraphSpacing = paragraphSpacing
        
        let key = NSAttributedString.Key.paragraphStyle
        self.addAttribute(key, value: paragraphStyle)
        return self
    }
    
    @discardableResult public func textAlignment(_ aligment: NSTextAlignment) -> NSMutableAttributedString {
        
        if self.length == 0 { return self }
        var range = NSRange(location: 0, length: self.length)
        
        let paragraphStyle = self.attribute(NSAttributedString.Key.paragraphStyle, at: 0, effectiveRange: &range) as? NSMutableParagraphStyle ?? NSMutableParagraphStyle()
        paragraphStyle.alignment = aligment
        
        let key = NSAttributedString.Key.paragraphStyle
        self.addAttribute(key, value: paragraphStyle)
        return self
    }
}
