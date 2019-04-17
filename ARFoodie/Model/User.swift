//
//  User.swift
//  ARFoodie
//
//  Created by Chen Yi-Wei on 2019/4/17.
//  Copyright © 2019 Chen Yi-Wei. All rights reserved.
//

import Foundation
import Firebase

struct CurrentUser {

    let uid: String
    let email: String
    var displayName: String = ""

    init(authData: Firebase.User) {

        self.uid = authData.uid
        self.email = authData.email!
    }

}
