//
//  ViewController.swift
//  ARFoodie
//
//  Created by Chen Yi-Wei on 2019/3/27.
//  Copyright © 2019 Chen Yi-Wei. All rights reserved.
//
import ARCL
import CoreLocation
import UIKit
import MapKit

class MainARViewController: UIViewController, CLLocationManagerDelegate {

    var sceneLocationView = SceneLocationView()

    let restaurantInfoManager = RestaurantInfoManager.shared

    var restaurants: [Restaurant] = []

    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.startReceivingLocationChanges()

        self.restaurantInfoManager.delegate = self

        view.addSubview(self.sceneLocationView)

    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.sceneLocationView.frame = view.bounds
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.sceneLocationView.run()

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.sceneLocationView.pause()
    }

    func startReceivingLocationChanges() {

        self.locationManager.requestWhenInUseAuthorization()
        let authorizationStatus = CLLocationManager.authorizationStatus()
        if authorizationStatus != .authorizedWhenInUse && !CLLocationManager.locationServicesEnabled() {
            return
        }

        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        if let location = locations.last {

            if location.horizontalAccuracy > 0 {

                self.locationManager.stopUpdatingLocation()
                let latitude = String(location.coordinate.latitude)
                let longtitude = String(location.coordinate.longitude)

                self.restaurantInfoManager.fetchRestaurant(lat: latitude, lng: longtitude)
            }
        }
    }
}
extension MainARViewController: RestaurantInfoDelegate {

    func manager(_ manager: RestaurantInfoManager, didFetch restaurants: [Restaurant]) {

        self.restaurants = restaurants

        for rest in restaurants {

            let coordinate = CLLocationCoordinate2D(latitude: rest.lat, longitude: rest.lng)
            let location = CLLocation(coordinate: coordinate, altitude: Double.random(in: 10...70))

            let nameLabel = UILabel(frame: CGRect(x: 10, y: 10, width: 150, height: 50))
            nameLabel.text = rest.name
            nameLabel.textColor = .white
            nameLabel.adjustsFontSizeToFitWidth = true

            let view = UIView()
            view.isOpaque = false
            view.frame = CGRect.init(x: 0, y: 0, width: 250, height: 100)
            view.layer.cornerRadius = 20
            view.clipsToBounds = true
            view.addSubview(nameLabel)
            view.backgroundColor = UIColor(r: 0, g: 0, b: 0, a: 0.7)
            view.layer.applySketchShadow()

            let annotaionNode = LocationAnnotationNode(location: location, view: view)

//            annotaionNode.scaleRelativeToDistance = true

            self.sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotaionNode)
            self.sceneLocationView.run()
        }

    }

    func manager(_ manager: RestaurantInfoManager, didFailed with: Error) {

    }
}

extension UIColor {

    // swiftlint:disable all
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: a)

    }
}

extension CALayer {
    func applySketchShadow(
        color: UIColor = .black,
        alpha: Float = 0.5,
        xPosition: CGFloat = 0,
        yPosition: CGFloat = 2,
        blur: CGFloat = 4,
        spread: CGFloat = 0) {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: xPosition, height: yPosition)
        shadowRadius = blur / 2.0
        if spread == 0 {
            shadowPath = nil
        } else {
            let dxValue = -spread
            let rect = bounds.insetBy(dx: dxValue, dy: dxValue)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
}
