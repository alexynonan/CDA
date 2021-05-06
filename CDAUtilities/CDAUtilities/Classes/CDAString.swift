//
//  CDAString.swift
//  CDAUtilities
//
//  Created by Alexander on 5/05/21.
//

import Foundation

extension String {
    
    public var trim: String {
        return self.trimmingCharacters(in: CharacterSet.whitespaces)
    }
    
    public var localized: String {
        
        let languageString = "\((UserDefaults.standard.object(forKey: "AppleLanguages") as? [String])?.first?.split(separator: "-").first ?? "es")"
        let stringPath = Bundle.main.path(forResource: languageString, ofType: "lproj") ?? ""
        let bundle = Bundle(path: stringPath) ?? Bundle.main
        return NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: "")
    }
    
    public var base64Decode: Data? {
        
        var base64 = self
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        
        let length = Double(base64.lengthOfBytes(using: String.Encoding.utf8))
        let requiredLength = 4 * ceil(length / 4.0)
        let paddingLength = requiredLength - length
        
        if paddingLength > 0 {
            let padding = "".padding(toLength: Int(paddingLength), withPad: "=", startingAt: 0)
            base64 += padding
        }
        
        return Data(base64Encoded: base64, options: .ignoreUnknownCharacters)
    }

    public func replaceByString(_ string: String, inRange range: CountableClosedRange<Int>) -> String {
        
        let start = index(string.startIndex, offsetBy: range.lowerBound)
        let end   = index(start, offsetBy: range.count)
        
        return self.replacingCharacters(in: start ..< end, with: string)
    }
    
//    MARK: - Validate
    
    public var hasDigit: Bool {
        
        let regex = "^(?=.*[0-9]).{1,}$"
        return self.hasCorrectFormatToRegex(regex)
    }
    
    public var hasLowerLetter: Bool {
        
        let regex = "^(?=.*[a-z]).{1,}$"
        return self.hasCorrectFormatToRegex(regex)
    }
    
    public var hasUpperLetter: Bool {
        
        let regex = "^(?=.*[A-Z]).{1,}$"
        return self.hasCorrectFormatToRegex(regex)
    }
    
    public var hasSpecialCharacter: Bool {
        
        let regex = "^(?=.*[!@#$%*]).{1,}$"
        return self.hasCorrectFormatToRegex(regex)
    }
    
    public var hasALetter: Bool {
        
        let regex = "^(?=.*[a-zA-Z]).{1,}$"
        return self.hasCorrectFormatToRegex(regex)
    }
    
    public var hasCellPhoneFormat: Bool {
        
        let regex = "^9[0-9]{8}$"
        return self.hasCorrectFormatToRegex(regex)
    }
    
    public var hasEmailFormat: Bool {
        
        let regex = "^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$"
        return self.hasCorrectFormatToRegex(regex)
    }
    
    public func hasCorrectFormatToRegex(_ regex: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }
    
    public func toSecureText(charactersToShow: Int = 3) -> String {
        return "****\(self.suffix(charactersToShow))"
    }
    
    public func toSecureEmail(charactersToShow: Int = 3) -> String {
        
        if self.hasEmailFormat {
            let emailComponents = self.components(separatedBy: "@")

            if emailComponents.count == 2 {
                let user = emailComponents.first ?? ""
                let domain = emailComponents.last ?? ""
                return "\(user.toSecureText(charactersToShow: charactersToShow))@\(domain)"
            }else {
                return self.toSecureText(charactersToShow: charactersToShow)
            }
            
        }else {
            return self.toSecureText(charactersToShow: charactersToShow)
        }
    }
    
}
