//
//  CDAUISafeKeyboard.swift
//  CDAUI
//
//  Created by Alexander on 8/05/21.
//

import UIKit

public class CDAUISafeKeyboard: UIInputViewController {

    override public func viewDidLoad() {
            
        super.viewDidLoad()
    
        if let safekeyboard = self.inputView as? CDAUISafeKeyboardView {
            safekeyboard.delegate = self
        }else{
            self.inputView = CDAUISafeKeyboardView()
            (self.inputView as? CDAUISafeKeyboardView)?.delegate = self
        }
        
        self.inputView?.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override public func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        (self.inputView as? CDAUISafeKeyboardView)?.shuffledValues()
    }
}

extension CDAUISafeKeyboard: CDAUISafeKeyboardViewDelegate {
    
    public func safeKeyboardViewPressDeleteButton(_ keyboard: CDAUISafeKeyboardView) {
        self.textDocumentProxy.deleteBackward()
    }
    
    public func safeKeyboardView(_ keyboard: CDAUISafeKeyboardView, tapInKeyWithValue value: String) {
        self.textDocumentProxy.insertText(value)
    }
}

