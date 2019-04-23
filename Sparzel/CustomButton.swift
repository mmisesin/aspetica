//
//  CustomButton.swift
//  Aspetica
//
//  Created by Artem Misesin on 12/25/18.
//  Copyright © 2018 Artem Misesin. All rights reserved.
//

import UIKit

class CustomButton: UIButton, Themable {

    init(symbol: String) {
        super.init(frame: .zero)

        setTitle(symbol, for: .normal)
        layer.borderWidth = 0.5
        titleLabel?.font = .systemFont(ofSize: 28)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        addTarget(self, action: #selector(touchDown), for: .touchDown)
        addTarget(self, action: #selector(dragAway), for: .touchDragOutside)
    }

    @objc func touchDown() {
        backgroundColor = Color.pressedButtonColor
        setTitleColor(Color.pressedButtonTextColor, for: .normal)
        layer.borderColor = Color.pressedButtonBorder.cgColor
    }

    @objc func dragAway() {
        backgroundColor = Color.defaultButtonBackground
        setTitleColor(Color.mainTextColor, for: .normal)
        layer.borderColor = Color.buttonBorder.cgColor
    }

    func applyTheme() {
        backgroundColor = Color.defaultButtonBackground
        layer.borderColor = Color.buttonBorder.cgColor
        tintColor = Color.deleteIconColor
        setTitleColor(Color.mainTextColor, for: .normal)
    }
    
}
