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
            NSAttributedString.Key.foregroundColor: UIColor.flatWatermelonDark,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 25, weight: .bold)
        ]
        let attributeString = NSAttributedString(string: "註冊", attributes: textAttributes)
        button.setAttributedTitle(attributeString, for: .normal)
        button.addTarget(self, action: #selector(registerPressed), for: .touchUpInside)

        return button
    }()

    // MARK: - View Did Load

    override func viewDidLoad() {
        super.viewDidLoad()

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

        view.backgroundColor = UIColor.flatWatermelonDark

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
