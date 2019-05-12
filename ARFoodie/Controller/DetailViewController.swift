//
//  DetailViewController.swift
//  ARFoodie
//
//  Created by Chen Yi-Wei on 2019/4/24.
//  Copyright © 2019 Chen Yi-Wei. All rights reserved.
//

import UIKit
import GoogleMaps
import GoogleSignIn
import YTLiveStreaming
import Firebase
import FirebaseUI
import ChameleonFramework
import MessageUI

class DetailViewController: UIViewController, UINavigationControllerDelegate {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    var placeID: String = ""

    var comments = [Comment]()

    let restaurantsRef = Database.database().reference(withPath: "restaurants")

    let restaurantDetailManager = RestaurantDetailManager()

    var restaurantDetail = RestaurantDetail.init(
        name: "暫無資料",
        address: "暫無資料",
        phoneNumber: "暫無資料",
        photoRef: "暫無資料",
        coordinate: CLLocationCoordinate2D.init(),
        isOpening: nil,
        rating: 0,
        userRatingsTotal: 0
    )

    enum DetailSection {

        case information, map, comment

    }

    let detailSections: [DetailSection] = [

        .map,
        .information,
        .comment
    ]

    lazy var tableView: UITableView = {

        let tableView = UITableView()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        tableView.addGestureRecognizer(gesture)
        tableView.backgroundColor = UIColor.init(hexString: "F2EDEC")

        return tableView
    }()

    private let containerView: UIView = {

        let view = UIView()
        view.backgroundColor = UIColor.white
        view.isOpaque = true

        return view
    }()

    let commentTextField: UITextField = {

        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "留言..."

        return textField

    }()

    lazy var sendButton: UIButton = {
        let button = UIButton()
        button.setTitle("發佈", for: .normal)
        button.setTitleColor(UIColor.flatSkyBlue, for: .normal)
        button.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)

