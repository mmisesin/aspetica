//
//  IconButton.swift
//  Aspetica
//
//  Created by Artem Misesin on 4/11/19.
//  Copyright © 2019 Artem Misesin. All rights reserved.
//

import UIKit

class IconButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.tintColor = Color.iconsColor
        addTarget(self, action: #selector(touchDown), for: .touchDown)
        addTarget(self, action: #selector(dragAway), for: .touchDragOutside)
        addTarget(self, action: #selector(touchUp), for: .touchUpInside)
    }

    @objc func touchDown() {
        layer.opacity = 0.4
    }

    @objc func dragAway() {
        layer.opacity = 1
    }

    @objc func touchUp() {
        layer.opacity = 1
    }

}
