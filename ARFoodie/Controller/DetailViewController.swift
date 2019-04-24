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

class DetailViewController: UIViewController {

    var placeID: String = ""

    var comments = [Comment]()

    let restaurantsRef = Database.database().reference(withPath: "restaurants")

    let restaurantDetailManager = RestaurantDetailManager.shared

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
        tableView.delegate = self
        tableView.dataSource = self

        return tableView
    }()

    let containerView: UIView = {

        let view = UIView()
        view.backgroundColor = UIColor.flatNavyBlueDark
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
        button.tintColor = .black
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
        button.tintColor = .black

        let rightBarButton = UIBarButtonItem(customView: button)
        return rightBarButton

    }()

    // MARK: - View Did Load Method

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.barTintColor = UIColor.flatWatermelonDark

        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor(hexString: "feffdf")!,
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

        tableView.register(InformationCell.self, forCellReuseIdentifier: "InformationCell")

        tableView.register(MapCell.self, forCellReuseIdentifier: "MapCell")

        tableView.register(CommentCell.self, forCellReuseIdentifier: "CommentCell")

    }

    func setLayout() {

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

        commentRef.observe(.value) { (snapshot) in

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

            let camera = GMSCameraPosition.camera(withTarget: restaurantDetail.coordinate, zoom: 16.0)
            cell.mapView.camera = camera
            cell.mapView.delegate = self

            let marker = GMSMarker()
            marker.position = restaurantDetail.coordinate
            marker.title = restaurantDetail.name
            marker.map = cell.mapView

            return cell

        case .information:

            guard let cell = tableView.dequeueReusableCell(withIdentifier: "InformationCell", for: indexPath) as? InformationCell else { fatalError() }

            cell.nameLabel.text = restaurantDetail.name

            cell.phoneLabel.text = restaurantDetail.phoneNumber

            cell.addressLabel.text = restaurantDetail.address

            cell.imgView.fetchImage(with: restaurantDetail.photoRef)

            cell.ratingView.rating = restaurantDetail.rating ?? 0

            cell.ratingView.text = String(format: "%.0f", restaurantDetail.userRatingsTotal ?? 0)

            if restaurantDetail.isOpening != nil {

                if restaurantDetail.isOpening! {
                    cell.isOpeningIcon.image = UIImage(named: "icons8-open-sign-100")
                } else {
                    cell.isOpeningIcon.image = UIImage(named: "icons8-closed-sign-100")
                }
            }

            return cell

        case .comment:

            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as? CommentCell else { fatalError() }

            if self.comments.count == 0 {

                cell.commentBody.text = "尚無評論"
                cell.commentBody.textColor = .gray

                return cell

            } else {

                cell.nameLabel.text = self.comments[indexPath.row].senderName
                cell.commentBody.text = self.comments[indexPath.row].content
                cell.commentBody.textColor = .black

                let storageRef = Storage.storage().reference().child("profileImages")

                let usersRef = Database.database().reference().child("users")

                let userRef = usersRef.child(self.comments[indexPath.row].senderUid)

                userRef.observeSingleEvent(of: .value) { (snapshot) in

                    guard
                        let info = snapshot.value as? [String: Any],
                        let imgUID = info["profileImageUID"] as? String
                        else { return }

                    let imageRef = storageRef.child("\(imgUID).png")

                    let placeholder = UIImage(named: "user")

                    cell.profileImageView.sd_setImage(with: imageRef, placeholderImage: placeholder)

                }

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
}

extension DetailViewController: GMSMapViewDelegate {

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
