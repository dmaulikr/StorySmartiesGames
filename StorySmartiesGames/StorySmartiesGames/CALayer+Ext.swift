//
//  CALayer.swift
//  StorySmartiesGames
//
//  Created by GEORGE QUENTIN on 12/01/2017.
//  Copyright © 2017 GEORGE QUENTIN. All rights reserved.
//

import Foundation
import UIKit

extension CALayer {
    
    public func addDashedLine(dotSize: CGFloat, count: CGFloat) {
        
        let  p0 = CGPoint(x: 0, y: self.bounds.height/2)
        let  p1 = CGPoint(x: self.bounds.width, y: self.bounds.height/2)
        
        let  path = UIBezierPath()
        path.move(to:p0)
        path.addLine(to:p1)
        path.stroke()
        
        let stepLength = Float(self.bounds.width/count)
        let dashPattern = [NSNumber(value: 0.001), NSNumber(value: stepLength)]
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = self.bounds
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.lineWidth = dotSize
        shapeLayer.lineJoin = kCALineJoinRound
        shapeLayer.lineCap = kCALineCapRound
        shapeLayer.lineDashPattern = dashPattern
        shapeLayer.lineDashPhase = dotSize
        shapeLayer.path = path.cgPath
        
        self.addSublayer(shapeLayer)
    }
    
    
}
