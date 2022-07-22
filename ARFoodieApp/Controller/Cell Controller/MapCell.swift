//
//  MapCell.swift
//  ARFoodie
//
//  Created by Chen Yi-Wei on 2019/4/3.
//  Copyright © 2019 Chen Yi-Wei. All rights reserved.
//

import Foundation
import MapKit
import GoogleMaps

class MapCell: UITableViewCell, GMSMapViewDelegate {

    private let mapView = GMSMapView()

    var placeID: String = ""

    var restaurantDetail: RestaurantDetail? {

        didSet {
            let camera = GMSCameraPosition.camera(withTarget: restaurantDetail!.coordinate, zoom: 16.0)
            self.mapView.camera = camera
            let marker = GMSMarker()
            marker.position = restaurantDetail!.coordinate
            marker.title = restaurantDetail!.name
            marker.map = self.mapView
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {

        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(mapView)

        self.mapView.delegate = self

        setMapView()

        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true

    }

    required init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)
    }

    private func setMapView() {

        mapView.translatesAutoresizingMaskIntoConstraints = false

        mapView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        mapView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
    }

    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {

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
