//
//  RemoteRestaurantLoader.swift
//  ARFoodie
//
//  Created by Chen Yi-Wei on 2022/7/31.
//

import Foundation

public class RemoteRestaurantLoader: RestaurantLoader {
    public typealias Result = Swift.Result<[Restaurant], Error>

    private let client: HTTPClient
    private let baseURL: URL

    public init(baseURL: URL, client: HTTPClient) {
        self.client = client
        self.baseURL = baseURL
    }

    public enum Error: Swift.Error {
        case connectionError
        case invalidData
    }

    private var validStatusCodes: [Int] = .init(200...299)

    public func load(coordinate: Coordinate, completion: @escaping (RestaurantLoader.Result) -> Void) {
        let url = RestaurantEndpoint.get(from: coordinate).url(baseURL: baseURL)

        client.get(url: url) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case let .success((data, response)):
                do {
                    let items = try RestaurantMapper.map(data, response)
                    completion(.success(items))
                } catch {
                    completion(.failure(Error.invalidData))
                }
            case .failure:
                completion(.failure(Error.connectionError))
            }
        }
    }
}
