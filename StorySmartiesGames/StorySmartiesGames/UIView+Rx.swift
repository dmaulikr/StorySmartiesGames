//
//  UIView+Rx.swift
//  StorySmarties
//
//  Created by Daniel Asher on 30/12/2015.
//  Copyright © 2015 LEXI LABS. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
 
private var uiView_touches_AssociationKey: UInt = 0

public extension UIView {
    
    var rx_touches: Variable<Set<UITouch>> {
        
        get {
            if let touches = objc_getAssociatedObject(self, &uiView_touches_AssociationKey) as?  Variable<Set<UITouch>> {
                return touches 
            } else {
                let emptySet = Variable(Set<UITouch>())
                objc_setAssociatedObject(self, &uiView_touches_AssociationKey, emptySet, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN) 
                return emptySet 
            }
        }
        
        set(newValue)   {
            objc_setAssociatedObject(self, &uiView_touches_AssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            
        }
    }
    
    override open func  touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.rx_touches.value = touches 
        super.touchesBegan(touches, with: event)
    }
    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.rx_touches.value = touches 
        super.touchesMoved(touches, with: event)
    }
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.rx_touches.value = touches 
        super.touchesEnded(touches, with: event)
    }

    public var rx_backgroundColor : AnyObserver<UIColor> {
        return AnyObserver<UIColor> { [weak self] event in
            MainScheduler.ensureExecutingOnScheduler() 
            switch event {
            case .next(let color):
                self?.backgroundColor = color
            case .error(let error):
                bindingErrorToInterface(error: error)
                break
            case .completed:
                break
            }
        }
    }
    
    public func iterateAllSubviews<T>(action: (T) -> Void) {
        
        // Get the subviews of the view
        let subviews = self.subviews
        
        // Return if there are no subviews
        if subviews.count == 0 {
            return
        }
        
        for subview in subviews {
            
            // Do what you want to do with the subview
            if let button = subview as? T {
                action(button) 
            } 
            
            // List the subviews of subview
            subview.iterateAllSubviews(action: action)
        }
    } 
    
}

func bindingErrorToInterface(error: Error) {
    let error = "Binding error to UI: \(error)"
#if DEBUG
    fatalError(error)
#else
    log.severe(error)
#endif
}
