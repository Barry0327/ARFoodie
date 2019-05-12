//
//  DetailViewController+handlers.swift
//  ARFoodie
//
//  Created by Chen Yi-Wei on 2019/4/24.
//  Copyright © 2019 Chen Yi-Wei. All rights reserved.
//

import UIKit
import GoogleSignIn
import YTLiveStreaming

extension DetailViewController: GIDSignInDelegate, GIDSignInUIDelegate {

    @objc func handleKeyboardNotifiction(notifiction: Notification) {

        guard
            let keybroadFrame = notifiction.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
            else { return }

        let keyboardHeight = keybroadFrame.cgRectValue.height

        let isKeyboardShowing = notifiction.name == UIResponder.keyboardWillShowNotification

        self.view.frame.origin.y = isKeyboardShowing ? -keyboardHeight : 0

        UIView.animate(withDuration: 0.5) {

            self.view.layoutIfNeeded()

        }
    }

    @objc func tableViewTapped() {
        self.view.endEditing(true)
    }

    @objc func backToLastView() {
        self.dismiss(animated: true, completion: nil)
    }

    @objc func createBoardcast() {

        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.uiDelegate = self
        GIDSignIn.sharedInstance()?.scopes = [

            "https://www.googleapis.com/auth/youtube",
            "https://www.googleapis.com/auth/youtube.force-ssl"

        ]

        GIDSignIn.sharedInstance()?.signIn()
    }

    @objc func sendButtonTapped() {

        guard CurrentUser.shared.user != nil else {

            AuthenticationError.connetError.alert(message: "您尚未登入，請重新登入")

            return
        }
        print("Triggered")
        self.commentTextField.endEditing(true)
        self.commentTextField.isEnabled = false
        self.sendButton.isEnabled = false

        let restaurantRef = restaurantsRef.child(self.placeID)
        let commentRef = restaurantRef.child("comments")

        guard
            let name = CurrentUser.shared.user?.displayName,
            let uid = CurrentUser.shared.user?.uid,
            let content = self.commentTextField.text,
            content != ""
            else {

                self.commentTextField.isEnabled = true
                self.sendButton.isEnabled = true
                return

        }

        let comment = Comment.init(name: name, uid: uid, content: content)

        commentRef.childByAutoId().setValue(comment.toAnyObject()) { error, _ in

            if error != nil {
                print(error!)
            } else {

                print("send comment successfully")
                DispatchQueue.main.async { [weak self] in

                    self?.commentTextField.text = ""
                    self?.commentTextField.isEnabled = true
                    self?.sendButton.isEnabled = true
                }

                DispatchQueue.main.asyncAfter(deadline: .now()+0.5) { [weak self] in
                    self?.tableView.scrollToBottom()
                }
            }
        }
    }

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {

        guard let currentUser = GIDSignIn.sharedInstance()?.currentUser else {
            return
        }

        GoogleOAuth2.sharedInstance.accessToken = currentUser.authentication.accessToken

        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        if let createLiveBoardcastViewController = storyboard.instantiateViewController(withIdentifier: "CreateLiveBoardcastViewController") as? CreateLiveBoardcastViewController {

            createLiveBoardcastViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            DispatchQueue.main.async { [weak self] in

                guard let self = self else { return }

                self.present(createLiveBoardcastViewController, animated: true, completion: nil)

            }
        }
    }
}

extension DetailViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        self.sendButtonTapped()

        return false
    }

}
