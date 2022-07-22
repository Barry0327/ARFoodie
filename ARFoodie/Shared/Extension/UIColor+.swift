//
//  UIColor+.swift
//  ARFoodie
//
//  Created by Barry Chen on 2021/4/7.
//  Copyright © 2021 Chen Yi-Wei. All rights reserved.
//

import UIKit

extension UIColor {

    // swiftlint:disable all
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: a)

    }
    // swiftlint:enable all
}
