//
//  RatioEvaluator.swift
//  Sparzel
//
//  Created by Artem Misesin on 1/20/17.
//  Copyright © 2017 Artem Misesin. All rights reserved.
//

import Foundation

class RatioEvaluator {
    func evaluate(values: (a: String, b: String, c: String, d: String), field: Int) -> String {
        var result = 0.0
        switch field{
        case 1, 2, 3:
            result = Double(values.c)! / Double(values.a)! * Double(values.b)!
        case 4:
            result = Double(values.d)! / Double(values.b)! * Double(values.a)!
        default: break
        }
        return forTailingZero(temp: result.roundTo(places: 2))
    }
    
    //taking care of zero
    func forTailingZero(temp: Double) -> String{
        return String(format: "%g", temp)
    }
}
