//
//  DetailTableViewController.swift
//  ARFoodie
//
//  Created by Chen Yi-Wei on 2019/4/1.
//  Copyright © 2019 Chen Yi-Wei. All rights reserved.
//

import UIKit
import GoogleMaps
import GoogleSignIn
import YTLiveStreaming
import Firebase
import FirebaseUI
import ChameleonFramework

class DetailTableViewController: UITableViewController, GIDSignInUIDelegate {

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
        businessHours: "暫無資料"
    )

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

    enum InformationRow {

        case phoneNumber, address, businessHours

    }

    enum DetailSection {

        case information(rows: [InformationRow])

        case photo

        case map

        case comment
    }

    let detailSections: [DetailSection] = [

        .photo,
        .information(rows: [.phoneNumber, .address, .businessHours]),
        .map,
        .comment
    ]

    // MARK: - View Did Load Method

    override func viewDidLoad() {
        super.viewDidLoad()

        print(placeID)

        self.navigationController?.navigationBar.barTintColor = UIColor.flatWatermelonDark

        self.tableView.backgroundColor = UIColor(hexString: "#faefd1")

        let gesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        self.tableView.addGestureRecognizer(gesture)

        fetchComments()

        self.navigationController?.view.addSubview(containerView)

        containerView.addSubview(commentTextField)
        containerView.addSubview(sendButton)

        setUpTextFieldLayOut()

        self.restaurantDetailManager.delegate = self
        self.restaurantDetailManager.fetchDetails(placeID: placeID)

        self.navigationItem.setLeftBarButton(dismissBTN, animated: true)
        self.navigationItem.setRightBarButton(createBoardcastBTN, animated: true)

        tableView.register(PhotoCell.self, forCellReuseIdentifier: "PhotoCell")

        tableView.register(InfoCell.self, forCellReuseIdentifier: "InfoCell")

        tableView.register(MapCell.self, forCellReuseIdentifier: "MapCell")

        tableView.register(CommentCell.self, forCellReuseIdentifier: "CommentCell")

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

    func setUpTextFieldLayOut() {

        containerView.anchor(
            top: nil,
            leading: self.navigationController?.view.leadingAnchor,
            bottom: self.navigationController?.view.bottomAnchor,
            trailing: self.navigationController?.view.trailingAnchor,
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

    }

    @objc func tableViewTapped() {
        self.commentTextField.endEditing(true)
    }

    @objc func handleKeyboardNotifiction(notifiction: Notification) {

        guard
            let keybroadFrame = notifiction.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
            else { return }

        let keyboardHeight = keybroadFrame.cgRectValue.height

        let isKeyboardShowing = notifiction.name == UIResponder.keyboardWillShowNotification

        self.navigationController?.view.frame.origin.y = isKeyboardShowing ? -keyboardHeight : 0

        UIView.animate(withDuration: 0.3) {

            self.navigationController?.view.layoutIfNeeded()
        }
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

    // MARK: - UIBarButtonItem Action Mehod

    @objc func sendButtonTapped() {

        print("Triggered")
        self.commentTextField.endEditing(true)
        self.commentTextField.isEnabled = false
        self.sendButton.isEnabled = false

        let restaurantRef = restaurantsRef.child(self.placeID)
        let commentRef = restaurantRef.child("comments")

        guard
            let name = CurrentUser.shared.user?.displayName,
            let uid = CurrentUser.shared.user?.uid,
            let content = self.commentTextField.text
            else { return }

        let comment = Comment.init(name: name, uid: uid, content: content)

        commentRef.childByAutoId().setValue(comment.toAnyObject()) { (error, _) in

            if error != nil {
                print(error!)
            } else {

                print("send comment successfully")
                self.commentTextField.text = ""
                self.commentTextField.isEnabled = true
                self.sendButton.isEnabled = true
            }
        }
    }

    @objc func backToLastView() {
        self.dismiss(animated: true, completion: nil)
    }

    @objc func createBoardcast() {

        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.uiDelegate = self
        GIDSignIn.sharedInstance()?.scopes = [

            "https://www.googleapis.com/auth/youtube",
            "https://www.googleapis.com/auth/youtube.force-ssl"

        ]

        GIDSignIn.sharedInstance()?.signIn()
    }

    // MARK: - Table View Data Source Method

    override func numberOfSections(in tableView: UITableView) -> Int {
        return detailSections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        let section = detailSections[section]

        switch section {

        case .photo, .map: return 1

        case let .information(rows): return rows.count

        case .comment:

            if self.comments.count == 0 {

                return 1

            } else {

                return self.comments.count

            }
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let section = detailSections[indexPath.section]

        switch section {

        case .photo:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell", for: indexPath) as? PhotoCell else { fatalError() }

            cell.nameLabel.text = restaurantDetail.name
            cell.restImageView.fetchImage(with: restaurantDetail.photoRef)
            cell.selectionStyle = .none

            return cell

        case let .information(rows):

            guard let cell = tableView.dequeueReusableCell(withIdentifier: "InfoCell", for: indexPath) as? InfoCell else { fatalError() }

            let row = rows[indexPath.row]

            switch row {

            case .phoneNumber:

                cell.iconImageView.image = UIImage(named: "icons8-ringer-volume-100")
                cell.infoLabel.text = restaurantDetail.phoneNumber

                return cell

            case .address:

                cell.iconImageView.image = UIImage(named: "icons8-address-100")
                cell.infoLabel.text = restaurantDetail.address

                return cell

            case .businessHours:

                cell.iconImageView.image = UIImage(named: "icons8-open-sign-100")
                cell.infoLabel.text = restaurantDetail.businessHours

                return cell
            }
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

        case .comment:

            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as? CommentCell else { fatalError() }

            if self.comments.count == 0 {

                cell.commentBody.text = "尚無評論"
                cell.commentBody.textColor = .gray

                return cell

            } else {

                cell.nameLabel.text = self.comments[indexPath.row].senderName
                cell.commentBody.text = self.comments[indexPath.row].content

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

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        let section = detailSections[indexPath.section]

        switch section {
        case .photo:
            return 250
        case .information:
            return 60
        case .map:
            return 250
        case .comment:
            return UITableView.automaticDimension
        }
    }

    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {

        let section = detailSections[indexPath.section]

        switch section {
        case .photo:
            return 250
        case .information:
            return 60
        case .map:
            return 250
        case .comment:
            return 200
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)

        let section = detailSections[indexPath.section]

        switch section {

        case let .information(rows):

            let row = rows[indexPath.row]

            switch row {

            case .phoneNumber:
                let phoneNumber = restaurantDetail.phoneNumber.filter { "0123456789".contains($0)}
                print(phoneNumber)
                guard let number = URL(string: "tel://\(phoneNumber)") else { return }

                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(number)
                } else {
                    // Fallback on earlier versions
                    UIApplication.shared.openURL(number)
                }
                return

            case .businessHours:

                return

            case .address:
                guard let url = URL(
                    string: "https://www.google.com/maps/search/?api=1&query=restaurant&query_place_id=\(placeID)"
                    )
                    else {
                        return
                }
                UIApplication.shared.open(
                    url,
                    options: [UIApplication.OpenExternalURLOptionsKey.universalLinksOnly: true]
                )
            }

        default:
            return
        }
    }
}

extension DetailTableViewController: RestaurantDetailDelegate {

    func manager(_ manager: RestaurantDetailManager, didFetch restaurant: RestaurantDetail) {

        self.restaurantDetail = restaurant

        self.tableView.reloadData()

    }

    func manager(_ manager: RestaurantDetailManager, didFailed with: Error) {

        AuthenticationError.connetError.alert(message: with.localizedDescription)

    }
}

extension DetailTableViewController: GMSMapViewDelegate {

    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {

        guard let url = URL(
            string: "https://www.google.com/maps/search/?api=1&query=restaurant&query_place_id=\(placeID)"
            )
            else {
                return false
        }
        UIApplication.shared.open(
            url,
            options: [UIApplication.OpenExternalURLOptionsKey.universalLinksOnly: true]
        )
        return true
    }
}

extension DetailTableViewController: GIDSignInDelegate {

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {

        guard let currentUser = GIDSignIn.sharedInstance()?.currentUser else {
            return
        }

        GoogleOAuth2.sharedInstance.accessToken = currentUser.authentication.accessToken

        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        if let createLiveBoardcastViewController = storyboard.instantiateViewController(withIdentifier: "CreateLiveBoardcastViewController") as? CreateLiveBoardcastViewController {

            createLiveBoardcastViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            DispatchQueue.main.async { [weak self] in

                guard let self = self else { return }

                self.present(createLiveBoardcastViewController, animated: true, completion: nil)

            }
        }
    }
}
