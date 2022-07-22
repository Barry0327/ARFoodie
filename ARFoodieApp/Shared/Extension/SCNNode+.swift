//
//  SCNNode+.swift
//  ARFoodie
//
//  Created by Barry Chen on 2021/4/7.
//  Copyright © 2021 Chen Yi-Wei. All rights reserved.
//

import Foundation
import ARKit

extension SCNNode {
    // This solved flickering issue.
    func renderOnTop() {
        self.renderingOrder = 2
        if let geom = self.geometry {
            for material in geom.materials {
                material.readsFromDepthBuffer = false
            }
        }
        for child in self.childNodes {
            child.renderOnTop()
        }
    }
}
