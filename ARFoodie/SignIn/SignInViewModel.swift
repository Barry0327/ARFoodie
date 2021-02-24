//
//  SignInViewModel.swift
//  ARFoodie
//
//  Created by Barry Chen on 2021/2/23.
//  Copyright © 2021 Chen Yi-Wei. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay
import Firebase

class SignInViewModel {
    let email: BehaviorRelay<String> = BehaviorRelay.init(value: "")
    let password: BehaviorRelay<String> = BehaviorRelay.init(value: "")

    let signInActivityIndicatorAnimating: PublishRelay<Bool> = PublishRelay.init()
    let errorMessage: PublishRelay<ErrorMessage> = PublishRelay.init()
    let signInView: PublishRelay<SignInView> = PublishRelay.init()

    @objc
    func signIn() {
        signInActivityIndicatorAnimating.accept(true)
        Auth.auth().signIn(
            withEmail: email.value,
            password: password.value) { [weak self] result, error in
            guard let self = self else { return }
            self.signInActivityIndicatorAnimating.accept(false)

            guard error == nil else {
                let message = ErrorMessage(title: "登入失敗", message: error!.localizedDescription)
                self.errorMessage.accept(message)
                return
            }

            guard let userID = result?.user.uid else {
                return
            }

            let currentUserRef = Database.database().reference(withPath: "users").child(userID)

            currentUserRef.observeSingleEvent(of: .value, with: { snapshot in
                guard
                    let info = snapshot.value as? [String: Any],
                    let displayName = info["displayName"] as? String,
                    let imgUID = info["profileImageUID"] as? String
                    else { return }

                var currentUser = User.init(authData: result!.user)
                currentUser.displayName = displayName
                currentUser.profileImageUID = imgUID
                CurrentUser.shared.user = currentUser
            })
            self.signInView.accept(.main)
        }
    }

    @objc func showUserPrivacy() {
        signInView.accept(.userPrivacy)
    }

    @objc func showUserPolicy() {
        signInView.accept(.userPolicy)
    }
}
