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

final class SignInRootView: NiblessView {
    // MARK: - Properties
    private let viewModel: SignInViewModel
    private var hierarchyNotReady: Bool = true

    private let disposeBag: DisposeBag = DisposeBag()

    private let scrollView: UIScrollView = UIScrollView()
    private let contentView: UIView = UIView {
        $0.backgroundColor = UIColor.flatWatermelonDark()
    }

    private let appNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        let textAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: UIColor(hexString: "E4DAD8")!,
            NSAttributedString.Key.font: UIFont(name: "SnellRoundhand-Black", size: 55) as Any
        ]
        let attributeString = NSAttributedString(string: "ARFoodie", attributes: textAttributes)
        label.attributedText = attributeString
        return label
    }()

    private let inputContainerView: UIView = UIView()

    private let emailIcon: UIImageView = {
        let imgView = UIImageView()
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
        return textField
    }()

    private let emailSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexString: "E4DAD8")
        return view
    }()

    private let passwordIcon: UIImageView = {
        let imgView = UIImageView()
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
        return textField
    }()

    private let passwordSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexString: "E4DAD8")
        return view
    }()

    private let signInButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 22
        let textAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: UIColor.flatWatermelonDark() as Any,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 25, weight: .bold)
        ]
        let attributeString = NSAttributedString(string: "登入", attributes: textAttributes)
        button.setAttributedTitle(attributeString, for: .normal)
        button.backgroundColor = UIColor(hexString: "E4DAD8")
        return button
    }()

    private let signUpButton: UIButton = {
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

    let userPolicyButton: UIButton = {
        let button = UIButton()
        button.setTitle("使用者條款", for: .normal)
        button.setTitleColor(.flatSkyBlue(), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        return button
    }()

    let privacyPolicyButton: UIButton = {
        let button = UIButton()
        button.setTitle("隱私權政策", for: .normal)
        button.setTitleColor(.flatSkyBlue(), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        return button
    }()

    // MARK: - Methods
    init(frame: CGRect = .zero,
         viewModel: SignInViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        bindTextFieldToViewModel()
        bindControlsToViewModel()
    }

    private func bindTextFieldToViewModel() {
        bindEmailField()
        bindPasswordField()
    }

    private func bindEmailField() {
        emailTextField.rx.text
            .orEmpty
            .subscribe(onNext: { [unowned self] in
                self.viewModel.email = $0
            })
            .disposed(by: disposeBag)

        emailTextField.rx.controlEvent(.editingDidEndOnExit)
            .subscribe(onNext: { [unowned self] in
                self.passwordTextField.becomeFirstResponder()
            })
            .disposed(by: disposeBag)
    }

    private func bindPasswordField() {
        passwordTextField.rx.text
            .orEmpty
            .subscribe(onNext: { [unowned self] in
                self.viewModel.password = $0
            })
            .disposed(by: disposeBag)

        passwordTextField.rx.controlEvent(.editingDidEndOnExit)
            .subscribe(onNext: { [unowned self] in
                self.viewModel.signIn()
            })
            .disposed(by: disposeBag)
    }

    private func bindControlsToViewModel() {
        signInButton.addTarget(viewModel,
                               action: #selector(SignInViewModel.signIn),
                               for: .touchUpInside)

        privacyPolicyButton.rx.tap
            .map { SignInView.userPrivacy }
            .bind(to: viewModel.signInView)
            .disposed(by: disposeBag)

        userPolicyButton.rx.tap
            .map { SignInView.userPolicy }
            .bind(to: viewModel.signInView)
            .disposed(by: disposeBag)

        signUpButton.rx.tap
            .map { SignInView.register }
            .bind(to: viewModel.signInView)
            .disposed(by: disposeBag)

        visitorButton.rx.tap
            .map { SignInView.main }
            .bind(to: viewModel.signInView)
            .disposed(by: disposeBag)
    }

    override func didMoveToWindow() {
        super.didMoveToWindow()
        guard hierarchyNotReady == true else { return }
        constructHeirachy()
        activateConstraints()
        hierarchyNotReady = false
    }

    private func constructHeirachy() {
        addSubview(scrollView)

        inputContainerView.addSubview(emailIcon)
        inputContainerView.addSubview(emailTextField)
        inputContainerView.addSubview(emailSeparatorView)
        inputContainerView.addSubview(passwordIcon)
        inputContainerView.addSubview(passwordTextField)
        inputContainerView.addSubview(passwordSeparator)
        inputContainerView.addSubview(signInButton)
        inputContainerView.addSubview(signUpButton)
        inputContainerView.addSubview(visitorButton)

        contentView.addSubview(appNameLabel)
        contentView.addSubview(inputContainerView)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(userPolicyButton)
        contentView.addSubview(privacyPolicyButton)

        scrollView.addSubview(contentView)
    }

    private func activateConstraints() {
        activateConstraintsScrollView()
        activateConstraintsContentView()
        activateConstraintsAppNameLabel()
        activateConstraintsInputContainerView()
        activateConstraintsEmailIcon()
        activateConstraintsEmailTextField()
        activateConstraintsEmailSeparatorView()
        activateConstraintsPasswordIcon()
        activateConstraintsPasswordTextField()
        activateConstraintsPasswordSeparator()
        activateConstraintsSignInButton()
        activateConstraintsSignUpButton()
        activateConstraintsDescriptionLabel()
        activateConstraintsUserPolicyButton()
        activateConstraintsPrivacyPolicyButton()
        activateConstraintsVisitorButton()
    }

    func resetScrollViewContentInset() {
        let scrollViewHeight: CGFloat = scrollView.bounds.height
        let contentViewHeight: CGFloat = 466.0

        var insets = UIEdgeInsets.zero
        insets.top = scrollViewHeight / 2
        insets.top -= contentViewHeight / 2
        insets.bottom = scrollViewHeight / 2
        insets.bottom -= contentViewHeight / 2

        scrollView.contentInset = insets
    }

    func moveContent(forKeyboardFrame keyboardFrame: CGRect) {
        var insets = scrollView.contentInset
        insets.bottom = keyboardFrame.height
        scrollView.contentInset = insets
    }
}
// MARK: - Layout constraints
extension SignInRootView {
    private func activateConstraintsScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        let top = scrollView.topAnchor
            .constraint(equalTo: safeAreaLayoutGuide.topAnchor)
        let leading = scrollView.leadingAnchor
            .constraint(equalTo: leadingAnchor)
        let trailing = scrollView.trailingAnchor
            .constraint(equalTo: trailingAnchor)
        let bottom = scrollView.bottomAnchor
            .constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)

        NSLayoutConstraint.activate([
            top, leading, trailing, bottom
        ])
    }

    private func activateConstraintsContentView() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        let top = contentView.topAnchor
            .constraint(equalTo: scrollView.topAnchor)
        let leading = contentView.leadingAnchor
            .constraint(equalTo: scrollView.leadingAnchor)
        let trailing = contentView.trailingAnchor
            .constraint(equalTo: scrollView.trailingAnchor)
        let bottom = contentView.bottomAnchor
            .constraint(equalTo: scrollView.bottomAnchor)
        let width = contentView.widthAnchor
            .constraint(equalTo: scrollView.widthAnchor)

        NSLayoutConstraint.activate([
            top, leading, trailing, bottom, width
        ])
    }

    private func activateConstraintsAppNameLabel() {
        appNameLabel.translatesAutoresizingMaskIntoConstraints = false
        let top = appNameLabel.topAnchor
            .constraint(equalTo: contentView.topAnchor)
        let leading = appNameLabel.leadingAnchor
            .constraint(equalTo: contentView.leadingAnchor, constant: 30)
        let trailing = appNameLabel.trailingAnchor
            .constraint(equalTo: contentView.trailingAnchor, constant: -30)
        let height = appNameLabel.heightAnchor.constraint(equalTo: appNameLabel.widthAnchor, multiplier: 1.0/5.0)

        NSLayoutConstraint.activate([
            top, leading, trailing, height
        ])
    }

    private func activateConstraintsInputContainerView() {
        inputContainerView.translatesAutoresizingMaskIntoConstraints = false
        let top = inputContainerView.topAnchor
            .constraint(equalTo: appNameLabel.bottomAnchor, constant: 30)
        let leading = inputContainerView.leadingAnchor
            .constraint(equalTo: contentView.leadingAnchor, constant: 30)
        let trailing = inputContainerView.trailingAnchor
            .constraint(equalTo: contentView.trailingAnchor, constant: -30)
        let height = inputContainerView.heightAnchor
            .constraint(equalTo: inputContainerView.widthAnchor)

        NSLayoutConstraint.activate([
            top, leading, trailing, height
        ])
    }

    private func activateConstraintsEmailIcon() {
        emailIcon.translatesAutoresizingMaskIntoConstraints = false
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

    private func activateConstraintsEmailTextField() {
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
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

    private func activateConstraintsEmailSeparatorView() {
        emailSeparatorView.translatesAutoresizingMaskIntoConstraints = false
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

    private func activateConstraintsPasswordIcon() {
        passwordIcon.translatesAutoresizingMaskIntoConstraints = false
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

    private func activateConstraintsPasswordTextField() {
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
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

    private func activateConstraintsPasswordSeparator() {
        passwordSeparator.translatesAutoresizingMaskIntoConstraints = false
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

    private func activateConstraintsSignInButton() {
        signInButton.translatesAutoresizingMaskIntoConstraints = false
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

    private func activateConstraintsSignUpButton() {
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        let top = signUpButton.topAnchor
            .constraint(equalTo: passwordSeparator.bottomAnchor, constant: 40)
        let trailing = signUpButton.trailingAnchor
            .constraint(equalTo: inputContainerView.trailingAnchor, constant: -10)
        let width = signUpButton.widthAnchor
            .constraint(equalToConstant: 120)
        let height = signUpButton.heightAnchor
            .constraint(equalToConstant: 45)

        NSLayoutConstraint.activate([
            top, trailing, width, height
        ])
    }

    private func activateConstraintsVisitorButton() {
        visitorButton.translatesAutoresizingMaskIntoConstraints = false
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

    private func activateConstraintsDescriptionLabel() {
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
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

    private func activateConstraintsUserPolicyButton() {
        userPolicyButton.translatesAutoresizingMaskIntoConstraints = false
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

    private func activateConstraintsPrivacyPolicyButton() {
        privacyPolicyButton.translatesAutoresizingMaskIntoConstraints = false
        let top = privacyPolicyButton.topAnchor
            .constraint(equalTo: descriptionLabel.bottomAnchor, constant: 5)
        let leading = privacyPolicyButton.leadingAnchor
            .constraint(equalTo: descriptionLabel.centerXAnchor)
        let width = privacyPolicyButton.widthAnchor
            .constraint(equalToConstant: 100)
        let height = privacyPolicyButton.heightAnchor
            .constraint(equalToConstant: 15)
        let bottom = privacyPolicyButton.bottomAnchor
            .constraint(equalTo: contentView.bottomAnchor)

        NSLayoutConstraint.activate([
            top, leading, width, height, bottom
        ])
    }
}
