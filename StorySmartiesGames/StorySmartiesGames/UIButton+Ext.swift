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
    
    public func buttonElements(_ title: String, _ fontSize: CGFloat, _ color: UIColor, _ withImage: Bool = false, _ image: UIImage? = UIImage()){
        
        let img = withImage ? image?.scaleImageToSize(newSize: self.frame.size) : UIImage()
        self.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        self.titleLabel?.adjustLabel()
        self.setTitle(title,for: .normal)
        self.setTitleColor(color.getTextColor(), for: .normal)
        self.setImage(img, for: .normal)
        self.imageView?.contentMode = .scaleAspectFit
        self.layer.cornerRadius = 10
        self.backgroundColor = color
        self.clipsToBounds = true
        self.adjustsImageWhenHighlighted = true
        //self.showsTouchWhenHighlighted = true
      
    }
    
    public func updateColor(color: UIColor, word: String) {
        self.setTitle(word,for: .normal)
        self.backgroundColor = color
        self.setTitleColor(color.getTextColor(), for: .normal)
        
    }
    
    public func setImage(image: UIImage?, inFrame frame: CGRect?, forState state: UIControlState){
        self.setImage(image, for: state)
        
        if let frame = frame{
            self.imageEdgeInsets = UIEdgeInsets(
                top: frame.minY - self.frame.minY,
                left: frame.minX - self.frame.minX,
                bottom: self.frame.maxY - frame.maxY,
                right: self.frame.maxX - frame.maxX
            )
        }
        
    }
      
    
}

