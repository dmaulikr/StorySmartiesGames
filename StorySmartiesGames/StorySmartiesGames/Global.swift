//
//  Global.swift
//  LEXI LABS
//
//  Created by Daniel Asher on 18/06/2015.
//  Copyright (c) 2015 AsherEnterprises. All rights reserved.
//

import Foundation
import UIKit

public func urlToDocumentFile(filename: String) -> NSURL! {
    var path = [String]()
    for p in NSSearchPathForDirectoriesInDomains(
        FileManager.SearchPathDirectory.documentDirectory,
        FileManager.SearchPathDomainMask.userDomainMask, true) {
            path.append(p)
    }
    
    path.append(filename)
    
    return NSURL.fileURL(withPathComponents: path) as NSURL!
}

public func pathToDocumentFile(filename: String) -> String? {
    let url = urlToDocumentFile(filename: filename)
    return url?.path
}

public extension NSRange {
    public var toRange : Range<Int> {
        return location ..< (location + length)
    }
}



extension Sequence where Self.Iterator.Element: Hashable {
    private typealias Element = Self.Iterator.Element
    
    public func freq() -> [Element: Int] {
        return reduce([:]) { (accu: [Element: Int], element) in
            var accu = accu
            accu[element] = accu[element]?.advanced(by: 1) ?? 1
            return accu
        }
    }
    
    public func chooseOne () -> Element {
        let list: [Element] = self as! [Self.Iterator.Element]
        let len = UInt32(list.count)
        let random = Int(arc4random_uniform(len))
        return list[random]
    }
    
    public func take(_ amount: Int) -> [Element] {
        guard var list = (self as? [Self.Iterator.Element]), list.count > 2, amount < list.count else { return [] }
        
        var temp = [Element]()
        var count = amount
        
        while count > 0 {
            let index = Int(arc4random_uniform(UInt32(list.count - 1)))
            temp.append(list[index])
            list.remove(at: index)
            
            count -= 1
        }
        
        return temp
    }
    
    public func shuffleArr() -> [Element] {
        
        guard var list = (self as? [Self.Iterator.Element]), list.count > 2 else { return [] }
        
        var temp = [Element]()
        
        while list.count > 0 {
            let index = Int(arc4random_uniform(UInt32(list.count - 1)))
            temp.append(list[index])
            list.remove(at: index)
        }
        
        return temp
    }
    
    public func pairsArr () -> [Element] { 
        guard let list = (self as? [Self.Iterator.Element]) else { return [] }
        let temp = list + list
        return temp.shuffleArr()
    }
    
    public func pairsWithShuffledIndex () -> (elements:[Element] ,index: [Int]){ 
        guard let list = (self as? [Self.Iterator.Element]), list.count > 2 else { return ([], [])}
        
        var newList = list + list
        var newIntList = newList.enumerated().flatMap{ (ind, ele) -> Int in return ind }
        
        var temp = [Element]()
        var tempInt = [Int]()
        
        while newList.count > 0 {
            let index = Int(arc4random_uniform(UInt32(newList.count - 1)))
            temp.append(newList[index])
            tempInt.append(newIntList[index])
            
            newList.remove(at: index)
            newIntList.remove(at: index)
        }
        
        
        return (temp,tempInt)
    }
    
    
}


extension Sequence where Self.Iterator.Element: Equatable {
    private typealias Element = Self.Iterator.Element
    
    public func wordFreq() -> [(element: Element, count: Int)] {
        
        let empty: [(Element, Int)] = []
        
        return reduce(empty) { (accu: [(Element, Int)], element) in
            var accu = accu
            for (index, value) in accu.enumerated() {
                if value.0 == element {
                    accu[index].1 += 1
                    return accu
                }
            }
            
            return accu + [(element, 1)]
        }
    }
    
}










