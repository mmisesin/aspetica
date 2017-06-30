//
//  PresentAnimator.swift
//  Aspetica
//
//  Created by Artem Misesin on 4/29/17.
//  Copyright © 2017 Artem Misesin. All rights reserved.
//

import UIKit

class PresentAnimator : NSObject {
}

extension PresentAnimator : UIViewControllerAnimatedTransitioning {
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
        //containerView.insertSubview(fromVC.view, belowSubview: toVC.view)
        containerView.addSubview(toVC.view)//insertSubview(toVC.view, aboveSubview: fromVC.view)
        let screenBounds = UIScreen.main.bounds
        let topLeftCorner = CGPoint(x: 0, y: 0)
        let bottomLeftCorner = CGPoint(x: 0, y: screenBounds.height)
        let startFrame = CGRect(origin: bottomLeftCorner, size: screenBounds.size)
        let finalFrame = CGRect(origin: topLeftCorner, size: screenBounds.size)
        let vc = fromVC as! ViewController
        let vc2 = toVC as! SettingsViewController
        print("KYS")
        let tempFrame = CGRect(x: 0, y: 0, width: vc.view.bounds.width, height: vc.view.bounds.height)
        vc.dimView = UIView(frame: tempFrame)
        vc.dimView.backgroundColor = .black
        vc.dimView.layer.opacity = 0
        vc.view.addSubview(vc.dimView)
        UIView.animate(withDuration: 0.5, animations: {
            vc.dimView.layer.opacity = 0.8
            vc.roundedView.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }, completion: nil)
        vc2.view.frame = startFrame
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveEaseOut, animations: {
            toVC.view.frame = finalFrame
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            
        })
    }
}
