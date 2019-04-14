//
//  LogInViewController.swift
//  ARFoodie
//
//  Created by Chen Yi-Wei on 2019/4/5.
//  Copyright © 2019 Chen Yi-Wei. All rights reserved.
//

import UIKit
import Firebase

class LogInViewController: UIViewController {

    let appNameLabel: UILabel = {

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "ARFoodie"
        label.font = UIFont.systemFont(ofSize: 30)
        label.textAlignment = .center

        return label
    }()

    let containerView: UIView = {

        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false

        view.backgroundColor = .white
        return view
    }()

    let emailIcon: UIImageView = {

        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.image = #imageLiteral(resourceName: "icons8-new-post-96")

        return imgView
    }()

    let emailTextField: UITextField = {

        let textField = UITextField()
        textField.placeholder = "輸入電子郵件"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    let emailSeparatorView: UIView = {

        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false

        return view

    }()

    let passwordIcon: UIImageView = {

        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.image = #imageLiteral(resourceName: "icons8-lock-filled-480")

        return imgView
    }()

    let passwordTextField: UITextField = {

        let textField = UITextField()
        textField.placeholder = "輸入密碼"
        textField.translatesAutoresizingMaskIntoConstraints = false

        return textField
    }()

    let passwordSeparator: UIView = {

        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view

    }()

    let logInButton: UIButton = {

        let button = UIButton()
        button.layer.cornerRadius = 22
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("登入", for: .normal)
        button.backgroundColor = .red
        button.addTarget(self, action: #selector(loginBTNPressed), for: .touchUpInside)

        return button
    }()

    let registerBTN: UIButton = {

        let button = UIButton()
        button.layer.cornerRadius = 22
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("註冊", for: .normal)
        button.backgroundColor = .blue
        button.addTarget(self, action: #selector(registerBTNPressed), for: .touchUpInside)

        return button
    }()

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

        view.backgroundColor = .gray
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

        setAppNameLabel()
        setContaionerView()
    }

    deinit {
        print("LoginView deinited")
    }

    @objc func loginBTNPressed() {
        guard
            let email = emailTextField.text,
            let password = passwordTextField.text,
            email.count > 0,
            password.count > 0
        else {
            print("Please check the email and password again")
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { (_, error) in

            if let error = error {

                let alert = UIAlertController(title: "登入失敗",
                                              message: error.localizedDescription,
                                              preferredStyle: .alert)

                alert.addAction(UIAlertAction(title: "OK", style: .default))

                self.present(alert, animated: true, completion: nil)

            }

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

        appNameLabel.widthAnchor.constraint(equalToConstant: 160).isActive = true
        appNameLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
        appNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        appNameLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -160).isActive = true
    }

    func setContaionerView() {

        containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 40).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 250).isActive = true
//        containerView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
        containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true

        emailIcon.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 18).isActive = true
        emailIcon.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15).isActive = true
        emailIcon.widthAnchor.constraint(equalToConstant: 25).isActive = true
        emailIcon.heightAnchor.constraint(equalToConstant: 25).isActive = true

        emailTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        emailTextField.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16).isActive = true
        emailTextField.leadingAnchor.constraint(equalTo: emailIcon.trailingAnchor, constant: 10).isActive = true
        emailTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10).isActive = true

        emailSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        emailSeparatorView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10).isActive = true
        emailSeparatorView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10).isActive = true
        emailSeparatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 5).isActive = true

        passwordIcon.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15).isActive = true
        passwordIcon.topAnchor.constraint(equalTo: emailSeparatorView.bottomAnchor, constant: 28).isActive = true
        passwordIcon.widthAnchor.constraint(equalToConstant: 25).isActive = true
        passwordIcon.heightAnchor.constraint(equalToConstant: 25).isActive = true

        passwordTextField.topAnchor.constraint(equalTo: emailSeparatorView.bottomAnchor, constant: 27).isActive = true
        passwordTextField.leadingAnchor.constraint(equalTo: passwordIcon.trailingAnchor, constant: 10).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        passwordTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10).isActive = true

        passwordSeparator.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 5).isActive = true
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

    }
}
