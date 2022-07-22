//
//  String+.swift
//  ARFoodie
//
//  Created by Barry Chen on 2021/4/7.
//  Copyright © 2021 Chen Yi-Wei. All rights reserved.
//

import Foundation

extension String {
    var digits: String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined()
    }
}
