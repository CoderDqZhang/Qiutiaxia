//
//  UITapGestureRecognizer+Extention.swift
//  CatchMe
//
//  Created by Zhang on 20/11/2017.
//  Copyright © 2017 Zhang. All rights reserved.
//

import UIKit

extension UIView {
    /// Tap
    func newTapGesture(config: @escaping (UITapGestureRecognizer) -> Void) -> NewGestureAction<UITapGestureRecognizer> {
        let tap = NewTapGesture(config: config)
        addGestureRecognizer(tap)
        return tap.gestureAction
    }
    
    func whenTap(handler: @escaping TapGestureHandler) {
        let tap = NewTapGesture(handler: handler)
        addGestureRecognizer(tap)
    }
    
    /// Pan
    func newPanGesture(config: @escaping (UIPanGestureRecognizer) -> Void = {_ in }) -> NewGestureAction<UIPanGestureRecognizer> {
        let pan = NewPanGesture(config: config)
        addGestureRecognizer(pan)
        return pan.gestureAction
    }
    
    /// Longpress
    func newLongpressGesture(config: @escaping (UILongPressGestureRecognizer) -> Void = {_ in}) -> NewGestureAction<UILongPressGestureRecognizer> {
        let longPress = NewLongPressGesture(config: config)
        addGestureRecognizer(longPress)
        return longPress.gestureAction
    }
    
}

typealias NewLongpressHandler = (UILongPressGestureRecognizer) -> Void
class NewLongPressGesture: UILongPressGestureRecognizer {
    
    var gestureAction = NewGestureAction<UILongPressGestureRecognizer>()
    
    init(config: NewLongpressHandler) {
        super.init(target: gestureAction, action: #selector(gestureAction.gestureAction(gesture:)))
        config(self)
        
    }
    
}


typealias PanGestureHandler = (UIPanGestureRecognizer) -> Void
class NewPanGesture: UIPanGestureRecognizer {
    
    var gestureAction = NewGestureAction<UIPanGestureRecognizer>()
    
    init(config: PanGestureHandler) {
        super.init(target: gestureAction, action: #selector(gestureAction.gestureAction(gesture:)))
        config(self)
    }
}

typealias TapGestureHandler = (UITapGestureRecognizer) -> Void

class NewTapGesture: UITapGestureRecognizer {
    var gestureAction = NewGestureAction<UITapGestureRecognizer>()
    
    init(handler: @escaping TapGestureHandler) {
        gestureAction.endedHandler = handler
        super.init(target: gestureAction, action: #selector(gestureAction.tapAction(gesture:)))
    }
    init(config: @escaping TapGestureHandler) {
        super.init(target: gestureAction, action: #selector(gestureAction.tapAction(gesture:)))
        config(self)
    }
}

class NewGestureAction<T: UIGestureRecognizer> {
    typealias NewGestureHandler = (_ gestureRecognizer: T) -> Void
    
    var beginHandler: NewGestureHandler?
    var cancelledHandler: NewGestureHandler?
    var changeHandler: NewGestureHandler?
    var endedHandler: NewGestureHandler?
    var failedHandler: NewGestureHandler?
    
    @objc func gestureAction(gesture: UIGestureRecognizer) {
        switch gesture.state {
        case .began:
            beginHandler?(gesture as! T)
        case .cancelled:
            cancelledHandler?(gesture as! T)
        case .changed:
            changeHandler?(gesture as! T)
        case .ended:
            endedHandler?(gesture as! T)
        case .failed:
            failedHandler?(gesture as! T)
        case .possible:
            break
        }
    }
    
    func whenBegan(handler: @escaping NewGestureHandler) -> NewGestureAction<T> {
        beginHandler = handler
        return self
    }
    
    func whenCancelled(handler: @escaping NewGestureHandler) -> NewGestureAction<T> {
        cancelledHandler = handler
        return self
    }
    
    func whenChanged(handler: @escaping NewGestureHandler) -> NewGestureAction<T> {
        changeHandler = handler
        return self
    }
    
    func whenEnded(handler: @escaping NewGestureHandler) -> NewGestureAction<T> {
        endedHandler = handler
        return self
    }
    func whenFailed(handler: @escaping NewGestureHandler) -> NewGestureAction<T> {
        failedHandler = handler
        return self
    }
    
    
    
    /// Tap手势用
    func whenTaped(handler: @escaping TapGestureHandler) {
        endedHandler = handler as? (T) -> Void
    }
    
    @objc func tapAction(gesture: UITapGestureRecognizer) {
        if T.self is UITapGestureRecognizer.Type {
            (endedHandler as! ((UITapGestureRecognizer) -> Void))(gesture)
        }
    }
}
