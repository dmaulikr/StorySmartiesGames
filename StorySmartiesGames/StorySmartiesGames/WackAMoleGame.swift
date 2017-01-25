//
//  WackAMoll.swift
//  StorySmartiesGames
//
//  Created by GEORGE QUENTIN on 13/01/2017.
//  Copyright © 2017 GEORGE QUENTIN. All rights reserved.
//

import Foundation
import UIKit


public class WackAMoleGame : GameViewBase {
    
    public var buttons = [UIButton]() 
    public var gridColor = UIColor.red
    public var mainColor = UIColor.green
    public var currentCards = [UIButton]()
    public var previousCards = [UIButton]()
    
    public var cardsOpened = [UIButton]()
    public var cardsOpenedLifeTime = [Int]()
    public var cardsClosed = [UIButton]()
    
    public var wordToHit = String()
    private var wordList = [String]()
    private var changeTitlelabel = true
    private var play = false
    
    var gameLoop : GameLoop?
    var maxCounter = 0
    var counter = 0 
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init(frame: CGRect, words: [String], startTime: TimeInterval, minLoop:Int = 5, maxLoop: Int = 15, spacing: CGFloat = 1, insetsBy: CGFloat = 5) {
        super.init(frame: frame)
        
        ViewController.titleLabel.text = "Wack A Mole Game"
        ViewController.descriptionLabel.text = "Tap the following word"
        
        if (minLoop >= maxLoop) {
            print("Min Loop must be greater than Max Loop")
            return;
        }
        wordList = words
        let size = 4
        
        // border, here 8 points on each side
        let insets = UIEdgeInsets(top: insetsBy, left: insetsBy, bottom: insetsBy, right: insetsBy)
        
        // available size is the total of the widths and heights of your cell views:
        // bounds.width/bounds.height minus edge insets minus spacing between cells
        let availableSize = CGSize(
            width: frame.width - insets.left - insets.right - CGFloat(size - 1) * spacing,
            height: frame.height - insets.top - insets.bottom - CGFloat(size - 1) * spacing)
        
        // maximum width and height that will fit
        let maxChildWidth = floor(availableSize.width / CGFloat(size))
        let maxChildHeight = floor(availableSize.height / CGFloat(size))
        
        // childSize should be square
        let childSize = CGSize(
            width: min(maxChildWidth, maxChildHeight),
            height: min(maxChildWidth, maxChildHeight))
        
        // total area occupied by the cell views, including spacing inbetween
        let totalChildArea = CGSize(
            width: childSize.width * CGFloat(size) + spacing * CGFloat(size - 1),
            height: childSize.height * CGFloat(size) + spacing * CGFloat(size - 1))
        
        // center everything in GridView
        let topLeftCorner = CGPoint(
            x: floor((frame.width - totalChildArea.width) / 2),
            y: floor((frame.height - totalChildArea.height) / 2))
        
        
        for row in 0..<size {
            for col in 0..<size {
                
                let button = UIButton(frame: CGRect(
                    x: topLeftCorner.x + CGFloat(col) * (childSize.width + spacing),
                    y: topLeftCorner.y + CGFloat(row) * (childSize.height + spacing),
                    width: childSize.width,
                    height: childSize.height))
                
                button.backgroundColor = gridColor
                
                button.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
                button.setTitle("",for: .normal)
                button.setTitleColor(UIColor.black, for: .normal)
                button.layer.cornerRadius = 10
                button.adjustsImageWhenHighlighted = true
                button.showsTouchWhenHighlighted = true
                button.addTarget(self, action: #selector(tapped(_:)), for: .touchUpInside)
                
                self.addSubview(button)
                self.buttons.append(button)
                
            }
        }
        
        
        Timer.scheduledTimer(withTimeInterval: startTime, repeats: false) { time in 
            if self.play == false { 
                self.play = true 
            }   
            
            self.maxCounter = Int(ViewController.pointsLabelLayer.frame.size.width) 
            self.counter = self.maxCounter
            
        }
        
        var randomTimeLoop = Int.randomi(minLoop, maxLoop)
        var gameLoopTime = 0
        var counter = 0
        
        wordToHit = wordList.chooseOne()
        self.cardsClosed = self.buttons
        
        
        
        gameLoop = GameLoop() { [weak self] in
            
            guard let strongSelf = self else { return }
            if (strongSelf.play ) {
                
                strongSelf.counter -= 1
                ViewController.pointsLabel.text = (ViewController.points == 1) ? "\(ViewController.points) Point" : "\(ViewController.points) Points"
                ViewController.pointsLabelLayer.frame.size.width = CGFloat(strongSelf.counter)
                //print(self?.counter)
                
                if strongSelf.changeTitlelabel == true{
                    strongSelf.clearGrid()
                }
                
                if counter > randomTimeLoop {
                    
                    if strongSelf.changeTitlelabel == true{
                        ViewController.descriptionLabel.text = strongSelf.wordToHit
                        strongSelf.changeTitlelabel = false
                    }
                    
                    
                    if strongSelf.cardsOpened.count  < strongSelf.buttons.count {
                        
                        let openNew = strongSelf.cardsClosed.chooseOne()
                        guard let cardIndex = strongSelf.cardsClosed.index(of: openNew) else { return }
                        
                        let word = (Int.randomi(0, 10) > 3) ? strongSelf.wordList.chooseOne() : strongSelf.wordToHit
                        openNew.backgroundColor = strongSelf.mainColor
                        openNew.setTitle(word, for: .normal)
                        
                        strongSelf.cardsOpened.append(openNew)
                        strongSelf.cardsOpenedLifeTime.append((gameLoopTime + Int.randomi(maxLoop + 10, maxLoop + 50)))
                        strongSelf.cardsClosed.remove(at: cardIndex)
                        
                    }
                    
                    //self.update()
                    randomTimeLoop = Int.randomi(minLoop, maxLoop)
                    counter = 0
                }else{
                    counter += 1
                }
                
                //expired cards
                for (ind, lifetime) in strongSelf.cardsOpenedLifeTime.enumerated(){
                    if lifetime < gameLoopTime{
                        strongSelf.cardsOpened[ind].backgroundColor = strongSelf.gridColor
                        strongSelf.cardsOpened[ind].setTitle("", for: .normal)
                        strongSelf.cardsClosed.append(strongSelf.cardsOpened[ind])
                        strongSelf.cardsOpened.remove(at: ind)
                        strongSelf.cardsOpenedLifeTime.remove(at: ind)
                    }
                }
                
                if (strongSelf.counter <= 0){
                    
                    ViewController.pointsLabel.text = "Game Over, You have \(ViewController.points) Points"
                    strongSelf.play = false
                }
                
            }
            gameLoopTime += 1
        }
        
        
    }
    
    deinit {
        gameLoop?.stop()
        gameLoop = nil
    }
    
    func clearGrid(){
        
        for but in self.buttons{
            but.backgroundColor = self.gridColor
            but.setTitle("", for: .normal)
        }
        
    }
    func  update (){
        
        currentCards.removeAll()
        currentCards = self.buttons.take(2)
        
        var duplicates = Int.randomi(0, currentCards.count - 1) 
        var temp = [UIButton]()
        
        for but in buttons{
            
            if currentCards.contains(but) && !previousCards.contains(but) {
                
                but.backgroundColor = self.mainColor
                
                if (duplicates > 0){
                    but.setTitle(wordToHit, for: .normal)
                    duplicates -= 1
                }else{
                    but.setTitle(wordList.chooseOne(), for: .normal)
                }
                
                temp.append(but)
                
            }else{
                
                //but.backgroundColor = (currentCards.contains(but) && previousCards.contains(but)) ? self.mainColor : self.gridColor
                but.backgroundColor = self.gridColor
                but.setTitle("", for: .normal)
            }
        }
        previousCards.removeAll()
        previousCards = temp
        
    }
    
    public func tapped(_ but: UIButton) {
        
        if (but.backgroundColor == self.mainColor && wordToHit == but.titleLabel?.text){
            
            counter = maxCounter 
            ViewController.points += 1
            wordToHit = wordList.chooseOne()
            changeTitlelabel = true
            
        }else if (but.backgroundColor == self.mainColor && wordToHit != but.titleLabel?.text){
            if (ViewController.points > 0){
                ViewController.points -= 1
            }
        }
        
    }
    
    
}
