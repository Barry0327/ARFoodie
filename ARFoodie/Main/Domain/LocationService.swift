//
//  LocationService.swift
//  ARFoodie
//
//  Created by Chen Yi-Wei on 2021/4/10.
//  Copyright © 2021 Chen Yi-Wei. All rights reserved.
//

import Foundation
import RxRelay
import CoreLocation.CLLocation

protocol LocationService {
    var coordinate: PublishRelay<Coordinate> { get }
    var locationError: PublishRelay<Error> { get }
    var currentLocation: CLLocation? { get }
    func getCurrentLocation()
}
