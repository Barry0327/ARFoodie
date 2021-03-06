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

        guard
            let email = emailTextField.text,
            let password = passwordTextField.text,
            emailTextField.text != "",
            passwordTextField.text != "",
            password.count >= 6
            else {

                return AuthenticationError.invalidInformation.alert(message: "請確認email及密碼資訊是否正確(密碼必須大於6個字元)")
        }

        guard passwordTextField.text == confirmTextField.text else {

            return AuthenticationError.invalidInformation.alert(message: "請再次確認密碼是否正確")

        }

        IHProgressHUD.show(withStatus: "連線中...")

        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in

            if error != nil {

                IHProgressHUD.dismiss()

                AuthenticationError.invalidInformation.alert(message: error!.localizedDescription)

                return
            }

            guard let user = result?.user else {

                IHProgressHUD.dismiss()

                return

            }

            let storageRef = Storage.storage().reference().child("profileImages")

            let imgName = NSUUID.init().uuidString

            let imageRef = storageRef.child("\(imgName).png")

            let data = self.profileImgView.image?.pngData()

            if let uploadData = data {

                imageRef.putData(uploadData, metadata: nil, completion: { (_, error) in

                    if error != nil {

                        IHProgressHUD.dismiss()

                        print(error!.localizedDescription)
                    }

                    let displayName = self.nameTextField.text ?? ""

                    var user = User.init(uid: user.uid, email: email, displayName: displayName)

                    user.profileImageUID = imgName

                    let value = user.toAnyObject()

                    CurrentUser.shared.user = user

                    self.registerUserIntoDatabase(uid: user.uid, value: value)

                })
            }
        }

    }

    private func registerUserIntoDatabase(uid: String, value: Any) {

        let userRef = Database.database().reference(withPath: "users")

        userRef.child(uid).setValue(value) { (error, _) in

            if error != nil {
                print("Failed to save user data")
            }

            self.nameTextField.text = nil
            self.emailTextField.text = nil
            self.passwordTextField.text = nil
            self.confirmTextField.text = nil

            IHProgressHUD.dismiss()

            DispatchQueue.main.async { [weak self] in

                guard let self = self else { return }

                self.performSegue(withIdentifier: "FinishRegister", sender: nil)

            }
        }

    }

    @objc func cancelBTNPressed() {

        self.dismiss(animated: true, completion: nil)

    }
}

extension RegisterViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        switch textField {

        case self.nameTextField:

            self.emailTextField.becomeFirstResponder()

        case self.emailTextField:

            self.passwordTextField.becomeFirstResponder()

        case self.passwordTextField:

            self.confirmTextField.becomeFirstResponder()

        default:
            self.registerPressed()
        }

        return false
    }
}
