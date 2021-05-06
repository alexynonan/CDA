//
//  CDALocalNotificationManager.swift
//  CDANotification
//
//  Created by Alexander on 6/05/21.
//
import UIKit
import Foundation
import CoreLocation
import UserNotifications
import CDAUtilities

public typealias CDANotificationSuccess  = () -> Void
public typealias CDANotificationError    = () -> Void

public class CDALocalNotificationManager: NSObject {

    public class func verifyAuthorizationInController(_ controller: UIViewController){
            
        UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .alert]) { (granted, error) in
            
            if !granted {
                
                let title = "Local Notification Access Disabled"
                let nameApp = Bundle.main.infoDictionary?["CFBundleName"] as? String ?? ""
                let message = "To receive a local notification in \(nameApp) you need authorize the app in configuration section"
                
                let acceptButton = CDAAlertButton(title: "Accept")
                let cancelButton = CDAAlertButton(title: "Cancel")
            
                DispatchQueue.main.async {
                    
                    controller.showAlert(title, message: message, buttons: [acceptButton], cancel: cancelButton) { _ in
                        
                        guard let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) else { return }
    
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        
                    } andCancelHandler: {
                        
                    }
                }
                
            }
        }
    }
    
    private class func createContentWithInformation(_ information: CDALocalNotificationObject) -> UNMutableNotificationContent{
        
        let content         = UNMutableNotificationContent()
        content.title       = information.notification_title
        content.subtitle    = information.notification_subtitle
        content.body        = information.notification_message
        content.userInfo    = information.notification_userInfo
        
        var arrayAttach = [UNNotificationAttachment]()
        for attach in information.notification_attachObjects{
            if let obj = attach.createAttachWithLocalResources(){
                arrayAttach.append(obj)
            }
        }
        
        content.attachments = arrayAttach
        
        return content
    }
    
    public class func createNotificationWithInformation(_ information: CDALocalNotificationObject, withTrigger trigger:CDANotificationTriggerObject, andOwnerDelegate delegate: UNUserNotificationCenterDelegate?, onSuccess success :CDANotificationSuccess?, onError failure: CDANotificationError?) {
        
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.delegate = delegate
        
        let content = self.createContentWithInformation(information)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: trigger.trigger_timeInterval, repeats: trigger.tigger_repeat)
        let request = UNNotificationRequest.init(identifier: information.notification_identifier, content: content, trigger: trigger)
        
        notificationCenter.add(request) { (error) in
            
            error == nil ? success?() : failure?()
        }
    }
    
    public class func createNotificationWithInformation(_ information: CDALocalNotificationObject, withCalendar calendar:CDANotificationCanlendarObject, andOwnerDelegate delegate: UNUserNotificationCenterDelegate?, onSuccess success :CDANotificationSuccess?, onError failure: CDANotificationError?) {
        
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.delegate = delegate
        
        let content = self.createContentWithInformation(information)
        let trigger = UNCalendarNotificationTrigger(dateMatching: calendar.calendar_components, repeats: calendar.calendar_repeat)
        let request = UNNotificationRequest.init(identifier: information.notification_identifier, content: content, trigger: trigger)
        
        notificationCenter.add(request) { (error) in
            
            error == nil ? success?() : failure?()
        }
    }
    
    public class func createNotificationWithInformation(_ information: CDALocalNotificationObject, withRegion region: CLRegion, andOwnerDelegate delegate: UNUserNotificationCenterDelegate?, onSuccess success : CDANotificationSuccess?, onError failure:CDANotificationError?) {
        
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.delegate = delegate
        
        let content = self.createContentWithInformation(information)
        let trigger = UNLocationNotificationTrigger(region: region, repeats: true)
        let request = UNNotificationRequest.init(identifier: information.notification_identifier, content: content, trigger: trigger)
        
        notificationCenter.add(request) { (error) in
            
            error == nil ? success?() : failure?()
        }
    }
    
    public class func removeNotifications(){
        
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    public class func removeNotificationWithIdentifier(_ identifier: String){
        
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }
    
    public class func removeNotificationsWithIdentifiers(_ identifiers: [String]){
        
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
    }
}
