//
//  BaseViewController.swift
//  Aspetica
//
//  Created by Artem Misesin on 4/12/19.
//  Copyright © 2019 Artem Misesin. All rights reserved.
//

import UIKit

protocol Themable: class {
    func applyTheme()
}

class BaseViewController: UIViewController, Themable {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applyTheme()
    }

    func applyTheme() {
        fatalError("applyTheme has not been implemented")
    }

}
