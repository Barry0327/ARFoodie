//
//  ErrorHandlers.swift
//  ARFoodie
//
//  Created by Chen Yi-Wei on 2019/4/21.
//  Copyright © 2019 Chen Yi-Wei. All rights reserved.
//

import UIKit
import StatusAlert

enum AuthenticationError: Error {

    case invalidInformation

    case connetError

}

extension AuthenticationError: CustomStringConvertible {

    var description: String {

        switch self {

        case .invalidInformation: return "資訊錯誤"

        case .connetError: return "連線錯誤"

        }
    }
}

extension Error {

    func alert(message: String = "") {

        let alert = StatusAlert()

        alert.title = "\(self)"
        alert.message = message
        alert.alertShowingDuration = 3

        alert.showInKeyWindow()
    }
}
