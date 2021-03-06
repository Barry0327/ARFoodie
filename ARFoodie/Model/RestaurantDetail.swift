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
    let reviews: [Review]

    static func empty() -> RestaurantDetail {
        return .init(name: "", address: "", phoneNumber: nil, photo: nil, coordinate: .init(latitude: 125, longitude: 125), isOpening: nil, rating: nil, userRatingsTotal: nil, reviews: [])
    }

    struct Photo: Codable {
        let reference: String

        var url: URL? {
            var components = URLComponents()
            components.scheme = "https"
            components.host = "maps.googleapis.com"
            components.path = "/maps/api/place/photo"
            let queryItems: [URLQueryItem] = [
                URLQueryItem(name: "key", value: Secrets.apiKey),
                URLQueryItem(name: "photoreference", value: reference),
                URLQueryItem(name: "maxwidth", value: "100"),
                URLQueryItem(name: "maxheight", value: "80")
            ]
            components.queryItems = queryItems
            return components.url
        }
        // swiftlint:disable nesting
        private enum CodingKeys: String, CodingKey {
            case reference = "photo_reference"
        }
    }

    struct Review: Codable {
        let authorName: String
        let authorPhotoURLString: String?
        let rating: Double
        let relativeTimeDescription: String
        let text: String

        private enum CodingKeys: String, CodingKey {
            case authorName = "author_name"
            case authorPhotoURLString = "profile_photo_url"
            case rating
            case relativeTimeDescription = "relative_time_description"
            case text
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
        case reviews
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

        reviews = try container.decodeIfPresent([Review].self, forKey: .reviews) ?? []
    }
}
