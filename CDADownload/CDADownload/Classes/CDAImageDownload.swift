//
//  CDAImageDownload.swift
//  CDADownload
//
//  Created by Alexander on 6/05/21.
//

import UIKit

let CDAImageDownloadDirectory = "Caches"

extension UIImageView {
    
    fileprivate func saveImage(_ image: UIImage?, withName name: String, inDirectory directory: String? = nil) -> Bool {
        
        guard let image         = image else { return false }
        guard let documentsPath = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first else { return false }
        let cachePath           = documentsPath + "/\(directory ?? CDAImageDownloadDirectory)"
        let filePath            = cachePath + "/\(name)"
        guard let data          = name.hasSuffix("jpg") ? image.jpegData(compressionQuality: 1) : image.pngData() else { return false }
        
        do {
            let url = URL(fileURLWithPath: filePath)
            try data.write(to: url, options: .atomic)
            print("CDAMImageDownloaded / Se guardó la imagen \(name)")
            return true
        }catch {
            return false
        }
    }
    
    fileprivate func getImageWithName(_ name: String, inDirectory directory: String? = nil) -> UIImage? {
        
        guard let documentsPath = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first else { return nil }
        let cachePath           = documentsPath + "/\(directory ?? CDAImageDownloadDirectory)"
        let filePath            = cachePath + "/\(name)"
        
        return UIImage(contentsOfFile: filePath)
    }
    
    fileprivate func downloadImageInUrl(_ url: String, withName name: String) -> UIImage? {
        
        guard let url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return nil }
        
        if let urlDownload = URL(string: url) {
            
            do {
                
                let imageData = try Data(contentsOf: urlDownload)
                let imageDownloaded = UIImage(data: imageData)
                
                if self.saveImage(imageDownloaded, withName: name) {
                    return self.getImageWithName(name)
                }else{
                    print("Error al descargar: \(url)")
                    return nil
                }
                
            }catch {
                print("Error al descargar: \(url)")
                return nil
            }
            
        }else{
            print("Error al descargar: \(url)")
            return nil
        }
    }
    
    fileprivate func doDownloadWithURL(_ url: String, name: String, withPlaceHolder placeHolder: UIImage?, success: @escaping(_ urlFile: String, _ image: UIImage?) -> Void) {
        
        DispatchQueue.global(qos: .default).async {
        
            guard let imageSaved = self.getImageWithName(name, inDirectory: nil) else {
                
                let imageDownloaded = self.downloadImageInUrl(url, withName: name) ?? placeHolder
                DispatchQueue.main.async {
                    success(url, imageDownloaded)
                }
                return
            }
            
            DispatchQueue.main.async {
                success(url, imageSaved)
            }
        }
    }
    
    public func downloadImageInUrl(_ url: String, withPlaceHolder placeHolder: UIImage?, success: @escaping(_ urlFile: String, _ image: UIImage?) -> Void) {
        
        self.image = placeHolder
        var name = url.replacingOccurrences(of: "/", with: "")
    
        if name.hasSuffix("jpg") {
            name = name.replacingOccurrences(of: ".jpg", with: "@3x.jpg")
        }else if name.hasSuffix("png") {
            name = name.replacingOccurrences(of: ".jpg", with: "@3x.png")
        }else{
            name = name + "@3x.png"
        }
        
        self.doDownloadWithURL(url, name: name, withPlaceHolder: placeHolder, success: success)
    }
}
