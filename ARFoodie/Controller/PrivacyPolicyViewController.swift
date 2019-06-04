//
//  PrivacyPolicyViewController.swift
//  ARFoodie
//
//  Created by Chen Yi-Wei on 2019/4/26.
//  Copyright © 2019 Chen Yi-Wei. All rights reserved.
//

import UIKit

class PrivacyPolicyViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!

    private lazy var dismissBTN: UIBarButtonItem = {

        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "icon-cross"), for: .normal)
        button.frame = CGRect(x: 11, y: 20, width: 19, height: 19)
        button.tintColor = UIColor.init(hexString: "F2EDEC")
        button.addTarget(self, action: #selector(self.backToLastView), for: .touchUpInside)

        let rightBarButton = UIBarButtonItem(customView: button)
        return rightBarButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.barTintColor = UIColor.flatWatermelonDark

        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor(hexString: "F2EDEC")!,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 21, weight: .bold)
        ]

        self.navigationItem.title = "隱私權政策"

        self.navigationItem.setRightBarButton(dismissBTN, animated: true)

        setLayout()

    }

    func setLayout() {

        textView.anchor(
            top: view.topAnchor,
            leading: view.leadingAnchor,
            bottom: view.bottomAnchor,
            trailing: view.trailingAnchor
        )
    }

    @objc func backToLastView() {
        self.dismiss(animated: true, completion: nil)
    }
}
