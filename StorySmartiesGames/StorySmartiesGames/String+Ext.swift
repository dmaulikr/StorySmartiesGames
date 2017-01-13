//
//  WordModel.swift
//  UIKitDynamicsApp
//
//  Created by GEORGE QUENTIN on 13/04/2016.
//  Copyright © 2016 RealEx. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

extension String {
    
    public static var listOfSightWords : [String] {
        return [
            "a", "an", "am", "at", "are", "as", "at", "and", "all", "about", "after",
            "be", "big", "by", "but", "been",
            "can", "could", "called", "come",
            "did", "down", "do",
            "each",
            "from", "first", "find", "for",
            "go",
            "he", "his", "had", "how", "has", "her", "here", "have", "him",
            "in", "I", "if", "into", "is", "it", "its",
            "just",
            "know",
            "like", "look", "long", "little",
            "me", "my", "made", "may", "make", "more", "many", "most",
            "not", "no", "now",
            "or", "one", "of", "out", "other", "over", "only", "on",
            "people",
            "said", "she",  "some", "so", "see", "small", "sit", 
            "this", "there", "the", "them", "then", "these", "two", "time", "than", "that", "their", "too", "to", 
            "up", "use",
            "very",
            "was", "wish", "with", "what", "were", "when", "we", "which", "will", "would", "words", "where", "water", "who", "way",
            "you", "your"
        ]
    }
    
    public func splitWithFullStop() -> [String] {
        return self.components(separatedBy: ".").filter { $0.isEmpty != true  }.map { $0.replaceCharacters() }
    }
    
    public func splitWithComma() -> [String] {
        return self.components(separatedBy: ",").filter { $0.isEmpty != true  }.map { $0.replaceCharacters() }
    }
    
