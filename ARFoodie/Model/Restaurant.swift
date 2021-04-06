//
//  Restaurant.swift
//  ARFoodie
//
//  Created by Chen Yi-Wei on 2019/3/28.
//  Copyright © 2019 Chen Yi-Wei. All rights reserved.
//

import Foundation
import CoreLocation

struct Restaurant {
    let placeID: String
    let name: String
    let lat: Double
    let lng: Double
    let rating: Double?
    let userRatingsTotal: Double?

    var location: CLLocation {
        return CLLocation(latitude: lat, longitude: lng)
    }

    private enum CodingKeys: String, CodingKey {
        case geometry, name, placeID = "place_id", rating, userRatingsTotal = "user_ratings_total"
    }

    private enum Location: String, CodingKey {
        case location
    }

    private enum LatAndLng: String, CodingKey {
        case lat, lng
    }

}

extension Restaurant: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        placeID = try container.decode(String.self, forKey: .placeID)
        name = try container.decode(String.self, forKey: .name)
        rating = try container.decodeIfPresent(Double.self, forKey: .rating)
        userRatingsTotal = try container.decodeIfPresent(Double.self, forKey: .userRatingsTotal)

        let locationContainer = try container.nestedContainer(keyedBy: Location.self, forKey: .geometry)
        let latLngContainer = try locationContainer.nestedContainer(keyedBy: LatAndLng.self, forKey: .location)
        lng = try latLngContainer.decode(Double.self, forKey: .lng)
        lat = try latLngContainer.decode(Double.self, forKey: .lat)
    }
}
