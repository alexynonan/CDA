//
//  CDAUISafeKeyboardView.swift
//  CDAUI
//
//  Created by Alexander on 8/05/21.
//

import UIKit

public protocol CDAUISafeKeyboardViewDelegate {
    func safeKeyboardView(_ keyboard: CDAUISafeKeyboardView, tapInKeyWithValue value: String)
    func safeKeyboardViewPressDeleteButton(_ keyboard: CDAUISafeKeyboardView)
}

@IBDesignable public class CDAUISafeKeyboardView: CDAUIAppearanceSafeKeyboardStyle {

    @IBInspectable public var backIcon: UIImage? = UIImage(named: "ic_delete.left")
    @IBInspectable public var backColor: UIColor = .black
    
    public var delegate: CDAUISafeKeyboardViewDelegate?
    
    lazy var arrayKeyButtons: [CDAUIButton] = {
        
        let randomArray = Array(0...9).shuffled()
        
        var arrayKeyButtons = [CDAUIButton]()
        for value in randomArray {
            arrayKeyButtons.append(self.drawButtonWithValue(value, inView: self))
        }
        
        return arrayKeyButtons
    }()
    
    private lazy var btnBack: CDAUIButton = {
        
        let btnBack = CDAUIButton(type: .system)
        btnBack.backgroundColor  = .clear
        btnBack.setImage(self.backIcon, for: .normal)
        btnBack.tintColor = self.backColor
        btnBack.translatesAutoresizingMaskIntoConstraints = false
        btnBack.addTarget(self, action: #selector(self.tapKeyBack(_:)), for: .touchUpInside)
        return btnBack
    }()
        
    public func shuffledValues(){
        
        let randomArray = Array(0...9).shuffled()
        for (index, btn) in self.arrayKeyButtons.enumerated() {
            btn.setTitle("\(randomArray[index])", for: .normal)
        }
    }
    
    private func drawButtonWithValue(_ value: Any, inView view: UIView) -> CDAUIButton {

        let btnKey = CDAUIButton(type: .system)
        btnKey.corner = self.style.buttonKeyboard.corner
        btnKey.border = self.style.buttonKeyboard.border
        btnKey.shadow = self.style.buttonKeyboard.shadow
        btnKey.backgroundColor = self.style.buttonKeyboard.backgroundColor
        
        let fontSize = self.style.buttonKeyboard.fontSize
        btnKey.titleLabel?.font = self.style.buttonKeyboard.fontType.systemFontToSize(fontSize)
        btnKey.setTitleColor(self.style.buttonKeyboard.textColor, for: .normal)
        btnKey.setTitle("\(value)", for: .normal)
        btnKey.translatesAutoresizingMaskIntoConstraints = false
        btnKey.addTarget(self, action: #selector(self.tapKeyInKeyboard(_:)), for: .touchUpInside)
        view.addSubview(btnKey)
        
        return btnKey
    }
    
    @objc private func tapKeyBack(_ btn: CDAUIButton) {
        self.delegate?.safeKeyboardViewPressDeleteButton(self)
    }
    
    @objc private func tapKeyInKeyboard(_ btn: CDAUIButton) {
        self.delegate?.safeKeyboardView(self, tapInKeyWithValue: btn.titleLabel?.text ?? "")
    }
    
    private func addHorizontalConstraints(){
        
        for (index, btn) in self.arrayKeyButtons.enumerated(){
            
            if index > 0 {
                btn.widthAnchor.constraint(equalTo: self.arrayKeyButtons[index - 1].widthAnchor).isActive = true
            }
            
            if index < self.arrayKeyButtons.count - 1 {
                
                let rest = index % 3
                
                if rest == 0 {
                    btn.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: self.style.inset.left).isActive = true
                }
        
                if rest == 1 || rest == 2{
                    btn.leadingAnchor.constraint(equalTo: self.arrayKeyButtons[index - 1].trailingAnchor, constant: self.style.horizontaSpacing).isActive = true
                }
                
                if rest == 2 {
                    btn.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -self.style.inset.right).isActive = true
                }
            }else{
                btn.centerXAnchor.constraint(equalToSystemSpacingAfter: self.centerXAnchor, multiplier: 0).isActive = true
                self.btnBack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -self.style.inset.right).isActive = true
                self.btnBack.widthAnchor.constraint(equalTo: btn.widthAnchor).isActive = true
                self.btnBack.topAnchor.constraint(equalTo: btn.topAnchor).isActive = true
                self.btnBack.heightAnchor.constraint(equalTo: btn.heightAnchor).isActive = true
            }
        }
    }
    
    private func addVerticalConstraints(){
        
        for (index, btn) in self.arrayKeyButtons.enumerated(){
            
            if index > 0 {
                btn.heightAnchor.constraint(equalTo: self.arrayKeyButtons[index - 1].heightAnchor).isActive = true
            }
        
            if index < 3{
                btn.topAnchor.constraint(equalTo: self.topAnchor, constant: self.style.inset.top).isActive = true
            }else {
                btn.topAnchor.constraint(equalTo: self.arrayKeyButtons[index - 3].bottomAnchor, constant: self.style.verticalSpacing).isActive = true
            }
        }
        
        let safeArea = self.superview?.safeAreaInsets.bottom ?? 0
        self.arrayKeyButtons.last?.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -(self.style.inset.bottom + safeArea)).isActive = true
    }
    
    override public func draw(_ rect: CGRect) {
        
        super.draw(rect)
        
        self.addSubview(self.btnBack)
        self.addHorizontalConstraints()
        self.addVerticalConstraints()
    }
    
    override public func prepareForInterfaceBuilder() {
    
        super.prepareForInterfaceBuilder()
    }
    
    public func updateHorizontalConstraints(){
        
        for (index, btn) in self.arrayKeyButtons.enumerated(){
            
            if index > 0 {
                btn.widthAnchor.constraint(equalTo: self.arrayKeyButtons[index - 1].widthAnchor).isActive = true
            }
            
            if index < self.arrayKeyButtons.count - 1 {
                
                let rest = index % 3
                
                if rest == 0 {
                    btn.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: self.style.inset.left).isActive = true
                }
                
                if rest == 1 || rest == 2{
                    btn.leadingAnchor.constraint(equalTo: self.arrayKeyButtons[index - 1].trailingAnchor, constant: self.style.horizontaSpacing).isActive = true
                }
                
                if rest == 2 {
                    btn.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -self.style.inset.right).isActive = true
                }
            }else{
                btn.centerXAnchor.constraint(equalToSystemSpacingAfter: self.centerXAnchor, multiplier: 0).isActive = true
                self.btnBack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -self.style.inset.right).isActive = true
                self.btnBack.widthAnchor.constraint(equalTo: btn.widthAnchor).isActive = true
                self.btnBack.topAnchor.constraint(equalTo: btn.topAnchor).isActive = true
                self.btnBack.heightAnchor.constraint(equalTo: btn.heightAnchor).isActive = true
            }
        }
    }
}

