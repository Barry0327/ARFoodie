//
//  SignUpViewController.swift
//  ARFoodie
//
//  Created by Chen Yi-Wei on 2019/4/7.
//  Copyright © 2019 Chen Yi-Wei. All rights reserved.
//

import UIKit
import IHProgressHUD
import Firebase

class SignUpViewController: UIViewController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    lazy var profileImgView: UIImageView = {

        let imgView = UIImageView()
        imgView.tintColor = UIColor(hexString: "fff4e1")
        imgView.image = UIImage(named: "user")
        imgView.layer.cornerRadius = 125/2
        imgView.layer.borderWidth = 1
        imgView.layer.borderColor = UIColor(hexString: "fff4e1")?.cgColor
        imgView.isUserInteractionEnabled = true
        imgView.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(profileImageViewSelectHandler)
            )
        )
        imgView.clipsToBounds = true

        return imgView
    }()

    let containerView: UIView = {

        let view = UIView()

        return view
    }()

    let nameLabel: UILabel = {

        let label = UILabel()
        let textAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: UIColor(hexString: "fff4e1")!
        ]
        let attributeString = NSAttributedString(string: "用戶名稱", attributes: textAttributes)
        label.attributedText = attributeString

        return label
    }()

    let nameTextField: UITextField = {

        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(
            string: "輸入名稱",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(hexString: "#BBC4C2")!]
        )
        textField.textAlignment = .center
        textField.textColor = UIColor(hexString: "E4DAD8")
        textField.tintColor = UIColor(hexString: "E4DAD8")

        return textField
    }()

    let nameSeparator: UIView = {

        let view = UIView()
        view.backgroundColor = UIColor(hexString: "fff4e1")

        return view
    }()

    let emailLabel: UILabel = {

        let label = UILabel()
        let textAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: UIColor(hexString: "fff4e1")!
        ]
        let attributeString = NSAttributedString(string: "登入帳號", attributes: textAttributes)
        label.attributedText = attributeString

        return label
    }()

    let emailTextField: UITextField = {

        let textField = UITextField()
        textField.textAlignment = .center
        textField.attributedPlaceholder = NSAttributedString(
            string: "輸入電子郵件",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(hexString: "#BBC4C2")!]
        )
        textField.textColor = UIColor(hexString: "E4DAD8")
        textField.tintColor = UIColor(hexString: "E4DAD8")

        return textField
    }()

    let emailSeparator: UIView = {

        let view = UIView()
        view.backgroundColor = UIColor(hexString: "fff4e1")

        return view
    }()

    let passwordLabel: UILabel = {

        let label = UILabel()
        let textAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: UIColor(hexString: "fff4e1")!
        ]
        let attributeString = NSAttributedString(string: "登入密碼", attributes: textAttributes)
        label.attributedText = attributeString

        return label
    }()

    let passwordTextField: UITextField = {

        let textField = UITextField()
        textField.textAlignment = .center
        textField.attributedPlaceholder = NSAttributedString(
            string: "輸入密碼",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(hexString: "#BBC4C2")!]
        )
        textField.isSecureTextEntry = true
        textField.textColor = UIColor(hexString: "E4DAD8")
        textField.tintColor = UIColor(hexString: "E4DAD8")

        return textField
    }()

    let passwordSeparator: UIView = {

        let view = UIView()
        view.backgroundColor = UIColor(hexString: "fff4e1")

        return view
    }()

    let confirmLabel: UILabel = {

        let label = UILabel()
        let textAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: UIColor(hexString: "fff4e1")!
        ]
        let attributeString = NSAttributedString(string: "確認密碼", attributes: textAttributes)
        label.attributedText = attributeString

        return label
    }()

    let confirmTextField: UITextField = {

        let textField = UITextField()
        textField.textAlignment = .center
        textField.attributedPlaceholder = NSAttributedString(
            string: "再次輸入密碼",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(hexString: "#BBC4C2")!]
        )
        textField.isSecureTextEntry = true
        textField.textColor = UIColor(hexString: "E4DAD8")
        textField.tintColor = UIColor(hexString: "E4DAD8")

        return textField
    }()

    let confirmSeparator: UIView = {

        let view = UIView()
        view.backgroundColor = UIColor(hexString: "fff4e1")

        return view
    }()

    let cancelButton: UIButton = {

        let button = UIButton()
        button.backgroundColor = .clear
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor(hexString: "fff4e1")?.cgColor
        button.layer.cornerRadius = 22
        let textAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: UIColor(hexString: "fff4e1")!,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 25, weight: .bold)
        ]
        let attributeString = NSAttributedString(string: "取消", attributes: textAttributes)
        button.setAttributedTitle(attributeString, for: .normal)
        button.addTarget(self, action: #selector(cancelBTNPressed), for: .touchUpInside)

        return button
    }()

    let registerButton: UIButton = {

        let button = UIButton()
        button.backgroundColor = UIColor(hexString: "fff4e1")
        button.layer.cornerRadius = 22
        let textAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: UIColor.flatWatermelonDark(),
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 25, weight: .bold)
        ]
        let attributeString = NSAttributedString(string: "註冊", attributes: textAttributes)
        button.setAttributedTitle(attributeString, for: .normal)
        button.addTarget(self, action: #selector(registerPressed), for: .touchUpInside)

        return button
    }()

    // swiftlint:disable force_cast
    private var rootView: SignUpRootView {
        view as! SignUpRootView
    }
    // swiftlint:enable force_cast

    // MARK: - View Life Cycle
    override func loadView() {
        super.loadView()
        view = SignUpRootView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.nameTextField.delegate = self
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        self.confirmTextField.delegate = self

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillShow(notifiction:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillHide(notificiton:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )

        self.hideKeyboardWhenTappedAround()

        view.backgroundColor = UIColor.flatWatermelonDark()
    }

    deinit {
        print("Register deinit")
    }
}

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

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

extension SignUpViewController: UITextFieldDelegate {

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
