//
//  GameLoop.swift
//  StorySmartiesGames
//
//  Created by GEORGE QUENTIN on 13/01/2017.
//  Copyright © 2017 GEORGE QUENTIN. All rights reserved.
//

import Foundation
import UIKit

class GameLoop : NSObject {
    
    var doSomething: () -> ()!
    var update : CADisplayLink!
    
    init(doSomething: @escaping () -> ()) {
        self.doSomething = doSomething
        super.init()
        start()
    }
    
    deinit {
        //print("GameLoop", #function)
    }
    // you could overwrite this too
    func handleTimer() {
        doSomething()
    }
    
    func start() {
        update = CADisplayLink(target: self, selector: #selector(GameLoop.handleTimer))
        update.preferredFramesPerSecond = 60
        update.add(to: RunLoop.current, forMode: RunLoopMode.commonModes)
    }
    
    func stop() {
        update.isPaused = true
        update.remove(from: RunLoop.current, forMode: RunLoopMode.commonModes)
        update = nil
        doSomething = { return }
    }
}
