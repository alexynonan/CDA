//
//  CDAUIInputTextRestrict.swift
//  CDAUI
//
//  Created by Alexander on 8/05/21.
//

import UIKit

extension CDAUIInputTextRestrictStyle {
    
    public struct Permissions: OptionSet {
        
        public let rawValue: Int
    
        public static let all               = Permissions(rawValue: 1 << 0)
        public static let email             = Permissions(rawValue: 1 << 1)
        public static let number            = Permissions(rawValue: 1 << 2)
        public static let decimal           = Permissions(rawValue: 1 << 3)
        public static let alphabetic        = Permissions(rawValue: 1 << 4)
        public static let accent            = Permissions(rawValue: 1 << 5)
        public static let punctuationMark   = Permissions(rawValue: 1 << 6)
        
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
    }
}

public struct CDAUIInputTextRestrictStyle {

    public var maxLength: Int = 250
    public var allow    : Permissions = .all
}


protocol CDAUIInputTextRestrict {
    
    var maxLength       : Int       { get set }
    var allowEmail      : Bool      { get set }
    var allowNumbers    : Bool      { get set }
    var allowAlphabetic : Bool      { get set }
    var allowAccent     : Bool      { get set }
    var allowDecimal    : Bool      { get set }
    
    var restrictions    : CDAUIInputTextRestrictStyle { get set }
    
    func updateRestrictAppearance()
}

extension CDAUIInputTextRestrict {
    
    func getTextPermissions() -> CDAUIInputTextRestrictStyle.Permissions {
        
        var arrayRestrictions = [CDAUIInputTextRestrictStyle.Permissions]()
        
        if self.allowEmail      { arrayRestrictions.append(.email) }
        if self.allowNumbers    { arrayRestrictions.append(.number) }
        if self.allowAlphabetic { arrayRestrictions.append(.alphabetic) }
        if self.allowAccent     { arrayRestrictions.append(.accent) }
        if self.allowDecimal    { arrayRestrictions.append(.decimal) }
        
        let restrictions = arrayRestrictions.count == 0 ? .all : CDAUIInputTextRestrictStyle.Permissions(arrayRestrictions)
        return restrictions
    }
    
    func applyMaxLengthToText(_ text: String?) -> String? {
        
        var text = text
        if text?.count ?? 0 > self.restrictions.maxLength {
            let range = self.restrictions.maxLength...((text?.count ?? self.restrictions.maxLength) - 1)
            text = text?.replaceByString("", inRange: range)
        }
        return text
    }
    
    func getTextAllowed() -> String {
        
        var allowText = ""
            
        if self.restrictions.allow.contains(.number)            { allowText += "0-9" }
        if self.restrictions.allow.contains(.decimal)           { allowText += "0-9." }
        if self.restrictions.allow.contains(.alphabetic)        { allowText += "A-Za-z " }
        if self.restrictions.allow.contains(.email)             { allowText += "@.-_A-Za-z0-9-" }
        if self.restrictions.allow.contains(.accent)            { allowText += "ÑñÁáÉéÍíÓóÚú " }
        if self.restrictions.allow.contains(.punctuationMark)   { allowText += ",.;:/'-" }
        
        return "[^\(allowText)]"
    }
}
