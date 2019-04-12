//
//  UILabel+Point.swift
//  Aspetica
//
//  Created by Artem Misesin on 12/25/18.
//  Copyright © 2018 Artem Misesin. All rights reserved.
//

import UIKit

extension UILabel {
    override open func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let relativeFrame = self.bounds
        let hitTestEdgeInsets = UIEdgeInsets(top: -44, left: -44, bottom: -44, right: -44)
        let hitFrame = relativeFrame.inset(by: hitTestEdgeInsets)
        return hitFrame.contains(point)
    }
}
