//
//  FirebaseManager.swift
//  ARFoodie
//
//  Created by Chen Yi-Wei on 2019/4/19.
//  Copyright © 2019 Chen Yi-Wei. All rights reserved.
//

import UIKit
import Firebase

class FirebaseManager {

    static let shared = FirebaseManager()

    func fetchUserInfo(user: Firebase.User?) {

        guard let user = user else { return }

        print("triggerd")

        var currentUser = User.init(authData: user)

        let usersRef = Database.database().reference(withPath: "users")

        let currentUserRef = usersRef.child(user.uid)

        currentUserRef.observeSingleEvent(of: .value, with: { (snapshot) in

            guard
                let info = snapshot.value as? [String: Any],
                let displayName = info["displayName"] as? String
                else { return }

            currentUser.displayName = displayName

            CurrentUser.shared.user = currentUser

        })

    }
}
