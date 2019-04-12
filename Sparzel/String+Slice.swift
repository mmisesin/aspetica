//
//  String+Slice.swift
//  Aspetica
//
//  Created by Artem Misesin on 12/25/18.
//  Copyright © 2018 Artem Misesin. All rights reserved.
//

import Foundation

extension String {
    mutating func stripFromCharacter(char:String) {
        if var ix = self.index(of: ".") {
            ix = self.index(after: ix)
            self = String(self.suffix(from: ix))
        }
    }
}
