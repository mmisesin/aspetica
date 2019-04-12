//
//  InsetLabel.swift
//  Aspetica
//
//  Created by Artem Misesin on 12/25/18.
//  Copyright © 2018 Artem Misesin. All rights reserved.
//

import UIKit

class InsetLabel: UILabel
{
    let topInset = CGFloat(0)
    let bottomInset = CGFloat(0)
    let leftInset = CGFloat(4)
    let rightInset = CGFloat(4)
    
    override func drawText(in rect: CGRect)
    {
        let insets: UIEdgeInsets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }
    
    override public var intrinsicContentSize: CGSize
    {
        var intrinsicSuperViewContentSize = super.intrinsicContentSize
        intrinsicSuperViewContentSize.height += topInset + bottomInset
        intrinsicSuperViewContentSize.width += leftInset + rightInset
        return intrinsicSuperViewContentSize
    }
}
