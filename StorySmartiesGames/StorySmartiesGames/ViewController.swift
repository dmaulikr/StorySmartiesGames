//
//  ViewController.swift
//  StorySmartiesGames
//
//  Created by GEORGE QUENTIN on 12/01/2017.
//  Copyright © 2017 GEORGE QUENTIN. All rights reserved.
//

import UIKit
import EasyAnimation
import RxSwift
import RandomKit
import Cartography

class ViewController: UIViewController {
    
    public static var container = UIView()
    public static var titleLabel = UILabel()
    public static var descriptionLabel = UILabel()
    public static var pointsLabel = UILabel()
    public static var points = 0
    
    var levels = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        ViewController.titleLabel = UILabel(frame: CGRect.zero)
        ViewController.titleLabel.font = UIFont.boldSystemFont(ofSize: 12.0)
        ViewController.titleLabel.text = ""
        ViewController.titleLabel.adjustLabel()
        ViewController.titleLabel.backgroundColor = UIColor.white.withAlphaComponent(0.4)
        self.view.addSubview(ViewController.titleLabel)
        
        ViewController.descriptionLabel = UILabel(frame: CGRect.zero)
        ViewController.descriptionLabel.font = UIFont.boldSystemFont(ofSize: 18.0)
        ViewController.descriptionLabel.text = ""
        ViewController.descriptionLabel.adjustLabel()
        
        ViewController.descriptionLabel.backgroundColor = UIColor.gray.withAlphaComponent(0.4)
        ViewController.descriptionLabel.layer.cornerRadius = 10
        self.view.addSubview(ViewController.descriptionLabel)
        
        addContainer(levels)
        
        ViewController.pointsLabel = UILabel(frame: CGRect.zero)
        ViewController.pointsLabel.font = UIFont.boldSystemFont(ofSize: 32.0)
        ViewController.pointsLabel.text = ""
        ViewController.pointsLabel.backgroundColor = UIColor.gray.withAlphaComponent(0.4)
        ViewController.pointsLabel.adjustLabel()
        ViewController.pointsLabel.layer.cornerRadius = 10
        self.view.addSubview(ViewController.pointsLabel)
        
        
        constrain(ViewController.titleLabel, self.view) { view, view2 in
            view.width   == view2.width - 40
            view.height  == 20
            view.centerX == view2.centerX
            view.top >= view2.top + 30
        }
        
        constrain(ViewController.descriptionLabel, self.view) { view, view2 in
            view.width   == view2.width - 40
            view.height  == 90
            view.centerX == view2.centerX
            view.top >= view2.top + 50
        }
        
        constrain(ViewController.pointsLabel, self.view) { view, view2 in
            view.width   == view2.width - 40
            view.height  == 90
            view.centerX == view2.centerX
            view.bottom >= view2.bottom - 50
        }
        
        createSwipe()
        
    }
    
    
    func createSwipe(){
        
        let directions: [UISwipeGestureRecognizerDirection] = [.right, .left]//, .up, .down]
        for direction in directions {
            let gesture = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
            gesture.direction = direction
            self.view.addGestureRecognizer(gesture)
        }
        
    }
    
    public func clearContainer(){
        
        for sub in ViewController.container.subviews{
            sub.removeFromSuperview()
            
        }
        ViewController.container.layer.sublayers?.removeAll()
        
        ViewController.container.removeFromSuperview()
        ViewController.points = 0
        ViewController.pointsLabel.text = ""
        ViewController.descriptionLabel.text = ""
    }
    
    public func addContainer(_ level: Int){
        
        clearContainer()
        
        let length = self.view.frame.width - 40
        let containerFrame = CGRect(x: 0, y: 0, width: length, height: length)
        
        //peter rabit book
        let sentences = String.peterRabbit.flatMap{ $0.splitWithFullStop().map{ $0.splitWithComma() } } 
            .flatMap{ $0 }
            .removeFirstEmptySpace()
        let words = sentences.wordsList(minCharacters: 3, maxCharacters: 6)
        let sightWords = String.listOfSightWords
        
        switch level {
        case 0:
            ViewController.container = MissingWordGame(frame: containerFrame, sentences: String.peterRabbit)
        case 1:
            ViewController.container = PairsGame(frame: containerFrame, words: words.take(8), startTime: 2, colored: true)
        case 2:
            ViewController.container = WackAMoleGame(frame: containerFrame, words: words, startTime: 2, minLoop: 30, maxLoop: 50)
        case 3:
            ViewController.container = SightWordRaceGame(frame: containerFrame, words: sightWords, switchDuration: 0.5)
        default:
            break
        }
        
        ViewController.container.containerElements()
        self.view.addSubview(ViewController.container)
        
        constrain(ViewController.container, self.view) { view, view2 in
            view.width  == view2.width - 40
            view.height == view.width
            view.center == view2.center
        }
        
    }
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                levels = levels.iterateForward(current: levels, max: 4)
            case UISwipeGestureRecognizerDirection.left:
                levels = levels.iterateBackward(current: levels, max: 4)
            default:
                break
            }
        }
        addContainer(levels)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //NSLog("Starting gravity")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

