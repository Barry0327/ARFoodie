//
//  ErrorMessage.swift
//  ARFoodie
//
//  Created by Barry Chen on 2021/2/23.
//  Copyright © 2021 Chen Yi-Wei. All rights reserved.
//

import Foundation

struct ErrorMessage {
    let id: UUID
    let title: String
    let message: String

    init(title: String, message: String) {
        self.id = UUID()
        self.title = title
        self.message = message
    }
}
