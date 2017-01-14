//
//  UILabel+Ext.swift
//  StorySmartiesGames
//
//  Created by GEORGE QUENTIN on 14/01/2017.
//  Copyright © 2017 GEORGE QUENTIN. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {

    public func adjustLabel(){
        
        self.numberOfLines = 0
        self.adjustsFontSizeToFitWidth = true
        self.lineBreakMode = NSLineBreakMode.byClipping
        self.minimumScaleFactor = 0.01
        self.textAlignment = .center
        self.clipsToBounds = true
    }
}
