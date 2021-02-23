//
//  SignInRootView.swift
//  ARFoodie
//
//  Created by Barry Chen on 2021/2/18.
//  Copyright © 2021 Chen Yi-Wei. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SignInRootView: NiblessView {
    // MARK: - Properties
    let viewModel: SignInViewModel
    var isHierarchyReady: Bool = false

    let disposeBag: DisposeBag = DisposeBag()

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

    private let inputContainerView: UIView = {
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

    private let signInButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 22
        button.translatesAutoresizingMaskIntoConstraints = false
        let textAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: UIColor.flatWatermelonDark() as Any,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 25, weight: .bold)
        ]
        let attributeString = NSAttributedString(string: "登入", attributes: textAttributes)
        button.setAttributedTitle(attributeString, for: .normal)
        button.backgroundColor = UIColor(hexString: "E4DAD8")
        button.translatesAutoresizingMaskIntoConstraints = false
//        button.addTarget(self, action: #selector(loginBTNPressed), for: .touchUpInside)
        return button
    }()

    private let registerButton: UIButton = {
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
        button.translatesAutoresizingMaskIntoConstraints = false
//        button.addTarget(self, action: #selector(registerBTNPressed), for: .touchUpInside)
        return button
    }()

    private let visitorButton: UIButton = {
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
        button.translatesAutoresizingMaskIntoConstraints = false
//        button.addTarget(self, action: #selector(visitorBTNPressed), for: .touchUpInside)
        return button
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "登入即代表您同意"
        label.textAlignment = .center
        label.textColor = UIColor(hexString: "E4DAD8")
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let userPolicyButton: UIButton = {
        let button = UIButton()
        button.setTitle("使用者條款", for: .normal)
        button.setTitleColor(.flatSkyBlue(), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let privacyPolicyButton: UIButton = {
        let button = UIButton()
        button.setTitle("隱私權政策", for: .normal)
        button.setTitleColor(.flatSkyBlue(), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
//        label.text = "隱私權政策"
//        label.textAlignment = .center
//        label.textColor = UIColor.flatSkyBlue()
//        label.font = UIFont.systemFont(ofSize: 15)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Methods
    init(frame: CGRect = .zero,
         viewModel: SignInViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        bindTextFieldToViewModel()
        setUpControls()
        emailTextField.rx.controlEvent(.editingDidEndOnExit)
            .subscribe(onNext: { [unowned self] in
                self.passwordTextField.becomeFirstResponder()
            })
            .disposed(by: disposeBag)
    }

    func bindTextFieldToViewModel() {
        bindEmailField()
        bindPasswordField()
    }

    func bindEmailField() {
        emailTextField.rx.text
            .orEmpty
            .bind(to: viewModel.email)
            .disposed(by: disposeBag)
    }

    func bindPasswordField() {
        passwordTextField.rx.text
            .orEmpty
            .bind(to: viewModel.password)
            .disposed(by: disposeBag)
    }

    func setUpControls() {
        signInButton.addTarget(viewModel,
                               action: #selector(SignInViewModel.signIn),
                               for: .touchUpInside)

        privacyPolicyButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.viewModel.signInView.accept(.userPrivacy)
            })
            .disposed(by: disposeBag)

        userPolicyButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.viewModel.signInView.accept(.userPolicy)
            })
            .disposed(by: disposeBag)

        registerButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.viewModel.signInView.accept(.register)
            })
            .disposed(by: disposeBag)

        visitorButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.viewModel.signInView.accept(.main)
            })
            .disposed(by: disposeBag)
    }

    override func didMoveToWindow() {
        super.didMoveToWindow()
        guard isHierarchyReady == false else { return }
        constructHeirachy()
        activateConstraints()
    }

    func constructHeirachy() {
        backgroundColor = UIColor.flatWatermelonDark()

        addSubview(appNameLabel)
        addSubview(inputContainerView)

        inputContainerView.addSubview(emailIcon)
        inputContainerView.addSubview(emailTextField)
        inputContainerView.addSubview(emailSeparatorView)
        inputContainerView.addSubview(passwordIcon)
        inputContainerView.addSubview(passwordTextField)
        inputContainerView.addSubview(passwordSeparator)
        inputContainerView.addSubview(signInButton)
        inputContainerView.addSubview(registerButton)
        inputContainerView.addSubview(visitorButton)

        addSubview(descriptionLabel)
        addSubview(userPolicyButton)
        addSubview(privacyPolicyButton)
    }

    func activateConstraints() {
        activateConstraintsAppNameLabel()
        activateConstraintsInputContainerView()
        activateConstraintsEmailIcon()
        activateConstraintsEmailTextField()
        activateConstraintsEmailSeparatorView()
        activateConstraintsPasswordIcon()
        activateConstraintsPasswordTextField()
        activateConstraintsPasswordSeparator()
        activateConstraintsSignInButton()
        activateConstraintsRegisterButton()
        activateConstraintsDescriptionLabel()
        activateConstraintsUserPolicyLabel()
        activateConstraintsPrivacyPolicyLabel()
        activateConstraintsVisitorButton()
    }

}
// MARK: - Layout constraints
extension SignInRootView {
    func activateConstraintsAppNameLabel() {
        let topConstant = bounds.height / 4

        let top = appNameLabel.topAnchor
            .constraint(equalTo: topAnchor, constant: topConstant)
        let leading = appNameLabel.leadingAnchor
            .constraint(equalTo: leadingAnchor, constant: 30)
        let trailing = appNameLabel.trailingAnchor
            .constraint(equalTo: trailingAnchor, constant: -30)
        let height = appNameLabel.heightAnchor.constraint(equalTo: appNameLabel.widthAnchor, multiplier: 1.0/5.0)

        NSLayoutConstraint.activate([
            top, leading, trailing, height
        ])
    }

