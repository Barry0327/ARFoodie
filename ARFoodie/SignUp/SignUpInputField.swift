//
//  SignUpInputField.swift
//  ARFoodie
//
//  Created by Barry Chen on 2021/2/24.
//  Copyright © 2021 Chen Yi-Wei. All rights reserved.
//

import UIKit

final class SignUpInputField: NiblessView {
    // MARK: - Properties
    let titleLabel: UILabel = UILabel {
        let textAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: UIColor(hexString: "fff4e1")!
        ]
        let attributeString = NSAttributedString(string: "", attributes: textAttributes)
        $0.attributedText = attributeString
    }

    let inputTextField: UITextField = UITextField {
        $0.attributedPlaceholder = NSAttributedString(
            string: "",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(hexString: "#BBC4C2")!]
        )
        $0.textAlignment = .center
        $0.textColor = UIColor(hexString: "E4DAD8")
        $0.tintColor = UIColor(hexString: "E4DAD8")
    }

    let separator: UIView = UIView {
        $0.backgroundColor = UIColor(hexString: "fff4e1")
    }

    // MARK: - Methods
    override func didMoveToWindow() {
        super.didMoveToWindow()
        constructViewHierarchy()
        activateConstraints()
    }

    private func constructViewHierarchy() {
        addSubview(titleLabel)
        addSubview(inputTextField)
        addSubview(separator)
    }

    private func activateConstraints() {
        activateTitleLabelConstraints()
        activateInputTextFieldConstraints()
        activateSeparatorConstraints()
    }
}
extension SignUpInputField {
    func activateTitleLabelConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        let top = titleLabel.topAnchor
            .constraint(equalTo: topAnchor)
        let leading = titleLabel.leadingAnchor
            .constraint(equalTo: leadingAnchor)

        NSLayoutConstraint.activate([
            top, leading
        ])
    }

    func activateInputTextFieldConstraints() {
        inputTextField.translatesAutoresizingMaskIntoConstraints = false
        let top = inputTextField.topAnchor
            .constraint(equalTo: titleLabel.bottomAnchor, constant: 15)
        let leading = inputTextField.leadingAnchor
            .constraint(equalTo: leadingAnchor)
        let trailing = inputTextField.trailingAnchor
            .constraint(equalTo: trailingAnchor)
        let height = inputTextField.heightAnchor
            .constraint(equalToConstant: 20)

        NSLayoutConstraint.activate([
            top, leading, trailing, height
        ])
    }

    func activateSeparatorConstraints() {
        separator.translatesAutoresizingMaskIntoConstraints = false
        let top = separator.topAnchor
            .constraint(equalTo: inputTextField.bottomAnchor)
        let leading = separator.leadingAnchor
            .constraint(equalTo: leadingAnchor)
        let trailing = separator.trailingAnchor
            .constraint(equalTo: trailingAnchor)
        let bottom = separator.bottomAnchor
            .constraint(equalTo: bottomAnchor)
        let height = separator.heightAnchor
            .constraint(equalToConstant: 1)

        NSLayoutConstraint.activate([
            top, leading, trailing, bottom, height
        ])
    }
}
