//
//  DismissalDelegate.swift
//  ratio
//
//  Created by Artem Misesin on 1/19/17.
//  Copyright © 2017 Artem Misesin. All rights reserved.
//

import UIKit

protocol DismissalDelegate : class
{
    func finishedShowing(viewController: UIViewController);
}

protocol Dismissable : class
{
    var dismissalDelegate : DismissalDelegate? { get set }
}

extension DismissalDelegate where Self: UIViewController
{
    func finishedShowing(viewController: UIViewController) {
        self.dismiss(animated: true, completion: nil)
        return
    }
}

