//
//  CDAUIInputSafeKeyboard.swift
//  CDAUI
//
//  Created by Alexander on 8/05/21.
//

import UIKit

extension CDAUISafeKeyboardStyle {
    
    public struct Storyboard {
        public var name         : String? = nil
        public var identifier   : String? = nil
    }
}

public struct CDAUISafeKeyboardStyle {
    
    public var enable       = false
    public var storyboard   = Storyboard()
}

protocol CDAUIInputSafeKeyboard where Self: UIResponder {
    
    var safeKeyboard        : CDAUISafeKeyboardStyle     { get set }
    var keyboardEnabled     : Bool                      { get set }
    var storyboardName      : String?                   { get set }
    var controllerIdentifier: String?                   { get set }
    
    var _inputViewController: UIInputViewController?    { get set }
    
    func updateSafeKeyaboardAppearance()
}

extension CDAUIInputSafeKeyboard {
    
    func getSafeKeyboard() -> UIInputViewController? {
                
        guard let storyboardName = self.safeKeyboard.storyboard.name else { return CDAUISafeKeyboard() }
        guard let storyboardIdentifier = self.safeKeyboard.storyboard.identifier else { return CDAUISafeKeyboard() }
                
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: storyboardIdentifier) as? UIInputViewController ?? CDAUISafeKeyboard()
    }
}
