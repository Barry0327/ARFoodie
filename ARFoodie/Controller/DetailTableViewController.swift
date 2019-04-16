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

class DetailTableViewController: UITableViewController, GIDSignInUIDelegate {

    var placeID: String = ""

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

    enum InformationRow {

        case phoneNumber, address, businessHours

    }

    enum DetailSection {

        case information(rows: [InformationRow])

        case photo

        case map
    }

    let detailSections: [DetailSection] = [

        .photo,
        .information(rows: [.phoneNumber, .address, .businessHours]),
        .map
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        print(placeID)

        self.restaurantDetailManager.delegate = self
        self.restaurantDetailManager.fetchDetails(placeID: placeID)

        self.navigationItem.setLeftBarButton(dismissBTN, animated: true)
        self.navigationItem.setRightBarButton(createBoardcastBTN, animated: true)

        tableView.register(PhotoCell.self, forCellReuseIdentifier: "PhotoCell")

        tableView.register(InfoCell.self, forCellReuseIdentifier: "InfoCell")

        tableView.register(MapCell.self, forCellReuseIdentifier: "MapCell")

//        tableView.separatorStyle = .none

    }

    // MARK: - UIBarButtonItem Action

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

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return detailSections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        let section = detailSections[section]

        switch section {
        case .photo, .map:
            return 1
        case let .information(rows): return rows.count
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
