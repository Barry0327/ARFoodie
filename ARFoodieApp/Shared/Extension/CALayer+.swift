//
//  CALayer+.swift
//  ARFoodie
//
//  Created by Barry Chen on 2021/4/7.
//  Copyright © 2021 Chen Yi-Wei. All rights reserved.
//

import UIKit

extension CALayer {
    func applySketchShadow(
        color: UIColor = .black,
        alpha: Float = 0.5,
        xPosition: CGFloat = 0,
        yPosition: CGFloat = 2,
        blur: CGFloat = 4,
        spread: CGFloat = 0) {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: xPosition, height: yPosition)
        shadowRadius = blur / 2.0
        if spread == 0 {
            shadowPath = nil
        } else {
            let dxValue = -spread
            let rect = bounds.insetBy(dx: dxValue, dy: dxValue)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
}
