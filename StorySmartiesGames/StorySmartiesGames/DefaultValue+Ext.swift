//
//  DefaultValue+Ext.swift
//  StorySmartiesCore
//
//  Created by Daniel Asher on 05/10/2016.
//  Copyright © 2016 LEXI LABS. All rights reserved.
//
import UIKit
// TODO: Review this. Perhaps a more elegant solution is possible.
public protocol LogWithDefault {
    var value: Self { get }
    init()
}

extension String: LogWithDefault { 
    public var value: String { return self }
}

extension Double: LogWithDefault {
    public var value: Double { return self }
}

extension CGFloat: LogWithDefault {
    public var value: CGFloat { return self }
}

extension Int: LogWithDefault {
    public var value: Int { return self }
}

extension CGRect: LogWithDefault {
    public var value: CGRect { return self }
}


// TODO: Review this. Perhaps a more elegant solution is possible.
extension Optional where Wrapped: LogWithDefault {
    
    public func safeUnwrap(functionName: StaticString = #function, fileName: StaticString = #file, lineNumber: Int = #line) -> Wrapped {
        
        if let bp = self?.value { 
            return bp 
        }else {
            let defaultValue = Wrapped.init()
            return defaultValue
        }
    }
    
}
