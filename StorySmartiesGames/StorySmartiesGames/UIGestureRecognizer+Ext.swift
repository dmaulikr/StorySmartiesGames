//
//  UIGestureRecognizer+Ext.swift
//  StorySmarties
//
//  Created by Daniel Asher on 03/06/2016.
//  Copyright © 2016 LEXI LABS. All rights reserved.
//

import Foundation
import UIKit

extension UIGestureRecognizer {
    public var touchInView : (point: CGPoint, velocity: CGPoint?, translation: CGPoint?) {
        let point = self.location(in: self.view)
        let pan = self as? UIPanGestureRecognizer
        let velocity = pan?.velocity(in: self.view)
        let translation = pan?.translation(in: self.view)
        return (point, velocity, translation)
    }
    public var touchInSuperview : (point: CGPoint, velocity: CGPoint?, translation: CGPoint?)? {
        guard 
        let superView = self.view?.superview 
            else { return nil }
        let point = self.location(in: superView)
        let pan = self as? UIPanGestureRecognizer
        let velocity = pan?.velocity(in: superView)
        let translation = pan?.translation(in: superView)
        return (point, velocity, translation)
    }
}


extension UIGestureRecognizerState : CustomStringConvertible {
    
    public var description : String {
        switch self {
        case .possible : return "Possible"// the recognizer has not yet recognized its gesture, but may be evaluating touch events. this is the default state
            
        case .began: return "Began"// the recognizer has received touches recognized as the gesture. the action method will be called at the next turn of the run loop
        case .changed: return "Changed" // the recognizer has received touches recognized as a change to the gesture. the action method will be called at the next turn of the run loop
        case .ended: return "Ended"// the recognizer has received touches recognized as the end of the gesture. the action method will be called at the next turn of the run loop and the recognizer will be reset to UIGestureRecognizerStatePossible
        case .cancelled: return "Cancelled"// the recognizer has received touches resulting in the cancellation of the gesture. the action method will be called at the next turn of the run loop. the recognizer will be reset to UIGestureRecognizerStatePossible
            
        case .failed: return "Failed"// the recognizer has received a touch sequence that can not be recognized as the 
        }
    } 
}
