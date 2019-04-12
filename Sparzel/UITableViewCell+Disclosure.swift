//
//  UITableViewCell+Disclosure.swift
//  Aspetica
//
//  Created by Artem Misesin on 12/25/18.
//  Copyright © 2018 Artem Misesin. All rights reserved.
//

import UIKit

extension UITableViewCell {
    func prepareDisclosureIndicator() {
        for case let button as UIButton in subviews {
            let image = button.backgroundImage(for: .normal)?.withRenderingMode(.alwaysTemplate)
            button.setBackgroundImage(image, for: .normal)
            button.tintColor = Color.accessoryViewColor
        }
    }
}
