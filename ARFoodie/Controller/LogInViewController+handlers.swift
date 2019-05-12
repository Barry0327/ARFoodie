//
//  LogInViewController+handlers.swift
//  ARFoodie
//
//  Created by Chen Yi-Wei on 2019/5/2.
//  Copyright © 2019 Chen Yi-Wei. All rights reserved.
//

import Foundation
import Firebase
import IHProgressHUD

extension LogInViewController {

    @objc func performUserPolicyPage() {

        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)

        guard
            let userPrivacyVC = storyboard.instantiateViewController(
                withIdentifier: "UserPolicyViewController"
                ) as? UserPolicyViewController
            else { fatalError("Please check the ID for UserPolicyViewController")}

        let navigationCTL = UINavigationController(rootViewController: userPrivacyVC)

        self.present(navigationCTL, animated: true, completion: nil)
    }

    @objc func performPrivacyPolicyPage() {

        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)

        guard
            let userPrivacyVC = storyboard.instantiateViewController(
                withIdentifier: "PrivacyPolicyViewController"
                ) as? PrivacyPolicyViewController
            else { fatalError("Please check the ID for PrivacyPolicyViewController")}

        let navigationCTL = UINavigationController(rootViewController: userPrivacyVC)

        self.present(navigationCTL, animated: true, completion: nil)
    }

    @objc func loginBTNPressed() {

        guard
            let email = emailTextField.text,
            let password = passwordTextField.text,
            email.count > 0,
            password.count > 0
            else {

                AuthenticationError.invalidInformation.alert(message: "帳號或密碼有誤")
                return
        }

        IHProgressHUD.show()

        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in

            guard let self = self else { return }

            if let error = error {

                IHProgressHUD.dismiss()

                let alert = UIAlertController(title: "登入失敗",
                                              message: error.localizedDescription,
                                              preferredStyle: .alert)

                alert.addAction(UIAlertAction(title: "OK", style: .default))

                self.present(alert, animated: true, completion: nil)

            }

            guard let userID = result?.user.uid else {

                IHProgressHUD.dismiss()

                return

            }

            let currentUserRef = Database.database().reference(withPath: "users").child(userID)

            currentUserRef.observeSingleEvent(of: .value, with: { snapshot in

                guard
                    let info = snapshot.value as? [String: Any],
                    let displayName = info["displayName"] as? String,
                    let imgUID = info["profileImageUID"] as? String
                    else { return }

                var currentUser = User.init(uid: result!.user.uid, email: result!.user.email!)

                currentUser.displayName = displayName

                currentUser.profileImageUID = imgUID

                CurrentUser.shared.user = currentUser

            })
            IHProgressHUD.dismiss()

            self.performSegue(withIdentifier: "FinishLogin", sender: self)

        }

    }

    @objc func registerBTNPressed() {

        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        if let registerVC = storyboard.instantiateViewController(withIdentifier: "RegisterViewController") as? RegisterViewController {

            self.present(registerVC, animated: true, completion: nil)

        }

    }

    @objc func visitorBTNPressed() {

        self.performSegue(withIdentifier: "FinishLogin", sender: self)

    }
}

extension LogInViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        switch textField {

        case self.emailTextField:

            self.passwordTextField.becomeFirstResponder()

        default:

            self.loginBTNPressed()

        }

        return false
    }
}
