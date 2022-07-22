//
//  SignInRootView.swift
//  ARFoodie
//
//  Created by Barry Chen on 2021/2/18.
//  Copyright © 2021 Chen Yi-Wei. All rights reserved.
//

import UIKit

class SignInRootView: UIView {
    // MARK: - Properties
    private let appNameLabel: UILabel = {

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        let textAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: UIColor(hexString: "E4DAD8")!,
            NSAttributedString.Key.font: UIFont(name: "SnellRoundhand-Black", size: 55) as Any
        ]
        let attributeString = NSAttributedString(string: "ARFoodie", attributes: textAttributes)
        label.attributedText = attributeString

        return label
    }()

    private let containerView: UIView = {

        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private let emailIcon: UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.image = #imageLiteral(resourceName: "icons8-new-post-96 (1)")
        imgView.tintColor = UIColor(hexString: "E4DAD8")

        return imgView
    }()

    let emailTextField: UITextField = {

        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(
            string: "輸入電子郵件",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(hexString: "#BBC4C2")!]
        )
        textField.textColor = UIColor(hexString: "E4DAD8")
        textField.tintColor = UIColor(hexString: "E4DAD8")
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField

    }()

    private let emailSeparatorView: UIView = {

        let view = UIView()
        view.backgroundColor = UIColor(hexString: "E4DAD8")
        view.translatesAutoresizingMaskIntoConstraints = false

        return view

    }()

    private let passwordIcon: UIImageView = {

        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.image = #imageLiteral(resourceName: "icons8-lock-filled-480")
        imgView.tintColor = UIColor(hexString: "E4DAD8")

        return imgView
    }()

    let passwordTextField: UITextField = {

        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(
            string: "輸入密碼",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(hexString: "#BBC4C2")!]
        )
        textField.textColor = .white
        textField.tintColor = UIColor(hexString: "E4DAD8")
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false

        return textField
    }()

    private let passwordSeparator: UIView = {

        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hexString: "E4DAD8")
        return view

    }()

    private let logInButton: UIButton = {

        let button = UIButton()
        button.layer.cornerRadius = 22
        button.translatesAutoresizingMaskIntoConstraints = false
        let textAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: UIColor.flatWatermelonColorDark() as Any,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 25, weight: .bold)
        ]
        let attributeString = NSAttributedString(string: "登入", attributes: textAttributes)
        button.setAttributedTitle(attributeString, for: .normal)
        button.backgroundColor = UIColor(hexString: "E4DAD8")
