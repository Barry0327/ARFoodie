//
//  RestaurantEndpoint.swift
//  ARFoodie
//
//  Created by Chen Yi-Wei on 2022/8/22.
//

import Foundation

public enum RestaurantEndpoint {
    case get(from: Coordinate)

    public func url(baseURL: URL) -> URL {
        switch self {
        case .get(let coordinate):
            var components = URLComponents()
            components.scheme = baseURL.scheme
            components.host = baseURL.host
            components.path = baseURL.path + "/nearbysearch/json"
            components.queryItems = [
                .init(name: "location", value: "\(coordinate.latitude),\(coordinate.longitude)"),
                .init(name: "rankby", value: "distance"),
                .init(name: "type", value: "restaurant"),
                .init(name: "language", value: "zh_TW"),
            ]
            return components.url!
        }
    }
}
