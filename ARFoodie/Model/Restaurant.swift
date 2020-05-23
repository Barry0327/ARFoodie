//
//  Restaurant.swift
//  ARFoodie
//
//  Created by Chen Yi-Wei on 2019/3/28.
//  Copyright © 2019 Chen Yi-Wei. All rights reserved.
//

import Foundation

struct Restaurant: Codable {

    let placeID: String
    let name: String
    let lat: Double
    let lng: Double
    let rating: Double?
    let userRatingsTotal: Double?

    enum RootKey: String, CodingKey {
        case results
    }

    enum RestaurantKey: String, CodingKey {
        case geometry, name, placdID, rating, userRatingsTotal
    }

    enum Location: String, CodingKey {
        case location
    }

    enum LatAndLng: String, CodingKey {
        case lat, lng
    }

}

extension Restaurant {
    init(from decoder: Decoder) throws {

        let value = try decoder.container(keyedBy: RootKey.self)
        let resultsContainer = try value.nestedContainer(keyedBy: RestaurantKey.self, forKey: .results)
        placeID = try resultsContainer.decode(String.self, forKey: .placdID)
        name = try resultsContainer.decode(String.self, forKey: .name)
        rating = try resultsContainer.decode(Double.self, forKey: .rating)
        userRatingsTotal = try resultsContainer.decode(Double.self, forKey: .userRatingsTotal)
        let locationContainer = try resultsContainer.nestedContainer(keyedBy: Location.self, forKey: .geometry)
        let latLngContainer = try locationContainer.nestedContainer(keyedBy: LatAndLng.self, forKey: .location)
        lng = try latLngContainer.decode(Double.self, forKey: .lng)
        lat = try latLngContainer.decode(Double.self, forKey: .lat)
    }
}