    func activateConstraintsInputContainerView() {
        let top = inputContainerView.topAnchor
            .constraint(equalTo: appNameLabel.bottomAnchor, constant: 30)
        let leading = inputContainerView.leadingAnchor
            .constraint(equalTo: leadingAnchor, constant: 30)
        let trailing = inputContainerView.trailingAnchor
            .constraint(equalTo: trailingAnchor, constant: -30)
        let height = inputContainerView.heightAnchor
            .constraint(equalTo: inputContainerView.widthAnchor)

        NSLayoutConstraint.activate([
            top, leading, trailing, height
        ])
    }

    func activateConstraintsEmailIcon() {
        let top = emailIcon.topAnchor
            .constraint(equalTo: inputContainerView.topAnchor, constant: 18)
        let leading = emailIcon.leadingAnchor
            .constraint(equalTo: inputContainerView.leadingAnchor, constant: 15)
        let width = emailIcon.widthAnchor
            .constraint(equalToConstant: 25)
        let height = emailIcon.heightAnchor
            .constraint(equalToConstant: 25)

        NSLayoutConstraint.activate([
            top, leading, width, height
        ])
    }

    func activateConstraintsEmailTextField() {
        let height = emailTextField.heightAnchor
            .constraint(equalToConstant: 30)
        let top = emailTextField.topAnchor
            .constraint(equalTo: inputContainerView.topAnchor, constant: 18)
        let leading = emailTextField.leadingAnchor
            .constraint(equalTo: emailIcon.trailingAnchor, constant: 10)
        let trailing = emailTextField.trailingAnchor
            .constraint(equalTo: inputContainerView.trailingAnchor, constant: -10)

        NSLayoutConstraint.activate([
            height, top, leading, trailing
        ])
    }

    func activateConstraintsEmailSeparatorView() {
        let height = emailSeparatorView.heightAnchor
            .constraint(equalToConstant: 1)
        let leading = emailSeparatorView.leadingAnchor
            .constraint(equalTo: inputContainerView.leadingAnchor, constant: 10)
        let trailing = emailSeparatorView.trailingAnchor
            .constraint(equalTo: inputContainerView.trailingAnchor, constant: -10)
        let top = emailSeparatorView.topAnchor
            .constraint(equalTo: emailTextField.bottomAnchor, constant: 3)

        NSLayoutConstraint.activate([
            height, leading, trailing, top
        ])
    }

    func activateConstraintsPasswordIcon() {
        let top = passwordIcon.topAnchor
            .constraint(equalTo: emailSeparatorView.bottomAnchor, constant: 28)
        let leading = passwordIcon.leadingAnchor
            .constraint(equalTo: inputContainerView.leadingAnchor, constant: 15)
        let width = passwordIcon.widthAnchor
            .constraint(equalToConstant: 25)
        let height = passwordIcon.heightAnchor
            .constraint(equalToConstant: 25)

        NSLayoutConstraint.activate([
            top, leading, width, height
        ])
    }

