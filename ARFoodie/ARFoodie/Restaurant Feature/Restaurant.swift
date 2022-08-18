//
//  Restaurant.swift
//  ARFoodie
//
//  Created by Chen Yi-Wei on 2022/7/30.
//

import Foundation

public struct Restaurant: Equatable {
    public let id: String
    public let name: String
    public let coordinate: Coordinate
    public let rating: Double?
    public let userRatingsTotal: Double?

    public init(id: String, name: String, coordinate: Coordinate, rating: Double?, userRatingsTotal: Double?) {
        self.id = id
        self.name = name
        self.coordinate = coordinate
        self.rating = rating
        self.userRatingsTotal = userRatingsTotal
    }
}
