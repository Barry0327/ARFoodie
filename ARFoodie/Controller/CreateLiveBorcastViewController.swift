//
//  CreateLiveBorcastViewController.swift
//  ARFoodie
//
//  Created by Chen Yi-Wei on 2019/4/16.
//  Copyright © 2019 Chen Yi-Wei. All rights reserved.
//

import UIKit
import YTLiveStreaming
import IHProgressHUD

class CreateLiveBoardcastViewController: UIViewController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    let input: YTLiveStreaming = YTLiveStreaming()

    let containerView: UIView = {

        let view = UIView()
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hexString: "F2EDEC")!

        return view
    }()

    let titleLabel: UILabel = {

        let label = UILabel()
        label.text = "標題"
        label.textColor = UIColor(hexString: "#ea5959")

        return label
    }()

    let titleTextField: UITextField = {

        let textField = UITextField()
        textField.placeholder = "請填入直播標題"
        textField.borderStyle = .roundedRect

        return textField
    }()

    let descriptionLabel: UILabel = {

        let label = UILabel()
        label.text = "描述(選填)"
        label.textColor = UIColor(hexString: "#ea5959")

        return label
    }()

    let descriptionTextField: UITextField = {

        let textField = UITextField()
        textField.placeholder = "請輸入直播內容描述"
        textField.borderStyle = .roundedRect

        return textField
    }()

    lazy var cancelButton: UIButton = {

        let button = UIButton()
        button.layer.cornerRadius = 20
        button.layer.borderColor = UIColor(hexString: "ef5a5a")?.cgColor
        button.layer.borderWidth = 2
        button.backgroundColor = .clear
        let textAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: UIColor(hexString: "ef5a5a")!,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22, weight: .bold)
        ]
        let attributeString = NSAttributedString(string: "取消", attributes: textAttributes)
        button.setAttributedTitle(attributeString, for: .normal)
        button.addTarget(self, action: #selector(cancelBTNPressed), for: .touchUpInside)

        return button
    }()

    lazy var startButton: UIButton = {

        let button = UIButton()
        button.layer.cornerRadius = 20
        let textAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: UIColor(hexString: "F2EDEC")!,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22, weight: .bold)
        ]
        let attributeString = NSAttributedString(string: "確認", attributes: textAttributes)
        button.setAttributedTitle(attributeString, for: .normal)
        button.backgroundColor = UIColor(hexString: "#ea5959")
        button.addTarget(self, action: #selector(starBTNPressed), for: .touchUpInside)

        return button
    }()

    let hintLabel: UILabel = {

        let label = UILabel()
        label.text = "您的直播將公開於Youtube平台上"
        label.adjustsFontSizeToFitWidth = true
        label.textColor = UIColor(hexString: "#ea5959")
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center

        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.hideKeyboardWhenTappedAround()

        titleTextField.delegate = self
        descriptionTextField.delegate = self

        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        view.isOpaque = true

        view.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(titleTextField)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(descriptionTextField)
        containerView.addSubview(cancelButton)
        containerView.addSubview(startButton)
        containerView.addSubview(hintLabel)

        setLayout()
    }

    @objc func starBTNPressed() {

//        guard
//            let title = self.titleTextField.text,
//            title.count > 0
//
//            else {
//
//                AuthenticationError.invalidInformation.alert(message: "請輸入直播標題")
//
//                return
//        }
//
//        IHProgressHUD.show(withStatus: "連線中")
//
//        let description = self.descriptionTextField.text
//
//        let date = Date.init()
//
//        self.input.createBroadcast(title, description: description, startTime: date) { (boardcast) in
//
//            guard let boardcast = boardcast else {
//
//                AuthenticationError.connetError.alert(message: "請確認您已啟用Youtube的直播功能")
//
//                return
//            }
//
//            print(boardcast)
//
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//
//            if let lfViewController = storyboard.instantiateViewController(withIdentifier: "LFLiveViewController") as? LFLiveViewController {
//
//                lfViewController.boardcast = boardcast
//
//                DispatchQueue.main.async { [weak self] in
//
//                    guard let self = self else { return }
//
//                    IHProgressHUD.dismiss()
//
//                    self.present(lfViewController, animated: true, completion: nil)
//
//                }
//            }
//        }
    }

    @objc func cancelBTNPressed() {

        self.dismiss(animated: true, completion: nil)
    }

    func setLayout() {

        containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        containerView.widthAnchor.constraint(equalToConstant: 250).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 320).isActive = true

        titleLabel.anchor(
            top: containerView.topAnchor,
            leading: containerView.leadingAnchor,
            bottom: nil,
            trailing: nil,
            padding: .init(top: 30, left: 20, bottom: 0, right: 0),
            size: .init(width: 70, height: 30)
        )

        titleTextField.anchor(
            top: titleLabel.bottomAnchor,
            leading: containerView.leadingAnchor,
            bottom: nil,
            trailing: containerView.trailingAnchor,
            padding: .init(top: 10, left: 20, bottom: 0, right: 20),
            size: .init(width: 0, height: 30)
        )

        descriptionLabel.anchor(
            top: titleTextField.bottomAnchor,
            leading: containerView.leadingAnchor,
            bottom: nil,
            trailing: nil,
            padding: .init(top: 20, left: 20, bottom: 0, right: 0),
            size: .init(width: 100, height: 30)
        )

        descriptionTextField.anchor(
            top: descriptionLabel.bottomAnchor,
            leading: containerView.leadingAnchor,
            bottom: nil,
            trailing: containerView.trailingAnchor,
            padding: .init(top: 10, left: 20, bottom: 0, right: 20),
            size: .init(width: 0, height: 30)
        )

        cancelButton.anchor(
            top: descriptionTextField.bottomAnchor,
            leading: containerView.leadingAnchor,
            bottom: nil,
            trailing: nil,
            padding: .init(top: 30, left: 20, bottom: 0, right: 0),
            size: .init(width: 90, height: 40)
        )

        startButton.anchor(
            top: descriptionTextField.bottomAnchor,
            leading: nil,
            bottom: nil,
            trailing: containerView.trailingAnchor,
            padding: .init(top: 30, left: 0, bottom: 0, right: 20),
            size: .init(width: 90, height: 40)
        )

        hintLabel.anchor(
            top: nil,
            leading: containerView.leadingAnchor,
            bottom: containerView.bottomAnchor,
            trailing: containerView.trailingAnchor,
            padding: .init(top: 0, left: 10, bottom: 15, right: 10),
            size: .init(width: 0, height: 15)
        )
    }
}

extension CreateLiveBoardcastViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        switch textField {

        case self.titleTextField:

            self.descriptionTextField.becomeFirstResponder()

        default:

            self.starBTNPressed()

        }

        return false

    }
}
