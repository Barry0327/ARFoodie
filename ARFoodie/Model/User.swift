//
//  User.swift
//  ARFoodie
//
//  Created by Chen Yi-Wei on 2019/4/17.
//  Copyright © 2019 Chen Yi-Wei. All rights reserved.
//

import Foundation
import Firebase

struct User {

    let uid: String
    let email: String
    var displayName: String = ""

    init(uid: String, email: String, displayName: String) {

        self.uid = uid
        self.email = email
        self.displayName = displayName
    }

    init(authData: Firebase.User) {

        self.uid = authData.uid
        self.email = authData.email!
    }

    func toAnyObject() -> Any {
        return [
            "email": self.email,
            "displayName": self.displayName
        ]
    }

}
