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

    var adjustedHeight: Double = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        self.startReceivingLocationChanges()

        self.restaurantInfoManager.delegate = self

        view.addSubview(self.sceneLocationView)

        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.locationTapped(tapRecognizer:)))

        sceneLocationView.addGestureRecognizer(tapRecognizer)
        sceneLocationView.isUserInteractionEnabled = true

    }
    @objc func locationTapped(tapRecognizer: UITapGestureRecognizer) {
        if tapRecognizer.state == UIGestureRecognizer.State.ended {
            let sceneView = sceneLocationView as SCNView
            let hits = sceneView.hitTest(tapRecognizer.location(in: tapRecognizer.view), options: nil) as [SCNHitTestResult]
            guard let hit = hits.first?.node.parent else { return }
            print(hit)
            guard let node = hit as? LocationAnnotationNode else {
                print("Failed")
                return
            }
            print(node)
            guard let node2 = node.childNodes.first else {
                print("GG")
                return
            }
            guard let node3 = node2 as? AnnotationNode else {
                print("GGG")
                return
            }
            self.locationNodeTouched(node: node3)

        }

    }
    func locationNodeTouched(node: AnnotationNode) {
        // Do stuffs with the node instance

        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)

        guard
            let detailVC = storyboard.instantiateViewController(
                withIdentifier: "DetailTableViewController"
                ) as? DetailTableViewController
            else { fatalError("Please check the ID for DetailTableViewController")}

        let navigationCTL = UINavigationController(rootViewController: detailVC)

        self.sceneLocationView.pause()

        self.sceneLocationView.removeFromSuperview()

        self.present(navigationCTL, animated: true, completion: nil)

        // node could have either node.view or node.image
        if let nodeImage = node.image {

            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)

            guard
                let detailVC = storyboard.instantiateViewController(
                    withIdentifier: "DetailTableViewController"
                    ) as? DetailTableViewController
                else { fatalError("Please check the ID for DetailTableViewController")}

            detailVC.placeID = nodeImage.accessibilityIdentifier

            let navigationCTL = UINavigationController(rootViewController: detailVC)

            self.present(navigationCTL, animated: true, completion: nil)
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.sceneLocationView.frame = view.bounds
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.setNavigationBarHidden(true, animated: true)

        print("run")
        self.sceneLocationView.run()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.setNavigationBarHidden(false, animated: true)

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

            let view = UIView()
            view.isOpaque = false
            view.frame = CGRect.init(x: 0, y: 0, width: 250, height: 70)
            view.backgroundColor = UIColor(r: 255, g: 255, b: 255, a: 0.7)
            view.layer.applySketchShadow()
            view.addSubview(nameLabel)
            view.addSubview(ratingLabel)
            view.addSubview(distanceLabel)

            let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 250, height: 60), cornerRadius: 5)
            path.move(to: CGPoint(x: 115, y: 60))
            path.addLine(to: CGPoint(x: 125, y: 70))
            path.addLine(to: CGPoint(x: 135, y: 60))
            path.close()

            let shapeLayer = CAShapeLayer()
            shapeLayer.path = path.cgPath

            view.layer.mask = shapeLayer

            let image = view.asImage()
            image.accessibilityIdentifier = rest.placeID

            let distanceInDouble: Double = Double(exactly: distance ?? 0) ?? 0
            print(distanceInDouble)

            let coordinate = CLLocationCoordinate2D(latitude: rest.lat, longitude: rest.lng)
            let location = CLLocation(coordinate: coordinate, altitude: adjustedHeight)
            self.adjustedHeight += 3
            print(adjustedHeight)

            let annotaionNode = LocationAnnotationNode(location: location, view: view)

            annotaionNode.renderOnTop()

            self.sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotaionNode)

        }
    }
    #warning("Add action when API requset failed")
    func manager(_ manager: RestaurantInfoManager, didFailed with: Error) {

    }
}
