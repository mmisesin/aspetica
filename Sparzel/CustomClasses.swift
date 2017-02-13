//
//  CustomButton.swift
//  ratio
//
//  Created by Artem Misesin on 1/18/17.
//  Copyright © 2017 Artem Misesin. All rights reserved.
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
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
    
    override public var intrinsicContentSize: CGSize
    {
        var intrinsicSuperViewContentSize = super.intrinsicContentSize
        intrinsicSuperViewContentSize.height += topInset + bottomInset
        intrinsicSuperViewContentSize.width += leftInset + rightInset
        return intrinsicSuperViewContentSize
    }
}

class CustomButton: UIButton {
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = CGFloat(borderWidth)
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
    
}

class TriangleView : UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        context.beginPath()
        context.move(to: CGPoint(x: rect.minX, y: rect.minY))
        context.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        context.addLine(to: CGPoint(x: (rect.maxX / 2.0), y: rect.maxY))
        context.closePath()
        
        context.setFillColor(ColorConstants.helpColor.cgColor)
        context.fillPath()
    }
}

