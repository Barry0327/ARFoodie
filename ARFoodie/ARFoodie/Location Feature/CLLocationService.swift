//
//  CLLocationService.swift
//  ARFoodie
//
//  Created by Chen Yi-Wei on 2022/8/22.
//

import Foundation
import CoreLocation

public final class CLLocationService: NSObject, CoordinateLoader {
    private(set) lazy var manager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        return manager
    }()

    private var completion: CoordinateLoader.Completion?

    public enum Error: Swift.Error {
        case notAuthorized
        case invalidLocation
    }

    func loadCoordinate(completion: @escaping CoordinateLoader.Completion) {
        let authorizationStatus = manager.authorizationStatus
        #if os(macOS)
        guard authorizationStatus == .authorizedAlways else {
            return completion(.failure(Error.notAuthorized))
        }
        #endif

        #if os(iOS)
        guard authorizationStatus == .authorizedWhenInUse else {
            return completion(.failure(Error.notAuthorized))
        }
        #endif

        self.completion = completion
        manager.requestLocation()
    }
}
extension CLLocationService: CLLocationManagerDelegate {
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        default: return
        }
    }

    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last,
              location.horizontalAccuracy > 0
        else {
            completion?(.failure(Error.invalidLocation))
            return completion = nil
        }

        let coordinate = Coordinate(
            longitude: location.coordinate.longitude,
            latitude: location.coordinate.latitude
        )
        completion?(.success(coordinate))
        completion = nil
    }

}
