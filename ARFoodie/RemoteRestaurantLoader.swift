//
//  RemoteRestaurantLoader.swift
//  ARFoodie
//
//  Created by Chen Yi-Wei on 2022/7/31.
//

import Foundation

public class RemoteRestaurantLoader: RestaurantLoader {
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

    public func load(completion: @escaping (RestaurantLoader.Result) -> Void) {
        client.get(url: url) { [weak self] result in
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