        return button
    }()

    lazy var dismissBTN: UIBarButtonItem = {

        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "icon-cross"), for: .normal)
        button.frame = CGRect(x: 11, y: 20, width: 19, height: 19)
        button.tintColor = UIColor.init(hexString: "F2EDEC")
        button.addTarget(self, action: #selector(self.backToLastView), for: .touchUpInside)

        let leftBarButton = UIBarButtonItem(customView: button)
        return leftBarButton
    }()

    lazy var createBoardcastBTN: UIBarButtonItem = {

        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 11, y: 20, width: 35, height: 35)
        button.setImage(UIImage(named: "icons8-video-call-100"), for: .normal)
        button.imageView?.contentMode = .scaleToFill
        button.addTarget(self, action: #selector(createBoardcast), for: .touchUpInside)
        button.tintColor = UIColor.init(hexString: "F2EDEC")

        let rightBarButton = UIBarButtonItem(customView: button)
        return rightBarButton

    }()

    // MARK: - View Did Load Method

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self

        self.commentTextField.delegate = self

        tableView.register(InformationCell.self, forCellReuseIdentifier: "InformationCell")

        tableView.register(MapCell.self, forCellReuseIdentifier: "MapCell")

        tableView.register(CommentCell.self, forCellReuseIdentifier: "CommentCell")

        tableView.separatorStyle = .none

        self.navigationController?.navigationBar.barTintColor = UIColor.flatWatermelonDark

        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor(hexString: "F2EDEC")!,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 21, weight: .bold)
        ]

        self.navigationItem.setLeftBarButton(dismissBTN, animated: true)
        self.navigationItem.setRightBarButton(createBoardcastBTN, animated: true)

        view.addSubview(tableView)
        view.addSubview(containerView)
        containerView.addSubview(commentTextField)
        containerView.addSubview(sendButton)

        self.restaurantDetailManager.delegate = self
        self.restaurantDetailManager.fetchDetails(placeID: placeID)

        fetchComments()

        setLayout()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleKeyboardNotifiction(notifiction:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleKeyboardNotifiction(notifiction:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )

    }

    deinit {
        print("DetailView deinit")
    }

    private func setLayout() {

        containerView.anchor(
            top: nil,
            leading: self.view.leadingAnchor,
            bottom: self.view.bottomAnchor,
            trailing: self.view.trailingAnchor,
            size: .init(width: 0, height: 50)
        )

        sendButton.anchor(
            top: containerView.topAnchor,
            leading: nil,
            bottom: nil,
            trailing: containerView.trailingAnchor,
            padding: .init(top: 10, left: 0, bottom: 0, right: 10),
            size: .init(width: 50, height: 30)
        )

        commentTextField.anchor(
            top: containerView.topAnchor,
            leading: containerView.leadingAnchor,
            bottom: nil,
            trailing: sendButton.leadingAnchor,
            padding: .init(top: 10, left: 10, bottom: 0, right: 10),
            size: .init(width: 0, height: 30)
        )

        tableView.anchor(
            top: view.topAnchor,
            leading: view.leadingAnchor,
            bottom: containerView.topAnchor,
            trailing: view.trailingAnchor
        )
    }

    func fetchComments() {

        let restaurantRef = restaurantsRef.child(self.placeID)
        let commentRef = restaurantRef.child("comments")

        commentRef.observe(.value) { [weak self] snapshot in

            var comments = [Comment]()

            for child in snapshot.children {

                if
                    let snapshot = child as? DataSnapshot,
                    let comment = Comment.init(snapshot: snapshot) {

                    comments.append(comment)
                }
            }

            DispatchQueue.main.async { [weak self] in

                guard let self = self else { return }

                self.comments = comments

                self.tableView.reloadData()
            }
        }
    }
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {

        return self.detailSections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        let section = detailSections[section]

        switch section {

        case .comment:

            if self.comments.count == 0 {

                return 1

            } else {

                return self.comments.count

            }

        default: return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let section = detailSections[indexPath.section]

        switch section {

        case .map:

            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MapCell", for: indexPath) as? MapCell else { fatalError() }

            cell.restaurantDetail = self.restaurantDetail

            cell.placeID = self.placeID

            return cell

        case .information:

            guard let cell = tableView.dequeueReusableCell(withIdentifier: "InformationCell", for: indexPath) as? InformationCell else { fatalError() }

            cell.restaurantDetail = self.restaurantDetail

            return cell

        case .comment:

            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as? CommentCell else { fatalError() }

            if self.comments.count == 0 {

                cell.comment = nil

                return cell

            } else {

                cell.comment = self.comments[indexPath.row]

                return cell

            }
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        let section = detailSections[indexPath.section]

        switch section {

        case .information:
            return 120
        case .map:
            return 200
        case .comment:
            return UITableView.automaticDimension
        }
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {

        let section = detailSections[indexPath.section]

        switch section {

        case .comment:

            guard self.comments.count > 0 else { return false }

            return true

        default: return false

        }
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {

        let section = detailSections[indexPath.section]

        switch section {
        case .comment:

            let report = UITableViewRowAction(style: .destructive, title: "檢舉") { (_, indexPath) in

                let composeVC = MFMailComposeViewController()
                composeVC.delegate = self
                composeVC.mailComposeDelegate = self

                composeVC.setToRecipients(["fm334142@gmail.com"])
                composeVC.setSubject("檢舉評論")

                let messageBody: String = "被檢舉者 UserID: \n\(self.comments[indexPath.row].senderUid)\n\n評論UID:\n\(self.comments[indexPath.row].commentUID!)\n\n請簡短描述檢舉原因:"

                composeVC.setMessageBody(messageBody, isHTML: false)

                self.present(composeVC, animated: true, completion: nil)

            }

            return [report]

        default:
            return nil
        }
    }

}

extension DetailViewController: MFMailComposeViewControllerDelegate {

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {

        print("called")

        controller.dismiss(animated: true, completion: nil)

    }
}

extension DetailViewController: RestaurantDetailDelegate {

    func manager(_ manager: RestaurantDetailManager, didFetch restaurant: RestaurantDetail) {

        self.restaurantDetail = restaurant

        self.navigationItem.title = restaurant.name

        self.tableView.reloadData()

    }

    func manager(_ manager: RestaurantDetailManager, didFailed with: Error) {

        AuthenticationError.connetError.alert(message: with.localizedDescription)

    }
}
