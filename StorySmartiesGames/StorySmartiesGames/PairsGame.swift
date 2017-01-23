//
//  Grid.swift
//  StorySmartiesGames
//
//  Created by GEORGE QUENTIN on 13/01/2017.
//  Copyright © 2017 GEORGE QUENTIN. All rights reserved.
//

import Foundation
import UIKit

public class PairsGame : UIView {
    
    // two-dimensional array of your Cell views. You create them elsewhere and add 
    // all of them to GridView
    public var originals = [(button:UIButton, color:UIColor, word:String)]() 
    public var recentChoiceColor = UIColor()
    public var recentChoiceWord = String()
    public var recentChoiceLocation = CGPoint()
    public var recentChoiceBool = false
    public var recentChoiceIndex = 0
    public var play = false
    public var mainColor = UIColor.red
    public var mainText = ""
    public var pairsFoundIndex = [Int]()
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init(frame: CGRect, words: [String]?, startTime: TimeInterval, colored: Bool = false,  spacing: CGFloat = 1, insetsBy: CGFloat = 5) {
        super.init(frame: frame)
        
        ViewController.titleLabel.text = "Pairs Game"
        ViewController.descriptionLabel.text = "Find 8 Pairs"
        
        //square size of the grid
        guard let wordsList = words, 
            let wordCount = (words?.count), (wordCount == 8) else { print("Must have 8 words"); return }
        
        let size = (wordCount/2)
        
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
        
        //button color pallet
        let colorsWithIndex : (colors:[UIColor], index: [Int]) = self.getColors(size)
        let colors = colorsWithIndex.colors
        var iterator = 0
        
        let wordsToAdd = colorsWithIndex.index.flatMap{ (index) -> String in
            return (index > wordCount - 1) ? wordsList[index - wordCount] : wordsList[index]
        }
        
        for row in 0..<size {
            for col in 0..<size {
                
                if (iterator < colors.count){
                    
                    let button = UIButton(frame: CGRect(
                        x: topLeftCorner.x + CGFloat(col) * (childSize.width + spacing),
                        y: topLeftCorner.y + CGFloat(row) * (childSize.height + spacing),
                        width: childSize.width,
                        height: childSize.height))
                    
                    let color = colored ? colors[iterator] : UIColor(red: CGFloat(102.0/255), green: CGFloat(143.0/255), blue: CGFloat(138.0/255), alpha: 1.0)
                    button.backgroundColor = color
                    
                    
                    let titleColor = color.getTextColor()
                    
                    let title = wordsToAdd[iterator]
                    button.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
                    button.setTitle(title,for: .normal)
                    button.setTitleColor(titleColor, for: .normal)
                    button.layer.cornerRadius = 10
                    button.adjustsImageWhenHighlighted = true
                    button.showsTouchWhenHighlighted = true
                    button.addTarget(self, action: #selector(tapped(_:)), for: .touchUpInside)
                    iterator += 1
                    
                    self.addSubview(button)
                    self.originals.append((button, color, title))
                }
            }
        }
        
        
        Timer.scheduledTimer(withTimeInterval: startTime, repeats: false) { _ in 
            if self.play == false {
                for element in self.originals {
                    element.button.backgroundColor = self.mainColor
                    element.button.setTitle(self.mainText,for: .normal)
                }
                ViewController.pointsLabel.text = (ViewController.points == 1) ? "Found \(ViewController.points) Pair" : "Found \(ViewController.points) Pairs"
                self.play = true
            }            
        }
        
    }
    
    deinit {
      //  print(#function)
    }
    
    public func tapped(_ but: UIButton) {
        
        var getOriginalColor = UIColor()
        var getOriginalWord = String()
        var getOriginalColorIndex = 0
        _ = self.originals.enumerated().flatMap{ (ind, element) -> Bool in
            if but.center == element.button.center {
                
                getOriginalColor = element.color
                getOriginalWord = element.word
                getOriginalColorIndex = ind
                
                return true
            }else {
                return false
            }
        }
        
        if self.play == true {
            
            but.backgroundColor = getOriginalColor
            but.setTitle(getOriginalWord,for: .normal)
            
            guard let color = but.backgroundColor, let title = but.titleLabel?.text else { return }
            
            if recentChoiceBool == false {
                recentChoiceColor = color
                recentChoiceWord = title
                recentChoiceBool = true
                recentChoiceLocation = but.center
                recentChoiceIndex = getOriginalColorIndex
                print( "first choice" )
            }else {
                if (recentChoiceColor == color && recentChoiceWord == title && but.center != recentChoiceLocation && !pairsFoundIndex.contains(getOriginalColorIndex) ){
                    pairsFoundIndex.append(recentChoiceIndex)
                    pairsFoundIndex.append(getOriginalColorIndex)
                    
                    ViewController.points += 1
                    print( "found pair, pairs found: ", pairsFoundIndex.count)
                    if pairsFoundIndex.count >= originals.count {
                        print( "\n====Game Over====")
                    }
                    
                }else{
                    
                    let recent = recentChoiceIndex
                    
                    if !pairsFoundIndex.contains(getOriginalColorIndex){
                        
                        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in 
                            self.originals[getOriginalColorIndex].button.backgroundColor = self.mainColor
                            self.originals[recent].button.backgroundColor = self.mainColor
                            
                            self.originals[getOriginalColorIndex].button.setTitle(self.mainText,for: .normal) 
                            self.originals[recent].button.setTitle(self.mainText,for: .normal) 
                        }
                        print( "did not find pair" )
                    }
                    
                }
                
                recentChoiceColor = UIColor()
                recentChoiceWord = ""
                recentChoiceBool = false
                recentChoiceLocation = CGPoint.zero
                recentChoiceIndex = 0
            }
            
        }
        
        ViewController.pointsLabel.text = (ViewController.points == 1) ? "Found \(ViewController.points) Pair" : "Found \(ViewController.points) Pairs"
        
    }
    
    public func getColors (_ amount: Int) -> ([UIColor], [Int]) { 
        
        let counter = (amount * amount) / 2
        var colors = [UIColor]()
        var index = 0
        while index < counter {
            colors.append(UIColor.randomColor())
            index = index + 1
        }
        return colors.pairsWithShuffledIndex()
    }
    
    
    
}
