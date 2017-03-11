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
        if tapClose{
            return 0.3
        } else {
            return 1.5
        }
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
        let vc = fromVC as! SettingsViewController
        let vc2 = toVC as! ViewController
        dimView.backgroundColor = .black
        dimView.layer.opacity = 0.8
        toVC.view.addSubview(dimView)
        UIView.animate(withDuration: 0.02, animations: {
            vc.panImage.tintColor = ColorConstants.accessoryViewColor
            vc.panImage.layer.opacity = 1
            vc.navBarTitle.layer.opacity = 0
            vc.closeButton.layer.opacity = 0
        })
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveLinear, animations: {
            fromVC.view.frame = finalFrame
            dimView.layer.opacity = 0.01
            vc2.stopAnimation((vc2.activeTextField)!.tag - 1)
            vc2.roundedView.transform = CGAffineTransform.identity
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            dimView.removeFromSuperview()
            vc.panImage.layer.opacity = 0
            vc.navBarTitle.layer.opacity = 1
            vc.closeButton.layer.opacity = 1
            if vc2.secondTapDone{
                vc2.activeTextField?.backgroundColor = UIColor.clear
                vc2.animationIsOn[(vc2.activeTextField)!.tag - 1] = true
                vc2.fadeIn(index: (vc2.activeTextField)!.tag - 1)
            }

        })
//        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: 0, initialSpringVelocity: 0, options: [], animations: {
//            fromVC.view.frame = finalFrame
//        }, completion: {(finish) in })
    }
}
