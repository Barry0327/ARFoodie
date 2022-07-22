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
        guard
            let filePath = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist"),
            let plist = NSDictionary(contentsOfFile: filePath),
            let apiKey = plist.object(forKey: "API_KEY") as? String
        else { return "" }

        return apiKey
    }()
}
