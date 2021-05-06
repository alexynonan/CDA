//
//  CDAKeyChain.swift
//  CDAKeyChain
//
//  Created by Alexander on 5/05/21.
//

import UIKit

public class CDAKeyChain: NSObject {

    public static var shared = CDAKeyChain()
    
    public var keychain_deloperMode = true{
        didSet{
            if !self.deviceIsAuthorize() {exit(-1)}
        }
    }
    
    @discardableResult public func dataFromKeychainWithAccount(_ account : String, withService service : String) -> Data? {
        
        if self.deviceIsAuthorize() {
            let data = self.keychainDataWithAccount(account, withService: service)
            return data
        }else{
            exit(-1)
        }
    }
    
    @discardableResult public func saveDataInKeychain(_ data : Data, withAccount account : String, withService service : String) -> Bool {
        
        if self.deviceIsAuthorize() {
            let saved = self.saveInKeychain(data, withAccount: account, withService: service)
            return saved
        }else{
            exit(-1)
        }
    }
    
    @discardableResult public func updateDataInKeychain(_ data : Data, withAccount account : String, withService service : String) -> Bool {
        
        if self.deviceIsAuthorize() {
            let updated = self.updateKeychainDataWithAccount(data, account: account, withService: service)
            return updated
        }else{
            exit(-1)
        }
    }
    
    @discardableResult public func deleteDataInKeychain(_ data : Data, withAccount account : String, withService service : String) -> Bool {
        
        if self.deviceIsAuthorize() {
            let deleted = self.deleteKeychainDataWithAccount(account, withService: service)
            return deleted
        }else{
            exit(-1)
        }
    }
    
    public func deleteKeychain(){
        
        let arrayElementsSecurity = [kSecClassGenericPassword,
                                     kSecClassInternetPassword,
                                     kSecClassCertificate,
                                     kSecClassKey,
                                     kSecClassIdentity]
        
        for elementSecurity in arrayElementsSecurity{
            
            let query = [kSecClass as String : elementSecurity]
            SecItemDelete(query as CFDictionary)
        }
    }

    @discardableResult public func deviceIsAuthorize() -> Bool {
        
        #if DEBUG
            return self.keychain_deloperMode
        #else
            if self.keychain_deloperMode{
                return true
            }
            
            if FileManager.default.fileExists(atPath: "/Applications/Cydia.app") || FileManager.default.fileExists(atPath: "/Library/MobileSubstrate/MobileSubstrate.dylib") || FileManager.default.fileExists(atPath: "/bin/bash") || FileManager.default.fileExists(atPath: "/usr/sbin/sshd") || FileManager.default.fileExists(atPath: "/etc/apt") {
                
                return false
                
            }else{
                
                let texto = "1234567890"
                
                do{
                    try texto.write(toFile: "/private/cache.txt", atomically: true, encoding: String.Encoding.utf8)
                    return false
                    
                }catch{
                    
                    return !UIApplication.shared.canOpenURL(URL(string: "cydia://package/com.example.package")!)
                }
            }
        #endif
    }
    
    
    //MARK: - Privado
    
    private func keychainDataWithAccount(_ account : String, withService service : String) -> Data? {
        
        let query : [String : Any] = [kSecClass as String                   : kSecClassGenericPassword as String,
                                      kSecAttrAccount as String             : account,
                                      kSecAttrService as String             : service,
                                      kSecMatchCaseInsensitive as String    : kCFBooleanTrue!,
                                      kSecReturnData as String              : kCFBooleanTrue!]
        
        var result : AnyObject?
        
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        if let result = result as? Data, status == noErr{
            return result
        }
        
        return nil
    }
    
    private func saveInKeychain(_ data : Data, withAccount account : String, withService service : String) -> Bool {
        
        let keychainData = data as CFData
        
        let query : [String : Any] = [kSecClass as String            : kSecClassGenericPassword as String,
                                      kSecAttrAccount as String      : account,
                                      kSecAttrService as String      : service,
                                      kSecValueData as String        : keychainData as Data,
                                      kSecAttrAccessible as String   : kSecAttrAccessibleWhenUnlocked as String]
        
        var keychainError = noErr
        keychainError = SecItemAdd(query as CFDictionary, nil)
        
        return keychainError == noErr
    }
    
    private func updateKeychainDataWithAccount(_ data : Data, account : String, withService service : String) -> Bool {
        
        let query : [String:Any] = [kSecClass as String         : kSecClassGenericPassword as String,
                                    kSecAttrAccount as String   : account,
                                    kSecAttrService as String   : service]
        
        let newAttributes : [String: Any] = [kSecAttrAccount as String  : account,
                                             kSecAttrService as String  : service,
                                             kSecValueData as String    : data]
        
        
        let status : OSStatus = SecItemUpdate(query as CFDictionary, newAttributes as CFDictionary)
        
        return status == noErr
    }
    
    private func deleteKeychainDataWithAccount(_ account : String, withService service : String) -> Bool {
        
        let query : [String:Any] = [kSecClass as String                   : kSecClassGenericPassword as String,
                                    kSecAttrAccount as String             : account,
                                    kSecAttrService as String             : service]
        
        let status: OSStatus = SecItemDelete(query as CFDictionary)
        
        return status == noErr
    }
    
}
