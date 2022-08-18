//
//  RestaurantMapper.swift
//  ARFoodie
//
//  Created by Chen Yi-Wei on 2022/8/2.
//

import Foundation

enum RestaurantMapper {
    private struct Root: Decodable {
        let results: [RemoteRestaurant]

        var items: [Restaurant] {
            results.map { $0.restaurant }
        }
    }

    private struct RemoteRestaurant: Decodable {
        struct Location: Decodable {
            let lat: Double
            let lng: Double
        }
        struct Geometry: Decodable {
            let location: Location
        }
        let place_id: String
        let name: String
        let geometry: Geometry
        let rating: Double?
        let user_ratings_total: Double?

        var restaurant: Restaurant {
            .init(
                id: place_id,
                name: name,
                coordinate: .init(longitude: geometry.location.lng, latitude: geometry.location.lat),
                rating: rating,
                userRatingsTotal: user_ratings_total
            )
        }
    }

    public enum Error: Swift.Error {
        case invalidData
    }

    private static var validStatusCodes: [Int] { .init(200...299) }

    static func map(_ data: Data, _ response: HTTPURLResponse) throws -> [Restaurant] {
        guard validStatusCodes.contains(response.statusCode) else {
            throw Error.invalidData
        }

        let decoder = JSONDecoder()
        let items = try decoder.decode(Root.self, from: data).items
        return items
    }
}