    public func replaceCharacters() -> String {
        
        return self.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: "\t", with: "")
    }
    public func replaceCharacters2() -> String {
        
        return self
            .replacingOccurrences(of: "\n", with: "")
            .replacingOccurrences(of: "\t", with: "")
            .replacingOccurrences(of: "\"", with: "")
            .replacingOccurrences(of: "!", with: "")
            .replacingOccurrences(of: ";", with: "")
            .replacingOccurrences(of: "(", with: "")
            .replacingOccurrences(of: ")", with: "")
            .replacingOccurrences(of: "—", with: " ")
            .replacingOccurrences(of: "-", with: " ")
    }
    
    public func indexAt(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    
    public func substringFrom(from: Int) -> String {
        let fromIndex = indexAt(from: from)
        return self.substring(from: fromIndex)
    }
    
    public func substringTo(to: Int) -> String {
        let toIndex = indexAt(from: to)
        return self.substring(to: toIndex)
    }
    
    public func substringWithRange(with r: Range<Int>) -> String {
        let startIndex = indexAt(from: r.lowerBound)
        let endIndex = indexAt(from: r.upperBound)
        return self.substring(with: startIndex..<endIndex)
    }
    
    public static func replaceAt(str: String, index: Int, newCharac: String) -> String {
        return str.substringTo(to: index - 1)  + newCharac + str.substringFrom(from: index)
    }
    
    public func checkCharSet(_ part:String, _ char: CharacterSet) -> Bool{
        let check = part.rangeOfCharacter(from: char)
        return (check != nil) ? true : false
    }
    
    public func isPunctuation(_ part: String) -> Bool{
        let punctSet = CharacterSet.punctuationCharacters
        return checkCharSet(part, punctSet)
    }    
    
    public func isHexadecimal(_ part:String) -> Bool{
        let hexadecimal = CharacterSet.alphanumerics 
        return checkCharSet(part, hexadecimal)
    }
    
    public func scrambleString() -> String {
        
        var chars = Array(self.characters)
        var result = ""
        
        while chars.count > 0 {
            let index = Int(arc4random_uniform(UInt32(chars.count - 1)))
            chars[index].write(to: &result)
            chars.remove(at: index)
        }
        return result
    }
    
    
    public func wordCount() -> Dictionary<String, Int> {
        let words = self.components(separatedBy: " ")
        var wordDictionary = Dictionary<String, Int>()
        for word in words {
            if wordDictionary[word] != nil {
                wordDictionary[word] = wordDictionary[word]! + 1
            } else {
                wordDictionary[word] = 1
            }
        }
        return wordDictionary
    }
    
    public func mostCommonWordsWithWordCount (_ minWordCount: Int) -> [String] {
        return self
            .lowercased()
            .replaceCharacters2()
            .wordCount()
            .flatMap({ (key: String, value: Int) -> String? in
                return (value > minWordCount) ? key : nil
            }).filter { $0.isEmpty != true  } 
    }
    
    public func replaceSightWord() -> (String, [String], [String], [Int])
    {
        
        var wordsFound  = [String]()
        var indexofWordsFound = [Int]()
        let wordsInSentence = self.lowercased().toWords().removeExtras()
        let firstWordInSentence = wordsInSentence.first.safeUnwrap().lowercased()
        for (index,word) in wordsInSentence.enumerated(){
            
            if ( String.listOfSightWords.contains(word) ) {
                wordsFound.append(word)
                indexofWordsFound.append(index)
            }else if word == "i"{
                wordsFound.append("I")
                indexofWordsFound.append(index)
            }
        }
        
        var ress = self
        for i in wordsFound {
            ress = ress.replacingOccurrences(of: " \(i) ", with: " ... ")
            ress = ress.replacingOccurrences(of: "—\(i) ", with: "—... ")
            ress = ress.replacingOccurrences(of: " \(i);", with: " ...;")
            ress = ress.replacingOccurrences(of: "(\(i) ", with: "(... ")
            ress = ress.replacingOccurrences(of: " \(i))", with: " ...)")
        }
        
        if (String.listOfSightWords.contains(firstWordInSentence)){
            ress = ress.replaceFirstWord("... ")
        }
        
        //wordsFound = Array(Set(wordsFound))
        let mirroredSentenced = self
            .components(separatedBy: [" ","\""])
            .filter { $0.isEmpty != true  }
            .splitButRetainValue("—", true)
        print(self, wordsInSentence, mirroredSentenced, wordsFound, indexofWordsFound)
        
        return  (ress, mirroredSentenced, wordsFound, indexofWordsFound)
    }
    
    public func replaceFirstWord(_ with: String) -> String
    {
        var result = String()
        let firstWordLength : Int = self.components(separatedBy: " ").first?.characters.count ?? 0
        
        for (index, c) in self.characters.enumerated(){
            if (index >= firstWordLength){
                result += "\(c)"
            }
        }
        
        return with + result
    }
    
    
    
    public static func randomVowels(excludedVowelsCharacter: Character? = nil) -> String {
        
        let vowels = "aeiou"
        let filtered = String(vowels
            .characters
            .filter { char in char != excludedVowelsCharacter }
        )
        
        let allowedVowelsCount = filtered.characters.count
        let randomNum = Int.randomi(0, allowedVowelsCount-1) 
        let rangeIndex = filtered.index(filtered.startIndex, offsetBy: randomNum)
        let randomVowel = String(filtered[rangeIndex])
        
        return  randomVowel
        
    }
    
    public static func randomConsonants(excludedConsonantCharacter: Character? = nil) -> String {
        
        let consonants = "bcdfghjklmnpqrstvwxyz"
        let filtered = String(consonants
            .characters
            .filter { char in char != excludedConsonantCharacter }
        )
        
        let allowedConsonantsCount = filtered.characters.count
        let randomNum = Int.randomi(0,allowedConsonantsCount-1)
        
        let rangeIndex = filtered.index(filtered.startIndex, offsetBy: randomNum)
        let randomConsonant = String(filtered[rangeIndex])
        
        return randomConsonant
    }
  
    public func toWords() -> [String] {
        return self["(\\b[^\\s]+\\b)"].matches()
    }
    
    public func toWordRanges() -> [Range<Int>] {
        return self["(\\b[^\\s]+\\b)"]
            .ranges()
            .map { $0.location ..< ($0.location + $0.length) } 
    }
    
    // Use linguistic tags to generate sentences from String
    public func toLinguisticTagRanges() -> (tags: [String], ranges: [Range<String.Index>]) {
        var r = [Range<String.Index>]()
        let i = self.characters.indices
        let t = self.linguisticTags(
            in: i.startIndex ..< i.endIndex, 
            scheme: NSLinguisticTagSchemeLexicalClass, 
            options: .joinNames, 
            orthography: nil, 
            tokenRanges: &r)
        
        return (t, r)
    }
    
    // FIXME: Move `SentenceTerminator`s after CloseQuote and Whitespace
    public func toSentences() -> [String] {
        
        let (tags, ranges) = toLinguisticTagRanges()
        
        var result = [String]()
        let ixs = tags.enumerated().filter {
            $0.element == "SentenceTerminator"
            }
            .map { return ranges[$0.offset].lowerBound}
        
        if ixs.count == 0 {
            return [self]
        }
        let prev = self.startIndex
        for ix in ixs {
            let r = prev...ix
            //            self[r].trimmingCharacters(in: .whitespaces)
            let trimmed = self[r].trimmingCharacters(in: .whitespaces)
            result.append(trimmed)
            // FIXME: This algorithm is broken here!!!
            //prev = ix.advancedBy(1)
        }
        
        return result
    }
    
    public func pad(by newLength: Int, with withString: String = " ", at startingAtIndex: Int = 0) -> String {
        return self.padding(toLength: newLength, withPad: " ", startingAt: 0)
    }
    
    public init(sep:String, _ lines:String...){
        self = ""
        for (idx, item) in lines.enumerated() {
            self += "\(item)"
            if idx < lines.count-1 {
                self += sep
            }
        }
    }
    
    public init(_ lines:String...){
        self = ""
        for (idx, item) in lines.enumerated() {
            self += "\(item)"
            if idx < lines.count-1 {
                self += "\n"
            }
        }
    }
    
    public func splitBy(characters: [Character], swallow: Bool = false) -> [String] {
        
        var substring = ""
        var array = [String]()
        var index = 0
        
        for character in self.characters {
            
            if let lastCharacter = substring.characters.last {
                
                // swallow same characters
                if lastCharacter == character {
                    
                    substring.append(character)
                    
                } else {
                    
                    var shouldSplit = false
                    
                    // check if we need to split already
                    for splitCharacter in characters {
                        // slit if the last character is from split characters or the current one
                        if character == splitCharacter || lastCharacter == splitCharacter {
                            
                            shouldSplit = true
                            break
                        }
                    }
                    
                    if shouldSplit {
                        
                        array.append(substring)
                        substring = String(character)
                        
                    } else /* swallow characters that do not equal any of the split characters */ {
                        
                        substring.append(character)
                    }
                }
            } else /* should be the first iteration */ {
                
                substring.append(character)
            }
            
            index += 1
            
            // add last substring to the array
            if index == self.characters.count {
                
                array.append(substring)
            }
        }
        
        return array.filter {
            
            if swallow {
                
                return true
                
            } else {
                
                for splitCharacter in characters {
                    
                    if $0.characters.contains(splitCharacter) {
                        
                        return false
                    }
                }
                return true
            }
        }
    }
    
}

