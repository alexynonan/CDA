//
//  CDAUIInputState.swift
//  CDAUI
//
//  Created by Alexander on 8/05/21.
//

import UIKit

extension CDAUIInputBorderStateStyle {
    
    public enum State: Int {
        case normal     = 0
        case editing    = 1
        case endEditing = 2
        case error      = 3
    }
}

extension CDAUIInputBorderStateStyle {
    
    public struct Color {
        public var normal       : UIColor?
        public var editing      : UIColor?
        public var endEditing   : UIColor?
        public var error        : UIColor?
    }
}

public struct CDAUIInputBorderStateStyle {
    
    public var state : State = .normal
    public var color = Color()
}

protocol CDAUIInputBorderSate {
    
    var borderSate: CDAUIInputBorderStateStyle { get set }
    
    var editing_state       : UIColor? { get set }
    var endEditing_state    : UIColor? { get set }
    var error_state         : UIColor? { get set }
    
    func updateBorderStateAppearance()
}

extension CDAUIInputBorderSate where Self: CDAUIBorder, Self: UIResponder {

    func getMainSuperView(_ view: UIView) -> UIView {
        if let newSuperView = view.superview { return self.getMainSuperView(newSuperView) }
        return view
    }
    
    func getBorderColorToSate() -> UIColor {
        
        switch self.borderSate.state {
        case .normal:
            return self.borderSate.color.normal ?? self.border.color
        case .editing:
            return self.borderSate.color.editing ?? self.border.color
        case .endEditing:
            return self.borderSate.color.endEditing ?? self.border.color
        case .error:
            return self.borderSate.color.error ?? self.border.color
        }
    }
    
    func getBorderStateToText(_ text: String) -> CDAUIInputBorderStateStyle.State {
        
        if text.count == 0 && !self.isFirstResponder {
            return .normal
        }else if text.count > 0 && !self.isFirstResponder {
            return .endEditing
        }
        
        return .editing
    }
}
