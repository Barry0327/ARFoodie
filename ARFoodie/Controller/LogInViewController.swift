//
//  LogInViewController.swift
//  ARFoodie
//
//  Created by Chen Yi-Wei on 2019/4/5.
//  Copyright © 2019 Chen Yi-Wei. All rights reserved.
//

import UIKit
import Firebase
import IHProgressHUD
import ChameleonFramework

class LogInViewController: UIViewController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    let appNameLabel: UILabel = {

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

    let containerView: UIView = {

        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    let emailIcon: UIImageView = {

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

    let emailSeparatorView: UIView = {

        let view = UIView()
        view.backgroundColor = UIColor(hexString: "E4DAD8")
        view.translatesAutoresizingMaskIntoConstraints = false

        return view

    }()

    let passwordIcon: UIImageView = {

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

    let passwordSeparator: UIView = {

        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hexString: "E4DAD8")
        return view

    }()

    let logInButton: UIButton = {

        let button = UIButton()
        button.layer.cornerRadius = 22
        button.translatesAutoresizingMaskIntoConstraints = false
        let textAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: UIColor.flatWatermelonDark,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 25, weight: .bold)
        ]
        let attributeString = NSAttributedString(string: "登入", attributes: textAttributes)
        button.setAttributedTitle(attributeString, for: .normal)
        button.backgroundColor = UIColor(hexString: "E4DAD8")
        button.addTarget(self, action: #selector(loginBTNPressed), for: .touchUpInside)

        return button
    }()

    let registerBTN: UIButton = {

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
        button.addTarget(self, action: #selector(registerBTNPressed), for: .touchUpInside)

        return button
    }()

    let descriptionLabel: UILabel = {

        let label = UILabel()
        label.text = "登入即代表您同意"
        label.textAlignment = .center
        label.textColor = UIColor(hexString: "E4DAD8")
        label.font = UIFont.systemFont(ofSize: 15)

        return label
    }()

    lazy var userPolicyLabel: UILabel = {

        let label = UILabel()
        label.text = "使用者條款"
        label.textAlignment = .center
        label.textColor = UIColor.flatSkyBlue
        label.font = UIFont.systemFont(ofSize: 15)
        label.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(performUserPolicyPage))
        label.addGestureRecognizer(gesture)

        return label
    }()

    let privacyPolicyLabel: UILabel = {

        let label = UILabel()
        label.text = "隱私權政策"
        label.textAlignment = .center
        label.textColor = UIColor.flatSkyBlue
        label.font = UIFont.systemFont(ofSize: 15)

        return label
    }()

    // MARK: - View Did Load

    override func viewDidLoad() {
        super.viewDidLoad()

        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self

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
        view.addSubview(appNameLabel)
        view.addSubview(containerView)

        containerView.addSubview(emailIcon)
        containerView.addSubview(emailTextField)
        containerView.addSubview(emailSeparatorView)
        containerView.addSubview(passwordIcon)
        containerView.addSubview(passwordTextField)
        containerView.addSubview(passwordSeparator)
        containerView.addSubview(logInButton)
        containerView.addSubview(registerBTN)

        view.addSubview(descriptionLabel)
        view.addSubview(userPolicyLabel)
        view.addSubview(privacyPolicyLabel)

        setAppNameLabel()

        setContaionerView()
    }

    @objc func performUserPolicyPage() {

        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)

        guard
            let userPrivacyVC = storyboard.instantiateViewController(
                withIdentifier: "UserPolicyViewController"
                ) as? UserPolicyViewController
            else { fatalError("Please check the ID for UserPolicyViewController")}

        let navigationCTL = UINavigationController(rootViewController: userPrivacyVC)

        self.present(navigationCTL, animated: true, completion: nil)
    }

    @objc func loginBTNPressed() {

        guard
            let email = emailTextField.text,
            let password = passwordTextField.text,
            email.count > 0,
            password.count > 0
        else {

            AuthenticationError.invalidInformation.alert(message: "帳號或密碼有誤")
            return
        }

        IHProgressHUD.show()

        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in

            guard let self = self else { return }

            if let error = error {

                IHProgressHUD.dismiss()

                let alert = UIAlertController(title: "登入失敗",
                                              message: error.localizedDescription,
                                              preferredStyle: .alert)

                alert.addAction(UIAlertAction(title: "OK", style: .default))

                self.present(alert, animated: true, completion: nil)

            }

            guard let userID = result?.user.uid else {

                IHProgressHUD.dismiss()

                return

            }

            let currentUserRef = Database.database().reference(withPath: "users").child(userID)

            currentUserRef.observeSingleEvent(of: .value, with: { (snapshot) in

                guard
                    let info = snapshot.value as? [String: Any],
                    let displayName = info["displayName"] as? String,
                    let imgUID = info["profileImageUID"] as? String
                    else { return }

                var currentUser = User.init(authData: result!.user)

                currentUser.displayName = displayName

                currentUser.profileImageUID = imgUID

                CurrentUser.shared.user = currentUser

            })
            IHProgressHUD.dismiss()

            self.performSegue(withIdentifier: "FinishLogin", sender: self)

        }

    }

    @objc func registerBTNPressed() {

        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        if let registerVC = storyboard.instantiateViewController(withIdentifier: "RegisterViewController") as? RegisterViewController {

            self.present(registerVC, animated: true, completion: nil)

        }

    }

    func setAppNameLabel() {

        appNameLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        appNameLabel.heightAnchor.constraint(equalToConstant: 80).isActive = true
        appNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        appNameLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -150).isActive = true
    }

    func setContaionerView() {

        containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 50).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        containerView.widthAnchor.constraint(equalToConstant: 300).isActive = true

//        containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
//        containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true

        emailIcon.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 18).isActive = true
        emailIcon.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15).isActive = true
        emailIcon.widthAnchor.constraint(equalToConstant: 25).isActive = true
        emailIcon.heightAnchor.constraint(equalToConstant: 25).isActive = true

        emailTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        emailTextField.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 18).isActive = true
        emailTextField.leadingAnchor.constraint(equalTo: emailIcon.trailingAnchor, constant: 10).isActive = true
        emailTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10).isActive = true

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

extension LogInViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        switch textField {

        case self.emailTextField:

            self.passwordTextField.becomeFirstResponder()

        default:

            self.loginBTNPressed()

        }

        return false
    }
}
