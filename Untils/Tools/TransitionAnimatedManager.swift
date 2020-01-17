//
//  TransitionAnimatedManager.swift
//  CatchMe
//
//  Created by Zhang on 22/12/2017.
//  Copyright © 2017 Zhang. All rights reserved.
//

import UIKit

class TransitionAnimatedManager: NSObject, UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
//        let containerView = transitionContext.containerView
//        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
//        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
//        
//        var destView: UIView!
//        var destTransfrom = CGAffineTransform.identity
//        let screenHeight = UIScreen.main.bounds.size.height
//        if modalPresentingType == ModalPresentingType.Present {
//            destView = toViewController?.view
//            destView.transform = CGAffineTransform(translationX: 0, y: screenHeight)
//            containerView.addSubview((toViewController?.view)!)
//        } else if modalPresentingType == ModalPresentingType.Dismiss {
//            destView = fromViewController?.view
//            destTransfrom = CGAffineTransform(translationX: 0, y: screenHeight)
//            containerView.insertSubview((toViewController?.view)!, belowSubview: fromViewController?.view)
//        }
//        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0,
//                       options: UIViewAnimationOptions.curveLinear, animations: {
//                                    destView.transform = destTransfrom
//        }, completion: {completed in
//            transitionContext.completeTransition(true)
//        })
    }
}

