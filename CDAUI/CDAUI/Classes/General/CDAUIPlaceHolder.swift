//
//  CDAUIPlaceHolder.swift
//  CDAUI
//
//  Created by Alexander on 8/05/21.
//

import UIKit
import CDAUtilities

extension CDAUIPlaceHolderStyle {
    
    public struct Text {
        public var scale: CGFloat = 0.8
        public var color: UIColor = .lightGray
        public var attributeText: NSAttributedString?
    }
}

public struct CDAUIPlaceHolderStyle {
    
    public var isFloating: Bool = false
    public var text = Text()
}

protocol CDAUIPlaceHolder {
    
    var placeholderStyle: CDAUIPlaceHolderStyle { get set }
    
    var isFloating              : Bool      { get set }
    var place_color             : UIColor   { get set }
    var lblPlaceholder          : UILabel   { get set }
    var internalLblPlaceholder  : UILabel?  { get }
    
    func updateColorPlaceHolderWhenChangeStatus(_ color: UIColor)
}

extension CDAUIPlaceHolder where Self: UITextField, Self: CDAUIInset, Self: CDAUIInputBorderSate{
    
    internal var internalLblPlaceholder: UILabel? {
        return self.subviews.filter({ return $0 is UILabel}).first as? UILabel
    }

    func updatePlaceholderAppearance() {
        self.internalLblPlaceholder?.textColor = self.placeholderStyle.text.color
        
        if self.placeholderStyle.isFloating {
            self.lblPlaceholder.textColor = self.placeholderStyle.text.color
        }
    }
    
    func updateColorPlaceHolderWhenChangeStatus(_ color: UIColor) {
        if self.placeholderStyle.isFloating {
            
            if self.borderSate.state == .normal {
                self.lblPlaceholder.textColor = self.placeholderStyle.text.color
            }else{
                self.lblPlaceholder.textColor = color
            }
        }
    }
    
    func animatePlaceholderToDown() {
        
        if !self.placeholderStyle.isFloating { return }
        
        UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseOut, animations: {
            self.lblPlaceholder.transform = .identity
        }) { (_) in
            self.lblPlaceholder.removeFromSuperview()
            self.internalLblPlaceholder?.isHidden = false
        }
    }
    
    func animatePlaceholderToUp() {

        if !self.placeholderStyle.isFloating { return }
        
        let scale = self.placeholderStyle.text.scale
        let delta_y = -self.frame.height/2
        let newWidth = self.lblPlaceholder.frame.width * scale
        let newOriginPlaceholder = self.lblPlaceholder.center.x - (newWidth/2)
        let delta_x = self.frame.origin.x - newOriginPlaceholder + 10
        
        self.internalLblPlaceholder?.isHidden = true
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.2, options: .curveEaseOut, animations: {

            self.lblPlaceholder.transform = CGAffineTransform(translationX: delta_x, y: delta_y).scaledBy(x: scale, y: scale)
            self.lblPlaceholder.layoutIfNeeded()

        }, completion: nil)
    }
    
    internal func addConstraintsToPlaceHolder() {

        self.superview?.insertSubview(self.lblPlaceholder, aboveSubview: self)
        self.lblPlaceholder.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.lblPlaceholder.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: self.internalInsets.left).isActive = true
        self.superview?.layoutIfNeeded()
    }
}
