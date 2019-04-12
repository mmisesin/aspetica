//
//  CustomButton.swift
//  Aspetica
//
//  Created by Artem Misesin on 12/25/18.
//  Copyright © 2018 Artem Misesin. All rights reserved.
//

import UIKit

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

    override func awakeFromNib() {
        super.awakeFromNib()
        addTarget(self, action: #selector(touchDown), for: .touchDown)
        addTarget(self, action: #selector(dragAway), for: .touchDragOutside)
    }

    @objc func touchDown() {
        backgroundColor = Color.pressedButtonColor
        setTitleColor(Color.pressedButtonTextColor, for: .normal)
        borderColor = Color.pressedButtonBorder
    }

    @objc func dragAway() {
        backgroundColor = Color.defaultButtonBackground
        setTitleColor(Color.mainTextColor, for: .normal)
        borderColor = Color.buttonBorder
    }
    
}
