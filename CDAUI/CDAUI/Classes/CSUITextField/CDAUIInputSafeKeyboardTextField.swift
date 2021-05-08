//
//  CDAUIInputSafeKeyboardTextField.swift
//  CDAUI
//
//  Created by Alexander on 8/05/21.
//

import UIKit

@IBDesignable open class CDAUIInputSafeKeyboardTextField: CDAUIInputErrorTextField, CDAUIInputSafeKeyboard {
    
    internal var safeKeyboard: CDAUISafeKeyboardStyle = CDAUISafeKeyboardStyle() {
        didSet { self.updateSafeKeyaboardAppearance() }
    }
    
    @IBInspectable public var keyboardEnabled: Bool {
        get { return self.safeKeyboard.enable }
        set { self.safeKeyboard.enable = newValue }
    }
    
    @IBInspectable public var storyboardName : String? {
        get{ return self.safeKeyboard.storyboard.name }
        set{ self.safeKeyboard.storyboard.name = newValue }
    }
    
    @IBInspectable public var controllerIdentifier : String? {
        get{ return self.safeKeyboard.storyboard.identifier }
        set{ self.safeKeyboard.storyboard.identifier = newValue }
    }
    
    internal var _inputViewController: UIInputViewController?
    
    override public var inputViewController: UIInputViewController?{
        get { return self._inputViewController }
        set { self._inputViewController = newValue }
    }
    
    func updateSafeKeyaboardAppearance() {
        self._inputViewController = self.getSafeKeyboard()
    }
}
