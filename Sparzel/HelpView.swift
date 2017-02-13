//
//  HelpRect.swift
//  Sparzel
//
//  Created by Artem Misesin on 2/12/17.
//  Copyright © 2017 Artem Misesin. All rights reserved.
//

import UIKit

class HelpView: UIView {

    var width: CGFloat = 79
    var height: CGFloat = 28
    var y: CGFloat = 10
    var x: CGFloat = 10
    var triangleWidth: CGFloat = 3
    var textLabel: String = "Help"
    
    override func draw(_ rect: CGRect) {
        let helpView = UIView(frame: CGRect(x: width/2 - width/4, y: y, width: width, height: height))
        helpView.layer.cornerRadius = 8
        helpView.backgroundColor = ColorConstants.helpColor
        self.addSubview(helpView)
        let triangle = UIBezierPath()
        triangle.lineWidth = 0.1
        triangle.move(to: CGPoint(x: helpView.bounds.midX - 3, y: helpView.bounds.maxY))
        triangle.addLine(to: CGPoint(x: helpView.bounds.midX, y: helpView.bounds.maxX + triangleWidth/2))
        triangle.addLine(to: CGPoint(x: helpView.bounds.midX + 3, y: helpView.bounds.maxY))
        ColorConstants.helpColor.setFill()
        ColorConstants.helpColor.setStroke()
        triangle.fill()
        triangle.stroke()
//        let helpLabel = UILabel(frame: CGRect(x: helpView.bounds.minX, y: helpView.bounds.minY, width: helpView.bounds.width, height: helpView.bounds.height))
//        helpLabel.textAlignment = .center
//        helpLabel.text = textLabel
//        helpLabel.textColor = ColorConstants.mainTint
//        helpLabel.font = helpLabel.font.withSize(12)
//        helpView.addSubview(helpLabel)
    }

}
