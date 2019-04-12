//
//  ValueProcessor.swift
//  Aspetica
//
//  Created by Artem Misesin on 1/27/19.
//  Copyright © 2019 Artem Misesin. All rights reserved.
//

import Foundation

class ValueProcessor {

    func addDigit(_ digit: Int, to value: String) -> Double {
        guard let doubleValue = Double(value) else { return 1 }
        guard
            value.replacingOccurrences(of: ".", with: "").count < 6,
            let newDoubleValue = Double(value + "\(digit)")
        else { return doubleValue }
        return newDoubleValue
    }

    func removeLastDigit(from value: String) -> Double {
        var localValue = value
        localValue.removeLast()
        if let last = localValue.last, last == "." {
            localValue.removeLast()
        }

        return localValue.isEmpty ? 1 : Double(localValue) ?? 1
    }
    
}
