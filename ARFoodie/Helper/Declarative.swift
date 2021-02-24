//
//  Declarative.swift
//  ARFoodie
//
//  Created by Barry Chen on 2021/2/24.
//  Copyright © 2021 Chen Yi-Wei. All rights reserved.
//

import Foundation

protocol Declarative: AnyObject {
    init()
}

extension Declarative {
    init(configureHandler: (Self) -> Void) {
        self.init()
        configureHandler(self)
    }
}

extension NSObject: Declarative { }
