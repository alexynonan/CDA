//
//  CDALocationManager.swift
//  CDALocation
//
//  Created by Alexander on 6/05/21.
//

import Foundation
import CoreLocation
import CDANotification
import CDAUtilities

public enum CDAMTypeRequestAuthorization {

    case whenInUse
    case always
}


@objc public protocol CDALocationManagerDelegate: NSObjectProtocol {
    
    @objc optional func locationManager(_ manager: CDALocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    @objc optional func locationManager(_ manager: CDALocationManager, didUpdateLocation userLocation: CLLocation?)
}

@objc public protocol CDALocationManagerRegionDelegate: NSObjectProtocol {

    @objc optional func locationManager(_ manager: CDALocationManager, userUpdateLocation userLocation: CLLocation?, createRegions arrayRegions: @escaping (_ array: [CDACircularRegion]) -> Void)
    @objc optional func locationManager(_ manager: CDALocationManager, createNotificationInformationForRegion region: CDACircularRegion, withObject object: Any?) -> CDALocalNotificationObject
    @objc optional func locationManager(_ manager: CDALocationManager, didEnterRegion region: CDACircularRegion)
    @objc optional func locationManager(_ manager: CDALocationManager, didExitRegion region: CDACircularRegion)
}

public class CDACircularRegion: NSObject {
    
    public var identifier       = ""
    public var radius           : CLLocationDistance = 0.0
    public var center           : CLLocationCoordinate2D!
    public var objectReference  : Any?
    public var notifyOnEntry    = true
    public var notifyOnExit     = false
    var region                  : CLCircularRegion!
    
    public init(center: CLLocationCoordinate2D, radius: CLLocationDistance, identifier: String, object: Any?){
        
        self.identifier = identifier
        self.center = center
        self.radius = radius
        self.objectReference = object
        self.region = CLCircularRegion(center: center, radius: radius, identifier: identifier)
        self.region.notifyOnEntry = self.notifyOnEntry
        self.region.notifyOnExit = self.notifyOnExit
    }
}

public class CDALocationManager: NSObject {
    
    public static let shared            = CDALocationManager()
    public var arrayCircularRegions     = [CDACircularRegion]()
    public var userLocation             : CLLocation?
    public var delegate                 : CDALocationManagerDelegate?
    public var delegateRegion           : CDALocationManagerRegionDelegate?
    
    public var distanceFilter : CLLocationDistance = 500{
        didSet{
            self.locationManager.distanceFilter = self.distanceFilter
        }
    }
    
    lazy public var locationManager : CLLocationManager = {
        
        let _locationManager = CLLocationManager()
        
        _locationManager.distanceFilter = self.distanceFilter
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest
        _locationManager.delegate = self
        _locationManager.allowsBackgroundLocationUpdates = self.getBackgroundModeAuthorization()
        
        return _locationManager
    }()
    
    public func updateRegionsToMonitoriong(){
     
        self.delegate?.locationManager?(self, didUpdateLocation: self.userLocation)
        
        self.delegateRegion?.locationManager?(self, userUpdateLocation: self.userLocation, createRegions: { (arrayCircularRegions) in
            
            self.arrayCircularRegions = arrayCircularRegions
            self.createNewRegions()
        })
    }
    
    public func getDistanceToLocation(latitude: CLLocationDegrees, longitude: CLLocationDegrees) -> CLLocationDistance{
     
        let location = CLLocation(latitude: latitude, longitude: longitude)
        return self.userLocation?.distance(from: location) ?? 0
    }
    
    public func startLocation(withRequestAthorization requestAuthorization: CDAMTypeRequestAuthorization){
        
        let authorizationStatus = CLLocationManager.authorizationStatus()
        
        if  authorizationStatus == .authorizedAlways || authorizationStatus == .authorizedWhenInUse {
            self.locationManager.startUpdatingLocation()
        }else if authorizationStatus == .denied{
            self.showAlertToChangeAuthorization()
        }else{
            requestAuthorization == .always ? self.locationManager.requestAlwaysAuthorization() : self.locationManager.requestWhenInUseAuthorization()
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            
            self.locationManager.startUpdatingLocation()
        }else if status == .denied {
            self.showAlertToChangeAuthorization()
        }
        
        self.delegate?.locationManager?(self, didChangeAuthorization: status)
    }
    
    private func showAlertToChangeAuthorization(){
        
        guard let controller = UIApplication.shared.keyWindow?.rootViewController else { return }
        
        let title = "Location Access Disabled"
        let nameApp = Bundle.main.infoDictionary?["CFBundleName"] as? String ?? ""
        let message = "To use your current location in \(nameApp) you would setup this in app configuration section"
        
        let acceptButton = CDAAlertButton(title: "Accept")
        let cancelButton = CDAAlertButton(title: "Cancel")
        
        controller.showAlert(title, message: message, buttons: [acceptButton], cancel: cancelButton, withCompletion: { (_) in
            
            if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
                
        }, andCancelHandler: nil)
    }
    
    private func createNewRegions(){
    
        for region in self.arrayCircularRegions{
            self.locationManager.startMonitoring(for: region.region)
            
            if let information = self.delegateRegion?.locationManager?(self, createNotificationInformationForRegion: region, withObject: region.objectReference){
                CDALocalNotificationManager.createNotificationWithInformation(information, withRegion: region.region, andOwnerDelegate: nil, onSuccess: nil, onError: nil)
            }
        }
    }
    
    private func removeRegions(){
        
        for region in self.locationManager.monitoredRegions{
            
            CDALocalNotificationManager.removeNotificationWithIdentifier(region.identifier)
            self.locationManager.stopMonitoring(for: region)
        }
        
        self.arrayCircularRegions.removeAll()
    }
    
    private func getRegionByIdentifier(_ identifier: String) -> CDACircularRegion?{
        
        let arrayResult = self.arrayCircularRegions.filter({$0.identifier == identifier})
        return arrayResult.first
    }
    
    private func getBackgroundModeAuthorization() -> Bool{
        
        let backgroundModes = Bundle.main.infoDictionary?["UIBackgroundModes"] as? [String]
        return backgroundModes?.contains(where: {$0 == "location"}) ?? false
    }
}


//MARK: - CLLocationManagerDelegate -
extension CDALocationManager: CLLocationManagerDelegate {
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        self.userLocation = locations.first
        self.removeRegions()
        self.updateRegionsToMonitoriong()
    }
    
    public func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        
        if let regionCustom = self.getRegionByIdentifier(region.identifier){
            self.delegateRegion?.locationManager?(self, didEnterRegion: regionCustom)
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        
        if let regionCustom = self.getRegionByIdentifier(region.identifier){
            self.delegateRegion?.locationManager?(self, didExitRegion: regionCustom)
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        
        print("\(region.identifier) now is monitoring")
    }
}
