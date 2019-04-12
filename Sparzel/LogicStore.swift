//
//  LogicStore.swift
//  Aspetica
//
//  Created by Artem Misesin on 4/11/19.
//  Copyright © 2019 Artem Misesin. All rights reserved.
//

import Foundation

class LogicStore {

    var activeValue: ActiveValue = ActiveValue.default {
        didSet {
            switch activeValue {
            case .height, .width:
                ratioValue = activeValue
            default: break
            }
            previousActiveValue = oldValue

            if activeValue == previousActiveValue {
                secondTapDone = isClearValue ? true : !secondTapDone
            } else {
                secondTapDone = false
            }

            if activeValue != previousActiveValue {
                decimalPartStarted = false
                isClearValue = false
            }
        }
    }

    var previousActiveValue: ActiveValue?

    var ratioValue: ActiveValue = ActiveValue.default

    var secondTapDone: Bool = false

    var isClearValue: Bool = false

    var decimalPartStarted: Bool = false

}
