//
//  CDAViewController.swift
//  CDAUtilities
//
//  Created by Alexander on 5/05/21.
//

import UIKit

extension UIViewController {
    
    public var className: String {
        return String(describing: type(of: self))
    }
   
    @IBAction public func btnExit(_ sender : UIButton?){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction public func btnTapGestureKeyboard(_ sender : UIButton?){
        self.view.endEditing(true)
    }
    
    public func popToViewController(_ controller: UIViewController.Type) {
        
        guard let controller = self.navigationController?.viewControllers.first(where: { type(of: $0) == controller }) else {
            return
        }
        
        self.navigationController?.popToViewController(controller, animated: true)
    }
    
    public func canPerformSegue(identifier: String) -> Bool {
        
        guard let identifiers = value(forKey: "storyboardSegueTemplates") as? [NSObject] else { return false }
        
        let canPerform = identifiers.contains { (object) -> Bool in
            if let id = object.value(forKey: "_identifier") as? String {
                return id == identifier
            }else{
                return false
            }
        }
        return canPerform
    }
}
