//
//  MapCell.swift
//  ARFoodie
//
//  Created by Chen Yi-Wei on 2019/4/3.
//  Copyright © 2019 Chen Yi-Wei. All rights reserved.
//

import Foundation
import MapKit

class MapCell: UITableViewCell {

    let mapView = MKMapView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {

        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(mapView)

        setMapView()

    }

    required init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)
    }

    func setMapView() {

        mapView.translatesAutoresizingMaskIntoConstraints = false

        mapView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        mapView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
    }
}
