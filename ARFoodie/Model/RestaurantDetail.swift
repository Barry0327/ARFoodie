//
//  RestaurantDetail.swift
//  ARFoodie
//
//  Created by Chen Yi-Wei on 2019/4/2.
//  Copyright © 2019 Chen Yi-Wei. All rights reserved.
//

import Foundation
import MapKit

struct RestaurantDetail {
    let name: String
    let address: String
    let phoneNumber: String?
    let photo: Photo?
    let coordinate: CLLocationCoordinate2D
    let isOpening: Bool?
    let rating: Double?
    let userRatingsTotal: Double?

    struct Photo: Codable {
        let reference: String

        // swiftlint:disable nesting
        private enum CodingKeys: String, CodingKey {
            case reference = "photo_reference"
        }
    }

    private enum CodingKeys: String, CodingKey {
        case name
        case address = "formatted_address"
        case phoneNumber = "formatted_phone_number"
        case photos
        case geometry
        case openingHours = "opening_hours"
        case rating
        case userRaingsTotal = "user_ratings_total"
    }

    private enum PhotosKeys: String, CodingKey {
        case photoReference = "photo_reference"
    }

    private enum GeometryKeys: String, CodingKey {
        case location
    }

    private enum LocationKeys: String, CodingKey {
        case lat, lng
    }

    private enum OpeningHoursKeys: String, CodingKey {
        case openNow = "open_now"
    }
}

extension RestaurantDetail: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        address = try container.decode(String.self, forKey: .address)
        phoneNumber = try container.decodeIfPresent(String.self, forKey: .phoneNumber)
        rating = try container.decodeIfPresent(Double.self, forKey: .rating)
        userRatingsTotal = try container.decodeIfPresent(Double.self, forKey: .userRaingsTotal)

        let photos = try container.decodeIfPresent([Photo].self, forKey: .photos)
        photo = photos?.first

        let geometryContainer = try container.nestedContainer(keyedBy: GeometryKeys.self, forKey: .geometry)
        let locationContainer = try geometryContainer.nestedContainer(keyedBy: LocationKeys.self, forKey: .location)
        let lat = try locationContainer.decode(Double.self, forKey: .lat)
        let lng = try locationContainer.decode(Double.self, forKey: .lng)
        coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)

        if let openingHoursContinaer = try? container.nestedContainer(keyedBy: OpeningHoursKeys.self, forKey: .openingHours) {
            isOpening = try openingHoursContinaer.decodeIfPresent(Bool.self, forKey: .openNow)
        } else {
            isOpening = nil
        }
    }
}
