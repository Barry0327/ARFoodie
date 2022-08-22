//
//  Coordinate.swift
//  ARFoodie
//
//  Created by Chen Yi-Wei on 2022/8/18.
//

import Foundation

public struct Coordinate: Equatable {
    public let longitude: Double
    public let latitude: Double

    public init(longitude: Double, latitude: Double) {
        self.longitude = longitude
        self.latitude = latitude
    }
}
