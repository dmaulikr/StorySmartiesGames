//
//  WackAMoll.swift
//  StorySmartiesGames
//
//  Created by GEORGE QUENTIN on 13/01/2017.
//  Copyright © 2017 GEORGE QUENTIN. All rights reserved.
//

import Foundation
import UIKit
import Cartography


public class WackAMollGame : UIView {
    
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
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init(frame: CGRect, words: [String], minLoop:Int = 5, maxLoop: Int = 15, spacing: CGFloat = 1, insetsBy: CGFloat = 5) {
        super.init(frame: frame)
        
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
        
        Timer.scheduledTimer(withTimeInterval: 4.0, repeats: false) { time in 
            if self.play == false { self.play = true }            
        }
        
        
        var randomTimeLoop = Int.randomi(minLoop, maxLoop)
        var gameLoopTime = 0
        var counter = 0
        
        wordToHit = wordList.chooseOne()
        self.cardsClosed = self.buttons
        
        _ = GameLoop() { 
            
            if (self.play ) {
                
                ViewController.pointsLabel.text = (ViewController.points == 1) ? "\(ViewController.points) Point" : "\(ViewController.points) Points"
                
                if self.changeTitlelabel == true{
                    self.clearGrid()
                }
                
                if counter > randomTimeLoop {
                    
                    if self.changeTitlelabel == true{
                        ViewController.descriptionLabel.text = self.wordToHit
                        self.changeTitlelabel = false
                    }
                    
                    
                    if self.cardsOpened.count  < self.buttons.count {
                        
                        let openNew = self.cardsClosed.chooseOne()
                        guard let cardIndex = self.cardsClosed.index(of: openNew) else { return }
                        
                        let word = (Int.randomi(0, 10) > 3) ? self.wordList.chooseOne() : self.wordToHit
                        openNew.backgroundColor = self.mainColor
                        openNew.setTitle(word, for: .normal)
                        
                        self.cardsOpened.append(openNew)
                        self.cardsOpenedLifeTime.append((gameLoopTime + Int.randomi(maxLoop + 10, maxLoop + 50)))
                        self.cardsClosed.remove(at: cardIndex)
                        
                    }
                    
                    //self.update()
                    randomTimeLoop = Int.randomi(minLoop, maxLoop)
                    counter = 0
                }else{
                    counter += 1
                }
                
                //expired cards
                for (ind, lifetime) in self.cardsOpenedLifeTime.enumerated(){
                    if lifetime < gameLoopTime{
                        self.cardsOpened[ind].backgroundColor = self.gridColor
                        self.cardsOpened[ind].setTitle("", for: .normal)
                        self.cardsClosed.append(self.cardsOpened[ind])
                        self.cardsOpened.remove(at: ind)
                        self.cardsOpenedLifeTime.remove(at: ind)
                    }
                }
            }
            gameLoopTime += 1
        }
        
        
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
