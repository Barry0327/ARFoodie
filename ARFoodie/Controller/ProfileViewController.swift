//
//  ProfileViewController.swift
//  ARFoodie
//
//  Created by Chen Yi-Wei on 2019/4/14.
//  Copyright © 2019 Chen Yi-Wei. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
import ChameleonFramework
import GoogleSignIn

class ProfileViewController: UIViewController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    let firebaseManager = FirebaseManager.shared

    var currentUser: User?

    let topContainterView: UIView = {

        let view = UIView()
        view.backgroundColor = UIColor.flatWatermelonDark

        return view
    }()

    lazy var signOutBTN: UIButton = {

        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(singOut), for: .touchUpInside)
        button.setImage(UIImage(named: "sign-out-option"), for: .normal)
        button.tintColor = .white

        return button

    }()

    let titleLabel: UILabel = {

        let label = UILabel()
        label.text = "個人檔案"
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)

        return label
    }()

    lazy var profileImageView: UIImageView = {

        let imgView = UIImageView()
        imgView.layer.cornerRadius = 100
        imgView.layer.borderWidth = 5
        imgView.layer.borderColor = UIColor.white.cgColor
        imgView.clipsToBounds = true
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.image = UIImage(named: "user")
        imgView.isUserInteractionEnabled = true
        imgView.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(profileImageViewSelectHandler)
            )
        )

        return imgView

    }()

    let bottomContainerView: UIView = {

        let view = UIView()
        view.backgroundColor = UIColor(hexString: "#faefd1")
        return view
    }()

    let nameLabel: UILabel = {

        let label = UILabel()
        label.text = "用戶名稱"

        return label
    }()

    let emailLabel: UILabel = {

        let label = UILabel()
        label.text = "帳號"

        return label
    }()

    let passwordLabel: UILabel = {

        let label = UILabel()
        label.text = "密碼"

        return label
    }()

    let nameContent: UILabel = {

        let label = UILabel()
        label.text = "Barry"

        return label
    }()

    let emailContent: UILabel = {

        let label = UILabel()
        label.text = "fm334142@gmail.com"

        return label
    }()

    lazy var changePasswordBTN: UIButton = {

        let button = UIButton()
        button.setTitle("變更密碼", for: .normal)
        button.setTitleColor(UIColor.flatSkyBlue, for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(changePasswordTapped), for: .touchUpInside)

        return button
    }()

    let connectedAccountLabel: UILabel = {

        let label = UILabel()
        label.text = "已連結的Youtube帳號"

        return label

    }()

    let youtubeAccountLabel: UILabel = {

        let label = UILabel()
        label.text = "fm334142@gmail.com"

        return label

    }()

    lazy var youtubeConnectBTN: UIButton = {

        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        button.setTitleColor(UIColor.flatSkyBlue, for: .normal)
        button.addTarget(self, action: #selector(youtubeConnectHandler), for: .touchUpInside)
        button.contentHorizontalAlignment = .left

        return button
    }()

    // MARK: - View Did Load

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(hexString: "#faefd1")

        firebaseManager.fetchUserInfo { [weak self] in

            guard let self = self else { return }
            self.currentUser = CurrentUser.shared.user
            self.nameContent.text = self.currentUser?.displayName
            self.emailContent.text = self.currentUser?.email
            self.fetchProfileImage()
        }

        view.addSubview(topContainterView)
        view.addSubview(signOutBTN)
        view.addSubview(profileImageView)
        view.addSubview(bottomContainerView)
        view.addSubview(titleLabel)

        bottomContainerView.addSubview(nameLabel)
        bottomContainerView.addSubview(emailLabel)
        bottomContainerView.addSubview(passwordLabel)

        bottomContainerView.addSubview(nameContent)
        bottomContainerView.addSubview(emailContent)
        bottomContainerView.addSubview(changePasswordBTN)

        bottomContainerView.addSubview(connectedAccountLabel)
        bottomContainerView.addSubview(youtubeAccountLabel)
        bottomContainerView.addSubview(youtubeConnectBTN)

        setTopLayout()
        setBottomLayout()

        checkYoutubeConnectState()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        checkYoutubeConnectState()

    }

    @objc func singOut() {

        if Auth.auth().currentUser != nil {

            print("did sign out")

            do {

                try Auth.auth().signOut()

                GIDSignIn.sharedInstance()?.signOut()

                CurrentUser.shared.user = nil

                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let loginVC = storyboard.instantiateViewController(withIdentifier: "LogInViewController") as? LogInViewController {

                    self.present(loginVC, animated: true, completion: nil)
                }

            } catch {

                AuthenticationError.connetError.alert(message: error.localizedDescription)

                print(error.localizedDescription)

            }
        } else {
            AuthenticationError.connetError.alert(message: "您尚未登入")
        }
    }

    // MARK: - Auto Layout Method

    func setTopLayout() {

        titleLabel.anchor(
            top: view.topAnchor,
            leading: nil,
            bottom: nil,
            trailing: nil,
            padding: .init(top: 20, left: 0, bottom: 0, right: 0),
            size: .init(width: 150, height: 30)
        )

        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        topContainterView.anchor(
            top: view.topAnchor,
            leading: view.leadingAnchor,
            bottom: nil,
            trailing: view.trailingAnchor,
            size: .init(width: 0, height: 270)
        )

        signOutBTN.anchor(
            top: nil,
            leading: nil,
            bottom: nil,
            trailing: view.trailingAnchor,
            padding: .init(top: 20, left: 0, bottom: 0, right: 10),
            size: .init(width: 20, height: 20)
        )

        signOutBTN.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true

        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 90).isActive = true

        profileImageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true

    }

    func setBottomLayout() {

        bottomContainerView.anchor(
            top: profileImageView.bottomAnchor,
            leading: nil,
            bottom: view.bottomAnchor,
            trailing: nil,
            padding: .init(top: 15, left: 0, bottom: 30, right: 0),
            size: .init(width: 330, height: 0)
        )

        bottomContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        nameLabel.anchor(
            top: bottomContainerView.topAnchor,
            leading: bottomContainerView.leadingAnchor,
            bottom: nil,
            trailing: nil,
            padding: .init(top: 40, left: 20, bottom: 0, right: 0),
            size: .init(width: 100, height: 30)
        )

        emailLabel.anchor(
            top: nameLabel.bottomAnchor,
            leading: bottomContainerView.leadingAnchor,
            bottom: nil,
            trailing: nil,
            padding: .init(top: 10, left: 20, bottom: 0, right: 0),
            size: .init(width: 100, height: 30)
        )

        passwordLabel.anchor(
            top: emailLabel.bottomAnchor,
            leading: bottomContainerView.leadingAnchor,
            bottom: nil,
            trailing: nil,
            padding: .init(top: 10, left: 20, bottom: 0, right: 0),
            size: .init(width: 100, height: 30)
        )

        nameContent.anchor(
            top: nil,
            leading: bottomContainerView.leadingAnchor,
            bottom: nil,
            trailing: bottomContainerView.trailingAnchor,
            padding: .init(top: 0, left: 130, bottom: 0, right: 10),
            size: .init(width: 0, height: 30)
        )

        nameContent.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor).isActive = true

        emailContent.anchor(
            top: nil,
            leading: nameContent.leadingAnchor,
            bottom: nil,
            trailing: bottomContainerView.trailingAnchor,
            padding: .init(top: 0, left: 0, bottom: 0, right: 10),
            size: .init(width: 0, height: 30)
        )

        emailContent.centerYAnchor.constraint(equalTo: emailLabel.centerYAnchor).isActive = true

        changePasswordBTN.anchor(
            top: nil,
            leading: emailContent.leadingAnchor,
            bottom: nil,
            trailing: nil,
            padding: .init(top: 0, left: 0, bottom: 0, right: 0),
            size: .init(width: 70, height: 20)
        )

        changePasswordBTN.centerYAnchor.constraint(equalTo: passwordLabel.centerYAnchor).isActive = true

        connectedAccountLabel.anchor(
            top: passwordLabel.bottomAnchor,
            leading: passwordLabel.leadingAnchor,
            bottom: nil,
            trailing: bottomContainerView.trailingAnchor,
            padding: .init(top: 30, left: 0, bottom: 0, right: 10),
            size: .init(width: 0, height: 30)
        )

        youtubeAccountLabel.anchor(
            top: connectedAccountLabel.bottomAnchor,
            leading: nameLabel.leadingAnchor,
            bottom: nil,
            trailing: bottomContainerView.trailingAnchor,
            padding: .init(top: 10, left: 0, bottom: 0, right: 10),
            size: .init(width: 0, height: 30)
        )

        youtubeConnectBTN.anchor(
            top: youtubeAccountLabel.bottomAnchor,
            leading: nameLabel.leadingAnchor,
            bottom: nil,
            trailing: nil,
            padding: .init(top: 5, left: 0, bottom: 0, right: 0),
            size: .init(width: 100, height: 30)
        )
    }

    func fetchProfileImage() {

        guard let user = currentUser else { return }

        let storageRef = Storage.storage().reference().child("profileImages")

        let imageRef = storageRef.child("\(user.profileImageUID!).png")

        let placeholder = UIImage(named: "user")

        self.profileImageView.sd_setImage(with: imageRef, placeholderImage: placeholder)

    }
}
