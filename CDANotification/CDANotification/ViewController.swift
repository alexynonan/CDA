//
//  ViewController.swift
//  CDANotification
//
//  Created by Alexander on 5/05/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let info = CDALocalNotificationObject()
        
        info.notification_title = "Alexander"
        info.notification_message = "Alexander prueba notifiaction"
        info.notification_timeInterval = 0.5
        
        let obj = CDANotificationTriggerObject()
//        obj.tigger_repeat = true
//        obj.trigger_timeInterval = 2
        
        CDALocalNotificationManager.verifyAuthorizationInController(self)
        // Do any additional setup after loading the view.
    }


}

