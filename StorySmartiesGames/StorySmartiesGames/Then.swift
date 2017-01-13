//
//  Then.swift
//  StorySmartiesModel
//
//  Created by Daniel Asher on 13/07/2016.
//  Copyright © 2016 LEXI LABS. All rights reserved.
//

import Foundation

public protocol Then {}
extension Then {

  public func then( block: (Self) -> Void) -> Self {
    block(self)
    return self
  }
}

extension NSObject: Then {}