func *(lhs: Character, rhs: Int) -> String {
    return String(repeating: String(lhs), count: rhs)
}

extension Collection where Iterator.Element == String {
    
    public func removeFirstEmptySpace () -> [String]
    {
        return self.flatMap{ sentence -> String in 
            if (sentence.characters.first == " "){
                return String.replaceAt(str: sentence, index: 1, newCharac: "")
            }else{
                return sentence
            }
        } 
    }
    
    public func removeExtras () ->[String]{
        return self.flatMap { str -> [String] in
            return str.components(separatedBy: ["—", "*", "/"])
        }
    }
    
    public func splitButRetainValue(_ val: String, _ front: Bool ) -> [String]{
        
        return self.flatMap { str -> [String] in
            
            var res = str.components(separatedBy: val)
            
            if (res.count > 1){
                res[res.count - 1] = front ? (val + res.last.safeUnwrap()) : (res.last.safeUnwrap() + val) 
            }
            return res
        }
    }
    
    public func sentenceWithWordFrequency (_ wordCountAmount: Int) -> [Int] {
        let count = (wordCountAmount<0) ? 0 : wordCountAmount
        return self.enumerated().flatMap { (ind, sent) -> Int? in
            let checkWordCount = sent
                .lowercased()
                .replaceCharacters2()
                .wordCount()
                .flatMap({ (key: String, value: Int) -> Bool in
                    return (value > count && key.isEmpty != true ) ? true : false
                }) 
            return checkWordCount.contains(true) ? ind : nil
        }
    }
    
    public func sentenceWith (minWordCount: Int) -> [Int] {
        return self.enumerated().flatMap { (ind, sent) -> Int? in
            return (sent.replaceCharacters2().toWords().count > minWordCount && sent.isEmpty != true ) ? ind : nil
        }
    }
    
    public func indexOfSentencesToShow (minAmountOfCharactersInAWord: Int, minAmountOfPotentialWord: Int) -> [(index: Int, wordsToFind: [String])]  {
        
        let PontentialSentencesToShow = self.sentenceWith(minWordCount: 5)
        return self.enumerated().flatMap{ (ind, sent) -> (Int, [String])? in
            
            if (PontentialSentencesToShow.contains(ind)){
                
                let wordSetInSentence = Array(Set( sent/*lowercased()*/.replaceCharacters2().toWords() ))
                let finalSet = wordSetInSentence.flatMap { word -> String? in
                    return (word.characters.count > minAmountOfCharactersInAWord && word.isEmpty != true) ? word : nil
                }
                return (finalSet.count > minAmountOfPotentialWord) ? (ind, finalSet) : (nil) 
            }else{
                return (nil)
            }
        }
        
    }
    
    
    public func wordsList(minCharacters: Int, maxCharacters: Int) -> [String] {
        
        let getWords = self.flatMap{ word -> [String] in
            return word
                .replaceCharacters2()
                .toWords()
                .flatMap { word -> String? in
                    return (word.characters.count > minCharacters && word.characters.count < maxCharacters && word.isEmpty != true) ? word : nil
            }
        }
        
        let words = Array(Set(getWords))
        
        return words
        
    }
    
    
    
}



