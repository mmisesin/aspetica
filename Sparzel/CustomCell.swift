//
//  CustomCell.swift
//  Aspetica
//
//  Created by Artem Misesin on 12/25/18.
//  Copyright © 2018 Artem Misesin. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if highlighted {
            self.backgroundColor = Color.onTapColor
        } else {
            self.backgroundColor = .clear
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        if selected {
            self.backgroundColor = Color.onTapColor
        } else {
            self.backgroundColor = .clear
        }
    }
}