    func activateConstraintsPasswordTextField() {
        let top = passwordTextField.topAnchor
            .constraint(equalTo: emailSeparatorView.bottomAnchor, constant: 29)
        let leading = passwordTextField.leadingAnchor
            .constraint(equalTo: passwordIcon.trailingAnchor, constant: 10)
        let trailing = passwordTextField.trailingAnchor
            .constraint(equalTo: inputContainerView.trailingAnchor, constant: -10)
        let height = passwordTextField.heightAnchor
            .constraint(equalToConstant: 30)

        NSLayoutConstraint.activate([
            top, leading, trailing, height
        ])
    }

    func activateConstraintsPasswordSeparator() {
        let top = passwordSeparator.topAnchor
            .constraint(equalTo: passwordTextField.bottomAnchor, constant: 3)
        let leading = passwordSeparator.leadingAnchor
            .constraint(equalTo: inputContainerView.leadingAnchor, constant: 10)
        let trailing = passwordSeparator.trailingAnchor
            .constraint(equalTo: inputContainerView.trailingAnchor, constant: -10)
        let height = passwordSeparator.heightAnchor
            .constraint(equalToConstant: 1)

        NSLayoutConstraint.activate([
            top, leading, trailing, height
        ])
    }

    func activateConstraintsSignInButton() {
        let top = signInButton.topAnchor
            .constraint(equalTo: passwordSeparator.bottomAnchor, constant: 40)
        let leading = signInButton.leadingAnchor
            .constraint(equalTo: inputContainerView.leadingAnchor, constant: 10)
        let width = signInButton.widthAnchor
            .constraint(equalToConstant: 120)
        let height = signInButton.heightAnchor
            .constraint(equalToConstant: 45)

        NSLayoutConstraint.activate([
            top, leading, width, height
        ])
    }

    func activateConstraintsRegisterButton() {
        let top = registerButton.topAnchor
            .constraint(equalTo: passwordSeparator.bottomAnchor, constant: 40)
        let trailing = registerButton.trailingAnchor
            .constraint(equalTo: inputContainerView.trailingAnchor, constant: -10)
        let width = registerButton.widthAnchor
            .constraint(equalToConstant: 120)
        let height = registerButton.heightAnchor
            .constraint(equalToConstant: 45)

        NSLayoutConstraint.activate([
            top, trailing, width, height
        ])
    }

    func activateConstraintsVisitorButton() {
        let top = visitorButton.topAnchor
            .constraint(equalTo: signInButton.bottomAnchor, constant: 30)
        let centerX = visitorButton.centerXAnchor
            .constraint(equalTo: centerXAnchor)
        let width = visitorButton.widthAnchor
            .constraint(equalToConstant: 120)
        let height = visitorButton.heightAnchor
            .constraint(equalToConstant: 36)

        NSLayoutConstraint.activate([
            top, centerX, width, height
        ])
    }

    func activateConstraintsDescriptionLabel() {
        let top = descriptionLabel.topAnchor
            .constraint(equalTo: inputContainerView.bottomAnchor, constant: 5)
        let leading = descriptionLabel.leadingAnchor
            .constraint(equalTo: inputContainerView.leadingAnchor)
        let trailing = descriptionLabel.trailingAnchor
            .constraint(equalTo: inputContainerView.trailingAnchor)
        let height = descriptionLabel.heightAnchor
            .constraint(equalToConstant: 15)

        NSLayoutConstraint.activate([
            top, leading, trailing, height
        ])
    }

    func activateConstraintsUserPolicyLabel() {
        let top = userPolicyButton.topAnchor
            .constraint(equalTo: descriptionLabel.bottomAnchor, constant: 5)
        let trailing = userPolicyButton.trailingAnchor
            .constraint(equalTo: descriptionLabel.centerXAnchor)
        let width = userPolicyButton.widthAnchor
            .constraint(equalToConstant: 100)
        let height = userPolicyButton.heightAnchor
            .constraint(equalToConstant: 15)

        NSLayoutConstraint.activate([
            top, trailing, width, height
        ])
    }

    func activateConstraintsPrivacyPolicyLabel() {
        let top = privacyPolicyButton.topAnchor
            .constraint(equalTo: descriptionLabel.bottomAnchor, constant: 5)
        let leading = privacyPolicyButton.leadingAnchor
            .constraint(equalTo: descriptionLabel.centerXAnchor)
        let width = privacyPolicyButton.widthAnchor
            .constraint(equalToConstant: 100)
        let height = privacyPolicyButton.heightAnchor
            .constraint(equalToConstant: 15)

        NSLayoutConstraint.activate([
            top, leading, width, height
        ])
    }
}
