//
//  RegisterViewController.swift
//  ARFoodie
//
//  Created by Chen Yi-Wei on 2019/4/7.
//  Copyright © 2019 Chen Yi-Wei. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    let profileImgView: UIImageView = {

        let imgView = UIImageView()
        imgView.backgroundColor = .blue

        return imgView
    }()

    let containerView: UIView = {

        let view = UIView()
        view.backgroundColor = .red

        return view
    }()

    let nameLabel: UILabel = {

        let label = UILabel()
        label.text = "使用者名稱"

        return label
    }()

    let nameTextField: UITextField = {

        let textField = UITextField()
        textField.placeholder = "輸入名稱"
        textField.textAlignment = .center

        return textField
    }()

    let nameSeparator: UIView = {

        let view = UIView()
        view.backgroundColor = .black

        return view
    }()

    let emailLabel: UILabel = {

        let label = UILabel()
        label.text = "登入帳號"

        return label
    }()

    let emailTextField: UITextField = {

        let textField = UITextField()
        textField.textAlignment = .center
        textField.placeholder = "輸入電子郵件"

        return textField
    }()

    let emailSeparator: UIView = {

        let view = UIView()
        view.backgroundColor = .black

        return view
    }()

    let passwordLabel: UILabel = {

        let label = UILabel()
        label.text = "登入密碼"

        return label
    }()

    let passwordTextField: UITextField = {

        let textField = UITextField()
        textField.textAlignment = .center
        textField.placeholder = "輸入密碼"
        textField.isSecureTextEntry = true

        return textField
    }()

    let passwordSeparator: UIView = {

        let view = UIView()
        view.backgroundColor = .black

        return view
    }()

    let confirmLabel: UILabel = {

        let label = UILabel()
        label.text = "確認密碼"

        return label
    }()

    let confirmTextField: UITextField = {

        let textField = UITextField()
        textField.textAlignment = .center
        textField.placeholder = "再次輸入密碼"
        textField.isSecureTextEntry = true

        return textField
    }()

    let confirmSeparator: UIView = {

        let view = UIView()
        view.backgroundColor = .black

        return view
    }()

    let cancelButton: UIButton = {

        let button = UIButton()
        button.backgroundColor = .blue
        button.layer.cornerRadius = 22
        button.setTitle("取消", for: .normal)
        button.addTarget(self, action: #selector(cancelBTNPressed), for: .touchUpInside)

        return button
    }()

    let registerButton: UIButton = {

        let button = UIButton()
        button.backgroundColor = .gray
        button.layer.cornerRadius = 22
        button.setTitle("註冊", for: .normal)
        button.addTarget(self, action: #selector(registerPressed), for: .touchUpInside)

        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(profileImgView)
        view.addSubview(containerView)

        containerView.addSubview(nameLabel)
        containerView.addSubview(nameTextField)
        containerView.addSubview(nameSeparator)
        containerView.addSubview(emailLabel)
        containerView.addSubview(emailTextField)
        containerView.addSubview(emailSeparator)
        containerView.addSubview(passwordLabel)
        containerView.addSubview(passwordTextField)
        containerView.addSubview(passwordSeparator)
        containerView.addSubview(confirmLabel)
        containerView.addSubview(confirmTextField)
        containerView.addSubview(confirmSeparator)
        containerView.addSubview(cancelButton)
        containerView.addSubview(registerButton)

        setLayout()
    }

    // MARK: Register function

    @objc func registerPressed() {

        guard
            let email = emailTextField.text,
            let password = passwordTextField.text,
            emailTextField.text != "",
            passwordTextField.text != ""
            else {
                return
        }

        if passwordTextField.text == confirmTextField.text {

        } else {
            print("confirm password again")
        }

    }

    @objc func cancelBTNPressed() {

        self.dismiss(animated: true, completion: nil)
    }

    func setLayout() {

        profileImgView.anchor(
            top: nil,
            leading: nil,
            bottom: nil,
            trailing: nil,
            padding: .zero,
            size: CGSize(width: 125, height: 125)
        )

        profileImgView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImgView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -200).isActive = true

        containerView.anchor(
            top: nil,
            leading: view.leadingAnchor,
            bottom: nil,
            trailing: view.trailingAnchor,
            padding: .init(top: 0, left: 40, bottom: 0, right: 40),
            size: .init(width: 0, height: 400)
        )

        containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 70).isActive = true

        nameLabel.anchor(
            top: containerView.topAnchor,
            leading: containerView.leadingAnchor,
            bottom: nil,
            trailing: nil,
            padding: .init(top: 10, left: 10, bottom: 0, right: 0),
            size: .init(width: 100, height: 20)
        )

        nameTextField.anchor(
            top: nameLabel.bottomAnchor,
            leading: containerView.leadingAnchor,
            bottom: nil,
            trailing: containerView.trailingAnchor,
            padding: .init(top: 15, left: 10, bottom: 0, right: 10),
            size: .init(width: 0, height: 20)
        )

        nameSeparator.anchor(
            top: nameTextField.bottomAnchor,
            leading: containerView.leadingAnchor,
            bottom: nil,
            trailing: containerView.trailingAnchor,
            padding: .init(top: 5, left: 10, bottom: 0, right: 10),
            size: .init(width: 0, height: 1)
        )

        emailLabel.anchor(
            top: nameSeparator.bottomAnchor,
            leading: containerView.leadingAnchor,
            bottom: nil,
            trailing: nil,
            padding: .init(top: 15, left: 10, bottom: 0, right: 0),
            size: .init(width: 100, height: 20)
        )

        emailTextField.anchor(
            top: emailLabel.bottomAnchor,
            leading: containerView.leadingAnchor,
            bottom: nil,
            trailing: containerView.trailingAnchor,
            padding: .init(top: 15, left: 10, bottom: 0, right: 10),
            size: .init(width: 0, height: 20)
        )

        emailSeparator.anchor(
            top: emailTextField.bottomAnchor,
            leading: containerView.leadingAnchor,
            bottom: nil,
            trailing: containerView.trailingAnchor,
            padding: .init(top: 5, left: 10, bottom: 0, right: 10),
            size: .init(width: 0, height: 1)
        )

        passwordLabel.anchor(
            top: emailSeparator.bottomAnchor,
            leading: containerView.leadingAnchor,
            bottom: nil,
            trailing: nil,
            padding: .init(top: 15, left: 10, bottom: 0, right: 0),
            size: .init(width: 100, height: 20)
        )

        passwordTextField.anchor(
            top: passwordLabel.bottomAnchor,
            leading: containerView.leadingAnchor,
            bottom: nil,
            trailing: containerView.trailingAnchor,
            padding: .init(top: 15, left: 10, bottom: 0, right: 10),
            size: .init(width: 0, height: 20)
        )

        passwordSeparator.anchor(
            top: passwordTextField.bottomAnchor,
            leading: containerView.leadingAnchor,
            bottom: nil,
            trailing: containerView.trailingAnchor,
            padding: .init(top: 5, left: 10, bottom: 0, right: 10),
            size: .init(width: 0, height: 1)
        )

        confirmLabel.anchor(
            top: passwordSeparator.bottomAnchor,
            leading: containerView.leadingAnchor,
            bottom: nil,
            trailing: nil,
            padding: .init(top: 15, left: 10, bottom: 0, right: 0),
            size: .init(width: 100, height: 20)
        )

        confirmTextField.anchor(
            top: confirmLabel.bottomAnchor,
            leading: containerView.leadingAnchor,
            bottom: nil,
            trailing: containerView.trailingAnchor,
            padding: .init(top: 15, left: 10, bottom: 0, right: 10),
            size: .init(width: 0, height: 20)
        )

        confirmSeparator.anchor(
            top: confirmTextField.bottomAnchor,
            leading: containerView.leadingAnchor,
            bottom: nil,
            trailing: containerView.trailingAnchor,
            padding: .init(top: 5, left: 10, bottom: 0, right: 10),
            size: .init(width: 0, height: 1)
        )

        cancelButton.anchor(
            top: confirmSeparator.bottomAnchor,
            leading: containerView.leadingAnchor,
            bottom: nil,
            trailing: nil,
            padding: .init(top: 30, left: 10, bottom: 0, right: 0),
            size: .init(width: 120, height: 45)
        )

        registerButton.anchor(
            top: confirmSeparator.bottomAnchor,
            leading: nil,
            bottom: nil,
            trailing: containerView.trailingAnchor,
            padding: .init(top: 30, left: 0, bottom: 0, right: 10),
            size: .init(width: 120, height: 45)
        )

    }
}
