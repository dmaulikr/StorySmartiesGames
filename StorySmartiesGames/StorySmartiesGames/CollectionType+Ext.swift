//
//  CollectionType+Ext.swift
//  StorySmartiesCore
//
//  Created by Daniel Asher on 09/08/2016.
//  Copyright © 2016 LEXI LABS. All rights reserved.
//

import Foundation

public extension Collection {
    /// Returns the element at the specified index iff it is within bounds, otherwise nil.
    public subscript (safe index: Index) -> Iterator.Element? {
        return index >= startIndex && index < endIndex ? self[index] : nil
    }
}
// Protocol that adds pairing to CollectionType classes 
public protocol Pairs {}
// We need to make sure SubSequence.Generator.Element == Generator.Element 
// https://airspeedvelocity.net/2016/01/03/generic-collections-subsequences-and-overloading/
public extension Pairs where Self : Collection, Self.SubSequence.Iterator.Element == Self.Iterator.Element, Self.IndexDistance == Int {
    /// Create a tuple array of adjacent pairs. The resulting array is length count-1
    /// - Parameter withWrap: if true pairs the last element with the first.
    public func pairs(withWrap: Bool = false) -> [(Self.Iterator.Element, Self.Iterator.Element)] {
        guard self.count >= 1 else { return [] }
        if withWrap == true {
            var tail = Array(self.dropFirst())
            tail.append(self.first!)
            return Array(zip(self, tail))
        } else {
            let tail = self.dropFirst()
            return Array(zip(self, tail))
        }
    }
    public func maybePairs() -> [(first: Self.Iterator.Element, second: Self.Iterator.Element?)] {
        guard self.count >= 1 else { return [] }
        let second = self.dropFirst().map{ (x: Self.Iterator.Element) -> Self.Iterator.Element? in return x} + [nil]
        return zip(self, second).map{$0}
    }
    public func splitPairs(whereSeparator separator: (Self.Iterator.Element, Self.Iterator.Element) -> Bool ) -> [[Self.Iterator.Element]] {
        guard self.count >= 1 else { return [] }
        let split = self.pairs()
            .split(whereSeparator: separator)
            .map{ unpair($0) }
        // FIXME: ❗️Awful hack! Verify it works too!
        let splitCount = split.map { $0.count }.reduce(0, +)
        if splitCount == self.count - 1 {
            let last = self.suffix(1).map { $0 }
            return split + [last]
        } else {
            return split
        }
    }
}

public func unpair<E>(_ zipped: [(E, E)]) -> [E] {
    var output = zipped.map { $0.0 }
    if let last = zipped.last?.1 {
        output.append(last)
    }
    return output
}

public func unpair<E>(_ zipped: ArraySlice<(E, E)>) -> [E] {
    var output = zipped.map { $0.0 }
    if let last = zipped.last?.1 {
        output.append(last)
    }
    return output
}

public extension Collection where Self.SubSequence.Iterator.Element == Self.Iterator.Element {
    public func split(after index: Self.Index) -> ([Self.Iterator.Element], [Self.Iterator.Element]) {
        guard index >= startIndex else { return ([], self.map{$0}) }
        guard index < endIndex else { return (self.map{$0}, []) }
        return (self.prefix(upTo: index).map{$0}, self.suffix(from: index).map{$0})
    }
    public func split(before index: Self.Index) -> ([Self.Iterator.Element], [Self.Iterator.Element]) {
        return self.split(after: self.index(index, offsetBy: -1))
    }
}

public extension Collection where Self.SubSequence.Iterator.Element == Self.Iterator.Element {
    public func cons() -> (head:  Self.Iterator.Element?, tail: [Self.Iterator.Element]) {
        guard let head = self.first else { return (head: nil, tail: []) }
        let tail = self.dropFirst().flatMap { $0 }
        return (head: head, tail: tail)
    }
    public func bodyTip() -> (body:  [Self.Iterator.Element], tip: Self.Iterator.Element?) {
        let last = self.suffix(1).map { $0 }.first
        guard let tip = last else { return (body: [], tip: nil) }
        let body = self.dropLast().flatMap { $0 }
        return (body: body, tip: tip)
    }
    public func recReduce(_ combine: @escaping (Self.Iterator.Element, Self.Iterator.Element) -> Self.Iterator.Element) -> Self.Iterator.Element? {
        
        return self.first.map {
            head in
            self.dropFirst().flatMap { $0 }
                .recReduce(combine)
                .map {combine(head, $0)}
                ?? head
        }
    }
}

extension Array : Pairs {}
extension Set : Pairs {}




