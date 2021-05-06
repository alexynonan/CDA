//
//  CDAColor.swift
//  CDAUtilities
//
//  Created by Alexander on 5/05/21.
//

import Foundation

import UIKit

extension UIColor {
    
    private class func intFromHexString(_ hexString: String) -> UInt64 {
        
        var hexInt : UInt64 = 0
        
        let scanner = Scanner(string: hexString)
        scanner.charactersToBeSkipped = CharacterSet.init(charactersIn: "#")
        scanner.scanHexInt64(&hexInt)
        
        return hexInt
    }
    
    public class func colorFromHexString(_ hexString: String, withAlpha alpha: CGFloat) -> UIColor {
        
        let hexint = self.intFromHexString(hexString)
        
        let red = CGFloat((hexint & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hexint & 0xFF00) >> 8) / 255.0
        let blue = CGFloat(hexint & 0xFF) / 255.0
        
        let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        return color
    }
    
    public var hexadecimalValue: String {
        
        var r : CGFloat = 0
        var g : CGFloat = 0
        var b : CGFloat = 0
        var a : CGFloat = 0
        
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb : Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        
        return String(format: "%06x", rgb)
    }
}
