//
//  ProfileViewController+handlers.swift
//  ARFoodie
//
//  Created by Chen Yi-Wei on 2019/4/19.
//  Copyright © 2019 Chen Yi-Wei. All rights reserved.
//

import UIKit
import Firebase
import IHProgressHUD
import GoogleSignIn
import YTLiveStreaming

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @objc func profileImageViewSelectHandler() {

        let picker = UIImagePickerController()

        picker.delegate = self

        picker.allowsEditing = true

        self.present(picker, animated: true, completion: nil)

    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {

        var selectImage: UIImage?

        if let editedImage = info[.editedImage] as? UIImage {

            selectImage = editedImage

        } else if let originalImage = info[.originalImage] as? UIImage {

            selectImage = originalImage

        }

        guard let user = self.currentUser else {

            print("No user!")

            return

        }

        self.profileImageView.image = selectImage

        let storageRef = Storage.storage().reference().child("profileImages")

        let imageUID = NSUUID.init().uuidString

        let imageRef = storageRef.child("\(imageUID).png")

        let data = self.profileImageView.image?.pngData()

        if let uploadData = data {

            imageRef.putData(uploadData, metadata: nil, completion: { (_, error) in

                if error != nil {

                    print(error!.localizedDescription)

                }

            })

            let usersRef = Database.database().reference().child("users")

            let userRef = usersRef.child(user.uid).child("profileImageUID")

            userRef.setValue(imageUID) { (error, _) in

                if error != nil {
                    print(error!.localizedDescription)
                }
            }
        }

        self.dismiss(animated: true, completion: nil)

    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {

        self.dismiss(animated: true, completion: nil)

    }

}

extension ProfileViewController: GIDSignInDelegate, GIDSignInUIDelegate {

    @objc func youtubeConnectHandler() {

        if GIDSignIn.sharedInstance()?.currentUser != nil {

            GIDSignIn.sharedInstance()?.signOut()

            self.youtubeConnectBTN.setTitle("連結Youtube帳戶", for: .normal)
            self.youtubeAccountLabel.text = "無連結帳號"

        } else {

            GIDSignIn.sharedInstance()?.delegate = self
            GIDSignIn.sharedInstance()?.uiDelegate = self

            GIDSignIn.sharedInstance()?.scopes = [

                "https://www.googleapis.com/auth/youtube",
                "https://www.googleapis.com/auth/youtube.force-ssl"

            ]

            GIDSignIn.sharedInstance()?.signIn()

        }

    }

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {

        guard let currentUser = GIDSignIn.sharedInstance()?.currentUser else {
            return
        }

        GoogleOAuth2.sharedInstance.accessToken = currentUser.authentication.accessToken

        self.youtubeConnectBTN.setTitle("解除連結", for: .normal)
        self.youtubeAccountLabel.text = currentUser.profile.email

    }

    func checkYoutubeConnectState() {

        if let currentUser = GIDSignIn.sharedInstance()?.currentUser {

            self.youtubeAccountLabel.text = currentUser.profile.email
            self.youtubeConnectBTN.setTitle("解除連結", for: .normal)
            self.youtubeConnectBTN.widthAnchor.constraint(equalToConstant: 70).isActive = true
            self.bottomContainerView.layoutIfNeeded()

        } else {

            self.youtubeAccountLabel.text = "無連結帳號"
            self.youtubeConnectBTN.setTitle("連結Youtube帳戶", for: .normal)

        }
    }
}
