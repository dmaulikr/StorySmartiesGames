//
//  UIFont+Ext.swift
//  StorySmartiesView
//
//  Created by Daniel Asher on 08/12/2016.
//  Copyright © 2016 LEXI LABS. All rights reserved.
//

import Foundation
import UIKit
extension UIFont {
    static func getCustomFont(size: CGFloat) -> UIFont {
        // Set textView font to one of Futura Medium or custom font ABeeZee-Regular
        let customFontFileName = "ABeeZee-Regular"
        let customFontName = "ABeeZee-Regular"
        
        if let font = UIFont(name: customFontName, size: size) {
            return font
        } else {
            let fontPath = Bundle(for: self).path(forResource: customFontFileName, ofType: "ttf")
            let fontData = NSData(contentsOfFile: fontPath!)
            let dataProvider = CGDataProvider(data: fontData!)
            let fontRef = CGFont(dataProvider!)
            var errorRef: Unmanaged<CFError>? = nil
            
            if (CTFontManagerRegisterGraphicsFont(fontRef, &errorRef) == false) {
                print("Failed to register font \(customFontName)- register graphics font failed - this font may have already been registered in the main bundle.")
            }
            if let font = UIFont(name: customFontName, size: size) {
                return font
            } else {
                let font = UIFont.systemFont(ofSize: size)
                print("Font \(customFontName) cannot be found")
                return font
            }
        }
    }
}
