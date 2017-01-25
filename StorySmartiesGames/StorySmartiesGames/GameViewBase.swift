//
//  GrayView.swift
//  StorySmartiesGames
//
//  Created by GEORGE QUENTIN on 25/01/2017.
//  Copyright © 2017 GEORGE QUENTIN. All rights reserved.
//

import Foundation
import UIKit

public class GameViewBase : UIView {
    public func containerElements(){
        self.backgroundColor = UIColor.gray.withAlphaComponent(0.4)
        self.clipsToBounds = true
        self.layer.cornerRadius = 10
        self.isUserInteractionEnabled = true
    }
}
