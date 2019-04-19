//
//  RegisterViewController + handlers.swift
//  ARFoodie
//
//  Created by Chen Yi-Wei on 2019/4/18.
//  Copyright © 2019 Chen Yi-Wei. All rights reserved.
//

import UIKit
import Firebase
import IHProgressHUD

extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

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

        self.profileImgView.image = selectImage
        self.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Did cancel picker view")
        self.dismiss(animated: true, completion: nil)
    }

    @objc func registerPressed() {

        IHProgressHUD.show(withStatus: "連線中..")

        guard
            let email = emailTextField.text,
            let password = passwordTextField.text,
            emailTextField.text != "",
            passwordTextField.text != ""
            else {
                IHProgressHUD.dismiss()
                return
        }

        guard passwordTextField.text == confirmTextField.text else {

            IHProgressHUD.dismiss()

            return
        }

        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in

            if error != nil {

                print(error!.localizedDescription)

                IHProgressHUD.dismiss()

                return
            }

            guard let user = result?.user else {

                IHProgressHUD.dismiss()

                return

            }

            let storageRef = Storage.storage().reference().child("profileImages")

            let imageRef = storageRef.child("\(user.uid).png")

            let data = self.profileImgView.image?.pngData()

            if let uploadData = data {

                imageRef.putData(uploadData, metadata: nil, completion: { (_, error) in

                    if error != nil {

                        IHProgressHUD.dismiss()

                        print(error!.localizedDescription)
                    }

                    let displayName = self.nameTextField.text ?? ""

                    let user = User.init(uid: user.uid, email: email, displayName: displayName)
                    let value = user.toAnyObject()

                    self.registerUserIntoDatabase(uid: user.uid, value: value)
                })
            }
        }

    }
    private func registerUserIntoDatabase(uid: String, value: Any) {

        let userRef = Database.database().reference(withPath: "users")

        userRef.child(uid).setValue(value)

        self.nameTextField.text = nil
        self.emailTextField.text = nil
        self.passwordTextField.text = nil
        self.confirmTextField.text = nil

        IHProgressHUD.dismiss()

        self.performSegue(withIdentifier: "FinishRegister", sender: nil)

    }
    @objc func cancelBTNPressed() {

        self.dismiss(animated: true, completion: nil)

    }
}
