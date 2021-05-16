//
//  SignUpRootView.swift
//  ARFoodie
//
//  Created by Barry Chen on 2021/2/24.
//  Copyright © 2021 Chen Yi-Wei. All rights reserved.
//

import UIKit

class SignUpRootView: NiblessView {
    // MARK: - Properties
    let profileImageView: UIImageView = UIImageView {
        $0.tintColor = UIColor(hexString: "fff4e1")
        $0.image = UIImage(named: "user")
        $0.layer.cornerRadius = 125/2
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(hexString: "fff4e1")?.cgColor
        $0.isUserInteractionEnabled = true
//        imgView.addGestureRecognizer(
//            UITapGestureRecognizer(
//                target: self,
//                action: #selector(profileImageViewSelectHandler)
//            )
//        )
        $0.clipsToBounds = true
    }

    let inputStackView: UIStackView = UIStackView {
        $0.axis = .vertical
        $0.spacing = 15
    }

    let nameInputField: SignUpInputField = SignUpInputField {
        $0.titleLabel.text = "用戶名稱"
        $0.inputTextField.placeholder = "輸入名稱"
    }

    let emailInputField: SignUpInputField = SignUpInputField {
        $0.titleLabel.text = "登入帳號"
        $0.inputTextField.placeholder = "輸入電子郵件"
    }

    let passwordInputField: SignUpInputField = SignUpInputField {
        $0.titleLabel.text = "登入密碼"
        $0.inputTextField.placeholder = "輸入密碼"
    }

    let confirmPasswordInputField: SignUpInputField = SignUpInputField {
        $0.titleLabel.text = "確認密碼"
        $0.inputTextField.placeholder = "再次輸入密碼"
    }

    let cancelButton: UIButton = UIButton {
        $0.backgroundColor = .clear
        $0.layer.borderWidth = 2
        $0.layer.borderColor = UIColor(hexString: "fff4e1")?.cgColor
        $0.layer.cornerRadius = 22
        let textAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: UIColor(hexString: "fff4e1")!,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 25, weight: .bold)
        ]
        let attributeString = NSAttributedString(string: "取消", attributes: textAttributes)
        $0.setAttributedTitle(attributeString, for: .normal)
//        button.addTarget(self, action: #selector(cancelBTNPressed), for: .touchUpInside)
    }

    let signUpButton: UIButton = UIButton {
        $0.backgroundColor = UIColor(hexString: "fff4e1")
        $0.layer.cornerRadius = 22
        let textAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: UIColor.flatWatermelonDark(),
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 25, weight: .bold)
        ]
        let attributeString = NSAttributedString(string: "註冊", attributes: textAttributes)
        $0.setAttributedTitle(attributeString, for: .normal)
//        button.addTarget(self, action: #selector(registerPressed), for: .touchUpInside)
    }

    var inputFields: [SignUpInputField] {
        return [nameInputField, emailInputField, passwordInputField, confirmPasswordInputField]
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        constructViewHierarchy()
    }

    override func didMoveToWindow() {
        super.didMoveToWindow()
        activateConstraints()
    }

    func constructViewHierarchy() {
        addSubview(profileImageView)
        addSubview(inputStackView)

        inputFields.forEach {
            inputStackView.addArrangedSubview($0)
        }

        addSubview(cancelButton)
        addSubview(signUpButton)
    }

    func activateConstraints() {
        activateConstraintsProfileImageView()
        activateConstraintsInputStackView()
        activateConstraintsInputFields()
        activateConstraintsCancelButton()
        activateConstraintsSignUpButton()
    }
}
// MARK: - Layout
extension SignUpRootView {
    func activateConstraintsProfileImageView() {
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        let centerX = profileImageView.centerXAnchor
            .constraint(equalTo: centerXAnchor)
        let centerY = profileImageView.centerYAnchor
            .constraint(equalTo: centerYAnchor, constant: -200)
        let width = profileImageView.widthAnchor
            .constraint(equalToConstant: 125)
        let height = profileImageView.heightAnchor
            .constraint(equalTo: profileImageView.widthAnchor)

        NSLayoutConstraint.activate([
            centerX, centerY, width, height
        ])
    }

    func activateConstraintsInputStackView() {
        inputStackView.translatesAutoresizingMaskIntoConstraints = false
        let leading = inputStackView.leadingAnchor
            .constraint(equalTo: leadingAnchor, constant: 40)
        let trailing = inputStackView.trailingAnchor
            .constraint(equalTo: trailingAnchor, constant: -40)
        let centerY = inputStackView.centerYAnchor
            .constraint(equalTo: centerYAnchor, constant: 70)

        NSLayoutConstraint.activate([
            leading, trailing, centerY
        ])
    }

    func activateConstraintsInputFields() {
        let inputFields = [nameInputField, passwordInputField, emailInputField, confirmPasswordInputField]
        inputFields.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.heightAnchor.constraint(equalToConstant: 56).isActive = true
        }
    }

    func activateConstraintsCancelButton() {
        let top = cancelButton.topAnchor
            .constraint(equalTo: inputStackView.bottomAnchor, constant: 30)
        let leading = cancelButton.leadingAnchor
            .constraint(equalTo: inputStackView.leadingAnchor, constant: 10)
        let width = cancelButton.widthAnchor
            .constraint(equalToConstant: 120)
        let height = cancelButton.heightAnchor
            .constraint(equalToConstant: 45)

        NSLayoutConstraint.activate([
            top, leading, width, height
        ])
    }

    func activateConstraintsSignUpButton() {
        let top = signUpButton.topAnchor
            .constraint(equalTo: cancelButton.topAnchor)
        let trailing = signUpButton.trailingAnchor
            .constraint(equalTo: inputStackView.trailingAnchor, constant: -10)
        let width = signUpButton.widthAnchor
            .constraint(equalTo: cancelButton.widthAnchor)
        let height = signUpButton.heightAnchor
            .constraint(equalTo: cancelButton.heightAnchor)

        NSLayoutConstraint.activate([
            top, trailing, width, height
        ])
    }
}
