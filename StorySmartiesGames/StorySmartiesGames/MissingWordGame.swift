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
    
    var buttons = [UIButton]()
    var buttonsPositions = [CGPoint]()
    var buttonsColors = [UIColor]()
    
    var currentSentence = String()
    var sentenceIndex = 0
    var sentencesS = [String]()
    
    var mainTextview = UITextView() 
    
    var font = UIFont()
    var fontSize : CGFloat = 20.0
    var bgColor = UIColor()
    var hiddenTextColor = UIColor.clear
    
    var snapToText = CGPoint()
    var wordsToChoose = [String]()
    var textViewRects = [(view: UIButton, text: String)]()
    
    var wasButtonIntersecting = false
    var wasButtonIntersectingIndex = 0
    var scoreCount = 0
    var maxScore = 0
    
    var addColor = false
    var play = false
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init(frame: CGRect, sentences: [String], startTime: TimeInterval, colored: Bool) {
        super.init(frame: frame)
        
        ViewController.titleLabel.text = "Missing Word Game"
        ViewController.descriptionLabel.text = "Drag the words within the sentences"
        
        initialSetup(sentences, colored)
        
        Timer.scheduledTimer (withTimeInterval: startTime, repeats: false) { _ in 
            self.play = true
            self.setUpWords()
            self.setupRectsInTextview()
            self.setupButtons()
        }
        
        
    }
    
    deinit {
        reset()
        self.removeFromSuperview()
        print("Missing word game", #function)
    }
    
    public func initialSetup(_ sentences: [String], _ colored: Bool){
        
        sentencesS = sentences
        currentSentence = sentencesS[sentenceIndex]
        
        font = UIFont.systemFont(ofSize: fontSize)
        bgColor = UIColor.clear
        addColor = colored
        animator = UIDynamicAnimator(referenceView: self)
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        //tap.numberOfTapsRequired = 2
        self.addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true
        
        setupTextview()
    }
    
    public func setupTextview(){
        mainTextview = {
            let frame = CGRect(x: 5, y: 100, width: self.frame.width - 10, height: self.frame.height - 100)
            let textView = UITextView(frame: frame)
            textView.font = font
            textView.backgroundColor = bgColor
            textView.layer.cornerRadius = 10
            textView.adjustsFontForContentSizeCategory = true
            textView.scrollsToTop = true
            textView.allowsEditingTextAttributes = false
            textView.isSelectable = false
            textView.isEditable = false
            textView.textAlignment = .center
            textView.text = currentSentence
            textView.translatesAutoresizingMaskIntoConstraints = false
            textView.clipsToBounds = true
            
            return textView
        }()
        self.addSubview(mainTextview)
    }
    
    public func setUpWords(){
        
        let minCount = 3
        let maxCount = 8
        let potentialWords = currentSentence.getNonDuplicatedWords(minCount, maxCount)
        wordsToChoose = (potentialWords.count > 5) ? potentialWords.take(5) : potentialWords
        buttonsColors = wordsToChoose.flatMap { word -> UIColor in return UIColor.randomColor() }
        
        scoreCount = 0
        maxScore = (wordsToChoose.count + 1)
        
        mainTextview.text = currentSentence
        mainTextview.attributedText = currentSentence.changesWordColor(wordsToChoose, hiddenTextColor)
        mainTextview.font = font
        
        ViewController.points = 0
        ViewController.pointsLabel.text = "You have \(maxScore - ViewController.points) attempts left" 
        ViewController.pointsLabelLayer.frame.size.width = ViewController.pointsLabel.frame.width
    }
    
    
    public func setupRectsInTextview(){
    
        let wordRanges = currentSentence.toWordRanges()
        for range in wordRanges {
            
            let highlightedText = mainTextview.text.substringWithRange(with: range) 
            guard let rect = mainTextview.rect(for: range) else { return }
            
            if (wordsToChoose.contains(highlightedText)){
               
                let char = highlightedText.characters.flatMap{ char -> Character in
                    return Character("_")
                }
                
                var text = highlightedText.replacingOccurrences(of: highlightedText, with: String (char)) 

                text.characters.removeFirst()
                text.characters.removeLast()
                
                let newRect = CGRect(x: rect.minX + 5, y: rect.minY, width: rect.width, height: rect.height)
                let wordView = UIButton(frame: newRect)
                wordView.titleLabel?.font = mainTextview.font
                wordView.backgroundColor = bgColor
                wordView.setTitleColor(UIColor.white, for: UIControlState.normal) 
                wordView.setTitle(text, for: UIControlState.normal)
                wordView.center.y = wordView.center.y + mainTextview.frame.minY + 1
                wordView.layer.cornerRadius = 10
                wordView.clipsToBounds = true
                
                wordView.frame = wordView.frame.increaseRect(10, 0)
                
                if let index = wordsToChoose.index(of: highlightedText) {
                    wordView.layer.borderColor = addColor ? buttonsColors[index].cgColor : UIColor.clear.cgColor
                    wordView.layer.borderWidth = addColor ? 2.0 : 0.0
                }
                
                self.insertSubview(wordView, aboveSubview: mainTextview)
                textViewRects.append((wordView, highlightedText))
                
            }
        }
        
        
    }
    
    public func setupButtons(){
    
        let newFont = mainTextview.font ?? font
        
        let spacing : CGFloat = 5
        var extraHeight : CGFloat = 0
        var previousX : CGFloat = 0
        
        for index in 0..<wordsToChoose.count {
            
            let width = CGFloat(wordsToChoose[index].characters.count) * newFont.xHeight 
            let height =  newFont.lineHeight 
           
            var tempX = spacing + previousX
            if (tempX > mainTextview.frame.width - width ){
                extraHeight = extraHeight + height + spacing
                tempX = 0
            }
            
            let xp = tempX + spacing
            previousX = xp + width
            let yp : CGFloat = spacing + extraHeight
            
            let frame = CGRect(x: xp, y: yp, width: width, height: height)
            //if ( !checkIntersetors(frame) ){
            
                let button = UIButton(frame: frame)
                let color = addColor ? buttonsColors[index] : UIColor.black
                button.buttonElements("\(wordsToChoose[index])", newFont, color)
                self.insertSubview(button, aboveSubview: mainTextview)
                
                let pan = UIPanGestureRecognizer(target: self, action: #selector(onPan(pan:)))
                button.addGestureRecognizer(pan)
                button.isUserInteractionEnabled  = true
                button.layer.zPosition = 1
                button.frame = button.frame.increaseRect(12, 10)
                buttons.append(button)
            //}
            
        }
        
        buttonsPositions = buttons.flatMap{ but -> CGPoint in
            return but.center
        }
        
    }
    
    public func checkIntersetors(_ frame: CGRect) -> Bool {
        if (buttons.count > 0 ){
            var temp = false
            for but in buttons{
                if (frame.intersects(but.frame)) {
                    temp = true
                    break
                }
            }
            return temp
        }else{
            return false
        }
    }
    
    
    func handleTap(_ sender: UITapGestureRecognizer) {
        //nextSentence()
    }
    
    public func nextSentence(){
        sentenceIndex = sentenceIndex.iterateForward(current: sentenceIndex, max: sentencesS.count)
        currentSentence = sentencesS[sentenceIndex]
        reset()
        setUpWords()
        setupRectsInTextview()
        setupButtons()
    }
    public func checkScore (){
        
        if scoreCount >= wordsToChoose.count && scoreCount < maxScore {
            
            ViewController.pointsLabel.text = "Congratutaions"
            Timer.scheduledTimer (withTimeInterval: 2.0, repeats: false) { _ in 
                self.nextSentence()
                self.play = true
            }
        }
        if (ViewController.points >= maxScore){
            play = false
            ViewController.pointsLabel.text = "Game Over" 
        }
    }
    
    func onPan(pan: UIPanGestureRecognizer) {
        
        let location = pan.location(in: self)
        guard let button = pan.view as? UIButton else { return }
        
        switch pan.state {
        case .began:
            if (play == true){
                button.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }
        case .changed: 
            
            if (play == true){
                
                button.center = location
                button.layer.zPosition = 2
                wasButtonIntersecting = false
                wasButtonIntersectingIndex = 0
                snapToText = CGPoint.zero
            
                for (ind,(view:view, text:text) ) in textViewRects.enumerated() {
                    
                    if (button.frame.intersects(view.frame) && button.titleLabel?.text == text){
                        view.backgroundColor = button.backgroundColor//UIColor.randomColor()
                        
                        snapToText = view.center
                        wasButtonIntersecting = true
                        wasButtonIntersectingIndex = ind
                        
                    }else{
                        view.backgroundColor = bgColor
                    }
                }
            }
            //print("Changed", location, button.frame)
        case .ended: 
            if (play == true){
                
                button.layer.zPosition = 1
                button.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                if (self.snapBehavior != nil) {
                    self.animator?.removeBehavior(self.snapBehavior)
                }
                
                guard let index = buttons.index(of: button) else { return }
                let snapPoint  = wasButtonIntersecting ? snapToText : buttonsPositions[index]
                
                if (wasButtonIntersecting){
                    button.backgroundColor = UIColor.clear
                    //button.setTitle("", for: UIControlState.normal) 
                    button.setTitleColor(UIColor.white, for: UIControlState.normal)
                    button.isUserInteractionEnabled = false 
                    button.isEnabled = false
                    button.isSelected = false
                    
                    textViewRects[wasButtonIntersectingIndex].view.setTitle("", for: UIControlState.normal) 
                    textViewRects[wasButtonIntersectingIndex].view.layer.borderColor = UIColor.clear.cgColor
                    textViewRects[wasButtonIntersectingIndex].view.layer.borderWidth = 0.0
                    
                    scoreCount += 1
                }
                
                self.snapBehavior = UISnapBehavior(item: button, snapTo: snapPoint)
                self.animator?.addBehavior(self.snapBehavior)
                
                for (view, _) in textViewRects {
                    view.backgroundColor = bgColor
                }
                
                
                let healthDecrement = ViewController.pointsLabel.frame.width / CGFloat(maxScore)
                ViewController.points += 1
                ViewController.pointsLabel.text = "You have \(maxScore - ViewController.points) attempts left" 
                
                let newWidth = ViewController.pointsLabel.frame.width - (healthDecrement * CGFloat(ViewController.points)) 
                ViewController.pointsLabelLayer.frame.size.width =  newWidth
            }
            checkScore()
            //print("Ended", location) 
        default:
            print(pan)
        }
        
      
    }
    
    
    public func reset(){
        
        for v in self.subviews{
            for b in buttons{
                if v == b {
                    v.removeFromSuperview()
                }
            }
            for (r,_) in textViewRects {
                if v == r {
                    v.removeFromSuperview()
                }
            }
        }
        
        for b in buttons{
            b.removeFromSuperview()
        }
        for (b,_) in textViewRects {
            b.removeFromSuperview()
        }
        buttons.removeAll()
        buttonsColors.removeAll()
        buttonsPositions.removeAll()
        textViewRects.removeAll()
        wordsToChoose.removeAll()
        
        
    }
    
    
}



