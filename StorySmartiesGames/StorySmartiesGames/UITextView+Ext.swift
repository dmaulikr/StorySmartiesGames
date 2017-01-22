//
//  UITextView+Ext.swift
//  StorySmartiesView
//
//  Created by Daniel Asher on 13/09/2016.
//  Copyright © 2016 LEXI LABS. All rights reserved.
//

import Foundation
import UIKit

public protocol UITextViewExtensions { 
    func range(from textRange: UITextRange) -> Range<Int>
    func rect(for range: Range<Int>) -> CGRect?
}

extension UITextView : UITextViewExtensions {
    @available(iOS, deprecated, message: "Replace call with `range(from textRange: UITextRange) -> Range<Int>`")
    public func textRangeToIntRange(range textRange: UITextRange) -> Range<Int> {
        return self.range(from: textRange)
    }
    
    public func range(from textRange: UITextRange) -> Range<Int> {
        let start = self.offset(from: self.beginningOfDocument, to: textRange.start)
        let end = self.offset(from: self.beginningOfDocument, to: textRange.end)
        return start ..< end
    }
    
    // TODO: Use CoreText to compute the glyph rects (which will account for line spacing!)
    @available(iOS, deprecated, message: "Replace call with `rect(for: Range<Int>) -> CGRect?`")
    public func rectForRange(range: Range<Int>) -> CGRect? {
        return self.rect(for: range)
    }
    // rect is the new API for rectForRange
    public func rect(for range: Range<Int>) -> CGRect? {
        // UITextView.selectable must be true for firstRectForRange to work! Horrible Apple API. 
        let originalSelectable = self.isSelectable
        if self.isSelectable == false {
            self.isSelectable = true
        }
        defer { 
            if self.isSelectable != originalSelectable {
                self.isSelectable = originalSelectable 
            }
        }
        guard 
        let start   = self.position(from: self.beginningOfDocument, offset: range.lowerBound),
        let end     = self.position(from: self.beginningOfDocument, offset: range.upperBound), 
        let textRange = self.textRange(from: start, to: end) 
            else { 
                print("No rect found for range \(range)")
                return nil }
        let rect = self.firstRect(for: textRange)
        let offset = self.contentOffset
        return rect.offsetBy(dx: -offset.x, dy: -offset.y)
    }
    
}
