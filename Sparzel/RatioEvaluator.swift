//
//  RatioEvaluator.swift
//  Sparzel
//
//  Created by Artem Misesin on 1/20/17.
//  Copyright © 2017 Artem Misesin. All rights reserved.
//

import Foundation

class RatioEvaluator {
    func evaluate(tappedValue: String, _ xValue: String, _ yValue: String, reversed: Bool) -> String {
        if !reversed {
            let result = Double(xValue)! / Double(yValue)! *
            Double(tappedValue)!
            return forTailingZero(temp: result)
        } else {
            let result = Double(tappedValue)! / Double(xValue)! *
                Double(yValue)!
            return forTailingZero(temp: result)
        }
    }
    
    //taking care of zero
    func forTailingZero(temp: Double) -> String{
        return String(format: "%g", temp)
    }
}
