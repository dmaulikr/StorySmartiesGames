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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.view.backgroundColor = UIColor.randomColor()
        front = UIImageView(image: UIImage(named: "front.png"))
        back = UIImageView(image: UIImage(named: "back.png"))
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(ViewController.tapped))
        singleTap.numberOfTapsRequired = 1
        
        let rect = CGRect(x: 20, y: 20, width: (back.image?.size.width)!, height: (back.image?.size.height)!)
        cardView = UIView(frame: rect)
        cardView.addGestureRecognizer(singleTap)
        cardView.isUserInteractionEnabled = true
        cardView.addSubview(back)
        
        view.addSubview(cardView)
    }
    
    func tapped() {
        
        if (showingBack) {
            UIView.transition(from: back, to: front, duration: 1, options: UIViewAnimationOptions.transitionFlipFromRight, completion: nil)
            showingBack = false
        } else {
            UIView.transition(from: front, to: back, duration: 1, options: UIViewAnimationOptions.transitionFlipFromLeft, completion: nil)
            showingBack = true
        }
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

