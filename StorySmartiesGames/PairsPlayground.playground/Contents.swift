//: Playground - noun: a place where people can play

import UIKit

let arr = [1,2,3,4,5]

var pair = [(Int, Int)]()
for (ind,i) in arr.enumerated(){
    
    if ind < arr.count - 1 {
        pair.append( ( i, arr[ind + 1] ) )
    }
}

let tail = arr.dropFirst()

let pairs = 
    zip(arr, arr.dropFirst()).map{$0}

print(pair)
let target = [(1,2), (2,3), (3,4), (4,5)]


let random = [1,5,-3,5,7,2,10]
let drops = 
    zip(random, random.dropFirst()).enumerated().filter { $1.1 < $1.0 }.map { $0.offset }
print(drops)
var str = "Hello, playground"



/*
 
 let text = mainTextview.text!
 //let attrString = mainTextview.attributedText
 
 let (tags, ranges) = text.toLinguisticTagRanges()
 zip(tags, ranges).forEach { tag, range in 
 print(tag.pad(by: 20), text[range])
 }
 //print(tags, ranges)
 let sentenceTerminatorIndices = tags.enumerated().filter { $1 == "SentenceTerminator" }.map { $0.offset }
 
 let tagPairs = tags.pairs()
 let withCloseQuote = tagPairs.enumerated().filter { $1.0 == "SentenceTerminator" && $1.1 == "CloseQuote" }.map { $0.offset + 1 }
 print("withCloseQuote:", withCloseQuote)
 print(sentenceTerminatorIndices)
 
 var sentenceRanges = sentenceTerminatorIndices.map { text.startIndex ..< ranges[$0].upperBound }
 
 if let lastUpperBound = sentenceRanges.last?.upperBound, lastUpperBound != text.endIndex {
 sentenceRanges.append(lastUpperBound ..< text.endIndex)
 } else if sentenceRanges.isEmpty {
 sentenceRanges.append(text.startIndex ..< text.endIndex)
 }
 
 //sentenceRanges.forEach { print("sentence", text[$0]) }
 //        let firstSentenceRange = mainTextview.text.startIndex ..< ranges[sentenceTerminatorIndices.first!].upperBound
 
 //      let firstSentence = mainTextview.text[firstSentenceRange]
 
 //print(firstSentence)
 
 //print("attributedText.size:", mainTextview.attributedText.size())
 let sentenceRects = sentenceRanges.map { sentenceRange -> CGSize in
 
 let subString = text[sentenceRange]
 
 print("substring", subString)
 
 let myAttrString = NSAttributedString(string: subString, attributes: 
 [NSFontAttributeName: mainTextview.font!,
 NSForegroundColorAttributeName: UIColor.black] )
 //            let subRange = NSRange(location: 0, length: numberOfGlyphs)
 //let subString = myAttrString.attributedSubstring(from: subRange)
 let framesetter = CTFramesetterCreateWithAttributedString(myAttrString)
 let size = CGSize(width: mainTextview.frame.width, height: CGFloat.greatestFiniteMagnitude)
 let frameSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, myAttrString.length), nil, size, nil)
 print("frameSize:", frameSize)
 //            print(subRange.toRange)
 //let attrStr = mainTextview.attributedText!.attributedSubstring(from: subRange)
 //print("attrStr", attrStr)
 let rect = myAttrString 
 .boundingRect(with: size, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
 
 print("rect:", rect, "framesize:",frameSize)
 //let boundingRect = mainTextview.layoutManager.boundingRect(forGlyphRange: subRange, in: mainTextview.textContainer)
 //print("boundingRect:", boundingRect, "numberOfGlyphs:", numberOfGlyphs)
 return frameSize
 }
 
 //let numberOfGlyphs =  sentenceTerminatorIndices //mainTextview.layoutManager.numberOfGlyphs
 //print("contentSize:", mainTextview.contentSize, "frame:", mainTextview.frame)
 
 //        boundingRec.frame = boundingRect
 //        boundingRec.backgroundColor = UIColor.randomColor()
 //boundingRec.frame.size = mainTextview.contentSize
 //        if (play == false){
 //            retry()
 //            play = true
 //        }
 
 */