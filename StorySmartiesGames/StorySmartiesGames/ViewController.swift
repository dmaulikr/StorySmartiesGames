//
//  ViewController.swift
//  StorySmartiesGames
//
//  Created by GEORGE QUENTIN on 12/01/2017.
//  Copyright © 2017 GEORGE QUENTIN. All rights reserved.
//

import AVFoundation
import UIKit
import EasyAnimation
import RxSwift
import RandomKit
import Cartography

class ViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    public static var container = UIView()
    public static var titleLabel = UILabel()
    public static var descriptionLabel = UILabel()
    public static var pointsLabel = UILabel()
    public static var pointsLabelLayer = CALayer()
    public static var points = 0
    let speechSynth = AVSpeechSynthesizer()
    let speechFinished = PublishSubject<Void>()
    var levels = 0
    
    func say(text: String) -> Observable<Void> {
        let utt = AVSpeechUtterance(string: text)
        speechSynth.speak(utt)
        return speechFinished.asObservable()
    }
    
    func say2(text: String) -> Observable<Void> {
        let utt = AVSpeechUtterance(string: text)
        return Observable.just(utt)
            .do { self.speechSynth.speak(utt) }
            .ignoreElements()
            .map { _ in () }
            .concat(speechFinished.asObservable())
    }

    func say3(text: String) -> Observable<Void> {
        return Observable.create { observer in 
            let utt = AVSpeechUtterance(string: text)
            self.speechSynth.speak(utt)
            return self.speechFinished.bindTo(observer)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        speechSynth.delegate = self
        
//        say3(text: "hi george")
//        .subscribe(onNext: {
//            print("speech finished")
//        })
//        .addDisposableTo(disposeBag)
        
        ViewController.titleLabel = UILabel(frame: CGRect.zero)
        ViewController.titleLabel.font = UIFont.boldSystemFont(ofSize: 12.0)
        //ViewController.titleLabel.text = ""
        ViewController.titleLabel.adjustLabel()
        ViewController.titleLabel.backgroundColor = UIColor.white.withAlphaComponent(0.4)
        self.view.addSubview(ViewController.titleLabel)
        
        ViewController.descriptionLabel = UILabel(frame: CGRect.zero)
        ViewController.descriptionLabel.font = UIFont.boldSystemFont(ofSize: 18.0)
        //ViewController.descriptionLabel.text = ""
        ViewController.descriptionLabel.adjustLabel()
        ViewController.descriptionLabel.backgroundColor = UIColor.gray.withAlphaComponent(0.4)
        ViewController.descriptionLabel.layer.cornerRadius = 10
        self.view.addSubview(ViewController.descriptionLabel)
        
        addContainer(levels)
        
        ViewController.pointsLabel = UILabel(frame: CGRect.zero)
        ViewController.pointsLabel.font = UIFont.boldSystemFont(ofSize: 28.0)
        //ViewController.pointsLabel.text = ""
        ViewController.pointsLabel.backgroundColor = UIColor.gray.withAlphaComponent(0.4)
        ViewController.pointsLabel.adjustLabel()
        ViewController.pointsLabel.layer.cornerRadius = 10
        self.view.addSubview(ViewController.pointsLabel)
        
        ViewController.pointsLabelLayer.frame = CGRect(x: 0, y: 0, width: self.view.frame.width - 40, height: 90) 
        ViewController.pointsLabelLayer.backgroundColor = UIColor.green.withAlphaComponent(0.3).cgColor
        ViewController.pointsLabelLayer.cornerRadius = 10
        ViewController.pointsLabel.layer.addSublayer(ViewController.pointsLabelLayer)
        
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
        ViewController.pointsLabelLayer.frame.size.width = ViewController.pointsLabel.frame.width
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
            ViewController.container = MissingWordGame(frame: containerFrame, sentences: String.peterRabbit, startTime: 4, colored: false, color: UIColor.cyan)
        case 1:
            ViewController.container = PairsGame(frame: containerFrame, words: words.take(8), startTime: 4, colored: true)
        case 2:
            ViewController.container = WackAMoleGame(frame: containerFrame, words: words, startTime: 4, minLoop: 30, maxLoop: 50)
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

extension ViewController : AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        speechFinished.onNext()
    }
}

