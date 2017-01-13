//
//  Array+Ext.swift
//  StorySmarties
//
//  Created by Daniel Asher on 20/05/2016.
//  Copyright © 2016 StoryShare. All rights reserved.
//

import Foundation

extension Array {
    // group into subarrays by applying predicate to adjacent elements in the source array.
    // let groups = [1,2,3,2,3,4].groupAdjacent { $0 > $1 } 
    // groups == [[1,2,3], [2,3,4]]
    public func groupAdjacent(predicate: (Element, Element) -> Bool) -> [[Element]] {
        guard let head = self.first else { return [] }
        return self.dropFirst().reduce( [[head]] ) { xss, x in
            guard let last = xss.last!.last else { return xss }
            var xssc = xss // copy required to mutate
            predicate(last, x) ? xssc[xss.count-1].append(x) : xssc.append([x])
            return xssc
        }
    }
   
}
