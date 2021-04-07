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

class MapCell: UITableViewCell {

    let mapView = GMSMapView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(mapView)
        activateConstraintsMapView()

        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func activateConstraintsMapView() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        let top = mapView.topAnchor
            .constraint(equalTo: contentView.topAnchor)
        let bottom = mapView.bottomAnchor
            .constraint(equalTo: contentView.bottomAnchor)
        let trailing = mapView.trailingAnchor
            .constraint(equalTo: contentView.trailingAnchor)
        let leading = mapView.leadingAnchor
            .constraint(equalTo: contentView.leadingAnchor)

        NSLayoutConstraint.activate([
            top, bottom, trailing, leading
        ])
    }

    func config(with detail: RestaurantDetail) {
        let camera = GMSCameraPosition.camera(withTarget: detail.coordinate, zoom: 16.0)
        mapView.camera = camera

        let marker = GMSMarker()
        marker.position = detail.coordinate
        marker.title = detail.name
        marker.map = mapView
    }
}
