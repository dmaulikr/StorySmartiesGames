//
//  FlipCard.swift
//  StorySmartiesGames
//
//  Created by GEORGE QUENTIN on 13/01/2017.
//  Copyright © 2017 GEORGE QUENTIN. All rights reserved.
//

import Foundation
import UIKit

public class SightWordRaceGame: UIView {
    
    public var back = UIButton()//UIImageView!
    public var front = UIButton()//UIImageView!
    var showingBack = true
    
    var wordList = [String]()
    var lifeTime : TimeInterval = 0
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init(frame: CGRect, words: [String], switchDuration: TimeInterval) {
        super.init(frame: frame)
        ViewController.titleLabel.text = "Sight Word Race Game"
        ViewController.descriptionLabel.text = "Say The Sight Word"
        
        wordList = words
        lifeTime = switchDuration
            
        front = UIButton(frame: frame)
        front.buttonElements(wordList.chooseOne(), 35.0, UIColor.black)
        front.addTarget(self, action: #selector(tapped(_:)), for: .touchUpInside)
        
        back = UIButton(frame: frame)
        back.buttonElements(wordList.chooseOne(), 35.0, UIColor.green)
        back.addTarget(self, action: #selector(tapped(_:)), for: .touchUpInside)
        
        self.addSubview(back)
        
    }
    
    
    
    func tapped(_ but: UIButton) {
        
//        let curlTransition : [UIViewAnimationOptions] = 
//            [
//                .transitionCurlUp, 
//                .transitionCurlDown
//            ]
//        
        let leftRightTransition : [UIViewAnimationOptions] = 
            [
                .transitionFlipFromLeft, 
                .transitionFlipFromRight
            ]
//        let topBottomTransition : [UIViewAnimationOptions] = 
//            [
//                .transitionFlipFromTop, 
//                .transitionFlipFromBottom
//            ]
        
        if (showingBack) {
            UIView.transition(from: back, to: front, duration: lifeTime, options: leftRightTransition[0], completion: { completed in 
                self.back.updateColor(color: UIColor.randomColor(), word: self.wordList.chooseOne()) 
            })
            showingBack = false
        } else {
            UIView.transition(from: front, to: back, duration: lifeTime, options: leftRightTransition[0], completion: { completed in
                self.front.updateColor(color: UIColor.randomColor(), word: self.wordList.chooseOne()) 
            })
            showingBack = true
        }
    }

}

