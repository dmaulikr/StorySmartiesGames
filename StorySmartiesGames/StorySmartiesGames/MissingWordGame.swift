//
//  MissingWordGame.swift
//  StorySmartiesGames
//
//  Created by GEORGE QUENTIN on 13/01/2017.
//  Copyright © 2017 GEORGE QUENTIN. All rights reserved.
//

import Foundation
import UIKit

public class MissingWordGame : UIView {
    
    var animator : UIDynamicAnimator? = nil
    var snapBehavior: UISnapBehavior!
    var wordsButtons = [UIButton]()
    var currentSentence = String()
    var mainTextview = UITextView() 
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init(frame: CGRect, words: [String], sentences: [String]) {
        super.init(frame: frame)
        
        animator = UIDynamicAnimator(referenceView: self)
        
        ViewController.titleLabel.text = "Missing Word Game"
        ViewController.descriptionLabel.text = "Drag The Missing Word in The Sentence"
        
        currentSentence = sentences[0]
        
        
        mainTextview = {
            let frame = CGRect(x: 0, y: 100, width: self.frame.width, height: self.frame.height - 100)
            let textView = UITextView(frame: frame)
            textView.font = UIFont.systemFont(ofSize: 20)
            textView.backgroundColor = UIColor.clear
            textView.layer.cornerRadius = 10
            textView.adjustsFontForContentSizeCategory = true
            textView.scrollsToTop = true
            textView.allowsEditingTextAttributes = false
            textView.isSelectable = false
            textView.isEditable = false
            textView.textAlignment = .center
            
            textView.translatesAutoresizingMaskIntoConstraints = false
            return textView
        }()
        self.addSubview(mainTextview)
        updateTextview()
        
        let size : CGFloat = 50.0
        let xPos = self.frame.width / 4
        
        for index in 0..<3 {
            let button = UIButton(frame: CGRect(x: size + xPos * CGFloat(index) , y: 10.0, width: size, height: size))
            button.buttonElements(words.chooseOne(), 10.0, UIColor.randomColor())
            self.insertSubview(button, aboveSubview: mainTextview)
            
            let pan = UIPanGestureRecognizer(target: self, action: #selector(onPan(pan:)))
            button.addGestureRecognizer(pan)
            button.isUserInteractionEnabled  = true
            
            wordsButtons.append(button)
        }
        
        
        
        let linguisticTags = currentSentence.toLinguisticTagRanges()
        zip(linguisticTags.tags, linguisticTags.ranges)
            .forEach {
                print($0.0.pad(by: 20), currentSentence[$0.1])
        }

        
    }
    deinit {
        wordsButtons.removeAll()
        self.removeFromSuperview()
        print("Missing word game", #function)
    }
    
    func onPan(pan: UIPanGestureRecognizer) {
        
        let location = pan.location(in: self)
        guard let button = pan.view as? UIButton else { return }
        
        switch pan.state {
        case .began:
            button.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            print("Began", location) 
        case .changed: 
            //location = pan.location(ofTouch: 0, in: self)
            button.center = location
            
            //print("Changed", location, newLocation)
        case .ended: 
            
            button.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
//            if (self.snapBehavior != nil) {
//                self.animator?.removeBehavior(self.snapBehavior)
//            }
//            let snapPoint = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
//            self.snapBehavior = UISnapBehavior(item: button, snapTo: snapPoint)
//            self.animator?.addBehavior(self.snapBehavior)
//            
            //print("Ended", location) 
        default:
            print(pan)
        }
        
      
    }
    
    public func updateTextview(){
        /*
        mainTextview.text = currentSentence
        
        let wordRanges = currentSentence.toWordRanges()
        for range in wordRanges {
            
            //let highlightedText = mainTextview.text.substringWithRange(with: range) 
            //let rect = mainTextview.rect(for: range)
            
            //let rectView = UIView(frame: rect!)
            //rectView.layer.borderColor = UIColor.randomColor().cgColor
            //rectView.layer.borderWidth = 2.0
            //mainTextview.addSubview(rectView)
        }
        
        */
    }
    
    
}
