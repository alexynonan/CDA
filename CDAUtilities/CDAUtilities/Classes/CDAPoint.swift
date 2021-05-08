//
//  CSPoint.swift
//  CDAUtilities
//
//  Created by Alexander on 5/05/21.
//

import UIKit

extension CGPoint {
    
    public var unitValue: CGPoint {
        
        var newPoint: CGPoint = .zero
        
        newPoint.x = (self.x > 1) ? 1 : (self.x < -1) ? -1 : self.x
        newPoint.y = (self.y > 1) ? 1 : (self.y < -1) ? -1 : self.y
        
        return newPoint
    }
    
    public var gradientPointPosition: CGPoint? {
        
        if self.x > 1 || self.x < -1 || self.y > 1 || self.y < -1 { return nil }
        return CGPoint(x: (self.x + 1)/2, y: (self.y + 1)/2)
    }
}
