//
//  Restaurant.swift
//  ARFoodie
//
//  Created by Chen Yi-Wei on 2022/7/30.
//

import Foundation

public struct Restaurant {
    public let id: String
    public let name: String
    public let latitude: Double
    public let longitude: Double
    public let rating: Double?
    public let userRatingsTotal: Double?

    public init(id: String, name: String, latitude: Double, longitude: Double, rating: Double?, userRatingsTotal: Double?) {
        self.id = id
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.rating = rating
        self.userRatingsTotal = userRatingsTotal
    }
}
