//
//  FirebaseManager.swift
//  ARFoodie
//
//  Created by Chen Yi-Wei on 2019/4/19.
//  Copyright © 2019 Chen Yi-Wei. All rights reserved.
//

import UIKit
import Firebase
import IHProgressHUD

class FirebaseManager {

    func fetchUserInfo() {

        IHProgressHUD.show()

        Auth.auth().addStateDidChangeListener { (_, user) in

            guard let user = user else {

                IHProgressHUD.dismiss()
                return

            }

            print("Triggerd")

            var currentUser = User.init(authData: user)

            let usersRef = Database.database().reference(withPath: "users")

            let currentUserRef = usersRef.child(user.uid)

            currentUserRef.observeSingleEvent(of: .value, with: { (snapshot) in

                DispatchQueue.main.async { [weak self] in

                    guard self != nil else { return }

                    guard
                        let info = snapshot.value as? [String: Any],
                        let displayName = info["displayName"] as? String,
                        let imgUID = info["profileImageUID"] as? String
                        else {

                            print("Failed to get current user info")
                            IHProgressHUD.dismiss()

                            return

                    }

                    currentUser.displayName = displayName

                    currentUser.profileImageUID = imgUID

                    CurrentUser.shared.user = currentUser

                    IHProgressHUD.dismiss()

                }

            })
        }

    }
}
