//
//  CDASystemAlert.swift
//  CDAUtilities
//
//  Created by Alexander on 5/05/21.
//

import UIKit
import Foundation

/**
 This class contains the variables for the creation of the custom `UIAlertAction`.
 */
public class CDAAlertButton {
    
    /// Title of alert button.
    public var title       : String!
    /// Icon of alert button, can be `nil`.
    public var icon        : UIImage?
    /// Color for icon.
    public var tintColor   : UIColor!
    /// Color for title.
    public var textColor   : UIColor!
    
    /**
     The CSAlertButton's contructor.
     
     - Parameters:
        - title:        Title of alert button.
        - icon:         Icon of alert button, for default is `nil`.
        - tintColor:    Color for icon, for default is the system blue color.
        - textColor:    Color for title, for default is the system blue color.
     */
    public init(title: String, icon: UIImage? = nil, tintColor: UIColor = .systemBlue, textColor: UIColor = .systemBlue) {
        self.title      = title
        self.icon       = icon
        self.tintColor  = tintColor
        self.textColor  = textColor
    }
}

extension UIViewController {
    
    /**
     Button completion for system alert & action sheet controller.
     
     - Parameters:
        - index: Index of the selected button.
     */
    public typealias ButtonAction   = ((_ index: Int)-> Void)?
    
    /// Cancel completion for system alert & action sheet controller.
    public typealias CancelAction   = (() -> ())?
    
    /**
     Creates a system alert for `UIViewController`.
     
     - Parameters:
        - title:        Alert's title,  can be `nil`.
        - message:      Alert's message,  can be `nil`.
        - buttons:      Contains the alert's buttons, for default is an empty array.
        - cancel:       Cancel button.
        - completion:   This completion executes when a button is pressed, has a single `Int` argument that indicates the index of the selected button.
        - handler:      This completion executes when cancel button is pressed, can be `nil`.
     */
    public func showAlert(_ title: String?, message: String?, buttons: [CDAAlertButton] = [], cancel: CDAAlertButton, withCompletion completion: ButtonAction = nil, andCancelHandler handler: CancelAction = nil) {
     
        let alert = self.createAlertController(title, message: message, style: .alert, buttons: buttons, cancel: cancel, withCompletion: completion, andCancelHandler: handler)
        self.present(alert, animated: true, completion: nil)
    }
    
    /**
     Creates a system alert for `UIViewController`.
     
     - Parameters:
        - title:        Alert's title,  can be `nil`.
        - message:      Alert's message,  can be `nil`.
        - buttons:      Contains the alert's buttons, for default is an empty array.
        - cancel:       Cancel button.
        - completion:   This completion executes when a button is pressed, has a single `Int` argument that indicates the index of the selected button.
        - handler:      This completion executes when cancel button is pressed, can be `nil`.
     */
    
    public func showAlertGeneral(title : String? = nil, message : String? = nil,cancel : String? = nil,_ completion : (() -> Void)?){
            
        let cancelButton = CDAAlertButton(title: cancel ?? "")
        self.showAlert(title ?? "", message: message ?? "", cancel: cancelButton, andCancelHandler: {
            completion?()
        });
    }
    
    /**
     Creates a system action sheet for `UIViewController`.
    
     - Parameters:
       - title:        Action sheet's title,  can be `nil`.
       - message:      Action sheet's message,  can be `nil`.
       - buttons:      Contains the action sheet's buttons, for default is an empty array.
       - cancel:       Cancel button.
       - completion:   This completion executes when a button is pressed, has a single `Int` argument that indicates the index of the selected button.
       - handler:      This completion executes when cancel button is pressed, can be `nil`.
    */
    public func showActionSheet(_ title: String?, message: String?, buttons: [CDAAlertButton] = [], cancel: CDAAlertButton, withCompletion completion: ButtonAction = nil, andCancelHandler handler: CancelAction = nil) {
     
        let alert = self.createAlertController(title, message: message, style: .actionSheet, buttons: buttons, cancel: cancel, withCompletion: completion, andCancelHandler: handler)
        self.present(alert, animated: true, completion: nil)
    }
    
    /**
     Private function that creates an `UIAlertController`.
     
     With the "style" parameter, we can define if controller is an alert or action sheet, also, set other properties like title, message and buttons.
    
     - Returns: Returns an `UIAlertController`.
     
     - Parameters:
        - title:        Alert's title,  can be `nil`.
        - message:      Alert's message,  can be `nil`.
        - buttons:      Contains the alert's buttons, for default is an empty array.
        - cancel:       Cancel button.
        - completion:   This completion executes when a button is pressed, has a single `Int` argument that indicates the index of the selected button.
        - handler:      This completion executes when cancel button is pressed, can be `nil`.
    */
    private func createAlertController(_ title: String?, message: String?, style: UIAlertController.Style, buttons: [CDAAlertButton], cancel: CDAAlertButton, withCompletion completion:  ButtonAction, andCancelHandler handler: CancelAction)-> UIAlertController {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        
        for (index, button) in buttons.enumerated() {
            let action = self.createAlertAction(button, style: .default) { (action) in completion?(index) }
            alert.addAction(action)
        }
        
        let action = self.createAlertAction(cancel, style: .cancel) { (_) in handler?() }
        alert.addAction(action)
        
        return alert
    }
    
    /**
     Private func that creates an `UIAlertAction`.
     
     This function sets the title, icon, text color and tint color.
     
     - Returns: Returns an `UIAlertAction`.
     
     - Parameters:
        - button:   Object that contains the values for the button.
        - style:    Define the button's tyle (default, cancel or destructive).
        - handler:  The `UIAlertAction` handler.
     */
    private func createAlertAction(_ button: CDAAlertButton, style: UIAlertAction.Style, handler: ((UIAlertAction) -> Void)?)-> UIAlertAction {
        
        let action = UIAlertAction(title: button.title, style: style, handler: handler)
        
        action.setValue(button.icon, forKey: "image")
        action.setValue(button.tintColor, forKey: "imageTintColor")
        action.setValue(button.textColor, forKey: "titleTextColor")
        
        return action
    }
}
