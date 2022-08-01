//
//  RemoteRestaurantLoader.swift
//  ARFoodie
//
//  Created by Chen Yi-Wei on 2022/7/31.
//

import Foundation

public class RemoteRestaurantLoader {
    public typealias Result = Swift.Result<[Restaurant], Error>

    private let url: URL
    private let client: HTTPClient

    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }

    public enum Error: Swift.Error {
        case connectionError
        case invalidData
    }

    private var validStatusCodes: [Int] = .init(200...299)

    public func load(completion: @escaping (Result) -> Void) {
        client.get(url: url) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success((data, response)):
                guard self.validStatusCodes.contains(response.statusCode) else {
                    completion(.failure(.invalidData))
                    return
                }
                let decoder = JSONDecoder()
                if let items = try? decoder.decode(Root.self, from: data).items {
                    completion(.success(items))
                }
                else {
                    completion(.failure(.invalidData))
                }
            case .failure:
                completion(.failure(.connectionError))
            }
        }
    }
}

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
        .init(id: place_id, name: name, latitude: geometry.location.lat, longitude: geometry.location.lng, rating: rating, userRatingsTotal: user_ratings_total)
    }
}
