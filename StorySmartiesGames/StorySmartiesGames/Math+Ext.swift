//
//  MathOperations.swift
//  AlienPhonicsSpriteKit
//
//  Created by GEORGE QUENTIN on 26/02/2016.
//  Copyright © 2016 GEORGE QUENTIN. All rights reserved.
//

import Foundation
import UIKit

extension FloatingPoint {
    public var degreesToRadians: Self { return self * .pi / 180 }
    public var radiansToDegrees: Self { return self * 180 / .pi }
}

extension Int {
    
    public static func randomi(_ min: Int, _ max: Int) -> Int {
        guard min < max else {return min}
        return Int(arc4random_uniform(UInt32(1 + max - min))) + min
    }
    public var degreesToRadians: Double { return Double(self) * .pi / 180 }
    public var radiansToDegrees: Double { return Double(self) * 180 / .pi }
    
    
    public func iterateBackward(current: Int, max: Int) -> Int {
        return (current<=0) ? (max - 1) : (current - 1)
    }
    public func iterateForward(current: Int, max: Int) -> Int {
        return ( current >= (max - 1) ) ? 0 : (current + 1)
    }
    
}
extension Double {
    
    public static func random(min: Double, max: Double) -> Double {
        
        let rand = Double(arc4random()) / Double(UINT32_MAX)
        let minimum = min < max ? min : max 
        return  rand * abs(min - max) + minimum
    }
    
    public static func roundToPlaces(value:Double, places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        
        return Darwin.round(value * divisor) / divisor
    }
    
}


public extension Float {
    func string(fractionDigits:Int = 2) -> String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = fractionDigits
        formatter.maximumFractionDigits = fractionDigits
        let n = NSNumber(floatLiteral: Double(self))
        return formatter.string(from: n) ?? "\(self)" 
    }
}


extension CGFloat {
    
    public static func roundToPlaces(value:CGFloat, places:Int) -> CGFloat {
        let divisor = pow(10.0, CGFloat(places))
        return Darwin.round(value * divisor) / divisor
    }

    public static func randf() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
    
    public static func randomf(min: CGFloat, max: CGFloat) -> CGFloat {
        
        let rand = CGFloat(arc4random()) / CGFloat(UINT32_MAX)
        let minimum = min < max ? min : max 
        return  rand * abs(min - max) + minimum
    }
   
    public static func distanceBetween(p1 : CGPoint, p2 : CGPoint) -> CGFloat {
        let dx : CGFloat = p1.x - p2.x
        let dy : CGFloat = p1.y - p2.y
        return sqrt(dx * dx + dy * dy)
    }

    public static func clampf(value: CGFloat, minimum:CGFloat, maximum:CGFloat) -> CGFloat {
        
        if value < minimum { return minimum }
        if value > maximum { return maximum }
        return value
    }
 
    public func getPercentangeValue(_ percent : CGFloat) -> CGFloat{
        return ( (self * percent) / CGFloat(100) )
    }
 
}

extension CGRect {
    
    public func increaseRect( _ widthPercentage: CGFloat, _ heightPercentage: CGFloat) -> CGRect {
        let startWidth = self.width
        let startHeight = self.height
        let adjustmentWidth = (startWidth * (widthPercentage / 100.0 )) / 2.0
        let adjustmentHeight = (startHeight * (heightPercentage / 100.0)) / 2.0
        return self.insetBy(dx: -adjustmentWidth, dy: -adjustmentHeight)
    }
    
}

extension Collection where Iterator.Element == Int {

    public func getPairs(advanceFirstBy: Int, advanceSecondBy: Int) -> [(Int, Int)] {
        
        guard let list = self as? [Int], list.count > 0 else { return [] }
        
        return list.enumerated().flatMap{ (ind, index) -> (Int, Int)? in
            if ind < list.count - 1 {
                return (ind != 0) ? ( index + advanceFirstBy, list[ind + 1] + advanceSecondBy) : ( index, list[ind + 1] + advanceSecondBy )
            }else{
                return nil
            }
        }
    }
    
}
