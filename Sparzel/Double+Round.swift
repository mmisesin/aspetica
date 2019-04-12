//
//  Double+Round.swift
//  Aspetica
//
//  Created by Artem Misesin on 12/25/18.
//  Copyright © 2018 Artem Misesin. All rights reserved.
//

import Foundation

extension Double {
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