//        button.addTarget(self, action: #selector(loginBTNPressed), for: .touchUpInside)

        return button
    }()

    private let registerBTN: UIButton = {

        let button = UIButton()
        button.layer.cornerRadius = 22
        button.translatesAutoresizingMaskIntoConstraints = false
        let textAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: UIColor(hexString: "E4DAD8")!,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 25, weight: .bold)
        ]
        let attributeString = NSAttributedString(string: "註冊", attributes: textAttributes)
        button.setAttributedTitle(attributeString, for: .normal)
        button.backgroundColor = .clear
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor(hexString: "E4DAD8")?.cgColor
//        button.addTarget(self, action: #selector(registerBTNPressed), for: .touchUpInside)

        return button
    }()

    private let visitorBTN: UIButton = {

        let button = UIButton()
        button.layer.cornerRadius = 18
        let textAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: UIColor(hexString: "E4DAD8")!,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .bold)
        ]
        let attributeString = NSAttributedString(string: "訪客", attributes: textAttributes)
        button.setAttributedTitle(attributeString, for: .normal)
        button.backgroundColor = .clear
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor(hexString: "E4DAD8")?.cgColor
//        button.addTarget(self, action: #selector(visitorBTNPressed), for: .touchUpInside)

        return button
    }()

    private let descriptionLabel: UILabel = {

        let label = UILabel()
        label.text = "登入即代表您同意"
        label.textAlignment = .center
        label.textColor = UIColor(hexString: "E4DAD8")
        label.font = UIFont.systemFont(ofSize: 15)

        return label
    }()

    let userPolicyLabel: UILabel = {

        let label = UILabel()
        label.text = "使用者條款"
        label.textAlignment = .center
        label.textColor = UIColor.flatSkyBlue()
        label.font = UIFont.systemFont(ofSize: 15)
        label.isUserInteractionEnabled = true
//        let gesture = UITapGestureRecognizer(target: self, action: #selector(performUserPolicyPage))
//        label.addGestureRecognizer(gesture)

        return label
    }()

    let privacyPolicyLabel: UILabel = {

        let label = UILabel()
        label.text = "隱私權政策"
        label.textAlignment = .center
        label.textColor = UIColor.flatSkyBlue()
        label.font = UIFont.systemFont(ofSize: 15)
        label.isUserInteractionEnabled = true
//        let gesture = UITapGestureRecognizer(target: self, action: #selector(performPrivacyPolicyPage))
//        label.addGestureRecognizer(gesture)

        return label
    }()

    // MARK: - Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func constructHeirachy() {
        backgroundColor = UIColor.flatWatermelonColorDark()

        addSubview(appNameLabel)
        addSubview(containerView)

        containerView.addSubview(emailIcon)
        containerView.addSubview(emailTextField)
        containerView.addSubview(emailSeparatorView)
        containerView.addSubview(passwordIcon)
        containerView.addSubview(passwordTextField)
        containerView.addSubview(passwordSeparator)
        containerView.addSubview(logInButton)
        containerView.addSubview(registerBTN)
        containerView.addSubview(visitorBTN)

        addSubview(descriptionLabel)
        addSubview(userPolicyLabel)
        addSubview(privacyPolicyLabel)

        setAppNameLabel()
        setContaionerView()
        setBottomLabel()
    }

    private func setAppNameLabel() {

        let constant = bounds.height / 4

        print(constant)

        appNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: constant).isActive = true
        appNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30).isActive = true
        appNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30).isActive = true
        appNameLabel.heightAnchor.constraint(equalTo: appNameLabel.widthAnchor, multiplier: 1.0/5.0).isActive = true

    }

    private func setContaionerView() {

        containerView.anchor(
            top: appNameLabel.bottomAnchor,
            leading: leadingAnchor,
            bottom: nil,
            trailing: trailingAnchor,
            padding: .init(top: 30, left: 30, bottom: 0, right: 30)
        )

        containerView.heightAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true

        NSLayoutConstraint.activate([

            emailIcon.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 18),
            emailIcon.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            emailIcon.widthAnchor.constraint(equalToConstant: 25),
            emailIcon.heightAnchor.constraint(equalToConstant: 25),
            emailTextField.heightAnchor.constraint(equalToConstant: 30),
            emailTextField.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 18),
            emailTextField.leadingAnchor.constraint(equalTo: emailIcon.trailingAnchor, constant: 10),
            emailTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10)

            ])

        emailSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        emailSeparatorView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10).isActive = true
        emailSeparatorView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10).isActive = true
        emailSeparatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 3).isActive = true

        passwordIcon.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15).isActive = true
        passwordIcon.topAnchor.constraint(equalTo: emailSeparatorView.bottomAnchor, constant: 28).isActive = true
        passwordIcon.widthAnchor.constraint(equalToConstant: 25).isActive = true
        passwordIcon.heightAnchor.constraint(equalToConstant: 25).isActive = true

        passwordTextField.topAnchor.constraint(equalTo: emailSeparatorView.bottomAnchor, constant: 29).isActive = true
        passwordTextField.leadingAnchor.constraint(equalTo: passwordIcon.trailingAnchor, constant: 10).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        passwordTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10).isActive = true

        passwordSeparator.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 3).isActive = true
        passwordSeparator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        passwordSeparator.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10).isActive = true
        passwordSeparator.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10).isActive = true

        logInButton.topAnchor.constraint(equalTo: passwordSeparator.bottomAnchor, constant: 40).isActive = true
        logInButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10).isActive = true
        logInButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        logInButton.heightAnchor.constraint(equalToConstant: 45).isActive = true

        registerBTN.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10).isActive = true
        registerBTN.topAnchor.constraint(equalTo: passwordSeparator.bottomAnchor, constant: 40).isActive = true
        registerBTN.widthAnchor.constraint(equalToConstant: 120).isActive = true
        registerBTN.heightAnchor.constraint(equalToConstant: 45).isActive = true

        visitorBTN.anchor(
            top: logInButton.bottomAnchor,
            leading: nil,
            bottom: nil,
            trailing: nil,
            padding: .init(top: 30, left: 0, bottom: 0, right: 0),
            size: .init(width: 120, height: 36)
        )
        visitorBTN.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }

    private func setBottomLabel() {

        descriptionLabel.anchor(
            top: containerView.bottomAnchor,
            leading: containerView.leadingAnchor,
            bottom: nil,
            trailing: containerView.trailingAnchor,
            padding: .init(top: 5, left: 0, bottom: 0, right: 0),
            size: .init(width: 0, height: 15)
        )

        userPolicyLabel.anchor(
            top: descriptionLabel.bottomAnchor,
            leading: nil,
            bottom: nil,
            trailing: descriptionLabel.centerXAnchor,
            padding: .init(top: 5, left: 0, bottom: 0, right: 0),
            size: .init(width: 100, height: 15)
        )

        privacyPolicyLabel.anchor(
            top: descriptionLabel.bottomAnchor,
            leading: descriptionLabel.centerXAnchor,
            bottom: nil,
            trailing: nil,
            padding: .init(top: 5, left: 0, bottom: 0, right: 0),
            size: .init(width: 100, height: 15)
        )
    }
}
