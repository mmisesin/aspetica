//
//  RatioEvaluator.swift
//  Sparzel
//
//  Created by Artem Misesin on 1/20/17.
//  Copyright © 2017 Artem Misesin. All rights reserved.
//

import Foundation

class RatioEvaluator {
    
    func evaluate(values: (a: String, b: String, c: String, d: String), field: Int, pixelsField: Int) -> String {
        var result = 0.0
        if pixelsField == 3{
            if Double(values.a) != nil && Double(values.b) != nil && Double(values.c) != nil{
                result = Double(values.c)! / Double(values.a)! * Double(values.b)!
            } else {
                return "🏅"
            }
        } else {
            if Double(values.a) != nil && Double(values.b) != nil && Double(values.d) != nil {
            result = Double(values.d)! / Double(values.b)! * Double(values.a)!
            } else {
                return "🏅"
            }
        }
        if result > 999999 {
            return "🗿"
        }
        if roundedValues {
            var temp = forTailingZero(temp: result.roundTo(places: 0))
            temp = temp.replacingOccurrences(of: ".", with: "", options: NSString.CompareOptions.literal, range:nil)
            return temp
        } else {
            let temp = forTailingZero(temp: result.roundTo(places: 2))
            return temp
        }
    }
    
    func roundValues(a: String, b: String) ->(String, String){
        if let aValue = Double(a), let bValue = Double(b){
            let temp1 = forTailingZero(temp: aValue.roundTo(places: 0))
            let temp2 = forTailingZero(temp: bValue.roundTo(places: 0))
            return (temp1, temp2)
        } else {
            return ("1920", "1080")
        }
    }
    
    func evaluateRatio(values: (a: String, b: String, c: String, d: String), field: Int) -> (String?, String?) {
        var result = (0.0, 0.0)
            if Double(values.c) != nil && Double(values.d) != nil{
                result = gCD(of: Double(values.c)!, and: Double(values.d)!)
            } else {
                result = gCD(of: Double(values.c)!, and: Double(values.d)!)
            }
        let temp1: String? = forTailingZero(temp: (result.0).roundTo(places: 2))
        let temp2: String? = forTailingZero(temp: (result.1).roundTo(places: 2))
            return (temp1, temp2)
    }
    
    //taking care of zero
    func forTailingZero(temp: Double) -> String{
        return String(format: "%g", temp)
    }
    
    func fetchData() -> (a: String, b: String, c: String, d: String) {
        let defaults = UserDefaults.standard
        if let xValue = defaults.string(forKey: xFieldKey) {
            if let yValue = defaults.string(forKey: yFieldKey) {
                if let wValue = defaults.string(forKey: wFieldKey) {
                    if let hValue = defaults.string(forKey: hFieldKey) {
                        return (xValue, yValue, wValue, hValue)
                    }
                }
            }
        }
        return ("16", "9", "1920", "1080")
    }
    
    
    func gCD(of num1: Double, and num2: Double) -> (Double, Double) {
        var x = 1
        for i in 1...Int(max(num1, num2)) {
            if Int(num1) % i == 0, Int(num2) % i == 0{
                x = i
            }
        }
        let (temp1, temp2) = (num1 / Double(x), num2 / Double(x))
        return (temp1, temp2)
    }
}
