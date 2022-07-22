//
//  RestaurantPinView.swift
//  ARFoodie
//
//  Created by Barry Chen on 2021/4/6.
//  Copyright © 2021 Chen Yi-Wei. All rights reserved.
//

import UIKit
import Cosmos
import CoreLocation.CLLocation

class RestaurantPinView: NiblessView {
    // MARK: Properties
    let nameLabel: UILabel = UILabel {
        $0.frame = CGRect(x: 5, y: 5, width: 230, height: 30)
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        $0.adjustsFontSizeToFitWidth = true
    }

    let ratingView: CosmosView = CosmosView {
        $0.frame = CGRect(x: 5, y: 35, width: 150, height: 30)
        $0.settings.updateOnTouch = false
        $0.settings.starSize = 16
        $0.settings.starMargin = 1
        $0.settings.fillMode = .half
        $0.settings.filledColor = UIColor.flatWatermelonDark()
        $0.settings.filledBorderColor = UIColor.flatWatermelonDark()
        $0.settings.emptyBorderColor = UIColor.flatWatermelonDark()
    }

    let distanceLabel: UILabel = UILabel {
        $0.frame = CGRect(x: 160, y: 30, width: 90, height: 30)
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textColor = UIColor(r: 79, g: 79, b: 79, a: 1)
    }
    // MARK: Methods
    init(restaurant: Restaurant, currentLocation: CLLocation?) {
        super.init(frame: CGRect(x: 0, y: 0, width: 240, height: 70))
        nameLabel.text = restaurant.name

        let rating = restaurant.rating ?? 0
        let userRatingTotal = restaurant.userRatingsTotal ?? 0
        ratingView.rating = rating
        ratingView.text = String(format: "%.0f", userRatingTotal)

        if let currentLocation = currentLocation {
            let distance = currentLocation.distance(from: restaurant.location)
            distanceLabel.text = "\(String(format: "%.1f", distance))m"
        }

        isOpaque = false
        backgroundColor = UIColor(hexString: "F2EDEC")?.withAlphaComponent(0.7)
        layer.applySketchShadow()
        constructViewHierarchy()
        drawPinShape()
    }

    private func constructViewHierarchy() {
        addSubview(nameLabel)
        addSubview(ratingView)
        addSubview(distanceLabel)
    }

    private func drawPinShape() {
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 240, height: 60), cornerRadius: 5)
        path.move(to: CGPoint(x: 115, y: 60))
        path.addLine(to: CGPoint(x: 125, y: 70))
        path.addLine(to: CGPoint(x: 135, y: 60))
        path.close()

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath

        layer.mask = shapeLayer
    }
}
