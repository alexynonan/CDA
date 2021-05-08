//
//  CDAUITextField.swift
//  CDAUI
//
//  Created by Alexander on 8/05/21.
//

import UIKit

@objc public protocol CDAUITextFieldDelegate {
    
    @objc optional func textFieldDeleteBackward(_ textField: CDAUITextField)
    @objc optional func textFieldUserDidEndEditing(_ textField: CDAUITextField)
    @objc optional func textField(_ textField: CDAUITextField, tapInLeftIconButton button: UIButton)
    @objc optional func textField(_ textField: CDAUITextField, tapInRightIconButton button: UIButton)
}

@IBDesignable open class CDAUITextField: CDAUIInputSafeKeyboardTextField {
    
    @IBOutlet weak open var textFieldDelegate: CDAUITextFieldDelegate?
    
    public lazy var style: Style = {
        return Style(textField: self)
    }()
    
    private var typingTimer         : DispatchSourceTimer?
    private var objText_textField   : NSKeyValueObservation?
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        
        self.objText_textField = observe(\.text, options: [.new]) { (object, change) in
            self.startTimeOutTyping()
        }
    }

    public func clearContent() {
        self.text = nil
        self.hideErrorMessage()
        self.text = nil
    }
    
    private func startTimeOutTyping() {
        
        self.cancelTimerKeyboard()
        self.typingTimer = DispatchSource.makeTimerSource()
        self.typingTimer?.schedule(deadline: .now() + 1, repeating: 1)
        self.typingTimer?.setEventHandler(handler: {
            
            DispatchQueue.main.async {
                self.cancelTimerKeyboard()
                if self.text?.count != 0 {
                    self.textFieldDelegate?.textFieldUserDidEndEditing?(self)
                }
            }
        })

        self.typingTimer?.activate()
    }
    
    private func cancelTimerKeyboard(){
        
        self.typingTimer?.cancel()
        self.typingTimer = nil
    }
    
    public override func deleteBackward() {
        
        super.deleteBackward()
        self.textFieldDelegate?.textFieldDeleteBackward?(self)
    }
    
    deinit {
        self.objText_textField = nil
    }
}

extension CDAUITextField {
    
    public struct Style {
        
        private var textField: CDAUITextField
        
        init(textField: CDAUITextField) {
            self.textField = textField
        }
        
        public var inputRestrictions: CDAUIInputTextRestrictStyle {
            get { return self.textField.restrictions }
            set { self.textField.restrictions = newValue }
        }
        
        public var inset: CDAUIInsetStyle {
            get { return self.textField.inset }
            set { self.textField.inset = newValue }
        }
        
        public var corner: CDAUICornerStyle {
            get { return self.textField.corner }
            set { self.textField.corner = newValue }
        }
        
        public var border: CDAUIBorderStyle {
            get { return self.textField.border }
            set { self.textField.border = newValue }
        }
        
        public var borderState: CDAUIInputBorderStateStyle {
            get { return self.textField.borderSate }
            set { self.textField.borderSate = newValue }
        }
        
        public var placeHolder: CDAUIPlaceHolderStyle {
            get { return self.textField.placeholderStyle }
            set { self.textField.placeholderStyle = newValue }
        }
        
        public var shadow: CDAUIShadowStyle {
            get { return self.textField.shadow }
            set { self.textField.shadow = newValue }
        }
        
        public var icons: CDAUIIconsTextFieldStyle {
            get { return self.textField.icons }
            set { self.textField.icons = newValue }
        }
        
        public var inputError: CDAUIInputErrorStyle {
            get { return self.textField.errorMessage }
            set { self.textField.errorMessage = newValue }
        }
        
        public var safeKeyboard: CDAUISafeKeyboardStyle {
            get { return self.textField.safeKeyboard }
            set { self.textField.safeKeyboard = newValue }
        }
    }
}




