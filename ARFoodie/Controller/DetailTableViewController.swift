//
//  DetailTableViewController.swift
//  ARFoodie
//
//  Created by Chen Yi-Wei on 2019/4/1.
//  Copyright © 2019 Chen Yi-Wei. All rights reserved.
//

import UIKit
import MapKit

class DetailTableViewController: UITableViewController {

    var placeID: String = ""

    let restaurantDetailManager = RestaurantDetailManager.shared

    var restaurantDetail = RestaurantDetail.init(
        name: "暫無資料",
        address: "暫無資料",
        phoneNumber: "暫無資料",
        photoRef: "",
        coordinate: CLLocationCoordinate2D.init()
    )

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

        self.restaurantDetailManager.fetchDetails(placeID: placeID)

        restaurantDetailManager.delegate = self

        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "icon-cross"), for: .normal)
        button.frame = CGRect(x: 11, y: 20, width: 19, height: 19)
        button.tintColor = .black
        button.addTarget(self, action: #selector(self.backToLastView), for: .touchUpInside)

        let leftBarButton = UIBarButtonItem(customView: button)
        self.navigationItem.setRightBarButton(leftBarButton, animated: true)

        tableView.register(PhotoCell.self, forCellReuseIdentifier: "PhotoCell")

        tableView.register(InfoCell.self, forCellReuseIdentifier: "InfoCell")

        tableView.register(MapCell.self, forCellReuseIdentifier: "MapCell")

//        tableView.separatorStyle = .none

    }

    @objc func backToLastView() {
        self.dismiss(animated: true, completion: nil)
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
                cell.infoLabel.text = "9:00 ~ 18:00"

                return cell
            }
        case .map:

            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MapCell", for: indexPath) as? MapCell else { fatalError() }

            let annotation = MKPointAnnotation()
            let coordinate = restaurantDetail.coordinate
            annotation.coordinate = coordinate

            cell.mapView.addAnnotation(annotation)
            let region = MKCoordinateRegion.init(center: coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
            cell.mapView.setRegion(region, animated: true)

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
                print("Call")
                return

            case .businessHours:
                return
            default:
                return
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
