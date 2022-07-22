//
//  Secrets.swift
//  ARFoodie
//
//  Created by Barry Chen on 2021/4/7.
//  Copyright © 2021 Chen Yi-Wei. All rights reserved.
//

import Foundation

struct Secrets {
    static let apiKey: String = {
        if let key = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String {
            return key
        }
        return ""
    }()
}
