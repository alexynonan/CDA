//
//  CDAUIBorderTabBar.swift
//  CDAUI
//
//  Created by Alexander on 8/05/21.
//

import UIKit

@IBDesignable class CustomizedTabBar: UITabBar {

    var radius: CGFloat = 30
    
    private lazy var shapeLayer: CALayer = {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = createPath()
        shapeLayer.strokeColor = UIColor.lightGray.cgColor
        shapeLayer.fillColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 1.0
        return shapeLayer
    }()

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.layer.insertSublayer(self.shapeLayer, at: 0)
    }

    func createPath() -> CGPath {

        let height: CGFloat = 30.0
        let path = UIBezierPath()
        let centerWidth = self.frame.width / 2

        path.move(to: .zero)
        path.addLine(to: CGPoint(x: (centerWidth - height * 2), y: 0))
        // first curve down
        path.addCurve(to: CGPoint(x: centerWidth, y: height),
                      controlPoint1: CGPoint(x: (centerWidth - 30), y: 0), controlPoint2: CGPoint(x: centerWidth - self.radius, y: height))
        // second curve up
        path.addCurve(to: CGPoint(x: (centerWidth + height * 2), y: 0),
                      controlPoint1: CGPoint(x: centerWidth + self.radius, y: height), controlPoint2: CGPoint(x: (centerWidth + 30), y: 0))

        path.addLine(to: CGPoint(x: self.frame.width, y: 0))
        path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height))
        path.addLine(to: CGPoint(x: 0, y: self.frame.height))
        path.close()

        return path.cgPath
    }

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let buttonRadius: CGFloat = self.radius
        return abs(self.center.x - point.x) > buttonRadius || abs(point.y) > buttonRadius
    }
}
