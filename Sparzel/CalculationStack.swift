//
//  CalculationStack.swift
//  Aspetica
//
//  Created by Artem Misesin on 12/29/18.
//  Copyright © 2018 Artem Misesin. All rights reserved.
//

import Foundation

struct CalculationStack {
    
    var xValue: Double
    var yValue: Double
    var widthValue: Double
    var heightValue: Double

    mutating func setValue(_ value: Double, for index: Int) {
        switch index {
        case 0:
            xValue = value
        case 1:
            yValue = value
        case 2:
            widthValue = value
        default:
            heightValue = value
        }
    }

    func getValue(for index: Int) -> Double {
        switch index {
        case 0:
            return xValue
        case 1:
            return yValue
        case 2:
            return widthValue
        default:
            return heightValue
        }
    }
    
    static var fromUserDefaults: CalculationStack {
        return CalculationStack(xValue: UserDefaultsManager.xValue,
                                yValue: UserDefaultsManager.yValue,
                                widthValue: UserDefaultsManager.widthValue,
                                heightValue: UserDefaultsManager.heightValue)
    }
    
    static var `default`: CalculationStack {
        return CalculationStack(xValue: 16,
                                yValue: 9,
                                widthValue: 1920,
                                heightValue: 1080)
    }

    static func oppositeField(to field: Int) -> Int {
        switch field {
        case 0:
            return 1
        case 1:
            return 0
        case 2:
            return 3
        default:
            return 2
        }
    }
    
}
