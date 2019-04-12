//
//  DismissAnimator.swift
//  Aspetica
//
//  Created by Artem Misesin on 2/17/17.
//  Copyright © 2017 Artem Misesin. All rights reserved.
//

import UIKit

class DismissAnimator : NSObject {
}

extension DismissAnimator : UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
            else {
                return
        }
        let containerView = transitionContext.containerView
        containerView.insertSubview(toVC.view, belowSubview: fromVC.view)
        
        let screenBounds = UIScreen.main.bounds
        let bottomLeftCorner = CGPoint(x: 0, y: screenBounds.height)
        let finalFrame = CGRect(origin: bottomLeftCorner, size: screenBounds.size)
        let tempFrame = CGRect(x: 0, y: 0, width: screenBounds.width, height: screenBounds.height)
        let dimView = UIView(frame: tempFrame)
        dimView.backgroundColor = .black
        dimView.layer.opacity = 0.4
        toVC.view.addSubview(dimView)
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveLinear, animations: {
            fromVC.view.frame = finalFrame
            dimView.layer.opacity = 0
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            dimView.removeFromSuperview()
        })
    }
}
