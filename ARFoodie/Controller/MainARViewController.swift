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
import ARKit

class MainARViewController: UIViewController, CLLocationManagerDelegate {

    var sceneLocationView = SceneLocationView()

    let restaurantInfoManager = RestaurantInfoManager.shared

    var restaurants: [Restaurant] = []

    let locationManager = CLLocationManager()

    var userCurrentLocation: CLLocation?

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

        print("run")
        self.sceneLocationView.run()

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)

        print("pause")
        self.sceneLocationView.pause()
    }

    // MARK: Core Location Delegate Method.
    /***********************************************************************/

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

                self.userCurrentLocation = location
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
            let location = CLLocation(coordinate: coordinate, altitude: Double.random(in: 0...60))

            let nameLabel = UILabel(frame: CGRect(x: 5, y: 5, width: 240, height: 30))
            nameLabel.text = rest.name
            nameLabel.textColor = .black
            nameLabel.font = UIFont.systemFont(ofSize: 20)
            nameLabel.adjustsFontSizeToFitWidth = true

            let ratingLabel = UILabel(frame: CGRect(x: 5, y: 35, width: 150, height: 30))
            ratingLabel.textColor = .black
            let rating: Double = rest.rating ?? 0
            let userRatingsTotal: Double = rest.userRatingsTotal ?? 0
            ratingLabel.text = "評價: \(rating) (\(Int(userRatingsTotal)))"
            ratingLabel.font = UIFont.systemFont(ofSize: 14)

            let restaurantLocation = CLLocation.init(latitude: rest.lat, longitude: rest.lng)
            let distance = self.userCurrentLocation?.distance(from: restaurantLocation)

            let distanceLabel = UILabel(frame: CGRect(x: 160, y: 35, width: 90, height: 30))
            distanceLabel.text = "\(String(format: "%.1f", distance!))m"
            distanceLabel.font = UIFont.systemFont(ofSize: 14)
            distanceLabel.textColor = UIColor(r: 79, g: 79, b: 79, a: 1)

            let view = ARView()
            view.isOpaque = false
            view.frame = CGRect.init(x: 0, y: 0, width: 250, height: 70)
            view.layer.cornerRadius = 20
            view.clipsToBounds = true
            view.backgroundColor = UIColor(r: 255, g: 255, b: 255, a: 0.7)
            view.layer.applySketchShadow()
            view.addSubview(nameLabel)
            view.addSubview(ratingLabel)
            view.addSubview(distanceLabel)
            view.placeID = rest.placeID

            let annotaionNode = LocationAnnotationNode(location: location, view: view)
//            annotaionNode.scaleRelativeToDistance = true
            annotaionNode.renderOnTop()

            self.sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotaionNode)
//            self.sceneLocationView.run()

        }

    }

    #warning("Add action when API requset failed")
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

extension SCNNode {
    func renderOnTop() {
        self.renderingOrder = 2
        if let geom = self.geometry {
            for material in geom.materials {
                material.readsFromDepthBuffer = false
            }
        }
        for child in self.childNodes {
            child.renderOnTop()
        }
    }
}
