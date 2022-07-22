//
//  LocationManager.swift
//  ARFoodie
//
//  Created by Chen Yi-Wei on 2021/4/10.
//  Copyright © 2021 Chen Yi-Wei. All rights reserved.
//

import Foundation
import CoreLocation
import RxRelay

final class LocationManager: NSObject, LocationService {
    let coordinate: PublishRelay<Coordinate> = .init()
    let locationError: PublishRelay<Error> = .init()
    var currentLocation: CLLocation?

    private let locationManager: CLLocationManager = CLLocationManager()

    override init() {
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func getCurrentLocation() {
        self.locationManager.requestWhenInUseAuthorization()
        let authorizationStatus = locationManager.authorizationStatus

        guard
            authorizationStatus == .authorizedWhenInUse,
            CLLocationManager.locationServicesEnabled()
        else {
            return
        }
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last,
              location.horizontalAccuracy > 0
        else { return }

        currentLocation = location
        locationManager.delegate = nil
        locationManager.stopUpdatingLocation()

        let latitude = String(location.coordinate.latitude)
        let longtitude = String(location.coordinate.longitude)
        let coordinate: Coordinate = (latitude, longtitude)
        self.coordinate.accept(coordinate)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationError.accept(error)
    }
}
