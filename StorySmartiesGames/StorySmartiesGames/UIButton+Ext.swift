//
//  UIButton+Ext.swift
//  StorySmartiesGames
//
//  Created by GEORGE QUENTIN on 13/01/2017.
//  Copyright © 2017 GEORGE QUENTIN. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    
    public func buttonElements(_ title: String, _ color: UIColor, _ image: UIImage?){
        
        self.titleLabel?.font = UIFont.systemFont(ofSize: 30.0)
        self.setTitle(title,for: .normal)
        self.setTitleColor(color.getTextColor(), for: .normal)
        self.setImage(image, for: .normal)
        self.layer.cornerRadius = 10
        self.backgroundColor = color
        self.adjustsImageWhenHighlighted = true
        //self.showsTouchWhenHighlighted = true
        
    }
    
    public func updateColor(color: UIColor, word: String) {
        self.setTitle(word,for: .normal)
        self.backgroundColor = color
        self.setTitleColor(color.getTextColor(), for: .normal)
        
    }
    
}
