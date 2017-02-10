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
        if Double(values.a) != nil && Double(values.b) != nil && Double(values.c) != nil && Double(values.d) != nil {
        if pixelsField == 3{
            result = Double(values.c)! / Double(values.a)! * Double(values.b)!
        } else {
            result = Double(values.d)! / Double(values.b)! * Double(values.a)!
        }
        if roundedValues {
            var temp = forTailingZero(temp: result.roundTo(places: 0))
            temp = temp.replacingOccurrences(of: ".", with: "", options: NSString.CompareOptions.literal, range:nil)
            return temp
        } else {
            var temp = forTailingZero(temp: result.roundTo(places: 2))
            //temp = remove(from: temp)
            return temp
        }
        } else {
            return "🏅"
        }
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
                        print((xValue, yValue, wValue, hValue))
                        return (xValue, yValue, wValue, hValue)
                    }
                }
            }
        }
        return ("16", "9", "1920", "1080")
    }
    
//    private func remove(from: String) -> String{
//        var counter = 0
//        var tempStr = from
//        for symbol in from.characters {
//            if symbol == "."{
//                break
//            } else {
//                counter = counter + 1
//                if counter > 6 {
//                    return from
//                }
//            }
//        }
//        if counter == 0{
//            return from
//        }
//        print(tempStr)
//        print(counter)
//        let sym = tempStr.remove(at: from.index(from.startIndex, offsetBy: counter - 1))
//        return tempStr
//    }

}
