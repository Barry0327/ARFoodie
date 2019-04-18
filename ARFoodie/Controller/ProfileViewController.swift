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

class ProfileViewController: UIViewController {

    var user: User?

    lazy var signOutBTN: UIBarButtonItem = {

        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 10, y: 10, width: 20, height: 20)
        button.addTarget(self, action: #selector(singOut), for: .touchUpInside)
        button.backgroundColor = .red

        let barButton = UIBarButtonItem(customView: button)
        return barButton

    }()

    let profileImageView: UIImageView = {

        let imgView = UIImageView()
        imgView.layer.cornerRadius = 85
        imgView.clipsToBounds = true
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.image = UIImage(named: "user")

        return imgView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.setRightBarButton(signOutBTN, animated: true)

        view.addSubview(profileImageView)

        setLayout()

        fetchUserInfo()

    }

    @objc func singOut() {

        if Auth.auth().currentUser != nil {

            print("did sign out")
            do {

                try Auth.auth().signOut()

                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let loginVC = storyboard.instantiateViewController(withIdentifier: "LogInViewController") as? LogInViewController {

                    self.present(loginVC, animated: true, completion: nil)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    func setLayout() {

        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -150).isActive = true

        profileImageView.widthAnchor.constraint(equalToConstant: 170).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 170).isActive = true

    }

    func fetchUserInfo() {

        Auth.auth().addStateDidChangeListener { (_, user) in

            guard let user = user else { return }

            print("triggerd")

            self.user = User.init(authData: user)

            let usersRef = Database.database().reference(withPath: "users")
            let currentUserRef = usersRef.child(self.user!.uid)

            currentUserRef.observeSingleEvent(of: .value, with: { (snapshot) in

                guard
                    let info = snapshot.value as? [String: Any],
                    let displayName = info["displayName"] as? String
                    else { return }

                self.user?.displayName = displayName

                self.fetchProfileImage()

            })
        }
    }

    func fetchProfileImage() {

        let storageRef = Storage.storage().reference().child("profileImages")

        guard let user = self.user else { return }

        let imageRef = storageRef.child("\(user.uid).png")

        let placeholder = UIImage(named: "user")

        self.profileImageView.sd_setImage(with: imageRef, placeholderImage: placeholder)

    }
}
