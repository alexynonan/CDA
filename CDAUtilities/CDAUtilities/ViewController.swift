//
//  ViewController.swift
//  CDAUtilities
//
//  Created by Alexander on 5/05/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var imageCDA : UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageCDA.addStyle(circle: true, radius: 5,border: 5, color: UIColor.red.cgColor)
        self.validation()
        // Do any additional setup after loading the view.
    }


    private func validation(){
       
        let email = "alexanderynonan@gmail.com"
        
        print("Is email :\(email.hasEmailFormat)")
       
        print(email.toSecureEmail(charactersToShow: 3))
        
        print(self.className)
    }
    
    @IBAction private func btnShow(_ sender : UIButton?){
        
//        self.showAlertGeneral(title: "", message: "", cancel: ""){
//
//        }

//        let button = CDAAlertButton(title: "Cancelar", icon: UIImage(named: "ic_btn_prueba"),tintColor: .link,textColor: .link)
//
//        self.showAlert("Gracias", message: "PRUEBA", cancel: button, andCancelHandler: {
//
//        })
        
//        self.showAlert("Prueba", message: "Realizando pruebas", buttons: [button,button], cancel: button) { position in
//
//        } andCancelHandler: {
//
//        }

//        self.showSystemActionSheet("Prueba", message: "ERROR", cancel: button)
        
    }
}

