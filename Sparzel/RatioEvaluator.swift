//
//  RatioEvaluator.swift
//  Sparzel
//
//  Created by Artem Misesin on 1/20/17.
//  Copyright © 2017 Artem Misesin. All rights reserved.
//

import Foundation

class RatioEvaluator {
    
    func calculate(stack: CalculationStack, field: Int, pixelsField: Int) -> CalculationStack {
        var localStack = stack

        var result: Double

        if field < 2 {
            if pixelsField == 3 {
                result = stack.widthValue / stack.xValue * stack.yValue
            } else {
                result = stack.heightValue / stack.yValue * stack.xValue
            }
            localStack.setValue(result, for: pixelsField)
        } else {
            if field == 2 {
                result = stack.widthValue / stack.xValue * stack.yValue
            } else {
                result = stack.heightValue / stack.yValue * stack.xValue
            }

            localStack.setValue(result, for: CalculationStack.oppositeField(to: field))
        }

        return localStack
    }
    
    func fetchData() -> CalculationStack {
        return CalculationStack.fromUserDefaults
    }
    
}
