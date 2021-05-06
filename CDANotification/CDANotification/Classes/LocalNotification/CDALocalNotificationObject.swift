//
//  CDALocalNotificationObject.swift
//  CDANotification
//
//  Created by Alexander on 6/05/21.
//

import Foundation
import UIKit

public class CDANotificationTriggerObject: NSObject{
    
    public var trigger_timeInterval    : TimeInterval = 0
    public var tigger_repeat           = false
}

public class CDANotificationCanlendarObject: NSObject{
    
    public var calendar_components       : DateComponents!
    public var calendar_repeat           = false
}

public class CDAAttachObject: NSObject{
    
    public var attach_name : String = ""
    public var attach_type : String = ""
    
    public init(name: String, type: String) {
        
        self.attach_name = name
        self.attach_type = type
    }
    
    public func createAttachWithLocalResources() -> UNNotificationAttachment?{
        
        if let path = Bundle.main.path(forResource: self.attach_name, ofType: self.attach_type){
            
            let url = URL(fileURLWithPath: path)
            let attach = try? UNNotificationAttachment(identifier: self.attach_name, url: url, options: nil)
            return attach
        }
        
        print("Ops. Occurred an error to attach \(self.attach_name).\(self.attach_type)")
        return nil
    }
}

public class CDALocalNotificationObject: NSObject {

    public var notification_title          = ""
    public var notification_subtitle       = ""
    public var notification_message        = ""
    public var notification_identifier     = ""
    public var notification_userInfo       = [String: Any]()
    public var notification_timeInterval   : Double  = 0
    public var notification_repeat         : Bool = false
    public var notification_attachObjects  = [CDAAttachObject]()
}
