//
//  ProfileViewController.swift
//  ARFoodie
//
//  Created by Chen Yi-Wei on 2019/4/14.
//  Copyright © 2019 Chen Yi-Wei. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {

    lazy var signOutBTN: UIBarButtonItem = {

        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 10, y: 10, width: 20, height: 20)
        button.addTarget(self, action: #selector(singOut), for: .touchUpInside)
        button.backgroundColor = .red

        let barButton = UIBarButtonItem(customView: button)
        return barButton

    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.setRightBarButton(signOutBTN, animated: true)

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
}
