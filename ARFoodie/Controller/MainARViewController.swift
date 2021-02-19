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
import Firebase
import TransitionButton
import Cosmos

class MainARViewController: UIViewController, CLLocationManagerDelegate {

    let firebaseManager = FirebaseManager()

    var sceneLocationView = SceneLocationView()

    let restaurantInfoManager = RestaurantInfoManager()

    var restaurants: [Restaurant] = []

    let locationManager = CLLocationManager()

    var userCurrentLocation: CLLocation?

    var adjustedHeight: Double = 5

    lazy var searchRestaurantsBTN: TransitionButton = {

        let button = TransitionButton()

        button.backgroundColor = UIColor.flatWatermelonColorDark()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.cornerRadius = 25
        button.addTarget(self, action: #selector(searchBTNTapped), for: .touchUpInside)
        let textAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: UIColor(hexString: "E4DAD8")!,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 25, weight: .bold)
        ]
        let attributeString = NSAttributedString(string: "找美食", attributes: textAttributes)
        button.setAttributedTitle(attributeString, for: .normal)
        button.spinnerColor = UIColor(hexString: "feffdf")!

        return button
    }()

// MARK: - ViewDidLoad Method

    override func viewDidLoad() {
        super.viewDidLoad()

        firebaseManager.fetchUserInfo()

        self.restaurantInfoManager.delegate = self

        view.addSubview(self.sceneLocationView)
        view.addSubview(searchRestaurantsBTN)
        self.setSearchButton()

        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.locationTapped(tapRecognizer:)))

        sceneLocationView.addGestureRecognizer(tapRecognizer)
        sceneLocationView.isUserInteractionEnabled = true

    }

    func setSearchButton() {

        searchRestaurantsBTN.widthAnchor.constraint(equalToConstant: 180).isActive = true
        searchRestaurantsBTN.heightAnchor.constraint(equalToConstant: 50).isActive = true
        searchRestaurantsBTN.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        searchRestaurantsBTN.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }

    @objc func searchBTNTapped() {

        self.searchRestaurantsBTN.startAnimation()
        self.sceneLocationView.removeAllNodes()
        self.adjustedHeight = 5
        self.startReceivingLocationChanges()

    }

    @objc func locationTapped(tapRecognizer: UITapGestureRecognizer) {

        if tapRecognizer.state == UIGestureRecognizer.State.ended {

            let location: CGPoint = tapRecognizer.location(in: self.sceneLocationView)

            let hits = self.sceneLocationView.hitTest(location, options: nil)

            guard let hit = hits.first?.node as? AnnotationNode else {
                print("Faield to get node")
                return
            }

            self.locationNodeTouched(node: hit)

        }

    }

    func locationNodeTouched(node: AnnotationNode) {

        // node could have either node.view or node.image
        if let nodeImage = node.image {

            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)

            guard
                let detailVC = storyboard.instantiateViewController(
                    withIdentifier: "DetailViewController"
                    ) as? DetailViewController
                else { fatalError("Please check the ID for DetailTableViewController")}

            detailVC.placeID = nodeImage.accessibilityIdentifier ?? ""

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

    // MARK: - Core Location Delegate Method.

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

                self.locationManager.delegate = nil

                self.locationManager.stopUpdatingLocation()

                let latitude = String(location.coordinate.latitude)
                let longtitude = String(location.coordinate.longitude)

                self.restaurantInfoManager.fetchRestaurant(lat: latitude, lng: longtitude)

            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {

        AuthenticationError.locationError.alert(message: error.localizedDescription)

    }

}

// MARK: - RestaurantInfoDelegate Method

extension MainARViewController: RestaurantInfoDelegate {

    func manager(_ manager: RestaurantInfoManager, didFetch restaurants: [Restaurant]) {

        self.restaurants = restaurants

        for rest in restaurants {

            let view = generateViewWith(rest: rest)

            let image = view.asImage()
            image.accessibilityIdentifier = rest.placeID

            let coordinate = CLLocationCoordinate2D(latitude: rest.lat, longitude: rest.lng)
            let location = CLLocation(coordinate: coordinate, altitude: adjustedHeight)
            self.adjustedHeight += 3
            print(adjustedHeight)

            let annotaionNode = LocationAnnotationNode(location: location, image: image)

            annotaionNode.continuallyAdjustNodePositionWhenWithinRange = false
            annotaionNode.continuallyUpdatePositionAndScale = false

            annotaionNode.renderOnTop()

            self.sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotaionNode)

        }
        DispatchQueue.main.async { [weak self] in

            guard let self = self else { return }

            self.searchRestaurantsBTN.stopAnimation()
        }
    }

    func manager(_ manager: RestaurantInfoManager, didFailed with: Error) {

        let alert = UIAlertController(title: "連線失敗", message: "連線有問題，請檢查網路連線", preferredStyle: .alert)

        let action = UIAlertAction(title: "OK", style: .cancel)

        alert.addAction(action)

    }

    private func generateViewWith(rest: Restaurant) -> UIView {

        let nameLabel = UILabel(frame: CGRect(x: 5, y: 5, width: 230, height: 30))
        nameLabel.text = rest.name
        nameLabel.textColor = .black
        nameLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        nameLabel.adjustsFontSizeToFitWidth = true

        let rating: Double = rest.rating ?? 0
        let userRatingsTotal: Double = rest.userRatingsTotal ?? 0

        let ratingView = CosmosView(frame: CGRect(x: 5, y: 35, width: 150, height: 30))
        ratingView.settings.updateOnTouch = false
        ratingView.settings.starSize = 16
        ratingView.settings.starMargin = 1
        ratingView.settings.fillMode = .half
        ratingView.settings.filledColor = UIColor.flatWatermelonColorDark()
        ratingView.settings.filledBorderColor = UIColor.flatWatermelonColorDark()
        ratingView.settings.emptyBorderColor = UIColor.flatWatermelonColorDark()
        ratingView.rating = rating
        ratingView.text = String(format: "%.0f", userRatingsTotal)

        let restaurantLocation = CLLocation.init(latitude: rest.lat, longitude: rest.lng)
        let distance = self.userCurrentLocation?.distance(from: restaurantLocation)

        let distanceLabel = UILabel(frame: CGRect(x: 160, y: 30, width: 90, height: 30))
        distanceLabel.text = "\(String(format: "%.1f", distance!))m"
        distanceLabel.font = UIFont.systemFont(ofSize: 14)
        distanceLabel.textColor = UIColor(r: 79, g: 79, b: 79, a: 1)

        let view = UIView()
        view.isOpaque = false
        view.frame = CGRect.init(x: 0, y: 0, width: 240, height: 70)
        view.backgroundColor = UIColor(hexString: "F2EDEC")
        view.alpha = 0.7
        view.layer.applySketchShadow()
        view.addSubview(nameLabel)
        view.addSubview(ratingView)
        view.addSubview(distanceLabel)

        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 240, height: 60), cornerRadius: 5)
        path.move(to: CGPoint(x: 115, y: 60))
        path.addLine(to: CGPoint(x: 125, y: 70))
        path.addLine(to: CGPoint(x: 135, y: 60))
        path.close()

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath

        view.layer.mask = shapeLayer

        return view
    }
}
