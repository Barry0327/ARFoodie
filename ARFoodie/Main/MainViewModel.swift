//
//  MainViewModel.swift
//  ARFoodie
//
//  Created by Barry Chen on 2021/3/31.
//  Copyright © 2021 Chen Yi-Wei. All rights reserved.
//

import Foundation
import CoreLocation
import RxRelay
import RxSwift

final class MainViewModel: NSObject {
    let locationManager = CLLocationManager()
    let placesService: PlacesService

    let bag: DisposeBag = DisposeBag()
    var currentLocation: CLLocation?
    let searchButtonAnimating: BehaviorRelay<Bool> = .init(value: false)
    let restaurants: BehaviorRelay<[Restaurant]> = .init(value: [])
    let selectedPlaceID: PublishRelay<String> = .init()
    let error: PublishRelay<Error> = .init()

    init(placesService: PlacesService) {
        self.placesService = placesService
    }

    func searchRestaurants() {
        searchButtonAnimating.accept(true)
        startReceivingLocationChanges()
    }

    func startReceivingLocationChanges() {
        self.locationManager.requestWhenInUseAuthorization()
        let authorizationStatus = locationManager.authorizationStatus
        if authorizationStatus != .authorizedWhenInUse && !CLLocationManager.locationServicesEnabled() {
            return
        }

        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }

    func searchPlaces(with coordinate: Coordinate) {
        placesService.nearbyRestaurants(coordinate: coordinate)
            .subscribe(on: MainScheduler.instance)
            .subscribe { [unowned self] in
                switch $0 {
                case .success(let restaurants):
                    self.restaurants.accept(restaurants)
                case .failure(let error):
                    self.error.accept(error)
                }
            }
            .disposed(by: bag)
    }
}
// MARK: - Location manager delegate
extension MainViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        guard let location = locations.last,
              location.horizontalAccuracy > 0
        else { return }

        currentLocation = location
        self.locationManager.delegate = nil
        self.locationManager.stopUpdatingLocation()

        let latitude = String(location.coordinate.latitude)
        let longtitude = String(location.coordinate.longitude)
        let coordinate: Coordinate = (latitude, longtitude)

        searchPlaces(with: coordinate)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.error.accept(error)
    }
}
