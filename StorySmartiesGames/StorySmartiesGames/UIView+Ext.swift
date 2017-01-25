//
//  UIView+Ext.swift
//  StorySmarties
//
//  Created by Daniel Asher on 18/05/2016.
//  Copyright © 2016 LEXI LABS. All rights reserved.
//

import Foundation
import UIKit
import RxSwift


public extension UIView {

    public func animateWithDuration(duration: Double, animations: @escaping (UIView) -> Void) {
        let animations : () -> Void = { animations(self) }
        UIView.animate(withDuration: duration, animations: animations, completion: nil)
    }
    
    public func animateWithDuration(duration: Double, animations: @escaping (UIView) -> Void, completion: ((Bool) -> Void)?) {
        let animations : () -> Void = { animations(self) }
        UIView.animate(withDuration: duration, animations: animations, completion: completion)
    }
    
    public func animateWithDuration(duration: Double, delay: Double, options: UIViewAnimationOptions, animations: @escaping (UIView) -> Void) {
        let animations : () -> Void = { animations(self) }
        UIView.animate(withDuration: duration, delay: delay, options: options, animations: animations, completion: nil)
    }
    
    public func animateWithDuration(duration: Double, delay: Double, options: UIViewAnimationOptions, animations: @escaping (UIView) -> Void, completion: ((Bool) -> Void)?) {
        let animations : () -> Void = { animations(self) }
        UIView.animate(withDuration: duration, delay: delay, options: options, animations: animations, completion: completion)
    }
    
    // Removes all constrains for this view
    func removeConstraints() {
        var topView : UIView? = self
        repeat {
            var list = [NSLayoutConstraint]()
            for c in topView?.constraints ?? [] {
                if c.firstItem as? UIView == self || c.secondItem as? UIView == self {
                    list.append(c)
                }
            }
            topView?.removeConstraints(list)
            topView = topView?.superview
            
        }
        while topView != nil
        
        self.translatesAutoresizingMaskIntoConstraints = true

    }

    
}
