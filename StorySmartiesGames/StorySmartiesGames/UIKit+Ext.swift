//
//  UIKit+Ext.swift
//  AlienPhonicsSpriteKit
//
//  Created by GEORGE QUENTIN on 26/02/2016.
//  Copyright © 2016 GEORGE QUENTIN. All rights reserved.
//

import Foundation
import UIKit

public struct ColorComponents {
    var r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat
}


extension UIColor {

    public static func randomColor() -> UIColor {
        return UIColor(red:   .randf(),
                       green: .randf(),
                       blue:  .randf(),
                       alpha: 1.0)
    }
    
    public func getComponents() -> ColorComponents {
        
        if (self.cgColor.numberOfComponents == 2) {
            let cc = self.cgColor.components 
            return ColorComponents(r:cc![0], g:cc![0], b:cc![0], a:cc![1])
        }
        else {
            let cc = self.cgColor.components 
            return ColorComponents(r:cc![0], g:cc![1], b:cc![2], a:cc![3])
        }
    }
    
    
    public func getTextColor () -> UIColor {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        _ = self.getRed(&r, green: &g, blue: &b, alpha: &a)
        return (r<0.8 && g<0.8 && b<0.8) ? UIColor.white : UIColor.black
    }
    
    
}

