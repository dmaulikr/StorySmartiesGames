//
//  Array2D.swift
//  StorySmarties
//
//  Created by Daniel Asher on 03/01/2016.
//  Copyright © 2016 LEXI LABS. All rights reserved.
//

public class Array2D {
    var cols:Int, rows:Int
    var matrix: [Int]
    public init(rows:Int, cols:Int) {
        self.cols = cols
        self.rows = rows
        matrix = Array(repeating:0, count:cols*rows)
    }
    // Row first indexing.
    public subscript(row:Int, col:Int) -> Int {
        get { return matrix[cols * row + col] }
        set { matrix[cols*row+col] = newValue }
    }
    
    public func colCount() -> Int {
        return self.cols
    }
    
    public func rowCount() -> Int {
        return self.rows
    }
}


extension Array2D : CustomStringConvertible {
    public var description : String {
        var str = ""
        for row in 0 ..< self.rows {
            for col in 0 ..< self.cols {
                str += "\(self[row, col]) "                
            }
            str += "\n"
        }
        return str
    }
}
