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

    var cardView: UIView!
    var back: UIImageView!
    var front: UIImageView!
    var showingBack = true
    
    public static var container = UIView()
    public static var descriptionLabel = UILabel()
    public static var pointsLabel = UILabel()
    public static var points = 0
    
    let gameTitle = ["Wack A Moll" , "Find 8 Pairs"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let length = self.view.frame.width - 40
        
        self.view.backgroundColor = UIColor.white
        //peter rabit book
        let sentences = String.peterRabbit.flatMap{ $0.splitWithFullStop().map{ $0.splitWithComma() } } 
            .flatMap{ $0 }
            .removeFirstEmptySpace()
        let words = sentences.wordsList(minCharacters: 3, maxCharacters: 6).take(8)
        
        ViewController.descriptionLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0.0, height: 0.0))
        ViewController.descriptionLabel.font = UIFont.boldSystemFont(ofSize: 18.0)
        ViewController.descriptionLabel.numberOfLines = 0
        ViewController.descriptionLabel.text = gameTitle[0]
        ViewController.descriptionLabel.textAlignment = .center
        ViewController.descriptionLabel.backgroundColor = UIColor.yellow
        self.view.addSubview(ViewController.descriptionLabel)
        
        ViewController.container = WackAMollGame(frame: CGRect(x: 0, y: 0, width: length, height: length), words: words, minLoop: 30, maxLoop: 50)
            //PairsGame(frame: CGRect(x: 0, y: 0, width: length, height: length), words: words, startTime: 2)
        ViewController.container.backgroundColor = UIColor.gray.withAlphaComponent(0.4)
        ViewController.container.clipsToBounds = false
        ViewController.container.layer.cornerRadius = 10
        self.view.addSubview(ViewController.container)
        
        ViewController.pointsLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0.0, height: 0.0))
        ViewController.pointsLabel.font = UIFont.boldSystemFont(ofSize: 32.0)
        ViewController.pointsLabel.text = "Found \(ViewController.points) Pairs"
        ViewController.pointsLabel.textAlignment = .center
        ViewController.pointsLabel.backgroundColor = UIColor.cyan
        self.view.addSubview(ViewController.pointsLabel)
        
        
        constrain(ViewController.descriptionLabel, self.view) { view, view2 in
            view.width   == view2.width - 40
            view.height  == 100
            view.centerX == view2.centerX
            view.top >= view2.top + 40
        }
        
        constrain(ViewController.container, self.view) { view, view2 in
            view.width  == view2.width - 40
            view.height == view.width
            view.center == view2.center
        }
        constrain(ViewController.pointsLabel, self.view) { view, view2 in
            view.width   == view2.width - 40
            view.height  == 100
            view.centerX == view2.centerX
            view.bottom >= view2.bottom - 20
        }
        
    }
    
   
    
    /*
    func flipCard(){
        front = UIImageView(image: UIImage(named: "front.png"))
        back = UIImageView(image: UIImage(named: "back.png"))
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(ViewController.tapped))
        singleTap.numberOfTapsRequired = 1
        
        let rect = CGRect(x: 50, y: 50, width: (back.image?.size.width)!, height: (back.image?.size.height)!)
        cardView = UIView(frame: rect)
        cardView.addGestureRecognizer(singleTap)
        cardView.isUserInteractionEnabled = true
        cardView.addSubview(back)
        
        view.addSubview(cardView)
    }
    
    func tapped() {
        
        let curlTransition : [UIViewAnimationOptions] = 
            [
            .transitionCurlUp, 
            .transitionCurlDown
            ]
        
        let leftRightTransition : [UIViewAnimationOptions] = 
            [
                .transitionFlipFromLeft, 
                .transitionFlipFromRight
            ]
        let topBottomTransition : [UIViewAnimationOptions] = 
            [
                .transitionFlipFromTop, 
                .transitionFlipFromBottom
            ]
        
        if (showingBack) {
            UIView.transition(from: back, to: front, duration: 1, options: leftRightTransition[0], completion: { completed in 
            })
            showingBack = false
        } else {
            UIView.transition(from: front, to: back, duration: 1, options: leftRightTransition[1], completion: nil)
            showingBack = true
        }
        
    }
 
    */
}

