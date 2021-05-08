//
//  CSUIFormValidator.swift
//  CDAUI
//
//  Created by Alexander on 8/05/21.
//

import UIKit

extension CDAUIInputForm {
    
    public struct RestrictionType: OptionSet {
        
        public let rawValue: Int

        public static let text                      = RestrictionType(rawValue: 1 << 0)
        public static let email                     = RestrictionType(rawValue: 1 << 1)
        public static let cellPhone                 = RestrictionType(rawValue: 1 << 2)
        public static let atLeastDigit              = RestrictionType(rawValue: 1 << 3)
        public static let atLeastLowerLetter        = RestrictionType(rawValue: 1 << 4)
        public static let atLeastUpperLetter        = RestrictionType(rawValue: 1 << 5)
        public static let atLeastSpecialCharacter   = RestrictionType(rawValue: 1 << 6)
        public static let atLeastALetter            = RestrictionType(rawValue: 1 << 7)
        fileprivate static let matchContent         = RestrictionType(rawValue: 1 << 8)
        fileprivate static let rangeNumber          = RestrictionType(rawValue: 1 << 9)
        
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
    }
}

public class CDAUIInputForm {
    
    public class Validation: NSObject {
        
        @objc dynamic fileprivate var textField         : CDAUITextField
        fileprivate var errorMessage                    : String?
        fileprivate var minLength                       : Int
        fileprivate var restrictiontype                 : RestrictionType
        fileprivate var isAValidFormat                  = false
        @objc dynamic fileprivate var textfieldToMatch  : CDAUITextField?
        fileprivate var range                           : ClosedRange<Double>
        
        private var inputObserver: NSKeyValueObservation?
        private var inputMatchObserver: NSKeyValueObservation?
        
        fileprivate init(textfield          : CDAUITextField,
                         textfieldToMatch   : CDAUITextField? = nil,
                         range              : ClosedRange<Double> = 0...0,
                         typeFormat         : RestrictionType = .text,
                         errorMessage       : String?, minLength: Int = 0) {
            
            self.textField          = textfield
            self.errorMessage       = errorMessage
            self.minLength          = minLength
            self.restrictiontype    = typeFormat
            self.textfieldToMatch   = textfieldToMatch
            self.range              = range
        }
        
        fileprivate func initObserver() {
            
            self.inputObserver = observe(\.textField.text, options: [.new]) { (object, change) in
                
                let newText = self.restrictiontype == .matchContent ? (self.textfieldToMatch?.text ?? "") : ((change.newValue ?? "") ?? "")
                let textSize = newText.count
                self.isAValidFormat = false
                
                if textSize >= self.minLength {
                    self.isAValidFormat = self.matchRegexTypeFormatToText(newText)
                }
            }
        }
        
        fileprivate func initMatchObserver() {
            
            self.inputMatchObserver = observe(\.textfieldToMatch?.text, options: [.new]) { (object, change) in
                
                let newText = ((change.newValue ?? "") ?? "")
                self.isAValidFormat = newText == self.textField.text
                
                if let errorMessage = self.errorMessage, !self.isAValidFormat, self.textField.text?.count != 0 {
                    self.textField.showErrorMessageWithText(errorMessage)
                }else{
                    self.textField.hideErrorMessage()
                }
            }
        }
        
        private func matchRegexTypeFormatToText(_ newText: String) -> Bool {
            
            var result = true
            
            let num = Double(newText) ?? .zero
        
            if self.restrictiontype.contains(.email),                   !newText.hasEmailFormat         { result = false }
            if self.restrictiontype.contains(.cellPhone),               !newText.hasCellPhoneFormat     { result = false }
            if self.restrictiontype.contains(.atLeastDigit),            !newText.hasDigit               { result = false }
            if self.restrictiontype.contains(.atLeastLowerLetter),      !newText.hasLowerLetter         { result = false }
            if self.restrictiontype.contains(.atLeastUpperLetter),      !newText.hasUpperLetter         { result = false }
            if self.restrictiontype.contains(.atLeastSpecialCharacter), !newText.hasSpecialCharacter    { result = false }
            if self.restrictiontype.contains(.atLeastALetter),          !newText.hasALetter             { result = false }
            if self.restrictiontype.contains(.matchContent),            newText != self.textField.text  { result = false }
            if self.restrictiontype.contains(.rangeNumber),             !self.range.contains(num)       { result = false }
            
            return result
        }
        
        deinit {
            self.inputObserver = nil
            self.inputMatchObserver = nil
        }
    }
}

extension Array where Element == CDAUIInputForm.Validation {
    
    public mutating func validateAll() -> Bool {
        
        self.forEach({ self.showErrorMessageIfNecessaryToInpunt($0.textField) })
        return self.allValidationsAreCorrect
    }
    
    public var allValidationsAreCorrect: Bool {
        return self.filter({ $0.isAValidFormat == false}).count == 0
    }
    
    public mutating func register(textfield: CDAUITextField, typeFormat: CDAUIInputForm.RestrictionType = .text, errorMessage: String? = nil, minLength: Int = 0) {
        
        let validation = CDAUIInputForm.Validation(textfield: textfield, typeFormat: typeFormat, errorMessage: errorMessage, minLength: minLength)
        validation.initObserver()
        self.append(validation)
    }
    
    public mutating func register(textfield: CDAUITextField, toMatchContent textfieldToMatch: CDAUITextField, errorMessage: String? = nil) {
        
        let validation = CDAUIInputForm.Validation(textfield: textfield, textfieldToMatch: textfieldToMatch, typeFormat: .matchContent, errorMessage: errorMessage)
        validation.initObserver()
        validation.initMatchObserver()
        self.append(validation)
    }
    
    public mutating func register(textfield: CDAUITextField, withRange range: ClosedRange<Double>, errorMessage: String? = nil) {
        
        let validation = CDAUIInputForm.Validation(textfield: textfield, range: range, typeFormat: .rangeNumber, errorMessage: errorMessage)
        validation.initObserver()
        self.append(validation)
    }
    
    public mutating func allValidationsAreCorrectTo(textfield: CDAUITextField) -> Bool {
        return self.filter({ $0.textField == textfield && $0.isAValidFormat == false }).count == 0
    }
    
    public mutating func deregister(textfield: CDAUITextField) {
        self.removeAll(where: { $0.textField == textfield})
    }
    
    public mutating func showErrorMessageIfNecessaryToInpunt(_ textField: CDAUITextField) {
        
        guard let validation = self.first(where: { $0.textField == textField && !$0.isAValidFormat}) else { return }
        guard let errorMessage = validation.errorMessage else { return }
        
        validation.textField.showErrorMessageWithText(errorMessage)
    }
}

public protocol CDAUIInputFormValidator {
    
    var validations: [CDAUIInputForm.Validation] { get }
}
